/// ResizeArray<T> (`List<T>`) operations.  A ResizeArray is the struct { data: array (the capacity); len: i32 }; the Fable
/// frontend emits its members as JS array calls (`slice` = ToArray, `splice` = Insert / RemoveAt, `sort`, `reverse`) and
/// as Util / Array library imports (`clear`, `addRangeInPlace`, `removeInPlace`, `indexOf`).  `push` (Add), `Count` and the
/// indexer are in TransformExpr.
module WasmGc.Transforms.ResizeArrayOps

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder
open WasmGc.Builder.Core
open WasmGc.Runtime.Runtime
open WasmGc.Runtime.Equality
open WasmGc.Runtime.LoopHelpers
open WasmGc.Runtime.LoopPrimitives
open WasmGc.Patterns.ListShape
open WasmGc.Patterns.ListPatterns
open WasmGc.Util.FableQuery
open WasmGc.Transforms.ArrayReplacements

type private Rav = { ElemT: WType; ArrIdx: int; RavIdx: int }

let private ravOf (ctx: Ctx) (t: Fable.Type) : Rav option =
    match t with
    | Fable.Type.Array(e, Fable.ArrayKind.ResizeArray) ->
        let elemT = mapTypeKnown ctx e
        let arrIdx, ravIdx = getOrAddResizeArrayType ctx elemT
        Some { ElemT = elemT; ArrIdx = arrIdx; RavIdx = ravIdx }
    | _ -> None

let private dataOf (r: Rav) (rav: WExpr) : WExpr =
    WExpr.Cast(WExpr.StructGet(rav, 0, WType.Ref(r.ArrIdx, true)), WType.Ref(r.ArrIdx, false))

let private lenOf (rav: WExpr) : WExpr = WExpr.StructGet(rav, 1, WType.I32)
let private setLen (rav: WExpr) (n: WExpr) : WExpr = WExpr.StructSet(rav, 1, n)

/// Room for `needed` elements (a local or constant: it is read twice): the data array at least doubles when too small.
let private ensureCapacity (r: Rav) (rav: WExpr) (needed: WExpr) : WExpr =
    wasm {
        let! d = dataOf r rav
        let! cap = arrayLen d
        do! WExpr.If(needed >. cap,
                wasm {
                    let! doubled = cap +. cap
                    let! newCap = wasmIf (needed >. doubled) needed doubled
                    let! newDat = WExpr.ArrayNew(r.ArrIdx, newCap, makeNumericZero r.ElemT, WType.Ref(r.ArrIdx, false))
                    do! arrayCopy newDat (i32Const 0) d (i32Const 0) (lenOf rav)
                    return! WExpr.StructSet(rav, 0, newDat)
                }, WExpr.Nop, WType.Void)
    }

/// Append one element.
let private push (r: Rav) (rav: WExpr) (value: WExpr) : WExpr =
    wasm {
        let! n = lenOf rav
        do! ensureCapacity r rav (n +. i32Const 1)
        do! arraySet (dataOf r rav) n value
        do! setLen rav (n +. i32Const 1)
    }

/// Shift the elements from `from` to the end by `delta` places (negative: left), then record the new length.
let private shiftTail (r: Rav) (rav: WExpr) (from: WExpr) (delta: WExpr) : WExpr =
    wasm {
        let! n = lenOf rav
        do! arrayCopy (dataOf r rav) (from +. delta) (dataOf r rav) from (n -. from)
        do! setLen rav (n +. delta)
    }

let private toArray (r: Rav) (wRav: WExpr) : WExpr =
    wasm {
        let! rav = wRav
        let! n = lenOf rav
        let! dst = arrayNew r.ArrIdx n (makeNumericZero r.ElemT) (WType.Ref(r.ArrIdx, false))
        do! arrayCopy dst (i32Const 0) (dataOf r rav) (i32Const 0) n
        return dst
    }

let private reverse (r: Rav) (wRav: WExpr) : WExpr =
    wasm {
        let! rav = wRav
        let! d = dataOf r rav
        let! n = lenOf rav
        let! i = mut (i32Const 0)
        while (i.Val <. (n -. i.Val -. i32Const 1)) do
            let! tmp = arrayGet d i.Val r.ElemT
            do! arraySet d i.Val (arrayGet d (n -. i.Val -. i32Const 1) r.ElemT)
            do! arraySet d (n -. i.Val -. i32Const 1) tmp
            do! i.Set(i.Val +. i32Const 1)
    }

