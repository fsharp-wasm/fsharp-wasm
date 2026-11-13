/// Test helpers for WasmGC compiler unit tests.
/// NullCompiler is a minimal Fable.Compiler stub (no FCS, no plugins).
/// All helpers (i32Const, localGet, buildArityIndex, WExprQuery, FableAst.*) live here
/// so test files only need `open Tests.WasmTestHelper`.
module Tests.WasmTestHelper

open System
open System.IO
open Expecto
open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core

// ─────────────────────────────────────────────────────────────────
// FableAst DSL helpers (shared across test modules)
// ─────────────────────────────────────────────────────────────────

module FableAst =

    let mkParam (name: string) (typ: Fable.Type) : Fable.Ident =
        { Name = name; Type = typ; IsMutable = false
          IsThisArgument = false; IsCompilerGenerated = false
          Range = None; IsInlineIfLambda = false }

    let mkIdent (name: string) (typ: Fable.Type) : Fable.Expr =
        Fable.IdentExpr (mkParam name typ)

    /// Fable integer literal (i32)
    let mkIntLit (n: int32) : Fable.Expr =
        Fable.Value(Fable.NumberConstant(NumberValue.Int32 n, NumberInfo.Empty), None)

    /// Fable unit expression
    let mkUnit : Fable.Expr =
        Fable.Value(Fable.UnitConstant, None)

    /// Fable boolean literal
    let mkBoolLit (b: bool) : Fable.Expr =
        Fable.Value(Fable.BoolConstant b, None)

// ─────────────────────────────────────────────────────────────────
// Mock entity (for type-lookup stubs)
// ─────────────────────────────────────────────────────────────────

let mockEntity (fullName: string) =
    { new Fable.Entity with
        member _.Ref                          = { FullName = fullName; Path = Fable.SourcePath "" }
        member _.FullName                     = fullName
        member _.DisplayName                  = fullName
        member _.CompiledName                 = fullName
        member _.Attributes                   = Seq.empty
        member _.MembersFunctionsAndValues    = Seq.empty
        member _.AllInterfaces                = Seq.empty
        member _.DeclaredInterfaces           = Seq.empty
        member _.FSharpFields                 = []
        member _.UnionCases                   = []
        member _.GenericParameters            = []
        member _.BaseType                     = None
        member _.DeclaringEntity              = None
        member _.TryFindMember(_)             = None
        member _.IsPublic                     = true
        member _.IsPrivate                    = false
        member _.IsInternal                   = false
        member _.IsNamespace                  = false
        member _.IsFSharpModule               = false
        member _.IsFSharpUnion                = false
        member _.IsFSharpRecord               = false
        member _.IsFSharpAbbreviation         = false
        member _.IsFSharpExceptionDeclaration = false
        member _.IsValueType                  = false
        member _.IsInterface                  = false
        member _.IsMeasure                    = false
        member _.IsByRef                      = false
        member _.IsEnum                       = false
        member _.IsAbstractClass              = false }

// ─────────────────────────────────────────────────────────────────
// NullCompiler — minimal Fable.Compiler stub
// Uses FSharp.Wasm.Core, NOT vendor Fable.Core
// ─────────────────────────────────────────────────────────────────

type NullCompiler() =

    // LibraryDir → our FSharp.Wasm.Core, NOT vendor Fable.Core
    let libDir =
        [ Path.Combine(__SOURCE_DIRECTORY__, "../../../core/FSharp.Wasm.Core")
          Path.Combine(__SOURCE_DIRECTORY__, "../../../../core/FSharp.Wasm.Core") ]
        |> List.tryFind Directory.Exists
        |> Option.defaultValue "."

    interface Fable.Compiler with
        member _.Options =
            CompilerOptionsHelper.Make(
                language    = Language.WasmGc,
                debugMode   = false,
                typedArrays = false)
        member _.Plugins              = { MemberDeclarationPlugins = Map.empty }
        member _.LibraryDir           = libDir
        member _.CurrentFile          = "<test>"
        member _.SourceFiles          = [||]
        member _.OutputDir            = None
        member _.OutputType           = OutputType.Exe
        member _.ProjectFile          = ""
        member _.ProjectOptions       = Unchecked.defaultof<_>
        member _.IncrementCounter()   = 0
        member _.IsPrecompilingInlineFunction = false
        member this.WillPrecompileInlineFunction(_) = this :> Fable.Compiler
        member _.GetImplementationFile(_) = []
        member _.GetRootModule(f)     = (f, None)
        member _.TryGetEntity(_)      = None
        member _.GetInlineExpr(_)     = failwith "NullCompiler: GetInlineExpr not supported in unit tests"
        member _.AddWatchDependency(_) = ()
        member _.AddLog(msg, sev, ?_r, ?_f, ?_t) =
            if sev = Severity.Error then eprintfn "[NullCompiler] %s" msg
        member _.TryGetPluginHelper() = None   // ICompilerCore — no plugin dispatch in tests

// ─────────────────────────────────────────────────────────────────
// wTypeKey — WAT type string (mirrors Wat.fs; no Emit dep)
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
    | WType.Ref(idx, false) -> $"ref{idx}"
    | WType.Ref(idx, true)  -> $"refnull{idx}"
    | WType.Func(ps, rs)    ->
        let pk = ps |> List.map wTypeKey |> String.concat ","
        let rk = rs |> List.map wTypeKey |> String.concat ","
        $"fn({pk})->({rk})"
    | WType.Struct fields   ->
        fields |> List.map (fun f -> $"{f.Name}:{wTypeKey f.Type}") |> String.concat ";" |> fun s -> $"struct{{{s}}}"
    | WType.Array(elem, true) -> 
        $"arr_mut_{wTypeKey elem}"
    | WType.Array(elem, false) -> 
        $"arr_imm_{wTypeKey elem}"

