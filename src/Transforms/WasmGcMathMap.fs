/// WasmGC dispatch for Math operations and the Map<int,int> IComparer intercept.
/// dispatchMathCall — routes standard math selectors (abs, min, max, round, …)
///                    to the appropriate WasmGC instructions or software helpers.
/// tryMapInline      — intercepts Fable's IComparer-injected Map.ofList / Map.empty
///                    calls, drops the injected comparator, and routes to Map_ofList /
///                    Map_empty with the correct WasmGC return type from KnownFuncs.
module Fable.Transforms.WasmGc.WasmGcMathMap

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder
open Fable.Transforms.WasmGc.WasmGcRuntime

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

// ─────────────────────────────────────────────────────────────────
// Map module intercept
// ─────────────────────────────────────────────────────────────────
/// Intercept standard F# `Map.*` calls that come through Fable's `mapModule`
/// replacement. Two operations get an extra IComparer argument appended by
/// Fable's `injectArg`:
///   - `Map.ofList [pairs...]`  → `LibCall("Map", "ofList", [list; comparer])`
///   - `Map.empty`              → `LibCall("Map", "empty",  [comparer])`
/// We drop the comparer (it's emitted as Nop anyway) and call the compiled
/// fable-library function directly, using the actual return type from KnownFuncs
/// to avoid the `FSharpMap<int,int>` → `I32` fallback in mapTypeKnown.
///
/// All other Map operations (`add`, `find`, `tryFind`, `containsKey`) receive
/// NO injected comparer, so they route correctly via KnownFuncsByPath as long
/// as the actual return type is used (see the fixed fallback in Fable2WasmGc).
let tryMapInline
        (ctx: Ctx)
        (importStem: string)
        (selector: string)
        (wArgs: WExpr list) : WExpr option =
    if importStem <> "Map" then None
    else
    match selector, wArgs with
    // Map.ofList [pairs; _comparer] — drop injected comparer, call Map_ofList(list)
    | "ofList", [wList; _comparer] ->
        match Map.tryFind "Map_ofList" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Map_ofList", [wList], retTy))
        | None -> None
    // Map.empty [_comparer] — drop injected comparer, call Map_empty()
    | "empty", [_comparer] ->
        match Map.tryFind "Map_empty" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Map_empty", [], retTy))
        | None -> None
    | _ -> None
