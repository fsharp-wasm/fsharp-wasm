
/// ClosureBuilder — the single place that creates closures, lifted functions and closure calls.
///
/// ABI (see Types.fs "Closure ABI"):
///   closure value  = struct (sub ClosureBase_k) { code: ref $FT; cap_0 .. cap_n }
///   $FT            = (self: ref $AnyFn, a1 .. an) -> r
///
/// Fixes over the previous version:
///   * `let rec` (one OR many bindings): the old code evaluated sibling cells before they were
///     bound and never bound the binding names inside the lifted bodies (→ "uninitialized
///     non-defaultable local").  Now: self-reference goes through `$self`, siblings through
///     pre-allocated cells that are filled after all closures exist.  A single self-recursive
///     closure needs no cell at all.
///   * Module function used as a value: `ref.func f` was stored in a closure whose code type has
///     an extra `$self` parameter (→ "struct.new expected (ref N), found ref.func of type (ref M)").
///     A `$self`-taking wrapper function is generated (once per function) instead.
///   * Closure calls derive the func type from the callee's DECLARED type, i.e. the same source
///     the lambda's signature came from, not from the types of the argument expressions.
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

/// Register a concrete closure struct and return its type index.
/// concreteStruct = { code: ref $FT, cap_0: T0, cap_1: T1, ... } sub ClosureBase
let private addConcreteClosureType
        (ctx: Ctx)
        (baseClosureTypeIdx: int)
        (codeFieldTy: WType)
        (captures: (string * WType) list)
        : int =
    let captureFields =
        captures |> List.mapi (fun i (name, ty) ->
            { Name = sprintf "cap_%d_%s" i name; Type = ty; Mutable = false })
    let typeIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add {
        Name = sprintf "ClosureType_%d" typeIdx
        Def  = WTypeDef.Struct({ Name = "code"; Type = codeFieldTy; Mutable = false } :: captureFields,
                               Some baseClosureTypeIdx) }
    typeIdx

/// Prefix of a lifted body:
///   let $self_cast = cast($self, ref $closureType)
///   let cap_i      = struct.get $self_cast (i+1)
///   let <prelude>  = …            (extra bindings that may use $self / captures)
///   body
let private wrapLiftedBody
        (closureTypeIdx: int)
        (captures      : (string * WType) list)
        (prelude       : (string * WExpr) list)
        (body          : WExpr)
        : WExpr =
    let withPrelude = List.foldBack (fun (n, e) acc -> WExpr.Let(n, e, acc)) prelude body
    if captures.IsEmpty then withPrelude
    else
        let castTy  = WType.Ref(closureTypeIdx, false)
        let selfCast = WExpr.LocalGet("$self_cast", castTy)
        let extracts =
            List.foldBack
                (fun (i, (name, ty)) acc -> WExpr.Let(name, WExpr.StructGet(selfCast, i + 1, ty), acc))
                (List.indexed captures) withPrelude
        WExpr.Let("$self_cast", WExpr.Cast(WExpr.LocalGet("$self", closureSelfTy), castTy), extracts)

// ─────────────────────────────────────────────────────────────────
// Core: emit one lifted function + register its closure types
// ─────────────────────────────────────────────────────────────────

/// Shared parameters for building one closure.
type ClosureSpec = {
    /// Unique name for the lifted Wasm function (e.g. "$closure_42").
    FuncName     : string
    /// Formal lambda parameters (excluding $self and captures; void params already dropped).
    ArgParams    : (string * WType) list
    /// Captured variables (name + type).
    Captures     : (string * WType) list
    /// Return type of the lifted function.
    RetType      : WType
}

/// Build and register one lifted function + its closure struct types.
/// `prelude` are extra `let`s evaluated at function entry (after capture extraction).
/// Returns WExpr.Closure(funcName, captureExprs, ref $closureTypeIdx).
let buildOneWith (ctx: Ctx) (spec: ClosureSpec) (prelude: (string * WExpr) list) (body: WExpr) : WExpr =
    let funcTypeIdx = closureFuncType ctx (spec.ArgParams |> List.map snd) spec.RetType
    let codeFieldTy = WType.Ref(funcTypeIdx, false)
    let baseIdx     = getOrAddClosureBase ctx funcTypeIdx
    let typeIdx     = addConcreteClosureType ctx baseIdx codeFieldTy spec.Captures

    ctx.ClosureRegistry.[spec.FuncName] <- (typeIdx, funcTypeIdx, spec.Captures.Length)

    // Tail calls (incl. closure calls → return_call_ref) keep `let rec` / mutually recursive local
    // functions in constant stack space; before, only module-level functions got this treatment.
    let liftedBody = wrapLiftedBody typeIdx spec.Captures prelude body
    let func =
        { Name = spec.FuncName
          Params = ("$self", closureSelfTy) :: spec.ArgParams
          Result = spec.RetType
          Locals = []
          Body = (if spec.RetType <> WType.Void then WasmGc.Core.Traverse.markTailCalls spec.RetType liftedBody else liftedBody)
          Exported = false }
        |> Lc.resolveLocals
    ctx.Functions.Add func

    let captureExprs = spec.Captures |> List.map (fun (n, ty) -> WExpr.LocalGet(n, ty))
    WExpr.Closure(spec.FuncName, captureExprs, WType.Ref(typeIdx, false))

