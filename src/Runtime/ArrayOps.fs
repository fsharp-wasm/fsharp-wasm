/// High-level array combinators for WasmGC code generation.
module Fable.Transforms.WasmGc.Runtime.ArrayOps

open Fable.AST.Wasm
open Fable.Transforms.WasmGc.Runtime.Types
open Fable.Transforms.WasmGc.Runtime.Builder
open Fable.Transforms.WasmGc.Runtime.LoopPrimitives

// ═══════════════════════════════════════════════════════════════════════════
// ARRAY COMBINATORS — parallel API to the list combinators above
// ═══════════════════════════════════════════════════════════════════════════

/// Shape info for a GC array type.
type ArrayShape = {
    ElemTy     : WType
    ArrTypeIdx : int
    ArrRefTy   : WType
}
    with
        /// Read one element: `a.Get(arr, idx)` -> `arrayGet arr idx a.ElemTy`
        member a.Get(arr: WExpr, idx: WExpr) = arrayGet arr idx a.ElemTy
        /// Write one element: `a.Set(arr, idx, v)` -> `arraySet arr idx v`
        member a.Set(arr: WExpr, idx: WExpr, v: WExpr) = arraySet arr idx v
        /// Array length: `a.Len(arr)` -> `arrayLen arr`
        member a.Len(arr: WExpr) = arrayLen arr
        /// Allocate a new array: `a.New(n, init)` -> `arrayNew a.ArrTypeIdx n init a.ArrRefTy`
        member a.New(n: WExpr, init: WExpr) = arrayNew a.ArrTypeIdx n init a.ArrRefTy

/// Build an ArrayShape from element type and GC array type index.
let mkArrayShape (elemT: WType) (arrTypeIdx: int) : ArrayShape =
    { ElemTy = elemT; ArrTypeIdx = arrTypeIdx; ArrRefTy = WType.Ref(arrTypeIdx, false) }

// ─────────────────────────────────────────────────────────────────────────────
// arrayFold — fold over a GC array
// ─────────────────────────────────────────────────────────────────────────────

/// Left-fold over a GC array.
///
///   let mutable acc = initAcc
///   for i in 0..arr.len-1 do
///       acc <- folder acc arr.[i]
///   acc
let arrayFold
        (gen     : LabelGen)
        (a       : ArrayShape)
        (arr     : WExpr)
        (initAcc : WExpr)
        (accTy   : WType)
        (folder  : WExpr -> WExpr -> WExpr)   // acc -> elem -> newAcc
        : WExpr =
    wasm {
        let! src = arr
        let! n = a.Len src
        let! acc = mutTy accTy initAcc
        let! i = mut (i32Const 0)
        while! (ltS i.Val n) do
            do! acc.Set(folder acc.Val (a.Get(src, i.Val)))
            do! i.Set(add i.Val (i32Const 1))
        return acc.Val
    }

// ─────────────────────────────────────────────────────────────────────────────
// arrayIter / arrayIteri — void traversal
// ─────────────────────────────────────────────────────────────────────────────

/// Iterate over a GC array for side effects only.
let arrayIter
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (body : WExpr -> WExpr)   // elem -> void
        : WExpr =
    wasm {
        let! src = arr
        return! indexedLoop gen (a.Len src)
                    (fun i -> body (a.Get(src, i)))
    }

/// Indexed iterate — body receives (idx, elem).
let arrayIteri
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (body : WExpr -> WExpr -> WExpr)   // idx -> elem -> void
        : WExpr =
    wasm {
        let! src = arr
        return! indexedLoop gen (a.Len src)
                    (fun i -> body i (a.Get(src, i)))
    }

// ─────────────────────────────────────────────────────────────────────────────
// arrayMap / arrayMapi — map to new array
// ─────────────────────────────────────────────────────────────────────────────

/// Map over a GC array, producing a new array.
let arrayMap
        (gen    : LabelGen)
        (a      : ArrayShape)       // source shape
        (ra     : ArrayShape)       // result shape (may differ)
        (arr    : WExpr)
        (mapper : WExpr -> WExpr)   // srcElem -> resElem
        : WExpr =
    wasm {
        let! src = arr
        let! n = a.Len src
        let! res = ra.New(n, makeNumericZero ra.ElemTy)
        do! indexedLoop gen n (fun i -> ra.Set(res, i, mapper (a.Get(src, i))))
        return res
    }

