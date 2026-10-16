/// ClosureBuilder — deduplicated closure and lifted-function construction.
///
/// Replaces the duplicate logic in:
///   buildClosure         (TransformClosure.fs ~60 lines)
///   buildLetRecLambdas   (TransformClosure.fs ~80 lines of near-identical type/struct setup)
///
/// Single source of truth for:
///   - ClosureBase type registration (funcTypeIdx → baseClosureTypeIdx)
///   - Concrete closure struct registration  
///   - Lifted function body with capture extraction preamble
///   - FuncTypeToClosureMap maintenance
module WasmGc.Transforms.ClosureBuilder

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Runtime.FreeVars
open WasmGc.Pipeline.Scope
module Lc = WasmGc.Runtime.Locals

// ─────────────────────────────────────────────────────────────────
// Shared type infrastructure
// ─────────────────────────────────────────────────────────────────

/// Get or create the ClosureBase type for a given funcTypeIdx.
/// ClosureBase = struct { code: ref $FT } sub $AnyFn
/// All closures sharing this apply signature cast to this base.
let private getOrAddClosureBase (ctx: Ctx) (funcTypeIdx: int) (codeFieldTy: WType) : int =
    match ctx.ClosureBaseTypeMap.TryGetValue(funcTypeIdx) with
    | true, idx -> idx
    | false, _ ->
        let idx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add {
            Name = sprintf "ClosureBase_%d" idx
            Def  = WTypeDef.Struct(
                     [{ Name = "code"; Type = codeFieldTy; Mutable = false }],
                     Some AnyFnTypeIdx) }
        ctx.ClosureBaseTypeMap.[funcTypeIdx] <- idx
        idx

/// Register a concrete closure struct and return its type index.
/// concreteStruct = { code: ref $FT, cap_0: T0, cap_1: T1, ... } sub ClosureBase
let private addConcreteClosureType
        (ctx: Ctx)
        (funcName: string)
        (baseClosureTypeIdx: int)
        (codeFieldTy: WType)
        (captures: (string * WType) list)
        : int =
    let captureFields =
        captures |> List.mapi (fun i (name, ty) ->
            { Name = sprintf "cap_%d_%s" i name; Type = ty; Mutable = false })
    let allFields = { Name = "code"; Type = codeFieldTy; Mutable = false } :: captureFields
    let typeIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add {
        Name = sprintf "ClosureType_%d" typeIdx
        Def  = WTypeDef.Struct(allFields, Some baseClosureTypeIdx) }
    typeIdx

/// Build the lifted function body prefix that extracts captures from $self.
/// Returns:  let $self_cast = cast($self, ref $closureTypeIdx)
///           let cap_name_0 = struct.get $self_cast 1
///           let cap_name_1 = struct.get $self_cast 2
///           ... inner body ...
let private wrapWithCaptureExtraction
        (selfTy       : WType)
        (closureTypeIdx: int)
        (captures     : (string * WType) list)
        (body         : WExpr)
        : WExpr =
    if captures.IsEmpty then body
    else
        let castTy  = WType.Ref(closureTypeIdx, false)
        let selfCast = WExpr.Cast(WExpr.LocalGet("$self", selfTy), castTy)
        let selfCastLG = WExpr.LocalGet("$self_cast", castTy)
        // Field indices: code=0, cap_0=1, cap_1=2, ...
        let extracted =
            captures |> List.mapi (fun i (name, ty) ->
                name, WExpr.StructGet(selfCastLG, i + 1, ty))
        let bodyWithExtracts =
            List.foldBack
                (fun (name, expr) acc -> WExpr.Let(name, expr, acc))
                extracted body
        WExpr.Let("$self_cast", selfCast, bodyWithExtracts)

// ─────────────────────────────────────────────────────────────────
// Core: emit one lifted function + register its closure types
// ─────────────────────────────────────────────────────────────────

/// Shared parameters for building one closure.
type ClosureSpec = {
    /// Unique name for the lifted Wasm function (e.g. "$closure_42").
    FuncName     : string
    /// Formal lambda parameters (excluding $self and captures).
    ArgParams    : (string * WType) list
    /// Captured variables (name + type).
    Captures     : (string * WType) list
    /// Return type of the lifted function.
    RetType      : WType
}

