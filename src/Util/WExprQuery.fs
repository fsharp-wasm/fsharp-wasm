/// Structural query and rewrite operations over the WExpr IR.
///
/// Used by: Optimizer, Validator, IrDump, test helpers.
/// No Ctx dependency — pure tree operations.
///
/// Provides:
/// - children: list all immediate sub-expressions
/// - fold: bottom-up aggregation (e.g., collect all names)
/// - collect: gather all nodes matching a predicate
/// - rewrite: bottom-up transformation (e.g., eliminate dead code)
module WasmGc.Util.WExprQuery

open WasmGc.Core.AST

// ─────────────────────────────────────────────────────────────────
// Basic traversal
// ─────────────────────────────────────────────────────────────────

/// All immediate subexpressions (for bottom-up fold / rewrite).
let children (expr: WExpr) : WExpr list =
    match expr with
    | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b)         -> [v; b]
    | WExpr.If(c, t, e, _)                                -> [c; t; e]
    | WExpr.Sequence xs                                    -> xs
    | WExpr.Block(_, b, _) | WExpr.Loop(_, b, _)          -> [b]
    | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _)
    | WExpr.CallIndirect(_, args, _)                       -> args
    | WExpr.ClosureApply(clo, args, _, _, _, _)
    | WExpr.TailCallRef(clo, args, _, _, _, _)             -> clo :: args
    | WExpr.CallRef(_, args, ptr, _)
    | WExpr.ReturnCallRef(_, args, ptr, _)                 -> ptr :: args
    | WExpr.CallVirtual(box, _, _, _, _, args, _)          -> box :: args
    | WExpr.Binary(_, a, b, _) | WExpr.Compare(_, a, b)   -> [a; b]
    | WExpr.Unary(_, x, _)                                 -> [x]
    | WExpr.Assign(_, v) | WExpr.GlobalSet(_, v)           -> [v]
    | WExpr.Cast(x, _) | WExpr.RefIsNull x | WExpr.RefTest(x, _)
    | WExpr.TagOf x | WExpr.ArrayLen x | WExpr.Throw x
    | WExpr.MemoryGrow x                                   -> [x]
    | WExpr.ArrayGet(a, i, _)                              -> [a; i]
    | WExpr.ArraySet(a, i, v)                              -> [a; i; v]
    | WExpr.ArrayNew(_, s, init, _)                        -> [s; init]
    | WExpr.ArrayNewFixed(_, fs, _)                        -> fs
    | WExpr.ArrayCopy(d, do_, s, so, n)                    -> [d; do_; s; so; n]
    | WExpr.StructNew(_, fs, _)                            -> fs
    | WExpr.StructGet(o, _, _)                             -> [o]
    | WExpr.StructSet(o, _, v)                             -> [o; v]
    | WExpr.Closure(_, caps, _)                            -> caps
    | WExpr.Break(_, Some v)                               -> [v]
    | WExpr.JoinPoint(_, _, b, c, _)                       -> [b; c]
    | WExpr.JoinApply(_, args, _)                          -> args
    | WExpr.TryCatch(b, catch, fin, _) ->
        b :: (match catch with Some(_, e) -> [e] | None -> [])
          @ (match fin   with Some e      -> [e] | None -> [])
    | WExpr.SwitchInt(s, cases, def, _)                    -> s :: def :: (cases |> List.map snd)
    | WExpr.MemLoad(_, _, a)                               -> [a]
    | WExpr.MemStore(_, _, a, v)                           -> [a; v]
    | _                                                    -> []

// ─────────────────────────────────────────────────────────────────
// Fold / collect
// ─────────────────────────────────────────────────────────────────

