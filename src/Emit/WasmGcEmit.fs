/// WasmGc Emit: Lower WExpr (high-level IR) → Instr list (flat WASM instructions).
/// This phase resolves names to indices, lowers control flow, and produces
/// a WasmModule ready for binary encoding.
module Fable.Transforms.WasmGc.WasmGcEmit

open Fable.AST.WasmGc

// ─────────────────────────────────────────────────────────────────
// Emitter Context — tracks index assignments
// ─────────────────────────────────────────────────────────────────

type EmitCtx =
    {
        /// Function name → function index
        FuncIndex: Map<string, int>
        /// Type name → type index
        TypeIndex: Map<string, int>
        /// Local variable name → local index (params come first)
        LocalIndex: Map<string, int>
        /// Stack of block labels for br/continue
        LabelStack: string list
        /// Number of imported functions (offsets our func indices)
        ImportFuncCount: int
        /// Global variable name → global index
        GlobalIndex: Map<string, int>
        /// Type index → array element WType; used for packed-type (i16) array.get_s selection.
        ArrayElemTypes: Map<int, WType>
        /// Index of the generic F# exception tag (for throw/catch)
        ExceptionTagIdx: int
    }

    member this.GetFuncIdx(name: string) =
        match Map.tryFind name this.FuncIndex with
        | Some idx -> idx
        | None -> failwith $"Emitter: unknown function '{name}'"

    member this.GetLocalIdx(name: string) =
        match Map.tryFind name this.LocalIndex with
        | Some idx -> idx
        | None ->
            let keys = this.LocalIndex |> Map.toList |> List.map fst |> String.concat ", "
            failwith $"Emitter: unknown local '%s{name}' (available: %s{keys})"

    member this.GetTypeIdx(name: string) =
        match Map.tryFind name this.TypeIndex with
        | Some idx -> idx
        | None -> failwith $"Emitter: unknown type '{name}'"

    member this.PushLabel(label: string) =
        { this with LabelStack = label :: this.LabelStack }

    member this.GetLabelDepth(label: string) =
        match this.LabelStack |> List.tryFindIndex ((=) label) with
        | Some depth -> depth
        | None -> failwith $"Emitter: unknown label '{label}'"

// ─────────────────────────────────────────────────────────────────
// Type encoding helpers
// ─────────────────────────────────────────────────────────────────

let wtypeToBlockType (ty: WType) : BlockType =
    match ty with
    | WType.Void -> BlockType.Empty
    | WType.I32 -> BlockType.Val WType.I32
    | WType.I64 -> BlockType.Val WType.I64
    | WType.F32 -> BlockType.Val WType.F32
    | WType.F64 -> BlockType.Val WType.F64
    | WType.Ref(idx, nullable) -> BlockType.Val(WType.Ref(idx, nullable))
    | _ -> BlockType.Empty

// ─────────────────────────────────────────────────────────────────
// Expression emission
// ─────────────────────────────────────────────────────────────────

