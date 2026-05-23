module QuickTestWasmGc.TestsList

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── List (74 tests) ───────────────────────────────────────

let testListHead () : int =
    let xs = [1; 2; 3]
    xs.Head

/// Test: empty list check → 1

let testListEmpty () : int =
    let xs: int list = []
    if List.isEmpty xs then 1 else 0

/// Test: pattern match on list head → 5

let testListMatch () : int =
    let xs = [5; 6; 7]
    match xs with
    | [] -> 0
    | h :: _ -> h

/// Test: List.fold sum → 15

let testListFoldSum () : int =
    let xs = [1; 2; 3; 4; 5]
    List.fold (fun acc x -> acc + x) 0 xs

// ─── List higher-order combinators ──────────────────────────────────────────

/// Test: List.map then fold sum → List.map (fun x -> x * 2) [1;2;3] = [2;4;6] → fold sum = 12

let testListMapSum () : int =
    let xs = [1; 2; 3]
    let doubled = List.map (fun x -> x * 2) xs
    List.fold (fun acc x -> acc + x) 0 doubled

/// Test: List.filter then fold sum → filter (>2) [1..5] = [3;4;5] → sum = 12

let testListFilterSum () : int =
    let xs = [1; 2; 3; 4; 5]
    let big = List.filter (fun x -> x > 2) xs
    List.fold (fun acc x -> acc + x) 0 big

/// Test: List.rev head → rev [1;2;3] = [3;2;1] → head = 3

let testListRevHead () : int =
    let xs = [1; 2; 3]
    (List.rev xs).Head

/// Test: List.append length → append [1;2] [3;4;5] = [1;2;3;4;5] → length = 5

let testListAppendLen () : int =
    let xs = [1; 2]
    let ys = [3; 4; 5]
    List.length (List.append xs ys)

// ─── TypeCast / numeric conversions ──────────────────────────────────────────

/// Test: int of float truncates → int 3.7 = 3

let testListIter () : int =
    let mutable acc = 0
    List.iter (fun x -> acc <- acc + x) [1; 2; 3; 4; 5]
    acc

/// Test: List.iter on empty list → 0

let testListIterEmpty () : int =
    let mutable acc = 0
    List.iter (fun x -> acc <- acc + x) []
    acc

// ─── List.exists / List.forAll ──────────────────────────────────────────────

/// Test: List.exists → 4 > 3 exists in [1;2;3;4;5] → 1

let testListExists () : int =
    if List.exists (fun x -> x > 3) [1; 2; 3; 4; 5] then 1 else 0

/// Test: List.exists → none > 10 → 0

let testListExistsFalse () : int =
    if List.exists (fun x -> x > 10) [1; 2; 3] then 1 else 0

/// Test: List.forAll → all > 0 in [1;2;3] → 1

let testListForAll () : int =
    if List.forall (fun x -> x > 0) [1; 2; 3] then 1 else 0

/// Test: List.forAll → not all > 2 in [1;2;3] → 0

let testListForAllFalse () : int =
    if List.forall (fun x -> x > 2) [1; 2; 3] then 1 else 0

// ─── List.sum ───────────────────────────────────────────────────────────────

/// Test: List.sum [1..5] = 15

let testListSum () : int =
    List.sum [1; 2; 3; 4; 5]

/// Test: List.sum [] = 0

let testListSumEmpty () : int =
    List.sum ([] : int list)

// ─── List.tryFind ───────────────────────────────────────────────────────────

/// Test: List.tryFind (>3) [1..5] = Some 4 → 4

let testListTryFindSome () : int =
    match List.tryFind (fun x -> x > 3) [1; 2; 3; 4; 5] with
    | Some v -> v
    | None   -> -1

/// Test: List.tryFind (>10) [1..5] = None → -1

let testListTryFindNone () : int =
    match List.tryFind (fun x -> x > 10) [1; 2; 3; 4; 5] with
    | Some v -> v
    | None   -> -1

// ─── List.tryHead ───────────────────────────────────────────────────────────

/// Test: List.tryHead [7;8;9] = Some 7 → 7

