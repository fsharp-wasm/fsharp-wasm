/// Phase 4b: WExpr Lowering — HIR → LIR
///
/// Eliminates compiler-managed temporaries from Emit.fs by making them
/// explicit Let-bound variables in the WExpr tree.
///
/// Before: Emit.fs injected $clo_apply_tmp and $switch_tmp at code-gen time.
/// After:  Emit.fs is a pure 1:1 WExpr→Instr serializer. No hidden state.
///
/// Pipeline position: AFTER Phase 4 (Normalize), BEFORE Phase 5 (Locals).
/// collectLocals automatically picks up the introduced $lo_* bindings.
///
/// Also required: add WExpr.CallRef / WExpr.ReturnCallRef to AST.fs:
///   | CallRef       of funcTypeIdx: int * args: WExpr list * codePtr: WExpr * retTy: WType
///   | ReturnCallRef of funcTypeIdx: int * args: WExpr list * codePtr: WExpr * retTy: WType
/// These replace ClosureApply/TailCallRef in the LIR.
module WasmGc.Pipeline.Lower

open WasmGc.Core.AST

// ─────────────────────────────────────────────────────────────────
// Fresh name generation
// ─────────────────────────────────────────────────────────────────

let private lowerCounter = ref 0
let private freshLow (tag: string) =
    let n = System.Threading.Interlocked.Increment(lowerCounter)
    sprintf "$lo_%s_%d" tag n

// ─────────────────────────────────────────────────────────────────
// Node lowering
// ─────────────────────────────────────────────────────────────────

/// Lower ClosureApply → Let($lo_clo_N, Cast(clo,...), CallRef(fti, [self]+args, codePtr))
///
/// The calling convention (self first, then args, then code ptr) becomes explicit
/// in the WExpr tree — no emitter magic needed.
let private lowerClosureApply (clo: WExpr) (args: WExpr list) (fti: int) (cti: int) (retTy: WType) =
    let tmp     = freshLow "clo"
    let baseTy  = WType.Ref(cti, false)
    let castClo = if cti > 0 then WExpr.Cast(clo, baseTy) else clo
    let self    = WExpr.LocalGet(tmp, baseTy)
    let codePtr = WExpr.StructGet(self, 0, WType.Ref(fti, false))
    let realArgs = args |> List.filter (fun a -> exprWType a <> WType.Void)
    WExpr.Let(tmp, castClo, WExpr.CallRef(fti, self :: realArgs, codePtr, retTy))

/// Lower TailCallRef → Let($lo_tail_N, Cast(clo,...), ReturnCallRef(...))
let private lowerTailCallRef (clo: WExpr) (args: WExpr list) (fti: int) (cti: int) (retTy: WType) =
    let tmp     = freshLow "tail"
    let baseTy  = WType.Ref(cti, false)
    let castClo = if cti > 0 then WExpr.Cast(clo, baseTy) else clo
    let self    = WExpr.LocalGet(tmp, baseTy)
    let codePtr = WExpr.StructGet(self, 0, WType.Ref(fti, false))
    let realArgs = args |> List.filter (fun a -> exprWType a <> WType.Void)
    WExpr.Let(tmp, castClo, WExpr.ReturnCallRef(fti, self :: realArgs, codePtr, retTy))

/// Lower SwitchInt scrutinee: bind to Let when not already a LocalGet.
let private lowerSwitch (scrut: WExpr) (cases: (int * WExpr) list) (def: WExpr) (retTy: WType) =
    match scrut with
    | WExpr.LocalGet _ -> WExpr.SwitchInt(scrut, cases, def, retTy)
    | _ ->
        let tmp = freshLow "sw"
        WExpr.Let(tmp, scrut, WExpr.SwitchInt(WExpr.LocalGet(tmp, WType.I32), cases, def, retTy))

// ─────────────────────────────────────────────────────────────────
// Recursive lowering
// ─────────────────────────────────────────────────────────────────

