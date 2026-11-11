/// Exact float → text, the way .NET prints it.
///
///   $floatToStr(x, is32)      `string x`, `x.ToString()`: the SHORTEST digits that read back as x ("R"), fixed notation
///                             for 1e-5 <= |x| < 1e15, otherwise `d.dddE+XX`.  `is32` = 1: the value is a float32.
///   $floatToFixed(x, prec)    `%.Nf` / `ToString("FN")`: the exact decimal expansion rounded half away from zero.
///
/// Both start from the EXACT decimal expansion of the double, built with schoolbook arithmetic on digit buffers
/// (one decimal digit per `WasmStr` element, least significant first):  x = m · 2^e  becomes  m · 5^-e / 10^-e
/// (e < 0) or  m · 2^e  (e >= 0).  Shortest digits: the expansions of the two midpoints to the neighbouring doubles
/// bound the interval that reads back as x; the first digit count p for which "v rounded to p digits" lies inside
/// it wins (inclusive bounds when the mantissa is even, as round-to-nearest-even parsing accepts them).
module WasmGc.Bcl.FloatFormat

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core
open WasmGc.Runtime.QuotationWalker
open WasmGc.Bcl.Helpers

// ── phantom declarations of the helper-to-helper calls (the bodies are the `q` definitions below) ─────────────
let fdMulSmall (_buf: WasmStr) (_off: int) (_len: int) (_k: int) : int = failwith "phantom"
let fdLoad (_buf: WasmStr) (_off: int) (_hi: int) (_lo: int) (_adj: int) : int = failwith "phantom"
let fdScale (_buf: WasmStr) (_off: int) (_len: int) (_hi: int) : int = failwith "phantom"
let fdDigit (_buf: WasmStr) (_off: int) (_len: int) (_total: int) (_i: int) : int = failwith "phantom"
let fdCmp (_cand: WasmStr) (_buf: WasmStr) (_off: int) (_len: int) (_total: int) : int = failwith "phantom"
let fdShortest (_x: float) (_is32: int) : WasmStr = failwith "phantom"
let fdExact (_x: float) : WasmStr = failwith "phantom"

/// Digit buffer capacity per number: 2^1026 and 5^1076 · 2^55 both have < 800 decimal digits.
[<Literal>]
let private Cap = 832

/// $fdMulSmall(buf, off, len, k) → new length: multiply the number at buf[off .. off+len) by k (< 2^15 + 1) in place.
let makeFdMulSmallHelper () : WFuncDecl =
    q "$fdMulSmall"
        <@ fun (buf: WasmStr) (off: int) (len: int) (k: int) ->
            let mutable carry = 0
            let mutable i = 0
            while i < len do
                let t = wsGet buf (off + i) * k + carry
                wsSet buf (off + i) (t % 10)
                carry <- t / 10
                i <- i + 1
            let mutable n = len
            while carry > 0 do
                wsSet buf (off + n) (carry % 10)
                carry <- carry / 10
                n <- n + 1
            n @>

/// $fdLoad(buf, off, hi, lo, adj) → digit count: write the decimal digits of  4·m + adj  (m = the mantissa with its
/// implicit bit) at buf[off ..], least significant first.  The number is held as five 16-bit limbs.
let makeFdLoadHelper () : WFuncDecl =
    q "$fdLoad"
        <@ fun (buf: WasmStr) (off: int) (hi: int) (lo: int) (adj: int) ->
            let normal = if ((hi >>> 20) &&& 2047) = 0 then 0 else 1
            let mutable l0 = (lo &&& 65535) * 4 + adj
            let mutable l1 = ((lo >>> 16) &&& 65535) * 4
            let mutable l2 = (hi &&& 65535) * 4
            let mutable l3 = (((hi >>> 16) &&& 15) + normal * 16) * 4
            let c0 = l0 >>> 16
            l0 <- l0 &&& 65535
            l1 <- l1 + c0
            let c1 = l1 >>> 16
            l1 <- l1 &&& 65535
            l2 <- l2 + c1
            let c2 = l2 >>> 16
            l2 <- l2 &&& 65535
            l3 <- l3 + c2
            let mutable l4 = l3 >>> 16
            l3 <- l3 &&& 65535
            let mutable n = 0
            let mutable more = 1
            while more = 1 do
                let a4 = l4
                let r4 = a4 % 10
                let a3 = r4 * 65536 + l3
                let r3 = a3 % 10
                let a2 = r3 * 65536 + l2
                let r2 = a2 % 10
                let a1 = r2 * 65536 + l1
                let r1 = a1 % 10
                let a0 = r1 * 65536 + l0
                wsSet buf (off + n) (a0 % 10)
                n <- n + 1
                l4 <- a4 / 10
                l3 <- a3 / 10
                l2 <- a2 / 10
                l1 <- a1 / 10
                l0 <- a0 / 10
                more <- if (l0 ||| l1 ||| l2 ||| l3 ||| l4) = 0 then 0 else 1
            n @>

