/// TEIL 2: IrDump — Debug output for Phase 3 (WExpr IR).
///
/// Generates S-expression WASM-like format showing WExpr structure AFTER Phase 3
/// (Fable→WExpr transform) but BEFORE Phase 5 (locals collection).
///
/// Format is inspired by WASM WAT text format but uses F# names for better readability:
///   (let $var type expr
///     (let-mut $i i32 0
///       (loop $main void
///         (if (lt-s $i 100)
///           (seq
///             (set $i (add-s $i 1))
///             (continue $main))
///           (break $exit)))))
///
/// Enable via --dump-phases 3 CLI flag.
module WasmGc.Pipeline.Dumps.IrDump

open System.IO
open WasmGc.Core.AST

// ─────────────────────────────────────────────────────────────────
// Type and operator formatting
// ─────────────────────────────────────────────────────────────────

let wTypeToString (ty: WType) : string =
    match ty with
    | WType.I32 -> "i32"
    | WType.I64 -> "i64"
    | WType.F32 -> "f32"
    | WType.F64 -> "f64"
    | WType.Void -> "void"
    | WType.Ref(idx, nullable) ->
        if nullable then sprintf "ref?(t%d)" idx else sprintf "ref(t%d)" idx
    | WType.Array elemTy -> sprintf "array(%s)" (wTypeToString elemTy)
    | WType.ArrayMut elemTy -> sprintf "array!(mut %s)" (wTypeToString elemTy)

let wUnOpToString (op: WUnOp) : string =
    match op with
    | WUnOp.I32Clz -> "clz-s"
    | WUnOp.I32Ctz -> "ctz-s"
    | WUnOp.I32Popcnt -> "popcnt-s"
    | WUnOp.I64Clz -> "clz-l"
    | WUnOp.I64Ctz -> "ctz-l"
    | WUnOp.I64Popcnt -> "popcnt-l"
    | WUnOp.F32Abs -> "abs-f32"
    | WUnOp.F32Neg -> "neg-f32"
    | WUnOp.F32Sqrt -> "sqrt-f32"
    | WUnOp.F64Abs -> "abs-f64"
    | WUnOp.F64Neg -> "neg-f64"
    | WUnOp.F64Sqrt -> "sqrt-f64"
    | WUnOp.I32Extend8S -> "extend8-s"
    | WUnOp.I32Extend16S -> "extend16-s"
    | WUnOp.I32TruncF32S -> "trunc-f32-s"
    | WUnOp.I32TruncF32U -> "trunc-f32-u"
    | WUnOp.I32TruncF64S -> "trunc-f64-s"
    | WUnOp.I32TruncF64U -> "trunc-f64-u"
    | WUnOp.I64TruncF32S -> "trunc-f32-l-s"
    | WUnOp.I64TruncF32U -> "trunc-f32-l-u"
    | WUnOp.I64TruncF64S -> "trunc-f64-l-s"
    | WUnOp.I64TruncF64U -> "trunc-f64-l-u"
    | WUnOp.F32ConvertI32S -> "convert-i32-f32-s"
    | WUnOp.F32ConvertI32U -> "convert-i32-f32-u"
    | WUnOp.F32ConvertI64S -> "convert-i64-f32-s"
    | WUnOp.F32ConvertI64U -> "convert-i64-f32-u"
    | WUnOp.F32DemoteF64 -> "demote-f64"
    | WUnOp.F64ConvertI32S -> "convert-i32-f64-s"
    | WUnOp.F64ConvertI32U -> "convert-i32-f64-u"
    | WUnOp.F64ConvertI64S -> "convert-i64-f64-s"
    | WUnOp.F64ConvertI64U -> "convert-i64-f64-u"
    | WUnOp.F64PromoteF32 -> "promote-f32"
    | WUnOp.I32ReinterpretF32 -> "reinterpret-f32"
    | WUnOp.I64ReinterpretF64 -> "reinterpret-f64"
    | WUnOp.F32ReinterpretI32 -> "reinterpret-i32"
    | WUnOp.F64ReinterpretI64 -> "reinterpret-i64"

