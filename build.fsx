#!/usr/bin/env -S dotnet fsi
/// build.fsx — FAKE 6 build script for fsharp-wasm
///
/// Usage:
///   dotnet fake run build.fsx                      # default (Build + QuickTest + Showcase)
///   dotnet fake run build.fsx --target Pack        # build + pack NuGet
///   dotnet fake run build.fsx --target Release     # full release (requires VERSION env var)
///   dotnet fake run build.fsx --target All         # everything
///
/// Environment variables:
///   VERSION            — semver string for NuGet pack / release (default: "0.0.0-local")
///   NUGET_API_KEY      — NuGet.org push API key (for Release target)
///   FSHARP_COMPILER    — path to patched fsc.dll (set by .envrc automatically)

// fake-cli 6.1.3 runs on FSharp.Core 8.0.x; without this Paket resolves FSharp.Core 11 and the script
// fails to load ("Could not load file or assembly 'Fake.Core.Environment'").
#r "nuget: FSharp.Core,               8.0.400"
#r "nuget: Fake.Core.Target,         6.1.3"
#r "nuget: Fake.Core.Process,        6.1.3"
#r "nuget: Fake.Core.ReleaseNotes,   6.1.3"
#r "nuget: Fake.DotNet.Cli,          6.1.3"
#r "nuget: Fake.IO.FileSystem,       6.1.3"
#r "nuget: Fake.Tools.Git,           6.1.3"

open Fake.Core
open Fake.DotNet
open Fake.IO
open Fake.IO.Globbing.Operators
open Fake.Tools.Git
open System
open System.IO

// ── Bootstrap FAKE context (required when running as .fsx) ─────────────────
Context.forceFakeContext()

// ── Paths ───────────────────────────────────────────────────────────────────
let root          = __SOURCE_DIRECTORY__
let srcDir        = Path.combine root "src"
let testsDir      = Path.combine root "tests"
let publishDir    = Path.combine root "publish"
let cliDir        = Path.combine root "tools/FSharp.Wasm.Cli"
let coreDir       = Path.combine root "fsharp-wasm-core/FSharp.Wasm.Core"
let vendorFableFsc = Path.combine root "vendor/fsharp/artifacts/bin/fsc/Release/net10.0/fsc.dll"

// ── Version ─────────────────────────────────────────────────────────────────
let version =
    match Environment.environVarOrNone "VERSION" with
    | Some v -> v.TrimStart('v')
    | None   ->
        // Try to read from CHANGELOG.md first line "## [x.y.z]"
        let changelog = Path.combine root "CHANGELOG.md"
        if File.exists changelog then
            File.ReadAllLines(changelog)
            |> Array.tryPick (fun l ->
                if l.StartsWith("## [") then
                    let s = l.TrimStart("## [".ToCharArray())
                    let e = s.IndexOf(']')
                    if e > 0 then Some (s.[..e-1]) else None
                else None)
            |> Option.defaultValue "0.0.0-local"
        else "0.0.0-local"

Trace.log $"Build version: {version}"

// ── Helper: dotnet CLI options ───────────────────────────────────────────────
let dotnetOpts (o: DotNet.Options) =
    let e = o.Environment
    let e2 =
        match Environment.environVarOrNone "FSHARP_COMPILER" with
        | Some p -> Map.add "FSHARP_COMPILER" p e
        | None when File.exists vendorFableFsc ->
            Map.add "FSHARP_COMPILER" vendorFableFsc e
        | None -> e
    { o with Environment = e2 }

let inline runDotNet cmd workDir =
    let result = DotNet.exec (fun o -> dotnetOpts o |> fun o -> { o with WorkingDirectory = workDir }) cmd ""
    if result.ExitCode <> 0 then failwithf "dotnet %s failed in %s (exit %d)" cmd workDir result.ExitCode

/// Run `bash <script>` in <dir> and fail the current target on a non-zero exit code.
let runBashScript (dir: string) (script: string) =
    let result =
        CreateProcess.fromRawCommand "bash" [ script ]
        |> CreateProcess.withWorkingDirectory dir
        |> CreateProcess.withTimeout (TimeSpan.FromMinutes 10.0)
        |> Proc.run
    if result.ExitCode <> 0 then failwithf "%s failed in %s (exit %d)" script dir result.ExitCode

// ── Target: Clean ───────────────────────────────────────────────────────────
Target.create "Clean" (fun _ ->
    Shell.cleanDir publishDir
    !! "src/bin" ++ "src/obj"
    ++ "tools/FSharp.Wasm.Cli/bin" ++ "tools/FSharp.Wasm.Cli/obj"
    ++ "fsharp-wasm-core/FSharp.Wasm.Core/bin" ++ "fsharp-wasm-core/FSharp.Wasm.Core/obj"
    |> Shell.cleanDirs
)

// ── Target: Build compiler ──────────────────────────────────────────────────
Target.create "Build" (fun _ ->
    DotNet.build (fun o ->
        { o with
            Configuration = DotNet.BuildConfiguration.Release
            Common = dotnetOpts o.Common }
    ) (Path.combine srcDir "WasmGc.fsproj")
    Trace.log "✅ WasmGc build complete"
)

// ── Target: Build CLI ────────────────────────────────────────────────────────
Target.create "BuildCli" (fun _ ->
    DotNet.build (fun o ->
        { o with
            Configuration = DotNet.BuildConfiguration.Release
            Common = dotnetOpts o.Common }
    ) (Path.combine cliDir "FSharp.Wasm.Cli.fsproj")
    Trace.log "✅ fsharp-wasm CLI build complete"
)

