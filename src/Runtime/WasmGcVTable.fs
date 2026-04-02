/// WasmGC vtable infrastructure for F# interface dispatch.
///
/// Design:
///   For each interface IFoo with methods M1, M2, ...:
///     - $IFoo_Mi_func  = WTypeDef.Func([EqRef; argi...], Ti)   -- method function type
///     - $IFoo_vtable   = WTypeDef.Struct([{m1: ref $IFoo_M1_func}; ...])
///     - $IFoo_box      = WTypeDef.Struct([{vtable: ref $vtable}; {self: EqRef}])
///
///   For each implementing type ConcreteT:
///     - $ConcreteT_IFoo_Mi_wrap(self: eqref, args...) → Ti   -- wrapper: cast + delegate
///     - $ConcreteT_IFoo_vtable : (ref $IFoo_vtable) = struct.new [ref.func $wrap1, ...]
///
///   TypeCast (obj :> IFoo):
///     struct.new $IFoo_box (global.get $ConcreteT_IFoo_vtable, obj)
///
///   CallVirtual(box, boxTypeIdx, vtableTypeIdx, methodIdx, funcTypeIdx, args, retTy)
///     → vtable dispatch using struct.get + call_ref
module Fable.Transforms.WasmGc.WasmGcVTable

open Fable.AST.WasmGc
open WasmGcTypes

// ─────────────────────────────────────────────────────────────────
// Interface registration
// ─────────────────────────────────────────────────────────────────

/// Register an interface in the vtable system.
/// Creates vtable struct type and box struct type (idempotent — safe to call multiple times).
/// Returns (vtableTypeIdx, boxTypeIdx).
///
/// methodSigs = list of (methodName, paramTypes_without_self, returnType).
/// EqRef is automatically prepended to paramTypes to form the vtable functype.
let getOrRegisterInterface
        (ctx: Ctx)
        (ifaceName: string)
        (methodSigs: (string * WType list * WType) list) : int * int =
    match ctx.VTableRegistry.TryGetValue(ifaceName) with
    | true, (vtableTypeIdx, boxTypeIdx, _, _) -> vtableTypeIdx, boxTypeIdx
    | false, _ ->
        // One func type per method: (eqref, args...) -> result
        let funcTypeIndices =
            methodSigs |> List.map (fun (_, paramTypes, retType) ->
                ctx.GetOrAddFuncType(WType.EqRef :: paramTypes, retType))

        // Vtable struct: one immutable funcref field per method.
        let vtableFields =
            methodSigs |> List.mapi (fun i (name, _, _) ->
                { Name = name; Type = WType.Ref(funcTypeIndices.[i], false); Mutable = false })
        let vtableTypeIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add({ Name = $"$vtbl_{ifaceName}"; Def = WTypeDef.Struct(vtableFields, None) })

        // Box struct: { vtable: ref $vtable; self: eqref }.
        let boxFields =
            [ { Name = "vtable"; Type = WType.Ref(vtableTypeIdx, false); Mutable = false }
              { Name = "self";   Type = WType.EqRef;                      Mutable = false } ]
        let boxTypeIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add({ Name = $"$box_{ifaceName}"; Def = WTypeDef.Struct(boxFields, None) })

        ctx.VTableRegistry.[ifaceName] <- (vtableTypeIdx, boxTypeIdx, funcTypeIndices, methodSigs |> List.map (fun (n,_,_) -> n))
        vtableTypeIdx, boxTypeIdx

// ─────────────────────────────────────────────────────────────────
// Implementation registration
// ─────────────────────────────────────────────────────────────────

