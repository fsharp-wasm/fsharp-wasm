module WasmGc.Transforms.TransformHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

/// One printf conversion: the conversion character and its precision (`%.2f` → Some 2).
/// Flags and widths are parsed away, not applied.
type FormatSpec = { Conv: char; Precision: int option }

/// Parse a printf-style format string into prefix parts and conversions.
/// e.g. "Hello %s, you are %d!" → (["Hello "; ", you are "; "!"], [s; d])
/// %% is treated as a literal '%'.
let parseFormatSpecs (fmt: string) : string list * FormatSpec list =
    let parts = System.Collections.Generic.List<string>()
    let specs = System.Collections.Generic.List<FormatSpec>()
    let sb = System.Text.StringBuilder()
    let precisionOf (flags: string) =
        match flags.IndexOf '.' with
        | -1 -> None
        | k ->
            let digits = flags.Substring(k + 1) |> Seq.takeWhile System.Char.IsDigit |> Seq.toArray |> System.String
            Some(if digits = "" then 0 else int digits)
    let mutable i = 0
    while i < fmt.Length do
        if fmt.[i] = '%' && i + 1 < fmt.Length then
            let mutable j = i + 1
            while j < fmt.Length && (System.Char.IsDigit(fmt.[j]) || fmt.[j] = '.' || fmt.[j] = '-' || fmt.[j] = '+' || fmt.[j] = ' ') do
                j <- j + 1
            if j < fmt.Length && fmt.[j] = '%' then
                sb.Append('%') |> ignore
                i <- j + 1
            elif j < fmt.Length then
                parts.Add(sb.ToString())
                sb.Clear() |> ignore
                specs.Add { Conv = fmt.[j]; Precision = precisionOf (fmt.Substring(i + 1, j - i - 1)) }
                i <- j + 1
            else
                i <- j
        else
            sb.Append(fmt.[i]) |> ignore
            i <- i + 1
    parts.Add(sb.ToString())
    List.ofSeq parts, List.ofSeq specs

/// `compare a b` on numbers → -1 / 0 / 1.  Floats follow F#'s generic comparison: NaN is below every other value
/// and equal to itself —  x < y ? -1 : x > y ? 1 : x = y ? 0 : y = y ? -1 : (x = x ? 1 : 0).
let numericCompare (a: WExpr) (b: WExpr) (argTy: WType) : WExpr =
    let x, y = WExpr.LocalGet("$cmp_a", argTy), WExpr.LocalGet("$cmp_b", argTy)
    let cmp op l r = WExpr.Compare(op, l, r)
    let i32 n = WExpr.Const(WConst.I32 n)
    let body =
        match argTy with
        | WType.F64 | WType.F32 ->
            WExpr.If(cmp WCompareOp.LtS x y, i32 -1,
                WExpr.If(cmp WCompareOp.GtS x y, i32 1,
                    WExpr.If(cmp WCompareOp.Eq x y, i32 0,
                        WExpr.If(cmp WCompareOp.Eq y y, i32 -1,
                            WExpr.If(cmp WCompareOp.Eq x x, i32 1, i32 0, WType.I32), WType.I32), WType.I32), WType.I32), WType.I32)
        | _ ->
            WExpr.If(cmp WCompareOp.Eq x y, i32 0, WExpr.If(cmp WCompareOp.LtS x y, i32 -1, i32 1, WType.I32), WType.I32)
    WExpr.Let("$cmp_a", a, WExpr.Let("$cmp_b", b, body))

/// `String.concat sep items` / `String.Join`: the items are a string ARRAY or an F# LIST.
let strJoin (ctx: Ctx) (sep: WExpr) (items: WExpr) : WExpr =
    let helper =
        match exprWType items with
        | WType.Ref(idx, _) when idx = ListBaseTypeIdx -> "$strJoinList"
        | _ -> "$strJoin"
    WExpr.Call(ctx.UseHelper helper, [ sep; items ], WType.Ref(StringTypeIdx, false))

/// `string c` for a char: a one-element string (chars are i32 code points here).
let charToString (c: WExpr) : WExpr =
    WExpr.ArrayNewFixed(StringTypeIdx, [ c ], WType.Ref(StringTypeIdx, false))

/// Convert one printf / interpolation hole value to a string.
///   %f %F     fixed decimals — `%.Nf`, default 6 (`$floatToFixed`)
///   %g %e     approximate: up to 6 significant digits (`$floatToStr`)
///   %b        true / false
///   other     string as is; integers and floats by their runtime type
let formatHole (ctx: Ctx) (spec: FormatSpec) (unsigned: bool) (wv: WExpr) : WExpr =
    let strRef = WType.Ref(StringTypeIdx, false)
    let lit (s: string) =
        WExpr.ArrayNewFixed(StringTypeIdx, s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList, strRef)
    let promote () =
        match exprWType wv with
        | WType.F64 -> wv
        | WType.F32 -> WExpr.Unary(WUnaryOp.PromoteF32, wv, WType.F64)
        | _ -> WExpr.Unary(WUnaryOp.ConvertI32S, wv, WType.F64)
    match spec.Conv with
    | 'f' | 'F' ->
        WExpr.Call(ctx.UseHelper "$floatToFixed", [ promote (); WExpr.Const(WConst.I32(defaultArg spec.Precision 6)) ], strRef)
    | 'g' | 'e' -> WExpr.Call(ctx.UseHelper "$floatToStr", [ promote () ], strRef)
    | 'b' -> WExpr.If(wv, lit "true", lit "false", strRef)
    | _ ->
        match exprWType wv with
        | WType.Ref(idx, _) when idx = StringTypeIdx -> wv
        | WType.I64 -> WExpr.Call(ctx.UseHelper "$intToStr", [ WExpr.Unary(WUnaryOp.WrapI64, wv, WType.I32) ], strRef)
        | WType.F64 | WType.F32 -> WExpr.Call(ctx.UseHelper "$floatToStr", [ promote () ], strRef)
        | _ -> WExpr.Call(ctx.UseHelper(if unsigned then "$uintToStr" else "$intToStr"), [ wv ], strRef)
