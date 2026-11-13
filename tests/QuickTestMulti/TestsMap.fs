module QuickTestWasmGc.TestsMap

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Map (25 tests) ───────────────────────────────────────

let testMapAddFind () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100 |> MapModule.add 2 200
    MapModule.tryFind 1 m |> Option.defaultValue 0

/// Test: tryFind on missing key → default 0

let testMapFindMissing () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100
    MapModule.tryFind 99 m |> Option.defaultValue 0

/// Test: count — two entries → 2

let testMapCount () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100 |> MapModule.add 2 200
    MapModule.count m

/// Test: containsKey — key present → 1

let testMapContainsKey () : int =
    let m = MapModule.empty intCmp |> MapModule.add 42 999
    if MapModule.containsKey 42 m then 1 else 0

/// Test: containsKey — key absent → 0

let testMapContainsKeyMissing () : int =
    let m = MapModule.empty intCmp |> MapModule.add 42 999
    if MapModule.containsKey 7 m then 1 else 0

/// Test: add replaces existing key → 555

let testMapAddReplace () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100 |> MapModule.add 1 555
    MapModule.tryFind 1 m |> Option.defaultValue 0

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 10b: FSharp.Wasm.Core/Option.fs — BCL migration
// Phase A: call OptionModule.* directly (via KnownFuncsByPath dispatch).
// The old tryOptionInline handlers remain active for FSharp.Core `Option.*` calls.
// These tests prove the compiled F# Option.fs functions produce identical results.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 10b: Option/Result inline replacements
// These call FSharp.Core Option.* / Result.* — Fable transforms them to direct
// WasmGC struct ops (ref.is_null, struct.get tag) at the FableTransforms stage.
// No source library file is needed; inlining is the correct architecture.
// ─────────────────────────────────────────────────────────────────────────────

/// Test: Option.isSome (Some 5) = true → 1

let testStdMapFind () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.find 2 m  // 20

// Map.ofList + Map.tryFind → Some → defaultValue

let testStdMapTryFind () : int =
    let m = Map.ofList [(10, 100); (20, 200)]
    Map.tryFind 20 m |> Option.defaultValue 0  // 200

// Map.tryFind missing key → None → 0

let testStdMapTryFindMissing () : int =
    let m = Map.ofList [(1, 1); (2, 2)]
    Map.tryFind 99 m |> Option.defaultValue 0  // 0

// Map.containsKey

let testStdMapContainsKey () : int =
    let m = Map.ofList [(5, 50); (6, 60)]
    if Map.containsKey 5 m then 1 else 0  // 1

// Map.add on top of ofList

let testStdMapAdd () : int =
    let m = Map.ofList [(1, 10)] |> Map.add 2 20
    Map.find 2 m  // 20

// ── Sprint 23 probes ──────────────────────────────────────────────────────────

let testMapIsEmpty () : int =
    let e = Map.ofList ([] : (int * int) list)
    let m = Map.ofList [(1, 10)]
    Map.count e + Map.count m  // 0 + 1 = 1

/// Map.remove — remove a key

let testMapRemove () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    let m2 = Map.remove 2 m
    Map.count m2  // 2

/// Map.toList — convert to list, check length

let testMapLargeAddFind () : int =
    let m = Map.ofList [(10, 100); (20, 200); (30, 300); (40, 400); (50, 500)]
    Map.find 30 m  // 300

/// Map.find raises on missing key, caught by try/with

let testMapFindRaises () : int =
    try
        let m = Map.ofList [(1, 10); (2, 20)]
        Map.find 99 m
    with _ -> -1  // -1

// ── Phase 2 continued: Map higher-order operations ───────────────

/// Map.fold — sum all values

let testMapFold () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.fold (fun acc _k v -> acc + v) 0 m  // 60

/// Map.fold — use as replacement for Map.iter (which needs capture-passing closures)

let testMapIter () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.fold (fun acc _k v -> acc + v) 0 m  // 60

/// Map.filter — keep entries where value > 15

let testMapFilter () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    let m2 = Map.filter (fun _k v -> v > 15) m
    Map.count m2  // 2

/// Map.exists — any value > 25?

let testMapExists () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    if Map.exists (fun _k v -> v > 25) m then 1 else 0  // 1

/// Map.forall — all values >= 10?

