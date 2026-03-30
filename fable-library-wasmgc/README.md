# fable-library-wasmgc — BCL Surface Reference

> **Status:** Sprint 16 (June 2026) — 337/337 QuickTests passing  
> BCL support is implemented as **inline replacements** in `WasmGcReplacements.fs` and  
> **runtime helpers** in `WasmGcRuntime.fs`. No separate BinaryDependency is needed.

---

## How BCL Functions Are Implemented

There are two implementation tiers:

| Tier       | What                                                           | Where                                       | Notes                                        |
| ---------- | -------------------------------------------------------------- | ------------------------------------------- | -------------------------------------------- |
| **Inline** | F# primitive ops → direct WasmGC instructions at the call site | `WasmGcReplacements.fs` + `Fable2WasmGc.fs` | Zero overhead, no function call              |
| **Helper** | Non-trivial algorithms → `WFuncDecl` emitted once per module   | `WasmGcRuntime.fs` (demand-driven)          | Called with `WExpr.Call("$helperName", ...)` |

Helpers are demand-driven: a helper is only emitted if `ctx.UseHelper("$helperName")` is called during translation.

---

## Supported BCL Operations

### `System.Math`

| F# / .NET                 | WasmGC Instruction        | Notes           |
| ------------------------- | ------------------------- | --------------- |
| `Math.Abs(f: float)`      | `f64.abs`                 | inline          |
| `Math.Abs(f: float32)`    | `f32.abs`                 | inline          |
| `Math.Abs(n: int)`        | `i32 select(n, -n, n>=0)` | inline          |
| `Math.Abs(n: int64)`      | `i64 select`              | inline          |
| `Math.Sqrt(f: float)`     | `f64.sqrt`                | inline          |
| `Math.Floor(f: float)`    | `f64.floor`               | inline          |
| `Math.Ceiling(f: float)`  | `f64.ceil`                | inline          |
| `Math.Truncate(f: float)` | `f64.trunc`               | inline          |
| `Math.Round(f: float)`    | `f64.nearest`             | inline          |
| `Math.Min(a, b: float)`   | `f64.min`                 | inline          |
| `Math.Max(a, b: float)`   | `f64.max`                 | inline          |
| `Math.Min(a, b: int)`     | `i32 select`              | inline          |
| `Math.Max(a, b: int)`     | `i32 select`              | inline          |
| `Math.Sign(n: int)`       | `i32 select(select...)`   | inline          |
| `Math.Pow(x, y: float)`   | ❌ not yet                |                 |
| `Math.Log(x: float)`      | ❌ not yet                |                 |
| `Math.PI`                 | `f64.const 3.141592...`   | inline constant |

---

### `System.String`

String runtime type: `(array (mut i32))` — UTF-16 code units as 32-bit integers.  
Optional: `WASMGC_STRING_MODE=i16` switches to packed `(array (mut i16))` — 50% smaller
for ASCII-heavy workloads (Sprint 16+).

