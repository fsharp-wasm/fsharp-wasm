/// TEIL 3: WExpr Query DSL.
///
/// Utilities for traversing, analyzing, and rewriting WExpr trees.
/// Used by Phase 6 (Validator) and Phase 7 (Optimizer) to query expression structure
/// without writing recursive boilerplate each time.
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

/// Return all immediate subexpressions of a WExpr.
/// Preserves structure — doesn't recurse further.
let children (expr: WExpr) : WExpr list =
    match expr with
    | WExpr.Let(_, value, body) | WExpr.LetMut(_, value, body) -> [value; body]
    | WExpr.If(cond, thenExpr, elseExpr, _) -> [cond; thenExpr; elseExpr]
    | WExpr.Sequence exprs -> exprs
    | WExpr.Block(_, body, _) | WExpr.Loop(_, body, _) -> [body]
    | WExpr.Call(_, args, _) | WExpr.CallIndirect(_, args, _) -> args
    | WExpr.ClosureApply(closure, args, _, _, _, _) | WExpr.TailCallRef(closure, args, _, _, _, _) ->
        closure :: args
    | WExpr.Binary(_, left, right, _) -> [left; right]
    | WExpr.Compare(_, left, right) -> [left; right]
    | WExpr.Unary(_, op, _) | WExpr.Cast(op, _) | WExpr.ArrayLen op
    | WExpr.RefIsNull op | WExpr.RefTest(op, _) | WExpr.TagOf op ->
        [op]
    | WExpr.Assign(_, value) | WExpr.GlobalSet(_, value) -> [value]
    | WExpr.JoinPoint(_, _, body, cont, _) -> [body; cont]
    | WExpr.JoinApply(_, args, _) -> args
    | WExpr.TryCatch(body, catch, fin, _) ->
        let catchExprs = catch |> Option.map snd |> Option.toList
        let finExprs = fin |> Option.toList
        body :: catchExprs @ finExprs
    | WExpr.StructNew(_, fields, _) | WExpr.ArrayNewFixed(_, fields, _) ->
        fields
    | WExpr.StructGet(obj, _, _) -> [obj]
    | WExpr.StructSet(obj, _, value) -> [obj; value]
    | WExpr.ArrayGet(arr, idx, _) -> [arr; idx]
    | WExpr.ArraySet(arr, idx, value) -> [arr; idx; value]
    | WExpr.ArrayNew(_, size, init, _) -> [size; init]
    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        [dst; dstOff; src; srcOff; len]
    | WExpr.Closure(_, captures, _) -> captures
    | WExpr.TailCall(_, args, _) -> args
    | WExpr.SwitchInt(scrutinee, cases, default_, _) ->
        scrutinee :: (cases |> List.map snd) @ [default_]
    | WExpr.MemLoad(_, _, addr) -> [addr]
    | WExpr.MemStore(_, _, addr, value) -> [addr; value]
    | WExpr.MemoryGrow(pages) -> [pages]
    | WExpr.CallVirtual(box, _, _, _, _, args, _) ->
        box :: args
    | WExpr.Break(_, value) -> value |> Option.toList
    | WExpr.Const _ | WExpr.LocalGet _ | WExpr.GlobalGet _
    | WExpr.FuncRef _ | WExpr.MemorySize
    | WExpr.Continue _ | WExpr.Nop -> []

// ─────────────────────────────────────────────────────────────────
// Folding and aggregation
// ─────────────────────────────────────────────────────────────────

