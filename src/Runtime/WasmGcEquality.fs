/// Structural equality helpers for WasmGC.
/// Generates WFuncDecl equality functions for records and discriminated unions.
/// Extracted from WasmGcRuntime.fs to separate concerns.
module Fable.Transforms.WasmGc.WasmGcEquality

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder
open Fable.Transforms.WasmGc.WasmGcLocals

// ─────────────────────────────────────────────────────────────────
// Structural equality — Sprint 6
// ─────────────────────────────────────────────────────────────────

/// Return a WExpr (result: i32) that compares two WExprs of the given WType.
/// Uses registered equality functions for nested struct/DU types.
let rec compareByWType (ctx: Ctx) (ty: WType) (a: WExpr) (b: WExpr) : WExpr =
    match ty with
    | WType.I32 | WType.I64 | WType.F32 | WType.F64 ->
        WExpr.Compare(WCompareOp.Eq, a, b)
    | WType.Ref(idx, false) when idx = StringTypeIdx ->
        WExpr.Call("$strEq", [a; b], WType.I32)
    | WType.Ref(idx, false) ->
        // Non-nullable ref: look up or generate structural equality
        match ctx.EqualityRegistry.TryGetValue(idx) with
        | true, funcName -> WExpr.Call(funcName, [a; b], WType.I32)
        | false, _ ->
            // No equality function registered — fall back to reference equality
            WExpr.Compare(WCompareOp.Eq, a, b)
    | WType.Ref(idx, true) ->
        // Nullable ref: if both null → 1, one null → 0, both non-null → recurse
        let nullA = WExpr.RefIsNull a
        let nullB = WExpr.RefIsNull b
        wasmIf (and_ nullA nullB)
            (i32Const 1)
            (wasmIf (or_ nullA nullB)
                (i32Const 0)
                // both non-null: cast to non-nullable and compare
                (match ctx.EqualityRegistry.TryGetValue(idx) with
                 | true, funcName ->
                     let aFixed = WExpr.Cast(a, WType.Ref(idx, false))
                     let bFixed = WExpr.Cast(b, WType.Ref(idx, false))
                     WExpr.Call(funcName, [aFixed; bFixed], WType.I32)
                 | false, _ -> WExpr.Compare(WCompareOp.Eq, a, b)))
    | _ -> WExpr.Compare(WCompareOp.Eq, a, b)

