module TestNative.Helper.CompilerHelper

open System.IO
open FSharp.Compiler.CodeAnalysis
open FSharp.Compiler.Text
open Fable
open Fable.Transforms
open Fable.AST

/// Erstellt einen simplen Mock für das Fable.Compiler Interface
type MockCompiler (fsharpAst: FSharp.Compiler.Symbols.FSharpImplementationFileDeclaration list) =
    // Basis-Optionen für Fable
    let options : Fable.CompilerOptions = 
        {
          TypedArrays           = true
          ClampByteArrays       = false
          Language              = Fable.Language.WasmGc
          Define                = [] // string list
          DebugMode             = true
          OptimizeFSharpAst     = true
          Verbosity             = Verbosity.Verbose
          FileExtension         = ".fs"
          TriggeredByDependency = false
          NoReflection          = true  
        }

    interface Fable.Compiler with
        member _.Options = options
        member _.LibraryDir = "../../vendor/Fable/src/Fable.Core" // Pfad anpassen!
        member _.CurrentFile = "TestMemFile.fs"
        member _.GetImplementationFile(_fileName) = failwith "Not needed for single-file tests"
        member _.GetRootModule(_fileName) = 
            FSharp2Fable.Compiler.getRootModule fsharpAst |> fst
        member _.TryGetEntity(_entityRef) = failwith "Mock: GetEntity not implemented"
        member _.GetInlineExpr(_entityRef) = failwith "Mock: GetInlineExpr not implemented"
        member _.AddWatchDependency(_file) = ()
        member _.AddLog(msg, severity, ?range, ?fileName, ?tag) = 
            printfn "[Fable %A] %s" severity msg
        // member _.GetMemberContext() = Fable.Core.MemberContext.Empty // Falls von Fable verlangt
        // Füge hier ggf. weitere Interface-Member hinzu, falls eure Fable-Version diese zwingend fordert.

/// Nutzt den FSharp Compiler Service (FCS), um einen String zu parsen und zu prüfen
let parseFSharpString (code: string) =
    let checker = FSharpChecker.Create()
    
    // Für einen echten In-Memory Test müssen wir Dummy-Optionen erstellen
    // In einer echten Umgebung müsstest du hier Referenzen (FSharp.Core, mscorlib) hinzufügen.
    let tempFile = Path.ChangeExtension(Path.GetTempFileName(), ".fs")
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
        | Some implFile -> implFile.Declarations
        | None -> failwith "Type checking succeeded, aber keine ImplementationFile gefunden."
    | FSharpCheckFileAnswer.Aborted -> 
        failwithf "Type checking aborted: %A" parseResults.Errors

/// Die Hauptfunktion, die ihr in Tests aufruft
let createMockCompiler (code: string) =
    // 1. F# Code parsen und typisieren (FCS)
    let fcsDeclarations = parseFSharpString code
    
    // 2. Fable Mock Compiler instanziieren
    let com = MockCompiler(fcsDeclarations) :> Fable.Compiler
    
    com