/// Build and register one lifted function + its closure struct types.
/// Returns WExpr.Closure(funcName, captureExprs, ref $closureTypeIdx).
let buildOne (ctx: Ctx) (spec: ClosureSpec) (body: WExpr) : WExpr =
    let selfTy      = WType.Ref(AnyFnTypeIdx, false)
    let argTys      = spec.ArgParams |> List.map snd
    let funcTypeIdx = ctx.GetOrAddFuncType(selfTy :: argTys, spec.RetType)
    let codeFieldTy = WType.Ref(funcTypeIdx, false)

    let baseIdx = getOrAddClosureBase ctx funcTypeIdx codeFieldTy
    let typeIdx = addConcreteClosureType ctx spec.FuncName baseIdx codeFieldTy spec.Captures

    ctx.ClosureRegistry.[spec.FuncName] <- (typeIdx, funcTypeIdx, spec.Captures.Length)
    if not (ctx.FuncTypeToClosureMap.ContainsKey(funcTypeIdx)) then
        ctx.FuncTypeToClosureMap.[funcTypeIdx] <- baseIdx

    // Build full param list: $self + user args
    let allParams = ("$self", selfTy) :: spec.ArgParams

    // Wrap body with capture extraction
    let liftedBody = wrapWithCaptureExtraction selfTy typeIdx spec.Captures body

    let func =
        { Name = spec.FuncName; Params = allParams; Result = spec.RetType
          Locals = []; Body = liftedBody; Exported = false }
        |> Lc.resolveLocals
    ctx.Functions.Add(func)

    let captureExprs = spec.Captures |> List.map (fun (n, ty) -> WExpr.LocalGet(n, ty))
    WExpr.Closure(spec.FuncName, captureExprs, WType.Ref(typeIdx, false))

// ─────────────────────────────────────────────────────────────────
// High-level helpers used by TransformClosure.fs
// ─────────────────────────────────────────────────────────────────

/// Filter free variable names to those that are actual captures
/// (local in scope, not a module-level zero-arg function).
let filterCaptures (ctx: Ctx) (freeVarNames: string list) : (string * WType) list =
    freeVarNames
    |> List.filter (isCapturable ctx)
    |> List.map (fun name ->
        name, Map.tryFind name ctx.Locals |> Option.defaultValue WType.I32)
    |> List.filter (snd >> (<>) WType.Void)

/// Build a unique closure function name from a base name and current TypeDefs count.
let closureName (baseName: string) (ctx: Ctx) : string =
    let counter = System.Threading.Interlocked.Increment(ctx.ClosureCounter)
    sprintf "%s_%d" baseName counter

