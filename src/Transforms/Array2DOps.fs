/// Two-dimensional arrays (`'T[,]`, the `Array2D` module).  The front end (the Fable fork) types `'T[,]` as `System.Array`2` and hands every operation over as a
/// call of `Array2D_<name>` (`Array2D_create`, `Array2D_get`, …); this is what those calls become.
///
/// A two-dimensional array is the struct { data: array; rows: i32; cols: i32 }, the element (r, c) at `data.[r * cols + c]`: row by row, as in .NET.  An index
/// out of range raises, as it does for a one-dimensional array (an exception that carries nothing, caught by any `with`).  The module (not a class of the base library) keeps the representation in one place and lets a
/// loop over the cells be a loop of the module, not a call per element.
module WasmGc.Transforms.Array2DOps

open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Builder
open WasmGc.Builder.Core
open WasmGc.Util.FableQuery

type private A2 = { ElemT: WType; ArrIdx: int; Idx: int }

let private a2Of (ctx: Ctx) (t: Fable.Type) : A2 option =
    match t with
    | Fable.Type.DeclaredType(entRef, [ elementType ]) when entRef.FullName = "System.Array`2" ->
        let elemT = mapTypeKnown ctx elementType
        let arrIdx, idx = getOrAddArray2DTypeFor ctx elementType elemT
        Some { ElemT = elemT; ArrIdx = arrIdx; Idx = idx }
    | _ -> None

let private dataOf (a: A2) (arr: WExpr) : WExpr = WExpr.StructGet(arr, 0, WType.Ref(a.ArrIdx, false))
let private rowsOf (arr: WExpr) : WExpr = WExpr.StructGet(arr, 1, WType.I32)
let private colsOf (arr: WExpr) : WExpr = WExpr.StructGet(arr, 2, WType.I32)
let private make (a: A2) (data: WExpr) (rows: WExpr) (cols: WExpr) : WExpr =
    WExpr.StructNew(a.Idx, [ data; rows; cols ], WType.Ref(a.Idx, false))

let private newData (a: A2) (length: WExpr) (init: WExpr) : WExpr =
    WExpr.ArrayNew(a.ArrIdx, length, init, WType.Ref(a.ArrIdx, false))

/// The index into the data of (r, c), after the checks: both below their size (one unsigned comparison each, so that a negative one fails too).
/// `arr`, `r` and `c` are locals or constants: they are read more than once.
let private index (arr: WExpr) (r: WExpr) (c: WExpr) : WExpr =
    wasm {
        do! wasmWhen (WExpr.Compare(WCompareOp.GeU, r, rowsOf arr) ||. WExpr.Compare(WCompareOp.GeU, c, colsOf arr)) (WExpr.Throw WExpr.Nop)
        return r *. colsOf arr +. c
    }

/// `body i j` for every cell, row by row.  `rows` and `cols` are locals or constants.
let private forCells (rows: WExpr) (cols: WExpr) (body: WExpr -> WExpr -> WExpr) : WExpr =
    wasm {
        let! i = mut (i32Const 0)
        let! j = mut (i32Const 0)
        while (i.Val <. rows) do
            do! j.Set(i32Const 0)
            while (j.Val <. cols) do
                do! body i.Val j.Val
                do! j.Set(j.Val +. i32Const 1)
            do! i.Set(i.Val +. i32Const 1)
    }

