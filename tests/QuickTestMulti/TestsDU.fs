module QuickTestWasmGc.TestsDU

open QuickTestWasmGc.Preamble
open WasmGc.Core

// ── DU (32 tests) ───────────────────────────────────────

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

let testActivePattern () : int =
    let classify n = match n with Even -> 0 | Odd -> 1
    [1; 2; 3; 4; 5] |> List.sumBy classify  // 1+0+1+0+1 = 3

// ── Sprint 23f: string ops, sprintf, more collections ────────────────────────


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

// ── Suite runner ──────────────────────────────────────────────────────────
let runDUTests (check: string -> (unit -> unit) -> unit) =
    check "testShapeAreaCircle" testShapeAreaCircle
    check "testShapeAreaSquare" testShapeAreaSquare
    check "testShapeAreaRect" testShapeAreaRect
    check "testShapePerimCircle" testShapePerimCircle
    check "testShapePerimSquare" testShapePerimSquare
    check "testShapePerimRect" testShapePerimRect
    check "testTreeSum" testTreeSum
    check "testTreeSum2" testTreeSum2
    check "testMutualTailCall" testMutualTailCall
    check "testMutualTailCall2" testMutualTailCall2
    check "testDuEnumEqTrue" testDuEnumEqTrue
    check "testDuEnumEqFalse" testDuEnumEqFalse
    check "testDuDataEqTrue" testDuDataEqTrue
    check "testDuDataEqFalse" testDuDataEqFalse
    check "testDuDataEqDiffCtor" testDuDataEqDiffCtor
    check "testTupleEqTrue" testTupleEqTrue
    check "testTupleEqFalse" testTupleEqFalse
    check "testTupleNeq" testTupleNeq
    check "testInterfaceDispatch" testInterfaceDispatch
    check "testInterfacePolymorphism" testInterfacePolymorphism
    check "testDuInterfaceCircle" testDuInterfaceCircle
    check "testDuInterfaceRect" testDuInterfaceRect
    check "testDuInterfacePoly" testDuInterfacePoly
    check "testClassCircleArea" testClassCircleArea
    check "testClassRectArea" testClassRectArea
    check "testMixedShapes" testMixedShapes
    check "testSortWith" testSortWith
    check "testSortWithDesc" testSortWithDesc
    check "testSortWithInts" testSortWithInts
    check "testActivePattern" testActivePattern
    check "testMutualLetRec" testMutualLetRec
    check "testMutualLetRecPingPong" testMutualLetRecPingPong
