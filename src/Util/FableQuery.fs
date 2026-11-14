/// Active patterns for Fable AST structural matching.
///
/// Replaces ad-hoc nested pattern matches in TransformExpr.fs and all
/// replacement modules with named, composable patterns.
///
/// Design: pure pattern matching, no side effects, no Ctx dependency.
/// Open this module in any transform file to enable the DSL.
module WasmGc.Util.FableQuery

open Fable.AST
open Fable.AST.Fable

// ─────────────────────────────────────────────────────────────────
// Lambda / delegate normalization
// ─────────────────────────────────────────────────────────────────

/// A function VALUE (an identifier or an import of function type — a closure parameter, a named function) seen as
/// the lambda `fun x1 … xn -> f x1 … xn`, so every handler that pattern-matches on a literal lambda also accepts
/// `List.map f xs` with `f` bound elsewhere.  Only atoms are expanded: nothing is evaluated more than once.
let private etaExpand (arity: int) (f: Expr) : (Ident list * Expr) option =
    let rec paramTypes (t: Type) (n: int) : Type list option =
        if n = 0 then Some []
        else
            match t with
            | LambdaType(a, r) -> paramTypes r (n - 1) |> Option.map (fun rest -> a :: rest)
            | DelegateType(args, _) when args.Length = n -> Some args
            | _ -> None
    let isAtom = match f with IdentExpr i -> not i.IsMutable | Import _ -> true | _ -> false
    if not isAtom then None else
    paramTypes f.Type arity
    |> Option.map (fun types ->
        let idents =
            types |> List.mapi (fun i t ->
                { Name = $"eta{i}"; Type = t; IsMutable = false; IsThisArgument = false; IsCompilerGenerated = true; IsInlineIfLambda = false; Range = None })
        let rec resultOf (t: Type) n = if n = 0 then t else (match t with LambdaType(_, r) -> resultOf r (n - 1) | DelegateType(_, r) -> r | _ -> t)
        idents, CurriedApply(f, idents |> List.map IdentExpr, resultOf f.Type arity, None))

/// A constant, an immutable identifier or a plain field of one: evaluated again inside a lambda it gives the same value at no cost.
let rec private isAtomicValue (e: Expr) : bool =
    match e with
    // a field of an atom that is neither mutable nor computed (`n.Variant` of a record)
    | Get(target, GetKind.FieldGet fi, _, _) -> not fi.CanHaveSideEffects && isAtomicValue target
    | Value(ValueKind.NumberConstant _, _) | Value(ValueKind.BoolConstant _, _) | Value(ValueKind.StringConstant _, _)
    | Value(ValueKind.CharConstant _, _) | Value(ValueKind.UnitConstant, _) -> true
    | IdentExpr i -> not i.IsMutable
    | _ -> false

/// The lambda inside the `let`s a partial application leaves around it: `(=) 30` is `let x = 30 in fun y -> x = y`.
/// Atomic bindings move inside the lambda (they evaluate to the same thing every time); anything else stays a value.
let rec private underAtomicLets (shape: Expr -> (Ident list * Expr) option) (f: Expr) : (Ident list * Expr) option =
    match f with
    | Let(x, value, inner) when isAtomicValue value ->
        underAtomicLets shape inner |> Option.map (fun (args, body) -> args, Let(x, value, body))
    | _ -> shape f

let private unaryShape (f: Expr) =
    match f with
    | Lambda(arg, body, _)
    | Delegate([arg], body, _, _) -> Some([ arg ], body)
    | _ -> None

let private binaryShape (f: Expr) =
    match f with
    | Lambda(a1, Lambda(a2, body, _), _)
    | Delegate([a1; a2], body, _, _)
    | Lambda(a1, Delegate([a2], body, _, _), _) -> Some([ a1; a2 ], body)
    | _ -> None

/// Single-arg lambda or single-element delegate (or a function value, eta-expanded).
let (|UnaryLambda|_|) (f: Expr) =
    match underAtomicLets unaryShape f with
    | Some([ arg ], body) -> Some(arg, body)
    | _ -> etaExpand 1 f |> Option.map (fun (ids, body) -> ids.[0], body)

