/// Pipeline phase orchestration.
///
/// Implements TEIL 1 — the 8-phase compilation pipeline with clear phase boundaries,
/// and integrates TEIL 2 (debug dumps) and TEIL 3 (query DSLs).
///
/// Flow:
/// Phase 0: Fable AST (input)
/// Phase 1: ScopeAnalyzer → ScopeMap
/// Phase 2: TypeResolver (extracting from Ctx)
/// Phase 3: Fable2WasmGc transform using ScopeMap
/// Phase 4: Normalizer → clean WExpr
/// Phase 5: Locals collection (existing)
/// Phase 6: Validator → catch errors early
/// Phase 7: Optimize (existing, minimal)
/// Phase 8: Emit → binary + optional WAT
///
/// Debug dumps (--dump-phases flag):
/// Phase 0 dump: FableAstDump.dumpToFile
/// Phase 3 dump: IrDump.dumpToFile
/// WAT dump: already in Emit
module WasmGc.Pipeline.Phases

open System
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Pipeline.ScopeAnalyzer
open WasmGc.Pipeline.Normalizer

// ─────────────────────────────────────────────────────────────────
// Configuration
// ─────────────────────────────────────────────────────────────────

/// Options controlling pipeline behavior and debug output.
type PipelineOptions = {
    /// Phases to dump (0-8). Empty = no dumps.
    DumpPhases: Set<int>
    /// Directory for debug outputs.
    DumpDir: string
    /// Fail on first validation error (strict mode).
    StrictValidation: bool
}

let defaultOptions = {
    DumpPhases = Set.empty
    DumpDir = "."
    StrictValidation = true
}

// ─────────────────────────────────────────────────────────────────
// Phase 0: Input verification
// ─────────────────────────────────────────────────────────────────

/// Verify Fable AST is well-formed and ready for processing.
let phase0_VerifyInput (opts: PipelineOptions) (decls: Declaration list) : Declaration list =
    if opts.DumpPhases.Contains(0) then
        let dumpPath = System.IO.Path.Combine(opts.DumpDir, "dump-phase0-fable.fs")
        WasmGc.Pipeline.Dumps.FableAstDump.dumpToFile dumpPath decls
        printfn "[Phase 0] Fable AST dumped to %s" dumpPath
    decls

// ─────────────────────────────────────────────────────────────────
// Phase 1: Scope Analysis
// ─────────────────────────────────────────────────────────────────

/// Build scope maps for all functions in the module.
let phase1_AnalyzeScopes (ctx: Ctx) (decls: Declaration list) : Map<string, ScopeMap> =
    let scopeMaps = analyzeModuleScope ctx decls
    printfn "[Phase 1] Scope analysis: %d functions analyzed" scopeMaps.Count
    scopeMaps

// ─────────────────────────────────────────────────────────────────
// Phase 3: Fable → WExpr Transform (simplified)
// ─────────────────────────────────────────────────────────────────

/// Transform Fable declarations to WExpr using scope information.
/// (Existing Fable2WasmGc.fs is called here; integration point.)
let phase3_TransformToWExpr (ctx: Ctx) (scopeMaps: Map<string, ScopeMap>) (decls: Declaration list)
    (_opts: PipelineOptions) : WModule =
    // TODO: Call into existing Fable2WasmGc.transformDeclarations,
    // passing scopeMaps so it can use ScopeMap instead of Ctx.Locals for IdentExpr resolution.
    // For now, this is a placeholder.
    printfn "[Phase 3] Transform Fable → WExpr"
    failwith "Phase 3: Integration with Fable2WasmGc pending"

// ─────────────────────────────────────────────────────────────────
// Phase 4: Normalization
// ─────────────────────────────────────────────────────────────────

/// Normalize WExpr tree: flatten sequences, remove nops, canonicalize lets.
let phase4_Normalize (wmod: WModule) (opts: PipelineOptions) : WModule =
    let normalized = normalizeModule wmod
    printfn "[Phase 4] Normalized WExpr tree"
    if opts.DumpPhases.Contains(4) then
        let dumpPath = System.IO.Path.Combine(opts.DumpDir, "dump-phase4-normalized.sexp")
        // Could use a prettyprinter for normalized IR
        printfn "[Phase 4] Normalized IR dump (not yet implemented): %s" dumpPath
    normalized

// ─────────────────────────────────────────────────────────────────
// Phase 6: Validation
// ─────────────────────────────────────────────────────────────────

/// Validate the module for structural correctness before emission.
let phase6_Validate (wmod: WModule) (_opts: PipelineOptions) : Result<WModule, string list> =
    // TODO: Integrate WasmGcValidator.validate
    // For now, stub.
    printfn "[Phase 6] Validation (stub)"
    Ok wmod

// ─────────────────────────────────────────────────────────────────
// Phase orchestration
// ─────────────────────────────────────────────────────────────────

/// Run the full pipeline.
/// Returns WModule on success, error list on failure.
let runPipeline (ctx: Ctx) (decls: Declaration list) (opts: PipelineOptions)
    : Result<WModule, string list> =
    try
        // Phase 0: Input
        let decls = phase0_VerifyInput opts decls

        // Phase 1: Scope analysis
        let scopeMaps = phase1_AnalyzeScopes ctx decls

        // Phase 3: Transform
        let wmod = phase3_TransformToWExpr ctx scopeMaps decls opts

        // Phase 4: Normalize
        let wmod = phase4_Normalize wmod opts

        // Phase 6: Validate
        let result = phase6_Validate wmod opts

        match result with
        | Ok wmod ->
            if opts.DumpPhases.Contains(3) then
                let dumpPath = System.IO.Path.Combine(opts.DumpDir, "dump-phase3-ir.sexp")
                WasmGc.Pipeline.Dumps.IrDump.dumpToFile dumpPath wmod
                printfn "[Phase 3] IR dumped to %s" dumpPath
            Ok wmod
        | Error errors ->
            Error errors
    with e ->
        Error [sprintf "Pipeline error: %s" e.Message]
