# Component Linking Example

Two independent F# modules compiled to WasmGC, composed at runtime.

## Structure

```
component-linking/
├── MathCore/          ← pure math primitives; no Wasm imports
│   ├── MathCore.fsproj
│   ├── MathCore.fs
│   └── run.sh
├── App/               ← imports MathCore; builds higher-level functions
│   ├── App.fsproj     (includes fable-library-wasmgc/Interop.fs)
│   ├── App.fs
│   └── run.sh
├── test-runner.mjs    ← instantiates both modules, wires imports, checks results
├── run.sh             ← top-level: build MathCore → build App → run tests
└── README.md
```

## Running

```bash
bash run.sh
```

This:

1. Compiles `MathCore.fs` → `MathCore/output/MathCore.wasm` (+ WIT world if wasm-tools present)
2. Compiles `App.fs` → `App/output/App.wasm`
3. Runs `test-runner.mjs` which wires the two modules together

## How component linking works

MathCore exports plain functions (`add`, `mul`, `fibonacci`, `dotProduct`, `intPow`, `clamp`).
App declares Wasm imports from a module named `"math-core"` using `[<Import>]`:

```fsharp
open Fable.Core
[<Import("fibonacci", "math-core")>]
let importFibonacci (n: int) : int = nativeOnly
```

The host (test-runner.mjs) wires them at instantiation time:

```js
// 1. Instantiate the provider
const { instance: mathCoreInst } = await WebAssembly.instantiate(mathCoreBuf, {
  env,
});

// 2. Instantiate the consumer, wiring 'math-core' from mathCoreInst's exports
const { instance: appInst } = await WebAssembly.instantiate(appBuf, {
  env,
  "math-core": mathCoreInst.exports, // ← this IS the component link
});
```

This is exactly the pattern used by the Wasm Component Model at the host layer.

## What it proves

- Two separate F# compilation units can be linked at Wasm runtime
- The `[<Import(selector, module)>]` / `nativeOnly` FFI works for cross-component calls
- WIT worlds are emitted for both components (describes their primitive-type interface)
- The math is correct: `sumOfFibs(7)` calls `fibonacci` inside MathCore, not a JS polyfill

## Extending this example

To add a new MathCore export:

1. Add a primitive-type `let` binding to `MathCore/MathCore.fs`
2. Add a matching `[<Import("name", "math-core")>]` declaration to `App/App.fs`
3. Use it in an App wrapper function
4. Add a check to `test-runner.mjs`
