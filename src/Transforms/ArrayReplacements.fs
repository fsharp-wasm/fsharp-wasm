/// Array inline Replacements — Fable dispatch ONLY. No WExpr loop generation.
/// All algorithms delegated to WasmGc.Patterns.Array (pure, Fable-free).
/// Covers typed arrays: create, init, fill, copy, map, filter, fold, iter,
/// exists, forAll, sort, sortWith, sortBy, reverse, concat, choose,
/// collect, zip, unzip, head/tail/take/skip/splitAt, and instance-method HOFs.
/// Array Replacements — Fable dispatch + WExpr generation.
/// All Fable.Expr argument extraction and WType resolution lives here.
/// WExpr algorithm logic is delegated to WasmGc.Patterns.Array where refactored.
/// sortWith uses shared $arraySortWith BCL helper (not inlined — saves ~40 WExpr/call).
module WasmGc.Transforms.ArrayReplacements

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core
open WasmGc.Runtime.Runtime
open WasmGc.Runtime.LoopHelpers

open WasmGc.Patterns
open WasmGc.Patterns.ListShape
open WasmGc.Patterns.ArrayOps

open WasmGc.Runtime.LoopPrimitives
open WasmGc.Util.FableQuery

// ─────────────────────────────────────────────────────────────────
// Array higher-order functions
// ─────────────────────────────────────────────────────────────────

// ── Type extraction ─────────────────────────────────────────────────────────

/// Extract element type only for F# array shapes: Fable.Type.Array<T, _>.
/// This is intentionally array-specific and complements (does not replace):
/// - ListCombinators.seqElemType for List/seq/IEnumerable-like shapes
/// - LoopHelpers.tryListTypeInfo for list registry resolution

let private arrElemT = function ArrayOf e -> Some e | _ -> None

/// Is this the type of a `seq<'T>` (what a `seq` parameter, or a coercion to `seq`, says)?
let isSeqType (t: Fable.Type) =
    match t with
    | Fable.Type.DeclaredType(e, [ _ ]) -> e.FullName = "System.Collections.Generic.IEnumerable`1"
    | _ -> false

/// An array where a `seq<'T>` is expected: `seq` is represented as a (strict) list, so the array is copied into one.
/// A list passes as it is; any other argument is returned unchanged (the caller reports what it cannot convert).
let coerceToSeq (ctx: Ctx) (argType: Fable.Type) (w: WExpr) : WExpr =
    let unsupported what =
        WasmGc.Core.Diagnostics.unsupported ctx.Diagnostics
            $"a {what} where a seq<'T> is expected"
            "A seq is a list here: lists, arrays and ResizeArrays convert, other collections (Set, Map, string) do not yet — use `Set.toList` first."
        w
    match argType with
    // a ResizeArray as a seq: a snapshot of its first Count elements as a list (the way Stack / Queue / HashSet do)
    | Fable.Type.Array(elemFableT, Fable.ArrayKind.ResizeArray) ->
        match tryListTypeInfoFromElemType ctx elemFableT with
        | Some(elemT, consIdx) ->
            let s = mkListShape elemT consIdx
            let arrIdx, _ = getOrAddResizeArrayType ctx elemT
            wasm {
                let! rav = w
                let! data = WExpr.Cast(WExpr.StructGet(rav, 0, WType.Ref(arrIdx, true)), WType.Ref(arrIdx, false))
                return! arrayToListRev (LabelGen "r2s") s data (WExpr.StructGet(rav, 1, WType.I32)) (fun ar i -> arrayGet ar i elemT)
            }
        | None -> w
    | Fable.Type.String -> unsupported "string"
    | Fable.Type.DeclaredType(e, _) when e.FullName.StartsWith "Microsoft.FSharp.Collections.FSharpSet" || e.FullName.StartsWith "Microsoft.FSharp.Collections.FSharpMap" ->
        unsupported "Set or Map"
    | _ ->
    match arrElemT argType with
    | Some elemFableT ->
        match tryListTypeInfoFromElemType ctx elemFableT with
        | Some(elemT, consIdx) ->
            let s = mkListShape elemT consIdx
            let gen = LabelGen("a2s")
            wasm {
                let! a = w
                return! arrayToListRev gen s a (arrayLen a) (fun ar i -> arrayGet ar i elemT)
            }
        | None -> w
    | None -> w

// let private shapeOf (ctx: Ctx) et =
//    let wt = mapTypeKnown ctx et
//    mkArrayShape wt (getOrAddArrayType ctx wt)

// ── Main dispatch ────────────────────────────────────────────────────────────

/// `Compare` of a Fable comparer argument (`ObjectExpr { Compare = fun x y -> … }`), or a bare two-argument lambda.
let private (|ComparerLambda|_|) (e: Fable.Expr) =
    match e with
    | Fable.Expr.ObjectExpr(members, _, _) ->
        members |> List.tryPick (fun m -> match m.Name, m.Body with "Compare", BinaryLambda(a, b, body) -> Some(a, b, body) | _ -> None)
    | BinaryLambda(a, b, body) -> Some(a, b, body)
    | _ -> None

/// How elements of type `t` live in a GC array: reference elements are stored nullable (the array is created
/// with null) and cast back to non-null on read.
type ArrayAccess =
    { TypeIdx: int; RefT: WType; Default: WExpr
      Read: WExpr -> WExpr -> WExpr; Write: WExpr -> WExpr -> WExpr -> WExpr }

let arrayAccess (ctx: Ctx) (t: WType) : ArrayAccess =
    let stored, zero =
        match t with
        | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
        | _ -> t, makeNumericZero t
    let idx = getOrAddArrayType ctx stored
    { TypeIdx = idx; RefT = WType.Ref(idx, false); Default = zero
      Read = (fun arr i -> match t with
                           | WType.Ref(ri, false) -> cast (arrayGet arr i stored) (WType.Ref(ri, false))
                           | _ -> arrayGet arr i t)
      Write = arraySet }

