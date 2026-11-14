
/// Fable AST → WasmGc IR translation.
module WasmGc.Transforms.TransformExpr

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST

open WasmGc.Builder.Core

open WasmGc.Runtime.Types
open WasmGc.Pipeline.Scope

module RT = WasmGc.Runtime.Runtime
module VT = WasmGc.Runtime.VTable
module Q  = WasmGc.Util.FableQuery

open WasmGc.Transforms.MathMap
open WasmGc.Transforms.ArrayReplacements

open TransformConstruct
open TransformClosures
open TransformDispatch
open TransformOperation
open TransformTest
open TransformDecisionTree

module Scope = WasmGc.Pipeline.Scope

open TransformHelpers

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
        do! WExpr.If(WExpr.Compare(WCompareOp.GeU, len, arrayLen(data)),
                wasm {
                    let! newCap = WExpr.Binary(WBinaryOp.Shl, arrayLen(data),
                                    i32One, WType.I32)
                    let! newDat = WExpr.ArrayNew(arrTypeIdx, newCap, zero, arrNNRefT)
                    do! WExpr.ArrayCopy(newDat, i32Zero,
                                        data,   i32Zero, len)
                    return! WExpr.StructSet(rav, 0, newDat)
                }, WExpr.Nop, WType.Void)
        // Re-read data (may have changed after grow)
        do! WExpr.ArraySet(WExpr.Cast(WExpr.StructGet(rav, 0, arrRefT), arrNNRefT), len, wVal)
        return! WExpr.StructSet(rav, 1,
            WExpr.Binary(WBinaryOp.Add, len, i32One, WType.I32))
    }

// the eval-Function get's called recursivly, but injected into module

// ─────────────────────────────────────────────────────────────────────────────
// JS Typed Array → WasmGC mapping
// Fable's standard replacements inject these when building result arrays for
// Array.map/init/scan/append/map2/choose/collect on typed (int/float) arrays.
// ─────────────────────────────────────────────────────────────────────────────

/// Map a JS typed array constructor name to (WasmGC element type, zero value).
/// Returns None for unknown names (not a typed array constructor).
let jsTypedArrayElemType (name: string) : (WType * WExpr) option =
    match name with
    | "Int8Array"    | "Uint8Array"
    | "Int16Array"   | "Uint16Array"
    | "Int32Array"   | "Uint32Array"    -> Some(WType.I32, i32Zero)
    | "BigInt64Array"| "BigUint64Array" -> Some(WType.I64, i64Const 0L)
    | "Float32Array"                   -> Some(WType.F32, f32Const 0.0f)
    | "Float64Array"                   -> Some(WType.F64, f64Const 0.0)
    | _                                -> None

/// Recursive entry point. Wraps transformExprCore with a single diagnostic
/// chokepoint: if a non-Unit-typed Fable expression compiles to Nop, that is
/// ALWAYS a compiler bug (the result is used as a value somewhere — a Let
/// binding, an If branch, a struct.new field — and Nop produces nothing on
/// the stack). Reporting it here, at the source expression, is far more
/// actionable than the resulting "expected i32 but nothing on stack" error
/// from wasm-tools three transforms later.
/// Read a module-level value that lives in a wasm global.  It is stored nullable (the initialiser has not run when the
/// global is declared); a non-null reference is cast on read.
let private readGlobal (qn: string) (ty: WType) : WExpr =
    match ty with
    | WType.Ref(idx, false) -> WExpr.Cast(WExpr.GlobalGet(qn, WType.Ref(idx, true)), ty)
    | _ -> WExpr.GlobalGet(qn, ty)

