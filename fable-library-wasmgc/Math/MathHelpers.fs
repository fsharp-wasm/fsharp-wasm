/// fable-library-wasmgc — Math helper operations.
/// Pure F# compiled by the Fable WasmGC backend.
/// Provides software implementations for math operations that have no native
/// WebAssembly opcode (sin, cos, pow, etc.). Native ops like abs, sqrt, floor,
/// ceil, trunc, round, min, max are handled directly by WasmGcMathMap.fs as
/// WASM intrinsics and don't appear here.
module MathHelpers

// ─── Integer power ───────────────────────────────────────────────────────────

/// Integer exponentiation: base ** exp (exp >= 0).
/// Uses exponentiation by squaring — O(log exp).
let powi (b: int) (exp: int) : int =
    let rec go acc b e =
        if e = 0 then acc
        elif e % 2 = 1 then go (acc * b) (b * b) (e / 2)
        else go acc (b * b) (e / 2)
    if exp < 0 then 0  // integer power with negative exp → 0
    else go 1 b exp

/// Float exponentiation: base ** exp (integer exponent).
let powf (b: float) (exp: int) : float =
    let rec go acc b e =
        if e = 0 then acc
        elif e % 2 = 1 then go (acc * b) (b * b) (e / 2)
        else go acc (b * b) (e / 2)
    if exp < 0 then
        1.0 / go 1.0 b (-exp)
    else
        go 1.0 b exp

// ─── Clamping ────────────────────────────────────────────────────────────────

/// Clamp a value to [lo, hi].
let clamp (lo: int) (hi: int) (value: int) : int =
    if value < lo then lo
    elif value > hi then hi
    else value

let clampf (lo: float) (hi: float) (value: float) : float =
    if value < lo then lo
    elif value > hi then hi
    else value

// ─── Future stubs ────────────────────────────────────────────────────────────
// The following transcendentals require Taylor/Chebyshev approximations
// or CORDIC algorithms. Implementations will be added as needed.
//
// Planned:
//   sin, cos, tan      — trigonometric
//   asin, acos, atan   — inverse trig
//   atan2              — two-argument arctangent
//   log, log10, log2   — logarithms
//   exp                — natural exponential
//   pow (float, float) — general power (via exp + log)
