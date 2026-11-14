/// WasmGC Optimization Passes — Phase 7 — applied to WasmIR before emission.
///
/// Module pass first (needs the call graph):
///   0. inlineSmallFunctions — opt-in (WASMGC_INLINE=1): a call of a small, non-recursive function becomes its body (`let` per parameter)
///
/// Pass pipeline per function (applied in order, all pure WExpr → WExpr):
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
// Pass 0 — Inlining of small functions (module level)
// ─────────────────────────────────────────────────────────────────────────────
// The engine inlines when it optimises (V8's TurboFan decides by the module it has: the same function ran in 60 ms in one module
// and in 36 ms in another), and its baseline tier inlines nothing.  Doing it here makes the code the same everywhere.
//
// A callee qualifies when its body is a plain expression (no loop, block, join point, return, tail call, closure or exception: nothing
// that is local to its own frame), has at most `MaxNodes` nodes, does not assign to a parameter and is not part of a call cycle.
// `Call(f, args)` becomes `let p1' = a1 in let p2' = a2 in body'`, every local of the callee renamed with a suffix that is unique to
// this expansion: the arguments are still evaluated once and left to right, and nothing of the caller can be captured.
// Two rounds, so that a chain of small helpers collapses; the constant folding and the let-alias removal that follow clean up the lets.
// Opt-in: WASMGC_INLINE=1 switches the pass on (see `enabled` for why it is not the default).

module private InlineFns =
    [<Literal>]
    let MaxNodes = 30

    /// Off unless WASMGC_INLINE=1: measured (docs/benchmarks.md of fsharp-wasm-runtime), it makes no difference where the engine inlines itself
    /// (V8 and JavaScriptCore: the geometric mean of the benchmark stays within 1-2 %, the noise), costs code (the scene gallery grows by 16 %, the
    /// widget editor by 4.7 %), and only pays where the engine does not inline: with V8's inliner off the spectral norm needs 29 ms instead of 47.
    let enabled = System.Environment.GetEnvironmentVariable "WASMGC_INLINE" = "1"

    /// Nodes a callee may consist of; anything else (loops, blocks, join points, returns, tail calls, closures, try, switch) keeps its call.
    let rec private plain (e: WExpr) =
        match e with
        | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _ | WExpr.Nop -> true
        | WExpr.Let _ | WExpr.LetMut _ | WExpr.Assign _ | WExpr.GlobalSet _
        | WExpr.Call _ | WExpr.StructNew _ | WExpr.StructGet _ | WExpr.StructSet _
        | WExpr.ArrayNew _ | WExpr.ArrayNewFixed _ | WExpr.ArrayGet _ | WExpr.ArraySet _ | WExpr.ArrayLen _
        | WExpr.If _ | WExpr.Sequence _ | WExpr.Cast _ | WExpr.RefIsNull _ | WExpr.RefTest _ | WExpr.TagOf _
        | WExpr.Unary _ | WExpr.Binary _ | WExpr.Compare _ -> List.forall plain (children e)
        | _ -> false

    let private calleesOf (body: WExpr) : string list =
        collect (function WExpr.Call _ | WExpr.TailCall _ -> true | _ -> false) body
        |> List.map (function WExpr.Call(n, _, _) | WExpr.TailCall(n, _, _) -> n | _ -> "")
        |> List.distinct

    /// The functions that can reach themselves through direct calls.
    let private recursive (funcs: WFuncDecl list) : Set<string> =
        let graph = funcs |> List.map (fun f -> f.Name, calleesOf f.Body) |> dict
        let reaches (start: string) =
            let seen = System.Collections.Generic.HashSet<string>()
            let rec go name =
                match graph.TryGetValue name with
                | true, next -> next |> List.exists (fun n -> n = start || (seen.Add n && go n))
                | _ -> false
            go start
        funcs |> List.filter (fun f -> reaches f.Name) |> List.map (fun f -> f.Name) |> Set.ofList

    let private qualifies (cycle: Set<string>) (f: WFuncDecl) =
        not (cycle.Contains f.Name)
        && plain f.Body
        && count (fun _ -> true) f.Body <= MaxNodes
        && not (exists (function WExpr.Assign(n, _) -> f.Params |> List.exists (fun (p, _) -> p = n) | _ -> false) f.Body)

    let private rename (suffix: string) (names: Set<string>) (body: WExpr) : WExpr =
        rewrite (function
            | WExpr.LocalGet(n, t) when names.Contains n -> Some(WExpr.LocalGet(n + suffix, t))
            | WExpr.Assign(n, v) when names.Contains n -> Some(WExpr.Assign(n + suffix, v))
            | WExpr.Let(n, v, b) when names.Contains n -> Some(WExpr.Let(n + suffix, v, b))
            | WExpr.LetMut(n, v, b) when names.Contains n -> Some(WExpr.LetMut(n + suffix, v, b))
            | _ -> None) body

    let private expand (callees: System.Collections.Generic.IDictionary<string, WFuncDecl>) (counter: int ref) (body: WExpr) : WExpr =
        rewrite (function
            | WExpr.Call(name, args, _) when callees.ContainsKey name && callees.[name].Params.Length = args.Length ->
                let c = callees.[name]
                counter.Value <- counter.Value + 1
                let suffix = sprintf "$i%d" counter.Value
                let bound = Set.ofList ((c.Params |> List.map fst) @ (allLetBindings c.Body |> List.map fst))
                Some(List.foldBack2 (fun (p, _) arg acc -> WExpr.Let(p + suffix, arg, acc)) c.Params args (rename suffix bound c.Body))
            | _ -> None) body

    let inlineSmallFunctions (funcs: WFuncDecl list) : WFuncDecl list =
        let counter = ref 0
        let cycle = recursive funcs
        let round (fs: WFuncDecl list) =
            let callees = fs |> List.filter (qualifies cycle) |> List.map (fun f -> f.Name, f) |> dict
            if callees.Count = 0 then fs
            else fs |> List.map (fun f -> { f with Body = expand callees counter f.Body })
        funcs |> round |> round

