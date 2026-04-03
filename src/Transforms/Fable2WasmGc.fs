/// Fable AST → WasmGc IR translation.
/// Phase 1: Handles minimal Fable AST cases for integers, floats,
/// let bindings, arithmetic, functions, and control flow.
module Fable.Transforms.WasmGc.Fable2WasmGc

open Fable
open Fable.AST
open Fable.AST.Fable
open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcFreeVars
open Fable.Transforms.WasmGc.WasmGcLoopHelpers
open Fable.Transforms.WasmGc.WasmGcRuntime
open Fable.Transforms.WasmGc.WasmGcLocals
open Fable.Transforms.WasmGc.WasmGcEquality
open Fable.Transforms.WasmGc.WasmGcReplacements
let rec transformExpr (ctx: Ctx) (expr: Fable.Expr) : WExpr =
    match expr with
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
        // For now, translate each binding as a sequential let
        // Recursive functions should already be declared at module level
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
        (binds, wBody) // TODO: sure, it was before (wBody, binds)?
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
        transformCall ctx callee info typ

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
        | ExprSet idxExpr
              when (match _expr.Type with | Fable.Type.Array _ -> true | _ -> false) ->
            let wArr = transformExpr ctx _expr
            let wIdx = transformExpr ctx idxExpr
            let wVal = transformExpr ctx value
            WExpr.ArraySet(wArr, wIdx, wVal)
        | _ -> WExpr.Nop // TODO: expr set

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
                let fieldIdx =
                    ent.FSharpFields
                    |> Seq.tryFindIndex (fun f -> f.Name = fieldInfo.Name)
                    |> Option.defaultValue 0
                WExpr.StructGet(wExpr, fieldIdx, mapTypeKnown ctx typ)
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
        WExpr.JoinApply($"$target_{targetIdx}", wArgs, ty)

    // ── Type cast ─────────────────────────────────────────
    | Fable.Expr.TypeCast(expr, targetFableType) ->
        let wExpr = transformExpr ctx expr
        let srcTy  = exprWType wExpr
        let dstTy  = mapType targetFableType
        if srcTy = dstTy then wExpr
        else
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
                            WasmGcVTable.emitBox ctx wExpr implTypeName ifaceName boxTypeIdx
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
            // Parse printf-style format string
            let parts = System.Collections.Generic.List<string>()
            let specs = System.Collections.Generic.List<char>()
            let sb = System.Text.StringBuilder()
            let mutable i = 0
            while i < fmt.Length do
                if fmt.[i] = '%' && i + 1 < fmt.Length then
                    let mutable j = i + 1
                    while j < fmt.Length && (System.Char.IsDigit(fmt.[j]) || fmt.[j] = '.' || fmt.[j] = '-' || fmt.[j] = '+' || fmt.[j] = ' ') do
                        j <- j + 1
                    if j < fmt.Length && fmt.[j] = '%' then
                        sb.Append('%') |> ignore
                        i <- j + 1
                    elif j < fmt.Length then
                        parts.Add(sb.ToString())
                        sb.Clear() |> ignore
                        specs.Add(fmt.[j])
                        i <- j + 1
                    else
                        i <- j
                else
                    sb.Append(fmt.[i]) |> ignore
                    i <- i + 1
            parts.Add(sb.ToString())
            let partsList = List.ofSeq parts
            let specsList = List.ofSeq specs
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
        let wArgs = args |> List.map (transformExpr ctx)
        // Derive functype from callee's lambda type
        let argTypes = args |> List.map (fun a -> mapTypeKnown ctx a.Type) |> List.filter (fun t -> t <> WType.Void)
        let funcTypeIdx = ctx.GetOrAddFuncType(argTypes, ty)
        // Look up which closure struct type corresponds to this functype
        // (registered by buildClosure earlier; 0 = AnyFn base if not found yet)
        let closureTypeIdx =
            match ctx.FuncTypeToClosureMap.TryGetValue(funcTypeIdx) with
            | true, cti -> cti
            | false, _ -> AnyFnTypeIdx
        WExpr.ClosureApply(wClosure, wArgs, funcTypeIdx, closureTypeIdx, 0, ty)

    // ── Lambda ────────────────────────────────────────────
    | Fable.Expr.Lambda(arg, body, name) ->
        buildClosure ctx [arg] body name

    | Fable.Expr.Delegate(args, body, name, _tags) ->
        buildClosure ctx args body name

    // ── Try/Catch ─────────────────────────────────────────
    | Fable.Expr.TryCatch(body, catch, finalizer, _range) ->
        let wBody = transformExpr ctx body
        let wCatch = catch |> Option.map (fun (ident, expr) ->
            ident.Name, transformExpr (ctx.WithLocal(ident.Name, WType.I32)) expr)
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

    // ── Catch-all ─────────────────────────────────────────
    | _ ->
        WExpr.Nop // TODO: emit warning for unhandled expression

// ─────────────────────────────────────────────────────────────────
// Value translation
// ─────────────────────────────────────────────────────────────────

/// Build a closure struct for a lambda/delegate.
/// Layout: struct { code_field: (ref $functype); cap1: T1; cap2: T2; ... }
/// The lifted function takes (cap1, cap2, ..., arg1, ...) as flat parameters.
/// The closure struct holds the captures; apply extracts them then calls via call_ref.
and buildClosure (ctx: Ctx) (args: Ident list) (body: Fable.Expr) (maybeName: string option) : WExpr =
    let baseName = defaultArg maybeName "$closure"
    // Give it a unique name based on type-def count (stable per file)
    let funcName = $"{baseName}_{ctx.TypeDefs.Count}"

    // Collect free variables (closed-over locals) from the body,
    // excluding the lambda parameters themselves.
    let argNames = args |> List.map (fun a -> a.Name) |> Set.ofList
    let freeVarNames =
        collectFreeVars argNames body
        |> Set.toList
        |> List.filter (fun name -> Map.containsKey name ctx.Locals)

    // Build capture list: (name, WType)
    let captures =
        freeVarNames
        |> List.map (fun name ->
            let ty = Map.tryFind name ctx.Locals |> Option.defaultValue WType.I32
            name, ty)
        |> List.filter (fun (_, ty) -> ty <> WType.Void)

    let captureCount = List.length captures

    // Lifted function parameters: captures first, then original args
    let captureParams = captures  // (name, WType)
    let argParams =
        args |> List.choose (fun a ->
            let ty = mapTypeKnown ctx a.Type
            if ty = WType.Void then None else Some(a.Name, ty))
    let allParams = captureParams @ argParams

    // Build function type: (cap types..., arg types...) → retType
    let paramTypes = allParams |> List.map snd
    let retType = mapResultTypeKnown ctx body.Type
    let funcTypeIdx = ctx.GetOrAddFuncType(paramTypes, retType)

    // Build closure struct type: { code: (ref $functype), cap0: T0, ... }
    let codeFieldType = WType.Ref(funcTypeIdx, false)
    let captureFields =
        captures |> List.mapi (fun i (name, ty) ->
            { Name = $"cap_{i}_{name}"; Type = ty; Mutable = false })
    let codeField = { Name = "code"; Type = codeFieldType; Mutable = false }
    let closureTypeIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add(
        { Name = $"ClosureType_{closureTypeIdx}"
          Def = WTypeDef.Struct(codeField :: captureFields, Some AnyFnTypeIdx) })
    ctx.ClosureRegistry.[funcName] <- (closureTypeIdx, funcTypeIdx, captureCount)
    // Also map funcTypeIdx → closureTypeIdx for CurriedApply resolution
    if not (ctx.FuncTypeToClosureMap.ContainsKey(funcTypeIdx)) then
        ctx.FuncTypeToClosureMap.[funcTypeIdx] <- closureTypeIdx

    // Build lifted function body:
    // In the function, capture parameters have their original names.
    // Add all to local context.
    let ctx' =
        allParams |> List.fold (fun (c: Ctx) (name, ty) -> c.WithLocal(name, ty)) ctx
    let ctx' = { ctx' with CurrentFunc = Some funcName }
    let wBody = transformExpr ctx' body

    let funcDecl : WFuncDecl =
        {
            Name = funcName
            Params = allParams
            Result = retType
            Locals = []
            Body = wBody
            Exported = false
        }
    // Resolve locals inline (resolveLocals is defined after this mutual-rec group)
    let paramNameSet = allParams |> List.map fst |> Set.ofList
    let resolvedLocals =
        collectLocals paramNameSet wBody
        |> List.distinctBy fst
        |> List.filter (fun (_, ty) -> ty <> WType.Void)
    ctx.Functions.Add({ funcDecl with Locals = resolvedLocals })

    // Return WExpr.Closure(funcName, capture_WExprs, closureRefType)
    let captureExprs =
        captures |> List.map (fun (name, ty) -> WExpr.LocalGet(name, ty))
    let closureRefType = WType.Ref(closureTypeIdx, false)
    WExpr.Closure(funcName, captureExprs, closureRefType)

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

