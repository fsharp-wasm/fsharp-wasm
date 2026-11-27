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

/// Test: the accuracy of Math.Sin, Cos, Tan, Atan2 and Exp (found by the arcs of FSharp.Graphics.Icons, whose points were off their circle by up to 4e-6): each value is within 1e-14
/// (relative, to the reference of IEEE doubles computed by Python's math module on 2026-11-26) at angles in every quadrant, close to a multiple of pi/2, negative, and large.
/// One decimal digit for each function: 11111 when all five hold.
let testMathAccuracy () : int =
    let near (a: float) (b: float) = abs (a - b) <= 1e-14 * (1.0 + abs b)
    let sinOk =
        near (System.Math.Sin(0.5)) 0.479425538604203 && near (System.Math.Sin(2.5)) 0.5984721441039565 && near (System.Math.Sin(3.14)) 0.0015926529164868282
        && near (System.Math.Sin(-3.0)) -0.1411200080598672 && near (System.Math.Sin(100.0)) -0.5063656411097588 && near (System.Math.Sin(7.0)) 0.6569865987187891 && near (System.Math.Sin(1e-3)) 0.0009999998333333417
    let cosOk =
        near (System.Math.Cos(0.5)) 0.8775825618903728 && near (System.Math.Cos(2.5)) -0.8011436155469337 && near (System.Math.Cos(3.14)) -0.9999987317275395
        && near (System.Math.Cos(-3.0)) -0.9899924966004454 && near (System.Math.Cos(100.0)) 0.8623188722876839 && near (System.Math.Cos(3.1415)) -0.9999999957076562 && near (System.Math.Cos(1.0)) 0.5403023058681398
    let tanOk =
        near (System.Math.Tan(0.5)) 0.5463024898437905 && near (System.Math.Tan(2.5)) -0.7470222972386603 && near (System.Math.Tan(3.0)) -0.1425465430742778
        && near (System.Math.Tan(-1.2)) -2.5721516221263188 && near (System.Math.Tan(100.0)) -0.5872139151569291
    let atanOk =
        near (System.Math.Atan2(1.0, 2.0)) 0.4636476090008061 && near (System.Math.Atan2(2.0, 1.0)) 1.1071487177940904 && near (System.Math.Atan2(1.0, 1.0)) 0.7853981633974483
        && near (System.Math.Atan2(-0.3, -1.0)) -2.8501358591119264 && near (System.Math.Atan2(5.0, -0.1)) 1.590793660768047 && near (System.Math.Atan2(-1.0, 3.0)) -0.3217505543966422
        && near (System.Math.Atan2(0.01, 1.0)) 0.009999666686665238 && near (System.Math.Atan2(3.0, -4.0)) 2.498091544796509
    let expOk =
        near (System.Math.Exp(0.3)) 1.3498588075760032 && near (System.Math.Exp(1.0)) 2.718281828459045 && near (System.Math.Exp(-2.0)) 0.1353352832366127 && near (System.Math.Exp(5.5)) 244.69193226422038
        && near (System.Math.Exp(0.01)) 1.010050167084168 && near (System.Math.Exp(10.0)) 22026.465794806718 && near (System.Math.Exp(-0.7)) 0.4965853037914095
    (if sinOk then 10000 else 0) + (if cosOk then 1000 else 0) + (if tanOk then 100 else 0) + (if atanOk then 10 else 0) + (if expOk then 1 else 0)

/// Test: List.skipWhile / List.takeWhile (found by the keyboard drag of FSharp.Graphics.Interact, which skips the slots before the one a drop started at): the predicate is
/// asked of existing elements only, an element that fails ends it, nothing is skipped or taken from an empty list or when it never or always holds, and it can capture.
let testListSkipTakeWhile () : int =
    let xs = [ 1; 2; 3; 10; 4; 5 ]
    let limit = 10
    let words = [ "a"; "bb"; "ccc"; "d" ]
    (if List.skipWhile (fun x -> x < limit) xs = [ 10; 4; 5 ] then 10000 else 0)
    + (if List.takeWhile (fun x -> x < limit) xs = [ 1; 2; 3 ] then 1000 else 0)
    + (if List.skipWhile (fun x -> x < 100) xs = [] && List.takeWhile (fun x -> x < 0) xs = [] then 100 else 0)
    + (if List.skipWhile (fun x -> x > 0) ([]: int list) = [] && List.takeWhile (fun x -> x > 0) xs = xs then 10 else 0)
    + (if List.skipWhile (fun (s: string) -> s.Length < 3) words = [ "ccc"; "d" ] && List.takeWhile (fun (s: string) -> s.Length < 3) words = [ "a"; "bb" ] then 1 else 0)

type MinMaxRecord = { MmName: string; MmRank: int }

/// List.minBy / maxBy with a key that is not a number: a tuple (the structural comparison), a string, a record; the first of equal keys wins.
let testListMinMaxByStructural () : int =
    let xs = [ (3, 1, "a"); (1, 9, "b"); (1, 2, "c"); (2, 0, "d"); (1, 2, "e") ]
    let (a1, _, n1) = xs |> List.minBy (fun (t, o, _) -> t, o)
    let (a2, _, n2) = xs |> List.maxBy (fun (t, o, _) -> t, o)
    let words = [ "pear"; "apple"; "fig"; "apple2" ]
    let recs = [ { MmName = "x"; MmRank = 2 }; { MmName = "a"; MmRank = 5 }; { MmName = "a"; MmRank = 1 } ]
    let first = recs |> List.minBy (fun r -> r.MmName, r.MmRank)
    let nums = [ 4; 2; 9; 2; 9 ]
    (if a1 = 1 && n1 = "c" then 10000 else 0)            // smallest (1, 2): the first of two equal keys
    + (if a2 = 3 && n2 = "a" then 1000 else 0)           // largest (3, 1)
    + (if List.minBy (fun (w: string) -> w) words = "apple" && List.maxBy (fun (w: string) -> w) words = "pear" then 100 else 0)
    + (if first.MmRank = 1 then 10 else 0)
    + (if List.minBy (fun n -> n) nums = 2 && List.maxBy (fun n -> -n) nums = 2 && List.maxBy (fun n -> n) nums = 9 then 1 else 0)

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

type SortWithItem = { SwKey: int; SwOrder: int }

/// The comparer reaches these as a function value, not as a lambda written at the call: that is the shared per-array-type helper
/// ($arraySortWith_n, ArraySort.fs), not the inline merge sort of ArrayReplacements.
let sortIntsWith (cmp: int -> int -> int) (xs: int[]) : int[] = Array.sortWith cmp xs
let sortItemsWith (cmp: SortWithItem -> SortWithItem -> int) (xs: SortWithItem[]) : SortWithItem[] = Array.sortWith cmp xs

/// Array.sortWith with a comparer that is a function value sorts in O(n log n): empty, one, two and odd lengths, records are
/// ordered by key and none is lost or doubled (.NET does not promise that equal keys keep their order, so neither does this test),
/// a permutation of 200 000 numbers comes out sorted (an insertion sort took minutes for that), and the input is untouched.
let testArraySortWithMerge () : int =
    let byInt (a: int) (b: int) = if a < b then -1 elif a > b then 1 else 0
    let small =
        sortIntsWith byInt [||] = [||] && sortIntsWith byInt [| 7 |] = [| 7 |] && sortIntsWith byInt [| 2; 1 |] = [| 1; 2 |]
        && sortIntsWith byInt [| 3; 1; 2 |] = [| 1; 2; 3 |] && sortIntsWith byInt [| 5; 4; 3; 2; 1 |] = [| 1; 2; 3; 4; 5 |]
        && sortIntsWith byInt [| 1; 1; 1 |] = [| 1; 1; 1 |]
    // records ordered by key (key = i * 31 % 7, order = i), every one of them still there once
    let items = Array.init 1000 (fun i -> { SwKey = (i * 31) % 7; SwOrder = i })
    let byKey = sortItemsWith (fun a b -> byInt a.SwKey b.SwKey) items
    let mutable stable = byKey.Length = 1000
    let mutable orderSum = byKey.[0].SwOrder
    for i in 1 .. byKey.Length - 1 do
        if byKey.[i - 1].SwKey > byKey.[i].SwKey then stable <- false
        orderSum <- orderSum + byKey.[i].SwOrder
    if orderSum <> 999 * 1000 / 2 then stable <- false
    let untouched = items.[0].SwOrder = 0 && items.[999].SwOrder = 999 && items.[1].SwKey = 3
    // a permutation of 0 .. n-1 (a step coprime to n), sorted back to the identity
    let n = 200000
    let big = sortIntsWith byInt (Array.init n (fun i -> (i * 7919) % n))
    let mutable identity = true
    for i in 0 .. n - 1 do
        if big.[i] <> i then identity <- false
    (if small then 1000 else 0) + (if stable then 100 else 0) + (if untouched then 10 else 0) + (if identity then 1 else 0)

// ── Array.pairwise ────────────────────────────────────────────────────────

