/// Quotation-to-WExpr translator for WasmGC runtime helpers.
///
/// Translates [<ReflectedDefinition>] F# functions into WFuncDecl,
/// making WasmGcRuntime.fs helpers writable as plain, readable F#.
///
/// Status: Core walker is complete.  WasmStr indexer/member support
///         is provided with phantom [<WasmIntrinsic>]-tagged methods.
///         Port helpers by annotating with [<ReflectedDefinition>] and
///         calling translateReflected in your makeAllHelpers function.
///
/// Design principles:
///   • Only covers monomorphic value-type F# — no classes, interfaces, or
///     captured lambdas (closures handled by Fable2WasmGc).
///   • Supported: let/let mutable, while, if-then-else, arithmetic, comparisons,
///     array indexing, Array.zeroCreate, explicit WasmIntrinsic calls.
///   • Not supported (clear error message): tuples, object expressions, match.
module Fable.Transforms.WasmGc.WasmGcQuotationWalker

open Microsoft.FSharp.Quotations
open Microsoft.FSharp.Quotations.Patterns
open Microsoft.FSharp.Quotations.DerivedPatterns
open System
open System.Reflection

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder

// ─────────────────────────────────────────────────────────────────────────────
// Intrinsic attribute
// ─────────────────────────────────────────────────────────────────────────────

/// Marks a method or property as representing a WasmGC intrinsic operation.
/// The quotation walker replaces calls to this member with the corresponding
/// WExpr primitive (looked up in the Intrinsics map by the attribute's name).
[<AttributeUsage(AttributeTargets.Method ||| AttributeTargets.Property)>]
type WasmIntrinsicAttribute(name: string) =
    inherit System.Attribute()
    member _.Name = name

// ─────────────────────────────────────────────────────────────────────────────
// Phantom type for WasmStr — used ONLY in [<ReflectedDefinition>] sources
// ─────────────────────────────────────────────────────────────────────────────

/// Phantom type representing a WasmGC array-of-i32 (our string representation).
/// Used as parameter/return types in quoted helper functions.
/// Never instantiated at runtime — only exists in F# quotations.
[<Struct>]
type WasmStr = WasmStr

// ─────────────────────────────────────────────────────────────────────────────
// Phantom intrinsic helpers
//
// Use these in [<ReflectedDefinition>] helper functions instead of direct
// array operations.  The quotation walker intercepts calls to these via
// [<WasmIntrinsic>] reflection and emits the correct WExpr.
//
// Example:
//   [<ReflectedDefinition>]
//   let strLen (s: WasmStr) : int =
//       wsLen s
// ─────────────────────────────────────────────────────────────────────────────

/// String length.  Translated to arrayLen. Never called at runtime.
[<WasmIntrinsic("$wasmStr_length")>]
let wsLen (_s: WasmStr) : int = failwith "phantom intrinsic"

/// String character at index.  Translated to arrayGet s i I32. Never called at runtime.
[<WasmIntrinsic("$wasmStr_get")>]
let wsGet (_s: WasmStr) (_i: int) : int = failwith "phantom intrinsic"

/// Allocate a new zero-filled WasmStr of `n` chars.
/// Translated to arrayNew StringTypeIdx n 0. Never called at runtime.
[<WasmIntrinsic("$wasmStr_create")>]
let wsCreate (_n: int) : WasmStr = WasmStr  // dummy — never executed

/// Allocate a new WasmStr of `n` chars all filled with `fill`.
/// Translated to arrayNew StringTypeIdx n fill. Never called at runtime.
[<WasmIntrinsic("$wasmStr_createFill")>]
let wsCreateFill (_n: int) (_fill: int) : WasmStr = WasmStr  // dummy — never executed

/// Set character at index `i` in `s` to `v`.
/// Translated to arraySet s i v. Never called at runtime.
[<WasmIntrinsic("$wasmStr_set")>]
let wsSet (_s: WasmStr) (_i: int) (_v: int) : unit = ()  // dummy — never executed

/// Copy `len` chars from `src` starting at `srcOff` into `dst` starting at `dstOff`.
/// Translated to array.copy. Never called at runtime.
[<WasmIntrinsic("$wasmStr_copy")>]
let wsCopy (_dst: WasmStr) (_dstOff: int) (_src: WasmStr) (_srcOff: int) (_len: int) : unit = ()  // dummy — never executed

