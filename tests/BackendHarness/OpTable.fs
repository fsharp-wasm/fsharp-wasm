module OpTable
// Differential test: every (op, type) combination through BOTH emitters.
open System
open System.IO
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open Lib

let private tys = [ WType.I32; WType.I64; WType.F32; WType.F64 ]
let private bins = [ WBinaryOp.Add; WBinaryOp.Sub; WBinaryOp.Mul; WBinaryOp.DivS; WBinaryOp.DivU; WBinaryOp.RemS; WBinaryOp.RemU
                     WBinaryOp.And; WBinaryOp.Or; WBinaryOp.Xor; WBinaryOp.Shl; WBinaryOp.ShrS; WBinaryOp.ShrU; WBinaryOp.Rotl; WBinaryOp.Rotr
                     WBinaryOp.Min; WBinaryOp.Max; WBinaryOp.CopySign ]
let private cmps = [ WCompareOp.Eq; WCompareOp.Ne; WCompareOp.LtS; WCompareOp.LtU; WCompareOp.GtS; WCompareOp.GtU
                     WCompareOp.LeS; WCompareOp.LeU; WCompareOp.GeS; WCompareOp.GeU ]
let private uns = [ WUnaryOp.Neg; WUnaryOp.Abs; WUnaryOp.Sqrt; WUnaryOp.Ceil; WUnaryOp.Floor; WUnaryOp.Trunc; WUnaryOp.Nearest
                    WUnaryOp.Not; WUnaryOp.Clz; WUnaryOp.Ctz; WUnaryOp.Popcnt; WUnaryOp.Eqz ]

let private isInt t = t = WType.I32 || t = WType.I64
let private isFloat t = t = WType.F32 || t = WType.F64

// Combinations that are not valid WebAssembly at all (skip them).
let private validBin op t =
    match op with
    | WBinaryOp.And | WBinaryOp.Or | WBinaryOp.Xor | WBinaryOp.Shl | WBinaryOp.ShrS | WBinaryOp.ShrU | WBinaryOp.Rotl | WBinaryOp.Rotr
    | WBinaryOp.RemS | WBinaryOp.RemU | WBinaryOp.DivU -> isInt t
    | WBinaryOp.Min | WBinaryOp.Max | WBinaryOp.CopySign -> isFloat t
    | _ -> true
let private validCmp op t =
    match op with
    | WCompareOp.LtU | WCompareOp.GtU | WCompareOp.LeU | WCompareOp.GeU -> isInt t
    | _ -> true
let private validUn op t =
    match op with
    | WUnaryOp.Neg -> true
    | WUnaryOp.Abs | WUnaryOp.Sqrt | WUnaryOp.Ceil | WUnaryOp.Floor | WUnaryOp.Trunc | WUnaryOp.Nearest -> isFloat t
    | WUnaryOp.Not | WUnaryOp.Clz | WUnaryOp.Ctz | WUnaryOp.Popcnt | WUnaryOp.Eqz -> isInt t
    | _ -> false

let build () : (string * WModule) list =
    let ctx = newCtx ()
    let funcs = ResizeArray<WFuncDecl>()
    let name (k: string) (o: obj) (t: WType) = sprintf "%s_%s_%s" k (string o) (wTypeKey t) |> fun s -> s.Replace(".", "_")
    for t in tys do
        for op in bins do
            if validBin op t then
                funcs.Add { Name = name "bin" op t; Params = ["a", t; "b", t]; Result = t; Locals = []; Exported = true
                            Body = WExpr.Binary(op, WExpr.LocalGet("a", t), WExpr.LocalGet("b", t), t) }
        for op in cmps do
            if validCmp op t then
                funcs.Add { Name = name "cmp" op t; Params = ["a", t; "b", t]; Result = WType.I32; Locals = []; Exported = true
                            Body = WExpr.Compare(op, WExpr.LocalGet("a", t), WExpr.LocalGet("b", t)) }
        for op in uns do
            if validUn op t then
                let res = if op = WUnaryOp.Eqz then WType.I32 else t
                funcs.Add { Name = name "un" op t; Params = ["a", t]; Result = res; Locals = []; Exported = true
                            Body = WExpr.Unary(op, WExpr.LocalGet("a", t), res) }
    // one module per function so that one bad op does not hide the others
    [ for f in funcs -> f.Name, mkModule ctx.TypeDefs [ f ] ]
