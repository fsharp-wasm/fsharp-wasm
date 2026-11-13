/// Eager consumption of seq pipelines — list / array comprehensions, `[a .. b]`, `Seq.toList (Seq.collect …)`.
///
/// Fable emits these as a lazy `Seq.delay (fun () -> Seq.collect … (rangeDouble …))` chain.  Nothing here builds an
/// IEnumerator: the producer tree is walked once and every element is PUSHED into the consumer's `yieldTo`, so the
/// whole pipeline becomes plain loops (no closures, no allocation besides the result).  A shape that is not
/// understood returns None and the caller reports it as before — fusion never guesses.
module WasmGc.Transforms.SeqFusion

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core
open WasmGc.Runtime.Runtime
open WasmGc.Runtime.LoopHelpers
open WasmGc.Runtime.LoopPrimitives

open WasmGc.Patterns.ListShape
open WasmGc.Patterns.ListPatterns
open WasmGc.Patterns.ArrayOps

open WasmGc.Util.FableQuery

/// element → statement (void) that consumes it
type private Yield = WExpr -> WExpr

let rec private strip (e: Fable.Expr) = match e with TypeCast(inner, _) -> strip inner | _ -> e

/// A call into one of the collection modules: (module, selector, args).
let private (|StreamCall|_|) (e: Fable.Expr) =
    match e with
    | Call(Import({ Selector = sel; Path = path }, _, _), info, _, _) ->
        (match System.IO.Path.GetFileNameWithoutExtension path with
         | "Seq" | "List" | "Array" as stem -> Some(stem, sel, info.Args)
         | _ -> None)
    | _ -> None

let private (|SeqCall|_|) (e: Fable.Expr) =
    match e with
    | StreamCall("Seq", sel, args) -> Some(sel, args)
    | _ -> None

/// Effect-free expressions (conservative).  `List.map f (List.filter g xs)` is strict: all of `g` runs before any
/// of `f`.  Interleaving them per element, which fusion does, is only unobservable when both are pure.
let rec private isPure (e: Fable.Expr) : bool =
    match e with
    | Value((NumberConstant _ | StringConstant _ | BoolConstant _ | CharConstant _ | UnitConstant | ValueKind.Null _), _) -> true
    | Value(NewTuple(values, _), _) -> List.forall isPure values
    | IdentExpr i -> not i.IsMutable
    | TypeCast(inner, _) -> isPure inner
    | Operation(Binary(_, a, b), _, _, _) | Operation(Logical(_, a, b), _, _, _) -> isPure a && isPure b
    | Operation(Unary(_, a), _, _, _) -> isPure a
    | Get(inner, (TupleIndex _ | FieldGet _), _, _) -> isPure inner
    | IfThenElse(c, t, el, _) -> isPure c && isPure t && isPure el
    | Let(_, value, body) -> isPure value && isPure body
    | _ -> false

let private (|RangeCall|_|) (e: Fable.Expr) =
    match e with
    | Call(Import({ Selector = "rangeDouble"; Path = path }, _, _), info, _, _) when path.EndsWith "Range.fs" ->
        (match info.Args with [ start; step; stop ] -> Some(start, step, stop) | _ -> None)
    | _ -> None

/// A shape `fuse` starts from (as opposed to a plain list / array, which other handlers already convert directly).
let private isProducer (e: Fable.Expr) =
    match strip e with
    | SeqCall _ | RangeCall _ -> true
    | StreamCall(_, ("map" | "filter" | "where"), [ UnaryLambda _; _ ]) -> true      // a stage of a chain
    | _ -> false

let private isInt32 (t: Fable.Type) = match t with Type.Number(NumberKind.Int32, _) -> true | _ -> false

let private i64 (e: WExpr) = WExpr.Unary(WUnaryOp.ExtendI32S, e, WType.I64)
let private i64Const (n: int64) = WExpr.Const(WConst.I64 n)
let private cmp64 op a b = WExpr.Compare(op, a, b)

