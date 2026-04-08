/// fable-library-wasmgc — Generic Map collection.
/// Written in pure F# — compiled by the WasmGC Fable backend.
/// Unbalanced BST with an explicit comparison function stored in the handle.
/// Supports any key type ('K) comparable via the provided cmp function.
module MapModule

// ─── Internal tree node ──────────────────────────────────────────────────────
// The BST node does NOT store the comparer; the MapHandle wrapper does.
// This means all order-sensitive operations receive cmp explicitly, while
// the public MapHandle API exposes cmp-free functions (they extract from handle).

type MapNode<'K, 'V> =
    | Empty
    | Node of key: 'K * value: 'V * left: MapNode<'K,'V> * right: MapNode<'K,'V>
    //         ─────   ───────   ────────────────────────   ────────────────────

// ─── Map handle ──────────────────────────────────────────────────────────────
// A value of type MapHandle<'K,'V> owns both the root node and the comparator.
// All public API functions work on MapHandle, so callers never need to thread cmp.

type MapHandle<'K, 'V> =
    { Root: MapNode<'K,'V>; Cmp: 'K -> 'K -> int }

// ─── Internal tree operations (take cmp explicitly) ──────────────────────────

let rec private nodeAdd (cmp: 'K -> 'K -> int) (key: 'K) (value: 'V) (node: MapNode<'K,'V>) : MapNode<'K,'V> =
    match node with
    | Empty -> Node(key, value, Empty, Empty)
    | Node(k, v, l, r) ->
        let c = cmp key k
        if c < 0 then Node(k, v, nodeAdd cmp key value l, r)
        elif c > 0 then Node(k, v, l, nodeAdd cmp key value r)
        else Node(key, value, l, r)   // replace

