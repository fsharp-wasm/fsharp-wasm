module QuickTestWasmGc.TestsClosures

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Closures (10 tests) ───────────────────────────────────────

let testHOFSimple (x: int) : int = applyFn doubleVal x

/// Make a closure that adds n to its argument
let makeAdder (n: int) : (int -> int) = fun x -> x + n

/// Test: create and call a closure

let testCapture (n: int) (x: int) : int = (makeAdder n) x

/// Apply a function twice
let applyTwice (f: int -> int) (x: int) : int = f (f x)

/// Test: apply a closure twice

let testApplyTwice (x: int) : int = applyTwice doubleVal x

/// Make a closure that multiplies by n
let makeMultiplier (n: int) : (int -> int) = fun x -> x * n

/// Test: closure capturing via let binding

let testLetCapture (n: int) (x: int) : int =
    let mult = makeMultiplier n
    mult x

// ─── Phase 6: Strings ─────────────────────────────────────────────

/// Test: string literal length

let testClosureCapMap () : int =
    let offset = 10
    [1; 2; 3] |> List.map (fun x -> x + offset) |> List.sum  // 11+12+13 = 36

/// List.filter with capturing threshold

let testClosureCapFilter () : int =
    let threshold = 3
    [1; 2; 3; 4; 5] |> List.filter (fun x -> x > threshold) |> List.length  // [4;5] = 2

/// List.fold with capturing multiplier

let testClosureCapFold () : int =
    let multiplier = 2
    List.fold (fun acc x -> acc + x * multiplier) 0 [1; 2; 3; 4; 5]  // 30

/// Closure returned from a function and applied later

let testClosureHigherOrder () : int =
    let makeAdder (n: int) = fun x -> x + n
    let add5 = makeAdder 5
    let add10 = makeAdder 10
    add5 3 + add10 7  // 8 + 17 = 25

/// Closure capturing a mutable ref cell

let testClosureCapRef () : int =
    let counter = ref 0
    let increment () = counter.Value <- counter.Value + 1
    increment ()
    increment ()
    increment ()
    counter.Value  // 3

/// Double-nested capture: closure captures another closure's captured variable

let testClosureNestedCapture () : int =
    let base_ = 100
    let outer n =
        let inner m = base_ + n + m
        inner
    let f = outer 5
    f 3  // 100 + 5 + 3 = 108

/// Set.fold with a capturing offset

// ── Suite runner ──────────────────────────────────────────────────────────
let runClosuresTests (check: string -> (unit -> unit) -> unit) =
    check "testHOFSimple" (fun () -> ignore (testHOFSimple ()))
    check "testCapture" (fun () -> ignore (testCapture ()))
    check "testApplyTwice" (fun () -> ignore (testApplyTwice ()))
    check "testLetCapture" (fun () -> ignore (testLetCapture ()))
    check "testClosureCapMap" (fun () -> ignore (testClosureCapMap ()))
    check "testClosureCapFilter" (fun () -> ignore (testClosureCapFilter ()))
    check "testClosureCapFold" (fun () -> ignore (testClosureCapFold ()))
    check "testClosureHigherOrder" (fun () -> ignore (testClosureHigherOrder ()))
    check "testClosureCapRef" (fun () -> ignore (testClosureCapRef ()))
    check "testClosureNestedCapture" (fun () -> ignore (testClosureNestedCapture ()))
