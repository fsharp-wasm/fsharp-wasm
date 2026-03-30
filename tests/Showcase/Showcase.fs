/// Showcase: Real-world F# compiled to WasmGC.
/// Demonstrates: recursion, loops, arrays, lists, records, pattern matching, strings.
/// Each exported function returns an int so the Node.js runner can check the result.
module Showcase

open Fable.Core

// ── Fibonacci (recursive) ────────────────────────────────────────────────────

let rec fib (n: int) : int =
    if n <= 1 then n else fib (n - 1) + fib (n - 2)

let showcaseFib10 () : int = fib 10    // 55
let showcaseFib20 () : int = fib 20    // 6765

// ── Primes — trial division ──────────────────────────────────────────────────

let isPrime (n: int) : bool =
    if n < 2 then false
    else
        let mutable i = 2
        let mutable ok = true
        while i * i <= n && ok do
            if n % i = 0 then ok <- false
            i <- i + 1
        ok

let showcaseIsPrime97 ()  : int = if isPrime 97  then 1 else 0   // 1
let showcaseIsPrime100 () : int = if isPrime 100 then 1 else 0   // 0

/// Count primes up to n (inclusive).
let countPrimes (n: int) : int =
    let mutable count = 0
    for i in 2 .. n do
        if isPrime i then count <- count + 1
    count

let showcaseCountPrimesTo100 () : int = countPrimes 100   // 25

// ── Project Euler #1: sum of multiples of 3 or 5 below 1000 ─────────────────

let sumMultiples35 (limit: int) : int =
    let mutable sum = 0
    for i in 1 .. limit - 1 do
        if i % 3 = 0 || i % 5 = 0 then sum <- sum + i
    sum

let showcaseSumMultiples35 () : int = sumMultiples35 1000   // 233168

// ── Project Euler #2: sum of even Fibonacci numbers ≤ 4,000,000 ─────────────

let sumEvenFibs (limit: int) : int =
    let mutable a = 1
    let mutable b = 2
    let mutable sum = 0
    while b <= limit do
        if b % 2 = 0 then sum <- sum + b
        let c = a + b
        a <- b
        b <- c
    sum

let showcaseSumEvenFibs () : int = sumEvenFibs 4_000_000   // 4613732

// ── Collatz sequence ─────────────────────────────────────────────────────────

let collatzSteps (n: int) : int =
    let mutable x = n
    let mutable steps = 0
    while x <> 1 do
        if x % 2 = 0 then x <- x / 2 else x <- 3 * x + 1
        steps <- steps + 1
    steps

let showcaseCollatz27 () : int = collatzSteps 27   // 111

// ── FizzBuzz (encodes as bit-packed int for testing) ─────────────────────────
// Returns: count of "Fizz" (div by 3 only), "Buzz" (div by 5 only),
// "FizzBuzz" (div by 15) in range 1..100.
// [0..15]: fizz-count, [16..31]: buzz-count, [32..47]: fizzbuzz-count
let fizzBuzzCounts () : int =
    let mutable fizz = 0
    let mutable buzz = 0
    let mutable fb = 0
    for i in 1 .. 100 do
        let d3 = i % 3 = 0
        let d5 = i % 5 = 0
        if d3 && d5 then fb <- fb + 1
        elif d3 then fizz <- fizz + 1
        elif d5 then buzz <- buzz + 1
    fizz ||| (buzz <<< 8) ||| (fb <<< 16)
    // fizz=27, buzz=14, fb=6 → 27 | (14 << 8) | (6 << 16) = 396827

let showcaseFizzBuzz () : int = fizzBuzzCounts ()   // 396827

// ── List operations ──────────────────────────────────────────────────────────

let showcaseListSum () : int =
    // sum 1..100 via fold over explicit list (range syntax goes through Seq.toList)
    let mutable s = 0
    for i in 1 .. 100 do s <- s + i
    s   // 5050

let showcaseListFilter () : int =
    [2; 4; 6; 8; 10; 12; 14; 16; 18; 20]
    |> List.sum   // 110

let showcaseListMap () : int =
    [1; 2; 3; 4; 5]
    |> List.map (fun x -> x * x)
    |> List.sum   // 1+4+9+16+25 = 55

let showcaseListFold () : int =
    List.fold (fun acc x -> acc + x) 0 [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]   // 55

// ── Array operations ─────────────────────────────────────────────────────────

let showcaseArraySum () : int =
    let arr = Array.init 10 (fun i -> i + 1)   // [|1..10|]
    Array.fold (fun acc x -> acc + x) 0 arr     // 55

let showcaseArrayMap () : int =
    let a = [| 1; 2; 3; 4; 5 |]
    let b = Array.map (fun x -> x * 2) a
    Array.sum b   // 2+4+6+8+10 = 30

let showcaseArrayFilter () : int =
    let a = Array.init 10 (fun i -> i + 1)   // [|1..10|]
    a |> Array.filter (fun x -> x % 2 = 1) |> Array.sum   // 1+3+5+7+9 = 25

// ── Records ──────────────────────────────────────────────────────────────────

type Point = { X: int; Y: int }

let distance2 (p: Point) : int = p.X * p.X + p.Y * p.Y

let showcaseRecord () : int =
    let p = { X = 3; Y = 4 }
    distance2 p   // 25

type Stats = { Count: int; Sum: int; Min: int; Max: int }

let computeStats (xs: int list) : Stats =
    match xs with
    | [] -> { Count = 0; Sum = 0; Min = 0; Max = 0 }
    | h :: _ ->
        List.fold
            (fun s x -> {
                Count = s.Count + 1
                Sum   = s.Sum + x
                Min   = if x < s.Min then x else s.Min
                Max   = if x > s.Max then x else s.Max
            })
            { Count = 1; Sum = h; Min = h; Max = h }
            (List.tail xs)

let showcaseStats () : int =
    let s = computeStats [3; 1; 4; 1; 5; 9; 2; 6]
    s.Sum   // 31

let showcaseStatsMax () : int =
    let s = computeStats [3; 1; 4; 1; 5; 9; 2; 6]
    s.Max   // 9

// ── Sorting ──────────────────────────────────────────────────────────────────

let showcaseSort () : int =
    List.sortBy id [9; 3; 7; 1; 5]
    |> List.head   // 1

let showcaseSortDesc () : int =
    List.sortByDescending id [9; 3; 7; 1; 5]
    |> List.head   // 9

// ── String operations ────────────────────────────────────────────────────────

let showcaseStringLen () : int =
    "Hello, WasmGC!".Length   // 14

let showcaseStringUpper () : int =
    "hello".ToUpper().Length   // 5 (and it's "HELLO")

let showcaseStringContains () : int =
    if "WasmGC rocks".Contains("rocks") then 1 else 0   // 1

// ── Option operations ────────────────────────────────────────────────────────

let safeDiv (a: int) (b: int) : int option =
    if b = 0 then None else Some (a / b)

let showcaseSafeDiv () : int =
    match safeDiv 10 2 with
    | Some v -> v   // 5
    | None   -> -1

let showcaseSafeDivZero () : int =
    match safeDiv 10 0 with
    | Some v -> v
    | None   -> -1   // -1