let buildOne (ctx: Ctx) (spec: ClosureSpec) (body: WExpr) : WExpr = buildOneWith ctx spec [] body

// ─────────────────────────────────────────────────────────────────
// High-level helpers used by TransformClosure.fs / TransformExpr.fs
// ─────────────────────────────────────────────────────────────────

/// Filter free variable names to those that are actual captures
/// (local in scope, not a module-level zero-arg function).
let filterCaptures (ctx: Ctx) (freeVarNames: string list) : (string * WType) list =
    freeVarNames
    |> List.filter (isCapturable ctx)
    |> List.map (fun name -> name, Map.tryFind name ctx.Locals |> Option.defaultValue WType.I32)
    |> List.filter (snd >> (<>) WType.Void)

/// Build a unique closure function name from a base name and current TypeDefs count.
let closureName (baseName: string) (ctx: Ctx) : string =
    let counter = System.Threading.Interlocked.Increment(ctx.ClosureCounter)
    sprintf "%s_%d" baseName counter

let private argParamsOf (ctx: Ctx) (args: Ident list) =
    args |> List.choose (fun a ->
        let ty = mapTypeKnown ctx a.Type
        if ty = WType.Void then None else Some(a.Name, ty))

/// Evaluation context for a lifted body: params + captures (+ extra closure-typed names).
let private liftedCtx (ctx: Ctx) funcName (argParams: (string * WType) list) captures extraLocals =
    let c =
        ctx
        |> withLocals (("$self", closureSelfTy) :: argParams)
        |> withLocals captures
        |> withLocals extraLocals
    { c with CurrentFunc = Some funcName }

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
    let argParams = argParamsOf ctx args
    let spec = { FuncName = funcName; ArgParams = argParams; Captures = captures
                 RetType = mapResultTypeKnown ctx body.Type }
    buildOne ctx spec (eval (liftedCtx ctx funcName argParams captures []) body)

/// Build the closures of a `let rec f = fun … [and g = fun …]` group and bind them around `contBody`.
///
///   n = 1:  let f = closure_f           (inside: `f` ≡ $self — no cell needed)
///   n > 1:  let cell_f = {null}; let cell_g = {null}          // all cells exist first
///           let f = closure_f(cell_g, …); let g = closure_g(cell_f, …)
///           cell_f.contents <- f; cell_g.contents <- g          // then they are tied
///           contBody
///           inside closure_f:  g ≡ (cast (cell_g.contents)), f ≡ $self
let buildLetRecLambdas
        (ctx      : Ctx)
        (eval     : Ctx -> Fable.Expr -> WExpr)
        (bindings : (Ident * Fable.Expr) list)
        (contBody : Fable.Expr)
        : WExpr =

    let anyFnNullTy = WType.Ref(AnyFnTypeIdx, true)
    let anyFnTy     = closureSelfTy

    // Decompose each binding into (ident, args, lambdaBody, nameHint)
    let lambdas =
        bindings |> List.map (fun (id, expr) ->
            match expr with
            | Lambda(arg, body, name)       -> id, [arg], body, name
            | Delegate(args, body, name, _) -> id, args, body, name
            | _ -> failwithf "buildLetRecLambdas: binding '%s' is not a lambda" id.Name)

    let n = lambdas.Length
    let names = lambdas |> List.map (fun (id, _, _, _) -> id.Name)
    let bindingNames = Set.ofList names
    let needCells = n > 1
    let cellTypeIdx = if needCells then getOrAddRefCellType ctx anyFnNullTy else -1
    let cellTy = WType.Ref(cellTypeIdx, false)
    // Unique per group: the same binding name (`loop`) is routinely reused by several groups.
    let groupId = System.Threading.Interlocked.Increment(ctx.ClosureCounter)
    let cellNames = names |> List.map (fun nm -> sprintf "$letrec_cell_%s_%d" nm groupId)

    // Free variables of all bodies (minus binding names and the lambda's own params)
    let commonCaptures =
        lambdas
        |> List.collect (fun (_, args, lbody, _) ->
            let bound = Set.union bindingNames (args |> List.map (fun a -> a.Name) |> Set.ofList)
            collectFreeVars bound lbody |> Set.toList)
        |> List.distinct
        |> filterCaptures ctx

    let buildAt (i: int) : WExpr =
        let (id, args, lbody, nameHint) = lambdas.[i]
        let funcName = closureName (defaultArg nameHint (sprintf "$letrec_%s" id.Name)) ctx
        let argParams = argParamsOf ctx args

        // Own cell is never needed (own name ≡ $self); siblings are reached through their cells.
        let siblingCells = if needCells then [ for j in 0 .. n - 1 do if j <> i then yield cellNames.[j], cellTy ] else []
        let captures = siblingCells @ commonCaptures

        let prelude =
            [ for j in 0 .. n - 1 ->
                names.[j],
                if j = i then WExpr.LocalGet("$self", anyFnTy)
                else WExpr.Cast(WExpr.StructGet(WExpr.LocalGet(cellNames.[j], cellTy), 0, anyFnNullTy), anyFnTy) ]

        let spec = { FuncName = funcName; ArgParams = argParams; Captures = captures
                     RetType = mapResultTypeKnown ctx lbody.Type }
        let bodyCtx = liftedCtx ctx funcName argParams captures (names |> List.map (fun nm -> nm, anyFnTy))
        buildOneWith ctx spec prelude (eval bodyCtx lbody)

    let closures = [ for i in 0 .. n - 1 -> buildAt i ]

    let contCtx = ctx |> withLocals (names |> List.map (fun nm -> nm, anyFnTy))
    let wCont = eval contCtx contBody

    let tie =
        if needCells then
            [ for j in 0 .. n - 1 ->
                WExpr.StructSet(WExpr.LocalGet(cellNames.[j], cellTy), 0, WExpr.LocalGet(names.[j], anyFnTy)) ]
        else []
    let inner = if tie.IsEmpty then wCont else WExpr.Sequence(tie @ [ wCont ])
    let bound = List.foldBack2 (fun nm clo acc -> WExpr.Let(nm, clo, acc)) names closures inner
    if not needCells then bound
    else
        List.foldBack
            (fun cn acc -> WExpr.Let(cn, WExpr.StructNew(cellTypeIdx, [ WExpr.Const(WConst.Null anyFnNullTy) ], cellTy), acc))
            cellNames bound