/// $fdScale(buf, off, len, hi) → new length: multiply by 2^E (E >= 0) or 5^-E (E < 0), E = exponent of the mantissa
/// unit minus 2 (the factor 4 of `fdLoad`).  The value is then  digits / 10^max(0, -E).
let makeFdScaleHelper () : WFuncDecl =
    q "$fdScale"
        <@ fun (buf: WasmStr) (off: int) (len: int) (hi: int) ->
            let be = (hi >>> 20) &&& 2047
            let e = (if be = 0 then 1 else be) - 1077
            let mutable n = len
            let mutable r = if e >= 0 then e else 0 - e
            let step = if e >= 0 then 15 else 6
            let big = if e >= 0 then 32768 else 15625
            let small = if e >= 0 then 2 else 5
            while r >= step do
                n <- fdMulSmall buf off n big
                r <- r - step
            let mutable f = 1
            for i in 1 .. r do
                f <- f * small
            if f > 1 then n <- fdMulSmall buf off n f
            n @>

/// $fdDigit(buf, off, len, total, i) → the i-th digit from the top of a number right-aligned in `total` digits.
let makeFdDigitHelper () : WFuncDecl =
    q "$fdDigit"
        <@ fun (buf: WasmStr) (off: int) (len: int) (total: int) (i: int) ->
            let idx = total - 1 - i
            if idx >= len then 0
            elif idx < 0 then 0
            else wsGet buf (off + idx) @>

/// $fdCmp(cand, buf, off, len, total) → -1 / 0 / 1: the candidate (total+1 digits, top first) against a number.
let makeFdCmpHelper () : WFuncDecl =
    q "$fdCmp"
        <@ fun (cand: WasmStr) (buf: WasmStr) (off: int) (len: int) (total: int) ->
            let mutable res = 0
            let mutable i = 0
            while res = 0 && i <= total do
                let a = wsGet cand i
                let b = if i = 0 then 0 else fdDigit buf off len total (i - 1)
                if a < b then res <- -1
                elif a > b then res <- 1
                i <- i + 1
            res @>

/// $fdExact(x) → string: [10^3 + decimal exponent of the first digit, digits…]  of the exact expansion of x (> 0, finite).
let makeFdExactHelper () : WFuncDecl =
    q "$fdExact"
        <@ fun (x: float) ->
            let hi = f64Hi x
            let lo = f64Lo x
            let be = (hi >>> 20) &&& 2047
            let buf = wsCreate 832
            let n = fdScale buf 0 (fdLoad buf 0 hi lo 0) hi
            let e = (if be = 0 then 1 else be) - 1077
            let scale = if e < 0 then 0 - e else 0
            let res = wsCreate (n + 1)
            wsSet res 0 (n - 1 - scale + 1000)
            for i in 0 .. n - 1 do
                wsSet res (i + 1) (wsGet buf (n - 1 - i))
            res @>

