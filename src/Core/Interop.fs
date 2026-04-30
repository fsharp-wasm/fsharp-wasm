// ════════════════════════════════════════════════════════════════════════════════
// src/Core/Interop.fs
//
// Compiler-side stub for Fable.Core attributes that the WasmGC backend
// recognises by qualified name.  Lives HERE — in src/Core — so it is compiled
// into the backend itself and is available to user code that does NOT pull in
// the NuGet Fable.Core package.
//
// Design contract
// ───────────────
// • The module is named `Fable.Core` (not a namespace) so that `nativeOnly` can
//   be defined alongside the attribute in the same compilation unit.
// • Fable's translator pattern-matches on the *qualified type name*
//   "Fable.Core.ImportAttribute", so the module path matters.
// • User code that already references the real NuGet Fable.Core does NOT include
//   this file — it is gated in the .fsproj with a Condition.
// • The WasmGC backend recognises [<Import("func","module")>] in
//   TransformExpr.fs / TransformMemberDecl.fs and lowers it to a
//   WasmImportDecl (extern import entry in the resulting .wasm module).
//
// Usage in user F# code:
//   open Fable.Core
//   [<Import("consoleLog", "env")>]
//   let consoleLog (msg: string) : unit = nativeOnly
// ════════════════════════════════════════════════════════════════════════════════
module Fable.Core

open System

// ─────────────────────────────────────────────────────────────────
// Import attribute
// ─────────────────────────────────────────────────────────────────

/// Declares a host Wasm import.
///
/// Applied to a binding whose body is `nativeOnly`.  The body is never compiled;
/// the WasmGC backend emits an `(import "<from>" "<selector>" ...)` declaration
/// instead, and the function is referenced by index like any other function.
///
/// Example:
///   [<Import("consoleLog", "env")>]
///   let consoleLog (msg: string) : unit = nativeOnly
///
/// This produces in WAT:
///   (import "env" "consoleLog" (func $consoleLog (param (ref $WasmStr))))
[<AttributeUsage(AttributeTargets.Method ||| AttributeTargets.Property, AllowMultiple = false)>]
type ImportAttribute(selector: string, from: string) =
    inherit Attribute()
    /// The name of the imported symbol in the host module (Wasm function name).
    member _.Selector = selector
    /// The host module name (the first string in the Wasm import pair).
    member _.From = from

// ─────────────────────────────────────────────────────────────────
// Emit attribute — inline Wasm text / macro
// ─────────────────────────────────────────────────────────────────

/// Emits raw WAT inline at the call site.
/// Use only for one-liner intrinsics that cannot be expressed as normal calls.
/// The macro string uses $0, $1 … as argument placeholders.
///
/// Example:
///   [<Emit("(drop $0)")>]
///   let ignore (_: 'a) : unit = nativeOnly
[<AttributeUsage(AttributeTargets.Method ||| AttributeTargets.Property, AllowMultiple = false)>]
type EmitAttribute(macro: string) =
    inherit Attribute()
    member _.Macro = macro

// ─────────────────────────────────────────────────────────────────
// Export attribute — mark a function as exported from the Wasm module
// ─────────────────────────────────────────────────────────────────

/// Marks a function as exported from the compiled Wasm module.
/// If `name` is omitted, the F# member name (camelCase) is used.
///
/// Example:
///   [<Export("add")>]
///   let add (a: int) (b: int) : int = a + b
///
/// Produces: (export "add" (func $add))
[<AttributeUsage(AttributeTargets.Method ||| AttributeTargets.Property, AllowMultiple = false)>]
type ExportAttribute(?name: string) =
    inherit Attribute()
    member _.Name = name

// ─────────────────────────────────────────────────────────────────
// nativeOnly sentinel
// ─────────────────────────────────────────────────────────────────

/// Sentinel body for [<Import>] and [<Emit>] bindings.
/// The WasmGC backend replaces the entire binding at compile time;
/// this expression is never actually evaluated.
/// At .NET runtime (e.g., in tests) it throws to make misuse obvious.
let inline nativeOnly<'T> : 'T =
    failwith "nativeOnly: this binding is replaced by the WasmGC compiler backend. \
              If you see this at runtime, the function was called outside a compiled Wasm context."
