/// WasmGC compilation pipeline.
/// Mirrors the pattern of Fable's built-in language backends.
/// Call compileFile from any host that has a Fable.Compiler instance
/// (e.g. a custom CLI, a dotnet tool wrapping Fable.Compiler.CodeServices).
module WasmGc.Pipeline.Core

open System.Collections.Concurrent
open Fable
open Fable.AST
open Fable.Transforms
open WasmGc.Core.AST

module T         = WasmGc.Runtime.Types
module Lowering  = WasmGc.Transforms.Fable2Wasm
module WasmXform = WasmGc.Transforms.FableAstGate

// our clean Fable-stage transform
module Opt       = WasmGc.Emit.Optimize
module L         = WasmGc.Runtime.Locals
module W         = WasmGc.Emit.Wat
module E         = WasmGc.Emit.Emit
module Bin       = WasmGc.Emit.Encoder
module Phases    = WasmGc.Pipeline.Phases

/// A source file whose F# → Fable step is done and which waits for the others (see compileFile).
type private PendingFile =
    { Com: Compiler; File: Fable.File; IsLibrary: bool; IsEntry: bool; OutPath: string }

// Per-project files that have been through the front-end, keyed by project file, then by full source path.
let private pendingFiles = ConcurrentDictionary<string, ConcurrentDictionary<string, PendingFile>>()

// Per-project lock objects — serialize processFileIntoCtx calls per project
// so that all shared mutable Ctx fields (TypeDefs, Dictionaries, etc.) are
// updated atomically without concurrent modification exceptions.
let private compilationLocks = ConcurrentDictionary<string, obj>()


// ─────────────────────────────────────────────────────────────────
// WIT / Component Model helpers
// ─────────────────────────────────────────────────────────────────

/// Convert a WType to its WIT canonical type string.
/// Returns None for reference types (structs, closures) that can't cross the component boundary.
let private witType (ty: WType) : string option =
    match ty with
    | WType.I32  -> Some "s32"
    | WType.I64  -> Some "s64"
    | WType.F32  -> Some "f32"
    | WType.F64  -> Some "f64"
    | WType.Void -> Some ""      // unit return (no result type)
    | _          -> None         // ref types — not WIT-exportable yet

/// Escape a Wasm function name as a WIT identifier.
/// Valid WIT ids are [a-z][a-z0-9-]* (kebab-case). Anything else is quoted: %"name".
let private witId (name: string) : string =
    let valid = name |> Seq.forall (fun c -> System.Char.IsLower c || System.Char.IsDigit c || c = '-')
    if valid && name.Length > 0 && System.Char.IsLower name[0] then name
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
                        let pId = pName.TrimStart '$'
                        if wt = "" then failwith "void param impossible"
                        pId + ": " + wt))
            // All params must be primitive (same count)
            if paramWit.Length <> f.Params.Length then None
            else
            match witType f.Result with
            | None -> None
            | Some retWit ->
                let exportName = witId (f.Name.TrimStart '$')
                let paramStr   = paramWit |> String.concat ", "
                let funcLine =
                    if retWit = "" then $"  export %s{exportName}: func(%s{paramStr});"
                    else                $"  export %s{exportName}: func(%s{paramStr}) -> %s{retWit};"
                Some funcLine)

    if witFuncs.IsEmpty then None
    else
        let lines = [
            $"package %s{packageName}:%s{worldName}@0.1.0;"
            ""
            $"world %s{worldName} {{"
            yield! witFuncs
            "}"
        ]
        Some (lines |> String.concat "\n")

