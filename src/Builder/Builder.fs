/// WasmGC Computation Expression builder, DSL combinators, and active patterns.
///
/// Architecture — three layers:
///
///   Layer 0  Primitive smart constructors (constants, locals, arithmetic, arrays…)
///   Layer 1  Structured control-flow helpers (makeWhileLoop, makeForLoop, makeIf…)
///            + typed handles: WVar, WArray, MutRef, BlockCtrl
///   Layer 2  WasmBuilder CE type + Wasm module combinators
///   Layer 3  WasmDsl infix operators + WasmPatterns active patterns
///
/// CE notes (patched F# compiler — vendor/fsharp):
///   `while! guard do body`  → builder.WhileBang(guard, body)       [WExpr guard, no bool]
///   `while  guard do body`  → builder.WhileExpr(guard, body)       [same, non-bang form]
///   `if     guard then b`   → builder.IfExpr(guard, thenB, elseB)  [WExpr guard]
///   `for x in col do body`  → builder.ForExpr(col, fun x -> body)  [WExpr collection]
///
/// Without the patch, `while!` falls back to Bind(WExpr, bool→WExpr) + While stack hack.
module WasmGc.Builder

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ═════════════════════════════════════════════════════════════════════════════
// Name / label generation
// ═════════════════════════════════════════════════════════════════════════════

let private nameCounter = ref 0

/// Fresh compiler-generated local name.  `$w` prefix avoids shadowing user names.
let freshName () =
    let n = System.Threading.Interlocked.Increment(nameCounter)
    $"$w{n}"

/// Fresh block/loop label with a semantic prefix for readable WAT output.
let freshLabel (prefix: string) =
    let n = System.Threading.Interlocked.Increment(nameCounter)
    $"${prefix}_{n}"

// ─────────────────────────────────────────────────────────────────────────────
// LabelGen — deterministic, per-site label family
// ─────────────────────────────────────────────────────────────────────────────

/// Generates a family of related labels for one code-generation site.
/// Each instance gets a unique sequence number — labels won't clash between sites.
///
///   let gen = LabelGen("map")
///   gen.Loop   // "$map_7_lp"
///   gen.Exit   // "$map_7_exit"
///   gen.Next "acc"  // "$map_7_acc"
type LabelGen(prefix: string) =
    let n = System.Threading.Interlocked.Increment(nameCounter)
    member _.Loop    = $"${prefix}_{n}_lp"
    member _.Exit    = $"${prefix}_{n}_exit"
    member _.Acc     = $"${prefix}_{n}_acc"
    member _.Idx     = $"${prefix}_{n}_i"
    member _.Tmp     = $"${prefix}_{n}_tmp"
    member _.Next(tag: string) = $"${prefix}_{n}_{tag}"
    member _.Fresh s = $"${prefix}_{n}_{s}"    // alias for Next
    member _.Prefix  = prefix

// ═════════════════════════════════════════════════════════════════════════════
// Layer 0 — Primitive WExpr smart constructors
// ═════════════════════════════════════════════════════════════════════════════

// ── Constants ────────────────────────────────────────────────────────────────
let inline i32Const (n: int)     = WExpr.Const(WConst.I32 n)
let inline i64Const (n: int64)   = WExpr.Const(WConst.I64 n)
let inline f32Const (v: float32) = WExpr.Const(WConst.F32 v)
let inline f64Const (v: float)   = WExpr.Const(WConst.F64 v)
let inline i32Zero               = WExpr.Const(WConst.I32 0)
let inline i32One                = WExpr.Const(WConst.I32 1)
let inline nullConst (ty: WType) = WExpr.Const(WConst.Null ty)

// ── Locals / Globals ─────────────────────────────────────────────────────────
let inline localGet  name ty = WExpr.LocalGet(name, ty)
let inline localSet  name v  = WExpr.Assign(name, v)
let inline globalGet name ty = WExpr.GlobalGet(name, ty)
let inline globalSet name v  = WExpr.GlobalSet(name, v)

