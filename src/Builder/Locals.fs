/// Local variable collection and WFuncDecl construction utilities.
/// Extracted from Runtime.fs — the infrastructure every helper needs.
/// Kept lean so emitters (Emit, Wat) can open this without pulling in
/// all the BCL string/char helpers.
module WasmGc.Runtime.Locals

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Compiler-internal temporaries — must NEVER appear in .Locals
// ─────────────────────────────────────────────────────────────────

/// Names injected by the EMITTER at code-generation time.
/// These are stack temporaries that the emitter inserts unconditionally;
/// they must not appear in the wasm `(local ...)` declarations because
/// the emitter does NOT use local.get/local.set for them — it uses
/// local.tee inline on the value stack.
///
/// Invariant: resolveLocals MUST strip these from every Locals list.
let private emitterInternalTemps =
    Set.ofList [
        "$clo_apply_tmp"       // local.tee target for call_ref self-arg
        "$switch_tmp"          // br_table target for SwitchInt
        "$fsharp_exn_carrier"  // exception tag global, not a local
    ]

let private isEmitterInternal (name: string) =
    Set.contains name emitterInternalTemps

// ─────────────────────────────────────────────────────────────────
// Local variable collection
// ─────────────────────────────────────────────────────────────────

/// Find all LocalGet names and their types referenced in an expression.
/// These are candidates for the locals list — even if they're not Let-bound,
/// they might be parameters or captured variables that need to be in Locals.
let rec findAllReferencedLocals (expr: WExpr) : (string * WType) list =
    match expr with
    | WExpr.LocalGet(name, ty) -> [(name, ty)]
    | WExpr.Let(_, value, body) | WExpr.LetMut(_, value, body) ->
        findAllReferencedLocals value @ findAllReferencedLocals body
    | WExpr.If(c, t, e, _) ->
        findAllReferencedLocals c @ findAllReferencedLocals t @ findAllReferencedLocals e
    | WExpr.Sequence exprs ->
        exprs |> List.collect findAllReferencedLocals
    | WExpr.Loop(_, body, _) | WExpr.Block(_, body, _) ->
        findAllReferencedLocals body
    | WExpr.Call(_, args, _) | WExpr.CallIndirect(_, args, _) ->
        args |> List.collect findAllReferencedLocals
    | WExpr.Binary(_, l, r, _) ->
        findAllReferencedLocals l @ findAllReferencedLocals r
    | WExpr.Unary(_, op, _) ->
        findAllReferencedLocals op
    | WExpr.Compare(_, l, r) ->
        findAllReferencedLocals l @ findAllReferencedLocals r
    | WExpr.Assign(_, v) | WExpr.GlobalSet(_, v) ->
        findAllReferencedLocals v
    | WExpr.JoinPoint(_, _, body, cont, _) ->
        findAllReferencedLocals body @ findAllReferencedLocals cont
    | WExpr.JoinApply(_, args, _) ->
        args |> List.collect findAllReferencedLocals
    | WExpr.TryCatch(body, catch, fin, _) ->
        let catchRefs = match catch with Some(_, e) -> findAllReferencedLocals e | None -> []
        let finRefs   = match fin with Some e -> findAllReferencedLocals e | None -> []
        findAllReferencedLocals body @ catchRefs @ finRefs
    | WExpr.StructNew(_, fields, _) | WExpr.ArrayNewFixed(_, fields, _) ->
        fields |> List.collect findAllReferencedLocals
    | WExpr.StructGet(obj, _, _) ->
        findAllReferencedLocals obj
    | WExpr.StructSet(obj, _, v) ->
        findAllReferencedLocals obj @ findAllReferencedLocals v
    | WExpr.ArrayGet(arr, idx, _) ->
        findAllReferencedLocals arr @ findAllReferencedLocals idx
    | WExpr.ArraySet(arr, idx, v) ->
        findAllReferencedLocals arr @ findAllReferencedLocals idx @ findAllReferencedLocals v
    | WExpr.Cast(obj, _) | WExpr.RefIsNull obj | WExpr.RefTest(obj, _)
    | WExpr.TagOf obj | WExpr.ArrayLen obj ->
        findAllReferencedLocals obj
    | WExpr.Closure(_, captures, _) ->
        captures |> List.collect findAllReferencedLocals
    | WExpr.ClosureApply(closure, args, _, _, _, _)
    | WExpr.TailCallRef(closure, args, _, _, _, _) ->
        findAllReferencedLocals closure @ (args |> List.collect findAllReferencedLocals)
    | WExpr.CallVirtual(box, _, _, _, _, args, _) ->
        findAllReferencedLocals box @ (args |> List.collect findAllReferencedLocals)
    | WExpr.TailCall(_, args, _) ->
        args |> List.collect findAllReferencedLocals
    | WExpr.SwitchInt(scrutinee, cases, default_, _) ->
        findAllReferencedLocals scrutinee
        @ (cases |> List.collect (fun (_, body) -> findAllReferencedLocals body))
        @ findAllReferencedLocals default_
    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        findAllReferencedLocals dst  @ findAllReferencedLocals dstOff
        @ findAllReferencedLocals src @ findAllReferencedLocals srcOff
        @ findAllReferencedLocals len
    | WExpr.ArrayNew(_, size, init, _) ->
        findAllReferencedLocals size @ findAllReferencedLocals init
    | WExpr.MemLoad(_, _, addr) ->
        findAllReferencedLocals addr
    | WExpr.MemStore(_, _, addr, value) ->
        findAllReferencedLocals addr @ findAllReferencedLocals value
    | WExpr.MemoryGrow pages ->
        findAllReferencedLocals pages
    | _ -> []

