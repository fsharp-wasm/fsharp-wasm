/// Fable AST → WasmGc IR translation.
/// Phase 1: Handles minimal Fable AST cases for integers, floats,
/// let bindings, arithmetic, functions, and control flow.
module WasmGc.Transforms.Fable2Wasm

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc.Runtime.Types
open WasmGc.Runtime.FreeVars
open WasmGc.Runtime.LoopHelpers
open WasmGc.Builder
open WasmGc.Runtime.Runtime
open WasmGc.Runtime.Locals
open WasmGc.Runtime.Equality
module RT = WasmGc.Runtime.Runtime
module VT = WasmGc.Runtime.VTable
module Lc = WasmGc.Runtime.Locals
module Val = WasmGc.PipelineValidator
open WasmGc.Transforms.OptionResult
open WasmGc.Transforms.ListCombinators
open WasmGc.Transforms.ListOps

open WasmGc.Transforms.TransformClosures
open WasmGc.Transforms.TransformDispatch


open WasmGc.Transforms.Helpers

/// Inline grow-and-set for ResizeArray.push.
/// wRav: the ResizeArray struct ref.  wVal: value to append.
let private resizeArrayPushInline (ctx: Ctx) (elemT: WType) (arrTypeIdx: int) (ravTypeIdx: int)
                                   (wRav: WExpr) (wVal: WExpr) : WExpr =
    let arrRefT   = WType.Ref(arrTypeIdx, true)
    let arrNNRefT = WType.Ref(arrTypeIdx, false)
    let zero      = makeNumericZero elemT
    wasm {
        let! rav  = wRav
        let! len  = WExpr.StructGet(rav, 1, WType.I32)
        let! data = WExpr.Cast(WExpr.StructGet(rav, 0, arrRefT), arrNNRefT)
        // When len = capacity, double the array and update the struct.
        do! WExpr.If(WExpr.Compare(WCompareOp.GeU, len, WExpr.ArrayLen(data)),
                wasm {
                    let! newCap = WExpr.Binary(WBinaryOp.Shl, WExpr.ArrayLen(data),
                                    WExpr.Const(WConst.I32 1), WType.I32)
                    let! newDat = WExpr.ArrayNew(arrTypeIdx, newCap, zero, arrNNRefT)
                    do! WExpr.ArrayCopy(newDat, WExpr.Const(WConst.I32 0),
                                        data,   WExpr.Const(WConst.I32 0), len)
                    return! WExpr.StructSet(rav, 0, newDat)
                }, WExpr.Nop, WType.Void)
        // Re-read data (may have changed after grow)
        do! WExpr.ArraySet(WExpr.Cast(WExpr.StructGet(rav, 0, arrRefT), arrNNRefT), len, wVal)
        return! WExpr.StructSet(rav, 1,
            WExpr.Binary(WBinaryOp.Add, len, WExpr.Const(WConst.I32 1), WType.I32))
    }

