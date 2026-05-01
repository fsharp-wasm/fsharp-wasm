module Fable.Cli.Pipeline

open System
open Fable
open Fable.AST
// open Fable.Transforms
open Fable.Compiler.Util

module WasmGc = WasmGc.Pipeline.Core

// module WasmGc =
//     let compileFile (com: Compiler) (cliArgs: CliArgs) _pathResolver isSilent (outPath: string) =
//         WasmGc.Pipeline.Core.compileFile com cliArgs.ProjectFile isSilent outPath

// let compileFile (com: Compiler) (cliArgs: CliArgs) pathResolver isSilent (outPath: string) =
//     WasmGc.compileFile com cliArgs pathResolver isSilent outPath
    
let compileFile (com: Compiler) (cliArgs: CliArgs) pathResolver isSilent (outPath: string) =
    WasmGc.compileFile com cliArgs.ProjectFile isSilent outPath
