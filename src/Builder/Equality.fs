/// Structural equality helpers for WasmGC.
/// Generates WFuncDecl equality functions for records and discriminated unions.
/// Extracted from Runtime.fs to separate concerns.
module WasmGc.Runtime.Equality

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core
open WasmGc.Runtime.Locals

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

// ─────────────────────────────────────────────────────────────────
// Structural ordering — `compare`, `<` `<=` `>` `>=` on records, unions, tuples, options
// ─────────────────────────────────────────────────────────────────

/// `compare a b` on numbers → -1 / 0 / 1.  Floats follow F#'s generic comparison: NaN is below every other value
/// and equal to itself —  x < y ? -1 : x > y ? 1 : x = y ? 0 : y = y ? -1 : (x = x ? 1 : 0).
let numericCompare (a: WExpr) (b: WExpr) (argTy: WType) : WExpr =
    let x, y = WExpr.LocalGet("$cmp_a", argTy), WExpr.LocalGet("$cmp_b", argTy)
    let cmp op l r = WExpr.Compare(op, l, r)
    let i32 n = WExpr.Const(WConst.I32 n)
    let body =
        match argTy with
        | WType.F64 | WType.F32 ->
            WExpr.If(cmp WCompareOp.LtS x y, i32 -1,
                WExpr.If(cmp WCompareOp.GtS x y, i32 1,
                    WExpr.If(cmp WCompareOp.Eq x y, i32 0,
                        WExpr.If(cmp WCompareOp.Eq y y, i32 -1,
                            WExpr.If(cmp WCompareOp.Eq x x, i32 1, i32 0, WType.I32), WType.I32), WType.I32), WType.I32), WType.I32)
        | _ ->
            WExpr.If(cmp WCompareOp.Eq x y, i32 0, WExpr.If(cmp WCompareOp.LtS x y, i32 -1, i32 1, WType.I32), WType.I32)
    WExpr.Let("$cmp_a", a, WExpr.Let("$cmp_b", b, body))

/// Is `ty` something `compareValues` can order structurally (a record / DU / tuple / option reference)?
let isStructuralRef (ty: WType) =
    match ty with
    | WType.Ref(idx, _) -> idx <> StringTypeIdx
    | _ -> false

/// Lexicographic combination of per-field comparisons (each -1 / 0 / 1): the first non-zero one wins.
let private lexicographic (comparisons: WExpr list) : WExpr =
    let i32 n = WExpr.Const(WConst.I32 n)
    match comparisons with
    | [] -> i32 0
    | _ ->
        // let c = cmp0 in if c <> 0 then c else (let c = cmp1 in …); the last one is returned as is
        let rec build (rest: WExpr list) : WExpr =
            match rest with
            | [ last ] -> last
            | first :: tail ->
                let c = WExpr.LocalGet("$cmp_c", WType.I32)
                WExpr.Let("$cmp_c", first, WExpr.If(WExpr.Compare(WCompareOp.Ne, c, i32 0), c, build tail, WType.I32))
            | [] -> i32 0
        build comparisons

/// -1 / 0 / 1 for two values of `ty`.  Structs and unions go through their registered `$compare_N`; `null`
/// (None) is below every non-null value, like F#'s option ordering.
let rec compareValues (ctx: Ctx) (ty: WType) (a: WExpr) (b: WExpr) : WExpr =
    let i32 n = WExpr.Const(WConst.I32 n)
    match ty with
    | WType.I32 | WType.I64 | WType.F32 | WType.F64 -> numericCompare a b ty
    | WType.Ref(idx, false) when idx = StringTypeIdx ->
        let c = WExpr.LocalGet("$cmp_s", WType.I32)
        WExpr.Let("$cmp_s", WExpr.Call("$strCompare", [ a; b ], WType.I32),
            WExpr.If(WExpr.Compare(WCompareOp.LtS, c, i32 0), i32 -1,
                WExpr.If(WExpr.Compare(WCompareOp.GtS, c, i32 0), i32 1, i32 0, WType.I32), WType.I32))
    | WType.Ref(idx, false) ->
        match getOrAddStructuralCompare ctx idx with
        | Some funcName -> WExpr.Call(funcName, [ a; b ], WType.I32)
        | None -> i32 0
    | WType.Ref(idx, true) ->
        let nullA, nullB = WExpr.RefIsNull a, WExpr.RefIsNull b
        wasmIf (and_ nullA nullB) (i32 0)
            (wasmIf nullA (i32 -1)
                (wasmIf nullB (i32 1)
                    (compareValues ctx (WType.Ref(idx, false)) (WExpr.Cast(a, WType.Ref(idx, false))) (WExpr.Cast(b, WType.Ref(idx, false))))))
    | _ -> i32 0