// ── Arithmetic (i32) ─────────────────────────────────────────────────────────
let inline add  a b    = WExpr.Binary(WBinaryOp.Add,  a, b, WType.I32)
let inline sub  a b    = WExpr.Binary(WBinaryOp.Sub,  a, b, WType.I32)
let inline mul  a b    = WExpr.Binary(WBinaryOp.Mul,  a, b, WType.I32)
let inline div_ a b    = WExpr.Binary(WBinaryOp.DivS, a, b, WType.I32)
let inline rem_ a b    = WExpr.Binary(WBinaryOp.RemS, a, b, WType.I32)
let inline and_ a b    = WExpr.Binary(WBinaryOp.And,  a, b, WType.I32)
let inline or_  a b    = WExpr.Binary(WBinaryOp.Or,   a, b, WType.I32)
let inline xor_ a b    = WExpr.Binary(WBinaryOp.Xor,  a, b, WType.I32)
let inline shl  a b    = WExpr.Binary(WBinaryOp.Shl,  a, b, WType.I32)
let inline shrS a b    = WExpr.Binary(WBinaryOp.ShrS, a, b, WType.I32)
let inline shrU a b    = WExpr.Binary(WBinaryOp.ShrU, a, b, WType.I32)
// Typed-generic versions — supply the result WType explicitly.
let inline addF a b ty = WExpr.Binary(WBinaryOp.Add,  a, b, ty)
let inline subF a b ty = WExpr.Binary(WBinaryOp.Sub,  a, b, ty)
let inline mulF a b ty = WExpr.Binary(WBinaryOp.Mul,  a, b, ty)

// ── Arithmetic (f64 / f32) ───────────────────────────────────────────────────
let inline addf64 a b = WExpr.Binary(WBinaryOp.Add,  a, b, WType.F64)
let inline subf64 a b = WExpr.Binary(WBinaryOp.Sub,  a, b, WType.F64)
let inline mulf64 a b = WExpr.Binary(WBinaryOp.Mul,  a, b, WType.F64)
let inline divf64 a b = WExpr.Binary(WBinaryOp.DivS, a, b, WType.F64)

// ── Comparisons ──────────────────────────────────────────────────────────────
let inline eq   a b = WExpr.Compare(WCompareOp.Eq,   a, b)
let inline ne   a b = WExpr.Compare(WCompareOp.Ne,   a, b)
let inline ltS  a b = WExpr.Compare(WCompareOp.LtS,  a, b)
let inline leS  a b = WExpr.Compare(WCompareOp.LeS,  a, b)
let inline gtS  a b = WExpr.Compare(WCompareOp.GtS,  a, b)
let inline geS  a b = WExpr.Compare(WCompareOp.GeS,  a, b)
let inline ltU  a b = WExpr.Compare(WCompareOp.LtU,  a, b)
let inline geU  a b = WExpr.Compare(WCompareOp.GeU,  a, b)
let inline eqF  a b = WExpr.Compare(WCompareOp.EqF,  a, b)
let inline ltF  a b = WExpr.Compare(WCompareOp.LtF,  a, b)
let inline leF  a b = WExpr.Compare(WCompareOp.LeF,  a, b)
let inline refEq a b = WExpr.Compare(WCompareOp.RefEq, a, b)

// ── Ref / cast ───────────────────────────────────────────────────────────────
let inline refIsNull e       = WExpr.RefIsNull e
let inline refIsNotNull e    = WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull e, WType.I32)
let inline cast e ty         = WExpr.Cast(e, ty)
let inline tagOf obj         = WExpr.TagOf obj

// ── Arrays ───────────────────────────────────────────────────────────────────
let inline arrayNew ti n init ty = WExpr.ArrayNew(ti, n, init, ty)
let inline arrayGet arr i ty     = WExpr.ArrayGet(arr, i, ty)
let inline arraySet arr i v      = WExpr.ArraySet(arr, i, v)
let inline arrayLen arr          = WExpr.ArrayLen arr
let arrayNewFixed ti elems ty    = WExpr.ArrayNewFixed(ti, elems, ty)
let arrayCopy dst dstOff src srcOff len = WExpr.ArrayCopy(dst, dstOff, src, srcOff, len)

