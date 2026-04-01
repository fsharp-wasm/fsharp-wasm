# Component Model

This document explains how fsharp-wasm integrates with the WebAssembly Component Model
for module composition and cross-language interop.

## Overview

The Wasm Component Model is a W3C standard that enables different Wasm modules — written
in different languages — to call each other through typed WIT interfaces. fsharp-wasm
supports generating Component Model compatible output.

## WIT Interface Files

When you compile an F# project, fsharp-wasm generates a `.wit` file alongside the `.wasm`:

```bash
dotnet fable MyApp.fsproj --lang wasmgc
# Output:
#   output/MyApp.wasm
#   output/MyApp.wat
#   output/MyApp.wit     ← WIT interface
```

The WIT file describes the exported functions in WIT syntax:

```wit
package fsharp:myapp;

world myapp {
  export add: func(a: s32, b: s32) -> s32;
  export fibonacci: func(n: s32) -> s32;
  export greet: func(name: string) -> string;
}
```

## Component Embedding

Use `wasm-tools` to embed the WIT metadata into the Wasm binary:

```bash
wasm-tools component embed output/MyApp.wit output/MyApp.wasm -o output/MyApp.component.wasm
wasm-tools component new output/MyApp.component.wasm -o output/MyApp.final.wasm
```

The test scripts (`run.sh`) do this automatically if `wasm-tools` is installed.

## Module Composition

Multiple F# modules can be composed at runtime. The `examples/component-linking/` directory
demonstrates this pattern:

```
MathCore/MathCore.fs    → MathCore.wasm  (provides: add, multiply, isPrime)
App/App.fs              → App.wasm       (imports: add, multiply from MathCore)
test-runner.mjs         → wires both together, runs combined tests
```

### Defining a Module

`MathCore/MathCore.fs`:

```fsharp
module MathCore

let add a b = a + b
let multiply a b = a * b
let isPrime n =
    if n < 2 then false
    else
        let mutable i = 2
        let mutable ok = true
        while i * i <= n && ok do
            if n % i = 0 then ok <- false
            i <- i + 1
        ok
```

### Importing from Another Module

`App/App.fs`:

```fsharp
module App

open Fable.Core

[<Import("add", "MathCore")>]
let mathAdd (a: int) (b: int) : int = nativeOnly

[<Import("multiply", "MathCore")>]
let mathMultiply (a: int) (b: int) : int = nativeOnly

let sumOfPrimes limit =
    // Uses mathAdd from MathCore
    let mutable total = 0
    for i in 2..limit do
        total <- mathAdd total i
    total
```

### Runtime Wiring (Node.js)

```javascript
// test-runner.mjs
import { readFileSync } from "fs";

const mathCoreBytes = readFileSync("MathCore/output/MathCore.wasm");
const appBytes = readFileSync("App/output/App.wasm");

// Instantiate MathCore first
const mathCore = await WebAssembly.instantiate(mathCoreBytes);

// Wire MathCore exports as App imports
const appImports = {
  MathCore: mathCore.instance.exports,
};
const app = await WebAssembly.instantiate(appBytes, appImports);

// Run tests
console.log(app.instance.exports.sumOfPrimes(100));
```

## FFI Imports

Import any host function using `[<Import>]`:

```fsharp
open Fable.Core

// Import from JavaScript Math object
[<Import("random", "Math")>]
let random () : float = nativeOnly

[<Import("log", "console")>]
let consoleLog (msg: string) : unit = nativeOnly

[<Import("now", "Date")>]
let dateNow () : float = nativeOnly
```

Provide the implementations when instantiating:

```javascript
const imports = {
  Math: { random: () => Math.random() },
  console: { log: (s) => console.log(s) },
  Date: { now: () => Date.now() },
};
const { instance } = await WebAssembly.instantiate(bytes, imports);
```

## Supported WIT Types

The WIT generator maps F# types to WIT types:

| F# Type         | WIT Type    |
| --------------- | ----------- |
| `int` / `int32` | `s32`       |
| `int64`         | `s64`       |
| `float32`       | `f32`       |
| `float`         | `f64`       |
| `bool`          | `bool`      |
| `string`        | `string`    |
| `unit`          | (no return) |

Complex types (records, DUs, lists) are not yet expressible in WIT — they are passed as
opaque references within a single module boundary.

## Server-Side with Wasmtime

```bash
wasmtime run output/MyApp.final.wasm --invoke fibonacci 30
```

## Examples

See the `examples/` directory for working demonstrations:

- [`examples/component-embed/`](../examples/component-embed/) — arrays and strings across component boundary (39 tests)
- [`examples/component-linking/`](../examples/component-linking/) — two F# components composed at runtime (22 tests)

Each example has a `run.sh` that handles compilation, embedding, and test execution.
