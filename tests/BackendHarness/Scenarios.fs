module Scenarios
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Pipeline.Scope
open Lib
module CB = WasmGc.Transforms.ClosureBuilder

let anyFn = WType.Ref(AnyFnTypeIdx, false)

let applyBaseline (ctx: Ctx) (wClosure: WExpr) (wArgs: WExpr list) (retTy: WType) =
    // legacy-shaped helper for hand-written scenarios: signature from arg types
    CB.applyClosure ctx (Fable.Type.Any) wClosure (wArgs |> List.map (fun _ -> Fable.Type.Any)) wArgs retTy

let rec ev (ctx: Ctx) (e: Fable.Expr) : WExpr =
    match e with
    | Fable.IdentExpr id ->
        match resolve ctx ctx.CurrentFunc id.Name with
        | Resolution.Local(n, t) | Resolution.CapturedVar(n, t) -> WExpr.LocalGet(n, t)
        | Resolution.KnownFunc(qn, ps, r) -> CB.buildKnownFuncClosure ctx qn ps r
        | Resolution.ModuleValue(qn, r) -> WExpr.Call(qn, [], r)
        | _ -> WExpr.LocalGet(id.Name, mapTypeKnown ctx id.Type)   // same fallback as TransformExpr
    | Fable.Value(Fable.NumberConstant(Fable.NumberValue.Int32 n, _), _) -> WExpr.Const(WConst.I32 n)
    | Fable.Value(Fable.UnitConstant, _) -> WExpr.Nop
    | Fable.Operation(Fable.Binary(op, l, r), _, _, _) ->
        let wl, wr = ev ctx l, ev ctx r
        match op with
        | BinaryOperator.BinaryPlus -> WExpr.Binary(WBinaryOp.Add, wl, wr, WType.I32)
        | BinaryOperator.BinaryMinus -> WExpr.Binary(WBinaryOp.Sub, wl, wr, WType.I32)
        | BinaryOperator.BinaryMultiply -> WExpr.Binary(WBinaryOp.Mul, wl, wr, WType.I32)
        | BinaryOperator.BinaryEqual -> WExpr.Compare(WCompareOp.Eq, wl, wr)
        | BinaryOperator.BinaryLessOrEqual -> WExpr.Compare(WCompareOp.LeS, wl, wr)
        | BinaryOperator.BinaryLess -> WExpr.Compare(WCompareOp.LtS, wl, wr)
        | _ -> failwith "op"
    | Fable.IfThenElse(c, t, el, _) -> WExpr.If(ev ctx c, ev ctx t, ev ctx el, mapResultTypeKnown ctx t.Type)
    | Fable.Lambda(arg, body, name) -> CB.buildClosure ctx ev [arg] body name
    | Fable.Delegate(args, body, name, _) -> CB.buildClosure ctx ev args body name
    | Fable.CurriedApply(callee, args, typ, _) -> CB.applyClosure ctx callee.Type (ev ctx callee) (args |> List.map (fun a -> a.Type)) (args |> List.map (ev ctx)) (mapResultTypeKnown ctx typ)
    | Fable.Let(id, v, body) ->
        let wv = ev ctx v
        let ty = mapTypeKnown ctx id.Type
        WExpr.Let(id.Name, wv, ev (ctx.WithLocal(id.Name, ty)) body)
    | Fable.LetRec(bs, body) -> CB.buildLetRecLambdas ctx ev bs body
    | _ -> failwithf "mini-ev: unsupported %A" e

/// Build a module function from a Fable lambda-style definition and add to ctx.
let defFunc (ctx: Ctx) (name: string) (ps: Fable.Ident list) (body: Fable.Expr) (exported: bool) =
    let pw = ps |> List.map (fun p -> p.Name, mapTypeKnown ctx p.Type)
    let ctx' = { WasmGc.Pipeline.Scope.enterFunc name pw ctx with CurrentFunc = Some name }
    let wbody = ev ctx' body
    let f = { Name = name; Params = pw; Result = mapResultTypeKnown ctx body.Type; Locals = []; Body = wbody; Exported = exported }
    ctx.Functions.Add f
    ctx

let newCtx () = Ctx.Create(stubCompiler)

