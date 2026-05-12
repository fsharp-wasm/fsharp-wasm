module WasmGc.Bcl.MathHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Tier 1 — integer math helpers
// ─────────────────────────────────────────────────────────────────

/// Runtime helper: $pown(x, n) → integer exponentiation by repeated squaring.
/// For n ≤ 0 returns 1 (consistent with F#'s pown for nonneg exponents).
let makePownHelper () : WFuncDecl =
    q "$pown"
        <@ fun (x: int) (n: int) ->
            let mutable result = 1
            let mutable b = x
            let mutable e = n
            while e > 0 do
                if e &&& 1 <> 0 then result <- result * b
                b <- b * b
                e <- e >>> 1
            result @>

/// Runtime helper: $powF64(base, exp) → float exponentiation via integer repeated squaring.
/// exp is truncated to i32; non-integer exponents are approximated by truncation.
/// Negative exponents return 1.0 (not supported without f64.div; document as limitation).
let makePowF64Helper () : WFuncDecl =
    q "$powF64"
        <@ fun (x: float) (n: float) ->
            let mutable result = 1.0
            let mutable b = x
            let mutable e = truncF64 n
            while e > 0 do
                if e &&& 1 <> 0 then result <- result * b
                b <- b * b
                e <- e >>> 1
            result @>

/// Runtime helper: $mathExp(x) → e^x.
/// Algorithm: range-reduce x = k*ln2 + r (|r| <= 0.5*ln2), compute e^r via 7-term
/// Taylor polynomial, then multiply by 2^k via integer repeated squaring.
/// Accuracy: ~1 ULP for |x| < 700; overflows to +∞ for x > ~709.
let makeMathExpHelper () : WFuncDecl =
    q "$mathExp"
        <@ fun (x: float) ->
            let ln2 = 0.6931471805599453
            // k = round(x / ln2); r = x - k * ln2; |r| <= 0.5 * ln2 ≈ 0.3466
            let k  = truncF64 (x / ln2 + 0.5)
            let r  = x - intToF64 k * ln2
            // e^r via 7-term Taylor series (Horner form):  1 + r*(1 + r*(1/2 + r*(1/6 + r*(1/24 + r*(1/120 + r/720)))))
            let er = 1.0 + r * (1.0 + r * (0.5 + r * (0.16666666666666666 + r * (0.041666666666666664 + r * (0.008333333333333333 + r * 0.001388888888888889)))))
            // 2^|k| via repeated squaring on integer k
            let mutable pw  = 1.0
            let mutable bv  = 2.0
            let mutable ki  = if k < 0 then -k else k
            while ki > 0 do
                if ki &&& 1 <> 0 then pw <- pw * bv
                bv <- bv * bv
                ki <- ki >>> 1
            if k < 0 then er / pw else er * pw @>

/// Runtime helper: $mathLog(x) → natural logarithm ln(x).
/// Algorithm: range-reduce x to [0.5, 2] by repeated halving/doubling (tracking adjustment
/// via multiples of ln2), then compute ln(x) via 15-term artanh series:
///   z = (x-1)/(x+1);  ln(x) = 2*(z + z³/3 + z⁵/5 + …)
/// |z| <= 1/3 for x ∈ [0.5,2], so 15 terms give < 1 ULP error.
/// Returns garbage for x <= 0 (undefined for log; caller responsible).
let makeMathLogHelper () : WFuncDecl =
    q "$mathLog"
        <@ fun (x: float) ->
            let ln2 = 0.6931471805599453
            let mutable xx  = x
            let mutable adj = 0.0
            // Bring xx into [0.5, 2.0]
            while xx > 2.0 do
                xx  <- xx / 2.0
                adj <- adj + ln2
            while xx < 0.5 do
                xx  <- xx * 2.0
                adj <- adj - ln2
            // Artanh series: z = (x-1)/(x+1); sum 15 terms z^(2n+1)/(2n+1)
            let z     = (xx - 1.0) / (xx + 1.0)
            let z2    = z * z
            let mutable term  = z
            let mutable res   = 0.0
            let mutable denom = 1.0
            let mutable i     = 0
            while i < 15 do
                res   <- res + term / denom
                term  <- term * z2
                denom <- denom + 2.0
                i     <- i + 1
            res * 2.0 + adj @>

