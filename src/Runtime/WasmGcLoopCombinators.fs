/// High-level loop combinators for WasmGC code generation.
///
/// These replace the old mkListLoop / mkArrayLoop helpers with a composable,
/// readable API. All combinators are parameterised by a LabelGen so names are
/// deterministic and debuggable.
///
/// Usage in WasmGcReplacements.fs (example):
///
///   // 1. Build a ListShape for the argument
///   let s = mkListShape ctx elemT consIdx
///   let gen = LabelGen "fld"
///   // 2. Compose the operation declaratively
///   listFold gen s wList (i32Const 0) WType.I32
///       (fun acc elem -> add acc elem)
module Fable.Transforms.WasmGc.WasmGcLoopCombinators

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder

// ─────────────────────────────────────────────────────────────────────────────
// ListShape — captures all per-element-type list information once
// ─────────────────────────────────────────────────────────────────────────────

/// All structural information about a concrete GC list type, bundled for
/// reuse across multiple combinator calls without threading the ctx.
type ListShape = {
    /// WType of each list element.
    ElemTy    : WType
    /// GC struct type index of the cons cell ($ListCons_T).
    ConsIdx   : int
    /// Nullable base-struct ref — the cursor type: Ref(ListBaseTypeIdx, true).
    BaseTy    : WType
    /// Non-nullable cons ref for StructGet operations: Ref(consIdx, false).
    NonNullTy : WType
    /// The null sentinel (empty list).
    Nil       : WExpr
    /// Cast a nullable base ref to the non-nullable cons ref.
    CastNN    : WExpr -> WExpr
    /// Extract the head element from a nullable base-ref cursor.
    /// Casts internally — caller need not cast before calling.
    Head      : WExpr -> WExpr
    /// Extract the tail (next node) from a nullable base-ref cursor.
    /// Casts internally — caller need not cast before calling.
    Tail      : WExpr -> WExpr
    /// Prepend an element to a list: Cons elem tail → new cons node.
    Cons      : WExpr -> WExpr -> WExpr
}

/// Build a ListShape for a concrete list element type.
let mkListShape (elemT: WType) (consIdx: int) : ListShape =
    let baseTy    = WType.Ref(ListBaseTypeIdx, true)
    let nonNullTy = WType.Ref(consIdx, false)
    let nil       = WExpr.Const(WConst.Null baseTy)
    let castNN n  = WExpr.Cast(n, nonNullTy)
    {
        ElemTy    = elemT
        ConsIdx   = consIdx
        BaseTy    = baseTy
        NonNullTy = nonNullTy
        Nil       = nil
        CastNN    = castNN
        Head      = fun n -> WExpr.StructGet(castNN n, 0, elemT)
        Tail      = fun n -> WExpr.StructGet(castNN n, 1, baseTy)
        Cons      = fun elem tail -> WExpr.StructNew(consIdx, [elem; tail], baseTy)
    }

// ─────────────────────────────────────────────────────────────────────────────
// listFold — fundamental traversal
// ─────────────────────────────────────────────────────────────────────────────

/// Left-fold over a GC linked list using LabelGen-scoped variable names.
///
///   let mutable cur = list
///   let mutable acc = initAcc
///   while cur <> null do
///       acc <- folder acc (head cur)
///       cur <- tail cur
///   acc
let listFold
        (gen     : LabelGen)
        (s       : ListShape)
        (list    : WExpr)
        (initAcc : WExpr)
        (accTy   : WType)
        (folder  : WExpr -> WExpr -> WExpr)   // acc → elem → newAcc
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        let! acc = mutTy accTy initAcc
        while! (refIsNotNull cur.Val) do
            do! acc.Set(folder acc.Val (s.Head cur.Val))
            do! cur.Set(s.Tail cur.Val)
        return acc.Val
    }

// ─────────────────────────────────────────────────────────────────────────────
// listRev — reverse a list in O(n)
// ─────────────────────────────────────────────────────────────────────────────

/// Reverse a GC linked list.
let listRev (gen: LabelGen) (s: ListShape) (list: WExpr) : WExpr =
    listFold gen s list s.Nil s.BaseTy
        (fun acc elem -> s.Cons elem acc)

// ─────────────────────────────────────────────────────────────────────────────
// listLength — count elements
// ─────────────────────────────────────────────────────────────────────────────

