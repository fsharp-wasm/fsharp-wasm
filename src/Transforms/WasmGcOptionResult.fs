/// WasmGC inline replacements for Option<'T> and Result<'T,'E>.
///
/// Design: the `wasm { }` CE (WasmGcBuilder) eliminates all explicit `tmp`
/// local-variable plumbing.  The private `optBranch` helper encodes the
/// shared "bind opt, RefIsNull test, dispatch" skeleton so each combinator
/// only expresses the semantic difference between None and Some branches.
///
/// Compared to the old code (one explicit let-binding + two LocalGet refs
/// per combinator):  -40 % lines, zero magic string variable names.
module Fable.Transforms.WasmGc.WasmGcOptionResult

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder
open Fable.Transforms.WasmGc.WasmGcRuntime

// ─────────────────────────────────────────────────────────────────
// Private helpers — Option encoding
// ─────────────────────────────────────────────────────────────────

/// True when a Fable type is an Option.
let private isOption (ftype: Fable.Type) =
    match ftype with | Fable.Type.Option _ -> true | _ -> false

/// Extract the inner value from a known-non-null option expression.
///   Direct-ref options  (inner is non-null ref):  ref.cast → non-null.
///   Wrapper-struct options (inner is primitive):  ref.cast → struct, struct.get[0].
let private unwrapSome (opt: WExpr) (optTypeIdx: int) (innerT: WType) : WExpr =
    match innerT with
    | WType.Ref(innerIdx, false) ->
        WExpr.Cast(opt, WType.Ref(innerIdx, false))
    | _ ->
        WExpr.StructGet(WExpr.Cast(opt, WType.Ref(optTypeIdx, false)), 0, innerT)

/// Wrap an inner value as a `Some`.
///   Direct-ref options:     the value itself IS the Some representation.
///   Wrapper-struct options: StructNew wrapping the value.
let private wrapSome (inner: WExpr) (resultOptTy: WType) : WExpr =
    match exprWType inner with
    | WType.Ref(_, false) -> inner
    | _ ->
        match resultOptTy with
        | WType.Ref(wrapperIdx, _) -> WExpr.StructNew(wrapperIdx, [inner], resultOptTy)
        | _ -> inner

/// Shared skeleton for all Option combinators.
/// Binds `wOpt` to a CE local → tests RefIsNull → dispatches None / Some branches.
/// `onSome` receives the bound local (already a valid WExpr to pass to unwrapSome).
let private optBranch (wOpt: WExpr) (ty: WType) (onNone: WExpr) (onSome: WExpr -> WExpr) : WExpr =
    wasm {
        let! opt = wOpt
        return WExpr.If(WExpr.RefIsNull opt, onNone, onSome opt, ty)
    }

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

    // Option.defaultArg / Option.defaultValue — None → default, Some x → x
    | ("defaultArg" | "defaultValue"), [optArg; defArg] ->
        let wOpt = transform ctx optArg
        let wDef = transform ctx defArg
        match exprWType wOpt with
        | WType.Ref(inOptTypeIdx, _) ->
            Some(optBranch wOpt ty wDef (fun opt -> unwrapSome opt inOptTypeIdx ty))
        | _ -> None

    // Option.map — None → None, Some x → Some (f x)
    | "map", [Fable.Expr.Lambda(farg, fbody, _); optArg] when isOption optArg.Type ->
        let wOpt   = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        match exprWType wOpt, ty with
        | WType.Ref(inOptTypeIdx, _), WType.Ref(_, _) ->
            let wBody = transform (ctx.WithLocal(farg.Name, innerT)) fbody
            let none  = WExpr.Const(WConst.Null ty)
            Some(optBranch wOpt ty none (fun opt ->
                WExpr.Let(farg.Name, unwrapSome opt inOptTypeIdx innerT,
                    wrapSome wBody ty)))
        | _ -> None

    // Option.bind — None → None, Some x → f x  (f returns option)
    | "bind", [Fable.Expr.Lambda(farg, fbody, _); optArg] when isOption optArg.Type ->
        let wOpt   = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        match exprWType wOpt with
        | WType.Ref(inOptTypeIdx, _) ->
            let wBody = transform (ctx.WithLocal(farg.Name, innerT)) fbody
            let none  = WExpr.Const(WConst.Null ty)
            Some(optBranch wOpt ty none (fun opt ->
                WExpr.Let(farg.Name, unwrapSome opt inOptTypeIdx innerT, wBody)))
        | _ -> None

    // Option.get / Option.value — unwrap Some; None becomes a runtime null-deref (correct)
    | ("get" | "value"), [optArg] when isOption optArg.Type ->
        let wOpt = transform ctx optArg
        match exprWType wOpt with
        | WType.Ref(optTypeIdx, _) ->
            Some(wasm { let! opt = wOpt
                        return unwrapSome opt optTypeIdx ty })
        | _ -> None

    // Option.filter — None → None, Some x where pred x → Some x, else None
    | "filter", [Fable.Expr.Lambda(farg, fbody, _); optArg] when isOption optArg.Type ->
        let wOpt   = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        match exprWType wOpt with
        | WType.Ref(optTypeIdx, _) ->
            let wPred = transform (ctx.WithLocal(farg.Name, innerT)) fbody
            let none  = WExpr.Const(WConst.Null ty)
            Some(optBranch wOpt ty none (fun opt ->
                WExpr.Let(farg.Name, unwrapSome opt optTypeIdx innerT,
                    WExpr.If(wPred, opt, none, ty))))
        | _ -> None

    // Option.defaultWith — None → thunk (), Some x → x
    // Fable emits:  LibCall "Option" "defaultArgWith" [opt; thunk]  (reversed order)
    | "defaultArgWith", [optArg; Fable.Expr.Lambda(_, fbody, _)] ->
        let wOpt   = transform ctx optArg
        let wThunk = transform ctx fbody
        match exprWType wOpt with
        | WType.Ref(optTypeIdx, _) ->
            Some(optBranch wOpt ty wThunk (fun opt -> unwrapSome opt optTypeIdx ty))
        | _ -> None

    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Result<'T,'E> combinators
