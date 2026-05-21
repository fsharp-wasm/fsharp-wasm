/// WasmGC array algorithm library — pure WExpr, NO Fable.AST dependency.
///
/// IMPORTANT: All wasm { } blocks must use variables bound by let!/mut
/// directly — DO NOT use gen.Acc/gen.Tmp/gen.Idx as local names.
/// Those LabelGen helpers name BLOCK labels, not locals.
/// Locals are named by freshName() when let!/Bind runs; capture the
/// returned WExpr handle and reuse it.
///
/// The Fable dispatch layer (Transforms/ArrayReplacements.fs) extracts typed
/// arguments from Fable.Expr and delegates here.
///
/// Key design: `sortWith` calls a shared $arraySortWith BCL helper instead of
/// inlining insertion sort at every call site.
module WasmGc.Patterns.ArrayPatterns

open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder
open WasmGc.Builder.Core
open WasmGc.Builder.Operators
open WasmGc.Runtime.LoopPrimitives

let private zero32 = i32Const 0

let private allocArr arrTypeIdx len zero ty = WExpr.ArrayNew(arrTypeIdx, len, zero, ty)

// ── map / mapi ──────────────────────────────────────────────────────────────

let map arrTypeIdx arrRefTy elemTy zero src (f: WExpr -> WExpr) : WExpr =
    let gen = LabelGen "map"
    wasm {
        let! (n: WExpr)   = arrayLen src
        let! (res: WExpr) = WExpr.ArrayNew(arrTypeIdx, n, zero, arrRefTy)
        do! indexedLoop gen n (fun i ->
            arraySet res i (f (arrayGet src i elemTy)))
        return res
    }

let mapi arrTypeIdx arrRefTy elemTy zeroElem src (f: WExpr -> WExpr -> WExpr) : WExpr =
    let gen = LabelGen "mapi"
    wasm {
        let! (n: WExpr)   = arrayLen src
        let! (res: WExpr) = allocArr arrTypeIdx n zeroElem arrRefTy
        do! indexedLoop gen n (fun i ->
            arraySet res i (f i (arrayGet src i elemTy)))
        return res
    }

// ── init / create ───────────────────────────────────────────────────────────

let init arrTypeIdx arrRefTy zeroElem n (f: WExpr -> WExpr) : WExpr =
    let gen = LabelGen "init"
    wasm {
        let! (res: WExpr) = allocArr arrTypeIdx n zeroElem arrRefTy
        do! indexedLoop gen n (fun i -> arraySet res i (f i))
        return res
    }

let create arrTypeIdx arrRefTy n value : WExpr =
    WExpr.ArrayNew(arrTypeIdx, n, value, arrRefTy)

// ── fold / scan ─────────────────────────────────────────────────────────────

let fold elemTy accTy src initVal (f: WExpr -> WExpr -> WExpr) : WExpr =
    let gen = LabelGen "fold"
    wasm {
        let! (n: WExpr)   = arrayLen src
        let! (acc: WVar)  = mutTy accTy initVal
        do! indexedLoop gen n (fun i -> acc <== f acc.Val (arrayGet src i elemTy))
        return acc.Val
    }

let scan arrTypeIdx arrRefTy elemTy zeroElem src initVal (f: WExpr -> WExpr -> WExpr) : WExpr =
    let gen = LabelGen "scan"
    wasm {
        let! n            = arrayLen src
        let! (res: WExpr) = WExpr.ArrayNew(arrTypeIdx, add n (i32Const 1), zeroElem, arrRefTy)
        let! (acc: WVar)  = mutTy (exprWType initVal) initVal
        do! arraySet res (i32Const 0) acc.Val
        do! indexedLoop gen n (fun i ->
            wasm {
                do! acc <== f acc.Val (arrayGet src i elemTy)
                do! arraySet res (add i (i32Const 1)) acc.Val
            })
        return res
    }

// ── filter ──────────────────────────────────────────────────────────────────
// Two-pass: collect into worst-case tmp, then copy to exact-size result.
// Uses bound CE variables (not LabelGen label names) for all local references.

let filter arrTypeIdx arrRefTy elemTy zeroElem src (pred: WExpr -> WExpr) : WExpr =
    let gen = LabelGen "filt"
    wasm {
        let! n   = arrayLen src
        let! (tmp: WExpr) = WExpr.ArrayNew(arrTypeIdx, n, zeroElem, arrRefTy)
        let! (cnt: WVar)  = mut (i32Const 0)
        do! indexedLoop gen n (fun i ->
            let elem = arrayGet src i elemTy
            wasmWhen (pred elem) (wasm {
                do! arraySet tmp cnt.Val elem
                do! cnt <== (cnt.Val +. i32Const 1)
            }))
        let! (res: WExpr) = WExpr.ArrayNew(arrTypeIdx, cnt.Val, zeroElem, arrRefTy)
        do! WExpr.ArrayCopy(res, i32Const 0, tmp, i32Const 0, cnt.Val)
        return res
    }

