// In-Memory Compiler Pipeline Helper — F# → AST → IR → WAT → WASM (no CLI shelling)
//
// Pipeline:
//   1. FCS parse + type-check        (FSharpChecker)
//   2. FCS → Fable AST               (FSharp2Fable.Compiler.transformFile)
//   3. WasmGC-safe Fable transforms  (WasmTransformPipeline.transformFileForWasm — NO JS)
//   4. Fable AST → WasmGC IR         (processFileIntoCtx + Phases 3–7)
//   5. WAT emission                  (Emit.Wat.moduleToWat)
//   6. Optional WASM binary          (wasm-tools or wasm-as)
//
// This module provides a full-featured in-process compiler that runs F# source strings
// through the complete WasmGC pipeline without shelling out to CLI or writing files.
//
// Pipeline stages:
//   1. F# source string
//   2. Parse & type-check via FSharp.Compiler.Service (FCS)
//   3. F# AST → Fable AST (FSharp2Fable)
//   4. Fable transformations (inlining, tail calls, etc.)
//   5. Fable AST → WasmGC IR context (Fable2Wasm)
//   6. Raw WModule (Phase 3-4)
//   7. Normalized WModule
//   8. WAT text emission
//   9. Optional: WASM binary (via wasm-as or wasm-opt)
//
// Usage:
//   match InMemoryPipelineHelper.compileSource fsharpSource with
//   | Ok stages -> assertWat stages.WatText ...
//   | Error msg -> printfn "compile error: %s" msg
//
namespace Tests

open System.IO
open System.Diagnostics
open FSharp.Compiler.CodeAnalysis
open FSharp.Compiler.Text
open Fable
open Fable.AST
open WasmGc.Core.AST

module WasmXform = WasmGc.Transforms.FableAstGate
module Phases    = WasmGc.Pipeline.Phases

// ──────────────────────────────────────────────────────────────────────────────
// Minimal result computation expression
// ──────────────────────────────────────────────────────────────────────────────

[<AutoOpen>]
module private ResultCE =
    type ResultBuilder() =
        member _.Return v     = Ok v
        member _.ReturnFrom r = r
        member _.Bind(r, f)   = Result.bind f r
        member _.Zero()       = Ok ()
        member _.Delay f      = f
        member _.Run f        = f ()
    let result = ResultBuilder()

// ─────────────────────────────────────────────────────────────────
// Output types
// ─────────────────────────────────────────────────────────────────

type CompilationStages =
    {
        /// The original F# source code
        FSharpSource        : string

        /// FCS type-checked declarations (before Fable transform).
        /// F# Compiler Service type-checked declarations
        FcsDeclarations     : FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list

        /// Fable intermediate AST produced by FSharp2Fable (before our transforms).
        FableAstRaw         : Fable.AST.Fable.File

        /// Fable AST after WasmGC-safe transforms.
        FableAstTransformed : Fable.AST.Fable.File

        /// WasmGC IR before normalization (Phase 3 output).
        WModuleRaw          : WModule

        /// WasmGC IR after all pipeline phases (normalized, lowered, optimized).
        WModuleNormalized   : WModule

        /// WAT text — primary human-readable output.
        WatText             : string

        /// Optional WASM binary (only if wasm-as / wasm-tools is available).
        WasmBinary          : byte[] option
    }

/// Compile result wrapped in Result type for error handling
type CompileResult = Result<CompilationStages, string>

// ──────────────────────────────────────────────────────────────────────────────
// Stage 2-3: Mock Fable.Compiler for in-memory compilation
// Uses FSharp.Wasm.Core (not vendor Fable.Core).
// ──────────────────────────────────────────────────────────────────────────────