// ── Structs ───────────────────────────────────────────────────────────────────
let inline structNew ti fs ty     = WExpr.StructNew(ti, fs, ty)
let inline structGet obj f ty     = WExpr.StructGet(obj, f, ty)
let inline structSet obj f v      = WExpr.StructSet(obj, f, v)

// ── Calls ────────────────────────────────────────────────────────────────────
let inline call func args ty = WExpr.Call(func, args, ty)

// ═════════════════════════════════════════════════════════════════════════════
// Layer 1 — Structured control flow + typed handles
// ═════════════════════════════════════════════════════════════════════════════

// ── Nop-collapsing sequence helpers ──────────────────────────────────────────

/// Sequence two expressions, eliminating leading/trailing Nop.
let inline seq2 a b =
    match a, b with
    | WExpr.Nop, x | x, WExpr.Nop -> x
    | _                             -> WExpr.Sequence [a; b]

/// Flatten a list of WExpr, eliminating Nops and unwrapping singletons.
let seqOf (exprs: WExpr list) : WExpr =
    match exprs |> List.filter ((<>) WExpr.Nop) with
    | []   -> WExpr.Nop
    | [e]  -> e
    | many -> WExpr.Sequence many

/// Legacy alias — prefer seqOf.
let inline sequence exprs = seqOf exprs

// ── Numeric zero value ────────────────────────────────────────────────────────
/// Zero / null for any WType. Used as default array element / accumulator init.
let makeNumericZero : WType -> WExpr = function
    | WType.I32            -> i32Zero
    | WType.I64            -> WExpr.Const(WConst.I64 0L)
    | WType.F32            -> WExpr.Const(WConst.F32 0.0f)
    | WType.F64            -> WExpr.Const(WConst.F64 0.0)
    | WType.Ref(idx, _)    -> WExpr.Const(WConst.Null(WType.Ref(idx, true)))
    | ty                   -> failwithf "makeNumericZero: non-scalar type %A" ty

// ── Short-circuit logic ───────────────────────────────────────────────────────
/// Logical AND — if cond1 then cond2 else 0.
let wasmAnd c1 c2 = WExpr.If(c1, c2, i32Zero, WType.I32)
/// Logical OR  — if cond1 then 1 else cond2.
let wasmOr  c1 c2 = WExpr.If(c1, i32One, c2, WType.I32)

// ── If / when helpers ─────────────────────────────────────────────────────────

/// True for expressions that always diverge (Break/Continue/Return/Throw).
let isDivergingExpr = function
    | WExpr.Break _ | WExpr.Continue _ | WExpr.Return _ | WExpr.Throw _ -> true
    | _ -> false

/// If–then–else with type inferred from branches; diverging branch uses the other type.
let wasmIf guard thenE elseE =
    let ty = if isDivergingExpr thenE then exprWType elseE else exprWType thenE
    WExpr.If(guard, thenE, elseE, ty)

/// Void if-then (no else).
let wasmWhen guard body = WExpr.If(guard, body, WExpr.Nop, WType.Void)

/// If with Nop elimination on both branches.
let makeIf guard thenBr elseBr retTy =
    match thenBr, elseBr with
    | WExpr.Nop, WExpr.Nop -> WExpr.Nop
    | _                     -> WExpr.If(guard, thenBr, elseBr, retTy)

// ── While loop ────────────────────────────────────────────────────────────────

/// Block/loop/if/break pattern for an arbitrary WExpr guard.
/// This is what WhileExpr and WhileBang dispatch to.
let makeWhileLoop (guard: WExpr) (body: WExpr) : WExpr =
    let gen = LabelGen("while")
    WExpr.Block(gen.Exit,
        WExpr.Loop(gen.Loop,
            WExpr.If(guard,
                seqOf [body; WExpr.Continue(gen.Loop, [])],
                WExpr.Break(gen.Exit, None),
                WType.Void),
            WType.Void),
        WType.Void)

