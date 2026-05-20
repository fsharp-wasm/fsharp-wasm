/// Closure struct building — pure WExpr, no Fable.AST.
/// ClosureBuilder.fs stays in Fable.WasmGc (it needs Ctx + FreeVars which touch Fable).
/// This module provides the WASM struct layout primitives for closures.
module WasmGc.Patterns.Closure

open WasmGc.Core.AST
open WasmGc.Builder.Core

// ── Struct field helpers ─────────────────────────────────────────────────────

let codeField   ty   = { Name = "code"; Type = ty;       Mutable = false }
let captureField i ty = { Name = $"cap{i}"; Type = ty;   Mutable = false }

/// Build the type def for a concrete closure: {code: ref $funcType, cap0: T0, cap1: T1, ...}
let concreteClosureTypeDef
        (baseName     : string)
        (codeFieldTy  : WType)
        (captureTypes : WType list)
        (parentIdx    : int)
        : WTypeDeclEntry =
    let fields =
        codeField codeFieldTy
        :: (captureTypes |> List.mapi captureField)
    { Name = baseName; Def = WTypeDef.Struct(fields, Some parentIdx) }

/// Build the base closure type: {code: ref $funcType} — no capture fields.
let baseClosureTypeDef (baseName: string) (codeFieldTy: WType) (anyFnIdx: int) : WTypeDeclEntry =
    { Name = baseName; Def = WTypeDef.Struct([codeField codeFieldTy], Some anyFnIdx) }

// ── StructNew for closure allocation ────────────────────────────────────────

/// Emit a `struct.new $closureType (ref.func $fn, cap0, cap1, ...)`.
let allocClosure (typeIdx: int) (codeTy: WType) (funcName: string) (captures: WExpr list) : WExpr =
    let codePtr = WExpr.FuncRef funcName
    WExpr.StructNew(typeIdx, codePtr :: captures, WType.Ref(typeIdx, false))

// ── Capture extraction (reading captures from a closed-over struct) ──────────

/// Read capture field i from a closure struct cast to the concrete type.
let readCapture (closureTypeIdx: int) (captureIdx: int) (captureTy: WType) (closureRef: WExpr) : WExpr =
    let castTy = WType.Ref(closureTypeIdx, false)
    WExpr.StructGet(WExpr.Cast(closureRef, castTy), 1 + captureIdx, captureTy)

/// Read the code pointer (field 0) from a closure ref, cast to the base type.
let readCode (baseTypeIdx: int) (funcTypeTy: WType) (closureRef: WExpr) : WExpr =
    WExpr.StructGet(WExpr.Cast(closureRef, WType.Ref(baseTypeIdx, false)), 0, funcTypeTy)

// ── CallRef through closure ──────────────────────────────────────────────────

/// Emit a ClosureApply — reads code pointer, calls it with (self, args...).
let applyClosureRef
        (funcTypeIdx    : int)
        (closureTypeIdx : int)
        (captureCount   : int)
        (closureRef     : WExpr)
        (args           : WExpr list)
        (retTy          : WType)
        : WExpr =
    WExpr.ClosureApply(closureRef, args, funcTypeIdx, closureTypeIdx, captureCount, retTy)
