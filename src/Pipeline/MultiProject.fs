/// Multi-project WasmGC compilation orchestration.
///
/// Coordinates compilation of multiple .fsproj files that reference each other,
/// producing either:
///   A) A statically-linked single .wasm (Strategy A — available today)
///   B) Per-module .wasm files with .wgi interface files (Strategy B — future)
///
/// Replaces the ad-hoc `sharedCtxs` dict in `Pipeline.fs` with an explicit
/// dependency graph and topological sort.
module WasmGc.Pipeline.MultiProject

open System
open System.IO
open System.Collections.Generic
open WasmGc.Core.AST
open WasmGc.Emit.ModuleInterface
open WasmGc.Emit.Linker

module E = WasmGc.Emit.Emit
module Enc = WasmGc.Emit.Encoder
module Wat = WasmGc.Emit.Wat

// ─────────────────────────────────────────────────────────────────────────────
// Dependency graph
// ─────────────────────────────────────────────────────────────────────────────

/// A compiled module unit — one .fsproj produces one WasmUnit.
type WasmUnit = {
    ProjectPath : string
    ModuleName  : string
    /// Compiled WModule (None if not yet compiled or loaded from cache).
    WModule     : WModule option
    /// Serialised interface (loaded from .wgi cache or extracted after compilation).
    Interface   : ModuleInterface option
    /// Names of modules this unit depends on (ProjectReference chain).
    Dependencies: string list
}

type ProjectGraph = {
    Units   : Map<string, WasmUnit>
    /// Topological order (dependencies before dependents).
    Order   : string list
}

// ─────────────────────────────────────────────────────────────────────────────
// Topological sort (Kahn's algorithm)
// ─────────────────────────────────────────────────────────────────────────────

/// Kahn's algorithm — returns topological order or raises on cycle.
let private topoSort (deps: Map<string, string list>) : string list =
    let indegree = Dictionary<string, int>()
    for name in deps.Keys do indegree.[name] <- 0
    for name, ds in Map.toSeq deps do
        for d in ds do
            if indegree.ContainsKey(d) then
                indegree.[name] <- indegree.[name] + 1

    let queue = Queue<string>()
    for kvp in indegree do
        if kvp.Value = 0 then queue.Enqueue(kvp.Key)

    let result = ResizeArray<string>()
    while queue.Count > 0 do
        let n = queue.Dequeue()
        result.Add(n)
        for dep in (Map.tryFind n deps |> Option.defaultValue []) do
            indegree.[dep] <- indegree.[dep] - 1
            if indegree.[dep] = 0 then queue.Enqueue(dep)

    if result.Count <> deps.Count then
        failwith "MultiProject: circular dependency detected in project graph"
    result |> Seq.toList

// ─────────────────────────────────────────────────────────────────────────────
// Build options
// ─────────────────────────────────────────────────────────────────────────────

type BuildMode =
    /// Merge all modules into a single .wasm at link time (Strategy A — default).
    | StaticLink
    /// Emit per-module .wasm + .wgi files; host links at instantiation (Strategy B).
    | SeparateModules

type BuildOptions = {
    Mode            : BuildMode
    OutputDir       : string
    /// Cache directory for .wgi files (used for incremental builds).
    CacheDir        : string option
    /// Treat linker warnings as errors.
    WarningsAsErrors: bool
}

module BuildOptions =
    let defaults outDir = {
        Mode             = StaticLink
        OutputDir        = outDir
        CacheDir         = Some(Path.Combine(outDir, ".wgc"))
        WarningsAsErrors = false
    }

// ─────────────────────────────────────────────────────────────────────────────
// Multi-project build result
// ─────────────────────────────────────────────────────────────────────────────

type BuildResult = {
    OutputFiles : (string * byte[]) list  // (path, bytes)
    WatFiles    : (string * string) list  // (path, text)
    Interfaces  : (string * ModuleInterface) list
    Diagnostics : string list
}

// ─────────────────────────────────────────────────────────────────────────────
// Core build logic
// ─────────────────────────────────────────────────────────────────────────────

