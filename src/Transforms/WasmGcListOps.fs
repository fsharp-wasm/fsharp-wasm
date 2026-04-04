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
    let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
    let null_list    = WExpr.Const(WConst.Null listBaseRefT)
    match selector, fableArgs with
    // List.skip n xs — args: [n; xs]; advance pointer n steps, return tail
    | "skip", (nArg :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let listNNRefT = WType.Ref(consIdx, false)
            let wN        = transform ctx nArg
            let wLst      = transform ctx listArg
            let nVar      = "$skip_n"
            let ptrVar    = "$skip_ptr"
            let nnVar     = "$skip_nn"
            let loopLabel = "$skip_loop"
            let skipBody =
                WExpr.If(
                    WExpr.Compare(WCompareOp.LtS,
                        WExpr.LocalGet(nVar, WType.I32),
                        WExpr.Const(WConst.I32 1)),
                    WExpr.Break("$skip_blk", None),
                    WExpr.If(
                        WExpr.RefIsNull(WExpr.LocalGet(ptrVar, listBaseRefT)),
                        WExpr.Break("$skip_blk", None),
                        WExpr.Let(nnVar,
                            WExpr.Cast(WExpr.LocalGet(ptrVar, listBaseRefT), listNNRefT),
                            WExpr.Sequence [
                                WExpr.Assign(ptrVar,
                                    WExpr.StructGet(
                                        WExpr.LocalGet(nnVar, listNNRefT), 1, listBaseRefT))
                                WExpr.Assign(nVar,
                                    WExpr.Binary(WBinaryOp.Sub,
                                        WExpr.LocalGet(nVar, WType.I32),
                                        WExpr.Const(WConst.I32 1), WType.I32))
                                WExpr.Continue(loopLabel, [])
                            ]),
                        WType.Void),
                    WType.Void)
            let loopExpr  = WExpr.Loop(loopLabel, skipBody, WType.Void)
            let blockExpr = WExpr.Block("$skip_blk", loopExpr, WType.Void)
            Some(WExpr.LetMut(nVar, wN,
                WExpr.LetMut(ptrVar, wLst,
                    WExpr.Sequence [
                        blockExpr
                        WExpr.LocalGet(ptrVar, listBaseRefT)
                    ])))
        | None -> None
    // List.take n xs — args: [n; xs]
    // Phase 1: collect first n elements reversed; Phase 2: reverse into forward list.
    | "take", (nArg :: listArg :: _) ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            let listNNRefT = WType.Ref(consIdx, false)
            let wN        = transform ctx nArg
            let wLst      = transform ctx listArg
            let nVar      = "$trev_n"
            let ptrVar    = "$trev_ptr"
            let accVar    = "$trev_acc"
            let nnVar     = "$trev_nn"
            let loopLabel = "$trev_loop"
            let collectBody =
                WExpr.If(
                    WExpr.Compare(WCompareOp.LtS,
                        WExpr.LocalGet(nVar, WType.I32),
                        WExpr.Const(WConst.I32 1)),
                    WExpr.Break("$trev_coll", None),
                    WExpr.If(
                        WExpr.RefIsNull(WExpr.LocalGet(ptrVar, listBaseRefT)),
                        WExpr.Break("$trev_coll", None),
                        WExpr.Let(nnVar,
                            WExpr.Cast(WExpr.LocalGet(ptrVar, listBaseRefT), listNNRefT),
                            WExpr.Sequence [
                                WExpr.Assign(accVar,
                                    WExpr.StructNew(consIdx,
                                        [WExpr.StructGet(
                                            WExpr.LocalGet(nnVar, listNNRefT), 0, elemT);
                                         WExpr.LocalGet(accVar, listBaseRefT)],
                                        listBaseRefT))
                                WExpr.Assign(ptrVar,
                                    WExpr.StructGet(
                                        WExpr.LocalGet(nnVar, listNNRefT), 1, listBaseRefT))
                                WExpr.Assign(nVar,
                                    WExpr.Binary(WBinaryOp.Sub,
                                        WExpr.LocalGet(nVar, WType.I32),
                                        WExpr.Const(WConst.I32 1), WType.I32))
                                WExpr.Continue(loopLabel, [])
                            ]),
                        WType.Void),
                    WType.Void)
            let loopExpr    = WExpr.Loop(loopLabel, collectBody, WType.Void)
            let collectExpr = WExpr.Block("$trev_coll", loopExpr, WType.Void)
            // collectPhase evaluates to the reversed first-n list
            let collectPhase =
                WExpr.LetMut(nVar, wN,
                    WExpr.LetMut(ptrVar, wLst,
                        WExpr.LetMut(accVar, null_list,
                            WExpr.Sequence [
                                collectExpr
                                WExpr.LocalGet(accVar, listBaseRefT)
                            ])))
            // Phase 2: reverse the reversed collection to get the forward list
            Some(mkListLoop "trev2" elemT consIdx collectPhase
                    [("$trev2_acc", null_list)]
                    (fun h -> WExpr.Assign("$trev2_acc",
                        WExpr.StructNew(consIdx,
                            [h; WExpr.LocalGet("$trev2_acc", listBaseRefT)],
                            listBaseRefT)))
                    (WExpr.LocalGet("$trev2_acc", listBaseRefT)) None)
        | None -> None
    // List.sortBy f xs / List.sortByDescending f xs — sort by key function.
    // Strategy: fill parallel elem+key arrays; insertion sort on keys; rebuild list.
    | ("sortBy" | "sortByDescending"),
        ((Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)) :: listArg :: _) ->
        let descending = selector = "sortByDescending"
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemT, consIdx) ->
        let keyFableT  = fbody.Type
        let keyT       = mapTypeKnown ctx keyFableT
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let keyArrIdx  = getOrAddArrayType ctx keyT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let keyArrRefT = WType.Ref(keyArrIdx, false)
        let s   = mkListShape elemT consIdx
        let gen = LabelGen("lsby")
        let ctx' = ctx.WithLocal(farg.Name, elemT)
        let wKey = transform ctx' fbody
        let wLst = transform ctx listArg
        let cmpOp = if descending then WCompareOp.GtS else WCompareOp.LtS
        let lstVar = "$lsby_lst"
        let arrVar = "$lsby_arr"
        let keyVar = "$lsby_key"
        let iVar   = "$lsby_i"
        let jVar   = "$lsby_j"
        let seVar  = "$lsby_se"
        let skVar  = "$lsby_sk"
        let riVar  = "$lsby_ri"
        let accVar = "$lsby_acc"
        let lstGet = WExpr.LocalGet(lstVar, s.BaseTy)
        let lenVar = "$lsby_len"
        let lenGet = WExpr.LocalGet(lenVar, WType.I32)
        let arrGet = WExpr.LocalGet(arrVar, arrRefT)
        let keyGet = WExpr.LocalGet(keyVar, keyArrRefT)
        let iGet   = WExpr.LocalGet(iVar, WType.I32)
        let jGet   = WExpr.LocalGet(jVar, WType.I32)
        let seGet  = WExpr.LocalGet(seVar, elemT)
        let skGet  = WExpr.LocalGet(skVar, keyT)
        let riGet  = WExpr.LocalGet(riVar, WType.I32)
        let accGet = WExpr.LocalGet(accVar, s.BaseTy)
        let feVar  = "$lsby_fe"
        let fkVar  = "$lsby_fk"
        let fillLoop =
            // Thread index (i32) through fold — avoids void-typed accumulator
            sequence [
                listFold gen s lstGet (i32Const 0) WType.I32
                    (fun i elem ->
                        WExpr.Let(feVar, elem,
                        WExpr.Let(fkVar, WExpr.Let(farg.Name, WExpr.LocalGet(feVar, elemT), wKey),
                            sequence [
                                WExpr.ArraySet(arrGet, i, WExpr.LocalGet(feVar, elemT))
                                WExpr.ArraySet(keyGet, i, WExpr.LocalGet(fkVar, keyT))
                                add i (i32Const 1)
                            ])))
                WExpr.Nop   // drop final index (already know len)
            ]
        let sjCond =
            // Inner while: shift right while key[j] > sk (ascending) or key[j] < sk (descending)
            wasmAnd (geS jGet (i32Const 0))
                     (WExpr.Compare(
                        (if descending then WCompareOp.LtS else WCompareOp.GtS),
                        WExpr.ArrayGet(keyGet, jGet, keyT),
                        skGet))
        let sortLoop =
            WExpr.LetMut(iVar, i32Const 1,
                whileLoop (gen.Next("sil")) (ltS iGet lenGet)
                    (WExpr.Let(seVar, WExpr.ArrayGet(arrGet, iGet, elemT),
                    WExpr.Let(skVar, WExpr.ArrayGet(keyGet, iGet, keyT),
                    WExpr.LetMut(jVar, sub iGet (i32Const 1),
                        sequence [
                            whileLoop (gen.Next("sjl")) sjCond
                                (sequence [
                                    WExpr.ArraySet(arrGet, add jGet (i32Const 1), WExpr.ArrayGet(arrGet, jGet, elemT))
                                    WExpr.ArraySet(keyGet, add jGet (i32Const 1), WExpr.ArrayGet(keyGet, jGet, keyT))
                                    localSet jVar (sub jGet (i32Const 1))
                                ])
                            WExpr.ArraySet(arrGet, add jGet (i32Const 1), seGet)
                            WExpr.ArraySet(keyGet, add jGet (i32Const 1), skGet)
                            localSet iVar (add iGet (i32Const 1))
                        ])))))
        let rebuildList =
            WExpr.LetMut(riVar, sub lenGet (i32Const 1),
                WExpr.LetMut(accVar, s.Nil,
                    sequence [
                        whileLoop (gen.Next("ril")) (geS riGet (i32Const 0))
                            (sequence [
                                localSet accVar (s.Cons (WExpr.ArrayGet(arrGet, riGet, elemT)) accGet)
                                localSet riVar  (sub riGet (i32Const 1))
                            ])
                        accGet
                    ]))
        Some(
            WExpr.Let(lstVar, wLst,
            WExpr.Let(lenVar, listLength gen s lstGet,
            WExpr.Let(arrVar, arrayNew arrTypeIdx lenGet (makeNumericZero elemT) arrRefT,
            WExpr.Let(keyVar, arrayNew keyArrIdx  lenGet (makeNumericZero keyT)  keyArrRefT,
                sequence [fillLoop; sortLoop; rebuildList])))))
    // List.sort xs / List.sortDescending xs — args: [xs; _comparer]
    // Strategy: list → array, insertion sort, array → list (walk backwards to cons).
    | ("sort" | "sortDescending"), (listArg :: _) ->
        let descending = selector = "sortDescending"
        match tryListTypeInfo ctx listArg with
        | Some(elemT, consIdx) ->
            // Ref-typed elements require nullable array storage (array.new needs a defaultable init).
            // We cast nullable→non-nullable on read, matching the sortWith pattern.
            let (arrElemT, arrDefault) =
                match elemT with
                | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                | t -> t, makeNumericZero t
            let readElem (arrExpr: WExpr) (idxExpr: WExpr) =
                match elemT with
                | WType.Ref(idx, false) ->
                    WExpr.Cast(WExpr.ArrayGet(arrExpr, idxExpr, WType.Ref(idx, true)), WType.Ref(idx, false))
                | _ -> WExpr.ArrayGet(arrExpr, idxExpr, elemT)
            let arrTypeIdx  = getOrAddArrayType ctx arrElemT
            let arrRefT     = WType.Ref(arrTypeIdx, false)
            let wLst        = transform ctx listArg
            let lstVar      = "$lsrt_lst"
            let lenVar      = "$lsrt_len"
            let arrVar      = "$lsrt_arr"
            let siVar       = "$lsrt_si"
            let sjVar       = "$lsrt_sj"
            let seVar       = "$lsrt_se"
            let riVar       = "$lsrt_ri"
            let accVar      = "$lsrt_acc"
            let siLoopLabel = "$lsrt_sil"
            let sjLoopLabel = "$lsrt_sjl"
            let riLoopLabel = "$lsrt_ril"
            let lstGet  = WExpr.LocalGet(lstVar, listBaseRefT)
            let lenGet  = WExpr.LocalGet(lenVar, WType.I32)
            let arrGet  = WExpr.LocalGet(arrVar, arrRefT)
            let siGet   = WExpr.LocalGet(siVar, WType.I32)
            let sjGet   = WExpr.LocalGet(sjVar, WType.I32)
            let seGet   = WExpr.LocalGet(seVar, elemT)
            let riGet   = WExpr.LocalGet(riVar, WType.I32)
            let accGet  = WExpr.LocalGet(accVar, listBaseRefT)
            let ltOp    = if descending then WCompareOp.GtS else WCompareOp.LtS
            // Pass 1: count list length
            let countLen =
                mkListLoop "lslen" elemT consIdx lstGet
                    [("$lslen_c", WExpr.Const(WConst.I32 0))]
                    (fun _ -> WExpr.Assign("$lslen_c",
                        WExpr.Binary(WBinaryOp.Add,
                            WExpr.LocalGet("$lslen_c", WType.I32),
                            WExpr.Const(WConst.I32 1), WType.I32)))
                    (WExpr.LocalGet("$lslen_c", WType.I32)) None
            // Pass 2: fill array from list
            let fillArray =
                mkListLoop "lsfill" elemT consIdx lstGet
                    [("$lsfill_i", WExpr.Const(WConst.I32 0))]
                    (fun h ->
                        WExpr.Sequence [
                            WExpr.ArraySet(arrGet,
                                WExpr.LocalGet("$lsfill_i", WType.I32), h)
                            WExpr.Assign("$lsfill_i",
                                WExpr.Binary(WBinaryOp.Add,
                                    WExpr.LocalGet("$lsfill_i", WType.I32),
                                    WExpr.Const(WConst.I32 1), WType.I32))
                        ])
                    WExpr.Nop None
            // Pass 3: insertion sort in-place on arrVar
            // For ref elements: use strCompare for strings; for numerics: direct LtS/GtS.
            let cmpSeArrJ =
                match elemT with
                | WType.Ref(si, _) when si = StringTypeIdx ->
                    let cmpRes = WExpr.Call(ctx.UseHelper("$strCompare"), [seGet; readElem arrGet sjGet], WType.I32)
                    WExpr.Compare(ltOp, cmpRes, WExpr.Const(WConst.I32 0))
                | _ ->
                    WExpr.Compare(ltOp, seGet, readElem arrGet sjGet)
            let sjCond =
                WExpr.If(WExpr.Compare(WCompareOp.GeS, sjGet, WExpr.Const(WConst.I32 0)),
                    cmpSeArrJ,
                    WExpr.Const(WConst.I32 0), WType.I32)
            let sjStep =
                WExpr.Sequence [
                    WExpr.ArraySet(arrGet,
                        WExpr.Binary(WBinaryOp.Add, sjGet,
                            WExpr.Const(WConst.I32 1), WType.I32),
                        WExpr.ArrayGet(arrGet, sjGet, arrElemT))
                    WExpr.Assign(sjVar,
                        WExpr.Binary(WBinaryOp.Sub, sjGet,
                            WExpr.Const(WConst.I32 1), WType.I32))
                    WExpr.Continue(sjLoopLabel, [])
                ]
            let sjLoop = WExpr.Loop(sjLoopLabel,
                WExpr.If(sjCond, sjStep, WExpr.Nop, WType.Void), WType.Void)
            let siStep =
                WExpr.Sequence [
                    WExpr.Let(seVar, readElem arrGet siGet,
                        WExpr.LetMut(sjVar,
                            WExpr.Binary(WBinaryOp.Sub, siGet,
                                WExpr.Const(WConst.I32 1), WType.I32),
                            WExpr.Sequence [
                                sjLoop
                                WExpr.ArraySet(arrGet,
                                    WExpr.Binary(WBinaryOp.Add, sjGet,
                                        WExpr.Const(WConst.I32 1), WType.I32),
                                    seGet)
                            ]))
                    WExpr.Assign(siVar,
                        WExpr.Binary(WBinaryOp.Add, siGet,
                            WExpr.Const(WConst.I32 1), WType.I32))
                    WExpr.Continue(siLoopLabel, [])
                ]
            let siLoop = WExpr.Loop(siLoopLabel,
                WExpr.If(WExpr.Compare(WCompareOp.LtS, siGet, lenGet),
                    siStep, WExpr.Nop, WType.Void),
                WType.Void)
            // Pass 4: rebuild list by walking array from len-1 down to 0 (forward cons)
            let riLoopBody =
                WExpr.If(
                    WExpr.Compare(WCompareOp.GeS, riGet, WExpr.Const(WConst.I32 0)),
                    WExpr.Sequence [
                        WExpr.Assign(accVar,
                            WExpr.StructNew(consIdx,
                                [readElem arrGet riGet; accGet],
                                listBaseRefT))
                        WExpr.Assign(riVar,
                            WExpr.Binary(WBinaryOp.Sub, riGet,
                                WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(riLoopLabel, [])
                    ],
                    WExpr.Nop, WType.Void)
            Some(WExpr.Let(lstVar, wLst,
                WExpr.Let(lenVar, countLen,
                    WExpr.Let(arrVar,
                        WExpr.ArrayNew(arrTypeIdx, lenGet,
                            arrDefault, arrRefT),
                        WExpr.Sequence [
                            fillArray
                            WExpr.LetMut(siVar, WExpr.Const(WConst.I32 1),
                                WExpr.Sequence [siLoop])
                            WExpr.LetMut(riVar,
                                WExpr.Binary(WBinaryOp.Sub, lenGet,
                                    WExpr.Const(WConst.I32 1), WType.I32),
                                WExpr.LetMut(accVar, null_list,
                                    WExpr.Sequence [
                                        WExpr.Loop(riLoopLabel, riLoopBody, WType.Void)
                                        accGet
                                    ]))
                        ]))))
        | None -> None
    // List.sortWith cmp xs — sort using a user-provided 2-arg comparator.
    // Strategy: list → array; insertion sort using inlined comparator call; rebuild.
    | "sortWith", (cmpArg :: listArg :: _) ->
        // Unpack the comparator into (arg1, arg2, body):
        // Fable may represent 'fun a b -> ...' as Lambda(a,Lambda(b,body)) or Delegate([a;b],body)
        let cmpParts =
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
        match tryListTypeInfo ctx listArg with
        | None -> None
        | Some(elemT, consIdx) ->
        // For sorting, we need an array. Ref-typed elements require nullable array storage
        // to allow array.new with a null default; we cast back to non-nullable on read.
        let (arrElemT, arrDefault) =
            match elemT with
            | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
            | t -> t, makeNumericZero t
        let readElem arrExpr idxExpr =
            match elemT with
            | WType.Ref(idx, false) ->
                WExpr.Cast(WExpr.ArrayGet(arrExpr, idxExpr, arrElemT), WType.Ref(idx, false))
            | _ -> WExpr.ArrayGet(arrExpr, idxExpr, elemT)
        let arrTypeIdx = getOrAddArrayType ctx arrElemT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let s   = mkListShape elemT consIdx
        // Compile comparator body with both args in scope
        let ctx'  = ctx.WithLocal(farg1.Name, elemT)
        let ctx'' = ctx'.WithLocal(farg2.Name, elemT)
        let wCmp  = transform ctx'' fbody   // result: i32 (negative/zero/positive)
        let wLst  = transform ctx listArg
        let lstVar    = "$lsw_lst"
        let arrVar    = "$lsw_arr"
        let lenVar    = "$lsw_len"
        let iVar      = "$lsw_i"
        let jVar      = "$lsw_j"
        let eVar      = "$lsw_e"
        let riVar     = "$lsw_ri"
        let accVar    = "$lsw_acc"
        let siLoopLabel = "$lsw_sil"
        let sjLoopLabel = "$lsw_sjl"
        let riLoopLabel = "$lsw_ril"
        let lstGet    = WExpr.LocalGet(lstVar, s.BaseTy)
        let arrGet    = WExpr.LocalGet(arrVar, arrRefT)
        let lenGet    = WExpr.LocalGet(lenVar, WType.I32)
        let iGet      = WExpr.LocalGet(iVar, WType.I32)
        let jGet      = WExpr.LocalGet(jVar, WType.I32)
        let eGet      = WExpr.LocalGet(eVar, elemT)
        let riGet     = WExpr.LocalGet(riVar, WType.I32)
        let accGet    = WExpr.LocalGet(accVar, s.BaseTy)
        // Inline comparator: let-bind both args, then evaluate body
        let inlineCmp aExpr bExpr =
            WExpr.Let(farg1.Name, aExpr,
                WExpr.Let(farg2.Name, bExpr,
                    wCmp))
        let countLen =
            mkListLoop "lswlen" elemT consIdx lstGet
                [("$lswlen_c", WExpr.Const(WConst.I32 0))]
                (fun _ -> WExpr.Assign("$lswlen_c",
                    WExpr.Binary(WBinaryOp.Add,
                        WExpr.LocalGet("$lswlen_c", WType.I32),
                        WExpr.Const(WConst.I32 1), WType.I32)))
                (WExpr.LocalGet("$lswlen_c", WType.I32)) None
        let fillArray =
            mkListLoop "lswfill" elemT consIdx lstGet
                [("$lswfill_i", WExpr.Const(WConst.I32 0))]
                (fun h ->
                    WExpr.Sequence [
                        WExpr.ArraySet(arrGet, WExpr.LocalGet("$lswfill_i", WType.I32), h)
                        WExpr.Assign("$lswfill_i",
                            WExpr.Binary(WBinaryOp.Add,
                                WExpr.LocalGet("$lswfill_i", WType.I32),
                                WExpr.Const(WConst.I32 1), WType.I32))
                    ])
                WExpr.Nop None
        // j-loop: shift elements right while cmp(arr[j], e) > 0
        let sjCond =
            WExpr.If(WExpr.Compare(WCompareOp.GeS, jGet, WExpr.Const(WConst.I32 0)),
                WExpr.Compare(WCompareOp.GtS,
                    inlineCmp (readElem arrGet jGet) eGet,
                    WExpr.Const(WConst.I32 0)),
                WExpr.Const(WConst.I32 0), WType.I32)
        let sjStep =
            WExpr.Sequence [
                WExpr.ArraySet(arrGet,
                    WExpr.Binary(WBinaryOp.Add, jGet, WExpr.Const(WConst.I32 1), WType.I32),
                    readElem arrGet jGet)
                WExpr.Assign(jVar,
                    WExpr.Binary(WBinaryOp.Sub, jGet, WExpr.Const(WConst.I32 1), WType.I32))
                WExpr.Continue(sjLoopLabel, [])
            ]
        let sjLoop = WExpr.Loop(sjLoopLabel,
            WExpr.If(sjCond, sjStep, WExpr.Nop, WType.Void), WType.Void)
        let siStep =
            WExpr.Sequence [
                WExpr.Let(eVar, readElem arrGet iGet,
                    WExpr.LetMut(jVar,
                        WExpr.Binary(WBinaryOp.Sub, iGet, WExpr.Const(WConst.I32 1), WType.I32),
                        WExpr.Sequence [
                            sjLoop
                            WExpr.ArraySet(arrGet,
                                WExpr.Binary(WBinaryOp.Add, jGet,
                                    WExpr.Const(WConst.I32 1), WType.I32),
                                eGet)
                        ]))
                WExpr.Assign(iVar,
                    WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
                WExpr.Continue(siLoopLabel, [])
            ]
        let siLoop = WExpr.Loop(siLoopLabel,
            WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet),
                siStep, WExpr.Nop, WType.Void),
            WType.Void)
        let riLoopBody =
            WExpr.If(
                WExpr.Compare(WCompareOp.GeS, riGet, WExpr.Const(WConst.I32 0)),
                WExpr.Sequence [
                    WExpr.Assign(accVar,
                        WExpr.StructNew(consIdx,
                            [readElem arrGet riGet; accGet],
                            listBaseRefT))
                    WExpr.Assign(riVar,
                        WExpr.Binary(WBinaryOp.Sub, riGet, WExpr.Const(WConst.I32 1), WType.I32))
                    WExpr.Continue(riLoopLabel, [])
                ],
                WExpr.Nop, WType.Void)
        Some(WExpr.Let(lstVar, wLst,
            WExpr.Let(lenVar, countLen,
                WExpr.Let(arrVar,
                    WExpr.ArrayNew(arrTypeIdx, lenGet, arrDefault, arrRefT),
                    WExpr.Sequence [
                        fillArray
                        WExpr.LetMut(iVar, WExpr.Const(WConst.I32 1),
                            WExpr.Sequence [siLoop])
                        WExpr.LetMut(riVar,
                            WExpr.Binary(WBinaryOp.Sub, lenGet,
                                WExpr.Const(WConst.I32 1), WType.I32),
                            WExpr.LetMut(accVar, s.Nil,
                                WExpr.Sequence [
                                    WExpr.Loop(riLoopLabel, riLoopBody, WType.Void)
                                    accGet
                                ]))
                    ]))))
    // List.flatten xss / List.concat xss — flatten list-of-lists using listFold combinators.
    // Two nested listFolds + one final listRev restores order.
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
        // Fold outer → for each inner list, fold inner prepend-reversed into accumulator
        let revResult =
            listFold gen os wLst s.Nil s.BaseTy
                (fun acc innerList ->
                    listFold gen s innerList acc s.BaseTy
                        (fun acc2 elem -> s.Cons elem acc2))
        Some(listRev gen s revResult)
    // List.zip xs ys — combine two lists into a list of pairs.
    // Strategy: walk both lists in parallel, cons tuples, then reverse.
    | "zip", (xsArg :: ysArg :: _) ->
        // Get element types of both input lists
        let xsElemFableT =
            match xsArg.Type with | Fable.Type.List t -> Some t | _ -> None
        let ysElemFableT =
            match ysArg.Type with | Fable.Type.List t -> Some t | _ -> None
        match xsElemFableT, ysElemFableT with
        | None, _ | _, None -> None
        | Some xElemFT, Some yElemFT ->
        let xElemT = mapTypeKnown ctx xElemFT
        let yElemT = mapTypeKnown ctx yElemFT
        let tupleFableT = Fable.Type.Tuple([xElemFT; yElemFT], false)
        let tupleWType  = mapTypeKnown ctx tupleFableT  // registers tuple struct if needed
        let tupleIdx    =
            let key = wTypesKey [xElemT; yElemT]
            match ctx.TupleRegistry.TryGetValue(key) with
            | true, idx -> idx
            | _ -> failwith "tuple not registered after mapTypeKnown"
        let tupleRefT   = WType.Ref(tupleIdx, false)
        let tupleNullRefT = WType.Ref(tupleIdx, true)
        // Get cons type for the output list (pairs)
        match tryListTypeInfoFromElemType ctx tupleFableT with
        | None -> None
        | Some(pairElemT, pairConsIdx) ->
        match tryListTypeInfo ctx xsArg with
        | None -> None
        | Some(xElemT2, xConsIdx) ->
        match tryListTypeInfo ctx ysArg with
        | None -> None
        | Some(yElemT2, yConsIdx) ->
        let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
        let xListNNRefT  = WType.Ref(xConsIdx, false)
        let yListNNRefT  = WType.Ref(yConsIdx, false)
        let pairListNNRefT = WType.Ref(pairConsIdx, false)
        let xPtr    = "$zip_xp"
        let yPtr    = "$zip_yp"
        let accVar  = "$zip_acc"
        let xnn     = "$zip_xnn"
        let ynn     = "$zip_ynn"
        let loopLabel = "$zip_loop"
        let wXs = transform ctx xsArg
        let wYs = transform ctx ysArg
        let loopBody =
            WExpr.If(
                WExpr.Unary(WUnaryOp.Eqz,
                    WExpr.RefIsNull(WExpr.LocalGet(xPtr, listBaseRefT)), WType.I32),
                WExpr.If(
                    WExpr.Unary(WUnaryOp.Eqz,
                        WExpr.RefIsNull(WExpr.LocalGet(yPtr, listBaseRefT)), WType.I32),
                    WExpr.Sequence [
                        WExpr.Let(xnn, WExpr.Cast(WExpr.LocalGet(xPtr, listBaseRefT), xListNNRefT),
                            WExpr.Let(ynn, WExpr.Cast(WExpr.LocalGet(yPtr, listBaseRefT), yListNNRefT),
                                WExpr.Sequence [
                                    WExpr.Assign(accVar,
                                        WExpr.StructNew(pairConsIdx,
                                            [WExpr.StructNew(tupleIdx,
                                                [WExpr.StructGet(WExpr.LocalGet(xnn, xListNNRefT), 0, xElemT)
                                                 WExpr.StructGet(WExpr.LocalGet(ynn, yListNNRefT), 0, yElemT)],
                                                tupleRefT)
                                             WExpr.LocalGet(accVar, listBaseRefT)],
                                            listBaseRefT))
                                    WExpr.Assign(xPtr,
                                        WExpr.StructGet(WExpr.LocalGet(xnn, xListNNRefT), 1, listBaseRefT))
                                    WExpr.Assign(yPtr,
                                        WExpr.StructGet(WExpr.LocalGet(ynn, yListNNRefT), 1, listBaseRefT))
                                    WExpr.Continue(loopLabel, [])
                                ]))
                    ],
                    WExpr.Nop, WType.Void),
                WExpr.Nop, WType.Void)
        let loop = WExpr.Loop(loopLabel, loopBody, WType.Void)
        let accumulate =
            WExpr.LetMut(xPtr, wXs,
                WExpr.LetMut(yPtr, wYs,
                    WExpr.LetMut(accVar, WExpr.Const(WConst.Null listBaseRefT),
                        WExpr.Sequence [
                            loop
                            WExpr.LocalGet(accVar, listBaseRefT)
                        ])))
        // Reverse the accumulated list
        let gen = LabelGen("zip")
        let sOut = mkListShape pairElemT pairConsIdx
        Some(listRev gen sOut accumulate)
    // List.map2 f xs ys — apply a 2-arg function to each pair of elements.
    // Strategy: walk both lists in parallel, cons f(x,y), then reverse.
    | "map2", (cmpArg :: xsArg :: ysArg :: _) ->
        // Unpack the 2-arg function (same patterns as sortWith)
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
        match tryListTypeInfo ctx xsArg with
        | None -> None
        | Some(xElemT, xConsIdx) ->
        match tryListTypeInfo ctx ysArg with
        | None -> None
        | Some(yElemT, yConsIdx) ->
        // Result element type from the lambda body
        let resultFableT = fbody.Type
        match tryListTypeInfoFromElemType ctx resultFableT with
        | None -> None
        | Some(resultElemT, resultConsIdx) ->
        let wBody = transform ctx fbody
        let listBaseRefT  = WType.Ref(ListBaseTypeIdx, true)
        let xListNNRefT   = WType.Ref(xConsIdx, false)
        let yListNNRefT   = WType.Ref(yConsIdx, false)
        let xPtr    = "$m2_xp"
        let yPtr    = "$m2_yp"
        let accVar  = "$m2_acc"
        let xnn     = "$m2_xnn"
        let ynn     = "$m2_ynn"
        let loopLabel = "$m2_loop"
        let wXs = transform ctx xsArg
        let wYs = transform ctx ysArg
        let inlineCall xExpr yExpr =
            WExpr.Let(farg1.Name, xExpr, WExpr.Let(farg2.Name, yExpr, wBody))
        let loopBody =
            WExpr.If(
                WExpr.Unary(WUnaryOp.Eqz,
                    WExpr.RefIsNull(WExpr.LocalGet(xPtr, listBaseRefT)), WType.I32),
                WExpr.If(
                    WExpr.Unary(WUnaryOp.Eqz,
                        WExpr.RefIsNull(WExpr.LocalGet(yPtr, listBaseRefT)), WType.I32),
                    WExpr.Sequence [
                        WExpr.Let(xnn, WExpr.Cast(WExpr.LocalGet(xPtr, listBaseRefT), xListNNRefT),
                            WExpr.Let(ynn, WExpr.Cast(WExpr.LocalGet(yPtr, listBaseRefT), yListNNRefT),
                                WExpr.Sequence [
                                    WExpr.Assign(accVar,
                                        WExpr.StructNew(resultConsIdx,
                                            [inlineCall
                                                (WExpr.StructGet(WExpr.LocalGet(xnn, xListNNRefT), 0, xElemT))
                                                (WExpr.StructGet(WExpr.LocalGet(ynn, yListNNRefT), 0, yElemT))
                                             WExpr.LocalGet(accVar, listBaseRefT)],
                                            listBaseRefT))
                                    WExpr.Assign(xPtr,
                                        WExpr.StructGet(WExpr.LocalGet(xnn, xListNNRefT), 1, listBaseRefT))
                                    WExpr.Assign(yPtr,
                                        WExpr.StructGet(WExpr.LocalGet(ynn, yListNNRefT), 1, listBaseRefT))
                                    WExpr.Continue(loopLabel, [])
                                ]))
                    ],
                    WExpr.Nop, WType.Void),
                WExpr.Nop, WType.Void)
        let loop = WExpr.Loop(loopLabel, loopBody, WType.Void)
        let accumulate =
            WExpr.LetMut(xPtr, wXs,
                WExpr.LetMut(yPtr, wYs,
                    WExpr.LetMut(accVar, WExpr.Const(WConst.Null listBaseRefT),
                        WExpr.Sequence [
                            loop
                            WExpr.LocalGet(accVar, listBaseRefT)
                        ])))
        let gen = LabelGen("m2")
        let sOut = mkListShape resultElemT resultConsIdx
        Some(listRev gen sOut accumulate)
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List primitives (no lambda — direct structural operations)
// ─────────────────────────────────────────────────────────────────

/// Dispatch list primitives that don't require a higher-order function.
/// Returns Some(WExpr) if handled, None to fall through to the general import path.
let tryListPrimitiveInline
        (ctx: Ctx)
        (selector: string)
        (wArgs: WExpr list)
        (ty: WType)
        (fableArgs: Fable.Expr list) : WExpr option =
    let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
    match selector, wArgs with
    // Seq.toList xs / List.ofList xs — when the arg is already a WasmGC list, identity.
    | ("toList" | "ofList"), [wList] ->
        match tryListTypeInfo ctx (List.head fableArgs) with
        | Some _ -> Some wList
        | None   -> None
    // List.head xs
    | "head", [wList] ->
        let elemT = ty
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            Some(WExpr.StructGet(WExpr.Cast(wList, WType.Ref(listConsIdx, false)), 0, elemT))
        | _ -> None
    // List.tail xs
    | "tail", [wList] ->
        let innerElemFableType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let innerElemWType = mapTypeKnown ctx innerElemFableType
        let elemKey = wTypeKey innerElemWType
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let nn = WExpr.Cast(wList, WType.Ref(listConsIdx, false))
            Some(WExpr.StructGet(nn, 1, listBaseRefT))
        | _ -> None
    // List.isEmpty xs
    | "isEmpty", [wList] when ty = WType.I32 ->
        match exprWType wList with
        | WType.Ref(_, _) -> Some(WExpr.RefIsNull(wList))
        | _ -> Some(WExpr.Compare(WCompareOp.Eq, wList, WExpr.Const(WConst.I32 0)))
    // List.length xs
    | "length", [wList] when ty = WType.I32 ->
        let innerElemFableType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let innerElemWType = mapTypeKnown ctx innerElemFableType
        let elemKey = wTypeKey innerElemWType
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let listNNRefT = WType.Ref(listConsIdx, false)
            let ptrName = "$listlen_ptr"
            let cntName = "$listlen_count"
            let loopLabel = "$listlen_loop"
            let loopBody =
                WExpr.If(
                    WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull(WExpr.LocalGet(ptrName, listBaseRefT)), WType.I32),
                    WExpr.Sequence [
                        WExpr.Assign(cntName, WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(cntName, WType.I32), WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Assign(ptrName,
                            WExpr.StructGet(WExpr.Cast(WExpr.LocalGet(ptrName, listBaseRefT), listNNRefT), 1, listBaseRefT))
                        WExpr.Continue(loopLabel, [])
                    ],
                    WExpr.Nop, WType.Void)
            Some(WExpr.LetMut(cntName, WExpr.Const(WConst.I32 0),
                WExpr.LetMut(ptrName, wList,
                    WExpr.Sequence [
                        WExpr.Loop(loopLabel, loopBody, WType.Void)
                        WExpr.LocalGet(cntName, WType.I32)
                    ])))
        | _ -> None
    // List.rev xs (selector "reverse" in Fable due to CompiledName)
    | ("reverse" | "rev"), [wList] ->
        let fableElemType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let elemT   = mapTypeKnown ctx fableElemType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let listNNRefT = WType.Ref(listConsIdx, false)
            let null_list  = WExpr.Const(WConst.Null listBaseRefT)
            let ptrName = "$rev_ptr"
            let resName = "$rev_result"
            let nnName  = "$rev_nn"
            let loopLbl = "$rev_loop"
            let step =
                WExpr.Let(nnName, WExpr.Cast(WExpr.LocalGet(ptrName, listBaseRefT), listNNRefT),
                    WExpr.Sequence [
                        WExpr.Assign(resName,
                            WExpr.StructNew(listConsIdx,
                                [WExpr.StructGet(WExpr.LocalGet(nnName, listNNRefT), 0, elemT);
                                 WExpr.LocalGet(resName, listBaseRefT)],
                                listBaseRefT))
                        WExpr.Assign(ptrName, WExpr.StructGet(WExpr.LocalGet(nnName, listNNRefT), 1, listBaseRefT))
                        WExpr.Continue(loopLbl, [])
                    ])
            let body =
                WExpr.If(
                    WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull(WExpr.LocalGet(ptrName, listBaseRefT)), WType.I32),
                    step, WExpr.Nop, WType.Void)
            Some(WExpr.LetMut(ptrName, wList,
                WExpr.LetMut(resName, null_list,
                    WExpr.Sequence [
                        WExpr.Loop(loopLbl, body, WType.Void)
                        WExpr.LocalGet(resName, listBaseRefT)
                    ])))
        | _ -> None
    // List.append xs ys
    | "append", [wXs; wYs] ->
        let fableElemType =
            match fableArgs with
            | [a; _] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let elemT   = mapTypeKnown ctx fableElemType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let listNNRefT = WType.Ref(listConsIdx, false)
            let null_list  = WExpr.Const(WConst.Null listBaseRefT)
            let p1Name = "$app_p1"
            let revName = "$app_rev"
            let nn1Name = "$app_nn1"
            let p2Name = "$app_p2"
            let nn2Name = "$app_nn2"
            let resName = "$app_result"
            let loop1 = "$app_loop1"
            let loop2 = "$app_loop2"
            let mkHead e = WExpr.StructGet(e, 0, elemT)
            let mkTail e = WExpr.StructGet(e, 1, listBaseRefT)
            let step1 =
                WExpr.Let(nn1Name, WExpr.Cast(WExpr.LocalGet(p1Name, listBaseRefT), listNNRefT),
                    WExpr.Sequence [
                        WExpr.Assign(revName,
                            WExpr.StructNew(listConsIdx,
                                [mkHead (WExpr.LocalGet(nn1Name, listNNRefT));
                                 WExpr.LocalGet(revName, listBaseRefT)],
                                listBaseRefT))
                        WExpr.Assign(p1Name, mkTail (WExpr.LocalGet(nn1Name, listNNRefT)))
                        WExpr.Continue(loop1, [])
                    ])
            let body1 =
                WExpr.If(
                    WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull(WExpr.LocalGet(p1Name, listBaseRefT)), WType.I32),
                    step1, WExpr.Nop, WType.Void)
            let step2 =
                WExpr.Let(nn2Name, WExpr.Cast(WExpr.LocalGet(p2Name, listBaseRefT), listNNRefT),
                    WExpr.Sequence [
                        WExpr.Assign(resName,
                            WExpr.StructNew(listConsIdx,
                                [mkHead (WExpr.LocalGet(nn2Name, listNNRefT));
                                 WExpr.LocalGet(resName, listBaseRefT)],
                                listBaseRefT))
                        WExpr.Assign(p2Name, mkTail (WExpr.LocalGet(nn2Name, listNNRefT)))
                        WExpr.Continue(loop2, [])
                    ])
            let body2 =
                WExpr.If(
                    WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull(WExpr.LocalGet(p2Name, listBaseRefT)), WType.I32),
                    step2, WExpr.Nop, WType.Void)
            Some(WExpr.LetMut(p1Name, wXs,
                WExpr.LetMut(revName, null_list,
                    WExpr.Sequence [
                        WExpr.Loop(loop1, body1, WType.Void)
                        WExpr.LetMut(p2Name, WExpr.LocalGet(revName, listBaseRefT),
                            WExpr.LetMut(resName, wYs,
                                WExpr.Sequence [
                                    WExpr.Loop(loop2, body2, WType.Void)
                                    WExpr.LocalGet(resName, listBaseRefT)
                                ]))
                    ])))
        | _ -> None
    // List.sum xs
    | "sum", _ when List.length wArgs <= 2 ->
        let listFableArg =
            match fableArgs with
            | [a] | [a; _] -> a
            | _ -> List.head fableArgs
        let listTypeInfo =
            match tryListTypeInfo ctx listFableArg with
            | Some ti -> Some ti
            | None ->
                // TODO: why direct why not tryElemType
                // ty is the WType of the element (same as result for sum); look up directly
                let elemKey = wTypeKey ty
                match ctx.ListRegistry.TryGetValue(elemKey) with
                | true, listConsIdx -> Some(ty, listConsIdx)
                | _ -> None
        match listTypeInfo with
        | Some(elemT, listConsIdx) ->
            let wList = match wArgs with | [a] -> a | [a; _] -> a | _ -> WExpr.Const(WConst.Null(listBaseRefT))
            let zero =
                match elemT with
                | WType.I64 -> WExpr.Const(WConst.I64 0L)
                | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
                | WType.F64 -> WExpr.Const(WConst.F64 0.0)
                | _ -> WExpr.Const(WConst.I32 0)
            Some(mkListLoop "sum" elemT listConsIdx wList
                    [("$sum_acc", zero)]
                    (fun h -> WExpr.Assign("$sum_acc",
                        WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet("$sum_acc", elemT), h, elemT)))
                    (WExpr.LocalGet("$sum_acc", elemT)) None)
        | None -> None
    // List.item n xs
    | "item", [nExpr; wList] ->
        let innerFableType =
            match fableArgs with
            | [_; a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let realElemT = mapTypeKnown ctx innerFableType
        let elemKey = wTypeKey realElemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let listNNRefT = WType.Ref(listConsIdx, false)
            let ptrName = "$item_ptr"
            let cntName = "$item_cnt"
            let nnName  = "$item_nn"
            let loopLabel = "$item_loop"
            let stepBody =
                WExpr.Let(nnName, WExpr.Cast(WExpr.LocalGet(ptrName, listBaseRefT), listNNRefT),
                    WExpr.Sequence [
                        WExpr.Assign(ptrName, WExpr.StructGet(WExpr.LocalGet(nnName, listNNRefT), 1, listBaseRefT))
                        WExpr.Assign(cntName, WExpr.Binary(WBinaryOp.Sub, WExpr.LocalGet(cntName, WType.I32), WExpr.Const(WConst.I32 1), WType.I32))
                        WExpr.Continue(loopLabel, [])
                    ])
            let loopBody =
                WExpr.If(
                    WExpr.Compare(WCompareOp.GtS, WExpr.LocalGet(cntName, WType.I32), WExpr.Const(WConst.I32 0)),
                    stepBody, WExpr.Nop, WType.Void)
            let finalNN = WExpr.Cast(WExpr.LocalGet(ptrName, listBaseRefT), listNNRefT)
            Some(WExpr.LetMut(cntName, nExpr,
                WExpr.LetMut(ptrName, wList,
                    WExpr.Sequence [
                        WExpr.Loop(loopLabel, loopBody, WType.Void)
                        WExpr.StructGet(finalNN, 0, realElemT)
                    ])))
        | _ -> None
    // List.min / List.max — fold from head, update running best
    // After ReplacementsInject, args = [list; comparer]. Disambiguate from Math.min(a,b)
    // by checking that the first fable arg is a List type.
    | ("min" | "max"), (wListArg :: _) when (match fableArgs with ha :: _ -> (match ha.Type with | Fable.Type.List _ -> true | _ -> false) | _ -> false) ->
        let listFableArg = List.head fableArgs
        let isMin = selector = "min"
        match tryListTypeInfo ctx listFableArg with
        | Some(elemT, listConsIdx) ->
            let listNNRefT = WType.Ref(listConsIdx, false)
            let bestVar    = "$listmm_best"
            let bestGet    = WExpr.LocalGet(bestVar, elemT)
            let cmpOp      = if isMin then WCompareOp.LtS else WCompareOp.GtS
            let headElem   = WExpr.StructGet(WExpr.Cast(wListArg, listNNRefT), 0, elemT)
            let headTail   = WExpr.StructGet(WExpr.Cast(wListArg, listNNRefT), 1, listBaseRefT)
            Some(WExpr.Let("$listmm_lst", wListArg,
                WExpr.LetMut(bestVar, headElem,
                    WExpr.Sequence [
                        mkListLoop "listmm" elemT listConsIdx headTail []
                            (fun h ->
                                WExpr.Let("$listmm_h", h,
                                    WExpr.If(WExpr.Compare(cmpOp, WExpr.LocalGet("$listmm_h", elemT), bestGet),
                                        WExpr.Assign(bestVar, WExpr.LocalGet("$listmm_h", elemT)),
                                        WExpr.Nop, WType.Void)))
                            WExpr.Nop None
                        bestGet
                    ])))
        | None -> None
    // List.contains needle list — linear search with early exit
    // After ReplacementsInject, args = [needle; list; comparer]. ty = I32 (bool).
    | "contains", (wNeedle :: wListArg :: _) when (match fableArgs with | _ :: ha :: _ -> (match ha.Type with | Fable.Type.List _ -> true | _ -> false) | _ -> false) ->
        let listFableArg = List.item 1 fableArgs
        match tryListTypeInfo ctx listFableArg with
        | Some(elemT, listConsIdx) ->
            let exitLabel = "$lcont_exit"
            Some(WExpr.Let("$lcont_needle", wNeedle,
                mkListLoop "lcont" elemT listConsIdx wListArg []
                    (fun h ->
                        WExpr.Let("$lcont_h", h,
                            WExpr.If(WExpr.Compare(WCompareOp.Eq, WExpr.LocalGet("$lcont_h", elemT), WExpr.LocalGet("$lcont_needle", elemT)),
                                WExpr.Break(exitLabel, Some(WExpr.Const(WConst.I32 1))),
                                WExpr.Nop, WType.Void)))
                    (WExpr.Const(WConst.I32 0)) (Some(exitLabel, WType.I32))))
        | None -> None
    // List.ofArray arr — convert GC array to linked list using arrayToListRev combinator.
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
                let arrVar  = "$ofa_arr"
                Some(WExpr.Let(arrVar, wArr,
                    let a = WExpr.LocalGet(arrVar, arrRefT)
                    arrayToListRev gen s a (WExpr.ArrayLen a)
                        (fun ar i -> WExpr.ArrayGet(ar, i, elemT))))
        | _ -> None
    // List.last xs — iterate to the end, return the final element
    | "last", [wList] ->
        let innerFableType =
            match fableArgs with
            | [a] -> (match a.Type with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any)
            | _ -> Fable.Type.Any
        let elemT   = mapTypeKnown ctx innerFableType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let listNNRefT = WType.Ref(listConsIdx, false)
            let lstVar    = "$last_lst"
            let valVar    = "$last_val"
            let ptrVar    = "$last_ptr"
            let nnVar     = "$last_nn"
            let loopLabel = "$last_loop"
            let lstGet    = WExpr.LocalGet(lstVar, listBaseRefT)
            let lstNN     = WExpr.Cast(lstGet, listNNRefT)
            let loopStep =
                WExpr.Let(nnVar,
                    WExpr.Cast(WExpr.LocalGet(ptrVar, listBaseRefT), listNNRefT),
                    WExpr.Sequence [
                        WExpr.Assign(valVar, WExpr.StructGet(WExpr.LocalGet(nnVar, listNNRefT), 0, elemT))
                        WExpr.Assign(ptrVar, WExpr.StructGet(WExpr.LocalGet(nnVar, listNNRefT), 1, listBaseRefT))
                        WExpr.Continue(loopLabel, [])
                    ])
            let loopBody =
                WExpr.If(
                    WExpr.Unary(WUnaryOp.Eqz,
                        WExpr.RefIsNull(WExpr.LocalGet(ptrVar, listBaseRefT)),
                        WType.I32),
                    loopStep, WExpr.Nop, WType.Void)
            Some(WExpr.Let(lstVar, wList,
                WExpr.LetMut(valVar, WExpr.StructGet(lstNN, 0, elemT),
                    WExpr.LetMut(ptrVar, WExpr.StructGet(lstNN, 1, listBaseRefT),
                        WExpr.Sequence [
                            WExpr.Loop(loopLabel, loopBody, WType.Void)
                            WExpr.LocalGet(valVar, elemT)
                        ]))))
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
    let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
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
            let tmpName = "$tryHead_tmp"
            let someBranch =
                WExpr.StructNew(optTypeIdx,
                    [WExpr.StructGet(WExpr.Cast(WExpr.LocalGet(tmpName, listBaseRefT), listNNRefT), 0, elemT)],
                    ty)
            let noneBranch = WExpr.Const(WConst.Null(ty))
            Some(WExpr.Let(tmpName, wList,
                WExpr.If(WExpr.RefIsNull(WExpr.LocalGet(tmpName, listBaseRefT)),
                    noneBranch, someBranch, ty)))
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
        | Some(elemT, listConsIdx) ->
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
            Some(mkListLoop "tryf" elemT listConsIdx wList []
                    (fun h -> WExpr.Let(farg.Name, h,
                        WExpr.If(wPred,
                            WExpr.Break("$tryf_exit", Some(WExpr.StructNew(optTypeIdx, [WExpr.LocalGet(farg.Name, elemT)], ty))),
                            WExpr.Nop, WType.Void)))
                    (WExpr.Const(WConst.Null ty)) (Some("$tryf_exit", ty)))
        | None -> None
    // List.findIndex pred xs — first 0-based index where pred holds; -1 if not found
    | ("findIndex" | "tryFindIndex"), [Fable.Expr.Lambda(farg, fbody, _); listArg]
    | ("findIndex" | "tryFindIndex"), [Fable.Expr.Delegate([farg], fbody, _, _); listArg] ->
        match tryListTypeInfo ctx listArg with
        | Some(elemT, listConsIdx) ->
            let wList = transform ctx listArg
            let ctx'  = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            let idxVar = "$fdi_idx"
            let result =
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
                    let stepBody h =
                        WExpr.Let(farg.Name, h,
                            WExpr.If(wPred,
                                WExpr.Break("$fdi_exit", Some(WExpr.StructNew(optTypeIdx, [WExpr.LocalGet(idxVar, WType.I32)], ty))),
                                WExpr.Assign(idxVar, WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(idxVar, WType.I32), WExpr.Const(WConst.I32 1), WType.I32)),
                                WType.Void))
                    WExpr.LetMut(idxVar, WExpr.Const(WConst.I32 0),
                        mkListLoop "fdi" elemT listConsIdx wList []
                            stepBody (WExpr.Const(WConst.Null ty)) (Some("$fdi_exit", ty)))
                else
                    let stepBody h =
                        WExpr.Let(farg.Name, h,
                            WExpr.If(wPred,
                                WExpr.Break("$fdi_exit", Some(WExpr.LocalGet(idxVar, WType.I32))),
                                WExpr.Assign(idxVar, WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(idxVar, WType.I32), WExpr.Const(WConst.I32 1), WType.I32)),
                                WType.Void))
                    WExpr.LetMut(idxVar, WExpr.Const(WConst.I32 0),
                        mkListLoop "fdi" elemT listConsIdx wList []
                            stepBody (WExpr.Const(WConst.I32 -1)) (Some("$fdi_exit", WType.I32)))
            Some result
        | None -> None
    | _ -> None

