/// Primitives domain: records and basic types
/// Types: Point, Counter, Rect, SWItem
module QuickTestWasmGc.TestsPrimitives

open QuickTestWasmGc.Preamble
open Fable.Core

// ─── Records ───────────────────────────────────────────────────

type Point = { X: float; Y: float }

let distanceFromOrigin (p: Point) : float =
    p.X * p.X + p.Y * p.Y  // x² + y²

let pointSum (x: float) (y: float) : float =
    let p = { X = x; Y = y }
    p.X + p.Y

let testDistanceFromOrigin (x: float) (y: float) : float =
    distanceFromOrigin { X = x; Y = y }

let testRecordEqTrue () : int =
    let p1 = { X = 1.0; Y = 2.0 }
    let p2 = { X = 1.0; Y = 2.0 }
    if p1 = p2 then 1 else 0

let testRecordEqFalse () : int =
    let p1 = { X = 1.0; Y = 2.0 }
    let p2 = { X = 2.0; Y = 1.0 }
    if p1 = p2 then 1 else 0

let testRecordNeq () : int =
    let p1 = { X = 1.0; Y = 2.0 }
    let p2 = { X = 3.0; Y = 4.0 }
    if p1 <> p2 then 1 else 0

// ─── Mutable record ────────────────────────────────────────────

type Counter = { mutable Count: int }

let testMutRecord () : int =
    let c = { Count = 0 }
    c.Count <- c.Count + 1
    c.Count <- c.Count + 1
    c.Count  // 2

// ─── Nested records ────────────────────────────────────────────

type Rect = { TopLeft: Point; BottomRight: Point }

let rectWidth (r: Rect) : float =
    r.BottomRight.X - r.TopLeft.X

let testRectWidth (x1: float) (y1: float) (x2: float) (y2: float) : float =
    rectWidth { TopLeft = { X = x1; Y = y1 }; BottomRight = { X = x2; Y = y2 } }

// ─── Tuples ────────────────────────────────────────────────────

let swapPair (a: int) (b: int) : int * int = (b, a)

let testSwapPairFst (a: int) (b: int) : int =
    let x, _ = swapPair a b
    x

let testSwapPairSnd (a: int) (b: int) : int =
    let _, y = swapPair a b
    y

let minMax (a: float) (b: float) : float * float =
    if a <= b then (a, b) else (b, a)

let testMinMaxFirst (a: float) (b: float) : float =
    let mn, _ = minMax a b
    mn

let testMinMaxSecond (a: float) (b: float) : float =
    let _, mx = minMax a b
    mx

let tripleSum (t: int * int * int) : int =
    let a, b, c = t
    a + b + c

let testTripleSum (a: int) (b: int) (c: int) : int =
    tripleSum (a, b, c)

// ─── SortWith helper type ──────────────────────────────────────

type SWItem = { SWVal: int }

let testSortWith () : int =
    let items = [{ SWVal = 3 }; { SWVal = 1 }; { SWVal = 2 }]
    let sorted = List.sortBy (fun x -> x.SWVal) items
    (List.item 0 sorted).SWVal + (List.item 1 sorted).SWVal + (List.item 2 sorted).SWVal

// ─── Suite runner ──────────────────────────────────────────────

let runPrimitivesTests (check: string -> (unit -> unit) -> unit) : unit =
    check "testDistanceFromOrigin" (fun () -> ignore (testDistanceFromOrigin 3.0 4.0))
    check "testRecordEqTrue" (fun () -> ignore (testRecordEqTrue ()))
    check "testRecordEqFalse" (fun () -> ignore (testRecordEqFalse ()))
    check "testRecordNeq" (fun () -> ignore (testRecordNeq ()))
    check "testMutRecord" (fun () -> ignore (testMutRecord ()))
    check "testRectWidth" (fun () -> ignore (testRectWidth 0.0 0.0 5.0 10.0))
    check "testSwapPairFst" (fun () -> ignore (testSwapPairFst 1 2))
    check "testSwapPairSnd" (fun () -> ignore (testSwapPairSnd 1 2))
    check "testMinMaxFirst" (fun () -> ignore (testMinMaxFirst 3.0 1.0))
    check "testMinMaxSecond" (fun () -> ignore (testMinMaxSecond 3.0 1.0))
    check "testTripleSum" (fun () -> ignore (testTripleSum 1 2 3))
    check "testSortWith" (fun () -> ignore (testSortWith ()))
