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
module WasmGc.Transforms.FSharpCoreReplacements

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core
open WasmGc.Builder.Operators

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
        Some (i32Zero)
    | WType.I64 ->
        Some (i64Const 0L)
    | WType.F32 ->
        Some (f32Const 0.0f)
    | WType.F64 ->
        Some (f64Const 0.0)
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
        Some (i32Zero)
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
// Exceptions → WasmGC StructNew
// ─────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────
// Exception struct: { message: ref $string }
// Registered on demand using GenericDuRegistry with "exn:" prefix as key.
// All exception types share the same struct layout — any type-specific data
// is reserved for future work (StackTrace, InnerException fields).
// ─────────────────────────────────────────────────────────────────

/// Get or register an exception struct type for the given fully-qualified name.
/// Uses GenericDuRegistry["exn:FullName"] as the mutable on-demand cache.
let private getOrAddExnType (ctx: Ctx) (fullName: string) : int =
    let key = $"exn:{fullName}"
    match ctx.GenericDuRegistry.TryGetValue(key) with
    | true, idx -> idx
    | false, _ ->
        // Struct: { message: ref $string }
        // Named after the exception type for WAT readability.
        let msgTy     = WType.Ref(StringTypeIdx, false)
        let shortName = fullName.Replace("System.", "").Replace("Collections.Generic.", "")
        let idx       = ctx.TypeDefs.Count
        ctx.TypeDefs.Add {
            Name = $"${shortName}"
            Def  = WTypeDef.Struct(
                    [{ Name = "message"; Type = msgTy; Mutable = false }], None)
        }
        ctx.GenericDuRegistry.[key] <- idx
        idx

let tryHandleException (ctx: Ctx) (selector: string) (wArgs: WExpr list) (ty: WType) : WExpr option =
    let exnFullName =
        match selector with
        | "Exception"                  -> Some "System.Exception"
        | "ArgumentException"          -> Some "System.ArgumentException"
        | "ArgumentNullException"      -> Some "System.ArgumentNullException"
        | "ArgumentOutOfRangeException"-> Some "System.ArgumentOutOfRangeException"
        | "FormatException"            -> Some "System.FormatException"
        | "InvalidOperationException"  -> Some "System.InvalidOperationException"
        | "NotImplementedException"    -> Some "System.NotImplementedException"
        | "NotSupportedException"      -> Some "System.NotSupportedException"
        | "NullReferenceException"     -> Some "System.NullReferenceException"
        | "OverflowException"          -> Some "System.OverflowException"
        | "InvalidCastException"       -> Some "System.InvalidCastException"
        | "IndexOutOfRangeException"   -> Some "System.IndexOutOfRangeException"
        | "StackOverflowException"     -> Some "System.StackOverflowException"
        | "OutOfMemoryException"       -> Some "System.OutOfMemoryException"
        | "KeyNotFoundException"       -> Some "System.Collections.Generic.KeyNotFoundException"
        | _                            -> None

    match exnFullName with
    | None -> None
    | Some fullName ->
        let typeIdx = getOrAddExnType ctx fullName
        // Argument normalisation: exception constructors may receive a message
        // string, no args (parameterless), or additional args.  Normalise to
        // always produce a struct with exactly one field: message.
        let msgArg =
            match wArgs with
            | []        -> WExpr.ArrayNewFixed(StringTypeIdx, [], WType.Ref(StringTypeIdx, false)) // ""
            | msg :: _  -> msg   // first arg is always the message
        Some(structNew typeIdx [msgArg] (WType.Ref(typeIdx, false)))

// ─────────────────────────────────────────────────────────────────
// Main dispatcher for FSharp.Core imports
// ─────────────────────────────────────────────────────────────────

let tryHandleStdlibImport (ctx: Ctx) (selector: string) (wArgs: WExpr list) (ty: WType) : WExpr option =
    match tryHandleException ctx selector wArgs ty with
    | Some res -> Some res
    | None ->
        match selector with
        | "defaultOf"       -> tryHandleDefaultOf   ctx wArgs ty
        | "disposeSafe"     -> tryHandleDisposeSafe  ctx wArgs ty
        | "identityHash"    -> tryHandleIdentityHash ctx wArgs ty
        | "singleton"       -> tryHandleSingleton   ctx wArgs ty
        | "empty"           -> tryHandleEmpty       ctx wArgs ty

        // Fable's Util.fs helpers that have WasmGC equivalents ────────────────
        // `downcast` in Fable is a checked cast; for WasmGC we use ref.cast via
        // the existing TypeCast path. As an import call it just returns the arg.
        | "downcast"        -> wArgs |> List.tryHead |> Option.orElse (Some WExpr.Nop)

        // `comparePrimitives` is Fable's generic compare fallback. In WasmGC we
        // emit subtract (for ints) as a fast approximation. Correct implementation
        // would dispatch on type — sufficient for Map/Set ordering.
        | "comparePrimitives" ->
            match wArgs with
            | [a; b] ->
                match exprWType a with
                // Use boolean compare trick for sign: (a>b) - (a<b) → {-1,0,1}
                // Works for f64, i64, and i32 without overflow and with less noise.
                | WType.F64 -> Some(a <=> b)
                | WType.I64 -> Some(a <=> b)
                | _         -> Some(a <=> b)
            | _ -> None

        | _ -> None
