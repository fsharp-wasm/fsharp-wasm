/// Test helpers for WasmGC compiler unit tests.
/// makeTestCtx creates a real Ctx via Ctx.Create using a NullCompiler stub.
/// All field names, type indices, and helper functions match the actual source.
module Tests.WasmTestHelper

open System
open Expecto
open Fable
open Fable.AST
open WasmGc.Core.AST
open WasmGc.Runtime.Types

let mockEntity (fullName: string) =
    { new Fable.AST.Fable.Entity with
        member _.Ref = { FullName = fullName; Path = Fable.AST.Fable.SourcePath "" }
        member _.FullName = fullName
        member _.DisplayName = fullName
        member _.CompiledName = fullName
        member _.Attributes = Seq.empty
        member _.MembersFunctionsAndValues = Seq.empty
        member _.AllInterfaces = Seq.empty
        member _.DeclaredInterfaces = Seq.empty
        member _.FSharpFields = []
        member _.UnionCases = []
        member _.GenericParameters = []
        member _.BaseType = None
        member _.DeclaringEntity = None
        member _.TryFindMember(_) = None
        member _.IsPublic = true
        member _.IsPrivate = false
        member _.IsInternal = false
        member _.IsNamespace = false
        member _.IsFSharpModule = false
        member _.IsFSharpUnion = false
        member _.IsFSharpRecord = false
        member _.IsFSharpAbbreviation = false
        member _.IsFSharpExceptionDeclaration = false
        member _.IsValueType = false
        member _.IsInterface = false
        member _.IsMeasure = false
        member _.IsByRef = false
        member _.IsEnum = false
        member _.IsAbstractClass = false }

// ─────────────────────────────────────────────────────────────────
// NullCompiler — minimal Fable.Compiler stub for tests
// ─────────────────────────────────────────────────────────────────
type NullCompiler() =
    interface Fable.Compiler with
        member _.Options =
          CompilerOptionsHelper.Make(debugMode = false, typedArrays = false)
          // CompilerOptionsHelper.Make(debugMode = false, typedArrays = true)
          // { Fable.CompilerOptions.Default with
          //     DebugMode = false
          //     TypedArrays = true
          //     Watch = false
          //     Language = Fable.Language.WasmGc
          //     FileExtension = ".fs"
          //     Define = []
          //     Optimize = false
          //     SourceMaps = false
          //     Clamp = false }

        // Fable 5: Plugins is a record, not a list
        member _.Plugins =
          { MemberDeclarationPlugins = Map.empty }
          // Fable.CompilerPlugins.Default
          // { MemberDeclarationPlugins = []
          //   PluginPlugins = [] }

        member _.LibraryDir = ""
        member _.CurrentFile = "<test>"
        member _.SourceFiles = [||]
        // member _.GetEntity(_) = failwith "Not implemented"
        // member _.GetEntity(entityRef: Fable.EntityRef): Fable.Entity =
        //     failwith $"Test error: Tried to look up entity {entityRef.FullName}"

        member _.OutputDir = None
        member _.OutputType = OutputType.Exe // Or Library depending on Fable version
        member _.ProjectFile = ""
        member _.ProjectOptions = Unchecked.defaultof<_> // Stub for FSharpProjectOptions
        member _.IncrementCounter() = 0
        member _.IsPrecompilingInlineFunction = false
        member _.WillPrecompileInlineFunction(_file) = failwith "Not implemented"

        member _.GetImplementationFile(_fileName) = []
        member _.GetRootModule(fileName) = (fileName, None)

        member _.TryGetEntity(entityRef) =
            // We can reuse the logic from your previous GetEntity here
            // but wrapped in Some() since this is TryGetEntity
            None

        member _.GetInlineExpr(_str) = failwith "Not implemented"
        member _.AddWatchDependency(_file) = ()

        // member _.GetEntity(entityRef: Fable.EntityRef) =
        //     // { FullName = entityRef.FullName
        //     //   Path = entityRef.Path
        //     //   BaseEntity = None
        //     //   AllInterfaces = []
        //     //   Attributes = []
        //     //   IsValueType = false
        //     //   IsInterface = false
        //     //   IsEnum = false
        //     //   IsFSharpUnion = false
        //     //   IsFSharpRecord = false
        //     //   IsFSharpModule = false
        //     //   MembersFunctionsAndValues = [] }

        //     { new Fable.Entity with
        //         member _.FullName = entityRef.FullName
        //         member _.Path = entityRef.Path
        //         member _.BaseEntity = None
        //         member _.AllInterfaces = [||]
        //         member _.Attributes = [||]
        //         member _.IsValueType = false
        //         member _.IsInterface = false
        //         member _.IsEnum = false
        //         member _.IsFSharpUnion = false
        //         member _.IsFSharpRecord = false
        //         member _.IsFSharpModule = false
        //         member _.MembersFunctionsAndValues = [||] }

        // member _.GetImplementation(_) = None
        // member _.GetRootModule(_) = ("", None)

        member _.AddLog(msg, severity, ?range, ?fileName, ?tag) =
            printfn "[%A] %s" severity msg

        // member _.GetOrAddInlineExpr(fullName, factory) = factory ()

        // member _.DefineDeclaration(_) = ()
        // member _.GetImportExpr(r, t, selector, path, kind) =
        //     Fable.Expr.Value(Fable.Value.StringConstant selector, r) // Minimal stub

