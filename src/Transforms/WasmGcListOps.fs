/// WasmGC inline replacements for List operations: sort, take, skip, partition,
/// primitives (head, tail, length, rev, append, nth, isEmpty, ofArray, toArray),
/// tryHead, tryFind, tryFindIndex, findIndex, and List.range.
module Fable.Transforms.WasmGc.WasmGcListOps

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder
open Fable.Transforms.WasmGc.WasmGcRuntime
open Fable.Transforms.WasmGc.WasmGcLoopHelpers
open Fable.Transforms.WasmGc.WasmGcLoopCombinators

let tryListTakeSkipSortInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    // ── List.skip n xs ─────────────────────────────────────────────
    | "skip", (nArg :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("skip")
            let wN   = transform ctx nArg
            let wLst = transform ctx listArg
            Some(
                letMut gen "n" WType.I32 wN (fun n setN ->
                letMut gen "ptr" s.BaseTy wLst (fun ptr setPtr ->
                    sequence [
                        whileLoop (gen.Next("lp"))
                            (wasmAnd (gtS n (i32Const 0)) (refIsNotNull ptr))
                            (sequence [setPtr (s.Tail ptr); setN (sub n (i32Const 1))])
                        ptr
                    ])))
        | None -> None
    // ── List.take n xs ─────────────────────────────────────────────
    | "take", (nArg :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("take")
            let wN   = transform ctx nArg
            let wLst = transform ctx listArg
            // Phase 1: collect first n elements reversed
            let revCollect =
                letMut gen "n" WType.I32 wN (fun n setN ->
                letMut gen "ptr" s.BaseTy wLst (fun ptr setPtr ->
                letMut gen "acc" s.BaseTy s.Nil (fun acc setAcc ->
                    sequence [
                        whileLoop (gen.Next("lp"))
                            (wasmAnd (gtS n (i32Const 0)) (refIsNotNull ptr))
                            (sequence [
                                setAcc (s.Cons (s.Head ptr) acc)
                                setPtr (s.Tail ptr)
                                setN (sub n (i32Const 1))
                            ])
                        acc
                    ])))
            // Phase 2: reverse
            Some(listRev gen s revCollect)
        | None -> None
    // ── List.sortBy / List.sortByDescending ────────────────────────
    | ("sortBy" | "sortByDescending"),
        ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _,  _)) :: listArg :: _) ->
        let descending = selector = "sortByDescending"
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemT, consIdx) ->
        let s   = mkListShape elemT consIdx
        let gen = LabelGen("lsby")
        let keyT       = mapTypeKnown ctx fbody.Type
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let keyArrIdx  = getOrAddArrayType ctx keyT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let keyArrRefT = WType.Ref(keyArrIdx, false)
        let ctx' = ctx.WithLocal(farg.Name, elemT)
        let wKey = transform ctx' fbody
        let wLst = transform ctx listArg
        let cmpOp = if descending then WCompareOp.GtS else WCompareOp.LtS
        Some(
            letVal gen "lst" s.BaseTy wLst (fun lst ->
            letVal gen "len" WType.I32 (listLength gen s lst) (fun len ->
            letVal gen "arr" arrRefT (arrayNew arrTypeIdx len (makeNumericZero elemT) arrRefT) (fun arr ->
            letVal gen "key" keyArrRefT (arrayNew keyArrIdx len (makeNumericZero keyT) keyArrRefT) (fun keyArr ->
                // Fill arrays
                let fillPhase =
                    listFold gen s lst (i32Const 0) WType.I32
                        (fun idx elem ->
                            letVal gen "fe" elemT elem (fun fe ->
                            letVal gen "fk" keyT (WExpr.Let(farg.Name, fe, wKey)) (fun fk ->
                                sequence [
                                    arraySet arr idx fe
                                    arraySet keyArr idx fk
                                    add idx (i32Const 1)
                                ])))
                // Insertion sort on key array
                let sortPhase =
                    letMut gen "si" WType.I32 (i32Const 1) (fun si setSi ->
                        whileLoop (gen.Next("sil")) (ltS si len)
                            (letVal gen "se" elemT (arrayGet arr si elemT) (fun se ->
                            letVal gen "sk" keyT (arrayGet keyArr si keyT) (fun sk ->
                            letMut gen "sj" WType.I32 (sub si (i32Const 1)) (fun sj setSj ->
                                let jCond =
                                    wasmAnd (geS sj (i32Const 0))
                                        (WExpr.Compare(
                                            (if descending then WCompareOp.LtS else WCompareOp.GtS),
                                            arrayGet keyArr sj keyT, sk))
                                sequence [
                                    whileLoop (gen.Next("sjl")) jCond
                                        (sequence [
                                            arraySet arr (add sj (i32Const 1)) (arrayGet arr sj elemT)
                                            arraySet keyArr (add sj (i32Const 1)) (arrayGet keyArr sj keyT)
                                            setSj (sub sj (i32Const 1))
                                        ])
                                    arraySet arr (add sj (i32Const 1)) se
                                    arraySet keyArr (add sj (i32Const 1)) sk
                                    setSi (add si (i32Const 1))
                                ])))))
                // Rebuild list from array (reverse order)
                let rebuildPhase = arrayToListRev gen s arr len (fun a i -> arrayGet a i elemT)
                sequence [fillPhase; WExpr.Nop; sortPhase; rebuildPhase]
            )))))
    // ── List.sort / List.sortDescending ────────────────────────────
    | ("sort" | "sortDescending"), (listArg :: _) ->
        let descending = selector = "sortDescending"
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("lsrt")
            let (arrElemT, arrDefault) =
                match elemT with
                | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                | t -> t, makeNumericZero t
            let readElem (arrExpr: WExpr) (idxExpr: WExpr) =
                match elemT with
                | WType.Ref(idx, false) ->
                    cast (arrayGet arrExpr idxExpr (WType.Ref(idx, true))) (WType.Ref(idx, false))
                | _ -> arrayGet arrExpr idxExpr elemT
            let arrTypeIdx = getOrAddArrayType ctx arrElemT
            let arrRefT    = WType.Ref(arrTypeIdx, false)
            let wLst       = transform ctx listArg
            let ltOp = if descending then WCompareOp.GtS else WCompareOp.LtS
            Some(
                letVal gen "lst" s.BaseTy wLst (fun lst ->
                letVal gen "len" WType.I32 (listLength gen s lst) (fun len ->
                letVal gen "arr" arrRefT (arrayNew arrTypeIdx len arrDefault arrRefT) (fun arr ->
                    // Fill array from list
                    let fillPhase =
                        listFold gen s lst (i32Const 0) WType.I32
                            (fun idx elem ->
                                sequence [arraySet arr idx elem; add idx (i32Const 1)])
                    // Insertion sort
                    let cmpSeArrJ (se: WExpr) (sj: WExpr) =
                        match elemT with
                        | WType.Ref(si, _) when si = StringTypeIdx ->
                            let cmpRes = WExpr.Call(ctx.UseHelper("$strCompare"), [se; readElem arr sj], WType.I32)
                            WExpr.Compare(ltOp, cmpRes, i32Const 0)
                        | _ -> WExpr.Compare(ltOp, se, readElem arr sj)
                    let sortPhase =
                        letMut gen "si" WType.I32 (i32Const 1) (fun si setSi ->
                            whileLoop (gen.Next("sil")) (ltS si len)
                                (letVal gen "se" elemT (readElem arr si) (fun se ->
                                letMut gen "sj" WType.I32 (sub si (i32Const 1)) (fun sj setSj ->
                                    let jCond =
                                        wasmAnd (geS sj (i32Const 0)) (cmpSeArrJ se sj)
                                    sequence [
                                        whileLoop (gen.Next("sjl")) jCond
                                            (sequence [
                                                arraySet arr (add sj (i32Const 1)) (readElem arr sj)
                                                setSj (sub sj (i32Const 1))
                                            ])
                                        arraySet arr (add sj (i32Const 1)) se
                                        setSi (add si (i32Const 1))
                                    ]))))
                    // Rebuild list
                    let rebuildPhase =
                        letMut gen "ri" WType.I32 (sub len (i32Const 1)) (fun ri setRi ->
                        letMut gen "acc" s.BaseTy s.Nil (fun acc setAcc ->
                            sequence [
                                whileLoop (gen.Next("ril")) (geS ri (i32Const 0))
                                    (sequence [
                                        setAcc (s.Cons (readElem arr ri) acc)
                                        setRi (sub ri (i32Const 1))
                                    ])
                                acc
                            ]))
                    sequence [fillPhase; WExpr.Nop; sortPhase; rebuildPhase]
                ))))
        | None -> None
    // ── List.sortWith cmp xs ──────────────────────────────────────
    | "sortWith", (cmpArg :: listArg :: _) ->
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
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemT, consIdx) ->
        let s   = mkListShape elemT consIdx
        let gen = LabelGen("lsw")
        let (arrElemT, arrDefault) =
            match elemT with
            | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
            | t -> t, makeNumericZero t
        let readElem arrExpr idxExpr =
            match elemT with
            | WType.Ref(idx, false) ->
                cast (arrayGet arrExpr idxExpr arrElemT) (WType.Ref(idx, false))
            | _ -> arrayGet arrExpr idxExpr elemT
        let arrTypeIdx = getOrAddArrayType ctx arrElemT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let ctx'  = ctx.WithLocal(farg1.Name, elemT)
        let ctx'' = ctx'.WithLocal(farg2.Name, elemT)
        let wCmp  = transform ctx'' fbody
        let wLst  = transform ctx listArg
        let inlineCmp a b = WExpr.Let(farg1.Name, a, WExpr.Let(farg2.Name, b, wCmp))
        Some(
            letVal gen "lst" s.BaseTy wLst (fun lst ->
            letVal gen "len" WType.I32 (listLength gen s lst) (fun len ->
            letVal gen "arr" arrRefT (arrayNew arrTypeIdx len arrDefault arrRefT) (fun arr ->
                // Fill
                let fillPhase =
                    listFold gen s lst (i32Const 0) WType.I32
                        (fun idx elem ->
                            sequence [arraySet arr idx elem; add idx (i32Const 1)])
                // Sort
                let sortPhase =
                    letMut gen "si" WType.I32 (i32Const 1) (fun si setSi ->
                        whileLoop (gen.Next("sil")) (ltS si len)
                            (letVal gen "e" elemT (readElem arr si) (fun e ->
                            letMut gen "sj" WType.I32 (sub si (i32Const 1)) (fun sj setSj ->
                                let jCond =
                                    wasmAnd (geS sj (i32Const 0))
                                        (gtS (inlineCmp (readElem arr sj) e) (i32Const 0))
                                sequence [
                                    whileLoop (gen.Next("sjl")) jCond
                                        (sequence [
                                            arraySet arr (add sj (i32Const 1)) (readElem arr sj)
                                            setSj (sub sj (i32Const 1))
                                        ])
                                    arraySet arr (add sj (i32Const 1)) e
                                    setSi (add si (i32Const 1))
                                ]))))
                // Rebuild
                let rebuildPhase =
                    letMut gen "ri" WType.I32 (sub len (i32Const 1)) (fun ri setRi ->
                    letMut gen "acc" s.BaseTy s.Nil (fun acc setAcc ->
                        sequence [
                            whileLoop (gen.Next("ril")) (geS ri (i32Const 0))
                                (sequence [
                                    setAcc (s.Cons (readElem arr ri) acc)
                                    setRi (sub ri (i32Const 1))
                                ])
                            acc
                        ]))
                sequence [fillPhase; WExpr.Nop; sortPhase; rebuildPhase]
            ))))
    // ── List.flatten / List.concat ─────────────────────────────────
    | ("flatten" | "concat"), (listArg :: _) ->
        let elemFableT =
            match listArg.Type with
            | Fable.Type.List(Fable.Type.List t) -> Some t
            | _ -> None
        match elemFableT with
        | None -> None
        | Some innerFableT ->
        match tryListTypeInfoFromElemType ctx innerFableT with
        | None -> None
        | Some(elemT, innerConsIdx) ->
        let outerElemFableT = Fable.Type.List innerFableT
        match tryListTypeInfoFromElemType ctx outerElemFableT with
        | None -> None
        | Some(outerElemT, outerConsIdx) ->
        let s   = mkListShape elemT innerConsIdx
        let os  = mkListShape outerElemT outerConsIdx
        let gen = LabelGen("flat")
        let wLst = transform ctx listArg
        let revResult =
            listFold gen os wLst s.Nil s.BaseTy
                (fun acc innerList ->
                    listFold gen s innerList acc s.BaseTy
                        (fun acc2 elem -> s.Cons elem acc2))
        Some(listRev gen s revResult)
    // ── List.zip xs ys ─────────────────────────────────────────────
    | "zip", (xsArg :: ysArg :: _) ->
        let xsElemFableT = match xsArg.Type with | Fable.Type.List t -> Some t | _ -> None
        let ysElemFableT = match ysArg.Type with | Fable.Type.List t -> Some t | _ -> None
        match xsElemFableT, ysElemFableT with
        | None, _ | _, None -> None
        | Some xElemFT, Some yElemFT ->
        let xElemT = mapTypeKnown ctx xElemFT
        let yElemT = mapTypeKnown ctx yElemFT
        let tupleFableT = Fable.Type.Tuple([xElemFT; yElemFT], false)
        let tupleWType  = mapTypeKnown ctx tupleFableT
        let tupleIdx    =
            let key = wTypesKey [xElemT; yElemT]
            match ctx.TupleRegistry.TryGetValue(key) with
            | true, idx -> idx
            | _ -> failwith "tuple not registered after mapTypeKnown"
        let tupleRefT = WType.Ref(tupleIdx, false)
        match tryListTypeInfoFromElemType ctx tupleFableT with
        | None -> None
        | Some(pairElemT, pairConsIdx) ->
        match tryListTypeInfo ctx xsArg, tryListTypeInfo ctx ysArg with
        | Some(_, xConsIdx), Some(_, yConsIdx) ->
            let sX   = mkListShape xElemT xConsIdx
            let sY   = mkListShape yElemT yConsIdx
            let sOut = mkListShape pairElemT pairConsIdx
            let gen  = LabelGen("zip")
            let wXs  = transform ctx xsArg
            let wYs  = transform ctx ysArg
            // Walk both lists in lockstep, consing reversed pairs
            Some(
                letMut gen "xp" sX.BaseTy wXs (fun xp setXp ->
                letMut gen "yp" sY.BaseTy wYs (fun yp setYp ->
                letMut gen "acc" sOut.BaseTy sOut.Nil (fun acc setAcc ->
                    sequence [
                        whileLoop (gen.Next("lp"))
                            (wasmAnd (refIsNotNull xp) (refIsNotNull yp))
                            (sequence [
                                setAcc (sOut.Cons
                                    (structNew tupleIdx [sX.Head xp; sY.Head yp] tupleRefT)
                                    acc)
                                setXp (sX.Tail xp)
                                setYp (sY.Tail yp)
                            ])
                        listRev gen sOut acc
                    ]))))
        | _ -> None
    // ── List.map2 f xs ys ──────────────────────────────────────────
    | "map2", (cmpArg :: xsArg :: ysArg :: _) ->
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
        match tryListTypeInfo ctx xsArg, tryListTypeInfo ctx ysArg with
        | Some(xElemT, xConsIdx), Some(yElemT, yConsIdx) ->
            match tryListTypeInfoFromElemType ctx fbody.Type with
            | None -> None
            | Some(resultElemT, resultConsIdx) ->
            let sX   = mkListShape xElemT xConsIdx
            let sY   = mkListShape yElemT yConsIdx
            let sOut = mkListShape resultElemT resultConsIdx
            let gen  = LabelGen("m2")
            let ctx'  = ctx.WithLocal(farg1.Name, xElemT).WithLocal(farg2.Name, yElemT)
            let wBody = transform ctx' fbody
            let wXs   = transform ctx xsArg
            let wYs   = transform ctx ysArg
            Some(
                letMut gen "xp" sX.BaseTy wXs (fun xp setXp ->
                letMut gen "yp" sY.BaseTy wYs (fun yp setYp ->
                letMut gen "acc" sOut.BaseTy sOut.Nil (fun acc setAcc ->
                    sequence [
                        whileLoop (gen.Next("lp"))
                            (wasmAnd (refIsNotNull xp) (refIsNotNull yp))
                            (sequence [
                                setAcc (sOut.Cons
                                    (WExpr.Let(farg1.Name, sX.Head xp,
                                        WExpr.Let(farg2.Name, sY.Head yp, wBody)))
                                    acc)
                                setXp (sX.Tail xp)
                                setYp (sY.Tail yp)
                            ])
                        listRev gen sOut acc
                    ]))))
        | _ -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List primitives (no lambda — direct structural operations)
