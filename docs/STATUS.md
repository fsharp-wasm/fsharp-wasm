# Project status

> **Recorded 2026-11-16** at commit `51289ed`, with `tests/run-all.sh` and the commands in the table below.
> The CI of this repository is the live truth; this page is a dated snapshot of what it covers.

## Test results

| Suite | What it checks | Result | In CI |
| --- | --- | --- | --- |
| QuickTest | language features, collections, strings, closures, numerics, arrays (CI runs it three times: default, unpacked `bool[]`/`byte[]`, with the inlining pass) | 675 passed | yes |
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
| Wasmecto's own tests | the test framework's own tests (`Math`, `Dictionary`, `Stack`, `StringBuilder`), compiled against the whole base library and run in Node | 36 passed | yes |
| Dogfood: core libraries (`tests/Dogfood/run.sh core-libs`) | the suites of FSharp.Wasm.Data (JSON, numbers) and FSharp.Wasm.Ui (typed CSS and HTML, the email grid), compiled from fsharp-wasm-core and run in Node | 29 passed (recorded 2026-11-20) | yes |
| Dogfood: newsletter (`tests/Dogfood/run.sh newsletter`) | the newsletter library's suite, and the designer module (an Elmish program on the HTML DSL) compiled, validated, and checked for its `start` export | 53 passed, designer 320 703 bytes (2026-11-20) | yes |

`bash tests/run-all.sh` runs every suite, keeps going after a failure and prints one table (`--list`, `--only a,b`). The differential run, the closure
fuzz and the pass tests' random programs add several hundred thousand generated cases to the named tests and checks in the table.

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

- `System.Array.Reverse`, `Sort`, `Clear` and `Resize` (the front end rejects the static methods: use `Array.rev`, `Array.sort`, `Array.fill`), `System.Array.CopyTo`
- a `seq { yield …; yield … }` that no consumer fuses (`Seq.delay` is not compiled); `for … in` over a `ResizeArray` through `GetEnumerator`
- `sprintf "%A"` / `%O` of a record, union, list or tuple (a compile error, not a wrong output); dictionary literals (`dict [ … ]`); comparer constructor overloads
- `StringBuilder.AppendFormat` with a format that is not a literal or has specifiers (`{0:N2}`): reported as unsupported
- a local function that is generic in its type arguments and whose only evidence of them is its use (`let bind r = match r with Ok v -> Ok (v + 1) | Error e -> Error e`, applied to a `Result<int, string>`) is compiled for `int`: annotate its parameter
- `async` and JSPI: planned
- exceptions as values: an `exn` stored in a list or a record is typed as an integer (`[ System.Exception "x" ]` does not validate); `System.ArgumentException("x")` (a constructor that delegates to the primary one) leaves its second field out; a derived class that adds a field writes it to the base class's field (`inherit EqBase(name)` with an own `size`)
- two modules with the same name in different namespaces (`Browser.Css` of the runtime and a `Css` of another library) share one set of function names (`Css_color`): the first definition wins and a call to the other does not validate; name the modules differently
- an exception with a payload cannot be caught by type: `try … with MyError m -> …` receives no value (the JSON parser of fsharp-wasm-newsletter records its first error instead)

Closed on 2026-11-16, each with tests whose expected values are what .NET computes: ranges with a step in `for`, `seq` and `Seq.iter`; array and string slices
(`a.[1..3]`, `s.[..2]`, `a.[2..]`, clamped like F#); `Array.concat`, `List.concat`; `System.Array.IndexOf`; `StringBuilder.AppendLine`,
`StringBuilder(text)` and `AppendFormat` with a literal; `isNull`.

Closed on 2026-11-19, after the recorded run above (found while building fsharp-wasm-newsletter; ten QuickTests added, 685 pass): structural equality of unions that have a list field
(two unions of different shapes were one type to `ref.test`, so the list dispatcher read the cases of the wrong union: a union's base struct and its
cases are now one `rec` group); equality of lists of class instances whose class has subclasses (it was generated as a case chain over a field that is not a tag, which did not validate; classes compare by reference now) and of
structs that hold function references (an interface's vtable); `List.contains` and `Array.contains` on strings, records and unions (they compared by reference);
`Math.Pow` with a fractional or a negative exponent (the exponent was truncated: `Math.Pow(0.4945, 2.4)` was 0.4945², `Math.Pow(2, -3)` was 1);
`%` on floats (compiled to `unreachable`: the emitter had no float remainder; it is `x - trunc(x / y) * y` now, the sign of the dividend as in .NET); `String.EndsWith` with a suffix that also occurs earlier (it compared the first occurrence with the end: `"6000".EndsWith "0"` was false).
The equality of lists of class instances is exercised by that repository's suite (a Wasmecto project that links the whole base library, which has the `Exception` hierarchy) and not by a QuickTest, because building a derived class in a QuickTest runs into the constructor gap above.

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
