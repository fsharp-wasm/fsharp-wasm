/// WasmGC compilation pipeline.
/// Mirrors the pattern of Fable's built-in language backends.
/// Call compileFile from any host that has a Fable.Compiler instance
/// (e.g. a custom CLI, a dotnet tool wrapping Fable.Compiler.CodeServices).
module Fable.Transforms.WasmGc.Pipeline

open System.Collections.Concurrent
open Fable
open Fable.AST
open Fable.Transforms
open Fable.AST.Wasm

module T = Fable.Transforms.WasmGc.Runtime.Types
module Lowering = Fable.Transforms.WasmGc.Transforms.Fable2Wasm
module Opt = Fable.Transforms.WasmGc.Emit.Optimize
module L = Fable.Transforms.WasmGc.Runtime.Locals
module W = Fable.Transforms.WasmGc.Emit.Wat
module E = Fable.Transforms.WasmGc.Emit.Emit
module Bin = Fable.Transforms.WasmGc.Emit.Encoder

// Per-project shared Ctx accumulated across source files.
// Keyed by project file path; cleared when the last file has been processed.
let private sharedCtxs = ConcurrentDictionary<string, T.Ctx>()

// Per-project lock objects — serialize processFileIntoCtx calls per project
// so that all shared mutable Ctx fields (TypeDefs, Dictionaries, etc.) are
// updated atomically without concurrent modification exceptions.
let private compilationLocks = ConcurrentDictionary<string, obj>()

// Per-project count of files processed.
// Uses atomic AddOrUpdate; when count reaches com.SourceFiles.Length, emission happens.
let private processedCounts = ConcurrentDictionary<string, int>()

// Per-project emit outPath — the outPath of the "app" (non-library) source file,
// which determines where App.wasm / App.wat are written.
let private emitOutPaths = ConcurrentDictionary<string, string>()

// ─────────────────────────────────────────────────────────────────
// WIT / Component Model helpers
// ─────────────────────────────────────────────────────────────────

/// Convert a WType to its WIT canonical type string.
/// Returns None for reference types (structs, closures) that can't cross the component boundary.
let private witType (ty: WType) : string option =
    match ty with
    | WType.I32 -> Some "s32"
    | WType.I64 -> Some "s64"
    | WType.F32 -> Some "f32"
    | WType.F64 -> Some "f64"
    | WType.Void -> Some ""         // unit return (no result type)
    | _ -> None                     // ref types — not WIT-exportable yet

/// Escape a Wasm function name as a WIT identifier.
/// Valid WIT ids are [a-z][a-z0-9-]* (kebab-case).  Anything else is quoted: %"name".
let private witId (name: string) : string =
    let valid = name |> Seq.forall (fun c -> System.Char.IsLower(c) || System.Char.IsDigit(c) || c = '-')
    if valid && name.Length > 0 && System.Char.IsLower(name.[0]) then name
    else sprintf "%%\"%s\"" name

/// Generate a WIT world file describing the primitive-type exports of a WModule.
/// Returns None if there are no WIT-exportable functions.
let generateWit (wmod: WModule) (packageName: string) (worldName: string) : string option =
    let witFuncs =
        wmod.Functions
        |> List.filter (fun f -> f.Exported)
        |> List.choose (fun f ->
            // Try converting all param types
            let paramWit =
                f.Params
                |> List.choose (fun (pName, ty) ->
                    witType ty |> Option.map (fun wt ->
                        let pId = pName.TrimStart('$')
                        if wt = "" then failwith "void param impossible"
                        pId + ": " + wt))
            // All params must be primitive (same count)
            if paramWit.Length <> f.Params.Length then None
            else
            match witType f.Result with
            | None -> None
            | Some retWit ->
                let exportName = witId (f.Name.TrimStart('$'))
                let paramStr = paramWit |> String.concat ", "
                let funcLine =
                    if retWit = "" then
                        sprintf "  export %s: func(%s);" exportName paramStr
                    else
                        sprintf "  export %s: func(%s) -> %s;" exportName paramStr retWit
                Some funcLine)

    if witFuncs.IsEmpty then None
    else
        let lines = [
            sprintf "package %s:%s@0.1.0;" packageName worldName
            ""
            sprintf "world %s {" worldName
            yield! witFuncs
            "}"
        ]
        Some (lines |> String.concat "\n")

