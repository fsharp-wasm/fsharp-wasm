module WasmGc.Util.FableQuery

open Fable.AST
open Fable.AST.Fable

// ── Lambda shapes ─────────────────────────────────────────────────

/// Matches a single-arg lambda or single-element delegate.
let (|UnaryLambda|_|) = function
    | Lambda(arg, body, _)
    | Delegate([arg], body, _, _) -> Some(arg, body)
    | _ -> None

/// Matches a curried 2-arg lambda or 2-element delegate.
let (|BinaryLambda|_|) = function
    | Lambda(a1, Lambda(a2, body, _), _)
    | Delegate([a1; a2], body, _, _) -> Some(a1, a2, body)
    | _ -> None

/// Matches a curried 3-arg lambda.
let (|TernaryLambda|_|) = function
    | Lambda(a1, Lambda(a2, Lambda(a3, body, _), _), _)
    | Delegate([a1; a2; a3], body, _, _) -> Some(a1, a2, a3, body)
    | _ -> None

// ── Type shapes ───────────────────────────────────────────────────

let (|ListOf|_|) = function
    | Type.List t -> Some t
    | Type.DeclaredType(_, [t]) -> Some t // seq<T> coercion
    | _ -> None

let (|ArrayOf|_|) = function
    | Type.Array(t, _) -> Some t
    | _ -> None

let (|ResizeArrayOf|_|) = function
    | Type.Array(t, ArrayKind.ResizeArray) -> Some t
    | _ -> None

let (|OptionOf|_|) = function
    | Type.Option(t, _) -> Some t
    | _ -> None

let (|TupleOf|_|) = function
    | Type.Tuple(ts, _) -> Some ts
    | _ -> None

// ── Call shapes ───────────────────────────────────────────────────

/// LibCall: matches a call to a Fable standard library function.
/// Returns (moduleStem, memberName, args).
let (|LibCall|_|) = function
    | Call(Import({ Selector = sel; Path = path }, _, _), callInfo, _, _)
          when path.EndsWith(".js") || path.Contains("fable-library") ->
        let stem = System.IO.Path.GetFileNameWithoutExtension(path)
        Some(stem, sel, callInfo.Args)
    | _ -> None

/// ImportCall: matches a call to a user-declared [<Import>] function.
let (|ImportCall|_|) = function
    | Call(Import({ Selector = sel; Path = path }, _, _), callInfo, _, _) ->
        Some(sel, path, callInfo.Args)
    | _ -> None

/// ResizeArray.push call (Emit wrapping).
let (|ResizeArrayPush|_|) = function
    | Emit({ Macro = "void ($0)" }, _, _) -> None // handled separately
    | Call(Get(arr, FieldGet fi, _, _), callInfo, _, _)
          when fi.Name = "push" ->
        match arr.Type with
        | ResizeArrayOf elemT -> Some(arr, elemT, callInfo.Args)
        | _ -> None
    | _ -> None

// ── Pattern helpers for common HOF shapes ─────────────────────────

/// Matches the standard (f, list) argument shape for List/Array HOFs.
let (|HofArgs|_|) = function
    | [UnaryLambda(farg, fbody); collection] -> Some(farg, fbody, collection)
    | [collection; UnaryLambda(farg, fbody)] -> Some(farg, fbody, collection)
    | _ -> None

/// Matches the fold (folder, init, collection) shape.
let (|FoldArgs|_|) = function
    | [BinaryLambda(acc, elem, body); init; coll] -> Some(acc, elem, body, init, coll)
    | _ -> None

// ── Value shapes ──────────────────────────────────────────────────

let private numberValueToInt = function
    | NumberValue.Int8 n -> Some(int n)
    | NumberValue.UInt8 n -> Some(int n)
    | NumberValue.Int16 n -> Some(int n)
    | NumberValue.UInt16 n -> Some(int n)
    | NumberValue.Int32 n -> Some(int n)
    | NumberValue.UInt32 n -> Some(int n)
    | NumberValue.NativeInt n -> Some(int n)
    | NumberValue.UNativeInt n -> Some(int n)
    | _ -> None

let private numberValueToFloat = function
    | NumberValue.Float16 n -> Some(float n)
    | NumberValue.Float32 n -> Some(float n)
    | NumberValue.Float64 n -> Some(float n)
    | NumberValue.Decimal n -> Some(float n)
    | NumberValue.Int8 n -> Some(float n)
    | NumberValue.UInt8 n -> Some(float n)
    | NumberValue.Int16 n -> Some(float n)
    | NumberValue.UInt16 n -> Some(float n)
    | NumberValue.Int32 n -> Some(float n)
    | NumberValue.UInt32 n -> Some(float n)
    | NumberValue.Int64 n -> Some(float n)
    | NumberValue.UInt64 n -> Some(float n)
    | NumberValue.NativeInt n -> Some(float n)
    | NumberValue.UNativeInt n -> Some(float n)
    | _ -> None

let (|IntLit|_|) = function
    | Value(NumberConstant(n, _), _) -> numberValueToInt n
    | _ -> None

let (|StrLit|_|) = function
    | Value(StringConstant s, _) -> Some s
    | _ -> None

