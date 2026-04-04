/// WasmGC inline replacements for Array operations.
/// Covers typed arrays: create, init, fill, copy, map, filter, fold, iter,
/// exists, forAll, sort, sortWith, sortBy, reverse, concat, choose,
/// collect, zip, unzip, head/tail/take/skip/splitAt, and instance-method HOFs.
module Fable.Transforms.WasmGc.WasmGcArrayReplacements

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder
open Fable.Transforms.WasmGc.WasmGcRuntime
open Fable.Transforms.WasmGc.WasmGcLoopHelpers
open Fable.Transforms.WasmGc.WasmGcLoopCombinators

// ─────────────────────────────────────────────────────────────────
// Array higher-order functions
// ─────────────────────────────────────────────────────────────────

let private getArrElemT (ftyp: Fable.Type) =
    match ftyp with | Fable.Type.Array(t, _) -> Some t | _ -> None

let private makeZero (elemT: WType) =
    match elemT with
    | WType.I64 -> WExpr.Const(WConst.I64 0L)
    | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
    | WType.F64 -> WExpr.Const(WConst.F64 0.0)
    | _ -> WExpr.Const(WConst.I32 0)

let tryArrayInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (wArgs: WExpr list)
        (resultFableType: Fable.Type) : WExpr option =
    let ty = mapTypeKnown ctx resultFableType
    match selector with
    // Array.create n initVal
    | "create" ->
        match getArrElemT resultFableType, wArgs with
        | Some elemFableT, [wSize; wInit] ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            Some(WExpr.ArrayNew(arrTypeIdx, wSize, wInit, WType.Ref(arrTypeIdx, false)))
        | _ -> None
    // Array.zeroCreate n
    | "zeroCreate" ->
        match getArrElemT resultFableType, wArgs with
        | Some elemFableT, [wSize] ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            Some(WExpr.ArrayNew(arrTypeIdx, wSize, makeZero elemT, WType.Ref(arrTypeIdx, false)))
        | _ -> None
    // Array.length
    | "length" ->
        match fableArgs with
        | [arrArg] when getArrElemT arrArg.Type |> Option.isSome ->
            Some(WExpr.ArrayLen(List.head wArgs))
        | _ -> None
    // Array.get / Array.item
    | ("get" | "item") ->
        let arrFableArg, arrWArgIdx, idxWArgIdx =
            match fableArgs with
            | [a; _] when getArrElemT a.Type |> Option.isSome -> a, 0, 1
            | [_; a] when getArrElemT a.Type |> Option.isSome -> a, 1, 0
            | _ -> List.head fableArgs, 0, 1
        match getArrElemT arrFableArg.Type, wArgs with
        | Some elemFableT, [w0; w1] ->
            let elemT = mapTypeKnown ctx elemFableT
            let wArr = if arrWArgIdx = 0 then w0 else w1
            let wIdx = if idxWArgIdx = 0 then w0 else w1
            Some(WExpr.ArrayGet(wArr, wIdx, elemT))
        | _ -> None
    // Array.set
    | "set" ->
        match fableArgs with
        | [arrArg; _; _] when getArrElemT arrArg.Type |> Option.isSome ->
            match wArgs with
            | [wArr; wIdx; wVal] -> Some(WExpr.ArraySet(wArr, wIdx, wVal))
            | _ -> None
        | _ -> None
    // Array.copy
    | "copy" ->
        match fableArgs with
        | [arrArg] ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRef = WType.Ref(arrTypeIdx, false)
                let wSrc = List.head wArgs
                let tmp = "$arrcopy_dst"
                Some(WExpr.Let(tmp, WExpr.ArrayNew(arrTypeIdx, WExpr.ArrayLen(wSrc), makeZero elemT, arrRef),
                    WExpr.Sequence [
                        WExpr.ArrayCopy(WExpr.LocalGet(tmp, arrRef), WExpr.Const(WConst.I32 0),
                            wSrc, WExpr.Const(WConst.I32 0), WExpr.ArrayLen(wSrc))
                        WExpr.LocalGet(tmp, arrRef)
                    ]))
            | None -> None
        | _ -> None
    // Array.fill
    | "fill" ->
        match getArrElemT resultFableType with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let arrRefT = WType.Ref(arrTypeIdx, false)
            match wArgs with
            | [_; _; wCount; wValue] -> Some(WExpr.ArrayNew(arrTypeIdx, wCount, wValue, arrRefT))
            | [_; wCount; wValue]    -> Some(WExpr.ArrayNew(arrTypeIdx, wCount, wValue, arrRefT))
            | [wCount; wValue]       -> Some(WExpr.ArrayNew(arrTypeIdx, wCount, wValue, arrRefT))
            | _ -> None
        | None ->
            match fableArgs, wArgs with
            | [arrArg; _; _; _], [wArr; wStart; wCount; wVal]
                  when getArrElemT arrArg.Type |> Option.isSome ->
                let iVar = "$fill_i"
                let limVar = "$fill_end"
                let lbl = "$fill_loop"
                let iGet = WExpr.LocalGet(iVar, WType.I32)
                Some(WExpr.LetMut(iVar, wStart,
                    WExpr.LetMut(limVar,
                        WExpr.Binary(WBinaryOp.Add, wStart, wCount, WType.I32),
                        WExpr.Loop(lbl,
                            WExpr.If(
                                WExpr.Compare(WCompareOp.LtS, iGet, WExpr.LocalGet(limVar, WType.I32)),
                                WExpr.Sequence [
                                    WExpr.ArraySet(wArr, iGet, wVal)
                                    WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                                    WExpr.Continue(lbl, [])
                                ],
                                WExpr.Nop, WType.Void),
                            WType.Void))))
            | _ -> None
    // Array.iter / iterate
    | ("iter" | "iterate") ->
        let tryLambdaAndArr () =
            match fableArgs with
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg; _]
            | [_; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg] ->
                Some(farg, fbody, arrArg)
            | _ -> None
        match tryLambdaAndArr () with
        | Some(farg, fbody, arrArg) ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(mkArrayLoop "aiter" elemT arrTypeIdx wArr []
                        (fun elem _idx -> WExpr.Let(farg.Name, elem, wBody))
                        WExpr.Nop None)
            | None -> None
        | None -> None
    // Array.iteri / iterateIndexed
    | ("iteri" | "iterateIndexed") ->
        let tryIdxLambdaAndArr () =
            match fableArgs with
            | [(Fable.Expr.Lambda(fidx, Fable.Expr.Lambda(farg, fbody, _), _)
               | Fable.Expr.Delegate([fidx; farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(fidx, Fable.Expr.Lambda(farg, fbody, _), _)
               | Fable.Expr.Delegate([fidx; farg], fbody, _, _)); arrArg; _]
            | [_; (Fable.Expr.Lambda(fidx, Fable.Expr.Lambda(farg, fbody, _), _)
                  | Fable.Expr.Delegate([fidx; farg], fbody, _, _)); arrArg] ->
                Some(fidx, farg, fbody, arrArg)
            | _ -> None
        match tryIdxLambdaAndArr () with
        | Some(fidx, farg, fbody, arrArg) ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(fidx.Name, WType.I32).WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(mkArrayLoop "aiteri" elemT arrTypeIdx wArr []
                        (fun elem idx ->
                            WExpr.Let(fidx.Name, idx, WExpr.Let(farg.Name, elem, wBody)))
                        WExpr.Nop None)
            | None -> None
        | None -> None
    // Array.map
    | "map" ->
        let tryMapArgs () =
            match fableArgs with
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg; _]
            | [_; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg] ->
                Some(farg, fbody, arrArg)
            | _ -> None
        match tryMapArgs () with
        | Some(farg, fbody, arrArg) ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let resultFableT = match resultFableType with | Fable.Type.Array(t,_) -> t | _ -> elemFableT
                let resultElemT = mapTypeKnown ctx resultFableT
                let resultArrIdx = getOrAddArrayType ctx resultElemT
                let resultArrRefT = WType.Ref(resultArrIdx, false)
                let srcVar = "$amap_src"
                let resVar = "$amap_res"
                let srcRefT = WType.Ref(arrTypeIdx, false)
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(WExpr.Let(srcVar, wArr,
                    WExpr.Let(resVar,
                        WExpr.ArrayNew(resultArrIdx, WExpr.ArrayLen(WExpr.LocalGet(srcVar, srcRefT)), makeZero resultElemT, resultArrRefT),
                        mkArrayLoop "amap" elemT arrTypeIdx (WExpr.LocalGet(srcVar, srcRefT)) []
                            (fun elem idx ->
                                WExpr.Let(farg.Name, elem,
                                    WExpr.ArraySet(WExpr.LocalGet(resVar, resultArrRefT), idx, wBody)))
                            (WExpr.LocalGet(resVar, resultArrRefT)) None)))
            | None -> None
        | None -> None
    // Array.mapi / mapIndexed
    | ("mapi" | "mapIndexed") ->
        let tryMapiArgs () =
            match fableArgs with
            | [(Fable.Expr.Lambda(fidx, Fable.Expr.Lambda(farg, fbody, _), _)
               | Fable.Expr.Delegate([fidx; farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(fidx, Fable.Expr.Lambda(farg, fbody, _), _)
               | Fable.Expr.Delegate([fidx; farg], fbody, _, _)); arrArg; _]
            | [_; (Fable.Expr.Lambda(fidx, Fable.Expr.Lambda(farg, fbody, _), _)
                  | Fable.Expr.Delegate([fidx; farg], fbody, _, _)); arrArg] ->
                Some(fidx, farg, fbody, arrArg)
            | _ -> None
        match tryMapiArgs () with
        | Some(fidx, farg, fbody, arrArg) ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let resultFableT = match resultFableType with | Fable.Type.Array(t,_) -> t | _ -> elemFableT
                let resultElemT = mapTypeKnown ctx resultFableT
                let resultArrIdx = getOrAddArrayType ctx resultElemT
                let resultArrRefT = WType.Ref(resultArrIdx, false)
                let srcVar = "$amapi_src"
                let resVar = "$amapi_res"
                let srcRefT = WType.Ref(arrTypeIdx, false)
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(fidx.Name, WType.I32).WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(WExpr.Let(srcVar, wArr,
                    WExpr.Let(resVar,
                        WExpr.ArrayNew(resultArrIdx, WExpr.ArrayLen(WExpr.LocalGet(srcVar, srcRefT)), makeZero resultElemT, resultArrRefT),
                        mkArrayLoop "amapi" elemT arrTypeIdx (WExpr.LocalGet(srcVar, srcRefT)) []
                            (fun elem idx ->
                                WExpr.Let(fidx.Name, idx,
                                    WExpr.Let(farg.Name, elem,
                                        WExpr.ArraySet(WExpr.LocalGet(resVar, resultArrRefT), idx, wBody))))
                            (WExpr.LocalGet(resVar, resultArrRefT)) None)))
            | None -> None
        | None -> None
    // Array.fold
    | "fold" ->
        match fableArgs with
        | [Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _); initArg; arrArg]
        | [Fable.Expr.Delegate([farg1; farg2], fbody, _, _); initArg; arrArg]
        | [_; Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _); initArg; arrArg]
        | [_; Fable.Expr.Delegate([farg1; farg2], fbody, _, _); initArg; arrArg] ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let wArr = List.last wArgs
                let wInit = transform ctx initArg
                let accT = mapTypeKnown ctx initArg.Type
                let ctx' = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
                let wBody = transform ctx' fbody
                Some(mkArrayLoop "afold" elemT arrTypeIdx wArr
                        [(farg1.Name, wInit)]
                        (fun elem _idx -> WExpr.Assign(farg1.Name, WExpr.Let(farg2.Name, elem, wBody)))
                        (WExpr.LocalGet(farg1.Name, accT)) None)
            | None -> None
        | _ -> None
    // Array.exists / Array.forAll
    | ("exists" | "forAll") ->
        let sel = selector
        let tryPredAndArr () =
            match fableArgs with
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg; _]
            | [_; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg] ->
                Some(farg, fbody, arrArg)
            | _ -> None
        match tryPredAndArr () with
        | Some(farg, fbody, arrArg) ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wPred = transform ctx' fbody
                let (breakVal, fallback) =
                    if sel = "exists"
                    then WExpr.Const(WConst.I32 1), WExpr.Const(WConst.I32 0)
                    else WExpr.Const(WConst.I32 0), WExpr.Const(WConst.I32 1)
                let checkExpr =
                    if sel = "exists" then wPred
                    else WExpr.Unary(WUnaryOp.Eqz, wPred, WType.I32)
                Some(mkArrayLoop "aexi" elemT arrTypeIdx wArr []
                        (fun elem _idx ->
                            WExpr.Let(farg.Name, elem,
                                WExpr.If(checkExpr,
                                    WExpr.Break("$aexi_exit", Some breakVal),
                                    WExpr.Nop, WType.Void)))
                        fallback (Some("$aexi_exit", WType.I32)))
            | None -> None
        | None -> None
    // Array.filter
    | "filter" ->
        let tryPredAndArr () =
            match fableArgs with
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg; _]
            | [_; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg] ->
                Some(farg, fbody, arrArg)
            | _ -> None
        match tryPredAndArr () with
        | Some(farg, fbody, arrArg) ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT = WType.Ref(arrTypeIdx, false)
                let wArr = transform ctx arrArg
                let srcVar = "$afilt_src"
                let cntVar = "$afilt_cnt"
                let resVar = "$afilt_res"
                let widxVar = "$afilt_widx"
                let srcGet = WExpr.LocalGet(srcVar, arrRefT)
                let resGet = WExpr.LocalGet(resVar, arrRefT)
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wPred = transform ctx' fbody
                let countLoop =
                    mkArrayLoop "afiltcnt" elemT arrTypeIdx srcGet
                        [(cntVar, WExpr.Const(WConst.I32 0))]
                        (fun elem _idx ->
                            WExpr.Let(farg.Name, elem,
                                WExpr.If(wPred,
                                    WExpr.Assign(cntVar, WExpr.Binary(WBinaryOp.Add,
                                        WExpr.LocalGet(cntVar, WType.I32),
                                        WExpr.Const(WConst.I32 1), WType.I32)),
                                    WExpr.Nop, WType.Void)))
                        (WExpr.LocalGet(cntVar, WType.I32)) None
                let fillLoop =
                    mkArrayLoop "afiltfil" elemT arrTypeIdx srcGet
                        [(widxVar, WExpr.Const(WConst.I32 0))]
                        (fun elem _idx ->
                            WExpr.Let(farg.Name, elem,
                                WExpr.If(wPred,
                                    WExpr.Sequence [
                                        WExpr.ArraySet(resGet, WExpr.LocalGet(widxVar, WType.I32), WExpr.LocalGet(farg.Name, elemT))
                                        WExpr.Assign(widxVar, WExpr.Binary(WBinaryOp.Add,
                                            WExpr.LocalGet(widxVar, WType.I32),
                                            WExpr.Const(WConst.I32 1), WType.I32))
                                    ],
                                    WExpr.Nop, WType.Void)))
                        resGet None
                Some(WExpr.Let(srcVar, wArr,
                    WExpr.Let("$afilt_count", countLoop,
                        WExpr.Let(resVar,
                            WExpr.ArrayNew(arrTypeIdx,
                                WExpr.LocalGet("$afilt_count", WType.I32),
                                makeZero elemT, arrRefT),
                            fillLoop))))
            | None -> None
        | None -> None
    // Array.init / initialize (List.init handled by tryListInitReplicateInline when result is List)
    | ("init" | "initialize") ->
        let tryInitArgs () =
            match fableArgs with
            | [lenArg; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _))]
            | [lenArg; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); _]
            | [_; lenArg; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _))] ->
                Some(lenArg, farg, fbody)
            | _ -> None
        match tryInitArgs () with
        | Some(lenArg, farg, fbody) ->
            let wLen = transform ctx lenArg
            let resultFableT = match resultFableType with | Fable.Type.Array(t,_) -> t | _ -> Fable.Type.Any
            let resultElemT = mapTypeKnown ctx resultFableT
            let resultArrIdx = getOrAddArrayType ctx resultElemT
            let resultArrRefT = WType.Ref(resultArrIdx, false)
            let resVar = "$ainit_res"
            let ctx' = ctx.WithLocal(farg.Name, WType.I32)
            let wBody = transform ctx' fbody
            Some(WExpr.Let(resVar,
                WExpr.ArrayNew(resultArrIdx, wLen, makeZero resultElemT, resultArrRefT),
                mkArrayLoop "ainit" resultElemT resultArrIdx (WExpr.LocalGet(resVar, resultArrRefT)) []
                    (fun _elem idx ->
                        WExpr.Let(farg.Name, idx,
                            WExpr.ArraySet(WExpr.LocalGet(resVar, resultArrRefT), idx, wBody)))
                    (WExpr.LocalGet(resVar, resultArrRefT)) None))
        | None -> None
    // ── Array.reduce f arr — fold from first element as accumulator ──
    | "reduce" | "reduceBack" ->
        match fableArgs with
        | [Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _); arrArg]
        | [Fable.Expr.Delegate([farg1; farg2], fbody, _, _); arrArg] ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT    = WType.Ref(arrTypeIdx, false)
                let wArr       = transform ctx arrArg
                let arrVar     = "$ared_arr"
                let accVar     = "$ared_acc"
                let iVar       = "$ared_i"
                let lenVar     = "$ared_len"
                let loopLabel  = "$ared_loop"
                let arrGet     = WExpr.LocalGet(arrVar, arrRefT)
                let accGet     = WExpr.LocalGet(accVar, elemT)
                let iGet       = WExpr.LocalGet(iVar, WType.I32)
                let lenGet     = WExpr.LocalGet(lenVar, WType.I32)
                let ctx'       = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
                let wBody      = transform ctx' fbody
                let elem       = WExpr.ArrayGet(arrGet, iGet, elemT)
                let step =
                    WExpr.Sequence [
                        WExpr.Assign(accVar,
                            WExpr.Let(farg1.Name, accGet,
                                WExpr.Let(farg2.Name, elem, wBody)))
                        WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(loopLabel, [])
                    ]
                let loop = WExpr.Loop(loopLabel,
                    WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet), step, WExpr.Nop, WType.Void),
                    WType.Void)
                Some(WExpr.Let(arrVar, wArr,
                    WExpr.Let(lenVar, WExpr.ArrayLen(arrGet),
                        WExpr.LetMut(accVar, WExpr.ArrayGet(arrGet, WExpr.Const(WConst.I32 0), elemT),
                            WExpr.LetMut(iVar, WExpr.Const(WConst.I32 1),
                                WExpr.Sequence [loop; accGet])))))
            | None -> None
        | _ -> None
    // ── Array.sum arr — fold with additive zero ──
    // After ReplacementsInject, args are [arr; adder] (adder appended last)
    | "sum" | "sumBy" ->
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> getArrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | Some arrArg ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let wArr       = transform ctx arrArg
                let accVar     = "$asum_acc"
                let accGet     = WExpr.LocalGet(accVar, elemT)
                Some(mkArrayLoop "asum" elemT arrTypeIdx wArr
                        [(accVar, makeZero elemT)]
                        (fun elem _idx ->
                            WExpr.Assign(accVar, WExpr.Binary(WBinaryOp.Add, accGet, elem, elemT)))
                        accGet None)
            | None -> None
        | None -> None
    // ── Array.min / Array.max — fold from first element, keep extreme ──
    // After ReplacementsInject, args are [arr; comparer] (comparer appended last)
    | "min" | "minBy" | "max" | "maxBy" ->
        let isMin = (match selector with | "min" | "minBy" -> true | _ -> false)
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> getArrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | Some arrArg ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT    = WType.Ref(arrTypeIdx, false)
                let wArr       = transform ctx arrArg
                let arrVar     = "$aminmax_arr"
                let accVar     = "$aminmax_acc"
                let iVar       = "$aminmax_i"
                let lenVar     = "$aminmax_len"
                let loopLabel  = "$aminmax_loop"
                let arrGet     = WExpr.LocalGet(arrVar, arrRefT)
                let accGet     = WExpr.LocalGet(accVar, elemT)
                let iGet       = WExpr.LocalGet(iVar, WType.I32)
                let lenGet     = WExpr.LocalGet(lenVar, WType.I32)
                let elem       = WExpr.ArrayGet(arrGet, iGet, elemT)
                let cmpOp      = if isMin then WCompareOp.LtS else WCompareOp.GtS
                // For floats use f64.min/f64.max; for integers use compare+select
                let updateAcc eVar =
                    match elemT with
                    | WType.F64 | WType.F32 ->
                        let bop = if isMin then WBinaryOp.Min else WBinaryOp.Max
                        WExpr.Assign(accVar, WExpr.Binary(bop, accGet, eVar, elemT))
                    | _ ->
                        WExpr.Assign(accVar,
                            WExpr.If(WExpr.Compare(cmpOp, eVar, accGet), eVar, accGet, elemT))
                let step =
                    WExpr.Sequence [
                        WExpr.Let("$aminmax_e", elem, updateAcc (WExpr.LocalGet("$aminmax_e", elemT)))
                        WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(loopLabel, [])
                    ]
                let loop = WExpr.Loop(loopLabel,
                    WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet), step, WExpr.Nop, WType.Void),
                    WType.Void)
                Some(WExpr.Let(arrVar, wArr,
                    WExpr.Let(lenVar, WExpr.ArrayLen(arrGet),
                        WExpr.LetMut(accVar, WExpr.ArrayGet(arrGet, WExpr.Const(WConst.I32 0), elemT),
                            WExpr.LetMut(iVar, WExpr.Const(WConst.I32 1),
                                WExpr.Sequence [loop; accGet])))))
            | None -> None
        | None -> None
    // ── Array.rev arr — new array with elements in reverse order ──
    // No injection for rev, fableArgs = [arr]
    | "rev" | "reverse" ->
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> getArrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | Some arrArg ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT    = WType.Ref(arrTypeIdx, false)
                let wArr       = transform ctx arrArg
                let srcVar     = "$arv_src"
                let resVar     = "$arv_res"
                let lenVar     = "$arv_len"
                let iVar       = "$arv_i"
                let loopLabel  = "$arv_loop"
                let srcGet     = WExpr.LocalGet(srcVar, arrRefT)
                let resGet     = WExpr.LocalGet(resVar, arrRefT)
                let lenGet     = WExpr.LocalGet(lenVar, WType.I32)
                let iGet       = WExpr.LocalGet(iVar, WType.I32)
                let revIdx =
                    WExpr.Binary(WBinaryOp.Sub,
                        WExpr.Binary(WBinaryOp.Sub, lenGet, WExpr.Const(WConst.I32 1), WType.I32),
                        iGet, WType.I32)
                let step =
                    WExpr.Sequence [
                        WExpr.ArraySet(resGet, iGet, WExpr.ArrayGet(srcGet, revIdx, elemT))
                        WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(loopLabel, [])
                    ]
                let loop = WExpr.Loop(loopLabel,
                    WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet), step, WExpr.Nop, WType.Void),
                    WType.Void)
                Some(WExpr.Let(srcVar, wArr,
                    WExpr.Let(lenVar, WExpr.ArrayLen(srcGet),
                        WExpr.Let(resVar, WExpr.ArrayNew(arrTypeIdx, lenGet, makeZero elemT, arrRefT),
                            WExpr.LetMut(iVar, WExpr.Const(WConst.I32 0),
                                WExpr.Sequence [loop; resGet])))))
            | None -> None
        | None -> None
    // ── Array.zip arr1 arr2 — parallel arrays → array of pairs ──
    | "zip" ->
        match fableArgs with
        | (arr1Arg :: arr2Arg :: _) ->
            match getArrElemT arr1Arg.Type, getArrElemT arr2Arg.Type with
            | Some e1FT, Some e2FT ->
                let e1T = mapTypeKnown ctx e1FT
                let e2T = mapTypeKnown ctx e2FT
                let tupleFableT = Fable.Type.Tuple([e1FT; e2FT], false)
                let tupleWType  = mapTypeKnown ctx tupleFableT
                let tupleIdx =
                    let key = wTypesKey [e1T; e2T]
                    match ctx.TupleRegistry.TryGetValue(key) with
                    | true, idx -> idx
                    | _ -> failwith "tuple not registered after mapTypeKnown"
                let tupleRefT   = WType.Ref(tupleIdx, false)
                // For array.new we need a non-null default for non-nullable ref elements.
                // Create a dummy zero-field tuple struct as the default value.
                let rec makeWZero (wt: WType) : WExpr =
                    match wt with
                    | WType.I64 -> WExpr.Const(WConst.I64 0L)
                    | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
                    | WType.F64 -> WExpr.Const(WConst.F64 0.0)
                    | WType.Ref(idx, true) -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                    | WType.Ref(idx, false) ->
                        match ctx.TypeDefs.[idx].Def with
                        | WTypeDef.Struct(fields, _) ->
                            WExpr.StructNew(idx, fields |> List.map (fun f -> makeWZero f.Type), WType.Ref(idx, false))
                        | _ -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                    | _ -> WExpr.Const(WConst.I32 0)
                let tupleDefault = makeWZero tupleRefT
                let resArrIdx   = getOrAddArrayType ctx tupleRefT
                let resArrRefT  = WType.Ref(resArrIdx, false)
                let wArr1 = transform ctx arr1Arg
                let wArr2 = transform ctx arr2Arg
                let a1Var = "$azip_a1"
                let a2Var = "$azip_a2"
                let resVar = "$azip_res"
                let a1Get = WExpr.LocalGet(a1Var, WType.Ref(getOrAddArrayType ctx e1T, false))
                let a2Get = WExpr.LocalGet(a2Var, WType.Ref(getOrAddArrayType ctx e2T, false))
                let resGet = WExpr.LocalGet(resVar, resArrRefT)
                let len = WExpr.ArrayLen(a1Get)
                Some(WExpr.Let(a1Var, wArr1,
                    WExpr.Let(a2Var, wArr2,
                        WExpr.Let(resVar,
                            WExpr.ArrayNew(resArrIdx, len, tupleDefault, resArrRefT),
                            mkArrayLoop "azip" tupleRefT resArrIdx resGet []
                                (fun _elem idx ->
                                    WExpr.ArraySet(resGet, idx,
                                        WExpr.StructNew(tupleIdx,
                                            [WExpr.ArrayGet(a1Get, idx, e1T)
                                             WExpr.ArrayGet(a2Get, idx, e2T)],
                                            tupleRefT)))
                                resGet None))))
            | _ -> None
        | _ -> None
    // ── Array.map2 f arr1 arr2 — apply f to each pair, collecting results ──
    | "map2" ->
        match fableArgs with
        | (cmpArg :: arr1Arg :: arr2Arg :: _) ->
            let cmpParts =
                match cmpArg with
                | Fable.Expr.Lambda(a1, Fable.Expr.Lambda(a2, body, _), _) -> Some(a1, a2, body)
                | Fable.Expr.Lambda(a1, Fable.Expr.Delegate([a2], body, _, _), _) -> Some(a1, a2, body)
                | Fable.Expr.Delegate([a1; a2], body, _, _) -> Some(a1, a2, body)
                | Fable.Expr.Delegate([a1], Fable.Expr.Lambda(a2, body, _), _, _) -> Some(a1, a2, body)
                | _ -> None
            match cmpParts with
            | None -> None
            | Some(farg1, farg2, fbody) ->
            match getArrElemT arr1Arg.Type, getArrElemT arr2Arg.Type with
            | Some e1FT, Some e2FT ->
                let e1T = mapTypeKnown ctx e1FT
                let e2T = mapTypeKnown ctx e2FT
                let resultFT = fbody.Type
                let resultET = mapTypeKnown ctx resultFT
                let resArrIdx  = getOrAddArrayType ctx resultET
                let resArrRefT = WType.Ref(resArrIdx, false)
                let arr1ArrIdx = getOrAddArrayType ctx e1T
                let arr2ArrIdx = getOrAddArrayType ctx e2T
                let wArr1 = transform ctx arr1Arg
                let wArr2 = transform ctx arr2Arg
                let wBody = transform ctx fbody
                let a1Var = "$am2_a1"
                let a2Var = "$am2_a2"
                let resVar = "$am2_res"
                let a1Get = WExpr.LocalGet(a1Var, WType.Ref(arr1ArrIdx, false))
                let a2Get = WExpr.LocalGet(a2Var, WType.Ref(arr2ArrIdx, false))
                let resGet = WExpr.LocalGet(resVar, resArrRefT)
                let len = WExpr.ArrayLen(a1Get)
                Some(WExpr.Let(a1Var, wArr1,
                    WExpr.Let(a2Var, wArr2,
                        WExpr.Let(resVar,
                            WExpr.ArrayNew(resArrIdx, len, makeNumericZero resultET, resArrRefT),
                            mkArrayLoop "am2" resultET resArrIdx resGet []
                                (fun _elem idx ->
                                    WExpr.ArraySet(resGet, idx,
                                        WExpr.Let(farg1.Name, WExpr.ArrayGet(a1Get, idx, e1T),
                                            WExpr.Let(farg2.Name, WExpr.ArrayGet(a2Get, idx, e2T),
                                                wBody))))
                                resGet None))))
            | _ -> None
        | _ -> None
    // ── Array.sortWith cmp arr — insertion sort with inline comparator ──
    | "sortWith" ->
        // Unpack the 2-arg comparator (may be Lambda or Delegate)
        let cmpArgOpt = fableArgs |> List.tryHead
        let cmpParts =
            match cmpArgOpt with
            | None -> None
            | Some cmpArg ->
                match cmpArg with
                | Fable.Expr.Lambda(arg1, Fable.Expr.Lambda(arg2, body, _), _) ->
                    Some(arg1, arg2, body)
                | Fable.Expr.Lambda(arg1, Fable.Expr.Delegate([arg2], body, _, _), _) ->
                    Some(arg1, arg2, body)
                | Fable.Expr.Delegate([arg1; arg2], body, _, _) ->
                    Some(arg1, arg2, body)
                | Fable.Expr.Delegate([arg1], Fable.Expr.Lambda(arg2, body, _), _, _) ->
                    Some(arg1, arg2, body)
                | _ -> None
        match cmpParts with
        | None -> None  // fall through to general array sort
        | Some(farg1, farg2, fbody) ->
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> getArrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | None -> None
        | Some arrArg ->
        match getArrElemT arrArg.Type with
        | None -> None
        | Some elemFableT ->
        let elemT      = mapTypeKnown ctx elemFableT
        let (arrElemT, arrDefault) =
            match elemT with
            | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
            | t -> t, makeZero t
        let readElem arrExpr idxExpr =
            match elemT with
            | WType.Ref(idx, false) ->
                WExpr.Cast(WExpr.ArrayGet(arrExpr, idxExpr, arrElemT), WType.Ref(idx, false))
            | _ -> WExpr.ArrayGet(arrExpr, idxExpr, elemT)
        let arrTypeIdx = getOrAddArrayType ctx arrElemT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let wArr       = transform ctx arrArg
        let ctx'       = ctx.WithLocal(farg1.Name, elemT)
        let ctx''      = ctx'.WithLocal(farg2.Name, elemT)
        let wCmp       = transform ctx'' fbody  // i32: negative/zero/positive
        let inlineCmp aExpr bExpr =
            WExpr.Let(farg1.Name, aExpr,
                WExpr.Let(farg2.Name, bExpr,
                    wCmp))
        let srcVar     = "$asw_src"
        let resVar     = "$asw_res"
        let lenVar     = "$asw_len"
        let iVar       = "$asw_i"
        let jVar       = "$asw_j"
        let eVar       = "$asw_e"
        let iLoopLabel = "$asw_il"
        let jLoopLabel = "$asw_jl"
        let srcGet     = WExpr.LocalGet(srcVar, arrRefT)
        let resGet     = WExpr.LocalGet(resVar, arrRefT)
        let lenGet     = WExpr.LocalGet(lenVar, WType.I32)
        let iGet       = WExpr.LocalGet(iVar, WType.I32)
        let jGet       = WExpr.LocalGet(jVar, WType.I32)
        let eGet       = WExpr.LocalGet(eVar, elemT)
        let jCond =
            WExpr.If(WExpr.Compare(WCompareOp.GeS, jGet, WExpr.Const(WConst.I32 0)),
                WExpr.Compare(WCompareOp.GtS,
                    inlineCmp (readElem resGet jGet) eGet,
                    WExpr.Const(WConst.I32 0)),
                WExpr.Const(WConst.I32 0), WType.I32)
        let jStep =
            WExpr.Sequence [
                WExpr.ArraySet(resGet,
                    WExpr.Binary(WBinaryOp.Add, jGet, WExpr.Const(WConst.I32 1), WType.I32),
                    readElem resGet jGet)
                WExpr.Assign(jVar, WExpr.Binary(WBinaryOp.Sub, jGet, WExpr.Const(WConst.I32 1), WType.I32))
                WExpr.Continue(jLoopLabel, [])
            ]
        let jLoop = WExpr.Loop(jLoopLabel,
            WExpr.If(jCond, jStep, WExpr.Nop, WType.Void), WType.Void)
        let iStep =
            WExpr.Sequence [
                WExpr.Let(eVar, readElem resGet iGet,
                    WExpr.LetMut(jVar,
                        WExpr.Binary(WBinaryOp.Sub, iGet, WExpr.Const(WConst.I32 1), WType.I32),
                        WExpr.Sequence [
                            jLoop
                            WExpr.ArraySet(resGet,
                                WExpr.Binary(WBinaryOp.Add, jGet, WExpr.Const(WConst.I32 1), WType.I32),
                                eGet)
                        ]))
                WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                WExpr.Continue(iLoopLabel, [])
            ]
        let iLoop = WExpr.Loop(iLoopLabel,
            WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet), iStep, WExpr.Nop, WType.Void),
            WType.Void)
        Some(WExpr.Let(srcVar, wArr,
            WExpr.Let(lenVar, WExpr.ArrayLen(srcGet),
                WExpr.Let(resVar, WExpr.ArrayNew(arrTypeIdx, lenGet, arrDefault, arrRefT),
                    WExpr.Sequence [
                        WExpr.ArrayCopy(resGet, WExpr.Const(WConst.I32 0), srcGet, WExpr.Const(WConst.I32 0), lenGet)
                        WExpr.LetMut(iVar, WExpr.Const(WConst.I32 1),
                            WExpr.Sequence [iLoop; resGet])
                    ]))))
    // ── Array.sort — insertion sort into a fresh copy ──
    // After ReplacementsInject, args are [arr; comparer] for sort/sortDescending
    | "sort" | "sortDescending" | "sortBy" ->
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> getArrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | Some arrArg ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT    = WType.Ref(arrTypeIdx, false)
                let wArr       = transform ctx arrArg
                let srcVar     = "$asort_src"
                let resVar     = "$asort_res"
                let lenVar     = "$asort_len"
                let iVar       = "$asort_i"
                let jVar       = "$asort_j"
                let eVar       = "$asort_e"
                let iLoopLabel = "$asort_il"
                let jLoopLabel = "$asort_jl"
                let srcGet     = WExpr.LocalGet(srcVar, arrRefT)
                let resGet     = WExpr.LocalGet(resVar, arrRefT)
                let lenGet     = WExpr.LocalGet(lenVar, WType.I32)
                let iGet       = WExpr.LocalGet(iVar, WType.I32)
                let jGet       = WExpr.LocalGet(jVar, WType.I32)
                let eGet       = WExpr.LocalGet(eVar, elemT)
                let ltCmp a b  = WExpr.Compare(WCompareOp.LtS, a, b)
                // j-loop condition: j >= 0 AND key < res[j]  (short-circuit via nested If)
                let jCond =
                    WExpr.If(WExpr.Compare(WCompareOp.GeS, jGet, WExpr.Const(WConst.I32 0)),
                        ltCmp eGet (WExpr.ArrayGet(resGet, jGet, elemT)),
                        WExpr.Const(WConst.I32 0), WType.I32)
                let jStep =
                    WExpr.Sequence [
                        WExpr.ArraySet(resGet,
                            WExpr.Binary(WBinaryOp.Add, jGet, WExpr.Const(WConst.I32 1), WType.I32),
                            WExpr.ArrayGet(resGet, jGet, elemT))
                        WExpr.Assign(jVar, WExpr.Binary(WBinaryOp.Sub, jGet, WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(jLoopLabel, [])
                    ]
                let jLoop = WExpr.Loop(jLoopLabel,
                    WExpr.If(jCond, jStep, WExpr.Nop, WType.Void), WType.Void)
                let iStep =
                    WExpr.Sequence [
                        WExpr.Let(eVar, WExpr.ArrayGet(resGet, iGet, elemT),
                            WExpr.LetMut(jVar,
                                WExpr.Binary(WBinaryOp.Sub, iGet, WExpr.Const(WConst.I32 1), WType.I32),
                                WExpr.Sequence [
                                    jLoop
                                    WExpr.ArraySet(resGet,
                                        WExpr.Binary(WBinaryOp.Add, jGet, WExpr.Const(WConst.I32 1), WType.I32),
                                        eGet)
                                ]))
                        WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(iLoopLabel, [])
                    ]
                let iLoop = WExpr.Loop(iLoopLabel,
                    WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet), iStep, WExpr.Nop, WType.Void),
                    WType.Void)
                Some(WExpr.Let(srcVar, wArr,
                    WExpr.Let(lenVar, WExpr.ArrayLen(srcGet),
                        WExpr.Let(resVar, WExpr.ArrayNew(arrTypeIdx, lenGet, makeZero elemT, arrRefT),
                            WExpr.Sequence [
                                WExpr.ArrayCopy(resGet, WExpr.Const(WConst.I32 0), srcGet, WExpr.Const(WConst.I32 0), lenGet)
                                WExpr.LetMut(iVar, WExpr.Const(WConst.I32 1),
                                    WExpr.Sequence [iLoop; resGet])
                            ]))))
            | None -> None
        | None -> None
    // ── Array.findIndex pred arr — first index where pred holds, -1 if none ──
    | "findIndex" | "tryFindIndex" ->
        match fableArgs with
        | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg] ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let wArr       = transform ctx arrArg
                let ctx'       = ctx.WithLocal(farg.Name, elemT)
                let wPred      = transform ctx' fbody
                Some(mkArrayLoop "afidx" elemT arrTypeIdx wArr []
                        (fun elem idx ->
                            WExpr.Let(farg.Name, elem,
                                WExpr.If(wPred,
                                    WExpr.Break("$afidx_exit", Some idx),
                                    WExpr.Nop, WType.Void)))
                        (WExpr.Const(WConst.I32 (-1))) (Some("$afidx_exit", WType.I32)))
            | None -> None
        | _ -> None
    // ── Array.contains needle arr — true (1) if any element equals needle ──
    // After ReplacementsInject, args are [needle; arr; eqComparer]
    | "contains" ->
        // Find the first array-typed arg; needle is the arg immediately before it
        let tryGetNeedleAndArr () =
            match fableArgs |> List.tryFindIndex (fun a -> getArrElemT a.Type |> Option.isSome) with
            | Some idx when idx > 0 -> Some(fableArgs.[idx - 1], fableArgs.[idx])
            | _ -> None
        match tryGetNeedleAndArr () with
        | Some(needle, arrArg) ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let wArr       = transform ctx arrArg
                let wNeedle    = transform ctx needle
                let needleVar  = "$acont_needle"
                let needleGet  = WExpr.LocalGet(needleVar, elemT)
                Some(WExpr.Let(needleVar, wNeedle,
                    mkArrayLoop "acont" elemT arrTypeIdx wArr []
                        (fun elem _idx ->
                            WExpr.If(WExpr.Compare(WCompareOp.Eq, elem, needleGet),
                                WExpr.Break("$acont_exit", Some(WExpr.Const(WConst.I32 1))),
                                WExpr.Nop, WType.Void))
                        (WExpr.Const(WConst.I32 0)) (Some("$acont_exit", WType.I32))))
            | None -> None
        | None -> None
    // ── Array.scan f init arr — fold storing all intermediate accumulators ─────
    // scan f init [|a;b;c|] = [|init; f init a; f (f init a) b; ...|] (length n+1)
    | "scan" ->
        match fableArgs with
        | [(Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _) | Fable.Expr.Delegate([farg1; farg2], fbody, _, _)); initArg; arrArg]
        | [(Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _) | Fable.Expr.Delegate([farg1; farg2], fbody, _, _)); initArg; arrArg; _] ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let accumFableT = initArg.Type
                let elemT    = mapTypeKnown ctx elemFableT
                let accT     = mapTypeKnown ctx accumFableT
                let arrTypeIdx  = getOrAddArrayType ctx elemT
                let accArrIdx = getOrAddArrayType ctx accT
                let arrRefT  = WType.Ref(arrTypeIdx, false)
                let accArrRefT = WType.Ref(accArrIdx, false)
                let wArr  = transform ctx arrArg
                let wInit = transform ctx initArg
                let srcVar = "$scan_src"
                let srcGet = WExpr.LocalGet(srcVar, arrRefT)
                let resVar = "$scan_res"
                let resGet = WExpr.LocalGet(resVar, accArrRefT)
                let accVar = "$scan_acc"
                let accGet = WExpr.LocalGet(accVar, accT)
                let ctx'  = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
                let wBody = transform ctx' fbody
                let fillLoop =
                    mkArrayLoop "scan" elemT arrTypeIdx srcGet []
                        (fun elem idx ->
                            let step = WExpr.Let(farg1.Name, accGet,
                                        WExpr.Let(farg2.Name, elem,
                                            WExpr.Sequence [
                                                WExpr.Assign(accVar, wBody)
                                                WExpr.ArraySet(resGet,
                                                    WExpr.Binary(WBinaryOp.Add, idx, WExpr.Const(WConst.I32 1), WType.I32),
                                                    accGet)
                                            ]))
                            step)
                        WExpr.Nop None
                Some(WExpr.Let(srcVar, wArr,
                    WExpr.Let(resVar,
                        WExpr.ArrayNew(accArrIdx,
                            WExpr.Binary(WBinaryOp.Add, WExpr.ArrayLen(srcGet), WExpr.Const(WConst.I32 1), WType.I32),
                            makeZero accT, accArrRefT),
                        WExpr.LetMut(accVar, wInit,
                            WExpr.Sequence [
                                WExpr.ArraySet(resGet, WExpr.Const(WConst.I32 0), accGet)
                                fillLoop
                                resGet
                            ]))))
            | None -> None
        | _ -> None
    // ── Array.toList arr — convert GC array to linked list (right-to-left cons) ──
    // Uses arrayToListRev combinator for clean, readable code.
    | "toList" when (match resultFableType with | Fable.Type.List _ -> true | _ -> false) ->
        match List.tryHead fableArgs with
        | None -> None
        | Some arrArg ->
        match getArrElemT arrArg.Type with
        | None -> None
        | Some elemFableT ->
        match tryListTypeInfoFromElemType ctx elemFableT with
        | None -> None
        | Some(elemT, consIdx) ->
            let s      = mkListShape elemT consIdx
            let gen    = LabelGen("atl")
            let wArr   = transform ctx arrArg
            let arrRefT = mapTypeKnown ctx arrArg.Type
            let arrVar  = "$atl_arr"
            Some(WExpr.Let(arrVar, wArr,
                let a = WExpr.LocalGet(arrVar, arrRefT)
                arrayToListRev gen s a (WExpr.ArrayLen a)
                    (fun ar i -> WExpr.ArrayGet(ar, i, elemT))))
    // ── Array.append arr1 arr2 — new array = arr1 ++ arr2 ────────────────────
    | "append" ->
        match fableArgs with
        | [arrArg1; arrArg2]
        | [arrArg1; arrArg2; _] when getArrElemT arrArg1.Type |> Option.isSome ->
            match getArrElemT arrArg1.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT = WType.Ref(arrTypeIdx, false)
                let wArr1 = transform ctx arrArg1
                let wArr2 = transform ctx arrArg2
                let a1Var = "$app_a1"
                let a1Get = WExpr.LocalGet(a1Var, arrRefT)
                let a2Var = "$app_a2"
                let a2Get = WExpr.LocalGet(a2Var, arrRefT)
                let l1Var = "$app_l1"
                let l1Get = WExpr.LocalGet(l1Var, WType.I32)
                let resVar = "$app_res"
                let resGet = WExpr.LocalGet(resVar, arrRefT)
                Some(WExpr.Let(a1Var, wArr1,
                    WExpr.Let(a2Var, wArr2,
                        WExpr.Let(l1Var, WExpr.ArrayLen(a1Get),
                            WExpr.Let(resVar,
                                WExpr.ArrayNew(arrTypeIdx,
                                    WExpr.Binary(WBinaryOp.Add, l1Get, WExpr.ArrayLen(a2Get), WType.I32),
                                    makeZero elemT, arrRefT),
                                WExpr.Sequence [
                                    WExpr.ArrayCopy(resGet, WExpr.Const(WConst.I32 0), a1Get, WExpr.Const(WConst.I32 0), l1Get)
                                    WExpr.ArrayCopy(resGet, l1Get, a2Get, WExpr.Const(WConst.I32 0), WExpr.ArrayLen(a2Get))
                                    resGet
                                ])))))
            | None -> None
        | _ -> None
    // ── Array.choose f arr — apply f, keep Some values, unwrap ──────────────
    // Strategy: two-pass.  Pass 1 counts matching elements.
    //           Pass 2 fills a freshly-allocated result array.
    | "choose" ->
        let tryFnAndArr () =
            match fableArgs with
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg; _]
            | [_; (Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg] ->
                Some(farg, fbody, arrArg)
            | _ -> None
        match tryFnAndArr () with
        | None -> None
        | Some(farg, fbody, arrArg) ->
        match getArrElemT arrArg.Type with
        | None -> None
        | Some inElemFableT ->
        let outElemFableT =
            match resultFableType with
            | Fable.Type.Array(t, _) -> t
            | _ -> Fable.Type.Any
        let inElemT    = mapTypeKnown ctx inElemFableT
        let outElemT   = mapTypeKnown ctx outElemFableT
        let inArrIdx   = getOrAddArrayType ctx inElemT
        let outArrIdx  = getOrAddArrayType ctx outElemT
        let inArrRefT  = WType.Ref(inArrIdx, false)
        let outArrRefT = WType.Ref(outArrIdx, false)
        let wArr       = transform ctx arrArg
        let ctx'       = ctx.WithLocal(farg.Name, inElemT)
        let wBody      = transform ctx' fbody
        let wBodyT     = mapTypeKnown ctx fbody.Type     // Option struct type
        match wBodyT with
        | WType.Ref(optTypeIdx, _) ->
            let optNullT   = WType.Ref(optTypeIdx, true)
            let optNonNull = WType.Ref(optTypeIdx, false)
            let srcVar    = "$acho_src"
            let cntVar    = "$acho_cnt"
            let resVar    = "$acho_res"
            let widxVar   = "$acho_wi"
            let srcGet    = WExpr.LocalGet(srcVar, inArrRefT)
            let resGet    = WExpr.LocalGet(resVar, outArrRefT)
            // Pass 1: count Somes
            let countLoop =
                mkArrayLoop "achocnt" inElemT inArrIdx srcGet
                    [(cntVar, WExpr.Const(WConst.I32 0))]
                    (fun elem _idx ->
                        WExpr.Let(farg.Name, elem,
                            WExpr.Let("$acho_opt", wBody,
                                WExpr.If(
                                    WExpr.RefIsNull(WExpr.LocalGet("$acho_opt", optNullT)),
                                    WExpr.Nop,
                                    WExpr.Assign(cntVar, WExpr.Binary(WBinaryOp.Add,
                                        WExpr.LocalGet(cntVar, WType.I32),
                                        WExpr.Const(WConst.I32 1), WType.I32)),
                                    WType.Void))))
                    (WExpr.LocalGet(cntVar, WType.I32)) None
            // Pass 2: fill result
            let fillLoop =
                mkArrayLoop "achofil" inElemT inArrIdx srcGet
                    [(widxVar, WExpr.Const(WConst.I32 0))]
                    (fun elem _idx ->
                        WExpr.Let(farg.Name, elem,
                            WExpr.Let("$acho_opt2", wBody,
                                WExpr.If(
                                    WExpr.RefIsNull(WExpr.LocalGet("$acho_opt2", optNullT)),
                                    WExpr.Nop,
                                    WExpr.Sequence [
                                        WExpr.ArraySet(resGet,
                                            WExpr.LocalGet(widxVar, WType.I32),
                                            WExpr.StructGet(
                                                WExpr.Cast(WExpr.LocalGet("$acho_opt2", optNullT), optNonNull),
                                                0, outElemT))
                                        WExpr.Assign(widxVar, WExpr.Binary(WBinaryOp.Add,
                                            WExpr.LocalGet(widxVar, WType.I32),
                                            WExpr.Const(WConst.I32 1), WType.I32))
                                    ],
                                    WType.Void))))
                    resGet None
            Some(WExpr.Let(srcVar, wArr,
                WExpr.Let("$acho_count", countLoop,
                    WExpr.Let(resVar,
                        WExpr.ArrayNew(outArrIdx,
                            WExpr.LocalGet("$acho_count", WType.I32),
                            makeZero outElemT, outArrRefT),
                        fillLoop))))
        | _ -> None
    // ── Array.collect f arr — apply f (returns array), concatenate results ───
    // Strategy: build intermediate list of sub-arrays, compute total length,
    //           allocate result, copy each sub-array in.
    | "collect" ->
        let tryFnAndArr () =
            match fableArgs with
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg]
            | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); arrArg; _] ->
                Some(farg, fbody, arrArg)
            | _ -> None
        match tryFnAndArr () with
        | None -> None
        | Some(farg, fbody, arrArg) ->
        match getArrElemT arrArg.Type with
        | None -> None
        | Some inElemFableT ->
        let outElemFableT =
            match resultFableType with
            | Fable.Type.Array(t, _) -> t
            | _ -> Fable.Type.Any
        let inElemT    = mapTypeKnown ctx inElemFableT
        let outElemT   = mapTypeKnown ctx outElemFableT
        let inArrIdx   = getOrAddArrayType ctx inElemT
        let outArrIdx  = getOrAddArrayType ctx outElemT
        let inArrRefT  = WType.Ref(inArrIdx, false)
        let outArrRefT = WType.Ref(outArrIdx, false)
        let wArr       = transform ctx arrArg
        let ctx'       = ctx.WithLocal(farg.Name, inElemT)
        let wBody      = transform ctx' fbody
        // Pass 1: compute total output length
        let srcVar    = "$acol_src"
        let resVar    = "$acol_res"
        let totVar    = "$acol_tot"
        let outVar    = "$acol_out"
        let subVar    = "$acol_sub"
        let srcGet    = WExpr.LocalGet(srcVar, inArrRefT)
        let resGet    = WExpr.LocalGet(resVar, outArrRefT)
        let totGet    = WExpr.LocalGet(totVar, WType.I32)
        let outGet    = WExpr.LocalGet(outVar, WType.I32)
        let subRefT   = outArrRefT   // sub-arrays have same element type
        let subGet    = WExpr.LocalGet(subVar, subRefT)
        let countLoop =
            mkArrayLoop "acolcnt" inElemT inArrIdx srcGet
                [(totVar, WExpr.Const(WConst.I32 0))]
                (fun elem _idx ->
                    WExpr.Let(farg.Name, elem,
                        WExpr.Let(subVar, wBody,
                            WExpr.Assign(totVar, WExpr.Binary(WBinaryOp.Add,
                                totGet, WExpr.ArrayLen(subGet), WType.I32)))))
                totGet None
        let fillLoop =
            mkArrayLoop "acolfil" inElemT inArrIdx srcGet
                [(outVar, WExpr.Const(WConst.I32 0))]
                (fun elem _idx ->
                    WExpr.Let(farg.Name, elem,
                        WExpr.Let(subVar, wBody,
                            WExpr.Sequence [
                                WExpr.ArrayCopy(resGet, outGet, subGet,
                                    WExpr.Const(WConst.I32 0),
                                    WExpr.ArrayLen(subGet))
                                WExpr.Assign(outVar, WExpr.Binary(WBinaryOp.Add,
                                    outGet, WExpr.ArrayLen(subGet), WType.I32))
                            ])))
                resGet None
        Some(WExpr.Let(srcVar, wArr,
            WExpr.Let("$acol_count", countLoop,
                WExpr.Let(resVar,
                    WExpr.ArrayNew(outArrIdx, WExpr.LocalGet("$acol_count", WType.I32),
                        makeZero outElemT, outArrRefT),
                    fillLoop))))
    | _ -> None
