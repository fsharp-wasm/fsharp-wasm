/// Snapshot / golden test framework for the WasmGC compiler.
///
/// Philosophy:
///   - Tests are written as REAL F# source strings (no hand-crafted Fable AST)
///   - The full compilation pipeline runs: F# string → Fable AST → WExpr → WAT text
///   - Outputs are compared to committed snapshot files in tests/Native/Snapshots/
///   - On first run (snapshot missing): write the snapshot; on subsequent runs: assert equality
///
/// Benefits over hand-crafted AST tests:
///   - Tests survive Fable AST refactors (we test behavior not AST shape)
///   - WAT snapshots serve as regression detection AND readable documentation
///   - The full pipeline is exercised (scope analysis, normalizer, lower, validator)
module Tests.Snapshot.Framework

open System
open System.IO
open Expecto
open WasmGc.Core.AST
open WasmGc.Emit

module Wat = WasmGc.Emit.Wat

open Tests.WasmTestHelper

// ─────────────────────────────────────────────────────────────────────────────
// Configuration
// ─────────────────────────────────────────────────────────────────────────────

let private snapshotDir =
    let here = Path.GetDirectoryName(Reflection.Assembly.GetExecutingAssembly().Location)
    // Walk up to tests/Native/Snapshots/
    let root = DirectoryInfo(here).Parent.Parent.Parent.Parent.FullName
    Path.Combine(root, "tests", "Native", "Snapshots")

let private updateSnapshots =
    Environment.GetEnvironmentVariable("UPDATE_SNAPSHOTS") = "1"

// ─────────────────────────────────────────────────────────────────────────────
// Core snapshot assertion
// ─────────────────────────────────────────────────────────────────────────────

/// Assert that `actual` matches the stored snapshot for `name`.
/// If UPDATE_SNAPSHOTS=1, writes the snapshot instead of comparing.
let assertSnapshot (name: string) (actual: string) =
    let path = Path.Combine(snapshotDir, name + ".snap")
    Directory.CreateDirectory(snapshotDir) |> ignore
    if updateSnapshots || not (File.Exists path) then
        File.WriteAllText(path, actual)
        printfn $"  [snapshot] Written: {name}.snap"
    else
        let expected = File.ReadAllText path
        if actual <> expected then
            // Show a diff-like view
            let aLines = actual.Split('\n')
            let eLines = expected.Split('\n')
            let diffs =
                Array.zip
                    (Array.append aLines (Array.create (max 0 (eLines.Length - aLines.Length)) ""))
                    (Array.append eLines (Array.create (max 0 (aLines.Length - eLines.Length)) ""))
                |> Array.mapi (fun i (a, e) -> i + 1, a, e)
                |> Array.filter (fun (_, a, e) -> a <> e)
                |> Array.truncate 20
            let diffMsg =
                diffs |> Array.map (fun (n, a, e) ->
                    $"  line {n}:\n    expected: {e}\n    actual:   {a}")
                |> String.concat "\n"
            failwithf "Snapshot mismatch for '%s':\n%s\n\nRun with UPDATE_SNAPSHOTS=1 to update." name diffMsg

// ─────────────────────────────────────────────────────────────────────────────
// WAT emission helper
// ─────────────────────────────────────────────────────────────────────────────

/// Compile a WModule to WAT text (normalized for snapshot stability).
let moduleToWat (m: WModule) : string =
    // Use the existing WAT emitter; strip addresses/offsets for stability

    // TODO: couldn't find Wat.emitModule we have to streamline the API here
    // let raw = Wat.emitModule m
    let raw = Wat.moduleToWat m
    // Normalize: remove any absolute paths, runtime timestamps
    raw.Replace("\r\n", "\n").TrimEnd()

/// Extract just the WAT for a single named function (for focused snapshots).
let funcToWat (funcName: string) (m: WModule) : string =
    match m.Functions |> List.tryFind (fun f -> f.Name = funcName || f.Name.EndsWith("/" + funcName)) with
    | None -> failwithf "Function '%s' not found in module" funcName
    | Some func ->
        // Emit just this function's body as WAT for readability
        let singleModule = { m with
                                Functions = [func]
                                Exports = []
                                Imports = [] }
        moduleToWat singleModule

// ─────────────────────────────────────────────────────────────────────────────
// Pipeline runner (for when PipelineHelper is wired up)
// ─────────────────────────────────────────────────────────────────────────────

/// Placeholder until PipelineHelper.compileToWasm is fully wired.
/// Today: uses makeTestCtx + transformExpr for focused IR snapshots.
/// Tomorrow: will use the full Fable→WasmGC pipeline.
[<RequireQualifiedAccess>]
type CompileResult =
    | WExprTree  of WExpr
    | WModuleOut of WModule
    | WatText    of string
    | Error      of string

// ─────────────────────────────────────────────────────────────────────────────
// Snapshot test builders
// ─────────────────────────────────────────────────────────────────────────────

/// Create a snapshot test from a WExpr tree (most useful today).
/// Produces a canonical IR dump as the snapshot content.
let wexprSnapshot (name: string) (expr: WExpr) =
    testCase name <| fun () ->
        let wat = WasmGc.Util.IrDump.dumpExpr 0 expr
        assertSnapshot name wat

/// Create a snapshot test from a WModule.
let watSnapshot (name: string) (m: WModule) =
    testCase name <| fun () ->
        let wat = moduleToWat m
        assertSnapshot name wat

/// Focused function snapshot — only the named function's WAT.
let funcSnapshot (testName: string) (funcName: string) (m: WModule) =
    testCase testName <| fun () ->
        let wat = funcToWat funcName m
        assertSnapshot testName wat

// ─────────────────────────────────────────────────────────────────────────────
// Test helpers for asserting WExpr properties
// ─────────────────────────────────────────────────────────────────────────────

open WasmGc.Util.WExprQuery

/// Assert that `expr` contains at least one node matching `pred`.
let assertContains (pred: WExpr -> bool) (msg: string) (expr: WExpr) =
    let found = WExprQuery.exists pred expr
    Expect.isTrue found msg

/// Assert that `expr` contains no node matching `pred`.
let assertAbsent (pred: WExpr -> bool) (msg: string) (expr: WExpr) =
    let found = WExprQuery.exists pred expr
    Expect.isFalse found msg

/// Assert exact node count matching `pred`.
let assertCount (pred: WExpr -> bool) (expected: int) (msg: string) (expr: WExpr) =
    let n = WExprQuery.collect (fun e -> if (pred e) then Some e else None) expr |> List.length
    Expect.equal n expected msg
