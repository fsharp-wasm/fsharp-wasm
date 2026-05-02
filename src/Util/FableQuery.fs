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
// Lambda / delegate shape normalization
// ─────────────────────────────────────────────────────────────────

/// Single-arg lambda or single-element delegate.
let (|UnaryLambda|_|) = function
    | Lambda(arg, body, _)
    | Delegate([arg], body, _, _)          -> Some(arg, body)
    | _                                    -> None

/// Curried 2-arg lambda or 2-element delegate.
let (|BinaryLambda|_|) = function
    | Lambda(a1, Lambda(a2, body, _), _)
    | Delegate([a1; a2], body, _, _)
    | Lambda(a1, Delegate([a2], body, _, _), _) -> Some(a1, a2, body)
    | _                                          -> None

/// Curried 3-arg lambda or 3-element delegate.
let (|TernaryLambda|_|) = function
    | Lambda(a1, Lambda(a2, Lambda(a3, body, _), _), _)
    | Delegate([a1; a2; a3], body, _, _)   -> Some(a1, a2, a3, body)
    | _                                    -> None

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
    | Type.LambdaType(arg, ret)                    -> Some([arg], ret)
    | Type.DelegateType(args, ret)                 -> Some(args, ret)
    | _                                            -> None

let (|NamedType|_|) (name: string) = function
    | Type.DeclaredType(e, _) when e.FullName = name -> Some()
    | _                                              -> None

let (|GenericType|_|) = function
    | Type.DeclaredType(_, (_ :: _ as args))       -> Some args
    | _                                            -> None

// Type predicates
let isListType    = function Type.List _                   -> true | _ -> false
let isArrayType   = function Type.Array _                  -> true | _ -> false
let isOptionType  = function Type.Option _                 -> true | _ -> false
let isTupleType   = function Type.Tuple _                  -> true | _ -> false
let isUnitType    = function Type.Unit                     -> true | _ -> false
let isBoolType    = function Type.Boolean                  -> true | _ -> false
let isStringType  = function Type.String                   -> true | _ -> false
let isNumericType = function Type.Number _                 -> true | _ -> false

let elemTypeOf = function
    | Type.List t | Type.Array(t, _) | Type.Option(t, _)  -> Some t
    | _                                                    -> None

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

/// Module-value (static) call.
let (|StaticCall|_|) = function
    | Call(callee, info, retType, _) when info.IsModuleValue -> Some(callee, info.Args, retType)
    | _                                                       -> None

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
// Number value helpers (shared by IntLit / FloatLit)
// ─────────────────────────────────────────────────────────────────

let private numToInt = function
    | NumberValue.Int8 n | NumberValue.UInt8 n
    | NumberValue.Int16 n | NumberValue.UInt16 n
    | NumberValue.Int32 n | NumberValue.UInt32 n
    | NumberValue.NativeInt n | NumberValue.UNativeInt n -> Some(int n)
    | _ -> None

let private numToFloat = function
    | NumberValue.Float16 n | NumberValue.Float32 n | NumberValue.Float64 n -> Some(float n)
    | NumberValue.Decimal n   -> Some(float n)
    | NumberValue.Int8 n      -> Some(float n)
    | NumberValue.UInt8 n     -> Some(float n)
    | NumberValue.Int16 n     -> Some(float n)
    | NumberValue.UInt16 n    -> Some(float n)
    | NumberValue.Int32 n     -> Some(float n)
    | NumberValue.UInt32 n    -> Some(float n)
    | NumberValue.Int64 n     -> Some(float n)
    | NumberValue.UInt64 n    -> Some(float n)
    | NumberValue.NativeInt n -> Some(float n)
    | NumberValue.UNativeInt n-> Some(float n)
    | _                       -> None

// ─────────────────────────────────────────────────────────────────
// Literal patterns
// ─────────────────────────────────────────────────────────────────

let (|IntLit|_|)   = function Value(NumberConstant(n, _), _) -> numToInt n   | _ -> None
let (|FloatLit|_|) = function Value(NumberConstant(n, _), _) -> numToFloat n | _ -> None
let (|StrLit|_|)   = function Value(StringConstant s, _)     -> Some s        | _ -> None
let (|BoolLit|_|)  = function Value(BoolConstant b, _)       -> Some b        | _ -> None
let (|CharLit|_|)  = function Value(CharConstant c, _)       -> Some c        | _ -> None
let (|UnitVal|_|)  = function Value(UnitConstant, _)         -> Some()        | _ -> None
let (|NullLit|_|)  = function Value(Null _, _)               -> Some()        | _ -> None