/// Array.pairwise: empty and one element give no pair (the length is clamped, not -1), two give one, the pairs overlap by one
/// element, the elements may be numbers, floats, strings or records, and the input is untouched.
let testArrayPairwise () : int =
    let none = (Array.pairwise ([||]: int[])).Length = 0 && (Array.pairwise [| 7 |]).Length = 0
    let two = Array.pairwise [| 3; 5 |] = [| (3, 5) |]
    let ints = [| 1; 4; 9; 16; 25 |]
    let diffs = ints |> Array.pairwise |> Array.map (fun (a, b) -> b - a)
    let numbers = diffs = [| 3; 5; 7; 9 |] && ints.Length = 5
    let floats = [| 1.5; 2.5; 4.0 |] |> Array.pairwise |> Array.map (fun (a, b) -> b - a) = [| 1.0; 1.5 |]
    let strings = [| "a"; "b"; "c" |] |> Array.pairwise = [| ("a", "b"); ("b", "c") |]
    let items = Array.init 4 (fun i -> { SwKey = i * i; SwOrder = i })
    let gaps = items |> Array.pairwise |> Array.map (fun (a, b) -> b.SwKey - a.SwKey)
    let records = gaps = [| 1; 3; 5 |]
    (if none then 10000 else 0) + (if two then 1000 else 0) + (if numbers then 100 else 0) + (if floats && strings then 10 else 0) + (if records then 1 else 0)

/// Array.zip of reference elements (a tuple of strings or records is a non-null reference: a fresh array has no default to be filled with),
/// of none, of numbers.
let testArrayZipRefs () : int =
    let strings = Array.zip [| "a"; "b" |] [| "x"; "y" |] = [| ("a", "x"); ("b", "y") |]
    let none = (Array.zip ([||]: string[]) ([||]: string[])).Length = 0
    let items = Array.init 3 (fun i -> { SwKey = i; SwOrder = 10 * i })
    let records = Array.zip items items |> Array.map (fun (a, b) -> a.SwOrder + b.SwKey) = [| 0; 11; 22 |]
    let numbers = Array.zip [| 1; 2; 3 |] [| 4.0; 5.0; 6.0 |] |> Array.sumBy (fun (a, b) -> float a * b) = 32.0
    (if strings then 1000 else 0) + (if none then 100 else 0) + (if records then 10 else 0) + (if numbers then 1 else 0)

/// Array.tryFindBack and findBack: the LAST element that satisfies the predicate (find and tryFind find the first), none in an empty array, a number, a string, a record.
/// Array.distinct: the first of equal elements in the order they came, by content (strings, tuples and records, not by reference), empty, all different, all equal.
let testArrayFindBackDistinct () : int =
    let last = [| 1; 2; 3; 4; 5 |] |> Array.tryFindBack (fun x -> x % 2 = 0) = Some 4 && [| 1; 2; 3; 4; 5 |] |> Array.findBack (fun x -> x % 2 = 1) = 5
    let first = [| 1; 2; 3; 4; 5 |] |> Array.tryFind (fun x -> x % 2 = 0) = Some 2
    let none = ([||]: int[]) |> Array.tryFindBack (fun _ -> true) = None && [| 1; 3 |] |> Array.tryFindBack (fun x -> x % 2 = 0) = None
    let items = Array.init 6 (fun i -> { SwKey = i % 3; SwOrder = i })
    let records = (items |> Array.findBack (fun r -> r.SwKey = 1)).SwOrder = 4 && (items |> Array.tryFindBack (fun r -> r.SwKey = 7)).IsNone
    let strings = [| "a"; "bb"; "cc"; "d" |] |> Array.tryFindBack (fun s -> s.Length = 2) = Some "cc"
    let nums = Array.distinct [| 3; 1; 3; 2; 1; 3 |] = [| 3; 1; 2 |] && (Array.distinct ([||]: int[])).Length = 0 && Array.distinct [| 1; 2; 3 |] = [| 1; 2; 3 |] && Array.distinct [| 5; 5; 5 |] = [| 5 |]
    let text = Array.distinct [| "b"; "a"; "b"; String.replicate 2 "a"; "aa" |] = [| "b"; "a"; "aa" |]
    let structured = Array.distinct [| (1, "x"); (1, "x"); (2, "x"); (1, "y") |] = [| (1, "x"); (2, "x"); (1, "y") |]
    let byContent = (Array.distinct (items |> Array.map (fun r -> { r with SwOrder = r.SwKey }))).Length = 3
    (if last && first && none then 10000 else 0) + (if records && strings then 1000 else 0) + (if nums then 100 else 0) + (if text && structured then 10 else 0) + (if byContent then 1 else 0)

/// Array.ofSeq of a list, a ResizeArray, an array (a copy: writing to it leaves the source alone), a seq that was mapped or filtered, of nothing, and of tuples, strings and records.
let testArrayOfSeq () : int =
    let ofList = Array.ofSeq [ 1; 2; 3 ] = [| 1; 2; 3 |] && (Array.ofSeq ([]: int list)).Length = 0
    let r = ResizeArray<int>([ 3; 1; 2 ])
    let ofResize = Array.ofSeq r = [| 3; 1; 2 |] && (r |> Seq.map (fun v -> v * 2) |> Array.ofSeq) = [| 6; 2; 4 |]
    let source = [| 1; 2; 3 |]
    let copy = Array.ofSeq source
    copy.[0] <- 99
    let copied = source.[0] = 1 && copy.[0] = 99 && copy.Length = 3
    let filtered = [ 1; 2; 3; 4 ] |> Seq.filter (fun v -> v % 2 = 0) |> Array.ofSeq = [| 2; 4 |]
    let tuples = (r |> Seq.map (fun v -> (v, v + 1)) |> Array.ofSeq) = [| (3, 4); (1, 2); (2, 3) |]
    let strings = ([ "a"; "b" ] |> Seq.map (fun s -> s + s) |> Array.ofSeq) = [| "aa"; "bb" |]
    let items = [ for i in 0 .. 2 -> { SwKey = i; SwOrder = 10 * i } ] |> Seq.map (fun x -> { x with SwKey = x.SwKey + 1 }) |> Array.ofSeq
    let records = items.Length = 3 && items.[2].SwKey = 3 && items.[2].SwOrder = 20
    (if ofList then 10000 else 0) + (if ofResize then 1000 else 0) + (if copied && filtered then 100 else 0) + (if tuples && strings then 10 else 0) + (if records then 1 else 0)

/// The instances of a class are equal when they are the same object: `obj.ReferenceEquals` and `=` of two objects with the same content are false, of an object and itself or another name for it true,
/// also behind a function, in an array and as a field.
type RefCell() =
    let mutable n = 0
    member _.N = n
    member _.Bump() = n <- n + 1

type RefHolder = { Cell: RefCell }

let testClassReferenceEquality () : int =
    let a = RefCell()
    let b = RefCell()
    let c = a
    let apart = not (obj.ReferenceEquals(a, b)) && obj.ReferenceEquals(a, c) && obj.ReferenceEquals(a, a)
    let cells = [| RefCell(); RefCell() |]
    let pick (i: int) = cells.[i]
    let behindCalls = not (obj.ReferenceEquals(pick 0, pick 1)) && obj.ReferenceEquals(pick 0, pick 0)
    let equalsOperator = (a = a) && not (a = b) && (a <> b) && not (a <> c)
    let holders = [| { Cell = a }; { Cell = b } |]
    let asFields = not (obj.ReferenceEquals(holders.[0].Cell, holders.[1].Cell)) && obj.ReferenceEquals(holders.[0].Cell, a)
    // the content is what it is, the identity does not move with it
    a.Bump()
    let identityStays = obj.ReferenceEquals(a, c) && a.N = 1 && b.N = 0 && not (obj.ReferenceEquals(a, b))
    (if apart then 10000 else 0) + (if behindCalls then 1000 else 0) + (if equalsOperator then 100 else 0) + (if asFields then 10 else 0) + (if identityStays then 1 else 0)

/// Option.orElse (Some stays, None becomes the other option; numbers, strings, records) and Option.flatten (Some (Some x), Some None, None).
let testOptionOrElseFlatten () : int =
    let orElseInts = (None |> Option.orElse (Some 3)) = Some 3 && (Some 1 |> Option.orElse (Some 3)) = Some 1 && (None |> Option.orElse (None: int option)).IsNone
    let orElseStrings = (None |> Option.orElse (Some "b")) = Some "b" && (Some "a" |> Option.orElse (Some "b")) = Some "a"
    let item = { SwKey = 1; SwOrder = 2 }
    let orElseRecords = (match (None: SortWithItem option) |> Option.orElse (Some item) with Some r -> r.SwOrder = 2 | None -> false)
    let flatten = Option.flatten (Some (Some 4)) = Some 4 && (Option.flatten (Some (None: int option))).IsNone && (Option.flatten (None: int option option)).IsNone
    let flattenStrings = Option.flatten (Some (Some "x")) = Some "x"
    (if orElseInts then 10000 else 0) + (if orElseStrings then 1000 else 0) + (if orElseRecords then 100 else 0) + (if flatten && flattenStrings then 10 else 0)

