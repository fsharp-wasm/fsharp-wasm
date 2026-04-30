// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/CaptureTests.fs
// Free variable capture and closure building edge cases
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.CaptureTests

open Expecto
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc

open WasmGc.Transforms.TransformExpr

open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst

[<Tests>]
let captureTests = testList "Free variable capture" [

    // test "db captured across lambda boundary" {
    //     // // indexeddb-crud: `let db = openDb "name" 1` used inside `fun () -> put db k v`
    //     // // 'db' must appear in closure captures, not as a bare LocalGet in lifted fn
    //     // let ctx = { makeTestCtx() with
    //     //                 Locals = Map.ofList [("db", WType.Ref(77, false))] }
    //     // let lambdaBody =
    //     //     Fable.Expr.Call(
    //     //         Fable.Expr.Import({ 
    //     //             Selector = "put"
    //     //             Path = "runtime/indexeddb.js" 
    //     //             Kind = ImportKind.UserImport false // TODO: more tests needed
    //     //         }, Fable.Type.Unit, None),
    //     //         {   Args = [mkIdent "db" Fable.Type.Any]
    //     //             ThisArg = None
    //     //             SignatureArgTypes = [] //: Type list
    //     //             GenericArgs = [] //: Type list
    //     //             MemberRef = None // : MemberRef option
    //     //             Tags = [] // string list
    //     //         },
    //     //         Fable.Type.Unit, 
    //     //         None)
    //     // let lambda =
    //     //     Fable.Expr.Lambda(mkParam "_unit" Fable.Type.Unit, lambdaBody, None)
    //     // let wClosure = transformExpr ctx lambda
    //     // // The lifted function should have 'db' as a capture parameter
    //     // // i.e., the ClosureStruct should include db's type
    //     // match wClosure with
    //     // | WExpr.Closure(_, captures, _) ->
    //     //     Expect.exists captures (fun (_, ty) -> ty = WType.Ref(77, false))
    //     //         "db should be in closure captures"
    //     // | other -> failtestf "Expected Closure node but got %A" other

    //     Expect.isTrue false "Not yet implemented"
    // }

    test "module-level function NOT captured in closure" {
        // KnownFuncs zero-arg functions should not appear in capture list
        // They become direct calls inside the lifted function
        let ctx = { makeTestCtx() with
                        Locals     = Map.ofList [("x", WType.I32)]
                        KnownFuncs = Map.ofList [("helperFn", ([], WType.I32))] }
        let lambdaBody =
            Fable.Expr.Let(
                mkParam "tmp" Fable.Type.Any,
                mkIdent "helperFn" Fable.Type.Any,
                mkIdent "x" Fable.Type.Any)
        let lambda = Fable.Expr.Lambda(
            mkParam "_" Fable.Type.Unit,
            lambdaBody, None)
        let wClosure = transformExpr ctx lambda
        match wClosure with
        // | WExpr.Closure(_, captures, _) ->
        // printf "CAPTURES are: %A" captures
        //     let hasHelperFn = captures |> List.exists (fun (n, _) -> n = "helperFn")
        //     Expect.isFalse hasHelperFn "Module-level functions should NOT be captured"
        | other -> failtestf "Expected Closure but got %A" other

        printf "my closure %A" wClosure
        failtestf " but got %A" wClosure
        Expect.isTrue false (sprintf ">>>>>>> Not yet implemented %A <<<<<<<<" wClosure)
    }

    // test "SSA rename 'db_2' captured like original 'db'" {
    //     // // Fable SSA: let db_2 = db; fun () -> put db_2 k v
    //     // // 'db_2' is in Locals (bound by outer Let), must be captured
    //     // let ctx = { makeTestCtx() with
    //     //                 Locals = Map.ofList [
    //     //                     ("db",   WType.Ref(77, false))
    //     //                     ("db_2", WType.Ref(77, false)) // SSA alias
    //     //                 ] }
    //     // let lambdaBody = mkIdent "db_2" Fable.Type.Any
    //     // let lambda = Fable.Expr.Lambda(mkParam "_" Fable.Type.Unit, lambdaBody, None)
    //     // let wClosure = transformExpr ctx lambda
    //     // match wClosure with
    //     // | WExpr.Closure(_, captures, _) ->
    //     //     Expect.exists captures (fun (n, _) -> n = "db_2")
    //     //         "SSA alias db_2 should be captured"
    //     // | other -> failtestf "Expected Closure but got %A" other
    //     Expect.isTrue false "Not yet implemented"
    // }

    test "captured name does not also appear as Let-local in lifted function" {
        // Bug: if captureNames not excluded from collectLocals, emitter sees duplicate
        let ctx = { makeTestCtx() with
                        Locals = Map.ofList [("db_2", WType.Ref(77, false))] }
        let lambdaBody = mkIdent "db_2" Fable.Type.Any
        let lambda = Fable.Expr.Lambda(mkParam "_" Fable.Type.Unit, lambdaBody, None)
        let wClosure = transformExpr ctx lambda
        match wClosure with
        | WExpr.Closure(liftedFuncName, captures, _) ->
            // Find the lifted function in ctx.Functions
            // Check that captured names are NOT in its Locals list
            // (they should only be in its Params)
            () // TODO: inspect ctx.Functions for the lifted func
        | other -> failtestf "Expected Closure but got %A" other
    }

    test "recursive let (letrec) binds all names before body" {
        // let rec even n = if n = 0 then true else odd (n-1)
        // and odd n = if n = 0 then false else even (n-1)
        // Both 'even' and 'odd' must be in scope for each other's body
        ()  // complex — implement after basic capture tests pass
    }

]
