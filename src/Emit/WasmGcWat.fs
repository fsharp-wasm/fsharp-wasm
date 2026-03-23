/// WasmGC WAT (WebAssembly Text Format) emitter.
/// Converts WModule (high-level WasmIR) directly to human-readable .wat text.
///
/// Design: operates on WModule (not WasmModule), so all names (funcs, types, locals)
/// are preserved as-is. No index resolution needed — WAT uses named identifiers.
///
/// Output style: unfolded instruction-per-line format (valid WAT, easy to generate,
/// easy to validate with wasm-tools / wat2wasm).
module Fable.Transforms.WasmGc.WasmGcWat

open System.Text
open Fable.AST.WasmGc

// ─────────────────────────────────────────────────────────────────
// WAT identifier helpers
// ─────────────────────────────────────────────────────────────────

/// Ensure a name has the WAT $ prefix and sanitize to valid WAT idchars.
/// WAT identifiers (idchar) do NOT allow: ' ' , ; ( ) [ ] { } " = ...
/// We replace ',' → '~' (already valid) and space → '_'.
/// This is applied consistently at both definition and use sites.
let private watId (name: string) =
    let base' = if name.StartsWith("$") then name else "$" + name
    // ',' is not a valid WAT idchar — replace with '~'
    if base'.IndexOfAny([|','; ' '|]) >= 0 then
        base'.Replace(',', '~').Replace(' ', '_')
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

// ─────────────────────────────────────────────────────────────────
// WType → WAT text
// ─────────────────────────────────────────────────────────────────

let rec private wtypeToStr (typeNames: Map<int, string>) (ty: WType) : string =
    match ty with
    | WType.I32 -> "i32"
    | WType.I64 -> "i64"
    | WType.F32 -> "f32"
    | WType.F64 -> "f64"
    | WType.Ref(idx, false) ->
        let name = typeNames |> Map.tryFind idx |> Option.defaultValue (sprintf "%d" idx)
        sprintf "(ref %s)" (watId name)
    | WType.Ref(idx, true) ->
        let name = typeNames |> Map.tryFind idx |> Option.defaultValue (sprintf "%d" idx)
        sprintf "(ref null %s)" (watId name)
    | WType.Void -> ""
    | WType.Externref -> "externref"
    | WType.I31ref -> "(ref i31)"
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
// Determine result type of WExpr (mirror of WasmGcEmit.exprResultType)
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
    | WExpr.CallVirtual(_, _, _, t) -> t
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
    | WExpr.Closure(_, _, t)     -> t
    | WExpr.ClosureApply(_, _, _, _, _, t) -> t
    | WExpr.TailCall(_, _, t)    -> t
    | WExpr.TailCallRef(_, _, _, _, _, t) -> t
    | WExpr.Unary(_, _, t)       -> t
    | WExpr.Binary(_, _, _, t)   -> t
    | WExpr.Compare _            -> WType.I32
    | WExpr.TryCatch(_, _, _, t) -> t
    | WExpr.Throw _              -> WType.Void

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
    | WUnaryOp.ConvertI32S, WType.F64 -> ["f64.convert_i32_s"]
    | WUnaryOp.ConvertI32S, WType.F32 -> ["f32.convert_i32_s"]
    | WUnaryOp.ConvertI64S, WType.F64 -> ["f64.convert_i64_s"]
    | WUnaryOp.ConvertI64S, WType.F32 -> ["f32.convert_i64_s"]
    | WUnaryOp.PromoteF32, _ -> ["f64.promote_f32"]
    | WUnaryOp.DemoteF64, _ -> ["f32.demote_f64"]
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
    | _ -> "i32.eq"  // fallback

// ─────────────────────────────────────────────────────────────────
// WExpr → flat list of WAT instruction strings
// ─────────────────────────────────────────────────────────────────

/// Determines one level of indentation string.
let private ind (depth: int) = System.String(' ', depth * 2)

