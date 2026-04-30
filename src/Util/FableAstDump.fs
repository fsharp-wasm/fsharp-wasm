/// TEIL 2: FableAstDump — Debug output for Phase 0 (Fable AST input).
///
/// Generates F#-like pseudo-code with type annotations for readable debugging.
/// Not actual F# (too verbose), but human-readable structure showing:
/// - Function signatures
/// - Let bindings with types
/// - Control flow (if, while, for, match)
/// - Lambda expressions
/// - Method calls
///
/// Enable via --dump-phases 0 CLI flag.
module WasmGc.Pipeline.Dumps.FableAstDump

open System.Text
open System.IO
open Fable.AST.Fable

// ─────────────────────────────────────────────────────────────────
// Type annotation helpers
// ─────────────────────────────────────────────────────────────────

let rec typeToString (ty: Type) : string =
    match ty with
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
        | NumberKind.Float32 -> "f32"
        | NumberKind.Float64 -> "f64"
        | _ -> "num"
    | Type.String -> "string"
    | Type.Boolean -> "bool"
    | Type.Function(args, ret, _) ->
        let argStrs = args |> List.map typeToString |> String.concat " -> "
        sprintf "(%s -> %s)" argStrs (typeToString ret)
    | Type.Array(elemTy, _) -> sprintf "%s[]" (typeToString elemTy)
    | Type.List elemTy -> sprintf "list<%s>" (typeToString elemTy)
    | Type.Option elemTy -> sprintf "%s option" (typeToString elemTy)
    | Type.Tuple(elemTys, _) ->
        elemTys |> List.map typeToString |> String.concat " * " |> sprintf "(%s)"
    | Type.Any -> "any"
    | Type.Unit -> "unit"
    | _ -> "?"

// ─────────────────────────────────────────────────────────────────
// AST formatting
// ─────────────────────────────────────────────────────────────────

let rec dumpExpr (indent: int) (expr: Expr) : string =
    let indentStr = String.replicate indent " "
    let nextIndent = indent + 2

    match expr with
    | Expr.IdentExpr ident ->
        sprintf "%s[Ident] %s : %s" indentStr ident.Name (typeToString ident.Type)

    | Expr.Value(kind, ty) ->
        match kind with
        | ValueKind.UnitConstant -> sprintf "%s[Unit]" indentStr
        | ValueKind.BoolConstant b -> sprintf "%s[Bool] %b" indentStr b
        | ValueKind.NumberConstant(n, _, _) -> sprintf "%s[Num] %A" indentStr n
        | ValueKind.StringConstant s -> sprintf "%s[Str] \"%s\"" indentStr s
        | _ -> sprintf "%s[Value] : %s" indentStr (typeToString ty)

    | Expr.Let(ident, value, body) ->
        let indent' = indentStr
        [ sprintf "%slet %s : %s =" indent' ident.Name (typeToString ident.Type)
          dumpExpr nextIndent value
          dumpExpr indent body ]
        |> String.concat "\n"

    | Expr.LetRec(bindings, body) ->
        let bindStrs =
            bindings
            |> List.map (fun (id, e) ->
                sprintf "%sand %s : %s =" indentStr id.Name (typeToString id.Type))
        let bindExprs = bindings |> List.map (fun (_, e) -> dumpExpr nextIndent e)
        let header = String.concat "\n" (List.head bindStrs :: List.tail bindStrs)
        [ sprintf "%slet rec" indentStr
          header
          String.concat "\n" bindExprs
          dumpExpr indent body ]
        |> String.concat "\n"

    | Expr.Lambda(arg, body, _) ->
        [ sprintf "%s[Lambda] fun %s : %s ->" indentStr arg.Name (typeToString arg.Type)
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.IfThenElse(guard, thenExpr, elseExpr, ty) ->
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

    | Expr.ForLoop(ident, start, end_, body, _, _) ->
        [ sprintf "%s[For] %s : %s in" indentStr ident.Name (typeToString ident.Type)
          dumpExpr nextIndent start
          sprintf "%s.." indentStr
          dumpExpr nextIndent end_
          sprintf "%sBody:" indentStr
          dumpExpr nextIndent body ]
        |> String.concat "\n"

    | Expr.Sequential exprs ->
        [ sprintf "%s[Seq]" indentStr
          exprs |> List.map (dumpExpr nextIndent) |> String.concat "\n" ]
        |> String.concat "\n"

    | Expr.Call(callee, callInfo, _, _) ->
        let calleeStr = dumpExpr nextIndent callee
        let argsStr = callInfo.Args |> List.map (dumpExpr nextIndent) |> String.concat "\n"
        [ sprintf "%s[Call]" indentStr
          sprintf "%sCallee:" indentStr
          calleeStr
          sprintf "%sArgs:" indentStr
          argsStr ]
        |> String.concat "\n"

    | Expr.CurriedApply(callee, args, _, _) ->
        let calleeStr = dumpExpr nextIndent callee
        let argsStr = args |> List.map (dumpExpr nextIndent) |> String.concat "\n"
        [ sprintf "%s[Apply]" indentStr
          calleeStr
          argsStr ]
        |> String.concat "\n"

    | Expr.DecisionTree(scrutinee, targets) ->
        let scrutStr = dumpExpr nextIndent scrutinee
        let targetStrs =
            targets
            |> List.mapi (fun i (ids, body) ->
                let idStr = ids |> List.map (fun id -> id.Name) |> String.concat ", "
                sprintf "%sCase (%s):" indentStr idStr
                + "\n" + dumpExpr nextIndent body)
        [ sprintf "%s[Match]" indentStr
          scrutStr ]
        @ targetStrs
        |> String.concat "\n"

    | Expr.TryCatch(body, catch, fin, _) ->
        let bodyStr = dumpExpr nextIndent body
        let catchStr = match catch with
            | Some(exId, e) -> sprintf "%sCatch %s:\n%s" indentStr exId.Name (dumpExpr nextIndent e)
            | None -> ""
        let finStr = match fin with
            | Some e -> sprintf "%sFinally:\n%s" indentStr (dumpExpr nextIndent e)
            | None -> ""
        [ sprintf "%s[Try]" indentStr; bodyStr; catchStr; finStr ]
        |> List.filter (fun s -> s <> "")
        |> String.concat "\n"

    | _ ->
        sprintf "%s[%s]" indentStr (expr.GetType().Name)


/// Dump a function declaration.
let dumpFuncDecl (func: MemberDeclaration) : string =
    let sig_ = sprintf "[Function] %s" func.Name
    let paramStrs = func.Arguments |> List.map (fun arg -> sprintf "%s : %s" arg.Name (typeToString arg.Type))
    let paramList = String.concat ", " paramStrs
    let retType = typeToString func.ReturnType
    let header = sprintf "%s(%s) -> %s" sig_ paramList retType
    let body = dumpExpr 2 func.Value
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
