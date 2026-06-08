/// Aggregating runner for all QuickTest domain modules.
module QuickTestWasmGc.Runner

open QuickTestWasmGc.Preamble
open QuickTestWasmGc.TestsArray
open QuickTestWasmGc.TestsBitwise
open QuickTestWasmGc.TestsClosures
open QuickTestWasmGc.TestsDU
open QuickTestWasmGc.TestsExceptions
open QuickTestWasmGc.TestsInterop
open QuickTestWasmGc.TestsList
open QuickTestWasmGc.TestsMap
open QuickTestWasmGc.TestsMath
open QuickTestWasmGc.TestsOption
open QuickTestWasmGc.TestsPrimitives
open QuickTestWasmGc.TestsPrintf
open QuickTestWasmGc.TestsResult
open QuickTestWasmGc.TestsSeq
open QuickTestWasmGc.TestsSet
open QuickTestWasmGc.TestsStringBuilder
open QuickTestWasmGc.TestsStrings
open Fable.Core

let runAllTests (check: string -> (unit -> unit) -> unit) =
    runArrayTests check
    runBitwiseTests check
    runClosuresTests check
    runDUTests check
    runExceptionsTests check
    runInteropTests check
    runListTests check
    runMapTests check
    runMathTests check
    runOptionTests check
    runPrimitivesTests check
    runPrintfTests check
    runResultTests check
    runSeqTests check
    runSetTests check
    runStringBuilderTests check
    runStringsTests check

[<EntryPoint>]
let main _ =
    let mutable passed = 0
    let mutable failed = 0
    let check name (f: unit -> unit) =
        try f (); passed <- passed + 1
        with ex ->
            failed <- failed + 1
            ()  // skip logging for now
    runAllTests check
    ()  // skip logging for now
    if failed > 0 then 1 else 0
