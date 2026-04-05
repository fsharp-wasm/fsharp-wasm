/// WasmGC inline replacements for List higher-order functions.
/// Uses high-level combinators from WasmGcLoopCombinators for clean, composable code.
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
let private seqElemType (t: Fable.Type) : Fable.Type option =
    match t with
    | Fable.Type.List e               -> Some e
    | Fable.Type.DeclaredType(_, [e]) -> Some e
    | _                               -> None

/// Numeric zero for a WType, including ref types (null).
let private makeNumericZero (elemT: WType) =
    match elemT with
    | WType.I64 -> WExpr.Const(WConst.I64 0L)
    | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
    | WType.F64 -> WExpr.Const(WConst.F64 0.0)
    | WType.Ref(idx, _) -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
    | _         -> WExpr.Const(WConst.I32 0)

// ─────────────────────────────────────────────────────────────────
// fold / reduce
// ─────────────────────────────────────────────────────────────────

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
            let s     = mkListShape elemT consIdx
            let gen   = LabelGen("fold")
            let accT  = mapTypeKnown ctx initArg.Type
            let ctx'  = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
            let wBody = transform ctx' fbody
            let wInit = transform ctx initArg
            let wList = transform ctx listArg
            Some(listFold gen s wList wInit accT
                    (fun acc elem -> WExpr.Let(farg1.Name, acc, WExpr.Let(farg2.Name, elem, wBody))))
        | None -> None
    | "reduce", [Fable.Expr.Lambda(farg1, Fable.Expr.Lambda(farg2, fbody, _), _); listArg]
    | "reduce", [Fable.Expr.Delegate([farg1; farg2], fbody, _, _); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s    = mkListShape elemT consIdx
            let gen  = LabelGen("red")
            let ctx' = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
            let wBody = transform ctx' fbody
            let wList = transform ctx listArg
            Some(
                letVal gen "lst" s.BaseTy wList (fun lst ->
                letVal gen "nn" s.NonNullTy (s.CastNN lst) (fun nn ->
                    listFold gen s
                        (WExpr.StructGet(nn, 1, s.BaseTy))
                        (WExpr.StructGet(nn, 0, elemT))
                        elemT
                        (fun acc elem ->
                            WExpr.Let(farg1.Name, acc, WExpr.Let(farg2.Name, elem, wBody))))))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// map / mapIndexed
// ─────────────────────────────────────────────────────────────────

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
                let s    = mkListShape inputElemT inputConsIdx
                let rs   = mkListShape resultElemT resultConsIdx
                let gen  = LabelGen("map")
                let ctx' = ctx.WithLocal(farg.Name, inputElemT)
                let wBody = transform ctx' fbody
                let wList = transform ctx listArg
                Some(listMap gen s rs wList (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
            | _ -> None
        | None -> None
    | "mapIndexed", [(Fable.Expr.Lambda(iarg, Fable.Expr.Lambda(farg, fbody, _), _)
                   | Fable.Expr.Delegate([iarg; farg], fbody, _, _)); listArg] ->
        match seqElemType listArg.Type with
        | Some elemFableType ->
            let resultElemFableType = seqElemType resultFableType |> Option.defaultValue elemFableType
            match tryListTypeInfo ctx listArg, tryListTypeInfoFromElemType ctx resultElemFableType with
            | Some(inputElemT, inputConsIdx), Some(resultElemT, resultConsIdx) ->
                let s    = mkListShape inputElemT inputConsIdx
                let rs   = mkListShape resultElemT resultConsIdx
                let gen  = LabelGen("mapi")
                let ctx' = ctx.WithLocal(iarg.Name, WType.I32).WithLocal(farg.Name, inputElemT)
                let wBody = transform ctx' fbody
                let wList = transform ctx listArg
                Some(listMapi gen s rs wList
                        (fun idx elem -> WExpr.Let(iarg.Name, idx, WExpr.Let(farg.Name, elem, wBody))))
            | _ -> None
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// filter
// ─────────────────────────────────────────────────────────────────

let tryListFilterInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | "filter", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s     = mkListShape elemT consIdx
            let gen   = LabelGen("filt")
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            let wList = transform ctx listArg
            Some(listFilter gen s wList (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// iter / iterateIndexed
// ─────────────────────────────────────────────────────────────────

let tryListIterInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | ("iter" | "iterate"), [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s    = mkListShape elemT consIdx
            let gen  = LabelGen("iter")
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wBody = transform ctx' fbody
            let wList = transform ctx listArg
            Some(listIter gen s wList (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
        | None -> None
    | "iterateIndexed", [(Fable.Expr.Lambda(iarg, Fable.Expr.Lambda(farg, fbody, _), _)
                       | Fable.Expr.Delegate([iarg; farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s    = mkListShape elemT consIdx
            let gen  = LabelGen("iteri")
            let ctx' = ctx.WithLocal(iarg.Name, WType.I32).WithLocal(farg.Name, elemT)
            let wBody = transform ctx' fbody
            let wList = transform ctx listArg
            Some(listIteri gen s wList
                    (fun idx elem -> WExpr.Let(iarg.Name, idx, WExpr.Let(farg.Name, elem, wBody))))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// exists / forAll
// ─────────────────────────────────────────────────────────────────

let tryListExistsForAllInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | (("exists" | "forAll") as sel), [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s     = mkListShape elemT consIdx
            let gen   = LabelGen("exi")
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            let wList = transform ctx listArg
            let pred elem = WExpr.Let(farg.Name, elem, wPred)
            Some(if sel = "exists" then listExists gen s wList pred
                 else listForAll gen s wList pred)
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// collect (flatMap) / partition
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
                let sIn  = mkListShape inputElemT inputConsIdx
                let sOut = mkListShape outputElemT outputConsIdx
                let gen  = LabelGen("coll")
                let ctx' = ctx.WithLocal(farg.Name, inputElemT)
                let wBody = transform ctx' fbody
                let wList = transform ctx listArg
                let revResult =
                    listFold gen sIn wList sOut.Nil sOut.BaseTy
                        (fun acc outerElem ->
                            listFold gen sOut (WExpr.Let(farg.Name, outerElem, wBody)) acc sOut.BaseTy
                                (fun acc2 innerElem -> sOut.Cons innerElem acc2))
                Some(listRev gen sOut revResult)
            | _ -> None
        | None -> None
    | "partition", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match seqElemType listArg.Type with
        | Some elemFableT ->
            match tryListTypeInfo ctx listArg with
            | None -> None
            | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("part")
            let listFableT  = Fable.Type.List(elemFableT)
            let tupleFableT = Fable.Type.Tuple([listFableT; listFableT], false)
            let tupleWType  = mapTypeKnown ctx tupleFableT
            let listWT      = mapTypeKnown ctx listFableT
            let tupleIdx    =
                let key = wTypesKey [listWT; listWT]
                match ctx.TupleRegistry.TryGetValue(key) with
                | true, idx -> idx
                | _ -> failwith "List.partition: tuple not registered after mapTypeKnown"
            let tupleRefT = WType.Ref(tupleIdx, false)
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            let wList = transform ctx listArg
            Some(
                letMut gen "yes" s.BaseTy s.Nil (fun yes setYes ->
                letMut gen "no" s.BaseTy s.Nil (fun no setNo ->
                    sequence [
                        listIter gen s wList (fun elem ->
                            letVal gen "e" elemT elem (fun e ->
                                WExpr.If(WExpr.Let(farg.Name, e, wPred),
                                    setYes (s.Cons e yes),
                                    setNo (s.Cons e no),
                                    WType.Void)))
                        structNew tupleIdx [listRev gen s yes; listRev gen s no] tupleRefT
                    ])))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// choose (filter-map)
// ─────────────────────────────────────────────────────────────────

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
                let sIn  = mkListShape inputElemT inputConsIdx
                let sOut = mkListShape outputElemT outputConsIdx
                let gen  = LabelGen("cho")
                let ctx' = ctx.WithLocal(farg.Name, inputElemT)
                let wBody = transform ctx' fbody
                let wList = transform ctx listArg
                let wBodyType = mapTypeKnown ctx fbody.Type
                match wBodyType with
                | WType.Ref(optTypeIdx, _) ->
                    let optNullableT = WType.Ref(optTypeIdx, true)
                    let optNonNullT  = WType.Ref(optTypeIdx, false)
                    let revChosen =
                        listFold gen sIn wList sOut.Nil sOut.BaseTy
                            (fun acc elem ->
                                let optVar = gen.Next("opt")
                                WExpr.Let(optVar, WExpr.Let(farg.Name, elem, wBody),
                                    wasmIf (refIsNotNull (localGet optVar optNullableT))
                                        (sOut.Cons
                                            (structGet (cast (localGet optVar optNullableT) optNonNullT) 0 outputElemT)
                                            acc)
                                        acc))
                    Some(listRev gen sOut revChosen)
                | _ -> None
            | _ -> None
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// foldBack / sumBy / minBy / maxBy
// ─────────────────────────────────────────────────────────────────

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
            let s       = mkListShape elemT consIdx
            let gen     = LabelGen("fb")
            let resultT = mapTypeKnown ctx resultFableType
            let ctx'    = ctx.WithLocal(farg.Name, elemT).WithLocal(sacc.Name, resultT)
            let wBody   = transform ctx' fbody
            let wList   = transform ctx listArg
            let wInit   = transform ctx initArg
            let revList = listRev gen s wList
            Some(listFold gen s revList wInit resultT
                    (fun acc elem ->
                        WExpr.Let(farg.Name, elem, WExpr.Let(sacc.Name, acc, wBody))))
        | None -> None
    | _ -> None

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
            let s       = mkListShape elemT consIdx
            let gen     = LabelGen("sumby")
            let resultT = mapTypeKnown ctx resultFableType
            let ctx'    = ctx.WithLocal(farg.Name, elemT)
            let wProj   = transform ctx' fbody
            let wList   = transform ctx listArg
            Some(listFold gen s wList (makeNumericZero resultT) resultT
                    (fun acc elem ->
                        WExpr.Binary(WBinaryOp.Add, acc, WExpr.Let(farg.Name, elem, wProj), resultT)))
        | None -> None
    | _ -> None

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
            let s     = mkListShape elemT consIdx
            let gen   = LabelGen("mmby")
            let keyT  = mapTypeKnown ctx fbody.Type
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wKey  = transform ctx' fbody
            let wList = transform ctx listArg
            let cmpOp = if isMin then WCompareOp.LtS else WCompareOp.GtS
            Some(
                letVal gen "lst" s.BaseTy wList (fun lst ->
                letVal gen "nn" s.NonNullTy (s.CastNN lst) (fun nn ->
                    let headElem = WExpr.StructGet(nn, 0, elemT)
                    let headTail = WExpr.StructGet(nn, 1, s.BaseTy)
                    letMut gen "bestE" elemT headElem (fun bestE setBestE ->
                    letMut gen "bestK" keyT (WExpr.Let(farg.Name, headElem, wKey)) (fun bestK setBestK ->
                        sequence [
                            listIter gen s headTail (fun elem ->
                                letVal gen "e" elemT elem (fun e ->
                                letVal gen "k" keyT (WExpr.Let(farg.Name, e, wKey)) (fun k ->
                                    WExpr.If(WExpr.Compare(cmpOp, k, bestK),
                                        sequence [setBestE e; setBestK k],
                                        WExpr.Nop, WType.Void))))
                            bestE
                        ])))))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// init / replicate
// ─────────────────────────────────────────────────────────────────

let tryListInitReplicateInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
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
            let s     = mkListShape elemT consIdx
            let gen   = LabelGen("init")
            let wN    = transform ctx nArg
            let ctx'  = ctx.WithLocal(farg.Name, WType.I32)
            let wBody = transform ctx' fbody
            // Count DOWN from n-1 to 0, cons f(i) → forward order
            Some(
                letMut gen "i" WType.I32 (sub wN (i32Const 1)) (fun i setI ->
                letMut gen "acc" s.BaseTy s.Nil (fun acc setAcc ->
                    sequence [
                        whileLoop (gen.Next("lp")) (geS i (i32Const 0))
                            (sequence [
                                setAcc (s.Cons (WExpr.Let(farg.Name, i, wBody)) acc)
                                setI (sub i (i32Const 1))
                            ])
                        acc
                    ])))
    | "replicate", (nArg :: xArg :: _) ->
        match tryListTypeInfoFromElemType ctx xArg.Type with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("repl")
            let wN  = transform ctx nArg
            let wX  = transform ctx xArg
            Some(
                letVal gen "x" elemT wX (fun x ->
                letVal gen "n" WType.I32 wN (fun n ->
                letMut gen "i" WType.I32 (i32Const 0) (fun i setI ->
                letMut gen "acc" s.BaseTy s.Nil (fun acc setAcc ->
                    sequence [
                        whileLoop (gen.Next("lp")) (ltS i n)
                            (sequence [setAcc (s.Cons x acc); setI (add i (i32Const 1))])
                        acc
                    ])))))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// pairwise
// ─────────────────────────────────────────────────────────────────

let tryListPairwiseInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "pairwise", [listArg] ->
        let inputElemFT =
            match seqElemType listArg.Type with Some t -> t | None -> Fable.Type.Any
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        let pairFT   = Fable.Type.Tuple([inputElemFT; inputElemFT], false)
        let pairWT   = mapTypeKnown ctx pairFT
        let _        = mapTypeKnown ctx (Fable.Type.List(pairFT))
        match tryListTypeInfoFromElemType ctx pairFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sIn  = mkListShape elemWT inConsIdx
        let sOut = mkListShape pairWT outConsIdx
        let gen  = LabelGen("pw")
        let tupleIdx  = match pairWT with | WType.Ref(i, _) -> i | _ -> 0
        let tupleRefT = WType.Ref(tupleIdx, false)
        let wList     = transform ctx listArg
        Some(
            letVal gen "inp" sIn.BaseTy wList (fun inp ->
                wasmIf (WExpr.RefIsNull inp)
                    sOut.Nil
                    (letVal gen "nn" sIn.NonNullTy (sIn.CastNN inp) (fun nn ->
                        letMut gen "prev" elemWT (WExpr.StructGet(nn, 0, elemWT)) (fun prev setPrev ->
                            let revAcc =
                                listFold gen sIn (WExpr.StructGet(nn, 1, sIn.BaseTy)) sOut.Nil sOut.BaseTy
                                    (fun acc elem ->
                                        letVal gen "e" elemWT elem (fun e ->
                                        letVal gen "pair" tupleRefT (structNew tupleIdx [prev; e] tupleRefT) (fun pair ->
                                            WExpr.Sequence [setPrev e; sOut.Cons pair acc])))
                            listRev gen sOut revAcc)))))
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// countBy — I32 keys, parallel-array grouping
// ─────────────────────────────────────────────────────────────────

let tryListCountByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "countBy", ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        let keyWT = mapTypeKnown ctx fbody.Type
        if keyWT <> WType.I32 then None
        else
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        let sIn = mkListShape elemWT inConsIdx
        let gen = LabelGen("cntb")
        let intFT  = Fable.Type.Number(NumberKind.Int32, NumberInfo.Empty)
        let pairFT = Fable.Type.Tuple([fbody.Type; intFT], false)
        let pairWT = mapTypeKnown ctx pairFT
        let _      = mapTypeKnown ctx (Fable.Type.List(pairFT))
        match tryListTypeInfoFromElemType ctx pairFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sOut      = mkListShape pairWT outConsIdx
        let tupleIdx  = match pairWT with | WType.Ref(i, _) -> i | _ -> 0
        let tupleRefT = WType.Ref(tupleIdx, false)
        let capacity  = 64
        let i32ArrIdx  = getOrAddArrayType ctx WType.I32
        let i32ArrRefT = WType.Ref(i32ArrIdx, false)
        let wList = transform ctx listArg
        let ctx'  = ctx.WithLocal(farg.Name, elemWT)
        Some(
            letVal gen "keys" i32ArrRefT (arrayNew i32ArrIdx (i32Const capacity) (i32Const 0) i32ArrRefT) (fun keys ->
            letVal gen "cnts" i32ArrRefT (arrayNew i32ArrIdx (i32Const capacity) (i32Const 0) i32ArrRefT) (fun cnts ->
            letMut gen "n" WType.I32 (i32Const 0) (fun n setN ->
            letMut gen "k" WType.I32 (i32Const 0) (fun k setK ->
            letMut gen "i" WType.I32 (i32Const 0) (fun i setI ->
                let scanLbl = gen.Next("scan")
                let scanLoop =
                    sequence [
                        setI (i32Const 0)
                        WExpr.Loop(scanLbl,
                            wasmIf (ltS i n)
                                (wasmIf (eq (arrayGet keys i WType.I32) k)
                                    (arraySet cnts i (add (arrayGet cnts i WType.I32) (i32Const 1)))
                                    (sequence [setI (add i (i32Const 1)); continue_ scanLbl]))
                                (sequence [
                                    arraySet keys n k
                                    arraySet cnts n (i32Const 1)
                                    setN (add n (i32Const 1))
                                ]),
                            WType.Void)
                    ]
                sequence [
                    listIter gen sIn wList (fun elem ->
                        sequence [setK (WExpr.Let(farg.Name, elem, transform ctx' fbody)); scanLoop])
                    // Build result: walk from n-1 down to 0
                    letMut gen "ri" WType.I32 (sub n (i32Const 1)) (fun ri setRi ->
                    letMut gen "out" sOut.BaseTy sOut.Nil (fun out setOut ->
                        sequence [
                            whileLoop (gen.Next("bld")) (geS ri (i32Const 0))
                                (sequence [
                                    setOut (sOut.Cons
                                        (structNew tupleIdx
                                            [arrayGet keys ri WType.I32; arrayGet cnts ri WType.I32]
                                            tupleRefT)
                                        out)
                                    setRi (sub ri (i32Const 1))
                                ])
                            out
                        ]))
                ]))))))
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// groupBy — I32 keys, parallel-array grouping with element lists
// ─────────────────────────────────────────────────────────────────

let tryListGroupByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | ("groupBy" | "List_groupBy"), ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        let keyWT = mapTypeKnown ctx fbody.Type
        if keyWT <> WType.I32 then None
        else
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        let sIn = mkListShape elemWT inConsIdx
        let gen = LabelGen("gb")
        let listElemFT = match seqElemType listArg.Type with Some t -> t | None -> Fable.Type.Any
        let groupFT    = Fable.Type.List(listElemFT)
        let pairFT     = Fable.Type.Tuple([fbody.Type; groupFT], false)
        let pairWT     = mapTypeKnown ctx pairFT
        let _          = mapTypeKnown ctx (Fable.Type.List(pairFT))
        match tryListTypeInfoFromElemType ctx pairFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sOut      = mkListShape pairWT outConsIdx
        let tupleIdx  = match pairWT with | WType.Ref(i, _) -> i | _ -> 0
        let tupleRefT = WType.Ref(tupleIdx, false)
        let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
        let capacity  = 64
        let i32ArrIdx  = getOrAddArrayType ctx WType.I32
        let i32ArrRefT = WType.Ref(i32ArrIdx, false)
        let lbArrIdx   = getOrAddArrayType ctx listBaseRefT
        let lbArrRefT  = WType.Ref(lbArrIdx, false)
        let null_list  = WExpr.Const(WConst.Null listBaseRefT)
        let wList = transform ctx listArg
        let ctx'  = ctx.WithLocal(farg.Name, elemWT)
        Some(
            letVal gen "keys" i32ArrRefT (arrayNew i32ArrIdx (i32Const capacity) (i32Const 0) i32ArrRefT) (fun keys ->
            letVal gen "heads" lbArrRefT (arrayNew lbArrIdx (i32Const capacity) null_list lbArrRefT) (fun heads ->
            letMut gen "n" WType.I32 (i32Const 0) (fun n setN ->
            letMut gen "k" WType.I32 (i32Const 0) (fun k setK ->
            letMut gen "i" WType.I32 (i32Const 0) (fun i setI ->
                let scanLbl = gen.Next("scan")
                let scanLoop (elemExpr: WExpr) =
                    sequence [
                        setI (i32Const 0)
                        WExpr.Loop(scanLbl,
                            wasmIf (ltS i n)
                                (wasmIf (eq (arrayGet keys i WType.I32) k)
                                    // Found: prepend elem to group list
                                    (arraySet heads i
                                        (WExpr.StructNew(inConsIdx,
                                            [elemExpr; arrayGet heads i listBaseRefT],
                                            listBaseRefT)))
                                    (sequence [setI (add i (i32Const 1)); continue_ scanLbl]))
                                // New group
                                (sequence [
                                    arraySet keys n k
                                    arraySet heads n
                                        (WExpr.StructNew(inConsIdx, [elemExpr; null_list], listBaseRefT))
                                    setN (add n (i32Const 1))
                                ]),
                            WType.Void)
                    ]
                sequence [
                    listIter gen sIn wList (fun elem ->
                        WExpr.Let(farg.Name, elem,
                            sequence [
                                setK (transform ctx' fbody)
                                scanLoop (WExpr.LocalGet(farg.Name, elemWT))
                            ]))
                    // Build result: walk from n-1 down to 0, reversing each group
                    letMut gen "ri" WType.I32 (sub n (i32Const 1)) (fun ri setRi ->
                    letMut gen "out" sOut.BaseTy sOut.Nil (fun out setOut ->
                        sequence [
                            whileLoop (gen.Next("bld")) (geS ri (i32Const 0))
                                (let groupFwd = listRev gen sIn (arrayGet heads ri listBaseRefT)
                                 sequence [
                                    setOut (sOut.Cons
                                        (structNew tupleIdx
                                            [arrayGet keys ri WType.I32; groupFwd]
                                            tupleRefT)
                                        out)
                                    setRi (sub ri (i32Const 1))
                                ])
                            out
                        ]))
                ]))))))
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// distinct / distinctBy — I32 keys, seen-array
// ─────────────────────────────────────────────────────────────────

let tryListDistinctInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "distinct", (listArg :: _) ->
        let elemFT = match seqElemType listArg.Type with Some t -> t | None -> Fable.Type.Any
        let elemWT = mapTypeKnown ctx elemFT
        if elemWT <> WType.I32 then None
        else
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(_, inConsIdx) ->
        match tryListTypeInfoFromElemType ctx elemFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sIn  = mkListShape elemWT inConsIdx
        let sOut = mkListShape elemWT outConsIdx
        let gen  = LabelGen("dst")
        let capacity   = 64
        let i32ArrIdx  = getOrAddArrayType ctx WType.I32
        let i32ArrRefT = WType.Ref(i32ArrIdx, false)
        let wList = transform ctx listArg
        Some(
            letVal gen "seen" i32ArrRefT (arrayNew i32ArrIdx (i32Const capacity) (i32Const 0) i32ArrRefT) (fun seen ->
            letMut gen "n" WType.I32 (i32Const 0) (fun n setN ->
            letMut gen "i" WType.I32 (i32Const 0) (fun i setI ->
            letMut gen "e" WType.I32 (i32Const 0) (fun e setE ->
            letMut gen "rev" sOut.BaseTy sOut.Nil (fun rev setRev ->
                let scanLbl = gen.Next("scan")
                let scanLoop =
                    sequence [
                        setI (i32Const 0)
                        WExpr.Loop(scanLbl,
                            wasmIf (ltS i n)
                                (wasmIf (eq (arrayGet seen i WType.I32) e)
                                    WExpr.Nop  // found → leave i < n
                                    (sequence [setI (add i (i32Const 1)); continue_ scanLbl]))
                                WExpr.Nop,  // i >= n → done scanning
                            WType.Void)
                    ]
                sequence [
                    listIter gen sIn wList (fun elem ->
                        sequence [
                            setE elem
                            scanLoop
                            WExpr.If(eq i n,
                                sequence [
                                    arraySet seen n e
                                    setN (add n (i32Const 1))
                                    setRev (sOut.Cons e rev)
                                ],
                                WExpr.Nop, WType.Void)
                        ])
                    listRev gen sOut rev
                ]))))))
    | _ -> None

let tryListDistinctByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "List_distinctBy", ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        let keyWT = mapTypeKnown ctx fbody.Type
        if keyWT <> WType.I32 then None
        else
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        let elemFT = match seqElemType listArg.Type with Some t -> t | None -> Fable.Type.Any
        match tryListTypeInfoFromElemType ctx elemFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sIn  = mkListShape elemWT inConsIdx
        let sOut = mkListShape elemWT outConsIdx
        let gen  = LabelGen("dstby")
        let capacity   = 64
        let i32ArrIdx  = getOrAddArrayType ctx WType.I32
        let i32ArrRefT = WType.Ref(i32ArrIdx, false)
        let wList = transform ctx listArg
        let ctx'  = ctx.WithLocal(farg.Name, elemWT)
        Some(
            letVal gen "seen" i32ArrRefT (arrayNew i32ArrIdx (i32Const capacity) (i32Const 0) i32ArrRefT) (fun seen ->
            letMut gen "n" WType.I32 (i32Const 0) (fun n setN ->
            letMut gen "k" WType.I32 (i32Const 0) (fun k setK ->
            letMut gen "i" WType.I32 (i32Const 0) (fun i setI ->
            letMut gen "rev" sOut.BaseTy sOut.Nil (fun rev setRev ->
                let scanLbl = gen.Next("scan")
                let scanLoop =
                    sequence [
                        setI (i32Const 0)
                        WExpr.Loop(scanLbl,
                            wasmIf (ltS i n)
                                (wasmIf (eq (arrayGet seen i WType.I32) k)
                                    WExpr.Nop
                                    (sequence [setI (add i (i32Const 1)); continue_ scanLbl]))
                                WExpr.Nop,
                            WType.Void)
                    ]
                sequence [
                    listIter gen sIn wList (fun elem ->
                        WExpr.Let(farg.Name, elem,
                            sequence [
                                setK (transform ctx' fbody)
                                scanLoop
                                WExpr.If(eq i n,
                                    sequence [
                                        arraySet seen n k
                                        setN (add n (i32Const 1))
                                        setRev (sOut.Cons (WExpr.LocalGet(farg.Name, elemWT)) rev)
                                    ],
                                    WExpr.Nop, WType.Void)
                            ]))
                    listRev gen sOut rev
                ]))))))
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// unzip
// ─────────────────────────────────────────────────────────────────

let tryListUnzipInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "unzip", [listArg] ->
        let inputElemFT = seqElemType listArg.Type
        match inputElemFT with
        | Some(Fable.Type.Tuple([ta; tb], _)) ->
            match tryListTypeInfo ctx listArg,
                  tryListTypeInfoFromElemType ctx ta,
                  tryListTypeInfoFromElemType ctx tb with
            | Some(pairT, pairConsIdx),
              Some(aElemT, aConsIdx),
              Some(bElemT, bConsIdx) ->
                let sIn = mkListShape pairT pairConsIdx
                let sA  = mkListShape aElemT aConsIdx
                let sB  = mkListShape bElemT bConsIdx
                let gen = LabelGen("unz")
                let wList = transform ctx listArg
                // Register output tuple type
                let listAWT = mapTypeKnown ctx (Fable.Type.List(ta))
                let listBWT = mapTypeKnown ctx (Fable.Type.List(tb))
                let _ = mapTypeKnown ctx (Fable.Type.Tuple([Fable.Type.List(ta); Fable.Type.List(tb)], false))
                let tupleKey = wTypesKey [listAWT; listBWT]
                match ctx.TupleRegistry.TryGetValue(tupleKey) with
                | false, _ -> None
                | true, resultTupleIdx ->
                let resultTupleRefT = WType.Ref(resultTupleIdx, false)
                // Fold: accumulate reversed 'a list; side-effect build reversed 'b list
                Some(
                    letMut gen "bRev" sB.BaseTy sB.Nil (fun bRev setBRev ->
                        let aRev =
                            listFold gen sIn wList sA.Nil sA.BaseTy
                                (fun aAcc pair ->
                                    letVal gen "p" pairT pair (fun p ->
                                        WExpr.Sequence [
                                            setBRev (sB.Cons (structGet p 1 bElemT) bRev)
                                            sA.Cons (structGet p 0 aElemT) aAcc
                                        ]))
                        structNew resultTupleIdx
                            [listRev gen sA aRev; listRev gen sB bRev]
                            resultTupleRefT))
            | _ -> None
        | _ -> None
    | _ -> None