// TODO: Another Mock.Compiler ??? really? 
/// Implements Fable.Compiler using pre-parsed FCS declarations held in memory.
/// TryGetEntity returns None — sufficient for tests that don't use reflection/plugins.
type private MockCompiler(fcsDecls: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list) =

    let libDir =
        let candidates = [
            Path.Combine(__SOURCE_DIRECTORY__, "../../../core/FSharp.Wasm.Core")
            Path.Combine(__SOURCE_DIRECTORY__, "../../../../core/FSharp.Wasm.Core")
        ]
        candidates |> List.tryFind Directory.Exists |> Option.defaultValue "."

    let opts : CompilerOptions =
        { TypedArrays           = true
          ClampByteArrays       = false
          Language              = Language.WasmGc
          Define                = []
          DebugMode             = false
          OptimizeFSharpAst     = true
          Verbosity             = Verbosity.Normal
          FileExtension         = ".fs"
          TriggeredByDependency = false
          NoReflection          = true
          JsTemporal            = false }

    interface Fable.Compiler with
        member _.Options      = opts
        member _.LibraryDir   = libDir
        member _.CurrentFile  = "InMemoryTest.fs"
        member _.OutputDir    = None
        member _.OutputType   = OutputType.Exe
        member _.ProjectFile  = ""
        member _.ProjectOptions =
            FSharpChecker.Create().GetProjectOptionsFromScript(
                "InMemoryTest.fs", SourceText.ofString "")
            |> Async.RunSynchronously |> fst
        member _.SourceFiles  = [| "InMemoryTest.fs" |]
        member _.Plugins      = { MemberDeclarationPlugins = Map.empty }
        member _.IsPrecompilingInlineFunction = false
        member this.WillPrecompileInlineFunction(_) = this :> Fable.Compiler
        member _.IncrementCounter() = 0
        member _.GetImplementationFile(_) = fcsDecls
        member _.GetRootModule(_) =
            try   Fable.Transforms.FSharp2Fable.Compiler.getRootModule fcsDecls
            with ex -> failwith $"MockCompiler.GetRootModule: {ex.Message}"
        member _.TryGetEntity(_)  = None
        member _.GetInlineExpr(_) =
            { Args = []; Body = Fable.AST.Fable.Expr.Value(Fable.AST.Fable.ValueKind.Null Fable.AST.Fable.Type.Any, None)
              FileName = ""; GenericArgs = []; ScopeIdents = Set.empty; IsFileLocal = false }
        member _.AddWatchDependency(_) = ()
        member _.AddLog(msg, sev, ?_r, ?_f, ?_t) =
            if sev = Severity.Error then eprintfn "[MockCompiler] %s" msg
        member _.TryGetPluginHelper() = None

// ─────────────────────────────────────────────────────────────────
// Pipeline stages
// ─────────────────────────────────────────────────────────────────

