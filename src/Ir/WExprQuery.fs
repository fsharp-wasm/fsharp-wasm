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
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Basic traversal
// ─────────────────────────────────────────────────────────────────

/// All immediate subexpressions (delegates to the single exhaustive traversal).
let children (expr: WExpr) : WExpr list = WasmGc.Core.Traverse.children expr

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
let count (pred: WExpr -> bool) (expr: WExpr) : int = WasmGc.Core.Traverse.count pred expr

/// True if any node satisfies the predicate.
let exists (pred: WExpr -> bool) (expr: WExpr) : bool = WasmGc.Core.Traverse.exists pred expr

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
let rewrite (f: WExpr -> WExpr option) (expr: WExpr) : WExpr = WasmGc.Core.Traverse.rewrite f expr

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

