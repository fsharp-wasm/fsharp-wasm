# Contributing to fsharp-wasm

Thank you for considering contributing to fsharp-wasm! This project compiles F# to WebAssembly GC,
and we welcome contributions of all kinds — bug reports, feature implementations, documentation
improvements, and test cases.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).
By participating, you agree to uphold a welcoming, inclusive, and harassment-free environment.

## Getting Started

### Prerequisites

| Tool       | Version | Purpose                                      |
| ---------- | ------- | -------------------------------------------- |
| .NET SDK   | 10.0+   | Build the compiler                           |
| Node.js    | 22+     | Run Wasm test harnesses                      |
| wasm-tools | 1.245+  | Binary validation (optional but recommended) |

### Setup

```bash
git clone https://github.com/fsharp-wasm/fsharp-wasm.git
cd fsharp-wasm
dotnet build src/Fable.WasmGc.fsproj
```

### Running Tests

Always run the full test suite before submitting a PR:

```bash
# Unit tests
cd tests/QuickTest && bash run.sh && cd ../..

# Showcase tests (real-world algorithms)
cd tests/Showcase && bash run.sh && cd ../..

# Component model examples
cd examples/component-embed && bash run.sh && cd ../..
cd examples/component-linking && bash run.sh && cd ../..
```

All tests must pass. If you add a new feature, add corresponding tests to `QuickTestWasmGc.fs`.

## How to Contribute

### Reporting Bugs

1. Check [existing issues](https://github.com/fsharp-wasm/fsharp-wasm/issues) first
2. Open a new issue with:
   - F# source code that triggers the bug
   - Expected vs. actual behavior
   - Output of `dotnet --version` and `node --version`
   - The generated `.wat` file if available (in `output/`)

### Submitting Code

1. **Fork** the repository
2. **Create a branch** from `main`:
   ```bash
   git checkout -b feature/my-feature
   ```
3. **Make your changes** — keep commits focused and atomic
4. **Run all tests** — every test must pass
5. **Open a Pull Request** with a clear description of what changed and why

### What Makes a Good PR

- **One concern per PR** — don't mix unrelated changes
- **Tests included** — add test cases to `tests/QuickTest/QuickTestWasmGc.fs` for new features
- **Passes CI** — all test suites green
- **Clear commit messages** — explain _what_ and _why_, not _how_

## Project Structure

Understanding the codebase:

```
src/
├── WasmGc.AST.fs             # IR types: WType, WExpr, WConst, WModule
├── WasmGcPipeline.fs         # Entry point, WIT generation
├── Runtime/
│   ├── WasmGcTypes.fs        # Ctx record, type registries
│   ├── WasmGcBuilder.fs      # CE builder (wasm { }) + smart constructors
│   ├── WasmGcRuntime.fs      # makeFunc + runtime helpers
│   ├── WasmGcFreeVars.fs     # Free variable analysis for closures
│   ├── WasmGcLoopHelpers.fs  # List/array loop helpers
│   └── WasmGcLoopCombinators.fs # Composable traversals
├── Transforms/
│   ├── Fable2WasmGc.fs       # Main Fable AST → WasmGC IR
│   └── WasmGcReplacements.fs # BCL inline replacements
└── Emit/
    ├── WasmGcOptimize.fs     # Optimization passes
    ├── WasmGcWat.fs          # WAT text emitter
    ├── WasmGcEmit.fs         # WExpr → Instr lowering
    └── WasmGcEncoder.fs      # Binary .wasm encoder
```

### Key Concepts

- **`WExpr`** — The intermediate representation. All F# constructs are lowered to `WExpr` nodes.
- **`Ctx`** — The compilation context, threaded through the pipeline. Holds type registries, function tables, and compilation state.
- **`wasm { }` CE** — Computation expression builder used in `WasmGcRuntime.fs` for readable IR construction. Not used in `WasmGcReplacements.fs` (by design — replacements stay as plain `WExpr`).
- **Monomorphization** — Generics are specialized at each call site. No runtime type parameters.

### Where to Add Things

| You want to...                                 | Edit this file                             |
| ---------------------------------------------- | ------------------------------------------ |
| Add a new BCL function (List._, Array._, etc.) | `Transforms/WasmGcReplacements.fs`         |
| Handle a new Fable AST node                    | `Transforms/Fable2WasmGc.fs`               |
| Add a runtime helper function                  | `Runtime/WasmGcRuntime.fs`                 |
| Add a new WasmGC type                          | `WasmGc.AST.fs` + `Runtime/WasmGcTypes.fs` |
| Fix binary encoding                            | `Emit/WasmGcEncoder.fs`                    |
| Fix WAT text output                            | `Emit/WasmGcWat.fs`                        |
| Add an optimization pass                       | `Emit/WasmGcOptimize.fs`                   |
| Add a test                                     | `tests/QuickTest/QuickTestWasmGc.fs`       |

## Coding Conventions

### F# Style

- Standard F# formatting conventions
- `camelCase` for functions and locals, `PascalCase` for types and modules
- Use pattern matching over if/else chains where it improves clarity
- Prefer immutable data; use `mutable` only when necessary for performance

### IR Construction

- In `WasmGcReplacements.fs`: construct `WExpr` directly (no CE)
- In `WasmGcRuntime.fs`: use `wasm { }` CE with `let!` for typed expressions, `do!` for void side-effects
- Use `wasmIf` (not `wasmWhen`) in loops to avoid infinite-loop bugs
- Always provide type annotations where WasmGC needs them (struct field types, function signatures)

### Naming

- Wasm function names: `$moduleStem_functionName` for library functions
- Test functions: `quickTest<Feature><Case>` pattern — auto-exported by name
- Type names: `$TypeName` with `$` prefix in WAT

### Commit Messages

```
Short summary (imperative mood, ≤72 chars)

Longer description if needed. Explain the motivation,
not the implementation (the diff shows the implementation).

Fixes #123
```

## Architecture Decisions

Important design decisions are documented in:

- [docs/architecture.md](docs/architecture.md) — Pipeline and structure
- [docs_original/design/](docs_original/design/) — Historical design documents

If you want to propose a significant architectural change, please open an issue first to discuss it.

## Clean-Room Policy

This project follows a clean-room development methodology. Do **not** copy code from other
compiler backends (OCaml's `wasm_of_ocaml`, Kotlin/Wasm, Dart/Wasm GC, etc.).

It is acceptable to:

- Read public specifications (W3C WasmGC spec, Component Model spec)
- Study published papers and blog posts about compilation techniques
- Reference open-source projects for understanding approaches (with attribution)

It is **not** acceptable to:

- Copy-paste code from other compilers
- Translate code line-by-line from another language

See [docs_original/design/07-legal-and-cleanroom.md](docs_original/design/07-legal-and-cleanroom.md) for details.

## Getting Help

- Open a [Discussion](https://github.com/fsharp-wasm/fsharp-wasm/discussions) for questions
- Check [docs/faq.md](docs/faq.md) for common questions
- Read the [Architecture docs](docs/architecture.md) before diving into the code

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
