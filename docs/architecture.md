# Architecture

This document describes the compilation pipeline, project structure, and key design decisions
of the fsharp-wasm compiler backend.

## Overview

fsharp-wasm is a **backend** for the [Fable](https://fable.io) F# compiler. Fable handles parsing,
type-checking, and desugaring F# code via F# Compiler Service (FCS). We take Fable's typed
intermediate representation and compile it to WebAssembly GC binary modules.

## Compilation Pipeline

The compiler processes F# source through seven distinct phases:

```
Phase 1: Parse & Type-Check
    F# source (.fs) → F# Compiler Service → Typed AST

Phase 2: Fable Transform
    F# Typed AST → Fable AST (portable IR)

Phase 3: BCL Replacements
    Fable AST → Fable AST with .NET BCL calls replaced by inline implementations
    (List.map, Array.filter, String.concat, Math.sin, etc.)

Phase 4: Monomorphization
    Generic functions specialized at each call site (demand-driven)

Phase 5: Fable → WasmGC IR
    Fable AST → WExpr / WModule (our internal WasmGC IR)

Phase 6: Optimization
    WExpr → WExpr (constant folding, dead code elimination)

Phase 7: Emission
    WExpr → .wat (text) + .wasm (binary)
```

### Detailed Flow

```
┌─────────────┐    ┌───────────────────┐    ┌──────────────────────┐
│ F# Source   │───▶│ FCS + Fable 5     │───▶│ WasmGcReplacements   │
│ (.fs files) │    │ Parse/TypeCheck    │    │ BCL → inline WasmIR │
└─────────────┘    └───────────────────┘    └──────────┬───────────┘
                                                       │
                                                       ▼
                   ┌───────────────────┐    ┌──────────────────────┐
                   │ Monomorphization  │◀───│ Fable2WasmGc         │
                   │ (demand-driven)   │    │ AST → WExpr IR       │
                   └───────────────────┘    └──────────┬───────────┘
                                                       │
                                                       ▼
                   ┌───────────────────┐    ┌──────────────────────┐
                   │ WasmGcOptimize    │───▶│ WasmGcWat (text)     │
                   │ P0/P1 passes      │    │ WasmGcEncoder (bin)  │
                   └───────────────────┘    └──────────────────────┘
                                                       │
                                                  ┌────┴────┐
                                                  ▼         ▼
                                                .wat     .wasm
```

## Source Layout

```
src/
├── WasmGc.AST.fs                  # Core IR types
├── WasmGcPipeline.fs              # Entry point, file processing, WIT generation
│
├── Runtime/                       # Runtime infrastructure
│   ├── WasmGcTypes.fs             # Ctx record, type registries, mapType helpers
│   ├── WasmGcBuilder.fs           # wasm {} CE builder + smart constructors
│   ├── WasmGcRuntime.fs           # makeFunc, runtime helpers (string, list, array)
│   ├── WasmGcFreeVars.fs          # Free variable analysis for closure conversion
│   ├── WasmGcLoopHelpers.fs       # mkListLoop, mkArrayLoop patterns
│   ├── WasmGcLoopCombinators.fs   # Composable list/array traversal combinators
│   └── WasmGcQuotationWalker.fs   # F# quotation → WFuncDecl translator
│
├── Transforms/                    # AST transformations
│   ├── Fable2WasmGc.fs            # Main translator: Fable AST → WExpr
│   └── WasmGcReplacements.fs      # All BCL inline replacements
│
└── Emit/                          # Output generation
    ├── WasmGcOptimize.fs          # Optimization passes (P0: const fold, P1: DCE)
    ├── WasmGcWat.fs               # WModule → WAT text emitter
    ├── WasmGcEmit.fs              # WExpr → Instr lowering
    └── WasmGcEncoder.fs           # Binary .wasm encoder (LEB128, sections)
```

## Core Types

### WasmGC IR (`WasmGc.AST.fs`)

The intermediate representation consists of:

- **`WType`** — Wasm types: `I32`, `I64`, `F32`, `F64`, `I16`, `StructRef`, `ArrayRef`, `FuncRef`, `AnyRef`, etc.
- **`WExpr`** — Expressions: `Const`, `LocalGet`, `LocalSet`, `Call`, `StructNew`, `StructGet`, `ArrayNew`, `If`, `Block`, `Loop`, `Return`, etc.
- **`WConst`** — Constants: `I32 of int`, `I64 of int64`, `F32 of float32`, `F64 of float`
- **`WFuncDecl`** — Function declaration: name, params, return type, locals, body
- **`WModule`** — Complete module: types, functions, imports, exports, globals, data

### Compilation Context (`WasmGcTypes.fs`)

The `Ctx` record is threaded through the entire pipeline and tracks:

- Type registries (struct types, array types, function types)
- Function table (name → index mapping)
- Import/export declarations
- Monomorphization cache
- Label generation state

### Pre-Registered Types

Three types are always registered at fixed indices (order matters for subtyping):

| Index | Name        | Definition          | Purpose                    |
| ----- | ----------- | ------------------- | -------------------------- |
| 0     | `$AnyFn`    | Closure base struct | Base type for all closures |
| 1     | `$WasmStr`  | `(array i32)`       | String representation      |
| 2     | `$ListBase` | List base struct    | Base for linked lists      |

## Key Design Decisions

### Why Fable as Frontend?

Fable gives us F# Compiler Service integration for free: full parsing, type-checking,
pattern match compilation, active patterns, computation expressions — all the complex
F# frontend work. We only need to implement the backend.

### Why Not wasm-ld?

`wasm-ld` (the WebAssembly linker) does not support WasmGC struct types. All linking
happens through the Wasm Component Model instead. Each compilation produces a
single-module `.wasm` file; multiple modules are composed via WIT interfaces.

### Why Inline BCL Replacements?

.NET Base Class Library functions (`List.map`, `Array.filter`, `String.concat`, etc.)
are replaced inline as WasmGC IR in `WasmGcReplacements.fs` rather than compiled from
a separate runtime library. This gives:

- Smaller binary output (no unused functions)
- Better optimization opportunities (functions are visible to the optimizer)
- Simpler build pipeline (no separate library compilation step)

The long-term plan is to compile a proper F# standard library through the backend itself,
but inline replacements remain the strategy for primitive operations.

### Why Demand-Driven Monomorphization?

Generics in F# are erased at the WasmGC level — each generic function is specialized
for the concrete types at each call site. This is "demand-driven": we only generate
specializations for types actually used in the program.

### CE Builder Scope

The `wasm { }` computation expression builder is used exclusively in `WasmGcRuntime.fs`
for readable IR construction of runtime helper functions. It is intentionally **not** used
in `WasmGcReplacements.fs` — replacements stay as plain `WExpr` construction for
predictable control over the generated code.

### Tail Calls via `return_call`

F# tail-recursive functions compile to Wasm's native `return_call` instruction rather
than being transformed into loops. This handles mutual recursion at zero cost and
produces cleaner output.

## Multi-File Processing

The pipeline processes multiple `.fs` files by accumulating into a shared `Ctx`:

1. Files are ordered by the F# project file (`.fsproj`)
2. Each file is processed via `processFileIntoCtx`, which updates the `Ctx`
3. Cross-file references resolve via `KnownFuncsByPath` keyed by `(fileStem, selector)`
4. The final `Ctx` contains all declarations and is emitted as a single `.wasm` module

## Optimization Passes

Currently implemented:

- **P0 — Constant Folding:** Evaluate constant expressions at compile time
- **P0 — Dead Code Elimination:** Remove unreachable code paths
- **P1 — Trivial Block Elimination:** Flatten single-expression blocks

Future passes (planned):

- Contification (turn escaping closures into direct calls)
- Lambda lifting (reduce closure allocations)
- Unboxing (remove wrapper structs for single-field types)

## Component Model Integration

fsharp-wasm supports the Wasm Component Model for cross-module interop:

1. **WIT Generation** — The pipeline generates `.wit` interface files alongside `.wasm`
2. **Component Embedding** — `wasm-tools component embed` attaches WIT metadata
3. **Component Linking** — Multiple F# modules can be composed at runtime

See [Component Model](component-model.md) for details.
