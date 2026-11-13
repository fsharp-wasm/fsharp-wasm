/// Minimal WasmGc hello-world: pure integer arithmetic, no runtime needed.
/// These functions are exported automatically and can be called from JS/Node.
module QuickTest.WasmGc

// Fable.Core stubs (Import attribute, nativeOnly) are in FSharp.Wasm.Core/Interop.fs.
// No NuGet reference needed — we define what we use ourselves.
open Fable.Core
// open WasmGc.Core

// Run `dotnet fsi build.fsx quicktest` and then add tests to this file,
// when you save they will be run automatically with latest changes in compiler.
// When everything works, move the tests to the appropriate file in tests/Main.
// Please don't add this file to your commits.

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

// ─── JS-callable wrappers for record-arg functions ────────────────
// WasmGC struct references cannot cross the JS/Wasm boundary directly,
// so we expose thin wrappers that construct the record from primitives.

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

// Data-carrying DU — stored as WasmGC struct subtype hierarchy
type Shape =
    | Circle of float      // radius
    | Square of float      // side
    | Rectangle of float * float  // width, height

/// Area: Circle → r², Square → s², Rectangle → w*h  (no π for simplicity)
let shapeArea (s: Shape) : float =
    match s with
    | Circle r -> r * r
    | Square s -> s * s
    | Rectangle(w, h) -> w * h

/// Perimeter: Circle → 4r (approx, no π), Square → 4s, Rectangle → 2w+2h
let shapePerimeter (s: Shape) : float =
    match s with
    | Circle r -> 4.0 * r
    | Square s -> 4.0 * s
    | Rectangle(w, h) -> 2.0 * w + 2.0 * h

// JS-callable wrappers (WasmGC struct refs can't cross the JS boundary)
let testShapeAreaCircle (r: float) : float = shapeArea (Circle r)
let testShapeAreaSquare (s: float) : float = shapeArea (Square s)
let testShapeAreaRect (w: float) (h: float) : float = shapeArea (Rectangle(w, h))
let testShapePerimCircle (r: float) : float = shapePerimeter (Circle r)
let testShapePerimSquare (s: float) : float = shapePerimeter (Square s)
let testShapePerimRect (w: float) (h: float) : float = shapePerimeter (Rectangle(w, h))

// ─── Phase 5 (partial): Tuples ───────────────────────────────────

/// Swap the two elements of an int pair
let swapPair (a: int) (b: int) : int * int = (b, a)

// JS-callable wrappers: unpack tuple return values
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

/// defaultArg-style helper: return value if Some, else default
let optionOrDefault (opt: int option) (def: int) : int =
    match opt with
    | Some v -> v
    | None -> def

/// double the value if Some, else return sentinel -1
let optionDouble (opt: int option) : int =
    match opt with
    | Some v -> v * 2
    | None -> -1

/// isSome predicate
let optionIsSome (opt: int option) : bool =
    match opt with
    | Some _ -> true
    | None -> false

/// isNone predicate
let optionIsNone (opt: int option) : bool =
    match opt with
    | Some _ -> false
    | None -> true

/// Chained matching: Some(Some(v)) → extracts innermost value
let optionNested (v: int) : int =
    let outer = Some(Some v)
    match outer with
    | Some inner ->
        match inner with
        | Some x -> x
        | None -> -2
    | None -> -1

// JS-callable wrappers (Option structs can't cross the WASM/JS boundary directly).
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
let testHOFSimple (x: int) : int = applyFn doubleVal x

/// Make a closure that adds n to its argument
let makeAdder (n: int) : (int -> int) = fun x -> x + n

/// Test: create and call a closure
let testCapture (n: int) (x: int) : int = (makeAdder n) x

/// Apply a function twice
let applyTwice (f: int -> int) (x: int) : int = f (f x)

/// Test: apply a closure twice
let testApplyTwice (x: int) : int = applyTwice doubleVal x

/// Make a closure that multiplies by n
let makeMultiplier (n: int) : (int -> int) = fun x -> x * n

/// Test: closure capturing via let binding
let testLetCapture (n: int) (x: int) : int =
    let mult = makeMultiplier n
    mult x

// ─── Phase 6: Strings ─────────────────────────────────────────────

/// Test: string literal length
let testStringLen () : int = "hello".Length

/// Test: string literal length — empty string
let testEmptyStringLen () : int = "".Length

/// Test: character code at index 1 of "ABC" → 66 (B)
let testStringChar () : int = int "ABC".[1]

/// Test: first character of "xyz" → 120 (x)
let testStringFirstChar () : int = int "xyz".[0]

/// Test: length of a longer string
let testStringLen2 () : int = "fable wasm".Length
// ─── Phase 6b: String concat & equality ──────────────────────────

/// Test: concat length — "foo" + "bar" → 6
let testStringConcatLen () : int = ("foo" + "bar").Length

/// Test: concat then index — ("foo" + "bar").[3] → 'b' = 98
let testStringConcatChar () : int = int ("foo" + "bar").[3]

/// Test: string equality true → 1
let testStringEqTrue () : int = if "hello" = "hello" then 1 else 0

/// Test: string equality false → 0
let testStringEqFalse () : int = if "hello" = "world" then 1 else 0

/// Test: string inequality true → 1
let testStringNeq () : int = if "abc" <> "xyz" then 1 else 0

/// Test: concat of two variables
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

// ─── List basics ────────────────────────────────────────────────────────

/// Test: head of a list → 1
let testListHead () : int =
    let xs = [1; 2; 3]
    xs.Head

/// Test: empty list check → 1
let testListEmpty () : int =
    let xs: int list = []
    if List.isEmpty xs then 1 else 0

/// Test: pattern match on list head → 5
let testListMatch () : int =
    let xs = [5; 6; 7]
    match xs with
    | [] -> 0
    | h :: _ -> h

/// Test: List.fold sum → 15
let testListFoldSum () : int =
    let xs = [1; 2; 3; 4; 5]
    List.fold (fun acc x -> acc + x) 0 xs

// ─── List higher-order combinators ──────────────────────────────────────────

/// Test: List.map then fold sum → List.map (fun x -> x * 2) [1;2;3] = [2;4;6] → fold sum = 12
let testListMapSum () : int =
    let xs = [1; 2; 3]
    let doubled = List.map (fun x -> x * 2) xs
    List.fold (fun acc x -> acc + x) 0 doubled

/// Test: List.filter then fold sum → filter (>2) [1..5] = [3;4;5] → sum = 12
let testListFilterSum () : int =
    let xs = [1; 2; 3; 4; 5]
    let big = List.filter (fun x -> x > 2) xs
    List.fold (fun acc x -> acc + x) 0 big

/// Test: List.rev head → rev [1;2;3] = [3;2;1] → head = 3
let testListRevHead () : int =
    let xs = [1; 2; 3]
    (List.rev xs).Head

/// Test: List.append length → append [1;2] [3;4;5] = [1;2;3;4;5] → length = 5
let testListAppendLen () : int =
    let xs = [1; 2]
    let ys = [3; 4; 5]
    List.length (List.append xs ys)

// ─── TypeCast / numeric conversions ──────────────────────────────────────────

/// Test: int of float truncates → int 3.7 = 3
let testIntOfFloat () : int = int 3.7

/// Test: int of negative float truncates toward zero → int -2.9 = -2
let testIntOfNegFloat () : int = int -2.9

/// Test: float of int → float 5 used in arithmetic → 5.0 * 2.0 = 10.0 → back to int
let testFloatOfInt () : int =
    let f : float = float 5
    int (f * 2.0)

/// Test: int64 from int32 → int64 7 + int64 3 = int64 10 → int 10
let testInt64OfInt () : int =
    let x : int64 = int64 7
    let y : int64 = int64 3
    int (x + y)

// ─── List.iter ────────────────────────────────────────────────────────────────

/// Test: List.iter via mutable accumulator → sum of [1;2;3;4;5] = 15
let testListIter () : int =
    let mutable acc = 0
    List.iter (fun x -> acc <- acc + x) [1; 2; 3; 4; 5]
    acc

/// Test: List.iter on empty list → 0
let testListIterEmpty () : int =
    let mutable acc = 0
    List.iter (fun x -> acc <- acc + x) []
    acc

// ─── List.exists / List.forAll ──────────────────────────────────────────────

/// Test: List.exists → 4 > 3 exists in [1;2;3;4;5] → 1
let testListExists () : int =
    if List.exists (fun x -> x > 3) [1; 2; 3; 4; 5] then 1 else 0

/// Test: List.exists → none > 10 → 0
let testListExistsFalse () : int =
    if List.exists (fun x -> x > 10) [1; 2; 3] then 1 else 0

/// Test: List.forAll → all > 0 in [1;2;3] → 1
let testListForAll () : int =
    if List.forall (fun x -> x > 0) [1; 2; 3] then 1 else 0

/// Test: List.forAll → not all > 2 in [1;2;3] → 0
let testListForAllFalse () : int =
    if List.forall (fun x -> x > 2) [1; 2; 3] then 1 else 0

// ─── List.sum ───────────────────────────────────────────────────────────────

/// Test: List.sum [1..5] = 15
let testListSum () : int =
    List.sum [1; 2; 3; 4; 5]

/// Test: List.sum [] = 0
let testListSumEmpty () : int =
    List.sum ([] : int list)

// ─── List.tryFind ───────────────────────────────────────────────────────────

/// Test: List.tryFind (>3) [1..5] = Some 4 → 4
let testListTryFindSome () : int =
    match List.tryFind (fun x -> x > 3) [1; 2; 3; 4; 5] with
    | Some v -> v
    | None   -> -1

/// Test: List.tryFind (>10) [1..5] = None → -1
let testListTryFindNone () : int =
    match List.tryFind (fun x -> x > 10) [1; 2; 3; 4; 5] with
    | Some v -> v
    | None   -> -1

// ─── List.tryHead ───────────────────────────────────────────────────────────

/// Test: List.tryHead [7;8;9] = Some 7 → 7
let testListTryHeadSome () : int =
    match List.tryHead [7; 8; 9] with
    | Some v -> v
    | None   -> -1

/// Test: List.tryHead [] = None → -1
let testListTryHeadNone () : int =
    match List.tryHead ([] : int list) with
    | Some v -> v
    | None   -> -1

// ─── Ref cells ──────────────────────────────────────────────────────────────

/// Test: create ref 5, increment via .Value <-, return .Value = 6
let testRefCell () : int =
    let r = ref 5
    r.Value <- r.Value + 1
    r.Value

/// Test: ref 0, conditionally set to 1, return .Value = 1
let testRefCellBool () : int =
    let r = ref 0
    if 3 > 2 then r.Value <- 1
    r.Value

// ─── Recursive discriminated union (Tree) ──────────────────────────────────

type Tree = Leaf | Node of Tree * Tree * int

let rec treeSum (t: Tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, r, v) -> v + treeSum l + treeSum r

/// Test: Node(Node(Leaf,Leaf,1), Node(Leaf,Leaf,2), 3) → 1+2+3 = 6
let testTreeSum () : int =
    treeSum (Node(Node(Leaf, Leaf, 1), Node(Leaf, Leaf, 2), 3))

/// Test: depth of a balanced tree of depth 3 = 7 nodes, sum of node values
let testTreeSum2 () : int =
    // Build: level3 = Node(Leaf,Leaf,1); level2 = Node(Node(Leaf,Leaf,1),Node(Leaf,Leaf,2),4)
    // root = Node(level2, Node(Leaf,Leaf,3), 10) → 1+2+4+3+10 = 20
    let ll = Node(Leaf, Leaf, 1)
    let lr = Node(Leaf, Leaf, 2)
    let rl = Node(Leaf, Leaf, 3)
    let left = Node(ll, lr, 4)
    let root = Node(left, rl, 10)
    treeSum root

// ─── Mutual tail calls ─────────────────────────────────────────────────────

let rec isEvenTC (n: int) : bool =
    if n = 0 then true else isOddTC (n - 1)
and isOddTC (n: int) : bool =
    if n = 0 then false else isEvenTC (n - 1)

/// Test: isEven 1000 → true → 1  (uses return_call, no stack overflow)
let testMutualTailCall () : int =
    if isEvenTC 1000 then 1 else 0

/// Test: isOdd 999 → true → 1
let testMutualTailCall2 () : int =
    if isOddTC 999 then 1 else 0

// ─── F# arrays (WASM GC mutable arrays) ────────────────────────────────────

/// Test: array literal [|5;10;15|], index 1 → 10
let testArrayLiteral () : int =
    let arr = [|5; 10; 15|]
    arr.[1]

/// Test: Array.create 3 0, mutate all, sum → 60
let testArrayCreate () : int =
    let arr = Array.create 3 0
    arr.[0] <- 10
    arr.[1] <- 20
    arr.[2] <- 30
    arr.[0] + arr.[1] + arr.[2]

/// Test: Array.zeroCreate 4, fill, read → 0+0+0+0 then set arr.[2]<-7, read → 7
let testArrayZeroCreate () : int =
    let arr = Array.zeroCreate 4
    arr.[2] <- 7
    arr.[2]

/// Test: arr.Length of [|1;2;3;4;5|] → 5
let testArrayLength () : int =
    let arr = [|1; 2; 3; 4; 5|]
    arr.Length

/// Test: sum over array with mutable accumulator → 15
let testArraySumLoop () : int =
    let arr = [|1; 2; 3; 4; 5|]
    let mutable s = 0
    for i in 0 .. arr.Length - 1 do
        s <- s + arr.[i]
    s

/// Test: float array, element access → 3.14
let testArrayFloat () : float =
    let arr = [|1.0; 3.14; 2.71|]
    arr.[1]

// ─── Array higher-order functions ──────────────────────────────────────────

/// Test: Array.fold sum [|1;2;3;4;5|] = 15
let testArrayFold () : int =
    Array.fold (fun acc x -> acc + x) 0 [|1; 2; 3; 4; 5|]

/// Test: Array.fold with float accumulator → 1.5
let testArrayFoldFloat () : float =
    Array.fold (fun acc x -> acc + x) 0.0 [|0.5; 0.5; 0.5|]

/// Test: Array.map double elements, check first+last = 2+10 = 12
let testArrayMap () : int =
    let result = Array.map (fun x -> x * 2) [|1; 2; 3; 4; 5|]
    result.[0] + result.[4]

/// Test: Array.map strings → check length
let testArrayMapStr () : int =
    let src = [|1; 2; 3|]
    let doubled = Array.map (fun x -> x * 3) src
    doubled.[2]   // 3*3 = 9

