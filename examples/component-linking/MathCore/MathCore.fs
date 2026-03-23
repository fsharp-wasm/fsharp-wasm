/// MathCore — pure math utilities compiled to WasmGC.
///
/// This module has no imports. All exports use primitive WasmGC value types
/// (i32 / f64), so WIT world generation will capture every function here.
///
/// It is one half of the component-linking example: App imports these
/// functions and adds higher-level wrappers on top.

module MathCore

/// Integer add. (Trivial — proves the wire-up works.)
let add (a: int) (b: int) : int = a + b

/// Integer multiply.
let mul (a: int) (b: int) : int = a * b

/// Clamp v to [lo, hi].
let clamp (v: int) (lo: int) (hi: int) : int =
    if v < lo then lo
    elif v > hi then hi
    else v

/// Classic iterative Fibonacci (no recursion depth issues).
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

/// Dot product of two 2-D vectors (x1,y1) · (x2,y2).
let dotProduct (x1: float) (y1: float) (x2: float) (y2: float) : float =
    x1 * x2 + y1 * y2

/// Integer power: base^exp, exp >= 0.
let rec intPow (b: int) (e: int) : int =
    if e = 0 then 1
    elif e % 2 = 0 then
        let half = intPow b (e / 2)
        half * half
    else
        b * intPow b (e - 1)
