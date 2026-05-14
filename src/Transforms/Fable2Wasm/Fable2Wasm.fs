/// Fable AST → WasmGc IR translation.
module WasmGc.Transforms.Fable2Wasm

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST

open WasmGc.Runtime.Locals

open WasmGc.Runtime.Types
module RT = WasmGc.Runtime.Runtime
module VT = WasmGc.Runtime.VTable
module Val = WasmGc.Pipeline.Validator
module BclReg = WasmGc.Bcl.Registry

open TransformMemberDecl
open TransformExpr

// ─────────────────────────────────────────────────────────────────
// Top-Level Declarations
// Declaration processing — top-level so it can be shared across files
// ─────────────────────────────────────────────────────────────────

/// Pre-scan all declarations and register MemberDecl bodies in ctx.GenericFuncRegistry.
/// Enables demand-driven specialization in trySpecializeCall without a two-pass pipeline.
let private preScanGenerics (ctx: Ctx) (decls: Declaration list) : unit =
    let rec scan decl =
        match decl with
        | MemberDeclaration m ->
            ctx.GenericFuncRegistry.[m.Name] <- (ctx.Compiler, m :> obj)
        | ModuleDeclaration md ->
            md.Members |> List.iter scan
        | ClassDeclaration cd ->
            cd.AttachedMembers |> List.iter (fun m ->
                ctx.GenericFuncRegistry.[m.Name] <- (ctx.Compiler, m :> obj))
        | ActionDeclaration _ -> ()
    decls |> List.iter scan


