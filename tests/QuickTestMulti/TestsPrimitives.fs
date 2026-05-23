module QuickTestWasmGc.TestsPrimitives

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── Primitives (28 tests) ───────────────────────────────────────

let testSwapPairFst (a: int) (b: int) : int =
    let x, _ = swapPair a b
    x

let testSwapPairSnd (a: int) (b: int) : int =
    let _, y = swapPair a b
    y

/// Min/max of two floats returned as a tuple
let minMax (a: float) (b: float) : float * float =
    if a <= b then (a, b) else (b, a)


let testMinMaxFirst (a: float) (b: float) : float =
    let mn, _ = minMax a b
    mn

let testMinMaxSecond (a: float) (b: float) : float =
    let _, mx = minMax a b
    mx

/// Sum components of a triple
let tripleSum (t: int * int * int) : int =
    let a, b, c = t
    a + b + c


let testTripleSum (a: int) (b: int) (c: int) : int =
    tripleSum (a, b, c)

// ─── Phase 5: Option<T> ──────────────────────────────────────────

/// defaultArg-style helper: return value if Some, else default
let optionOrDefault (opt: int option) (def: int) : int =
    match opt with
    | Some v -> v
    | None -> def

/// double the value if Some, else return sentinel -1
let optionDouble (opt: int option) : int =
    match opt with
    | Some v -> v * 2
    | None -> -1

/// isSome predicate
let optionIsSome (opt: int option) : bool =
    match opt with
    | Some _ -> true
    | None -> false

/// isNone predicate
let optionIsNone (opt: int option) : bool =
    match opt with
    | Some _ -> false
    | None -> true

/// Chained matching: Some(Some(v)) → extracts innermost value
let optionNested (v: int) : int =
    let outer = Some(Some v)
    match outer with
    | Some inner ->
        match inner with
        | Some x -> x
        | None -> -2
    | None -> -1

// JS-callable wrappers (Option structs can't cross the WASM/JS boundary directly).

let testIntOfFloat () : int = int 3.7

/// Test: int of negative float truncates toward zero → int -2.9 = -2

let testIntOfNegFloat () : int = int -2.9

/// Test: float of int → float 5 used in arithmetic → 5.0 * 2.0 = 10.0 → back to int

let testFloatOfInt () : int =
    let f : float = float 5
    int (f * 2.0)

/// Test: int64 from int32 → int64 7 + int64 3 = int64 10 → int 10

let testInt64OfInt () : int =
    let x : int64 = int64 7
    let y : int64 = int64 3
    int (x + y)

// ─── List.iter ────────────────────────────────────────────────────────────────

/// Test: List.iter via mutable accumulator → sum of [1;2;3;4;5] = 15

let testIsDigit () : int =
    if System.Char.IsDigit('5') then 1 else 0

/// Test: Char.IsDigit 'A' = false

let testIsDigitFalse () : int =
    if System.Char.IsDigit('A') then 1 else 0

/// Test: Char.IsLetter 'A' = true

let testIsLetter () : int =
    if System.Char.IsLetter('A') then 1 else 0

/// Test: Char.IsLetter '5' = false

let testIsLetterFalse () : int =
    if System.Char.IsLetter('5') then 1 else 0

/// Test: Char.IsUpper 'A' = true

let testIsWhiteSpace () : int =
    if System.Char.IsWhiteSpace(' ') then 1 else 0

/// Test: Char.IsLetterOrDigit '9' = true

let testIsLetterOrDigit () : int =
    if System.Char.IsLetterOrDigit('9') then 1 else 0

/// Test: Char.ToLower 'A' = 'a' (97)

let testFloatMul () : int =
    if 3.0 * 2.0 = 6.0 then 1 else 0

/// Test: float comparison 1.5 < 2.5

let testIdentityInt () : int = identity 99

/// Test: identity<float> 2.5 > 2.0 → 1