let testListTryHeadSome () : int =
    match List.tryHead [7; 8; 9] with
    | Some v -> v
    | None   -> -1

/// Test: List.tryHead [] = None → -1

let testListTryHeadNone () : int =
    match List.tryHead ([] : int list) with
    | Some v -> v
    | None   -> -1

// ─── Ref cells ──────────────────────────────────────────────────────────────

/// Test: create ref 5, increment via .Value <-, return .Value = 6

let testListMapi () : int =
    List.fold (+) 0 (List.mapi (fun i x -> i * x) [1; 2; 3])

/// Test: List.iteri (fun i x -> s <- s + i*x) [1;2;3] → s = 0+2+6 = 8

let testListIteri () : int =
    let mutable s = 0
    List.iteri (fun i x -> s <- s + i * x) [1; 2; 3]
    s

/// Test: List.collect (fun x -> [x; x*2]) [1;2;3] length = 6

let testListCollect () : int =
    List.length (List.collect (fun x -> [x; x * 2]) [1; 2; 3])

/// Test: List.collect order correct — fold of [1;2;2;4;3;6] = 18

let testListCollectOrder () : int =
    List.fold (+) 0 (List.collect (fun x -> [x; x * 2]) [1; 2; 3])

/// Test: List.choose (fun x -> if x > 2 then Some(x*10) else None) [1;2;3;4] length = 2

let testListChoose () : int =
    List.length (List.choose (fun x -> if x > 2 then Some(x * 10) else None) [1; 2; 3; 4])

/// Test: List.choose sum of chosen values = 30+40 = 70

let testListChooseSum () : int =
    List.fold (+) 0 (List.choose (fun x -> if x > 2 then Some(x * 10) else None) [1; 2; 3; 4])

// ── List.foldBack / sumBy / minBy / maxBy ────────────────────────

/// Test: List.foldBack (::) [1;2;3] [] = [1;2;3] — fold right restores list

let testListFoldBack () : int =
    List.length (List.foldBack (fun x acc -> x :: acc) [1; 2; 3] [])

/// Test: List.foldBack builds right-to-left string of lengths: 3-2-1
/// Since we return int, test that foldBack difference: foldBack(sub)[1;2;3] 0 = 1-2+3 = 2
/// foldBack sub [1;2;3] 0 = sub 1 (sub 2 (sub 3 0)) = sub 1 (sub 2 3) = sub 1 1 = 0

let testListFoldBackOrder () : int =
    List.foldBack (fun x acc -> x - acc) [1; 2; 3] 0

/// Test: List.sumBy (fun x -> x * x) [1;2;3;4] = 1+4+9+16 = 30

let testListSumBy () : int =
    List.sumBy (fun x -> x * x) [1; 2; 3; 4]

/// Test: List.minBy (fun x -> x % 3) [4;2;7;1;6] — element with min (x%3): 1%3=1, 2%3=2, 4%3=1, 6%3=0, 7%3=1 → 6

let testListMinBy () : int =
    List.minBy (fun x -> x % 3) [4; 2; 7; 1; 6]

/// Test: List.maxBy (fun x -> x % 5) [3;8;1;6;4] — max (x%5): 3%5=3, 8%5=3, 1%5=1, 6%5=1, 4%5=4 → 4

let testListMaxBy () : int =
    List.maxBy (fun x -> x % 5) [3; 8; 1; 6; 4]

// ── List.min / List.max / List.contains ──────────────────────────

/// Test: List.min [3;1;4;1;5] = 1

let testListMin () : int =
    List.min [3; 1; 4; 1; 5]

/// Test: List.max [3;1;4;1;5] = 5

let testListMax () : int =
    List.max [3; 1; 4; 1; 5]

/// Test: List.contains 3 [1;2;3;4] → true → 1

let testListContains () : int =
    if List.contains 3 [1; 2; 3; 4] then 1 else 0

/// Test: List.contains 9 [1;2;3;4] → false → 0

let testListContainsFalse () : int =
    if List.contains 9 [1; 2; 3; 4] then 1 else 0

// ── List.init / replicate / take / skip / sort ───────────────────

