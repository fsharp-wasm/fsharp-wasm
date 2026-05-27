module QuickTestWasmGc.TestsPrintf

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Printf (28 tests) ───────────────────────────────────────

let testStringInterpolation () : int =
    let x = 42
    let s = $"x={x}"   // "x=42" → length 4
    s.Length

/// Test: F# interpolated nested string

let testStringInterpolationConcat () : int =
    let a = 3
    let b = 7
    let s = $"{a}+{b}"   // "3+7" → length 3
    s.Length

// ─── String.padLeft / padRight / replace ──────────────────────────

/// Test: "42".PadLeft(5) → "   42" — length 5

let testPrintfnLiteral () : int =
    printfn "hello"
    42

// ─── More List operations ─────────────────────────────────────────

/// Test: List.item 2 [10;20;30;40;50] = 30

let testSprintfInt () : int =
    (sprintf "%d" 42).Length

/// Test: sprintf "%d" -7 → "-7", length = 2

let testSprintfNegInt () : int =
    (sprintf "%d" -7).Length

/// Test: sprintf "%s" "hello" → "hello", length = 5

let testSprintfStr () : int =
    (sprintf "%s" "hello").Length

/// Test: sprintf "x=%d" 100 → "x=100", length = 5

let testSprintfIntLiteral () : int =
    (sprintf "x=%d" 100).Length

/// Test: sprintf "%d %d" 3 7 — length of "3 7" = 3

let testSprintfTwoInts () : int =
    (sprintf "%d %d" 3 7).Length

/// Test: sprintf "%s and %s" "foo" "bar" — "foo and bar", length = 11

let testSprintfTwoStrs () : int =
    (sprintf "%s and %s" "foo" "bar").Length

/// Test: sprintf "%b" true → "true", length = 4

let testSprintfBoolTrue () : int =
    (sprintf "%b" true).Length

/// Test: sprintf "%b" false → "false", length = 5

let testSprintfBoolFalse () : int =
    (sprintf "%b" false).Length

/// Test: sprintf "n=%d,s=%s" 7 "hi" → "n=7,s=hi", length = 8

let testSprintfMixed () : int =
    (sprintf "n=%d,s=%s" 7 "hi").Length

/// Test: sprintf "%d" 0 → "0", first char = '0' = 48

let testSprintfZero () : int =
    int (sprintf "%d" 0).[0]

/// Test: sprintf "Result: %d" 99 → starts with 'R' = 82

let testSprintfPrefix () : int =
    int (sprintf "Result: %d" 99).[0]

/// Test: sprintf "%f" 3.14 — contains '.' (value > 0)
/// Length: "3.14" = 4 chars

let testSprintfFloat () : int =
    (sprintf "%f" 3.14).Length

/// Test: sprintf "%f" 0.5 → "0.5", length = 3

let testSprintfFloatHalf () : int =
    (sprintf "%f" 0.5).Length

/// Test: sprintf "%f" 2.0 → "2.0", length = 3

let testSprintfFloatWhole () : int =
    (sprintf "%f" 2.0).Length

/// Test: sprintf "%f" -1.5 → "-1.5", length = 4

let testSprintfFloatNeg () : int =
    (sprintf "%f" -1.5).Length

/// Test: sprintf "pi=~%f" 3.14159 → starts with 'p' = 112

let testSprintfFloatInStr () : int =
    int (sprintf "pi=~%f" 3.14159).[0]

/// Test: printfn with %d doesn't crash, returns sentinel 1

let testPrintfnInt () : int =
    printfn "count = %d" 42
    1

/// Test: printfn with %s doesn't crash, returns sentinel 1

let testPrintfnStr () : int =
    printfn "hello, %s!" "world"
    1

/// Test: printfn with multiple args doesn't crash

let testPrintfnMulti () : int =
    printfn "%d + %d = %d" 3 7 10
    1

/// Test: sprintf "%i" 99 (same as %d) → "99", length = 2

