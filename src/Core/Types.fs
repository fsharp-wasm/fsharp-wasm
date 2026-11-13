/// WasmGC context, type mapping, and exprWType utilities.
/// Extracted from Fable2Wasm.fs to keep concerns separated.
module WasmGc.Runtime.Types

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST

// module Fable = Fable.AST.Fable

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

/// Scope classification for identifier resolution in Phase 3.
type ScopeKind =
    | Local
    | FreeVar
    | ModuleValue
    | KnownFunc

/// Scope entry metadata for one identifier.
type ScopeEntry =
    {
        Kind: ScopeKind
        WType: WType
        Depth: int
    }

/// Per-function scope map: identifier name -> scope metadata.
type ScopeMap = Map<string, ScopeEntry>

type Ctx =
    {
        /// Currently known local variable types
        Locals: Map<string, WType>

        /// Phase 1 scope analysis result: function name -> scope map.
        ScopeMaps: Map<string, ScopeMap>

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
        /// Structural ordering functions (`$compare_N`), by struct / DU type index.
        CompareRegistry: System.Collections.Generic.Dictionary<int, string>
        /// Structural hash functions (`$hash_N`), by struct / DU / array type index — consistent with EqualityRegistry.
        HashRegistry: System.Collections.Generic.Dictionary<int, string>

        /// Generic MemberDecl bodies, pre-scanned before translation.
        /// Key: fully-qualified F# function name (e.g. "MyModule.swap")
        /// Value: (per-file Compiler instance, Fable MemberDecl as obj)
        /// The per-file Compiler is needed for cross-file entity lookups during specialization.
        // NOTE: Ctx must reference ICompiler for `com.GetImportedModule` and error reporting.
        // To reduce this coupling, extract a minimal ICompilerServices interface from ICompiler
        // and depend on that instead. Track in issue: decouple-ctx-from-compiler.
        // TODO: we shouldn't reference the full Compiler
        GenericFuncRegistry: System.Collections.Generic.Dictionary<string, ICompilerCore * obj>

        /// Cache of already-emitted or in-progress specializations.
        /// Key = mangled name (e.g. "MyModule.swap|i32,ref1"); Value = same mangled name (sentinel).
        MonoCache: System.Collections.Generic.Dictionary<string, string>

        /// Active type substitution during specialized translation.
        /// Empty outside generic function bodies.
        /// Key: F# generic param name ("T", "U", ...); Value: concrete WType.
        TypeSubst: Map<string, WType>
        /// Mutable locals that a closure captures AND something assigns: name → the type of the value.  They live in a
        /// shared ref cell (`Locals` holds the cell), read through `struct.get` and written through `struct.set`.
        BoxedLocals: Map<string, WType>

        /// Compiler reference for diagnostics
        Compiler: ICompilerCore

        // ── Multi-file / library-compilation support ──────────────────────────
        /// True when compiling a non-last file (library context).
        /// Library functions get module-qualified names and are not exported.
        IsLibraryContext: bool
        /// Top-level functions of the file being compiled are wasm exports.  False for the files of a referenced
        /// project (a runtime library): their functions are internal, and are dropped when unreachable.
        ExportFunctions: bool

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

        /// Module-level `let mutable x = …`: qualified name → declared (non-null) WType.  Kept in a wasm global; the
        /// initialisers run, in declaration order, in the start function `$__init`.
        MutableGlobals: System.Collections.Generic.Dictionary<string, WType>
        GlobalDecls: ResizeArray<WGlobalDecl>
        InitSteps: ResizeArray<WExpr>
        /// Names assigned anywhere (`x <- …` on an identifier): a module value among them is a mutable global.
        AssignedIdents: System.Collections.Generic.HashSet<string>

        /// Constructors of generic classes (ctor function name → declaring compiler, class declaration): a generic class is
        /// instantiated per type-argument list, its constructor included.
        GenericCtors: System.Collections.Generic.Dictionary<string, ICompilerCore * Fable.ClassDecl>

        /// Host callbacks (function-typed arguments of JS imports): signature key → index into `CallbackTramps`.
        CallbackSigs: System.Collections.Generic.Dictionary<string, int>
        /// Per callback signature: (trampoline function name, number of boxed JS arguments it takes).
        CallbackTramps: ResizeArray<string * int>

        /// ResizeArray element WType key → (arrTypeIdx, ravTypeIdx).
        /// ravTypeIdx: index of struct { data: (mut ref? $Arr_T); len: (mut i32) }.
        ResizeArrayRegistry: System.Collections.Generic.Dictionary<string, int * int>

        /// Monotonically increasing counter for generating globally-unique decision-tree target labels.
        /// Shared (mutable ref cell) so nested transformDecisionTree calls don't collide.
        DecisionTreeCounter: int ref

        /// The base offset for the current DecisionTree being translated.
        /// Set by transformDecisionTree before processing matchExpr so that
        /// DecisionTreeSuccess(localIdx) → JoinApply("$target_{TargetBase + localIdx}").
        /// Saved/restored around nested DecisionTree calls (LIFO via mutable mutation).
        TargetBase: int ref

        /// Set to true when any wasm:memory intrinsic is lowered in this compilation.
        /// Controls whether a linear memory section is emitted in the output.
        HasLinearMemory: bool ref

        /// Monotonically increasing counter for generating globally-unique closure names.
        /// Shared (mutable ref cell) so multiple closure variants don't get duplicate names.
        ClosureCounter: int ref

        /// Structured diagnostic accumulator — collect errors/warnings with source locations.
        /// Replaces scattered eprintfn calls. Flushed and checked before WASM emit.
        Diagnostics: WasmGc.Core.Diagnostics.DiagnosticBag
    }

    static member Create(com: ICompilerCore, ?stringMode: StringMode) =
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
            ScopeMaps = Map.empty
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
            CompareRegistry = System.Collections.Generic.Dictionary<int, string>()
            HashRegistry = System.Collections.Generic.Dictionary<int, string>()
            GenericFuncRegistry = System.Collections.Generic.Dictionary<string, ICompilerCore * obj>()
            MonoCache = System.Collections.Generic.Dictionary<string, string>()
            TypeSubst = Map.empty
            BoxedLocals = Map.empty
            Compiler = com
            IsLibraryContext = false
            ExportFunctions = true
            CurrentFileStem = ""
            NamePrefix = ""
            FuncNameAlias = Map.empty
            KnownFuncsByPath = Map.empty
            ExternImports = System.Collections.Concurrent.ConcurrentDictionary<string, WImport>()
            StringMode = stringMode
            VTableRegistry = System.Collections.Generic.Dictionary<string, int * int * int list * string list>()
            VTableImplRegistry = System.Collections.Generic.Dictionary<string * string, string>()
            VTableGlobals = new ResizeArray<WGlobalDecl>()
            MutableGlobals = System.Collections.Generic.Dictionary<string, WType>()
            GlobalDecls = new ResizeArray<WGlobalDecl>()
            InitSteps = new ResizeArray<WExpr>()
            AssignedIdents = System.Collections.Generic.HashSet<string>()
            GenericCtors = System.Collections.Generic.Dictionary<string, ICompilerCore * Fable.ClassDecl>()
            CallbackSigs = System.Collections.Generic.Dictionary<string, int>()
            CallbackTramps = new ResizeArray<string * int>()
            ResizeArrayRegistry = System.Collections.Generic.Dictionary<string, int * int>()
            DecisionTreeCounter = ref 0
            TargetBase = ref 0
            HasLinearMemory = ref false
            ClosureCounter = ref 0
            Diagnostics     = WasmGc.Core.Diagnostics.DiagnosticBag()
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

