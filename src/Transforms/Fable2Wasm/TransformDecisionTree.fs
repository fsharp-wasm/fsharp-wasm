module WasmGc.Transforms.TransformDecisionTree

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc.Runtime.Types
open WasmGc.Builder

// ─────────────────────────────────────────────────────────────────
// Decision tree translation (pattern matching)
// ─────────────────────────────────────────────────────────────────

let transformDecisionTree
    (ctx: Ctx)
    (eval: Ctx -> Fable.Expr -> WExpr)
    (matchExpr: Fable.Expr)
    (targets: (Ident list * Fable.Expr) list) : WExpr =
    let resultType = mapTypeKnown ctx matchExpr.Type
    // Assign globally-unique IDs to these targets (avoids label collisions in nested matches).
    let baseId = !ctx.DecisionTreeCounter
    ctx.DecisionTreeCounter := baseId + targets.Length
    // Create join points for each target
    let wTargets =
        targets
        |> List.mapi (fun i (idents, body) ->
            let parms = idents |> List.map (fun id -> id.Name, mapTypeKnown ctx id.Type)
            let ctx' = (ctx, idents) ||> List.fold (fun c id -> c.WithLocal(id.Name, mapTypeKnown ctx id.Type))
            let wBody = eval ctx' body
            $"$target_{baseId + i}", parms, wBody
        )
    // Before translating matchExpr, publish the current base so that
    // DecisionTreeSuccess nodes (which reference 0-based local indices)
    // produce globally-unique labels ($target_{baseId + localIdx}).
    let savedBase = !ctx.TargetBase
    ctx.TargetBase := baseId
    let wMatch = eval ctx matchExpr
    ctx.TargetBase := savedBase
    // Wrap in join points
    (wMatch, List.rev wTargets)
    ||> List.fold (fun cont (label, parms, body) ->
        WExpr.JoinPoint(label, parms, body, cont, resultType)
    )