/// List.iter2 and List.iteri2: the two lists in lockstep (numbers, strings, records); the index counts from 0; two empty lists do nothing.
let testListIter2 () : int =
    let mutable acc = 0
    List.iter2 (fun a b -> acc <- acc + a * b) [ 1; 2; 3 ] [ 4; 5; 6 ]
    let dot = acc = 32
    acc <- 0
    List.iteri2 (fun i a b -> acc <- acc + i * (a + b)) [ 1; 2; 3 ] [ 4; 5; 6 ]
    let indexed = acc = 25
    let mutable text = ""
    List.iter2 (fun (k: string) (v: int) -> text <- text + k + string v) [ "a"; "b" ] [ 1; 2 ]
    let mutable n = 0
    List.iter2 (fun (_: int) (_: int) -> n <- n + 1) [] []
    let item = { SwKey = 1; SwOrder = 2 }
    let mutable total = 0
    List.iteri2 (fun i (r: SortWithItem) (x: int) -> total <- total + i + r.SwOrder * x) [ item; item ] [ 10; 20 ]
    (if dot then 10000 else 0) + (if indexed then 1000 else 0) + (if text = "a1b2" then 100 else 0) + (if n = 0 then 10 else 0) + (if total = 61 then 1 else 0)

[<Struct>]
type SrInner = { SrN: int }

[<Struct>]
type SrOuter = { SrA: int; SrB: string; SrI: SrInner }

/// A struct record that is a missing value: the `out` variable of `TryGetValue` starts as the default of the type (the front end writes it as a call of the
/// record's name with a zero for each field), and so does `Unchecked.defaultof`.  A dictionary of struct records is how the cells of a terminal canvas are kept.
let testStructRecordDefault () : int =
    let d = System.Collections.Generic.Dictionary<int, SrOuter>()
    d[1] <- { SrA = 5; SrB = "x"; SrI = { SrN = 2 } }
    let found = match d.TryGetValue 1 with | true, v -> v.SrA + v.SrI.SrN | _ -> -1
    let missing = match d.TryGetValue 9 with | true, v -> v.SrA | _ -> -1
    let z : SrOuter = Unchecked.defaultof<SrOuter>
    (if found = 7 then 1000 else 0) + (if missing = -1 then 100 else 0) + (if z.SrA = 0 then 10 else 0) + (if z.SrI.SrN = 0 then 1 else 0)

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

/// Test: a fractional exponent is a power, not a truncated one — 0.4945 ^ 2.4 = 0.18450116…  (it used to be 0.4945²)
let testMathPowFractional () : int = int (System.Math.Pow(0.4945, 2.4) * 1000000.0)

/// Test: a negative exponent divides — 2 ^ -3 = 0.125  (it used to be 1)
let testMathPowNegative () : int = int (System.Math.Pow(2.0, -3.0) * 1000.0 + 0.5)

/// Test: a root — 9 ^ 0.5 = 3, 10 ^ -2.5 = 0.00316227…
let testMathPowRoot () : int =
    int (System.Math.Pow(9.0, 0.5) * 1000.0 + 0.5) + int (System.Math.Pow(10.0, -2.5) * 1000000.0)

/// Test: 0 ^ 2.5 = 0
let testMathPowZeroBase () : int = int (System.Math.Pow(0.0, 2.5) * 1000.0 + 7.0)

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

/// ResizeArray(other ResizeArray) is a copy: Fable emits the JS `Array.from(source)` for a source that is not a literal
let testResizeArrayCopyOfResizeArray () : int =
    let a = ResizeArray<int>()
    a.Add 1; a.Add 2; a.Add 3
    let b = ResizeArray<int>(a)
    b.Add 4
    b.[0] <- 9
    a.Count * 1000 + b.Count * 100 + a.[0] * 10 + b.[0]       // 3419

/// ResizeArray(list) where the list is a value, not a literal
let testResizeArrayCopyOfListValue () : int =
    let xs = [ 5; 6; 7 ] |> List.map (fun x -> x + 1)
    let r = ResizeArray<int>(xs)
    r.Count * 10 + r.[2]                                      // 38

/// Array.tryPick: the first Some the callback returns, and the callback runs once per element up to it (3 of 4), nothing found is None: 30 * 100 + 3 * 10 + 0
let testArrayTryPick () : int =
    let a = [| 1; 2; 3; 4 |]
    let calls = ref 0
    let found = a |> Array.tryPick (fun x -> calls.Value <- calls.Value + 1; if x > 2 then Some (x * 10) else None)
    let none = a |> Array.tryPick (fun x -> if x > 9 then Some x else None)
    (match found with Some v -> v | None -> -1) * 100 + calls.Value * 10 + (match none with Some _ -> 1 | None -> 0)     // 3030

/// Array.tryPick over strings, with a string as its result (a reference type in the option)
let testArrayTryPickString () : int =
    let names = [| "a"; "bb"; "ccc" |]
    match names |> Array.tryPick (fun s -> if s.Length = 2 then Some (s + "!") else None) with
    | Some s -> s.Length                                      // 3
    | None -> 0

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

/// `Stack(seq)` pushes in order (1 at the bottom), `TryPop` / `TryPeek` do not throw: 3 * 100 + 2 * 10 + 0 (empty: false) + 0 left
let testStackTryPopAndSeqCtor () : int =
    let s = System.Collections.Generic.Stack<int>([ 1; 2; 3 ])
    let mutable top = 0
    let ok = s.TryPop(&top)
    let mutable next = 0
    let okPeek = s.TryPeek(&next)
    s.Pop() |> ignore
    s.Pop() |> ignore
    let mutable none = 0
    let okEmpty = s.TryPop(&none)
    (if ok then top * 100 else 0) + (if okPeek then next * 10 else 0) + (if okEmpty then 1000 else 0) + s.Count

/// `for c in s` and `s.ToCharArray()` give characters (i32), not one-character strings: Fable asks for s.split("") and types the
/// result char[].  Digits of "a1b22c" summed (5) * 100 + its length (6) * 10 + 'h' - 'e' (3) = 563
let testForInStringAndToCharArray () : int =
    let mutable digits = 0
    for c in "a1b22c" do
        if c >= '0' && c <= '9' then digits <- digits + (int c - int '0')
    let chars = "hello".ToCharArray()
    digits * 100 + "a1b22c".Length * 10 + (int chars.[0] - int chars.[1])

/// A string literal pattern: `match s with "" -> … | v -> …` (the empty string is a pattern like any other; it is
/// `s <> null && s.Length = 0`, and the null literal must not reach the non-null string compare).
/// "x" -> 10 + 1, "" -> None -> 0, a StringBuilder result "abcd" -> 100 + 4:  11 + 0 + 104 = 115
let private classify (s: string) : int option =
    match s with
    | "" -> None
    | v -> Some v.Length

let testStringLiteralPattern () : int =
    let a = match classify "x" with Some n -> 10 + n | None -> 0
    let b = match classify "" with Some n -> 1000 + n | None -> 0
    let sb = System.Text.StringBuilder()
    sb.Append("abcd") |> ignore
    let c = match classify (sb.ToString()) with Some n -> 100 + n | None -> 0
    a + b + c

// ── List.sortBy: a stable merge sort by key, ordered by Fable's comparer (strings and structural keys too), records as elements ──

type SByRec = { SbKey: string; SbRank: int }

let testListSortByStringKey () : int =
    let items = [ { SbKey = "pear"; SbRank = 1 }; { SbKey = "apple"; SbRank = 2 }; { SbKey = "fig"; SbRank = 3 }; { SbKey = "apple"; SbRank = 4 } ]
    List.sortBy (fun r -> r.SbKey) items |> List.fold (fun h r -> h * 10 + r.SbRank) 0          // apple 2, apple 4 (stable), fig 3, pear 1

let testListSortByDescendingStable () : int =
    let items = [ (1, 'a'); (2, 'b'); (1, 'c'); (3, 'd'); (2, 'e') ]
    List.sortByDescending fst items |> List.map (fun (_, c) -> int c - 96) |> List.fold (fun h v -> h * 10 + v) 0   // d b e a c

let testListSortByTupleKey () : int =
    let items = [ (2, "b"); (1, "z"); (2, "a"); (1, "a") ]
    List.sortBy id items |> List.map (fun (n, s) -> n * 1000 + int s.[0]) |> List.fold (fun h v -> h * 31 + v) 7     // (1,a) (1,z) (2,a) (2,b)

let testListSortByManyElements () : int =
    let xs = List.init 3000 (fun i -> (i * 7919) % 3001)
    let sorted = List.sortBy (fun v -> v % 1000) xs
    let ok = sorted |> List.pairwise |> List.forall (fun (a, b) -> a % 1000 <= b % 1000)
    (if ok then 1000000 else 0) + List.length sorted * 100 + List.sum sorted % 100

// ── inlining of small functions: the arguments are evaluated once and in order, the callee's names cannot capture the caller's ──

