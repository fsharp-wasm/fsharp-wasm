/// WasmGC context, type mapping, and exprWType utilities.
/// Extracted from Fable2WasmGc.fs to keep concerns separated.
module Fable.Transforms.WasmGc.WasmGcTypes

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc

// ─────────────────────────────────────────────────────────────────
// Constants — pre-registered type indices (always the same)
// ─────────────────────────────────────────────────────────────────

/// Type index 0 is always $AnyFn — the universal base struct for all closures.
[<Literal>]
let AnyFnTypeIdx = 0

/// Type index 1 is always $WasmStr — an (array i32) holding UTF-16 code units.
[<Literal>]
let StringTypeIdx = 1

/// Type index 2 is always $ListBase — the common supertype of all per-element list cons structs.
[<Literal>]
let ListBaseTypeIdx = 2

/// Type index 3 is always $StringBuilder — struct(data: mut ref $WasmStr, length: mut i32, capacity: mut i32).
[<Literal>]
let StringBuilderTypeIdx = 3

// ─────────────────────────────────────────────────────────────────
// Context — threaded through the translation
// ─────────────────────────────────────────────────────────────────

/// Selects how F# strings are stored in the WasmGC (array) type.
/// I32 (default): each slot is a 32-bit integer — UTF-16 code units stored wide.
/// I16: each slot is a packed 16-bit integer — 50 % smaller for ASCII-heavy workloads;
///      reads use array.get_s (sign-extend). Not all Wasm runtimes support i16 arrays yet.
type StringMode = I32 | I16

