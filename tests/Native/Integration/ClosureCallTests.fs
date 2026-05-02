// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/ClosureCallTests.fs
// The full lifecycle: Lambda → buildClosure → ClosureApply → emit
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.ClosureCallTests

open Expecto
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc

module Validator = WasmGc.Pipeline.Validator
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
              Fable.NumberConstant(NumberValue.Int32 42, Fable.NumberInfo.Empty),
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
                Fable.OperationKind.Binary(
                    BinaryOperator.BinaryPlus,
                    Fable.Expr.IdentExpr xIdent,
                    Fable.Expr.Value(Fable.NumberConstant(NumberValue.Int32 1, Fable.NumberInfo.Empty), None)
                ),
                [],
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
        // Build: let capturedValue = 42 in fun () -> capturedValue
        let ctx    = makeTestCtx()
        let capVal = mkParam "capturedValue" (Fable.Type.Number(Int32, NumberInfo.Empty))
        let ctx'   = ctx.WithLocal("capturedValue", WType.I32)
        
        // Lambda with no args, body references capturedValue
        let body   = Fable.Expr.IdentExpr capVal
        let lambda = Fable.Expr.Lambda(mkParam "_unit" Fable.Type.Unit, body, None)
        
        let result = transformExpr ctx' lambda
        
        match result with
        | WExpr.Closure(funcName, captureExprs, closureTy) ->
            // Captures are in the struct initialiser (captureExprs list)
            Expect.isNonEmpty captureExprs "closure must capture capturedValue"
            Expect.equal captureExprs.Length 1 "exactly one capture"
            match captureExprs.[0] with
            | WExpr.LocalGet("capturedValue", WType.I32) -> ()
            | other -> failtestf "capture should be LocalGet(capturedValue), got %A" other
            
            // Verify the functype is (ref $AnyFn) → i32 — self only, no extra capture arg
            let fti =
                match closureTy with
                | WType.Ref(closureTypeIdx, false) ->
                    match ctx'.TypeDefs.[closureTypeIdx].Def with
                    | WTypeDef.Struct({ Type = WType.Ref(fti, false) } :: _, _) -> fti
                    | _ -> failtest "closure struct should have code field first"
                | _ -> failtest "closure should have Ref type"
            match ctx'.TypeDefs.[fti].Def with
            | WTypeDef.Func([WType.Ref(0, false)], _) ->
                ()  // correct: only self-param, captures are in struct
            | WTypeDef.Func(ps, _) ->
                failtestf "functype should have only self param, got %d params" ps.Length
            | other -> failtestf "expected Func def, got %A" other
        | other -> failtestf "expected Closure, got %A" other
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
        let msgArg =  mkParam "_" (Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty))
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
