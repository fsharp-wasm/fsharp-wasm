/// WasmGc Optimization Passes — applied to WasmIR before emission.
///
/// Priority-ordered passes (see docs/next-better-advanced-implementation/05-optimization-passes.md):
///   P0: constant folding, dead code elimination, join-point inlining
///   P1: let-alias removal, tail-call-to-loop, known-call optimization
///   P2: contification, constructor propagation (future)
///
/// All passes are pure WExpr → WExpr transformations, safe to compose.
module Fable.Transforms.WasmGc.WasmGcOptimize

open Fable.AST.WasmGc

// ─────────────────────────────────────────────────────────────────
// Tree-walk helpers
// ─────────────────────────────────────────────────────────────────

/// Map a function over all direct sub-expressions of a WExpr.
let mapSubExprs (f: WExpr -> WExpr) (expr: WExpr) : WExpr =
    match expr with
    | WExpr.Let(n, v, b) -> WExpr.Let(n, f v, f b)
    | WExpr.LetMut(n, v, b) -> WExpr.LetMut(n, f v, f b)
    | WExpr.Assign(n, v) -> WExpr.Assign(n, f v)
    | WExpr.Call(fn, args, t) -> WExpr.Call(fn, List.map f args, t)
    | WExpr.CallIndirect(ref_, args, t) -> WExpr.CallIndirect(f ref_, List.map f args, t)
    | WExpr.CallVirtual(obj, mi, args, t) -> WExpr.CallVirtual(f obj, mi, List.map f args, t)
    | WExpr.StructNew(ti, fields, t) -> WExpr.StructNew(ti, List.map f fields, t)
    | WExpr.StructGet(obj, fi, t) -> WExpr.StructGet(f obj, fi, t)
    | WExpr.StructSet(obj, fi, v) -> WExpr.StructSet(f obj, fi, f v)
    | WExpr.ArrayNew(ti, sz, init, t) -> WExpr.ArrayNew(ti, f sz, f init, t)
    | WExpr.ArrayNewFixed(ti, elems, t) -> WExpr.ArrayNewFixed(ti, List.map f elems, t)
    | WExpr.ArrayGet(arr, idx, t) -> WExpr.ArrayGet(f arr, f idx, t)
    | WExpr.ArraySet(arr, idx, v) -> WExpr.ArraySet(f arr, f idx, f v)
    | WExpr.ArrayLen(arr) -> WExpr.ArrayLen(f arr)
    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) -> WExpr.ArrayCopy(f dst, f dstOff, f src, f srcOff, f len)
    | WExpr.If(c, t_, e, t) -> WExpr.If(f c, f t_, f e, t)
    | WExpr.Loop(l, b, t) -> WExpr.Loop(l, f b, t)
    | WExpr.Block(l, b, t) -> WExpr.Block(l, f b, t)
    | WExpr.Break(l, v) -> WExpr.Break(l, Option.map f v)
    | WExpr.Continue(l, args) -> WExpr.Continue(l, List.map f args)
    | WExpr.Return(v) -> WExpr.Return(Option.map f v)
    | WExpr.Sequence exprs -> WExpr.Sequence(List.map f exprs)
    | WExpr.JoinPoint(l, ps, body, cont, t) -> WExpr.JoinPoint(l, ps, f body, f cont, t)
    | WExpr.JoinApply(l, args, t) -> WExpr.JoinApply(l, List.map f args, t)
    | WExpr.SwitchInt(scrut, cases, def_, t) ->
        WExpr.SwitchInt(f scrut, List.map (fun (v, e) -> v, f e) cases, f def_, t)
    | WExpr.TagOf obj -> WExpr.TagOf(f obj)
    | WExpr.Cast(obj, t) -> WExpr.Cast(f obj, t)
    | WExpr.Closure(fn, caps, t) -> WExpr.Closure(fn, List.map f caps, t)
    | WExpr.ClosureApply(fn, args, ft, ct, cc, t) -> WExpr.ClosureApply(f fn, List.map f args, ft, ct, cc, t)
    | WExpr.Unary(op, o, t) -> WExpr.Unary(op, f o, t)
    | WExpr.Binary(op, l, r, t) -> WExpr.Binary(op, f l, f r, t)
    | WExpr.Compare(op, l, r) -> WExpr.Compare(op, f l, f r)
    | WExpr.TryCatch(b, catch_, fin_, t) ->
        let catch' = catch_ |> Option.map (fun (n, e) -> n, f e)
        let fin' = fin_ |> Option.map f
        WExpr.TryCatch(f b, catch', fin', t)
    | WExpr.Throw e -> WExpr.Throw(f e)
    | WExpr.RefIsNull obj -> WExpr.RefIsNull(f obj)
    | WExpr.TailCall(fn, args, t) -> WExpr.TailCall(fn, List.map f args, t)
    | WExpr.TailCallRef(fn, args, ft, ct, cc, t) -> WExpr.TailCallRef(f fn, List.map f args, ft, ct, cc, t)
    // Atoms — nothing to map
    | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _ | WExpr.Nop -> expr
    | WExpr.GlobalSet(n, v) -> WExpr.GlobalSet(n, f v)