/// Indexed map — mapper receives (index, element).
let arrayMapi
        (gen    : LabelGen)
        (a      : ArrayShape)
        (ra     : ArrayShape)
        (arr    : WExpr)
        (mapper : WExpr -> WExpr -> WExpr)   // idx -> srcElem -> resElem
        : WExpr =
    wasm {
        let! src = arr
        let! n = a.Len src
        let! res = ra.New(n, makeNumericZero ra.ElemTy)
        do! indexedLoop gen n (fun i -> ra.Set(res, i, mapper i (a.Get(src, i))))
        return res
    }

// ─────────────────────────────────────────────────────────────────────────────
// arrayExists / arrayForAll — short-circuit search
// ─────────────────────────────────────────────────────────────────────────────

/// Returns 1 (true) if any element satisfies the predicate (short-circuits).
let arrayExists
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    wasm {
        let src = WArray.wrap a.ElemTy arr
        let! n  = src.Len
        let! i  = mut (i32Const 0)
        return! Wasm.labeledBlock gen "blk" WType.I32 (fun ctrl -> wasm {
            while (i.Val <. n) do
                if (pred src.[i.Val]) then
                    do! ctrl.BreakWith (i32Const 1)
                do! i <== (i.Val +. i32Const 1)
            return i32Const 0
        })
    }

/// Returns 1 (true) if all elements satisfy the predicate (short-circuits).
let arrayForAll
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    wasm {
        let src = WArray.wrap a.ElemTy arr
        let! n  = src.Len
        let! i  = mut (i32Const 0)
        return! Wasm.labeledBlock gen "blk" WType.I32 (fun ctrl -> wasm {
            while (i.Val <. n) do
                if (pred src.[i.Val]) then
                    do! i <== (i.Val +. i32Const 1)
                else
                    do! ctrl.BreakWith (i32Const 0)
            return i32Const 1
        })
    }

// ─────────────────────────────────────────────────────────────────────────────
// arrayFilter — two-pass filter (count + fill)
// ─────────────────────────────────────────────────────────────────────────────

/// Two-pass filter: count matching elements, allocate, fill.
let arrayFilter
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    wasm {
        let src = WArray.wrap a.ElemTy arr
        let! n   = src.Len

        // Pass 1: count
        let! cnt = mut (i32Const 0)
        let! i   = mut (i32Const 0)
        while (i.Val <. n) do
            if (pred src.[i.Val]) then
                do! cnt <== (cnt.Val +. i32Const 1)
            do! i <== (i.Val +. i32Const 1)

        // Pass 2: allocate + fill
        let res = WArray.wrap a.ElemTy (a.New(cnt.Val, makeNumericZero a.ElemTy))
        let! wi = mut (i32Const 0)
        do! i   <== i32Const 0
        while (i.Val <. n) do
            if (pred src.[i.Val]) then
                do! res.Set(wi.Val) src.[i.Val]
                do! wi <== (wi.Val +. i32Const 1)
            do! i <== (i.Val +. i32Const 1)

        return res.Expr
    }

// ─────────────────────────────────────────────────────────────────────────────
// arraySearch — find first element matching predicate
// ─────────────────────────────────────────────────────────────────────────────

/// Find the first array element satisfying `pred` and return `onFound idx elem`.
/// If not found, returns `onNotFound`.
let arraySearch
        (gen        : LabelGen)
        (a          : ArrayShape)
        (arr        : WExpr)
        (resTy      : WType)
        (pred       : WExpr -> WExpr)
        (onFound    : WExpr -> WExpr -> WExpr)   // idx -> elem -> result
        (onNotFound : WExpr)
        : WExpr =
    wasm {
        let src = WArray.wrap a.ElemTy arr
        let! n  = src.Len
        let! i  = mut (i32Const 0)
        return! Wasm.labeledBlock gen "search" resTy (fun ctrl -> wasm {
            while (i.Val <. n) do
                if (pred src.[i.Val]) then
                    do! ctrl.BreakWith (onFound i.Val src.[i.Val])
                do! i <== (i.Val +. i32Const 1)
            return onNotFound
        })
    }
