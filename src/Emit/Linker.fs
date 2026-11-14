/// WasmGC Static Module Linker.
///
/// Merges multiple WModule values into a single WModule before binary encoding.
/// This is Strategy A from MODULE-LINKING-SPEC.md: compile-time static linking.
///
/// Algorithm:
///   1. Compute structural keys for all types in all modules
///   2. Deduplicate types globally (same key → same output index)
///   3. Build per-module type-index remap tables
///   4. Rewrite all WExpr trees using the remap tables
///   5. Deduplicate functions (resolved imports + duplicate BCL helpers)
///   6. Produce merged WModule
///
/// Invariant: input modules are in dependency order — if B imports from A,
/// A appears before B in the list.
module WasmGc.Emit.Linker

open System.Collections.Generic
open WasmGc.Core.AST
open WasmGc.Util.WExprQuery

// ─────────────────────────────────────────────────────────────────────────────
// Structural type keys — enables deduplication across module boundaries
// ─────────────────────────────────────────────────────────────────────────────

/// Compute a stable structural key for a WTypeDef.
/// Two WTypeDefs with equal keys are structurally identical and can be merged.
///
/// Keys are built recursively: type references within the def are replaced
/// by the key of the referenced type (not its index), producing a
/// self-contained description that doesn't depend on module-local indexing.
///
/// `typeKey: int -> string` resolves a local type index to its already-computed key.
let rec private typeDefKey (typeKey: int -> string) (def: WTypeDef) : string =
    let tyKey =
        let rec wt = function
            | WType.I32 -> "i32" | WType.I64 -> "i64"
            | WType.F32 -> "f32" | WType.F64 -> "f64"
            | WType.I16 -> "i16" | WType.I8 -> "i8" | WType.Void -> "void"
            | WType.Externref -> "ext" | WType.ExternNonNull -> "extnn" | WType.I31ref -> "i31"
            | WType.EqRef -> "eq"   | WType.AnyRef -> "any"
            | WType.Ref(idx, false) -> $"ref({typeKey idx})"
            | WType.Ref(idx, true)  -> $"refn({typeKey idx})"
            | WType.Func(ps, rs) ->
                let p = ps |> List.map wt |> String.concat ","
                let r = rs |> List.map wt |> String.concat ","
                $"fn({p})->({r})"
            | WType.Struct fields ->
                let fs = fields |> List.map (fun f -> $"""{f.Name}:{wt f.Type}:{if f.Mutable then "m" else ""}""") |> String.concat ";"
                $"struct({fs})"
            | WType.Array(elem, mut) ->
                $"""arr({wt elem},{if mut then "m" else ""})"""
        wt
    match def with
    | WTypeDef.Struct(fields, parent) ->
        let fs = fields |> List.map (fun f -> $"{f.Name}:{tyKey f.Type}") |> String.concat ";"
        let p  = parent |> Option.map (fun i -> $"<{typeKey i}") |> Option.defaultValue ""
        $"struct({fs}){p}"
    | WTypeDef.Array(elem, mut) ->
        $"""array({tyKey elem},{if mut then "m" else "i"})"""
    | WTypeDef.Func(ps, result) ->
        let p = ps |> List.map tyKey |> String.concat ","
        let r = tyKey result
        $"func({p})->({r})"

// ─────────────────────────────────────────────────────────────────────────────
// Type remap table — maps (moduleIdx, localTypeIdx) → merged globalTypeIdx
// ─────────────────────────────────────────────────────────────────────────────

type TypeRemapTable = { Map: Map<int, int> }

module TypeRemapTable =
    let identity count = { Map = [0..count-1] |> List.map (fun i -> i, i) |> Map.ofList }
    let remap (t: TypeRemapTable) (localIdx: int) =
        match Map.tryFind localIdx t.Map with
        | Some g -> g
        | None   -> failwithf "Linker: type index %d not in remap table" localIdx

// ─────────────────────────────────────────────────────────────────────────────
// WExpr type-index rewriting
// ─────────────────────────────────────────────────────────────────────────────

