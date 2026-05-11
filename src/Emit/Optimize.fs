/// WasmGC Optimization Passes — Phase 7 — applied to WasmIR before emission.
///
/// Pass order (all pure WExpr → WExpr):
///   1. inlineJoins       — join-point beta-reduction (fixed-point)
///   2. foldConstants      — arithmetic/comparison on literals
///   3. eliminateDeadCode  — unused pure lets, empty sequences
///   4. removeLetAliases   — `let x = y` → substitute x with y
///   5. foldConstants      — second pass: alias removal opens new folds
///
/// Uses WExprQuery.rewrite / WExprQuery.substituteLocal — no duplicate traversal code.
/// All passes are pure WExpr → WExpr transformations, safe to compose.
/// Uses WExprQuery for efficient tree analysis.
module WasmGc.Emit.Optimize

open WasmGc.Core.AST
open WasmGc.Util.WExprQuery   // rewrite, substituteLocal, exists, count, collect

open WasmGc.Builder
open WasmGc.Builder.WasmPatterns

// ─────────────────────────────────────────────────────────────────
// Purity
// Check if expression is pure (no observable side effects)
// ─────────────────────────────────────────────────────────────────

let rec isPure = function
    | WExpr.Const _
    | WExpr.LocalGet _
    | WExpr.GlobalGet _
    | WExpr.Nop -> true
    | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) -> isPure v && isPure b
    | WExpr.Unary(_, x, _)
    | WExpr.Cast(x, _)
    | WExpr.RefIsNull x
    | WExpr.RefTest(x, _)  -> isPure x
    | WExpr.Binary(_, a, b, _)
    | WExpr.Compare(_, a, b) -> isPure a && isPure b
    | WExpr.If(c, t, e, _)   -> isPure c && isPure t && isPure e
    | WExpr.StructGet(o, _, _)-> isPure o
    | WExpr.Sequence xs       -> List.forall isPure xs
    | _                       -> false

// ─────────────────────────────────────────────────────────────────
// Pass 1 — Join-point inlining
// ─────────────────────────────────────────────────────────────────
// Reference: Maurer et al., "Compiling without Continuations" (PLDI 2017)

/// Substitute all JoinApply(label, args) with `body` (params bound to args).
let private applyJoin (label: string) (parms: (string * WType) list) (body: WExpr) (expr: WExpr) =
    rewrite (function
        | WExpr.JoinApply(l, args, _) when l = label ->
            List.foldBack
                (fun ((pName, _), arg) acc -> WExpr.Let(pName, arg, acc))
                (List.zip parms args) body
            |> Some
        | _ -> None) expr

let private inlineJoins (expr: WExpr) : WExpr =
    // Early exit if there are no join points at all
    // (avoid infinite loop caused by rewrite always returning new objects)
    let hasJoinPoints = exists (function WExpr.JoinPoint _ -> true | _ -> false) expr
    if not hasJoinPoints then
        expr
    else
        // Outside-in: process outer joins first so inner join counts are correct
        let mutable changed = true
        let mutable e = expr
        
        while changed do
            let joinPointsBefore = 
                collect (function WExpr.JoinPoint _ -> true | _ -> false) e |> List.length
            
            let e' =
                rewrite (function
                    | WExpr.JoinPoint(lbl, parms, body, cont, _) ->
                        let uses = count (function WExpr.JoinApply(l,_,_) -> l = lbl | _ -> false) cont
                        if uses >= 1 then Some(applyJoin lbl parms body cont) else None
                    | _ -> None) e
            
            let joinPointsAfter = 
                collect (function WExpr.JoinPoint _ -> true | _ -> false) e' |> List.length
            
            changed <- joinPointsAfter < joinPointsBefore  // Changed only if we actually inlined
            e <- e'
        
        e

// ─────────────────────────────────────────────────────────────────
// Pass 2 — Constant folding
// ─────────────────────────────────────────────────────────────────
// Reference: any compiler textbook, e.g., Appel "Modern Compiler Implementation in ML" Ch. 17

let private foldI32 op a b = WExpr.Const(WConst.I32(op a b))
let private foldF64 op a b = WExpr.Const(WConst.F64(op a b))
let private boolI32 p a b  = WExpr.Const(WConst.I32(if p a b then 1 else 0))

