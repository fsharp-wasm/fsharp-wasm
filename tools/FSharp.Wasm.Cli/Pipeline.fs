/// WasmGC pipeline bridge — replaces Fable.Cli/Pipeline.fs.
/// The only file in this tool that knows about WasmGc.Pipeline.Core.
module Fable.Cli.Pipeline

open Fable
open Fable.Compiler.Util

module WasmGc = WasmGc.Pipeline.Core
    
let compileFile (com: Fable.Transforms.State.CompilerImpl) (cliArgs: CliArgs) pathResolver isSilent (outPath: string) =
    WasmGc.compileFile com cliArgs.ProjectFile isSilent outPath
