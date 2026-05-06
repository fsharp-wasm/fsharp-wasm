/// WasmGC inline replacements for Option<'T> and Result<'T,'E>.
/// FableQuery DSL integrated — UnaryLambda replaces Lambda|Delegate([f]) throughout.
///
/// Design: the `wasm { }` CE (WasmGcBuilder) eliminates all explicit `tmp`
/// local-variable plumbing.  The private `optBranch` helper encodes the
/// shared "bind opt, RefIsNull test, dispatch" skeleton so each combinator
/// only expresses the semantic difference between None and Some branches.
///
/// Compared to the old code (one explicit let-binding + two LocalGet refs
/// per combinator):  -40 % lines, zero magic string variable names.
module WasmGc.Transforms.OptionResult

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Builder
open WasmGc.Runtime.Runtime
open WasmGc.Util.FableQuery   // ← DSL

// ─────────────────────────────────────────────────────────────────
// Private helpers — Option encoding
// ─────────────────────────────────────────────────────────────────

/// Extract the inner value from a known-non-null option expression.
///   Direct-ref options  (inner is non-null ref):  ref.cast → non-null.
///   Wrapper-struct options (inner is primitive):  ref.cast → struct, struct.get[0].
let private unwrapSome (opt: WExpr) (optTypeIdx: int) (innerT: WType) : WExpr =
    match innerT with
    | WType.Ref(innerIdx, false) -> WExpr.Cast(opt, WType.Ref(innerIdx, false))
    | _ -> WExpr.StructGet(WExpr.Cast(opt, WType.Ref(optTypeIdx, false)), 0, innerT)

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
        match exprWType (transform ctx optArg) with
        | WType.Ref(optIdx, _) as wOptTy ->
            Some(optBranch (transform ctx optArg) ty (transform ctx defArg)
                    (fun opt -> unwrapSome opt optIdx ty))
        | _ -> None

    // Option.map — None → None, Some x → Some (f x)
    // DSL: UnaryLambda replaces Lambda(farg,...)|Delegate([farg],...) everywhere below
    | "map", [UnaryLambda(farg, fbody); optArg] when isOptionType optArg.Type ->
        let wOpt   = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        match exprWType wOpt, ty with
        | WType.Ref(inOptIdx, _), WType.Ref(_, _) ->
            let wBody = transform (ctx.WithLocal(farg.Name, innerT)) fbody
            let none  = WExpr.Const(WConst.Null ty)
            Some(optBranch wOpt ty none (fun opt ->
                WExpr.Let(farg.Name, unwrapSome opt inOptIdx innerT, wrapSome wBody ty)))
        | _ -> None

    // Option.bind — None → None, Some x → f x  (f returns option)
    | "bind", [UnaryLambda(farg, fbody); optArg] when isOptionType optArg.Type ->
        let wOpt   = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        match exprWType wOpt with
        | WType.Ref(inOptIdx, _) ->
            let wBody = transform (ctx.WithLocal(farg.Name, innerT)) fbody
            Some(optBranch wOpt ty (WExpr.Const(WConst.Null ty))
                    (fun opt -> WExpr.Let(farg.Name, unwrapSome opt inOptIdx innerT, wBody)))
        | _ -> None

    // Option.get / Option.value — unwrap Some; None becomes a runtime null-deref (correct)
    | ("get" | "value"), [optArg] when isOptionType optArg.Type ->
        let wOpt = transform ctx optArg
        match exprWType wOpt with
        | WType.Ref(optIdx, _) ->
            Some(wasm { let! opt = wOpt in return unwrapSome opt optIdx ty })
        | _ -> None

    // Option.filter — None → None, Some x where pred x → Some x, else None
    | "filter", [UnaryLambda(farg, fbody); optArg] when isOptionType optArg.Type ->
        let wOpt   = transform ctx optArg
        let innerT = mapTypeKnown ctx farg.Type
        match exprWType wOpt with
        | WType.Ref(optIdx, _) ->
            let wPred = transform (ctx.WithLocal(farg.Name, innerT)) fbody
            let none  = WExpr.Const(WConst.Null ty)
            Some(optBranch wOpt ty none (fun opt ->
                WExpr.Let(farg.Name, unwrapSome opt optIdx innerT,
                    WExpr.If(wPred, opt, none, ty))))
        | _ -> None

    // Option.defaultWith — None → thunk (), Some x → x
    // Fable emits:  LibCall "Option" "defaultArgWith" [opt; thunk]  (reversed order)
    | "defaultArgWith", [optArg; UnaryLambda(_, fbody)] ->
        let wOpt = transform ctx optArg
        match exprWType wOpt with
        | WType.Ref(optIdx, _) ->
            Some(optBranch wOpt ty (transform ctx fbody)
                    (fun opt -> unwrapSome opt optIdx ty))
        | _ -> None

    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Result<'T,'E> combinators