/// Is `path` a source file of the core library (FSharp.Wasm.Core, the directory the compiler was given as its library) or of
/// a package that was fetched for the program (`fable_modules`)?  Such files are compiled like the program's but are not
/// its exports, and the program's own functions must not capture their names.
/// (`LibraryDir` is relative to the directory of the file being compiled, hence the `CurrentFile`.)
let isCoreLibraryFile (com: ICompilerCore) (path: string) : bool =
    let full (p: string) = (try System.IO.Path.GetFullPath p with _ -> p).Replace('\\', '/')
    let libraryDir =
        if System.String.IsNullOrEmpty com.LibraryDir || com.LibraryDir = "." then ""
        else full (System.IO.Path.Combine(System.IO.Path.GetDirectoryName com.CurrentFile, com.LibraryDir))
    let file = full path
    file.Contains("fable_modules", System.StringComparison.OrdinalIgnoreCase)
    || (libraryDir <> "" && file.StartsWith(libraryDir.TrimEnd('/') + "/", System.StringComparison.OrdinalIgnoreCase))

/// Full type name for FSharpRef (used to detect ref cell types)
let [<Literal>] FSharpRefFullName = "Microsoft.FSharp.Core.FSharpRef`1"

/// A ref cell or a byref / outref / inref to one: all are the same single-field box (`d.TryGetValue(k, &v)` hands over
/// the cell of `v`).
let isRefCellEntity (fullName: string) =
    fullName = FSharpRefFullName
    || fullName.StartsWith("Microsoft.FSharp.Core.byref`", System.StringComparison.Ordinal)
    || fullName.StartsWith("Microsoft.FSharp.Core.outref`", System.StringComparison.Ordinal)
    || fullName.StartsWith("Microsoft.FSharp.Core.inref`", System.StringComparison.Ordinal)

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
let getOrAddArrayType (ctx: Ctx) (elemType: WType) : int =
    // reference elements are stored nullable: an array can be created before its elements exist
    let elemT = match elemType with WType.Ref(idx, _) -> WType.Ref(idx, true) | t -> t
    let key = $"GcArr_{wTypeKey elemT}"
    match ctx.ArrayRegistry.TryGetValue(key) with
    | true, idx -> idx
    | false, _ ->
        let idx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add({ Name = $"GcArray_{idx}"; Def = WTypeDef.Array(elemT, true) })
        ctx.ArrayRegistry.[key] <- idx
        idx

