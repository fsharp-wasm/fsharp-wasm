/// String and char runtime helpers for WasmGC.
/// Local variable collection lives in Locals.fs.
/// Structural equality lives in WasmGcEquality.fs.
module WasmGc.Runtime.Runtime

open WasmGc.Core.AST
open WasmGc.Runtime.Types

open WasmGc.Builder
open WasmGc.Builder.Core

open WasmGc.Runtime.Locals
// open WasmGc.Runtime.QuotationWalker

// ─────────────────────────────────────────────────────────────────────────────
// BCL helpers have been extracted to src/Bcl/:
//   StringHelpers.fs    — $strConcat, $strEq, $strIndexOf, $intToStr, etc.
//   CharHelpers.fs      — $charIsDigit, $charToLower, etc.
//   MathHelpers.fs      — $pown, $powF64, $mathSin, etc.
//   StringBuilderHelpers.fs — $sbCreate, $sbAppend, $sbToString
//
// The BCL registry (BclRegistry.fs) maps helper names → builder functions
// and resolves transitive dependencies. buildWModule calls BclRegistry.emitUsed.
// ─────────────────────────────────────────────────────────────────────────────

/// After all functions are translated, give every ClosureApply / TailCallRef whose
/// ClosureBase was unknown at the call site (closureTypeIdx = 0) its ClosureBase type.
///
/// A ClosureBase may be unknown when a higher-order function receives a closure parameter
/// but no closure with that exact apply signature was constructed before the call was
/// translated (e.g. Set.iter takes (int -> unit) but every built closure has captures).
///
/// Uses the exhaustive `Traverse.rewrite`: the previous hand-written recursion skipped
/// Closure captures, Cast, StructGet, ArrayGet, Return, Continue, JoinApply, ... so
/// ClosureApply nodes below them kept index 0 and produced `struct.get $AnyFn 0`.
let fixClosureApply (typeDefs: ResizeArray<WTypeDeclEntry>) (functions: WFuncDecl list) : WFuncDecl list =
    // funcTypeIdx -> ClosureBase struct.  Only direct subtypes of $AnyFn count:
    // concrete closure structs have a ClosureBase (non-zero index) as supertype.
    let funcTypeToClosureMap =
        let d = System.Collections.Generic.Dictionary<int, int>()
        typeDefs
        |> Seq.iteri (fun i entry ->
            match entry.Def with
            | WTypeDef.Struct({ Name = "code"; Type = WType.Ref(funcTypeIdx, _) } :: _, Some parent)
                when parent = AnyFnTypeIdx && not (d.ContainsKey funcTypeIdx) ->
                d.[funcTypeIdx] <- i
            | _ -> ())
        d

    let getOrCreateClosureBase (funcTypeIdx: int) : int =
        match funcTypeToClosureMap.TryGetValue funcTypeIdx with
        | true, cti -> cti
        | false, _ ->
            (match typeDefs.[funcTypeIdx].Def with
             | WTypeDef.Func _ -> ()
             | other -> failwithf "closure call refers to type %d (%s) which is not a function type: %A" funcTypeIdx typeDefs.[funcTypeIdx].Name other)
            let idx = typeDefs.Count
            typeDefs.Add
                { Name = $"ClosureBase_{idx}"
                  Def = WTypeDef.Struct([ { Name = "code"; Type = WType.Ref(funcTypeIdx, false); Mutable = false } ], Some AnyFnTypeIdx) }
            funcTypeToClosureMap.[funcTypeIdx] <- idx
            idx

    let fixNode =
        function
        | WExpr.ClosureApply(c, a, fti, 0, cc, ty) -> Some(WExpr.ClosureApply(c, a, fti, getOrCreateClosureBase fti, cc, ty))
        | WExpr.TailCallRef(c, a, fti, 0, cc, ty) -> Some(WExpr.TailCallRef(c, a, fti, getOrCreateClosureBase fti, cc, ty))
        | _ -> None

    functions |> List.map (fun f -> { f with Body = WasmGc.Core.Traverse.rewrite fixNode f.Body })