// ─────────────────────────────────────────────────────────────────────────────
// Float phantom intrinsics
// ─────────────────────────────────────────────────────────────────────────────

/// Truncate f64 to i32 (toward zero).  Translated to i32.trunc_f64_s.
[<WasmIntrinsic("$f64_trunc_i32")>]
let truncF64 (_f: float) : int = failwith "phantom intrinsic"

/// Absolute value of f64.  Translated to f64.abs.
[<WasmIntrinsic("$f64_abs")>]
let absF64 (_f: float) : float = failwith "phantom intrinsic"

/// f64 negation.  Translated to f64.neg.
[<WasmIntrinsic("$f64_neg")>]
let negF64 (_f: float) : float = failwith "phantom intrinsic"

/// Convert i32 to f64 (signed).  Translated to f64.convert_i32_s.
[<WasmIntrinsic("$i32_to_f64")>]
let intToF64 (_n: int) : float = failwith "phantom intrinsic"

// ─────────────────────────────────────────────────────────────────────────────
// StringBuilder phantom struct + struct intrinsics
// ─────────────────────────────────────────────────────────────────────────────

/// Phantom struct representing a WasmGC $StringBuilder.
/// Layout: { data: ref $WasmStr; len: i32; cap: i32 }
/// Never instantiated at runtime — only used in [<ReflectedDefinition>] quotations.
[<Struct>]
type SbStruct = SbStruct

/// struct.new $StringBuilder [data; len; cap]
[<WasmIntrinsic("$sb_new")>]
let sbNew (_data: WasmStr) (_len: int) (_cap: int) : SbStruct = SbStruct

/// struct.get $StringBuilder 0 → ref $WasmStr  (the data buffer)
[<WasmIntrinsic("$sb_buf_get")>]
let sbBuf (_sb: SbStruct) : WasmStr = WasmStr

/// struct.set $StringBuilder 0  (replace data buffer)
[<WasmIntrinsic("$sb_buf_set")>]
let sbSetBuf (_sb: SbStruct) (_data: WasmStr) : unit = ()

/// struct.get $StringBuilder 1 → i32  (current length)
[<WasmIntrinsic("$sb_len_get")>]
let sbLen (_sb: SbStruct) : int = 0

/// struct.set $StringBuilder 1  (update length)
[<WasmIntrinsic("$sb_len_set")>]
let sbSetLen (_sb: SbStruct) (_len: int) : unit = ()

/// struct.get $StringBuilder 2 → i32  (capacity)
[<WasmIntrinsic("$sb_cap_get")>]
let sbCap (_sb: SbStruct) : int = 0

/// struct.set $StringBuilder 2  (update capacity)
[<WasmIntrinsic("$sb_cap_set")>]
let sbSetCap (_sb: SbStruct) (_cap: int) : unit = ()

// ─────────────────────────────────────────────────────────────────────────────
// Type mapping — System.Type → WType
// ─────────────────────────────────────────────────────────────────────────────

/// Configuration for the quotation translator: how to map F# types to WTypes.
type QTypeMap = {
    /// Type index of the WasmStr array type (pre-registered at index StringTypeIdx).
    StrTypeIdx    : int
    /// Type index of the StringBuilder GC struct (pre-registered at StringBuilderTypeIdx).
    SbTypeIdx     : int
    /// Custom type resolver for project-specific struct types.
    /// Return None to let the walker raise an error for unknown types.
    ResolveCustom : System.Type -> WType option
}

let private toWType (tm: QTypeMap) (t: System.Type) : WType =
    if   t = typeof<int>    || t = typeof<int32>  then WType.I32
    elif t = typeof<int64>                         then WType.I64
    elif t = typeof<float>                         then WType.F64
    elif t = typeof<float32>                       then WType.F32
    elif t = typeof<bool>                          then WType.I32  // booleans are i32 in WASM
    elif t = typeof<char>                          then WType.I32  // chars are Unicode code-points
    elif t = typeof<unit>                          then WType.Void
    elif t = typeof<WasmStr>                       then WType.Ref(tm.StrTypeIdx, false)
    elif t = typeof<SbStruct>                      then WType.Ref(tm.SbTypeIdx,  false)
    else
        match tm.ResolveCustom t with
        | Some wty -> wty
        | None     -> failwithf "WasmQuotationWalker: no WType mapping for %s. Add to QTypeMap.ResolveCustom." t.FullName

