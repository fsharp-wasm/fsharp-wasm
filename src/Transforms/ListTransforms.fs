/// WasmGC inline replacements for List higher-order function HOF operations.
/// Full FableQuery DSL integration — no Fable.Expr.Lambda inline patterns.
/// Uses high-level combinators from WasmGcLoopCombinators for clean, composable code.
module WasmGc.Transforms.ListTransforms

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core
open WasmGc.Runtime.Equality

open WasmGc.Runtime.Runtime
open WasmGc.Runtime.LoopHelpers
open WasmGc.Runtime.LoopPrimitives

open WasmGc.Patterns.ListShape
open WasmGc.Patterns.ListPatterns
open WasmGc.Patterns.ArrayOps

open WasmGc.Util.FableQuery   // ← all DSL patterns

// ─────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────

/// Extract only the element Fable.Type shape for list-like sequence signatures:
/// - Fable.Type.List<T>
/// - Fable.Type.DeclaredType(_, [T])  (seq<T> / IEnumerable<T>-style signatures)
///
/// Boundary note:
/// - This helper does NOT resolve Wasm list registry info (use LoopHelpers.tryListTypeInfo for that).
/// - This helper does NOT handle arrays (use ArrayReplacements.getArrElemT for Fable.Type.Array<T,_>).
let private seqElemType (t: Fable.Type) : Fable.Type option =
    match t with
    | Fable.Type.List e               -> Some e
    | Fable.Type.DeclaredType(_, [e]) -> Some e
    | _                               -> None

let private listElemTypes ctx (listArg: Fable.Expr) (resultType: Fable.Type) =
    match seqElemType listArg.Type, seqElemType resultType with
    | Some inET, Some outET ->
        match tryListTypeInfo ctx listArg, tryListTypeInfoFromElemType ctx outET with
        | Some(inT, inIdx), Some(outT, outIdx) -> Some(inT, inIdx, outT, outIdx)
        | _ -> None
    | _ -> None

let private withElem (ctx: Ctx) (farg: Ident) elemT = ctx.WithLocal(farg.Name, elemT)
let private withElems (ctx: Ctx) (a: Ident) ta (b: Ident) tb = ctx.WithLocal(a.Name, ta).WithLocal(b.Name, tb)

// ─────────────────────────────────────────────────────────────────
// fold / reduce
// ─────────────────────────────────────────────────────────────────

let tryListFoldInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | "fold", FoldArgs(farg1, farg2, fbody, initArg, listArg) ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s    = mkListShape elemT consIdx
            let accT = mapTypeKnown ctx initArg.Type
            let wBody = transform (withElems ctx farg1 accT farg2 elemT) fbody
            Some(listFold (LabelGen "fold") s (transform ctx listArg) (transform ctx initArg) accT
                    (fun acc elem -> WExpr.Let(farg1.Name, acc, WExpr.Let(farg2.Name, elem, wBody))))
        | None -> None

    | "reduce", [BinaryLambda(farg1, farg2, fbody); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s     = mkListShape elemT consIdx
            let wBody = transform (withElems ctx farg1 elemT farg2 elemT) fbody
            Some(wasm {
                let! lst = transform ctx listArg
                let! nn  = s.CastNN lst
                return! listFold (LabelGen "red") s
                    (WExpr.StructGet(nn, 1, s.BaseTy))
                    (WExpr.StructGet(nn, 0, elemT))
                    elemT
                    (fun acc elem -> WExpr.Let(farg1.Name, acc, WExpr.Let(farg2.Name, elem, wBody)))
            })
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// map / mapi (mapIndexed)
// ─────────────────────────────────────────────────────────────────

let tryListMapInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "map", [UnaryLambda(farg, fbody); listArg] ->
        match listElemTypes ctx listArg resultFableType with
        | Some(inT, inIdx, outT, outIdx) ->
            let wBody = transform (withElem ctx farg inT) fbody
            Some(listMap (LabelGen "map")
                    (mkListShape inT inIdx) (mkListShape outT outIdx)
                    (transform ctx listArg)
                    (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
        | None -> None

    | "mapIndexed", [BinaryLambda(iarg, farg, fbody); listArg] ->
        match listElemTypes ctx listArg resultFableType with
        | Some(inT, inIdx, outT, outIdx) ->
            let wBody = transform (withElems ctx iarg WType.I32 farg inT) fbody
            Some(listMapi (LabelGen "mapi")
                    (mkListShape inT inIdx) (mkListShape outT outIdx)
                    (transform ctx listArg)
                    (fun idx elem -> WExpr.Let(iarg.Name, idx, WExpr.Let(farg.Name, elem, wBody))))
        | None -> None
    | _ -> None

/// List.indexed xs = List.mapi (fun i x -> (i, x)) xs
let tryListIndexedInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "indexed", [ listArg ] ->
        match listArg.Type with
        | Fable.Type.List elemT ->
            let ident name t : Fable.Ident =
                { Name = name; Type = t; IsMutable = false; IsThisArgument = false
                  IsCompilerGenerated = true; IsInlineIfLambda = false; Range = None }
            let index = ident "index$" (Fable.Type.Number(NumberKind.Int32, NumberInfo.Empty))
            let elem = ident "elem$" elemT
            let pair = Fable.Expr.Value(Fable.ValueKind.NewTuple([ Fable.Expr.IdentExpr index; Fable.Expr.IdentExpr elem ], false), None)
            tryListMapInline transform ctx "mapIndexed" [ Fable.Expr.Delegate([ index; elem ], pair, None, []); listArg ] resultFableType
        | _ -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// filter / choose
// ─────────────────────────────────────────────────────────────────

let tryListFilterInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | "filter", [UnaryLambda(farg, fbody); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s     = mkListShape elemT consIdx
            let wPred = transform (withElem ctx farg elemT) fbody
            Some(listFilter (LabelGen "filt") s (transform ctx listArg)
                    (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None

    | "choose", [UnaryLambda(farg, fbody); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let resultElemFableT = seqElemType fbody.Type |> Option.defaultValue Fable.Type.Any
            match tryListTypeInfoFromElemType ctx resultElemFableT with
            | Some(outElemT, outConsIdx) ->
                let s     = mkListShape elemT consIdx
                let rs    = mkListShape outElemT outConsIdx
                let wBody = transform (withElem ctx farg elemT) fbody
                Some(listChoose (LabelGen "choo") s rs (transform ctx listArg)
                        (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
            | None -> None
        | None -> None

    | _ -> None

// ─────────────────────────────────────────────────────────────────
// iter / iteri (iterateIndexed)
// ─────────────────────────────────────────────────────────────────

let tryListIterInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | ("iter" | "iterate"), [UnaryLambda(farg, fbody); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s     = mkListShape elemT consIdx
            let wBody = transform (withElem ctx farg elemT) fbody
            Some(listIter (LabelGen "iter") s (transform ctx listArg)
                    (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
        | None -> None

    | "iterateIndexed", [BinaryLambda(iarg, farg, fbody); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s     = mkListShape elemT consIdx
            let wBody = transform (withElems ctx iarg WType.I32 farg elemT) fbody
            Some(listIteri (LabelGen "iteri") s (transform ctx listArg)
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
    | (("exists" | "forAll") as sel), [UnaryLambda(farg, fbody); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s     = mkListShape elemT consIdx
            let wPred = transform (withElem ctx farg elemT) fbody
            let pred  = fun elem -> WExpr.Let(farg.Name, elem, wPred)
            Some(if sel = "exists"
                 then listExists  (LabelGen "exi") s (transform ctx listArg) pred
                 else listForAll  (LabelGen "all") s (transform ctx listArg) pred)
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// collect (flatMap) / concat / append / partition
// ─────────────────────────────────────────────────────────────────

let tryListCollectInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "collect", [UnaryLambda(farg, fbody); listArg] ->
        match tryListTypeInfo ctx listArg, seqElemType resultFableType with
        | Some(inElemT, inConsIdx), Some outElemFableT ->
            match tryListTypeInfoFromElemType ctx outElemFableT with
            | Some(outElemT, outConsIdx) ->
                let s     = mkListShape inElemT inConsIdx
                let rs    = mkListShape outElemT outConsIdx
                let wBody = transform (withElem ctx farg inElemT) fbody
                Some(listCollect (LabelGen "coll") s rs (transform ctx listArg)
                        (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
            | None -> None
        | _ -> None
    // TODO: obsolete or still useful? 
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
                    return structNew tupleIdx [listRevInPlace gen s yes.Val; listRevInPlace gen s no.Val] tupleRefT
                })
        | None -> None
    | "concat", [listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(innerListT, _) ->
            match innerListT with
            | WType.Ref(innerConsIdx, _) ->
                // list<list<T>> → flatten
                match seqElemType listArg.Type |> Option.bind (seqElemType) with
                | Some innerElemFableT ->
                    let innerElemT = mapTypeKnown ctx innerElemFableT
                    let s = mkListShape (WType.Ref(innerConsIdx, true)) innerConsIdx
                    Some(listConcat (LabelGen "cat") s (transform ctx listArg) innerElemT innerConsIdx)
                | None -> None
            | _ -> None
        | None -> None

    | "append", [listArg1; listArg2] ->
        match tryListTypeInfo ctx listArg1 with
        | Some(elemT, consIdx) ->
            let s = mkListShape elemT consIdx
            Some(listAppend (LabelGen "app") s (transform ctx listArg1) (transform ctx listArg2))
        | None -> None
    | _ -> None


// TODO: all below has to be checked if still useful or moved
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
                                            (OptionResultTransforms.unwrapSome (localGet optVar optNullableT) optTypeIdx outputElemT)
                                            acc)
                                        acc))
                    Some(listRevInPlace gen sOut revChosen)
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
                        checkedAdd acc (WExpr.Let(farg.Name, elem, wProj)) resultT))
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
                do! wasmWhen (ltS n (i32Const 0)) (WExpr.Throw WExpr.Nop)      // ArgumentException
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
                    return! listRevInPlace gen sOut revAcc
                })
        })
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// windowed — sliding windows over an array copy, built back to front so the outer list needs no reverse
// ─────────────────────────────────────────────────────────────────

let tryListWindowedInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, fableArgs with
    | "windowed", [sizeArg; listArg] ->
        let elemFT = match seqElemType listArg.Type with Some t -> t | None -> Fable.Type.Any
        let windowFT = Fable.Type.List elemFT
        let windowWT = mapTypeKnown ctx windowFT
        match tryListTypeInfo ctx listArg, tryListTypeInfoFromElemType ctx windowFT with
        | Some(elemWT, inConsIdx), Some(_, outConsIdx) ->
            let sIn, sOut = mkListShape elemWT inConsIdx, mkListShape windowWT outConsIdx
            let arrTypeIdx = getOrAddArrayType ctx elemWT
            let a = mkArrayShape elemWT arrTypeIdx
            let gen = LabelGen("win")
            Some(wasm {
                let! size = transform ctx sizeArg
                let! lst = transform ctx listArg
                do! wasmWhen (ltS size (i32Const 1)) (WExpr.Throw WExpr.Nop)       // ArgumentException
                let! len = listLength gen sIn lst
                let! arr = arrayNew arrTypeIdx len (makeNumericZero elemWT) (WType.Ref(arrTypeIdx, false))
                do! listFold gen sIn lst (i32Const 0) WType.I32
                        (fun idx elem -> sequence [ a.Set(arr, idx, elem); add idx (i32Const 1) ])
                let! acc = mutTy sOut.BaseTy sOut.Nil
                let! start = mut (sub len size)
                while! (geS start.Val (i32Const 0)) do
                    let! win = mutTy sIn.BaseTy sIn.Nil
                    let! j = mut (sub (add start.Val size) (i32Const 1))
                    while! (geS j.Val start.Val) do
                        do! win.Set(sIn.Cons (a.Get(arr, j.Val)) win.Val)
                        do! j.Set(sub j.Val (i32Const 1))
                    do! acc.Set(sOut.Cons win.Val acc.Val)
                    do! start.Set(sub start.Val (i32Const 1))
                return acc.Val
            })
        | _ -> None
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
                            WExpr.Let(rv, listRevInPlace gen sOut rebuiltRev.Val,
                                acc.Set(
                                    wasmIf found.Val
                                        (WExpr.LocalGet(rv, sOut.BaseTy))
                                        (sOut.Cons
                                            (WExpr.StructNew(tupleIdx, [k; i32Const 1], tupleRefT))
                                            (WExpr.LocalGet(rv, sOut.BaseTy)))))
                        ])))
            return! listRevInPlace gen sOut acc.Val
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
                            WExpr.Let(rv, listRevInPlace gen sOut rebuiltRev.Val,
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
    | ("distinct" | "List_distinct"), (listArg :: _) ->
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
            return! listRevInPlace gen sOut rev.Val
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
            return! listRevInPlace gen sOut rev.Val
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
                        [listRevInPlace gen sA aRev; listRevInPlace gen sB bRev.Val]
                        resultTupleRefT
                })
            | _ -> None
        | _ -> None
    | _ -> None


// ─────────────────────────────────────────────────────────────────────────────
// Unified entry point — chains all List.* dispatch functions
// ─────────────────────────────────────────────────────────────────────────────

/// Primary dispatch: routes any List.* selector to the correct handler.
/// Returns None if the selector is not handled by any combinator.
let tryListInline
        (transform       : TransformFn)
        (ctx             : Ctx)
        (selector        : string)
        (fableArgs       : Fable.Expr list)
        (resultFableType : Fable.Type)
        : WExpr option =
    // Some functions take resultFableType, others don't. Adapt each call.
    tryListFoldInline transform ctx selector fableArgs
    |> Option.orElseWith (fun () -> tryListMapInline transform ctx selector fableArgs resultFableType)
    |> Option.orElseWith (fun () -> tryListCollectInline transform ctx selector fableArgs resultFableType)
    |> Option.orElseWith (fun () -> tryListFilterInline transform ctx selector fableArgs)
    |> Option.orElseWith (fun () -> tryListIterInline transform ctx selector fableArgs)
    // TODO: tryListSortInline, tryListQueryInline, tryListUtilInline not yet implemented