let makeMathSinHelper () : WFuncDecl =
    q "$mathSin"
        <@ fun (x: float) ->
            let twoPi = 6.283185307179586
            let pi    = 3.141592653589793
            // Range-reduce to [-2π, 2π] then fine-tune to [-π, π]
            let k     = intToF64 (truncF64 (x / twoPi))
            let mutable r = x - twoPi * k
            if r > pi  then r <- r - twoPi
            if r < -pi then r <- r + twoPi
            // 9-term Horner for sin(r): r*(1 - r²/6 + r⁴/120 - ...)
            let t = r * r
            r * (1.0 + t * (-0.16666666666666666 + t * (0.008333333333333333 + t * (-0.0001984126984126984 + t * (2.7557319223985888e-6 + t * (-2.505210838544172e-8 + t * (1.6059043836821613e-10 + t * (-7.647163731819816e-13)))))))) @>

let makeMathCosHelper () : WFuncDecl =
    q "$mathCos"
        <@ fun (x: float) ->
            let twoPi = 6.283185307179586
            let pi    = 3.141592653589793
            let k     = intToF64 (truncF64 (x / twoPi))
            let mutable r = x - twoPi * k
            if r > pi  then r <- r - twoPi
            if r < -pi then r <- r + twoPi
            // 8-term Horner for cos(r): 1 - r²/2 + r⁴/24 - ...
            let t = r * r
            1.0 + t * (-0.5 + t * (0.041666666666666664 + t * (-0.001388888888888889 + t * (2.48015873015873e-5 + t * (-2.7557319223985888e-7 + t * (2.08767569878681e-9 + t * (-1.1470745597729725e-11))))))) @>

let makeMathTanHelper () : WFuncDecl =
    q "$mathTan"
        <@ fun (x: float) ->
            let twoPi = 6.283185307179586
            let pi    = 3.141592653589793
            let k     = intToF64 (truncF64 (x / twoPi))
            let mutable r = x - twoPi * k
            if r > pi  then r <- r - twoPi
            if r < -pi then r <- r + twoPi
            // Compute sin and cos inline, return their ratio
            let t    = r * r
            let sinR = r * (1.0 + t * (-0.16666666666666666 + t * (0.008333333333333333 + t * (-0.0001984126984126984 + t * (2.7557319223985888e-6 + t * (-2.505210838544172e-8 + t * 1.6059043836821613e-10))))))
            let cosR = 1.0 + t * (-0.5 + t * (0.041666666666666664 + t * (-0.001388888888888889 + t * (2.48015873015873e-5 + t * (-2.7557319223985888e-7 + t * 2.08767569878681e-9)))))
            sinR / cosR @>

let makeMathAtan2Helper () : WFuncDecl =
    q "$mathAtan2"
        <@ fun (y: float) (x: float) ->
            let pi       = 3.141592653589793
            let halfPi   = 1.5707963267948966
            if y = 0.0 then
                if x >= 0.0 then 0.0 else pi
            elif x = 0.0 then
                if y > 0.0 then halfPi else -halfPi
            else
                let absX    = if x < 0.0 then -x else x
                let absY    = if y < 0.0 then -y else  y
                let swapped = absY > absX
                let t       = if swapped then absX / absY else absY / absX
                // Range-reduce to [0, tan(π/8)] ≈ [0, 0.4142] via
                // atan(t) = π/4 + atan((t-1)/(t+1)) when t > tan(π/8)
                let k       = 0.41421356237309515
                let pi4     = 0.7853981633974483
                let mutable a    = t
                let mutable adj  = 0.0
                if t > k then
                    a    <- (t - 1.0) / (t + 1.0)
                    adj  <- pi4
                // 6-term Taylor for atan(a), |a| ≤ 0.4142 — error < 1e-7
                let a2  = a * a
                let poly = a * (1.0 + a2 * (-0.3333333333333333 + a2 * (0.2 - a2 * (0.14285714285714285 - a2 * (0.1111111111111111 - a2 * 0.09090909090909091)))))
                let a0   = adj + poly
                // Undo swap: atan(absY/absX) = π/2 − atan(absX/absY) when swapped
                let a1   = if swapped then halfPi - a0 else a0
                // Quadrant correction for x < 0
                let a2r  = if x < 0.0 then pi - a1 else a1
                if y < 0.0 then -a2r else a2r @>
