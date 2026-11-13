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
            // the constructor of a generic class is instantiated per type-argument list (see trySpecializeCall)
            match cd.Constructor with
            | Some ctor when (match ctx.Compiler.TryGetEntity cd.Entity with Some e -> e.GenericParameters.Length > 0 | None -> false) ->
                ctx.GenericCtors.[ctor.Name] <- (ctx.Compiler, cd)
            | _ -> ()
        | ActionDeclaration _ -> ()
    decls |> List.iter scan


/// The vtable slots of an interface, in declaration order, derived from its abstract members:
/// (member name, parameter types without self, result type).  None when the declaration alone does not determine them
/// (a generic interface or generic members, inherited interfaces, overloaded names): the first implementation registers
/// the interface instead.
let private interfaceSlots (ctx: Ctx) (ent: Fable.Entity) : (string * WType list * WType) list option =
    let members =
        ent.MembersFunctionsAndValues
        |> Seq.filter (fun m -> m.IsDispatchSlot && not m.IsProperty)
        |> List.ofSeq
    let determined =
        not members.IsEmpty
        && Seq.isEmpty ent.DeclaredInterfaces
        && ent.GenericParameters |> List.forall (fun p -> p.IsMeasure)
        && members |> List.forall (fun m -> m.GenericParameters.IsEmpty)
        && (members |> List.map (fun m -> m.CompiledName) |> List.distinct).Length = members.Length
    if not determined then None
    else
        members
        |> List.map (fun m ->
            let args =
                m.CurriedParameterGroups
                |> List.concat
                |> List.map (fun p -> mapTypeKnown ctx p.Type)
                |> List.filter (fun t -> t <> WType.Void)
            m.CompiledName, args, mapResultTypeKnown ctx m.ReturnParameter.Type)
        |> Some

/// Wire the interfaces a class, record or union implements to its compiled members (see VT.wireImplementation).
let private wireInterfaces (ctx: Ctx) (classDecl: Fable.ClassDecl) (typeIdx: int) : unit =
    let members =
        classDecl.AttachedMembers
        |> List.choose (fun m ->
            match m.ImplementedSignatureRef with
            | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)) ->
                // the compiled function was qualified: TypeFullName_MethodName
                let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                ctx.Functions
                |> Seq.tryFindBack (fun f -> f.Name = qualName)
                |> Option.map (fun func ->
                    ifaceEntityRef.FullName, ifaceMemberInfo.CompiledName, qualName, List.map snd func.Params, func.Result)
            | _ -> None)
    VT.wireImplementation ctx classDecl.Entity.FullName typeIdx members

/// A module-level value whose initialiser is not a scalar literal: it is computed once and kept, not recomputed (a
/// literal is as cheap to repeat as to read).
let private isComputedValue (m: MemberDecl) =
    match m.Body with
    | Value((UnitConstant | BoolConstant _ | CharConstant _ | StringConstant _ | NumberConstant _ | Null _), _) -> false
    | _ -> true