// ── S1: closure with a capture:  makeAdder k = fun x -> x + k ;  run a b = (makeAdder a) b
let s1 () =
    let ctx = newCtx ()
    let k, x = id32 "k", id32 "x"
    let lam = Fable.Lambda(x, add (var x) (var k), None)
    defFunc ctx "makeAdder" [k] lam false |> ignore
    let ctxK = ctx |> withKnownFuncs [ "makeAdder", ([WType.I32], anyFn) ]
    let a, b = id32 "a", id32 "b"
    // run a b = makeAdder(a) applied to b
    let wcall = WExpr.Call("makeAdder", [WExpr.LocalGet("a", WType.I32)], anyFn)
    let body = applyBaseline ctx wcall [WExpr.LocalGet("b", WType.I32)] WType.I32
    ctx.Functions.Add { Name = "run"; Params = ["a", WType.I32; "b", WType.I32]; Result = WType.I32; Locals = []; Body = body; Exported = true }
    "s1_capture", ctx

// ── S2: zero-capture lambda:  run x = (fun y -> y * 2) x
let s2 () =
    let ctx = newCtx ()
    let x, y = id32 "x", id32 "y"
    let body = app (Fable.Lambda(y, mul (var y) (num 2), None)) [var x] i32T
    defFunc ctx "run" [x] body true |> ignore
    "s2_nocapture", ctx

// ── S3: module function used as value (KnownFunc) :  inc x = x+1 ;  run x = (inc as value) x
let s3 () =
    let ctx = newCtx ()
    let x = id32 "x"
    defFunc ctx "inc" [x] (add (var x) (num 1)) false |> ignore
    let ctx2 = { ctx with KnownFuncs = Map.ofList [ "inc", ([WType.I32], WType.I32) ] }
    let v = id32 "v"
    let fnVal = ev { WasmGc.Pipeline.Scope.enterFunc "run" ["v", WType.I32] ctx2 with CurrentFunc = Some "run" } (var (ident "inc" (fn1 i32T i32T)))
    let body = CB.applyClosure ctx2 (fn1 i32T i32T) fnVal [i32T] [WExpr.LocalGet("v", WType.I32)] WType.I32
    ctx.Functions.Add { Name = "run"; Params = ["v", WType.I32]; Result = WType.I32; Locals = []; Body = body; Exported = true }
    "s3_knownfunc", ctx

// ── S4: mutually recursive closures:  let rec ev n = if n=0 then 1 else od (n-1) and od n = if n=0 then 0 else ev (n-1) in ev x
let s4 () =
    let ctx = newCtx ()
    let x, n1, n2 = id32 "x", id32 "n", id32 "n"
    let evI = ident "evenF" (fn1 i32T i32T)
    let odI = ident "oddF"  (fn1 i32T i32T)
    let evBody = ite (eq (var n1) (num 0)) (num 1) (app (var odI) [sub (var n1) (num 1)] i32T)
    let odBody = ite (eq (var n2) (num 0)) (num 0) (app (var evI) [sub (var n2) (num 1)] i32T)
    let e = Fable.LetRec([ evI, Fable.Lambda(n1, evBody, None); odI, Fable.Lambda(n2, odBody, None) ], app (var evI) [var x] i32T)
    defFunc ctx "run" [x] e true |> ignore
    "s4_letrec_mutual", ctx

// ── S5: single self-recursive local closure:  let rec fact n = if n=0 then 1 else n * fact (n-1) in fact x
let s5 () =
    let ctx = newCtx ()
    let x, n = id32 "x", id32 "n"
    let fI = ident "fact" (fn1 i32T i32T)
    let body = ite (eq (var n) (num 0)) (num 1) (mul (var n) (app (var fI) [sub (var n) (num 1)] i32T))
    let e = Fable.LetRec([ fI, Fable.Lambda(n, body, None) ], app (var fI) [var x] i32T)
    defFunc ctx "run" [x] e true |> ignore
    "s5_letrec_self", ctx


// ── S6: Array.sortWith with a closure comparer (per-array-type helper)
let s6 () =
    let ctx = newCtx ()
    let arrIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add { Name = "IntArr"; Def = WTypeDef.Array(WType.I32, true) }
    let arrTy = WType.Ref(arrIdx, false)
    let a, b = id32 "a", id32 "b"
    let cmp = ev (WasmGc.Pipeline.Scope.enterFunc "run" [] ctx) (Fable.Delegate([a; b], sub (var a) (var b), None, []))
    let at i = WExpr.ArrayGet(WExpr.LocalGet("arr", arrTy), WExpr.Const(WConst.I32 i), WType.I32)
    let body =
        WExpr.Let("arr", WExpr.ArrayNewFixed(arrIdx, [ for v in [ 3; 1; 2 ] -> WExpr.Const(WConst.I32 v) ], arrTy),
            WExpr.Sequence [
                WExpr.Call("$arraySortWith", [ WExpr.LocalGet("arr", arrTy); cmp; WExpr.Const(WConst.I32 3) ], WType.Void)
                WExpr.Binary(WBinaryOp.Add, WExpr.Binary(WBinaryOp.Mul, at 0, WExpr.Const(WConst.I32 100), WType.I32),
                    WExpr.Binary(WBinaryOp.Add, WExpr.Binary(WBinaryOp.Mul, at 1, WExpr.Const(WConst.I32 10), WType.I32), at 2, WType.I32), WType.I32) ])
    ctx.Functions.Add { Name = "run"; Params = []; Result = WType.I32; Locals = []; Body = body; Exported = true }
    "s6_array_sortwith", ctx