/// A let-bound generic lambda — `let mk id kind f = f (newNode id kind)` has the result of `f` as its type parameter `'a` —
/// is compiled once, so its closure signature needs concrete types.  They are what its applications in `body` state
/// (`mk 1 KLabel (fun n -> …)` returns a `Node`): read off those, the lambda is built with them.  A lambda that is not
/// generic, or whose uses state nothing, is compiled as it is.
let private lambdaInstantiation (ctx: Ctx) (ident: Ident) (value: Fable.Expr) (body: Fable.Expr) : Ctx =
    match value with
    | (Fable.Expr.Lambda _ | Fable.Expr.Delegate _) when not ident.IsMutable && hasGenericParam ident.Type ->
        let mutable bound : Map<string, Fable.Type> = Map.empty
        body
        |> Fable.Transforms.AST.visitFromInsideOut (fun e ->
            match e with
            | Fable.Expr.CurriedApply(Fable.Expr.IdentExpr id, args, resultType, _) when id.Name = ident.Name ->
                let applied = List.foldBack (fun (a: Fable.Expr) acc -> Fable.Type.LambdaType(a.Type, acc)) args resultType
                bound <- unify ident.Type applied bound
            // a lambda of several arguments is a delegate: its uses are plain calls
            | Fable.Expr.Call(Fable.Expr.IdentExpr id, info, resultType, _) when id.Name = ident.Name ->
                bound <- unify ident.Type (Fable.Type.DelegateType(info.Args |> List.map (fun a -> a.Type), resultType)) bound
            | _ -> ()
            e)
        |> ignore
        let fresh = bound |> Map.filter (fun name t -> not (ctx.TypeSubst.ContainsKey name) && not (hasGenericParam t))
        if fresh.IsEmpty then ctx
        else { ctx with TypeSubst = fresh |> Map.fold (fun m name t -> Map.add name (mapTypeKnown ctx t) m) ctx.TypeSubst }
    | _ -> ctx

let rec transformExpr (ctx: Ctx) (expr: Fable.Expr) : WExpr =
    let result = transformExprCore ctx expr
    match result, expr.Type with
    | WExpr.Nop, ty when ty <> Fable.Type.Unit ->
        WasmGc.Core.Diagnostics.nonVoidNop
            ctx.Diagnostics (sprintf "%A" expr) ctx.CurrentFunc expr.Range
    | _ -> ()
    result

