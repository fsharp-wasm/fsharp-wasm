/// Phase 4c — Unique locals (WExpr → WExpr), between Lower (4b) and ResolveLocals (5).
///
/// WASM locals are flat: one name, one slot per function.  The builders, however, scope names
/// lexically and several of them use *fixed* temporaries:
///
///     buildFor      Let("$limit", …)          ← every `for` loop in a function
///     string/char   Let("$iofi_tmp"|"$chcl2"|…) ← every use of the construct
///     array/list    Let(farg.Name, …)           ← lambda parameters of inlined HOFs
///
/// Consequences before this pass: sequential loops declared `$limit` twice (WAT rejected by
/// `wasm-tools parse`), and — worse — a *nested* loop overwrote the outer loop's limit, so the
/// outer loop ran to the wrong bound.  Two same-named lets with different types silently shared
/// one (wrongly typed) local.
///
/// This pass makes every binder name unique per function and rewrites exactly the references in
/// its scope, so flat-local execution is equivalent to the lexical semantics the builders assumed.
/// Binders: Let, LetMut, JoinPoint parameters, TryCatch handler variable.  The first binder of a
/// name keeps it; function parameters are reserved, so nothing can shadow them.
///
/// `Locals` is intentionally NOT touched: Phase 5 (`resolveLocals`) recomputes it from the result.
module WasmGc.Pipeline.UniqueLocals

open WasmGc.Core
open WasmGc.Core.AST
open WasmGc.Core.Traverse

/// Every name that occurs in the function (binders, references, parameters, pre-declared locals).
let private namesIn (f: WFuncDecl) : string seq =
    let acc = ResizeArray<string>()

    let rec go e =
        match e with
        | WExpr.LocalGet(n, _)
        | WExpr.Assign(n, _)
        | WExpr.Let(n, _, _)
        | WExpr.LetMut(n, _, _) -> acc.Add n
        | WExpr.JoinPoint(_, ps, _, _, _) -> ps |> List.iter (fst >> acc.Add)
        | WExpr.TryCatch(_, Some(n, _), _, _) -> acc.Add n
        | _ -> ()

        children e |> List.iter go

    go f.Body
    seq {
        yield! acc
        yield! f.Params |> Seq.map fst
        yield! f.Locals |> Seq.map fst
    }

let private renameBody (namer: UniqueNamer) (body: WExpr) : WExpr =
    let lookup (env: Map<string, string>) n =
        Map.tryFind n env |> Option.defaultValue n

    let rec go (env: Map<string, string>) (e: WExpr) : WExpr =
        match e with
        | WExpr.LocalGet(n, t) -> WExpr.LocalGet(lookup env n, t)
        | WExpr.Assign(n, v) -> WExpr.Assign(lookup env n, go env v)

        | WExpr.Let(n, v, b) ->
            let v = go env v
            let n, env' = namer.Bind(env, n)
            WExpr.Let(n, v, go env' b)

        | WExpr.LetMut(n, v, b) ->
            let v = go env v
            let n, env' = namer.Bind(env, n)
            WExpr.LetMut(n, v, go env' b)

        // parameters are in scope in `body`; `cont` jumps to it via JoinApply (positional args)
        | WExpr.JoinPoint(label, ps, body, cont, t) ->
            let names, env' = namer.BindAll(env, List.map fst ps)
            WExpr.JoinPoint(label, List.zip names (List.map snd ps), go env' body, go env cont, t)

        | WExpr.TryCatch(body, Some(n, handler), fin, t) ->
            let n, env' = namer.Bind(env, n)
            WExpr.TryCatch(go env body, Some(n, go env' handler), Option.map (go env) fin, t)

        | _ -> mapChildren (go env) e

    go Map.empty body

let uniqueFunc (f: WFuncDecl) : WFuncDecl =
    let namer = UniqueNamer.Create(namesIn f, f.Params |> List.map fst)
    let body = renameBody namer f.Body
    if namer.RenameCount = 0 then f else { f with Body = body }

let uniqueModule (wmod: WModule) : WModule =
    { wmod with Functions = List.map uniqueFunc wmod.Functions }