/// Process one Fable declaration into the shared ctx (mutates ctx.TypeDefs/Functions).
/// Returns the updated immutable record (KnownFuncs accumulates across declarations).
let rec processDecl (ctx: Ctx) (decl: Declaration) : Ctx =
    match decl with
    // module-level `let mutable x = init`, and every module-level value that is more than a literal (`let host = Host()`,
    // `let table = [| … |]`): a wasm global, and `init` runs once, in the start function — as in F#, where a module value
    // is evaluated at start-up and shared, not recomputed at every reference
    | MemberDeclaration memberDecl when memberDecl.Args.IsEmpty && (ctx.AssignedIdents.Contains memberDecl.Name || isComputedValue memberDecl) ->
        let func = transformMemberDecl ctx transformExpr memberDecl |> resolveLocals
        let qualified = ctx.FuncNameAlias |> Map.tryFind func.Name |> Option.defaultValue func.Name
        let initName = qualified + "$init"
        ctx.Functions.Add { func with Name = initName; Exported = false }
        let stored = match func.Result with WType.Ref(idx, _) -> WType.Ref(idx, true) | t -> t
        ctx.MutableGlobals.[qualified] <- func.Result
        ctx.GlobalDecls.Add { Name = qualified; Type = stored; Init = WasmGc.Builder.Core.makeNumericZero stored; Mutable = true; Exported = false }
        ctx.InitSteps.Add(WExpr.GlobalSet(qualified, WExpr.Call(initName, [], func.Result)))
        // known like any function of this file — a reference from another file finds it by (file, name) — but as a value
        let byPath =
            if qualified <> func.Name then
                ctx.KnownFuncsByPath |> Map.add (ctx.CurrentFileStem, func.Name) qualified |> Map.add (ctx.CurrentFileStem, qualified) qualified
            else ctx.KnownFuncsByPath
        { ctx with KnownFuncs = Map.add qualified ([], func.Result) ctx.KnownFuncs; KnownFuncsByPath = byPath }
    | MemberDeclaration memberDecl ->
        let func = transformMemberDecl ctx transformExpr memberDecl |> resolveLocals
        let shortName = func.Name
        // In library context, use module-qualified name (e.g. MapModule_add).
        // FuncNameAlias was pre-populated in ModuleDeclaration so recursive calls resolve correctly.
        let qualifiedName = ctx.FuncNameAlias |> Map.tryFind shortName |> Option.defaultValue shortName
        let isLibFunc = qualifiedName <> shortName
        let rec hasGeneric (t: Fable.Type) =
            match t with
            | Fable.Type.GenericParam _ -> true
            | Fable.Type.List e | Fable.Type.Option(e, _) | Fable.Type.Array(e, _) -> hasGeneric e
            | Fable.Type.Tuple(ts, _) -> List.exists hasGeneric ts
            | Fable.Type.LambdaType(a, r) -> hasGeneric a || hasGeneric r
            | Fable.Type.DelegateType(ts, r) -> List.exists hasGeneric ts || hasGeneric r
            | Fable.Type.DeclaredType(_, ts) -> List.exists hasGeneric ts
            | _ -> false
        // a generic function can only be compiled with its type parameters unresolved; it is not an export, and it
        // stays in the module only if something calls it unspecialised (see dropUnreferenced)
        let isGenericOriginal = memberDecl.Args |> List.exists (fun a -> hasGeneric a.Type) || hasGeneric memberDecl.Body.Type
        let func = { func with
                        Name = qualifiedName
                        // Library functions are internal — only last-file functions are exported.
                        Exported = if isLibFunc || isGenericOriginal then false else func.Exported }
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
            // reserve the slot first: mapping a field type can register further types (the list of this record's
            // element type, …), and those must not take the index the registry already hands out
            ctx.TypeDefs.Add({ Name = classDecl.Entity.FullName; Def = WTypeDef.Struct([], None) })
            let ctx' = ctx.WithTypeEntry(classDecl.Entity.FullName, typeIdx)
            let fields =
                ent.FSharpFields
                |> List.map (fun f ->
                    { Name = f.Name; Type = mapTypeKnown ctx' f.FieldType; Mutable = f.IsMutable })
            ctx.TypeDefs.[typeIdx] <- { Name = classDecl.Entity.FullName; Def = WTypeDef.Struct(fields, None) }
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
            wireInterfaces ctx'' classDecl typeIdx
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
                // reserve every case slot before mapping any field (a field's type may register new types)
                cases |> List.iteri (fun i _ ->
                    ctx.TypeDefs.Add({ Name = $"{classDecl.Entity.FullName}#{i}"; Def = WTypeDef.Struct([], Some baseIdx) }))
                cases |> List.iteri (fun i case ->
                    let dataFields =
                        case.UnionCaseFields
                        |> List.map (fun f ->
                            { Name = f.Name; Type = mapTypeKnown ctx'' f.FieldType; Mutable = false })
                        |> List.filter (fun f -> f.Type <> WType.Void)
                    ctx.TypeDefs.[baseIdx + 1 + i] <-
                        { Name = $"{classDecl.Entity.FullName}#{i}"
                          Def = WTypeDef.Struct(
                                { Name = "tag"; Type = WType.I32; Mutable = false } :: dataFields,
                                Some baseIdx) })
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
                    wireInterfaces ctx3 classDecl baseIdx
                    ctx3)
        else
            // Regular class, abstract class, or interface declaration.
            // Interface declarations have no fields or implementations to emit.
            if ent.IsInterface then
                // register the vtable at the declaration: a value of the interface type (a parameter, a field) is the box,
                // and a call dispatches, wherever it comes in the compile order relative to any implementation
                interfaceSlots ctx ent |> Option.iter (fun slots -> VT.getOrRegisterInterface ctx classDecl.Entity.FullName slots |> ignore)
                ctx
            else
                // ── Resolve parent type for struct subtyping ─────────────────────────────
                // WasmGC requires ALL fields (including inherited) to be declared in the
                // subtype, with the parent's fields appearing first (prefix layout).
                let typeIdx = ctx.TypeDefs.Count
                ctx.TypeDefs.Add({ Name = classDecl.Entity.FullName; Def = WTypeDef.Struct([], None) })    // reserved, see above
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
                // A class field of reference type is stored nullable: the instance exists before its constructor has
                // initialised the fields (`let items = Array.zeroCreate 4`), and reads cast back to the declared type.
                let ownFields =
                    ent.FSharpFields
                    |> List.map (fun f ->
                        let ty = match mapTypeKnown ctx' f.FieldType with WType.Ref(i, _) -> WType.Ref(i, true) | t -> t
                        // mutable in the struct whatever F# says: the constructor body assigns every field once
                        { Name = f.Name; Type = ty; Mutable = true })

                // Flattened layout: parent prefix fields + own new fields
                let allFields, superTypeOpt =
                    match parentStructInfo with
                    | Some(parentIdx, parentFields) -> parentFields @ ownFields, Some parentIdx
                    | None -> ownFields, None

                ctx.TypeDefs.[typeIdx] <- { Name = classDecl.Entity.FullName; Def = WTypeDef.Struct(allFields, superTypeOpt) }
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
                        let ctorFunc = TransformDispatch.buildClassCtor transformExpr ctx' ctorDecl retTy ctorParams ctorDecl.Name |> resolveLocals
                        ctx'.Functions.Add(ctorFunc)
                        // Register synthesized constructor for cross-file import dispatch.
                        // Fable uses the full qualified name (e.g. "ArgumentException_$ctor_Z...") as
                        // the import selector when calling from a different file.
                        let kf = ctx'.KnownFuncs |> Map.add ctorFunc.Name (List.map snd ctorParams, retTy)
                        let kfByPath = ctx'.KnownFuncsByPath |> Map.add (ctx'.CurrentFileStem, ctorFunc.Name) ctorFunc.Name
                        { ctx' with KnownFuncs = kf; KnownFuncsByPath = kfByPath }
                // The members of a generic class are compiled per instantiation, when a call asks for them (trySpecializeCall);
                // compiled here, without type arguments, they would be dead code that still reports its diagnostics.
                let isGenericClass = ent.GenericParameters |> List.exists (fun p -> not p.IsMeasure)
                let ctx'' =
                    (ctx'', if isGenericClass then [] else classDecl.AttachedMembers)
                    ||> List.fold (fun c m ->
                        let func = transformMemberDecl c transformExpr m |> resolveLocals
                        let func =
                            if m.ImplementedSignatureRef.IsSome then
                                let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                                { func with Name = qualName; Exported = false }
                            else func
                        c.Functions.Add(func); c)
                wireInterfaces ctx'' classDecl typeIdx
                ctx''


/// Remove every function nothing refers to: not exported, not the start function, and not called / referenced
/// (`call`, `ref.func`, closure creation, vtable globals) from a function that is kept.  The generic original of a
/// function that is only ever used specialised (`el<'msg>` → `el|…`) is the typical victim: it can only be compiled
/// with its type parameters unresolved, so it must not be emitted unless something really needs it.
let private dropUnreferenced (ctx: Ctx) (funcs: WFuncDecl list) : WFuncDecl list =
    let byName = funcs |> List.map (fun f -> f.Name, f) |> dict
    let kept = System.Collections.Generic.HashSet<string>()
    let rec visit (e: WExpr) =
        (match e with
         | WExpr.Call(n, _, _) | WExpr.TailCall(n, _, _) | WExpr.FuncRef n | WExpr.Closure(n, _, _) -> keep n
         | _ -> ())
        WasmGc.Core.Traverse.children e |> List.iter visit
    and keep (name: string) =
        if kept.Add name then
            match byName.TryGetValue name with
            | true, f -> visit f.Body
            | _ -> ()
    for f in funcs do
        if f.Exported then keep f.Name
    if ctx.InitSteps.Count > 0 then
        keep "$__init"
        ctx.InitSteps |> Seq.iter visit
    for g in Seq.append ctx.VTableGlobals ctx.GlobalDecls do visit g.Init
    // anything the kept bodies reach through the helpers is already named in a call; helper functions (`$…`) that
    // are added later by the BCL registry are not in `funcs`
    funcs |> List.filter (fun f -> kept.Contains f.Name)

/// Build the final WModule from accumulated ctx state.
/// Call this once, on the last file in the project.
let buildWModule (ctx: Ctx) : WModule =
    // the start function: initialisers of module-level mutable variables, in declaration order
    if ctx.InitSteps.Count > 0 && not (ctx.Functions.Exists(fun f -> f.Name = "$__init")) then
        ctx.Functions.Add { Name = "$__init"; Params = []; Result = WType.Void; Locals = []; Body = WExpr.Sequence(List.ofSeq ctx.InitSteps); Exported = false }
    let assemble () =
        ctx.Functions |> Seq.toList
        |> WasmGc.Runtime.ArraySort.specialize ctx      // per-array-type Array.sortWith helpers
        |> RT.fixClosureApply ctx.TypeDefs              // must run last: creates missing ClosureBase types
        |> dropUnreferenced ctx
    let fixedFunctions =
        let kept = assemble ()
        // the host-facing exports depend on what survives; adding them changes what is reachable
        if HostInterop.finalize ctx kept then assemble () else kept

    // TODO: obsolete when pipeline is in place
    // Validate the functions after closure transformations are applied

    // TODO:  should we validate only in debug? not sures
    // if opts.ValidateBeforeEmit then
    Val.validate true ctx.TypeDefs fixedFunctions |> ignore

    // TODO: Refactor buildWModule into a modular pipeline (e.g., separate modules for RuntimeHelpers, 
    // Validation, and ExportResolution) to avoid this becoming a "God Function."
    // Currently, buildWModule is doing "The Grand Setup": resolving dependencies, filtering helpers, handling errors (BUG-05), and building the record. As this grows, it becomes a "God Function."
    // Splitting these into distinct passes (e.g., Discovery -> Optimization -> Validation -> Emission) makes it much easier to test and debug.

    // Use the BCL Registry to build all required helpers with dependency resolution.
    // BclRegistry.emitUsed handles:
    // 1. Building only the helpers in ctx.UsedHelpers
    // 2. Resolving transitive dependencies (e.g., $floatToStr → $intToStr + $strConcat)
    // 3. Returning them as WFuncDecl ready for emission
    let allFunctions = BclReg.emitUsed ctx @ fixedFunctions

    // an extern (`[<Import>] … = nativeOnly`) is imported only if a function that is kept calls it — a runtime
    // library declares hundreds, an app uses a few
    let called =
        let names = System.Collections.Generic.HashSet<string>()
        let rec visit (e: WExpr) =
            (match e with
             | WExpr.Call(n, _, _) | WExpr.TailCall(n, _, _) | WExpr.FuncRef n -> names.Add n |> ignore
             | _ -> ())
            WasmGc.Core.Traverse.children e |> List.iter visit
        allFunctions |> List.iter (fun f -> visit f.Body)
        for g in Seq.append ctx.VTableGlobals ctx.GlobalDecls do visit g.Init
        names

    {
        Types = ctx.TypeDefs |> Seq.toList
        Imports =
            [   // User-declared external Wasm imports (via [<Import("name","module")>] on nativeOnly)
                yield! ctx.ExternImports.Values |> Seq.filter (fun i -> called.Contains i.CallName)
                // Built-in: consolePrint for printfn
                if called.Contains "consolePrint" then
                    yield { ModuleName = "env"; Name = "consolePrint"; CallName = ""
                            Desc = ImportFunc([WType.Ref(StringTypeIdx, false)], WType.Void) } ]
        Functions = allFunctions
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
              yield! ctx.VTableGlobals
              yield! ctx.GlobalDecls ]
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
        Start = if ctx.InitSteps.Count > 0 then Some "$__init" else None
        HasLinearMemory = !ctx.HasLinearMemory
    }

