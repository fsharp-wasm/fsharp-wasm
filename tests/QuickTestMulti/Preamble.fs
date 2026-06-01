/// Minimal shared preamble: only helpers used by MULTIPLE domains
/// Each domain has its own Types in its TestsX.fs file
module QuickTestWasmGc.Preamble

open Fable.Core

// ── External Wasm FFI ───────────────────────────────────────────────────────
[<Import("wasmAdd", "testEnv")>]
let externWasmAdd (a: int) (b: int) : int = nativeOnly

[<Import("wasmMul", "testEnv")>]
let externWasmMul (a: int) (b: int) : int = nativeOnly

// ── Basic arithmetic ───────────────────────────────────────────────────────

/// Simple addition
let add (a: int) (b: int) : int = a + b

/// Subtract
let sub (a: int) (b: int) : int = a - b

/// Multiply
let mul (a: int) (b: int) : int = a * b

// ── Recursive helpers ──────────────────────────────────────────────────────

/// Recursive fibonacci
let rec fib (n: int) : int =
    if n <= 1 then n
    else fib (n - 1) + fib (n - 2)

/// Recursive factorial
let rec fact (n: int) : int =
    if n <= 1 then 1
    else n * fact (n - 1)

/// Clamp a value to [lo, hi]
let clamp (lo: int) (hi: int) (v: int) : int =
    if v < lo then lo
    elif v > hi then hi
    else v

/// Absolute value
let myAbs (n: int) : int =
    if n < 0 then -n else n

/// Integer square root (Newton's method)
let isqrt (n: int) : int =
    if n < 0 then 0
    elif n = 0 then 0
    else
        let mutable x = n
        let mutable y = (x + 1) / 2
        while y < x do
            x <- y
            y <- (y + n / y) / 2
        x

// ── Higher-order function helpers (Closures domain) ────────────────────────

/// Apply a function to a value
let applyFn (f: int -> int) (x: int) : int = f x

/// Double a value
let doubleVal (x: int) : int = x * 2

/// Make an adder closure
let makeAdder (n: int) : (int -> int) = fun x -> x + n

/// Apply function twice
let applyTwice (f: int -> int) (x: int) : int = f (f x)

/// Make a multiplier closure
let makeMultiplier (n: int) : (int -> int) = fun x -> x * n

// ── Option helpers (Option domain) ─────────────────────────────────────────

/// Get value from option or return default
let optionOrDefault (opt: int option) (def: int) : int =
    match opt with
    | Some v -> v
    | None -> def

/// Double the value in an option
let optionDouble (opt: int option) : int =
    match opt with
    | Some v -> v * 2
    | None -> -1

/// Check if option is Some
let optionIsSome (opt: int option) : bool =
    match opt with
    | Some _ -> true
    | None -> false

/// Check if option is None
let optionIsNone (opt: int option) : bool =
    match opt with
    | Some _ -> false
    | None -> true

/// Nested option matching
let optionNested (v: int) : int =
    let outer = Some(Some v)
    match outer with
    | Some inner ->
        match inner with
        | Some x -> x
        | None -> -2
    | None -> -1

// ── Math library wrappers (Math domain) ────────────────────────────────────

let mathAbsF (x: float) : float = System.Math.Abs(x)
let mathAbsI (x: int) : int = System.Math.Abs(x)
let mathSqrt (x: float) : float = System.Math.Sqrt(x)
let mathFloor (x: float) : float = System.Math.Floor(x)
let mathCeil (x: float) : float = System.Math.Ceiling(x)
let mathTrunc (x: float) : float = System.Math.Truncate(x)
let mathRound (x: float) : float = System.Math.Round(x)
let mathMinF (a: float) (b: float) : float = System.Math.Min(a, b)
let mathMaxF (a: float) (b: float) : float = System.Math.Max(a, b)
let mathMinI (a: int) (b: int) : int = System.Math.Min(a, b)
let mathMaxI (a: int) (b: int) : int = System.Math.Max(a, b)

// ── Comparison helpers ─────────────────────────────────────────────────────

/// Integer comparison: a < b → -1, a = b → 0, a > b → 1
let intCmp (a: int) (b: int) : int =
    if a < b then -1
    elif a > b then 1
    else 0

/// Float rounding to 6 decimal places
let roundTo6 (x: float) : float =
    let scale = 1000000.0
    System.Math.Round(x * scale) / scale