/// Rewrite all type indices in a WType using the remap table.
let rec private remapWType (remap: int -> int) : WType -> WType = function
    | WType.Ref(idx, n) -> WType.Ref(remap idx, n)
    | WType.Func(ps, rs) -> WType.Func(List.map (remapWType remap) ps, List.map (remapWType remap) rs)
    | WType.Struct fields ->
        WType.Struct(fields |> List.map (fun f -> { f with Type = remapWType remap f.Type }))
    | WType.Array(elem, mut) -> WType.Array(remapWType remap elem, mut)
    | t -> t   // primitives: I32, I64, F32, F64, I16, Void, AnyRef, etc.

/// Rewrite all type references within a WExpr.
/// This is the core of the linker: makes module B's WExprs valid in the merged module.
let rec private remapExpr (rt: int -> int) (expr: WExpr) : WExpr =
    let r = remapExpr rt
    let t = remapWType rt
    match expr with
    // Expressions that carry explicit WType
    | WExpr.LocalGet(n, ty)          -> WExpr.LocalGet(n, t ty)
    | WExpr.GlobalGet(n, ty)         -> WExpr.GlobalGet(n, t ty)
    | WExpr.Const(WConst.Null ty)    -> WExpr.Const(WConst.Null(t ty))
    | WExpr.Binary(op, a, b, ty)     -> WExpr.Binary(op, r a, r b, t ty)
    | WExpr.Unary(op, a, ty)         -> WExpr.Unary(op, r a, t ty)
    | WExpr.Compare(op, a, b)        -> WExpr.Compare(op, r a, r b)
    | WExpr.If(c, th, el, ty)        -> WExpr.If(r c, r th, r el, t ty)
    | WExpr.Block(lbl, body, ty)     -> WExpr.Block(lbl, r body, t ty)
    | WExpr.Loop(lbl, body, ty)      -> WExpr.Loop(lbl, r body, t ty)
    | WExpr.Let(n, v, body)          -> WExpr.Let(n, r v, r body)
    | WExpr.LetMut(n, v, body)       -> WExpr.LetMut(n, r v, r body)
    | WExpr.Assign(n, v)             -> WExpr.Assign(n, r v)
    | WExpr.GlobalSet(n, v)          -> WExpr.GlobalSet(n, r v)
    | WExpr.Sequence exprs           -> WExpr.Sequence(List.map r exprs)
    | WExpr.Call(fn, args, ty)       -> WExpr.Call(fn, List.map r args, t ty)
    | WExpr.CallRef(fti, args, ptr, ty) -> WExpr.CallRef(rt fti, List.map r args, r ptr, t ty)
    | WExpr.ReturnCallRef(fti, a, p, ty) -> WExpr.ReturnCallRef(rt fti, List.map r a, r p, t ty)
    | WExpr.Return(Some e)           -> WExpr.Return(Some(r e))
    | WExpr.Break(lbl, Some v)       -> WExpr.Break(lbl, Some(r v))
    // Array ops
    | WExpr.ArrayNew(ti, sz, init, ty)   -> WExpr.ArrayNew(rt ti, r sz, r init, t ty)
    | WExpr.ArrayNewFixed(ti, elems, ty) -> WExpr.ArrayNewFixed(rt ti, List.map r elems, t ty)
    | WExpr.ArrayGet(arr, i, ty)         -> WExpr.ArrayGet(r arr, r i, t ty)
    | WExpr.ArraySet(arr, i, v)          -> WExpr.ArraySet(r arr, r i, r v)
    | WExpr.ArrayLen e                   -> WExpr.ArrayLen(r e)
    | WExpr.ArrayCopy(d, di, s, si, len) -> WExpr.ArrayCopy(r d, r di, r s, r si, r len)
    // Struct ops
    | WExpr.StructNew(ti, fs, ty)    -> WExpr.StructNew(rt ti, List.map r fs, t ty)
    | WExpr.StructGet(s, f, ty)      -> WExpr.StructGet(r s, f, t ty)
    | WExpr.StructSet(s, f, v)       -> WExpr.StructSet(r s, f, r v)
    // Cast / test
    | WExpr.Cast(e, ty)              -> WExpr.Cast(r e, t ty)
    | WExpr.RefTest(e, ty)           -> WExpr.RefTest(r e, t ty)
    // Closure ops
    | WExpr.Closure(fn, caps, ty)    -> WExpr.Closure(fn, List.map r caps, t ty)
    | WExpr.ClosureApply(clo, args, fti, cti, n, ty) ->
        WExpr.ClosureApply(r clo, List.map r args, rt fti, rt cti, n, t ty)
    | WExpr.TailCallRef(clo, args, fti, cti, n, ty) ->
        WExpr.TailCallRef(r clo, List.map r args, rt fti, rt cti, n, t ty)
    // TryCatch
    | WExpr.TryCatch(body, catches, final, ty) ->
        WExpr.TryCatch(r body, catches |> Option.map (fun (tag, h) -> tag, r h), Option.map r final, t ty)
    // Leaf / passthrough
    | e -> e

