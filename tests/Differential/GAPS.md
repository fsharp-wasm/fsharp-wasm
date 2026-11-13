# Gaps found by the differential / property tests

Each entry is something the backend does NOT do (or does differently from .NET) that a property exposed.
A gap is closed when its property goes back into `Props/*.fs` and the comparison is clean.

| Property | Construct | Symptom | Status |
|---|---|---|---|
| `prop_s_concatMany`, `prop_s_replicate` | `String.concat sep (list)`, `String.replicate`, `String.Join(sep, list)` | `$strJoin` took a string ARRAY; a list reached it → wasm validation error | fixed: `$strJoinList` |
| `PropsInt64` | `string (int64)` | no `$int64ToStr` helper: an int64 was printed through a 32-bit conversion | fixed: `$int64ToStr` |
| (not written yet) | `float (uint64)` / `float (uint32)` above 2^63 | no unsigned convert opcode in the AST | open |
| (not written yet) | `%g` / `%e` formats | approximated | open |
| `prop_rem` | `Int32.MinValue % -1` | .NET raises, wasm returns 0 | known difference, kept (see known-differences.txt) |

## Found and fixed by the list / array / closure properties (`PropsLists.fs`)

Each of these was silently WRONG or did not compile; the property is what showed it.

| Construct | Was | Now |
|---|---|---|
| `Array.sortDescending`, `sortBy`, `sortByDescending` | sorted ascending by the ELEMENT (direction and key ignored) | comparer-driven stable keyed sort; `sortInPlace(By)` too |
| `Array.sumBy` / `minBy` / `maxBy` | projection ignored | projection applied once per element; first extreme wins, `<` / `>` semantics (NaN never wins) |
| `Array.min` / `max` on floats | `f64.min` / `max` (NaN propagates) | F# comparison semantics; strings / records / tuples compare structurally |
| `List.sum` / `sumBy` / `Array.sum` on ints | wrapped around | `Checked.(+)`: OverflowException, as FSharp.Core |
| `xs @ ys` | reversed `ys` | rev xs, cons onto ys |
| `=` / `<>` / `compare` on lists | `=` always true | per-element-type walkers behind a dispatcher (`$equals_list_vN`, `$compare_list_vN`) |
| `=` on arrays; fields of a record / union that are lists / arrays / records | reference equality | structural (`$equals_N` for arrays, nested types registered on demand) |
| `let rec f = fun … f …` (local, single binding) | "unresolved identifier f" | routed to `buildLetRecLambdas` (Fable folds a single `let rec` into a plain `Let`) |
| anonymous records `{| a = 1 |}` | no backend support | the tuple struct of the declared field types (fields are name-sorted) |
| `[ a .. b ]`, `[ for … do … yield … ]`, `Seq.toList/toArray` over `delay/collect/map/filter/append/singleton/empty` | not compiled | fused into loops (`SeqFusion.fs`), no IEnumerator |
| `Array.tryFindIndex`, `List.tryHead/tryFind` | wrapper struct even for reference elements; `tryFindIndex` returned a bare int | one option representation (`optionRepr`): non-null reference = itself, else `Option_N` box |
| `List.take/skip/item/replicate`, `Array.take/skip/sub` with bad counts | silently clamped | raise like .NET (`skip` / `truncate` keep their lenient rules) |
| `List.windowed`, `List.distinct`, `Array.ofList`, `Array.foldBack`, `Array.sub`, `Array.find/tryFind/tryItem/tryLast/take/skip/truncate/where`, `List.find/truncate` | unhandled import → invalid module | handlers |

## Found and fixed by the generics properties (`PropsGenerics.fs`)

