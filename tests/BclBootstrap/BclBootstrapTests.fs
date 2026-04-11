module BclBootstrap

open System

// ── Sprint 31: fsharp-wasm-core bootstrap ─────────────────────────────────
// All functions are exported automatically (plain module-level exports).

// ── Math.fs tests ──────────────────────────────────────────────────────────

let testMathAbsInt () : int =
    Math.Abs(-42)  // → 42

let testMathAbsFloat () : int =
    let r = Math.Abs(-3.14)
    if r > 3.13 && r < 3.15 then 1 else 0

let testMathSignNeg () : int =
    Math.Sign(-7)   // → -1

let testMathSignPos () : int =
    Math.Sign(99)   // → 1

let testMathMinInt () : int =
    Math.Min(3, 7)  // → 3

let testMathMaxInt () : int =
    Math.Max(3, 7)  // → 7

let testMathConstPI () : int =
    if Math.PI > 3.14 && Math.PI < 3.15 then 1 else 0

// ── Exception.fs tests ─────────────────────────────────────────────────────

let testExceptionBasic () : int =
    let e = Exception("hello")
    if e.Message = "hello" then 1 else 0

let testArgumentExceptionParam () : int =
    let e = ArgumentException("bad", "myParam")
    if e.ParamName = "myParam" then 1 else 0

let testThrowCatchArgumentException () : int =
    try
        raise (ArgumentException("oops", "p"))
        0
    with
    | :? ArgumentException -> 42
    | _ -> -1

let testDiscriminateExcType () : int =
    try
        raise (ArgumentNullException("p"))
        0
    with
    | :? ArgumentNullException -> 1
    | :? ArgumentException     -> 2
    | :? Exception             -> 3
    | _                        -> -1