/// Resolve a generic DU instance key to its registered GC type index.
/// Key format: "FullName<wTypeKey1,wTypeKey2,...>" — built in mapTypeKnown for generic args.
let getOrAddOptionType (ctx: Ctx) (elemT: WType) =
    let key = wTypeKey elemT
    match ctx.OptionRegistry.TryGetValue(key) with
    | true, idx -> idx
    | false, _ ->
        let idx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add({ Name = $"Option_{idx}"; Def = WTypeDef.Struct([{ Name = "value"; Type = elemT; Mutable = false }], None) })
        ctx.OptionRegistry.[key] <- idx
        idx

/// How an option of `elemT` is represented → (option type, `Some`, `None`).
/// A non-null reference is its own Some (None = null); everything else — numbers, nullable references, nested
/// options — is boxed in `Option_N { value }` (None = null box).
let optionRepr (ctx: Ctx) (elemT: WType) : WType * (WExpr -> WExpr) * WExpr =
    match elemT with
    | WType.Ref(idx, false) ->
        let t = WType.Ref(idx, true)
        t, id, WExpr.Const(WConst.Null t)
    | _ ->
        let idx = getOrAddOptionType ctx elemT
        let t = WType.Ref(idx, true)
        t, (fun v -> WExpr.StructNew(idx, [ v ], t)), WExpr.Const(WConst.Null t)

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

// ─────────────────────────────────────────────────────────────────
// Closure ABI — single source of truth
// ─────────────────────────────────────────────────────────────────
//
// Every closure value is a struct that is a subtype of `$AnyFn` and has the code
// pointer in field 0.  The code pointer has the func type
//
//        (self: ref $AnyFn, a1: T1, ..., an: Tn) -> R          (void Ti dropped)
//
// ONE `ClosureBase_k` struct (code: ref $FT) exists per func type `$FT`; every
// concrete closure struct of that signature is a subtype of it, so a single
// `ref.cast (ref $ClosureBase_k)` is valid for ALL closures of that signature.

