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
        do! Wasm.while_ (refIsNotNull cur.Val)
                (sequence [
                    acc.Set(folder acc.Val (s.Head cur.Val))
                    cur.Set(s.Tail cur.Val)
                ])
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
        return! Wasm.while_ (refIsNotNull cur.Val)
                    (sequence [body (s.Head cur.Val); cur.Set(s.Tail cur.Val)])
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
        return! Wasm.while_ (refIsNotNull cur.Val)
                    (sequence [body i.Val (s.Head cur.Val); i.Set(add i.Val (i32Const 1)); cur.Set(s.Tail cur.Val)])
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
            do! Wasm.while_ (refIsNotNull cur.Val)
                    (sequence [
                        acc.Set(rs.Cons (mapper i.Val (s.Head cur.Val)) acc.Val)
                        i.Set(add i.Val (i32Const 1))
                        cur.Set(s.Tail cur.Val)
                    ])
            return acc.Val
        }
    listRev gen rs rev

// ─────────────────────────────────────────────────────────────────────────────
// listExists / listForAll — short-circuit search returning bool
// ─────────────────────────────────────────────────────────────────────────────

/// Returns 1 (true) if any element satisfies the predicate (short-circuits).
let listExists
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    let blkLbl = gen.Next("blk")
    let lpLbl  = gen.Next("lp")
    wasm {
        let! cur = mutTy s.BaseTy list
        let! res = mut (i32Const 0)
        do! WExpr.Block(blkLbl,
                WExpr.Loop(lpLbl,
                    wasmIf (refIsNotNull cur.Val)
                        (wasmIf (pred (s.Head cur.Val))
                            (sequence [res.Set(i32Const 1); WExpr.Break(blkLbl, None)])
                            (sequence [cur.Set(s.Tail cur.Val); WExpr.Continue(lpLbl, [])]))
                        WExpr.Nop,
                    WType.Void),
                WType.Void)
        return res.Val
    }

/// Returns 1 (true) if all elements satisfy the predicate (short-circuits on first failure).
let listForAll
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    let blkLbl = gen.Next("blk")
    let lpLbl  = gen.Next("lp")
    wasm {
        let! cur = mutTy s.BaseTy list
        let! res = mut (i32Const 1)
        do! WExpr.Block(blkLbl,
                WExpr.Loop(lpLbl,
                    wasmIf (refIsNotNull cur.Val)
                        (wasmIf (pred (s.Head cur.Val))
                            (sequence [cur.Set(s.Tail cur.Val); WExpr.Continue(lpLbl, [])])
                            (sequence [res.Set(i32Const 0); WExpr.Break(blkLbl, None)]))
                        WExpr.Nop,
                    WType.Void),
                WType.Void)
        return res.Val
    }

// ─────────────────────────────────────────────────────────────────────────────
// listSearch — find first element matching predicate
// ─────────────────────────────────────────────────────────────────────────────

