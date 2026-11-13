/// Free variable analysis for lambda body capture computation.
/// Extracted from Fable2Wasm.fs — purely functional, no WExpr dependency.
///
/// COMPLETENESS MATTERS: a variable that is referenced but missed here is not captured by
/// the closure.  The lifted function then reads an *unbound* local — silently 0/null for
/// numeric / nullable types (wrong results, e.g. `fun j -> arr.[i]` read index 0), or an
/// invalid module for non-nullable references.  The match on `Fable.Expr` below therefore has
/// no wildcard: when Fable adds an expression form the compiler flags this function.
module WasmGc.Runtime.FreeVars

open Fable.AST
open Fable.AST.Fable

let private unionMany (xs: seq<Set<string>>) = Set.unionMany xs

/// Collect all free variable names from a Fable expression — names that
/// are referenced but not bound within the expression itself.
let rec collectFreeVars (bound: Set<string>) (expr: Fable.Expr) : Set<string> =
    let go = collectFreeVars bound
    let goAll es = es |> List.map go |> unionMany
    let goOpt = Option.map go >> Option.defaultValue Set.empty
    match expr with
    | Fable.Expr.IdentExpr ident ->
        if Set.contains ident.Name bound then Set.empty else Set.singleton ident.Name
    | Fable.Expr.Import _ -> Set.empty
    | Fable.Expr.Value(kind, _) ->
        match kind with
        | Fable.ValueKind.NewUnion(args, _, _, _)
        | Fable.ValueKind.NewRecord(args, _, _)
        | Fable.ValueKind.NewAnonymousRecord(args, _, _, _)
        | Fable.ValueKind.NewTuple(args, _) -> goAll args
        | Fable.ValueKind.NewArray(Fable.ArrayValues exprs, _, _) -> goAll exprs
        | Fable.ValueKind.NewArray(Fable.ArrayAlloc e, _, _)
        | Fable.ValueKind.NewArray(Fable.ArrayFrom e, _, _) -> go e
        | Fable.ValueKind.NewOption(e, _, _) -> goOpt e
        | Fable.ValueKind.NewList(Some(h, t), _) -> Set.union (go h) (go t)
        // `$"…{x}…"` — the interpolated values are real expressions.
        | Fable.ValueKind.StringTemplate(tag, _, values) -> Set.union (goOpt tag) (goAll values)
        | Fable.ValueKind.BaseValue(Some id, _) -> if Set.contains id.Name bound then Set.empty else Set.singleton id.Name
        // `this` in a constructor body is the local `$this` (the instance under construction): a closure created there
        // captures it like any other local; where there is no such local it is not a capture (see isCapturable)
        | Fable.ValueKind.ThisValue _ -> if Set.contains "$this" bound then Set.empty else Set.singleton "$this"
        | Fable.ValueKind.NewList(None, _)
        | Fable.ValueKind.BaseValue(None, _)
        | Fable.ValueKind.TypeInfo _
        | Fable.ValueKind.Null _
        | Fable.ValueKind.UnitConstant
        | Fable.ValueKind.BoolConstant _
        | Fable.ValueKind.CharConstant _
        | Fable.ValueKind.StringConstant _
        | Fable.ValueKind.NumberConstant _
        | Fable.ValueKind.RegexConstant _ -> Set.empty
    | Fable.Expr.Lambda(arg, body, _) -> collectFreeVars (Set.add arg.Name bound) body
    | Fable.Expr.Delegate(args, body, _, _) ->
        collectFreeVars (args |> List.fold (fun acc a -> Set.add a.Name acc) bound) body
    | Fable.Expr.ObjectExpr(members, _, baseCall) ->
        let fvMembers =
            members
            |> List.map (fun m ->
                collectFreeVars (m.Args |> List.fold (fun acc a -> Set.add a.Name acc) bound) m.Body)
            |> unionMany
        Set.union fvMembers (goOpt baseCall)
    | Fable.Expr.TypeCast(e, _) -> go e
    | Fable.Expr.Test(e, _, _) -> go e
    | Fable.Expr.Call(callee, info, _, _) ->
        unionMany [ go callee; goOpt info.ThisArg; goAll info.Args ]
    | Fable.Expr.CurriedApply(callee, args, _, _) -> Set.union (go callee) (goAll args)
    | Fable.Expr.Operation(kind, _, _, _) ->
        match kind with
        | Fable.OperationKind.Unary(_, x) -> go x
        | Fable.OperationKind.Binary(_, l, r)
        | Fable.OperationKind.Logical(_, l, r) -> Set.union (go l) (go r)
    | Fable.Expr.Emit(info, _, _) -> Set.union (goOpt info.CallInfo.ThisArg) (goAll info.CallInfo.Args)
    | Fable.Expr.DecisionTree(e, targets) ->
        let fvTargets =
            targets
            |> List.map (fun (idents, body) ->
                collectFreeVars (idents |> List.fold (fun acc id -> Set.add id.Name acc) bound) body)
            |> unionMany
        Set.union (go e) fvTargets
    | Fable.Expr.DecisionTreeSuccess(_, vals, _) -> goAll vals
    | Fable.Expr.Let(ident, value, body) ->
        Set.union (go value) (collectFreeVars (Set.add ident.Name bound) body)
    | Fable.Expr.LetRec(bindings, body) ->
        let bound' = bindings |> List.fold (fun acc (id, _) -> Set.add id.Name acc) bound
        let fvBindings = bindings |> List.map (fun (_, e) -> collectFreeVars bound' e) |> unionMany
        Set.union fvBindings (collectFreeVars bound' body)
    | Fable.Expr.Get(e, kind, _, _) ->
        match kind with
        | Fable.GetKind.ExprGet idx -> Set.union (go e) (go idx)   // arr.[i] — `i` is a free variable too
        | Fable.GetKind.TupleIndex _
        | Fable.GetKind.FieldGet _
        | Fable.GetKind.UnionField _
        | Fable.GetKind.UnionTag
        | Fable.GetKind.ListHead
        | Fable.GetKind.ListTail
        | Fable.GetKind.OptionValue -> go e
    | Fable.Expr.Set(e, kind, _, v, _) ->
        match kind with
        | Fable.SetKind.ExprSet idx -> unionMany [ go e; go idx; go v ]
        | Fable.SetKind.FieldSet _
        | Fable.SetKind.ValueSet -> Set.union (go e) (go v)
    | Fable.Expr.Sequential es -> goAll es
    | Fable.Expr.WhileLoop(g, b, _) -> Set.union (go g) (go b)
    | Fable.Expr.ForLoop(ident, s, e, body, _, _) ->
        unionMany [ go s; go e; collectFreeVars (Set.add ident.Name bound) body ]
    | Fable.Expr.TryCatch(body, catch, fin, _) ->
        let fvCatch =
            match catch with
            | Some(ident, e) -> collectFreeVars (Set.add ident.Name bound) e
            | None -> Set.empty
        unionMany [ go body; fvCatch; goOpt fin ]
    | Fable.Expr.IfThenElse(g, t, e, _) -> unionMany [ go g; go t; go e ]
    // `<@ … x … @>`: variables of the enclosing scope used inside a quotation are captured as values,
    // so they are free variables of the closure that builds the quotation.
    | Fable.Expr.Quote(quoted, _, _) -> go quoted
    // Unresolved forms only exist in precompiled inline functions and are normally gone before code
    // generation; if one survives, its sub-expressions are still real uses.
    | Fable.Expr.Unresolved(u, _, _) ->
        match u with
        | Fable.UnresolvedExpr.UnresolvedTraitCall(_, _, _, _, argExprs) -> goAll argExprs
        | Fable.UnresolvedExpr.UnresolvedReplaceCall(thisArg, args, _, attached) ->
            unionMany [ goOpt thisArg; goAll args; goOpt attached ]
        | Fable.UnresolvedExpr.UnresolvedInlineCall(_, witnesses, callee, info) ->
            unionMany [ goAll (witnesses |> List.map (fun w -> w.Expr)); goOpt callee; goOpt info.ThisArg; goAll info.Args ]
    | Fable.Expr.Extended(kind, _) ->
        match kind with
        | Fable.ExtendedSet.Throw(e, _) -> goOpt e          // `raise (E msg)` captures msg
        | Fable.ExtendedSet.Curry(e, _) -> go e
        | Fable.ExtendedSet.Debugger -> Set.empty
