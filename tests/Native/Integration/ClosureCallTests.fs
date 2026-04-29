// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/ClosureCallTests.fs
// The full lifecycle: Lambda → buildClosure → ClosureApply → emit
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.ClosureCallTests

open Expecto
open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc


open WasmGc.Transforms.TransformExpr

open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst


[<Tests>]
let closureCallTests = testList "Closure call lifecycle" [

    test "zero-arg closure: fun () -> 42 has correct functype" {
        let ctx = makeTestCtx()
        let lambda = Fable.Expr.Lambda(
            FableAst.mkParam "_" Fable.Type.Unit
            // { Name = "_";
            //   Type = Fable.Type.Unit;
            //   Range = None;
            //   IsMutable = false
            //   IsThisArgument
            //   }
            ,
            Fable.Expr.Value(
              Fable.NumberConstant(NumberKind.Int32 42, Fable.NumberInfo.Empty),
              None),
            None)
        let result = transformExpr ctx lambda
        // The closure should have functype (self) → i32 (1 param: self only)
        match result with
        | WExpr.Closure(liftedName, captures, ty) ->
            // Look up the lifted function in ctx
            match ctx.Functions |> Seq.tryFind (fun f -> f.Name = liftedName) with
            | Some func ->
                Expect.equal func.Params.Length 1 "Zero-arg closure should have 1 param (self only)"
            | None -> failtestf "Lifted function %s not found in ctx.Functions" liftedName
        | other -> failtestf "Expected Closure node but got %A" other
    }

    test "one-arg i32 closure: fun x -> x + 1 has functype (self, i32) → i32" {
        let ctx = makeTestCtx()
        // let xIdent = { Fable.Name = "x"; Fable.Type = Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty); Fable.Range = None; Fable.IsMutable = false }
        let xIdent = mkParam "x" (Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty))
        let lambda = Fable.Expr.Lambda(
            xIdent,
            Fable.Expr.Operation(
                Fable.OperationKind.Binary(Fable.BinaryOperator.BinaryPlus,
                    Fable.Expr.IdentExpr xIdent,
                    Fable.Expr.Value(Fable.NumberConstant(1.0, NumberKind.Int32, Fable.NumberInfo.Empty), None)),
                Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty), None),
            None)
        let result = transformExpr ctx lambda
        match result with
        | WExpr.Closure(liftedName, _, _) ->
            match ctx.Functions |> Seq.tryFind (fun f -> f.Name = liftedName) with
            | Some func ->
                Expect.equal func.Params.Length 2 "One-arg closure should have 2 params (self + x)"
                Expect.equal (snd func.Params.[1]) WType.I32 "Second param should be I32"
            | None -> failtestf "Lifted function not found: %s" liftedName
        | other -> failtestf "Expected Closure but got %A" other
    }

    test "closure with capture: functype includes self only (capture is in struct)" {
        // fun () -> capturedValue + 1
        // The capture is stored in the closure struct, NOT as an extra functype param
        let ctx = { makeTestCtx() with Locals = Map.ofList [("capturedValue", WType.I32)] }
        let lambda = Fable.Expr.Lambda(
            { Fable.Name = "_"; Fable.Type = Fable.Type.Unit; Fable.Range = None; Fable.IsMutable = false },
            Fable.Expr.IdentExpr { Fable.Name = "capturedValue"; Fable.Type = Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty); Fable.Range = None; Fable.IsMutable = false },
            None)
        let result = transformExpr ctx lambda
        match result with
        | WExpr.Closure(liftedName, captures, _) ->
            Expect.exists captures (fun (n, _) -> n = "capturedValue") "capturedValue should be in captures"
            // Lifted function params: only self (the capture is extracted from self inside the body)
            match ctx.Functions |> Seq.tryFind (fun f -> f.Name = liftedName) with
            | Some func ->
                Expect.equal func.Params.Length 1 "Captured closure should have 1 param (self only) — capture comes from struct"
            | None -> ()
        | other -> failtestf "Expected Closure but got %A" other
    }

    test "CurriedApply on local closure: arity matches functype" {
        let ctx = makeTestCtx()
        // Simulate: render(handle) where render: i32 → unit
        // This is the closure_4 scenario
        let funcTypeIdx = ctx.GetOrAddFuncType([WType.Ref(0, false); WType.I32], WType.Void)
        let wClosure = localGet "$render" (WType.Ref(0, false))
        let wArgs = [i32Const 42]  // handle
        let closureApply = WExpr.ClosureApply(wClosure, wArgs, funcTypeIdx, 0, 0, WType.Void)
        // Validate
        let errors = System.Collections.Generic.List()
        Validator.checkFunc "$test" (buildArityIndex ctx.TypeDefs) errors closureApply
        Expect.isEmpty errors "call(render, handle) should have correct arity"
    }

    test "Elmish dispatch: fun _ -> () has functype (self, i32) → void" {
        // fun _ -> () where _ : 'Msg = int
        // ClosureType_122 in the WAT — this is the initial no-op dispatch
        let ctx = makeTestCtx()
        let msgArg = { Fable.Name = "_"; Fable.Type = Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty); Fable.Range = None; Fable.IsMutable = false }
        let lambda = Fable.Expr.Lambda(
            msgArg,
            Fable.Expr.Value(Fable.UnitConstant, None),
            None)
        let result = transformExpr ctx lambda
        match result with
        | WExpr.Closure(liftedName, _, _) ->
            match ctx.Functions |> Seq.tryFind (fun f -> f.Name = liftedName) with
            | Some func ->
                Expect.equal func.Params.Length 2 "Dispatch stub should have (self, msg) = 2 params"
                Expect.equal func.Result WType.Void "Dispatch should return void"
            | None -> failtestf "Lifted dispatch stub not found: %s" liftedName
        | other -> failtestf "Expected Closure but got %A" other
    }

]
