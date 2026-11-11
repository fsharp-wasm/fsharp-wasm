/// Records, discriminated unions, tuples and options.  Values are built from ints so the generated inputs reach
/// them; results are ints / bools.  Same rules as Props.fs (total functions; raising is fine on both sides).
module PropsData

type P = { X: int; Y: int }
type Shape =
    | Circle of int
    | Rect of int * int
    | Empty

type Tree =
    | Leaf
    | Node of Tree * int * Tree

let private shape (a: int) (b: int) : Shape =
    match ((a % 3) + 3) % 3 with
    | 0 -> Circle b
    | 1 -> Rect(a, b)
    | _ -> Empty

let rec private insert (t: Tree) (v: int) : Tree =
    match t with
    | Leaf -> Node(Leaf, v, Leaf)
    | Node(l, x, r) -> if v < x then Node(insert l v, x, r) elif v > x then Node(l, x, insert r v) else t

let rec private sum (t: Tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, x, r) -> sum l + x + sum r

let rec private depth (t: Tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, _, r) -> 1 + max (depth l) (depth r)

// ── records ─────────────────────────────────────────────────────────────────────────────────────
let prop_d_recEq (a: int) (b: int) : bool = { X = a; Y = b } = { X = b; Y = a }
let prop_d_recNe (a: int) (b: int) : bool = { X = a; Y = b } <> { X = a; Y = b + 1 }
let prop_d_recCompare (a: int) (b: int) : int = sign (compare { X = a; Y = b } { X = b; Y = a })
let prop_d_recUpdate (a: int) (b: int) : int = let p = { X = a; Y = b } in let q = { p with Y = a + b } in q.X + q.Y * 3
let prop_d_recFields (a: int) (b: int) : int = let p = { X = a; Y = b } in p.X - p.Y
let prop_d_recLt (a: int) (b: int) : bool = { X = a; Y = b } < { X = b; Y = a }

// ── unions ──────────────────────────────────────────────────────────────────────────────────────
let prop_d_unionArea (a: int) (b: int) : int =
    match shape a b with
    | Circle r -> r * r
    | Rect(w, h) -> w * h
    | Empty -> -1
let prop_d_unionEq (a: int) (b: int) : bool = shape a b = shape b a
let prop_d_unionCompare (a: int) (b: int) : int = sign (compare (shape a b) (shape b a))
let prop_d_unionIsCircle (a: int) (b: int) : bool = match shape a b with Circle _ -> true | _ -> false
let prop_d_unionGuard (a: int) (b: int) : int =
    match shape a b with
    | Circle r when r > 10 -> 1
    | Circle _ -> 2
    | Rect(w, _) when w < 0 -> 3
    | Rect _ -> 4
    | Empty -> 5

// ── recursive unions ────────────────────────────────────────────────────────────────────────────
let prop_d_treeSum (a: int) (b: int) : int = [ a; b; a + b; a - b; b * 2 ] |> List.fold insert Leaf |> sum
let prop_d_treeDepth (a: int) (b: int) : int = [ a; b; a + b; a - b; b * 2; a * 3 ] |> List.fold insert Leaf |> depth

// ── tuples ──────────────────────────────────────────────────────────────────────────────────────
let prop_d_tupleSwap (a: int) (b: int) : int = let (x, y) = (b, a) in x - y
let prop_d_tupleEq (a: int) (b: int) : bool = (a, b) = (b, a)
let prop_d_tupleCompare (a: int) (b: int) : int = sign (compare (a, b) (b, a))
let prop_d_tupleNested (a: int) (b: int) : int = let ((x, y), z) = ((a, b), a + b) in x * y - z
let prop_d_fst (a: int) (b: int) : int = fst (a, b) + snd (b, a) * 2

// ── options ─────────────────────────────────────────────────────────────────────────────────────
let private opt (a: int) (b: int) : int option = if a % 2 = 0 then Some b else None
let prop_d_optDefault (a: int) (b: int) : int = defaultArg (opt a b) -1
let prop_d_optMap (a: int) (b: int) : int = opt a b |> Option.map (fun v -> v * 3) |> Option.defaultValue 0
let prop_d_optBind (a: int) (b: int) : int = opt a b |> Option.bind (fun v -> if v > 0 then Some(v * 2) else None) |> Option.defaultValue -1
let prop_d_optIsSome (a: int) (b: int) : bool = Option.isSome (opt a b)
let prop_d_optEq (a: int) (b: int) : bool = opt a b = opt b a
let prop_d_optFilter (a: int) (b: int) : int = opt a b |> Option.filter (fun v -> v > 5) |> Option.defaultValue 0
let prop_d_optMatch (a: int) (b: int) : int = match opt a b with Some v when v > 0 -> v | Some v -> -v | None -> 0
let prop_d_optCompare (a: int) (b: int) : int = sign (compare (opt a b) (opt b a))