// Alias for compatibility
let (|Null|_|) = (|NullLit|_|)

// ─────────────────────────────────────────────────────────────────
// Get / Set / field access
// ─────────────────────────────────────────────────────────────────

let (|GetField|_|) = function
    | Get(obj, FieldGet fi, _, _)              -> Some(obj, fi)
    | _                                        -> None

/// Structural FieldGet that only matches by name — for ad-hoc member access.
let (|FieldGet|_|) = function
    | Get(obj, FieldGet fi, retTy, _)          -> Some(obj, fi.Name, retTy)
    | _                                        -> None

let (|SetField|_|) = function
    | Set(obj, FieldSet fieldName, _, value, _)-> Some(obj, fieldName, value)
    | _                                        -> None

let (|GetIndex|_|) = function
    | Get(obj, ExprGet idx, _, _)              -> Some(obj, idx)
    | _                                        -> None

let (|SetIndex|_|) = function
    | Set(obj, ExprSet idx, _, value, _)       -> Some(obj, idx, value)
    | _                                        -> None

let (|TupleGet|_|) = function
    | Get(obj, TupleIndex i, retTy, _)         -> Some(obj, i, retTy)
    | _                                        -> None

let (|UnionCaseGet|_|) = function
    | Get(obj, UnionField(caseRef, fi), retTy, _) -> Some(obj, caseRef, fi, retTy)
    | _                                            -> None

// ─────────────────────────────────────────────────────────────────
// Operators
// ─────────────────────────────────────────────────────────────────

let (|BinOp|_|) = function
    | Operation(OperationKind.Binary(op, l, r), _, ty, _) -> Some(op, l, r, ty)
    | _                                                    -> None

let (|UnOp|_|) = function
    | Operation(OperationKind.Unary(op, e), _, ty, _)     -> Some(op, e, ty)
    | _                                                    -> None

let (|LogicalOp|_|) = function
    | Operation(OperationKind.Logical(op, l, r), _, ty, _)-> Some(op, l, r, ty)
    | _                                                    -> None

// ─────────────────────────────────────────────────────────────────
// Control flow shapes
// ─────────────────────────────────────────────────────────────────

let (|IfExpr|_|)    = function IfThenElse(g, t, e, _)        -> Some(g, t, e)    | _ -> None
let (|WhileExpr|_|) = function WhileLoop(g, b, _)             -> Some(g, b)       | _ -> None
let (|ForExpr|_|)   = function ForLoop(i, s, e, b, _, _)      -> Some(i, s, e, b) | _ -> None
let (|TryExpr|_|)   = function TryCatch(b, c, f, _)           -> Some(b, c, f)    | _ -> None

// ─────────────────────────────────────────────────────────────────
// String helpers
// ─────────────────────────────────────────────────────────────────

let (|StringConcat|_|) = function
    | Call(Import({ Selector = "concat" }, _, _), info, _, _) -> Some info.Args
    | _ -> None

let (|StringLength|_|) = function
    | Get(str_, FieldGet fi, _, _) when fi.Name = "Length" -> Some str_
    | _ -> None

let (|StringIndex|_|) = function      // BUG FIX: was `functions` instead of `function`
    | Get(str_, ExprGet idx, _, _)  -> Some(str_, idx)
    | _                             -> None

// ─────────────────────────────────────────────────────────────────
// Declaration patterns
// ─────────────────────────────────────────────────────────────────

let private hasTag (tag: string) (tags: string list) =
    tags |> List.exists (fun t -> t.Equals(tag, System.StringComparison.OrdinalIgnoreCase))

let (|IsExported|_|) = function
    | MemberDeclaration m when hasTag "export" m.Tags -> Some()
    | ClassDeclaration c  when hasTag "export" c.Tags -> Some()
    | _                                               -> None

let (|IsAbstract|_|) = function
    | ClassDeclaration c when hasTag "abstract" c.Tags -> Some()
    | _                                                -> None

// ─────────────────────────────────────────────────────────────────
// Collection constructor shapes
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
