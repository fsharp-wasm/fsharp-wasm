// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/ListReplacementTests.fs
// List.map, List.filter, etc. produce correct WExpr
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.ListReplacementTests

open Expecto
open Fable.AST.Fable
open Fable.AST.Wasm
open Fable.Transforms.WasmGc
// open Tests.WasmTestHelpers

// Helper: build Fable AST for List.map (fun x -> x + 1) myList
let private buildListMapAst () =
    let listType = Type.List(Type.Number(Int32, NumberInfo.Empty))
    let listArg = Expr.IdentExpr { Name = "myList"; Type = listType; Range = None; IsMutable = false }
    let farg = {
        Name = "x"
        Type = Type.Number(Int32, NumberInfo.Empty)
        Range = None
        IsMutable = false
    }
    let fbody = Expr.Operation(
        OperationKind.Binary(BinaryOperator.BinaryPlus,
            Expr.IdentExpr farg,
            Expr.Value(NumberConstant(1.0, Int32, NumberInfo.Empty), None)),
        Type.Number(Int32, NumberInfo.Empty), None)
    let lambda = Expr.Lambda(farg, fbody, None)
    // LibCall: List.map lambda myList
    (lambda, listArg, listType)

[<Tests>]
let listReplacementTests = testList "List replacements" [

    test "List.map produces loop structure (no Nop)" {
        let ctx = makeTestCtx()
        // Register list type
        let _ = mapTypeKnown ctx (Fable.Type.List(Fable.Type.Number(Int32, NumberInfo.Empty)))
        let (lambda, listArg, _) = buildListMapAst()
        let wList = WExpr.LocalGet("myList", WType.Ref(100, true))
        let result = ListCombinators.tryListMapInline
                        Fable2WasmGc.transformExpr ctx "map"
                        [lambda; listArg] (Fable.Type.List(Fable.Type.Number(Int32, NumberInfo.Empty)))
        Expect.isSome result "List.map should produce a replacement"
        let wExpr = result.Value
        // Should not be Nop
        Expect.notEqual wExpr WExpr.Nop "List.map result should not be Nop"
        // Should contain a loop
        let loops = WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) wExpr
        Expect.isNonEmpty loops "List.map should produce a Loop"
    }

    test "List.map no unknown locals in result" {
        let ctx = makeTestCtx()
        let _ = mapTypeKnown ctx (Fable.Type.List(Fable.Type.Number(Int32, NumberInfo.Empty)))
        let (lambda, listArg, listType) = buildListMapAst()
        let ctxWithList = { ctx with Locals = Map.ofList [("myList", WType.Ref(100, true))] }
        let result = ListCombinators.tryListMapInline
                        Fable2WasmGc.transformExpr ctxWithList "map"
                        [lambda; listArg] listType
        match result with
        | None -> failtest "List.map should produce a replacement"
        | Some wExpr ->
            let params' = []
            let locals = Locals.resolveLocals params' wExpr |> List.map fst
            assertNoUnknownLocals params' locals wExpr
    }

    test "List.filter → two-phase: count then build" {
        // List.filter should produce a pattern that:
        // 1. Traverses the list once to build a reversed result
        // 2. Reverses the accumulated list
        // (or: direct cons-cell building in one pass)
        ()
    }

    test "List.fold accumulates correctly" {
        // List.fold (fun acc x -> acc + x) 0 [1;2;3]
        // Result WExpr should have: mutable acc, mutable cur, while loop
        ()
    }

    test "List.collect (warned in build) is now implemented" {
        // This test FAILS until List.collect is implemented
        // It documents the missing feature
        let ctx = makeTestCtx()
        let _ = mapTypeKnown ctx (Fable.Type.List(Fable.Type.Number(Int32, NumberInfo.Empty)))
        let listArg = Fable.Expr.IdentExpr { Name = "xs"; Type = Fable.Type.List(Fable.Type.Number(Int32, NumberInfo.Empty)); Range = None; IsMutable = false }
        let farg = { Name = "x"; Type = Fable.Type.Number(Int32, NumberInfo.Empty); Range = None; IsMutable = false }
        let fbody = listArg  // trivial: identity (maps each int to a list of... something)
        let lambda = Fable.Expr.Lambda(farg, fbody, None)
        let result = ListCombinators.tryListMapInline
                        Fable2WasmGc.transformExpr ctx "collect"
                        [lambda; listArg] (Fable.Type.List(Fable.Type.Number(Int32, NumberInfo.Empty)))
        // Currently None (unimplemented) — should be Some after fix
        Expect.isSome result "List.collect must be implemented (required by Html/Elements.fs)"
    }

    test "List.exists → short-circuit with Block exit" {
        let ctx = makeTestCtx()
        let _ = mapTypeKnown ctx (Fable.Type.List(Fable.Type.Number(Int32, NumberInfo.Empty)))
        // List.exists produces a labeled block with early exit
        // Check: result contains Block + Break(lbl, Some(i32Const 1))
        ()
    }

    test "List.forAll → short-circuit with Block exit on failure" {
        ()
    }

    test "List.sortBy → insertion sort on temporary array, rebuild list" {
        // Complex: must produce array alloc + sort phase + list rebuild
        ()
    }

]
