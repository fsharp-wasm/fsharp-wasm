/// Single, exhaustive traversal primitive for the WExpr IR.
///
/// Every pass that walks the tree (Lower, Normalizer, Locals, Optimize, closure
/// fix-ups, validators, ...) must be built on `children` / `mapChildren` instead of
/// re-implementing a partial `match`. Partial copies silently skipped nodes such as
/// `Return`, `Continue`, `Closure` captures or `Cast`, which left un-lowered
/// ClosureApply nodes and undeclared locals behind.
///
/// The two functions below are deliberately written WITHOUT a wildcard arm: when a
/// new WExpr case is added the compiler flags both of them (FS0025) and nothing can
/// be forgotten.
module WasmGc.Core.Traverse

open WasmGc.Core.AST

/// All immediate sub-expressions, left-to-right in evaluation order.
let children (expr: WExpr) : WExpr list =
    match expr with
    | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _ | WExpr.FuncRef _
    | WExpr.Nop | WExpr.MemorySize -> []
    | WExpr.GlobalSet(_, v) | WExpr.Assign(_, v) -> [ v ]
    | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) -> [ v; b ]
    | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _) -> args
    | WExpr.CallIndirect(f, args, _) -> f :: args
    | WExpr.CallVirtual(o, _, _, _, _, args, _) -> o :: args
    | WExpr.StructNew(_, fs, _) | WExpr.ArrayNewFixed(_, fs, _) -> fs
    | WExpr.StructGet(o, _, _) -> [ o ]
    | WExpr.StructSet(o, _, v) -> [ o; v ]
    | WExpr.ArrayNew(_, s, i, _) -> [ s; i ]
    | WExpr.ArrayGet(a, i, _) -> [ a; i ]
    | WExpr.ArraySet(a, i, v) -> [ a; i; v ]
    | WExpr.ArrayLen a -> [ a ]
    | WExpr.ArrayCopy(d, dof, s, sof, n) -> [ d; dof; s; sof; n ]
    | WExpr.If(c, t, e, _) -> [ c; t; e ]
    | WExpr.Loop(_, b, _) | WExpr.Block(_, b, _) -> [ b ]
    | WExpr.Break(_, v) -> Option.toList v
    | WExpr.Continue(_, args) -> args
    | WExpr.Return v -> Option.toList v
    | WExpr.Sequence xs -> xs
    | WExpr.JoinPoint(_, _, b, c, _) -> [ b; c ]
    | WExpr.JoinApply(_, args, _) -> args
    | WExpr.SwitchInt(s, cases, d, _) -> s :: (List.map snd cases) @ [ d ]
    | WExpr.TagOf o | WExpr.Cast(o, _) | WExpr.RefIsNull o | WExpr.RefTest(o, _) -> [ o ]
    | WExpr.Unary(_, x, _) -> [ x ]
    | WExpr.Binary(_, a, b, _) | WExpr.Compare(_, a, b) -> [ a; b ]
    | WExpr.Closure(_, caps, _) -> caps
    | WExpr.ClosureApply(c, args, _, _, _, _) | WExpr.TailCallRef(c, args, _, _, _, _) -> c :: args
    | WExpr.CallRef(_, args, ptr, _) | WExpr.ReturnCallRef(_, args, ptr, _) -> args @ [ ptr ]
    | WExpr.TryCatch(b, c, f, _) -> b :: (c |> Option.map snd |> Option.toList) @ Option.toList f
    | WExpr.Throw x | WExpr.MemoryGrow x | WExpr.MemLoad(_, _, x) -> [ x ]
    | WExpr.MemStore(_, _, a, v) -> [ a; v ]