/// First index of an element equal to `item`, or -1.
let private indexOf (ctx: Ctx) (r: Rav) (wRav: WExpr) (item: WExpr) : WExpr =
    wasm {
        let! rav = wRav
        let! x = item
        let! d = dataOf r rav
        let! n = lenOf rav
        let! i = mut (i32Const 0)
        let! found = mut (i32Const -1)
        while ((found.Val <. i32Const 0) &&. (i.Val <. n)) do
            do! WExpr.If(structuralEquals ctx (arrayGet d i.Val r.ElemT) x,
                         found.Set i.Val, WExpr.Nop, WType.Void)
            do! i.Set(i.Val +. i32Const 1)
        return found.Val
    }

/// Statement appending the elements of `source` (a list, a `seq<'T>`, an array or a ResizeArray) to a ResizeArray.
let private addRangeTo (transform: Ctx -> Fable.Expr -> WExpr) (ctx: Ctx) (r: Rav) (source: Fable.Expr) : (WExpr -> WExpr) option =
    // a list, or a `seq<'T>` (AddRange takes an IEnumerable): a seq is a list here
    let addList (elemT: Fable.Type) =
        tryListTypeInfoFromElemType ctx elemT
        |> Option.map (fun (listElemT, consIdx) ->
            let s = mkListShape listElemT consIdx
            fun (rav: WExpr) -> listIter (LabelGen "radd") s (transform ctx source) (fun elem -> push r rav elem))
    match source.Type with
    | Fable.Type.List elemT -> addList elemT
    | Fable.Type.DeclaredType(_, [ elemT ]) when isSeqType source.Type -> addList elemT
    | Fable.Type.Array(_, Fable.ArrayKind.ResizeArray) ->
        ravOf ctx source.Type
        |> Option.map (fun src ->
            fun (rav: WExpr) ->
                wasm {
                    let! from = transform ctx source
                    let! count = lenOf from
                    let! n = lenOf rav
                    do! ensureCapacity r rav (n +. count)
                    do! arrayCopy (dataOf r rav) n (dataOf src from) (i32Const 0) count
                    do! setLen rav (n +. count)
                })
    | Fable.Type.Array _ ->
        Some(fun (rav: WExpr) ->
            wasm {
                let! from = transform ctx source
                let! count = arrayLen from
                let! n = lenOf rav
                do! ensureCapacity r rav (n +. count)
                do! arrayCopy (dataOf r rav) n from (i32Const 0) count
                do! setLen rav (n +. count)
            })
    | _ -> None

/// `ResizeArray<T>()` and `ResizeArray<T>(capacity)`: empty, room for four (the capacity is only a hint).
let emptyOf (ctx: Ctx) (elemType: Fable.Type) : WExpr =
    let elemT = mapTypeKnown ctx elemType
    let arrIdx, ravIdx = getOrAddResizeArrayType ctx elemT
    WExpr.StructNew(ravIdx, [ WExpr.ArrayNew(arrIdx, i32Const 4, makeNumericZero elemT, WType.Ref(arrIdx, false)); i32Zero ], WType.Ref(ravIdx, false))

/// A ResizeArray holding the given values (`ResizeArray [ a; b ]` with literal elements).
let ofValues (ctx: Ctx) (elemType: Fable.Type) (values: WExpr list) : WExpr =
    match values with
    | [] -> emptyOf ctx elemType
    | _ ->
        let elemT = mapTypeKnown ctx elemType
        let arrIdx, ravIdx = getOrAddResizeArrayType ctx elemT
        WExpr.StructNew(ravIdx, [ WExpr.ArrayNewFixed(arrIdx, values, WType.Ref(arrIdx, false)); i32Const values.Length ], WType.Ref(ravIdx, false))