/// $fdShortest(x, is32) → string: [10^3 + decimal exponent of the first digit, digits…] of the shortest digit string
/// that reads back as x (> 0, finite).  `is32`: the double is a float32 widened — the interval is that of a float32.
let makeFdShortestHelper () : WFuncDecl =
    q "$fdShortest"
        <@ fun (x: float) (is32: int) ->
            let hi = f64Hi x
            let lo = f64Lo x
            let be = (hi >>> 20) &&& 2047
            let mantZero = if (hi &&& 1048575) = 0 && lo = 0 then 1 else 0
            // half the gap to a neighbour, in units of a quarter of the mantissa's last place
            let adjHigh = if is32 = 1 then 1073741824 else 2
            let adjLow =
                if mantZero = 1 && be > (if is32 = 1 then 897 else 1)
                then (if is32 = 1 then 0 - 536870912 else 0 - 1)
                else (if is32 = 1 then 0 - 1073741824 else 0 - 2)
            let even = if is32 = 1 then 1 - ((lo >>> 29) &&& 1) else 1 - (lo &&& 1)
            let buf = wsCreate (3 * 832)
            let nv = fdScale buf 0 (fdLoad buf 0 hi lo 0) hi
            let nl = fdScale buf 832 (fdLoad buf 832 hi lo adjLow) hi
            let nh = fdScale buf 1664 (fdLoad buf 1664 hi lo adjHigh) hi
            let e = (if be = 0 then 1 else be) - 1077
            let scale = if e < 0 then 0 - e else 0
            let total = max nv (max nl nh)
            let first = total - nv                           // index of v's first digit
            let cand = wsCreate (total + 1)
            let mutable found = 0
            let mutable p = 1
            let mutable digits = 0
            while found = 0 && p <= total - first do
                // which of {down, up} is nearer to v: the digit after the p-th decides; an exact tie (a 5 followed
                // only by zeros) goes to the even neighbour, like .NET's Dragon4
                let roundDigit = if first + p < total then fdDigit buf 0 nv total (first + p) else 0
                let mutable restNonZero = 0
                for j in first + p + 1 .. total - 1 do
                    if fdDigit buf 0 nv total j <> 0 then restNonZero <- 1
                let prevDigit = fdDigit buf 0 nv total (first + p - 1)
                let nearerUp =
                    if roundDigit > 5 then 1
                    elif roundDigit < 5 then 0
                    else (if restNonZero = 1 || prevDigit % 2 = 1 then 1 else 0)
                let mutable attempt = 0
                while found = 0 && attempt < 2 do
                    // attempt 0: the nearer of {down, up}; attempt 1: the other one
                    let wantUp = if (attempt = 0) = (nearerUp = 1) then 1 else 0
                    // candidate digits, top first, with a spare digit in front for a carry
                    for j in 0 .. total - 1 do
                        wsSet cand (j + 1) (if j >= first && j < first + p then fdDigit buf 0 nv total j else 0)
                    wsSet cand 0 0
                    if wantUp = 1 then
                        let mutable pos = first + p          // cand index of the last kept digit is first + p - 1 + 1
                        let mutable carry = 1
                        while carry = 1 && pos >= 0 do
                            let d = wsGet cand pos + 1
                            if d = 10 then
                                wsSet cand pos 0
                                pos <- pos - 1
                            else
                                wsSet cand pos d
                                carry <- 0
                    let cl = fdCmp cand buf 832 nl total
                    let ch = fdCmp cand buf 1664 nh total
                    let lowOk = if cl > 0 || (cl = 0 && even = 1) then 1 else 0
                    let highOk = if ch < 0 || (ch = 0 && even = 1) then 1 else 0
                    if lowOk = 1 && highOk = 1 then
                        found <- 1
                        digits <- p
                    attempt <- attempt + 1
                if found = 0 then p <- p + 1
            if found = 0 then
                // not reached for a double (17 digits always suffice); fall back to the exact expansion
                fdExact x
            else
                // significant digits of the candidate, trailing zeros removed
                let carry = wsGet cand first                   // the cell above v's first digit (cand index = first)
                let start = if carry = 1 then first else first + 1
                let mutable last = total                       // cand index of the last digit
                while last > start && wsGet cand last = 0 do last <- last - 1
                let count = last - start + 1
                let res = wsCreate (count + 1)
                // exponent of the first digit: v's first digit has weight 10^(nv-1-scale); a carry adds one
                wsSet res 0 (nv - 1 - scale + carry + 1000)
                for i in 0 .. count - 1 do
                    wsSet res (i + 1) (wsGet cand (start + i))
                res @>