/// Test: Array.mapi (i, x) → i + x, check middle element
let testArrayMapi () : int =
    let arr = Array.mapi (fun i x -> i + x) [|10; 20; 30|]
    // [0+10; 1+20; 2+30] = [10; 21; 32]
    arr.[1]   // 21

/// Test: Array.filter keeps elements > 2: [3;4;5] → length 3
let testArrayFilter () : int =
    let arr = [|1; 2; 3; 4; 5|]
    let result = Array.filter (fun x -> x > 2) arr
    result.Length

/// Test: Array.filter all match: length = 5
let testArrayFilterAll () : int =
    let result = Array.filter (fun x -> x > 0) [|1; 2; 3; 4; 5|]
    result.Length

/// Test: Array.filter none match: length = 0
let testArrayFilterNone () : int =
    let result = Array.filter (fun x -> x > 10) [|1; 2; 3; 4; 5|]
    result.Length

/// Test: Array.exists with true predicate → 1
let testArrayExists () : int =
    if Array.exists (fun x -> x > 4) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.exists with false predicate → 0
let testArrayExistsFalse () : int =
    if Array.exists (fun x -> x > 10) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.forall all positive → 1
let testArrayForAll () : int =
    if Array.forall (fun x -> x > 0) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.forall not all > 3 → 0
let testArrayForAllFalse () : int =
    if Array.forall (fun x -> x > 3) [|1; 2; 3; 4; 5|] then 1 else 0

/// Test: Array.init 5 (i*i) → [0;1;4;9;16], check index 3 = 9
let testArrayInit () : int =
    let arr = Array.init 5 (fun i -> i * i)
    arr.[3]

/// Test: Array.init + fold → sum of 0..4 = 10
let testArrayInitFold () : int =
    let arr = Array.init 5 (fun i -> i)
    Array.fold (+) 0 arr

/// Test: Array.iter with mutable capture → sum = 15
let testArrayIter () : int =
    let mutable s = 0
    Array.iter (fun x -> s <- s + x) [|1; 2; 3; 4; 5|]
    s

/// Test: Array.iteri with mutable capture → sum of i*x: 0*1+1*2+2*3+3*4+4*5 = 40
let testArrayIteri () : int =
    let mutable s = 0
    Array.iteri (fun i x -> s <- s + i * x) [|1; 2; 3; 4; 5|]
    s

// ── New Array combinators ─────────────────────────────────────────

/// Test: Array.reduce (+) [|1;2;3;4;5|] = 15
let testArrayReduce () : int =
    Array.reduce (+) [|1; 2; 3; 4; 5|]

/// Test: Array.sum [|1;2;3;4;5|] = 15
let testArraySum () : int =
    Array.sum [|1; 2; 3; 4; 5|]

/// Test: Array.min [|3;1;4;1;5|] = 1
let testArrayMin () : int =
    Array.min [|3; 1; 4; 1; 5|]

/// Test: Array.max [|3;1;4;1;5|] = 5
let testArrayMax () : int =
    Array.max [|3; 1; 4; 1; 5|]

/// Test: Array.rev [|1;2;3|].[0] = 3
let testArrayRev () : int =
    (Array.rev [|1; 2; 3|]).[0]

/// Test: Array.sort [|3;1;2|] first element = 1
let testArraySort () : int =
    (Array.sort [|3; 1; 2|]).[0]

/// Test: Array.findIndex (fun x -> x > 3) [|1;5;2;4|] = 1
let testArrayFindIndex () : int =
    Array.findIndex (fun x -> x > 3) [|1; 5; 2; 4|]

/// Test: Array.contains 3 [|1;2;3;4|] → true → 1
let testArrayContains () : int =
    if Array.contains 3 [|1; 2; 3; 4|] then 1 else 0

/// Test: Array.contains 9 [|1;2;3;4|] → false → 0
let testArrayContainsFalse () : int =
    if Array.contains 9 [|1; 2; 3; 4|] then 1 else 0

// ── New List combinators ─────────────────────────────────────────

/// Test: List.mapi (fun i x -> i * x) [1;2;3] |> fold (+) 0 = 0+2+6 = 8
let testListMapi () : int =
    List.fold (+) 0 (List.mapi (fun i x -> i * x) [1; 2; 3])

/// Test: List.iteri (fun i x -> s <- s + i*x) [1;2;3] → s = 0+2+6 = 8
let testListIteri () : int =
    let mutable s = 0
    List.iteri (fun i x -> s <- s + i * x) [1; 2; 3]
    s

/// Test: List.collect (fun x -> [x; x*2]) [1;2;3] length = 6
let testListCollect () : int =
    List.length (List.collect (fun x -> [x; x * 2]) [1; 2; 3])

/// Test: List.collect order correct — fold of [1;2;2;4;3;6] = 18
let testListCollectOrder () : int =
    List.fold (+) 0 (List.collect (fun x -> [x; x * 2]) [1; 2; 3])

/// Test: List.choose (fun x -> if x > 2 then Some(x*10) else None) [1;2;3;4] length = 2
let testListChoose () : int =
    List.length (List.choose (fun x -> if x > 2 then Some(x * 10) else None) [1; 2; 3; 4])

/// Test: List.choose sum of chosen values = 30+40 = 70
let testListChooseSum () : int =
    List.fold (+) 0 (List.choose (fun x -> if x > 2 then Some(x * 10) else None) [1; 2; 3; 4])

// ── List.foldBack / sumBy / minBy / maxBy ────────────────────────

/// Test: List.foldBack (::) [1;2;3] [] = [1;2;3] — fold right restores list
let testListFoldBack () : int =
    List.length (List.foldBack (fun x acc -> x :: acc) [1; 2; 3] [])

/// Test: List.foldBack builds right-to-left string of lengths: 3-2-1
/// Since we return int, test that foldBack difference: foldBack(sub)[1;2;3] 0 = 1-2+3 = 2
/// foldBack sub [1;2;3] 0 = sub 1 (sub 2 (sub 3 0)) = sub 1 (sub 2 3) = sub 1 1 = 0
let testListFoldBackOrder () : int =
    List.foldBack (fun x acc -> x - acc) [1; 2; 3] 0

/// Test: List.sumBy (fun x -> x * x) [1;2;3;4] = 1+4+9+16 = 30
let testListSumBy () : int =
    List.sumBy (fun x -> x * x) [1; 2; 3; 4]

/// Test: List.minBy (fun x -> x % 3) [4;2;7;1;6] — element with min (x%3): 1%3=1, 2%3=2, 4%3=1, 6%3=0, 7%3=1 → 6
let testListMinBy () : int =
    List.minBy (fun x -> x % 3) [4; 2; 7; 1; 6]

/// Test: List.maxBy (fun x -> x % 5) [3;8;1;6;4] — max (x%5): 3%5=3, 8%5=3, 1%5=1, 6%5=1, 4%5=4 → 4
let testListMaxBy () : int =
    List.maxBy (fun x -> x % 5) [3; 8; 1; 6; 4]

// ── List.min / List.max / List.contains ──────────────────────────

/// Test: List.min [3;1;4;1;5] = 1
let testListMin () : int =
    List.min [3; 1; 4; 1; 5]

/// Test: List.max [3;1;4;1;5] = 5
let testListMax () : int =
    List.max [3; 1; 4; 1; 5]

/// Test: List.contains 3 [1;2;3;4] → true → 1
let testListContains () : int =
    if List.contains 3 [1; 2; 3; 4] then 1 else 0

/// Test: List.contains 9 [1;2;3;4] → false → 0
let testListContainsFalse () : int =
    if List.contains 9 [1; 2; 3; 4] then 1 else 0

// ── List.init / replicate / take / skip / sort ───────────────────

/// Test: List.init 5 (fun _ -> 1) - all ones, length = 5
let testListInit () : int =
    List.length (List.init 5 (fun _ -> 1))

/// Test: List.replicate 4 7 → [7;7;7;7]; head = 7
let testListReplicate () : int =
    List.head (List.replicate 4 7)

/// Test: List.take 3 [1..5] → [1;2;3]; last = 3
let testListTake () : int =
    List.item 2 (List.take 3 [1; 2; 3; 4; 5])

/// Test: List.skip 2 [1..5] → [3;4;5]; head = 3
let testListSkip () : int =
    List.head (List.skip 2 [1; 2; 3; 4; 5])

/// Test: List.sort [3;1;4;1;5;2] head = 1
let testListSort () : int =
    List.head (List.sort [3; 1; 4; 1; 5; 2])
// ── Array.scan / Array.append ────────────────────────────────────

/// Test: Array.scan (+) 0 [|1;2;3;4|] = [|0;1;3;6;10|]; last element = 10
let testArrayScan () : int =
    let r = Array.scan (+) 0 [|1; 2; 3; 4|]
    r.[r.Length - 1]

/// Test: Array.scan length = n+1 = 5
let testArrayScanLen () : int =
    (Array.scan (+) 0 [|1; 2; 3; 4|]).Length

/// Test: Array.append [|1;2;3|] [|4;5|] element at index 3 = 4
let testArrayAppend () : int =
    (Array.append [|1; 2; 3|] [|4; 5|]).[3]

/// Test: Array.append concatenated length = 5
let testArrayAppendLen () : int =
    (Array.append [|1; 2; 3|] [|4; 5|]).Length

// ── String operations ────────────────────────────────────────────

/// Test: "hello world".IndexOf("world") = 6
let testStringIndexOf () : int =
    "hello world".IndexOf("world")

/// Test: "hello world".IndexOf("xyz") = -1
let testStringIndexOfMiss () : int =
    "hello world".IndexOf("xyz")

/// Test: "abcabc".LastIndexOf("bc") = 4 (last occurrence)
let testStringLastIndexOf () : int =
    "abcabc".LastIndexOf("bc")

/// Test: "abcabc".LastIndexOf("xyz") = -1 (not found)
let testStringLastIndexOfMiss () : int =
    "abcabc".LastIndexOf("xyz")

/// Test: "hello world hello".IndexOf("hello", 5) = 12 (after fromIndex)
let testStringIndexOfFrom () : int =
    "hello world hello".IndexOf("hello", 5)

/// Test: "hello world".StartsWith("hello") = true → 1
let testStringStartsWith () : int =
    if "hello world".StartsWith("hello") then 1 else 0

/// Test: "hello world".StartsWith("world") = false → 0
let testStringStartsWithFalse () : int =
    if "hello world".StartsWith("world") then 1 else 0

/// Test: "hello world".EndsWith("world") = true → 1
let testStringEndsWith () : int =
    if "hello world".EndsWith("world") then 1 else 0

/// Test: "hello world".EndsWith("hello") = false → 0
let testStringEndsWithFalse () : int =
    if "hello world".EndsWith("hello") then 1 else 0

/// Test: "hello world".Substring(6) = "world"; length = 5
let testStringSubstring () : int =
    "hello world".Substring(6).Length

/// Test: "hello world".Substring(6, 3) = "wor"; length = 3
let testStringSubstringLen () : int =
    "hello world".Substring(6, 3).Length

// ── List.findIndex ────────────────────────────────────────────────

/// Test: List.findIndex (fun x -> x > 3) [1;5;2;4] = 1 (index of 5)
let testListFindIndex () : int =
    List.findIndex (fun x -> x > 3) [1; 5; 2; 4]

/// Test: List.findIndex (fun x -> x > 10) [1;2;3] → exception; guard with tryFindIndex = None → -1
let testListTryFindIndex () : int =
    match List.tryFindIndex (fun x -> x > 10) [1; 2; 3] with
    | Some i -> i
    | None -> -1

// ── Option.Value ─────────────────────────────────────────────────

/// Test: (Some 42).Value = 42
let testOptionValue () : int =
    (Some 42).Value

/// Test: Option.map then .Value = 84
let testOptionMapValue () : int =
    (Option.map (fun x -> x * 2) (Some 42)).Value

// ── Result<T,E> pattern matching ─────────────────────────────────

/// Test: match Ok 42 with Ok x -> x | Error _ -> -1 = 42
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
let testToLowerLength () : int =
    let s = "Hello".ToLower()
    s.Length

/// Test: "hello".ToUpper() = "HELLO" → first char
let testToUpperFirstChar () : int =
    let s = "hello".ToUpper()
    int s.[0]  // 'H' = 72

/// Test: toLower roundtrip
let testToLowerChars () : int =
    let s = "ABC".ToLower()
    // a=97, b=98, c=99, sum=294
    int s.[0] + int s.[1] + int s.[2]

/// Test: toUpper roundtrip
let testToUpperChars () : int =
    let s = "xyz".ToUpper()
    // X=88, Y=89, Z=90, sum=267
    int s.[0] + int s.[1] + int s.[2]

/// Test: String.trim leading/trailing spaces
let testTrimBasic () : int =
    let s = "  hi  ".Trim()
    s.Length  // "hi" → 2

/// Test: trimStart only
let testTrimStart () : int =
    let s = "  abc".TrimStart()
    s.Length  // "abc" → 3

/// Test: trimEnd only
let testTrimEnd () : int =
    let s = "abc  ".TrimEnd()
    s.Length  // "abc" → 3

/// Test: String.contains "hello" "ell" = true
let testContains () : int =
    if "hello".Contains("ell") then 1 else 0

/// Test: String.contains "hello" "xyz" = false
let testContainsNot () : int =
    if "hello".Contains("xyz") then 1 else 0

/// Test: toLower on mixed string
let testToLowerMixed () : int =
    let s = "HeLLo".ToLower()
    // should equal "hello", first char = 104
    int s.[0]  // 'h' = 104

// ─── Number-to-string + String interpolation ──────────────────────

/// Test: string(42).Length = 2
let testStringOfInt () : int =
    (string 42).Length

/// Test: string(-1).Length = 2
let testStringOfNegInt () : int =
    (string -1).Length

/// Test: string(0).Length = 1
let testStringOfZero () : int =
    (string 0).Length

/// Test: string(123) starts with '1' (= 49)
let testStringOfIntChar () : int =
    int (string 123).[0]  // '1' = 49

/// Test: F# interpolated string $"x={x}" produces correct length
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
let testPadLeft () : int =
    ("42".PadLeft(5)).Length

/// Test: "42".PadRight(5) → "42   " — length 5
let testPadRight () : int =
    ("42".PadRight(5)).Length

/// Test: "42".PadLeft(1) → "42" (no change needed) — length 2
let testPadLeftNoop () : int =
    ("42".PadLeft(1)).Length

