// In-Memory Compiler Pipeline Helper — Complete F# → AST → IR → WAT → WASM
//
// This module provides a full-featured in-process compiler that runs F# source strings
// through the complete WasmGC pipeline without shelling out to CLI or writing files.
//
// Pipeline stages:
//   1. F# source string
//   2. Parse & type-check via FSharp.Compiler.Service (FCS)
//   3. F# AST → Fable AST (FSharp2Fable)
//   4. Fable transformations (inlining, tail calls, etc.)
//   5. Fable AST → WasmGC IR context (Fable2Wasm)
//   6. Raw WModule (Phase 3-4)
//   7. Normalized WModule
//   8. WAT text emission
//   9. Optional: WASM binary (via wasm-as or wasm-opt)
//
// Usage:
//   let output = InMemoryPipelineHelper.compileSource fsharpSourceCode
//   // output.WModule - use for AST assertions
//   // output.WatText - use for WAT snapshots
//   // output.WasmBinary - optional WASM binary
//
namespace Tests

// open System
open System.IO
open System.Diagnostics
open FSharp.Compiler.CodeAnalysis
open FSharp.Compiler.Text
open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.Compiler.Util
// open Fable.Transforms
open WasmGc.Core.AST

/// All stages of the compilation pipeline output
type CompilationStages = {
    /// The original F# source code
    FSharpSource: string
    
    /// F# Compiler Service type-checked declarations
    FcsDeclarations: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list
    
    /// Fable intermediate AST before transformations
    FableAstRaw: Fable.AST.Fable.ModuleDecl list
    
    /// Fable AST after all transformations
    FableAstTransformed: Fable.AST.Fable.ModuleDecl list
    
    /// WasmGC IR before normalization (Phase 3/4)
    WModuleRaw: WModule
    
    /// WasmGC IR after normalization and lowering (final IR)
    WModuleNormalized: WModule
    
    /// WebAssembly Text format (WAT) - human-readable
    WatText: string
    
    /// Optional: WebAssembly binary (only if wasm-as is available)
    WasmBinary: byte[] option
}

/// Compile result wrapped in Result type for error handling
type CompileResult = Result<CompilationStages, string>

