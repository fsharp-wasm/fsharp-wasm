// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/ArrayReplacementTests.fs
// ════════════════════════════════════════════════════════════════════════════════
/// tests/Native/Integration/ArrayReplacementTests.fs
/// Replace all `Expect.isTrue false "Not Implemented"` stubs with real assertions.
module Tests.Integration.ArrayReplacementTests

open Expecto
open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Transforms.ArrayReplacements
open WasmGc.Transforms.TransformExpr

module ArrayReplacements = WasmGc.Transforms.ArrayReplacements

open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst

// ─────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────


// let private tryArr ctx sel fableArgs resultFableType =
//     let wArgs = fableArgs |> List.map (transformExpr ctx)
//     tryArrayInline transformExpr ctx sel fableArgs wArgs resultFableType

/// Call tryArrayInline with a lambda-accepting selector.
let private tryArr ctx sel fableArgs resultFableType =
    // Inject the mock identifiers into the context so the scope resolver knows they exist
    let locals = 
        fableArgs |> List.choose (function
            // TODO: is this really correct? above is the original.
            | IdentExpr id -> Some (id.Name, WType.Ref(200, false)) // Inject dummy types
            | _ -> None)
        |> Map.ofList
    let ctx' : Ctx = { ctx with Locals = Map.fold (fun acc k v -> Map.add k v acc) ctx.Locals locals }
    let wArgs = fableArgs |> List.map (transformExpr ctx')
    tryArrayInline transformExpr ctx' sel fableArgs wArgs resultFableType


let private intArrT n = Type.Array(Type.Number(Int32, NumberInfo.Empty), ArrayKind.MutableArray)
let private mkIntLambda argName body = Lambda(mkParam argName (Type.Number(Int32, NumberInfo.Empty)), body, None)

// ─────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────

[<Tests>]
let arrayReplacementTests = testList "Array replacements" [

    test "Array.get (indexing) → ArrayGet" {
        let ctx    = makeTestCtx()
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        // let idxArg = Value(NumberConstant(NumberValue.Int32 0, NumberInfo.Empty), None)
        let idxArg = mkIntLit 0
        let result = tryArr ctx "get" [arrArg; idxArg] (Type.Number(Int32, NumberInfo.Empty))
        Expect.isSome result "Array.get should produce Some"
        match result.Value with
        | WExpr.ArrayGet _ -> ()
        | other -> failtestf "Expected ArrayGet, got %A" other
    }

    test "Array.length → ArrayLen" {
        let ctx    = makeTestCtx()
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        let result = tryArr ctx "length" [arrArg] (Type.Number(Int32, NumberInfo.Empty))
        Expect.isSome result "Array.length should produce Some"
        match result.Value with
        | WExpr.ArrayLen _ -> ()
        | other -> failtestf "Expected ArrayLen, got %A" other
    }

    test "Array.map → indexed loop with result array" {
        let ctx    = makeTestCtx()
        let farg   = mkParam "x" (Type.Number(Int32, NumberInfo.Empty))
        let fbody  = Value(NumberConstant(NumberValue.Int32 42, NumberInfo.Empty), None)
        let lambda = Lambda(farg, fbody, None)
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        let result = tryArr ctx "map" [lambda; arrArg] (intArrT 0)
        Expect.isSome result "Array.map should produce Some"
        // Result must contain a loop (the indexed map loop)
        let hasLoop = WasmGc.Util.WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result.Value
        Expect.isNonEmpty hasLoop "Array.map result must contain a Loop"
        // Must allocate a result array
        let hasArrayNew = WasmGc.Util.WExprQuery.collect (function WExpr.ArrayNew _ -> true | _ -> false) result.Value
        Expect.isNonEmpty hasArrayNew "Array.map result must contain ArrayNew for result"
    }

    test "Array.filter → two-pass count+fill" {
        let ctx    = makeTestCtx()
        let farg   = mkParam "x" (Type.Number(Int32, NumberInfo.Empty))
        // pred: x > 0
        let fbody  = Operation(OperationKind.Binary(BinaryOperator.BinaryGreater,
                        IdentExpr farg,
                        Value(NumberConstant(NumberValue.Int32 0, NumberInfo.Empty), None)), [], Type.Boolean, None)
        let lambda = Lambda(farg, fbody, None)
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        let result = tryArr ctx "filter" [lambda; arrArg] (intArrT 0)
        Expect.isSome result "Array.filter should produce Some"
        // Two-pass: must contain exactly 2 loops
        let loops = WasmGc.Util.WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result.Value
        Expect.equal loops.Length 2 "Array.filter must use two passes (count loop + fill loop)"
    }

    test "Array.exists → short-circuit with Block" {
        let ctx    = makeTestCtx()
        let farg   = mkParam "x" (Type.Number(Int32, NumberInfo.Empty))
        let fbody  = Value(BoolConstant true, None)
        let lambda = Lambda(farg, fbody, None)
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        let result = tryArr ctx "exists" [lambda; arrArg] Type.Boolean
        Expect.isSome result "Array.exists should produce Some"
        // Short-circuit: must use a Block for early exit
        let hasBlock = WasmGc.Util.WExprQuery.collect (function WExpr.Block _ -> true | _ -> false) result.Value
        Expect.isNonEmpty hasBlock "Array.exists must use Block for short-circuit exit"
    }

    test "Array.forAll → short-circuit with Block" {
        let ctx    = makeTestCtx()
        let farg   = mkParam "x" (Type.Number(Int32, NumberInfo.Empty))
        let fbody  = Value(BoolConstant true, None)
        let lambda = Lambda(farg, fbody, None)
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        let result = tryArr ctx "forAll" [lambda; arrArg] Type.Boolean
        Expect.isSome result "Array.forAll should produce Some"
        let hasBlock = WasmGc.Util.WExprQuery.collect (function WExpr.Block _ -> true | _ -> false) result.Value
        Expect.isNonEmpty hasBlock "Array.forAll must use Block for short-circuit exit"
    }

    test "Array.copy → arrayCopy instruction VERSION  2" {
        let ctx    = makeTestCtx()
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        let result = tryArr ctx "copy" [arrArg] (intArrT 0)
        Expect.isSome result "Array.copy should produce Some"
        let hasCopy = WasmGc.Util.WExprQuery.collect (function WExpr.ArrayCopy _ -> true | _ -> false) result.Value
        Expect.isNonEmpty hasCopy "Array.copy must emit ArrayCopy"
    }

    test "Array.copy → arrayCopy instruction" {
        let ctx = makeTestCtx()
        let arrType = Fable.Type.Array(Fable.Type.Number(Int32, NumberInfo.Empty), Fable.ArrayKind.ResizeArray)
        // let arrArg = Fable.Expr.IdentExpr { Name = "src"; Type = arrType; Range = None; IsMutable = false }
        let arrArg = FableAst.mkIdent "src" arrType
        let ctxWithArr = { ctx with Locals = Map.ofList [("src", WType.Ref(200, false))] }
        let result = ArrayReplacements.tryArrayInline
                        transformExpr ctxWithArr "copy"
                        [arrArg] [localGet "src" (WType.Ref(200, false))]
                        arrType
        Expect.isSome result "Array.copy should be handled"
        let wExpr = result.Value
        let hasCopy = WExprQuery.collect (function WExpr.ArrayCopy _ -> true | _ -> false) wExpr
        Expect.isNonEmpty hasCopy "Array.copy should produce ArrayCopy instruction"
    }

    test "Array.fill → counted loop with arraySet" {
        // Array.fill target start count value — mutates existing array in a counted loop.
        // Implementation: while! loop over [start, start+count) calling arraySet each iteration.
        let ctx      = makeTestCtx()
        let intT     = Type.Number(Int32, NumberInfo.Empty)
        let arrArg   = IdentExpr(mkParam "xs" (intArrT 0))
        let startArg = Value(NumberConstant(NumberValue.Int32 0,  NumberInfo.Empty), None)
        let countArg = Value(NumberConstant(NumberValue.Int32 5,  NumberInfo.Empty), None)
        let valArg   = Value(NumberConstant(NumberValue.Int32 42, NumberInfo.Empty), None)
        // resultFableType must NOT be an array type so the loop-based branch is hit
        // (the first branch only activates when result is an array — create semantics)
        let result   = tryArr ctx "fill" [arrArg; startArg; countArg; valArg] intT
        Expect.isSome result "Array.fill should produce Some"
        let loops = WasmGc.Util.WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result.Value
        Expect.isNonEmpty loops "Array.fill must emit a counted loop"
        let sets = WasmGc.Util.WExprQuery.collect (function WExpr.ArraySet _ -> true | _ -> false) result.Value
        Expect.isNonEmpty sets "Array.fill must emit ArraySet inside the loop"
    }

    test "Array.zeroCreate n → arrayNew with zero init" {
        let ctx = makeTestCtx()
        let result = ArrayReplacements.tryArrayInline
                        transformExpr ctx "zeroCreate"
                        [Fable.Expr.Value(Fable.NumberConstant(NumberValue.Int32 10, Fable.NumberInfo.Empty), None)]
                        [i32Const 10]
                        (Fable.Type.Array(Fable.Type.Number(NumberKind.Int32, Fable.NumberInfo.Empty), Fable.ArrayKind.ResizeArray))
        Expect.isSome result "Array.zeroCreate should be handled"
        let wExpr = result.Value
        let hasNew = WExprQuery.collect (function WExpr.ArrayNew _ -> true | _ -> false) wExpr
        Expect.isNonEmpty hasNew "zeroCreate should use ArrayNew"
    }

    test "Array.sortBy → insertion sort into fresh copy" {
        // Array.sortBy keyFn arr — copies arr then sorts the copy in-place.
        // Implementation: insertionSortInPlace → nested while loops.
        let ctx    = makeTestCtx()
        let farg   = mkParam "x" (Type.Number(Int32, NumberInfo.Empty))
        let fbody  = IdentExpr farg   // identity key function
        let lambda = Lambda(farg, fbody, None)
        let arrArg = IdentExpr(mkParam "xs" (intArrT 0))
        let result = tryArr ctx "sortBy" [lambda; arrArg] (intArrT 0)
        Expect.isSome result "Array.sortBy should produce Some"
        // insertionSortInPlace emits two nested while! loops (outer i, inner j)
        let loops = WasmGc.Util.WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result.Value
        Expect.isGreaterThanOrEqual loops.Length 1 "Array.sortBy must contain at least one Loop (insertion sort)"
        // Must allocate a result array (the fresh copy)
        let allocs = WasmGc.Util.WExprQuery.collect (function WExpr.ArrayNew _ -> true | _ -> false) result.Value
        Expect.isNonEmpty allocs "Array.sortBy must allocate a fresh copy with ArrayNew"
    }
]
