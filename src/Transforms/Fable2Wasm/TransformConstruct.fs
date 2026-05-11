module WasmGc.Transforms.TransformConstruct

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core

module VT = WasmGc.Runtime.VTable

/// Baut eine If-Then-Else Wasm-Expression
let buildIf (wGuard: WExpr) (wThen: WExpr) (wElse: WExpr) (ty: WType) =
    WExpr.If(wGuard, wThen, wElse, ty)

/// Baut eine Wasm While-Schleife
let buildWhile (wGuard: WExpr) (wBody: WExpr) =
    let label = "$while"
    let loopBody =
        WExpr.If(
            wGuard,
            WExpr.Sequence [wBody; WExpr.Continue(label, [])],
            WExpr.Nop,
            WType.Void
        )
    WExpr.Loop(label, loopBody, WType.Void)

let buildFor
    (ctx: Ctx)
    (ident: Ident)
    (wStart: WExpr)
    (wLimit: WExpr)
    (wBody: WExpr)
    isUp =
    let label = "$for"

    let cmpOp = if isUp then WCompareOp.LeS else WCompareOp.GeS
    let stepOp = if isUp then WBinaryOp.Add else WBinaryOp.Sub
    // let i = start
    // loop $for {
    //   if (i <= limit) { body; i = i + 1; continue $for }
    // }
    let loopBody =
        WExpr.If(
            WExpr.Compare(cmpOp, WExpr.LocalGet(ident.Name, WType.I32), localGet "$limit" WType.I32),
            WExpr.Sequence [
                wBody
                WExpr.Assign(ident.Name, WExpr.Binary(stepOp, WExpr.LocalGet(ident.Name, WType.I32), i32One, WType.I32))
                WExpr.Continue(label, [])
            ],
            WExpr.Nop,
            WType.Void
        )
    WExpr.Let(ident.Name, wStart,
        WExpr.Let("$limit", wLimit,
            WExpr.Loop(label, loopBody, WType.Void)))

// ── Type cast ─────────────────────────────────────────
/// Baut einen TypeCast
let buildTypeCast (ctx: Ctx) (wExpr: WExpr) (targetFableType: Fable.Type) : WExpr =
    let srcTy = exprWType wExpr
    // Use mapTypeKnown so DeclaredType → Ref(typeIdx) when registered (vs. mapType → I32).
    let dstTyKnown = mapTypeKnown ctx targetFableType
    let dstTy = mapType targetFableType
    if srcTy = dstTyKnown then wExpr
    else
        match srcTy, dstTyKnown with
        // ── AnyRef → concrete struct ref: ref.cast (used in exception catch bindings) ─
        | WType.AnyRef, WType.Ref(typeIdx, _) -> WExpr.Cast(wExpr, WType.Ref(typeIdx, false))
        // ── Nullable ref → concrete non-null ref: ref.cast ─
        | WType.Ref(_, true), WType.Ref(typeIdx, false) -> WExpr.Cast(wExpr, WType.Ref(typeIdx, false))
        | _ ->
            match srcTy, dstTy with
            // ── Truncation (float → int) ───
            | WType.F64, WType.I32 -> WExpr.Unary(WUnaryOp.TruncF64S,    wExpr, WType.I32)
            | WType.F32, WType.I32 -> WExpr.Unary(WUnaryOp.TruncF32S,    wExpr, WType.I32)
            | WType.F64, WType.I64 -> WExpr.Unary(WUnaryOp.TruncF64S,    wExpr, WType.I64)
            | WType.F32, WType.I64 -> WExpr.Unary(WUnaryOp.TruncF32S,    wExpr, WType.I64)
            // ── Wrap / Extend (int width changes) ─
            | WType.I64, WType.I32 -> WExpr.Unary(WUnaryOp.WrapI64,      wExpr, WType.I32)
            | WType.I32, WType.I64 -> WExpr.Unary(WUnaryOp.ExtendI32S,   wExpr, WType.I64)
            // ── Convert (int → float) ─────
            | WType.I32, WType.F64 -> WExpr.Unary(WUnaryOp.ConvertI32S,  wExpr, WType.F64)
            | WType.I64, WType.F64 -> WExpr.Unary(WUnaryOp.ConvertI64S,  wExpr, WType.F64)
            | WType.I32, WType.F32 -> WExpr.Unary(WUnaryOp.ConvertI32S,  wExpr, WType.F32)
            | WType.I64, WType.F32 -> WExpr.Unary(WUnaryOp.ConvertI64S,  wExpr, WType.F32)
            // ── Float width changes ────────
            | WType.F32, WType.F64 -> WExpr.Unary(WUnaryOp.PromoteF32,   wExpr, WType.F64)
            | WType.F64, WType.F32 -> WExpr.Unary(WUnaryOp.DemoteF64,    wExpr, WType.F32)
            // ── Interface boxing: upcasting a concrete struct ref to an interface type ──
            | WType.Ref(concreteTypeIdx, false), WType.I32 ->
                // Interface types currently map to I32 (not yet registered in TypeRegistry).
                // If the target is a known interface in VTableRegistry, emit a box.
                match targetFableType with
                | Fable.Type.DeclaredType(targetEntRef, _) ->
                    let ifaceName = targetEntRef.FullName
                    match ctx.VTableRegistry.TryGetValue(ifaceName) with
                    | true, (_, boxTypeIdx, _, _) ->
                        match ctx.TypeRegistry |> Map.tryFindKey (fun _ idx -> idx = concreteTypeIdx) with
                        | Some implTypeName ->
                            VT.emitBox ctx wExpr implTypeName ifaceName boxTypeIdx
                        | None -> wExpr
                    | false, _ -> wExpr
                | _ -> wExpr
            // ── Unsupported / same ref type → passthrough ─
            | _ -> wExpr