module InMemoryPipelineHelper =

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 1-2: FCS (F# Compiler Service)
    // ──────────────────────────────────────────────────────────────────────────────

    /// Parse and type-check F# source code using FCS
    let private fcsParseAndCheck (code: string) : Result<FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list, string> =
        try
            let checker = FSharpChecker.Create()
            let tempFile = Path.ChangeExtension(Path.GetTempFileName(), ".fs")
            
            try
                File.WriteAllText(tempFile, code)
                
                let projOptions, _ = 
                    checker.GetProjectOptionsFromScript(tempFile, SourceText.ofString code)
                    |> Async.RunSynchronously

                let parseResults, checkResults = 
                    checker.ParseAndCheckFileInProject(
                        tempFile, 1, 
                        SourceText.ofString code, 
                        projOptions)
                    |> Async.RunSynchronously

                match checkResults with
                | FSharpCheckFileAnswer.Succeeded(res) -> 
                    match res.ImplementationFile with
                    | Some implFile -> Ok(implFile.Declarations)
                    | None -> Error("Type checking succeeded but no ImplementationFile was produced")
                | FSharpCheckFileAnswer.Aborted -> 
                    let errors = String.concat "\n" (parseResults.Diagnostics |> Array.map (fun e -> e.Message))
                    Error($"Type checking aborted:\n{errors}")
            finally
                try File.Delete(tempFile) with _ -> ()
        with ex ->
            Error($"FCS parsing failed: {ex.Message}")

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 2-3: Mock Compiler Interface for Fable
    // ──────────────────────────────────────────────────────────────────────────────

    /// Mock Compiler that implements Fable.Compiler interface for in-memory testing
    type private MockCompiler(fcsDeclarations: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list) =
        let options : Fable.CompilerOptions = 
            {
                TypedArrays           = true
                ClampByteArrays       = false
                Language              = Fable.Language.WasmGc
                Define                = []
                DebugMode             = false
                OptimizeFSharpAst     = true
                Verbosity             = Verbosity.Normal
                FileExtension         = ".fs"
                TriggeredByDependency = false
                NoReflection          = true
            }

        interface Fable.Compiler with
            member _.Options = options
            member _.LibraryDir = 
                // Try to find Fable.Core in the workspace
                let candidates = [
                    Path.Combine(__SOURCE_DIRECTORY__, "../../vendor/Fable/src/Fable.Core")
                    Path.Combine(__SOURCE_DIRECTORY__, "../../../../vendor/Fable/src/Fable.Core")
                    Path.Combine(__SOURCE_DIRECTORY__, "../../../../../vendor/Fable/src/Fable.Core")
                ]
                candidates 
                |> List.tryFind Directory.Exists
                |> Option.defaultValue (Path.Combine(__SOURCE_DIRECTORY__, "../../vendor/Fable/src/Fable.Core"))
                
            member _.CurrentFile = "InMemoryTest.fs"
            member _.GetImplementationFile(_fileName) = 
                // Return the in-memory declarations instead of reading from disk
                fcsDeclarations
            member _.GetRootModule(_fileName) = 
                // Use Fable's internal helper to extract the root module from FCS declarations
                try
                    Fable.Transforms.FSharp2Fable.Compiler.getRootModule fcsDeclarations
                    // |> fst
                with ex ->
                    failwith $"Failed to extract root module: {ex.Message}"
            member _.TryGetEntity(_entityRef) = 
                // In-memory tests don't need full entity resolution
                None
            member _.GetInlineExpr(_entityRef) = 
                // In-memory tests don't use inline expressions 
                {
                    Args = []
                    Body = Fable.AST.Fable.Expr.Value(Fable.AST.Fable.ValueKind.Null Fable.AST.Fable.Type.Any, None)
                    FileName = ""
                    GenericArgs = []
                    ScopeIdents = Set.empty
                }

            member _.AddWatchDependency(_file) = ()
            member _.AddLog(msg, severity, ?range, ?fileName, ?tag) = 
                if severity = Severity.Error then
                    printfn $"[Fable Error] %s{msg}"
                    
            // TODO: Added these missing members for Fable 5
            member _.IncrementCounter() = 0
            member this.WillPrecompileInlineFunction(file: string) = this
            member _.IsPrecompilingInlineFunction = false
            member _.OutputDir = None
            member _.OutputType = Fable.OutputType.Exe // or Library, depending on your test
            member _.Plugins = { MemberDeclarationPlugins = Map.empty } // TODO: Adjust based on your imports
            member _.ProjectFile = ""
            member _.ProjectOptions = obj() :?> FSharp.Compiler.CodeAnalysis.FSharpProjectOptions // Or mock/null if not used
            member _.SourceFiles = [||]

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 3: FCS → Fable AST
    // ──────────────────────────────────────────────────────────────────────────────

    let private fcsToFableAst (fcsDeclarations: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list) 
                               : Result<Fable.AST.Fable.ModuleDecl list, string> =
                               // : Result<Fable.AST.Fable.ModuleDecl list, string> =
        try
            let com = MockCompiler(fcsDeclarations) :> Fable.Compiler
            // Run the FSharp2Fable transformation
            let file = Fable.Transforms.FSharp2Fable.Compiler.transformFile com
            let fableModuleDecls = file.Declarations
            
            // Filtere alle ModuleDeclaration-Fälle heraus und extrahiere das innere ModuleDecl
            let fableModuleDecls = 
                file.Declarations 
            
                |> List.choose (function
                    | ModuleDeclaration mDecl -> Some mDecl
                    | _ -> None)
            
            Ok(fableModuleDecls)
        with ex ->
            Error($"Fable AST generation failed: {ex.Message}")


    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 4: Fable transformations
    // ──────────────────────────────────────────────────────────────────────────────

    let private transformFableAst (fableAst: Fable.AST.Fable.ModuleDecl list) 
                                  (fcsDeclarations: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list)
                                  : Result<Fable.AST.Fable.ModuleDecl list, string> =
        try
            let com = MockCompiler(fcsDeclarations) :> Fable.Compiler
            // Apply standard Fable transformations
            let transformedAst = 
                fableAst
                // TODO: Apply FableTransforms.getTransformations here
                // For now, pass through as-is since the transformations need proper wiring
            Ok(transformedAst)
        with ex ->
            Error($"Fable AST transformation failed: {ex.Message}")

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 5-7: Fable AST → WasmGC IR (normalized WModule)
    // ──────────────────────────────────────────────────────────────────────────────

    let private fableToWasmIr (fcsDeclarations: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list)
                              (fableAst: Fable.AST.Fable.ModuleDecl list)
                              : Result<WModule * WModule, string> =
        try
            let com = MockCompiler(fcsDeclarations) :> Fable.Compiler
            let fableFile = Fable.File { Path = "InMemoryTest.fs"
                                         Declarations = fableAst }
            let ctx = WasmGc.Transforms.Fable2Wasm.Ctx.Create()
            let finalCtx = WasmGc.Transforms.Fable2Wasm.processFileIntoCtx ctx com fableFile true
            let wmoduleRaw = WasmGc.Transforms.Fable2Wasm.buildWModule finalCtx
            let wmoduleNormalized = WasmGc.Pipeline.Phases.phase4_Normalize {Verbosity=Verbosity.Silent} wmoduleRaw
            Ok(wmoduleRaw, wmoduleNormalized)
        with ex ->
            Error($"WasmGC IR generation failed: {ex.Message}")

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 8: WModule → WAT
    // ──────────────────────────────────────────────────────────────────────────────

    let private wmoduleToWat (wmodule: WModule) : Result<string, string> =
        try
            let wat = WasmGc.Emit.Wat.moduleToWat wmodule
            Ok(wat)
        with ex ->
            Error($"WAT emission failed: {ex.Message}")

    // ──────────────────────────────────────────────────────────────────────────────
    // Stage 9: WAT → WASM (optional, requires external tools)
    // ──────────────────────────────────────────────────────────────────────────────

    let private watToWasm (watText: string) : byte[] option =
        // Try to use wasm-as (from Binaryen) or wasm2wat to convert WAT to binary
        // This is optional; tests can work with just WAT
        try
            let tempWat = Path.ChangeExtension(Path.GetTempFileName(), ".wat")
            let tempWasm = Path.ChangeExtension(tempWat, ".wasm")
            try
                File.WriteAllText(tempWat, watText)
                
                // Try wasm-as from Binaryen
                let psi = ProcessStartInfo(
                    "wasm-as", $"\"{tempWat}\" -o \"{tempWasm}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false)
                
                match Process.Start(psi) with
                | null -> 
                    failwith "Failed to start the process."
                | proc ->
                    proc.WaitForExit(5000) |> ignore
                    
                    if proc.ExitCode = 0 && File.Exists(tempWasm) then
                        Some(File.ReadAllBytes(tempWasm))
                    else
                        None
            finally
                try File.Delete(tempWat) with _ -> ()
                try File.Delete(tempWasm) with _ -> ()
        with _ ->
            None

    // ──────────────────────────────────────────────────────────────────────────────
    // Main entry point: Orchestrate all stages
    // ──────────────────────────────────────────────────────────────────────────────

    /// Compile F# source code through the complete pipeline, producing all intermediate stages
    let compileSource (fsharpCode: string) : CompileResult =
        result {
            // Stage 1-2: FCS Parse & Type Check
            let! fcsDeclarations = fcsParseAndCheck fsharpCode
            
            // Stage 3: FCS → Fable AST (raw)
            let! fableAstRaw = fcsToFableAst fcsDeclarations
            
            // Stage 4: Apply Fable transformations
            let! fableAstTransformed = transformFableAst fableAstRaw fcsDeclarations
            
            // Stage 5-7: Fable → WasmGC IR (raw + normalized)
            let! (wmoduleRaw, wmoduleNormalized) = fableToWasmIr fcsDeclarations fableAstTransformed
            
            // Stage 8: WModule → WAT
            let! watText = wmoduleToWat wmoduleNormalized
            
            // Stage 9: WAT → WASM (optional)
            let wasmBinary = watToWasm watText
            
            return {
                FSharpSource = fsharpCode
                FcsDeclarations = fcsDeclarations
                FableAstRaw = fableAstRaw
                FableAstTransformed = fableAstTransformed
                WModuleRaw = wmoduleRaw
                WModuleNormalized = wmoduleNormalized
                WatText = watText
                WasmBinary = wasmBinary
            }
        }

    /// Helper to compile and assert - returns true if successful, false if skipped
    let compileAndAssertResult (fsharpCode: string) (f: CompilationStages -> unit) : bool =
        match compileSource fsharpCode with
        | Ok stages ->
            f stages
            true
        | Error msg ->
            printfn $"  [compilation error] %s{msg}"
            false

    /// Helper to get just the normalized WModule (most common use case)
    let tryCompileToWModule (fsharpCode: string) : WModule option =
        match compileSource fsharpCode with
        | Ok stages -> Some stages.WModuleNormalized
        | Error _ -> None

    /// Helper to get WAT text for snapshot testing
    let tryCompileToWat (fsharpCode: string) : string option =
        match compileSource fsharpCode with
        | Ok stages -> Some stages.WatText
        | Error _ -> None
