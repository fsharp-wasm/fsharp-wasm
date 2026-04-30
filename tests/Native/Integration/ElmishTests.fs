// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/ElmishTests.fs
// Elmish runtime: dispatch, runWith, model update cycle
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.ElmishTests

open Expecto

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc
open WasmGc.Runtime.Types
open WasmGc.Transforms.TransformExpr

open Tests.WasmTestHelper

[<Tests>]
let elmishTests = testList "Elmish dispatch" [

    test "initial dispatch stub (fun _ -> ()) has 2-param functype" {
        // ClosureType_122 in the original WAT: (func (param i32)) — MISSING self!
        // After fix: (func (param (ref $AnyFn)) (param i32)) — correct
        let ctx = makeTestCtx()
        let msgArg = FableAst.mkParam "_" (Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty))
          // {
          // Fable.Name = "_"
          // Fable.Type = Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty)
          // Fable.Range = None
          // Fable.IsMutable = false }
        let stub = Fable.Expr.Lambda(msgArg, Fable.Expr.Value(Fable.UnitConstant, None), None)
        let wStub = transformExpr ctx stub
        match wStub with
        | WExpr.Closure(name, _, _) ->
            match ctx.Functions |> Seq.tryFind (fun f -> f.Name = name) with
            | Some f ->
                // Functype = params for lifted function
                // Must be [self; msg] = 2 params
                Expect.equal f.Params.Length 2
                    "Dispatch stub MUST have (self, msg) = 2 params — not (msg) alone"
                // self must be ref $AnyFn
                Expect.equal (snd f.Params.[0]) (WType.Ref(AnyFnTypeIdx, false))
                    "First param must be self (ref $AnyFn)"
                // msg must be i32
                Expect.equal (snd f.Params.[1]) WType.I32
                    "Second param must be i32 (the message)"
            | None -> failtestf "Lifted stub %s not found" name
        | other -> failtestf "Expected Closure but got %A" other
    }

    test "dispatchImpl captured in state struct correctly" {
        // state.Dispatch = fun msg -> dispatchImpl render state update msg
        // All four captures must appear in the closure struct
        ()
    }

    test "model update: call_ref has correct arity for update fn" {
        // update: Model -> Msg -> (Model * Cmd)
        // In Elmish: call update with (msg, model) via ClosureApply
        ()
    }

]
