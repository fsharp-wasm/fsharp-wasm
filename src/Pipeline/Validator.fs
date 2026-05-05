/// Pre-emit structural validator — Phase 6.
///
/// Catches bugs BEFORE they become cryptic Wasm traps:
///   - call_ref arity mismatches (ClosureApply / TailCallRef / CallVirtual)
///   - void-typed arguments that produce no stack value (void-arg stack underflows)
///   - LocalGet references to names not in params or locals
///   - CallRef/ReturnCallRef with wrong arg count (LIR nodes from Lower.fs)
///
/// Run after Phase 5 (Locals resolved), before Phase 7 (Optimize).
module WasmGc.Pipeline.Validator

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Util.WExprQuery   // collect, exists

// ─────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────

[<Struct>]
type ValidationError = {
    FuncName : string
    NodeDesc : string
    Message  : string
}

// ─────────────────────────────────────────────────────────────────
// Arity index
// ─────────────────────────────────────────────────────────────────
/// Build funcTypeIdx → paramCount map from the module's type table.
let private arityIndex (typeDefs: ResizeArray<WTypeDeclEntry>) : Map<int, int> =
    typeDefs
    |> Seq.mapi (fun i entry -> i, entry)
    |> Seq.choose (fun (i, entry) ->
        match entry.Def with
        | WTypeDef.Func(parms, _) -> Some(i, parms.Length)
        | _                       -> None)
    |> Map.ofSeq

// ─────────────────────────────────────────────────────────────────
// Per-function checker
// ─────────────────────────────────────────────────────────────────

let internal checkFunc
        (name    : string)
        (arity   : Map<int, int>)
        (known   : Set<string>)       // params + locals
        (body    : WExpr)
        : ValidationError list =

    let errors = ResizeArray()
    let err desc msg = errors.Add { FuncName = name; NodeDesc = desc; Message = msg }

    let nonVoidCount args = args |> List.filter (fun a -> exprWType a <> WType.Void) |> List.length

    let arityCheckCallRef desc fti selfCount args =
        let nv = nonVoidCount args
        match Map.tryFind fti arity with
        | None ->
            err desc (sprintf "funcTypeIdx %d not registered in type table" fti)
        | Some expected when selfCount + nv <> expected ->
            err desc (sprintf "call_ref fti=%d: need %d params, got %d (self=%d + %d non-void args)"
                          fti expected (selfCount + nv) selfCount nv)
        | _ -> ()
        args |> List.iteri (fun i a ->
            if exprWType a = WType.Void then
                err desc (sprintf "arg[%d] is void — no stack value → stack underflow" i))

    let arityCheckVirtual desc fti args =             // for CallVirtual
        let nv = nonVoidCount args
        match Map.tryFind fti arity with
        | None -> err desc (sprintf "funcTypeIdx %d not in type table" fti)
        | Some expected when 1 + nv <> expected ->
            err desc (sprintf "need %d params, got self + %d non-void args" expected nv)
        | _ -> ()

    // Unknown LocalGet references
    collect (function WExpr.LocalGet _ -> true | _ -> false) body
    |> List.choose (function WExpr.LocalGet(n, _) when not (Set.contains n known) -> Some n | _ -> None)
    |> List.distinct
    |> List.iter (fun n -> err "LocalGet" (sprintf "unknown local '%s' not in params or .Locals" n))

    // Walk and check call nodes
    let rec walk = function
        | WExpr.ClosureApply(clo, args, fti, _, _, _) ->
            arityCheckCallRef (sprintf "ClosureApply(fti=%d)" fti) fti 1 args  // +1 self
            walk clo; List.iter walk args

        | WExpr.TailCallRef(clo, args, fti, _, _, _) ->
            arityCheckCallRef (sprintf "TailCallRef(fti=%d)" fti) fti 1 args
            walk clo; List.iter walk args

        | WExpr.CallRef(fti, args, ptr, _) ->
            // LIR node: self is already first element of args (from Lower.fs)
            // Post-Lower: self is already args[0]; arity check uses 0 extra self
            arityCheckCallRef (sprintf "CallRef(fti=%d)" fti) fti 0 args
            List.iter walk args; walk ptr

        | WExpr.ReturnCallRef(fti, args, ptr, _) ->
            arityCheckCallRef (sprintf "ReturnCallRef(fti=%d)" fti) fti 0 args
            List.iter walk args; walk ptr

        | WExpr.CallVirtual(box, _, _, _, fti, args, _) ->
            arityCheckVirtual (sprintf "CallVirtual(fti=%d)" fti) fti args   // +1 self (box)
            walk box; List.iter walk args

        | WExpr.Closure(n, _, WType.Ref(0, _)) ->
            err (sprintf "Closure('%s')" n) "has AnyFnTypeIdx(0) — fixClosureApply may not have run"

        // Descend
        | expr -> children expr |> List.iter walk

    walk body
    List.ofSeq errors

// ─────────────────────────────────────────────────────────────────
// Public API
// ─────────────────────────────────────────────────────────────────

/// Validate all functions in the module.
/// strict=true → raise after printing; false → warn-only (for CI gates).
let validate
        (strict   : bool)
        (typeDefs : ResizeArray<WTypeDeclEntry>)
        (funcs    : WFuncDecl list)
        : ValidationError list =

    let arity  = arityIndex typeDefs
    let errors =
        funcs |> List.collect (fun f ->
            let known = (f.Params |> List.map fst) @ (f.Locals |> List.map fst) |> Set.ofList
            checkFunc f.Name arity known f.Body)

    if not errors.IsEmpty then
        eprintfn ""
        let severity = if strict then "✗ ERROR" else "⚠ WARNING"
        eprintfn "\n[Validator] %s — %d issue(s):" severity errors.Length
        eprintfn "%s" (String.replicate 72 "─")
        // Group by function for readability
        errors
        |> List.groupBy (fun e -> e.FuncName)
        |> List.iter (fun (fn, errs) ->
            eprintfn "  %s" fn
            errs |> List.iter (fun e ->
                eprintfn "    [%s]" e.NodeDesc
                eprintfn "    → %s" e.Message))
        eprintfn "%s" (String.replicate 72 "─")
        eprintfn ""
        if strict then
            failwithf "[Validator] %d error(s) — aborting before emit" errors.Length
    errors

