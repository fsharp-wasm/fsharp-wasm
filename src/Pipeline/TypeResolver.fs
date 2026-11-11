/// Phase 2: Type Resolution.
///
/// Extracted from Core/Types.fs — type mapping and registry logic.
/// Converts Fable.Type to WType with on-demand type registration.
module WasmGc.Pipeline.TypeResolver

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Core.AST  // for wTypeKey, wTypesKey

// ─────────────────────────────────────────────────────────────────
// Type-keying helpers (stable string keys for registry lookup)
// ─────────────────────────────────────────────────────────────────

/// Helper functions for registry keying (imported from AST module)
let wTypesKey (types: WType list) : string =
    types |> List.map WTypeKeys.wTypeKey |> String.concat ","

// ─────────────────────────────────────────────────────────────────
// Registry helpers
// ─────────────────────────────────────────────────────────────────

/// Get or add a ref cell (FSharpRef<T>) type.
let getOrAddRefCellType (ctx: Ctx) (innerWType: WType) : int =
    let key = WTypeKeys.wTypeKey innerWType
    match ctx.RefRegistry.TryGetValue(key) with
    | true, idx -> idx
    | false, _ ->
        let typeIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add(
            { Name = $"FSharpRef_{typeIdx}"
              Def = WTypeDef.Struct([{ Name = "value"; Type = innerWType; Mutable = true }], None) })
        ctx.RefRegistry.[key] <- typeIdx
        typeIdx

/// Get or add an array type (immutable Fable array).
let getOrAddArrayType (ctx: Ctx) (elemT: WType) : int =
    let key = $"GcArr_{WTypeKeys.wTypeKey elemT}"
    match ctx.ArrayRegistry.TryGetValue(key) with
    | true, idx -> idx
    | false, _ ->
        let typeIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add(
            { Name = $"Array_{typeIdx}"
              Def = WTypeDef.Array(elemT, false) })
        ctx.ArrayRegistry.[key] <- typeIdx
        typeIdx

/// Get or add ResizeArray<T> type (growable array with data + length).
let getOrAddResizeArrayType (ctx: Ctx) (elemT: WType) : int * int =
    let key = WTypeKeys.wTypeKey elemT
    match ctx.ResizeArrayRegistry.TryGetValue(key) with
    | true, (arrTypeIdx, ravTypeIdx) -> (arrTypeIdx, ravTypeIdx)
    | false, _ ->
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let ravTypeIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add(
            { Name = $"ResizeArray_{ravTypeIdx}"
              Def = WTypeDef.Struct(
                [ { Name = "data"; Type = WType.Ref(arrTypeIdx, true); Mutable = true }
                  { Name = "length"; Type = WType.I32; Mutable = true } ],
                None) })
        ctx.ResizeArrayRegistry.[key] <- (arrTypeIdx, ravTypeIdx)
        (arrTypeIdx, ravTypeIdx)

// ─────────────────────────────────────────────────────────────────
// Main type resolution: Fable.Type → WType
// ─────────────────────────────────────────────────────────────────