type Ctx =
    {
        /// Currently known local variable types
        Locals: Map<string, WType>
        /// Accumulated type definitions for the module
        TypeDefs: ResizeArray<WTypeDeclEntry>
        /// Accumulated function definitions
        Functions: ResizeArray<WFuncDecl>
        /// Currently processing function name (for recursion detection)
        CurrentFunc: string option
        /// Map of known functions and their wasm types
        KnownFuncs: Map<string, WType list * WType>
        /// Entity FullName → WASM struct type index (for records, DUs)
        TypeRegistry: Map<string, int>
        /// Tuple element-type signature → WASM struct type index
        TupleRegistry: System.Collections.Generic.Dictionary<string, int>
        /// Option inner WType → WASM struct type index for the { value: T } box struct.
        OptionRegistry: System.Collections.Generic.Dictionary<string, int>
        /// List element WType key → WASM struct type index for the $ListCons_T struct.
        ListRegistry: System.Collections.Generic.Dictionary<string, int>
        /// F# array element WType key → WASM (array (mut T)) type index.
        ArrayRegistry: System.Collections.Generic.Dictionary<string, int>
        /// FSharpRef inner WType key → WASM struct type index for the mutable single-field box.
        RefRegistry: System.Collections.Generic.Dictionary<string, int>
        /// On-demand generic DU instantiation key → base type index.
        /// Key format: "FullName<WType1,WType2>" e.g. "FSharpResult`2<I32,I32>".
        /// Used for built-in generic DUs (Result<T,E>, Choice<T,U>, etc.) not emitted via ClassDeclaration.
        GenericDuRegistry: System.Collections.Generic.Dictionary<string, int>
        /// FuncType signature → WTypeDef.Func type index (in TypeDefs).
        FuncTypeRegistry: System.Collections.Generic.Dictionary<string, int>
        /// funcName → (closureTypeIdx, funcTypeIdx, captureCount)
        ClosureRegistry: System.Collections.Generic.Dictionary<string, int * int * int>
        /// funcTypeIdx → closureTypeIdx
        FuncTypeToClosureMap: System.Collections.Generic.Dictionary<int, int>
        /// funcTypeIdx → base closure type index (struct with only the code field, sub $AnyFn).
        /// Used for ref.cast in library functions that accept closure parameters.
        ClosureBaseTypeMap: System.Collections.Generic.Dictionary<int, int>
        /// Runtime helpers actually used in this module — demand-driven emission.
        UsedHelpers: System.Collections.Generic.HashSet<string>
        /// Structural equality functions generated on-demand.
        /// Key: typeIdx (in TypeDefs); Value: generated function name ($equals_N).
        /// Pre-registered before body generation to allow recursive types.
        EqualityRegistry: System.Collections.Generic.Dictionary<int, string>
        /// Generic MemberDecl bodies, pre-scanned before translation.
        /// Key: fully-qualified F# function name (e.g. "MyModule.swap")
        /// Value: (per-file Compiler instance, Fable MemberDecl as obj)
        /// The per-file Compiler is needed for cross-file entity lookups during specialization.
        GenericFuncRegistry: System.Collections.Generic.Dictionary<string, Compiler * obj>
        /// Cache of already-emitted or in-progress specializations.
        /// Key = mangled name (e.g. "MyModule.swap|i32,ref1"); Value = same mangled name (sentinel).
        MonoCache: System.Collections.Generic.Dictionary<string, string>
        /// Active type substitution during specialized translation.
        /// Empty outside generic function bodies.
        /// Key: F# generic param name ("T", "U", ...); Value: concrete WType.
        TypeSubst: Map<string, WType>
        /// Compiler reference for diagnostics
        Compiler: Compiler
        // ── Multi-file / library-compilation support ──────────────────────────
        /// True when compiling a non-last file (library context).
        /// Library functions get module-qualified names and are not exported.
        IsLibraryContext: bool
        /// Filename stem of the current source file (e.g. "Map" for Map.fs).
        /// Used to key KnownFuncsByPath for cross-file import resolution.
        CurrentFileStem: string
        /// Current module name prefix (e.g. "MapModule") set while processing a
        /// ModuleDeclaration inside a library file. Empty for non-library files.
        NamePrefix: string
        /// Short name → qualified WAsmGC function name within the current library module.
        /// Populated before compiling each library module so recursive calls resolve correctly.
        FuncNameAlias: Map<string, string>
        /// (fileStem, selector) → qualified WasmGC function name.
        /// Enables cross-file import dispatch to resolve the correct qualified name.
        KnownFuncsByPath: Map<string * string, string>
        /// External Wasm function imports declared via [<Import("name","module")>] on nativeOnly funcs.
        /// Key = internal call-name "$ext$module$name"; Value = WImport to be emitted in import section.
        ExternImports: System.Collections.Concurrent.ConcurrentDictionary<string, WImport>
        /// String storage mode: I32 (default, wide) or I16 (packed, 50 % smaller for ASCII).
        StringMode: StringMode
        // ── Interface vtable support ───────────────────────────────────────
        /// Interface full name → (vtableTypeIdx, boxTypeIdx, methodFuncTypeIndices, orderedMethodNames).
        /// Populated on first encounter of an interface being implemented.
        VTableRegistry: System.Collections.Generic.Dictionary<string, int * int * int list * string list>
        /// (implTypeName, ifaceName) → vtable global name ($ImplType_IFace_vtable).
        VTableImplRegistry: System.Collections.Generic.Dictionary<string * string, string>
        /// Accumulated vtable globals to emit in the final WModule.
        VTableGlobals: ResizeArray<WGlobalDecl>
        /// ResizeArray element WType key → (arrTypeIdx, ravTypeIdx).
        /// ravTypeIdx: index of struct { data: (mut ref? $Arr_T); len: (mut i32) }.
        ResizeArrayRegistry: System.Collections.Generic.Dictionary<string, int * int>
    }

    static member Create(com: Compiler, ?stringMode: StringMode) =
        let stringMode = defaultArg stringMode I32
        let typeDefs = new ResizeArray<WTypeDeclEntry>()
        let functions = new ResizeArray<WFuncDecl>()
        // Pre-register $AnyFn = struct {} (index 0)
        typeDefs.Add({ Name = "$AnyFn"; Def = WTypeDef.Struct([], None) })
        // Pre-register $WasmStr — element type depends on StringMode:
        //   I32 (default): (array (mut i32)) — wide UTF-16 code units
        //   I16:           (array (mut i16)) — packed UTF-16, saved 50% memory; reads use array.get_s
        let strElemType = match stringMode with I32 -> WType.I32 | I16 -> WType.I16
        typeDefs.Add({ Name = "$WasmStr"; Def = WTypeDef.Array(strElemType, true) })
        // Pre-register $ListBase = struct {} (index 2)
        typeDefs.Add({ Name = "$ListBase"; Def = WTypeDef.Struct([], None) })
        // Pre-register $StringBuilder = struct { data: (mut ref $WasmStr), length: (mut i32), capacity: (mut i32) } (index 3)
        typeDefs.Add({ Name = "$StringBuilder"
                       Def = WTypeDef.Struct([
                           { Name = "data";     Type = WType.Ref(StringTypeIdx, false); Mutable = true }
                           { Name = "length";   Type = WType.I32;                       Mutable = true }
                           { Name = "capacity"; Type = WType.I32;                       Mutable = true }
                       ], None) })
        {
            Locals = Map.empty
            TypeDefs = typeDefs
            Functions = functions
            CurrentFunc = None
            KnownFuncs = Map.empty
            TypeRegistry = Map.empty
            TupleRegistry = System.Collections.Generic.Dictionary<string, int>()
            OptionRegistry = System.Collections.Generic.Dictionary<string, int>()
            ListRegistry = System.Collections.Generic.Dictionary<string, int>()
            ArrayRegistry = System.Collections.Generic.Dictionary<string, int>()
            RefRegistry = System.Collections.Generic.Dictionary<string, int>()
            GenericDuRegistry = System.Collections.Generic.Dictionary<string, int>()
            FuncTypeRegistry = System.Collections.Generic.Dictionary<string, int>()
            ClosureRegistry = System.Collections.Generic.Dictionary<string, int * int * int>()
            FuncTypeToClosureMap = System.Collections.Generic.Dictionary<int, int>()
            ClosureBaseTypeMap = System.Collections.Generic.Dictionary<int, int>()
            UsedHelpers = System.Collections.Generic.HashSet<string>()
            EqualityRegistry = System.Collections.Generic.Dictionary<int, string>()
            GenericFuncRegistry = System.Collections.Generic.Dictionary<string, Compiler * obj>()
            MonoCache = System.Collections.Generic.Dictionary<string, string>()
            TypeSubst = Map.empty
            Compiler = com
            IsLibraryContext = false
            CurrentFileStem = ""
            NamePrefix = ""
            FuncNameAlias = Map.empty
            KnownFuncsByPath = Map.empty
            ExternImports = System.Collections.Concurrent.ConcurrentDictionary<string, WImport>()
            StringMode = stringMode
            VTableRegistry = System.Collections.Generic.Dictionary<string, int * int * int list * string list>()
            VTableImplRegistry = System.Collections.Generic.Dictionary<string * string, string>()
            VTableGlobals = new ResizeArray<WGlobalDecl>()
            ResizeArrayRegistry = System.Collections.Generic.Dictionary<string, int * int>()
        }

    member this.WithLocal(name: string, ty: WType) =
        { this with Locals = Map.add name ty this.Locals }

    member this.WithTypeEntry(fullName: string, typeIdx: int) =
        { this with TypeRegistry = Map.add fullName typeIdx this.TypeRegistry }

    /// Mark a runtime helper as needed and return its name (for use in WExpr.Call).
    member this.UseHelper(name: string) : string =
        this.UsedHelpers.Add(name) |> ignore
        name

    /// Register an external Wasm import (from [<Import("name","module")>] on nativeOnly).
    /// Returns the internal call-name to use in WExpr.Call.
    member this.RegisterExternFunc(moduleName: string, funcName: string, parms: WType list, result: WType) : string =
        // callName is the internal identifier used at call sites and in the funcIndex.
        // WImport.Name stays as the external name (visible to the Wasm runtime/JS host).
        // WImport.CallName = callName (disambiguates if two modules export same funcName).
        let callName = $"{moduleName}_{funcName}"
        this.ExternImports.TryAdd(callName, { ModuleName = moduleName; Name = funcName; CallName = callName; Desc = ImportFunc(parms, result) }) |> ignore
        callName

    /// Get or create a WTypeDef.Func typeIdx for the given signature.
    member this.GetOrAddFuncType(paramTypes: WType list, resultType: WType) : int =
        let resultTypes = match resultType with | WType.Void -> [] | t -> [t]
        let key = $"{wTypesKey paramTypes}->{wTypesKey resultTypes}"
        match this.FuncTypeRegistry.TryGetValue(key) with
        | true, idx -> idx
        | false, _ ->
            let idx = this.TypeDefs.Count
            this.TypeDefs.Add(
                { Name = $"FuncType_{idx}"
                  Def = WTypeDef.Func(paramTypes, resultType) })
            this.FuncTypeRegistry.[key] <- idx
            idx

