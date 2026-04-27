/// Test helpers for WasmGC compiler unit tests.
/// makeTestCtx creates a real Ctx via Ctx.Create using a NullCompiler stub.
/// All field names, type indices, and helper functions match the actual source.
module Tests.WasmTestHelpers

open System
open Fable.AST
open Fable.AST.Wasm

open Fable.Transforms.WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// NullCompiler — minimal Fable.Compiler stub for tests
// ─────────────────────────────────────────────────────────────────

type NullCompiler() =
    interface Fable.Compiler with
        member _.Options = { Fable.CompilerOptions.Default with DebugMode = false }
        member _.Plugins = []
        member _.LibraryDir = ""
        member _.CurrentFile = "<test>"
        member _.SourceFiles = [||]
        member _.GetEntity(_) = None
        member _.GetImplementation(_) = None
        member _.GetRootModule(_) = None
        member _.AddLog(_, _, _, _, _) = ()
        member _.GetOrAddInlineExpr(_, factory) = factory ()

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
        let fk = fields |> List.map (fun f -> sprintf "%s:%s" f.Name (wTypeKey f.Type)) |> String.concat ";"
        sprintf "struct{%s}" fk
    | WType.Array(elem, mut_) ->
        sprintf "arr_%s_%s" (if mut_ then "mut" else "imm") (wTypeKey elem)

// ─────────────────────────────────────────────────────────────────
// makeTestCtx — creates a real Ctx with the four pre-registered types
// ─────────────────────────────────────────────────────────────────

/// Build a fresh Ctx for unit tests.
/// Identical to the production pipeline init — same 4 pre-registered types:
///   index 0 = $AnyFn  (struct {} — base for all closures)
///   index 1 = $WasmStr (array (mut i32) — UTF-16 string)
///   index 2 = $ListBase (struct {} — base for all list cons types)
///   index 3 = $StringBuilder (struct { data; length; capacity })
let makeTestCtx () : Ctx =
    Ctx.Create(NullCompiler() :> Fable.Compiler)

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
    let ctx' = locals |> List.fold (fun c (n, t) -> c.WithLocal(n, t)) ctx
    { ctx' with KnownFuncs = kf }

// ─────────────────────────────────────────────────────────────────
// mapTypeKnown re-export — tests call it directly from Types module
// ─────────────────────────────────────────────────────────────────

// mapTypeKnown is defined in Types.fs, imported via:
//   open Fable.Transforms.WasmGc.Runtime.Types
// Tests call it as: mapTypeKnown ctx fableType

// ─────────────────────────────────────────────────────────────────
// WExpr builders (convenience for test setup)
// ─────────────────────────────────────────────────────────────────

open Fable.Transforms.WasmGc.Runtime.Builder

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
        | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b)               -> [v; b]
        | WExpr.If(c, t, e, _)                                       -> [c; t; e]
        | WExpr.Sequence xs                                          -> xs
        | WExpr.Block(_, b, _) | WExpr.Loop(_, b, _)                -> [b]
        | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _)       -> args
        | WExpr.ClosureApply(c, args, _, _, _, _)                    -> c :: args
        | WExpr.TailCallRef(c, args, _, _, _, _)                     -> c :: args
        | WExpr.ArrayNew(_, s, init, _)                              -> [s; init]
        | WExpr.ArrayNewFixed(_, es, _)                              -> es
        | WExpr.ArrayGet(a, i, _)                                    -> [a; i]
        | WExpr.ArraySet(a, i, v)                                    -> [a; i; v]
        | WExpr.ArrayLen e                                           -> [e]
        | WExpr.ArrayCopy(d, d2, s, s2, n)                          -> [d; d2; s; s2; n]
        | WExpr.StructNew(_, fs, _)                                  -> fs
        | WExpr.StructGet(o, _, _)                                   -> [o]
        | WExpr.StructSet(o, _, v)                                   -> [o; v]
        | WExpr.Cast(e, _) | WExpr.RefIsNull e | WExpr.RefTest(e,_)
        | WExpr.Unary(_, e, _) | WExpr.TagOf e | WExpr.Throw e      -> [e]
        | WExpr.Binary(_, a, b, _) | WExpr.Compare(_, a, b)         -> [a; b]
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
    | WExpr.TailCallRef _               -> "tail_call_ref"

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

    let mkParam name ty =
        { Name = name; Type = ty; Range = None; IsMutable = false; IsCompilerGenerated = false }

    let mkIdent name ty =
        Fable.Expr.IdentExpr(mkParam name ty)

    let mkIntLit n =
        Fable.Expr.Value(Fable.NumberConstant(float n, Fable.Int32, Fable.NumberInfo.Empty), None)

    let mkUnit =
        Fable.Expr.Value(Fable.UnitConstant, None)

    let mkLambda paramName paramTy body =
        Fable.Expr.Lambda(mkParam paramName paramTy, body, None)

    let mkBinaryLambda a aty b bty body =
        Fable.Expr.Lambda(mkParam a aty, Fable.Expr.Lambda(mkParam b bty, body, None), None)

    let mkLet name ty value body =
        Fable.Expr.Let(mkParam name ty, value, body)

    let mkInt32T = Fable.Type.Number(Fable.Int32, Fable.NumberInfo.Empty)
    let mkFloat64T = Fable.Type.Number(Fable.Float64, Fable.NumberInfo.Empty)
    let mkBoolT   = Fable.Type.Boolean
    let mkStringT = Fable.Type.String
    let mkUnitT   = Fable.Type.Unit
    let mkListT t  = Fable.Type.List t
    let mkArrayT t = Fable.Type.Array(t, Fable.ArrayKind.Array)
    let mkOptionT (t: Fable.Type) = Fable.Type.Option(t, false)
    let mkTupleT ts = Fable.Type.Tuple(ts, false)

    let mkEntity (fullName: string) : Fable.EntityRef =
        { FullName = fullName; Path = Fable.EntityPath.PrecompiledLib }

    let mkDeclaredT fullName =
        Fable.Type.DeclaredType(mkEntity fullName, [])