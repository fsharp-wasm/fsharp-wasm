// Minimal Fable.Core stubs for WasmGC compilation.
// We define these ourselves so we need no NuGet Fable.Core package.
// Fable's translator recognises [<Import>] by its qualified name "Fable.Core.ImportAttribute".
// Using `module Fable.Core` (not namespace) so we can also define `nativeOnly` here.
module Fable.Core

open System

/// Declares a Wasm import: [<Import("funcName", "moduleName")>].
/// Applied to a binding whose body is `nativeOnly` — the body is never compiled;
/// our WasmGC backend emits a `(import "moduleName" "funcName" ...)` declaration.
[<AttributeUsage(AttributeTargets.Method ||| AttributeTargets.Property)>]
type ImportAttribute(selector: string, from: string) =
    inherit Attribute()
    member _.Selector = selector
    member _.From = from

/// Marks a function body as "host-provided"; the body is replaced at compile time.
/// Used together with [<Import>] to declare external Wasm imports.
let inline nativeOnly<'T> : 'T = failwith "nativeOnly: replaced by host Wasm import"
