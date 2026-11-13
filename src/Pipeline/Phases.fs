/// Pipeline phase orchestration.
///
///   Phase 0   Input + optional FableAstDump
///   Phase 1   ScopeAnalyzer  → ScopeMap per function
///   Phase 2   type mapping   (on-demand via mapTypeKnown, no separate step)
///   Phase 3   Fable → raw WExpr
///   Phase 4   Normalizer     → flat, Nop-free WExpr
///   Phase 4b  Lower          → ClosureApply/SwitchInt → Let+CallRef/BrTable (LIR)
///   Phase 5   Locals         → WFuncDecl.Locals collected from clean LIR
///   Phase 6   Validator      → structural checks, no emit-time surprises
///   Phase 7   Optimize       → DCE/const-fold, re-runs Phase 5
///   Phase 8   Emit           → WAT + .wasm (owned by caller)
///
/// Ordering invariants:
///   4 before 4b  — Normalizer removes noise before Lower introduces new Lets
///   4b before 5  — collectLocals must see $lo_* bindings from Lower
///   5 before 6   — Validator needs resolved .Locals for unknown-ref checks
///   7 re-runs 5  — join-point inlining adds Lets not visible before optimization
module WasmGc.Pipeline.Phases

open System
open System.IO

open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Pipeline.ScopeAnalyzer
open WasmGc.Pipeline.Normalizer
open WasmGc.Pipeline.UniqueLocals
open WasmGc.Pipeline.Lower

module Dump    = WasmGc.Pipeline.Dumps
module L       = WasmGc.Runtime.Locals
module Valid   = WasmGc.Pipeline.Validator
module Opt     = WasmGc.Emit.Optimize

// ─────────────────────────────────────────────────────────────────
// Pipeline configuration / Options
// ─────────────────────────────────────────────────────────────────

/// Options controlling debug output and strictness for one compilation run.
[<Struct>]
type PipelineOptions = {
    /// Phase numbers to write dumps for.
    /// 0=Fable, 3=raw WExpr, 4=normalized, 42=lowered LIR, 5=with locals, 8=WAT
    DumpPhases    : Set<int>
    /// Root directory for debug dump files.
    DumpDir       : string
    /// Fail hard on the first validation error rather than collecting them all.
    StrictValidation : bool
    /// Log phase timings to stderr.
    Timings       : bool
    /// Suppress progress/debug logging.
    Quiet         : bool
}

let defaultOptions : PipelineOptions = {
    DumpPhases       = Set.empty
    DumpDir          = "."
    StrictValidation = true
    Timings          = false
    Quiet            = false
}

/// Construct options from a comma-separated phase list string (e.g. "0,3,8").
let optionsFromDumpFlag (flag: string) (dir: string) : PipelineOptions =
    let phases =
        if String.IsNullOrWhiteSpace flag then Set.empty
        else
            flag.Split(',')
            |> Array.choose (fun s ->
                match Int32.TryParse(s.Trim()) with
                | true, n -> Some n
                | _       -> None)
            |> Set.ofArray

    { defaultOptions with
        DumpPhases = phases
        DumpDir = dir }

/// Options from the environment, so every entry point (CLI, tests, CI) can dump without a flag plumbed
/// through Fable's CLI:  WASMGC_DUMP_PHASES="0,3,8"  WASMGC_DUMP_DIR=<dir>  WASMGC_TIMINGS=1
let optionsFromEnv () : PipelineOptions =
    let env name fallback =
        match Environment.GetEnvironmentVariable name with
        | null | "" -> fallback
        | v -> v
    { optionsFromDumpFlag (env "WASMGC_DUMP_PHASES" "") (env "WASMGC_DUMP_DIR" ".") with
        Timings = env "WASMGC_TIMINGS" "" <> "" }

// ─────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────


// ─────────────────────────────────────────────────────────────────────────────
// Pipeline logger — wraps eprintfn so tests can silence progress output.
// Set WASMGC_QUIET=1 or pass PipelineOptions.Quiet=true to suppress.
// ─────────────────────────────────────────────────────────────────────────────
let private log (opts: PipelineOptions) fmt =
    if opts.Quiet then
        let nullWriter = new System.IO.StringWriter()
        Printf.fprintfn (nullWriter :> System.IO.TextWriter) fmt
    else
        Printf.eprintfn fmt