let floatToStr (_x: float) (_is32: int) : WasmStr = failwith "phantom"
let floatToFixed (_x: float) (_prec: int) : WasmStr = failwith "phantom"

/// $floatToStr(x, is32) → .NET's text of a float: "NaN", "Infinity", "-0", "0.1", "1E+15", "1.2345E-07" …
let makeFloatToStrHelper () : WFuncDecl =
    q "$floatToStr"
        <@ fun (x: float) (is32: int) ->
            let hi = f64Hi x
            let lo = f64Lo x
            let be = (hi >>> 20) &&& 2047
            let neg = if hi < 0 then 1 else 0
            if be = 2047 then
                if (hi &&& 1048575) = 0 && lo = 0 then
                    let r = wsCreate (8 + neg)
                    if neg = 1 then wsSet r 0 45
                    wsSet r neg 73
                    wsSet r (neg + 1) 110
                    wsSet r (neg + 2) 102
                    wsSet r (neg + 3) 105
                    wsSet r (neg + 4) 110
                    wsSet r (neg + 5) 105
                    wsSet r (neg + 6) 116
                    wsSet r (neg + 7) 121
                    r
                else
                    let r = wsCreate 3
                    wsSet r 0 78
                    wsSet r 1 97
                    wsSet r 2 78
                    r
            elif (hi &&& 2147483647) = 0 && lo = 0 then
                let r = wsCreate (1 + neg)
                if neg = 1 then wsSet r 0 45
                wsSet r neg 48
                r
            else
                let d = fdShortest (absF64 x) is32
                let exp10 = wsGet d 0 - 1000
                let n = wsLen d - 1
                // fixed notation for 1e-4 <= |x| < 1e17 (a float32: < 1e9); 0.00001 is "1E-05", 1e17 is "1E+17"
                if exp10 >= 0 - 4 && exp10 < (if is32 = 1 then 9 else 17) then
                    let intDigits = if exp10 >= 0 then exp10 + 1 else 0
                    let size =
                        if exp10 >= 0 then (if n <= intDigits then intDigits else n + 1)
                        else n + 1 + (0 - exp10)
                    let r = wsCreate (neg + size)
                    if neg = 1 then wsSet r 0 45
                    let mutable k = neg
                    if exp10 >= 0 then
                        for i in 0 .. intDigits - 1 do
                            wsSet r (k + i) (if i < n then wsGet d (i + 1) + 48 else 48)
                        k <- k + intDigits
                        if n > intDigits then
                            wsSet r k 46
                            k <- k + 1
                            for i in intDigits .. n - 1 do
                                wsSet r (k + i - intDigits) (wsGet d (i + 1) + 48)
                    else
                        wsSet r k 48
                        wsSet r (k + 1) 46
                        k <- k + 2
                        for i in 0 .. (0 - exp10 - 2) do
                            wsSet r (k + i) 48
                        k <- k + (0 - exp10 - 1)
                        for i in 0 .. n - 1 do
                            wsSet r (k + i) (wsGet d (i + 1) + 48)
                    r
                else
                    // scientific: d[.ddd]E±XX
                    let eAbs = if exp10 < 0 then 0 - exp10 else exp10
                    let eDigits = if eAbs >= 100 then 3 else 2
                    let size = (if n > 1 then n + 1 else 1) + 2 + eDigits
                    let r = wsCreate (neg + size)
                    if neg = 1 then wsSet r 0 45
                    let mutable k = neg
                    wsSet r k (wsGet d 1 + 48)
                    k <- k + 1
                    if n > 1 then
                        wsSet r k 46
                        k <- k + 1
                        for i in 1 .. n - 1 do
                            wsSet r (k + i - 1) (wsGet d (i + 1) + 48)
                        k <- k + n - 1
                    wsSet r k 69
                    wsSet r (k + 1) (if exp10 < 0 then 45 else 43)
                    k <- k + 2
                    if eDigits = 3 then
                        wsSet r k (eAbs / 100 + 48)
                        wsSet r (k + 1) (eAbs / 10 % 10 + 48)
                        wsSet r (k + 2) (eAbs % 10 + 48)
                    else
                        wsSet r k (eAbs / 10 + 48)
                        wsSet r (k + 1) (eAbs % 10 + 48)
                    r @>

