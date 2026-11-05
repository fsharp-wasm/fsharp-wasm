module EmitScenarios
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open Lib

let private i32 n = WExpr.Const(WConst.I32 n)
let private get n = WExpr.LocalGet(n, WType.I32)
let private add a b = WExpr.Binary(WBinaryOp.Add, a, b, WType.I32)
let private fn name ps res body exported : WFuncDecl = { Name = name; Params = ps; Result = res; Locals = []; Body = body; Exported = exported }
let private carrierGet = WExpr.GlobalGet("$fsharp_exn_carrier", WType.AnyRef)
let private cnt : WGlobalDecl = { Name = "$cnt"; Type = WType.I32; Init = i32 0; Mutable = true; Exported = false }

let private build (extraGlobals: WGlobalDecl list) (ctx: WasmGc.Runtime.Types.Ctx) (funcs: WFuncDecl list) =
    { mkModule ctx.TypeDefs funcs with Globals = carrier :: extraGlobals }

// E1: `break` out of a loop from INSIDE a try body  (label depth through try_table)
let e1 () =
    let ctx = newCtx ()
    let body =
        WExpr.LetMut("i", i32 0, WExpr.LetMut("acc", i32 0,
          WExpr.Sequence [
            WExpr.Block("exit",
              WExpr.Loop("L",
                WExpr.TryCatch(
                  WExpr.If(WExpr.Compare(WCompareOp.GeS, get "i", get "n"),
                           WExpr.Break("exit", None),
                           WExpr.Sequence [ WExpr.Assign("acc", add (get "acc") (get "i"))
                                            WExpr.Assign("i", add (get "i") (i32 1))
                                            WExpr.Continue("L", []) ],
                           WType.Void),
                  Some("e", WExpr.Assign("acc", i32 -1)), None, WType.Void),
                WType.Void),
              WType.Void)
            get "acc" ]))
    "e1_break_in_try", build [] ctx [ fn "run" ["n", WType.I32] WType.I32 body true ]

// E2: exception payload survives raise → catch  (carrier must not be cleared by `throw`)
let e2 () =
    let ctx = newCtx ()
    let boxIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add { Name = "Boxed"; Def = WTypeDef.Struct([ { Name = "v"; Type = WType.I32; Mutable = false } ], None) }
    let boxTy = WType.Ref(boxIdx, false)
    let body =
        WExpr.TryCatch(
            WExpr.Sequence [ WExpr.GlobalSet("$fsharp_exn_carrier", WExpr.StructNew(boxIdx, [ get "x" ], boxTy))
                             WExpr.Throw WExpr.Nop
                             i32 0 ],
            Some("e", WExpr.StructGet(WExpr.Cast(carrierGet, boxTy), 0, WType.I32)), None, WType.I32)
    "e2_exn_payload", build [] ctx [ fn "run" ["x", WType.I32] WType.I32 body true ]

// E3: decision-tree join point used twice, body too big to inline
let e3 () =
    let ctx = newCtx ()
    let jbody = add (add (WExpr.Binary(WBinaryOp.Mul, get "v", i32 100, WType.I32)) (get "v")) (i32 7)
    let cont =
        WExpr.If(WExpr.Compare(WCompareOp.Eq, get "x", i32 1), WExpr.JoinApply("t0", [ i32 10 ], WType.I32),
          WExpr.If(WExpr.Compare(WCompareOp.Eq, get "x", i32 2), WExpr.JoinApply("t0", [ i32 20 ], WType.I32), i32 0, WType.I32), WType.I32)
    "e3_shared_join", build [] ctx [ fn "run" ["x", WType.I32] WType.I32 (WExpr.JoinPoint("t0", ["v", WType.I32], jbody, cont, WType.I32)) true ]

// E4: try/finally  (finalizer ran never before)
let e4 () =
    let ctx = newCtx ()
    let incr = WExpr.GlobalSet("$cnt", add (WExpr.GlobalGet("$cnt", WType.I32)) (i32 1))
    let f1 = fn "normal" ["x", WType.I32] WType.I32 (WExpr.TryCatch(get "x", None, Some incr, WType.I32)) true
    let f2 =
        fn "thrown" [] WType.I32
            (WExpr.Sequence [
                WExpr.TryCatch(
                    WExpr.TryCatch(WExpr.Sequence [ WExpr.GlobalSet("$fsharp_exn_carrier", WExpr.Const(WConst.Null WType.AnyRef)); WExpr.Throw WExpr.Nop; i32 0 ], None, Some incr, WType.I32),
                    Some("e", i32 99), None, WType.I32)
                WExpr.GlobalGet("$cnt", WType.I32) ]) true
    let f3 = fn "count" [] WType.I32 (WExpr.GlobalGet("$cnt", WType.I32)) true
    "e4_try_finally", build [ cnt ] ctx [ f1; f2; f3 ]

// E5: signed division by a power of two on a negative operand
let e5 () =
    let ctx = newCtx ()
    "e5_div_neg", build [] ctx [ fn "run" ["x", WType.I32] WType.I32 (WExpr.Binary(WBinaryOp.DivS, get "x", i32 4, WType.I32)) true ]

// E6: float NaN constant + unsigned i64 compare
let e6 () =
    let ctx = newCtx ()
    let ltu = WExpr.Compare(WCompareOp.LtU, WExpr.Const(WConst.I64 1L), WExpr.Const(WConst.I64 -1L))
    "e6_nan_i64", build [] ctx [ fn "nan" [] WType.F64 (WExpr.Const(WConst.F64 nan)) true
                                 fn "ltu" [] WType.I32 ltu true ]

// E7: mutually recursive struct types (forward type reference needs a rec group)
let e7 () =
    let ctx = newCtx ()
    let a = ctx.TypeDefs.Count
    let b = a + 1
    ctx.TypeDefs.Add { Name = "A"; Def = WTypeDef.Struct([ { Name = "b"; Type = WType.Ref(b, true); Mutable = false } ], None) }
    ctx.TypeDefs.Add { Name = "B"; Def = WTypeDef.Struct([ { Name = "a"; Type = WType.Ref(a, true); Mutable = false }; { Name = "v"; Type = WType.I32; Mutable = false } ], None) }
    let body =
        WExpr.Let("bb", WExpr.StructNew(b, [ WExpr.Const(WConst.Null(WType.Ref(a, true))); get "x" ], WType.Ref(b, false)),
          WExpr.Let("aa", WExpr.StructNew(a, [ WExpr.LocalGet("bb", WType.Ref(b, false)) ], WType.Ref(a, false)),
            WExpr.StructGet(WExpr.LocalGet("bb", WType.Ref(b, false)), 1, WType.I32)))
    "e7_forward_types", build [] ctx [ fn "run" ["x", WType.I32] WType.I32 body true ]

let all = [ e1; e2; e3; e4; e5; e6; e7 ]