/// Rewrite a WFuncDecl's type references.
let private remapFunc (rt: int -> int) (rwt: WType -> WType) (f: WFuncDecl) : WFuncDecl =
    { f with
        Params  = f.Params  |> List.map (fun (n, ty) -> n, rwt ty)
        Result  = rwt f.Result
        Locals  = f.Locals  |> List.map (fun (n, ty) -> n, rwt ty)
        Body    = remapExpr rt f.Body }

// ─────────────────────────────────────────────────────────────────────────────
// Main linker
// ─────────────────────────────────────────────────────────────────────────────

type LinkOptions = {
    /// Keep all exports from all modules. False = keep only last module's exports.
    UnionExports: bool
    /// Function names that should be deduplicated (same name = same body assumed).
    /// Always includes BCL helpers ($strConcat etc.).
    DeduplicateFunctions: bool
}

module LinkOptions =
    let defaults = { UnionExports = true; DeduplicateFunctions = true }

type LinkDiagnostic =
    | DuplicateExport of name: string * modules: string list
    | UnresolvedImport of name: string * fromModule: string
    | TypeDeduplication of key: string * keptIdx: int

type LinkResult = {
    Module      : WModule
    Diagnostics : LinkDiagnostic list
}

/// Link multiple WModules into one.
/// Modules must be in dependency order (dependencies first).
let link (opts: LinkOptions) (modules: (string * WModule) list) : LinkResult =
    let diags = ResizeArray<LinkDiagnostic>()

    // ── Step 1: build global type table with deduplication ────────────────────
    // keyToGlobalIdx: structural key → global type index
    // globalTypeDefs: final merged list of WTypeDeclEntry
    let keyToGlobalIdx = Dictionary<string, int>()
    let globalTypeDefs = ResizeArray<WTypeDeclEntry>()

    // Per-module remap tables: localIdx → globalIdx
    let moduleMaps = Array.create modules.Length Map.empty

    for mi, (_, m) in List.indexed modules do
        // We process types in order; for forward references (parent types etc.)
        // we need the key of already-processed types.
        let localKeys = Dictionary<int, string>()   // localIdx → key (for this module)
        let localToGlobal = ResizeArray<int>()       // localIdx → globalIdx

        for li, entry in List.indexed m.Types do
            // Resolve type references within this def using already-known local keys
            let getKey (localIdx: int) =
                match localKeys.TryGetValue(localIdx) with
                | true, k -> k
                | _ -> $"?{localIdx}"  // forward reference — structural key approximation

            let key  = typeDefKey getKey entry.Def
            localKeys.[li] <- key

            let gIdx =
                match keyToGlobalIdx.TryGetValue(key) with
                | true, existing ->
                    diags.Add(TypeDeduplication(key, existing))
                    existing   // already in merged table — reuse
                | _ ->
                    let idx = globalTypeDefs.Count
                    keyToGlobalIdx.[key] <- idx
                    globalTypeDefs.Add { entry with Name = entry.Name }
                    idx

            localToGlobal.Add(gIdx)

        moduleMaps.[mi] <- localToGlobal |> Seq.mapi (fun i g -> i, g) |> Map.ofSeq

    // ── Step 2: build remap functions ─────────────────────────────────────────
    let makeRemap (mi: int) =
        let map = moduleMaps.[mi]
        fun (localIdx: int) ->
            match Map.tryFind localIdx map with
            | Some g -> g
            | None   -> failwithf "Linker: module %d has no remap for type index %d" mi localIdx

    // ── Step 3: collect all exports (to resolve imports) ─────────────────────
    // exportedFuncs: export-name → (source module index, internal function name)
    let exportedFuncs = Dictionary<string, int * string>()
    for mi, (mname, m) in List.indexed modules do
        for exp in m.Exports do
            if exp.Kind = ExportFunc then
                if exportedFuncs.ContainsKey(exp.ExportName) then
                    let (prevMi, _) = exportedFuncs.[exp.ExportName]
                    diags.Add(DuplicateExport(exp.ExportName, [fst modules.[prevMi]; mname]))
                exportedFuncs.[exp.ExportName] <- (mi, exp.InternalName)

    // ── Step 4: merge functions (dedup by name, resolve imports) ─────────────
    let mergedFuncs = ResizeArray<WFuncDecl>()
    let seenFuncNames = HashSet<string>()

    // External imports (not satisfied by any module in the link set)
    let externalImports = ResizeArray<WImport>()
    let resolvedImportNames = HashSet<string>()  // imports resolved to direct calls

    // First pass: process imports — mark which are resolved internally
    for mi, (mname, m) in List.indexed modules do
        for imp in m.Imports do
            match imp.Desc with
            | ImportFunc _ ->
                if exportedFuncs.ContainsKey(imp.Name) then
                    resolvedImportNames.Add(imp.Name) |> ignore
                else
                    // External import — keep it (deduplicated)
                    let key = $"{imp.ModuleName}/{imp.Name}"
                    if not (externalImports |> Seq.exists (fun e -> $"{e.ModuleName}/{e.Name}" = key)) then
                        externalImports.Add(imp)
                    else
                        diags.Add(UnresolvedImport(imp.Name, mname))
            | _ -> ()

    // Second pass: merge function bodies
    let rt (mi: int) = makeRemap mi
    let rwt (mi: int) = remapWType (rt mi)

    for mi, (_, m) in List.indexed modules do
        for func in m.Functions do
            let dedup = opts.DeduplicateFunctions && func.Name.StartsWith("$")  // BCL helpers
            if not dedup || seenFuncNames.Add(func.Name) then
                mergedFuncs.Add(remapFunc (rt mi) (rwt mi) func)

    // ── Step 5: merge globals ─────────────────────────────────────────────────
    let mergedGlobals = ResizeArray<WGlobalDecl>()
    let seenGlobals   = HashSet<string>()
    for mi, (_, m) in List.indexed modules do
        for g in m.Globals do
            if seenGlobals.Add(g.Name) then
                mergedGlobals.Add { 
                    g with
                        Type = rwt mi g.Type
                        Init = remapExpr (rt mi) g.Init }

    // ── Step 6: merge exports ─────────────────────────────────────────────────
    let mergedExports =
        if opts.UnionExports then
            modules
            |> List.collect (fun (_, m) -> m.Exports)
            |> List.distinctBy (fun e -> e.ExportName)
        else
            // Only last module's exports
            snd (List.last modules) |> (fun m -> m.Exports)

    // Memory export (at most one)
    let hasMemory = modules |> List.exists (fun (_, m) -> m.HasLinearMemory)

    // ── Step 7: merge tags ────────────────────────────────────────────────────
    let mergedTags =
        modules
        |> List.collect (fun (_, m) -> m.Tags)
        |> List.distinctBy (fun t -> t.Name)

    let merged : WModule = {
        Types         = globalTypeDefs |> Seq.toList
        Imports       = externalImports |> Seq.toList
        Functions     = mergedFuncs |> Seq.toList
        Globals       = mergedGlobals |> Seq.toList
        Exports       = mergedExports
        DataSegments  = modules |> List.collect (fun (_, m) -> m.DataSegments)
        Tags          = mergedTags
        Start         = modules |> List.tryPick (fun (_, m) -> m.Start)
        HasLinearMemory = hasMemory
    }

    { Module = merged; Diagnostics = diags |> Seq.toList }

/// Convenience: link without diagnostics (throws on error).
let linkModules (modules: (string * WModule) list) : WModule =
    let result = link LinkOptions.defaults modules
    // Report warnings
    for d in result.Diagnostics do
        match d with
        | UnresolvedImport(name, m) ->
            eprintfn "[WGC-Linker] WARNING: unresolved import '%s' from module '%s'" name m
        | DuplicateExport(name, ms) ->
            eprintfn "[WGC-Linker] WARNING: duplicate export '%s' from modules: %s" name (String.concat ", " ms)
        | TypeDeduplication _ -> ()   // Info only
    result.Module