/// `start, step .. stop` over int32.  Counted in int64 so `stop = Int32.MaxValue` cannot wrap around; `step = 0` raises.
let private range (transform: TransformFn) (ctx: Ctx) (yieldTo: Yield) start step stop : WExpr =
    let ascending = match step with IntLit n -> Some(n > 0) | _ -> None
    wasm {
        let! i = mutTy WType.I64 (i64 (transform ctx start))
        let! stp = i64 (transform ctx step)
        let! lim = i64 (transform ctx stop)
        do! wasmWhen (cmp64 WCompareOp.Eq stp (i64Const 0L)) (WExpr.Throw WExpr.Nop)       // ArgumentException
        let up = cmp64 WCompareOp.LeS i.Val lim
        let down = cmp64 WCompareOp.GeS i.Val lim
        let guard =
            match ascending with
            | Some true -> up
            | Some false -> down
            | None -> wasmIf (cmp64 WCompareOp.GtS stp (i64Const 0L)) up down
        while! guard do
            do! yieldTo (WExpr.Unary(WUnaryOp.WrapI64, i.Val, WType.I32))
            do! i.Set(WExpr.Binary(WBinaryOp.Add, i.Val, stp, WType.I64))
    }

/// Walk the producer `e`, calling `yieldTo` for every element it generates.
let rec private fuse (transform: TransformFn) (ctx: Ctx) (yieldTo: Yield) (e: Fable.Expr) : WExpr option =
    let bound (x: Ident) = ctx.WithLocal(x.Name, mapTypeKnown ctx x.Type)
    match strip e with
    | SeqCall("delay", [ UnaryLambda(_, body) ]) -> fuse transform ctx yieldTo body
    // conversions between the collection kinds do not change the sequence of elements
    | StreamCall(_, ("toList" | "ofSeq" | "toArray" | "ofArray" | "ofList" | "toSeq"), [ x ]) -> fuse transform ctx yieldTo x
    // List.init / Array.init n f  =  f 0, f 1, … (f pure, so the evaluation order against other stages is unobservable)
    | StreamCall(stem, "init", [ n; UnaryLambda(x, f) ]) when stem <> "Seq" && isPure f ->
        let wf = transform (bound x) f
        Some(range transform ctx (fun i -> yieldTo (WExpr.Let(x.Name, i, wf))) (Value(NumberConstant(NumberValue.Int32 0, NumberInfo.Empty), None)) (Value(NumberConstant(NumberValue.Int32 1, NumberInfo.Empty), None)) (Operation(Binary(BinaryMinus, n, Value(NumberConstant(NumberValue.Int32 1, NumberInfo.Empty), None)), [], Type.Number(NumberKind.Int32, NumberInfo.Empty), None)))
    | SeqCall("empty", _) -> Some WExpr.Nop
    | SeqCall("singleton", [ x ]) -> Some(yieldTo (transform ctx x))
    | SeqCall("append", [ a; b ]) ->
        fuse transform ctx yieldTo a
        |> Option.bind (fun wa -> fuse transform ctx yieldTo b |> Option.map (fun wb -> WExpr.Sequence [ wa; wb ]))
    | SeqCall("collect", [ UnaryLambda(x, inner); src ]) ->
        fuse transform (bound x) yieldTo inner
        |> Option.bind (fun body -> fuse transform ctx (fun elem -> WExpr.Let(x.Name, elem, body)) src)
    | StreamCall(stem, "map", [ UnaryLambda(x, f); src ]) when stem = "Seq" || isPure f ->
        let wf = transform (bound x) f
        fuse transform ctx (fun elem -> WExpr.Let(x.Name, elem, yieldTo wf)) src
    | StreamCall(stem, ("filter" | "where"), [ UnaryLambda(x, pred); src ]) when stem = "Seq" || isPure pred ->
        let wp = transform (bound x) pred
        let xT = mapTypeKnown ctx x.Type
        fuse transform ctx (fun elem -> WExpr.Let(x.Name, elem, wasmWhen wp (yieldTo (WExpr.LocalGet(x.Name, xT))))) src
    // `a; b; seqExpr`: the statements run, then the sequence is walked (the `()` arm of a `match` inside a comprehension)
    | Sequential exprs when not exprs.IsEmpty ->
        let init, last = List.splitAt (exprs.Length - 1) exprs
        fuse transform ctx yieldTo last.Head
        |> Option.map (fun walked -> WExpr.Sequence((init |> List.map (transform ctx)) @ [ walked ]))
    | IfThenElse(guard, thenE, elseE, _) ->
        fuse transform ctx yieldTo thenE
        |> Option.bind (fun wt ->
            fuse transform ctx yieldTo elseE |> Option.map (fun we -> WExpr.If(transform ctx guard, wt, we, WType.Void)))
    | Let(x, value, body) ->
        fuse transform (bound x) yieldTo body |> Option.map (fun wb -> WExpr.Let(x.Name, transform ctx value, wb))
    | RangeCall(start, step, stop) as r when (match r.Type with ListOf t -> isInt32 t | _ -> false) ->
        Some(range transform ctx yieldTo start step stop)
    | src ->
        match src.Type with
        | Type.List _ ->
            tryListTypeInfo ctx src
            |> Option.map (fun (elemWT, consIdx) ->
                listIter (LabelGen "fz") (mkListShape elemWT consIdx) (transform ctx src) yieldTo)
        // a ResizeArray: the first Count elements of its data array (the length is read once, before the walk)
        | Type.Array(t, ArrayKind.ResizeArray) ->
            let elemWT = mapTypeKnown ctx t
            let arrIdx, _ = getOrAddResizeArrayType ctx elemWT
            let a = mkArrayShape elemWT arrIdx
            Some(wasm {
                let! rav = transform ctx src
                let! arr = WExpr.Cast(WExpr.StructGet(rav, 0, WType.Ref(arrIdx, true)), WType.Ref(arrIdx, false))
                let! n = WExpr.StructGet(rav, 1, WType.I32)
                let! i = mut (i32Const 0)
                while! (ltS i.Val n) do
                    do! yieldTo (a.Get(arr, i.Val))
                    do! i.Set(add i.Val (i32Const 1))
            })
        | Type.Array(t, _) ->
            let elemWT = mapTypeKnown ctx t
            let a = mkArrayShape elemWT (getOrAddArrayType ctx elemWT)
            Some(wasm {
                let! arr = transform ctx src
                let! i = mut (i32Const 0)
                while! (ltS i.Val (a.Len arr)) do
                    do! yieldTo (a.Get(arr, i.Val))
                    do! i.Set(add i.Val (i32Const 1))
            })
        | _ -> None