/// Count elements in a GC linked list.
let listLength (gen: LabelGen) (s: ListShape) (list: WExpr) : WExpr =
    listFold gen s list (i32Const 0) WType.I32
        (fun acc _ -> add acc (i32Const 1))

// ─────────────────────────────────────────────────────────────────────────────
// listMap — map over a list, preserving order via double-reverse
// ─────────────────────────────────────────────────────────────────────────────

/// Map over a GC linked list — fold→rev to preserve element order.
/// The result list type can differ from the source (`rs` may differ from `s`).
let listMap
        (gen    : LabelGen)
        (s      : ListShape)       // source shape
        (rs     : ListShape)       // result shape (may equal s)
        (list   : WExpr)
        (mapper : WExpr -> WExpr)  // srcElem → resElem
        : WExpr =
    // Pass 1: build reversed mapped list
    let revResNil = rs.Nil
    let rev =
        listFold gen s list revResNil rs.BaseTy
            (fun acc elem -> rs.Cons (mapper elem) acc)
    // Pass 2: reverse the result to restore order
    listRev gen rs rev

// ─────────────────────────────────────────────────────────────────────────────
// listFilter — filter a list, preserving order
// ─────────────────────────────────────────────────────────────────────────────

/// Filter a GC linked list using a predicate.  Result list preserves order.
let listFilter
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (pred : WExpr -> WExpr)   // elem → i32 (bool)
        : WExpr =
    let rev =
        listFold gen s list s.Nil s.BaseTy
            (fun acc elem -> wasmIf (pred elem) (s.Cons elem acc) acc)
    listRev gen s rev

// ─────────────────────────────────────────────────────────────────────────────
// listIter — void traversal (no accumulator)
// ─────────────────────────────────────────────────────────────────────────────

/// Traverse a GC linked list for side effects only — no accumulator.
let listIter (gen: LabelGen) (s: ListShape) (list: WExpr) (body: WExpr -> WExpr) : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        while! (refIsNotNull cur.Val) do
            do! body (s.Head cur.Val)
            do! cur.Set(s.Tail cur.Val)
    }

/// Indexed void traversal — body receives (index, element).
let listIteri
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (body : WExpr -> WExpr -> WExpr)   // idx → elem → void
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        let! i = mut (i32Const 0)
        while! (refIsNotNull cur.Val) do
            do! body i.Val (s.Head cur.Val)
            do! i.Set(add i.Val (i32Const 1))
            do! cur.Set(s.Tail cur.Val)
    }

// ─────────────────────────────────────────────────────────────────────────────
// listMapi — indexed map
// ─────────────────────────────────────────────────────────────────────────────

/// Indexed map over a list — result preserves order via fold→rev.
let listMapi
        (gen    : LabelGen)
        (s      : ListShape)
        (rs     : ListShape)
        (list   : WExpr)
        (mapper : WExpr -> WExpr -> WExpr)  // idx → srcElem → resElem
        : WExpr =
    let rev =
        wasm {
            let! cur = mutTy s.BaseTy list
            let! acc = mutTy rs.BaseTy rs.Nil
            let! i = mut (i32Const 0)
            while! (refIsNotNull cur.Val) do
                do! acc.Set(rs.Cons (mapper i.Val (s.Head cur.Val)) acc.Val)
                do! i.Set(add i.Val (i32Const 1))
                do! cur.Set(s.Tail cur.Val)
            return acc.Val
        }
    listRev gen rs rev

// ─────────────────────────────────────────────────────────────────────────────
// listExists / listForAll — short-circuit search returning bool
// ─────────────────────────────────────────────────────────────────────────────

/// Returns 1 (true) if any element satisfies the predicate (short-circuits).
///
/// Generates:
///   block $exit : i32 {
///     let mut cur = list
///     loop $lp {
///       if refIsNotNull cur then
///         if pred(cur.Head) then
///           br $exit 1         // BreakWith — valued exit
///         cur <- cur.Tail
///         continue $lp
///     }
///     0                        // fallthrough = not found
///   }
let listExists
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        return! Wasm.labeledBlock gen "blk" WType.I32 (fun ctrl -> wasm {
            do! Wasm.labeledLoop gen "lp" (fun lp -> wasm {
                if (refIsNotNull cur.Val) then
                    if (pred (s.Head cur.Val)) then
                        // Early exit with 1 — breaks the outer block.
                        // inner.Break exits the inner loop; outer ctrl.BreakWith exits the block.
                        do! ctrl.BreakWith (i32Const 1)
                    do! cur <== s.Tail cur.Val
                else
                    do! lp.Break
            })
            return i32Const 0
        })
    }

