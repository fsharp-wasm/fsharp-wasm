/// Reusable low-level loop primitives for WasmGC code generation.
///
/// This module intentionally contains only loop shapes and shared sort/rebuild
/// helpers that can be consumed by both list and array operation modules.
module WasmGc.Runtime.LoopPrimitives

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder
open WasmGc.Builder.Core


open WasmGc.Patterns.ListShape

open WasmGc.Builder.Operators

// ─────────────────────────────────────────────────────────────────────────────
// indexedLoop — index-based iteration over an array or string
// ─────────────────────────────────────────────────────────────────────────────

/// Counted index loop over 0..len-1; `body` receives the current index.
let indexedLoop (gen: LabelGen) (len: WExpr) (body: WExpr -> WExpr) : WExpr =
    wasm {
        let! n = len
        let! i = mut (i32Const 0)
        while (i.Val <. n) do
            do! body i.Val
            do! i <== (i.Val +. i32Const 1)
    }

// ─────────────────────────────────────────────────────────────────────────────
// arrayToListRev — walk array right-to-left, consing into a list
// ─────────────────────────────────────────────────────────────────────────────

/// Walk array right-to-left, consing each element into a list.
///
/// The resulting list preserves the original array order (reversed accumulator = forward)..
let arrayToListRev
        (gen     : LabelGen)
        (s       : ListShape)
        (arr     : WExpr)
        (len     : WExpr)
        (getElem : WExpr -> WExpr -> WExpr)
        : WExpr =
    wasm {
        let! ri  = mut (len -. i32Const 1)
        let! acc = mutTy s.BaseTy s.Nil
        while (ri.Val >=. i32Const 0) do
            do! acc <== s.Cons (getElem arr ri.Val) acc.Val
            do! ri  <== (ri.Val -. i32Const 1)
        return acc.Val
    }

/// Stable bottom-up merge sort of `arr`, optionally permuting a parallel `keys` array with it (`Some` = one projection
/// per element, evaluated once; `None` = the elements are their own keys).  O(n log n); one scratch array per array.
/// `cmp ka kb > 0` means ka must come after kb; equal keys keep their order (the left run wins ties).
let mergeSortKeyed
        (arr       : WExpr)
        (len       : WExpr)
        (elemTy    : WType)
        (readElem  : WExpr -> WExpr -> WExpr)
        (writeElem : WExpr -> WExpr -> WExpr -> WExpr)
        (keys      : (WExpr * WType * (WExpr -> WExpr -> WExpr) * (WExpr -> WExpr -> WExpr -> WExpr)) option)
        (cmp       : WExpr -> WExpr -> WExpr)
        : WExpr =
    let scratch (a: WExpr) (n: WExpr) (elem: WType) =
        match exprWType a with
        | WType.Ref(idx, _) -> arrayNew idx n (makeNumericZero elem) (WType.Ref(idx, false))
        | t -> failwithf "mergeSort: not an array: %A" t
    wasm {
        let! n = len
        let! tmpE = scratch arr n elemTy
        // the key array's scratch (the elements are their own keys when there is none)
        let! tmpK = match keys with Some(ka, kty, _, _) -> scratch ka n kty | None -> tmpE
        let keyAt a idx = match keys with Some(_, _, readK, _) -> readK a idx | None -> readElem a idx
        let keysOf = match keys with Some(ka, _, _, _) -> ka | None -> arr
        // copy slot `from` of the sources into slot `k` of the scratch arrays
        let move (k: WExpr) (from: WExpr) =
            match keys with
            | Some(ka, _, readK, writeK) -> sequence [ writeElem tmpE k (readElem arr from); writeK tmpK k (readK ka from) ]
            | None -> writeElem tmpE k (readElem arr from)
        let! width = mut (i32Const 1)
        while (width.Val <. n) do
            let! lo = mut (i32Const 0)
            while (lo.Val <. n) do
                let! mid = wasmIf (lo.Val +. width.Val <. n) (lo.Val +. width.Val) n
                let! hi = wasmIf (lo.Val +. width.Val +. width.Val <. n) (lo.Val +. width.Val +. width.Val) n
                let! l = mut lo.Val
                let! r = mut mid
                let! k = mut lo.Val
                // merge the runs [lo, mid) and [mid, hi) into the scratch arrays
                while ((l.Val <. mid) &&. (r.Val <. hi)) do
                    do! WExpr.If(cmp (keyAt keysOf l.Val) (keyAt keysOf r.Val) >. i32Const 0,
                            sequence [ move k.Val r.Val; r.Set(r.Val +. i32Const 1) ],
                            sequence [ move k.Val l.Val; l.Set(l.Val +. i32Const 1) ],
                            WType.Void)
                    do! k.Set(k.Val +. i32Const 1)
                while (l.Val <. mid) do
                    do! move k.Val l.Val
                    do! l.Set(l.Val +. i32Const 1)
                    do! k.Set(k.Val +. i32Const 1)
                while (r.Val <. hi) do
                    do! move k.Val r.Val
                    do! r.Set(r.Val +. i32Const 1)
                    do! k.Set(k.Val +. i32Const 1)
                do! lo.Set(lo.Val +. width.Val +. width.Val)
            do! arrayCopy arr (i32Const 0) tmpE (i32Const 0) n
            match keys with
            | Some(ka, _, _, _) -> do! arrayCopy ka (i32Const 0) tmpK (i32Const 0) n
            | None -> ()
            do! width.Set(width.Val +. width.Val)
    }

/// Merge sort of `arr` by its elements (see `mergeSortKeyed`).  `cmp a b > 0` means a must come after b.
let mergeSortInPlace
        (arr       : WExpr)
        (len       : WExpr)
        (elemTy    : WType)
        (readElem  : WExpr -> WExpr -> WExpr)
        (writeElem : WExpr -> WExpr -> WExpr -> WExpr)
        (cmp       : WExpr -> WExpr -> WExpr)
        : WExpr =
    mergeSortKeyed arr len elemTy readElem writeElem None cmp

// ─────────────────────────────────────────────────────────────────────────────
// arrayAccess — how elements of one type live in a GC array
// ─────────────────────────────────────────────────────────────────────────────

/// How elements of type `t` live in a GC array: reference elements are stored nullable (the array is created
/// with null) and cast back to non-null on read.
type ArrayAccess =
    { TypeIdx: int; RefT: WType; Default: WExpr
      Read: WExpr -> WExpr -> WExpr; Write: WExpr -> WExpr -> WExpr -> WExpr }

/// `arrayAccess` for the array of a user-visible F# array type: `elementType` decides whether the elements are stored packed
/// (see `getOrAddArrayTypeFor`); a temporary array of the same elements can use `arrayAccess`.
let arrayAccessFor (ctx: Ctx) (elementType: Fable.AST.Fable.Type) (t: WType) : ArrayAccess =
    let stored, zero =
        match t with
        | WType.Ref(idx, _) -> WType.Ref(idx, true), WExpr.Const(WConst.Null(WType.Ref(idx, true)))
        | _ -> t, makeNumericZero t
    let idx = getOrAddArrayTypeFor ctx elementType stored
    { TypeIdx = idx; RefT = WType.Ref(idx, false); Default = zero
      Read = (fun arr i -> match t with
                           | WType.Ref(ri, false) -> cast (arrayGet arr i stored) (WType.Ref(ri, false))
                           | _ -> arrayGet arr i t)
      Write = arraySet }

let arrayAccess (ctx: Ctx) (t: WType) : ArrayAccess = arrayAccessFor ctx Fable.AST.Fable.Type.Any t
