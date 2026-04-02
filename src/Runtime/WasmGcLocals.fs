/// Local variable collection and WFuncDecl construction utilities.
/// Extracted from WasmGcRuntime.fs — the infrastructure every helper needs.
/// Kept lean so emitters (WasmGcEmit, WasmGcWat) can open this without pulling in
/// all the BCL string/char helpers.
module Fable.Transforms.WasmGc.WasmGcLocals

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes

// ─────────────────────────────────────────────────────────────────
// Local variable collection
// ─────────────────────────────────────────────────────────────────

/// Collect all locals used within a WExpr (for the WASM code section).
/// Returns (name, WType) pairs for all Let/LetMut bindings not in paramNames.
let rec collectLocals (paramNames: Set<string>) (expr: WExpr) : (string * WType) list =
    match expr with
    | WExpr.Let(name, value, body) | WExpr.LetMut(name, value, body) ->
        let valueTy = exprWType value
        let local =
            if Set.contains name paramNames then []
            else
                // If the value has Void type (e.g., WExpr.Nop from unhandled calls),
                // infer the local type from how it's used (LocalGet) in the body.
                let ty =
                    if valueTy <> WType.Void then valueTy
                    else
                        // Find first LocalGet(name, ty) in body to get the actual type
                        let rec findType (e: WExpr) =
                            match e with
                            | WExpr.LocalGet(n, ty) when n = name && ty <> WType.Void -> Some ty
                            | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) ->
                                match findType v with
                                | Some ty -> Some ty
                                | None -> findType b
                            | WExpr.If(c, thenE, elseE, _) ->
                                match findType c with
                                | Some ty -> Some ty
                                | None ->
                                    match findType thenE with
                                    | Some ty -> Some ty
                                    | None -> findType elseE
                            | WExpr.Sequence exprs ->
                                exprs |> List.tryPick findType
                            | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _) ->
                                args |> List.tryPick findType
                            | WExpr.StructGet(obj, _, _) | WExpr.ArrayLen obj
                            | WExpr.Cast(obj, _) | WExpr.RefIsNull obj
                            | WExpr.TagOf obj | WExpr.Loop(_, obj, _) | WExpr.Block(_, obj, _) ->
                                findType obj
                            | WExpr.Unary(_, obj, _) -> findType obj
                            | WExpr.Binary(_, l, r, _) | WExpr.Compare(_, l, r) ->
                                match findType l with
                                | Some ty -> Some ty
                                | None -> findType r
                            | WExpr.JoinPoint(_, _, b, cont, _) ->
                                match findType b with
                                | Some ty -> Some ty
                                | None -> findType cont
                            | WExpr.JoinApply(_, args, _) -> args |> List.tryPick findType
                            | WExpr.StructNew(_, fields, _) -> fields |> List.tryPick findType
                            | WExpr.ArrayNewFixed(_, elems, _) -> elems |> List.tryPick findType
                            | WExpr.ArrayGet(arr, idx, _) ->
                                match findType arr with
                                | Some ty -> Some ty
                                | None -> findType idx
                            | _ -> None
                        match findType body with
                        | Some t -> t
                        | None -> WType.I32  // last resort: assume I32
                if ty = WType.Void then []
                else [(name, ty)]
        local @ collectLocals paramNames value @ collectLocals paramNames body
    | WExpr.If(c, t, e, _) ->
        collectLocals paramNames c @ collectLocals paramNames t @ collectLocals paramNames e
    | WExpr.Sequence exprs ->
        exprs |> List.collect (collectLocals paramNames)
    | WExpr.Loop(_, body, _) ->
        collectLocals paramNames body
    | WExpr.Block(_, body, _) ->
        collectLocals paramNames body
    | WExpr.Call(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.CallIndirect(func, args, _) ->
        collectLocals paramNames func @ (args |> List.collect (collectLocals paramNames))
    | WExpr.Binary(_, l, r, _) ->
        collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Unary(_, op, _) ->
        collectLocals paramNames op
    | WExpr.Compare(_, l, r) ->
        collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Assign(_, v) ->
        collectLocals paramNames v
    | WExpr.GlobalSet(_, v) ->
        collectLocals paramNames v
    | WExpr.JoinPoint(_, _, body, cont, _) ->
        collectLocals paramNames body @ collectLocals paramNames cont
    | WExpr.JoinApply(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.TryCatch(body, catch, fin, _) ->
        let catchLocals =
            match catch with
            | Some(name, expr) -> [name, WType.I32] @ collectLocals paramNames expr
            | None -> []
        let finLocals =
            match fin with
            | Some expr -> collectLocals paramNames expr
            | None -> []
        collectLocals paramNames body @ catchLocals @ finLocals
    | WExpr.StructNew(_, fields, _) ->
        fields |> List.collect (collectLocals paramNames)
    | WExpr.StructGet(obj, _, _) ->
        collectLocals paramNames obj
    | WExpr.StructSet(obj, _, v) ->
        collectLocals paramNames obj @ collectLocals paramNames v
    | WExpr.ArrayNewFixed(_, elems, _) ->
        elems |> List.collect (collectLocals paramNames)
    | WExpr.ArrayGet(arr, idx, _) ->
        collectLocals paramNames arr @ collectLocals paramNames idx
    | WExpr.ArraySet(arr, idx, v) ->
        collectLocals paramNames arr @ collectLocals paramNames idx @ collectLocals paramNames v
    | WExpr.ArrayLen(arr) ->
        collectLocals paramNames arr
    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        collectLocals paramNames dst
        @ collectLocals paramNames dstOff
        @ collectLocals paramNames src
        @ collectLocals paramNames srcOff
        @ collectLocals paramNames len
    | WExpr.ArrayNew(_, size, init, _) ->
        collectLocals paramNames size @ collectLocals paramNames init
    | WExpr.RefIsNull obj ->
        collectLocals paramNames obj
    | WExpr.Cast(obj, _) ->
        collectLocals paramNames obj
    | WExpr.Closure(_, captures, _) ->
        captures |> List.collect (collectLocals paramNames)
    | WExpr.ClosureApply(closure, args, _, _, _, _) ->
        // Always register $clo_apply_tmp (emitter uses local.tee unconditionally)
        let tmpLocal = ["$clo_apply_tmp", WType.Ref(AnyFnTypeIdx, false)]
        tmpLocal
        @ collectLocals paramNames closure
        @ (args |> List.collect (collectLocals paramNames))
    | WExpr.TailCall(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.TailCallRef(closure, args, _, _, _, _) ->
        let tmpLocal = ["$clo_apply_tmp", WType.Ref(AnyFnTypeIdx, false)]
        tmpLocal
        @ collectLocals paramNames closure
        @ (args |> List.collect (collectLocals paramNames))
    | WExpr.CallVirtual(box, _, _, _, _, args, _) ->
        // box is evaluated twice in the emitter (always a LocalGet in practice)
        collectLocals paramNames box
        @ (args |> List.collect (collectLocals paramNames))
    | _ -> []

/// Fill in the Locals field of a WFuncDecl by scanning the body.
let resolveLocals (func: WFuncDecl) : WFuncDecl =
    let paramNames = func.Params |> List.map fst |> Set.ofList
    let locals =
        collectLocals paramNames func.Body
        |> List.distinctBy fst
        |> List.filter (fun (_, ty) -> ty <> WType.Void)
    { func with Locals = locals }

/// Build a WFuncDecl with automatic local collection.
/// Eliminates the collectLocals boilerplate that appears on every helper.
let makeFunc (name: string) (parms: (string * WType) list) (result: WType) (body: WExpr) : WFuncDecl =
    let paramNames = parms |> List.map fst |> Set.ofList
    { Name     = name
      Params   = parms
      Result   = result
      Locals   = collectLocals paramNames body
                 |> List.distinctBy fst
                 |> List.filter (fun (_, ty) -> ty <> WType.Void)
      Body     = body
      Exported = false }