let rec transformExpr (ctx: Ctx) (expr: Fable.Expr) : WExpr =
    match expr with
    // ── Emit: ResizeArray.Add(x) emits "void ($0)" wrapping a .push() InstanceCall ──
    | Fable.Expr.Emit(info, _, _)
          when info.Macro = "void ($0)" ->
        match info.CallInfo.Args with
        | [Fable.Expr.Call(Fable.Expr.Get(ar, GetKind.FieldGet fi, _, _), pushInfo, _, _)]
              when fi.Name = "push" &&
                   (match ar.Type with | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) -> true | _ -> false) ->
            match pushInfo.Args with
            | [arg] ->
                let elemFableType = match ar.Type with | Fable.Type.Array(t, _) -> t | _ -> Fable.Type.Any
                let elemWT = mapTypeKnown ctx elemFableType
                let (arrTypeIdx, ravTypeIdx) = getOrAddResizeArrayType ctx elemWT
                resizeArrayPushInline ctx elemWT arrTypeIdx ravTypeIdx (transformExpr ctx ar) (transformExpr ctx arg)
            | _ -> WExpr.Nop
        | _ -> WExpr.Nop
    // ── Constants ──────────────────────────────────────────
    | Fable.Expr.Value(kind, _) ->
        transformValue ctx kind

    // ── Identifier references ─────────────────────────────
    | Fable.Expr.IdentExpr ident ->
        // Use mapTypeKnown so local variables holding records get proper ref types
        let ty =
            match Map.tryFind ident.Name ctx.Locals with
            | Some knownTy -> knownTy
            | None -> mapTypeKnown ctx ident.Type

        match Map.tryFind ident.Name ctx.Locals with
        | Some _ ->
            // Genuine local variable — emit LocalGet.
            WExpr.LocalGet(ident.Name, ty)
        | None ->
            // Not a local. Check if it's a known (module-level) function.
            let actualName =
                ctx.FuncNameAlias
                |> Map.tryFind ident.Name
                |> Option.defaultValue ident.Name
            match Map.tryFind actualName ctx.KnownFuncs with
            | Some([], retTy) when retTy <> WType.Void ->
                // Zero-argument function (module-level value / builder instance).
                // Emit as a direct call: `div ()` → WExpr.Call("div", [], retTy).
                WExpr.Call(actualName, [], retTy)
            | Some([], WType.Void) ->
                // Zero-arg void function used as a value — shouldn't happen, but guard.
                WExpr.Call(actualName, [], WType.Void)
            | Some _ ->
                // Non-zero-arg function referenced as a value — this is a partial application
                // or a higher-order reference. Build a closure for it.
                // (This case rarely hits here; most partial apps go through CurriedApply.)
                WExpr.LocalGet(ident.Name, ty)  // let existing buildClosure path handle it
            | None ->
                // Unknown identifier — fall back to LocalGet (emits a warning via validator).
                WExpr.LocalGet(ident.Name, ty)

    // ── Let bindings ──────────────────────────────────────
    | Fable.Expr.Let(ident, value, body) ->
        let wValue = transformExpr ctx value
        // Prefer the actual WExpr type (from the value) over the declared type;
        // this correctly handles Let-bound record/DU values.
        let ty =
            let declaredTy = mapTypeKnown ctx ident.Type
            if declaredTy = WType.I32 then
                // Fall back to the inferred type from the value expression;
                // this handles the case where mapTypeKnown doesn't know the type yet.
                let inferredTy = exprWType wValue
                if inferredTy <> WType.I32 && inferredTy <> WType.Void then inferredTy else declaredTy
            else declaredTy
        let ctx' = ctx.WithLocal(ident.Name, ty)
        let wBody = transformExpr ctx' body
        if ident.IsMutable then
            WExpr.LetMut(ident.Name, wValue, wBody)
        else
            WExpr.Let(ident.Name, wValue, wBody)

    // ── Let rec bindings ──────────────────────────────────
    | Fable.Expr.LetRec(bindings, body) ->
        // Detect mutual-closure pattern: ALL bindings are lambdas/delegates.
        // Sequential lets can't handle mutual calls (dispatch ↔ render in Elmish).
        // We use a ref-cell strategy: allocate a mutable AnyFn slot per binding,
        // build each closure capturing sibling slots, fill slots after closure creation.
        let allAreLambdas =
            bindings |> List.forall (fun (_, v) ->
                match v with Fable.Expr.Lambda _ | Fable.Expr.Delegate _ -> true | _ -> false)

        if allAreLambdas && bindings.Length > 1 then
            buildLetRecLambdas ctx transformExpr bindings body
        else
        // Non-lambda LetRec (e.g. value-level or module-level)  — sequential lets as before.
        let folder (ctx: Ctx) (ident: Ident, value: Fable.Expr) =
            let wValue = transformExpr ctx value
            let ty = mapTypeKnown ctx ident.Type
            ctx.WithLocal(ident.Name, ty), (ident.Name, wValue, ty)

        let ctx', binds =
            ((ctx, []), bindings)
            ||> List.fold (fun (ctx, acc) binding ->
                let ctx', b = folder ctx binding
                ctx', b :: acc
            )
        let binds = List.rev binds
        let wBody = transformExpr ctx' body
        // Chain let bindings
        (binds, wBody)
        ||> List.foldBack (fun (name, value, _ty) acc ->
            WExpr.Let(name, value, acc)
        )

    // ── Sequential (statement list) ───────────────────────
    | Fable.Expr.Sequential exprs ->
        let wExprs = exprs |> List.map (transformExpr ctx)
        WExpr.Sequence wExprs

    // ── Operations ────────────────────────────────────────
    | Fable.Expr.Operation(kind, _tags, typ, _range) ->
        // TODO: for better diagnostics, we could match on the operation kind and print more info about it here
        // (match kind with
        //  | Unary(op, _) -> eprintfn "[WasmGc] Unary op=%A mapType=%A in func=%A" op (mapType typ) ctx.CurrentFunc
        //  | _ -> ())
        transformOperation ctx kind typ

    // ── Function calls ────────────────────────────────────
    | Fable.Expr.Call(callee, info, typ, _range) ->
        // TODO: for better diagnostics, we could match on the callee expression and print more info about it here
        // eprintfn "[WasmGc] Call callee=%A in func=%A" callee ctx.CurrentFunc
        transformCall ctx transformExpr callee info typ

    // ── If/Then/Else ──────────────────────────────────────
    | Fable.Expr.IfThenElse(guard, thenExpr, elseExpr, _range) ->
        let wGuard = transformExpr ctx guard
        let wThen = transformExpr ctx thenExpr
        let wElse = transformExpr ctx elseExpr
        let ty = mapTypeKnown ctx thenExpr.Type
        WExpr.If(wGuard, wThen, wElse, ty)

    // ── While loop ────────────────────────────────────────
    | Fable.Expr.WhileLoop(guard, body, _range) ->
        let label = "$while"
        let wGuard = transformExpr ctx guard
        let wBody = transformExpr ctx body
        // loop $while { br_if (not guard) $while_exit; body; continue $while }
        let loopBody =
            WExpr.If(
                wGuard,
                WExpr.Sequence [wBody; WExpr.Continue(label, [])],
                WExpr.Nop,
                WType.Void
            )
        WExpr.Loop(label, loopBody, WType.Void)

    // ── For loop ──────────────────────────────────────────
    | Fable.Expr.ForLoop(ident, start, limit, body, isUp, _range) ->
        let label = "$for"
        let wStart = transformExpr ctx start
        let wLimit = transformExpr ctx limit
        let ctx' = ctx.WithLocal(ident.Name, WType.I32)
        let wBody = transformExpr ctx' body
        let cmpOp = if isUp then WCompareOp.LeS else WCompareOp.GeS
        let stepOp = if isUp then WBinaryOp.Add else WBinaryOp.Sub
        // let i = start
        // loop $for {
        //   if (i <= limit) { body; i = i + 1; continue $for }
        // }
        let loopBody =
            WExpr.If(
                WExpr.Compare(cmpOp, WExpr.LocalGet(ident.Name, WType.I32), WExpr.LocalGet("$limit", WType.I32)),
                WExpr.Sequence [
                    wBody
                    WExpr.Assign(ident.Name, WExpr.Binary(stepOp, WExpr.LocalGet(ident.Name, WType.I32), WExpr.Const(WConst.I32 1), WType.I32))
                    WExpr.Continue(label, [])
                ],
                WExpr.Nop,
                WType.Void
            )
        WExpr.Let(ident.Name, wStart,
            WExpr.Let("$limit", wLimit,
                WExpr.Loop(label, loopBody, WType.Void)))

    // ── Set (mutation) ────────────────────────────────────
    | Fable.Expr.Set(_expr, kind, _typ, value, _range) ->
        match kind with
        | ValueSet ->
            match _expr with
            | Fable.Expr.IdentExpr ident ->
                let wValue = transformExpr ctx value
                WExpr.Assign(ident.Name, wValue)
            | _ ->
                WExpr.Nop // TODO
        | FieldSet fieldName ->
            // Mutable record field assignment (Phase 3)
            match _expr.Type with
            | Fable.Type.DeclaredType(entRef, _) ->
                match Map.tryFind entRef.FullName ctx.TypeRegistry with
                | Some _ ->
                    let wObj = transformExpr ctx _expr
                    let wVal = transformExpr ctx value
                    let ent = ctx.Compiler.GetEntity(entRef)
                    let fieldIdx =
                        ent.FSharpFields
                        |> Seq.tryFindIndex (fun f -> f.Name = fieldName)
                        |> Option.defaultValue 0
                    WExpr.StructSet(wObj, fieldIdx, wVal)
                | None -> WExpr.Nop
            | _ -> WExpr.Nop
        // FSharpRef.set_Value → ExprSet(StringConst "contents")
        // Replacements.setRefCell uses setExpr which emits ExprSet(StringConst "contents")
        | ExprSet(Fable.Expr.Value(Fable.ValueKind.StringConstant "contents", _))
              when (match _expr.Type with
                    | Fable.Type.DeclaredType(e, _) -> e.FullName = FSharpRefFullName
                    | _ -> false) ->
            let wObj = transformExpr ctx _expr
            let wVal = transformExpr ctx value
            let innerWType = exprWType wVal
            let refTypeIdx = getOrAddRefCellType ctx innerWType
            WExpr.StructSet(wObj, 0, wVal)
        // F# array element assignment: arr.[i] <- v
        // ResizeArray element assignment: rav.[i] <- v → array.set on data field
        | ExprSet idxExpr
              when (match _expr.Type with | Fable.Type.Array _ -> true | _ -> false) ->
            let isResizeArr = match _expr.Type with | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) -> true | _ -> false
            if isResizeArr then
                let elemFableType = match _expr.Type with | Fable.Type.Array(t, _) -> t | _ -> Fable.Type.Any
                let elemT = mapTypeKnown ctx elemFableType
                let (arrTypeIdx, _) = getOrAddResizeArrayType ctx elemT
                let arrRefT = WType.Ref(arrTypeIdx, true)
                let wRav = transformExpr ctx _expr
                let wIdx = transformExpr ctx idxExpr
                let wVal = transformExpr ctx value
                WExpr.ArraySet(WExpr.Cast(WExpr.StructGet(wRav, 0, arrRefT), WType.Ref(arrTypeIdx, false)), wIdx, wVal)
            else
                let wArr = transformExpr ctx _expr
                let wIdx = transformExpr ctx idxExpr
                let wVal = transformExpr ctx value
                WExpr.ArraySet(wArr, wIdx, wVal)
        | _ -> WExpr.Nop // TODO: expr set

    // ── ResizeArray<T> — length and element access ────────────────────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, _, _)
          when (fi.Name = "Length" || fi.Name = "length" || fi.Name = "Count" || fi.Name = "count")
            && (match expr.Type with | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) -> true | _ -> false) ->
        // ResizeArray.Count / .Length → struct field 1 (len)
        let elemFableType = match expr.Type with | Fable.Type.Array(t, _) -> t | _ -> Fable.Type.Any
        let elemWT = mapTypeKnown ctx elemFableType
        let (_, ravTypeIdx) = getOrAddResizeArrayType ctx elemWT
        WExpr.StructGet(transformExpr ctx expr, 1, WType.I32)

    | Fable.Expr.Get(expr, GetKind.ExprGet idxExpr, typ, _)
          when (match expr.Type with | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) -> true | _ -> false) ->
        // ResizeArray.[i] → array.get on the struct's data field
        let elemFableType = match expr.Type with | Fable.Type.Array(t, _) -> t | _ -> Fable.Type.Any
        let elemWT = mapTypeKnown ctx elemFableType
        let (arrTypeIdx, ravTypeIdx) = getOrAddResizeArrayType ctx elemWT
        let arrRefT = WType.Ref(arrTypeIdx, true)
        WExpr.ArrayGet(WExpr.Cast(WExpr.StructGet(transformExpr ctx expr, 0, arrRefT),
                                  WType.Ref(arrTypeIdx, false)),
                       transformExpr ctx idxExpr, mapTypeKnown ctx typ)

    // ── Array length and indexing ──────────────────────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, _, _)
          when (fi.Name = "Length" || fi.Name = "length")
            && (match expr.Type with | Fable.Type.Array _ -> true | _ -> false) ->
        WExpr.ArrayLen(transformExpr ctx expr)

    | Fable.Expr.Get(expr, GetKind.ExprGet idxExpr, typ, _)
          when (match expr.Type with | Fable.Type.Array _ -> true | _ -> false) ->
        let wArr = transformExpr ctx expr
        let wIdx = transformExpr ctx idxExpr
        let elemT = mapTypeKnown ctx typ
        WExpr.ArrayGet(wArr, wIdx, elemT)

    // ── String operations (length, char indexing) ─────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, _, _)
          when expr.Type = Fable.Type.String && (fi.Name = "length" || fi.Name = "Length") ->
        WExpr.ArrayLen(transformExpr ctx expr)

    | Fable.Expr.Get(expr, GetKind.ExprGet idxExpr, _, _)
          when expr.Type = Fable.Type.String ->
        let wArr = transformExpr ctx expr
        let wIdx = transformExpr ctx idxExpr
        // array.get $WasmStr — returns i32 UTF-16 code unit
        WExpr.ArrayGet(wArr, wIdx, WType.I32)

    // ── FSharpRef.Value getter (get_Value → FieldGet "contents" on FSharpRef type) ─
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, typ, _)
          when fi.Name = "contents"
            && (match expr.Type with
                | Fable.Type.DeclaredType(e, _) -> e.FullName = FSharpRefFullName
                | _ -> false) ->
        let wObj = transformExpr ctx expr
        let innerWType = mapTypeKnown ctx typ
        let _refTypeIdx = getOrAddRefCellType ctx innerWType  // ensure registered
        WExpr.StructGet(wObj, 0, innerWType)

    // ── Record/struct field access (Phase 3) ────────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fieldInfo, typ, _) ->
        let wExpr = transformExpr ctx expr
        match expr.Type with
        | Fable.Type.DeclaredType(entRef, _) ->
            match Map.tryFind entRef.FullName ctx.TypeRegistry with
            | Some typeIdx ->
                let ent = ctx.Compiler.GetEntity(entRef)
                // For inherited types, parent fields come first in the struct layout
                let parentFieldCount =
                    match ent.BaseType with
                    | Some baseT when baseT.Entity.FullName <> "System.Object" ->
                        // Count parent's fields
                        let parentEnt = ctx.Compiler.GetEntity(baseT.Entity)
                        parentEnt.FSharpFields.Length
                    | _ -> 0
                let ownFieldIdx =
                    ent.FSharpFields
                    |> Seq.tryFindIndex (fun f -> f.Name = fieldInfo.Name)
                    |> Option.defaultValue 0
                let fieldIdx = parentFieldCount + ownFieldIdx
                // Cast if the object is typed as anyref/eqref (e.g., a catch variable) —
                // struct.get requires the concrete ref type on the stack.
                let targetRefTy = WType.Ref(typeIdx, false)
                let wSelf =
                    match exprWType wExpr with
                    | WType.Ref(idx, _) when idx = typeIdx -> wExpr
                    | _ -> WExpr.Cast(wExpr, targetRefTy)
                WExpr.StructGet(wSelf, fieldIdx, mapTypeKnown ctx typ)
            | None -> WExpr.Const(WConst.I32 0)
        | _ -> WExpr.Const(WConst.I32 0)

    | Fable.Expr.Get(expr, GetKind.TupleIndex i, typ, _) ->
        // Tuples are GC structs; field index matches tuple element index (0-based).
        let wObj = transformExpr ctx expr
        let fieldTy = mapTypeKnown ctx typ
        WExpr.StructGet(wObj, i, fieldTy)

    // ── DU field access (Phase 4) ─────────────────────────
    | Fable.Expr.Get(expr, GetKind.UnionField info, typ, _) ->
        let wObj = transformExpr ctx expr
        // Build the instance key: use genArgs if this is a generic DU (e.g., Result<T,E>)
        let instKey =
            if info.GenericArgs.IsEmpty then info.Entity.FullName
            else
                let argKeys = info.GenericArgs |> List.map (fun t -> wTypeKey (mapTypeKnown ctx t)) |> String.concat ","
                $"{info.Entity.FullName}<{argKeys}>"
        let caseKey = $"{instKey}#{info.CaseIndex}"
        // Check both GenericDuRegistry (for on-demand types) and TypeRegistry (for class-declared types).
        let caseTypeIdxOpt =
            match ctx.GenericDuRegistry.TryGetValue(caseKey) with
            | true, idx -> Some idx
            | false, _ -> Map.tryFind caseKey ctx.TypeRegistry
        match caseTypeIdxOpt with
        | Some caseTypeIdx ->
            // Cast from base ref to the concrete case subtype, then get the field.
            // Field 0 in the case struct is always the tag; data fields start at 1.
            let castedObj = WExpr.Cast(wObj, WType.Ref(caseTypeIdx, false))
            WExpr.StructGet(castedObj, info.FieldIndex + 1, mapTypeKnown ctx typ)
        | None ->
            WExpr.Const(WConst.I32 0)

    | Fable.Expr.Get(expr, GetKind.UnionTag, _, _) ->
        let wObj = transformExpr ctx expr
        WExpr.TagOf(wObj)

    | Fable.Expr.Get(expr, GetKind.OptionValue, typ, _) ->
        // Option<T>.Value: extract the inner value from a Some.
        // For non-null ref inners (direct-ref option): cast nullable → non-null inner ref.
        // For primitives / nullable-ref inners (wrapper struct): cast + StructGet field 0.
        let wObj = transformExpr ctx expr
        let innerType = mapTypeKnown ctx typ
        match innerType with
        | WType.Ref(innerIdx, false) ->
            // Direct-ref option: the option IS the inner ref, just cast to non-null.
            WExpr.Cast(wObj, WType.Ref(innerIdx, false))
        | _ ->
            // Wrapper-struct option: cast to non-null struct, then read field 0.
            match exprWType wObj with
            | WType.Ref(optTypeIdx, _) ->
                WExpr.StructGet(WExpr.Cast(wObj, WType.Ref(optTypeIdx, false)), 0, innerType)
            | _ -> wObj

    | Fable.Expr.Get(listExpr, GetKind.ListHead, typ, _) ->
        // xs.Head: cast (ref null $ListBase) → (ref $ListCons_T), then StructGet field 0 (head).
        let wList = transformExpr ctx listExpr
        let elemWType = mapTypeKnown ctx typ
        let elemKey = wTypeKey elemWType
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let castedList = WExpr.Cast(wList, WType.Ref(listConsIdx, false))
            WExpr.StructGet(castedList, 0, elemWType)
        | _ -> WExpr.Nop

    | Fable.Expr.Get(listExpr, GetKind.ListTail, _typ, _) ->
        // xs.Tail: cast (ref null $ListBase) → (ref $ListCons_T), StructGet field 1 → (ref null $ListBase).
        // No second cast needed — tail field type IS (ref null $ListBase).
        let wList = transformExpr ctx listExpr
        // Get element type from the INNER list expression's type
        let innerElemFableType =
            match listExpr.Type with
            | Fable.Type.List(t) -> t
            | _ -> Fable.Type.Any
        let innerElemWType = mapTypeKnown ctx innerElemFableType
        let elemKey = wTypeKey innerElemWType
        let listBaseRefT = WType.Ref(ListBaseTypeIdx, true)
        match ctx.ListRegistry.TryGetValue(elemKey) with
        | true, listConsIdx ->
            let castedList = WExpr.Cast(wList, WType.Ref(listConsIdx, false))
            WExpr.StructGet(castedList, 1, listBaseRefT)
        | _ -> WExpr.Nop

    | Fable.Expr.Test(expr, kind, _range) ->
        transformTest ctx expr kind

    // ── Decision tree (pattern matching) ──────────────────
    | Fable.Expr.DecisionTree(matchExpr, targets) ->
        transformDecisionTree ctx matchExpr targets

    | Fable.Expr.DecisionTreeSuccess(targetIdx, boundValues, typ) ->
        // This should be handled within transformDecisionTree
        let wArgs = boundValues |> List.map (transformExpr ctx)
        let ty = mapTypeKnown ctx typ
        WExpr.JoinApply($"$target_{!ctx.TargetBase + targetIdx}", wArgs, ty)

    // ── Type cast ─────────────────────────────────────────
    | Fable.Expr.TypeCast(expr, targetFableType) ->
        let wExpr = transformExpr ctx expr
        let srcTy  = exprWType wExpr
        // Use mapTypeKnown so DeclaredType → Ref(typeIdx) when registered (vs. mapType → I32).
        let dstTyKnown = mapTypeKnown ctx targetFableType
        let dstTy  = mapType targetFableType
        if srcTy = dstTyKnown then wExpr
        else
            match srcTy, dstTyKnown with
            // ── AnyRef → concrete struct ref: ref.cast (used in exception catch bindings) ─
            | WType.AnyRef, WType.Ref(typeIdx, _) ->
                WExpr.Cast(wExpr, WType.Ref(typeIdx, false))
            // ── Nullable ref → concrete non-null ref: ref.cast ─
            | WType.Ref(_, true), WType.Ref(typeIdx, false) ->
                WExpr.Cast(wExpr, WType.Ref(typeIdx, false))
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

    // ── CurriedApply (closure call) ───────────────────────
    // Special case: sprintf/printfn — Fable emits:
    //   CurriedApply(Call(Import("toText"|"toConsole"), [TypeCast(Call(Import("printf"), [StringConst fmt]))]), formatArgs)
    // We intercept this and expand the format string inline.
    | Fable.Expr.CurriedApply(callee, args, typ, _) ->
        let sprintfFmt =
            match callee with
            | Fable.Expr.Call(Fable.Expr.Import({Selector=sel}, _, _), outerInfo, _, _)
                when sel = "toText" || sel = "toConsole" ->
                match outerInfo.Args with
                | [Fable.Expr.TypeCast(innerExpr, _)] ->
                    match innerExpr with
                    | Fable.Expr.Call(Fable.Expr.Import({Selector="printf"}, _, _), innerInfo, _, _) ->
                        match innerInfo.Args with
                        | Fable.Expr.Value(Fable.ValueKind.StringConstant fmt, _) :: _ -> Some(sel, fmt)
                        | _ -> None
                    | _ -> None
                | _ -> None
            | _ -> None
        match sprintfFmt with
        | Some(sel, fmt) ->
            let strRef = WType.Ref(StringTypeIdx, false)
            let emitLit (s: string) =
                WExpr.ArrayNewFixed(StringTypeIdx,
                    s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList, strRef)
            let partsList, specsList = parseFormatString fmt
            let formatHole (spec: char) (ve: Fable.Expr) =
                let wv  = transformExpr ctx ve
                let wty = exprWType wv
                match spec with
                | 'f' | 'g' | 'e' ->
                    let wf64 = match wty with
                               | WType.F64 -> wv
                               | WType.F32 -> WExpr.Unary(WUnaryOp.PromoteF32, wv, WType.F64)
                               | _ -> WExpr.Unary(WUnaryOp.ConvertI32S, wv, WType.F64)
                    WExpr.Call(ctx.UseHelper("$floatToStr"), [wf64], strRef)
                | 'b' ->
                    WExpr.If(wv, emitLit "true", emitLit "false", strRef)
                | _ ->
                    match wty with
                    | WType.Ref(idx, _) when idx = StringTypeIdx -> wv
                    | WType.I64 ->
                        WExpr.Call(ctx.UseHelper("$intToStr"),
                            [WExpr.Unary(WUnaryOp.WrapI64, wv, WType.I32)], strRef)
                    | WType.F64 ->
                        WExpr.Call(ctx.UseHelper("$floatToStr"), [wv], strRef)
                    | WType.F32 ->
                        WExpr.Call(ctx.UseHelper("$floatToStr"),
                            [WExpr.Unary(WUnaryOp.PromoteF32, wv, WType.F64)], strRef)
                    | _ ->
                        WExpr.Call(ctx.UseHelper("$intToStr"), [wv], strRef)
            let nSpecs = List.length specsList
            let holeParts =
                [ for k in 0 .. nSpecs - 1 do
                    yield emitLit partsList.[k]
                    if k < args.Length then
                        yield formatHole specsList.[k] args.[k] ]
            let lastPart = if List.isEmpty partsList then "" else List.last partsList
            let segments = holeParts @ [emitLit lastPart]
            let formattedStr =
                match segments with
                | [] -> emitLit ""
                | [single] -> single
                | head :: tail ->
                    tail |> List.fold (fun acc s ->
                        WExpr.Call(ctx.UseHelper("$strConcat"), [acc; s], strRef)) head
            if sel = "toConsole" then
                WExpr.Sequence([
                    WExpr.Call("consolePrint", [formattedStr], WType.Void)
                    WExpr.Nop
                ])
            else
                formattedStr
        | None ->
        let ty = mapTypeKnown ctx typ
        let wClosure = transformExpr ctx callee
        // Guard: if callee compiled to Nop (unimplemented import), skip the whole apply
        if wClosure = WExpr.Nop then WExpr.Nop else

        // Transform ALL args first to preserve evaluation order / side-effects.
        // Then filter void-typed results: they produce no stack value.
        // funcTypeIdx and wArgs must agree on count — both drop voids.
        let wArgsAll = args |> List.map (transformExpr ctx)

        // Pair each wArg with its Fable type.
        let wArgPairs = List.zip wArgsAll args

        // For the functype, we need to know the expected call signature.
        // First pass: collect the non-void arg types to register the functype.
        let wArgsFull =
            wArgPairs |> List.map (fun (wArg, fArg) ->
                match exprWType wArg with
                | WType.Void ->
                    // Unit arg at a JS-bridge call site: the JS side sends an i32.
                    // Preserve as i32Const 0 so the stack count matches.
                    // For pure F# closures this is dead code (the body ignores it).
                    WExpr.Const(WConst.I32 0)
                | _ -> wArg)

        let wArgs    = wArgsAll |> List.filter (fun a -> exprWType a <> WType.Void)
        // Self-parameter convention (Sprint 25b):
        // funcTypeIdx = (ref $AnyFn, arg1..., argN) → retType
        // All closures with the same apply signature share this functype.
        let selfType    = WType.Ref(AnyFnTypeIdx, false)
        // let argTypes = args |> List.map (fun a -> mapTypeKnown ctx a.Type) |> List.filter (fun t -> t <> WType.Void)
        let argTypes    = wArgs |> List.map exprWType   // already non-void
        let funcTypeIdx = ctx.GetOrAddFuncType(selfType :: argTypes, ty)

        let closureTypeIdx =
            match ctx.FuncTypeToClosureMap.TryGetValue(funcTypeIdx) with
            | true, cti -> cti
            | false, _ -> AnyFnTypeIdx
        WExpr.ClosureApply(wClosure, wArgs, funcTypeIdx, closureTypeIdx, 0, ty)

    // ── Lambda ────────────────────────────────────────────
    | Fable.Expr.Lambda(arg, body, name) ->
        buildClosure ctx transformExpr [arg] body name

    | Fable.Expr.Delegate(args, body, name, _tags) ->
        buildClosure ctx transformExpr args body name

    // ── Try/Catch ─────────────────────────────────────────
    | Fable.Expr.TryCatch(body, catch, finalizer, _range) ->
        let wBody = transformExpr ctx body
        let wCatch = catch |> Option.map (fun (ident, expr) ->
            // Type the catch ident as anyref so TypeTest (ref.test) works against typed exceptions.
            // The ident value is loaded from $fsharp_exn_carrier at the start of the handler.
            let ctxWithIdent = ctx.WithLocal(ident.Name, WType.AnyRef)
            let wHandlerExpr = transformExpr ctxWithIdent expr
            let wHandlerWithCarrier =
                WExpr.Let(ident.Name, WExpr.GlobalGet("$fsharp_exn_carrier", WType.AnyRef), wHandlerExpr)
            ident.Name, wHandlerWithCarrier)
        let wFinally = finalizer |> Option.map (transformExpr ctx)
        let ty = mapType body.Type
        WExpr.TryCatch(wBody, wCatch, wFinally, ty)

    // ── Extended expressions ──────────────────────────────
    | Fable.Expr.Extended(kind, _range) ->
        match kind with
        | Fable.ExtendedSet.Throw(Some expr, _) ->
            let wExpr = transformExpr ctx expr
            WExpr.Throw(wExpr)
        | _ -> WExpr.Nop

    // ── ObjectExpr: IComparer-like interface objects ───────
    // Fable emits makeComparer as ObjectExpr { Compare = fun x y -> compare x y }.
    // We extract the Compare (or Equals/GetHashCode) member body and translate it.
    // For IComparer, the body is a Delegate — buildClosure handles it and returns
    // a (ref $AnyFn) closure that can be stored as MapHandle/SetHandle.Cmp.
    | Fable.Expr.ObjectExpr(members, _, _) ->
        // Prefer "Compare" for IComparer, fall back to first member for other objects
        let target =
            members |> List.tryFind (fun m -> m.Name = "Compare")
            |> Option.orElse (List.tryHead members)
        match target with
        | Some m -> transformExpr ctx m.Body
        | None -> WExpr.Nop

    // ── Catch-all ─────────────────────────────────────────
    | _ ->
        WExpr.Nop // TODO: emit warning for unhandled expression

