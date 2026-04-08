/// fable-library-wasmgc — Generic Set collection.
/// Written in pure F# — compiled by the WasmGC Fable backend.
/// Supports any element type ('T) comparable via a provided cmp function.
/// The comparison function is stored in the SetHandle wrapper.
module SetModule

// ─── Internal tree node ──────────────────────────────────────────────────────

type SetNode<'T> =
    | Empty
    | Node of value: 'T * left: SetNode<'T> * right: SetNode<'T>
    //         ───────   ────────────────────  ────────────────────

// ─── Set handle ──────────────────────────────────────────────────────────────

type SetHandle<'T> =
    { Root: SetNode<'T>; Cmp: 'T -> 'T -> int }

// ─── Internal tree operations ────────────────────────────────────────────────

let rec private nodeAdd (cmp: 'T -> 'T -> int) (value: 'T) (node: SetNode<'T>) : SetNode<'T> =
    match node with
    | Empty -> Node(value, Empty, Empty)
    | Node(v, l, r) ->
        let c = cmp value v
        if c < 0 then Node(v, nodeAdd cmp value l, r)
        elif c > 0 then Node(v, l, nodeAdd cmp value r)
        else node  // already present

let rec private nodeContains (cmp: 'T -> 'T -> int) (value: 'T) (node: SetNode<'T>) : bool =
    match node with
    | Empty -> false
    | Node(v, l, r) ->
        let c = cmp value v
        if c < 0 then nodeContains cmp value l
        elif c > 0 then nodeContains cmp value r
        else true

let rec private nodeMergeInto (cmp: 'T -> 'T -> int) (source: SetNode<'T>) (target: SetNode<'T>) : SetNode<'T> =
    match source with
    | Empty -> target
    | Node(sv, sl, sr) ->
        nodeMergeInto cmp sr (nodeMergeInto cmp sl (nodeAdd cmp sv target))

let rec private nodeRemove (cmp: 'T -> 'T -> int) (value: 'T) (node: SetNode<'T>) : SetNode<'T> =
    match node with
    | Empty -> Empty
    | Node(v, l, r) ->
        let c = cmp value v
        if c < 0 then Node(v, nodeRemove cmp value l, r)
        elif c > 0 then Node(v, l, nodeRemove cmp value r)
        else nodeMergeInto cmp r l

let rec private nodeFold (folder: 'S -> 'T -> 'S) (state: 'S) (node: SetNode<'T>) : 'S =
    match node with
    | Empty -> state
    | Node(v, l, r) ->
        let s1 = nodeFold folder state l
        let s2 = folder s1 v
        nodeFold folder s2 r

let rec private nodeIter (action: 'T -> unit) (node: SetNode<'T>) : unit =
    match node with
    | Empty -> ()
    | Node(v, l, r) ->
        nodeIter action l
        action v
        nodeIter action r

let rec private nodeFilter (cmp: 'T -> 'T -> int) (predicate: 'T -> bool) (node: SetNode<'T>) : SetNode<'T> =
    match node with
    | Empty -> Empty
    | Node(v, l, r) ->
        let fl = nodeFilter cmp predicate l
        let fr = nodeFilter cmp predicate r
        if predicate v then Node(v, fl, fr)
        else nodeMergeInto cmp fr fl

let rec private nodeExists (predicate: 'T -> bool) (node: SetNode<'T>) : bool =
    match node with
    | Empty -> false
    | Node(v, l, r) ->
        if predicate v then true
        elif nodeExists predicate l then true
        else nodeExists predicate r

let rec private nodeForAll (predicate: 'T -> bool) (node: SetNode<'T>) : bool =
    match node with
    | Empty -> true
    | Node(v, l, r) ->
        if not (predicate v) then false
        elif not (nodeForAll predicate l) then false
        else nodeForAll predicate r

let rec private nodeUnion (cmp: 'T -> 'T -> int) (a: SetNode<'T>) (b: SetNode<'T>) : SetNode<'T> =
    match a with
    | Empty -> b
    | Node(v, l, r) ->
        nodeUnion cmp r (nodeUnion cmp l (nodeAdd cmp v b))

let rec private nodeIntersectAcc (cmp: 'T -> 'T -> int) (b: SetNode<'T>) (node: SetNode<'T>) (acc: SetNode<'T>) : SetNode<'T> =
    match node with
    | Empty -> acc
    | Node(v, l, r) ->
        let acc1 = nodeIntersectAcc cmp b l acc
        let acc2 = if nodeContains cmp v b then nodeAdd cmp v acc1 else acc1
        nodeIntersectAcc cmp b r acc2

let rec private nodeDifferenceAcc (cmp: 'T -> 'T -> int) (b: SetNode<'T>) (node: SetNode<'T>) (acc: SetNode<'T>) : SetNode<'T> =
    match node with
    | Empty -> acc
    | Node(v, l, r) ->
        let acc1 = nodeDifferenceAcc cmp b l acc
        let acc2 = if nodeContains cmp v b then acc1 else nodeAdd cmp v acc1
        nodeDifferenceAcc cmp b r acc2

let rec private nodeIsSubset (cmp: 'T -> 'T -> int) (a: SetNode<'T>) (b: SetNode<'T>) : bool =
    match a with
    | Empty -> true
    | Node(v, l, r) ->
        nodeContains cmp v b && nodeIsSubset cmp l b && nodeIsSubset cmp r b

let rec private nodeToListAcc (acc: 'T list) (node: SetNode<'T>) : 'T list =
    match node with
    | Empty -> acc
    | Node(v, l, r) -> nodeToListAcc (v :: nodeToListAcc acc r) l

let rec private nodeMinElement (node: SetNode<'T>) : 'T =
    match node with
    | Empty -> failwith "Set is empty"
    | Node(v, l, _) ->
        match l with
        | Empty -> v
        | _ -> nodeMinElement l

let rec private nodeMaxElement (node: SetNode<'T>) : 'T =
    match node with
    | Empty -> failwith "Set is empty"
    | Node(v, _, r) ->
        match r with
        | Empty -> v
        | _ -> nodeMaxElement r

// ─── Public API (operates on SetHandle) ──────────────────────────────────────

/// Create an empty set with the given comparison function.
let empty (cmp: 'T -> 'T -> int) : SetHandle<'T> =
    { Root = Empty; Cmp = cmp }

/// True when the set has no elements.
let isEmpty (s: SetHandle<'T>) : bool =
    match s.Root with Empty -> true | _ -> false

/// Add an element.
let add (value: 'T) (s: SetHandle<'T>) : SetHandle<'T> =
    { s with Root = nodeAdd s.Cmp value s.Root }

/// Check if element is present.
let contains (value: 'T) (s: SetHandle<'T>) : bool =
    nodeContains s.Cmp value s.Root

/// Remove an element.
let remove (value: 'T) (s: SetHandle<'T>) : SetHandle<'T> =
    { s with Root = nodeRemove s.Cmp value s.Root }

/// Total number of elements.
let count (s: SetHandle<'T>) : int =
    nodeFold (fun n _ -> n + 1) 0 s.Root

/// Fold over all elements in ascending order.
let fold (folder: 'S -> 'T -> 'S) (state: 'S) (s: SetHandle<'T>) : 'S =
    nodeFold folder state s.Root

/// Iterate over all elements in ascending order.
let iter (action: 'T -> unit) (s: SetHandle<'T>) : unit =
    nodeIter action s.Root

/// Filter elements by predicate.
let filter (predicate: 'T -> bool) (s: SetHandle<'T>) : SetHandle<'T> =
    { s with Root = nodeFilter s.Cmp predicate s.Root }

/// Check if any element satisfies the predicate.
let exists (predicate: 'T -> bool) (s: SetHandle<'T>) : bool =
    nodeExists predicate s.Root

/// Check if all elements satisfy the predicate.
let forAll (predicate: 'T -> bool) (s: SetHandle<'T>) : bool =
    nodeForAll predicate s.Root

/// Map elements through a function, building a new set with the same type comparer.
let map (mapping: 'T -> 'T) (s: SetHandle<'T>) : SetHandle<'T> =
    let mapped = nodeFold (fun acc v -> nodeAdd s.Cmp (mapping v) acc) Empty s.Root
    { s with Root = mapped }

/// Union of two sets (must use same comparer).
let union (a: SetHandle<'T>) (b: SetHandle<'T>) : SetHandle<'T> =
    { a with Root = nodeUnion a.Cmp a.Root b.Root }

/// Intersection of two sets.
let intersect (a: SetHandle<'T>) (b: SetHandle<'T>) : SetHandle<'T> =
    { a with Root = nodeIntersectAcc a.Cmp b.Root a.Root Empty }

/// Difference: elements in a but not in b.
let difference (a: SetHandle<'T>) (b: SetHandle<'T>) : SetHandle<'T> =
    { a with Root = nodeDifferenceAcc a.Cmp b.Root a.Root Empty }

/// Check if a is a subset of b.
let isSubset (a: SetHandle<'T>) (b: SetHandle<'T>) : bool =
    nodeIsSubset a.Cmp a.Root b.Root

/// Convert to a list in ascending order.
let toList (s: SetHandle<'T>) : 'T list =
    nodeToListAcc [] s.Root

/// Build a set from a list using the given comparer.
/// Fable injects the comparer as first argument via ReplacementsInject.
let ofList (cmp: 'T -> 'T -> int) (xs: 'T list) : SetHandle<'T> =
    List.fold (fun acc x -> add x acc) (empty cmp) xs

/// Build a set from an array using the given comparer.
let ofArray (cmp: 'T -> 'T -> int) (xs: 'T array) : SetHandle<'T> =
    Array.fold (fun acc x -> add x acc) (empty cmp) xs

/// Singleton set with given comparer.
let singleton (cmp: 'T -> 'T -> int) (x: 'T) : SetHandle<'T> =
    add x (empty cmp)

/// Minimum element (leftmost node).
let minElement (s: SetHandle<'T>) : 'T =
    nodeMinElement s.Root

/// Maximum element (rightmost node).
let maxElement (s: SetHandle<'T>) : 'T =
    nodeMaxElement s.Root