| Construct | Was | Now |
|---|---|---|
| generic record `Box<'T>` used at `float`, `string`, records … | one struct for every instantiation, field typed `i32` → invalid module | one struct per instantiation (`registerGenericRecord`, same scheme as generic unions) |
| `List.map f xs` / `Array.fold f …` with `f` a closure parameter or a named function | handlers only matched literal lambdas → unhandled import | `UnaryLambda` / `BinaryLambda` eta-expand function values (identifiers / imports only, so nothing is evaluated twice) |
| `nan`, `infinity`, `Double.MaxValue` | "unresolved identifier Number" | constants |
| arrays of references (`(string * int)[]`, `string[]`, records) | `array.new` with a null initialiser into a non-null element type → invalid module | element type is always nullable, reads are cast (`arrayGet`) — one array type per element type |
| abstract class / interface implemented only partially (default member in the base class) | compiler crash (`index out of range`) | error `WGC011` naming the type; proper virtual dispatch is M2 |

## Performance work driven by `tests/Bench` (see the table the CI prints)

| Finding | Change |
|---|---|
| array / list sorts were insertion sorts: `bench_sort` 26× slower than .NET | stable bottom-up merge sort (`mergeSortKeyed`), keyed variant permutes a parallel key array; `bench_sort` ≈ .NET |
| list pipelines allocated twice per stage (build reversed, copy-reverse); V8 allocates a cons for ~70–90 ns | cons tails are mutable; fresh accumulators are reversed in place (`listRevInPlace`) |
| `[1 .. n] \|> List.map f \|> List.filter g \|> List.fold h 0` built three lists | `SeqFusion`: the chain is ONE loop when the stages are pure (strict lists: an impure stage must run to completion first, so it is never fused); `FableNormalize.finishDeclaration` floats nested lets and inlines single-use stream intermediates so the chain is visible; `bench_list` 15× FASTER than .NET (no intermediate lists) |

## Text formatting (`PropsFormat.fs`, 59 properties, 784k calls vs .NET, 0 disagreements)

