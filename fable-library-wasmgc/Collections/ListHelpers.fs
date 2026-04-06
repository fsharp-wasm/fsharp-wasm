/// fable-library-wasmgc — List helper operations.
/// Pure F# compiled by the Fable WasmGC backend.
/// These operations were previously over-inlined in the compiler transform layer
/// (parallel-array scan loops restricted to I32 keys, cap=64 fixed allocation).
/// Moving them here makes them correct, general, and easier to maintain.
/// Key constraint: currently int-only (no generic comparison until i31ref boxing).
module ListHelpers

// ─── pairwise ────────────────────────────────────────────────────────────────

/// Produces consecutive pairs: [1;2;3] → [(1,2); (2,3)].
let pairwise (xs: int list) : (int * int) list =
    let rec go acc prev rest =
        match rest with
        | [] -> List.rev acc
        | x :: xs -> go ((prev, x) :: acc) x xs
    match xs with
    | [] | [_] -> []
    | x :: xs -> go [] x xs

// ─── distinct ────────────────────────────────────────────────────────────────

/// Remove duplicates, preserving first occurrence order.
/// O(n²) with list-based seen tracking (matches prior inline implementation).
let distinct (xs: int list) : int list =
    let rec contains v ys =
        match ys with
        | [] -> false
        | y :: rest -> if v = y then true else contains v rest
    let rec go acc seen xs =
        match xs with
        | [] -> List.rev acc
        | x :: rest ->
            if contains x seen then go acc seen rest
            else go (x :: acc) (x :: seen) rest
    go [] [] xs

// ─── distinctBy ──────────────────────────────────────────────────────────────

/// Remove duplicates by key projection, preserving first occurrence order.
/// O(n²) with list-based seen-key tracking.
let distinctBy (f: int -> int) (xs: int list) : int list =
    let rec containsKey k ys =
        match ys with
        | [] -> false
        | y :: rest -> if k = y then true else containsKey k rest
    let rec go acc seenKeys xs =
        match xs with
        | [] -> List.rev acc
        | x :: rest ->
            let k = f x
            if containsKey k seenKeys then go acc seenKeys rest
            else go (x :: acc) (k :: seenKeys) rest
    go [] [] xs

// ─── countBy ─────────────────────────────────────────────────────────────────

/// Count occurrences by key projection: [1;2;1;3] with id → [(1,2); (2,1); (3,1)].
/// O(n·k) where k = distinct keys (matches prior inline implementation).
let countBy (f: int -> int) (xs: int list) : (int * int) list =
    let rec updateOrAdd k pairs =
        match pairs with
        | [] -> [(k, 1)]
        | (pk, pv) :: rest ->
            if pk = k then (pk, pv + 1) :: rest
            else (pk, pv) :: updateOrAdd k rest
    let rec go acc xs =
        match xs with
        | [] -> acc
        | x :: rest -> go (updateOrAdd (f x) acc) rest
    go [] xs

// ─── groupBy ─────────────────────────────────────────────────────────────────

/// Group elements by key projection.
/// Each group's elements are in input order.
/// O(n·k) where k = distinct keys (matches prior inline implementation).
let groupBy (f: int -> int) (xs: int list) : (int * int list) list =
    let rec appendOrAdd k v pairs =
        match pairs with
        | [] -> [(k, [v])]
        | (pk, pvs) :: rest ->
            if pk = k then (pk, v :: pvs) :: rest
            else (pk, pvs) :: appendOrAdd k v rest
    let rec go acc xs =
        match xs with
        | [] ->
            let rec revGroups result groups =
                match groups with
                | [] -> List.rev result
                | (k, vs) :: rest -> revGroups ((k, List.rev vs) :: result) rest
            revGroups [] acc
        | x :: rest -> go (appendOrAdd (f x) x acc) rest
    go [] xs
