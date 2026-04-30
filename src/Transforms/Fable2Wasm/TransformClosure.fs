module WasmGc.Transforms.TransformClosures

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Runtime.FreeVars
module Lc = WasmGc.Runtime.Locals

// ─────────────────────────────────────────────────────────────────
// Value translation
// ─────────────────────────────────────────────────────────────────

/// Build a closure struct for a lambda/delegate.
///
/// SELF-PARAMETER CALLING CONVENTION (Sprint 25b):
///   Lifted function signature: ($self: ref $AnyFn, arg1: T1, ..., argN: TN) → R
///   The code field type for ALL closures with the same apply signature (T1..TN → R)
///   is the SAME functype: (ref $AnyFn, T1, ..., TN) → R.
///   This guarantees ref.cast to ClosureBase succeeds at runtime for ANY closure
///   regardless of how many captures it has.
///
///   At call time (CurriedApply):
///     1. Cast closure to ClosureBase (struct { code: ref $FT_self_args })
///     2. Push it as $self (first arg)
///     3. Push other args
///     4. struct.get 0 → code pointer; call_ref $funcTypeIdx
///
///   Inside the lifted function body, captures are extracted from $self:
///     let $self_cast = ref.cast (ref $ConcreteClosureType) $self
///     let cap_0     = struct.get $self_cast 1
///     let cap_1     = struct.get $self_cast 2
///     ... original body ...
/// Build a single lambda/delegate closure.
/// Takes `eval` as a parameter to break circularity with transformExpr.
let rec buildClosure (ctx: Ctx) (eval: Ctx -> Fable.Expr -> WExpr) (args: Ident list) (body: Fable.Expr) (maybeName: string option) : WExpr =
    let baseName = defaultArg maybeName "$closure"
    // Give it a unique name based on type-def count (stable per file)
    let funcName = $"{baseName}_{ctx.TypeDefs.Count}"

    // Collect free variables (closed-over locals) from the body, 
    // excluding the lambda parameters themselves.
    let argNames = args |> List.map (fun a -> a.Name) |> Set.ofList
    let allFreeVarNames = collectFreeVars argNames body |> Set.toList
    let freeVarNames =
        allFreeVarNames
        |> List.filter (fun name -> 
            Map.containsKey name ctx.Locals &&
            // excluding the lambda parameters themselves.
            let q = ctx.FuncNameAlias |> Map.tryFind name |> Option.defaultValue name
            match Map.tryFind q ctx.KnownFuncs with
            | Some([], _) -> false   // zero-arg = module value, will be emitted as Call
            | _ -> true
            )

    // Build capture list: (name, WType)
    let captures =
        freeVarNames
        |> List.map (fun name -> name, Map.tryFind name ctx.Locals |> Option.defaultValue WType.I32)
        |> List.filter (fun (_, ty) -> ty <> WType.Void)

    let captureCount = List.length captures

    // Lambda parameters (NOT captures — captures come from $self struct.get)
    let argParams =
        args |> List.choose (fun a ->
            let ty = mapTypeKnown ctx a.Type
            if ty = WType.Void then None else Some(a.Name, ty))

    // Build function type: (ref $AnyFn, arg1..., argN) → retType
    // The self-parameter approach: ALL closures with the same apply signature share
    // this functype, regardless of how many captures they have.
    let selfType = WType.Ref(AnyFnTypeIdx, false)
    let argParamTypes = argParams |> List.map snd
    let retType = mapResultTypeKnown ctx body.Type
    let funcTypeIdx = ctx.GetOrAddFuncType(selfType :: argParamTypes, retType)

    // Build closure struct type: { code: (ref $functype), cap0: T0, cap1: T1, ... }
    // The code field type is the APPLY+SELF functype (not the lifted functype).
    let codeFieldType = WType.Ref(funcTypeIdx, false)
    let captureFields =
        captures |> List.mapi (fun i (name, ty) ->
            { Name = $"cap_{i}_{name}"; Type = ty; Mutable = false })
    let codeField = { Name = "code"; Type = codeFieldType; Mutable = false }

    // ClosureBase: struct { code: ref $FT_self_args } sub $AnyFn
    // All concrete closures with this apply signature extend the SAME ClosureBase.
    // This is the key to making ref.cast work for any closure.
    let baseClosureTypeIdx =
        match ctx.ClosureBaseTypeMap.TryGetValue(funcTypeIdx) with
        | true, idx -> idx
        | false, _ ->
            let idx = ctx.TypeDefs.Count
            ctx.TypeDefs.Add(
                { Name = $"ClosureBase_{idx}"
                  Def = WTypeDef.Struct([codeField], Some AnyFnTypeIdx) })
            ctx.ClosureBaseTypeMap.[funcTypeIdx] <- idx
            idx

    let closureTypeIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add(
        { Name = $"ClosureType_{closureTypeIdx}"
          Def = WTypeDef.Struct(codeField :: captureFields, Some baseClosureTypeIdx) })
    ctx.ClosureRegistry.[funcName] <- (closureTypeIdx, funcTypeIdx, captureCount)

    // Store the BASE closure type (not the concrete type) in FuncTypeToClosureMap.
    // Call sites that look up funcTypeIdx → closureBaseTypeIdx will always get the right
    // ClosureBase struct, and ref.cast to it works for any closure with the same apply sig.
    if not (ctx.FuncTypeToClosureMap.ContainsKey(funcTypeIdx)) then
        ctx.FuncTypeToClosureMap.[funcTypeIdx] <- baseClosureTypeIdx

    // Build lifted function body
    // Params: ($self: ref $AnyFn, arg1, ..., argN) — NOT captures (they come from $self).
    // ctx' includes captures in Locals for type resolution during transformExpr.
    let allParams = [("$self", selfType)] @ argParams
    let ctxWithCaptures =
        captures |> List.fold (fun (c: Ctx) (name, ty) -> c.WithLocal(name, ty)) ctx
    let ctx' =
        allParams |> List.fold (fun (c: Ctx) (name, ty) -> c.WithLocal(name, ty)) ctxWithCaptures
    let ctx' = { ctx' with CurrentFunc = Some funcName }
    
    // Here we resolve the the recursive dependency
    // let wBody = transformExpr ctx' body
    let wBody = eval ctx' body

    // Wrap body with capture extraction from $self (only if there are captured vars).
    // Generated prefix:
    //   let $self_cast = ref.cast (ref $ClosureType_N) $self
    //   let cap_0      = struct.get $self_cast 1
    //   let cap_1      = struct.get $self_cast 2
    //   ...
    let wBodyWithCaptures =
        if captureCount = 0 then wBody
        else
            let selfCastTy = WType.Ref(closureTypeIdx, false)
            let selfGet = WExpr.LocalGet("$self", selfType)
            let selfCast = WExpr.Cast(selfGet, selfCastTy)
            let bodyWithExtracts =
                captures
                |> List.mapi (fun i (name, ty) ->
                    let capSrc = WExpr.StructGet(WExpr.LocalGet("$self_cast", selfCastTy), i + 1, ty)
                    (name, capSrc))
                |> List.foldBack (fun (name, capExpr) innerBody ->
                    WExpr.Let(name, capExpr, innerBody)) <| wBody
            WExpr.Let("$self_cast", selfCast, bodyWithExtracts)

    let paramNameSet = allParams |> List.map fst |> Set.ofList
    let closureFunc =
        { Name = funcName; Params = allParams; Result = retType
          Locals = []; Body = wBodyWithCaptures; Exported = false }
          |> Lc.resolveLocals   // Apply full local resolution (includes captured references)
    ctx.Functions.Add(closureFunc)

    // Return WExpr.Closure(funcName, capture_WExprs, closureRefType)
    let captureExprs =
        captures |> List.map (fun (name, ty) -> WExpr.LocalGet(name, ty))
    let closureRefType = WType.Ref(closureTypeIdx, false)
    WExpr.Closure(funcName, captureExprs, closureRefType)