/// Returns 1 (true) if all elements satisfy the predicate (short-circuits on first failure).
///
/// Generates:
///   block $exit : i32 {
///     let mut cur = list
///     loop $lp {
///       if refIsNotNull cur then
///         if not pred(cur.Head) then
///           br $exit 0         // BreakWith — valued exit, failure
///         cur <- cur.Tail
///         continue $lp
///     }
///     1                        // fallthrough = all passed
///   }
let listForAll
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        return! Wasm.labeledBlock gen "blk" WType.I32 (fun ctrl -> wasm {
            do! Wasm.labeledLoop gen "lp" (fun lp -> wasm {
                if (refIsNotNull cur.Val) then
                    if (pred (s.Head cur.Val)) then
                        do! cur <== s.Tail cur.Val
                    else
                        // Predicate failed — exit with 0.
                        do! ctrl.BreakWith (i32Const 0)
                else
                    do! lp.Break
            })
            return i32Const 1
        })
    }

// ─────────────────────────────────────────────────────────────────────────────
// listSearch — find first element matching predicate
// ─────────────────────────────────────────────────────────────────────────────

/// Find the first element satisfying `pred` and return `onFound elem` or `onNotFound`.
/// Uses break-on-found for O(n) worst-case with early exit.
///
/// Generates:
///   block $exit : resTy {
///     let mut cur = list
///     loop $lp {
///       if refIsNotNull cur then
///         if pred(cur.Head) then
///           br $exit (onFound cur.Head)
///         cur <- cur.Tail
///         continue $lp
///     }
///     onNotFound
///   }
let listSearch
        (gen        : LabelGen)
        (s          : ListShape)
        (list       : WExpr)
        (resTy      : WType)
        (pred       : WExpr -> WExpr)
        (onFound    : WExpr -> WExpr)
        (onNotFound : WExpr)
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        return! Wasm.labeledBlock gen "exit" resTy (fun ctrl -> wasm {
            do! Wasm.labeledLoop gen "lp" (fun lp -> wasm {
                if (refIsNotNull cur.Val) then
                    if (pred (s.Head cur.Val)) then
                        do! ctrl.BreakWith (onFound (s.Head cur.Val))
                    do! cur <== s.Tail cur.Val
                else
                    do! lp.Break
            })
            return onNotFound
        })
    }

// ─────────────────────────────────────────────────────────────────────────────
// indexedLoop — index-based iteration over an array or string
// ─────────────────────────────────────────────────────────────────────────────

/// Index-based loop over 0..len-1; body receives index as WExpr.
///
///   let n = len
///   let mutable i = 0
///   while i < n do
///       body i
///       i <- i + 1
/// Counted index loop over 0..len-1; body receives the current index WExpr.
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

/// Walk an array from right to left, consing each element into a list.
/// The result is in the same order as the array (reversed accumulator = forward).
///
/// `getElem arr i` : WExpr -> WExpr -> WExpr   — e.g. fun a i -> WExpr.ArrayGet(a, i, elemTy)
/// Walk array right-to-left, consing each element into a list.
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

// ─────────────────────────────────────────────────────────────────────────────
// insertionSortInPlace — shared between Array.sort and List.sort
// ─────────────────────────────────────────────────────────────────────────────

