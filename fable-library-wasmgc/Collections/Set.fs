/// fable-library-wasmgc — Set collection.
/// Written in pure F# — compiled by the WasmGC Fable backend.
/// Int-only BST (same strategy as Map.fs).
module SetModule

// ─── Data type ───────────────────────────────────────────────────────────────

type SetNode =
    | Empty
    | Node of int * SetNode * SetNode
    //         value  left     right

// ─── Public API ──────────────────────────────────────────────────────────────

/// Empty set.
let empty () : SetNode = Empty

/// True when the set has no elements.
let isEmpty (tree: SetNode) : bool =
    match tree with
    | Empty -> true
    | _ -> false

/// Add an element.
let rec add (value: int) (tree: SetNode) : SetNode =
    match tree with
    | Empty -> Node(value, Empty, Empty)
    | Node(v, l, r) ->
        if value < v then Node(v, add value l, r)
        elif value > v then Node(v, l, add value r)
        else tree  // already present

/// Check if element is present.
let rec contains (value: int) (tree: SetNode) : bool =
    match tree with
    | Empty -> false
    | Node(v, l, r) ->
        if value < v then contains value l
        elif value > v then contains value r
        else true

/// Helper: merge two subtrees by inserting all elements of source into target.
let rec private setMergeInto (source: SetNode) (target: SetNode) : SetNode =
    match source with
    | Empty -> target
    | Node(sv, sl, sr) ->
        setMergeInto sr (setMergeInto sl (add sv target))

/// Remove an element by rebuilding without it.
let rec remove (value: int) (tree: SetNode) : SetNode =
    match tree with
    | Empty -> Empty
    | Node(v, l, r) ->
        if value < v then Node(v, remove value l, r)
        elif value > v then Node(v, l, remove value r)
        else setMergeInto r l

/// Total number of elements.
let rec count (tree: SetNode) : int =
    match tree with
    | Empty -> 0
    | Node(_, l, r) -> 1 + count l + count r

/// Convert to a list in ascending order.
let rec private toListAcc (acc: int list) (n: SetNode) : int list =
    match n with
    | Empty -> acc
    | Node(v, l, r) -> toListAcc (v :: toListAcc acc r) l

let toList (node: SetNode) : int list = toListAcc [] node

/// Fold over all elements in ascending order (left → root → right).
let rec fold (folder: int -> int -> int) (state: int) (node: SetNode) : int =
    match node with
    | Empty -> state
    | Node(v, l, r) ->
        let s1 = fold folder state l
        let s2 = folder s1 v
        fold folder s2 r

/// Iterate over all elements in ascending order.
let rec iter (action: int -> unit) (node: SetNode) : unit =
    match node with
    | Empty -> ()
    | Node(v, l, r) ->
        iter action l
        action v
        iter action r

/// Filter elements by predicate, rebuilding the tree.
let rec filter (predicate: int -> bool) (node: SetNode) : SetNode =
    match node with
    | Empty -> Empty
    | Node(v, l, r) ->
        let fl = filter predicate l
        let fr = filter predicate r
        if predicate v then Node(v, fl, fr)
        else setMergeInto fr fl

/// Check if any element satisfies the predicate.
let rec exists (predicate: int -> bool) (node: SetNode) : bool =
    match node with
    | Empty -> false
    | Node(v, l, r) ->
        if predicate v then true
        elif exists predicate l then true
        else exists predicate r

/// Check if all elements satisfy the predicate.
let rec forAll (predicate: int -> bool) (node: SetNode) : bool =
    match node with
    | Empty -> true
    | Node(v, l, r) ->
        if not (predicate v) then false
        elif not (forAll predicate l) then false
        else forAll predicate r

/// Union of two sets.
let rec union (a: SetNode) (b: SetNode) : SetNode =
    match a with
    | Empty -> b
    | Node(v, l, r) ->
        union r (union l (add v b))

/// Intersection of two sets — keep elements from a that exist in b.
let rec private intersectAcc (b: SetNode) (node: SetNode) (acc: SetNode) : SetNode =
    match node with
    | Empty -> acc
    | Node(v, l, r) ->
        let acc1 = intersectAcc b l acc
        let acc2 = if contains v b then add v acc1 else acc1
        intersectAcc b r acc2

let intersect (a: SetNode) (b: SetNode) : SetNode =
    intersectAcc b a Empty

/// Difference: elements in a but not in b.
let rec private differenceAcc (b: SetNode) (node: SetNode) (acc: SetNode) : SetNode =
    match node with
    | Empty -> acc
    | Node(v, l, r) ->
        let acc1 = differenceAcc b l acc
        let acc2 = if contains v b then acc1 else add v acc1
        differenceAcc b r acc2

let difference (a: SetNode) (b: SetNode) : SetNode =
    differenceAcc b a Empty

/// Check if a is a subset of b.
/// Check whether a is a subset of b (every element of a is in b).
let rec isSubset (a: SetNode) (b: SetNode) : bool =
    match a with
    | Empty -> true
    | Node(v, l, r) ->
        contains v b && isSubset l b && isSubset r b

/// Build a set from a list.
let rec private ofListAcc (acc: SetNode) (xs: int list) : SetNode =
    match xs with
    | [] -> acc
    | x :: rest -> ofListAcc (add x acc) rest

let ofList (xs: int list) : SetNode = ofListAcc Empty xs

/// Build a set from an array.
let ofArray (xs: int array) : SetNode =
    Array.fold (fun acc x -> add x acc) Empty xs

/// Singleton set.
let singleton (x: int) : SetNode = Node(x, Empty, Empty)

/// Map elements through a function, building a new set.
/// Top-level helper avoids closure-capture in nested let rec.
let rec private mapAcc (mapping: int -> int) (lst: int list) (acc: SetNode) : SetNode =
    match lst with
    | [] -> acc
    | x :: rest -> mapAcc mapping rest (add (mapping x) acc)

let map (mapping: int -> int) (node: SetNode) : SetNode =
    mapAcc mapping (toList node) Empty

/// Minimum element (in-order traversal: leftmost node).
let rec minElement (node: SetNode) : int =
    match node with
    | Empty -> failwith "Set is empty"
    | Node(v, l, _) ->
        if isEmpty l then v
        else minElement l

/// Maximum element (in-order traversal: rightmost node).
let rec maxElement (node: SetNode) : int =
    match node with
    | Empty -> failwith "Set is empty"
    | Node(v, _, r) ->
        if isEmpty r then v
        else maxElement r
