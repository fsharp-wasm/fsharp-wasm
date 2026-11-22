/// WasmGC inline replacements for Option<'T> and Result<'T,'E>.
/// FableQuery DSL integrated — UnaryLambda replaces Lambda|Delegate([f]) throughout.
module WasmGc.Transforms.OptionResultTransforms

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Builder.Core
open WasmGc.Runtime.Runtime
open WasmGc.Util.FableQuery

// ─────────────────────────────────────────────────────────────────
// Option encoding helpers
// ─────────────────────────────────────────────────────────────────

/// Extract the inner value from a known-non-null option expression.
///   Direct-ref options  (inner is non-null ref):  ref.cast → non-null.
///   Wrapper-struct options (inner is primitive):  ref.cast → struct, struct.get[0].
let unwrapSome (opt: WExpr) (optTypeIdx: int) (innerT: WType) : WExpr =
    match innerT with
    | WType.Ref(innerIdx, false) -> cast opt (WType.Ref(innerIdx, false))
    | _ -> structGet (cast opt (WType.Ref(optTypeIdx, false))) 0 innerT

/// Wrap an inner value as a `Some`.
///   Direct-ref options:     the value itself IS the Some representation.
///   Wrapper-struct options: StructNew wrapping the value.
let private wrapSome (inner: WExpr) (resultOptTy: WType) : WExpr =
    match exprWType inner with
    | WType.Ref(_, false) -> inner
    | _ ->
        match resultOptTy with
        | WType.Ref(wrapperIdx, _) -> structNew wrapperIdx [inner] resultOptTy
        | _ -> inner

/// Shared skeleton for all Option combinators.
/// Binds `wOpt` to a CE local → tests RefIsNull → dispatches None / Some branches.
/// `onSome` receives the bound local (already a valid WExpr to pass to unwrapSome).
/// `ref.is_null` is TRUE for None, so the None branch is the `then` branch.
let private optBranch (wOpt: WExpr) (ty: WType) (onNone: WExpr) (onSome: WExpr -> WExpr) : WExpr =
    wasm {
        let! opt = wOpt
        return makeIf (refIsNull opt) onNone (onSome opt) ty
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
            let none  = nullConst ty
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
            Some(optBranch wOpt ty (nullConst ty)
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
            let none  = nullConst ty
            Some(optBranch wOpt ty none (fun opt ->
                WExpr.Let(farg.Name, unwrapSome opt optIdx innerT,
                    makeIf wPred opt none ty)))
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
        | Type.DeclaredType(e, []) -> e.FullName
        | Type.DeclaredType(e, gs) ->
            let argKeys = gs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
            $"{e.FullName}<{argKeys}>"
        | _ -> ""

    /// Shared skeleton: bind result → test Ok tag (tag == 0) → Ok branch, Error branch.
    let resultBranch (wResult: WExpr) (okCase: WExpr -> WExpr) (errCase: WExpr -> WExpr) =
        wasm {
            let! res = wResult
            let isOk = eq (WExpr.TagOf res) i32Zero
            return makeIf isOk (okCase res) (errCase res) ty
        }

    /// The Error branch of map and bind: `Error e → Error e`.  Every instantiation of the union is its own set of structs: when the result keeps its type
    /// (`Result<int,string>` → `Result<int,string>`) the Error value is returned as it is; when the Ok type changes (`Result<A,E>` → `Result<B,E>`) the value is
    /// not one of the output's type, so an Error of the output instantiation is built holding the same payload (the case structs follow the base: Ok at +1, Error at +2,
    /// see registerGenericUnion).  None when that cannot be done here (the error type is unit: the struct has no payload field), and the call is not inlined.
    let errorBranch (resultArg: Fable.Expr) : (WExpr -> WExpr) option =
        match resultArg.Type, ty with
        | Type.DeclaredType(_, [ _; errArg ]), WType.Ref(outBase, _) ->
            match ctx.GenericDuRegistry.TryGetValue(resultInstKey resultArg.Type) with
            | true, inBase when inBase = outBase -> Some id
            | true, inBase ->
                let errT = mapTypeKnown ctx errArg
                if errT = WType.Void then None
                else Some(fun res -> WExpr.StructNew(outBase + 2, [ i32One; structGet (cast res (WType.Ref(inBase + 2, false))) 1 errT ], ty))
            | _ -> None
        | _ -> None

    /// Result.bind — extract Ok payload, run body, return wBody directly.  wBody itself produces the output Result.
    let withBindCase (resultArg: Fable.Expr) (farg: Fable.Ident) fbody =
        let instKey = resultInstKey resultArg.Type
        match ctx.GenericDuRegistry.TryGetValue(instKey), errorBranch resultArg with
        | (true, _), Some errCase ->
            match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
            | true, okCaseIdx ->
                let innerT = mapTypeKnown ctx farg.Type
                let okRef  = WType.Ref(okCaseIdx, false)
                let wBody  = transform (ctx.WithLocal(farg.Name, innerT)) fbody
                Some(resultBranch (transform ctx resultArg) (fun res ->
                    let innerVal = structGet (cast res okRef) 1 innerT
                    WExpr.Let(farg.Name, innerVal, wBody)) errCase)
            | _ -> None
        | _ -> None

    /// Result.map — extract Ok payload, apply f, RE-WRAP in Ok(0, f(x)) of the OUTPUT instantiation: its Ok struct is at the output's base + 1, which is not the input's
    /// when f changes the type of the value (`Result<Todo list,E>` → `Result<Shadow,E>`: the input's struct has a list field, and a Shadow is not one).
    let withMapCase (resultArg: Fable.Expr) (farg: Fable.Ident) fbody =
        let instKey = resultInstKey resultArg.Type
        match ctx.GenericDuRegistry.TryGetValue(instKey), errorBranch resultArg, ty with
        | (true, _), Some errCase, WType.Ref(outBase, _) ->
            match ctx.GenericDuRegistry.TryGetValue($"{instKey}#0") with
            | true, okCaseIdx ->
                let innerT = mapTypeKnown ctx farg.Type
                let okRef  = WType.Ref(okCaseIdx, false)
                let wBody  = transform (ctx.WithLocal(farg.Name, innerT)) fbody
                Some(resultBranch (transform ctx resultArg) (fun res ->
                    let innerVal = structGet (cast res okRef) 1 innerT
                    WExpr.Let(farg.Name, innerVal,
                        WExpr.StructNew(outBase + 1, [i32Zero; wBody], ty))) errCase)
            | _ -> None
        | _ -> None

    match selector, fableArgs with

    // Result.isOk → tag == 0
    | "Result_IsOk",    [r] -> Some(eq (WExpr.TagOf(transform ctx r)) i32Zero)

    // Result.isError → tag != 0
    | "Result_IsError", [r] -> Some(ne (WExpr.TagOf(transform ctx r)) i32Zero)

    // Result.map f r — Ok x → Ok (f x), Error e → Error e
    | "Result_Map",  [UnaryLambda(farg, fbody); resultArg] ->
        withMapCase resultArg farg fbody

    // Result.bind f r — Ok x → f x (f returns Result), Error e → Error e
    | "Result_Bind", [UnaryLambda(farg, fbody); resultArg] ->
        withBindCase resultArg farg fbody

    | _ -> None