// These arrive as Get(arr, FieldGet "filter/some/every/forEach") as callee
// ─────────────────────────────────────────────────────────────────

/// Handle array instance-style calls: arr.filter/some/every/forEach(lambda)
/// fieldName matches lowercase JS method name; returns None to fall through.
let tryArrayInstanceCall
        (transform: TransformFn)
        (ctx: Ctx)
        (fieldName: string)
        (arrExpr: Fable.Expr)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    let ty = mapTypeKnown ctx resultFableType
    let getLambda args =
        match args with
        | [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _))] -> Some(farg, fbody)
        | _ -> None
    match fieldName, getLambda fableArgs with
    | ("filter"), Some(farg, fbody) ->
        match getArrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let arrRefT = WType.Ref(arrTypeIdx, false)
            let wArr = transform ctx arrExpr
            let srcVar = "$ifilt_src"
            let cntVar = "$ifilt_cnt"
            let resVar = "$ifilt_res"
            let widxVar = "$ifilt_widx"
            let srcGet = WExpr.LocalGet(srcVar, arrRefT)
            let resGet = WExpr.LocalGet(resVar, arrRefT)
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            let countLoop =
                mkArrayLoop "ifiltcnt" elemT arrTypeIdx srcGet
                    [(cntVar, WExpr.Const(WConst.I32 0))]
                    (fun elem _idx ->
                        WExpr.Let(farg.Name, elem,
                            WExpr.If(wPred,
                                WExpr.Assign(cntVar, WExpr.Binary(WBinaryOp.Add,
                                    WExpr.LocalGet(cntVar, WType.I32), WExpr.Const(WConst.I32 1), WType.I32)),
                                WExpr.Nop, WType.Void)))
                    (WExpr.LocalGet(cntVar, WType.I32)) None
            let fillLoop =
                mkArrayLoop "ifiltfil" elemT arrTypeIdx srcGet
                    [(widxVar, WExpr.Const(WConst.I32 0))]
                    (fun elem _idx ->
                        WExpr.Let(farg.Name, elem,
                            WExpr.If(wPred,
                                WExpr.Sequence [
                                    WExpr.ArraySet(resGet, WExpr.LocalGet(widxVar, WType.I32), WExpr.LocalGet(farg.Name, elemT))
                                    WExpr.Assign(widxVar, WExpr.Binary(WBinaryOp.Add,
                                        WExpr.LocalGet(widxVar, WType.I32), WExpr.Const(WConst.I32 1), WType.I32))
                                ],
                                WExpr.Nop, WType.Void)))
                    resGet None
            Some(WExpr.Let(srcVar, wArr,
                WExpr.Let("$ifilt_count", countLoop,
                    WExpr.Let(resVar,
                        WExpr.ArrayNew(arrTypeIdx,
                            WExpr.LocalGet("$ifilt_count", WType.I32),
                            makeZero elemT, arrRefT),
                        fillLoop))))
        | None -> None
    | ("some"), Some(farg, fbody) ->
        match getArrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(mkArrayLoop "isome" elemT arrTypeIdx wArr []
                    (fun elem _idx ->
                        WExpr.Let(farg.Name, elem,
                            WExpr.If(wPred,
                                WExpr.Break("$isome_exit", Some(WExpr.Const(WConst.I32 1))),
                                WExpr.Nop, WType.Void)))
                    (WExpr.Const(WConst.I32 0)) (Some("$isome_exit", WType.I32)))
        | None -> None
    | ("every"), Some(farg, fbody) ->
        match getArrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(mkArrayLoop "ievery" elemT arrTypeIdx wArr []
                    (fun elem _idx ->
                        WExpr.Let(farg.Name, elem,
                            WExpr.If(WExpr.Unary(WUnaryOp.Eqz, wPred, WType.I32),
                                WExpr.Break("$ievery_exit", Some(WExpr.Const(WConst.I32 0))),
                                WExpr.Nop, WType.Void)))
                    (WExpr.Const(WConst.I32 1)) (Some("$ievery_exit", WType.I32)))
        | None -> None
    | ("forEach"), Some(farg, fbody) ->
        match getArrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wBody = transform ctx' fbody
            Some(mkArrayLoop "iforeach" elemT arrTypeIdx wArr []
                    (fun elem _idx -> WExpr.Let(farg.Name, elem, wBody))
                    WExpr.Nop None)
        | None -> None
    // Array.reduce f arr → fold from first element as accumulator
    | ("reduce" | "reduceRight"), _ ->
        let getTwoArgLambda (args: Fable.Expr list) =
            match args with
            | [Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _)]
            | [Fable.Expr.Delegate([farg1; farg2], fbody, _, _)] -> Some(farg1, farg2, fbody)
            | _ -> None
        match getTwoArgLambda fableArgs with
        | Some(farg1, farg2, fbody) ->
            match getArrElemT arrExpr.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT    = WType.Ref(arrTypeIdx, false)
                let wArr       = transform ctx arrExpr
                let arrVar     = "$ired_arr"
                let accVar     = "$ired_acc"
                let iVar       = "$ired_i"
                let lenVar     = "$ired_len"
                let loopLabel  = "$ired_loop"
                let arrGet     = WExpr.LocalGet(arrVar, arrRefT)
                let accGet     = WExpr.LocalGet(accVar, elemT)
                let iGet       = WExpr.LocalGet(iVar, WType.I32)
                let lenGet     = WExpr.LocalGet(lenVar, WType.I32)
                let ctx'       = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
                let wBody      = transform ctx' fbody
                let elem       = WExpr.ArrayGet(arrGet, iGet, elemT)
                let step =
                    WExpr.Sequence [
                        WExpr.Assign(accVar,
                            WExpr.Let(farg1.Name, accGet,
                                WExpr.Let(farg2.Name, elem, wBody)))
                        WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(loopLabel, [])
                    ]
                let loop = WExpr.Loop(loopLabel,
                    WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet), step, WExpr.Nop, WType.Void),
                    WType.Void)
                Some(WExpr.Let(arrVar, wArr,
                    WExpr.Let(lenVar, WExpr.ArrayLen(arrGet),
                        WExpr.LetMut(accVar, WExpr.ArrayGet(arrGet, WExpr.Const(WConst.I32 0), elemT),
                            WExpr.LetMut(iVar, WExpr.Const(WConst.I32 1),
                                WExpr.Sequence [loop; accGet])))))
            | None -> None
        | None -> None
    | _ -> None

