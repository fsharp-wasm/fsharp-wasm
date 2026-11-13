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

/// `a = b` for two strings (result: i32), by content.  A `string option` is a nullable reference, so an operand may be
/// null: null = null, and null differs from every string.  (`$strEq` itself takes non-null strings.)
let strEquals (ctx: Ctx) (a: WExpr) (b: WExpr) : WExpr =
    let strEq x y = WExpr.Call(ctx.UseHelper "$strEq", [x; y], WType.I32)
    match exprWType a, exprWType b with
    | WType.Ref(_, false), WType.Ref(_, false) -> strEq a b
    | ta, tb ->
        let nonNull = WType.Ref(StringTypeIdx, false)
        let la, lb = WExpr.LocalGet("$seq_a", ta), WExpr.LocalGet("$seq_b", tb)
        WExpr.Let("$seq_a", a, WExpr.Let("$seq_b", b,
            wasmIf (and_ (WExpr.RefIsNull la) (WExpr.RefIsNull lb))
                (i32Const 1)
                (wasmIf (or_ (WExpr.RefIsNull la) (WExpr.RefIsNull lb))
                    (i32Const 0)
                    (strEq (WExpr.Cast(la, nonNull)) (WExpr.Cast(lb, nonNull))))))

/// Return a WExpr (result: i32) that compares two WExprs of the given WType.
/// Uses registered equality functions for nested struct/DU types.
let rec compareByWType (ctx: Ctx) (ty: WType) (a: WExpr) (b: WExpr) : WExpr =
    match ty with
    | WType.I32 | WType.I64 | WType.F32 | WType.F64 ->
        WExpr.Compare(WCompareOp.Eq, a, b)
    | WType.Ref(idx, _) when idx = StringTypeIdx -> strEquals ctx a b
    | WType.Ref(idx, false) ->
        // Non-nullable ref: look up or generate structural equality (records, unions, tuples, arrays)
        match getOrAddStructuralEquals ctx idx with
        | Some funcName -> WExpr.Call(funcName, [a; b], WType.I32)
        | None ->
            // Not a structural type (closure, …) — reference equality
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
                (match getOrAddStructuralEquals ctx idx with
                 | Some funcName ->
                     let aFixed = WExpr.Cast(a, WType.Ref(idx, false))
                     let bFixed = WExpr.Cast(b, WType.Ref(idx, false))
                     WExpr.Call(funcName, [aFixed; bFixed], WType.I32)
                 | None -> WExpr.Compare(WCompareOp.Eq, a, b)))
    | _ -> WExpr.Compare(WCompareOp.Eq, a, b)

/// Generate an equality function for a record struct type.
/// `typeIdx` must be in ctx.TypeDefs; `fields` are the struct fields.
and makeRecordEqualsFunc (ctx: Ctx) (funcName: string) (typeIdx: int) (fields: WField list) : WFuncDecl =
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
and makeDuEqualsFunc (ctx: Ctx) (funcName: string) (baseIdx: int) (caseTypeIdxs: int list) : WFuncDecl =
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
and getOrAddStructuralEquals (ctx: Ctx) (typeIdx: int) : string option =
    if typeIdx = ListBaseTypeIdx then Some(getOrAddListEquals ctx) else
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
        | WTypeDef.Array(elemT, _) ->
            let funcName = $"$equals_{typeIdx}"
            ctx.EqualityRegistry.[typeIdx] <- funcName
            let func = makeArrayEqualsFunc ctx funcName typeIdx elemT
            ctx.Functions.Add(func)
            Some funcName
        | _ -> None