// ─────────────────────────────────────────────────────────────────

let tryResultInline
        (transform: TransformFn)  // Ctx -> Expr -> WExpr
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (ty: WType) : WExpr option =

    let resultInstKey (t: Fable.Type) =
        match t with
        | Type.DeclaredType(e, gs) when gs.IsEmpty -> e.FullName
        | Type.DeclaredType(e, gs) ->
            let argKeys = gs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
            $"{e.FullName}<{argKeys}>"
        | _ -> ""

    /// Shared skeleton for Result combinators: bind result to a local, tag-test Ok.
    let resultBranch (wResult: WExpr) (okCase: WExpr -> WExpr) =
        wasm {
            let! res = wResult
            let isOk = WExpr.Compare(WCompareOp.Eq, WExpr.TagOf res, WExpr.Const(WConst.I32 0))
            return WExpr.If(isOk, okCase res, res, ty)
        }

    let withOkCase selector (resultArg: Fable.Expr) (farg: Fable.Ident) fbody =
        let instKey = resultInstKey resultArg.Type
        match ctx.GenericDuRegistry.TryGetValue(instKey) with
        | true, baseIdx ->
            match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
            | true, okCaseIdx ->
                let innerT   = mapTypeKnown ctx farg.Type
                let okRef    = WType.Ref(okCaseIdx, false)
                let wBody    = transform (ctx.WithLocal(farg.Name, innerT)) fbody
                Some(resultBranch (transform ctx resultArg) (fun res ->
                    let castedOk = WExpr.Cast(res, okRef)
                    let innerVal = WExpr.StructGet(castedOk, 1, innerT)
                    WExpr.Let(farg.Name, innerVal, wBody)))
            | _ -> None
        | _ -> None

    match selector, fableArgs with

    // Result.isOk → tag == 0
    | "Result_IsOk",    [r] -> Some(WExpr.Compare(WCompareOp.Eq, WExpr.TagOf(transform ctx r), WExpr.Const(WConst.I32 0)))

    // Result.isError → tag != 0
    | "Result_IsError", [r] -> Some(WExpr.Compare(WCompareOp.Ne, WExpr.TagOf(transform ctx r), WExpr.Const(WConst.I32 0)))

    // Result.map f r — if Ok x → Ok (f x) else Error (pass through)
    // DSL: UnaryLambda handles both Lambda and Delegate([f]) cases
    // TODO: use UnaryLambda ! 
    | "Result_Map",  [UnaryLambda(farg, fbody); resultArg] ->
        withOkCase selector resultArg farg fbody
        // TODO: like withOkCase?!
    //    let instKey = resultInstKey resultArg.Type
    //    match ctx.GenericDuRegistry.TryGetValue(instKey) with
    //    | true, _ ->
    //        match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
    //        | true, okCaseIdx ->
    //            let innerT   = mapTypeKnown ctx farg.Type
    //            let okRef    = WType.Ref(okCaseIdx, false)
    //            let wBody    = transform (ctx.WithLocal(farg.Name, innerT)) fbody
    //            Some(resultBranch (transform ctx resultArg) (fun res ->
    //                let castedOk = WExpr.Cast(res, okRef)
    //                let innerVal = WExpr.StructGet(castedOk, 1, innerT)
    //                WExpr.Let(farg.Name, innerVal,
    //                    WExpr.StructNew(okCaseIdx, [WExpr.Const(WConst.I32 0); wBody], ty))))
    //        | _ -> None
    //    | _ -> None

    // Result.bind f r — if Ok x → f x else Error (pass through)
    | "Result_Bind", [UnaryLambda(farg, fbody); resultArg] ->
        withOkCase selector resultArg farg fbody

    | _ -> None
