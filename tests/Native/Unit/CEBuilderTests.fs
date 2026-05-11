// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/CEBuilderTests.fs
// The wasm {} computation expression — all important patterns
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.CEBuilderTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Builder.Core

module WExprQuery = WasmGc.Util.WExprQuery

[<Tests>]
let ceBuilderTests = testList "wasm {} CE builder" [

    test "let! x = i32 → Let node with LocalGet continuation" {
        let result = wasm { 
            let! x: WExpr = (i32Const 42) in return x }
        match result with
        | WExpr.Let(name, WExpr.Const(WConst.I32 42), WExpr.LocalGet(name2, WType.I32))
            when name = name2 -> ()
        | other -> failtestf "Expected Let($w, i32(42), LocalGet($w)) but got %A" other
    }

    test "let! v = mut i32 → LetMut node with WVar handle" {
        let result = wasm {
            let! v = mut (i32Const 0)
            return v.Val
        }
        match result with
        | WExpr.LetMut(n, WExpr.Const(WConst.I32 0), WExpr.LocalGet(n2, WType.I32))
            when n = n2 -> ()
        | other -> failtestf "Expected LetMut then LocalGet but got %A" other
    }

    test "do! void expr → Sequence(void, continuation)" {
        let result = wasm {
            do! WExpr.ArraySet(localGet "$a" WType.I32, i32Const 0, i32Const 1)
            return i32Const 99
        }
        match result with
        | WExpr.Sequence [WExpr.ArraySet _; WExpr.Const(WConst.I32 99)] -> ()
        | other -> failtestf "Expected Seq(ArraySet, i32(99)) but got %A" other
    }

    test "while! guard → Block/Loop/If structure" {
        let result = wasm {
            let! i = mut (i32Const 0)
            while! (ltS (localGet "i" WType.I32) (i32Const 10)) do
                do! localSet "i" (add (localGet "i" WType.I32) (i32Const 1))
        }
        // Should produce: LetMut(i, 0, Block($exit, Loop($lp, If(i<10, ..., Break))))
        let hasLoop = WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result
        Expect.isNonEmpty hasLoop "while! should produce a Loop node"
        let hasBlock = WExprQuery.collect (function WExpr.Block _ -> true | _ -> false) result
        Expect.isNonEmpty hasBlock "while! should produce an exit Block"
    }

    test "Combine: Nop + expr → expr (no spurious Nop)" {
        let result = wasm {
            do! WExpr.Nop
            return i32Const 5
        }
        // The Nop should be dropped by Combine
        match result with
        | WExpr.Const(WConst.I32 5) -> ()  // ideal: Nop dropped
        | WExpr.Sequence [WExpr.Nop; WExpr.Const(WConst.I32 5)] ->
            failtest "Bug: Nop not eliminated from Sequence"
        | other -> failtestf "Unexpected: %A" other
    }

    test "Combine is not order-sensitive for Nop" {
        let a = wasm { return i32Const 1 }
        let b = WExpr.Nop
        let combined = WasmBuilder().Combine(a, b)
        Expect.equal combined (i32Const 1) "Combine(expr, Nop) should return expr"
        let combined2 = WasmBuilder().Combine(b, a)
        Expect.equal combined2 (i32Const 1) "Combine(Nop, expr) should return expr"
    }

    test "let! x = void-typed expr → sequences it and continues with Nop" {
        let voidCall = WExpr.Call("$sideEffect", [], WType.Void)
        let result = wasm {
            let! _: WExpr = voidCall
            return (i32Const 7)
        }
        match result with
        | WExpr.Sequence [WExpr.Call("$sideEffect", [], WType.Void); WExpr.Const(WConst.I32 7)] -> ()
        | other -> failtestf "Void let! should sequence and continue: %A" other
    }

    test "return! passes WExpr through unchanged" {
        let inner = WExpr.Call("$foo", [i32Const 1], WType.I32)
        let result = wasm { return! inner }
        Expect.equal result inner "return! should not wrap the expression"
    }

    test "wasmAnd produces If(a, b, 0, I32) — short-circuit" {
        let result = wasmAnd (i32Const 1) (i32Const 2)
        match result with
        | WExpr.If(WExpr.Const(WConst.I32 1), WExpr.Const(WConst.I32 2), WExpr.Const(WConst.I32 0), WType.I32) -> ()
        | other -> failtestf "Expected short-circuit If but got %A" other
    }

    test "wasmIf with diverging then-branch takes else type" {
        let brk = WExpr.Break("$lbl", None)  // diverges, type = Void
        let result = wasmIf (i32Const 0) brk (i32Const 5)
        match result with
        | WExpr.If(_, WExpr.Break _, WExpr.Const(WConst.I32 5), WType.I32) -> ()
        | other -> failtestf "Should take I32 from else-branch: %A" other
    }

    test "loopResult generates Block/Loop with break-with-value" {
        let result = loopResult WType.I32 (i32Const (-1)) (fun brk ->
            wasm { return! brk (i32Const 42) })
        let blocks = WExprQuery.collect (function WExpr.Block _ -> true | _ -> false) result
        Expect.isNonEmpty blocks "loopResult should wrap in a Block"
        let breakWithVal = WExprQuery.collect (function WExpr.Break(_, Some _) -> true | _ -> false) result
        Expect.isNonEmpty breakWithVal "loopResult should have a Break-with-value"
    }

    test "WVar <== shorthand works inside wasm block" {
        let result = wasm {
            let! v = mut (i32Const 0)
            do! v <== i32Const 99
            return v.Val
        }
        // Should contain an Assign node
        let assigns = WExprQuery.collect (function WExpr.Assign _ -> true | _ -> false) result
        Expect.isNonEmpty assigns "<== should produce an Assign node"
    }

]
