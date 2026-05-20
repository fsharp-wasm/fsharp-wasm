/// Array BCL helpers — emitted on-demand (like $strConcat etc.)
/// $arraySortWith: insertion sort in place — takes anyref array + cmp closure.
/// Called by arraySortWith in ArrayOps.fs instead of inlining per call site.
module WasmGc.Bcl.ArrayHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Bcl.Helpers

open WasmGc.Builder.Core
open WasmGc.Runtime.LoopPrimitives
open WasmGc.Runtime.QuotationWalker

let private q name body =
    translateReflected name body runtimeTypeMap runtimeIntrinsics |> resolveLocals

/// $arraySortWith(arr: ref $AnyArray, cmp: ref $AnyFn, n: i32) → void
/// Insertion sort in place using the comparison closure.
/// Shared helper: one copy per module regardless of how many Array.sortWith call sites exist.
let makeArraySortWithHelper () : WFuncDecl =
    let gen    = LabelGen "bsort"
    let arrTy  = WType.AnyRef
    let cmpTy  = WType.Ref(AnyFnTypeIdx, false)
    let elemTy = WType.I32  // AnyArray elements stored as i32/anyref; cast at read site
    {   Name    = "$arraySortWith"
        Params  = [("arr", arrTy); ("cmp", cmpTy); ("n", WType.I32)]
        Result  = WType.Void
        Locals  = []
        Exported= false
        Body    =
            let arr = localGet "arr" arrTy
            let cmp = localGet "cmp" cmpTy
            let n   = localGet "n"   WType.I32
            // Insertion sort:
            //   for i = 1 to n-1:
            //     held = arr[i]
            //     j = i - 1
            //     while j >= 0 && cmp(held, arr[j]) < 0:
            //       arr[j+1] = arr[j]; j--
            //     arr[j+1] = held
            let read  a idx = WExpr.ArrayGet(a, idx, elemTy)
            let write a idx v = WExpr.ArraySet(a, idx, v)
            let cmpCall a b  =
                // Call the comparison closure: cmp(a, b) → i32
                WExpr.ClosureApply(cmp, [a; b], AnyFnTypeIdx, AnyFnTypeIdx, 0, WType.I32)
            insertionSortInPlace gen arr n elemTy read write cmpCall
    }