// ─────────────────────────────────────────────────────────────────────────────
// Translation context
// ─────────────────────────────────────────────────────────────────────────────

type private QCtx = {
    TypeMap    : QTypeMap
    /// Known runtime intrinsics: declared-name → WExpr builder.
    /// Populated by the caller (typically from standardIntrinsics).
    Intrinsics : Map<string, WExpr list -> WExpr>
    /// Shared counter for fresh label generation.
    LabelN     : int ref
}

let private freshLbl (ctx: QCtx) (tag: string) =
    let n = System.Threading.Interlocked.Increment(ctx.LabelN)
    $"$q_{tag}_{n}"

let private wty (ctx: QCtx) (t: System.Type) = toWType ctx.TypeMap t

/// Prefix for quotation-source local variables.
let private localPfx (v: Var) = "$" + v.Name

// ─────────────────────────────────────────────────────────────────────────────
// Core translator
// ─────────────────────────────────────────────────────────────────────────────

let rec private tx (ctx: QCtx) (expr: Expr) : WExpr =
    match expr with

    // ── Constants ────────────────────────────────────────────────────────────
    | Int32  n  -> i32Const n
    | Int64  n  -> i64Const n
    | Double f  -> f64Const f
    | Single f  -> f32Const f
    | Bool   b  -> i32Const (if b then 1 else 0)
    | Value(v, t) when t = typeof<char>  -> i32Const (int (v :?> char))
    | Value(_, t) when t = typeof<unit>  -> WExpr.Nop
    | Value(v, t) ->
        failwithf "WasmQuotationWalker: unhandled constant %A : %s — only int/int64/float/bool/char/unit are supported." v t.FullName

    // ── Variables ────────────────────────────────────────────────────────────
    | Var v ->
        localGet (localPfx v) (wty ctx v.Type)

    // ── Let (immutable) ──────────────────────────────────────────────────────
    | Let(v, e, body) when not v.IsMutable ->
        WExpr.Let(localPfx v, tx ctx e, tx ctx body)

    // ── Let mutable ──────────────────────────────────────────────────────────
    | Let(v, e, body) when v.IsMutable ->
        WExpr.LetMut(localPfx v, tx ctx e, tx ctx body)

    // ── VarSet (x <- e) ──────────────────────────────────────────────────────
    | VarSet(v, e) ->
        localSet (localPfx v) (tx ctx e)

    // ── Sequential (a; b) ────────────────────────────────────────────────────
    | Sequential(a, b) ->
        sequence [tx ctx a; tx ctx b]

    // ── If-then-else ─────────────────────────────────────────────────────────
    | IfThenElse(cond, thenE, elseE) ->
        wasmIf (tx ctx cond) (tx ctx thenE) (tx ctx elseE)

    // ── While loop ───────────────────────────────────────────────────────────
    | WhileLoop(cond, body) ->
        let lbl = freshLbl ctx "wl"
        whileLoop lbl (tx ctx cond) (tx ctx body)

    // ── For (integer range: for i = lo to hi do ...) ──────────────────────────
    | ForIntegerRangeLoop(v, lo, hi, body) ->
        let iV  = localPfx v
        let lbl = freshLbl ctx "fl"
        let gi  = localGet iV WType.I32
        WExpr.LetMut(iV, tx ctx lo,
            whileLoop lbl (leS gi (tx ctx hi))
                (sequence [tx ctx body; localSet iV (add gi (i32Const 1))]))

    // ── Array .Length property ────────────────────────────────────────────────
    | PropertyGet(Some arr, pi, []) when pi.Name = "Length" ->
        arrayLen (tx ctx arr)

    // ── GetArray — arr.[i] ───────────────────────────────────────────────────
    | Call(None, mi, [arr; idx])
            when mi.Name = "GetArray" || mi.Name = "get_Item" ->
        arrayGet (tx ctx arr) (tx ctx idx) (wty ctx mi.ReturnType)

    // ── SetArray — arr.[i] <- v ───────────────────────────────────────────────
    | Call(None, mi, [arr; idx; v])
            when mi.Name = "SetArray" || mi.Name = "set_Item" ->
        arraySet (tx ctx arr) (tx ctx idx) (tx ctx v)

    // ── Array.zeroCreate n ───────────────────────────────────────────────────
    // NOTE: This requires the caller to pass the correct array typeIdx.
    // Register the translation via Intrinsics map: "ZeroCreate" → builder.
    | Call(None, mi, [n])
            when mi.Name = "ZeroCreate" || mi.Name = "zeroCreate" ->
        match Map.tryFind "ZeroCreate" ctx.Intrinsics with
        | Some builder -> builder [tx ctx n]
        | None -> failwith "WasmQuotationWalker: Array.zeroCreate requires a 'ZeroCreate' entry in Intrinsics map (typeIdx-specific). Register it via standardIntrinsics."

    // ── Arithmetic operators ─────────────────────────────────────────────────r
    // SpecificCall uses GetGenericMethodDefinition(), so the int-typed and float-typed
    // annotations capture the same generic method.  Dispatch on a.Type at runtime.
    | SpecificCall <@ (+) @> (_, _, [a; b]) ->
        if a.Type = typeof<float> then addf64 (tx ctx a) (tx ctx b) else add  (tx ctx a) (tx ctx b)
    | SpecificCall <@ (-) @> (_, _, [a; b]) ->
        if a.Type = typeof<float> then subf64 (tx ctx a) (tx ctx b) else sub  (tx ctx a) (tx ctx b)
    | SpecificCall <@ ( * ) @> (_, _, [a; b]) ->
        if a.Type = typeof<float> then mulf64 (tx ctx a) (tx ctx b) else mul  (tx ctx a) (tx ctx b)
    | SpecificCall <@ ( / ) @> (_, _, [a; b]) ->
        if a.Type = typeof<float> then divf64 (tx ctx a) (tx ctx b) else div_ (tx ctx a) (tx ctx b)
    | SpecificCall <@ (%) @> (_, _, [a; b]) ->
        rem_ (tx ctx a) (tx ctx b)

    // ── Comparison operators ─────────────────────────────────────────────────
    // Works for both int and float — WExpr.Compare is typed by its operands.
    | SpecificCall <@ (=)  @> (_, _, [a; b]) -> eq  (tx ctx a) (tx ctx b)
    | SpecificCall <@ (<>) @> (_, _, [a; b]) -> ne  (tx ctx a) (tx ctx b)
    | SpecificCall <@ (<)  @> (_, _, [a; b]) -> ltS (tx ctx a) (tx ctx b)
    | SpecificCall <@ (<=) @> (_, _, [a; b]) -> leS (tx ctx a) (tx ctx b)
    | SpecificCall <@ (>)  @> (_, _, [a; b]) -> gtS (tx ctx a) (tx ctx b)
    | SpecificCall <@ (>=) @> (_, _, [a; b]) -> geS (tx ctx a) (tx ctx b)

    // ── Boolean operators (short-circuit via wasmAnd / wasmOr) ───────────────
    | SpecificCall <@ (&&) @> (_, _, [a; b]) -> wasmAnd (tx ctx a) (tx ctx b)
    | SpecificCall <@ (||) @> (_, _, [a; b]) -> wasmOr  (tx ctx a) (tx ctx b)
    | SpecificCall <@ not  @> (_, _, [a])    ->
        // `not x` = `if x then 0 else 1`
        WExpr.If(tx ctx a, i32Const 0, i32Const 1, WType.I32)

    // ── Bitwise operators (i32) ───────────────────────────────────────────────
    | SpecificCall <@ (&&&) @> (_, _, [a; b]) -> and_ (tx ctx a) (tx ctx b)
    | SpecificCall <@ (|||) @> (_, _, [a; b]) -> or_  (tx ctx a) (tx ctx b)
    | SpecificCall <@ (^^^) @> (_, _, [a; b]) -> xor_ (tx ctx a) (tx ctx b)
    | SpecificCall <@ (<<<) @> (_, _, [a; b]) -> shl  (tx ctx a) (tx ctx b)
    | SpecificCall <@ (>>>) @> (_, _, [a; b]) -> shrS (tx ctx a) (tx ctx b)

    // ── Type conversions (identity in WASM for our supported types) ───────────
    | SpecificCall <@ int     @> (_, _, [a]) -> tx ctx a  // i32 → i32 nop
    | SpecificCall <@ char    @> (_, _, [a]) -> tx ctx a  // i32 → char nop
    | SpecificCall <@ float   @> (_, _, [a]) ->           // i32 → f64
        WExpr.Unary(WUnaryOp.ConvertI32S, tx ctx a, WType.F64)
    | SpecificCall <@ float32 @> (_, _, [a]) ->           // i32 → f32
        WExpr.Unary(WUnaryOp.ConvertI32S, tx ctx a, WType.F32)

    // ── Unary negation and abs ────────────────────────────────────────────────
    // NOTE: Since Sprint 19c, SpecificCall matches on GetGenericMethodDefinition(),
    // so <@ (~- : float->float) @> and <@ (~-) @> both resolve to the same generic def.
    // Only the FIRST pattern fires — we must dispatch on the argument runtime type.
    | SpecificCall <@ (( ~- ) : float -> float) @> (_, _, [a]) ->
        let wa = tx ctx a
        if   a.Type = typeof<float>   then WExpr.Unary(WUnaryOp.Neg, wa, WType.F64)
        elif a.Type = typeof<float32> then WExpr.Unary(WUnaryOp.Neg, wa, WType.F32)
        else sub (i32Const 0) wa   // i32 / i64 negation: 0 - x
    | SpecificCall <@ abs @> (_, _, [a]) ->
        let wa = tx ctx a
        if   a.Type = typeof<float>   then WExpr.Unary(WUnaryOp.Abs, wa, WType.F64)
        elif a.Type = typeof<float32> then WExpr.Unary(WUnaryOp.Abs, wa, WType.F32)
        else WExpr.If(ltS wa (i32Const 0), sub (i32Const 0) wa, wa, WType.I32)

    // ── min / max (i32) ────────────────────────────────────────────────────
    | SpecificCall <@ min @> (_, _, [a; b]) ->
        let wa = tx ctx a
        let wb = tx ctx b
        WExpr.If(ltS wa wb, wa, wb, WType.I32)
    | SpecificCall <@ max @> (_, _, [a; b]) ->
        let wa = tx ctx a
        let wb = tx ctx b
        WExpr.If(gtS wa wb, wa, wb, WType.I32)

    // ── WasmIntrinsic static calls ────────────────────────────────────────────
    // Methods tagged [<WasmIntrinsic("$name")>] are resolved to intrinsic builders.
    | Call(None, mi, args) ->
        let intrName =
            mi.GetCustomAttributes(typeof<WasmIntrinsicAttribute>, false)
            |> Array.tryHead
            |> Option.map (fun a -> (a :?> WasmIntrinsicAttribute).Name)
        match intrName with
        | Some name ->
            let wArgs = List.map (tx ctx) args
            match Map.tryFind name ctx.Intrinsics with
            | Some builder -> builder wArgs
            | None         -> WExpr.Call(name, wArgs, wty ctx mi.ReturnType)
        | None ->
            // Plain call to another module-level function (assumed available as WExpr.Call).
            WExpr.Call("$" + mi.Name, List.map (tx ctx) args, wty ctx mi.ReturnType)

    // ── WasmIntrinsic instance calls (e.g., wasmStr.Length, wasmStr.[i]) ─────
    | PropertyGet(Some obj, pi, []) ->
        let intrName =
            pi.GetCustomAttributes(typeof<WasmIntrinsicAttribute>, false)
            |> Array.tryHead
            |> Option.map (fun a -> (a :?> WasmIntrinsicAttribute).Name)
        match intrName with
        | Some name ->
            match Map.tryFind name ctx.Intrinsics with
            | Some builder -> builder [tx ctx obj]
            | None         -> WExpr.Call(name, [tx ctx obj], wty ctx pi.PropertyType)
        | None ->
            failwithf "WasmQuotationWalker: unsupported property get '%s.%s'" pi.DeclaringType.Name pi.Name

    | Call(Some obj, mi, args) ->
        let intrName =
            mi.GetCustomAttributes(typeof<WasmIntrinsicAttribute>, false)
            |> Array.tryHead
            |> Option.map (fun a -> (a :?> WasmIntrinsicAttribute).Name)
        match intrName with
        | Some name ->
            let wArgs = tx ctx obj :: List.map (tx ctx) args
            match Map.tryFind name ctx.Intrinsics with
            | Some builder -> builder wArgs
            | None         -> WExpr.Call(name, wArgs, wty ctx mi.ReturnType)
        | None ->
            failwithf "WasmQuotationWalker: unsupported instance call '%s.%s'. Add [<WasmIntrinsic>] or translate to a module-level call." mi.DeclaringType.Name mi.Name

    | NewTuple _ ->
        failwith "WasmQuotationWalker: tuples not supported — use struct fields or individual let-bindings."

    | _ ->
        failwithf "WasmQuotationWalker: unsupported F# pattern:\n%A\nAdd a case to WasmGcQuotationWalker.tx." expr