/// A module-level function used as a first-class value.
/// The raw function has no `$self` parameter, so a closure cannot point at it directly; a tiny
/// wrapper `(self, a…) -> f(a…)` is generated once per function and wrapped in a 0-capture closure.
let buildKnownFuncClosure (ctx: Ctx) (qn: string) (paramTys: WType list) (retTy: WType) : WExpr =
    let key = "$kf:" + qn
    let wrapperName = sprintf "$kfclo_%s" qn
    match ctx.ClosureRegistry.TryGetValue key with
    | true, (typeIdx, _, _) -> WExpr.Closure(wrapperName, [], WType.Ref(typeIdx, false))
    | _ ->
        let ps = paramTys |> List.filter (fun t -> t <> WType.Void)
        let funcTypeIdx = closureFuncType ctx ps retTy
        let baseIdx = getOrAddClosureBase ctx funcTypeIdx
        let typeIdx = addConcreteClosureType ctx baseIdx (WType.Ref(funcTypeIdx, false)) []
        let argParams = ps |> List.mapi (fun i t -> sprintf "$a%d" i, t)
        ctx.Functions.Add
            { Name = wrapperName
              Params = ("$self", closureSelfTy) :: argParams
              Result = retTy
              Locals = []
              Body =
                (let call = WExpr.Call(qn, argParams |> List.map WExpr.LocalGet, retTy)
                 if retTy <> WType.Void then WasmGc.Core.Traverse.markTailCalls retTy call else call)
              Exported = false }
        ctx.ClosureRegistry.[key] <- (typeIdx, funcTypeIdx, 0)
        WExpr.Closure(wrapperName, [], WType.Ref(typeIdx, false))

/// The first `n` parameter types of a function type (curried `LambdaType` chain or an exactly
/// matching `DelegateType`).
let rec private declaredParams (t: Fable.Type) (n: int) : Fable.Type list option =
    if n = 0 then Some []
    else
        match t with
        | Fable.LambdaType(a, r) -> declaredParams r (n - 1) |> Option.map (fun rest -> a :: rest)
        | Fable.DelegateType(ps, _) when ps.Length = n -> Some ps
        | _ -> None

let private isOpaque (t: Fable.Type) =
    match t with
    | Fable.GenericParam _ | Fable.Any -> true
    | _ -> false

