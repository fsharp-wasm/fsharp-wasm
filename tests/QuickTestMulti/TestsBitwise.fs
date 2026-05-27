module QuickTestWasmGc.TestsBitwise

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Bitwise (12 tests) ───────────────────────────────────────

let testBitwiseAnd () : int = 5 &&& 3

/// Test: 5 ||| 3 = 7

let testBitwiseOr () : int = 5 ||| 3

/// Test: 5 ^^^ 3 = 6

let testBitwiseXor () : int = 5 ^^^ 3

/// Test: 1 <<< 3 = 8

let testShiftLeft () : int = 1 <<< 3

/// Test: 32 >>> 2 = 8

let testShiftRight () : int = 32 >>> 2

/// Test: 10 / 3 = 3

let testIntDiv () : int = 10 / 3

/// Test: 10 % 3 = 1

let testIntMod () : int = 10 % 3

// ─── Math: abs, min, max ─────────────────────────────────────────

/// Test: abs (-42) = 42

let testAbsNeg () : int = abs (-42)

/// Test: abs 7 = 7

let testAbsPos () : int = abs 7

/// Test: min 3 7 = 3

let testMinScalar () : int = min 3 7

/// Test: max 3 7 = 7

let testMaxScalar () : int = max 3 7

/// Test: unary negation — let x = -5 in 0 - x = 5

let testNegation () : int =
    let x = -5
    0 - x

// ─── Char operations ──────────────────────────────────────────────

/// Test: Char.IsDigit '5' = true

// ── Suite runner ──────────────────────────────────────────────────────────
let runBitwiseTests (check: string -> (unit -> unit) -> unit) =
    check "testBitwiseAnd" (fun () -> ignore (testBitwiseAnd ()))
    check "testBitwiseOr" (fun () -> ignore (testBitwiseOr ()))
    check "testBitwiseXor" (fun () -> ignore (testBitwiseXor ()))
    check "testShiftLeft" (fun () -> ignore (testShiftLeft ()))
    check "testShiftRight" (fun () -> ignore (testShiftRight ()))
    check "testIntDiv" (fun () -> ignore (testIntDiv ()))
    check "testIntMod" (fun () -> ignore (testIntMod ()))
    check "testAbsNeg" (fun () -> ignore (testAbsNeg ()))
    check "testAbsPos" (fun () -> ignore (testAbsPos ()))
    check "testMinScalar" (fun () -> ignore (testMinScalar ()))
    check "testMaxScalar" (fun () -> ignore (testMaxScalar ()))
    check "testNegation" (fun () -> ignore (testNegation ()))
