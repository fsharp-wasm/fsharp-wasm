# Project status

> **Recorded 2026-11-15** at commit `6d8fe71`, with `tests/run-all.sh` and the commands in the table below.
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
| Wasmecto tests (`tests/Wasm`) | a test project written with the Wasmecto framework, compiled to WebAssembly and run in Node: language core, collections, closures, a compiler pipeline smoke test | 81 passed | yes |
| Wasmecto's own tests | the test framework's own tests (`Math`, `Dictionary`, `Stack`, `StringBuilder`) | **does not compile** (7 errors: `StringBuilder.AppendLine(string)`, `Dictionary.SumValues`, `RuntimeHelpers.GetHashCode`, and the `AggregateException` null in the base library's `Task.fs`) | no |

`bash tests/run-all.sh` runs every suite, keeps going after a failure and prints one table (`--list`, `--only a,b`). In the recorded run 11 of 12
suites passed; the one that did not is the framework's own test project (row above). The differential run, the closure fuzz and the pass
tests' random programs add several hundred thousand generated cases to the named tests and checks in the table.

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
- `sprintf "%A"` / `%O` of a record, union, list or tuple (a compile error, not a wrong output), dictionary literals (`dict [ … ]`), a few enumerator cases (`for … in` over a `ResizeArray` through `GetEnumerator`), comparer constructor overloads
- a local function that is generic in its type arguments and whose only evidence of them is its use (`let bind r = match r with Ok v -> Ok (v + 1) | Error e -> Error e`, applied to a `Result<int, string>`) is compiled for `int`: annotate its parameter
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
