module WasmGc.Bcl.MathHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Runtime.QuotationWalker
open WasmGc.Bcl.Helpers
open WasmGc.Builder

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

/// Runtime helper: $powF64(base, exp) → base ^ exp.
///   · a whole exponent (positive or negative): repeated squaring, exact for small cases; a negative exponent divides;
///   · any other exponent, base > 0: e^(exp · ln base) — ln by range reduction and the artanh series, e^y by range
///     reduction and a 14-term Taylor sum (error below 1e-15 relative);
///   · base = 0: 0 for a positive exponent, +∞ otherwise;  base < 0 with a fractional exponent: NaN.
/// (It used to truncate the exponent: Math.Pow(x, 2.4) was x², and a negative exponent gave 1.)
let makePowF64Helper () : WFuncDecl =
    q "$powF64"
        <@ fun (x: float) (n: float) ->
            let k = truncF64 n
            if intToF64 k = n then
                let mutable result = 1.0
                let mutable b = x
                let mutable e = if k < 0 then -k else k
                while e > 0 do
                    if e &&& 1 <> 0 then result <- result * b
                    b <- b * b
                    e <- e >>> 1
                if k < 0 then 1.0 / result else result
            elif x > 0.0 then
                let ln2 = 0.6931471805599453
                // ln x: bring x into [0.5, 2], then 2·artanh((x-1)/(x+1))
                let mutable xx  = x
                let mutable adj = 0.0
                while xx > 2.0 do
                    xx  <- xx / 2.0
                    adj <- adj + ln2
                while xx < 0.5 do
                    xx  <- xx * 2.0
                    adj <- adj - ln2
                let z  = (xx - 1.0) / (xx + 1.0)
                let z2 = z * z
                let mutable term  = z
                let mutable sum   = 0.0
                let mutable denom = 1.0
                let mutable i     = 0
                while i < 15 do
                    sum   <- sum + term / denom
                    term  <- term * z2
                    denom <- denom + 2.0
                    i     <- i + 1
                let y = n * (sum * 2.0 + adj)
                // e^y = 2^k · e^r with |r| <= ln2 / 2
                let kk = truncF64 (y / ln2 + (if y < 0.0 then -0.5 else 0.5))
                let r  = y - intToF64 kk * ln2
                let mutable er = 1.0
                let mutable j  = 14
                while j > 1 do
                    j  <- j - 1
                    er <- 1.0 + er * r / intToF64 j
                let mutable pw = 1.0
                let mutable bv = 2.0
                let mutable ki = if kk < 0 then -kk else kk
                while ki > 0 do
                    if ki &&& 1 <> 0 then pw <- pw * bv
                    bv <- bv * bv
                    ki <- ki >>> 1
                if kk < 0 then er / pw else er * pw
            elif x = 0.0 then
                if n > 0.0 then 0.0 else 1.0 / 0.0
            else 0.0 / 0.0 @>

/// Runtime helper: $mathExp(x) → e^x.
/// Algorithm: range-reduce x = k*ln2 + r (|r| <= 0.5*ln2), compute e^r via the Taylor
/// polynomial to r^13, then multiply by 2^k via integer repeated squaring.
/// Accuracy: a few ULP for |x| < 700; overflows to +∞ for x > ~709.
let makeMathExpHelper () : WFuncDecl =
    q "$mathExp"
        <@ fun (x: float) ->
            let ln2 = 0.6931471805599453
            // k = round(x / ln2); r = x - k * ln2; |r| <= 0.5 * ln2 ≈ 0.3466
            // (the half is added away from zero: truncation toward zero of x/ln2 + 0.5 left |r| up to ln2 for a negative x, where the series is off by 1e-13)
            let k  = truncF64 (x / ln2 + (if x < 0.0 then -0.5 else 0.5))
            let r  = x - intToF64 k * ln2
            // e^r via the Taylor series to r^13/13! (|r| <= 0.3466: the next term is below 1e-16; seven terms were off by 1e-7, measured 2026-11-26), in Horner form
            let er = 1.0 + r * (1.0 + r * (0.5 + r * (0.16666666666666666 + r * (0.041666666666666664 + r * (0.008333333333333333 + r * (0.001388888888888889 + r * (0.0001984126984126984 + r * (2.48015873015873e-05 + r * (2.7557319223985893e-06 + r * (2.755731922398589e-07 + r * (2.505210838544172e-08 + r * (2.08767569878681e-09 + r * 1.6059043836821613e-10))))))))))))
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

/// Runtime helper: $mathSin(x).  The reduction to a quarter turn and the series of sin r or cos r (the one the quadrant of x asks for), which at |r| <= π/4 are accurate to
/// about 1e-16: the terms they stop at are below that.  (They reduced to [-π, π], where the same series are off by up to 4e-6, measured 2026-11-26.)
let makeMathSinHelper () : WFuncDecl =
    q "$mathSin"
        <@ fun (x: float) ->
            // x = k·π/2 + r with |r| <= π/4: k the nearest whole number of quarter turns, π/2 in two parts so that k·pio2_1 is exact (Cody and Waite, as fdlibm does).
            // A very large x is first brought down by whole turns (what it could hold before: |x| below 1.3e10).
            let xr = if x > 1.0e6 || x < -1.0e6 then x - 6.283185307179586 * intToF64 (truncF64 (x / 6.283185307179586)) else x
            let k  = truncF64 (xr * 0.6366197723675814 + (if xr < 0.0 then -0.5 else 0.5))
            let kf = intToF64 k
            let r  = (xr - kf * 1.5707963267341256) - kf * 6.077100506506192e-11
            let t  = r * r
            let quad = k &&& 3
            let v = if (quad &&& 1) = 0 then r * (1.0 + t * (-0.16666666666666666 + t * (0.008333333333333333 + t * (-0.0001984126984126984 + t * (2.7557319223985893e-06 + t * (-2.505210838544172e-08 + t * (1.6059043836821613e-10 + t * (-7.647163731819816e-13 + t * 2.8114572543455206e-15)))))))) else 1.0 + t * (-0.5 + t * (0.041666666666666664 + t * (-0.001388888888888889 + t * (2.48015873015873e-05 + t * (-2.755731922398589e-07 + t * (2.08767569878681e-09 + t * (-1.1470745597729725e-11 + t * (4.779477332387385e-14 + t * -1.5619206968586225e-16))))))))
            if quad >= 2 then -v else v @>

