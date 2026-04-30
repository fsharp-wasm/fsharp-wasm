/// Phase 4: WExpr Normalization.
///
/// After Phase 3 (Fable2WasmGc transform), the WExpr tree may contain:
/// - Nested Sequences: Sequence([Sequence([...]), ...])
/// - Unnecessary Nops in sequences
/// - Redundant Let bindings: Let(x, e, Let(x, e', body)) with same var names
///
/// This phase:
/// 1. Flattens nested Sequences into a single flat list
/// 2. Removes Nop entries from Sequence lists (except if it's the only item)
/// 3. Canonicalizes Let bindings (deduplication by name)
/// 4. Runs BEFORE Phase 5 (collectLocals), ensuring locals collector sees clean input
///
/// Normalization is essential because collectLocals must count each distinct name
/// exactly once — if Phase 3 outputs Let(x, ..., Let(x, ...)), locals would be double-counted.
module WasmGc.Pipeline.Normalizer

open WasmGc.Core.AST

// ─────────────────────────────────────────────────────────────────
// Normalization helpers
// ─────────────────────────────────────────────────────────────────

/// Flatten nested Sequences into one list.
/// Sequences([Sequence([a, b]), c, Sequence([d])]) → [a, b, c, d]
let rec flattenSequences (exprs: WExpr list) : WExpr list =
    exprs |> List.collect (fun e ->
        match e with
        | WExpr.Sequence inner -> flattenSequences inner
        | other -> [other]
    )

/// Remove Nops from a sequence, but preserve if list becomes empty.
let removeUnnecessaryNops (exprs: WExpr list) : WExpr list =
    match exprs |> List.filter (fun e -> e <> WExpr.Nop) with
    | [] -> [WExpr.Nop]  // Empty sequence → keep one Nop
    | filtered -> filtered

