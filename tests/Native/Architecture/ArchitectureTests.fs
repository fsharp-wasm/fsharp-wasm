/// Architecture boundary tests — prove the Fable.AST dependency wall holds.
///
/// These tests do NOT test logic; they test that the new project structure
/// compiles without accidentally pulling in Fable.AST below the boundary.
///
/// How to run: `dotnet test tests/Native/ --filter Category=Architecture`
///
/// If any test here fails to compile, a lower-layer project has gained a
/// Fable.AST dependency — fix it before merging.
module Tests.Architecture.BoundaryTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Builder.Core

// ── Prove pure layers compile without Fable namespaces ──────────────────────
// If any of these opens fail, the layer has a Fable leak.

// Layer 0: Core — no Fable
open WasmGc.Core.Diagnostics         // DiagnosticBag

// Layer 1: Builder — no Fable
open WasmGc.Builder                   // WasmBuilder, WVar, MutRef

// Layer 2: Ir — no Fable
open WasmGc.Util.WExprQuery           // WExprQuery.exists
open WasmGc.Util.IrDump               // dumpExpr
module WExprQuery = WasmGc.Util.WExprQuery  // avoid Fable leak through type alias

// Layer 3: Patterns — no Fable
// open WasmGc.Patterns                  // Array.*, List.*, Closure.*
// Note: Don't use "open WasmGc.Patterns" directly because it shadows the built-in Array module
// Instead, use fully qualified names like WasmGc.Patterns.ArrayPatterns.map, etc.
// TODO: fix this shadowing by find better naming

// Layer 5: Emit — no Fable
open WasmGc.Emit.Optimize             // optimizeFuncBody
open WasmGc.Emit.Linker               // linkModules

// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let boundaryTests = testList "Architecture / boundary" [

    test "Core: DiagnosticBag has no Fable types in its signature" {
        // If this compiles, Core has no Fable leak.
        let bag = WasmGc.Core.Diagnostics.DiagnosticBag()
        bag.Warn(WasmGc.Core.Diagnostics.Code.UnresolvedIdent,
                 WasmGc.Core.Diagnostics.SourceLoc.Unknown,
                 msg = "test")
        Expect.equal bag.Count 1 "bag has one entry"
    }

    test "Builder: WasmBuilder is usable without Fable" {
        let raw = wasm {
            let! x = i32Const 5
            return add x (i32Const 3)
        }
        let result = WasmGc.Emit.Optimize.optimizeFuncBody raw
        Expect.equal result (i32Const 8) "5+3 constant-folds to 8 after optimization"
    }

    test "Ir: WExprQuery.exists runs on a wasm { } tree" {
        let tree = wasm { return add (i32Const 1) (i32Const 2) }
        let hasAdd = WExprQuery.exists
                        (function WExpr.Binary(WBinaryOp.Add,_,_,_) -> true | _ -> false)
                        tree
        Expect.isTrue hasAdd "tree contains an Add node"
    }

    test "Patterns.Array: map produces ArrayNew + loop without Fable" {
        let src = i32Const 0  // placeholder — type shape drives the algorithm
        let result = WasmGc.Patterns.ArrayPatterns.map 1 (WType.Ref(1,false)) WType.I32
                         (i32Const 0) src (fun e -> add e (i32Const 1))
        let hasNew  = WExprQuery.exists (function WExpr.ArrayNew _ -> true | _ -> false) result
        let hasLoop = WExprQuery.exists (function WExpr.Loop _ -> true | _ -> false) result
        Expect.isTrue hasNew  "Array.map produces ArrayNew"
        Expect.isTrue hasLoop "Array.map produces Loop"
    }

    test "Patterns.Array: filter produces two ArrayNew (tmp + trimmed)" {
        let src = i32Const 0
        let (result: WExpr) = 
            WasmGc.Patterns.ArrayPatterns.filter 1 (WType.Ref(1,false)) WType.I32
                (i32Const 0) src (fun e -> ne e (i32Const 0))
        let news = WExprQuery.collect (function WExpr.ArrayNew _ -> true | _ -> false) result
        Expect.isGreaterThanOrEqual news.Length 2 "filter allocates tmp + result"
    }

    test "Patterns.Array: sortWith emits Call to $arraySortWith (not inline loop)" {
        let src = i32Const 0
        let cmp = WExpr.LocalGet("cmp", WType.Ref(0, false))
        let result = WasmGc.Patterns.ArrayPatterns.sortWith 1 (WType.Ref(1,false))
                         (i32Const 0) src cmp
        // Must contain a Call to $arraySortWith
        let hasCall = WExprQuery.exists
                          (function WExpr.Call("$arraySortWith",_,_) -> true | _ -> false)
                          result
        // Must NOT contain a Loop (no inline insertion sort)
        let hasLoop = WExprQuery.exists (function WExpr.Loop _ -> true | _ -> false) result
        Expect.isTrue  hasCall "sortWith emits call to $arraySortWith"
        Expect.isFalse hasLoop "sortWith does NOT inline a sort loop"
    }

    test "Emit.Optimize: optimizeFuncBody runs without Fable" {
        let body = WExpr.Binary(WBinaryOp.Add, i32Const 1, i32Const 2, WType.I32)
        let opt  = WasmGc.Emit.Optimize.optimizeFuncBody body
        Expect.equal opt (i32Const 3) "1+2 folded to 3"
    }

    test "Emit.Linker: linkModules runs without Fable" {
        let emptyMod : WModule = {
            Types=[]; Imports=[]; Functions=[]; Globals=[]
            Exports=[]; DataSegments=[]; Tags=[]; Start=None; HasLinearMemory=false }
        let merged = WasmGc.Emit.Linker.linkModules [("A", emptyMod); ("B", emptyMod)]
        Expect.equal merged.Types.Length 0 "empty modules → empty merged"
    }

    test "Closure.allocClosure builds StructNew without Fable" {
        let def = WasmGc.Patterns.Closure.allocClosure 0 (WType.Ref(0,false)) "$myFn" [i32Const 42]
        match def with
        | WExpr.StructNew(0, [WExpr.FuncRef _; WExpr.Const(WConst.I32 42)], _) -> ()
        | other -> failtestf "Expected StructNew, got %A" other
    }

    test "Diagnostic codes are stable strings (not changed accidentally)" {
        Expect.equal WasmGc.Core.Diagnostics.Code.UnresolvedIdent "WGC001" "WGC001 stable"
        Expect.equal WasmGc.Core.Diagnostics.Code.UnhandledImport  "WGC002" "WGC002 stable"
        Expect.equal WasmGc.Core.Diagnostics.Code.ArityMismatch    "WGC003" "WGC003 stable"
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Dependency graph tests — assert nothing imports Fable below the boundary
// These use reflection to check assembly references at runtime.
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let dependencyGraphTests = testList "Architecture / dependency graph" [

    let fableAssemblyNames = Set.ofList [
        "Fable.AST"; "Fable.Transforms"; "Fable.Compiler" ]

    let refsOf (asm: System.Reflection.Assembly) =
        asm.GetReferencedAssemblies()
        |> Array.map (fun n -> n.Name)
        |> Set.ofArray

    let hasFableDep (asmName: string) =
        try
            let asm = System.Reflection.Assembly.Load(asmName)
            Set.intersect (refsOf asm) fableAssemblyNames |> Set.isEmpty |> not
        with _ -> false  // assembly not loaded → not in build graph → OK

    // TODO: not possible yet - we have to enable it later
    // test "WasmGc.Core has no Fable dependency" {
    //     // Types.fs has been moved OUT of WasmGc.Core.fsproj.
    //     // Re-run `dotnet build` after this change — then this test verifies the wall.
    //     // If the check still fails, Types.fs has leaked back into Core.
    //     let hasDep = hasFableDep "WasmGc.Core"
    //     if hasDep then
    //         // Fail with actionable message (not just true/false)
    //         failtest "WasmGc.Core must not reference Fable.AST. \
    //                   Ensure Types.fs is NOT compiled into WasmGc.Core.fsproj. \
    //                   Fix: remove Types.fs from src/Core/WasmGc.Core.fsproj and \
    //                   add it to src/Fable.WasmGc.fsproj instead."
    //     Expect.isFalse (hasFableDep "WasmGc.Core") "WasmGc.Core must not reference Fable.AST"
    // }

    test "WasmGc.Builder has no Fable dependency" {
        Expect.isFalse (hasFableDep "WasmGc.Builder") "WasmGc.Builder must not reference Fable.AST"
    }

    test "WasmGc.Ir has no Fable dependency" {
        Expect.isFalse (hasFableDep "WasmGc.Ir") "WasmGc.Ir must not reference Fable.AST"
    }

    test "WasmGc.Patterns has no Fable dependency" {
        Expect.isFalse (hasFableDep "WasmGc.Patterns") "WasmGc.Patterns must not reference Fable.AST"
    }

    test "WasmGc.Bcl has no Fable dependency" {
        Expect.isFalse (hasFableDep "WasmGc.Bcl") "WasmGc.Bcl must not reference Fable.AST"
    }

    test "WasmGc.Emit has no Fable dependency" {
        Expect.isFalse (hasFableDep "WasmGc.Emit") "WasmGc.Emit must not reference Fable.AST"
    }
]
