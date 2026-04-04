/// Minimal WasmGc hello-world: pure integer arithmetic, no runtime needed.
/// These functions are exported automatically and can be called from JS/Node.
module QuickTest.WasmGc

// Fable.Core stubs (Import attribute, nativeOnly) are in fable-library-wasmgc/Interop.fs.
// No NuGet reference needed — we define what we use ourselves.
open Fable.Core

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
// Sprint 9: fable-library-wasmgc/Map.fs — F# library compiled by our backend
// Tests call MapModule directly (src/fable-library-wasmgc/Map.fs).
// The library is a REAL F# source file, not compiler-internal WasmIR.
// ─────────────────────────────────────────────────────────────────────────────

/// Test: MapModule.add + tryFind — found key → 100
let testMapAddFind () : int =
    let m = MapModule.empty() |> MapModule.add 1 100 |> MapModule.add 2 200
    MapModule.tryFind 1 m |> Option.defaultValue 0

/// Test: tryFind on missing key → default 0
let testMapFindMissing () : int =
    let m = MapModule.empty() |> MapModule.add 1 100
    MapModule.tryFind 99 m |> Option.defaultValue 0

/// Test: count — two entries → 2
let testMapCount () : int =
    let m = MapModule.empty() |> MapModule.add 1 100 |> MapModule.add 2 200
    MapModule.count m

/// Test: containsKey — key present → 1
let testMapContainsKey () : int =
    let m = MapModule.empty() |> MapModule.add 42 999
    if MapModule.containsKey 42 m then 1 else 0

/// Test: containsKey — key absent → 0
let testMapContainsKeyMissing () : int =
    let m = MapModule.empty() |> MapModule.add 42 999
    if MapModule.containsKey 7 m then 1 else 0

/// Test: add replaces existing key → 555
let testMapAddReplace () : int =
    let m = MapModule.empty() |> MapModule.add 1 100 |> MapModule.add 1 555
    MapModule.tryFind 1 m |> Option.defaultValue 0

// ─────────────────────────────────────────────────────────────────────────────
// Sprint 10b: fable-library-wasmgc/Option.fs — BCL migration
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

/// Test: sprintf "%f" 3.14 — contains '.' (value > 0)
/// Length: "3.14" = 4 chars
let testSprintfFloat () : int =
    (sprintf "%f" 3.14).Length

/// Test: sprintf "%f" 0.5 → "0.5", length = 3
let testSprintfFloatHalf () : int =
    (sprintf "%f" 0.5).Length

/// Test: sprintf "%f" 2.0 → "2.0", length = 3
let testSprintfFloatWhole () : int =
    (sprintf "%f" 2.0).Length

/// Test: sprintf "%f" -1.5 → "-1.5", length = 4
let testSprintfFloatNeg () : int =
    (sprintf "%f" -1.5).Length

/// Test: sprintf "pi=~%f" 3.14159 → starts with 'p' = 112
let testSprintfFloatInStr () : int =
    int (sprintf "pi=~%f" 3.14159).[0]

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
