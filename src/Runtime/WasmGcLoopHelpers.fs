/// Loop builder helpers for list and array traversal patterns.
/// Extracted from Fable2WasmGc.fs for reuse across replacements.
module Fable.Transforms.WasmGc.WasmGcLoopHelpers

open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes

// ─────────────────────────────────────────────────────────────────
// List type info helpers
// ─────────────────────────────────────────────────────────────────

/// Resolve the list cons type-index and element WType for a Fable list argument.
/// Registers the cons type if not already present.
/// Returns None when the argument is not a List type.
let tryListTypeInfo (ctx: Ctx) (listFableArg: Fable.Expr) : (WType * int) option =
    match listFableArg.Type with
    | Fable.Type.List(elemFableType) ->
        let _ = mapTypeKnown ctx (Fable.Type.List(elemFableType))
        let elemT   = mapTypeKnown ctx elemFableType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, idx -> Some(elemT, idx)
        | _         -> None
    | _ -> None

/// Variant that takes the ELEMENT Fable type directly.
let tryListTypeInfoFromElemType (ctx: Ctx) (elemFableType: Fable.Type) : (WType * int) option =
    let _ = mapTypeKnown ctx (Fable.Type.List(elemFableType))
    let elemT = mapTypeKnown ctx elemFableType
    let key   = wTypeKey elemT
    match ctx.ListRegistry.TryGetValue(key) with
    | true, idx -> Some(elemT, idx)
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// mkListLoop — unified list traversal skeleton
// ─────────────────────────────────────────────────────────────────

/// Build a complete list-traversal WExpr.
///
/// prefix    – unique label/name prefix (e.g. "fold", "iter")
/// elemT     – WType of list elements
/// consIdx   – GC struct type index of the $ListCons_T type
/// wList     – the list WExpr (type = ref null $ListBase)
/// extraMuts – outer mutable accumulators [(name, initExpr)]
/// perStep   – receives the head WExpr; returns a Void body for each element
/// postLoop  – expression returned after the loop exits naturally
/// exitBlock – if Some(exitLabel, resultTy), wraps everything in Block for early exit
let mkListLoop
        (prefix: string)
        (elemT: WType) (consIdx: int) (wList: WExpr)
        (extraMuts: (string * WExpr) list)
        (perStep: WExpr -> WExpr)
        (postLoop: WExpr)
        (exitBlock: (string * WType) option) : WExpr =
    let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
    let listNNRefT   = WType.Ref(consIdx, false)
    let ptrName   = $"${prefix}_ptr"
    let nnName    = $"${prefix}_nn"
    let loopLabel = $"${prefix}_loop"
    let step =
        WExpr.Let(nnName, WExpr.Cast(WExpr.LocalGet(ptrName, listBaseRefT), listNNRefT),
            WExpr.Sequence [
                perStep (WExpr.StructGet(WExpr.LocalGet(nnName, listNNRefT), 0, elemT))
                WExpr.Assign(ptrName, WExpr.StructGet(WExpr.LocalGet(nnName, listNNRefT), 1, listBaseRefT))
                WExpr.Continue(loopLabel, [])
            ])
    let loopBody =
        WExpr.If(
            WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull(WExpr.LocalGet(ptrName, listBaseRefT)), WType.I32),
            step, WExpr.Nop, WType.Void)
    let loopAndResult =
        WExpr.Sequence [WExpr.Loop(loopLabel, loopBody, WType.Void); postLoop]
    let maybeBlocked =
        match exitBlock with
        | Some(lbl, rty) -> WExpr.Block(lbl, loopAndResult, rty)
        | None           -> loopAndResult
    let withPtr = WExpr.LetMut(ptrName, wList, maybeBlocked)
    (extraMuts, withPtr) ||> List.foldBack (fun (name, init) inner -> WExpr.LetMut(name, init, inner))

// ─────────────────────────────────────────────────────────────────
// mkArrayLoop — indexed array traversal skeleton
// ─────────────────────────────────────────────────────────────────

/// Build an indexed array traversal loop (parallel to mkListLoop for lists).
///
/// prefix    – unique label/name prefix
/// elemT     – WType of array elements
/// arrTypeIdx – GC array type index
/// wArr      – the array WExpr
/// extraMuts – mutable accumulators [(name, initExpr)]
/// perStep   – receives (elem WExpr, idx WExpr); returns a body
/// postLoop  – expression returned after the loop
/// exitBlock – if Some(exitLabel, resultTy), wraps in Block for early exit
let mkArrayLoop
        (prefix: string)
        (elemT: WType) (arrTypeIdx: int) (wArr: WExpr)
        (extraMuts: (string * WExpr) list)
        (perStep: WExpr -> WExpr -> WExpr)
        (postLoop: WExpr)
        (exitBlock: (string * WType) option) : WExpr =
    let arrRefT   = WType.Ref(arrTypeIdx, false)
    let arrVar    = $"${prefix}_arr"
    let lenVar    = $"${prefix}_len"
    let iVar      = $"${prefix}_i"
    let loopLabel = $"${prefix}_loop"
    let iGet   = WExpr.LocalGet(iVar, WType.I32)
    let lenGet = WExpr.LocalGet(lenVar, WType.I32)
    let arrGet = WExpr.LocalGet(arrVar, arrRefT)
    let elem   = WExpr.ArrayGet(arrGet, iGet, elemT)
    let step =
        WExpr.Sequence [
            perStep elem iGet
            WExpr.Assign(iVar, WExpr.Binary(WBinaryOp.Add, iGet, WExpr.Const(WConst.I32 1), WType.I32))
            WExpr.Continue(loopLabel, [])
        ]
    let loopBody = WExpr.If(WExpr.Compare(WCompareOp.LtS, iGet, lenGet), step, WExpr.Nop, WType.Void)
    let loopAndResult = WExpr.Sequence [WExpr.Loop(loopLabel, loopBody, WType.Void); postLoop]
    let maybeBlocked =
        match exitBlock with
        | Some(lbl, rty) -> WExpr.Block(lbl, loopAndResult, rty)
        | None           -> loopAndResult
    let withI = WExpr.LetMut(iVar, WExpr.Const(WConst.I32 0), maybeBlocked)
    let withExtras = (extraMuts, withI) ||> List.foldBack (fun (n, v) inner -> WExpr.LetMut(n, v, inner))
    let withLen = WExpr.Let(lenVar, WExpr.ArrayLen(arrGet), withExtras)
    WExpr.Let(arrVar, wArr, withLen)
