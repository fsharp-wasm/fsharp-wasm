/// Full-pipeline test helper — compiles real F# source strings through the
/// complete WasmGC pipeline: FCS → Fable AST → WExpr → WModule.
///
/// This is the replacement for hand-crafted Fable AST in tests.
/// The Fable compilation step requires the Fable CLI to be accessible;
/// tests gracefully skip if the runner binary is not on PATH.
namespace Tests

open System
open System.IO
open System.Diagnostics
open WasmGc.Core.AST
open WasmGc.Runtime.Types

module PipelineHelper =

    // ── Fable CLI runner ──────────────────────────────────────────────────────

    let private fableCli =
        // Prefer a local path (dev scenario); fall back to PATH
        let candidates = [
            Path.Combine(__SOURCE_DIRECTORY__, "../../tools/FSharp.Wasm.Cli/bin/Debug/net10.0/FSharp.Wasm.Cli")
            Path.Combine(__SOURCE_DIRECTORY__, "../../tools/FSharp.Wasm.Cli/bin/Release/net10.0/FSharp.Wasm.Cli")
        ]
        candidates |> List.tryFind File.Exists

    let private isFableAvailable () = fableCli.IsSome

    /// Run the Fable CLI on a temporary .fsproj wrapping `source`,
    /// return the path to the output .wasm (or throw on failure).
    let private runFable (source: string) (extraIncludes: string list) : string * string =
        let tmpDir = Path.Combine(Path.GetTempPath(), $"wgc_test_{Guid.NewGuid():N}")
        Directory.CreateDirectory(tmpDir) |> ignore

        // Write the source file
        let srcFile = Path.Combine(tmpDir, "Fixture.fs")
        File.WriteAllText(srcFile,
            "module Fixture\nopen Fable.Core\n" + source)

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
    <Compile Include="{Path.Combine(Path.GetDirectoryName(__SOURCE_DIRECTORY__), "../../fable-library-wasmgc/Core/Interop.fs")}" />
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

        use proc = Process.Start(psi)
        let stdout = proc.StandardOutput.ReadToEnd()
        let stderr = proc.StandardError.ReadToEnd()
        proc.WaitForExit()

        if proc.ExitCode <> 0 then
            failwithf "Fable compilation failed (exit %d):\nstdout: %s\nstderr: %s"
                proc.ExitCode stdout stderr

        // Find the output .wasm
        let wasm = Directory.GetFiles(outDir, "*.wasm") |> Array.tryHead
        match wasm with
        | None -> failwithf "Fable produced no .wasm in %s\nstdout: %s" outDir stdout
        | Some w -> w, outDir

    // ── WAT reader ────────────────────────────────────────────────────────────

    /// Read WAT text produced alongside the .wasm.
    let watFromDir (outDir: string) : string option =
        Directory.GetFiles(outDir, "*.wat")
        |> Array.tryHead
        |> Option.map File.ReadAllText

    // ── High-level API ────────────────────────────────────────────────────────

    type CompileOutput = {
        WasmPath : string
        WatText  : string option
        OutDir   : string
    }

    /// Compile a real F# source string through the full pipeline.
    /// Returns None when Fable CLI is not available (tests skip gracefully).
    let tryCompileSource (source: string) (?extraIncludes: string list) : CompileOutput option =
        if not (isFableAvailable()) then None
        else
            let extras = defaultArg extraIncludes []
            try
                let wasmPath, outDir = runFable source extras
                Some { WasmPath = wasmPath
                       WatText  = watFromDir outDir
                       OutDir   = outDir }
            with ex ->
                failwithf "PipelineHelper.tryCompileSource failed:\n%s" ex.Message

    /// Compile and assert — skips cleanly if Fable CLI is unavailable.
    /// `f` receives the WAT text to make assertions.
    let compileAndAssert (source: string) (f: CompileOutput -> unit) =
        match tryCompileSource source with
        | None ->
            // Not an error — just skip with a note
            eprintfn "  [skip] Fable CLI not found — run from a dev environment with dotnet tools"
        | Some output ->
            f output

    // ── WAT assertions ───────────────────────────────────────────────────────

    /// Assert the WAT text contains a substring (case-sensitive).
    let assertWatContains (wat: string option) (snippet: string) (msg: string) =
        match wat with
        | None -> failwith "No WAT output produced"
        | Some text ->
            if not (text.Contains snippet) then
                failwithf "%s\nExpected WAT to contain: %s\nActual WAT (first 500 chars):\n%s"
                    msg snippet (text |> fun s -> if s.Length > 500 then s.[..500] + "..." else s)

    let assertWatAbsent (wat: string option) (snippet: string) (msg: string) =
        match wat with
        | None -> failwith "No WAT output produced"
        | Some text ->
            if text.Contains snippet then
                failwithf "%s\nExpected WAT NOT to contain: %s" msg snippet
