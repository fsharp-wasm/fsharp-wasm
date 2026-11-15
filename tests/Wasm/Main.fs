/// Entry point — registers all Wasmecto suites for this test package.
/// A compiled module exports the functions of its last file, so this file exports `wasmecto_run`.
module WasmTests.Main

open Wasmecto.Runner

do
    register [
        // Unit
        WasmTests.Unit.LanguageAndCollectionsTests.LanguageAndCollectionsTests.tests
        WasmTests.TestsClosures.ClosureTests.tests

        // Integration
        WasmTests.Integration.CompilerPipelineSmokeTests.CompilerPipelineSmokeTests.tests
    ]

let wasmecto_run () : int = runRegistered ()
