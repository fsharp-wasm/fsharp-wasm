

#r "../../vendor/Fable/lib/fcs/FSharp.Compiler.Service.dll"
#r "../../vendor/Fable/lib/fcs/FSharp.DependencyManager.Nuget.dll"
#r "../../vendor/Fable/src/Fable.AST/bin/Debug/net10.0/Fable.AST.dll"
#r "../../vendor/Fable/src/Fable.Transforms/bin/Debug/net10.0/Fable.Transforms.dll"
#r "../../src/bin/Debug/net10.0/Fable.WasmGc.dll"

#r "../../tests/Native/bin/Debug/net10.0/TestNative.dll"
#r "../../tests/Native/bin/Debug/net10.0/Expecto.dll"

open Expecto
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc

open WasmGc.Transforms.TransformExpr

open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst

let ctx = { makeTestCtx() with
                Locals     = Map.ofList [("x", WType.I32)]
                KnownFuncs = Map.ofList [("helperFn", ([], WType.I32))] }
let lambdaBody =
    Fable.Expr.Let(
        mkParam "tmp" Fable.Type.Any,
        mkIdent "helperFn" Fable.Type.Any,
        mkIdent "x" Fable.Type.Any)
let lambda = Fable.Expr.Lambda(
    mkParam "_" Fable.Type.Unit,
    lambdaBody, None)
let wClosure = transformExpr ctx lambda
// match wClosure with
// | WExpr.Closure(_, captures, _) ->
// printf "CAPTURES are: %A" captures
//     let hasHelperFn = captures |> List.exists (fun (n, _) -> n = "helperFn")
//     Expect.isFalse hasHelperFn "Module-level functions should NOT be captured"
// | other -> failtestf "Expected Closure but got %A" other