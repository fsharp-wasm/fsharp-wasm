# Gaps found by the differential / property tests

Each entry is something the backend does NOT do (or does differently from .NET) that a property exposed.
A gap is closed when its property goes back into `Props/*.fs` and the comparison is clean.

| Property | Construct | Symptom | Status |
|---|---|---|---|
| `prop_s_concatMany` | `String.concat sep (list)` / `String.Join(sep, list)` | `$strJoin` takes a string ARRAY; a list reaches it → wasm validation error | open (M2) |
| (not written yet) | `string (int64)` | no `$int64ToStr` helper: an int64 is printed through a 32-bit conversion | open |
| (not written yet) | `float (uint64)` / `float (uint32)` above 2^63 | no unsigned convert opcode in the AST | open |
| (not written yet) | `%g` / `%e` formats | approximated by `$floatToStr` (up to 6 significant digits) | open |
| `prop_rem` | `Int32.MinValue % -1` | .NET raises, wasm returns 0 | known difference, kept (see known-differences.txt) |