// ── S7: closure applied to a CLOSURE LITERAL argument (arg type ≠ declared param type)
//        h = fun (g: int->int) (x: int) -> g x      run k = h (fun y -> y + k) 3
let s7 () =
    let ctx = newCtx ()
    let k, g, x, y, h = id32 "k", ident "g" (fn1 i32T i32T), id32 "x", id32 "y", ident "h" (Fable.Type.DelegateType([ fn1 i32T i32T; i32T ], i32T))
    let hDef = Fable.Delegate([ g; x ], app (var g) [ var x ] i32T, None, [])
    let body = Fable.Let(h, hDef, app (var h) [ Fable.Lambda(y, add (var y) (var k), None); num 3 ] i32T)
    defFunc ctx "run" [ k ] body true |> ignore
    "s7_closure_arg", ctx

// ── S8: closure application below `return`  (old Lower did not descend into Return)
let s8 () =
    let ctx = newCtx ()
    let x, y = id32 "x", id32 "y"
    let clo = ev (WasmGc.Pipeline.Scope.enterFunc "run" [ "x", WType.I32 ] ctx) (Fable.Lambda(y, mul (var y) (num 3), None))
    let call = CB.applyClosure ctx (fn1 i32T i32T) clo [ i32T ] [ WExpr.LocalGet("x", WType.I32) ] WType.I32
    ctx.Functions.Add { Name = "run"; Params = [ "x", WType.I32 ]; Result = WType.I32; Locals = []; Body = WExpr.Sequence [ WExpr.Return(Some call); WExpr.Const(WConst.I32 0) ]; Exported = true }
    "s8_return_apply", ctx

// ── S9: nested closures, each capturing from the enclosing one:   run a = ((fun b -> (fun c -> a + b + c)) 10) 100
let s9 () =
    let ctx = newCtx ()
    let a, b, c = id32 "a", id32 "b", id32 "c"
    let inner = Fable.Lambda(c, add (add (var a) (var b)) (var c), None)
    let outer = Fable.Lambda(b, inner, None)
    let body = app (app outer [ num 10 ] (fn1 i32T i32T)) [ num 100 ] i32T
    defFunc ctx "run" [ a ] body true |> ignore
    "s9_nested", ctx


// ── S10: 2-argument self-recursive closure with accumulator, 3,000,000 deep (needs return_call_ref)
let s10 () =
    let ctx = newCtx ()
    let x, n, acc = id32 "x", id32 "n", id32 "acc"
    let loopI = ident "loop" (Fable.Type.DelegateType([ i32T; i32T ], i32T))
    let body = ite (eq (var n) (num 0)) (var acc) (app (var loopI) [ sub (var n) (num 1); add (var acc) (num 1) ] i32T)
    let e = Fable.LetRec([ loopI, Fable.Delegate([ n; acc ], body, None, []) ], app (var loopI) [ var x; num 0 ] i32T)
    defFunc ctx "run" [ x ] e true |> ignore
    "s10_deep_tail", ctx

// ── S11: unit-argument closure   run k = (fun () -> k + 1) ()
let s11 () =
    let ctx = newCtx ()
    let k, u = id32 "k", ident "u" Fable.Type.Unit
    let body = app (Fable.Lambda(u, add (var k) (num 1), None)) [ Fable.Value(Fable.UnitConstant, None) ] i32T
    defFunc ctx "run" [ k ] body true |> ignore
    "s11_unit_closure", ctx

