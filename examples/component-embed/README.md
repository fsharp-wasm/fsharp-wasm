# Component Embed Example — WasmGC Arrays and Strings

Two F# modules compiled to WasmGC, demonstrating **GC-managed arrays and strings**
working inside compiled code, with primitive results composable between modules.

## What this showcases

| Feature | Where | What it proves |
|---------|-------|---------------|
| **GC array + in-place mutation** | `MathCore.sortMedian5` | `[| a;b;c;d;e |]` allocated on GC heap; bubble-sort swaps elements in-place |
| **GC array + HOF closure** | `MathCore.countAbove` | `Array.filter (fun x -> x > threshold)` over a GC array; closure captures free var |
| **GC string literals + branching** | `MathCore.greetingLen` | String literals are `(array i32)` on GC heap; `.Length` reads the GC size field |
| **GC array from cross-module results** | `App.powersAndSum` | Calls `MathCore.intPow` 5×, stores results in a WasmGC array inside App, sums them |
| **GC string concat + `.Length`** | `App.parityLabel` | "even"/"odd" strings created, concatenated via `+`, length returned as i32 |
| **GC string branching** | `App.gradeMessage` | Score mapped to grade string label, length returned as i32 |
| **Cross-module call + local logic** | `App.medianIsEven` | Delegates sort to MathCore, checks parity of result locally in App |

## Structure

```
component-embed/
├── MathCore/            ← pure math + array/string demos; no Wasm imports
│   ├── MathCore.fs
│   ├── MathCore.fsproj
│   └── run.sh
├── App/                 ← imports MathCore; adds array/string showcase
│   ├── App.fs           (includes fable-library-wasmgc/Interop.fs)
│   ├── App.fsproj
│   └── run.sh
├── test-runner.mjs      ← wires modules, runs 37+ checks
├── run.sh               ← top-level: build MathCore → build App → run tests
└── README.md
```

## Running

```bash
bash run.sh
```

This compiles both modules (WAT + WASM + WIT world if `wasm-tools` present),
then runs the combined Node.js test suite.

## How WasmGC arrays work

In our F# backend, an `int[]` compiles to a WasmGC `(array anyref)` — a
GC-managed reference type on the WasmGC heap.  No `malloc`, no `free`.

```fsharp
// MathCore.sortMedian5 — allocates, mutates, and reads a GC array:
let arr = [| a; b; c; d; e |]          // allocates (array anyref) on GC heap
arr.[j] <- arr.[j + 1]                 // array.set — in-place mutation
let result = arr.[2]                    // array.get — indexed read
```

`Array.filter` uses a **closure** — the lambda `fun x -> x > threshold` is compiled
to a WasmGC struct capturing `threshold` as a field.  HOF over GC arrays works today.

## How WasmGC strings work

F# `string` compiles to a WasmGC `(array i32)` — each element is a UTF-32 code point.
No null terminator.  No buffer overflow.  Garbage collected automatically.

```fsharp
// App.parityLabel — string literal, concat, .Length:
let s1 = if a % 2 = 0 then "even" else "odd"   // GC string literals
let combined = s1 + "+" + s2                     // allocates new (array i32)
combined.Length                                  // reads GC array length field
```

## How modules are composed

```js
// test-runner.mjs — wire MathCore exports into App's imports:
const { instance: mathCoreInst } = await WebAssembly.instantiate(mathCoreBuf, { env });

const { instance: appInst } = await WebAssembly.instantiate(appBuf, {
  env,
  "math-core": mathCoreInst.exports,   // <-- the composition step
});
```

F# `[<Import("sortMedian5", "math-core")>]` in App matches `sortMedian5` in
MathCore's export table.  Primitive values (i32/f64) cross the boundary cleanly.

## Why not pass arrays/strings between modules directly?

WasmGC reference types (arrays, structs) live on the **GC heap** — they are typed by
the module that allocated them.  Crossing a module boundary requires one of:

1. **Returning primitive summaries** (i32 counts, f64 sums) ← what we demo here
2. **Component Model canonical ABI** (`wasm-tools component embed/new/compose`)
   — handles `list<s32>` and `string` via a linear-memory lifting/lowering layer
   — our WIT world generator already emits the `.wit` file for this workflow
3. **Shared GC type declarations** via a future type-import proposal (post-MVP)

The component model path (option 2) requires our strings to use linear memory,
which is a different architecture.  Option 1 is the correct WasmGC composition
pattern and it is fully working today.
