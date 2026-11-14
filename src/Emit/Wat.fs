/// WasmGC WAT (WebAssembly Text Format) emitter.
/// Converts WModule (high-level WasmIR) directly to human-readable .wat text.
///
/// Design: operates on WModule (not WasmModule), so all names (funcs, types, locals)
/// are preserved as-is. No index resolution needed — WAT uses named identifiers.
///
/// Output style: unfolded instruction-per-line format (valid WAT, easy to generate,
/// easy to validate with wasm-tools / wat2wasm).
module WasmGc.Emit.Wat

open System.Text
open WasmGc.Core.AST
open WasmGc.Runtime.Types


// ─────────────────────────────────────────────────────────────────
// WAT identifier helpers
// ─────────────────────────────────────────────────────────────────

/// Ensure a name has the WAT $ prefix and sanitize to valid WAT idchars.
/// WAT identifiers (idchar) do NOT allow: ' ' , ; ( ) [ ] { } " = ...
/// We replace: ',' → '~', ' '/'|'/'.'→ '_', ';'/'('/')' → '_'.
/// This is applied consistently at both definition and use sites.
let private watId (name: string) =
    let base' = if name.StartsWith("$") then name else "$" + name
    // Check for any invalid WAT id character
    if base'.IndexOfAny([|','; ' '; '|'; '.'; ';'; '('; ')'; '['; ']'; '{'; '}'|]) >= 0 then
        base'.Replace(',', '~').Replace(' ', '_').Replace('|', '_')
             .Replace('.', '_').Replace(';', '_')
             .Replace('(', '_').Replace(')', '_')
             .Replace('[', '_').Replace(']', '_')
             .Replace('{', '_').Replace('}', '_')
    else base'

/// Strip the $ prefix for use in export/import string names.
let private stripDollar (name: string) =
    if name.StartsWith("$") then name.[1..] else name

// ─────────────────────────────────────────────────────────────────
// Type name map
// ─────────────────────────────────────────────────────────────────

/// Build a map from type index → WAT name (for resolving Ref(idx,..) in instructions).
let buildTypeNames (typeDefs: WTypeDeclEntry list) : Map<int, string> =
    typeDefs
    |> List.mapi (fun i td -> (i, td.Name))
    |> Map.ofList

/// Build a map from type index → array element WType.
/// Used to determine whether to emit array.get vs. array.get_s (for packed i16 types).
let buildArrayElemTypes (typeDefs: WTypeDeclEntry list) : Map<int, WType> =
    typeDefs
    |> List.mapi (fun i td ->
        match td.Def with
        | WTypeDef.Array(elemType, _) -> Some (i, elemType)
        | _ -> None)
    |> List.choose id
    |> Map.ofList

// ─────────────────────────────────────────────────────────────────
// WType → WAT text
// ─────────────────────────────────────────────────────────────────

let rec private wtypeToStr (typeNames: Map<int, string>) (ty: WType) : string =
    match ty with
    | WType.I32 -> "i32"
    | WType.I64 -> "i64"
    | WType.F32 -> "f32"
    | WType.F64 -> "f64"
    | WType.I16 -> "i16"  // packed type — only valid inside array type defs
    | WType.I8 -> "i8"    // packed type — only valid inside array type defs
    | WType.Ref(idx, false) ->
        let name = typeNames |> Map.tryFind idx |> Option.defaultValue (sprintf "%d" idx)
        sprintf "(ref %s)" (watId name)
    | WType.Ref(idx, true) ->
        let name = typeNames |> Map.tryFind idx |> Option.defaultValue (sprintf "%d" idx)
        sprintf "(ref null %s)" (watId name)
    | WType.Void -> ""
    | WType.Externref -> "externref"
    | WType.ExternNonNull -> "(ref extern)"
    | WType.I31ref -> "(ref i31)"
    | WType.EqRef -> "(ref eq)"
    | WType.AnyRef -> "anyref"
    | WType.Func _ -> "(ref func)"
    | WType.Struct _ -> "(ref struct)"
    | WType.Array _ -> "(ref array)"

/// Emit result clause: "(result i32)" or "" for void.
let private resultClause (typeNames: Map<int, string>) (ty: WType) =
    match ty with
    | WType.Void -> ""
    | t -> sprintf " (result %s)" (wtypeToStr typeNames t)

/// Emit param clause without name: "(param i32)".
let private paramClause (typeNames: Map<int, string>) (ty: WType) =
    sprintf "(param %s)" (wtypeToStr typeNames ty)

// ─────────────────────────────────────────────────────────────────
// WTypeDef → WAT type declaration
// ─────────────────────────────────────────────────────────────────

let private typeDefToWat (typeNames: Map<int, string>) (entry: WTypeDeclEntry) : string =
    let name = watId entry.Name
    match entry.Def with
    | WTypeDef.Struct(fields, superType) ->
        let superStr =
            match superType with
            | None -> ""
            | Some superIdx ->
                let sn = typeNames |> Map.tryFind superIdx |> Option.defaultValue (sprintf "%d" superIdx)
                sprintf " %s" (watId sn)
        let fieldStrs =
            fields |> List.map (fun f ->
                let mutPre = if f.Mutable then "(mut " else ""
                let mutSuf = if f.Mutable then ")" else ""
                let tyStr  = wtypeToStr typeNames f.Type
                sprintf "(field %s%s%s)" mutPre tyStr mutSuf
            )
        let fieldsStr = if fieldStrs.IsEmpty then "" else " " + String.concat " " fieldStrs
        sprintf "  (type %s (sub%s (struct%s)))" name superStr fieldsStr
    | WTypeDef.Array(elem, mutable_) ->
        let elemStr = wtypeToStr typeNames elem
        if mutable_ then
            sprintf "  (type %s (array (mut %s)))" name elemStr
        else
            sprintf "  (type %s (array %s))" name elemStr
    | WTypeDef.Func(parms, result) ->
        let pStrs =
            parms
            |> List.filter (fun t -> t <> WType.Void)
            |> List.map (wtypeToStr typeNames)
            |> List.map (sprintf "(param %s)")
            |> String.concat " "
        let rStr =
            match result with
            | WType.Void -> ""
            | t -> sprintf " (result %s)" (wtypeToStr typeNames t)
        let ps = if pStrs = "" then "" else " " + pStrs
        sprintf "  (type %s (func%s%s))" name ps rStr

// ─────────────────────────────────────────────────────────────────
// WImport → WAT import declaration
// ─────────────────────────────────────────────────────────────────