let private timed (opts: PipelineOptions) (label: string) (f: unit -> 'a) : 'a =
    if opts.Timings then
        let sw = System.Diagnostics.Stopwatch.StartNew()
        let result = f ()
        sw.Stop()
        log opts "  [%s] %.1f ms" label sw.Elapsed.TotalMilliseconds
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

let phase0_Input (opts: PipelineOptions) (decls: Declaration list) =
    timed opts "Phase0" (fun () ->
        dumpIf opts 0 (fun dir ->
            let p = Path.Combine(dir, "dump-phase0-fable.fs")
            WasmGc.Util.FableAstDump.dumpToFile p decls
            log opts "  [Phase 0] %s" p)
        decls)

// ─────────────────────────────────────────────────────────────────
// Phase 1 — Scope analysis
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
        let maps = analyzeModuleScope ctx decls
        if opts.Timings || opts.DumpPhases.Contains 1 then
            log opts "  [Phase 1] %d functions analyzed" maps.Count
        maps)

// ─────────────────────────────────────────────────────────────────
// Phase 2 — Type Resolution
// ─────────────────────────────────────────────────────────────────
//
// Type resolution is integrated into Ctx via mapTypeKnown / resolveType.
// It runs on-demand during Phase 3 for each Fable.Type encountered.
// No separate orchestration step required — the Ctx.TypeDefs ResizeArray
// accumulates registrations in place.
//
// The type-registration helpers (getOrAddArrayType etc.) are in Core/Types.fs.

// ─────────────────────────────────────────────────────────────────
// Phase 3 — Fable → (raw) WExpr Transform
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
        // `{ ctx with ScopeMaps = scopeMaps }`

        // Call the existing lowering pipeline. buildWModule already calls
        // processFileIntoCtx internally; here we build the raw module from
        // whatever has been accumulated in ctx.
        let raw = WasmGc.Transforms.Fable2Wasm.buildWModule { ctx with ScopeMaps = scopeMaps }
        dumpIf opts 3 (fun dir ->
            let p = Path.Combine(dir, "dump-phase3-raw-ir.sexp")
            WasmGc.Util.IrDump.dumpToFile p raw
            log opts "  [Phase 3] %s" p)
        raw)

// ─────────────────────────────────────────────────────────────────
// Phase 4 — Normalize
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
        let norm = normalizeModule wmod
        dumpIf opts 4 (fun dir ->
            let p = Path.Combine(dir, "dump-phase4-normalized.sexp")
            WasmGc.Util.IrDump.dumpToFile p norm
            log opts "  [Phase 4] Normalized IR → %s" p)
        norm)

// ─────────────────────────────────────────────────────────────────
// Phase 4b — Lower (HIR → LIR)
// ─────────────────────────────────────────────────────────────────

/// Convert high-level ClosureApply / TailCallRef / SwitchInt into
/// primitive Let + CallRef / ReturnCallRef / BrTable nodes.
/// After this phase Emit.fs needs zero temporary injection logic.
let phase4b_Lower (opts: PipelineOptions) (wmod: WModule) =
    timed opts "Phase4b" (fun () ->
        let low = lowerModule wmod
        dumpIf opts 42 (fun dir ->
            let p = Path.Combine(dir, "dump-phase4b-lir.sexp")
            WasmGc.Util.IrDump.dumpToFile p low
            log opts "  [Phase 4b] %s" p)
        low)

// ─────────────────────────────────────────────────────────────────
// Phase 4c — Unique locals
// ─────────────────────────────────────────────────────────────────

/// Make every binder name unique per function (scope-aware renaming).  WASM locals are flat, the
/// builders scope names lexically and reuse fixed temporaries (`$limit`, loop counters of nested
/// array helpers, lambda parameters of inlined HOFs): without this, nested `for` loops and nested
/// array helpers overwrite each other's locals.  Phase 5 recomputes `Locals` from the result.
let phase4c_UniqueLocals (opts: PipelineOptions) (wmod: WModule) : WModule =
    timed opts "Phase4c-UniqueLocals" (fun () ->
        let uniq = WasmGc.Pipeline.UniqueLocals.uniqueModule wmod
        dumpIf opts 43 (fun dir ->
            let p = Path.Combine(dir, "dump-phase4c-unique.sexp")
            WasmGc.Util.IrDump.dumpToFile p uniq
            log opts "  [Phase 4c] %s" p)
        uniq)

