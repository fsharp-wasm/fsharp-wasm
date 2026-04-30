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
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Scope entry and map types
// ─────────────────────────────────────────────────────────────────

/// Classify the scope origin of an identifier.
type ScopeKind =
    /// Bound locally (Let-binding or Lambda parameter) in the current function.
    | Local
    /// Bound outside current lambda — captured across boundary (becomes a free variable).
    | FreeVar
    /// Module-level zero-arg value or function — no parameters, can be direct call.
    | ModuleValue
    /// Known function (from ctx.KnownFuncs registry).
    | KnownFunc

/// Single scope entry: how an identifier is bound and what type it has.
type ScopeEntry = {
    Kind: ScopeKind
    WType: WType
    /// Lambda nesting depth where it's bound (0 = function top-level)
    Depth: int
}

/// Map from identifier name → scope information.
type ScopeMap = Map<string, ScopeEntry>

// ─────────────────────────────────────────────────────────────────
// Scope analysis core
// ─────────────────────────────────────────────────────────────────

/// Analyze one Fable expression to collect all identifier bindings and their scopes.
/// 
/// Pass 1: Collect all Let/Lambda bindings with their depths.
/// Result: Map<name, {Kind, WType, Depth}>.
let analyzeScopeOfExpr (ctx: Ctx) (expr: Expr) : ScopeMap =
    let rec analyzeExpr (depth: int) (localBindings: Map<string, ScopeEntry>) (expr: Expr) : Map<string, ScopeEntry> =
        match expr with
        // ── Binding sites ──
        
        | Let(ident, value, body) ->
            // Analyze the value first (outer scope)
            let bindings = analyzeExpr depth localBindings value
            // Add the bound name with current depth
            let bindings' = bindings.Add(ident.Name, {
                Kind = Local
                WType = WType.I32  // placeholder; real type comes from phase 2
                Depth = depth
            })
            // Analyze body with extended bindings
            analyzeExpr depth bindings' body

        | LetRec(bindingList, body) ->
            // All bound names are available at this depth
            let names = bindingList |> List.map (fun (id, _) -> id.Name)
            let bindings = localBindings
            let bindings' = names |> List.fold (fun acc name ->
                acc.Add(name, { Kind = Local; WType = WType.I32; Depth = depth })
            ) bindings
            // Analyze each binding value
            let bindings'' = bindingList |> List.fold (fun acc (_, e) ->
                analyzeExpr depth acc e
            ) bindings'
            // Analyze body
            analyzeExpr depth bindings'' body

        | Lambda(arg, body, _) ->
            // Lambda parameter is bound at next depth
            let param = { Kind = Local; WType = WType.I32; Depth = depth + 1 }
            let bindings' = localBindings.Add(arg.Name, param)
            analyzeExpr (depth + 1) bindings' body

        | Delegate(args, body, _, _) ->
            // All args are bound at next depth
            let bindings' = args |> List.fold (fun acc arg ->
                acc.Add(arg.Name, { Kind = Local; WType = WType.I32; Depth = depth + 1 })
            ) localBindings
            analyzeExpr (depth + 1) bindings' body

        // ── Recursive cases ──

        | Value(kind, _) ->
            match kind with
            | ValueKind.NewUnion(args, _, _, _)
            | ValueKind.NewRecord(args, _, _)
            | ValueKind.NewTuple(args, _)
            | ValueKind.NewAnonymousRecord(args, _, _, _) ->
                args |> List.fold (analyzeExpr depth) localBindings
            | ValueKind.NewArray(ArrayValues exprs, _, _) ->
                exprs |> List.fold (analyzeExpr depth) localBindings
            | ValueKind.NewArray(ArrayAlloc e, _, _)
            | ValueKind.NewArray(ArrayFrom e, _, _) ->
                analyzeExpr depth localBindings e
            | ValueKind.NewOption(Some e, _, _) ->
                analyzeExpr depth localBindings e
            | ValueKind.NewList(Some(head, tail), _) ->
                analyzeExpr depth localBindings head |> analyzeExpr depth <| tail
            | ValueKind.NewList(None, _) -> localBindings
            | _ -> localBindings

        | TypeCast(e, _) ->
            analyzeExpr depth localBindings e

        | Operation(kind, _, _, _) ->
            match kind with
            | OperationKind.Binary(_, l, r) ->
                analyzeExpr depth localBindings l |> analyzeExpr depth <| r
            | OperationKind.Unary(_, op) ->
                analyzeExpr depth localBindings op
            | OperationKind.Logical(_, l, r) ->
                analyzeExpr depth localBindings l |> analyzeExpr depth <| r

        | Call(callee, info, _, _) ->
            let bindings = analyzeExpr depth localBindings callee
            let bindings' = match info.ThisArg with Some e -> analyzeExpr depth bindings e | None -> bindings
            info.Args |> List.fold (analyzeExpr depth) bindings'

        | CurriedApply(callee, args, _, _) ->
            let bindings = analyzeExpr depth localBindings callee
            args |> List.fold (analyzeExpr depth) bindings

        | IfThenElse(g, t, e, _) ->
            let bindings = analyzeExpr depth localBindings g
            let bindings' = analyzeExpr depth bindings t
            analyzeExpr depth bindings' e

        | Sequential exprs ->
            exprs |> List.fold (analyzeExpr depth) localBindings

        | WhileLoop(g, b, _) ->
            let bindings = analyzeExpr depth localBindings g
            analyzeExpr depth bindings b

        | ForLoop(ident, s, e, body, _, _) ->
            let bindings = analyzeExpr depth localBindings s
            let bindings' = analyzeExpr depth bindings e
            let param = { Kind = Local; WType = WType.I32; Depth = depth }
            let bindings'' = bindings'.Add(ident.Name, param)
            analyzeExpr depth bindings'' body

        | Get(e, _, _, _) ->
            analyzeExpr depth localBindings e

        | Set(e, _, _, v, _) ->
            let bindings = analyzeExpr depth localBindings e
            analyzeExpr depth bindings v

        | Test(e, _, _) ->
            analyzeExpr depth localBindings e

        | DecisionTree(e, targets) ->
            let bindings = analyzeExpr depth localBindings e
            targets |> List.fold (fun acc (idents, body) ->
                let bindings' = idents |> List.fold (fun acc' id ->
                    acc'.Add(id.Name, { Kind = Local; WType = WType.I32; Depth = depth })
                ) acc
                analyzeExpr depth bindings' body
            ) bindings

        | DecisionTreeSuccess(_, vals, _) ->
            vals |> List.fold (analyzeExpr depth) localBindings

        | TryCatch(body, catch, fin, _) ->
            let bindings = analyzeExpr depth localBindings body
            let bindings' = match catch with
                | Some(catchId, e) ->
                    let bindings'' = bindings.Add(catchId.Name, { Kind = Local; WType = WType.I32; Depth = depth })
                    analyzeExpr depth bindings'' e
                | None -> bindings
            let bindings'' = match fin with
                | Some e -> analyzeExpr depth bindings' e
                | None -> bindings'
            bindings''

        | IdentExpr _ ->
            // Leaf node - no new bindings
            localBindings

        | e ->
            // Catchall for other expression types
            localBindings

    analyzeExpr 0 Map.empty expr