/// Emit WASM instructions for a WExpr.
/// Returns a flat list of instructions.
let rec emitExpr (ctx: EmitCtx) (expr: WExpr) : Instr list =
    match expr with
    // ── Constants ──────────────────────────────────────────
    | WExpr.Const c ->
        match c with
        | WConst.I32 n -> [Instr.I32Const n]
        | WConst.I64 n -> [Instr.I64Const n]
        | WConst.F32 f -> [Instr.F32Const f]
        | WConst.F64 f -> [Instr.F64Const f]
        | WConst.Null(WType.Ref(typeIdx, _)) -> [Instr.RefNull(HeapType.TypeIdx typeIdx)]
        | WConst.Null _ -> [Instr.RefNull HeapType.None_]
        | WConst.Unit -> [] // unit produces no value
        | WConst.String _ -> [Instr.I32Const 0] // TODO: string data section

    // ── Local/Global access ───────────────────────────────
    | WExpr.LocalGet(name, _) ->
        [Instr.LocalGet(ctx.GetLocalIdx name)]

    | WExpr.GlobalGet(name, _) ->
        match Map.tryFind name ctx.GlobalIndex with
        | Some idx -> [Instr.GlobalGet idx]
        | None ->
            eprintfn "[WasmGc] WARNING: unknown global '%s' in GlobalGet — emitting i32.const 0" name
            [Instr.I32Const 0]

    | WExpr.GlobalSet(name, value) ->
        let valueInstrs = emitExpr ctx value
        match Map.tryFind name ctx.GlobalIndex with
        | Some idx -> valueInstrs @ [Instr.GlobalSet idx]
        | None ->
            eprintfn "[WasmGc] WARNING: unknown global '%s' in GlobalSet — dropping store" name
            valueInstrs @ [Instr.Drop]

    // ── Let binding ───────────────────────────────────────
    | WExpr.Let(name, value, body) ->
        let valueInstrs = emitExpr ctx value
        let localIdx = ctx.GetLocalIdx name
        let bodyInstrs = emitExpr ctx body
        valueInstrs @ [Instr.LocalSet localIdx] @ bodyInstrs

    | WExpr.LetMut(name, value, body) ->
        // Same as Let — local is mutable by default in WASM
        let valueInstrs = emitExpr ctx value
        let localIdx = ctx.GetLocalIdx name
        let bodyInstrs = emitExpr ctx body
        valueInstrs @ [Instr.LocalSet localIdx] @ bodyInstrs

    // ── Assignment ────────────────────────────────────────
    | WExpr.Assign(name, value) ->
        let valueInstrs = emitExpr ctx value
        let localIdx = ctx.GetLocalIdx name
        valueInstrs @ [Instr.LocalSet localIdx]

    // ── Function calls ────────────────────────────────────
    | WExpr.Call(func, args, _) ->
        let argInstrs = args |> List.collect (emitExpr ctx)
        match Map.tryFind func ctx.FuncIndex with
        | Some funcIdx ->
            argInstrs @ [Instr.Call funcIdx]
        | None ->
            // Unknown function — emit unreachable for now
            argInstrs @ [Instr.Unreachable]

    | WExpr.CallIndirect(funcRef, args, _) ->
        // call_ref is not yet implemented in the binary emitter.
        // Emit args + funcRef for side-effects then trap so the developer sees
        // a runtime panic rather than a silent wrong-answer or stack corruption.
        eprintfn "[WasmGc] WARNING: WExpr.CallIndirect reached binary emitter — emitting unreachable trap. Use WExpr.TailCallRef for closure dispatch."
        let argInstrs = args |> List.collect (emitExpr ctx)
        let funcRefInstrs = emitExpr ctx funcRef
        argInstrs @ funcRefInstrs @ [Instr.Unreachable]

    // ── Tail calls ────────────────────────────────────────
    | WExpr.TailCall(func, args, _) ->
        // return_call: reuse current frame, tail-jump to the named function.
        // Emits: args... return_call funcIdx
        let argInstrs = args |> List.collect (emitExpr ctx)
        match Map.tryFind func ctx.FuncIndex with
        | Some funcIdx ->
            argInstrs @ [Instr.ReturnCall funcIdx]
        | None ->
            // Fallback: regular call + return if function not yet indexed
            argInstrs @ [Instr.Call 0; Instr.Return] // unreachable fallback

    | WExpr.TailCallRef(closure, args, funcTypeIdx, closureTypeIdx, _captureCount, _) ->
        // Same self-parameter pattern as ClosureApply but using return_call_ref.
        let closureInstrs = emitExpr ctx closure
        let argsInstrs = args |> List.collect (emitExpr ctx)
        let tmpIdx = ctx.GetLocalIdx("$clo_apply_tmp")
        let castInstr =
            if closureTypeIdx > 0 then
                let rt = { Nullable = false; HeapType = HeapType.TypeIdx closureTypeIdx }
                [Instr.RefCast rt]
            else []
        closureInstrs
        @ castInstr
        @ [Instr.LocalTee tmpIdx; Instr.Drop]
        @ [Instr.LocalGet tmpIdx]                // push $self (first arg)
        @ argsInstrs
        @ [Instr.LocalGet tmpIdx]
        @ castInstr
        @ [Instr.StructGet(closureTypeIdx, 0); Instr.ReturnCallRef funcTypeIdx]

    | WExpr.CallVirtual(box, boxTypeIdx, vtableTypeIdx, methodIdx, funcTypeIdx, args, _) ->
        // Vtable dispatch — correct call_ref stack order: [self, args..., funcref]
        // box is always a LocalGet (boxing result is always immediately let-bound),
        // so evaluating it twice is safe and avoids a typed-tmp local.
        //   box.self               → first arg (eqref)
        //   args...
        //   box.vtable.method_N    → funcref (must be on TOP for call_ref)
        //   call_ref $funcTypeIdx
        let boxInstrs = emitExpr ctx box
        let argsInstrs = args |> List.collect (emitExpr ctx)
        boxInstrs @ [Instr.StructGet(boxTypeIdx, 1)]   // self (eqref) — first arg
        @ argsInstrs
        @ boxInstrs @ [Instr.StructGet(boxTypeIdx, 0); Instr.StructGet(vtableTypeIdx, methodIdx)]  // funcref on top
        @ [Instr.CallRef funcTypeIdx]

    // ── Struct operations ─────────────────────────────────
    | WExpr.StructNew(typeIdx, fields, _) ->
        let fieldInstrs = fields |> List.collect (emitExpr ctx)
        fieldInstrs @ [Instr.StructNew typeIdx]

    | WExpr.StructGet(obj, fieldIdx, _) ->
        let objInstrs = emitExpr ctx obj
        // Resolve struct type index from the obj's WType.Ref
        let typeIdx =
            match exprResultType obj with
            | WType.Ref(idx, _) -> idx
            | _ -> 0
        objInstrs @ [Instr.StructGet(typeIdx, fieldIdx)]

    | WExpr.StructSet(obj, fieldIdx, value) ->
        let objInstrs = emitExpr ctx obj
        let valueInstrs = emitExpr ctx value
        let typeIdx =
            match exprResultType obj with
            | WType.Ref(idx, _) -> idx
            | _ -> 0
        objInstrs @ valueInstrs @ [Instr.StructSet(typeIdx, fieldIdx)]

    // ── Array operations ──────────────────────────────────
    | WExpr.ArrayNew(typeIdx, size, init, _) ->
        let initInstrs = emitExpr ctx init
        let sizeInstrs = emitExpr ctx size
        initInstrs @ sizeInstrs @ [Instr.ArrayNew typeIdx]

    | WExpr.ArrayNewFixed(typeIdx, elems, _) ->
        let elemInstrs = elems |> List.collect (emitExpr ctx)
        elemInstrs @ [Instr.ArrayNewFixed(typeIdx, List.length elems)]

    | WExpr.ArrayGet(arr, idx, _) ->
        let arrInstrs = emitExpr ctx arr
        let idxInstrs = emitExpr ctx idx
        let typeIdx =
            match exprResultType arr with
            | WType.Ref(ti, _) -> ti
            | _ -> 0
        let getInstr =
            match Map.tryFind typeIdx ctx.ArrayElemTypes with
            | Some WType.I16 -> Instr.ArrayGetS typeIdx
            | _              -> Instr.ArrayGet typeIdx
        arrInstrs @ idxInstrs @ [getInstr]

    | WExpr.ArraySet(arr, idx, value) ->
        let arrInstrs = emitExpr ctx arr
        let idxInstrs = emitExpr ctx idx
        let valueInstrs = emitExpr ctx value
        let typeIdx =
            match exprResultType arr with
            | WType.Ref(ti, _) -> ti
            | _ -> 0
        arrInstrs @ idxInstrs @ valueInstrs @ [Instr.ArraySet typeIdx]

    | WExpr.ArrayLen(arr) ->
        let arrInstrs = emitExpr ctx arr
        arrInstrs @ [Instr.ArrayLen]

    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        // array.copy pops: dst, dst_offset, src, src_offset, length (dst at bottom, length at top)
        let typeIdx =
            match exprResultType dst with
            | WType.Ref(ti, _) -> ti
            | _ -> 0
        emitExpr ctx dst
        @ emitExpr ctx dstOff
        @ emitExpr ctx src
        @ emitExpr ctx srcOff
        @ emitExpr ctx len
        @ [Instr.ArrayCopy(typeIdx, typeIdx)]

    // ── Control flow ──────────────────────────────────────
    | WExpr.If(cond, then_, else_, ty) ->
        let condInstrs = emitExpr ctx cond
        let bt = wtypeToBlockType ty
        // Push a phantom label so that Br-depth counting sees the If block
        // (WASM If is a labeled structured block; Br 0 inside it exits the If,
        //  Br 1 would reach the enclosing block, etc.)
        let ctx' = ctx.PushLabel("$if")
        let thenInstrs = emitExpr ctx' then_
        let elseInstrs = emitExpr ctx' else_
        condInstrs @ [Instr.If(bt, thenInstrs, elseInstrs)]

    | WExpr.Loop(label, body, ty) ->
        let bt = wtypeToBlockType ty
        let ctx' = ctx.PushLabel(label)
        let bodyInstrs = emitExpr ctx' body
        [Instr.Loop(bt, bodyInstrs)]

    | WExpr.Block(label, body, ty) ->
        let bt = wtypeToBlockType ty
        let ctx' = ctx.PushLabel(label)
        let bodyInstrs = emitExpr ctx' body
        [Instr.Block(bt, bodyInstrs)]

    | WExpr.Break(label, value) ->
        let depth = ctx.GetLabelDepth label
        let valueInstrs =
            match value with
            | Some v -> emitExpr ctx v
            | None -> []
        valueInstrs @ [Instr.Br depth]

    | WExpr.Continue(label, _args) ->
        let depth = ctx.GetLabelDepth label
        [Instr.Br depth]

    | WExpr.Return(value) ->
        let valueInstrs =
            match value with
            | Some v -> emitExpr ctx v
            | None -> []
        valueInstrs @ [Instr.Return]

    | WExpr.Sequence exprs ->
        // Emit each expression; drop intermediate values except the last
        match exprs with
        | [] -> []
        | [single] -> emitExpr ctx single
        | _ ->
            let allButLast = exprs |> List.take (List.length exprs - 1)
            let last = exprs |> List.last
            let intermediateInstrs =
                allButLast
                |> List.collect (fun e ->
                    let instrs = emitExpr ctx e
                    // Drop the result if it produces a value
                    match exprResultType e with
                    | WType.Void -> instrs
                    | _ -> instrs @ [Instr.Drop]
                )
            intermediateInstrs @ emitExpr ctx last

    | WExpr.Nop -> []

    // ── Join points ───────────────────────────────────────
    | WExpr.JoinPoint(_label, _parms, _body, cont, _ty) ->
        // For Phase 1, we inline join points into blocks
        // The DecisionTreeSuccess → JoinApply dispatches to the right target
        // For simplicity, emit the continuation which contains JoinApply nodes
        emitExpr ctx cont

    | WExpr.JoinApply(label, args, _ty) ->
        // This is handled by decision tree lowering — see transformDecisionTree
        // For now, inline: emit args, emit the target body
        args |> List.collect (emitExpr ctx)

    // ── Pattern matching ──────────────────────────────────
    | WExpr.SwitchInt(scrutinee, cases, default_, ty) ->
        // Lower to nested if/else for now (br_table optimization later)
        let scrInstrs = emitExpr ctx scrutinee
        let bt = wtypeToBlockType ty
        let rec buildChain remaining =
            match remaining with
            | [] -> emitExpr ctx default_
            | (value, body) :: rest ->
                let bodyInstrs = emitExpr ctx body
                let restInstrs = buildChain rest
                // if (scrutinee == value) then body else rest
                [Instr.LocalGet(ctx.GetLocalIdx "$switch_tmp")]
                @ [Instr.I32Const value; Instr.I32Eq]
                @ [Instr.If(bt, bodyInstrs, restInstrs)]
        // Store scrutinee in a temp local, then chain comparisons
        scrInstrs @ [Instr.LocalSet(ctx.GetLocalIdx "$switch_tmp")]
        @ buildChain cases

    | WExpr.TagOf(obj) ->
        let objInstrs = emitExpr ctx obj
        match exprResultType obj with
        | WType.Ref(typeIdx, _) ->
            // Data-carrying DU: tag is stored in field 0 of the base struct
            objInstrs @ [Instr.StructGet(typeIdx, 0)]
        | _ ->
            // Enum-like DU: the i32 value IS the tag, pass through
            objInstrs

    | WExpr.Cast(obj, targetType) ->
        let objInstrs = emitExpr ctx obj
        match targetType with
        | WType.Ref(typeIdx, nullable) ->
            // Downcast from base DU type to a specific case subtype
            let rt = { Nullable = nullable; HeapType = HeapType.TypeIdx typeIdx }
            objInstrs @ [Instr.RefCast rt]
        | _ ->
            // No-op for non-ref casts (e.g., TypeCast on primitives)
            objInstrs

    | WExpr.RefIsNull(obj) ->
        let objInstrs = emitExpr ctx obj
        objInstrs @ [Instr.RefIsNull]

    | WExpr.RefTest(obj, targetType) ->
        let objInstrs = emitExpr ctx obj
        match targetType with
        | WType.Ref(typeIdx, nullable) ->
            let rt = { Nullable = nullable; HeapType = HeapType.TypeIdx typeIdx }
            objInstrs @ [Instr.RefTest rt]
        | _ ->
            // Non-ref fallback: drop the value and push 1 (always matches)
            objInstrs @ [Instr.Drop; Instr.I32Const 1]

    // ── Closures ──────────────────────────────────────────
    | WExpr.Closure(funcName, captures, closureRefType) ->
        // struct.new $closureTypeIdx (ref.func $funcName, cap0, cap1, ...)
        let closureTypeIdx =
            match closureRefType with
            | WType.Ref(idx, _) -> idx
            | _ -> failwith $"Closure type must be a Ref, got {closureRefType}"
        let funcIdx = ctx.GetFuncIdx(funcName)
        let captureInstrs = captures |> List.collect (emitExpr ctx)
        [Instr.RefFunc funcIdx] @ captureInstrs @ [Instr.StructNew closureTypeIdx]

    /// ref.func $funcName — used in vtable global initializers.
    | WExpr.FuncRef funcName ->
        let funcIdx = ctx.GetFuncIdx(funcName)
        [Instr.RefFunc funcIdx]

    | WExpr.ClosureApply(closure, args, funcTypeIdx, closureTypeIdx, _captureCount, _) ->
        // Self-parameter calling convention (Sprint 25b):
        //   1. Eval closure → cast to ClosureBase → save in $clo_apply_tmp (type ref $AnyFn)
        //   2. Push $clo_apply_tmp as $self (first arg, type ref $AnyFn — functype requires this)
        //   3. Push remaining args
        //   4. Push $clo_apply_tmp → re-cast to ClosureBase → struct.get 0 → code ptr
        //   5. call_ref $funcTypeIdx (where funcTypeIdx = (ref $AnyFn, arg1...) → R)
        //
        // Two ref.casts of the same value cost negligible overhead and are valid because
        // $clo_apply_tmp (type ref $AnyFn) holds a value that is actually ref $ClosureBase_X.
        let closureInstrs = emitExpr ctx closure
        let argsInstrs = args |> List.collect (emitExpr ctx)
        let tmpIdx = ctx.GetLocalIdx("$clo_apply_tmp")
        let castInstr =
            if closureTypeIdx > 0 then
                let rt = { Nullable = false; HeapType = HeapType.TypeIdx closureTypeIdx }
                [Instr.RefCast rt]
            else []
        closureInstrs
        @ castInstr                              // cast to ClosureBase (for struct.get later)
        @ [Instr.LocalTee tmpIdx; Instr.Drop]    // save (stored as ref $AnyFn in local)
        @ [Instr.LocalGet tmpIdx]                // push $self (first arg: ref $AnyFn)
        @ argsInstrs                             // push other args
        @ [Instr.LocalGet tmpIdx]                // push for struct.get
        @ castInstr                              // cast to ClosureBase again
        @ [Instr.StructGet(closureTypeIdx, 0); Instr.CallRef funcTypeIdx]

    // ── Numeric operations ────────────────────────────────
    | WExpr.Unary(op, operand, ty) ->
        let operandInstrs = emitExpr ctx operand
        match op, ty with
        // i32 negation: (0 - x)
        | WUnaryOp.Neg, WType.I32 ->
            [Instr.I32Const 0] @ operandInstrs @ [Instr.I32Sub]
        // i64 negation: (0 - x)
        | WUnaryOp.Neg, WType.I64 ->
            [Instr.I64Const 0L] @ operandInstrs @ [Instr.I64Sub]
        // bitwise NOT i32: x XOR -1
        | WUnaryOp.Not, WType.I32 ->
            operandInstrs @ [Instr.I32Const -1; Instr.I32Xor]
        // bitwise NOT i64: x XOR -1L
        | WUnaryOp.Not, WType.I64 ->
            operandInstrs @ [Instr.I64Const -1L; Instr.I64Xor]
        | _ ->
            let opInstr = emitUnaryOp op ty
            operandInstrs @ [opInstr]

    | WExpr.Binary(op, left, right, ty) ->
        let leftInstrs = emitExpr ctx left
        let rightInstrs = emitExpr ctx right
        let opInstr = emitBinaryOp op ty
        leftInstrs @ rightInstrs @ [opInstr]

    | WExpr.Compare(op, left, right) ->
        let leftInstrs = emitExpr ctx left
        let rightInstrs = emitExpr ctx right
        // Determine numeric type from left operand
        let numTy = exprResultType left
        // WebAssembly has no ref.ne; use ref.eq + i32.eqz
        match op, numTy with
        | WCompareOp.Ne, WType.Ref _ ->
            leftInstrs @ rightInstrs @ [Instr.RefEq; Instr.I32Eqz]
        | _ ->
            leftInstrs @ rightInstrs @ [emitCompareOp op numTy]

    // ── Error handling ────────────────────────────────────
    | WExpr.TryCatch(body, catchOpt, _finally, ty) ->
        // Encode as:
        //   (block $outer (result T)
        //     (block $catch  ;; catch_all branches here (exits this block)
        //       (try_table (result T) [(catch_all 0)]
        //         body
        //       )               ;; T on stack (normal path)
        //       br 1            ;; break to $outer with T (skip handler)
        //     )                 ;; $catch exited — exception was caught
        //     handler           ;; produces T
        //   )
        let resultBt = wtypeToBlockType ty
        let bodyInstrs = emitExpr ctx body
        let handlerInstrs =
            match catchOpt with
            | Some (_, handlerExpr) -> emitExpr ctx handlerExpr
            // catch_all has no payload, so the catch variable binding is zero-initialized
            | None -> []
        [Instr.Block(resultBt,
            [Instr.Block(BlockType.Empty,
                [Instr.TryTable(resultBt, [Catch.All 0], bodyInstrs)]
                @ [Instr.Br 1])]
            @ handlerInstrs)]

    | WExpr.Throw(exnExpr) ->
        // Emit the exception expression (for side effects), then drop the result
        // and throw using the generic F# exception tag (tag index = importTagCount + 0).
        let exnInstrs = emitExpr ctx exnExpr
        let exnTy = exprResultType exnExpr
        let dropInstrs = if exnTy <> WType.Void then [Instr.Drop] else []
        exnInstrs @ dropInstrs @ [Instr.Throw ctx.ExceptionTagIdx]