// ── S12: captures of mixed WASM types (struct ref, i64, f64) built through buildOne
let s12 () =
    let ctx = newCtx ()
    let pt = ctx.TypeDefs.Count
    ctx.TypeDefs.Add { Name = "Pt"; Def = WTypeDef.Struct([ { Name = "x"; Type = WType.I32; Mutable = false }; { Name = "y"; Type = WType.I32; Mutable = false } ], None) }
    let ptTy = WType.Ref(pt, false)
    let g n t = WExpr.LocalGet(n, t)
    let add a b = WExpr.Binary(WBinaryOp.Add, a, b, WType.I32)
    let spec : CB.ClosureSpec =
        { FuncName = "$cap_mix"; ArgParams = [ "z", WType.I32 ]; RetType = WType.I32
          Captures = [ "p", ptTy; "big", WType.I64; "f", WType.F64 ] }
    let body =
        add (add (g "z" WType.I32) (add (WExpr.StructGet(g "p" ptTy, 0, WType.I32)) (WExpr.StructGet(g "p" ptTy, 1, WType.I32))))
            (add (WExpr.Unary(WUnaryOp.WrapI64, g "big" WType.I64, WType.I32)) (WExpr.Unary(WUnaryOp.TruncF64S, g "f" WType.F64, WType.I32)))
    let clo = CB.buildOne ctx spec body
    let main =
        WExpr.Let("p", WExpr.StructNew(pt, [ WExpr.LocalGet("a", WType.I32); WExpr.Const(WConst.I32 5) ], ptTy),
          WExpr.Let("big", WExpr.Const(WConst.I64 100L),
            WExpr.Let("f", WExpr.Const(WConst.F64 2.5),
              CB.applyClosure ctx (fn1 i32T i32T) clo [ i32T ] [ WExpr.Const(WConst.I32 1) ] WType.I32)))
    ctx.Functions.Add { Name = "run"; Params = [ "a", WType.I32 ]; Result = WType.I32; Locals = []; Body = main; Exported = true }
    "s12_mixed_captures", ctx

// ── S13: three mutually recursive closures + captured outer variable
//        a n = if n=0 then k   else b (n-1);  b n = if n=0 then k+1 else c (n-1);  c n = if n=0 then k+2 else a (n-1)
let s13 () =
    let ctx = newCtx ()
    let k, x = id32 "k", id32 "x"
    let fa, fb, fc = ident "fa" (fn1 i32T i32T), ident "fb" (fn1 i32T i32T), ident "fc" (fn1 i32T i32T)
    let mk (self: Fable.Ident) (next: Fable.Ident) (off: int) =
        let n = id32 "n"
        self, Fable.Lambda(n, ite (eq (var n) (num 0)) (add (var k) (num off)) (app (var next) [ sub (var n) (num 1) ] i32T), None)
    let e = Fable.LetRec([ mk fa fb 0; mk fb fc 1; mk fc fa 2 ], app (var fa) [ var x ] i32T)
    defFunc ctx "run" [ k; x ] e true |> ignore
    "s13_three_way_letrec", ctx

// ── S14: a closure that captures ANOTHER closure:  f = fun x -> x+1;  g = fun x -> f (f x);  run x = g x
let s14 () =
    let ctx = newCtx ()
    let x, a, b = id32 "x", id32 "a", id32 "b"
    let f = ident "f" (fn1 i32T i32T)
    let g = ident "g" (fn1 i32T i32T)
    let body =
        Fable.Let(f, Fable.Lambda(a, add (var a) (num 1), None),
            Fable.Let(g, Fable.Lambda(b, app (var f) [ app (var f) [ var b ] i32T ] i32T, None),
                app (var g) [ var x ] i32T))
    defFunc ctx "run" [ x ] body true |> ignore
    "s14_closure_captures_closure", ctx

// ── S15: an exception thrown INSIDE a closure is caught by the caller (payload survives call_ref)
let s15 () =
    let ctx = newCtx ()
    let boxIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add { Name = "Boxed"; Def = WTypeDef.Struct([ { Name = "v"; Type = WType.I32; Mutable = false } ], None) }
    let boxTy = WType.Ref(boxIdx, false)
    let spec : CB.ClosureSpec = { FuncName = "$thrower"; ArgParams = [ "z", WType.I32 ]; Captures = []; RetType = WType.I32 }
    let body =
        WExpr.Sequence [ WExpr.GlobalSet("$fsharp_exn_carrier", WExpr.StructNew(boxIdx, [ WExpr.LocalGet("z", WType.I32) ], boxTy))
                         WExpr.Throw WExpr.Nop
                         WExpr.Const(WConst.I32 0) ]
    let clo = CB.buildOne ctx spec body
    let call = CB.applyClosure ctx (fn1 i32T i32T) clo [ i32T ] [ WExpr.LocalGet("x", WType.I32) ] WType.I32
    let main =
        WExpr.TryCatch(call,
            Some("e", WExpr.StructGet(WExpr.Cast(WExpr.GlobalGet("$fsharp_exn_carrier", WType.AnyRef), boxTy), 0, WType.I32)),
            None, WType.I32)
    ctx.Functions.Add { Name = "run"; Params = [ "x", WType.I32 ]; Result = WType.I32; Locals = []; Body = main; Exported = true }
    "s15_throw_in_closure", ctx

let all = [ s1; s2; s3; s4; s5; s6; s7; s8; s9; s10; s11; s12; s13; s14; s15 ]