/// Rebuild `expr` with `f` applied to every immediate sub-expression.
let mapChildren (f: WExpr -> WExpr) (expr: WExpr) : WExpr =
    let fs = List.map f
    match expr with
    | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _ | WExpr.FuncRef _
    | WExpr.Nop | WExpr.MemorySize -> expr
    | WExpr.GlobalSet(n, v) -> WExpr.GlobalSet(n, f v)
    | WExpr.Assign(n, v) -> WExpr.Assign(n, f v)
    | WExpr.Let(n, v, b) -> WExpr.Let(n, f v, f b)
    | WExpr.LetMut(n, v, b) -> WExpr.LetMut(n, f v, f b)
    | WExpr.Call(n, a, t) -> WExpr.Call(n, fs a, t)
    | WExpr.TailCall(n, a, t) -> WExpr.TailCall(n, fs a, t)
    | WExpr.CallIndirect(c, a, t) -> WExpr.CallIndirect(f c, fs a, t)
    | WExpr.CallVirtual(o, b, v, m, ft, a, t) -> WExpr.CallVirtual(f o, b, v, m, ft, fs a, t)
    | WExpr.StructNew(i, x, t) -> WExpr.StructNew(i, fs x, t)
    | WExpr.StructGet(o, i, t) -> WExpr.StructGet(f o, i, t)
    | WExpr.StructSet(o, i, v) -> WExpr.StructSet(f o, i, f v)
    | WExpr.ArrayNew(i, s, n, t) -> WExpr.ArrayNew(i, f s, f n, t)
    | WExpr.ArrayNewFixed(i, x, t) -> WExpr.ArrayNewFixed(i, fs x, t)
    | WExpr.ArrayGet(a, i, t) -> WExpr.ArrayGet(f a, f i, t)
    | WExpr.ArraySet(a, i, v) -> WExpr.ArraySet(f a, f i, f v)
    | WExpr.ArrayLen a -> WExpr.ArrayLen(f a)
    | WExpr.ArrayCopy(d, dof, s, sof, n) -> WExpr.ArrayCopy(f d, f dof, f s, f sof, f n)
    | WExpr.If(c, t, e, ty) -> WExpr.If(f c, f t, f e, ty)
    | WExpr.Loop(l, b, t) -> WExpr.Loop(l, f b, t)
    | WExpr.Block(l, b, t) -> WExpr.Block(l, f b, t)
    | WExpr.Break(l, v) -> WExpr.Break(l, Option.map f v)
    | WExpr.Continue(l, a) -> WExpr.Continue(l, fs a)
    | WExpr.Return v -> WExpr.Return(Option.map f v)
    | WExpr.Sequence xs -> WExpr.Sequence(fs xs)
    | WExpr.JoinPoint(l, p, b, c, t) -> WExpr.JoinPoint(l, p, f b, f c, t)
    | WExpr.JoinApply(l, a, t) -> WExpr.JoinApply(l, fs a, t)
    | WExpr.SwitchInt(s, cs, d, t) -> WExpr.SwitchInt(f s, cs |> List.map (fun (n, e) -> n, f e), f d, t)
    | WExpr.TagOf o -> WExpr.TagOf(f o)
    | WExpr.Cast(o, t) -> WExpr.Cast(f o, t)
    | WExpr.RefIsNull o -> WExpr.RefIsNull(f o)
    | WExpr.RefTest(o, t) -> WExpr.RefTest(f o, t)
    | WExpr.Unary(op, x, t) -> WExpr.Unary(op, f x, t)
    | WExpr.Binary(op, a, b, t) -> WExpr.Binary(op, f a, f b, t)
    | WExpr.Compare(op, a, b) -> WExpr.Compare(op, f a, f b)
    | WExpr.Closure(n, c, t) -> WExpr.Closure(n, fs c, t)
    | WExpr.ClosureApply(c, a, x, y, z, t) -> WExpr.ClosureApply(f c, fs a, x, y, z, t)
    | WExpr.TailCallRef(c, a, x, y, z, t) -> WExpr.TailCallRef(f c, fs a, x, y, z, t)
    | WExpr.CallRef(i, a, p, t) -> WExpr.CallRef(i, fs a, f p, t)
    | WExpr.ReturnCallRef(i, a, p, t) -> WExpr.ReturnCallRef(i, fs a, f p, t)
    | WExpr.TryCatch(b, c, fin, t) ->
        WExpr.TryCatch(f b, c |> Option.map (fun (n, e) -> n, f e), Option.map f fin, t)
    | WExpr.Throw x -> WExpr.Throw(f x)
    | WExpr.MemoryGrow x -> WExpr.MemoryGrow(f x)
    | WExpr.MemLoad(k, o, a) -> WExpr.MemLoad(k, o, f a)
    | WExpr.MemStore(k, o, a, v) -> WExpr.MemStore(k, o, f a, f v)

/// Bottom-up rewrite: children first, then `f` on the rebuilt node.
let rewrite (f: WExpr -> WExpr option) (expr: WExpr) : WExpr =
    let rec go e =
        let e' = mapChildren go e
        match f e' with
        | Some r -> r
        | None -> e'
    go expr