// ─────────────────────────────────────────────────────────────────
// Type mapping: Fable.Type → WType
// ─────────────────────────────────────────────────────────────────

let mapType (t: Fable.Type) : WType =
    match t with
    | Fable.Type.Unit -> WType.Void
    | Fable.Type.Boolean -> WType.I32
    | Fable.Type.Char -> WType.I32
    | Fable.Type.String -> WType.Ref(StringTypeIdx, false)
    | Fable.Type.Number(kind, _) ->
        match kind with
        | Int8 | UInt8 | Int16 | UInt16 | Int32 | UInt32 -> WType.I32
        | Int64 | UInt64 | BigInt -> WType.I64
        | Float32 -> WType.F32
        | Float64 -> WType.F64
        | NativeInt | UNativeInt -> WType.I32
        | _ -> WType.I32
    | Fable.Type.LambdaType _ -> WType.Ref(AnyFnTypeIdx, false)
    | Fable.Type.DelegateType _ -> WType.Ref(AnyFnTypeIdx, false)
    | Fable.Type.Tuple _ -> WType.I32
    | Fable.Type.Option _ -> WType.I32
    | Fable.Type.List _ -> WType.I32
    | Fable.Type.Array _ -> WType.I32
    | Fable.Type.DeclaredType _ -> WType.I32
    | Fable.Type.Any -> WType.I32
    | Fable.Type.GenericParam _ -> WType.I32
    | _ -> WType.I32