and private transformExprCore (ctx: Ctx) (expr: Fable.Expr) : WExpr =
    match expr with
    // ── Emit: integer width casts (byte / sbyte / int16 / uint16 / uint32) ──
    | Fable.Expr.Emit(info, _, _)
          when (match info.CallInfo.Args with
                | [ _ ] -> (NumericCasts.integerCast info.Macro (WExpr.Nop)).IsSome
                | _ -> false) ->
        match info.CallInfo.Args with
        | [ arg ] -> (NumericCasts.integerCast info.Macro (transformExpr ctx arg)).Value
        | _ -> WExpr.Nop
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
                let (arrTypeIdx, ravTypeIdx) = getOrAddResizeArrayTypeFor ctx elemFableType elemWT
                resizeArrayPushInline ctx elemWT arrTypeIdx ravTypeIdx (transformExpr ctx ar) (transformExpr ctx arg)
            | _ -> WExpr.Nop
        | _ -> WExpr.Nop

    // ── Constants ──
    | Value(kind, _) ->
        transformValue ctx kind transformExpr

    // ── Identifier references ─────────────────────────────
    | IdentExpr ident when ctx.BoxedLocals.ContainsKey ident.Name ->
        let inner = ctx.BoxedLocals[ident.Name]
        cellGet (WExpr.LocalGet(ident.Name, WType.Ref(getOrAddRefCellType ctx inner, false))) inner

    | IdentExpr ident ->
        let res = Scope.resolve ctx ctx.CurrentFunc ident.Name
        match res with
        | Scope.Resolution.Local(name, ty)          -> WExpr.LocalGet(name, ty)
        | Scope.Resolution.CapturedVar(name, ty)    -> WExpr.LocalGet(name, ty)
        | Scope.Resolution.Global(qn, ty)           -> readGlobal qn ty
        | Scope.Resolution.ModuleValue(qn, retTy)   ->
            // `let f () = …` is registered WITHOUT parameters (unit params are dropped), i.e. exactly
            // like a module value `let x = …`.  A reference whose Fable type is `unit -> R` is a
            // first-class FUNCTION: wrap it in a closure.  Calling it here ran it eagerly and, for
            // `unit -> unit`, produced no value at all (binding skipped → "uninitialized local").
            match ident.Type with
            | Fable.Type.LambdaType(Fable.Type.Unit, resT) when mapTypeKnown ctx resT = retTy ->
                ClosureBuilder.buildKnownFuncClosure ctx qn [] retTy
            | _ -> WExpr.Call(qn, [], retTy)
        | Scope.Resolution.KnownFunc(qn, ps, retTy) ->
            // First-class function reference.  `ref.func qn` cannot be stored in a closure directly:
            // closure code pointers take `$self` as an extra first parameter, a module function
            // does not.  ClosureBuilder generates a `$self`-taking wrapper (once per function).
            ClosureBuilder.buildKnownFuncClosure ctx qn ps retTy
        | Scope.Resolution.ExternFunc(key, retTy)   -> WExpr.Call(key, [], retTy)
        | Scope.Resolution.Unknown name             ->
            // ── Type-safe unknown-ident fallback ─────────────────────────────────
            // JS typed array names (Int32Array, Float64Array, etc.) are injected by
            // Fable's standard replacements. They have no WasmGC representation.
            // Emit Nop so the CurriedApply Nop-guard suppresses the whole apply.
            // For all other unknowns, use the declared Fable type (not I32 blindly)
            // so the type stack stays consistent if the code is somehow live.
            match jsTypedArrayElemType name with
            | Some _ ->
                // Handled: CurriedApply intercept turns this into ArrayNew.
                // As a bare IdentExpr it should be unreachable, but emit Nop just in case.
                WExpr.Nop
            | None ->
                let declaredTy = mapTypeKnown ctx ident.Type
                WasmGc.Core.Diagnostics.unresolvedIdent
                    ctx.Diagnostics name ctx.CurrentFunc ident.Range
                WExpr.LocalGet(name, declaredTy)

    // ── `let rec f = fun … f …` ──
    // Fable folds a single recursive binding into a plain Let; inside the lambda its own name must be the closure.
    | Let(ident, (Fable.Expr.Lambda _ | Fable.Expr.Delegate _ as value), body)
        when not ident.IsMutable && (WasmGc.Runtime.FreeVars.collectFreeVars Set.empty value).Contains ident.Name ->
        buildLetRecLambdas ctx transformExpr [ ident, value ] body

    // ── Let bindings ──
    | Let(ident, value, body) ->
        let wValue = transformExpr (lambdaInstantiation ctx ident value body) value
        // A non-unit binding whose value produced nothing keeps the local's default and later fails
        // validation as "uninitialized local".  (A plain Nop is already reported by transformExpr.)
        if wValue <> WExpr.Nop && exprWType wValue = WType.Void
           && ident.Type <> Fable.Type.Unit && value.Type <> Fable.Type.Unit then
            WasmGc.Core.Diagnostics.valuelessBinding
                ctx.Diagnostics ident.Name (sprintf "%A" value) ctx.CurrentFunc value.Range
        let declaredTy = mapTypeKnown ctx ident.Type
        // Prefer the actual WExpr type (from the value) over the declared type;
        // this correctly handles Let-bound record/DU values.
        let ty =
            if declaredTy = WType.I32 then
                // Fall back to the inferred type from the value expression;
                // this handles the case where mapTypeKnown doesn't know the type yet.
                let inferredTy = exprWType wValue
                if inferredTy <> WType.I32 && inferredTy <> WType.Void then inferredTy else declaredTy
            else declaredTy
        if ident.IsMutable && FableNormalize.capturedAndAssigned ident.Name body then
            // a mutable local that a closure captures and something assigns lives in a shared cell
            let cellIdx = getOrAddRefCellType ctx ty
            let ctx' = { ctx.WithLocal(ident.Name, WType.Ref(cellIdx, false)) with BoxedLocals = Map.add ident.Name ty ctx.BoxedLocals }
            WExpr.Let(ident.Name, WExpr.StructNew(cellIdx, [ wValue ], WType.Ref(cellIdx, false)), transformExpr ctx' body)
        else
        let ctx' = ctx.WithLocal(ident.Name, ty)
        let wBody = transformExpr ctx' body
        if ident.IsMutable then
            WExpr.LetMut(ident.Name, wValue, wBody)
        else
            WExpr.Let(ident.Name, wValue, wBody)

    // ── Let rec bindings ──────────────────────────────────
    | LetRec(bindings, body) ->
        // Detect mutual-closure pattern: ALL bindings are lambdas/delegates.
        // Sequential lets can't handle mutual calls (dispatch ↔ render in Elmish).
        // We use a ref-cell strategy: allocate a mutable AnyFn slot per binding,
        // build each closure capturing sibling slots, fill slots after closure creation.
        let allAreLambdas =
            bindings |> List.forall (fun (_, v) ->
                match v with Fable.Expr.Lambda _ | Fable.Expr.Delegate _ -> true | _ -> false)

        // One binding is included: a self-recursive local function (`let rec loop i = … loop (i+1)`)
        // previously went down the sequential-let path below, where its own name is not yet in scope
        // inside the lambda body → unbound local → invalid module.
        if allAreLambdas && not bindings.IsEmpty then
            // Delegation to TransformClosures
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
    | Sequential exprs ->
        let wExprs = exprs |> List.map (transformExpr ctx)
        WExpr.Sequence wExprs

    // ── Operations ────────────────────────────────────────
    | Operation(kind, _tags, typ, _range) ->
        // TODO: for better diagnostics, we could match on the operation kind and print more info about it here
        // (match kind with
        //  | Unary(op, _) -> eprintfn "[WasmGc] Unary op=%A mapType=%A in func=%A" op (mapType typ) ctx.CurrentFunc
        //  | _ -> ())
        transformOperation ctx transformExpr kind typ

    // ── Set (mutation) ────────────────────────────────────
    | Fable.Expr.Set(_expr, kind, _typ, value, _range) ->
        match kind with
        | ValueSet ->
            match _expr with
            | Fable.Expr.IdentExpr ident ->
                let wValue = transformExpr ctx value
                match Map.tryFind ident.Name ctx.BoxedLocals with
                | Some inner -> WExpr.StructSet(WExpr.LocalGet(ident.Name, WType.Ref(getOrAddRefCellType ctx inner, false)), 0, wValue)
                | None ->
                match Scope.resolve ctx ctx.CurrentFunc ident.Name with
                | Scope.Resolution.Global(qn, _) -> WExpr.GlobalSet(qn, wValue)
                | _ -> WExpr.Assign(ident.Name, wValue)
            | _ ->
                WExpr.Nop // TODO
        | FieldSet fieldName ->
            // Mutable record field assignment (Phase 3)
            match _expr.Type with
            | Fable.Type.DeclaredType(entRef, _) ->
                match declaredStructIdx ctx _expr.Type with
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
                    | Fable.Type.DeclaredType(e, _) -> isRefCellEntity e.FullName
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
                let (arrTypeIdx, _) = getOrAddResizeArrayTypeFor ctx elemFableType elemT
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

    // ── a property of an interface value (`shape.Bounds`): the getter slot of its vtable ──────────────
    | Fable.Expr.Get(receiver, GetKind.FieldGet fi, typ, _)
          when (match receiver.Type with
                | Fable.Type.DeclaredType(e, _) -> (VT.tryFindMemberSlot ctx e.FullName [ "get_" + fi.Name; fi.Name ]).IsSome
                | _ -> false) ->
        let ifaceName = match receiver.Type with Fable.Type.DeclaredType(e, _) -> e.FullName | _ -> ""
        let slot = (VT.tryFindMemberSlot ctx ifaceName [ "get_" + fi.Name; fi.Name ]).Value
        let vtableTypeIdx, boxTypeIdx, funcTypeIndices, _ = ctx.VTableRegistry.[ifaceName]
        VT.emitCallVirtual ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices slot (transformExpr ctx receiver) [] (mapTypeKnown ctx typ)

    // JS number constants Fable emits for `nan`, `infinity`, `Double.MaxValue`, …
    | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Number" }, GetKind.FieldGet fi, typ, _)
        when (match fi.Name with "NaN" | "POSITIVE_INFINITY" | "NEGATIVE_INFINITY" | "MAX_VALUE" | "MIN_VALUE" | "EPSILON" -> true | _ -> false) ->
        let value =
            match fi.Name with
            | "NaN" -> nan
            | "POSITIVE_INFINITY" -> infinity
            | "NEGATIVE_INFINITY" -> -infinity
            | "MAX_VALUE" -> System.Double.MaxValue
            | "MIN_VALUE" -> System.Double.Epsilon
            | _ -> System.Math.Pow(2.0, -52.0)
        match mapTypeKnown ctx typ with
        | WType.F32 -> WExpr.Const(WConst.F32(float32 value))
        | _ -> WExpr.Const(WConst.F64 value)

    // anonymous record field: the struct is the tuple of the fields in name order
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, typ, _)
        when (match expr.Type with Fable.Type.AnonymousRecordType(names, _, _) -> Array.contains fi.Name names | _ -> false) ->
        let names = match expr.Type with Fable.Type.AnonymousRecordType(names, _, _) -> names | _ -> [||]
        WExpr.StructGet(transformExpr ctx expr, Array.findIndex ((=) fi.Name) names, mapTypeKnown ctx typ)

    // ── ResizeArray<T> — length and element access ────────────────────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, _, _)
          when (fi.Name = "Length" || fi.Name = "length" || fi.Name = "Count" || fi.Name = "count")
            && (match expr.Type with | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) -> true | _ -> false) ->
        // ResizeArray.Count / .Length → struct field 1 (len)
        let elemFableType = match expr.Type with | Fable.Type.Array(t, _) -> t | _ -> Fable.Type.Any
        let elemWT = mapTypeKnown ctx elemFableType
        let (_, ravTypeIdx) = getOrAddResizeArrayTypeFor ctx elemFableType elemWT
        WExpr.StructGet(transformExpr ctx expr, 1, WType.I32)

    | Fable.Expr.Get(expr, GetKind.ExprGet idxExpr, typ, _)
          when (match expr.Type with | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) -> true | _ -> false) ->
        // ResizeArray.[i] → array.get on the struct's data field
        let elemFableType = match expr.Type with | Fable.Type.Array(t, _) -> t | _ -> Fable.Type.Any
        let elemWT = mapTypeKnown ctx elemFableType
        let (arrTypeIdx, ravTypeIdx) = getOrAddResizeArrayTypeFor ctx elemFableType elemWT
        let arrRefT = WType.Ref(arrTypeIdx, true)
        arrayGet (WExpr.Cast(WExpr.StructGet(transformExpr ctx expr, 0, arrRefT), WType.Ref(arrTypeIdx, false)))
                 (transformExpr ctx idxExpr) (mapTypeKnown ctx typ)

    // ── Array length and indexing ──────────────────────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, _, _)
          when (fi.Name = "Length" || fi.Name = "length")
            && (match expr.Type with | Fable.Type.Array _ -> true | _ -> false) ->
        arrayLen(transformExpr ctx expr)

    | Fable.Expr.Get(expr, GetKind.ExprGet idxExpr, typ, _)
          when (match expr.Type with | Fable.Type.Array _ -> true | _ -> false) ->
        let wArr = transformExpr ctx expr
        let wIdx = transformExpr ctx idxExpr
        let elemT = mapTypeKnown ctx typ
        arrayGet wArr wIdx elemT

    // ── String operations (length, char indexing) ─────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fi, _, _)
          when expr.Type = Fable.Type.String && (fi.Name = "length" || fi.Name = "Length") ->
        arrayLen(transformExpr ctx expr)

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
                | Fable.Type.DeclaredType(e, _) -> isRefCellEntity e.FullName
                | _ -> false) ->
        let wObj = transformExpr ctx expr
        let innerWType = mapTypeKnown ctx typ
        let _refTypeIdx = getOrAddRefCellType ctx innerWType  // ensure registered
        cellGet wObj innerWType

    // ── Record/struct field access (Phase 3) ────────────
    | Fable.Expr.Get(expr, GetKind.FieldGet fieldInfo, typ, _) ->
        let wExpr = transformExpr ctx expr
        match expr.Type with
        | Fable.Type.DeclaredType(entRef, _) ->
            match declaredStructIdx ctx expr.Type with
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
                let mapped = mapTypeKnown ctx typ
                // a field stored nullable (a class field) is read back as the non-null type the program declared
                match ctx.TypeDefs.[typeIdx].Def with
                | WTypeDef.Struct(fields, _) when fieldIdx < fields.Length ->
                    match fields.[fieldIdx].Type, mapped with
                    | WType.Ref(i, true), WType.Ref(j, false) when i = j ->
                        WExpr.Cast(WExpr.StructGet(wSelf, fieldIdx, fields.[fieldIdx].Type), mapped)
                    | _ -> WExpr.StructGet(wSelf, fieldIdx, mapped)
                | _ -> WExpr.StructGet(wSelf, fieldIdx, mapped)
            | None -> i32Zero
        | _ -> i32Zero

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
            i32Zero

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
        transformTest ctx transformExpr expr kind

    // ── Decision tree (pattern matching) ──────────────────
    | Fable.Expr.DecisionTree(matchExpr, targets) ->
        transformDecisionTree ctx transformExpr matchExpr targets

    | Fable.Expr.DecisionTreeSuccess(targetIdx, boundValues, typ) ->
        // This should be handled within transformDecisionTree
        let wArgs = boundValues |> List.map (transformExpr ctx)
        let ty = mapTypeKnown ctx typ
        WExpr.JoinApply($"$target_{!ctx.TargetBase + targetIdx}", wArgs, ty)

    // ── If/Then/Else ──────────────────────────────────────
    | IfThenElse(guard, thenExpr, elseExpr, _) ->
        let wGuard = transformExpr ctx guard
        let wThen = transformExpr ctx thenExpr
        let wElse = transformExpr ctx elseExpr
        let ty = mapTypeKnown ctx thenExpr.Type
        buildIf wGuard wThen wElse ty

    // ── Loops ──
    // ── While loop ────────────────────────────────────────
    | WhileLoop(guard, body, _) ->
        buildWhile (transformExpr ctx guard) (transformExpr ctx body)

    // ── For loop ────────────────────────────────────────
    | ForLoop(ident, start, limit, body, isUp, _range) ->
        let wStart = transformExpr ctx start
        let wLimit = transformExpr ctx limit
        let ctx'   = ctx.WithLocal(ident.Name, WType.I32)
        let wBody  = transformExpr ctx' body
        buildFor ctx ident wStart wLimit wBody isUp

    // ── Function calls ────────────────────────────────────
    // ── JS Typed Array constructors in Call expressions ────
    // Handles: Call(IdentExpr "Int32Array", [size], typ)
    // These are JS typed array constructors with no WasmGC equivalent.
    // We translate to ArrayNew(elemTypeIdx, size, zeroVal, arrRefTy).
    | Call(Fable.Expr.IdentExpr ctorIdent, info, typ, _) 
        when jsTypedArrayElemType ctorIdent.Name |> Option.isSome ->
        let elemWTy, zeroVal =
            match jsTypedArrayElemType ctorIdent.Name with
            | Some (et, zv) -> et, zv
            | None -> WType.I32, i32Zero // unreachable
        let wSize =
            info.Args |> List.tryHead
            |> Option.map (transformExpr ctx)
            |> Option.defaultValue i32Zero
        let arrTypeIdx = if packedBytes && ctorIdent.Name = "Uint8Array" then getOrAddArrayType ctx WType.I8 else getOrAddArrayType ctx elemWTy
        WExpr.ArrayNew(arrTypeIdx, wSize, zeroVal, WType.Ref(arrTypeIdx, false))

    | Call(callee, info, typ, _) ->
        // Delegation to TransformDispatch
        transformCall ctx transformExpr callee info typ

    // ── CurriedApply (closure call) ───────────────────────

    // ── JS Typed Array constructors (must run BEFORE general CurriedApply) ──
    // Fable's standard Replacements.fs rewrites Array.map/init/scan/append/map2
    // on int/float arrays into: CurriedApply(IdentExpr "Int32Array", [size])
    // These are JS typed array constructors with no WasmGC equivalent.
    // We translate to ArrayNew(elemTypeIdx, size, zeroVal, arrRefTy).
    //
    // Affected: any op that allocates a fixed-size result array before filling it.
    // This case MUST precede the general CurriedApply path — otherwise the
    // Unknown ident fallback emits LocalGet("Int32Array", I32) as the closure,
    // causing "expected ref $type, found i32" at WASM binary validation time.
    | Fable.Expr.CurriedApply(Fable.Expr.IdentExpr ctorIdent, ctorArgs, _, _)
        when jsTypedArrayElemType ctorIdent.Name |> Option.isSome ->
        let elemWTy, zeroVal =
            match jsTypedArrayElemType ctorIdent.Name with
            | Some (et, zv) -> et, zv
            | None -> WType.I32, i32Zero // unreachable
        let wSize =
            ctorArgs |> List.tryHead
            |> Option.map (transformExpr ctx)
            |> Option.defaultValue (i32Zero)
        let arrTypeIdx = if packedBytes && ctorIdent.Name = "Uint8Array" then getOrAddArrayType ctx WType.I8 else getOrAddArrayType ctx elemWTy
        WExpr.ArrayNew(arrTypeIdx, wSize, zeroVal, WType.Ref(arrTypeIdx, false))

    // Special case: sprintf/printfn — Fable emits:
    //   CurriedApply(Call(Import("toText"|"toConsole"), [TypeCast(Call(Import("printf"), [StringConst fmt]))]), formatArgs)
    // We intercept this and expand the format string inline.
    | Fable.Expr.CurriedApply(callee, args, typ, _) ->
        let sprintfFmt, args =
            match callee with
            | Q.PrintfApply(sel, fmt, applied) -> Some(sel, fmt), applied @ args
            | _ -> None, args
        match sprintfFmt with
        | Some(sel, fmt) ->
            let strRef = WType.Ref(StringTypeIdx, false)
            let emitLit (s: string) =
                WExpr.ArrayNewFixed(StringTypeIdx,
                    s |> Seq.map (fun c -> WExpr.Const(WConst.I32(int c))) |> Seq.toList, strRef)
            let partsList, specsList = parseFormatSpecs fmt
            let nSpecs = List.length specsList
            let holeParts =
                [ for k in 0 .. nSpecs - 1 do
                    yield emitLit partsList.[k]
                    if k < args.Length then
                        yield formatField ctx specsList.[k] (Q.isUnsignedInt args.[k].Type) (transformExpr ctx args.[k]) ]
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

        // The apply node (func type + ClosureBase) is built by ClosureBuilder.applyClosure:
        //  * the func type comes from the callee's DECLARED function type — the same source the
        //    lifted lambda's signature was built from — not from the types of the argument
        //    expressions (a closure struct passed where `ref $AnyFn` is declared produced a
        //    different func type and an invalid call_ref);
        //  * void (unit) arguments are dropped consistently on both sides;
        //  * the ClosureBase is created on demand, so closureTypeIdx is never 0.
        ClosureBuilder.applyClosure ctx callee.Type wClosure (args |> List.map (fun a -> a.Type)) wArgsAll ty

    // ── Lambda ──
    | Lambda(arg, body, name) ->
        // Delegation to TransformClosures
        buildClosure ctx transformExpr [arg] body name
        
    | Delegate(args, body, name, _) ->
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
                WExpr.Let(ident.Name, globalGet "$fsharp_exn_carrier" WType.AnyRef, wHandlerExpr)
            ident.Name, wHandlerWithCarrier)
        let wFinally = finalizer |> Option.map (transformExpr ctx)
        let ty = mapType body.Type
        WExpr.TryCatch(wBody, wCatch, wFinally, ty)

    // | Fable.Extended(Fable.Curry(expr, arity), typeInfo) ->
    //     // 1. Transform the underlying function expression
    //     let transformedInner = transformExpr ctx expr
        
    //     // 2. Generate a WasmGC closure allocation (struct.new) 
    //     // wrapping the function reference with an initial environment payload
    //     emitWasmClosureCreation ctx transformedInner arity typeInfo

    // | Fable.CurriedApply(applied, args, typeInfo) ->
    //     // 1. Transform the closure identifier/expression
    //     let transformedApplied = transformExpr ctx applied
        
    //     // 2. Transform the arguments being applied
    //     let transformedArgs = args |> List.map (transformExpr ctx)
        
    //     // 3. Emit a closure invocation sequence instead of falling back to Nop
    //     emitWasmClosureCall ctx transformedApplied transformedArgs typeInfo

    // ── Extended expressions ──────────────────────────────
    | Fable.Expr.Extended(kind, _range) ->
        match kind with
        | Fable.ExtendedSet.Throw(Some expr, _) ->
            let wExpr = transformExpr ctx expr
            // WasmGC exception model: store the object in the $fsharp_exn_carrier
            // global BEFORE throwing the zero-payload $fsharp_exn tag.
            // The catch_all handler reads the carrier back to inspect the exception.
            // This must be a sequence: [carrier := obj; throw $fsharp_exn]
            let wExprTy = exprWType wExpr
            match wExprTy with
            | WType.Void ->
                // Already a Nop/unit expr — the exception construction failed upstream.
                // Emit a bare throw so the control flow is at least correct.
                WExpr.Throw(WExpr.Nop)
            | _ ->
                // $fsharp_exn_carrier is anyref — any ref value is assignment-compatible.
                // (WasmGC: ref $T <: anyref for all concrete types T.)
                WExpr.Sequence [
                    WExpr.GlobalSet("$fsharp_exn_carrier", wExpr)
                    WExpr.Throw(WExpr.Nop)
                ]
        | _ -> WExpr.Nop

    // ── ObjectExpr: IComparer-like interface objects ───────
    // Fable emits makeComparer as ObjectExpr { Compare = fun x y -> compare x y }.
    // We extract the Compare (or Equals/GetHashCode) member body and translate it.
    // For IComparer, the body is a Delegate — buildClosure handles it and returns
    // a (ref $AnyFn) closure that can be stored as MapHandle/SetHandle.Cmp.
    | Fable.Expr.ObjectExpr(members, typ, baseCall) ->
        // an object expression implementing an interface of the vtable system (`{ new IFoo with … }`)
        match ObjectExprBuilder.tryBuild ctx transformExpr members typ baseCall with
        | Some boxed -> boxed
        | None ->
            // Prefer "Compare" for IComparer, fall back to first member for other objects
            let target =
                members |> List.tryFind (fun m -> m.Name = "Compare")
                |> Option.orElse (List.tryHead members)
            match target with
            | Some m -> transformExpr ctx m.Body
            | None -> WExpr.Nop

    // ── Type cast ─────────────────────────────────────────
    | TypeCast(innerExpr, targetTy) ->
        let w = transformExpr ctx innerExpr
        match innerExpr.Type, targetTy with
        // uint32 → float / int64: zero-extend through i64.  A signed conversion would read bit 31 as a sign.
        | Fable.Type.Number(NumberKind.UInt32, _), Fable.Type.Number((NumberKind.Float32 | NumberKind.Float64), _)
            when exprWType w = WType.I32 ->
            WExpr.Unary(WUnaryOp.ConvertI64S, WExpr.Unary(WUnaryOp.ExtendI32U, w, WType.I64), mapTypeKnown ctx targetTy)
        | Fable.Type.Number(NumberKind.UInt32, _), Fable.Type.Number((NumberKind.Int64 | NumberKind.UInt64), _)
            when exprWType w = WType.I32 ->
            WExpr.Unary(WUnaryOp.ExtendI32U, w, WType.I64)
        // char → string
        | Fable.Type.Char, Fable.Type.String when exprWType w = WType.I32 -> charToString w
        // `arr :> seq<_>`: a seq is a list
        | Fable.Type.Array _, target when isSeqType target -> coerceToSeq ctx innerExpr.Type w
        // `d :> seq<_>` of a portable collection (Dictionary, HashSet, Stack, Queue): its `ToSeqList()` member builds the list
        | Fable.Type.DeclaredType(e, _), target when isSeqType target && e.FullName.StartsWith "System.Collections.Generic." ->
            let selector = e.FullName.Substring(e.FullName.LastIndexOf '.' + 1).Replace('`', '$') + "__ToSeqList"
            match trySpecializeCall ctx transformExpr selector (Fable.CallInfo.Create(thisArg = innerExpr, args = [ Fable.Expr.Value(Fable.ValueKind.UnitConstant, None) ])) targetTy with
            | Some call -> call
            | None -> w
        | _, target when isSeqType target -> w
        | _ -> buildTypeCast ctx w targetTy

    // ── Import as value ─────────────────────────────────────────
    | Fable.Expr.Import(info, typ, _) ->
        let ty = mapTypeKnown ctx typ
        let pLow = info.Path.ToLowerInvariant()
        let isLocalFile = pLow.EndsWith(".fs") || pLow.EndsWith(".fsi")
        let isFableLib = pLow.Contains("fable-library")
        if not isLocalFile && not isFableLib && info.Selector <> "" then
            let callName = ctx.RegisterExternFunc(info.Path, info.Selector, [], ty) 
            WExpr.FuncRef callName
        else
            let stem = System.IO.Path.GetFileNameWithoutExtension(info.Path)
            let actualName =
                match Map.tryFind (stem, info.Selector) ctx.KnownFuncsByPath with
                | Some qualName -> qualName
                | None -> info.Selector
            // a module VALUE of another file (`let nil = El 0`) is a nullary function here: reading it is a call;
            // only a value of function type (`let f () = …` passed along) is a function reference
            let isFunctionValue = (match typ with Fable.Type.LambdaType _ | Fable.Type.DelegateType _ -> true | _ -> false)
            match ctx.MutableGlobals.TryGetValue actualName, Map.tryFind actualName ctx.KnownFuncs with
            | (true, globalTy), _ -> readGlobal actualName globalTy          // a value that lives in a global
            | _, Some([], retTy) when not isFunctionValue -> WExpr.Call(actualName, [], retTy)
            | _ -> WExpr.FuncRef actualName

    | _ -> 
        eprintfn "[WasmGc] FATAL/WARNING: Unhandled Fable AST expression: %A" expr
        WExpr.Nop // for Set, Get, Test etc


