module WasmGc.Transforms.TransformOperation

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Runtime.Equality

module VT = WasmGc.Runtime.VTable
module Q = WasmGc.Util.FableQuery
open WasmGc.Transforms.NumericCasts

// ─────────────────────────────────────────────────────────────────
// Operation translation
// ─────────────────────────────────────────────────────────────────

let transformOperation
    (ctx: Ctx)
    (eval: Ctx -> Fable.Expr -> WExpr)
    (kind: OperationKind)
    (typ: Fable.Type) : WExpr =
    let ty = mapTypeKnown ctx typ
    // arithmetic on byte / sbyte / int16 / uint16 wraps at the width of the type
    let wrap =
        match typ with
        | Fable.Type.Number(kind, _) -> narrow kind
        | _ -> id
    match kind with
    | Unary(op, operand) ->
        let wOperand = eval ctx operand
        match op with
        | UnaryMinus ->
            wrap (WExpr.Unary(WUnaryOp.Neg, wOperand, ty))
        | UnaryNot ->
            WExpr.Unary(WUnaryOp.Eqz, wOperand, ty)
        | UnaryNotBitwise ->
            // JS bitwise NOT silently truncates floats to int (~~x = Math.trunc(x) for floats); Fable uses `~~~(~~~x)`
            // for F#'s `int x`.  In WASM we must truncate explicitly — saturating like .NET (NaN → 0), never trapping.
            let wOperand' =
                match exprWType wOperand with
                | WType.F64 -> WExpr.Unary(WUnaryOp.TruncSatF64S, wOperand, WType.I32)
                | WType.F32 -> WExpr.Unary(WUnaryOp.TruncSatF32S, wOperand, WType.I32)
                | _ -> wOperand
            wrap (WExpr.Unary(WUnaryOp.Not, wOperand', ty))
        | _ ->
            WExpr.Unary(WUnaryOp.Neg, wOperand, ty) // fallback

    | Binary(op, left, right) ->
        // String operations route to runtime helpers (array i32 has no native == or +)
        if left.Type = Fable.Type.String || right.Type = Fable.Type.String then
            let wLeft = eval ctx left
            let wRight = eval ctx right
            let strRef = WType.Ref(StringTypeIdx, false)
            match op with
            | BinaryPlus -> WExpr.Call(ctx.UseHelper("$strConcat"), [wLeft; wRight], strRef)
            | BinaryEqual -> strEquals ctx wLeft wRight
            | BinaryUnequal -> WExpr.Unary(WUnaryOp.Eqz, strEquals ctx wLeft wRight, WType.I32)
            // ordinal ordering via $strCompare (<0 / 0 / >0)
            | BinaryLess | BinaryLessOrEqual | BinaryGreater | BinaryGreaterOrEqual ->
                let cmp = WExpr.Call(ctx.UseHelper("$strCompare"), [wLeft; wRight], WType.I32)
                let cop =
                    match op with
                    | BinaryLess -> WCompareOp.LtS
                    | BinaryLessOrEqual -> WCompareOp.LeS
                    | BinaryGreater -> WCompareOp.GtS
                    | _ -> WCompareOp.GeS
                WExpr.Compare(cop, cmp, WExpr.Const(WConst.I32 0))
            | _ -> WExpr.Nop // other string ops unsupported
        // ── Structural equality for records, data-carrying DUs, and tuples ──
        elif (op = BinaryEqual || op = BinaryUnequal) &&
             (match left.Type with
              | Fable.Type.Tuple _ | Fable.Type.AnonymousRecordType _ -> true
              | Fable.Type.DeclaredType(entRef, _) -> Map.containsKey entRef.FullName ctx.TypeRegistry
              | _ -> false) then
            // Ensure the wasm type is registered (mapTypeKnown may create a fresh TupleRegistry entry)
            let wLeft = eval ctx left
            let wRight = eval ctx right
            let eq = structuralEquals ctx wLeft wRight
            if op = BinaryUnequal then WExpr.Unary(WUnaryOp.Eqz, eq, WType.I32) else eq
        else
        let wLeft = eval ctx left
        let wRight = eval ctx right
        let unsigned = Q.isUnsignedInt left.Type
        let pick s u = if unsigned then u else s
        let structural = isStructuralRef (exprWType wLeft)
        match op with
        // ordering on records / unions / tuples / options: the structural compare function, then compare with 0
        | BinaryLess | BinaryLessOrEqual | BinaryGreater | BinaryGreaterOrEqual when structural ->
            let cmp = compareValues ctx (exprWType wLeft) wLeft wRight
            let cop =
                match op with
                | BinaryLess -> WCompareOp.LtS
                | BinaryLessOrEqual -> WCompareOp.LeS
                | BinaryGreater -> WCompareOp.GtS
                | _ -> WCompareOp.GeS
            WExpr.Compare(cop, cmp, WExpr.Const(WConst.I32 0))
        // `=` in generic code (`items.[i] = item` with 'T = string): the operands' Fable type is the parameter, the
        // evaluated value says what it became in this instantiation
        | BinaryEqual | BinaryUnequal when (match exprWType wLeft with WType.Ref(i, _) -> i = StringTypeIdx | _ -> false) ->
            let eq = strEquals ctx wLeft wRight
            if op = BinaryUnequal then WExpr.Unary(WUnaryOp.Eqz, eq, WType.I32) else eq
        | BinaryEqual | BinaryUnequal when structural ->
            let eq = structuralEquals ctx wLeft wRight
            if op = BinaryUnequal then WExpr.Unary(WUnaryOp.Eqz, eq, WType.I32) else eq
        // Comparisons → WExpr.Compare
        | BinaryEqual ->
            WExpr.Compare(WCompareOp.Eq, wLeft, wRight)
        | BinaryUnequal ->
            WExpr.Compare(WCompareOp.Ne, wLeft, wRight)
        | BinaryLess ->
            WExpr.Compare(pick WCompareOp.LtS WCompareOp.LtU, wLeft, wRight)
        | BinaryLessOrEqual ->
            WExpr.Compare(pick WCompareOp.LeS WCompareOp.LeU, wLeft, wRight)
        | BinaryGreater ->
            WExpr.Compare(pick WCompareOp.GtS WCompareOp.GtU, wLeft, wRight)
        | BinaryGreaterOrEqual ->
            WExpr.Compare(pick WCompareOp.GeS WCompareOp.GeU, wLeft, wRight)
        // Arithmetic → WExpr.Binary
        | BinaryPlus ->
            wrap (WExpr.Binary(WBinaryOp.Add, wLeft, wRight, ty))
        | BinaryMinus ->
            wrap (WExpr.Binary(WBinaryOp.Sub, wLeft, wRight, ty))
        | BinaryMultiply ->
            wrap (WExpr.Binary(WBinaryOp.Mul, wLeft, wRight, ty))
        | BinaryDivide ->
            WExpr.Binary(pick WBinaryOp.DivS WBinaryOp.DivU, wLeft, wRight, ty)
        | BinaryModulus ->
            WExpr.Binary(pick WBinaryOp.RemS WBinaryOp.RemU, wLeft, wRight, ty)
        | BinaryShiftLeft ->
            wrap (WExpr.Binary(WBinaryOp.Shl, wLeft, wRight, ty))
        | BinaryShiftRightSignPropagating ->
            WExpr.Binary(pick WBinaryOp.ShrS WBinaryOp.ShrU, wLeft, wRight, ty)
        | BinaryShiftRightZeroFill ->
            WExpr.Binary(WBinaryOp.ShrU, wLeft, wRight, ty)
        | BinaryOrBitwise ->
            WExpr.Binary(WBinaryOp.Or, wLeft, wRight, ty)
        | BinaryXorBitwise ->
            WExpr.Binary(WBinaryOp.Xor, wLeft, wRight, ty)
        | BinaryAndBitwise ->
            WExpr.Binary(WBinaryOp.And, wLeft, wRight, ty)
        | BinaryExponent ->
            // No native WASM exponent: route to $pown (i32) or $powF64 (f64).
            match ty with
            | WType.I32 -> WExpr.Call(ctx.UseHelper("$pown"),   [wLeft; wRight], WType.I32)
            | _         -> WExpr.Call(ctx.UseHelper("$powF64"), [wLeft; wRight], WType.F64)

    | Logical(op, left, right) ->
        let wLeft = eval ctx left
        let wRight = eval ctx right
        match op with
        | LogicalAnd ->
            // short-circuit: if left then right else false
            WExpr.If(wLeft, wRight, WExpr.Const(WConst.I32 0), WType.I32)
        | LogicalOr ->
            // short-circuit: if left then true else right
            WExpr.If(wLeft, WExpr.Const(WConst.I32 1), wRight, WType.I32)
