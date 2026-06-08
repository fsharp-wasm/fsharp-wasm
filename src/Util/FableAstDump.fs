/// TEIL 2: FableAstDump — Debug output for Phase 0 (Fable AST input).
///
/// Generates F#-like pseudo-code with type annotations for readable debugging.
/// Not actual F# (too verbose), but human-readable structure showing:
/// - Function signatures
/// - Let bindings with types
/// - Control flow (if, while, for, match)
/// - Lambda/delegate expressions
/// - Calls and applications
///
/// Enable via --dump-phases 0 CLI flag.
module WasmGc.Util.FableAstDump

open System.IO
open Fable.AST
open Fable.AST.Fable

// ─────────────────────────────────────────────────────────────────
// Type annotation helpers
// ─────────────────────────────────────────────────────────────────

let rec typeToString (ty: Type) : string =
    match ty with
    | Type.Measure fullname -> $"measure<{fullname}>"
    | Type.MetaType -> "meta"
    | Type.Any -> "any"
    | Type.Unit -> "unit"
    | Type.Boolean -> "bool"
    | Type.Char -> "char"
    | Type.String -> "string"
    | Type.Regex -> "regex"
    | Type.Number(kind, _) ->
        match kind with
        | NumberKind.Int8 -> "i8"
        | NumberKind.UInt8 -> "u8"
        | NumberKind.Int16 -> "i16"
        | NumberKind.UInt16 -> "u16"
        | NumberKind.Int32 -> "i32"
        | NumberKind.UInt32 -> "u32"
        | NumberKind.Int64 -> "i64"
        | NumberKind.UInt64 -> "u64"
        | NumberKind.Int128 -> "i128"
        | NumberKind.UInt128 -> "u128"
        | NumberKind.BigInt -> "bigint"
        | NumberKind.NativeInt -> "nativeint"
        | NumberKind.UNativeInt -> "unativeint"
        | NumberKind.Float16 -> "f16"
        | NumberKind.Float32 -> "f32"
        | NumberKind.Float64 -> "f64"
        | NumberKind.Decimal -> "decimal"
    | Type.Option(elemTy, isStruct) ->
        if isStruct then $"voption<{typeToString elemTy}>"
        else $"{typeToString elemTy} option"
    | Type.Tuple(elemTys, isStruct) ->
        let inner = elemTys |> List.map typeToString |> String.concat " * "
        if isStruct then $"struct ({inner})" else $"({inner})"
    | Type.Array(elemTy, kind) ->
        let k =
            match kind with
            | ArrayKind.ResizeArray -> "resize"
            | ArrayKind.MutableArray -> "mutable"
            | ArrayKind.ImmutableArray -> "immutable"
        $"{typeToString elemTy}[]<{k}>"
    | Type.List elemTy -> $"list<{typeToString elemTy}>"
    | Type.LambdaType(argTy, retTy) -> $"({typeToString argTy} -> {typeToString retTy})"
    | Type.DelegateType(argTys, retTy) ->
        let args =
            match argTys with
            | [] -> "unit"
            | xs -> xs |> List.map typeToString |> String.concat " * "
        $"delegate ({args}) -> {typeToString retTy}"
    | Type.GenericParam(name, _, _) -> $"'{name}"
    | Type.DeclaredType(entRef, genericArgs) ->
        match genericArgs with
        | [] -> entRef.FullName
        | xs ->
            let gen = xs |> List.map typeToString |> String.concat ", "
            $"{entRef.FullName}<{gen}>"
    | Type.AnonymousRecordType(fieldNames, genericArgs, isStruct) ->
        let fields =
            List.zip (Array.toList fieldNames) genericArgs
            |> List.map (fun (n, t) -> $"{n}: {typeToString t}")
            |> String.concat "; "
        if isStruct then $"struct {{ {fields} }}" else $"{{ {fields} }}"
    | Type.Nullable(elemTy, isStruct) ->
        if isStruct then $"nullable<{typeToString elemTy}>"
        else $"Nullable<{typeToString elemTy}>"

// ─────────────────────────────────────────────────────────────────
// AST formatting
// ─────────────────────────────────────────────────────────────────