/// Run a command and return true if it exited with code 0.
let private runCmd (exe: string) (args: string) : bool =
    try
        let psi = System.Diagnostics.ProcessStartInfo(exe, args)
        psi.UseShellExecute <- false
        psi.RedirectStandardError <- true
        use proc = System.Diagnostics.Process.Start(psi)
        proc.WaitForExit()
        proc.ExitCode = 0
    with _ -> false

// ─────────────────────────────────────────────────────────────────

/// Compile one file of a Fable project into a WasmGC output.
/// On all files except the last: accumulates declarations into the shared Ctx.
/// On the last file: finalizes and emits WAT + .wasm binary.
///
/// Parameters follow the Fable pipeline convention:
///   com       — per-file Compiler instance (entity lookups rooted here)
///   projectFile — absolute path to the .fsproj (used as Ctx key)
///   isSilent  — suppress output when true (used in watch-mode no-op passes)
///   outPath   — path for the .wasm output (stem is also used for .wat sidecar)
let compileFile (com: Compiler) (projectFile: string) (isSilent: bool) (outPath: string) =
    async {
        // Front-end: F# → Fable AST → Fable IR (language-agnostic transforms)
        let fableFile =
            FSharp2Fable.Compiler.transformFile com
            |> FableTransforms.transformFile com

        // Library files (from fable-library-wasmgc/ or fable_modules/) are
        // isLastFile=false — their functions get prefixed names and are not exported.
        // App files are isLastFile=true — functions get their original names and are exported.
        // We detect "is library" by path rather than by source-file order, so the pipeline
        // is robust regardless of which file gets compiled first in ThreadPool.
        let currentFile = com.CurrentFile
        let isLibraryFile =
            Fable.Naming.isInFableModules currentFile
            || currentFile.Contains("fable-library-wasmgc")
            || System.IO.Path.GetFileName(currentFile) = "Interop.fs"
        let isLastFile = not isLibraryFile

        // Serialize ALL Ctx mutations per-project — the shared Ctx contains many
        // non-thread-safe mutable fields (TypeDefs ResizeArray, Dictionaries, etc.).
        // The F# front-end (transformFile above) is thread-safe; only the WasmGC
        // transform phase needs to be sequential.
        let compilationMutex = compilationLocks.GetOrAdd(projectFile, fun _ -> obj())
        let finalCtx =
            lock compilationMutex (fun () ->
                // Re-read the latest ctx inside the lock so each file sees all
                // declarations accumulated by previously completed files.
                let latestCtx =
                    match sharedCtxs.TryGetValue(projectFile) with
                    | true, c -> c
                    | _ ->
                        let stringMode =
                            match System.Environment.GetEnvironmentVariable("WASMGC_STRING_MODE") with
                            | "i16" -> T.I16
                            | _     -> T.I32
                        let fresh = T.Ctx.Create(com, stringMode)
                        sharedCtxs.[projectFile] <- fresh
                        fresh
                let ctx = Lowering.processFileIntoCtx latestCtx com fableFile isLastFile
                // Write BEFORE releasing lock so subsequent files see the update.
                sharedCtxs.[projectFile] <- ctx
                ctx)

        // Track the correct output path from the app (non-library) file.
        if not isLibraryFile then
            emitOutPaths.[projectFile] <- outPath

        // Count files processed.  Emission happens when the count reaches the total.
        // This works regardless of processing order (race-free).
        let totalFiles = com.SourceFiles |> Array.filter (fun f -> f.EndsWith(".fs") || f.EndsWith(".fsx")) |> Array.length
        let processedCount = processedCounts.AddOrUpdate(projectFile, 1, fun _ c -> c + 1)
        let allDone = processedCount >= totalFiles

        // Emit only when all source files have been processed.
        // Use the stored app-file outPath (not the current file's outPath which may be a library file).
        if not isSilent && allDone then
            let emitPath =
                match emitOutPaths.TryGetValue(projectFile) with
                | true, p -> p
                | _ -> outPath  // fallback: single-file project
            processedCounts.TryRemove(projectFile) |> ignore
            emitOutPaths.TryRemove(projectFile) |> ignore
            sharedCtxs.TryRemove(projectFile) |> ignore

            let wasmModule =
                let rawModule = Lowering.buildWModule finalCtx
                let optimized = Opt.optimizeModule rawModule
                // Re-run resolveLocals after optimization: join-point inlining introduces new
                // Let bindings (e.g. db_2 = arg) whose locals weren't visible before inlining.
                { optimized with
                    Functions = optimized.Functions |> List.map L.resolveLocals }

            let dir = System.IO.Path.GetDirectoryName(emitPath)
            if not (System.IO.Directory.Exists(dir)) then
                System.IO.Directory.CreateDirectory(dir) |> ignore

            let stem = System.IO.Path.GetFileNameWithoutExtension(emitPath)

            // Always emit WAT (human-readable, primary output for debugging)
            let watPath = System.IO.Path.Combine(dir, stem + ".wat")
            let watText = W.moduleToWat wasmModule
            let watContent: string = watText
            do! System.IO.File.WriteAllTextAsync(watPath, watContent) |> Async.AwaitTask

            // WAT-first binary: wasm-tools parse; fallback to built-in encoder.
            let wasmPath = System.IO.Path.Combine(dir, stem + ".wasm")
            let watFirstSucceeded =
                if not (System.IO.File.Exists(watPath)) then false
                else
                try
                    let psi =
                        System.Diagnostics.ProcessStartInfo(
                            "wasm-tools",
                            sprintf "parse \"%s\" -o \"%s\"" watPath wasmPath)
                    psi.UseShellExecute <- false
                    psi.RedirectStandardError <- true
                    use proc = System.Diagnostics.Process.Start(psi)
                    proc.WaitForExit()
                    proc.ExitCode = 0
                with _ -> false

            if not watFirstSucceeded then
                let lowered = E.emitModule wasmModule
                let bytes = Bin.encodeModule lowered
                let wasmBytes: byte[] = bytes
                do! System.IO.File.WriteAllBytesAsync(wasmPath, wasmBytes) |> Async.AwaitTask

            // ── WIT / Component Model ───────────────────────────────────────
            // Generate a WIT world file for all primitive-type exports.
            // If wasm-tools is available, also wrap into a Component binary.
            let packageName = stem.ToLowerInvariant().Replace(".", "-").Replace("_", "-")
            let worldName   = packageName
            match generateWit wasmModule packageName worldName with
            | None -> ()
            | Some witContent ->
                let witDir  = System.IO.Path.Combine(dir, "wit")
                if not (System.IO.Directory.Exists(witDir)) then
                    System.IO.Directory.CreateDirectory(witDir) |> ignore
                let witPath = System.IO.Path.Combine(witDir, worldName + ".wit")
                do! System.IO.File.WriteAllTextAsync(witPath, witContent) |> Async.AwaitTask

                // Try to produce a Component binary using wasm-tools.
                // Steps: embed WIT metadata → create component.
                let embeddedPath  = System.IO.Path.Combine(dir, stem + "-embedded.wasm")
                let componentPath = System.IO.Path.Combine(dir, stem + "-component.wasm")
                let embedOk =
                    runCmd "wasm-tools"
                        (sprintf "component embed \"%s\" \"%s\" -o \"%s\""
                            witDir wasmPath embeddedPath)
                if embedOk then
                    let newOk =
                        runCmd "wasm-tools"
                            (sprintf "component new \"%s\" -o \"%s\""
                                embeddedPath componentPath)
                    if newOk then
                        eprintfn "    ✅ Component: %s" componentPath
                    else
                        eprintfn "    ⚠️  wasm-tools component new failed — embedded.wasm kept"
                else
                    eprintfn "    ℹ️  wasm-tools not found or embed failed — WIT written to %s" witPath
    }
