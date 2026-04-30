/// Type-resolution helpers for list and seq shapes used by replacement routing.
/// Note: loop-shape builders were removed; loop construction lives in Runtime.Builder / CE while!.
module WasmGc.Runtime.LoopHelpers

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// List type info helpers
// ─────────────────────────────────────────────────────────────────

/// Resolve the list cons type-index and element WType for a Fable list argument.
/// Registers the cons type if not already present.
/// Returns None when the argument is not a List type.
///
/// Seq routing: also accepts DeclaredType(_, [elemType]) — the shape of
/// IEnumerable<T>, seq<T>, List<T> from Fable's Seq module replacement.
/// This makes every tryList*Inline handler transparently accept `Seq.*` calls
/// when the underlying seq argument is backed by a WasmGC list.
let tryListTypeInfo (ctx: Ctx) (listFableArg: Fable.Expr) : (WType * int) option =
    match listFableArg.Type with
    | Fable.Type.List(elemFableType) ->
        let _ = mapTypeKnown ctx (Fable.Type.List(elemFableType))
        let elemT   = mapTypeKnown ctx elemFableType
        let elemKey = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, idx -> Some(elemT, idx)
        | _         -> None
    // ── Seq<T> / IEnumerable<T> routing ──────────────────────────────────────
    // Fable represents `seq<T>` (and coerces lists to it) as a DeclaredType
    // with one generic argument.  When such an arg was registered as a list in
    // the ListRegistry, forward to the list implementation transparently.
    | Fable.Type.DeclaredType(_, [elemFableType]) ->
        let _ = mapTypeKnown ctx (Fable.Type.List(elemFableType))
        let elemT = mapTypeKnown ctx elemFableType
        let key   = wTypeKey elemT
        match ctx.ListRegistry.TryGetValue(key) with
        | true, idx -> Some(elemT, idx)
        | _ -> None
    | _ -> None

/// Variant that takes the ELEMENT Fable type directly.
let tryListTypeInfoFromElemType (ctx: Ctx) (elemFableType: Fable.Type) : (WType * int) option =
    let _ = mapTypeKnown ctx (Fable.Type.List(elemFableType))
    let elemT = mapTypeKnown ctx elemFableType
    let key   = wTypeKey elemT
    match ctx.ListRegistry.TryGetValue(key) with
    | true, idx -> Some(elemT, idx)
    | _ -> None