/// $floatToFixed(x, prec) → x with exactly `prec` digits after the point (F# `%.Nf`, `ToString("FN")`): the exact decimal
/// expansion rounded half away from zero.
let makeFloatToFixedHelper () : WFuncDecl =
    q "$floatToFixed"
        <@ fun (x: float) (prec: int) ->
            let hi = f64Hi x
            let lo = f64Lo x
            let be = (hi >>> 20) &&& 2047
            let neg = if hi < 0 then 1 else 0
            if be = 2047 then
                if (hi &&& 1048575) = 0 && lo = 0 then
                    let r = wsCreate (8 + neg)
                    if neg = 1 then wsSet r 0 45
                    wsSet r neg 73
                    wsSet r (neg + 1) 110
                    wsSet r (neg + 2) 102
                    wsSet r (neg + 3) 105
                    wsSet r (neg + 4) 110
                    wsSet r (neg + 5) 105
                    wsSet r (neg + 6) 116
                    wsSet r (neg + 7) 121
                    r
                else
                    let r = wsCreate 3
                    wsSet r 0 78
                    wsSet r 1 97
                    wsSet r 2 78
                    r
            else
                // the digits of |x|: d[1 ..] with the first digit's decimal exponent exp10 (zero: no digits)
                let isZero = if (hi &&& 2147483647) = 0 && lo = 0 then 1 else 0
                let d = if isZero = 1 then wsCreate 1 else fdExact (absF64 x)
                let n = if isZero = 1 then 0 else wsLen d - 1
                let exp10 = if isZero = 1 then 0 else wsGet d 0 - 1000
                // M = round(|x| · 10^prec): its decimal digits are the first K digits of d, K = exp10 + 1 + prec
                let k = exp10 + 1 + prec
                let mLen = if k > 0 then k + 1 else 1               // + a leading slot for the carry
                let m = wsCreate mLen
                let mutable roundUp = 0
                if isZero = 0 then
                    if k >= 0 && k < n then
                        // round to nearest; an exact tie (a 5 followed only by zeros) goes to the even neighbour
                        let dk = wsGet d (k + 1)
                        if dk > 5 then roundUp <- 1
                        elif dk = 5 then
                            let mutable rest = 0
                            for j in k + 1 .. n - 1 do
                                if wsGet d (j + 1) <> 0 then rest <- 1
                            let prev = if k > 0 then wsGet d k else 0
                            roundUp <- if rest = 1 || prev % 2 = 1 then 1 else 0
                    if k > 0 then
                        for i in 0 .. k - 1 do
                            wsSet m (i + 1) (if i < n then wsGet d (i + 1) else 0)
                if roundUp = 1 then
                    let mutable pos = mLen - 1
                    let mutable carry = 1
                    while carry = 1 && pos >= 0 do
                        let v = wsGet m pos + 1
                        if v = 10 then
                            wsSet m pos 0
                            pos <- pos - 1
                        else
                            wsSet m pos v
                            carry <- 0
                // significant digits of M (leading zeros skipped), but at least prec + 1 so "0.00" keeps its zero
                let mutable first = 0
                while first < mLen - 1 && wsGet m first = 0 do first <- first + 1
                let nsig = mLen - first
                let total = if nsig > prec + 1 then nsig else prec + 1
                let intLen = total - prec
                let size = neg + total + (if prec > 0 then 1 else 0)
                let r = wsCreate size
                if neg = 1 then wsSet r 0 45
                let pad = total - nsig
                for i in 0 .. total - 1 do
                    let ch = if i < pad then 0 else wsGet m (first + i - pad)
                    let outPos = neg + i + (if i >= intLen then 1 else 0)
                    wsSet r outPos (ch + 48)
                if prec > 0 then wsSet r (neg + intLen) 46
                r @>
