/// High-level list combinators for WasmGC code generation.
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
module WasmGc.Runtime.ListOps

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder.Core

open WasmGc.Runtime.ListShape
open WasmGc.Runtime.LoopPrimitives

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

/// Reverse a GC linked list in O(n).
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

/// Map over a GC linked list, preserving order via fold-then-reverse.
let listMap
        (gen    : LabelGen)
        (s      : ListShape)       // source shape
        (rs     : ListShape)       // result shape (may differ from source)
        (list   : WExpr)
        (mapper : WExpr -> WExpr)  // srcElem → resElem
        : WExpr =
    let rev =
        listFold gen s list rs.Nil rs.BaseTy
            (fun acc elem -> rs.Cons (mapper elem) acc)
    listRev gen rs rev

// ─────────────────────────────────────────────────────────────────────────────
// listMapi — indexed map
// ─────────────────────────────────────────────────────────────────────────────

/// Indexed map over a GC linked list — result preserves order via fold→rev.
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
// listFilter — filter a list, preserving order
// ─────────────────────────────────────────────────────────────────────────────

/// Filter a GC linked list, preserving source order.
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

/// Side-effect traversal over a GC linked list.
/// Traverse a GC linked list for side effects only — no accumulator.
let listIter
        (gen  : LabelGen)
        (s    : ListShape)
        (list : WExpr)
        (body : WExpr -> WExpr)   // elem → void
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        while! (refIsNotNull cur.Val) do
            do! body (s.Head cur.Val)
            do! cur.Set(s.Tail cur.Val)
    }

/// Indexed side-effect traversal over a GC linked list.
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
// listExists / listForAll — short-circuit search returning bool
// ─────────────────────────────────────────────────────────────────────────────

/// Returns 1 (true) if any element satisfies `pred` (short-circuits).
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
                        do! ctrl.BreakWith (i32Const 1)
                    do! cur <== s.Tail cur.Val
                else
                    do! lp.Break
            })
            return i32Const 0
        })
    }

/// Returns 1 (true) if all elements satisfy `pred` (short-circuits on first failure).
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


/// Find first element satisfying `pred`.
/// Returns `onFound elem` if found, otherwise `onNotFound`.
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

// ─────────────────────────────────────────────────────────────────────────────
// listChoose — filter-map (map that can filter out None values)
// ─────────────────────────────────────────────────────────────────────────────

/// Filter-map over a GC linked list (like List.choose).
/// The mapper returns an option type; only Some values are included in the result.
let listChoose
        (gen    : LabelGen)
        (s      : ListShape)       // source shape
        (rs     : ListShape)       // result shape (element type is unwrapped from option)
        (list   : WExpr)
        (mapper : WExpr -> WExpr)  // srcElem → option<resElem>
        : WExpr =
    let rev =
        listFold gen s list rs.Nil rs.BaseTy
            (fun acc elem ->
                let optVar = gen.Next "opt"
                WExpr.Let(optVar, mapper elem,
                    wasmIf (refIsNotNull (localGet optVar (WType.Ref(-1, true))))
                        (rs.Cons (structGet (cast (localGet optVar (WType.Ref(-1, true))) rs.BaseTy) 0 rs.ElemTy) acc)
                        acc))
    listRev gen rs rev

// ─────────────────────────────────────────────────────────────────────────────
// listCollect — flatMap (map to list, then flatten)
// ─────────────────────────────────────────────────────────────────────────────

/// Collect (flatMap) over a GC linked list (like List.collect).
/// The mapper returns a list; all elements from all lists are flattened into the result.
let listCollect
        (gen    : LabelGen)
        (s      : ListShape)       // source shape
        (rs     : ListShape)       // result shape (for flattened elements)
        (list   : WExpr)
        (mapper : WExpr -> WExpr)  // srcElem → list<resElem>
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list
        let! acc = mutTy rs.BaseTy rs.Nil
        while! (refIsNotNull cur.Val) do
            let! innerList = mapper (s.Head cur.Val)
            let folder acc2 elem = rs.Cons elem acc2
            let! tempAcc = listFold gen rs innerList acc.Val rs.BaseTy folder
            do! acc.Set(tempAcc)
            do! cur.Set(s.Tail cur.Val)
        return! listRev gen rs acc.Val
    }

// ─────────────────────────────────────────────────────────────────────────────
// listConcat — flatten a list of lists
// ─────────────────────────────────────────────────────────────────────────────

/// Flatten a list of lists (like List.concat).
/// `list` is a list<list<T>>, and we flatten it to list<T>.
let listConcat
        (gen          : LabelGen)
        (outerShape   : ListShape)  // shape for list<list<T>>
        (list         : WExpr)
        (elemT        : WType)      // the T from list<T>
        (elemConsIdx  : int)        // cons index for T
        : WExpr =
    let innerShape = mkListShape elemT elemConsIdx
    wasm {
        let! outerCur = mutTy outerShape.BaseTy list
        let! acc = mutTy innerShape.BaseTy innerShape.Nil
        while! (refIsNotNull outerCur.Val) do
            let! innerList = outerShape.Head outerCur.Val
            let folder acc2 elem = innerShape.Cons elem acc2
            let! tempAcc = listFold gen innerShape innerList acc.Val innerShape.BaseTy folder
            do! acc.Set(tempAcc)
            do! outerCur.Set(outerShape.Tail outerCur.Val)
        return! listRev gen innerShape acc.Val
    }

// ─────────────────────────────────────────────────────────────────────────────
// listAppend — concatenate two lists
// ─────────────────────────────────────────────────────────────────────────────

/// Append two GC linked lists (like @).
let listAppend
        (gen    : LabelGen)
        (s      : ListShape)
        (list1  : WExpr)
        (list2  : WExpr)
        : WExpr =
    wasm {
        let! cur = mutTy s.BaseTy list1
        let! acc = mutTy s.BaseTy list2
        while! (refIsNotNull cur.Val) do
            do! acc.Set(s.Cons (s.Head cur.Val) acc.Val)
            do! cur.Set(s.Tail cur.Val)
        return! listRev gen s acc.Val
    }