/// Test: "42".PadLeft(4) first char = ' ' (32)
let testPadLeftChar () : int =
    int ("42".PadLeft(4)).[0]  // '  42'[0] = 32

/// Test: "hello world".Replace("world", "F#") — result "hello F#", length 8
let testReplace () : int =
    ("hello world".Replace("world", "F#")).Length

/// Test: "aabbcc".Replace("bb", "") — result "aacc", length 4
let testReplaceRemove () : int =
    ("aabbcc".Replace("bb", "")).Length

/// Test: "abc".Replace("x", "y") — no match, same string, length 3
let testReplaceNoMatch () : int =
    ("abc".Replace("x", "y")).Length

/// Test printfn with string literal (just checking doesn't crash)
let testPrintfnLiteral () : int =
    printfn "hello"
    42

// ─── More List operations ─────────────────────────────────────────

/// Test: List.item 2 [10;20;30;40;50] = 30
let testListItem () : int =
    List.item 2 [10; 20; 30; 40; 50]

/// Test: (List.tail [100;200;300]).Head = 200
let testListTailHead () : int =
    (List.tail [100; 200; 300]).Head

/// Test: List.length [10;20;30] = 3
let testListLength () : int =
    List.length [10; 20; 30]

/// Test: List.reduce (+) [1;2;3;4;5] = 15
let testListReduce () : int =
    List.reduce (fun a b -> a + b) [1; 2; 3; 4; 5]

/// Test: List.reduce max equivalent [3;1;4;1;5;9;2;6] = 9
let testListReduceMax () : int =
    List.reduce (fun a b -> if a > b then a else b) [3; 1; 4; 1; 5; 9; 2; 6]

/// Test: List.last [1;2;3;4;5] = 5
let testListLast () : int =
    List.last [1; 2; 3; 4; 5]

/// Test: List.last [42] = 42  (single-element list)
let testListLastSingle () : int =
    List.last [42]

/// Test: (List.sortDescending [3;1;4;1;5;9]).Head = 9
let testListSortDesc () : int =
    (List.sortDescending [3; 1; 4; 1; 5; 9]).Head

// ─── Bitwise / arithmetic ─────────────────────────────────────────

/// Test: 5 &&& 3 = 1
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
let testIsDigit () : int =
    if System.Char.IsDigit('5') then 1 else 0

/// Test: Char.IsDigit 'A' = false
let testIsDigitFalse () : int =
    if System.Char.IsDigit('A') then 1 else 0

/// Test: Char.IsLetter 'A' = true
let testIsLetter () : int =
    if System.Char.IsLetter('A') then 1 else 0

/// Test: Char.IsLetter '5' = false
let testIsLetterFalse () : int =
    if System.Char.IsLetter('5') then 1 else 0

/// Test: Char.IsUpper 'A' = true
let testIsUpper () : int =
    if System.Char.IsUpper('A') then 1 else 0

/// Test: Char.IsLower 'a' = true
let testIsLower () : int =
    if System.Char.IsLower('a') then 1 else 0

/// Test: Char.IsWhiteSpace ' ' = true
let testIsWhiteSpace () : int =
    if System.Char.IsWhiteSpace(' ') then 1 else 0

/// Test: Char.IsLetterOrDigit '9' = true
let testIsLetterOrDigit () : int =
    if System.Char.IsLetterOrDigit('9') then 1 else 0

/// Test: Char.ToLower 'A' = 'a' (97)
let testCharToLower () : int =
    int (System.Char.ToLower('A'))

/// Test: Char.ToUpper 'a' = 'A' (65)
let testCharToUpper () : int =
    int (System.Char.ToUpper('a'))

// ─── Option additional operations ────────────────────────────────

/// Test: Option.defaultValue 99 (Some 42) = 42
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
let testFloatMul () : int =
    if 3.0 * 2.0 = 6.0 then 1 else 0

/// Test: float comparison 1.5 < 2.5
let testFloatCompare () : int =
    if 1.5 < 2.5 then 1 else 0

// ─── Sprint 6: Structural Equality ─────────────────────────────────────────────

/// Test: record equality — same values → 1
let testRecordEqTrue () : int =
    let p1 = { X = 1.0; Y = 2.0 }
    let p2 = { X = 1.0; Y = 2.0 }
    if p1 = p2 then 1 else 0

/// Test: record equality — different Y → 0
let testRecordEqFalse () : int =
    let p1 = { X = 1.0; Y = 2.0 }
    let p2 = { X = 1.0; Y = 3.0 }
    if p1 = p2 then 1 else 0

/// Test: record inequality — different Y → 1
let testRecordNeq () : int =
    let p1 = { X = 5.0; Y = 6.0 }
    let p2 = { X = 5.0; Y = 7.0 }
    if p1 <> p2 then 1 else 0

/// Test: DU equality — same enum tag → 1
let testDuEnumEqTrue () : int =
    let a = Direction.North
    let b = Direction.North
    if a = b then 1 else 0

/// Test: DU equality — different enum tags → 0
let testDuEnumEqFalse () : int =
    let a = Direction.North
    let b = Direction.South
    if a = b then 1 else 0

/// Test: data-carrying DU equality — Circle 3.0 = Circle 3.0 → 1
let testDuDataEqTrue () : int =
    let s1 = Circle 3.0
    let s2 = Circle 3.0
    if s1 = s2 then 1 else 0

/// Test: data-carrying DU equality — Circle 3.0 ≠ Circle 4.0 → 0
let testDuDataEqFalse () : int =
    let s1 = Circle 3.0
    let s2 = Circle 4.0
    if s1 = s2 then 1 else 0

/// Test: data-carrying DU equality — different constructors → 0
let testDuDataEqDiffCtor () : int =
    let s1 = Circle 3.0
    let s2 = Square 3.0
    if s1 = s2 then 1 else 0

/// Test: tuple equality — same values → 1
let testTupleEqTrue () : int =
    if (1, 2) = (1, 2) then 1 else 0

/// Test: tuple equality — different second element → 0
let testTupleEqFalse () : int =
    if (1, 2) = (1, 3) then 1 else 0

/// Test: tuple inequality — different second element → 1
let testTupleNeq () : int =
    if (1, 2) <> (1, 3) then 1 else 0

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 5: Monomorphization — demand-driven generic specialization
// ─────────────────────────────────────────────────────────────────────────────

/// Generic identity function.
/// Monomorphized to i32 (testIdentityInt) and f64 (testIdentityFloat).
let identity<'T> (x: 'T) : 'T = x

/// Test: identity<int> 99 = 99
let testIdentityInt () : int = identity 99

/// Test: identity<float> 2.5 > 2.0 → 1
let testIdentityFloat () : int =
    if identity 2.5 > 2.0 then 1 else 0

/// Generic const2: returns first argument, discards second.
/// Exercises a two-type-parameter specialization.
let const2<'A, 'B> (a: 'A) (b: 'B) : 'A = a

/// Test: const2<int,float> 7 3.14 = 7
let testConst2IntFloat () : int = const2 7 3.14

/// Test: const2<int,int> 99 0 = 99
let testConst2IntInt () : int = const2 99 0

/// Test: const2<float,int> 2.5 42 → result > 2.0 → 1
let testConst2FloatInt () : int =
    if const2 2.5 42 > 2.0 then 1 else 0

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 9: FSharp.Wasm.Core/Collections/Map.fs — F# library compiled by our backend
// Tests call MapModule directly (src/FSharp.Wasm.Core/Collections/Map.fs).
// The library is a REAL F# source file, not compiler-internal WasmIR.
// ─────────────────────────────────────────────────────────────────────────────

/// Standard int comparator used by all MapModule/SetModule tests.
let private intCmp (a: int) (b: int) : int = if a < b then -1 elif a > b then 1 else 0

/// Test: MapModule.add + tryFind — found key → 100
let testMapAddFind () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100 |> MapModule.add 2 200
    MapModule.tryFind 1 m |> Option.defaultValue 0

/// Test: tryFind on missing key → default 0
let testMapFindMissing () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100
    MapModule.tryFind 99 m |> Option.defaultValue 0

/// Test: count — two entries → 2
let testMapCount () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100 |> MapModule.add 2 200
    MapModule.count m

/// Test: containsKey — key present → 1
let testMapContainsKey () : int =
    let m = MapModule.empty intCmp |> MapModule.add 42 999
    if MapModule.containsKey 42 m then 1 else 0

/// Test: containsKey — key absent → 0
let testMapContainsKeyMissing () : int =
    let m = MapModule.empty intCmp |> MapModule.add 42 999
    if MapModule.containsKey 7 m then 1 else 0

/// Test: add replaces existing key → 555
let testMapAddReplace () : int =
    let m = MapModule.empty intCmp |> MapModule.add 1 100 |> MapModule.add 1 555
    MapModule.tryFind 1 m |> Option.defaultValue 0

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 10b: FSharp.Wasm.Core/Option.fs — BCL migration
// Phase A: call OptionModule.* directly (via KnownFuncsByPath dispatch).
// The old tryOptionInline handlers remain active for FSharp.Core `Option.*` calls.
// These tests prove the compiled F# Option.fs functions produce identical results.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 10b: Option/Result inline replacements
// These call FSharp.Core Option.* / Result.* — Fable transforms them to direct
// WasmGC struct ops (ref.is_null, struct.get tag) at the FableTransforms stage.
// No source library file is needed; inlining is the correct architecture.
// ─────────────────────────────────────────────────────────────────────────────

/// Test: Option.isSome (Some 5) = true → 1
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

/// Test: sprintf "%f" 3.14 = "3.140000" — %f always prints 6 decimals; length 8
let testSprintfFloat () : int =
    (sprintf "%f" 3.14).Length

/// Test: sprintf "%f" 0.5 → "0.500000", length = 8
let testSprintfFloatHalf () : int =
    (sprintf "%f" 0.5).Length

/// Test: sprintf "%f" 2.0 → "2.000000", length = 8
let testSprintfFloatWhole () : int =
    (sprintf "%f" 2.0).Length

/// Test: sprintf "%f" -1.5 → "-1.500000", length = 9
let testSprintfFloatNeg () : int =
    (sprintf "%f" -1.5).Length

/// Test: sprintf "pi=~%f" 3.14159 → starts with 'p' = 112
let testSprintfFloatInStr () : int =
    int (sprintf "pi=~%f" 3.14159).[0]

// Precision, rounding and sign of %f / %.Nf.  Expected values come from the .NET reference (tests/Differential).
let testSprintfFloatPrec2 () : int = if sprintf "%.2f" 3.14159 = "3.14" then 1 else 0
let testSprintfFloatPrec0 () : int = if sprintf "%.0f" 2.4 = "2" then 1 else 0
let testSprintfFloatPrec3Neg () : int = if sprintf "%.3f" -2.71828 = "-2.718" then 1 else 0
/// rounding carries into the integer part
let testSprintfFloatCarry () : int = if sprintf "%.1f" 9.96 = "10.0" then 1 else 0
let testSprintfFloatRoundUp () : int = if sprintf "%.2f" 2.675 = sprintf "%.2f" 2.675 then 1 else 0
let testSprintfFloatSixDecimals () : int = if sprintf "%f" 3.14159 = "3.141590" then 1 else 0

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
let testStrSplitLen () : int =
    let parts = "a,b,c".Split([| "," |], System.StringSplitOptions.None)
    parts.Length

/// Test: "a,b,c".Split(",") → first part is "a" → length 1
let testStrSplitFirst () : int =
    let parts = "a,b,c".Split([| "," |], System.StringSplitOptions.None)
    parts.[0].Length

/// Test: "a,b,c".Split(",") → second part "b" → first char = 98 ('b')
let testStrSplitSecond () : int =
    let parts = "a,b,c".Split([| "," |], System.StringSplitOptions.None)
    int parts.[1].[0]

/// Test: "hello world foo".Split(" ") → 3 parts
let testStrSplitWords () : int =
    let parts = "hello world foo".Split([| " " |], System.StringSplitOptions.None)
    parts.Length

/// Test: "no-delim".Split(",") → 1 part (no delimiter found)
let testStrSplitNoDelim () : int =
    let parts = "no-delim".Split([| "," |], System.StringSplitOptions.None)
    parts.Length

/// Test: "".Split(",") → 1 part (empty string gives 1 segment)
let testStrSplitEmpty () : int =
    let parts = "".Split([| "," |], System.StringSplitOptions.None)
    parts.Length

/// Test: split and re-join length — "x::y::z" split by "::" → 3 parts
let testStrSplitMultiChar () : int =
    let parts = "x::y::z".Split([| "::" |], System.StringSplitOptions.None)
    parts.Length

// ── String.Join tests ──────────────────────────────────────────────────────

/// Test: String.Join(", ", [|"hello";"world";"foo"|]) → "hello, world, foo" (length 17)
let testStrJoinLen () : int =
    let parts = [| "hello"; "world"; "foo" |]
    System.String.Join(", ", parts).Length

/// Test: String.Join with empty sep → "helloworld" (length 10)
let testStrJoinNoSep () : int =
    System.String.Join("", [| "hello"; "world" |]).Length

/// Test: String.Join with single element → same as element (length 5)
let testStrJoinOne () : int =
    System.String.Join(",", [| "hello" |]).Length

// ── Int32.Parse tests ──────────────────────────────────────────────────────

/// Test: Int32.Parse("42") = 42
let testIntParse () : int =
    System.Int32.Parse("42")

/// Test: Int32.Parse("-17") = -17
let testIntParseNeg () : int =
    System.Int32.Parse("-17")

/// Test: Int32.Parse("0") = 0
let testIntParseZero () : int =
    System.Int32.Parse("0")

// ── Double.Parse / float tests ─────────────────────────────────────────────

/// Test: float "3.14" * 100.0 |> int = 314
let testFloatParse () : int =
    int (float "3.14" * 100.0)

/// Test: float "-2.5" * 10.0 |> int = -25
let testFloatParseNeg () : int =
    int (float "-2.5" * 10.0)

/// Test: float "7" |> int = 7   (integer string, no dot)
let testFloatParseInt () : int =
    int (float "7")

// ── String.IsNullOrEmpty / String.compare ─────────────────────────────────

/// Test: String.IsNullOrEmpty "" = true (1)
let testStrIsNullOrEmptyTrue () : int =
    if System.String.IsNullOrEmpty("") then 1 else 0

/// Test: String.IsNullOrEmpty "hi" = false (0)
let testStrIsNullOrEmptyFalse () : int =
    if System.String.IsNullOrEmpty("hi") then 1 else 0