/// Ordering function of a record (or tuple) struct: field by field.
and private makeRecordCompareFunc (ctx: Ctx) (funcName: string) (typeIdx: int) (fields: WField list) : WFuncDecl =
    let refT = WType.Ref(typeIdx, false)
    let aGet, bGet = WExpr.LocalGet("$cmp_x", refT), WExpr.LocalGet("$cmp_y", refT)
    let body =
        fields
        |> List.mapi (fun i f -> compareValues ctx f.Type (WExpr.StructGet(aGet, i, f.Type)) (WExpr.StructGet(bGet, i, f.Type)))
        |> lexicographic
    let parms = [ ("$cmp_x", refT); ("$cmp_y", refT) ]
    { Name = funcName; Params = parms; Result = WType.I32
      Locals = collectLocals (parms |> List.map fst |> Set.ofList) body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// Ordering function of a union: by case tag first, then the fields of the (equal) case.
and private makeDuCompareFunc (ctx: Ctx) (funcName: string) (baseIdx: int) (caseTypeIdxs: int list) : WFuncDecl =
    let i32 n = WExpr.Const(WConst.I32 n)
    let baseRefT = WType.Ref(baseIdx, false)
    let aGet, bGet = WExpr.LocalGet("$cmp_x", baseRefT), WExpr.LocalGet("$cmp_y", baseRefT)
    let tagA, tagB = WExpr.StructGet(aGet, 0, WType.I32), WExpr.StructGet(bGet, 0, WType.I32)
    let tag = WExpr.LocalGet("$cmp_tag", WType.I32)
    let caseChain =
        List.foldBack
            (fun (i, caseIdx) (elseExpr: WExpr) ->
                let caseRef = WType.Ref(caseIdx, false)
                let fields =
                    match (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[caseIdx].Def with
                    | WTypeDef.Struct(fs, _) -> List.tail fs   // skip the tag
                    | _ -> []
                let cmp =
                    fields
                    |> List.mapi (fun fi f ->
                        compareValues ctx f.Type
                            (WExpr.StructGet(WExpr.Cast(aGet, caseRef), fi + 1, f.Type))
                            (WExpr.StructGet(WExpr.Cast(bGet, caseRef), fi + 1, f.Type)))
                    |> lexicographic
                WExpr.If(WExpr.Compare(WCompareOp.Eq, tag, i32 i), cmp, elseExpr, WType.I32))
            (caseTypeIdxs |> List.mapi (fun i c -> i, c))
            (i32 0)
    let body =
        WExpr.If(WExpr.Compare(WCompareOp.LtS, tagA, tagB), i32 -1,
            WExpr.If(WExpr.Compare(WCompareOp.GtS, tagA, tagB), i32 1,
                WExpr.Let("$cmp_tag", tagA, caseChain), WType.I32), WType.I32)
    let parms = [ ("$cmp_x", baseRefT); ("$cmp_y", baseRefT) ]
    { Name = funcName; Params = parms; Result = WType.I32
      Locals = collectLocals (parms |> List.map fst |> Set.ofList) body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// Get or create the structural ordering function for the struct / union / tuple at `typeIdx`.
and getOrAddStructuralCompare (ctx: Ctx) (typeIdx: int) : string option =
    match ctx.CompareRegistry.TryGetValue(typeIdx) with
    | true, funcName -> Some funcName
    | false, _ ->
        if typeIdx >= ctx.TypeDefs.Count then None else
        let defs = ctx.TypeDefs :> System.Collections.Generic.IList<_>
        match defs.[typeIdx].Def with
        | WTypeDef.Struct(fields, None) ->
            let isSubOf parent i =
                i < defs.Count && (match defs.[i].Def with WTypeDef.Struct(_, Some p) -> p = parent | _ -> false)
            let funcName = $"$compare_{typeIdx}"
            ctx.CompareRegistry.[typeIdx] <- funcName          // register first: recursive types
            let func =
                if isSubOf typeIdx (typeIdx + 1) then
                    let mutable caseIdx = typeIdx + 1
                    let cases = System.Collections.Generic.List<int>()
                    while isSubOf typeIdx caseIdx do
                        cases.Add caseIdx
                        caseIdx <- caseIdx + 1
                    makeDuCompareFunc ctx funcName typeIdx (Seq.toList cases)
                else
                    makeRecordCompareFunc ctx funcName typeIdx fields
            ctx.Functions.Add func
            Some funcName
        | _ -> None

/// `a = b` for two values of a struct / union / tuple / option type (anything but strings and primitives falls back
/// to reference equality).  An option is a NULLABLE reference — None is null — so both operands are bound once and
/// compared with the null-aware `compareByWType`.
let structuralEquals (ctx: Ctx) (a: WExpr) (b: WExpr) : WExpr =
    let ty = exprWType a
    match ty with
    | WType.Ref(idx, nullable) when idx <> StringTypeIdx ->
        getOrAddStructuralEquals ctx idx |> ignore
        ctx.UseHelper "$strEq" |> ignore                      // fields may be strings
        if nullable then
            WExpr.Let("$eqn_a", a, WExpr.Let("$eqn_b", b,
                compareByWType ctx ty (WExpr.LocalGet("$eqn_a", ty)) (WExpr.LocalGet("$eqn_b", ty))))
        else
            match ctx.EqualityRegistry.TryGetValue idx with
            | true, funcName -> WExpr.Call(funcName, [ a; b ], WType.I32)
            | _ -> WExpr.Compare(WCompareOp.Eq, a, b)
    | _ -> WExpr.Compare(WCompareOp.Eq, a, b)