/// Test: List.init 5 (fun _ -> 1) - all ones, length = 5

let testListInit () : int =
    List.length (List.init 5 (fun _ -> 1))

/// Test: List.replicate 4 7 → [7;7;7;7]; head = 7

let testListReplicate () : int =
    List.head (List.replicate 4 7)

/// Test: List.take 3 [1..5] → [1;2;3]; last = 3

let testListTake () : int =
    List.item 2 (List.take 3 [1; 2; 3; 4; 5])

/// Test: List.skip 2 [1..5] → [3;4;5]; head = 3

let testListSkip () : int =
    List.head (List.skip 2 [1; 2; 3; 4; 5])

/// Test: List.sort [3;1;4;1;5;2] head = 1

let testListSort () : int =
    List.head (List.sort [3; 1; 4; 1; 5; 2])
// ── Array.scan / Array.append ────────────────────────────────────

/// Test: Array.scan (+) 0 [|1;2;3;4|] = [|0;1;3;6;10|]; last element = 10

let testListFindIndex () : int =
    List.findIndex (fun x -> x > 3) [1; 5; 2; 4]

/// Test: List.findIndex (fun x -> x > 10) [1;2;3] → exception; guard with tryFindIndex = None → -1

let testListTryFindIndex () : int =
    match List.tryFindIndex (fun x -> x > 10) [1; 2; 3] with
    | Some i -> i
    | None -> -1

// ── Option.Value ─────────────────────────────────────────────────

/// Test: (Some 42).Value = 42

let testListItem () : int =
    List.item 2 [10; 20; 30; 40; 50]

/// Test: (List.tail [100;200;300]).Head = 200

let testListTailHead () : int =
    (List.tail [100; 200; 300]).Head

/// Test: List.length [10;20;30] = 3

let testListLength () : int =
    List.length [10; 20; 30]

/// Test: List.reduce (+) [1;2;3;4;5] = 15

let testListReduce () : int =
    List.reduce (fun a b -> a + b) [1; 2; 3; 4; 5]

/// Test: List.reduce max equivalent [3;1;4;1;5;9;2;6] = 9

let testListReduceMax () : int =
    List.reduce (fun a b -> if a > b then a else b) [3; 1; 4; 1; 5; 9; 2; 6]

/// Test: List.last [1;2;3;4;5] = 5

let testListLast () : int =
    List.last [1; 2; 3; 4; 5]

/// Test: List.last [42] = 42  (single-element list)

let testListLastSingle () : int =
    List.last [42]

/// Test: (List.sortDescending [3;1;4;1;5;9]).Head = 9

let testListSortDesc () : int =
    (List.sortDescending [3; 1; 4; 1; 5; 9]).Head

// ─── Bitwise / arithmetic ─────────────────────────────────────────

/// Test: 5 &&& 3 = 1

let testListSortBy () : int =
    List.sortBy id [3; 1; 4; 1; 5; 9; 2; 6]
    |> List.head

/// Test: List.append [1;2;3] [4;5] |> List.sum = 15

let testListFlatten () : int =
    List.append [1; 2; 3] [4; 5] |> List.sum

// ── Interface vtable dispatch tests ─────────────────────────────────────

type IGreeter =
    abstract Greet: unit -> int  // returns length of greeting string

type EnglishGreeter = { Word: string }
    with
        interface IGreeter with
            member this.Greet() = this.Word.Length

type SpanishGreeter = { Palabra: string }
    with
        interface IGreeter with
            member this.Greet() = this.Palabra.Length

/// Test: vtable dispatch — Dog.Speak via IAnimal interface.
/// EnglishGreeter { Word = "hello" } :> IGreeter |> .Greet() = 5

let testListZip () : int =
    let xs = [1; 2; 3]
    let ys = [10; 20; 30]
    let zipped = List.zip xs ys
    let (a, b) = List.head zipped
    a + b  // 11

/// Test: List.zip ['a';'b';'c'] [1;2;3] length = 3

let testListZipLen () : int =
    let xs = ['a'; 'b'; 'c']
    let ys = [1; 2; 3]
    List.zip xs ys |> List.length  // 3

