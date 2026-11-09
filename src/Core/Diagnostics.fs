/// WasmGc Compiler Diagnostics — structured error/warning collection.
///
/// Replaces scattered eprintfn calls with a bag that:
///   - Tracks severity (Error | Warning)
///   - Includes source location (file, line, column)  
///   - Supports structured pretty-printing
///   - Can abort compilation on the first error or collect all errors
///
/// Invariant: a Diagnostic with Severity.Error MUST cause compilation to halt
/// before emitting WASM. A Warning is logged but does not block output.
module WasmGc.Core.Diagnostics

open Fable.AST

// ─────────────────────────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────────────────────────

[<RequireQualifiedAccess>]
type Severity = | Error | Warning | Note

type SourceLoc =
    { File   : string
      Line   : int
      Column : int }

    override this.ToString() =
        sprintf "%s(%d,%d)" this.File this.Line this.Column

    static member FromFable(r: SourceLocation) =
        { File   = defaultArg r.File "<unknown>"
          Line   = r.start.line
          Column = r.start.column }

    static member Unknown = { File = "<unknown>"; Line = 0; Column = 0 }

type Diagnostic =
    { Severity : Severity
      Code     : string          // e.g. "WGC001", "WGC002"
      Location : SourceLoc
      FuncName : string option   // current function being compiled
      Message  : string
      Hint     : string option   // optional actionable hint
    }

    override d.ToString() =
        let sev = match d.Severity with
                  | Severity.Error   -> "error"
                  | Severity.Warning -> "warning"
                  | Severity.Note    -> "note"
        let func = d.FuncName |> Option.map (sprintf " in '%s'") |> Option.defaultValue ""
        let hint = d.Hint |> Option.map (sprintf "\n    hint: %s") |> Option.defaultValue ""
        sprintf "%O: %s[%s]%s: %s%s" d.Location sev d.Code func d.Message hint

// ─────────────────────────────────────────────────────────────────────────────
// Diagnostic codes — single place, discoverable
// ─────────────────────────────────────────────────────────────────────────────

[<RequireQualifiedAccess>]
module Code =
    /// Unknown identifier — not in locals, KnownFuncs, or ExternImports.
    let UnresolvedIdent    = "WGC001"
    /// Import call pattern not handled by backend — emitting Nop.
    let UnhandledImport    = "WGC002"
    /// call_ref arity mismatch detected by pre-emit validator.
    let ArityMismatch      = "WGC003"
    /// Duplicate Wasm export name.
    let DuplicateExport    = "WGC004"
    /// Type mismatch: expected Ref, got I32 (from Unknown ident fallback).
    let TypeMismatch       = "WGC005"
    /// Local variable used before initialization.
    let UninitializedLocal = "WGC006"
    /// Generic monomorphization limit hit.
    let MonoLimit          = "WGC007"
    /// transformExpr returned Nop for a non-Unit-typed expression — the
    /// enclosing Let/If/struct.new will be missing a stack value.
    let NonVoidNop         = "WGC008"
    /// Call through a computed callee that is neither a closure nor a handled member call.
    let UnhandledCallee    = "WGC009"
    /// A non-Unit `let` whose value compiled to nothing — the local keeps its default
    /// and fails validation later as an uninitialized local.
    let ValuelessBinding   = "WGC010"

// ─────────────────────────────────────────────────────────────────────────────
// Diagnostic bag
// ─────────────────────────────────────────────────────────────────────────────

type DiagnosticBag() =
    let items = System.Collections.Generic.List<Diagnostic>()

    member _.Add(d: Diagnostic) = items.Add(d)

    member this.Error(code, loc, ?func, ?msg, ?hint) =
        items.Add {
            Severity = Severity.Error
            Code     = code
            Location = loc
            FuncName = func
            Message  = defaultArg msg "compiler error"
            Hint     = hint
        }

    member this.Warn(code, loc, ?func, ?msg, ?hint) =
        items.Add {
            Severity = Severity.Warning
            Code     = code
            Location = loc
            FuncName = func
            Message  = defaultArg msg "compiler warning"
            Hint     = hint
        }

    member _.All    = items :> seq<Diagnostic>
    member _.Errors = items |> Seq.filter (fun d -> d.Severity = Severity.Error)
    member _.HasErrors = items |> Seq.exists (fun d -> d.Severity = Severity.Error)
    member _.Count  = items.Count

    /// Print all diagnostics to stderr in a format parseable by editors.
    member _.Flush() =
        if items.Count > 0 then
            let errors   = items |> Seq.filter (fun d -> d.Severity = Severity.Error) |> Seq.length
            let warnings = items |> Seq.filter (fun d -> d.Severity = Severity.Warning) |> Seq.length
            eprintfn ""
            eprintfn "── WasmGc Diagnostics ──────────────────────────────────────────────────────"
            for d in items do
                eprintfn "%O" d
            eprintfn "────────────────────────────────────────────────────────────────────────────"
            eprintfn "Summary: %d error(s), %d warning(s)" errors warnings
            eprintfn ""

    /// Flush and abort if any errors were recorded.
    member this.FailOnErrors(phase: string) =
        this.Flush()
        if this.HasErrors then
            let n = this.Errors |> Seq.length
            failwithf "[WasmGc] Compilation aborted at %s with %d error(s)" phase n