/// Produce a deterministic, collision-free mangled name for a generic specialization.
/// Uses wTypeKey (already stable) for type argument encoding.
/// "|" separates the base name from type args; "~" separates individual type args.
/// Both "|" and "~" are valid WAT identifier characters, so the result is WAT-safe.
/// Example: mangleGenericName "MyMod.swap" [WType.I32; WType.Ref(1,false)] = "MyMod.swap|i32~ref1"
let mangleGenericName (baseName: string) (typeArgs: WType list) : string =
    match typeArgs with
    | [] -> baseName
    | _  ->
        let suffix = typeArgs |> List.map wTypeKey |> String.concat "~"
        $"{baseName}|{suffix}"

let mapResultType (t: Fable.Type) : WType =
    match t with
    | Fable.Type.Unit -> WType.Void
    | _ -> mapType t

/// Full type name for FSharpRef (used to detect ref cell types)
let [<Literal>] FSharpRefFullName = "Microsoft.FSharp.Core.FSharpRef`1"

/// Get or create the mutable 1-field box struct type for FSharpRef<T>.
let getOrAddRefCellType (ctx: Ctx) (innerWType: WType) : int =
    let key = wTypeKey innerWType
    match ctx.RefRegistry.TryGetValue(key) with
    | true, idx -> idx
    | false, _ ->
        let idx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add(
            { Name = $"RefCell_{idx}"
              Def = WTypeDef.Struct([{ Name = "contents"; Type = innerWType; Mutable = true }], None) })
        ctx.RefRegistry.[key] <- idx
        idx

/// Get or create a mutable GC array type for the given element WType.
let getOrAddArrayType (ctx: Ctx) (elemT: WType) : int =
    let key = $"GcArr_{wTypeKey elemT}"
    match ctx.ArrayRegistry.TryGetValue(key) with
    | true, idx -> idx
    | false, _ ->
        let idx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add({ Name = $"GcArray_{idx}"; Def = WTypeDef.Array(elemT, true) })
        ctx.ArrayRegistry.[key] <- idx
        idx

/// Register (if needed) a $ResizeArray_T struct:
///   struct { data: (mut ref? $Arr_T); len: (mut i32) }
/// Returns (arrTypeIdx, ravTypeIdx).
let getOrAddResizeArrayType (ctx: Ctx) (elemT: WType) : int * int =
    let key = wTypeKey elemT
    match ctx.ResizeArrayRegistry.TryGetValue(key) with
    | true, pair -> pair
    | false, _ ->
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let ravTypeIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add({ Name = $"$ResizeArray_{ravTypeIdx}"
                           Def = WTypeDef.Struct([
                               { Name = "data"; Type = WType.Ref(arrTypeIdx, true); Mutable = true }
                               { Name = "len";  Type = WType.I32;                   Mutable = true }
                           ], None) })
        ctx.ResizeArrayRegistry.[key] <- (arrTypeIdx, ravTypeIdx)
        (arrTypeIdx, ravTypeIdx)