and transformCall (ctx: Ctx) (callee: Fable.Expr) (info: CallInfo) (typ: Fable.Type) : WExpr =
    let ty = mapTypeKnown ctx typ
    let wArgs = info.Args |> List.map (transformExpr ctx)
    // ── Interface vtable dispatch ─────────────────────────────────────────────
    // Detect `iface.Method(args)` where the receiver is a known vtable-boxed interface.
    // MemberRef points to the interface's own method declaration; thisArg is the box.
    let ifaceDispatch =
        match info.MemberRef, info.ThisArg with
        | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)), Some thisArg ->
            let ifaceName = ifaceEntityRef.FullName
            match ctx.VTableRegistry.TryGetValue(ifaceName) with
            | true, (vtableTypeIdx, boxTypeIdx, funcTypeIndices, methodNames) ->
                let methodName = ifaceMemberInfo.CompiledName
                match methodNames |> List.tryFindIndex (fun n -> n = methodName) with
                | Some methodIdx ->
                    let boxExpr = transformExpr ctx thisArg
                    Some (WasmGcVTable.emitCallVirtual ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodIdx boxExpr wArgs ty)
                | None -> None
            | false, _ -> None
        | _ -> None
    match ifaceDispatch with
    | Some result -> result
    | None ->
    match callee with
    | Fable.Expr.IdentExpr ident ->
        // Sprint 5: try demand-driven generic specialization first.
        match trySpecializeCall ctx ident.Name info typ with
        | Some specialized -> specialized
        | None ->
        // Direct function call (non-generic or unregistered generic).
        // In library context, FuncNameAlias maps short→qualified for same-file recursive calls.
        let actualName = ctx.FuncNameAlias |> Map.tryFind ident.Name |> Option.defaultValue ident.Name
        WExpr.Call(actualName, wArgs, ty)
    | Fable.Expr.Import(importInfo, _, _) ->
        // For string instance methods (IndexOf, Substring, etc.), Fable puts the
        // receiver in info.ThisArg rather than info.Args. Prepend it so our dispatch
        // patterns see [receiver; arg1; ...] like module-level functions do.
        let wArgs =
            match info.ThisArg with
            | Some t -> transformExpr ctx t :: wArgs
            | None -> wArgs
        // ── Higher-order list/option combinators — delegated to WasmGcReplacements ──
        match tryListFoldInline transformExpr ctx importInfo.Selector info.Args with
        | Some result -> result
        | None ->
        match tryListFoldBackInline transformExpr ctx importInfo.Selector info.Args typ with
        | Some result -> result
        | None ->
        match tryListMapInline transformExpr ctx importInfo.Selector info.Args typ with
        | Some result -> result
        | None ->
        match tryListCollectInline transformExpr ctx importInfo.Selector info.Args typ with
        | Some result -> result
        | None ->
        match tryListChooseInline transformExpr ctx importInfo.Selector info.Args typ with
        | Some result -> result
        | None ->
        match tryListInitReplicateInline transformExpr ctx importInfo.Selector info.Args typ with
        | Some result -> result
        | None ->
        match tryListTakeSkipSortInline transformExpr ctx importInfo.Selector info.Args typ with
        | Some result -> result
        | None ->
        match tryListSumByInline transformExpr ctx importInfo.Selector info.Args typ with
        | Some result -> result
        | None ->
        match tryListMinMaxByInline transformExpr ctx importInfo.Selector info.Args with
        | Some result -> result
        | None ->
        match tryListFilterInline transformExpr ctx importInfo.Selector info.Args with
        | Some result -> result
        | None ->
        match tryListIterInline transformExpr ctx importInfo.Selector info.Args with
        | Some result -> result
        | None ->
        match tryListExistsForAllInline transformExpr ctx importInfo.Selector info.Args with
        | Some result -> result
        | None ->
        match tryOptionInline transformExpr ctx importInfo.Selector info.Args ty with
        | Some result -> result
        | None ->
        match tryResultInline transformExpr ctx importInfo.Selector info.Args ty with
        | Some result -> result
        | None ->
        // ── Array module primitives — delegated to WasmGcReplacements ──────────
        match tryArrayInline transformExpr ctx importInfo.Selector info.Args wArgs typ with
        | Some result -> result
        | None ->
        // ── General import handling (already-transformed args) ─────────────────────
        // Inline arithmetic/logical operators that Fable routes through imports
        // when no Replacements module handles them (WasmGc has none yet).
        // ── List/Option operations — delegated to WasmGcReplacements ─────────────
        match tryListPrimitiveInline ctx importInfo.Selector wArgs ty info.Args with
        | Some result -> result
        | None ->
        match tryListTryHeadInline transformExpr ctx importInfo.Selector wArgs ty info.Args with
        | Some result -> result
        | None ->
        match tryListTryFindInline transformExpr ctx importInfo.Selector info.Args ty with
        | Some result -> result
        | None ->
        match importInfo.Selector, wArgs, ty with
        // ── Structural equality: Fable compiles record/DU/tuple `=` as Util.equals/equalArrays ──
        | ("equals" | "op_Equality" | "equalArrays"), [a; b], WType.I32 ->
            let wty = exprWType a
            let typeIdx = match wty with WType.Ref(idx, _) -> idx | _ -> -1
            if typeIdx >= 0 then
                ctx.UseHelper("$strEq") |> ignore
                match getOrAddStructuralEquals ctx typeIdx with
                | Some funcName -> WExpr.Call(funcName, [a; b], WType.I32)
                | None -> WExpr.Compare(WCompareOp.Eq, a, b)
            else WExpr.Compare(WCompareOp.Eq, a, b)  // primitives: direct eq
        // Unary negation: 0 - x
        | ("op_UnaryNegation_Int32" | "op_UnaryNegation"), [arg], WType.I32 ->
            WExpr.Binary(WBinaryOp.Sub, WExpr.Const(WConst.I32 0), arg, WType.I32)
        | ("op_UnaryNegation_Int64" | "op_UnaryNegation"), [arg], WType.I64 ->
            WExpr.Binary(WBinaryOp.Sub, WExpr.Const(WConst.I64 0L), arg, WType.I64)
        | ("op_UnaryNegation_Float32"), [arg], WType.F32 ->
            WExpr.Unary(WUnaryOp.Neg, arg, WType.F32)
        | ("op_UnaryNegation_Float64" | "op_UnaryNegation"), [arg], WType.F64 ->
            WExpr.Unary(WUnaryOp.Neg, arg, WType.F64)
        // Math helpers imported from fable-library/Double.js, Util.js etc.
        // Route these through dispatchMathCall so they get proper WasmIR.
        | ("abs" | "min" | "max" | "round" | "sign" | "sqrt" | "floor" | "ceiling" | "ceil" | "trunc" | "truncate" | "nearest"), _, _ ->
            dispatchMathCall importInfo.Selector wArgs ty
        // String char access: String.getCharAtIndex(str, idx) → array.get $WasmStr
        | "getCharAtIndex", [str; idx], _ ->
            WExpr.ArrayGet(str, idx, WType.I32)
        // String.indexOf(str, needle) → $strIndexOf
        | "indexOf", [str; needle], WType.I32 ->
            WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; needle], WType.I32)
        // String.startsWith(str, prefix) → $strIndexOf == 0
        | "startsWith", [str; prefix], _ ->
            WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; prefix], WType.I32), WExpr.Const(WConst.I32 0))
        // String.endsWith(str, suffix) → check at (len(str) - len(suffix))
        | "endsWith", [str; suffix], _ ->
            let strLen  = WExpr.ArrayLen str
            let sufLen  = WExpr.ArrayLen suffix
            let pos     = WExpr.Binary(WBinaryOp.Sub, strLen, sufLen, WType.I32)
            // pos >= 0 && $strIndexOf(str, suffix) == pos
            let posOk   = WExpr.Compare(WCompareOp.GeS, pos, WExpr.Const(WConst.I32 0))
            let atEnd   = WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; suffix], WType.I32), pos)
            WExpr.Binary(WBinaryOp.And, posOk, atEnd, WType.I32)
        // String.substring(str, start, len) → $strSubstring
        | "substring", [str; start; len], _ ->
            WExpr.Call(ctx.UseHelper("$strSubstring"), [str; start; len], WType.Ref(StringTypeIdx, false))
        | "substring", [str; start], _ ->
            let len = WExpr.Binary(WBinaryOp.Sub, WExpr.ArrayLen str, start, WType.I32)
            WExpr.Call(ctx.UseHelper("$strSubstring"), [str; start; len], WType.Ref(StringTypeIdx, false))
        // ── Char predicates and conversions (result type I32 distinguishes from string ops) ──
        | "isDigit", [c], WType.I32 ->
            let tmp = "$chd"
            WExpr.Let(tmp, c,
                WExpr.Binary(WBinaryOp.And,
                    WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 48)),
                    WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 57)),
                    WType.I32))
        | "isLetter", [c], WType.I32 ->
            let tmp = "$chl"
            WExpr.Let(tmp, c,
                WExpr.Binary(WBinaryOp.Or,
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 65)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 90)),
                        WType.I32),
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 97)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 122)),
                        WType.I32),
                    WType.I32))
        | "isLetterOrDigit", [c], WType.I32 ->
            let tmp = "$chlod"
            WExpr.Let(tmp, c,
                WExpr.Binary(WBinaryOp.Or,
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 48)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 57)),
                        WType.I32),
                    WExpr.Binary(WBinaryOp.Or,
                        WExpr.Binary(WBinaryOp.And,
                            WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 65)),
                            WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 90)),
                            WType.I32),
                        WExpr.Binary(WBinaryOp.And,
                            WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 97)),
                            WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 122)),
                            WType.I32),
                        WType.I32),
                    WType.I32))
        | "isUpper", [c], WType.I32 ->
            let tmp = "$chup"
            WExpr.Let(tmp, c,
                WExpr.Binary(WBinaryOp.And,
                    WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 65)),
                    WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 90)),
                    WType.I32))
        | "isLower", [c], WType.I32 ->
            let tmp = "$chlo"
            WExpr.Let(tmp, c,
                WExpr.Binary(WBinaryOp.And,
                    WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 97)),
                    WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 122)),
                    WType.I32))
        | "isWhiteSpace", [c], WType.I32 ->
            let tmp = "$chws"
            WExpr.Let(tmp, c,
                WExpr.Binary(WBinaryOp.Or,
                    WExpr.Compare(WCompareOp.Eq, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 32)),
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 9)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 13)),
                        WType.I32),
                    WType.I32))
        // Char.ToLower(c) → if A-Z then c+32 else c (result I32 distinguishes from string toLower)
        | "toLower", [c], WType.I32 ->
            let tmp = "$chcl"
            WExpr.Let(tmp, c,
                WExpr.If(
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 65)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 90)),
                        WType.I32),
                    WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 32), WType.I32),
                    WExpr.LocalGet(tmp, WType.I32), WType.I32))
        // Char.ToUpper(c) → if a-z then c-32 else c (result I32 distinguishes from string toUpper)
        | "toUpper", [c], WType.I32 ->
            let tmp = "$chcu"
            WExpr.Let(tmp, c,
                WExpr.If(
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 97)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 122)),
                        WType.I32),
                    WExpr.Binary(WBinaryOp.Sub, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 32), WType.I32),
                    WExpr.LocalGet(tmp, WType.I32), WType.I32))
        // String.toLower / toUpper / trim
        | ("toLower" | "toLowerInvariant"), [str], _ ->
            WExpr.Call(ctx.UseHelper("$strToLower"), [str], WType.Ref(StringTypeIdx, false))
        | ("toUpper" | "toUpperInvariant"), [str], _ ->
            WExpr.Call(ctx.UseHelper("$strToUpper"), [str], WType.Ref(StringTypeIdx, false))
        | "trim", [str], _ ->
            WExpr.Call(ctx.UseHelper("$strTrim"), [str], WType.Ref(StringTypeIdx, false))
        | ("trimStart" | "trimLeft"), [str], _ ->
            WExpr.Call(ctx.UseHelper("$strTrimStart"), [str], WType.Ref(StringTypeIdx, false))
        | ("trimEnd" | "trimRight"), [str], _ ->
            WExpr.Call(ctx.UseHelper("$strTrimEnd"), [str], WType.Ref(StringTypeIdx, false))
        // String.contains(str, needle) → $strIndexOf >= 0
        | "contains", [str; needle], _ ->
            WExpr.Compare(WCompareOp.GeS, WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; needle], WType.I32), WExpr.Const(WConst.I32 0))
        // String.IsNullOrEmpty(str) → array.len = 0 (our strings are never null in WasmGC)
        | "isNullOrEmpty", [str], _ ->
            WExpr.Compare(WCompareOp.Eq, WExpr.ArrayLen(str), WExpr.Const(WConst.I32 0))
        // String.IsNullOrWhiteSpace(str) → trim then check length = 0
        | "isNullOrWhiteSpace", [str], _ ->
            WExpr.Compare(WCompareOp.Eq,
                WExpr.ArrayLen(WExpr.Call(ctx.UseHelper("$strTrim"), [str], WType.Ref(StringTypeIdx, false))),
                WExpr.Const(WConst.I32 0))
        // String.compare(a, b) / String.Compare(a, b) → $strCompare → i32 (-1 | 0 | 1)
        | ("compare" | "compareOrdinal" | "compareCurrentCulture"), [a; b], WType.I32 ->
            WExpr.Call(ctx.UseHelper("$strCompare"), [a; b], WType.I32)
        // toString for numbers (via LibCall path)
        | "toString", [arg], WType.Ref(si, _) when si = StringTypeIdx ->
            WExpr.Call(ctx.UseHelper("$intToStr"), [arg], WType.Ref(StringTypeIdx, false))
        | "toString", [arg], _ ->
            WExpr.Call(ctx.UseHelper("$intToStr"), [arg], WType.Ref(StringTypeIdx, false))
        // int32ToString / int64ToString (Util module LibCall path)
        | "int32ToString", [arg], _ ->
            WExpr.Call(ctx.UseHelper("$intToStr"), [arg], WType.Ref(StringTypeIdx, false))
        | "int64ToString", [arg], _ ->
            WExpr.Call(ctx.UseHelper("$intToStr"), [WExpr.Unary(WUnaryOp.WrapI64, arg, WType.I32)], WType.Ref(StringTypeIdx, false))
        // String.padLeft / padRight
        | "padLeft", [str; width], _ ->
            WExpr.Call(ctx.UseHelper("$strPadLeft"), [str; width], WType.Ref(StringTypeIdx, false))
        | "padRight", [str; width], _ ->
            WExpr.Call(ctx.UseHelper("$strPadRight"), [str; width], WType.Ref(StringTypeIdx, false))
        // String.replace (all occurrences)
        | "replace", [str; oldSub; newSub], _ ->
            WExpr.Call(ctx.UseHelper("$strReplace"), [str; oldSub; newSub], WType.Ref(StringTypeIdx, false))
        // String.split — Fable emits LibCall(String, "split", [str; sepArr; option; splitOptions])
        // We only support the simple str + single-separator case.
        | "split", str :: rest, _ ->
            let strArrTypeIdx = getOrAddArrayType ctx (WType.Ref(StringTypeIdx, false))
            let arrRef = WType.Ref(strArrTypeIdx, false)
            // Extract the separator: rest[0] is an array-of-strings; get its first element
            let sepArr = List.tryHead rest
            match sepArr with
            | Some sepArrExpr ->
                // sepArrExpr is array of strings; take first element as the delimiter
                let delim = WExpr.ArrayGet(sepArrExpr, WExpr.Const(WConst.I32 0), WType.Ref(StringTypeIdx, false))
                WExpr.Call(ctx.UseHelper("$strSplit"), [str; delim], arrRef)
            | None ->
                // No separator — split on whitespace (use " " as separator)
                let space = WExpr.ArrayNewFixed(StringTypeIdx, [WExpr.Const(WConst.I32 32)], WType.Ref(StringTypeIdx, false))
                WExpr.Call(ctx.UseHelper("$strSplit"), [str; space], arrRef)
        // ── printf-style format strings: "interpolate" (printfn/%d/%s/%f) ─────────
        // Fable emits: LibCall(String, "interpolate", [StringConst fmt; NewArray(ArrayValues vals)])
        // We intercept info.Args (raw Fable AST) before transformation to parse the format.
        // Handles %d %i %s %f %g %e %b %o %x specifiers.
        | "interpolate", _, _ ->
            let strRef = WType.Ref(StringTypeIdx, false)
            let emitLit (s: string) =
                WExpr.ArrayNewFixed(StringTypeIdx,
                    s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList, strRef)
            // Parse printf-style format string: split at %specs, return (prefix_parts, spec_chars)
            let parseFormat (fmt: string) =
                let parts = System.Collections.Generic.List<string>()
                let specs = System.Collections.Generic.List<char>()
                let sb = System.Text.StringBuilder()
                let mutable i = 0
                while i < fmt.Length do
                    if fmt.[i] = '%' && i + 1 < fmt.Length then
                        let mutable j = i + 1
                        // skip optional flags, width, precision (e.g. "-10.2")
                        while j < fmt.Length && (System.Char.IsDigit(fmt.[j]) || fmt.[j] = '.' || fmt.[j] = '-' || fmt.[j] = '+' || fmt.[j] = ' ') do
                            j <- j + 1
                        if j < fmt.Length && fmt.[j] = '%' then
                            // %% → literal '%'
                            sb.Append('%') |> ignore
                            i <- j + 1
                        elif j < fmt.Length then
                            parts.Add(sb.ToString())
                            sb.Clear() |> ignore
                            specs.Add(fmt.[j])
                            i <- j + 1
                        else
                            i <- j
                    else
                        sb.Append(fmt.[i]) |> ignore
                        i <- i + 1
                parts.Add(sb.ToString())
                List.ofSeq parts, List.ofSeq specs
            // Convert one format hole value to a string WExpr
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
            // Extract raw Fable args (before transformation) to get format string + value exprs
            let fmtStrOpt, valExprs =
                match info.Args with
                | Fable.Expr.Value(Fable.ValueKind.StringConstant fmt, _)
                  :: Fable.Expr.Value(Fable.ValueKind.NewArray(Fable.NewArrayKind.ArrayValues vals, _, _), _) :: _ ->
                    Some fmt, vals
                | Fable.Expr.Value(Fable.ValueKind.StringConstant fmt, _) :: _ ->
                    Some fmt, []
                | _ -> None, []
            match fmtStrOpt with
            | None ->
                eprintfn "[WasmGc] interpolate: unexpected arg shape — falling back to Nop"
                WExpr.Nop
            | Some fmt ->
                let parts, specs = parseFormat fmt
                let nSpecs = List.length specs
                let holeParts =
                    [ for k in 0 .. nSpecs - 1 do
                        yield emitLit parts.[k]
                        if k < valExprs.Length then
                            yield formatHole specs.[k] valExprs.[k] ]
                let lastPart = if List.isEmpty parts then "" else List.last parts
                let segments = holeParts @ [emitLit lastPart]
                match segments with
                | [] -> emitLit ""
                | [single] -> single
                | head :: tail ->
                    tail |> List.fold (fun acc s ->
                        WExpr.Call(ctx.UseHelper("$strConcat"), [acc; s], strRef)) head
        // toText: the result of sprintf — already a string, just pass it through
        | "toText", [str], _ -> str
        // printf(str) — process %% → % in format string, pass through
        | "printf", [str], _ ->
            match info.Args with
            | Fable.Expr.Value(Fable.ValueKind.StringConstant fmt, _) :: _ when fmt.Contains("%%") ->
                let strRef = WType.Ref(StringTypeIdx, false)
                let processed = fmt.Replace("%%", "%")
                WExpr.ArrayNewFixed(StringTypeIdx,
                    processed |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList, strRef)
            | _ -> str
        | "printf", (str :: _), _ -> str  // with format holes, best-effort pass-through
        | "toConsoleError", [str], _ ->
            WExpr.Call("consolePrint", [str], WType.Void)
        // String concat: String.concat([str1; str2; ...]) → fold $strConcat
        // hasSpread=true so args[0] may be an array; handle simple 2-arg case
        | "concat", [WExpr.ArrayNewFixed(_, [a; b], _)], _ ->
            let strRef = WType.Ref(StringTypeIdx, false)
            WExpr.Call(ctx.UseHelper("$strConcat"), [a; b], strRef)
        | "concat", [a; b], _ ->
            let strRef = WType.Ref(StringTypeIdx, false)
            WExpr.Call(ctx.UseHelper("$strConcat"), [a; b], strRef)
        // ── BigInt/Int64 conversion helpers ─────────────────────────────────────
        // In WasmGC, I64 is native, so BigInt intermediaries become no-ops or simple converts.
        // fromInt32(x : I32) → I64   →  i64.extend_i32_s
        | "fromInt32", [arg], WType.I64 ->
            WExpr.Unary(WUnaryOp.ExtendI32S, arg, WType.I64)
        // toInt64_unchecked(x : I64) → I64  → passthrough (BigInt→I64 already done by mapType)
        | "toInt64_unchecked", [arg], WType.I64 ->
            arg
        // toInt32_unchecked(x : I64) → I32  → i32.wrap_i64
        | "toInt32_unchecked", [arg], WType.I32 ->
            WExpr.Unary(WUnaryOp.WrapI64, arg, WType.I32)
        // BigInt op_Addition / op_Subtraction / op_Multiply for I64
        | "op_Addition", [a; b], WType.I64 ->
            WExpr.Binary(WBinaryOp.Add, a, b, WType.I64)
        | "op_Subtraction", [a; b], WType.I64 ->
            WExpr.Binary(WBinaryOp.Sub, a, b, WType.I64)
        | "op_Multiply", [a; b], WType.I64 ->
            WExpr.Binary(WBinaryOp.Mul, a, b, WType.I64)
        // ── FSharpRef constructor: FSharpRef(initVal) → StructNew of mutable 1-field box ──
        | "FSharpRef", [initVal], _ ->
            let innerWType = exprWType initVal
            let refTypeIdx = getOrAddRefCellType ctx innerWType
            WExpr.StructNew(refTypeIdx, [initVal], WType.Ref(refTypeIdx, false))
        // ── toConsole (printfn final stage): calls $consolePrint(str) ─────────────
        // Emits a call to the JS-imported $consolePrint function.
        // String.toConsole is called with the final formatted string.
        | "toConsole", [str], _ ->
            WExpr.Call("consolePrint", [str], WType.Void)
        // String.join(sep, arr) → $strJoin — Fable emits LibCall(String, "join", [sep; arr])
        | "join", sep :: rest, WType.Ref(si, _) when si = StringTypeIdx ->
            let strArrTypeIdx = getOrAddArrayType ctx (WType.Ref(StringTypeIdx, false))
            let arrRef = WType.Ref(strArrTypeIdx, false)
            match rest with
            | [arrExpr] ->
                WExpr.Call(ctx.UseHelper("$strJoin"), [sep; arrExpr], WType.Ref(StringTypeIdx, false))
            | _ ->
                // joinWithIndices or other overload — not yet supported, emit Nop
                eprintfn "[WasmGc] WARNING: unhandled String.join variant with %d args" rest.Length
                WExpr.Nop
        // String.join with no sep (sep = "")
        | "join", [arrExpr], _ ->
            let strRef = WType.Ref(StringTypeIdx, false)
            let emptyStr = WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
            WExpr.Call(ctx.UseHelper("$strJoin"), [emptyStr; arrExpr], strRef)
        // Int/Long parse: LibCall(Int/Long/Int8/UInt8/..., "parse", [str; style; unsigned; bitsize])
        // We dispatch to $parseInt regardless of style — basic decimal parsing only.
        | "parse", str :: _, WType.I32 ->
            WExpr.Call(ctx.UseHelper("$parseInt"), [str], WType.I32)
        | "parse", str :: _, WType.I64 ->
            // Parse as i32 then extend to i64 (sufficient for typical use)
            WExpr.Unary(WUnaryOp.ExtendI32S,
                WExpr.Call(ctx.UseHelper("$parseInt"), [str], WType.I32), WType.I64)
        // Double/Float parse: LibCall(Double, "parse", [str])
        | "parse", [str], WType.F64 ->
            WExpr.Call(ctx.UseHelper("$parseFloat"), [str], WType.F64)
        | "parse", [str], WType.F32 ->
            WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$parseFloat"), [str], WType.F64), WType.F32)
        // Fallback: if the selector names a function compiled from a library
        // file earlier in this project (in ctx.KnownFuncs), emit a direct call.
        // This handles same-project cross-file calls (e.g. MapModule.add).
        | selector, _, _ ->
            // Use the import path to find the module-qualified function name.
            // importInfo.Path = e.g. "../fable-library-wasmgc/Map.fs" → stem = "Map"
            let stem = System.IO.Path.GetFileNameWithoutExtension(importInfo.Path)
            let actualName =
                match Map.tryFind (stem, selector) ctx.KnownFuncsByPath with
                | Some qualName -> qualName
                | None -> selector  // fallback to short name (handles non-library or unknown)
            match Map.tryFind actualName ctx.KnownFuncs with
            | Some _ -> WExpr.Call(actualName, wArgs, ty)
            | None ->
            // ── External Wasm FFI — [<Import("name","module")>] on nativeOnly ──────────
            // When the path has no .fs extension and no fable-library, treat as a Wasm import.
            // The import is registered once; subsequent calls reuse the same declaration.
            let path = importInfo.Path
            let pLow = path.ToLowerInvariant()
            let isLocalFile = pLow.EndsWith(".fs") || pLow.EndsWith(".fsi")
            let isFableLib = pLow.Contains("fable-library")
            if not isLocalFile && not isFableLib && selector <> "" then
                let paramTypes = wArgs |> List.map exprWType
                let callName = ctx.RegisterExternFunc(path, selector, paramTypes, ty)
                WExpr.Call(callName, wArgs, ty)
            else
                eprintfn "[WasmGc] WARNING: unhandled import call '%s' from '%s' — emitting Nop" selector path
                WExpr.Nop
    // ── Numeric .toString() — for string(n), n.ToString(), sprintf, etc. ────
    | Fable.Expr.Get(numExpr, GetKind.FieldGet fi, _, _)
        when fi.Name = "toString"
          && (match numExpr.Type with
              | Fable.Type.Number _ | Fable.Type.Boolean -> true | _ -> false) ->
        let wNum = transformExpr ctx numExpr
        let strRef = WType.Ref(StringTypeIdx, false)
        match exprWType wNum with
        | WType.I64 -> WExpr.Call(ctx.UseHelper("$intToStr"), [WExpr.Unary(WUnaryOp.WrapI64, wNum, WType.I32)], strRef)
        | WType.F64 | WType.F32 ->
            WExpr.Call(ctx.UseHelper("$intToStr"), [WExpr.Unary(WUnaryOp.TruncF64S, wNum, WType.I32)], strRef)
        | _ -> WExpr.Call(ctx.UseHelper("$intToStr"), [wNum], strRef)
    // ── char.charCodeAt(0) — Fable JS replacement for int(char) conversion ──
    // In WasmGC, chars are already i32 code points; charCodeAt(0) is a no-op.
    | Fable.Expr.Get(thisExpr, GetKind.FieldGet fi, _, _) when fi.Name = "charCodeAt" ->
        transformExpr ctx thisExpr   // discard the '0' arg; just return the char i32 value
    // ── Char instance methods (Fable emits .toLocaleLowerCase() etc. on char values) ──
    | Fable.Expr.Get(charExpr, GetKind.FieldGet fi, _, _)
        when (match charExpr.Type with | Fable.Type.Char -> true | _ -> false) ->
        let wChar = transformExpr ctx charExpr
        match fi.Name with
        | ("toLocaleLowerCase" | "toLower" | "toLowerCase") ->
            // Char.ToLower: if A-Z then c+32 else c
            let tmp = "$chcl2"
            WExpr.Let(tmp, wChar,
                WExpr.If(
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 65)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 90)),
                        WType.I32),
                    WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 32), WType.I32),
                    WExpr.LocalGet(tmp, WType.I32), WType.I32))
        | ("toLocaleUpperCase" | "toUpper" | "toUpperCase") ->
            // Char.ToUpper: if a-z then c-32 else c
            let tmp = "$chcu2"
            WExpr.Let(tmp, wChar,
                WExpr.If(
                    WExpr.Binary(WBinaryOp.And,
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 97)),
                        WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 122)),
                        WType.I32),
                    WExpr.Binary(WBinaryOp.Sub, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 32), WType.I32),
                    WExpr.LocalGet(tmp, WType.I32), WType.I32))
        | _ ->
            eprintfn "[WasmGc] WARNING: unhandled char method '%s' — returning char unchanged" fi.Name
            wChar
    // ── Math.* (JS GlobalCall("Math", ...) from replacements) ─────
    // ── Math.pow → $pown (i32) or $powF64 (f64 repeated-squaring) ────────
    | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
        when fi.Name = "pow" && ty = WType.I32 ->
        WExpr.Call(ctx.UseHelper("$pown"), wArgs, WType.I32)
    | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
        when fi.Name = "pow" && (ty = WType.F64 || ty = WType.F32) ->
        WExpr.Call(ctx.UseHelper("$powF64"), wArgs, WType.F64)
    | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _) ->
        dispatchMathCall fi.Name wArgs ty
    // ── String instance methods: indexOf, startsWith, endsWith, substring ──────
    // These come as Get(strExpr, FieldGet "indexOf") callee with args=[needle].
    // We intercept before the general FieldGet handler.
    | Fable.Expr.Get(strExpr, GetKind.FieldGet fi, _, _)
        when (match strExpr.Type with | Fable.Type.String -> true | _ -> false) ->
        let wStr = transformExpr ctx strExpr
        let mArgs = info.Args |> List.map (transformExpr ctx)
        let strRef = WType.Ref(StringTypeIdx, false)
        match fi.Name, mArgs with
        | "indexOf", [needle] ->
            WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; needle], WType.I32)
        | "indexOf", [needle; fromIdx] ->
            // For indexOf with fromIndex: search in substring from fromIdx
            let subLen = WExpr.Binary(WBinaryOp.Sub, WExpr.ArrayLen wStr, fromIdx, WType.I32)
            let sub = WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; fromIdx; subLen], WType.Ref(StringTypeIdx, false))
            let found = WExpr.Call(ctx.UseHelper("$strIndexOf"), [sub; needle], WType.I32)
            // if found >= 0, add fromIdx back; else keep -1
            let tmp = "$iofi_tmp"
            WExpr.Let(tmp, found,
                WExpr.If(
                    WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), WExpr.Const(WConst.I32 0)),
                    WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(tmp, WType.I32), fromIdx, WType.I32),
                    WExpr.Const(WConst.I32 -1), WType.I32))
        | "lastIndexOf", [needle] ->
            WExpr.Call(ctx.UseHelper("$strLastIndexOf"), [wStr; needle], WType.I32)
        | "lastIndexOf", [needle; fromIdx] ->
            // For lastIndexOf with fromIndex: search in prefix up to fromIdx+1
            let clamped = WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; WExpr.Const(WConst.I32 0); WExpr.Binary(WBinaryOp.Add, fromIdx, WExpr.Const(WConst.I32 1), WType.I32)], WType.Ref(StringTypeIdx, false))
            WExpr.Call(ctx.UseHelper("$strLastIndexOf"), [clamped; needle], WType.I32)
        | "startsWith", [prefix] ->
            WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; prefix], WType.I32), WExpr.Const(WConst.I32 0))
        | "endsWith", [suffix] ->
            let pos = WExpr.Binary(WBinaryOp.Sub, WExpr.ArrayLen wStr, WExpr.ArrayLen suffix, WType.I32)
            let posOk = WExpr.Compare(WCompareOp.GeS, pos, WExpr.Const(WConst.I32 0))
            let atEnd = WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; suffix], WType.I32), pos)
            WExpr.Binary(WBinaryOp.And, posOk, atEnd, WType.I32)
        | "substring", [start] ->
            let len = WExpr.Binary(WBinaryOp.Sub, WExpr.ArrayLen wStr, start, WType.I32)
            WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; start; len], strRef)
        | "substring", [start; len] ->
            WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; start; len], strRef)
        | "slice", [start] ->
            let len = WExpr.Binary(WBinaryOp.Sub, WExpr.ArrayLen wStr, start, WType.I32)
            WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; start; len], strRef)
        | "slice", [start; endIdx] ->
            let len = WExpr.Binary(WBinaryOp.Sub, endIdx, start, WType.I32)
            WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; start; len], strRef)
        | "concat", [other] ->
            WExpr.Call(ctx.UseHelper("$strConcat"), [wStr; other], strRef)
        | ("toLowerCase" | "toLocaleLowerCase" | "toLowerInvariant"), [] ->
            WExpr.Call(ctx.UseHelper("$strToLower"), [wStr], strRef)
        | ("toUpperCase" | "toLocaleUpperCase" | "toUpperInvariant"), [] ->
            WExpr.Call(ctx.UseHelper("$strToUpper"), [wStr], strRef)
        | "trim", [] ->
            WExpr.Call(ctx.UseHelper("$strTrim"), [wStr], strRef)
        | ("trimStart" | "trimLeft"), [] ->
            WExpr.Call(ctx.UseHelper("$strTrimStart"), [wStr], strRef)
        | ("trimEnd" | "trimRight"), [] ->
            WExpr.Call(ctx.UseHelper("$strTrimEnd"), [wStr], strRef)
        | ("includes" | "contains"), [needle] ->
            WExpr.Compare(WCompareOp.GeS, WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; needle], WType.I32), WExpr.Const(WConst.I32 0))
        | "replace", [oldSub; newSub] ->
            WExpr.Call(ctx.UseHelper("$strReplace"), [wStr; oldSub; newSub], strRef)
        | "split", [sep] ->
            // str.split(sep) → $strSplit(str, sep); returns array of strings
            let strArrTypeIdx = getOrAddArrayType ctx (WType.Ref(StringTypeIdx, false))
            WExpr.Call(ctx.UseHelper("$strSplit"), [wStr; sep], WType.Ref(strArrTypeIdx, false))
        | "padStart", [width] | "padStart", [width; _] ->
            WExpr.Call(ctx.UseHelper("$strPadLeft"), [wStr; width], strRef)
        | "padEnd", [width] | "padEnd", [width; _] ->
            WExpr.Call(ctx.UseHelper("$strPadRight"), [wStr; width], strRef)
        | _ ->
            eprintfn "[WasmGc] WARNING: unhandled string method '%s' — emitting Nop" fi.Name
            WExpr.Nop
    // ── Native JS array HOF instance calls — delegated to WasmGcReplacements ──
    // Fable maps Array.Filter/Exists/ForAll/Iterate to JS native: .filter/.some/.every/.forEach
    | Fable.Expr.Get(arrExpr, GetKind.FieldGet fi, typ2, _) ->
        // ── vtable dispatch: `iface.Method(args)` where iface is a box-typed value ──
        let wReceiver = transformExpr ctx arrExpr
        match exprWType wReceiver with
        | WType.Ref(boxTypeIdx, false) ->
            // Check if boxTypeIdx corresponds to a known vtable box struct.
            let ifaceNameOpt =
                ctx.VTableRegistry |> Seq.tryFind (fun kv ->
                    let _, bti, _, _ = kv.Value
                    bti = boxTypeIdx)
                |> Option.map (fun kv -> kv.Key)
            match ifaceNameOpt with
            | Some ifaceName ->
                let vtableTypeIdx, _, funcTypeIndices, methodNames = ctx.VTableRegistry.[ifaceName]
                match methodNames |> List.tryFindIndex (fun n -> n = fi.Name) with
                | Some methodIdx ->
                    WasmGcVTable.emitCallVirtual ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodIdx wReceiver wArgs ty
                | None ->
                    // Method not in vtable — fall through to array instance/indirect
                    match tryArrayInstanceCall transformExpr ctx fi.Name arrExpr info.Args typ with
                    | Some result -> result
                    | None ->
                        let wCallee = transformExpr ctx callee
                        WExpr.CallIndirect(wCallee, wArgs, ty)
            | None ->
                match tryArrayInstanceCall transformExpr ctx fi.Name arrExpr info.Args typ with
                | Some result -> result
                | None ->
                    let wCallee = transformExpr ctx callee
                    WExpr.CallIndirect(wCallee, wArgs, ty)
        | _ ->
            match tryArrayInstanceCall transformExpr ctx fi.Name arrExpr info.Args typ with
            | Some result -> result
            | None ->
                let wCallee = transformExpr ctx callee
                WExpr.CallIndirect(wCallee, wArgs, ty)
    | _ ->
        // Indirect call (TODO: closure apply)
        let wCallee = transformExpr ctx callee
        WExpr.CallIndirect(wCallee, wArgs, ty)

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
                WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull(wExpr), WType.I32)
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
                WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull(wExpr), WType.I32)
            else
                WExpr.RefIsNull(wExpr)
        | _ ->
            if isCons then
                WExpr.Compare(WCompareOp.Ne, wExpr, WExpr.Const(WConst.I32 0))
            else
                WExpr.Compare(WCompareOp.Eq, wExpr, WExpr.Const(WConst.I32 0))
    | TypeTest _typ ->
        // TODO: runtime type test
        WExpr.Const(WConst.I32 0)

