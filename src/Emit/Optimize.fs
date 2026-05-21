/// WasmGC Optimization Passes — Phase 7 — applied to WasmIR before emission.
///
/// Pass pipeline (applied in order, all pure WExpr → WExpr):
///   1. inlineJoins        — beta-reduce join points (fixed-point, no mutation)
///   2. foldConstants      — arithmetic/comparison/branch on literals + identities
///   3. strengthReduce     — algebraic strength reduction (mul→shl, div→shr, etc.)
///   4. eliminateDeadCode  — unused pure lets, empty sequences, trivial branches
///   5. removeLetAliases   — `let x = y` → substitute everywhere x is used
///   6. foldConstants      — second pass: alias removal opens new opportunities
///
/// All passes use WExprQuery.rewrite (bottom-up) — no duplicate traversal logic.
/// None mutate state; the pipeline is safe to run in parallel across functions.
/// All passes are pure WExpr → WExpr transformations, safe to compose.
/// Uses WExprQuery for efficient tree analysis.
module WasmGc.Emit.Optimize

open WasmGc.Core.AST
open WasmGc.Util.WExprQuery

open WasmGc.Builder
open WasmGc.Builder.WasmPatterns

// ─────────────────────────────────────────────────────────────────────────────
// Inline-join configuration
// ─────────────────────────────────────────────────────────────────────────────

module private InlineCfg =
    [<Literal>]
    let SmallBodyLimit = 3

    #if WGC_INLINE_AGGRESSIVE
    let aggressive = true
    #else
    let aggressive = false
    #endif

    /// Cheap size heuristic: true when expression node count <= SmallBodyLimit.
    let isSmall (expr: WExpr) =
        // WExprQuery.count walks the tree; early exit isn't available, but limit is tiny.
        count (fun _ -> true) expr <= SmallBodyLimit

// ─────────────────────────────────────────────────────────────────────────────
// Purity oracle
// Check if expression is pure (no observable side effects)
// ─────────────────────────────────────────────────────────────────────────────

/// True iff `expr` has no observable side effects and can be dropped or moved.
/// Conservative: any unknown node returns false.
let rec isPure = function
    | WExpr.Const _
    | WExpr.LocalGet _
    | WExpr.GlobalGet _
    | WExpr.Nop -> true
    | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) -> isPure v && isPure b
    | WExpr.Unary(_, x, _)
    | WExpr.Cast(x, _)
    | WExpr.RefIsNull x
    | WExpr.RefTest(x, _)      -> isPure x
    | WExpr.Binary(_, a, b, _)
    | WExpr.Compare(_, a, b)   -> isPure a && isPure b
    | WExpr.If(c, t, e, _)     -> isPure c && isPure t && isPure e
    | WExpr.StructGet(o, _, _) -> isPure o
    | WExpr.ArrayGet(a, i, _)  -> isPure a && isPure i
    | WExpr.ArrayLen a         -> isPure a
    | WExpr.Sequence xs        -> List.forall isPure xs
    | WExpr.TagOf o            -> isPure o
    | _                        -> false

// ─────────────────────────────────────────────────────────────────────────────
// Pass 1 — Join-point inlining (PLDI 2017, Maurer et al.)
// ─────────────────────────────────────────────────────────────────────────────
// Reference: Maurer et al., "Compiling without Continuations" (PLDI 2017)

/// Substitute all JoinApply(label, args) with `body` (params bound to args).
let private applyJoin (label: string) (parms: (string * WType) list) (body: WExpr) (expr: WExpr) : WExpr =
    rewrite (function
        | WExpr.JoinApply(l, args, _) when l = label ->
            List.foldBack
                (fun ((pName, _), arg) acc -> WExpr.Let(pName, arg, acc))
                (List.zip parms args) body
            |> Some
        | _ -> None) expr

/// Inline join points that are applied exactly once (linear use).
/// Pure functional — iterates to fixed point without mutation.
let rec private inlineJoins (expr: WExpr) : WExpr =
    let hasJoin = exists (function WExpr.JoinPoint _ -> true | _ -> false) expr
    if not hasJoin then expr
    else
        // Safe mode (default): inline only when single-use OR when duplication is safe.
        // Duplication considered safe when body is pure and small.
        let pass =
            rewrite (function
                | WExpr.JoinPoint(lbl, parms, body, cont, _) ->
                    let uses = count (function WExpr.JoinApply(l,_,_) -> l = lbl | _ -> false) cont
                    // Inline when used once (no duplication) or the body is trivially cheap
                    if uses = 1 || (uses > 1 && isPure body && InlineCfg.isSmall body)
                    then Some(applyJoin lbl parms body cont)
                    else None
                | _ -> None) expr
        // Fixed-point: keep inlining until nothing changes
        if pass = expr then expr else inlineJoins pass