and transformValue (ctx: Ctx) (kind: ValueKind) : WExpr =
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
            let wh = transformExpr ctx h
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
    | NumberConstant(value, _info) ->
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
        | _ -> WExpr.Const(WConst.I32 0) // fallback
    | Null _ -> WExpr.Const(WConst.Null(WType.I32))
    // ── Records (Phase 3) ────────────────────────────────
    | NewRecord(values, entRef, _) ->
        match Map.tryFind entRef.FullName ctx.TypeRegistry with
        | Some typeIdx ->
            let wValues = values |> List.map (transformExpr ctx)
            WExpr.StructNew(typeIdx, wValues, WType.Ref(typeIdx, false))
        | None ->
            // Record type not registered yet — emit stub
            WExpr.Const(WConst.I32 0)
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
                let wFields = values |> List.map (transformExpr ctx)
                WExpr.StructNew(caseTypeIdx, wTag :: wFields, WType.Ref(baseIdx, false))
            | None ->
                // Still not found (shouldn't happen after registration) — fall back
                eprintfn "[WasmGc] WARNING: DU case '%s' not found after registration" caseKey
                WExpr.Const(WConst.I32 tag)
    // ── Tuples (Phase 5-ish) ────────────────────────────────
    | NewTuple(values, _isStruct) ->
        // Determine/register the struct type for this tuple shape.
        let wValues = values |> List.map (transformExpr ctx)
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
            | Some expr -> transformExpr ctx expr   // Some(v) = v itself (non-null ref)
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
                let wV = transformExpr ctx expr
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
            [WExpr.ArrayNew(arrTypeIdx, WExpr.Const(WConst.I32 4), zero, WType.Ref(arrTypeIdx, false))
             WExpr.Const(WConst.I32 0)],
            WType.Ref(ravTypeIdx, false))
    | NewArray(Fable.NewArrayKind.ArrayValues exprs, elemType, _) ->
        let elemT = mapTypeKnown ctx elemType
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let wVals = exprs |> List.map (transformExpr ctx)
        WExpr.ArrayNewFixed(arrTypeIdx, wVals, WType.Ref(arrTypeIdx, false))
    | NewArray(Fable.NewArrayKind.ArrayAlloc sizeExpr, elemType, _) ->
        let elemT = mapTypeKnown ctx elemType
        let arrTypeIdx = getOrAddArrayType ctx elemT
        let wSize = transformExpr ctx sizeExpr
        let zero =
            match elemT with
            | WType.I64 -> WExpr.Const(WConst.I64 0L)
            | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
            | WType.F64 -> WExpr.Const(WConst.F64 0.0)
            | _ -> WExpr.Const(WConst.I32 0)
        WExpr.ArrayNew(arrTypeIdx, wSize, zero, WType.Ref(arrTypeIdx, false))
    | NewArray(Fable.NewArrayKind.ArrayFrom srcExpr, elemType, _) ->
        // ArrayFrom: copy from another array/seq. Treat as identity for now (same wasm array ref).
        transformExpr ctx srcExpr
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
            let wHead = transformExpr ctx headExpr
            let wTail = transformExpr ctx tailExpr
            match ctx.ListRegistry.TryGetValue(elemKey) with
            | true, listConsIdx ->
                WExpr.StructNew(listConsIdx, [wHead; wTail], listBaseRefT)
            | _ -> WExpr.Nop
    | _ -> WExpr.Nop // TODO: other values