/// Curried 2-arg lambda or 2-element delegate (or a function value, eta-expanded).
let (|BinaryLambda|_|) (f: Expr) =
    match underAtomicLets binaryShape f with
    | Some([ a1; a2 ], body) -> Some(a1, a2, body)
    | _ -> etaExpand 2 f |> Option.map (fun (ids, body) -> ids.[0], ids.[1], body)

/// `Compare` of a Fable comparer argument (`ObjectExpr { Compare = fun x y -> … }`), or a bare two-argument lambda.
let (|ComparerLambda|_|) (e: Expr) =
    match e with
    | ObjectExpr(members, _, _) ->
        members |> List.tryPick (fun m -> match m.Name, m.Body with "Compare", BinaryLambda(a, b, body) -> Some(a, b, body) | _ -> None)
    | BinaryLambda(a, b, body) -> Some(a, b, body)
    | _ -> None

/// Curried 3-arg lambda or 3-element delegate.
let (|TernaryLambda|_|) = function
    | Lambda(a1, Lambda(a2, Lambda(a3, body, _), _), _)
    | Delegate([a1; a2; a3], body, _, _)             -> Some(a1, a2, a3, body)
    | _                                              -> None

/// N-arg curried lambda (arbitrary depth).
let (|NaryLambda|_|) (n: int) (expr: Expr) : (Ident list * Expr) option =
    let rec collect acc k = function
        | _ when k = 0                 -> Some(List.rev acc, expr)
        | Lambda(arg, body, _)         -> collect (arg :: acc) (k - 1) body
        | Delegate(args, body, _, _) when args.Length = k ->
            Some(List.rev acc @ args, body)
        | _                            -> None
    collect [] n expr

// ─────────────────────────────────────────────────────────────────
// printf
// ─────────────────────────────────────────────────────────────────

/// `printfn` / `sprintf` formatter over a literal format string:
///   Call(Import "toConsole" | "toText", [TypeCast(Call(Import "printf", [Str fmt; …]))])  ⇒  (selector, fmt)
/// Creating one has no effect (output happens when it is applied) and the format is constant, so it may be
/// moved or duplicated freely.
let (|PrintfFormatter|_|) (e: Expr) : (string * string) option =
    match e with
    | Expr.Call(Expr.Import({ Selector = ("toText" | "toConsole") as sel }, _, _), outer, _, _) ->
        match outer.Args with
        | [ Expr.TypeCast(Expr.Call(Expr.Import({ Selector = "printf" }, _, _), inner, _, _), _) ] ->
            match inner.Args with
            | Expr.Value(ValueKind.StringConstant fmt, _) :: _ -> Some(sel, fmt)
            | _ -> None
        | _ -> None
    | _ -> None

/// A printf formatter applied to arguments, possibly one at a time (F# curries `printfn "%d %d" a b`):
///   CurriedApply(CurriedApply(formatter, [a]), [b])  ⇒  (selector, fmt, [a; b])
/// A bare formatter matches with no arguments.
let rec (|PrintfApply|_|) (e: Expr) : (string * string * Expr list) option =
    match e with
    | PrintfFormatter(sel, fmt) -> Some(sel, fmt, [])
    | Expr.CurriedApply(PrintfApply(sel, fmt, applied), more, _, _) -> Some(sel, fmt, applied @ more)
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Number kinds
// ─────────────────────────────────────────────────────────────────

/// uint8 / uint16 / uint32 / uint64.  Their values are zero-extended in an i32, so comparison, division, remainder, logical
/// right shift, min / max and the conversion to float / int64 / string need the unsigned variants.
let isUnsignedInt (t: Type) =
    match t with
    | Type.Number((NumberKind.UInt8 | NumberKind.UInt16 | NumberKind.UInt32 | NumberKind.UInt64), _) -> true
    | _ -> false

// ─────────────────────────────────────────────────────────────────
// Type shapes
// ─────────────────────────────────────────────────────────────────

/// List<T> — also matches seq<T> coerced from list (DeclaredType with one arg).
let (|ListOf|_|) = function
    | Type.List t                                  -> Some t
    | Type.DeclaredType(_, [t])                    -> Some t   // seq<T> coercion
    | _                                            -> None