/// Bottom-up transformation: recursively transform sub-expressions, then apply f.
let rec visitFromInsideOut (f: WExpr -> WExpr) (expr: WExpr) : WExpr =
    let expr' = mapSubExprs (visitFromInsideOut f) expr
    f expr'

/// Top-down transformation: apply f first, then recursively transform sub-expressions.
let rec visitFromOutsideIn (f: WExpr -> WExpr) (expr: WExpr) : WExpr =
    let expr' = f expr
    mapSubExprs (visitFromOutsideIn f) expr'

// ─────────────────────────────────────────────────────────────────
// Check if expression is pure (no observable side effects)
// ─────────────────────────────────────────────────────────────────

let rec isPure (expr: WExpr) : bool =
    match expr with
    | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _ | WExpr.Nop -> true
    | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) -> isPure v && isPure b
    | WExpr.Unary(_, o, _) -> isPure o
    | WExpr.Binary(_, l, r, _) -> isPure l && isPure r
    | WExpr.Compare(_, l, r) -> isPure l && isPure r
    | WExpr.If(c, t_, e, _) -> isPure c && isPure t_ && isPure e
    | WExpr.StructGet(obj, _, _) -> isPure obj
    | WExpr.Sequence exprs -> List.forall isPure exprs
    | WExpr.Cast(obj, _) -> isPure obj
    | WExpr.RefIsNull obj -> isPure obj
    | _ -> false // conservative: calls, struct.new, assigns are impure

// ─────────────────────────────────────────────────────────────────
// Check if a name is referenced in an expression
// ─────────────────────────────────────────────────────────────────

let rec isUsed (name: string) (expr: WExpr) : bool =
    match expr with
    | WExpr.LocalGet(n, _) -> n = name
    | WExpr.Assign(n, v) -> n = name || isUsed name v
    | _ ->
        // Check sub-expressions (we don't need to recurse into bindings
        // that shadow the name, but for simplicity we're conservative)
        let mutable found = false
        let _ =
            mapSubExprs (fun e ->
                if not found then
                    if isUsed name e then found <- true
                e
            ) expr
        found

// ─────────────────────────────────────────────────────────────────
// P0 Pass 1: Constant Folding
// ─────────────────────────────────────────────────────────────────
// Reference: any compiler textbook, e.g., Appel "Modern Compiler Implementation in ML" Ch. 17