let private importToWat (typeNames: Map<int, string>) (imp: WImport) : string =
    // funcId = WAT internal identifier; Name = external name in the import declaration.
    let internalId = if imp.CallName <> "" then imp.CallName else imp.Name
    let funcId = watId internalId
    match imp.Desc with
    | ImportFunc(parms, result) ->
        let pStrs =
            parms
            |> List.filter (fun t -> t <> WType.Void)
            |> List.map (wtypeToStr typeNames)
            |> List.map (sprintf "(param %s)")
            |> String.concat " "
        let rStr =
            match result with
            | WType.Void -> ""
            | t -> sprintf " (result %s)" (wtypeToStr typeNames t)
        let ps = if pStrs = "" then "" else " " + pStrs
        sprintf "  (import \"%s\" \"%s\" (func %s%s%s))" imp.ModuleName imp.Name funcId ps rStr
    | ImportGlobal(ty, mutable_) ->
        let mutStr = if mutable_ then "(mut " else ""
        let mutClose = if mutable_ then ")" else ""
        sprintf "  (import \"%s\" \"%s\" (global %s %s%s%s))"
            imp.ModuleName imp.Name funcId mutStr (wtypeToStr typeNames ty) mutClose
    | ImportMemory(min, max) ->
        let maxStr = match max with | Some m -> sprintf " %d" m | None -> ""
        sprintf "  (import \"%s\" \"%s\" (memory %d%s))" imp.ModuleName imp.Name min maxStr
    | ImportTag parms ->
        let pStrs =
            parms
            |> List.filter (fun t -> t <> WType.Void)
            |> List.map (wtypeToStr typeNames)
            |> List.map (sprintf "(param %s)")
            |> String.concat " "
        let ps = if pStrs = "" then "" else " " + pStrs
        sprintf "  (import \"%s\" \"%s\" (tag %s%s))" imp.ModuleName imp.Name funcId ps

// ─────────────────────────────────────────────────────────────────
// Determine result type of WExpr (mirror of Emit.exprResultType)
// ─────────────────────────────────────────────────────────────────

let rec private exprType (expr: WExpr) : WType =
    match expr with
    | WExpr.Const(WConst.I32 _)  -> WType.I32
    | WExpr.Const(WConst.I64 _)  -> WType.I64
    | WExpr.Const(WConst.F32 _)  -> WType.F32
    | WExpr.Const(WConst.F64 _)  -> WType.F64
    | WExpr.Const(WConst.Unit)   -> WType.Void
    | WExpr.Const(WConst.String _) -> WType.I32
    | WExpr.Const(WConst.Null t) -> t
    | WExpr.LocalGet(_, t)       -> t
    | WExpr.GlobalGet(_, t)      -> t
    | WExpr.GlobalSet _          -> WType.Void
    | WExpr.Let(_, _, body)      -> exprType body
    | WExpr.LetMut(_, _, body)   -> exprType body
    | WExpr.Assign _             -> WType.Void
    | WExpr.Call(_, _, t)        -> t
    | WExpr.CallIndirect(_, _, t)-> t
    | WExpr.CallVirtual(_, _, _, _, _, _, t) -> t
    | WExpr.CallRef (_, _, _, t) -> t
    | WExpr.ReturnCallRef (_, _, _, t) -> t
    | WExpr.FuncRef _            -> WType.Ref(0, false)
    | WExpr.StructNew(_, _, t)   -> t
    | WExpr.StructGet(_, _, t)   -> t
    | WExpr.StructSet _          -> WType.Void
    | WExpr.ArrayNew(_, _, _, t) -> t
    | WExpr.ArrayNewFixed(_, _, t) -> t
    | WExpr.ArrayGet(_, _, t)    -> t
    | WExpr.ArraySet _           -> WType.Void
    | WExpr.ArrayLen _           -> WType.I32
    | WExpr.ArrayCopy _          -> WType.Void
    | WExpr.If(_, _, _, t)       -> t
    | WExpr.Loop(_, _, t)        -> t
    | WExpr.Block(_, _, t)       -> t
    | WExpr.Break _              -> WType.Void
    | WExpr.Continue _           -> WType.Void
    | WExpr.Return _             -> WType.Void
    | WExpr.Sequence exprs ->
        match exprs with
        | [] -> WType.Void
        | _  -> exprType (List.last exprs)
    | WExpr.Nop                  -> WType.Void
    | WExpr.JoinPoint(_, _, _, _, t) -> t
    | WExpr.JoinApply(_, _, t)   -> t
    | WExpr.SwitchInt(_, _, _, t) -> t
    | WExpr.TagOf _              -> WType.I32
    | WExpr.Cast(_, t)           -> t
    | WExpr.RefIsNull _          -> WType.I32
    | WExpr.RefTest _            -> WType.I32
    | WExpr.Closure(_, _, t)     -> t
    | WExpr.ClosureApply(_, _, _, _, _, t) -> t
    | WExpr.TailCall(_, _, t)    -> t
    | WExpr.TailCallRef(_, _, _, _, _, t) -> t
    | WExpr.Unary(_, _, t)       -> t
    | WExpr.Binary(_, _, _, t)   -> t
    | WExpr.Compare _            -> WType.I32
    | WExpr.TryCatch(_, _, _, t) -> t
    | WExpr.Throw _              -> WType.Void
    // Linear memory
    | WExpr.MemLoad(WMemKind.Byte, _, _)
    | WExpr.MemLoad(WMemKind.I32, _, _)  -> WType.I32
    | WExpr.MemLoad(WMemKind.I64, _, _)  -> WType.I64
    | WExpr.MemLoad(WMemKind.F32, _, _)  -> WType.F32
    | WExpr.MemLoad(WMemKind.F64, _, _)  -> WType.F64
    | WExpr.MemStore _   -> WType.Void
    | WExpr.MemorySize   -> WType.I32
    | WExpr.MemoryGrow _ -> WType.I32

// ─────────────────────────────────────────────────────────────────
// Unary/Binary/Compare → WAT mnemonic strings
// ─────────────────────────────────────────────────────────────────

