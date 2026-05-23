module QuickTestWasmGc.TestsExceptions

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── Exceptions (14 tests) ───────────────────────────────────────

let testTryCatchBasic () : int =
    try
        failwith "boom"
        0
    with _ -> 42  // 42

/// try/with — normal path (no exception)

let testTryCatchNoThrow () : int =
    try
        10 + 20
    with _ -> 0  // 30

/// Nested try/with — inner handler catches

let testTryCatchNested () : int =
    try
        try
            failwith "inner"
            0
        with _ -> 100
    with _ -> 200  // 100 (inner handler catches)

/// try/with — exception in computation, handler returns fallback

let testTryCatchFallback () : int =
    let result =
        try
            let x = 10
            failwith "error"
            x + 5
        with _ -> 99
    result  // 99

// ── Phase 2: Map extended operations ─────────────────────────────

/// Map.isEmpty — check count of empty map

let testExnNestedFailwith () : int =
    let boom () = failwith "nested boom"
    try
        boom ()
        0
    with _ -> 77  // 77

/// try/with returning unit (side-effect only)

let testExnUnit () : int =
    let mutable x = 0
    try
        x <- 10
        failwith "err"
    with _ ->
        x <- x + 5
    x  // 15

/// exception does not throw — normal path

let testExnNormalPath () : int =
    try
        let a = 10
        let b = 20
        a + b
    with _ -> 0  // 30

/// nested try/with — inner catches

let testExnNestedInnerCatch () : int =
    try
        let r =
            try
                failwith "inner"
                0
            with _ -> 42
        r + 1
    with _ -> 0  // 43

/// nested try/with — inner rethrows to outer

let testExnNestedRethrow () : int =
    try
        try
            failwith "pass-through"
            0
        with _ ->
            failwith "outer-boom"
            0
    with _ -> 99  // 99

// ── Sprint 25b: Capturing closures in HOF contexts ───────────────

/// List.map with a capturing closure (offset captured from outer scope)

let testExnCarrierBasic () : int =
    try
        raise (MyTypedException 99)
        0
    with _ -> 42  // 42 — handler reached

/// Exception carrier: the catch variable is the actual thrown struct (anyref carrier).
/// Access its field via TypeTest + cast to confirm payload round-trip.

let testExnTypedPayload () : int =
    try
        raise (MyTypedException 77)
        0
    with
    | :? MyTypedException as e -> e.Value  // 77 — payload extracted from carrier
    | _ -> 0

/// TypeTest discriminates: :? MyTypedException vs. a different exception.

let testExnTypeTestDiscriminate () : int =
    let mutable result = 0
    try
        failwith "generic error"  // throws a different exception type
        result <- 1
    with
    | :? MyTypedException -> result <- 20  // should NOT match
    | _ -> result <- 99  // should match
    result  // 99

/// TypeTest succeeds when matching the thrown type precisely.

let testExnTypeTestMatch () : int =
    try
        raise (MyTypedException 55)
        0
    with
    | :? MyTypedException -> 1  // should match → 1
    | _ -> 0

/// Exception with non-trivial value: carrier stores and retrieves int payload.

let testExnCarrierInt () : int =
    let mutable acc = 0
    for i in 1 .. 5 do
        try
            if i % 2 = 0 then raise (MyTypedException (i * 10))
        with
        | :? MyTypedException as e -> acc <- acc + e.Value
        | _ -> ()
    acc  // 20 + 40 = 60



// ── Suite runner ──────────────────────────────────────────────────────────
let runExceptionsTests (check: string -> (unit -> unit) -> unit) =
    check "testTryCatchBasic" testTryCatchBasic
    check "testTryCatchNoThrow" testTryCatchNoThrow
    check "testTryCatchNested" testTryCatchNested
    check "testTryCatchFallback" testTryCatchFallback
    check "testExnNestedFailwith" testExnNestedFailwith
    check "testExnUnit" testExnUnit
    check "testExnNormalPath" testExnNormalPath
    check "testExnNestedInnerCatch" testExnNestedInnerCatch
    check "testExnNestedRethrow" testExnNestedRethrow
    check "testExnCarrierBasic" testExnCarrierBasic
    check "testExnTypedPayload" testExnTypedPayload
    check "testExnTypeTestDiscriminate" testExnTypeTestDiscriminate
    check "testExnTypeTestMatch" testExnTypeTestMatch
    check "testExnCarrierInt" testExnCarrierInt
