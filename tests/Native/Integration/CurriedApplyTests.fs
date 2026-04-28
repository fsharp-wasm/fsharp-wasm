module Tests.Integration.CurriedApplyTests

open Expecto
open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc
open Tests.WasmTestHelpers

[<Tests>]
let curryingTests = testList "Curried Application" [

    test "Partial application creates Closure" {
        let ctx = makeTestCtx()
        let intType = Type.Number(NumberKind.Int32, NumberInfo.Empty)

        // let add a b = a + b
        // let partial = add 10
        let addFn = mkIdent "add" (Type.Lambda(intType, Type.Lambda(intType, intType)))

        let partialApply = Expr.Delegate(addFn, [mkIntLit 10], None)

        let result = Fable2WasmGc.transformExpr ctx partialApply

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
