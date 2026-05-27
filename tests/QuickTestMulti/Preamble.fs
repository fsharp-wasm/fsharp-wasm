
/// Shared preamble functions and types for all QuickTest domain modules
module QuickTestWasmGc.Preamble

// Fable.Core stubs (Import attribute, nativeOnly) are in fable-library-wasmgc/Interop.fs.
// No NuGet reference needed — we define what we use ourselves.
open Fable.Core

// ── External Wasm FFI — declared here, implemented in test-runner.mjs ───────
// This is how you call Rust/WASM/JS functions from F# compiled to WasmGC.
// The [<Import>] attribute declares a Wasm import: (moduleName, funcName).
// nativeOnly means "this body is never executed — the Wasm runtime provides it."
[<Import("wasmAdd", "testEnv")>]
let externWasmAdd (a: int) (b: int) : int = nativeOnly

[<Import("wasmMul", "testEnv")>]
let externWasmMul (a: int) (b: int) : int = nativeOnly

/// Simple addition
let add (a: int) (b: int) : int = a + b

/// Subtract
let sub (a: int) (b: int) : int = a - b

/// Multiply
let mul (a: int) (b: int) : int = a * b

/// Recursive fibonacci
let rec fib (n: int) : int =
    if n <= 1 then n
    else fib (n - 1) + fib (n - 2)

/// Recursive factorial
let rec fact (n: int) : int =
    if n <= 1 then 1
    else n * fact (n - 1)

/// Clamp a value to [lo, hi]
let clamp (lo: int) (hi: int) (v: int) : int =
    if v < lo then lo
    elif v > hi then hi
    else v

/// Absolute value
let myAbs (n: int) : int =
    if n < 0 then -n else n

/// Integer square root (Newton's method)
let isqrt (n: int) : int =
    if n < 0 then 0
    elif n = 0 then 0
    else
        let mutable x = n
        let mutable y = (x + 1) / 2
        while y < x do
            x <- y
            y <- (y + n / y) / 2
        x

// ─── Phase 3: Records ─────────────────────────────────────────────

/// 2D point record
type Point = { X: float; Y: float }

/// Euclidean distance from origin
let distanceFromOrigin (p: Point) : float =
    let x2 = p.X * p.X
    let y2 = p.Y * p.Y
    // Newton's integer sqrt won't work on float — use the Pythagorean triple 3,4,5
    x2 + y2   // return x²+y² so the test can verify without sqrt

/// Create a point and read its fields
let pointSum (x: float) (y: float) : float =
    let p = { X = x; Y = y }
    p.X + p.Y

/// Mutable counter record
type Counter = { mutable Count: int }

/// Increment a counter 3 times and return the value
let runCounter () : int =
    let c = { Count = 0 }
    c.Count <- c.Count + 1
    c.Count <- c.Count + 1
    c.Count <- c.Count + 1
    c.Count

/// Nested record access
type Rect = { TopLeft: Point; BottomRight: Point }

let rectWidth (r: Rect) : float =
    r.BottomRight.X - r.TopLeft.X

/// JS-callable wrappers for record-arg functions
let testDistanceFromOrigin (x: float) (y: float) : float =
    distanceFromOrigin { X = x; Y = y }

let testRectWidth (x1: float) (y1: float) (x2: float) (y2: float) : float =
    rectWidth { TopLeft = { X = x1; Y = y1 }; BottomRight = { X = x2; Y = y2 } }

// ─── Phase 4: Discriminated Unions ───────────────────────────────

// Enum-like DU (no fields) — stored as plain i32 tag
type Direction = North | South | East | West

let directionToInt (d: Direction) : int =
    match d with
    | North -> 0
    | South -> 1
    | East -> 2
    | West -> 3

let intToDirection (n: int) : Direction =
    match n with
    | 0 -> North
    | 1 -> South
    | 2 -> East
    | _ -> West

// Data-carrying DU
type Shape =
    | Circle of float
    | Square of float
    | Rectangle of float * float

/// Area: Circle → r², Square → s², Rectangle → w*h
let shapeArea (s: Shape) : float =
    match s with
    | Circle r -> r * r
    | Square s -> s * s
    | Rectangle(w, h) -> w * h