let rec private nodeTryFind (cmp: 'K -> 'K -> int) (key: 'K) (node: MapNode<'K,'V>) : 'V option =
    match node with
    | Empty -> None
    | Node(k, v, l, r) ->
        let c = cmp key k
        if c < 0 then nodeTryFind cmp key l
        elif c > 0 then nodeTryFind cmp key r
        else Some v

let rec private nodeContainsKey (cmp: 'K -> 'K -> int) (key: 'K) (node: MapNode<'K,'V>) : bool =
    match node with
    | Empty -> false
    | Node(k, _, l, r) ->
        let c = cmp key k
        if c < 0 then nodeContainsKey cmp key l
        elif c > 0 then nodeContainsKey cmp key r
        else true

let rec private nodeMergeInto (cmp: 'K -> 'K -> int) (source: MapNode<'K,'V>) (target: MapNode<'K,'V>) : MapNode<'K,'V> =
    match source with
    | Empty -> target
    | Node(sk, sv, sl, sr) ->
        nodeMergeInto cmp sr (nodeMergeInto cmp sl (nodeAdd cmp sk sv target))

let rec private nodeRemove (cmp: 'K -> 'K -> int) (key: 'K) (node: MapNode<'K,'V>) : MapNode<'K,'V> =
    match node with
    | Empty -> Empty
    | Node(k, v, l, r) ->
        let c = cmp key k
        if c < 0 then Node(k, v, nodeRemove cmp key l, r)
        elif c > 0 then Node(k, v, l, nodeRemove cmp key r)
        else nodeMergeInto cmp r l

let rec private nodeFold (folder: 'S -> 'K -> 'V -> 'S) (state: 'S) (node: MapNode<'K,'V>) : 'S =
    match node with
    | Empty -> state
    | Node(k, v, l, r) ->
        let s1 = nodeFold folder state l
        let s2 = folder s1 k v
        nodeFold folder s2 r

let rec private nodeIter (action: 'K -> 'V -> unit) (node: MapNode<'K,'V>) : unit =
    match node with
    | Empty -> ()
    | Node(k, v, l, r) ->
        nodeIter action l
        action k v
        nodeIter action r

let rec private nodeMapValues (mapping: 'K -> 'V -> 'U) (node: MapNode<'K,'V>) : MapNode<'K,'U> =
    match node with
    | Empty -> Empty
    | Node(k, v, l, r) ->
        Node(k, mapping k v, nodeMapValues mapping l, nodeMapValues mapping r)

let rec private nodeFilter (cmp: 'K -> 'K -> int) (predicate: 'K -> 'V -> bool) (node: MapNode<'K,'V>) : MapNode<'K,'V> =
    match node with
    | Empty -> Empty
    | Node(k, v, l, r) ->
        let fl = nodeFilter cmp predicate l
        let fr = nodeFilter cmp predicate r
        if predicate k v then Node(k, v, fl, fr)
        else nodeMergeInto cmp fr fl

let rec private nodeExists (predicate: 'K -> 'V -> bool) (node: MapNode<'K,'V>) : bool =
    match node with
    | Empty -> false
    | Node(k, v, l, r) ->
        if predicate k v then true
        elif nodeExists predicate l then true
        else nodeExists predicate r

let rec private nodeForAll (predicate: 'K -> 'V -> bool) (node: MapNode<'K,'V>) : bool =
    match node with
    | Empty -> true
    | Node(k, v, l, r) ->
        if not (predicate k v) then false
        elif not (nodeForAll predicate l) then false
        else nodeForAll predicate r

let rec private nodeToListAcc (acc: ('K * 'V) list) (node: MapNode<'K,'V>) : ('K * 'V) list =
    match node with
    | Empty -> acc
    | Node(k, v, l, r) -> nodeToListAcc ((k, v) :: nodeToListAcc acc r) l

// ─── Public API (operates on MapHandle) ──────────────────────────────────────

/// Create an empty map with the given comparison function.
/// The comparer is stored in the handle and used by all subsequent operations.
let empty (cmp: 'K -> 'K -> int) : MapHandle<'K,'V> =
    { Root = Empty; Cmp = cmp }

/// True when the map has no entries.
let isEmpty (m: MapHandle<'K,'V>) : bool =
    match m.Root with Empty -> true | _ -> false

/// Insert or replace key→value.
let add (key: 'K) (value: 'V) (m: MapHandle<'K,'V>) : MapHandle<'K,'V> =
    { m with Root = nodeAdd m.Cmp key value m.Root }

/// Look up a key.  Returns None when absent.
let tryFind (key: 'K) (m: MapHandle<'K,'V>) : 'V option =
    nodeTryFind m.Cmp key m.Root

/// Return value for key; raises on missing key.
let find (key: 'K) (m: MapHandle<'K,'V>) : 'V =
    match tryFind key m with
    | Some v -> v
    | None   -> failwith "Key not found"

/// True when key is present.
let containsKey (key: 'K) (m: MapHandle<'K,'V>) : bool =
    nodeContainsKey m.Cmp key m.Root

/// Remove a key from the map.
let remove (key: 'K) (m: MapHandle<'K,'V>) : MapHandle<'K,'V> =
    { m with Root = nodeRemove m.Cmp key m.Root }

/// Total number of entries.
let count (m: MapHandle<'K,'V>) : int =
    nodeFold (fun n _ _ -> n + 1) 0 m.Root

/// Fold over all key-value pairs in ascending key order.
let fold (folder: 'S -> 'K -> 'V -> 'S) (state: 'S) (m: MapHandle<'K,'V>) : 'S =
    nodeFold folder state m.Root

/// Iterate over all key-value pairs in ascending key order.
let iter (action: 'K -> 'V -> unit) (m: MapHandle<'K,'V>) : unit =
    nodeIter action m.Root

/// Map values, keeping keys unchanged.  Returns a new map with same comparer.
let mapValues (mapping: 'K -> 'V -> 'U) (m: MapHandle<'K,'V>) : MapHandle<'K,'U> =
    { Root = nodeMapValues mapping m.Root; Cmp = m.Cmp }

/// Filter entries by predicate.
let filter (predicate: 'K -> 'V -> bool) (m: MapHandle<'K,'V>) : MapHandle<'K,'V> =
    { m with Root = nodeFilter m.Cmp predicate m.Root }

/// Check if any entry satisfies the predicate.
let exists (predicate: 'K -> 'V -> bool) (m: MapHandle<'K,'V>) : bool =
    nodeExists predicate m.Root

/// Check if all entries satisfy the predicate.
let forAll (predicate: 'K -> 'V -> bool) (m: MapHandle<'K,'V>) : bool =
    nodeForAll predicate m.Root

/// Convert to a list of (key, value) pairs in ascending key order.
let toList (m: MapHandle<'K,'V>) : ('K * 'V) list =
    nodeToListAcc [] m.Root

let rec private ofListAcc (cmp: 'K -> 'K -> int) (acc: MapHandle<'K,'V>) (pairs: ('K * 'V) list) : MapHandle<'K,'V> =
    match pairs with
    | [] -> acc
    | (k, v) :: rest -> ofListAcc cmp (add k v acc) rest

/// Build a map from a list of (key, value) pairs using the given comparer.
/// Fable injects the comparer as the first argument via ReplacementsInject.
let ofList (cmp: 'K -> 'K -> int) (pairs: ('K * 'V) list) : MapHandle<'K,'V> =
    ofListAcc cmp (empty cmp) pairs

