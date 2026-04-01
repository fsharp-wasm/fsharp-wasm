# Frequently Asked Questions

## General

### What is fsharp-wasm?

fsharp-wasm is a compiler backend that compiles F# source code to WebAssembly with garbage
collection (WasmGC). It uses the [Fable](https://fable.io) compiler as a frontend for
parsing and type-checking, then generates native `.wasm` binary files.

### How is this different from Fable (F# → JavaScript)?

Fable compiles F# to JavaScript (and Python, Rust, Dart). fsharp-wasm compiles F# to
WebAssembly GC — native `.wasm` binaries with no JavaScript runtime involved.

|          | Fable (JS)                  | fsharp-wasm         |
| -------- | --------------------------- | ------------------- |
| Output   | JavaScript                  | WebAssembly binary  |
| Runtime  | Node.js / browser JS engine | Any WasmGC runtime  |
| GC       | JavaScript GC               | Host WasmGC         |
| Interop  | JavaScript APIs             | WIT Component Model |
| Maturity | Production                  | Pre-release         |

### Is this production-ready?

The core pipeline is robust — 337 unit tests + 26 algorithm tests + Component Model examples
all pass. However, some important F# features are not yet implemented (interfaces, generic
`Map`/`Set`, async). For production use, evaluate whether your use case requires those features.

### What runtimes does the output work on?

Any runtime that supports WasmGC (the W3C GC proposal):

- Node.js 22+ (flag `--experimental-wasm-gc`)
- Chrome 119+ / V8 9.9+
- Firefox 120+ (SpiderMonkey)
- Safari 18+ (JavaScriptCore)
- Wasmtime 14+ (server-side)
- WasmEdge 0.14+

### What .NET version is required to build the compiler?

.NET SDK 10.0 or later (see `global.json`).

---

## F# Language Support

### Does it support the full F# language?

No. It supports a substantial subset. See [Status](STATUS.md) for the full matrix.

Well-supported today:

- Records, DUs, pattern matching
- Closures, higher-order functions, currying
- Lists, arrays, options, results
- Strings with 35+ operations
- Math functions
- Multi-file projects
- FFI imports
- Module composition via Component Model

Not yet supported:

- Interfaces / abstract members
- Generic `Map<'K,'V>` and `Set<'T>` (only `int` keys)
- `seq { }` / lazy sequences
- Async / computation expressions beyond `seq`
- Typed exception dispatch

### Can I use F# computation expressions?

`try/with` (basic), `async { }` — not yet. Custom CEs that expand to supported constructs
at compile time (via Fable's desugaring) work if their generated code uses supported features.

### Can I use records with mutable fields?

Yes. Mutable record fields compile to WasmGC `struct.set`:

```fsharp
type Counter = { mutable Count: int }
let c = { Count = 0 }
c.Count <- c.Count + 1
```

### Does `printf` / `printfn` work?

Yes — `sprintf`, `printf`, and `printfn` with format strings work, including
`%d`, `%f`, `%s`, `%b`, and `%%` escaping. You also need to wire up the output function
via FFI if running in a non-browser environment.

### Does string interpolation work?

Yes:

```fsharp
let name = "world"
let msg = $"Hello, {name}!"
```

### Can I use `match` with guards?

Yes. Pattern guards (`when` clauses) are supported.

### Can I use active patterns?

Active patterns that reduce to supported constructs should work. Total active patterns
(single-case) and partial active patterns may require testing — please report issues.

---

## Build and Tooling

### Do I need `wasm-tools`?

`wasm-tools` is optional but strongly recommended. The compiler generates `.wasm` without it;
`wasm-tools validate` verifies the binary is correct WasmGC, and `wasm-tools component embed`
is needed for Component Model output.

Install via `cargo install wasm-tools` or download from the
[Bytecode Alliance releases](https://github.com/nickhutchinson/nickhutchinson.github.io/releases).

### How do I debug the generated code?

1. Read the `.wat` file — the compiler always writes a human-readable WAT alongside the `.wasm`
2. Open Chrome DevTools → Sources → look for the `.wasm` tab (shows WAT disassembly)
3. Use `wasm-tools dump output/MyApp.wasm` to inspect sections

### Why is the generated WAT hard to read?

Names follow the pattern `$ModuleStem_FunctionName`, e.g., `$List_map_i32`.
All names are valid WAT identifiers. The `watId` function handles prefix disambiguation.

### The compiler says "`nativeOnly` should not be called at runtime" — what does this mean?

Functions decorated with `[<Import>]` use `nativeOnly` as a placeholder body. They are
replaced by Wasm import declarations in the output. If you see this at runtime, your import
was not correctly registered when instantiating the Wasm module.

---

## Architecture

### Why use Fable instead of building a fresh F# compiler?

F# Compiler Service (FCS) is a multi-year, production-quality codebase handling the full F#
language spec. Fable adds further transformations (pattern compilation, desugaring of
computation expressions, active patterns, etc.). Building a competing frontend would take years
and have less compatibility. We focus on the backend — that is where the WasmGC expertise lives.

### Why not use `wasm-ld` for linking multiple files?

`wasm-ld` (the WebAssembly linker from LLVM) does not support WasmGC struct types. It works
for linear-memory Wasm but not for the GC proposal. Module composition uses the Wasm Component
Model instead — WIT interfaces describe the contracts between modules.

### Why inline BCL replacements instead of a runtime library?

Inline replacements in `WasmGcReplacements.fs` mean:

- Zero binary size overhead (unused functions are dead-code eliminated)
- Better optimization (the optimizer sees through function calls)
- Simpler build pipeline (no separate library build step)

The long-term plan is to compile a proper F# standard library through the backend itself.

### What is monomorphization?

F# generics are resolved at compile time by specializing each generic function for its
concrete type arguments. `identity<int>` and `identity<float>` generate two separate WASM
functions — `$identity_i32` and `$identity_f64`. This eliminates all runtime type overhead.

### Does it support cross-file generics?

Yes. Generic specialization across file boundaries works via the `(Compiler * MemberDecl)`
monomorphization cache, introduced in Sprint 10c.

---

## Performance

### How does WasmGC performance compare to native code?

WasmGC performance depends heavily on the host JIT. V8's WasmGC implementation achieves
~60–80% of native speed for compute-heavy workloads. GC-heavy workloads (lots of allocation)
depend on the host GC tuning.

### How does it compare to Fable → JavaScript?

For compute-bound code, WasmGC typically wins. For code that heavily interops with JavaScript
APIs (DOM manipulation, fetch, etc.), JavaScript may be faster due to lower crossing overhead.

### Are there optimization passes?

Yes — constant folding and dead code elimination are currently implemented. More aggressive
passes (contification, lambda lifting, unboxing) are planned.

---

## Contributing and Sponsoring

### How do I contribute?

See [CONTRIBUTING.md](../CONTRIBUTING.md).

### Is there a sponsorship program?

Yes — see [GitHub Sponsors](https://github.com/sponsors/fsharp-wasm). Sponsorship supports
full-time development of the compiler backend, standard library work, and documentation.

### Where do I ask questions?

Open a [GitHub Discussion](https://github.com/fsharp-wasm/fsharp-wasm/discussions). For bugs,
open an [Issue](https://github.com/fsharp-wasm/fsharp-wasm/issues).
