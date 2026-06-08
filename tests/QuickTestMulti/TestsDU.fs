/// DU (Discriminated Unions) domain tests
/// Types: Direction (enum), Shape (data-carrying), Tree (recursive)
module QuickTestWasmGc.TestsDU

open QuickTestWasmGc.Preamble
open Fable.Core

// ─── Direction: enum-like DU ───────────────────────────────────────

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

// ─── Shape: data-carrying DU ───────────────────────────────────────

type Shape =
    | Circle of float
    | Square of float
    | Rectangle of float * float

let shapeArea (s: Shape) : float =
    match s with
    | Circle r -> r * r
    | Square s -> s * s
    | Rectangle(w, h) -> w * h

let shapePerimeter (s: Shape) : float =
    match s with
    | Circle r -> 4.0 * r
    | Square s -> 4.0 * s
    | Rectangle(w, h) -> 2.0 * w + 2.0 * h

let testShapeAreaCircle (r: float) : float = shapeArea (Circle r)
let testShapeAreaSquare (s: float) : float = shapeArea (Square s)
let testShapeAreaRect (w: float) (h: float) : float = shapeArea (Rectangle(w, h))
let testShapePerimCircle (r: float) : float = shapePerimeter (Circle r)
let testShapePerimSquare (s: float) : float = shapePerimeter (Square s)
let testShapePerimRect (w: float) (h: float) : float = shapePerimeter (Rectangle(w, h))

// ─── Tree: recursive DU ────────────────────────────────────────────

type Tree = Leaf | Node of Tree * Tree * int

let rec treeSum (t: Tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, r, v) -> treeSum l + treeSum r + v

let testTreeSum () : int =
    let t = Node(Leaf, Leaf, 5)
    treeSum t  // 5

let testTreeSum2 () : int =
    let t = Node(Node(Leaf, Leaf, 2), Node(Leaf, Leaf, 3), 10)
    treeSum t  // 2 + 3 + 10 = 15

// ─── GeoShape: another DU with pattern matching ─────────────────

type GeoShape =
    | Circle2 of float
    | Rect2 of float * float
    | Dot2 of float * float

let testRefTestCircle () : int =
    let s = Circle2 1.5
    match s with
    | Circle2 _ -> 1
    | _ -> 0

let testRefTestRect () : int =
    let s = Rect2(2.0, 3.0)
    match s with
    | Rect2 _ -> 1
    | _ -> 0

let testRefTestDot () : int =
    let s = Dot2(1.0, 2.0)
    match s with
    | Dot2 _ -> 1
    | _ -> 0

// ─── MathExpr: recursive evaluation ─────────────────────────────

type MathExpr =
    | NumLit of int
    | Add of MathExpr * MathExpr
    | Mul of MathExpr * MathExpr

let rec evalExpr = function
    | NumLit x -> x
    | Add(l, r) -> evalExpr l + evalExpr r
    | Mul(l, r) -> evalExpr l * evalExpr r

let testRecursiveDU () : int =
    let expr = Add(Mul(NumLit 2, NumLit 3), NumLit 4)
    evalExpr expr  // (2*3) + 4 = 10

// ─── DU equality tests ──────────────────────────────────────────

let testDuEnumEqTrue () : int =
    let d1 = North
    let d2 = North
    if d1 = d2 then 1 else 0

let testDuEnumEqFalse () : int =
    let d1 = North
    let d2 = South
    if d1 = d2 then 1 else 0

let testDuDataEqTrue () : int =
    let s1 = Circle 3.0
    let s2 = Circle 3.0
    if s1 = s2 then 1 else 0

let testDuDataEqFalse () : int =
    let s1 = Circle 3.0
    let s2 = Circle 5.0
    if s1 = s2 then 1 else 0

let testDuDataEqDiffCtor () : int =
    let s1 = Circle 3.0
    let s2 = Square 3.0
    if s1 = s2 then 1 else 0

// ─── Suite runner ──────────────────────────────────────────────

let runDUTests (check: string -> (unit -> unit) -> unit) : unit =
    check "testShapeAreaCircle" (fun () -> ignore (testShapeAreaCircle 3.0))
    check "testShapeAreaSquare" (fun () -> ignore (testShapeAreaSquare 2.0))
    check "testShapeAreaRect" (fun () -> ignore (testShapeAreaRect 2.0 3.0))
    check "testShapePerimCircle" (fun () -> ignore (testShapePerimCircle 1.0))
    check "testShapePerimSquare" (fun () -> ignore (testShapePerimSquare 2.0))
    check "testShapePerimRect" (fun () -> ignore (testShapePerimRect 2.0 3.0))
    check "testTreeSum" (fun () -> ignore (testTreeSum ()))
    check "testTreeSum2" (fun () -> ignore (testTreeSum2 ()))
    check "testRefTestCircle" (fun () -> ignore (testRefTestCircle ()))
    check "testRefTestRect" (fun () -> ignore (testRefTestRect ()))
    check "testRefTestDot" (fun () -> ignore (testRefTestDot ()))
    check "testRecursiveDU" (fun () -> ignore (testRecursiveDU ()))
    check "testDuEnumEqTrue" (fun () -> ignore (testDuEnumEqTrue ()))
    check "testDuEnumEqFalse" (fun () -> ignore (testDuEnumEqFalse ()))
    check "testDuDataEqTrue" (fun () -> ignore (testDuDataEqTrue ()))
    check "testDuDataEqFalse" (fun () -> ignore (testDuDataEqFalse ()))
    check "testDuDataEqDiffCtor" (fun () -> ignore (testDuDataEqDiffCtor ()))
