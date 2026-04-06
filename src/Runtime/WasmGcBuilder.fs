/// WasmGc Computation Expression Builder — Sprint 4
///
/// Provides `WasmBuilder`, a CE that makes WExpr construction ergonomic.
///
/// Instead of:
///   WExpr.Let("$t0", computeA(),
///     WExpr.Let("$t1", computeB (WExpr.LocalGet("$t0", WType.I32)),
///       WExpr.Binary(WBinaryOp.Add, LocalGet "$t0", LocalGet "$t1", WType.I32)))
///
/// Write:
///   wasm {
///       let! a = computeA ()
///       let! b = computeB a
///       return WExpr.Binary(WBinaryOp.Add, a, b, WType.I32)
///   }
///
/// Rules:
///   - Do NOT rewrite existing WExpr-construction code (it stays as-is).
///   - Use the CE for NEW runtime helpers, NEW optimisation passes, and tests.
module Fable.Transforms.WasmGc.WasmGcBuilder

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes

// ─────────────────────────────────────────────────────────────────
// Fresh name generation (thread-safe)
// ─────────────────────────────────────────────────────────────────

let private nameCounter = ref 0

/// Generate a unique local-variable name guaranteed not to clash with
/// user-level names (which start with letters, not '$w').
let freshName () =
    let n = System.Threading.Interlocked.Increment(nameCounter)
    $"$w{n}"

// ─────────────────────────────────────────────────────────────────
// WVar — typed mutable handles (moved here so WasmBuilder can reference it)
// ─────────────────────────────────────────────────────────────────

/// A strongly-typed handle for a WasmGC local variable.
/// Eliminates string-keyed `localGet "$name" i32` boilerplate.
///
/// Create with `WVar.letMut` or via `let! v = mut expr` in the CE.
/// Use `.Val` to read, `.Set(e)` to assign, `.Update(f)` to modify.
[<Struct>]
type WVar = { Name: string; Ty: WType }
    with
        /// The current value as a WExpr (LocalGet).
        member v.Val = WExpr.LocalGet(v.Name, v.Ty)
        /// Assign a new value (LocalSet).
        member v.Set(expr: WExpr) = WExpr.Assign(v.Name, expr)
        /// Assign the result of a function applied to the current value.
        member v.Update(f: WExpr -> WExpr) = WExpr.Assign(v.Name, f (WExpr.LocalGet(v.Name, v.Ty)))

/// Mutation shorthand: `v <== expr` is equivalent to `v.Set(expr)`.
/// Use with `do!` inside a `wasm { }` block:
///   do! acc <== folder acc.Val elem
let inline (<==) (v: WVar) (expr: WExpr) = v.Set(expr)

// ─────────────────────────────────────────────────────────────────
// MutInit — mutable binding marker for the CE
// ─────────────────────────────────────────────────────────────────

/// Marker type for mutable bindings inside `wasm { }`.
/// Use `mut expr` or `mutTy ty expr` to create, then bind with `let! v = ...`.
///
///   wasm {
///       let! i = mut (i32Const 0)             // mutable i32
///       let! p = mutTy s.BaseTy wList         // mutable with explicit type
///       do! Wasm.while_ (cond) (wasm {
///           do! i.Set(add i.Val (i32Const 1))
///       })
///       return i.Val
///   }
[<Struct>]
type MutInit = { Init: WExpr; Ty: WType }

/// Create a mutable binding marker; type is inferred from the expression.
let mut (init: WExpr) : MutInit = { Init = init; Ty = exprWType init }

/// Create a mutable binding marker with an explicit type
/// (needed when the init expression type doesn't match the variable type,
/// e.g. nullable ref init for a broader ref type).
let mutTy (ty: WType) (init: WExpr) : MutInit = { Init = init; Ty = ty }

// ─────────────────────────────────────────────────────────────────
// WasmBuilder — monadic CE over WExpr
// ─────────────────────────────────────────────────────────────────

