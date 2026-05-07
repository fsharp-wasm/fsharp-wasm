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

// ─────────────────────────────────────────────────────────────────
// Core resolution
// ─────────────────────────────────────────────────────────────────


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

    // 3 & 4. Known function  (module-level or multi-arg)
    let qualName = ctx.FuncNameAlias |> Map.tryFind name |> Option.defaultValue name
    match Map.tryFind qualName ctx.KnownFuncs with
    | Some([], retTy)       -> Resolution.ModuleValue(qualName, retTy)
    | Some(paramTys, retTy) -> Resolution.KnownFunc(qualName, paramTys, retTy)
    | None ->

    // 5. Extern import
    // WImport.Desc: WImportDesc — return type is inside ImportFunc(_, result)
    let extKey = sprintf "$ext$%s" name
    match ctx.ExternImports.TryGetValue(extKey) with
    | true, imp ->
        let retTy =
            match imp.Desc with
            | ImportFunc(_, result) -> result
            | ImportGlobal(ty, _)   -> ty
            | _                     -> WType.Void
        Resolution.ExternFunc(extKey, retTy)
    | _ ->

    // 6. Fallback
    Resolution.Unknown name

/// Emit a WExpr for the resolved identifier.
/// `warn`: if true, logs a warning for Unknown resolutions (Phase 3 mode).
let toExpr (res: Resolution) (warn: bool) : WExpr =
    match res with
    | Resolution.Local(n, ty)
    | Resolution.CapturedVar(n, ty)      -> WExpr.LocalGet(n, ty)
    | Resolution.ModuleValue(qn, retTy)  -> WExpr.Call(qn, [], retTy)
    | Resolution.KnownFunc(qn, _, _)     -> WExpr.FuncRef qn
    | Resolution.ExternFunc(key, retTy)  -> WExpr.Call(key, [], retTy)
    | Resolution.Unknown name            ->
        // Note: callers should emit diagnostics via ctx.Diagnostics rather than
        // calling this path. toExpr is kept for legacy call sites only.
        if warn then
            eprintfn "  [WGC001] unresolved identifier '%s'" name
        WExpr.LocalGet(name, WType.I32)   // type I32 is a fallback; callers should use mapTypeKnown

/// True when the identifier resolves to a module-level zero-arg function.
/// Used by buildClosure to exclude module values from capture lists.
let isModuleValue (ctx: Ctx) (name: string) : bool =
    let q = ctx.FuncNameAlias |> Map.tryFind name |> Option.defaultValue name
    match Map.tryFind q ctx.KnownFuncs with Some([], _) -> true | _ -> false

/// True when the identifier is a local variable in scope.
let isLocal      (ctx: Ctx) (name: string) : bool = Map.containsKey name ctx.Locals

/// True when the identifier is capturable (local and NOT a module-level value).
let isCapturable (ctx: Ctx) (name: string) : bool = isLocal ctx name && not (isModuleValue ctx name)

// ─────────────────────────────────────────────────────────────────
// Ctx extension helpers — fluent context building
// ─────────────────────────────────────────────────────────────────


let withLocals (locals: (string * WType) list) (ctx: Ctx) : Ctx =
    locals |> List.fold (fun c (n, t) -> c.WithLocal(n, t)) ctx

// TODO: still used?
let withKnownFunc (name: string) (parms: WType list) (retTy: WType) (ctx: Ctx) : Ctx =
    { ctx with KnownFuncs = Map.add name (parms, retTy) ctx.KnownFuncs }

// TODO: should it be inside ctx? maybe with caching?
let withKnownFuncs (funcs: (string * (WType list * WType)) list) (ctx: Ctx) : Ctx =
    funcs |> List.fold (fun c (n, sig_) ->
        { c with KnownFuncs = Map.add n sig_ c.KnownFuncs }) ctx

/// Enter a new function scope: add params as locals, set CurrentFunc.
let enterFunc (name: string) (parms: (string * WType) list) (ctx: Ctx) : Ctx =
    { withLocals parms ctx with CurrentFunc = Some name }



// ─────────────────────────────────────────────────────────────────
// Debug helperss
// ─────────────────────────────────────────────────────────────────
// TODO: refactor to a separate module

// /// ANSI Color Helper
// let inline color (code: string) (text: string) = sprintf "\x1b[%sm%s\x1b[0m" code text

// /// Der Profi-Formatter für eprintfn %a
// let format (tw: TextWriter) (res: Resolution) =
//     let output =
//         match res with

//         | Resolution.Local(n, ty)        -> color "92" (sprintf "LOCAL(%s: %A)" n ty)
//         | Resolution.CapturedVar(n, ty)  -> color "96" (sprintf "CAPTURED(%s: %A)" n ty)
//         | Resolution.ModuleValue(qn, ty) -> color "94" (sprintf "MOD-VAL(%s: %A)" qn ty)