let private unaryMnemonic (op: WUnaryOp) (ty: WType) : string list =
    match op, ty with
    | WUnaryOp.Neg, WType.I32 -> ["i32.const 0"; "i32.sub"]   // special: 0 - x
    | WUnaryOp.Neg, WType.I64 -> ["i64.const 0"; "i64.sub"]
    | WUnaryOp.Neg, WType.F32 -> ["f32.neg"]
    | WUnaryOp.Neg, WType.F64 -> ["f64.neg"]
    | WUnaryOp.Abs, WType.F32 -> ["f32.abs"]
    | WUnaryOp.Abs, WType.F64 -> ["f64.abs"]
    | WUnaryOp.Sqrt, WType.F32 -> ["f32.sqrt"]
    | WUnaryOp.Sqrt, WType.F64 -> ["f64.sqrt"]
    | WUnaryOp.Ceil, WType.F32 -> ["f32.ceil"]
    | WUnaryOp.Ceil, WType.F64 -> ["f64.ceil"]
    | WUnaryOp.Floor, WType.F32 -> ["f32.floor"]
    | WUnaryOp.Floor, WType.F64 -> ["f64.floor"]
    | WUnaryOp.Trunc, WType.F32 -> ["f32.trunc"]
    | WUnaryOp.Trunc, WType.F64 -> ["f64.trunc"]
    | WUnaryOp.Nearest, WType.F32 -> ["f32.nearest"]
    | WUnaryOp.Nearest, WType.F64 -> ["f64.nearest"]
    | WUnaryOp.Not, WType.I32 -> ["i32.const -1"; "i32.xor"]
    | WUnaryOp.Not, WType.I64 -> ["i64.const -1"; "i64.xor"]
    | WUnaryOp.Eqz, WType.I32 -> ["i32.eqz"]
    | WUnaryOp.Eqz, WType.I64 -> ["i64.eqz"]
    | WUnaryOp.Clz, WType.I32 -> ["i32.clz"]
    | WUnaryOp.Ctz, WType.I32 -> ["i32.ctz"]
    | WUnaryOp.Popcnt, WType.I32 -> ["i32.popcnt"]
    | WUnaryOp.WrapI64, _ -> ["i32.wrap_i64"]
    | WUnaryOp.ExtendI32S, _ -> ["i64.extend_i32_s"]
    | WUnaryOp.ExtendI32U, _ -> ["i64.extend_i32_u"]
    | WUnaryOp.TruncF64S, WType.I32 -> ["i32.trunc_f64_s"]
    | WUnaryOp.TruncF64S, WType.I64 -> ["i64.trunc_f64_s"]
    | WUnaryOp.TruncF32S, WType.I32 -> ["i32.trunc_f32_s"]
    | WUnaryOp.TruncF32S, WType.I64 -> ["i64.trunc_f32_s"]
    | WUnaryOp.TruncSatF64S, WType.I32 -> ["i32.trunc_sat_f64_s"]
    | WUnaryOp.TruncSatF64S, WType.I64 -> ["i64.trunc_sat_f64_s"]
    | WUnaryOp.TruncSatF32S, WType.I32 -> ["i32.trunc_sat_f32_s"]
    | WUnaryOp.TruncSatF32S, WType.I64 -> ["i64.trunc_sat_f32_s"]
    | WUnaryOp.ConvertI32S, WType.F64 -> ["f64.convert_i32_s"]
    | WUnaryOp.ConvertI32S, WType.F32 -> ["f32.convert_i32_s"]
    | WUnaryOp.ConvertI64S, WType.F64 -> ["f64.convert_i64_s"]
    | WUnaryOp.ConvertI64S, WType.F32 -> ["f32.convert_i64_s"]
    | WUnaryOp.PromoteF32, _ -> ["f64.promote_f32"]
    | WUnaryOp.DemoteF64, _ -> ["f32.demote_f64"]
    | WUnaryOp.ReinterpretI32ToF32, _ -> ["f32.reinterpret_i32"]
    | WUnaryOp.ReinterpretF32ToI32, _ -> ["i32.reinterpret_f32"]
    | WUnaryOp.ReinterpretI64ToF64, _ -> ["f64.reinterpret_i64"]
    | WUnaryOp.ReinterpretF64ToI64, _ -> ["i64.reinterpret_f64"]
    | _ -> ["unreachable"]

let private binaryMnemonic (op: WBinaryOp) (ty: WType) : string =
    match op, ty with
    | WBinaryOp.Add,  WType.I32 -> "i32.add"
    | WBinaryOp.Sub,  WType.I32 -> "i32.sub"
    | WBinaryOp.Mul,  WType.I32 -> "i32.mul"
    | WBinaryOp.DivS, WType.I32 -> "i32.div_s"
    | WBinaryOp.DivU, WType.I32 -> "i32.div_u"
    | WBinaryOp.RemS, WType.I32 -> "i32.rem_s"
    | WBinaryOp.RemU, WType.I32 -> "i32.rem_u"
    | WBinaryOp.And,  WType.I32 -> "i32.and"
    | WBinaryOp.Or,   WType.I32 -> "i32.or"
    | WBinaryOp.Xor,  WType.I32 -> "i32.xor"
    | WBinaryOp.Shl,  WType.I32 -> "i32.shl"
    | WBinaryOp.ShrS, WType.I32 -> "i32.shr_s"
    | WBinaryOp.ShrU, WType.I32 -> "i32.shr_u"
    | WBinaryOp.Rotl, WType.I32 -> "i32.rotl"
    | WBinaryOp.Rotr, WType.I32 -> "i32.rotr"
    | WBinaryOp.Add,  WType.I64 -> "i64.add"
    | WBinaryOp.Sub,  WType.I64 -> "i64.sub"
    | WBinaryOp.Mul,  WType.I64 -> "i64.mul"
    | WBinaryOp.DivS, WType.I64 -> "i64.div_s"
    | WBinaryOp.DivU, WType.I64 -> "i64.div_u"
    | WBinaryOp.RemS, WType.I64 -> "i64.rem_s"
    | WBinaryOp.RemU, WType.I64 -> "i64.rem_u"
    | WBinaryOp.And,  WType.I64 -> "i64.and"
    | WBinaryOp.Or,   WType.I64 -> "i64.or"
    | WBinaryOp.Xor,  WType.I64 -> "i64.xor"
    | WBinaryOp.Shl,  WType.I64 -> "i64.shl"
    | WBinaryOp.ShrS, WType.I64 -> "i64.shr_s"
    | WBinaryOp.ShrU, WType.I64 -> "i64.shr_u"
    | WBinaryOp.Rotl, WType.I64 -> "i64.rotl"
    | WBinaryOp.Rotr, WType.I64 -> "i64.rotr"
    | WBinaryOp.Add,  WType.F32 -> "f32.add"
    | WBinaryOp.Sub,  WType.F32 -> "f32.sub"
    | WBinaryOp.Mul,  WType.F32 -> "f32.mul"
    | WBinaryOp.DivS, WType.F32 -> "f32.div"
    | WBinaryOp.DivU, WType.F32 -> "f32.div"
    | WBinaryOp.Min,  WType.F32 -> "f32.min"
    | WBinaryOp.Max,  WType.F32 -> "f32.max"
    | WBinaryOp.CopySign, WType.F32 -> "f32.copysign"
    | WBinaryOp.Add,  WType.F64 -> "f64.add"
    | WBinaryOp.Sub,  WType.F64 -> "f64.sub"
    | WBinaryOp.Mul,  WType.F64 -> "f64.mul"
    | WBinaryOp.DivS, WType.F64 -> "f64.div"
    | WBinaryOp.DivU, WType.F64 -> "f64.div"
    | WBinaryOp.Min,  WType.F64 -> "f64.min"
    | WBinaryOp.Max,  WType.F64 -> "f64.max"
    | WBinaryOp.CopySign, WType.F64 -> "f64.copysign"
    | _ -> "unreachable"

