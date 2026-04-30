/// Pipeline phase orchestration — TEIL 1 full implementation.
///
/// 8 phases with hard input/output type contracts:
///
///   Phase 0  Input verification + FableAstDump
///   Phase 1  ScopeAnalyzer   → ScopeMap per function
///   Phase 2  TypeResolver    (integrated into Ctx; called on-demand per type)
///   Phase 3  Fable → WExpr   (Fable2Wasm + TransformExpr, using ScopeMap)
///   Phase 4  Normalizer      → clean, flat WExpr (prerequisite for Phase 5)
///   Phase 5  Locals          → WFuncDecl with resolved locals (existing)
///   Phase 6  Validator       → structural correctness before emit
///   Phase 7  Optimize        → constant-fold, DCE (existing, minimal)
///   Phase 8  Emit            → WAT text + .wasm binary
///
/// Key invariant: Phase 5 (collectLocals) runs AFTER Phase 4 (Normalizer).
/// Violation of this order causes double-counted locals and "unknown local" traps.
module WasmGc.Pipeline.Phases

open System
open System.IO
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Pipeline.ScopeAnalyzer
open WasmGc.Pipeline.Normalizer

module Dump    = WasmGc.Pipeline.Dumps
module L       = WasmGc.Runtime.Locals
module Valid   = WasmGc.Pipeline.Validator
module Opt     = WasmGc.Emit.Optimize

// ─────────────────────────────────────────────────────────────────
// Pipeline configuration
// ─────────────────────────────────────────────────────────────────

/// Options controlling debug output and strictness for one compilation run.
[<Struct>]
type PipelineOptions = {
    /// Phase numbers whose debug dump should be written.
    /// 0 = Fable AST, 3 = raw WExpr IR, 8 = WAT (always written by emitter).
    DumpPhases    : Set<int>
    /// Root directory for debug dump files.
    DumpDir       : string
    /// Fail hard on the first validation error rather than collecting them all.
    StrictValidation : bool
    /// Log phase timings to stderr.
    Timings       : bool
}

let defaultOptions : PipelineOptions = {
    DumpPhases       = Set.empty
    DumpDir          = "."
    StrictValidation = true
    Timings          = false
}

/// Construct options from a comma-separated phase list string (e.g. "0,3,8").
let optionsFromDumpFlag (dumpFlag: string) (dumpDir: string) : PipelineOptions =
    let phases =
        if String.IsNullOrWhiteSpace dumpFlag then Set.empty
        else
            dumpFlag.Split(',')
            |> Array.choose (fun s ->
                match System.Int32.TryParse(s.Trim()) with
                | true, n -> Some n
                | _ -> None)
            |> Set.ofArray
    { defaultOptions with DumpPhases = phases; DumpDir = dumpDir }

// ─────────────────────────────────────────────────────────────────
// Timing helper
// ─────────────────────────────────────────────────────────────────

