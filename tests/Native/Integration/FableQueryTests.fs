// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/FableQueryTests.fs
// FableQuery active patterns work correctly
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.FableQueryTests

open Expecto
open Fable.AST
open Fable.AST.Fable

open Tests.WasmTestHelper
open Tests.WasmTestHelper.FableAst

[<Tests>]
let fableQueryTests = testList "FableQuery patterns" [

    test "UnaryLambda matches Lambda" {
        let farg = mkParam "x" Fable.Type.Any
        let expr = Lambda(farg, IdentExpr farg, None)
        match expr with
        | FableQuery.UnaryLambda(arg, body) ->
            Expect.equal arg.Name "x" "arg should be x"
        | _ -> failtest "UnaryLambda should match Lambda"
    }

    test "UnaryLambda matches single Delegate" {
        let farg = mkParam "x" Fable.Type.Any
        let expr = Delegate([farg], IdentExpr farg, None, [])
        match expr with
        | FableQuery.UnaryLambda(arg, body) ->
            Expect.equal arg.Name "x" "arg should be x"
        | _ -> failtest "UnaryLambda should match Delegate([x], ...)"
    }

    test "BinaryLambda matches curried Lambda" {
        let a1 = mkParam "a" Fable.Type.Any
        let a2 = mkParam "b" Fable.Type.Any
        let expr = Lambda(a1, Lambda(a2, IdentExpr a2, None), None)
        match expr with
        | FableQuery.BinaryLambda(arg1, arg2, body) ->
            Expect.equal arg1.Name "a" "first arg"
            Expect.equal arg2.Name "b" "second arg"
        | _ -> failtest "BinaryLambda should match curried Lambda"
    }

    test "HofArgs matches (lambda, list) order" {
        let farg = mkParam "x" Fable.Type.Any
        let lambda = Lambda(farg, IdentExpr farg, None)
        let list = IdentExpr (mkParam "xs" (Type.List Fable.Type.Any))
        match [lambda; list] with
        | FableQuery.HofArgs(arg, body, coll) ->
            Expect.equal arg.Name "x" "lambda arg"
        | _ -> failtest "HofArgs should match [lambda; collection]"
    }

    test "FoldArgs matches (binary-lambda, init, coll)" {
        let acc = mkParam "acc" Fable.Type.Any
        let elem = mkParam "elem" Fable.Type.Any
        let folder = Lambda(acc, Lambda(elem, IdentExpr acc, None), None)
        let init = Value(NumberConstant(0.0, Int32, NumberInfo.Empty), None)
        let coll = IdentExpr (mkParam "xs" (Type.List Fable.Type.Any))
        match [folder; init; coll] with
        | FableQuery.FoldArgs(a, e, body, i, c) ->
            Expect.equal a.Name "acc" "accumulator param"
            Expect.equal e.Name "elem" "element param"
        | _ -> failtest "FoldArgs should match [binaryLambda; init; collection]"
    }

    test "ListOf matches List<int>" {
        match Type.List(Type.Number(Int32, NumberInfo.Empty)) with
        | FableQuery.ListOf elemT -> Expect.equal elemT (Type.Number(Int32, NumberInfo.Empty)) "elem type"
        | _ -> failtest "ListOf should match List<int>"
    }

    test "ArrayOf matches Array<string>" {
        match Type.Array(Type.String, ArrayKind.Array) with
        | FableQuery.ArrayOf elemT -> Expect.equal elemT Type.String "string element"
        | _ -> failtest "ArrayOf should match Array<string>"
    }

    test "OptionOf matches Option<float>" {
        match Type.Option(Type.Number(Float64, NumberInfo.Empty)) with
        | FableQuery.OptionOf inner -> Expect.equal inner (Type.Number(Float64, NumberInfo.Empty)) "float inner"
        | _ -> failtest "OptionOf should match Option<float>"
    }

]