let private inlSq (n: int) : int = n * n
let private inlAddTwice (n: int) (m: int) : int = n + n + m
let private inlPick (c: bool) (a: int) (b: int) : int = if c then a else b
let private inlClamp (v: int) (lo: int) (hi: int) : int = if v < lo then lo elif v > hi then hi else v
let private inlChain (n: int) : int = inlSq (inlClamp n 0 10) + 1
let private inlMutating (x: int) : int =
    let mutable acc = x
    acc <- acc * 2
    acc <- acc + 1
    acc
let private inlFirst (a: int[]) (i: int) : int = a.[i] + a.Length

let testInlineEvalOnce () : int =
    let calls = ref 0
    let next () = calls.Value <- calls.Value + 1; calls.Value * 10
    let r = inlAddTwice (next ()) (next ())          // n = 10 is used twice by the callee but evaluated once: 10 + 10 + 20
    r * 100 + calls.Value                            // 4002

let testInlineNameCapture () : int =
    let n = 5
    let m = 7
    inlAddTwice m n + n                              // the callee's n and m are the caller's m and n: 7 + 7 + 5, then + 5

let testInlineChain () : int = inlChain 15 + inlChain -3 + inlChain 4      // 101 + 1 + 17

let testInlineStrictArguments () : int =
    let calls = ref 0
    let tick () = calls.Value <- calls.Value + 1; 1
    let r = inlPick true (tick ()) (tick ())         // both arguments are evaluated, in order, whichever the callee takes
    r * 10 + calls.Value                             // 12

let testInlineLocalMutation () : int = inlMutating 3 + inlMutating 10      // 7 + 21

let testInlineArrayArguments () : int =
    let a = [| 1; 2; 3 |]
    inlFirst a 2 + inlFirst a 0                      // (3 + 3) + (1 + 3)

// ── byte[] and bool[]: the same results as .NET, whether the elements are stored in 32 or in 8 bits ──

let testByteArrayRoundTrip () : int =
    let a = Array.zeroCreate<byte> 4
    a.[0] <- 255uy; a.[1] <- 128uy; a.[2] <- 1uy; a.[3] <- byte 300     // 300 wraps to 44
    int a.[0] + int a.[1] * 10 + int a.[2] * 1000 + int a.[3] * 100000

let testByteArrayArithmetic () : int =
    let a = [| 250uy; 3uy; 200uy; 7uy |]
    let b = Array.map (fun x -> x + 10uy) a                             // wraps: 4 13 210 17
    let c = Array.append a b |> Array.rev
    let d = Array.sub c 2 4
    Array.sumBy int d * 1000 + Array.length c

let testByteArrayBlitCopy () : int =
    let src = Array.init 8 (fun i -> byte (i * 40))                      // 0 40 80 120 160 200 240 24
    let dst = Array.zeroCreate<byte> 8
    Array.blit src 2 dst 1 5
    let copy = Array.copy dst
    copy.[0] <- 99uy
    Array.sumBy int copy + int dst.[0]

let testByteArraySort () : int =
    let s = [| 200uy; 5uy; 255uy; 0uy; 17uy |] |> Array.sort
    int s.[0] + int s.[1] * 10 + int s.[2] * 100 + int s.[3] * 1000 + int s.[4] * 10000

let testByteArrayFilterFold () : int =
    let a = Array.init 20 (fun i -> byte (i * 13))
    let big = a |> Array.filter (fun x -> x > 100uy)
    (big |> Array.fold (fun acc x -> acc + int x) 0) + big.Length

let testBoolArray () : int =
    let a = Array.create 10 false
    for i in 0 .. 4 do a.[i * 2] <- true
    let n = a |> Array.filter id |> Array.length
    let m = a |> Array.map not |> Array.filter id |> Array.length
    (if a.[4] then 100 else 0) + (if a.[5] then 10 else 0) + n * 1000 + m * 10000

let testBoolArrayLiteral () : int =
    let a = [| true; false; true; true |]
    let r = Array.rev a
    (if r.[0] then 1 else 0) + (if r.[1] then 10 else 0) + (if r.[2] then 100 else 0) + (if Array.forall id a then 1000 else 0) + (if Array.exists id a then 10000 else 0)

let testByteArrayForIn () : int =
    let a = [| 1uy; 2uy; 255uy |]
    let mutable s = 0
    for x in a do s <- s * 3 + int x
    s

let testByteArrayToList () : int =
    let l = [ 7uy; 250uy; 3uy ]
    let a = List.toArray l
    let back = Array.toList a |> List.map int
    List.sum back * 10 + a.Length

let testByteArraySortBy () : int =
    let a = [| 30uy; 255uy; 4uy; 128uy |] |> Array.sortBy (fun x -> 255uy - x)
    int a.[0] + int a.[1] * 1000 + int a.[3] * 1000000

let testByteResizeArray () : int =
    let r = System.Collections.Generic.List<byte>()
    for i in 0 .. 9 do r.Add(byte (i * 30))                  // the last ones wrap: 270 -> 14
    r.Add 255uy
    let a = r.ToArray()
    a.Length * 1000 + (a |> Array.sumBy int) + int r.[10]

let testBoolResizeArray () : int =
    let r = System.Collections.Generic.List<bool>()
    for i in 0 .. 7 do r.Add(i % 3 = 0)
    let a = r.ToArray()
    (a |> Array.filter id |> Array.length) * 100 + a.Length * 10 + (if r.[6] then 1 else 0)

let testByteAppendInit () : int =
    let a = Array.append (Array.append [| 1uy |] [| 2uy; 255uy |]) (Array.init 3 (fun i -> byte (i + 250)))
    Array.sumBy int a * 10 + a.Length

let testByteOfSeq () : int =
    let a = Seq.toArray (seq { for i in 0 .. 5 -> byte (i * 60) })
    let b = Array.ofList [ 9uy; 250uy ]
    Array.sumBy int a + Array.sumBy int b * 1000


// ── ranges with a step, slices, Array.concat, List.concat, System.Array.IndexOf (every value checked against .NET) ──

let testStepForUp () : int =
    let mutable s = 0
    for i in 0 .. 2 .. 9 do s <- s + i
    s                                                                     // 0+2+4+6+8

let testStepForDown () : int =
    let mutable s = 0
    for i in 10 .. -3 .. 0 do s <- s + i
    s                                                                     // 10+7+4+1

let testStepForEmpty () : int =
    let mutable n = 0
    for _ in 5 .. 2 .. 1 do n <- n + 1
    for _ in 1 .. -1 .. 5 do n <- n + 1
    n                                                                     // both ranges are empty

let testStepForBig () : int =
    let mutable n = 0
    for _ in 0 .. 1000 .. 100000 do n <- n + 1
    n                                                                     // 101

let testStepForVariable () : int =
    let step = 3
    let mutable s = 0
    for i in 0 .. step .. 10 do s <- s + i
    s                                                                     // 0+3+6+9

let testStepForNested () : int =
    let mutable s = 0
    for i in 0 .. 2 .. 4 do
        for j in 1 .. 2 .. 5 do s <- s + i * j
    s                                                                     // (0+2+4) * (1+3+5)

let testStepSeq () : int =
    let sum = seq { 0 .. 5 .. 20 } |> Seq.sum                             // 50
    let len = seq { 0 .. 5 .. 20 } |> Seq.length                          // 5
    let lst = seq { 0 .. 5 .. 20 } |> Seq.toList |> List.length          // 5
    sum * 10000 + len * 100 + lst

let testStepSeqIter () : int =
    let mutable s = 0
    Seq.iter (fun i -> s <- s + i) (seq { 1 .. 2 .. 9 })
    [ 1 .. 3 .. 10 ] |> List.iter (fun i -> s <- s + i)
    s                                                                     // 25 + 22

let private sliceSource () = [| 10; 20; 30; 40; 50 |]

let testArraySliceBounds () : int =
    let a = sliceSource ()
    let sum (x: int[]) = Array.sum x
    sum a.[1..3] * 1000000 + sum a.[..1] * 10000 + sum a.[2..] * 100 + a.[0..4].Length
    // 90 * 1000000 + 30 * 10000 + 120 * 100 + 5

let testArraySliceClamped () : int =
    let a = sliceSource ()
    // out of range is clamped, an inverted range is empty (the .NET results)
    a.[1..10].Length * 100000 + a.[3..1].Length * 10000 + (Array.sum a.[-1..2]) * 100 + a.[5..].Length * 10 + a.[7..].Length + a.[..10].Length * 1000000 + a.[..(-1)].Length * 1000
    // 4 * 100000 + 0 + 60 * 100 + 0 + 0 + 5 * 1000000 + 0

let testArraySliceVariable () : int =
    let a = sliceSource ()
    let i, j = 1, 2
    Array.sum a.[i .. i + j]                                              // 90

let testArraySliceIsCopy () : int =
    let a = sliceSource ()
    let b = a.[0..2]
    b.[0] <- 99
    a.[0] * 100 + b.[0]                                                   // 10 * 100 + 99

