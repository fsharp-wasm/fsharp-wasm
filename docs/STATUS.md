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
| Dogfood: core libraries (`tests/Dogfood/run.sh core-libs`) | the suites of FSharp.Wasm.Data (JSON, numbers), FSharp.Wasm.Ui (typed CSS and HTML, the email grid) and FSharp.Wasm.Edit (operations on a document, history), compiled from fsharp-wasm-core and run in Node | 45 passed (recorded 2026-11-21) | yes |
| Dogfood: newsletter (`tests/Dogfood/run.sh newsletter`) | the newsletter library's suite, and the designer module (an Elmish program on the HTML DSL, with dragging of blocks on `FSharp.Graphics.Interact`) compiled, validated, and checked for its `start` export | 61 passed, designer 379 155 bytes (2026-11-21) | yes |
| Dogfood: widget editor (`tests/Dogfood/run.sh widget-editor`) | the widget editor of fsharp-wasm-ide (the whole FSharp.Graphics stack: Widgets, Scene, Tea, Canvas) compiled as one module, validated, and checked for the exports `runtime/gfx.js` calls | 168 957 bytes, exports present (2026-11-20) | yes |

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
- a `seq { yield …; yield … }` that no consumer fuses (`Seq.delay` is not compiled)
- `sprintf "%A"` / `%O` of a record, union, list or tuple (a compile error, not a wrong output); dictionary literals (`dict [ … ]`); comparer constructor overloads
- `StringBuilder.AppendFormat` with a format that is not a literal or has specifiers (`{0:N2}`): reported as unsupported
- a local function that is generic in its type arguments and whose only evidence of them is its use (`let bind r = match r with Ok v -> Ok (v + 1) | Error e -> Error e`, applied to a `Result<int, string>`) is compiled for `int`: annotate its parameter
- `async` and JSPI: planned
- the Exports string ABI (`WASMGC_STRING_ABI=exports`, what Cloudflare Workers and Vercel Edge need) crosses a string one character per call (`__str_at`, `__str_set`). Measured on 2026-11-22 with the Ghost Todo module (`bench/` of fsharp-wasm-edge, a profile on Node): 42.5 % of the time of a request whose answer is 218 000 characters is in the JS-to-WebAssembly calls, 15.7 % in garbage collection, about a quarter in the module's own code; the module needs 14 to 24 times what hand-written JavaScript needs on Node (9 to 16 on workerd, 44 to 75 on Bun) wherever the answer or the persisted snapshot is long, and 1.7 to 2.4 times on a small answer. A bulk path is not built (the module writes the string into a linear memory it exports, the host reads it with one `TextDecoder` call, and the other way round). A module for the JS String Builtins crosses a string with one call, but those are not available on those platforms; that ABI is not measured against the same workload yet.
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

Closed on 2026-11-20 (686 QuickTests pass; found by compiling the widget editor of fsharp-wasm-ide, which no dogfooding gate covered then; `run.sh widget-editor` does now): a union declared in the program and generic (`Cmd<'Msg>`, the Elm-style command of the widget editor) was mapped to its uninstantiated structs in signatures while constructors and matches used the structs of the instantiation (`Cmd<Msg>`): a function that returned `CmdNone` at a record type declared one type and built another (`type mismatch: expected (ref $type), found (ref (exact $type))`, or `unknown field`). It had only validated while the structs of a union were canonical by shape, which the 2026-11-19 change to one `rec` group per union ended. Signatures use the instantiation now (Types.mapTypeKnown); the QuickTest builds such a union at a record type.

Closed on 2026-11-21 (found by compiling FSharp.Wasm.Edit of fsharp-wasm-core as a referenced project of the test module): a generic function of a library file that calls a private
function of its own file (`Ops.drop` calls `Ops.withoutSource`) was compiled at the call, in another file, with the names of that file; the library file prefixes its functions with
its name, so the call named a function that does not exist (`unknown func: $Ops_withoutSource`; the module did not even validate). The specialisation uses the names of the file
that declares the function now (`Ctx.GenericFuncAliases`). The files of the entry project keep their names, so a QuickTest cannot show it; the Dogfood suite `core-libs` does (it compiles the Edit tests).