// ─────────────────────────────────────────────────────────────────
// Decision tree translation (pattern matching)
// ─────────────────────────────────────────────────────────────────

and transformDecisionTree (ctx: Ctx) (matchExpr: Fable.Expr) (targets: (Ident list * Fable.Expr) list) : WExpr =
    let resultType = mapTypeKnown ctx matchExpr.Type
    // Create join points for each target
    let wTargets =
        targets
        |> List.mapi (fun i (idents, body) ->
            let parms = idents |> List.map (fun id -> id.Name, mapTypeKnown ctx id.Type)
            let ctx' = (ctx, idents) ||> List.fold (fun c id -> c.WithLocal(id.Name, mapTypeKnown ctx id.Type))
            let wBody = transformExpr ctx' body
            $"$target_{i}", parms, wBody
        )
    // Translate the match expression (which contains DecisionTreeSuccess nodes)
    let wMatch = transformExpr ctx matchExpr
    // Wrap in join points
    (wMatch, List.rev wTargets)
    ||> List.fold (fun cont (label, parms, body) ->
        WExpr.JoinPoint(label, parms, body, cont, resultType)
    )

// ─────────────────────────────────────────────────────────────────
// Sprint 5: Monomorphization — demand-driven generic specialization
// ─────────────────────────────────────────────────────────────────

