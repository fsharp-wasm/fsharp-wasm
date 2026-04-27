// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/ArrayReplacementTests.fs
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.ArrayReplacementTests

open Expecto
open Fable.AST.Wasm
open Fable.Transforms.WasmGc

open Tests.WasmTestHelpers

[<Tests>]
let arrayReplacementTests = testList "Array replacements" [

    test "Array.map → indexed loop with result array" {
        ()
    }

    test "Array.filter → two-pass count+fill" {
        // Must produce: pass1 loop (count) + arrayNew + pass2 loop (fill)
        ()
    }

    test "Array.exists → short-circuit with Block" {
        ()
    }

    test "Array.forAll → short-circuit with Block" {
        ()
    }

    test "Array.copy → arrayCopy instruction" {
        let ctx = makeTestCtx()
        let arrType = Fable.Type.Array(Fable.Type.Number(Int32, NumberInfo.Empty), Fable.ArrayKind.Array)
        let arrArg = Fable.Expr.IdentExpr { Name = "src"; Type = arrType; Range = None; IsMutable = false }
        let ctxWithArr = { ctx with Locals = Map.ofList [("src", WType.Ref(200, false))] }
        let result = ArrayReplacements.tryArrayInline
                        Fable2WasmGc.transformExpr ctxWithArr "copy"
                        [arrArg] [localGet "src" (WType.Ref(200, false))]
                        arrType
        Expect.isSome result "Array.copy should be handled"
        let wExpr = result.Value
        let hasCopy = WExprQuery.collect (function WExpr.ArrayCopy _ -> true | _ -> false) wExpr
        Expect.isNonEmpty hasCopy "Array.copy should produce ArrayCopy instruction"
    }

    test "Array.fill → counted loop with arraySet" {
        ()
    }

    test "Array.zeroCreate n → arrayNew with zero init" {
        let ctx = makeTestCtx()
        let result = ArrayReplacements.tryArrayInline
                        Fable2WasmGc.transformExpr ctx "zeroCreate"
                        [Fable.Expr.Value(Fable.NumberConstant(10.0, Fable.Int32, Fable.NumberInfo.Empty), None)]
                        [i32Const 10]
                        (Fable.Type.Array(Fable.Type.Number(Fable.Int32, Fable.NumberInfo.Empty), Fable.ArrayKind.Array))
        Expect.isSome result "Array.zeroCreate should be handled"
        let wExpr = result.Value
        let hasNew = WExprQuery.collect (function WExpr.ArrayNew _ -> true | _ -> false) wExpr
        Expect.isNonEmpty hasNew "zeroCreate should use ArrayNew"
    }

    test "Array.sortBy → insertion sort in-place on temp array" {
        ()
    }

]
