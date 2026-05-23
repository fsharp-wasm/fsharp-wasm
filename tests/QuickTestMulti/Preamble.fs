
/// Minimal WasmGc hello-world: pure integer arithmetic, no runtime needed.
/// These functions are exported automatically and can be called from JS/Node.
module QuickTest.WasmGc

// Fable.Core stubs (Import attribute, nativeOnly) are in fable-library-wasmgc/Interop.fs.
// No NuGet reference needed — we define what we use ourselves.
open WasmGc.Core

// Run `dotnet fsi build.fsx quicktest` and then add tests to this file,
// when you save they will be run automatically with latest changes in compiler.
// When everything works, move the tests to the appropriate file in tests/Main.
// Please don't add this file to your commits.

// ── External Wasm FFI — declared here, implemented in test-runner.mjs ───────
// This is how you call Rust/WASM/JS functions from F# compiled to WasmGC.
// The [<Import>] attribute declares a Wasm import: (moduleName, funcName).
// nativeOnly means "this body is never executed — the Wasm runtime provides it."
[<Import("wasmAdd", "testEnv")>]
let externWasmAdd (a: int) (b: int) : int = nativeOnly

[<Import("wasmMul", "testEnv")>]
let externWasmMul (a: int) (b: int) : int = nativeOnly

/// Simple addition
let add (a: int) (b: int) : int = a + b

/// Subtract
let sub (a: int) (b: int) : int = a - b

/// Multiply
let mul (a: int) (b: int) : int = a * b

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

// ─── Phase 3: Records ─────────────────────────────────────────────

/// 2D point record
type Point = { X: float; Y: float }

/// Euclidean distance from origin
let distanceFromOrigin (p: Point) : float =
    let x2 = p.X * p.X
    let y2 = p.Y * p.Y
    // Newton's integer sqrt won't work on float — use the Pythagorean triple 3,4,5
    x2 + y2   // return x²+y² so the test can verify without sqrt

/// Create a point and read its fields
let pointSum (x: float) (y: float) : float =
    let p = { X = x; Y = y }
    p.X + p.Y

/// Mutable counter record
type Counter = { mutable Count: int }

/// Increment a counter 3 times and return the value
let runCounter () : int =
    let c = { Count = 0 }
    c.Count <- c.Count + 1
    c.Count <- c.Count + 1
    c.Count <- c.Count + 1
    c.Count

/// Nested record access
type Rect = { TopLeft: Point; BottomRight: Point }

let rectWidth (r: Rect) : float =
    r.BottomRight.X - r.TopLeft.X

// ─── JS-callable wrappers for record-arg functions ────────────────
// WasmGC struct references cannot cross the JS/Wasm boundary directly,
// so we expose thin wrappers that construct the record from primitives.
