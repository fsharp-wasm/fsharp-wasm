/// Integer width casts shared by the operator lowering, the `Emit` macros Fable generates for conversions
/// and the BigInt (int64) library calls.  Every small integer is an i32 here.
module WasmGc.Transforms.NumericCasts

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types

/// Truncate an i32 to the width of a small integer type — the wrap-around of `byte`, `sbyte`, `int16`, `uint16`
/// arithmetic.  Every integer is an i32 here; int32 / uint32 wrap by themselves.
let narrow (kind: NumberKind) (x: WExpr) : WExpr =
    let i32 n = WExpr.Const(WConst.I32 n)
    let bin op a b = WExpr.Binary(op, a, b, WType.I32)
    // sign-extend the low `mask`+1 bits:  ((x + half) & mask) - half
    let signExtend half mask = bin WBinaryOp.Sub (bin WBinaryOp.And (bin WBinaryOp.Add x (i32 half)) (i32 mask)) (i32 half)
    match kind with
    | NumberKind.UInt8 -> bin WBinaryOp.And x (i32 0xFF)
    | NumberKind.UInt16 -> bin WBinaryOp.And x (i32 0xFFFF)
    | NumberKind.Int8 -> signExtend 0x80 0xFF
    | NumberKind.Int16 -> signExtend 0x8000 0xFFFF
    | _ -> x

/// Fable lowers integer width casts to JavaScript `Emit` macros (`byte a` → "$0 & 0xFF" …).  Every small integer is
/// an i32 here, so each macro is `narrow`; `uint32` shares int32's bit pattern.
/// Returns None for any other macro (the caller reports it).
let integerCast (macro: string) (arg: WExpr) : WExpr option =
    // a float / i64 operand is converted to i32 first, as JS ToInt32 would
    let x =
        match exprWType arg with
        | WType.I64 -> WExpr.Unary(WUnaryOp.WrapI64, arg, WType.I32)
        | WType.F64 -> WExpr.Unary(WUnaryOp.TruncF64S, arg, WType.I32)
        | WType.F32 -> WExpr.Unary(WUnaryOp.TruncF32S, arg, WType.I32)
        | _ -> arg
    match macro with
    | "$0 & 0xFF" -> Some(narrow NumberKind.UInt8 x)
    | "$0 & 0xFFFF" -> Some(narrow NumberKind.UInt16 x)
    | "($0 + 0x80 & 0xFF) - 0x80" -> Some(narrow NumberKind.Int8 x)
    | "($0 + 0x8000 & 0xFFFF) - 0x8000" -> Some(narrow NumberKind.Int16 x)
    | "$0 >>> 0" -> Some x
    | _ -> None