let private compareMnemonic (op: WCompareOp) (ty: WType) : string =
    match op, ty with
    | WCompareOp.Eq,  WType.I32 -> "i32.eq"
    | WCompareOp.Ne,  WType.I32 -> "i32.ne"
    | WCompareOp.LtS, WType.I32 -> "i32.lt_s"
    | WCompareOp.LtU, WType.I32 -> "i32.lt_u"
    | WCompareOp.GtS, WType.I32 -> "i32.gt_s"
    | WCompareOp.GtU, WType.I32 -> "i32.gt_u"
    | WCompareOp.LeS, WType.I32 -> "i32.le_s"
    | WCompareOp.LeU, WType.I32 -> "i32.le_u"
    | WCompareOp.GeS, WType.I32 -> "i32.ge_s"
    | WCompareOp.GeU, WType.I32 -> "i32.ge_u"
    | WCompareOp.Eq,  WType.I64 -> "i64.eq"
    | WCompareOp.Ne,  WType.I64 -> "i64.ne"
    | WCompareOp.LtU, WType.I64 -> "i64.lt_u"
    | WCompareOp.GtU, WType.I64 -> "i64.gt_u"
    | WCompareOp.LeU, WType.I64 -> "i64.le_u"
    | WCompareOp.GeU, WType.I64 -> "i64.ge_u"
    | WCompareOp.LtS, WType.I64 -> "i64.lt_s"
    | WCompareOp.GtS, WType.I64 -> "i64.gt_s"
    | WCompareOp.LeS, WType.I64 -> "i64.le_s"
    | WCompareOp.GeS, WType.I64 -> "i64.ge_s"
    | WCompareOp.Eq,  WType.F32 -> "f32.eq"
    | WCompareOp.Ne,  WType.F32 -> "f32.ne"
    | WCompareOp.LtS, WType.F32 -> "f32.lt"
    | WCompareOp.GtS, WType.F32 -> "f32.gt"
    | WCompareOp.LeS, WType.F32 -> "f32.le"
    | WCompareOp.GeS, WType.F32 -> "f32.ge"
    | WCompareOp.Eq,  WType.F64 -> "f64.eq"
    | WCompareOp.Ne,  WType.F64 -> "f64.ne"
    | WCompareOp.LtS, WType.F64 -> "f64.lt"
    | WCompareOp.GtS, WType.F64 -> "f64.gt"
    | WCompareOp.LeS, WType.F64 -> "f64.le"
    | WCompareOp.GeS, WType.F64 -> "f64.ge"
    | WCompareOp.RefEq, _ -> "ref.eq"
    | WCompareOp.Eq,  WType.Ref _ -> "ref.eq"
    | WCompareOp.Ne,  WType.Ref _ -> "ref.eq"   // will need i32.eqz after
    | _ -> failwithf "Wat: no instruction for comparison %A on %A" op ty

// ─────────────────────────────────────────────────────────────────
// WExpr → flat list of WAT instruction strings
// ─────────────────────────────────────────────────────────────────

/// WAT float literal.  F# prints NaN/Infinity, WAT wants `nan` / `inf` / `-inf`.
let private watFloat (formatted: string) (v: float) : string =
    if System.Double.IsNaN v then "nan"
    elif System.Double.IsPositiveInfinity v then "inf"
    elif System.Double.IsNegativeInfinity v then "-inf"
    else formatted

/// Parameters of the join points currently being emitted (label → parameter locals).
/// Scoped: set while the join point's continuation is emitted, restored afterwards.
let private joinParams = System.Collections.Generic.Dictionary<string, (string * WType) list>()

/// Determines one level of indentation string.
let private ind (depth: int) = System.String(' ', depth * 2)

