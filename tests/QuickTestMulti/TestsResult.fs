module QuickTestWasmGc.TestsResult

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── Result (15 tests) ───────────────────────────────────────

let testResultMatchOk () : int =
    match Ok 42 with
    | Ok x -> x
    | Error _ -> -1

/// Test: match Error 7 with Ok _ -> -1 | Error e -> e = 7

let testResultMatchError () : int =
    match Error 7 with
    | Ok _ -> -1
    | Error e -> e

/// Test: Result.isOk (Ok 1) = 1

let testResultIsOk () : int =
    if Result.isOk (Ok 1) then 1 else 0

/// Test: Result.isError (Error "x") = 1

let testResultIsError () : int =
    if Result.isError (Error "x") then 1 else 0

/// Test: Result.map (*2) (Ok 21) |> match Ok x -> x | _ -> -1 = 42

let testResultMap () : int =
    match Result.map (fun x -> x * 2) (Ok 21) with
    | Ok x -> x
    | Error _ -> -1

/// Test: Result.bind (fun x -> Ok (x+1)) (Ok 5) = 6

let testResultBind () : int =
    match Result.bind (fun x -> Ok (x + 1)) (Ok 5) with
    | Ok x -> x
    | Error _ -> -1

/// Test: Result.bind on Error passes through = -99

let testResultBindError () : int =
    match Result.bind (fun x -> Ok (x + 1)) (Error -99) with
    | Ok x -> x
    | Error e -> e

// ─── String Case + Trim Tests ────────────────────────────────────

/// Test: "Hello".ToLower() = "hello" → length 5

let testResultModuleIsOk () : int =
    if Result.isOk (Ok 5) then 1 else 0

/// Test: Result.isOk (Error 0) = false → 0

let testResultModuleIsOkFalse () : int =
    if Result.isOk (Error 0) then 1 else 0

/// Test: Result.isError (Error 0) = true → 1

let testResultModuleIsError () : int =
    if Result.isError (Error 0) then 1 else 0

/// Test: Result.isError (Ok 5) = false → 0

let testResultModuleIsErrorFalse () : int =
    if Result.isError (Ok 5) then 1 else 0

/// Test: default 42 when Error → match gives 42

let testResultModuleDefaultValueError () : int =
    match (Error 0 : Result<int,int>) with Ok x -> x | Error _ -> 42

/// Test: default 42 when Ok 99 → match gives 99

let testResultModuleDefaultValueOk () : int =
    match (Ok 99 : Result<int,int>) with Ok x -> x | Error _ -> 42

/// Test: defaultError 42 when Ok → 42

let testResultModuleDefaultErrorOk () : int =
    match (Ok 0 : Result<int,int>) with Ok _ -> 42 | Error e -> e

/// Test: defaultError 42 when Error 7 → 7

let testResultModuleDefaultErrorError () : int =
    match (Error 7 : Result<int,int>) with Ok _ -> 42 | Error e -> e

// ─── Sprint 10e: printf / sprintf format strings ───────────────────────────

/// Test: sprintf "%d" 42 → "42", length = 2

// ── Suite runner ──────────────────────────────────────────────────────────
let runResultTests (check: string -> (unit -> unit) -> unit) =
    check "testResultMatchOk" testResultMatchOk
    check "testResultMatchError" testResultMatchError
    check "testResultIsOk" testResultIsOk
    check "testResultIsError" testResultIsError
    check "testResultMap" testResultMap
    check "testResultBind" testResultBind
    check "testResultBindError" testResultBindError
    check "testResultModuleIsOk" testResultModuleIsOk
    check "testResultModuleIsOkFalse" testResultModuleIsOkFalse
    check "testResultModuleIsError" testResultModuleIsError
    check "testResultModuleIsErrorFalse" testResultModuleIsErrorFalse
    check "testResultModuleDefaultValueError" testResultModuleDefaultValueError
    check "testResultModuleDefaultValueOk" testResultModuleDefaultValueOk
    check "testResultModuleDefaultErrorOk" testResultModuleDefaultErrorOk
    check "testResultModuleDefaultErrorError" testResultModuleDefaultErrorError
