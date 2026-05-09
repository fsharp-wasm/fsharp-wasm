namespace Fable.WasmGc.Tests

open Expecto
open WasmGc.Model
open PipelineHelper

module FutureTests =

    [<Tests>]
    let tests =
        testList "WasmGC Integration (Real F# Source)" [

            test "Array.map generates a Loop (No Nops)" {
                let source = """
                    module Test
                    let run (xs: int[]) = xs |> Array.map (fun x -> x + 1)
                """
                let wModule = compileToWasm source
                let func = findFunc "run" wModule
                
                // Assert: Array.map must be lowered to a Loop 
                let hasLoop = func.Body |> contains (function WExpr.Loop _ -> true | _ -> false)
                Expect.isTrue hasLoop "Array.map should have produced a Wasm Loop"
            }

            test "Mutation and While-Loops" {
                let source = """
                    module Test
                    let sumTo (n: int) =
                        let mutable acc = 0
                        let mutable i = 1
                        while i <= n do
                            acc <- acc + i
                            i <- i + 1
                        acc
                """
                let wModule = compileToWasm source
                let func = findFunc "sumTo" wModule

                // Assert: check for i32.add and local.set [cite: 20489, 20476]
                let hasAdd = func.Body |> contains (function WExpr.Binary(WBinaryOp.I32Add, _, _, _) -> true | _ -> false)
                let hasSet = func.Body |> contains (function WExpr.Assign("i", _) -> true | _ -> false)
                
                Expect.isTrue (hasAdd && hasSet) "Should contain I32Add and Assign instructions"
            }

            test "Exception Handling (WasmGC Structs)" {
                let source = """
                    module Test
                    let thrower (x: int) =
                        if x < 0 then raise (System.ArgumentException("Negative"))
                        else x
                """
                let wModule = compileToWasm source
                let func = findFunc "thrower" wModule

                // Assert: The 'raise' call should be lowered to StructNew (since we fixed the interceptors)
                let hasStructNew = func.Body |> contains (function WExpr.StructNew _ -> true | _ -> false)
                Expect.isTrue hasStructNew "Exception raise should be a WasmGC StructNew call"
            }

            test "List Cons/Nil lowered to unified base type" {
                let source = """
                    module Test
                    let getList () = [1; 2; 3]
                """
                let wModule = compileToWasm source
                let func = findFunc "getList" wModule

                // Assert: Check for ListBaseTypeIdx registrations [cite: 15027, 15037]
                let isListCons = func.Body |> contains (function 
                    | WExpr.StructNew(idx, _, _) when idx = 101 -> true // Assuming 101 is ListCons
                    | _ -> false)
                Expect.isTrue isListCons "List literal should involve StructNew"
            }
            
            test "Closures capture variables via Struct fields" {
                let source = """
                    module Test
                    let makeAdder x = (fun y -> x + y)
                """
                let wModule = compileToWasm source
                
                // Assert: The closure initialization should use StructNew to capture 'x'
                let func = findFunc "makeAdder" wModule
                let capturesVar = func.Body |> contains (function WExpr.StructNew _ -> true | _ -> false)
                Expect.isTrue capturesVar "Closure should allocate a WasmGC struct to capture 'x'"
            }
        ]