// ─────────────────────────────────────────────────────────────────
// Operation translation
// ─────────────────────────────────────────────────────────────────

and transformOperation (ctx: Ctx) (kind: OperationKind) (typ: Fable.Type) : WExpr =
    let ty = mapTypeKnown ctx typ
    match kind with
    | Unary(op, operand) ->
        let wOperand = transformExpr ctx operand
        match op with
        | UnaryMinus ->
            WExpr.Unary(WUnaryOp.Neg, wOperand, ty)
        | UnaryNot ->
            WExpr.Unary(WUnaryOp.Eqz, wOperand, ty)
        | UnaryNotBitwise ->
            // JS bitwise NOT silently truncates floats to int (~~x = Math.trunc(x) for floats).
            // In WASM we must truncate explicitly before applying integer NOT.
            let wOperand' =
                match exprWType wOperand with
                | WType.F64 -> WExpr.Unary(WUnaryOp.TruncF64S, wOperand, WType.I32)
                | WType.F32 -> WExpr.Unary(WUnaryOp.TruncF32S, wOperand, WType.I32)
                | _ -> wOperand
            WExpr.Unary(WUnaryOp.Not, wOperand', ty)
        | _ ->
            WExpr.Unary(WUnaryOp.Neg, wOperand, ty) // fallback

    | Binary(op, left, right) ->
        // String operations route to runtime helpers (array i32 has no native == or +)
        if left.Type = Fable.Type.String || right.Type = Fable.Type.String then
            let wLeft = transformExpr ctx left
            let wRight = transformExpr ctx right
            let strRef = WType.Ref(StringTypeIdx, false)
            match op with
            | BinaryPlus -> WExpr.Call(ctx.UseHelper("$strConcat"), [wLeft; wRight], strRef)
            | BinaryEqual -> WExpr.Call(ctx.UseHelper("$strEq"), [wLeft; wRight], WType.I32)
            | BinaryUnequal ->
                WExpr.Unary(WUnaryOp.Eqz, WExpr.Call(ctx.UseHelper("$strEq"), [wLeft; wRight], WType.I32), WType.I32)
            | _ -> WExpr.Nop // other string ops unsupported
        // ── Structural equality for records, data-carrying DUs, and tuples ──
        elif (op = BinaryEqual || op = BinaryUnequal) &&
             (match left.Type with
              | Fable.Type.Tuple _ -> true
              | Fable.Type.DeclaredType(entRef, _) -> Map.containsKey entRef.FullName ctx.TypeRegistry
              | _ -> false) then
            // Ensure the wasm type is registered (mapTypeKnown may create a fresh TupleRegistry entry)
            let wLeft = transformExpr ctx left
            let wRight = transformExpr ctx right
            let typeIdx =
                match exprWType wLeft with
                | WType.Ref(idx, _) -> idx
                | _ -> -1
            if typeIdx < 0 then
                WExpr.Compare(WCompareOp.Eq, wLeft, wRight)  // fallback: ref eq
            else
                // Ensure strEq is emitted (compareByWType may delegate some fields to it)
                ctx.UseHelper("$strEq") |> ignore
                match getOrAddStructuralEquals ctx typeIdx with
                | Some funcName ->
                    let call = WExpr.Call(funcName, [wLeft; wRight], WType.I32)
                    if op = BinaryUnequal then WExpr.Unary(WUnaryOp.Eqz, call, WType.I32)
                    else call
                | None ->
                    WExpr.Compare(WCompareOp.Eq, wLeft, wRight)  // fallback
        else
        let wLeft = transformExpr ctx left
        let wRight = transformExpr ctx right
        match op with
        // Comparisons → WExpr.Compare
        | BinaryEqual ->
            WExpr.Compare(WCompareOp.Eq, wLeft, wRight)
        | BinaryUnequal ->
            WExpr.Compare(WCompareOp.Ne, wLeft, wRight)
        | BinaryLess ->
            WExpr.Compare(WCompareOp.LtS, wLeft, wRight)
        | BinaryLessOrEqual ->
            WExpr.Compare(WCompareOp.LeS, wLeft, wRight)
        | BinaryGreater ->
            WExpr.Compare(WCompareOp.GtS, wLeft, wRight)
        | BinaryGreaterOrEqual ->
            WExpr.Compare(WCompareOp.GeS, wLeft, wRight)
        // Arithmetic → WExpr.Binary
        | BinaryPlus ->
            WExpr.Binary(WBinaryOp.Add, wLeft, wRight, ty)
        | BinaryMinus ->
            WExpr.Binary(WBinaryOp.Sub, wLeft, wRight, ty)
        | BinaryMultiply ->
            WExpr.Binary(WBinaryOp.Mul, wLeft, wRight, ty)
        | BinaryDivide ->
            WExpr.Binary(WBinaryOp.DivS, wLeft, wRight, ty)
        | BinaryModulus ->
            WExpr.Binary(WBinaryOp.RemS, wLeft, wRight, ty)
        | BinaryShiftLeft ->
            WExpr.Binary(WBinaryOp.Shl, wLeft, wRight, ty)
        | BinaryShiftRightSignPropagating ->
            WExpr.Binary(WBinaryOp.ShrS, wLeft, wRight, ty)
        | BinaryShiftRightZeroFill ->
            WExpr.Binary(WBinaryOp.ShrU, wLeft, wRight, ty)
        | BinaryOrBitwise ->
            WExpr.Binary(WBinaryOp.Or, wLeft, wRight, ty)
        | BinaryXorBitwise ->
            WExpr.Binary(WBinaryOp.Xor, wLeft, wRight, ty)
        | BinaryAndBitwise ->
            WExpr.Binary(WBinaryOp.And, wLeft, wRight, ty)
        | BinaryExponent ->
            // No native WASM exponent: route to $pown (i32) or $powF64 (f64).
            match ty with
            | WType.I32 -> WExpr.Call(ctx.UseHelper("$pown"),   [wLeft; wRight], WType.I32)
            | _         -> WExpr.Call(ctx.UseHelper("$powF64"), [wLeft; wRight], WType.F64)

    | Logical(op, left, right) ->
        let wLeft = transformExpr ctx left
        let wRight = transformExpr ctx right
        match op with
        | LogicalAnd ->
            // short-circuit: if left then right else false
            WExpr.If(wLeft, wRight, WExpr.Const(WConst.I32 0), WType.I32)
        | LogicalOr ->
            // short-circuit: if left then true else right
            WExpr.If(wLeft, WExpr.Const(WConst.I32 1), wRight, WType.I32)

// ─────────────────────────────────────────────────────────────────
// Call translation
// ─────────────────────────────────────────────────────────────────

and transformTest (ctx: Ctx) (expr: Fable.Expr) (kind: TestKind) : WExpr =
    let wExpr = transformExpr ctx expr
    match kind with
    | UnionCaseTest tag ->
        match exprWType wExpr with
        | WType.Ref(_, _) ->
            // Data-carrying DU: compare the stored tag field (field 0) against the expected tag.
            // NOTE: ref.test cannot be used here because WASM GC uses isorecursive type
            // equivalence — two subtypes with identical field structures (e.g. Result<int,int>
            // where both Ok(int) and Error(int) produce the same struct layout) are considered
            // the same type, so ref.test would incorrectly return 1 for the wrong case.
            WExpr.Compare(WCompareOp.Eq, WExpr.TagOf(wExpr), WExpr.Const(WConst.I32 tag))
        | _ ->
            // Enum-like DU: the i32 value IS the tag.
            WExpr.Compare(WCompareOp.Eq, wExpr, WExpr.Const(WConst.I32 tag))
    | OptionTest isSome ->
        // Use ref.is_null when the option is encoded as a nullable GC ref,
        // fall back to i32 == 0 / != 0 for the unresolved (mapType) fallback.
        match exprWType wExpr with
        | WType.Ref(_, _) ->
            if isSome then
                // Some → not null: i32.eqz(ref.is_null(...))
                refIsNotNull wExpr
            else
                // None → null: ref.is_null(...) → i32
                WExpr.RefIsNull(wExpr)
        | _ ->
            if isSome then
                WExpr.Compare(WCompareOp.Ne, wExpr, WExpr.Const(WConst.I32 0))
            else
                WExpr.Compare(WCompareOp.Eq, wExpr, WExpr.Const(WConst.I32 0))
    | ListTest isCons ->
        // Use ref.is_null for GC-encoded lists (null = empty, non-null = cons).
        // Fall back to i32 comparison if the list is i32-encoded (shouldn't happen now).
        match exprWType wExpr with
        | WType.Ref(_, _) ->
            if isCons then
                refIsNotNull wExpr
            else
                WExpr.RefIsNull(wExpr)
        | _ ->
            if isCons then
                WExpr.Compare(WCompareOp.Ne, wExpr, WExpr.Const(WConst.I32 0))
            else
                WExpr.Compare(WCompareOp.Eq, wExpr, WExpr.Const(WConst.I32 0))
    | TypeTest typ ->
        // Runtime type test: ref.test (ref $TypeIdx) against the typed exception/object.
        // Used for `:? SomeType` and `with :? SomeException as e` patterns.
        match typ with
        | Fable.Type.DeclaredType(entRef, _) ->
            match Map.tryFind entRef.FullName ctx.TypeRegistry with
            | Some typeIdx ->
                WExpr.RefTest(wExpr, WType.Ref(typeIdx, false))
            | None ->
                // Type not (yet) registered — check GenericDuRegistry too
                match ctx.GenericDuRegistry.TryGetValue(entRef.FullName) with
                | true, typeIdx -> WExpr.RefTest(wExpr, WType.Ref(typeIdx, false))
                | false, _ -> WExpr.Const(WConst.I32 0)  // unknown type: test fails
        | _ ->
            // Primitive / other types can't be runtime-tested via ref.test
            WExpr.Const(WConst.I32 0)

// ─────────────────────────────────────────────────────────────────
// Decision tree translation (pattern matching)
// ─────────────────────────────────────────────────────────────────

and transformDecisionTree (ctx: Ctx) (matchExpr: Fable.Expr) (targets: (Ident list * Fable.Expr) list) : WExpr =
    let resultType = mapTypeKnown ctx matchExpr.Type
    // Assign globally-unique IDs to these targets (avoids label collisions in nested matches).
    let baseId = !ctx.DecisionTreeCounter
    ctx.DecisionTreeCounter := baseId + targets.Length
    // Create join points for each target
    let wTargets =
        targets
        |> List.mapi (fun i (idents, body) ->
            let parms = idents |> List.map (fun id -> id.Name, mapTypeKnown ctx id.Type)
            let ctx' = (ctx, idents) ||> List.fold (fun c id -> c.WithLocal(id.Name, mapTypeKnown ctx id.Type))
            let wBody = transformExpr ctx' body
            $"$target_{baseId + i}", parms, wBody
        )
    // Before translating matchExpr, publish the current base so that
    // DecisionTreeSuccess nodes (which reference 0-based local indices)
    // produce globally-unique labels ($target_{baseId + localIdx}).
    let savedBase = !ctx.TargetBase
    ctx.TargetBase := baseId
    let wMatch = transformExpr ctx matchExpr
    ctx.TargetBase := savedBase
    // Wrap in join points
    (wMatch, List.rev wTargets)
    ||> List.fold (fun cont (label, parms, body) ->
        WExpr.JoinPoint(label, parms, body, cont, resultType)
    )

// ─────────────────────────────────────────────────────────────────
// Declaration translation
// ─────────────────────────────────────────────────────────────────

/// Transform a single Fable member declaration into a WasmIR function
and transformMemberDecl (ctx: Ctx) (decl: MemberDecl) : WFuncDecl =
    // Filter out unit parameters — WASM has no void param type.
    // Use mapTypeKnown to resolve record/DU params to GC struct refs.
    let params' =
        decl.Args
        |> List.choose (fun a ->
            let ty = mapTypeKnown ctx a.Type
            if ty = WType.Void then None
            else Some(a.Name, ty))
    let ctx' =
        (ctx, decl.Args)
        ||> List.fold (fun c a -> c.WithLocal(a.Name, mapTypeKnown ctx a.Type))
    let ctx' = { ctx' with CurrentFunc = Some decl.Name }
    let wBody = transformExpr ctx' decl.Body
    // Compute resultType AFTER body translation — the body may register DU types on-demand
    // (e.g. NewUnion for Result<T,E>) that must be visible for mapResultTypeKnown to return
    // the correct Ref type rather than the i32 fallback.
    let resultType = mapResultTypeKnown ctx decl.Body.Type

    // Tail call optimization: rewrite Call(f, args, t) in tail position to TailCall.
    // return_call reuses the current stack frame — critical for mutual recursion and
    // any deep call chain that Fable didn't already convert to a loop.
    // Only applies to non-void functions (void functions use return with no value).
    let rec markTailCalls (expr: WExpr) : WExpr =
        match expr with
        | WExpr.Call(f, args, t) when t = resultType && not (f.StartsWith("$")) ->
            WExpr.TailCall(f, args, t)
        | WExpr.Let(name, value, body) -> WExpr.Let(name, value, markTailCalls body)
        | WExpr.LetMut(name, value, body) -> WExpr.LetMut(name, value, markTailCalls body)
        | WExpr.If(cond, then_, else_, t) ->
            WExpr.If(cond, markTailCalls then_, markTailCalls else_, t)
        | WExpr.Sequence exprs when exprs.Length > 0 ->
            let init = exprs |> List.take (exprs.Length - 1)
            WExpr.Sequence(init @ [markTailCalls (List.last exprs)])
        | WExpr.JoinPoint(lbl, parms, body, cont, t) ->
            WExpr.JoinPoint(lbl, parms, body, markTailCalls cont, t)
        | _ -> expr
    let wBody =
        if resultType <> WType.Void
        then markTailCalls wBody
        else wBody
    {
        Name = decl.Name
        Params = params'
        Result = resultType
        Locals = [] // filled in later by local collection pass
        Body = wBody
        Exported = true // export all top-level functions for now
    }

