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

let private (|SeqCall|_|) (e: Fable.Expr) =
    match e with
    | Call(Import({ Selector = sel; Path = path }, _, _), info, _, _) when path.EndsWith "Seq.fs" -> Some(sel, info.Args)
    | _ -> None

let private (|RangeCall|_|) (e: Fable.Expr) =
    match e with
    | Call(Import({ Selector = "rangeDouble"; Path = path }, _, _), info, _, _) when path.EndsWith "Range.fs" ->
        (match info.Args with [ start; step; stop ] -> Some(start, step, stop) | _ -> None)
    | _ -> None

/// A shape `fuse` starts from (as opposed to a plain list / array, which other handlers already convert directly).
let private isProducer (e: Fable.Expr) =
    match strip e with
    | SeqCall _ | RangeCall _ -> true
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
    | SeqCall("empty", _) -> Some WExpr.Nop
    | SeqCall("singleton", [ x ]) -> Some(yieldTo (transform ctx x))
    | SeqCall("append", [ a; b ]) ->
        fuse transform ctx yieldTo a
        |> Option.bind (fun wa -> fuse transform ctx yieldTo b |> Option.map (fun wb -> WExpr.Sequence [ wa; wb ]))
    | SeqCall("collect", [ UnaryLambda(x, inner); src ]) ->
        fuse transform (bound x) yieldTo inner
        |> Option.bind (fun body -> fuse transform ctx (fun elem -> WExpr.Let(x.Name, elem, body)) src)
    | SeqCall("map", [ UnaryLambda(x, f); src ]) ->
        let wf = transform (bound x) f
        fuse transform ctx (fun elem -> WExpr.Let(x.Name, elem, yieldTo wf)) src
    | SeqCall("filter", [ UnaryLambda(x, pred); src ]) ->
        let wp = transform (bound x) pred
        let xT = mapTypeKnown ctx x.Type
        fuse transform ctx (fun elem -> WExpr.Let(x.Name, elem, wasmWhen wp (yieldTo (WExpr.LocalGet(x.Name, xT))))) src
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

/// `Seq.toList` / `Seq.toArray` (and `List.ofSeq` / `Array.ofSeq`) over a fusable producer.  The elements are
/// consed onto a reversed accumulator list, which is then turned around (list) or poured back to front into the array.
let trySeqFusionInline
        (transform: TransformFn)
        (ctx: Ctx)
        (selector: string)
        (fableArgs: Fable.Expr list)
        (resultFableType: Fable.Type) : WExpr option =
    let collect (t: Fable.Type) (src: Fable.Expr) (finish: ListShape -> WExpr -> WExpr) =
        tryListTypeInfoFromElemType ctx t
        |> Option.bind (fun (elemWT, consIdx) ->
            let s = mkListShape elemWT consIdx
            let acc = freshName ()
            let accGet = WExpr.LocalGet(acc, s.BaseTy)
            fuse transform ctx (fun elem -> WExpr.Assign(acc, s.Cons elem accGet)) src
            |> Option.map (fun body -> WExpr.LetMut(acc, s.Nil, WExpr.Sequence [ body; finish s accGet ])))
    match selector, fableArgs, resultFableType with
    | ("toList" | "ofSeq"), [ src ], Type.List t when isProducer src ->
        collect t src (fun s rev -> listRev (LabelGen "fzl") s rev)
    | ("toArray" | "ofSeq"), [ src ], Type.Array(t, _) when isProducer src ->
        collect t src (fun s rev ->
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
    | _ -> None