let tryImport
        (transform: Ctx -> Fable.Expr -> WExpr)
        (ctx: Ctx)
        (selector: string)
        (args: Fable.Expr list)
        (resultFableType: Fable.Type)
        : WExpr option =
    let withLocals (names: (string * WType) list) = names |> List.fold (fun (c: Ctx) (n, t) -> c.WithLocal(n, t)) ctx
    match selector, args with
    | "Array2D_create", [ rows; cols; value ] ->
        a2Of ctx resultFableType
        |> Option.map (fun a ->
            wasm {
                let! r = transform ctx rows
                let! c = transform ctx cols
                let! v = transform ctx value
                let! data = newData a (r *. c) v
                return make a data r c
            })
    | "Array2D_zeroCreate", [ rows; cols ] ->
        a2Of ctx resultFableType
        |> Option.map (fun a ->
            wasm {
                let! r = transform ctx rows
                let! c = transform ctx cols
                let! data = newData a (r *. c) (makeNumericZero a.ElemT)
                return make a data r c
            })
    | "Array2D_get", [ ar; row; col ] ->
        a2Of ctx ar.Type
        |> Option.map (fun a ->
            wasm {
                let! arr = transform ctx ar
                let! r = transform ctx row
                let! c = transform ctx col
                let! i = index arr r c
                return arrayGet (dataOf a arr) i a.ElemT
            })
    | "Array2D_set", [ ar; row; col; value ] ->
        a2Of ctx ar.Type
        |> Option.map (fun a ->
            wasm {
                let! arr = transform ctx ar
                let! r = transform ctx row
                let! c = transform ctx col
                let! v = transform ctx value
                let! i = index arr r c
                do! arraySet (dataOf a arr) i v
            })
    | "Array2D_length1", [ ar ] -> a2Of ctx ar.Type |> Option.map (fun _ -> rowsOf (transform ctx ar))
    | "Array2D_length2", [ ar ] -> a2Of ctx ar.Type |> Option.map (fun _ -> colsOf (transform ctx ar))
    // `a.GetLength 0` and `a.GetLength 1`; any other dimension is the second, where .NET raises
    | "Array2D_getLength", [ ar; dim ] ->
        a2Of ctx ar.Type
        |> Option.map (fun _ ->
            wasm {
                let! arr = transform ctx ar
                let! d = transform ctx dim
                return! wasmIf (d =. i32Const 0) (rowsOf arr) (colsOf arr)
            })
    | "Array2D_get_Length", [ ar ] ->
        a2Of ctx ar.Type
        |> Option.map (fun _ ->
            wasm {
                let! arr = transform ctx ar
                return rowsOf arr *. colsOf arr
            })
    | "Array2D_initialize", [ rows; cols; BinaryLambda(ia, ja, fbody) ] ->
        a2Of ctx resultFableType
        |> Option.map (fun a ->
            let wBody = transform (withLocals [ ia.Name, WType.I32; ja.Name, WType.I32 ]) fbody
            wasm {
                let! r = transform ctx rows
                let! c = transform ctx cols
                let! data = newData a (r *. c) (makeNumericZero a.ElemT)
                do! forCells r c (fun i j -> arraySet data (i *. c +. j) (WExpr.Let(ia.Name, i, WExpr.Let(ja.Name, j, wBody))))
                return make a data r c
            })
    | "Array2D_iterate", [ UnaryLambda(farg, fbody); ar ] ->
        a2Of ctx ar.Type
        |> Option.map (fun a ->
            let wBody = transform (withLocals [ farg.Name, a.ElemT ]) fbody
            wasm {
                let! arr = transform ctx ar
                let! rows = rowsOf arr
                let! cols = colsOf arr
                do! forCells rows cols (fun i j -> WExpr.Let(farg.Name, arrayGet (dataOf a arr) (i *. cols +. j) a.ElemT, wBody))
            })
    | "Array2D_iterateIndexed", [ TernaryLambda(ia, ja, farg, fbody); ar ] ->
        a2Of ctx ar.Type
        |> Option.map (fun a ->
            let wBody = transform (withLocals [ ia.Name, WType.I32; ja.Name, WType.I32; farg.Name, a.ElemT ]) fbody
            wasm {
                let! arr = transform ctx ar
                let! rows = rowsOf arr
                let! cols = colsOf arr
                do! forCells rows cols (fun i j ->
                    WExpr.Let(ia.Name, i, WExpr.Let(ja.Name, j, WExpr.Let(farg.Name, arrayGet (dataOf a arr) (i *. cols +. j) a.ElemT, wBody))))
            })
    | "Array2D_map", [ UnaryLambda(farg, fbody); ar ] ->
        match a2Of ctx ar.Type, a2Of ctx resultFableType with
        | Some a, Some out ->
            let wBody = transform (withLocals [ farg.Name, a.ElemT ]) fbody
            Some(wasm {
                let! arr = transform ctx ar
                let! rows = rowsOf arr
                let! cols = colsOf arr
                let! data = newData out (rows *. cols) (makeNumericZero out.ElemT)
                do! forCells rows cols (fun i j ->
                    let at = i *. cols +. j
                    arraySet data at (WExpr.Let(farg.Name, arrayGet (dataOf a arr) at a.ElemT, wBody)))
                return make out data rows cols
            })
        | _ -> None
    | "Array2D_copy", [ ar ] ->
        a2Of ctx ar.Type
        |> Option.map (fun a ->
            wasm {
                let! arr = transform ctx ar
                let! rows = rowsOf arr
                let! cols = colsOf arr
                let! data = newData a (rows *. cols) (makeNumericZero a.ElemT)
                do! arrayCopy data (i32Const 0) (dataOf a arr) (i32Const 0) (rows *. cols)
                return make a data rows cols
            })
    | _ -> None