// ─────────────────────────────────────────────────────────────────────────────
// Public API
// ─────────────────────────────────────────────────────────────────────────────

/// Translate a [<ReflectedDefinition>] function into a WFuncDecl.
///
/// `qexpr`      — obtained via `<@ myFunc @>` at the call site.
/// `funcName`   — the WASM function name to assign (e.g. "$strTrim").
/// `typeMap`    — F# type → WType mapping.
/// `intrinsics` — known intrinsic builders; see standardIntrinsics.
let translateReflected
        (funcName  : string)
        (typeMap   : QTypeMap)
        (intrinsics: Map<string, WExpr list -> WExpr>)
        (qexpr     : Expr)
        : WFuncDecl =
    let ctx = {
        TypeMap    = typeMap
        Intrinsics = intrinsics
        LabelN     = ref 0
    }
    // A module-level function quotation is a chain of Lambdas ending in the body.
    let rec stripLambdas acc = function
        | Lambda(v, rest) -> stripLambdas ((v.Name, wty ctx v.Type) :: acc) rest
        | body            -> List.rev acc, body
    let parms, body = stripLambdas [] qexpr
    let retTy =
        let rec lastTy = function
            | Lambda(_, rest) -> lastTy rest
            | e               -> wty ctx e.Type
        lastTy qexpr
    {
        Name    = funcName
        Params  = parms |> List.map (fun (n, t) -> "$" + n, t)
        Locals  = []    // WasmGcEmit.collectLocals fills this in when emitting
        Result  = retTy
        Body    = tx ctx body
        Exported = false
    }

