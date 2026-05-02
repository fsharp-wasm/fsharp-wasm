/// Scope — unified identifier resolution for Phase 3 (Fable → WExpr).
///
/// Resolution order (first match wins):
///   1. Local variable  (ctx.Locals)
///   2. Closure capture (ctx.ScopeMaps → FreeVar entries)
///   3. Zero-arg module function (ctx.KnownFuncs with [])
///   4. Known function reference (ctx.KnownFuncs with params)
///   5. Extern import   (ctx.ExternImports)
///   6. Unresolved      → I32 fallback + warning
///
/// Used by: TransformExpr.transformIdentExpr
///          TransformClosure.buildClosure (freeVarNames filter)
///          TransformDispatch.buildCurriedApply
module WasmGc.Pipeline.Scope

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Resolution result
// ─────────────────────────────────────────────────────────────────

/// What kind of thing a resolved identifier is.
[<RequireQualifiedAccess>]
type Resolution =
    /// let x = 42  —  read from a Wasm local.
    | Local       of name: string * ty: WType
    /// Captured closure variable — read from local in this scope.
    | CapturedVar of name: string * ty: WType
    /// Zero-arg module-level function — emit a Call with no args.
    | ModuleValue of qualifiedName: string * retTy: WType
    /// Multi-arg known function — emit a partial application / funcref.
    | KnownFunc   of qualifiedName: string * paramTys: WType list * retTy: WType
    /// [<Import>] extern — already registered, emit Call($ext$...).
    | ExternFunc  of internalName: string * retTy: WType
    /// Unresolvable — emit LocalGet as a fallback (Validator will catch it).
    | Unknown     of name: string

/// Resolve `name` in the given context.
/// `funcName` is the current function being compiled (for ScopeMap lookup).
let resolve (ctx: Ctx) (funcName: string option) (name: string) : Resolution =
    // 1. Local variable
    match Map.tryFind name ctx.Locals with
    | Some ty -> Resolution.Local(name, ty)
    | None ->

    // 2. Closure capture (ScopeMap from Phase 1)
    let inScopeMap =
        funcName
        |> Option.bind (fun fn -> Map.tryFind fn ctx.ScopeMaps)
        |> Option.bind (fun sm -> Map.tryFind name sm)
    match inScopeMap with
    | Some { Kind = ScopeKind.FreeVar; WType = ty } -> Resolution.CapturedVar(name, ty)
    | Some { Kind = ScopeKind.Local;   WType = ty } -> Resolution.Local(name, ty)
    | _ ->

    // 3 & 4. Known function (module-level or multi-arg)
    let qualName =
        ctx.FuncNameAlias |> Map.tryFind name |> Option.defaultValue name
    match Map.tryFind qualName ctx.KnownFuncs with
    | Some([], retTy)           -> Resolution.ModuleValue(qualName, retTy)
    | Some(paramTys, retTy)     -> Resolution.KnownFunc(qualName, paramTys, retTy)
    | None ->

    // 5. Extern import
    let extKey = sprintf "$ext$%s" name
    match ctx.ExternImports.TryGetValue(extKey) with
    | true, imp -> Resolution.ExternFunc(extKey, imp.ReturnType)
    | _ ->

    // 6. Fallback
    Resolution.Unknown name

/// Emit a WExpr for the resolved identifier.
/// `warnUnknown`: if true, logs a warning for Unknown resolutions (Phase 3 mode).
let toExpr (res: Resolution) (warnUnknown: bool) : WExpr =
    match res with
    | Resolution.Local(name, ty)
    | Resolution.CapturedVar(name, ty)      -> WExpr.LocalGet(name, ty)
    | Resolution.ModuleValue(qn, retTy)     -> WExpr.Call(qn, [], retTy)
    | Resolution.KnownFunc(qn, ps, retTy)   ->
        // Return a funcref — call site will wrap in a closure or apply directly
        WExpr.FuncRef qn
    | Resolution.ExternFunc(key, retTy)     -> WExpr.Call(key, [], retTy)
    | Resolution.Unknown name               ->
        if warnUnknown then
            eprintfn "  [Scope] WARNING: unresolved identifier '%s' → LocalGet fallback" name
        WExpr.LocalGet(name, WType.I32)

/// True when the identifier resolves to a module-level zero-arg function.
/// Used by buildClosure to exclude module values from capture lists.
let isModuleValue (ctx: Ctx) (name: string) : bool =
    let qualName = ctx.FuncNameAlias |> Map.tryFind name |> Option.defaultValue name
    match Map.tryFind qualName ctx.KnownFuncs with
    | Some([], _) -> true
    | _           -> false

/// True when the identifier is a local variable in scope.
let isLocal (ctx: Ctx) (name: string) : bool =
    Map.containsKey name ctx.Locals

/// True when the identifier is capturable (local and NOT a module-level value).
let isCapturable (ctx: Ctx) (name: string) : bool =
    isLocal ctx name && not (isModuleValue ctx name)

// ─────────────────────────────────────────────────────────────────
// Ctx extension helpers — fluent context building
// ─────────────────────────────────────────────────────────────────
// These are already on Ctx via WithLocal etc., but documented here
// for discoverability.

/// Add a batch of (name, WType) locals to ctx — used when entering a function scope.
let withLocals (locals: (string * WType) list) (ctx: Ctx) : Ctx =
    locals |> List.fold (fun c (n, t) -> c.WithLocal(n, t)) ctx

/// Add a batch of known functions to ctx — used during TransformMemberDecl pre-scan.
let withKnownFuncs (funcs: (string * (WType list * WType)) list) (ctx: Ctx) : Ctx =
    funcs |> List.fold (fun c (n, sig_) -> c.WithKnownFunc(n, sig_)) ctx

/// Enter a new function scope: add params as locals, set CurrentFunc.
let enterFunc (name: string) (parms: (string * WType) list) (ctx: Ctx) : Ctx =
    { withLocals parms ctx with CurrentFunc = Some name }
