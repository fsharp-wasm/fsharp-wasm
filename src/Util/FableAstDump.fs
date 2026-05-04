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
        sprintf "%s[Ident] %s : %s" indentStr ident.Name (typeToString ident.Type)

    | Expr.Value(kind, _) ->
        match kind with
        | ValueKind.UnitConstant -> sprintf "%s[Unit]" indentStr
        | ValueKind.BoolConstant b -> sprintf "%s[Bool] %b" indentStr b
        | ValueKind.CharConstant c -> sprintf "%s[Char] '%c'" indentStr c
        | ValueKind.NumberConstant(n, _) -> sprintf "%s[Num] %A" indentStr n
        | ValueKind.StringConstant s -> sprintf "%s[Str] \"%s\"" indentStr s
        | ValueKind.Null t -> sprintf "%s[Null] : %s" indentStr (typeToString t)
        | _ -> sprintf "%s[Value] : %s" indentStr (typeToString kind.Type)

    | Expr.Let(ident, value, body) ->
        [ sprintf "%slet %s : %s =" indentStr ident.Name (typeToString ident.Type)
          dumpExpr nextIndent value
          dumpExpr indent body ]
        |> String.concat "\n"


    | Expr.LetRec(bindings, body) ->
        let bindLines =
            bindings
            |> List.mapi (fun i (id, e) ->
                let kw = if i = 0 then "let rec" else "and"
                [ sprintf "%s%s %s : %s =" indentStr kw id.Name (typeToString id.Type)
                  dumpExpr nextIndent e ]
                |> String.concat "\n")
            |> String.concat "\n"

        [ bindLines
          dumpExpr indent body ]
        |> String.concat "\n"

    | Expr.Lambda(arg, body, _) ->
        [ sprintf "%s[Lambda] fun %s : %s ->" indentStr arg.Name (typeToString arg.Type)
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.Delegate(args, body, _, _) ->
        let argStr =
            args
            |> List.map (fun a -> $"{a.Name}: {typeToString a.Type}")
            |> String.concat ", "
        [ sprintf "%s[Delegate] fun (%s) ->" indentStr argStr
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.IfThenElse(guard, thenExpr, elseExpr, _) ->
        [ sprintf "%s[If]" indentStr
          sprintf "%sCondition:" indentStr
          dumpExpr nextIndent guard
          sprintf "%sThen:" indentStr
          dumpExpr nextIndent thenExpr
          sprintf "%sElse:" indentStr
          dumpExpr nextIndent elseExpr ]
        |> String.concat "\n"

    | Expr.WhileLoop(guard, body, _) ->
        [ sprintf "%s[While]" indentStr
          sprintf "%sCondition:" indentStr
          dumpExpr nextIndent guard
          sprintf "%sBody:" indentStr
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.ForLoop(ident, start, limit, body, isUp, _) ->
        let dir = if isUp then "to" else "downto"
        [ sprintf "%s[For] %s : %s" indentStr ident.Name (typeToString ident.Type)
          sprintf "%sStart:" indentStr
          dumpExpr nextIndent start
          sprintf "%s%s:" indentStr dir
          dumpExpr nextIndent limit
          sprintf "%sBody:" indentStr
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.Sequential exprs ->
        [ sprintf "%s[Seq]" indentStr
          exprs |> List.map (dumpExpr nextIndent) |> String.concat "\n" ]
        |> String.concat "\n"

    | Expr.Call(callee, callInfo, _, _) ->
        let calleeStr = dumpExpr nextIndent callee
        let thisArgStr =
            match callInfo.ThisArg with
            | Some thisArg ->
                [ sprintf "%sThisArg:" indentStr
                  dumpExpr nextIndent thisArg ]
                |> String.concat "\n"
            | None -> ""
        let argsStr =
            callInfo.Args
            |> List.map (dumpExpr nextIndent)
            |> String.concat "\n"

        [ sprintf "%s[Call]" indentStr
          sprintf "%sCallee:" indentStr
          calleeStr
          thisArgStr
          sprintf "%sArgs:" indentStr
          argsStr ]
        |> List.filter (fun s -> s <> "")
        |> String.concat "\n"

    | Expr.CurriedApply(callee, args, _, _) ->
        [ sprintf "%s[Apply]" indentStr
          sprintf "%sCallee:" indentStr
          dumpExpr nextIndent callee
          sprintf "%sArgs:" indentStr
          args |> List.map (dumpExpr nextIndent) |> String.concat "\n" ]
        |> String.concat "\n"

    | Expr.DecisionTree(scrutinee, targets) ->
        let scrutStr = dumpExpr nextIndent scrutinee
        let targetStrs =
            targets
            |> List.mapi (fun i (ids, body) ->
                let idStr = ids |> List.map (fun id -> id.Name) |> String.concat ", "
                [ sprintf "%sCase #%d (%s):" indentStr i idStr
                  dumpExpr nextIndent body ]
                |> String.concat "\n")
        [ sprintf "%s[Match]" indentStr
          scrutStr ]
        @ targetStrs
        |> String.concat "\n"

    | Expr.DecisionTreeSuccess(targetIndex, vals, _) ->
        [ sprintf "%s[DecisionTreeSuccess] target=%d" indentStr targetIndex
          vals |> List.map (dumpExpr nextIndent) |> String.concat "\n" ]
        |> String.concat "\n"

    | Expr.TryCatch(body, catch, fin, _) ->
        let bodyStr = dumpExpr nextIndent body
        let catchStr =
            match catch with
            | Some(exId, e) ->
                sprintf "%sCatch %s:\n%s" indentStr exId.Name (dumpExpr nextIndent e)
            | None -> ""
        let finStr =
            match fin with
            | Some e -> sprintf "%sFinally:\n%s" indentStr (dumpExpr nextIndent e)
            | None -> ""
        [ sprintf "%s[Try]" indentStr
          bodyStr
          catchStr
          finStr ]
        |> List.filter (fun s -> s <> "")
        |> String.concat "\n"

    | Expr.TypeCast(e, t) ->
        [ sprintf "%s[TypeCast] : %s" indentStr (typeToString t)
          dumpExpr nextIndent e ]
        |> String.concat "\n"

    | Expr.Get(e, _, t, _) ->
        [ sprintf "%s[Get] : %s" indentStr (typeToString t)
          dumpExpr nextIndent e ]
        |> String.concat "\n"

    | Expr.Set(e, _, t, v, _) ->
        [ sprintf "%s[Set] : %s" indentStr (typeToString t)
          sprintf "%sTarget:" indentStr
          dumpExpr nextIndent e
          sprintf "%sValue:" indentStr
          dumpExpr nextIndent v ]
        |> String.concat "\n"

    | Expr.Test(e, testKind, _) ->
        [ sprintf "%s[Test] %A" indentStr testKind
          dumpExpr nextIndent e ]
        |> String.concat "\n"

    | Expr.Import(info, t, _) ->
        sprintf "%s[Import] %A : %s" indentStr info (typeToString t)

    | Expr.Emit(info, t, _) ->
        sprintf "%s[Emit] %A : %s" indentStr info (typeToString t)

    | Expr.Extended(kind, _) ->
        sprintf "%s[Extended] %A : %s" indentStr kind (typeToString kind.Type)

    | Expr.ObjectExpr(members, t, baseCall) ->
        let baseStr =
            match baseCall with
            | Some b ->
                [ sprintf "%sBaseCall:" indentStr
                  dumpExpr nextIndent b ]
                |> String.concat "\n"
            | None -> ""
        let memberStrs =
            members
            |> List.map (fun m ->
                let args = m.Args |> List.map (fun a -> a.Name) |> String.concat ", "
                [ sprintf "%sMember %s(%s):" indentStr m.Name args
                  dumpExpr nextIndent m.Body ]
                |> String.concat "\n")
            |> String.concat "\n"

        [ sprintf "%s[ObjectExpr] : %s" indentStr (typeToString t)
          baseStr
          memberStrs ]
        |> List.filter (fun s -> s <> "")
        |> String.concat "\n"

    | Expr.Unresolved(u, t, _) ->
        sprintf "%s[Unresolved] %A : %s" indentStr u (typeToString t)

    | Expr.Quote(q, isTyped, _) ->
        [ sprintf "%s[Quote] typed=%b" indentStr isTyped
          dumpExpr nextIndent q ]
        |> String.concat "\n"

    | Fable.Expr.Operation(kind, _tags, _ty, _range) ->
        let desc =
            match kind with
            | OperationKind.Binary(op, _, _) -> sprintf "Binary(%A)" op
            | OperationKind.Unary(op, _)     -> sprintf "Unary(%A)" op
            | OperationKind.Logical(op, _, _)-> sprintf "Logical(%A)" op
        sprintf "%sOperation(%s)" indentStr desc

/// Dump a function/member declaration.
let dumpFuncDecl (func: MemberDecl) : string =
    let sig_ = sprintf "[Function] %s" func.Name
    let paramStrs = func.Args |> List.map (fun arg -> sprintf "%s : %s" arg.Name (typeToString arg.Type))
    let paramList = String.concat ", " paramStrs
    let retType = typeToString func.Body.Type
    let header = sprintf "%s(%s) -> %s" sig_ paramList retType
    let body = dumpExpr 2 func.Body
    sprintf "%s\n%s" header body

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