// ── Target: Build Core ───────────────────────────────────────────────────────
Target.create "BuildCore" (fun _ ->
    DotNet.build (fun o ->
        { o with
            Configuration = DotNet.BuildConfiguration.Release
            Common = dotnetOpts o.Common }
    ) (Path.combine coreDir "FSharp.WasmCore.fsproj")
    Trace.log "✅ FSharp.Wasm.Core build complete"
)

// ── Target: Tests ────────────────────────────────────────────────────────────
Target.create "QuickTest" (fun _ ->
    runBashScript (Path.combine testsDir "QuickTest") "run.sh"
    Trace.log "✅ QuickTest passed"
)

Target.create "Showcase" (fun _ ->
    runBashScript (Path.combine testsDir "Showcase") "run.sh"
    Trace.log "✅ Showcase passed"
)

// Run Expecto unit tests for fsharp-wasm-core (once they exist)
Target.create "UnitTests" (fun _ ->
    let testProj = Path.combine testsDir "Unit/WatTests/WatTests.fsproj"
    if File.exists testProj then
        DotNet.test (fun o ->
            { o with
                Configuration = DotNet.BuildConfiguration.Release
                Common = dotnetOpts o.Common }
        ) testProj
        Trace.log "✅ UnitTests passed"
    else
        Trace.log "⚠️  UnitTests project not yet created — skipping"
)

// ── Target: Pack NuGet ────────────────────────────────────────────────────────
Target.create "Pack" (fun _ ->
    Shell.mkdir publishDir

    // Pack main compiler backend
    DotNet.pack (fun o ->
        { o with
            Configuration  = DotNet.BuildConfiguration.Release
            OutputPath     = Some (Path.combine publishDir "nuget")
            Common         = dotnetOpts o.Common
            MSBuildParams  = { o.MSBuildParams with Properties = [ "Version", version ] } }
    ) (Path.combine srcDir "WasmGc.fsproj")

    // Pack CLI tool
    DotNet.pack (fun o ->
        { o with
            Configuration  = DotNet.BuildConfiguration.Release
            OutputPath     = Some (Path.combine publishDir "nuget")
            Common         = dotnetOpts o.Common
            MSBuildParams  = { o.MSBuildParams with Properties = [ "Version", version ] } }
    ) (Path.combine cliDir "FSharp.Wasm.Cli.fsproj")

    // Pack Core BCL
    DotNet.pack (fun o ->
        { o with
            Configuration  = DotNet.BuildConfiguration.Release
            OutputPath     = Some (Path.combine publishDir "nuget")
            Common         = dotnetOpts o.Common
            MSBuildParams  = { o.MSBuildParams with Properties = [ "Version", version ] } }
    ) (Path.combine coreDir "FSharp.WasmCore.fsproj")

    Trace.log $"✅ NuGet packages packed to {publishDir}/nuget"
)

// ── Target: Publish NuGet ─────────────────────────────────────────────────────
Target.create "PublishNuGet" (fun _ ->
    let apiKey =
        Environment.environVarOrNone "NUGET_API_KEY"
        |> Option.defaultWith (fun () -> failwith "NUGET_API_KEY not set")
    !! (Path.combine publishDir "nuget/*.nupkg")
    |> Seq.iter (fun pkg ->
        DotNet.exec id $"nuget push {pkg} --source https://api.nuget.org/v3/index.json --api-key {apiKey} --skip-duplicate" ""
        |> ignore
    )
    Trace.log "✅ NuGet packages published"
)

// ── Target: Publish self-contained CLI binaries ───────────────────────────────
Target.create "PublishBinaries" (fun _ ->
    let rids = [ "linux-x64"; "win-x64"; "osx-x64"; "osx-arm64" ]
    for rid in rids do
        let outDir = Path.combine publishDir rid
        DotNet.publish (fun o ->
            { o with
                Configuration = DotNet.BuildConfiguration.Release
                Runtime       = Some rid
                SelfContained = Some true
                OutputPath    = Some outDir
                Common        = dotnetOpts o.Common
                MSBuildParams = { o.MSBuildParams with Properties = [ "Version", version; "PublishReadyToRun", "false" ] } }
        ) (Path.combine cliDir "FSharp.Wasm.Cli.fsproj")
    Trace.log "✅ Self-contained CLI binaries published"
)

// ── Target: Release ───────────────────────────────────────────────────────────
// Full release = Build + Test + Pack + PublishNuGet + PublishBinaries
Target.create "Release" ignore

// ── Target: All (CI gate) ─────────────────────────────────────────────────────
Target.create "All" ignore

// ── Default target ─────────────────────────────────────────────────────────────
Target.create "Default" ignore

// ── Dependency graph ──────────────────────────────────────────────────────────
open Fake.Core.TargetOperators

"Clean"
    ==> "Build"
    ==> "BuildCli"
    ==> "BuildCore"
    ==> "Default"

"Default"
    ==> "QuickTest"
    ==> "Showcase"
    ==> "UnitTests"
    ==> "Pack"
    ==> "All"

"All"
    ==> "PublishNuGet"
    ==> "PublishBinaries"
    ==> "Release"

Target.runOrDefaultWithArguments "Default"
