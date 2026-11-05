
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

// let private q name body =
//     translateReflected name body runtimeTypeMap runtimeIntrinsics |> resolveLocals

/// `$arraySortWith` — kept only so that `UsedHelpers` still resolves the name.
///
/// The real implementation is generated PER ARRAY TYPE by `Runtime.ArraySort.specialize`, which rewrites
/// every call site to `$arraySortWith_<arrayTypeIdx>`.  The previous generic version (anyref array,
/// `AnyFnTypeIdx` as call_ref function type) could not pass validation.
let makeArraySortWithHelper () : WFuncDecl =
    {   Name    = "$arraySortWith"
        Params  = [("arr", WType.AnyRef); ("cmp", WType.Ref(AnyFnTypeIdx, false)); ("n", WType.I32)]
        Result  = WType.Void
        Locals  = []
        Exported= false
        Body    = WExpr.Nop
    }