// ─────────────────────────────────────────────────────────────────
// Determine result type of a WExpr (for drop decisions)
// ─────────────────────────────────────────────────────────────────

/// Canonical WExpr type query — delegates to the shared WasmGcTypes.exprWType.
/// Sprint 2: eliminated the duplicate implementation that existed here.
and exprResultType (expr: WExpr) : WType = WasmGcTypes.exprWType expr

// ─────────────────────────────────────────────────────────────────
// Numeric operation instruction selection
// ─────────────────────────────────────────────────────────────────

and emitUnaryOp (op: WUnaryOp) (ty: WType) : Instr =
    match op, ty with
    | WUnaryOp.Neg, WType.I32 ->
        // negate i32: 0 - x (we emit this as a sequence outside)
        // For simplicity, just emit i32.const 0; i32.sub is handled at call site
        Instr.I32Sub // caller must emit (i32.const 0) before operand
    | WUnaryOp.Neg, WType.F64 -> Instr.F64Neg
    | WUnaryOp.Neg, WType.F32 -> Instr.F32Neg
    | WUnaryOp.Abs, WType.F64 -> Instr.F64Abs
    | WUnaryOp.Abs, WType.F32 -> Instr.F32Abs
    | WUnaryOp.Sqrt, WType.F64 -> Instr.F64Sqrt
    | WUnaryOp.Sqrt, WType.F32 -> Instr.F32Sqrt
    | WUnaryOp.Ceil, WType.F64 -> Instr.F64Ceil
    | WUnaryOp.Ceil, WType.F32 -> Instr.F32Ceil
    | WUnaryOp.Floor, WType.F64 -> Instr.F64Floor
    | WUnaryOp.Floor, WType.F32 -> Instr.F32Floor
    | WUnaryOp.Trunc, WType.F64 -> Instr.F64Trunc
    | WUnaryOp.Trunc, WType.F32 -> Instr.F32Trunc
    | WUnaryOp.Nearest, WType.F64 -> Instr.F64Nearest
    | WUnaryOp.Nearest, WType.F32 -> Instr.F32Nearest
    | WUnaryOp.Not, WType.I32 -> Instr.I32Eqz
    | WUnaryOp.Eqz, WType.I32 -> Instr.I32Eqz
    | WUnaryOp.Eqz, WType.I64 -> Instr.I64Eqz
    | WUnaryOp.Clz, WType.I32 -> Instr.I32Clz
    | WUnaryOp.Ctz, WType.I32 -> Instr.I32Ctz
    | WUnaryOp.Popcnt, WType.I32 -> Instr.I32Popcnt
    | WUnaryOp.WrapI64, _ -> Instr.I32WrapI64
    | WUnaryOp.ExtendI32S, _ -> Instr.I64ExtendI32S
    | WUnaryOp.ExtendI32U, _ -> Instr.I64ExtendI32U
    | WUnaryOp.TruncF64S, WType.I32 -> Instr.I32TruncF64S
    | WUnaryOp.TruncF64S, WType.I64 -> Instr.I64TruncF64S
    | WUnaryOp.TruncF32S, WType.I32 -> Instr.I32TruncF32S
    | WUnaryOp.ConvertI32S, WType.F64 -> Instr.F64ConvertI32S
    | WUnaryOp.ConvertI32S, WType.F32 -> Instr.F32ConvertI32S
    | WUnaryOp.ConvertI64S, WType.F64 -> Instr.F64ConvertI64S
    | WUnaryOp.ConvertI64S, WType.F32 -> Instr.F32ConvertI64S
    | WUnaryOp.PromoteF32, _ -> Instr.F64PromoteF32
    | WUnaryOp.DemoteF64, _ -> Instr.F32DemoteF64
    | _ -> Instr.Unreachable // fallback

