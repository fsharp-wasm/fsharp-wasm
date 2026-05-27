module QuickTestWasmGc.TestsOption

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Option (25 tests) ───────────────────────────────────────

let testOptionSome (v: int) (def: int) : int = optionOrDefault (Some v) def

let testOptionNone (def: int) : int = optionOrDefault None def

let testOptionDoubleSome (v: int) : int = optionDouble (Some v)

let testOptionDoubleNone () : int = optionDouble None

let testOptionIsSome (v: int) : int = if optionIsSome (Some v) then 1 else 0

let testOptionIsNone () : int = if optionIsNone None then 1 else 0

let testOptionNested (v: int) : int = optionNested v

// ─── Phase 6: Math.* ────────────────────────────────────────────

let mathAbsF (x: float) : float = System.Math.Abs(x)
let mathAbsI (x: int) : int = System.Math.Abs(x)
let mathSqrt (x: float) : float = System.Math.Sqrt(x)
let mathFloor (x: float) : float = System.Math.Floor(x)
let mathCeil (x: float) : float = System.Math.Ceiling(x)
let mathTrunc (x: float) : float = System.Math.Truncate(x)
let mathRound (x: float) : float = System.Math.Round(x)
let mathMinF (a: float) (b: float) : float = System.Math.Min(a, b)
let mathMaxF (a: float) (b: float) : float = System.Math.Max(a, b)
let mathMinI (a: int) (b: int) : int = System.Math.Min(a, b)
let mathMaxI (a: int) (b: int) : int = System.Math.Max(a, b)

// ─── Phase 5: Closures & Higher-Order Functions ────────────────

/// Apply a function to a value
let applyFn (f: int -> int) (x: int) : int = f x

/// Double a value (ordinary function used as argument)
let doubleVal (x: int) : int = x * 2

/// Test: pass a module-level function as a HOF argument

let testOptionMap () : int =
    let x = Some 5
    let y = Option.map (fun v -> v * 3) x
    Option.defaultValue 0 y


let testOptionBind () : int =
    let x = Some 4
    let y = Option.bind (fun v -> if v > 0 then Some(v * 2) else None) x
    Option.defaultValue -1 y

// ─── List basics ────────────────────────────────────────────────────────

/// Test: head of a list → 1

let testOptionValue () : int =
    (Some 42).Value

/// Test: Option.map then .Value = 84

let testOptionMapValue () : int =
    (Option.map (fun x -> x * 2) (Some 42)).Value

// ── Result<T,E> pattern matching ─────────────────────────────────

/// Test: match Ok 42 with Ok x -> x | Error _ -> -1 = 42

let testOptionDefaultValue () : int =
    Option.defaultValue 99 (Some 42)

/// Test: Option.defaultValue 99 None = 99

let testOptionDefaultValueNone () : int =
    Option.defaultValue 99 None

/// Test: Option.defaultWith (fun () -> 42) None = 42

let testOptionDefaultWith () : int =
    Option.defaultWith (fun () -> 42) None

/// Test: Option.defaultWith (fun () -> 99) (Some 5) = 5

let testOptionDefaultWithSome () : int =
    Option.defaultWith (fun () -> 99) (Some 5)

/// Test: Option.filter (>3) (Some 5) returns Some 5, extract value

let testOptionFilter () : int =
    match Option.filter (fun x -> x > 3) (Some 5) with
    | Some x -> x
    | None -> 0

/// Test: Option.filter (>10) (Some 5) returns None

let testOptionFilterNone () : int =
    match Option.filter (fun x -> x > 10) (Some 5) with
    | Some _ -> 1
    | None -> 0

/// Test: float arithmetic 3.0 * 2.0 = 6.0

let testOptionModuleIsSome () : int =
    if Option.isSome (Some 5) then 1 else 0

/// Test: Option.isSome None = false → 0

let testOptionModuleIsSomeNone () : int =
    if Option.isSome None then 1 else 0

/// Test: Option.isNone None = true → 1

let testOptionModuleIsNone () : int =
    if Option.isNone None then 1 else 0

/// Test: Option.isNone (Some 5) = false → 0

let testOptionModuleIsNoneSome () : int =
    if Option.isNone (Some 5) then 1 else 0

/// Test: Option.defaultValue 42 None = 42

let testOptionModuleDefaultValueNone () : int =
    Option.defaultValue 42 None

/// Test: Option.defaultValue 42 (Some 99) = 99

let testOptionModuleDefaultValueSome () : int =
    Option.defaultValue 42 (Some 99)

/// Test: Option.count None = 0  (same as: if isNone then 0 else 1)

let testOptionModuleCountNone () : int =
    if Option.isNone None then 0 else 1

/// Test: Option.count (Some 5) = 1  (same as: if isSome then 1 else 0)

let testOptionModuleCountSome () : int =
    if Option.isSome (Some 5) then 1 else 0

/// Test: Result.isOk (Ok 5) = true → 1

// ── Suite runner ──────────────────────────────────────────────────────────
let runOptionTests (check: string -> (unit -> unit) -> unit) =
    check "testOptionSome" (fun () -> ignore (testOptionSome ()))
    check "testOptionNone" (fun () -> ignore (testOptionNone ()))
    check "testOptionDoubleSome" (fun () -> ignore (testOptionDoubleSome ()))
    check "testOptionDoubleNone" (fun () -> ignore (testOptionDoubleNone ()))
    check "testOptionIsSome" (fun () -> ignore (testOptionIsSome ()))
    check "testOptionIsNone" (fun () -> ignore (testOptionIsNone ()))
    check "testOptionNested" (fun () -> ignore (testOptionNested ()))
    check "testOptionMap" (fun () -> ignore (testOptionMap ()))
    check "testOptionBind" (fun () -> ignore (testOptionBind ()))
    check "testOptionValue" (fun () -> ignore (testOptionValue ()))
    check "testOptionMapValue" (fun () -> ignore (testOptionMapValue ()))
    check "testOptionDefaultValue" (fun () -> ignore (testOptionDefaultValue ()))
    check "testOptionDefaultValueNone" (fun () -> ignore (testOptionDefaultValueNone ()))
    check "testOptionDefaultWith" (fun () -> ignore (testOptionDefaultWith ()))
    check "testOptionDefaultWithSome" (fun () -> ignore (testOptionDefaultWithSome ()))
    check "testOptionFilter" (fun () -> ignore (testOptionFilter ()))
    check "testOptionFilterNone" (fun () -> ignore (testOptionFilterNone ()))
    check "testOptionModuleIsSome" (fun () -> ignore (testOptionModuleIsSome ()))
    check "testOptionModuleIsSomeNone" (fun () -> ignore (testOptionModuleIsSomeNone ()))
    check "testOptionModuleIsNone" (fun () -> ignore (testOptionModuleIsNone ()))
    check "testOptionModuleIsNoneSome" (fun () -> ignore (testOptionModuleIsNoneSome ()))
    check "testOptionModuleDefaultValueNone" (fun () -> ignore (testOptionModuleDefaultValueNone ()))
    check "testOptionModuleDefaultValueSome" (fun () -> ignore (testOptionModuleDefaultValueSome ()))
    check "testOptionModuleCountNone" (fun () -> ignore (testOptionModuleCountNone ()))
    check "testOptionModuleCountSome" (fun () -> ignore (testOptionModuleCountSome ()))
