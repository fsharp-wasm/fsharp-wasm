// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/WhileBangTests.fs
// while! in different compiler configurations
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.WhileBangTests

open Expecto
open Fable.AST.Wasm
open Fable.Transforms.WasmGc.Builder
open Fable.Transforms.WasmGc.Builder

[<Tests>]
let whileBangTests = testList "while! loop generation" [

    test "while! guard → makeWhileLoop structure" {
        let guard = ltS (localGet "i" WType.I32) (i32Const 10)
        let body  = localSet "i" (add (localGet "i" WType.I32) (i32Const 1))
        let result = wasm {
            while! guard do
                do! body
        }
        // Structure: Block($exit, Loop($lp, If(guard, Seq(body, Continue), Break)))
        match result with
        | WExpr.Block(exitLbl, WExpr.Loop(loopLbl, WExpr.If(_, _, WExpr.Break(exitLbl2, None), _), _), _)
            when exitLbl = exitLbl2 ->
            ()
        | other -> failtestf "while! should produce Block/Loop/If/Break: %A" other
    }

    test "while! guard references mutable var correctly" {
        let result = wasm {
            let! i = mut (i32Const 0)
            while! (ltS i.Val (i32Const 5)) do
                do! i <== add i.Val (i32Const 1)
            return i.Val
        }
        let loops = WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result
        Expect.isNonEmpty loops "while! with WVar should produce Loop"
    }

    test "nested while! loops each get unique labels" {
        let result = wasm {
            let! i = mut (i32Const 0)
            while! (ltS i.Val (i32Const 3)) do
                let! j = mut (i32Const 0)
                while! (ltS j.Val (i32Const 3)) do
                    do! j <== add j.Val (i32Const 1)
                do! i <== add i.Val (i32Const 1)
        }
        // Collect all loop labels
        let labels =
            WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result
            |> List.choose (function WExpr.Loop(lbl, _, _) -> Some lbl | _ -> None)
        // All labels must be unique
        Expect.equal labels.Length (List.distinct labels |> List.length) "All loop labels must be unique"
    }

    test "while! with Wasm.labeledBlock for early exit" {
        let result = wasm {
            let! i = mut (i32Const 0)
            return! Wasm.labeledBlock (LabelGen "search") "blk" WType.I32 (fun ctrl -> wasm {
                while! (ltS i.Val (i32Const 10)) do
                    if (i32Const 1 |> ignore; true) then  // simplification
                        do! ctrl.BreakWith (i.Val)
                    do! i <== add i.Val (i32Const 1)
                return i32Const (-1)
            })
        }
        let breakWithVal = WExprQuery.collect (function WExpr.Break(_, Some _) -> true | _ -> false) result
        Expect.isNonEmpty breakWithVal "labeledBlock should have Break-with-value"
    }

    test "listFold uses while! correctly" {
        let s = mkListShape WType.I32 100
        let gen = LabelGen "fold"
        let result = listFold gen s (WExpr.Const(WConst.Null s.BaseTy)) (i32Const 0) WType.I32
                        (fun acc elem -> add acc elem)
        let loops = WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) result
        Expect.isNonEmpty loops "listFold should produce a Loop via while!"
    }

]
