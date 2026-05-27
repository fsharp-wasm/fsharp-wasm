module QuickTestWasmGc.TestsArray

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Array (55 tests) ───────────────────────────────────────

let testArrayLiteral () : int =
    let arr = [|5; 10; 15|]
    arr.[1]

/// Test: Array.create 3 0, mutate all, sum → 60

let testArrayCreate () : int =
    let arr = Array.create 3 0
    arr.[0] <- 10
    arr.[1] <- 20
    arr.[2] <- 30
    arr.[0] + arr.[1] + arr.[2]

/// Test: Array.zeroCreate 4, fill, read → 0+0+0+0 then set arr.[2]<-7, read → 7

let testArrayZeroCreate () : int =
    let arr = Array.zeroCreate 4
    arr.[2] <- 7
    arr.[2]

/// Test: arr.Length of [|1;2;3;4;5|] → 5

let testArrayLength () : int =
    let arr = [|1; 2; 3; 4; 5|]
    arr.Length

/// Test: sum over array with mutable accumulator → 15

let testArraySumLoop () : int =
    let arr = [|1; 2; 3; 4; 5|]
    let mutable s = 0
    for i in 0 .. arr.Length - 1 do
        s <- s + arr.[i]
    s

/// Test: float array, element access → 3.14

let testArrayFloat () : float =
    let arr = [|1.0; 3.14; 2.71|]
    arr.[1]

// ─── Array higher-order functions ──────────────────────────────────────────

/// Test: Array.fold sum [|1;2;3;4;5|] = 15

let testArrayFold () : int =
    Array.fold (fun acc x -> acc + x) 0 [|1; 2; 3; 4; 5|]

/// Test: Array.fold with float accumulator → 1.5

let testArrayFoldFloat () : float =
    Array.fold (fun acc x -> acc + x) 0.0 [|0.5; 0.5; 0.5|]

/// Test: Array.map double elements, check first+last = 2+10 = 12

let testArrayMap () : int =
    let result = Array.map (fun x -> x * 2) [|1; 2; 3; 4; 5|]
    result.[0] + result.[4]

/// Test: Array.map strings → check length

let testArrayMapStr () : int =
    let src = [|1; 2; 3|]
    let doubled = Array.map (fun x -> x * 3) src
    doubled.[2]   // 3*3 = 9

/// Test: Array.mapi (i, x) → i + x, check middle element

let testArrayMapi () : int =
    let arr = Array.mapi (fun i x -> i + x) [|10; 20; 30|]
    // [0+10; 1+20; 2+30] = [10; 21; 32]
    arr.[1]   // 21

/// Test: Array.filter keeps elements > 2: [3;4;5] → length 3

let testArrayFilter () : int =
    let arr = [|1; 2; 3; 4; 5|]
    let result = Array.filter (fun x -> x > 2) arr
    result.Length

/// Test: Array.filter all match: length = 5

let testArrayFilterAll () : int =
    let result = Array.filter (fun x -> x > 0) [|1; 2; 3; 4; 5|]
    result.Length

/// Test: Array.filter none match: length = 0

let testArrayFilterNone () : int =
    let result = Array.filter (fun x -> x > 10) [|1; 2; 3; 4; 5|]
    result.Length

/// Test: Array.exists with true predicate → 1

let testArrayExists () : int =
    if Array.exists (fun x -> x > 4) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.exists with false predicate → 0

let testArrayExistsFalse () : int =
    if Array.exists (fun x -> x > 10) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.forall all positive → 1

let testArrayForAll () : int =
    if Array.forall (fun x -> x > 0) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.forall not all > 3 → 0

let testArrayForAllFalse () : int =
    if Array.forall (fun x -> x > 3) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.init 5 (i*i) → [0;1;4;9;16], check index 3 = 9

let testArrayInit () : int =
    let arr = Array.init 5 (fun i -> i * i)
    arr.[3]

/// Test: Array.init + fold → sum of 0..4 = 10

let testArrayInitFold () : int =
    let arr = Array.init 5 (fun i -> i)
    Array.fold (+) 0 arr

/// Test: Array.iter with mutable capture → sum = 15