/// Computation-expression builder for WExpr.
///
/// The monad is roughly:  m a  ≅  WExpr   (value of type a encoded as a local)
///
/// `let! x = e` introduces a fresh let-binding and passes a `LocalGet` to the
/// continuation, so `x` is ready-to-use wherever a WExpr is expected.
///
/// `let! v = mut expr` introduces a mutable binding and passes a `WVar` handle.
/// Use `v.Val` to read, `v.Set(newVal)` to assign.
///
/// `do! e` sequences a void-typed expression without naming its result.
type WasmBuilder() =

    /// `let! x = e in k x` — introduce a binding.
    /// If `e` is void-typed (procedure call), sequences it and calls k with Nop.
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    // [<InlineIfLambda>]  // Can't use this because of the overload with unit->WExpr below.
    member _.Bind(expr: WExpr, k: WExpr -> WExpr) =
        match exprWType expr with
        | WType.Void ->
            // Sequence the side-effect; continuation gets unit (Nop).
            let body = k WExpr.Nop
            match body with
            | WExpr.Nop -> expr  // `let! _ = e` at the end of a CE: just e
            | _ -> WExpr.Sequence [expr; body]
        | ty ->
            let name = freshName ()
            WExpr.Let(name, expr, k (WExpr.LocalGet(name, ty)))

    /// `let! v = mut expr` — introduce a mutable binding.
    /// The continuation receives a `WVar` with `.Val` / `.Set(e)` / `.Update(f)`.
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Bind(m: MutInit, k: WVar -> WExpr) : WExpr =
        let name = freshName ()
        WExpr.LetMut(name, m.Init, k { Name = name; Ty = m.Ty })

    /// `do! e` — sequence a void expression, ignoring its (unit) result.
    /// F# desugars `do! e` as `Bind(e, fun () -> rest)` so we need this overload.
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Bind(expr: WExpr, k: unit -> WExpr) =
        let body = k ()
        match body with
        | WExpr.Nop -> expr
        | _ -> WExpr.Sequence [expr; body]

    /// `return e` — wrap a value.
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Return(expr: WExpr) = expr

    /// `return! e` — return an already-built WExpr directly.
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.ReturnFrom(expr: WExpr) = expr

    /// Empty CE block → Nop.
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Zero() = WExpr.Nop

    /// Combine two sequential statements (used when the CE has bare `e1; e2`).
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Combine(a: WExpr, b: WExpr) =
        match a, b with
        | WExpr.Nop, _ -> b
        | _, WExpr.Nop -> a
        | _ -> WExpr.Sequence [a; b]

    /// Delay — called by F# CE desugaring; we evaluate immediately (no laziness).
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Delay(f: unit -> WExpr) = f ()

    /// Run — identity (CE result is the WExpr directly).
    [<System.Runtime.CompilerServices.MethodImpl(System.Runtime.CompilerServices.MethodImplOptions.AggressiveInlining)>]
    member _.Run(expr: WExpr) = expr

// ─────────────────────────────────────────────────────────────────
// Builder singleton
// ─────────────────────────────────────────────────────────────────

/// Singleton `WasmBuilder` instance.  Use in modules as:
///   let myExpr = wasm { let! x = e; return f x }
let wasm = WasmBuilder()

// ─────────────────────────────────────────────────────────────────
// Smart constructors — thin helpers for common WExpr patterns.
// These complement the CE; use them inline inside or outside a `wasm` block.
// ─────────────────────────────────────────────────────────────────

/// Returns true for expressions that always diverge (Break/Continue/Return),
/// which have no meaningful result type and should be treated as bottom/polymorphic.
let isDivergingExpr = function
    | WExpr.Break _ | WExpr.Continue _ | WExpr.Return _ -> true
    | _ -> false

/// Construct an if–then–else; result type is inferred from the branches.
/// If then-branch diverges (Break/Continue/Return), type is taken from else-branch.
let inline wasmIf cond thenE elseE =
    let ty =
        if isDivergingExpr thenE then exprWType elseE
        else exprWType thenE
    WExpr.If(cond, thenE, elseE, ty)

/// Void if-then (no else case).
let inline wasmWhen cond body =
    WExpr.If(cond, body, WExpr.Nop, WType.Void)

/// Sequence a list of void expressions.
let wasmSeq (exprs: WExpr list) =
    match exprs with
    | [] -> WExpr.Nop
    | [single] -> single
    | _ -> WExpr.Sequence exprs

/// Introduce a named let-binding with explicit type (for when type inference can't help).
let wasmLet name (expr: WExpr) (body: WExpr -> WExpr) =
    let ty = exprWType expr
    WExpr.Let(name, expr, body (WExpr.LocalGet(name, ty)))