and emitBinaryOp (op: WBinaryOp) (ty: WType) : Instr =
    match op, ty with
    // i32 operations
    | WBinaryOp.Add, WType.I32 -> Instr.I32Add
    | WBinaryOp.Sub, WType.I32 -> Instr.I32Sub
    | WBinaryOp.Mul, WType.I32 -> Instr.I32Mul
    | WBinaryOp.DivS, WType.I32 -> Instr.I32DivS
    | WBinaryOp.DivU, WType.I32 -> Instr.I32DivU
    | WBinaryOp.RemS, WType.I32 -> Instr.I32RemS
    | WBinaryOp.RemU, WType.I32 -> Instr.I32RemU
    | WBinaryOp.And, WType.I32 -> Instr.I32And
    | WBinaryOp.Or, WType.I32 -> Instr.I32Or
    | WBinaryOp.Xor, WType.I32 -> Instr.I32Xor
    | WBinaryOp.Shl, WType.I32 -> Instr.I32Shl
    | WBinaryOp.ShrS, WType.I32 -> Instr.I32ShrS
    | WBinaryOp.ShrU, WType.I32 -> Instr.I32ShrU
    | WBinaryOp.Rotl, WType.I32 -> Instr.I32Rotl
    | WBinaryOp.Rotr, WType.I32 -> Instr.I32Rotr
    // i64 operations
    | WBinaryOp.Add, WType.I64 -> Instr.I64Add
    | WBinaryOp.Sub, WType.I64 -> Instr.I64Sub
    | WBinaryOp.Mul, WType.I64 -> Instr.I64Mul
    | WBinaryOp.DivS, WType.I64 -> Instr.I64DivS
    | WBinaryOp.DivU, WType.I64 -> Instr.I64DivU
    | WBinaryOp.RemS, WType.I64 -> Instr.I64RemS
    | WBinaryOp.RemU, WType.I64 -> Instr.I64RemU
    | WBinaryOp.And, WType.I64 -> Instr.I64And
    | WBinaryOp.Or, WType.I64 -> Instr.I64Or
    | WBinaryOp.Xor, WType.I64 -> Instr.I64Xor
    | WBinaryOp.Shl, WType.I64 -> Instr.I64Shl
    | WBinaryOp.ShrS, WType.I64 -> Instr.I64ShrS
    | WBinaryOp.ShrU, WType.I64 -> Instr.I64ShrU
    | WBinaryOp.Rotl, WType.I64 -> Instr.I64Rotl
    | WBinaryOp.Rotr, WType.I64 -> Instr.I64Rotr
    // f32 operations
    | WBinaryOp.Add, WType.F32 -> Instr.F32Add
    | WBinaryOp.Sub, WType.F32 -> Instr.F32Sub
    | WBinaryOp.Mul, WType.F32 -> Instr.F32Mul
    | WBinaryOp.DivS, WType.F32 -> Instr.F32Div
    | WBinaryOp.DivU, WType.F32 -> Instr.F32Div
    // f64 operations
    | WBinaryOp.Add, WType.F64 -> Instr.F64Add
    | WBinaryOp.Sub, WType.F64 -> Instr.F64Sub
    | WBinaryOp.Mul, WType.F64 -> Instr.F64Mul
    | WBinaryOp.DivS, WType.F64 -> Instr.F64Div
    | WBinaryOp.DivU, WType.F64 -> Instr.F64Div
    // f32/f64 min, max, copysign
    | WBinaryOp.Min, WType.F32 -> Instr.F32Min
    | WBinaryOp.Max, WType.F32 -> Instr.F32Max
    | WBinaryOp.CopySign, WType.F32 -> Instr.F32CopySign
    | WBinaryOp.Min, WType.F64 -> Instr.F64Min
    | WBinaryOp.Max, WType.F64 -> Instr.F64Max
    | WBinaryOp.CopySign, WType.F64 -> Instr.F64CopySign
    | _ -> Instr.Unreachable // fallback

