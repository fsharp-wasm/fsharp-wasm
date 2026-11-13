/// Full-pipeline test helper — compiles real F# source strings through the
/// complete WasmGC pipeline: FCS → Fable AST → WExpr → WModule.
///
/// STRATEGY: Uses in-memory compilation (InMemoryPipelineHelper) as the primary path.
/// The CLI-based approach is now OBSOLETE (see below) and kept only for E2E testing.
///
/// Why in-memory is better:
///   - 10-100x faster (no process startup/process overhead)
///   - Debuggable (can set breakpoints in compiler phases)
///   - Testable in isolation (each phase can be verified separately)
///   - No file I/O
///
/// [OBSOLETE] CLI-based compilation:
///   The old approach of shelling out to FSharp.Wasm.Cli is preserved below for
///   occasional E2E tests, but new tests should use the in-memory pipeline.
///   To migrate from CLI: replace PipelineHelper.compileToWasm with
///   InMemoryPipelineHelper.compileSource or InMemoryPipelineHelper.tryCompileToWModule.
///
module Tests.PipelineHelper

open System
open System.IO
open System.Diagnostics
// open WasmGc.Core.AST
// open WasmGc.Runtime.Types

// ── [OBSOLETE] Fable CLI runner ──────────────────────────────────────────

[<Obsolete("Use InMemoryPipelineHelper.compileSource instead. CLI shelling is 10-100x slower and less debuggable.")>]
let private fableCli =
    // Prefer a local path (dev scenario); fall back to PATH
    let candidates = [
        Path.Combine(__SOURCE_DIRECTORY__, "../../tools/FSharp.Wasm.Cli/bin/Debug/net10.0/FSharp.Wasm.Cli")
        Path.Combine(__SOURCE_DIRECTORY__, "../../tools/FSharp.Wasm.Cli/bin/Release/net10.0/FSharp.Wasm.Cli")
    ]
    candidates |> List.tryFind File.Exists

[<Obsolete("Use InMemoryPipelineHelper instead.")>]
let private isFableAvailable () = fableCli.IsSome

/// [OBSOLETE] Run the Fable CLI on a temporary .fsproj wrapping `source`.
/// This shells out to a process, which is 10-100x slower than in-memory compilation.
/// For new tests, use InMemoryPipelineHelper instead.
[<Obsolete("Use InMemoryPipelineHelper.compileSource for 10-100x faster tests")>]
let private runFable (source: string) (extraIncludes: string list) : string * string =
    let tmpDir = Path.Combine(Path.GetTempPath(), $"wgc_test_{Guid.NewGuid():N}")
    Directory.CreateDirectory(tmpDir) |> ignore

    // Write the source file
    let srcFile = Path.Combine(tmpDir, "Fixture.fs")
    File.WriteAllText(srcFile,
        """
        module Fixture
        open Fable.Core
        """ + source)


    let sourceDir = Path.GetDirectoryName(__SOURCE_DIRECTORY__) |> Option.ofObj |> Option.defaultValue ""
    
    // Write a minimal .fsproj
    let extraCompiles =
        extraIncludes
        |> List.map (fun p -> $"""    <Compile Include="{p}" />""")
        |> String.concat "\n"
    let fsproj = $"""
<Project Sdk="Microsoft.NET.Sdk">
<PropertyGroup>
<OutputType>Exe</OutputType>
<TargetFramework>net10.0</TargetFramework>
</PropertyGroup>
<ItemGroup>
<Compile Include="{Path.Combine(sourceDir, "../../core/FSharp.Wasm.Core/Interop.fs")}" />
{extraCompiles}
<Compile Include="{srcFile}" />
</ItemGroup>
</Project>"""
    let projFile = Path.Combine(tmpDir, "Fixture.fsproj")
    File.WriteAllText(projFile, fsproj)

    let outDir = Path.Combine(tmpDir, "out")
    Directory.CreateDirectory(outDir) |> ignore

    let cli = fableCli.Value
    let psi = ProcessStartInfo(
        "dotnet", $"run --project \"{cli}\" -- \"{tmpDir}\" --outDir \"{outDir}\" --noCache",
        RedirectStandardOutput = true,
        RedirectStandardError  = true,
        UseShellExecute        = false)

    match Process.Start(psi) with
    | null -> 
        failwith "Failed to start the process."
    | proc ->
        let stdout = proc.StandardOutput.ReadToEnd()
        let stderr = proc.StandardError.ReadToEnd()
        proc.WaitForExit()

        if proc.ExitCode <> 0 then
            failwithf $"Fable compilation failed (exit %d{proc.ExitCode}):\n stdout: %s{stdout}\n stderr: %s{stderr}"

        // Find the output .wasm
        let wasm = Directory.GetFiles(outDir, "*.wasm") |> Array.tryHead
        match wasm with
        | None -> failwithf $"Fable produced no .wasm in %s{outDir}\n stdout: %s{stdout}"
        | Some w -> w, outDir