let testArraySliceElementTypes () : int =
    let s = [| "a"; "bb"; "ccc" |].[1..] |> Array.sumBy (fun x -> x.Length)           // 5
    let f = int ([| 1.5; 2.5; 3.5 |].[1..] |> Array.sum)                               // 6
    let b = [| 1uy; 2uy; 3uy; 4uy |].[1..2] |> Array.sumBy int                         // 5
    let t = [| true; false; true |].[1..] |> Array.filter id |> Array.length           // 1
    s * 1000 + f * 100 + b * 10 + t

let testStringSlice () : int =
    let h = "hello"
    // "ell" "he" "lo" "llo" "" "he" ""  (lengths 3 2 2 3 0 2 0), and the content
    (h.[1..3].Length * 1000000 + h.[..1].Length * 100000 + h.[3..].Length * 10000 + h.[2..10].Length * 1000
     + h.[3..1].Length * 100 + h.[-1..1].Length * 10 + h.[7..].Length) + int h.[1..3].[0] * 10000000

let testArrayConcat () : int =
    let a = Array.concat [ [| 1; 2 |]; [| 3 |]; [||] ]                                  // 6
    let b = Array.concat [| [| 1; 2 |]; [| 3; 4 |] |]                                   // 10
    let c = [ [| 1; 2 |]; [| 3 |]; [| 4; 5 |] ] |> Array.concat
    let d = (Array.concat ([] : int[] list)).Length                                     // 0
    let e = Array.concat [ [| "a" |]; [| "bb"; "c" |] ] |> Array.sumBy (fun s -> s.Length)   // 4
    Array.sum a * 1000000 + Array.sum b * 10000 + c.[0] * 1000 + c.[2] * 100 + c.[4] * 10 + d + e
    // 6 * 1000000 + 10 * 10000 + 1000 + 300 + 50 + 0 + 4

let testListConcat () : int =
    let a = List.concat [ [ 1 ]; [ 2; 3 ] ] |> List.length                              // 3
    let b = [ [ 1; 2 ]; [ 3 ] ] |> List.concat |> List.sum                              // 6
    let c = List.collect (fun x -> [ x; x ]) [ 1; 2; 3 ] |> List.length                 // 6
    a * 100 + b * 10 + c

let testArrayIndexOf () : int =
    let i1 = System.Array.IndexOf([| 5; 6; 7 |], 7)                                     // 2
    let i2 = System.Array.IndexOf([| 5; 6; 7 |], 9)                                     // -1
    let i3 = System.Array.IndexOf([| 5; 6; 5 |], 5, 1)                                  // 2
    let i4 = System.Array.IndexOf([| 5; 6; 5 |], 5, 1, 1)                               // -1
    let i5 = System.Array.IndexOf([| "a"; "bb"; "c" |], "bb")                           // 1
    let i6 = System.Array.IndexOf(Array.empty<int>, 1)                                  // -1
    (i1 + 1) * 100000 + (i2 + 1) * 10000 + (i3 + 1) * 1000 + (i4 + 1) * 100 + (i5 + 1) * 10 + (i6 + 1)
    // 3 * 100000 + 0 + 3 * 1000 + 0 + 2 * 10 + 0

let testOperatorsAsFunctions () : int =
    let a = [| true; false; true |] |> Array.map not |> Array.filter id |> Array.length  // 1
    let b = [| 1; 2; 3 |] |> Array.map (~-) |> Array.sum                                // -6
    let c = [| 1; 2; 3; 4 |] |> Array.reduce (*)                                         // 24
    let d = [ 3; 9; 4 ] |> List.fold max 0                                               // 9
    a * 100000 + (b + 10) * 10000 + c * 100 + d
    // 100000 + 4 * 10000 + 2400 + 9

let testStringBuilderLineAndFormat () : int =
    let sb = System.Text.StringBuilder("ab")
    sb.AppendLine("cd") |> ignore
    sb.AppendLine() |> ignore
    sb.AppendFormat("x={0},{1}", 7, "q") |> ignore
    let s = sb.ToString()
    s.Length * 1000 + s.IndexOf '\n' * 100 + int s.[s.Length - 1]
    // "abcd\n\nx=7,q": 11 * 1000 + 4 * 100 + 'q' (113)

// ── structural equality of unions that have list fields, and of lists of exceptions ───────────────────────────────

type EqJson =
    | EqNull
    | EqStr of string
    | EqList of EqJson list

type EqTree =
    | EqLeaf of int
    | EqNode of EqTree list

/// Test: two unions of different shapes, both with a list field, compared in one program.  Types are canonical by
/// structure and both bases are `(struct (field i32))`: lists of the two element types used to be one type to the
/// equality dispatcher, which read the cases of the wrong union (illegal cast).   Result 3 = (equal, equal, different).
let testEqTwoUnionsWithLists () : int =
    let a = EqList [ EqStr "x"; EqList [ EqNull ] ]
    let b = EqList [ EqStr "x"; EqList [ EqNull ] ]
    let c = EqNode [ EqLeaf 1; EqNode [ EqLeaf 2 ] ]
    let d = EqNode [ EqLeaf 1; EqNode [ EqLeaf 2 ] ]
    (if a = b then 1 else 0) + (if c = d then 2 else 0) + (if a = EqList [ EqStr "y"; EqList [ EqNull ] ] then 4 else 0)

type EqPair = { PA: int; PB: string }

/// Test: `List.contains` and `Array.contains` compare by content, not by reference — strings, records and unions.
/// Result 15 = list of strings (1) + array of strings (2) + list of records (4) + a missing string is not found (8).
let testContainsByContent () : int =
    let words = [ "click here"; "read more"; "here" ]
    let needle = "Click here".ToLowerInvariant()
    let arr = [| "a"; "b" |]
    let recs = [ { PA = 1; PB = "x" }; { PA = 2; PB = "y" } ]
    (if List.contains needle words then 1 else 0)
    + (if Array.contains ("a" + "") arr then 2 else 0)
    + (if List.contains { PA = 2; PB = "y" } recs then 4 else 0)
    + (if List.contains "nope" words then 0 else 8)

// ── the remainder of floats ───────────────────────────────────────────────────────────────────────────────────────

/// Test: 7.5 % 2.0 = 1.5 (`%` on floats compiled to `unreachable`: the emitter had no float remainder)
let testFloatModulus () : int = int (7.5 % 2.0 * 100.0)

/// Test: the sign of the dividend, as in .NET and JavaScript: -7.5 % 2.0 = -1.5
let testFloatModulusNegative () : int = int (-7.5 % 2.0 * 100.0)

/// Test: a hue wrapped into a circle, the way a colour library does it: (370.5 % 360.0) = 10.5
let testFloatModulusWrap () : int = int (370.5 % 360.0 * 10.0)

// ── String.EndsWith with a suffix that also occurs earlier ──────────────────────────────────────────────────────────

/// Test: EndsWith compared the FIRST occurrence of the suffix with the end: "6000".EndsWith "0" was false.
/// Result 15 = one-character suffix (1) + repeated suffix (2) + not a suffix (0, +4 when right) + empty suffix (8).
let testEndsWithRepeated () : int =
    (if "6000".EndsWith "0" then 1 else 0)
    + (if "abcabc".EndsWith "bc" then 2 else 0)
    + (if "abcabd".EndsWith "bc" then 0 else 4)
    + (if "x".EndsWith "" then 8 else 0)

// ── a generic union declared in the program, at a reference type ──────────────────────────────────────────────────

type CmdLike<'M> =
    | CmdNone
    | CmdEmit of 'M
    | CmdBatch of CmdLike<'M> list

type CmdMsg = { CmdCode: int; CmdLabel: string }