/// Process one Fable declaration into the shared ctx (mutates ctx.TypeDefs/Functions).
/// Returns the updated immutable record (KnownFuncs accumulates across declarations).
let rec processDecl (ctx: Ctx) (decl: Declaration) : Ctx =
    match decl with
    | MemberDeclaration memberDecl ->
        let func = transformMemberDecl ctx transformExpr memberDecl |> resolveLocals
        let shortName = func.Name
        // In library context, use module-qualified name (e.g. MapModule_add).
        // FuncNameAlias was pre-populated in ModuleDeclaration so recursive calls resolve correctly.
        let qualifiedName = ctx.FuncNameAlias |> Map.tryFind shortName |> Option.defaultValue shortName
        let isLibFunc = qualifiedName <> shortName
        let func = { func with
                        Name = qualifiedName
                        // Library functions are internal — only last-file functions are exported.
                        Exported = if isLibFunc then false else func.Exported }
        ctx.Functions.Add(func)
        let paramTypes = func.Params |> List.map snd
        let kf = ctx.KnownFuncs |> Map.add qualifiedName (paramTypes, func.Result)
        // Register for cross-file import dispatch: (fileStem, shortSelector) → qualifiedName
        // Also register (fileStem, qualifiedName) → qualifiedName to handle cases where Fable
        // uses the fully-qualified name as the import selector (e.g. class constructors:
        // "ArgumentException_$ctor_Z384F8060" rather than "$ctor_Z384F8060").
        let kfByPath =
            if isLibFunc then
                ctx.KnownFuncsByPath
                |> Map.add (ctx.CurrentFileStem, shortName) qualifiedName
                |> Map.add (ctx.CurrentFileStem, qualifiedName) qualifiedName
            else
                ctx.KnownFuncsByPath
        { ctx with KnownFuncs = kf; KnownFuncsByPath = kfByPath }
    | ActionDeclaration action ->
        let wBody = transformExpr ctx action.Body
        let func : WFuncDecl =
            { Name = "$init"; Params = []; Result = WType.Void; Locals = []; Body = wBody; Exported = false }
        ctx.Functions.Add(func |> resolveLocals)
        ctx
    | ModuleDeclaration modDecl ->
        // Recurse into nested module declarations (library pre-scan is done in processFileIntoCtx).
        (ctx, modDecl.Members) ||> List.fold processDecl
    | ClassDeclaration classDecl ->
        let ent = ctx.Compiler.GetEntity(classDecl.Entity)
        if ent.IsFSharpRecord then
            let typeIdx = ctx.TypeDefs.Count
            let ctx' = ctx.WithTypeEntry(classDecl.Entity.FullName, typeIdx)
            let fields =
                ent.FSharpFields
                |> List.map (fun f ->
                    { Name = f.Name; Type = mapTypeKnown ctx' f.FieldType; Mutable = f.IsMutable })
            ctx.TypeDefs.Add({ Name = classDecl.Entity.FullName; Def = WTypeDef.Struct(fields, None) })
            let ctx'' =
                (ctx', classDecl.AttachedMembers)
                ||> List.fold (fun c m ->
                    let func = transformMemberDecl c transformExpr m |> resolveLocals
                    // Interface implementations are internals — accessed via vtable wrappers.
                    // Qualify the name with the declaring type to avoid duplicate Wasm function
                    // names when multiple types implement the same interface method name.
                    let func =
                        if m.ImplementedSignatureRef.IsSome then
                            let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                            { func with Name = qualName; Exported = false }
                        else func
                    c.Functions.Add(func); c)
            // ── Vtable wiring for interface implementations ──────────────
            // Find all members that implement an interface method.
            let ifaceImpls =
                classDecl.AttachedMembers
                |> List.choose (fun m ->
                    match m.ImplementedSignatureRef with
                    | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)) ->
                        // The compiled function was qualified: TypeFullName_MethodName
                        let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                        match ctx''.Functions |> Seq.tryFindBack (fun f -> f.Name = qualName) with
                        | Some func ->
                            Some(ifaceEntityRef.FullName, ifaceMemberInfo.CompiledName,
                                 qualName, func.Params |> List.map snd, func.Result)
                        | None -> None
                    | _ -> None)
            // Group by interface full name.
            let byIface = ifaceImpls |> List.groupBy (fun (ifaceName, _, _, _, _) -> ifaceName)
            for (ifaceName, methods) in byIface do
                // Collect method signatures for interface registration.
                // We need the non-self param types: skip the first param (concrete self).
                let methodSigs =
                    methods |> List.map (fun (_, methodName, _, compiledParams, retType) ->
                        let nonSelfParams = match compiledParams with _ :: rest -> rest | [] -> []
                        methodName, nonSelfParams, retType)
                let vtableTypeIdx, boxTypeIdx = VT.getOrRegisterInterface ctx'' ifaceName methodSigs
                let _, _, funcTypeIndices, _ = ctx''.VTableRegistry.[ifaceName]
                let methodImpls =
                    methods |> List.map (fun (_, methodName, compiledFunc, compiledParams, retType) ->
                        methodName, compiledFunc, compiledParams, retType)
                VT.registerVTableImpl ctx'' classDecl.Entity.FullName typeIdx
                    ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodImpls
            ctx''
        elif ent.IsFSharpUnion then
            let cases = ent.UnionCases
            let isEnumLike = cases |> List.forall (fun c -> c.UnionCaseFields.IsEmpty)
            if isEnumLike then ctx
            else
                let baseIdx = ctx.TypeDefs.Count
                let ctx' = ctx.WithTypeEntry(classDecl.Entity.FullName, baseIdx)
                let ctx'' =
                    [ 0 .. cases.Length - 1 ]
                    |> List.fold (fun (c: Ctx) i ->
                        c.WithTypeEntry($"{classDecl.Entity.FullName}#{i}", baseIdx + 1 + i)) ctx'
                ctx.TypeDefs.Add(
                    { Name = classDecl.Entity.FullName
                      Def = WTypeDef.Struct([{ Name = "tag"; Type = WType.I32; Mutable = false }], None) })
                cases |> List.iteri (fun i case ->
                    let dataFields =
                        case.UnionCaseFields
                        |> List.map (fun f ->
                            { Name = f.Name; Type = mapTypeKnown ctx'' f.FieldType; Mutable = false })
                        |> List.filter (fun f -> f.Type <> WType.Void)
                    ctx.TypeDefs.Add(
                        { Name = $"{classDecl.Entity.FullName}#{i}"
                          Def = WTypeDef.Struct(
                                { Name = "tag"; Type = WType.I32; Mutable = false } :: dataFields,
                                Some baseIdx) }))
                (ctx'', classDecl.AttachedMembers)
                ||> List.fold (fun c m ->
                    let func = transformMemberDecl c transformExpr m |> resolveLocals
                    let func =
                        if m.ImplementedSignatureRef.IsSome then
                            let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                            { func with Name = qualName; Exported = false }
                        else func
                    c.Functions.Add(func); c)
                |> (fun ctx3 ->
                    // ── Vtable wiring for DU interface implementations ──────────
                    let ifaceImpls =
                        classDecl.AttachedMembers
                        |> List.choose (fun m ->
                            match m.ImplementedSignatureRef with
                            | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)) ->
                                let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                                match ctx3.Functions |> Seq.tryFindBack (fun f -> f.Name = qualName) with
                                | Some func ->
                                    Some(ifaceEntityRef.FullName, ifaceMemberInfo.CompiledName,
                                         qualName, func.Params |> List.map snd, func.Result)
                                | None -> None
                            | _ -> None)
                    let byIface = ifaceImpls |> List.groupBy (fun (ifaceName, _, _, _, _) -> ifaceName)
                    for (ifaceName, methods) in byIface do
                        let methodSigs =
                            methods |> List.map (fun (_, methodName, _, compiledParams, retType) ->
                                let nonSelfParams = match compiledParams with _ :: rest -> rest | [] -> []
                                methodName, nonSelfParams, retType)
                        let vtableTypeIdx, boxTypeIdx = VT.getOrRegisterInterface ctx3 ifaceName methodSigs
                        let _, _, funcTypeIndices, _ = ctx3.VTableRegistry.[ifaceName]
                        let methodImpls =
                            methods |> List.map (fun (_, methodName, compiledFunc, compiledParams, retType) ->
                                methodName, compiledFunc, compiledParams, retType)
                        VT.registerVTableImpl ctx3 classDecl.Entity.FullName baseIdx
                            ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodImpls
                    ctx3)
        else
            // Regular class, abstract class, or interface declaration.
            // Interface declarations have no fields or implementations to emit.
            if ent.IsInterface then ctx
            else
                // ── Resolve parent type for struct subtyping ─────────────────────────────
                // WasmGC requires ALL fields (including inherited) to be declared in the
                // subtype, with the parent's fields appearing first (prefix layout).
                let typeIdx = ctx.TypeDefs.Count
                let ctx' = ctx.WithTypeEntry(classDecl.Entity.FullName, typeIdx)

                // Look up parent struct (skip System.Object / System.Exception from BCL)
                let parentStructInfo =
                    match ent.BaseType with
                    | Some baseT ->
                        let parentName = baseT.Entity.FullName
                        // Use ctx (NOT ctx') so we don't find our own self-registered index
                        // which was added to ctx' before TypeDefs.Add has run.
                        match Map.tryFind parentName ctx.TypeRegistry with
                        | Some parentIdx when parentIdx < ctx.TypeDefs.Count ->
                            match ctx.TypeDefs.[parentIdx].Def with
                            | WTypeDef.Struct(parentFields, _) -> Some(parentIdx, parentFields)
                            | _ -> None
                        | _ -> None
                    | None -> None

                // Child's own fields declared in this class body
                let ownFields =
                    ent.FSharpFields
                    |> List.map (fun f ->
                        { Name = f.Name; Type = mapTypeKnown ctx' f.FieldType; Mutable = f.IsMutable })

                // Flattened layout: parent prefix fields + own new fields
                let allFields, superTypeOpt =
                    match parentStructInfo with
                    | Some(parentIdx, parentFields) -> parentFields @ ownFields, Some parentIdx
                    | None -> ownFields, None

                ctx.TypeDefs.Add({ Name = classDecl.Entity.FullName; Def = WTypeDef.Struct(allFields, superTypeOpt) })
                // ── Synthesize constructor: takes field values, returns struct.new ──
                // Fable's constructor body is OOP/JS-style (field sets); we replace
                // it with a direct struct.new that matches the struct field layout.
                let ctx'' =
                    match classDecl.Constructor with
                    | None -> ctx'
                    | Some ctorDecl ->
                        let ctorParams =
                            ctorDecl.Args
                            |> List.choose (fun a ->
                                let ty = mapTypeKnown ctx' a.Type
                                if ty = WType.Void then None else Some(a.Name, ty))
                        let retTy = WType.Ref(typeIdx, false)
                        // Build struct.new: map each allFields field to a ctor arg (by name),
                        // falling back to a zero/null constant for fields not in ctor args.
                        let fieldGetters =
                            allFields |> List.map (fun fd ->
                                match ctorParams |> List.tryFind (fun (n, _) -> n = fd.Name) with
                                | Some(name, ty) -> WExpr.LocalGet(name, ty)
                                | None ->
                                    // Default: zero for value types, null for ref types
                                    match fd.Type with
                                    | WType.Ref(_, _) -> WExpr.Const(WConst.Null fd.Type)
                                    | WType.AnyRef     -> WExpr.Const(WConst.Null WType.AnyRef)
                                    | _                -> WExpr.Const(WConst.I32 0))
                        let ctorBody = WExpr.StructNew(typeIdx, fieldGetters, retTy)
                        let ctorFunc : WFuncDecl =
                            { Name = ctorDecl.Name; Params = ctorParams; Result = retTy
                              Locals = []; Body = ctorBody; Exported = false }
                        ctx'.Functions.Add(ctorFunc)
                        // Register synthesized constructor for cross-file import dispatch.
                        // Fable uses the full qualified name (e.g. "ArgumentException_$ctor_Z...") as
                        // the import selector when calling from a different file.
                        let kf = ctx'.KnownFuncs |> Map.add ctorFunc.Name (List.map snd ctorParams, retTy)
                        let kfByPath = ctx'.KnownFuncsByPath |> Map.add (ctx'.CurrentFileStem, ctorFunc.Name) ctorFunc.Name
                        { ctx' with KnownFuncs = kf; KnownFuncsByPath = kfByPath }
                let ctx'' =
                    (ctx'', classDecl.AttachedMembers)
                    ||> List.fold (fun c m ->
                        let func = transformMemberDecl c transformExpr m |> resolveLocals
                        let func =
                            if m.ImplementedSignatureRef.IsSome then
                                let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                                { func with Name = qualName; Exported = false }
                            else func
                        c.Functions.Add(func); c)
                // ── Vtable wiring for interface implementations ──────────────
                let ifaceImpls =
                    classDecl.AttachedMembers
                    |> List.choose (fun m ->
                        match m.ImplementedSignatureRef with
                        | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)) ->
                            let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                            match ctx''.Functions |> Seq.tryFindBack (fun f -> f.Name = qualName) with
                            | Some func ->
                                Some(ifaceEntityRef.FullName, ifaceMemberInfo.CompiledName,
                                     qualName, func.Params |> List.map snd, func.Result)
                            | None -> None
                        | _ -> None)
                let byIface = ifaceImpls |> List.groupBy (fun (ifaceName, _, _, _, _) -> ifaceName)
                for (ifaceName, methods) in byIface do
                    let methodSigs =
                        methods |> List.map (fun (_, methodName, _, compiledParams, retType) ->
                            let nonSelfParams = match compiledParams with _ :: rest -> rest | [] -> []
                            methodName, nonSelfParams, retType)
                    let vtableTypeIdx, boxTypeIdx = VT.getOrRegisterInterface ctx'' ifaceName methodSigs
                    let _, _, funcTypeIndices, _ = ctx''.VTableRegistry.[ifaceName]
                    let methodImpls =
                        methods |> List.map (fun (_, methodName, compiledFunc, compiledParams, retType) ->
                            methodName, compiledFunc, compiledParams, retType)
                    VT.registerVTableImpl ctx'' classDecl.Entity.FullName typeIdx
                        ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodImpls
                ctx''


