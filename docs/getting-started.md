# Getting Started

This guide walks you through setting up fsharp-wasm, building from source, and compiling your first F# program to WebAssembly GC.

## Prerequisites

| Tool                                                                     | Version | Required    | Purpose                                       |
| ------------------------------------------------------------------------ | ------- | ----------- | --------------------------------------------- |
| [.NET SDK](https://dotnet.microsoft.com/download)                        | 10.0+   | Yes         | Build the compiler and compile F# projects    |
| [Node.js](https://nodejs.org/)                                           | 22+     | Yes         | Run compiled Wasm modules (test harness)      |
| [wasm-tools](https://github.com/nickhutchinson/nickhutchinson.github.io) | 1.245+  | Recommended | Binary validation and Component Model tooling |

### Installing wasm-tools

```bash
# Via cargo (if you have Rust installed)
cargo install wasm-tools

# Or download a prebuilt binary from:
# https://github.com/nickhutchinson/nickhutchinson.github.io/releases
```

wasm-tools is optional — the compiler works without it, but test scripts use it for binary validation.

## Clone and Build

```bash
git clone https://github.com/fsharp-wasm/fsharp-wasm.git
cd fsharp-wasm
dotnet build src/Fable.WasmGc.fsproj
```

The build produces the compiler backend as a .NET library. It integrates with the Fable CLI
(included in `vendor/Fable/`).

## Verify Installation

Run the test suite to confirm everything works:

```bash
cd tests/QuickTest && bash run.sh
```

You should see output like:

```
Compiling QuickTestWasmGc...
Running wasm-tools validate...
Running 353 tests...
✅ All 353 tests passed
```

## Compile an F# File

### Project Setup

Create a minimal F# project:

```bash
mkdir MyApp && cd MyApp
dotnet new classlib -lang F# -n MyApp
```

Edit `MyApp.fs`:

```fsharp
module MyApp

let add a b = a + b

let factorial n =
    let mutable result = 1
    for i in 2..n do
        result <- result * i
    result

let greet name =
    "Hello, " + name + "!"
```

### Compile to WasmGC

```bash
dotnet fable MyApp.fsproj --lang wasmgc
```

This produces:

- `output/MyApp.wasm` — Binary WebAssembly module
- `output/MyApp.wat` — Human-readable WAT text format (for debugging)

### Run with Node.js

```javascript
// run.mjs
import { readFileSync } from "fs";

const bytes = readFileSync("output/MyApp.wasm");
const { instance } = await WebAssembly.instantiate(bytes);

console.log("add(3, 4) =", instance.exports.add(3, 4)); // 7
console.log("factorial(10) =", instance.exports.factorial(10)); // 3628800
```

```bash
node --experimental-wasm-gc run.mjs
```

## Run All Test Suites

```bash
# Quick unit tests (353 tests)
cd tests/QuickTest && bash run.sh && cd ../..

# Real-world algorithm showcase (26 tests)
cd tests/Showcase && bash run.sh && cd ../..

# Component Model embedding (39 tests)
cd examples/component-embed && bash run.sh && cd ../..

# Cross-module linking (22 tests)
cd examples/component-linking && bash run.sh && cd ../..
```

## Understanding the Output

### WAT File

The `.wat` file is a human-readable representation of the Wasm module. It's useful for
debugging and understanding what the compiler generates:

```wat
(module
  (type $add_type (func (param i32 i32) (result i32)))
  (func $add (type $add_type) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add
  )
  (export "add" (func $add))
)
```

### Binary Validation

If you have `wasm-tools` installed, validate the binary:

```bash
wasm-tools validate output/MyApp.wasm
# Should output nothing (success) or validation errors
```

## Using FFI Imports

You can import functions from the host environment:

```fsharp
// In your F# code
open Fable.Core

[<Import("log", "console")>]
let consoleLog (msg: string) : unit = nativeOnly

[<Import("random", "math")>]
let mathRandom () : float = nativeOnly
```

Then provide the imports when instantiating:

```javascript
const imports = {
  console: { log: (str) => console.log(str) },
  math: { random: () => Math.random() },
};
const { instance } = await WebAssembly.instantiate(bytes, imports);
```

See [Component Model](component-model.md) for advanced module composition.

## Next Steps

- [Architecture](architecture.md) — Understand the compiler pipeline
- [Type Mapping](type-mapping.md) — How F# types become WasmGC types
- [BCL Coverage](bcl-coverage.md) — Which .NET functions are supported
- [Status](STATUS.md) — Current feature matrix