/// Introduce a named mutable let-binding.
let wasmLetMut name (expr: WExpr) (body: WExpr -> WExpr) =
    let ty = exprWType expr
    WExpr.LetMut(name, expr, body (WExpr.LocalGet(name, ty)))

/// Logical AND short-circuit: if cond1 then cond2 else 0.
let wasmAnd cond1 cond2 =
    WExpr.If(cond1, cond2, WExpr.Const(WConst.I32 0), WType.I32)

/// Logical OR short-circuit: if cond1 then 1 else cond2.
let wasmOr cond1 cond2 =
    WExpr.If(cond1, WExpr.Const(WConst.I32 1), cond2, WType.I32)

// ─────────────────────────────────────────────────────────────────
// Additional smart constructors — Sprint 10a additions.
// These cover array, struct, arithmetic, branches and tags for
// use in wasm { } blocks or directly in WasmGcRuntime.fs helpers.
// ─────────────────────────────────────────────────────────────────

// --- Constants ---

let i32Const (n: int)     = WExpr.Const(WConst.I32 n)
let i64Const (n: int64)   = WExpr.Const(WConst.I64 n)
let f32Const (v: float32) = WExpr.Const(WConst.F32 v)
let f64Const (v: float)   = WExpr.Const(WConst.F64 v)
let nullConst (ty: WType) = WExpr.Const(WConst.Null ty)

// --- Locals / Globals ---

let localGet (name: string) (ty: WType) = WExpr.LocalGet(name, ty)
let localSet (name: string) (v: WExpr)  = WExpr.Assign(name, v)
let globalGet (name: string) (ty: WType) = WExpr.GlobalGet(name, ty)
let globalSet (name: string) (v: WExpr)  = WExpr.GlobalSet(name, v)

// --- Arithmetic (i32) ---

let add  a b = WExpr.Binary(WBinaryOp.Add,  a, b, WType.I32)
let sub  a b = WExpr.Binary(WBinaryOp.Sub,  a, b, WType.I32)
let mul  a b = WExpr.Binary(WBinaryOp.Mul,  a, b, WType.I32)
let div_ a b = WExpr.Binary(WBinaryOp.DivS, a, b, WType.I32)
let rem_ a b = WExpr.Binary(WBinaryOp.RemS, a, b, WType.I32)
let and_ a b = WExpr.Binary(WBinaryOp.And,  a, b, WType.I32)
let or_  a b = WExpr.Binary(WBinaryOp.Or,   a, b, WType.I32)
let xor_ a b = WExpr.Binary(WBinaryOp.Xor,  a, b, WType.I32)
let shl  a b = WExpr.Binary(WBinaryOp.Shl,  a, b, WType.I32)
let shrS a b = WExpr.Binary(WBinaryOp.ShrS, a, b, WType.I32)
let shrU a b = WExpr.Binary(WBinaryOp.ShrU, a, b, WType.I32)

// --- Arithmetic (f64) ---

let addf64 a b = WExpr.Binary(WBinaryOp.Add, a, b, WType.F64)
let subf64 a b = WExpr.Binary(WBinaryOp.Sub, a, b, WType.F64)
let mulf64 a b = WExpr.Binary(WBinaryOp.Mul, a, b, WType.F64)
let divf64 a b = WExpr.Binary(WBinaryOp.DivS, a, b, WType.F64)

// --- Comparisons ---

let eq   a b = WExpr.Compare(WCompareOp.Eq,  a, b)
let ne   a b = WExpr.Compare(WCompareOp.Ne,  a, b)
let ltS  a b = WExpr.Compare(WCompareOp.LtS, a, b)
let leS  a b = WExpr.Compare(WCompareOp.LeS, a, b)
let gtS  a b = WExpr.Compare(WCompareOp.GtS, a, b)
let geS  a b = WExpr.Compare(WCompareOp.GeS, a, b)
let ltU  a b = WExpr.Compare(WCompareOp.LtU, a, b)
let gtU  a b = WExpr.Compare(WCompareOp.GtU, a, b)
let refEq a b = WExpr.Compare(WCompareOp.RefEq, a, b)

// --- Ref ops ---

let refIsNull  (e: WExpr)              = WExpr.RefIsNull e
let cast       (e: WExpr) (ty: WType) = WExpr.Cast(e, ty)
let tagOf      (obj: WExpr)            = WExpr.TagOf obj

