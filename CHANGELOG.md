# Changelog

All notable changes to the compiler are documented here (newest first). The sibling repositories keep their own.

## [Unreleased]

### Added
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

### Changed
- **The F# base library moved to its own repository**, [fsharp-wasm-core](https://github.com/fsharp-wasm/fsharp-wasm-core)
  (`FSharp.Wasm.Core`, Apache-2.0), and is the `core` submodule here; `fable-library-wasmgc/` is gone. One compile list
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