/// Compile one Fable file INTO an existing ctx (multi-file accumulation).
/// Returns the updated ctx (KnownFuncs may grow; TypeDefs/Functions mutated in-place).
/// The com argument ensures GetEntity lookups use the current file's type-checker.
/// isLastFile controls whether functions keep their names (the entry project's files) or get the file name as prefix (every other file).
let processFileIntoCtx (ctx: Ctx) (com: ICompilerCore) (file: Fable.File) (isLastFile: bool) : Ctx =
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
    for decl in file.Declarations do
        for name in FableNormalize.assignedIdents decl do
            ctx.AssignedIdents.Add name |> ignore

    // ── Phase 1: Scope analysis ───────────────────────────────────────────────
    // Build ScopeMaps for all member functions so Scope.resolve can distinguish
    // LocalGet vs CapturedVar correctly in Phase 3.
    // Must run BEFORE processDecl so ctx.ScopeMaps is populated on first use.
    let scopeMaps = WasmGc.Pipeline.ScopeAnalyzer.analyzeModuleScope ctx file.Declarations
    let ctx = { ctx with ScopeMaps = Map.fold (fun m k v -> Map.add k v m) ctx.ScopeMaps scopeMaps }

    (ctx, file.Declarations) ||> List.fold processDecl


/// Compile one file from scratch, producing a WModule. Used for single-file projects
/// and as the fallback; Pipeline.fs uses processFileIntoCtx for multi-file projects.
let transformFile (com: ICompilerCore) (file: Fable.File) : WModule =
    let ctx = Ctx.Create(com)
    let finalCtx = processFileIntoCtx ctx com file true  // single-file = always the "last" file
    // ── Flush diagnostics before emit ────────────────────────────────────────
    // Warnings are printed but don't abort; errors fail fast here before any
    // WASM binary is produced. This replaces the old scattered eprintfn calls.
    finalCtx.Diagnostics.FailOnErrors("Fable → WExpr")
    // (Errors abort here; WASMGC_ALLOW_ERRORS=1 to emit anyway.) Formerly: not called here — the validator in
    // buildWModule will catch structural errors more precisely. Use strict
    // validate flag instead for hard failures.
    buildWModule finalCtx