/// Bottom-up fold over all WExpr nodes.
/// First processes all children, then applies f to the result.
let rec fold (f: 'a -> WExpr -> 'a) (acc: 'a) (expr: WExpr) : 'a =
    let acc' = children expr |> List.fold (fold f) acc
    f acc' expr

/// Collect all nodes matching a predicate.
/// Returns them in depth-first post-order.
let collect (pred: WExpr -> bool) (expr: WExpr) : WExpr list =
    fold (fun acc e -> if pred e then e :: acc else acc) [] expr
    |> List.rev  // Reverse to maintain depth-first order

/// Collect all local variable references (LocalGet nodes).
let localRefs (expr: WExpr) : string list =
    collect (function WExpr.LocalGet(name, _) -> true | _ -> false) expr
    |> List.map (function WExpr.LocalGet(n, _) -> n | _ -> failwith "impossible")

/// Find all ClosureApply nodes.
let closureApplys (expr: WExpr) : WExpr list =
    collect (function WExpr.ClosureApply _ -> true | _ -> false) expr

/// Find all Loop nodes (for detecting infinite loops or loop nesting).
let allLoops (expr: WExpr) : WExpr list =
    collect (function WExpr.Loop _ -> true | _ -> false) expr

/// Find all Break statements targeting a specific label.
let breaksForLabel (label: string) (expr: WExpr) : WExpr list =
    collect (function WExpr.Break(lbl, _) when lbl = label -> true | _ -> false) expr

/// Count depth of loop nesting.
let loopNestingDepth (expr: WExpr) : int =
    fold (fun maxDepth e ->
        match e with
        | WExpr.Loop _ -> maxDepth + 1
        | _ -> maxDepth
    ) 0 expr

// ─────────────────────────────────────────────────────────────────
// Rewriting and transformation
// ─────────────────────────────────────────────────────────────────

/// Bottom-up rewrite: apply f to each node AFTER rewriting children.
/// If f returns Some, use the new value; otherwise keep original.
let rec rewrite (f: WExpr -> WExpr option) (expr: WExpr) : WExpr =
    let rewroteChildren =
        match expr with
        | WExpr.Let(n, value, body) ->
            WExpr.Let(n, rewrite f value, rewrite f body)
        | WExpr.LetMut(n, value, body) ->
            WExpr.LetMut(n, rewrite f value, rewrite f body)
        | WExpr.If(cond, thenE, elseE, ty) ->
            WExpr.If(rewrite f cond, rewrite f thenE, rewrite f elseE, ty)
        | WExpr.Sequence exprs ->
            WExpr.Sequence(exprs |> List.map (rewrite f))
        | WExpr.Block(lbl, body, ty) ->
            WExpr.Block(lbl, rewrite f body, ty)
        | WExpr.Loop(lbl, body, ty) ->
            WExpr.Loop(lbl, rewrite f body, ty)
        | WExpr.Call(name, args, ty) ->
            WExpr.Call(name, args |> List.map (rewrite f), ty)
        | WExpr.CallIndirect(tblIdx, args, ty) ->
            WExpr.CallIndirect(tblIdx, args |> List.map (rewrite f), ty)
        | WExpr.Binary(op, left, right, ty) ->
            WExpr.Binary(op, rewrite f left, rewrite f right, ty)
        | WExpr.Unary(op, operand, ty) ->
            WExpr.Unary(op, rewrite f operand, ty)
        | WExpr.Compare(op, left, right) ->
            WExpr.Compare(op, rewrite f left, rewrite f right)
        | WExpr.Assign(name, value) ->
            WExpr.Assign(name, rewrite f value)
        | WExpr.JoinPoint(lbl, params_, body, cont, ty) ->
            WExpr.JoinPoint(lbl, params_, rewrite f body, rewrite f cont, ty)
        | WExpr.JoinApply(lbl, args, ty) ->
            WExpr.JoinApply(lbl, args |> List.map (rewrite f), ty)
        | WExpr.TryCatch(body, catch, fin, ty) ->
            let catchRew = catch |> Option.map (fun (ex, e) -> (ex, rewrite f e))
            let finRew = fin |> Option.map (rewrite f)
            WExpr.TryCatch(rewrite f body, catchRew, finRew, ty)
        | WExpr.StructNew(idx, fields, ty) ->
            WExpr.StructNew(idx, fields |> List.map (rewrite f), ty)
        | WExpr.StructGet(obj, field, ty) ->
            WExpr.StructGet(rewrite f obj, field, ty)
        | WExpr.StructSet(obj, field, value) ->
            WExpr.StructSet(rewrite f obj, field, rewrite f value)
        | WExpr.ArrayGet(arr, idx, ty) ->
            WExpr.ArrayGet(rewrite f arr, rewrite f idx, ty)
        | WExpr.ArraySet(arr, idx, value) ->
            WExpr.ArraySet(rewrite f arr, rewrite f idx, rewrite f value)
        | WExpr.ArrayNew(idx, size, init, ty) ->
            WExpr.ArrayNew(idx, rewrite f size, rewrite f init, ty)
        | WExpr.ArrayNewFixed(idx, fields, ty) ->
            WExpr.ArrayNewFixed(idx, fields |> List.map (rewrite f), ty)
        | WExpr.ArrayLen(arr) ->
            WExpr.ArrayLen(rewrite f arr)
        | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
            WExpr.ArrayCopy(
                rewrite f dst,
                rewrite f dstOff,
                rewrite f src,
                rewrite f srcOff,
                rewrite f len
            )
        | WExpr.Cast(obj, ty) ->
            WExpr.Cast(rewrite f obj, ty)
        | WExpr.RefIsNull(obj) ->
            WExpr.RefIsNull(rewrite f obj)
        | WExpr.RefTest(obj, idx) ->
            WExpr.RefTest(rewrite f obj, idx)
        | WExpr.Closure(ctxIdx, captures, ty) ->
            WExpr.Closure(ctxIdx, captures |> List.map (rewrite f), ty)
        | WExpr.ClosureApply(closure, args, fti, cti, ci, ty) ->
            WExpr.ClosureApply(
                rewrite f closure,
                args |> List.map (rewrite f),
                fti, cti, ci, ty
            )
        | WExpr.TailCallRef(closure, args, fti, cti, ci, ty) ->
            WExpr.TailCallRef(
                rewrite f closure,
                args |> List.map (rewrite f),
                fti, cti, ci, ty
            )
        | WExpr.TailCall(lbl, args, ty) ->
            WExpr.TailCall(lbl, args |> List.map (rewrite f), ty)
        | WExpr.GlobalSet(name, value) ->
            WExpr.GlobalSet(name, rewrite f value)
        | WExpr.SwitchInt(scrutinee, cases, default_, ty) ->
            WExpr.SwitchInt(
                rewrite f scrutinee,
                cases |> List.map (fun (n, e) -> (n, rewrite f e)),
                rewrite f default_,
                ty
            )
        | WExpr.MemLoad(endian, memTy, addr) ->
            WExpr.MemLoad(endian, memTy, rewrite f addr)
        | WExpr.MemStore(endian, memTy, addr, value) ->
            WExpr.MemStore(endian, memTy, rewrite f addr, rewrite f value)
        | WExpr.MemoryGrow(pages) ->
            WExpr.MemoryGrow(rewrite f pages)
        | WExpr.CallVirtual(box, iface, method_, mtIdx, miIdx, args, ty) ->
            WExpr.CallVirtual(
                rewrite f box, iface, method_, mtIdx, miIdx,
                args |> List.map (rewrite f), ty
            )
        | WExpr.TagOf(obj) ->
            WExpr.TagOf(rewrite f obj)
        | WExpr.Break(lbl, value) ->
            WExpr.Break(lbl, value |> Option.map (rewrite f))
        | other -> other

    f rewroteChildren |> Option.defaultValue rewroteChildren

// ─────────────────────────────────────────────────────────────────
// Common queries
// ─────────────────────────────────────────────────────────────────

/// Check if an expression references a specific local variable.
let referencesLocal (localName: string) (expr: WExpr) : bool =
    collect (function WExpr.LocalGet(n, _) when n = localName -> true | _ -> false) expr
    |> List.isEmpty
    |> not

/// Remove all Nop expressions from a Sequence.
let removeNops (expr: WExpr) : WExpr =
    rewrite (function
        | WExpr.Sequence exprs ->
            let filtered = exprs |> List.filter (fun e -> e <> WExpr.Nop)
            match filtered with
            | [] -> Some WExpr.Nop
            | [single] -> Some single
            | many -> Some (WExpr.Sequence many)
        | _ -> None
    ) expr

/// Flatten nested Sequences into a single level.
let flattenSequences (expr: WExpr) : WExpr =
    rewrite (function
        | WExpr.Sequence exprs ->
            let rec flattenList acc = function
                | [] -> List.rev acc
                | WExpr.Sequence inner :: rest ->
                    flattenList (List.revAppend (flattenList [] inner) acc) rest
                | e :: rest ->
                    flattenList (e :: acc) rest
            let flattened = flattenList [] exprs
            match flattened with
            | [single] -> Some single
            | many -> Some (WExpr.Sequence many)
        | _ -> None
    ) expr
