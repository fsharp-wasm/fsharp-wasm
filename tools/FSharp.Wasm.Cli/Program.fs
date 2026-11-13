/// fsharp-wasm — WasmGC compiler driver
///
/// Thin wrapper: cracks the project, runs Fable type-check + our WasmGC backend.
/// No watch mode, no source maps, no run-process — just compile to .wasm / .wat.
/// Sets the library path to FSharp.Wasm.Core (repository fsharp-wasm-core) — NOT vendor Fable.Core.
///
/// Usage:  fsharp-wasm [<path/to/project.fsproj>] [--outDir <dir>] [--verbose] [--silent]
module FSharp.Wasm.Cli

open System
open System.IO
open Microsoft.Extensions.Logging
open Fable
open Fable.Compiler.Util
open Fable.Cli.CustomLogging

let private usage = """fsharp-wasm — WasmGC compiler

Usage:
  fsharp-wasm [<project.fsproj|dir>] [options]

Options:
  --outDir <dir>   Output directory for .wasm/.wat  (default: <projectDir>/output)
  --noCache        Force full recompile
  --verbose        Verbose output
  --silent         Suppress all output
  --help           Show this message
"""

type private Args =
    { Project : string option
      OutDir  : string option
      NoCache : bool
      Verbose : bool
      Silent  : bool }

let private parseArgs argv =
    let rec loop (acc: Args) = function
        | []                              -> Ok acc
        | ("--help" | "-h") :: _          -> Error "help"
        | "--outDir"  :: d :: rest         -> loop { acc with OutDir  = Some d } rest
        | "--noCache"       :: rest        -> loop { acc with NoCache = true }   rest
        | "--verbose"       :: rest        -> loop { acc with Verbose = true }   rest
        | "--silent"        :: rest        -> loop { acc with Silent  = true }   rest
        | p :: rest when not (p.StartsWith("-")) ->
            match acc.Project with
            | Some _ -> Error "Multiple project paths"
            | None   -> loop { acc with Project = Some p } rest
        | u :: _ -> Error $"Unknown argument: {u}"
    loop { Project=None; OutDir=None; NoCache=false; Verbose=false; Silent=false } (List.ofArray argv)

let private resolveFsproj projArg =
    let path = projArg |> Option.map Path.GetFullPath |> Option.defaultValue Environment.CurrentDirectory
    if   File.Exists path      then Ok path
    elif Directory.Exists path then
        match Directory.GetFiles(path, "*.fsproj") with
        | [| f |] -> Ok f
        | [||]    -> Error $"No .fsproj in: {path}"
        | _       -> Error $"Multiple .fsproj in: {path} — specify one"
    else Error $"Path not found: {path}"

/// Locate the core library, the directory `FSharp.Wasm.Core`: `FSHARP_WASM_CORE_DIR` (a checkout of fsharp-wasm-core),
/// else `core/FSharp.Wasm.Core` or `fsharp-wasm-core/FSharp.Wasm.Core` found upwards from the project directory (a project
/// inside this repository, or next to a checkout), else upwards from the CLI itself (a project anywhere else — a runtime
/// library, an app of its own — with the library shipped beside the binary).  `FSHARP_WASM_LIBRARY` (the library directory
/// itself) is the older name of the setting and still read.
let private findCoreLibrary (projDir: string) =
    let candidates = [ Path.Combine("core", "FSharp.Wasm.Core"); Path.Combine("fsharp-wasm-core", "FSharp.Wasm.Core") ]
    let rec tryUp dir depth =
        if depth > 8 || String.IsNullOrEmpty dir then None
        else
            match candidates |> List.map (fun c -> Path.Combine(dir, c)) |> List.tryFind Directory.Exists with
            | Some found -> Some found
            | None -> tryUp (Path.GetDirectoryName dir) (depth + 1)
    let fromEnv name = match Environment.GetEnvironmentVariable name with null | "" -> None | v -> Some v
    fromEnv "FSHARP_WASM_CORE_DIR" |> Option.map (fun d -> Path.Combine(d, "FSharp.Wasm.Core"))
    |> Option.orElse (fromEnv "FSHARP_WASM_LIBRARY")
    |> Option.orElse (tryUp projDir 0)
    |> Option.orElse (tryUp (AppContext.BaseDirectory.TrimEnd Path.DirectorySeparatorChar) 0)

[<EntryPoint>]
let main argv =
    match parseArgs argv with
    | Error "help" -> printfn "%s" usage; 0
    | Error msg    -> eprintfn "Error: %s\n%s" msg usage; 1
    | Ok args      ->

    match resolveFsproj args.Project with
    | Error msg -> eprintfn "Error: %s" msg; 1
    | Ok fsproj ->

    let verbosity = if args.Verbose then Verbosity.Verbose elif args.Silent then Verbosity.Silent else Verbosity.Normal
    let logLevel  = if args.Verbose then LogLevel.Debug  elif args.Silent  then LogLevel.None    else LogLevel.Information

    use factory =
        LoggerFactory.Create(fun b ->
            b.SetMinimumLevel(logLevel)
             .AddCustomConsole(fun o -> o.UseNoPrefixMsgStyle <- true) |> ignore)
    Log.setLogger verbosity (factory.CreateLogger "")

    let projDir   = Path.GetDirectoryName fsproj
    let outDir    = args.OutDir |> Option.map Path.GetFullPath
                    |> Option.defaultWith (fun () -> Path.Combine(projDir, "output"))

    // Use our own core library, NOT vendor Fable.Core
    let coreLib   = findCoreLibrary projDir

    if coreLib.IsNone && not args.Silent then
        eprintfn "Warning: FSharp.Wasm.Core not found (set FSHARP_WASM_CORE_DIR, or init the `core` submodule) — LibraryDir will default to '.'"

    let cliArgs : CliArgs =
        { ProjectFile        = Fable.Path.normalizeFullPath fsproj
          RootDir            = Environment.CurrentDirectory
          OutDir             = Some outDir
          IsWatch            = false
          Precompile         = false
          PrecompiledLib     = None
          PrintAst           = false
          FableLibraryPath   = coreLib    // ← our library, not Fable.Core
          Configuration      = "Release"
          NoRestore          = false
          NoCache            = args.NoCache
          NoGitignore        = false
          NoParallelTypeCheck = false
          SourceMaps         = false
          SourceMapsRoot     = None
          Exclude            = []
          Replace            = Map.empty
          RunProcess         = None
          Verbosity          = verbosity
          CompilerOptions    =
              CompilerOptionsHelper.Make(
                  language         = Language.WasmGc,
                  fileExtension    = ".wasm",
                  define           = [ "FABLE_COMPILER"; "FABLE_COMPILER_5"; "FABLE_COMPILER_WASMGC" ],
                  debugMode        = false,
                  optimizeFSharpAst = false,
                  verbosity        = verbosity) }

    try
        match Fable.Cli.Main.State.Create(cliArgs)
              |> Fable.Cli.Main.startCompilationAsync
              |> Async.RunSynchronously with
        | Ok (_, logs) ->
            if not args.Silent then
                for l in logs do Log.log l.Severity l.Message
            0
        | Error (msg, logs) ->
            for l in logs do eprintfn "%s" l.Message
            eprintfn "Compilation failed: %s" msg
            1
    with ex ->
        eprintfn "Fatal: %s" ex.Message
        if args.Verbose then eprintfn "%s" ex.StackTrace
        1


