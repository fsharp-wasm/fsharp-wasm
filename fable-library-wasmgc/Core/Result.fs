/// fable-library-wasmgc — Result operations.
/// Pure F# compiled by the Fable WasmGC backend.
/// Uses F#'s built-in Result<'T,'E> DU type; this module provides standard combinators.
/// Fable compiles Result to a WasmGC tagged struct hierarchy (Ok / Error cases).
module ResultModule

/// Map over the Ok value, leaving Error unchanged.
let map (f: 'a -> 'b) (r: Result<'a, 'e>) : Result<'b, 'e> =
    match r with
    | Ok x    -> Ok(f x)
    | Error e -> Error e

/// Map over the Error value, leaving Ok unchanged.
let mapError (f: 'e -> 'f) (r: Result<'a, 'e>) : Result<'a, 'f> =
    match r with
    | Ok x    -> Ok x
    | Error e -> Error(f e)

/// Flat-map (bind): apply f only when Ok; propagate Error unchanged.
let bind (f: 'a -> Result<'b, 'e>) (r: Result<'a, 'e>) : Result<'b, 'e> =
    match r with
    | Ok x    -> f x
    | Error e -> Error e

/// True when the result is Ok.
let isOk (r: Result<'a, 'e>) : bool =
    match r with
    | Ok _    -> true
    | Error _ -> false

/// True when the result is Error.
let isError (r: Result<'a, 'e>) : bool =
    match r with
    | Error _ -> true
    | Ok _    -> false

/// Extract the Ok value; raises if Error.
let get (r: Result<'a, 'e>) : 'a =
    match r with
    | Ok x    -> x
    | Error _ -> failwith "Result.get called on Error"

/// Extract the Error value; raises if Ok.
let getError (r: Result<'a, 'e>) : 'e =
    match r with
    | Error e -> e
    | Ok _    -> failwith "Result.getError called on Ok"

/// Return the Ok value, or a default when Error.
let defaultValue (def: 'a) (r: Result<'a, 'e>) : 'a =
    match r with
    | Ok x    -> x
    | Error _ -> def

/// Compute the default lazily when Error.
let defaultWith (def: 'e -> 'a) (r: Result<'a, 'e>) : 'a =
    match r with
    | Ok x    -> x
    | Error e -> def e

/// Convert to an option: Ok x → Some x; Error → None.
let toOption (r: Result<'a, 'e>) : 'a option =
    match r with
    | Ok x    -> Some x
    | Error _ -> None

/// Convert to a list: Ok x → [x]; Error → [].
let toList (r: Result<'a, 'e>) : 'a list =
    match r with
    | Ok x    -> [x]
    | Error _ -> []

/// Apply a side-effecting function to the Ok value; no-op on Error.
let iter (f: 'a -> unit) (r: Result<'a, 'e>) : unit =
    match r with
    | Ok x    -> f x
    | Error _ -> ()

/// Apply a side-effecting function to the Error value; no-op on Ok.
let iterError (f: 'e -> unit) (r: Result<'a, 'e>) : unit =
    match r with
    | Error e -> f e
    | Ok _    -> ()

/// True when Ok and the predicate holds; false on Error or failed predicate.
let exists (pred: 'a -> bool) (r: Result<'a, 'e>) : bool =
    match r with
    | Ok x    -> pred x
    | Error _ -> false

/// True when Error or the predicate holds for the Ok value.
let forall (pred: 'a -> bool) (r: Result<'a, 'e>) : bool =
    match r with
    | Ok x    -> pred x
    | Error _ -> true

/// Fold: apply f to the Ok value starting from state; return state unchanged on Error.
let fold (f: 'state -> 'a -> 'state) (state: 'state) (r: Result<'a, 'e>) : 'state =
    match r with
    | Ok x    -> f state x
    | Error _ -> state

/// Combine two results: if both Ok, apply f to both values; first Error wins.
let map2 (f: 'a -> 'b -> 'c) (ra: Result<'a, 'e>) (rb: Result<'b, 'e>) : Result<'c, 'e> =
    match ra, rb with
    | Ok a,    Ok b    -> Ok(f a b)
    | Error e, _       -> Error e
    | _,       Error e -> Error e
