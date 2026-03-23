/// App — higher-level functions built on top of MathCore Wasm imports.
///
/// The [<Import(selector, module)>] attribute declares a Wasm import.
/// At instantiation time, the host (test-runner.mjs) wires the imports by
/// passing `{ 'math-core': mathCoreInstance.exports }` as the import object.
///
/// This module exposes its own set of functions that the test runner checks.

module App

open Fable.Core

// ── Wasm imports from the 'math-core' component ──────────────────────────────
// Names match MathCore's export table exactly (plain F# function names,
// since MathCore is compiled as its own standalone project — no prefix).

[<Import("add", "math-core")>]
let importAdd (a: int) (b: int) : int = nativeOnly

[<Import("mul", "math-core")>]
let importMul (a: int) (b: int) : int = nativeOnly

[<Import("fibonacci", "math-core")>]
let importFibonacci (n: int) : int = nativeOnly

[<Import("dotProduct", "math-core")>]
let importDotProduct (x1: float) (y1: float) (x2: float) (y2: float) : float = nativeOnly

[<Import("intPow", "math-core")>]
let importIntPow (b: int) (e: int) : int = nativeOnly

// ── Higher-level wrappers ─────────────────────────────────────────────────────

/// Sum of the first n Fibonacci numbers F(0)+F(1)+...+F(n).
let sumOfFibs (n: int) : int =
    let mutable acc = 0
    let mutable i = 0
    while i <= n do
        acc <- importAdd acc (importFibonacci i)
        i <- i + 1
    acc

/// Squared magnitude of a 2-D vector: x·x + y·y  (= dotProduct(v,v)).
let magnitudeSquared (x: float) (y: float) : float =
    importDotProduct x y x y

/// Triangle number: 1 + 2 + ... + n  (uses importAdd from MathCore).
let triangleNumber (n: int) : int =
    let mutable acc = 0
    let mutable i = 1
    while i <= n do
        acc <- importAdd acc i
        i <- i + 1
    acc