/// The `self` parameter type of every closure function.
let closureSelfTy = WType.Ref(AnyFnTypeIdx, false)

/// Func type of a closure with the given (possibly void-containing) args and result.
let closureFuncType (ctx: Ctx) (argTys: WType list) (ret: WType) : int =
    ctx.GetOrAddFuncType(closureSelfTy :: (argTys |> List.filter (fun t -> t <> WType.Void)), ret)

/// Get or create the ClosureBase struct for a func type.
let getOrAddClosureBase (ctx: Ctx) (funcTypeIdx: int) : int =
    match ctx.ClosureBaseTypeMap.TryGetValue funcTypeIdx with
    | true, idx -> idx
    | false, _ ->
        let idx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add
            { Name = $"ClosureBase_{idx}"
              Def =
                WTypeDef.Struct(
                    [ { Name = "code"; Type = WType.Ref(funcTypeIdx, false); Mutable = false } ],
                    Some AnyFnTypeIdx
                ) }
        ctx.ClosureBaseTypeMap.[funcTypeIdx] <- idx
        ctx.FuncTypeToClosureMap.[funcTypeIdx] <- idx
        idx

/// Type mapping that resolves declared (record/DU) types via the context's type registry.
let rec mapTypeKnown (ctx: Ctx) (t: Fable.Type) : WType =
    match t with
    // Resolve generic parameters from active type substitution (Sprint 5: monomorphization)
    | Fable.Type.GenericParam(name, _, _) ->
        match Map.tryFind name ctx.TypeSubst with
        | Some wty -> wty
        | None -> WType.I32  // unresolved — not inside a specialized body
    | Fable.Type.DeclaredType(entRef, genericArgs) when isRefCellEntity entRef.FullName ->
        let innerT = match genericArgs with | [t] -> mapTypeKnown ctx t | _ -> WType.I32
        WType.Ref(getOrAddRefCellType ctx innerT, false)
    // KeyValuePair<'K,'V> is a pair, like in Fable (`kv.Key` / `kv.Value` read the items; the constructor makes the tuple)
    | Fable.Type.DeclaredType(entRef, [ k; v ]) when entRef.FullName = "System.Collections.Generic.KeyValuePair`2" ->
        mapTypeKnown ctx (Fable.Type.Tuple([ k; v ], false))
    // StringBuilder: always maps to the pre-registered $StringBuilder struct
    | Fable.Type.DeclaredType(entRef, _) when entRef.FullName = "System.Text.StringBuilder" ->
        WType.Ref(StringBuilderTypeIdx, false)
    // `seq<'T>` is a (strict) list: the Seq handlers already read a seq-typed value as a list, a list is a seq as is, and
    // an array or other collection passed as a seq is converted where it is coerced (`toSeqList`)
    | Fable.Type.DeclaredType(entRef, [ elem ]) when entRef.FullName = "System.Collections.Generic.IEnumerable`1" ->
        mapTypeKnown ctx (Fable.Type.List elem)
    | Fable.Type.DeclaredType(entRef, genericArgs) ->
        // Try the generic instance key first (for on-demand registered DUs like Result<T,E>)
        if not genericArgs.IsEmpty then
            let argKeys = genericArgs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
            let instKey = $"{entRef.FullName}<{argKeys}>"
            match ctx.GenericDuRegistry.TryGetValue(instKey) with
            | true, idx -> WType.Ref(idx, false)
            | false, _ ->
                // A generic RECORD gets one struct per instantiation (Box<int>, Box<float>, … differ in their fields)
                match registerGenericRecord ctx entRef genericArgs instKey with
                | Some idx -> WType.Ref(idx, false)
                | None ->
                match registerGenericClass ctx entRef genericArgs instKey with
                | Some idx -> WType.Ref(idx, false)
                | None ->
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
    // an anonymous record is a tuple of its fields (F# keeps them sorted by name, so the order is canonical)
    | Fable.Type.AnonymousRecordType(_, fieldTypes, isStruct) -> mapTypeKnown ctx (Fable.Type.Tuple(fieldTypes, isStruct))
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
                      { Name = "tail"; Type = WType.Ref(ListBaseTypeIdx, true); Mutable = true } ],
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