// ─────────────────────────────────────────────────────────────────
// Mutual-closure let rec (Sprint 25e)
// ─────────────────────────────────────────────────────────────────

/// Build mutually-recursive closures from LetRec bindings.
/// Handle `let rec f = fun ... and g = fun ...` inside a function body.
///
/// Strategy: for each binding i, allocate a mutable ref-cell ($cell_i) containing
/// a nullable reference to the closure struct.  Each closure captures:
///   • the REF CELLS of all sibling bindings   (not the sibling closures directly)
///   • all common free variables from the outer context
/// After all closures are built, we fill in the cells via struct.set.
/// Inside each lifted function, a preamble extracts sibling closures from their cells.
///
/// This correctly handles mutual calls (dispatch ↔ render in Elmish) without
/// requiring a shared env struct or WasmGC globals.
///
/// Takes `eval` as a parameter to break circularity with transformExpr.
and buildLetRecLambdas (ctx: Ctx) (eval: Ctx -> Fable.Expr -> WExpr) 
                       (bindings: (Fable.AST.Fable.Ident * Fable.AST.Fable.Expr) list) 
                       (body: Fable.AST.Fable.Expr) : WExpr =
    let anyFnNullTy  = WType.Ref(AnyFnTypeIdx, true)   // (ref null $AnyFn)
    let anyFnTy      = WType.Ref(AnyFnTypeIdx, false)  // (ref $AnyFn)
    let cellTypeIdx  = getOrAddRefCellType ctx anyFnNullTy
    let cellTy       = WType.Ref(cellTypeIdx, false)

    // Extract lambda args and body for each binding
    let lambdas =
        bindings |> List.map (fun (id, expr) ->
            match expr with
            | Fable.Expr.Lambda(arg, lbody, name)      -> id, [arg], lbody, name
            | Fable.Expr.Delegate(args, lbody, name, _) -> id, args,  lbody, name
            | _ -> failwithf "buildLetRecLambdas: non-lambda binding '%s'" id.Name)

    let bindingNames = lambdas |> List.map (fun (id, _, _, _) -> id.Name) |> Set.ofList

    // Collect all free variables across ALL bodies, minus binding names and per-lambda params
    let allFreeVarNames =
        lambdas
        |> List.collect (fun (_, args, lbody, _) ->
            let argNames = args |> List.map (fun a -> a.Name) |> Set.ofList
            let bound = Set.union bindingNames argNames
            collectFreeVars bound lbody |> Set.toList)
        |> List.distinct
        |> List.filter (fun name -> Map.containsKey name ctx.Locals)
        // TODO: check if we have to filter like in buildClosure

    let commonCaptures =
        allFreeVarNames
        |> List.map (fun name -> name, Map.find name ctx.Locals)
        |> List.filter (fun (_, ty) -> ty <> WType.Void)

    let cellLocalNames = lambdas |> List.map (fun (id, _, _, _) -> $"$letrec_cell_{id.Name}")
    let bindingCount   = bindings.Length

    // Helper function to build one lifted closure for binding at index i
    let buildOneClosure (i: int) =
        let (id, args, lbody, maybeName) = lambdas.[i]
        let baseName = defaultArg maybeName $"$letrec_{id.Name}"
        let funcName = $"{baseName}_{ctx.TypeDefs.Count}"

        let siblingCellCaptures =
            cellLocalNames
            |> List.mapi (fun j cellName -> j, cellName)
            |> List.choose (fun (j, cellName) -> if j = i then None else Some(cellName, cellTy))

        let allCaptures = siblingCellCaptures @ commonCaptures

        // Lambda formal parameters
        let argParams =
            args |> List.choose (fun a ->
                let ty = mapTypeKnown ctx a.Type
                if ty = WType.Void then None else Some(a.Name, ty))

        let selfType    = WType.Ref(AnyFnTypeIdx, false)
        let argParamTypes = argParams |> List.map snd
        let retType     = mapResultTypeKnown ctx lbody.Type
        let funcTypeIdx = ctx.GetOrAddFuncType(selfType :: argParamTypes, retType)

        // Build concrete closure struct type:
        //   { code: ref $FT, cell_j1: ref $CellType, ..., cap0: T0, ... }
        let codeField     = { Name = "code"; Type = WType.Ref(funcTypeIdx, false); Mutable = false }
        let captureFields =
            allCaptures |> List.mapi (fun k (name, ty) ->
                { Name = $"cap_{k}_{name}"; Type = ty; Mutable = false })

        // ClosureBase for this functype (shared across all closures with same apply sig)
        let baseClosureTypeIdx =
            match ctx.ClosureBaseTypeMap.TryGetValue(funcTypeIdx) with
            | true, idx -> idx
            | false, _ ->
                let idx = ctx.TypeDefs.Count
                ctx.TypeDefs.Add(
                    { Name = $"ClosureBase_{idx}"
                      Def = WTypeDef.Struct([codeField], Some AnyFnTypeIdx) })
                ctx.ClosureBaseTypeMap.[funcTypeIdx] <- idx
                idx

        let closureTypeIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add(
            { Name = $"ClosureType_{closureTypeIdx}"
              Def = WTypeDef.Struct(codeField :: captureFields, Some baseClosureTypeIdx) })
        ctx.ClosureRegistry.[funcName] <- (closureTypeIdx, funcTypeIdx, List.length allCaptures)
        if not (ctx.FuncTypeToClosureMap.ContainsKey(funcTypeIdx)) then
            ctx.FuncTypeToClosureMap.[funcTypeIdx] <- baseClosureTypeIdx

        // Build the lifted function context:
        //   - $self and formal args
        //   - sibling names as anyFnTy (extracted from cells in preamble)
        //   - common captures from ctx
        let ctxL1 : Ctx =
            [("$self", selfType)] @ argParams
            |> List.fold (fun (c: Ctx) (n: string, t: WType) -> c.WithLocal(n, t)) ctx
        // Add sibling names so that references in the body resolve correctly
        let ctxL2 : Ctx =
            lambdas |> List.fold (fun (c: Ctx) (bid: Fable.AST.Fable.Ident, _, _, _: string option) -> c.WithLocal(bid.Name, anyFnTy)) ctxL1
        let ctxL3 : Ctx =
            commonCaptures |> List.fold (fun (c: Ctx) (n: string, t: WType) -> c.WithLocal(n, t)) ctxL2
        let ctxLifted = { ctxL3 with CurrentFunc = Some funcName }

        // Transform the original Fable body in this enriched context
        // let wBody = transformExpr ctxLifted lbody
        let wBody = eval ctxLifted lbody

        // Build preamble: extract $self to concrete closure type, then extract captures.
        let concreteSelfTy = WType.Ref(closureTypeIdx, false)

        // TODO: debug
        // // Build extraction expressions for all captures (they're in cap_0, cap_1, ... order)
        // // Index within the capture fields: 0 = first sibling cell, ...
        // // NOTE: captureFields are numbered starting at field index 1 (field 0 = code).
        // let siblingCellsWithIdx =
        //     cellLocalNames
        //     |> List.mapi (fun j cellName -> j, cellName)
        //     |> List.choose (fun (j, cellName) ->
        //         if j = i then None
        //         else
        //             // Which capture field index? Sibling j's cell appears at:
        //             // captureFields position = number of siblings before j that are not i
        //             Some(j, cellName))

        // // The captureField order is: [sibling cells in order (skipping i)], [commonCaptures in order]
        // // So: siblingCellCaptures has (bindingCount-1) items, then commonCaptures

        // For each sibling, what field index is its cell?
        let siblingCellFieldIdxMap =
            siblingCellCaptures
            |> List.mapi (fun k (cellName, _) -> cellName, 1 + k)
            |> Map.ofList
        let commonCaptureFieldStart = 1 + List.length siblingCellCaptures // field 0 is code

        // Generate preamble:
        //   let $self_cast = ref.cast (ref $ClosureType_N) $self
        //   // extract sibling closures from their cells
        //   let sib_name_j = ref.cast (ref $AnyFn) (struct.get $self_cast  <cell_field_idx>).contents
        //   // extract common captures
        //   let commonName = struct.get $self_cast <field_idx>

        let selfGet     = WExpr.LocalGet("$self", selfType)
        let selfCastExpr = WExpr.Cast(selfGet, concreteSelfTy)

        // Extract each sibling by name (as anyFnTy, for LocalGet in body)
        let siblingExtractions =
            lambdas
            |> List.mapi (fun j (jid, _, _, _) -> j, jid.Name)
            |> List.choose (fun (j, sibName) ->
                if j = i then None
                else
                    let cellLocalName = cellLocalNames.[j]
                    let cellFieldIdx  = siblingCellFieldIdxMap |> Map.tryFind cellLocalName |> Option.defaultValue 1
                    let cellExtract  = WExpr.StructGet(WExpr.LocalGet("$self_cast", concreteSelfTy), cellFieldIdx, cellTy)
                    let contentsExpr = WExpr.StructGet(cellExtract, 0, anyFnNullTy)
                    let nonNullExpr  = WExpr.Cast(contentsExpr, anyFnTy)
                    Some(sibName, nonNullExpr))

        // Extract common captures
        let commonCapExtractions =
            commonCaptures |> List.mapi (fun k (name, ty) ->
                let fieldIdx = commonCaptureFieldStart + k
                name, WExpr.StructGet(WExpr.LocalGet("$self_cast", concreteSelfTy), fieldIdx, ty))

        // Also bind the current binding's own name to $self so that self-recursive
        // references in the body (e.g. `cmd dispatch` inside dispatch's body) resolve.
        let selfNameExtraction = (id.Name, WExpr.LocalGet("$self", anyFnTy))
        let allExtractions = [selfNameExtraction] @ siblingExtractions @ commonCapExtractions

        let wBodyWithExtracts =
            (allExtractions, wBody)
            ||> List.foldBack (fun (name, src) acc -> WExpr.Let(name, src, acc))

        let wBodyFull = WExpr.Let("$self_cast", selfCastExpr, wBodyWithExtracts)

        let allParams   = [("$self", selfType)] @ argParams
        let closureFunc =
            { Name      = funcName
              Params    = allParams
              Result    = retType
              Locals    = []
              Body      = wBodyFull
              Exported  = false }
            |> Lc.resolveLocals   // Apply full local resolution (includes captured references)

        ctx.Functions.Add(closureFunc)

        let captureExprs =
            (siblingCellCaptures |> List.map (fun (cellName, ty) -> WExpr.LocalGet(cellName, ty)))
            @ (commonCaptures |> List.map (fun (name, ty) -> WExpr.LocalGet(name, ty)))
        WExpr.Closure(funcName, captureExprs, WType.Ref(closureTypeIdx, false))


    // ─── Generate the full WExpr sequence ────────────────────────────────────
    //
    //  let $letrec_cell_dispatch = StructNew(cellTypeIdx, [ref.null $AnyFn])
    //  let $letrec_cell_render   = StructNew(cellTypeIdx, [ref.null $AnyFn])
    //  let dispatch = Closure(fn_dispatch, [$letrec_cell_render, model_ref, ...])
    //  let render   = Closure(fn_render,   [$letrec_cell_dispatch, model_ref, ...])
    //  ;; fill cells
    //  StructSet($letrec_cell_dispatch, 0, dispatch)
    //  StructSet($letrec_cell_render,   0, render)
    //  <body>

    // Build the final WExpr sequence
    // Build closures (this registers lifted functions and types)
    let closureExprs = lambdas |> List.mapi (fun i _ -> buildOneClosure i)

    // Null initializer for the cells: ref.null $AnyFn
    let nullAnyFn = WExpr.Const(WConst.Null anyFnNullTy)

    // Allocate cells upfront (with null contents; filled later)
    let cellAlloc = WExpr.StructNew(cellTypeIdx, [nullAnyFn], cellTy)

    // Assign binding names to their closure exprs in the body context
    let bodyCtx =
        (ctx, List.zip lambdas closureExprs)
        ||> List.fold (fun c ((id, _, _, _), closureExpr) ->
            let ty = match closureExpr with WExpr.Closure(_, _, t) -> t | _ -> anyFnTy
            c.WithLocal(id.Name, ty))

    // let wBody = transformExpr bodyCtx body
    let wBody = eval bodyCtx body

    // Bind all closure names for use in body + fillCells
    let boundClosures =
        List.zip3 (lambdas |> List.map (fun (id, _, _, _) -> id.Name)) closureExprs
            (lambdas |> List.map (fun (id, _, _, _) -> id))
        |> List.map (fun (name, expr, _) ->
            let ty = match expr with WExpr.Closure(_, _, t) -> t | _ -> anyFnTy
            name, expr, ty)

    // StructSet: fill each cell by reading the already-bound closure locals
    let fillCells =
        List.zip cellLocalNames boundClosures
        |> List.map (fun (cellName, (closureName, _, closureTy)) ->
            WExpr.StructSet(WExpr.LocalGet(cellName, cellTy), 0, WExpr.LocalGet(closureName, closureTy)))

    // Build final WExpr bottom-up:
    //   body is inserted after fillCells
    let bodyWithFills =
        WExpr.Sequence(fillCells @ [wBody])

    // Wrap with let bindings for each closure
    let withClosureLets =
        (boundClosures, bodyWithFills)
        ||> List.foldBack (fun (name, value, ty) acc ->
            WExpr.Let(name, value, acc))

    // Wrap with let bindings for each cell
    (List.zip cellLocalNames (List.init bindingCount (fun _ -> cellAlloc)), withClosureLets)
    ||> List.foldBack (fun (cellName, cellInit) acc ->
        WExpr.Let(cellName, cellInit, acc))
