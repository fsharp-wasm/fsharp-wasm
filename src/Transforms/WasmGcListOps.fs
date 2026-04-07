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
            Some(wasm {
                let! n = mut wN
                let! ptr = mutTy s.BaseTy wLst
                while! (wasmAnd (gtS n.Val (i32Const 0)) (refIsNotNull ptr.Val)) do
                    do! ptr.Set(s.Tail ptr.Val)
                    do! n.Set(sub n.Val (i32Const 1))
                return ptr.Val
            })
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
                wasm {
                    let! n   = mut wN
                    let! ptr = mutTy s.BaseTy wLst
                    let! acc = mutTy s.BaseTy s.Nil
                    while! (wasmAnd (gtS n.Val (i32Const 0)) (refIsNotNull ptr.Val)) do
                        do! acc.Set(s.Cons (s.Head ptr.Val) acc.Val)
                        do! ptr.Set(s.Tail ptr.Val)
                        do! n.Set(sub n.Val (i32Const 1))
                    return acc.Val
                }
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
        Some(wasm {
            let! lst    = wLst
            let! len    = listLength gen s lst
            let! arr    = arrayNew arrTypeIdx len (makeNumericZero elemT) arrRefT
            let! keyArr = arrayNew keyArrIdx len (makeNumericZero keyT) keyArrRefT
            // Fill arrays
            let fillPhase =
                listFold gen s lst (i32Const 0) WType.I32
                    (fun idx elem ->
                        wasm {
                            let! fe = elem
                            let! fk = WExpr.Let(farg.Name, fe, wKey)
                            do! arraySet arr idx fe
                            do! arraySet keyArr idx fk
                            return! add idx (i32Const 1)
                        })
            // Insertion sort on key array
            let sortPhase = wasm {
                let! si = mut (i32Const 1)
                while! (ltS si.Val len) do
                    let! se = arrayGet arr si.Val elemT
                    let! sk = arrayGet keyArr si.Val keyT
                    let! sj = mut (sub si.Val (i32Const 1))
                    let jCond =
                        wasmAnd (geS sj.Val (i32Const 0))
                            (WExpr.Compare(
                                (if descending then WCompareOp.LtS else WCompareOp.GtS),
                                arrayGet keyArr sj.Val keyT, sk))
                    while! jCond do
                        do! arraySet arr (add sj.Val (i32Const 1)) (arrayGet arr sj.Val elemT)
                        do! arraySet keyArr (add sj.Val (i32Const 1)) (arrayGet keyArr sj.Val keyT)
                        do! sj.Set(sub sj.Val (i32Const 1))
                    do! arraySet arr (add sj.Val (i32Const 1)) se
                    do! arraySet keyArr (add sj.Val (i32Const 1)) sk
                    do! si.Set(add si.Val (i32Const 1))
            }
            // Rebuild list from array (reverse order)
            let rebuildPhase = arrayToListRev gen s arr len (fun a i -> arrayGet a i elemT)
            do! fillPhase
            do! sortPhase
            return! rebuildPhase
        })
    // ── List.sort / List.sortDescending ────────────────────────────
    | ("sort" | "sortDescending"), (listArg :: _) ->
        let descending = selector = "sortDescending"
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("lsrt")
            let wLst = transform ctx listArg
            match elemT with
            | WType.Ref(idx, _) ->
                // For reference-typed elements, use nullable array + cast-back pattern
                let arrElemT   = WType.Ref(idx, true)
                let arrDefault = WExpr.Const(WConst.Null(arrElemT))
                let arrTypeIdx = getOrAddArrayType ctx arrElemT
                let arrRefT    = WType.Ref(arrTypeIdx, false)
                let readElem arrExpr idxExpr =
                    cast (arrayGet arrExpr idxExpr arrElemT) (WType.Ref(idx, false))
                let writeElem arrExpr idxExpr valExpr = arraySet arrExpr idxExpr valExpr
                let ltOp = if descending then WCompareOp.GtS else WCompareOp.LtS
                let inlineCmp a b =
                    match elemT with
                    | WType.Ref(si, _) when si = StringTypeIdx ->
                        let cmpRes = WExpr.Call(ctx.UseHelper("$strCompare"), [a; b], WType.I32)
                        WExpr.Compare(ltOp, cmpRes, i32Const 0)
                    | _ -> WExpr.Compare(ltOp, a, b)
                Some(wasm {
                    let! lst = wLst
                    let! len = listLength gen s lst
                    let! arr = arrayNew arrTypeIdx len arrDefault arrRefT
                    let fillPhase =
                        listFold gen s lst (i32Const 0) WType.I32
                            (fun idx elem -> sequence [arraySet arr idx elem; add idx (i32Const 1)])
                    do! fillPhase
                    do! insertionSortInPlace gen arr len elemT readElem writeElem
                            (fun a b -> wasmIf (inlineCmp a b) (i32Const -1) (i32Const 1))
                    return! arrayToListRev gen s arr len (fun a i -> readElem a i)
                })
            | _ ->
                // For numeric element types, delegate to the buildListSort combinator
                let arrTypeIdx = getOrAddArrayType ctx elemT
                Some(buildListSort gen s arrTypeIdx wLst descending)
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
        let writeElem arrExpr idxExpr valExpr = arraySet arrExpr idxExpr valExpr
        let arrTypeIdx = getOrAddArrayType ctx arrElemT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let ctx'  = ctx.WithLocal(farg1.Name, elemT)
        let ctx'' = ctx'.WithLocal(farg2.Name, elemT)
        let wCmp  = transform ctx'' fbody
        let wLst  = transform ctx listArg
        let inlineCmp a b = WExpr.Let(farg1.Name, a, WExpr.Let(farg2.Name, b, wCmp))
        Some(wasm {
            let! lst = wLst
            let! len = listLength gen s lst
            let! arr = arrayNew arrTypeIdx len arrDefault arrRefT
            let fillPhase =
                listFold gen s lst (i32Const 0) WType.I32
                    (fun idx elem ->
                        sequence [arraySet arr idx elem; add idx (i32Const 1)])
            do! fillPhase
            do! insertionSortInPlace gen arr len elemT readElem writeElem inlineCmp
            return! arrayToListRev gen s arr len (fun a i -> readElem a i)
        })
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
            Some(wasm {
                let! xp  = mutTy sX.BaseTy wXs
                let! yp  = mutTy sY.BaseTy wYs
                let! acc = mutTy sOut.BaseTy sOut.Nil
                while! (wasmAnd (refIsNotNull xp.Val) (refIsNotNull yp.Val)) do
                    do! acc.Set(sOut.Cons
                        (structNew tupleIdx [sX.Head xp.Val; sY.Head yp.Val] tupleRefT)
                        acc.Val)
                    do! xp.Set(sX.Tail xp.Val)
                    do! yp.Set(sY.Tail yp.Val)
                return! listRev gen sOut acc.Val
            })
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
            Some(wasm {
                let! xp  = mutTy sX.BaseTy wXs
                let! yp  = mutTy sY.BaseTy wYs
                let! acc = mutTy sOut.BaseTy sOut.Nil
                while! (wasmAnd (refIsNotNull xp.Val) (refIsNotNull yp.Val)) do
                    do! acc.Set(sOut.Cons
                        (WExpr.Let(farg1.Name, sX.Head xp.Val,
                            WExpr.Let(farg2.Name, sY.Head yp.Val, wBody)))
                        acc.Val)
                    do! xp.Set(sX.Tail xp.Val)
                    do! yp.Set(sY.Tail yp.Val)
                return! listRev gen sOut acc.Val
            })
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
            Some(wasm {
                let! cnt = mut nExpr
                let! ptr = mutTy s.BaseTy wList
                while! (gtS cnt.Val (i32Const 0)) do
                    do! ptr.Set(s.Tail ptr.Val)
                    do! cnt.Set(sub cnt.Val (i32Const 1))
                return s.Head ptr.Val
            })
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
            Some(wasm {
                let! lst = wListArg
                let! nn  = s.CastNN lst
                let headElem = structGet nn 0 elemT
                let headTail = structGet nn 1 s.BaseTy
                let! best = mutTy elemT headElem
                do! listIter gen s headTail (fun elem ->
                    wasm {
                        let! h = elem
                        return! WExpr.If(WExpr.Compare(cmpOp, h, best.Val),
                            best.Set h, WExpr.Nop, WType.Void)
                    })
                return best.Val
            })
        | None -> None
    | "contains", (wNeedle :: wListArg :: _)
        when (match fableArgs with | _ :: ha :: _ -> (match ha.Type with | Fable.Type.List _ -> true | _ -> false) | _ -> false) ->
        let listFableArg = List.item 1 fableArgs
        match tryListTypeInfo ctx listFableArg with
        | Some(elemT, consIdx) ->
            let s   = mkListShape elemT consIdx
            let gen = LabelGen("lcont")
            Some(wasm {
                let! needle = wNeedle
                return! listSearch gen s wListArg WType.I32
                    (fun elem -> eq elem needle)
                    (fun _ -> i32Const 1)
                    (i32Const 0)
            })
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
                Some(wasm {
                    let! arr = wArr
                    return! arrayToListRev gen s arr (arrayLen arr)
                        (fun a i -> arrayGet a i elemT)
                })
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
            Some(wasm {
                let! lst = wList
                let! nn  = s.CastNN lst
                let! v   = mutTy elemT (structGet nn 0 elemT)
                let! ptr = mutTy s.BaseTy (structGet nn 1 s.BaseTy)
                while! (refIsNotNull ptr.Val) do
                    do! v.Set(s.Head ptr.Val)
                    do! ptr.Set(s.Tail ptr.Val)
                return v.Val
            })
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
            Some(wasm {
                let! tmp = wList
                return! WExpr.If(WExpr.RefIsNull tmp,
                    nullConst ty,
                    structNew optTypeIdx
                        [structGet (cast tmp listNNRefT) 0 elemT]
                        ty,
                    ty)
            })
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
                Some(wasm {
                    let! cur = mutTy s.BaseTy wList
                    let! idx = mut (i32Const 0)
                    return! WExpr.Block(exitLbl,
                        sequence [
                            WExpr.Loop(lpLbl,
                                wasmIf (refIsNotNull cur.Val)
                                    (wasmIf (WExpr.Let(farg.Name, s.Head cur.Val, wPred))
                                        (WExpr.Break(exitLbl, Some(structNew optTypeIdx [idx.Val] ty)))
                                        (sequence [
                                            idx.Set(add idx.Val (i32Const 1))
                                            cur.Set(s.Tail cur.Val)
                                            continue_ lpLbl
                                        ]))
                                    WExpr.Nop,
                                WType.Void)
                            nullConst ty
                        ],
                        ty)
                })
            else
                let exitLbl = gen.Next("exit")
                let lpLbl   = gen.Next("lp")
                Some(wasm {
                    let! cur = mutTy s.BaseTy wList
                    let! idx = mut (i32Const 0)
                    return! WExpr.Block(exitLbl,
                        sequence [
                            WExpr.Loop(lpLbl,
                                wasmIf (refIsNotNull cur.Val)
                                    (wasmIf (WExpr.Let(farg.Name, s.Head cur.Val, wPred))
                                        (WExpr.Break(exitLbl, Some idx.Val))
                                        (sequence [
                                            idx.Set(add idx.Val (i32Const 1))
                                            cur.Set(s.Tail cur.Val)
                                            continue_ lpLbl
                                        ]))
                                    WExpr.Nop,
                                WType.Void)
                            i32Const (-1)
                        ],
                        WType.I32)
                })
        | None -> None
    | _ -> None
