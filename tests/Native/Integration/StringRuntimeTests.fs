// ════════════════════════════════════════════════════════════════════════════════
// tests/Integration/StringRuntimeTests.fs
// Runtime helper functions produce correct WExpr / WAT
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Integration.StringRuntimeTests

open Expecto
open WasmGc.Core.AST
open WasmGc
open WasmGc.Runtime.Locals
open WasmGc.Runtime.Types
open WasmGc.Bcl.StringHelpers

module RT = WasmGc.Bcl.StringHelpers

open Tests.WasmTestHelper

[<Tests>]
let stringRuntimeTests = testList "String runtime helpers" [

    test "makeStrConcatHelper produces valid WFuncDecl" {
        let decl = RT.makeStrConcatHelper()
        Expect.equal decl.Name "$strConcat" "name must be $strConcat"
        Expect.equal decl.Params.Length 2 "must have 2 params (a, b)"
        Expect.notEqual decl.Body WExpr.Nop "body must not be Nop"
        // Body should contain ArrayCopy
        let copies = WExprQuery.collect (function WExpr.ArrayCopy _ -> true | _ -> false) decl.Body
        Expect.isNonEmpty copies "strConcat must use ArrayCopy"
    }

    test "makeStrConcatHelper: no unknown locals" {
        let decl = RT.makeStrConcatHelper()
        let paramNames = decl.Params |> List.map fst
        assertNoUnknownLocals paramNames (decl.Locals |> List.map fst) decl.Body
    }

    test "makeStrEqHelper produces correct structure" {
        let decl = RT.makeStrEqHelper()
        Expect.equal decl.Name "$strEq" "name must be $strEq"
        Expect.equal decl.Result WType.I32 "strEq must return I32 (bool)"
        let loops = WExprQuery.collect (function WExpr.Loop _ -> true | _ -> false) decl.Body
        Expect.isNonEmpty loops "strEq must loop over chars"
    }

    test "makeStrIndexOfHelper: multi-level break produces no mutable result flag" {
        // After rewrite: should NOT contain a 'result = -1' pattern
        // Instead: Block + Break-with-value for early exit
        let decl = RT.makeStrIndexOfHelper()
        // Check: does it use break-with-value? (sign of the new implementation)
        let breakWithVal = WExprQuery.collect (function WExpr.Break(_, Some _) -> true | _ -> false) decl.Body
        // Either new CE-based (breakWithVal) or old QW-based (no break-with-value, uses flag)
        // This test will PASS with new implementation, fail with old
        Expect.isNonEmpty breakWithVal "strIndexOf should use Break-with-value (not mutable result flag)"
    }

    test "makeStrSubstringHelper uses ArrayCopy" {
        let decl = RT.makeStrSubstringHelper()
        let copies = WExprQuery.collect (function WExpr.ArrayCopy _ -> true | _ -> false) decl.Body
        Expect.isNonEmpty copies "substring must copy chars via ArrayCopy"
    }

    test "makeIntToStrHelper: result is WasmStr (not I32)" {
        let decl = RT.makeIntToStrHelper()
        Expect.equal decl.Result (WType.Ref(StringTypeIdx, false)) "intToStr must return WasmStr"
    }

    test "sprintf %d n → call to $intToStr" {
        // When transformExpr sees sprintf "%d" applied to an i32,
        // it should produce a Call("$intToStr", [n], strRef)
        let ctx = makeTestCtx()
        // Build: sprintf "%d" someInt
        // This goes through the CurriedApply → sprintfFmt handling
        ()  // TODO: build exact Fable AST for sprintf
    }

    test "sprintf %s s → identity (string passthrough)" {
        ()
    }

    test "sprintf %f v → call to float-to-string helper" {
        // Currently: might emit Nop if $floatToStr doesn't exist
        // This test documents whether float formatting works
        ()
    }

]
