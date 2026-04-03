# Design Decisions

This document records the key architectural decisions made during fsharp-wasm development,
their rationale, and the alternatives that were considered and rejected.

## Fable as the F# Frontend

**Decision:** Use Fable's compiler frontend (FCS + Fable AST) rather than building our own.

**Rationale:**

- F# Compiler Service handles the full F# language specification — parsing, type inference,
  overload resolution, pattern compilation, active patterns, computation expressions
- Building a competing frontend would take years and would always lag FCS on language features
- Fable adds further transformations (decision trees, DU normalization, module resolution)
  that are valuable and already correct
- We focus expertise on the backend — that is where the WasmGC knowledge lives

**Trade-off:** We depend on Fable's versioning and patch the upstream source in `vendor/Fable/`.

## Single-Module Output

**Decision:** Each F# project compiles to a single `.wasm` file. Multi-module composition uses the Wasm Component Model.

**Rationale:**

- `wasm-ld` (LLVM's Wasm linker) does not support WasmGC struct types — it is designed for
  linear-memory Wasm
- The Wasm Component Model provides typed interfaces (WIT) for composing modules across
  language boundaries — superior to raw linking
- Single-module output is simpler and easier to optimize

**Trade-off:** Component Model support required new tooling (`wasm-tools`). Now working since Sprint 11c.

## `wasm-tools` for Validation

**Decision:** Use `wasm-tools` (Bytecode Alliance) for binary validation.

**Rationale:**

- `wabt` (`wasm-validate`) does not support the `(sub ...)` subtype syntax introduced by WasmGC
- `wasm-tools` is maintained by the Bytecode Alliance, actively tracks the WasmGC spec, and
  is Apache 2.0 licensed

## Inline BCL Replacements

**Decision:** All List, Array, Option, Result, Math, and String functions are implemented
as inline WasmGC IR in `WasmGcReplacements.fs`.

**Rationale:**

- Zero binary size overhead — only used functions appear in the output
- Better optimization — the optimizer sees through function call boundaries
- Simpler build — no separate library compilation step
- Faster iteration — BCL functions can be tuned without managing a separate project

**Future:** A proper compiled F# standard library (`fable-library-wasmgc/`) will eventually
replace inline replacements for complex modules (Map, Set, Seq). Plan documented in ROADMAP.

**The Sprint 8 lesson:** Sprint 8 attempted to build a hardcoded BST as compiler-internal
code. This was wrong — it bypassed the F# type system and was unmaintainable.
The correct approach: write F#, compile it through our own backend.

## Demand-Driven Monomorphization

**Decision:** Generics are eliminated by specializing functions at each call site.

**Rationale:**

- WasmGC has no runtime type parameters — all types must be concrete
- Dictionary of Methods (DoM) approach (boxing + vtable dispatch) adds overhead
- Demand-driven specialization eliminates overhead and enables aggressive optimization
- The approach scales: each specialization is cached, so work is not repeated

**Trade-off:** Binary size can grow for highly generic code. In practice, F# programs
use a bounded set of concrete type instantiations.

**Cross-file fix (Sprint 10c):** Cross-file generic specialization required storing
`(Compiler * MemberDecl)` pairs in the registry rather than string-keyed paths.

## Runtime Helper Tiers

**Decision:** Runtime helper functions are written at three tiers of abstraction, chosen based on complexity:

- **Tier 1 — F# Quotations** (`q "$name" <@ fun params -> body @>`): Preferred for pure/straightforward helpers. The `WasmGcQuotationWalker` translates a `[<ReflectedDefinition>]` F# lambda directly into a `WFuncDecl`. Readable, type-checked by F#, and testable by inspection. Used in `WasmGcRuntime.fs` for all string helpers (26 functions as of Sprint 19c).
- **Tier 2 — CE Builder** (`wasm { let! x = ... }`): For helpers that require labeled-break loops, non-local exits, or multi-phase algorithms that can't be expressed as simple quotations. Available in `WasmGcRuntime.fs`.
- **Tier 3 — Raw WExpr**: Direct `WExpr` construction. Used in `WasmGcReplacements.fs` (BCL replacement code) where inline code generation — not function registration — is required.

**Quotation Walker capabilities (Sprint 19c):**
`let`/`let mutable`, `while`, `for i = lo to hi`, `if/elif/else`, arithmetic (`+`, `-`, `*`, `/`, `%`) for both `int` (i32) and `float` (f64), comparisons (`=`, `<>`, `<`, `<=`, `>`, `>=`), boolean short-circuit (`&&`, `||`, `not`), bitwise operators (`&&&`, `|||`, `^^^`, `<<<`, `>>>`), unary negation (int and float), `abs`, `min`, `max`, `int`/`char` identity conversions, `float` (i32→f64), `wsLen`/`wsGet`/`wsSet`/`wsCreate`/`wsCreateFill`/`wsCopy` phantom intrinsics for WasmStr, float phantom intrinsics (`truncF64`, `absF64`, `negF64`, `intToF64`), and cross-helper calls via phantom functions.

**Key implementation details:**

- `SpecificCall <@ (+) @>` uses `GetGenericMethodDefinition()` — the type annotation in the pattern is irrelevant. Dispatch to `f64` vs `i32` variants is done by checking `a.Type = typeof<float>` at translation time.
- Phantom cross-call functions (e.g. `private intToStr`, `private strConcat`) in `WasmGcRuntime.fs` enable quotations to reference other runtime helpers. The QW translates them as `WExpr.Call("$" + mi.Name, ...)`.
- `WasmGcReplacements.fs` BCL replacements remain in Tier 3. They could register helper functions using Tier 1 in principle, but inline code generation (the common case there) requires direct WExpr construction.

## `return_call` for Tail Calls

**Decision:** F# tail-recursive functions use native Wasm `return_call`, not loop transformation.

**Rationale:**

- `return_call` / `return_call_ref` are standardized in the Wasm tail-call proposal (enabled by default in V8/SpiderMonkey)
- Handles mutual recursion between functions transparently
- No AST-level transformation needed — falls out naturally from emit
- Stack-safe by definition — no stack buildup regardless of recursion depth

## `$AnyFn` Closure Hierarchy

**Decision:** Closures use a `$AnyFn` base struct at type index 0, with one specialized
subtype per closure shape.

**Rationale:**

- WasmGC `call_ref` requires a typed function reference
- Captured variables must be stored in the closure struct (not on Wasm stack)
- Subtyping (`sub`) enables passing any closure as `(ref $AnyFn)` to higher-order functions
- Production quality: same approach used by other mature WASM GC implementations

## Nullable Option Optimization

**Decision:** `Option<'T>` where `'T` is a reference type uses a null reference rather than a wrapper struct.

**Rationale:**

- `None : Option<string>` allocates zero bytes — it is a null reference
- `Some s` is the string reference itself — no wrapper needed
- WasmGC `(ref null T)` types support this natively
- Only value-type options (int, float) need a struct wrapper

**Introduced:** Sprint 10d.

## Clean-Room Development

**Decision:** All code is written from scratch, not ported from other compiler implementations.

**Rationale:**

- Legal clarity — no license contamination from existing compiler codebases
- Intellectual integrity — understanding comes from first principles
- Freedom to evolve the design without constraints from inherited architecture

**Policy:**

- Reading specifications, papers, and blog posts is acceptable
- Copying code from other compilers is not
- See [07-legal-and-cleanroom.md](../docs_original/design/07-legal-and-cleanroom.md) for the full policy

## String Representation

**Decision:** Strings are `(array i32)` — GC-managed arrays of UTF-16 code units as 32-bit values.

**Rationale:**

- WasmGC `(array i32)` is widely supported
- UTF-16 matches .NET's internal string encoding (F# `string` = `System.String` = UTF-16)
- Simplifies interop with F# string operations

**Alternative:** `(array i16)` (packed UTF-16) is available via `WASMGC_STRING_MODE=i16`.
This halves string memory usage at the cost of `array.get_s` sign-extension instructions.
Introduced in Sprint 16 as an opt-in mode.

## LabelGen Architecture

**Decision:** A `LabelGen` class generates unique label names for blocks and loops.

**Rationale:**

- Before Sprint 16, label names were generated ad hoc with string concatenation
- `LabelGen` gives each generated label a descriptive, stable name (e.g., `"for_loop_body"`)
- Makes generated WAT human-readable and debuggable
- Enables `letVal`/`letMut` smart constructors that automatically name intermediate values

**Introduced:** Sprint 16.