/// Generate an equality function for a record struct type.
/// `typeIdx` must be in ctx.TypeDefs; `fields` are the struct fields.
let makeRecordEqualsFunc (ctx: Ctx) (funcName: string) (typeIdx: int) (fields: WField list) : WFuncDecl =
    let refT = WType.Ref(typeIdx, false)
    let aGet = WExpr.LocalGet("$eq_a", refT)
    let bGet = WExpr.LocalGet("$eq_b", refT)
    let body =
        if fields.IsEmpty then
            i32Const 1  // empty struct: always equal
        else
            let comps =
                fields |> List.mapi (fun i field ->
                    let fa = WExpr.StructGet(aGet, i, field.Type)
                    let fb = WExpr.StructGet(bGet, i, field.Type)
                    compareByWType ctx field.Type fa fb)
            comps |> List.fold (fun acc cmp -> and_ acc cmp) (i32Const 1)
    let parms = [("$eq_a", refT); ("$eq_b", refT)]
    let paramNames = parms |> List.map fst |> Set.ofList
    { Name = funcName; Params = parms; Result = WType.I32
      Locals = collectLocals paramNames body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// Generate an equality function for a data-carrying DU base type.
/// `baseIdx` = type index of the base struct (tag field only).
/// `caseTypeIdxs` = type indices of case structs (baseIdx+1, baseIdx+2, ...).
let makeDuEqualsFunc (ctx: Ctx) (funcName: string) (baseIdx: int) (caseTypeIdxs: int list) : WFuncDecl =
    let baseRefT = WType.Ref(baseIdx, false)
    let aGet = WExpr.LocalGet("$eq_a", baseRefT)
    let bGet = WExpr.LocalGet("$eq_b", baseRefT)
    let tagA = WExpr.StructGet(aGet, 0, WType.I32)
    let tagB = WExpr.StructGet(bGet, 0, WType.I32)
    // If tags differ → 0. If same → compare case fields.
    let caseEquality =
        if caseTypeIdxs.IsEmpty then i32Const 1 else
        // Build if-else chain: if tag=0 then compare_case0 else if tag=1 then ...
        let tagLocal = WExpr.LocalGet("$eq_tag", WType.I32)
        let indexedCases = caseTypeIdxs |> List.mapi (fun i caseIdx -> (i, caseIdx))
        let caseChain =
            List.foldBack (fun (i, caseIdx) (elseExpr: WExpr) ->
                let caseRef = WType.Ref(caseIdx, false)
                let caseDef = (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[caseIdx]
                let caseFields =
                    match caseDef.Def with
                    | WTypeDef.Struct(fields, _) -> fields |> List.tail  // skip tag field
                    | _ -> []
                let caseEq =
                    if caseFields.IsEmpty then i32Const 1
                    else
                        let castedA = WExpr.Cast(aGet, caseRef)
                        let castedB = WExpr.Cast(bGet, caseRef)
                        let comps =
                            caseFields |> List.mapi (fun fi field ->
                                let fa = WExpr.StructGet(castedA, fi + 1, field.Type)
                                let fb = WExpr.StructGet(castedB, fi + 1, field.Type)
                                compareByWType ctx field.Type fa fb)
                        comps |> List.fold (fun acc cmp -> and_ acc cmp) (i32Const 1)
                WExpr.If(
                    WExpr.Compare(WCompareOp.Eq, tagLocal, WExpr.Const(WConst.I32 i)),
                    caseEq, elseExpr, WType.I32)
            ) indexedCases (i32Const 0)
        WExpr.Let("$eq_tag", tagA, caseChain)
    let body =
        wasmIf
            (WExpr.Compare(WCompareOp.Ne, tagA, tagB))
            (i32Const 0)
            caseEquality
    let parms = [("$eq_a", baseRefT); ("$eq_b", baseRefT)]
    let paramNames = parms |> List.map fst |> Set.ofList
    { Name = funcName; Params = parms; Result = WType.I32
      Locals = collectLocals paramNames body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// Get or create a structural equality function for the struct/DU at `typeIdx`.
/// Registers in ctx.EqualityRegistry and adds to ctx.Functions.
/// Returns the function name.
let rec getOrAddStructuralEquals (ctx: Ctx) (typeIdx: int) : string option =
    match ctx.EqualityRegistry.TryGetValue(typeIdx) with
    | true, funcName -> Some funcName
    | false, _ ->
        if typeIdx >= ctx.TypeDefs.Count then None else
        let entry = (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[typeIdx]
        match entry.Def with
        | WTypeDef.Struct(fields, None) ->
            // Record or DU base — need to distinguish
            let isDuBase =
                // Check if there's a sub-type at typeIdx+1 that has superType = Some typeIdx
                typeIdx + 1 < ctx.TypeDefs.Count &&
                (match (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[typeIdx + 1].Def with
                 | WTypeDef.Struct(_, Some parent) -> parent = typeIdx
                 | _ -> false)
            let funcName = $"$equals_{typeIdx}"
            // Pre-register to prevent infinite recursion on recursive types
            ctx.EqualityRegistry.[typeIdx] <- funcName
            let func =
                if isDuBase then
                    // Collect all case type indices (consecutive sub-types)
                    let mutable caseIdx = typeIdx + 1
                    let caseTypeIdxs = System.Collections.Generic.List<int>()
                    while caseIdx < ctx.TypeDefs.Count &&
                          (match (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[caseIdx].Def with
                           | WTypeDef.Struct(_, Some parent) -> parent = typeIdx
                           | _ -> false) do
                        caseTypeIdxs.Add(caseIdx)
                        caseIdx <- caseIdx + 1
                    makeDuEqualsFunc ctx funcName typeIdx (Seq.toList caseTypeIdxs)
                else
                    makeRecordEqualsFunc ctx funcName typeIdx fields
            ctx.Functions.Add(func)
            Some funcName
        | _ -> None

/// Get or create a structural equality function for a tuple type.
/// The tuple struct is in ctx.TupleRegistry by its wTypesKey.
let getOrAddTupleEquals (ctx: Ctx) (tupleTypeIdx: int) : string option =
    getOrAddStructuralEquals ctx tupleTypeIdx