let testArrayIter () : int =
    let mutable s = 0
    Array.iter (fun x -> s <- s + x) [|1; 2; 3; 4; 5|]
    s

/// Test: Array.iteri with mutable capture → sum of i*x: 0*1+1*2+2*3+3*4+4*5 = 40

let testArrayIteri () : int =
    let mutable s = 0
    Array.iteri (fun i x -> s <- s + i * x) [|1; 2; 3; 4; 5|]
    s

// ── New Array combinators ─────────────────────────────────────────

/// Test: Array.reduce (+) [|1;2;3;4;5|] = 15

let testArrayReduce () : int =
    Array.reduce (+) [|1; 2; 3; 4; 5|]

/// Test: Array.sum [|1;2;3;4;5|] = 15

let testArraySum () : int =
    Array.sum [|1; 2; 3; 4; 5|]

/// Test: Array.min [|3;1;4;1;5|] = 1

let testArrayMin () : int =
    Array.min [|3; 1; 4; 1; 5|]

/// Test: Array.max [|3;1;4;1;5|] = 5

let testArrayMax () : int =
    Array.max [|3; 1; 4; 1; 5|]

/// Test: Array.rev [|1;2;3|].[0] = 3

let testArrayRev () : int =
    (Array.rev [|1; 2; 3|]).[0]

/// Test: Array.sort [|3;1;2|] first element = 1

let testArraySort () : int =
    (Array.sort [|3; 1; 2|]).[0]

/// Test: Array.findIndex (fun x -> x > 3) [|1;5;2;4|] = 1

let testArrayFindIndex () : int =
    Array.findIndex (fun x -> x > 3) [|1; 5; 2; 4|]

/// Test: Array.contains 3 [|1;2;3;4|] → true → 1

let testArrayContains () : int =
    if Array.contains 3 [|1; 2; 3; 4|] then 1 else 0

/// Test: Array.contains 9 [|1;2;3;4|] → false → 0

let testArrayContainsFalse () : int =
    if Array.contains 9 [|1; 2; 3; 4|] then 1 else 0

// ── New List combinators ─────────────────────────────────────────

/// Test: List.mapi (fun i x -> i * x) [1;2;3] |> fold (+) 0 = 0+2+6 = 8

let testArrayScan () : int =
    let r = Array.scan (+) 0 [|1; 2; 3; 4|]
    r.[r.Length - 1]

/// Test: Array.scan length = n+1 = 5

let testArrayScanLen () : int =
    (Array.scan (+) 0 [|1; 2; 3; 4|]).Length

/// Test: Array.append [|1;2;3|] [|4;5|] element at index 3 = 4

let testArrayAppend () : int =
    (Array.append [|1; 2; 3|] [|4; 5|]).[3]

/// Test: Array.append concatenated length = 5

let testArrayAppendLen () : int =
    (Array.append [|1; 2; 3|] [|4; 5|]).Length

// ── String operations ────────────────────────────────────────────

/// Test: "hello world".IndexOf("world") = 6

let testArrayToList () : int =
    let arr = [| 1; 2; 3 |]
    let lst = Array.toList arr
    List.sum lst

/// Test: List.ofArray [|4;5;6|] |> List.sum = 15

let testListOfArray () : int =
    let arr = [| 4; 5; 6 |]
    let lst = List.ofArray arr
    List.sum lst

/// Test: List.sortBy id [3;1;4;1;5;9;2;6] |> List.head = 1

let testArraySortWith () : int =
    let arr = [| 3; 1; 4; 2 |]
    let sorted = Array.sortWith (fun a b -> if a < b then -1 elif a > b then 1 else 0) arr
    sorted.[0]  // 1

/// Array.sortWith descending: head of sorted [|3;1;4;2|] should be 4

let testArraySortWithDesc () : int =
    let arr = [| 3; 1; 4; 2 |]
    let sorted = Array.sortWith (fun a b -> if b < a then -1 elif b > a then 1 else 0) arr
    sorted.[0]  // 4

// ── List.zip ──────────────────────────────────────────────────────────────

/// Test: List.zip [1;2;3] [10;20;30] |> List.head = (1, 10), sum = 11

let testArrayZip () : int =
    let arr1 = [| 1; 2; 3 |]
    let arr2 = [| 10; 20; 30 |]
    let zipped = Array.zip arr1 arr2
    let (a, b) = zipped.[0]
    a + b  // 11

