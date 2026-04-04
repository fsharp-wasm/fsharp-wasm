/// WasmGC inline BCL replacements.
/// Handles Option, List, Array, Math, String, BigInt inline patterns.
/// Each replacement function takes `transform: TransformFn` to call back into
/// the translator for lambda bodies, breaking the circular dependency.
module Fable.Transforms.WasmGc.WasmGcReplacements

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
// Option representation helpers
// ─────────────────────────────────────────────────────────────────

/// Extract the inner value from a known-non-null option local.
/// Direct-ref options (non-null inner ref):  cast nullable → non-null inner ref.
/// Wrapper-struct options (primitive inner): cast → non-null struct, then StructGet field 0.
let private unwrapSomeLocal (optLocalExpr: WExpr) (optTypeIdx: int) (innerT: WType) : WExpr =
    match innerT with
    | WType.Ref(innerIdx, false) ->
        // Direct-ref encoding: optTypeIdx == innerIdx; cast removes the nullable bit.
        WExpr.Cast(optLocalExpr, WType.Ref(innerIdx, false))
    | _ ->
        // Wrapper struct: cast to non-null struct, get field 0.
        WExpr.StructGet(WExpr.Cast(optLocalExpr, WType.Ref(optTypeIdx, false)), 0, innerT)

/// Wrap an inner value as a Some option.
/// Direct-ref options (inner is non-null ref): the value itself represents Some — return as-is.
/// Wrapper-struct options:                     wrap in StructNew.
let private wrapSome (innerExpr: WExpr) (resultOptTy: WType) : WExpr =
    match exprWType innerExpr with
    | WType.Ref(_, false) -> innerExpr          // direct-ref: value IS the Some
    | _ ->
        match resultOptTy with
        | WType.Ref(wrapperIdx, _) -> WExpr.StructNew(wrapperIdx, [innerExpr], resultOptTy)
        | _ -> innerExpr                        // fallback (shouldn't occur in well-typed code)

// ─────────────────────────────────────────────────────────────────
// Option combinators
// ─────────────────────────────────────────────────────────────────

let tryOptionInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (ty: WType) : WExpr option =
    match selector, fableArgs with
    // Option.defaultArg/defaultValue: (option, default) → if None then default else option.Value
    | ("defaultArg" | "defaultValue"), [optArg; defArg] ->
        let wOpt = transform ctx optArg
        let wDef = transform ctx defArg
        let tmp = "$optdefault_tmp"
        match exprWType wOpt with
        | WType.Ref(inOptTypeIdx, _) ->
            let optRef = WType.Ref(inOptTypeIdx, true)
            let innerVal = unwrapSomeLocal (WExpr.LocalGet(tmp, optRef)) inOptTypeIdx ty
            Some(WExpr.Let(tmp, wOpt,
                WExpr.If(WExpr.RefIsNull(WExpr.LocalGet(tmp, optRef)), wDef, innerVal, ty)))
        | _ -> None
    // Option.map: (f: 'a -> 'b, opt: 'a option) → 'b option
    | "map", [Fable.Expr.Lambda(farg, fbody, _); optArg]
        when (match optArg.Type with | Fable.Type.Option _ -> true | _ -> false) ->
        let wOpt = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        let tmp = "$optmap_tmp"
        match exprWType wOpt, ty with
        | WType.Ref(inOptTypeIdx, _), WType.Ref(_, _) ->
            let optRef = WType.Ref(inOptTypeIdx, true)
            let ctx' = ctx.WithLocal(farg.Name, innerT)
            let wBody = transform ctx' fbody
            let innerVal = unwrapSomeLocal (WExpr.LocalGet(tmp, optRef)) inOptTypeIdx innerT
            let mappedResult = WExpr.Let(farg.Name, innerVal, wrapSome wBody ty)
            let noneResult = WExpr.Const(WConst.Null(ty))
            Some(WExpr.Let(tmp, wOpt,
                WExpr.If(WExpr.RefIsNull(WExpr.LocalGet(tmp, optRef)), noneResult, mappedResult, ty)))
        | _ -> None
    // Option.bind: (f: 'a -> 'b option, opt: 'a option) → 'b option
    | "bind", [Fable.Expr.Lambda(farg, fbody, _); optArg]
        when (match optArg.Type with | Fable.Type.Option _ -> true | _ -> false) ->
        let wOpt = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        let tmp = "$optbind_tmp"
        match exprWType wOpt with
        | WType.Ref(inOptTypeIdx, _) ->
            let optRef = WType.Ref(inOptTypeIdx, true)
            let ctx' = ctx.WithLocal(farg.Name, innerT)
            let wBody = transform ctx' fbody
            let innerVal = unwrapSomeLocal (WExpr.LocalGet(tmp, optRef)) inOptTypeIdx innerT
            let bindResult = WExpr.Let(farg.Name, innerVal, wBody)
            let noneResult = WExpr.Const(WConst.Null(ty))
            Some(WExpr.Let(tmp, wOpt,
                WExpr.If(WExpr.RefIsNull(WExpr.LocalGet(tmp, optRef)), noneResult, bindResult, ty)))
        | _ -> None
    // Option.get / Option.value: unwrap Some, throw (crash) on None.
    // We just cast + extract; if None, it's a runtime null-deref (correct behaviour).
    | ("get" | "value"), [optArg]
        when (match optArg.Type with | Fable.Type.Option _ -> true | _ -> false) ->
        let wOpt = transform ctx optArg
        let tmp = "$optget_tmp"
        match exprWType wOpt with
        | WType.Ref(optTypeIdx, _) ->
            let optRef = WType.Ref(optTypeIdx, true)
            let innerVal = unwrapSomeLocal (WExpr.LocalGet(tmp, optRef)) optTypeIdx ty
            Some(WExpr.Let(tmp, wOpt, innerVal))
        | _ -> None
    // Option.filter: pred → Some if pred holds, None otherwise
    // Fable emits: LibCall "Option" "filter" with args [pred; opt]
    | "filter", [Fable.Expr.Lambda(farg, fbody, _); optArg]
        when (match optArg.Type with | Fable.Type.Option _ -> true | _ -> false) ->
        let wOpt = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        let tmp = "$optfilt_tmp"
        match exprWType wOpt with
        | WType.Ref(optTypeIdx, _) ->
            let optRef = WType.Ref(optTypeIdx, true)
            let ctx' = ctx.WithLocal(farg.Name, innerT)
            let wPred = transform ctx' fbody
            let innerVal = unwrapSomeLocal (WExpr.LocalGet(tmp, optRef)) optTypeIdx innerT
            let passThrough = WExpr.LocalGet(tmp, optRef)
            let failResult  = WExpr.Const(WConst.Null(optRef))
            let checkResult = WExpr.Let(farg.Name, innerVal,
                                WExpr.If(wPred, passThrough, failResult, ty))
            Some(WExpr.Let(tmp, wOpt,
                WExpr.If(WExpr.RefIsNull(WExpr.LocalGet(tmp, optRef)), failResult, checkResult, ty)))
        | _ -> None
    // Option.defaultWith: thunk → 'a; evaluate thunk on None
    // Fable emits: LibCall "Option" "defaultArgWith" with args [opt; thunk] (reversed)
    | "defaultArgWith", [optArg; Fable.Expr.Lambda(_, fbody, _)] ->
        let wOpt = transform ctx optArg
        let wThunkBody = transform ctx fbody
        let tmp = "$optdw_tmp"
        match exprWType wOpt with
        | WType.Ref(optTypeIdx, _) ->
            let optRef = WType.Ref(optTypeIdx, true)
            let innerVal = unwrapSomeLocal (WExpr.LocalGet(tmp, optRef)) optTypeIdx ty
            Some(WExpr.Let(tmp, wOpt,
                WExpr.If(WExpr.RefIsNull(WExpr.LocalGet(tmp, optRef)), wThunkBody, innerVal, ty)))
        | _ -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Result<T,E> combinators
// ─────────────────────────────────────────────────────────────────

let tryResultInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (ty: WType) : WExpr option =
    /// Look up the instance key for a Result<T,E> DeclaredType.
    let getResultInstKey (resultType: Fable.Type) =
        match resultType with
        | Fable.Type.DeclaredType(entRef, genArgs) ->
            if genArgs.IsEmpty then entRef.FullName
            else
                let argKeys = genArgs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
                $"{entRef.FullName}<{argKeys}>"
        | _ -> ""

    match selector, fableArgs with
    // Result.isOk (r) → tag == 0
    | "Result_IsOk", [resultArg] ->
        let wResult = transform ctx resultArg
        Some(WExpr.Compare(WCompareOp.Eq, WExpr.TagOf(wResult), WExpr.Const(WConst.I32 0)))

    // Result.isError (r) → tag != 0
    | "Result_IsError", [resultArg] ->
        let wResult = transform ctx resultArg
        Some(WExpr.Compare(WCompareOp.Ne, WExpr.TagOf(wResult), WExpr.Const(WConst.I32 0)))

    // Result.map f r → if Ok x → Ok (f x) else Error e (pass through)
    | "Result_Map", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); resultArg] ->
        let wResult = transform ctx resultArg
        let instKey = getResultInstKey resultArg.Type
        match ctx.GenericDuRegistry.TryGetValue(instKey) with
        | true, baseIdx ->
            match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
            | true, okCaseIdx ->
                let innerT = mapTypeKnown ctx farg.Type
                let tmp = "$resmap_tmp"
                let resRef = WType.Ref(baseIdx, false)
                let okRef = WType.Ref(okCaseIdx, false)
                let ctx' = ctx.WithLocal(farg.Name, innerT)
                let wBody = transform ctx' fbody
                let castedOk = WExpr.Cast(WExpr.LocalGet(tmp, resRef), okRef)
                let innerVal = WExpr.StructGet(castedOk, 1, innerT)
                let mappedOk = WExpr.Let(farg.Name, innerVal,
                                WExpr.StructNew(okCaseIdx, [WExpr.Const(WConst.I32 0); wBody], ty))
                let passError = WExpr.LocalGet(tmp, resRef)
                let isOk = WExpr.Compare(WCompareOp.Eq,
                                WExpr.TagOf(WExpr.LocalGet(tmp, resRef)),
                                WExpr.Const(WConst.I32 0))
                Some(WExpr.Let(tmp, wResult, WExpr.If(isOk, mappedOk, passError, ty)))
            | _ -> None
        | _ -> None

    // Result.bind f r → if Ok x → f x else Error e (pass through)
    | "Result_Bind", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); resultArg] ->
        let wResult = transform ctx resultArg
        let instKey = getResultInstKey resultArg.Type
        match ctx.GenericDuRegistry.TryGetValue(instKey) with
        | true, baseIdx ->
            match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
            | true, okCaseIdx ->
                let innerT = mapTypeKnown ctx farg.Type
                let tmp = "$resbind_tmp"
                let resRef = WType.Ref(baseIdx, false)
                let okRef = WType.Ref(okCaseIdx, false)
                let ctx' = ctx.WithLocal(farg.Name, innerT)
                let wBody = transform ctx' fbody
                let castedOk = WExpr.Cast(WExpr.LocalGet(tmp, resRef), okRef)
                let innerVal = WExpr.StructGet(castedOk, 1, innerT)
                let bindResult = WExpr.Let(farg.Name, innerVal, wBody)
                let passError = WExpr.LocalGet(tmp, resRef)
                let isOk = WExpr.Compare(WCompareOp.Eq,
                                WExpr.TagOf(WExpr.LocalGet(tmp, resRef)),
                                WExpr.Const(WConst.I32 0))
                Some(WExpr.Let(tmp, wResult, WExpr.If(isOk, bindResult, passError, ty)))
            | _ -> None
        | _ -> None

    | _ -> None