let foldConstants (expr: WExpr) : WExpr =
    visitFromInsideOut (fun e ->
        match e with
        // i32 arithmetic
        | WExpr.Binary(WBinaryOp.Add, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a + b))
        | WExpr.Binary(WBinaryOp.Sub, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a - b))
        | WExpr.Binary(WBinaryOp.Mul, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a * b))
        | WExpr.Binary(WBinaryOp.DivS, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) when b <> 0 ->
            WExpr.Const(WConst.I32(a / b))
        | WExpr.Binary(WBinaryOp.RemS, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) when b <> 0 ->
            WExpr.Const(WConst.I32(a % b))
        | WExpr.Binary(WBinaryOp.And, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a &&& b))
        | WExpr.Binary(WBinaryOp.Or, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a ||| b))
        | WExpr.Binary(WBinaryOp.Xor, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a ^^^ b))
        | WExpr.Binary(WBinaryOp.Shl, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a <<< (b &&& 31)))
        | WExpr.Binary(WBinaryOp.ShrS, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b), _) ->
            WExpr.Const(WConst.I32(a >>> (b &&& 31)))
        // f64 arithmetic
        | WExpr.Binary(WBinaryOp.Add, WExpr.Const(WConst.F64 a), WExpr.Const(WConst.F64 b), _) ->
            WExpr.Const(WConst.F64(a + b))
        | WExpr.Binary(WBinaryOp.Sub, WExpr.Const(WConst.F64 a), WExpr.Const(WConst.F64 b), _) ->
            WExpr.Const(WConst.F64(a - b))
        | WExpr.Binary(WBinaryOp.Mul, WExpr.Const(WConst.F64 a), WExpr.Const(WConst.F64 b), _) ->
            WExpr.Const(WConst.F64(a * b))
        | WExpr.Binary(WBinaryOp.DivS, WExpr.Const(WConst.F64 a), WExpr.Const(WConst.F64 b), _) when b <> 0.0 ->
            WExpr.Const(WConst.F64(a / b))
        // i32 comparisons on constants
        | WExpr.Compare(WCompareOp.Eq, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b)) ->
            WExpr.Const(WConst.I32(if a = b then 1 else 0))
        | WExpr.Compare(WCompareOp.Ne, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b)) ->
            WExpr.Const(WConst.I32(if a <> b then 1 else 0))
        | WExpr.Compare(WCompareOp.LtS, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b)) ->
            WExpr.Const(WConst.I32(if a < b then 1 else 0))
        | WExpr.Compare(WCompareOp.LeS, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b)) ->
            WExpr.Const(WConst.I32(if a <= b then 1 else 0))
        | WExpr.Compare(WCompareOp.GtS, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b)) ->
            WExpr.Const(WConst.I32(if a > b then 1 else 0))
        | WExpr.Compare(WCompareOp.GeS, WExpr.Const(WConst.I32 a), WExpr.Const(WConst.I32 b)) ->
            WExpr.Const(WConst.I32(if a >= b then 1 else 0))
        // if(const) → inline branch
        | WExpr.If(WExpr.Const(WConst.I32 1), then_, _, _) -> then_
        | WExpr.If(WExpr.Const(WConst.I32 0), _, else_, _) -> else_
        // i32 identity/annihilator
        | WExpr.Binary(WBinaryOp.Add, x, WExpr.Const(WConst.I32 0), _)
        | WExpr.Binary(WBinaryOp.Add, WExpr.Const(WConst.I32 0), x, _)
        | WExpr.Binary(WBinaryOp.Sub, x, WExpr.Const(WConst.I32 0), _) -> x
        | WExpr.Binary(WBinaryOp.Mul, x, WExpr.Const(WConst.I32 1), _)
        | WExpr.Binary(WBinaryOp.Mul, WExpr.Const(WConst.I32 1), x, _) -> x
        | WExpr.Binary(WBinaryOp.Mul, _, WExpr.Const(WConst.I32 0), _)
        | WExpr.Binary(WBinaryOp.Mul, WExpr.Const(WConst.I32 0), _, _) -> WExpr.Const(WConst.I32 0)
        | _ -> e
    ) expr

// ─────────────────────────────────────────────────────────────────
// P0 Pass 2: Dead Code Elimination
// ─────────────────────────────────────────────────────────────────
// Reference: Appel "Modern Compiler Implementation in ML" Ch. 17

/// Remove `let x = e in body` when x is never used in body AND e is pure.
let eliminateDeadCode (expr: WExpr) : WExpr =
    visitFromInsideOut (fun e ->
        match e with
        | WExpr.Let(name, value, body) when not (isUsed name body) && isPure value ->
            body
        | WExpr.LetMut(name, value, body) when not (isUsed name body) && isPure value ->
            body
        // Sequence: drop pure non-last expressions
        | WExpr.Sequence [] -> WExpr.Nop
        | WExpr.Sequence [single] -> single
        | WExpr.Sequence exprs ->
            let n      = List.length exprs
            let last   = exprs.[n - 1]
            let others = exprs |> List.take (n - 1)
            let live   = others |> List.filter (fun e -> not (isPure e))
            match live with
            | [] -> last
            | _ -> WExpr.Sequence(live @ [last])
        | _ -> e
    ) expr

