module Tests.Unit.PatternMatchTests

open Expecto
open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc
open WasmGc.Transform.TransformExpr

open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst

[<Tests>]
let patternMatchTests = testList "Pattern Matching" [

    test "Simple DU match (Option-like)" {
        let ctx = makeTestCtx()

        // Setup: match someValue with | Some x -> x | None -> 0
        let intType = Type.Number(NumberKind.Int32, NumberInfo.Empty)
        let optionType = Type.Option(intType, false)

        let target = mkIdent "opt" optionType

        // Fable lowers matches to DecisionTree
        // This is a simplified manual construction of the AST Fable produces
        let matchExpr = Expr.DecisionTree(
            target,
            [
                // Case 0: Some x -> return x
                (DecisionTree.DecisionTreeTest.Test(DecisionTree.TestKind.UnionCaseTag 1, target), 0)
            ],
            [
                // Decision 0 (Some): Get field 0
                Expr.Operation(OperationKind.UnionFieldGet(1, 0, optionType), intType, None)
                // Decision 1 (None): Return 0
                mkIntLit 0
            ],
            intType, None
        )

        let result = transformExpr ctx matchExpr

        // Expectation: WasmGC should produce an 'if' checking the tag
        // followed by a struct.get to extract the value
        match result with
        | WExpr.If(_, WExpr.StructGet _, WExpr.Const _, _) -> ()
        | _ -> failtestf "Expected If/StructGet for DU match, got %A" result
    }
]