/// On-demand struct for ONE instantiation of a generic class (`Stack<'T>`), when the class was compiled from source: its
/// fields with the class's type parameters bound to the (already mapped) type arguments.  Reference fields are stored
/// nullable and every field is mutable — the constructor body assigns them.  `None` for anything else.
and registerGenericClass (ctx: Ctx) (entRef: Fable.EntityRef) (genericArgs: Fable.Type list) (instKey: string) : int option =
    if not (Map.containsKey entRef.FullName ctx.TypeRegistry) then None else
    let ent = try Some(ctx.Compiler.GetEntity entRef) with _ -> None
    match ent with
    | Some ent when not ent.IsFSharpRecord && not ent.IsFSharpUnion && not ent.IsInterface
                    && ent.GenericParameters.Length = genericArgs.Length
                    && (match ent.BaseType with None -> true | Some b -> b.Entity.FullName = "System.Object") ->
        let idx = ctx.TypeDefs.Count
        ctx.GenericDuRegistry.[instKey] <- idx
        ctx.TypeDefs.Add({ Name = instKey; Def = WTypeDef.Struct([], None) })   // slot, filled below
        let subst =
            (ent.GenericParameters |> List.map (fun p -> p.Name), genericArgs |> List.map (mapTypeKnown ctx))
            ||> List.zip |> Map.ofList
        let inner = { ctx with TypeSubst = subst }
        let fields =
            ent.FSharpFields
            |> List.map (fun f ->
                let ty = match mapTypeKnown inner f.FieldType with WType.Ref(i, _) -> WType.Ref(i, true) | t -> t
                { Name = f.Name; Type = ty; Mutable = true })
        ctx.TypeDefs.[idx] <- { Name = instKey; Def = WTypeDef.Struct(fields, None) }
        Some idx
    | _ -> None

/// On-demand struct for ONE instantiation of a generic record: the fields are mapped with the record's type
/// parameters bound to the (already mapped) type arguments.  `None` when `entRef` is not a generic record.
and registerGenericRecord (ctx: Ctx) (entRef: Fable.EntityRef) (genericArgs: Fable.Type list) (instKey: string) : int option =
    let ent = try Some(ctx.Compiler.GetEntity entRef) with _ -> None
    match ent with
    | Some ent when ent.IsFSharpRecord && ent.GenericParameters.Length = genericArgs.Length ->
        let idx = ctx.TypeDefs.Count
        ctx.GenericDuRegistry.[instKey] <- idx                         // first: a recursive field finds itself
        ctx.TypeDefs.Add({ Name = instKey; Def = WTypeDef.Struct([], None) })   // slot, filled below
        let subst =
            (ent.GenericParameters |> List.map (fun p -> p.Name), genericArgs |> List.map (mapTypeKnown ctx))
            ||> List.zip |> Map.ofList
        let inner = { ctx with TypeSubst = subst }
        let fields = ent.FSharpFields |> List.map (fun f -> { Name = f.Name; Type = mapTypeKnown inner f.FieldType; Mutable = f.IsMutable })
        ctx.TypeDefs.[idx] <- { Name = instKey; Def = WTypeDef.Struct(fields, None) }
        Some idx
    | _ -> None

