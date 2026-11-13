/// WasmGC dispatch for Math operations and the Map<int,int> IComparer intercept.
/// dispatchMathCall — routes standard math selectors (abs, min, max, round, …)
///                    to the appropriate WasmGC instructions or software helpers.
/// tryMapInline      — intercepts Fable's IComparer-injected Map.ofList / Map.empty
///                    calls, passes the comparator through to Map_ofList / Map_empty
///                    so the new generic MapHandle API can store cmp in the handle.
module WasmGc.Transforms.MathMap

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core
open WasmGc.Runtime.Runtime

// ─────────────────────────────────────────────────────────────────
// Math dispatch
// ─────────────────────────────────────────────────────────────────

let dispatchMathCall (name: string) (wArgs: WExpr list) (ty: WType) (unsigned: bool) : WExpr =
    match name, wArgs, ty with
    // abs
    | "abs", [arg], WType.F64 -> WExpr.Unary(WUnaryOp.Abs, arg, WType.F64)
    | "abs", [arg], WType.F32 -> WExpr.Unary(WUnaryOp.Abs, arg, WType.F32)
    | "abs", [arg], WType.I32 ->
        // F#'s `abs Int32.MinValue` raises OverflowException; raise (a bare throw: catchable, but the exception
        // object is not populated) instead of silently returning MinValue
        wasm {
            let! tmp = arg
            return wasmIf (ltS tmp (i32Const 0))
                       (wasmIf (WExpr.Compare(WCompareOp.Eq, tmp, i32Const System.Int32.MinValue))
                               (WExpr.Throw WExpr.Nop) (sub (i32Const 0) tmp))
                       tmp
        }
    | "abs", [arg], WType.I64 ->
        wasm {
            let! tmp = arg
            return wasmIf (ltS tmp (i64Const 0L))
                (WExpr.Binary(WBinaryOp.Sub, i64Const 0L, tmp, WType.I64)) tmp
        }
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
    // Math.Round(x, digits): .NET scales by 10^digits, rounds half to even and scales back (|x| >= 1e16 is already integral)
    | ("round" | "nearest"), [arg; WExpr.Const(WConst.I32 d)], WType.F64 when d >= 0 && d <= 15 ->
        let p10 = WExpr.Const(WConst.F64(System.Math.Pow(10.0, float d)))
        let x = WExpr.LocalGet("$rnd_x", WType.F64)
        WExpr.Let("$rnd_x", arg,
            WExpr.If(WExpr.Compare(WCompareOp.LtS, WExpr.Unary(WUnaryOp.Abs, x, WType.F64), WExpr.Const(WConst.F64 1e16)),
                     WExpr.Binary(WBinaryOp.DivS, WExpr.Unary(WUnaryOp.Nearest, WExpr.Binary(WBinaryOp.Mul, x, p10, WType.F64), WType.F64), p10, WType.F64),
                     x, WType.F64))
    | ("round" | "nearest"), [arg; _], WType.F64 -> WExpr.Unary(WUnaryOp.Nearest, arg, WType.F64)
    | ("round" | "nearest"), [arg; _], WType.F32 -> WExpr.Unary(WUnaryOp.Nearest, arg, WType.F32)
    // min
    | "min", [a; b], WType.F64 -> WExpr.Binary(WBinaryOp.Min, a, b, WType.F64)
    | "min", [a; b], WType.F32 -> WExpr.Binary(WBinaryOp.Min, a, b, WType.F32)
    | "min", [a; b], (WType.I32 | WType.I64) ->
        wasm {
            let! ta = a
            let! tb = b
            return wasmIf (if unsigned then ltU ta tb else ltS ta tb) ta tb
        }
    // max
    | "max", [a; b], WType.F64 -> WExpr.Binary(WBinaryOp.Max, a, b, WType.F64)
    | "max", [a; b], WType.F32 -> WExpr.Binary(WBinaryOp.Max, a, b, WType.F32)
    | "max", [a; b], (WType.I32 | WType.I64) ->
        wasm {
            let! ta = a
            let! tb = b
            return wasmIf (if unsigned then WExpr.Compare(WCompareOp.GtU, ta, tb) else gtS ta tb) ta tb
        }
    // sign of a float: -1 / 0 / 1; NaN raises (ArithmeticException on .NET)
    | "sign", [arg], _ when (match exprWType arg with WType.F64 | WType.F32 -> true | _ -> false) ->
        wasm {
            let! tmp = arg
            let zero = if exprWType arg = WType.F32 then WExpr.Const(WConst.F32 0.0f) else WExpr.Const(WConst.F64 0.0)
            return wasmIf (WExpr.Compare(WCompareOp.Ne, tmp, tmp))
                       (WExpr.Throw WExpr.Nop)
                       (wasmIf (WExpr.Compare(WCompareOp.GtS, tmp, zero)) (i32Const 1)
                               (wasmIf (WExpr.Compare(WCompareOp.LtS, tmp, zero)) (i32Const (-1)) (i32Const 0)))
        }
    // sign
    | "sign", [arg], _ ->
        wasm {
            let! tmp = arg
            return wasmIf (gtS tmp (i32Const 0))
                (i32Const 1)
                (wasmIf (ltS tmp (i32Const 0)) (i32Const (-1)) (i32Const 0))
        }
    // Transcendentals: software implementations in FSharp.Wasm.Core/Math/MathHelpers.fs (repository fsharp-wasm-core).
    // Emitted as plain calls; if MathHelpers.fs is not part of the compiled project the module
    // fails WAT/WASM validation (unknown function) instead of silently computing wrong values.
    | ("exp" | "asin" | "acos" | "atan" | "atan2" | "sinh" | "cosh" | "tanh"), _, WType.F64 ->
        WExpr.Call("MathHelpers_" + name, wArgs, WType.F64)
    | _ ->
        // Never fabricate a value: a silent 0.0 is indistinguishable from a real result.
        eprintfn "[WasmGc] ERROR: unhandled Math call '%s' — emitting a trap (throws at runtime)" name
        WExpr.Throw(WExpr.Nop)

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
/// NO injected comparer from Fable, but the comparer is stored inside the MapHandle
/// produced by empty/ofList — so they work correctly by extracting it from the handle.
let tryMapInline
        (ctx: Ctx)
        (importStem: string)
        (selector: string)
        (wArgs: WExpr list) : WExpr option =
    if importStem <> "Map" then None
    else
    match selector, wArgs with
    // Map.ofList [pairs; cmp] — Fable appends cmp last; new API wants (cmp, list)
    | "ofList", [wList; wComparer] ->
        match Map.tryFind "Map_ofList" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Map_ofList", [wComparer; wList], retTy))
        | None -> None
    // Map.empty [cmp] — Fable appends cmp last; pass it through
    | "empty", [wComparer] ->
        match Map.tryFind "Map_empty" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Map_empty", [wComparer], retTy))
        | None -> None
    // Map.map routes to Map_mapValues (since "map" conflicts in F#)
    | "map", wArgs ->
        match Map.tryFind "Map_mapValues" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Map_mapValues", wArgs, retTy))
        | None -> None
    // Map.iter — Fable emits "iterate" as the selector
    | "iterate", wArgs ->
        match Map.tryFind "Map_iter" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Map_iter", wArgs, retTy))
        | None -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Set module intercept
