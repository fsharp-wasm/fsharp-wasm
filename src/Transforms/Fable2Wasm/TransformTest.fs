module WasmGc.Transforms.TransformTest

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder

// ─────────────────────────────────────────────────────────────────
// Test translation
// ─────────────────────────────────────────────────────────────────

let transformTest
    (ctx: Ctx)
    (eval: Ctx -> Fable.Expr -> WExpr)
    (expr: Fable.Expr)
    (kind: TestKind) : WExpr =
    let wExpr = eval ctx expr // TODO: do this before we call it !
    match kind with
    | UnionCaseTest tag ->
        match exprWType wExpr with
        | WType.Ref(_, _) ->
            // Data-carrying DU: compare the stored tag field (field 0) against the expected tag.
            // NOTE: ref.test cannot be used here because WASM GC uses isorecursive type
            // equivalence — two subtypes with identical field structures (e.g. Result<int,int>
            // where both Ok(int) and Error(int) produce the same struct layout) are considered
            // the same type, so ref.test would incorrectly return 1 for the wrong case.
            WExpr.Compare(WCompareOp.Eq, WExpr.TagOf(wExpr), WExpr.Const(WConst.I32 tag))
        | _ ->
            // Enum-like DU: the i32 value IS the tag.
            WExpr.Compare(WCompareOp.Eq, wExpr, WExpr.Const(WConst.I32 tag))
    | OptionTest isSome ->
        // Use ref.is_null when the option is encoded as a nullable GC ref,
        // fall back to i32 == 0 / != 0 for the unresolved (mapType) fallback.
        match exprWType wExpr with
        | WType.Ref(_, _) ->
            if isSome then
                // Some → not null: i32.eqz(ref.is_null(...))
                refIsNotNull wExpr
            else
                // None → null: ref.is_null(...) → i32
                WExpr.RefIsNull(wExpr)
        | _ ->
            if isSome then
                WExpr.Compare(WCompareOp.Ne, wExpr, WExpr.Const(WConst.I32 0))
            else
                WExpr.Compare(WCompareOp.Eq, wExpr, WExpr.Const(WConst.I32 0))
    | ListTest isCons ->
        // Use ref.is_null for GC-encoded lists (null = empty, non-null = cons).
        // Fall back to i32 comparison if the list is i32-encoded (shouldn't happen now).
        match exprWType wExpr with
        | WType.Ref(_, _) ->
            if isCons then
                refIsNotNull wExpr
            else
                WExpr.RefIsNull(wExpr)
        | _ ->
            if isCons then
                WExpr.Compare(WCompareOp.Ne, wExpr, WExpr.Const(WConst.I32 0))
            else
                WExpr.Compare(WCompareOp.Eq, wExpr, WExpr.Const(WConst.I32 0))
    | TypeTest typ ->
        // Runtime type test: ref.test (ref $TypeIdx) against the typed exception/object.
        // Used for `:? SomeType` and `with :? SomeException as e` patterns.
        match typ with
        | Fable.Type.DeclaredType(entRef, _) ->
            match Map.tryFind entRef.FullName ctx.TypeRegistry with
            | Some typeIdx ->
                WExpr.RefTest(wExpr, WType.Ref(typeIdx, false))
            | None ->
                // Type not (yet) registered — check GenericDuRegistry too
                match ctx.GenericDuRegistry.TryGetValue(entRef.FullName) with
                | true, typeIdx -> WExpr.RefTest(wExpr, WType.Ref(typeIdx, false))
                | false, _ -> WExpr.Const(WConst.I32 0)  // unknown type: test fails
        | _ ->
            // Primitive / other types can't be runtime-tested via ref.test
            WExpr.Const(WConst.I32 0)
