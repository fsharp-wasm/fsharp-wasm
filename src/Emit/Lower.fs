module Lower

open AST // Assuming your WExpr / WType definitions live here

// A helper to generate unique local names to avoid conflicts during lowering
let mutable tmpVarCounter = 0
let freshTempName prefix = 
    tmpVarCounter <- tmpVarCounter + 1
    sprintf "$%s_%d" prefix tmpVarCounter

/// Recursively lowers high-level AST nodes into standard WASM LIR
let rec lowerExpr (expr: WExpr) : WExpr =
    match expr with
    // ── Lowering Closures ──────────────────────────────────────────────
    | WExpr.ClosureApply(closure, args, funcTypeIdx, closureTypeIdx, _, _) ->
        let loweredClosure = lowerExpr closure
        let loweredArgs = args |> List.map lowerExpr
        
        let tmpName = freshTempName "clo_tmp"
        let tmpType = WType.Ref(closureTypeIdx, false)

        // Lower into: 
        // block { 
        //   let tmp = cast(closure); 
        //   call_ref (tmp, args..., tmp.code_ptr) 
        // }
        WExpr.Block(
            [ tmpName, tmpType ], // Inject temp variable declaration
            [
                WExpr.LocalSet(tmpName, WExpr.RefCast(loweredClosure, tmpType))
                WExpr.CallRef(
                    funcTypeIdx,
                    // The 'self' argument
                    WExpr.LocalGet(tmpName) :: loweredArgs, 
                    // The code pointer extracted from the closure struct
                    WExpr.StructGet(WExpr.LocalGet(tmpName), 0, closureTypeIdx)
                )
            ]
        )

    | WExpr.TailCallRef(closure, args, funcTypeIdx, closureTypeIdx, _, _) ->
        // Same logic as above, but outputting a WExpr.ReturnCallRef instead
        let loweredClosure = lowerExpr closure
        let loweredArgs = args |> List.map lowerExpr
        let tmpName = freshTempName "tail_tmp"
        let tmpType = WType.Ref(closureTypeIdx, false)

        WExpr.Block(
            [ tmpName, tmpType ],
            [
                WExpr.LocalSet(tmpName, WExpr.RefCast(loweredClosure, tmpType))
                WExpr.ReturnCallRef(
                    funcTypeIdx,
                    WExpr.LocalGet(tmpName) :: loweredArgs,
                    WExpr.StructGet(WExpr.LocalGet(tmpName), 0, closureTypeIdx)
                )
            ]
        )

    // ── Lowering SwitchInt ─────────────────────────────────────────────
    | WExpr.SwitchInt(target, cases, defaultCase) ->
        let loweredTarget = lowerExpr target
        let loweredCases = cases |> List.map (fun (v, e) -> v, lowerExpr e)
        let loweredDefault = lowerExpr defaultCase
        
        // Transform the switch statement into a standard WASM BrTable (or nested Ifs)
        // This removes the need for Emit.fs to manage $switch_tmp
        let tmpName = freshTempName "switch_tmp"
        
        // (Implementation details of BrTable lowering omitted for brevity, 
        // but the concept is mapping cases to block targets here)
        WExpr.Block(
            [ tmpName, WType.I32 ],
            [
                WExpr.LocalSet(tmpName, loweredTarget)
                // ... generate BrTable using WExpr.LocalGet(tmpName)
                loweredDefault // Dummy placeholder
            ]
        )

    // ── Standard Node Traversal ────────────────────────────────────────
    // For nodes that are already low-level, just recurse
    | WExpr.If(cond, thn, els) -> 
        WExpr.If(lowerExpr cond, lowerExpr thn, lowerExpr els)
    | WExpr.BinaryOp(op, left, right) -> 
        WExpr.BinaryOp(op, lowerExpr left, lowerExpr right)
    | _ -> expr

/// Lowers an entire WebAssembly module
let lowerModule (wmod: WModule) : WModule =
    { wmod with
        Functions = 
            wmod.Functions 
            |> List.map (fun f -> 
                { f with Body = lowerExpr f.Body })
    }