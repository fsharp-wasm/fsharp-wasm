module WasmGc.Transforms.TransformHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

/// One printf conversion: `%[flags][width][.precision]conv`.  Flags: 1 = `-` (left), 2 = `0` (zero pad), 4 = `+`, 8 = space.
type FormatSpec = { Conv: char; Precision: int option; Width: int; Flags: int }

/// Parse a printf-style format string into prefix parts and conversions.
/// e.g. "Hello %s, you are %d!" → (["Hello "; ", you are "; "!"], [s; d])
/// %% is treated as a literal '%'.
let parseFormatSpecs (fmt: string) : string list * FormatSpec list =
    let parts = System.Collections.Generic.List<string>()
    let specs = System.Collections.Generic.List<FormatSpec>()
    let sb = System.Text.StringBuilder()
    let widthOf (flags: string) =
        let body = (match flags.IndexOf '.' with -1 -> flags | k -> flags.Substring(0, k)).TrimStart('-', '+', ' ', '0')
        if body = "" || not (System.Char.IsDigit body.[0]) then 0 else int body
    let flagsOf (flags: string) =
        let lead = flags |> Seq.takeWhile (fun c -> c = '-' || c = '+' || c = ' ' || c = '0') |> Seq.toList
        (if List.contains '-' lead then 1 else 0) ||| (if List.contains '0' lead then 2 else 0)
        ||| (if List.contains '+' lead then 4 else 0) ||| (if List.contains ' ' lead then 8 else 0)
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
                let flags = fmt.Substring(i + 1, j - i - 1)
                specs.Add { Conv = fmt.[j]; Precision = precisionOf flags; Width = widthOf flags; Flags = flagsOf flags }
                i <- j + 1
            else
                i <- j
        else
            sb.Append(fmt.[i]) |> ignore
            i <- i + 1
    parts.Add(sb.ToString())
    List.ofSeq parts, List.ofSeq specs

/// `String.concat sep items` / `String.Join`: the items are a string ARRAY or an F# LIST.
let strJoin (ctx: Ctx) (sep: WExpr) (items: WExpr) : WExpr =
    let helper =
        match exprWType items with
        | WType.Ref(idx, _) when idx = ListBaseTypeIdx -> "$strJoinList"
        | _ -> "$strJoin"
    WExpr.Call(ctx.UseHelper helper, [ sep; items ], WType.Ref(StringTypeIdx, false))

/// `string (x: int64)` / `%d` of an int64 — the whole 64 bits (a 32-bit conversion truncated them).
let int64ToString (ctx: Ctx) (x: WExpr) (unsigned: bool) : WExpr =
    WExpr.Call(ctx.UseHelper "$int64ToStr", [ x; WExpr.Const(WConst.I32(if unsigned then 1 else 0)) ], WType.Ref(StringTypeIdx, false))

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
    let is32 () = WExpr.Const(WConst.I32(if exprWType wv = WType.F32 then 1 else 0))
    let promote () =
        match exprWType wv with
        | WType.F64 -> wv
        | WType.F32 -> WExpr.Unary(WUnaryOp.PromoteF32, wv, WType.F64)
        | _ -> WExpr.Unary(WUnaryOp.ConvertI32S, wv, WType.F64)
    match spec.Conv with
    | 'f' | 'F' ->
        WExpr.Call(ctx.UseHelper "$floatToFixed", [ promote (); WExpr.Const(WConst.I32(defaultArg spec.Precision 6)) ], strRef)
    | 'g' | 'e' -> WExpr.Call(ctx.UseHelper "$floatToStr", [ promote (); is32 () ], strRef)
    | 'b' -> WExpr.If(wv, lit "true", lit "false", strRef)
    | 'c' -> charToString wv
    // %x %X %o: the two's-complement bits of a 32-bit integer
    | ('x' | 'X' | 'o') when exprWType wv = WType.I32 ->
        let bits, upper = (match spec.Conv with 'o' -> 3, 0 | 'X' -> 4, 1 | _ -> 4, 0)
        WExpr.Call(ctx.UseHelper "$uintToRadix", [ wv; WExpr.Const(WConst.I32 bits); WExpr.Const(WConst.I32 upper) ], strRef)
    | 'u' when exprWType wv = WType.I32 -> WExpr.Call(ctx.UseHelper "$uintToStr", [ wv ], strRef)
    | _ ->
        match exprWType wv with
        | WType.Ref(idx, _) when idx = StringTypeIdx -> wv
        | WType.I64 ->
            WExpr.Call(ctx.UseHelper "$int64ToStr", [ wv; WExpr.Const(WConst.I32(if unsigned then 1 else 0)) ], strRef)
        | WType.F64 | WType.F32 -> WExpr.Call(ctx.UseHelper "$floatToStr", [ promote (); is32 () ], strRef)
        | WType.Ref _ ->
            // a record / union / tuple / list under %A or %O: structured printing (with F#'s 80-column layout) is not implemented
            WasmGc.Core.Diagnostics.unsupported ctx.Diagnostics
                (sprintf "printf '%%%c' of a structured value" spec.Conv)
                "Print the fields yourself, or convert the value to a string first."
            lit "?"
        | _ -> WExpr.Call(ctx.UseHelper(if unsigned then "$uintToStr" else "$intToStr"), [ wv ], strRef)

/// A printf field: the converted value, then sign flags and padding to the width (`$fmtPad`).
let formatField (ctx: Ctx) (spec: FormatSpec) (unsigned: bool) (wv: WExpr) : WExpr =
    let s = formatHole ctx spec unsigned wv
    if spec.Width = 0 && spec.Flags &&& 12 = 0 then s
    else
        let numeric = match spec.Conv with 's' | 'c' | 'b' | 'A' | 'O' -> 0 | _ -> 16
        WExpr.Call(ctx.UseHelper "$fmtPad", [ s; WExpr.Const(WConst.I32 spec.Width); WExpr.Const(WConst.I32(spec.Flags ||| numeric)) ], WType.Ref(StringTypeIdx, false))

/// `string x` / `x.ToString()` / `String(x)` for a primitive: the text .NET gives (floats approximated, see `$floatToStr`).
let primitiveToString (ctx: Ctx) (fableType: Fable.AST.Fable.Type) (wv: WExpr) : WExpr =
    let strRef = WType.Ref(StringTypeIdx, false)
    let lit (s: string) =
        WExpr.ArrayNewFixed(StringTypeIdx, s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList, strRef)
    match fableType, exprWType wv with
    | Fable.AST.Fable.Type.Char, _ -> charToString wv
    | Fable.AST.Fable.Type.Boolean, _ -> WExpr.If(wv, lit "True", lit "False", strRef)
    | _, WType.Ref(idx, _) when idx = StringTypeIdx -> wv
    | _, WType.Ref(idx, _) when idx = StringBuilderTypeIdx -> WExpr.Call(ctx.UseHelper "$sbToString", [ wv ], strRef)
    | _, WType.I64 -> int64ToString ctx wv (WasmGc.Util.FableQuery.isUnsignedInt fableType)
    | _, WType.F64 -> WExpr.Call(ctx.UseHelper "$floatToStr", [ wv; WExpr.Const(WConst.I32 0) ], strRef)
    | _, WType.F32 -> WExpr.Call(ctx.UseHelper "$floatToStr", [ WExpr.Unary(WUnaryOp.PromoteF32, wv, WType.F64); WExpr.Const(WConst.I32 1) ], strRef)
    | _ -> WExpr.Call(ctx.UseHelper(if WasmGc.Util.FableQuery.isUnsignedInt fableType then "$uintToStr" else "$intToStr"), [ wv ], strRef)