/// Emit WAT instructions for a WExpr into the string buffer.
/// `depth` controls indentation; `sb` is the output buffer.
let rec private emitExpr (typeNames: Map<int, string>) (depth: int) (sb: StringBuilder) (expr: WExpr) : unit =
    let w (line: string) = sb.AppendLine(ind depth + line) |> ignore
    let emit e = emitExpr typeNames depth sb e
    let emitD d e = emitExpr typeNames d sb e

    match expr with
    // ── Constants ──────────────────────────────────────────
    | WExpr.Const(WConst.I32 n) -> w $"i32.const {n}"
    | WExpr.Const(WConst.I64 n) -> w $"i64.const {n}"
    | WExpr.Const(WConst.F32 f) ->
        // WAT requires hex float or decimal; use decimal with enough precision
        let fs = sprintf "%.9g" (float f)
        w $"f32.const {fs}"
    | WExpr.Const(WConst.F64 f) ->
        let fs = sprintf "%.17g" f
        w $"f64.const {fs}"
    | WExpr.Const(WConst.Null(WType.Ref(idx, _))) ->
        let name = typeNames |> Map.tryFind idx |> Option.defaultValue (sprintf "%d" idx)
        w $"ref.null {watId name}"
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
        | WExpr.Unary(WUnaryOp.Neg, operand, WType.I64) ->
            w "i64.const 0"
            emit operand
            w "i64.sub"
        | _ -> emit value
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
        for a in args do emit a
        emit funcRef
        w "call_ref 0 ;; TODO: resolve functype"

    | WExpr.CallVirtual(_, _, _, _) ->
        w "unreachable ;; vtable dispatch not yet implemented"

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
        w $"array.get {watId name}"

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
    | WExpr.JoinPoint(_label, _parms, _body, cont, _ty) ->
        emit cont

    | WExpr.JoinApply(_label, args, _ty) ->
        for a in args do emit a

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
        emit closure
        w "local.tee $clo_apply_tmp"
        w "drop"
        for a in args do emit a
        w "local.get $clo_apply_tmp"
        if closureTypeIdx > 0 then
            let name = typeNames |> Map.tryFind closureTypeIdx |> Option.defaultValue (sprintf "%d" closureTypeIdx)
            w $"ref.cast (ref {watId name})"
        let ftName = typeNames |> Map.tryFind funcTypeIdx |> Option.defaultValue (string funcTypeIdx)
        let cloName = typeNames |> Map.tryFind closureTypeIdx |> Option.defaultValue (string closureTypeIdx)
        w $"struct.get {watId cloName} 0"
        w $"call_ref {watId ftName}"

    | WExpr.TailCallRef(closure, args, funcTypeIdx, closureTypeIdx, _captureCount, _) ->
        emit closure
        w "local.tee $clo_apply_tmp"
        w "drop"
        for a in args do emit a
        w "local.get $clo_apply_tmp"
        if closureTypeIdx > 0 then
            let name = typeNames |> Map.tryFind closureTypeIdx |> Option.defaultValue (string closureTypeIdx)
            w $"ref.cast (ref {watId name})"
        let ftName = typeNames |> Map.tryFind funcTypeIdx |> Option.defaultValue (string funcTypeIdx)
        let cloName = typeNames |> Map.tryFind closureTypeIdx |> Option.defaultValue (string closureTypeIdx)
        w $"struct.get {watId cloName} 0"
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
        emitExpr typeNames (depth + 6) sb body
        w "    )"
        w $"    br 1"
        w "  )"
        match catch_ with
        | Some (_, handler) -> emitExpr typeNames (depth + 2) sb handler
        | None -> ()
        w ")"

    | WExpr.Throw(_exn) ->
        w "unreachable ;; throw not yet implemented"

// ─────────────────────────────────────────────────────────────────
// WFuncDecl → WAT function text
// ─────────────────────────────────────────────────────────────────

let private funcToWat (typeNames: Map<int, string>) (f: WFuncDecl) : string =
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
    emitExpr typeNames 2 sb f.Body
    sb.AppendLine("  )") |> ignore
    sb.ToString()

// ─────────────────────────────────────────────────────────────────
// WGlobalDecl → WAT global declaration
// ─────────────────────────────────────────────────────────────────

let private globalToWat (typeNames: Map<int, string>) (g: WGlobalDecl) : string =
    let sb = StringBuilder()
    let gid = watId g.Name
    let tyStr = wtypeToStr typeNames g.Type
    let mutStr = if g.Mutable then sprintf "(mut %s)" tyStr else tyStr
    sb.Append($"  (global {gid} {mutStr}") |> ignore
    emitExpr typeNames 0 sb g.Init
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
        | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _) -> for a in args do scan a
        | WExpr.CallIndirect(funcRef, args, _) -> scan funcRef; for a in args do scan a
        | WExpr.CallVirtual(obj, _, args, _) -> scan obj; for a in args do scan a
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
        | WExpr.Cast(e, _) | WExpr.TagOf(e) | WExpr.RefIsNull(e) | WExpr.Throw(e) -> scan e
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
        | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _ | WExpr.Nop
        | WExpr.Break(_, None) | WExpr.Return None -> ()
    for f in funcs do scan f.Body
    refs |> Seq.toList |> List.sortBy id

/// Convert a WModule to a WAT text string.
/// This is the primary output function for Sprint 1.
let moduleToWat (wmod: WModule) : string =
    let typeNames = buildTypeNames wmod.Types
    let sb = StringBuilder()

    sb.AppendLine("(module") |> ignore

    // ── Type section ──────────────────────────────────────
    if not wmod.Types.IsEmpty then
        sb.AppendLine("  ;; ── Types ───────────────────────────────────────────") |> ignore
        for td in wmod.Types do
            sb.AppendLine(typeDefToWat typeNames td) |> ignore

    // ── Import section ────────────────────────────────────
    if not wmod.Imports.IsEmpty then
        sb.AppendLine("  ;; ── Imports ────────────────────────────────────────") |> ignore
        for imp in wmod.Imports do
            sb.AppendLine(importToWat typeNames imp) |> ignore

    // ── Functions ─────────────────────────────────────────
    if not wmod.Functions.IsEmpty then
        sb.AppendLine("  ;; ── Functions ──────────────────────────────────────") |> ignore
        for f in wmod.Functions do
            sb.Append(funcToWat typeNames f) |> ignore

    // ── Elem declare (required for ref.func validity) ─────
    // Any function used as ref.func must be declared in an element segment.
    let closureFuncNames = collectClosureFuncNames wmod.Functions
    if not closureFuncNames.IsEmpty then
        sb.AppendLine("  ;; ── Elem declare (func refs) ────────────────────────") |> ignore
        let funcIds = closureFuncNames |> List.map watId |> String.concat " "
        sb.AppendLine($"  (elem declare func {funcIds})") |> ignore

    // ── Exports ───────────────────────────────────────────
    if not wmod.Exports.IsEmpty then
        sb.AppendLine("  ;; ── Exports ────────────────────────────────────────") |> ignore
        for exp in wmod.Exports do
            sb.AppendLine(exportToWat exp) |> ignore

    // ── Globals ───────────────────────────────────────────
    if not wmod.Globals.IsEmpty then
        sb.AppendLine("  ;; ── Globals ─────────────────────────────────────────") |> ignore
        for g in wmod.Globals do
            sb.AppendLine(globalToWat typeNames g) |> ignore

    sb.AppendLine(")") |> ignore
    sb.ToString()
