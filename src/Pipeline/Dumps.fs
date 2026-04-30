module WasmGc.Pipeline.Dumps

open System.IO
open System.Text
open Fable.AST.Fable
open WasmGc.Core.AST

module FableAstDump =

    let private dumpDecl (decl: Declaration) : string =
        match decl with
        | Declaration.MemberDeclaration md -> $"[member] {md.Name}"
        | Declaration.ClassDeclaration cd -> $"[class] {cd.Name}"
        | Declaration.ModuleDeclaration md -> $"[module] {md.Name}"
        | Declaration.ActionDeclaration _ -> "[action]"

    /// Minimal phase-0 dump writer kept local to the pipeline.
    let dumpToFile (outPath: string) (decls: Declaration list) : unit =
        let lines =
            [
                ";; phase0 fable declarations"
                yield! decls |> List.map dumpDecl
            ]

        File.WriteAllLines(outPath, lines)

module IrDump =

    let private pad (n: int) = String.replicate n " "

    let rec private dumpExpr (indent: int) (expr: WExpr) : string =
        let p = pad indent

        match expr with
        | WExpr.Const c -> $"{p}(const {c})"
        | WExpr.LocalGet(name, ty) -> $"{p}(local.get {name} : {ty})"
        | WExpr.GlobalGet(name, ty) -> $"{p}(global.get {name} : {ty})"
        | WExpr.Nop -> $"{p}nop"
        | WExpr.Sequence exprs ->
            let inner = exprs |> List.map (dumpExpr (indent + 2)) |> String.concat "\n"
            $"{p}(seq\n{inner}\n{p})"
        | WExpr.Let(name, value, body) ->
            $"{p}(let {name}\n{dumpExpr (indent + 2) value}\n{dumpExpr (indent + 2) body}\n{p})"
        | WExpr.LetMut(name, value, body) ->
            $"{p}(let-mut {name}\n{dumpExpr (indent + 2) value}\n{dumpExpr (indent + 2) body}\n{p})"
        | WExpr.If(cond, thenExpr, elseExpr, ty) ->
            $"{p}(if : {ty}\n{dumpExpr (indent + 2) cond}\n{dumpExpr (indent + 2) thenExpr}\n{dumpExpr (indent + 2) elseExpr}\n{p})"
        | _ ->
            // Keep a safe fallback for all other current/future IR nodes.
            $"{p}{expr}"

    let private dumpFuncDecl (f: WFuncDecl) : string =
        let sb = StringBuilder()
        sb.AppendLine($"(func {f.Name} (result {f.Result})") |> ignore

        for (n, t) in f.Params do
            sb.AppendLine($"  (param {n} {t})") |> ignore

        for (n, t) in f.Locals do
            sb.AppendLine($"  (local {n} {t})") |> ignore

        sb.AppendLine(dumpExpr 2 f.Body) |> ignore
        sb.AppendLine(")") |> ignore
        sb.ToString().TrimEnd()

    /// Minimal phase-3 IR dump writer kept local to the pipeline.
    let dumpToFile (outPath: string) (wmod: WModule) : unit =
        let content =
            wmod.Functions
            |> List.map dumpFuncDecl
            |> String.concat "\n\n"

        File.WriteAllText(outPath, content)