/// Emit WAT instructions for a WExpr into the string buffer.
/// `depth` controls indentation; `sb` is the output buffer.
let rec private emitExpr (typeNames: Map<int, string>) (arrayElemTypes: Map<int, WType>) (depth: int) (sb: StringBuilder) (expr: WExpr) : unit =
    let w (line: string) = sb.AppendLine(ind depth + line) |> ignore
    let emit e = emitExpr typeNames arrayElemTypes depth sb e
    let emitD d e = emitExpr typeNames arrayElemTypes d sb e

    match expr with
    // ── Constants ──────────────────────────────────────────
    | WExpr.Const(WConst.I32 n) -> w $"i32.const {n}"
    | WExpr.Const(WConst.I64 n) -> w $"i64.const {n}"
    | WExpr.Const(WConst.F32 f) ->
        let lit = watFloat (sprintf "%.9g" (float f)) (float f)
        w $"f32.const {lit}"
    | WExpr.Const(WConst.F64 f) ->
        let lit = watFloat (sprintf "%.17g" f) f
        w $"f64.const {lit}"
    | WExpr.Const(WConst.Null(WType.Ref(idx, _))) ->
        let name = typeNames |> Map.tryFind idx |> Option.defaultValue (sprintf "%d" idx)
        w $"ref.null {watId name}"
    | WExpr.Const(WConst.Null WType.AnyRef) -> w "ref.null any"
    | WExpr.Const(WConst.Null WType.Externref) -> w "ref.null extern"
    | WExpr.Const(WConst.Null WType.EqRef) -> w "ref.null eq"
    | WExpr.Const(WConst.Null WType.I31ref) -> w "ref.null i31"
    | WExpr.Const(WConst.Null _) -> w "ref.null none"
    | WExpr.Const(WConst.Unit) -> ()   // unit produces nothing
    | WExpr.Const(WConst.String _) -> w "i32.const 0" // shouldn't appear post-translation

    // ── Local / global access ─────────────────────────────
    | WExpr.LocalGet(name, _) -> w $"local.get {watId name}"
    | WExpr.GlobalGet(name, _) -> w $"global.get {watId name}"
    | WExpr.GlobalSet(name, value) ->
        emit value
        w $"global.set {watId name}"

    // ── Let binding (A-normal form) ───────────────────────
    | WExpr.Let(name, value, body) | WExpr.LetMut(name, value, body) ->
        // Handle i32 negation specially: needs "i32.const 0" before operand
        match value with
        | WExpr.Unary(WUnaryOp.Neg, operand, WType.I32) ->
            w "i32.const 0"
            emit operand
            w "i32.sub"
            w $"local.set {watId name}"
        | WExpr.Unary(WUnaryOp.Neg, operand, WType.I64) ->
            w "i64.const 0"
            emit operand
            w "i64.sub"
            w $"local.set {watId name}"
        | _ when exprWType value = WType.Void ->
            // `value` produced NO stack output (Nop, or any expr whose
            // exprWType is Void). Emitting `local.set` here would pop from
            // an empty stack and invalidate the entire function — this is
            // the func-39 "expected i32 but nothing on stack" failure.
            //
            // This always indicates an unhandled Fable expression upstream
            // (see Diagnostics WGC008, emitted by transformExpr). Skip the
            // assignment: numeric locals default to 0, nullable ref locals
            // default to null. The local keeps its default value instead of
            // corrupting the function's stack balance.
            eprintfn $"[WasmGc] WARNING: binding '%s{name}' produced no value (Nop) \
                       — skipping local.set. See WGC008 for the unhandled expression."
        | _ ->
            emit value
            w $"local.set {watId name}"
        emit body

    // ── Assignment ────────────────────────────────────────
    | WExpr.Assign(name, value) ->
        emit value
        w $"local.set {watId name}"

    // ── Function calls ────────────────────────────────────
    | WExpr.Call(func, args, _) ->
        for a in args do emit a
        w $"call {watId func}"

    | WExpr.TailCall(func, args, _) ->
        for a in args do emit a
        w $"return_call {watId func}"

    | WExpr.CallIndirect(funcRef, args, _) ->
        // Lower.fs should have converted CallIndirect → CallRef before emit.
        // If we reach here, fall back to inferring the functype from the ref type of funcRef.
        let ftName =
            match exprWType funcRef with
            | WType.Ref(idx, _) ->
                typeNames |> Map.tryFind idx |> Option.defaultValue $"type{idx}"
            | _ -> "0"  // unknown — WAT will reject at validation; signals a compiler bug
        for a in args do emit a
        emitD depth funcRef
        w $"call_ref {watId ftName}"

    | WExpr.CallVirtual(box, boxTypeIdx, vtableTypeIdx, methodIdx, funcTypeIdx, args, _) ->
        // Vtable dispatch — correct call_ref stack order: [self, args..., funcref]
        // box is always a LocalGet in practice, so emitting it twice is safe.
        //   box struct.get $box 1          → self (eqref, first arg)
        //   args...
        //   box struct.get $box 0          → vtable ref
        //   struct.get $vtable N           → funcref (must be on top for call_ref)
        //   call_ref $func_type
        let boxName    = typeNames |> Map.tryFind boxTypeIdx    |> Option.defaultValue (string boxTypeIdx)
        let vtableName = typeNames |> Map.tryFind vtableTypeIdx |> Option.defaultValue (string vtableTypeIdx)
        let ftName     = typeNames |> Map.tryFind funcTypeIdx   |> Option.defaultValue (string funcTypeIdx)
        emit box
        w $"struct.get {watId boxName} 1"    // self (eqref) — first arg
        for a in args do emit a
        emit box
        w $"struct.get {watId boxName} 0"    // vtable
        w $"struct.get {watId vtableName} {methodIdx}"  // funcref on top
        w $"call_ref {watId ftName}"

    /// ref.func $funcName — create a typed funcref for vtable global init.
    | WExpr.FuncRef funcName ->
        w $"ref.func {watId funcName}"

    // ── Struct operations ─────────────────────────────────
    | WExpr.StructNew(typeIdx, fields, _) ->
        for f in fields do emit f
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        w $"struct.new {watId name}"

    | WExpr.StructGet(obj, fieldIdx, _) ->
        emit obj
        let typeIdx = match exprType obj with | WType.Ref(idx, _) -> idx | _ -> 0
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        w $"struct.get {watId name} {fieldIdx}"

    | WExpr.StructSet(obj, fieldIdx, value) ->
        emit obj
        emit value
        let typeIdx = match exprType obj with | WType.Ref(idx, _) -> idx | _ -> 0
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        w $"struct.set {watId name} {fieldIdx}"

    // ── Array operations ──────────────────────────────────
    | WExpr.ArrayNew(typeIdx, size, init, _) ->
        emit init
        emit size
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        w $"array.new {watId name}"

    | WExpr.ArrayNewFixed(typeIdx, elems, _) ->
        for e in elems do emit e
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        w $"array.new_fixed {watId name} {List.length elems}"

    | WExpr.ArrayGet(arr, idx, _) ->
        emit arr
        emit idx
        let typeIdx = match exprType arr with | WType.Ref(ti, _) -> ti | _ -> 0
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        // Use array.get_s for packed i16 arrays (sign-extends to i32).
        let instr =
            match Map.tryFind typeIdx arrayElemTypes with
            | Some WType.I16 -> "array.get_s"
            | Some WType.I8  -> "array.get_u"
            | _              -> "array.get"
        w $"{instr} {watId name}"

    | WExpr.ArraySet(arr, idx, value) ->
        emit arr
        emit idx
        emit value
        let typeIdx = match exprType arr with | WType.Ref(ti, _) -> ti | _ -> 0
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        w $"array.set {watId name}"

    | WExpr.ArrayLen(arr) ->
        emit arr
        w "array.len"

    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        emit dst
        emit dstOff
        emit src
        emit srcOff
        emit len
        let typeIdx = match exprType dst with | WType.Ref(ti, _) -> ti | _ -> 0
        let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
        w $"array.copy {watId name} {watId name}"

    // ── Control flow ──────────────────────────────────────
    | WExpr.If(cond, then_, else_, ty) ->
        emit cond
        let rStr = resultClause typeNames ty
        w $"if{rStr}"
        emitD (depth + 1) then_
        match else_ with
        | WExpr.Nop -> ()
        | _ ->
            w "else"
            emitD (depth + 1) else_
        w "end"

    | WExpr.Loop(label, body, ty) ->
        let rStr = resultClause typeNames ty
        w $"loop {watId label}{rStr}"
        emitD (depth + 1) body
        w "end"

    | WExpr.Block(label, body, ty) ->
        let rStr = resultClause typeNames ty
        w $"block {watId label}{rStr}"
        emitD (depth + 1) body
        w "end"

    | WExpr.Break(label, value) ->
        match value with
        | Some v -> emit v
        | None -> ()
        w $"br {watId label}"

    | WExpr.Continue(label, _args) ->
        w $"br {watId label}"

    | WExpr.Return(value) ->
        match value with
        | Some v -> emit v
        | None -> ()
        w "return"

    | WExpr.Sequence exprs ->
        match exprs with
        | [] -> ()
        | [single] -> emit single
        | _ ->
            let allButLast = exprs |> List.take (List.length exprs - 1)
            let last = exprs |> List.last
            for e in allButLast do
                emit e
                match exprType e with
                | WType.Void -> ()
                | _ -> w "drop"
            emit last

    | WExpr.Nop -> ()

    // ── Join points ───────────────────────────────────────
    // The optimizer inlines single-use join points; remaining ones
    // are treated like the binary emitter: emit the continuation,
    // which contains JoinApply nodes that have been substituted.
    // Shared decision-tree target used from several leaves:
    //   block $jp_done (result T) / block $jp / <cont> br $jp_done / end / <body> / end
    // JoinApply = evaluate args, store into the parameter locals, `br $jp`.
    // (Previously: only `cont` was emitted and JoinApply pushed its args — the target body
    //  was dropped and the operand stack was left unbalanced.)
    | WExpr.JoinPoint(label, parms, body, cont, ty) ->
        if WasmGc.Core.Traverse.count (function WExpr.JoinApply(l, _, _) when l = label -> true | _ -> false) cont = 0 then
            emit cont
        else
            let rStr = resultClause typeNames ty
            let jp = watId ("jp_" + label)
            let jd = watId ("jp_done_" + label)
            let prev = match joinParams.TryGetValue label with | true, v -> Some v | _ -> None
            joinParams.[label] <- parms
            w $"block {jd}{rStr}"
            w $"  block {jp}"
            emitD (depth + 2) cont
            (match prev with Some v -> joinParams.[label] <- v | None -> joinParams.Remove label |> ignore)
            w $"    br {jd}"
            w "  end"
            emitD (depth + 1) body
            w "end"

    | WExpr.JoinApply(label, args, _ty) ->
        for a in args do emit a
        for (p, a) in List.zip (joinParams.[label] |> List.map fst) args |> List.filter (fun (_, a) -> exprType a <> WType.Void) |> List.rev do
            w $"local.set {watId p}"
        let target = watId ("jp_" + label)
        w $"br {target}"

    // ── Pattern matching (switch) ─────────────────────────
    | WExpr.SwitchInt(scrutinee, cases, default_, ty) ->
        emit scrutinee
        w "local.set $switch_tmp"
        let rStr = resultClause typeNames ty
        let rec buildNested remaining =
            match remaining with
            | [] ->
                emitD depth default_
            | (value, body) :: rest ->
                w $"local.get $switch_tmp"
                w $"i32.const {value}"
                w "i32.eq"
                w $"if{rStr}"
                emitD (depth + 1) body
                w "else"
                buildNested rest
                w "end"
        buildNested cases

    | WExpr.TagOf(obj) ->
        emit obj
        match exprType obj with
        | WType.Ref(typeIdx, _) ->
            let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
            w $"struct.get {watId name} 0"
        | _ -> ()  // i32 enum-like DU tag — pass through

    | WExpr.Cast(obj, targetType) ->
        emit obj
        match targetType with
        // across the host boundary (the Exports string ABI): a GC reference becomes an opaque `externref`, and what the host hands
        // back is internalised again before it is cast to the type the module expects
        | WType.Externref when (match exprType obj with WType.Ref _ -> true | _ -> false) ->
            w "extern.convert_any"
        | WType.Ref(typeIdx, nullable) when (match exprType obj with WType.Externref | WType.ExternNonNull -> true | _ -> false) ->
            let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
            w "any.convert_extern"
            if nullable then
                w $"ref.cast (ref null {watId name})"
            else
                w $"ref.cast (ref {watId name})"
        | WType.Ref(typeIdx, nullable) ->
            let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
            if nullable then
                w $"ref.cast (ref null {watId name})"
            else
                w $"ref.cast (ref {watId name})"
        | _ -> ()  // non-ref cast: passthrough

    | WExpr.RefIsNull(obj) ->
        emit obj
        w "ref.is_null"

    | WExpr.RefTest(obj, targetType) ->
        emit obj
        match targetType with
        | WType.Ref(typeIdx, nullable) ->
            let name = typeNames |> Map.tryFind typeIdx |> Option.defaultValue (sprintf "%d" typeIdx)
            if nullable then
                w $"ref.test (ref null {watId name})"
            else
                w $"ref.test (ref {watId name})"
        | _ -> w "drop\ni32.const 1"  // non-ref: fallback always-true

    // ── Closures ──────────────────────────────────────────
    | WExpr.Closure(funcName, captures, closureRefType) ->
        let closureTypeIdx =
            match closureRefType with
            | WType.Ref(idx, _) -> idx
            | _ -> 0
        w $"ref.func {watId funcName}"
        for c in captures do emit c
        let name = typeNames |> Map.tryFind closureTypeIdx |> Option.defaultValue (sprintf "%d" closureTypeIdx)
        w $"struct.new {watId name}"

    | WExpr.ClosureApply(closure, args, funcTypeIdx, closureTypeIdx, _captureCount, _) ->
        // Self-parameter convention (Sprint 25b):
        //   cast → save in tmp → push $self → push args → cast again → struct.get code → call_ref
        let ftName  = typeNames |> Map.tryFind funcTypeIdx   |> Option.defaultValue (string funcTypeIdx)
        let cloName = typeNames |> Map.tryFind closureTypeIdx |> Option.defaultValue (string closureTypeIdx)
        emit closure
        if closureTypeIdx > 0 then w $"ref.cast (ref {watId cloName})"
        w "local.tee $clo_apply_tmp"
        w "drop"
        w "local.get $clo_apply_tmp"    // $self (first arg)
        for a in args do emit a
        w "local.get $clo_apply_tmp"
        if closureTypeIdx > 0 then w $"ref.cast (ref {watId cloName})"
        w $"struct.get {watId cloName} 0"
        w $"call_ref {watId ftName}"

    | WExpr.TailCallRef(closure, args, funcTypeIdx, closureTypeIdx, _captureCount, _) ->
        let ftName  = typeNames |> Map.tryFind funcTypeIdx   |> Option.defaultValue (string funcTypeIdx)
        let cloName = typeNames |> Map.tryFind closureTypeIdx |> Option.defaultValue (string closureTypeIdx)
        emit closure
        if closureTypeIdx > 0 then w $"ref.cast (ref {watId cloName})"
        w "local.tee $clo_apply_tmp"
        w "drop"
        w "local.get $clo_apply_tmp"    // $self (first arg)
        for a in args do emit a
        w "local.get $clo_apply_tmp"
        if closureTypeIdx > 0 then w $"ref.cast (ref {watId cloName})"
        w $"struct.get {watId cloName} 0"
        w $"return_call_ref {watId ftName}"

    | WExpr.CallRef(funcTypeIdx, args, codePtr, _) ->
        // LIR node from Lower.fs: args[0]=self, args[1..]=user args, codePtr=struct.get
        let ftName = typeNames |> Map.tryFind funcTypeIdx |> Option.defaultValue (string funcTypeIdx)
        for a in args do emit a
        emitD depth codePtr
        w $"call_ref {watId ftName}"

    | WExpr.ReturnCallRef(funcTypeIdx, args, codePtr, _) ->
        let ftName = typeNames |> Map.tryFind funcTypeIdx |> Option.defaultValue (string funcTypeIdx)
        for a in args do emit a
        emitD depth codePtr
        w $"return_call_ref {watId ftName}"

    // ── Numeric operations ─────────────────────────────────
    | WExpr.Unary(op, operand, ty) ->
        match op, ty with
        | WUnaryOp.Neg, WType.I32 ->
            w "i32.const 0"
            emit operand
            w "i32.sub"
        | WUnaryOp.Neg, WType.I64 ->
            w "i64.const 0"
            emit operand
            w "i64.sub"
        | WUnaryOp.Eqz, _ ->
            emit operand
            w (match exprType operand with WType.I64 -> "i64.eqz" | _ -> "i32.eqz")
        | _ ->
            emit operand
            for m in unaryMnemonic op ty do w m

    | WExpr.Binary(op, left, right, ty) ->
        emit left
        emit right
        w (binaryMnemonic op ty)

    | WExpr.Compare(op, left, right) ->
        let numTy = exprType left
        emit left
        emit right
        let mn = compareMnemonic op numTy
        w mn
        // ref.eq followed by i32.eqz for Ne on refs
        match op, numTy with
        | WCompareOp.Ne, WType.Ref _ -> w "i32.eqz"
        | _ -> ()

    // ── Error handling ────────────────────────────────────
    | WExpr.TryCatch(body, catch_, _finally, ty) ->
        // (block (result T) (block (try_table (result T) (catch_all 0) body) br 1) handler)
        let resultStr =
            match ty with
            | WType.Void -> ""
            | t -> $" (result {wtypeToStr typeNames t})"
        w $"(block{resultStr}"
        w "  (block"
        w $"    (try_table{resultStr} (catch_all 0)"
        emitExpr typeNames arrayElemTypes (depth + 6) sb body
        w "    )"
        w $"    br 1"
        w "  )"
        match catch_ with
        | Some (_, handler) -> emitExpr typeNames arrayElemTypes (depth + 2) sb handler
        | None -> ()
        w ")"

    | WExpr.Throw WExpr.Nop ->
        // Rethrow / payload already stored in $fsharp_exn_carrier by the caller — leave it alone.
        w "throw $fsharp_exn"

    | WExpr.Throw(exnExpr) ->
        // Evaluate the exception expression, store in carrier global, then throw.
        emitExpr typeNames arrayElemTypes depth sb exnExpr
        let exnTy = exprType exnExpr
        if exnTy <> WType.Void then
            w "global.set $fsharp_exn_carrier"
        else
            // Generic/untyped throw (e.g. failwith): clear the carrier so that
            // subsequent `:? T` type tests return false rather than matching stale data.
            w "ref.null any"
            w "global.set $fsharp_exn_carrier"
        w "throw $fsharp_exn"

    // ── Linear memory ─────────────────────────────────────────────────────────
    | WExpr.MemorySize ->
        w "memory.size"

    | WExpr.MemoryGrow pages ->
        emitExpr typeNames arrayElemTypes depth sb pages
        w "memory.grow"

    | WExpr.MemLoad(kind, offset, addr) ->
        emitExpr typeNames arrayElemTypes depth sb addr
        let mnemonic, offStr =
            let o = if offset = 0 then "" else $" offset={offset}"
            match kind with
            | WMemKind.Byte -> "i32.load8_u", o
            | WMemKind.I32  -> "i32.load", o
            | WMemKind.I64  -> "i64.load", o
            | WMemKind.F32  -> "f32.load", o
            | WMemKind.F64  -> "f64.load", o
        w $"{mnemonic}{offStr}"

    | WExpr.MemStore(kind, offset, addr, value) ->
        emitExpr typeNames arrayElemTypes depth sb addr
        emitExpr typeNames arrayElemTypes depth sb value
        let mnemonic, offStr =
            let o = if offset = 0 then "" else $" offset={offset}"
            match kind with
            | WMemKind.Byte -> "i32.store8", o
            | WMemKind.I32  -> "i32.store", o
            | WMemKind.I64  -> "i64.store", o
            | WMemKind.F32  -> "f32.store", o
            | WMemKind.F64  -> "f64.store", o
        w $"{mnemonic}{offStr}"

