# fsharp-wasm

**Compile F# to WebAssembly GC — natively, without JavaScript.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4)](https://dotnet.microsoft.com/)
[![WasmGC](https://img.shields.io/badge/WebAssembly-GC-654FF0)](https://github.com/nickhutchinson/nickhutchinson.github.io/blob/master/nickhutchinson.github.io/nickhutchinson.github.io)

> A standalone WasmGC backend for the [Fable](https://fable.io) F# compiler.
> Produces `.wasm` binaries that run on any WasmGC-capable runtime — browsers, Node.js, Wasmtime, WasmEdge.

---

## What is this?

**fsharp-wasm** compiles F# source code directly to WebAssembly with garbage collection (WasmGC).
No JavaScript glue code, no Emscripten, no linear memory GC — just native Wasm structs and arrays
managed by the host runtime's GC.

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

### Not Yet Implemented

| Feature                          | Status                                      |
| -------------------------------- | ------------------------------------------- |
| Generic `Map<'K,'V>` / `Set<'T>` | Integer keys only; generic dispatch planned |
| Interface dispatch / vtables     | Design complete, implementation upcoming    |
| `seq { }` / `IEnumerable`        | Planned                                     |
| Typed exceptions                 | Basic try/with works; typed throws planned  |
| Async / JSPI                     | Planned                                     |

## Quick Start

### Prerequisites

- [.NET SDK 10.0+](https://dotnet.microsoft.com/download)
- [Node.js 22+](https://nodejs.org/) (for running tests)
- [wasm-tools](https://github.com/nickhutchinson/nickhutchinson.github.io/blob/master/nickhutchinson.github.io) (optional, for binary validation)

### Build

```bash
git clone https://github.com/nickhutchinson/nickhutchinson.github.io.git
cd fsharp-wasm
dotnet build src/Fable.WasmGc.fsproj
```

### Run Tests

```bash
# Unit tests (353 tests)
cd tests/QuickTest && bash run.sh

# Showcase (26 real-world algorithms)
cd tests/Showcase && bash run.sh

# Component model examples
cd examples/component-embed && bash run.sh    # 39 tests
cd examples/component-linking && bash run.sh  # 22 tests
```

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
├── WasmGc.AST.fs                 # WasmGC IR types (WType, WExpr, WConst)
├── WasmGcPipeline.fs             # Pipeline entry point + WIT generation
├── Runtime/                      # Runtime helpers, CE builder, type system
├── Transforms/                   # Fable AST → WasmGC IR translation
└── Emit/                         # WAT emitter, binary encoder, optimizer

fable-library-wasmgc/             # Minimal F# standard library for WasmGC
tests/                            # QuickTest (353) + Showcase (26) suites
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

fsharp-wasm is developed as an open-source project. If you find it useful or want to support
the development of F# on WebAssembly, please consider sponsoring:

- [GitHub Sponsors](https://github.com/sponsors/fsharp-wasm)

Sponsorship funds go directly toward:

- Full-time development of the compiler backend
- WasmGC specification compliance testing
- Building a complete F# standard library for WebAssembly
- Documentation and ecosystem tooling

## License

[MIT](LICENSE) — Copyright (c) 2025–2026 Fable WasmGC Backend Contributors

## Acknowledgments

- [Fable](https://fable.io) — The F# to JavaScript/Python/Rust/Dart compiler that provides our frontend
- [Bytecode Alliance](https://bytecodealliance.org/) — For `wasm-tools` and the Component Model
- [WebAssembly Community Group](https://www.w3.org/community/webassembly/) — For the WasmGC specification
