// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/FableAstHelpers.fs
// ════════════════════════════════════════════════════════════════════════════════
namespace Tests

open Fable.AST
open Fable.AST.Fable

module FableAstHelpers =
    // ─────────────────────────────────────────────────────────────────
    // FableQuery Active Patterns
    // ─────────────────────────────────────────────────────────────────

    module FableQuery =
        /// Matches a Lambda or a single-argument Delegate
        let (|UnaryLambda|_|) (expr: Expr) =
            match expr with
            | Lambda(arg, body, _) -> Some(arg, body)
            | Delegate([arg], body, _, _) -> Some(arg, body)
            | _ -> None

        /// Matches a curried Lambda (fun a -> fun b -> ...) or a 2-arg Delegate
        let (|BinaryLambda|_|) (expr: Expr) =
            match expr with
            | Lambda(arg1, UnaryLambda(arg2, body), _) -> Some(arg1, arg2, body)
            | Delegate([arg1; arg2], body, _, _) -> Some(arg1, arg2, body)
            | _ -> None

        /// Matches [lambda; collection] pattern common in HOFs like List.map
        let (|HofArgs|_|) (args: Expr list) =
            match args with
            | [UnaryLambda(arg, body); collection] -> Some(arg, body, collection)
            | _ -> None

        /// Matches [folder; init; collection] pattern common in List.fold
        let (|FoldArgs|_|) (args: Expr list) =
            match args with
            | [BinaryLambda(acc, elem, body); init; collection] -> Some(acc, elem, body, init, collection)
            | _ -> None

        /// Matches Fable.Type.List
        let (|ListOf|_|) (t: Type) =
            match t with
            | Type.List(elem) -> Some(elem)
            | _ -> None

        /// Matches Fable.Type.Array
        let (|ArrayOf|_|) (t: Type) =
            match t with
            | Type.Array(elem, _) -> Some(elem)
            | _ -> None

        /// Matches Fable.Type.Option
        let (|OptionOf|_|) (t: Type) =
            match t with
            | Type.Option(elem, _) -> Some(elem)
            | _ -> None

        /// Matches Fable.Type.Tuple
        let (|TupleOf|_|) (t: Type) =
            match t with
            | Type.Tuple(elems, _) -> Some(elems)
            | _ -> None
