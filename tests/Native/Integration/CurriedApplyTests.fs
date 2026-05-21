module Tests.Integration.CurriedApplyTests

open Expecto
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc
open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst
open WasmGc.Transforms.TransformExpr

open Tests.RealFSharpHelpers

open Tests.Snapshot.Framework

[<Tests>]
let curryingTests = testList "Curried Application" [

    // TODO: this is replaced with test below
    // test "Partial application creates Closure" {
    //     let ctx = makeTestCtx()
    //     let intType = Type.Number(NumberKind.Int32, NumberInfo.Empty)

    //     // let add a b = a + b
    //     // let partial = add 10
    //     let addFn = mkIdent "add" (Type.LambdaType(intType, Type.LambdaType(intType, intType)))
    //     // Build a one-arg delegate body referencing 'add' (free var), to exercise closure creation.
    //     let x = mkParam "x" intType
    //     // TODO: we need `mkIntLit 10`
    //     let partialApply = Expr.Delegate([x], addFn, None, [])        
    //     // let partialApply = Expr.Delegate([mkIntLit 10], addFn, None, [])

    //     let result = transformExpr ctx partialApply

    //     match result with
    //     | WExpr.Closure(_, captures, _) ->
    //         Expect.equal captures.Length 1 "Should capture the applied argument (10)"
    //     | _ -> failtestf "Expected partial application to produce a Closure, got %A" result
    // }
    
    test "Partial application via Real F# produces a Closure" {
        """
let add a b = a + b
let partial = add 10 // Erzeugt eine partielle Anwendung
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "partial")
            assertContains
                (function 

                    | WExpr.Closure(_, captures, _) -> true
                    | _ -> false)
                "Partial application 'add 10' must lower into a Closure"
                f.Body)
    }

    // test "Lambda capturing a free variable produces a Closure" {
    //     // Tests that a lambda which closes over a local variable produces
    //     // a WExpr.Closure with that variable in its capture list.
    //     // This is the real invariant — partial application is a higher-level concern.
    //     let ctx = { makeTestCtx() with Locals = Map.ofList [("captured", WType.I32)] }
    //     let intType = Type.Number(NumberKind.Int32, NumberInfo.Empty)
    //     let param   = mkParam "x" intType
    //     // fun x -> x + captured   (captured is a free variable → must be in closure)
    //     let body = Expr.Operation(
    //         OperationKind.Binary BinaryOperator.Add,
    //         [],
    //         // [Expr.IdentExpr "x"; Expr.IdentExpr "captured"],
    //         // [Expr.IdentExpr(mkParam "x" intType); Expr.IdentExpr(mkParam "captured" intType)],
    //         intType, None)
    //     let lambda  = Expr.Lambda(param, body, None)
    //     let result  = transformExpr ctx lambda
    //     match result with
    //
    //     | WExpr.Closure(_, captures, _) ->
    //         let hasCaptured = captures |> List.exists (function
    //             | WExpr.LocalGet("captured", _) -> true | _ -> false)
    //         Expect.isTrue hasCaptured "Free variable 'captured' must appear in closure captures"
    //     | other ->
    //         failtestf "Expected WExpr.Closure, got %A" other
    // }


    test "Lambda capturing a free variable produces a Closure" {
        """
let makeClosure (captured: int) =
    fun (x: int) -> x + captured
        """ |> tryCompile |> skipIfNotWired (fun m ->
            // Suchen Sie nach der inneren Lambda-Funktion oder der umschließenden Funktion,
            // je nachdem, wie Ihr Compiler Closures im WModule abbildet.
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "makeClosure")
            
            // Überprüfung der Invariante: Das WExpr-Zielkonstrukt muss eine Closure 
            // mit der gefangenen Variable ("captured") im Capture-Satz sein.
            assertContains
                (function 

                    | WExpr.Closure(_, captures, _) -> 
                        captures |> List.exists (function
                            | WExpr.LocalGet("captured", _) -> true 

                            | _ -> false)
                    | _ -> false)
                "The lambda must lower into a Closure that captures 'captured'"
                f.Body)
    }


    test "Full application of curried function → optimized Call" {
        let ctx = makeTestCtx()
        // (add 10) 20
        // The compiler should ideally optimize this to a direct call if 'add' is known
        ()
    }
]