// ── append ──────────────────────────────────────────────────────────────────

let append arrTypeIdx arrRefTy zero a b : WExpr =
    let gen = LabelGen "app"
    wasm {
        let! (la: WExpr)  = arrayLen a
        let! (lb: WExpr)  = arrayLen b
        let! (res: WExpr) = WExpr.ArrayNew(arrTypeIdx, add la lb, zero, arrRefTy)
        do! WExpr.ArrayCopy(res, i32Const 0, a, i32Const 0, la)
        do! WExpr.ArrayCopy(res, la, b, i32Const 0, lb)
        return res
    }

// ── fill (mutates target in place) ──────────────────────────────────────────

let fill target start count value : WExpr =
    let gen = LabelGen "fill"
    wasm {
        let! (i: WVar)    = mut start
        let! (lim: WExpr) = add start count
        while (i.Val <. lim) do
            do! arraySet target i.Val value
            do! i <== (i.Val +. i32Const 1)
    }

// ── sort ────────────────────────────────────────────────────────────────────

/// sortWith via shared $arraySortWith BCL helper — ONE copy per module.
/// Eliminates code bloat from inlining insertion sort at every call site.
/// BclRegistry must register $arraySortWith alongside string/math helpers.
let sortWith arrTypeIdx arrRefTy zero src cmpClosure : WExpr =
    let gen = LabelGen "sortw"
    wasm {
        let! n   = arrayLen src
        let! (res: WExpr) = allocArr arrTypeIdx n zero arrRefTy
        do! WExpr.ArrayCopy(res, i32Const 0, src, i32Const 0, n)
        do! WExpr.Call("$arraySortWith", [res; cmpClosure; n], WType.Void)
        return res
    }

/// sortBy — inline insertion sort keyed by a pure function (typically tiny arrays).
let sortBy arrTypeIdx arrRefTy elemTy keyTy zero src (keyFn: WExpr -> WExpr) : WExpr =
    let gen = LabelGen "sortb"
    let cmp a b =
        match keyTy with
        // | WType.I32 -> sub (keyFn a) (keyFn b)
        | WType.F64 ->
            WExpr.If(WExpr.Compare(WCompareOp.LtS, keyFn a, keyFn b), i32Const -1,
                WExpr.If(WExpr.Compare(WCompareOp.GtS, keyFn a, keyFn b), i32Const 1,
                         i32Const 0, WType.I32), WType.I32)
        | _         -> sub (keyFn a) (keyFn b)
    wasm {
        let! (n: WExpr)   = arrayLen src
        let! (res: WExpr) = WExpr.ArrayNew(arrTypeIdx, n, zero, arrRefTy)
        do! WExpr.ArrayCopy(res, i32Const 0, src, i32Const 0, n)
        do! insertionSortInPlace gen res n elemTy
                (fun a i -> arrayGet a i elemTy)
                (fun a i v -> arraySet a i v)
                cmp
        return res
    }

// ── iter / exists / forall / tryFindIndex ────────────────────────────────────

let iter elemTy src (f: WExpr -> WExpr) : WExpr =
    let gen = LabelGen "iter"
    wasm {
        let! n = arrayLen src
        do! indexedLoop gen n (fun i -> f (arrayGet src i elemTy))
    }

let exists elemTy src (pred: WExpr -> WExpr) : WExpr =
    Wasm.withEarlyExit WType.I32 (fun brk ->
        let gen = LabelGen "any"
        wasm {
            let! n = arrayLen src
            do! indexedLoop gen n (fun i ->
                wasmWhen (pred (arrayGet src i elemTy)) (brk (i32Const 1)))
            return i32Const 0
        })

let forall elemTy src (pred: WExpr -> WExpr) : WExpr =
    Wasm.withEarlyExit WType.I32 (fun brk ->
        let gen = LabelGen "all"
        wasm {
            let! n = arrayLen src
            do! indexedLoop gen n (fun i ->
                wasmWhen (WExpr.Unary(WUnaryOp.Eqz, pred (arrayGet src i elemTy), WType.I32))
                    (brk (i32Const 0)))
            return i32Const 1
        })

let tryFindIndex elemTy src (pred: WExpr -> WExpr) : WExpr =
    Wasm.withEarlyExit WType.I32 (fun brk ->
        let gen = LabelGen "fnd"
        wasm {
            let! n = arrayLen src
            do! indexedLoop gen n (fun i ->
                wasmWhen (pred (arrayGet src i elemTy)) (brk i))
            return i32Const -1
        })

let map2 arrTypeIdx arrRefTy elemATy elemBTy zero a b (f: WExpr -> WExpr -> WExpr) : WExpr =
    let gen = LabelGen "map2"
    wasm {
        let! (n: WExpr)   = arrayLen a
        let! (res: WExpr) = WExpr.ArrayNew(arrTypeIdx, n, zero, arrRefTy)
        do! indexedLoop gen n (fun i ->
            arraySet res i
                (f (arrayGet a i elemATy) (arrayGet b i elemBTy)))
        return res
    }