/// Type mapping that resolves declared (record/DU) types via the context's type registry.
let rec mapTypeKnown (ctx: Ctx) (t: Fable.Type) : WType =
    match t with
    // Resolve generic parameters from active type substitution (Sprint 5: monomorphization)
    | Fable.Type.GenericParam(name, _, _) ->
        match Map.tryFind name ctx.TypeSubst with
        | Some wty -> wty
        | None -> WType.I32  // unresolved — not inside a specialized body
    | Fable.Type.DeclaredType(entRef, genericArgs) when entRef.FullName = FSharpRefFullName ->
        let innerT = match genericArgs with | [t] -> mapTypeKnown ctx t | _ -> WType.I32
        WType.Ref(getOrAddRefCellType ctx innerT, false)
    // StringBuilder: always maps to the pre-registered $StringBuilder struct
    | Fable.Type.DeclaredType(entRef, _) when entRef.FullName = "System.Text.StringBuilder" ->
        WType.Ref(StringBuilderTypeIdx, false)
    | Fable.Type.DeclaredType(entRef, genericArgs) ->
        // Try the generic instance key first (for on-demand registered DUs like Result<T,E>)
        if not genericArgs.IsEmpty then
            let argKeys = genericArgs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
            let instKey = $"{entRef.FullName}<{argKeys}>"
            match ctx.GenericDuRegistry.TryGetValue(instKey) with
            | true, idx -> WType.Ref(idx, false)
            | false, _ ->
                // Fall back to non-generic key (ClassDeclaration-registered types)
                match Map.tryFind entRef.FullName ctx.TypeRegistry with
                | Some idx -> WType.Ref(idx, false)
                | None -> WType.I32
        else
            match Map.tryFind entRef.FullName ctx.TypeRegistry with
            | Some idx -> WType.Ref(idx, false)
            | None ->
                // Check if it's a registered interface (vtable box struct).
                // VTableRegistry is populated when a ClassDeclaration implementing
                // the interface is processed, which always precedes function bodies.
                let ifaceName = entRef.FullName
                if ctx.VTableRegistry.ContainsKey(ifaceName) then
                    let _, boxTypeIdx, _, _ = ctx.VTableRegistry.[ifaceName]
                    WType.Ref(boxTypeIdx, false)
                else WType.I32
    | Fable.Type.Tuple(elementTypes, _) ->
        let wTypes = elementTypes |> List.map (mapTypeKnown ctx)
        let key = wTypesKey wTypes
        match ctx.TupleRegistry.TryGetValue(key) with
        | true, idx -> WType.Ref(idx, false)
        | false, _ ->
            let typeIdx = ctx.TypeDefs.Count
            let fields =
                wTypes |> List.mapi (fun i ft ->
                    { Name = $"Item{i + 1}"; Type = ft; Mutable = false })
            ctx.TypeDefs.Add(
                { Name = $"Tuple_{typeIdx}"
                  Def = WTypeDef.Struct(fields, None) })
            ctx.TupleRegistry.[key] <- typeIdx
            WType.Ref(typeIdx, false)
    | Fable.Type.Option(innerType, _) ->
        let innerWType = mapTypeKnown ctx innerType
        match innerWType with
        | WType.Ref(innerIdx, false) ->
            // Non-null inner ref → no wrapper struct needed.
            // A nullable ref (ref null $T) directly encodes the option:
            //   null  = None
            //   non-null ptr = Some value
            // Non-nullable inner is required: nullable inners (lists, nested options)
            // would make None ≡ Some(empty/None), breaking the encoding.
            WType.Ref(innerIdx, true)
        | _ ->
            // Primitive inner type (I32/I64/F64) or already-nullable ref → wrapper struct.
            let key = wTypeKey innerWType
            match ctx.OptionRegistry.TryGetValue(key) with
            | true, idx -> WType.Ref(idx, true)
            | false, _ ->
                let typeIdx = ctx.TypeDefs.Count
                ctx.TypeDefs.Add(
                    { Name = $"Option_{typeIdx}"
                      Def = WTypeDef.Struct([{ Name = "value"; Type = innerWType; Mutable = false }], None) })
                ctx.OptionRegistry.[key] <- typeIdx
                WType.Ref(typeIdx, true)
    | Fable.Type.List(elementType) ->
        let elemWType = mapTypeKnown ctx elementType
        let key = wTypeKey elemWType
        if not (ctx.ListRegistry.ContainsKey(key)) then
            let typeIdx = ctx.TypeDefs.Count
            ctx.TypeDefs.Add(
                { Name = $"ListCons_{typeIdx}"
                  Def = WTypeDef.Struct(
                    [ { Name = "head"; Type = elemWType; Mutable = false }
                      { Name = "tail"; Type = WType.Ref(ListBaseTypeIdx, true); Mutable = false } ],
                    Some ListBaseTypeIdx) })
            ctx.ListRegistry.[key] <- typeIdx
        WType.Ref(ListBaseTypeIdx, true)
    | Fable.Type.Array(elementType, Fable.ArrayKind.ResizeArray) ->
        // ResizeArray<T> is backed by a growable struct { data; len }.
        let elemT = mapTypeKnown ctx elementType
        let (_, ravTypeIdx) = getOrAddResizeArrayType ctx elemT
        WType.Ref(ravTypeIdx, false)
    | Fable.Type.Array(elementType, _) ->
        let elemT = mapTypeKnown ctx elementType
        WType.Ref(getOrAddArrayType ctx elemT, false)
    | _ -> mapType t