/// Perimeter: Circle → 4r, Square → 4s, Rectangle → 2w+2h
let shapePerimeter (s: Shape) : float =
    match s with
    | Circle r -> 4.0 * r
    | Square s -> 4.0 * s
    | Rectangle(w, h) -> 2.0 * w + 2.0 * h

// ─── Phase 5 (partial): Tuples ───────────────────────────────────

/// Swap the two elements of an int pair
let swapPair (a: int) (b: int) : int * int = (b, a)

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

let optionOrDefault (opt: int option) (def: int) : int =
    match opt with
    | Some v -> v
    | None -> def

let optionDouble (opt: int option) : int =
    match opt with
    | Some v -> v * 2
    | None -> -1

let optionIsSome (opt: int option) : bool =
    match opt with
    | Some _ -> true
    | None -> false

let optionIsNone (opt: int option) : bool =
    match opt with
    | Some _ -> false
    | None -> true

let optionNested (v: int) : int =
    let outer = Some(Some v)
    match outer with
    | Some inner ->
        match inner with
        | Some x -> x
        | None -> -2
    | None -> -1

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

let applyFn (f: int -> int) (x: int) : int = f x

let doubleVal (x: int) : int = x * 2

let testHOFSimple (x: int) : int = applyFn doubleVal x

let makeAdder (n: int) : (int -> int) = fun x -> x + n

let testCapture (n: int) (x: int) : int = (makeAdder n) x

let applyTwice (f: int -> int) (x: int) : int = f (f x)

let testApplyTwice (x: int) : int = applyTwice doubleVal x

let makeMultiplier (n: int) : (int -> int) = fun x -> x * n

let testLetCapture (n: int) (x: int) : int =
    let mult = makeMultiplier n
    mult x

// ─── Phase 6: Strings ─────────────────────────────────────────────

let testStringLen () : int = "hello".Length
let testEmptyStringLen () : int = "".Length
let testStringChar () : int = int "ABC".[1]
let testStringFirstChar () : int = int "xyz".[0]
let testStringLen2 () : int = "fable wasm".Length
let testStringConcatLen () : int = ("foo" + "bar").Length
let testStringConcatChar () : int = int ("foo" + "bar").[3]
let testStringEqTrue () : int = if "hello" = "hello" then 1 else 0
let testStringEqFalse () : int = if "hello" = "world" then 1 else 0
let testStringNeq () : int = if "abc" <> "xyz" then 1 else 0
let testStringConcatVars () : int =
    let a = "hello"
    let b = " world"
    (a + b).Length

// ─── Option combinators ───────────────────────────────────────────

let testOptionMap () : int =
    let x = Some 5
    let y = Option.map (fun v -> v * 3) x
    Option.defaultValue 0 y

let testOptionBind () : int =
    let x = Some 4
    let y = Option.bind (fun v -> if v > 0 then Some(v * 2) else None) x
    Option.defaultValue -1 y

// ─── Recursive discriminated union (Tree) ──────────────────────────────────

type Tree = Leaf | Node of Tree * Tree * int

let rec treeSum (t: Tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, r, v) -> v + treeSum l + treeSum r

// ─── Map/Set comparator ───────────────────────────────────────────────────────

/// Standard int comparator used by all MapModule/SetModule tests.
let intCmp (a: int) (b: int) : int = if a < b then -1 elif a > b then 1 else 0

// ─── Math helpers ─────────────────────────────────────────────────────────────

let fibonacci = fib

let roundTo6 (x: float) : int =
    int (System.Math.Round(x * 1000000.0))

// ─── Interface types ──────────────────────────────────────────────────────────

type IGreeter =
    abstract Greet: unit -> int

type EnglishGreeter = { Word: string }
    with
        interface IGreeter with
            member this.Greet() = this.Word.Length

type SpanishGreeter = { Palabra: string }
    with
        interface IGreeter with
            member this.Greet() = this.Palabra.Length

// ─── Exception types ──────────────────────────────────────────────────────────

exception MyTypedException of Value: int