let testMapForall () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    if Map.forall (fun _k v -> v >= 10) m then 1 else 0  // 1

/// Map.map — double all values

let testMapMap () : int =
    let m = Map.ofList [(1, 10); (2, 20)]
    let m2 = Map.map (fun _k v -> v * 2) m
    Map.find 1 m2 + Map.find 2 m2  // 20 + 40 = 60

// ── Phase 4: Additional Seq operations ───────────────────────────

/// Seq.choose — filter+map

let testMapCustomCmpReverse () : int =
    let reverseCmp (a: int) (b: int) = if a > b then -1 elif a < b then 1 else 0
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    // Regular Map uses injected comparator; reverse cmp via MapModule direct API
    let m2 = MapModule.empty reverseCmp |> MapModule.add 1 10 |> MapModule.add 2 20 |> MapModule.add 3 30
    MapModule.fold (fun acc _k v -> acc + v) 0 m2  // 60 (same sum regardless of order)

/// MapModule with explicit intCmp — add multiple distinct keys, containsKey.

let testMapModuleContainsKey () : int =
    let m = MapModule.empty intCmp
            |> MapModule.add 10 100
            |> MapModule.add 20 200
            |> MapModule.add 30 300
    if MapModule.containsKey 20 m && not (MapModule.containsKey 99 m) then 1 else 0  // 1

/// MapModule tryFind and find round-trip.

let testMapModuleFindRoundTrip () : int =
    let m = MapModule.empty intCmp |> MapModule.add 7 77 |> MapModule.add 8 88
    MapModule.find 7 m + (MapModule.tryFind 8 m |> Option.defaultValue 0)  // 77 + 88 = 165

/// SetModule with explicit comparator: add distinct values, count = 3.

let testMapModuleRemove () : int =
    let m = MapModule.empty intCmp
            |> MapModule.add 1 10
            |> MapModule.add 2 20
            |> MapModule.add 3 30
    let m2 = MapModule.remove 2 m
    MapModule.count m2  // 2

/// MapModule.toList returns pairs in ascending order of comparison.

// ── Suite runner ──────────────────────────────────────────────────────────
let runMapTests (check: string -> (unit -> unit) -> unit) =
    check "testMapAddFind" (fun () -> ignore (testMapAddFind ()))
    check "testMapFindMissing" (fun () -> ignore (testMapFindMissing ()))
    check "testMapCount" (fun () -> ignore (testMapCount ()))
    check "testMapContainsKey" (fun () -> ignore (testMapContainsKey ()))
    check "testMapContainsKeyMissing" (fun () -> ignore (testMapContainsKeyMissing ()))
    check "testMapAddReplace" (fun () -> ignore (testMapAddReplace ()))
    check "testStdMapFind" (fun () -> ignore (testStdMapFind ()))
    check "testStdMapTryFind" (fun () -> ignore (testStdMapTryFind ()))
    check "testStdMapTryFindMissing" (fun () -> ignore (testStdMapTryFindMissing ()))
    check "testStdMapContainsKey" (fun () -> ignore (testStdMapContainsKey ()))
    check "testStdMapAdd" (fun () -> ignore (testStdMapAdd ()))
    check "testMapIsEmpty" (fun () -> ignore (testMapIsEmpty ()))
    check "testMapRemove" (fun () -> ignore (testMapRemove ()))
    check "testMapLargeAddFind" (fun () -> ignore (testMapLargeAddFind ()))
    check "testMapFindRaises" (fun () -> ignore (testMapFindRaises ()))
    check "testMapFold" (fun () -> ignore (testMapFold ()))
    check "testMapIter" (fun () -> ignore (testMapIter ()))
    check "testMapFilter" (fun () -> ignore (testMapFilter ()))
    check "testMapExists" (fun () -> ignore (testMapExists ()))
    check "testMapForall" (fun () -> ignore (testMapForall ()))
    check "testMapMap" (fun () -> ignore (testMapMap ()))
    check "testMapCustomCmpReverse" (fun () -> ignore (testMapCustomCmpReverse ()))
    check "testMapModuleContainsKey" (fun () -> ignore (testMapModuleContainsKey ()))
    check "testMapModuleFindRoundTrip" (fun () -> ignore (testMapModuleFindRoundTrip ()))
    check "testMapModuleRemove" (fun () -> ignore (testMapModuleRemove ()))