// ─────────────────────────────────────────────────────────────────
// WExpr builders
// ─────────────────────────────────────────────────────────────────

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
// buildArityIndex — for Validator and closure-arity tests
// ─────────────────────────────────────────────────────────────────

/// funcTypeIdx → expected param count, built from a TypeDefs list.
let buildArityIndex (typeDefs: System.Collections.Generic.List<WTypeDeclEntry>) : Map<int, int> =
    typeDefs
    |> Seq.mapi (fun i e -> i, e)
    |> Seq.choose (fun (i, e) ->
        match e.Def with
        | WTypeDef.Func(ps, _) -> Some(i, ps.Length)
        | _ -> None)
    |> Map.ofSeq

// ─────────────────────────────────────────────────────────────────
// assertNoUnknownLocals — structural integrity check for WFuncDecl tests
// ─────────────────────────────────────────────────────────────────

/// Assert that every LocalGet in `body` refers to a declared param or local.
/// Uses WasmGc.Util.WExprQuery.collect.
let assertNoUnknownLocals
        (paramNames   : string list)
        (declaredLocals: string list)
        (body         : WExpr) =
    let known = Set.ofList (paramNames @ declaredLocals)
    let used  =
        WasmGc.Util.WExprQuery.collect (function WExpr.LocalGet _ -> true | _ -> false) body
        |> List.choose (function WExpr.LocalGet(n, _) -> Some n | _ -> None)
        |> Set.ofList
    let unknown = Set.difference used known
    if not (Set.isEmpty unknown) then
        failtestf "Unknown locals in function body: %A" unknown

// ─────────────────────────────────────────────────────────────────
// WExprQuery — local alias so tests can use `WExprQuery.collect` unqualified
// (delegates to the real module at WasmGc.Util.WExprQuery)
// ─────────────────────────────────────────────────────────────────

module WExprQuery =
    let inline children e     = WasmGc.Util.WExprQuery.children e
    let inline exists   p e   = WasmGc.Util.WExprQuery.exists p e
    let inline collect  p e   = WasmGc.Util.WExprQuery.collect p e
    let inline rewrite  f e   = WasmGc.Util.WExprQuery.rewrite f e
    let inline fold     f s e = WasmGc.Util.WExprQuery.fold f s e

// ─────────────────────────────────────────────────────────────────
// Ctx construction
// ─────────────────────────────────────────────────────────────────

let private allTestContexts = System.Collections.Generic.List<Ctx>()

let flushAllDiagnostics () =
    for ctx in allTestContexts do
        if ctx.Diagnostics.Count > 0 then ctx.Diagnostics.Flush()
    allTestContexts.Clear()

let flushTestDiagnostics () =
    flushAllDiagnostics()
    GC.Collect()
    GC.WaitForPendingFinalizers()

type internal ContextFinalizer(ctx: Ctx) =
    override _.Finalize() =
        try if ctx.Diagnostics.Count > 0 then ctx.Diagnostics.Flush() with _ -> ()

type AutoFlushContext(ctx: Ctx) =
    member _.Ctx = ctx
    interface IDisposable with
        member _.Dispose() = if ctx.Diagnostics.Count > 0 then ctx.Diagnostics.Flush()

let makeAutoFlushCtx () = new AutoFlushContext(Ctx.Create(NullCompiler()))

// ─────────────────────────────────────────────────────────────────
// makeTestCtx — real Ctx with the four pre-registered types
// ─────────────────────────────────────────────────────────────────

/// Build a fresh Ctx for unit tests.
/// Same 4 pre-registered types as production:
///   0 = $AnyFn  1 = $WasmStr  2 = $ListBase  3 = $StringBuilder
let makeTestCtx () : Ctx =
    let ctx = Ctx.Create(NullCompiler())
    allTestContexts.Add(ctx)
    ignore (new ContextFinalizer(ctx))
    ctx

let makeCtxWithLocals (locals: (string * WType) list) : Ctx =
    locals |> List.fold (fun ctx (n, t) -> ctx.WithLocal(n, t)) (makeTestCtx())

let makeCtxWithModuleValues (vals: (string * WType) list) : Ctx =
    let ctx = makeTestCtx()
    { ctx with KnownFuncs = vals |> List.map (fun (n, r) -> n, ([], r)) |> Map.ofList }

let makeCtxWithFuncs (funcs: (string * WType list * WType) list) : Ctx =
    let ctx = makeTestCtx()
    { ctx with KnownFuncs = funcs |> List.map (fun (n, ps, r) -> n, (ps, r)) |> Map.ofList }

let makeCtxFull (locals: (string * WType) list) (funcs: (string * WType list * WType) list) : Ctx =
    let ctx = makeCtxWithFuncs funcs
    locals |> List.fold (fun (c: Ctx) (n, t) -> c.WithLocal(n, t)) ctx

let withAutoFlushDiagnostics (f: Ctx -> 'T) : 'T =
    let ctx = makeTestCtx()
    try f ctx finally ctx.Diagnostics.Flush()