// --- Array ops ---

/// array.new — allocate an array of `size` elements all initialised to `init`.
let arrayNew (typeIdx: int) (size: WExpr) (init: WExpr) (ty: WType) =
    WExpr.ArrayNew(typeIdx, size, init, ty)

let arrayNewFixed (typeIdx: int) (elems: WExpr list) (ty: WType) =
    WExpr.ArrayNewFixed(typeIdx, elems, ty)

let arrayGet (arr: WExpr) (idx: WExpr) (ty: WType) =
    WExpr.ArrayGet(arr, idx, ty)

let arraySet (arr: WExpr) (idx: WExpr) (v: WExpr) =
    WExpr.ArraySet(arr, idx, v)

let arrayLen (arr: WExpr) = WExpr.ArrayLen arr

let arrayCopy (dst: WExpr) (dstOff: WExpr) (src: WExpr) (srcOff: WExpr) (len: WExpr) =
    WExpr.ArrayCopy(dst, dstOff, src, srcOff, len)

// --- Struct ops ---

let structNew (typeIdx: int) (fields: WExpr list) (ty: WType) =
    WExpr.StructNew(typeIdx, fields, ty)

let structGet (obj: WExpr) (fieldIdx: int) (ty: WType) =
    WExpr.StructGet(obj, fieldIdx, ty)

let structSet (obj: WExpr) (fieldIdx: int) (v: WExpr) =
    WExpr.StructSet(obj, fieldIdx, v)

// --- Control flow ---

/// Unconditional break to a labelled block (no value).
let br (label: string) = WExpr.Break(label, None)

/// Conditional break: if `cond` is non-zero, break to `label`.
let brIf (label: string) (cond: WExpr) =
    WExpr.If(cond, WExpr.Break(label, None), WExpr.Nop, WType.Void)

/// Continue (jump back to top of) a named loop.
let continue_ (label: string) = WExpr.Continue(label, [])

/// Loop with a label; body is Void.
let loop (label: string) (body: WExpr) =
    WExpr.Loop(label, body, WType.Void)

/// Block with a label and explicit result type.
let block_ (label: string) (ty: WType) (body: WExpr) =
    WExpr.Block(label, body, ty)

/// Sequence, filtering out Nop entries.
let sequence (exprs: WExpr list) =
    let active = exprs |> List.filter (fun e -> e <> WExpr.Nop)
    match active with
    | []       -> WExpr.Nop
    | [single] -> single
    | _        -> WExpr.Sequence active

// --- Calls ---

let call (func: string) (args: WExpr list) (ty: WType) =
    WExpr.Call(func, args, ty)

// ─────────────────────────────────────────────────────────────────
// Loop sugar — Sprint 11
// ─────────────────────────────────────────────────────────────────

/// Standard while loop:
///   block $exit { loop $lbl { if cond { body; continue $lbl } else { break $exit } } }
let whileLoop (lbl: string) (cond: WExpr) (body: WExpr) : WExpr =
    let exitLbl = lbl + "_exit"
    WExpr.Block(exitLbl,
        WExpr.Loop(lbl,
            WExpr.If(cond,
                WExpr.Sequence [body; WExpr.Continue(lbl, [])],
                WExpr.Break(exitLbl, None),
                WType.Void),
            WType.Void),
        WType.Void)

/// Loop with early exit that carries a value:
///   block $exit : ty { loop $lbl { body; continue $lbl }; fallback }
let loopWithResult (lbl: string) (ty: WType) (body: WExpr) (fallback: WExpr) : WExpr =
    let exitLbl = lbl + "_exit"
    WExpr.Block(exitLbl,
        WExpr.Sequence [
            WExpr.Loop(lbl, WExpr.Sequence [body; WExpr.Continue(lbl, [])], WType.Void)
            fallback
        ],
        ty)

/// Loop with early-exit that carries a typed value — auto-generates labels.
/// The body receives a `brk: WExpr → WExpr` function to exit with a value.
/// `fallback` is emitted if the body falls through without breaking.
///
///   loopResult WType.I32 (i32Const -1) (fun brk ->
///       Wasm.when_ (cond) (brk foundValue))
let loopResult (ty: WType) (fallback: WExpr) (body: (WExpr -> WExpr) -> WExpr) : WExpr =
    let lbl = freshName ()
    let exitLbl = lbl + "_exit"
    let brk (v: WExpr) = WExpr.Break(exitLbl, Some v)
    let bodyExpr = body brk
    WExpr.Block(exitLbl,
        WExpr.Sequence [
            WExpr.Loop(lbl, WExpr.Sequence [bodyExpr; WExpr.Continue(lbl, [])], WType.Void)
            fallback
        ],
        ty)

