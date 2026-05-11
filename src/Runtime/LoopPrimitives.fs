/// Reusable low-level loop primitives for WasmGC code generation.
///
/// This module intentionally contains only loop shapes and shared sort/rebuild
/// helpers that can be consumed by both list and array operation modules.
module WasmGc.Runtime.LoopPrimitives

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder
open WasmGc.Builder.Core


open WasmGc.Runtime.ListShape
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

// ─────────────────────────────────────────────────────────────────────────────
// insertionSortInPlace — shared between Array.sort and List.sort
// ─────────────────────────────────────────────────────────────────────────────

/// In-place insertion sort over a GC array.
///
/// `cmp a b` must return an i32-like ordering:
/// - negative if a < b
/// - zero if a = b
/// - positive if a > b
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
