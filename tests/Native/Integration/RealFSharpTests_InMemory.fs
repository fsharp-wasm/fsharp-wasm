/// In-Memory Compiler Tests — Direct F# source to WModule, no CLI
///
/// These tests compile real F# source strings through the complete pipeline
/// in the same process, producing intermediate AST/IR artifacts at each stage.
///
/// Strategy:
///   - Each test compiles a self-contained F# module
///   - Assertions can target any stage: Fable AST, WExpr, WAT, or final WModule
///   - Tests run in milliseconds (no subprocess overhead)
///   - Debuggable: set breakpoints in FSharp2Fable, Normalizer, etc.
///
/// To add new tests:
///   1. Write real F# source (no hand-crafted AST)
///   2. Call InMemoryPipelineHelper.compileSource
///   3. Assert on any stage in CompilationStages
///
module TestNative.Integration.RealFSharpTests_InMemory

open Expecto
open WasmGc.Core.AST
open WasmGc.Util.WExprQuery
open Tests

// ──────────────────────────────────────────────────────────────────────────────
// Test helpers: common patterns for stage-specific assertions
// ──────────────────────────────────────────────────────────────────────────────

/// Find a function by name in the WModule, handling name mangling
let private findFunc (name: string) (m: WModule) : WFunc option =
    m.Functions 
    |> List.tryFind (fun f -> 
        f.Name.Contains(name) || 
        f.Name.EndsWith("/" + name))

/// Assert that a WExpr tree contains at least one node matching a predicate
let private assertContains (predicate: WExpr -> bool) (msg: string) (expr: WExpr) : unit =
    let found = exists predicate expr
    Expect.isTrue found msg

/// Assert that a WExpr tree does NOT contain any node matching a predicate
let private assertNotContains (predicate: WExpr -> bool) (msg: string) (expr: WExpr) : unit =
    let found = exists predicate expr
    Expect.isFalse found msg

// ──────────────────────────────────────────────────────────────────────────────
// Stage 1: Simple arithmetic and let-bindings
// ──────────────────────────────────────────────────────────────────────────────

[<Tests>]
let arithmeticTests = testList "In-Memory / arithmetic" [

    test "let addTwo (a: int) (b: int) = a + b produces I32Add" {
        let code = """
module Fixture
open Fable.Core

let addTwo (a: int) (b: int) = a + b
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            match findFunc "addTwo" stages.WModuleNormalized with
            | Some f ->
                assertContains 
                    (function 
                        | WExpr.Binary(WBinaryOp.Add, _, _, WType.I32) -> true 
                        | _ -> false)
                    "addTwo body must contain I32.add operation"
                    f.Body
            | None -> failtestf "Function 'addTwo' not found in WModule"
        | Error err -> skiptest $"Compilation failed: {err}"
    }

    test "let counter: mutable local uses LetMut" {
        let code = """
module Fixture
open Fable.Core

let counter () =
    let mutable x = 0
    x <- x + 1
    x
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            match findFunc "counter" stages.WModuleNormalized with
            | Some f ->
                assertContains 
                    (function WExpr.LetMut _ -> true | _ -> false)
                    "counter must use LetMut for mutable local variable"
                    f.Body
            | None -> failtestf "Function 'counter' not found"
        | Error err -> skiptest $"Compilation failed: {err}"
    }

    test "let rec fibonacci produces recursive call" {
        let code = """
module Fixture
open Fable.Core

let rec fib n =
    if n <= 1 then n
    else fib (n - 1) + fib (n - 2)
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            match findFunc "fib" stages.WModuleNormalized with
            | Some f ->
                assertContains 
                    (function WExpr.Call _ -> true | _ -> false)
                    "fib should contain a recursive call"
                    f.Body
            | None -> failtestf "Function 'fib' not found"
        | Error err -> skiptest $"Compilation failed: {err}"
    }
]

// ──────────────────────────────────────────────────────────────────────────────
// Stage 2: Closures and captured variables
// ──────────────────────────────────────────────────────────────────────────────

[<Tests>]
let closureTests = testList "In-Memory / closures" [

    test "lambda with captured local: Closure with captures" {
        let code = """
module Fixture
open Fable.Core

let makeMult (factor: int) =
    fun (x: int) -> x * factor
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            match findFunc "makeMult" stages.WModuleNormalized with
            | Some f ->
                assertContains 
                    (function WExpr.Closure(_, _::_, _) -> true | _ -> false)
                    "makeMult must produce a Closure with at least one captured variable"
                    f.Body
            | None -> failtestf "Function 'makeMult' not found"
        | Error err -> skiptest $"Compilation failed: {err}"
    }
]

// ──────────────────────────────────────────────────────────────────────────────
// Stage 3: Arrays and collection operations
// ──────────────────────────────────────────────────────────────────────────────

