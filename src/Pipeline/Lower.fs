/// Phase 4b: WExpr Lowering — HIR → LIR
///
/// Makes compiler-managed temporaries explicit Let-bound variables so that Emit is a
/// pure 1:1 WExpr→Instr serializer:
///
///   ClosureApply / TailCallRef  → Let($lo_clo_N, cast, CallRef(…))      (explicit calling convention)
///   SwitchInt                   → Let($lo_sw_N, scrut, if-chain)        (no br_table nesting subtleties)
///   TryCatch(_, _, Some fin)    → try/catch + explicit finalizer paths  (Emit never saw `fin`)
///
/// Pipeline position: AFTER Phase 4 (Normalize), BEFORE Phase 5 (Locals).
///
/// The traversal is `Traverse.rewrite`, i.e. it is exhaustive by construction.  The
/// previous hand-written recursion skipped `Return`, `Continue` and `CallRef` children, so
/// ClosureApply nodes below them reached the emitter un-lowered.
module WasmGc.Pipeline.Lower

open WasmGc.Core.AST
open WasmGc.Core.Traverse
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Fresh name generation
// ─────────────────────────────────────────────────────────────────

let private lowerCounter = ref 0
let private freshLow (tag: string) =
    let n = System.Threading.Interlocked.Increment(lowerCounter)
    sprintf "$lo_%s_%d" tag n

let private exnCarrier = "$fsharp_exn_carrier"

// ─────────────────────────────────────────────────────────────────
// Node lowering
// ─────────────────────────────────────────────────────────────────

/// ClosureApply / TailCallRef → Let(tmp, Cast(clo, ClosureBase), call_ref(code))
///
/// ABI: call_ref $fti (self :: args) (struct.get $ClosureBase 0 self).
/// `cti` MUST be a ClosureBase struct: index 0 is the field-less `$AnyFn`, where
/// `struct.get 0` cannot validate.  `Runtime.fixClosureApply` guarantees cti > 0 for
/// every node before this phase runs; a violation is a compiler bug, so fail loudly.
let private lowerClosureCall (tag: string) (mk: int * WExpr list * WExpr * WType -> WExpr)
                             (clo: WExpr) (args: WExpr list) (fti: int) (cti: int) (retTy: WType) =
    if cti <= 0 then
        failwithf "Lower: closure call (func type %d) has no ClosureBase type — Runtime.fixClosureApply was not applied" fti
    let tmp     = freshLow tag
    let baseTy  = WType.Ref(cti, false)
    let self    = WExpr.LocalGet(tmp, baseTy)
    let codePtr = WExpr.StructGet(self, 0, WType.Ref(fti, false))
    let realArgs = args |> List.filter (fun a -> exprWType a <> WType.Void)
    WExpr.Let(tmp, WExpr.Cast(clo, baseTy), mk (fti, self :: realArgs, codePtr, retTy))

/// SwitchInt → Let(tmp, scrut, if tmp == k0 then e0 else if tmp == k1 …  else default)
let private lowerSwitch (scrut: WExpr) (cases: (int * WExpr) list) (def: WExpr) (retTy: WType) =
    let tmp = freshLow "sw"
    let get = WExpr.LocalGet(tmp, WType.I32)
    let chain =
        List.foldBack
            (fun (k, body) rest ->
                WExpr.If(WExpr.Compare(WCompareOp.Eq, get, WExpr.Const(WConst.I32 k)), body, rest, retTy))
            cases def
    WExpr.Let(tmp, scrut, chain)

/// try body [with h] finally fin
///
///   let r = try (try body with h) with _ -> { let e = carrier; fin; carrier <- e; rethrow }
///   fin; r
///
/// The exception payload lives in a global, so it is saved around the finalizer (which may
/// itself throw and catch) and restored before rethrowing.
let private lowerTryFinally (body: WExpr) (catch: (string * WExpr) option) (fin: WExpr) (ty: WType) =
    let inner = match catch with Some _ -> WExpr.TryCatch(body, catch, None, ty) | None -> body
    let saved = freshLow "exn"
    let onExn =
        WExpr.Let(saved, WExpr.GlobalGet(exnCarrier, WType.AnyRef),
            WExpr.Sequence
                [ fin
                  WExpr.GlobalSet(exnCarrier, WExpr.LocalGet(saved, WType.AnyRef))
                  WExpr.Throw WExpr.Nop ])
    let guarded = WExpr.TryCatch(inner, Some("$lo_exn", onExn), None, ty)
    match ty with
    | WType.Void -> WExpr.Sequence [ guarded; fin ]
    | _ ->
        let res = freshLow "try"
        WExpr.Let(res, guarded, WExpr.Sequence [ fin; WExpr.LocalGet(res, ty) ])

let private lowerNode (e: WExpr) : WExpr option =
    match e with
    | WExpr.ClosureApply(clo, args, fti, cti, _, ret) ->
        Some(lowerClosureCall "clo" WExpr.CallRef clo args fti cti ret)
    | WExpr.TailCallRef(clo, args, fti, cti, _, ret) ->
        Some(lowerClosureCall "tail" WExpr.ReturnCallRef clo args fti cti ret)
    | WExpr.SwitchInt(s, cases, def, ret) -> Some(lowerSwitch s cases def ret)
    | WExpr.TryCatch(body, catch, Some fin, ty) -> Some(lowerTryFinally body catch fin ty)
    | _ -> None

let lowerExpr (e: WExpr) : WExpr = rewrite lowerNode e

let lowerFunc   (f: WFuncDecl) : WFuncDecl = { f with Body = lowerExpr f.Body }
let lowerModule (wmod: WModule) : WModule   = { wmod with Functions = List.map lowerFunc wmod.Functions }