/// Counted loop from 0 to n (exclusive), body receives index as WExpr.
let countLoop (lbl: string) (n: WExpr) (body: WExpr -> WExpr) : WExpr =
    let iVar = lbl + "_i"
    let nVar = lbl + "_n"
    let iGet = localGet iVar WType.I32
    let nGet = localGet nVar WType.I32
    WExpr.Let(nVar, n,
        WExpr.LetMut(iVar, i32Const 0,
            whileLoop lbl (ltS iGet nGet) (
                sequence [
                    body iGet
                    localSet iVar (add iGet (i32Const 1))
                ])))

// ─────────────────────────────────────────────────────────────────
// LabelGen — deterministic, debuggable label generation
// ─────────────────────────────────────────────────────────────────

/// Generates scoped, deterministic variable/label names.
/// Each LabelGen instance has its own counter, so names won't clash
/// between different combinator invocations.
///
/// Usage:
///   let gen = LabelGen "fold"
///   let cur = gen.Next "cur"   // "$fold_cur_1"
///   let acc = gen.Next "acc"   // "$fold_acc_2"
type LabelGen(prefix: string) =
    let mutable n = 0
    member _.Next(tag: string) =
        n <- n + 1
        $"${prefix}_{tag}_{n}"
    member _.Prefix = prefix

// ─────────────────────────────────────────────────────────────────
// Scoped variable helpers — letVal / letMut
// ─────────────────────────────────────────────────────────────────

/// Introduce an immutable let-binding; body receives the LocalGet expression.
///
///   letVal gen "n" WType.I32 (arrayLen arr) (fun gn -> ...)
let letVal (gen: LabelGen) (tag: string) (ty: WType) (value: WExpr) (body: WExpr -> WExpr) : WExpr =
    let name = gen.Next(tag)
    WExpr.Let(name, value, body (localGet name ty))

/// Introduce a mutable let-binding; body receives the LocalGet expression AND
/// a setter function (WExpr → WExpr = LocalSet "name" newVal).
///
///   letMut gen "i" WType.I32 (i32Const 0) (fun i setI ->
///       whileLoop ... (sequence [setI (add i (i32Const 1))]))
let letMut (gen: LabelGen) (tag: string) (ty: WType) (init: WExpr) (body: WExpr -> (WExpr -> WExpr) -> WExpr) : WExpr =
    let name = gen.Next(tag)
    WExpr.LetMut(name, init, body (localGet name ty) (localSet name))

/// RefIsNotNull — often needed inside loop conditions.
/// Implemented as eqz(ref.is_null e): returns 1 when e is not null.
let refIsNotNull (e: WExpr) = WExpr.Unary(WUnaryOp.Eqz, WExpr.RefIsNull e, WType.I32)

/// Try a sequence of option-returning thunks; return the first Some.
/// Replaces the match...| None -> match...| None -> waterfall pattern.
let tryFirst (fns: (unit -> WExpr option) list) : WExpr option =
    fns |> List.tryPick (fun f -> f ())

/// Helper zero-value for a numeric WType (used by buildListSort etc.)
let makeNumericZero = function
    | WType.I32 -> i32Const 0
    | WType.I64 -> i64Const 0L
    | WType.F32 -> f32Const 0.0f
    | WType.F64 -> f64Const 0.0
    | ty        -> failwithf "makeNumericZero: non-numeric type %A" ty

// ─────────────────────────────────────────────────────────────────
// WVar factory helpers
// ─────────────────────────────────────────────────────────────────