// ─────────────────────────────────────────────────────────────────
// WFuncDecl → WAT function text
// ─────────────────────────────────────────────────────────────────

let private funcToWat (typeNames: Map<int, string>) (arrayElemTypes: Map<int, WType>) (f: WFuncDecl) : string =
    let sb = StringBuilder()
    let funcId = watId f.Name
    // Build (param $name type) list
    let paramStr =
        f.Params
        |> List.filter (fun (_, ty) -> ty <> WType.Void)
        |> List.map (fun (name, ty) -> sprintf "(param %s %s)" (watId name) (wtypeToStr typeNames ty))
        |> String.concat " "
    let paramStr = if paramStr = "" then "" else " " + paramStr
    // Build (result type) clause
    let resultStr = resultClause typeNames f.Result
    // Build (local $name type) list
    let localStr =
        f.Locals
        |> List.filter (fun (_, ty) -> ty <> WType.Void)
        |> List.map (fun (name, ty) -> sprintf "    (local %s %s)" (watId name) (wtypeToStr typeNames ty))
        |> String.concat "\n"
    let exportStr =
        if f.Exported then sprintf " ;; exported as \"%s\"" f.Name else ""
    sb.AppendLine(sprintf "  (func %s%s%s%s" funcId paramStr resultStr exportStr) |> ignore
    if localStr <> "" then
        sb.AppendLine(localStr) |> ignore
    // Emit function body
    emitExpr typeNames arrayElemTypes 2 sb f.Body
    sb.AppendLine("  )") |> ignore
    sb.ToString()

