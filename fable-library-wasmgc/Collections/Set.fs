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
let toList (node: SetNode) : int list =
    let rec go (acc: int list) (n: SetNode) : int list =
        match n with
        | Empty -> acc
        | Node(v, l, r) -> go (v :: go acc r) l
    go [] node

/// Build a set from a list.
let rec private ofListAcc (acc: SetNode) (xs: int list) : SetNode =
    match xs with
    | [] -> acc
    | x :: rest -> ofListAcc (add x acc) rest

let ofList (xs: int list) : SetNode = ofListAcc Empty xs
