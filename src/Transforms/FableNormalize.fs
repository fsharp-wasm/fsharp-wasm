/// Fable-AST normalisation — runs ONCE per declaration, before any backend transform.
///
/// Why this exists
/// ───────────────
/// The backend (Fable → WExpr) makes two assumptions that Fable's own AST does not guarantee:
///
///   1. Binder names are unique per *function*.  WASM locals are flat (name → one slot) and
///      `FreeVars.collectFreeVars` works on names.  Fable only guarantees uniqueness per *scope*,
///      so sibling/nested `x`s (pipelines, decision-tree targets, shadowing, inlined bodies) end up as
///      one local with conflicting types, or as a capture analysis that confuses two different `x`.
///
///   2. `x |> List.f g` reaches the list/seq handlers as `Call(Import f, [g; list])`.
///      Fable reaches that shape by beta-reducing `CurriedApply(Lambda x → Call(f,[g; x]), [list])`;
///      the gate disables Fable's optimiser, so the pipe survives as a lambda that is allocated,
///      lifted into `$closure_N` and applied.  Inside the lifted body the handlers no longer see the
///      call in the shape they pattern-match on → WGC002 / WGC008 for *every* pipeline stage.
///
/// What it does
/// ────────────
///   Pass 1  uniquify   alpha-rename every binder (Let, LetRec, Lambda, Delegate, ForLoop, catch ident,
///                      decision-tree target idents, object-expr member args) so that each name is
///                      bound exactly once in a declaration.  Scope-aware; references follow renames.
///   Pass 2  beta       CurriedApply(Lambda p → b, a :: rest)  ⇒  Let(p, a, b rest)
///                      CurriedApply(Let(i, v, λ…), args)       ⇒  Let(i, v, apply λ args)
///                      Because pass 1 made binders unique, this is capture-free by construction and
///                      never needs to substitute `a` into `b` (evaluation order/once-only preserved).
///   Pass 3  inline     Let(f, λ…, body) with exactly one reference to `f`  ⇒  body[f := λ…]
///                      Fable builds `x |> List.sumBy (fun g -> …)` as
///                          let arg = (fun g -> …) in fun list -> List.sumBy arg list
///                      so after pass 2 the call is `List.sumBy arg list` with `arg` an identifier.
///                      The list/seq/array handlers pattern-match a *literal* lambda argument, exactly
///                      what a direct call `List.sumBy (fun g -> …) list` gives them.  Creating a lambda
///                      has no effect, so moving it to its single use site is always sound (names are
///                      unique after pass 1, so nothing can be captured).  This is the one piece of
///                      Fable's `bindingBetaReduction` the backend depends on.
///
/// Pure Fable.AST → Fable.AST; no FCS, no backend types.
namespace WasmGc.Transforms

open System.Collections.Generic
open WasmGc.Core
open Fable.AST.Fable
open Fable.Transforms // AutoOpen `AST` module: visit, visitFromInsideOut

