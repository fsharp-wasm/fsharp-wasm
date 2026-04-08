/// fsharp-wasm — WasmGC compiler driver
///
/// Loads Fable.Compiler and Fable.WasmGc in-process, no subprocess needed.
/// Fixes the MSBuild/NuGet contamination issue by controlling the environment.
///
/// Usage:
///   fsharp-wasm <projectDir|.fsproj> [--outDir <dir>] [--noCache] [--verbose] [--silent]
///
/// Language is always WasmGc — no need to pass --lang wasmgc.
///
/// FSHARP_COMPILER env var:
///   If set to an fsc.dll path, DotnetFscCompilerPath is set so the patched
///   compiler is used for MSBuild design-time builds (see Directory.Build.props).
module FSharp.Wasm.Cli

open System
open System.IO
open Microsoft.Extensions.Logging
open Fable
open Fable.Compiler.Util
open Fable.Cli.CustomLogging  // CustomConsole formatter from Fable.Cli

// ── helpers ───────────────────────────────────────────────────────────────────

let private usage () =
    """fsharp-wasm — WasmGC compiler driver

Usage:
  fsharp-wasm <projectDir|.fsproj> [options]

Options:
  --outDir <dir>     Output directory for .wasm / .wat files  (default: <projectDir>/output)
  --noCache          Recompile all files without cache
  --verbose          Print verbose compiler output
  --silent           Suppress all output
  --help             Show this message
"""

let private parseArgs (argv: string list) =
    let rec loop argv outDir noCache verbose silent =
        match argv with
        | [] -> Ok (None, outDir, noCache, verbose, silent)
        | "--help" :: _ | "-h" :: _ -> Error "help"
        | "--outDir" :: dir :: rest -> loop rest (Some dir) noCache verbose silent
        | "--noCache" :: rest -> loop rest outDir true verbose silent
        | "--verbose" :: rest -> loop rest outDir noCache true silent
        | "--silent" :: rest -> loop rest outDir noCache verbose true
        | proj :: rest when not (proj.StartsWith("-")) ->
            // First positional arg is the project
            match loop rest outDir noCache verbose silent with
            | Ok (None, od, nc, v, s) -> Ok (Some proj, od, nc, v, s)
            | Ok (Some _, _, _, _, _) -> Error "Multiple project paths specified"
            | e -> e
        | unknown :: _ -> Error $"Unknown argument: {unknown}"
    loop argv None false false false

// ── entry point ───────────────────────────────────────────────────────────────

[<EntryPoint>]
let main argv =
    let argv = argv |> List.ofArray

    match parseArgs argv with
    | Error "help" ->
        printfn "%s" (usage ())
        0
    | Error msg ->
        eprintfn "Error: %s" msg
        eprintfn "%s" (usage ())
        1
    | Ok (projPathOpt, outDirOpt, noCache, verbose, silent) ->

    // ── set up logger ────────────────────────────────────────────────────────
    let verbosity = if verbose then Verbosity.Verbose elif silent then Verbosity.Silent else Verbosity.Normal
    let logLevel = if verbose then LogLevel.Debug elif silent then LogLevel.None else LogLevel.Information

    let createLogger level =
        use factory =
            LoggerFactory.Create(fun builder ->
                builder
                    .SetMinimumLevel(level)
                    .AddCustomConsole(fun opts -> opts.UseNoPrefixMsgStyle <- true)
                |> ignore
            )
        factory.CreateLogger("")

    Fable.Compiler.Util.Log.setLogger verbosity (createLogger logLevel)

    // ── resolve project file ─────────────────────────────────────────────────
    let rootDir = Environment.CurrentDirectory

    let projPath =
        match projPathOpt with
        | None -> rootDir
        | Some p -> Path.GetFullPath p

    let fsprojPath =
        if Directory.Exists(projPath) then
            let candidates = Directory.GetFiles(projPath, "*.fsproj")
            match candidates with
            | [| single |] -> Ok single
            | [||] ->
                let fsx = Directory.GetFiles(projPath, "*.fsx")
                match fsx with
                | [| single |] -> Ok single
                | _ -> Error $"No .fsproj or .fsx found in: {projPath}"
            | _ -> Error $"Multiple .fsproj files found in: {projPath} — specify one explicitly"
        elif File.Exists(projPath) then
            Ok projPath
        else
            Error $"Path does not exist: {projPath}"

    match fsprojPath with
    | Error msg ->
        eprintfn "Error: %s" msg
        1
    | Ok fsproj ->

    // ── build CliArgs with WasmGc defaults ──────────────────────────────────
    let projDir = Path.GetDirectoryName(fsproj)
    let outDir =
        outDirOpt
        |> Option.map (fun d -> if Path.IsPathRooted(d) then d else Path.GetFullPath(Path.Combine(rootDir, d)))
        |> Option.defaultWith (fun () -> Path.Combine(projDir, "output"))

    let define =
        [ "FABLE_COMPILER"; "FABLE_COMPILER_5"; "FABLE_COMPILER_WASMGC" ]

    let compilerOptions =
        CompilerOptionsHelper.Make(
            language = Language.WasmGc,
            fileExtension = ".wasm",
            define = define,
            debugMode = false,
            optimizeFSharpAst = false,
            verbosity = verbosity
        )

    let cliArgs: CliArgs =
        {
            ProjectFile = Fable.Path.normalizeFullPath fsproj
            RootDir = rootDir
            OutDir = Some outDir
            IsWatch = false
            Precompile = false
            PrecompiledLib = None
            PrintAst = false
            FableLibraryPath = None
            Configuration = "Release"
            NoRestore = false
            NoCache = noCache
            NoParallelTypeCheck = false
            SourceMaps = false
            SourceMapsRoot = None
            Exclude = []
            Replace = Map.empty
            RunProcess = None
            CompilerOptions = compilerOptions
            Verbosity = verbosity
        }

    // ── run Fable compilation via startCompilationAsync ─────────────────────
    // Delegate to Fable.Cli.Main.State.Create + startCompilationAsync.
    // This gives us the full pipeline: MSBuildCracker → TypeCheck → WasmGcPipeline.
    // WasmGc is dispatched by Pipeline.fs which calls WasmGcPipeline.compileFile directly.
    let state = Fable.Cli.Main.State.Create(cliArgs)

    try
        let compilationResult =
            Fable.Cli.Main.startCompilationAsync state
            |> Async.RunSynchronously

        match compilationResult with
        | Ok (_state, logs) ->
            for (log: Fable.Transforms.State.LogEntry) in logs do
                if not silent then
                    Fable.Compiler.Util.Log.log log.Severity log.Message
            0
        | Error (msg, logs) ->
            for (log: Fable.Transforms.State.LogEntry) in logs do
                eprintfn "%s" log.Message
            eprintfn "Compilation failed: %s" msg
            1
    with ex ->
        eprintfn "Fatal: %s" ex.Message
        if verbose then eprintfn "%s" ex.StackTrace
        1
