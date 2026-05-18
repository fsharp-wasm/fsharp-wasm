/// VTable dispatch patterns — pure WExpr, no Fable.AST.
/// The actual Ctx mutation (registering new type defs) stays in Runtime/VTable.fs
/// since it needs Ctx. This module holds the pure WExpr emission side.
module WasmGc.Patterns.VTable

open WasmGc.Core.AST
open WasmGc.Builder.Core

/// Emit a virtual dispatch call through a vtable field.
/// `obj` — the receiver (ref $concreteType)
/// `vtableFieldIdx` — index of the vtable pointer field in the object struct
/// `methodFieldIdx` — index of the method in the vtable struct
/// `funcTypeIdx`    — the function type index for call_ref
let dispatchVirtual
        (obj            : WExpr)
        (vtableFieldIdx : int)
        (methodFieldIdx : int)
        (vtableTy       : WType)
        (methodTy       : WType)
        (funcTypeIdx    : int)
        (args           : WExpr list)
        (retTy          : WType)
        : WExpr =
    let vtableRef  = WExpr.StructGet(obj, vtableFieldIdx, vtableTy)
    let methodPtr  = WExpr.StructGet(vtableRef, methodFieldIdx, methodTy)
    WExpr.CallRef(funcTypeIdx, args, methodPtr, retTy)

/// Cast object to interface type and read interface vtable pointer.
let castAndReadVTable (interfaceTypeIdx: int) (vtableFieldIdx: int) (vtableTy: WType) (obj: WExpr) : WExpr =
    let cast = WExpr.Cast(obj, WType.Ref(interfaceTypeIdx, false))
    WExpr.StructGet(cast, vtableFieldIdx, vtableTy)