//         | Resolution.KnownFunc(qn, p, r) -> color "95" (sprintf "K-FUNC(%s: %A->%A)" qn p r)
//         | Resolution.ExternFunc(key, ty) -> color "93" (sprintf "EXTERN(%s: %A)" key ty)
//         | Resolution.Unknown n           -> color "91" (sprintf "!! UNKNOWN(%s) !!" n)
    
//     tw.Write(output)

/// Debug-Print für das Resultat einer Auflösung.
// let debugResolution (name: string) (res: Resolution) =
//     let tag, detail, color = 
//         match res with

//         | Resolution.Local(n, ty)        -> "LOCAL ", sprintf "%s : %A" n ty, "92" // Grün
//         | Resolution.CapturedVar(n, ty)  -> "CAPTUR ", sprintf "%s : %A" n ty, "96" // Cyan
//         | Resolution.ModuleValue(qn, ty) -> "M-VAL ", sprintf "%s : %A" qn ty, "94" // Blau

//         | Resolution.KnownFunc(qn, p, r) -> "K-FUNC", sprintf "%s (%A -> %A)" qn p r, "95" // Magenta
//         | Resolution.ExternFunc(key, ty) -> "EXTERN", sprintf "%s : %A" key ty, "93" // Gelb
//         | Resolution.Unknown n           -> "UNKNOWN", n, "91" // Rot

//     // TODO: we need a library for colored console output, this is just a quick hack
//     // Format: [Scope] -> NAME => [TAG] Details
//     eprintfn "  \x1b[90m[Scope]\x1b[0m %-15s \x1b[1m=>\x1b[0m \x1b[%sm[%s]\x1b[0m %s" 
//             name color tag detail

// let debugResolution (prefix: string) (res: Resolution) =
//     let color code text = sprintf "\x1b[%sm%s\x1b[0m" code text
    
//     let msg = 
//         match res with

//         | Local(n, ty)        -> color "92" (sprintf "[LOCAL] %s : %A" n ty)
//         | CapturedVar(n, ty)  -> color "96" (sprintf "[CAPTURED] %s : %A" n ty)
//         | ModuleValue(qn, ty) -> color "94" (sprintf "[MOD-VAL] %s : %A" qn ty)

//         | KnownFunc(qn, p, r) -> color "95" (sprintf "[K-FUNC] %s (%A->%A)" qn p r)
//         | ExternFunc(key, ty) -> color "93" (sprintf "[EXTERN] %s : %A" key ty)
//         | Unknown n           -> color "91" (sprintf "[UNKNOWN] %s" n)

//     // WICHTIG: Nur EIN eprintfn Aufruf für die ganze Zeile verhindert das Vermischen
//     eprintfn "  %s %s" prefix msg


// let debugResolution (ctx: Ctx) (name: string) (res: Resolution) =
//     let color code text = sprintf "\x1b[%sm%s\x1b[0m" code text
//     let ctxName = defaultArg ctx.CurrentFunc "Global"

//     match res with


//     | Resolution.Unknown n ->
//         // Hier ist die echte Hilfe: Was war eigentlich verfügbar?
//         let locals = ctx.Locals |> Map.keys |> String.concat ", "
//         let funcs  = ctx.KnownFuncs |> Map.keys |> Seq.truncate 5 |> String.concat ", "
        
//         eprintfn "  %s %s" (color "91" "[SCOPE ERROR]") (color "1" n)
//         eprintfn "    \x1b[90m├─ Function:\x1b[0m %s" ctxName
//         eprintfn "    \x1b[90m├─ Locals  :\x1b[0m [%s]" (if locals = "" then "none" else locals)
//         eprintfn "    \x1b[90m└─ Knowns  :\x1b[0m [%s...]" funcs

//     | _ -> 
//         // Kompakte Erfolgsmeldung
//         printfn "  \x1b[92m[OK]\x1b[0m %s -> %A" name res

let debugResolution (ctx: Ctx) (range: Fable.AST.SourceLocation option) (name: string) (res: Resolution) =
    let color code text = sprintf "\x1b[%sm%s\x1b[0m" code text
    
    // Ortsangabe extrahieren
    let loc = 
        match range with

        | Some r -> sprintf "%A(%d,%d)" r.File r.start.line r.start.column
        | None   -> "unknown-location"

    match res with

    | Resolution.Unknown n ->
        let msg = 
            [
                color "91;1" (sprintf "\n[RESOLVE ERROR] unresolved ident '%s' in '%A'" n ctx.CurrentFunc)
                color "90"   (sprintf "  Location: %s" loc)
                color "90"   (sprintf "  Function: %s" (defaultArg ctx.CurrentFunc "Global"))
                color "93"   (sprintf "  Locals  : [%s]" (ctx.Locals |> Map.keys |> String.concat ", "))
            ] |> String.concat "\n"
        
        // EIN eprintfn Aufruf für den gesamten Block verhindert das Zerhäckseln durch Threads
        eprintfn "%s\n" msg
    | _ -> ()
