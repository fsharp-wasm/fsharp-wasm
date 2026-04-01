# fsharp-wasm Documentation

Welcome to the fsharp-wasm documentation. This project compiles F# to WebAssembly GC.

## Guides

| Document | Description |
|----------|-------------|
| [Getting Started](getting-started.md) | Prerequisites, build, first project |
| [Architecture](architecture.md) | Compiler pipeline, design decisions, project structure |
| [WasmGC Backend](wasm-gc-backend.md) | How F# compiles to WasmGC instructions |
| [Type Mapping](type-mapping.md) | F# types → WasmGC types reference |
| [Component Model](component-model.md) | WIT generation, module linking, FFI |
| [FAQ](faq.md) | Frequently asked questions |

## Project Status

| Document | Description |
|----------|-------------|
| [Status](STATUS.md) | Current feature matrix and test results |
| [Roadmap](ROADMAP.md) | Development direction and priorities |

## Reference

| Document | Description |
|----------|-------------|
| [BCL Coverage](bcl-coverage.md) | Supported .NET Base Class Library functions |
| [Design Decisions](design-decisions.md) | Key architectural choices and rationale |

## Historical Design Documents

The original design documents that guided development are preserved in
[docs_original/](../docs_original/). These are reference material — the files in this
folder reflect the current state of the project.