/// Named while loop — use when you need to refer to the labels in the body.
let whileLoop (lbl: string) (cond: WExpr) (body: WExpr) : WExpr =
    let exit = lbl + "_exit"
    WExpr.Block(exit,
        WExpr.Loop(lbl,
            WExpr.If(cond,
                seqOf [body; WExpr.Continue(lbl, [])],
                WExpr.Break(exit, None),
                WType.Void),
            WType.Void),
        WType.Void)

// ── For / counted loops ───────────────────────────────────────────────────────

/// Indexed for-loop from 0 to len-1; body receives the current index as WExpr.
let makeForLoop (len: WExpr) (body: WExpr -> WExpr) : WExpr =
    let idx = freshName()
    WExpr.Let(idx, i32Zero,
        makeWhileLoop (ltS (localGet idx WType.I32) len)
            (seqOf [body (localGet idx WType.I32)
                    localSet idx (add (localGet idx WType.I32) i32One)]))

/// Named counted loop — use when you need the index name for debugging.
let countLoop (lbl: string) (n: WExpr) (body: WExpr -> WExpr) : WExpr =
    let iVar = lbl + "_i"
    let nVar = lbl + "_n"
    WExpr.Let(nVar, n,
        WExpr.LetMut(iVar, i32Zero,
            whileLoop lbl (ltS (localGet iVar WType.I32) (localGet nVar WType.I32))
                (seqOf [body (localGet iVar WType.I32)
                        localSet iVar (add (localGet iVar WType.I32) i32One)])))

// ── Loop with result ──────────────────────────────────────────────────────────

/// Loop with early-exit that carries a typed value — auto-generates labels.
/// Body receives a `brk: WExpr → WExpr` function to exit with a value.
/// `fallback` is emitted if the body falls through without breaking.
let loopResult (ty: WType) (fallback: WExpr) (body: (WExpr -> WExpr) -> WExpr) : WExpr =
    let gen = LabelGen("loop")
    let brk v = WExpr.Break(gen.Exit, Some v)
    WExpr.Block(gen.Exit,
        seqOf [WExpr.Loop(gen.Loop,
                    seqOf [body brk; WExpr.Continue(gen.Loop, [])],
                    WType.Void)
               fallback],
        ty)

// ── Scoped binding helpers ────────────────────────────────────────────────────

/// Immutable let-binding — body receives the LocalGet expression.
let letVal (gen: LabelGen) (tag: string) (ty: WType) (value: WExpr) (body: WExpr -> WExpr) : WExpr =
    let name = gen.Next tag
    WExpr.Let(name, value, body (localGet name ty))

/// Mutable let-binding — body receives LocalGet and a setter function.
let letMut (gen: LabelGen) (tag: string) (ty: WType) (init: WExpr) (body: WExpr -> (WExpr -> WExpr) -> WExpr) : WExpr =
    let name = gen.Next tag
    WExpr.LetMut(name, init, body (localGet name ty) (localSet name))

// ── Control flow helpers ──────────────────────────────────────────────────────
let inline br        label     = WExpr.Break(label, None)
let inline brIf      label cond = WExpr.If(cond, WExpr.Break(label, None), WExpr.Nop, WType.Void)
let inline continue_ label     = WExpr.Continue(label, [])
let inline loop      label body = WExpr.Loop(label, body, WType.Void)
let inline block_    label ty body = WExpr.Block(label, body, ty)

// ─────────────────────────────────────────────────────────────────────────────
// Typed handles — WVar, MutRef, WArray, BlockCtrl
// ─────────────────────────────────────────────────────────────────────────────

/// Strongly-typed handle for a WasmGC local variable.
/// Create with `WVar.letMut` / `WVar.letVal`, or via `let! v = mut expr` in CE.
[<Struct>]
type WVar = { Name: string; Ty: WType } with
    /// Read the current value (LocalGet).
    member v.Val                      = WExpr.LocalGet(v.Name, v.Ty)
    /// Write a new value (LocalSet).
    member v.Set(expr: WExpr)         = WExpr.Assign(v.Name, expr)
    /// Read-modify-write.
    member v.Update(f: WExpr -> WExpr)= WExpr.Assign(v.Name, f (WExpr.LocalGet(v.Name, v.Ty)))