/// `ResizeArray<T>(source)`: a copy of the elements of a list, seq, array or ResizeArray.
let ofSource (transform: Ctx -> Fable.Expr -> WExpr) (ctx: Ctx) (elemType: Fable.Type) (source: Fable.Expr) : WExpr option =
    match ravOf ctx (Fable.Type.Array(elemType, Fable.ArrayKind.ResizeArray)) with
    | None -> None
    | Some r ->
        addRangeTo transform ctx r source
        |> Option.map (fun add ->
            wasm {
                let! rav = emptyOf ctx elemType
                do! add rav
                return rav
            })

/// Instance members the frontend emits as JS array methods on a ResizeArray receiver.
let tryInstance
        (transform: Ctx -> Fable.Expr -> WExpr)
        (ctx: Ctx)
        (name: string)
        (receiver: Fable.Expr)
        (args: Fable.Expr list)
        : WExpr option =
    match ravOf ctx receiver.Type, name, args with
    // ToArray()
    | Some r, "slice", [] -> Some(toArray r (transform ctx receiver))
    | Some r, "reverse", [] -> Some(reverse r (transform ctx receiver))
    // Sort() / Sort(Comparison): the comparison is a function of two elements, > 0 when the first must come after
    | Some r, "sort", [ BinaryLambda(ca, cb, cbody) ] ->
        let elem = arrayAccess ctx r.ElemT
        let wCmp = transform (ctx.WithLocal(ca.Name, r.ElemT).WithLocal(cb.Name, r.ElemT)) cbody
        let cmp a b = WExpr.Let(ca.Name, a, WExpr.Let(cb.Name, b, wCmp))
        Some(wasm {
            let! rav = transform ctx receiver
            do! mergeSortInPlace (dataOf r rav) (lenOf rav) r.ElemT elem.Read elem.Write cmp
        })
    // RemoveAt(i) = splice(i, 1); RemoveRange(i, n) = splice(i, n)
    | Some r, "splice", [ idx; count ] ->
        Some(wasm {
            let! rav = transform ctx receiver
            let! i = transform ctx idx
            let! n = transform ctx count
            do! shiftTail r rav (i +. n) (i32Const 0 -. n)
        })
    // Insert(i, x) = splice(i, 0, x)
    | Some r, "splice", [ idx; _; item ] ->
        Some(wasm {
            let! rav = transform ctx receiver
            let! i = transform ctx idx
            let! v = transform ctx item
            let! n = lenOf rav
            do! ensureCapacity r rav (n +. i32Const 1)
            do! shiftTail r rav i (i32Const 1)
            do! arraySet (dataOf r rav) i v
        })
    | _ -> None

/// Library imports a ResizeArray member compiles to: Util.clear, Array.addRangeInPlace / removeInPlace / indexOf / contains.
let tryImport
        (transform: Ctx -> Fable.Expr -> WExpr)
        (ctx: Ctx)
        (stem: string)
        (selector: string)
        (args: Fable.Expr list)
        (resultFableType: Fable.Type)
        : WExpr option =
    match stem, selector, args with
    | "Util", "clear", [ ar ] ->
        ravOf ctx ar.Type |> Option.map (fun _ -> setLen (transform ctx ar) (i32Const 0))
    | "Array", "addRangeInPlace", [ source; ar ] ->
        ravOf ctx ar.Type
        |> Option.bind (fun r ->
            addRangeTo transform ctx r source
            |> Option.map (fun add ->
                wasm {
                    let! rav = transform ctx ar
                    do! add rav
                }))
    // Remove(x): the first equal element leaves; true when there was one
    | "Array", "removeInPlace", item :: ar :: _ ->
        ravOf ctx ar.Type
        |> Option.map (fun r ->
            wasm {
                let! rav = transform ctx ar
                let! i = indexOf ctx r rav (transform ctx item)
                do! WExpr.If(i >=. i32Const 0,
                             shiftTail r rav (i +. i32Const 1) (i32Const -1),
                             WExpr.Nop, WType.Void)
                return i >=. i32Const 0
            })
    // Contains(x): the arguments come as (item, array, comparer)
    | "Array", "contains", item :: ar :: _ ->
        ravOf ctx ar.Type |> Option.map (fun r -> indexOf ctx r (transform ctx ar) (transform ctx item) >=. i32Const 0)
    | "Array", "indexOf", ar :: item :: _ ->
        ravOf ctx ar.Type |> Option.map (fun r -> indexOf ctx r (transform ctx ar) (transform ctx item))
    | _ -> None