/// Build a closure for a plain lambda/delegate.
/// `eval` is transformExpr — passed to break the circular reference.
let buildClosure
        (ctx      : Ctx)
        (eval     : Ctx -> Fable.Expr -> WExpr)
        (args     : Ident list)
        (body     : Fable.Expr)
        (nameHint : string option)
        : WExpr =

    let funcName = closureName (defaultArg nameHint "$closure") ctx
    let argNames = args |> List.map (fun a -> a.Name) |> Set.ofList
    let captures = collectFreeVars argNames body |> Set.toList |> filterCaptures ctx
    let argParams =
        args |> List.choose (fun a ->
            let ty = mapTypeKnown ctx a.Type
            if ty = WType.Void then None else Some(a.Name, ty))
    let retType  = mapResultTypeKnown ctx body.Type

    let spec = { FuncName = funcName; ArgParams = argParams; Captures = captures; RetType = retType }

    // Build eval context: params + captures accessible as locals
    let ctx' =
        ctx
        |> withLocals (("$self", WType.Ref(AnyFnTypeIdx, false)) :: argParams)
        |> withLocals captures
        |> fun c -> { c with CurrentFunc = Some funcName }

    buildOne ctx spec (eval ctx' body)

/// Build mutually-recursive closures from LetRec bindings.
/// Shared cells strategy: each closure captures the ref-cells of its siblings.
let buildLetRecLambdas
        (ctx      : Ctx)
        (eval     : Ctx -> Fable.Expr -> WExpr)
        (bindings : (Ident * Fable.Expr) list)
        (contBody : Fable.Expr)
        : WExpr =

    let anyFnNullTy = WType.Ref(AnyFnTypeIdx, true)
    let anyFnTy     = WType.Ref(AnyFnTypeIdx, false)
    let cellTypeIdx = getOrAddRefCellType ctx anyFnNullTy
    let cellTy      = WType.Ref(cellTypeIdx, false)

    // Decompose each binding into (ident, args, lambdaBody, nameHint)
    let lambdas =
        bindings |> List.map (fun (id, expr) ->
            match expr with
            | Lambda(arg, body, name)          -> id, [arg], body, name
            | Delegate(args, body, name, _)    -> id, args,  body, name
            | _ -> failwithf "buildLetRecLambdas: binding '%s' is not a lambda" id.Name)

    let bindingNames  = lambdas |> List.map (fun (id, _, _, _) -> id.Name) |> Set.ofList
    let cellLocalNames= lambdas |> List.map (fun (id, _, _, _) -> sprintf "$letrec_cell_%s" id.Name)

    // Common free variables across ALL bodies (minus binding names and per-lambda params)
    let commonCaptures =
        lambdas
        |> List.collect (fun (_, args, lbody, _) ->
            let bound = Set.union bindingNames (args |> List.map (fun a -> a.Name) |> Set.ofList)
            collectFreeVars bound lbody |> Set.toList)
        |> List.distinct
        |> filterCaptures ctx

    // Build one lifted closure for binding at index i
    let buildOne_ (i: int) : WExpr =
        let (id, args, lbody, nameHint) = lambdas.[i]
        let funcName = closureName (defaultArg nameHint (sprintf "$letrec_%s" id.Name)) ctx

        let siblingCells =
            cellLocalNames
            |> List.mapi (fun j n -> j, n)
            |> List.choose (fun (j, n) -> if j = i then None else Some(n, cellTy))

        let allCaptures = siblingCells @ commonCaptures
        let argParams =
            args |> List.choose (fun a ->
                let ty = mapTypeKnown ctx a.Type
                if ty = WType.Void then None else Some(a.Name, ty))
        let retType = mapResultTypeKnown ctx lbody.Type

        let spec = { FuncName = funcName; ArgParams = argParams; Captures = allCaptures; RetType = retType }

        let ctx' =
            ctx
            |> withLocals (("$self", WType.Ref(AnyFnTypeIdx, false)) :: argParams)
            |> withLocals allCaptures
            // Resolve sibling closures from their cells inside the lifted body
            |> fun c ->
                cellLocalNames |> List.mapi (fun j cellName ->
                    // Each binding resolves to: struct.get (cell) 0  (unwrap the ref cell)
                    let closureExpr = WExpr.StructGet(WExpr.LocalGet(cellName, cellTy), 0, anyFnTy)
                    lambdas.[j] |> (fun (id, _, _, _) -> id.Name), closureExpr)
                |> List.fold (fun (c: Ctx) (n, _) -> c.WithLocal(n, anyFnTy)) c
            |> fun c -> { c with CurrentFunc = Some funcName }

        buildOne ctx spec (eval ctx' lbody)

    // Build all closures
    let closureExprs = lambdas |> List.mapi (fun i _ -> buildOne_ i)

    // Initialize: let $cell_i = ref(null); ... fill cells; then body
    // Wrap everything in LetMut bindings for each cell
    let initCells =
        List.zip cellLocalNames closureExprs
        |> List.map (fun (cellName, closureExpr) ->
            cellName, WExpr.StructNew(cellTypeIdx, [closureExpr], cellTy))

    // The continuation body with binding names resolved to cell dereferences
    let ctx'' =
        ctx
        |> fun c ->
            lambdas |> List.mapi (fun i (id, _, _, _) ->
                id.Name, WExpr.StructGet(WExpr.LocalGet(cellLocalNames.[i], cellTy), 0, anyFnTy))
            |> List.fold (fun (c: Ctx) (n, _) -> c.WithLocal(n, anyFnTy)) c
        |> withLocals (cellLocalNames |> List.map (fun n -> n, cellTy))

    let wCont = eval ctx'' contBody

    // Nest: let $cell_0 = ...; let $cell_1 = ...; continuation
    List.foldBack
        (fun (name, expr) acc -> WExpr.Let(name, expr, acc))
        initCells wCont