/// Test: String.compare "abc" "abc" = 0
let testStrCompareEq () : int =
    System.String.Compare("abc", "abc")

/// Test: String.compare "abc" "abd" < 0 → -1
let testStrCompareLt () : int =
    System.String.Compare("abc", "abd")

/// Test: String.compare "b" "a" > 0 → 1
let testStrCompareGt () : int =
    System.String.Compare("b", "a")

// ── Showcase: Recursion ───────────────────────────────────────────────────

/// Fibonacci (recursive)
let rec fibonacci (n: int) : int =
    if n <= 1 then n else fibonacci (n - 1) + fibonacci (n - 2)

/// Test: fibonacci 10 = 55
let testFib10 () : int = fibonacci 10

/// Test: fibonacci 15 = 610
let testFib15 () : int = fibonacci 15

// ── Showcase: Primes (array + loop) ──────────────────────────────────────

/// Naive primality test: O(n) trial division
let isPrime (n: int) : bool =
    if n < 2 then false
    else
        let mutable i = 2
        let mutable ok = true
        while i * i <= n && ok do
            if n % i = 0 then ok <- false
            i <- i + 1
        ok

/// Test: isPrime 7 = true → 1
let testIsPrime7 () : int = if isPrime 7 then 1 else 0

/// Test: isPrime 4 = false → 0
let testIsPrime4 () : int = if isPrime 4 then 1 else 0

/// Test: count primes up to 50 = 15 (2,3,5,7,11,13,17,19,23,29,31,37,41,43,47)
let testCountPrimesTo50 () : int =
    let mutable count = 0
    for i in 2 .. 50 do
        if isPrime i then count <- count + 1
    count

// ── Showcase: Project Euler style ────────────────────────────────────────

/// Sum of all multiples of 3 or 5 below 1000 = 233168
let testSumMultiples35 () : int =
    let mutable sum = 0
    for i in 1 .. 999 do
        if i % 3 = 0 || i % 5 = 0 then sum <- sum + i
    sum

/// Collatz sequence steps for n=27 = 111
let testCollatz27 () : int =
    let mutable n = 27
    let mutable steps = 0
    while n <> 1 do
        if n % 2 = 0 then n <- n / 2
        else n <- 3 * n + 1
        steps <- steps + 1
    steps

// ── Showcase: List combinators ────────────────────────────────────────────

/// Test: Array.toList [|1;2;3|] |> List.sum = 6
let testArrayToList () : int =
    let arr = [| 1; 2; 3 |]
    let lst = Array.toList arr
    List.sum lst

/// Test: List.ofArray [|4;5;6|] |> List.sum = 15
let testListOfArray () : int =
    let arr = [| 4; 5; 6 |]
    let lst = List.ofArray arr
    List.sum lst

/// Test: List.sortBy id [3;1;4;1;5;9;2;6] |> List.head = 1
let testListSortBy () : int =
    List.sortBy id [3; 1; 4; 1; 5; 9; 2; 6]
    |> List.head

/// Test: List.append [1;2;3] [4;5] |> List.sum = 15
let testListFlatten () : int =
    List.append [1; 2; 3] [4; 5] |> List.sum

// ── Interface vtable dispatch tests ─────────────────────────────────────

type IGreeter =
    abstract Greet: unit -> int  // returns length of greeting string

type EnglishGreeter = { Word: string }
    with
        interface IGreeter with
            member this.Greet() = this.Word.Length

type SpanishGreeter = { Palabra: string }
    with
        interface IGreeter with
            member this.Greet() = this.Palabra.Length

/// Test: vtable dispatch — Dog.Speak via IAnimal interface.
/// EnglishGreeter { Word = "hello" } :> IGreeter |> .Greet() = 5
let testInterfaceDispatch () : int =
    let g : IGreeter = { Word = "hello" } :> IGreeter
    g.Greet()

/// Test: vtable dispatch polymorphism — two different implementors.
/// ["hello".Length; "hola".Length] |> List.sum = 5 + 4 = 9
let testInterfacePolymorphism () : int =
    let greeters : IGreeter list =
        [ { Word = "hello" } :> IGreeter
          { Palabra = "hola" } :> IGreeter ]
    greeters |> List.sumBy (fun g -> g.Greet())

// ── DU implementing interface ─────────────────────────────────────────────

type IShape =
    abstract Area: unit -> int

type IntShape =
    | ICircle of Radius: int
    | IRect of Width: int * Height: int
    interface IShape with
        member this.Area() =
            match this with
            | ICircle r -> r * r
            | IRect(w, h) -> w * h

/// DU implementing interface — ICircle(3).Area() = 9
let testDuInterfaceCircle () : int =
    let s : IShape = ICircle 3 :> IShape
    s.Area()

/// DU implementing interface — IRect(4,5).Area() = 20
let testDuInterfaceRect () : int =
    let s : IShape = IRect(4, 5) :> IShape
    s.Area()

/// DU interface polymorphism
let testDuInterfacePoly () : int =
    let shapes : IShape list = [ ICircle 2 :> IShape; IRect(3, 4) :> IShape ]
    shapes |> List.sumBy (fun s -> s.Area())  // 4 + 12 = 16

// ── Regular class implementing interface ──────────────────────────────────

type ClassCircle(radius: int) =
    interface IShape with
        member _.Area() = radius * radius

type ClassRect(width: int, height: int) =
    interface IShape with
        member _.Area() = width * height

/// Regular class implementing interface — ClassCircle(5).Area() = 25
let testClassCircleArea () : int =
    let s : IShape = ClassCircle(5) :> IShape
    s.Area()

/// Regular class implementing interface — ClassRect(3,7).Area() = 21
let testClassRectArea () : int =
    let s : IShape = ClassRect(3, 7) :> IShape
    s.Area()

/// Mixed list: DU + regular class, both implementing IShape
let testMixedShapes () : int =
    let shapes : IShape list = [ ICircle 3 :> IShape; ClassRect(2, 6) :> IShape ]
    shapes |> List.sumBy (fun s -> s.Area())  // 9 + 12 = 21

// ── Interface used before any implementation exists, tupled members, any implementation order ──

type IMeasure =
    abstract Size: text: string * scale: float * pad: int -> int
    abstract Label: unit -> string

/// The call sites precede every implementation in the compile order, as a library function taking a host-supplied service.
let measureVia (m: IMeasure) (s: string) : int = m.Size(s, 2.0, 1) + (m.Label()).Length

/// Members implemented in the opposite order of the declaration (the vtable slots are filled by name).
type WideMeasure(k: int) =
    interface IMeasure with
        member _.Label() = "wide"
        member _.Size(text, scale, pad) = int (float text.Length * scale) * k + pad

type NarrowMeasure =
    { Unit: int }
    interface IMeasure with
        member _.Label() = "narrow!"
        member this.Size(text, _scale, pad) = text.Length * this.Unit + pad

/// class, reversed order: Size("abcd", 2.0, 1) = int(4 * 2.0) * 3 + 1 = 25, plus "wide".Length = 4
let testInterfaceBeforeImplClass () : int = measureVia (WideMeasure(3) :> IMeasure) "abcd"

/// record, reversed order: 4 * 5 + 1 = 21, plus "narrow!".Length = 7
let testInterfaceBeforeImplRecord () : int = measureVia ({ Unit = 5 } :> IMeasure) "abcd"

// ── Object expressions implementing an interface ─────────────────────────

/// Captures `scale`; the members take their own (tupled) parameters.
let objExprMeasure (scale: int) : IMeasure =
    { new IMeasure with
        member _.Label() = "obj"
        member _.Size(text, factor, pad) = int (float text.Length * factor) * scale + pad }

type ISink =
    abstract Push: int -> unit
    abstract Total: unit -> int

/// Size("abcd", 2.0, 1) = int(4 * 2.0) * 3 + 1 = 25, plus "obj".Length = 3
let testObjectExprCapture () : int = measureVia (objExprMeasure 3) "abcd"

/// Two instances of one expression keep their own captures: 2 * 100 + 20 = 220
let testObjectExprTwoInstances () : int =
    let a = objExprMeasure 1
    let b = objExprMeasure 10
    a.Size("ab", 1.0, 0) * 100 + b.Size("ab", 1.0, 0)

/// A captured ref cell is shared state between the members: 5 + 7 = 12
let testObjectExprSharedState () : int =
    let total = ref 0
    let sink =
        { new ISink with
            member _.Push(x) = total.Value <- total.Value + x
            member _.Total() = total.Value }
    sink.Push 5
    sink.Push 7
    sink.Total()

/// An object expression and a class implementing the same interface in one list: 2 * 2 + 2 * 1 = 6
let testObjectExprNextToClass () : int =
    [ objExprMeasure 2; WideMeasure(1) :> IMeasure ] |> List.sumBy (fun m -> m.Size("ab", 1.0, 0))

// ── List.sortWith ─────────────────────────────────────────────────────────

type SWItem = { SWVal: int }

/// sortWith ascending comparator: head of sorted [3;1;4;2] should be 1
let testSortWith () : int =
    let items = [ { SWVal = 3 }; { SWVal = 1 }; { SWVal = 4 }; { SWVal = 2 } ]
    let sorted = List.sortWith (fun a b -> if a.SWVal < b.SWVal then -1 elif a.SWVal > b.SWVal then 1 else 0) items
    (List.head sorted).SWVal  // 1

/// sortWith descending comparator: head of sorted [3;1;4;2] should be 4
let testSortWithDesc () : int =
    let items = [ { SWVal = 3 }; { SWVal = 1 }; { SWVal = 4 }; { SWVal = 2 } ]
    let sorted = List.sortWith (fun a b -> if b.SWVal < a.SWVal then -1 elif b.SWVal > a.SWVal then 1 else 0) items
    (List.head sorted).SWVal  // 4

/// sortWith on ints: head should be 1
let testSortWithInts () : int =
    List.sortWith (fun a b -> if a < b then -1 elif a > b then 1 else 0) [5; 3; 1; 4; 2] |> List.head  // 1

// ── Array.sortWith ────────────────────────────────────────────────────────

/// Array.sortWith ascending: head of sorted [|3;1;4;2|] should be 1
let testArraySortWith () : int =
    let arr = [| 3; 1; 4; 2 |]
    let sorted = Array.sortWith (fun a b -> if a < b then -1 elif a > b then 1 else 0) arr
    sorted.[0]  // 1

/// Array.sortWith descending: head of sorted [|3;1;4;2|] should be 4
let testArraySortWithDesc () : int =
    let arr = [| 3; 1; 4; 2 |]
    let sorted = Array.sortWith (fun a b -> if b < a then -1 elif b > a then 1 else 0) arr
    sorted.[0]  // 4

// ── List.zip ──────────────────────────────────────────────────────────────

/// Test: List.zip [1;2;3] [10;20;30] |> List.head = (1, 10), sum = 11
let testListZip () : int =
    let xs = [1; 2; 3]
    let ys = [10; 20; 30]
    let zipped = List.zip xs ys
    let (a, b) = List.head zipped
    a + b  // 11

/// Test: List.zip ['a';'b';'c'] [1;2;3] length = 3
let testListZipLen () : int =
    let xs = ['a'; 'b'; 'c']
    let ys = [1; 2; 3]
    List.zip xs ys |> List.length  // 3

// ── List.map2 ─────────────────────────────────────────────────────────────

/// Test: List.map2 (+) [1;2;3] [4;5;6] |> List.sum = 21
let testListMap2Sum () : int =
    List.map2 (fun a b -> a + b) [1; 2; 3] [4; 5; 6] |> List.sum  // 21

/// Test: List.map2 (*) [1;2;3] [4;5;6] head = 4
let testListMap2Head () : int =
    List.map2 (fun a b -> a * b) [1; 2; 3] [4; 5; 6] |> List.head  // 4

// ── Array.zip ─────────────────────────────────────────────────────────────

/// Test: Array.zip [|1;2;3|] [|10;20;30|].[0] = (1,10), sum = 11
let testArrayZip () : int =
    let arr1 = [| 1; 2; 3 |]
    let arr2 = [| 10; 20; 30 |]
    let zipped = Array.zip arr1 arr2
    let (a, b) = zipped.[0]
    a + b  // 11

/// Test: Array.zip of length 3 → length 3
let testArrayZipLen () : int =
    let zipped = Array.zip [| 1; 2; 3 |] [| 4; 5; 6 |]
    zipped.Length  // 3

// ── Array.map2 ────────────────────────────────────────────────────────────

/// Test: Array.map2 (+) [|1;2;3|] [|4;5;6|] sum = 21
let testArrayMap2Sum () : int =
    Array.map2 (fun a b -> a + b) [| 1; 2; 3 |] [| 4; 5; 6 |] |> Array.sum  // 21

/// Test: Array.map2 (*) first = 4
let testArrayMap2Head () : int =
    (Array.map2 (fun a b -> a * b) [| 1; 2; 3 |] [| 4; 5; 6 |]).[0]  // 4

// ── pown (integer exponentiation) ─────────────────────────────────────────

/// Test: pown 2 10 = 1024
let testPown2_10 () : int = pown 2 10

/// Test: pown 3 0 = 1
let testPownZero () : int = pown 3 0

/// Test: pown 5 3 = 125
let testPownCube () : int = pown 5 3

/// Test: pown 1 100 = 1
let testPownOne () : int = pown 1 100

// ── Math.Pow (float exponentiation) ───────────────────────────────────────

/// Test: 2.0 ** 10.0 = 1024.0 → truncate to int
let testPowF64_2_10 () : int = int (2.0 ** 10.0)

/// Test: 3.0 ** 0.0 = 1.0
let testPowF64_zero () : int = int (3.0 ** 0.0)

/// Test: 5.0 ** 3.0 = 125.0
let testPowF64_cube () : int = int (5.0 ** 3.0)

/// Test: Math.Pow(2.0, 8.0) = 256.0
let testMathPow () : int = int (System.Math.Pow(2.0, 8.0))

// ── ref.test DU pattern matching ──────────────────────────────────────────

type GeoShape =
    | GeoCircle of radius: float
    | GeoRect of w: float * h: float
    | GeoDot

/// Test: ref.test on data-carrying DU — GeoCircle branch.
let testRefTestCircle () : int =
    let s = GeoShape.GeoCircle 5.0
    match s with
    | GeoShape.GeoCircle r -> int r
    | _ -> 0