// ─────────────────────────────────────────────────────────────────

let tryResultInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (ty: WType) : WExpr option =

    let getResultInstKey (resultType: Fable.Type) =
        match resultType with
        | Fable.Type.DeclaredType(entRef, genArgs) ->
            if genArgs.IsEmpty then entRef.FullName
            else
                let argKeys = genArgs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
                $"{entRef.FullName}<{argKeys}>"
        | _ -> ""

    /// Shared skeleton for Result combinators: bind result to a local, tag-test Ok.
    let resultBranch (wResult: WExpr) (resRef: WType) (okCase: WExpr -> WExpr) : WExpr =
        wasm {
            let! res = wResult
            let isOk = WExpr.Compare(WCompareOp.Eq, WExpr.TagOf res, WExpr.Const(WConst.I32 0))
            return WExpr.If(isOk, okCase res, res, ty)
        }

    match selector, fableArgs with

    // Result.isOk → tag == 0
    | "Result_IsOk", [resultArg] ->
        let wResult = transform ctx resultArg
        Some(WExpr.Compare(WCompareOp.Eq, WExpr.TagOf wResult, WExpr.Const(WConst.I32 0)))

    // Result.isError → tag != 0
    | "Result_IsError", [resultArg] ->
        let wResult = transform ctx resultArg
        Some(WExpr.Compare(WCompareOp.Ne, WExpr.TagOf wResult, WExpr.Const(WConst.I32 0)))

    // Result.map f r — if Ok x → Ok (f x) else Error (pass through)
    | "Result_Map", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); resultArg] ->
        let wResult = transform ctx resultArg
        let instKey = getResultInstKey resultArg.Type
        match ctx.GenericDuRegistry.TryGetValue(instKey) with
        | true, baseIdx ->
            match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
            | true, okCaseIdx ->
                let innerT  = mapTypeKnown ctx farg.Type
                let resRef  = WType.Ref(baseIdx, false)
                let okRef   = WType.Ref(okCaseIdx, false)
                let wBody   = transform (ctx.WithLocal(farg.Name, innerT)) fbody
                Some(resultBranch wResult resRef (fun res ->
                    let castedOk = WExpr.Cast(res, okRef)
                    let innerVal = WExpr.StructGet(castedOk, 1, innerT)
                    WExpr.Let(farg.Name, innerVal,
                        WExpr.StructNew(okCaseIdx, [WExpr.Const(WConst.I32 0); wBody], ty))))
            | _ -> None
        | _ -> None

    // Result.bind f r — if Ok x → f x else Error (pass through)
    | "Result_Bind", [(Fable.Expr.Lambda(farg, fbody, _) | Fable.Expr.Delegate([farg], fbody, _, _)); resultArg] ->
        let wResult = transform ctx resultArg
        let instKey = getResultInstKey resultArg.Type
        match ctx.GenericDuRegistry.TryGetValue(instKey) with
        | true, baseIdx ->
            match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
            | true, okCaseIdx ->
                let innerT  = mapTypeKnown ctx farg.Type
                let resRef  = WType.Ref(baseIdx, false)
                let okRef   = WType.Ref(okCaseIdx, false)
                let wBody   = transform (ctx.WithLocal(farg.Name, innerT)) fbody
                Some(resultBranch wResult resRef (fun res ->
                    let castedOk = WExpr.Cast(res, okRef)
                    let innerVal = WExpr.StructGet(castedOk, 1, innerT)
                    WExpr.Let(farg.Name, innerVal, wBody)))
            | _ -> None
        | _ -> None

    | _ -> None