/// Bottom-up fold over every node.
let rec fold (f: 'a -> WExpr -> 'a) (acc: 'a) (expr: WExpr) : 'a =
    f (List.fold (fold f) acc (children expr)) expr

let rec exists (pred: WExpr -> bool) (expr: WExpr) : bool =
    pred expr || List.exists (exists pred) (children expr)

let count (pred: WExpr -> bool) (expr: WExpr) : int =
    fold (fun n e -> if pred e then n + 1 else n) 0 expr

// ─────────────────────────────────────────────────────────────────
// Type-section helpers (shared by the binary encoder and the WAT printer)
// ─────────────────────────────────────────────────────────────────

/// Type indices a WType refers to.
let rec wTypeRefs (t: WType) : int list =
    match t with
    | WType.Ref(i, _) -> [ i ]
    | WType.Func(a, r) -> (a @ r) |> List.collect wTypeRefs
    | WType.Struct fs -> fs |> List.collect (fun f -> wTypeRefs f.Type)
    | WType.Array(e, _) -> wTypeRefs e
    | _ -> []

/// Type indices a type definition refers to (field/param types and the supertype).
let typeDefRefs (d: WTypeDef) : int list =
    match d with
    | WTypeDef.Struct(fields, sup) -> (fields |> List.collect (fun f -> wTypeRefs f.Type)) @ Option.toList sup
    | WTypeDef.Array(elem, _) -> wTypeRefs elem
    | WTypeDef.Func(ps, r) -> (r :: ps) |> List.collect wTypeRefs

/// Contiguous recursion groups `(first, last)` covering indices 0..n-1.
///
/// WasmGC only allows a type to refer to an EARLIER type, or to types of its own `rec` group.
/// Type indices are baked into every instruction, so types cannot be reordered; instead each
/// forward reference i → j (j > i) widens the group to [i..j].  Self references need no group.
/// Types without forward references stay singleton groups, which keeps their canonical identity
/// (e.g. `$AnyFn`, `$WasmStr`) equal across modules.
let recGroups (refs: int list[]) : (int * int) list =
    let n = refs.Length
    if n = 0 then []
    else
        let reach i = refs.[i] |> List.filter (fun r -> r < n) |> List.fold max i
        let groups = ResizeArray<int * int>()
        let mutable start = 0
        let mutable hi = reach 0
        for i in 1 .. n - 1 do
            if i > hi then
                groups.Add((start, hi))
                start <- i
                hi <- reach i
            else
                hi <- max hi (reach i)
        groups.Add((start, hi))
        List.ofSeq groups

// ─────────────────────────────────────────────────────────────────
// Tail positions
// ─────────────────────────────────────────────────────────────────

/// Rewrite calls in TAIL position of a function body (result type `resultTy`) into
/// `return_call` / `return_call_ref`, so recursion through them runs in constant stack:
///
///   Call(f, …)         → TailCall(f, …)           (known functions; `$`-helpers are left alone)
///   ClosureApply(…)    → TailCallRef(…)           (local `let rec` closures, mutual recursion, CPS)
///
/// Tail positions: the body of Let/LetMut, both branches of If, the last element of a Sequence,
/// and BOTH the body and the continuation of a JoinPoint.  Never descends into TryCatch (a call
/// inside a `try` is not a tail call) nor into loops.
/// The callee's result type must equal `resultTy` exactly, as `return_call` requires.
let rec markTailCalls (resultTy: WType) (expr: WExpr) : WExpr =
    let go = markTailCalls resultTy
    match expr with
    | WExpr.Call(f, args, t) when t = resultTy && not (f.StartsWith "$") -> WExpr.TailCall(f, args, t)
    | WExpr.ClosureApply(c, args, fti, cti, cc, t) when t = resultTy -> WExpr.TailCallRef(c, args, fti, cti, cc, t)
    | WExpr.Let(n, v, b) -> WExpr.Let(n, v, go b)
    | WExpr.LetMut(n, v, b) -> WExpr.LetMut(n, v, go b)
    | WExpr.If(c, t, e, ty) -> WExpr.If(c, go t, go e, ty)
    | WExpr.Sequence xs when not xs.IsEmpty ->
        WExpr.Sequence((xs |> List.take (xs.Length - 1)) @ [ go (List.last xs) ])
    | WExpr.JoinPoint(l, p, b, c, t) -> WExpr.JoinPoint(l, p, go b, go c, t)
    | _ -> expr
