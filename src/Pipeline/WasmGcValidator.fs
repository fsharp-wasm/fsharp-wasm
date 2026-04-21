/// Pre-emit AST validator for WasmGC.
///
/// Catches arity mismatches, void-arg stack underflows, and other structural
/// problems in the WExpr tree BEFORE they become cryptic WebAssembly traps.
///
/// Insert into buildWModule after fixClosureApply:
///   WasmGcValidator.validate true ctx.TypeDefs fixedFunctions
module Fable.Transforms.WasmGc.WasmGcValidator

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes

// let _ = printfn "WasmGcValidator loaded from %s" dllPath
// ─────────────────────────────────────────────────────────────────
// Error type
// ─────────────────────────────────────────────────────────────────

[<Struct>]
type ValidationError = {
    FuncName : string
    NodeDesc : string
    Message  : string
}

// ─────────────────────────────────────────────────────────────────
// Functype arity index (built once per validate call)
// ─────────────────────────────────────────────────────────────────

let private buildArityIndex (typeDefs: ResizeArray<WTypeDeclEntry>) : Map<int, int> =
    typeDefs
    |> Seq.mapi (fun i entry -> i, entry)
    |> Seq.choose (fun (i, entry) ->
        match entry.Def with
        | WTypeDef.Func(parms, _) -> Some(i, List.length parms)
        | _ -> None)
    |> Map.ofSeq

// ─────────────────────────────────────────────────────────────────
// Per-function checker
// ─────────────────────────────────────────────────────────────────

