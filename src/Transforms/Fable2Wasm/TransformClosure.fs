module WasmGc.Transforms.TransformClosures

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Runtime.FreeVars

open WasmGc.Transforms.ClosureBuilder

module Lc = WasmGc.Runtime.Locals

// TODO: looks like a bunch duplicate code below

// ─────────────────────────────────────────────────────────────────
// Value translation
// ─────────────────────────────────────────────────────────────────

/// Build a closure struct for a lambda/delegate.
///
/// SELF-PARAMETER CALLING CONVENTION (Sprint 25b):
///   Lifted function signature: ($self: ref $AnyFn, arg1: T1, ..., argN: TN) → R
///   The code field type for ALL closures with the same apply signature (T1..TN → R)
///   is the SAME functype: (ref $AnyFn, T1, ..., TN) → R.
///   This guarantees ref.cast to ClosureBase succeeds at runtime for ANY closure
///   regardless of how many captures it has.
///
///   At call time (CurriedApply):
///     1. Cast closure to ClosureBase (struct { code: ref $FT_self_args })
///     2. Push it as $self (first arg)
///     3. Push other args
///     4. struct.get 0 → code pointer; call_ref $funcTypeIdx
///
///   Inside the lifted function body, captures are extracted from $self:
///     let $self_cast = ref.cast (ref $ConcreteClosureType) $self
///     let cap_0     = struct.get $self_cast 1
///     let cap_1     = struct.get $self_cast 2
///     ... original body ...
/// Build a single lambda/delegate closure.
/// Takes `eval` as a parameter to break circularity with transformExpr.
let rec buildClosure
        (ctx      : Ctx)
        (eval     : Ctx -> Fable.Expr -> WExpr)
        (args     : Ident list)
        (body     : Fable.Expr)
        (nameHint : string option)
        : WExpr =
    ClosureBuilder.buildClosure ctx eval args body nameHint

// ─────────────────────────────────────────────────────────────────
// Mutual-closure let rec (Sprint 25e)
// ─────────────────────────────────────────────────────────────────

/// Build mutually-recursive closures from LetRec bindings.
/// Handle `let rec f = fun ... and g = fun ...` inside a function body.
///
/// Strategy: for each binding i, allocate a mutable ref-cell ($cell_i) containing
/// a nullable reference to the closure struct.  Each closure captures:
///   • the REF CELLS of all sibling bindings   (not the sibling closures directly)
///   • all common free variables from the outer context
/// After all closures are built, we fill in the cells via struct.set.
/// Inside each lifted function, a preamble extracts sibling closures from their cells.
///
/// This correctly handles mutual calls (dispatch ↔ render in Elmish) without
/// requiring a shared env struct or WasmGC globals.
///
/// Takes `eval` as a parameter to break circularity with transformExpr.
and buildLetRecLambdas
        (ctx      : Ctx)
        (eval     : Ctx -> Fable.Expr -> WExpr)
        (bindings : (Ident * Fable.Expr) list)
        (body     : Fable.Expr)
        : WExpr =
    ClosureBuilder.buildLetRecLambdas ctx eval bindings body


// let emitWasmClosureCall 
//     (ctx      : Ctx) 
//     closureExpr
//     (args     : Ident list)
//     typeInfo =
//     // Assumes closure structure: field 0 = function ref, field 1 = environment payload
    
//     // 1. Push the closure struct instance to the stack
//     let closureLocal = ctx.AllocateLocal(closureExpr.Type)
    
//     // 2. Extract the function pointer from the closure struct
//     let funcRef = WExpr.StructGet(closureExpr, 0)
    
//     // 3. Extract the context environment payload
//     let envPayload = WExpr.StructGet(closureExpr, 1)
    
//     // 4. Combine environment payload and arguments into the call parameters
//     let callParams = envPayload :: args
    
//     // 5. Emit CallRef / TailCallRef instead of CallIndirect
//     if ctx.IsTailCallContext then
//         WExpr.TailCallRef(funcRef, callParams)
//     else
//         WExpr.CallRef(funcRef, callParams)