// ─────────────────────────────────────────────────────────────────
// Phase 5 — Locals Collection - Resolve locals
// ─────────────────────────────────────────────────────────────────

/// Collect all Let/LetMut-bound names and build the final WFuncDecl.Locals list.
///
/// Runs on the NORMALIZED WExpr from Phase 4.  Running on raw Phase 3 output
/// risks missing branch-local names (DecisionTree targets) or double-counting
/// duplicate Lets that Normalizer would have collapsed.
///
/// Must run AFTER Phase 4b so $lo_* bindings introduced by Lower are visible.
let phase5_ResolveLocals (opts: PipelineOptions) (wmod: WModule) : WModule =
    timed opts "Phase5-Locals" (fun () ->
        { wmod with Functions = List.map L.resolveLocals wmod.Functions })

// ─────────────────────────────────────────────────────────────────
// Phase 6 — Validate
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
let phase6_Validate (opts: PipelineOptions) (wmod: WModule) =
    timed opts "Phase6-Validate" (fun () ->
        let typeDefs = new ResizeArray<WTypeDeclEntry>(wmod.Types)
        // let typeDefs = ResizeArray wmod.Types
        // let typeDefs = wmod.Types
        let errors   = Valid.validate false typeDefs wmod.Functions
        if errors.IsEmpty then Ok wmod
        else
            errors |> List.iter (fun e ->
                log opts "  ✗ [%s] %s: %s" e.FuncName e.NodeDesc e.Message)
            if opts.StrictValidation
            then Error errors
            else
                eprintfn "  [Phase 6] %d error(s) — continuing" errors.Length
                Ok wmod)

// ─────────────────────────────────────────────────────────────────
// Phase 7 — Optimize
// ─────────────────────────────────────────────────────────────────

let phase7_Optimize (opts: PipelineOptions) (wmod: WModule) =
    timed opts "Phase7" (fun () ->
        let opt = Opt.optimizeModule wmod
        // Re-resolve locals: join-point inlining may have introduced new Lets.  Only now is it known which join
        // points survive, so their (nullable) parameters are read through casts here.
        { opt with Functions = opt.Functions |> List.map (L.castJoinParams >> L.resolveLocals) })

// ─────────────────────────────────────────────────────────────────
// Phase 8 — Emission (WAT + binary)
// ─────────────────────────────────────────────────────────────────
//
// Emission is handled by the caller (Pipeline.Core / compileFile) which
// writes WAT and invokes wasm-tools or the built-in encoder.
// This module only carries type information forward.

// ─────────────────────────────────────────────────────────────────
// Full pipeline
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
    let decls     = phase0_Input opts decls

    // Phase 1 — scope analysis
    let scopes    = phase1_ScopeAnalysis ctx opts decls

    // Phase 3 — Fable → raw WExpr
    // (Phase 2 runs on-demand inside mapTypeKnown / resolveType)
    let raw       = phase3_Transform ctx scopes opts decls

    // Phase 4 — normalize WExpr (MUST precede Phase 5)
    let norm      = phase4_Normalize opts raw

    let lir       = phase4b_Lower opts norm        // ← new

    // Phase 4c — one binder, one name per function (flat WASM locals vs. lexical builders)
    let uniq      = phase4c_UniqueLocals opts lir

    // Phase 5 — resolve locals on normalized tree
    let withLoc   = phase5_ResolveLocals opts uniq  // ← after Lower + UniqueLocals

    // Phase 6 — validate
    match phase6_Validate opts withLoc with
    | Error e -> Error e
    // Phase 7 — optimize (re-resolves locals after inlining)
    | Ok valid -> Ok (phase7_Optimize opts valid)

    // TODO: phase 7 integrated above
    // Phase 7 — optimize (re-resolves locals after inlining)
    // let finalModule = phase7_Optimize opts validModule
    // Ok finalModule

/// Convenience: run pipeline and raise on validation failure (CI / strict mode).
let runPipelineStrict (ctx: Ctx) (decls: Declaration list) (opts: PipelineOptions) =
    match runPipeline ctx decls opts with
    | Ok m -> m
    | Error errs ->
        errs
        |> List.map (fun e -> sprintf "  [%s] %s: %s" e.FuncName e.NodeDesc e.Message)
        |> String.concat "\n"
        |> failwithf "Pipeline validation failed:\n%s"

