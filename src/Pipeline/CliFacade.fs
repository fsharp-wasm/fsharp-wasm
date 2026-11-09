/// CLI Facade — programmatic / single-file entry point for the WasmGC pipeline.
/// WasmGC programmatic pipeline — Phases 2-5.
///
/// This module owns Phases 2-5.  Phase 1 (FSharp2Fable) is the caller's
/// responsibility since it requires a full Fable.Compiler / FCS setup.
///
/// All pipeline phases after Phase 1 consume only ICompilerCore — the
/// platform-agnostic interface now defined in Fable.AST/Plugins.fs.
/// No Fable.Compiler (FCS-heavy) is carried beyond the entry point.
/// The caller owns Phase 1 (FSharp2Fable.Compiler.transformFile, needs Compiler/FCS).
/// Everything from Phase 2 onward operates on ICompilerCore — no FCS after entry.
namespace WasmGc.Pipeline

open System
open System.IO
open System.Diagnostics
open Fable                            // ICompilerCore, Severity live here now
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST

module WasmXform = WasmGc.Transforms.FableAstGate
module Phases    = WasmGc.Pipeline.Phases

// ──────────────────────────────────────────────────────────────────────────────
// Minimal result CE
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

// ──────────────────────────────────────────────────────────────────────────────
// Output record
// ──────────────────────────────────────────────────────────────────────────────

/// Represents all outputs of the WasmGC compilation pipeline
type CompilationOutput =
    {
        /// Fable AST after WasmGC-safe transforms (no JS corruption).
        /// The transformed Fable AST ready for WasmGC backend
        FableAstTransformed : Fable.AST.Fable.File

        /// Raw WasmGC IR (Phase 3 output, before normalization).
        WModuleRaw          : WModule option

        /// Normalized + optimized WasmGC IR.
        /// The normalized WasmGC IR module (ready for code generation)
        WModuleNormalized   : WModule option

        /// WAT text representation (human-readable WebAssembly)
        WatText             : string option

        /// WASM binary (requires wasm-tools in PATH or falls back to built-in encoder).
        WasmBinary          : byte[] option
    }

// ──────────────────────────────────────────────────────────────────────────────
// Pipeline stages — all take ICompilerCore, not Fable.Compiler
// ──────────────────────────────────────────────────────────────────────────────

/// The clean compilation pipeline for WasmGC (ready for production)
module WasmGcCompilationPipeline =

    let private toWasmIr (com: ICompilerCore) (file: File) =
        try
            // Ctx.Create now accepts ICompilerCore
            let ctx      = WasmGc.Runtime.Types.Ctx.Create(com)
            // processFileIntoCtx now accepts ICompilerCore
            let finalCtx = WasmGc.Transforms.Fable2Wasm.processFileIntoCtx ctx com file true
            finalCtx.Diagnostics.FailOnErrors("Fable → WExpr")
            let raw  = WasmGc.Transforms.Fable2Wasm.buildWModule finalCtx
            let opts = { Phases.defaultOptions with Quiet = true }
            match Phases.runPipeline finalCtx file.Declarations opts with
            | Ok opt  -> Ok (raw, opt)
            | Error e ->
                e |> List.map (fun e -> $"[{e.FuncName}] {e.NodeDesc}: {e.Message}")
                  |> String.concat "; " |> fun s -> Error $"Validation: {s}"
        with ex -> Error $"Fable→IR: {ex.Message}"

    let private toWat (wmod: WModule) =
        try  Ok (WasmGc.Emit.Wat.moduleToWat wmod)
        with ex -> Error $"WAT emit: {ex.Message}"

    let private toBinary (wat: string) =
        let tmp  = Path.ChangeExtension(Path.GetTempFileName(), ".wat")
        let wasm = Path.ChangeExtension(tmp, ".wasm")
        try
            File.WriteAllText(tmp, wat)
            use p = Process.Start(ProcessStartInfo("wasm-tools", $"parse \"{tmp}\" -o \"{wasm}\"",
                                                   UseShellExecute=false, RedirectStandardError=true))
            p.WaitForExit(10_000) |> ignore
            if p.ExitCode = 0 && File.Exists(wasm) then Some(File.ReadAllBytes wasm) else None
        with _ -> None
        |> fun r -> try File.Delete tmp  with _ -> ()
                    try File.Delete wasm with _ -> ()
                    r

    /// Compile a Fable.File through the WasmGC backend (Phases 2-5).
    /// Accepts ICompilerCore — Fable.Compiler upcasts implicitly.
    let compileFile (com: ICompilerCore) (file: File) : Result<CompilationOutput, string> =
        result {
            let! xformed = try Ok (WasmXform.transformFileForWasm com file) with ex -> Error ex.Message
            let  rawOpt, normOpt, watOpt =
                match toWasmIr com xformed with
                | Ok (raw, norm) -> Some raw, Some norm, toWat norm |> Result.toOption
                | Error _        -> None, None, None
            return { FableAstTransformed = xformed
                     WModuleRaw          = rawOpt
                     WModuleNormalized   = normOpt
                     WatText             = watOpt
                     WasmBinary          = watOpt |> Option.bind toBinary }
        }

// ──────────────────────────────────────────────────────────────────────────────
// Public surface - integration helpers
// ──────────────────────────────────────────────────────────────────────────────

module CliIntegration =
    let compile (com: ICompilerCore) (file: File) =
        WasmGcCompilationPipeline.compileFile com file