| F# / .NET                                 | Method / Helper          | Inline?              |
| ----------------------------------------- | ------------------------ | -------------------- |
| `String.length s` / `s.Length`            | `array.len`              | ✅ inline            |
| `s.[i]` / `String.item i s`               | `array.get`              | ✅ inline            |
| `s + t` / `String.concat s t`             | `$strConcat`             | helper               |
| `s = t` / `String.op_Equality`            | `$strEq`                 | helper               |
| `s <> t`                                  | `$strEq` + `i32.eqz`     | helper               |
| `s.Contains(sub)` / `String.contains`     | `$strIndexOf` ≥ 0        | helper               |
| `s.IndexOf(sub)` / `String.indexOf`       | `$strIndexOf`            | helper               |
| `s.LastIndexOf(sub)`                      | `$strLastIndexOf`        | helper               |
| `s.Substring(start)` / `String.substring` | `$strSubstring`          | helper               |
| `s.Substring(start, len)`                 | `$strSubstring`          | helper               |
| `s.Replace(from, to)`                     | `$strReplace`            | helper               |
| `s.Trim()` / `String.trim s`              | `$strTrim`               | helper               |
| `s.TrimStart()`                           | `$strTrimStart`          | helper               |
| `s.TrimEnd()`                             | `$strTrimEnd`            | helper               |
| `s.ToLower()` / `s.ToLowerInvariant()`    | `$strToLower`            | helper               |
| `s.ToUpper()` / `s.ToUpperInvariant()`    | `$strToUpper`            | helper               |
| `s.StartsWith(prefix)`                    | `$strIndexOf` = 0        | inline-ish           |
| `s.EndsWith(suffix)`                      | `$strLastIndexOf` check  | inline-ish           |
| `s.Split(char)` / `s.Split(string[])`     | `$strSplit`              | helper               |
| `String.Join(sep, parts)`                 | `$strJoin`               | helper               |
| `string (n: int)` / `sprintf "%d" n`      | `$intToStr`              | helper               |
| `string (f: float)` / `sprintf "%f" f`    | `$floatToStr`            | helper               |
| `string (c: char)` / `sprintf "%c" c`     | inline `array.new_fixed` | inline               |
| `sprintf "%s" s`                          | identity                 | inline               |
| `sprintf "%d/%s/..."`                     | multi-format expand      | inline-expanded      |
| `$"interp {x}"` (string interpolation)    | `interpolate`            | inline-expanded      |
| `printfn "%d..." x`                       | `toText` + console       | helper               |
| `Int32.Parse(s)` / `int s`                | `$parseInt`              | helper               |
| `Double.Parse(s)` / `float s`             | `$parseFloat`            | helper               |
| `Int32.TryParse(s, &n)`                   | ❌ not yet (byref)       |                      |
| `String.IsNullOrEmpty(s)`                 | len = 0 check            | inline               |
| `String.IsNullOrWhiteSpace(s)`            | `$strTrim` + len         | helper               |
| `s.PadLeft(n)` / `s.PadLeft(n, c)`        | `$strPadLeft`            | helper               |
| `s.PadRight(n)` / `s.PadRight(n, c)`      | `$strPadRight`           | helper               |
| `s.[lo..hi]` (slice)                      | `$strSubstring`          | helper               |
| `s.ToCharArray()`                         | identity (is array)      | inline               |
| `String.replicate n s`                    | `$strReplicate`          | helper               |
| `String.init n f`                         | inline loop              | inline               |
| `String.forall pred s`                    | inline loop              | inline               |
| `String.exists pred s`                    | inline loop              | inline               |
| `String.map f s`                          | `$strMapHelper`          | helper (via closure) |
| `String.collect f s`                      | ❌ not yet               |                      |
| `String.compare s t` / `compare s t`      | `$strCompare`            | helper               |
| `String.compareOrdinal`                   | `$strCompare`            | helper               |

---

### `System.Char`

Chars are `i32` (WasmGC has no native char type).

| F# / .NET                 | Implementation                     |
| ------------------------- | ---------------------------------- | --- | -------------------------------- |
| `Char.IsDigit(c)`         | `c >= '0' && c <= '9'` (inline)    |
| `Char.IsLetter(c)`        | `(c >= 'a' && c <= 'z')            |     | (c >= 'A' && c <= 'Z')` (inline) |
| `Char.IsUpper(c)`         | `c >= 'A' && c <= 'Z'` (inline)    |
| `Char.IsLower(c)`         | `c >= 'a' && c <= 'z'` (inline)    |
| `Char.IsWhiteSpace(c)`    | `c <= 32` (inline, ASCII only)     |
| `Char.IsLetterOrDigit(c)` | combined (inline)                  |
| `Char.ToLower(c)`         | `if A-Z then c+32 else c` (inline) |
| `Char.ToUpper(c)`         | `if a-z then c-32 else c` (inline) |
| `Char.IsPunctuation(c)`   | ❌ not yet                         |
| `Char.IsControl(c)`       | ❌ not yet                         |

---

### `Microsoft.FSharp.Core.Option`

| F# Operation                      | Notes                       |
| --------------------------------- | --------------------------- | ------------------------ |
| `Some x`                          | ✅ struct boxing / nullable |
| `None`                            | ✅ null ref (zero-alloc)    |
| `Option.isSome` / `Option.isNone` | ✅ null check               |
| `Option.get` / `Option.value`     | ✅ deref                    |
| `Option.map f`                    | ✅ inline                   |
| `Option.bind f`                   | ✅ inline                   |
| `Option.filter pred`              | ✅ inline                   |
| `Option.defaultValue x`           | ✅ inline                   |
| `Option.defaultWith thunk`        | ✅ inline                   |
| `Option.orElse`                   | ❌ not yet                  |
| `Option.orElseWith`               | ❌ not yet                  |
| `match x with Some v -> ...       | None -> ...`                | ✅ full pattern matching |

---

### `Microsoft.FSharp.Core.Result`

| F# Operation              | Notes           |
| ------------------------- | --------------- | --- |
| `Ok x`                    | ✅ DU           |
| `Error e`                 | ✅ DU           |
| `Result.isOk` / `isError` | ✅ tag check    |
| `Result.map f`            | ✅ inline       |
| `Result.mapError f`       | ✅ inline       |
| `Result.bind f`           | ✅ inline       |
| `Result.defaultValue x`   | ✅ inline       |
| `Result.defaultError x`   | ✅ inline       |
| `match r with Ok v -> ... | Error e -> ...` | ✅  |

---

### `Microsoft.FSharp.Collections.List`