/// Try to specialize a call to a generic function.
/// Returns Some(WExpr.Call to the specialized version) or None if not applicable.
/// None means: fall through to the regular (unspecialized) call handling.
and trySpecializeCall
    (ctx: Ctx)
    (funcName: string)
    (info: Fable.CallInfo)
    (resultFableType: Fable.Type)
    : WExpr option =
    // 1. Quick exit: no GenericArgs = not a generic call.
    if info.GenericArgs.IsEmpty then None else
    // 2. Is this function body registered (i.e., defined in-module)?
    match ctx.GenericFuncRegistry.TryGetValue(funcName) with
    | false, _ -> None
    | true, (declCom, regObj) ->
    let memberDecl = regObj :?> MemberDecl
    // 3. Map concrete Fable types to WTypes.
    let wTypeArgs = info.GenericArgs |> List.map (mapTypeKnown ctx)
    // 4. Compute the mangled name for this specialization.
    let mangledName = mangleGenericName funcName wTypeArgs
    // 5. Pre-evaluate call arguments under the OUTER (non-specialized) ctx.
    let wArgs = info.Args |> List.map (transformExpr ctx)
    let retTy = mapTypeKnown ctx resultFableType
    // 6. Already emitted? Just emit a call — body is already in ctx.Functions.
    if ctx.MonoCache.ContainsKey(mangledName) then
        Some(WExpr.Call(mangledName, wArgs, retTy))
    else
    // 7. Get generic param names in declaration order via the declaring compiler.
    //    Use declCom (the compiler for the file that DECLARES the generic function)
    //    so that entity lookups resolve correctly even for cross-file generics.
    let paramNamesOpt =
        match memberDecl.MemberRef with
        | MemberRef(entityRef, memberRefInfo) ->
            match declCom.TryGetEntity(entityRef) with
            | Some entity ->
                match entity.TryFindMember(memberRefInfo) with
                | Some mfv ->
                    let names = mfv.GenericParameters |> List.map (fun p -> p.Name)
                    if names.Length = wTypeArgs.Length then Some names else None
                | None -> None
            | None -> None
        | GeneratedMemberRef _ -> None
    match paramNamesOpt with
    | None -> None  // can't retrieve param names — fall through to normal call
    | Some paramNames ->
    // 8. Register sentinel early to handle recursive specializations.
    ctx.MonoCache.[mangledName] <- mangledName
    // 9. Build TypeSubst: generic param name → concrete WType.
    let subst = List.zip paramNames wTypeArgs |> Map.ofList
    // 10. Build specialized context: set substitution + populate arg locals.
    //     Override Compiler with the declaring file's compiler so entity lookups
    //     within the body resolve against the right compilation unit.
    let ctx' = { ctx with TypeSubst = subst; CurrentFunc = Some mangledName; Compiler = declCom }
    let ctx' =
        (ctx', memberDecl.Args)
        ||> List.fold (fun c a -> c.WithLocal(a.Name, mapTypeKnown c a.Type))
    // 11. Translate the specialized function body.
    let retTy' = mapResultTypeKnown ctx' memberDecl.Body.Type
    let wBody = transformExpr ctx' memberDecl.Body
    // 12. Build params list (filter out unit/void).
    let funcParams =
        memberDecl.Args
        |> List.choose (fun a ->
            let ty = mapTypeKnown ctx' a.Type
            if ty = WType.Void then None else Some(a.Name, ty))
    // 13. Emit the specialized WFuncDecl.
    let func : WFuncDecl =
        { Name = mangledName
          Params = funcParams
          Result = retTy'
          Locals = []
          Body = wBody
          Exported = false }
    ctx.Functions.Add(func |> resolveLocals)
    Some(WExpr.Call(mangledName, wArgs, retTy'))

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
        let kfByPath =
            if isLibFunc then
                ctx.KnownFuncsByPath |> Map.add (ctx.CurrentFileStem, shortName) qualifiedName
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
                let vtableTypeIdx, boxTypeIdx = WasmGcVTable.getOrRegisterInterface ctx'' ifaceName methodSigs
                let _, _, funcTypeIndices, _ = ctx''.VTableRegistry.[ifaceName]
                let methodImpls =
                    methods |> List.map (fun (_, methodName, compiledFunc, compiledParams, retType) ->
                        methodName, compiledFunc, compiledParams, retType)
                WasmGcVTable.registerVTableImpl ctx'' classDecl.Entity.FullName typeIdx
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
                    ctx.TypeDefs.Add(
                        { Name = $"{classDecl.Entity.FullName}#{i}"
                          Def = WTypeDef.Struct(
                                { Name = "tag"; Type = WType.I32; Mutable = false } :: dataFields,
                                Some baseIdx) }))
                (ctx'', classDecl.AttachedMembers)
                ||> List.fold (fun c m ->
                    let func = transformMemberDecl c m |> resolveLocals
                    c.Functions.Add(func); c)
        else
            (ctx, classDecl.AttachedMembers)
            ||> List.fold (fun c m ->
                let func = transformMemberDecl c m |> resolveLocals
                c.Functions.Add(func); c)

/// Build the final WModule from accumulated ctx state.
/// Call this once, on the last file in the project.
let buildWModule (ctx: Ctx) : WModule =
    let fixedFunctions =
        ctx.Functions |> Seq.toList
        |> WasmGcRuntime.fixClosureApply ctx.TypeDefs
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
                [ "$strConcat",    WasmGcRuntime.makeStrConcatHelper
                  "$strEq",        WasmGcRuntime.makeStrEqHelper
                  "$strIndexOf",      WasmGcRuntime.makeStrIndexOfHelper
                  "$strLastIndexOf",   WasmGcRuntime.makeStrLastIndexOfHelper
                  "$strSubstring",     WasmGcRuntime.makeStrSubstringHelper
                  "$strToLower",   WasmGcRuntime.makeStrToLowerHelper
                  "$strToUpper",   WasmGcRuntime.makeStrToUpperHelper
                  "$strTrim",      WasmGcRuntime.makeStrTrimHelper
                  "$strTrimStart", WasmGcRuntime.makeStrTrimStartHelper
                  "$strTrimEnd",   WasmGcRuntime.makeStrTrimEndHelper
                  "$intToStr",     WasmGcRuntime.makeIntToStrHelper
                  "$floatToStr",   WasmGcRuntime.makeFloatToStrHelper
                  "$strPadLeft",   WasmGcRuntime.makeStrPadLeftHelper
                  "$strPadRight",  WasmGcRuntime.makeStrPadRightHelper
                  "$strReplace",   WasmGcRuntime.makeStrReplaceHelper
                  "$strSplit",     WasmGcRuntime.makeStrSplitHelper strArrTypeIdx
                  "$strJoin",      WasmGcRuntime.makeStrJoinHelper strArrTypeIdx
                  "$parseInt",     WasmGcRuntime.makeIntParseHelper
                  "$parseFloat",   WasmGcRuntime.makeFloatParseHelper
                  "$strCompare",   WasmGcRuntime.makeStrCompareHelper
                  // ── Tier 1 char helpers ───────────────────────────────────
                  "$charIsDigit",         WasmGcRuntime.makeCharIsDigitHelper
                  "$charIsLetter",        WasmGcRuntime.makeCharIsLetterHelper
                  "$charIsUpper",         WasmGcRuntime.makeCharIsUpperHelper
                  "$charIsLower",         WasmGcRuntime.makeCharIsLowerHelper
                  "$charIsWhitespace",    WasmGcRuntime.makeCharIsWhitespaceHelper
                  "$charToLower",         WasmGcRuntime.makeCharToLowerHelper
                  "$charToUpper",         WasmGcRuntime.makeCharToUpperHelper
                  "$charIsLetterOrDigit", WasmGcRuntime.makeCharIsLetterOrDigitHelper
                  "$pown",              WasmGcRuntime.makePownHelper
                  "$powF64",             WasmGcRuntime.makePowF64Helper ]
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
        Globals = ctx.VTableGlobals |> Seq.toList
        Exports =
            fixedFunctions
            |> List.choose (fun f ->
                if f.Exported then
                    Some { InternalName = f.Name; ExportName = f.Name; Kind = ExportFunc }
                else None)
        DataSegments = []
        Start = None
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