let testIdentityFloat () : int =
    if identity 2.5 > 2.0 then 1 else 0

/// Generic const2: returns first argument, discards second.
/// Exercises a two-type-parameter specialization.
let const2<'A, 'B> (a: 'A) (b: 'B) : 'A = a

/// Test: const2<int,float> 7 3.14 = 7

let testConst2IntFloat () : int = const2 7 3.14

/// Test: const2<int,int> 99 0 = 99

let testConst2IntInt () : int = const2 99 0

/// Test: const2<float,int> 2.5 42 → result > 2.0 → 1

let testConst2FloatInt () : int =
    if const2 2.5 42 > 2.0 then 1 else 0

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 9: fable-library-wasmgc/Map.fs — F# library compiled by our backend
// Tests call MapModule directly (src/fable-library-wasmgc/Map.fs).
// The library is a REAL F# source file, not compiler-internal WasmIR.
// ─────────────────────────────────────────────────────────────────────────────

/// Standard int comparator used by all MapModule/SetModule tests.
let private intCmp (a: int) (b: int) : int = if a < b then -1 elif a > b then 1 else 0

/// Test: MapModule.add + tryFind — found key → 100

let testIntParse () : int =
    System.Int32.Parse("42")

/// Test: Int32.Parse("-17") = -17

let testIntParseNeg () : int =
    System.Int32.Parse("-17")

/// Test: Int32.Parse("0") = 0

let testIntParseZero () : int =
    System.Int32.Parse("0")

// ── Double.Parse / float tests ─────────────────────────────────────────────

/// Test: float "3.14" * 100.0 |> int = 314

let testFloatParse () : int =
    int (float "3.14" * 100.0)

/// Test: float "-2.5" * 10.0 |> int = -25

let testFloatParseNeg () : int =
    int (float "-2.5" * 10.0)

/// Test: float "7" |> int = 7   (integer string, no dot)

let testFloatParseInt () : int =
    int (float "7")

// ── String.IsNullOrEmpty / String.compare ─────────────────────────────────

/// Test: String.IsNullOrEmpty "" = true (1)

let testSumMultiples35 () : int =
    let mutable sum = 0
    for i in 1 .. 999 do
        if i % 3 = 0 || i % 5 = 0 then sum <- sum + i
    sum

/// Collatz sequence steps for n=27 = 111

// ── Suite runner ──────────────────────────────────────────────────────────
let runPrimitivesTests (check: string -> (unit -> unit) -> unit) =
    check "testSwapPairFst" testSwapPairFst
    check "testSwapPairSnd" testSwapPairSnd
    check "testMinMaxFirst" testMinMaxFirst
    check "testMinMaxSecond" testMinMaxSecond
    check "testTripleSum" testTripleSum
    check "testIntOfFloat" testIntOfFloat
    check "testIntOfNegFloat" testIntOfNegFloat
    check "testFloatOfInt" testFloatOfInt
    check "testInt64OfInt" testInt64OfInt
    check "testIsDigit" testIsDigit
    check "testIsDigitFalse" testIsDigitFalse
    check "testIsLetter" testIsLetter
    check "testIsLetterFalse" testIsLetterFalse
    check "testIsWhiteSpace" testIsWhiteSpace
    check "testIsLetterOrDigit" testIsLetterOrDigit
    check "testFloatMul" testFloatMul
    check "testIdentityInt" testIdentityInt
    check "testIdentityFloat" testIdentityFloat
    check "testConst2IntFloat" testConst2IntFloat
    check "testConst2IntInt" testConst2IntInt
    check "testConst2FloatInt" testConst2FloatInt
    check "testIntParse" testIntParse
    check "testIntParseNeg" testIntParseNeg
    check "testIntParseZero" testIntParseZero
    check "testFloatParse" testFloatParse
    check "testFloatParseNeg" testFloatParseNeg
    check "testFloatParseInt" testFloatParseInt
    check "testSumMultiples35" testSumMultiples35
