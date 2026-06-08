/// fsharp-wasm — WasmGC compiler driver
///
/// Thin wrapper: cracks the project, runs Fable type-check + our WasmGC backend.
/// No watch mode, no source maps, no run-process — just compile to .wasm / .wat.
///
/// Usage:  fsharp-wasm [<path/to/project.fsproj>] [--outDir <dir>] [--verbose] [--silent]
module FSharp.Wasm.Cli

open System
open System.IO
open Microsoft.Extensions.Logging
open Fable
open Fable.Compiler.Util
open Fable.Cli.CustomLogging

// ── arg parsing ──────────────────────────────────────────────────────────────

let private usage = """fsharp-wasm — WasmGC compiler driver

Usage:
  fsharp-wasm [<project.fsproj|dir>] [options]

Options:
  --outDir <dir>   Output directory for .wasm/.wat  (default: <projectDir>/output)
  --noCache        Force full recompile
  --verbose        Verbose output
  --silent         Suppress all output
  --help           Show this message
"""

type Args =
    { Project : string option
      OutDir  : string option
      NoCache : bool
      Verbose : bool
      Silent  : bool }

let private parseArgs argv =
    let rec loop acc = function
        | [] -> Ok acc
        | ("--help"|"-h") :: _ -> Error "help"
        | "--outDir" :: d :: rest -> loop { acc with OutDir  = Some d }   rest
        | "--noCache"    :: rest  -> loop { acc with NoCache = true }      rest
        | "--verbose"    :: rest  -> loop { acc with Verbose = true }      rest
        | "--silent"     :: rest  -> loop { acc with Silent  = true }      rest
        | p :: rest when not (p.StartsWith("-")) ->
            match acc.Project with
            | Some _ -> Error "Multiple project paths"
            | None   -> loop { acc with Project = Some p } rest
        | u :: _ -> Error $"Unknown argument: {u}"
    loop { Project=None; OutDir=None; NoCache=false; Verbose=false; Silent=false } (List.ofArray argv)

let private resolveFsproj (projArg: string option) =
    let root = Environment.CurrentDirectory
    let path = projArg |> Option.map Path.GetFullPath |> Option.defaultValue root
    if   File.Exists path      then Ok path
    elif Directory.Exists path then
        match Directory.GetFiles(path, "*.fsproj") with
        | [| f |] -> Ok f
        | [||]    -> Error $"No .fsproj found in: {path}"
        | _       -> Error $"Multiple .fsproj files in: {path} — specify one"
    else Error $"Path does not exist: {path}"

// ── entry point ──────────────────────────────────────────────────────────────

[<EntryPoint>]
let main argv =
    match parseArgs argv with
    | Error "help" -> printfn "%s" usage; 0
    | Error msg    -> eprintfn "Error: %s\n%s" msg usage; 1
    | Ok args      ->

    match resolveFsproj args.Project with
    | Error msg -> eprintfn "Error: %s" msg; 1
    | Ok fsproj ->

    let verbosity  = if args.Verbose then Verbosity.Verbose elif args.Silent then Verbosity.Silent else Verbosity.Normal
    let logLevel   = if args.Verbose then LogLevel.Debug  elif args.Silent  then LogLevel.None    else LogLevel.Information

    use factory =
        LoggerFactory.Create(fun b ->
            b.SetMinimumLevel(logLevel)
             .AddCustomConsole(fun o -> o.UseNoPrefixMsgStyle <- true) |> ignore)
    Fable.Compiler.Util.Log.setLogger verbosity (factory.CreateLogger "")

    let projDir = Path.GetDirectoryName fsproj
    let outDir  =
        args.OutDir
        |> Option.map (fun d -> if Path.IsPathRooted d then d else Path.GetFullPath d)
        |> Option.defaultWith (fun () -> Path.Combine(projDir, "output"))

    let cliArgs : CliArgs =
        { ProjectFile  = Fable.Path.normalizeFullPath fsproj
          RootDir      = Environment.CurrentDirectory
          OutDir       = Some outDir
          IsWatch      = false
          Precompile   = false
          PrecompiledLib  = None
          PrintAst     = false
          FableLibraryPath = None
          Configuration = "Release"
          NoRestore    = false
          NoCache      = args.NoCache
          NoParallelTypeCheck = false
          SourceMaps   = false
          SourceMapsRoot = None
          Exclude      = []
          Replace      = Map.empty
          RunProcess   = None
          Verbosity    = verbosity
          CompilerOptions =
              CompilerOptionsHelper.Make(
                  language    = Language.WasmGc,
                  fileExtension = ".wasm",
                  define      = [ "FABLE_COMPILER"; "FABLE_COMPILER_5"; "FABLE_COMPILER_WASMGC" ],
                  debugMode   = false,
                  optimizeFSharpAst = false,
                  verbosity   = verbosity) }

    let state = Fable.Cli.Main.State.Create(cliArgs)

    try
        match Fable.Cli.Main.startCompilationAsync state |> Async.RunSynchronously with
        | Ok (_, logs) ->
            for l in logs do
                if not args.Silent then Log.log l.Severity l.Message
            0
        | Error (msg, logs) ->
            for l in logs do eprintfn "%s" l.Message
            eprintfn "Compilation failed: %s" msg
            1
    with ex ->
        eprintfn "Fatal: %s" ex.Message
        if args.Verbose then eprintfn "%s" ex.StackTrace
        1