/// Build the final WModule from accumulated ctx state.
/// Call this once, on the last file in the project.
let buildWModule (ctx: Ctx) : WModule =
    let fixedFunctions =
        ctx.Functions |> Seq.toList
        |> RT.fixClosureApply ctx.TypeDefs

    // TODO: obsolete when pipeline is in place
    // Validate the functions after closure transformations are applied

    // TODO:  should we validate only in debug? not sures
    // if opts.ValidateBeforeEmit then
    Val.validate true ctx.TypeDefs fixedFunctions |> ignore

    // TODO: Refactor buildWModule into a modular pipeline (e.g., separate modules for RuntimeHelpers, 
    // Validation, and ExportResolution) to avoid this becoming a "God Function."
    // Currently, buildWModule is doing "The Grand Setup": resolving dependencies, filtering helpers, handling errors (BUG-05), and building the record. As this grows, it becomes a "God Function."
    // Splitting these into distinct passes (e.g., Discovery -> Optimization -> Validation -> Emission) makes it much easier to test and debug.

    {
        Types = ctx.TypeDefs |> Seq.toList
        Imports =
            [   // User-declared external Wasm imports (via [<Import("name","module")>] on nativeOnly)
                yield! ctx.ExternImports.Values
                // Built-in: consolePrint for printfn (always needed)
                yield { ModuleName = "env"; Name = "consolePrint"; CallName = ""
                        Desc = ImportFunc([WType.Ref(StringTypeIdx, false)], WType.Void) } ]
        Functions =
            // Use the BCL Registry to build all required helpers with dependency resolution.
            // BclRegistry.emitUsed handles:
            // 1. Building only the helpers in ctx.UsedHelpers
            // 2. Resolving transitive dependencies (e.g., $floatToStr → $intToStr + $strConcat)
            // 3. Returning them as WFuncDecl ready for emission
            let bclHelpers = BclReg.emitUsed ctx
            bclHelpers @ fixedFunctions
        Globals =
            // $fsharp_exn_carrier: mutable anyref global used to pass exception objects
            // between throw and catch_all (WasmGC exception proposal has zero-payload tags).
            let carrierGlobal =
                { Name = "$fsharp_exn_carrier"
                  Type = WType.AnyRef
                  Init = WExpr.Const(WConst.Null WType.AnyRef)
                  Mutable = true
                  Exported = false }
            [ yield carrierGlobal
              yield! ctx.VTableGlobals ]
        Exports =
            // Collect all exported functions
            let exportedFuncs =
                fixedFunctions
                |> List.filter (fun f -> f.Exported)
                |> List.map (fun f -> (f.Name, f))

            // BUG-05: Detect duplicate export names at compile time
            let duplicates =
                exportedFuncs
                |> List.groupBy fst
                |> List.choose (fun (name, items) ->
                    if items.Length > 1 then
                        Some(name, items |> List.map snd)
                    else None)

            // Emit warnings for duplicates
            if duplicates.Length > 0 then
                let dupNames = duplicates |> List.map fst |> String.concat ", "
                eprintfn "[WasmGc] WARNING BUG-05: Duplicate Wasm export names: %s. Use [<CompiledName(\"...\")>] to disambiguate or apply module qualification." dupNames

            [   // Linear memory export (index 0) must appear before function exports in the list
                if !ctx.HasLinearMemory then
                    yield { InternalName = "0"; ExportName = "memory"; Kind = ExportMemory }
                yield! exportedFuncs
                       |> List.map (fun (_, f) -> { InternalName = f.Name; ExportName = f.Name; Kind = ExportFunc }) ]
        DataSegments = []
        Tags = [ { Name = "$fsharp_exn"; ParamTypes = [] } ]
        Start = None
        HasLinearMemory = !ctx.HasLinearMemory
    }

