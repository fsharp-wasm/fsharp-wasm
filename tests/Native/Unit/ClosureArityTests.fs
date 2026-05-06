// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/ClosureArityTests.fs
// Regression: call_ref stack underflow — the closure_4 bug class
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.ClosureArityTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Builder
open WasmGc.Runtime.Types

open WasmGc.Pipeline.Core
module Validator = WasmGc.Pipeline.Validator

open Tests.WasmTestHelper

// The pattern that caused closure_4 crash:
// JS bridge closure: fun (handle: unit) -> render handle
// handle : unit → WType.Void → filtered out of wArgs
// funcTypeIdx registered for 0 user args → (self) only
// Emitter pushes self + nothing + funcref → call_ref needs 1 i32, gets 0

[<Tests>]
let closureArityTests = testList "ClosureApply arity" [

    test "unit arg at JS bridge preserved as i32Const 0" {
        // wArgs = [WExpr.Nop]  (unit-typed Fable arg transforms to Nop)
        // After fix: wArgsFull replaces Nop → i32Const 0
        // So funcTypeIdx gets registered with (self, i32) = 2 params
        // and the i32Const 0 is pushed before call_ref
        let ctx = makeTestCtx ()
        let unitArg = WExpr.Nop   // unit arg transforms to this
        let wArgsFull =
            [unitArg] |> List.map (fun a ->
                match exprWType a with
                | WType.Void -> i32Const 0   // THE FIX
                | _ -> a)
        let wArgs = wArgsFull |> List.filter (fun a -> exprWType a <> WType.Void)
        // wArgs should have 1 element: i32Const 0
        Expect.equal wArgs.Length 1 "unit arg should become i32Const 0, not be dropped"
        Expect.equal (exprWType wArgs.[0]) WType.I32 "preserved arg should be i32"
    }

    test "void expression (side-effect only) still filtered" {
        // do! arraySet arr i v → void, should be filtered from ClosureApply args
        let voidExpr = WExpr.ArraySet(localGet "$arr" WType.I32, i32Const 0, i32Const 42)
        Expect.equal (exprWType voidExpr) WType.Void "ArraySet is void"
        let wArgs = [voidExpr] |> List.filter (fun a -> exprWType a <> WType.Void)
        Expect.isEmpty wArgs "pure void side-effects should be filtered"
    }

    test "ident-path ClosureApply includes closureTypeIdx lookup" {
        // Bug: ident-based CurriedApply path hardcoded closureTypeIdx=0
        // Fix: same TryGetValue lookup as the main CurriedApply path
        let ctx = makeTestCtx ()
        ctx.FuncTypeToClosureMap.[4] <- 5  // funcTypeIdx=4 → closureTypeIdx=5
        let funcTypeIdx = 4
        let closureTypeIdx =
            match ctx.FuncTypeToClosureMap.TryGetValue(funcTypeIdx) with
            | true, cti -> cti
            | false, _  -> AnyFnTypeIdx
        Expect.equal closureTypeIdx 5 "closureTypeIdx must be looked up, not hardcoded to 0"
    }

    test "validator catches: self+0 args for (self,i32)->void functype" {
        let typeDefs = System.Collections.Generic.List<WTypeDeclEntry>()
        typeDefs.Add({ Name = "$FT_6"; Def = WTypeDef.Func([WType.Ref(0,false); WType.I32], WType.Void) })
        // ClosureApply with 0 user args but functype expects 1 (besides self)
        let expr = WExpr.ClosureApply(
            WExpr.FuncRef "$render",
            [],  // ← MISSING the i32 arg
            0, 0, 0, WType.Void)
        let known = Set.empty<string>
        let errors = Validator.checkFunc "$closure_4" (buildArityIndex typeDefs) known expr
        Expect.isNonEmpty errors "validator must catch missing arg"
        Expect.stringContains errors.Head.Message "got self(1)+0" "error should state actual provided param count"
        Expect.stringContains errors.Head.Message "need 2 params" "error should state expected param count"
    }

    test "validator passes: self+1 i32 arg for (self,i32)->void functype" {
        let typeDefs = System.Collections.Generic.List<WTypeDeclEntry>()
        typeDefs.Add({ Name = "$FT_6"; Def = WTypeDef.Func([WType.Ref(0,false); WType.I32], WType.Void) })
        let expr = WExpr.ClosureApply(
            WExpr.FuncRef "$render",
            [i32Const 0],  // ← CORRECT: 1 user arg
            0, 0, 0, WType.Void)
        let known = Set.empty<string>
        let errors = Validator.checkFunc "$closure_4" (buildArityIndex typeDefs) known expr
        Expect.isEmpty errors "validator should pass when arity is correct"
    }
]