/// Test: Array.zip of length 3 → length 3

let testArrayZipLen () : int =
    let zipped = Array.zip [| 1; 2; 3 |] [| 4; 5; 6 |]
    zipped.Length  // 3

// ── Array.map2 ────────────────────────────────────────────────────────────

/// Test: Array.map2 (+) [|1;2;3|] [|4;5;6|] sum = 21

let testArrayMap2Sum () : int =
    Array.map2 (fun a b -> a + b) [| 1; 2; 3 |] [| 4; 5; 6 |] |> Array.sum  // 21

/// Test: Array.map2 (*) first = 4

let testArrayMap2Head () : int =
    (Array.map2 (fun a b -> a * b) [| 1; 2; 3 |] [| 4; 5; 6 |]).[0]  // 4

// ── pown (integer exponentiation) ─────────────────────────────────────────

/// Test: pown 2 10 = 1024

let testArrayChooseBasic () : int =
    let arr = [| 1; 2; 3; 4; 5 |]
    let result = Array.choose (fun x -> if x % 2 = 0 then Some(x * 10) else None) arr
    Array.sum result  // 20 + 40 = 60


let testArrayChooseLength () : int =
    let arr = [| 1; 2; 3; 4; 5; 6 |]
    let result = Array.choose (fun x -> if x > 3 then Some x else None) arr
    Array.length result  // 4, 5, 6 → length 3


let testArrayChooseEmpty () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.choose (fun _x -> None : int option) arr
    Array.length result  // 0


let testArrayChooseAllSome () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.choose (fun x -> Some(x + 10)) arr
    result.[0] + result.[1] + result.[2]  // 11+12+13 = 36

// ─── Array.collect ───────────────────────────────────────────────────────────


let testArrayCollectBasic () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.collect (fun x -> [| x; x * 10 |]) arr
    Array.sum result  // (1+10)+(2+20)+(3+30) = 11+22+33 = 66


let testArrayCollectLength () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.collect (fun x -> [| x; x |]) arr
    Array.length result  // 3 * 2 = 6


let testArrayCollectEmpty () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.collect (fun _x -> [||] : int[]) arr
    Array.length result  // 0


let testArrayCollectSingleton () : int =
    let arr = [| 5; 10; 15 |]
    let result = Array.collect (fun x -> [| x |]) arr
    result.[0] + result.[1] + result.[2]  // 5+10+15 = 30

// ─── comparePrimitives / compare ──────────────────────────────────────────────


let testResizeArrayBasic () : int =
    let xs = ResizeArray<int>()
    xs.Add(10)
    xs.Add(20)
    xs.Add(30)
    xs.Count  // 3

// Seq.* routing to list ops (the arg goes through IEnumerable<T> type)

let testArrayUnzip () : int =
    let pairs = [|(1, 4); (2, 5); (3, 6)|]
    let (xs, ys) = Array.unzip pairs
    Array.sum xs + Array.sum ys  // 6 + 15 = 21

// ── Sprint 23d: more Seq, string, let mutable ────────────────────────────────


let testResizeArrayIndex () : int =
    let xs = ResizeArray<int>()
    xs.Add(100); xs.Add(200); xs.Add(300)
    xs.[1]  // 200


let testSetOfArray () : int =
    let s = Set.ofArray [|1; 2; 3; 2|]
    Set.count s  // 3

// ── Phase 4b: additional Seq/List ops ──────────────────────────
/// Seq.head (via List.head)