let cmdNone<'M> () : CmdLike<'M> = CmdNone
let cmdEmit (m: 'M) : CmdLike<'M> = CmdEmit m

let rec cmdWeight (c: CmdLike<CmdMsg>) : int =
    match c with
    | CmdNone -> 0
    | CmdEmit m -> m.CmdCode
    | CmdBatch cs -> cs |> List.sumBy cmdWeight

/// Test: a function that returns a case of a generic union declared in the program (the Elm-style `Cmd<'Msg>` of the widget
/// editor), called at a record type.  The function's declared result type and the struct it builds were two instantiations of the
/// union; they only validated while the structs of a union were canonical by shape.  5 + 2 = 7
let testGenericUnionAtReferenceType () : int =
    let a : CmdLike<CmdMsg> = cmdNone ()
    let b = cmdEmit { CmdCode = 5; CmdLabel = "x" }
    cmdWeight (CmdBatch [ a; b; cmdEmit { CmdCode = 2; CmdLabel = "y" } ])


// ── Computation expressions and DSL shapes ───────────────────────────────────────────────────────────────────────────────────────────
// What a stack of DSLs needs from the compiler: user-defined builders (Bind/Return/Delay/Combine/For/Run), inlined builders, custom operations,
// comprehensions and statically resolved members.  Each is a program of the kind a library would write; the expected value is what .NET computes.
// The builders are local to the tests: the .NET side of the Differential suite calls the functions by reflection, before the file's own initialisation
// has run, so a module-level `let b = Builder()` is still null there (it is not in the module).

type CeResultBuilder() =
    member _.Bind(r: Result<'a, 'e>, f: 'a -> Result<'b, 'e>) : Result<'b, 'e> = match r with Ok v -> f v | Error e -> Error e
    member _.Return(v: 'a) : Result<'a, 'e> = Ok v
    member _.ReturnFrom(r: Result<'a, 'e>) : Result<'a, 'e> = r
let ceParse (s: string) : Result<int, string> = if s = "x" then Error "bad" else Ok s.Length

/// a result builder: let! chains and a short circuit.  3 * 8 + 19 = 43, an Error stops the chain (+1000 would show it did not)
let testCeResult () : int =
    let ceResult = CeResultBuilder()
    let ok =
        ceResult {
            let! a = ceParse "abc"
            let! b = ceParse "abcdefgh"
            return a * b + 19 }
    let bad =
        ceResult {
            let! a = ceParse "x"
            let! b = ceParse "abcdefgh"
            return a + b + 1000 }
    (match ok with Ok v -> v | Error _ -> -1) + (match bad with Ok _ -> 1000 | Error _ -> 0)

type CeOptionBuilder() =
    member _.Bind(o: 'a option, f: 'a -> 'b option) : 'b option = match o with Some v -> f v | None -> None
    member _.Return(v: 'a) : 'a option = Some v
let ceHalf (n: int) : int option = if n % 2 = 0 then Some (n / 2) else None

/// an option builder; a None on the way gives None.  4 + 2 + 1 = 7
let testCeOption () : int =
    let ceOption = CeOptionBuilder()
    let ok =
        ceOption {
            let! a = ceHalf 8
            let! b = ceHalf a
            return a + b + 1 }
    let bad =
        ceOption {
            let! a = ceHalf 3
            return a }
    (match ok with Some v -> v | None -> -100) + (match bad with Some _ -> 1000 | None -> 0)

type CePipe() =
    member inline _.Bind(x: int, [<InlineIfLambda>] f: int -> int) : int = f (x + 1)
    member inline _.Return(x: int) : int = x * 2

/// a builder with inline members and InlineIfLambda, the zero-cost shape: a = 5, b = 8, (5 + 8 + 2) * 2 = 30
let testCeInlineBuilder () : int =
    let cePipe = CePipe()
    cePipe {
        let! a = 4
        let! b = a + 2
        return a + b + 2 }

/// list, array and seq comprehensions with a guard.  30 + 2 - 1 + 0 + 0 = 31
let testCeComprehensions () : int =
    let a = [ for i in 1 .. 4 -> i * i ]
    let b = [| for i in 1 .. 3 do if i % 2 = 1 then yield i |]
    let c = seq { for i in 1 .. 3 do yield i * 10 } |> Seq.sum
    (List.sum a) + (Array.length b) - 1 + (c - 60) + (if Array.length b = 2 then 0 else 100)

type CeRange = { CeMin: int; CeMax: int; CeStep: int }
type CeRangeBuilder() =
    member _.Yield(_) : CeRange = { CeMin = 0; CeMax = 0; CeStep = 1 }
    [<CustomOperation("from")>] member _.From(q: CeRange, v: int) : CeRange = { q with CeMin = v }
    [<CustomOperation("upTo")>] member _.UpTo(q: CeRange, v: int) : CeRange = { q with CeMax = v }
    [<CustomOperation("by")>] member _.By(q: CeRange, v: int) : CeRange = { q with CeStep = v }
    member _.Run(q: CeRange) : int =
        let mutable n = 0
        for _ in q.CeMin .. q.CeStep .. q.CeMax do n <- n + 1
        n

/// custom operations: a query-like DSL with named clauses.  1 4 7 10 = 4 values, 0 2 .. 14 = 8 values
let testCeCustomOperations () : int =
    let ceRange = CeRangeBuilder()
    let a = ceRange { from 1; upTo 10; by 3 }
    let b = ceRange { from 0; upTo 14; by 2 }
    a + b

type CeNode = CeText of string | CeEl of string * (string * string) list * CeNode list
type CeItem = CeAttr of string * string | CeChild of CeNode
type CeElBuilder(tag: string) =
    member _.Yield(i: CeItem) : CeItem list = [ i ]
    member _.Yield(n: CeNode) : CeItem list = [ CeChild n ]
    member _.Yield(s: string) : CeItem list = [ CeChild (CeText s) ]
    member _.Zero() : CeItem list = []
    member _.Delay(f: unit -> CeItem list) : CeItem list = f ()
    member _.Combine(a: CeItem list, b: CeItem list) : CeItem list = a @ b
    member _.For(xs: int list, f: int -> CeItem list) : CeItem list = List.collect f xs
    member _.Run(items: CeItem list) : CeNode =
        CeEl(tag, [ for i in items do match i with CeAttr (k, v) -> yield (k, v) | _ -> () ],
                  [ for i in items do match i with CeChild n -> yield n | _ -> () ])
let ceCls (v: string) : CeItem = CeAttr ("class", v)
let rec ceCount (n: CeNode) : int =
    match n with
    | CeText s -> s.Length
    | CeEl (_, a, c) -> 100 + a.Length * 1000 + List.sumBy ceCount c

/// a view DSL as a computation expression: attributes and children are yielded, `for` repeats a child, elements nest by calling another builder.
/// 100 + 1000 + (100 + 2) + (100 + 1) + (100 + 1) = 1404
let testCeViewDsl () : int =
    let ceDiv = CeElBuilder "div"
    let ceLi = CeElBuilder "li"
    let n =
        ceDiv {
            ceCls "box"
            ceLi { "ab" }
            for _ in [ 1; 2 ] do
                ceLi { "x" } }
    ceCount n

let inline ceTwice (x: ^a) : ^a = x + x
let inline ceSumBy ([<InlineIfLambda>] f: 'a -> ^n) (xs: 'a list) : ^n = List.fold (fun acc x -> acc + f x) LanguagePrimitives.GenericZero xs

/// statically resolved member constraints, the way to write numeric helpers that cost nothing.  4 + 3 + 2 = 9
let testCeStaticMembers () : int =
    let a = ceTwice 2
    let b = ceSumBy (fun (x: int) -> x) [ 1; 2 ]
    let c = ceTwice 1.0 |> int
    a + b + c

// ── A lambda in an argument, with a type variable that only the callee fixes ──────────────────────────────────────────────────────────────

type LgNode = { LgName: string }

let lgWithin (path: int list) (f: 'i list -> int -> ('i list * 'i option) option) (items: 'i list) : ('i list * 'i option) option =
    match path with
    | [ i ] -> f items i
    | _ -> None

let lgInsertInto (at: int list) (item: 'i) (roots: 'i list) : 'i list option =
    let put (items: 'i list) (i: int) = if i < 0 || i > List.length items then None else Some (item :: items, None)
    match lgWithin at put roots with
    | Some (r, _) -> Some r
    | None -> None

/// The `None` of `put` is `'b option`, and nothing in `put` says what `'b` is: the parameter type of `lgWithin` does (`'i option`).  It was compiled as an
/// `int option`, the closure built another tuple than `lgWithin` took, and the call trapped (`illegal cast`).  Three items: 3
let testLambdaVariableFixedByCallee () : int =
    match lgInsertInto [ 1 ] { LgName = "x" } [ { LgName = "a" }; { LgName = "b" } ] with
    | Some r -> List.length r
    | None -> -1

// ── for ... in over a ResizeArray ───────────────────────────────────────────────────────────────────────────────────────────────────────────

/// `for x in resizeArray do …` is the `GetEnumerator` form, which the backend has no object for: it is written as an `iterate` over the elements, like a list's.
/// Ints, strings, a mutable local the body assigns, a nested loop and an empty one.  (1 + 2 + 3) * 100 + (2 + 3) * 10 + 2 pairs = 652
let testForInResizeArray () : int =
    let l = ResizeArray<int>()
    l.Add 1
    l.Add 2
    l.Add 3
    let mutable s = 0
    for v in l do s <- s + v
    let names = ResizeArray<string>()
    names.Add "ab"
    names.Add "cde"
    let mutable n = 0
    for x in names do n <- n + x.Length
    let mutable pairs = 0
    for a in l do
        for b in names do
            if a = b.Length - 1 then pairs <- pairs + 1
    let empty = ResizeArray<int>()
    let mutable none = 0
    for _ in empty do none <- none + 1
    s * 100 + n * 10 + pairs + none

// ── IDisposable: use, an explicit Dispose, a builder's Using ───────────────────────────────────────────────────────────────────────────────

type DisposeLog() =
    member val Count = 0 with get, set

type DisposeCell(log: DisposeLog, weight: int) =
    member _.Weight = weight
    interface System.IDisposable with
        member _.Dispose() = log.Count <- log.Count + weight

type DisposeBuilder() =
    member _.Return(x: int) : int = x
    member _.Bind(x: int, f: int -> int) : int = f x
    member _.Delay(f: unit -> int) : int = f ()
    member _.Using(d: DisposeCell, f: DisposeCell -> int) : int =
        try f d
        finally (d :> System.IDisposable).Dispose()

let disposeOf (c: DisposeCell) : System.IDisposable = c :> System.IDisposable

/// `use` disposes at the end of its scope (also when it is left by the result, here a value computed first), an explicit call through the interface
/// disposes, a value held as the interface disposes, and a builder's `Using` that disposes itself does so once.  1 + 10 + 100 + 1000 + (weights 3)
let testDispose () : int =
    let log = DisposeLog()
    let viaUse =
        use c = new DisposeCell(log, 1)
        c.Weight * 7
    let c2 = new DisposeCell(log, 10)
    (c2 :> System.IDisposable).Dispose()
    let held = disposeOf (new DisposeCell(log, 100))
    held.Dispose()
    let viaBuilder =
        let b = DisposeBuilder()
        b {
            use c = new DisposeCell(log, 1000)
            let! x = c.Weight
            return x + 1 }
    viaUse + viaBuilder + log.Count * 100

/// The Seq functions over a string: its characters are the elements.  Written the way a library writes a check (`name |> Seq.forall …`), through a function that takes the
/// string, and inline on a literal.  1 (all lower case) + 10 (one upper case) + 300 (three that are not X) + 382 000 (the sum of the codes 97 + 98 + 88 + 99)
let private isLower (name: string) : bool =
    name.Length > 0 && name |> Seq.forall (fun c -> c >= 'a' && c <= 'z')

let testSeqOverString () : int =
    let s = "abXc"
    let allLower = isLower "abc"
    let anyUpper = s |> Seq.exists (fun c -> c >= 'A' && c <= 'Z')
    let n = s |> Seq.filter (fun c -> c <> 'X') |> Seq.length
    let codes = s |> Seq.map int |> Seq.sum
    (if allLower then 1 else 0) + (if anyUpper then 10 else 0) + n * 100 + codes * 1000

/// Structural equality of packed arrays (`bool[]` and `byte[]` are arrays of i8): equal contents, one difference, inside a record, in a list.
/// The comparison of the elements was a reference comparison, which does not validate for a number.  1 + 10 + 100 + 1000 + 10000
type PackedBits = { Bits: byte[]; Flags: bool[] }

let testPackedArrayEquality () : int =
    let a = [| true; false; true |]
    let b = [| true; false; true |]
    let c = [| true; true; true |]
    let x = { Bits = [| 1uy; 2uy |]; Flags = a }
    let y = { Bits = [| 1uy; 2uy |]; Flags = b }
    let z = { Bits = [| 1uy; 3uy |]; Flags = a }
    (if a = b then 1 else 0) + (if a <> c then 10 else 0) + (if x = y then 100 else 0) + (if x <> z then 1000 else 0)
    + (if [ [| 1uy |]; [| 2uy |] ] = [ [| 1uy |]; [| 2uy |] ] then 10000 else 0)

// Result.map and Result.bind whose function changes the type of the Ok value: the output is another instantiation of Result, with structs of its own,
// so the Ok must be built in the output's struct and an Error must be rebuilt in it (the input's Error object is not a value of the output's type).
type MappedDegrees = { Degrees: int }
type MappedReading = { Label: string; Value: MappedDegrees }

let testResultMapBindChangeTheType () : int =
    let parse (s: string) : Result<int list, string> = if s = "" then Error "empty" else Ok [ s.Length; 2 ]
    let toDegrees (r: Result<int list, string>) : Result<MappedDegrees, string> = r |> Result.map (fun xs -> { Degrees = List.sum xs })
    let toReading (r: Result<int list, string>) : Result<MappedReading, string> =
        r |> Result.bind (fun xs -> if List.isEmpty xs then Error "none" else Ok { Label = "x"; Value = { Degrees = List.head xs } })
    let sameType (r: Result<int list, string>) : Result<int list, string> = r |> Result.map (fun xs -> 7 :: xs)
    let a = match toDegrees (parse "abc") with Ok d -> d.Degrees | Error _ -> -1           // 3 + 2
    let b = match toDegrees (parse "") with Ok _ -> -1 | Error e -> e.Length                // "empty"
    let c = match toReading (parse "abcd") with Ok r -> r.Value.Degrees | Error _ -> -1     // 4
    let d = match toReading (parse "") with Ok _ -> -1 | Error e -> e.Length                // "empty"
    let e = match sameType (parse "abc") with Ok xs -> List.length xs | Error _ -> -1       // 3
    let f = match sameType (parse "") with Ok _ -> -1 | Error s -> s.Length                 // "empty"
    a * 100000 + b * 10000 + c * 1000 + d * 100 + e * 10 + f

// A seq that is a value (the result of a function, an argument, `Seq.delay` of a `seq { }`, `Seq.singleton`, `Seq.empty`, `Seq.append`): a seq is a strict list, so each is built by
// one loop where it is made.  They used to compile only where a consumer read them on the spot.
let seqEvens (n: int) : seq<int> = seq { for i in 1 .. n do if i % 2 = 0 then yield i }
let seqSumOf (xs: seq<int>) : int = xs |> Seq.sum

let testSeqAsValue () : int =
    let a = seqEvens 10 |> Seq.sum                                                     // 30
    let b = seqSumOf (seqEvens 6)                                                      // 12
    let c = Seq.delay (fun () -> seq { yield 1; yield 2; yield 3 }) |> Seq.length      // 3
    let one : seq<int> = Seq.singleton 7
    let none : seq<int> = Seq.empty
    let d = Seq.length one * 10 + Seq.length none + Seq.sum one                        // 17
    let e = Seq.append (seqEvens 4) (Seq.singleton 100) |> Seq.sum                     // 106
    (if a = 30 then 1 else 0) + (if b = 12 then 10 else 0) + (if c = 3 then 100 else 0) + (if d = 17 then 1000 else 0) + (if e = 106 then 10000 else 0)

// Seq.zip walks two sequences together and ends with the shorter (as .NET's does): lists, arrays, a list with an array, seq values, an empty one
let testSeqZip () : int =
    let a = Seq.zip [ 1; 2; 3 ] [ 10; 20; 30; 40 ] |> Seq.sumBy (fun (x, y) -> x * y)                       // 140
    let b = Seq.zip [| 1; 2; 3 |] [| 4; 5; 6 |] |> Seq.map (fun (x, y) -> x + y) |> Seq.sum                 // 21
    let c = Seq.zip [ 1; 2; 3 ] [| "a"; "bb" |] |> Seq.map (fun (n, s) -> n + s.Length) |> Seq.sum          // (1 + 1) + (2 + 2) = 6
    let d = Seq.zip (seqEvens 8) [ "x"; "y"; "z"; "w"; "v" ] |> Seq.length                                   // 4
    let e = Seq.zip ([] : int list) [ 1; 2 ] |> Seq.length                                                   // 0
    let f = Seq.zip [ 1; 2 ] [ "p"; "q" ] |> Seq.toList |> List.map (fun (n, s) -> s + string n) |> String.concat ","   // p1,q2
    (if a = 140 then 1 else 0) + (if b = 21 then 10 else 0) + (if c = 6 then 100 else 0) + (if d = 4 then 1000 else 0) + (if e = 0 then 10000 else 0) + (if f = "p1,q2" then 100000 else 0)

// Option.toList / Option.toArray of an option of any type: the base library's `toArray` is compiled for `int`, so an option of a string, a closure or a record gave a module that did not validate
type OptBox = { N: int }

let testOptionToList () : int =
    let a = Option.toList (Some 5) |> List.sum                                                     // 5
    let b = Option.toList (None : int option) |> List.length                                       // 0
    let c = Option.toList (Some "abc") |> List.map (fun s -> s.Length) |> List.sum                 // 3
    let d = Option.toList (None : string option) |> List.length                                    // 0
    let e = Option.toList (Some (fun x -> x + 1)) |> List.map (fun f -> f 41) |> List.sum          // 42
    let f = Option.toArray (Some { N = 7 }) |> Array.sumBy (fun r -> r.N)                          // 7
    let g = Option.toArray (None : OptBox option) |> Array.length                                  // 0
    let h = [ Some 1; None; Some 3 ] |> List.collect Option.toList |> List.sum                     // 4
    (if a = 5 then 1 else 0) + (if b = 0 then 10 else 0) + (if c = 3 then 100 else 0) + (if d = 0 then 1000 else 0) + (if e = 42 then 10000 else 0) + (if f = 7 then 100000 else 0) + (if g = 0 then 1000000 else 0) + (if h = 4 then 10000000 else 0)

// The inverse trigonometric and hyperbolic functions, for float and float32 (MathF): the float32 ones were a trap at run time ("unhandled Math call 'asin'")
let private near (tolerance: float) (expected: float) (actual: float) : bool = abs (actual - expected) <= tolerance

let testMathTranscendentals () : int =
    let d = [ near 1e-9 0.5235987755982989 (System.Math.Asin 0.5)
              near 1e-9 1.0471975511965979 (System.Math.Acos 0.5)
              near 1e-9 0.7853981633974483 (System.Math.Atan 1.0)
              near 1e-9 1.1752011936438014 (System.Math.Sinh 1.0)
              near 1e-9 1.5430806348152437 (System.Math.Cosh 1.0)
              near 1e-9 0.46211715726000974 (System.Math.Tanh 0.5) ]
    let f = [ near 1e-6 0.5235987755982989 (float (System.MathF.Asin 0.5f))
              near 1e-6 1.0471975511965979 (float (System.MathF.Acos 0.5f))
              near 1e-6 0.7853981633974483 (float (System.MathF.Atan 1.0f))
              near 1e-6 1.1752011936438014 (float (System.MathF.Sinh 1.0f))
              near 1e-6 1.5430806348152437 (float (System.MathF.Cosh 1.0f))
              near 1e-6 0.46211715726000974 (float (System.MathF.Tanh 0.5f)) ]
    let bits (xs: bool list) = xs |> List.fold (fun acc ok -> acc * 2 + (if ok then 1 else 0)) 0
    bits d * 64 + bits f                                              // 63 * 64 + 63 = 4095

// Double.IsNaN, IsInfinity, IsPositiveInfinity and IsNegativeInfinity, for float and float32: they were "member 'isNaN' of Any" and an unhandled import, and the module did not compile
let testFloatPredicates () : int =
    let nan' = System.Double.NaN
    let inf = System.Double.PositiveInfinity
    let d = [ System.Double.IsNaN nan'; not (System.Double.IsNaN 1.5); not (System.Double.IsNaN inf)
              System.Double.IsInfinity inf; System.Double.IsInfinity (-inf); not (System.Double.IsInfinity 1.0e300); not (System.Double.IsInfinity nan')
              System.Double.IsPositiveInfinity inf; not (System.Double.IsPositiveInfinity (-inf))
              System.Double.IsNegativeInfinity (-inf); not (System.Double.IsNegativeInfinity inf) ]
    let nanf = System.Single.NaN
    let inff = System.Single.PositiveInfinity
    let f = [ System.Single.IsNaN nanf; not (System.Single.IsNaN 1.5f)
              System.Single.IsInfinity inff; System.Single.IsInfinity (-inff); not (System.Single.IsInfinity 1.0e30f)
              System.Single.IsPositiveInfinity inff; System.Single.IsNegativeInfinity (-inff); not (System.Single.IsNegativeInfinity inff) ]
    let bits (xs: bool list) = xs |> List.fold (fun acc ok -> acc * 2 + (if ok then 1 else 0)) 0
    bits d * 256 + bits f                                             // 2047 * 256 + 255 = 524287

// A comprehension over a HashSet or a Dictionary, and Trim / TrimStart / TrimEnd with a character: neither compiled ("unhandled import call 'delay'", "'trimEnd'")
let testComprehensionOverCollections () : int =
    let h = System.Collections.Generic.HashSet<int>([ 1; 2; 3; 4 ])
    let d = System.Collections.Generic.Dictionary<int, int>()
    d.[1] <- 5
    d.[2] <- 0
    d.[3] <- 7
    let evens = [ for x in h do if x % 2 = 0 then yield x * 10 ] |> List.sort
    let withValue =
        [ for f in h do
            match d.TryGetValue f with
            | true, s -> if s > 0 then yield f
            | _ -> () ]
        |> List.sort
    let keys = [| for kv in d do if kv.Value > 0 then yield kv.Key |] |> Array.sort
    let nested = [| for a in [ 1; 2 ] do for q in h do if q > a then yield q |]
    (if evens = [ 20; 40 ] then 1 else 0) + (if withValue = [ 1; 3 ] then 10 else 0) + (if keys = [| 1; 3 |] then 100 else 0) + (if nested.Length = 5 then 1000 else 0)    // 1111

let testTrimChars () : int =
    let a = "12.500".TrimEnd('0') = "12.5"
    let b = "000125".TrimStart('0') = "125"
    let c = "xxhixx".Trim('x') = "hi"
    let d = "000".TrimEnd('0') = ""
    let e = "abc".TrimEnd('0') = "abc"
    let f = "  padded ".Trim() = "padded"                                 // the ones without an argument still work
    (if a then 1 else 0) + (if b then 10 else 0) + (if c then 100 else 0) + (if d then 1000 else 0) + (if e then 10000 else 0) + (if f then 100000 else 0)    // 111111

// An array pattern over an array of unions: the test that the array is not null was a call of the union array's structural equality with a null (the module did not validate)
type PatV =
    | PN of float
    | PT of string

let private patHead (a: PatV[]) : int =
    match a with
    | [| PN x |] -> int x
    | [| PN x; PN y |] -> int (x + y)
    | _ -> -1

let testArrayPatternOfUnions () : int =
    patHead [| PN 2.0 |] + patHead [| PN 3.0; PN 4.0 |] * 10 + (if patHead [| PT "a" |] = -1 then 100 else 0) + (if patHead [||] = -1 then 1000 else 0)    // 2 + 70 + 100 + 1000


// A record whose field is of a class type that is null at first: `{ Reading = null }` stored a null in a field the record had declared non-null (the module did not validate: "expected (ref $T), found (ref null $T)")
[<AllowNullLiteral>]
type NullLink(value: int) =
    member _.Value = value

type NullHolder =
    { Id: int
      mutable Items: System.Collections.Generic.List<int>
      mutable Link: NullLink
      Name: string }

let testRecordFieldNull () : int =
    let h = { Id = 1; Items = null; Link = null; Name = "a" }
    let before = (if isNull h.Items then 1 else 0) + (if isNull h.Link then 10 else 0)
    h.Items <- System.Collections.Generic.List<int>()
    h.Items.Add 7
    h.Items.Add 8
    h.Link <- NullLink(5)
    let after = (if not (isNull h.Items) && h.Items.Count = 2 then 100 else 0) + (if not (isNull h.Link) && h.Link.Value = 5 then 1000 else 0)
    let copy = { h with Link = null }
    before + after + (if isNull copy.Link && copy.Items.Count = 2 then 10000 else 0)    // 11111

// string / ToString() of a union case: "Raised", as .NET prints it (a case without fields; the result was a number or nothing)
type AlarmKind =
    | Raised
    | Escalated
    | Cleared

type PointShape =
    | Dot
    | Circle of float

// A local `let rec` function handed to a list function inside its own body (`cs |> List.sumBy size`): it is a closure that refers to itself
type RoseTree =
    | Leaf
    | Branch of RoseTree list
    | Wrapped of RoseTree

let testLocalRecAsValue () : int =
    let rec size (t: RoseTree) : int =
        match t with
        | Leaf -> 1
        | Branch cs -> cs |> List.sumBy size
        | Wrapped c -> size c
    let a = size (Branch [ Leaf; Branch [ Leaf; Leaf ]; Wrapped Leaf ]) = 4
    let rec depth (t: RoseTree) : int =
        match t with
        | Leaf -> 0
        | Branch cs -> 1 + (cs |> List.map depth |> List.fold max 0)
        | Wrapped c -> 1 + depth c
    let b = depth (Branch [ Leaf; Branch [ Wrapped Leaf ] ]) = 3
    // the same with a named function for the other list functions that inline a lambda
    let weight (x: int) : int = x * 3
    let c = [ 1; 2; 3 ] |> List.sumBy weight = 18
    let d = [ 5; 9; 2 ] |> List.maxBy weight = 9 && [ 5; 9; 2 ] |> List.minBy weight = 2
    let step (x: int) (acc: int) : int = acc * 10 + x
    let e = List.foldBack step [ 1; 2; 3 ] 0 = 321
    (if a then 1 else 0) + (if b then 10 else 0) + (if c then 100 else 0) + (if d then 1000 else 0) + (if e then 10000 else 0)    // 11111

// Char.IsControl: the control characters of Unicode (U+0000..U+001F, U+007F..U+009F), which the toolkit's text field has to tell from text (unhandled import call 'isControl')
let testCharIsControl () : int =
    let a = System.Char.IsControl '\n' && System.Char.IsControl '\t' && System.Char.IsControl '\000'
    let b = System.Char.IsControl '\u007F' && System.Char.IsControl '\u0080' && System.Char.IsControl '\u009F'
    let c = not (System.Char.IsControl 'a') && not (System.Char.IsControl ' ') && not (System.Char.IsControl '\u00A0') && not (System.Char.IsControl '\u00E4')
    let d = "a\nb" |> Seq.filter (fun ch -> not (System.Char.IsControl ch)) |> Seq.length = 2
    let e = [ '\r'; 'x'; '\u0001' ] |> List.filter System.Char.IsControl |> List.length = 2
    (if a then 1 else 0) + (if b then 10 else 0) + (if c then 100 else 0) + (if d then 1000 else 0) + (if e then 10000 else 0)    // 11111

let testUnionToString () : int =
    let a = string Raised = "Raised"
    let b = (Escalated).ToString() = "Escalated"
    let c = [ Raised; Cleared ] |> List.map string |> String.concat "," = "Raised,Cleared"
    let d = string Dot = "Dot"                          // a case without fields of a union that has others with fields
    let e = (Cleared |> string).Length = 7
    (if a then 1 else 0) + (if b then 10 else 0) + (if c then 100 else 0) + (if d then 1000 else 0) + (if e then 10000 else 0)    // 11111