// ─────────────────────────────────────────────────────────────────
// List higher-order combinators
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
        match listArg.Type with
        | Fable.Type.List(elemFableType) ->
            let resultElemFableType = match resultFableType with | Fable.Type.List(t) -> t | _ -> elemFableType
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
        | _ -> None
    | "mapIndexed", [(Fable.Expr.Lambda(iarg, Fable.Expr.Lambda(farg, fbody, _), _)
                   | Fable.Expr.Delegate([iarg; farg], fbody, _, _)); listArg] ->
        match listArg.Type with
        | Fable.Type.List(elemFableType) ->
            let resultElemFableType = match resultFableType with | Fable.Type.List(t) -> t | _ -> elemFableType
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
        | _ -> None
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
        match listArg.Type with
        | Fable.Type.List(inputElemFableType) ->
            let outputElemFableType = match resultFableType with | Fable.Type.List(t) -> t | _ -> inputElemFableType
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
        | _ -> None
    // List.partition pred xs → (trueList, falseList) as a tuple struct.
    // Strategy: single pass collecting two reversed accumulators, then reverse each.
    | "partition", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match listArg.Type with
        | Fable.Type.List(elemFableT) ->
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
        | _ -> None
    | _ -> None

let tryListChooseInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    match selector, fableArgs with
    | "choose", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); listArg] ->
        match listArg.Type with
        | Fable.Type.List(inputElemFableType) ->
            let outputElemFableType = match resultFableType with | Fable.Type.List(t) -> t | _ -> Fable.Type.Any
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
        | _ -> None
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
    // Guard: only when result is a List type (Array.init is handled by tryArrayInline)
    | ("init" | "initialize"), _ when (match resultFableType with | Fable.Type.List _ -> true | _ -> false) ->
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
            match resultFableType with
            | Fable.Type.List(t) -> t
            | _ -> fbody.Type
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
// List.take / List.skip / List.sort
// ─────────────────────────────────────────────────────────────────

/// `List.skip n xs` → drop first n elements; returns tail from position n.
/// `List.take n xs` → first n elements as a new list.
/// `List.sort xs` / `List.sortDescending xs` → sorted list via list→array→sort→list.
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

// ─────────────────────────────────────────────────────────────────
// Math dispatch
// ─────────────────────────────────────────────────────────────────