and emitCompareOp (op: WCompareOp) (ty: WType) : Instr =
    match op, ty with
    | WCompareOp.Eq, WType.I32 -> Instr.I32Eq
    | WCompareOp.Ne, WType.I32 -> Instr.I32Ne
    | WCompareOp.LtS, WType.I32 -> Instr.I32LtS
    | WCompareOp.LtU, WType.I32 -> Instr.I32LtU
    | WCompareOp.GtS, WType.I32 -> Instr.I32GtS
    | WCompareOp.GtU, WType.I32 -> Instr.I32GtU
    | WCompareOp.LeS, WType.I32 -> Instr.I32LeS
    | WCompareOp.LeU, WType.I32 -> Instr.I32LeU
    | WCompareOp.GeS, WType.I32 -> Instr.I32GeS
    | WCompareOp.GeU, WType.I32 -> Instr.I32GeU
    | WCompareOp.Eq, WType.I64 -> Instr.I64Eq
    | WCompareOp.Ne, WType.I64 -> Instr.I64Ne
    | WCompareOp.LtS, WType.I64 -> Instr.I64LtS
    | WCompareOp.GtS, WType.I64 -> Instr.I64GtS
    | WCompareOp.LeS, WType.I64 -> Instr.I64LeS
    | WCompareOp.GeS, WType.I64 -> Instr.I64GeS
    | WCompareOp.Eq, WType.F32 -> Instr.F32Eq
    | WCompareOp.Ne, WType.F32 -> Instr.F32Ne
    | WCompareOp.LtS, WType.F32 -> Instr.F32Lt
    | WCompareOp.GtS, WType.F32 -> Instr.F32Gt
    | WCompareOp.LeS, WType.F32 -> Instr.F32Le
    | WCompareOp.GeS, WType.F32 -> Instr.F32Ge
    | WCompareOp.Eq, WType.F64 -> Instr.F64Eq
    | WCompareOp.Ne, WType.F64 -> Instr.F64Ne
    | WCompareOp.LtS, WType.F64 -> Instr.F64Lt
    | WCompareOp.GtS, WType.F64 -> Instr.F64Gt
    | WCompareOp.LeS, WType.F64 -> Instr.F64Le
    | WCompareOp.GeS, WType.F64 -> Instr.F64Ge
    | WCompareOp.RefEq, _ -> Instr.RefEq
    | WCompareOp.Eq, WType.Ref _ -> Instr.RefEq
    // Ne on Ref — handled in emitExpr as [RefEq; I32Eqz]; should not reach here
    | WCompareOp.Ne, WType.Ref _ -> Instr.RefEq
    | _ -> Instr.I32Eq // fallback