/// Given a list of (name, WModule) pairs in dependency order,
/// link them according to the build options and return the artifacts.
let buildFromModules
        (opts: BuildOptions)
        (namedModules: (string * WModule) list)
        : BuildResult =

    let diags = ResizeArray<string>()

    match opts.Mode with

    | StaticLink ->
        // Strategy A: merge everything into one .wasm
        let linkResult = link { LinkOptions.defaults with DeduplicateFunctions = true } namedModules

        for d in linkResult.Diagnostics do
            match d with
            | UnresolvedImport(name, fromMod) ->
                let msg = $"Unresolved import '{name}' from module '{fromMod}'"
                if opts.WarningsAsErrors then failwith msg
                diags.Add($"WARNING: {msg}")
            | DuplicateExport(name, mods) ->
                diags.Add($"""WARNING: duplicate export '{name}' from {String.concat ", " mods}""")
            | TypeDeduplication _ -> ()   // Informational

        let merged = linkResult.Module

        // Emit WAT
        let watText = Wat.moduleToWat merged // TODO: why not call it same as binary?
        
        // Emit binary: WModule → WasmModule → bytes
        let wasmModule = E.emitModule merged
        let wasmBytes = Enc.encodeModule wasmModule

        let projectName = namedModules |> List.last |> fst
        let wasmPath    = Path.Combine(opts.OutputDir, projectName + ".wasm")
        let watPath     = Path.Combine(opts.OutputDir, projectName + ".wat")

        // Write interface for the merged module (useful for consumers)
        let iface = extract projectName "merged" merged

        { OutputFiles = [(wasmPath, wasmBytes)]
          WatFiles    = [(watPath,  watText)]
          Interfaces  = [(projectName, iface)]
          Diagnostics = diags |> Seq.toList }

    | SeparateModules ->
        // Strategy B: per-module artifacts (host links at instantiation)
        // Not fully implementable until GC type imports are standardised —
        // emit each module separately but warn that GC types won't be shared.
        diags.Add("WARNING: SeparateModules mode — GC types (struct refs) cannot cross module boundaries without the Component Model. Use StaticLink for now.")

        let results = ResizeArray<string * byte[]>()
        let wats    = ResizeArray<string * string>()
        let ifaces  = ResizeArray<string * ModuleInterface>()

        for name, m in namedModules do
            let wat   = Wat.moduleToWat m
            let wasmModule = E.emitModule m
            let bytes = Enc.encodeModule wasmModule
            let iface = extract name "head" m

            results.Add(Path.Combine(opts.OutputDir, name + ".wasm"), bytes)
            wats.Add(Path.Combine(opts.OutputDir, name + ".wat"),    wat)
            ifaces.Add(name, iface)

            // Write .wgi alongside each .wasm
            match opts.CacheDir with
            | Some dir ->
                Directory.CreateDirectory(dir) |> ignore
                let wgiPath = Path.Combine(dir, name + ".wgi")
                let json: string = toJson iface
                File.WriteAllText(wgiPath, json)
            | None -> ()

        { OutputFiles = results |> Seq.toList
          WatFiles    = wats    |> Seq.toList
          Interfaces  = ifaces  |> Seq.toList
          Diagnostics = diags   |> Seq.toList }

// ─────────────────────────────────────────────────────────────────────────────
// Pipeline.fs integration
// ─────────────────────────────────────────────────────────────────────────────

/// Called from Pipeline.Core after all WModules have been compiled.
/// Replaces the ad-hoc `buildWModule finalCtx |> emitWasm` call sequence.
///
/// `compiledModules`: pairs of (projectName, WModule) in dependency order.
///   The last entry is the "application" module whose exports become the wasm exports.
///
/// `outDir`: directory where .wasm / .wat / .wgi files are written.
let emitAll (compiledModules: (string * WModule) list) (outDir: string) : unit =
    if compiledModules.IsEmpty then ()
    else
        let opts = BuildOptions.defaults outDir
        let result = buildFromModules opts compiledModules

        // Write artifacts
        Directory.CreateDirectory(outDir) |> ignore
        for path, bytes in result.OutputFiles do
            File.WriteAllBytes(path, bytes)
            printfn $"  Written: {path} ({bytes.Length} bytes)"
        for path, text in result.WatFiles do
            File.WriteAllText(path, text)
            printfn $"  Written: {path}"

        // Print diagnostics
        for diag in result.Diagnostics do
            eprintfn $"[WasmGc] {diag}"