let (|ArrayOf|_|) = function
    | Type.Array(t, _)                             -> Some t
    | _                                            -> None

let (|MutableArrayOf|_|) = function
    | Type.Array(t, ArrayKind.MutableArray)        -> Some t
    | _                                            -> None

let (|ResizeArrayOf|_|) = function
    | Type.Array(t, ArrayKind.ResizeArray)         -> Some t
    | _                                            -> None

let (|OptionOf|_|) = function
    | Type.Option(t, _)                            -> Some t
    | _                                            -> None

let (|TupleOf|_|) = function
    | Type.Tuple(ts, _)                            -> Some ts
    | _                                            -> None

let (|MaybeTuple|_|) = function
    | Type.Tuple([a; b], _)                        -> Some(a, b)
    | _                                            -> None

let (|FunctionType|_|) = function
    | Type.LambdaType(arg, ret)    -> Some([arg], ret)
    | Type.DelegateType(args, ret) -> Some(args, ret)
    | _                            -> None

let (|NamedType|_|) (name: string) = function
    | Type.DeclaredType(e, _) when e.FullName = name -> Some()
    | _                                              -> None

let (|GenericType|_|) = function
    | Type.DeclaredType(_, (_ :: _ as args))       -> Some args
    | _                                            -> None

// Type predicates
let isListType    = function Type.List _    -> true | _ -> false
let isArrayType   = function Type.Array _   -> true | _ -> false
let isOptionType  = function Type.Option _  -> true | _ -> false
let isTupleType   = function Type.Tuple _   -> true | _ -> false
let isUnitType    = function Type.Unit      -> true | _ -> false
let isBoolType    = function Type.Boolean   -> true | _ -> false
let isStringType  = function Type.String    -> true | _ -> false
let isNumericType = function Type.Number _  -> true | _ -> false

let elemTypeOf = function
    | Type.List t | Type.Array(t, _) | Type.Option(t, _) -> Some t
    | _                                                  -> None

// ─────────────────────────────────────────────────────────────────
// HOF argument shapes
// ─────────────────────────────────────────────────────────────────

/// [lambda; collection] or [collection; lambda] — covers List.map, Array.filter etc.
let (|HofArgs|_|) = function
    | [UnaryLambda(farg, fbody); coll]
    | [coll; UnaryLambda(farg, fbody)] -> Some(farg, fbody, coll)
    | _                                -> None

/// [binaryLambda; init; collection] — List.fold, Array.fold etc.
let (|FoldArgs|_|) = function
    | [BinaryLambda(acc, elem, body); init; coll] -> Some(acc, elem, body, init, coll)
    | _                                           -> None

/// [binaryLambda; collection] where first arg is index — List.mapi, Array.mapi.
let (|MapiArgs|_|) = function
    | [BinaryLambda(idx, elem, body); coll]
    | [coll; BinaryLambda(idx, elem, body)] -> Some(idx, elem, body, coll)
    | _                                     -> None

// ─────────────────────────────────────────────────────────────────
// Call shapes
// ─────────────────────────────────────────────────────────────────

/// Fable standard library call → (moduleStem, memberName, args).
let (|LibCall|_|) = function
    | Call(Import({ Selector = sel; Path = path }, _, _), info, _, _)
          when path.Contains("fable-library") || path.EndsWith(".js") ->
        Some(System.IO.Path.GetFileNameWithoutExtension(path), sel, info.Args)
    | _ -> None

/// User [<Import>] call → (selector, modulePath, args).
let (|ImportCall|_|) = function
    | Call(Import({ Selector = sel; Path = path }, _, _), info, _, _) ->
        Some(sel, path, info.Args)
    | _ -> None

// StaticCall: any Call without a this-arg (covers both module-value and static member)
// StaticCall here means: Call without a this-arg (module-level or static).
let (|StaticCall|_|) = function
    | Call (callee, info, retType, _) 
        when info.ThisArg.IsNone 
        // TODO: or/and not memberInfo.IsInstance
        ->
        Some (callee, info.Args, retType)
    | _ -> None