/// Factory and scoping helpers for `WVar`.
module WVar =
    /// Introduce a mutable local; body receives a `WVar` handle.
    ///   WVar.letMut gen "i" WType.I32 (i32Const 0) (fun i ->
    ///       i.Update(fun v -> add v (i32Const 1)))
    let letMut (gen: LabelGen) (tag: string) (ty: WType) (init: WExpr) (body: WVar -> WExpr) : WExpr =
        let name = gen.Next(tag)
        WExpr.LetMut(name, init, body { Name = name; Ty = ty })

    /// Introduce an immutable local; body receives a `WVar` handle.
    let letVal (gen: LabelGen) (tag: string) (ty: WType) (value: WExpr) (body: WVar -> WExpr) : WExpr =
        let name = gen.Next(tag)
        WExpr.Let(name, value, body { Name = name; Ty = ty })

    /// Wrap an existing local name as a WVar (for interfacing with legacy code).
    let inline ofName (name: string) (ty: WType) : WVar = { Name = name; Ty = ty }

// ─────────────────────────────────────────────────────────────────
// WArray — typed array handle with .[idx] indexing
// ─────────────────────────────────────────────────────────────────

/// A typed wrapper for a WasmGC array expression that supports `.[idx]` indexing.
///
///   let arr = WArray.wrap WType.I32 someArrayExpr
///   arr.[i.Val]           // → arrayGet someArrayExpr i.Val WType.I32
///   arr.Set(i.Val) v      // → arraySet someArrayExpr i.Val v
///   arr.Len               // → arrayLen someArrayExpr
type WArray = { Expr: WExpr; ElemType: WType }
    with
        member a.Item(idx: WExpr) = WExpr.ArrayGet(a.Expr, idx, a.ElemType)
        member a.Set(idx: WExpr) (v: WExpr) = WExpr.ArraySet(a.Expr, idx, v)
        member a.Len = WExpr.ArrayLen(a.Expr)

/// Factory helpers for `WArray`.
module WArray =
    /// Wrap a WExpr as a typed array handle.
    let inline wrap (elemType: WType) (expr: WExpr) : WArray = { Expr = expr; ElemType = elemType }
    /// Wrap a local variable as a typed array handle.
    let inline ofVar (v: WVar) (elemType: WType) : WArray = { Expr = v.Val; ElemType = elemType }

// ─────────────────────────────────────────────────────────────────
// Wasm — implicit-label high-level control flow
// ─────────────────────────────────────────────────────────────────

/// High-level WasmGC control-flow combinators with implicit label management.
/// Use these in `wasm { }` blocks instead of `whileLoop lbl cond body`.
module Wasm =

    /// While loop — auto-generates labels.
    ///   Wasm.while_ (cond) body
    let while_ (cond: WExpr) (body: WExpr) : WExpr =
        let lbl = freshName ()
        whileLoop lbl cond body

    /// Conditional — executes body when cond is non-zero (void result).
    let when_ (cond: WExpr) (body: WExpr) : WExpr = wasmWhen cond body

    /// Counter loop from 0 to n-1; body receives the current index.
    ///   Wasm.for_ n (fun i -> ...)
    let for_ (n: WExpr) (body: WExpr -> WExpr) : WExpr =
        let lbl = freshName ()
        countLoop lbl n body

    /// Loop-control handles passed to `Wasm.loop`.
    type LoopCtrl = {
        /// Exit the loop immediately (void).
        Brk: WExpr
        /// Jump back to the top of the loop.
        Cont: WExpr
    }

    /// Infinite loop with explicit break/continue handles.
    /// The body is called once to produce a WExpr; uses `ctrl.Brk` to exit.
    ///
    ///   Wasm.loop (fun ctrl -> wasm {
    ///       do! Wasm.when_ (condition) ctrl.Brk
    ///       // ... body ...
    ///   })
    let loop (body: LoopCtrl -> WExpr) : WExpr =
        let lbl = freshName ()
        let exitLbl = lbl + "_exit"
        let ctrl = { Brk = WExpr.Break(exitLbl, None); Cont = WExpr.Continue(lbl, []) }
        let bodyExpr = body ctrl
        WExpr.Block(exitLbl,
            WExpr.Loop(lbl,
                WExpr.Sequence [bodyExpr; WExpr.Continue(lbl, [])],
                WType.Void),
            WType.Void)

// ─────────────────────────────────────────────────────────────────
// WasmDsl — infix operators for WExpr (open when needed)
// ─────────────────────────────────────────────────────────────────