/// Runtime helper: $mathCos(x): the same reduction; cos is sin a quarter turn on.
let makeMathCosHelper () : WFuncDecl =
    q "$mathCos"
        <@ fun (x: float) ->
            // x = k·π/2 + r with |r| <= π/4: k the nearest whole number of quarter turns, π/2 in two parts so that k·pio2_1 is exact (Cody and Waite, as fdlibm does).
            // A very large x is first brought down by whole turns (what it could hold before: |x| below 1.3e10).
            let xr = if x > 1.0e6 || x < -1.0e6 then x - 6.283185307179586 * intToF64 (truncF64 (x / 6.283185307179586)) else x
            let k  = truncF64 (xr * 0.6366197723675814 + (if xr < 0.0 then -0.5 else 0.5))
            let kf = intToF64 k
            let r  = (xr - kf * 1.5707963267341256) - kf * 6.077100506506192e-11
            let t  = r * r
            let quad = k &&& 3
            let v = if (quad &&& 1) = 0 then 1.0 + t * (-0.5 + t * (0.041666666666666664 + t * (-0.001388888888888889 + t * (2.48015873015873e-05 + t * (-2.755731922398589e-07 + t * (2.08767569878681e-09 + t * (-1.1470745597729725e-11 + t * (4.779477332387385e-14 + t * -1.5619206968586225e-16)))))))) else r * (1.0 + t * (-0.16666666666666666 + t * (0.008333333333333333 + t * (-0.0001984126984126984 + t * (2.7557319223985893e-06 + t * (-2.505210838544172e-08 + t * (1.6059043836821613e-10 + t * (-7.647163731819816e-13 + t * 2.8114572543455206e-15))))))))
            if quad = 1 || quad = 2 then -v else v @>

/// Runtime helper: $mathTan(x): sin r over cos r, or minus cos r over sin r a quarter turn on.
let makeMathTanHelper () : WFuncDecl =
    q "$mathTan"
        <@ fun (x: float) ->
            // x = k·π/2 + r with |r| <= π/4: k the nearest whole number of quarter turns, π/2 in two parts so that k·pio2_1 is exact (Cody and Waite, as fdlibm does).
            // A very large x is first brought down by whole turns (what it could hold before: |x| below 1.3e10).
            let xr = if x > 1.0e6 || x < -1.0e6 then x - 6.283185307179586 * intToF64 (truncF64 (x / 6.283185307179586)) else x
            let k  = truncF64 (xr * 0.6366197723675814 + (if xr < 0.0 then -0.5 else 0.5))
            let kf = intToF64 k
            let r  = (xr - kf * 1.5707963267341256) - kf * 6.077100506506192e-11
            let t  = r * r
            let quad = k &&& 3
            let sinR = r * (1.0 + t * (-0.16666666666666666 + t * (0.008333333333333333 + t * (-0.0001984126984126984 + t * (2.7557319223985893e-06 + t * (-2.505210838544172e-08 + t * (1.6059043836821613e-10 + t * (-7.647163731819816e-13 + t * 2.8114572543455206e-15))))))))
            let cosR = 1.0 + t * (-0.5 + t * (0.041666666666666664 + t * (-0.001388888888888889 + t * (2.48015873015873e-05 + t * (-2.755731922398589e-07 + t * (2.08767569878681e-09 + t * (-1.1470745597729725e-11 + t * (4.779477332387385e-14 + t * -1.5619206968586225e-16))))))))
            if (quad &&& 1) = 0 then sinR / cosR else -(cosR / sinR) @>

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
                // atan(a) for |a| <= 0.4142: once more around tan(π/16) (atan a = π/16 + atan((a - c) / (1 + a·c)), and symmetrically for a < 0) so that |b| <= 0.1989, and then
                // 11 terms of the series, whose next term is below 1e-16.  (Six terms on |a| <= 0.4142 were off by 1e-7, measured 2026-11-26.)
                let c16  = 0.198912367379658
                let pi16 = 0.19634954084936207
                let sgn  = if a < 0.0 then -1.0 else 1.0
                let aa   = sgn * a
                let mutable b    = a
                let mutable adj2 = 0.0
                if aa > 0.1 then
                    b    <- sgn * ((aa - c16) / (1.0 + aa * c16))
                    adj2 <- sgn * pi16
                let b2   = b * b
                let poly = b * (1.0 + b2 * (-0.3333333333333333 + b2 * (0.2 + b2 * (-0.14285714285714285 + b2 * (0.1111111111111111 + b2 * (-0.09090909090909091 + b2 * (0.07692307692307693 + b2 * (-0.06666666666666667 + b2 * (0.058823529411764705 + b2 * (-0.05263157894736842 + b2 * (0.047619047619047616 + b2 * -0.043478260869565216)))))))))))
                let a0   = adj + adj2 + poly
                // Undo swap: atan(absY/absX) = π/2 − atan(absX/absY) when swapped
                let a1   = if swapped then halfPi - a0 else a0
                // Quadrant correction for x < 0
                let a2r  = if x < 0.0 then pi - a1 else a1
                if y < 0.0 then -a2r else a2r @>