// ── List.map2 ─────────────────────────────────────────────────────────────

/// Test: List.map2 (+) [1;2;3] [4;5;6] |> List.sum = 21

let testListMap2Sum () : int =
    List.map2 (fun a b -> a + b) [1; 2; 3] [4; 5; 6] |> List.sum  // 21

/// Test: List.map2 (*) [1;2;3] [4;5;6] head = 4

let testListMap2Head () : int =
    List.map2 (fun a b -> a * b) [1; 2; 3] [4; 5; 6] |> List.head  // 4

// ── Array.zip ─────────────────────────────────────────────────────────────

/// Test: Array.zip [|1;2;3|] [|10;20;30|].[0] = (1,10), sum = 11

let testListPartitionCounts () : int =
    // Evens vs odds in [1..6]
    let evens, odds = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.length evens * 10 + List.length odds  // 3 evens, 3 odds → 33


let testListPartitionEvens () : int =
    let evens, _ = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.sum evens  // 2+4+6 = 12


let testListPartitionOdds () : int =
    let _, odds = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.sum odds  // 1+3+5 = 9


let testListPartitionEmpty () : int =
    let a, b = List.partition (fun x -> x > 0) ([] : int list)
    List.length a + List.length b  // 0


let testListPartitionAllTrue () : int =
    let a, b = List.partition (fun x -> x > 0) [1;2;3]
    List.length a * 10 + List.length b  // 3 true, 0 false → 30


let testListPartitionOrder () : int =
    // Verify order is preserved: evens [2;4;6], check first element = 2
    let evens, _ = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.head evens  // 2

// ─── Array.choose ────────────────────────────────────────────────────────────


let testListSortIntAsc () : int =
    let sorted = List.sort [3; 1; 4; 1; 5; 9; 2; 6]
    List.head sorted  // min = 1


let testListSortStrAsc () : int =
    let sorted = List.sort ["cherry"; "apple"; "banana"]
    if List.head sorted = "apple" then 1 else 0  // 1

// ─── Sprint 22b: standard F# Map<int,int> via Fable IComparer intercept ──────

// Map.ofList + Map.find (find uses KnownFuncsByPath → Map_find with correct retTy)

let testSeqToList () : int =
    let xs : int list = [10; 20; 30]
    Seq.toList xs |> List.sum  // 60


let testListUnzip () : int =
    let pairs = [(1, 10); (2, 20); (3, 30)]
    let (xs, ys) = List.unzip pairs
    List.sum xs + List.sum ys  // 6 + 60 = 66


let testListGroupBy () : int =
    let groups = [1; 2; 3; 4; 5; 6] |> List.groupBy (fun x -> x % 2)
    List.length groups  // 2

type MathExpr =
    | Lit of int
    | Add of MathExpr * MathExpr
    | Mul of MathExpr * MathExpr

let rec evalExpr = function
    | Lit n       -> n
    | Add(a, b)   -> evalExpr a + evalExpr b
    | Mul(a, b)   -> evalExpr a * evalExpr b


let testListDistinctBy () : int =
    [1; 2; 3; 4; 5; 6] |> List.distinctBy (fun x -> x % 3) |> List.length  // 3

// ── Phase 3: Exception handling ──────────────────────────────────

/// try/with catch-all — failwith throws, handler recovers

let testMapToList () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.toList m |> List.length  // 3

/// Map add + find round-trip with more keys (5 elements)

let testSetOfListCount () : int =
    let s = Set.ofList [3; 1; 2; 1]
    Set.count s  // 3 (duplicate removed)

/// Set.contains

let testSetToList () : int =
    let s = Set.ofList [3; 1; 2]
    Set.toList s |> List.length  // 3

/// Set.filter — keep even

let testClosureCapListExists () : int =
    let target = 7
    if List.exists (fun x -> x = target) [1; 4; 7; 9] then 1 else 0  // 1

/// List.forall with capturing bound

let testClosureCapListForAll () : int =
    let bound = 10
    if List.forall (fun x -> x < bound) [1; 3; 5; 7; 9] then 1 else 0  // 1