/// Collect all Let/LetMut-bound locals (the WASM locals declaration list).
/// Collect all locals used within a WExpr (for the WASM code section).
/// paramNames: names to exclude (they're already params, not locals).
/// Returns (name, WType) pairs for all Let/LetMut bindings not in paramNames.
let rec collectLocals (paramNames: Set<string>) (expr: WExpr) : (string * WType) list =
    match expr with
    | WExpr.Let(name, value, body) | WExpr.LetMut(name, value, body) ->
        let valueTy = exprWType value
        let local =
            if Set.contains name paramNames || isEmitterInternal name then []
            else
                // If the value has Void type (e.g., WExpr.Nop from unhandled calls),
                // infer the local type from how it's used (LocalGet) in the body.
                let ty =
                    if valueTy <> WType.Void then valueTy
                    else
                        // Find/Infer from first LocalGet(name, _) usage in body to get the actual type
                        let rec findType (e: WExpr) =
                            match e with
                            | WExpr.LocalGet(n, ty) when n = name && ty <> WType.Void -> Some ty
                            | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) ->
                                match findType v with Some ty -> Some ty | None -> findType b
                            | WExpr.If(c, thenE, elseE, _) ->
                                match findType c with
                                | Some ty -> Some ty
                                | None ->
                                    match findType thenE with
                                    | Some ty -> Some ty
                                    | None -> findType elseE
                            | WExpr.Sequence exprs -> exprs |> List.tryPick findType
                            | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _) ->
                                args |> List.tryPick findType
                            | WExpr.StructGet(obj, _, _) | WExpr.ArrayLen obj
                            | WExpr.Cast(obj, _)
                            | WExpr.RefIsNull obj
                            | WExpr.RefTest(obj, _)
                            | WExpr.TagOf obj
                            | WExpr.Loop(_, obj, _)
                            | WExpr.Block(_, obj, _) -> findType obj
                            | WExpr.Unary(_, obj, _) -> findType obj
                            | WExpr.Binary(_, l, r, _) | WExpr.Compare(_, l, r) ->
                                match findType l with Some ty -> Some ty | None -> findType r
                            | WExpr.JoinPoint(_, _, b, cont, _) ->
                                match findType b with Some ty -> Some ty | None -> findType cont
                            | WExpr.JoinApply(_, args, _) -> args |> List.tryPick findType
                            | WExpr.StructNew(_, fields, _) -> fields |> List.tryPick findType
                            | WExpr.ArrayNewFixed(_, elems, _) -> elems |> List.tryPick findType
                            | WExpr.ArrayGet(arr, idx, _) ->
                                match findType arr with Some ty -> Some ty | None -> findType idx
                            | _ -> None
                        match findType body with
                        | Some t -> t
                        | None   -> WType.I32  // last resort: assume I32
                if ty = WType.Void then []
                else [(name, ty)]
        local @ collectLocals paramNames value @ collectLocals paramNames body

    | WExpr.If(c, t, e, _) ->
        collectLocals paramNames c @ collectLocals paramNames t @ collectLocals paramNames e
    | WExpr.Sequence exprs ->
        exprs |> List.collect (collectLocals paramNames)
    | WExpr.Loop(_, body, _)
    | WExpr.Block(_, body, _) ->
        collectLocals paramNames body
    | WExpr.Call(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.CallIndirect(func, args, _) ->
        collectLocals paramNames func @ (args |> List.collect (collectLocals paramNames))
    | WExpr.Binary(_, l, r, _) ->
        collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Unary(_, op, _) ->
        collectLocals paramNames op
    | WExpr.Compare(_, l, r) ->
        collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Assign(_, v)
    | WExpr.GlobalSet(_, v) ->
        collectLocals paramNames v
    | WExpr.JoinPoint(_, _, body, cont, _) ->
        collectLocals paramNames body @ collectLocals paramNames cont
    | WExpr.JoinApply(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.TryCatch(body, catch, fin, _) ->
        // The catch ident is declared via WExpr.Let(ident, GlobalGet($fsharp_exn_carrier), ...)
        // inside the handler expression itself — collectLocals on `expr` will find it.
        let catchLocals = match catch with Some(_, e) -> collectLocals paramNames e | None -> []
        let finLocals   = match fin with Some e -> collectLocals paramNames e | None -> []
        collectLocals paramNames body @ catchLocals @ finLocals
    | WExpr.StructNew(_, fields, _) ->
        fields |> List.collect (collectLocals paramNames)
    | WExpr.StructGet(obj, _, _) -> collectLocals paramNames obj
    | WExpr.StructSet(obj, _, v) ->
        collectLocals paramNames obj @ collectLocals paramNames v
    | WExpr.ArrayNewFixed(_, elems, _) ->
        elems |> List.collect (collectLocals paramNames)
    | WExpr.ArrayGet(arr, idx, _) ->
        collectLocals paramNames arr @ collectLocals paramNames idx
    | WExpr.ArraySet(arr, idx, v) ->
        collectLocals paramNames arr @ collectLocals paramNames idx @ collectLocals paramNames v
    | WExpr.ArrayLen arr  -> collectLocals paramNames arr
    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        collectLocals paramNames dst
        @ collectLocals paramNames dstOff
        @ collectLocals paramNames src
        @ collectLocals paramNames srcOff
        @ collectLocals paramNames len
    | WExpr.ArrayNew(_, size, init, _) ->
        collectLocals paramNames size @ collectLocals paramNames init
    | WExpr.RefIsNull obj
    | WExpr.RefTest(obj, _)
    | WExpr.Cast(obj, _) ->
        collectLocals paramNames obj
    | WExpr.Closure(_, captures, _) ->
        captures |> List.collect (collectLocals paramNames)
    | WExpr.ClosureApply(closure, args, _, _, _, _) ->
        // OLD LOGIC Always register $clo_apply_tmp (emitter uses local.tee unconditionally)
        // let tmpLocal = ["$clo_apply_tmp", WType.Ref(AnyFnTypeIdx, false)]
        // tmpLocal @ // .... TODO: 

        // NOTE: $clo_apply_tmp is NOT added here — it's an emitter-internal temp
        // injected by the WAT/binary emitter as a local.tee target; it must not
        // appear in the WASM locals list.        
        collectLocals paramNames closure
        @ (args |> List.collect (collectLocals paramNames))
    | WExpr.TailCall(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.TailCallRef(closure, args, _, _, _, _) ->
        // Same as ClosureApply — $clo_apply_tmp is emitter-internal
        // TODO: also OLD LOGIC has to move
        collectLocals paramNames closure
        @ (args |> List.collect (collectLocals paramNames))
    | WExpr.CallVirtual(box, _, _, _, _, args, _) ->
        // box is evaluated twice in the emitter (always a LocalGet in practice)
        collectLocals paramNames box
        @ (args |> List.collect (collectLocals paramNames))
    | WExpr.SwitchInt(scrutinee, cases, default_, _) ->
        // TODO: OLD LOGIC below has to move 
        // // Must add $switch_tmp local that the emitter uses unconditionally
        // let switchTmpLocal = ["$switch_tmp", WType.I32]
        // switchTmpLocal
        // @ 

        // NOTE: $switch_tmp is NOT added here — emitter-internal
        collectLocals paramNames scrutinee
        @ (cases |> List.collect (fun (_, body) -> collectLocals paramNames body))
        @ collectLocals paramNames default_
    | WExpr.TagOf obj       -> collectLocals paramNames obj
    // Linear memory — no new locals; just recurse into sub-expressions
    | WExpr.MemLoad(_, _, addr) -> collectLocals paramNames addr
    | WExpr.MemStore(_, _, addr, value) ->
        collectLocals paramNames addr @ collectLocals paramNames value
    | WExpr.MemoryGrow pages -> collectLocals paramNames pages
    | WExpr.MemorySize -> []
    | _ -> []

/// Fill in the Locals field of a WFuncDecl by scanning the body.
/// Strips emitter-internal temporaries ($clo_apply_tmp, $switch_tmp) — those
/// are injected by the emitter and must NOT appear in the wasm locals list.
/// Collects both explicit Let/LetMut bindings and any referenced LocalGet variables
/// that aren't parameters. This ensures closure captures are properly included.
let resolveLocals (func: WFuncDecl) : WFuncDecl =
    let paramNames = func.Params |> List.map fst |> Set.ofList

    // Pass 1: Let/LetMut-declared locals
    // First pass: collect declared locals (Let/LetMut bindings)
    let declaredLocals =
        collectLocals paramNames func.Body
        |> List.distinctBy fst
        |> List.filter (fun (name, ty) ->
            ty <> WType.Void && not (isEmitterInternal name))

    let declaredNames = declaredLocals |> List.map fst |> Set.ofList

    // Pass 2: LocalGet references not covered by params or declared locals
    // (captures that are referenced but weren't let-bound in THIS function body)
    // Second pass: find all referenced locals (LocalGet references)
    let additionalLocals =
        findAllReferencedLocals func.Body
        |> List.filter (fun (name, _) ->
            not (Set.contains name paramNames)   &&
            not (Set.contains name declaredNames) &&
            not (isEmitterInternal name))
        |> List.distinctBy fst
        |> List.filter (fun (_, ty) -> ty <> WType.Void)

    { func with Locals = declaredLocals @ additionalLocals }

/// Build a WFuncDecl with automatic local collection.
/// Eliminates the collectLocals boilerplate that appears on every helper.
let makeFunc
        (name    : string)
        (parms   : (string * WType) list)
        (result  : WType)
        (body    : WExpr)
        : WFuncDecl =
    let paramNames = parms |> List.map fst |> Set.ofList
    { Name     = name
      Params   = parms
      Result   = result
      Locals   =
          collectLocals paramNames body
          |> List.distinctBy fst
          |> List.filter (fun (name, ty) -> ty <> WType.Void && not (isEmitterInternal name))
      Body     = body
      Exported = false }