let private foldConstants (expr: WExpr) : WExpr =
    // TODO: what about other consts? Can we build this more general? insteead of repeating ourself
    rewrite (function
        // ── i32 arithmetic ────────────────────────────────────────────────
        | BinAdd(I32Lit a, I32Lit b, _) -> Some(foldI32 (+) a b)
        | BinSub(I32Lit a, I32Lit b, _) -> Some(foldI32 (-) a b)
        | BinMul(I32Lit a, I32Lit b, _) -> Some(foldI32 ( *) a b)
        | WExpr.Binary(WBinaryOp.DivS, I32Lit a, I32Lit b, _) when b <> 0 -> Some(foldI32 (/) a b)
        | WExpr.Binary(WBinaryOp.RemS, I32Lit a, I32Lit b, _) when b <> 0 -> Some(foldI32 (%) a b)
        | BinAnd(I32Lit a, I32Lit b, _) -> Some(foldI32 (&&&) a b)
        | BinOr (I32Lit a, I32Lit b, _) -> Some(foldI32 (|||) a b)
        | WExpr.Binary(WBinaryOp.Xor,  I32Lit a, I32Lit b, _) -> Some(foldI32 (^^^) a b)
        | WExpr.Binary(WBinaryOp.Shl,  I32Lit a, I32Lit b, _) -> Some(foldI32 (fun a b -> a <<< (b &&& 31)) a b)
        | WExpr.Binary(WBinaryOp.ShrS, I32Lit a, I32Lit b, _) -> Some(foldI32 (fun a b -> a >>> (b &&& 31)) a b)
        | WExpr.Binary(WBinaryOp.ShrU, I32Lit a, I32Lit b, _) -> Some(WExpr.Const(WConst.I32(int (uint32 a >>> (b &&& 31)))))
        // ── f64 arithmetic ────────────────────────────────────────────────
        | BinAdd(F64Lit a, F64Lit b, _) -> Some(foldF64 (+) a b)
        | BinSub(F64Lit a, F64Lit b, _) -> Some(foldF64 (-) a b)
        | BinMul(F64Lit a, F64Lit b, _) -> Some(foldF64 ( *) a b)
        | WExpr.Binary(WBinaryOp.DivS, F64Lit a, F64Lit b, _) when b <> 0.0 -> Some(foldF64 (/) a b)
        // ── comparisons ───────────────────────────────────────────────────
        | CmpEq(I32Lit a, I32Lit b) -> Some(boolI32 (=)  a b)
        | CmpNe(I32Lit a, I32Lit b) -> Some(boolI32 (<>) a b)
        | CmpLt(I32Lit a, I32Lit b) -> Some(boolI32 (<)  a b)
        | WExpr.Compare(WCompareOp.LeS, I32Lit a, I32Lit b) -> Some(boolI32 (<=) a b)
        | CmpGt(I32Lit a, I32Lit b) -> Some(boolI32 (>)  a b)
        | WExpr.Compare(WCompareOp.GeS, I32Lit a, I32Lit b) -> Some(boolI32 (>=) a b)
        // ── if-on-constant ────────────────────────────────────────────────
        | IfExpr(I32One, t, _, _) -> Some t
        | IfExpr(I32Zero, _, e, _) -> Some e
        // ── identity / annihilator ────────────────────────────────────────
        | BinAdd(x, I32Zero, _)
        | BinAdd(I32Zero, x, _)
        | BinSub(x, I32Zero, _)
        | BinMul(x, I32One, _)
        | BinMul(I32One, x, _) -> Some x
        | BinMul(_, I32Zero, _)
        | BinMul(I32Zero, _, _) -> Some(WExpr.Const(WConst.I32 0))
        | BinAnd(_, I32Zero, _)
        | BinAnd(I32Zero, _, _) -> Some(WExpr.Const(WConst.I32 0))
        | BinOr (x, I32Zero, _)
        | BinOr (I32Zero, x, _) -> Some x
        // ── strength reduction ─────────────────────────────────────────────
        // x * 2^n → x << n (power-of-two mul)
        | BinMul(x, I32Lit n, ty)
        | BinMul(I32Lit n, x, ty)
                    when n > 1 && (n &&& (n - 1)) = 0 ->
                let shift = System.Numerics.BitOperations.Log2(uint32 n) |> int
                Some(WExpr.Binary(WBinaryOp.Shl, x, WExpr.Const(WConst.I32 shift), ty))
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────
// Pass 3 — Dead code elimination
// ─────────────────────────────────────────────────────────────────
// Reference: Appel "Modern Compiler Implementation in ML" Ch. 17

/// Remove `let x = e in body` when x is never used in body AND e is pure.
let private eliminateDeadCode (expr: WExpr) : WExpr =
    rewrite (function
        // Pure unused let — drop
        | WExpr.Let(name, value, body) when isPure value && not (exists (function WExpr.LocalGet(n,_) -> n = name | _ -> false) body) ->
            Some body
        | WExpr.LetMut(name, value, body) when isPure value && not (exists (function WExpr.LocalGet(n,_) | WExpr.Assign(n,_) -> n = name | _ -> false) body) ->
            Some body
        // Sequence cleanup
        | WExpr.Sequence [] -> Some WExpr.Nop
        | WExpr.Sequence [e] -> Some e
        | WExpr.Sequence exprs ->
            let last = List.last exprs
            let init = exprs |> List.take (exprs.Length - 1) |> List.filter (isPure >> not)
            if init.Length = exprs.Length - 1 then None  // nothing changed
            else Some(match init with [] -> last | _ -> WExpr.Sequence(init @ [last]))
        // if both branches are Nop, drop the whole thing
        | WExpr.If(_, WExpr.Nop, WExpr.Nop, _) -> Some WExpr.Nop
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────
// Pass 4 — Let-alias removal
// ─────────────────────────────────────────────────────────────────

/// `let x = y` where y is a LocalGet and x is not reassigned — substitute.
let private removeLetAliases (expr: WExpr) : WExpr =
    rewrite (function
        | WExpr.Let(name, (WExpr.LocalGet _ as alias), body)
              when not (exists (function WExpr.Assign(n,_) -> n = name | _ -> false) body) ->
            Some(substituteLocal name alias body)
        | _ -> None) expr

// ─────────────────────────────────────────────────────────────────
// Compose all passes into a single optimization run
// ─────────────────────────────────────────────────────────────────

/// Run all implemented optimization passes on a single function body.
let optimizeFuncBody (body: WExpr) : WExpr =
    body
    |> inlineJoins
    |> foldConstants
    |> eliminateDeadCode
    |> removeLetAliases
    |> foldConstants      // alias removal exposes new constant operands (may open new opportunities)

/// Apply optimizations to all functions in a WModule.
let optimizeModule (wmod: WModule) : WModule =
    { wmod with
        Functions =
            wmod.Functions
            |> List.map (fun f -> { f with Body = optimizeFuncBody f.Body }) }
