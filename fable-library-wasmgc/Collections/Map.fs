/// fable-library-wasmgc — Map collection.
/// Written in pure F# — compiled by the WasmGC Fable backend.
/// This is NOT a hand-crafted WasmIR helper inside the compiler.
/// Key type: int (BST by integer comparison).
module MapModule

// ─── Data type ───────────────────────────────────────────────────────────────
// Simple, unbalanced BST — correct semantics.
// Represented as a discriminated union; compiled to a WasmGC struct hierarchy
// by ClassDeclaration handling in Fable2WasmGc.processDecl.

type MapNode =
    | Empty
    | Node of int * int * MapNode * MapNode
    //         key  value  left     right

// ─── Public API ──────────────────────────────────────────────────────────────

/// Empty map — always returns the Empty node.
let empty () : MapNode = Empty

/// True when the map has no entries.
let isEmpty (tree: MapNode) : bool =
    match tree with
    | Empty -> true
    | _ -> false

/// Insert or replace key→value.  O(depth).
let rec add (key: int) (value: int) (tree: MapNode) : MapNode =
    match tree with
    | Empty -> Node(key, value, Empty, Empty)
    | Node(k, v, l, r) ->
        if key < k then Node(k, v, add key value l, r)
        elif key > k then Node(k, v, l, add key value r)
        else Node(key, value, l, r)   // replace

/// Look up a key.  Returns None when absent.
let rec tryFind (key: int) (tree: MapNode) : int option =
    match tree with
    | Empty -> None
    | Node(k, v, l, r) ->
        if key < k then tryFind key l
        elif key > k then tryFind key r
        else Some v

/// Total number of nodes (entries).
let rec count (tree: MapNode) : int =
    match tree with
    | Empty -> 0
    | Node(_, _, l, r) -> 1 + count l + count r

/// True when key is present.
let rec containsKey (key: int) (tree: MapNode) : bool =
    match tree with
    | Empty -> false
    | Node(k, _, l, r) ->
        if key < k then containsKey key l
        elif key > k then containsKey key r
        else true

/// Return value for key; raises on missing key.
let find (key: int) (tree: MapNode) : int =
    match tryFind key tree with
    | Some v -> v
    | None   -> failwith "Key not found"

/// Helper: merge two subtrees by inserting all elements of source into target.
let rec private mergeInto (source: MapNode) (target: MapNode) : MapNode =
    match source with
    | Empty -> target
    | Node(sk, sv, sl, sr) ->
        mergeInto sr (mergeInto sl (add sk sv target))

/// Remove a key from the map by rebuilding the path without it.
let rec remove (key: int) (tree: MapNode) : MapNode =
    match tree with
    | Empty -> Empty
    | Node(k, v, l, r) ->
        if key < k then Node(k, v, remove key l, r)
        elif key > k then Node(k, v, l, remove key r)
        else mergeInto r l

/// Fold over all key-value pairs in ascending key order (left → root → right).
let rec fold (folder: int -> int -> int -> int) (state: int) (node: MapNode) : int =
    match node with
    | Empty -> state
    | Node(k, v, l, r) ->
        let s1 = fold folder state l
        let s2 = folder s1 k v
        fold folder s2 r

/// Iterate over all key-value pairs in ascending key order.
let rec iter (action: int -> int -> unit) (node: MapNode) : unit =
    match node with
    | Empty -> ()
    | Node(k, v, l, r) ->
        iter action l
        action k v
        iter action r

/// Map values, keeping keys unchanged.  Returns a new map.
let rec mapValues (mapping: int -> int -> int) (node: MapNode) : MapNode =
    match node with
    | Empty -> Empty
    | Node(k, v, l, r) ->
        Node(k, mapping k v, mapValues mapping l, mapValues mapping r)

/// Filter entries by predicate, rebuilding the tree.
let rec filter (predicate: int -> int -> bool) (node: MapNode) : MapNode =
    match node with
    | Empty -> Empty
    | Node(k, v, l, r) ->
        let fl = filter predicate l
        let fr = filter predicate r
        if predicate k v then Node(k, v, fl, fr)
        else mergeInto fr fl

/// Check if any entry satisfies the predicate.
let rec exists (predicate: int -> int -> bool) (node: MapNode) : bool =
    match node with
    | Empty -> false
    | Node(k, v, l, r) ->
        if predicate k v then true
        elif exists predicate l then true
        else exists predicate r

/// Check if all entries satisfy the predicate.
let rec forAll (predicate: int -> int -> bool) (node: MapNode) : bool =
    match node with
    | Empty -> true
    | Node(k, v, l, r) ->
        if not (predicate k v) then false
        elif not (forAll predicate l) then false
        else forAll predicate r

/// Convert to a list of (key, value) pairs in ascending key order.
let rec private toListAcc (acc: (int * int) list) (node: MapNode) : (int * int) list =
    match node with
    | Empty -> acc
    | Node(k, v, l, r) -> toListAcc ((k, v) :: toListAcc acc r) l

let toList (node: MapNode) : (int * int) list = toListAcc [] node

/// Build a map from a list of (key, value) pairs.
/// The IComparer argument injected by Fable is dropped at the call site in
/// tryMapInline (WasmGcMathMap.fs); this function receives only the list.
let rec private ofListAcc (acc: MapNode) (pairs: (int * int) list) : MapNode =
    match pairs with
    | [] -> acc
    | (k, v) :: rest -> ofListAcc (add k v acc) rest

let ofList (pairs: (int * int) list) : MapNode = ofListAcc Empty pairs