/// Struct type index of a declared (record / class) type — of its INSTANTIATION when it is generic.
let declaredStructIdx (ctx: Ctx) (t: Fable.Type) : int option =
    match t with
    | Fable.Type.DeclaredType(entRef, _) when Map.containsKey entRef.FullName ctx.TypeRegistry ->
        (match mapTypeKnown ctx t with WType.Ref(idx, _) -> Some idx | _ -> None)
    | _ -> None

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
    | WExpr.Const(WConst.I32 _)               -> WType.I32
    | WExpr.Const(WConst.I64 _)               -> WType.I64
    | WExpr.Const(WConst.F32 _)               -> WType.F32
    | WExpr.Const(WConst.F64 _)               -> WType.F64
    | WExpr.Const(WConst.String _)            -> WType.Ref(StringTypeIdx, false)
    | WExpr.Const(WConst.Null ty)             -> ty
    | WExpr.Const(WConst.Unit)                -> WType.Void
    | WExpr.LocalGet(_, ty)                   -> ty
    | WExpr.GlobalGet(_, ty)                  -> ty
    | WExpr.Let(_, _, body)                   -> exprWType body
    | WExpr.LetMut(_, _, body)                -> exprWType body
    | WExpr.Assign _                          -> WType.Void
    | WExpr.GlobalSet _                       -> WType.Void
    | WExpr.Call(_, _, ty)                    -> ty
    | WExpr.CallIndirect(_, _, ty)            -> ty
    | WExpr.CallVirtual(_, _, _, _, _, _, ty) -> ty
    | WExpr.FuncRef _                         -> WType.Ref(AnyFnTypeIdx, false)
    | WExpr.StructNew(_, _, ty)               -> ty
    | WExpr.StructGet(_, _, ty)               -> ty
    | WExpr.StructSet _                       -> WType.Void
    | WExpr.ArrayNew(_, _, _, ty)             -> ty
    | WExpr.ArrayNewFixed(_, _, ty)           -> ty
    | WExpr.ArrayGet(_, _, ty)                -> ty
    | WExpr.ArraySet _                        -> WType.Void
    | WExpr.ArrayLen _                        -> WType.I32
    | WExpr.ArrayCopy _                       -> WType.Void
    | WExpr.If(_, _, _, ty)                   -> ty
    | WExpr.Loop(_, _, ty)                    -> ty
    | WExpr.Block(_, _, ty)                   -> ty
    | WExpr.Break _                           -> WType.Void
    | WExpr.Continue _                        -> WType.Void
    | WExpr.Return _                          -> WType.Void
    | WExpr.Sequence []                       -> WType.Void
    | WExpr.Sequence xs                       -> exprWType (List.last xs)
    | WExpr.Nop                               -> WType.Void
    | WExpr.JoinPoint(_, _, _, _, ty)         -> ty
    | WExpr.JoinApply(_, _, ty)               -> ty
    | WExpr.SwitchInt(_, _, _, ty)            -> ty
    | WExpr.TagOf _                           -> WType.I32
    | WExpr.Cast(_, ty)                       -> ty
    | WExpr.RefIsNull _                       -> WType.I32
    | WExpr.RefTest _                         -> WType.I32
    | WExpr.Closure(_, _, ty)                 -> ty
    | WExpr.ClosureApply(_, _, _, _, _, ty)   -> ty
    | WExpr.Unary(_, _, ty)                   -> ty
    | WExpr.Binary(_, _, _, ty)               -> ty
    | WExpr.Compare _                         -> WType.I32
    | WExpr.TailCall(_, _, ty)                -> ty
    | WExpr.TailCallRef(_, _, _, _, _, ty)    -> ty
    | WExpr.CallRef(_, _, _, ty)              -> ty
    | WExpr.ReturnCallRef(_, _, _, ty)        -> ty
    | WExpr.TryCatch(_, _, _, ty)             -> ty
    | WExpr.Throw _                           -> WType.Void
    | WExpr.MemLoad(WMemKind.I64, _, _)       -> WType.I64
    | WExpr.MemLoad(WMemKind.F32, _, _)       -> WType.F32
    | WExpr.MemLoad(WMemKind.F64, _, _)       -> WType.F64
    | WExpr.MemLoad _                         -> WType.I32
    | WExpr.MemStore _                        -> WType.Void
    | WExpr.MemorySize                        -> WType.I32
    | WExpr.MemoryGrow _                      -> WType.I32

/// Function type alias used to pass `transformExpr` into replacement modules.
/// Breaking the mutual recursion via higher-order parameter.
type TransformFn = Ctx -> Fable.Expr -> WExpr


