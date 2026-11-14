# Project status

> **Recorded 2026-11-14** at commit `2e63a0c`, with `tests/run-all.sh` and the commands in the table below.
> The CI of this repository is the live truth; this page is a dated snapshot of what it covers.

## Test results

| Suite | What it checks | Result | In CI |
| --- | --- | --- | --- |
| QuickTest | language features, collections, strings, closures, numerics, arrays (CI runs it three times: default, unpacked `bool[]`/`byte[]`, with the inlining pass) | 656 passed | yes |
| QuickTestMulti | the same, one compilation per domain (17 domains) | 17/17 domains passed | yes |
| Differential: .NET against wasm | generated inputs through the same F# functions on .NET and as wasm | 392 functions, 183 012 calls: 179 115 identical, 0 disagreements, 3 896 where both sides fail, 1 known difference | yes |
| Showcase | classic algorithms and small programs end to end | 26 passed | yes |
| String ABI (exports) | no `wasm:js-string` import, accessor exports, non-ASCII round trip, empty and null, 10 000 characters | 5 passed | yes |
| Host interop | callbacks, strings and numbers across the boundary, 500 closures called and called again after a GC | 14 passed | yes |
| IR pass tests | the optimiser passes, with property tests over 50 000 generated programs | 27 passed | yes |
| Backend harness | scenarios through the binary encoder and through WAT and wasm-tools; closure fuzz | closure fuzz: 30 720 checks, 0 failures | yes |
| BCL bootstrap | the base library's exceptions and math compiled through the backend | 11 passed | yes |
| Component embed | WIT generation and embedding with wasm-tools | 39 passed | yes |
| Component linking | two modules compiled apart and linked at run time | 22 passed | yes |
| Wasm tests (wasmtime) | a test project compiled to WebAssembly and run in wasmtime | **does not compile** (18 errors); needs wasmtime | no |
| Wasmecto | the test framework's own tests | **the runner expects an older repository layout** | no |

`bash tests/run-all.sh` runs every suite, keeps going after a failure and prints one table (`--list`, `--only a,b`). In the recorded run 10 of 12
suites passed and one was skipped for a runner problem (`FSHARP_WASMECTO_DIR` as an absolute path is looked up below the repository root);
the two rows marked above are open. The named tests and checks above add up to 800; the differential run, the closure fuzz and the pass
tests' random programs add several hundred thousand generated cases.

## Where each area is tested

| Area | Suites |
| --- | --- |
| Language core: let, recursion, tail calls, records, unions, pattern matching, closures, generics | QuickTest, QuickTestMulti (Closures, DU, Primitives), Showcase |
| Collections: List, Array, Map, Set, Seq, ResizeArray, Option, Result | QuickTestMulti (List, Array, Map, Set, Seq, Option, Result), QuickTest |
| Strings and formatting: UTF-16 strings on the GC heap, `sprintf`, `printfn`, interpolation | QuickTestMulti (Strings, StringBuilder, Printf), StringAbi |
| Numerics: 32/64-bit integers, floats, bitwise, Math | QuickTestMulti (Primitives, Bitwise, Math), Differential |
| Exceptions | QuickTestMulti (Exceptions), BCL bootstrap |
| Host boundary: imports, callbacks, the two string ABIs | Host interop, StringAbi |
| Modules and the Component Model | Component embed, Component linking |
| The backend itself: encoder, WAT, validation | Backend harness, IR pass tests |
| Agreement with .NET | Differential |

## Known gaps

Measured while writing tests; each is a program that does not compile or a method that is not mapped yet:

- stepped ranges: `for i in 0 .. 2 .. 9`
- `Array.map not` (a function value of a built-in operator), `Array.concat` of a list of arrays, array slices `a.[1..3]`
- `System.Array.IndexOf`, `Resize`, `Clear`, `Reverse`, `Sort`, `CopyTo`
- `sprintf "%A"`, dictionary literals (`dict [ … ]`), a few enumerator cases (`for … in` over a `ResizeArray` through `GetEnumerator`), comparer constructor overloads
- `async` and JSPI: planned

## Source layout

```text
src/Core/            WType / WExpr / WFunc / WModule (AST.fs), types and registries, diagnostics, unique names
src/Transforms/      Fable AST → WasmGC IR: the main transformer (Fable2Wasm/), the BCL replacements, host interop, list/array/seq operations
src/Patterns/        reusable IR patterns: loops, arrays, lists, closures, vtables
src/Ir/              the IR dump and queries over the IR
src/Emit/            WExpr → instructions, the binary encoder, the WAT printer, the optimiser, the linker, module interfaces
src/Ir/              the IR dump and queries over the IR
src/Pipeline/        the phases between the Fable AST and the emitter: normalising, scope analysis, unique locals, lowering, validation
src/Pipeline.fs      the pipeline: project → IR → .wat / .wasm (wasm-tools parse and validate) → WIT
tools/               the CLI
tests/               the suites above
examples/            component-embed, component-linking
```
