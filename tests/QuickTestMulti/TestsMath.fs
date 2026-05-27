module QuickTestWasmGc.TestsMath

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Math (41 tests) ───────────────────────────────────────

let testDistanceFromOrigin (x: float) (y: float) : float =
    distanceFromOrigin { X = x; Y = y }


let testFib10 () : int = fibonacci 10

/// Test: fibonacci 15 = 610

let testFib15 () : int = fibonacci 15

// ── Showcase: Primes (array + loop) ──────────────────────────────────────

/// Naive primality test: O(n) trial division
let isPrime (n: int) : bool =
    if n < 2 then false
    else
        let mutable i = 2
        let mutable ok = true
        while i * i <= n && ok do
            if n % i = 0 then ok <- false
            i <- i + 1
        ok

/// Test: isPrime 7 = true → 1

let testIsPrime7 () : int = if isPrime 7 then 1 else 0

/// Test: isPrime 4 = false → 0

let testIsPrime4 () : int = if isPrime 4 then 1 else 0

/// Test: count primes up to 50 = 15 (2,3,5,7,11,13,17,19,23,29,31,37,41,43,47)

let testCountPrimesTo50 () : int =
    let mutable count = 0
    for i in 2 .. 50 do
        if isPrime i then count <- count + 1
    count

// ── Showcase: Project Euler style ────────────────────────────────────────

/// Sum of all multiples of 3 or 5 below 1000 = 233168

let testCollatz27 () : int =
    let mutable n = 27
    let mutable steps = 0
    while n <> 1 do
        if n % 2 = 0 then n <- n / 2
        else n <- 3 * n + 1
        steps <- steps + 1
    steps

// ── Showcase: List combinators ────────────────────────────────────────────

/// Test: Array.toList [|1;2;3|] |> List.sum = 6

let testPown2_10 () : int = pown 2 10

/// Test: pown 3 0 = 1

let testPownZero () : int = pown 3 0

/// Test: pown 5 3 = 125

let testPownCube () : int = pown 5 3

/// Test: pown 1 100 = 1

let testPownOne () : int = pown 1 100

// ── Math.Pow (float exponentiation) ───────────────────────────────────────

/// Test: 2.0 ** 10.0 = 1024.0 → truncate to int

let testPowF64_2_10 () : int = int (2.0 ** 10.0)

/// Test: 3.0 ** 0.0 = 1.0

let testPowF64_zero () : int = int (3.0 ** 0.0)

/// Test: 5.0 ** 3.0 = 125.0

let testPowF64_cube () : int = int (5.0 ** 3.0)

/// Test: Math.Pow(2.0, 8.0) = 256.0

let testMathPow () : int = int (System.Math.Pow(2.0, 8.0))

// ── ref.test DU pattern matching ──────────────────────────────────────────

type GeoShape =
    | GeoCircle of radius: float
    | GeoRect of w: float * h: float
    | GeoDot

/// Test: ref.test on data-carrying DU — GeoCircle branch.

let testMathExp_zero () : int = int (System.Math.Exp(0.0))

/// Test: Math.exp(1) ≈ 2.71828 → rounded to 2

let testMathExp_one () : int = int (System.Math.Exp(1.0))

/// Test: Math.exp(10) ≈ 22026.46 → int truncation = 22026

let testMathExp_ten () : int = int (System.Math.Exp(10.0))

/// Test: Math.exp(-1) ≈ 0.3678 → int truncation = 0

let testMathExp_neg () : int = int (System.Math.Exp(-1.0))

// ─── Math.Log ────────────────────────────────────────────────────────────────

/// Test: Math.log(1) = 0

let testMathLog_one () : int = int (System.Math.Log(1.0))

/// Test: Math.log(e) ≈ 1.0 → rounded to 1 (raw truncation unreliable due to polynomial error)

let testMathLog_e () : int = int (System.Math.Round(System.Math.Log(System.Math.Exp(1.0))))

/// Test: Math.log(1024) = 10*ln2 ≈ 6.93 → int = 6

let testMathLog_1024 () : int = int (System.Math.Log(1024.0))

/// Test: round-trip: int(exp(log(100)+0.5)) = 100 (within tolerance)

let testMathExpLogRoundtrip () : int = int (System.Math.Exp(System.Math.Log(100.0) + 0.5))

// ─── Math.Sin / Cos / Tan ─────────────────────────────────────────────────────

/// Test: Math.sin(0) = 0

let testMathSin_zero   () : int = int (System.Math.Sin(0.0))

/// Test: Math.sin(π/2) ≈ 1 → rounded

let testMathSin_90deg  () : int = int (System.Math.Round(System.Math.Sin(1.5707963267948966)))

/// Test: Math.cos(0) = 1 (Horner evaluates to exactly 1.0)

let testMathCos_zero   () : int = int (System.Math.Round(System.Math.Cos(0.0)))

/// Test: Math.cos(π) ≈ -1 → rounded

let testMathCos_180deg () : int = int (System.Math.Round(System.Math.Cos(3.141592653589793)))

/// Test: Math.tan(0) = 0

let testMathTan_zero   () : int = int (System.Math.Tan(0.0))

/// Test: Math.tan(π/4) ≈ 1 → rounded

let testMathTan_45deg  () : int = int (System.Math.Round(System.Math.Tan(0.7853981633974483)))

// ─── Bit manipulation (i32.clz / i32.ctz / i32.popcnt) ──────────────────────

/// Test: LeadingZeroCount(1) = 31 (binary 1 has 31 leading zeros in 32-bit)

let testClz_one () : int = System.Numerics.BitOperations.LeadingZeroCount(1u)

/// Test: LeadingZeroCount(0x80000000u) = 0 (highest bit set)

