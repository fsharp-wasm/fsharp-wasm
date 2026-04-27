// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/CaptureTests.fs
// Free variable capture and closure building edge cases
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.CaptureTests

open Expecto
open Fable.AST.Wasm
open Fable.Transforms.WasmGc

open Tests.WasmTestHelpers

[<Tests>]
let captureTests = testList "Free variable capture" [

    test "db captured across lambda boundary" {
        // indexeddb-crud: `let db = openDb "name" 1` used inside `fun () -> put db k v`
        // 'db' must appear in closure captures, not as a bare LocalGet in lifted fn
        let ctx = { makeTestCtx() with
                        Locals = Map.ofList [("db", WType.Ref(77, false))] }
        let lambdaBody =
            Fable.Expr.Call(
                Fable.Expr.Import({ Selector = "put"; Path = "runtime/indexeddb.js" }, Fable.Type.Unit, None),
                { Args = [Fable.Expr.IdentExpr { Name = "db"; Type = Fable.Type.Any; Range = None; IsMutable = false }]
                  ThisArg = None; HasSpread = false; IsConstructor = false },
                Fable.Type.Unit, None)
        let lambda =
            Fable.Expr.Lambda(
                { Name = "_unit"; Type = Fable.Type.Unit; Range = None; IsMutable = false },
                lambdaBody, None)
        let wClosure = Fable2WasmGc.transformExpr ctx lambda
        // The lifted function should have 'db' as a capture parameter
        // i.e., the ClosureStruct should include db's type
        match wClosure with
        | WExpr.Closure(_, captures, _) ->
            Expect.exists captures (fun (_, ty) -> ty = WType.Ref(77, false))
                "db should be in closure captures"
        | other -> failtestf "Expected Closure node but got %A" other
    }

    test "module-level function NOT captured in closure" {
        // KnownFuncs zero-arg functions should not appear in capture list
        // They become direct calls inside the lifted function
        let ctx = { makeTestCtx() with
                        Locals     = Map.ofList [("x", WType.I32)]
                        KnownFuncs = Map.ofList [("helperFn", ([], WType.I32))] }
        let lambdaBody =
            Fable.Expr.Let(
                { Name = "tmp"; Type = Fable.Type.Any; Range = None; IsMutable = false },
                Fable.Expr.IdentExpr { Name = "helperFn"; Type = Fable.Type.Any; Range = None; IsMutable = false },
                Fable.Expr.IdentExpr { Name = "x"; Type = Fable.Type.Any; Range = None; IsMutable = false })
        let lambda = Fable.Expr.Lambda(
            { Name = "_"; Type = Fable.Type.Unit; Range = None; IsMutable = false },
            lambdaBody, None)
        let wClosure = Fable2WasmGc.transformExpr ctx lambda
        match wClosure with
        | WExpr.Closure(_, captures, _) ->
            let hasHelperFn = captures |> List.exists (fun (n, _) -> n = "helperFn")
            Expect.isFalse hasHelperFn "Module-level functions should NOT be captured"
        | other -> failtestf "Expected Closure but got %A" other
    }

    test "SSA rename 'db_2' captured like original 'db'" {
        // Fable SSA: let db_2 = db; fun () -> put db_2 k v
        // 'db_2' is in Locals (bound by outer Let), must be captured
        let ctx = { makeTestCtx() with
                        Locals = Map.ofList [
                            ("db",   WType.Ref(77, false))
                            ("db_2", WType.Ref(77, false)) // SSA alias
                        ] }
        let lambdaBody =
            Fable.Expr.IdentExpr { Name = "db_2"; Type = Fable.Type.Any; Range = None; IsMutable = false }
        let lambda = Fable.Expr.Lambda(
            { Name = "_"; Type = Fable.Type.Unit; Range = None; IsMutable = false },
            lambdaBody, None)
        let wClosure = Fable2WasmGc.transformExpr ctx lambda
        match wClosure with
        | WExpr.Closure(_, captures, _) ->
            Expect.exists captures (fun (n, _) -> n = "db_2")
                "SSA alias db_2 should be captured"
        | other -> failtestf "Expected Closure but got %A" other
    }

    test "captured name does not also appear as Let-local in lifted function" {
        // Bug: if captureNames not excluded from collectLocals, emitter sees duplicate
        let ctx = { makeTestCtx() with
                        Locals = Map.ofList [("db_2", WType.Ref(77, false))] }
        let lambdaBody =
            Fable.Expr.IdentExpr { Name = "db_2"; Type = Fable.Type.Any; Range = None; IsMutable = false }
        let lambda = Fable.Expr.Lambda(
            { Name = "_"; Type = Fable.Type.Unit; Range = None; IsMutable = false },
            lambdaBody, None)
        let wClosure = Fable2WasmGc.transformExpr ctx lambda
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