let mapResultTypeKnown (ctx: Ctx) (t: Fable.Type) : WType =
    match t with
    | Fable.Type.Unit -> WType.Void
    | _ -> mapTypeKnown ctx t

// ─────────────────────────────────────────────────────────────────
// exprWType — get the WType of a WExpr
// ─────────────────────────────────────────────────────────────────

/// Lightweight helper — get the WType of a WExpr without going through the emitter.
let rec exprWType (expr: WExpr) : WType =
    match expr with
    | WExpr.Const(WConst.I32 _) -> WType.I32
    | WExpr.Const(WConst.I64 _) -> WType.I64
    | WExpr.Const(WConst.F32 _) -> WType.F32
    | WExpr.Const(WConst.F64 _) -> WType.F64
    | WExpr.Const(WConst.Unit) -> WType.Void
    | WExpr.Const(WConst.String _) -> WType.Ref(StringTypeIdx, false)
    | WExpr.Const(WConst.Null t) -> t
    | WExpr.LocalGet(_, t) -> t
    | WExpr.GlobalGet(_, t) -> t
    | WExpr.GlobalSet _ -> WType.Void
    | WExpr.Let(_, _, body) | WExpr.LetMut(_, _, body) -> exprWType body
    | WExpr.Assign _ -> WType.Void
    | WExpr.Call(_, _, t) -> t
    | WExpr.CallIndirect(_, _, t) -> t
    | WExpr.StructNew(_, _, t) -> t
    | WExpr.StructGet(_, _, t) -> t
    | WExpr.StructSet _ -> WType.Void
    | WExpr.ArrayNew(_, _, _, t) -> t
    | WExpr.ArrayNewFixed(_, _, t) -> t
    | WExpr.ArrayGet(_, _, t) -> t
    | WExpr.ArraySet _ -> WType.Void
    | WExpr.ArrayLen _ -> WType.I32
    | WExpr.ArrayCopy _ -> WType.Void
    | WExpr.If(_, _, _, t) -> t
    | WExpr.Loop(_, _, t) -> t
    | WExpr.Block(_, _, t) -> t
    | WExpr.Break _ | WExpr.Continue _ | WExpr.Return _ -> WType.Void
    | WExpr.Sequence exprs ->
        match exprs with
        | [] -> WType.Void
        | _ -> exprWType (List.last exprs)
    | WExpr.Nop -> WType.Void
    | WExpr.JoinPoint(_, _, _, _, t) -> t
    | WExpr.JoinApply(_, _, t) -> t
    | WExpr.SwitchInt(_, _, _, t) -> t
    | WExpr.TagOf _ -> WType.I32
    | WExpr.Cast(_, t) -> t
    | WExpr.Closure(_, _, t) -> t
    | WExpr.ClosureApply(_, _, _, _, _, t) -> t
    | WExpr.TailCall(_, _, t) -> t
    | WExpr.TailCallRef(_, _, _, _, _, t) -> t
    | WExpr.Unary(_, _, t) -> t
    | WExpr.Binary(_, _, _, t) -> t
    | WExpr.Compare _ -> WType.I32
    | WExpr.TryCatch(_, _, _, t) -> t
    | WExpr.Throw _ -> WType.Void
    | WExpr.CallVirtual(_, _, _, _, _, _, t) -> t
    | WExpr.FuncRef _ -> WType.Ref(AnyFnTypeIdx, false)  // funcref is a Ref to AnyFn
    | WExpr.RefIsNull _ -> WType.I32
    | WExpr.RefTest _ -> WType.I32

/// Function type alias used to pass `transformExpr` into replacement modules.
/// Breaking the mutual recursion via higher-order parameter.
type TransformFn = Ctx -> Fable.Expr -> WExpr