// ─────────────────────────────────────────────────────────────────
/// Intercept standard F# `Set.*` calls that come through Fable's `setModule`
/// replacement.  Operations that receive an injected IComparer pass it through
/// to the new generic SetHandle API (comparer stored in handle).
let trySetInline
        (ctx: Ctx)
        (importStem: string)
        (selector: string)
        (wArgs: WExpr list) : WExpr option =
    if importStem <> "Set" then None
    else
    match selector, wArgs with
    // Set.ofList [items; cmp] — Fable appends cmp last; new API wants (cmp, list)
    | "ofList", [wList; wComparer] ->
        match Map.tryFind "Set_ofList" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Set_ofList", [wComparer; wList], retTy))
        | None -> None
    // Set.ofArray [items; cmp] — Fable appends cmp last; new API wants (cmp, array)
    | "ofArray", [wArr; wComparer] ->
        match Map.tryFind "Set_ofArray" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Set_ofArray", [wComparer; wArr], retTy))
        | None -> None
    // Set.empty [cmp] — Fable appends cmp last; pass it through
    | "empty", [wComparer] ->
        match Map.tryFind "Set_empty" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Set_empty", [wComparer], retTy))
        | None -> None
    // Set.singleton [value; cmp] — Fable appends cmp last; new API wants (cmp, value)
    | "singleton", [wVal; wComparer] ->
        match Map.tryFind "Set_singleton" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Set_singleton", [wComparer; wVal], retTy))
        | None -> None
    // Set.map [mapping; set; cmp] — drop injected comparer (Set.map preserves type)
    | "map", [wMapping; wSet; _comparer] ->
        match Map.tryFind "Set_map" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Set_map", [wMapping; wSet], retTy))
        | None -> None
    // Set.iterate → Set_iter (naming mismatch)
    | "iterate", wArgs ->
        match Map.tryFind "Set_iter" ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call("Set_iter", wArgs, retTy))
        | None -> None
    // Direct-mapping operations (no comparer injection, pass args as-is)
    | sel, wArgs when
        sel = "add" || sel = "contains" || sel = "remove" || sel = "count" ||
        sel = "isEmpty" || sel = "fold" || sel = "toList" ||
        sel = "filter" || sel = "exists" || sel = "forAll" ||
        sel = "union" || sel = "intersect" || sel = "difference" ||
        sel = "isSubset" || sel = "minElement" || sel = "maxElement" ->
        let funcName = $"Set_{sel}"
        match Map.tryFind funcName ctx.KnownFuncs with
        | Some (_, retTy) -> Some(WExpr.Call(funcName, wArgs, retTy))
        | None -> None
    | _ -> None
