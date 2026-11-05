module FreeVarChecks
open Fable.AST
open Fable.AST.Fable
open Lib
open WasmGc.Runtime.FreeVars

let run () : bool =
    let arr, i, x, m = ident "arr" (Fable.Type.Array(i32T, ArrayKind.MutableArray)), id32 "i", id32 "x", ident "m" Fable.Type.String
    let cases : (string * Fable.Expr * string list) list =
        [ "arr.[i]   (ExprGet index)", Fable.Get(var arr, GetKind.ExprGet(var i), i32T, None), [ "arr"; "i" ]
          "arr.[i] <- x (ExprSet index)", Fable.Set(var arr, SetKind.ExprSet(var i), i32T, var x, None), [ "arr"; "i"; "x" ]
          "$\"..{x}..\" (StringTemplate)", Fable.Value(ValueKind.StringTemplate(None, [ "a"; "b" ], [ var x ]), None), [ "x" ]
          "raise msg   (Extended Throw)", Fable.Extended(ExtendedSet.Throw(Some(var m), i32T), None), [ "m" ]
          "<@ x @>      (Quote)", Fable.Quote(var x, true, None), [ "x" ]
          "fun x -> x + i (bound arg)", Fable.Lambda(x, add (var x) (var i), None), [ "i" ] ]
    let mutable ok = true
    for (name, e, expected) in cases do
        let got = collectFreeVars Set.empty e |> Set.toList |> List.sort
        let pass = got = List.sort expected
        if not pass then ok <- false
        printfn "  %-34s %s  free = %A" name (if pass then "PASS" else "FAIL") got
    ok

module OptChecks =
    open WasmGc.Core.AST
    let run () : bool =
        let opt = WasmGc.Emit.Optimize.optimizeFuncBody
        let i32 n = WExpr.Const(WConst.I32 n)
        let g n = WExpr.LocalGet(n, WType.I32)
        let fx = WExpr.LocalGet("x", WType.F64)
        let bin op a b = WExpr.Binary(op, a, b, WType.I32)
        let cases : (string * bool) list =
            [ "x / 2 left alone",                  (let e = bin WBinaryOp.DivS (g "x") (i32 2) in opt e = e)
              "MinValue / -1 not folded",          (let e = bin WBinaryOp.DivS (i32 System.Int32.MinValue) (i32 -1) in opt e = e)
              "if 5 → then",                       (opt (WExpr.If(i32 5, i32 1, i32 2, WType.I32)) = i32 1)
              "if 0 → else",                       (opt (WExpr.If(i32 0, i32 1, i32 2, WType.I32)) = i32 2)
              "f64 x - x kept",                    (let e = WExpr.Binary(WBinaryOp.Sub, fx, fx, WType.F64) in opt e = e)
              "f64 x == x kept",                   (let e = WExpr.Compare(WCompareOp.Eq, fx, fx) in opt e = e)
              "call * 0 keeps call",               (let e = bin WBinaryOp.Mul (WExpr.Call("f", [], WType.I32)) (i32 0) in opt e = e)
              "i32 x - x → 0 (still folded)",      (opt (bin WBinaryOp.Sub (g "x") (g "x")) = i32 0)
              "x * 4 → x << 2 (still reduced)",    (opt (bin WBinaryOp.Mul (g "x") (i32 4)) = bin WBinaryOp.Shl (g "x") (i32 2))
              "!!x → x <> 0 for non-boolean x",    (let e = WExpr.Unary(WUnaryOp.Eqz, WExpr.Unary(WUnaryOp.Eqz, g "x", WType.I32), WType.I32) in opt e = WExpr.Compare(WCompareOp.Ne, g "x", i32 0))
              "!!(a < b) → a < b (boolean)",       (let c = WExpr.Compare(WCompareOp.LtS, g "a", g "b") in opt (WExpr.Unary(WUnaryOp.Eqz, WExpr.Unary(WUnaryOp.Eqz, c, WType.I32), WType.I32)) = c)
              "terminates with a NaN constant",    (let jp =
                                                        WExpr.JoinPoint("j", [ "p", WType.I32 ],
                                                            bin WBinaryOp.Mul (bin WBinaryOp.Add (g "p") (g "p")) (bin WBinaryOp.Add (g "p") (i32 3)),
                                                            WExpr.If(WExpr.Compare(WCompareOp.LtS, WExpr.Const(WConst.F64 nan), WExpr.Const(WConst.F64 1.0)),
                                                                     WExpr.JoinApply("j", [ i32 1 ], WType.I32), WExpr.JoinApply("j", [ i32 2 ], WType.I32), WType.I32), WType.I32)
                                                    System.Threading.Tasks.Task.Run(fun () -> opt jp |> ignore).Wait 5000)
              "alias kept when source reassigned", (match opt (WExpr.Let("j", g "i", WExpr.Sequence [ WExpr.Assign("i", bin WBinaryOp.Add (g "i") (i32 1)); g "j" ])) with WExpr.Let("j", _, _) -> true | _ -> false) ]
        let mutable ok = true
        for (n, p) in cases do
            if not p then ok <- false
            printfn "  %-36s %s" n (if p then "PASS" else "FAIL")
        ok

module ValidatorChecks =
    open WasmGc.Core.AST
    open WasmGc.Runtime.Types
    let run () : bool =
        // the exact shape the OLD letrec produced: a closure body reading its own (never bound) name
        let anyFn = WType.Ref(AnyFnTypeIdx, false)
        let bad = { Name = "$letrec_f_1"; Params = [ "$self", anyFn ]; Result = WType.I32; Locals = []; Exported = false
                    Body = WExpr.Sequence [ WExpr.Cast(WExpr.LocalGet("f", anyFn), anyFn); WExpr.Const(WConst.I32 1) ] }
        let td = System.Collections.Generic.List<WTypeDeclEntry>()
        let errs = WasmGc.Pipeline.Validator.validate false td [ WasmGc.Runtime.Locals.resolveLocals bad ]
        let found = errs |> List.exists (fun e -> e.Message.Contains "never bound")
        printfn "  unbound non-nullable ref reported   %s   (%d issue(s))" (if found then "PASS" else "FAIL") errs.Length
        found