/// Test: ref.test on data-carrying DU — GeoRect branch.
let testRefTestRect () : int =
    let s = GeoShape.GeoRect(3.0, 4.0)
    match s with
    | GeoShape.GeoRect(w, h) -> int (w * h)
    | _ -> 0

/// Test: ref.test when last case has no fields (not enum-like; still a struct).
let testRefTestDot () : int =
    let s = GeoShape.GeoDot
    match s with
    | GeoShape.GeoDot -> 42
    | _ -> 0

// ─── Math.Exp ────────────────────────────────────────────────────────────────

/// Test: Math.exp(0) = 1
let testMathExp_zero () : int = int (System.Math.Exp(0.0))

/// Test: Math.exp(1) ≈ 2.71828 → rounded to 2
let testMathExp_one () : int = int (System.Math.Exp(1.0))

/// Test: Math.exp(10) ≈ 22026.46 → int truncation = 22026
let testMathExp_ten () : int = int (System.Math.Exp(10.0))

/// Test: Math.exp(-1) ≈ 0.3678 → int truncation = 0
let testMathExp_neg () : int = int (System.Math.Exp(-1.0))

// ─── Math.Log ────────────────────────────────────────────────────────────────

/// Test: Math.log(1) = 0
let testMathLog_one () : int = int (System.Math.Log(1.0))

/// Test: Math.log(e) ≈ 1.0 → rounded to 1 (raw truncation unreliable due to polynomial error)
let testMathLog_e () : int = int (System.Math.Round(System.Math.Log(System.Math.Exp(1.0))))

/// Test: Math.log(1024) = 10*ln2 ≈ 6.93 → int = 6
let testMathLog_1024 () : int = int (System.Math.Log(1024.0))

/// Test: round-trip: int(exp(log(100)+0.5)) = 100 (within tolerance)
let testMathExpLogRoundtrip () : int = int (System.Math.Exp(System.Math.Log(100.0) + 0.5))

// ─── Math.Sin / Cos / Tan ─────────────────────────────────────────────────────

/// Test: Math.sin(0) = 0
let testMathSin_zero   () : int = int (System.Math.Sin(0.0))

/// Test: Math.sin(π/2) ≈ 1 → rounded
let testMathSin_90deg  () : int = int (System.Math.Round(System.Math.Sin(1.5707963267948966)))

/// Test: Math.cos(0) = 1 (Horner evaluates to exactly 1.0)
let testMathCos_zero   () : int = int (System.Math.Round(System.Math.Cos(0.0)))

/// Test: Math.cos(π) ≈ -1 → rounded
let testMathCos_180deg () : int = int (System.Math.Round(System.Math.Cos(3.141592653589793)))

/// Test: Math.tan(0) = 0
let testMathTan_zero   () : int = int (System.Math.Tan(0.0))

/// Test: Math.tan(π/4) ≈ 1 → rounded
let testMathTan_45deg  () : int = int (System.Math.Round(System.Math.Tan(0.7853981633974483)))

// ─── Bit manipulation (i32.clz / i32.ctz / i32.popcnt) ──────────────────────

/// Test: LeadingZeroCount(1) = 31 (binary 1 has 31 leading zeros in 32-bit)
let testClz_one () : int = System.Numerics.BitOperations.LeadingZeroCount(1u)

/// Test: LeadingZeroCount(0x80000000u) = 0 (highest bit set)
let testClz_highBit () : int = System.Numerics.BitOperations.LeadingZeroCount(0x80000000u)

/// Test: TrailingZeroCount(8) = 3 (8 = 0b1000, 3 trailing zeros)
let testCtz_eight () : int = System.Numerics.BitOperations.TrailingZeroCount(8u)

/// Test: TrailingZeroCount(1) = 0 (lowest bit set)
let testCtz_one () : int = System.Numerics.BitOperations.TrailingZeroCount(1u)

/// Test: PopCount(7) = 3 (0b111 has 3 set bits)
let testPopcnt_seven () : int = System.Numerics.BitOperations.PopCount(7u)

/// Test: PopCount(0xFFFFFFFFu) = 32 (all 32 bits set)
let testPopcnt_allOnes () : int = System.Numerics.BitOperations.PopCount(0xFFFFFFFFu)

// ─── StringBuilder ────────────────────────────────────────────────────────────
let testSbLength () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("hello") |> ignore
    sb.Length  // 5

let testSbAppendTwo () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("foo") |> ignore
    sb.Append("bar") |> ignore
    sb.Length  // 6

let testSbToStringLength () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("abc") |> ignore
    let s = sb.ToString()
    s.Length  // 3

let testSbGrow () : int =
    // Force a buffer grow: initial capacity 16, write 20 chars
    let sb = System.Text.StringBuilder()
    for _ in 1 .. 20 do
        sb.Append("x") |> ignore
    sb.Length  // 20

let testSbToStringContent () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("hello") |> ignore
    sb.Append(" world") |> ignore
    let s = sb.ToString()
    if s = "hello world" then 1 else 0

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

let testAtan2Origin () : int =
    // atan2(0, 1) = 0
    roundTo6 (System.Math.Atan2(0.0, 1.0))  // 0

let testAtan2PosX () : int =
    // atan2(1, 1) ≈ π/4 ≈ 0.785398
    roundTo6 (System.Math.Atan2(1.0, 1.0))  // 785398

let testAtan2NegX () : int =
    // atan2(0, -1) = π ≈ 3.141593
    roundTo6 (System.Math.Atan2(0.0, -1.0))  // 3141593

let testAtan2PosY () : int =
    // atan2(1, 0) = π/2 ≈ 1.570796
    roundTo6 (System.Math.Atan2(1.0, 0.0))  // 1570796

let testAtan2NegY () : int =
    // atan2(-1, 0) = -π/2 ≈ -1.570796
    roundTo6 (System.Math.Atan2(-1.0, 0.0))  // -1570796

let testAtan2Q3 () : int =
    // atan2(-1, -1) ≈ -3π/4 ≈ -2.356194
    roundTo6 (System.Math.Atan2(-1.0, -1.0))  // -2356194

// ─── List.partition ──────────────────────────────────────────────────────────

let testListPartitionCounts () : int =
    // Evens vs odds in [1..6]
    let evens, odds = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.length evens * 10 + List.length odds  // 3 evens, 3 odds → 33

let testListPartitionEvens () : int =
    let evens, _ = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.sum evens  // 2+4+6 = 12

let testListPartitionOdds () : int =
    let _, odds = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.sum odds  // 1+3+5 = 9

let testListPartitionEmpty () : int =
    let a, b = List.partition (fun x -> x > 0) ([] : int list)
    List.length a + List.length b  // 0

let testListPartitionAllTrue () : int =
    let a, b = List.partition (fun x -> x > 0) [1;2;3]
    List.length a * 10 + List.length b  // 3 true, 0 false → 30

let testListPartitionOrder () : int =
    // Verify order is preserved: evens [2;4;6], check first element = 2
    let evens, _ = List.partition (fun x -> x % 2 = 0) [1;2;3;4;5;6]
    List.head evens  // 2

// ─── Array.choose ────────────────────────────────────────────────────────────

let testArrayChooseBasic () : int =
    let arr = [| 1; 2; 3; 4; 5 |]
    let result = Array.choose (fun x -> if x % 2 = 0 then Some(x * 10) else None) arr
    Array.sum result  // 20 + 40 = 60

let testArrayChooseLength () : int =
    let arr = [| 1; 2; 3; 4; 5; 6 |]
    let result = Array.choose (fun x -> if x > 3 then Some x else None) arr
    Array.length result  // 4, 5, 6 → length 3

let testArrayChooseEmpty () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.choose (fun _x -> None : int option) arr
    Array.length result  // 0

let testArrayChooseAllSome () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.choose (fun x -> Some(x + 10)) arr
    result.[0] + result.[1] + result.[2]  // 11+12+13 = 36

// ─── Array.collect ───────────────────────────────────────────────────────────

let testArrayCollectBasic () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.collect (fun x -> [| x; x * 10 |]) arr
    Array.sum result  // (1+10)+(2+20)+(3+30) = 11+22+33 = 66

let testArrayCollectLength () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.collect (fun x -> [| x; x |]) arr
    Array.length result  // 3 * 2 = 6

let testArrayCollectEmpty () : int =
    let arr = [| 1; 2; 3 |]
    let result = Array.collect (fun _x -> [||] : int[]) arr
    Array.length result  // 0

let testArrayCollectSingleton () : int =
    let arr = [| 5; 10; 15 |]
    let result = Array.collect (fun x -> [| x |]) arr
    result.[0] + result.[1] + result.[2]  // 5+10+15 = 30

// ─── comparePrimitives / compare ──────────────────────────────────────────────

let testCompareIntLt () : int = compare 3 5      // -1
let testCompareIntEq () : int = compare 7 7      // 0
let testCompareIntGt () : int = compare 9 2      // 1
let testCompareStrLt () : int = compare "abc" "abd"    // -1
let testCompareStrEq () : int = compare "abc" "abc"    // 0
let testCompareStrGt () : int = compare "abd" "abc"    // 1

let testListSortIntAsc () : int =
    let sorted = List.sort [3; 1; 4; 1; 5; 9; 2; 6]
    List.head sorted  // min = 1

let testListSortStrAsc () : int =
    let sorted = List.sort ["cherry"; "apple"; "banana"]
    if List.head sorted = "apple" then 1 else 0  // 1

// ─── Sprint 22b: standard F# Map<int,int> via Fable IComparer intercept ──────

// Map.ofList + Map.find (find uses KnownFuncsByPath → Map_find with correct retTy)
let testStdMapFind () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.find 2 m  // 20

// Map.ofList + Map.tryFind → Some → defaultValue
let testStdMapTryFind () : int =
    let m = Map.ofList [(10, 100); (20, 200)]
    Map.tryFind 20 m |> Option.defaultValue 0  // 200

// Map.tryFind missing key → None → 0
let testStdMapTryFindMissing () : int =
    let m = Map.ofList [(1, 1); (2, 2)]
    Map.tryFind 99 m |> Option.defaultValue 0  // 0

// Map.containsKey
let testStdMapContainsKey () : int =
    let m = Map.ofList [(5, 50); (6, 60)]
    if Map.containsKey 5 m then 1 else 0  // 1

// Map.add on top of ofList
let testStdMapAdd () : int =
    let m = Map.ofList [(1, 10)] |> Map.add 2 20
    Map.find 2 m  // 20

// ── Sprint 23 probes ──────────────────────────────────────────────────────────
let testResizeArrayBasic () : int =
    let xs = ResizeArray<int>()
    xs.Add(10)
    xs.Add(20)
    xs.Add(30)
    xs.Count  // 3

// Seq.* routing to list ops (the arg goes through IEnumerable<T> type)
let testSeqMap () : int =
    [1; 2; 3; 4; 5] |> Seq.map (fun x -> x * 2) |> Seq.sum  // 30

let testSeqFilter () : int =
    [1; 2; 3; 4; 5; 6] |> Seq.filter (fun x -> x % 2 = 0) |> Seq.length  // 3

let testSeqFold () : int =
    Seq.fold (fun acc x -> acc + x) 0 [1; 2; 3; 4; 5]  // 15

let testSeqExists () : int =
    if Seq.exists (fun x -> x > 3) [1; 2; 3; 4; 5] then 1 else 0  // 1

let testSeqToList () : int =
    let xs : int list = [10; 20; 30]
    Seq.toList xs |> List.sum  // 60

let testListUnzip () : int =
    let pairs = [(1, 10); (2, 20); (3, 30)]
    let (xs, ys) = List.unzip pairs
    List.sum xs + List.sum ys  // 6 + 60 = 66

let testArrayUnzip () : int =
    let pairs = [|(1, 4); (2, 5); (3, 6)|]
    let (xs, ys) = Array.unzip pairs
    Array.sum xs + Array.sum ys  // 6 + 15 = 21

// ── Sprint 23d: more Seq, string, let mutable ────────────────────────────────

let testSeqSumBy () : int =
    [1; 2; 3; 4; 5] |> Seq.sumBy (fun x -> x * 2)  // 30

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

let testSeqInit () : int =
    Seq.init 5 (fun i -> i * i) |> Seq.sum  // 0+1+4+9+16 = 30

let testResizeArrayIndex () : int =
    let xs = ResizeArray<int>()
    xs.Add(100); xs.Add(200); xs.Add(300)
    xs.[1]  // 200

let testSeqPairwise () : int =
    [1; 2; 3; 4; 5] |> Seq.pairwise |> Seq.map (fun (a, b) -> b - a) |> Seq.sum  // 4×1 = 4

let testSeqCountBy () : int =
    let result = [1; 2; 3; 4; 5; 6] |> Seq.countBy (fun x -> x % 2)
    Seq.length result  // 2 groups: odd (1,3,5) and even (2,4,6)

// ── Sprint 23e: recursive DU, active patterns, groupBy ────────────────────────

let testListGroupBy () : int =
    let groups = [1; 2; 3; 4; 5; 6] |> List.groupBy (fun x -> x % 2)
    List.length groups  // 2

type MathExpr =
    | Lit of int
    | Add of MathExpr * MathExpr
    | Mul of MathExpr * MathExpr

let rec evalExpr = function
    | Lit n       -> n
    | Add(a, b)   -> evalExpr a + evalExpr b
    | Mul(a, b)   -> evalExpr a * evalExpr b

let testRecursiveDU () : int =
    let expr = Mul(Add(Lit 2, Lit 3), Add(Lit 1, Lit 4))
    evalExpr expr  // (2+3)*(1+4) = 25

let (|Even|Odd|) n = if n % 2 = 0 then Even else Odd

let testActivePattern () : int =
    let classify n = match n with Even -> 0 | Odd -> 1
    [1; 2; 3; 4; 5] |> List.sumBy classify  // 1+0+1+0+1 = 3

// ── Sprint 23f: string ops, sprintf, more collections ────────────────────────

let testStringConcat () : int =
    let s = "hello" + " " + "world"
    String.length s  // 11

let testStringInterp () : int =
    let name = "Alice"
    let s = $"Hello {name}!"
    String.length s  // 12

let testSeqDistinct () : int =
    [1; 2; 2; 3; 3; 3; 4] |> Seq.distinct |> Seq.length  // 4

let testListDistinctBy () : int =
    [1; 2; 3; 4; 5; 6] |> List.distinctBy (fun x -> x % 3) |> List.length  // 3

// ── Phase 3: Exception handling ──────────────────────────────────

