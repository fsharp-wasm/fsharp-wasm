module WasmGc.Transforms.TransformConstruct

open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc.Runtime.Types
open WasmGc.Builder

/// Baut eine If-Then-Else Wasm-Expression
let buildIf (wGuard: WExpr) (wThen: WExpr) (wElse: WExpr) (ty: WType) =
    WExpr.If(wGuard, wThen, wElse, ty)

/// Baut eine Wasm While-Schleife
let buildWhile (wGuard: WExpr) (wBody: WExpr) =
    let label = "$while"
    let loopBody =
        WExpr.If(
            wGuard,
            WExpr.Sequence [wBody; WExpr.Continue(label, [])],
            WExpr.Nop,
            WType.Void
        )
    WExpr.Loop(label, loopBody, WType.Void)

/// Baut einen TypeCast
let buildTypeCast (ctx: Ctx) (wExpr: WExpr) (targetFableType: Fable.Type) : WExpr =
    let srcTy = exprWType wExpr
    let dstTyKnown = mapTypeKnown ctx targetFableType
    let dstTy = mapType targetFableType
    if srcTy = dstTyKnown then wExpr
    else
        match srcTy, dstTyKnown with
        | WType.AnyRef, WType.Ref(typeIdx, _) -> WExpr.Cast(wExpr, WType.Ref(typeIdx, false))
        | WType.Ref(_, true), WType.Ref(typeIdx, false) -> WExpr.Cast(wExpr, WType.Ref(typeIdx, false))
        | _ ->
            match srcTy, dstTy with
            | WType.F64, WType.I32 -> WExpr.Unary(WUnaryOp.TruncF64S, wExpr, WType.I32)
            | WType.F32, WType.I32 -> WExpr.Unary(WUnaryOp.TruncF32S, wExpr, WType.I32)
            | WType.I32, WType.F64 -> WExpr.Unary(WUnaryOp.ConvertI32S, wExpr, WType.F64)
            | WType.I64, WType.F64 -> WExpr.Unary(WUnaryOp.ConvertI64S, wExpr, WType.F64)
            | WType.F32, WType.F64 -> WExpr.Unary(WUnaryOp.PromoteF32, wExpr, WType.F64)
            | WType.F64, WType.F32 -> WExpr.Unary(WUnaryOp.DemoteF64, wExpr, WType.F32)
            | _ -> wExpr

/// Konvertiert Fable Konstanten in Wasm Konstanten
let transformValue (ctx: Ctx) (kind: ValueKind) (eval: Ctx -> Fable.Expr -> WExpr) : WExpr =
    match kind with
    | UnitConstant -> WExpr.Nop
    | BoolConstant b -> WExpr.Const(WConst.I32(if b then 1 else 0))
    | CharConstant c -> WExpr.Const(WConst.I32(int c))
    | StringConstant s ->
        let strType = WType.Ref(StringTypeIdx, false)
        if s.Length = 0 then WExpr.ArrayNewFixed(StringTypeIdx, [], strType)
        else
            let chars = s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList
            WExpr.ArrayNewFixed(StringTypeIdx, chars, strType)
    | NumberConstant(value, _) ->
        match value with
        | NumberValue.Int32 n -> WExpr.Const(WConst.I32 n)
        | NumberValue.Float64 n -> WExpr.Const(WConst.F64 n)
        // ... (Füge hier die restlichen NumberValue cases ein)
        | _ -> WExpr.Const(WConst.I32 0)
    | Null _ -> WExpr.Const(WConst.Null(WType.I32))
    | NewArray(Fable.NewArrayKind.ArrayValues exprs, elemType, _) ->
        let elemT = mapTypeKnown ctx elemType
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let wVals = exprs |> List.map (eval ctx)
        WExpr.ArrayNewFixed(arrTypeIdx, wVals, WType.Ref(arrTypeIdx, false))
    | _ -> WExpr.Nop // Für komplexe Typen wie NewTuple, NewUnion (aus deinem Original-Code hier übernehmen)