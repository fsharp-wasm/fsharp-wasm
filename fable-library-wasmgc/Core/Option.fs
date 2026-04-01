/// fable-library-wasmgc — Option operations.
/// Pure F# compiled by the Fable WasmGC backend.
/// Uses F#'s built-in option DU type; this module provides the standard combinators.
/// Fable recognises option as a nullable struct — compiled to a WasmGC nullable ref.
module OptionModule

/// Map a function over the value inside Some.
let map (f: 'a -> 'b) (opt: 'a option) : 'b option =
    match opt with
    | None   -> None
    | Some x -> Some(f x)

/// Flat-map (bind): apply f only if Some; short-circuit on None.
let bind (f: 'a -> 'b option) (opt: 'a option) : 'b option =
    match opt with
    | None   -> None
    | Some x -> f x

/// Return the value, or a given default when None.
let defaultValue (def: 'a) (opt: 'a option) : 'a =
    match opt with
    | None   -> def
    | Some x -> x

/// Return the value, or compute a default lazily when None.
let defaultWith (def: unit -> 'a) (opt: 'a option) : 'a =
    match opt with
    | None   -> def()
    | Some x -> x

/// True when the option is None.
let isNone (opt: 'a option) : bool =
    match opt with
    | None   -> true
    | Some _ -> false

/// True when the option is Some.
let isSome (opt: 'a option) : bool =
    match opt with
    | Some _ -> true
    | None   -> false

/// Extract the value; raises if None.
let get (opt: 'a option) : 'a =
    match opt with
    | Some x -> x
    | None   -> failwith "Option.get called on None"

/// Apply a side-effecting function to the value when Some; no-op on None.
let iter (f: 'a -> unit) (opt: 'a option) : unit =
    match opt with
    | None   -> ()
    | Some x -> f x

/// Return None if the predicate fails; preserve Some otherwise.
let filter (pred: 'a -> bool) (opt: 'a option) : 'a option =
    match opt with
    | None   -> None
    | Some x -> if pred x then Some x else None

/// Convert to a list: [] for None, [x] for Some x.
let toList (opt: 'a option) : 'a list =
    match opt with
    | None   -> []
    | Some x -> [x]

/// Convert to an array: [||] for None, [|x|] for Some x.
let toArray (opt: 'a option) : 'a array =
    match opt with
    | None   -> [||]
    | Some x -> [|x|]

/// Return alt when None; preserve the original option when Some.
let orElse (alt: 'a option) (opt: 'a option) : 'a option =
    match opt with
    | None   -> alt
    | Some _ -> opt

/// Compute alt lazily when None; preserve the original option when Some.
let orElseWith (alt: unit -> 'a option) (opt: 'a option) : 'a option =
    match opt with
    | None   -> alt()
    | Some _ -> opt

/// Fold: apply f to the contained value, or return state unchanged for None.
let fold (f: 'state -> 'a -> 'state) (state: 'state) (opt: 'a option) : 'state =
    match opt with
    | None   -> state
    | Some x -> f state x

/// True when Some and the predicate holds; false otherwise.
let exists (pred: 'a -> bool) (opt: 'a option) : bool =
    match opt with
    | None   -> false
    | Some x -> pred x

/// True when None or the predicate holds for the contained value.
let forall (pred: 'a -> bool) (opt: 'a option) : bool =
    match opt with
    | None   -> true
    | Some x -> pred x

/// Flatten a nested option: Some(Some x) → Some x; all other cases → None.
let flatten (opt: 'a option option) : 'a option =
    match opt with
    | None        -> None
    | Some inner  -> inner