| F# Operation                    | Notes                        |
| ------------------------------- | ---------------------------- |
| `[ 1; 2; 3 ]` literals          | ✅ cons chain                |
| `head :: tail` construction     | ✅                           |
| `List.head` / `List.tail`       | ✅                           |
| `List.isEmpty`                  | ✅                           |
| `List.length`                   | ✅                           |
| `List.item n`                   | ✅                           |
| `List.rev`                      | ✅                           |
| `List.append` / `@`             | ✅                           |
| `List.map f`                    | ✅                           |
| `List.mapi f`                   | ✅                           |
| `List.filter f`                 | ✅                           |
| `List.fold f acc`               | ✅                           |
| `List.foldBack f acc`           | ✅                           |
| `List.reduce f`                 | ✅                           |
| `List.iter f`                   | ✅                           |
| `List.iteri f`                  | ✅                           |
| `List.exists pred`              | ✅                           |
| `List.forall pred`              | ✅                           |
| `List.contains x`               | ✅                           |
| `List.find pred`                | ✅                           |
| `List.tryFind pred`             | ✅                           |
| `List.findIndex pred`           | ✅                           |
| `List.tryFindIndex pred`        | ✅                           |
| `List.head` (tryHead)           | ✅                           |
| `List.last`                     | ✅                           |
| `List.sum`                      | ✅                           |
| `List.sumBy f`                  | ✅                           |
| `List.min` / `List.max`         | ✅                           |
| `List.minBy f` / `List.maxBy f` | ✅                           |
| `List.sort`                     | ✅ (insertion sort on array) |
| `List.sortDescending`           | ✅                           |
| `List.sortBy f`                 | ✅                           |
| `List.collect f`                | ✅                           |
| `List.choose f`                 | ✅                           |
| `List.skip n`                   | ✅                           |
| `List.take n`                   | ✅                           |
| `List.init n f`                 | ✅                           |
| `List.replicate n x`            | ✅                           |
| `List.concat`                   | ✅                           |
| `List.truncate n`               | ❌ not yet                   |
| `List.distinct`                 | ❌ not yet                   |
| `List.zip`                      | ❌ not yet                   |
| `List.unzip`                    | ❌ not yet                   |
| `List.pairwise`                 | ❌ not yet                   |
| `List.groupBy f`                | ❌ not yet                   |

---

### `Microsoft.FSharp.Collections.Array`

| F# Operation                  | Notes      |
| ----------------------------- | ---------- | ----------- | --- |
| `[                            | 1; 2; 3    | ]` literals | ✅  |
| `arr.[i]`                     | ✅         |
| `arr.[i] <- v`                | ✅         |
| `Array.length arr`            | ✅         |
| `Array.get arr i`             | ✅         |
| `Array.set arr i v`           | ✅         |
| `Array.create n v`            | ✅         |
| `Array.zeroCreate n`          | ✅         |
| `Array.init n f`              | ✅         |
| `Array.copy arr`              | ✅         |
| `Array.fill arr s l v`        | ✅         |
| `Array.map f arr`             | ✅         |
| `Array.mapi f arr`            | ✅         |
| `Array.filter f arr`          | ✅         |
| `Array.fold f acc arr`        | ✅         |
| `Array.iter f arr`            | ✅         |
| `Array.iteri f arr`           | ✅         |
| `Array.exists pred`           | ✅         |
| `Array.forall pred`           | ✅         |
| `Array.reduce f arr`          | ✅         |
| `Array.min` / `Array.max`     | ✅         |
| `Array.minBy f` / `maxBy f`   | ✅         |
| `Array.sort arr`              | ✅         |
| `Array.sortDescending arr`    | ✅         |
| `Array.sortBy f arr`          | ✅         |
| `Array.append a b`            | ✅         |
| `Array.choose f arr`          | ✅         |
| `Array.collect f arr`         | ✅         |
| `Array.find pred`             | ✅         |
| `Array.tryFind pred`          | ✅         |
| `Array.contains x`            | ✅         |
| `Array.sum` / `Array.sumBy f` | ✅         |
| `Array.indexed`               | ❌ not yet |
| `Array.zip`                   | ❌ not yet |
| `Array.unzip`                 | ❌ not yet |

---

### Tuples

| F# Operation         | Notes               |
| -------------------- | ------------------- |
| `(a, b)` 2-tuples    | ✅ WasmGC struct    |
| `(a, b, c)` 3-tuples | ✅ WasmGC struct    |
| Larger tuples        | ✅ up to 8 elements |
| `fst t` / `snd t`    | ✅ field access     |
| `let (a, b) = t`     | ✅ destructuring    |

---

### Records