let testClz_highBit () : int = System.Numerics.BitOperations.LeadingZeroCount(0x80000000u)

/// Test: TrailingZeroCount(8) = 3 (8 = 0b1000, 3 trailing zeros)

let testCtz_eight () : int = System.Numerics.BitOperations.TrailingZeroCount(8u)

/// Test: TrailingZeroCount(1) = 0 (lowest bit set)

let testCtz_one () : int = System.Numerics.BitOperations.TrailingZeroCount(1u)

/// Test: PopCount(7) = 3 (0b111 has 3 set bits)

let testPopcnt_seven () : int = System.Numerics.BitOperations.PopCount(7u)

/// Test: PopCount(0xFFFFFFFFu) = 32 (all 32 bits set)

let testPopcnt_allOnes () : int = System.Numerics.BitOperations.PopCount(0xFFFFFFFFu)

// ─── StringBuilder ────────────────────────────────────────────────────────────

let testAtan2Origin () : int =
    // atan2(0, 1) = 0
    roundTo6 (System.Math.Atan2(0.0, 1.0))  // 0


let testAtan2PosX () : int =
    // atan2(1, 1) ≈ π/4 ≈ 0.785398
    roundTo6 (System.Math.Atan2(1.0, 1.0))  // 785398


let testAtan2NegX () : int =
    // atan2(0, -1) = π ≈ 3.141593
    roundTo6 (System.Math.Atan2(0.0, -1.0))  // 3141593


let testAtan2PosY () : int =
    // atan2(1, 0) = π/2 ≈ 1.570796
    roundTo6 (System.Math.Atan2(1.0, 0.0))  // 1570796


let testAtan2NegY () : int =
    // atan2(-1, 0) = -π/2 ≈ -1.570796
    roundTo6 (System.Math.Atan2(-1.0, 0.0))  // -1570796


let testAtan2Q3 () : int =
    // atan2(-1, -1) ≈ -3π/4 ≈ -2.356194
    roundTo6 (System.Math.Atan2(-1.0, -1.0))  // -2356194

// ─── List.partition ──────────────────────────────────────────────────────────


// ── Suite runner ──────────────────────────────────────────────────────────
let runMathTests (check: string -> (unit -> unit) -> unit) =
    check "testDistanceFromOrigin" (fun () -> ignore (testDistanceFromOrigin ()))
    check "testFib10" (fun () -> ignore (testFib10 ()))
    check "testFib15" (fun () -> ignore (testFib15 ()))
    check "testIsPrime7" (fun () -> ignore (testIsPrime7 ()))
    check "testIsPrime4" (fun () -> ignore (testIsPrime4 ()))
    check "testCountPrimesTo50" (fun () -> ignore (testCountPrimesTo50 ()))
    check "testCollatz27" (fun () -> ignore (testCollatz27 ()))
    check "testPown2_10" (fun () -> ignore (testPown2_10 ()))
    check "testPownZero" (fun () -> ignore (testPownZero ()))
    check "testPownCube" (fun () -> ignore (testPownCube ()))
    check "testPownOne" (fun () -> ignore (testPownOne ()))
    check "testPowF64_2_10" (fun () -> ignore (testPowF64_2_10 ()))
    check "testPowF64_zero" (fun () -> ignore (testPowF64_zero ()))
    check "testPowF64_cube" (fun () -> ignore (testPowF64_cube ()))
    check "testMathPow" (fun () -> ignore (testMathPow ()))
    check "testMathExp_zero" (fun () -> ignore (testMathExp_zero ()))
    check "testMathExp_one" (fun () -> ignore (testMathExp_one ()))
    check "testMathExp_ten" (fun () -> ignore (testMathExp_ten ()))
    check "testMathExp_neg" (fun () -> ignore (testMathExp_neg ()))
    check "testMathLog_one" (fun () -> ignore (testMathLog_one ()))
    check "testMathLog_e" (fun () -> ignore (testMathLog_e ()))
    check "testMathLog_1024" (fun () -> ignore (testMathLog_1024 ()))
    check "testMathExpLogRoundtrip" (fun () -> ignore (testMathExpLogRoundtrip ()))
    check "testMathSin_zero" (fun () -> ignore (testMathSin_zero ()))
    check "testMathSin_90deg" (fun () -> ignore (testMathSin_90deg ()))
    check "testMathCos_zero" (fun () -> ignore (testMathCos_zero ()))
    check "testMathCos_180deg" (fun () -> ignore (testMathCos_180deg ()))
    check "testMathTan_zero" (fun () -> ignore (testMathTan_zero ()))
    check "testMathTan_45deg" (fun () -> ignore (testMathTan_45deg ()))
    check "testClz_one" (fun () -> ignore (testClz_one ()))
    check "testClz_highBit" (fun () -> ignore (testClz_highBit ()))
    check "testCtz_eight" (fun () -> ignore (testCtz_eight ()))
    check "testCtz_one" (fun () -> ignore (testCtz_one ()))
    check "testPopcnt_seven" (fun () -> ignore (testPopcnt_seven ()))
    check "testPopcnt_allOnes" (fun () -> ignore (testPopcnt_allOnes ()))
    check "testAtan2Origin" (fun () -> ignore (testAtan2Origin ()))
    check "testAtan2PosX" (fun () -> ignore (testAtan2PosX ()))
    check "testAtan2NegX" (fun () -> ignore (testAtan2NegX ()))
    check "testAtan2PosY" (fun () -> ignore (testAtan2PosY ()))
    check "testAtan2NegY" (fun () -> ignore (testAtan2NegY ()))
    check "testAtan2Q3" (fun () -> ignore (testAtan2Q3 ()))