// ─────────────────────────────────────────────────────────────────────────────
// Standard intrinsics map
// ─────────────────────────────────────────────────────────────────────────────

/// Build the standard intrinsics map for WasmGcRuntime.fs helpers.i as
/// Pass `strTypeIdx = StringTypeIdx` (= 1) from WasmGcTypes.
let standardIntrinsics (strTypeIdx: int) (sbTypeIdx: int) : Map<string, WExpr list -> WExpr> =
    let strRefTy = WType.Ref(strTypeIdx, false)
    let sbRefTy  = WType.Ref(sbTypeIdx,  false)
    Map.ofList [
        // ── WasmStr read intrinsics ───────────────────────────────────────────
        "$wasmStr_length",     (function [s]              -> arrayLen s                           | a -> failwithf "arity $wasmStr_length: got %d" a.Length)
        "$wasmStr_get",        (function [s; i]           -> arrayGet s i WType.I32               | a -> failwithf "arity $wasmStr_get: got %d" a.Length)
        // ── WasmStr write intrinsics (for Tier 1 string-building helpers) ─────
        "$wasmStr_create",     (function [n]              -> arrayNew strTypeIdx n (i32Const 0) strRefTy    | a -> failwithf "arity $wasmStr_create: got %d" a.Length)
        "$wasmStr_createFill", (function [n; fill]        -> arrayNew strTypeIdx n fill strRefTy  | a -> failwithf "arity $wasmStr_createFill: got %d" a.Length)
        "$wasmStr_set",        (function [s; i; v]        -> arraySet s i v                       | a -> failwithf "arity $wasmStr_set: got %d" a.Length)
        "$wasmStr_copy",       (function [dst;do_;src;so_;len] -> WExpr.ArrayCopy(dst,do_,src,so_,len) | a -> failwithf "arity $wasmStr_copy: got %d" a.Length)
        // ── Array ops ─────────────────────────────────────────────────────────
        "arrayLen",        (function [a]       -> arrayLen a          | a -> failwithf "arity mismatch arrayLen: got %d" a.Length)
        "arrayGet",        (function [a; i; _] -> arrayGet a i WType.I32 | a -> failwithf "arity mismatch arrayGet: got %d" a.Length)
        "arraySet",        (function [a; i; v] -> arraySet a i v      | a -> failwithf "arity mismatch arraySet: got %d" a.Length)
        // ── String helpers — forwarded as WExpr.Call to existing runtime fns ──
        "$strSubstring",   fun args -> WExpr.Call("$strSubstring", args, strRefTy)
        "$strConcat",      fun args -> WExpr.Call("$strConcat",    args, strRefTy)
        "$strIndexOf",     fun args -> WExpr.Call("$strIndexOf",   args, WType.I32)
        "$strLastIndexOf", fun args -> WExpr.Call("$strLastIndexOf", args, WType.I32)
        // ── Char helpers ───────────────────────────────────────────────────────
        "$charIsWhitespace",    (function [c] -> WExpr.Call("$charIsWhitespace",    [c], WType.I32) | a -> failwithf "arity mismatch $charIsWhitespace: got %d" a.Length)
        "$charIsDigit",         (function [c] -> WExpr.Call("$charIsDigit",         [c], WType.I32) | a -> failwithf "arity mismatch $charIsDigit: got %d" a.Length)
        "$charIsLetter",        (function [c] -> WExpr.Call("$charIsLetter",        [c], WType.I32) | a -> failwithf "arity mismatch $charIsLetter: got %d" a.Length)
        "$charIsUpper",         (function [c] -> WExpr.Call("$charIsUpper",         [c], WType.I32) | a -> failwithf "arity mismatch $charIsUpper: got %d" a.Length)
        "$charIsLower",         (function [c] -> WExpr.Call("$charIsLower",         [c], WType.I32) | a -> failwithf "arity mismatch $charIsLower: got %d" a.Length)
        "$charIsLetterOrDigit", (function [c] -> WExpr.Call("$charIsLetterOrDigit", [c], WType.I32) | a -> failwithf "arity mismatch $charIsLetterOrDigit: got %d" a.Length)
        "$charToLower",         (function [c] -> WExpr.Call("$charToLower",         [c], WType.I32) | a -> failwithf "arity mismatch $charToLower: got %d" a.Length)
        "$charToUpper",         (function [c] -> WExpr.Call("$charToUpper",         [c], WType.I32) | a -> failwithf "arity mismatch $charToUpper: got %d" a.Length)
        // ── Float phantom intrinsics ────────────────────────────────────────────
        "$f64_trunc_i32",  (function [f] -> WExpr.Unary(WUnaryOp.TruncF64S,  f, WType.I32) | a -> failwithf "arity $f64_trunc_i32: got %d"  a.Length)
        "$f64_abs",        (function [f] -> WExpr.Unary(WUnaryOp.Abs,         f, WType.F64) | a -> failwithf "arity $f64_abs: got %d"        a.Length)
        "$f64_neg",        (function [f] -> WExpr.Unary(WUnaryOp.Neg,         f, WType.F64) | a -> failwithf "arity $f64_neg: got %d"        a.Length)
        "$i32_to_f64",     (function [n] -> WExpr.Unary(WUnaryOp.ConvertI32S, n, WType.F64) | a -> failwithf "arity $i32_to_f64: got %d"    a.Length)
        // ── StringBuilder struct phantom intrinsics ──────────────────────────
        // Layout: field 0 = data:WasmStr(ref), field 1 = len:i32, field 2 = cap:i32
        "$sb_new",     (function [data; len; cap] -> WExpr.StructNew(sbTypeIdx, [data; len; cap], sbRefTy)  | a -> failwithf "arity $sb_new: got %d"     a.Length)
        "$sb_buf_get", (function [sb]             -> WExpr.StructGet(sb, 0, strRefTy)                       | a -> failwithf "arity $sb_buf_get: got %d"  a.Length)
        "$sb_buf_set", (function [sb; data]       -> WExpr.StructSet(sb, 0, data)                           | a -> failwithf "arity $sb_buf_set: got %d"  a.Length)
        "$sb_len_get", (function [sb]             -> WExpr.StructGet(sb, 1, WType.I32)                      | a -> failwithf "arity $sb_len_get: got %d"  a.Length)
        "$sb_len_set", (function [sb; len]        -> WExpr.StructSet(sb, 1, len)                            | a -> failwithf "arity $sb_len_set: got %d"  a.Length)
        "$sb_cap_get", (function [sb]             -> WExpr.StructGet(sb, 2, WType.I32)                      | a -> failwithf "arity $sb_cap_get: got %d"  a.Length)
        "$sb_cap_set", (function [sb; cap]        -> WExpr.StructSet(sb, 2, cap)                            | a -> failwithf "arity $sb_cap_set: got %d"  a.Length)
    ]
