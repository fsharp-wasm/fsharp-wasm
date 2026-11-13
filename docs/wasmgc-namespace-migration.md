# WasmGC namespace migration

This document summarizes the namespace refactor from `Fable.Transforms.WasmGc.*` to `WasmGc.*` across the fsharp-wasm organization.

## New root namespace

- Old: `Fable.Transforms.WasmGc.*`
- New: `WasmGc.*`

### Module map (compiler backend)
- `Fable.Transforms.WasmGc.Pipeline` → `WasmGc.Pipeline`
- `Fable.Transforms.WasmGc.PipelineValidator` → `WasmGc.PipelineValidator`
- `Fable.Transforms.WasmGc.Builder` → `WasmGc.Builder`
- `Fable.Transforms.WasmGc.Runtime.*` → `WasmGc.Runtime.*`
- `Fable.Transforms.WasmGc.Transforms.*` → `WasmGc.Transforms.*`
- `Fable.Transforms.WasmGc.Emit.*` → `WasmGc.Emit.*`

### Projects touched
- `src/` (compiler backend) — all modules updated to `WasmGc.*`
- `tests/Native/**` — imports updated to `WasmGc.*`
- `tools/FSharp.Wasm.Cli/Pipeline.fs` — now calls `WasmGc.Pipeline.compileFile`
- `src/Fable.WasmGc.fsproj` — `<RootNamespace>WasmGc</RootNamespace>`
- `Directory.Build.props` — unified defaults: `net10.0`, `LangVersion=preview`, `Nullable=enable`, `DebugType=embedded`

### What we did NOT change
- Vendor sources under `vendor/` (including `vendor/Fable/**`)
- Other first-party products using their own roots (e.g., `FSharp.Wasm.*`, `FSharp.Graphics.*`, `GlyphAura.*`)

## How to update code

- Replace `open Fable.Transforms.WasmGc.Runtime.Types` with `open WasmGc.Runtime.Types`
- Replace `open Fable.Transforms.WasmGc.Builder` with `open WasmGc.Builder`
- Replace `open Fable.Transforms.WasmGc` with `open WasmGc`
- Replace `Fable.Transforms.WasmGc.Pipeline` with `WasmGc.Pipeline`
- Replace `Fable.Transforms.WasmGc.Emit.*` with `WasmGc.Emit.*`
- Replace `Fable.Transforms.WasmGc.Transforms.*` with `WasmGc.Transforms.*`

Examples
- Before: `module Fable.Transforms.WasmGc.Transforms.Fable2Wasm`
  After:  `module WasmGc.Transforms.Fable2Wasm`

- Before: `open Fable.Transforms.WasmGc.Runtime.Locals`
  After:  `open WasmGc.Runtime.Locals`

## Build notes

- The solution depends on patched F# and patched Fable/FCS. Vendor projects currently fail with nullability/generic constraints under .NET 10, which is expected with in-flight patches. The WasmGC rename does not introduce additional first-party compile errors.
- To build the backend alone: `dotnet build src/Fable.WasmGc.fsproj`

## Next steps (optional)

- Folder layout: consider moving `src/` to `compiler/wasmgc/` and introducing `libs/`, `runtime/`, `graphics/` roots for clarity.
- Packaging: decide whether `AssemblyName`/`PackageId` for `Fable.WasmGc` should be renamed (e.g., `WasmGc` or `FSharp.Wasm.WasmGc`). Keeping as-is avoids consumer breakage for now.
- The F# base library (formerly `fable-library-wasmgc`) is now `FSharp.Wasm.Core` in its own repository, fsharp-wasm-core, consumed here as the `core` submodule. Whether it grows into a full alternative BCL (and with which `System.*` surface) is still open.