/// In-place insertion sort on a GC array.
/// `cmp a b` should return an i32 WExpr: negative = a < b, 0 = equal, positive = a > b.
/// `readElem arr idx` reads element at index (may cast nullable → non-nullable).
/// `writeElem arr idx val` writes element at index.
let insertionSortInPlace
        (gen       : LabelGen)
        (arr       : WExpr)
        (len       : WExpr)
        (elemTy    : WType)
        (readElem  : WExpr -> WExpr -> WExpr)
        (writeElem : WExpr -> WExpr -> WExpr -> WExpr)
        (cmp       : WExpr -> WExpr -> WExpr)
        : WExpr =
    wasm {
        let! si = mut (i32Const 1)
        while (si.Val <. len) do
            let! se = readElem arr si.Val
            let! sj = mut (si.Val -. i32Const 1)
            while ((sj.Val >=. i32Const 0) &&. (cmp (readElem arr sj.Val) se >. i32Const 0)) do
                do! writeElem arr (sj.Val +. i32Const 1) (readElem arr sj.Val)
                do! sj <== (sj.Val -. i32Const 1)
            do! writeElem arr (sj.Val +. i32Const 1) se
            do! si <== (si.Val +. i32Const 1)
    }

// ─────────────────────────────────────────────────────────────────────────────
// buildListSort — O(n²) insertion sort, fully composed from combinators
// ─────────────────────────────────────────────────────────────────────────────

/// Sort a GC linked list via insertion sort (O(n²) — suitable for typical F# sizes).
///
/// Passes:
///   1. Count length.
///   2. Allocate + fill a GcArray.
///   3. Insertion sort in place.
///   4. Rebuild list from array (backwards, so order is preserved).
///
/// `arrTypeIdx` — GC array type index for elements of `s.ElemTy` (from getOrAddArrayType ctx).
/// `descending` — if true uses gt comparison instead of lt.
let buildListSort
        (gen        : LabelGen)
        (s          : ListShape)
        (arrTypeIdx : int)
        (list       : WExpr)
        (descending : bool)
        : WExpr =
    let arrRefTy = WType.Ref(arrTypeIdx, false)
    let cmpOp    = if descending then gtS else ltS

    wasm {
        let! lst = list
        let! len = listLength gen s lst
        let! arr = arrayNew arrTypeIdx len (makeNumericZero s.ElemTy) arrRefTy

        // Fill the array from the list (index is the accumulator)
        let arrGet arr i = arrayGet arr i s.ElemTy
        let arrSet arr i v = arraySet arr i v
        do! listFold gen s lst (i32Const 0) WType.I32
                (fun idx elem ->
                    sequence [arrSet arr idx elem; add idx (i32Const 1)])

        // Insertion sort in-place
        do! insertionSortInPlace gen arr len s.ElemTy
                arrGet arrSet
                (fun a b -> wasmIf (cmpOp a b) (i32Const -1) (i32Const 1))

        // Rebuild list from array (right-to-left → forward order)
        return! arrayToListRev gen s arr len arrGet
    }

// ═══════════════════════════════════════════════════════════════════════════
// ARRAY COMBINATORS — parallel API to the list combinators above
// ═══════════════════════════════════════════════════════════════════════════

/// Shape info for a GC array type, analogous to ListShape for lists.
type ArrayShape = {
    ElemTy     : WType
    ArrTypeIdx : int
    ArrRefTy   : WType
}
    with
        /// Read one element: `a.Get(arr, idx)` → `arrayGet arr idx a.ElemTy`
        member a.Get(arr: WExpr, idx: WExpr) = arrayGet arr idx a.ElemTy
        /// Write one element: `a.Set(arr, idx, v)` → `arraySet arr idx v`
        member a.Set(arr: WExpr, idx: WExpr, v: WExpr) = arraySet arr idx v
        /// Array length: `a.Len(arr)` → `arrayLen arr`
        member a.Len(arr: WExpr) = arrayLen arr
        /// Allocate a new array: `a.New(n, init)` → `arrayNew a.ArrTypeIdx n init a.ArrRefTy`
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
        (folder  : WExpr -> WExpr -> WExpr)   // acc → elem → newAcc
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
        (body : WExpr -> WExpr)   // elem → void
        : WExpr =
    wasm {
        let! src = arr
        return! indexedLoop gen (a.Len src)
                    (fun i -> body (a.Get(src, i)))
    }
let arrayIteri
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (body : WExpr -> WExpr -> WExpr)   // idx → elem → void
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
        (mapper : WExpr -> WExpr)   // srcElem → resElem
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
        (mapper : WExpr -> WExpr -> WExpr)   // idx → srcElem → resElem
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

/// Filter a GC array using a predicate (two-pass: count then fill).
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
        (onFound    : WExpr -> WExpr -> WExpr)   // idx → elem → result
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


