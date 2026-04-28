// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/ArrayReplacementTests.fs
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.ArrayReplacementTests

open Expecto
open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
// open Fable.Transforms.WasmGc
open WasmGc.Transforms
open WasmGc.Transforms.ArrayReplacements

open Tests.WasmTestHelpers


[<Tests>]
let arrayReplacementTests = testList "Array replacements" [

    test "Array.get (indexing) → ArrayGet" {
        let ctx = makeTestCtx()
        let intType = Type.Number(NumberKind.Int32, NumberInfo.Empty)
        let arrType = Type.Array(intType, ArrayKind.ResizeArray) // TODO: test other kinds too

        // arr.[0]
        let expr = Expr.Operation(
            OperationKind.ArrayGet(mkIntLit 0),
            Tags.empty, intType, None)

        // We need to provide the array instance to the operation
        // (In Fable 5, ArrayGet is often a curried apply or an Operation)
        let appliedExpr = Expr.Operation(
            OperationKind.ArrayGet(mkIntLit 0),
            [], intType, None)

        // Note: For unit tests, we usually test the specific replacement logic
        let result = ArrayReplacements.tryArrayGet ctx [mkIdent "arr" arrType; mkIntLit 0] intType

        match result with
        | Some(WExpr.ArrayGet _) -> ()
        | _ -> failtest "Array.get should transform to Wasm ArrayGet"
    }

    test "Array.length → ArrayLen" {
        let ctx = makeTestCtx()
        let arrType = Type.Array(Type.Number(NumberKind.Int32, NumberInfo.Empty), ArrayKind.ResizeArray)

        let result = ArrayReplacements.tryArrayLength ctx [mkIdent "arr" arrType]
        match result with
        | Some(WExpr.ArrayLen _) -> ()
        | _ -> failtest "Array.length should transform to Wasm ArrayLen"
    }

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
        let arrType = Fable.Type.Array(Fable.Type.Number(Int32, NumberInfo.Empty), Fable.ArrayKind.ResizeArray)
        // let arrArg = Fable.Expr.IdentExpr { Name = "src"; Type = arrType; Range = None; IsMutable = false }
        let arrArg = FableAst.mkIdent "src" arrType
        let ctxWithArr = { ctx with Locals = Map.ofList [("src", WType.Ref(200, false))] }
        let result = ArrayReplacements.tryArrayInline
                        Fable2Wasm.transformExpr ctxWithArr "copy"
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
                        Fable2Wasm.transformExpr ctx "zeroCreate"
                        [Fable.Expr.Value(Fable.NumberConstant(10.0, Fable.Int32, Fable.NumberInfo.Empty), None)]
                        [i32Const 10]
                        (Fable.Type.Array(Fable.Type.Number(Fable.Int32, Fable.NumberInfo.Empty), Fable.ArrayKind.ResizeArray))
        Expect.isSome result "Array.zeroCreate should be handled"
        let wExpr = result.Value
        let hasNew = WExprQuery.collect (function WExpr.ArrayNew _ -> true | _ -> false) wExpr
        Expect.isNonEmpty hasNew "zeroCreate should use ArrayNew"
    }

    test "Array.sortBy → insertion sort in-place on temp array" {
        ()
    }
]
