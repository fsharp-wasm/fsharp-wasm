/// Optimizer regression tests — one test per transformation, property-based where appropriate.
/// Tests are deterministic: input WExpr → expected output WExpr, exact match.
module Tests.Unit.OptimizeTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Emit.Optimize
open WasmGc.Builder
open Tests.Snapshot.Framework

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

let private opt  = optimizeFuncBody
let private same e = Expect.equal (opt e) e "should not change pure-already-optimised expr"

let private i32 n  = WExpr.Const(WConst.I32 n)
let private i64 n  = WExpr.Const(WConst.I64 n)
let private f64 v  = WExpr.Const(WConst.F64 v)
let private g name = WExpr.LocalGet(name, WType.I32)
let private bin op a b = WExpr.Binary(op, a, b, WType.I32)
let private cmp op a b = WExpr.Compare(op, a, b)

// ─────────────────────────────────────────────────────────────────────────────
// Constant folding
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let constFoldTests = testList "Optimize / constant folding" [

    test "i32 addition of literals" {
        Expect.equal (opt (bin WBinaryOp.Add (i32 3) (i32 4))) (i32 7) "3 + 4 = 7"
    }
    test "i32 subtraction" {
        Expect.equal (opt (bin WBinaryOp.Sub (i32 10) (i32 3))) (i32 7) "10 - 3 = 7"
    }
    test "i32 multiplication" {
        Expect.equal (opt (bin WBinaryOp.Mul (i32 6) (i32 7))) (i32 42) "6 * 7 = 42"
    }
    test "i32 division" {
        Expect.equal (opt (bin WBinaryOp.DivS (i32 42) (i32 7))) (i32 6) "42 / 7 = 6"
    }
    test "i32 division by zero is not folded" {
        let e = bin WBinaryOp.DivS (i32 1) (i32 0)
        same e  // must not evaluate — would trap at runtime
    }
    test "i32 bitwise AND" {
        Expect.equal (opt (bin WBinaryOp.And (i32 0xFF) (i32 0x0F))) (i32 0x0F) "0xFF & 0x0F"
    }
    test "i32 shift left" {
        Expect.equal (opt (WExpr.Binary(WBinaryOp.Shl, i32 1, i32 3, WType.I32))) (i32 8) "1 << 3 = 8"
    }
    test "i32 unsigned shift right" {
        Expect.equal (opt (WExpr.Binary(WBinaryOp.ShrU, i32 -1, i32 28, WType.I32)))
            (i32 15) "0xFFFFFFFF >>> 28 = 0xF = 15"
    }
    test "f64 multiplication" {
        Expect.equal (opt (WExpr.Binary(WBinaryOp.Mul, f64 2.0, f64 3.5, WType.F64))) (f64 7.0) "2.0 * 3.5"
    }
    test "comparison: 3 < 4 → 1" {
        Expect.equal (opt (cmp WCompareOp.LtS (i32 3) (i32 4))) (i32 1) "3 < 4 → true"
    }
    test "comparison: 5 < 4 → 0" {
        Expect.equal (opt (cmp WCompareOp.LtS (i32 5) (i32 4))) (i32 0) "5 < 4 → false"
    }
    test "branch elimination: if 1 then A else B → A" {
        let a = WExpr.Call("a", [], WType.I32)
        let b = WExpr.Call("b", [], WType.I32)
        let result = opt (WExpr.If(i32 1, a, b, WType.I32))
        Expect.equal result a "if true always takes then branch"
    }
    test "branch elimination: if 0 then A else B → B" {
        let a = WExpr.Call("a", [], WType.I32)
        let b = WExpr.Call("b", [], WType.I32)
        Expect.equal (opt (WExpr.If(i32 0, a, b, WType.I32))) b "if false always takes else branch"
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Algebraic identities
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let identityTests = testList "Optimize / algebraic identities" [
    test "x + 0 → x" {
        Expect.equal (opt (bin WBinaryOp.Add (g "x") (i32 0))) (g "x") ""
    }
    test "0 + x → x" {
        Expect.equal (opt (bin WBinaryOp.Add (i32 0) (g "x"))) (g "x") ""
    }
    test "x - 0 → x" {
        Expect.equal (opt (bin WBinaryOp.Sub (g "x") (i32 0))) (g "x") ""
    }
    test "x * 1 → x" {
        Expect.equal (opt (bin WBinaryOp.Mul (g "x") (i32 1))) (g "x") ""
    }
    test "x * 0 → 0" {
        Expect.equal (opt (bin WBinaryOp.Mul (g "x") (i32 0))) (i32 0) ""
    }
    test "x & 0 → 0" {
        Expect.equal (opt (bin WBinaryOp.And (g "x") (i32 0))) (i32 0) ""
    }
    test "x | 0 → x" {
        Expect.equal (opt (bin WBinaryOp.Or (g "x") (i32 0))) (g "x") ""
    }
    test "x - x → 0 (same local)" {
        Expect.equal (opt (bin WBinaryOp.Sub (g "x") (g "x"))) (i32 0) ""
    }
    test "x ^ x → 0 (same local)" {
        Expect.equal (opt (WExpr.Binary(WBinaryOp.Xor, g "x", g "x", WType.I32))) (i32 0) ""
    }
    test "x == x → 1 (same local)" {
        Expect.equal (opt (cmp WCompareOp.Eq (g "x") (g "x"))) (i32 1) ""
    }
    test "x != x → 0 (same local)" {
        Expect.equal (opt (cmp WCompareOp.Ne (g "x") (g "x"))) (i32 0) ""
    }
    test "not(not(x)) → x" {
        let notX = WExpr.Unary(WUnaryOp.Eqz, g "x", WType.I32)
        Expect.equal (opt (WExpr.Unary(WUnaryOp.Eqz, notX, WType.I32))) (g "x") ""
    }
    test "refIsNull(structNew) → 0 (never null)" {
        let sn = WExpr.StructNew(0, [], WType.Ref(0, false))
        Expect.equal (opt (WExpr.RefIsNull sn)) (i32 0) "freshly allocated struct is never null"
    }
    test "refIsNull(null ref) → 1" {
        Expect.equal (opt (WExpr.RefIsNull(WExpr.Const(WConst.Null(WType.Ref(0, true)))))) (i32 1) ""
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Strength reduction
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let strengthTests = testList "Optimize / strength reduction" [
    test "x * 4 → x << 2" {
        let result = opt (bin WBinaryOp.Mul (g "x") (i32 4))
        Expect.equal result (WExpr.Binary(WBinaryOp.Shl, g "x", i32 2, WType.I32)) ""
    }
    test "x * 8 → x << 3" {
        let result = opt (bin WBinaryOp.Mul (g "x") (i32 8))
        Expect.equal result (WExpr.Binary(WBinaryOp.Shl, g "x", i32 3, WType.I32)) ""
    }
    test "4 * x → x << 2 (commutative)" {
        let result = opt (bin WBinaryOp.Mul (i32 4) (g "x"))
        Expect.equal result (WExpr.Binary(WBinaryOp.Shl, g "x", i32 2, WType.I32)) ""
    }
    test "x / 2 → x >> 1 (signed)" {
        let result = opt (WExpr.Binary(WBinaryOp.DivS, g "x", i32 2, WType.I32))
        Expect.equal result (WExpr.Binary(WBinaryOp.ShrS, g "x", i32 1, WType.I32)) ""
    }
    test "x / 8 → x >> 3 (signed)" {
        let result = opt (WExpr.Binary(WBinaryOp.DivS, g "x", i32 8, WType.I32))
        Expect.equal result (WExpr.Binary(WBinaryOp.ShrS, g "x", i32 3, WType.I32)) ""
    }
    test "x * 3 is NOT strength-reduced (not power of two)" {
        // 3 is not a power of two — must not be reduced
        let e = bin WBinaryOp.Mul (g "x") (i32 3)
        same e
    }
    test "i32 * 4 literal is fully folded (not reduced to shift)" {
        // Constant folding should fold i32 * i32 before strength reduction
        Expect.equal (opt (bin WBinaryOp.Mul (i32 5) (i32 4))) (i32 20) "5*4=20 (not 5<<2)"
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Dead code elimination
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let dceTests = testList "Optimize / dead code elimination" [
    test "unused pure let is dropped" {
        let body = WExpr.Let("tmp", i32 42, g "x")
        Expect.equal (opt body) (g "x") "let tmp = 42 in x  →  x  (tmp not used)"
    }
    test "used let is preserved" {
        let body = WExpr.Let("tmp", i32 42, g "tmp")
        // After alias removal + folding, this becomes i32 42
        let result = opt body
        Expect.equal result (i32 42) ""
    }
    test "empty sequence → Nop" {
        Expect.equal (opt (WExpr.Sequence [])) WExpr.Nop ""
    }
    test "singleton sequence unwraps" {
        Expect.equal (opt (WExpr.Sequence [g "x"])) (g "x") ""
    }
    test "pure intermediate in sequence is dropped" {
        // [pure_expr; result] → [result]  (pure_expr has no side effects)
        let body = WExpr.Sequence [i32 99; g "x"]
        Expect.equal (opt body) (g "x") ""
    }
    test "impure intermediate in sequence is kept" {
        let call = WExpr.Call("sideEffect", [], WType.Void)
        let body = WExpr.Sequence [call; g "x"]
        // call is not pure — must be retained
        let result = opt body
        match result with
        | WExpr.Sequence [c; x] ->
            Expect.equal c call "impure call must be kept"
            Expect.equal x (g "x") "result must be x"
        | _ -> failtestf "Expected Sequence[call; x], got %A" result
    }
    test "if both branches Nop, whole if dropped when guard pure" {
        let e = WExpr.If(i32 1, WExpr.Nop, WExpr.Nop, WType.Void)
        // First: const fold → then branch = Nop; DCE sees both Nop → drops all
        Expect.equal (opt e) WExpr.Nop ""
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Let-alias removal
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let aliasTests = testList "Optimize / let-alias removal" [
    test "let x = y; use x → use y directly" {
        let body = WExpr.Let("x", g "y",
                     WExpr.Binary(WBinaryOp.Add, g "x", i32 1, WType.I32))
        let expected = WExpr.Binary(WBinaryOp.Add, g "y", i32 1, WType.I32)
        Expect.equal (opt body) expected ""
    }
    test "aliased and then constant-folded chain" {
        // let x = y; let z = x + 0 → let z = y → z = y (after fold: x+0→x, alias: x→y)
        let body =
            WExpr.Let("x", g "y",
                WExpr.Let("z", WExpr.Binary(WBinaryOp.Add, g "x", i32 0, WType.I32),
                    g "z"))
        Expect.equal (opt body) (g "y") "chain: x→y, x+0→x→y, let z=y; z→y"
    }
    test "alias not removed when x is later reassigned" {
        // let x = y; x := 0; use x — alias must not be substituted
        let body =
            WExpr.Let("x", g "y",
                WExpr.Sequence [
                    WExpr.Assign("x", i32 0)
                    g "x"
                ])
        // x is assigned → alias removal must NOT substitute y for x
        let result = opt body
        match result with
        | WExpr.Let("x", _, _) -> ()  // preserved
        | _ -> failtestf "let x = y must be preserved when x is reassigned: %A" result
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Compose: multi-pass interactions
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let composeTests = testList "Optimize / composed passes" [
    test "const fold + DCE: let x = 1 + 2 in 99 → 99" {
        let body = WExpr.Let("x", bin WBinaryOp.Add (i32 1) (i32 2), i32 99)
        // Pass 1: fold 1+2=3 → Let("x", 3, 99)
        // Pass 4: x unused, 3 pure → drop → 99
        Expect.equal (opt body) (i32 99) ""
    }
    test "strength + fold: x * 4 * 0 → 0" {
        // x * 4 * 0
        let e = bin WBinaryOp.Mul (bin WBinaryOp.Mul (g "x") (i32 4)) (i32 0)
        Expect.equal (opt e) (i32 0) "anything * 0 = 0"
    }
    test "nested const fold: (1+2)*(3+4) → 21" {
        let e = bin WBinaryOp.Mul
                    (bin WBinaryOp.Add (i32 1) (i32 2))
                    (bin WBinaryOp.Add (i32 3) (i32 4))
        Expect.equal (opt e) (i32 21) "(1+2)*(3+4) = 3*7 = 21"
    }
    test "branch-in-branch elimination" {
        // if (1 == 1) then if 0 then A else B else C  →  B
        let a = WExpr.Call("a", [], WType.I32)
        let b = WExpr.Call("b", [], WType.I32)
        let c = WExpr.Call("c", [], WType.I32)
        let inner = WExpr.If(i32 0, a, b, WType.I32)
        let outer = WExpr.If(cmp WCompareOp.Eq (i32 1) (i32 1), inner, c, WType.I32)
        Expect.equal (opt outer) b "if(1==1) then (if 0 then A else B) else C  →  B"
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Snapshot tests — regression detection for the full optimizer
// ─────────────────────────────────────────────────────────────────────────────

// Typical array-map generated WExpr (before optimization)
let private arrayMapBody =
    let arrTy = WType.Ref(1, false)
    WExpr.Let("n", WExpr.ArrayLen(g "arr"),
        WExpr.Let("res", WExpr.ArrayNew(1, g "n", i32 0, arrTy),
            WExpr.LetMut("i", i32 0,
                WExpr.Sequence [
                    WExpr.Binary(WBinaryOp.Add, i32 0, i32 0, WType.I32)  // dead expr
                    WExpr.Block("exit",
                        WExpr.Loop("lp",
                            WExpr.If(
                                WExpr.Compare(WCompareOp.LtS, g "i", g "n"),
                                WExpr.Sequence [
                                    WExpr.ArraySet(g "res", g "i",
                                        WExpr.Binary(WBinaryOp.Mul, WExpr.ArrayGet(g "arr", g "i", WType.I32), i32 2, WType.I32))
                                    WExpr.Assign("i", WExpr.Binary(WBinaryOp.Add, g "i", i32 1, WType.I32))
                                    WExpr.Continue("lp", [])
                                ],
                                WExpr.Break("exit", None),
                                WType.Void),
                            WType.Void),
                        WType.Void)
                    g "res"
                ])))

[<Tests>]
let snapshotTests = testList "Optimize / snapshots" [
    wexprSnapshot "optimizer/array-map-before" arrayMapBody
    wexprSnapshot "optimizer/array-map-after" (opt arrayMapBody)
    wexprSnapshot "optimizer/const-chain-before" (
        bin WBinaryOp.Mul
            (bin WBinaryOp.Add (i32 1) (i32 2))
            (bin WBinaryOp.Add (i32 3) (i32 4)))
    wexprSnapshot "optimizer/const-chain-after" (
        opt (bin WBinaryOp.Mul
                (bin WBinaryOp.Add (i32 1) (i32 2))
                (bin WBinaryOp.Add (i32 3) (i32 4))))
]