/// A call whose result is a fused pipeline: the chain `[a .. b] |> List.map f |> List.filter g |> List.fold h 0`
/// becomes ONE loop (no intermediate lists), and `Seq.toList` / `Seq.toArray` over any seq expression likewise.
/// Stages of `List` / `Array` must be pure (see `isPure`); the consumer's own lambda may do anything.
/// None = not a fusable shape: the call is compiled the ordinary way.
let trySeqFusionInline (transform: TransformFn) (ctx: Ctx) (call: Fable.Expr) : WExpr option =
    match call with
    | StreamCall(stem, selector, args) ->
        // the elements are consed onto a reversed accumulator list, which is turned around (list) or poured back to
        // front into the array
        let collect (t: Fable.Type) (producer: Fable.Expr) (finish: ListShape -> WExpr -> WExpr) =
            tryListTypeInfoFromElemType ctx t
            |> Option.bind (fun (elemWT, consIdx) ->
                let s = mkListShape elemWT consIdx
                let acc = freshName ()
                let accGet = WExpr.LocalGet(acc, s.BaseTy)
                fuse transform ctx (fun elem -> WExpr.Assign(acc, s.Cons elem accGet)) producer
                |> Option.map (fun body -> WExpr.LetMut(acc, s.Nil, WExpr.Sequence [ body; finish s accGet ])))
        let toList (t: Fable.Type) (producer: Fable.Expr) = collect t producer (fun s rev -> listRevInPlace (LabelGen "fzl") s rev)
        let toArray (t: Fable.Type) (producer: Fable.Expr) =
            collect t producer (fun s rev ->
                let elemWT = mapTypeKnown ctx t
                let arrTypeIdx = getOrAddArrayType ctx elemWT
                let a, gen = mkArrayShape elemWT arrTypeIdx, LabelGen "fza"
                wasm {
                    let! len = listLength gen s rev
                    let! arr = arrayNew arrTypeIdx len (makeNumericZero elemWT) (WType.Ref(arrTypeIdx, false))
                    let! i = mut (sub len (i32Const 1))
                    do! listIter gen s rev (fun elem -> sequence [ a.Set(arr, i.Val, elem); i.Set(sub i.Val (i32Const 1)) ])
                    return arr
                })
        // a consumer folds the elements of `src` into an accumulator
        let consume (src: Fable.Expr) (init: WExpr) (accT: WType) (step: WExpr -> WExpr -> WExpr) =
            let acc = freshName ()
            let accGet = WExpr.LocalGet(acc, accT)
            fuse transform ctx (fun elem -> WExpr.Assign(acc, step accGet elem)) src
            |> Option.map (fun body -> WExpr.LetMut(acc, init, WExpr.Sequence [ body; accGet ]))
        let numeric (t: Fable.Type) = match mapTypeKnown ctx t with WType.I32 | WType.I64 | WType.F32 | WType.F64 as w -> Some w | _ -> None
        match stem, selector, args, call.Type with
        // stages that materialise their result
        | ("List" | "Array"), ("map" | "filter" | "where"), [ UnaryLambda(_, f); src ], Type.List t when isProducer src && isPure f -> toList t call
        | ("List" | "Array"), ("map" | "filter" | "where"), [ UnaryLambda(_, f); src ], Type.Array(t, _) when isProducer src && isPure f -> toArray t call
        | _, ("toList" | "ofSeq"), [ src ], Type.List t when isProducer src -> toList t src
        | _, ("toArray" | "ofSeq"), [ src ], Type.Array(t, _) when isProducer src -> toArray t src
        // consumers
        | _, "fold", [ BinaryLambda(a, x, body); init; src ], accFT when isProducer src ->
            let accT = mapTypeKnown ctx accFT
            let elemT = match src.Type with ListOf et | ArrayOf et -> mapTypeKnown ctx et | _ -> WType.I32
            let wBody = transform (ctx.WithLocal(a.Name, accT).WithLocal(x.Name, elemT)) body
            consume src (transform ctx init) accT (fun acc elem -> WExpr.Let(a.Name, acc, WExpr.Let(x.Name, elem, wBody)))
        | _, "sum", (src :: _), accFT when isProducer src ->
            numeric accFT |> Option.bind (fun accT -> consume src (makeNumericZero accT) accT (fun acc elem -> checkedAdd acc elem accT))
        | _, "sumBy", [ UnaryLambda(x, body); src ], accFT when isProducer src ->
            numeric accFT |> Option.bind (fun accT ->
                let elemT = match src.Type with ListOf et | ArrayOf et -> mapTypeKnown ctx et | _ -> WType.I32
                let wBody = transform (ctx.WithLocal(x.Name, elemT)) body
                consume src (makeNumericZero accT) accT (fun acc elem -> checkedAdd acc (WExpr.Let(x.Name, elem, wBody)) accT))
        | _, ("length" | "count"), [ src ], _ when isProducer src ->
            consume src (i32Const 0) WType.I32 (fun acc _ -> add acc (i32Const 1))
        | _ -> None
    | _ -> None