// ─────────────────────────────────────────────────────────────────
// wTypeKey — mirrors Wat.fs (needed for registry key lookups in tests)
// Defined here independently so test helpers don't depend on the Wat module.
// ─────────────────────────────────────────────────────────────────

let rec wTypeKey (t: WType) : string =
    match t with
    | WType.I32             -> "i32"
    | WType.I64             -> "i64"
    | WType.F32             -> "f32"
    | WType.F64             -> "f64"
    | WType.I16             -> "i16"
    | WType.Void            -> "void"
    | WType.Externref       -> "extern"
    | WType.I31ref          -> "i31"
    | WType.EqRef           -> "eqref"
    | WType.AnyRef          -> "anyref"
    | WType.Ref(idx, false) -> sprintf "ref%d"     idx
    | WType.Ref(idx, true)  -> sprintf "refnull%d" idx
    | WType.Func(ps, rs) ->
        let pk = ps |> List.map wTypeKey |> String.concat ","
        let rk = rs |> List.map wTypeKey |> String.concat ","
        sprintf "fn(%s)->(%s)" pk rk
    | WType.Struct fields ->
        // let fk = fields |> List.map (fun (f: wStructField) -> sprintf "%s:%s" f.Name (wTypeKey f.Type)) |> String.concat ";"
        let fk = fields |> List.map (fun f -> sprintf "%s:%s" f.Name (wTypeKey f.Type)) |> String.concat ";"
        sprintf "struct{%s}" fk
    | WType.Array(elem, mut_) ->
        sprintf "arr_%s_%s" (if mut_ then "mut" else "imm") (wTypeKey elem)

// ─────────────────────────────────────────────────────────────────
// Auto-flushing test wrapper — captures diagnostics in test output
// ─────────────────────────────────────────────────────────────────

