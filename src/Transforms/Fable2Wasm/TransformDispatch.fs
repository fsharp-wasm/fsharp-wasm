module WasmGc.Transforms.TransformDispatch

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST

open WasmGc.Builder.Core
open WasmGc.Runtime.Locals // TODO: should they be renamed to Builder
open WasmGc.Runtime.Types
open WasmGc.Runtime.Equality
open WasmGc.Transforms.ArrayReplacements
open WasmGc.Transforms.BigIntMap
open WasmGc.Transforms.OptionResultTransforms
open WasmGc.Transforms.ListTransforms
open WasmGc.Transforms.SeqFusion
open WasmGc.Transforms.ListOps
open WasmGc.Transforms.MathMap

open WasmGc.Transforms.TransformHelpers

module RT = WasmGc.Runtime.Runtime
module VT = WasmGc.Runtime.VTable

// ─────────────────────────────────────────────────────────────────
// Sprint 5: Monomorphization — demand-driven generic specialization
// ─────────────────────────────────────────────────────────────────

/// The constructor function of a class: allocate its struct (parameters that name a field go in directly), then run
/// Fable's constructor body on the new instance — that body is what initialises the fields (`let mutable n = start * 2`
/// is `this.n <- start * 2`).  `instTy` is the struct type of the instance (one per instantiation for a generic class).
let buildClassCtor
        (eval: Ctx -> Expr -> WExpr)
        (ctx: Ctx)
        (ctorDecl: MemberDecl)
        (instTy: WType)
        (ctorParams: (string * WType) list)
        (name: string)
        : WFuncDecl =
    let typeIdx = match instTy with WType.Ref(i, _) -> i | _ -> 0
    let fieldDefs = match ctx.TypeDefs.[typeIdx].Def with WTypeDef.Struct(fs, _) -> fs | _ -> []
    let fieldValues =
        fieldDefs |> List.map (fun fd ->
            match ctorParams |> List.tryFind (fun (n, _) -> n = fd.Name) with
            | Some(n, t) -> WExpr.LocalGet(n, t)
            | None ->
                match fd.Type with
                | WType.Ref(_, _) -> WExpr.Const(WConst.Null fd.Type)
                | WType.AnyRef -> WExpr.Const(WConst.Null WType.AnyRef)
                | WType.I64 -> WExpr.Const(WConst.I64 0L)
                | WType.F64 -> WExpr.Const(WConst.F64 0.0)
                | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
                | _ -> WExpr.Const(WConst.I32 0))
    let allocate = WExpr.StructNew(typeIdx, fieldValues, instTy)
    let bodyCtx = ctorParams |> List.fold (fun (c: Ctx) (n, t) -> c.WithLocal(n, t)) (ctx.WithLocal("$this", instTy))
    // the base-constructor call (an empty object expression) has no effect here
    let initExpr =
        match ctorDecl.Body with
        | Sequential(ObjectExpr _ :: rest) -> Fable.Expr.Sequential rest
        | b -> b
    let init = eval bodyCtx initExpr
    let body =
        if init = WExpr.Nop then allocate
        else WExpr.Let("$this", allocate, WExpr.Sequence [ init; WExpr.LocalGet("$this", instTy) ])
    { Name = name; Params = ctorParams; Result = instTy; Locals = []; Body = body; Exported = false }

/// Bind the type parameters of `declared` against the types `actual` of a call site (`'T` against `string`, …).
/// Structural; a shape that does not match binds nothing.  The first binding of a name wins.
let rec unify (declared: Type) (actual: Type) (acc: Map<string, Type>) : Map<string, Type> =
    match declared, actual with
    | Type.GenericParam(name, _, _), _ -> if Map.containsKey name acc then acc else Map.add name actual acc
    | Type.List d, Type.List a -> unify d a acc
    | Type.Option(d, _), Type.Option(a, _) -> unify d a acc
    | Type.Array(d, _), Type.Array(a, _) -> unify d a acc
    | Type.Tuple(ds, _), Type.Tuple(xs, _) when ds.Length = xs.Length -> List.fold2 (fun m d a -> unify d a m) acc ds xs
    | Type.LambdaType(d1, d2), Type.LambdaType(a1, a2) -> unify d2 a2 (unify d1 a1 acc)
    | Type.DelegateType(ds, dr), Type.DelegateType(xs, ar) when ds.Length = xs.Length ->
        unify dr ar (List.fold2 (fun m d a -> unify d a m) acc ds xs)
    | Type.DeclaredType(de, dargs), Type.DeclaredType(ae, aargs) when de.FullName = ae.FullName && dargs.Length = aargs.Length ->
        List.fold2 (fun m d a -> unify d a m) acc dargs aargs
    | _ -> acc

let rec hasGenericParam (t: Type) =
    match t with
    | Type.GenericParam _ -> true
    | Type.List e | Type.Option(e, _) | Type.Array(e, _) -> hasGenericParam e
    | Type.Tuple(ts, _) -> List.exists hasGenericParam ts
    | Type.LambdaType(a, r) -> hasGenericParam a || hasGenericParam r
    | Type.DelegateType(ts, r) -> List.exists hasGenericParam ts || hasGenericParam r
    | Type.DeclaredType(_, ts) -> List.exists hasGenericParam ts
    | _ -> false

/// The type arguments of a call to a generic function that the call does not state: read them off the types at the call
/// site.  A member of a generic class (`Stack<'T>.Push`) has no type arguments of its own — `'T` is the class's — so
/// the receiver and arguments are what say it.  `[]` when nothing generic is bound.
let private inferTypeArgs (memberDecl: MemberDecl) (info: CallInfo) (resultFableType: Type) : (string * Type) list =
    let actuals = (info.ThisArg |> Option.toList |> List.map (fun t -> t.Type)) @ (info.Args |> List.map (fun a -> a.Type))
    let declared = memberDecl.Args |> List.map (fun a -> a.Type)
    // a declared `unit` parameter (`ToSeqList()`) or an omitted optional one has no actual: the leading pairs line up
    let n = min actuals.Length declared.Length
    let fromArgs = List.fold2 (fun m d a -> unify d a m) Map.empty (List.truncate n declared) (List.truncate n actuals)
    unify memberDecl.Body.Type resultFableType fromArgs |> Map.toList