/// Instance method call → (thisArg, memberRef, args, retType).
let (|InstanceCall|_|) = function
    | Call(_, info, retType, _) when info.ThisArg.IsSome ->
        Some(info.ThisArg.Value, info.MemberRef, info.Args, retType)
    | _ -> None

/// ResizeArray.push call.
let (|ResizeArrayPush|_|) = function
    | Call(Get(arr, FieldGet fi, _, _), info, _, _) when fi.Name = "push" ->
        match arr.Type with
        | ResizeArrayOf elemT -> Some(arr, elemT, info.Args)
        | _                   -> None
    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Literals — each NumberValue case has its own concrete type
// Number value helpers (shared by IntLit / FloatLit)
// ─────────────────────────────────────────────────────────────────

let private numToInt = function
    | NumberValue.Int8 v        -> Some(int v)
    | NumberValue.UInt8 v       -> Some(int v)
    | NumberValue.Int16 v       -> Some(int v)
    | NumberValue.UInt16 v      -> Some(int v)
    | NumberValue.Int32 v       -> Some v
    | NumberValue.UInt32 v      -> Some(int v)
    | NumberValue.NativeInt v   -> Some(int v)
    | NumberValue.UNativeInt v  -> Some(int v)
    | _                         -> None

let private numToFloat (n: NumberValue) : float option =
    match n with
    | NumberValue.Float16 v  -> Some(float v)
    | NumberValue.Float32 v  -> Some(float v)
    | NumberValue.Float64 v  -> Some v
    | NumberValue.Decimal v  -> Some(float v)
    | NumberValue.Int8 v     -> Some(float v)
    | NumberValue.UInt8 v    -> Some(float v)
    | NumberValue.Int16 v    -> Some(float v)
    | NumberValue.UInt16 v   -> Some(float v)
    | NumberValue.Int32 v    -> Some(float v)
    | NumberValue.UInt32 v   -> Some(float v)
    | NumberValue.Int64 v    -> Some(float v)
    | NumberValue.UInt64 v   -> Some(float v)
    | NumberValue.NativeInt v   -> Some(float v)
    | NumberValue.UNativeInt v  -> Some(float v)
    | _                         -> None

// ─────────────────────────────────────────────────────────────────
// Literal patterns
// ─────────────────────────────────────────────────────────────────

let (|IntLit|_|)   = function Value(NumberConstant(n, _), _) -> numToInt n   | _ -> None
let (|FloatLit|_|) = function Value(NumberConstant(n, _), _) -> numToFloat n | _ -> None
let (|StrLit|_|)   = function Value(StringConstant s, _)     -> Some s       | _ -> None
let (|BoolLit|_|)  = function Value(BoolConstant b, _)       -> Some b       | _ -> None
let (|CharLit|_|)  = function Value(CharConstant c, _)       -> Some c       | _ -> None
let (|UnitVal|_|)  = function Value(UnitConstant, _)         -> Some()       | _ -> None
let (|NullLit|_|)  = function Value(Null _, _)               -> Some()       | _ -> None
let (|Null|_|)     = (|NullLit|_|)   // backward compat alias

// ─────────────────────────────────────────────────────────────────
// Get / Set / field access
// (|GetField|_|) is named differently to avoid shadowing GetKind.FieldGet DU constructor.
// Use (|GetField|_|) for raw FieldInfo pair, (|FieldNamed|_|) for name-only.
// ─────────────────────────────────────────────────────────────────

// Raw field info pair — use when you need fi.IsMutable, fi.FieldType etc.
// Use (|GetField|_|) for raw FieldInfo pair, (|FieldNamed|_|) for name-only.
let (|GetField|_|) = function
    | Get(obj, FieldGet fi, _, _)               -> Some(obj, fi)
    | _                                         -> None

// Name-only field access — most common case in replacements
let (|FieldNamed|_|) = function
    | Get(obj, FieldGet fi, retTy, _)           -> Some(obj, fi.Name, retTy)
    | _                                         -> None

