/// Entry point — registers all Wasmecto suites for this test package.
/// `wasmecto_run` export is implemented in Wasmecto.Runner.
module WasmTests.Main

open Wasmecto.Runner

do
    register [
        // Unit
        WasmTests.Unit.Topics.LanguageAndCollectionsTests.LanguageAndCollectionsTests.tests
        WasmTests.TestsClosures.ClosureTests.tests

        // Integration
        WasmTests.Integration.Topics.CompilerPipelineSmokeTests.CompilerPipelineSmokeTests.tests
    ]