/// Pre-scan all declarations and register MemberDecl bodies in ctx.GenericFuncRegistry.
/// Enables demand-driven specialization in trySpecializeCall without a two-pass pipeline.
let preScanGenerics (ctx: Ctx) (decls: Declaration list) : unit =
    let rec scan decl =
        match decl with
        | MemberDeclaration m ->
            ctx.GenericFuncRegistry.[m.Name] <- (ctx.Compiler, m :> obj)
        | ModuleDeclaration md ->
            md.Members |> List.iter scan
        | ClassDeclaration cd ->
            cd.AttachedMembers |> List.iter (fun m ->
                ctx.GenericFuncRegistry.[m.Name] <- (ctx.Compiler, m :> obj))
        | ActionDeclaration _ -> ()
    decls |> List.iter scan

// ─────────────────────────────────────────────────────────────────
// Declaration processing — top-level so it can be shared across files
// ─────────────────────────────────────────────────────────────────

/// Process one Fable declaration into the shared ctx (mutates ctx.TypeDefs/Functions).
/// Returns the updated immutable record (KnownFuncs accumulates across declarations).
let rec processDecl (ctx: Ctx) (decl: Declaration) : Ctx =
    match decl with
    | MemberDeclaration memberDecl ->
        let func = transformMemberDecl ctx memberDecl |> resolveLocals
        let shortName = func.Name
        // In library context, use module-qualified name (e.g. MapModule_add).
        // FuncNameAlias was pre-populated in ModuleDeclaration so recursive calls resolve correctly.
        let qualifiedName = ctx.FuncNameAlias |> Map.tryFind shortName |> Option.defaultValue shortName
        let isLibFunc = qualifiedName <> shortName
        let func = { func with
                        Name = qualifiedName
                        // Library functions are internal — only last-file functions are exported.
                        Exported = if isLibFunc then false else func.Exported }
        ctx.Functions.Add(func)
        let paramTypes = func.Params |> List.map snd
        let kf = ctx.KnownFuncs |> Map.add qualifiedName (paramTypes, func.Result)
        // Register for cross-file import dispatch: (fileStem, shortSelector) → qualifiedName
        // Also register (fileStem, qualifiedName) → qualifiedName to handle cases where Fable
        // uses the fully-qualified name as the import selector (e.g. class constructors:
        // "ArgumentException_$ctor_Z384F8060" rather than "$ctor_Z384F8060").
        let kfByPath =
            if isLibFunc then
                ctx.KnownFuncsByPath
                |> Map.add (ctx.CurrentFileStem, shortName) qualifiedName
                |> Map.add (ctx.CurrentFileStem, qualifiedName) qualifiedName
            else
                ctx.KnownFuncsByPath
        { ctx with KnownFuncs = kf; KnownFuncsByPath = kfByPath }
    | ActionDeclaration action ->
        let wBody = transformExpr ctx action.Body
        let func : WFuncDecl =
            { Name = "$init"; Params = []; Result = WType.Void; Locals = []; Body = wBody; Exported = false }
        ctx.Functions.Add(func |> resolveLocals)
        ctx
    | ModuleDeclaration modDecl ->
        // Recurse into nested module declarations (library pre-scan is done in processFileIntoCtx).
        (ctx, modDecl.Members) ||> List.fold processDecl
    | ClassDeclaration classDecl ->
        let ent = ctx.Compiler.GetEntity(classDecl.Entity)
        if ent.IsFSharpRecord then
            let typeIdx = ctx.TypeDefs.Count
            let ctx' = ctx.WithTypeEntry(classDecl.Entity.FullName, typeIdx)
            let fields =
                ent.FSharpFields
                |> List.map (fun f ->
                    { Name = f.Name; Type = mapTypeKnown ctx' f.FieldType; Mutable = f.IsMutable })
            ctx.TypeDefs.Add({ Name = classDecl.Entity.FullName; Def = WTypeDef.Struct(fields, None) })
            let ctx'' =
                (ctx', classDecl.AttachedMembers)
                ||> List.fold (fun c m ->
                    let func = transformMemberDecl c m |> resolveLocals
                    // Interface implementations are internals — accessed via vtable wrappers.
                    // Qualify the name with the declaring type to avoid duplicate Wasm function
                    // names when multiple types implement the same interface method name.
                    let func =
                        if m.ImplementedSignatureRef.IsSome then
                            let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                            { func with Name = qualName; Exported = false }
                        else func
                    c.Functions.Add(func); c)
            // ── Vtable wiring for interface implementations ──────────────
            // Find all members that implement an interface method.
            let ifaceImpls =
                classDecl.AttachedMembers
                |> List.choose (fun m ->
                    match m.ImplementedSignatureRef with
                    | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)) ->
                        // The compiled function was qualified: TypeFullName_MethodName
                        let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                        match ctx''.Functions |> Seq.tryFindBack (fun f -> f.Name = qualName) with
                        | Some func ->
                            Some(ifaceEntityRef.FullName, ifaceMemberInfo.CompiledName,
                                 qualName, func.Params |> List.map snd, func.Result)
                        | None -> None
                    | _ -> None)
            // Group by interface full name.
            let byIface = ifaceImpls |> List.groupBy (fun (ifaceName, _, _, _, _) -> ifaceName)
            for (ifaceName, methods) in byIface do
                // Collect method signatures for interface registration.
                // We need the non-self param types: skip the first param (concrete self).
                let methodSigs =
                    methods |> List.map (fun (_, methodName, _, compiledParams, retType) ->
                        let nonSelfParams = match compiledParams with _ :: rest -> rest | [] -> []
                        methodName, nonSelfParams, retType)
                let vtableTypeIdx, boxTypeIdx = VT.getOrRegisterInterface ctx'' ifaceName methodSigs
                let _, _, funcTypeIndices, _ = ctx''.VTableRegistry.[ifaceName]
                let methodImpls =
                    methods |> List.map (fun (_, methodName, compiledFunc, compiledParams, retType) ->
                        methodName, compiledFunc, compiledParams, retType)
                VT.registerVTableImpl ctx'' classDecl.Entity.FullName typeIdx
                    ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodImpls
            ctx''
        elif ent.IsFSharpUnion then
            let cases = ent.UnionCases
            let isEnumLike = cases |> List.forall (fun c -> c.UnionCaseFields.IsEmpty)
            if isEnumLike then ctx
            else
                let baseIdx = ctx.TypeDefs.Count
                let ctx' = ctx.WithTypeEntry(classDecl.Entity.FullName, baseIdx)
                let ctx'' =
                    [ 0 .. cases.Length - 1 ]
                    |> List.fold (fun (c: Ctx) i ->
                        c.WithTypeEntry($"{classDecl.Entity.FullName}#{i}", baseIdx + 1 + i)) ctx'
                ctx.TypeDefs.Add(
                    { Name = classDecl.Entity.FullName
                      Def = WTypeDef.Struct([{ Name = "tag"; Type = WType.I32; Mutable = false }], None) })
                cases |> List.iteri (fun i case ->
                    let dataFields =
                        case.UnionCaseFields
                        |> List.map (fun f ->
                            { Name = f.Name; Type = mapTypeKnown ctx'' f.FieldType; Mutable = false })
                        |> List.filter (fun f -> f.Type <> WType.Void)
                    ctx.TypeDefs.Add(
                        { Name = $"{classDecl.Entity.FullName}#{i}"
                          Def = WTypeDef.Struct(
                                { Name = "tag"; Type = WType.I32; Mutable = false } :: dataFields,
                                Some baseIdx) }))
                (ctx'', classDecl.AttachedMembers)
                ||> List.fold (fun c m ->
                    let func = transformMemberDecl c m |> resolveLocals
                    let func =
                        if m.ImplementedSignatureRef.IsSome then
                            let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                            { func with Name = qualName; Exported = false }
                        else func
                    c.Functions.Add(func); c)
                |> (fun ctx3 ->
                    // ── Vtable wiring for DU interface implementations ──────────
                    let ifaceImpls =
                        classDecl.AttachedMembers
                        |> List.choose (fun m ->
                            match m.ImplementedSignatureRef with
                            | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)) ->
                                let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                                match ctx3.Functions |> Seq.tryFindBack (fun f -> f.Name = qualName) with
                                | Some func ->
                                    Some(ifaceEntityRef.FullName, ifaceMemberInfo.CompiledName,
                                         qualName, func.Params |> List.map snd, func.Result)
                                | None -> None
                            | _ -> None)
                    let byIface = ifaceImpls |> List.groupBy (fun (ifaceName, _, _, _, _) -> ifaceName)
                    for (ifaceName, methods) in byIface do
                        let methodSigs =
                            methods |> List.map (fun (_, methodName, _, compiledParams, retType) ->
                                let nonSelfParams = match compiledParams with _ :: rest -> rest | [] -> []
                                methodName, nonSelfParams, retType)
                        let vtableTypeIdx, boxTypeIdx = VT.getOrRegisterInterface ctx3 ifaceName methodSigs
                        let _, _, funcTypeIndices, _ = ctx3.VTableRegistry.[ifaceName]
                        let methodImpls =
                            methods |> List.map (fun (_, methodName, compiledFunc, compiledParams, retType) ->
                                methodName, compiledFunc, compiledParams, retType)
                        VT.registerVTableImpl ctx3 classDecl.Entity.FullName baseIdx
                            ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodImpls
                    ctx3)
        else
            // Regular class, abstract class, or interface declaration.
            // Interface declarations have no fields or implementations to emit.
            if ent.IsInterface then ctx
            else
                // ── Resolve parent type for struct subtyping ─────────────────────────────
                // WasmGC requires ALL fields (including inherited) to be declared in the
                // subtype, with the parent's fields appearing first (prefix layout).
                let typeIdx = ctx.TypeDefs.Count
                let ctx' = ctx.WithTypeEntry(classDecl.Entity.FullName, typeIdx)

                // Look up parent struct (skip System.Object / System.Exception from BCL)
                let parentStructInfo =
                    match ent.BaseType with
                    | Some baseT ->
                        let parentName = baseT.Entity.FullName
                        // Use ctx (NOT ctx') so we don't find our own self-registered index
                        // which was added to ctx' before TypeDefs.Add has run.
                        match Map.tryFind parentName ctx.TypeRegistry with
                        | Some parentIdx when parentIdx < ctx.TypeDefs.Count ->
                            match ctx.TypeDefs.[parentIdx].Def with
                            | WTypeDef.Struct(parentFields, _) -> Some(parentIdx, parentFields)
                            | _ -> None
                        | _ -> None
                    | None -> None

                // Child's own fields declared in this class body
                let ownFields =
                    ent.FSharpFields
                    |> List.map (fun f ->
                        { Name = f.Name; Type = mapTypeKnown ctx' f.FieldType; Mutable = f.IsMutable })

                // Flattened layout: parent prefix fields + own new fields
                let allFields, superTypeOpt =
                    match parentStructInfo with
                    | Some(parentIdx, parentFields) -> parentFields @ ownFields, Some parentIdx
                    | None -> ownFields, None

                ctx.TypeDefs.Add({ Name = classDecl.Entity.FullName; Def = WTypeDef.Struct(allFields, superTypeOpt) })
                // ── Synthesize constructor: takes field values, returns struct.new ──
                // Fable's constructor body is OOP/JS-style (field sets); we replace
                // it with a direct struct.new that matches the struct field layout.
                let ctx'' =
                    match classDecl.Constructor with
                    | None -> ctx'
                    | Some ctorDecl ->
                        let ctorParams =
                            ctorDecl.Args
                            |> List.choose (fun a ->
                                let ty = mapTypeKnown ctx' a.Type
                                if ty = WType.Void then None else Some(a.Name, ty))
                        let retTy = WType.Ref(typeIdx, false)
                        // Build struct.new: map each allFields field to a ctor arg (by name),
                        // falling back to a zero/null constant for fields not in ctor args.
                        let fieldGetters =
                            allFields |> List.map (fun fd ->
                                match ctorParams |> List.tryFind (fun (n, _) -> n = fd.Name) with
                                | Some(name, ty) -> WExpr.LocalGet(name, ty)
                                | None ->
                                    // Default: zero for value types, null for ref types
                                    match fd.Type with
                                    | WType.Ref(_, _) -> WExpr.Const(WConst.Null fd.Type)
                                    | WType.AnyRef     -> WExpr.Const(WConst.Null WType.AnyRef)
                                    | _                -> WExpr.Const(WConst.I32 0))
                        let ctorBody = WExpr.StructNew(typeIdx, fieldGetters, retTy)
                        let ctorFunc : WFuncDecl =
                            { Name = ctorDecl.Name; Params = ctorParams; Result = retTy
                              Locals = []; Body = ctorBody; Exported = false }
                        ctx'.Functions.Add(ctorFunc)
                        // Register synthesized constructor for cross-file import dispatch.
                        // Fable uses the full qualified name (e.g. "ArgumentException_$ctor_Z...") as
                        // the import selector when calling from a different file.
                        let kf = ctx'.KnownFuncs |> Map.add ctorFunc.Name (List.map snd ctorParams, retTy)
                        let kfByPath = ctx'.KnownFuncsByPath |> Map.add (ctx'.CurrentFileStem, ctorFunc.Name) ctorFunc.Name
                        { ctx' with KnownFuncs = kf; KnownFuncsByPath = kfByPath }
                let ctx'' =
                    (ctx'', classDecl.AttachedMembers)
                    ||> List.fold (fun c m ->
                        let func = transformMemberDecl c m |> resolveLocals
                        let func =
                            if m.ImplementedSignatureRef.IsSome then
                                let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                                { func with Name = qualName; Exported = false }
                            else func
                        c.Functions.Add(func); c)
                // ── Vtable wiring for interface implementations ──────────────
                let ifaceImpls =
                    classDecl.AttachedMembers
                    |> List.choose (fun m ->
                        match m.ImplementedSignatureRef with
                        | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)) ->
                            let qualName = $"{classDecl.Entity.FullName}_{m.Name}"
                            match ctx''.Functions |> Seq.tryFindBack (fun f -> f.Name = qualName) with
                            | Some func ->
                                Some(ifaceEntityRef.FullName, ifaceMemberInfo.CompiledName,
                                     qualName, func.Params |> List.map snd, func.Result)
                            | None -> None
                        | _ -> None)
                let byIface = ifaceImpls |> List.groupBy (fun (ifaceName, _, _, _, _) -> ifaceName)
                for (ifaceName, methods) in byIface do
                    let methodSigs =
                        methods |> List.map (fun (_, methodName, _, compiledParams, retType) ->
                            let nonSelfParams = match compiledParams with _ :: rest -> rest | [] -> []
                            methodName, nonSelfParams, retType)
                    let vtableTypeIdx, boxTypeIdx = VT.getOrRegisterInterface ctx'' ifaceName methodSigs
                    let _, _, funcTypeIndices, _ = ctx''.VTableRegistry.[ifaceName]
                    let methodImpls =
                        methods |> List.map (fun (_, methodName, compiledFunc, compiledParams, retType) ->
                            methodName, compiledFunc, compiledParams, retType)
                    VT.registerVTableImpl ctx'' classDecl.Entity.FullName typeIdx
                        ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodImpls
                ctx''

