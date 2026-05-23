module QuickTestWasmGc.TestsInterop

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── Interop (6 tests) ───────────────────────────────────────

let testExternAdd () : int =
    externWasmAdd 10 32

/// Test: externWasmAdd with negative numbers — -5 + 5 = 0

let testExternAddNeg () : int =
    externWasmAdd -5 5

/// Test: externWasmMul — 6 × 7 = 42

let testExternMul () : int =
    externWasmMul 6 7

/// Test: chaining two extern calls — (2 + 3) * 4 = 20

let testExternChain () : int =
    externWasmMul (externWasmAdd 2 3) 4

// ── String.Split tests ─────────────────────────────────────────────────────

/// Test: "a,b,c".Split([|","|]) → 3 parts

let testLetMutable () : int =
    let mutable x = 10
    x <- x + 5
    x <- x * 2
    x  // 30


let testLetMutableLoop () : int =
    let mutable sum = 0
    for i in 1..10 do
        sum <- sum + i
    sum  // 55


// ── Suite runner ──────────────────────────────────────────────────────────
let runInteropTests (check: string -> (unit -> unit) -> unit) =
    check "testExternAdd" testExternAdd
    check "testExternAddNeg" testExternAddNeg
    check "testExternMul" testExternMul
    check "testExternChain" testExternChain
    check "testLetMutable" testLetMutable
    check "testLetMutableLoop" testLetMutableLoop
