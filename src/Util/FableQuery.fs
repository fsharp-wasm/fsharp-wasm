module FableQuery

open Fable.AST.Fable

// ── Lambda shapes ─────────────────────────────────────────────────

/// Matches a single-arg lambda or single-element delegate.
let (|UnaryLambda|_|) = function
    | Lambda(arg, body, _)
    | Delegate([arg], body, _, _) -> Some(arg, body)
    | _ -> None

/// Matches a curried 2-arg lambda or 2-element delegate.
let (|BinaryLambda|_|) = function
    | Lambda(a1, Lambda(a2, body, _), _)
    | Delegate([a1; a2], body, _, _) -> Some(a1, a2, body)
    | _ -> None

/// Matches a curried 3-arg lambda.
let (|TernaryLambda|_|) = function
    | Lambda(a1, Lambda(a2, Lambda(a3, body, _), _), _)
    | Delegate([a1; a2; a3], body, _, _) -> Some(a1, a2, a3, body)
    | _ -> None

// ── Type shapes ───────────────────────────────────────────────────

let (|ListOf|_|) = function
    | Type.List t -> Some t
    | Type.DeclaredType(_, [t]) -> Some t  // seq<T> coercion
    | _ -> None

let (|ArrayOf|_|) = function
    | Type.Array(t, _) -> Some t
    | _ -> None

let (|ResizeArrayOf|_|) = function
    | Type.Array(t, ArrayKind.ResizeArray) -> Some t
    | _ -> None

let (|OptionOf|_|) = function
    | Type.Option t -> Some t
    | _ -> None

let (|TupleOf|_|) = function
    | Type.Tuple(ts, _) -> Some ts
    | _ -> None

// ── Call shapes ───────────────────────────────────────────────────

/// LibCall: matches a call to a Fable standard library function.
/// Returns (moduleStem, memberName, args).
let (|LibCall|_|) = function
    | Call(Import({ Selector = sel; Path = path }, _, _), callInfo, _, _)
          when path.EndsWith(".js") || path.Contains("fable-library") ->
        let stem = System.IO.Path.GetFileNameWithoutExtension(path)
        Some(stem, sel, callInfo.Args)
    | _ -> None

/// ImportCall: matches a call to a user-declared [<Import>] function.
let (|ImportCall|_|) = function
    | Call(Import({ Selector = sel; Path = path }, _, _), callInfo, _, _) ->
        Some(sel, path, callInfo.Args)
    | _ -> None

/// ResizeArray.push call (Emit wrapping).
let (|ResizeArrayPush|_|) = function
    | Emit({ Macro = "void ($0)" }, _, _) -> None  // handled separately
    | Call(Get(arr, FieldGet fi, _, _), callInfo, _, _)
          when fi.Name = "push" ->
        match arr.Type with
        | ResizeArrayOf elemT -> Some(arr, elemT, callInfo.Args)
        | _ -> None
    | _ -> None

// ── Pattern helpers for common HOF shapes ─────────────────────────

/// Matches the standard (f, list) argument shape for List/Array HOFs.
let (|HofArgs|_|) = function
    | [UnaryLambda(farg, fbody); collection] -> Some(farg, fbody, collection)
    | [collection; UnaryLambda(farg, fbody)] -> Some(farg, fbody, collection)
    | _ -> None

/// Matches the fold (folder, init, collection) shape.
let (|FoldArgs|_|) = function
    | [BinaryLambda(acc, elem, body); init; coll] -> Some(acc, elem, body, init, coll)
    | _ -> None

// ── Value shapes ──────────────────────────────────────────────────

let (|IntLit|_|) = function
    | Value(NumberConstant(n, Int32, _), _) -> Some(int n)
    | _ -> None

let (|StrLit|_|) = function
    | Value(StringConstant s, _) -> Some s
    | _ -> None

let (|BoolLit|_|) = function
    | Value(BoolConstant b, _) -> Some b
    | _ -> None

let (|UnitVal|_|) = function
    | Value(UnitConstant, _) -> Some()
    | _ -> None