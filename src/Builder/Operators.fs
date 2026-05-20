namespace WasmGc.Builder

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core


// ═════════════════════════════════════════════════════════════════════════════
// Layer 3 — WasmDsl infix operators + WasmPatterns active patterns
// ═════════════════════════════════════════════════════════════════════════════

/// Infix operators for WExpr. `open WasmDsl` inside helper modules.
[<AutoOpen>]
module WasmDsl =
    let inline ( +.  ) a b = add   a b
    let inline ( -.  ) a b = sub   a b
    let inline ( *.  ) a b = mul   a b
    let inline ( /.  ) a b = div_  a b
    let inline ( %.  ) a b = rem_  a b
    let inline ( =.  ) a b = eq    a b
    let inline ( <>. ) a b = ne    a b
    let inline ( <.  ) a b = ltS   a b
    let inline ( <=. ) a b = leS   a b
    let inline ( >.  ) a b = gtS   a b
    let inline ( >=. ) a b = geS   a b
    let inline ( &&. ) a b = wasmAnd a b
    let inline ( ||. ) a b = wasmOr  a b
    let inline ( +.. ) a b = addf64 a b
    let inline ( -.. ) a b = subf64 a b
    let inline ( *.. ) a b = mulf64 a b
    let inline ( /.. ) a b = divf64 a b

/// Active patterns for readable, refactor-safe WExpr transforms.
module WasmPatterns =
    let (|I32Lit|_|)  = function WExpr.Const(WConst.I32 n) -> Some n | _ -> None
    let (|I64Lit|_|)  = function WExpr.Const(WConst.I64 n) -> Some n | _ -> None
    let (|F64Lit|_|)  = function WExpr.Const(WConst.F64 v) -> Some v | _ -> None
    let (|I32Zero|_|) = function WExpr.Const(WConst.I32 0) -> Some() | _ -> None
    let (|I32One|_|)  = function WExpr.Const(WConst.I32 1) -> Some() | _ -> None

    let (|BinAdd|_|) = function WExpr.Binary(WBinaryOp.Add,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinSub|_|) = function WExpr.Binary(WBinaryOp.Sub,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinMul|_|) = function WExpr.Binary(WBinaryOp.Mul,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinAnd|_|) = function WExpr.Binary(WBinaryOp.And,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinOr|_|)  = function WExpr.Binary(WBinaryOp.Or,   a, b, t) -> Some(a, b, t) | _ -> None

    let (|CmpEq|_|)  = function WExpr.Compare(WCompareOp.Eq,  a, b) -> Some(a, b) | _ -> None
    let (|CmpNe|_|)  = function WExpr.Compare(WCompareOp.Ne,  a, b) -> Some(a, b) | _ -> None
    let (|CmpLt|_|)  = function WExpr.Compare(WCompareOp.LtS, a, b) -> Some(a, b) | _ -> None
    let (|CmpGt|_|)  = function WExpr.Compare(WCompareOp.GtS, a, b) -> Some(a, b) | _ -> None

    let (|IfExpr|_|)   = function WExpr.If(c, t, e, ty) -> Some(c, t, e, ty) | _ -> None
    let (|LocalVar|_|) = function WExpr.LocalGet(n, ty)  -> Some(n, ty)       | _ -> None
    let (|IsNull|_|)   = function WExpr.RefIsNull e       -> Some e            | _ -> None


module Operators =

    /// Wrapper for value-producing WExprs; enables clean operator overloading
    /// without redefining F# global operators for all types.
    type WVal = private WVal of WExpr
    with
        static member op_LessThan (WVal a, WVal b) = WVal (WExpr.Compare(WCompareOp.LtS, a, b))
        static member op_GreaterThan (WVal a, WVal b) = WVal (WExpr.Compare(WCompareOp.GtS, a, b))
        static member op_LessThanOrEqual (WVal a, WVal b) = WVal (WExpr.Compare(WCompareOp.LeS, a, b))
        static member op_GreaterThanOrEqual (WVal a, WVal b) = WVal (WExpr.Compare(WCompareOp.GeS, a, b))
        static member op_Subtraction (WVal a, WVal b) = WVal (WExpr.Binary(WBinaryOp.Sub, a, b, exprWType a))

    module WVal =
        let private ensure (e: WExpr) =
            if isDivergingExpr e || exprWType e = WType.Void then
                failwith "WVal operator expects a value expression (non-void, non-diverging)."
            e

        /// Wrap a value-producing expression (throws on void/diverging)
        let v (e: WExpr) = e |> ensure |> WVal
        /// Unwrap
        let value (WVal e) = e
        // Local custom operators used to build IR comparisons without returning F# bools
        // Note: Builder.fs also re-exports these as module-level functions.
        // Keep here for `open WasmGc.Builder.Operators` usage in non-CE contexts. 
        let ( <? ) (WVal a) (WVal b) = WVal (WExpr.Compare(WCompareOp.LtS, a, b))
        let ( >? ) (WVal a) (WVal b) = WVal (WExpr.Compare(WCompareOp.GtS, a, b))
        let ( -? ) (WVal a) (WVal b) = WVal (WExpr.Binary(WBinaryOp.Sub, a, b, exprWType a))

        /// Three-way comparison result in {-1,0,1}
        let cmp (a: WExpr) (b: WExpr) : WExpr =
            let res = (v a >? v b) -? (v a <? v b)
            value res

    /// Ternary comparator operator for WExprs: returns {-1,0,1}
    let ( <=> ) (a: WExpr) (b: WExpr) : WExpr =
        WVal.cmp a b

