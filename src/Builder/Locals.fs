
/// Local variable collection and WFuncDecl construction.
/// Key invariant: emitter-internal temporaries ($clo_apply_tmp, $switch_tmp)
/// must NEVER appear here — they are either eliminated by Lower.fs or
/// injected by Emit.fs as true stack operations (local.tee with no .Locals entry).
module WasmGc.Runtime.Locals

open WasmGc.Core.AST
open WasmGc.Core.Traverse
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Emitter-internal temporaries — excluded from .Locals
// ─────────────────────────────────────────────────────────────────
// After Lower.fs runs, ClosureApply → Let($lo_clo_N,...) so $clo_apply_tmp
// is gone from HIR code paths.  The legacy path in Emit.fs still injects
// $clo_apply_tmp/$switch_tmp as locals for functions not yet lowered;
// we keep the exclusion filter here as a safety net.

let private internalTemps =
    Set.ofList ["$clo_apply_tmp"; "$switch_tmp"; "$fsharp_exn_carrier"]

let private isInternal (name: string) = Set.contains name internalTemps

// ─────────────────────────────────────────────────────────────────
// Local collection — built on the exhaustive Traverse.children
// ─────────────────────────────────────────────────────────────────
//
// The previous hand-written walkers skipped Return / Break(Some v) / Continue /
// Closure captures / JoinPoint parameters, so locals bound or referenced inside those
// nodes were never declared.  Everything below goes through `children`.

/// Type of the first `LocalGet name` (non-void) found in `e`, if any.
let rec private firstGetType (name: string) (e: WExpr) : WType option =
    match e with
    | WExpr.LocalGet(n, t) when n = name && t <> WType.Void -> Some t
    | _ -> children e |> List.tryPick (firstGetType name)

/// Declared type of a Let-bound local.  A void-typed initialiser (e.g. a `throw` whose
/// value is unused) never emits a local.set, so the type is recovered from the first use.
let private bindingType (name: string) (value: WExpr) (body: WExpr) : WType =
    match exprWType value with
    | WType.Void -> firstGetType name body |> Option.defaultValue WType.Void
    | t -> t

/// Find all LocalGet names and their types referenced in an expression
/// (parameters, captured variables and Let-bound locals alike).
let findAllReferencedLocals (expr: WExpr) : (string * WType) list =
    let acc = ResizeArray<string * WType>()
    let rec go e =
        match e with
        | WExpr.LocalGet(n, t) -> acc.Add((n, t))
        | _ -> ()
        children e |> List.iter go
    go expr
    List.ofSeq acc

// A local of non-nullable reference type counts as initialised only inside the block that sets it.  The parameters of
// a join point are set where a `JoinApply` sits (in whichever nested block of `cont`) and read in `body`, after
// those blocks have ended — so they are declared nullable, and `castJoinParams` reads them through a cast.
let private nullableRef (t: WType) =
    match t with
    | WType.Ref(i, false) -> WType.Ref(i, true)
    | t -> t

/// Collect all Let/LetMut/JoinPoint-parameter bindings (the WASM locals declaration list).
/// `paramNames` are excluded because they are already function parameters.
let collectLocals (paramNames: Set<string>) (expr: WExpr) : (string * WType) list =
    let acc = ResizeArray<string * WType>()
    let add n t = if not (Set.contains n paramNames || isInternal n) then acc.Add((n, t))
    let rec go e =
        match e with
        | WExpr.Let(n, v, b) | WExpr.LetMut(n, v, b) -> add n (bindingType n v b)
        | WExpr.JoinPoint(_, ps, _, _, _) -> ps |> List.iter (fun (n, t) -> add n (nullableRef t))
        | _ -> ()
        children e |> List.iter go
    go expr
    List.ofSeq acc