// ─────────────────────────────────────────────────────────────────

let tryListPrimitiveInline
        (ctx: Ctx)
        (selector: string)
        (wArgs: WExpr list)
        (ty: WType)
        (fableArgs: Fable.Expr list) : WExpr option =
    let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
    match selector, wArgs with
    | ("toList" | "ofList"), [wList] ->
        match tryListTypeInfo ctx (List.head fableArgs) with
        | Some _ -> Some wList
        | None   -> None
    | "head", [wList] ->
        let elemT = ty
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            Some(structGet (cast wList (WType.Ref(listConsIdx, false))) 0 elemT)
        | _ -> None
    | "tail", [wList] ->
        let innerFableType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let innerElemWType = mapTypeKnown ctx innerFableType
        let elemKey = wTypeKey innerElemWType
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, consIdx ->
            Some(structGet (cast wList (WType.Ref(consIdx, false))) 1 listBaseRefT)
        | _ -> None
    | "isEmpty", [wList] when ty = WType.I32 ->
        match exprWType wList with
        | WType.Ref(_, _) -> Some(WExpr.RefIsNull(wList))
        | _ -> Some(eq wList (i32Const 0))
    | "length", [wList] when ty = WType.I32 ->
        let innerFableType =
            match fableArgs with
            | [a] ->
                match a.Type with
                | Fable.Type.List(t) | Fable.Type.DeclaredType(_, [t]) -> t
                | _ -> Fable.Type.Any
            | _ -> Fable.Type.Any
        let innerElemWType = mapTypeKnown ctx innerFableType
        let elemKey = wTypeKey innerElemWType
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, consIdx ->
            let s   = mkListShape innerElemWType consIdx
            let gen = LabelGen("listlen")
            Some(listLength gen s wList)
        | _ -> None
    | ("reverse" | "rev"), [wList] ->
        let fableElemType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let elemT   = mapTypeKnown ctx fableElemType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, consIdx ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("rev")
            Some(listRev gen s wList)
        | _ -> None
    | "append", [wXs; wYs] ->
        let fableElemType =
            match fableArgs with
            | [a; _] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let elemT   = mapTypeKnown ctx fableElemType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, consIdx ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("app")
            // Reverse xs, then fold prepend onto ys
            let revXs = listRev gen s wXs
            Some(listFold gen s revXs wYs s.BaseTy (fun acc elem -> s.Cons elem acc))
        | _ -> None
    | "sum", _ when List.length wArgs <= 2 ->
        let listFableArg =
            match fableArgs with | [a] | [a; _] -> a | _ -> List.head fableArgs
        let listTypeInfo =
            match tryListTypeInfo ctx listFableArg with
            | Some ti -> Some ti
            | None ->
                let elemKey = wTypeKey ty
                match ctx.ListRegistry.TryGetValue(elemKey) with
                | true, listConsIdx -> Some(ty, listConsIdx)
                | _ -> None
        match listTypeInfo with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("sum")
            let wList = match wArgs with | [a] | [a; _] -> a | _ -> s.Nil
            let zero = makeNumericZero elemT
            Some(listFold gen s wList zero elemT
                    (fun acc elem -> WExpr.Binary(WBinaryOp.Add, acc, elem, elemT)))
        | None -> None
    | "item", [nExpr; wList] ->
        let innerFableType =
            match fableArgs with
            | [_; a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let realElemT = mapTypeKnown ctx innerFableType
        let elemKey = wTypeKey realElemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, consIdx ->
            let s   = mkListShape realElemT consIdx
            let gen = LabelGen("item")
            Some(
                letMut gen "cnt" WType.I32 nExpr (fun cnt setCnt ->
                letMut gen "ptr" s.BaseTy wList (fun ptr setPtr ->
                    sequence [
                        whileLoop (gen.Next("lp")) (gtS cnt (i32Const 0))
                            (sequence [setPtr (s.Tail ptr); setCnt (sub cnt (i32Const 1))])
                        s.Head ptr
                    ])))
        | _ -> None
    | (("min" | "max") as sel), (wListArg :: _)
        when (match fableArgs with ha :: _ -> (match ha.Type with | Fable.Type.List _ -> true | _ -> false) | _ -> false) ->
        let listFableArg = List.head fableArgs
        let isMin = sel = "min"
        match tryListTypeInfo ctx listFableArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("listmm")
            let cmpOp = if isMin then WCompareOp.LtS else WCompareOp.GtS
            Some(
                letVal gen "lst" s.BaseTy wListArg (fun lst ->
                letVal gen "nn" s.NonNullTy (s.CastNN lst) (fun nn ->
                    let headElem = structGet nn 0 elemT
                    let headTail = structGet nn 1 s.BaseTy
                    letMut gen "best" elemT headElem (fun best setBest ->
                        sequence [
                            listIter gen s headTail (fun elem ->
                                letVal gen "h" elemT elem (fun h ->
                                    WExpr.If(WExpr.Compare(cmpOp, h, best),
                                        setBest h, WExpr.Nop, WType.Void)))
                            best
                        ]))))
        | None -> None
    | "contains", (wNeedle :: wListArg :: _)
        when (match fableArgs with | _ :: ha :: _ -> (match ha.Type with | Fable.Type.List _ -> true | _ -> false) | _ -> false) ->
        let listFableArg = List.item 1 fableArgs
        match tryListTypeInfo ctx listFableArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("lcont")
            Some(
                letVal gen "needle" elemT wNeedle (fun needle ->
                    listSearch gen s wListArg WType.I32
                        (fun elem -> eq elem needle)
                        (fun _ -> i32Const 1)
                        (i32Const 0)))
        | None -> None
    | ("ofArray" | "ofSeq"), [wArr] ->
        match List.tryHead fableArgs with
        | None -> None
        | Some arrFableArg ->
        match arrFableArg.Type with
        | Fable.Type.Array(elemFableT, _) ->
            match tryListTypeInfoFromElemType ctx elemFableT with
            | None -> None
            | Some(elemT, consIdx) ->
                let s       = mkListShape elemT consIdx
                let gen     = LabelGen("ofa")
                let arrRefT = mapTypeKnown ctx arrFableArg.Type
                Some(letVal gen "arr" arrRefT wArr (fun arr ->
                    arrayToListRev gen s arr (arrayLen arr)
                        (fun a i -> arrayGet a i elemT)))
        | _ -> None
    | "last", [wList] ->
        let innerFableType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let elemT   = mapTypeKnown ctx innerFableType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, consIdx ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("last")
            Some(
                letVal gen "lst" s.BaseTy wList (fun lst ->
                letVal gen "nn" s.NonNullTy (s.CastNN lst) (fun nn ->
                    letMut gen "val" elemT (structGet nn 0 elemT) (fun v setV ->
                    letMut gen "ptr" s.BaseTy (structGet nn 1 s.BaseTy) (fun ptr setPtr ->
                        sequence [
                            whileLoop (gen.Next("lp")) (refIsNotNull ptr)
                                (sequence [setV (s.Head ptr); setPtr (s.Tail ptr)])
                            v
                        ])))))
        | _ -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List.tryHead / List.tryFind
// ─────────────────────────────────────────────────────────────────

let tryListTryHeadInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (wArgs: WExpr list)
        (ty: WType)
        (fableArgs: Fable.Expr list) : WExpr option =
    match selector, wArgs with
    | ("tryHead" | "head"), [wList] when ty <> WType.I32 ->
        let innerFableType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let elemT = mapTypeKnown ctx innerFableType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let listNNRefT = WType.Ref(listConsIdx, false)
            let optTypeIdx =
                let key = wTypeKey elemT
                match ctx.OptionRegistry.TryGetValue(key) with
                | true, idx -> idx
                | false, _ ->
                    let idx = ctx.TypeDefs.Count
                    ctx.TypeDefs.Add({ Name = $"Option_{idx}"; Def = WTypeDef.Struct([{ Name = "value"; Type = elemT; Mutable = false }], None) })
                    ctx.OptionRegistry.[key] <- idx
                    idx
            let gen = LabelGen("tryH")
            Some(
                letVal gen "tmp" (WType.Ref(ListBaseTypeIdx, true)) wList (fun tmp ->
                    WExpr.If(WExpr.RefIsNull tmp,
                        nullConst ty,
                        structNew optTypeIdx
                            [structGet (cast tmp listNNRefT) 0 elemT]
                            ty,
                        ty)))
        | _ -> None
    | _ -> None

let tryListTryFindInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (ty: WType) : WExpr option =
    match selector, fableArgs with
    | ("tryFind" | "pick"), [Fable.Expr.Lambda(farg, fbody, _); listArg]
    | ("tryFind" | "pick"), [Fable.Expr.Delegate([farg], fbody, _, _); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("tryf")
            let wList = transform ctx listArg
            let optTypeIdx =
                let key = wTypeKey elemT
                match ctx.OptionRegistry.TryGetValue(key) with
                | true, idx -> idx
                | false, _ ->
                    let idx = ctx.TypeDefs.Count
                    ctx.TypeDefs.Add({ Name = $"Option_{idx}"; Def = WTypeDef.Struct([{ Name = "value"; Type = elemT; Mutable = false }], None) })
                    ctx.OptionRegistry.[key] <- idx
                    idx
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(listSearch gen s wList ty
                    (fun elem -> WExpr.Let(farg.Name, elem, wPred))
                    (fun elem -> structNew optTypeIdx [elem] ty)
                    (nullConst ty))
        | None -> None
    | ("findIndex" | "tryFindIndex"), [Fable.Expr.Lambda(farg, fbody, _); listArg]
    | ("findIndex" | "tryFindIndex"), [Fable.Expr.Delegate([farg], fbody, _, _); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("fdi")
            let wList = transform ctx listArg
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            if selector = "tryFindIndex" then
                let optTypeIdx =
                    let key = wTypeKey WType.I32
                    match ctx.OptionRegistry.TryGetValue(key) with
                    | true, idx -> idx
                    | false, _ ->
                        let idx = ctx.TypeDefs.Count
                        ctx.TypeDefs.Add({ Name = $"Option_{idx}"; Def = WTypeDef.Struct([{ Name = "value"; Type = WType.I32; Mutable = false }], None) })
                        ctx.OptionRegistry.[key] <- idx
                        idx
                let exitLbl = gen.Next("exit")
                let lpLbl   = gen.Next("lp")
                Some(
                    letMut gen "cur" s.BaseTy wList (fun cur setCur ->
                    letMut gen "idx" WType.I32 (i32Const 0) (fun idx setIdx ->
                        WExpr.Block(exitLbl,
                            sequence [
                                WExpr.Loop(lpLbl,
                                    wasmIf (refIsNotNull cur)
                                        (wasmIf (WExpr.Let(farg.Name, s.Head cur, wPred))
                                            (WExpr.Break(exitLbl, Some(structNew optTypeIdx [idx] ty)))
                                            (sequence [
                                                setIdx (add idx (i32Const 1))
                                                setCur (s.Tail cur)
                                                continue_ lpLbl
                                            ]))
                                        WExpr.Nop,
                                    WType.Void)
                                nullConst ty
                            ],
                            ty))))
            else
                let exitLbl = gen.Next("exit")
                let lpLbl   = gen.Next("lp")
                Some(
                    letMut gen "cur" s.BaseTy wList (fun cur setCur ->
                    letMut gen "idx" WType.I32 (i32Const 0) (fun idx setIdx ->
                        WExpr.Block(exitLbl,
                            sequence [
                                WExpr.Loop(lpLbl,
                                    wasmIf (refIsNotNull cur)
                                        (wasmIf (WExpr.Let(farg.Name, s.Head cur, wPred))
                                            (WExpr.Break(exitLbl, Some idx))
                                            (sequence [
                                                setIdx (add idx (i32Const 1))
                                                setCur (s.Tail cur)
                                                continue_ lpLbl
                                            ]))
                                        WExpr.Nop,
                                    WType.Void)
                                i32Const (-1)
                            ],
                            WType.I32))))
        | None -> None
    | _ -> None
