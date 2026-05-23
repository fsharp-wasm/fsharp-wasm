/// Mock Compiler Interface for In-Memory Fable Compilation
///
/// This module creates a mock Fable.Compiler that implements the Fable compiler interface,
/// allowing Fable transformations to run on F# code that has been type-checked via FCS
/// without requiring the full CLI pipeline.
///
/// Usage:
///   let fcsDeclarations = parseFSharpString code
///   let compiler = createMockCompiler code
///   let fableAst = Fable.Transforms.FSharp2Fable.Compiler.transformFile compiler
///
module TestNative.Helper.CompilerHelper

open System
open System.IO
open FSharp.Compiler.CodeAnalysis
open FSharp.Compiler.Text
open Fable
open Fable.Transforms
open Fable.AST

// ──────────────────────────────────────────────────────────────────────────────
// FCS (F# Compiler Service) Integration
// ──────────────────────────────────────────────────────────────────────────────

/// Parse and type-check F# source code using FCS (F# Compiler Service)
/// Returns the typed F# AST declarations on success
let parseFSharpString (code: string) : Result<FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list, string> =
    try
        let checker = FSharpChecker.Create()
        let tempFile = Path.ChangeExtension(Path.GetTempFileName(), ".fs")
        
        try
            File.WriteAllText(tempFile, code)
            
            let projOptions, _ = 
                checker.GetProjectOptionsFromScript(tempFile, SourceText.ofString code)
                |> Async.RunSynchronously

            let parseResults, checkResults = 
                checker.ParseAndCheckFileInProject(tempFile, 1, SourceText.ofString code, projOptions)
                |> Async.RunSynchronously

            match checkResults with
            | FSharpCheckFileAnswer.Succeeded(res) -> 
                match res.ImplementationFile with
                | Some implFile -> 
                    Ok(implFile.Declarations)
                | None -> 
                    Error("Type checking succeeded but no ImplementationFile was produced")
            | FSharpCheckFileAnswer.Aborted -> 
                let errors = 
                    parseResults.Errors 
                    |> Array.map (fun e -> e.Message) 
                    |> String.concat "\n"
                Error($"Type checking aborted:\n{errors}")
        finally
            try File.Delete(tempFile) with _ -> ()
    with ex ->
        Error($"FCS parsing failed: {ex.Message}")

// ──────────────────────────────────────────────────────────────────────────────
// Mock Compiler Implementation
// ──────────────────────────────────────────────────────────────────────────────

/// Mock Compiler that implements Fable.Compiler interface for in-memory testing.
/// This allows Fable transformations to run without shelling out to a CLI.
type MockCompiler (fcsDeclarations: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list) =
    
    // Standard Fable compiler options for WasmGC backend
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
            // TODO: we create our own Fable.Core (it's already in a subproject.) The Fable.Core from Fable is not compatible and optimized for other js
            // Try to locate Fable.Core library in workspace
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
            // Return the in-memory FCS declarations instead of reading from disk
            Some fcsDeclarations
        
        member _.GetRootModule(_fileName) = 
            // Extract root module from FCS declarations using Fable's helper
            try
                Fable.Transforms.FSharp2Fable.Compiler.getRootModule fcsDeclarations |> fst
            with ex ->
                failwith $"Failed to extract root module from FCS declarations: {ex.Message}"
        
        member _.TryGetEntity(_entityRef) = 
            // In-memory tests don't need full entity resolution from disk
            None
        
        member _.GetInlineExpr(_entityRef) = 
            // Inline expressions not used in in-memory tests
            None
        
        member _.AddWatchDependency(_file) = 
            // No file watching in tests
            ()
        
        member _.AddLog(msg, severity, ?range, ?fileName, ?tag) = 
            // Log compiler messages (particularly errors)
            if severity = Severity.Error then
                printfn "[Fable Error] %s" msg

// ──────────────────────────────────────────────────────────────────────────────
// Public API
// ──────────────────────────────────────────────────────────────────────────────

/// Create a Fable.Compiler mock from F# source code.
/// This is the main entry point for in-memory compilation testing.
///
/// Steps:
///   1. Parse and type-check F# source using FCS
///   2. Create a MockCompiler implementing Fable.Compiler interface
///   3. Return the compiler for use with Fable transformations
///
let createMockCompiler (code: string) : Fable.Compiler =
    match parseFSharpString code with
    | Ok fcsDeclarations ->
        MockCompiler(fcsDeclarations) :> Fable.Compiler
    | Error msg ->
        failwith $"Failed to parse F# source for mock compiler:\n{msg}"