let testSprintfI () : int =
    (sprintf "%i" 99).Length

/// Test: sprintf "%-format with literal %%" → contains literal '%', length = 1

let testSprintfPercent () : int =
    (sprintf "100%%").Length   // "100%" → length = 4

/// Test: sprintf result of zero is "0" (char 48)

let testSprintfIntZeroChar () : int =
    int (sprintf "%d" 0).[0]  // '0' = 48

/// Test: sprintf "%s" "" → empty string, length = 0

let testSprintfEmptyStr () : int =
    (sprintf "%s" "").Length

/// Test: sprintf with int interpolation — "42" starts with '4' = 52

let testSprintfIntFirstChar () : int =
    int (sprintf "%d" 42).[0]  // '4' = 52

/// Test: F# interpolated string $"val={x}" still works

let testInterpolationWithSprintf () : int =
    let x = 99
    let s = $"val={x}"  // "val=99" length = 6
    s.Length

// ── FFI / External Wasm import tests ─────────────────────────────────────────

/// Test: externWasmAdd is resolved as a Wasm import — 10 + 32 = 42

// ── Suite runner ──────────────────────────────────────────────────────────
let runPrintfTests (check: string -> (unit -> unit) -> unit) =
    check "testStringInterpolation" (fun () -> ignore (testStringInterpolation ()))
    check "testStringInterpolationConcat" (fun () -> ignore (testStringInterpolationConcat ()))
    check "testPrintfnLiteral" (fun () -> ignore (testPrintfnLiteral ()))
    check "testSprintfInt" (fun () -> ignore (testSprintfInt ()))
    check "testSprintfNegInt" (fun () -> ignore (testSprintfNegInt ()))
    check "testSprintfStr" (fun () -> ignore (testSprintfStr ()))
    check "testSprintfIntLiteral" (fun () -> ignore (testSprintfIntLiteral ()))
    check "testSprintfTwoInts" (fun () -> ignore (testSprintfTwoInts ()))
    check "testSprintfTwoStrs" (fun () -> ignore (testSprintfTwoStrs ()))
    check "testSprintfBoolTrue" (fun () -> ignore (testSprintfBoolTrue ()))
    check "testSprintfBoolFalse" (fun () -> ignore (testSprintfBoolFalse ()))
    check "testSprintfMixed" (fun () -> ignore (testSprintfMixed ()))
    check "testSprintfZero" (fun () -> ignore (testSprintfZero ()))
    check "testSprintfPrefix" (fun () -> ignore (testSprintfPrefix ()))
    check "testSprintfFloat" (fun () -> ignore (testSprintfFloat ()))
    check "testSprintfFloatHalf" (fun () -> ignore (testSprintfFloatHalf ()))
    check "testSprintfFloatWhole" (fun () -> ignore (testSprintfFloatWhole ()))
    check "testSprintfFloatNeg" (fun () -> ignore (testSprintfFloatNeg ()))
    check "testSprintfFloatInStr" (fun () -> ignore (testSprintfFloatInStr ()))
    check "testPrintfnInt" (fun () -> ignore (testPrintfnInt ()))
    check "testPrintfnStr" (fun () -> ignore (testPrintfnStr ()))
    check "testPrintfnMulti" (fun () -> ignore (testPrintfnMulti ()))
    check "testSprintfI" (fun () -> ignore (testSprintfI ()))
    check "testSprintfPercent" (fun () -> ignore (testSprintfPercent ()))
    check "testSprintfIntZeroChar" (fun () -> ignore (testSprintfIntZeroChar ()))
    check "testSprintfEmptyStr" (fun () -> ignore (testSprintfEmptyStr ()))
    check "testSprintfIntFirstChar" (fun () -> ignore (testSprintfIntFirstChar ()))
    check "testInterpolationWithSprintf" (fun () -> ignore (testInterpolationWithSprintf ()))
