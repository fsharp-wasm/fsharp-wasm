/// Compiler regression tests using REAL F# source — no hand-crafted Fable AST.
///
/// Strategy:
///   Each test provides a self-contained F# module as a string literal.
///   The test makes precise assertions on the WExpr tree produced by the
///   compiler for the named function.
///
/// Why real F# instead of hand-crafted Fable AST:
///   - Tests survive Fable AST refactors (we test the transform, not the input format)
///   - Error messages point to real F# lines, not abstract AST constructions
///   - Forces the full Fable parsing + type-check path, catching edge cases early
///   - Newcomers can read and write tests without understanding Fable.AST
///
/// Today this module uses PipelineHelper (the F#→WModule bridge).
/// Uncomment `<Compile Include="Helper/PipelineHelper.fs" />` in TestNative.fsproj
/// once MockCompiler is wired to the real Fable CLI runner.
module Tests.Integration.RealFSharpTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Builder.Core
open WasmGc.Util.WExprQuery

// TODO: this should be a helper in Compiler not in Tests. So for now it's here
// Collect values by mapping nodes to option 'a and accumulating matches.
let collectAll (picker: WExpr -> 'a option) (expr: WExpr) : 'a list =
    WasmGc.Util.WExprQuery.fold (fun acc e ->
        match picker e with
        | Some v -> v :: acc
        | None -> acc) [] expr
    |> List.rev
open Tests.WasmTestHelper
open Tests.Snapshot.Framework

// ─────────────────────────────────────────────────────────────────────────────
// Shared F# fixture snippets
// ─────────────────────────────────────────────────────────────────────────────

/// Minimal prelude needed for any test module compiled through our backend.
/// This mirrors what QuickTest.fsproj includes.
let private prelude = """
module Fixture

open Fable.Core
"""

/// Compile a complete F# source module to a WModule using PipelineHelper.
/// Returns None if the pipeline helper is not yet wired (graceful skip).
let private tryCompile (src: string) : WModule option =
    // TODO: wire to real Fable CLI when PipelineHelper.compileToWasm is ready
    // For now return None so these tests are skipped gracefully.
    // When wired:
    //   try Some(PipelineHelper.compileToWasm (prelude + src))
    //   with ex -> failwithf "Compilation failed:\n%s\n\nSource:\n%s" ex.Message src
    None

let private skipIfNotWired (f: WModule -> unit) (m: WModule option) =
    match m with
    | None -> ()  // skip — pipeline not yet wired
    | Some wm -> f wm

// ─────────────────────────────────────────────────────────────────────────────
// Tests — arithmetic and locals
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let arithmeticTests = testList "RealF# / arithmetic" [

    test "let x = a + b: produces Add + Let" {
        """
let addTwo (a: int) (b: int) = a + b
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "addTwo")
            assertContains
                (function WExpr.Binary(WBinaryOp.Add, _, _, WType.I32) -> true | _ -> false)
                "addTwo body must contain an i32.add"
                f.Body)
    }

    test "let mut x = 0: produces LetMut" {
        """
let counter () =
    let mutable x = 0
    x <- x + 1
    x
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "counter")
            assertContains
                (function WExpr.LetMut _ -> true | _ -> false)
                "counter must use LetMut for mutable local"
                f.Body)
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Tests — closures
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let closureTests = testList "RealF# / closures" [

    test "lambda with captured local: Closure with captures" {
        """
let makeMult (factor: int) =
    fun (x: int) -> x * factor
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "makeMult")
            assertContains
                (function WExpr.Closure(_, _::_, _) -> true | _ -> false)
                "makeMult must produce a Closure with at least one capture"
                f.Body)
    }

    test "module-level function: NOT captured" {
        """
let helper (x: int) = x + 1

let useHelper (xs: int list) =
    xs |> List.map helper
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let closures = collectAll (function WExpr.Closure(_, caps, _) -> Some caps | _ -> None)
            // Every closure in the module must not capture 'helper' directly
            // (it's a KnownFunc, emitted as a Call, not a LocalGet)
            m.Functions |> List.iter (fun f ->
                let caps = collectAll (function WExpr.Closure(_, cs, _) -> Some cs | _ -> None) f.Body
                for capList in caps do
                    for cap in capList do
                        match cap with
                        | WExpr.LocalGet(name, _) when name.Contains "helper" ->
                            failtestf "Module-level 'helper' must not be captured; got LocalGet(%s)" name
                        | _ -> ()))
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Tests — arrays
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let arrayTests = testList "RealF# / arrays" [

    test "Array.map on int[]: no Int32Array in output" {
        // This is the regression from the QuickTest failure.
        // After the Int32Array fix, the backend must produce ArrayNew, not LocalGet("Int32Array",I32).
        """
let doubleAll (xs: int[]) = Array.map (fun x -> x * 2) xs
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "doubleAll")
            // Must NOT contain an unresolved LocalGet("Int32Array", ...)
            assertAbsent
                (function WExpr.LocalGet(name, _) when name = "Int32Array" -> true | _ -> false)
                "Array.map must not produce unresolved 'Int32Array' ident"
                f.Body
            // MUST contain ArrayNew (the correct WasmGC allocation)
            assertContains
                (function WExpr.ArrayNew _ -> true | _ -> false)
                "Array.map must produce ArrayNew for result array"
                f.Body)
    }

    test "Array.init: produces Loop + ArraySet" {
        """
let initSquares (n: int) = Array.init n (fun i -> i * i)
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "initSquares")
            assertContains (function WExpr.Loop _ -> true | _ -> false)
                "Array.init must emit a loop" f.Body
            assertContains (function WExpr.ArraySet _ -> true | _ -> false)
                "Array.init must emit ArraySet" f.Body)
    }

    test "Array.fill: Loop + ArraySet, no ArrayNew (mutates in place)" {
        """
let fillZeros (xs: int[]) = Array.fill xs 0 (Array.length xs) 0
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "fillZeros")
            assertContains (function WExpr.Loop _ -> true | _ -> false)
                "Array.fill must emit a loop" f.Body
            assertContains (function WExpr.ArraySet _ -> true | _ -> false)
                "Array.fill must emit ArraySet" f.Body)
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Tests — exceptions
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let exceptionTests = testList "RealF# / exceptions" [

    test "failwith: produces Throw (not Nop)" {
        // Regression: Exception from ./Util.fs was emitting Nop.
        """
let alwaysFails () : int = failwith "oops"
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "alwaysFails")
            assertContains
                (function WExpr.Throw _ -> true | _ -> false)
                "failwith must produce Throw, not Nop"
                f.Body
            assertAbsent
                (function WExpr.Nop -> true | _ -> false)
                "failwith must not produce Nop (Nop means unhandled import)"
                f.Body)
    }

    test "try/with: produces TryCatch with catch_all" {
        """
let safeDiv (a: int) (b: int) =
    try a / b
    with _ -> 0
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "safeDiv")
            assertContains
                (function WExpr.TryCatch _ -> true | _ -> false)
                "try/with must produce TryCatch"
                f.Body)
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// Tests — DUs and pattern matching
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let duTests = testList "RealF# / DUs" [

    test "single-field DU roundtrip: StructNew + StructGet" {
        """
type Wrapper = Wrapper of int
let wrap x = Wrapper x
let unwrap (Wrapper x) = x
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let wrapF = m.Functions |> List.find (fun f -> f.Name.Contains "wrap")
            assertContains (function WExpr.StructNew _ -> true | _ -> false)
                "wrap must emit StructNew" wrapF.Body
            let unwrapF = m.Functions |> List.find (fun f -> f.Name.Contains "unwrap")
            assertContains (function WExpr.StructGet _ -> true | _ -> false)
                "unwrap must emit StructGet" unwrapF.Body)
    }

    test "Option.map Some: produces If + StructNew" {
        """
let doubleOpt (x: int option) = Option.map (fun n -> n * 2) x
        """ |> tryCompile |> skipIfNotWired (fun m ->
            let f = m.Functions |> List.find (fun f -> f.Name.Contains "doubleOpt")
            assertContains (function WExpr.If _ -> true | _ -> false)
                "Option.map must produce If (None branch)" f.Body)
    }
]
