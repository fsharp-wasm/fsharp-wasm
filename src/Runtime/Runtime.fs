/// String and char runtime helpers for WasmGC.
/// Local variable collection lives in Locals.fs.
/// Structural equality lives in WasmGcEquality.fs.
module WasmGc.Runtime.Runtime

open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Builder
open WasmGc.Builder.Core

open WasmGc.Runtime.Locals
// open WasmGc.Runtime.QuotationWalker

// ─────────────────────────────────────────────────────────────────────────────
// BCL helpers have been extracted to src/Bcl/:
//   StringHelpers.fs    — $strConcat, $strEq, $strIndexOf, $intToStr, etc.
//   CharHelpers.fs      — $charIsDigit, $charToLower, etc.
//   MathHelpers.fs      — $pown, $powF64, $mathSin, etc.
//   StringBuilderHelpers.fs — $sbCreate, $sbAppend, $sbToString
//
// The BCL registry (BclRegistry.fs) maps helper names → builder functions
// and resolves transitive dependencies. buildWModule calls BclRegistry.emitUsed.
// ─────────────────────────────────────────────────────────────────────────────

/// After all functions are translated, fixup any ClosureApply nodes whose
let fixClosureApply (typeDefs: ResizeArray<WTypeDeclEntry>) (functions: WFuncDecl list) : WFuncDecl list =
    let funcTypeToClosureMap =
        let d = System.Collections.Generic.Dictionary<int, int>()
        typeDefs
        |> Seq.mapi (fun i entry -> i, entry)
        |> Seq.choose (fun (i, entry) ->
            match entry.Def with
            // Only match ClosureBase types: direct subtypes of AnyFn (supertype = AnyFnTypeIdx = 0).
            // ClosureType_X structs have supertype = ClosureBase_Y (some non-zero index), so they
            // are excluded here. This is the key invariant: ALL concrete closure types with the
            // same funcTypeIdx share exactly ONE ClosureBase (supertype AnyFn), so ref.cast to
            // that ClosureBase always succeeds regardless of how many captures a closure has.
            | WTypeDef.Struct(codeField :: _, Some parentIdx) when
                    codeField.Name = "code" && parentIdx = AnyFnTypeIdx ->
                match codeField.Type with
                | WType.Ref(funcTypeIdx, _) -> Some(funcTypeIdx, i)
                | _ -> None
            | _ -> None)
        |> Seq.iter (fun (funcTypeIdx, closureBaseIdx) ->
            // Only record the first ClosureBase found for a given funcTypeIdx — there should be
            // exactly one per funcTypeIdx, created eagerly by buildClosure via ClosureBaseTypeMap.
            if not (d.ContainsKey(funcTypeIdx)) then
                d.[funcTypeIdx] <- closureBaseIdx)
        d

    // Lazily create a ClosureBase for a funcTypeIdx if one doesn't exist yet.
    // This handles cases where a higher-order function receives a closure parameter
    // but no closure with that exact apply signature was ever constructed (e.g.,
    // Set.iter takes (int -> unit) but all built closures for that signature
    // have captures, giving them a different lifted func type).
    let getOrCreateClosureBase (funcTypeIdx: int) : int =
        match funcTypeToClosureMap.TryGetValue(funcTypeIdx) with
        | true, cti -> cti
        | false, _ ->
            let idx = typeDefs.Count
            let codeField = { Name = "code"; Type = WType.Ref(funcTypeIdx, false); Mutable = false }
            typeDefs.Add(
                { Name = $"ClosureBase_{idx}"
                  Def = WTypeDef.Struct([codeField], Some AnyFnTypeIdx) })
            funcTypeToClosureMap.[funcTypeIdx] <- idx
            idx

    let rec fix (expr: WExpr) : WExpr =
        match expr with
        | WExpr.ClosureApply(closure, args, funcTypeIdx, 0, captureCount, ty) ->
            let closureTypeIdx = getOrCreateClosureBase funcTypeIdx
            WExpr.ClosureApply(fix closure, List.map fix args, funcTypeIdx, closureTypeIdx, captureCount, ty)
        | WExpr.ClosureApply(closure, args, funcTypeIdx, closureTypeIdx, captureCount, ty) ->
            WExpr.ClosureApply(fix closure, List.map fix args, funcTypeIdx, closureTypeIdx, captureCount, ty)
        | WExpr.Let(n, v, body) -> WExpr.Let(n, fix v, fix body)
        | WExpr.LetMut(n, v, body) -> WExpr.LetMut(n, fix v, fix body)
        | WExpr.If(c, t, e, ty) -> WExpr.If(fix c, fix t, fix e, ty)
        | WExpr.Sequence exprs -> WExpr.Sequence(List.map fix exprs)
        | WExpr.Call(name, args, ty) -> WExpr.Call(name, List.map fix args, ty)
        | WExpr.Loop(l, body, ty) -> WExpr.Loop(l, fix body, ty)
        | WExpr.Block(l, body, ty) -> WExpr.Block(l, fix body, ty)
        | WExpr.JoinPoint(l, p, body, cont, ty) ->
            WExpr.JoinPoint(l, p, fix body, fix cont, ty)
        | WExpr.SwitchInt(s, cases, def, ty) ->
            WExpr.SwitchInt(fix s, List.map (fun (v, e) -> v, fix e) cases, fix def, ty)
        | WExpr.StructNew(typeIdx, fields, ty) ->
            WExpr.StructNew(typeIdx, List.map fix fields, ty)
        | WExpr.ArrayNewFixed(typeIdx, elems, ty) ->
            WExpr.ArrayNewFixed(typeIdx, List.map fix elems, ty)
        | WExpr.TryCatch(body, catch, fin, ty) ->
            let fixCatch = catch |> Option.map (fun (n, e) -> n, fix e)
            let fixFin = fin |> Option.map fix
            WExpr.TryCatch(fix body, fixCatch, fixFin, ty)
        | WExpr.Assign(n, v) -> WExpr.Assign(n, fix v)
        | WExpr.StructSet(obj, idx, v) -> WExpr.StructSet(fix obj, idx, fix v)
        | WExpr.Unary(op, operand, ty) -> WExpr.Unary(op, fix operand, ty)
        | WExpr.Binary(op, a, b, ty) -> WExpr.Binary(op, fix a, fix b, ty)
        | WExpr.Compare(op, a, b) -> WExpr.Compare(op, fix a, fix b)
        | WExpr.Throw(e) -> WExpr.Throw(fix e)
        | WExpr.MemLoad(kind, off, addr) -> WExpr.MemLoad(kind, off, fix addr)
        | WExpr.MemStore(kind, off, addr, v) -> WExpr.MemStore(kind, off, fix addr, fix v)
        | WExpr.MemoryGrow pages -> WExpr.MemoryGrow(fix pages)
        | WExpr.MemorySize -> WExpr.MemorySize
        | _ -> expr

    functions |> List.map (fun f -> { f with Body = fix f.Body })