let wBinOpToString (op: WBinOp) : string =
    match op with
    | WBinOp.I32Add -> "add-s"
    | WBinOp.I32Sub -> "sub-s"
    | WBinOp.I32Mul -> "mul-s"
    | WBinOp.I32DivS -> "div-s-s"
    | WBinOp.I32DivU -> "div-s-u"
    | WBinOp.I32RemS -> "rem-s-s"
    | WBinOp.I32RemU -> "rem-s-u"
    | WBinOp.I32And -> "and-s"
    | WBinOp.I32Or -> "or-s"
    | WBinOp.I32Xor -> "xor-s"
    | WBinOp.I32Shl -> "shl-s"
    | WBinOp.I32ShrS -> "shr-s-s"
    | WBinOp.I32ShrU -> "shr-s-u"
    | WBinOp.I32RotL -> "rotl-s"
    | WBinOp.I32RotR -> "rotr-s"
    | WBinOp.I64Add -> "add-l"
    | WBinOp.I64Sub -> "sub-l"
    | WBinOp.I64Mul -> "mul-l"
    | WBinOp.I64DivS -> "div-l-s"
    | WBinOp.I64DivU -> "div-l-u"
    | WBinOp.I64RemS -> "rem-l-s"
    | WBinOp.I64RemU -> "rem-l-u"
    | WBinOp.I64And -> "and-l"
    | WBinOp.I64Or -> "or-l"
    | WBinOp.I64Xor -> "xor-l"
    | WBinOp.I64Shl -> "shl-l"
    | WBinOp.I64ShrS -> "shr-l-s"
    | WBinOp.I64ShrU -> "shr-l-u"
    | WBinOp.I64RotL -> "rotl-l"
    | WBinOp.I64RotU -> "rotr-l"
    | WBinOp.F32Add -> "add-f32"
    | WBinOp.F32Sub -> "sub-f32"
    | WBinOp.F32Mul -> "mul-f32"
    | WBinOp.F32Div -> "div-f32"
    | WBinOp.F32Min -> "min-f32"
    | WBinOp.F32Max -> "max-f32"
    | WBinOp.F32Copysign -> "copysign-f32"
    | WBinOp.F64Add -> "add-f64"
    | WBinOp.F64Sub -> "sub-f64"
    | WBinOp.F64Mul -> "mul-f64"
    | WBinOp.F64Div -> "div-f64"
    | WBinOp.F64Min -> "min-f64"
    | WBinOp.F64Max -> "max-f64"
    | WBinOp.F64Copysign -> "copysign-f64"

let wCompOpToString (op: WCompOp) : string =
    match op with
    | WCompOp.I32Eq -> "eq-s"
    | WCompOp.I32Ne -> "ne-s"
    | WCompOp.I32LtS -> "lt-s-s"
    | WCompOp.I32LtU -> "lt-s-u"
    | WCompOp.I32LeS -> "le-s-s"
    | WCompOp.I32LeU -> "le-s-u"
    | WCompOp.I32GtS -> "gt-s-s"
    | WCompOp.I32GtU -> "gt-s-u"
    | WCompOp.I32GeS -> "ge-s-s"
    | WCompOp.I32GeU -> "ge-s-u"
    | WCompOp.I64Eq -> "eq-l"
    | WCompOp.I64Ne -> "ne-l"
    | WCompOp.I64LtS -> "lt-l-s"
    | WCompOp.I64LtU -> "lt-l-u"
    | WCompOp.I64LeS -> "le-l-s"
    | WCompOp.I64LeU -> "le-l-u"
    | WCompOp.I64GtS -> "gt-l-s"
    | WCompOp.I64GtU -> "gt-l-u"
    | WCompOp.I64GeS -> "ge-l-s"
    | WCompOp.I64GeU -> "ge-l-u"
    | WCompOp.F32Eq -> "eq-f32"
    | WCompOp.F32Ne -> "ne-f32"
    | WCompOp.F32Lt -> "lt-f32"
    | WCompOp.F32Le -> "le-f32"
    | WCompOp.F32Gt -> "gt-f32"
    | WCompOp.F32Ge -> "ge-f32"
    | WCompOp.F64Eq -> "eq-f64"
    | WCompOp.F64Ne -> "ne-f64"
    | WCompOp.F64Lt -> "lt-f64"
    | WCompOp.F64Le -> "le-f64"
    | WCompOp.F64Gt -> "gt-f64"
    | WCompOp.F64Ge -> "ge-f64"

// ─────────────────────────────────────────────────────────────────
// WExpr formatting
// ─────────────────────────────────────────────────────────────────

