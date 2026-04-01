# Roadmap

> This roadmap describes the development direction for fsharp-wasm over the coming year.
> It is intentionally free of fixed dates — this is an open-source project and timing
> depends on contributors, sponsors, and community priorities.
>
> **Current state:** Sprint 16a complete — 337/337 tests passing, core F# → WasmGC pipeline
> robust and production quality for value types, collections, closures, and module composition.

---

## Strategic Decisions (Locked)

These decisions are confirmed and will not change:

| Decision                           | Rationale                                                                                                                  |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Fable as F# frontend**           | FCS + Fable gives us full parsing, type-checking, desugaring, and pattern compilation. No need to reinvent the frontend.   |
| **Single-module output**           | `wasm-ld` does not support WasmGC struct types. Multi-module composition uses the Wasm Component Model.                    |
| **wasm-tools for validation**      | wabt lacks WasmGC subtype (`sub`) support. wasm-tools (Bytecode Alliance, Apache 2.0) is the correct tool.                 |
| **Inline BCL replacements**        | `List.*`, `Array.*`, `Option.*`, `Math.*`, `String.*` inlined as IR — smaller binaries, better optimization opportunities. |
| **Closures as `$AnyFn` subtypes**  | Base struct + typed substructs + `call_ref` is production quality and handles all F# closure patterns.                     |
| **`return_call` for tail calls**   | Native Wasm tail calls — zero overhead, handles mutual recursion.                                                          |
| **Demand-driven monomorphization** | Specialize generics at call sites; cache via `(Compiler * MemberDecl)` pairs.                                              |

---

## What's Implemented

See [STATUS.md](STATUS.md) for the full feature matrix.  
**Summary:** Core arithmetic, records, DUs, pattern matching, closures, strings (35+ ops),
arrays, lists, options, results, multi-file modules, FFI imports, Component Model, 337 tests.

---

## Upcoming Development

### Near-term: Interface Dispatch and Vtables

The next major milestone is F# interface support. This unlocks:

- `interface I with member ...` implementations
- Abstract classes and virtual members
- Generic constraints with `IComparable` (`comparison` constraint)
- **Generic `Map<'K,'V>` and `Set<'T>`** (depends on polymorphic comparison)

The design is documented in [docs_original/design/vtable-generics.md](../docs_original/design/vtable-generics.md).

**Approach:**

- One `$VTable_I` struct per interface, with `funcref` fields for each method
- Each implementing type registers its vtable at module init
- `IComparable.CompareTo` dispatch enables `Map.add`, `Set.contains`, etc.
- `br_on_cast` remains the fast path for concrete types

**Why this matters:** Every real F# program uses `Map` or custom interfaces eventually.
This is the gateway to idiomatic F# compilation.

---

### Near-term: BCL Completeness Pass

Filling gaps in the supported .NET Base Class Library:

- `Int32.TryParse` / `Double.TryParse` (returns `bool * T` without exceptions)
- `Char.IsLetter`, `Char.IsDigit`, `Char.IsWhiteSpace`
- `Math.Abs`, `Math.Min`, `Math.Max` for all numeric types (verify coverage)
- `Array.map`, `Array.mapi`, `Array.fold`, `Array.sortBy`
- `List.sortBy`, `List.distinctBy`, `List.groupBy`
- `String.padLeft`, `String.padRight`, `String.substring`

---

### Medium-term: Typed Exception Handling

F# `try/with` works today for basic cases. Full typed exception support means:

- Pattern matching on exception types (`try .. with :? ArgumentException -> ...`)
- Custom exception types defined in F#
- `raise`, `reraise`
- Integration with Wasm exception handling proposal

---

### Medium-term: Sequence Expressions and Lazy Evaluation

`seq { }` computation expressions and `IEnumerable<'T>`:

- State machine compilation for `seq { yield ... }`
- `Seq.map`, `Seq.filter`, `Seq.take`, `Seq.fold`, etc.
- Lazy evaluation — values computed on demand
- Integration with `for x in mySeq do` syntax

This adds lazy collections to complement the existing eager `List<'T>` and `Array<'T>`.

---

### Medium-term: Async and JSPI

F# `async { }` computation expressions compiled to Wasm with JSPI:

- JSPI (JavaScript-Promise Integration) — W3C standard for suspending Wasm from async JS
- Supported in Chrome 123+, Node.js 22+, Wasmtime (with flag)
- `async { let! x = fetchData() }` compiles to suspendable Wasm functions
- Enables F# async code to interop with JavaScript `Promise`-based APIs

