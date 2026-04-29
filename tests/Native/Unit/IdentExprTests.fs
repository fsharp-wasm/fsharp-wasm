// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/IdentExprTests.fs
// Every way IdentExpr can go wrong
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.IdentExprTests

open Expecto

open Fable.AST
open Fable.AST.Wasm
open WasmGc

open Tests.WasmTestHelper

let private mkIdent name ty : Fable.Expr =
    Fable.Expr.IdentExpr {
    Name = name; Type = ty
    Range = None; IsMutable = false }

[<Tests>]
let identExprTests = testList "IdentExpr" [

    test "local variable → LocalGet" {
        let ctx = { makeTestCtx() with Locals = Map.ofList [("x", WType.I32)] }
        let result = transformExpr ctx (mkIdent "x" Fable.Type.Any)
        match result with
        | WExpr.LocalGet("x", WType.I32) -> ()
        | other -> failtestf "Expected LocalGet(x, I32) but got %A" other
    }

    test "zero-arg KnownFunc (CE builder like 'div') → Call" {
        // counter demo: `div { ... }` desugars to `let b = div in b.Run(...)`
        // 'div' must become WExpr.Call("div", [], ...) not LocalGet
        let ctx = { makeTestCtx() with
                        KnownFuncs = Map.ofList [("div", ([], WType.Ref(99, false)))] }
        let result = transformExpr ctx (mkIdent "div" Fable.Type.Any)
        match result with
        | WExpr.Call("div", [], WType.Ref(99, false)) -> ()
        | WExpr.LocalGet _ -> failtestf "Bug: 'div' was emitted as LocalGet — counter demo will crash"
        | other -> failtestf "Expected Call(div) but got %A" other
    }

    test "local shadows KnownFunc with same name" {
        let ctx = { makeTestCtx() with
                        Locals     = Map.ofList [("f", WType.I32)]
                        KnownFuncs = Map.ofList [("f", ([], WType.Ref(1, false)))] }
        let result = transformExpr ctx (mkIdent "f" Fable.Type.Any)
        match result with
        | WExpr.LocalGet("f", WType.I32) -> ()
        | WExpr.Call _ -> failtestf "Bug: local should shadow KnownFunc"
        | other -> failtestf "Expected LocalGet(f) got %A" other
    }

    test "FuncNameAlias resolves before KnownFunc lookup" {
        // Some modules use aliased names, e.g. "ElementModule_ofHandle" → "ofHandle"
        let ctx = { makeTestCtx() with
                        FuncNameAlias = Map.ofList [("ElementModule_ofHandle", "ofHandle")]
                        KnownFuncs    = Map.ofList [("ofHandle", ([], WType.Ref(10, false)))] }
        let result = transformExpr ctx (mkIdent "ElementModule_ofHandle" Fable.Type.Any)
        match result with
        | WExpr.Call("ofHandle", [], _) -> ()
        | WExpr.LocalGet _ -> failtestf "Alias not resolved — ofHandle was treated as unknown local"
        | other -> failtestf "Expected Call(ofHandle) got %A" other
    }

    test "Fable-encoded @ names: builder$0040_3 → resolved correctly" {
        // Fable encodes `@` as `$0040` in identifier names
        // builder@3 becomes builder$0040_3
        // This is the Let-bound alias for a CE builder reference
        // The inner reference ('div') must be a Call, not LocalGet
        let ctx = { makeTestCtx() with
                        KnownFuncs = Map.ofList [("div", ([], WType.Ref(42, false)))] }
        // Simulate: let builder$0040_3 = div
        let letExpr =
            Fable.Expr.Let(
                { Name = "builder$0040_3"; Type = Fable.Type.Any; Range = None; IsMutable = false },
                mkIdent "div" Fable.Type.Any,    // ← this is the problem
                mkIdent "builder$0040_3" Fable.Type.Any)
        let result = transformExpr ctx letExpr
        // The inner 'div' reference should be a Call, not a LocalGet that crashes emitter
        let hasUnknownLocal =
            WExprQuery.collect (function
                | WExpr.LocalGet("div", _) -> true
                | _ -> false) result
            |> List.isEmpty |> not
        Expect.isFalse hasUnknownLocal "Bug: 'div' inside Let value should be Call, not LocalGet"
    }

    test "todo-style module value → Call or resolved correctly" {
        // todo demo: `todo` is a module-level let `let todo = { ... }`
        // When referenced inside a function body, it should not become LocalGet
        // unless it was explicitly put in Locals (which it isn't for module values)
        let ctx = { makeTestCtx() with
                        KnownFuncs = Map.ofList [("todo", ([], WType.Ref(55, false)))] }
        let result = transformExpr ctx (mkIdent "todo" Fable.Type.Any)
        match result with
        | WExpr.Call _ -> ()
        | WExpr.LocalGet _ -> failtestf "Bug: module-level 'todo' emitted as LocalGet — todo demo will crash"
        | other -> failtestf "Unexpected: %A" other
    }

]
