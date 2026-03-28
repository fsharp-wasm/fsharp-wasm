/// App — higher-level functions built on top of MathCore Wasm imports.
///
/// Showcases F# arrays AND strings compiled to WasmGC, with cross-module calls:
///   `powersAndSum`  — builds a WasmGC array whose elements come from MathCore.intPow
///   `parityLabel`   — creates WasmGC strings ("even"/"odd"), concatenates, returns length
///   `gradeMessage`  — maps score to a grade-string label, returns its length
///   `medianIsEven`  — calls MathCore.sortMedian5 (cross-module), checks parity
///
/// Cross-module wiring at instantiation time:
///   { 'math-core': mathCoreInstance.exports }   <- passed by test-runner.mjs

module App

open Fable.Core

// ── Wasm imports from the 'math-core' component ──────────────────────────────
// Names match MathCore's export table exactly (plain F# function names,
// since MathCore is compiled as its own standalone project — no prefix).

[<Import("add", "math-core")>]
let importAdd (a: int) (b: int) : int = nativeOnly

[<Import("fibonacci", "math-core")>]
let importFibonacci (n: int) : int = nativeOnly

[<Import("dotProduct", "math-core")>]
let importDotProduct (x1: float) (y1: float) (x2: float) (y2: float) : float = nativeOnly

[<Import("intPow", "math-core")>]
let importIntPow (b: int) (e: int) : int = nativeOnly

[<Import("sortMedian5", "math-core")>]
let importSortMedian5 (a: int) (b: int) (c: int) (d: int) (e: int) : int = nativeOnly

[<Import("countAbove", "math-core")>]
let importCountAbove (a: int) (b: int) (c: int) (d: int) (e: int) (threshold: int) : int = nativeOnly

// ── Primitives (from component-linking baseline) ──────────────────────────────

/// Sum of F(0)+F(1)+...+F(n) — demonstrated cross-module call in a loop.
let sumOfFibs (n: int) : int =
    let mutable acc = 0
    let mutable i = 0
    while i <= n do
        acc <- importAdd acc (importFibonacci i)
        i <- i + 1
    acc

/// |v|^2 = x*x + y*y  (no sqrt needed; uses cross-module dotProduct).
let magnitudeSquared (x: float) (y: float) : float =
    importDotProduct x y x y

/// Triangle number 1+2+...+n.
let triangleNumber (n: int) : int =
    let mutable acc = 0
    let mutable i = 1
    while i <= n do
        acc <- importAdd acc i
        i <- i + 1
    acc

// ── WasmGC Array showcase ─────────────────────────────────────────────────────

/// Sum of squares of 5 inputs — each square computed via cross-module intPow,
/// stored in a WasmGC array, then summed by a loop.
let powersAndSum (a: int) (b: int) (c: int) (d: int) (e: int) : int =
    let squares = [| importIntPow a 2; importIntPow b 2; importIntPow c 2
                     importIntPow d 2; importIntPow e 2 |]
    let mutable total = 0
    let mutable i = 0
    while i < squares.Length do
        total <- total + squares.[i]
        i <- i + 1
    total

/// Returns 1 if the median of 5 inputs is even, 0 otherwise.
/// Delegates sorting to MathCore (cross-module call), then checks parity in App.
let medianIsEven (a: int) (b: int) (c: int) (d: int) (e: int) : int =
    let med = importSortMedian5 a b c d e
    if med % 2 = 0 then 1 else 0

// ── WasmGC String showcase ────────────────────────────────────────────────────

/// Classify two ints as "even" or "odd", concatenate with "+", return total length.
/// "even+even" -> 9, "even+odd"/"odd+even" -> 8, "odd+odd" -> 7
let parityLabel (a: int) (b: int) : int =
    let s1 = if a % 2 = 0 then "even" else "odd"
    let s2 = if b % 2 = 0 then "even" else "odd"
    let combined = s1 + "+" + s2
    combined.Length

/// Map a numeric score to a grade string and return its length.
/// 9 (Excellent) / 4 (Good) / 4 (Pass) / 10 (Borderline) / 4 (Fail)
let gradeMessage (score: int) : int =
    let msg =
        if score >= 90 then "Excellent"
        elif score >= 80 then "Good"
        elif score >= 70 then "Pass"
        elif score >= 60 then "Borderline"
        else "Fail"
    msg.Length
