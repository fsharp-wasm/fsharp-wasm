# fsharp-wasm

<!-- status -->
[![CI](https://github.com/fsharp-wasm/fsharp-wasm/actions/workflows/ci.yml/badge.svg?branch=develop)](https://github.com/fsharp-wasm/fsharp-wasm/actions/workflows/ci.yml) · [Status of every repository](https://fsharp-wasm.github.io/status/)
<!-- /status -->

<!-- platform -->
> **Part of the [fsharp-wasm platform](https://fsharp-wasm.github.io/projects/)**: the compiler. Builds on [fsharp](https://github.com/fsharp-wasm/fsharp) and [Fable](https://github.com/fsharp-wasm/fable) (our forks: the front end). Used by every other repository.
> [All projects](https://fsharp-wasm.github.io/projects/) · [Roadmap](https://fsharp-wasm.github.io/docs/roadmap/) · [Tests](https://fsharp-wasm.github.io/tests/) · [Benchmarks](https://fsharp-wasm.github.io/benchmarks/) · [Live demos](https://fsharp-wasm.github.io/demos/)

**Compile F# to WebAssembly GC: small modules that use the engine's own garbage collector.**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4)](https://dotnet.microsoft.com/)
[![WasmGC](https://img.shields.io/badge/WebAssembly-GC-654FF0)](https://github.com/WebAssembly/gc)

> A standalone WasmGC backend for the [Fable](https://fable.io) F# compiler.
> Produces `.wasm` binaries that run on any WasmGC-capable runtime — browsers, Node.js, Wasmtime, WasmEdge.

---

## What is this?

**fsharp-wasm** compiles F# source code directly to WebAssembly with garbage collection (WasmGC).
No Emscripten and no garbage collector shipped in the binary — just native Wasm structs and arrays
managed by the host runtime's GC. A module needs no JavaScript runtime *library*; what it reaches outside itself (the DOM, the network, storage)
comes through imports that a host provides: [fsharp-wasm-runtime](https://github.com/fsharp-wasm/fsharp-wasm-runtime) in the browser,
[fsharp-wasm-edge](https://github.com/fsharp-wasm/fsharp-wasm-edge) on Cloudflare, Vercel, Netlify, Deno, Bun and Node.

```fsharp
// hello.fs
module Hello

let fibonacci n =
    let mutable a, b = 0, 1
    for _ in 1..n do
        let t = a + b
        a <- b
        b <- t
    a

let isPrime n =
    if n < 2 then false
    else
        let mutable i = 2
        let mutable result = true
        while i * i <= n && result do
            if n % i = 0 then result <- false
            i <- i + 1
        result
```

Compile and run:

```bash
dotnet fable hello.fsproj --lang wasmgc
# → output/hello.wasm + output/hello.wat
```

## Features

### Implemented

| Category            | Features                                                                           |
| ------------------- | ---------------------------------------------------------------------------------- |
| **Core Language**   | Let bindings, recursion, tail calls (`return_call`), mutual recursion              |
| **Type System**     | Records, discriminated unions, pattern matching, generics (monomorphized)          |
| **Functions**       | Closures, higher-order functions, currying, partial application                    |
| **Collections**     | `List<'T>`, `Array<'T>`, `Option<'T>`, `Result<'T,'E>` with full combinators       |
| **Strings**         | Native UTF-16 on GC heap, 35+ operations (concat, split, join, format, trim, etc.) |
| **Math**            | Full `System.Math` (sin, cos, sqrt, abs, pow, min, max, etc.)                      |
| **Formatting**      | `sprintf`, `printfn`, `$"interpolation"`                                           |
| **Parsing**         | `Int32.Parse`, `Double.Parse`, `float` cast                                        |
| **Multi-file**      | Multiple `.fs` files compiled into a single Wasm module                            |
| **FFI**             | `[<Import("name","module")>]` for importing host/Wasm functions                    |
| **Component Model** | WIT file generation, `wasm-tools component embed/new` integration                  |
| **Module Linking**  | Multiple F# compilation units composed at runtime                                  |
| **Binary Output**   | Direct `.wasm` binary encoding (LEB128, all sections) + human-readable `.wat`      |

### Known gaps

Programs that do not compile yet, measured while writing tests (the full, dated list is in [docs/STATUS.md](docs/STATUS.md)): stepped ranges
(`for i in 0 .. 2 .. 9`), `Array.map not`, `Array.concat` of a list of arrays, array slices, `System.Array.IndexOf` / `Resize` / `Clear` / `Reverse` /
`Sort` / `CopyTo`, `sprintf "%A"`, dictionary literals, comparer constructor overloads, and `async` / JSPI (planned).

## Quick Start

Four commands, with the [.NET 10 SDK](https://dotnet.microsoft.com/download) and [Node.js 22+](https://nodejs.org/) installed:

```bash
dotnet tool install -g FSharp.Wasm.Cli --prerelease     # the compiler, once
dotnet new install FSharp.Wasm.Templates                # the starter, once
dotnet new fsharp-wasm -n hello && cd hello             # hello.fs, run.mjs (Node), index.html (a web page)
fsharp-wasm . --outDir out && node run.mjs              # hello.fs -> out/hello.wasm (a few hundred bytes), run by Node
```

The starter is [`examples/hello-wasm`](examples/hello-wasm); CI compiles and runs it on every push, and the release workflow runs the whole path above, from the packed tool and the packed
template into an empty HOME, before it publishes anything. Without the .NET tool: `curl -fsSL https://raw.githubusercontent.com/fsharp-wasm/fsharp-wasm/main/scripts/install.sh | sh`
installs a release binary (Linux, macOS; checked against `SHA256SUMS`).

### Prerequisites (to build the compiler yourself)

- [.NET SDK 10.0+](https://dotnet.microsoft.com/download) (see `global.json`)
- [Node.js 22+](https://nodejs.org/) (for running tests)
- [`wasm-tools`](https://github.com/bytecodealliance/wasm-tools) (optional, for binary validation and Component Model)

### 0. Or just use a release

Every tagged release carries the compiler as a self-contained binary — `fsharp-wasm-<rid>.tar.gz` (Linux, macOS) or `.zip`
(Windows) — with `core/FSharp.Wasm.Core/` (the F# base library) next to it, plus the NuGet packages. Unpack it, put a .NET SDK on the `PATH`
(the CLI cracks projects through `dotnet`), and run `fsharp-wasm <project> --outDir <dir>`. Other repositories
(`fsharp-wasm-runtime`, …) fetch the compiler from here this way; none of them is a submodule of this repository.

### 1. Clone (to work on the compiler)

```bash
git clone https://github.com/fsharp-wasm/fsharp-wasm.git
cd fsharp-wasm
git submodule update --init --depth 1 vendor/Fable vendor/fsharp core
```

`vendor/Fable` (the Fable fork the backend is built on), `vendor/fsharp` (the patched F# compiler) and `core`
([fsharp-wasm-core](https://github.com/fsharp-wasm/fsharp-wasm-core), the F# base library the compiler ships beside its
binary and every program is compiled with) are the only submodules: build-time dependencies, not products. The other
sibling repositories are separate; the test suite that compiles the sources of `fsharp-wasmecto` looks for a checkout
next to this repository (or `FSHARP_WASMECTO_DIR`) and is skipped without one. `FSHARP_WASM_CORE_DIR` points the compiler
at another checkout of fsharp-wasm-core.

### 2. Build

The backend is built on a patched F# compiler (`vendor/fsharp`), which is built once; the steps, with the versions, are in [CONTRIBUTING.md](CONTRIBUTING.md):

```bash
(cd vendor/fsharp && mkdir -p artifacts && ./build/build.sh -c Release)
export FSHARP_COMPILER="$PWD/vendor/fsharp/artifacts/bin/fsc/Release/net10.0/fsc.dll"
dotnet build src/WasmGc.fsproj -c Release
dotnet build tools/FSharp.Wasm.Cli/FSharp.Wasm.Cli.fsproj -c Release
```

This builds the WasmGC backend (`src/WasmGc.fsproj`, with the Fable projects of `vendor/Fable` it stands on) and the command-line tool.

### 3. Run tests

```bash
bash tests/run-all.sh              # every suite, one summary table (--list, --only quicktest,showcase, --fail-fast)
bash tests/QuickTest/run.sh        # the main regression suite (706 tests on 2026-11-24)
bash tests/Showcase/run.sh         # 26 end-to-end programs
cd examples/component-embed && bash run.sh      # 39 checks
cd examples/component-linking && bash run.sh    # 22 checks
```

What each suite checks, and the counts of a recorded run (675 + 26 + 39 + 22 + 14 + 11 + 5 + 27 + 81 + 36 named tests, a differential run of 183 012 calls
against .NET with no disagreement, a closure fuzz of 30 720 checks), are in [docs/STATUS.md](docs/STATUS.md) and on
[fsharp-wasm.github.io/tests](https://fsharp-wasm.github.io/tests).

> **Note**: The test scripts run the compiler via `dotnet run --project vendor/Fable/src/Fable.Cli`
> which automatically resolves the WasmGC backend from the parent repo.

## Releases

Pushing a `v*` tag runs `.github/workflows/release.yml` and publishes GitHub Release assets for:
- the platform-specific `Fable.Cli` compiler archives
- a `Fable.WasmGc-net10.0.zip` build of the backend DLLs
- a `Fable.WasmGc` NuGet package (`.nupkg`)

The release workflow also packs the compiler as a .NET tool (`FSharp.Wasm.Cli`) and the `dotnet new` template (`FSharp.Wasm.Templates`), proves both from an empty HOME and NuGet cache (install,
`dotnet new`, compile, validate, run on Node), and only then publishes. NuGet upload is wired in and stays skipped until the `NUGET_API_KEY` secret is configured.

### Compile Your Own F# Project

1. Create an F# project:

   ```bash
   dotnet new console -lang F# -n MyApp
   ```

2. Compile to WasmGC:

   ```bash
   dotnet fable MyApp.fsproj --lang wasmgc
   ```

3. Run with Node.js:
   ```javascript
   const { readFileSync } = await import("fs");
   const bytes = readFileSync("output/MyApp.wasm");
   const { instance } = await WebAssembly.instantiate(bytes);
   console.log(instance.exports.myFunction(42));
   ```

## Architecture

```
F# Source (.fs)
    │
    ▼
┌──────────────────────┐
│  F# Compiler Service │  Parse + type-check
│  (via Fable 5)       │
└──────────┬───────────┘
           │  Fable AST
           ▼
┌──────────────────────┐
│  Fable2WasmGc        │  F# AST → WasmGC IR
│  + Replacements      │  BCL inlining (List, Array, Option, Math, String...)
│  + Monomorphization  │  Generic specialization
└──────────┬───────────┘
           │  WExpr / WModule
           ▼
┌──────────────────────┐
│  Optimize            │  Constant folding, dead code elimination
└──────────┬───────────┘
           │
     ┌─────┴─────┐
     ▼           ▼
┌─────────┐ ┌──────────┐
│ WAT     │ │ Encoder  │  .wat (text)  +  .wasm (binary)
│ Emitter │ │ (Binary) │
└─────────┘ └──────────┘
```

See [docs/architecture.md](docs/architecture.md) for details.

## Project Structure

```
src/
├── Core/                         # the IR types (WType, WExpr, WFunc, WModule), registries, diagnostics
├── Transforms/                   # Fable AST → WasmGC IR translation, the BCL replacements, host interop
├── Patterns/                     # reusable IR patterns: loops, arrays, lists, closures, vtables
├── Ir/, Pipeline/                # IR queries and dumps; the phases between the Fable AST and the emitter
├── Emit/                         # WAT printer, binary encoder, optimiser, linker
└── Pipeline.fs                   # project → IR → .wat / .wasm → WIT

core/                            # submodule: fsharp-wasm-core — FSharp.Wasm.Core, the F# base library
tests/                            # the suites, run together by tests/run-all.sh
examples/                         # Component model demos
docs/                             # Documentation
vendor/Fable/                     # Fable 5 with WasmGC patches
```

## Documentation

- [Getting Started](docs/getting-started.md) — Setup, build, and first project
- [Architecture](docs/architecture.md) — Compiler pipeline and design decisions
- [WasmGC Backend](docs/wasm-gc-backend.md) — How F# maps to WasmGC
- [Type Mapping](docs/type-mapping.md) — F# types → Wasm GC types
- [Status](docs/STATUS.md) — Current feature matrix
- [Roadmap](docs/ROADMAP.md) — What's next
- [Contributing](CONTRIBUTING.md) — How to contribute
- [FAQ](docs/faq.md) — Frequently asked questions

## How It Works

fsharp-wasm leverages [Fable](https://fable.io)'s frontend (F# Compiler Service + Fable's typed AST)
and adds a completely new backend that targets WebAssembly GC:

- **Records** → WasmGC `struct` types with named fields
- **Discriminated Unions** → Struct hierarchy with tag dispatch via `br_on_cast`
- **Closures** → `$AnyFn` base struct with captured variables + `call_ref` dispatch
- **Strings** → GC-managed `(array i32)` with 35+ runtime operations
- **Lists** → Linked-list struct hierarchy (`$ListBase` / `$ListCons`)
- **Generics** → Demand-driven monomorphization (specialized at each call site)
- **Tail calls** → Native `return_call` (zero-cost, handles mutual recursion)

## Sponsoring

fsharp-wasm is developed as an open-source project by the [fsharp-wasm organisation](https://github.com/fsharp-wasm). If you find it useful or want
to support the development of F# on WebAssembly, please consider sponsoring the organisation:

- [GitHub Sponsors: fsharp-wasm](https://github.com/sponsors/fsharp-wasm)
- [Tiers, goals and the way for companies](https://fsharp-wasm.github.io/sponsor/): what each amount gets you, and what the money unlocks (set 2026-11-26)

Sponsorship supports the work across the organisation's repositories: the compiler and its tests, the base library and the hosts, the documentation,
and the benchmarks and test infrastructure that let anyone check what is claimed. The goals, in steps:

1. **10 sponsors:** incorporating the organisation, and live deployments of the edge host on Cloudflare, Vercel and Netlify.
2. **$2 500 a month:** the Component Model work (WIT interfaces to Rust crates) and the native desktop shell.
3. **$5 000 a month and up:** focused work on the device APIs for iOS and Android and on the accessible GUI framework.

## Contributing

Welcome. [CONTRIBUTING](https://github.com/fsharp-wasm/.github/blob/develop/CONTRIBUTING.md) is the organisation's guide and [AGENTS.md](AGENTS.md) says how the platform is worked on (the compiler comes first: a fault found here
is fixed in the compiler, not worked around here).

- **Run the tests:** `bash tests/run-all.sh` (all suites, about ten minutes); `bash tests/QuickTest/run.sh` for the main regression suite. [CONTRIBUTING.md](CONTRIBUTING.md) has the build.
- **A good first contribution:** A program that does not compile, with its F# source, is the best report; each gap in [docs/STATUS.md](docs/STATUS.md) is a task. Issues labelled [`good first issue`](https://github.com/fsharp-wasm/fsharp-wasm/labels/good%20first%20issue) are the places to start.
- **A change** goes to `develop` as a pull request, with a test that fails without it. Open an issue first for anything larger than a fix.

## License

[Apache License 2.0](LICENSE) — Copyright 2025–2026 The fsharp-wasm contributors; see [NOTICE](NOTICE). The two forks it is built on, Fable and the F# compiler, keep their MIT License.

## Acknowledgments

- [Fable](https://fable.io) — The F# to JavaScript/Python/Rust/Dart compiler that provides our frontend
- [Bytecode Alliance](https://bytecodealliance.org/) — For `wasm-tools` and the Component Model
- [WebAssembly Community Group](https://www.w3.org/community/webassembly/) — For the WasmGC specification
