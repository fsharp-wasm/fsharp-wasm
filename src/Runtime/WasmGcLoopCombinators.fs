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
    letMut gen "cur" s.BaseTy list     (fun cur setCur ->
    letMut gen "acc" accTy  initAcc    (fun acc setAcc ->
        sequence [
            whileLoop (gen.Next("lp")) (refIsNotNull cur)
                (sequence [
                    setAcc (folder acc (s.Head cur))
                    setCur (s.Tail cur)
                ])
            acc
        ]))

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
// listExists / listForAll — short-circuit search returning bool
// ─────────────────────────────────────────────────────────────────────────────

/// Returns 1 (true) if any element satisfies the predicate (short-circuits).
let listExists
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    // Capture labels BEFORE letMut so the label strings are in scope for break/continue.
    let blkLbl = gen.Next("blk")
    let lpLbl  = gen.Next("lp")
    letMut gen "cur" s.BaseTy list (fun cur setCur ->
    letMut gen "res" WType.I32 (i32Const 0) (fun res setRes ->
        sequence [
            WExpr.Block(blkLbl,
                WExpr.Loop(lpLbl,
                    wasmIf (refIsNotNull cur)
                        (wasmIf (pred (s.Head cur))
                            (sequence [setRes (i32Const 1); WExpr.Break(blkLbl, None)])
                            (sequence [setCur (s.Tail cur); WExpr.Continue(lpLbl, [])]))
                        WExpr.Nop,
                    WType.Void),
                WType.Void)
            res
        ]))

/// Returns 1 (true) if all elements satisfy the predicate (short-circuits on first failure).
let listForAll
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (pred : WExpr -> WExpr)
        : WExpr =
    let blkLbl = gen.Next("blk")
    let lpLbl  = gen.Next("lp")
    letMut gen "cur" s.BaseTy list (fun cur setCur ->
    letMut gen "res" WType.I32 (i32Const 1) (fun res setRes ->
        sequence [
            WExpr.Block(blkLbl,
                WExpr.Loop(lpLbl,
                    wasmIf (refIsNotNull cur)
                        (wasmIf (pred (s.Head cur))
                            (sequence [setCur (s.Tail cur); WExpr.Continue(lpLbl, [])])
                            (sequence [setRes (i32Const 0); WExpr.Break(blkLbl, None)]))
                        WExpr.Nop,
                    WType.Void),
                WType.Void)
            res
        ]))

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
    letMut gen "cur" s.BaseTy list (fun cur setCur ->
        WExpr.Block(exitLbl,
            sequence [
                WExpr.Loop(lpLbl,
                    wasmIf (refIsNotNull cur)
                        (sequence [
                            wasmIf (pred (s.Head cur))
                                (WExpr.Break(exitLbl, Some (onFound (s.Head cur))))
                                (sequence [setCur (s.Tail cur); WExpr.Continue(lpLbl, [])])
                        ])
                        WExpr.Nop,
                    WType.Void)
                onNotFound
            ],
            resTy))

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
    letVal gen "n" WType.I32 len (fun gl ->
    letMut gen "i" WType.I32 (i32Const 0) (fun i setI ->
        whileLoop (gen.Next("lp")) (ltS i gl)
            (sequence [body i; setI (add i (i32Const 1))])))

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
    letMut gen "ri"  WType.I32  (sub len (i32Const 1)) (fun ri setRi ->
    letMut gen "acc" s.BaseTy   s.Nil                   (fun acc setAcc ->
        sequence [
            whileLoop (gen.Next("lp")) (geS ri (i32Const 0))
                (sequence [
                    setAcc (s.Cons (getElem arr ri) acc)
                    setRi  (sub ri (i32Const 1))
                ])
            acc
        ]))

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

    // Pass 1 — count
    letVal gen "lst" s.BaseTy list (fun lst ->
    letVal gen "len" WType.I32 (listLength gen s lst) (fun len ->

    // Pass 2 — allocate array (init value: zero for the element type)
    letVal gen "arr" arrRefTy
        (arrayNew arrTypeIdx len (makeNumericZero s.ElemTy) arrRefTy)
        (fun arr ->

    // Fill the array from the list
    let fillLoop =
        letMut gen "fi" WType.I32 (i32Const 0) (fun fi setFi ->
            listFold gen s lst WExpr.Nop WType.Void
                (fun _ elem ->
                    sequence [
                        arraySet arr fi elem
                        setFi (add fi (i32Const 1))
                    ]))

    // Pass 3 — insertion sort in-place
    let sortLoop =
        letMut gen "si" WType.I32 (i32Const 1) (fun si setSi ->
            whileLoop (gen.Next("sil")) (ltS si len)
                (letVal gen "se" s.ElemTy (arrayGet arr si s.ElemTy) (fun se ->
                letMut gen "sj" WType.I32 (sub si (i32Const 1))      (fun sj setSj ->
                    sequence [
                        whileLoop (gen.Next("sjl"))
                            (wasmAnd (geS sj (i32Const 0))
                                     (cmpOp se (arrayGet arr sj s.ElemTy)))
                            (sequence [
                                arraySet arr (add sj (i32Const 1)) (arrayGet arr sj s.ElemTy)
                                setSj (sub sj (i32Const 1))
                            ])
                        arraySet arr (add sj (i32Const 1)) se
                        setSi (add si (i32Const 1))
                    ]))))

    // Pass 4 — rebuild list from array (right-to-left → forward order)
    sequence [
        fillLoop
        sortLoop
        arrayToListRev gen s arr len
            (fun a i -> arrayGet a i s.ElemTy)
    ])))
