module WasmGc.Transforms.TransformMemberDecl

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder

// ─────────────────────────────────────────────────────────────────
// Declaration translation
// ─────────────────────────────────────────────────────────────────

/// Transform a single Fable member declaration into a WasmIR function
let transformMemberDecl
    (ctx: Ctx)
    (eval: Ctx -> Fable.Expr -> WExpr)
    (decl: MemberDecl) : WFuncDecl =
    // Filter out unit parameters — WASM has no void param type.
    // Use mapTypeKnown to resolve record/DU params to GC struct refs.
    let params' =
        decl.Args
        |> List.choose (fun a ->
            let ty = mapTypeKnown ctx a.Type
            if ty = WType.Void then None
            else Some(a.Name, ty))
    let ctx' =
        (ctx, decl.Args)
        ||> List.fold (fun c a -> c.WithLocal(a.Name, mapTypeKnown ctx a.Type))
    let ctx' = { ctx' with CurrentFunc = Some decl.Name }
    let wBody = eval ctx' decl.Body // TODO: we should do this before we enter?!
    // Compute resultType AFTER body translation — the body may register DU types on-demand
    // (e.g. NewUnion for Result<T,E>) that must be visible for mapResultTypeKnown to return
    // the correct Ref type rather than the i32 fallback.
    let resultType = mapResultTypeKnown ctx decl.Body.Type

    // Tail call optimization: rewrite Call(f, args, t) in tail position to TailCall.
    // return_call reuses the current stack frame — critical for mutual recursion and
    // any deep call chain that Fable didn't already convert to a loop.
    // Only applies to non-void functions (void functions use return with no value).
    let rec markTailCalls (expr: WExpr) : WExpr =
        match expr with
        | WExpr.Call(f, args, t) when t = resultType && not (f.StartsWith("$")) ->
            WExpr.TailCall(f, args, t)
        | WExpr.Let(name, value, body) -> WExpr.Let(name, value, markTailCalls body)
        | WExpr.LetMut(name, value, body) -> WExpr.LetMut(name, value, markTailCalls body)
        | WExpr.If(cond, then_, else_, t) ->
            WExpr.If(cond, markTailCalls then_, markTailCalls else_, t)
        | WExpr.Sequence exprs when exprs.Length > 0 ->
            let init = exprs |> List.take (exprs.Length - 1)
            WExpr.Sequence(init @ [markTailCalls (List.last exprs)])
        | WExpr.JoinPoint(lbl, parms, body, cont, t) ->
            WExpr.JoinPoint(lbl, parms, body, markTailCalls cont, t)
        | _ -> expr
    let wBody =
        if resultType <> WType.Void
        then markTailCalls wBody
        else wBody
    {
        Name = decl.Name
        Params = params'
        Result = resultType
        Locals = [] // filled in later by local collection pass
        Body = wBody
        Exported = true // export all top-level functions for now
    }