/// Assignment operator: `do! v <== newVal` inside `wasm { }`.
let inline (<==) (v: WVar) (expr: WExpr) = v.Set(expr)

/// Marker type for mutable CE bindings.
/// Created by `mut init` / `mutTy ty init`; consumed by `Bind(MutRef, WVar → WExpr)`.
/// The name is NOT embedded here — the CE builder assigns a fresh name in Bind.
[<Struct>]
type MutRef = { Init: WExpr; Ty: WType }

/// Create a mutable binding marker; type inferred from init expression.
let mut   (init: WExpr) : MutRef = { Init = init; Ty = exprWType init }
/// Create a mutable binding marker with explicit type (for wider-ref initialisers).
let mutTy (ty: WType) (init: WExpr) : MutRef = { Init = init; Ty = ty }

/// Typed wrapper for a WasmGC array expression supporting `.[idx]` indexing.
type WArray = { Expr: WExpr; ElemType: WType } with
    member a.Item(i: WExpr)           = WExpr.ArrayGet(a.Expr, i, a.ElemType)
    member a.Set (i: WExpr) (v: WExpr)= WExpr.ArraySet(a.Expr, i, v)
    member a.Len                      = WExpr.ArrayLen a.Expr

/// Typed break/continue handles for labeled blocks.
type BlockCtrl = {
    Break    : WExpr
    BreakWith: WExpr -> WExpr
    Continue : WExpr
}

// ─────────────────────────────────────────────────────────────────────────────
// WVar / WArray factory modules
// ─────────────────────────────────────────────────────────────────────────────

module WVar =
    let letMut (gen: LabelGen) tag ty init (body: WVar -> WExpr) : WExpr =
        let name = gen.Next tag
        WExpr.LetMut(name, init, body { Name = name; Ty = ty })
    let letVal (gen: LabelGen) tag ty value (body: WVar -> WExpr) : WExpr =
        let name = gen.Next tag
        WExpr.Let(name, value, body { Name = name; Ty = ty })
    let inline ofName name ty : WVar = { Name = name; Ty = ty }

module WArray =
    let inline wrap  elemType expr  : WArray = { Expr = expr;   ElemType = elemType }
    let inline ofVar (v: WVar) elemType : WArray = { Expr = v.Val; ElemType = elemType }

// ─────────────────────────────────────────────────────────────────────────────
// Legacy named-loop helpers (keep for existing call sites in Runtime.fs)
// ─────────────────────────────────────────────────────────────────────────────

/// Named let + named let-mut scoped binding (for explicit-label sites).
let wasmLet    name expr body = WExpr.Let(name, expr, body (WExpr.LocalGet(name, exprWType expr)))
let wasmLetMut name expr body = WExpr.LetMut(name, expr, body (WExpr.LocalGet(name, exprWType expr)))

/// Try-first: return the first Some from a list of thunks.
let tryFirst (fns: (unit -> WExpr option) list) = fns |> List.tryPick (fun f -> f ())

// ═════════════════════════════════════════════════════════════════════════════
// Layer 2 — WasmBuilder CE + Wasm module combinators
// ═════════════════════════════════════════════════════════════════════════════

/// Stack for while! guard — only used by the STANDARD (unpatched) compiler path.
/// The patched compiler calls WhileBang/WhileExpr directly.
let private _whileBangGuards = System.Collections.Generic.Stack<WExpr>()

