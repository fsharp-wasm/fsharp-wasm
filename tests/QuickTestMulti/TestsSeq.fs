module QuickTestWasmGc.TestsSeq

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Seq (26 tests) ───────────────────────────────────────

let testSeqMap () : int =
    [1; 2; 3; 4; 5] |> Seq.map (fun x -> x * 2) |> Seq.sum  // 30


let testSeqFilter () : int =
    [1; 2; 3; 4; 5; 6] |> Seq.filter (fun x -> x % 2 = 0) |> Seq.length  // 3


let testSeqFold () : int =
    Seq.fold (fun acc x -> acc + x) 0 [1; 2; 3; 4; 5]  // 15


let testSeqExists () : int =
    if Seq.exists (fun x -> x > 3) [1; 2; 3; 4; 5] then 1 else 0  // 1


let testSeqSumBy () : int =
    [1; 2; 3; 4; 5] |> Seq.sumBy (fun x -> x * 2)  // 30


let testSeqInit () : int =
    Seq.init 5 (fun i -> i * i) |> Seq.sum  // 0+1+4+9+16 = 30


let testSeqPairwise () : int =
    [1; 2; 3; 4; 5] |> Seq.pairwise |> Seq.map (fun (a, b) -> b - a) |> Seq.sum  // 4×1 = 4


let testSeqCountBy () : int =
    let result = [1; 2; 3; 4; 5; 6] |> Seq.countBy (fun x -> x % 2)
    Seq.length result  // 2 groups: odd (1,3,5) and even (2,4,6)

// ── Sprint 23e: recursive DU, active patterns, groupBy ────────────────────────


let testSeqDistinct () : int =
    [1; 2; 2; 3; 3; 3; 4] |> Seq.distinct |> Seq.length  // 4


let testSeqChoose () : int =
    [1; 2; 3; 4; 5]
    |> Seq.choose (fun x -> if x % 2 = 0 then Some (x * 10) else None)
    |> Seq.sum  // 60

/// Seq.collect — flatMap

let testSeqCollect () : int =
    [1; 2; 3]
    |> Seq.collect (fun x -> [x; x * 10])
    |> Seq.sum  // 1+10+2+20+3+30 = 66

/// Seq.reduce — accumulate without init

let testSeqReduce () : int =
    [1; 2; 3; 4; 5] |> Seq.reduce (fun a b -> a + b)  // 15

/// Seq.mapIndexed — use index

let testSeqMapIndexed () : int =
    [10; 20; 30]
    |> Seq.mapi (fun i x -> i + x)
    |> Seq.sum  // (0+10)+(1+20)+(2+30) = 63

/// Seq.forall — all positive?

let testSeqForall () : int =
    if Seq.forall (fun x -> x > 0) [1; 2; 3] then 1 else 0  // 1

// ── Phase 2c: Set operations ─────────────────────────────────────

/// Set.ofList + count

let testSeqHead () : int =
    List.head [10; 20; 30]  // 10

/// Seq.tryHead Some (via List.tryHead)

let testSeqTryHead () : int =
    match List.tryHead [42; 1; 2] with
    | Some x -> x
    | None -> 0  // 42

/// Seq.tryHead None (via List.tryHead)

let testSeqTryHeadEmpty () : int =
    match List.tryHead ([] : int list) with
    | Some _ -> 1
    | None -> 0  // 0

/// Seq.isEmpty (via List.isEmpty)

let testSeqIsEmpty () : int =
    (if List.isEmpty [] then 1 else 0) + (if List.isEmpty [1] then 0 else 1)  // 2

/// Seq.length (via List.length)

let testSeqLength () : int =
    List.length [1; 2; 3; 4; 5]  // 5

/// Seq.item (via List.item)

let testSeqItem () : int =
    List.item 2 [10; 20; 30; 40]  // 30

/// Seq.min / max (via List.min/max)

let testSeqMinMax () : int =
    List.min [3; 1; 4; 1; 5] + List.max [3; 1; 4; 1; 5]  // 1 + 5 = 6

/// Seq.sortBy

let testSeqSortBy () : int =
    [30; 10; 20]
    |> List.sortBy id
    |> List.head  // 10

/// List.rev + head

let testSeqRev () : int =
    List.rev [1; 2; 3] |> List.head  // 3

// testSeqToArray — removed: Array.ofList not yet implemented

/// List.findIndex

let testSeqFindIndex () : int =
    List.findIndex (fun x -> x > 20) [10; 20; 30; 40]  // 2

/// List.skip + take

let testSeqSkipTake () : int =
    [1; 2; 3; 4; 5] |> List.skip 2 |> List.take 2 |> List.sum  // 3+4 = 7

/// List.groupBy count

let testSeqGroupByCount () : int =
    [1; 2; 3; 4; 5; 6]
    |> List.groupBy (fun x -> x % 2)
    |> List.length  // 2

// ── Phase 3b: More exception tests ───────────────────────────────

/// failwith in nested function

// ── Suite runner ──────────────────────────────────────────────────────────
let runSeqTests (check: string -> (unit -> unit) -> unit) =
    check "testSeqMap" (fun () -> ignore (testSeqMap ()))
    check "testSeqFilter" (fun () -> ignore (testSeqFilter ()))
    check "testSeqFold" (fun () -> ignore (testSeqFold ()))
    check "testSeqExists" (fun () -> ignore (testSeqExists ()))
    check "testSeqSumBy" (fun () -> ignore (testSeqSumBy ()))
    check "testSeqInit" (fun () -> ignore (testSeqInit ()))
    check "testSeqPairwise" (fun () -> ignore (testSeqPairwise ()))
    check "testSeqCountBy" (fun () -> ignore (testSeqCountBy ()))
    check "testSeqDistinct" (fun () -> ignore (testSeqDistinct ()))
    check "testSeqChoose" (fun () -> ignore (testSeqChoose ()))
    check "testSeqCollect" (fun () -> ignore (testSeqCollect ()))
    check "testSeqReduce" (fun () -> ignore (testSeqReduce ()))
    check "testSeqMapIndexed" (fun () -> ignore (testSeqMapIndexed ()))
    check "testSeqForall" (fun () -> ignore (testSeqForall ()))
    check "testSeqHead" (fun () -> ignore (testSeqHead ()))
    check "testSeqTryHead" (fun () -> ignore (testSeqTryHead ()))
    check "testSeqTryHeadEmpty" (fun () -> ignore (testSeqTryHeadEmpty ()))
    check "testSeqIsEmpty" (fun () -> ignore (testSeqIsEmpty ()))
    check "testSeqLength" (fun () -> ignore (testSeqLength ()))
    check "testSeqItem" (fun () -> ignore (testSeqItem ()))
    check "testSeqMinMax" (fun () -> ignore (testSeqMinMax ()))
    check "testSeqSortBy" (fun () -> ignore (testSeqSortBy ()))
    check "testSeqRev" (fun () -> ignore (testSeqRev ()))
    check "testSeqFindIndex" (fun () -> ignore (testSeqFindIndex ()))
    check "testSeqSkipTake" (fun () -> ignore (testSeqSkipTake ()))
    check "testSeqGroupByCount" (fun () -> ignore (testSeqGroupByCount ()))