/// Run a command and return true if it exited with code 0.
let private runCmd (exe: string) (args: string) : bool =
    try
        let psi = System.Diagnostics.ProcessStartInfo(exe, args)
        psi.UseShellExecute        <- false
        psi.RedirectStandardError  <- true
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
///   com         — per-file Compiler instance (entity lookups rooted here)
///   projectFile — absolute path to the .fsproj (used as Ctx key)
///   isSilent    — suppress output when true (used in watch-mode no-op passes)
///   outPath     — path for the .wasm output (stem is also used for .wat sidecar)
let compileFile (com: Compiler) (projectFile: string) (isSilent: bool) (outPath: string) =
    async {
        // Front-end: F# → Fable AST (FCS), then apply our clean WasmGC transforms.
        // WasmXform.transformFileForWasm replaces FableTransforms.transformFile:
        //   ✓ uncurryMemberArgs (via transformDeclaration structural pass)
        //   ✗ curryReceivedArgs / uncurrySendingArgs / propagateCurrying — JS only, skipped
        let fableFile =
            FSharp2Fable.Compiler.transformFile com
            |> WasmXform.transformFileForWasm com

        // Only the entry project's own files keep their functions' names (they are the module's exports).  Every other
        // file — FSharp.Wasm.Core, fable_modules, and the files of a project the program references — has its
        // functions prefixed with the file's name, so that `bounds` of one module and `bounds` of another do not collide.
        // We detect "is library" by path rather than by source-file order, so the pipeline
        // is robust regardless of which file gets compiled first in ThreadPool.
        let currentFile = com.CurrentFile
        let isLibraryFile =
            Fable.Naming.isInFableModules currentFile
            || WasmGc.Runtime.Types.isCoreLibraryFile com currentFile
            || System.IO.Path.GetFileName(currentFile) = "Interop.fs"
        // Only the entry project's own files export their functions; a referenced project (a runtime library) does not.
        let isEntryFile =
            let dir = System.IO.Path.GetDirectoryName(System.IO.Path.GetFullPath projectFile)
            let file = System.IO.Path.GetFullPath currentFile
            file.StartsWith(dir.TrimEnd(System.IO.Path.DirectorySeparatorChar) + string System.IO.Path.DirectorySeparatorChar, System.StringComparison.Ordinal)

        // The Fable host hands the files over in parallel and in ANY order, but lowering is order-dependent: a type must
        // be declared before the code that uses it, a function before its callers.  So each file is parked here after
        // its (thread-safe, parallel) F# → Fable step; whoever completes the set lowers all of them, in project order,
        // on one thread.
        let totalFiles =
            com.SourceFiles
            |> Array.filter (fun f -> f.EndsWith(".fs") || f.EndsWith(".fsx"))
            |> Array.length
        let compilationMutex = compilationLocks.GetOrAdd(projectFile, fun _ -> obj())
        let completed : PendingFile list option =
            lock compilationMutex (fun () ->
                let parked = pendingFiles.GetOrAdd(projectFile, fun _ -> ConcurrentDictionary<string, PendingFile>())
                let key (f: string) = System.IO.Path.GetFullPath f
                parked[key currentFile] <-
                    { Com = com; File = fableFile; IsLibrary = isLibraryFile; IsEntry = isEntryFile; OutPath = outPath }
                if parked.Count < totalFiles then None
                else
                    pendingFiles.TryRemove projectFile |> ignore
                    let inOrder = com.SourceFiles |> Array.map key |> Array.distinct
                    let known = inOrder |> Array.choose (fun f -> match parked.TryGetValue f with | true, p -> Some p | _ -> None)
                    let unknown = parked |> Seq.filter (fun kv -> not (Array.contains kv.Key inOrder)) |> Seq.map (fun kv -> kv.Value) |> Seq.toArray
                    Some(List.ofArray (Array.append known unknown)))

        // Emit only when every source file has arrived (and not in a silent watch pass).
        // The output path is the app file's, not a library file's.
        match completed with
        | Some files when not isSilent ->
            let emitPath =
                match files |> List.filter (fun p -> not p.IsLibrary) |> List.tryLast with
                | Some p -> p.OutPath
                | None -> outPath

            let finalCtx =
                let stringMode =
                    match System.Environment.GetEnvironmentVariable("WASMGC_STRING_MODE") with
                    | "i16" -> T.I16
                    | _     -> T.I32
                files
                |> List.fold
                    (fun (ctx: T.Ctx) p ->
                        Lowering.processFileIntoCtx { ctx with ExportFunctions = p.IsEntry } p.Com p.File p.IsEntry)
                    (T.Ctx.Create(files.Head.Com, stringMode))

            let wasmModule =
                let declarations = (files |> List.filter (fun p -> not p.IsLibrary) |> List.tryLast |> Option.defaultValue files.Head).File.Declarations

                // ── Flush accumulated diagnostics from all processed files ────────
                // Each processFileIntoCtx call accumulates into finalCtx.Diagnostics.
                // Print here (after last file) so all warnings are visible together.
                // Dump the Fable AST first: it is what you need when the transform itself reports errors.
                let opts = Phases.optionsFromEnv ()
                Phases.phase0_Input opts declarations |> ignore
                finalCtx.Diagnostics.FailOnErrors("Fable → WExpr")

                // Call the full pipeline defined in Phases.fs
                // This properly runs:
                //   Phase 3: Fable → raw WExpr
                //   Phase 4: Normalize
                //   Phase 4b: Lower (ClosureApply → CallRef, etc.)
                //   Phase 5: Resolve locals
                //   Phase 6: Validate
                //   Phase 7: Optimize
                match Phases.runPipeline finalCtx declarations opts with
                | Ok pipelineModule -> pipelineModule
                | Error errors ->
                    errors |> List.iter (fun e ->
                        eprintfn $"  ✗ [%s{e.FuncName}] %s{e.NodeDesc}: %s{e.Message}")
                    failwith "Pipeline validation failed"

            let dir  = System.IO.Path.GetDirectoryName(emitPath)
            let stem = System.IO.Path.GetFileNameWithoutExtension(emitPath)

            if not (System.IO.Directory.Exists dir) then
                System.IO.Directory.CreateDirectory dir |> ignore

            // Always emit WAT (human-readable, primary output for debugging)
            let watPath    = System.IO.Path.Combine(dir, stem + ".wat")
            let watContent = W.moduleToWat wasmModule
            do! System.IO.File.WriteAllTextAsync(watPath, watContent) |> Async.AwaitTask

            // WAT-first binary: wasm-tools parse; fallback to built-in encoder.
            let wasmPath = System.IO.Path.Combine(dir, stem + ".wasm")
            let watFirstSucceeded =
                if not (System.IO.File.Exists watPath) then false
                else
                try
                    let psi =
                        System.Diagnostics.ProcessStartInfo(
                            "wasm-tools",
                            $"parse \"%s{watPath}\" -o \"%s{wasmPath}\"")
                    psi.UseShellExecute       <- false
                    psi.RedirectStandardError <- true
                    use proc = System.Diagnostics.Process.Start(psi)
                    // Read stderr BEFORE waiting (a full pipe would deadlock) and never swallow it:
                    // a WAT file that `wasm-tools parse` rejects is a compiler bug (WAT printer vs encoder
                    // divergence), not something to hide behind the fallback.
                    let err = proc.StandardError.ReadToEnd()
                    proc.WaitForExit()
                    if proc.ExitCode <> 0 then
                        let firstLines = err.Split('\n') |> Array.truncate 4 |> String.concat "\n      "
                        eprintfn "    ⚠️  wasm-tools parse rejected %s — using the built-in encoder instead:\n      %s" watPath firstLines
                    proc.ExitCode = 0
                with _ -> false   // wasm-tools not installed → built-in encoder (silent, expected)

            if not watFirstSucceeded then
                let lowered   = E.emitModule wasmModule
                let bytes     = Bin.encodeModule lowered
                let wasmBytes : byte[] = bytes
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
                if not (System.IO.Directory.Exists witDir) then
                    System.IO.Directory.CreateDirectory witDir |> ignore
                let witPath = System.IO.Path.Combine(witDir, worldName + ".wit")
                do! System.IO.File.WriteAllTextAsync(witPath, witContent) |> Async.AwaitTask

                // Try to produce a Component binary using wasm-tools.
                // Steps: embed WIT metadata → create component.
                let embeddedPath  = System.IO.Path.Combine(dir, stem + "-embedded.wasm")
                let componentPath = System.IO.Path.Combine(dir, stem + "-component.wasm")
                let embedOk =
                    runCmd "wasm-tools"
                        $"component embed \"%s{witDir}\" \"%s{wasmPath}\" -o \"%s{embeddedPath}\""

                if embedOk then
                    let newOk =
                        runCmd "wasm-tools"
                            $"component new \"%s{embeddedPath}\" -o \"%s{componentPath}\""

                    if newOk then
                        eprintfn $"    ✅ Component: %s{componentPath}"
                    else
                        eprintfn "    ⚠️  wasm-tools component new failed — embedded.wasm kept"
                else
                    eprintfn $"    ℹ️  wasm-tools not found or embed failed — WIT written to %s{witPath}"
        | _ -> ()
    }