type WasmBuilder() =

    // ── Core CE protocol ─────────────────────────────────────────────────────

    member _.Zero()                          = WExpr.Nop
    member _.Delay(f: unit -> WExpr)         = f ()      // eager — tree built at CE time
    member _.Run(e: WExpr)                   = e
    member _.Return(e: WExpr)                = e
    member _.Return(_: unit)                 = WExpr.Nop // `do! e` at CE end
    member _.ReturnFrom(e: WExpr)            = e

    member _.Combine(a: WExpr, b: WExpr) =
        match a, b with
        | WExpr.Nop, x | x, WExpr.Nop -> x
        | _                             -> WExpr.Sequence [a; b]

    // ── Bind overloads ────────────────────────────────────────────────────────

    /// `let! x = expr` — introduces a Let for value-typed results;
    /// sequences for void-typed results (same as `do!`).
    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Bind(expr: WExpr, k: WExpr -> WExpr) =
        match exprWType expr with
        | WType.Void ->
            let body = k WExpr.Nop
            match expr, body with
            | WExpr.Nop, _  -> body
            | _, WExpr.Nop  -> expr
            | _             -> WExpr.Sequence [expr; body]
        | ty ->
            let name = freshName()
            WExpr.Let(name, expr, k (WExpr.LocalGet(name, ty)))

    /// `let! v = mut expr` — introduces a mutable binding; k receives a WVar handle.
    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Bind(m: MutRef, k: WVar -> WExpr) : WExpr =
        let name = freshName()
        WExpr.LetMut(name, m.Init, k { Name = name; Ty = m.Ty })

    /// `do! expr` — sequences a void expression.
    /// Guards on Nop input: `do! Nop; rest` → `rest` (no spurious Sequence [Nop; …]).
    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Bind(expr: WExpr, k: unit -> WExpr) =
        match expr with
        | WExpr.Nop -> k ()
        | _ ->
            let body = k ()
            match body with
            | WExpr.Nop -> expr
            | _         -> WExpr.Sequence [expr; body]

    // ── while! — patched compiler (WhileBang) ─────────────────────────────────
    // Guard arrives as WExpr directly; no bool coercion, no stack hack.

    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.WhileBang(guard: WExpr, body: WExpr) = makeWhileLoop guard body

    // ── while! — standard compiler fallback (Bind + While stack hack) ────────
    // Guard is tunnelled through _whileBangGuards and reconstructed in While.
    // Only reached when compiled with unpatched fsc.

    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Bind(guard: WExpr, k: bool -> WExpr) : WExpr =
        _whileBangGuards.Push(guard)
        k true

    member _.While(guard: unit -> bool, body: WExpr) : WExpr =
        if _whileBangGuards.Count > 0
        then makeWhileLoop (_whileBangGuards.Pop()) body
        else body   // guard() is a bool — not reachable in WasmGC context

    // ── while (non-bang) — patched compiler (WhileExpr) ──────────────────────
    // RFC weakness-3 note: WhileExpr and WhileBang have identical bodies;
    // we keep both so the patched compiler can dispatch either form.

    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.WhileExpr(guard: WExpr, body: WExpr) = makeWhileLoop guard body

    // ── if — patched compiler (IfExpr) ───────────────────────────────────────
    // RFC weakness-1 fix: branches are raw WExpr (not Delayed) after the
    //   CheckComputationExpressions.fs change — no trailing Nop from Combine.
    // RFC weakness-2 fix: bool overload handles plain `if cond then` in wasm {}.
    // RFC weakness-5: dispatch is NOT gated on LanguageFeature — the method
    //   presence is checked unconditionally.

    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.IfExpr(guard: WExpr, thenBr: WExpr, elseBr: WExpr) =
        let ty = if isDivergingExpr thenBr then exprWType elseBr else exprWType thenBr
        makeIf guard thenBr elseBr ty

    // Bool overload — `if someCondition then …` where someCondition: bool.
    member _.IfExpr(guard: bool, thenBr: WExpr, elseBr: WExpr) =
        if guard then thenBr else elseBr

    // ── for — patched compiler (ForExpr) ─────────────────────────────────────
    // RFC weakness-4 note: body is a lambda (correct — binds the loop variable).
    // Element type defaults to I32; callers needing a different type use
    // makeForLoop / Wasm.for_ directly.

    [<System.Runtime.CompilerServices.MethodImpl(
        System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.ForExpr(collection: WExpr, body: WExpr -> WExpr) =
        makeForLoop (arrayLen collection) (fun i -> body (arrayGet collection i WType.I32))

    member _.For(sequence: WExpr, body: WExpr -> WExpr) =
        makeForLoop (arrayLen sequence) (fun i -> body (arrayGet sequence i WType.I32))

    // ── Parallel bindings (and!) ──────────────────────────────────────────────

    member _.Bind2Return(a: WExpr, b: WExpr, f: WExpr * WExpr -> WExpr) : WExpr =
        let n1, n2 = freshName(), freshName()
        WExpr.Let(n1, a, WExpr.Let(n2, b, f (WExpr.LocalGet(n1, exprWType a),
                                              WExpr.LocalGet(n2, exprWType b))))

    member _.Bind2(a: WExpr, b: WExpr, f: WExpr * WExpr -> WExpr) : WExpr =
        let n1, n2 = freshName(), freshName()
        WExpr.Let(n1, a, WExpr.Let(n2, b, f (WExpr.LocalGet(n1, exprWType a),
                                              WExpr.LocalGet(n2, exprWType b))))

/// The `wasm { }` singleton CE builder.
let wasm = WasmBuilder()

// ═════════════════════════════════════════════════════════════════════════════
// Wasm — high-level combinators module
// ═════════════════════════════════════════════════════════════════════════════

/// High-level WasmGC control-flow combinators with implicit label management.
/// Prefer these over raw makeWhileLoop / whileLoop in runtime helpers.
module Wasm =

    /// `for i in 0..len-1 do body i`
    let for_ len body = makeForLoop len body

    /// Void if-then.
    let if_   guard thenBr = makeIf guard thenBr WExpr.Nop WType.Void

    /// If-then-else with explicit result type.
    let ifElse guard thenBr elseBr retTy = makeIf guard thenBr elseBr retTy

    /// Standard while loop.
    let while_ guard body = makeWhileLoop guard body

    /// Void conditional — executes body when cond is non-zero.
    let when_ cond body = wasmWhen cond body

    /// Sequence a list of WExpr, collapsing Nops.
    let stmts xs = seqOf xs

    /// Bind-once: `let tmp = e; k tmp` — avoids evaluating e twice.
    let bind (e: WExpr) (k: WExpr -> WExpr) : WExpr =
        match exprWType e with
        | WType.Void -> seqOf [e; k WExpr.Nop]
        | ty -> let n = freshName() in WExpr.Let(n, e, k (WExpr.LocalGet(n, ty)))

    /// Fold over a range 0..len-1 with an accumulator.
    let foldRange (len: WExpr) (init: WExpr) (accTy: WType) (f: WExpr -> WExpr -> WExpr) : WExpr =
        let acc = freshName()
        WExpr.LetMut(acc, init,
            seqOf [for_ len (fun i -> WExpr.Assign(acc, f (localGet acc accTy) i))
                   localGet acc accTy])

    /// Early-exit block — body receives a `breakWith: WExpr → WExpr` to exit with value.
    let withEarlyExit (retTy: WType) (f: (WExpr -> WExpr) -> WExpr) : WExpr =
        let lbl = freshLabel "brk"
        WExpr.Block(lbl,
            f (fun v -> WExpr.Break(lbl, if retTy = WType.Void then None else Some v)),
            retTy)

    /// Infinite loop with BlockCtrl (break exits, continue jumps to top).
    let loop (body: BlockCtrl -> WExpr) : WExpr =
        let gen = LabelGen "loop"
        let ctrl = { Break = WExpr.Break(gen.Exit, None)
                     BreakWith = fun v -> WExpr.Break(gen.Exit, Some v)
                     Continue = WExpr.Continue(gen.Loop, []) }
        WExpr.Block(gen.Exit,
            WExpr.Loop(gen.Loop,
                seqOf [body ctrl; WExpr.Continue(gen.Loop, [])],
                WType.Void),
            WType.Void)

    /// Named block with full BlockCtrl handle (supports BreakWith for typed exits).
    let labeledBlock (gen: LabelGen) (tag: string) (ty: WType) (body: BlockCtrl -> WExpr) : WExpr =
        let lbl  = gen.Next tag
        let ctrl = { Break = WExpr.Break(lbl, None)
                     BreakWith = fun v -> WExpr.Break(lbl, Some v)
                     Continue = WExpr.Continue(lbl, []) }
        WExpr.Block(lbl, body ctrl, ty)

    /// Named loop+block with full BlockCtrl.
    let labeledLoop (gen: LabelGen) (tag: string) (body: BlockCtrl -> WExpr) : WExpr =
        let lbl  = gen.Next tag
        let exit = lbl + "_exit"
        let ctrl = { Break = WExpr.Break(exit, None)
                     BreakWith = fun v -> WExpr.Break(exit, Some v)
                     Continue = WExpr.Continue(lbl, []) }
        WExpr.Block(exit,
            WExpr.Loop(lbl, seqOf [body ctrl; WExpr.Continue(lbl, [])], WType.Void),
            WType.Void)

// ═════════════════════════════════════════════════════════════════════════════
// Layer 3 — WasmDsl infix operators + WasmPatterns active patterns
// ═════════════════════════════════════════════════════════════════════════════

/// Infix operators for WExpr. `open WasmDsl` inside helper modules.
[<AutoOpen>]
module WasmDsl =
    let inline ( +.  ) a b = add   a b
    let inline ( -.  ) a b = sub   a b
    let inline ( *.  ) a b = mul   a b
    let inline ( /.  ) a b = div_  a b
    let inline ( %.  ) a b = rem_  a b
    let inline ( =.  ) a b = eq    a b
    let inline ( <>. ) a b = ne    a b
    let inline ( <.  ) a b = ltS   a b
    let inline ( <=. ) a b = leS   a b
    let inline ( >.  ) a b = gtS   a b
    let inline ( >=. ) a b = geS   a b
    let inline ( &&. ) a b = wasmAnd a b
    let inline ( ||. ) a b = wasmOr  a b
    let inline ( +.. ) a b = addf64 a b
    let inline ( -.. ) a b = subf64 a b
    let inline ( *.. ) a b = mulf64 a b
    let inline ( /.. ) a b = divf64 a b

/// Active patterns for readable, refactor-safe WExpr transforms.
module WasmPatterns =
    let (|I32Lit|_|)  = function WExpr.Const(WConst.I32 n) -> Some n | _ -> None
    let (|I64Lit|_|)  = function WExpr.Const(WConst.I64 n) -> Some n | _ -> None
    let (|F64Lit|_|)  = function WExpr.Const(WConst.F64 v) -> Some v | _ -> None
    let (|I32Zero|_|) = function WExpr.Const(WConst.I32 0) -> Some() | _ -> None
    let (|I32One|_|)  = function WExpr.Const(WConst.I32 1) -> Some() | _ -> None

    let (|BinAdd|_|) = function WExpr.Binary(WBinaryOp.Add,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinSub|_|) = function WExpr.Binary(WBinaryOp.Sub,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinMul|_|) = function WExpr.Binary(WBinaryOp.Mul,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinAnd|_|) = function WExpr.Binary(WBinaryOp.And,  a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinOr|_|)  = function WExpr.Binary(WBinaryOp.Or,   a, b, t) -> Some(a, b, t) | _ -> None

    let (|CmpEq|_|)  = function WExpr.Compare(WCompareOp.Eq,  a, b) -> Some(a, b) | _ -> None
    let (|CmpNe|_|)  = function WExpr.Compare(WCompareOp.Ne,  a, b) -> Some(a, b) | _ -> None
    let (|CmpLt|_|)  = function WExpr.Compare(WCompareOp.LtS, a, b) -> Some(a, b) | _ -> None
    let (|CmpGt|_|)  = function WExpr.Compare(WCompareOp.GtS, a, b) -> Some(a, b) | _ -> None

    let (|IfExpr|_|)   = function WExpr.If(c, t, e, ty) -> Some(c, t, e, ty) | _ -> None
    let (|LocalVar|_|) = function WExpr.LocalGet(n, ty)  -> Some(n, ty)       | _ -> None
    let (|IsNull|_|)   = function WExpr.RefIsNull e       -> Some e            | _ -> None