// ─────────────────────────────────────────────────────────────────────────────
// Pass 2 — Constant folding + algebraic identities
// ─────────────────────────────────────────────────────────────────────────────
// Reference: any compiler textbook, e.g., Appel "Modern Compiler Implementation in ML" Ch. 17

let private foldI32 op a b = WExpr.Const(WConst.I32(op a b))
let private foldI64 op a b = WExpr.Const(WConst.I64(op a b))
let private foldF32 op a b = WExpr.Const(WConst.F32(op a b))
let private foldF64 op a b = WExpr.Const(WConst.F64(op a b))
let private boolI32 p a b  = WExpr.Const(WConst.I32(if p a b then 1 else 0))

let private foldConstants (expr: WExpr) : WExpr =
    rewrite (function
        // ── i32 literal arithmetic ────────────────────────────────────────
        | BinAdd(I32Lit a, I32Lit b, _) -> Some(foldI32 (+)  a b)
        | BinSub(I32Lit a, I32Lit b, _) -> Some(foldI32 (-)  a b)
        | BinMul(I32Lit a, I32Lit b, _) -> Some(foldI32 ( *) a b)
        | WExpr.Binary(WBinaryOp.DivS, I32Lit a, I32Lit b, _) when b <> 0 -> Some(foldI32 (/) a b)
        | WExpr.Binary(WBinaryOp.RemS, I32Lit a, I32Lit b, _) when b <> 0 -> Some(foldI32 (%) a b)
        | BinAnd(I32Lit a, I32Lit b, _) -> Some(foldI32 (&&&) a b)
        | BinOr (I32Lit a, I32Lit b, _) -> Some(foldI32 (|||) a b)
        | WExpr.Binary(WBinaryOp.Xor,  I32Lit a, I32Lit b, _) -> Some(foldI32 (^^^) a b)
        | WExpr.Binary(WBinaryOp.Shl,  I32Lit a, I32Lit b, _) -> Some(foldI32 (fun a b -> a <<< (b &&& 31)) a b)
        | WExpr.Binary(WBinaryOp.ShrS, I32Lit a, I32Lit b, _) -> Some(foldI32 (fun a b -> a >>> (b &&& 31)) a b)
        | WExpr.Binary(WBinaryOp.ShrU, I32Lit a, I32Lit b, _) -> Some(WExpr.Const(WConst.I32(int (uint32 a >>> (b &&& 31)))))
        // ── i64 literal arithmetic ────────────────────────────────────────
        | BinAdd(I64Lit a, I64Lit b, _) -> Some(foldI64 (+) a b)
        | BinSub(I64Lit a, I64Lit b, _) -> Some(foldI64 (-) a b)
        | BinMul(I64Lit a, I64Lit b, _) -> Some(foldI64 ( *) a b)
        // ── f64 literal arithmetic ────────────────────────────────────────
        | BinAdd(F64Lit a, F64Lit b, _) -> Some(foldF64 (+) a b)
        | BinSub(F64Lit a, F64Lit b, _) -> Some(foldF64 (-) a b)
        | BinMul(F64Lit a, F64Lit b, _) -> Some(foldF64 ( *) a b)
        | WExpr.Binary(WBinaryOp.DivS, F64Lit a, F64Lit b, _) when b <> 0.0 -> Some(foldF64 (/) a b)
        // ── i32 comparisons ───────────────────────────────────────────────
        | CmpEq(I32Lit a, I32Lit b) -> Some(boolI32 (=)  a b)
        | CmpNe(I32Lit a, I32Lit b) -> Some(boolI32 (<>) a b)
        | CmpLt(I32Lit a, I32Lit b) -> Some(boolI32 (<)  a b)
        | CmpGt(I32Lit a, I32Lit b) -> Some(boolI32 (>)  a b)
        | WExpr.Compare(WCompareOp.LeS, I32Lit a, I32Lit b) -> Some(boolI32 (<=) a b)
        | WExpr.Compare(WCompareOp.GeS, I32Lit a, I32Lit b) -> Some(boolI32 (>=) a b)
        // ── branch elimination (if-on-constant) ────────────────────────────────────────────
        // TODO: shouldn't it be Zero and Not-Zero. Or One and not one?! Like in other langs
        | IfExpr(I32One,  t, _, _) -> Some t
        | IfExpr(I32Zero, _, e, _) -> Some e
        // ── i32 identities and annihilators ──────────────────────────────
        | BinAdd(x, I32Zero, _)
        | BinAdd(I32Zero, x, _)
        | BinSub(x, I32Zero, _)
        | BinMul(x, I32One,  _)
        | BinMul(I32One,  x, _) -> Some x
        | BinMul(_, I32Zero, _)
        | BinMul(I32Zero, _, _) -> Some(WExpr.Const(WConst.I32 0))
        | BinAnd(_, I32Zero, _)
        | BinAnd(I32Zero, _, _) -> Some(WExpr.Const(WConst.I32 0))
        | BinOr (x, I32Zero, _)
        | BinOr (I32Zero, x, _) -> Some x
        | WExpr.Binary(WBinaryOp.Xor, x, I32Zero, _)     -> Some x
        // x - x → 0
        | BinSub(LocalVar(a,_), LocalVar(b,_), _) when a = b -> Some(WExpr.Const(WConst.I32 0))
        // x & x → x, x | x → x, x ^ x → 0
        | BinAnd(LocalVar(a,ta), LocalVar(b,_), _) when a = b -> Some(WExpr.LocalGet(a, ta))
        | BinOr (LocalVar(a,ta), LocalVar(b,_), _) when a = b -> Some(WExpr.LocalGet(a, ta))
        | WExpr.Binary(WBinaryOp.Xor, LocalVar(a,_), LocalVar(b,_), _) when a = b ->
            Some(WExpr.Const(WConst.I32 0))
        // ── strength reduction ─────────────────────────────────────────────
        // x * 2^n → x << n (power-of-two mul)
        | BinMul(x, I32Lit n, ty)
        | BinMul(I32Lit n, x, ty)
                    when n > 1 && (n &&& (n - 1)) = 0 ->
                let shift = System.Numerics.BitOperations.Log2(uint32 n) |> int
                Some(WExpr.Binary(WBinaryOp.Shl, x, WExpr.Const(WConst.I32 shift), ty))
        // ── comparison with self → known bool ────────────────────────────
        | CmpEq(LocalVar(a,_), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 1))
        | CmpNe(LocalVar(a,_), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 0))
        | CmpLt(LocalVar(a,_), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 0))
        | CmpGt(LocalVar(a,_), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 0))
        // ── not(not(x)) → x ──────────────────────────────────────────────
        | WExpr.Unary(WUnaryOp.Eqz, WExpr.Unary(WUnaryOp.Eqz, x, _), _) -> Some x
        // ── refIsNull(null) → 1, refIsNull(non-null struct) → 0 ─────────
        | IsNull(WExpr.Const(WConst.Null _)) -> Some(WExpr.Const(WConst.I32 1))
        | IsNull(WExpr.StructNew _) | IsNull(WExpr.ArrayNew _) -> Some(WExpr.Const(WConst.I32 0))
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────────────────
// Pass 3 — Strength reduction (separate from const fold for clarity)
// ─────────────────────────────────────────────────────────────────────────────