// ─────────────────────────────────────────────────────────────────
// WGlobalDecl → WAT global declaration
// ─────────────────────────────────────────────────────────────────

let private globalToWat (typeNames: Map<int, string>) (arrayElemTypes: Map<int, WType>) (g: WGlobalDecl) : string =
    let sb = StringBuilder()
    let gid = watId g.Name
    let tyStr = wtypeToStr typeNames g.Type
    let mutStr = if g.Mutable then sprintf "(mut %s)" tyStr else tyStr
    sb.Append($"  (global {gid} {mutStr}") |> ignore
    emitExpr typeNames arrayElemTypes 0 sb g.Init
    sb.Append(")") |> ignore
    sb.ToString()

// ─────────────────────────────────────────────────────────────────
// WExport → WAT export declaration
// ─────────────────────────────────────────────────────────────────

let private exportToWat (exp: WExport) : string =
    match exp.Kind with
    | ExportFunc ->
        sprintf "  (export \"%s\" (func %s))" exp.ExportName (watId exp.InternalName)
    | ExportGlobal ->
        sprintf "  (export \"%s\" (global %s))" exp.ExportName (watId exp.InternalName)
    | ExportMemory ->
        sprintf "  (export \"%s\" (memory 0))" exp.ExportName
    | ExportTag ->
        sprintf "  (export \"%s\" (tag %s))" exp.ExportName (watId exp.InternalName)

// ─────────────────────────────────────────────────────────────────
// WModule → WAT module text
// ─────────────────────────────────────────────────────────────────