/// Find the first element satisfying `pred` and return `onFound elem` or `onNotFound`.
/// Uses break-on-found for O(n) worst-case with early exit.
let listSearch
        (gen        : LabelGen)
        (s          : ListShape)
        (list       : WExpr)
        (resTy      : WType)
        (pred       : WExpr -> WExpr)
        (onFound    : WExpr -> WExpr)
        (onNotFound : WExpr)
        : WExpr =
    let exitLbl = gen.Next("exit")
    let lpLbl   = gen.Next("lp")
    wasm {
        let! cur = mutTy s.BaseTy list
        return! WExpr.Block(exitLbl,
            sequence [
                WExpr.Loop(lpLbl,
                    wasmIf (refIsNotNull cur.Val)
                        (wasmIf (pred (s.Head cur.Val))
                            (WExpr.Break(exitLbl, Some (onFound (s.Head cur.Val))))
                            (sequence [cur.Set(s.Tail cur.Val); WExpr.Continue(lpLbl, [])]))
                        WExpr.Nop,
                    WType.Void)
                onNotFound
            ],
            resTy)
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
let indexedLoop (gen: LabelGen) (len: WExpr) (body: WExpr -> WExpr) : WExpr =
    wasm {
        let! n = len
        let! i = mut (i32Const 0)
        return! Wasm.while_ (ltS i.Val n)
                    (sequence [body i.Val; i.Set(add i.Val (i32Const 1))])
    }

// ─────────────────────────────────────────────────────────────────────────────
// arrayToListRev — walk array right-to-left, consing into a list
// ─────────────────────────────────────────────────────────────────────────────

/// Walk an array from right to left, consing each element into a list.
/// The result is in the same order as the array (reversed accumulator = forward).
///
/// `getElem arr i` : WExpr -> WExpr -> WExpr   — e.g. fun a i -> WExpr.ArrayGet(a, i, elemTy)
let arrayToListRev
        (gen     : LabelGen)
        (s       : ListShape)
        (arr     : WExpr)       // must be a LocalGet or simple ref — reused un-bound
        (len     : WExpr)
        (getElem : WExpr -> WExpr -> WExpr)
        : WExpr =
    wasm {
        let! ri  = mut (sub len (i32Const 1))
        let! acc = mutTy s.BaseTy s.Nil
        do! Wasm.while_ (geS ri.Val (i32Const 0))
                (sequence [
                    acc.Set(s.Cons (getElem arr ri.Val) acc.Val)
                    ri.Set(sub ri.Val (i32Const 1))
                ])
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
        (readElem  : WExpr -> WExpr -> WExpr)    // arr → idx → elem
        (writeElem : WExpr -> WExpr -> WExpr -> WExpr)  // arr → idx → val → void
        (cmp       : WExpr -> WExpr -> WExpr)     // a → b → i32 (negative/zero/positive)
        : WExpr =
    wasm {
        let! si = mut (i32Const 1)
        return! Wasm.while_ (ltS si.Val len)
            (wasm {
                let! se = readElem arr si.Val
                let! sj = mut (sub si.Val (i32Const 1))
                do! Wasm.while_
                        (wasmAnd (geS sj.Val (i32Const 0))
                                 (gtS (cmp (readElem arr sj.Val) se) (i32Const 0)))
                        (sequence [
                            writeElem arr (add sj.Val (i32Const 1)) (readElem arr sj.Val)
                            sj.Set(sub sj.Val (i32Const 1))
                        ])
                do! writeElem arr (add sj.Val (i32Const 1)) se
                return! si.Set(add si.Val (i32Const 1))
            })
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

        // Fill the array from the list
        let! fi = mut (i32Const 0)
        do! listFold gen s lst WExpr.Nop WType.Void
                (fun _ elem ->
                    sequence [
                        arraySet arr fi.Val elem
                        fi.Set(add fi.Val (i32Const 1))
                    ])

        // Insertion sort in-place
        do! insertionSortInPlace gen arr len s.ElemTy
                (fun a i -> arrayGet a i s.ElemTy)
                (fun a i v -> arraySet a i v)
                (fun a b -> wasmIf (cmpOp a b) (i32Const -1) (i32Const 1))

        // Rebuild list from array (right-to-left → forward order)
        return! arrayToListRev gen s arr len
                    (fun a i -> arrayGet a i s.ElemTy)
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
        let! n = arrayLen src
        let! acc = mutTy accTy initAcc
        let! i = mut (i32Const 0)
        do! Wasm.while_ (ltS i.Val n)
                (sequence [
                    acc.Set(folder acc.Val (arrayGet src i.Val a.ElemTy))
                    i.Set(add i.Val (i32Const 1))
                ])
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
        return! indexedLoop gen (arrayLen src)
                    (fun i -> body (arrayGet src i a.ElemTy))
    }

/// Indexed void traversal — body receives (index, element).
let arrayIteri
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (body : WExpr -> WExpr -> WExpr)   // idx → elem → void
        : WExpr =
    wasm {
        let! src = arr
        return! indexedLoop gen (arrayLen src)
                    (fun i -> body i (arrayGet src i a.ElemTy))
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
        let! n = arrayLen src
        let! res = arrayNew ra.ArrTypeIdx n (makeNumericZero ra.ElemTy) ra.ArrRefTy
        do! indexedLoop gen n (fun i ->
                arraySet res i (mapper (arrayGet src i a.ElemTy)))
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
        let! n = arrayLen src
        let! res = arrayNew ra.ArrTypeIdx n (makeNumericZero ra.ElemTy) ra.ArrRefTy
        do! indexedLoop gen n (fun i ->
                arraySet res i (mapper i (arrayGet src i a.ElemTy)))
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
    let blkLbl = gen.Next("blk")
    let lpLbl  = gen.Next("lp")
    wasm {
        let! src = arr
        let! n = arrayLen src
        let! i = mut (i32Const 0)
        return! WExpr.Block(blkLbl,
            sequence [
                WExpr.Loop(lpLbl,
                    wasmIf (ltS i.Val n)
                        (wasmIf (pred (arrayGet src i.Val a.ElemTy))
                            (WExpr.Break(blkLbl, Some(i32Const 1)))
                            (sequence [i.Set(add i.Val (i32Const 1)); continue_ lpLbl]))
                        WExpr.Nop,
                    WType.Void)
                i32Const 0
            ],
            WType.I32)
    }

/// Returns 1 (true) if all elements satisfy the predicate (short-circuits).
let arrayForAll
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    let blkLbl = gen.Next("blk")
    let lpLbl  = gen.Next("lp")
    wasm {
        let! src = arr
        let! n = arrayLen src
        let! i = mut (i32Const 0)
        return! WExpr.Block(blkLbl,
            sequence [
                WExpr.Loop(lpLbl,
                    wasmIf (ltS i.Val n)
                        (wasmIf (pred (arrayGet src i.Val a.ElemTy))
                            (sequence [i.Set(add i.Val (i32Const 1)); continue_ lpLbl])
                            (WExpr.Break(blkLbl, Some(i32Const 0))))
                        WExpr.Nop,
                    WType.Void)
                i32Const 1
            ],
            WType.I32)
    }

// ─────────────────────────────────────────────────────────────────────────────
// arrayFilter — two-pass filter (count + fill)
// ─────────────────────────────────────────────────────────────────────────────

/// Filter a GC array using a predicate (two-pass: count then fill).
let arrayFilter
        (gen  : LabelGen)
        (a    : ArrayShape)
        (arr  : WExpr)
        (pred : WExpr -> WExpr)   // elem → i32 (bool)
        : WExpr =
    wasm {
        let! src = arr
        let! n = arrayLen src
        // Pass 1: count matching elements
        let! cnt = mut (i32Const 0)
        do! indexedLoop gen n (fun i ->
                wasmWhen (pred (arrayGet src i a.ElemTy))
                    (cnt.Set(add cnt.Val (i32Const 1))))
        // Pass 2: allocate + fill
        let! res = arrayNew a.ArrTypeIdx cnt.Val (makeNumericZero a.ElemTy) a.ArrRefTy
        let! wi = mut (i32Const 0)
        do! indexedLoop gen n (fun i ->
                wasmWhen (pred (arrayGet src i a.ElemTy))
                    (sequence [
                        arraySet res wi.Val (arrayGet src i a.ElemTy)
                        wi.Set(add wi.Val (i32Const 1))
                    ]))
        return res
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
    let exitLbl = gen.Next("exit")
    let lpLbl   = gen.Next("lp")
    wasm {
        let! src = arr
        let! n = arrayLen src
        let! i = mut (i32Const 0)
        return! WExpr.Block(exitLbl,
            sequence [
                WExpr.Loop(lpLbl,
                    wasmIf (ltS i.Val n)
                        (let elem = arrayGet src i.Val a.ElemTy
                         wasmIf (pred elem)
                            (WExpr.Break(exitLbl, Some(onFound i.Val (arrayGet src i.Val a.ElemTy))))
                            (sequence [i.Set(add i.Val (i32Const 1)); continue_ lpLbl]))
                        WExpr.Nop,
                    WType.Void)
                onNotFound
            ],
            resTy)
    }