/// Build the final WModule from accumulated ctx state.
/// Call this once, on the last file in the project.
let buildWModule (ctx: Ctx) : WModule =
    let fixedFunctions =
        ctx.Functions |> Seq.toList
        |> RT.fixClosureApply ctx.TypeDefs

    // Validate the functions after closure transformations are applied
    Val.validate true ctx.TypeDefs fixedFunctions

    // TODO: Refactor buildWModule into a modular pipeline (e.g., separate modules for RuntimeHelpers, 
    // Validation, and ExportResolution) to avoid this becoming a "God Function."
    // Currently, buildWModule is doing "The Grand Setup": resolving dependencies, filtering helpers, handling errors (BUG-05), and building the record. As this grows, it becomes a "God Function."
    // Splitting these into distinct passes (e.g., Discovery -> Optimization -> Validation -> Emission) makes it much easier to test and debug.

    {
        Types = ctx.TypeDefs |> Seq.toList
        Imports =
            [   // User-declared external Wasm imports (via [<Import("name","module")>] on nativeOnly)
                yield! ctx.ExternImports.Values
                // Built-in: consolePrint for printfn (always needed)
                yield { ModuleName = "env"; Name = "consolePrint"; CallName = ""
                        Desc = ImportFunc([WType.Ref(StringTypeIdx, false)], WType.Void) } ]
        Functions =
            let strArrTypeIdx = getOrAddArrayType ctx (WType.Ref(StringTypeIdx, false))
            let helperBuilders =
                [ "$strConcat",    RT.makeStrConcatHelper
                  "$strEq",        RT.makeStrEqHelper
                  "$strIndexOf",      RT.makeStrIndexOfHelper
                  "$strLastIndexOf",   RT.makeStrLastIndexOfHelper
                  "$strSubstring",     RT.makeStrSubstringHelper
                  "$strToLower",   RT.makeStrToLowerHelper
                  "$strToUpper",   RT.makeStrToUpperHelper
                  "$strTrim",      RT.makeStrTrimHelper
                  "$strTrimStart", RT.makeStrTrimStartHelper
                  "$strTrimEnd",   RT.makeStrTrimEndHelper
                  "$intToStr",     RT.makeIntToStrHelper
                  "$floatToStr",   RT.makeFloatToStrHelper
                  "$strPadLeft",   RT.makeStrPadLeftHelper
                  "$strPadRight",  RT.makeStrPadRightHelper
                  "$strReplace",   RT.makeStrReplaceHelper
                  "$strSplit",     RT.makeStrSplitHelper strArrTypeIdx
                  "$strJoin",      RT.makeStrJoinHelper strArrTypeIdx
                  "$parseInt",     RT.makeIntParseHelper
                  "$parseFloat",   RT.makeFloatParseHelper
                  "$strCompare",   RT.makeStrCompareHelper
                  // ── Tier 1 char helpers ───────────────────────────────────
                  "$charIsDigit",         RT.makeCharIsDigitHelper
                  "$charIsLetter",        RT.makeCharIsLetterHelper
                  "$charIsUpper",         RT.makeCharIsUpperHelper
                  "$charIsLower",         RT.makeCharIsLowerHelper
                  "$charIsWhitespace",    RT.makeCharIsWhitespaceHelper
                  "$charToLower",         RT.makeCharToLowerHelper
                  "$charToUpper",         RT.makeCharToUpperHelper
                  "$charIsLetterOrDigit", RT.makeCharIsLetterOrDigitHelper
                  "$pown",              RT.makePownHelper
                  "$powF64",            RT.makePowF64Helper
                  "$mathExp",           RT.makeMathExpHelper
                  "$mathLog",           RT.makeMathLogHelper
                  "$mathSin",           RT.makeMathSinHelper
                  "$mathCos",           RT.makeMathCosHelper
                  "$mathTan",           RT.makeMathTanHelper
                  "$mathAtan2",         RT.makeMathAtan2Helper
                  // ── StringBuilder helpers ─────────────────────────────────
                  "$sbCreate",          RT.makeStringBuilderCreateHelper
                  "$sbAppend",          RT.makeStringBuilderAppendHelper
                  "$sbToString",        RT.makeStringBuilderToStringHelper ]
            let runtimeHelpers =
                // Resolve helper dependencies: $floatToStr calls $intToStr and $strConcat
                if ctx.UsedHelpers.Contains("$floatToStr") then
                    ctx.UsedHelpers.Add("$intToStr") |> ignore
                    ctx.UsedHelpers.Add("$strConcat") |> ignore
                // $strSplit depends on $strIndexOf and $strSubstring
                if ctx.UsedHelpers.Contains("$strSplit") then
                    ctx.UsedHelpers.Add("$strIndexOf") |> ignore
                    ctx.UsedHelpers.Add("$strSubstring") |> ignore
                // $strJoin depends on $strConcat
                if ctx.UsedHelpers.Contains("$strJoin") then
                    ctx.UsedHelpers.Add("$strConcat") |> ignore
                helperBuilders |> List.choose (fun (name, make) ->
                    if ctx.UsedHelpers.Contains(name) then Some(make()) else None)
            runtimeHelpers @ fixedFunctions
        Globals =
            // $fsharp_exn_carrier: mutable anyref global used to pass exception objects
            // between throw and catch_all (WasmGC exception proposal has zero-payload tags).
            let carrierGlobal =
                { Name = "$fsharp_exn_carrier"
                  Type = WType.AnyRef
                  Init = WExpr.Const(WConst.Null WType.AnyRef)
                  Mutable = true
                  Exported = false }
            [ yield carrierGlobal
              yield! ctx.VTableGlobals ]
        Exports =
            // Collect all exported functions
            let exportedFuncs =
                fixedFunctions
                |> List.filter (fun f -> f.Exported)
                |> List.map (fun f -> (f.Name, f))

            // BUG-05: Detect duplicate export names at compile time
            let duplicates =
                exportedFuncs
                |> List.groupBy fst
                |> List.choose (fun (name, items) ->
                    if items.Length > 1 then
                        Some(name, items |> List.map snd)
                    else None)

            // Emit warnings for duplicates
            if duplicates.Length > 0 then
                let dupNames = duplicates |> List.map fst |> String.concat ", "
                eprintfn "[WasmGc] WARNING BUG-05: Duplicate Wasm export names: %s. Use [<CompiledName(\"...\")>] to disambiguate or apply module qualification." dupNames

            [   // Linear memory export (index 0) must appear before function exports in the list
                if !ctx.HasLinearMemory then
                    yield { InternalName = "0"; ExportName = "memory"; Kind = ExportMemory }
                yield! exportedFuncs
                       |> List.map (fun (_, f) -> { InternalName = f.Name; ExportName = f.Name; Kind = ExportFunc }) ]
        DataSegments = []
        Tags = [ { Name = "$fsharp_exn"; ParamTypes = [] } ]
        Start = None
        HasLinearMemory = !ctx.HasLinearMemory
    }