/// Collect all function names used with ref.func (i.e., in Closure nodes).
/// In WAT, these must be declared in an (elem declare func ...) segment.
let private collectClosureFuncNames (funcs: WFuncDecl list) : string list =
    let refs = System.Collections.Generic.HashSet<string>()
    let rec scan (expr: WExpr) =
        match expr with
        | WExpr.Closure(funcName, captures, _) ->
            refs.Add(funcName) |> ignore
            for c in captures do scan c
        | WExpr.Let(_, value, body) | WExpr.LetMut(_, value, body) ->
            scan value; scan body
        | WExpr.Assign(_, value) -> scan value
        | WExpr.Sequence exprs -> for e in exprs do scan e
        | WExpr.If(cond, thenE, elseE, _) -> scan cond; scan thenE; scan elseE
        | WExpr.Call(_, args, _) 
        | WExpr.TailCall(_, args, _) 
        | WExpr.CallRef(_, args, _, _) 
        | WExpr.ReturnCallRef(_, args, _, _)-> for a in args do scan a
        | WExpr.CallIndirect(funcRef, args, _) -> scan funcRef; for a in args do scan a
        | WExpr.CallVirtual(obj, _, _, _, _, args, _) -> scan obj; for a in args do scan a
        | WExpr.FuncRef funcName -> refs.Add(funcName) |> ignore
        | WExpr.ClosureApply(clo, args, _, _, _, _) -> scan clo; for a in args do scan a
        | WExpr.TailCallRef(clo, args, _, _, _, _) -> scan clo; for a in args do scan a
        | WExpr.Binary(_, l, r, _) -> scan l; scan r
        | WExpr.Unary(_, e, _) -> scan e
        | WExpr.Compare(_, l, r) -> scan l; scan r
        | WExpr.StructNew(_, fields, _) -> for f in fields do scan f
        | WExpr.StructGet(obj, _, _) -> scan obj
        | WExpr.StructSet(obj, _, value) -> scan obj; scan value
        | WExpr.ArrayNew(_, sz, init, _) -> scan sz; scan init
        | WExpr.ArrayNewFixed(_, elems, _) -> for e in elems do scan e
        | WExpr.ArrayGet(arr, idx, _) -> scan arr; scan idx
        | WExpr.ArraySet(arr, idx, value) -> scan arr; scan idx; scan value
        | WExpr.ArrayLen arr -> scan arr
        | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
            scan dst; scan dstOff; scan src; scan srcOff; scan len
        | WExpr.Cast(e, _) | WExpr.TagOf(e) | WExpr.RefIsNull(e) | WExpr.Throw(e) | WExpr.RefTest(e, _) -> scan e
        | WExpr.Loop(_, body, _) | WExpr.Block(_, body, _) -> scan body
        | WExpr.Break(_, Some e) -> scan e
        | WExpr.Continue(_, args) -> for a in args do scan a
        | WExpr.Return(Some e) -> scan e
        | WExpr.JoinPoint(_, _, body, cont, _) -> scan body; scan cont
        | WExpr.JoinApply(_, args, _) -> for a in args do scan a
        | WExpr.SwitchInt(scrutinee, cases, default_, _) ->
            scan scrutinee
            for (_, e) in cases do scan e
            scan default_
        | WExpr.TryCatch(body, catch_, finally_, _) ->
            scan body
            match catch_ with Some(_, h) -> scan h | None -> ()
            match finally_ with Some f -> scan f | None -> ()
        | WExpr.GlobalSet(_, e) -> scan e
        | WExpr.MemLoad(_, _, addr) -> scan addr
        | WExpr.MemStore(_, _, addr, v) -> scan addr; scan v
        | WExpr.MemoryGrow pages -> scan pages
        | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _ | WExpr.Nop
        | WExpr.Break(_, None) | WExpr.Return None | WExpr.MemorySize -> ()
    for f in funcs do scan f.Body
    refs |> Seq.toList |> List.sortBy id

/// Collect all FuncRef names referenced from global init expressions.
/// These also need (elem declare func ...) to be valid.
let private collectGlobalFuncRefs (globals: WGlobalDecl list) : string list =
    let refs = System.Collections.Generic.HashSet<string>()
    let rec scan (expr: WExpr) =
        match expr with
        | WExpr.FuncRef name -> refs.Add(name) |> ignore
        | WExpr.StructNew(_, fields, _) -> for f in fields do scan f
        | WExpr.Sequence exprs -> for e in exprs do scan e
        | _ -> ()
    for g in globals do scan g.Init
    refs |> Seq.toList |> List.sortBy id

/// Convert a WModule to a WAT text string.
/// This is the primary output function for Sprint 1.
let moduleToWat (wmod: WModule) : string =
    let typeNames     = buildTypeNames wmod.Types
    let arrayElemTypes = buildArrayElemTypes wmod.Types
    let sb = StringBuilder()

    sb.AppendLine("(module") |> ignore

    // ── Type section ──────────────────────────────────────
    if not wmod.Types.IsEmpty then
        sb.AppendLine("  ;; ── Types ───────────────────────────────────────────") |> ignore
        // Forward references (mutually recursive types) need `rec` groups — same grouping as the encoder.
        let typeArr = Array.ofList wmod.Types
        let groups = WasmGc.Core.Traverse.recGroups (typeArr |> Array.map (fun e -> WasmGc.Core.Traverse.typeDefRefs e.Def))
        for (first, last) in groups do
            if first = last then
                sb.AppendLine(typeDefToWat typeNames typeArr.[first]) |> ignore
            else
                sb.AppendLine("  (rec") |> ignore
                for i in first .. last do
                    sb.AppendLine("  " + typeDefToWat typeNames typeArr.[i]) |> ignore
                sb.AppendLine("  )") |> ignore

    // ── Import section ────────────────────────────────────
    if not wmod.Imports.IsEmpty then
        sb.AppendLine("  ;; ── Imports ────────────────────────────────────────") |> ignore
        for imp in wmod.Imports do
            sb.AppendLine(importToWat typeNames imp) |> ignore

    // ── Tags (exception handling) ─────────────────────────
    if not wmod.Tags.IsEmpty then
        sb.AppendLine("  ;; ── Tags (exception handling) ──────────────────────") |> ignore
        for tag in wmod.Tags do
            let pStrs =
                tag.ParamTypes
                |> List.filter (fun t -> t <> WType.Void)
                |> List.map (wtypeToStr typeNames)
                |> List.map (sprintf "(param %s)")
            let paramsStr = if pStrs.IsEmpty then "" else " " + (pStrs |> String.concat " ")
            sb.AppendLine(sprintf "  (tag %s%s)" (watId tag.Name) paramsStr) |> ignore

    // ── Linear memory ─────────────────────────────────────
    // WasmGC and linear memory coexist in the same module (each managed independently).
    // 1 initial page = 64KB; grows via memory.grow. Exported so JS can read it zero-copy.
    if wmod.HasLinearMemory then
        sb.AppendLine("  ;; ── Linear memory ──────────────────────────────────") |> ignore
        sb.AppendLine("  (memory 1)") |> ignore
        sb.AppendLine("  (export \"memory\" (memory 0))") |> ignore

    // ── Functions ─────────────────────────────────────────
    if not wmod.Functions.IsEmpty then
        sb.AppendLine("  ;; ── Functions ──────────────────────────────────────") |> ignore
        for f in wmod.Functions do
            sb.Append(funcToWat typeNames arrayElemTypes f) |> ignore

    // ── Elem declare (required for ref.func validity) ─────
    // Any function used as ref.func must be declared in an element segment.
    let closureFuncNames = collectClosureFuncNames wmod.Functions
    let globalFuncRefs   = collectGlobalFuncRefs wmod.Globals
    let allFuncRefs = (closureFuncNames @ globalFuncRefs) |> List.distinct |> List.sortBy id
    if not allFuncRefs.IsEmpty then
        sb.AppendLine("  ;; ── Elem declare (func refs) ────────────────────────") |> ignore
        let funcIds = allFuncRefs |> List.map watId |> String.concat " "
        sb.AppendLine($"  (elem declare func {funcIds})") |> ignore

    // ── Start function (module-level initialisers) ────────
    match wmod.Start with
    | Some name -> sb.AppendLine($"  (start {watId name})") |> ignore
    | None -> ()

    // ── Exports ───────────────────────────────────────────
    if not wmod.Exports.IsEmpty then
        sb.AppendLine("  ;; ── Exports ────────────────────────────────────────") |> ignore
        for exp in wmod.Exports do
            sb.AppendLine(exportToWat exp) |> ignore

    // ── Globals ───────────────────────────────────────────
    if not wmod.Globals.IsEmpty then
        sb.AppendLine("  ;; ── Globals ─────────────────────────────────────────") |> ignore
        for g in wmod.Globals do
            sb.AppendLine(globalToWat typeNames arrayElemTypes g) |> ignore

    sb.AppendLine(")") |> ignore
    sb.ToString()


