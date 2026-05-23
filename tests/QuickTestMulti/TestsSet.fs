module QuickTestWasmGc.TestsSet

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── Set (20 tests) ───────────────────────────────────────

let testSetContains () : int =
    let s = Set.ofList [1; 2; 3]
    (if Set.contains 2 s then 1 else 0) + (if Set.contains 5 s then 0 else 1)  // 2

/// Set.add + contains

let testSetAdd () : int =
    let s = Set.ofList [1; 2; 3]
    let s2 = Set.add 4 s
    if Set.contains 4 s2 then Set.count s2 else 0  // 4

/// Set.remove + count

let testSetRemove () : int =
    let s = Set.ofList [1; 2; 3; 4]
    let s2 = Set.remove 3 s
    Set.count s2  // 3

/// Set.isEmpty

let testSetIsEmpty () : int =
    let e = Set.ofList ([] : int list)
    let s = Set.ofList [1]
    (if Set.isEmpty e then 1 else 0) + (if Set.isEmpty s then 0 else 1)  // 2

/// Set.fold — sum all elements

let testSetFold () : int =
    let s = Set.ofList [1; 2; 3; 4; 5]
    Set.fold (fun acc x -> acc + x) 0 s  // 15

/// Set.toList — length

let testSetFilter () : int =
    let s = Set.ofList [1; 2; 3; 4; 5; 6]
    let s2 = Set.filter (fun x -> x % 2 = 0) s
    Set.count s2  // 3

/// Set.exists — any > 4?

let testSetExists () : int =
    let s = Set.ofList [1; 2; 3; 4; 5]
    if Set.exists (fun x -> x > 4) s then 1 else 0  // 1

/// Set.forall — all > 0?

let testSetForall () : int =
    let s = Set.ofList [1; 2; 3]
    if Set.forall (fun x -> x > 0) s then 1 else 0  // 1

/// Set.union

let testSetUnion () : int =
    let a = Set.ofList [1; 2; 3]
    let b = Set.ofList [3; 4; 5]
    Set.count (Set.union a b)  // 5

/// Set.intersect

let testSetIntersect () : int =
    let a = Set.ofList [1; 2; 3; 4]
    let b = Set.ofList [3; 4; 5; 6]
    Set.count (Set.intersect a b)  // 2

/// Set.difference

let testSetDifference () : int =
    let a = Set.ofList [1; 2; 3; 4]
    let b = Set.ofList [3; 4; 5]
    Set.count (Set.difference a b)  // 2

/// Set.isSubset

let testSetIsSubset () : int =
    let a = Set.ofList [1; 2]
    let b = Set.ofList [1; 2; 3; 4]
    (if Set.isSubset a b then 1 else 0) + (if Set.isSubset b a then 0 else 1)  // 2

/// Set.map — double all elements

let testSetMap () : int =
    let s = Set.ofList [1; 2; 3]
    let s2 = Set.map (fun x -> x * 2) s
    Set.fold (fun acc x -> acc + x) 0 s2  // 2+4+6 = 12

/// Set.minElement / maxElement

let testSetMinMax () : int =
    let s = Set.ofList [5; 1; 3; 2; 4]
    Set.minElement s + Set.maxElement s  // 1 + 5 = 6

/// Set.singleton

let testSetSingleton () : int =
    let s = Set.singleton 42
    if Set.contains 42 s then Set.count s else 0  // 1

/// Set.ofArray

let testClosureCapSetFold () : int =
    let offset = 100
    Set.fold (fun acc v -> acc + v + offset) 0 (Set.ofList [1; 2; 3])  // 306

/// List.exists with capturing closure

let testSetModuleBasic () : int =
    let s = SetModule.empty intCmp
            |> SetModule.add 5
            |> SetModule.add 3
            |> SetModule.add 7
    SetModule.count s  // 3

/// SetModule deduplication — adding duplicates doesn't increase count.

let testSetModuleDedup () : int =
    let s = SetModule.empty intCmp
            |> SetModule.add 1
            |> SetModule.add 1
            |> SetModule.add 2
            |> SetModule.add 2
    SetModule.count s  // 2

/// SetModule.contains works correctly.

let testSetModuleContains () : int =
    let s = SetModule.empty intCmp |> SetModule.add 42 |> SetModule.add 99
    if SetModule.contains 42 s && not (SetModule.contains 1 s) then 1 else 0  // 1

/// MapModule.remove reduces count by 1.

let testSetModuleFold () : int =
    let s = SetModule.empty intCmp |> SetModule.add 10 |> SetModule.add 20 |> SetModule.add 30
    SetModule.fold (fun acc x -> acc + x) 0 s  // 60

// ── Sprint 25e: Mutual LetRec closures ─────────────────────────

/// Mutual recursion via let rec … and …: even checks — is-even/is-odd.

// ── Suite runner ──────────────────────────────────────────────────────────
let runSetTests (check: string -> (unit -> unit) -> unit) =
    check "testSetContains" testSetContains
    check "testSetAdd" testSetAdd
    check "testSetRemove" testSetRemove
    check "testSetIsEmpty" testSetIsEmpty
    check "testSetFold" testSetFold
    check "testSetFilter" testSetFilter
    check "testSetExists" testSetExists
    check "testSetForall" testSetForall
    check "testSetUnion" testSetUnion
    check "testSetIntersect" testSetIntersect
    check "testSetDifference" testSetDifference
    check "testSetIsSubset" testSetIsSubset
    check "testSetMap" testSetMap
    check "testSetMinMax" testSetMinMax
    check "testSetSingleton" testSetSingleton
    check "testClosureCapSetFold" testClosureCapSetFold
    check "testSetModuleBasic" testSetModuleBasic
    check "testSetModuleDedup" testSetModuleDedup
    check "testSetModuleContains" testSetModuleContains
    check "testSetModuleFold" testSetModuleFold