// ─────────────────────────────────────────────────────────────────
// P0 Pass 3: Join-Point Inlining (single-use)
// ─────────────────────────────────────────────────────────────────
// Reference: Maurer et al., "Compiling without Continuations" (PLDI 2017)

/// Count uses of a join-point label in an expression.
let rec countJoinApply (label: string) (expr: WExpr) : int =
    match expr with
    | WExpr.JoinApply(l, _, _) -> if l = label then 1 else 0
    | _ ->
        let mutable total = 0
        let _ = mapSubExprs (fun e -> total <- total + countJoinApply label e; e) expr
        total

/// Substitute all JoinApply(label, args) with the body (with args bound to parms).
/// This is the inlining step.
let rec inlineJoinApply (label: string) (parms: (string * WType) list) (body: WExpr) (expr: WExpr) : WExpr =
    match expr with
    | WExpr.JoinApply(l, args, _) when l = label ->
        // Bind args to parms and substitute into body
        let bindings = List.zip parms args
        List.foldBack
            (fun ((paramName, _), argExpr) acc -> WExpr.Let(paramName, argExpr, acc))
            bindings
            body
    | _ -> mapSubExprs (inlineJoinApply label parms body) expr

/// Inline join points that are called exactly once.
let inlineSingleUseJoins (expr: WExpr) : WExpr =
    visitFromOutsideIn (fun e ->
        match e with
        | WExpr.JoinPoint(label, parms, body, cont, _ty) ->
            let uses = countJoinApply label cont
            if uses = 1 then
                // Inline: remove the JoinPoint wrapper, substitute in cont
                inlineJoinApply label parms body cont
            else
                e
        | _ -> e
    ) expr

// ─────────────────────────────────────────────────────────────────
// P1 Pass: Let Alias Removal
// ─────────────────────────────────────────────────────────────────
// When `let x = y` where y is another local, substitute x → y everywhere.

/// Substitute all occurrences of name with replacement in expr.
let rec substituteLocal (name: string) (replacement: WExpr) (expr: WExpr) : WExpr =
    match expr with
    | WExpr.LocalGet(n, _) when n = name -> replacement
    // Don't substitute into let-bindings that shadow the name
    | WExpr.Let(n, v, b) ->
        let v' = substituteLocal name replacement v
        let b' = if n = name then b else substituteLocal name replacement b
        WExpr.Let(n, v', b')
    | WExpr.LetMut(n, v, b) ->
        let v' = substituteLocal name replacement v
        let b' = if n = name then b else substituteLocal name replacement b
        WExpr.LetMut(n, v', b')
    | _ -> mapSubExprs (substituteLocal name replacement) expr

let removeLetAliases (expr: WExpr) : WExpr =
    visitFromOutsideIn (fun e ->
        match e with
        | WExpr.Let(name, (WExpr.LocalGet(_, _) as alias), body) ->
            // let x = y → substitute x with y in body
            substituteLocal name alias body
        | _ -> e
    ) expr

// ─────────────────────────────────────────────────────────────────
// Compose all passes into a single optimization run
// ─────────────────────────────────────────────────────────────────

/// Run all implemented optimization passes on a single function body.
let optimizeFuncBody (expr: WExpr) : WExpr =
    // Inline join points to fixed-point: one `visitFromOutsideIn` pass only inlines one
    // top-level join point per pass, so chains of nested join points need multiple passes.
    let rec inlineAllJoins (expr: WExpr) =
        let expr' = inlineSingleUseJoins expr
        if expr' = expr then expr else inlineAllJoins expr'
    expr
    |> inlineAllJoins     // P0: join-point inlining (fixed-point)
    |> foldConstants      // P0: constant folding
    |> eliminateDeadCode  // P0: dead code elimination
    |> removeLetAliases   // P1: let alias removal
    |> foldConstants      // second pass — folding after alias removal may open new opportunities

/// Apply optimizations to all functions in a WModule.
let optimizeModule (wmod: WModule) : WModule =
    { wmod with
        Functions =
            wmod.Functions
            |> List.map (fun f -> { f with Body = optimizeFuncBody f.Body }) }