/// Every name that is *bound* inside `func` (params, Let, LetMut, join-point params).
let boundNames (func: WFuncDecl) : Set<string> =
    let fromBody =
        let acc = ResizeArray<string>()
        let rec go e =
            match e with
            | WExpr.Let(n, _, _) | WExpr.LetMut(n, _, _) -> acc.Add n
            | WExpr.JoinPoint(_, ps, _, _, _) -> ps |> List.iter (fst >> acc.Add)
            | _ -> ()
            children e |> List.iter go
        go func.Body
        acc
    Set.union (func.Params |> List.map fst |> Set.ofList) (Set.ofSeq fromBody)

/// LocalGet references to names that nothing in `func` binds.  Such a reference is a
/// compiler bug (e.g. a closure that forgot to capture a variable): for numeric types the
/// local silently reads 0, for non-nullable references the module does not validate.
let unboundReferences (func: WFuncDecl) : (string * WType) list =
    let bound = boundNames func
    findAllReferencedLocals func.Body
    |> List.filter (fun (n, t) -> t <> WType.Void && not (Set.contains n bound) && not (isInternal n))
    |> List.distinctBy fst

/// Read the parameters of the join points that survive to emission (the unused and the inlined ones are plain `Let`s)
/// through a cast to their non-nullable type; see `nullableRef`.  Idempotent: the rewritten read is nullable-typed.
/// (Names are unique per function after Phase 4c.)
let castJoinParams (func: WFuncDecl) : WFuncDecl =
    let isApplyOf label e = match e with WExpr.JoinApply(l, _, _) -> l = label | _ -> false
    let nonNullParams =
        func.Body
        |> fold (fun acc e ->
            match e with
            | WExpr.JoinPoint(label, ps, _, cont, _) when exists (isApplyOf label) cont ->
                ps |> List.fold (fun a (n, t) -> match t with WType.Ref(_, false) -> Set.add n a | _ -> a) acc
            | _ -> acc) Set.empty
    if Set.isEmpty nonNullParams then func
    else
        let read e =
            match e with
            | WExpr.LocalGet(n, (WType.Ref(i, false) as t)) when Set.contains n nonNullParams ->
                Some(WExpr.Cast(WExpr.LocalGet(n, WType.Ref(i, true)), t))
            | _ -> None
        { func with Body = rewrite read func.Body }

// ─────────────────────────────────────────────────────────────────
// resolveLocals / makeFunc
// ─────────────────────────────────────────────────────────────────

let resolveLocals (func: WFuncDecl) : WFuncDecl =
    let paramNames = func.Params |> List.map fst |> Set.ofList

    let declaredAll =
        collectLocals paramNames func.Body
        |> List.filter (fun (name, ty) -> ty <> WType.Void && not (isInternal name))

    // Same name bound with two different WASM types cannot be a single local.
    declaredAll
    |> List.groupBy fst
    |> List.iter (fun (n, xs) ->
        if (xs |> List.map snd |> List.distinct |> List.length) > 1 then
            eprintfn "[WasmGc] WARNING: local '%s' in '%s' is bound with conflicting types %A" n func.Name (xs |> List.map snd |> List.distinct))

    let declared = declaredAll |> List.distinctBy fst
    let declaredSet = declared |> List.map fst |> Set.ofList

    let additional =
        findAllReferencedLocals func.Body
        |> List.filter (fun (name, ty) ->
            ty <> WType.Void
            && not (Set.contains name paramNames)
            && not (Set.contains name declaredSet)
            && not (isInternal name))
        |> List.distinctBy fst

    { func with Locals = declared @ additional }

/// Build a WFuncDecl with automatic local collection.
/// Eliminates the collectLocals boilerplate that appears on every helper.
let makeFunc (name: string) (parms: (string * WType) list) (result: WType) (body: WExpr) : WFuncDecl =
    let pset = parms |> List.map fst |> Set.ofList
    { Name     = name
      Params   = parms
      Result   = result
      Locals   = collectLocals pset body
                 |> List.distinctBy fst
                 |> List.filter (fun (n, ty) -> ty <> WType.Void && not (isInternal n))
      Body     = body
      Exported = false }
