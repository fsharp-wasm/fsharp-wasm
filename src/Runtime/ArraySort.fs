
/// Array.sortWith support — one helper PER ARRAY TYPE.
///
/// The former shared `$arraySortWith` could not validate:
///   * it read elements with `array.get` from an `anyref` (no array type);
///   * it called the comparer with `AnyFnTypeIdx` (= the field-less `$AnyFn` STRUCT, index 0) as the
///     call_ref function type.
/// Both need static type information the generic helper does not have, so call sites
/// `Call("$arraySortWith", [arr; cmp; n])` are rewritten to `$arraySortWith_<arrayTypeIdx>` and the
/// helper is generated here, typed for that array, with the comparer's real signature
/// `(self, elem, elem) -> i32`.
module WasmGc.Runtime.ArraySort

open WasmGc.Core.AST
open WasmGc.Core.Traverse
open WasmGc.Runtime.Types

let private helperName (arrIdx: int) = sprintf "$arraySortWith_%d" arrIdx

/// Insertion sort, in place:
///   for i = 1 to n-1:  held = a[i]; j = i-1
///                      while j >= 0 && cmp(held, a[j]) < 0: a[j+1] <- a[j]; j--
///                      a[j+1] <- held
let private buildHelper (ctx: Ctx) (arrIdx: int) (elemTy: WType) : WFuncDecl =
    let arrTy = WType.Ref(arrIdx, false)
    let fti = closureFuncType ctx [ elemTy; elemTy ] WType.I32
    let cti = getOrAddClosureBase ctx fti
    let i32 n = WExpr.Const(WConst.I32 n)
    let get n t = WExpr.LocalGet(n, t)
    let geti n = get n WType.I32
    let add a b = WExpr.Binary(WBinaryOp.Add, a, b, WType.I32)
    let sub a b = WExpr.Binary(WBinaryOp.Sub, a, b, WType.I32)
    let arr = get "arr" arrTy
    let at idx = WExpr.ArrayGet(arr, idx, elemTy)
    let cmp a b = WExpr.ClosureApply(get "cmp" closureSelfTy, [ a; b ], fti, cti, 0, WType.I32)
    let held = get "held" elemTy
    let inner =
        WExpr.Block("sort_inner_exit",
            WExpr.Loop("sort_inner",
                WExpr.If(WExpr.Compare(WCompareOp.LtS, geti "j", i32 0),
                    WExpr.Break("sort_inner_exit", None),
                    WExpr.If(WExpr.Compare(WCompareOp.GeS, cmp held (at (geti "j")), i32 0),
                        WExpr.Break("sort_inner_exit", None),
                        WExpr.Sequence
                            [ WExpr.ArraySet(arr, add (geti "j") (i32 1), at (geti "j"))
                              WExpr.Assign("j", sub (geti "j") (i32 1))
                              WExpr.Continue("sort_inner", []) ],
                        WType.Void),
                    WType.Void),
                WType.Void),
            WType.Void)
    let outer =
        WExpr.Block("sort_exit",
            WExpr.Loop("sort_outer",
                WExpr.If(WExpr.Compare(WCompareOp.GeS, geti "i", geti "n"),
                    WExpr.Break("sort_exit", None),
                    WExpr.Let("held", at (geti "i"),
                        WExpr.LetMut("j", sub (geti "i") (i32 1),
                            WExpr.Sequence
                                [ inner
                                  WExpr.ArraySet(arr, add (geti "j") (i32 1), held)
                                  WExpr.Assign("i", add (geti "i") (i32 1))
                                  WExpr.Continue("sort_outer", []) ])),
                    WType.Void),
                WType.Void),
            WType.Void)
    { Name = helperName arrIdx
      Params = [ "arr", arrTy; "cmp", closureSelfTy; "n", WType.I32 ]
      Result = WType.Void
      Locals = []
      Body = WExpr.LetMut("i", i32 1, outer)
      Exported = false }
    |> WasmGc.Runtime.Locals.resolveLocals

/// Rewrite every `$arraySortWith` call to its per-array-type helper and return the new helpers.
let specialize (ctx: Ctx) (functions: WFuncDecl list) : WFuncDecl list =
    let needed = System.Collections.Generic.Dictionary<int, WType>()
    let rewriteNode (e: WExpr) =
        match e with
        | WExpr.Call("$arraySortWith", (arrArg :: rest), ty) ->
            match exprWType arrArg with
            | WType.Ref(arrIdx, _) ->
                match ctx.TypeDefs.[arrIdx].Def with
                | WTypeDef.Array(elemTy, _) ->
                    needed.[arrIdx] <- elemTy
                    Some(WExpr.Call(helperName arrIdx, arrArg :: rest, ty))
                | _ -> failwithf "Array.sortWith: type %d (%s) is not an array" arrIdx ctx.TypeDefs.[arrIdx].Name
            | other -> failwithf "Array.sortWith: cannot determine the array type of the argument (%A)" other
        | _ -> None
    let rewritten = functions |> List.map (fun f -> { f with Body = rewrite rewriteNode f.Body })
    let helpers = needed |> Seq.map (fun kv -> buildHelper ctx kv.Key kv.Value) |> Seq.toList
    rewritten @ helpers