module AutoFlushDiagnostics =
    let private contexts = System.Collections.Concurrent.ConcurrentBag<Ctx>()
    
    /// Create a context and register it for auto-flushing.
    let makeContext () : Ctx =
        let ctx = Ctx.Create(NullCompiler() :> Fable.Compiler)
        contexts.Add(ctx)
        ctx
    
    /// Flush all accumulated diagnostics from all contexts.
    let flushAll () =
        for ctx in contexts do
            if ctx.Diagnostics.Count > 0 then
                ctx.Diagnostics.Flush()
    
    /// Wrap a test function to auto-flush diagnostics after execution.
    /// Usage in tests: 
    ///   AutoFlushDiagnostics.wrapTest "My test" {
    ///       let ctx = makeTestCtx()
    ///       // do test...
    ///   }
    let wrapTest (testName: string) (testFn: unit -> 'T) : unit -> 'T =
        fun () ->
            try
                testFn ()
            finally
                flushAll ()
    
    /// Register a process-exit handler to flush any remaining diagnostics
    do
        System.AppDomain.CurrentDomain.ProcessExit.Add(fun _ ->
            try flushAll () with _ -> ())

/// Finalizer wrapper for contexts — ensures diagnostics are flushed when context is GC'd.
/// This provides automatic flushing even if the context goes out of scope unexpectedly.
type internal ContextFinalizer(ctx: Ctx) =
    override _.Finalize() =
        try
            if ctx.Diagnostics.Count > 0 then
                ctx.Diagnostics.Flush()
        with _ -> ()

// ─────────────────────────────────────────────────────────────────
// Disposable context wrapper — auto-flush diagnostics on disposal
// ─────────────────────────────────────────────────────────────────

/// Wrapper that auto-flushes diagnostics when disposed.
/// Use with `use` keyword in tests for automatic flushing.
type AutoFlushContext(ctx: Ctx) =
    member _.Ctx = ctx
    interface System.IDisposable with
        member _.Dispose() =
            if ctx.Diagnostics.Count > 0 then
                ctx.Diagnostics.Flush()

/// Create a context that auto-flushes on disposal.
/// Use with: use ctx = makeAutoFlushCtx(); let wctx = ctx.Ctx in ...
let makeAutoFlushCtx () : AutoFlushContext =
    new AutoFlushContext(Ctx.Create(NullCompiler() :> Fable.Compiler))

let private allTestContexts = System.Collections.Generic.List<Ctx>()

/// Flush diagnostics from all test contexts created during the test run.
let flushAllDiagnostics () =
    for ctx in allTestContexts do
        if ctx.Diagnostics.Count > 0 then
            ctx.Diagnostics.Flush()
    allTestContexts.Clear()

/// Call this at the end of your test module to ensure all diagnostics are flushed.
/// This is especially important for integration tests that compile code.
let flushTestDiagnostics () =
    // First, flush accumulated diagnostics
    flushAllDiagnostics()
    // Then, force garbage collection to run any remaining finalizers
    System.GC.Collect()
    System.GC.WaitForPendingFinalizers()

// ─────────────────────────────────────────────────────────────────
// makeTestCtx — creates a real Ctx with the four pre-registered types
// ─────────────────────────────────────────────────────────────────

/// Build a fresh Ctx for unit tests.
/// Identical to the production pipeline init — same 4 pre-registered types:
///   index 0 = $AnyFn  (struct {} — base for all closures)
///   index 1 = $WasmStr (array (mut i32) — UTF-16 string)
///   index 2 = $ListBase (struct {} — base for all list cons types)
///   index 3 = $StringBuilder (struct { data; length; capacity })
///
/// NOTE: Each context created by this function has diagnostics auto-flushing
/// attached via a finalizer. When the context is garbage collected, any
/// accumulated diagnostics will be flushed to stderr.
let makeTestCtx () : Ctx =
    let ctx = Ctx.Create(NullCompiler() :> Fable.Compiler)
    allTestContexts.Add(ctx)  // Auto-track for diagnostics flushing
    // Attach a finalizer so diagnostics are flushed when context is GC'd
    ignore (new ContextFinalizer(ctx))
    ctx

/// Ctx with specific Locals pre-added (for tests that inspect IdentExpr handling).
let makeCtxWithLocals (locals: (string * WType) list) : Ctx =
    locals |> List.fold (fun ctx (n, t) -> ctx.WithLocal(n, t)) (makeTestCtx ())

/// Ctx with specific zero-arg KnownFuncs pre-added (for CE builder / module-value tests).
let makeCtxWithModuleValues (vals: (string * WType) list) : Ctx =
    let ctx = makeTestCtx ()
    let kf  = vals |> List.map (fun (n, retT) -> n, ([], retT)) |> Map.ofList
    { ctx with KnownFuncs = kf }

/// Ctx with full KnownFuncs entries (name, paramTypes, retType).
let makeCtxWithFuncs (funcs: (string * WType list * WType) list) : Ctx =
    let ctx = makeTestCtx ()
    let kf  = funcs |> List.map (fun (n, ps, r) -> n, (ps, r)) |> Map.ofList
    { ctx with KnownFuncs = kf }

/// Ctx with both Locals and KnownFuncs.
let makeCtxFull
        (locals : (string * WType) list)
        (funcs  : (string * WType list * WType) list)
        : Ctx =
    let ctx = makeTestCtx ()
    let kf  = funcs |> List.map (fun (n, ps, r) -> n, (ps, r)) |> Map.ofList
    let ctx' = locals |> List.fold (fun (c: Ctx) (n, t) -> c.WithLocal(n, t)) ctx
    { ctx' with KnownFuncs = kf }

// ─────────────────────────────────────────────────────────────────
// Auto-flushing context wrapper — ensures diagnostics are printed
// even when contexts go out of scope in tests
// ─────────────────────────────────────────────────────────────────

/// Wrap a test function to auto-flush diagnostics after execution.
/// This ensures that any warnings/errors accumulated during the test
/// are printed to stderr, even if the test passes.
let withAutoFlushDiagnostics (testFn: Ctx -> 'T) : 'T =
    let ctx = makeTestCtx ()
    try
        testFn ctx
    finally
        // Always flush diagnostics, even on exception
        ctx.Diagnostics.Flush()

/// Same as withAutoFlushDiagnostics but for a test that creates its own context.
/// Call ctx.Diagnostics.Flush() in the finally block of your test.
let autoFlushAfterTest (testFn: unit -> 'T) (ctxToFlush: Ctx) : 'T =
    try
        testFn ()
    finally
        ctxToFlush.Diagnostics.Flush()

// ─────────────────────────────────────────────────────────────────
// mapTypeKnown re-export — tests call it directly from Types module
// ─────────────────────────────────────────────────────────────────

// mapTypeKnown is defined in Types.fs, imported via:
//   open WasmGc.Runtime.Types
// Tests call it as: mapTypeKnown ctx fableType

// ─────────────────────────────────────────────────────────────────
// WExpr builders (convenience for test setup)
// ─────────────────────────────────────────────────────────────────

open WasmGc.Builder.Core

let inline i32Const  n    = WExpr.Const(WConst.I32 n)
let inline i64Const  n    = WExpr.Const(WConst.I64 n)
let inline f32Const  v    = WExpr.Const(WConst.F32 v)
let inline f64Const  v    = WExpr.Const(WConst.F64 v)
let inline nullRef   ty   = WExpr.Const(WConst.Null ty)
let inline nullList  ()   = WExpr.Const(WConst.Null(WType.Ref(ListBaseTypeIdx, true)))
let inline anyRef    ()   = WType.Ref(AnyFnTypeIdx, false)

let inline localGet  name ty = WExpr.LocalGet(name, ty)
let inline localSet  name v  = WExpr.Assign(name, v)

// ─────────────────────────────────────────────────────────────────
// buildArityIndex — for Validator tests
// ─────────────────────────────────────────────────────────────────

/// Build funcTypeIdx → expected param count map from a TypeDefs list.
let buildArityIndex (typeDefs: System.Collections.Generic.List<WTypeDeclEntry>) : Map<int, int> =
    typeDefs
    |> Seq.mapi (fun i e -> i, e)
    |> Seq.choose (fun (i, e) ->
        match e.Def with
        | WTypeDef.Func(ps, _) -> Some(i, ps.Length)
        | _ -> None)
    |> Map.ofSeq

// ─────────────────────────────────────────────────────────────────
// WExprQuery — traversal, collection, rewrite
// ─────────────────────────────────────────────────────────────────

module WExprQuery =

    let children (expr: WExpr) : WExpr list =
        match expr with
        | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b)                 -> [v; b]
        | WExpr.If(c, t, e, _)                                       -> [c; t; e]
        | WExpr.Sequence xs                                          -> xs
        | WExpr.Block(_, b, _) | WExpr.Loop(_, b, _)                 -> [b]
        | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _)        -> args
        | WExpr.ClosureApply(c, args, _, _, _, _)                    -> c :: args
        | WExpr.TailCallRef(c, args, _, _, _, _)                     -> c :: args
        | WExpr.ArrayNew(_, s, init, _)                              -> [s; init]
        | WExpr.ArrayNewFixed(_, es, _)                              -> es
        | WExpr.ArrayGet(a, i, _)                                    -> [a; i]
        | WExpr.ArraySet(a, i, v)                                    -> [a; i; v]
        | WExpr.ArrayLen e                                           -> [e]
        | WExpr.ArrayCopy(d, d2, s, s2, n)                           -> [d; d2; s; s2; n]
        | WExpr.StructNew(_, fs, _)                                  -> fs
        | WExpr.StructGet(o, _, _)                                   -> [o]
        | WExpr.StructSet(o, _, v)                                   -> [o; v]
        | WExpr.Cast(e, _) | WExpr.RefIsNull e | WExpr.RefTest(e,_)
        | WExpr.Unary(_, e, _) | WExpr.TagOf e | WExpr.Throw e       -> [e]
        | WExpr.Binary(_, a, b, _) | WExpr.Compare(_, a, b)          -> [a; b]
        | WExpr.Assign(_, v) | WExpr.GlobalSet(_, v)                 -> [v]
        | WExpr.Return(Some v) | WExpr.Break(_, Some v)              -> [v]
        | WExpr.JoinPoint(_, _, b, c, _)                             -> [b; c]
        | WExpr.JoinApply(_, args, _)                                -> args
        | WExpr.SwitchInt(s, cases, d, _)                            -> s :: (cases |> List.map snd) @ [d]
        | WExpr.TryCatch(b, catch, fin, _)                           ->
            b :: (catch |> Option.toList |> List.map snd) @ (fin |> Option.toList)
        | WExpr.MemLoad(_, _, addr)                                  -> [addr]
        | WExpr.MemStore(_, _, addr, v)                              -> [addr; v]
        | WExpr.MemoryGrow pages                                     -> [pages]
        | WExpr.CallVirtual(o, _, _, _, _, args, _)                  -> o :: args
        | WExpr.Closure(_, caps, _)                                  -> caps
        | _ -> []

    let rec fold (f: 'S -> WExpr -> 'S) (state: 'S) (expr: WExpr) : 'S =
        let state' = children expr |> List.fold (fold f) state
        f state' expr

    let collect (pred: WExpr -> bool) (expr: WExpr) : WExpr list =
        fold (fun acc e -> if pred e then e :: acc else acc) [] expr

    let exists (pred: WExpr -> bool) (expr: WExpr) : bool =
        fold (fun found e -> found || pred e) false expr

    let count (pred: WExpr -> bool) (expr: WExpr) : int =
        fold (fun n e -> if pred e then n + 1 else n) 0 expr

    let allLocalNames (expr: WExpr) : string list =
        collect (function WExpr.LocalGet _ -> true | _ -> false) expr
        |> List.choose (function WExpr.LocalGet(n, _) -> Some n | _ -> None)
        |> List.distinct

    let allClosureApplys (expr: WExpr) : WExpr list =
        collect (function WExpr.ClosureApply _ -> true | _ -> false) expr

    let allLoops   (expr: WExpr) = collect (function WExpr.Loop  _ -> true | _ -> false) expr
    let allBlocks  (expr: WExpr) = collect (function WExpr.Block _ -> true | _ -> false) expr
    let allBreaks  (expr: WExpr) = collect (function WExpr.Break _ -> true | _ -> false) expr
    let allBreakWithValues (expr: WExpr) =
        collect (function WExpr.Break(_, Some _) -> true | _ -> false) expr
    let allCalls (name: string) (expr: WExpr) =
        collect (function WExpr.Call(n, _, _) -> n = name | _ -> false) expr

    let rec rewrite (f: WExpr -> WExpr option) (expr: WExpr) : WExpr =
        let expr' =
            match expr with
            | WExpr.Let(n, v, b)       -> WExpr.Let(n, rewrite f v, rewrite f b)
            | WExpr.LetMut(n, v, b)    -> WExpr.LetMut(n, rewrite f v, rewrite f b)
            | WExpr.If(c, t, e, ty)    -> WExpr.If(rewrite f c, rewrite f t, rewrite f e, ty)
            | WExpr.Sequence xs        -> WExpr.Sequence(List.map (rewrite f) xs)
            | WExpr.Block(l, b, ty)    -> WExpr.Block(l, rewrite f b, ty)
            | WExpr.Loop(l, b, ty)     -> WExpr.Loop(l, rewrite f b, ty)
            | WExpr.Assign(n, v)       -> WExpr.Assign(n, rewrite f v)
            | WExpr.Call(n, args, ty)  -> WExpr.Call(n, List.map (rewrite f) args, ty)
            | WExpr.ClosureApply(c, args, ft, ct, cc, ty) ->
                WExpr.ClosureApply(rewrite f c, List.map (rewrite f) args, ft, ct, cc, ty)
            | WExpr.ArraySet(a, i, v)  -> WExpr.ArraySet(rewrite f a, rewrite f i, rewrite f v)
            | WExpr.ArrayGet(a, i, ty) -> WExpr.ArrayGet(rewrite f a, rewrite f i, ty)
            | WExpr.StructGet(o, fi, ty)  -> WExpr.StructGet(rewrite f o, fi, ty)
            | WExpr.StructSet(o, fi, v)   -> WExpr.StructSet(rewrite f o, fi, rewrite f v)
            | WExpr.StructNew(ti, fs, ty) -> WExpr.StructNew(ti, List.map (rewrite f) fs, ty)
            | WExpr.Binary(op, a, b, ty)  -> WExpr.Binary(op, rewrite f a, rewrite f b, ty)
            | WExpr.Compare(op, a, b)     -> WExpr.Compare(op, rewrite f a, rewrite f b)
            | WExpr.Unary(op, e, ty)      -> WExpr.Unary(op, rewrite f e, ty)
            | WExpr.RefIsNull e           -> WExpr.RefIsNull(rewrite f e)
            | WExpr.Cast(e, ty)           -> WExpr.Cast(rewrite f e, ty)
            | WExpr.Break(l, Some v)      -> WExpr.Break(l, Some(rewrite f v))
            | WExpr.Throw e               -> WExpr.Throw(rewrite f e)
            | WExpr.SwitchInt(s, cases, d, ty) ->
                WExpr.SwitchInt(
                    rewrite f s,
                    List.map (fun (k, v) -> k, rewrite f v) cases,
                    rewrite f d, ty)
            | WExpr.TryCatch(b, catch, fin, ty) ->
                WExpr.TryCatch(
                    rewrite f b,
                    catch |> Option.map (fun (n, e) -> n, rewrite f e),
                    fin   |> Option.map (rewrite f), ty)
            | other -> other
        f expr' |> Option.defaultValue expr'

// ─────────────────────────────────────────────────────────────────
// Shape helper — readable top-level label for assertions
// ─────────────────────────────────────────────────────────────────

let exprShape (expr: WExpr) : string =
    match expr with
    | WExpr.Const(WConst.I32 n)         -> sprintf "i32(%d)" n
    | WExpr.Const(WConst.I64 n)         -> sprintf "i64(%d)" n
    | WExpr.Const(WConst.F64 v)         -> sprintf "f64(%g)" v
    | WExpr.Const(WConst.F32 v)         -> sprintf "f32(%g)" v
    | WExpr.Const(WConst.Null ty)       -> sprintf "null(%s)" (wTypeKey ty)
    | WExpr.Const(WConst.Unit)          -> "unit"
    | WExpr.Const(WConst.String _)      -> "str"
    | WExpr.LocalGet(n, _)              -> sprintf "local(%s)" n
    | WExpr.GlobalGet(n, _)             -> sprintf "global(%s)" n
    | WExpr.Assign(n, _)                -> sprintf "set(%s)" n
    | WExpr.GlobalSet(n, _)             -> sprintf "global.set(%s)" n
    | WExpr.Let(n, _, _)                -> sprintf "let(%s)" n
    | WExpr.LetMut(n, _, _)             -> sprintf "letmut(%s)" n
    | WExpr.Nop                         -> "nop"
    | WExpr.Return _                    -> "return"
    | WExpr.Sequence xs                 -> sprintf "seq[%d]" xs.Length
    | WExpr.If _                        -> "if"
    | WExpr.Loop(l, _, _)               -> sprintf "loop(%s)" l
    | WExpr.Block(l, _, _)              -> sprintf "block(%s)" l
    | WExpr.Break(l, None)              -> sprintf "break(%s)" l
    | WExpr.Break(l, Some _)            -> sprintf "break_val(%s)" l
    | WExpr.Continue(l, _)              -> sprintf "continue(%s)" l
    | WExpr.Call(n, args, _)            -> sprintf "call(%s,%d)" n args.Length
    | WExpr.TailCall(n, args, _)        -> sprintf "tail(%s,%d)" n args.Length
    | WExpr.ClosureApply(_, args, fti, _, _, _) -> sprintf "closure(fti=%d,args=%d)" fti args.Length
    | WExpr.Closure(n, caps, _)         -> sprintf "closure_def(%s,caps=%d)" n caps.Length
    | WExpr.ArrayGet _                  -> "arr.get"
    | WExpr.ArraySet _                  -> "arr.set"
    | WExpr.ArrayLen _                  -> "arr.len"
    | WExpr.ArrayNew _                  -> "arr.new"
    | WExpr.ArrayNewFixed(_, es, _)     -> sprintf "arr.new_fixed[%d]" es.Length
    | WExpr.ArrayCopy _                 -> "arr.copy"
    | WExpr.StructGet(_, f, _)          -> sprintf "struct.get[%d]" f
    | WExpr.StructSet(_, f, _)          -> sprintf "struct.set[%d]" f
    | WExpr.StructNew(ti, fs, _)        -> sprintf "struct.new(%d,fields=%d)" ti fs.Length
    | WExpr.Binary(op, _, _, _)         -> sprintf "bin(%A)" op
    | WExpr.Compare(op, _, _)           -> sprintf "cmp(%A)" op
    | WExpr.Unary(op, _, _)             -> sprintf "unary(%A)" op
    | WExpr.RefIsNull _                 -> "ref.is_null"
    | WExpr.RefTest(_, ty)              -> sprintf "ref.test(%s)" (wTypeKey ty)
    | WExpr.Cast(_, ty)                 -> sprintf "cast(%s)" (wTypeKey ty)
    | WExpr.TagOf _                     -> "tag_of"
    | WExpr.Throw _                     -> "throw"
    | WExpr.TryCatch _                  -> "try_catch"
    | WExpr.SwitchInt(_, cs, _, _)      -> sprintf "switch[%d]" cs.Length
    | WExpr.JoinPoint(n, _, _, _, _)    -> sprintf "join(%s)" n
    | WExpr.JoinApply(n, _, _)          -> sprintf "apply(%s)" n
    | WExpr.CallVirtual _               -> "call_virt"
    | WExpr.FuncRef n                   -> sprintf "func_ref(%s)" n
    | WExpr.MemLoad _                   -> "mem.load"
    | WExpr.MemStore _                  -> "mem.store"
    | WExpr.MemorySize                  -> "mem.size"
    | WExpr.MemoryGrow _                -> "mem.grow"
    | WExpr.CallIndirect _              -> "call_indirect"
    | WExpr.CallRef _                   -> "call_ref"       // TODO: check if this is actually used, or be lowered to call_indirect (others too)
    | WExpr.TailCallRef _               -> "tail_call_ref"
    | WExpr.ReturnCallRef _             -> "return_call_ref"

// ─────────────────────────────────────────────────────────────────
// Assertion helpers (Expecto-compatible, also used from Wasmecto)
// ─────────────────────────────────────────────────────────────────

let assertShape (expected: string) (expr: WExpr) =
    let actual = exprShape expr
    Expect.equal actual expected (sprintf "Expected WExpr shape '%s' but got '%s'" expected actual)

let assertNoUnknownLocals (paramNames: string list) (localNames: string list) (expr: WExpr) =
    let known   = Set.ofList (paramNames @ localNames)
    let unknown = WExprQuery.allLocalNames expr |> List.filter (fun n -> not (Set.contains n known))
    Expect.isEmpty unknown (sprintf "Unknown locals in expr: %A" unknown)

let assertClosureArities (arityMap: Map<int, int>) (expr: WExpr) =
    let mismatches =
        WExprQuery.allClosureApplys expr
        |> List.choose (function
            | WExpr.ClosureApply(_, args, fti, _, _, _) ->
                let nonVoid = args |> List.filter (fun a -> exprWType a <> WType.Void)
                let actual  = 1 + nonVoid.Length
                match Map.tryFind fti arityMap with
                | Some expected when actual <> expected ->
                    Some(sprintf "fti=%d: expected %d params (incl self), got %d on stack" fti expected actual)
                | None ->
                    Some(sprintf "fti=%d: functype not registered" fti)
                | _ -> None
            | _ -> None)
    Expect.isEmpty mismatches (sprintf "ClosureApply arity errors: %A" mismatches)

let assertHasLoop (label: string) (expr: WExpr) =
    Expect.isNonEmpty (WExprQuery.allLoops expr) (sprintf "%s: expected Loop" label)

let assertHasBlock (label: string) (expr: WExpr) =
    Expect.isNonEmpty (WExprQuery.allBlocks expr) (sprintf "%s: expected Block" label)

let assertHasBreakWithValue (label: string) (expr: WExpr) =
    Expect.isNonEmpty (WExprQuery.allBreakWithValues expr) (sprintf "%s: expected Break-with-value" label)

let assertUniqueLoopLabels (expr: WExpr) =
    let labels =
        WExprQuery.allLoops expr
        |> List.choose (function WExpr.Loop(l, _, _) -> Some l | _ -> None)
    Expect.equal labels.Length (List.distinct labels |> List.length)
        "All loop labels must be unique"

// ─────────────────────────────────────────────────────────────────
// Fable AST builder helpers
// ─────────────────────────────────────────────────────────────────

module FableAst =
    open Fable.AST.Fable

    let mkParam name ty = // TODO: this is not only FableAst related
        { Name = name
          Type = ty
          Range = None
          IsMutable = false
          IsCompilerGenerated = false
          IsThisArgument = false
          // Tags = []
          // Tags = Fable.Tags.empty
          IsInlineIfLambda = false
          }

    let mkIdent name ty =
        Fable.Expr.IdentExpr(mkParam name ty)

    let mkIntLit n =
        // Expr.Value(NumberConstant(NumberValue.Int32 n, NumberInfo.Empty), None)
        // Fable.Expr.Value(Fable.NumberConstant(float n, NumberKind.Int32, Fable.NumberInfo.Empty), None)
        // NumberConstant takes (NumberValue * NumberInfo)
        // Int32 must be qualified as NumberValue.Int32
        let value = NumberValue.Int32 (int n)
        Expr.Value(ValueKind.NumberConstant(value, NumberInfo.Empty), None)

    let mkUnit =
        Expr.Value(UnitConstant, None)
        // Fable.Expr.Value(Fable.UnitConstant, None)

    let mkLambda paramName paramTy body =
        Fable.Expr.Lambda(mkParam paramName paramTy, body, None)

    let mkBinaryLambda a aty b bty body =
        Fable.Expr.Lambda(mkParam a aty, Fable.Expr.Lambda(mkParam b bty, body, None), None)

    let mkLet name ty value body =
        Fable.Expr.Let(mkParam name ty, value, body)

    let mkInt32T = Type.Number(NumberKind.Int32, NumberInfo.Empty)
    let mkFloat64T = Type.Number(NumberKind.Float64, NumberInfo.Empty)

    let mkBoolT   = Fable.Type.Boolean
    let mkStringT = Fable.Type.String
    let mkUnitT   = Fable.Type.Unit
    let mkListT t  = Fable.Type.List t
    // let mkArrayT t = Fable.Type.Array(t, Fable.ArrayKind.Array)
    let mkArrayT t = Fable.Type.Array(t, Fable.ArrayKind.ResizeArray)
    let mkOptionT (t: Fable.Type) = Fable.Type.Option(t, false)
    let mkTupleT ts = Fable.Type.Tuple(ts, false)

    let mkEntity (fullName: string) : Fable.EntityRef =
        // { FullName = fullName; Path = Fable.EntityPath.PrecompiledLib }
        { FullName = fullName; Path = Fable.EntityPath.SourcePath "" }

    let mkDeclaredT fullName =
        Fable.Type.DeclaredType(mkEntity fullName, [])