let rec lowerExpr (e: WExpr) : WExpr =
    match e with
    | WExpr.ClosureApply(clo, args, fti, cti, _, ret) ->
        lowerClosureApply (lowerExpr clo) (List.map lowerExpr args) fti cti ret
    | WExpr.TailCallRef(clo, args, fti, cti, _, ret) ->
        lowerTailCallRef (lowerExpr clo) (List.map lowerExpr args) fti cti ret
    | WExpr.SwitchInt(s, cases, def, ret) ->
        lowerSwitch (lowerExpr s) (cases |> List.map (fun (n,e) -> n, lowerExpr e)) (lowerExpr def) ret
    | WExpr.Let(n, v, b)               -> WExpr.Let(n, lowerExpr v, lowerExpr b)
    | WExpr.LetMut(n, v, b)            -> WExpr.LetMut(n, lowerExpr v, lowerExpr b)
    | WExpr.If(c, t, el, ty)           -> WExpr.If(lowerExpr c, lowerExpr t, lowerExpr el, ty)
    | WExpr.Sequence xs                -> WExpr.Sequence(List.map lowerExpr xs)
    | WExpr.Block(l, b, ty)            -> WExpr.Block(l, lowerExpr b, ty)
    | WExpr.Loop(l, b, ty)             -> WExpr.Loop(l, lowerExpr b, ty)
    | WExpr.Assign(n, v)               -> WExpr.Assign(n, lowerExpr v)
    | WExpr.GlobalSet(n, v)            -> WExpr.GlobalSet(n, lowerExpr v)
    | WExpr.Call(n, args, ty)          -> WExpr.Call(n, List.map lowerExpr args, ty)
    | WExpr.TailCall(n, args, ty)      -> WExpr.TailCall(n, List.map lowerExpr args, ty)
    | WExpr.CallIndirect(f, args, ty)  -> WExpr.CallIndirect(lowerExpr f, List.map lowerExpr args, ty)
    | WExpr.Binary(op, a, b, ty)       -> WExpr.Binary(op, lowerExpr a, lowerExpr b, ty)
    | WExpr.Unary(op, x, ty)           -> WExpr.Unary(op, lowerExpr x, ty)
    | WExpr.Compare(op, a, b)          -> WExpr.Compare(op, lowerExpr a, lowerExpr b)
    | WExpr.Cast(x, ty)                -> WExpr.Cast(lowerExpr x, ty)
    | WExpr.RefIsNull x                -> WExpr.RefIsNull(lowerExpr x)
    | WExpr.RefTest(x, ty)             -> WExpr.RefTest(lowerExpr x, ty)
    | WExpr.TagOf x                    -> WExpr.TagOf(lowerExpr x)
    | WExpr.ArrayLen x                 -> WExpr.ArrayLen(lowerExpr x)
    | WExpr.ArrayGet(a, i, ty)         -> WExpr.ArrayGet(lowerExpr a, lowerExpr i, ty)
    | WExpr.ArraySet(a, i, v)          -> WExpr.ArraySet(lowerExpr a, lowerExpr i, lowerExpr v)
    | WExpr.ArrayNew(ti, s, init, ty)  -> WExpr.ArrayNew(ti, lowerExpr s, lowerExpr init, ty)
    | WExpr.ArrayNewFixed(ti, fs, ty)  -> WExpr.ArrayNewFixed(ti, List.map lowerExpr fs, ty)
    | WExpr.ArrayCopy(d, do_, s, so, n) ->
        WExpr.ArrayCopy(lowerExpr d, lowerExpr do_, lowerExpr s, lowerExpr so, lowerExpr n)
    | WExpr.StructNew(ti, fs, ty)      -> WExpr.StructNew(ti, List.map lowerExpr fs, ty)
    | WExpr.StructGet(o, f, ty)        -> WExpr.StructGet(lowerExpr o, f, ty)
    | WExpr.StructSet(o, f, v)         -> WExpr.StructSet(lowerExpr o, f, lowerExpr v)
    | WExpr.Closure(n, caps, ty)       -> WExpr.Closure(n, List.map lowerExpr caps, ty)
    | WExpr.Break(l, Some v)           -> WExpr.Break(l, Some(lowerExpr v))
    | WExpr.Throw x                    -> WExpr.Throw(lowerExpr x)
    | WExpr.MemLoad(en, mt, a)         -> WExpr.MemLoad(en, mt, lowerExpr a)
    | WExpr.MemStore(en, mt, a, v)     -> WExpr.MemStore(en, mt, lowerExpr a, lowerExpr v)
    | WExpr.MemoryGrow p               -> WExpr.MemoryGrow(lowerExpr p)
    | WExpr.JoinPoint(l, ps, b, c, ty) -> WExpr.JoinPoint(l, ps, lowerExpr b, lowerExpr c, ty)
    | WExpr.JoinApply(l, args, ty)     -> WExpr.JoinApply(l, List.map lowerExpr args, ty)
    | WExpr.CallVirtual(box, bi, vi, mi, fti, args, ty) ->
        WExpr.CallVirtual(lowerExpr box, bi, vi, mi, fti, List.map lowerExpr args, ty)
    | WExpr.TryCatch(b, catch, fin, ty) ->
        WExpr.TryCatch(lowerExpr b,
            catch |> Option.map (fun (ex, e) -> ex, lowerExpr e),
            fin   |> Option.map lowerExpr, ty)
    | leaf -> leaf

let lowerFunc   (f: WFuncDecl) : WFuncDecl = { f with Body = lowerExpr f.Body }
let lowerModule (wmod: WModule) : WModule   = { wmod with Functions = List.map lowerFunc wmod.Functions }