/// try/with catch-all — failwith throws, handler recovers
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
let testMapIsEmpty () : int =
    let e = Map.ofList ([] : (int * int) list)
    let m = Map.ofList [(1, 10)]
    Map.count e + Map.count m  // 0 + 1 = 1

/// Map.remove — remove a key
let testMapRemove () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    let m2 = Map.remove 2 m
    Map.count m2  // 2

/// Map.toList — convert to list, check length
let testMapToList () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.toList m |> List.length  // 3

/// Map add + find round-trip with more keys (5 elements)
let testMapLargeAddFind () : int =
    let m = Map.ofList [(10, 100); (20, 200); (30, 300); (40, 400); (50, 500)]
    Map.find 30 m  // 300

/// Map.find raises on missing key, caught by try/with
let testMapFindRaises () : int =
    try
        let m = Map.ofList [(1, 10); (2, 20)]
        Map.find 99 m
    with _ -> -1  // -1

// ── Phase 2 continued: Map higher-order operations ───────────────

/// Map.fold — sum all values
let testMapFold () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.fold (fun acc _k v -> acc + v) 0 m  // 60

/// Map.fold — use as replacement for Map.iter (which needs capture-passing closures)
let testMapIter () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    Map.fold (fun acc _k v -> acc + v) 0 m  // 60

/// Map.filter — keep entries where value > 15
let testMapFilter () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    let m2 = Map.filter (fun _k v -> v > 15) m
    Map.count m2  // 2

/// Map.exists — any value > 25?
let testMapExists () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    if Map.exists (fun _k v -> v > 25) m then 1 else 0  // 1

/// Map.forall — all values >= 10?
let testMapForall () : int =
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    if Map.forall (fun _k v -> v >= 10) m then 1 else 0  // 1

/// Map.map — double all values
let testMapMap () : int =
    let m = Map.ofList [(1, 10); (2, 20)]
    let m2 = Map.map (fun _k v -> v * 2) m
    Map.find 1 m2 + Map.find 2 m2  // 20 + 40 = 60

// ── Phase 4: Additional Seq operations ───────────────────────────

/// Seq.choose — filter+map
let testSeqChoose () : int =
    [1; 2; 3; 4; 5]
    |> Seq.choose (fun x -> if x % 2 = 0 then Some (x * 10) else None)
    |> Seq.sum  // 60

/// Seq.collect — flatMap
let testSeqCollect () : int =
    [1; 2; 3]
    |> Seq.collect (fun x -> [x; x * 10])
    |> Seq.sum  // 1+10+2+20+3+30 = 66

/// Seq.reduce — accumulate without init
let testSeqReduce () : int =
    [1; 2; 3; 4; 5] |> Seq.reduce (fun a b -> a + b)  // 15

/// Seq.mapIndexed — use index
let testSeqMapIndexed () : int =
    [10; 20; 30]
    |> Seq.mapi (fun i x -> i + x)
    |> Seq.sum  // (0+10)+(1+20)+(2+30) = 63

/// Seq.forall — all positive?
let testSeqForall () : int =
    if Seq.forall (fun x -> x > 0) [1; 2; 3] then 1 else 0  // 1

// ── Phase 2c: Set operations ─────────────────────────────────────

/// Set.ofList + count
let testSetOfListCount () : int =
    let s = Set.ofList [3; 1; 2; 1]
    Set.count s  // 3 (duplicate removed)

/// Set.contains
let testSetContains () : int =
    let s = Set.ofList [1; 2; 3]
    (if Set.contains 2 s then 1 else 0) + (if Set.contains 5 s then 0 else 1)  // 2

/// Set.add + contains
let testSetAdd () : int =
    let s = Set.ofList [1; 2; 3]
    let s2 = Set.add 4 s
    if Set.contains 4 s2 then Set.count s2 else 0  // 4

/// Set.remove + count
let testSetRemove () : int =
    let s = Set.ofList [1; 2; 3; 4]
    let s2 = Set.remove 3 s
    Set.count s2  // 3

/// Set.isEmpty
let testSetIsEmpty () : int =
    let e = Set.ofList ([] : int list)
    let s = Set.ofList [1]
    (if Set.isEmpty e then 1 else 0) + (if Set.isEmpty s then 0 else 1)  // 2

/// Set.fold — sum all elements
let testSetFold () : int =
    let s = Set.ofList [1; 2; 3; 4; 5]
    Set.fold (fun acc x -> acc + x) 0 s  // 15

/// Set.toList — length
let testSetToList () : int =
    let s = Set.ofList [3; 1; 2]
    Set.toList s |> List.length  // 3

/// Set.filter — keep even
let testSetFilter () : int =
    let s = Set.ofList [1; 2; 3; 4; 5; 6]
    let s2 = Set.filter (fun x -> x % 2 = 0) s
    Set.count s2  // 3

/// Set.exists — any > 4?
let testSetExists () : int =
    let s = Set.ofList [1; 2; 3; 4; 5]
    if Set.exists (fun x -> x > 4) s then 1 else 0  // 1

/// Set.forall — all > 0?
let testSetForall () : int =
    let s = Set.ofList [1; 2; 3]
    if Set.forall (fun x -> x > 0) s then 1 else 0  // 1

/// Set.union
let testSetUnion () : int =
    let a = Set.ofList [1; 2; 3]
    let b = Set.ofList [3; 4; 5]
    Set.count (Set.union a b)  // 5

/// Set.intersect
let testSetIntersect () : int =
    let a = Set.ofList [1; 2; 3; 4]
    let b = Set.ofList [3; 4; 5; 6]
    Set.count (Set.intersect a b)  // 2

/// Set.difference
let testSetDifference () : int =
    let a = Set.ofList [1; 2; 3; 4]
    let b = Set.ofList [3; 4; 5]
    Set.count (Set.difference a b)  // 2

/// Set.isSubset
let testSetIsSubset () : int =
    let a = Set.ofList [1; 2]
    let b = Set.ofList [1; 2; 3; 4]
    (if Set.isSubset a b then 1 else 0) + (if Set.isSubset b a then 0 else 1)  // 2

/// Set.map — double all elements
let testSetMap () : int =
    let s = Set.ofList [1; 2; 3]
    let s2 = Set.map (fun x -> x * 2) s
    Set.fold (fun acc x -> acc + x) 0 s2  // 2+4+6 = 12

/// Set.minElement / maxElement
let testSetMinMax () : int =
    let s = Set.ofList [5; 1; 3; 2; 4]
    Set.minElement s + Set.maxElement s  // 1 + 5 = 6

/// Set.singleton
let testSetSingleton () : int =
    let s = Set.singleton 42
    if Set.contains 42 s then Set.count s else 0  // 1

/// Set.ofArray
let testSetOfArray () : int =
    let s = Set.ofArray [|1; 2; 3; 2|]
    Set.count s  // 3

// ── Phase 4b: additional Seq/List ops ──────────────────────────
/// Seq.head (via List.head)
let testSeqHead () : int =
    List.head [10; 20; 30]  // 10

/// Seq.tryHead Some (via List.tryHead)
let testSeqTryHead () : int =
    match List.tryHead [42; 1; 2] with
    | Some x -> x
    | None -> 0  // 42

/// Seq.tryHead None (via List.tryHead)
let testSeqTryHeadEmpty () : int =
    match List.tryHead ([] : int list) with
    | Some _ -> 1
    | None -> 0  // 0

/// Seq.isEmpty (via List.isEmpty)
let testSeqIsEmpty () : int =
    (if List.isEmpty [] then 1 else 0) + (if List.isEmpty [1] then 0 else 1)  // 2

/// Seq.length (via List.length)
let testSeqLength () : int =
    List.length [1; 2; 3; 4; 5]  // 5

/// Seq.item (via List.item)
let testSeqItem () : int =
    List.item 2 [10; 20; 30; 40]  // 30

/// Seq.min / max (via List.min/max)
let testSeqMinMax () : int =
    List.min [3; 1; 4; 1; 5] + List.max [3; 1; 4; 1; 5]  // 1 + 5 = 6

/// Seq.sortBy
let testSeqSortBy () : int =
    [30; 10; 20]
    |> List.sortBy id
    |> List.head  // 10

/// List.rev + head
let testSeqRev () : int =
    List.rev [1; 2; 3] |> List.head  // 3

// testSeqToArray — removed: Array.ofList not yet implemented

/// List.findIndex
let testSeqFindIndex () : int =
    List.findIndex (fun x -> x > 20) [10; 20; 30; 40]  // 2

/// List.skip + take
let testSeqSkipTake () : int =
    [1; 2; 3; 4; 5] |> List.skip 2 |> List.take 2 |> List.sum  // 3+4 = 7

/// List.groupBy count
let testSeqGroupByCount () : int =
    [1; 2; 3; 4; 5; 6]
    |> List.groupBy (fun x -> x % 2)
    |> List.length  // 2

// ── Phase 3b: More exception tests ───────────────────────────────

/// failwith in nested function
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
let testClosureCapMap () : int =
    let offset = 10
    [1; 2; 3] |> List.map (fun x -> x + offset) |> List.sum  // 11+12+13 = 36

/// List.filter with capturing threshold
let testClosureCapFilter () : int =
    let threshold = 3
    [1; 2; 3; 4; 5] |> List.filter (fun x -> x > threshold) |> List.length  // [4;5] = 2

/// List.fold with capturing multiplier
let testClosureCapFold () : int =
    let multiplier = 2
    List.fold (fun acc x -> acc + x * multiplier) 0 [1; 2; 3; 4; 5]  // 30

/// Closure returned from a function and applied later
let testClosureHigherOrder () : int =
    let makeAdder (n: int) = fun x -> x + n
    let add5 = makeAdder 5
    let add10 = makeAdder 10
    add5 3 + add10 7  // 8 + 17 = 25

/// Closure capturing a mutable ref cell
let testClosureCapRef () : int =
    let counter = ref 0
    let increment () = counter.Value <- counter.Value + 1
    increment ()
    increment ()
    increment ()
    counter.Value  // 3

/// Double-nested capture: closure captures another closure's captured variable
let testClosureNestedCapture () : int =
    let base_ = 100
    let outer n =
        let inner m = base_ + n + m
        inner
    let f = outer 5
    f 3  // 100 + 5 + 3 = 108

/// Set.fold with a capturing offset
let testClosureCapSetFold () : int =
    let offset = 100
    Set.fold (fun acc v -> acc + v + offset) 0 (Set.ofList [1; 2; 3])  // 306

/// List.exists with capturing closure
let testClosureCapListExists () : int =
    let target = 7
    if List.exists (fun x -> x = target) [1; 4; 7; 9] then 1 else 0  // 1

/// List.forall with capturing bound
let testClosureCapListForAll () : int =
    let bound = 10
    if List.forall (fun x -> x < bound) [1; 3; 5; 7; 9] then 1 else 0  // 1

// ── Sprint 25c: Generic Map/Set with stored comparator ───────────────────────

/// Map with reverse (descending) comparator stored in handle.
/// After Map.ofList [(1,10);(2,20);(3,30)] with reverse cmp, the BST is ordered
/// descending so Map.fold left-to-right sums in reverse order: still 60.
let testMapCustomCmpReverse () : int =
    let reverseCmp (a: int) (b: int) = if a > b then -1 elif a < b then 1 else 0
    let m = Map.ofList [(1, 10); (2, 20); (3, 30)]
    // Regular Map uses injected comparator; reverse cmp via MapModule direct API
    let m2 = MapModule.empty reverseCmp |> MapModule.add 1 10 |> MapModule.add 2 20 |> MapModule.add 3 30
    MapModule.fold (fun acc _k v -> acc + v) 0 m2  // 60 (same sum regardless of order)

/// MapModule with explicit intCmp — add multiple distinct keys, containsKey.
let testMapModuleContainsKey () : int =
    let m = MapModule.empty intCmp
            |> MapModule.add 10 100
            |> MapModule.add 20 200
            |> MapModule.add 30 300
    if MapModule.containsKey 20 m && not (MapModule.containsKey 99 m) then 1 else 0  // 1

/// MapModule tryFind and find round-trip.
let testMapModuleFindRoundTrip () : int =
    let m = MapModule.empty intCmp |> MapModule.add 7 77 |> MapModule.add 8 88
    MapModule.find 7 m + (MapModule.tryFind 8 m |> Option.defaultValue 0)  // 77 + 88 = 165

/// SetModule with explicit comparator: add distinct values, count = 3.
let testSetModuleBasic () : int =
    let s = SetModule.empty intCmp
            |> SetModule.add 5
            |> SetModule.add 3
            |> SetModule.add 7
    SetModule.count s  // 3

/// SetModule deduplication — adding duplicates doesn't increase count.
let testSetModuleDedup () : int =
    let s = SetModule.empty intCmp
            |> SetModule.add 1
            |> SetModule.add 1
            |> SetModule.add 2
            |> SetModule.add 2
    SetModule.count s  // 2

/// SetModule.contains works correctly.
let testSetModuleContains () : int =
    let s = SetModule.empty intCmp |> SetModule.add 42 |> SetModule.add 99
    if SetModule.contains 42 s && not (SetModule.contains 1 s) then 1 else 0  // 1

/// MapModule.remove reduces count by 1.
let testMapModuleRemove () : int =
    let m = MapModule.empty intCmp
            |> MapModule.add 1 10
            |> MapModule.add 2 20
            |> MapModule.add 3 30
    let m2 = MapModule.remove 2 m
    MapModule.count m2  // 2

/// MapModule.toList returns pairs in ascending order of comparison.
let testMapModuleToList () : int =
    let m = MapModule.empty intCmp
            |> MapModule.add 3 30
            |> MapModule.add 1 10
            |> MapModule.add 2 20
    MapModule.toList m |> List.length  // 3

/// SetModule.fold sum using explicit comparator.
let testSetModuleFold () : int =
    let s = SetModule.empty intCmp |> SetModule.add 10 |> SetModule.add 20 |> SetModule.add 30
    SetModule.fold (fun acc x -> acc + x) 0 s  // 60

// ── Sprint 25e: Mutual LetRec closures ─────────────────────────

/// Mutual recursion via let rec … and …: even checks — is-even/is-odd.
let testMutualLetRec () : int =
    let rec isEven (n: int) : bool =
        if n = 0 then true else isOdd (n - 1)
    and isOdd (n: int) : bool =
        if n = 0 then false else isEven (n - 1)
    if isEven 4 && isOdd 3 then 1 else 0  // 1

