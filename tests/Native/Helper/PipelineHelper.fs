namespace Fable.WasmGc.Tests

open Fable
// open Fable.AST
open WasmGc.Core.AST
// open WasmGc.Model // WExpr, WModule, WType, etc.
open WasmGc.Pipeline // For processFileIntoCtx [cite: 6361]
open Tests.WasmTestHelper

module PipelineHelper =
    /// Compiles a standalone F# source string into a WasmGC Module.
    /// This uses the actual patched compiler phases.
    let compileToWasm (source: string) : WModule =
        // 1. Mock the Fable compiler options (disable TypedArrays as discussed)
        let options = CompilerOptionsHelper.Make(typedArrays = false)
        
        // 2. Run FCS and Fable Frontend (simplified for brevity)
        // In your real project, use your existing 'NullCompiler' or 'TestCompiler'
        let fableFile = MockCompiler.Transform(source, options)
        
        // 3. Initialize the WasmGC Context [cite: 6351, 6358]
        let ctx = T.Ctx.Create(sourcePath = "Test.fs")
        
        // 4. Run the lowering phases [cite: 6349, 6361]
        Phases.processFileIntoCtx ctx fableFile true
        
        // 5. Emit the final WModule structure
        WasmGc.Emit.Emit.buildWModule ctx

    /// Helper to find a specific function by name in the compiled module
    let findFunc (name: string) (m: WModule) =
        m.Functions |> List.find (fun f -> f.Name.Contains name)

    /// Helper to check if a specific Wasm instruction exists in an expression tree
    let rec contains (predicate: WExpr -> bool) (expr: WExpr) : bool =
        if predicate expr then true
        else
            match expr with
            | WExpr.Let(_, value, body) -> contains predicate value || contains predicate body
            | WExpr.Loop(_, body, _) -> contains predicate body
            | WExpr.If(cond, thenB, elseB, _) -> contains predicate cond || contains predicate thenB || (elseB |> Option.exists (contains predicate))
            | WExpr.Call(_, args, _) -> args |> List.exists (contains predicate)
            | _ -> false // Add more recursive cases as needed for your AST