Closed on 2026-11-21, the same work (694 QuickTests pass; both are written the natural way in FSharp.Wasm.Edit and its tests now, which the Dogfood suite `core-libs` keeps):
a lambda in an argument that has a type variable of its own (`put` in `insertInto<'i>`: its `None` is `'b option`, and only the parameter type of the callee says what `'b` is) was compiled with
`'b` as an `int` and built another tuple than the callee took (`illegal cast` at run time); the callee's parameter type fixes it now, function types compared curried (QuickTest `lambda argument
with a type variable that only the callee fixes`). And the registry of generic functions, keyed by the plain name, took the wrong function when two files have a private function of the same name
(`show` of Wasmecto's `Expect` and a `show` of a test file: `expected i32, found (ref …)`): it is also keyed by the declaring file, which a call knows (its own file, or the path of the import), and a
specialisation of a function that another declaration shadowed is named with its file.

Closed on 2026-11-21 (696 QuickTests pass; both found by the probes of computation expressions): `for x in resizeArray do …` — F# writes the `GetEnumerator` form, which the backend has no object for, and
FableNormalize left it alone for a ResizeArray (lists, arrays and seqs became an `iterate`): it is an `iterate` over the elements 0 … Count - 1 now, compiled by ResizeArrayOps. And `IDisposable.Dispose` was a no-op
(`use`, `(x :> IDisposable).Dispose()` and a builder's `Using` ran no cleanup): Fable calls all three `disposeSafe`, which calls the `Dispose` slot of the class's vtable now, nothing for null; `use` of a type that is not
sealed is `if (x :? IDisposable) then x.Dispose()` in F#, and that type test on an interface was the constant false: it tests the box of the interface and the classes that implement it.

Closed on 2026-11-21 (found by the newsletter designer, which measures the drop targets of a page through `measureSlots (cb: float -> float -> float -> float -> float -> float -> unit)`): a callback handed to
the host took at most four arguments (`WGC011`), the width of the export `__cb`. It takes eight now, and `__cb` is as wide as the widest callback the program passes (four at least, so a module that never needed more
keeps its export). The suite `tests/HostInterop` passes a callback with six and one with eight arguments (it failed to compile before).

Closed on 2026-11-21 (697 QuickTests pass; found by FSharp.Wasm.Icons of fsharp-wasm-core, whose check of a name is `name |> Seq.forall …`): a string used as a `seq<char>` (`s |> Seq.exists`, `Seq.filter`, `Seq.map`
and the rest of the module, and any `seq<char>` parameter) was passed on as the string itself, and the list code that a seq stands for cast it to a list cell: the module did not validate. The cast of a string to a
seq is a list of its characters now, as the cast of an array is a list of its elements (`coerceToSeq`); the diagnostic that said "string does not convert yet" was never reached on this path.

Closed on 2026-11-21 (698 QuickTests pass; found by the widget editor of fsharp-wasm-ide, which compares a drag session): structural equality of `bool[]` and `byte[]` (arrays of i8, alone, in a record, in a
list) compared the elements as references, and the module did not validate (`expected ref but found i32`). The elements of a packed array are read as i32, as every other read of it does, and compared as numbers
(`makeArrayEqualsFunc`).

Closed on 2026-11-22 (699 QuickTests pass; found by compiling the canvas client of the Ghost Todo of fsharp-wasm-backend, whose shadow of the server's list does `Result.map` into another type): `Result.map` and
`Result.bind` whose function changes the type of the Ok value (`Result<Todo list,E>` to `Result<Shadow,E>`) built the Ok case of the *input's* instantiation of the union and returned the input's Error object as
the output's. Every instantiation of a union is its own set of structs, so the module did not validate (`expected (ref null $type), found (ref (exact $type))`). The Ok is built in the output's struct and an
Error is rebuilt in it (`tryResultInline`: the case structs follow the base, Ok at +1 and Error at +2); a result that keeps its type still returns the Error value as it is. The call is not inlined when the
error type is unit (the struct has no payload field).

Measured on 2026-11-21 (693 QuickTests pass, in all three modes): what a stack of DSLs needs from the compiler. User-defined computation expression builders
(`result` and `option` with `Bind`/`Return`/`ReturnFrom`, a view DSL with `Yield`/`Zero`/`Delay`/`Combine`/`For`/`Run` in which attributes and children are yielded
and elements nest by calling another builder), builders with `inline` members and `InlineIfLambda`, `[<CustomOperation>]` (a query-like DSL), list, array and seq
comprehensions with guards, and statically resolved member constraints (`inline` numeric helpers) all compile and give what .NET gives (seven QuickTests, `ce:`).
The same probes confirmed two gaps that were already listed (`for … in` over a `ResizeArray`, a `seq { yield …; yield … }` nothing fuses) and found one new one (`IDisposable.Dispose`, above).

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