/// Infix operator module for WExpr.
/// `open WasmDsl` inside a `wasm { }` helper to write:
///   j.Val +. i32Const 1   instead of   add j.Val (i32Const 1)
///   a =. b                instead of   eq a b
///   a &&. b               instead of   wasmAnd a b
[<AutoOpen>]
module WasmDsl =
    // i32 arithmetic
    let inline ( +. )  (a: WExpr) (b: WExpr) = add a b
    let inline ( -. )  (a: WExpr) (b: WExpr) = sub a b
    let inline ( *. )  (a: WExpr) (b: WExpr) = mul a b
    let inline ( /. )  (a: WExpr) (b: WExpr) = div_ a b
    let inline ( %. )  (a: WExpr) (b: WExpr) = rem_ a b
    // i32 comparisons
    let inline ( =. )  (a: WExpr) (b: WExpr) = eq  a b
    let inline ( <>.)  (a: WExpr) (b: WExpr) = ne  a b
    let inline ( <. )  (a: WExpr) (b: WExpr) = ltS a b
    let inline ( <=.)  (a: WExpr) (b: WExpr) = leS a b
    let inline ( >. )  (a: WExpr) (b: WExpr) = gtS a b
    let inline ( >=.)  (a: WExpr) (b: WExpr) = geS a b
    // logical (short-circuit)
    let inline ( &&.)  (a: WExpr) (b: WExpr) = wasmAnd a b
    let inline ( ||.)  (a: WExpr) (b: WExpr) = wasmOr  a b
    // f64 arithmetic (double-dot to avoid clash with i32 ops)
    let inline ( +.. ) (a: WExpr) (b: WExpr) = addf64 a b
    let inline ( -.. ) (a: WExpr) (b: WExpr) = subf64 a b
    let inline ( *.. ) (a: WExpr) (b: WExpr) = mulf64 a b
    let inline ( /.. ) (a: WExpr) (b: WExpr) = divf64 a b

// ─────────────────────────────────────────────────────────────────
// WasmPatterns — active patterns for AST transformation (Tier 3)
// ─────────────────────────────────────────────────────────────────

/// Active patterns for matching common WExpr forms.
/// Use in `WasmGcReplacements.fs` or the optimizer to write
/// readable, refactor-safe AST transforms.
///
///   match expr with
///   | I32Zero -> i32Const 0    // identity: 0 + x → x
///   | BinAdd(I32Zero, x) | BinAdd(x, I32Zero) -> x
///   | _ -> ...
module WasmPatterns =

    let (|I32Lit|_|)  = function WExpr.Const(WConst.I32 n) -> Some n | _ -> None
    let (|I64Lit|_|)  = function WExpr.Const(WConst.I64 n) -> Some n | _ -> None
    let (|F64Lit|_|)  = function WExpr.Const(WConst.F64 v) -> Some v | _ -> None
    let (|I32Zero|_|) = function WExpr.Const(WConst.I32 0) -> Some() | _ -> None
    let (|I32One|_|)  = function WExpr.Const(WConst.I32 1) -> Some() | _ -> None

    let (|BinAdd|_|) = function
        | WExpr.Binary(WBinaryOp.Add, a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinSub|_|) = function
        | WExpr.Binary(WBinaryOp.Sub, a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinMul|_|) = function
        | WExpr.Binary(WBinaryOp.Mul, a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinAnd|_|) = function
        | WExpr.Binary(WBinaryOp.And, a, b, t) -> Some(a, b, t) | _ -> None
    let (|BinOr|_|)  = function
        | WExpr.Binary(WBinaryOp.Or,  a, b, t) -> Some(a, b, t) | _ -> None

    let (|CmpEq|_|) = function
        | WExpr.Compare(WCompareOp.Eq,  a, b) -> Some(a, b) | _ -> None
    let (|CmpNe|_|) = function
        | WExpr.Compare(WCompareOp.Ne,  a, b) -> Some(a, b) | _ -> None
    let (|CmpLt|_|) = function
        | WExpr.Compare(WCompareOp.LtS, a, b) -> Some(a, b) | _ -> None
    let (|CmpGt|_|) = function
        | WExpr.Compare(WCompareOp.GtS, a, b) -> Some(a, b) | _ -> None

    let (|IfExpr|_|) = function
        | WExpr.If(cond, thenE, elseE, ty) -> Some(cond, thenE, elseE, ty) | _ -> None
    let (|LocalVar|_|) = function
        | WExpr.LocalGet(name, ty) -> Some(name, ty) | _ -> None
    let (|IsNull|_|) = function
        | WExpr.RefIsNull e -> Some e | _ -> None