/// Equality function of an array type: same length and equal elements, left to right (stops at the first difference).
and makeArrayEqualsFunc (ctx: Ctx) (funcName: string) (typeIdx: int) (elemT: WType) : WFuncDecl =
    let refT = WType.Ref(typeIdx, false)
    let a, b = WExpr.LocalGet("$eq_a", refT), WExpr.LocalGet("$eq_b", refT)
    let i, ok = WExpr.LocalGet("$eq_i", WType.I32), WExpr.LocalGet("$eq_ok", WType.I32)
    let at arr = WExpr.ArrayGet(arr, i, elemT)
    let loop =
        whileLoop "$eq_loop" (and_ ok (WExpr.Compare(WCompareOp.LtS, i, WExpr.ArrayLen a)))
            (WExpr.Sequence [ WExpr.Assign("$eq_ok", compareByWType ctx elemT (at a) (at b))
                              WExpr.Assign("$eq_i", add i (i32Const 1)) ])
    let body =
        wasmIf (WExpr.Compare(WCompareOp.Ne, WExpr.ArrayLen a, WExpr.ArrayLen b))
            (i32Const 0)
            (WExpr.LetMut("$eq_i", i32Const 0, WExpr.LetMut("$eq_ok", i32Const 1, WExpr.Sequence [ loop; ok ])))
    let parms = [ ("$eq_a", refT); ("$eq_b", refT) ]
    { Name = funcName; Params = parms; Result = WType.I32
      Locals = collectLocals (parms |> List.map fst |> Set.ofList) body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }


// ── lists ──────────────────────────────────────────────────────────────────────────────────────────────────────
// Every list is the one base struct; each element type has its own cons subtype `{ head; tail }`.  Equality and
// ordering therefore dispatch on the node's runtime type: `$equals_list_vN` tests the registered cons types in turn
// and hands over to `$equals_list_<cons>`, which walks both lists.  `N` = number of element types registered at the
// time of the request, so a later request (more element types) gets a fresh dispatcher.

/// `(consIdx, head type)` of every registered list element type.
and private consTypes (ctx: Ctx) : (int * WType) list =
    [ for consIdx in ctx.ListRegistry.Values |> Seq.distinct ->
        consIdx, (match ctx.TypeDefs.[consIdx].Def with WTypeDef.Struct(f :: _, _) -> f.Type | _ -> WType.I32) ]

/// Add `decl` unless a function of that name exists already.
and private addOnce (ctx: Ctx) (decl: WFuncDecl) : string =
    if not (ctx.Functions.Exists(fun f -> f.Name = decl.Name)) then ctx.Functions.Add decl
    decl.Name