---

### Medium-term: Wire Loop Combinators and Quotation Walker

Infrastructure built in Sprint 16 but not yet fully wired up:

- `WasmGcLoopCombinators.fs` — replace manual traversal helpers in `WasmGcRuntime.fs`
- `WasmGcQuotationWalker.fs` — compile F# quotations (`[<ReflectedDefinition>]`) into `WFuncDecl`
- Both reduce boilerplate and improve maintainability of the runtime helper layer

---

### Longer-term: F# Standard Library Compiled by Own Backend

Eventually, F# standard library modules will be compiled through fsharp-wasm itself
rather than hand-written as inline replacements:

```
fable-library-wasmgc/
    Option.fs       ← compiled by our own backend
    List.fs
    Array.fs
    Map.fs          ← generic, uses vtable dispatch
    Set.fs
    Result.fs
    Seq.fs          ← lazy sequences
```

The strategy:

1. Write idiomatic F# code for each module
2. Compile via `processFileIntoCtx` in the pipeline
3. Link into the user's module via single-module accumulation
4. Gradually replace inline `WasmGcReplacements.fs` entries with compiled versions

Prerequisites: Interface dispatch + vtable (for generic Map/Set), seq support (for Seq).

---

### Longer-term: Full Component Model Integration

Mature support for the Wasm Component Model (WIT):

- WIT-typed exports: F# module exports described by WIT interface files
- WIT-typed imports: consume other Wasm components (Rust, C, Go, etc.)
- Lift/lower adapters at component boundaries
- `wasmtime serve` support for server-side F# Wasm components
- Browser `WebAssembly.instantiateStreaming` + component linker

This is the point at which fsharp-wasm becomes a proper interop tool rather than a
research prototype — real cross-language composition.

---

### Longer-term: Performance Optimization Passes

Systematic performance improvements:

- **Contification** — turn escaping closures into direct calls where provable
- **Lambda lifting** — lift nested functions to top level, eliminating closure allocations
- **Unboxing** — eliminate wrapper structs for single-field types
- **Struct elision** — identify records used only locally and promote to locals
- **Inline threshold tuning** — configure when to inline vs. call

---

### Longer-term: Developer Tooling

- **Source maps** — map Wasm instructions back to F# source locations for debugging
- **wasm-tools component** integration for browser DevTools
- **LSP / IDE integration** — show WasmGC output inline while editing F#
- **Incremental compilation** — only recompile changed files
- **Watch mode** — `--watch` flag for development iteration

---

## What We Explicitly Are Not Building

| Thing                          | Reason                                                                                                 |
| ------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Our own F# parser/type-checker | Fable + FCS does this correctly. Re-implementing it would be years of work with no benefit.            |
| `wasm-ld`-based linking        | Does not support WasmGC struct types. Component Model is the right approach.                           |
| Hardcoded runtime BST          | Sprint 8 mistake, fully reverted. Write F#, compile it through the backend.                            |
| Copy code from other compilers | Clean-room policy. See [07-legal-and-cleanroom.md](../docs_original/design/07-legal-and-cleanroom.md). |
| JavaScript output              | There is already an excellent F# → JS compiler. We compile to native Wasm.                             |

---

## Long-Term Vision

```
F# source (.fs)
    │
    ▼ Fable 5 + fsharp-wasm backend
    │
    ▼ .wasm (WasmGC) + .wit (Component Model)
    │
    ├──▶ Browser (Chrome, Firefox, Safari)
    ├──▶ Node.js 22+
    ├──▶ Wasmtime / WasmEdge (server-side)
    └──▶ Embedded / edge runtimes
```

**Target:** Compile real F# applications — data processing pipelines, REST APIs, browser
UIs (with Elmish/Feliz-style frameworks), cryptography, compression — natively to WasmGC
with near-native performance, no JavaScript runtime overhead, and proper WIT interface
contracts for cross-language interop.

---

## How to Influence the Roadmap

- **Open an issue** — if you need a specific feature, say so. Community needs drive priorities.
- **Submit a PR** — implementation beats discussion.
- **Sponsor the project** — sustained development requires sustained funding. See [GitHub Sponsors](https://github.com/sponsors/fsharp-wasm).
- **Share what you're building** — knowing real use cases helps prioritize the right things.
