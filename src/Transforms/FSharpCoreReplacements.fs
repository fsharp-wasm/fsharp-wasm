/// WasmGC inline replacements for F#.Core unhandled imports.
///
/// These are Fable-generated import calls for F# standard library operations
/// that don't have native WASM support. We provide WasmGC-specific implementations.
///
/// Examples:
///   - `defaultOf<'T>`    → Unchecked.defaultof
///   - `disposeSafe(x)`   → IDisposable.Dispose (or no-op if not IDisposable)
///   - `FSharpRef`        → mutable ref cell (already supported via RefRegistry)
///   - `singleton(x)`     → Seq.singleton → single-element list
///   - `empty`            → Seq.empty → null list
///   - `identityHash(x)`  → GetHashCode stub (return 0 for now)
module Fable.Transforms.WasmGc.Transforms.FSharpCoreReplacements

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open Fable.Transforms.WasmGc.Runtime.Types
open Fable.Transforms.WasmGc.Runtime.Builder

// ─────────────────────────────────────────────────────────────────
// Unchecked.defaultof<'T> → zero-like value for type T
// ─────────────────────────────────────────────────────────────────

/// Handle `defaultof<'T>` imports.
/// Returns: null (refs), 0 (i32), 0L (i64), 0.0 (f64), or Nop (unknown types).
let tryHandleDefaultOf (ctx: Ctx) (wArgs: WExpr list) (ty: WType) : WExpr option =
    match ty with
    | WType.Ref(_, _) ->
        // Reference type: null value
        Some (WExpr.Const(WConst.Null ty))
    | WType.I32 ->
        Some (WExpr.Const(WConst.I32 0))
    | WType.I64 ->
        Some (WExpr.Const(WConst.I64 0L))
    | WType.F32 ->
        Some (WExpr.Const(WConst.F32 0.0f))
    | WType.F64 ->
        Some (WExpr.Const(WConst.F64 0.0))
    | _ ->
        // Unknown: fall through to Nop (compiler will warn)
        Some WExpr.Nop

// ─────────────────────────────────────────────────────────────────
// IDisposable.Dispose → no-op or call Dispose method
// ─────────────────────────────────────────────────────────────────

/// Handle `disposeSafe(obj)` imports.
/// For now: returns Nop. In future, would check if obj has IDisposable
/// and route to obj.Dispose().
let tryHandleDisposeSafe (ctx: Ctx) (wArgs: WExpr list) (ty: WType) : WExpr option =
    match wArgs with
    | [obj] ->
        // TODO: Check if obj's type has IDisposable, route to Dispose method.
        // For now: it's a no-op (dispose is called elsewhere or implicit).
        Some WExpr.Nop
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Object.GetHashCode stub → identityHash
// ─────────────────────────────────────────────────────────────────

/// Handle `identityHash(obj)` imports.
/// For now: returns a constant 0 (all objects have the same hash).
/// This is used by Dictionary as a fallback. In future, use ref address.
let tryHandleIdentityHash (ctx: Ctx) (wArgs: WExpr list) (ty: WType) : WExpr option =
    match wArgs with
    | [_obj] ->
        // Stub: return 0 for all objects.
        // (In future: extract address bits from ref, or use ref identity)
        Some (WExpr.Const(WConst.I32 0))
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Seq.singleton(x) → single-element list
// ─────────────────────────────────────────────────────────────────

/// Handle `singleton(x)` imports (Seq.singleton in fable-library).
/// Result: a single-cons list: Cons(x, Nil).
/// For now: stub with Nop (TODO: implement via ListRegistry like ListOps.fs does).
let tryHandleSingleton (ctx: Ctx) (wArgs: WExpr list) (ty: WType) : WExpr option =
    match wArgs with
    | [elem] ->
        // TODO: Implement using ctx.ListRegistry.GetOrAdd like ListOps.fs
        // For now: return Nop as a placeholder
        Some WExpr.Nop
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Seq.empty → null list (empty sequence)
// ─────────────────────────────────────────────────────────────────

/// Handle `empty` imports (Seq.empty, Option.empty, etc.).
/// Result: null reference (null list).
let tryHandleEmpty (ctx: Ctx) (wArgs: WExpr list) (ty: WType) : WExpr option =
    match ty with
    | WType.Ref(_, _) ->
        // Return null for empty sequence/list/option
        Some (WExpr.Const(WConst.Null ty))
    | _ ->
        // Not a ref type — shouldn't happen for Seq.empty
        Some WExpr.Nop

// ─────────────────────────────────────────────────────────────────
// Main dispatcher for FSharp.Core imports
// ─────────────────────────────────────────────────────────────────

/// Try to handle a standard F#.Core import call.
/// Returns None if the import should fall through to default handling (Nop).
let tryHandleStdlibImport (ctx: Ctx) (selector: string) (wArgs: WExpr list) (ty: WType) : WExpr option =
    match selector with
    | "defaultOf" -> tryHandleDefaultOf ctx wArgs ty
    | "disposeSafe" -> tryHandleDisposeSafe ctx wArgs ty
    | "identityHash" -> tryHandleIdentityHash ctx wArgs ty
    | "singleton" -> tryHandleSingleton ctx wArgs ty
    | "empty" -> tryHandleEmpty ctx wArgs ty
    | _ -> None