// ─────────────────────────────────────────────────────────────────────────────
// Purity oracle
// Check if expression is pure (no observable side effects)
// ─────────────────────────────────────────────────────────────────────────────

/// True iff `expr` has no observable side effects and can be dropped or moved.
///
/// Operations that can TRAP are not pure: dropping `let _ = arr.[i]` or `let _ = x / y` would turn
/// an IndexOutOfRange / DivideByZero / InvalidCast into silent success.  That excludes
/// ref.cast, struct.get (null deref), array.get (bounds), integer div/rem and float→int truncation.
/// Conservative: any unknown node returns false.
let rec isPure = function
    | WExpr.Const _
    | WExpr.LocalGet _
    | WExpr.GlobalGet _
    | WExpr.Nop -> true
    | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) -> isPure v && isPure b
    | WExpr.Unary(op, x, _) ->
        (match op with
         | WUnaryOp.TruncF64S | WUnaryOp.TruncF32S -> false
         | _ -> true)
        && isPure x
    | WExpr.RefIsNull x
    | WExpr.RefTest(x, _)      -> isPure x
    | WExpr.Binary(op, a, b, ty) ->
        let traps =
            match op, ty with
            | (WBinaryOp.DivS | WBinaryOp.DivU | WBinaryOp.RemS | WBinaryOp.RemU), (WType.I32 | WType.I64) -> true
            | _ -> false
        not traps && isPure a && isPure b
    | WExpr.Compare(_, a, b)   -> isPure a && isPure b
    | WExpr.If(c, t, e, _)     -> isPure c && isPure t && isPure e
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
/// Iterates to a fixed point.
///
/// Convergence is detected with an explicit "something was inlined" flag, NOT with `pass = expr`:
/// F# equality on floats is IEEE (`nan = nan` is false), so any expression containing a NaN constant
/// was never equal to itself and this loop never terminated (compiler hang on every function with a
/// `match` and a `nan` literal).
let rec private inlineJoins (expr: WExpr) : WExpr =
    let hasJoin = exists (function WExpr.JoinPoint _ -> true | _ -> false) expr
    if not hasJoin then expr
    else
        let changed = ref false
        // Safe mode (default): inline only when single-use OR when duplication is safe.
        // Duplication considered safe when body is pure and small.
        let pass =
            rewrite (function
                | WExpr.JoinPoint(lbl, parms, body, cont, _) ->
                    let uses = count (function WExpr.JoinApply(l,_,_) -> l = lbl | _ -> false) cont
                    // Inline when used once (no duplication) or the body is trivially cheap
                    if uses = 1 || (uses > 1 && isPure body && InlineCfg.isSmall body)
                    then
                        changed.Value <- true
                        Some(applyJoin lbl parms body cont)
                    else None
                | _ -> None) expr
        if changed.Value then inlineJoins pass else pass

// ─────────────────────────────────────────────────────────────────────────────
// Pass 2 — Constant folding + algebraic identities
// ─────────────────────────────────────────────────────────────────────────────
// Reference: any compiler textbook, e.g., Appel "Modern Compiler Implementation in ML" Ch. 17