/// Func type `(index, params incl. $self, result)` of a statically known closure: the code field of its concrete
/// `ClosureType_n` / `ClosureBase_n` struct.  That is how the closure was BUILT, whatever the use site believes.
let private knownFuncType (ctx: Ctx) (clo: WExpr) : (int * WType list * WType) option =
    match exprWType clo with
    | WType.Ref(idx, _) when idx > AnyFnTypeIdx && idx < ctx.TypeDefs.Count && ctx.TypeDefs.[idx].Name.StartsWith "Closure" ->
        match ctx.TypeDefs.[idx].Def with
        | WTypeDef.Struct(f :: _, _) ->
            match f.Type with
            | WType.Ref(fti, _) ->
                match ctx.TypeDefs.[fti].Def with
                | WTypeDef.Func(ps, r) -> Some(fti, ps, r)
                | _ -> None
            | _ -> None
        | _ -> None
    | _ -> None

/// Call closure `wClosure` (static Fable type `calleeTy`) with `wArgs`.
///
/// The func type is derived from the callee's DECLARED parameter types — the same source the
/// lifted function's signature came from — so `call_ref` and the code field always agree.
/// (Deriving it from the argument *expressions* breaks as soon as an argument's WASM type is a
/// subtype/nullability variant of the declared one, e.g. a concrete closure struct passed where
/// `ref $AnyFn` is declared.)  Opaque declared types (generic/any) fall back to the argument type.
let applyClosure (ctx: Ctx) (calleeTy: Fable.Type) (wClosure: WExpr) (fableArgs: Fable.Type list) (wArgs: WExpr list) (retTy: WType) : WExpr =
    // Declared types are only trusted when they line up 1:1 with the supplied arguments.
    let declared =
        if fableArgs.Length = wArgs.Length then declaredParams calleeTy wArgs.Length else None
    let argTys =
        wArgs
        |> List.mapi (fun i w ->
            let argTy = exprWType w
            match declared with
            | Some ds -> if isOpaque ds.[i] then argTy else mapTypeKnown ctx ds.[i]
            | None -> argTy)
    // Void-typed (unit) arguments are not passed at all.
    let kept = List.zip argTys wArgs |> List.filter (fun (t, w) -> t <> WType.Void && exprWType w <> WType.Void)
    let funcTypeIdx = closureFuncType ctx (kept |> List.map fst) retTy
    let cti = getOrAddClosureBase ctx funcTypeIdx
    let direct (clo: WExpr) (args: WExpr list) = WExpr.ClosureApply(clo, args, funcTypeIdx, cti, 0, retTy)

    match knownFuncType ctx wClosure with
    // Built with a different signature than the use site derives — typically a generic body such as
    // `let boom () = failwith "…"` (`unit -> 'a`, built returning i32) used as `unit -> unit`.  Call it as built.
    | Some(fti, ps, res) when fti <> funcTypeIdx && ps.Length - 1 = kept.Length ->
        let call = WExpr.ClosureApply(wClosure, kept |> List.map snd, fti, getOrAddClosureBase ctx fti, 0, res)
        if retTy = WType.Void && res <> WType.Void then WExpr.Sequence [ call; WExpr.Nop ] else call
    | _ ->

    if kept.Length < 2 || kept.Length <> wArgs.Length then
        direct wClosure (List.map snd kept)
    else
        // The closure object may be n-ary (a delegate) or curried — `fun a -> fun b -> …` is built as one
        // closure per parameter.  Like F#'s OptimizedClosures.Adapt: take the n-ary entry when the object
        // has it, otherwise apply one argument at a time.  Closure and arguments are bound first (in the
        // original evaluation order), so both paths share them and nothing is evaluated twice.
        let id = System.Threading.Interlocked.Increment(ctx.ClosureCounter)
        let cloName = sprintf "$ap_clo_%d" id
        let cloRef = WExpr.LocalGet(cloName, exprWType wClosure)
        let bound = kept |> List.mapi (fun i (declTy, a) -> sprintf "$ap_arg_%d_%d" id i, declTy, a)
        let argRefs = bound |> List.map (fun (n, _, a) -> WExpr.LocalGet(n, exprWType a))

        let curried =
            let rec go (f: WExpr) (rest: (WType * WExpr) list) =
                match rest with
                | [] -> f
                | (declTy, arg) :: tail ->
                    let ret = if tail.IsEmpty then retTy else closureSelfTy
                    let fti = closureFuncType ctx [ declTy ] ret
                    go (WExpr.ClosureApply(f, [ arg ], fti, getOrAddClosureBase ctx fti, 0, ret)) tail
            go cloRef (List.zip (bound |> List.map (fun (_, t, _) -> t)) argRefs)

        let dispatch = WExpr.If(WExpr.RefTest(cloRef, WType.Ref(cti, false)), direct cloRef argRefs, curried, retTy)
        let withArgs = List.foldBack (fun (n, _, a) body -> WExpr.Let(n, a, body)) bound dispatch
        WExpr.Let(cloName, wClosure, withArgs)
