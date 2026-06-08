/// Exceptions domain
module QuickTestWasmGc.TestsExceptions

open QuickTestWasmGc.Preamble
open Fable.Core

// ─── Exception type ────────────────────────────────────────────

exception MyTypedException of Value: int

// ─── Basic exception tests ─────────────────────────────────────

let testExnNestedFailwith () : int =
    try
        try
            failwith "level 1"
        with _ ->
            failwith "level 2"
    with _ -> 42

let testExnUnit () : int =
    try
        let f () = failwith "in f"
        f ()
        0
    with _ -> 7

let testExnNormalPath () : int =
    try
        1 + 1
    with _ -> 0

let testExnNestedInnerCatch () : int =
    try
        try
            failwith "inner"
        with _ -> 55
    with _ -> 0

let testExnNestedRethrow () : int =
    let mutable caught = 0
    try
        try
            failwith "test"
        with _ ->
            caught <- 1
            failwith "rethrow"
    with _ -> caught + 10

let testExnPairsCatchOrder () : int =
    try
        failwith "msg"
    with _ -> 1

let testExnIntCatch () : int =
    try
        failwith "msg"
    with _ -> 2

let testExnStringCatch () : int =
    try
        failwith "msg"
    with _ -> 3

let testExnTryFinally () : int =
    let mutable x = 0
    try
        x <- 1
        failwith "boom"
    finally
        x <- x + 1
    x

let testExnTryFinallyWithCatch () : int =
    let mutable x = 0
    try
        try
            x <- 1
            failwith "boom"
        finally
            x <- x + 1
    with _ -> x

let testExnCarrierBasic () : int =
    try
        raise (MyTypedException 99)
        0
    with _ -> 42

let testExnTypedPayload () : int =
    try
        raise (MyTypedException 77)
        0
    with
    | :? MyTypedException as e -> e.Value
    | _ -> 0

let testExnTypeTestDiscriminate () : int =
    let mutable result = 0
    try
        failwith "generic error"
        result <- 1
    with
    | :? MyTypedException -> result <- 20
    | _ -> result <- 99
    result

let testExnTypeTestMatch () : int =
    try
        raise (MyTypedException 55)
        0
    with
    | :? MyTypedException -> 1
    | _ -> 0

let testExnCarrierInt () : int =
    let mutable acc = 0
    for i in 1 .. 5 do
        try
            if i % 2 = 0 then raise (MyTypedException (i * 10))
        with
        | :? MyTypedException as e -> acc <- acc + e.Value
        | _ -> ()
    acc  // 20 + 40 = 60

// ─── Suite runner ──────────────────────────────────────────────

let runExceptionsTests (check: string -> (unit -> unit) -> unit) : unit =
    check "testExnNestedFailwith" (fun () -> ignore (testExnNestedFailwith ()))
    check "testExnUnit" (fun () -> ignore (testExnUnit ()))
    check "testExnNormalPath" (fun () -> ignore (testExnNormalPath ()))
    check "testExnNestedInnerCatch" (fun () -> ignore (testExnNestedInnerCatch ()))
    check "testExnNestedRethrow" (fun () -> ignore (testExnNestedRethrow ()))
    check "testExnPairsCatchOrder" (fun () -> ignore (testExnPairsCatchOrder ()))
    check "testExnIntCatch" (fun () -> ignore (testExnIntCatch ()))
    check "testExnStringCatch" (fun () -> ignore (testExnStringCatch ()))
    check "testExnTryFinally" (fun () -> ignore (testExnTryFinally ()))
    check "testExnTryFinallyWithCatch" (fun () -> ignore (testExnTryFinallyWithCatch ()))
    check "testExnCarrierBasic" (fun () -> ignore (testExnCarrierBasic ()))
    check "testExnTypedPayload" (fun () -> ignore (testExnTypedPayload ()))
    check "testExnTypeTestDiscriminate" (fun () -> ignore (testExnTypeTestDiscriminate ()))
    check "testExnTypeTestMatch" (fun () -> ignore (testExnTypeTestMatch ()))
    check "testExnCarrierInt" (fun () -> ignore (testExnCarrierInt ()))
