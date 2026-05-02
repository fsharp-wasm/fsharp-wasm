/// Local variable collection and WFuncDecl construction.
/// Key invariant: emitter-internal temporaries ($clo_apply_tmp, $switch_tmp)
/// must NEVER appear here — they are either eliminated by Lower.fs or
/// injected by Emit.fs as true stack operations (local.tee with no .Locals entry).
module WasmGc.Runtime.Locals

open WasmGc.Core.AST
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
// findAllReferencedLocals - Local variable collection
// ─────────────────────────────────────────────────────────────────

/// Find all LocalGet names and their types referenced in an expression.
/// These are candidates for the locals list — even if they're not Let-bound,
/// they might be parameters or captured variables that need to be in Locals.
let rec findAllReferencedLocals (expr: WExpr) : (string * WType) list =
    match expr with
    | WExpr.LocalGet(n, ty)                          -> [(n, ty)]
    | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b)    -> findAllReferencedLocals v @ findAllReferencedLocals b
    | WExpr.If(c, t, e, _)                           -> findAllReferencedLocals c @ findAllReferencedLocals t @ findAllReferencedLocals e
    | WExpr.Sequence xs                              -> List.collect findAllReferencedLocals xs
    | WExpr.Loop(_, b, _) | WExpr.Block(_, b, _)    -> findAllReferencedLocals b
    | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _)
    | WExpr.CallIndirect(_, args, _)                 -> List.collect findAllReferencedLocals args
    | WExpr.Binary(_, l, r, _) | WExpr.Compare(_, l, r) -> findAllReferencedLocals l @ findAllReferencedLocals r
    | WExpr.Unary(_, x, _)                           -> findAllReferencedLocals x
    | WExpr.Assign(_, v) | WExpr.GlobalSet(_, v)     -> findAllReferencedLocals v
    | WExpr.JoinPoint(_, _, b, c, _)                 -> findAllReferencedLocals b @ findAllReferencedLocals c
    | WExpr.JoinApply(_, args, _)                    -> List.collect findAllReferencedLocals args
    | WExpr.TryCatch(b, catch, fin, _) ->
        findAllReferencedLocals b
        @ (match catch with Some(_, e) -> findAllReferencedLocals e | None -> [])
        @ (match fin   with Some e     -> findAllReferencedLocals e | None -> [])
    | WExpr.StructNew(_, fs, _) | WExpr.ArrayNewFixed(_, fs, _) -> List.collect findAllReferencedLocals fs
    | WExpr.StructGet(o, _, _)                       -> findAllReferencedLocals o
    | WExpr.StructSet(o, _, v)                       -> findAllReferencedLocals o @ findAllReferencedLocals v
    | WExpr.ArrayGet(a, i, _)                        -> findAllReferencedLocals a @ findAllReferencedLocals i
    | WExpr.ArraySet(a, i, v)                        -> findAllReferencedLocals a @ findAllReferencedLocals i @ findAllReferencedLocals v
    | WExpr.Cast(x, _) | WExpr.RefIsNull x | WExpr.RefTest(x, _) | WExpr.TagOf x | WExpr.ArrayLen x -> findAllReferencedLocals x
    | WExpr.Closure(_, caps, _)                      -> List.collect findAllReferencedLocals caps
    | WExpr.ClosureApply(clo, args, _, _, _, _)
    | WExpr.TailCallRef(clo, args, _, _, _, _)       -> findAllReferencedLocals clo @ List.collect findAllReferencedLocals args
    // LIR nodes (after Lower.fs)
    | WExpr.CallRef(_, args, ptr, _)
    | WExpr.ReturnCallRef(_, args, ptr, _)           -> List.collect findAllReferencedLocals args @ findAllReferencedLocals ptr
    | WExpr.CallVirtual(box, _, _, _, _, args, _)    -> findAllReferencedLocals box @ List.collect findAllReferencedLocals args
    | WExpr.TailCall(_, args, _)                     -> List.collect findAllReferencedLocals args
    | WExpr.SwitchInt(s, cases, def, _) ->
        findAllReferencedLocals s
        @ List.collect (snd >> findAllReferencedLocals) cases
        @ findAllReferencedLocals def
    | WExpr.ArrayCopy(d, do_, s, so, n)              -> List.collect findAllReferencedLocals [d; do_; s; so; n]
    | WExpr.ArrayNew(_, s, init, _)                  -> findAllReferencedLocals s @ findAllReferencedLocals init
    | WExpr.MemLoad(_, _, a)                         -> findAllReferencedLocals a
    | WExpr.MemStore(_, _, a, v)                     -> findAllReferencedLocals a @ findAllReferencedLocals v
    | WExpr.MemoryGrow p                             -> findAllReferencedLocals p
    | _                                              -> []

// ─────────────────────────────────────────────────────────────────
// collectLocals
// ─────────────────────────────────────────────────────────────────

