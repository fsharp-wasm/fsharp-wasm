/// Phase 1: Scope Analysis for Fable AST.
///
/// Builds a ScopeMap: for each identifier reference, determine whether it's:
/// - Local: bound by Let/Lambda in the current scope
/// - FreeVar: bound outside the current scope (crossed lambda boundary)
/// - ModuleValue: zero-arg module-level function (no params, can be inlined as direct call)
/// - KnownFunc: registered function from ctx.KnownFuncs
///
/// This is a single-pass analysis, run ONCE per function before Phase 3 (Fable→WExpr transform).
/// Replaces scattered re-queries throughout transformExpr with one upfront map.
module WasmGc.Pipeline.ScopeAnalyzer

open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Scope analysis core
// ─────────────────────────────────────────────────────────────────

/// Analyze one Fable expression to collect all identifier bindings and their scopes.
///
/// Pass 1: Collect all Let/Lambda bindings with their depths.
/// Result: Map<name, {Kind, WType, Depth}>.
let analyzeScopeOfExpr (_ctx: Ctx) (expr: Expr) : ScopeMap =
    let rec analyzeExpr (depth: int) (localBindings: ScopeMap) (e: Expr) : ScopeMap =
        match e with
        // ── Binding sites ──
        | Let(ident, value, body) ->
            let bindings = analyzeExpr depth localBindings value

            let bindings' =
                bindings.Add(
                    ident.Name,
                    {
                        Kind = ScopeKind.Local
                        WType = WType.I32 // placeholder; refined by later phases
                        Depth = depth
                    }
                )

            analyzeExpr depth bindings' body

        | LetRec(bindingList, body) ->
            let names = bindingList |> List.map (fun (id, _) -> id.Name)

            let bindings' =
                names
                |> List.fold
                    (fun (acc: ScopeMap) name ->
                        acc.Add(
                            name,
                            {
                                Kind = ScopeKind.Local
                                WType = WType.I32
                                Depth = depth
                            }
                        ))
                    localBindings

            let bindings'' =
                bindingList
                |> List.fold (fun (acc: ScopeMap) (_, bexpr) -> analyzeExpr depth acc bexpr) bindings'

            analyzeExpr depth bindings'' body

        | Lambda(arg, body, _) ->
            let bindings' =
                localBindings.Add(
                    arg.Name,
                    {
                        Kind = ScopeKind.Local
                        WType = WType.I32
                        Depth = depth + 1
                    }
                )

            analyzeExpr (depth + 1) bindings' body

        | Delegate(args, body, _, _) ->
            let bindings' =
                args
                |> List.fold
                    (fun (acc: ScopeMap) arg ->
                        acc.Add(
                            arg.Name,
                            {
                                Kind = ScopeKind.Local
                                WType = WType.I32
                                Depth = depth + 1
                            }
                        ))
                    localBindings

            analyzeExpr (depth + 1) bindings' body

        // ── Recursive structural traversal ──
        | Value(kind, _) ->
            match kind with
            | ValueKind.NewUnion(args, _, _, _)
            | ValueKind.NewRecord(args, _, _)
            | ValueKind.NewTuple(args, _)
            | ValueKind.NewAnonymousRecord(args, _, _, _) ->
                args |> List.fold (analyzeExpr depth) localBindings

            | ValueKind.NewArray(ArrayValues exprs, _, _) ->
                exprs |> List.fold (analyzeExpr depth) localBindings

            | ValueKind.NewArray(ArrayAlloc sizeExpr, _, _)
            | ValueKind.NewArray(ArrayFrom sizeExpr, _, _) ->
                analyzeExpr depth localBindings sizeExpr

            | ValueKind.NewOption(Some valueExpr, _, _) ->
                analyzeExpr depth localBindings valueExpr

            | ValueKind.NewList(Some(head, tail), _) ->
                let b1 = analyzeExpr depth localBindings head
                analyzeExpr depth b1 tail

            | ValueKind.NewList(None, _) ->
                localBindings

            | _ ->
                localBindings

        | TypeCast(inner, _) ->
            analyzeExpr depth localBindings inner

        | Operation(kind, _, _, _) ->
            match kind with
            | OperationKind.Binary(_, l, r) ->
                let b1 = analyzeExpr depth localBindings l
                analyzeExpr depth b1 r
            | OperationKind.Unary(_, opExpr) ->
                analyzeExpr depth localBindings opExpr
            | OperationKind.Logical(_, l, r) ->
                let b1 = analyzeExpr depth localBindings l
                analyzeExpr depth b1 r
            // TODO: never reached
            // | _ -> localBindings

        | Call(callee, info, _, _) ->
            let bindings = analyzeExpr depth localBindings callee

            let bindings' =
                match info.ThisArg with
                | Some thisArg -> analyzeExpr depth bindings thisArg
                | None -> bindings

            info.Args |> List.fold (analyzeExpr depth) bindings'

        | CurriedApply(callee, args, _, _) ->
            let bindings = analyzeExpr depth localBindings callee
            args |> List.fold (analyzeExpr depth) bindings

        | IfThenElse(g, t, f, _) ->
            let b1 = analyzeExpr depth localBindings g
            let b2 = analyzeExpr depth b1 t
            analyzeExpr depth b2 f

        | Sequential exprs ->
            exprs |> List.fold (analyzeExpr depth) localBindings

        | WhileLoop(g, body, _) ->
            let b1 = analyzeExpr depth localBindings g
            analyzeExpr depth b1 body

        | ForLoop(ident, startExpr, endExpr, body, _, _) ->
            let b1 = analyzeExpr depth localBindings startExpr
            let b2 = analyzeExpr depth b1 endExpr

            let b3 =
                b2.Add(
                    ident.Name,
                    {
                        Kind = ScopeKind.Local
                        WType = WType.I32
                        Depth = depth
                    }
                )

            analyzeExpr depth b3 body

        | Get(target, _, _, _) ->
            analyzeExpr depth localBindings target

        | Set(target, _, _, valueExpr, _) ->
            let b1 = analyzeExpr depth localBindings target
            analyzeExpr depth b1 valueExpr

        | Test(target, _, _) ->
            analyzeExpr depth localBindings target

        | DecisionTree(scrutinee, targets) ->
            let b1 = analyzeExpr depth localBindings scrutinee

            targets
            |> List.fold
                (fun (acc: ScopeMap) (idents, body) ->
                    let acc' =
                        idents
                        |> List.fold
                            (fun (sacc: ScopeMap) id ->
                                sacc.Add(
                                    id.Name,
                                    {
                                        Kind = ScopeKind.Local
                                        WType = WType.I32
                                        Depth = depth
                                    }
                                ))
                            acc

                    analyzeExpr depth acc' body)
                b1

        | DecisionTreeSuccess(_, vals, _) ->
            vals |> List.fold (analyzeExpr depth) localBindings

        | TryCatch(body, catch, finalizer, _) ->
            let b1 = analyzeExpr depth localBindings body

            let b2 =
                match catch with
                | Some(catchId, catchExpr) ->
                    let withCatch =
                        b1.Add(
                            catchId.Name,
                            {
                                Kind = ScopeKind.Local
                                WType = WType.I32
                                Depth = depth
                            }
                        )

                    analyzeExpr depth withCatch catchExpr
                | None ->
                    b1

            match finalizer with
            | Some finExpr -> analyzeExpr depth b2 finExpr
            | None -> b2

        | IdentExpr _ ->
            localBindings

        | _ ->
            localBindings

    analyzeExpr 0 Map.empty expr

/// Classify an identifier and return its ScopeEntry.
///
/// Logic:
/// 1) localBindings
/// 2) known functions from ctx.KnownFuncs
/// 3) fallback to Local/I32
let classifyIdent (name: string) (localBindings: ScopeMap) (ctx: Ctx) : ScopeEntry =
    match localBindings.TryFind(name) with
    | Some entry -> entry
    | None ->
        match ctx.KnownFuncs.TryFind(name) with
        | Some(fnParams, resultTy) when List.isEmpty fnParams ->
            {
                Kind = ScopeKind.KnownFunc
                WType = resultTy
                Depth = 0
            }
        | Some(_, resultTy) ->
            {
                Kind = ScopeKind.KnownFunc
                WType = resultTy
                Depth = 0
            }
        | None ->
            {
                Kind = ScopeKind.Local
                WType = WType.I32
                Depth = 0
            }

/// Promote Local entries to FreeVar when captured across lambda boundary.
let markFreeVars (lambdaDepth: int) (entries: ScopeMap) : ScopeMap =
    entries
    |> Map.map (fun _ entry ->
        if entry.Depth < lambdaDepth && entry.Kind = ScopeKind.Local then
            { entry with Kind = ScopeKind.FreeVar }
        else
            entry)

/// Analyze all declarations in a module to build function scope maps.
let analyzeModuleScope (ctx: Ctx) (decls: Declaration list) : Map<string, ScopeMap> =
    decls
    |> List.choose (fun decl ->
        match decl with
        | MemberDeclaration md ->
            let scope = analyzeScopeOfExpr ctx md.Body
            Some(md.Name, scope)
        | _ -> None)
    |> Map.ofList