let rec dumpExpr (indent: int) (expr: Expr) : string =
    let indentStr = String.replicate indent " "
    let nextIndent = indent + 2

    match expr with
    | Expr.IdentExpr ident ->
        $"%s{indentStr}[Ident] %s{ident.Name} : %s{typeToString ident.Type}"

    | Expr.Value(kind, _) ->
        match kind with
        | ValueKind.UnitConstant -> $"%s{indentStr}[Unit]"
        | ValueKind.BoolConstant b -> $"%s{indentStr}[Bool] %b{b}"
        | ValueKind.CharConstant c -> $"%s{indentStr}[Char] '%c{c}'"
        | ValueKind.NumberConstant(n, _) -> $"%s{indentStr}[Num] %A{n}"
        | ValueKind.StringConstant s -> $"%s{indentStr}[Str] \"%s{s}\""
        | ValueKind.Null t -> $"%s{indentStr}[Null] : %s{typeToString t}"
        | _ -> $"%s{indentStr}[Value] : %s{typeToString kind.Type}"

    | Expr.Let(ident, value, body) ->
        [ $"%s{indentStr}let %s{ident.Name} : %s{typeToString ident.Type} ="
          dumpExpr nextIndent value
          dumpExpr indent body ]
        |> String.concat "\n"


    | Expr.LetRec(bindings, body) ->
        let bindLines =
            bindings
            |> List.mapi (fun i (id, e) ->
                let kw = if i = 0 then "let rec" else "and"
                [ $"%s{indentStr}%s{kw} %s{id.Name} : %s{typeToString id.Type} ="
                  dumpExpr nextIndent e ]
                |> String.concat "\n")
            |> String.concat "\n"

        [ bindLines
          dumpExpr indent body ]
        |> String.concat "\n"

    | Expr.Lambda(arg, body, _) ->
        [ $"%s{indentStr}[Lambda] fun %s{arg.Name} : %s{typeToString arg.Type} ->"
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.Delegate(args, body, _, _) ->
        let argStr =
            args
            |> List.map (fun a -> $"{a.Name}: {typeToString a.Type}")
            |> String.concat ", "
        [ $"%s{indentStr}[Delegate] fun (%s{argStr}) ->"
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.IfThenElse(guard, thenExpr, elseExpr, _) ->
        [ $"%s{indentStr}[If]"
          $"%s{indentStr}Condition:"
          dumpExpr nextIndent guard
          $"%s{indentStr}Then:"
          dumpExpr nextIndent thenExpr
          $"%s{indentStr}Else:"
          dumpExpr nextIndent elseExpr ]
        |> String.concat "\n"

    | Expr.WhileLoop(guard, body, _) ->
        [ $"%s{indentStr}[While]"
          $"%s{indentStr}Condition:"
          dumpExpr nextIndent guard
          $"%s{indentStr}Body:"
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.ForLoop(ident, start, limit, body, isUp, _) ->
        let dir = if isUp then "to" else "downto"
        [ $"%s{indentStr}[For] %s{ident.Name} : %s{typeToString ident.Type}"
          $"%s{indentStr}Start:"
          dumpExpr nextIndent start
          $"%s{indentStr}%s{dir}:"
          dumpExpr nextIndent limit
          $"%s{indentStr}Body:"
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.Sequential exprs ->
        [ $"%s{indentStr}[Seq]"
          exprs |> List.map (dumpExpr nextIndent) |> String.concat "\n" ]
        |> String.concat "\n"

    | Expr.Call(callee, callInfo, _, _) ->
        let calleeStr = dumpExpr nextIndent callee
        let thisArgStr =
            match callInfo.ThisArg with
            | Some thisArg ->
                [ $"%s{indentStr}ThisArg:"
                  dumpExpr nextIndent thisArg ]
                |> String.concat "\n"
            | None -> ""
        let argsStr =
            callInfo.Args
            |> List.map (dumpExpr nextIndent)
            |> String.concat "\n"

        [ $"%s{indentStr}[Call]"
          $"%s{indentStr}Callee:"
          calleeStr
          thisArgStr
          $"%s{indentStr}Args:"
          argsStr ]
        |> List.filter (fun s -> s <> "")
        |> String.concat "\n"

    | Expr.CurriedApply(callee, args, _, _) ->
        [ $"%s{indentStr}[Apply]"
          $"%s{indentStr}Callee:"
          dumpExpr nextIndent callee
          $"%s{indentStr}Args:"
          args |> List.map (dumpExpr nextIndent) |> String.concat "\n" ]
        |> String.concat "\n"

    | Expr.DecisionTree(scrutinee, targets) ->
        let scrutStr = dumpExpr nextIndent scrutinee
        let targetStrs =
            targets
            |> List.mapi (fun i (ids, body) ->
                let idStr = ids |> List.map (fun id -> id.Name) |> String.concat ", "
                [ $"%s{indentStr}Case #%d{i} (%s{idStr}):"
                  dumpExpr nextIndent body ]
                |> String.concat "\n")
        [ $"%s{indentStr}[Match]"
          scrutStr ]
        @ targetStrs
        |> String.concat "\n"

    | Expr.DecisionTreeSuccess(targetIndex, vals, _) ->
        [ $"%s{indentStr}[DecisionTreeSuccess] target=%d{targetIndex}"
          vals |> List.map (dumpExpr nextIndent) |> String.concat "\n" ]
        |> String.concat "\n"

    | Expr.TryCatch(body, catch, fin, _) ->
        let bodyStr = dumpExpr nextIndent body
        let catchStr =
            match catch with
            | Some(exId, e) ->
                $"%s{indentStr}Catch %s{exId.Name}:\n%s{dumpExpr nextIndent e}"
            | None -> ""
        let finStr =
            match fin with
            | Some e -> $"%s{indentStr}Finally:\n%s{dumpExpr nextIndent e}"
            | None -> ""
        [ $"%s{indentStr}[Try]"
          bodyStr
          catchStr
          finStr ]
        |> List.filter (fun s -> s <> "")
        |> String.concat "\n"

    | Expr.TypeCast(e, t) ->
        [ $"%s{indentStr}[TypeCast] : %s{typeToString t}"
          dumpExpr nextIndent e ]
        |> String.concat "\n"

    | Expr.Get(e, _, t, _) ->
        [ $"%s{indentStr}[Get] : %s{typeToString t}"
          dumpExpr nextIndent e ]
        |> String.concat "\n"

    | Expr.Set(e, _, t, v, _) ->
        [ $"%s{indentStr}[Set] : %s{typeToString t}"
          $"%s{indentStr}Target:"
          dumpExpr nextIndent e
          $"%s{indentStr}Value:"
          dumpExpr nextIndent v ]
        |> String.concat "\n"

    | Expr.Test(e, testKind, _) ->
        [ $"%s{indentStr}[Test] %A{testKind}"
          dumpExpr nextIndent e ]
        |> String.concat "\n"

    | Expr.Import(info, t, _) ->
        $"%s{indentStr}[Import] %A{info} : %s{typeToString t}"

    | Expr.Emit(info, t, _) ->
        $"%s{indentStr}[Emit] %A{info} : %s{typeToString t}"

    | Expr.Extended(kind, _) ->
        $"%s{indentStr}[Extended] %A{kind} : %s{typeToString kind.Type}"

    | Expr.ObjectExpr(members, t, baseCall) ->
        let baseStr =
            match baseCall with
            | Some b ->
                [ $"%s{indentStr}BaseCall:"
                  dumpExpr nextIndent b ]
                |> String.concat "\n"
            | None -> ""
        let memberStrs =
            members
            |> List.map (fun m ->
                let args = m.Args |> List.map (fun a -> a.Name) |> String.concat ", "
                [ $"%s{indentStr}Member %s{m.Name}(%s{args}):"
                  dumpExpr nextIndent m.Body ]
                |> String.concat "\n")
            |> String.concat "\n"

        [ $"%s{indentStr}[ObjectExpr] : %s{typeToString t}"
          baseStr
          memberStrs ]
        |> List.filter (fun s -> s <> "")
        |> String.concat "\n"

    | Expr.Unresolved(u, t, _) ->
        $"%s{indentStr}[Unresolved] %A{u} : %s{typeToString t}"

    | Expr.Quote(q, isTyped, _) ->
        [ $"%s{indentStr}[Quote] typed=%b{isTyped}"
          dumpExpr nextIndent q ]
        |> String.concat "\n"

    | Fable.Expr.Operation(kind, _tags, _ty, _range) ->
        let desc =
            match kind with
            | OperationKind.Binary(op, _, _) -> $"Binary(%A{op})"
            | OperationKind.Unary(op, _)     -> $"Unary(%A{op})"
            | OperationKind.Logical(op, _, _)-> $"Logical(%A{op})"

        $"%s{indentStr}Operation(%s{desc})"

/// Dump a function/member declaration.
let dumpFuncDecl (func: MemberDecl) : string =
    let sig_ = $"[Function] %s{func.Name}"
    let paramStrs = func.Args |> List.map (fun arg -> $"%s{arg.Name} : %s{typeToString arg.Type}")
    let paramList = String.concat ", " paramStrs
    let retType = typeToString func.Body.Type
    let header = $"%s{sig_}(%s{paramList}) -> %s{retType}"
    let body = dumpExpr 2 func.Body
    $"%s{header}\n%s{body}"

/// Dump all declarations in a module.
let dumpModule (decls: Declaration list) : string =
    decls
    |> List.choose (function
        | Declaration.MemberDeclaration md -> Some(dumpFuncDecl md)
        | _ -> None)
    |> String.concat "\n\n"

/// Write the Fable AST dump to a file.
let dumpToFile (outPath: string) (decls: Declaration list) : unit =
    let content = dumpModule decls
    File.WriteAllText(outPath, content)