/// Compile one Fable file INTO an existing ctx (multi-file accumulation).
/// Returns the updated ctx (KnownFuncs may grow; TypeDefs/Functions mutated in-place).
/// The com argument ensures GetEntity lookups use the current file's type-checker.
/// isLastFile controls whether functions get module-qualified names (library files = false).
let processFileIntoCtx (ctx: Ctx) (com: Compiler) (file: Fable.File) (isLastFile: bool) : Ctx =
    // Interop.fs is a Fable.Core stub that exists only for FCS type resolution.
    // Skip it entirely — our backend must never emit WasmGC code for it.
    let fileName = System.IO.Path.GetFileName(com.CurrentFile)
    if fileName = "Interop.fs" then
        { ctx with Compiler = com }
    else
    let stem = System.IO.Path.GetFileNameWithoutExtension(com.CurrentFile)
    // Update Compiler reference, and set library-context flags for the current file.
    let baseCtx = { ctx with
                        Compiler = com
                        CurrentFileStem = stem
                        IsLibraryContext = not isLastFile
                        NamePrefix = ""
                        FuncNameAlias = Map.empty }
    let ctx =
        if not isLastFile then
            // Pre-scan: build FuncNameAlias for all top-level member functions in this library file.
            // Fable puts file-level module functions at the top level (NOT inside ModuleDeclaration),
            // so we collect them here and prefix with the file stem to avoid name collisions.
            let rec collectMembers acc decls =
                (acc, decls) ||> List.fold (fun a d ->
                    match d with
                    | MemberDeclaration m -> Map.add m.Name (stem + "_" + m.Name) a
                    | ModuleDeclaration md -> collectMembers a md.Members
                    | _ -> a)
            let aliases = collectMembers Map.empty file.Declarations
            { baseCtx with FuncNameAlias = aliases }
        else baseCtx
    preScanGenerics ctx file.Declarations

    // ── Phase 1: Scope analysis ───────────────────────────────────────────────
    // Build ScopeMaps for all member functions so Scope.resolve can distinguish
    // LocalGet vs CapturedVar correctly in Phase 3.
    // Must run BEFORE processDecl so ctx.ScopeMaps is populated on first use.
    let scopeMaps = WasmGc.Pipeline.ScopeAnalyzer.analyzeModuleScope ctx file.Declarations
    let ctx = { ctx with ScopeMaps = Map.fold (fun m k v -> Map.add k v m) ctx.ScopeMaps scopeMaps }

    (ctx, file.Declarations) ||> List.fold processDecl


/// Compile one file from scratch, producing a WModule. Used for single-file projects
/// and as the fallback; Pipeline.fs uses processFileIntoCtx for multi-file projects.
let transformFile (com: Compiler) (file: Fable.File) : WModule =
    let ctx = Ctx.Create(com)
    let finalCtx = processFileIntoCtx ctx com file true  // single-file = always the "last" file
    // ── Flush diagnostics before emit ────────────────────────────────────────
    // Warnings are printed but don't abort; errors fail fast here before any
    // WASM binary is produced. This replaces the old scattered eprintfn calls.
    finalCtx.Diagnostics.Flush()
    // Note: FailOnErrors is intentionally NOT called here — the validator in
    // buildWModule will catch structural errors more precisely. Use strict
    // validate flag instead for hard failures.
    buildWModule finalCtx
