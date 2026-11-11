# Gaps found by the differential / property tests

Each entry is something the backend does NOT do (or does differently from .NET) that a property exposed.
A gap is closed when its property goes back into `Props/*.fs` and the comparison is clean.

| Property | Construct | Symptom | Status |
|---|---|---|---|
| `prop_s_concatMany`, `prop_s_replicate` | `String.concat sep (list)`, `String.replicate`, `String.Join(sep, list)` | `$strJoin` took a string ARRAY; a list reached it → wasm validation error | fixed: `$strJoinList` |
| `PropsInt64` | `string (int64)` | no `$int64ToStr` helper: an int64 was printed through a 32-bit conversion | fixed: `$int64ToStr` |
| (not written yet) | `float (uint64)` / `float (uint32)` above 2^63 | no unsigned convert opcode in the AST | open |
| (not written yet) | `%g` / `%e` formats | approximated by `$floatToStr` (up to 6 significant digits) | open |
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
| `Dictionary`, `HashSet`, `Stack`, `Queue`, `Map`/`Set` with non-int keys, `Lazy`, `Decimal`, `Int32.TryParse`, `String.Format`, exception constructors (`InvalidOperationException …`) | unhandled imports (measured by the coverage probe) — M2 |
| lazy `seq { … }` | only the eagerly consumed shapes are fused; a seq that is stored / passed around needs an enumerator (M2) |
| performance | array sorts are insertion sorts (O(n²)); a merge sort belongs to M4 once there are benchmarks |