// ── Suite runner ──────────────────────────────────────────────────────────
let runArrayTests (check: string -> (unit -> unit) -> unit) =
    check "testArrayLiteral" (fun () -> ignore (testArrayLiteral ()))
    check "testArrayCreate" (fun () -> ignore (testArrayCreate ()))
    check "testArrayZeroCreate" (fun () -> ignore (testArrayZeroCreate ()))
    check "testArrayLength" (fun () -> ignore (testArrayLength ()))
    check "testArraySumLoop" (fun () -> ignore (testArraySumLoop ()))
    check "testArrayFloat" (fun () -> ignore (testArrayFloat ()))
    check "testArrayFold" (fun () -> ignore (testArrayFold ()))
    check "testArrayFoldFloat" (fun () -> ignore (testArrayFoldFloat ()))
    check "testArrayMap" (fun () -> ignore (testArrayMap ()))
    check "testArrayMapStr" (fun () -> ignore (testArrayMapStr ()))
    check "testArrayMapi" (fun () -> ignore (testArrayMapi ()))
    check "testArrayFilter" (fun () -> ignore (testArrayFilter ()))
    check "testArrayFilterAll" (fun () -> ignore (testArrayFilterAll ()))
    check "testArrayFilterNone" (fun () -> ignore (testArrayFilterNone ()))
    check "testArrayExists" (fun () -> ignore (testArrayExists ()))
    check "testArrayExistsFalse" (fun () -> ignore (testArrayExistsFalse ()))
    check "testArrayForAll" (fun () -> ignore (testArrayForAll ()))
    check "testArrayForAllFalse" (fun () -> ignore (testArrayForAllFalse ()))
    check "testArrayInit" (fun () -> ignore (testArrayInit ()))
    check "testArrayInitFold" (fun () -> ignore (testArrayInitFold ()))
    check "testArrayIter" (fun () -> ignore (testArrayIter ()))
    check "testArrayIteri" (fun () -> ignore (testArrayIteri ()))
    check "testArrayReduce" (fun () -> ignore (testArrayReduce ()))
    check "testArraySum" (fun () -> ignore (testArraySum ()))
    check "testArrayMin" (fun () -> ignore (testArrayMin ()))
    check "testArrayMax" (fun () -> ignore (testArrayMax ()))
    check "testArrayRev" (fun () -> ignore (testArrayRev ()))
    check "testArraySort" (fun () -> ignore (testArraySort ()))
    check "testArrayFindIndex" (fun () -> ignore (testArrayFindIndex ()))
    check "testArrayContains" (fun () -> ignore (testArrayContains ()))
    check "testArrayContainsFalse" (fun () -> ignore (testArrayContainsFalse ()))
    check "testArrayScan" (fun () -> ignore (testArrayScan ()))
    check "testArrayScanLen" (fun () -> ignore (testArrayScanLen ()))
    check "testArrayAppend" (fun () -> ignore (testArrayAppend ()))
    check "testArrayAppendLen" (fun () -> ignore (testArrayAppendLen ()))
    check "testArrayToList" (fun () -> ignore (testArrayToList ()))
    check "testListOfArray" (fun () -> ignore (testListOfArray ()))
    check "testArraySortWith" (fun () -> ignore (testArraySortWith ()))
    check "testArraySortWithDesc" (fun () -> ignore (testArraySortWithDesc ()))
    check "testArrayZip" (fun () -> ignore (testArrayZip ()))
    check "testArrayZipLen" (fun () -> ignore (testArrayZipLen ()))
    check "testArrayMap2Sum" (fun () -> ignore (testArrayMap2Sum ()))
    check "testArrayMap2Head" (fun () -> ignore (testArrayMap2Head ()))
    check "testArrayChooseBasic" (fun () -> ignore (testArrayChooseBasic ()))
    check "testArrayChooseLength" (fun () -> ignore (testArrayChooseLength ()))
    check "testArrayChooseEmpty" (fun () -> ignore (testArrayChooseEmpty ()))
    check "testArrayChooseAllSome" (fun () -> ignore (testArrayChooseAllSome ()))
    check "testArrayCollectBasic" (fun () -> ignore (testArrayCollectBasic ()))
    check "testArrayCollectLength" (fun () -> ignore (testArrayCollectLength ()))
    check "testArrayCollectEmpty" (fun () -> ignore (testArrayCollectEmpty ()))
    check "testArrayCollectSingleton" (fun () -> ignore (testArrayCollectSingleton ()))
    check "testResizeArrayBasic" (fun () -> ignore (testResizeArrayBasic ()))
    check "testArrayUnzip" (fun () -> ignore (testArrayUnzip ()))
    check "testResizeArrayIndex" (fun () -> ignore (testResizeArrayIndex ()))
    check "testSetOfArray" (fun () -> ignore (testSetOfArray ()))