module InMemoryPipelineHelper =

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 1-2: FCS (F# Compiler Service)
    // ──────────────────────────────────────────────────────────────────────────────

    /// Parse and type-check F# source code using FCS
    let private fcsParseAndCheck (code: string)
            : Result<FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list, string> =
        try
            let checker  = FSharpChecker.Create()
            let tempFile = Path.ChangeExtension(Path.GetTempFileName(), ".fs")
            
            try
                File.WriteAllText(tempFile, code)
                let projOpts, _ =
                    checker.GetProjectOptionsFromScript(tempFile, SourceText.ofString code)
                    |> Async.RunSynchronously
                let parseResults, checkResult =
                    checker.ParseAndCheckFileInProject(
                        tempFile, 1, SourceText.ofString code, projOpts)
                    |> Async.RunSynchronously
                match checkResult with
                | FSharpCheckFileAnswer.Succeeded res ->
                    match res.ImplementationFile with
                    | Some impl -> Ok impl.Declarations
                    | None      -> Error "Type-check succeeded but produced no ImplementationFile"
                | FSharpCheckFileAnswer.Aborted ->
                    parseResults.Diagnostics
                    |> Array.map (fun e -> e.Message)
                    |> String.concat "\n"
                    |> fun errs -> Error $"Type-check aborted:\n{errs}"
            finally
                try File.Delete(tempFile) with _ -> ()
        with ex -> Error $"FCS parse+check failed: {ex.Message}"

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 3: FCS → Fable AST
    // ──────────────────────────────────────────────────────────────────────────────

    let private fcsToFableAst
            (fcsDecls: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list)
            : Result<Fable.AST.Fable.File, string> =
        try Ok (Fable.Transforms.FSharp2Fable.Compiler.transformFile (MockCompiler(fcsDecls) :> Fable.Compiler))
        with ex -> Error $"FSharp2Fable failed: {ex.Message}"

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 4: Fable transformations
    // WasmGC-safe Fable transforms
    // ──────────────────────────────────────────────────────────────────────────────


    /// Applies WasmTransformPipeline.transformFileForWasm — no JS-specific rewrites.
    let private transformFableAst
            (file: Fable.AST.Fable.File)
            (fcsDecls: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list)
            : Result<Fable.AST.Fable.File, string> =
        try Ok (WasmXform.transformFileForWasm (MockCompiler(fcsDecls)) file)
        with ex -> Error $"WasmGC transform failed: {ex.Message}"

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 5-7: Fable AST → WasmGC IR (normalized WModule)
    // ──────────────────────────────────────────────────────────────────────────────

    let private fableToWasmIr
            (fcsDecls: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list)
            (file: Fable.AST.Fable.File)
            : Result<WModule * WModule, string> =
        try
            let com      = MockCompiler(fcsDecls) :> Fable.Compiler
            let ctx      = WasmGc.Runtime.Types.Ctx.Create(com)
            let finalCtx = WasmGc.Transforms.Fable2Wasm.processFileIntoCtx ctx com file true
            finalCtx.Diagnostics.Flush()

            // Raw module (Phase 3 only) for snapshot / diff purposes.
            let raw  = WasmGc.Transforms.Fable2Wasm.buildWModule finalCtx
            let opts = { Phases.defaultOptions with Quiet = true }
            match Phases.runPipeline finalCtx file.Declarations opts with
            | Ok opt  -> Ok (raw, opt)
            | Error e ->
                e |> List.map (fun e -> $"[{e.FuncName}] {e.NodeDesc}: {e.Message}")
                  |> String.concat "; " |> fun s -> Error $"Validation: {s}"
        with ex -> Error $"Fable→IR failed: {ex.Message}"


    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 8: WModule → WAT
    // ──────────────────────────────────────────────────────────────────────────────

    let private wmoduleToWat (wmod: WModule) : Result<string, string> =
        try  Ok (WasmGc.Emit.Wat.moduleToWat wmod)
        with ex -> Error $"WAT emit failed: {ex.Message}"


    // ──────────────────────────────────────────────────────────────────────────────
    // ── Stage 9: WAT → WASM binary (optional, requires external tools) ───────────
    // ──────────────────────────────────────────────────────────────────────────────
    let private watToWasm (wat: string) : byte[] option =
        let tmp  = Path.ChangeExtension(Path.GetTempFileName(), ".wat")
        let wasm = Path.ChangeExtension(tmp, ".wasm")
        try
            File.WriteAllText(tmp, wat)
            use proc = Process.Start(
                ProcessStartInfo("wasm-as", $"\"{tmp}\" -o \"{wasm}\"",
                                 RedirectStandardOutput=true, RedirectStandardError=true,
                                 UseShellExecute=false))
            proc.WaitForExit(5_000) |> ignore
            if proc.ExitCode = 0 && File.Exists(wasm) then Some(File.ReadAllBytes wasm) else None
        with _ -> None
        |> fun r -> try File.Delete tmp  with _ -> ()
                    try File.Delete wasm with _ -> ()
                    r

    // ──────────────────────────────────────────────────────────────────────────────
    // ── Orchestrator ──────────────────────────────────────────────────────────────
    // Main entry point: Orchestrate all stages
    // ──────────────────────────────────────────────────────────────────────────────

    /// Compile F# source through the complete in-memory WasmGC pipeline.
    let compileSource (fsharpCode: string) : CompileResult =
        result {
            // Stage 1-2: FCS Parse & Type Check
            let! fcsDecls         = fcsParseAndCheck fsharpCode
            // Stage 3: FCS → Fable AST (raw)
            let! fableRaw         = fcsToFableAst fcsDecls
            // Stage 4: Apply Fable transformations
            let! fableTransformed = transformFableAst fableRaw fcsDecls
            // Stage 5-7: Fable → WasmGC IR (raw + normalized)
            let! (wmodRaw, wmod)  = fableToWasmIr fcsDecls fableTransformed
            // Stage 8: WModule → WAT
            let! watText          = wmoduleToWat wmod
            // Stage 9: WAT → WASM (optional)
            let  wasmBinary        = watToWasm watText

            return {
                FSharpSource        = fsharpCode
                FcsDeclarations     = fcsDecls
                FableAstRaw         = fableRaw
                FableAstTransformed = fableTransformed
                WModuleRaw          = wmodRaw
                WModuleNormalized   = wmod
                WatText             = watText
                WasmBinary          = wasmBinary
            }
        }

    // ── Convenience helpers ───────────────────────────────────────────────────

    /// Helper to compile and assert - returns true if successful, false if skipped
    let compileAndAssertResult (fsharpCode: string) (f: CompilationStages -> unit) : bool =
        match compileSource fsharpCode with
        | Ok stages ->
            f stages
            true
        | Error msg ->
            printfn $"  [compilation error] %s{msg}"
            false

    /// Helper to get just the normalized WModule (most common use case)
    let tryCompileToWModule (code: string) : WModule option =
        match compileSource code with
        | Ok s -> Some s.WModuleNormalized
        | _    -> None

    /// Helper to get WAT text for snapshot testing
    let tryCompileToWat (code: string) : string option =
        match compileSource code with
        | Ok s -> Some s.WatText
        | _    -> None