/// Try to specialize a call to a generic function (or a member / constructor of a generic class).
/// Returns Some(WExpr.Call to the specialized version) or None if not applicable.
/// None means: fall through to the regular (unspecialized) call handling.
let trySpecializeCall
    (ctx: Ctx)
    (eval: Ctx -> Expr -> WExpr)
    (funcName: string)
    (info: CallInfo)
    (resultFableType: Type)
    : WExpr option =

    // 1. Is this function body registered (i.e., defined in-module)?
    let isCtor, registered =
        match ctx.GenericCtors.TryGetValue funcName with
        | true, (declCom, classDecl) -> true, Some(declCom, classDecl.Constructor.Value :> obj)
        | _ ->
            match ctx.GenericFuncRegistry.TryGetValue funcName with
            | true, entry -> false, Some entry
            | _ -> false, None
    if System.Environment.GetEnvironmentVariable "WASMGC_TRACE_SPEC" = "1" then
        eprintfn "[spec] %s registered=%b ctor=%b ctors=%d funcs=%d" funcName registered.IsSome isCtor ctx.GenericCtors.Count ctx.GenericFuncRegistry.Count
    match registered with
    | None -> None
    | Some(declCom, regObj) ->
        let memberDecl = regObj :?> MemberDecl

        // 2. The type arguments: stated by the call, or read off its types.
        //    A generic class's constructor takes them from the instance type it returns.
        let stated : (string * WType) list option =
            if info.GenericArgs.IsEmpty then None
            else
                // 3. The call states them: names in declaration order via the declaring compiler.
                match memberDecl.MemberRef with
                | MemberRef(entityRef, memberRefInfo) ->
                    match declCom.TryGetEntity(entityRef) with
                    | Some entity ->
                        match entity.TryFindMember(memberRefInfo) with
                        | Some mfv ->
                            let names = mfv.GenericParameters |> List.map (fun p -> p.Name)
                            let wTypeArgs = info.GenericArgs |> List.map (mapTypeKnown ctx)
                            if names.Length = wTypeArgs.Length then Some(List.zip names wTypeArgs) else None
                        | None -> None
                    | None -> None
                | GeneratedMemberRef _ -> None
        // … or, when it does not (or states a class's arguments, which the member's own parameter list does not name),
        // the types at the call site say them
        let named : (string * WType) list option =
            match stated with
            | Some _ -> stated
            | None ->
                let isGeneric =
                    isCtor
                    || (memberDecl.Args |> List.exists (fun a -> hasGenericParam a.Type) || hasGenericParam memberDecl.Body.Type)
                if not isGeneric then None
                else
                    let declType =
                        if isCtor then
                            let _, classDecl = ctx.GenericCtors.[funcName]
                            let ent = (declCom.TryGetEntity classDecl.Entity).Value
                            Type.DeclaredType(classDecl.Entity, ent.GenericParameters |> List.map (fun p -> Type.GenericParam(p.Name, false, [])))
                        else memberDecl.Body.Type
                    let inferred =
                        if isCtor then unify declType resultFableType Map.empty |> Map.toList
                        else inferTypeArgs memberDecl info resultFableType
                    // a binding to a type parameter that nothing here resolves (`'K` for `'K` outside any specialisation) says nothing;
                    // inside a specialisation (one member of a generic class calling another) TypeSubst resolves it
                    let known = inferred |> List.filter (fun (_, t) -> match t with Type.GenericParam(n, _, _) -> ctx.TypeSubst.ContainsKey n | _ -> true)
                    if known.IsEmpty then None
                    else Some(known |> List.map (fun (n, t) -> n, mapTypeKnown ctx t))
        if System.Environment.GetEnvironmentVariable "WASMGC_TRACE_SPEC" = "1" then
            eprintfn "[spec]   → %s named=%A resultType=%A" funcName (named |> Option.map (List.map fst)) resultFableType
        match named with
        | None -> None
        | Some named ->
        let paramNames, wTypeArgs = List.unzip named

        // 4. Compute the mangled name for this specialization.
        let mangledName = mangleGenericName funcName wTypeArgs

        // 5. Pre-evaluate call arguments under the OUTER (non-specialized) ctx.
        //    An instance member's receiver comes in `ThisArg`; the compiled function takes it as its first parameter.
        //    Fable drops the trailing `None`s of omitted optional arguments (`HashSet<int>()` for `?items`): they are filled in.
        let isOptional (a: Ident) = match a.Type with Type.Option _ -> true | _ -> false
        let omittedOptional (given: int) = memberDecl.Args |> List.skip (min given memberDecl.Args.Length) |> List.forall isOptional
        let wArgs =
            let receiver =
                match info.ThisArg with
                | Some t when memberDecl.Args.Length = info.Args.Length + 1
                              || (memberDecl.Args.Length > info.Args.Length + 1 && omittedOptional (info.Args.Length + 1)) -> [ eval ctx t ]
                | _ -> []
            let given = receiver @ (info.Args |> List.map (eval ctx))
            let substCtx = { ctx with TypeSubst = List.zip paramNames wTypeArgs |> Map.ofList }
            let missing = memberDecl.Args |> List.skip (min given.Length memberDecl.Args.Length)
            if not missing.IsEmpty && missing |> List.forall isOptional then
                given @ (missing |> List.map (fun a -> WExpr.Const(WConst.Null(mapTypeKnown substCtx a.Type))))
            else given
        let retTy = mapTypeKnown ctx resultFableType

        // 6. Already emitted? Just emit a call — body is already in ctx.Functions.
        if ctx.MonoCache.ContainsKey(mangledName) then
            Some(WExpr.Call(mangledName, wArgs, retTy))
        else
            // 7. Register sentinel early to handle recursive specializations.
            ctx.MonoCache.[mangledName] <- mangledName

            // 8. Build TypeSubst: generic param name → concrete WType.
            let subst = List.zip paramNames wTypeArgs |> Map.ofList

            // 9. Build specialized context: set substitution + populate arg locals.
            //    Override Compiler with the declaring file's compiler so entity lookups
            //    within the body resolve against the right compilation unit.
            let ctx' = { ctx with TypeSubst = subst; CurrentFunc = Some mangledName; Compiler = declCom }
            let ctx' =
                (ctx', memberDecl.Args)
                ||> List.fold (fun c a -> c.WithLocal(a.Name, mapTypeKnown c a.Type))

            if isCtor then
                // the constructor of one instantiation: allocate its struct, run the field initialisers
                let _, classDecl = ctx.GenericCtors.[funcName]
                let ent = (declCom.TryGetEntity classDecl.Entity).Value
                let instType = Type.DeclaredType(classDecl.Entity, ent.GenericParameters |> List.map (fun p -> Type.GenericParam(p.Name, false, [])))
                let instTy = mapTypeKnown ctx' instType
                let ctorParams =
                    memberDecl.Args |> List.choose (fun a ->
                        let ty = mapTypeKnown ctx' a.Type
                        if ty = WType.Void then None else Some(a.Name, ty))
                let ctorFunc = buildClassCtor eval ctx' memberDecl instTy ctorParams mangledName
                ctx.Functions.Add(ctorFunc |> resolveLocals)
                Some(WExpr.Call(mangledName, wArgs, instTy))
            else
            // 10. Translate the specialized function body.
            let retTy' = mapResultTypeKnown ctx' memberDecl.Body.Type
            let wBody = eval ctx' memberDecl.Body

            // 11. Build params list (filter out unit/void).
            let funcParams =
                memberDecl.Args
                |> List.choose (fun a ->
                    let ty = mapTypeKnown ctx' a.Type
                    if ty = WType.Void then None else Some(a.Name, ty))

            // 12. Emit the specialized WFuncDecl.
            let func : WFuncDecl =
                {   Name = mangledName
                    Params = funcParams
                    Result = retTy'
                    Locals = []
                    Body = wBody
                    Exported = false }
            ctx.Functions.Add(func |> resolveLocals)
            Some(WExpr.Call(mangledName, wArgs, retTy'))

/// `String.Join(sep, xs)` with non-string elements: each element is converted first (`string x`).
let private stringifyItems (ctx: Ctx) (itemsType: Fable.Type) (items: WExpr) : WExpr =
    let isString (t: Fable.Type) = (t = Fable.Type.String)
    // `String.Join(sep, xs)` types its argument as seq<'T>; the value itself is a list or an array
    let itemsType =
        match itemsType, exprWType items with
        | Fable.Type.DeclaredType(_, [ et ]), WType.Ref(idx, _) when idx = ListBaseTypeIdx -> Fable.Type.List et
        | t, _ -> t
    match itemsType with
    | Fable.Type.List et when not (isString et) ->
        match WasmGc.Runtime.LoopHelpers.tryListTypeInfoFromElemType ctx et, WasmGc.Runtime.LoopHelpers.tryListTypeInfoFromElemType ctx Fable.Type.String with
        | Some(elemWT, elemCons), Some(strWT, strCons) ->
            WasmGc.Patterns.ListPatterns.listMap (LabelGen "jn") (WasmGc.Patterns.ListShape.mkListShape elemWT elemCons) (WasmGc.Patterns.ListShape.mkListShape strWT strCons) items (primitiveToString ctx et)
        | _ -> items
    | Fable.Type.Array(et, _) when not (isString et) ->
        let elemWT, strWT = mapTypeKnown ctx et, mapTypeKnown ctx Fable.Type.String
        let a = WasmGc.Patterns.ArrayOps.mkArrayShape elemWT (getOrAddArrayType ctx elemWT)
        let ra = WasmGc.Patterns.ArrayOps.mkArrayShape strWT (getOrAddArrayType ctx strWT)
        WasmGc.Patterns.ArrayOps.arrayMap (LabelGen "jn") a ra items (primitiveToString ctx et)
    | _ -> items

/// Does an import path point into the core library?  The path is relative to the importing file ("./Set.fs" inside the
/// library, "../core/FSharp.Wasm.Core/Collections/Set.fs" from the program), so it is resolved first.
let private isCoreLibraryPath (ctx: Ctx) (path: string) : bool =
    let resolved =
        try System.IO.Path.GetFullPath(System.IO.Path.Combine(System.IO.Path.GetDirectoryName ctx.Compiler.CurrentFile, path))
        with _ -> path
    isCoreLibraryFile ctx.Compiler resolved

/// Behandelt String, Math und Import Calls
let dispatchImportCall (ctx: Ctx) (eval: Ctx -> Expr -> WExpr) (importInfo: ImportInfo) (info: CallInfo) (typ: Type) (wArgs: WExpr list) : WExpr =
    let ty = mapTypeKnown ctx typ
    let path = importInfo.Path
    let importStem = System.IO.Path.GetFileNameWithoutExtension(importInfo.Path)
    // A function of the compiled program (or of a referenced library such as a runtime) that happens to be named like
    // an F# core function — `append`, `iter`, `clear`, … — is that function, not the core one: the replacements below
    // are matched on the selector alone, so a user function must not reach them.
    let isUserFunc =
        path.ToLowerInvariant().EndsWith ".fs" && not (isCoreLibraryPath ctx path)
        && (Map.containsKey importInfo.Selector ctx.KnownFuncs || ctx.GenericFuncRegistry.ContainsKey importInfo.Selector)
    let sel = if isUserFunc then "$user" else importInfo.Selector
    let r =
        tryFirst [
            // ── Map/Set module: must come first to prevent List combinators matching Set/Map DeclaredTypes ──
            // String.replicate must not fall into the List.replicate handler below
            fun () ->
                match importStem, sel, wArgs with
                | "String", "replicate", [ count; str ] ->
                    Some(WExpr.Call(ctx.UseHelper "$strRepeat", [ str; count ], WType.Ref(StringTypeIdx, false)))
                | _ -> None
            fun () -> tryBigIntInline ctx importStem sel wArgs (info.Args |> List.exists (fun a -> WasmGc.Util.FableQuery.isUnsignedInt a.Type) || WasmGc.Util.FableQuery.isUnsignedInt typ)
            fun () -> ResizeArrayOps.tryImport   eval ctx importStem sel info.Args typ
            fun () -> tryMapInline               ctx importStem sel wArgs
            fun () -> trySetInline               ctx importStem sel wArgs
            // ── List combinators ────────────────────────────────────────────────────
            fun () -> tryListFoldInline           eval ctx sel info.Args
            fun () -> tryListFoldBackInline       eval ctx sel info.Args typ
            fun () -> tryListMapInline            eval ctx sel info.Args typ
            fun () -> tryListIndexedInline        eval ctx sel info.Args typ
            fun () -> tryListCollectInline        eval ctx sel info.Args typ
            fun () -> tryListChooseInline         eval ctx sel info.Args typ
            fun () -> tryListInitReplicateInline  eval ctx sel info.Args typ
            fun () -> tryListTakeSkipSortInline   eval ctx sel info.Args typ
            fun () -> tryListSumByInline          eval ctx sel info.Args typ
            fun () -> tryListMinMaxByInline       eval ctx sel info.Args
            fun () -> tryListFilterInline         eval ctx sel info.Args
            fun () -> tryListIterInline           eval ctx sel info.Args
            fun () -> tryListExistsForAllInline   eval ctx sel info.Args
            fun () -> tryListUnzipInline          eval ctx sel info.Args typ
            fun () -> tryListPairwiseInline       eval ctx sel info.Args typ
            fun () -> tryListWindowedInline       eval ctx sel info.Args
            fun () -> tryListCountByInline        eval ctx sel info.Args typ
            fun () -> tryListGroupByInline        eval ctx sel info.Args typ
            fun () -> tryListDistinctInline       eval ctx sel info.Args typ
            fun () -> tryListDistinctByInline     eval ctx sel info.Args typ
            fun () -> tryOptionInline             eval ctx sel info.Args ty
            fun () -> tryResultInline             eval ctx sel info.Args ty
            // ── Array module primitives ────────────────────────────────────────────
            fun () -> tryArrayInline              eval ctx sel info.Args wArgs typ
            // ── List/Option primitives ─────────────────────────────────────────────
            fun () -> tryListPrimitiveInline      ctx sel wArgs ty info.Args
            fun () -> tryListTryHeadInline        eval ctx sel wArgs ty info.Args
            fun () -> tryListFindIndexInline      eval ctx sel info.Args ty
        ]
    match r with
    | Some result -> result
    | None ->
    match sel, wArgs, ty with
    // ── Structural equality: Fable compiles record/DU/tuple `=` as Util.equals/equalArrays ──
    | ("equals" | "op_Equality" | "equalArrays"), [a; b], WType.I32
    | "equalsWith", [_; a; b], WType.I32 ->
        structuralEquals ctx a b
    // ── out / byref argument of a mutable local (`d.TryGetValue(k, &v)`): Fable passes `FSharpRef(fun () -> v, fun x -> v <- x)`.
    //    `v` is captured and assigned, so it already lives in a cell (BoxedLocals) — and the cell is the byref ──
    | "FSharpRef", [ _; _ ], _
        when (match info.Args with
              | [ (Fable.Lambda(_, Fable.IdentExpr id, _) | Fable.Delegate(_, Fable.IdentExpr id, _, _)); _ ] -> ctx.BoxedLocals.ContainsKey id.Name
              | _ -> false) ->
        match info.Args with
        | (Fable.Lambda(_, Fable.IdentExpr id, _) | Fable.Delegate(_, Fable.IdentExpr id, _, _)) :: _ ->
            WExpr.LocalGet(id.Name, WType.Ref(getOrAddRefCellType ctx ctx.BoxedLocals[id.Name], false))
        | _ -> WExpr.Nop
    // ── hashing: `hash x` and the Dictionary / HashSet key hash; by the value's WType, whichever Fable helper it came through ──
    | ("numberHash" | "stringHash" | "safeHash" | "structuralHash" | "arrayHash" | "fastStructuralHash" | "bigintHash"), [x], WType.I32 ->
        structuralHash ctx x
    // Unary negation: 0 - x  (covers all int8/int16/int32/uint variants → all map to I32)
    | ("op_UnaryNegation_Int8"    | "op_UnaryNegation_UInt8"
    |  "op_UnaryNegation_Int16"   | "op_UnaryNegation_UInt16"
    |  "op_UnaryNegation_Int32"   | "op_UnaryNegation_UInt32"
    |  "op_UnaryNegation"), [arg], WType.I32 ->
        WExpr.Binary(WBinaryOp.Sub, i32Zero, arg, WType.I32)
    | ("op_UnaryNegation_Int64"   | "op_UnaryNegation"), [arg], WType.I64 ->
        WExpr.Binary(WBinaryOp.Sub, i64Const 0L, arg, WType.I64)
    | ("op_UnaryNegation_Float32"), [arg], WType.F32 ->
        WExpr.Unary(WUnaryOp.Neg, arg, WType.F32)
    | ("op_UnaryNegation_Float64" | "op_UnaryNegation"), [arg], WType.F64 ->
        WExpr.Unary(WUnaryOp.Neg, arg, WType.F64)

    // Math helpers imported from fable-library/Double.js, Util.js etc.
    // Route these through dispatchMathCall so they get proper WasmIR.
    | ("abs" | "min" | "max" | "round" | "sign" | "sqrt" | "floor" | "ceiling" | "ceil" | "trunc" | "truncate" | "nearest"), _, _ ->
        // Fable's `sign` library function is int-typed, so it wraps a float argument in a cast to int32; a float
        // must keep its value (sign 0.5 = 1)
        let wArgs =
            match sel, info.Args with
            | "sign", [ Fable.Expr.TypeCast(inner, _) ]
                when (match inner.Type with Fable.Type.Number((NumberKind.Float32 | NumberKind.Float64), _) -> true | _ -> false) ->
                [ eval ctx inner ]
            | _ -> wArgs
        dispatchMathCall importInfo.Selector wArgs ty (info.Args |> List.exists (fun a -> WasmGc.Util.FableQuery.isUnsignedInt a.Type))
    // ---------------------------------------------------
    // Maths
    // Trig / transcendental — software polynomial (no native WASM trig ops).
    // For float32 args: promote to f64, call helper, demote back.
    | "exp", [arg], WType.F32 ->
        WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathExp"), [WExpr.Unary(WUnaryOp.PromoteF32, arg, WType.F64)], WType.F64), WType.F32)
    | "exp", [arg], _ -> WExpr.Call(ctx.UseHelper("$mathExp"), [arg], WType.F64)
    | "log", [arg], WType.F32 ->
        WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathLog"),  [WExpr.Unary(WUnaryOp.PromoteF32, arg, WType.F64)], WType.F64), WType.F32)
    | "log", [arg], _ -> WExpr.Call(ctx.UseHelper("$mathLog"), [arg], WType.F64)
    | "sin", [arg], WType.F32 ->
        WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathSin"),  [WExpr.Unary(WUnaryOp.PromoteF32, arg, WType.F64)], WType.F64), WType.F32)
    | "sin",  [arg], _ -> WExpr.Call(ctx.UseHelper("$mathSin"),  [arg], WType.F64)
    | "cos", [arg], WType.F32 ->
        WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathCos"),  [WExpr.Unary(WUnaryOp.PromoteF32, arg, WType.F64)], WType.F64), WType.F32)
    | "cos",  [arg], _ -> WExpr.Call(ctx.UseHelper("$mathCos"),  [arg], WType.F64)
    | "tan", [arg], WType.F32 ->
        WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathTan"),  [WExpr.Unary(WUnaryOp.PromoteF32, arg, WType.F64)], WType.F64), WType.F32)
    | "tan",  [arg], _ -> WExpr.Call(ctx.UseHelper("$mathTan"),  [arg], WType.F64)
    | "atan2", [y; x], WType.F32 ->
        let yD = WExpr.Unary(WUnaryOp.PromoteF32, y, WType.F64)
        let xD = WExpr.Unary(WUnaryOp.PromoteF32, x, WType.F64)
        WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathAtan2"), [yD; xD], WType.F64), WType.F32)
    | "atan2", [y; x], _ -> WExpr.Call(ctx.UseHelper("$mathAtan2"), [y; x], WType.F64)
    
    // BitOperations: LeadingZeroCount → Math.clz32 (intercepted here); TrailingZeroCount/PopCount come as LibCall
    | "trailingZeroCount", [arg], _ -> WExpr.Unary(WUnaryOp.Ctz,    arg, WType.I32)
    | "popCount",          [arg], _ -> WExpr.Unary(WUnaryOp.Popcnt, arg, WType.I32)
    
    // BitConverter reinterpret-cast helpers (no memory access, pure bit rewriting)
    | "int32BitsToSingle",  [arg], _ -> WExpr.Unary(WUnaryOp.ReinterpretI32ToF32, arg, WType.F32)
    | "singleToInt32Bits",  [arg], _ -> WExpr.Unary(WUnaryOp.ReinterpretF32ToI32, arg, WType.I32)
    | "int64BitsToDouble",  [arg], _ -> WExpr.Unary(WUnaryOp.ReinterpretI64ToF64, arg, WType.F64)
    | "doubleToInt64Bits",  [arg], _ -> WExpr.Unary(WUnaryOp.ReinterpretF64ToI64, arg, WType.I64)
    | "uint32BitsToSingle", [arg], _ -> WExpr.Unary(WUnaryOp.ReinterpretI32ToF32, arg, WType.F32)
    | "singleToUInt32Bits", [arg], _ -> WExpr.Unary(WUnaryOp.ReinterpretF32ToI32, arg, WType.I32)
    // ---------------------------------------------------
    // ── StringBuilder — calls from ./System.Text.fs ───────────────────────────
    | "StringBuilder_$ctor", _, _ ->
        // new StringBuilder() / new StringBuilder(capacity)
        let cap = match wArgs with | [c] -> c | _ -> i32Const 16
        WExpr.Call(ctx.UseHelper("$sbCreate"), [cap], WType.Ref(StringBuilderTypeIdx, false))
    | sel, sb :: value :: _, _ when sel.StartsWith("StringBuilder__Append_") ->
        // sb.Append(x) — returns sb (unit in F# use, but typed as ref $StringBuilder).  Everything is appended as a
        // string: a char is a one-character string, an integer its decimal text.
        let strT = WType.Ref(StringTypeIdx, false)
        let append (s: WExpr) = WExpr.Call(ctx.UseHelper("$sbAppend"), [sb; s], WType.Ref(StringBuilderTypeIdx, false))
        match info.Args |> List.tryLast |> Option.map (fun a -> a.Type) with
        | Some Fable.Type.Char -> append (WExpr.ArrayNew(StringTypeIdx, i32Const 1, value, strT))
        | Some(Fable.Type.Number _) when exprWType value = WType.I32 -> append (WExpr.Call(ctx.UseHelper("$intToStr"), [value], strT))
        | _ -> append value
    | "StringBuilder__Clear", [sb], _ ->
        // sb.Clear() — length back to 0, returns sb
        wasm {
            let! b = sb
            do! WExpr.StructSet(b, 1, i32Const 0)
            return b
        }
    | "StringBuilder__get_Length", [sb], _ ->
        // sb.Length → struct.get field 1 (length)
        WExpr.StructGet(sb, 1, WType.I32)
    | sel, [sb], _ when sel.StartsWith("StringBuilder__ToString") ->
        // sb.ToString() → $sbToString
        WExpr.Call(ctx.UseHelper("$sbToString"), [sb], WType.Ref(StringTypeIdx, false))
    // String char access: String.getCharAtIndex(str, idx) → array.get $WasmStr
    | "getCharAtIndex", [str; idx], _ ->
        WExpr.ArrayGet(str, idx, WType.I32)
    // String.indexOf(str, needle) → $strIndexOf
    // String
    | "indexOf", [str; needle], WType.I32 ->
        WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; needle], WType.I32)
    // String.startsWith(str, prefix) → $strIndexOf == 0
    | "startsWith", [str; prefix], _ ->
        WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; prefix], WType.I32), i32Zero)
    // String.endsWith(str, suffix) → check at (len(str) - len(suffix))
    | "endsWith", [str; suffix], _ ->
        let strLen  = arrayLen str
        let sufLen  = arrayLen suffix
        let pos     = WExpr.Binary(WBinaryOp.Sub, strLen, sufLen, WType.I32)
        // pos >= 0 && $strIndexOf(str, suffix) == pos
        let posOk   = WExpr.Compare(WCompareOp.GeS, pos, i32Zero)
        let atEnd   = WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; suffix], WType.I32), pos)
        WExpr.Binary(WBinaryOp.And, posOk, atEnd, WType.I32)
    // String.substring(str, start, len) → $strSubstring
    | "substring", [str; start; len], _ ->
        WExpr.Call(ctx.UseHelper("$strSubstring"), [str; start; len], WType.Ref(StringTypeIdx, false))
    | "substring", [str; start], _ ->
        let len = WExpr.Binary(WBinaryOp.Sub, arrayLen str, start, WType.I32)
        WExpr.Call(ctx.UseHelper("$strSubstring"), [str; start; len], WType.Ref(StringTypeIdx, false))
    // ── Char predicates and conversions — delegated to Runtime helpers ──
    | "isDigit",         [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charIsDigit"),        [c], WType.I32)
    | "isLetter",        [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charIsLetter"),       [c], WType.I32)
    | "isLetterOrDigit", [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charIsLetterOrDigit"),[c], WType.I32)
    | "isUpper",         [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charIsUpper"),        [c], WType.I32)
    | "isLower",         [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charIsLower"),        [c], WType.I32)
    | "isWhiteSpace",    [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charIsWhitespace"),   [c], WType.I32)
    | "toLower",         [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charToLower"),        [c], WType.I32)
    | "toUpper",         [c], WType.I32 -> WExpr.Call(ctx.UseHelper("$charToUpper"),        [c], WType.I32)
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
        WExpr.Compare(WCompareOp.GeS, WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; needle], WType.I32), i32Zero)
    // String.IsNullOrEmpty(str) → array.len = 0 (our strings are never null in WasmGC)
    | "isNullOrEmpty", [str], _ ->
        WExpr.Compare(WCompareOp.Eq, arrayLen(str), i32Zero)
    // String.IsNullOrWhiteSpace(str) → trim then check length = 0
    | "isNullOrWhiteSpace", [str], _ ->
        WExpr.Compare(WCompareOp.Eq,
            arrayLen(WExpr.Call(ctx.UseHelper("$strTrim"), [str], WType.Ref(StringTypeIdx, false))),
            i32Zero)
    // `compare` on tuples: Fable passes them to Util.compareArrays; they are structs here, so use the structural ordering
    | "compareArrays", [a; b], WType.I32 when isStructuralRef (exprWType a) ->
        compareValues ctx (exprWType a) a b
    // String.compare(a, b) / String.Compare(a, b) → $strCompare → i32 (-1 | 0 | 1)
    // Also handles generic "compare" calls with non-string args (e.g. int64 via Long module)
    | ("compare" | "compareOrdinal" | "compareCurrentCulture"), [a; b], WType.I32 ->
        let argTy = exprWType a
        match argTy with
        | WType.Ref(si, _) when si = StringTypeIdx ->
            WExpr.Call(ctx.UseHelper("$strCompare"), [a; b], WType.I32)
        | _ ->
            // Numeric compare → -1 / 0 / 1 (floats: F# ordering, NaN lowest)
            compareValues ctx argTy a b
    // comparePrimitives(a, b) — Fable's generic primitive compare (Util.fs import).
    // Result: -1 / 0 / 1.  Dispatches on runtime arg type.
    | "comparePrimitives", [a; b], WType.I32 ->
        let argTy = exprWType a
        match argTy with
        | WType.Ref(si, _) when si = StringTypeIdx ->
            WExpr.Call(ctx.UseHelper("$strCompare"), [a; b], WType.I32)
        | _ ->
            compareValues ctx argTy a b
    // toString for numbers (via LibCall path)
    | "toString", [arg], _ -> primitiveToString ctx (match info.Args with a :: _ -> a.Type | [] -> Fable.Type.Any) arg
    // int32ToString / int64ToString (Util module LibCall path)
    | "int32ToString", [arg], _ ->
        WExpr.Call(ctx.UseHelper("$intToStr"), [arg], WType.Ref(StringTypeIdx, false))
    | "int64ToString", [arg], _ -> int64ToString ctx arg false
    | "uint64ToString", [arg], _ -> int64ToString ctx arg true
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
        // `s.Split('c')`: the separator array is a literal of CHARS — read the element from the Fable AST
        let literalSep =
            match info.Args with
            | _ :: Fable.Expr.Value(Fable.ValueKind.NewArray(Fable.NewArrayKind.ArrayValues [ sep ], _, _), _) :: _ ->
                let w = eval ctx sep
                Some(if sep.Type = Fable.Type.Char then charToString w else w)
            | _ -> None
        match sepArr with
        | Some _ when literalSep.IsSome ->
            WExpr.Call(ctx.UseHelper("$strSplit"), [str; literalSep.Value], arrRef)
        | Some sepArrExpr ->
            // sepArrExpr is array of strings; take first element as the delimiter
            let delim = arrayGet sepArrExpr i32Zero (WType.Ref(StringTypeIdx, false))
            WExpr.Call(ctx.UseHelper("$strSplit"), [str; delim], arrRef)
        | None ->
            // No separator — split on whitespace (use " " as separator)
            let space = WExpr.ArrayNewFixed(StringTypeIdx, [i32Const 32], WType.Ref(StringTypeIdx, false))
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
            let parts, specs = parseFormatSpecs fmt
            let nSpecs = List.length specs
            let holeParts =
                [ for k in 0 .. nSpecs - 1 do
                    yield emitLit parts.[k]
                    if k < valExprs.Length then
                        yield formatField ctx specs.[k] (WasmGc.Util.FableQuery.isUnsignedInt valExprs.[k].Type) (eval ctx valExprs.[k]) ]
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
    // String concat: fold any N strings via $strConcat
    // hasSpread=true causes Fable to wrap args into ArrayNewFixed; handle both forms.
    | "concat", [WExpr.ArrayNewFixed(_, items, _)], _ ->
        let strRef = WType.Ref(StringTypeIdx, false)
        let foldConcat ss =
            match ss with
            | [] -> WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
            | [s] -> s
            | h :: t -> t |> List.fold (fun acc s -> WExpr.Call(ctx.UseHelper("$strConcat"), [acc; s], strRef)) h
        foldConcat items
    | "concat", args, _ when not (List.isEmpty args) ->
        let strRef = WType.Ref(StringTypeIdx, false)
        match args with
        | [s] -> s
        | h :: t -> t |> List.fold (fun acc s -> WExpr.Call(ctx.UseHelper("$strConcat"), [acc; s], strRef)) h
        | [] -> WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
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
    // ── Unchecked.defaultof<'T> — zero-like value for type T ──────────────────────
    | "defaultOf", [], _ ->
        match ty with
        | WType.Ref(_, _) -> WExpr.Const(WConst.Null ty)
        | WType.I32 -> i32Zero
        | WType.I64 -> i64Const 0L
        | WType.F32 -> f32Const 0.0f
        | WType.F64 -> f64Const 0.0
        | _ -> WExpr.Nop
    // ── IDisposable.Dispose → no-op (for now) ───────────────────────────────────────
    | "disposeSafe", [_obj], _ ->
        WExpr.Nop
    // ── Seq.empty → null list ────────────────────────────────────────────────────────
    | "empty", [], _ ->
        WExpr.Const(WConst.Null ty)
    // ── Seq.singleton(x) → single-element list Cons(x, null) ──────────────────────────
    | "singleton", [elem], _ ->
        // TODO: Implement via ctx.ListRegistry like ListOps.fs does
        // For now: stub with Nop to unblock wasmecto
        WExpr.Nop
    // ── Object.GetHashCode without a structural hash of its own: values by value, references 0 ──
    | "identityHash", [x], WType.I32 ->
        identityHash ctx x
    // ── toConsole (printfn final stage): calls $consolePrint(str) ─────────────
    // Emits a call to the JS-imported $consolePrint function.
    // String.toConsole is called with the final formatted string.
    | "toConsole", [str], _ ->
        WExpr.Call("consolePrint", [str], WType.Void)
    // String.join(sep, items) → $strJoin — Fable emits LibCall(String, "join", [sep; items]); items of any element type
    | "join", sep :: rest, WType.Ref(si, _) when si = StringTypeIdx ->
        let strArrTypeIdx = getOrAddArrayType ctx (WType.Ref(StringTypeIdx, false))
        let arrRef = WType.Ref(strArrTypeIdx, false)
        match rest with
        | [arrExpr] -> strJoin ctx sep (stringifyItems ctx (List.last info.Args).Type arrExpr)
        | _ ->
            // joinWithIndices or other overload — not yet supported, emit Nop
            eprintfn "[WasmGc] WARNING: unhandled String.join variant with %d args" rest.Length
            WExpr.Nop
    // String.join with no sep (sep = "")
    | "join", [arrExpr], _ ->
        let strRef = WType.Ref(StringTypeIdx, false)
        let emptyStr = WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
        strJoin ctx emptyStr (stringifyItems ctx (List.last info.Args).Type arrExpr)
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
    // ── downcast: runtime-safe cast used in `:? T as e` pattern bindings ──────
    // Fable emits `Call(Import("downcast","./Util.fs"), [obj])` when narrowing
    // an anyref/base-type catch variable to a concrete exception/DU type.
    // We emit ref.cast to the target struct type (inferred from the return type).
    | "downcast", [arg], WType.Ref(typeIdx, _) ->
        WExpr.Cast(arg, WType.Ref(typeIdx, false))
    | "downcast", [arg], _ ->
        // ty was computed via mapTypeKnown from the call's Fable return type.
        // If it resolved to a non-struct type (e.g. I32 for unregistered DeclaredType),
        // pass through the argument unchanged — the caller will handle the type mismatch.
        arg
        
    // TODO: Wasm Memory was handled before in fallback branch below. Check if this is working here
    // Wasm Memory
    | "i32.load", [addr], _ when path = "wasm:memory" ->
        ctx.HasLinearMemory := true
        WExpr.MemLoad(WMemKind.I32, 0, addr)

    // Fallback: if the selector names a function compiled from a library
    // file earlier in this project (in ctx.KnownFuncs), emit a direct call.
    // This handles same-project cross-file calls (e.g. Map.add → Map_add).
    | _, _, _ ->
        let selector = importInfo.Selector
        // a generic function of ANOTHER file (`onClick<'msg>` called from the app): the call site knows the type
        // arguments, so it gets its own specialised copy instead of the unresolved (i32-typed) original
        // (library functions are resolved by module-qualified name below; their short names are not unique)
        // (a function of a file of a referenced PROJECT is also known by its file's name, but is specialised like any other)
        let isLibraryFunc =
            isCoreLibraryPath ctx importInfo.Path
            && Map.containsKey (System.IO.Path.GetFileNameWithoutExtension importInfo.Path, selector) ctx.KnownFuncsByPath
        // a member or constructor of a generic CLASS (`Queue$1__Enqueue_…`, `Queue$1_$ctor`) is instantiated even when it
        // lives in the core library: its name is the class's, there is no plain-name collision to fear
        let isClassMember = selector.Contains "$"
        match (if isLibraryFunc && not isClassMember then None else trySpecializeCall ctx eval selector info typ) with
        | Some specialised -> specialised
        | None ->
        // Use the import path to find the module-qualified function name.
        // importInfo.Path = e.g. "../core/FSharp.Wasm.Core/Collections/Map.fs" → stem = "Map"
        let stem = System.IO.Path.GetFileNameWithoutExtension(importInfo.Path)
        let actualName =
            match Map.tryFind (stem, selector) ctx.KnownFuncsByPath with
            | Some qualName -> qualName
            | None -> selector  // fallback to short name (handles non-library or unknown)
        // a core-library import is resolved through its own (file, name) entry only: the plain name is the namespace of
        // the program's functions, and a program function called `append` must not capture `List.append`
        let isLibraryImport = isCoreLibraryPath ctx importInfo.Path
        let knownEntry =
            if isLibraryImport && not (Map.containsKey (stem, selector) ctx.KnownFuncsByPath) then None
            else Map.tryFind actualName ctx.KnownFuncs
        match knownEntry with
        | Some (_, retTy) ->
            // Use the actual compiled return type (retTy) rather than the Fable-annotated
            // type (ty). This is critical for generic collection types like Map<int,int>
            // whose Fable type maps to I32 (unknown DeclaredType) but whose WasmGC
            // return type is Ref(MapBaseTypeIdx, false). Using the wrong type here causes
            // local variables to be typed incorrectly, breaking downstream lookups.
            let effectiveTy = if retTy = WType.Void then ty else retTy
            WExpr.Call(actualName, wArgs, effectiveTy)
        | None ->
        // ── wasm:memory intrinsics — lower to WASM linear memory instructions ─────
        // Functions declared as [<Import("f32.store","wasm:memory")>] are lowered here
        // instead of emitting a JS import. The module must declare a linear memory section.
        let path = importInfo.Path
        if path = "wasm:memory" then
            ctx.HasLinearMemory := true   // mark module as needing (memory 1)
            match selector, wArgs with
            | "i32.store8",   [addr; v]  -> WExpr.MemStore(WMemKind.Byte, 0, addr, v)
            | "i32.store",    [addr; v]  -> WExpr.MemStore(WMemKind.I32,  0, addr, v)
            | "i64.store",    [addr; v]  -> WExpr.MemStore(WMemKind.I64,  0, addr, v)
            | "f32.store",    [addr; v]  -> WExpr.MemStore(WMemKind.F32,  0, addr, v)
            | "f64.store",    [addr; v]  -> WExpr.MemStore(WMemKind.F64,  0, addr, v)
            | "i32.load8_u",  [addr]     -> WExpr.MemLoad(WMemKind.Byte, 0, addr)
            | "i32.load",     [addr]     -> WExpr.MemLoad(WMemKind.I32,  0, addr)
            | "i64.load",     [addr]     -> WExpr.MemLoad(WMemKind.I64,  0, addr)
            | "f32.load",     [addr]     -> WExpr.MemLoad(WMemKind.F32,  0, addr)
            | "f64.load",     [addr]     -> WExpr.MemLoad(WMemKind.F64,  0, addr)
            | "memory.size",  []         -> WExpr.MemorySize
            | "memory.grow",  [pages]    -> WExpr.MemoryGrow pages
            | unknown, _ ->
                eprintfn "[WasmGc] WARNING: unknown wasm:memory intrinsic '%s'" unknown
                WExpr.Nop
        else
        // ── External Wasm FFI — [<Import("name","module")>] on nativeOnly ──────────
        // When the path has no .fs extension and no fable-library, treat as a Wasm import.
        // The import is registered once; subsequent calls reuse the same declaration.
        let pLow = path.ToLowerInvariant()
        let isLocalFile = pLow.EndsWith(".fs") || pLow.EndsWith(".fsi")
        let isFableLib = pLow.Contains("fable-library")
        if not isLocalFile && not isFableLib && selector <> "" then
            HostInterop.call ctx path selector info wArgs typ ty
        else
            // Try stdlib import replacements before giving up
            match FSharpCoreReplacements.tryHandleStdlibImport ctx selector wArgs ty with
            | Some result -> result
            | None ->
                WasmGc.Core.Diagnostics.unhandledImport ctx.Diagnostics selector path ctx.CurrentFunc
                WExpr.Nop

    // TODO: already handled above in the more specific match arm for wasm:memory imports, but we need to check if there are any other cases that might be missed by the current patterns.
    // | _ ->
    //     eprintfn "[WasmGc] WARNING: unhandled import call '%s' from '%s'" sel path
    //     WExpr.Nop

// ─────────────────────────────────────────────────────────────────
// Call translation
// ─────────────────────────────────────────────────────────────────

/// What a callee is, in a line: `member 'ContainsKey' of Dictionary` rather than the AST dumped with %A (which the
/// diagnostic cuts off before the member's name).
let private describeCallee (callee: Expr) : string =
    let typeName (t: Fable.Type) =
        match t with
        | Fable.Type.DeclaredType(e, _) -> e.FullName
        | Fable.Type.Array(elem, kind) -> sprintf "%A array of %A" kind elem
        | Fable.Type.List _ -> "list"
        | Fable.Type.Option _ -> "option"
        | Fable.Type.String -> "string"
        | Fable.Type.Tuple _ -> "tuple"
        | Fable.Type.LambdaType _ | Fable.Type.DelegateType _ -> "function"
        | other -> (sprintf "%A" other).Replace("\n", " ").Replace("  ", " ")
    match callee with
    | Fable.Expr.Get(target, Fable.GetKind.FieldGet fi, _, _) -> sprintf "member '%s' of %s" fi.Name (typeName target.Type)
    | Fable.Expr.Get(target, Fable.GetKind.ExprGet _, _, _) -> sprintf "indexed value of %s" (typeName target.Type)
    | Fable.Expr.Get(target, kind, _, _) -> sprintf "%A of %s" kind (typeName target.Type)
    | Fable.Expr.IdentExpr i -> sprintf "value '%s' of %s" i.Name (typeName i.Type)
    | other -> (sprintf "%A" other).Replace("\n", " ").Replace("  ", " ")

/// A member call on an array receiver: a ResizeArray's members first (ToArray, Sort, Insert, RemoveAt, …), then the
/// native array methods.
let private tryArrayMember (eval: Ctx -> Expr -> WExpr) (ctx: Ctx) (name: string) (receiver: Expr) (args: Expr list) (typ: Type) : WExpr option =
    ResizeArrayOps.tryInstance eval ctx name receiver args
    |> Option.orElseWith (fun () -> tryArrayInstanceCall eval ctx name receiver args typ)

/// Call through a computed callee — a record/class field holding a closure, the result of another
/// call, … Function-typed callees are applied as closures (same path as a closure-typed local);
/// anything else is a compiler gap: it is reported (WGC009) instead of emitting an ill-typed `call_ref`.
let private indirectCall
        (ctx: Ctx)
        (eval: Ctx -> Expr -> WExpr)
        (callee: Expr)
        (info: CallInfo)
        (wArgs: WExpr list)
        (ty: WType)
        : WExpr =
    let wCallee = eval ctx callee

    let isClosure =
        match callee.Type, exprWType wCallee with
        | (Fable.Type.LambdaType _ | Fable.Type.DelegateType _), _ -> true
        | _, WType.Ref(idx, _) -> idx = AnyFnTypeIdx
        | _ -> false

    if isClosure then
        ClosureBuilder.applyClosure ctx callee.Type wCallee (info.Args |> List.map (fun a -> a.Type)) wArgs ty
    else
        WasmGc.Core.Diagnostics.unhandledCallee ctx.Diagnostics (describeCallee callee) ctx.CurrentFunc callee.Range
        WExpr.Nop

/// Main-Dispatcher for all C
// ── Builder/Locals.fs (~line 61) — FS0026 rule never matched ─────────────
// Same issue.  The Locals.fs collectLocals has a catch-all that shadows a
// specific case below it.  Find the duplicate and remove the shadowed arm.

let private transformCallCore
    (ctx: Ctx)
    (eval: Ctx -> Expr -> WExpr)
    (callee: Expr)
    (info: CallInfo)
    (typ: Type) : WExpr =

    // TODO: for better diagnostics, we could match on the callee expression and print more info about it here
    // eprintfn "[WasmGc] Call callee=%A in func=%A" callee ctx.CurrentFunc
    let ty = mapTypeKnown ctx typ
    let wArgs =
        let evaluated = info.Args |> List.map (eval ctx)
        // an array passed where the signature says `seq<'T>` (F# coerces silently) becomes the list a seq is
        if info.SignatureArgTypes.Length = evaluated.Length then
            List.zip3 info.SignatureArgTypes (info.Args |> List.map (fun a -> a.Type)) evaluated
            |> List.map (fun (declared, actual, w) -> if isSeqType declared then coerceToSeq ctx actual w else w)
        else evaluated

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
                    let boxExpr = eval ctx thisArg
                    let wArgsFilt  = wArgs |> List.filter (fun a -> exprWType a <> WType.Void)
                    Some (VT.emitCallVirtual ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodIdx boxExpr wArgsFilt ty)
                | None -> None
            | false, _ -> None
        | _ -> None

    match ifaceDispatch with
    | Some result -> result
    | None ->
        match callee with
        // `String(x)`: what Fable emits for `x.ToString()` on a float / bool / …
        | IdentExpr { Name = "String" } when (match wArgs with [ _ ] -> true | _ -> false) ->
            primitiveToString ctx info.Args.Head.Type wArgs.Head
        | IdentExpr ident ->
            // A local variable typed as a closure (ref $AnyFn) is a higher-order call: ClosureApply, not a direct Call.
            // It comes first: a local `add` or `append` shadows a module function of the same name, and the generic
            // function registry is keyed by the short name, so specialization would otherwise take the local's call.
            match Map.tryFind ident.Name ctx.Locals with
            | Some(WType.Ref(idx, _)) when idx = AnyFnTypeIdx ->
                // Self-parameter convention (Sprint 25b): prepend ref $AnyFn as first param.
                let wClosure = WExpr.LocalGet(ident.Name, WType.Ref(AnyFnTypeIdx, false))
                // Func type from the callee's declared type (see ClosureBuilder.applyClosure);
                // the ClosureBase is created on demand so closureTypeIdx is never 0.
                ClosureBuilder.applyClosure ctx ident.Type wClosure (info.Args |> List.map (fun a -> a.Type)) wArgs ty
            | _ ->
            // Sprint 5: demand-driven generic specialization.
            match trySpecializeCall ctx eval ident.Name info typ with
            | Some specialized -> specialized
            | None ->
                // Direct function call (non-generic or unregistered generic).  An instance member called on an
                // expression (`Counter(5).Next()`) carries its receiver in `ThisArg`; the function takes it first.
                let actualName = ctx.FuncNameAlias |> Map.tryFind ident.Name |> Option.defaultValue ident.Name
                let receiver = match info.ThisArg with Some t -> [ eval ctx t ] | None -> []
                WExpr.Call(actualName, receiver @ wArgs, ty)

        | Import(importInfo, _, _) ->
            // For string instance methods (IndexOf, Substring, etc.), Fable puts the
            // receiver in info.ThisArg rather than info.Args. Prepend it so our dispatch
            // patterns see [receiver; arg1; ...] like module-level functions do.
            let fullWArgs =
                match info.ThisArg with
                | Some t -> eval ctx t :: wArgs
                | None -> wArgs
            dispatchImportCall ctx eval importInfo info typ fullWArgs

        // ── console.log/info/warn/error/debug ────────────────────────────────────
        // Fable's `printfn "literal"` shortcut (no format arguments) is `console.log(str)`.
        // Formatted printfn goes through String.toConsole → $consolePrint; route this one the same way.
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "console" }, GetKind.FieldGet fi, _, _)
            when (match fi.Name with
                  | "log" | "info" | "warn" | "error" | "debug" -> true
                  | _ -> false) ->
            match wArgs with
            | [ str ] when (match exprWType str with
                            | WType.Ref(si, _) -> si = StringTypeIdx
                            | _ -> false) ->
                WExpr.Call("consolePrint", [ str ], WType.Void)
            | _ -> indirectCall ctx eval callee info wArgs ty
        // ── StringBuilder.ToString() ─────────────────────────────────────────────
        // Fable's generic Object.ToString replacement yields `sb.toString()` (a FieldGet callee on
        // the instance), not the `StringBuilder__ToString` import handled in dispatchImportCall.
        | Fable.Expr.Get(sbExpr, GetKind.FieldGet fi, _, _)
            when (fi.Name = "toString" || fi.Name = "ToString")
                 && (match sbExpr.Type with
                     | Fable.Type.DeclaredType(entRef, _) -> entRef.FullName = "System.Text.StringBuilder"
                     | _ -> false) ->
            WExpr.Call(ctx.UseHelper("$sbToString"), [ eval ctx sbExpr ], WType.Ref(StringTypeIdx, false))
        // TODO: why is this part skippd? till the default match `| _ -> let wCallee`
        // ── Numeric .toString() — for string(n), n.ToString(), sprintf, etc. ────
        | Fable.Expr.Get(numExpr, GetKind.FieldGet fi, _, _)
            when fi.Name = "toString"
            && (match numExpr.Type with
                | Fable.Type.Number _ | Fable.Type.Boolean -> true | _ -> false) ->
            primitiveToString ctx numExpr.Type (eval ctx numExpr)
        // ── char.charCodeAt(0) — Fable JS replacement for int(char) conversion ──
        // In WasmGC, chars are already i32 code points; charCodeAt(0) is a no-op.
        | Fable.Expr.Get(thisExpr, GetKind.FieldGet fi, _, _) when fi.Name = "charCodeAt" ->
            eval ctx thisExpr   // discard the '0' arg; just return the char i32 value
        // ── Char instance methods (Fable emits .toLocaleLowerCase() etc. on char values) ──
        | Fable.Expr.Get(charExpr, GetKind.FieldGet fi, _, _)
            when (match charExpr.Type with | Fable.Type.Char -> true | _ -> false) ->
            let wChar = eval ctx charExpr
            match fi.Name with
            | ("toLocaleLowerCase" | "toLower" | "toLowerCase") ->
                // Char.ToLower: if A-Z then c+32 else c
                let tmp = "$chcl2"
                WExpr.Let(tmp, wChar,
                    WExpr.If(
                        WExpr.Binary(WBinaryOp.And,
                            WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), i32Const 65),
                            WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), i32Const 90),
                            WType.I32),
                        WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(tmp, WType.I32), i32Const 32, WType.I32),
                        WExpr.LocalGet(tmp, WType.I32), WType.I32))
            | ("toLocaleUpperCase" | "toUpper" | "toUpperCase") ->
                // Char.ToUpper: if a-z then c-32 else c
                let tmp = "$chcu2"
                WExpr.Let(tmp, wChar,
                    WExpr.If(
                        WExpr.Binary(WBinaryOp.And,
                            WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), i32Const 97),
                            WExpr.Compare(WCompareOp.LeS, WExpr.LocalGet(tmp, WType.I32), i32Const 122),
                            WType.I32),
                        WExpr.Binary(WBinaryOp.Sub, WExpr.LocalGet(tmp, WType.I32), i32Const 32, WType.I32),
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
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "exp" ->
            match ty, wArgs with
            | WType.F32, [a] -> WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathExp"),  [WExpr.Unary(WUnaryOp.PromoteF32, a, WType.F64)], WType.F64), WType.F32)
            | _,         _   -> WExpr.Call(ctx.UseHelper("$mathExp"), wArgs, WType.F64)
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "log" ->
            match ty, wArgs with
            | WType.F32, [a] -> WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathLog"),  [WExpr.Unary(WUnaryOp.PromoteF32, a, WType.F64)], WType.F64), WType.F32)
            | _,         _   -> WExpr.Call(ctx.UseHelper("$mathLog"), wArgs, WType.F64)
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "log10" ->
            match wArgs with
            | [a] -> WExpr.Binary(WBinaryOp.DivS, WExpr.Call(ctx.UseHelper("$mathLog"), [a], WType.F64), WExpr.Const(WConst.F64 2.302585092994046), WType.F64)
            | _ -> f64Const 0.0
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "log2" ->
            match wArgs with
            | [a] -> WExpr.Binary(WBinaryOp.DivS, WExpr.Call(ctx.UseHelper("$mathLog"), [a], WType.F64), WExpr.Const(WConst.F64 0.6931471805599453), WType.F64)
            | _ -> f64Const 0.0
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "sin" ->
            match ty, wArgs with
            | WType.F32, [a] -> WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathSin"),  [WExpr.Unary(WUnaryOp.PromoteF32, a, WType.F64)], WType.F64), WType.F32)
            | _,         _   -> WExpr.Call(ctx.UseHelper("$mathSin"), wArgs, WType.F64)
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "cos" ->
            match ty, wArgs with
            | WType.F32, [a] -> WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathCos"),  [WExpr.Unary(WUnaryOp.PromoteF32, a, WType.F64)], WType.F64), WType.F32)
            | _,         _   -> WExpr.Call(ctx.UseHelper("$mathCos"), wArgs, WType.F64)
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "tan" ->
            match ty, wArgs with
            | WType.F32, [a] -> WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathTan"),  [WExpr.Unary(WUnaryOp.PromoteF32, a, WType.F64)], WType.F64), WType.F32)
            | _,         _   -> WExpr.Call(ctx.UseHelper("$mathTan"), wArgs, WType.F64)
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "atan2" ->
            match ty, wArgs with
            | WType.F32, [y; x] ->
                let yD = WExpr.Unary(WUnaryOp.PromoteF32, y, WType.F64)
                let xD = WExpr.Unary(WUnaryOp.PromoteF32, x, WType.F64)
                WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathAtan2"), [yD; xD], WType.F64), WType.F32)
            | _,         _      -> WExpr.Call(ctx.UseHelper("$mathAtan2"), wArgs, WType.F64)
        // BitOperations.LeadingZeroCount → Math.clz32 (GlobalCall "Math" route)
        // `char n` / `string.fromCharCode` : chars already ARE i32 code points
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "String" }, GetKind.FieldGet fi, _, _)
            when (fi.Name = "fromCharCode" || fi.Name = "fromCodePoint") && wArgs.Length = 1 ->
            List.head wArgs
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _)
            when fi.Name = "clz32" ->
            WExpr.Unary(WUnaryOp.Clz, List.head wArgs, WType.I32)
        | Fable.Expr.Get(Fable.Expr.IdentExpr { Name = "Math" }, GetKind.FieldGet fi, _, _) ->
            dispatchMathCall fi.Name wArgs ty (info.Args |> List.exists (fun a -> WasmGc.Util.FableQuery.isUnsignedInt a.Type))
        // ── String instance methods: indexOf, startsWith, endsWith, substring ──────
        // These come as Get(strExpr, FieldGet "indexOf") callee with args=[needle].
        // We intercept before the general FieldGet handler.
        | Fable.Expr.Get(strExpr, GetKind.FieldGet fi, _, _)
            when (match strExpr.Type with | Fable.Type.String -> true | _ -> false) ->
            let wStr = eval ctx strExpr
            // `s.IndexOf('c')`, `s.Contains('c')` … pass a char where the helpers search for a string
            let needsString = [ "indexOf"; "lastIndexOf"; "startsWith"; "endsWith"; "includes"; "contains" ] |> List.contains fi.Name
            let mArgs =
                info.Args
                |> List.map (fun a ->
                    let w = eval ctx a
                    if needsString && a.Type = Fable.Type.Char then charToString w else w)
            let strRef = WType.Ref(StringTypeIdx, false)
            match fi.Name, mArgs with
            | "indexOf", [needle] ->
                WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; needle], WType.I32)
            | "indexOf", [needle; fromIdx] ->
                // For indexOf with fromIndex: search in substring from fromIdx
                let subLen = WExpr.Binary(WBinaryOp.Sub, arrayLen wStr, fromIdx, WType.I32)
                let sub = WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; fromIdx; subLen], WType.Ref(StringTypeIdx, false))
                let found = WExpr.Call(ctx.UseHelper("$strIndexOf"), [sub; needle], WType.I32)
                // if found >= 0, add fromIdx back; else keep -1
                let tmp = "$iofi_tmp"
                WExpr.Let(tmp, found,
                    WExpr.If(
                        WExpr.Compare(WCompareOp.GeS, WExpr.LocalGet(tmp, WType.I32), i32Zero),
                        WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet(tmp, WType.I32), fromIdx, WType.I32),
                        i32Const -1, WType.I32))
            | "lastIndexOf", [needle] ->
                WExpr.Call(ctx.UseHelper("$strLastIndexOf"), [wStr; needle], WType.I32)
            | "lastIndexOf", [needle; fromIdx] ->
                // For lastIndexOf with fromIndex: search in prefix up to fromIdx+1
                let clamped = WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; i32Zero; WExpr.Binary(WBinaryOp.Add, fromIdx, i32One, WType.I32)], WType.Ref(StringTypeIdx, false))
                WExpr.Call(ctx.UseHelper("$strLastIndexOf"), [clamped; needle], WType.I32)
            | "startsWith", [prefix] ->
                WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; prefix], WType.I32), i32Zero)
            | "endsWith", [suffix] ->
                let pos = WExpr.Binary(WBinaryOp.Sub, arrayLen wStr, arrayLen suffix, WType.I32)
                let posOk = WExpr.Compare(WCompareOp.GeS, pos, i32Zero)
                let atEnd = WExpr.Compare(WCompareOp.Eq, WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; suffix], WType.I32), pos)
                WExpr.Binary(WBinaryOp.And, posOk, atEnd, WType.I32)
            | "substring", [start] ->
                let len = WExpr.Binary(WBinaryOp.Sub, arrayLen wStr, start, WType.I32)
                WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; start; len], strRef)
            | "substring", [start; len] ->
                WExpr.Call(ctx.UseHelper("$strSubstring"), [wStr; start; len], strRef)
            | "slice", [start] ->
                let len = WExpr.Binary(WBinaryOp.Sub, arrayLen wStr, start, WType.I32)
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
                WExpr.Compare(WCompareOp.GeS, WExpr.Call(ctx.UseHelper("$strIndexOf"), [wStr; needle], WType.I32), i32Zero)
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
            let wReceiver = eval ctx arrExpr
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
                        VT.emitCallVirtual ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodIdx wReceiver wArgs ty
                    | None ->
                        // Method not in vtable — fall through to array instance/indirect
                        match tryArrayMember eval ctx fi.Name arrExpr info.Args typ with
                        | Some result -> result
                        | None ->
                            indirectCall ctx eval callee info wArgs ty
                | None ->
                    match tryArrayMember eval ctx fi.Name arrExpr info.Args typ with
                    | Some result -> result
                    | None ->
                        indirectCall ctx eval callee info wArgs ty
            | _ ->
                match tryArrayMember eval ctx fi.Name arrExpr info.Args typ with
                | Some result -> result
                | None ->
                    indirectCall ctx eval callee info wArgs ty

        | _ ->
            indirectCall ctx eval callee info wArgs ty

/// Entry point for every Fable call.  A seq pipeline that is consumed eagerly (`[ for … ]`, `[a .. b]`, `Seq.toArray …`)
/// is fused into loops BEFORE its lazy, closure-based arguments are compiled; everything else takes the normal route.
let transformCall (ctx: Ctx) (eval: Ctx -> Expr -> WExpr) (callee: Expr) (info: CallInfo) (typ: Type) : WExpr =
    match callee with
    | Import _ when info.ThisArg.IsNone -> trySeqFusionInline eval ctx (Call(callee, info, typ, None))
    | _ -> None
    |> Option.defaultWith (fun () -> transformCallCore ctx eval callee info typ)