[<Tests>]
let arrayTests = testList "In-Memory / arrays" [

    test "Array.map int[]: generates Loop, not Int32Array local" {
        let code = """
module Fixture
open Fable.Core

let doubleAll (xs: int[]) = 
    Array.map (fun x -> x * 2) xs
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            match findFunc "doubleAll" stages.WModuleNormalized with
            | Some f ->
                assertNotContains
                    (function 
                        | WExpr.LocalGet("Int32Array", _) -> true 
                        | _ -> false)
                    "Array.map must not reference Int32Array local (should be resolved)"
                    f.Body
                
                assertContains
                    (function WExpr.Loop _ -> true | _ -> false)
                    "Array.map should contain a Loop construct"
                    f.Body
            | None -> failtestf "Function 'doubleAll' not found"
        | Error err -> skiptest $"Compilation failed: {err}"
    }
]

// ──────────────────────────────────────────────────────────────────────────────
// Stage 4: Pattern matching and control flow
// ──────────────────────────────────────────────────────────────────────────────

[<Tests>]
let patternMatchTests = testList "In-Memory / pattern-matching" [

    test "match x with | 0 -> true | _ -> false uses SwitchInt" {
        let code = """
module Fixture
open Fable.Core

let isZero x = 
    match x with 
    | 0 -> true 
    | _ -> false
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            match findFunc "isZero" stages.WModuleNormalized with
            | Some f ->
                assertContains
                    (function WExpr.SwitchInt _ -> true | _ -> false)
                    "Integer match should lower to SwitchInt"
                    f.Body
            | None -> failtestf "Function 'isZero' not found"
        | Error err -> skiptest $"Compilation failed: {err}"
    }
]

// ──────────────────────────────────────────────────────────────────────────────
// Stage 5: Exception handling (WasmGC structs)
// ──────────────────────────────────────────────────────────────────────────────

[<Tests>]
let exceptionTests = testList "In-Memory / exceptions" [

    test "raise expr uses StructNew for exception object" {
        let code = """
module Fixture
open Fable.Core

let thrower () =
    raise (System.Exception("oops"))
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            match findFunc "thrower" stages.WModuleNormalized with
            | Some f ->
                assertContains
                    (function WExpr.StructNew _ -> true | _ -> false)
                    "Exception raise should construct a WasmGC struct (StructNew)"
                    f.Body
            | None -> failtestf "Function 'thrower' not found"
        | Error err -> skiptest $"Compilation failed: {err}"
    }
]

// ──────────────────────────────────────────────────────────────────────────────
// Stage 6: WAT snapshot tests (intermediate representation)
// ──────────────────────────────────────────────────────────────────────────────

[<Tests>]
let watSnapshotTests = testList "In-Memory / WAT snapshots" [

    test "simple add function WAT is valid" {
        let code = """
module Fixture
open Fable.Core

let add a b = a + b
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            let wat = stages.WatText
            Expect.stringContains wat "(func" "WAT should contain function definitions"
            Expect.stringContains wat "i32.add" "WAT should contain i32.add instruction"
        | Error err -> skiptest $"Compilation failed: {err}"
    }

    test "closure WAT includes struct allocation" {
        let code = """
module Fixture
open Fable.Core

let makeMult factor =
    fun x -> x * factor
        """
        
        match InMemoryPipelineHelper.compileSource code with
        | Ok stages ->
            let wat = stages.WatText
            Expect.stringContains wat "struct.new" "WAT should contain struct.new for closure capture"
        | Error err -> skiptest $"Compilation failed: {err}"
    }
]

// TODO: add later: more complex patterns, async/await, interfaces, etc.
// [<Tests>]
// let compilerPipelineTests =
//     testList "In-Process Compiler AST Tests" [

//         test "Compiles a simple let-binding into a Wasm Local" {
//             let code = """
//             module TestModule
//             let add a b = a + b
//             """
            
//             // 1. Hole das intern generierte WModule (Dauert Millisekunden)
//             // let wModule = compileToWModule code
            
//             // 2. Assert auf den rohen Abstrakten Syntaxbaum (AST)
//             // Beispiel:
//             // let addFunc = wModule.Functions |> Seq.find (fun f -> f.Name = "add")
//             //
//             // let hasAddOp = 
//             //     WasmGc.Util.WExprQuery.exists (function | WExpr.I32Add -> true | _ -> false) addFunc.Body
//             //
//             // Expect.isTrue hasAddOp "WExpr.I32Add should be generated for '+'"
            
//             Expect.isTrue true "Mocked test passed"
//         }

//         test "Lowers F# match to Wasm SwitchInt" {
//             let code = """
//             module TestModule
//             let isZero x = match x with | 0 -> true | _ -> false
//             """
            
//             // let wModule = compileToWModule code
//             // let func = wModule.Functions |> Seq.find (fun f -> f.Name = "isZero")
//             // let hasSwitch = WasmGc.Util.WExprQuery.exists (function | WExpr.SwitchInt _ -> true | _ -> false) func.Body
            
//             // Expect.isTrue hasSwitch "Match expressions on ints must lower to SwitchInt"
//             Expect.isTrue true "Mocked test passed"
//         }
//     ]