let tryArrayInline
        (transform : TransformFn)
        (ctx       : Ctx)
        (selector  : string)
        (fableArgs : Fable.Expr list)
        (wArgs     : WExpr list)       // pre-compiled args (for trivial cases)
        (resultFableType : Fable.Type)
        : WExpr option =

    // let w f = transform ctx f
    // let inline none () = None

    let ty = mapTypeKnown ctx resultFableType
    match selector with
    // Array.create n initVal
    | "create" ->
        match arrElemT resultFableType, wArgs with
        | Some elemFableT, [wSize; wInit] ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            Some(arrayNew arrTypeIdx wSize wInit (WType.Ref(arrTypeIdx, false)))
        | _ -> None
    // Array.zeroCreate n
    | "zeroCreate" ->
        match arrElemT resultFableType, wArgs with
        | Some elemFableT, [wSize] ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            Some(arrayNew arrTypeIdx wSize (makeNumericZero elemT) (WType.Ref(arrTypeIdx, false)))
        | _ -> None
    // Array.length
    | "length" ->
        match fableArgs with
        | [arrArg] when arrElemT arrArg.Type |> Option.isSome ->
            Some(arrayLen (List.head wArgs))
        | _ -> None
    // Array.get / Array.item
    | ("get" | "item") ->
        let arrFableArg, arrWArgIdx, idxWArgIdx =
            match fableArgs with
            | [a; _] when arrElemT a.Type |> Option.isSome -> a, 0, 1
            | [_; a] when arrElemT a.Type |> Option.isSome -> a, 1, 0
            | _ -> List.head fableArgs, 0, 1
        match arrElemT arrFableArg.Type, wArgs with
        | Some elemFableT, [w0; w1] ->
            let elemT = mapTypeKnown ctx elemFableT
            let wArr = if arrWArgIdx = 0 then w0 else w1
            let wIdx = if idxWArgIdx = 0 then w0 else w1
            let wArrFinal =
                match arrFableArg.Type with
                | ResizeArrayOf _ ->
                    let (arrTypeIdx, _) = getOrAddResizeArrayType ctx elemT
                    let arrRefT = WType.Ref(arrTypeIdx, true)
                    cast (structGet wArr 0 arrRefT) (WType.Ref(arrTypeIdx, false))
                | _ -> wArr
            Some(arrayGet wArrFinal wIdx elemT)
        | _ -> None
    // ResizeArray.[idx] <- v → Array.setItem(ar, idx, value)
    | "setItem" ->
        match fableArgs with
        | [arrArg; _; _] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                match wArgs with
                | [wArr; wIdx; wVal] ->
                    match arrArg.Type with
                    | ResizeArrayOf _ ->
                        let (arrTypeIdx, _) = getOrAddResizeArrayType ctx elemT
                        let arrRefT = WType.Ref(arrTypeIdx, true)
                        Some(arraySet (cast (structGet wArr 0 arrRefT) (WType.Ref(arrTypeIdx, false))) wIdx wVal)
                    | _ ->
                        Some(arraySet wArr wIdx wVal)
                | _ -> None
            | None -> None
        | _ -> None
    // Array.set
    | "set" ->
        match fableArgs with
        | [arrArg; _; _] when arrElemT arrArg.Type |> Option.isSome ->
            match wArgs with
            | [wArr; wIdx; wVal] -> Some(arraySet wArr wIdx wVal)
            | _ -> None
        | _ -> None
    // Array.copy
    | "copy" ->
        match fableArgs with
        | [arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRef = WType.Ref(arrTypeIdx, false)
                let wSrc = List.head wArgs
                let gen = LabelGen("acpy")
                Some(wasm {
                    let! src = wSrc
                    let! dst = arrayNew arrTypeIdx (arrayLen src) (makeNumericZero elemT) arrRef
                    do! arrayCopy dst (i32Const 0) src (i32Const 0) (arrayLen src)
                    return dst
                })
            | None -> None
        | _ -> None
    // Array.fill
    | "fill" ->
        match arrElemT resultFableType with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let arrRefT = WType.Ref(arrTypeIdx, false)
            // `Array.zeroCreate<'T> n` fills with `null` (`Unchecked.defaultof`) whatever 'T is: for a number that is zero
            let fillValue (v: WExpr) =
                match v, elemT with
                | WExpr.Const(WConst.Null _), (WType.I32 | WType.I64 | WType.F32 | WType.F64) -> WasmGc.Builder.Core.makeNumericZero elemT
                | _ -> v
            match wArgs with
            | [_; _; wCount; wValue] -> Some(arrayNew arrTypeIdx wCount (fillValue wValue) arrRefT)
            | [_; wCount; wValue]    -> Some(arrayNew arrTypeIdx wCount (fillValue wValue) arrRefT)
            | [wCount; wValue]       -> Some(arrayNew arrTypeIdx wCount (fillValue wValue) arrRefT)
            | _ -> None
        | None ->
            match fableArgs, wArgs with
            | [arrArg; _; _; _], [wArr; wStart; wCount; wVal] when arrElemT arrArg.Type |> Option.isSome ->
                let gen = LabelGen("fill")
                Some(wasm {
                    let! lim = add wStart wCount
                    let! i = mut wStart
                    while! (ltS i.Val lim) do
                        do! arraySet wArr i.Val wVal
                        do! i.Set(add i.Val (i32Const 1))
                })
            | _ -> None
    // Array.iter / iterate
    | ("iter" | "iterate") ->
        match fableArgs with
        | [UnaryLambda(farg, fbody); arrArg]
        | [UnaryLambda(farg, fbody); arrArg; _]
        | [_; UnaryLambda(farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("aiter")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayIter gen a wArr
                    (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
            | None -> None
        | _ -> None
    // Array.iteri / iterateIndexed
    | ("iteri" | "iterateIndexed") ->
        match fableArgs with
        | [BinaryLambda(fidx, farg, fbody); arrArg]
        | [BinaryLambda(fidx, farg, fbody); arrArg; _]
        | [_; BinaryLambda(fidx, farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("aiteri")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(fidx.Name, WType.I32).WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayIteri gen a wArr
                    (fun idx elem ->
                        WExpr.Let(fidx.Name, idx, WExpr.Let(farg.Name, elem, wBody))))
            | None -> None
        | _ -> None
    // Array.map
    | "map" ->
        match fableArgs with
        | [UnaryLambda(farg, fbody); arrArg]
        | [UnaryLambda(farg, fbody); arrArg; _]
        | [_; UnaryLambda(farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let resultFableT = match resultFableType with | ArrayOf t -> t | _ -> elemFableT
                let resultElemT = mapTypeKnown ctx resultFableT
                let resultArrIdx = getOrAddArrayType ctx resultElemT
                let a = mkArrayShape elemT arrTypeIdx
                let ra = mkArrayShape resultElemT resultArrIdx
                let gen = LabelGen("amap")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayMap gen a ra wArr
                    (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
            | None -> None
        | _ -> None
    // Array.mapi / mapIndexed
    | ("mapi" | "mapIndexed") ->
        match fableArgs with
        | [BinaryLambda(fidx, farg, fbody); arrArg]
        | [BinaryLambda(fidx, farg, fbody); arrArg; _]
        | [_; BinaryLambda(fidx, farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let resultFableT = match resultFableType with | ArrayOf t -> t | _ -> elemFableT
                let resultElemT = mapTypeKnown ctx resultFableT
                let resultArrIdx = getOrAddArrayType ctx resultElemT
                let a = mkArrayShape elemT arrTypeIdx
                let ra = mkArrayShape resultElemT resultArrIdx
                let gen = LabelGen("amapi")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(fidx.Name, WType.I32).WithLocal(farg.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayMapi gen a ra wArr
                    (fun idx elem ->
                        WExpr.Let(fidx.Name, idx,
                            WExpr.Let(farg.Name, elem, wBody))))
            | None -> None
        | _ -> None
    // Array.fold
    | "fold" ->
        match fableArgs with
        | FoldArgs(farg1, farg2, fbody, initArg, arrArg) ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("afold")
                let wArr = List.last wArgs
                let wInit = transform ctx initArg
                let accT = mapTypeKnown ctx initArg.Type
                let ctx' = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
                let wBody = transform ctx' fbody
                Some(arrayFold gen a wArr wInit accT
                    (fun acc elem ->
                        WExpr.Let(farg1.Name, acc,
                            WExpr.Let(farg2.Name, elem, wBody))))
            | None -> None
        | _ -> None
    // ── slices: Array.take / skip / truncate ──
    // take / skip raise when the count leaves the array (negative: ArgumentException, too large:
    // InvalidOperationException); truncate clamps to [0, length].
    | "take" | "skip" | "truncate" ->
        match fableArgs, wArgs with
        | [ _; arrArg ], [ wN; wSrc ] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let outOfRange n len = wasmOr (ltS n (i32Const 0)) (gtS n len)
                Some(wasm {
                    // skip: a count <= 0 keeps the whole array
                    let! n = if selector = "skip" then wasmIf (ltS wN (i32Const 0)) (i32Const 0) wN else wN
                    let! src = wSrc
                    let! len = arrayLen src
                    do! wasmWhen (if selector = "truncate" then WExpr.Const(WConst.I32 0) else outOfRange n len) (WExpr.Throw WExpr.Nop)
                    let! count =
                        match selector with
                        | "take" -> n
                        | "skip" -> sub len n
                        | _ -> wasmIf (ltS n (i32Const 0)) (i32Const 0) (wasmIf (gtS n len) len n)
                    let! start = if selector = "skip" then n else i32Const 0
                    let! dst = arrayNew arrTypeIdx count (makeNumericZero elemT) (WType.Ref(arrTypeIdx, false))
                    do! arrayCopy dst (i32Const 0) src start count
                    return dst
                })
            | None -> None
        | _ -> None
    // ── search: Array.find / tryFind (a missing element raises / is None), tryItem, tryLast ──
    | "find" | "tryFind" ->
        match fableArgs with
        | [ UnaryLambda(farg, fbody); arrArg ] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let a = mkArrayShape elemT (getOrAddArrayType ctx elemT)
                let wPred = transform (ctx.WithLocal(farg.Name, elemT)) fbody
                let found elem = WExpr.Let(farg.Name, elem, wPred)
                if selector = "find" then
                    Some(arraySearch (LabelGen "afind") a (transform ctx arrArg) elemT found (fun _ e -> e) (WExpr.Throw WExpr.Nop))
                else
                    let optT, some, none = optionRepr ctx elemT
                    Some(arraySearch (LabelGen "atry") a (transform ctx arrArg) optT found (fun _ e -> some e) none)
            | None -> None
        | _ -> None
    | "tryItem" | "tryLast" ->
        match fableArgs, wArgs with
        | (arrArg :: _), _ ->
            match arrElemT (List.last fableArgs).Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let a = mkArrayShape elemT (getOrAddArrayType ctx elemT)
                let optT, some, none = optionRepr ctx elemT
                let wSrc = List.last wArgs
                Some(wasm {
                    let! src = wSrc
                    let! len = arrayLen src
                    let! i = if selector = "tryLast" then sub len (i32Const 1) else List.head wArgs
                    return! wasmIf (wasmOr (ltS i (i32Const 0)) (geS i len)) none (some (a.Get(src, i)))
                })
            | None -> None
        | _ -> None
    // Array.foldBack f arr state — right to left
    | "foldBack" ->
        match fableArgs with
        | [BinaryLambda(farg, sacc, fbody); arrArg; initArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let a = mkArrayShape elemT (getOrAddArrayType ctx elemT)
                let accT = mapTypeKnown ctx initArg.Type
                let wBody = transform (ctx.WithLocal(farg.Name, elemT).WithLocal(sacc.Name, accT)) fbody
                Some(wasm {
                    let! src = List.item 1 wArgs
                    let! acc = mutTy accT (transform ctx initArg)
                    let! i = mut (sub (a.Len src) (i32Const 1))
                    while! (geS i.Val (i32Const 0)) do
                        do! acc.Set(WExpr.Let(farg.Name, a.Get(src, i.Val), WExpr.Let(sacc.Name, acc.Val, wBody)))
                        do! i.Set(sub i.Val (i32Const 1))
                    return acc.Val
                })
            | None -> None
        | _ -> None
    // Array.sub arr start count  (Fable: getSubArray) — ArgumentException when the range leaves the array
    | "getSubArray" ->
        match fableArgs, wArgs with
        | [arrArg; _; _], [wSrc; wStart; wCount] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                Some(wasm {
                    let! src = wSrc
                    let! start = wStart
                    let! count = wCount
                    do! wasmWhen
                            (wasmOr (ltS start (i32Const 0)) (wasmOr (ltS count (i32Const 0)) (ltS (sub (arrayLen src) start) count)))
                            (WExpr.Throw WExpr.Nop)
                    let! dst = arrayNew arrTypeIdx count (makeNumericZero elemT) (WType.Ref(arrTypeIdx, false))
                    do! arrayCopy dst (i32Const 0) src start count
                    return dst
                })
            | None -> None
        | _ -> None
    // Array.exists / Array.forAll
    | ("exists" | "forAll") ->
        let sel = selector
        match fableArgs with
        | [UnaryLambda(farg, fbody); arrArg]
        | [UnaryLambda(farg, fbody); arrArg; _]
        | [_; UnaryLambda(farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("aexi")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wPred = transform ctx' fbody
                if sel = "exists" then
                    Some(arrayExists gen a wArr
                        (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
                else
                    Some(arrayForAll gen a wArr
                        (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
            | None -> None
        | _ -> None
    // Array.filter
    | "filter" | "where" ->
        match fableArgs with
        | [UnaryLambda(farg, fbody); arrArg]
        | [UnaryLambda(farg, fbody); arrArg; _]
        | [_; UnaryLambda(farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a = mkArrayShape elemT arrTypeIdx
                let gen = LabelGen("afilt")
                let wArr = transform ctx arrArg
                let ctx' = ctx.WithLocal(farg.Name, elemT)
                let wPred = transform ctx' fbody
                Some(arrayFilter gen a wArr
                    (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
            | None -> None
        | _ -> None
    // Array.init / initialize
    | ("init" | "initialize") ->
        match fableArgs with
        | [lenArg; UnaryLambda(farg, fbody)]
        | [lenArg; UnaryLambda(farg, fbody); _]
        | [_; lenArg; UnaryLambda(farg, fbody)] ->
            let wLen = transform ctx lenArg
            let resultFableT = match resultFableType with | ArrayOf t -> t | _ -> Fable.Type.Any
            let resultElemT = mapTypeKnown ctx resultFableT
            let resultArrIdx = getOrAddArrayType ctx resultElemT
            let resultArrRefT = WType.Ref(resultArrIdx, false)
            let gen = LabelGen("ainit")
            let ctx' = ctx.WithLocal(farg.Name, WType.I32)
            let wBody = transform ctx' fbody
            Some(wasm {
                let! res = arrayNew resultArrIdx wLen (makeNumericZero resultElemT) resultArrRefT
                do! Wasm.for_ (arrayLen res) (fun idx ->
                        WExpr.Let(farg.Name, idx,
                            arraySet res idx wBody))
                return res
            })
        | _ -> None
    // ── Array.reduce f arr — fold from first element as accumulator ──
    | ("reduce" | "reduceBack") ->
        match fableArgs with
        | [BinaryLambda(farg1, farg2, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let gen        = LabelGen("ared")
                let wArr       = transform ctx arrArg
                let ctx'       = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
                let wBody      = transform ctx' fbody
                Some(wasm {
                    let! src = wArr
                    let! len = arrayLen src
                    let! acc = mutTy elemT (arrayGet src (i32Const 0) elemT)
                    let! i = mut (i32Const 1)
                    while! (ltS i.Val len) do
                        do! acc.Set(WExpr.Let(farg1.Name, acc.Val,
                                WExpr.Let(farg2.Name, arrayGet src i.Val elemT, wBody)))
                        do! i.Set(add i.Val (i32Const 1))
                    return acc.Val
                })
            | None -> None
        | _ -> None
    // ── Array.sum arr — fold with additive zero ──
    | "sum" | "sumBy" ->
        let proj, arrArg =
            match fableArgs with
            | UnaryLambda(x, body) :: arr :: _ -> Some(x, body), Some arr
            | arr :: _ -> None, Some arr
            | [] -> None, None
        match arrArg |> Option.bind (fun arr -> arrElemT arr.Type |> Option.map (fun t -> arr, t)) with
        | Some(arr, elemFableT) ->
            let elemT = mapTypeKnown ctx elemFableT
            let a = mkArrayShape elemT (getOrAddArrayType ctx elemT)
            // the sum has the type of the projection (`sumBy float` over ints), else of the elements
            let sumT = match proj with Some(_, body) -> mapTypeKnown ctx body.Type | None -> elemT
            let term =
                match proj with
                | Some(x, body) ->
                    let wBody = transform (ctx.WithLocal(x.Name, elemT)) body
                    (fun elem -> WExpr.Let(x.Name, elem, wBody))
                | None -> id
            Some(arrayFold (LabelGen "asum") a (transform ctx arr) (makeNumericZero sumT) sumT
                    (fun acc elem -> checkedAdd acc (term elem) sumT))
        | None -> None
    // ── Array.min / Array.max — fold from first element, keep extreme ──
    | "min" | "minBy" | "max" | "maxBy" ->
        // F# keeps the FIRST extreme: the accumulator is replaced only when the new key is strictly smaller
        // (larger).  Comparison is `<` / `>` on the key: IEEE for floats (NaN never wins), ordinal for strings,
        // structural for records / unions / tuples.
        let isMin = selector.StartsWith "min"
        let proj, arrArg =
            match fableArgs with
            | UnaryLambda(x, body) :: arr :: _ -> Some(x, body), Some arr
            | arr :: _ -> None, Some arr
            | [] -> None, None
        match arrArg |> Option.bind (fun arr -> arrElemT arr.Type |> Option.map (fun t -> arr, t)) with
        | Some(arr, elemFableT) ->
            let elemT = mapTypeKnown ctx elemFableT
            let keyFT = match proj with Some(_, body) -> body.Type | None -> elemFableT
            let keyT = mapTypeKnown ctx keyFT
            let a = mkArrayShape elemT (getOrAddArrayType ctx elemT)
            let key =
                match proj with
                | Some(x, body) ->
                    let wBody = transform (ctx.WithLocal(x.Name, elemT)) body
                    (fun elem -> WExpr.Let(x.Name, elem, wBody))
                | None -> id
            let better (k: WExpr) (best: WExpr) =
                let unsigned = isUnsignedInt keyFT
                match keyT with
                | WType.I32 | WType.I64 | WType.F32 | WType.F64 ->
                    WExpr.Compare((match isMin, unsigned with
                                   | true, false -> WCompareOp.LtS | true, true -> WCompareOp.LtU
                                   | false, false -> WCompareOp.GtS | false, true -> WCompareOp.GtU), k, best)
                | _ ->
                    WExpr.Compare((if isMin then WCompareOp.LtS else WCompareOp.GtS),
                                  WasmGc.Runtime.Equality.compareValues ctx keyT k best, i32Const 0)
            Some(wasm {
                let! src = transform ctx arr
                let! len = arrayLen src
                let! best = mutTy elemT (a.Get(src, i32Const 0))        // an empty array traps, as .NET raises
                let! bestKey = mutTy keyT (key best.Val)
                let! i = mut (i32Const 1)
                while! (ltS i.Val len) do
                    let! e = a.Get(src, i.Val)
                    let! k = key e
                    do! wasmWhen (better k bestKey.Val) (sequence [ best.Set e; bestKey.Set k ])
                    do! i.Set(add i.Val (i32Const 1))
                return best.Val
            })
        | None -> None
    // ── Array.rev arr — new array with elements in reverse order ──
    | ("rev" | "reverse") ->
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> arrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | Some arrArg ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT    = WType.Ref(arrTypeIdx, false)
                let wArr       = transform ctx arrArg
                let gen        = LabelGen("arv")
                Some(wasm {
                    let! src = wArr
                    let! len = arrayLen src
                    let! res = arrayNew arrTypeIdx len (makeNumericZero elemT) arrRefT
                    do! Wasm.for_ len (fun i ->
                            arraySet res i (arrayGet src (sub (sub len (i32Const 1)) i) elemT))
                    return res
                })
            | None -> None
        | None -> None
    // ── Array.zip arr1 arr2 — parallel arrays → array of pairs ──
    | "zip" ->
        match fableArgs with
        | (arr1Arg :: arr2Arg :: _) ->
            match arrElemT arr1Arg.Type, arrElemT arr2Arg.Type with
            | Some e1FT, Some e2FT ->
                let e1T = mapTypeKnown ctx e1FT
                let e2T = mapTypeKnown ctx e2FT
                let tupleFableT = Fable.Type.Tuple([e1FT; e2FT], false)
                let tupleWType  = mapTypeKnown ctx tupleFableT
                let tupleIdx = getOrAddTupleType ctx [e1T; e2T]
                let tupleRefT   = WType.Ref(tupleIdx, false)
                let rec makeWZero (wt: WType) : WExpr =
                    match wt with
                    | WType.I64 -> WExpr.Const(WConst.I64 0L)
                    | WType.F32 -> WExpr.Const(WConst.F32 0.0f)
                    | WType.F64 -> WExpr.Const(WConst.F64 0.0)
                    | WType.Ref(idx, true) -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                    | WType.Ref(idx, false) ->
                        match ctx.TypeDefs.[idx].Def with
                        | WTypeDef.Struct(fields, _) ->
                            structNew idx (fields |> List.map (fun f -> makeWZero f.Type)) (WType.Ref(idx, false))
                        | _ -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
                    | _ -> WExpr.Const(WConst.I32 0)
                let tupleDefault = makeWZero tupleRefT
                let resArrIdx   = getOrAddArrayType ctx tupleRefT
                let resArrRefT  = WType.Ref(resArrIdx, false)
                let wArr1 = transform ctx arr1Arg
                let wArr2 = transform ctx arr2Arg
                let gen = LabelGen("azip")
                let a1ArrIdx = getOrAddArrayType ctx e1T
                let a2ArrIdx = getOrAddArrayType ctx e2T
                Some(wasm {
                    let! a1 = wArr1
                    let! a2 = wArr2
                    let! res = arrayNew resArrIdx (arrayLen a1) tupleDefault resArrRefT
                    do! Wasm.for_ (arrayLen a1) (fun idx ->
                            arraySet res idx
                                (structNew tupleIdx
                                    [arrayGet a1 idx e1T; arrayGet a2 idx e2T]
                                    tupleRefT))
                    return res
                })
            | _ -> None
        | _ -> None
    // ── Array.unzip arr — array of pairs → two arrays ─────────────────────
    | "unzip" ->
        match fableArgs with
        | [arrArg] ->
            match arrElemT arrArg.Type with
            | Some(MaybeTuple(ta, tb)) ->
                let aT      = mapTypeKnown ctx ta
                let bT      = mapTypeKnown ctx tb
                let pairT   = mapTypeKnown ctx (Fable.Type.Tuple([ta; tb], false))
                match pairT with
                | WType.Ref(pairIdx, _) ->
                    let aArrIdx = getOrAddArrayType ctx aT
                    let bArrIdx = getOrAddArrayType ctx bT
                    let aArrRefT = WType.Ref(aArrIdx, false)
                    let bArrRefT = WType.Ref(bArrIdx, false)
                    let arrATupleWT = WType.Ref(aArrIdx, false)
                    let arrBTupleWT = WType.Ref(bArrIdx, false)
                    let _ = mapTypeKnown ctx (Fable.Type.Tuple([Fable.Type.Array(ta, Fable.ArrayKind.MutableArray); Fable.Type.Array(tb, Fable.ArrayKind.MutableArray)], false))
                    let resultTupleIdx = getOrAddTupleType ctx [arrATupleWT; arrBTupleWT]
                    let resultTupleRefT = WType.Ref(resultTupleIdx, false)
                    let pairArrIdx = getOrAddArrayType ctx pairT
                    let pairArrRefT = WType.Ref(pairArrIdx, false)
                    let wArr  = transform ctx arrArg
                    let gen = LabelGen("aunz")
                    Some(wasm {
                        let! src = wArr
                        let! n = arrayLen src
                        let! aArr = arrayNew aArrIdx n (makeNumericZero aT) aArrRefT
                        let! bArr = arrayNew bArrIdx n (makeNumericZero bT) bArrRefT
                        do! Wasm.for_ n (fun idx -> wasm {
                            let! p = arrayGet src idx pairT
                            do! arraySet aArr idx (structGet p 0 aT)
                            return! arraySet bArr idx (structGet p 1 bT)
                        })
                        return structNew resultTupleIdx [aArr; bArr] resultTupleRefT
                    })
                | _ -> None
            | _ -> None
        | _ -> None
    // ── Array.map2 f arr1 arr2 — apply f to each pair, collecting results ──
    | "map2" ->
        match fableArgs with
        | (BinaryLambda(farg1, farg2, fbody) :: arr1Arg :: arr2Arg :: _) ->
            match arrElemT arr1Arg.Type, arrElemT arr2Arg.Type with
            | Some e1FT, Some e2FT ->
                let e1T = mapTypeKnown ctx e1FT
                let e2T = mapTypeKnown ctx e2FT
                let resultFT = fbody.Type
                let resultET = mapTypeKnown ctx resultFT
                let resArrIdx  = getOrAddArrayType ctx resultET
                let resArrRefT = WType.Ref(resArrIdx, false)
                let arr1ArrIdx = getOrAddArrayType ctx e1T
                let arr2ArrIdx = getOrAddArrayType ctx e2T
                let wArr1 = transform ctx arr1Arg
                let wArr2 = transform ctx arr2Arg
                let wBody = transform ctx fbody
                let gen = LabelGen("am2")
                Some(wasm {
                    let! a1 = wArr1
                    let! a2 = wArr2
                    let! n = arrayLen a1
                    let! res = arrayNew resArrIdx n (makeNumericZero resultET) resArrRefT
                    do! Wasm.for_ n (fun idx ->
                            arraySet res idx
                                (WExpr.Let(farg1.Name, arrayGet a1 idx e1T,
                                    WExpr.Let(farg2.Name, arrayGet a2 idx e2T,
                                        wBody))))
                    return res
                })
            | _ -> None
        | _ -> None
    // ── Array.sortWith cmp arr — insertion sort with inline comparator ──
    | "sortWith" ->
        let cmpArgOpt = fableArgs |> List.tryHead
        let cmpParts =
            match cmpArgOpt with
            | None -> None
            | Some (BinaryLambda(arg1, arg2, body)) ->
                Some(arg1, arg2, body)
            | _ -> None
        match cmpParts with
        | None -> None
        | Some(farg1, farg2, fbody) ->
        let arrArgOpt = fableArgs |> List.tryFind (fun a -> arrElemT a.Type |> Option.isSome)
        match arrArgOpt with
        | None -> None
        | Some arrArg ->
        match arrElemT arrArg.Type with
        | None -> None
        | Some elemFableT ->
        let elemT      = mapTypeKnown ctx elemFableT
        let (arrElemT, arrDefault) =
            match elemT with
            | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
            | t -> t, makeNumericZero t
        let readElem arrExpr idxExpr =
            match elemT with
            | WType.Ref(idx, false) ->
                cast (arrayGet arrExpr idxExpr arrElemT) (WType.Ref(idx, false))
            | _ -> arrayGet arrExpr idxExpr elemT
        let writeElem arrExpr idxExpr valExpr =
            arraySet arrExpr idxExpr valExpr
        let arrTypeIdx = getOrAddArrayType ctx arrElemT
        let arrRefT    = WType.Ref(arrTypeIdx, false)
        let wArr       = transform ctx arrArg
        let ctx'       = ctx.WithLocal(farg1.Name, elemT)
        let ctx''      = ctx'.WithLocal(farg2.Name, elemT)
        let wCmp       = transform ctx'' fbody
        let inlineCmp aExpr bExpr =
            WExpr.Let(farg1.Name, aExpr,
                WExpr.Let(farg2.Name, bExpr,
                    wCmp))
        let gen = LabelGen("asw")
        Some(wasm {
            let! src = wArr
            let! len = arrayLen src
            let! res = arrayNew arrTypeIdx len arrDefault arrRefT
            do! arrayCopy res (i32Const 0) src (i32Const 0) len
            do! mergeSortInPlace res len elemT readElem writeElem inlineCmp
            return res
        })
    // ── Array.sort / sortDescending / sortBy / sortByDescending / sortInPlace / sortInPlaceBy ──
    // The ordering is the comparer Fable passes (`ObjectExpr { Compare = … }`: numbers, strings, structural),
    // applied to the key (the projection, evaluated once per element, or the element itself).  Stable;
    // Descending swaps the comparer's operands.  The copying variants return a fresh array.
    | "sort" | "sortDescending" | "sortBy" | "sortByDescending" | "sortInPlace" | "sortInPlaceBy" ->
        let descending, inPlace = selector.EndsWith "Descending", selector.StartsWith "sortInPlace"
        let parts =
            match fableArgs with
            | [ UnaryLambda(x, projBody); arrArg; cmpArg ] -> Some(Some(x, projBody), arrArg, cmpArg)
            | [ arrArg; cmpArg ] -> Some(None, arrArg, cmpArg)
            | _ -> None
        match parts with
        | Some(proj, arrArg, ComparerLambda(ca, cb, cbody)) ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let keyT = match proj with Some(_, body) -> mapTypeKnown ctx body.Type | None -> elemT
                let elem, key = arrayAccess ctx elemT, arrayAccess ctx keyT
                let wCmp = transform (ctx.WithLocal(ca.Name, keyT).WithLocal(cb.Name, keyT)) cbody
                let ordered ka kb = WExpr.Let(ca.Name, ka, WExpr.Let(cb.Name, kb, wCmp))
                let cmp = if descending then (fun a b -> ordered b a) else ordered
                let wProj = proj |> Option.map (fun (x, body) -> x, transform (ctx.WithLocal(x.Name, elemT)) body)
                let sortStmt (arr: WExpr) (len: WExpr) : WExpr =
                    match wProj with
                    | None -> mergeSortInPlace arr len elemT elem.Read elem.Write cmp
                    | Some(x, projBody) ->
                        wasm {
                            let! keys = arrayNew key.TypeIdx len key.Default key.RefT
                            do! indexedLoop (LabelGen "akey") len (fun i ->
                                    key.Write keys i (WExpr.Let(x.Name, elem.Read arr i, projBody)))
                            do! mergeSortKeyed arr len elemT elem.Read elem.Write (Some(keys, keyT, key.Read, key.Write)) cmp
                        }
                if inPlace then
                    Some(wasm {
                        let! src = transform ctx arrArg
                        do! sortStmt src (arrayLen src)
                    })
                else
                    Some(wasm {
                        let! src = transform ctx arrArg
                        let! len = arrayLen src
                        let! copy = arrayNew elem.TypeIdx len elem.Default elem.RefT
                        do! arrayCopy copy (i32Const 0) src (i32Const 0) len
                        do! sortStmt copy len
                        return copy
                    })
            | None -> None
        | _ -> None
    // ── Array.findIndex pred arr — first index where pred holds, -1 if none ──
    | "findIndex" | "tryFindIndex" ->
        match fableArgs with
        | [UnaryLambda(farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a          = mkArrayShape elemT arrTypeIdx
                let gen        = LabelGen("afidx")
                let wArr       = transform ctx arrArg
                let ctx'       = ctx.WithLocal(farg.Name, elemT)
                let wPred      = transform ctx' fbody
                let index =
                    arraySearch gen a wArr WType.I32
                        (fun elem -> WExpr.Let(farg.Name, elem, wPred))
                        (fun idx _elem -> idx)
                        (i32Const -1)
                // findIndex raises KeyNotFoundException when nothing matches; tryFindIndex is `int option`
                // (a wrapper struct for the primitive, null = None)
                let isTry = (selector = "tryFindIndex")
                let optionIdx = getOrAddOptionType ctx WType.I32
                Some(wasm {
                    let! i = index
                    let missing = ltS i (i32Const 0)
                    return! (if isTry then wasmIf missing (WExpr.Const(WConst.Null ty)) (structNew optionIdx [ i ] ty)
                             else wasmIf missing (WExpr.Throw WExpr.Nop) i)
                })
            | None -> None
        | _ -> None
    // ── Array.contains needle arr — true (1) if any element equals needle ──
    | "contains" ->
        let tryGetNeedleAndArr () =
            match fableArgs |> List.tryFindIndex (fun a -> arrElemT a.Type |> Option.isSome) with
            | Some idx when idx > 0 -> Some(fableArgs.[idx - 1], fableArgs.[idx])
            | _ -> None
        match tryGetNeedleAndArr () with
        | Some(needle, arrArg) ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let elemT      = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let a          = mkArrayShape elemT arrTypeIdx
                let gen        = LabelGen("acont")
                let wArr       = transform ctx arrArg
                let wNeedle    = transform ctx needle
                Some(wasm {
                    let! needle = wNeedle
                    return! arrayExists gen a wArr
                        (fun elem -> eq elem needle)
                })
            | None -> None
        | None -> None
    // ── Array.scan f init arr — fold storing all intermediate accumulators ─────
    | "scan" ->
        match fableArgs with
        | [BinaryLambda(farg1, farg2, fbody); initArg; arrArg]
        | [BinaryLambda(farg1, farg2, fbody); initArg; arrArg; _] ->
            match arrElemT arrArg.Type with
            | Some elemFableT ->
                let accumFableT = initArg.Type
                let elemT    = mapTypeKnown ctx elemFableT
                let accT     = mapTypeKnown ctx accumFableT
                let arrTypeIdx  = getOrAddArrayType ctx elemT
                let accArrIdx = getOrAddArrayType ctx accT
                let srcA      = mkArrayShape elemT arrTypeIdx
                let srcRefT  = WType.Ref(arrTypeIdx, false)
                let accArrRefT = WType.Ref(accArrIdx, false)
                let wArr  = transform ctx arrArg
                let wInit = transform ctx initArg
                let gen = LabelGen("scan")
                let ctx'  = ctx.WithLocal(farg1.Name, accT).WithLocal(farg2.Name, elemT)
                let wBody = transform ctx' fbody
                Some(wasm {
                    let! src = wArr
                    let! res = arrayNew accArrIdx (add (arrayLen src) (i32Const 1)) (makeNumericZero accT) accArrRefT
                    let! acc = mutTy accT wInit
                    do! arraySet res (i32Const 0) acc.Val
                    do! arrayIteri gen srcA src (fun idx elem ->
                            WExpr.Let(farg1.Name, acc.Val,
                                WExpr.Let(farg2.Name, elem, wasm {
                                    do! acc.Set(wBody)
                                    return! arraySet res (add idx (i32Const 1)) acc.Val
                                })))
                    return res
                })
            | None -> None
        | _ -> None
    // ── Array.toList arr — convert GC array to linked list (right-to-left cons) ──
    | "toList" when (match resultFableType with | ListOf _ -> true | _ -> false) ->
        match List.tryHead fableArgs with
        | None -> None
        | Some arrArg ->
        match arrElemT arrArg.Type with
        | None -> None
        | Some elemFableT ->
        match tryListTypeInfoFromElemType ctx elemFableT with
        | None -> None
        | Some(elemT, consIdx) ->
            let s      = mkListShape elemT consIdx
            let gen    = LabelGen("atl")
            let wArr   = transform ctx arrArg
            let arrRefT = mapTypeKnown ctx arrArg.Type
            Some(wasm {
                let! a = wArr
                return! arrayToListRev gen s a (arrayLen a)
                    (fun ar i -> arrayGet ar i elemT)
            })
    // ── Array.append arr1 arr2 — new array = arr1 ++ arr2 ────────────────────
    | "append" ->
        match fableArgs with
        | [arrArg1; _]
        | [arrArg1; _; _] when arrElemT arrArg1.Type |> Option.isSome ->
            match arrElemT arrArg1.Type with
            | Some elemFableT ->
                let elemT = mapTypeKnown ctx elemFableT
                let arrTypeIdx = getOrAddArrayType ctx elemT
                let arrRefT = WType.Ref(arrTypeIdx, false)
                let wArr1 = transform ctx arrArg1
                let wArr2 = transform ctx fableArgs.[1]
                let gen = LabelGen("app")
                Some(wasm {
                    let! a1 = wArr1
                    let! a2 = wArr2
                    let! l1 = arrayLen a1
                    let! res = arrayNew arrTypeIdx (add l1 (arrayLen a2)) (makeNumericZero elemT) arrRefT
                    do! arrayCopy res (i32Const 0) a1 (i32Const 0) l1
                    do! arrayCopy res l1 a2 (i32Const 0) (arrayLen a2)
                    return res
                })
            | None -> None
        | _ -> None
    // ── Array.choose f arr — apply f, keep Some values, unwrap ──────────────
    | "choose" ->
        match fableArgs with
        | [UnaryLambda(farg, fbody); arrArg]
        | [UnaryLambda(farg, fbody); arrArg; _]
        | [_; UnaryLambda(farg, fbody); arrArg] ->
            match arrElemT arrArg.Type with
            | Some inElemFableT ->
                let outElemFableT =
                    match resultFableType with
                    | ArrayOf t -> t
                    | _ -> Fable.Type.Any
                let inElemT    = mapTypeKnown ctx inElemFableT
                let outElemT   = mapTypeKnown ctx outElemFableT
                let inArrIdx   = getOrAddArrayType ctx inElemT
                let outArrIdx  = getOrAddArrayType ctx outElemT
                let inArrRefT  = WType.Ref(inArrIdx, false)
                let outArrRefT = WType.Ref(outArrIdx, false)
                let wArr       = transform ctx arrArg
                let ctx'       = ctx.WithLocal(farg.Name, inElemT)
                let wBody      = transform ctx' fbody
                let wBodyT     = mapTypeKnown ctx fbody.Type
                match wBodyT with
                | WType.Ref(optTypeIdx, _) ->
                    let optNullT   = WType.Ref(optTypeIdx, true)
                    let optNonNull = WType.Ref(optTypeIdx, false)
                    let inA        = mkArrayShape inElemT inArrIdx
                    let gen        = LabelGen("acho")
                    // Pass 1: count Somes
                    let countExpr src =
                        wasm {
                            let! cnt = mut (i32Const 0)
                            do! Wasm.for_ (arrayLen src) (fun i ->
                                    WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                                        let! opt = wBody
                                        return! wasmWhen (refIsNotNull opt)
                                            (cnt.Set(add cnt.Val (i32Const 1)))
                                    }))
                            return cnt.Val
                        }
                    // Pass 2: fill result
                    let fillExpr src res =
                        wasm {
                            let! wi = mut (i32Const 0)
                            do! Wasm.for_ (arrayLen src) (fun i ->
                                    WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                                        let! opt = wBody
                                        return! wasmWhen (refIsNotNull opt)
                                            (wasm {
                                                do! arraySet res wi.Val (OptionResultTransforms.unwrapSome opt optTypeIdx outElemT)
                                                return! wi.Set(add wi.Val (i32Const 1))
                                            })
                                    }))
                            return res
                        }
                    Some(wasm {
                        let! src = wArr
                        let! count = countExpr src
                        let! res = arrayNew outArrIdx count (makeNumericZero outElemT) outArrRefT
                        return! fillExpr src res
                    })
                // TODO: check AnyRef 
                | _ -> failwith("ArrayReplacements - choose - case not handled")
            | _ -> None
        | _ -> None
    // ── Array.collect f arr — apply f (returns array), concatenate results ───
    | "collect" ->
        match fableArgs with
        | [UnaryLambda(farg, fbody); arrArg]
        | [UnaryLambda(farg, fbody); arrArg; _] ->
            match arrElemT arrArg.Type with
            | Some inElemFableT ->
                let outElemFableT =
                    match resultFableType with
                    | ArrayOf t -> t
                    | _ -> Fable.Type.Any
                let inElemT    = mapTypeKnown ctx inElemFableT
                let outElemT   = mapTypeKnown ctx outElemFableT
                let inArrIdx   = getOrAddArrayType ctx inElemT
                let outArrIdx  = getOrAddArrayType ctx outElemT
                let inArrRefT  = WType.Ref(inArrIdx, false)
                let outArrRefT = WType.Ref(outArrIdx, false)
                let wArr       = transform ctx arrArg
                let ctx'       = ctx.WithLocal(farg.Name, inElemT)
                let wBody      = transform ctx' fbody
                let gen = LabelGen("acol")
                // Pass 1: compute total output length
                let countExpr src =
                    wasm {
                        let! tot = mut (i32Const 0)
                        do! Wasm.for_ (arrayLen src) (fun i ->
                                WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                                    let! sub = wBody
                                    return! tot.Set(add tot.Val (arrayLen sub))
                                }))
                        return tot.Val
                    }
                // Pass 2: allocate + fill
                let fillExpr src res =
                    wasm {
                        let! out = mut (i32Const 0)
                        do! Wasm.for_ (arrayLen src) (fun i ->
                                WExpr.Let(farg.Name, arrayGet src i inElemT, wasm {
                                    let! sub = wBody
                                    do! arrayCopy res out.Val sub (i32Const 0) (arrayLen sub)
                                    return! out.Set(add out.Val (arrayLen sub))
                                }))
                        return res
                    }
                Some(wasm {
                    let! src = wArr
                    let! count = countExpr src
                    let! res = arrayNew outArrIdx count (makeNumericZero outElemT) outArrRefT
                    return! fillExpr src res
                })
            | None -> None
        | _ -> None
    | _ -> None
// These arrive as Get(arr, FieldGet "filter/some/every/forEach") as callee
// ─────────────────────────────────────────────────────────────────

/// Handle array instance-style calls: arr.filter/some/every/forEach(lambda)
/// fieldName matches lowercase JS method name; returns None to fall through.
let tryArrayInstanceCall
        (transform: TransformFn)
        (ctx: Ctx)
        (fieldName: string)
        (arrExpr: Fable.Expr)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    let ty = mapTypeKnown ctx resultFableType
    match fieldName, fableArgs with
    | ("filter"), [UnaryLambda(farg, fbody)] ->
        match arrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("ifilt")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(arrayFilter gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None
    | ("some"), [UnaryLambda(farg, fbody)] ->
        match arrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("isome")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(arrayExists gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None
    | ("every"), [UnaryLambda(farg, fbody)] ->
        match arrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("ievery")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wPred = transform ctx' fbody
            Some(arrayForAll gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wPred)))
        | None -> None
    | ("forEach"), [UnaryLambda(farg, fbody)] ->
        match arrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let a = mkArrayShape elemT arrTypeIdx
            let gen = LabelGen("iforeach")
            let wArr = transform ctx arrExpr
            let ctx' = ctx.WithLocal(farg.Name, elemT)
            let wBody = transform ctx' fbody
            Some(arrayIter gen a wArr
                (fun elem -> WExpr.Let(farg.Name, elem, wBody)))
        | None -> None
    // Array.reduce f arr → fold from first element as accumulator
    | ("reduce" | "reduceRight"), [BinaryLambda(farg1, farg2, fbody)] ->
        match arrElemT arrExpr.Type with
        | Some elemFableT ->
            let elemT      = mapTypeKnown ctx elemFableT
            let arrTypeIdx = getOrAddArrayType ctx elemT
            let gen        = LabelGen("ired")
            let wArr       = transform ctx arrExpr
            let ctx'       = ctx.WithLocal(farg1.Name, elemT).WithLocal(farg2.Name, elemT)
            let wBody      = transform ctx' fbody
            Some(wasm {
                let! src = wArr
                let! len = arrayLen src
                let! acc = mutTy elemT (arrayGet src (i32Const 0) elemT)
                let! i = mut (i32Const 1)
                while! (ltS i.Val len) do
                    do! acc.Set(WExpr.Let(farg1.Name, acc.Val,
                            WExpr.Let(farg2.Name, arrayGet src i.Val elemT, wBody)))
                    do! i.Set(add i.Val (i32Const 1))
                return acc.Val
            })
        | None -> None
    | _ -> None


// ─────────────────────────────────────────────────────────────────────────────
// Unified entry point (preferred over calling individual try* functions)
// ─────────────────────────────────────────────────────────────────────────────

/// Primary dispatch entry: routes all Array.* selectors to the correct handler.
let tryArr
        (transform       : TransformFn)
        (ctx             : Ctx)
        (selector        : string)
        (fableArgs       : Fable.Expr list)
        (resultFableType : Fable.Type)
        : WExpr option =
    let wArgs = fableArgs |> List.map (transform ctx)
    tryArrayInline transform ctx selector fableArgs wArgs resultFableType
