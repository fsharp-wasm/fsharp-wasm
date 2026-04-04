/// WasmGC inline replacements for List higher-order functions.
/// fold, map, mapIndexed, filter, iter, iteri, exists, forAll,
/// collect, choose, foldBack, sumBy, minMaxBy, init, replicate.
///
/// Each function expresses only the semantic loop body; the shared
/// mkListLoop / mkListShape machinery lives in WasmGcLoopHelpers.
module Fable.Transforms.WasmGc.WasmGcListCombinators

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder
open Fable.Transforms.WasmGc.WasmGcRuntime
open Fable.Transforms.WasmGc.WasmGcLoopHelpers
open Fable.Transforms.WasmGc.WasmGcLoopCombinators

/// Extract element Fable.Type from List<T>, seq<T>, or IEnumerable<T>.
/// Lets all handlers accept Seq.* calls that Fable encodes as DeclaredType<_,[T]>.
let private seqElemType (t: Fable.Type) : Fable.Type option =
    match t with
    | Fable.Type.List e               -> Some e
    | Fable.Type.DeclaredType(_, [e]) -> Some e
    | _                               -> None

let tryListFoldInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | "fold", [Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _); initArg; listArg]
    | "fold", [Fable.Expr.Delegate([farg1; farg2], fbody, _, _); initArg; listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let wInit = transform ctx initArg
            let wList = transform ctx listArg
            let accT  = mapTypeKnown ctx initArg.Type
            let ctx'  = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
            let wBody = transform ctx' fbody
            Some(mkListLoop "fold" elemT consIdx wList
                    [(farg1.Name, wInit)]
                    (fun h -> WExpr.Assign(farg1.Name, WExpr.Let(farg2.Name, h, wBody)))
                    (WExpr.LocalGet(farg1.Name, accT)) None)
        | None -> None
    // List.reduce f xs — like fold but uses head as initial accumulator
    | "reduce", [Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _); listArg]
    | "reduce", [Fable.Expr.Delegate([farg1; farg2], fbody, _, _); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let wList        = transform ctx listArg
            let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
            let listNNRefT   = WType.Ref(consIdx, false)
            let ctx'         = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
            let wBody        = transform ctx' fbody
            let lstVar = "$red_lst"
            let nnVar  = "$red_nn"
            // Cast to non-null, grab head as initial acc, fold over tail
            Some(
                WExpr.Let(lstVar, wList,
                    WExpr.Let(nnVar,
                        WExpr.Cast(WExpr.LocalGet(lstVar, listBaseRefT), listNNRefT),
                        mkListLoop "red" elemT consIdx
                            (WExpr.StructGet(WExpr.LocalGet(nnVar, listNNRefT), 1, listBaseRefT))
                            [(farg1.Name, WExpr.StructGet(WExpr.LocalGet(nnVar, listNNRefT), 0, elemT))]
                            (fun h -> WExpr.Assign(farg1.Name, WExpr.Let(farg2.Name, h, wBody)))
                            (WExpr.LocalGet(farg1.Name, elemT)) None)))
        | None -> None
    | _ -> None

let tryListMapInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "map", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match seqElemType listArg.Type with
        | Some elemFableType ->
            let resultElemFableType = seqElemType resultFableType |> Option.defaultValue elemFableType
            match tryListTypeInfo ctx listArg, tryListTypeInfoFromElemType ctx resultElemFableType with
            | Some(inputElemT, inputConsIdx), Some(resultElemT, resultConsIdx) ->
                let wList        = transform ctx listArg
                let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
                let null_list    = WExpr.Const(WConst.Null listBaseRefT)
                let ctx'         = ctx.WithLocal(farg.Name, inputElemT)
                let wBody        = transform ctx' fbody
                let revMapped =
                    mkListLoop "maprev" inputElemT inputConsIdx wList
                        [("$maprev_acc", null_list)]
                        (fun h -> WExpr.Assign("$maprev_acc",
                            WExpr.StructNew(resultConsIdx,
                                [WExpr.Let(farg.Name, h, wBody); WExpr.LocalGet("$maprev_acc", listBaseRefT)],
                                listBaseRefT)))
                        (WExpr.LocalGet("$maprev_acc", listBaseRefT)) None
                Some(mkListLoop "map" resultElemT resultConsIdx revMapped
                        [("$map_acc", null_list)]
                        (fun h -> WExpr.Assign("$map_acc",
                            WExpr.StructNew(resultConsIdx,
                                [h; WExpr.LocalGet("$map_acc", listBaseRefT)],
                                listBaseRefT)))
                        (WExpr.LocalGet("$map_acc", listBaseRefT)) None)
            | _ -> None
        | None -> None
    | "mapIndexed", [(Fable.Expr.Lambda(iarg, Fable.Expr.Lambda(farg, fbody, _), _)
                   | Fable.Expr.Delegate([iarg; farg], fbody, _, _)); listArg] ->
        match seqElemType listArg.Type with
        | Some elemFableType ->
            let resultElemFableType = seqElemType resultFableType |> Option.defaultValue elemFableType
            match tryListTypeInfo ctx listArg, tryListTypeInfoFromElemType ctx resultElemFableType with
            | Some(inputElemT, inputConsIdx), Some(resultElemT, resultConsIdx) ->
                let wList        = transform ctx listArg
                let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
                let null_list    = WExpr.Const(WConst.Null listBaseRefT)
                let ctx'         = ctx.WithLocal(iarg.Name, WType.I32).WithLocal(farg.Name, inputElemT)
                let wBody        = transform ctx' fbody
                let revMapped =
                    mkListLoop "mapirev" inputElemT inputConsIdx wList
                        [("$mapirev_acc", null_list); ("$mapi_idx", WExpr.Const(WConst.I32 0))]
                        (fun h ->
                            WExpr.Sequence [
                                WExpr.Assign("$mapirev_acc",
                                    WExpr.StructNew(resultConsIdx,
                                        [WExpr.Let(iarg.Name, WExpr.LocalGet("$mapi_idx", WType.I32),
                                            WExpr.Let(farg.Name, h, wBody));
                                         WExpr.LocalGet("$mapirev_acc", listBaseRefT)],
                                        listBaseRefT))
                                WExpr.Assign("$mapi_idx",
                                    WExpr.Binary(WBinaryOp.Add,
                                        WExpr.LocalGet("$mapi_idx", WType.I32),
                                        WExpr.Const(WConst.I32 1), WType.I32))
                            ])
                        (WExpr.LocalGet("$mapirev_acc", listBaseRefT)) None
                Some(mkListLoop "mapi" resultElemT resultConsIdx revMapped
                        [("$mapi_acc", null_list)]
                        (fun h -> WExpr.Assign("$mapi_acc",
                            WExpr.StructNew(resultConsIdx,
                                [h; WExpr.LocalGet("$mapi_acc", listBaseRefT)],
                                listBaseRefT)))
                        (WExpr.LocalGet("$mapi_acc", listBaseRefT)) None)
            | _ -> None
        | None -> None
    | _ -> None

let tryListFilterInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | "filter", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let wList        = transform ctx listArg
            let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
            let null_list    = WExpr.Const(WConst.Null listBaseRefT)
            let ctx'         = ctx.WithLocal(farg.Name, elemT)
            let wPred        = transform ctx' fbody
            let revFiltered =
                mkListLoop "filtrev" elemT consIdx wList
                    [("$filtrev_acc", null_list)]
                    (fun h -> WExpr.Let(farg.Name, h,
                        WExpr.If(wPred,
                            WExpr.Assign("$filtrev_acc",
                                WExpr.StructNew(consIdx,
                                    [WExpr.LocalGet(farg.Name, elemT); WExpr.LocalGet("$filtrev_acc", listBaseRefT)],
                                    listBaseRefT)),
                            WExpr.Nop, WType.Void)))
                    (WExpr.LocalGet("$filtrev_acc", listBaseRefT)) None
            Some(mkListLoop "filt" elemT consIdx revFiltered
                    [("$filt_acc", null_list)]
                    (fun h -> WExpr.Assign("$filt_acc",
                        WExpr.StructNew(consIdx,
                            [h; WExpr.LocalGet("$filt_acc", listBaseRefT)],
                            listBaseRefT)))
                    (WExpr.LocalGet("$filt_acc", listBaseRefT)) None)
        | None -> None
    | _ -> None

let tryListIterInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | ("iter" | "iterate"), [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let wList = transform ctx listArg
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wBody = transform ctx' fbody
            Some(mkListLoop "iter" elemT consIdx wList []
                    (fun h -> WExpr.Let(farg.Name, h, wBody)) WExpr.Nop None)
        | None -> None
    | "iterateIndexed", [(Fable.Expr.Lambda(iarg, Fable.Expr.Lambda(farg, fbody, _), _)
                       | Fable.Expr.Delegate([iarg; farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let wList = transform ctx listArg
            let ctx'  = ctx.WithLocal(iarg.Name, WType.I32).WithLocal(farg.Name, elemT)
            let wBody = transform ctx' fbody
            Some(mkListLoop "iteri" elemT consIdx wList
                    [("$iteri_idx", WExpr.Const(WConst.I32 0))]
                    (fun h ->
                        WExpr.Sequence [
                            WExpr.Let(iarg.Name, WExpr.LocalGet("$iteri_idx", WType.I32),
                                WExpr.Let(farg.Name, h, wBody))
                            WExpr.Assign("$iteri_idx",
                                WExpr.Binary(WBinaryOp.Add,
                                    WExpr.LocalGet("$iteri_idx", WType.I32),
                                    WExpr.Const(WConst.I32 1), WType.I32))
                        ])
                    WExpr.Nop None)
        | None -> None
    | _ -> None

let tryListExistsForAllInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | (("exists" | "forAll") as sel), [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let wList = transform ctx listArg
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            let (breakVal, fallback) =
                if sel = "exists"
                then WExpr.Const(WConst.I32 1), WExpr.Const(WConst.I32 0)
                else WExpr.Const(WConst.I32 0), WExpr.Const(WConst.I32 1)
            let checkExpr =
                if sel = "exists" then wPred
                else WExpr.Unary(WUnaryOp.Eqz, wPred, WType.I32)
            Some(mkListLoop "exi" elemT consIdx wList []
                    (fun h -> WExpr.Let(farg.Name, h,
                        WExpr.If(checkExpr, WExpr.Break("$exi_exit", Some breakVal), WExpr.Nop, WType.Void)))
                    fallback (Some("$exi_exit", WType.I32)))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List.collect (flatMap) and List.choose (filter-map)
// ─────────────────────────────────────────────────────────────────

let tryListCollectInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "collect", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match seqElemType listArg.Type with
        | Some inputElemFableType ->
            let outputElemFableType = seqElemType resultFableType |> Option.defaultValue inputElemFableType
            match tryListTypeInfo ctx listArg, tryListTypeInfoFromElemType ctx outputElemFableType with
            | Some(inputElemT, inputConsIdx), Some(outputElemT, outputConsIdx) ->
                let wList        = transform ctx listArg
                let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
                let null_list    = WExpr.Const(WConst.Null listBaseRefT)
                let ctx'         = ctx.WithLocal(farg.Name, inputElemT)
                let wBody        = transform ctx' fbody
                // Build reversed concatenation: outer loop over source, inner loop over each sub-list
                let revConcat =
                    mkListLoop "collout" inputElemT inputConsIdx wList
                        [("$coll_acc", null_list)]
                        (fun h ->
                            mkListLoop "collsub" outputElemT outputConsIdx
                                (WExpr.Let(farg.Name, h, wBody))
                                []
                                (fun s -> WExpr.Assign("$coll_acc",
                                    WExpr.StructNew(outputConsIdx,
                                        [s; WExpr.LocalGet("$coll_acc", listBaseRefT)],
                                        listBaseRefT)))
                                WExpr.Nop None)
                        // postLoop: reverse $coll_acc into the final result
                        (mkListLoop "collrev" outputElemT outputConsIdx
                            (WExpr.LocalGet("$coll_acc", listBaseRefT))
                            [("$coll_final", null_list)]
                            (fun s -> WExpr.Assign("$coll_final",
                                WExpr.StructNew(outputConsIdx,
                                    [s; WExpr.LocalGet("$coll_final", listBaseRefT)],
                                    listBaseRefT)))
                            (WExpr.LocalGet("$coll_final", listBaseRefT)) None)
                        None
                Some revConcat
            | _ -> None
        | None -> None
    // List.partition pred xs → (trueList, falseList) as a tuple struct.
    // Strategy: single pass collecting two reversed accumulators, then reverse each.
    | "partition", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match seqElemType listArg.Type with
        | Some elemFableT ->
            match tryListTypeInfo ctx listArg with
            | None -> None
            | Some(elemT, consIdx) ->
            // Register the tuple type (List<elemT> * List<elemT>)
            let listFableT  = Fable.Type.List(elemFableT)
            let tupleFableT = Fable.Type.Tuple([listFableT; listFableT], false)
            let tupleWType  = mapTypeKnown ctx tupleFableT
            let listWT      = mapTypeKnown ctx listFableT
            let listKey     = wTypeKey listWT
            let tupleIdx    =
                let key = wTypesKey [listWT; listWT]
                match ctx.TupleRegistry.TryGetValue(key) with
                | true, idx -> idx
                | _ -> failwith "List.partition: tuple not registered after mapTypeKnown"
            let tupleRefT   = WType.Ref(tupleIdx, false)
            let wList        = transform ctx listArg
            let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
            let null_list    = WExpr.Const(WConst.Null listBaseRefT)
            let ctx'         = ctx.WithLocal(farg.Name, elemT)
            let wPred        = transform ctx' fbody
            let trueAcc  = "$part_tacc"
            let falseAcc = "$part_facc"
            let trueOut  = "$part_tout"
            let falseOut = "$part_fout"
            let accType  = listBaseRefT
            // Single pass: build reversed true and false lists
            let buildRevLists =
                mkListLoop "part1" elemT consIdx wList
                    [(trueAcc, null_list); (falseAcc, null_list)]
                    (fun h ->
                        WExpr.Let(farg.Name, h,
                            WExpr.If(wPred,
                                WExpr.Assign(trueAcc,
                                    WExpr.StructNew(consIdx,
                                        [h; WExpr.LocalGet(trueAcc, accType)],
                                        listBaseRefT)),
                                WExpr.Assign(falseAcc,
                                    WExpr.StructNew(consIdx,
                                        [h; WExpr.LocalGet(falseAcc, accType)],
                                        listBaseRefT)),
                                WType.Void)))
                    WExpr.Nop None
            // Reverse trueAcc
            let revTrue =
                mkListLoop "part2t" elemT consIdx
                    (WExpr.LocalGet(trueAcc, listBaseRefT))
                    [(trueOut, null_list)]
                    (fun h -> WExpr.Assign(trueOut,
                        WExpr.StructNew(consIdx,
                            [h; WExpr.LocalGet(trueOut, accType)],
                            listBaseRefT)))
                    (WExpr.LocalGet(trueOut, listBaseRefT)) None
            // Reverse falseAcc
            let revFalse =
                mkListLoop "part2f" elemT consIdx
                    (WExpr.LocalGet(falseAcc, listBaseRefT))
                    [(falseOut, null_list)]
                    (fun h -> WExpr.Assign(falseOut,
                        WExpr.StructNew(consIdx,
                            [h; WExpr.LocalGet(falseOut, accType)],
                            listBaseRefT)))
                    (WExpr.LocalGet(falseOut, listBaseRefT)) None
            Some(WExpr.LetMut(trueAcc, null_list,
                WExpr.LetMut(falseAcc, null_list,
                    WExpr.Sequence [
                        buildRevLists
                        WExpr.LetMut(trueOut, null_list,
                            WExpr.LetMut(falseOut, null_list,
                                WExpr.Let("$part_tf", revTrue,
                                    WExpr.Let("$part_ff", revFalse,
                                        WExpr.StructNew(tupleIdx,
                                            [WExpr.LocalGet("$part_tf", listBaseRefT)
                                             WExpr.LocalGet("$part_ff", listBaseRefT)],
                                            tupleRefT)))))
                    ])))
        | None -> None
    | _ -> None

let tryListChooseInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "choose", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match seqElemType listArg.Type with
        | Some inputElemFableType ->
            let outputElemFableType = seqElemType resultFableType |> Option.defaultValue Fable.Type.Any
            match tryListTypeInfo ctx listArg, tryListTypeInfoFromElemType ctx outputElemFableType with
            | Some(inputElemT, inputConsIdx), Some(outputElemT, outputConsIdx) ->
                let wList        = transform ctx listArg
                let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
                let null_list    = WExpr.Const(WConst.Null listBaseRefT)
                let ctx'         = ctx.WithLocal(farg.Name, inputElemT)
                let wBody        = transform ctx' fbody
                // The body returns Option<'b>  — a nullable ref to an option struct
                let wBodyType    = mapTypeKnown ctx fbody.Type
                match wBodyType with
                | WType.Ref(optTypeIdx, _) ->
                    let optNullableT = WType.Ref(optTypeIdx, true)
                    let optNonNullT  = WType.Ref(optTypeIdx, false)
                    // Phase 1: build reversed list of unwrapped Some values
                    let revChosen =
                        mkListLoop "chorev" inputElemT inputConsIdx wList
                            [("$cho_rev_acc", null_list)]
                            (fun h ->
                                WExpr.Let(farg.Name, h,
                                    WExpr.Let("$cho_opt", wBody,
                                        WExpr.If(
                                            WExpr.RefIsNull(WExpr.LocalGet("$cho_opt", optNullableT)),
                                            WExpr.Nop,
                                            WExpr.Assign("$cho_rev_acc",
                                                WExpr.StructNew(outputConsIdx,
                                                    [WExpr.StructGet(
                                                        WExpr.Cast(WExpr.LocalGet("$cho_opt", optNullableT), optNonNullT),
                                                        0, outputElemT);
                                                     WExpr.LocalGet("$cho_rev_acc", listBaseRefT)],
                                                    listBaseRefT)),
                                            WType.Void))))
                            (WExpr.LocalGet("$cho_rev_acc", listBaseRefT)) None
                    // Phase 2: reverse to restore order
                    Some(mkListLoop "cho" outputElemT outputConsIdx revChosen
                            [("$cho_acc", null_list)]
                            (fun h -> WExpr.Assign("$cho_acc",
                                WExpr.StructNew(outputConsIdx,
                                    [h; WExpr.LocalGet("$cho_acc", listBaseRefT)],
                                    listBaseRefT)))
                            (WExpr.LocalGet("$cho_acc", listBaseRefT)) None)
                | _ -> None
            | _ -> None
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List.foldBack, List.sumBy, List.minBy, List.maxBy
// ─────────────────────────────────────────────────────────────────

/// Numeric zero for a WType (mirrors makeZero for arrays; defined here so it
/// is available to list functions that appear before the array section).
let private makeNumericZero (elemT: WType) =
    match elemT with
    | WType.I64 -> WExpr.Const(WConst.I64 0L)
    | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
    | WType.F64 -> WExpr.Const(WConst.F64 0.0)
    | WType.Ref(idx, _) ->
        // For GC reference element types, array.new requires ref.null of the element type.
        WExpr.Const(WConst.Null(WType.Ref(idx, true)))
    | _         -> WExpr.Const(WConst.I32 0)

/// `List.foldBack f list state` — right fold.
/// Implemented as: reverse input, then fold forward (same as foldBack semantics).
let tryListFoldBackInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "foldBack", [(Fable.Expr.Lambda(farg, Fable.Expr.Lambda(sacc, fbody, _), _)
                 | Fable.Expr.Delegate([farg; sacc], fbody, _, _)); listArg; initArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let resultT      = mapTypeKnown ctx resultFableType
            let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
            let null_list    = WExpr.Const(WConst.Null listBaseRefT)
            let wList        = transform ctx listArg
            let wInit        = transform ctx initArg
            let ctx'         = ctx.WithLocal(farg.Name, elemT).WithLocal(sacc.Name, resultT)
            let wBody        = transform ctx' fbody
            // Phase 1: reverse the input list
            let revList =
                mkListLoop "fbrev" elemT consIdx wList
                    [("$fbrev_acc", null_list)]
                    (fun h -> WExpr.Assign("$fbrev_acc",
                        WExpr.StructNew(consIdx,
                            [h; WExpr.LocalGet("$fbrev_acc", listBaseRefT)],
                            listBaseRefT)))
                    (WExpr.LocalGet("$fbrev_acc", listBaseRefT)) None
            // Phase 2: fold forward over reversed list with element first (foldBack semantics)
            Some(mkListLoop "fb" elemT consIdx revList
                    [("$fb_acc", wInit)]
                    (fun h -> WExpr.Assign("$fb_acc",
                        WExpr.Let(farg.Name, h,
                            WExpr.Let(sacc.Name, WExpr.LocalGet("$fb_acc", resultT), wBody))))
                    (WExpr.LocalGet("$fb_acc", resultT)) None)
        | None -> None
    | _ -> None

/// `List.sumBy f list` — sum of projected values.
/// After ReplacementsInject, args end with an adder; we just find the lambda + list.
let tryListSumByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "sumBy", ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let resultT  = mapTypeKnown ctx resultFableType
            let wList    = transform ctx listArg
            let ctx'     = ctx.WithLocal(farg.Name, elemT)
            let wProj    = transform ctx' fbody
            let accVar   = "$sumby_acc"
            Some(mkListLoop "sumby" elemT consIdx wList
                    [(accVar, makeNumericZero resultT)]
                    (fun h -> WExpr.Assign(accVar,
                        WExpr.Binary(WBinaryOp.Add,
                            WExpr.LocalGet(accVar, resultT),
                            WExpr.Let(farg.Name, h, wProj),
                            resultT)))
                    (WExpr.LocalGet(accVar, resultT)) None)
        | None -> None
    | _ -> None

/// `List.minBy f list` / `List.maxBy f list` — element with min/max projected value.
/// After ReplacementsInject, args end with a comparer; we find the lambda + list.
/// Returns the *element* (not the key value).
let tryListMinMaxByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | (("minBy" | "maxBy") as sel),
      ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        let isMin = sel = "minBy"
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let wList    = transform ctx listArg
            let keyT     = mapTypeKnown ctx fbody.Type
            let ctx'     = ctx.WithLocal(farg.Name, elemT)
            let wKey     = transform ctx' fbody
            let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
            // Single pass: track best element and best key
            // Initialise from head; bail if list empty (returns unreachable)
            let listNNRefT  = WType.Ref(consIdx, false)
            let arrVar      = "$mmby_lst"
            let bestElemVar = "$mmby_best_e"
            let bestKeyVar  = "$mmby_best_k"
            let cmpOp       = if isMin then WCompareOp.LtS else WCompareOp.GtS
            let updateIfBetter eVar kVar =
                // WCompareOp.LtS/GtS maps to F64Lt/F64Gt for floats in the emitter — universal
                let cond = WExpr.Compare(cmpOp, WExpr.LocalGet(kVar, keyT), WExpr.LocalGet(bestKeyVar, keyT))
                WExpr.If(cond,
                    WExpr.Sequence [
                        WExpr.Assign(bestElemVar, WExpr.LocalGet(eVar, elemT))
                        WExpr.Assign(bestKeyVar, WExpr.LocalGet(kVar, keyT))
                    ],
                    WExpr.Nop, WType.Void)
            // Get first element + key to initialise
            let listNN   = WExpr.Cast(WExpr.LocalGet(arrVar, listBaseRefT), listNNRefT)
            let headElem = WExpr.StructGet(listNN, 0, elemT)
            let headTail = WExpr.StructGet(listNN, 1, listBaseRefT)
            let initKey  = WExpr.Let(farg.Name, headElem, wKey)
            Some(
                WExpr.Let(arrVar, wList,
                    WExpr.LetMut(bestElemVar, headElem,
                        WExpr.LetMut(bestKeyVar, initKey,
                            WExpr.Sequence [
                                mkListLoop "mmby" elemT consIdx headTail []
                                    (fun h ->
                                        WExpr.Let("$mmby_e", h,
                                            WExpr.Let("$mmby_k", WExpr.Let(farg.Name, WExpr.LocalGet("$mmby_e", elemT), wKey),
                                                updateIfBetter "$mmby_e" "$mmby_k")))
                                    WExpr.Nop None
                                WExpr.LocalGet(bestElemVar, elemT)
                            ]))))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List.init / List.replicate
// ─────────────────────────────────────────────────────────────────

/// `List.init n f` → [f 0; f 1; ...; f (n-1)]
/// `List.replicate n x` → [x; x; ...; x] (n times)
let tryListInitReplicateInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
    let null_list    = WExpr.Const(WConst.Null listBaseRefT)
    match selector, fableArgs with
    // List.init n f — Fable uses selector "initialize" (CompiledName), also accept "init"
    // Guard: result is List or seq/IEnumerable (DeclaredType), not raw Array (handled by tryArrayInline)
    | ("init" | "initialize"), _ when seqElemType resultFableType |> Option.isSome ->
        let tryInitArgs () =
            match fableArgs with
            | [lenArg; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _))]
            | [lenArg; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); _]
            | [_; lenArg; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _))] ->
                Some(lenArg, farg, fbody)
            | _ -> None
        match tryInitArgs () with
        | None -> None
        | Some(nArg, farg, fbody) ->
        let resultElemFableT =
            match seqElemType resultFableType with
            | Some t -> t
            | None   -> fbody.Type
        match tryListTypeInfoFromElemType ctx resultElemFableT with
        | None -> None
        | Some(elemT, consIdx) ->
            let wN        = transform ctx nArg
            let ctx'      = ctx.WithLocal(farg.Name, WType.I32)
            let wBody     = transform ctx' fbody
            let iVar      = "$init_i"
            let accVar    = "$init_acc"
            let loopLabel = "$init_loop"
            // Count DOWN from n-1 to 0, cons f(i) each step → builds list in forward order
            let loopBody =
                WExpr.If(
                    WExpr.Compare(WCompareOp.GeS,
                        WExpr.LocalGet(iVar, WType.I32),
                        WExpr.Const(WConst.I32 0)),
                    WExpr.Sequence [
                        WExpr.Assign(accVar,
                            WExpr.StructNew(consIdx,
                                [WExpr.Let(farg.Name, WExpr.LocalGet(iVar, WType.I32), wBody);
                                 WExpr.LocalGet(accVar, listBaseRefT)],
                                listBaseRefT))
                        WExpr.Assign(iVar,
                            WExpr.Binary(WBinaryOp.Sub,
                                WExpr.LocalGet(iVar, WType.I32),
                                WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(loopLabel, [])
                    ],
                    WExpr.Nop, WType.Void)
            Some(WExpr.LetMut(iVar,
                WExpr.Binary(WBinaryOp.Sub, wN, WExpr.Const(WConst.I32 1), WType.I32),
                WExpr.LetMut(accVar, null_list,
                    WExpr.Sequence [
                        WExpr.Loop(loopLabel, loopBody, WType.Void)
                        WExpr.LocalGet(accVar, listBaseRefT)
                    ])))
    // List.replicate n x — args: [n; x]
    | "replicate", (nArg :: xArg :: _) ->
        match tryListTypeInfoFromElemType ctx xArg.Type with
        | Some(elemT, consIdx) ->
            let wN        = transform ctx nArg
            let wX        = transform ctx xArg
            let iVar      = "$repl_i"
            let nVar      = "$repl_n"
            let accVar    = "$repl_acc"
            let xVar      = "$repl_x"
            let loopLabel = "$repl_loop"
            let loopBody =
                WExpr.If(
                    WExpr.Compare(WCompareOp.LtS,
                        WExpr.LocalGet(iVar, WType.I32),
                        WExpr.LocalGet(nVar, WType.I32)),
                    WExpr.Sequence [
                        WExpr.Assign(accVar,
                            WExpr.StructNew(consIdx,
                                [WExpr.LocalGet(xVar, elemT);
                                 WExpr.LocalGet(accVar, listBaseRefT)],
                                listBaseRefT))
                        WExpr.Assign(iVar,
                            WExpr.Binary(WBinaryOp.Add,
                                WExpr.LocalGet(iVar, WType.I32),
                                WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(loopLabel, [])
                    ],
                    WExpr.Nop, WType.Void)
            Some(WExpr.Let(xVar, wX,
                WExpr.Let(nVar, wN,
                    WExpr.LetMut(iVar, WExpr.Const(WConst.I32 0),
                        WExpr.LetMut(accVar, null_list,
                            WExpr.Sequence [
                                WExpr.Loop(loopLabel, loopBody, WType.Void)
                                WExpr.LocalGet(accVar, listBaseRefT)
                            ])))))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List.unzip  ─ single pass + two reversal passes
// ─────────────────────────────────────────────────────────────────

/// `Seq.pairwise : seq<'a> → seq<'a * 'a>`
/// Forward pass builds a reversed list of (prev,cur) pairs while tracking prev.
/// Reverse pass restores order.
let tryListPairwiseInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "pairwise", [listArg] ->
        let inputElemFT =
            match seqElemType listArg.Type with
            | Some t -> t
            | None   -> Fable.Type.Any
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        // Register the output pair tuple and list types
        let pairFT   = Fable.Type.Tuple([inputElemFT; inputElemFT], false)
        let pairWT   = mapTypeKnown ctx pairFT           // Ref(tupleIdx, false)
        let _        = mapTypeKnown ctx (Fable.Type.List(pairFT))
        match tryListTypeInfoFromElemType ctx pairFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
        let inNNRefT     = WType.Ref(inConsIdx, false)
        let tupleIdx     = match pairWT with | WType.Ref(i, _) -> i | _ -> 0
        let tupleRefT    = WType.Ref(tupleIdx, false)
        let null_list    = WExpr.Const(WConst.Null listBaseRefT)
        let wList        = transform ctx listArg
        let inp  = "$pw_inp"
        let nnin = "$pw_nn"
        let prev = "$pw_prev"
        let acc  = "$pw_acc"
        let it   = "$pw_it"
        let out  = "$pw_out"
        // Forward loop: starting from the TAIL of the input.
        // Body: cons (prev, cur) onto acc; update prev.
        let fwdBody h =
            WExpr.Let(it, h,
                WExpr.Sequence [
                    WExpr.Assign(acc,
                        WExpr.StructNew(outConsIdx,
                            [WExpr.StructNew(tupleIdx,
                                [WExpr.LocalGet(prev, elemWT);
                                 WExpr.LocalGet(it, elemWT)],
                                tupleRefT);
                             WExpr.LocalGet(acc, listBaseRefT)],
                            listBaseRefT))
                    WExpr.Assign(prev, WExpr.LocalGet(it, elemWT))
                ])
        // Reverse the accumulated (reversed) pair list
        let revLoop =
            mkListLoop "pwrev" pairWT outConsIdx
                (WExpr.LocalGet(acc, listBaseRefT))
                [(out, null_list)]
                (fun h -> WExpr.Assign(out,
                    WExpr.StructNew(outConsIdx,
                        [h; WExpr.LocalGet(out, listBaseRefT)],
                        listBaseRefT)))
                (WExpr.LocalGet(out, listBaseRefT)) None
        // Outer structure: null-check input, extract head as prev, walk tail
        let body =
            WExpr.Let(inp, wList,
                WExpr.If(
                    WExpr.RefIsNull(WExpr.LocalGet(inp, listBaseRefT)),
                    null_list,
                    WExpr.Let(nnin, WExpr.Cast(WExpr.LocalGet(inp, listBaseRefT), inNNRefT),
                        WExpr.LetMut(prev,
                            WExpr.StructGet(WExpr.LocalGet(nnin, inNNRefT), 0, elemWT),
                            WExpr.LetMut(acc, null_list,
                                WExpr.Sequence [
                                    mkListLoop "pwfwd" elemWT inConsIdx
                                        (WExpr.StructGet(WExpr.LocalGet(nnin, inNNRefT), 1, listBaseRefT))
                                        [] fwdBody WExpr.Nop None
                                    revLoop
                                ]))),
                    listBaseRefT))
        Some body
    | _ -> None

/// `Seq.countBy : ('a → 'key) → seq<'a> → seq<'key * int>`
/// For I32-compatible keys (bool, int): uses parallel I32 arrays to accumulate counts.
/// Returns a list of (key, count) in first-occurrence order.
let tryListCountByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "countBy", ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        // Only handle I32 key types (bool, int, enum, char)
        let keyWT = mapTypeKnown ctx fbody.Type
        if keyWT <> WType.I32 then None
        else
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        // Output pair type: (key * int)
        let intFT  = Fable.Type.Number(NumberKind.Int32, NumberInfo.Empty)
        let pairFT = Fable.Type.Tuple([fbody.Type; intFT], false)
        let pairWT = mapTypeKnown ctx pairFT
        let _      = mapTypeKnown ctx (Fable.Type.List(pairFT))
        match tryListTypeInfoFromElemType ctx pairFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
        let null_list    = WExpr.Const(WConst.Null listBaseRefT)
        let tupleIdx     = match pairWT with | WType.Ref(i, _) -> i | _ -> 0
        let tupleRefT    = WType.Ref(tupleIdx, false)
        let zero32       = WExpr.Const(WConst.I32 0)
        let one32        = WExpr.Const(WConst.I32 1)
        let capacity     = 64
        let i32ArrIdx    = getOrAddArrayType ctx WType.I32
        let i32ArrRefT   = WType.Ref(i32ArrIdx, false)
        let keysVar = "$cntb_keys"
        let cntsVar = "$cntb_cnts"
        let nVar    = "$cntb_n"
        let kVar    = "$cntb_k"
        let iVar    = "$cntb_i"
        let outVar  = "$cntb_out"
        let wList   = transform ctx listArg
        let ctx'    = ctx.WithLocal(farg.Name, elemWT)
        let kGet    = WExpr.LocalGet(kVar, WType.I32)
        let nGet    = WExpr.LocalGet(nVar, WType.I32)
        let iGet    = WExpr.LocalGet(iVar, WType.I32)
        let keysGet = WExpr.LocalGet(keysVar, i32ArrRefT)
        let cntsGet = WExpr.LocalGet(cntsVar, i32ArrRefT)
        // Inner scan loop: search keys[0..n-1] for k
        let scanLoop =
            WExpr.Sequence [
                WExpr.Assign(iVar, zero32)
                WExpr.Loop("$cntb_scan",
                    WExpr.If(
                        WExpr.Compare(WCompareOp.LtS, iGet, nGet),
                        WExpr.If(
                            WExpr.Compare(WCompareOp.Eq, WExpr.ArrayGet(keysGet, iGet, WType.I32), kGet),
                            // Found at i: increment, done
                            WExpr.ArraySet(cntsGet, iGet,
                                WExpr.Binary(WBinaryOp.Add, WExpr.ArrayGet(cntsGet, iGet, WType.I32), one32, WType.I32)),
                            // Not found at i: i++, continue
                            WExpr.Sequence [
                                WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, one32, WType.I32))
                                WExpr.Continue("$cntb_scan", [])
                            ],
                            WType.Void),
                        // i >= n: add new entry
                        WExpr.Sequence [
                            WExpr.ArraySet(keysGet, nGet, kGet)
                            WExpr.ArraySet(cntsGet, nGet, one32)
                            WExpr.Assign(nVar, WExpr.Binary(WBinaryOp.Add, nGet, one32, WType.I32))
                        ],
                        WType.Void),
                    WType.Void)
            ]
        // Forward walk over input: compute key, scan/update
        let fwdLoop =
            mkListLoop "cntbfwd" elemWT inConsIdx wList []
                (fun h ->
                    WExpr.Sequence [
                        WExpr.Assign(kVar, WExpr.Let(farg.Name, h, transform ctx' fbody))
                        scanLoop
                    ])
                WExpr.Nop None
        // Build result list in first-occurrence order:
        // Walk i from n-1 down to 0, consing (keys[i], cnts[i]) pairs
        let buildResult =
            WExpr.LetMut(iVar,
                WExpr.Binary(WBinaryOp.Sub, nGet, one32, WType.I32),
                WExpr.LetMut(outVar, null_list,
                    WExpr.Sequence [
                        WExpr.Loop("$cntb_build",
                            WExpr.If(
                                WExpr.Compare(WCompareOp.GeS, iGet, zero32),
                                WExpr.Sequence [
                                    WExpr.Assign(outVar,
                                        WExpr.StructNew(outConsIdx,
                                            [WExpr.StructNew(tupleIdx,
                                                [WExpr.ArrayGet(keysGet, iGet, WType.I32);
                                                 WExpr.ArrayGet(cntsGet, iGet, WType.I32)],
                                                tupleRefT);
                                             WExpr.LocalGet(outVar, listBaseRefT)],
                                            listBaseRefT))
                                    WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Sub, iGet, one32, WType.I32))
                                    WExpr.Continue("$cntb_build", [])
                                ],
                                WExpr.Nop, WType.Void),
                            WType.Void)
                        WExpr.LocalGet(outVar, listBaseRefT)
                    ]))
        let body =
            WExpr.Let(keysVar,
                WExpr.ArrayNew(i32ArrIdx, WExpr.Const(WConst.I32 capacity), zero32, i32ArrRefT),
                WExpr.Let(cntsVar,
                    WExpr.ArrayNew(i32ArrIdx, WExpr.Const(WConst.I32 capacity), zero32, i32ArrRefT),
                    WExpr.LetMut(nVar, zero32,
                        WExpr.LetMut(kVar, zero32,
                            WExpr.Sequence [fwdLoop; buildResult]))))
        Some body
    | _ -> None

/// `List.unzip : ('a * 'b) list → 'a list * 'b list`
/// Single forward pass builds reversed acc lists; two reversal passes restore order.
let tryListUnzipInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "unzip", [listArg] ->
        // Element of the input list must be a tuple with exactly 2 fields.
        let inputElemFT = seqElemType listArg.Type
        match inputElemFT with
        | Some(Fable.Type.Tuple([ta; tb], _)) ->
            match tryListTypeInfo ctx listArg,
                  tryListTypeInfoFromElemType ctx ta,
                  tryListTypeInfoFromElemType ctx tb with
            | Some(pairT, pairConsIdx),
              Some(aElemT, aConsIdx),
              Some(bElemT, bConsIdx) ->
                let wList = transform ctx listArg
                let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
                let null_list = WExpr.Const(WConst.Null listBaseRefT)
                // Register the output tuple type (List<ta>, List<tb>).
                let listAWT = mapTypeKnown ctx (Fable.Type.List(ta))
                let listBWT = mapTypeKnown ctx (Fable.Type.List(tb))
                let _ = mapTypeKnown ctx (Fable.Type.Tuple([Fable.Type.List(ta); Fable.Type.List(tb)], false))
                let tupleKey = wTypesKey [listAWT; listBWT]
                match ctx.TupleRegistry.TryGetValue(tupleKey) with
                | false, _ -> None  // shouldn't happen after mapTypeKnown above
                | true, resultTupleIdx ->
                let pairNNRefT    = WType.Ref(pairConsIdx, false)
                let resultTupleRefT = WType.Ref(resultTupleIdx, false)
                let aRevAcc = "$unz_ar"
                let bRevAcc = "$unz_br"
                // Forward pass: build reversed acc lists from pairs.
                let fwdLoop =
                    mkListLoop "unzfwd" pairT pairConsIdx wList []
                        (fun h ->
                            WExpr.Let("$unz_h", h,
                                WExpr.Sequence [
                                    WExpr.Assign(aRevAcc,
                                        WExpr.StructNew(aConsIdx,
                                            [WExpr.StructGet(WExpr.LocalGet("$unz_h", pairT), 0, aElemT);
                                             WExpr.LocalGet(aRevAcc, listBaseRefT)],
                                            listBaseRefT))
                                    WExpr.Assign(bRevAcc,
                                        WExpr.StructNew(bConsIdx,
                                            [WExpr.StructGet(WExpr.LocalGet("$unz_h", pairT), 1, bElemT);
                                             WExpr.LocalGet(bRevAcc, listBaseRefT)],
                                            listBaseRefT))
                                ]))
                        WExpr.Nop None
                // Reversal pass for the 'a list.
                let revA =
                    mkListLoop "unzra" aElemT aConsIdx
                        (WExpr.LocalGet(aRevAcc, listBaseRefT))
                        [("$unz_ao", null_list)]
                        (fun h -> WExpr.Assign("$unz_ao",
                            WExpr.StructNew(aConsIdx,
                                [h; WExpr.LocalGet("$unz_ao", listBaseRefT)],
                                listBaseRefT)))
                        (WExpr.LocalGet("$unz_ao", listBaseRefT)) None
                // Reversal pass for the 'b list.
                let revB =
                    mkListLoop "unzrb" bElemT bConsIdx
                        (WExpr.LocalGet(bRevAcc, listBaseRefT))
                        [("$unz_bo", null_list)]
                        (fun h -> WExpr.Assign("$unz_bo",
                            WExpr.StructNew(bConsIdx,
                                [h; WExpr.LocalGet("$unz_bo", listBaseRefT)],
                                listBaseRefT)))
                        (WExpr.LocalGet("$unz_bo", listBaseRefT)) None
                Some(WExpr.LetMut(aRevAcc, null_list,
                    WExpr.LetMut(bRevAcc, null_list,
                        WExpr.Sequence [
                            fwdLoop
                            WExpr.StructNew(resultTupleIdx, [revA; revB], resultTupleRefT)
                        ])))
            | _ -> None
        | _ -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List.take / List.skip / List.sort
// ─────────────────────────────────────────────────────────────────

/// `List.skip n xs` → drop first n elements; returns tail from position n.
/// `List.take n xs` → first n elements as a new list.
/// `List.sort xs` / `List.sortDescending xs` → sorted list via list→array→sort→list.
