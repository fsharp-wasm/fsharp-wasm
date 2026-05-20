
module WasmGc.Bcl.Helpers

open Microsoft.FSharp.Quotations

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Runtime.QuotationWalker
open WasmGc.Builder.Core
open WasmGc.Runtime.Locals

// ─────────────────────────────────────────────────────────────────
// Quotation walker helpers — shared by all Tier 1 BCL helpers
// ─────────────────────────────────────────────────────────────────

/// Type-map used when translating runtime quotations: strings map to StringTypeIdx,
/// StringBuilder struct maps to StringBuilderTypeIdx.
let (* private *) runtimeTypeMap () : QTypeMap =
    { StrTypeIdx = StringTypeIdx
      SbTypeIdx  = StringBuilderTypeIdx
      ResolveCustom = fun _ -> None }

/// Intrinsics used when translating runtime quotations.
let private runtimeIntrinsics () = standardIntrinsics StringTypeIdx StringBuilderTypeIdx

/// Translate an inline quotation to a WFuncDecl and collect locals.
/// The WFuncDecl returned by translateReflected has Locals = [];
/// resolveLocals fills them in so the function is self-contained.
let q (name: string) (qexpr: Expr) : WFuncDecl =
    translateReflected name (runtimeTypeMap()) (runtimeIntrinsics()) qexpr
    |> resolveLocals