/// Register an interface implementation for a concrete record/struct type.
/// Generates wrapper functions and a vtable global.
///
/// implTypeName:  the F# type full name (for registry key, e.g. "MyNS.Dog")
/// concreteTypeIdx: the WasmGC struct type index of the concrete type
/// ifaceName:     the interface full name
/// methodImpls:   list of (methodName, compiledFuncName, compiledParamTypes, compiledRetType)
///                compiledParamTypes INCLUDES the concrete-type self parameter as first element.
///
/// Generates:
///   $ImplType_IFoo_methodName_wrap(self: eqref, args...) → result
///     { ref.cast (ref $concreteType) (local.get $self); ... call $compiledFuncName }
///   $ImplType_IFoo_vtable global
let registerVTableImpl
        (ctx: Ctx)
        (implTypeName: string)
        (concreteTypeIdx: int)
        (ifaceName: string)
        (vtableTypeIdx: int)
        (boxTypeIdx: int)
        (funcTypeIndices: int list)
        (methodImpls: (string * string * WType list * WType) list) : unit =
    let key = (implTypeName, ifaceName)
    if ctx.VTableImplRegistry.ContainsKey(key) then ()  // already registered
    else

    let wrapperNames =
        methodImpls |> List.mapi (fun i (methodName, compiledFunc, compiledParams, compiledRet) ->
            let wrapperName = $"${implTypeName}_{ifaceName}_{methodName}_wrap"
            let funcTypeIdx = funcTypeIndices.[i]

            // Wrapper params: (self: eqref, non-self args from compiled signature).
            // compiledParams[0] is the concrete self type; skip it and use EqRef instead.
            let wrapperArgs, bodyArgs =
                match compiledParams with
                | _ :: rest ->
                    // Wrapper takes eqref self + the rest positionally
                    let wrapperParams = ("$self", WType.EqRef) :: List.mapi (fun i ty -> $"$arg_{i}", ty) rest
                    let bodyArgExprs =
                        // First arg: cast eqref self to concrete type, then pass rest
                        WExpr.Cast(WExpr.LocalGet("$self", WType.EqRef), WType.Ref(concreteTypeIdx, false))
                        :: (rest |> List.mapi (fun i ty -> WExpr.LocalGet($"$arg_{i}", ty)))
                    wrapperParams, bodyArgExprs
                | [] ->
                    // No self param (unusual for interface methods, but handle gracefully)
                    [ "$self", WType.EqRef ], []

            let wrapperBody = WExpr.Call(compiledFunc, bodyArgs, compiledRet)
            let wrapperFunc : WFuncDecl =
                { Name = wrapperName
                  Params = wrapperArgs
                  Result = compiledRet
                  Locals = []
                  Body = wrapperBody
                  Exported = false }
            ctx.Functions.Add(wrapperFunc)
            wrapperName)

    // Vtable global: struct.new $vtable_type (ref.func wrap1, ref.func wrap2, ...)
    let vtableGlobalName = $"${implTypeName}_{ifaceName}_vtable"
    let funcRefs = wrapperNames |> List.map WExpr.FuncRef
    let vtableInit = WExpr.StructNew(vtableTypeIdx, funcRefs, WType.Ref(vtableTypeIdx, false))
    let vtableGlobal : WGlobalDecl =
        { Name = vtableGlobalName
          Type = WType.Ref(vtableTypeIdx, false)
          Init = vtableInit
          Mutable = false
          Exported = false }
    ctx.VTableGlobals.Add(vtableGlobal)
    ctx.VTableImplRegistry.[key] <- vtableGlobalName

// ─────────────────────────────────────────────────────────────────
// Boxing: (obj :> IFoo)
// ─────────────────────────────────────────────────────────────────

/// Emit a box struct that wraps a concrete object as an interface value.
/// Returns: struct.new $box_type (global.get $vtable_global, obj)
///
/// obj must already be typed as the concrete struct ref (WType.Ref(concreteTypeIdx, false)).
let emitBox
        (ctx: Ctx)
        (obj: WExpr)
        (implTypeName: string)
        (ifaceName: string)
        (boxTypeIdx: int) : WExpr =
    let key = (implTypeName, ifaceName)
    match ctx.VTableImplRegistry.TryGetValue(key) with
    | true, vtableGlobalName ->
        let vtableTypeIdx, _, _, _ = ctx.VTableRegistry.[ifaceName]
        let vtableGet = WExpr.GlobalGet(vtableGlobalName, WType.Ref(vtableTypeIdx, false))
        WExpr.StructNew(boxTypeIdx, [vtableGet; obj], WType.Ref(boxTypeIdx, false))
    | false, _ ->
        failwithf "VTable not registered for impl '%s' implementing '%s'" implTypeName ifaceName

// ─────────────────────────────────────────────────────────────────
// Dispatch: call interface method on a box
// ─────────────────────────────────────────────────────────────────

/// Emit a vtable dispatch call.
/// Returns CallVirtual(box, boxTypeIdx, vtableTypeIdx, methodIdx, funcTypeIdx, args, retTy).
let emitCallVirtual
        (ifaceName: string)
        (vtableTypeIdx: int)
        (boxTypeIdx: int)
        (funcTypeIndices: int list)
        (methodIdx: int)
        (box: WExpr)
        (args: WExpr list)
        (retTy: WType) : WExpr =
    let funcTypeIdx = funcTypeIndices.[methodIdx]
    WExpr.CallVirtual(box, boxTypeIdx, vtableTypeIdx, methodIdx, funcTypeIdx, args, retTy)
