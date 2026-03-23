/// WasmGC compilation pipeline.
/// Mirrors the pattern of Fable's built-in language backends.
/// Call compileFile from any host that has a Fable.Compiler instance
/// (e.g. a custom CLI, a dotnet tool wrapping Fable.Compiler.CodeServices).
module Fable.Transforms.WasmGc.WasmGcPipeline

open System.Collections.Concurrent
open Fable
open Fable.AST
open Fable.Transforms
open Fable.Transforms.WasmGc

// Per-project shared Ctx accumulated across source files.
// Keyed by project file path; cleared when the last file has been processed.
let private sharedCtxs = ConcurrentDictionary<string, WasmGcTypes.Ctx>()

// ─────────────────────────────────────────────────────────────────
// WIT / Component Model helpers
// ─────────────────────────────────────────────────────────────────

/// Convert a WType to its WIT canonical type string.
/// Returns None for reference types (structs, closures) that can't cross the component boundary.
let private witType (ty: WasmGc.WType) : string option =
    match ty with
    | WasmGc.WType.I32 -> Some "s32"
    | WasmGc.WType.I64 -> Some "s64"
    | WasmGc.WType.F32 -> Some "f32"
    | WasmGc.WType.F64 -> Some "f64"
    | WasmGc.WType.Void -> Some ""         // unit return (no result type)
    | _ -> None                            // ref types — not WIT-exportable yet

/// Escape a Wasm function name as a WIT identifier.
/// Valid WIT ids are [a-z][a-z0-9-]* (kebab-case).  Anything else is quoted: %"name".
let private witId (name: string) : string =
    let valid = name |> Seq.forall (fun c -> System.Char.IsLower(c) || System.Char.IsDigit(c) || c = '-')
    if valid && name.Length > 0 && System.Char.IsLower(name.[0]) then name
    else sprintf "%%\"%s\"" name

/// Generate a WIT world file describing the primitive-type exports of a WModule.
/// Returns None if there are no WIT-exportable functions.
let generateWit (wmod: WasmGc.WModule) (packageName: string) (worldName: string) : string option =
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
        // Get or create shared Ctx for this project.
        let ctx =
            match sharedCtxs.TryGetValue(projectFile) with
            | true, existing -> existing
            | _ ->
                let fresh = WasmGcTypes.Ctx.Create(com)
                sharedCtxs.[projectFile] <- fresh
                fresh

        // Front-end: F# → Fable AST → Fable IR (language-agnostic transforms)
        let fableFile =
            FSharp2Fable.Compiler.transformFile com
            |> FableTransforms.transformFile com

        let isLastFile = com.CurrentFile = (Array.last com.SourceFiles)
        let finalCtx = Fable2WasmGc.processFileIntoCtx ctx com fableFile isLastFile
        sharedCtxs.[projectFile] <- finalCtx

        // Emit only on the last source file.
        if not isSilent && isLastFile then
            sharedCtxs.TryRemove(projectFile) |> ignore

            let wasmModule =
                Fable2WasmGc.buildWModule finalCtx
                |> WasmGcOptimize.optimizeModule

            let dir = System.IO.Path.GetDirectoryName(outPath)
            if not (System.IO.Directory.Exists(dir)) then
                System.IO.Directory.CreateDirectory(dir) |> ignore

            let stem = System.IO.Path.GetFileNameWithoutExtension(outPath)

            // Always emit WAT (human-readable, primary output for debugging)
            let watPath = System.IO.Path.Combine(dir, stem + ".wat")
            let watText = WasmGcWat.moduleToWat wasmModule
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
                let lowered = WasmGcEmit.emitModule wasmModule
                let bytes = WasmGcEncoder.encodeModule lowered
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