/// Format a WExpr as an S-expression with proper indentation.
let rec dumpExpr (indent: int) (expr: WExpr) : string =
    let indentStr = String.replicate indent " "

    match expr with
    | WExpr.Const(const_) ->
        match const_ with
        | WConst.I32 n -> sprintf "i32(%d)" n
        | WConst.I64 n -> sprintf "i64(%dL)" n
        | WConst.F32 f -> sprintf "f32(%f)" f
        | WConst.F64 f -> sprintf "f64(%f)" f
        | WConst.Null -> "null"
        | WConst.Undefined -> "undefined"

    | WExpr.LocalGet(name, ty) ->
        sprintf "(local-get %s : %s)" name (wTypeToString ty)

    | WExpr.LocalSet(name, value) ->
        sprintf "(local-set %s\n%s%s)" name indentStr (dumpExpr (indent + 2) value)

    | WExpr.Assign(name, value) ->
        sprintf "(set %s\n%s%s)" name indentStr (dumpExpr (indent + 2) value)

    | WExpr.Let(name, value, body) ->
        sprintf "(let %s\n%s%s\n%s%s)"
            name indentStr (dumpExpr (indent + 2) value) indentStr (dumpExpr (indent + 2) body)

    | WExpr.LetMut(name, value, body) ->
        sprintf "(let-mut %s\n%s%s\n%s%s)"
            name indentStr (dumpExpr (indent + 2) value) indentStr (dumpExpr (indent + 2) body)

    | WExpr.Nop -> "nop"

    | WExpr.Sequence exprs ->
        let exprStrs = exprs |> List.map (fun e ->
            sprintf "%s%s" indentStr (dumpExpr (indent + 2) e))
        sprintf "(seq\n%s)" (String.concat "\n" exprStrs)

    | WExpr.If(cond, thenExpr, elseExpr, ty) ->
        sprintf "(if %s : %s\n%s%s\n%s%s\n%s%s)"
            (dumpExpr 0 cond) (wTypeToString ty)
            indentStr (dumpExpr (indent + 2) thenExpr)
            indentStr (dumpExpr (indent + 2) thenExpr)
            indentStr (dumpExpr (indent + 2) elseExpr)

    | WExpr.Loop(label, body, ty) ->
        sprintf "(loop %s : %s\n%s%s)" label (wTypeToString ty) indentStr (dumpExpr (indent + 2) body)

    | WExpr.Block(label, body, ty) ->
        sprintf "(block %s : %s\n%s%s)" label (wTypeToString ty) indentStr (dumpExpr (indent + 2) body)

    | WExpr.Break(label, Some value) ->
        sprintf "(break %s %s)" label (dumpExpr 0 value)

    | WExpr.Break(label, None) ->
        sprintf "(break %s)" label

    | WExpr.Continue(label, _) ->
        sprintf "(continue %s)" label

    | WExpr.Call(name, args, ty) ->
        let argStrs = args |> List.map (dumpExpr 0) |> String.concat " "
        sprintf "(call %s %s : %s)" name argStrs (wTypeToString ty)

    | WExpr.CallIndirect(tableIdx, args, ty) ->
        let argStrs = args |> List.map (dumpExpr 0) |> String.concat " "
        sprintf "(call-indirect $t%d %s : %s)" tableIdx argStrs (wTypeToString ty)

    | WExpr.Binary(op, left, right, ty) ->
        sprintf "(%s %s %s : %s)" (wBinOpToString op) (dumpExpr 0 left) (dumpExpr 0 right) (wTypeToString ty)

    | WExpr.Unary(op, value, ty) ->
        sprintf "(%s %s : %s)" (wUnOpToString op) (dumpExpr 0 value) (wTypeToString ty)

    | WExpr.Compare(op, left, right) ->
        sprintf "(%s %s %s)" (wCompOpToString op) (dumpExpr 0 left) (dumpExpr 0 right)

    | WExpr.ClosureApply(closure, args, fti, cti, ci, ty) ->
        let argStrs = args |> List.map (dumpExpr 0) |> String.concat " "
        sprintf "(closure-apply %s %s : fti=%d cti=%d ci=%d %s)"
            (dumpExpr 0 closure) argStrs fti cti ci (wTypeToString ty)

    | WExpr.ArrayGet(arr, idx, ty) ->
        sprintf "(array.get %s [%s] : %s)" (dumpExpr 0 arr) (dumpExpr 0 idx) (wTypeToString ty)

    | WExpr.ArraySet(arr, idx, value) ->
        sprintf "(array.set %s [%s] %s)" (dumpExpr 0 arr) (dumpExpr 0 idx) (dumpExpr 0 value)

    | WExpr.ArrayLen(arr) ->
        sprintf "(array.len %s)" (dumpExpr 0 arr)

    | WExpr.StructGet(obj, field, ty) ->
        sprintf "(struct.get %s .%s : %s)" (dumpExpr 0 obj) field (wTypeToString ty)

    | WExpr.StructSet(obj, field, value) ->
        sprintf "(struct.set %s .%s %s)" (dumpExpr 0 obj) field (dumpExpr 0 value)

    | WExpr.Closure(ctypeIdx, captures, ty) ->
        let captureStrs = captures |> List.map (dumpExpr 0) |> String.concat " "
        sprintf "(closure t%d %s : %s)" ctypeIdx captureStrs (wTypeToString ty)

    | WExpr.Cast(obj, ty) ->
        sprintf "(cast %s : %s)" (dumpExpr 0 obj) (wTypeToString ty)

    | WExpr.RefIsNull(obj) ->
        sprintf "(ref.is-null %s)" (dumpExpr 0 obj)

    | _ ->
        sprintf "[%s]" (expr.GetType().Name)


/// Format a function declaration.
let dumpFuncDecl (func: WFuncDecl) : string =
    let paramStrs = func.Params |> List.map (fun (name, ty) ->
        sprintf "(param %s %s)" name (wTypeToString ty))
    let paramList = String.concat "\n  " paramStrs
    let resultStr = wTypeToString func.Result
    let header = sprintf "(func %s\n  %s\n  (result %s)" func.Name paramList resultStr
    let body = dumpExpr 4 func.Body
    sprintf "%s\n  %s)" header body


/// Format a complete module.
let dumpModule (wmod: WModule) : string =
    let funcStrs = wmod.Functions |> List.map dumpFuncDecl
    String.concat "\n\n" funcStrs


/// Write the IR dump to a file.
let dumpToFile (outPath: string) (wmod: WModule) : unit =
    let content = dumpModule wmod
    File.WriteAllText(outPath, content)
