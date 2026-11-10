module WasmGc.Transforms.TransformDispatch

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST

open WasmGc.Builder.Core
open WasmGc.Runtime.Locals // TODO: should they be renamed to Builder
open WasmGc.Runtime.Types
open WasmGc.Runtime.Equality
open WasmGc.Transforms.ArrayReplacements
open WasmGc.Transforms.OptionResultTransforms
open WasmGc.Transforms.ListTransforms
open WasmGc.Transforms.ListOps
open WasmGc.Transforms.MathMap

open WasmGc.Transforms.TransformHelpers

module RT = WasmGc.Runtime.Runtime
module VT = WasmGc.Runtime.VTable

// ─────────────────────────────────────────────────────────────────
// Sprint 5: Monomorphization — demand-driven generic specialization
// ─────────────────────────────────────────────────────────────────

/// Try to specialize a call to a generic function.
/// Returns Some(WExpr.Call to the specialized version) or None if not applicable.
/// None means: fall through to the regular (unspecialized) call handling.
let trySpecializeCall
    (ctx: Ctx)
    (eval: Ctx -> Expr -> WExpr)
    (funcName: string)
    (info: CallInfo)
    (resultFableType: Type)
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
        let wArgs = info.Args |> List.map (eval ctx)
        let retTy = mapTypeKnown ctx resultFableType

        // 6. Already emitted? Just emit a call — body is already in ctx.Functions.
        if ctx.MonoCache.ContainsKey(mangledName) then
            Some(WExpr.Call(mangledName, wArgs, retTy))
        else
            // 7. Get generic param names in declaration order via the declaring compiler.
            //    Use declCom (the compiler for the file that DECLARES the generic function)
            //    so that entity lookups resolve correctly even for cross-file generics.

            let paramNamesOpt = // TODO: rewrite with Option.bind or add OptionBuilder for our staircases here! Who shold read this!
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
            // let wBody = transformExpr ctx' memberDecl.Body
            let wBody = eval ctx' memberDecl.Body

            // 12. Build params list (filter out unit/void).
            let funcParams =
                memberDecl.Args
                |> List.choose (fun a ->
                    let ty = mapTypeKnown ctx' a.Type
                    if ty = WType.Void then None else Some(a.Name, ty))

            // 13. Emit the specialized WFuncDecl.
            let func : WFuncDecl =
                {   Name = mangledName
                    Params = funcParams
                    Result = retTy'
                    Locals = []
                    Body = wBody
                    Exported = false }
            ctx.Functions.Add(func |> resolveLocals)
            Some(WExpr.Call(mangledName, wArgs, retTy'))

/// Behandelt String, Math und Import Calls
let dispatchImportCall (ctx: Ctx) (eval: Ctx -> Expr -> WExpr) (importInfo: ImportInfo) (info: CallInfo) (typ: Type) (wArgs: WExpr list) : WExpr =
    let ty = mapTypeKnown ctx typ
    let sel = importInfo.Selector
    let path = importInfo.Path

    // TODO: this ListReplacements should be moved 
    let importStem = System.IO.Path.GetFileNameWithoutExtension(importInfo.Path)
    let r =
        tryFirst [
            // ── Map/Set module: must come first to prevent List combinators matching Set/Map DeclaredTypes ──
            fun () -> tryMapInline               ctx importStem sel wArgs
            fun () -> trySetInline               ctx importStem sel wArgs
            // ── List combinators ────────────────────────────────────────────────────
            fun () -> tryListFoldInline           eval ctx sel info.Args
            fun () -> tryListFoldBackInline       eval ctx sel info.Args typ
            fun () -> tryListMapInline            eval ctx sel info.Args typ
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
    | ("equals" | "op_Equality" | "equalArrays"), [a; b], WType.I32 ->
        let wty = exprWType a
        let typeIdx = match wty with WType.Ref(idx, _) -> idx | _ -> -1
        if typeIdx >= 0 then
            ctx.UseHelper("$strEq") |> ignore
            match getOrAddStructuralEquals ctx typeIdx with
            | Some funcName -> WExpr.Call(funcName, [a; b], WType.I32)
            | None -> WExpr.Compare(WCompareOp.Eq, a, b)
        else WExpr.Compare(WCompareOp.Eq, a, b)  // primitives: direct eq
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
    | sel, sb :: str :: _, _ when sel.StartsWith("StringBuilder__Append_") ->
        // sb.Append(str) — returns sb (unit in F# use, but typed as ref $StringBuilder)
        WExpr.Call(ctx.UseHelper("$sbAppend"), [sb; str], WType.Ref(StringBuilderTypeIdx, false))
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
    // String.compare(a, b) / String.Compare(a, b) → $strCompare → i32 (-1 | 0 | 1)
    // Also handles generic "compare" calls with non-string args (e.g. int64 via Long module)
    | ("compare" | "compareOrdinal" | "compareCurrentCulture"), [a; b], WType.I32 ->
        let argTy = exprWType a
        match argTy with
        | WType.Ref(si, _) when si = StringTypeIdx ->
            WExpr.Call(ctx.UseHelper("$strCompare"), [a; b], WType.I32)
        | _ ->
            // Numeric compare → -1 / 0 / 1 (floats: F# ordering, NaN lowest)
            numericCompare a b argTy
    // comparePrimitives(a, b) — Fable's generic primitive compare (Util.fs import).
    // Result: -1 / 0 / 1.  Dispatches on runtime arg type.
    | "comparePrimitives", [a; b], WType.I32 ->
        let argTy = exprWType a
        match argTy with
        | WType.Ref(si, _) when si = StringTypeIdx ->
            WExpr.Call(ctx.UseHelper("$strCompare"), [a; b], WType.I32)
        | _ ->
            numericCompare a b argTy
    // toString for numbers (via LibCall path)
    | "toString", [arg], WType.Ref(si, _) when si = StringTypeIdx ->
        WExpr.Call(ctx.UseHelper(if info.Args |> List.exists (fun a -> WasmGc.Util.FableQuery.isUnsignedInt a.Type) then "$uintToStr" else "$intToStr"), [arg], WType.Ref(StringTypeIdx, false))
    | "toString", [arg], _ ->
        WExpr.Call(ctx.UseHelper(if info.Args |> List.exists (fun a -> WasmGc.Util.FableQuery.isUnsignedInt a.Type) then "$uintToStr" else "$intToStr"), [arg], WType.Ref(StringTypeIdx, false))
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
            let delim = WExpr.ArrayGet(sepArrExpr, i32Zero, WType.Ref(StringTypeIdx, false))
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
                        yield formatHole ctx specs.[k] (WasmGc.Util.FableQuery.isUnsignedInt valExprs.[k].Type) (eval ctx valExprs.[k]) ]
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
    // ── Object.GetHashCode stub → identityHash (return 0) ────────────────────────────
    | "identityHash", [_obj], WType.I32 ->
        i32Zero
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
    | selector, _, _ ->
        // Use the import path to find the module-qualified function name.
        // importInfo.Path = e.g. "../fable-library-wasmgc/Map.fs" → stem = "Map"
        let stem = System.IO.Path.GetFileNameWithoutExtension(importInfo.Path)
        let actualName =
            match Map.tryFind (stem, selector) ctx.KnownFuncsByPath with
            | Some qualName -> qualName
            | None -> selector  // fallback to short name (handles non-library or unknown)
        match Map.tryFind actualName ctx.KnownFuncs with
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
            let paramTypes = wArgs |> List.map exprWType
            let callName = ctx.RegisterExternFunc(path, selector, paramTypes, ty)
            WExpr.Call(callName, wArgs, ty)
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
        WasmGc.Core.Diagnostics.unhandledCallee ctx.Diagnostics (sprintf "%A" callee) ctx.CurrentFunc callee.Range
        WExpr.Nop

/// Main-Dispatcher for all C
// ── Builder/Locals.fs (~line 61) — FS0026 rule never matched ─────────────
// Same issue.  The Locals.fs collectLocals has a catch-all that shadows a
// specific case below it.  Find the duplicate and remove the shadowed arm.

let transformCall 
    (ctx: Ctx) 
    (eval: Ctx -> Expr -> WExpr)
    // eval
    (callee: Expr)
    (info: CallInfo) 
    (typ: Type) : WExpr =

    // TODO: for better diagnostics, we could match on the callee expression and print more info about it here
    // eprintfn "[WasmGc] Call callee=%A in func=%A" callee ctx.CurrentFunc
    let ty = mapTypeKnown ctx typ
    let wArgs = info.Args |> List.map (eval ctx)

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
        | IdentExpr ident ->
            // Sprint 5: try demand-driven generic specialization first.
            // match trySpecializeCall ctx eval ident.Name info typ with
            match trySpecializeCall ctx eval ident.Name info typ with
            | Some specialized -> specialized
            | None ->
                // Check if the identifier is a local variable typed as a closure (ref $AnyFn).
                // If so, this is a higher-order call — emit ClosureApply instead of a direct Call.
                let actualName = ctx.FuncNameAlias |> Map.tryFind ident.Name |> Option.defaultValue ident.Name
                match Map.tryFind ident.Name ctx.Locals with
                | Some(WType.Ref(idx, _)) when idx = AnyFnTypeIdx ->
                    // This is a closure parameter — dispatch via ClosureApply.
                    // Self-parameter convention (Sprint 25b): prepend ref $AnyFn as first param.
                    let wClosure = WExpr.LocalGet(ident.Name, WType.Ref(AnyFnTypeIdx, false))
                    // Func type from the callee's declared type (see ClosureBuilder.applyClosure);
                    // the ClosureBase is created on demand so closureTypeIdx is never 0.
                    ClosureBuilder.applyClosure ctx ident.Type wClosure (info.Args |> List.map (fun a -> a.Type)) wArgs ty
                | _ -> WExpr.Call(actualName, wArgs, ty)  // Direct function call (non-generic or unregistered generic).

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
            let wNum = eval ctx numExpr
            let strRef = WType.Ref(StringTypeIdx, false)
            match exprWType wNum with
            | WType.I64 -> WExpr.Call(ctx.UseHelper("$intToStr"), [WExpr.Unary(WUnaryOp.WrapI64, wNum, WType.I32)], strRef)
            | WType.F64 | WType.F32 ->
                WExpr.Call(ctx.UseHelper("$intToStr"), [WExpr.Unary(WUnaryOp.TruncF64S, wNum, WType.I32)], strRef)
            | _ -> WExpr.Call(ctx.UseHelper(if WasmGc.Util.FableQuery.isUnsignedInt numExpr.Type then "$uintToStr" else "$intToStr"), [wNum], strRef)
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
            let mArgs = info.Args |> List.map (eval ctx)
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
                        match tryArrayInstanceCall eval ctx fi.Name arrExpr info.Args typ with
                        | Some result -> result
                        | None ->
                            indirectCall ctx eval callee info wArgs ty
                | None ->
                    match tryArrayInstanceCall eval ctx fi.Name arrExpr info.Args typ with
                    | Some result -> result
                    | None ->
                        indirectCall ctx eval callee info wArgs ty
            | _ ->
                match tryArrayInstanceCall eval ctx fi.Name arrExpr info.Args typ with
                | Some result -> result
                | None ->
                    indirectCall ctx eval callee info wArgs ty

        | _ ->
            indirectCall ctx eval callee info wArgs ty

