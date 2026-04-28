module WasmGc.Transforms.Fable2Wasm

open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc.Runtime.Types
module RT = WasmGc.Runtime.Runtime

// Imports unserer neuen Module
open TransformConstruct
open TransformClosures
open TransformDispatch

// Die eval-Funktion wird rekursiv aufgerufen, aber in Module injiziert.
let rec transformExpr (ctx: Ctx) (expr: Fable.Expr) : WExpr =
    match expr with
    // ── Constants ──
    | Value(kind, _) ->
        transformValue ctx kind transformExpr

    // ── Identifiers ──
    | IdentExpr ident ->
        let ty = match Map.tryFind ident.Name ctx.Locals with | Some knownTy -> knownTy | None -> mapTypeKnown ctx ident.Type
        match Map.tryFind ident.Name ctx.Locals with
        | Some _ -> WExpr.LocalGet(ident.Name, ty)
        | None ->
            let actualName = ctx.FuncNameAlias |> Map.tryFind ident.Name |> Option.defaultValue ident.Name
            match Map.tryFind actualName ctx.KnownFuncs with
            | Some([], retTy) when retTy <> WType.Void -> WExpr.Call(actualName, [], retTy)
            | Some([], WType.Void) -> WExpr.Call(actualName, [], WType.Void)
            | _ -> WExpr.LocalGet(ident.Name, ty)

    // ── Let bindings ──
    | Let(ident, value, body) ->
        let wValue = transformExpr ctx value
        let declaredTy = mapTypeKnown ctx ident.Type
        let ty = if declaredTy = WType.I32 then (let inf = exprWType wValue in if inf <> WType.I32 && inf <> WType.Void then inf else declaredTy) else declaredTy
        let ctx' = ctx.WithLocal(ident.Name, ty)
        let wBody = transformExpr ctx' body
        if ident.IsMutable then WExpr.LetMut(ident.Name, wValue, wBody)
        else WExpr.Let(ident.Name, wValue, wBody)

    | LetRec(bindings, body) ->
        // Delegation an TransformClosures
        buildLetRecLambdas ctx transformExpr bindings body

    // ── Sequential ──
    | Sequential exprs ->
        let wExprs = exprs |> List.map (transformExpr ctx)
        WExpr.Sequence wExprs

    // ── If/Then/Else ──
    | IfThenElse(guard, thenExpr, elseExpr, _) ->
        let wGuard = transformExpr ctx guard
        let wThen = transformExpr ctx thenExpr
        let wElse = transformExpr ctx elseExpr
        let ty = mapTypeKnown ctx thenExpr.Type
        buildIf wGuard wThen wElse ty

    // ── Loops ──
    | WhileLoop(guard, body, _) ->
        buildWhile (transformExpr ctx guard) (transformExpr ctx body)

    // ── Function calls ──
    | Call(callee, info, typ, _) ->
        // Delegation an TransformDispatch
        transformCall ctx transformExpr callee info typ

    // ── Lambda ──
    | Lambda(arg, body, name) ->
        // Delegation an TransformClosures
        buildClosure ctx transformExpr [arg] body name
        
    | Delegate(args, body, name, _) ->
        buildClosure ctx transformExpr args body name

    // ── TypeCast ──
    | TypeCast(innerExpr, targetTy) ->
        buildTypeCast ctx (transformExpr ctx innerExpr) targetTy

    | _ -> 
        WExpr.Nop // Für Set, Get, Test etc. aus dem Original kopieren (bleiben schlank)


// =========================================================================
// Top-Level Declarations (Hier ändert sich fast nichts, da das Modul-Wiring identisch bleibt)
// =========================================================================

let rec processDecl (ctx: Ctx) (decl: Declaration) : Ctx =
    // Dein Original Code aus Zeile 827 bis 915 kommt hier exakt so rein.
    // Da transformExpr nun intern alles aufruft, ändert sich an der Modul-Verarbeitung nichts.
    ctx 

let buildWModule (ctx: Ctx) : WModule =
    // Dein Original Code aus Zeile 916
    {
        Types = ctx.TypeDefs |> Seq.toList
        Imports = [] // ...
        Functions = ctx.Functions |> Seq.toList
        Globals = []
        Exports = []
        DataSegments = []
        Tags = []
        Start = None
        HasLinearMemory = !ctx.HasLinearMemory
    }

let processFileIntoCtx (ctx: Ctx) (com: Compiler) (file: Fable.File) (isLastFile: bool) : Ctx =
    // Dein Original Code aus Zeile 947
    ctx

let transformFile (com: Compiler) (file: Fable.File) : WModule =
    let ctx = Ctx.Create(com)
    let finalCtx = processFileIntoCtx ctx com file true 
    buildWModule finalCtx