| Construct | Was | Now |
|---|---|---|
| `string (x: float)`, `x.ToString()`, `String(x)` | `1.0` printed as "1.0", 6 digits at most, invalid wasm for float32 / bool | exact shortest round-trip digits (`$floatToStr`): exact decimal expansion with digit buffers + interval search, .NET's fixed / `E+XX` thresholds (double 1e-4 ≤ |x| < 1e17, float32 < 1e9), ties to even |
| `%f`, `%.Nf`, `ToString("FN")` | last-digit errors, ≥ 10 decimals wrong | exact expansion rounded half to even on exact ties (`$floatToFixed`) |
| `%5d`, `%-5d`, `%05d`, `%+d`, `% d`, `%8.2f`, `%-8.2f` | width and flags ignored | `$fmtPad` |
| `string true`, `string 'c'`, `string (float32 …)` | "1" / invalid | `primitiveToString` |
| `Math.Round(x, digits)` | digits ignored | scale · round half even · unscale (like .NET) |
| `String.Join(sep, xs)` with non-string `xs` | illegal cast | elements converted first |
| `%A` / `%O` of records, lists, tuples | invalid module | error `WGC011` (structured printing with F#'s 80-column layout is open) |

## Found and fixed by compiling a real program: the browser runtime and its ten demos (`fsharp-wasm-runtime`)

A 1,100-line library project plus ten applications, compiled from a *different repository* and driven in Chromium.
Each of these was silently wrong or produced an invalid module; none showed in single-project tests.

| Construct | Was | Now |
|---|---|---|
| project with several files | the Fable host hands files over in parallel and in any order; lowering is order dependent (a type before its use, a function before its callers) → a union used before its declaration was registered twice, `Attr list` inside the mutually recursive `Node`/`Attr` got an `i32` element type | each file is parked after its (parallel) front-end step; the last arrival lowers all of them, on one thread, in project order |
| `let mutable x` captured by a closure and assigned | the closure got a COPY (`counter 2` printed 0) | shared ref cell (`FableNormalize.capturedAndAssigned`, `BoxedLocals`): reads `struct.get`, writes `struct.set`; regression tests in QuickTest |
| a parameter named like a module-level value (`label`) used inside a closure | not captured (the module value won) → "read but never bound" | a local shadows a module value |
| a program function named like a core function (`append`, `iter`, `clear`) | `List.append` calls were bound to it (`return_call $append` with the wrong types) and, the other way round, its calls went to the core replacement | core imports resolve through their own (file, name); program functions bypass the selector-keyed replacements |
| module value of ANOTHER file read as a value (`let nil = El 0`, then `Element.nil`) | `ref.func` | a call |
| `List.choose` / `Array.choose` with a chooser returning an option of a reference type | `struct.get 0` on the reference | `unwrapSome` (non-null reference = its own `Some`) |
| generic instance member called from another file (`builder.For(xs, f)`) | specialised copy called without its receiver | `ThisArg` is the first argument |
| project outside the repository | `FSharp.Wasm.Core` not found → core files treated as program files | searched from the CLI too; `FSHARP_WASM_LIBRARY` overrides |
| every public function of every file was a wasm export, every declared extern an import | a 47 KB module for a counter; a library's functions collide (`BUG-05`) | only the ENTRY project's functions are exports; an extern is imported only if a surviving function calls it (11 KB → 19 KB with all the code that now compiles, vs 47 KB before) |
| `seq<'T>` parameters (found by the runtime's HTML builder `For`) | the type was `i32`: a function taking `seq` was uncallable | `seq<'T>` maps to the list type; an array passed where the signature (or a cast) says `seq` is copied into a list (`coerceToSeq`) |
| `[<Import("f", "x.js")>] let f (s: string) (cb: string -> unit) : string = nativeOnly` | strings and closures are GC objects JS cannot touch | host interop ABI, see `docs/host-interop.md`; a closure's table slot is released when the host's JS function is garbage collected (`__cbFree`), so re-registering handlers on every render does not leak |

Still open from that work:

| Area | Gap |
|---|---|
| `seq<'T>` from other collections | `seq<'T>` is a strict list: lists and arrays convert (at the call, or at `:> seq<_>`); `ResizeArray`, `Set`, `Map`, `string` as a `seq` report `WGC011` instead; an infinite or lazy seq passed around is not representable |
| strings are never null | `s = null`, `isNull s` cannot be written for a string; a JS `null` / `undefined` arrives as `""` |
| host callbacks | only `int`/`bool`/`float`/`string`/`string array` cross the boundary (no `int64`, records) |
| `printfn` in the browser | the host reads the string through the `__str_len` / `__str_at` exports (one call per character) |

## Portable collections (`FSharp.Wasm.Core/Collections/System.Collections.Generic.fs`, M2)

`Stack<'T>`, `Queue<'T>`, `Dictionary<'K,'V>` and `HashSet<'T>` are plain F# — arrays, counters, `=` and `hash` — that the
compiler instantiates once per type-argument list, like a generic function. A type defined in source in a `System.*`
namespace is not a Fable replacement candidate, so calls on it are ordinary member calls and the BCL names stay. Nothing
in them is wasm specific: the same file compiles to any Fable target.

| Construct | Was | Now |
|---|---|---|
| `new Stack<int>()`, `Queue`, `Dictionary`, `HashSet` | JS idioms (`Map`, `set/has/delete/size`) or unhandled imports | library classes; `Dictionary` is a chained hash table with the .NET layout (entries in index order, removed entries reused through a free list), so `for kv in d` / `d.Keys` enumerate in the BCL's order |
| generic class | compiled once with `i32` fields | one struct per instantiation (`registerGenericClass`), constructor and members specialised; constructors run their `let` initialisers |
| `hash x`, `numberHash` / `stringHash` / `arrayHash` / `structuralHash` | unhandled imports | structural hash consistent with `=` (`Equality.hashValue`): primitives by value (`0.0` = `-0.0`), strings FNV-1a, records / tuples / unions / arrays / lists folded; references without structure hash to 0 |
| `d.TryGetValue(k, &v)`, `match d.TryGetValue k with | true, v -> …` | byref parameter mapped to the value | `byref` / `outref` / `inref` are the ref-cell struct; the caller's `v` lives in a cell |
| one member of a generic class calling another | not specialised (same type-parameter name was ignored) | the class's own `TypeSubst` resolves it |
| `d :> seq<_>` / `d |> Seq.map …` for `Dictionary`, `HashSet`, `Stack`, `Queue` | not a seq | the classes implement `IEnumerable<_>` for the type checker; the coercion calls their `ToSeqList()` (a seq is a list here) |
| `for x in (xs: seq<'T>)` | iterator protocol (`getEnumerator`), no handler | normalised to `Seq.iterate` like the list / array loops |
| `KeyValuePair<'K,'V>` | `i32` | a pair, as in Fable (`kv.Key` / `kv.Value`) |
| `Dictionary<_,_>()` / `HashSet<_>(seq)` | an omitted optional argument is dropped by Fable: the call had 0 arguments for 1 parameter | the missing trailing options are filled with `None` |
| members of a generic class | all compiled up front without type arguments (dead code that still reported its diagnostics) | compiled per instantiation only |

Limits found while writing them (the library works around each): module-level functions of a library file are not compiled
from source (only its classes are), a non-generic `let` helper inside a generic class is not specialised, and a local generic
function used at several types (`let grow (a: 'T array) = …` called with `int array` and `'K array`) is compiled once.

## Still open (coverage probe: every call below compiles to an unhandled import)

| Area | Missing |
|---|---|
| `Array` | `allPairs`, `average`, `chunkBySize`, `copyTo`/`blit` via the method, `exactlyOne`, `exists2`, `forall2`, `fold2`, `foldBack2`, `mapFold`, `scanBack`, `findBack`, `pairwise`, `partition`, `splitAt`, `indexed`, `transpose`, `windowed`, `zip3`, `pick`, `tryPick` |
| `Array` / `List` (hash based) | `distinct`, `except`, `groupBy`, `countBy` on arrays |
| `List` | `pick`, `tryPick` (the chooser's option has to be evaluated ONCE: needs a binding loop, not `listSearch`) |
| ranges | float ranges (`[0.0 .. 0.5 .. 2.0]`), non-int32 integer ranges |
| `Array2D` | not supported by Fable itself (frontend limit, see M5) |
| exports | every function of a project file is exported under its plain name: two modules with a function of the same name collide (`BUG-05`), and `private` does not help — an export policy (public only / module-qualified) is M6 |
| abstract classes | base-class default members + overrides (vtable slots for ALL virtual members) — M2 |
| `Map`/`Set` with non-int keys, `Lazy`, `Decimal`, `Int32.TryParse`, `String.Format`, exception constructors (`InvalidOperationException …`) | unhandled imports (measured by the coverage probe) — M2 |
| `Dictionary` / `HashSet` | `Keys` / `Values` are arrays (the BCL's `KeyCollection` has `.Count`), no `ContainsValue` (needs `'V : equality`), no capacity / comparer constructor overloads (secondary constructors are not lowered: Fable emits them as free functions with JS `this` semantics; the library takes one optional `?items` argument instead), `HashSet` has `UnionWith` / `ExceptWith` / `IntersectWith` / `IsSubsetOf` / `IsSupersetOf` / `Overlaps` / `SetEquals` but not the strict variants; class instances as keys compare structurally, not by reference — M2 |
| `dict [...]`, `List.countBy`, `Map` / `Set` with string keys (`m.[k]`, `s.Count`) | unhandled imports (`getItemFromDict`, `List_countBy`, `FSharpMap__get_Item`, `FSharpSet__get_Count`) — M2: the portable-library route (a class compiled from source) is the plan |
| lazy `seq { … }` | only the eagerly consumed shapes are fused; a seq that is stored / passed around needs an enumerator (M2) |
| performance | array sorts are insertion sorts (O(n²)); a merge sort belongs to M4 once there are benchmarks |