let private timed (opts: PipelineOptions) (label: string) (f: unit -> 'a) : 'a =
    if opts.Timings then
        let sw = System.Diagnostics.Stopwatch.StartNew()
        let result = f ()
        sw.Stop()
        eprintfn "  [%s] %.1f ms" label sw.Elapsed.TotalMilliseconds
        result
    else f ()

// ─────────────────────────────────────────────────────────────────
// Dump helpers
// ─────────────────────────────────────────────────────────────────

let private ensureDir (dir: string) =
    if not (Directory.Exists dir) then Directory.CreateDirectory dir |> ignore

let private dumpIf (opts: PipelineOptions) (phase: int) (action: string -> unit) =
    if opts.DumpPhases.Contains phase then
        ensureDir opts.DumpDir
        action opts.DumpDir

// ─────────────────────────────────────────────────────────────────
// Phase 0 — Input verification + optional Fable AST dump
// ─────────────────────────────────────────────────────────────────

/// Verify and optionally dump the incoming Fable declarations.
/// Returns the same list unchanged — this phase is purely observational.
let phase0_Input (opts: PipelineOptions) (decls: Declaration list) : Declaration list =
    timed opts "Phase0-Input" (fun () ->
        dumpIf opts 0 (fun dir ->
            let path = Path.Combine(dir, "dump-phase0-fable.fs")
            WasmGc.Util.FableAstDump.dumpToFile path decls
            eprintfn "  [Phase 0] Fable AST → %s" path)
        decls)

// ─────────────────────────────────────────────────────────────────
// Phase 1 — Scope Analysis
// ─────────────────────────────────────────────────────────────────

/// Single-pass scope analysis for all MemberDeclarations.
/// Result: Map<functionName, ScopeMap>
/// Each ScopeMap records, for every identifier in that function:
///   - Kind (Local | FreeVar | ModuleValue | KnownFunc)
///   - WType (placeholder I32 until Phase 2 resolves it)
///   - Depth (lambda nesting level where it is bound)
let phase1_ScopeAnalysis
        (ctx: Ctx)
        (opts: PipelineOptions)
        (decls: Declaration list)
        : Map<string, ScopeMap> =
    timed opts "Phase1-Scope" (fun () ->
        let scopeMaps = analyzeModuleScope ctx decls
        if opts.Timings || opts.DumpPhases.Contains 1 then
            eprintfn "  [Phase 1] %d functions analyzed" scopeMaps.Count
        scopeMaps)

// ─────────────────────────────────────────────────────────────────
// Phase 2 — Type Resolution
// ─────────────────────────────────────────────────────────────────
//
// Type resolution is integrated into Ctx via mapTypeKnown / resolveType.
// It runs on-demand during Phase 3 for each Fable.Type encountered.
// No separate orchestration step required — the Ctx.TypeDefs ResizeArray
// accumulates registrations in place.
//
// The TypeResolver module (src/Pipeline/TypeResolver.fs) exposes the
// type-registration helpers (getOrAddArrayType etc.) for use in Phase 3.

// ─────────────────────────────────────────────────────────────────
// Phase 3 — Fable → WExpr Transform
// ─────────────────────────────────────────────────────────────────

/// Transform Fable declarations to WModule using scope information from Phase 1.
///
/// Integration note: TransformExpr.transformIdentExpr should receive the
/// ScopeMap for the current function and use classifyIdent instead of
/// Map.tryFind ctx.Locals. The scopeMaps parameter is threaded through.
///
/// Until that refactor is complete, we call the existing Fable2Wasm pipeline
/// directly and pass scopeMaps for future use.
let phase3_Transform
        (ctx: Ctx)
        (scopeMaps: Map<string, ScopeMap>)
        (opts: PipelineOptions)
        (decls: Declaration list)
        : WModule =
    timed opts "Phase3-Transform" (fun () ->
        // Pass scopeMaps into the transform context so TransformExpr can use
        // classifyIdent for IdentExpr resolution instead of Map.tryFind ctx.Locals.
        // ScopeMaps are stored in ctx.ScopeMaps (added to Ctx in Types.fs).
        let ctxWithScopes = { ctx with ScopeMaps = scopeMaps }

        // Call the existing lowering pipeline. buildWModule already calls
        // processFileIntoCtx internally; here we build the raw module from
        // whatever has been accumulated in ctx.
        let rawModule = WasmGc.Transforms.Fable2Wasm.buildWModule ctxWithScopes

        dumpIf opts 3 (fun dir ->
            let path = Path.Combine(dir, "dump-phase3-raw-ir.sexp")
            WasmGc.Util.IrDump.dumpToFile path rawModule
            eprintfn "  [Phase 3] Raw WExpr IR → %s" path)

        rawModule)

// ─────────────────────────────────────────────────────────────────
// Phase 4 — Normalization
// ─────────────────────────────────────────────────────────────────

/// Normalize the WExpr tree before locals collection.
///
/// Performs (in order):
///   1. Flatten Sequence([Sequence([...]), ...]) → single flat list
///   2. Remove Nop entries from Sequence lists (except lone Nop)
///   3. Canonicalize Let(x, e, Let(x, e', body)) — prevent double-registration
///      by Phase 5 (collectLocals)
///
/// MUST run before Phase 5. Without this, collectLocals may see:
///   - Double Let bindings for the same name → duplicate local declarations
///   - Nop nodes interrupting sequence structure → missed let-bindings in branches
let phase4_Normalize (opts: PipelineOptions) (wmod: WModule) : WModule =
    timed opts "Phase4-Normalize" (fun () ->
        let normalized = normalizeModule wmod
        dumpIf opts 4 (fun dir ->
            let path = Path.Combine(dir, "dump-phase4-normalized.sexp")
            WasmGc.Util.IrDump.dumpToFile path normalized
            eprintfn "  [Phase 4] Normalized IR → %s" path)
        normalized)

// ─────────────────────────────────────────────────────────────────
// Phase 5 — Locals Collection
// ─────────────────────────────────────────────────────────────────

/// Collect all Let/LetMut-bound names and build the final WFuncDecl.Locals list.
///
/// Runs on the NORMALIZED WExpr from Phase 4.  Running on raw Phase 3 output
/// risks missing branch-local names (DecisionTree targets) or double-counting
/// duplicate Lets that Normalizer would have collapsed.
let phase5_ResolveLocals (opts: PipelineOptions) (wmod: WModule) : WModule =
    timed opts "Phase5-Locals" (fun () ->
        { wmod with Functions = wmod.Functions |> List.map L.resolveLocals })

// ─────────────────────────────────────────────────────────────────
// Phase 6 — Validation
// ─────────────────────────────────────────────────────────────────

/// Validate the normalized+locals-resolved module before optimization/emission.
///
/// Catches:
///   - ClosureApply call_ref stack underflow (arity mismatch against registered functype)
///   - LocalGet references to names not in params or locals (would trap in emitter)
///   - Void-arg filter dropping real arguments (closure_4 bug class)
///   - Unreachable code after unconditional Break/Continue
///
/// With StrictValidation=true (default), logs errors and returns Error.
/// With StrictValidation=false, logs warnings and returns Ok (for incremental dev).
let phase6_Validate
        (opts: PipelineOptions)
        (wmod: WModule)
        : Result<WModule, Valid.ValidationError list> =
    timed opts "Phase6-Validate" (fun () ->
        let errors = Valid.validate false wmod.TypeDefs wmod.Functions
        if errors.IsEmpty then
            Ok wmod
        else
            let errorMsgs = errors |> List.map (fun e -> sprintf "[%s] %s: %s" e.FuncName e.NodeDesc e.Message)
            errorMsgs |> List.iter (eprintfn "  Validation error: %s")
            if opts.StrictValidation then
                Error errors
            else
                eprintfn "  [Phase 6] %d validation error(s) — continuing (StrictValidation=false)" errors.Length
                Ok wmod)

// ─────────────────────────────────────────────────────────────────
// Phase 7 — Optimization
// ─────────────────────────────────────────────────────────────────

/// Apply constant folding and trivial dead-code elimination.
/// Currently minimal; join-point inlining may introduce new Let bindings,
/// so Phase 5 (resolveLocals) is re-run after optimization.
let phase7_Optimize (opts: PipelineOptions) (wmod: WModule) : WModule =
    timed opts "Phase7-Optimize" (fun () ->
        let optimized = Opt.optimizeModule wmod
        // Re-run locals after optimization: join-point inlining may have
        // introduced new Let bindings (e.g. db_2 = arg) not visible before.
        { optimized with Functions = optimized.Functions |> List.map L.resolveLocals })

// ─────────────────────────────────────────────────────────────────
// Phase 8 — Emission (WAT + binary)
// ─────────────────────────────────────────────────────────────────
//
// Emission is handled by the caller (Pipeline.Core / compileFile) which
// writes WAT and invokes wasm-tools or the built-in encoder.
// This module only carries type information forward.

// ─────────────────────────────────────────────────────────────────
// Full pipeline — orchestrates Phase 0–7
// ─────────────────────────────────────────────────────────────────

/// Run phases 0–7 on a pre-populated Ctx.
///
/// The Ctx is assumed to already contain all declarations (accumulated by
/// processFileIntoCtx across multiple source files).  Emission (Phase 8) is
/// left to the caller so it can choose WAT path and binary encoding strategy.
///
/// Returns:
///   Ok wmod    — validated, optimized, locals-resolved WModule ready for emit
///   Error errs — validation failed; errs is the ValidationError list
let runPipeline
        (ctx: Ctx)
        (decls: Declaration list)
        (opts: PipelineOptions)
        : Result<WModule, Valid.ValidationError list> =

    // Phase 0 — verify + optional Fable AST dump
    let decls = phase0_Input opts decls

    // Phase 1 — scope analysis
    let scopeMaps = phase1_ScopeAnalysis ctx opts decls

    // Phase 3 — Fable → raw WExpr
    // (Phase 2 runs on-demand inside mapTypeKnown / resolveType)
    let rawModule = phase3_Transform ctx scopeMaps opts decls

    // Phase 4 — normalize WExpr (MUST precede Phase 5)
    let normalizedModule = phase4_Normalize opts rawModule

    // Phase 5 — resolve locals on normalized tree
    let localizedModule = phase5_ResolveLocals opts normalizedModule

    // Phase 6 — validate
    match phase6_Validate opts localizedModule with
    | Error errs -> Error errs
    | Ok validModule ->

    // Phase 7 — optimize (re-resolves locals after inlining)
    let finalModule = phase7_Optimize opts validModule

    Ok finalModule

/// Convenience: run pipeline and raise on validation failure (CI / strict mode).
let runPipelineStrict
        (ctx: Ctx)
        (decls: Declaration list)
        (opts: PipelineOptions)
        : WModule =
    match runPipeline ctx decls opts with
    | Ok wmod -> wmod
    | Error errs ->
        let msg =
            errs
            |> List.map (fun e -> sprintf "  [%s] %s: %s" e.FuncName e.NodeDesc e.Message)
            |> String.concat "\n"
        failwithf "WasmGC pipeline validation failed:\n%s" msg
