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
open Fable.Transforms.WasmGc.WasmGcEquality

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
            Some(wasm {
                let! lst = wList
                let! nn = s.CastNN lst
                return! listFold gen s
                    (WExpr.StructGet(nn, 1, s.BaseTy))
                    (WExpr.StructGet(nn, 0, elemT))
                    elemT
                    (fun acc elem ->
                        WExpr.Let(farg1.Name, acc, WExpr.Let(farg2.Name, elem, wBody)))
            })
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
            Some(wasm {
                let! yes = mutTy s.BaseTy s.Nil
                let! no = mutTy s.BaseTy s.Nil
                do! listIter gen s wList (fun elem ->
                    wasm {
                        let! e = elem
                        return! WExpr.If(WExpr.Let(farg.Name, e, wPred),
                            yes.Set(s.Cons e yes.Val),
                            no.Set(s.Cons e no.Val),
                            WType.Void)
                    })
                return structNew tupleIdx [listRev gen s yes.Val; listRev gen s no.Val] tupleRefT
            })
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
            Some(wasm {
                let! lst = wList
                let! nn = s.CastNN lst
                let headElem = WExpr.StructGet(nn, 0, elemT)
                let headTail = WExpr.StructGet(nn, 1, s.BaseTy)
                let! bestE = mutTy elemT headElem
                let! bestK = mutTy keyT (WExpr.Let(farg.Name, headElem, wKey))
                do! listIter gen s headTail (fun elem ->
                    wasm {
                        let! e = elem
                        let! k = WExpr.Let(farg.Name, e, wKey)
                        return! WExpr.If(WExpr.Compare(cmpOp, k, bestK.Val),
                            WExpr.Sequence [bestE.Set e; bestK.Set k],
                            WExpr.Nop, WType.Void)
                    })
                return bestE.Val
            })
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
            Some(wasm {
                let! i = mut (sub wN (i32Const 1))
                let! acc = mutTy s.BaseTy s.Nil
                while! (geS i.Val (i32Const 0)) do
                    do! acc.Set(s.Cons (WExpr.Let(farg.Name, i.Val, wBody)) acc.Val)
                    do! i.Set(sub i.Val (i32Const 1))
                return acc.Val
            })
    | "replicate", (nArg :: xArg :: _) ->
        match tryListTypeInfoFromElemType ctx xArg.Type with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("repl")
            let wN  = transform ctx nArg
            let wX  = transform ctx xArg
            Some(wasm {
                let! x = wX
                let! n = wN
                let! i = mut (i32Const 0)
                let! acc = mutTy s.BaseTy s.Nil
                while! (ltS i.Val n) do
                    do! acc.Set(s.Cons x acc.Val)
                    do! i.Set(add i.Val (i32Const 1))
                return acc.Val
            })
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
        Some(wasm {
            let! inp = wList
            return! wasmIf (WExpr.RefIsNull inp)
                sOut.Nil
                (wasm {
                    let! nn = sIn.CastNN inp
                    let! prev = mutTy elemWT (WExpr.StructGet(nn, 0, elemWT))
                    let revAcc =
                        listFold gen sIn (WExpr.StructGet(nn, 1, sIn.BaseTy)) sOut.Nil sOut.BaseTy
                            (fun acc elem ->
                                wasm {
                                    let! e = elem
                                    let! pair = structNew tupleIdx [prev.Val; e] tupleRefT
                                    do! prev.Set e
                                    return sOut.Cons pair acc
                                })
                    return! listRev gen sOut revAcc
                })
        })
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// countBy — any key type, list-of-pairs accumulator with fold-rebuild
// ─────────────────────────────────────────────────────────────────

let tryListCountByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "countBy", ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        let sIn  = mkListShape elemWT inConsIdx
        let gen  = LabelGen("cntb")
        let intFT  = Fable.Type.Number(NumberKind.Int32, NumberInfo.Empty)
        let keyFT  = fbody.Type
        let keyWT  = mapTypeKnown ctx keyFT
        let pairFT = Fable.Type.Tuple([keyFT; intFT], false)
        let pairWT = mapTypeKnown ctx pairFT
        let _      = mapTypeKnown ctx (Fable.Type.List(pairFT))
        match tryListTypeInfoFromElemType ctx pairFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sOut      = mkListShape pairWT outConsIdx
        let tupleIdx  = match pairWT with | WType.Ref(i, _) -> i | _ -> 0
        let tupleRefT = WType.Ref(tupleIdx, false)
        let wList = transform ctx listArg
        let ctx'  = ctx.WithLocal(farg.Name, elemWT)
        Some(wasm {
            let! acc        = mutTy sOut.BaseTy sOut.Nil
            let! rebuiltRev = mutTy sOut.BaseTy sOut.Nil
            let! found      = mut (i32Const 0)
            do! listIter gen sIn wList (fun elem ->
                WExpr.Let(farg.Name, elem,
                    let kv = gen.Next("k")
                    WExpr.Let(kv, transform ctx' fbody,
                        let k  = WExpr.LocalGet(kv, keyWT)
                        let rv = gen.Next("rv")
                        sequence [
                            found.Set(i32Const 0)
                            rebuiltRev.Set(
                                listFold gen sOut acc.Val sOut.Nil sOut.BaseTy
                                    (fun revAcc pairElem ->
                                        let pKey = WExpr.StructGet(pairElem, 0, keyWT)
                                        let pCnt = WExpr.StructGet(pairElem, 1, WType.I32)
                                        wasmIf
                                            (and_
                                                (WExpr.Unary(WUnaryOp.Eqz, found.Val, WType.I32))
                                                (compareByWType ctx keyWT pKey k))
                                            (sequence [
                                                found.Set(i32Const 1)
                                                sOut.Cons
                                                    (WExpr.StructNew(tupleIdx,
                                                        [pKey; add pCnt (i32Const 1)],
                                                        tupleRefT))
                                                    revAcc
                                            ])
                                            (sOut.Cons pairElem revAcc)))
                            WExpr.Let(rv, listRev gen sOut rebuiltRev.Val,
                                acc.Set(
                                    wasmIf found.Val
                                        (WExpr.LocalGet(rv, sOut.BaseTy))
                                        (sOut.Cons
                                            (WExpr.StructNew(tupleIdx, [k; i32Const 1], tupleRefT))
                                            (WExpr.LocalGet(rv, sOut.BaseTy)))))
                        ])))
            return! listRev gen sOut acc.Val
        })
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// groupBy — any key type, list-of-pairs accumulator with fold-rebuild
// ─────────────────────────────────────────────────────────────────

let tryListGroupByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | ("groupBy" | "List_groupBy"), ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        let sIn = mkListShape elemWT inConsIdx
        let gen = LabelGen("gb")
        let listElemFT = match seqElemType listArg.Type with Some t -> t | None -> Fable.Type.Any
        let groupFT    = Fable.Type.List(listElemFT)
        let keyFT      = fbody.Type
        let keyWT      = mapTypeKnown ctx keyFT
        let pairFT     = Fable.Type.Tuple([keyFT; groupFT], false)
        let pairWT     = mapTypeKnown ctx pairFT
        let _          = mapTypeKnown ctx (Fable.Type.List(pairFT))
        match tryListTypeInfoFromElemType ctx pairFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sOut      = mkListShape pairWT outConsIdx
        let tupleIdx  = match pairWT with | WType.Ref(i, _) -> i | _ -> 0
        let tupleRefT = WType.Ref(tupleIdx, false)
        let groupWT   = sIn.BaseTy  // Ref(ListBaseTypeIdx, true)
        let wList     = transform ctx listArg
        let ctx'      = ctx.WithLocal(farg.Name, elemWT)
        Some(wasm {
            let! acc        = mutTy sOut.BaseTy sOut.Nil
            let! rebuiltRev = mutTy sOut.BaseTy sOut.Nil
            let! found      = mut (i32Const 0)
            do! listIter gen sIn wList (fun elem ->
                WExpr.Let(farg.Name, elem,
                    let e  = WExpr.LocalGet(farg.Name, elemWT)
                    let kv = gen.Next("k")
                    WExpr.Let(kv, transform ctx' fbody,
                        let k  = WExpr.LocalGet(kv, keyWT)
                        let rv = gen.Next("rv")
                        sequence [
                            found.Set(i32Const 0)
                            rebuiltRev.Set(
                                listFold gen sOut acc.Val sOut.Nil sOut.BaseTy
                                    (fun revAcc pairElem ->
                                        let pKey = WExpr.StructGet(pairElem, 0, keyWT)
                                        let pGrp = WExpr.StructGet(pairElem, 1, groupWT)
                                        wasmIf
                                            (and_
                                                (WExpr.Unary(WUnaryOp.Eqz, found.Val, WType.I32))
                                                (compareByWType ctx keyWT pKey k))
                                            (sequence [
                                                found.Set(i32Const 1)
                                                sOut.Cons
                                                    (WExpr.StructNew(tupleIdx,
                                                        [pKey; sIn.Cons e pGrp],
                                                        tupleRefT))
                                                    revAcc
                                            ])
                                            (sOut.Cons pairElem revAcc)))
                            WExpr.Let(rv, listRev gen sOut rebuiltRev.Val,
                                acc.Set(
                                    wasmIf found.Val
                                        (WExpr.LocalGet(rv, sOut.BaseTy))
                                        (sOut.Cons
                                            (WExpr.StructNew(tupleIdx,
                                                [k; sIn.Cons e sIn.Nil],
                                                tupleRefT))
                                            (WExpr.LocalGet(rv, sOut.BaseTy)))))
                        ])))
            // Reverse the accumulator (to restore first-seen order) and reverse each group list.
            let! out = mutTy sOut.BaseTy sOut.Nil
            do! listIter gen sOut acc.Val (fun pairElem ->
                let pKey = WExpr.StructGet(pairElem, 0, keyWT)
                let pGrp = WExpr.StructGet(pairElem, 1, groupWT)
                out.Set(sOut.Cons
                    (WExpr.StructNew(tupleIdx, [pKey; listRev gen sIn pGrp], tupleRefT))
                    out.Val))
            return out.Val
        })
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// distinct / distinctBy — any element/key type, list-based seen set
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
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        match tryListTypeInfoFromElemType ctx elemFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let sIn  = mkListShape elemWT inConsIdx
        let sOut = mkListShape elemWT outConsIdx
        let gen  = LabelGen("dst")
        let wList = transform ctx listArg
        Some(wasm {
            let! rev  = mutTy sOut.BaseTy sOut.Nil
            let! seen = mutTy sIn.BaseTy  sIn.Nil
            do! listIter gen sIn wList (fun elem ->
                let lv = gen.Next("de")
                WExpr.Let(lv, elem,
                    let e = WExpr.LocalGet(lv, elemWT)
                    wasmIf
                        (listExists gen sIn seen.Val (fun sv -> compareByWType ctx elemWT sv e))
                        WExpr.Nop
                        (sequence [
                            seen.Set(sIn.Cons e seen.Val)
                            rev.Set(sOut.Cons e rev.Val)
                        ])))
            return! listRev gen sOut rev.Val
        })
    | _ -> None

let tryListDistinctByInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "List_distinctBy", ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemWT, inConsIdx) ->
        let elemFT = match seqElemType listArg.Type with Some t -> t | None -> Fable.Type.Any
        match tryListTypeInfoFromElemType ctx elemFT with
        | None -> None
        | Some(_, outConsIdx) ->
        let keyFT = fbody.Type
        match tryListTypeInfoFromElemType ctx keyFT with
        | None -> None
        | Some(keyWT, keyConsIdx) ->
        let sIn  = mkListShape elemWT inConsIdx
        let sOut = mkListShape elemWT outConsIdx
        let sKey = mkListShape keyWT  keyConsIdx
        let gen  = LabelGen("dstby")
        let wList = transform ctx listArg
        let ctx'  = ctx.WithLocal(farg.Name, elemWT)
        Some(wasm {
            let! rev  = mutTy sOut.BaseTy sOut.Nil
            let! seen = mutTy sKey.BaseTy sKey.Nil
            do! listIter gen sIn wList (fun elem ->
                WExpr.Let(farg.Name, elem,
                    let e  = WExpr.LocalGet(farg.Name, elemWT)
                    let kv = gen.Next("dk")
                    WExpr.Let(kv, transform ctx' fbody,
                        let k = WExpr.LocalGet(kv, keyWT)
                        wasmIf
                            (listExists gen sKey seen.Val (fun sv -> compareByWType ctx keyWT sv k))
                            WExpr.Nop
                            (sequence [
                                seen.Set(sKey.Cons k seen.Val)
                                rev.Set(sOut.Cons e rev.Val)
                            ]))))
            return! listRev gen sOut rev.Val
        })
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
                Some(wasm {
                    let! bRev = mutTy sB.BaseTy sB.Nil
                    let aRev =
                        listFold gen sIn wList sA.Nil sA.BaseTy
                            (fun aAcc pair ->
                                wasm {
                                    let! p = pair
                                    do! bRev.Set(sB.Cons (structGet p 1 bElemT) bRev.Val)
                                    return sA.Cons (structGet p 0 aElemT) aAcc
                                })
                    return structNew resultTupleIdx
                        [listRev gen sA aRev; listRev gen sB bRev.Val]
                        resultTupleRefT
                })
            | _ -> None
        | _ -> None
    | _ -> None
