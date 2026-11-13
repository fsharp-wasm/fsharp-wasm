/// FCS parse+check helper and MockCompiler for in-memory tests.
/// MockCompiler implements Fable.Compiler (full interface) but uses
/// FSharp.Wasm.Core as LibraryDir — NOT vendor Fable.Core.
module TestNative.Helper.CompilerHelper

open System
open System.IO
open FSharp.Compiler.CodeAnalysis
open FSharp.Compiler.Text
open Fable
open Fable.Transforms
open Fable.AST

// ─────────────────────────────────────────────────────────────────
// FCS (F# Compiler Service) Integration
// ─────────────────────────────────────────────────────────────────

/// Parse and type-check F# source code using FCS (F# Compiler Service)
/// Returns the typed F# AST declarations on success
let parseFSharpString (code: string)
        : Result<FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list, string> =
    try
        let checker  = FSharpChecker.Create()
        let tempFile = Path.ChangeExtension(Path.GetTempFileName(), ".fs")
        
        try
            File.WriteAllText(tempFile, code)
            let projOpts, _ =
                checker.GetProjectOptionsFromScript(tempFile, SourceText.ofString code)
                |> Async.RunSynchronously

            let parseResults, checkResult =
                checker.ParseAndCheckFileInProject(tempFile, 1, SourceText.ofString code, projOpts)
                |> Async.RunSynchronously

            match checkResult with
            | FSharpCheckFileAnswer.Succeeded res ->
                match res.ImplementationFile with
                | Some impl -> Ok impl.Declarations
                | None      -> Error "Type-check succeeded but produced no ImplementationFile"
            | FSharpCheckFileAnswer.Aborted ->
                parseResults.Diagnostics
                |> Array.map (fun e -> e.Message)
                |> String.concat "\n"
                |> fun errs -> Error $"Type-check aborted:\n{errs}"
        finally
            try File.Delete(tempFile) with _ -> ()
    with ex -> Error $"FCS parse failed: {ex.Message}"

// ─────────────────────────────────────────────────────────────────
// MockCompiler Implementation
// ─────────────────────────────────────────────────────────────────
// TODO: do we still need the MockCompiler?

/// Mock Compiler that implements Fable.Compiler interface for in-memory testing.
/// This allows Fable transformations to run without shelling out to a CLI.
type MockCompiler (fcsDeclarations: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list) =

    // Our own library, not vendor Fable.Core
    let libDir =
        let candidates = [
            Path.Combine(__SOURCE_DIRECTORY__, "../../../core/FSharp.Wasm.Core")
            Path.Combine(__SOURCE_DIRECTORY__, "../../../../core/FSharp.Wasm.Core")
        ]
        candidates |> List.tryFind Directory.Exists |> Option.defaultValue "."

    // Standard Fable compiler options for WasmGC backend
    let options : CompilerOptions =
        { TypedArrays           = true
          ClampByteArrays       = false
          Language              = Language.WasmGc
          Define                = []
          DebugMode             = false
          OptimizeFSharpAst     = true
          Verbosity             = Verbosity.Normal
          FileExtension         = ".fs"
          TriggeredByDependency = false
          NoReflection          = true
          JsTemporal            = false }

    interface Fable.Compiler with
        member _.Options      = options
        member _.LibraryDir   = libDir
        member _.CurrentFile  = "InMemoryTest.fs"
        member _.OutputDir    = None
        member _.OutputType   = OutputType.Exe
        member _.ProjectFile  = ""
        member _.ProjectOptions = Unchecked.defaultof<_>
        member _.SourceFiles  = [| "InMemoryTest.fs" |]
        member _.Plugins      = { MemberDeclarationPlugins = Map.empty }
        member _.IsPrecompilingInlineFunction = false
        member this.WillPrecompileInlineFunction(_) = this :> Fable.Compiler
        member _.IncrementCounter() = 0
        member _.GetImplementationFile(_) = fcsDeclarations
        member _.GetRootModule(_) =
            try   FSharp2Fable.Compiler.getRootModule fcsDeclarations
            with ex -> failwith $"MockCompiler.GetRootModule: {ex.Message}"
        member _.TryGetEntity(_)   = None
        member _.GetInlineExpr(_)  =
            { Args        = []
              Body        = Fable.AST.Fable.Expr.Value(Fable.AST.Fable.ValueKind.Null Fable.AST.Fable.Type.Any, None)
              FileName    = ""; GenericArgs = []; ScopeIdents = Set.empty; IsFileLocal = false }
        member _.AddWatchDependency(_) = ()
        member _.AddLog(msg, sev, ?_r, ?_f, ?_t) =
            if sev = Severity.Error then eprintfn "[MockCompiler] %s" msg
        // ICompilerCore — no plugin dispatch in tests
        member _.TryGetPluginHelper() = None

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
    | Ok decls -> MockCompiler(decls) :> Fable.Compiler
    | Error msg -> failwith $"createMockCompiler: {msg}"