let private checkFunc
        (funcName  : string)
        (arityIdx  : Map<int, int>)
        (errors    : ResizeArray<ValidationError>)
        (expr      : WExpr)
        : unit =

    let add desc msg =
        errors.Add { FuncName = funcName; NodeDesc = desc; Message = msg }

    let nonVoidCount args =
        args |> List.filter (fun a -> exprWType a <> WType.Void) |> List.length

    let rec check expr =

        match expr with

        // ── Primary check: call_ref arity ────────────────────────
        | WExpr.ClosureApply(closure, args, funcTypeIdx, closureTypeIdx, _, _) ->

            // Any void arg produces no stack value → immediate underflow
            let voids = args |> List.filter (fun a -> exprWType a = WType.Void)
            if not voids.IsEmpty then
                add (sprintf "ClosureApply fti=%d cti=%d" funcTypeIdx closureTypeIdx)
                    (sprintf "%d void-typed arg(s) will produce no stack value → call_ref underflow" voids.Length)

            // Arity check: functype params must be (self :: non-void-args)
            match Map.tryFind funcTypeIdx arityIdx with
            | Some expected ->
                let actual = 1 + nonVoidCount args  // +1 for self
                if actual <> expected then
                    add (sprintf "ClosureApply fti=%d cti=%d" funcTypeIdx closureTypeIdx)
                        (sprintf "call_ref needs %d args (incl $self), %d on stack (%d args + self)" expected actual (actual - 1))
            | None ->
                add (sprintf "ClosureApply fti=%d" funcTypeIdx)
                    (sprintf "funcTypeIdx %d not registered — type table incomplete" funcTypeIdx)

            check closure
            args |> List.iter check

        | WExpr.TailCallRef(closure, args, funcTypeIdx, closureTypeIdx, _, _) ->

            let voids = args |> List.filter (fun a -> exprWType a = WType.Void)
            if not voids.IsEmpty then
                add (sprintf "TailCallRef fti=%d cti=%d" funcTypeIdx closureTypeIdx)
                    (sprintf "%d void arg(s) → return_call_ref underflow" voids.Length)

            match Map.tryFind funcTypeIdx arityIdx with
            | Some expected ->
                let actual = 1 + nonVoidCount args
                if actual <> expected then
                    add (sprintf "TailCallRef fti=%d cti=%d" funcTypeIdx closureTypeIdx)
                        (sprintf "return_call_ref needs %d, %d on stack" expected actual)
            | None -> ()

            check closure
            args |> List.iter check

        // ── Secondary checks ──────────────────────────────────────

        // Closures passed as values should have a non-AnyFn type registered
        | WExpr.Closure(name, caps, ty) ->
            match ty with
            | WType.Ref(0, _) ->
                add (sprintf "Closure '%s'" name)
                    "Closure has AnyFnTypeIdx (0) as type — fixClosureApply may not have run"
            | _ -> ()
            caps |> List.iter check

        // CallRef-via-CallVirtual: args should match vtable slot arity
        | WExpr.CallVirtual(box, _, _, _, funcTypeIdx, args, _) ->
            match Map.tryFind funcTypeIdx arityIdx with
            | Some expected ->
                // CallVirtual passes self (eqref) + args; self is the box, not in args list
                let actual = 1 + nonVoidCount args
                if actual <> expected then
                    add (sprintf "CallVirtual fti=%d" funcTypeIdx)
                        (sprintf "vtable call_ref needs %d, %d on stack" expected actual)
            | None -> ()
            check box
            args |> List.iter check

        // ── Recursive descent ─────────────────────────────────────
        | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b)  -> check v; check b
        | WExpr.If(c, t, e, _)                         -> check c; check t; check e
        | WExpr.Sequence xs                             -> xs |> List.iter check
        | WExpr.Block(_, body, _)
        | WExpr.Loop(_, body, _)                        -> check body
        | WExpr.Call(_, args, _)                        -> args |> List.iter check
        | WExpr.TailCall(_, args, _)                    -> args |> List.iter check
        | WExpr.Assign(_, v)                            -> check v
        | WExpr.ArrayGet(a, i, _)                       -> check a; check i
        | WExpr.ArraySet(a, i, v)                       -> check a; check i; check v
        | WExpr.ArrayNew(_, s, init, _)                 -> check s; check init
        | WExpr.ArrayNewFixed(_, elems, _)              -> elems |> List.iter check
        | WExpr.ArrayLen e                              -> check e
        | WExpr.ArrayCopy(d, do_, s, so, n)            -> check d; check do_; check s; check so; check n
        | WExpr.StructNew(_, fs, _)                     -> fs |> List.iter check
        | WExpr.StructGet(o, _, _)                      -> check o
        | WExpr.StructSet(o, _, v)                      -> check o; check v
        | WExpr.Cast(e, _) | WExpr.RefIsNull e
        | WExpr.RefTest(e, _) | WExpr.TagOf e          -> check e
        | WExpr.Unary(_, e, _)                          -> check e
        | WExpr.Binary(_, a, b, _)
        | WExpr.Compare(_, a, b)                        -> check a; check b
        | WExpr.Break(_, Some v)                        -> check v
        | WExpr.Throw e                                 -> check e
        | WExpr.MemLoad(_, _, addr)                     -> check addr
        | WExpr.MemStore(_, _, addr, v)                 -> check addr; check v
        | WExpr.MemoryGrow pages                        -> check pages
        | WExpr.JoinPoint(_, _, b, c, _)                -> check b; check c
        | WExpr.SwitchInt(s, cases, d, _)              ->
            check s; cases |> List.iter (snd >> check); check d
        | WExpr.TryCatch(b, catch, fin, _)             ->
            check b
            catch |> Option.iter (snd >> check)
            fin   |> Option.iter check
        | _ -> ()

    check expr

// ─────────────────────────────────────────────────────────────────
// Public API
// ─────────────────────────────────────────────────────────────────

/// Validate all functions in the module.
/// failOnErrors=true → raise after printing; false → warn-only (for CI gates).
let validate
        (failOnErrors : bool)
        (typeDefs     : ResizeArray<WTypeDeclEntry>)
        (functions    : WFuncDecl list)
        : unit =
    let errors   = ResizeArray<ValidationError>()
    let arityIdx = buildArityIndex typeDefs
    for f in functions do
        checkFunc f.Name arityIdx errors f.Body
    if errors.Count > 0 then
        let tag = if failOnErrors then "✗ ERROR" else "⚠ WARN"
        eprintfn ""
        eprintfn "[WasmGcValidator] %s — %d issue(s) found before emit:" tag errors.Count
        eprintfn "%s" (String.replicate 72 "─")
        // Group by function for readability
        errors
        |> Seq.groupBy (fun e -> e.FuncName)
        |> Seq.iter (fun (fn, errs) ->
            eprintfn "  func %s" fn
            for e in errs do
                eprintfn "    [%s]" e.NodeDesc
                eprintfn "    → %s" e.Message)
        eprintfn "%s" (String.replicate 72 "─")
        eprintfn ""
        if failOnErrors then
            failwithf "[WasmGcValidator] %d error(s) — fix before emitting WASM" errors.Count
