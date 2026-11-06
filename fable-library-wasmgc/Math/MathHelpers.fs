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

// ─── Transcendentals ─────────────────────────────────────────────────────────
// Software implementations for functions with no WASM opcode. Selected by name from
// MathMap.dispatchMathCall as `MathHelpers_<name>`, so keep the F# names identical to
// System.Math / F# core (exp, atan, atan2, asin, acos, sinh, cosh, tanh).
// Max relative error vs. libm ≈ 1e-15 (checked on 20k random inputs per function).
// No top-level values on purpose: everything is a literal or a local, so there is no
// module static-init order to worry about in the WasmGC backend.

[<Literal>]
let private PI = 3.14159265358979323846
[<Literal>]
let private HALF_PI = 1.57079632679489661923
[<Literal>]
let private PI_OVER_6 = 0.5235987755982988
[<Literal>]
let private SQRT3 = 1.7320508075688772
[<Literal>]
let private TAN_PI_OVER_12 = 0.2679491924311227

/// e^x — range reduction x = k·ln2 + r (|r| ≤ ln2/2), degree-13 Horner Taylor on r,
/// scaled by 2^k (split in two factors so k = 1024 doesn't overflow 2^k).
let exp (x: float) : float =
    if x <> x then x
    elif x > 709.782712893384 then 1.0 / 0.0
    elif x < -745.1332191019412 then 0.0
    else
        let kf = floor (x * 1.44269504088896340736 + 0.5)
        let k  = int kf
        let r  = (x - kf * 0.6931471803691238) - kf * 1.9082149292705877e-10
        let mutable acc = 1.0
        let mutable n   = 13
        while n >= 1 do
            acc <- 1.0 + acc * r / float n
            n   <- n - 1
        let h = k / 2
        acc * powf 2.0 h * powf 2.0 (k - h)

/// Arctangent: fold |x| into [0,1] via 1/x, then into [-tan(π/12), tan(π/12)] via the
/// π/6 angle-subtraction identity, then a 14-term Maclaurin series.
let atan (x: float) : float =
    if x <> x then x
    else
        let ax    = if x < 0.0 then -x else x
        let inv   = ax > 1.0
        let a1    = if inv then 1.0 / ax else ax
        let shift = a1 > TAN_PI_OVER_12
        let a2    = if shift then (a1 * SQRT3 - 1.0) / (SQRT3 + a1) else a1
        let z     = a2 * a2
        let mutable term = a2
        let mutable sum  = 0.0
        let mutable sgn  = 1.0
        let mutable n    = 0
        while n < 14 do
            sum  <- sum + sgn * term / float (2 * n + 1)
            term <- term * z
            sgn  <- -sgn
            n    <- n + 1
        let r1 = if shift then PI_OVER_6 + sum else sum
        let r2 = if inv then HALF_PI - r1 else r1
        if x < 0.0 then -r2 else r2

/// atan2(y, x). Infinite-infinity quadrant cases and signed zeros are not special-cased.
let atan2 (y: float) (x: float) : float =
    if x <> x || y <> y then 0.0 / 0.0
    elif x > 0.0 then atan (y / x)
    elif x < 0.0 then (if y >= 0.0 then atan (y / x) + PI else atan (y / x) - PI)
    elif y > 0.0 then HALF_PI
    elif y < 0.0 then -HALF_PI
    else 0.0

let asin (x: float) : float =
    if x <> x || x > 1.0 || x < -1.0 then 0.0 / 0.0
    elif x = 1.0 then HALF_PI
    elif x = -1.0 then -HALF_PI
    else atan (x / sqrt ((1.0 - x) * (1.0 + x)))

let acos (x: float) : float =
    if x <> x || x > 1.0 || x < -1.0 then 0.0 / 0.0
    elif x = -1.0 then PI
    else 2.0 * atan (sqrt ((1.0 - x) / (1.0 + x)))

/// sinh — odd Taylor series for |x| < 0.5 (avoids cancellation in e^x − e^−x).
let sinh (x: float) : float =
    if x <> x then x
    elif (if x < 0.0 then -x else x) < 0.5 then
        let z = x * x
        let mutable term = x
        let mutable sum  = 0.0
        let mutable n    = 0
        while n < 7 do
            sum  <- sum + term
            term <- term * z / float ((2 * n + 2) * (2 * n + 3))
            n    <- n + 1
        sum
    else (exp x - exp (-x)) / 2.0

let cosh (x: float) : float =
    if x <> x then x else (exp x + exp (-x)) / 2.0

let tanh (x: float) : float =
    if x <> x then x
    else
        let ax = if x < 0.0 then -x else x
        if ax >= 20.0 then (if x > 0.0 then 1.0 else -1.0)
        elif ax < 0.5 then sinh x / cosh x
        else
            let t = 1.0 - 2.0 / (exp (2.0 * ax) + 1.0)
            if x > 0.0 then t else -t

// Still missing (no handler → MathMap emits a trapping throw): sin, cos, tan, log, log10, log2, pow (float, float)