let (|BoolLit|_|) = function
    | Value(BoolConstant b, _) -> Some b
    | _ -> None

let (|UnitVal|_|) = function
    | Value(UnitConstant, _) -> Some()
    | _ -> None

// ── Additional value patterns ──────────────────────────────────────

let (|NullLit|_|) = function
    | Value(Null _, _) -> Some()
    | _ -> None

let (|FloatLit|_|) = function
    | Value(NumberConstant(n, _), _) -> numberValueToFloat n
    | _ -> None

let (|CharLit|_|) = function
    | Value(CharConstant c, _) -> Some c
    | _ -> None

// ── More type patterns ────────────────────────────────────────────

let (|NamedType|_|) (name: string) = function
    | Type.DeclaredType(entity, _) when entity.FullName = name -> Some()
    | _ -> None

let (|GenericType|_|) = function
    | Type.DeclaredType(_, typeArgs) when not (List.isEmpty typeArgs) -> Some typeArgs
    | _ -> None

let (|FunctionType|_|) = function
    | Type.LambdaType(arg, ret) -> Some([arg], ret)
    | Type.DelegateType(args, ret) -> Some(args, ret)
    | _ -> None

let (|MaybeTuple|_|) = function
    | Type.Tuple([a; b], _) -> Some(a, b)
    | _ -> None

// ── Declaration patterns ──────────────────────────────────────────

let (|IsExported|_|) (decl: Declaration) =
    let hasExportTag (tags: string list) =
        tags |> List.exists (fun t -> t.Equals("export", System.StringComparison.OrdinalIgnoreCase))

    match decl with
    | MemberDeclaration m when hasExportTag m.Tags -> Some()
    | ClassDeclaration c when hasExportTag c.Tags -> Some()
    | _ -> None

let (|IsAbstract|_|) (decl: Declaration) =
    let hasAbstractTag (tags: string list) =
        tags |> List.exists (fun t -> t.Equals("abstract", System.StringComparison.OrdinalIgnoreCase))

    match decl with
    | ClassDeclaration c when hasAbstractTag c.Tags -> Some()
    | _ -> None

// ── Expression leaf patterns ──────────────────────────────────────

let (|Null|_|) = function
    | Value(Null _, _) -> Some()
    | _ -> None

let (|GetField|_|) = function
    | Get(obj, FieldGet fi, _, _) -> Some(obj, fi)
    | _ -> None

let (|SetField|_|) = function
    | Set(obj, FieldSet fieldName, _, value, _) -> Some(obj, fieldName, value)
    | _ -> None

let (|GetIndex|_|) = function
    | Get(obj, ExprGet indexExpr, _, _) -> Some(obj, indexExpr)
    | _ -> None

let (|SetIndex|_|) = function
    | Set(obj, ExprSet indexExpr, _, value, _) -> Some(obj, indexExpr, value)
    | _ -> None

// ── Control flow patterns ─────────────────────────────────────────

let (|IfExpr|_|) = function
    | IfThenElse(g, t, e, _) -> Some(g, t, e)
    | _ -> None

let (|WhileExpr|_|) = function
    | WhileLoop(g, b, _) -> Some(g, b)
    | _ -> None

let (|ForExpr|_|) = function
    | ForLoop(i, s, e, b, _, _) -> Some(i, s, e, b)
    | _ -> None

let (|TryExpr|_|) = function
    | TryCatch(b, c, f, _) -> Some(b, c, f)
    | _ -> None

// ── Matcher patterns for common operations ─────────────────────────

let (|ListCons|_|) = function
    | Call(Import({ Selector = "cons" }, _, _), _, _, _) -> Some()
    | _ -> None

let (|ListEmpty|_|) = function
    | Call(Import({ Selector = "empty" }, _, _), _, _, _) -> Some()
    | _ -> None

let (|ListMap|_|) = function
    | Call(Import({ Selector = "map" }, _, _), callInfo, _, _) -> Some(callInfo.Args)
    | Call(Get(li, _, _, _), _, _, _) when li.Type = Type.List(Type.Any) -> Some([])
    | _ -> None

let (|ArrayCreate|_|) = function
    | Call(Import({ Selector = "zeroCreate" }, _, _), callInfo, _, _) -> Some(callInfo.Args)
    | _ -> None

// ── Number and string operations ───────────────────────────────────

let (|StringConcat|_|) = function
    | Call(Import({ Selector = "concat" }, _, _), callInfo, _, _) -> Some(callInfo.Args)
    | _ -> None

let (|StringLength|_|) = function
    | Get(str_, FieldGet fi, _, _) when fi.Name = "Length" -> Some(str_)
    | _ -> None

let (|StringIndex|_|) = function
    | Get(str_, ExprGet idx, _, _) -> Some(str_, idx)
    | _ -> None

// ── Complex pattern: nested lambda chains ─────────────────────────

/// Matches N-arg lambda by deconstructing nested Lambdas.
let (|NaryLambda|_|) (n: int) (expr: Expr) : (Ident list * Expr) option =
    let rec collect acc count e =
        if count = 0 then
            Some(List.rev acc, e)
        else
            match e with
            | Lambda(arg, body, _) -> collect (arg :: acc) (count - 1) body
            | _ -> None

    collect [] n expr