/// Classify an identifier and return its ScopeEntry.
/// 
/// Logic (in order):
/// 1. Check localBindings (Let/Lambda bounds in the current function)
/// 2. Check ctx.KnownFuncs (module-level functions)
/// 3. Unknown → treat as LocalGet (will be caught by validator if truly missing)
let classifyIdent (name: string) (localBindings: ScopeMap) (ctx: Ctx) : ScopeEntry =
    match localBindings.TryFind(name) with
    | Some entry -> entry
    | None ->
        match ctx.KnownFuncs.TryFind(name) with
        | Some (params, resultTy) when List.isEmpty params ->
            // Zero-arg known function → direct call
            { Kind = KnownFunc; WType = resultTy; Depth = 0 }
        | Some (_, resultTy) ->
            // Multi-arg function → module value (curried)
            { Kind = KnownFunc; WType = resultTy; Depth = 0 }
        | None ->
            // Unknown → assume local (validator will catch if missing at runtime)
            { Kind = Local; WType = WType.I32; Depth = 0 }


/// Promote Local entries at deeper depths to FreeVar when crossing lambda boundary.
/// Called after analyzing a lambda body to mark captured variables.
let markFreeVars (lambdaDepth: int) (entries: ScopeMap) : ScopeMap =
    entries |> Map.map (fun _ entry ->
        if entry.Depth < lambdaDepth && entry.Kind = Local then
            { entry with Kind = FreeVar }
        else
            entry
    )


/// Analyze all declarations in a module to build comprehensive scope information.
/// Returns a Map<functionName, ScopeMap> for cross-function reference.
let analyzeModuleScope (ctx: Ctx) (decls: Declaration list) : Map<string, ScopeMap> =
    decls |> List.choose (fun decl ->
        match decl with
        | MemberDeclaration md ->
            let funcName = md.Name
            let scope = analyzeScopeOfExpr ctx md.Value
            Some(funcName, scope)
        | _ -> None
    ) |> Map.ofList
