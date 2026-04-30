module WasmGc.Pipeline.Dumps

open System.IO
open Fable.AST.Fable
open WasmGc.Core.AST

module FableAstDump =

    let private declHeader (decl: Declaration) : string =
        match decl with
        | Declaration.MemberDeclaration md -> $"[member] {md.Name}"
        | Declaration.ClassDeclaration cd -> $"[class] {cd.Name}"
        | Declaration.ModuleDeclaration md -> $"[module] {md.Name}"
        | Declaration.ActionDeclaration _ -> "[action]"

    let dumpToFile (outPath: string) (decls: Declaration list) : unit =
        let lines =
            [
                ";; Phase 0 Fable AST dump"
                yield! decls |> List.map declHeader
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
        | WExpr.GlobalSet(name, value) ->
            $"{p}(global.set {name}\n{dumpExpr (indent + 2) value}\n{p})"
        | WExpr.Let(name, value, body) ->
            $"{p}(let {name}\n{dumpExpr (indent + 2) value}\n{dumpExpr (indent + 2) body}\n{p})"
        | WExpr.LetMut(name, value, body) ->
            $"{p}(let-mut {name}\n{dumpExpr (indent + 2) value}\n{dumpExpr (indent + 2) body}\n{p})"
        | WExpr.Assign(name, value) ->
            $"{p}(set {name}\n{dumpExpr (indent + 2) value}\n{p})"
        | WExpr.Sequence exprs ->
            let inner = exprs |> List.map (dumpExpr (indent + 2)) |> String.concat "\n"
            $"{p}(seq\n{inner}\n{p})"
        | WExpr.If(cond, thenExpr, elseExpr, ty) ->
            $"{p}(if : {ty}\n{dumpExpr (indent + 2) cond}\n{dumpExpr (indent + 2) thenExpr}\n{dumpExpr (indent + 2) elseExpr}\n{p})"
        | WExpr.Block(label, body, ty) ->
            $"{p}(block {label} : {ty}\n{dumpExpr (indent + 2) body}\n{p})"
        | WExpr.Loop(label, body, ty) ->
            $"{p}(loop {label} : {ty}\n{dumpExpr (indent + 2) body}\n{p})"
        | WExpr.Break(label, valueOpt) ->
            match valueOpt with
            | Some value -> $"{p}(break {label}\n{dumpExpr (indent + 2) value}\n{p})"
            | None -> $"{p}(break {label})"
        | WExpr.Continue(label, args) ->
            let inner = args |> List.map (dumpExpr (indent + 2)) |> String.concat "\n"
            if System.String.IsNullOrEmpty(inner) then $"{p}(continue {label})"
            else $"{p}(continue {label}\n{inner}\n{p})"
        | WExpr.Return valueOpt ->
            match valueOpt with
            | Some value -> $"{p}(return\n{dumpExpr (indent + 2) value}\n{p})"
            | None -> $"{p}(return)"
        | WExpr.Nop -> $"{p}nop"
        | _ -> $"{p}{expr}"

    let private dumpFuncDecl (f: WFuncDecl) : string =
        let paramLines =
            f.Params
            |> List.map (fun (name, ty) -> $"  (param {name} {ty})")

        let localLines =
            f.Locals
            |> List.map (fun (name, ty) -> $"  (local {name} {ty})")

        let body = dumpExpr 2 f.Body

        String.concat "\n" (
            [
                $"(func {f.Name} (result {f.Result})"
                yield! paramLines
                yield! localLines
                body
                ")"
            ]
        )

    let dumpToFile (outPath: string) (wmod: WModule) : unit =
        let content =
            wmod.Functions
            |> List.map dumpFuncDecl
            |> String.concat "\n\n"

        File.WriteAllText(outPath, content)
