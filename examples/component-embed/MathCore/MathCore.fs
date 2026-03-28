/// MathCore — math utility library compiled to WasmGC.
///
/// Showcases three WasmGC capabilities:
///   ARRAYS (mutation): `sortMedian5`  allocates a GC array and sorts it in-place.
///   ARRAYS (HOF):      `countAbove`   uses Array.filter + a closure on a GC array.
///   STRINGS:           `greetingLen`  builds WasmGC strings via literal + branching.
///
/// All exported functions use primitive types (i32 / f64) so they compose across
/// module boundaries without the Component Model canonical ABI.

module MathCore

// ── Arithmetic primitives ─────────────────────────────────────────────────────

let add (a: int) (b: int) : int = a + b
let mul (a: int) (b: int) : int = a * b

let clamp (v: int) (lo: int) (hi: int) : int =
    if v < lo then lo
    elif v > hi then hi
    else v

let fibonacci (n: int) : int =
    if n <= 1 then n
    else
        let mutable a = 0
        let mutable b = 1
        let mutable i = 2
        while i <= n do
            let c = a + b
            a <- b
            b <- c
            i <- i + 1
        b

let dotProduct (x1: float) (y1: float) (x2: float) (y2: float) : float =
    x1 * x2 + y1 * y2

let rec intPow (b: int) (e: int) : int =
    if e = 0 then 1
    elif e % 2 = 0 then
        let half = intPow b (e / 2)
        half * half
    else
        b * intPow b (e - 1)

// ── WasmGC Array showcase 1: mutable GC array + in-place swap ────────────────

/// Median of 5 integers, found by bubble-sorting a GC-managed array.
///
/// `[| a; b; c; d; e |]` allocates a WasmGC `(array anyref)` on the GC heap —
/// no malloc, no free, no pointer arithmetic.  Swaps modify the array in-place
/// exactly like F# semantics dictate.  Returns the middle element after sorting.
let sortMedian5 (a: int) (b: int) (c: int) (d: int) (e: int) : int =
    let arr = [| a; b; c; d; e |]
    let mutable i = 0
    while i < 4 do
        let mutable j = 0
        while j < 4 - i do
            if arr.[j] > arr.[j + 1] then
                let tmp = arr.[j]
                arr.[j] <- arr.[j + 1]
                arr.[j + 1] <- tmp
            j <- j + 1
        i <- i + 1
    arr.[2]   // index 2 = median of 5

// ── WasmGC Array showcase 2: higher-order function + closure ─────────────────

/// Count how many of 5 values exceed a threshold.
///
/// Uses `Array.filter` with a closure — a higher-order function on a WasmGC
/// array.  The closure captures `threshold` from the enclosing scope as a
/// WasmGC struct field (free-variable closure conversion).  All GC-managed,
/// all collected by the GC when done.
let countAbove (a: int) (b: int) (c: int) (d: int) (e: int) (threshold: int) : int =
    let arr = [| a; b; c; d; e |]
    let filtered = Array.filter (fun x -> x > threshold) arr
    filtered.Length

// ── WasmGC String showcase ────────────────────────────────────────────────────

/// Return the length of a greeting string chosen based on name length.
///
/// All string literals are WasmGC `(array i32)` on the GC heap — no null
/// terminator, no buffer overflow possible, garbage-collected automatically.
let greetingLen (nameLen: int) : int =
    let greeting =
        if nameLen > 5 then "Hello, friend!"
        elif nameLen > 0 then "Hello!"
        else "Hi!"
    greeting.Length