/// Map a Fable type to WType, registering new types as needed.
/// Resolves generic parameters from TypeSubst (monomorphization).
let rec resolveType (ctx: Ctx) (t: Fable.Type) : WType =
    match t with
    // Resolve generic parameters from active type substitution
    | Type.GenericParam(name, _, _) ->
        match Map.tryFind name ctx.TypeSubst with
        | Some wty -> wty
        | None -> WType.I32  // unresolved — use default

    // FSharpRef<T> — mutable single-field struct
    | Type.DeclaredType(entRef, genericArgs) when entRef.FullName = "Microsoft.FSharp.Core.FSharpRef`1" ->
        let innerT = match genericArgs with | [t] -> resolveType ctx t | _ -> WType.I32
        WType.Ref(getOrAddRefCellType ctx innerT, false)

    // StringBuilder — pre-registered at index 3
    | Type.DeclaredType(entRef, _) when entRef.FullName = "System.Text.StringBuilder" ->
        WType.Ref(StringBuilderTypeIdx, false)

    // User-declared and generic types
    | Type.DeclaredType(entRef, genericArgs) ->
        // Try generic instance key first (for on-demand registered DUs like Result<T,E>)
        if not genericArgs.IsEmpty then
            let argKeys = genericArgs |> List.map (fun t -> WTypeKeys.wTypeKey (resolveType ctx t)) |> String.concat ","
            let instKey = $"{entRef.FullName}<{argKeys}>"
            match ctx.GenericDuRegistry.TryGetValue(instKey) with
            | true, idx -> WType.Ref(idx, false)
            | false, _ ->
                // Fall back to non-generic key (ClassDeclaration-registered types)
                match Map.tryFind entRef.FullName ctx.TypeRegistry with
                | Some idx -> WType.Ref(idx, false)
                | None -> WType.I32
        else
            match Map.tryFind entRef.FullName ctx.TypeRegistry with
            | Some idx -> WType.Ref(idx, false)
            | None ->
                // Check if it's a registered interface (vtable box struct)
                if ctx.VTableRegistry.ContainsKey(entRef.FullName) then
                    let _, boxTypeIdx, _, _ = ctx.VTableRegistry.[entRef.FullName]
                    WType.Ref(boxTypeIdx, false)
                else WType.I32

    // Tuple types
    | Type.AnonymousRecordType(_, fieldTypes, isStruct) -> resolveType ctx (Type.Tuple(fieldTypes, isStruct))
    | Type.Tuple(elementTypes, _) ->
        let wTypes = elementTypes |> List.map (resolveType ctx)
        let key = wTypesKey wTypes
        match ctx.TupleRegistry.TryGetValue(key) with
        | true, idx -> WType.Ref(idx, false)
        | false, _ ->
            let typeIdx = ctx.TypeDefs.Count
            let fields =
                wTypes |> List.mapi (fun i ft ->
                    { Name = $"Item{i + 1}"; Type = ft; Mutable = false })
            ctx.TypeDefs.Add(
                { Name = $"Tuple_{typeIdx}"
                  Def = WTypeDef.Struct(fields, None) })
            ctx.TupleRegistry.[key] <- typeIdx
            WType.Ref(typeIdx, false)

    // Option types
    | Type.Option(innerType, _) ->
        let innerWType = resolveType ctx innerType
        match innerWType with
        | WType.Ref(innerIdx, false) ->
            // Non-null inner ref — use nullable ref directly
            WType.Ref(innerIdx, true)
        | _ ->
            // Primitive inner or already-nullable → wrapper struct
            let key = WTypeKeys.wTypeKey innerWType
            match ctx.OptionRegistry.TryGetValue(key) with
            | true, idx -> WType.Ref(idx, true)
            | false, _ ->
                let typeIdx = ctx.TypeDefs.Count
                ctx.TypeDefs.Add(
                    { Name = $"Option_{typeIdx}"
                      Def = WTypeDef.Struct([{ Name = "value"; Type = innerWType; Mutable = false }], None) })
                ctx.OptionRegistry.[key] <- typeIdx
                WType.Ref(typeIdx, true)

    // List types
    | Type.List(elementType) ->
        let elemWType = resolveType ctx elementType
        let key = WTypeKeys.wTypeKey elemWType
        if not (ctx.ListRegistry.ContainsKey(key)) then
            let typeIdx = ctx.TypeDefs.Count
            ctx.TypeDefs.Add(
                { Name = $"ListCons_{typeIdx}"
                  Def = WTypeDef.Struct(
                    [ { Name = "head"; Type = elemWType; Mutable = false }
                      { Name = "tail"; Type = WType.Ref(ListBaseTypeIdx, true); Mutable = false } ],
                    Some ListBaseTypeIdx) })
            ctx.ListRegistry.[key] <- typeIdx
        WType.Ref(ListBaseTypeIdx, true)

    // ResizeArray types
    | Type.Array(elementType, ArrayKind.ResizeArray) ->
        let elemT = resolveType ctx elementType
        let (_, ravTypeIdx) = getOrAddResizeArrayType ctx elemT
        WType.Ref(ravTypeIdx, false)

    // Regular array types
    | Type.Array(elementType, _) ->
        let elemT = resolveType ctx elementType
        WType.Ref(getOrAddArrayType ctx elemT, false)

    // Primitive types
    | _ -> resolvePrimitiveType t

/// Resolve primitive Fable types to WType (no registration needed).
and resolvePrimitiveType (t: Fable.Type) : WType =
    match t with
    | Type.Unit -> WType.Void
    | Type.Boolean -> WType.I32
    | Type.Char -> WType.I32
    | Type.String -> WType.Ref(StringTypeIdx, false)
    | Type.Number(kind, _) ->
        match kind with
        | Int8 | UInt8 | Int16 | UInt16 | Int32 | UInt32 -> WType.I32
        | Int64 | UInt64 | BigInt -> WType.I64
        | Float32 -> WType.F32
        | Float64 -> WType.F64
        | NativeInt | UNativeInt -> WType.I32
        | _ -> WType.I32
    | Type.LambdaType _ -> WType.Ref(AnyFnTypeIdx, false)
    | Type.DelegateType _ -> WType.Ref(AnyFnTypeIdx, false)
    | Type.Tuple _ -> WType.I32
    | Type.Option _ -> WType.I32
    | Type.List _ -> WType.I32
    | Type.Array _ -> WType.I32
    | Type.DeclaredType _ -> WType.I32
    | Type.Any -> WType.I32
    | Type.GenericParam _ -> WType.I32
    | _ -> WType.I32

/// Resolve type, converting Void result to appropriate type.
let resolveResultType (ctx: Ctx) (t: Fable.Type) : WType =
    match t with
    | Type.Unit -> WType.Void
    | _ -> resolveType ctx t
