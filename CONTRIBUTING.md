# Contributing to the compiler

Thank you for looking. The organisation-wide guide is [CONTRIBUTING of fsharp-wasm/.github](https://github.com/fsharp-wasm/.github/blob/develop/CONTRIBUTING.md) (ways to help, how a change
travels, the licence); this page is what is particular to the compiler: how to build it, how to test it, where things live. How we work, in full, is [AGENTS.md](AGENTS.md).

## Code of Conduct

[Contributor Covenant 2.1](https://github.com/fsharp-wasm/.github/blob/develop/CODE_OF_CONDUCT.md). By taking part you agree to keep it welcoming and free of harassment.

## The best first contribution: a program that does not compile

An issue with the F# source of a program that fails (or runs wrongly) is the most useful report we get: it becomes a test. [docs/STATUS.md](docs/STATUS.md) lists the known gaps, each with its
minimal program; any of them is a good first task. A fix always comes with a test that fails without it.

## Prerequisites

| Tool | Version | For |
|---|---|---|
| .NET SDK | 10.0 (`global.json`); **10.0.303** to build the patched F# compiler (its own `global.json` pins that band) | the compiler and the CLI |
| Node.js | 22+ | the test harnesses |
| [wasm-tools](https://github.com/bytecodealliance/wasm-tools) | 1.263.0 (the version CI uses) | validating the modules |

Only want to compile programs, not change the compiler? Take a release binary (README, section 0) and skip everything below.

## Build

```bash
git clone https://github.com/fsharp-wasm/fsharp-wasm.git && cd fsharp-wasm
git submodule update --init --depth 1 vendor/Fable vendor/fsharp core

# the patched F# compiler the backend is built on (once per vendor/fsharp commit; several minutes)
(cd vendor/fsharp && mkdir -p artifacts && ./build/build.sh -c Release)
export FSHARP_COMPILER="$PWD/vendor/fsharp/artifacts/bin/fsc/Release/net10.0/fsc.dll"

dotnet build src/WasmGc.fsproj -c Release
dotnet build tools/FSharp.Wasm.Cli/FSharp.Wasm.Cli.fsproj -c Release
```

Compile a program: `dotnet tools/FSharp.Wasm.Cli/bin/Release/net10.0/fsharp-wasm.dll <project directory> --outDir out --noCache`, then `wasm-tools validate out/<Name>.wasm --features gc`.

## Test

```bash
bash tests/QuickTest/run.sh        # the main regression suite: compile one file, run it in Node, check the answers
bash tests/run-all.sh              # every suite, one summary table (--list, --only quicktest,showcase, --fail-fast)
```

`run-all.sh` takes about ten minutes; run it before you push a compiler change, and do not edit `src/` while it runs (`dotnet run` rebuilds). What each suite checks is in [docs/STATUS.md](docs/STATUS.md).
The Dogfood suites (`tests/Dogfood/run.sh core-libs|newsletter|widget-editor`) compile real programs from sibling repositories; they look for checkouts next to this one (`FSHARP_CORE_DIR`, `FSHARP_NEWSLETTER_DIR`, `FSHARP_IDE_DIR`)
and are skipped without them.

## A change to the compiler

1. **Write the test first**: a function in `tests/QuickTest/QuickTestWasmGc.fs` and its check in `test-runner.mjs` (several files: `tests/QuickTest`'s sibling `tests/QuickTestMulti`; what only a real program shows: Dogfood). Run it and see it fail.
2. Fix the compiler. **Never change a test to make it pass if it passes on .NET**: the compiler or the library is what is wrong.
3. Run `bash tests/run-all.sh`.
4. If the fix closes a known gap, move it in `docs/STATUS.md` from the known gaps to the dated closed list; if you found one you do not fix, write it there with a minimal program.
5. Branch from `develop`, open a pull request against `develop`, say why in the message.

### Where to add things

| You want to… | Look in |
|---|---|
| inline-replace a function of `List`, `Array`, `Option`, `Seq`, `Math`, `ResizeArray` | `src/Transforms/` (`ListOps.fs`, `ArrayReplacements.fs`, `OptionResultTransforms.fs`, `SeqFusion.fs`, `MathMap.fs`, `ResizeArrayOps.fs`, `FSharpCoreReplacements.fs`) |
| handle a new kind of Fable AST node, or a call | `src/Transforms/Fable2Wasm/` (`TransformExpr.fs`, `TransformDispatch.fs`, …) |
| add a function that every program may use, written in F# | the base library, [fsharp-wasm-core](https://github.com/fsharp-wasm/fsharp-wasm-core) (the lowest layer all its users can reach) |
| change a BCL helper the emitted code calls | `src/Bcl/` |
| add a type or an instruction to the IR | `src/Core/AST.fs`, `src/Core/Types.fs` |
| fix the WAT text or the binary encoding, or an optimisation | `src/Emit/` (`Wat.fs`, `Encoder.fs`, `Optimize.fs`) |
| change the normalisation of the Fable AST before the backend | `src/Transforms/FableNormalize.fs` |
| add a test | `tests/QuickTest/QuickTestWasmGc.fs` |

The pipeline and its ideas are in [docs/architecture.md](docs/architecture.md) and [docs/wasm-gc-backend.md](docs/wasm-gc-backend.md). Generics are specialised at each call site; there are no runtime type parameters.

## Conventions

Slim, strongly typed, functional where it reads better, no copy-paste (DRY first, KISS second but never at the cost of quality); a comment says why, not what ([AGENTS.md §9](AGENTS.md)). Commit messages:
a summary of at most 72 characters in the imperative, then why (the diff shows how).

## Clean-room policy

This project is developed clean-room: do **not** copy code from other compiler backends (OCaml's `wasm_of_ocaml`, Kotlin/Wasm, Dart's Wasm GC backend, …), and do not translate one line by line.
Reading public specifications (the WebAssembly GC and Component Model specs), papers and blog posts is fine, and so is studying open-source projects to understand an approach (with attribution).

## Getting help

A [Discussion](https://github.com/fsharp-wasm/fsharp-wasm/discussions), or an issue. [docs/faq.md](docs/faq.md) and [docs/architecture.md](docs/architecture.md) first.

## License

By contributing, you agree that your contributions are licensed under the [Apache License 2.0](LICENSE).
