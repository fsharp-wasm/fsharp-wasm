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
            Some(arrayNew arrTypeIdx wSize wInit (WType.Ref(arrTypeIdx, false)))
        | _ -> None
    // Array.zeroCreate n
    | "zeroCreate" ->
        match getArrElemT resultFableType, wArgs with
        | Some elemFableT, [wSize] ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            Some(arrayNew arrTypeIdx wSize (makeZero elemT) (WType.Ref(arrTypeIdx, false)))
        | _ -> None
    // Array.length
    | "length" ->
        match fableArgs with
        | [arrArg] when getArrElemT arrArg.Type |> Option.isSome ->
            Some(arrayLen (List.head wArgs))
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
            let wArrFinal =
                match arrFableArg.Type with
                | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) ->
                    let (arrTypeIdx, _) = getOrAddResizeArrayType ctx elemT
                    let arrRefT = WType.Ref(arrTypeIdx, true)
                    cast (structGet wArr 0 arrRefT) (WType.Ref(arrTypeIdx, false))
                | _ -> wArr
            Some(arrayGet wArrFinal wIdx elemT)
        | _ -> None
    // ResizeArray.[idx] <- v → Array.setItem(ar, idx, value)
    | "setItem" ->
        match fableArgs with
        | [arrArg; _; _] ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                match wArgs with
                | [wArr; wIdx; wVal] ->
                    match arrArg.Type with
                    | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) ->
                        let (arrTypeIdx, _) = getOrAddResizeArrayType ctx elemT
                        let arrRefT = WType.Ref(arrTypeIdx, true)
                        Some(arraySet (cast (structGet wArr 0 arrRefT) (WType.Ref(arrTypeIdx, false))) wIdx wVal)
                    | _ ->
                        Some(arraySet wArr wIdx wVal)
                | _ -> None
            | None -> None
        | _ -> None
    // Array.set
    | "set" ->
        match fableArgs with
        | [arrArg; _; _] when getArrElemT arrArg.Type |> Option.isSome ->
            match wArgs with
            | [wArr; wIdx; wVal] -> Some(arraySet wArr wIdx wVal)
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
                let gen = LabelGen("acpy")
                Some(wasm {
                    let! src = wSrc
                    let! dst = arrayNew arrTypeIdx (arrayLen src) (makeZero elemT) arrRef
                    do! arrayCopy dst (i32Const 0) src (i32Const 0) (arrayLen src)
                    return dst
                })
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
            | [_; _; wCount; wValue] -> Some(arrayNew arrTypeIdx wCount wValue arrRefT)
            | [_; wCount; wValue]    -> Some(arrayNew arrTypeIdx wCount wValue arrRefT)
            | [wCount; wValue]       -> Some(arrayNew arrTypeIdx wCount wValue arrRefT)
            | _ -> None
        | None ->
            match fableArgs, wArgs with
            | [arrArg; _; _; _], [wArr; wStart; wCount; wVal]
                  when getArrElemT arrArg.Type |> Option.isSome ->
                let gen = LabelGen("fill")
                Some(wasm {
                    let! lim = add wStart wCount
                    let! i = mut wStart
                    while! (ltS i.Val lim) do
                        do! arraySet wArr i.Val wVal
                        do! i.Set(add i.Val (i32Const 1))
                })
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
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("aiter")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayIter gen a wArr
                    (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
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
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("aiteri")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(fidx.Name, WType.I32).WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayIteri gen a wArr
                    (fun idx elem ->
                        WExpr.Let(fidx.Name, idx, WExpr.Let(farg.Name, elem, wBody))))
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
                let a = mkArrayShape elemT arrTypeIdx
                let ra = mkArrayShape resultElemT resultArrIdx
                let gen = LabelGen("amap")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayMap gen a ra wArr
                    (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
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
                let a = mkArrayShape elemT arrTypeIdx
                let ra = mkArrayShape resultElemT resultArrIdx
                let gen = LabelGen("amapi")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(fidx.Name, WType.I32).WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayMapi gen a ra wArr
                    (fun idx elem ->
                        WExpr.Let(fidx.Name, idx,
                            WExpr.Let(farg.Name, elem, wBody))))
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
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("afold")
                let wArr = List.last wArgs
                let wInit = transform ctx initArg
                let accT = mapTypeKnown ctx initArg.Type
                let ctx' = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayFold gen a wArr wInit accT
                    (fun acc elem ->
                        WExpr.Let(farg1.Name, acc,
                            WExpr.Let(farg2.Name, elem, wBody))))
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
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("aexi")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wPred = transform ctx' fbody
                if sel = "exists" then
                    Some(arrayExists gen a wArr
                        (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
                else
                    Some(arrayForAll gen a wArr
                        (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
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
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("afilt")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wPred = transform ctx' fbody
                Some(arrayFilter gen a wArr
                    (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
            | None -> None
        | None -> None
    // Array.init / initialize
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
            let gen = LabelGen("ainit")
            let ctx' = ctx.WithLocal(farg.Name, WType.I32)
            let wBody = transform ctx' fbody
            Some(wasm {
                let! res = arrayNew resultArrIdx wLen (makeZero resultElemT) resultArrRefT
                do! Wasm.for_ (arrayLen res) (fun idx ->
                        WExpr.Let(farg.Name, idx,
                            arraySet res idx wBody))
                return res
            })
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
                let gen        = LabelGen("ared")
                let ctx'       = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
                let wBody      = transform ctx' fbody
                Some(wasm {
                    let! src = wArr
                    let! len = arrayLen src
                    let! acc = mutTy elemT (arrayGet src (i32Const 0) elemT)
                    let! i = mut (i32Const 1)
                    while! (ltS i.Val len) do
                        do! acc.Set(WExpr.Let(farg1.Name, acc.Val,
                                WExpr.Let(farg2.Name, arrayGet src i.Val elemT, wBody)))
                        do! i.Set(add i.Val (i32Const 1))
                    return acc.Val
                })
            | None -> None
        | _ -> None
    // ── Array.sum arr — fold with additive zero ──
    | "sum" | "sumBy" ->
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> getArrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | Some arrArg ->
            match getArrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a          = mkArrayShape elemT arrTypeIdx
                let gen        = LabelGen("asum")
                let wArr       = transform ctx arrArg
                Some(arrayFold gen a wArr (makeZero elemT) elemT
                    (fun acc elem -> WExpr.Binary(WBinaryOp.Add, acc, elem, elemT)))
            | None -> None
        | None -> None
    // ── Array.min / Array.max — fold from first element, keep extreme ──
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
                let gen        = LabelGen("aminmax")
                let cmpOp      = if isMin then WCompareOp.LtS else WCompareOp.GtS
                let updateAcc acc eVar =
                    match elemT with
                    | WType.F64 | WType.F32 ->
                        let bop = if isMin then WBinaryOp.Min else WBinaryOp.Max
                        WExpr.Binary(bop, acc, eVar, elemT)
                    | _ ->
                        WExpr.If(WExpr.Compare(cmpOp, eVar, acc), eVar, acc, elemT)
                Some(wasm {
                    let! src = wArr
                    let! len = arrayLen src
                    let! acc = mutTy elemT (arrayGet src (i32Const 0) elemT)
                    let! i = mut (i32Const 1)
                    while! (ltS i.Val len) do
                        let! e = arrayGet src i.Val elemT
                        do! acc.Set(updateAcc acc.Val e)
                        do! i.Set(add i.Val (i32Const 1))
                    return acc.Val
                })
            | None -> None
        | None -> None
    // ── Array.rev arr — new array with elements in reverse order ──
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
                let gen        = LabelGen("arv")
                Some(wasm {
                    let! src = wArr
                    let! len = arrayLen src
                    let! res = arrayNew arrTypeIdx len (makeZero elemT) arrRefT
                    do! Wasm.for_ len (fun i ->
                            arraySet res i (arrayGet src (sub (sub len (i32Const 1)) i) elemT))
                    return res
                })
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
                let rec makeWZero (wt: WType) : WExpr =
                    match wt with
                    | WType.I64 -> WExpr.Const(WConst.I64 0L)
                    | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
                    | WType.F64 -> WExpr.Const(WConst.F64 0.0)
                    | WType.Ref(idx, true) -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                    | WType.Ref(idx, false) ->
                        match ctx.TypeDefs.[idx].Def with
                        | WTypeDef.Struct(fields, _) ->
                            structNew idx (fields |> List.map (fun f -> makeWZero f.Type)) (WType.Ref(idx, false))
                        | _ -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                    | _ -> WExpr.Const(WConst.I32 0)
                let tupleDefault = makeWZero tupleRefT
                let resArrIdx   = getOrAddArrayType ctx tupleRefT
                let resArrRefT  = WType.Ref(resArrIdx, false)
                let wArr1 = transform ctx arr1Arg
                let wArr2 = transform ctx arr2Arg
                let gen = LabelGen("azip")
                let a1ArrIdx = getOrAddArrayType ctx e1T
                let a2ArrIdx = getOrAddArrayType ctx e2T
                Some(wasm {
                    let! a1 = wArr1
                    let! a2 = wArr2
                    let! res = arrayNew resArrIdx (arrayLen a1) tupleDefault resArrRefT
                    do! Wasm.for_ (arrayLen a1) (fun idx ->
                            arraySet res idx
                                (structNew tupleIdx
                                    [arrayGet a1 idx e1T; arrayGet a2 idx e2T]
                                    tupleRefT))
                    return res
                })
            | _ -> None
        | _ -> None
    // ── Array.unzip arr — array of pairs → two arrays ─────────────────────
    | "unzip" ->
        match fableArgs with
        | [arrArg] ->
            match getArrElemT arrArg.Type with
            | Some(Fable.Type.Tuple([ta; tb], _)) ->
                let aT      = mapTypeKnown ctx ta
                let bT      = mapTypeKnown ctx tb
                let pairT   = mapTypeKnown ctx (Fable.Type.Tuple([ta; tb], false))
                match pairT with
                | WType.Ref(pairIdx, _) ->
                    let aArrIdx = getOrAddArrayType ctx aT
                    let bArrIdx = getOrAddArrayType ctx bT
                    let aArrRefT = WType.Ref(aArrIdx, false)
                    let bArrRefT = WType.Ref(bArrIdx, false)
                    let arrATupleWT = WType.Ref(aArrIdx, false)
                    let arrBTupleWT = WType.Ref(bArrIdx, false)
                    let _ = mapTypeKnown ctx (Fable.Type.Tuple([Fable.Type.Array(ta, Fable.ArrayKind.MutableArray); Fable.Type.Array(tb, Fable.ArrayKind.MutableArray)], false))
                    let tupleKey = wTypesKey [arrATupleWT; arrBTupleWT]
                    match ctx.TupleRegistry.TryGetValue(tupleKey) with
                    | false, _ -> None
                    | true, resultTupleIdx ->
                    let resultTupleRefT = WType.Ref(resultTupleIdx, false)
                    let pairArrIdx = getOrAddArrayType ctx pairT
                    let pairArrRefT = WType.Ref(pairArrIdx, false)
                    let wArr  = transform ctx arrArg
                    let gen = LabelGen("aunz")
                    let makeZeroFor wt =
                        match wt with
                        | WType.I64 -> WExpr.Const(WConst.I64 0L)
                        | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
                        | WType.F64 -> WExpr.Const(WConst.F64 0.0)
                        | WType.Ref(i, _) -> WExpr.Const(WConst.Null(WType.Ref(i, true)))
                        | _ -> i32Const 0
                    Some(wasm {
                        let! src = wArr
                        let! n = arrayLen src
                        let! aArr = arrayNew aArrIdx n (makeZeroFor aT) aArrRefT
                        let! bArr = arrayNew bArrIdx n (makeZeroFor bT) bArrRefT
                        do! Wasm.for_ n (fun idx -> wasm {
                            let! p = arrayGet src idx pairT
                            do! arraySet aArr idx (structGet p 0 aT)
                            return! arraySet bArr idx (structGet p 1 bT)
                        })
                        return structNew resultTupleIdx [aArr; bArr] resultTupleRefT
                    })
                | _ -> None
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
                let gen = LabelGen("am2")
                Some(wasm {
                    let! a1 = wArr1
                    let! a2 = wArr2
                    let! n = arrayLen a1
                    let! res = arrayNew resArrIdx n (makeNumericZero resultET) resArrRefT
                    do! Wasm.for_ n (fun idx ->
                            arraySet res idx
                                (WExpr.Let(farg1.Name, arrayGet a1 idx e1T,
                                    WExpr.Let(farg2.Name, arrayGet a2 idx e2T,
                                        wBody))))
                    return res
                })
            | _ -> None
        | _ -> None
    // ── Array.sortWith cmp arr — insertion sort with inline comparator ──
    | "sortWith" ->
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
        | None -> None
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
                cast (arrayGet arrExpr idxExpr arrElemT) (WType.Ref(idx, false))
            | _ -> arrayGet arrExpr idxExpr elemT
        let writeElem arrExpr idxExpr valExpr =
            arraySet arrExpr idxExpr valExpr
        let arrTypeIdx = getOrAddArrayType ctx arrElemT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let wArr       = transform ctx arrArg
        let ctx'       = ctx.WithLocal(farg1.Name, elemT)
        let ctx''      = ctx'.WithLocal(farg2.Name, elemT)
        let wCmp       = transform ctx'' fbody
        let inlineCmp aExpr bExpr =
            WExpr.Let(farg1.Name, aExpr,
                WExpr.Let(farg2.Name, bExpr,
                    wCmp))
        let gen = LabelGen("asw")
        Some(wasm {
            let! src = wArr
            let! len = arrayLen src
            let! res = arrayNew arrTypeIdx len arrDefault arrRefT
            do! arrayCopy res (i32Const 0) src (i32Const 0) len
            do! insertionSortInPlace gen res len elemT readElem writeElem inlineCmp
            return res
        })
    // ── Array.sort — insertion sort into a fresh copy ──
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
                let gen        = LabelGen("asort")
                let readElem arrExpr idxExpr = arrayGet arrExpr idxExpr elemT
                let writeElem arrExpr idxExpr valExpr = arraySet arrExpr idxExpr valExpr
                let cmp a b = WExpr.Compare(WCompareOp.LtS, a, b)
                // For sort: a < b → -1, else 1 (good enough for insertion sort's > 0 check)
                let cmpFn a b =
                    WExpr.If(WExpr.Compare(WCompareOp.LtS, a, b),
                        i32Const -1,
                        WExpr.If(WExpr.Compare(WCompareOp.Eq, a, b), i32Const 0, i32Const 1, WType.I32),
                        WType.I32)
                Some(wasm {
                    let! src = wArr
                    let! len = arrayLen src
                    let! res = arrayNew arrTypeIdx len (makeZero elemT) arrRefT
                    do! arrayCopy res (i32Const 0) src (i32Const 0) len
                    do! insertionSortInPlace gen res len elemT readElem writeElem cmpFn
                    return res
                })
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
                let a          = mkArrayShape elemT arrTypeIdx
                let gen        = LabelGen("afidx")
                let wArr       = transform ctx arrArg
                let ctx'       = ctx.WithLocal(farg.Name, elemT)
                let wPred      = transform ctx' fbody
                Some(arraySearch gen a wArr WType.I32
                    (fun elem -> WExpr.Let(farg.Name, elem, wPred))
                    (fun idx _elem -> idx)
                    (i32Const -1))
            | None -> None
        | _ -> None
    // ── Array.contains needle arr — true (1) if any element equals needle ──
    | "contains" ->
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
                let a          = mkArrayShape elemT arrTypeIdx
                let gen        = LabelGen("acont")
                let wArr       = transform ctx arrArg
                let wNeedle    = transform ctx needle
                Some(wasm {
                    let! needle = wNeedle
                    return! arrayExists gen a wArr
                        (fun elem -> eq elem needle)
                })
            | None -> None
        | None -> None
    // ── Array.scan f init arr — fold storing all intermediate accumulators ─────
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
                let srcA      = mkArrayShape elemT arrTypeIdx
                let srcRefT  = WType.Ref(arrTypeIdx, false)
                let accArrRefT = WType.Ref(accArrIdx, false)
                let wArr  = transform ctx arrArg
                let wInit = transform ctx initArg
                let gen = LabelGen("scan")
                let ctx'  = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
                let wBody = transform ctx' fbody
                Some(wasm {
                    let! src = wArr
                    let! res = arrayNew accArrIdx (add (arrayLen src) (i32Const 1)) (makeZero accT) accArrRefT
                    let! acc = mutTy accT wInit
                    do! arraySet res (i32Const 0) acc.Val
                    do! arrayIteri gen srcA src (fun idx elem ->
                            WExpr.Let(farg1.Name, acc.Val,
                                WExpr.Let(farg2.Name, elem, wasm {
                                    do! acc.Set(wBody)
                                    return! arraySet res (add idx (i32Const 1)) acc.Val
                                })))
                    return res
                })
            | None -> None
        | _ -> None
    // ── Array.toList arr — convert GC array to linked list (right-to-left cons) ──
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
            Some(wasm {
                let! a = wArr
                return! arrayToListRev gen s a (arrayLen a)
                    (fun ar i -> arrayGet ar i elemT)
            })
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
                let gen = LabelGen("app")
                Some(wasm {
                    let! a1 = wArr1
                    let! a2 = wArr2
                    let! l1 = arrayLen a1
                    let! res = arrayNew arrTypeIdx (add l1 (arrayLen a2)) (makeZero elemT) arrRefT
                    do! arrayCopy res (i32Const 0) a1 (i32Const 0) l1
                    do! arrayCopy res l1 a2 (i32Const 0) (arrayLen a2)
                    return res
                })
            | None -> None
        | _ -> None
    // ── Array.choose f arr — apply f, keep Some values, unwrap ──────────────
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
        let wBodyT     = mapTypeKnown ctx fbody.Type
        match wBodyT with
        | WType.Ref(optTypeIdx, _) ->
            let optNullT   = WType.Ref(optTypeIdx, true)
            let optNonNull = WType.Ref(optTypeIdx, false)
            let inA        = mkArrayShape inElemT inArrIdx
            let gen        = LabelGen("acho")
            // Pass 1: count Somes
            let countExpr src =
                wasm {
                    let! cnt = mut (i32Const 0)
                    do! Wasm.for_ (arrayLen src) (fun i ->
                            WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                                let! opt = wBody
                                return! wasmWhen (WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull opt, WType.I32))
                                    (cnt.Set(add cnt.Val (i32Const 1)))
                            }))
                    return cnt.Val
                }
            // Pass 2: fill result
            let fillExpr src res =
                wasm {
                    let! wi = mut (i32Const 0)
                    do! Wasm.for_ (arrayLen src) (fun i ->
                            WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                                let! opt = wBody
                                return! wasmWhen (WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull opt, WType.I32))
                                    (wasm {
                                        do! arraySet res wi.Val (structGet (cast opt optNonNull) 0 outElemT)
                                        return! wi.Set(add wi.Val (i32Const 1))
                                    })
                            }))
                    return res
                }
            Some(wasm {
                let! src = wArr
                let! count = countExpr src
                let! res = arrayNew outArrIdx count (makeZero outElemT) outArrRefT
                return! fillExpr src res
            })
        | _ -> None
    // ── Array.collect f arr — apply f (returns array), concatenate results ───
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
        let gen = LabelGen("acol")
        // Pass 1: compute total output length
        let countExpr src =
            wasm {
                let! tot = mut (i32Const 0)
                do! Wasm.for_ (arrayLen src) (fun i ->
                        WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                            let! sub = wBody
                            return! tot.Set(add tot.Val (arrayLen sub))
                        }))
                return tot.Val
            }
        // Pass 2: allocate + fill
        let fillExpr src res =
            wasm {
                let! out = mut (i32Const 0)
                do! Wasm.for_ (arrayLen src) (fun i ->
                        WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                            let! sub = wBody
                            do! arrayCopy res out.Val sub (i32Const 0) (arrayLen sub)
                            return! out.Set(add out.Val (arrayLen sub))
                        }))
                return res
            }
        Some(wasm {
            let! src = wArr
            let! count = countExpr src
            let! res = arrayNew outArrIdx count (makeZero outElemT) outArrRefT
            return! fillExpr src res
        })
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
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("ifilt")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(arrayFilter gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None
    | ("some"), Some(farg, fbody) ->
        match getArrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("isome")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(arrayExists gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None
    | ("every"), Some(farg, fbody) ->
        match getArrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("ievery")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(arrayForAll gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None
    | ("forEach"), Some(farg, fbody) ->
        match getArrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("iforeach")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wBody = transform ctx' fbody
            Some(arrayIter gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
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
                let gen        = LabelGen("ired")
                let ctx'       = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
                let wBody      = transform ctx' fbody
                Some(wasm {
                    let! src = wArr
                    let! len = arrayLen src
                    let! acc = mutTy elemT (arrayGet src (i32Const 0) elemT)
                    let! i = mut (i32Const 1)
                    while! (ltS i.Val len) do
                        do! acc.Set(WExpr.Let(farg1.Name, acc.Val,
                                WExpr.Let(farg2.Name, arrayGet src i.Val elemT, wBody)))
                        do! i.Set(add i.Val (i32Const 1))
                    return acc.Val
                })
            | None -> None
        | None -> None
    | _ -> None