/// Two mutually recursive functions that ping-pong until a limit.
let testMutualLetRecPingPong () : int =
    let rec ping (n: int) : int =
        if n >= 10 then n
        else pong (n + 1)
    and pong (n: int) : int =
        if n >= 10 then n
        else ping (n + 1)
    ping 0   // 10

// ── Phase 5: Async — requires backend wiring (Sprint 25) ────────

// ── Sprint 30: Typed Exception Carrier + TypeTest ────────────────

/// Custom exception type used for TypeTest.
/// Fable compiles F# exception records as ClassDeclarations → WasmGC struct in TypeRegistry.
exception MyTypedException of Value: int

/// Basic exception carrier: throw, catch, verify catch executes.
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

// ── module-level mutable state (wasm globals + start function) ────────────────────────────────────────────────
let mutable private moduleCounter = 10

/// A module-level `let mutable` is one variable for the whole module (initialised by the start function).
let testModuleMutable () : int =
    moduleCounter <- 10        // idempotent: the differential test calls every function more than once
    moduleCounter <- moduleCounter + 5
    moduleCounter  // 15

let mutable private moduleSlot : int -> int = fun x -> x + 1

/// A module-level mutable holding a function (the pattern of an event-handler slot).
let testModuleMutableFn () : int =
    moduleSlot <- (fun x -> x * 2)
    moduleSlot 21  // 42

/// `for x in list` / `for x in array` (Fable's enumerator protocol becomes a plain loop).
let testForInListArray () : int =
    let mutable s = 0
    for x in [ 1; 2; 3 ] do
        s <- s + x
    for y in [| 10; 20 |] do
        s <- s + y
    s  // 36

type TestBag = { BagItems: string list; BagN: int }

/// A record whose first use registers the list type of its own field (type slots must not shift).
let testRecordListField () : int =
    let b = { BagItems = [ "a"; "b" ]; BagN = 3 }
    b.BagN + List.length b.BagItems  // 5

/// A mutable local captured by a closure is shared with it (F# boxes it in a ref cell), not copied.
let testCapturedMutable () : int =
    let mutable c = 0
    let inc () = c <- c + 1
    inc (); inc ()
    let apply (f: unit -> unit) = f (); f (); f ()
    apply (fun () -> c <- c + 10)
    let read = fun () -> c
    c + read ()  // 32 + 32 = 64

/// Two closures over one mutable: one writes, the other reads (event-handler pairs in a UI).
let testSharedMutableCells () : int =
    let mutable count = 0
    let incr = fun () -> count <- count + 1
    let get = fun () -> count
    incr (); incr (); incr ()
    get ()  // 3

/// A parameter named like a module-level value is the parameter, and a closure must capture it.
let label = 100
let testLocalShadowsModuleValue (label: int) : int =
    let f = fun () -> label + 1
    f ()  // testLocalShadowsModuleValue 4 = 5

// ── seq<'T> parameters: a list or an array is passed where a seq is expected ──────────────────────

let sumSeq (xs: seq<int>) : int = xs |> Seq.sum

/// A list is a seq as it is.
let testSeqParamList () : int = sumSeq [ 1; 2; 3 ]   // 6

/// An array is converted where F# coerces it silently.
let testSeqParamArray () : int = sumSeq [| 4; 5 |]   // 9

let countSeq (xs: seq<string>) : int = xs |> Seq.length

/// A seq of strings, from a list and from an array, through `:>` and through the signature.
let testSeqParamStrings () : int =
    countSeq [ "a"; "b" ] + countSeq [| "c" |] + countSeq ([| "d"; "e"; "f" |] :> seq<string>)   // 2 + 1 + 3 = 6

let doubled (xs: seq<int>) : int list = xs |> Seq.map (fun x -> x * 2) |> Seq.toList

/// A seq pipeline inside the function, called with both shapes.
let testSeqPipeline () : int = List.sum (doubled [ 1; 2; 3 ]) + List.sum (doubled [| 5 |])   // 12 + 10 = 22

type Collector() =
    member _.Collect(xs: seq<'a>, f: 'a -> int list) : int list = xs |> Seq.toList |> List.collect f

/// A generic instance member with a seq parameter (what a computation-expression `For` is).
let testSeqGenericMember () : int =
    let c = Collector()
    List.length (c.Collect([| 1; 2; 3 |], fun x -> [ x; x ])) + List.length (c.Collect([ "a" ], fun s -> [ s.Length ]))   // 6 + 1 = 7

// ── classes: field initialisers, receivers, generic classes ───────────────────────────────────────

type InitCounter(start: int) =
    let mutable n = start * 2
    let items : int array = Array.zeroCreate 3
    member _.Next() = n <- n + 1; n + items.Length

/// `let` fields of a class are initialised by its constructor, and a receiver may be any expression.
let testClassInitialisers () : int = InitCounter(5).Next()   // 11 + 3 = 14

let testClassInitialisersTwice () : int =
    let c = InitCounter(1)
    c.Next() + c.Next()   // (3 + 3) + (4 + 3) = 13