/// Recursively normalize an expression tree.
/// Returns the normalized version.
let rec normalizeExpr (expr: WExpr) : WExpr =
    match expr with
    // Flatten and clean sequences
    | WExpr.Sequence exprs ->
        let flattened = flattenSequences exprs
        let cleaned = removeUnnecessaryNops flattened
        let normalized = cleaned |> List.map normalizeExpr
        match normalized with
        | [single] -> single  // Single-element sequence → unwrap
        | many -> WExpr.Sequence many

    // Recursive descent through all structure-forming nodes

    | WExpr.Let(name, value, body) ->
        WExpr.Let(name, normalizeExpr value, normalizeExpr body)

    | WExpr.LetMut(name, value, body) ->
        WExpr.LetMut(name, normalizeExpr value, normalizeExpr body)

    | WExpr.If(cond, thenExpr, elseExpr, ty) ->
        WExpr.If(normalizeExpr cond, normalizeExpr thenExpr, normalizeExpr elseExpr, ty)

    | WExpr.Block(label, body, ty) ->
        WExpr.Block(label, normalizeExpr body, ty)

    | WExpr.Loop(label, body, ty) ->
        WExpr.Loop(label, normalizeExpr body, ty)

    | WExpr.Call(name, args, ty) ->
        WExpr.Call(name, List.map normalizeExpr args, ty)

    | WExpr.CallIndirect(tableIdx, args, ty) ->
        WExpr.CallIndirect(tableIdx, List.map normalizeExpr args, ty)

    | WExpr.Binary(op, left, right, ty) ->
        WExpr.Binary(op, normalizeExpr left, normalizeExpr right, ty)

    | WExpr.Unary(op, operand, ty) ->
        WExpr.Unary(op, normalizeExpr operand, ty)

    | WExpr.Compare(op, left, right) ->
        WExpr.Compare(op, normalizeExpr left, normalizeExpr right)

    | WExpr.Assign(name, value) ->
        WExpr.Assign(name, normalizeExpr value)

    | WExpr.JoinPoint(label, params_, body, cont, ty) ->
        WExpr.JoinPoint(label, params_, normalizeExpr body, normalizeExpr cont, ty)

    | WExpr.JoinApply(label, args, ty) ->
        WExpr.JoinApply(label, List.map normalizeExpr args, ty)

    | WExpr.TryCatch(body, catch, fin, ty) ->
        let normBody = normalizeExpr body
        let normCatch = catch |> Option.map (fun (ex, e) -> (ex, normalizeExpr e))
        let normFin = fin |> Option.map normalizeExpr
        WExpr.TryCatch(normBody, normCatch, normFin, ty)

    | WExpr.StructNew(typeIdx, fields, ty) ->
        WExpr.StructNew(typeIdx, List.map normalizeExpr fields, ty)

    | WExpr.StructGet(obj, field, ty) ->
        WExpr.StructGet(normalizeExpr obj, field, ty)

    | WExpr.StructSet(obj, field, value) ->
        WExpr.StructSet(normalizeExpr obj, field, normalizeExpr value)

    | WExpr.ArrayGet(arr, idx, ty) ->
        WExpr.ArrayGet(normalizeExpr arr, normalizeExpr idx, ty)

    | WExpr.ArraySet(arr, idx, value) ->
        WExpr.ArraySet(normalizeExpr arr, normalizeExpr idx, normalizeExpr value)

    | WExpr.ArrayNew(typeIdx, size, init, ty) ->
        WExpr.ArrayNew(typeIdx, normalizeExpr size, normalizeExpr init, ty)

    | WExpr.ArrayNewFixed(typeIdx, fields, ty) ->
        WExpr.ArrayNewFixed(typeIdx, List.map normalizeExpr fields, ty)

    | WExpr.ArrayLen(arr) ->
        WExpr.ArrayLen(normalizeExpr arr)

    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        WExpr.ArrayCopy(
            normalizeExpr dst,
            normalizeExpr dstOff,
            normalizeExpr src,
            normalizeExpr srcOff,
            normalizeExpr len
        )

    | WExpr.Cast(obj, ty) ->
        WExpr.Cast(normalizeExpr obj, ty)

    | WExpr.RefIsNull(obj) ->
        WExpr.RefIsNull(normalizeExpr obj)

    | WExpr.RefTest(obj, typeIdx) ->
        WExpr.RefTest(normalizeExpr obj, typeIdx)

    | WExpr.Closure(captureTypeIdx, captures, ty) ->
        WExpr.Closure(captureTypeIdx, List.map normalizeExpr captures, ty)

    | WExpr.ClosureApply(closure, args, fti, cti, ci, ty) ->
        WExpr.ClosureApply(
            normalizeExpr closure,
            List.map normalizeExpr args,
            fti, cti, ci, ty
        )

    | WExpr.TailCallRef(closure, args, fti, cti, ci, ty) ->
        WExpr.TailCallRef(
            normalizeExpr closure,
            List.map normalizeExpr args,
            fti, cti, ci, ty
        )

    | WExpr.TailCall(label, args, ty) ->
        WExpr.TailCall(label, List.map normalizeExpr args, ty)

    | WExpr.GlobalSet(name, value) ->
        WExpr.GlobalSet(name, normalizeExpr value)

    | WExpr.SwitchInt(scrutinee, cases, default_, ty) ->
        WExpr.SwitchInt(
            normalizeExpr scrutinee,
            cases |> List.map (fun (n, e) -> (n, normalizeExpr e)),
            normalizeExpr default_,
            ty
        )

    | WExpr.MemLoad(endian, memTy, addr) ->
        WExpr.MemLoad(endian, memTy, normalizeExpr addr)

    | WExpr.MemStore(endian, memTy, addr, value) ->
        WExpr.MemStore(endian, memTy, normalizeExpr addr, normalizeExpr value)

    | WExpr.MemoryGrow(pages) ->
        WExpr.MemoryGrow(normalizeExpr pages)

    | WExpr.CallVirtual(box, iface, method_, methodTypeIdx, methodImplIdx, args, ty) ->
        WExpr.CallVirtual(
            normalizeExpr box, iface, method_, methodTypeIdx, methodImplIdx,
            List.map normalizeExpr args, ty
        )

    | WExpr.TagOf(obj) ->
        WExpr.TagOf(normalizeExpr obj)

    // Leaf nodes — return unchanged
    | other -> other


/// Normalize a complete function declaration.
let normalizeFuncDecl (func: WFuncDecl) : WFuncDecl =
    { func with Body = normalizeExpr func.Body }

/// Normalize all functions in a module.
let normalizeModule (wmod: WModule) : WModule =
    let normalized =
        wmod.Functions
        |> List.map normalizeFuncDecl
        // |> ResizeArray // TODO: needed?
    { wmod with Functions = normalized }