// ─────────────────────────────────────────────────────────────────
// WASM value type encoding byte (for type section)
// ─────────────────────────────────────────────────────────────────

let valTypeByte (ty: WType) : byte =
    match ty with
    | WType.I32 -> 0x7Fuy
    | WType.I64 -> 0x7Euy
    | WType.F32 -> 0x7Duy
    | WType.F64 -> 0x7Cuy
    | _ -> 0x7Fuy // fallback to i32

// ─────────────────────────────────────────────────────────────────
// Lowered WASM function — ready for binary encoding
// ─────────────────────────────────────────────────────────────────

type WasmFunc =
    {
        /// Param types
        ParamTypes: WType list
        /// Result types
        ResultTypes: WType list
        /// Local types (excluding params)
        LocalTypes: WType list
        /// Flat instruction list
        Body: Instr list
        /// Original name (for debug/name section)
        Name: string
    }

/// A lowered global variable ready for binary encoding.
type WasmGlobal =
    {
        /// Value type
        Type: WType
        /// true = mutable global
        Mutable: bool
        /// Constant initializer expression (must be a WASM constant expr)
        Init: Instr list
        /// Debug name
        Name: string
    }

type WasmModule =
    {
        /// Struct/array/GC type definitions (WASM GC type section, first in order)
        StructTypes: WTypeDeclEntry list
        /// Type section entries — func types: (params, results)
        FuncTypes: (WType list * WType list) list
        /// Import entries
        Imports: WImport list
        /// Type-section index for each import (parallel to Imports list)
        ImportTypeIndices: int list
        /// Function-section type index for each non-import function (parallel to Functions list)
        FuncTypeIndices: int list
        /// Lowered function bodies
        Functions: WasmFunc list
        /// Lowered global variables
        Globals: WasmGlobal list
        /// Export entries
        Exports: WExport list
        DataSegments: WDataSegment list
        /// Start function index
        StartFunc: int option
        /// Function indices declared via ref.func (must appear in declarative elem segment)
        DeclaredFuncRefs: int list
        /// Module-level exception tag declarations: list of (func type index for tag params)
        Tags: int list
    }