let dispatchMathCall (name: string) (wArgs: WExpr list) (ty: WType) : WExpr =
    match name, wArgs, ty with
    // abs
    | "abs", [arg], WType.F64 -> WExpr.Unary(WUnaryOp.Abs, arg, WType.F64)
    | "abs", [arg], WType.F32 -> WExpr.Unary(WUnaryOp.Abs, arg, WType.F32)
    | "abs", [arg], WType.I32 ->
        let tmp = "$abs_tmp"
        WExpr.Let(tmp, arg,
            WExpr.If(WExpr.Compare(WCompareOp.LtS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 0)),
                WExpr.Binary(WBinaryOp.Sub, WExpr.Const(WConst.I32 0), WExpr.LocalGet(tmp, WType.I32), WType.I32),
                WExpr.LocalGet(tmp, WType.I32), WType.I32))
    | "abs", [arg], WType.I64 ->
        let tmp = "$abs_tmp"
        WExpr.Let(tmp, arg,
            WExpr.If(WExpr.Compare(WCompareOp.LtS, WExpr.LocalGet(tmp, WType.I64), WExpr.Const(WConst.I64 0L)),
                WExpr.Binary(WBinaryOp.Sub, WExpr.Const(WConst.I64 0L), WExpr.LocalGet(tmp, WType.I64), WType.I64),
                WExpr.LocalGet(tmp, WType.I64), WType.I64))
    // sqrt
    | "sqrt", [arg], WType.F64 -> WExpr.Unary(WUnaryOp.Sqrt, arg, WType.F64)
    | "sqrt", [arg], WType.F32 -> WExpr.Unary(WUnaryOp.Sqrt, arg, WType.F32)
    // floor
    | "floor", [arg], WType.F64 -> WExpr.Unary(WUnaryOp.Floor, arg, WType.F64)
    | "floor", [arg], WType.F32 -> WExpr.Unary(WUnaryOp.Floor, arg, WType.F32)
    // ceil
    | ("ceil" | "ceiling"), [arg], WType.F64 -> WExpr.Unary(WUnaryOp.Ceil, arg, WType.F64)
    | ("ceil" | "ceiling"), [arg], WType.F32 -> WExpr.Unary(WUnaryOp.Ceil, arg, WType.F32)
    // trunc
    | ("trunc" | "truncate"), [arg], WType.F64 -> WExpr.Unary(WUnaryOp.Trunc, arg, WType.F64)
    | ("trunc" | "truncate"), [arg], WType.F32 -> WExpr.Unary(WUnaryOp.Trunc, arg, WType.F32)
    // round / nearest
    | ("round" | "nearest"), [arg], WType.F64 -> WExpr.Unary(WUnaryOp.Nearest, arg, WType.F64)
    | ("round" | "nearest"), [arg], WType.F32 -> WExpr.Unary(WUnaryOp.Nearest, arg, WType.F32)
    | ("round" | "nearest"), [arg; _], WType.F64 -> WExpr.Unary(WUnaryOp.Nearest, arg, WType.F64)
    | ("round" | "nearest"), [arg; _], WType.F32 -> WExpr.Unary(WUnaryOp.Nearest, arg, WType.F32)
    // min
    | "min", [a; b], WType.F64 -> WExpr.Binary(WBinaryOp.Min, a, b, WType.F64)
    | "min", [a; b], WType.F32 -> WExpr.Binary(WBinaryOp.Min, a, b, WType.F32)
    | "min", [a; b], WType.I32 ->
        let ta = "$min_a"
        let tb = "$min_b"
        WExpr.Let(ta, a, WExpr.Let(tb, b,
            WExpr.If(WExpr.Compare(WCompareOp.LtS, WExpr.LocalGet(ta, WType.I32), WExpr.LocalGet(tb, WType.I32)),
                WExpr.LocalGet(ta, WType.I32), WExpr.LocalGet(tb, WType.I32), WType.I32)))
    | "min", [a; b], WType.I64 ->
        let ta = "$min_a"
        let tb = "$min_b"
        WExpr.Let(ta, a, WExpr.Let(tb, b,
            WExpr.If(WExpr.Compare(WCompareOp.LtS, WExpr.LocalGet(ta, WType.I64), WExpr.LocalGet(tb, WType.I64)),
                WExpr.LocalGet(ta, WType.I64), WExpr.LocalGet(tb, WType.I64), WType.I64)))
    // max
    | "max", [a; b], WType.F64 -> WExpr.Binary(WBinaryOp.Max, a, b, WType.F64)
    | "max", [a; b], WType.F32 -> WExpr.Binary(WBinaryOp.Max, a, b, WType.F32)
    | "max", [a; b], WType.I32 ->
        let ta = "$max_a"
        let tb = "$max_b"
        WExpr.Let(ta, a, WExpr.Let(tb, b,
            WExpr.If(WExpr.Compare(WCompareOp.GtS, WExpr.LocalGet(ta, WType.I32), WExpr.LocalGet(tb, WType.I32)),
                WExpr.LocalGet(ta, WType.I32), WExpr.LocalGet(tb, WType.I32), WType.I32)))
    | "max", [a; b], WType.I64 ->
        let ta = "$max_a"
        let tb = "$max_b"
        WExpr.Let(ta, a, WExpr.Let(tb, b,
            WExpr.If(WExpr.Compare(WCompareOp.GtS, WExpr.LocalGet(ta, WType.I64), WExpr.LocalGet(tb, WType.I64)),
                WExpr.LocalGet(ta, WType.I64), WExpr.LocalGet(tb, WType.I64), WType.I64)))
    // sign
    | "sign", [arg], _ ->
        let tmp = "$sign_tmp"
        WExpr.Let(tmp, arg,
            WExpr.If(WExpr.Compare(WCompareOp.GtS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 0)),
                WExpr.Const(WConst.I32 1),
                WExpr.If(WExpr.Compare(WCompareOp.LtS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 0)),
                    WExpr.Const(WConst.I32 (-1)),
                    WExpr.Const(WConst.I32 0), WType.I32),
                WType.I32))
    | _ ->
        eprintfn "[WasmGc] WARNING: unhandled Math call '%s' — emitting I32 0" name
        WExpr.Const(WConst.I32 0)