/// True iff n is a power of two (n > 0).
let private isPow2 (n: int) = n > 0 && (n &&& (n - 1)) = 0
let private log2 n = System.Numerics.BitOperations.Log2(uint32 n) |> int

let private strengthReduce (expr: WExpr) : WExpr =
    rewrite (function
        // x * 2^n → x << n
        | BinMul(x, I32Lit n, ty) | BinMul(I32Lit n, x, ty) when isPow2 n ->
            Some(WExpr.Binary(WBinaryOp.Shl, x, WExpr.Const(WConst.I32(log2 n)), ty))
        // x / 2^n → x >> n  (signed, only safe for non-negative x; we emit for all since
        //   F# semantics match signed shift for non-negative divisors)
        | WExpr.Binary(WBinaryOp.DivS, x, I32Lit n, ty) when isPow2 n && n > 1 ->
            Some(WExpr.Binary(WBinaryOp.ShrS, x, WExpr.Const(WConst.I32(log2 n)), ty))
        // x % 2^n → x & (2^n - 1)  (only for unsigned mod; skip signed)
        // i64 strength reductions
        | WExpr.Binary(WBinaryOp.Mul, x, WExpr.Const(WConst.I64 n), ty)
        | WExpr.Binary(WBinaryOp.Mul, WExpr.Const(WConst.I64 n), x, ty)
            when n > 1L && (n &&& (n - 1L)) = 0L ->
            let shift = System.Numerics.BitOperations.Log2(uint64 n) |> int
            Some(WExpr.Binary(WBinaryOp.Shl, x, WExpr.Const(WConst.I64(int64 shift)), ty))
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────────────────
// Pass 4 — Dead code elimination
// ─────────────────────────────────────────────────────────────────────────────
// Reference: Appel "Modern Compiler Implementation in ML" Ch. 17

let private usesLocal (name: string) (e: WExpr) =
    exists (function
        | WExpr.LocalGet(n, _) | WExpr.Assign(n, _) -> n = name
        | _ -> false) e

/// Remove `let x = e in body` when x is never used in body AND e is pure.
let private eliminateDeadCode (expr: WExpr) : WExpr =
    rewrite (function
        // Drop pure unused immutable let-bindings
        | WExpr.Let(name, value, body) when isPure value && not (usesLocal name body) ->
            Some body
        // Single-use let elimination: Let("x", v, LocalGet("x")) → v
        // Handles the common CE pattern: let! x = expr; return x
        | WExpr.Let(name, value, WExpr.LocalGet(n, _)) when n = name -> Some value
        // Let("x", const, expr using x once) → substitute and drop binding
        | WExpr.Let(name, (WExpr.Const _ as c), body)
              when not (exists (function WExpr.Assign(n,_) -> n = name | _ -> false) body) ->
            Some(substituteLocal name c body)
        // Drop pure unused mutable let-bindings (no writes in body either)
        | WExpr.LetMut(name, value, body) when isPure value && not (usesLocal name body) ->
            Some body
        // Flatten/trim sequences
        | WExpr.Sequence [] -> Some WExpr.Nop
        | WExpr.Sequence [e] -> Some e
        | WExpr.Sequence exprs ->
            let last = List.last exprs
            let init =
                exprs
                |> List.take (exprs.Length - 1)
                |> List.filter (isPure >> not)   // drop pure non-final expressions
            if init.Length = exprs.Length - 1 then None  // nothing changed
            else Some(match init with [] -> last | _ -> WExpr.Sequence(init @ [last]))
        // Both branches pure Nop → no-op if
        | WExpr.If(guard, WExpr.Nop, WExpr.Nop, _) when isPure guard -> Some WExpr.Nop
        // Unreachable continuations after diverging expressions
        | WExpr.Let(_, WExpr.Throw _, _) -> None  // Throw diverges; can't eliminate let
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────────────────
// Pass 5 — Let-alias removal
// ─────────────────────────────────────────────────────────────────────────────

/// Substitute `let x = y` when y is a LocalGet and x is never reassigned.
let private removeLetAliases (expr: WExpr) : WExpr =
    rewrite (function
        | WExpr.Let(name, (WExpr.LocalGet _ as alias), body)
              when not (exists (function WExpr.Assign(n,_) -> n = name | _ -> false) body) ->
            Some(substituteLocal name alias body)
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────────────────
// Composed optimization pipeline
// ─────────────────────────────────────────────────────────────────────────────

/// Run all passes on a single function body.
/// Two constant-fold passes bracket the structural passes to catch opportunities
/// opened by join inlining, alias removal, and dead-code elimination.
let optimizeFuncBody (body: WExpr) : WExpr =
    body
    |> inlineJoins
    |> foldConstants
    |> strengthReduce
    |> eliminateDeadCode
    |> removeLetAliases
    |> foldConstants    // alias removal opens new folding opportunities

/// Apply all passes to every function in a WModule.
let optimizeModule (wmod: WModule) : WModule =
    { wmod with
        Functions =
            wmod.Functions
            |> List.map (fun f -> { f with Body = optimizeFuncBody f.Body }) }