// ─────────────────────────────────────────────────────────────────
// Module-level emission: WModule → WasmModule
// ─────────────────────────────────────────────────────────────────

/// Lower a high-level WModule to a WasmModule ready for binary encoding.
let emitModule (wmod: WModule) : WasmModule =
    // 0. Struct types occupy the first N type indices
    let structTypes = wmod.Types
    let structTypeCount = structTypes.Length

    // 1. Collect all function types (deduplicated), offset by structTypeCount
    let funcTypes = ResizeArray<WType list * WType list>()
    let funcTypeMap = System.Collections.Generic.Dictionary<string, int>()

    // Pre-populate funcTypeMap with WTypeDef.Func entries already in wmod.Types.
    // This ensures that closure func-type indices (assigned during translation) are
    // consistent with the indices that emitModule would assign to function signatures.
    for i in 0 .. structTypes.Length - 1 do
        match structTypes.[i].Def with
        | WTypeDef.Func(parms, result) ->
            let paramTypes = parms |> List.filter (fun t -> t <> WType.Void)
            let resultTypes = match result with | WType.Void -> [] | t -> [t]
            let key = sprintf "%A->%A" paramTypes resultTypes
            if not (funcTypeMap.ContainsKey(key)) then
                funcTypeMap.[key] <- i
        | _ -> ()

    let getOrAddFuncType (paramTypes: WType list) (resultTypes: WType list) =
        let key = sprintf "%A->%A" paramTypes resultTypes
        match funcTypeMap.TryGetValue(key) with
        | true, idx -> idx
        | false, _ ->
            let idx = funcTypes.Count + structTypeCount
            funcTypes.Add((paramTypes, resultTypes))
            funcTypeMap.[key] <- idx
            idx

    // 2. Build function index map (imports first, then our functions)
    let importFuncCount = wmod.Imports |> List.length
    let funcIndex =
        // Imports occupy indices 0..N-1; regular functions start at N.
        // CallName is the internal identifier (may differ from external Name for FFI imports).
        (wmod.Imports |> List.mapi (fun i imp ->
            let key = if imp.CallName <> "" then imp.CallName else imp.Name
            key, i))
        @ (wmod.Functions |> List.mapi (fun i f -> f.Name, importFuncCount + i))
        |> Map.ofList

    // 3. Build type index map
    let typeIndex =
        wmod.Types
        |> List.mapi (fun i t -> t.Name, i)
        |> Map.ofList

    // 3b. Register import function types and record their type indices
    let importTypeIndices =
        wmod.Imports
        |> List.map (fun imp ->
            match imp.Desc with
            | ImportFunc(paramTys, resultTy) ->
                let paramTypes = paramTys |> List.filter (fun t -> t <> WType.Void)
                let resultTypes = match resultTy with | WType.Void -> [] | t -> [t]
                getOrAddFuncType paramTypes resultTypes
            | ImportTag paramTys ->
                // Tag type is a function type with params only (no results)
                let paramTypes = paramTys |> List.filter (fun t -> t <> WType.Void)
                getOrAddFuncType paramTypes []
            | _ -> 0  // non-func/non-tag imports don't need type idx here
        )

    // 3c. Build global index map
    let globalIndex =
        wmod.Globals
        |> List.mapi (fun i g -> g.Name, i)
        |> Map.ofList

    // 3d. Register tag types and compute tag indices.
    // Imported tags come first (counted from imports), then local tags.
    let importTagCount =
        wmod.Imports |> List.sumBy (fun imp -> match imp.Desc with | ImportTag _ -> 1 | _ -> 0)
    let tagTypeIndices =
        wmod.Tags
        |> List.map (fun tag ->
            let paramTypes = tag.ParamTypes |> List.filter (fun t -> t <> WType.Void)
            getOrAddFuncType paramTypes [])
    // The first local tag index starts after imported tags
    let exceptionTagIdx = importTagCount  // index of the first local tag (the generic F# exn tag)

    // 3d. Build array element type map: type index → element WType (for packed i16 read selection)
    let arrayElemTypes =
        wmod.Types
        |> List.mapi (fun i td ->
            match td.Def with
            | WTypeDef.Array(elemTy, _) -> Some(i, elemTy)
            | _                         -> None)
        |> List.choose id
        |> Map.ofList

    // 4. Register all function types
    let funcTypeIndices =
        wmod.Functions
        |> List.map (fun f ->
            // Filter Void params — WASM has no void value type // TODO: for real? is this true?
            let paramTypes = f.Params |> List.map snd |> List.filter (fun t -> t <> WType.Void)
            let resultTypes =
                match f.Result with
                | WType.Void -> []
                | t -> [t]
            getOrAddFuncType paramTypes resultTypes
        )

    // 5. Emit each function body
    let wasmFuncs =
        wmod.Functions
        |> List.map (fun f ->
            let paramNames = f.Params |> List.map fst |> Set.ofList
            // Build local index map: params first, then declared locals
            let paramLocals = f.Params |> List.mapi (fun i (name, _) -> name, i)
            let paramCount = List.length f.Params
            let extraLocals =
                f.Locals
                |> List.filter (fun (name, _) -> not (Set.contains name paramNames))
                |> List.mapi (fun i (name, ty) -> (name, paramCount + i), ty)

            let localIndex =
                (paramLocals @ (extraLocals |> List.map fst))
                |> Map.ofList

            let localTypes = extraLocals |> List.map snd

            let ctx : EmitCtx =
                {
                    FuncIndex = funcIndex
                    TypeIndex = typeIndex
                    LocalIndex = localIndex
                    LabelStack = []
                    ImportFuncCount = importFuncCount
                    GlobalIndex = globalIndex
                    ArrayElemTypes = arrayElemTypes
                    ExceptionTagIdx = exceptionTagIdx
                }

            try
                let bodyInstrs = emitExpr ctx f.Body
                let resultTypes =
                    match f.Result with
                    | WType.Void -> []
                    | t -> [t]

                {
                    ParamTypes = f.Params |> List.map snd
                    ResultTypes = resultTypes
                    LocalTypes = localTypes
                    Body = bodyInstrs
                    Name = f.Name
                }
            with ex ->
                failwith $"Emitter error in function '%s{f.Name}': %s{ex.Message}"
        )

    // 5b. Lower globals — emit init expressions (must be constant exprs)
    let wasmGlobals =
        wmod.Globals
        |> List.map (fun g ->
            let initCtx : EmitCtx =
                {
                    FuncIndex = funcIndex
                    TypeIndex = typeIndex
                    LocalIndex = Map.empty
                    LabelStack = []
                    ImportFuncCount = importFuncCount
                    GlobalIndex = globalIndex
                    ArrayElemTypes = arrayElemTypes
                    ExceptionTagIdx = exceptionTagIdx
                }
            let initInstrs = emitExpr initCtx g.Init
            {
                Type = g.Type
                Mutable = g.Mutable
                Init = initInstrs
                Name = g.Name
            }
        )

    // 6. Rebuild exports with correct indices
    let exports =
        wmod.Exports
        |> List.map (fun e ->
            match e.Kind with
            | ExportFunc ->
                match Map.tryFind e.InternalName funcIndex with
                | Some idx -> { e with InternalName = string idx }
                | None -> e
            | _ -> e
        )

    // 7. Collect all func indices referenced by ref.func (needed for declarative elem segment)
    let rec collectRefFuncs (instrs: Instr list) : int list =
        instrs |> List.collect (fun instr ->
            match instr with
            | Instr.RefFunc idx -> [idx]
            | Instr.If(_, thenBody, elseBody) ->
                collectRefFuncs thenBody @ collectRefFuncs elseBody
            | Instr.Block(_, body) | Instr.Loop(_, body) ->
                collectRefFuncs body
            | Instr.TryTable(_, _, body) ->
                collectRefFuncs body
            | _ -> [])

    let refFuncsFromFunctions =
        wasmFuncs
        |> List.collect (fun f -> collectRefFuncs f.Body)

    // Also collect ref.func from global init instructions (for vtable globals)
    let refFuncsFromGlobals =
        wasmGlobals
        |> List.collect (fun g -> collectRefFuncs g.Init)

    let declaredFuncRefs =
        (refFuncsFromFunctions @ refFuncsFromGlobals)
        |> List.distinct
        |> List.sort

    {
        StructTypes = structTypes
        FuncTypes = funcTypes |> Seq.toList
        Imports = wmod.Imports
        ImportTypeIndices = importTypeIndices
        FuncTypeIndices = funcTypeIndices
        Functions = wasmFuncs
        Globals = wasmGlobals
        Exports = exports
        DataSegments = wmod.DataSegments
        StartFunc = None
        DeclaredFuncRefs = declaredFuncRefs
        Tags = tagTypeIndices
    }
