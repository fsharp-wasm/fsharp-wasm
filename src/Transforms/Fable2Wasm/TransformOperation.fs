module WasmGc.Transforms.TransformOperation

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Runtime.Equality

module VT = WasmGc.Runtime.VTable

// ─────────────────────────────────────────────────────────────────
// Operation translation
// ─────────────────────────────────────────────────────────────────

/// Fable lowers integer width casts to JavaScript `Emit` macros (`byte a` → "$0 & 0xFF" …).  Every small integer is
/// an i32 here, so each macro is a short integer expression; `uint32` shares int32's bit pattern.
/// Returns None for any other macro (the caller reports it).
let integerCast (macro: string) (arg: WExpr) : WExpr option =
    let i32 n = WExpr.Const(WConst.I32 n)
    let bin op a b = WExpr.Binary(op, a, b, WType.I32)
    // a float / i64 operand is converted to i32 first, as JS ToInt32 would
    let x =
        match exprWType arg with
        | WType.I64 -> WExpr.Unary(WUnaryOp.WrapI64, arg, WType.I32)
        | WType.F64 -> WExpr.Unary(WUnaryOp.TruncF64S, arg, WType.I32)
        | WType.F32 -> WExpr.Unary(WUnaryOp.TruncF32S, arg, WType.I32)
        | _ -> arg
    // sign-extend the low `mask`+1 bits:  ((x + half) & mask) - half
    let signExtend half mask = bin WBinaryOp.Sub (bin WBinaryOp.And (bin WBinaryOp.Add x (i32 half)) (i32 mask)) (i32 half)
    match macro with
    | "$0 & 0xFF" -> Some(bin WBinaryOp.And x (i32 0xFF))
    | "$0 & 0xFFFF" -> Some(bin WBinaryOp.And x (i32 0xFFFF))
    | "($0 + 0x80 & 0xFF) - 0x80" -> Some(signExtend 0x80 0xFF)
    | "($0 + 0x8000 & 0xFFFF) - 0x8000" -> Some(signExtend 0x8000 0xFFFF)
    | "$0 >>> 0" -> Some x
    | _ -> None

/// uint8 / uint16 / uint32 operands need the unsigned opcodes (comparison, division, remainder, logical shift).
let private isUnsigned (t: Fable.Type) =
    match t with
    | Fable.Type.Number((NumberKind.UInt8 | NumberKind.UInt16 | NumberKind.UInt32), _) -> true
    | _ -> false

let transformOperation
    (ctx: Ctx)
    (eval: Ctx -> Fable.Expr -> WExpr)
    (kind: OperationKind)
    (typ: Fable.Type) : WExpr =
    let ty = mapTypeKnown ctx typ
    match kind with
    | Unary(op, operand) ->
        let wOperand = eval ctx operand
        match op with
        | UnaryMinus ->
            WExpr.Unary(WUnaryOp.Neg, wOperand, ty)
        | UnaryNot ->
            WExpr.Unary(WUnaryOp.Eqz, wOperand, ty)
        | UnaryNotBitwise ->
            // JS bitwise NOT silently truncates floats to int (~~x = Math.trunc(x) for floats).
            // In WASM we must truncate explicitly before applying integer NOT.
            let wOperand' =
                match exprWType wOperand with
                | WType.F64 -> WExpr.Unary(WUnaryOp.TruncF64S, wOperand, WType.I32)
                | WType.F32 -> WExpr.Unary(WUnaryOp.TruncF32S, wOperand, WType.I32)
                | _ -> wOperand
            WExpr.Unary(WUnaryOp.Not, wOperand', ty)
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
            | BinaryEqual -> WExpr.Call(ctx.UseHelper("$strEq"), [wLeft; wRight], WType.I32)
            | BinaryUnequal ->
                WExpr.Unary(WUnaryOp.Eqz, WExpr.Call(ctx.UseHelper("$strEq"), [wLeft; wRight], WType.I32), WType.I32)
            | _ -> WExpr.Nop // other string ops unsupported
        // ── Structural equality for records, data-carrying DUs, and tuples ──
        elif (op = BinaryEqual || op = BinaryUnequal) &&
             (match left.Type with
              | Fable.Type.Tuple _ -> true
              | Fable.Type.DeclaredType(entRef, _) -> Map.containsKey entRef.FullName ctx.TypeRegistry
              | _ -> false) then
            // Ensure the wasm type is registered (mapTypeKnown may create a fresh TupleRegistry entry)
            let wLeft = eval ctx left
            let wRight = eval ctx right
            let typeIdx =
                match exprWType wLeft with
                | WType.Ref(idx, _) -> idx
                | _ -> -1
            if typeIdx < 0 then
                WExpr.Compare(WCompareOp.Eq, wLeft, wRight)  // fallback: ref eq
            else
                // Ensure strEq is emitted (compareByWType may delegate some fields to it)
                ctx.UseHelper("$strEq") |> ignore
                match getOrAddStructuralEquals ctx typeIdx with
                | Some funcName ->
                    let call = WExpr.Call(funcName, [wLeft; wRight], WType.I32)
                    if op = BinaryUnequal then WExpr.Unary(WUnaryOp.Eqz, call, WType.I32)
                    else call
                | None ->
                    WExpr.Compare(WCompareOp.Eq, wLeft, wRight)  // fallback
        else
        let wLeft = eval ctx left
        let wRight = eval ctx right
        let unsigned = isUnsigned left.Type
        let pick s u = if unsigned then u else s
        match op with
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
            WExpr.Binary(WBinaryOp.Add, wLeft, wRight, ty)
        | BinaryMinus ->
            WExpr.Binary(WBinaryOp.Sub, wLeft, wRight, ty)
        | BinaryMultiply ->
            WExpr.Binary(WBinaryOp.Mul, wLeft, wRight, ty)
        | BinaryDivide ->
            WExpr.Binary(pick WBinaryOp.DivS WBinaryOp.DivU, wLeft, wRight, ty)
        | BinaryModulus ->
            WExpr.Binary(pick WBinaryOp.RemS WBinaryOp.RemU, wLeft, wRight, ty)
        | BinaryShiftLeft ->
            WExpr.Binary(WBinaryOp.Shl, wLeft, wRight, ty)
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
