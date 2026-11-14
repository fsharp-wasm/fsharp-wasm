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
module WasmGc.Util.IrDump

open System.IO
open WasmGc.Core.AST

// ─────────────────────────────────────────────────────────────────
// Type and operator formatting
// ─────────────────────────────────────────────────────────────────

let rec wTypeToString (ty: WType) : string =
    match ty with
    | WType.I32 -> "i32"
    | WType.I64 -> "i64"
    | WType.F32 -> "f32"
    | WType.F64 -> "f64"
    | WType.I16 -> "i16"
    | WType.I8 -> "i8"
    | WType.Void -> "void"
    | WType.Externref -> "externref"
    | WType.ExternNonNull -> "(ref extern)"
    | WType.I31ref -> "i31ref"
    | WType.EqRef -> "eqref"
    | WType.AnyRef -> "anyref"
    | WType.Ref(idx, nullable) ->
        if nullable then $"(ref null t{idx})" else $"(ref t{idx})"
    | WType.Func(args, results) ->
        let a = args |> List.map wTypeToString |> String.concat " "
        let r = results |> List.map wTypeToString |> String.concat " "
        $"(func ({a}) -> ({r}))"
    | WType.Struct fields ->
        let fs =
            fields
            |> List.map (fun f ->
                let mutSuffix = if f.Mutable then " mut" else ""
                $"{f.Name}:{wTypeToString f.Type}{mutSuffix}")
            |> String.concat "; "
        $"(struct {fs})"
    | WType.Array(elem, mutable_) ->
        if mutable_ then $"(array mut {wTypeToString elem})"
        else $"(array {wTypeToString elem})"

let wUnaryOpToString (op: WUnaryOp) : string =
    match op with
    | WUnaryOp.Neg -> "neg"
    | WUnaryOp.Abs -> "abs"
    | WUnaryOp.Sqrt -> "sqrt"
    | WUnaryOp.Ceil -> "ceil"
    | WUnaryOp.Floor -> "floor"
    | WUnaryOp.Trunc -> "trunc"
    | WUnaryOp.Nearest -> "nearest"
    | WUnaryOp.Not -> "not"
    | WUnaryOp.Clz -> "clz"
    | WUnaryOp.Ctz -> "ctz"
    | WUnaryOp.Popcnt -> "popcnt"
    | WUnaryOp.Eqz -> "eqz"
    | WUnaryOp.WrapI64 -> "wrap_i64"
    | WUnaryOp.ExtendI32S -> "extend_i32_s"
    | WUnaryOp.ExtendI32U -> "extend_i32_u"
    | WUnaryOp.TruncF64S -> "trunc_f64_s"
    | WUnaryOp.TruncF32S -> "trunc_f32_s"
    | WUnaryOp.TruncSatF64S -> "trunc_sat_f64_s"
    | WUnaryOp.TruncSatF32S -> "trunc_sat_f32_s"
    | WUnaryOp.ConvertI32S -> "convert_i32_s"
    | WUnaryOp.ConvertI64S -> "convert_i64_s"
    | WUnaryOp.PromoteF32 -> "promote_f32"
    | WUnaryOp.DemoteF64 -> "demote_f64"
    | WUnaryOp.ReinterpretI32ToF32 -> "reinterpret_i32_to_f32"
    | WUnaryOp.ReinterpretF32ToI32 -> "reinterpret_f32_to_i32"
    | WUnaryOp.ReinterpretI64ToF64 -> "reinterpret_i64_to_f64"
    | WUnaryOp.ReinterpretF64ToI64 -> "reinterpret_f64_to_i64"

let wBinaryOpToString (op: WBinaryOp) : string =
    match op with
    | WBinaryOp.Add -> "add"
    | WBinaryOp.Sub -> "sub"
    | WBinaryOp.Mul -> "mul"
    | WBinaryOp.DivS -> "div_s"
    | WBinaryOp.DivU -> "div_u"
    | WBinaryOp.RemS -> "rem_s"
    | WBinaryOp.RemU -> "rem_u"
    | WBinaryOp.And -> "and"
    | WBinaryOp.Or -> "or"
    | WBinaryOp.Xor -> "xor"
    | WBinaryOp.Shl -> "shl"
    | WBinaryOp.ShrS -> "shr_s"
    | WBinaryOp.ShrU -> "shr_u"
    | WBinaryOp.Rotl -> "rotl"
    | WBinaryOp.Rotr -> "rotr"
    | WBinaryOp.Min -> "min"
    | WBinaryOp.Max -> "max"
    | WBinaryOp.CopySign -> "copysign"