/// Bottom-up fold over every node in the tree.
let rec fold (f: 'a -> WExpr -> 'a) (acc: 'a) (expr: WExpr) : 'a =
    let acc' = List.fold (fold f) acc (children expr)
    f acc' expr

/// Collect all nodes matching a predicate.
let collect (pred: WExpr -> bool) (expr: WExpr) : WExpr list =
    fold (fun acc e -> if pred e then e :: acc else acc) [] expr
    // |> List.rev  // Reverse to maintain depth-first order

/// Count nodes matching a predicate.
let count (pred: WExpr -> bool) (expr: WExpr) : int =
    fold (fun n e -> if pred e then n + 1 else n) 0 expr

/// True if any node satisfies the predicate.
let exists (pred: WExpr -> bool) (expr: WExpr) : bool =
    let rec go = function
        | e when pred e -> true
        | e -> children e |> List.exists go
    go expr

/// Collect all LocalGet name references.
let allLocalRefs (expr: WExpr) : (string * WType) list =
    collect (function WExpr.LocalGet _ -> true | _ -> false) expr
    |> List.choose (function WExpr.LocalGet(n, ty) -> Some(n, ty) | _ -> None)

/// Collect all Let/LetMut binding names.
let allLetBindings (expr: WExpr) : (string * WType) list =
    collect (function WExpr.Let _ | WExpr.LetMut _ -> true | _ -> false) expr
    |> List.choose (function
        | WExpr.Let(n, v, _) | WExpr.LetMut(n, v, _) -> Some(n, exprWType v)
        | _ -> None)

/// Check if a name is referenced anywhere in an expression.
let references (name: string) (expr: WExpr) : bool =
    exists (function WExpr.LocalGet(n, _) | WExpr.Assign(n, _) -> n = name | _ -> false) expr

// ─────────────────────────────────────────────────────────────────
// Rewriting and transformation -- Bottom-up rewrite
// ─────────────────────────────────────────────────────────────────

/// Rewrite every node bottom-up.  `f` returns `Some newNode` to replace, `None` to keep.
let rec rewrite (f: WExpr -> WExpr option) (expr: WExpr) : WExpr =
    // First rewrite children
    let expr' =
        match expr with
        | WExpr.Let(n, v, b)              -> WExpr.Let(n, rewrite f v, rewrite f b)
        | WExpr.LetMut(n, v, b)           -> WExpr.LetMut(n, rewrite f v, rewrite f b)
        | WExpr.If(c, t, e, ty)           -> WExpr.If(rewrite f c, rewrite f t, rewrite f e, ty)
        | WExpr.Sequence xs               -> WExpr.Sequence(List.map (rewrite f) xs)
        | WExpr.Block(l, b, ty)           -> WExpr.Block(l, rewrite f b, ty)
        | WExpr.Loop(l, b, ty)            -> WExpr.Loop(l, rewrite f b, ty)
        | WExpr.Assign(n, v)              -> WExpr.Assign(n, rewrite f v)
        | WExpr.GlobalSet(n, v)           -> WExpr.GlobalSet(n, rewrite f v)
        | WExpr.Call(n, args, ty)         -> WExpr.Call(n, List.map (rewrite f) args, ty)
        | WExpr.TailCall(n, args, ty)     -> WExpr.TailCall(n, List.map (rewrite f) args, ty)
        | WExpr.Binary(op, a, b, ty)      -> WExpr.Binary(op, rewrite f a, rewrite f b, ty)
        | WExpr.Unary(op, x, ty)          -> WExpr.Unary(op, rewrite f x, ty)
        | WExpr.Compare(op, a, b)         -> WExpr.Compare(op, rewrite f a, rewrite f b)
        | WExpr.Cast(x, ty)               -> WExpr.Cast(rewrite f x, ty)
        | WExpr.RefIsNull x               -> WExpr.RefIsNull(rewrite f x)
        | WExpr.RefTest(x, ty)            -> WExpr.RefTest(rewrite f x, ty)
        | WExpr.TagOf x                   -> WExpr.TagOf(rewrite f x)
        | WExpr.ArrayLen x                -> WExpr.ArrayLen(rewrite f x)
        | WExpr.ArrayGet(a, i, ty)        -> WExpr.ArrayGet(rewrite f a, rewrite f i, ty)
        | WExpr.ArraySet(a, i, v)         -> WExpr.ArraySet(rewrite f a, rewrite f i, rewrite f v)
        | WExpr.ArrayNew(ti, s, init, ty) -> WExpr.ArrayNew(ti, rewrite f s, rewrite f init, ty)
        | WExpr.ArrayNewFixed(ti, fs, ty) -> WExpr.ArrayNewFixed(ti, List.map (rewrite f) fs, ty)
        | WExpr.StructNew(ti, fs, ty)     -> WExpr.StructNew(ti, List.map (rewrite f) fs, ty)
        | WExpr.StructGet(o, idx, ty)     -> WExpr.StructGet(rewrite f o, idx, ty)
        | WExpr.StructSet(o, idx, v)      -> WExpr.StructSet(rewrite f o, idx, rewrite f v)
        | WExpr.Closure(n, caps, ty)      -> WExpr.Closure(n, List.map (rewrite f) caps, ty)
        | WExpr.ClosureApply(clo, args, a, b, c, ty) ->
            WExpr.ClosureApply(rewrite f clo, List.map (rewrite f) args, a, b, c, ty)
        | WExpr.TailCallRef(clo, args, a, b, c, ty) ->
            WExpr.TailCallRef(rewrite f clo, List.map (rewrite f) args, a, b, c, ty)
        | WExpr.CallRef(fti, args, ptr, ty) ->
            WExpr.CallRef(fti, List.map (rewrite f) args, rewrite f ptr, ty)
        | WExpr.ReturnCallRef(fti, args, ptr, ty) ->
            WExpr.ReturnCallRef(fti, List.map (rewrite f) args, rewrite f ptr, ty)
        | WExpr.JoinPoint(l, ps, b, c, ty) -> WExpr.JoinPoint(l, ps, rewrite f b, rewrite f c, ty)
        | WExpr.JoinApply(l, args, ty)    -> WExpr.JoinApply(l, List.map (rewrite f) args, ty)
        | WExpr.TryCatch(b, catch, fin, ty) ->
            WExpr.TryCatch(rewrite f b,
                catch |> Option.map (fun (ex, e) -> ex, rewrite f e),
                fin   |> Option.map (rewrite f), ty)
        | WExpr.SwitchInt(s, cases, def, ty) ->
            WExpr.SwitchInt(rewrite f s, cases |> List.map (fun (n,e) -> n, rewrite f e), rewrite f def, ty)
        | WExpr.Break(l, Some v)          -> WExpr.Break(l, Some(rewrite f v))
        | other                           -> other
    // Then apply f to the (possibly rewritten) node
    f expr' |> Option.defaultValue expr'

/// Substitute all `LocalGet(name, _)` with `replacement`.
let substituteLocal (name: string) (replacement: WExpr) (expr: WExpr) : WExpr =
    rewrite (function
        | WExpr.LocalGet(n, _) when n = name -> Some replacement
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────
// Shape predicates (for tests and validator)
// ─────────────────────────────────────────────────────────────────

/// Human-readable top-level shape tag (for test assertions and error messages).
let rec shapeTag = function
    | WExpr.Const(WConst.I32 n)        -> sprintf "i32(%d)" n
    | WExpr.Const(WConst.F64 v)        -> sprintf "f64(%g)" v
    | WExpr.Const _                    -> "const"
    | WExpr.LocalGet(n, _)             -> sprintf "local(%s)" n
    | WExpr.Assign(n, _)               -> sprintf "set(%s)" n
    | WExpr.GlobalGet(n, _)            -> sprintf "global(%s)" n
    | WExpr.GlobalSet(n, _)            -> sprintf "globalset(%s)" n
    | WExpr.Let(n, _, _)               -> sprintf "let(%s)" n
    | WExpr.LetMut(n, _, _)            -> sprintf "letmut(%s)" n
    | WExpr.Nop                        -> "nop"
    | WExpr.Sequence xs                -> sprintf "seq[%d]" xs.Length
    | WExpr.If _                       -> "if"
    | WExpr.Loop(l, _, _)              -> sprintf "loop(%s)" l
    | WExpr.Block(l, _, _)             -> sprintf "block(%s)" l
    | WExpr.Call(n, args, _)           -> sprintf "call(%s,%d)" n args.Length
    | WExpr.TailCall(n, args, _)       -> sprintf "tail(%s,%d)" n args.Length
    | WExpr.ClosureApply(_, args, fti, _, _, _) -> sprintf "clo_apply(fti=%d,args=%d)" fti args.Length
    | WExpr.CallRef(fti, args, _, _)   -> sprintf "call_ref(fti=%d,args=%d)" fti args.Length
    | WExpr.ReturnCallRef(fti, args, _, _) -> sprintf "ret_call_ref(fti=%d,args=%d)" fti args.Length
    | WExpr.ArrayGet _                 -> "array.get"
    | WExpr.ArraySet _                 -> "array.set"
    | WExpr.ArrayLen _                 -> "array.len"
    | WExpr.ArrayNew _                 -> "array.new"
    | WExpr.ArrayNewFixed(_, fs, _)    -> sprintf "array.new_fixed[%d]" fs.Length
    | WExpr.StructGet(_, f, _)         -> sprintf "struct.get(%d)" f
    | WExpr.StructSet(_, f, _)         -> sprintf "struct.set(%d)" f
    | WExpr.StructNew(ti, fs, _)       -> sprintf "struct.new(ti=%d,f=%d)" ti fs.Length
    | WExpr.Closure(n, caps, _)        -> sprintf "closure(%s,caps=%d)" n caps.Length
    | WExpr.Cast(_, ty)                -> sprintf "cast(%A)" ty
    | WExpr.RefIsNull _                -> "ref.is_null"
    | WExpr.Break(l, None)             -> sprintf "break(%s)" l
    | WExpr.Break(l, Some _)           -> sprintf "break_val(%s)" l
    | WExpr.Continue(l, _)             -> sprintf "continue(%s)" l
    | WExpr.Binary(op, _, _, _)        -> sprintf "binary(%A)" op
    | WExpr.Compare(op, _, _)          -> sprintf "cmp(%A)" op
    | WExpr.Unary(op, _, _)            -> sprintf "unary(%A)" op
    | WExpr.JoinPoint(l, _, _, _, _)   -> sprintf "join(%s)" l
    | WExpr.JoinApply(l, args, _)      -> sprintf "join_apply(%s,%d)" l args.Length
    | WExpr.SwitchInt(_, cases, _, _)  -> sprintf "switch[%d]" cases.Length
    | WExpr.TryCatch _                 -> "try_catch"
    | WExpr.Throw _                    -> "throw"
    | WExpr.MemLoad _                  -> "mem.load"
    | WExpr.MemStore _                 -> "mem.store"
    | WExpr.MemoryGrow _               -> "memory.grow"
    | WExpr.MemorySize                 -> "memory.size"
    | other                            -> sprintf "?(%s)" (other.GetType().Name)