module FableNormalize =

    // ─────────────────────────────────────────────────────────────────
    // Names already present in a declaration (so fresh names never clash)
    // ─────────────────────────────────────────────────────────────────

    let private collectNames (seed: string seq) (body: Expr) : HashSet<string> =
        let names = HashSet<string>(seed)
        let add (i: Ident) = names.Add i.Name |> ignore

        body
        |> visitFromInsideOut (fun e ->
            match e with
            | IdentExpr i -> add i
            | Let(i, _, _) -> add i
            | ForLoop(i, _, _, _, _, _) -> add i
            | LetRec(bs, _) -> bs |> List.iter (fst >> add)
            | Lambda(a, _, _) -> add a
            | Delegate(args, _, _, _) -> List.iter add args
            | TryCatch(_, Some(i, _), _, _) -> add i
            | DecisionTree(_, targets) -> targets |> List.iter (fst >> List.iter add)
            | ObjectExpr(ms, _, _) -> ms |> List.iter (fun m -> List.iter add m.Args)
            | _ -> ()

            e)
        |> ignore

        names

    // ─────────────────────────────────────────────────────────────────
    // Pass 1 — unique binders
    // ─────────────────────────────────────────────────────────────────

    type private Env = Map<string, string>

    /// `this` idents are never renamed; everything else goes through the shared UniqueNamer.
    let private bind (namer: UniqueNamer) (env: Env) (id: Ident) : Ident * Env =
        if id.IsThisArgument then
            id, env
        else
            let name, env' = namer.Bind(env, id.Name)
            (if name = id.Name then id else { id with Name = name }), env'

    let private bindAll (namer: UniqueNamer) (env: Env) (ids: Ident list) : Ident list * Env =
        let rev, env' =
            ids
            |> List.fold
                (fun (acc, env) id ->
                    let id', env' = bind namer env id
                    id' :: acc, env')
                ([], env)

        List.rev rev, env'

    let rec private uniq (namer: UniqueNamer) (env: Env) (e: Expr) : Expr =
        let go = uniq namer env

        match e with
        | IdentExpr id ->
            match Map.tryFind id.Name env with
            | Some name when name <> id.Name -> IdentExpr { id with Name = name }
            | _ -> e

        | Let(id, value, body) ->
            let value = go value
            let id, env' = bind namer env (id)
            Let(id, value, uniq namer env' body)

        | LetRec(bindings, body) ->
            let ids, env' = bindAll namer env (bindings |> List.map fst)

            let bindings =
                List.map2 (fun id (_, value) -> id, uniq namer env' value) ids bindings

            LetRec(bindings, uniq namer env' body)

        | Lambda(arg, body, name) ->
            let arg, env' = bind namer env arg
            Lambda(arg, uniq namer env' body, name)

        | Delegate(args, body, name, tags) ->
            let args, env' = bindAll namer env args
            Delegate(args, uniq namer env' body, name, tags)

        | ForLoop(id, start, limit, body, isUp, range) ->
            let start = go start
            let limit = go limit
            let id, env' = bind namer env (id)
            ForLoop(id, start, limit, uniq namer env' body, isUp, range)

        | TryCatch(body, catch, finalizer, range) ->
            let catch =
                catch
                |> Option.map (fun (id, handler) ->
                    let id, env' = bind namer env (id)
                    id, uniq namer env' handler)

            TryCatch(go body, catch, Option.map go finalizer, range)

        | DecisionTree(expr, targets) ->
            let targets =
                targets
                |> List.map (fun (ids, target) ->
                    let ids, env' = bindAll namer env ids
                    ids, uniq namer env' target)

            DecisionTree(go expr, targets)

        | ObjectExpr(members, typ, baseCall) ->
            let members =
                members
                |> List.map (fun m ->
                    let args, env' = bindAll namer env m.Args
                    { m with Args = args; Body = uniq namer env' m.Body })

            ObjectExpr(members, typ, Option.map go baseCall)

        | _ -> visit go e

    // ─────────────────────────────────────────────────────────────────
    // Pass 2 — beta reduction of applied lambdas
    // ─────────────────────────────────────────────────────────────────

    let private isOpaque (t: Type) =
        match t with
        | GenericParam _
        | Any -> true
        | _ -> false

    let private subst (replacements: Map<string, Expr>) (e: Expr) =
        if Map.isEmpty replacements then
            e
        else
            e
            |> visitFromInsideOut (function
                | IdentExpr i when Map.containsKey i.Name replacements -> replacements.[i.Name]
                | other -> other)

    /// Can `e` be applied to arguments without evaluating anything but let-bound values?
    let rec private applicable (e: Expr) =
        match e with
        | Lambda _ -> true
        | Let(_, _, inner) -> applicable inner
        | _ -> false

    /// Bind lambda parameter `p` to argument `arg` around `body`.
    let private bindArg (p: Ident) (arg: Expr) (body: Expr) : Expr =
        match p.Type, arg with
        // unit parameters have no WASM representation: keep the argument's effects, drop the binding
        | Unit, Value(UnitConstant, _) -> subst (Map [ p.Name, Value(UnitConstant, None) ]) body
        | Unit, _ -> Sequential [ arg; subst (Map [ p.Name, Value(UnitConstant, None) ]) body ]
        // `fun x -> …` from an eta-expanded generic use site can still carry 'T: prefer the argument's type
        | pt, _ when isOpaque pt && not (isOpaque arg.Type) ->
            let p' = { p with Type = arg.Type }
            Let(p', arg, subst (Map [ p.Name, IdentExpr p' ]) body)
        | _ -> Let(p, arg, body)

    /// Inside-out step: children are already reduced.
    let rec private beta (e: Expr) : Expr =
        match e with
        | CurriedApply(Lambda(p, body, _), arg :: rest, t, r) ->
            let body =
                if List.isEmpty rest then body else beta (CurriedApply(body, rest, t, r))

            bindArg p arg body
        | CurriedApply(Let(i, v, inner), args, t, r) when applicable inner ->
            Let(i, v, beta (CurriedApply(inner, args, t, r)))
        | _ -> e

    // ─────────────────────────────────────────────────────────────────
    // Pass 3 — inline single-use let-bound lambdas
    // ─────────────────────────────────────────────────────────────────

    let private countRefs (name: string) (e: Expr) : int =
        let n = ref 0

        e
        |> visitFromInsideOut (fun x ->
            match x with
            | IdentExpr i when i.Name = name -> n.Value <- n.Value + 1
            | _ -> ()

            x)
        |> ignore

        n.Value

    let private isLambda (e: Expr) =
        match e with
        | Lambda _
        | Delegate _ -> true
        | _ -> false

    let private inlineLambdaBinding (e: Expr) : Expr =
        match e with
        | Let(i, value, body) when not i.IsMutable && isLambda value && countRefs i.Name body = 1 ->
            subst (Map [ i.Name, value ]) body
        | _ -> e

    // ─────────────────────────────────────────────────────────────────
    // Entry points
    // ─────────────────────────────────────────────────────────────────

    /// Normalise one function body. `paramNames` are bound by the caller (function arguments).
    let normalizeBody (paramNames: string list) (body: Expr) : Expr =
        let namer = UniqueNamer.Create(collectNames paramNames body, paramNames)

        body
        |> uniq namer Map.empty
        |> visitFromInsideOut beta
        |> visitFromInsideOut inlineLambdaBinding

    let private normalizeMember (m: MemberDecl) : MemberDecl =
        { m with Body = normalizeBody (m.Args |> List.map (fun a -> a.Name)) m.Body }

    let rec normalizeDeclaration (decl: Declaration) : Declaration =
        match decl with
        | ModuleDeclaration m -> ModuleDeclaration { m with Members = List.map normalizeDeclaration m.Members }
        | ActionDeclaration a -> ActionDeclaration { a with Body = normalizeBody [] a.Body }
        | MemberDeclaration m -> MemberDeclaration(normalizeMember m)
        | ClassDeclaration c ->
            ClassDeclaration
                { c with
                    Constructor = Option.map normalizeMember c.Constructor
                    BaseCall = Option.map (normalizeBody []) c.BaseCall
                    AttachedMembers = List.map normalizeMember c.AttachedMembers }