let wCompareOpToString (op: WCompareOp) : string =
    match op with
    | WCompareOp.Eq -> "eq"
    | WCompareOp.Ne -> "ne"
    | WCompareOp.LtS -> "lt_s"
    | WCompareOp.LtU -> "lt_u"
    | WCompareOp.GtS -> "gt_s"
    | WCompareOp.GtU -> "gt_u"
    | WCompareOp.LeS -> "le_s"
    | WCompareOp.LeU -> "le_u"
    | WCompareOp.GeS -> "ge_s"
    | WCompareOp.GeU -> "ge_u"
    | WCompareOp.RefEq -> "ref_eq"

let wMemKindToString (k: WMemKind) : string =
    match k with
    | WMemKind.Byte -> "byte"
    | WMemKind.I32 -> "i32"
    | WMemKind.I64 -> "i64"
    | WMemKind.F32 -> "f32"
    | WMemKind.F64 -> "f64"

// ─────────────────────────────────────────────────────────────────
// WExpr formatting
// ─────────────────────────────────────────────────────────────────

let private pad (indent: int) = String.replicate indent " "

let private joinLines (lines: string list) = String.concat "\n" lines

let rec dumpExpr (indent: int) (expr: WExpr) : string =
    let p = pad indent
    let d = dumpExpr (indent + 2)

    match expr with
    | WExpr.Const c ->
        match c with
        | WConst.I32 n -> $"{p}(i32.const {n})"
        | WConst.I64 n -> $"{p}(i64.const {n})"
        | WConst.F32 n -> $"{p}(f32.const {n})"
        | WConst.F64 n -> $"{p}(f64.const {n})"
        | WConst.String s -> $"{p}(string.const {s})"
        | WConst.Null ty -> $"{p}(ref.null {wTypeToString ty})"
        | WConst.Unit -> $"{p}unit"

    | WExpr.LocalGet(name, ty) ->
        $"{p}(local.get {name} : {wTypeToString ty})"

    | WExpr.GlobalGet(name, ty) ->
        $"{p}(global.get {name} : {wTypeToString ty})"

    | WExpr.GlobalSet(name, value) ->
        joinLines [
            $"{p}(global.set {name}"
            d value
            $"{p})"
        ]

    | WExpr.Let(name, value, body) ->
        joinLines [
            $"{p}(let {name}"
            d value
            d body
            $"{p})"
        ]

    | WExpr.LetMut(name, value, body) ->
        joinLines [
            $"{p}(let-mut {name}"
            d value
            d body
            $"{p})"
        ]

    | WExpr.Assign(name, value) ->
        joinLines [
            $"{p}(set {name}"
            d value
            $"{p})"
        ]

    | WExpr.Call(func, args, ty) ->
        let argLines = args |> List.map d
        joinLines (
            [ $"{p}(call {func} : {wTypeToString ty}" ]
            @ argLines
            @ [ $"{p})" ]
        )

    | WExpr.CallIndirect(funcRef, args, ty) ->
        let argLines = args |> List.map d
        joinLines (
            [ $"{p}(call_indirect : {wTypeToString ty}"
              d funcRef ]
            @ argLines
            @ [ $"{p})" ]
        )

    | WExpr.CallVirtual(obj, boxTypeIdx, vtableTypeIdx, methodIdx, funcTypeIdx, args, ty) ->
        let argLines = args |> List.map d
        joinLines (
            [ $"{p}(call_virtual boxType={boxTypeIdx} vtableType={vtableTypeIdx} methodIdx={methodIdx} funcType={funcTypeIdx} : {wTypeToString ty}"
              d obj ]
            @ argLines
            @ [ $"{p})" ]
        )

    | WExpr.CallRef(fti, args, codePtr, ty) ->
        let argLines = args |> List.map d
        joinLines (
            [ $"{p}(call_ref fti={fti} : {wTypeToString ty}" ]
            @ argLines
            @ [ d codePtr; $"{p})" ]
        )

    | WExpr.ReturnCallRef(fti, args, codePtr, ty) ->
        let argLines = args |> List.map d
        joinLines (
            [ $"{p}(return_call_ref fti={fti} : {wTypeToString ty}" ]
            @ argLines
            @ [ d codePtr; $"{p})" ]
        )

    | WExpr.FuncRef funcName ->
        $"{p}(ref.func {funcName})"

    | WExpr.StructNew(typeIdx, fields, ty) ->
        let fs = fields |> List.map d
        joinLines (
            [ $"{p}(struct.new t{typeIdx} : {wTypeToString ty}" ]
            @ fs
            @ [ $"{p})" ]
        )

    | WExpr.StructGet(obj, fieldIdx, ty) ->
        joinLines [
            $"{p}(struct.get {fieldIdx} : {wTypeToString ty}"
            d obj
            $"{p})"
        ]

    | WExpr.StructSet(obj, fieldIdx, value) ->
        joinLines [
            $"{p}(struct.set {fieldIdx}"
            d obj
            d value
            $"{p})"
        ]

    | WExpr.ArrayNew(typeIdx, size, init, ty) ->
        joinLines [
            $"{p}(array.new t{typeIdx} : {wTypeToString ty}"
            d size
            d init
            $"{p})"
        ]

    | WExpr.ArrayNewFixed(typeIdx, elems, ty) ->
        let es = elems |> List.map d
        joinLines (
            [ $"{p}(array.new_fixed t{typeIdx} : {wTypeToString ty}" ]
            @ es
            @ [ $"{p})" ]
        )

    | WExpr.ArrayGet(arr, idx, ty) ->
        joinLines [
            $"{p}(array.get : {wTypeToString ty}"
            d arr
            d idx
            $"{p})"
        ]

    | WExpr.ArraySet(arr, idx, value) ->
        joinLines [
            $"{p}(array.set"
            d arr
            d idx
            d value
            $"{p})"
        ]

    | WExpr.ArrayLen arr ->
        joinLines [
            $"{p}(array.len"
            d arr
            $"{p})"
        ]

    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        joinLines [
            $"{p}(array.copy"
            d dst
            d dstOff
            d src
            d srcOff
            d len
            $"{p})"
        ]

    | WExpr.If(cond, thenExpr, elseExpr, ty) ->
        joinLines [
            $"{p}(if : {wTypeToString ty}"
            d cond
            d thenExpr
            d elseExpr
            $"{p})"
        ]

    | WExpr.Loop(label, body, ty) ->
        joinLines [
            $"{p}(loop {label} : {wTypeToString ty}"
            d body
            $"{p})"
        ]

    | WExpr.Break(label, valueOpt) ->
        match valueOpt with
        | Some value ->
            joinLines [
                $"{p}(break {label}"
                d value
                $"{p})"
            ]
        | None ->
            $"{p}(break {label})"

    | WExpr.Continue(label, args) ->
        let as_ = args |> List.map d
        joinLines (
            [ $"{p}(continue {label}" ]
            @ as_
            @ [ $"{p})" ]
        )

    | WExpr.Block(label, body, ty) ->
        joinLines [
            $"{p}(block {label} : {wTypeToString ty}"
            d body
            $"{p})"
        ]

    | WExpr.Return valueOpt ->
        match valueOpt with
        | Some v ->
            joinLines [
                $"{p}(return"
                d v
                $"{p})"
            ]
        | None ->
            $"{p}(return)"

    | WExpr.Sequence exprs ->
        let xs = exprs |> List.map d
        joinLines (
            [ $"{p}(seq" ]
            @ xs
            @ [ $"{p})" ]
        )

    | WExpr.Nop ->
        $"{p}nop"

    | WExpr.JoinPoint(label, parms, body, cont, ty) ->
        let ps =
            parms
            |> List.map (fun (n, t) -> $"{n}:{wTypeToString t}")
            |> String.concat ", "
        joinLines [
            $"{p}(join_point {label} ({ps}) : {wTypeToString ty}"
            d body
            d cont
            $"{p})"
        ]

    | WExpr.JoinApply(label, args, ty) ->
        let as_ = args |> List.map d
        joinLines (
            [ $"{p}(join_apply {label} : {wTypeToString ty}" ]
            @ as_
            @ [ $"{p})" ]
        )

    | WExpr.SwitchInt(scrutinee, cases, default_, ty) ->
        let caseLines =
            cases
            |> List.collect (fun (k, e) ->
                [ $"{p}  (case {k}"
                  dumpExpr (indent + 4) e
                  $"{p}  )" ])
        joinLines (
            [ $"{p}(switch_int : {wTypeToString ty}"
              d scrutinee ]
            @ caseLines
            @ [ $"{p}  (default"
                dumpExpr (indent + 4) default_
                $"{p}  )"
                $"{p})" ]
        )

    | WExpr.TagOf obj ->
        joinLines [
            $"{p}(tag_of"
            d obj
            $"{p})"
        ]

    | WExpr.Cast(obj, targetType) ->
        joinLines [
            $"{p}(cast -> {wTypeToString targetType}"
            d obj
            $"{p})"
        ]

    | WExpr.RefIsNull obj ->
        joinLines [
            $"{p}(ref.is_null"
            d obj
            $"{p})"
        ]

    | WExpr.RefTest(obj, targetType) ->
        joinLines [
            $"{p}(ref.test {wTypeToString targetType}"
            d obj
            $"{p})"
        ]

    | WExpr.Closure(funcName, captures, ty) ->
        let cs = captures |> List.map d
        joinLines (
            [ $"{p}(closure {funcName} : {wTypeToString ty}" ]
            @ cs
            @ [ $"{p})" ]
        )

    | WExpr.ClosureApply(closure, args, funcTypeIdx, closureTypeIdx, captureCount, ty) ->
        let as_ = args |> List.map d
        joinLines (
            [ $"{p}(closure_apply fti={funcTypeIdx} cti={closureTypeIdx} captures={captureCount} : {wTypeToString ty}"
              d closure ]
            @ as_
            @ [ $"{p})" ]
        )

    | WExpr.Unary(op, operand, ty) ->
        joinLines [
            $"{p}({wUnaryOpToString op} : {wTypeToString ty}"
            d operand
            $"{p})"
        ]

    | WExpr.Binary(op, left, right, ty) ->
        joinLines [
            $"{p}({wBinaryOpToString op} : {wTypeToString ty}"
            d left
            d right
            $"{p})"
        ]

    | WExpr.Compare(op, left, right) ->
        joinLines [
            $"{p}({wCompareOpToString op}"
            d left
            d right
            $"{p})"
        ]

    | WExpr.TailCall(func, args, ty) ->
        let as_ = args |> List.map d
        joinLines (
            [ $"{p}(tail_call {func} : {wTypeToString ty}" ]
            @ as_
            @ [ $"{p})" ]
        )

    | WExpr.TailCallRef(funcRef, args, funcTypeIdx, closureTypeIdx, captureCount, ty) ->
        let as_ = args |> List.map d
        joinLines (
            [ $"{p}(tail_call_ref fti={funcTypeIdx} cti={closureTypeIdx} captures={captureCount} : {wTypeToString ty}"
              d funcRef ]
            @ as_
            @ [ $"{p})" ]
        )

    | WExpr.TryCatch(body, catchExpr, finallyExpr, ty) ->
        let catchLines =
            match catchExpr with
            | Some (name, cexpr) ->
                [ $"{p}  (catch {name}"
                  dumpExpr (indent + 4) cexpr
                  $"{p}  )" ]
            | None -> []
        let finallyLines =
            match finallyExpr with
            | Some f ->
                [ $"{p}  (finally"
                  dumpExpr (indent + 4) f
                  $"{p}  )" ]
            | None -> []
        joinLines (
            [ $"{p}(try : {wTypeToString ty}"
              d body ]
            @ catchLines
            @ finallyLines
            @ [ $"{p})" ]
        )

    | WExpr.Throw exn ->
        joinLines [
            $"{p}(throw"
            d exn
            $"{p})"
        ]

    | WExpr.MemLoad(kind, offset, addr) ->
        joinLines [
            $"{p}(mem.load {wMemKindToString kind} offset={offset}"
            d addr
            $"{p})"
        ]

    | WExpr.MemStore(kind, offset, addr, value) ->
        joinLines [
            $"{p}(mem.store {wMemKindToString kind} offset={offset}"
            d addr
            d value
            $"{p})"
        ]

    | WExpr.MemorySize ->
        $"{p}(memory.size)"

    | WExpr.MemoryGrow pages ->
        joinLines [
            $"{p}(memory.grow"
            d pages
            $"{p})"
        ]

let dumpFuncDecl (func: WFuncDecl) : string =
    let exportedSuffix = if func.Exported then " ;; exported" else ""
    let header =
        $"(func {func.Name} (result {wTypeToString func.Result}){exportedSuffix}"
    let paramLines =
        func.Params
        |> List.map (fun (n, t) -> $"  (param {n} {wTypeToString t})")
    let locals =
        func.Locals
        |> List.map (fun (n, t) -> $"  (local {n} {wTypeToString t})")
    let body = dumpExpr 2 func.Body
    joinLines ([ header ] @ paramLines @ locals @ [ body; ")" ])

let dumpModule (wmod: WModule) : string =
    wmod.Functions
    |> List.map dumpFuncDecl
    |> String.concat "\n\n"

let dumpToFile (outPath: string) (wmod: WModule) : unit =
    let content = dumpModule wmod
    File.WriteAllText(outPath, content)
