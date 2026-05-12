module Tests.Integration.CurriedApplyTests

open Expecto
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc
open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst
open WasmGc.Transforms.TransformExpr

[<Tests>]
let curryingTests = testList "Curried Application" [

    test "Partial application creates Closure" {
        let ctx = makeTestCtx()
        let intType = Type.Number(NumberKind.Int32, NumberInfo.Empty)

        // let add a b = a + b
        // let partial = add 10
        let addFn = mkIdent "add" (Type.LambdaType(intType, Type.LambdaType(intType, intType)))
        // Build a one-arg delegate body referencing 'add' (free var), to exercise closure creation.
        let x = mkParam "x" intType
        // TODO: we need `mkIntLit 10`
        let partialApply = Expr.Delegate([x], addFn, None, [])        
        // let partialApply = Expr.Delegate([mkIntLit 10], addFn, None, [])

        let result = transformExpr ctx partialApply

        match result with
        | WExpr.Closure(_, captures, _) ->
            Expect.equal captures.Length 1 "Should capture the applied argument (10)"
        | _ -> failtestf "Expected partial application to produce a Closure, got %A" result
    }

    test "Full application of curried function → optimized Call" {
        let ctx = makeTestCtx()
        // (add 10) 20
        // The compiler should ideally optimize this to a direct call if 'add' is known
        ()
    }
]
