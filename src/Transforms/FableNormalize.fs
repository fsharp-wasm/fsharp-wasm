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
///                      Let(f, toConsole(printf "…"), body)                  ⇒  body[f := …]   (every use)
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

    module Q = WasmGc.Util.FableQuery

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
    // Pass 3 — inline effect-free let-bound values (single-use lambdas, printf formatters)
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

    /// Constants and immutable identifiers: evaluating them has no effect and yields the same value anywhere
    /// in their scope (a mutable identifier could be reassigned between the binding and a later use).
    let private isAtom (e: Expr) =
        match e with
        | IdentExpr i -> not i.IsMutable
        | Value((NumberConstant _ | StringConstant _ | BoolConstant _ | CharConstant _ | UnitConstant), _) -> true
        | _ -> false

    /// Effect-free values the handlers must see at their use site.
    ///  * a literal lambda: moved to its single use (duplicating one would duplicate code and allocation); a
    ///    recursive one (`let rec f = fun … f …`) stays bound, its body names the binding
    ///  * a printf formatter, possibly partially applied to atoms: `printfn "%d %d" a b` reaches us as
    ///        let clo = toConsole(printf "…") in let clo_1 = clo a in clo_1 b
    ///    Nothing is printed before the last argument and the format is constant, so it is safe to
    ///    substitute at every use.
    let private inlinable (i: Ident) (value: Expr) (body: Expr) =
        not i.IsMutable
        && (match value with
            | Q.PrintfApply(_, _, applied) -> List.forall isAtom applied
            | _ -> isLambda value && countRefs i.Name body = 1 && countRefs i.Name value = 0)   // not a `let rec`

    /// Top-down on purpose: substituting `clo` exposes `let clo_1 = <formatter> a` one level further in,
    /// which must be looked at again (a bottom-up pass would already have passed it).
    let rec private inlinePure (e: Expr) : Expr =
        match e with
        | Let(i, value, body) when inlinable i value body -> inlinePure (subst (Map [ i.Name, value ]) body)
        | _ -> visit inlinePure e

    // ─────────────────────────────────────────────────────────────────
    // Pass 4 — inline single-use stream intermediates:  `xs |> List.map f |> List.filter g |> List.sum`  arrives as
    //     let a = map f xs in let b = filter g a in sum b
    // which hides the pipeline from the fusion in SeqFusion.  `a` moves into its only use when that use is the FIRST
    // thing evaluated afterwards (so the order of effects is unchanged) and is a direct argument of another
    // collection call.
    // ─────────────────────────────────────────────────────────────────

    let private isCollectionCall (e: Expr) =
        match e with
        | Call(Import({ Path = path }, _, _), _, _, _) ->
            (match System.IO.Path.GetFileNameWithoutExtension path with
             | "Seq" | "List" | "Array" | "Range" -> true
             | _ -> false)
        | _ -> false

    /// Arguments evaluated before `name` is read must not have effects: atoms and lambdas only.
    let private inertArg (e: Expr) = isAtom e || isLambda e || (match e with Value _ -> true | _ -> false)

    /// Is `name` read, exactly once, as a direct argument of the FIRST collection call `e` evaluates?
    let rec private usedFirstByCall (name: string) (e: Expr) : bool =
        match e with
        | Call(_, info, _, _) when isCollectionCall e ->
            let isName = function IdentExpr i when i.Name = name -> true | _ -> false
            let beforeIt = info.Args |> List.takeWhile (not << isName)
            info.Args |> List.exists isName && List.forall inertArg beforeIt && countRefs name e = 1
        | Let(_, value, rest) -> usedFirstByCall name value && countRefs name rest = 0
        | TypeCast(inner, _) -> usedFirstByCall name inner
        | _ -> false

    let rec private inlineStreams (e: Expr) : Expr =
        match e with
        // `let x = (let y = a in b) in c`  ⇒  `let y = a in let x = b in c`   (binder names are unique, nothing is captured)
        | Let(i, Let(j, a, b), body) -> inlineStreams (Let(j, a, Let(i, b, body)))
        | Let(i, value, body) when not i.IsMutable && isCollectionCall value && usedFirstByCall i.Name body ->
            inlineStreams (subst (Map [ i.Name, value ]) body)
        | _ -> visit inlineStreams e

    // ─────────────────────────────────────────────────────────────────
    // Pass 5 — `for x in xs do body` over a list or an array.
    //     let e = getEnumerator xs in try while e.MoveNext() do (let x = e.Current in body) finally dispose e
    // is an iterator protocol the backend has no object for; as `List.iter (fun x -> body) xs` it becomes a plain loop
    // (the handlers inline the literal lambda, so mutable locals of the loop body keep working).
    // ─────────────────────────────────────────────────────────────────

    let rec private stripCasts (e: Expr) = match e with TypeCast(inner, _) -> stripCasts inner | _ -> e

    let rec private foreachLoops (e: Expr) : Expr =
        match e with
        | Let(_, Call(Import({ Selector = "getEnumerator" }, _, _), info, _, _),
              TryCatch(WhileLoop(_, Let(x, _, body), _), None, Some _, _)) when (match info.Args with [ _ ] -> true | _ -> false) ->
            let src = stripCasts info.Args.Head
            let iterate stem =
                Call(Import({ Selector = "iterate"; Path = $"./{stem}.fs"; Kind = LibraryImport(LibraryImportInfo.Create()) }, Any, None),
                     CallInfo.Create(args = [ Lambda(x, foreachLoops body, None); src ]), Unit, None)
            (match src.Type with
             | Type.List _ -> iterate "List"
             | Type.Array(_, ArrayKind.ResizeArray) -> visit foreachLoops e
             | Type.Array _ -> iterate "Array"
             // a seq is a list here
             | Type.DeclaredType(ent, [ _ ]) when ent.FullName = "System.Collections.Generic.IEnumerable`1" -> iterate "Seq"
             | _ -> visit foreachLoops e)
        | _ -> visit foreachLoops e

    // ─────────────────────────────────────────────────────────────────
    // Pass 6 — `{ s with X = x }` on a struct record: F# reads the unchanged fields through
    //     let inputRecord: byref<S, InOut> = s      (an alias of the value, not a cell holding it)
    // The backend reads a `byref` as the single-field cell of `&v`, so `inputRecord.R` found no such field.  An alias whose
    // value is no cell itself is the value: the binder takes the value's type (names are unique after pass 1).
    // ─────────────────────────────────────────────────────────────────

    let private isCellType (t: Type) =
        match t with
        | Type.DeclaredType(ent, _) -> WasmGc.Runtime.Types.isRefCellEntity ent.FullName
        | _ -> false

    let rec private unalias (e: Expr) : Expr =
        match e with
        | Let(i, value, body) when not i.IsMutable && isCellType i.Type && not (isCellType value.Type) && value.Type <> Type.Any ->
            let retype (x: Expr) =
                match x with
                | IdentExpr id when id.Name = i.Name -> IdentExpr { id with Type = value.Type }
                | _ -> x
            Let({ i with Type = value.Type }, unalias value, unalias (visitFromInsideOut retype body))
        | _ -> visit unalias e

    // ─────────────────────────────────────────────────────────────────
    // Pass 7 — a tuple that is only taken apart:
    //     let matchValue = (d.TryGetValue(k, &outArg), outArg) in … matchValue.Item1 … matchValue.Item2 …
    // is `match d.TryGetValue k with | true, v -> … | _ -> …`.  Nobody needs the tuple: each element becomes a binding of
    // its own, and an element that is a variable nobody assigns afterwards is read in place — so `outArg`, which holds
    // null after a miss, is only read in the arm that has it (a null cannot be stored in a tuple of non-null references,
    // and the allocation is saved too).
    // ─────────────────────────────────────────────────────────────────

    let private assignedNames (e: Expr) : Set<string> =
        let names = HashSet<string>()
        e
        |> visitFromInsideOut (fun x ->
            (match x with
             | Expr.Set(IdentExpr i, _, _, _, _) -> names.Add i.Name |> ignore
             | _ -> ())
            x)
        |> ignore
        Set.ofSeq names

    let rec private scalarTuples (e: Expr) : Expr =
        match e with
        | Let(tup, Value(NewTuple(elems, _), _), body) when not tup.IsMutable ->
            let isElementGet (x: Expr) = match x with Get(IdentExpr i, TupleIndex _, _, _) -> i.Name = tup.Name | _ -> false
            let gets = ref 0
            body |> visitFromInsideOut (fun x -> (if isElementGet x then gets.Value <- gets.Value + 1); x) |> ignore
            if countRefs tup.Name body <> gets.Value then visit scalarTuples e   // the tuple itself is used: keep it
            else
                let assigned = assignedNames body
                // (element, the name it is read by, whether it needs a binding of its own)
                let slots =
                    elems
                    |> List.mapi (fun k el ->
                        match el with
                        | IdentExpr x when not (assigned.Contains x.Name) -> x, None
                        | _ ->
                            let id = { tup with Name = sprintf "%s$%d" tup.Name k; Type = el.Type }
                            id, Some el)
                let read (x: Expr) =
                    match x with
                    | Get(IdentExpr i, TupleIndex k, _, _) when i.Name = tup.Name && k < slots.Length -> IdentExpr(fst slots.[k])
                    | _ -> x
                let body' = body |> visitFromInsideOut read |> scalarTuples
                List.foldBack (fun (id, bound) acc -> match bound with Some el -> Let(id, scalarTuples el, acc) | None -> acc) slots body'
        | _ -> visit scalarTuples e

    // ─────────────────────────────────────────────────────────────────
    // Entry points
    // ─────────────────────────────────────────────────────────────────

    /// Normalise one function body. `paramNames` are bound by the caller (function arguments).
    let normalizeBody (paramNames: string list) (body: Expr) : Expr =
        let namer = UniqueNamer.Create(collectNames paramNames body, paramNames)

        body
        |> uniq namer Map.empty
        |> visitFromInsideOut beta
        |> inlinePure
        |> unalias

    /// Apply `f paramNames body` to every function body of a declaration.
    let rec private mapBodies (f: string list -> Expr -> Expr) (decl: Declaration) : Declaration =
        let member' (m: MemberDecl) = { m with Body = f (m.Args |> List.map (fun a -> a.Name)) m.Body }
        match decl with
        | ModuleDeclaration m -> ModuleDeclaration { m with Members = List.map (mapBodies f) m.Members }
        | ActionDeclaration a -> ActionDeclaration { a with Body = f [] a.Body }
        | MemberDeclaration m -> MemberDeclaration(member' m)
        | ClassDeclaration c ->
            ClassDeclaration
                { c with
                    Constructor = Option.map member' c.Constructor
                    BaseCall = Option.map (f []) c.BaseCall
                    AttachedMembers = List.map member' c.AttachedMembers }

    let normalizeDeclaration (decl: Declaration) : Declaration = mapBodies normalizeBody decl

    /// Runs AFTER Fable's uncurrying (the calls have their final shape then): single-use stream intermediates move
    /// into the call that consumes them, which is what exposes a pipeline to the fusion.
    /// Tuples that are only taken apart go away here too: `d.TryGetValue(k, &v)` becomes the tuple `(found, v)` only in
    /// Fable's own transforms.
    let finishDeclaration (decl: Declaration) : Declaration = mapBodies (fun _ -> inlineStreams >> foreachLoops >> scalarTuples) decl

    /// Is the mutable local `name` both assigned and used inside a closure within `body`?  Such a variable cannot live in
    /// a wasm local (the closure would capture a copy): F# gives it a shared cell, so does the backend.
    let capturedAndAssigned (name: string) (body: Expr) : bool =
        let assigned, captured = ref false, ref false
        body
        |> visitFromInsideOut (fun x ->
            (match x with
             | Expr.Set(IdentExpr i, ValueSet, _, _, _) when i.Name = name -> assigned.Value <- true
             | Expr.Lambda _ | Expr.Delegate _ | Expr.ObjectExpr _
                 when (WasmGc.Runtime.FreeVars.collectFreeVars Set.empty x).Contains name -> captured.Value <- true
             | _ -> ())
            x)
        |> ignore
        assigned.Value && captured.Value

    /// Names that are assigned (`x <- …` on an identifier) anywhere in the declaration.  A module-level value
    /// among them is a mutable variable: it lives in a wasm global instead of being recomputed at every reference.
    let assignedIdents (decl: Declaration) : Set<string> =
        let names = System.Collections.Generic.HashSet<string>()
        let scan (_: string list) (body: Expr) : Expr =
            body
            |> visitFromInsideOut (fun x ->
                (match x with
                 | Expr.Set(IdentExpr i, ValueSet, _, _, _) -> names.Add i.Name |> ignore
                 | _ -> ())
                x)
            |> ignore
            body
        mapBodies scan decl |> ignore
        Set.ofSeq names