and private listFunc (ctx: Ctx) (name: string) (result: WType) (body: WExpr) : WFuncDecl =
    let baseRef = WType.Ref(ListBaseTypeIdx, false)
    let parms = [ ("$la", baseRef); ("$lb", baseRef) ]
    { Name = name; Params = parms; Result = result
      Locals = collectLocals (parms |> List.map fst |> Set.ofList) body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// Walk both lists in step.  `step headX headY` yields a verdict; the walk goes on while it equals `carryOn` and
/// ends with the verdict otherwise.  When either list ends, `onEnd` (given the two cursors) gives the result.
and private walkLists (consIdx: int) (headT: WType) (carryOn: int) (step: WExpr -> WExpr -> WExpr) (onEnd: WExpr -> WExpr -> WExpr) : WExpr =
    let baseRef, baseNull = WType.Ref(ListBaseTypeIdx, false), WType.Ref(ListBaseTypeIdx, true)
    let consT = WType.Ref(consIdx, false)
    let local n ty = WExpr.LocalGet(n, ty)
    let x, y = local "$lx" baseNull, local "$ly" baseNull
    let cx, cy = WExpr.Cast(x, consT), WExpr.Cast(y, consT)
    let verdict = local "$lh" WType.I32
    let finish v = WExpr.Sequence [ WExpr.Assign("$lr", v); WExpr.Assign("$ld", i32Const 1) ]
    let iteration =
        WExpr.If(or_ (WExpr.RefIsNull x) (WExpr.RefIsNull y),
            finish (onEnd x y),
            WExpr.Let("$lh", step (WExpr.StructGet(cx, 0, headT)) (WExpr.StructGet(cy, 0, headT)),
                WExpr.If(WExpr.Compare(WCompareOp.Ne, verdict, i32Const carryOn),
                    finish verdict,
                    WExpr.Sequence [ WExpr.Assign("$lx", WExpr.StructGet(cx, 1, baseNull))
                                     WExpr.Assign("$ly", WExpr.StructGet(cy, 1, baseNull)) ],
                    WType.Void)),
            WType.Void)
    WExpr.LetMut("$lx", WExpr.Cast(local "$la" baseRef, baseNull),
        WExpr.LetMut("$ly", WExpr.Cast(local "$lb" baseRef, baseNull),
            WExpr.LetMut("$lr", i32Const 0,
                WExpr.LetMut("$ld", i32Const 0,
                    WExpr.Sequence [ whileLoop "$lw" (WExpr.Compare(WCompareOp.Eq, local "$ld" WType.I32, i32Const 0)) iteration
                                     local "$lr" WType.I32 ]))))

/// Dispatcher: the first registered cons type the node is an instance of picks the walker.
and private listDispatch (ctx: Ctx) (name: string) (walkerPrefix: string) (walk: int -> WType -> WExpr) (whenNoMatch: WExpr) : string =
    let baseRef = WType.Ref(ListBaseTypeIdx, false)
    let a, b = WExpr.LocalGet("$la", baseRef), WExpr.LocalGet("$lb", baseRef)
    let types = consTypes ctx
    let perCons = types |> List.map (fun (consIdx, headT) -> consIdx, addOnce ctx (listFunc ctx $"{walkerPrefix}{consIdx}" WType.I32 (walk consIdx headT)))
    let dispatch =
        List.foldBack
            (fun (consIdx, fn) (rest: WExpr) ->
                WExpr.If(WExpr.RefTest(a, WType.Ref(consIdx, false)), WExpr.Call(fn, [ a; b ], WType.I32), rest, WType.I32))
            perCons whenNoMatch
    addOnce ctx (listFunc ctx name WType.I32 dispatch)

/// `$equals_list_vN(a, b)` for two NON-NULL lists: same length, equal heads.
and getOrAddListEquals (ctx: Ctx) : string =
    let name = $"$equals_list_v{(consTypes ctx).Length}"
    match ctx.EqualityRegistry.TryGetValue ListBaseTypeIdx with
    | true, n when n = name -> n                    // built, or being built (a list of lists asks for itself)
    | _ ->
        ctx.EqualityRegistry.[ListBaseTypeIdx] <- name
        listDispatch ctx name "$equals_list_c"
            (fun consIdx headT ->
                walkLists consIdx headT 1
                    (fun hx hy -> compareByWType ctx headT hx hy)
                    (fun x y -> and_ (WExpr.RefIsNull x) (WExpr.RefIsNull y)))
            (i32Const 1)

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
    if typeIdx = ListBaseTypeIdx then Some(getOrAddListCompare ctx) else
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

/// `$compare_list_vN(a, b)` for two NON-NULL lists: lexicographic over the heads, the shorter prefix is smaller.
and getOrAddListCompare (ctx: Ctx) : string =
    let name = $"$compare_list_v{(consTypes ctx).Length}"
    match ctx.CompareRegistry.TryGetValue ListBaseTypeIdx with
    | true, n when n = name -> n
    | _ ->
        ctx.CompareRegistry.[ListBaseTypeIdx] <- name
        listDispatch ctx name "$compare_list_c"
            (fun consIdx headT ->
                walkLists consIdx headT 0
                    (fun hx hy -> compareValues ctx headT hx hy)
                    (fun x y -> wasmIf (WExpr.RefIsNull x) (wasmIf (WExpr.RefIsNull y) (i32Const 0) (i32Const -1)) (i32Const 1)))
            (i32Const 0)

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
    // strings compare by content (generic code reaches `=` with a string only once instantiated)
    | WType.Ref(idx, _) when idx = StringTypeIdx -> strEquals ctx a b
    | _ -> WExpr.Compare(WCompareOp.Eq, a, b)

// ─────────────────────────────────────────────────────────────────
// Structural hashing — `hash x`, Dictionary / HashSet keys
//   Consistent with `compareByWType`: whatever `=` calls equal hashes equal.  Primitives hash to their value
//   (as in .NET), strings by FNV-1a, records / tuples / unions / arrays / lists by an FNV fold over their parts.
//   References that are compared by identity (closures, anything without structure) hash to 0: correct, just slow.
// ─────────────────────────────────────────────────────────────────

[<Literal>]
let private FnvBasis = -2128831035   // 0x811C9DC5
[<Literal>]
let private FnvPrime = 16777619

/// Fold one more part into a running hash.
let private mix (h: WExpr) (x: WExpr) = mul (xor_ h x) (i32Const FnvPrime)

let private hashFunc (name: string) (parms: (string * WType) list) (body: WExpr) : WFuncDecl =
    { Name = name; Params = parms; Result = WType.I32
      Locals = collectLocals (parms |> List.map fst |> Set.ofList) body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// `$hash_N(x)` for the struct / union / array type at `typeIdx`, or None for types without structure.
let rec getOrAddStructuralHash (ctx: Ctx) (typeIdx: int) : string option =
    if typeIdx = ListBaseTypeIdx then Some(getOrAddListHash ctx) else
    match ctx.HashRegistry.TryGetValue typeIdx with
    | true, name -> Some name
    | false, _ ->
        if typeIdx >= ctx.TypeDefs.Count then None else
        let name = $"$hash_{typeIdx}"
        let defs = ctx.TypeDefs :> System.Collections.Generic.IList<_>
        let isCaseOf parent i = i < defs.Count && (match defs.[i].Def with WTypeDef.Struct(_, Some p) -> p = parent | _ -> false)
        let register (build: unit -> WFuncDecl) =
            ctx.HashRegistry.[typeIdx] <- name              // before the body: recursive types ask for themselves
            ctx.Functions.Add(build ())
            Some name
        let refT = WType.Ref(typeIdx, false)
        let self = WExpr.LocalGet("$h_a", refT)
        match defs.[typeIdx].Def with
        | WTypeDef.Struct(_, None) when isCaseOf typeIdx (typeIdx + 1) ->
            // union: the tag, then the fields of the case the value is
            let cases = Seq.initInfinite ((+) (typeIdx + 1)) |> Seq.takeWhile (isCaseOf typeIdx) |> Seq.toList
            register (fun () ->
                let tag = WExpr.LocalGet("$h_tag", WType.I32)
                let seed = mix (i32Const FnvBasis) tag
                let caseHash caseIdx =
                    let caseRef = WType.Ref(caseIdx, false)
                    let fs = match defs.[caseIdx].Def with WTypeDef.Struct(fs, _) -> List.tail fs | _ -> []
                    fs |> List.mapi (fun fi f -> hashValue ctx f.Type (WExpr.StructGet(WExpr.Cast(self, caseRef), fi + 1, f.Type)))
                       |> List.fold mix seed
                let chain =
                    List.foldBack (fun (i, c) rest -> WExpr.If(WExpr.Compare(WCompareOp.Eq, tag, i32Const i), caseHash c, rest, WType.I32))
                        (cases |> List.mapi (fun i c -> i, c)) seed
                hashFunc name [ "$h_a", refT ] (WExpr.Let("$h_tag", WExpr.StructGet(self, 0, WType.I32), chain)))
        | WTypeDef.Struct(fields, None) ->
            register (fun () ->
                let parts = fields |> List.mapi (fun i f -> hashValue ctx f.Type (WExpr.StructGet(self, i, f.Type)))
                hashFunc name [ "$h_a", refT ] (parts |> List.fold mix (i32Const FnvBasis)))
        | WTypeDef.Array(elemT, _) ->
            register (fun () ->
                let i, h = WExpr.LocalGet("$h_i", WType.I32), WExpr.LocalGet("$h_h", WType.I32)
                let loop =
                    whileLoop "$h_loop" (WExpr.Compare(WCompareOp.LtS, i, WExpr.ArrayLen self))
                        (WExpr.Sequence [ WExpr.Assign("$h_h", mix h (hashValue ctx elemT (WExpr.ArrayGet(self, i, elemT))))
                                          WExpr.Assign("$h_i", add i (i32Const 1)) ])
                hashFunc name [ "$h_a", refT ] (WExpr.LetMut("$h_i", i32Const 0, WExpr.LetMut("$h_h", i32Const FnvBasis, WExpr.Sequence [ loop; h ]))))
        | _ -> None

/// The hash (an i32 expression) of `x`, a value of `ty`.
and hashValue (ctx: Ctx) (ty: WType) (x: WExpr) : WExpr =
    let local n t = WExpr.LocalGet(n, t)
    match ty with
    | WType.I32 -> x
    | WType.I64 ->
        WExpr.Let("$h_x", x,
            WExpr.Unary(WUnaryOp.WrapI64,
                WExpr.Binary(WBinaryOp.Xor, local "$h_x" ty, WExpr.Binary(WBinaryOp.ShrU, local "$h_x" ty, WExpr.Const(WConst.I64 32L), WType.I64), WType.I64),
                WType.I32))
    | WType.F32 | WType.F64 ->
        // 0.0 and -0.0 are equal, so they hash alike; every other value by its bits
        let is32 = (ty = WType.F32)
        let bits = WExpr.Unary((if is32 then WUnaryOp.ReinterpretF32ToI32 else WUnaryOp.ReinterpretF64ToI64), local "$h_f" ty, (if is32 then WType.I32 else WType.I64))
        let zero = if is32 then WExpr.Const(WConst.F32 0.0f) else WExpr.Const(WConst.F64 0.0)
        WExpr.Let("$h_f", x,
            WExpr.If(WExpr.Compare(WCompareOp.Eq, local "$h_f" ty, zero), i32Const 0,
                (if is32 then bits else hashValue ctx WType.I64 bits), WType.I32))
    | WType.Ref(idx, false) when idx = StringTypeIdx -> WExpr.Call(ctx.UseHelper "$strHash", [ x ], WType.I32)
    | WType.Ref(idx, false) ->
        match getOrAddStructuralHash ctx idx with
        | Some fn -> WExpr.Call(fn, [ x ], WType.I32)
        | None -> WExpr.Let("$h_d", x, i32Const 0)
    | WType.Ref(idx, true) ->
        // None / null hashes to 0
        let nonNull = WType.Ref(idx, false)
        WExpr.Let("$h_n", x,
            wasmIf (WExpr.RefIsNull(local "$h_n" ty)) (i32Const 0) (hashValue ctx nonNull (WExpr.Cast(local "$h_n" ty, nonNull))))
    | _ -> WExpr.Let("$h_d", x, i32Const 0)

/// `$hash_list_vN(list)` for a NON-NULL list: the heads folded in order; N as for `$equals_list_vN`.
and getOrAddListHash (ctx: Ctx) : string =
    let name = $"$hash_list_v{(consTypes ctx).Length}"
    match ctx.HashRegistry.TryGetValue ListBaseTypeIdx with
    | true, n when n = name -> n
    | _ ->
        ctx.HashRegistry.[ListBaseTypeIdx] <- name
        let baseRef, baseNull = WType.Ref(ListBaseTypeIdx, false), WType.Ref(ListBaseTypeIdx, true)
        let list = WExpr.LocalGet("$la", baseRef)
        let walk consIdx headT =
            let consT = WType.Ref(consIdx, false)
            let node, h = WExpr.LocalGet("$lx", baseNull), WExpr.LocalGet("$lh", WType.I32)
            let cons = WExpr.Cast(node, consT)
            WExpr.LetMut("$lx", WExpr.Cast(list, baseNull),
                WExpr.LetMut("$lh", i32Const FnvBasis,
                    WExpr.Sequence [ whileLoop "$lw" (WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull node, WType.I32))
                                         (WExpr.Sequence [ WExpr.Assign("$lh", mix h (hashValue ctx headT (WExpr.StructGet(cons, 0, headT))))
                                                           WExpr.Assign("$lx", WExpr.StructGet(cons, 1, baseNull)) ])
                                     h ]))
        let perCons = consTypes ctx |> List.map (fun (consIdx, headT) -> consIdx, addOnce ctx (hashFunc $"$hash_list_c{consIdx}" [ "$la", baseRef ] (walk consIdx headT)))
        let dispatch =
            List.foldBack (fun (consIdx, fn) rest -> WExpr.If(WExpr.RefTest(list, WType.Ref(consIdx, false)), WExpr.Call(fn, [ list ], WType.I32), rest, WType.I32))
                perCons (i32Const 0)
        addOnce ctx (hashFunc name [ "$la", baseRef ] dispatch)

/// `hash x` — what Fable's `numberHash` / `stringHash` / `safeHash` / `structuralHash` / `arrayHash` calls compile to.
let structuralHash (ctx: Ctx) (x: WExpr) : WExpr = hashValue ctx (exprWType x) x

/// `GetHashCode()` of something without a structural hash of its own (`identityHash`): values hash as above, but
/// references have no address to read, so they all hash to 0 (still correct, merely collides).
let identityHash (ctx: Ctx) (x: WExpr) : WExpr =
    match exprWType x with
    | WType.Ref(idx, _) when idx <> StringTypeIdx -> WExpr.Let("$h_d", x, i32Const 0)
    | _ -> structuralHash ctx x