/// Compile one Fable file INTO an existing ctx (multi-file accumulation).
/// Returns the updated ctx (KnownFuncs may grow; TypeDefs/Functions mutated in-place).
/// The com argument ensures GetEntity lookups use the current file's type-checker.
/// isLastFile controls whether functions get module-qualified names (library files = false).
let processFileIntoCtx (ctx: Ctx) (com: Compiler) (file: Fable.File) (isLastFile: bool) : Ctx =
    // Interop.fs is a Fable.Core stub that exists only for FCS type resolution.
    // Skip it entirely — our backend must never emit WasmGC code for it.
    let fileName = System.IO.Path.GetFileName(com.CurrentFile)
    if fileName = "Interop.fs" then
        { ctx with Compiler = com }
    else
    let stem = System.IO.Path.GetFileNameWithoutExtension(com.CurrentFile)
    // Update Compiler reference, and set library-context flags for the current file.
    let baseCtx = { ctx with
                        Compiler = com
                        CurrentFileStem = stem
                        IsLibraryContext = not isLastFile
                        NamePrefix = ""
                        FuncNameAlias = Map.empty }
    let ctx =
        if not isLastFile then
            // Pre-scan: build FuncNameAlias for all top-level member functions in this library file.
            // Fable puts file-level module functions at the top level (NOT inside ModuleDeclaration),
            // so we collect them here and prefix with the file stem to avoid name collisions.
            let rec collectMembers acc decls =
                (acc, decls) ||> List.fold (fun a d ->
                    match d with
                    | MemberDeclaration m -> Map.add m.Name (stem + "_" + m.Name) a
                    | ModuleDeclaration md -> collectMembers a md.Members
                    | _ -> a)
            let aliases = collectMembers Map.empty file.Declarations
            { baseCtx with FuncNameAlias = aliases }
        else baseCtx
    preScanGenerics ctx file.Declarations
    (ctx, file.Declarations) ||> List.fold processDecl

/// Compile one file from scratch, producing a WModule. Used for single-file projects
/// and as the fallback; Pipeline.fs uses processFileIntoCtx for multi-file projects.
let transformFile (com: Compiler) (file: Fable.File) : WModule =
    let ctx = Ctx.Create(com)
    let finalCtx = processFileIntoCtx ctx com file true  // single-file = always the "last" file
    buildWModule finalCtx
