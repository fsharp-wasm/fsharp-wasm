# Changelog

All notable changes to the compiler are documented here (newest first). The sibling repositories keep their own.

## [Unreleased]

### Added
- **`bool[]`, `byte[]` and their ResizeArrays are stored in 8 bits** (`(array (mut i8))`, read with `array.get_u`) instead of 32: a quarter of the memory,
  and the benchmark's sieve — a `bool[]` written with a stride — runs in 44 ms instead of 69 (1.08× JavaScript instead of 0.63×). `getOrAddArrayTypeFor` /
  `getOrAddResizeArrayTypeFor` decide, from the F# element type, which array type a value has; the arrays a library routine makes for itself stay 32-bit.
  `WASMGC_PACKED_BYTES=0` switches it off. Checked: QuickTest 656 of 656 in both layouts (fourteen new tests of byte and bool arrays), the other suites, the
  backend's Ghost Todo module on all eight platforms of its matrix, the widget editor and the scene gallery in Chromium. `sbyte[]` stays 32-bit (it would
  need `array.get_s` and has no user in sight).
- **Inlining of small functions, opt-in** (`WASMGC_INLINE=1`). A call of a small (≤ 30 nodes), non-recursive function whose body has
  no loop, block, join point, return, tail call, closure or exception becomes its body: a `let` per parameter (arguments evaluated
  once, in order) and the callee's locals renamed per expansion. Off by default, because it does not pay where the engine inlines
  itself (V8 and JavaScriptCore: no difference within the noise) and costs code (scene gallery +16 %, widget editor +4.7 %); it is
  there for engines or flags that do not inline (V8 with `--no-wasm-inlining`: spectral norm 47 → 29 ms). QuickTest has six tests of its
  semantics and runs a second time with the pass on in CI.
- **Strings across the host boundary without the JS String Builtins** (`WASMGC_STRING_ABI=exports`). The module imports no
  `wasm:js-string`; a string crosses as an opaque reference and the host reads and builds strings through the exports
  `__str_len` / `__str_at` / `__str_new` / `__str_set`. Platforms that precompile a module without builtins (Cloudflare
  Workers, Vercel Edge) can run it now. `tests/StringAbi`, `docs/host-interop.md`. The default (builtins) is unchanged.
- **Interfaces by name.** A vtable is registered where the interface is declared, its slots are found by member name, an
  interface *property* is read through its getter slot, and object expressions (`{ new I with … }`, with captured
  variables) are built as a closure environment plus vtable.
- **Collections.** `ResizeArray` operations (`Sort`, `Reverse`, slicing, `AddRange`, `Insert`/`RemoveRange`, a `seq` as source,
  as a `seq`), capacity constructors for `Dictionary`, `HashSet`, `Queue`, `Stack`, `List.indexed`, `List.findIndex`,
  `List.tryItem`, `List.ofSeq`, `StringBuilder.Clear`, `StringBuilder.Append` of a `char` or an `int`.
- **Module values are evaluated once.** `let host = Host()` or `let table = [| … |]` lives in a wasm global initialised at
  start-up, in declaration order — it used to be recomputed at every reference (a new object each time).
- **Let-bound generic lambdas** (`let mk id f = f (newNode id)`) are built at the instantiation their uses state.
- **Tuples that are only taken apart** are not allocated: `match d.TryGetValue k with | true, v -> …` reads the out variable in
  the arm that has it (it is null after a miss, and a tuple of non-null references cannot hold that).
- `FSHARP_WASM_CORE_DIR` — a checkout of fsharp-wasm-core for the compiler to use (`FSHARP_WASM_LIBRARY`, the old name of the
  library directory, is still read).

### Fixed
- **`Array.blit` and `System.Array.Copy` did nothing.** Fable asks for the library routines `copyTo` / `copyToArray`; they were an unhandled import call —
  compiled to nothing, with only a warning (WGC002). They are `array.copy` now (overlapping ranges move correctly; out of range traps where .NET throws).
- `List.sortBy` / `sortByDescending` were an insertion sort (O(n²): 80 000 elements took 2 s) and compared keys numerically only, so a string
  key did not compile. They are a stable merge sort over a key array now, ordered by the comparer Fable passes (numbers, strings, structural
  keys), like `Array.sortBy`; reference elements work. `Array.sort`, `sortWith`, `List.sort` and `sortWith` were already merge sorts.
- `for c in s` and `s.ToCharArray()` over a string gave an array of one-character *strings* where `char` is an `i32` (the
  module did not validate); they give a `char` array now (`$strToChars`).
- A string literal pattern, `match s with "" -> … | v -> …`, no longer emits a null compare against the non-null `$strEq`
  (the module did not validate): a null literal in a string comparison is a null check.

### Changed
- **Licence: Apache-2.0** (it was MIT) — `LICENSE`, `NOTICE` (which names the two forks that keep MIT, `vendor/Fable` and `vendor/fsharp`) and the
  package metadata. Versions before this change were published under the MIT License.
- **The F# base library moved to its own repository**, [fsharp-wasm-core](https://github.com/fsharp-wasm/fsharp-wasm-core)
  (`FSharp.Wasm.Core`, Apache-2.0), merged with the System.* library that repository already had (the compiler's `Dictionary` and
  `Stack` are the ones kept), and is the `core` submodule here; `fable-library-wasmgc/` is gone. `bclbootstrap` runs now: the
  submodule has the `Exception.fs` and `Math.fs` it compiles. One compile list
  (`FSharp.Wasm.Core.props`) replaces two; one `Interop.fs` replaces three. The compiler recognises library files by the
  library directory it was given, not by a name in the path.
- Functions of every file that is not the entry project's own are prefixed with the file's name (two modules each with a
  `bounds` no longer collide).
- A tuple is typed by the *declared* types of its elements: `("a", None)` and `("b", Some arr)` are one tuple type.
- Dead duplicates removed: `src/Pipeline/TypeResolver.fs` (a second type mapper with its own `getOrAddRefCellType` and friends that nothing
  called) and `src/Core/Interop.fs` (a third copy of the Fable.Core stubs, already commented out of its project).
- String equality is null-aware (a `string option` is a nullable string); one `getOrAddTupleType` replaces five registrations.

### Fixed
- Wasm validation and run-time failures found by compiling the FSharp.Graphics stack (a 220 KB module): non-nullable
  references set in the branches of a shared match target and read after them; references stored in ref cells (`out`
  arguments) and module globals; `{ s with … }` on a struct record through a `byref` alias; `Append(char)`; `ToString` of a
  `StringBuilder`; an interface property read.
