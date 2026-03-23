/// Free variable analysis for lambda body capture computation.
/// Extracted from Fable2WasmGc.fs — purely functional, no WExpr dependency.
module Fable.Transforms.WasmGc.WasmGcFreeVars

open Fable.AST
open Fable.AST.Fable

// ─────────────────────────────────────────────────────────────────
// Free variable analysis
// ─────────────────────────────────────────────────────────────────

/// Collect all free variable names from a Fable expression — names that
/// are referenced but not bound within the expression itself.
let rec collectFreeVars (bound: Set<string>) (expr: Fable.Expr) : Set<string> =
    match expr with
    | Fable.Expr.IdentExpr ident ->
        if Set.contains ident.Name bound then Set.empty
        else Set.singleton ident.Name
    | Fable.Expr.Let(ident, value, body) ->
        let fv = collectFreeVars bound value
        let bound' = Set.add ident.Name bound
        Set.union fv (collectFreeVars bound' body)
    | Fable.Expr.LetRec(bindings, body) ->
        let bound' = bindings |> List.fold (fun acc (id, _) -> Set.add id.Name acc) bound
        let fvBindings = bindings |> List.map (fun (_, e) -> collectFreeVars bound' e) |> Set.unionMany
        Set.union fvBindings (collectFreeVars bound' body)
    | Fable.Expr.Lambda(arg, body, _) ->
        collectFreeVars (Set.add arg.Name bound) body
    | Fable.Expr.Delegate(args, body, _, _) ->
        let bound' = args |> List.fold (fun acc a -> Set.add a.Name acc) bound
        collectFreeVars bound' body
    | Fable.Expr.Value _ -> Set.empty
    | Fable.Expr.TypeCast(e, _) -> collectFreeVars bound e
    | Fable.Expr.Operation(kind, _, _, _) ->
        match kind with
        | Fable.OperationKind.Binary(_, l, r) ->
            Set.union (collectFreeVars bound l) (collectFreeVars bound r)
        | Fable.OperationKind.Unary(_, op) -> collectFreeVars bound op
        | Fable.OperationKind.Logical(_, l, r) ->
            Set.union (collectFreeVars bound l) (collectFreeVars bound r)
    | Fable.Expr.Call(callee, info, _, _) ->
        let fvCallee = collectFreeVars bound callee
        let fvArgs = info.Args |> List.map (collectFreeVars bound) |> Set.unionMany
        Set.union fvCallee fvArgs
    | Fable.Expr.CurriedApply(callee, args, _, _) ->
        let fvCallee = collectFreeVars bound callee
        let fvArgs = args |> List.map (collectFreeVars bound) |> Set.unionMany
        Set.union fvCallee fvArgs
    | Fable.Expr.IfThenElse(g, t, e, _) ->
        collectFreeVars bound g |> Set.union (collectFreeVars bound t) |> Set.union (collectFreeVars bound e)
    | Fable.Expr.Sequential es ->
        es |> List.map (collectFreeVars bound) |> Set.unionMany
    | Fable.Expr.WhileLoop(g, b, _) ->
        Set.union (collectFreeVars bound g) (collectFreeVars bound b)
    | Fable.Expr.ForLoop(ident, s, e, body, _, _) ->
        let bound' = Set.add ident.Name bound
        [ collectFreeVars bound s; collectFreeVars bound e; collectFreeVars bound' body ]
        |> Set.unionMany
    | Fable.Expr.Get(e, _, _, _) -> collectFreeVars bound e
    | Fable.Expr.Set(e, _, _, v, _) ->
        Set.union (collectFreeVars bound e) (collectFreeVars bound v)
    | Fable.Expr.Test(e, _, _) -> collectFreeVars bound e
    | Fable.Expr.DecisionTree(e, targets) ->
        let fv = collectFreeVars bound e
        let fvTargets =
            targets |> List.map (fun (idents, body) ->
                let bound' = idents |> List.fold (fun acc id -> Set.add id.Name acc) bound
                collectFreeVars bound' body)
            |> Set.unionMany
        Set.union fv fvTargets
    | Fable.Expr.DecisionTreeSuccess(_, vals, _) ->
        vals |> List.map (collectFreeVars bound) |> Set.unionMany
    | Fable.Expr.TryCatch(body, catch, fin, _) ->
        let fvBody = collectFreeVars bound body
        let fvCatch =
            match catch with
            | Some(ident, e) -> collectFreeVars (Set.add ident.Name bound) e
            | None -> Set.empty
        let fvFin = fin |> Option.map (collectFreeVars bound) |> Option.defaultValue Set.empty
        [ fvBody; fvCatch; fvFin ] |> Set.unionMany
    | Fable.Expr.Import _ -> Set.empty
    | _ -> Set.empty