// ── Sprint 25c: Generic Map/Set with stored comparator ───────────────────────

/// Map with reverse (descending) comparator stored in handle.
/// After Map.ofList [(1,10);(2,20);(3,30)] with reverse cmp, the BST is ordered
/// descending so Map.fold left-to-right sums in reverse order: still 60.

let testMapModuleToList () : int =
    let m = MapModule.empty intCmp
            |> MapModule.add 3 30
            |> MapModule.add 1 10
            |> MapModule.add 2 20
    MapModule.toList m |> List.length  // 3

/// SetModule.fold sum using explicit comparator.

// ── Suite runner ──────────────────────────────────────────────────────────
let runListTests (check: string -> (unit -> unit) -> unit) =
    check "testListHead" testListHead
    check "testListEmpty" testListEmpty
    check "testListMatch" testListMatch
    check "testListFoldSum" testListFoldSum
    check "testListMapSum" testListMapSum
    check "testListFilterSum" testListFilterSum
    check "testListRevHead" testListRevHead
    check "testListAppendLen" testListAppendLen
    check "testListIter" testListIter
    check "testListIterEmpty" testListIterEmpty
    check "testListExists" testListExists
    check "testListExistsFalse" testListExistsFalse
    check "testListForAll" testListForAll
    check "testListForAllFalse" testListForAllFalse
    check "testListSum" testListSum
    check "testListSumEmpty" testListSumEmpty
    check "testListTryFindSome" testListTryFindSome
    check "testListTryFindNone" testListTryFindNone
    check "testListTryHeadSome" testListTryHeadSome
    check "testListTryHeadNone" testListTryHeadNone
    check "testListMapi" testListMapi
    check "testListIteri" testListIteri
    check "testListCollect" testListCollect
    check "testListCollectOrder" testListCollectOrder
    check "testListChoose" testListChoose
    check "testListChooseSum" testListChooseSum
    check "testListFoldBack" testListFoldBack
    check "testListFoldBackOrder" testListFoldBackOrder
    check "testListSumBy" testListSumBy
    check "testListMinBy" testListMinBy
    check "testListMaxBy" testListMaxBy
    check "testListMin" testListMin
    check "testListMax" testListMax
    check "testListContains" testListContains
    check "testListContainsFalse" testListContainsFalse
    check "testListInit" testListInit
    check "testListReplicate" testListReplicate
    check "testListTake" testListTake
    check "testListSkip" testListSkip
    check "testListSort" testListSort
    check "testListFindIndex" testListFindIndex
    check "testListTryFindIndex" testListTryFindIndex
    check "testListItem" testListItem
    check "testListTailHead" testListTailHead
    check "testListLength" testListLength
    check "testListReduce" testListReduce
    check "testListReduceMax" testListReduceMax
    check "testListLast" testListLast
    check "testListLastSingle" testListLastSingle
    check "testListSortDesc" testListSortDesc
    check "testListSortBy" testListSortBy
    check "testListFlatten" testListFlatten
    check "testListZip" testListZip
    check "testListZipLen" testListZipLen
    check "testListMap2Sum" testListMap2Sum
    check "testListMap2Head" testListMap2Head
    check "testListPartitionCounts" testListPartitionCounts
    check "testListPartitionEvens" testListPartitionEvens
    check "testListPartitionOdds" testListPartitionOdds
    check "testListPartitionEmpty" testListPartitionEmpty
    check "testListPartitionAllTrue" testListPartitionAllTrue
    check "testListPartitionOrder" testListPartitionOrder
    check "testListSortIntAsc" testListSortIntAsc
    check "testListSortStrAsc" testListSortStrAsc
    check "testSeqToList" testSeqToList
    check "testListUnzip" testListUnzip
    check "testListGroupBy" testListGroupBy
    check "testListDistinctBy" testListDistinctBy
    check "testMapToList" testMapToList
    check "testSetOfListCount" testSetOfListCount
    check "testSetToList" testSetToList
    check "testClosureCapListExists" testClosureCapListExists
    check "testClosureCapListForAll" testClosureCapListForAll
    check "testMapModuleToList" testMapModuleToList
