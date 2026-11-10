/// Fable lowers int64 / uint64 to JavaScript BigInt library calls (`BigInt.op_Addition`, `BigInt.op_RightShift`,
/// `BigInt.toInt64_unchecked`, …).  Here an int64 IS an i64 (wrapping arithmetic included), so each call is one
/// native instruction.  Only `BigInt.fs` imports are touched; anything not listed yet stays unhandled and is
/// reported (WGC008) rather than guessed.
module WasmGc.Transforms.BigIntMap

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Transforms.NumericCasts
open WasmGc.Transforms.TransformHelpers

let tryBigIntInline (ctx: Ctx) (stem: string) (sel: string) (wArgs: WExpr list) (unsigned: bool) : WExpr option =
    if stem <> "BigInt" then None
    else
        let i64 = WType.I64
        // shift counts and mixed operands arrive as i32
        let wide (x: WExpr) =
            match exprWType x with
            | WType.I64 -> x
            | _ -> WExpr.Unary(WUnaryOp.ExtendI32S, x, i64)
        let bin op a b = Some(WExpr.Binary(op, wide a, wide b, i64))
        let pick s u = if unsigned then u else s
        let wrap32 x = WExpr.Unary(WUnaryOp.WrapI64, wide x, WType.I32)
        match sel, wArgs with
        // arithmetic and bitwise operators (an i64 wraps by itself)
        | "op_Addition", [ a; b ] -> bin WBinaryOp.Add a b
        | "op_Subtraction", [ a; b ] -> bin WBinaryOp.Sub a b
        | "op_Multiply", [ a; b ] -> bin WBinaryOp.Mul a b
        | "op_Division", [ a; b ] -> bin (pick WBinaryOp.DivS WBinaryOp.DivU) a b
        | "op_Modulus", [ a; b ] -> bin (pick WBinaryOp.RemS WBinaryOp.RemU) a b
        | "op_BitwiseAnd", [ a; b ] -> bin WBinaryOp.And a b
        | "op_BitwiseOr", [ a; b ] -> bin WBinaryOp.Or a b
        | "op_ExclusiveOr", [ a; b ] -> bin WBinaryOp.Xor a b
        | "op_LeftShift", [ a; n ] -> bin WBinaryOp.Shl a n
        | "op_RightShift", [ a; n ] -> bin (pick WBinaryOp.ShrS WBinaryOp.ShrU) a n
        | "op_UnaryNegation", [ a ] -> Some(WExpr.Binary(WBinaryOp.Sub, WExpr.Const(WConst.I64 0L), wide a, i64))
        | "op_LogicalNot", [ a ] -> Some(WExpr.Binary(WBinaryOp.Xor, wide a, WExpr.Const(WConst.I64 -1L), i64))
        // comparison
        | "equals", [ a; b ] -> Some(WExpr.Compare(WCompareOp.Eq, wide a, wide b))
        | "compare", [ a; b ] when not unsigned -> Some(numericCompare (wide a) (wide b) i64)
        // conversions to int64 / uint64 (unchecked: the value is already 64 bits)
        | ("toInt64" | "toUInt64" | "toInt64_unchecked" | "toUInt64_unchecked" | "fromInt64" | "fromUInt64"), [ a ] -> Some(wide a)
        | ("fromInt32" | "fromInt16" | "fromInt8"), [ a ] -> Some(WExpr.Unary(WUnaryOp.ExtendI32S, a, i64))
        | ("fromUInt32" | "fromUInt16" | "fromUInt8" | "fromChar"), [ a ] -> Some(WExpr.Unary(WUnaryOp.ExtendI32U, a, i64))
        // conversions from int64 to smaller integers wrap
        | ("toInt32" | "toUInt32" | "toInt32_unchecked" | "toUInt32_unchecked"), [ a ] -> Some(wrap32 a)
        | ("toInt16" | "toInt16_unchecked"), [ a ] -> Some(narrow NumberKind.Int16 (wrap32 a))
        | ("toUInt16" | "toUInt16_unchecked"), [ a ] -> Some(narrow NumberKind.UInt16 (wrap32 a))
        | ("toInt8" | "toInt8_unchecked"), [ a ] -> Some(narrow NumberKind.Int8 (wrap32 a))
        | ("toUInt8" | "toUInt8_unchecked"), [ a ] -> Some(narrow NumberKind.UInt8 (wrap32 a))
        // floats (signed only; saturating like .NET 9+)
        | "toFloat64", [ a ] -> Some(WExpr.Unary(WUnaryOp.ConvertI64S, wide a, WType.F64))
        | "toFloat32", [ a ] -> Some(WExpr.Unary(WUnaryOp.ConvertI64S, wide a, WType.F32))
        | "fromFloat64", [ a ] -> Some(WExpr.Unary(WUnaryOp.TruncSatF64S, a, i64))
        | "fromFloat32", [ a ] -> Some(WExpr.Unary(WUnaryOp.TruncSatF32S, a, i64))
        | "toString", [ a ] -> Some(int64ToString ctx (wide a) unsigned)
        | _ -> None