// /// Structural FieldGet that only matches by name — for ad-hoc member access.
// let (|FieldGet|_|) = function
//     | Get(obj, FieldGet fi, retTy, _)          -> Some(obj, fi.Name, retTy)
//     | _                                        -> None

let (|SetField|_|) = function
    | Set(obj, FieldSet name, _, value, _)      -> Some(obj, name, value)
    | _                                         -> None

let (|GetIndex|_|) = function
    | Get(obj, ExprGet idx, _, _)               -> Some(obj, idx)
    | _                                         -> None

let (|SetIndex|_|) = function
    | Set(obj, ExprSet idx, _, value, _)        -> Some(obj, idx, value)
    | _                                         -> None

let (|TupleGet|_|) = function
    | Get(obj, TupleIndex i, retTy, _)          -> Some(obj, i, retTy)
    | _                                         -> None

// UnionField wraps a single UnionFieldInfo record, not a tuple
let (|UnionCaseGet|_|) = function
    | Get(obj, UnionField info, retTy, _)       -> Some(obj, info, retTy)
    | _                                         -> None

// ─────────────────────────────────────────────────────────────────
// Operators
// ─────────────────────────────────────────────────────────────────

let (|BinOp|_|) = function
    | Operation(OperationKind.Binary(op, l, r), _, ty, _)  -> Some(op, l, r, ty)
    | _                                                    -> None

let (|UnOp|_|) = function
    | Operation(OperationKind.Unary(op, e), _, ty, _)      -> Some(op, e, ty)
    | _                                                    -> None

let (|LogicalOp|_|) = function
    | Operation(OperationKind.Logical(op, l, r), _, ty, _) -> Some(op, l, r, ty)
    | _                                                    -> None

// ─────────────────────────────────────────────────────────────────
// Control flow
// ─────────────────────────────────────────────────────────────────

let (|IfExpr|_|)    = function IfThenElse(g, t, e, _)    -> Some(g, t, e)    | _ -> None
let (|WhileExpr|_|) = function WhileLoop(g, b, _)        -> Some(g, b)       | _ -> None
let (|ForExpr|_|)   = function ForLoop(i, s, e, b, _, _) -> Some(i, s, e, b) | _ -> None
let (|TryExpr|_|)   = function TryCatch(b, c, f, _)      -> Some(b, c, f)    | _ -> None

// ─────────────────────────────────────────────────────────────────
// Strings
// ─────────────────────────────────────────────────────────────────

let (|StringConcat|_|) = function
    | Call(Import({ Selector = "concat" }, _, _), info, _, _) -> Some info.Args
    | _ -> None

// NOTE: uses FieldGet as DU constructor (not active pattern) — no shadowing
let (|StringLength|_|) = function
    | Get(s, FieldGet fi, _, _) when fi.Name = "Length" -> Some s
    | _                                                  -> None

let (|StringIndex|_|) = function
    | Get(s, ExprGet idx, _, _) -> Some(s, idx)
    | _                         -> None

// ─────────────────────────────────────────────────────────────────
// Declaration helpers
// ─────────────────────────────────────────────────────────────────

let private hasTag tag (tags: string list) =
    tags |> List.exists (fun t -> t.Equals(tag, System.StringComparison.OrdinalIgnoreCase))

let (|IsExported|_|) = function
    | MemberDeclaration m when hasTag "export" m.Tags -> Some()
    | ClassDeclaration c  when hasTag "export" c.Tags -> Some()
    | _                                               -> None

let (|IsAbstract|_|) = function
    | ClassDeclaration c when hasTag "abstract" c.Tags -> Some()
    | _                                                -> None

// ─────────────────────────────────────────────────────────────────
// Collection constructors
// ─────────────────────────────────────────────────────────────────

let (|ArrayCreate|_|) = function
    | Call(Import({ Selector = "zeroCreate" }, _, _), info, _, _) -> Some info.Args
    | _ -> None

let (|ListCons|_|) = function
    | Call(Import({ Selector = "cons" }, _, _), _, _, _)  -> Some()
    | _ -> None

let (|ListEmpty|_|) = function
    | Call(Import({ Selector = "empty" }, _, _), _, _, _) -> Some()
    | _ -> None
