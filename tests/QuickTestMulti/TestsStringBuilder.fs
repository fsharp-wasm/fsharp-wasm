module QuickTestWasmGc.TestsStringBuilder

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── StringBuilder (4 tests) ───────────────────────────────────────

let testSbLength () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("hello") |> ignore
    sb.Length  // 5


let testSbAppendTwo () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("foo") |> ignore
    sb.Append("bar") |> ignore
    sb.Length  // 6


let testSbGrow () : int =
    // Force a buffer grow: initial capacity 16, write 20 chars
    let sb = System.Text.StringBuilder()
    for _ in 1 .. 20 do
        sb.Append("x") |> ignore
    sb.Length  // 20


let testSbChained () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("a") |> ignore
    sb.Append("b") |> ignore
    sb.Append("c") |> ignore
    sb.Append("d") |> ignore
    sb.Append("e") |> ignore
    sb.Length  // 5

// ─── Math.Atan2 ───────────────────────────────────────────────────────────────
// We compare floats rounded to 6 decimal places to avoid fp noise.
let private roundTo6 (x: float) : int =
    int (System.Math.Round(x * 1_000_000.0))


// ── Suite runner ──────────────────────────────────────────────────────────
let runStringBuilderTests (check: string -> (unit -> unit) -> unit) =
    check "testSbLength" testSbLength
    check "testSbAppendTwo" testSbAppendTwo
    check "testSbGrow" testSbGrow
    check "testSbChained" testSbChained