| F# Operation                     | Notes                          |
| -------------------------------- | ------------------------------ |
| `type R = { X: int }` definition | ✅ → WasmGC struct with fields |
| `{ X = 5 }` construction         | ✅ `struct.new`                |
| `r.X` field access               | ✅ `struct.get`                |
| `{ r with X = 7 }` copy-update   | ✅ copy all fields then patch  |
| Mutable fields `mutable X: int`  | ✅ `struct.set`                |
| Structural equality `r1 = r2`    | ✅ generated `$equals_N`       |
| Recursive records                | ✅ via type index              |

---

### Discriminated Unions

| F# Operation                               | Notes                             |
| ------------------------------------------ | --------------------------------- | ------------------------- | --- | --------------------------- |
| Simple tags `                              | A                                 | B                         | C`  | ✅ tag field in base struct |
| DU with data `                             | Ok of T`                          | ✅ polymorphic sub-struct |
| `match du with`                            | ✅ full pattern matching          |
| Nested patterns                            | ✅                                |
| Guard conditions                           | ✅                                |
| `                                          | \_ ->` wildcard                   | ✅                        |
| Structural equality                        | ✅ via `$equals_N` per-type       |
| Generic DUs (`Result<T,E>`, `Choice<T,U>`) | ✅ demand-driven monomorphization |

---

### Closures & Higher-Order Functions

| F# Feature             | Notes                                  |
| ---------------------- | -------------------------------------- |
| Lambda `fun x -> ...`  | ✅ `$AnyFn` subtype + `call_ref`       |
| Function application   | ✅ `call_ref` via closure dispatch     |
| Partial application    | ✅ closure captures env                |
| Recursive functions    | ✅ `return_call` for proper tail calls |
| Mutual recursion `and` | ✅                                     |
| Curried functions      | ✅ via multi-level closures            |

---

### Integers and Arithmetic

| Type                                  | Supported ops                                                             |
| ------------------------------------- | ------------------------------------------------------------------------- |
| `int`                                 | `+`, `-`, `*`, `/`, `%`, `<`, `>`, `=`, `<>`, `<=`, `>=`, bitwise, shifts |
| `int64`                               | same; maps to WasmGC `i64`                                                |
| `int8` / `int16` / `uint8` / `uint16` | promoted to `i32`, truncated on assignment                                |
| `float` / `double`                    | `+`, `-`, `*`, `/`, comparisons, all Math.\* ops                          |
| `float32`                             | same; maps to WasmGC `f32`                                                |

---

### Known Limitations

| Feature                       | Status                            |
| ----------------------------- | --------------------------------- |
| `Map<'K,'V>` generic          | ❌ only `int` map via `Map.fs`    |
| `Set<'T>` generic             | ❌ not yet                        |
| `Dictionary<K,V>`             | ❌ not yet                        |
| `seq { }` / `IEnumerable<T>`  | ❌ not yet (no lazy evaluation)   |
| `async { }` / Tasks           | ❌ Sprint 18+                     |
| `try / with` typed exceptions | ❌ (basic TryCatch works)         |
| Interface dispatch / vtables  | ❌ Sprint 17+                     |
| Reflection                    | ❌ by design                      |
| `Int32.TryParse` (byref)      | ❌ byref not yet supported        |
| `Regex`                       | ❌ not yet                        |
| `DateTime` / `TimeSpan`       | ❌ not yet                        |
| `Console.ReadLine()`          | ❌ (no stdin in Wasm without FFI) |

---

## F# Library Files in This Directory

| File         | Purpose                                                                  |
| ------------ | ------------------------------------------------------------------------ |
| `Interop.fs` | Wasm FFI stubs — `[<Import>]` + `nativeOnly` bindings for host functions |
| `Map.fs`     | `Map<int, int>` BST — prototype for generic `Map<'K,'V>` (Sprint 17+)    |

### Adding a new BCL function

1. **Simple/inline**: Add a case in `WasmGcReplacements.fs` or `Fable2WasmGc.fs`
2. **Complex runtime helper**: Add `makeXxxHelper () : WFuncDecl` to `WasmGcRuntime.fs`,
   register in the `allHelpers` map, call `ctx.UseHelper("$xxx")` at translation time
3. **F# library**: Write an `.fs` file here, add to `Fable.WasmGc.fsproj` compile order,
   handle `Import` nodes in `Fable2WasmGc.fs` via `KnownFuncsByPath`

---

## String Mode Compiler Switch

Since Sprint 16, you can switch string storage from wide `i32` to packed `i16`:

```bash
WASMGC_STRING_MODE=i16 dotnet fable --lang wasmgc MyProject.fsproj
```

- `i32` (default): each code unit stored as 32-bit — broadest runtime support
- `i16`: each code unit stored as 16-bit — 50% smaller strings; uses `array.get_s` on read.  
  Requires a runtime that supports packed i16 array types (Chrome 120+, Node.js 22+).

The `WASMGC_STRING_MODE` env var is read once at startup in `WasmGcPipeline.fs`.