/// Collect all Let/LetMut-bound locals (the WASM locals declaration list).
/// Collect all locals used within a WExpr (for the WASM code section).
/// paramNames: names to exclude (they're already params, not locals).
/// Returns (name, WType) pairs for all Let/LetMut bindings not in paramNames.
let rec collectLocals (paramNames: Set<string>) (expr: WExpr) : (string * WType) list =
    match expr with
    | WExpr.Let(name, value, body) | WExpr.LetMut(name, value, body) ->
        let isExcluded = Set.contains name paramNames || isInternal name
        let local =
            if isExcluded then []
            else
                let valueTy = exprWType value
                let ty =
                    if valueTy <> WType.Void then valueTy
                    else
                        // Infer from first matching LocalGet in body
                        let rec find = function
                            | WExpr.LocalGet(n, t) when n = name && t <> WType.Void -> Some t
                            | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) -> match find v with Some t -> Some t | None -> find b
                            | WExpr.If(c, t, el, _) -> find c |> Option.orElse (find t) |> Option.orElse (find el)
                            | WExpr.Sequence xs -> List.tryPick find xs
                            | WExpr.Loop(_, b, _) | WExpr.Block(_, b, _) -> find b
                            | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _) -> List.tryPick find args
                            | WExpr.Binary(_, l, r, _) | WExpr.Compare(_, l, r) -> find l |> Option.orElse (find r)
                            | WExpr.Unary(_, x, _) -> find x
                            | WExpr.StructGet(o, _, _) | WExpr.ArrayLen o | WExpr.Cast(o, _)
                            | WExpr.RefIsNull o | WExpr.RefTest(o, _) | WExpr.TagOf o -> find o
                            | WExpr.JoinPoint(_, _, b, c, _) -> find b |> Option.orElse (find c)
                            | WExpr.JoinApply(_, args, _) -> List.tryPick find args
                            | WExpr.StructNew(_, fs, _) | WExpr.ArrayNewFixed(_, fs, _) -> List.tryPick find fs
                            | WExpr.ArrayGet(a, i, _) -> find a |> Option.orElse (find i)
                            | WExpr.CallRef(_, args, ptr, _) | WExpr.ReturnCallRef(_, args, ptr, _) ->
                                List.tryPick find args |> Option.orElse (find ptr)
                            | _ -> None
                        match find body with Some t -> t | None -> WType.I32
                if ty = WType.Void then [] else [(name, ty)]
        local @ collectLocals paramNames value @ collectLocals paramNames body

    | WExpr.If(c, t, e, _)           -> collectLocals paramNames c @ collectLocals paramNames t @ collectLocals paramNames e
    | WExpr.Sequence xs               -> List.collect (collectLocals paramNames) xs
    | WExpr.Loop(_, b, _) | WExpr.Block(_, b, _) -> collectLocals paramNames b
    | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _)
    | WExpr.CallIndirect(_, args, _)  -> List.collect (collectLocals paramNames) args
    | WExpr.Binary(_, l, r, _)        -> collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Unary(_, x, _)            -> collectLocals paramNames x
    | WExpr.Compare(_, l, r)          -> collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Assign(_, v) | WExpr.GlobalSet(_, v) -> collectLocals paramNames v
    | WExpr.JoinPoint(_, _, b, c, _)  -> collectLocals paramNames b @ collectLocals paramNames c
    | WExpr.JoinApply(_, args, _)     -> List.collect (collectLocals paramNames) args
    | WExpr.TryCatch(b, catch, fin, _) ->
        collectLocals paramNames b
        @ (match catch with Some(_, e) -> collectLocals paramNames e | None -> [])
        @ (match fin   with Some e     -> collectLocals paramNames e | None -> [])
    | WExpr.StructNew(_, fs, _) | WExpr.ArrayNewFixed(_, fs, _) -> List.collect (collectLocals paramNames) fs
    | WExpr.StructGet(o, _, _)        -> collectLocals paramNames o
    | WExpr.StructSet(o, _, v)        -> collectLocals paramNames o @ collectLocals paramNames v
    | WExpr.ArrayGet(a, i, _)         -> collectLocals paramNames a @ collectLocals paramNames i
    | WExpr.ArraySet(a, i, v)         -> collectLocals paramNames a @ collectLocals paramNames i @ collectLocals paramNames v
    | WExpr.ArrayLen x | WExpr.Cast(x, _) | WExpr.RefIsNull x
    | WExpr.RefTest(x, _) | WExpr.TagOf x -> collectLocals paramNames x
    | WExpr.ArrayCopy(d, do_, s, so, n) -> List.collect (collectLocals paramNames) [d; do_; s; so; n]
    | WExpr.ArrayNew(_, s, init, _)   -> collectLocals paramNames s @ collectLocals paramNames init
    | WExpr.Closure(_, caps, _)       -> List.collect (collectLocals paramNames) caps
    // HIR closure nodes (pre-lowering) — no $clo_apply_tmp injection here
    | WExpr.ClosureApply(clo, args, _, _, _, _)
    | WExpr.TailCallRef(clo, args, _, _, _, _) ->
        collectLocals paramNames clo @ List.collect (collectLocals paramNames) args
    // LIR closure nodes (post-lowering) — $lo_* names collected via Let above
    | WExpr.CallRef(_, args, ptr, _)
    | WExpr.ReturnCallRef(_, args, ptr, _) ->
        List.collect (collectLocals paramNames) args @ collectLocals paramNames ptr
    | WExpr.CallVirtual(box, _, _, _, _, args, _) ->
        collectLocals paramNames box @ List.collect (collectLocals paramNames) args
    | WExpr.SwitchInt(s, cases, def, _) ->
        // No $switch_tmp injection — after Lower, scrutinee is already Let-bound
        collectLocals paramNames s
        @ List.collect (snd >> collectLocals paramNames) cases
        @ collectLocals paramNames def
    | WExpr.MemLoad(_, _, a)          -> collectLocals paramNames a
    | WExpr.MemStore(_, _, a, v)      -> collectLocals paramNames a @ collectLocals paramNames v
    | WExpr.MemoryGrow p              -> collectLocals paramNames p
    | _                               -> []

// ─────────────────────────────────────────────────────────────────
// resolveLocals / makeFunc
// ─────────────────────────────────────────────────────────────────

let resolveLocals (func: WFuncDecl) : WFuncDecl =
    let paramNames = func.Params |> List.map fst |> Set.ofList

    let declared =
        collectLocals paramNames func.Body
        |> List.distinctBy fst
        |> List.filter (fun (name, ty) -> ty <> WType.Void && not (isInternal name))

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