/// True iff the i32 value of `e` is guaranteed to be 0 or 1.
let rec private isBool (e: WExpr) : bool =
    match e with
    | WExpr.Compare _ | WExpr.RefIsNull _ | WExpr.RefTest _ | WExpr.Unary(WUnaryOp.Eqz, _, _) -> true
    | WExpr.Const(WConst.I32 n) -> n = 0 || n = 1
    | WExpr.If(_, t, el, WType.I32) -> isBool t && isBool el
    | _ -> false

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
        // MinValue / -1 overflows (and would throw inside the compiler); leave it to the runtime.
        | WExpr.Binary(WBinaryOp.DivS, I32Lit a, I32Lit b, _) when b <> 0 && not (a = System.Int32.MinValue && b = -1) -> Some(foldI32 (/) a b)
        | WExpr.Binary(WBinaryOp.RemS, I32Lit a, I32Lit b, _) when b <> 0 && b <> -1 -> Some(foldI32 (%) a b)
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
        // wasm `if` takes ANY non-zero i32 as true (previously only the literals 1 / 0 folded).
        | IfExpr(WExpr.Const(WConst.I32 n), t, e, _) -> Some(if n <> 0 then t else e)
        // ── i32 identities and annihilators ──────────────────────────────
        | BinAdd(x, I32Zero, _)
        | BinAdd(I32Zero, x, _)
        | BinSub(x, I32Zero, _)
        | BinMul(x, I32One,  _)
        | BinMul(I32One,  x, _) -> Some x
        // The other operand is dropped, so it must not have side effects (`f() * 0` still calls f).
        | BinMul(x, I32Zero, _)
        | BinMul(I32Zero, x, _) when isPure x -> Some(WExpr.Const(WConst.I32 0))
        | BinAnd(x, I32Zero, _)
        | BinAnd(I32Zero, x, _) when isPure x -> Some(WExpr.Const(WConst.I32 0))
        | BinOr (x, I32Zero, _)
        | BinOr (I32Zero, x, _) -> Some x
        | WExpr.Binary(WBinaryOp.Xor, x, I32Zero, _)     -> Some x
        // x - x → 0
        // (i32 only: for f64 `x - x` is NaN when x is NaN/inf, and the result type would change.)
        | BinSub(LocalVar(a,_), LocalVar(b,_), WType.I32) when a = b -> Some(WExpr.Const(WConst.I32 0))
        // x & x → x, x | x → x, x ^ x → 0
        | BinAnd(LocalVar(a,ta), LocalVar(b,_), WType.I32) when a = b -> Some(WExpr.LocalGet(a, ta))
        | BinOr (LocalVar(a,ta), LocalVar(b,_), WType.I32) when a = b -> Some(WExpr.LocalGet(a, ta))
        | WExpr.Binary(WBinaryOp.Xor, LocalVar(a,_), LocalVar(b,_), WType.I32) when a = b ->
            Some(WExpr.Const(WConst.I32 0))
        // ── strength reduction ─────────────────────────────────────────────
        // x * 2^n → x << n (power-of-two mul)
        | BinMul(x, I32Lit n, ty)
        | BinMul(I32Lit n, x, ty)
                    when n > 1 && (n &&& (n - 1)) = 0 ->
                let shift = System.Numerics.BitOperations.Log2(uint32 n) |> int
                Some(WExpr.Binary(WBinaryOp.Shl, x, WExpr.Const(WConst.I32 shift), ty))
        // ── comparison with self → known bool ────────────────────────────
        // (integers only: x == x is false and x <> x is true for a NaN float.)
        | CmpEq(LocalVar(a,(WType.I32 | WType.I64)), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 1))
        | CmpNe(LocalVar(a,(WType.I32 | WType.I64)), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 0))
        | CmpLt(LocalVar(a,_), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 0))
        | CmpGt(LocalVar(a,_), LocalVar(b,_)) when a = b -> Some(WExpr.Const(WConst.I32 0))
        // ── not(not(x)) ──────────────────────────────────────────────────
        // `!!x` is `x <> 0`, which equals `x` only when x is already 0/1.  (`!!popcnt(-1)` is 1, not 32;
        // the old unconditional `→ x` rewrite changed the result of every non-boolean operand.)
        | WExpr.Unary(WUnaryOp.Eqz, WExpr.Unary(WUnaryOp.Eqz, x, _), _) when isBool x -> Some x
        | WExpr.Unary(WUnaryOp.Eqz, WExpr.Unary(WUnaryOp.Eqz, x, _), _) when WasmGc.Runtime.Types.exprWType x = WType.I32 ->
            Some(WExpr.Compare(WCompareOp.Ne, x, WExpr.Const(WConst.I32 0)))
        | WExpr.Unary(WUnaryOp.Eqz, WExpr.Unary(WUnaryOp.Eqz, x, _), _) when WasmGc.Runtime.Types.exprWType x = WType.I64 ->
            Some(WExpr.Compare(WCompareOp.Ne, x, WExpr.Const(WConst.I64 0L)))
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
        // NOTE: `x / 2^n → x >> n` was removed.  It is only valid for x >= 0: F# truncates toward
        // zero (-7 / 2 = -3) while an arithmetic shift floors (-7 >> 1 = -4).  Engines already
        // emit the correct bias-and-shift sequence for division by a constant.
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
        | WExpr.Let(name, (WExpr.LocalGet(src, _) as alias), body)
              // Neither side may be reassigned: `let j = i; i <- i + 1; j` must keep the OLD value.
              when not (exists (function WExpr.Assign(n,_) -> n = name || n = src | _ -> false) body) ->
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
    let functions = if InlineFns.enabled then InlineFns.inlineSmallFunctions wmod.Functions else wmod.Functions
    { wmod with
        Functions =
            functions
            |> List.map (fun f -> { f with Body = optimizeFuncBody f.Body }) }