// ── WAT reader ────────────────────────────────────────────────────────────

/// Read WAT text produced alongside the .wasm.
let watFromDir (outDir: string) : string option =
    Directory.GetFiles(outDir, "*.wat")
    |> Array.tryHead
    |> Option.map File.ReadAllText

// ── High-level API (OBSOLETE — use InMemoryPipelineHelper instead) ──────────

type CompileOutput = {
    WasmPath : string
    WatText  : string option
    OutDir   : string
}

/// [OBSOLETE] Compile a real F# source string through the CLI pipeline.
/// Returns None when Fable CLI is not available (tests skip gracefully).
/// USE InMemoryPipelineHelper.compileSource INSTEAD for 10-100x faster tests.
[<Obsolete("Use InMemoryPipelineHelper.compileSource instead. CLI shelling is 10-100x slower and less debuggable.")>]
let tryCompileSource (source: string) (extraIncludes: string list option) : CompileOutput option =
    if not (isFableAvailable()) then None
    else
        let extras = defaultArg extraIncludes []
        try
            let wasmPath, outDir = runFable source extras
            Some { WasmPath = wasmPath
                   WatText  = watFromDir outDir
                   OutDir   = outDir }
        with ex ->
            failwithf $"PipelineHelper.tryCompileSource failed:\n%s{ex.Message}"

/// [OBSOLETE] Compile and assert — skips cleanly if Fable CLI is unavailable.
/// USE InMemoryPipelineHelper.compileAndAssertResult INSTEAD.
[<Obsolete("Use InMemoryPipelineHelper.compileAndAssertResult instead.")>]
let compileAndAssert (source: string) (f: CompileOutput -> unit) =
    match tryCompileSource source None with
    | None ->
        // Not an error — just skip with a note
        eprintfn "  [skip] Fable CLI not found — run from a dev environment with dotnet tools"
    | Some output ->
        f output

// ── WAT assertions ───────────────────────────────────────────────────────

/// [OBSOLETE] Assert the WAT text contains a substring (case-sensitive).
/// USE InMemoryPipelineHelper.compileSource instead and assert on stages.WatText.
[<Obsolete("Use InMemoryPipelineHelper.compileSource instead.")>]
let assertWatContains (wat: string option) (snippet: string) (msg: string) =
    match wat with
    | None -> failwith "No WAT output produced"
    | Some text ->
        if not (text.Contains snippet) then
            failwithf "%s\nExpected WAT to contain: %s\nActual WAT (first 500 chars):\n%s"
                msg snippet (text |> fun s -> if s.Length > 500 then s[..500] + "..." else s)

/// [OBSOLETE] Assert WAT does not contain a substring.
[<Obsolete("Use InMemoryPipelineHelper.compileSource instead.")>]
let assertWatAbsent (wat: string option) (snippet: string) (msg: string) =
    match wat with
    | None -> failwith "No WAT output produced"
    | Some text ->
        if text.Contains snippet then
            failwithf $"%s{msg}\nExpected WAT NOT to contain: %s{snippet}"


// ── Migration Guide: CLI → In-Memory ──────────────────────────────────────
//
// OLD WAY (CLI-based, OBSOLETE):
//   let code = """let add a b = a + b"""
//   PipelineHelper.compileAndAssert code (fun output ->
//       PipelineHelper.assertWatContains output.WatText "i32.add" "Should have i32.add")
//
// NEW WAY (In-Memory, RECOMMENDED):
//   let code = """module Fixture
//                 open Fable.Core
//                 let add a b = a + b"""
//   match InMemoryPipelineHelper.compileSource code with
//   | Ok stages ->
//       Expect.stringContains stages.WatText "i32.add" "Should have i32.add"
//   | Error err -> skiptest $"Compilation failed: {err}"
//
// Benefits of In-Memory:
//   • 10-100x faster (no subprocess overhead)
//   • Debuggable (set breakpoints in FSharp2Fable, Normalizer, etc.)
//   • Access to all pipeline stages (FcsDeclarations, FableAst, WModule, WAT)
//   • No file I/O, no temp directories
//   • Works in CI/CD without special tooling
//
// For E2E Integration Tests (if needed):
//   Use InMemoryPipelineHelper.compileSource and optionally emit WASM binary
//   via WatToWasm. Only use the CLI-based approach for full end-to-end validation.