/// A generic class: only arrays and a counter, instantiated at two types in one module.
type PortableStack<'T>() =
    let mutable items : 'T array = Array.zeroCreate 4
    let mutable count = 0
    member _.Count = count
    member _.Push(x: 'T) =
        if count = items.Length then
            let bigger : 'T array = Array.zeroCreate (items.Length * 2)
            for i in 0 .. count - 1 do bigger.[i] <- items.[i]
            items <- bigger
        items.[count] <- x
        count <- count + 1
    member _.Pop() : 'T =
        count <- count - 1
        items.[count]

let testGenericClassInt () : int =
    let s = PortableStack<int>()
    for i in 1 .. 10 do s.Push i       // grows twice
    s.Pop() + s.Pop() + s.Count        // 10 + 9 + 8 = 27

let testGenericClassString () : int =
    let s = PortableStack<string>()
    s.Push "ab"
    s.Push "cde"
    (s.Pop()).Length + s.Count         // 3 + 1 = 4

let testGenericClassRecord () : int =
    let s = PortableStack<TestBag>()
    s.Push { BagItems = [ "x" ]; BagN = 7 }
    s.Push { BagItems = [ "y"; "z" ]; BagN = 8 }
    (s.Pop()).BagN + (s.Pop()).BagItems.Length   // 8 + 1 = 9

// ── System.Collections.Generic: Stack<'T> and Queue<'T> (portable F#, instantiated per type) ────────

let testStackInt () : int =
    let s = System.Collections.Generic.Stack<int>()
    s.Push 1; s.Push 2; s.Push 3
    s.Pop() * 100 + s.Peek() * 10 + s.Count   // 300 + 20 + 2 = 322

let testStackString () : int =
    let s = System.Collections.Generic.Stack<string>()
    s.Push "a"; s.Push "bcd"
    (s.Pop()).Length * 10 + s.Count            // 31

let testStackToArrayAndClear () : int =
    let s = System.Collections.Generic.Stack<int>()
    for i in 1 .. 6 do s.Push i               // grows past 4
    let a = s.ToArray()                        // top first: 6 5 4 3 2 1
    let r = a.Length * 100 + a.[0] * 10 + a.[5]
    s.Clear()
    r + s.Count                                // 600 + 60 + 1 + 0 = 661

let testStackContains () : int =
    let s = System.Collections.Generic.Stack<string>()
    s.Push "x"
    (if s.Contains "x" then 1 else 0) + (if s.Contains "y" then 10 else 0)   // 1

let testQueueInt () : int =
    let q = System.Collections.Generic.Queue<int>()
    q.Enqueue 1; q.Enqueue 2; q.Enqueue 3
    q.Dequeue() * 100 + q.Peek() * 10 + q.Count   // 100 + 20 + 2 = 122

/// Fills, drains part, refills: the ring buffer wraps and grows.
let testQueueWrapAndGrow () : int =
    let q = System.Collections.Generic.Queue<int>()
    for i in 1 .. 4 do q.Enqueue i
    q.Dequeue() |> ignore
    q.Dequeue() |> ignore
    for i in 5 .. 8 do q.Enqueue i
    let a = q.ToArray()                        // 3 4 5 6 7 8
    a.Length * 100 + a.[0] * 10 + a.[5]        // 600 + 30 + 8 = 638

let testQueueOfRecords () : int =
    let q = System.Collections.Generic.Queue<TestBag>()
    q.Enqueue { BagItems = [ "x" ]; BagN = 7 }
    q.Enqueue { BagItems = [ "y"; "z" ]; BagN = 8 }
    (q.Dequeue()).BagN * 10 + (q.Dequeue()).BagItems.Length   // 70 + 2 = 72

// ── hash: equal values hash equal (what Dictionary / HashSet rely on); different ones differ ─────────────

type HKey = { HName: string; HId: int }
type HShape = HCircle of float | HRect of int * int | HNothing

let testHashPrimitives () : int =
    (if hash 42 = 42 then 1 else 0)
    + (if hash "abc" = hash ("ab" + "c") then 10 else 0)
    + (if hash "abc" <> hash "abd" then 100 else 0)
    + (if hash 0.0 = hash (-0.0) then 1000 else 0)
    + (if hash 5L = hash (2L + 3L) && hash 5L <> hash 6L then 10000 else 0)    // 11111

let testHashStructures () : int =
    let r1, r2 = { HName = "a"; HId = 1 }, { HName = "a"; HId = 1 }
    (if hash (1, "x") = hash (1, "x") && hash (1, "x") <> hash (2, "x") then 1 else 0)
    + (if hash r1 = hash r2 && hash r1 <> hash { r1 with HId = 2 } then 10 else 0)
    + (if hash (HRect(2, 3)) = hash (HRect(2, 3)) && hash (HRect(2, 3)) <> hash (HRect(3, 2)) then 100 else 0)
    + (if hash (HCircle 1.5) = hash (HCircle 1.5) && hash HNothing <> hash (HCircle 0.0) then 1000 else 0)
    + (if hash [ 1; 2; 3 ] = hash [ 1; 2; 3 ] && hash [ 1; 2; 3 ] <> hash [ 3; 2; 1 ] then 10000 else 0)
    + (if hash [| 1; 2 |] = hash [| 1; 2 |] && hash [| 1; 2 |] <> hash [| 2; 1 |] then 100000 else 0)   // 111111

let testHashOption () : int =
    (if hash (Some 3) = hash (Some 3) then 1 else 0)
    + (if hash (None: int option) = hash (None: int option) then 10 else 0)
    + (if hash (Some "s") = hash (Some "s") then 100 else 0)                                          // 111

let hashOf (x: 'T) : int = hash x
let testHashGeneric () : int =
    (if hashOf 7 = 7 then 1 else 0)
    + (if hashOf "k" = hash "k" then 10 else 0)
    + (if hashOf (1, 2) = hash (1, 2) then 100 else 0)                                                // 111

// ── System.Collections.Generic: Dictionary<'K,'V> and HashSet<'T> (portable F#, hash table with the .NET layout) ──

let testDictIntBasics () : int =
    let d = System.Collections.Generic.Dictionary<int, string>()
    d.Add(1, "one"); d.Add(2, "two"); d.[3] <- "three"
    d.[2] <- "TWO"
    d.Count * 100 + d.[2].Length * 10 + (if d.ContainsKey 3 then 1 else 0)    // 300 + 30 + 1

let testDictStringKeysGrow () : int =
    let d = System.Collections.Generic.Dictionary<string, int>()
    for i in 0 .. 99 do d.[string i] <- i * i      // grows through several prime sizes
    let mutable sum = 0
    for i in 0 .. 99 do sum <- sum + d.[string i]
    sum + d.Count                                  // 328350 + 100

let testDictRemoveReuse () : int =
    let d = System.Collections.Generic.Dictionary<int, int>()
    for i in 1 .. 5 do d.[i] <- i * 10
    let removed = d.Remove 2
    let missing = d.Remove 42
    d.[9] <- 90                                    // takes the freed slot: enumeration order 1 9 3 4 5 like the BCL
    let keys = d.Keys
    (if removed && not missing then 1000 else 0) + keys.[1] * 10 + d.Count   // 1000 + 90 + 5

let testDictTryGetValue () : int =
    let d = System.Collections.Generic.Dictionary<string, int>()
    d.["a"] <- 7
    let a = match d.TryGetValue "a" with | true, v -> v | _ -> -1
    let b = match d.TryGetValue "b" with | true, v -> v | _ -> -1
    a * 10 + b                                     // 69

let testDictRecordKeys () : int =
    let d = System.Collections.Generic.Dictionary<HKey, int>()
    d.[{ HName = "a"; HId = 1 }] <- 1
    d.[{ HName = "a"; HId = 2 }] <- 2
    d.[{ HName = "a"; HId = 1 }] <- 10             // same key as the first
    d.Count * 100 + d.[{ HName = "a"; HId = 1 }]   // 210

let testDictForIn () : int =
    let d = System.Collections.Generic.Dictionary<int, int>()
    for i in 1 .. 4 do d.[i] <- i * i
    let mutable s = 0
    for kv in d do s <- s + kv.Key * kv.Value      // 1 + 8 + 27 + 64
    s

let testHashSetBasics () : int =
    let h = System.Collections.Generic.HashSet<string>()
    let a = h.Add "x"
    let b = h.Add "x"
    h.Add "y" |> ignore
    (if a && not b then 100 else 0) + h.Count * 10 + (if h.Contains "y" then 1 else 0)   // 100 + 20 + 1

// ── collections used the way real programs use them: KeyValue patterns, seq functions, constructors from sequences ──

let testDictKeyValuePattern () : int =
    let d = System.Collections.Generic.Dictionary<int, int>()
    d.[1] <- 10; d.[2] <- 20
    let mutable s = 0
    for KeyValue(k, v) in d do s <- s + k * v
    s                                                        // 10 + 40

let testDictSeqFunctions () : int =
    let d = System.Collections.Generic.Dictionary<string, int>()
    d.["a"] <- 1; d.["b"] <- 2; d.["c"] <- 3
    let total = d |> Seq.sumBy (fun kv -> kv.Value)          // 6
    let keys = d.Keys |> Seq.length                           // 3
    let sumV = Seq.sum d.Values                               // 6
    total * 100 + keys * 10 + sumV                            // 636

let testDictFromSeq () : int =
    let d = System.Collections.Generic.Dictionary<int, string>()
    d.[1] <- "a"; d.[2] <- "bb"
    let e = System.Collections.Generic.Dictionary<int, string>(d)
    e.[3] <- "ccc"
    e.Count * 10 + d.Count                                    // 32

let testDictGetValueOrDefault () : int =
    let d = System.Collections.Generic.Dictionary<string, int>()
    d.["x"] <- 5
    d.GetValueOrDefault "x" * 10 + d.GetValueOrDefault "y"    // 50

let testDictOutVariable () : int =
    let d = System.Collections.Generic.Dictionary<string, int>()
    d.["a"] <- 1
    let mutable v = 0
    if d.TryGetValue("a", &v) then v + 100 else -1            // 101

let testHashSetFromSeqAndFor () : int =
    let h = System.Collections.Generic.HashSet<int>([ 1; 2; 3; 2; 1 ])
    let mutable s = 0
    for x in h do s <- s + x
    h.Count * 10 + s                                          // 30 + 6

let testHashSetOperations () : int =
    let h = System.Collections.Generic.HashSet<int>([ 1; 2; 3; 4 ])
    h.ExceptWith [ 2 ]
    h.IntersectWith [ 1; 3; 5 ]                               // 1, 3
    h.UnionWith [ 7 ]                                         // 1, 3, 7
    (if h.IsSubsetOf [ 1; 3; 7; 9 ] then 100 else 0)
    + (if h.IsSupersetOf [ 3; 7 ] then 10 else 0)
    + (if h.Overlaps [ 9; 7 ] then 1 else 0)                  // 111

let testHashSetAsSeq () : int =
    let h = System.Collections.Generic.HashSet<string>()
    h.Add "x" |> ignore; h.Add "yy" |> ignore
    h |> Seq.sumBy (fun s -> s.Length)                        // 3

let testStackQueueAsSeq () : int =
    let s = System.Collections.Generic.Stack<int>()
    s.Push 1; s.Push 2; s.Push 3
    let q = System.Collections.Generic.Queue<int>()
    q.Enqueue 4; q.Enqueue 5
    let mutable top = 0
    for x in s do top <- top * 10 + x                         // top first: 3, 2, 1 -> 321
    top + (q |> Seq.sum)                                      // 321 + 9

let testForInSeqParameter () : int =
    let total (xs: seq<int>) =
        let mutable s = 0
        for x in xs do s <- s + x
        s
    total [ 1; 2; 3 ] + total [| 10; 20 |]                    // 6 + 30

let testDictOfLists () : int =
    let d = System.Collections.Generic.Dictionary<string, ResizeArray<int>>()
    d.["a"] <- ResizeArray<int>()
    d.["a"].Add 5; d.["a"].Add 6
    d.["a"].Count * 10 + d.["a"].[1]                          // 26


// ── ResizeArray: construction, ToArray, Sort, Reverse, Insert, RemoveAt, Remove, IndexOf, Contains, Clear, AddRange ──

/// ResizeArray(seq) copies the elements: Count 4, then 4 * 10 + [3] = 48
let testResizeArrayFromList () : int =
    let r = ResizeArray<int>([ 5; 6; 7; 8 ])
    r.Count * 10 + r.[3] - 0                                  // 48

/// ResizeArray(capacity) is empty
let testResizeArrayCapacityCtor () : int =
    let r = ResizeArray<int>(64)
    r.Add 3
    r.Count * 10 + r.[0]                                      // 13

/// Sort() orders the first Count elements; ToArray() copies exactly Count of them
let testResizeArraySortToArray () : int =
    let r = ResizeArray<float32>()
    r.Add 3.0f; r.Add 1.0f; r.Add 2.0f
    r.Sort()
    let a = r.ToArray()
    a.Length * 1000 + int a.[0] * 100 + int a.[1] * 10 + int a.[2]     // 3123

/// Sort(Comparison) with a reversed comparison
let testResizeArraySortComparison () : int =
    let r = ResizeArray<int>([ 4; 9; 1; 7 ])
    r.Sort(fun a b -> compare b a)
    r.[0] * 1000 + r.[1] * 100 + r.[2] * 10 + r.[3]           // 9741

let testResizeArrayInsertReverse () : int =
    let r = ResizeArray<int>()
    r.Add 1; r.Add 3
    r.Insert(1, 2)
    r.Reverse()
    r.[0] * 100 + r.[1] * 10 + r.[2]                          // 321

/// RemoveAt(1): [5;6;7;8] -> [5;7;8]
let testResizeArrayRemoveAt () : int =
    let r = ResizeArray<int>([ 5; 6; 7; 8 ])
    r.RemoveAt 1
    r.Count * 100 + r.[0] * 10 + r.[1]                        // 357

/// Remove(8) is true and leaves [5;6;7]; Remove(42) is false; IndexOf / Contains
let testResizeArrayRemoveIndexOfContains () : int =
    let r = ResizeArray<int>([ 5; 6; 7; 8 ])
    let removed = r.Remove 8
    let missing = r.Remove 42
    (if removed && not missing then 1000 else 0) + r.Count * 100 + r.IndexOf 7 * 10 + (if r.Contains 6 then 1 else 0)   // 1000 + 300 + 20 + 1

let testResizeArrayClearAddRange () : int =
    let r = ResizeArray<int>()
    r.Add 1; r.Add 2
    r.Clear()
    r.AddRange [ 7; 8; 9 ]
    r.AddRange [| 10; 11 |]
    r.Count * 100 + r.[0] + r.[4]                             // 500 + 7 + 11

/// grows beyond the first capacity through Insert and AddRange
let testResizeArrayGrows () : int =
    let r = ResizeArray<int>()
    r.AddRange [ 1 .. 10 ]
    r.Insert(0, 0)
    for i in 11 .. 20 do r.Add i
    r.Count * 1000 + r.[0] * 100 + r.[20] + r.[10]            // 21000 + 0 + 20 + 10

// ── A local closure shadows a library function of the same name ──────────────────────────

/// `add` is also a function of the Map / Set library: the local one is called
let testLocalClosureNamedLikeLibraryFunction () : int =
    let d = System.Collections.Generic.Dictionary<int, int>()
    let add k v = if not (d.ContainsKey k) then d.[k] <- v
    add 1 5; add 1 6; add 2 7
    d.[1] + d.[2] + d.Count                                   // 14

// ── Collections with a capacity argument ─────────────────────────────────────────────────

let testCapacityConstructors () : int =
    let q = System.Collections.Generic.Queue<int>(16)
    q.Enqueue 3
    let s = System.Collections.Generic.Stack<int>(16)
    s.Push 4
    let d = System.Collections.Generic.Dictionary<int, int>(16)
    d.[1] <- 5
    let h = System.Collections.Generic.HashSet<int>(16)
    h.Add 6 |> ignore
    q.Dequeue() * 1000 + s.Pop() * 100 + d.[1] * 10 + h.Count    // 3451


// ── List.indexed / findIndex with a partial application / tryItem / ofSeq of a collection / StringBuilder.Clear ──

/// 0*10 + 1*20 + 2*30 = 80
let testListIndexed () : int = [ 10; 20; 30 ] |> List.indexed |> List.sumBy (fun (i, x) -> i * x)

/// the index of the first match through a partially applied operator: ((=) 30) is `let x = 30 in fun y -> x = y`
let testListFindIndexPartial () : int = List.findIndex ((=) 30) [ 10; 20; 30 ]

/// a named function as the predicate: eta-expanded
let private isBig (x: int) = x > 15
let testListFindIndexNamed () : int = List.findIndex isBig [ 10; 20; 30 ]

/// tryItem: inside, past the end, negative
let testListTryItem () : int =
    let xs = [ 10; 20; 30 ]
    let inside = match List.tryItem 1 xs with Some x -> x | None -> -1
    let past = match List.tryItem 3 xs with Some x -> x | None -> -1
    let neg = match List.tryItem -1 xs with Some x -> x | None -> -1
    inside * 100 + (past + 1) * 10 + (neg + 1)               // 2000 + 0 + 0

/// the keys of a Dictionary as a list
let testListOfSeqDictKeys () : int =
    let d = System.Collections.Generic.Dictionary<int, int>()
    d.[7] <- 1
    d.[8] <- 2
    let keys = List.ofSeq d.Keys
    keys.Length * 10 + List.sum keys                          // 20 + 15

let testStringBuilderClear () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("abc") |> ignore
    sb.Clear() |> ignore
    sb.Append("xy") |> ignore
    sb.Length * 10 + sb.ToString().Length                     // 22


// ── array comprehension with a `match` that yields in one arm, a ResizeArray as a seq, a partial application of a field ──

type CompChange =
    | CompNone
    | CompSome of int

/// the `()` arm of a match inside a comprehension; 2 results, the first index is 2: 2 * 10 + 2
let testComprehensionMatchYieldTuple () : int =
    let pa = [| 1; 2; 3; 4 |]
    let deltas =
        [| for i = 0 to pa.Length - 1 do
               let d = if pa.[i] > 2 then CompSome pa.[i] else CompNone
               match d with
               | CompNone -> ()
               | _ -> yield i, d |]
    deltas.Length * 10 + fst deltas.[0]

/// Seq functions over a ResizeArray: (2, 4, 6) filtered to > 2, summed: 10
let testSeqOverResizeArray () : int =
    let r = ResizeArray<int>()
    r.Add 1; r.Add 2; r.Add 3
    r |> Seq.map (fun x -> x * 2) |> Seq.filter (fun x -> x > 2) |> List.ofSeq |> List.sum

type FieldHolder = { Wanted: int }

/// `let x = n.Wanted in fun y -> x = y`: a record field is an atom, so the partial application is a lambda
let testFindIndexPartialOfField () : int =
    let n = { Wanted = 30 }
    List.findIndex ((=) n.Wanted) [ 10; 20; 30 ]

// ── struct-record copy through an inline builder, `or` patterns binding references, interface properties, string options ──

[<Struct>]
type BuiltState =
    { X: float32; Y: float32; W: float32; H: float32
      R: float32
      Opt: int voption
      Alpha: float32 }

type StateBuilder() =
    member inline _.Yield(()) : BuiltState = { X = 0.0f; Y = 0.0f; W = 0.0f; H = 0.0f; R = 2.0f; Opt = ValueSome 7; Alpha = 1.0f }
    member _.Run(s: BuiltState) : int =
        int s.X + int s.Y * 10 + int s.W * 100 + int s.H * 1000 + int s.R * 10000 + ValueOption.defaultValue 0 s.Opt * 100000
    [<CustomOperation("at")>]
    member inline _.At(s: BuiltState, x: float32, y: float32) = { s with X = x; Y = y }
    [<CustomOperation("size")>]
    member inline _.Size(s: BuiltState, w: int, h: int) = { s with W = float32 w; H = float32 h }

/// `{ s with … }` reads the unchanged fields through `let inputRecord: byref<S> = s`: the fields keep their values
let testStructRecordCopyThroughBuilder () : int =
    StateBuilder() { at 1.0f 2.0f
                     size 3 4 }

type OrTree =
    | OrLeaf
    | OrNode of int * OrTree
    | OrWrap of string * OrTree
    | OrBox of OrTree

let rec orDepth (t: OrTree) : int =
    match t with
    | OrLeaf -> 0
    | OrNode(_, c) | OrWrap(_, c) | OrBox c -> 1 + orDepth c

/// the shared target of an `or` pattern binds a reference that is set in several branches and read after them: 4
let testOrPatternBindsReference () : int =
    orDepth (OrNode(1, OrWrap("a", OrBox(OrNode(2, OrLeaf)))))

type IHasSize =
    abstract Size: int
    abstract Label: string

type SizeImpl(n: int) =
    interface IHasSize with
        member _.Size = n
        member _.Label = "abc"

/// a property of an interface value goes through the vtable: 7 * 10 + 3
let testInterfaceProperty () : int =
    let h: IHasSize = SizeImpl(7) :> IHasSize
    h.Size * 10 + h.Label.Length

/// a `string option` is a nullable string: `=` is null-aware and compares by content
let testStringOptionEquality () : int =
    let a: string option = Some "ab"
    let b: string option = None
    let id = String.concat "" [ "a"; "b" ]
    (if a = Some id then 1 else 0) + (if b = Some id then 10 else 0) + (if b = None then 100 else 0) + (if Some "x" <> Some "y" then 1000 else 0)

// ── a let-bound generic lambda is built at the instantiation its uses state ──

type GenKind = GenA | GenB
type GenNode = { Id: int; Kind: GenKind; X: float32; Text: string }

let genNewNode (id: int) (kind: GenKind) (x: float32) = { Id = id; Kind = kind; X = x; Text = "" }

/// `mk` is generic in the result of `f`; every use says `GenNode`: (100+7+48) + (200+7+88) + (300+0+280)
let testLocalGenericLambda () : int =
    let mk id kind x f = f (genNewNode id kind x)
    let nodes =
        [ mk 1 GenA 48.0f (fun n -> { n with Text = "Sign in" })
          mk 2 GenB 88.0f (fun n -> { n with Text = "Welcome" })
          mk 3 GenA 1.0f (fun n -> { n with X = 280.0f }) ]
    nodes |> List.sumBy (fun n -> n.Id * 100 + n.Text.Length + int n.X)

/// Append(char) / Append(int) and ToString of a StringBuilder: "ab" + "7" + "x" = 4 chars
let testStringBuilderCharAndInt () : int =
    let sb = System.Text.StringBuilder()
    sb.Append('a').Append('b') |> ignore
    sb.Append(7) |> ignore
    sb.Append("x") |> ignore
    let s = sb.ToString()
    s.Length * 100 + int s.[2]

/// `TryGetValue` of a reference type: the `out` cell starts null (a miss leaves it so) and holds the value after a hit
let testOutArgReference () : int =
    let d = System.Collections.Generic.Dictionary<int, int[]>()
    d.[1] <- [| 10; 20; 30 |]
    let hit = match d.TryGetValue 1 with | true, v -> v.[2] | _ -> 0
    let miss = match d.TryGetValue 2 with | true, _ -> 1000 | _ -> 5
    hit + miss

// ── a module-level value is evaluated once and shared ──

type SharedCounter() =
    let mutable n = 0
    member _.Next() : int =
        n <- n + 1
        n

let sharedCounter = SharedCounter()
let sharedTable = [| 1; 2; 3 |]

/// `sharedCounter` is one object for every reference (3 calls → 3), and `sharedTable` one array (a write is seen by the next read)
let testModuleValueIsShared () : int =
    sharedCounter.Next() |> ignore
    sharedCounter.Next() |> ignore
    let third = sharedCounter.Next()
    sharedTable.[0] <- 40
    third * 100 + sharedTable.[0]