// ─────────────────────────────────────────────────────────────────────────────
// Convenience constructors
// ─────────────────────────────────────────────────────────────────────────────

let unresolvedIdent
        (bag: DiagnosticBag)
        (name: string)
        (funcName: string option)
        (range: SourceLocation option)
        : unit =
    let loc = range |> Option.map SourceLoc.FromFable |> Option.defaultValue SourceLoc.Unknown
    bag.Warn(
        Code.UnresolvedIdent, loc,
        func = defaultArg funcName "<global>",
        msg  = sprintf "Unresolved identifier '%s' — not in locals, KnownFuncs, or ExternImports." name,
        hint = "Check that the identifier is in scope and that all files are in the correct compilation order.")

let unhandledImport
        (bag: DiagnosticBag)
        (importName: string)
        (fromFile: string)
        (funcName: string option)
        : unit =
    bag.Warn(
        Code.UnhandledImport, SourceLoc.Unknown,
        func = defaultArg funcName "<global>",
        msg  = sprintf "Unhandled import call '%s' from '%s' — emitting Nop." importName fromFile,
        hint = sprintf "Add a handler for '%s' in FSharpCoreReplacements or TransformExpr." importName)

let nonVoidNop
        (bag: DiagnosticBag)
        (exprDescription: string)
        (funcName: string option)
        (range: SourceLocation option)
        : unit =
    let loc = range |> Option.map SourceLoc.FromFable |> Option.defaultValue SourceLoc.Unknown
    // Truncate — Fable.Expr `%A` dumps can be enormous (nested ASTs).
    let desc =
        if exprDescription.Length > 160 then exprDescription.Substring(0, 160) + " …"
        else exprDescription
    bag.Error(
        Code.NonVoidNop, loc,
        func = defaultArg funcName "<global>",
        msg  = sprintf "Expression of non-Unit type compiled to Nop (produces no value): %s" desc,
        hint = "This expression shape is unhandled in TransformExpr/TransformDispatch. \
                The enclosing Let/If/struct.new now has a missing operand and the \
                function WILL fail WAT/WASM validation. Add a case for this expression.")

let unhandledCallee
        (bag: DiagnosticBag)
        (calleeDescription: string)
        (funcName: string option)
        (range: SourceLocation option)
        : unit =
    let loc = range |> Option.map SourceLoc.FromFable |> Option.defaultValue SourceLoc.Unknown
    let desc =
        let flat = calleeDescription.Replace("\r", "").Replace("\n", " ")
        if flat.Length > 240 then flat.Substring(0, 240) + " …" else flat
    bag.Error(
        Code.UnhandledCallee, loc,
        func = defaultArg funcName "<global>",
        msg  = sprintf "Call through a callee that is not a function value: %s" desc,
        hint = "Not a closure (LambdaType/DelegateType) and not a handled member call. \
                Add a case for this callee shape in TransformDispatch.transformCall.")

let valuelessBinding
        (bag: DiagnosticBag)
        (identName: string)
        (valueDescription: string)
        (funcName: string option)
        (range: SourceLocation option)
        : unit =
    let loc = range |> Option.map SourceLoc.FromFable |> Option.defaultValue SourceLoc.Unknown
    let desc =
        let flat = valueDescription.Replace("\r", "").Replace("\n", " ")
        if flat.Length > 160 then flat.Substring(0, 160) + " …" else flat
    bag.Error(
        Code.ValuelessBinding, loc,
        func = defaultArg funcName "<global>",
        msg  = sprintf "Binding '%s' has a non-Unit type but its value compiled to nothing: %s" identName desc,
        hint = "The value expression is unhandled in TransformExpr/TransformDispatch, so the local \
                is never initialized and the function WILL fail WAT/WASM validation.")
