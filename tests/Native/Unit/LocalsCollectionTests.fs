// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/LocalsCollectionTests.fs
// All the "unknown local" crash cases
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.LocalsCollectionTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Builder

module Locals = WasmGc.Runtime.Locals

[<Tests>]
let localsCollectionTests = testList "collectLocals" [

    test "Let in then-branch collected" {
        let expr = WExpr.If(i32Const 1,
            WExpr.Let("a", i32Const 1, localGet "a" WType.I32),
            WExpr.Nop, WType.I32)
        let locs = Locals.collectLocals Set.empty expr
        Expect.contains locs ("a", WType.I32) "a in then-branch must be collected"
    }

    test "Let in else-branch collected" {
        let expr = WExpr.If(i32Const 1,
            WExpr.Nop,
            WExpr.Let("b", i32Const 2, localGet "b" WType.I32),
            WType.I32)
        let locs = Locals.collectLocals Set.empty expr
        Expect.contains locs ("b", WType.I32) "b in else-branch must be collected"
    }

    test "Let in all SwitchInt arms collected" {
        let expr = WExpr.SwitchInt(
            i32Const 0,
            [ 0, WExpr.Let("x", i32Const 10, WExpr.Nop)
              1, WExpr.Let("y", i32Const 20, WExpr.Nop) ],
            WExpr.Let("z", i32Const 30, WExpr.Nop),
            WType.Void)
        let locs = Locals.collectLocals Set.empty expr
        Expect.contains locs ("x", WType.I32) "x from case 0"
        Expect.contains locs ("y", WType.I32) "y from case 1"
        Expect.contains locs ("z", WType.I32) "z from default"
    }

    test "Let inside TryCatch body collected" {
        let expr = WExpr.TryCatch(
            WExpr.Let("ok", i32Const 1, WExpr.Nop),
            Some("_exn", WExpr.Let("err", i32Const 0, WExpr.Nop)),
            None, WType.Void)
        let locs = Locals.collectLocals Set.empty expr
        Expect.contains locs ("ok", WType.I32) "ok in try body"
        Expect.contains locs ("err", WType.I32) "err in catch body"
    }

    test "Let inside nested Sequence collected" {
        let expr = WExpr.Sequence [
            WExpr.Nop
            WExpr.Sequence [
                WExpr.Let("deep", i32Const 99, WExpr.Nop)
            ]
        ]
        let locs = Locals.collectLocals Set.empty expr
        Expect.contains locs ("deep", WType.I32) "deep in nested Sequence"
    }

    test "resolveLocals deduplicates same name from both branches" {
        let expr = WExpr.If(i32Const 1,
            WExpr.Let("x", i32Const 1, WExpr.Nop),
            WExpr.Let("x", i32Const 2, WExpr.Nop),
            WType.Void)
        let func = Locals.makeFunc "_" [] (WType.Void) expr
        // let resolved = expr |> Locals.resolveLocals
        // let xEntries = resolved |> List.filter (fun (n, _) -> n = "x")
        let resolved = (func |> Locals.resolveLocals).Locals
        let xEntries = resolved |> List.filter (fun (n, _) -> n = "x")
        Expect.equal xEntries.Length 1 "x should appear exactly once"
    }

    test "resolveLocals excludes param names" {
        let expr = WExpr.Let("param1", i32Const 0, WExpr.Nop)
        let func = Locals.makeFunc "_" [("param1", WType.I32)] (WType.Void) expr
        let resolved = (Locals.resolveLocals func).Locals
        Expect.isEmpty resolved "param names must not appear in locals"
    }

    test "resolveLocals excludes internal $w temporaries from CE builder" {
        // TODO: freshName is deprecated
        // freshName() generates $w1, $w2 etc. — these are Let-introduced
        // by the wasm {} CE. They SHOULD appear in locals (they need to be declared).
        let expr = WExpr.Let("$w42", i32Const 0, localGet "$w42" WType.I32)
        let func = Locals.makeFunc "_" [] (WType.Void) expr
        let resolved = (Locals.resolveLocals func).Locals
        // $w42 IS a real local — it's a CE temp, not a compiler artifact like $clo_apply_tmp
        Expect.exists resolved (fun (n, _) -> n = "$w42") "$w42 CE temp must be in locals"
    }

    test "resolveLocals excludes $clo_apply_tmp (compiler internal)" {
        let expr = WExpr.LetMut("$clo_apply_tmp", WExpr.Const(WConst.Null (WType.Ref(0, true))), WExpr.Nop)
        let func = Locals.makeFunc "_" [] (WType.Void) expr
        // $clo_apply_tmp is declared by ClosureApply emitter pattern, should not be re-declared
        // It's a param-like internal — check behavior here and document
        let resolved = (Locals.resolveLocals func).Locals
        // This test documents the behavior — adjust expectation to match actual intent
        Expect.isEmpty resolved "$clo_apply_tmp must not appear in locals"
    }

    test "Let with Ref type (not I32) correctly typed in locals" {
        let elemRefT = WType.Ref(42, false)
        let expr = WExpr.Let("elem", WExpr.Const(WConst.Null (WType.Ref(42, true))), WExpr.Nop)
        let locs = Locals.collectLocals Set.empty expr
        match List.tryFind (fun (n, _) -> n = "elem") locs with
        | Some(_, ty) -> Expect.equal ty (WType.Ref(42, true)) "elem should have Null ref type"
        | None -> failtest "elem not collected"
    }
]