/// convert Fable consts in Wasm consts
let transformValue (ctx: Ctx) (kind: ValueKind) (eval: Ctx -> Fable.Expr -> WExpr) : WExpr =
    match kind with
    | UnitConstant -> WExpr.Nop
    | BoolConstant b -> WExpr.Const(WConst.I32(if b then 1 else 0))
    | CharConstant c -> WExpr.Const(WConst.I32(int c))
    | StringConstant s ->
        // Encode string as (array i32) — each element is a UTF-16 code unit.
        let strType = WType.Ref(StringTypeIdx, false)
        if s.Length = 0 then
            WExpr.ArrayNewFixed(StringTypeIdx, [], strType)
        else
            let chars = s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList
            WExpr.ArrayNewFixed(StringTypeIdx, chars, strType)

    | StringTemplate(_, parts, holes) ->
        // F# interpolated string: "...{hole0}...{hole1}..."
        // parts.Length = holes.Length + 1; interleave them and concatenate.
        let strRef = WType.Ref(StringTypeIdx, false)
        let emitStr (s: string) =
            if s.Length = 0 then WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
            else WExpr.ArrayNewFixed(StringTypeIdx, s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList, strRef)
        let holeToStr (h: Fable.Expr) =
            let wh = eval ctx h
            match exprWType wh with
            | WType.Ref(idx, _) when idx = StringTypeIdx -> wh
            | WType.I32 -> WExpr.Call(ctx.UseHelper("$intToStr"), [wh], strRef)
            | WType.I64 -> WExpr.Call(ctx.UseHelper("$intToStr"), [WExpr.Unary(WUnaryOp.WrapI64, wh, WType.I32)], strRef)
            | WType.F64 -> WExpr.Call(ctx.UseHelper("$floatToStr"), [wh], strRef)
            | WType.F32 ->
                let wf64 = WExpr.Unary(WUnaryOp.PromoteF32, wh, WType.F64)
                WExpr.Call(ctx.UseHelper("$floatToStr"), [wf64], strRef)
            | _ -> WExpr.Call(ctx.UseHelper("$intToStr"), [wh], strRef)
        // Build list: [part0; holeStr0; part1; holeStr1; ...; partN]
        let nHoles = List.length holes
        let partsForHoles = if nHoles = 0 then [] else List.take nHoles parts
        let zipped = List.map2 (fun p h -> [emitStr p; holeToStr h]) partsForHoles holes
        let segments =
            (List.collect id zipped)
            @ (match List.tryLast parts with Some last -> [emitStr last] | None -> [])
        // Fold with $strConcat
        match segments with
        | [] -> WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
        | [single] -> single
        | head :: tail ->
            tail |> List.fold (fun acc s -> WExpr.Call(ctx.UseHelper("$strConcat"), [acc; s], strRef)) head
    | NumberConstant(value, _) ->
        match value with
        | NumberValue.Int8 n -> WExpr.Const(WConst.I32(int n))
        | NumberValue.UInt8 n -> WExpr.Const(WConst.I32(int n))
        | NumberValue.Int16 n -> WExpr.Const(WConst.I32(int n))
        | NumberValue.UInt16 n -> WExpr.Const(WConst.I32(int n))
        | NumberValue.Int32 n -> WExpr.Const(WConst.I32 n)
        | NumberValue.UInt32 n -> WExpr.Const(WConst.I32(int n))
        | NumberValue.Int64 n -> WExpr.Const(WConst.I64 n)
        | NumberValue.UInt64 n -> WExpr.Const(WConst.I64(int64 n))
        | NumberValue.Float32 n -> WExpr.Const(WConst.F32 n)
        | NumberValue.Float64 n -> WExpr.Const(WConst.F64 n)
        | NumberValue.NativeInt n -> WExpr.Const(WConst.I32(int n))
        | NumberValue.UNativeInt n -> WExpr.Const(WConst.I32(int n))
        | _ -> i32Zero // fallback
    | Null _ -> WExpr.Const(WConst.Null(WType.I32))
    // ── Records (Phase 3) ────────────────────────────────
    | NewRecord(values, entRef, _) ->
        match Map.tryFind entRef.FullName ctx.TypeRegistry with
        | Some typeIdx ->
            let wValues = values |> List.map (eval ctx)
            WExpr.StructNew(typeIdx, wValues, WType.Ref(typeIdx, false))
        | None ->
            // Record type not registered yet — emit stub
            i32Zero
    // ── Discriminated unions (Phase 4) ─────────────────
    | NewUnion(values, tag, entRef, genArgs) ->
        let ent = ctx.Compiler.GetEntity(entRef)
        let isEnumLike = ent.UnionCases |> List.forall (fun c -> c.UnionCaseFields.IsEmpty)
        if isEnumLike then
            // Enum-like: the tag IS the value
            WExpr.Const(WConst.I32 tag)
        else
            // Data-carrying: construct the case struct, result type is the base ref.
            // On-demand registration for generic types (Result<T,E>, Choice2, etc.) not
            // registered via ClassDeclaration. Uses GenericDuRegistry (mutable dictionary).
            let instKey =
                if genArgs.IsEmpty then entRef.FullName
                else
                    let argKeys = genArgs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
                    $"{entRef.FullName}<{argKeys}>"
            // Build a substitution map from generic param names to concrete types.
            let substMap =
                if genArgs.IsEmpty then Map.empty
                else
                    let paramNames = ent.GenericParameters |> List.map (fun p -> p.Name)
                    (paramNames, genArgs) ||> List.zip |> Map.ofList
            // Substitute a Fable generic param type using the substitution map.
            let substituteType (t: Fable.Type) : Fable.Type =
                match t with
                | Fable.Type.GenericParam(name, _, _) ->
                    match Map.tryFind name substMap with
                    | Some concreteType -> concreteType
                    | None -> t
                | _ -> t
            // Try to find or register base type + case types in GenericDuRegistry.
            let baseIdx =
                // First check GenericDuRegistry (for generic types registered on-demand)
                match ctx.GenericDuRegistry.TryGetValue(instKey) with
                | true, idx -> idx
                | false, _ ->
                    // Also check TypeRegistry (for ClassDeclaration-registered types)
                    match Map.tryFind instKey ctx.TypeRegistry with
                    | Some idx -> idx
                    | None ->
                        // Not yet registered — register now using concrete genArgs.
                        let baseIdx = ctx.TypeDefs.Count
                        let cases = ent.UnionCases
                        // Pre-register all indices.
                        ctx.GenericDuRegistry.[instKey] <- baseIdx
                        for i in 0 .. cases.Length - 1 do
                            ctx.GenericDuRegistry.[$"{instKey}#{i}"] <- baseIdx + 1 + i
                        // Emit base struct: { tag: i32 }
                        ctx.TypeDefs.Add(
                            { Name = instKey
                              Def = WTypeDef.Struct([{ Name = "tag"; Type = WType.I32; Mutable = false }], None) })
                        // Emit case structs, each extending the base.
                        for i in 0 .. cases.Length - 1 do
                            let case = cases.[i]
                            let dataFields =
                                case.UnionCaseFields
                                |> List.map (fun f ->
                                    let concreteType = substituteType f.FieldType
                                    { Name = f.Name; Type = mapTypeKnown ctx concreteType; Mutable = false })
                                |> List.filter (fun f -> f.Type <> WType.Void)
                            ctx.TypeDefs.Add(
                                { Name = $"{instKey}#{i}"
                                  Def = WTypeDef.Struct(
                                        { Name = "tag"; Type = WType.I32; Mutable = false } :: dataFields,
                                        Some baseIdx) })
                        baseIdx
            // Build the case key and look up in both registries.
            let caseKey = $"{instKey}#{tag}"
            let caseTypeIdxOpt =
                match ctx.GenericDuRegistry.TryGetValue(caseKey) with
                | true, idx -> Some idx
                | false, _ -> Map.tryFind caseKey ctx.TypeRegistry
            match caseTypeIdxOpt with
            | Some caseTypeIdx ->
                let wTag = WExpr.Const(WConst.I32 tag)
                let wFields = values |> List.map (eval ctx)
                WExpr.StructNew(caseTypeIdx, wTag :: wFields, WType.Ref(baseIdx, false))
            | None ->
                // Still not found (shouldn't happen after registration) — fall back
                eprintfn "[WasmGc] WARNING: DU case '%s' not found after registration" caseKey
                WExpr.Const(WConst.I32 tag)
    // ── Tuples (Phase 5-ish) ────────────────────────────────
    | NewTuple(values, _isStruct) ->
        // Determine/register the struct type for this tuple shape.
        let wValues = values |> List.map (eval ctx)
        let wTypes = wValues |> List.map exprWType
        let key = wTypesKey wTypes
        let typeIdx =
            match ctx.TupleRegistry.TryGetValue(key) with
            | true, idx -> idx
            | false, _ ->
                let idx = ctx.TypeDefs.Count
                let fields = wTypes |> List.mapi (fun i ft -> { Name = $"Item{i + 1}"; Type = ft; Mutable = false })
                ctx.TypeDefs.Add({ Name = $"Tuple_{idx}"; Def = WTypeDef.Struct(fields, None) })
                ctx.TupleRegistry.[key] <- idx
                idx
        WExpr.StructNew(typeIdx, wValues, WType.Ref(typeIdx, false))
    // ── Option<T> ───────────────────────────────────────────
    | NewOption(value, innerType, _) ->
        // Use mapTypeKnown to check the inner type's representation.
        // If inner is a non-null ref (records, tuples, arrays, DUs, strings),
        // we use a nullable ref directly: null=None, non-null=Some.
        // If inner is a primitive (I32/F64) or already-nullable ref (lists, nested options),
        // we fall back to a wrapper struct $Option_N { value }.
        let innerWType = mapTypeKnown ctx innerType
        match innerWType with
        | WType.Ref(innerIdx, false) ->
            // Direct-ref option: no wrapper struct, zero extra allocation.
            let nullableRef = WType.Ref(innerIdx, true)
            match value with
            | Some expr -> eval ctx expr   // Some(v) = v itself (non-null ref)
            | None      -> WExpr.Const(WConst.Null nullableRef)
        | _ ->
            // Wrapper-struct option: get-or-create $Option_N { value: innerWType }.
            let key = wTypeKey innerWType
            let optTypeIdx =
                match ctx.OptionRegistry.TryGetValue(key) with
                | true, idx -> idx
                | false, _ ->
                    let idx = ctx.TypeDefs.Count
                    ctx.TypeDefs.Add(
                        { Name = $"Option_{idx}"
                          Def = WTypeDef.Struct([{ Name = "value"; Type = innerWType; Mutable = false }], None) })
                    ctx.OptionRegistry.[key] <- idx
                    idx
            match value with
            | Some expr ->
                let wV = eval ctx expr
                WExpr.StructNew(optTypeIdx, [wV], WType.Ref(optTypeIdx, true))
            | None ->
                WExpr.Const(WConst.Null(WType.Ref(optTypeIdx, true)))
    // ── List<T> ─────────────────────────────────────────────
    // ── F# arrays [|...|] and Array.create / Array.zeroCreate ────────────
    // ResizeArray<T> grows: create a mutable struct { data: $Arr_T; len: i32 } with initial capacity 4.
    | NewArray(Fable.NewArrayKind.ArrayValues _, elemType, Fable.ArrayKind.ResizeArray) ->
        let elemT = mapTypeKnown ctx elemType
        let (arrTypeIdx, ravTypeIdx) = getOrAddResizeArrayType ctx elemT
        let zero = makeNumericZero elemT
        WExpr.StructNew(ravTypeIdx,
            [WExpr.ArrayNew(arrTypeIdx, i32Const 4, zero, WType.Ref(arrTypeIdx, false))
             i32Zero],
            WType.Ref(ravTypeIdx, false))
    | NewArray(Fable.NewArrayKind.ArrayValues exprs, elemType, _) ->
        let elemT = mapTypeKnown ctx elemType
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let wVals = exprs |> List.map (eval ctx)
        WExpr.ArrayNewFixed(arrTypeIdx, wVals, WType.Ref(arrTypeIdx, false))
    | NewArray(Fable.NewArrayKind.ArrayAlloc sizeExpr, elemType, _) ->
        let elemT = mapTypeKnown ctx elemType
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let wSize = eval ctx sizeExpr
        let zero =
            match elemT with
            | WType.I64 -> i64Const 0L
            | WType.F32 -> f32Const 0.0f
            | WType.F64 -> f64Const 0.0
            | _ -> i32Zero
        WExpr.ArrayNew(arrTypeIdx, wSize, zero, WType.Ref(arrTypeIdx, false))
    | NewArray(Fable.NewArrayKind.ArrayFrom srcExpr, elemType, _) ->
        // ArrayFrom: copy from another array/seq. Treat as identity for now (same wasm array ref).
        eval ctx srcExpr
    | NewList(value, elementType) ->
        // Ensure the $ListCons_T type is registered. mapTypeKnown always returns Ref(ListBaseTypeIdx).
        let _ = mapTypeKnown ctx (Fable.Type.List(elementType))
        let elemWType = mapTypeKnown ctx elementType
        let elemKey = wTypeKey elemWType
        let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
        match value with
        | None ->
            // Empty list: ref.null $ListBase (the unified list base type)
            WExpr.Const(WConst.Null(listBaseRefT))
        | Some(headExpr, tailExpr) ->
            // Cons: struct.new $ListCons_T { head = h; tail = t }
            // Type annotation is $ListBase (nullable) — all list vars use this type.
            let wHead = eval ctx headExpr
            let wTail = eval ctx tailExpr
            match ctx.ListRegistry.TryGetValue(elemKey) with
            | true, listConsIdx ->
                WExpr.StructNew(listConsIdx, [wHead; wTail], listBaseRefT)
            | _ -> WExpr.Nop
    | _ -> WExpr.Nop // TODO: other values