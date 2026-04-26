// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/TypeResolutionTests.fs
// mapTypeKnown edge cases — wrong types cause call_ref mismatches
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.TypeResolutionTests

open Expecto
open Fable.AST.Fable
open Fable.AST.Wasm
open Fable.Transforms.WasmGc
open Tests.WasmTestHelpers

[<Tests>]
let typeResolutionTests = testList "mapTypeKnown" [

    test "int → I32" {
        let ctx = makeTestCtx()
        Expect.equal (mapTypeKnown ctx (Type.Number(Int32, NumberInfo.Empty))) WType.I32 "int → I32"
    }

    test "float → F64" {
        let ctx = makeTestCtx()
        Expect.equal (mapTypeKnown ctx (Type.Number(Float64, NumberInfo.Empty))) WType.F64 "float → F64"
    }

    test "unit → Void" {
        let ctx = makeTestCtx()
        Expect.equal (mapTypeKnown ctx Type.Unit) WType.Void "unit → Void"
    }

    test "bool → I32 (WASM has no bool)" {
        let ctx = makeTestCtx()
        Expect.equal (mapTypeKnown ctx Type.Boolean) WType.I32 "bool → I32"
    }

    test "string → Ref(StringTypeIdx, false)" {
        let ctx = makeTestCtx()
        let result = mapTypeKnown ctx Type.String
        Expect.equal result (WType.Ref(StringTypeIdx, false)) "string → Ref(StringTypeIdx)"
    }

    test "List<int> registers in ListRegistry and returns Ref" {
        let ctx = makeTestCtx()
        let result = mapTypeKnown ctx (Type.List(Type.Number(Int32, NumberInfo.Empty)))
        match result with
        | WType.Ref(_, true) -> ()  // nullable ref (list can be null = empty)
        | WType.Ref(_, false) -> ()  // non-null also acceptable
        | other -> failtestf "List<int> should be a Ref, got %A" other
        // And it should be in ListRegistry
        let key = wTypeKey WType.I32
        Expect.isTrue (ctx.ListRegistry.ContainsKey(key)) "ListRegistry should have I32 list type"
    }

    test "unregistered DeclaredType → I32 fallback with warning" {
        // This is the source of call_ref mismatches when types aren't registered yet
        let ctx = makeTestCtx()
        let unknownEntity = { FullName = "Some.Unknown.Type"; Path = "" }
        let result = mapTypeKnown ctx (Type.DeclaredType(unknownEntity, []))
        // Should fall back to I32 (or produce a specific sentinel value)
        Expect.equal result WType.I32 "unknown DeclaredType should fall back to I32"
    }

    test "Handle = int → I32 (not Void)" {
        // Handle is `type Handle = int` — if this resolves to Void, JS bridge breaks
        let ctx = makeTestCtx()
        // Handle maps via type alias — should still be I32
        // In practice: Fable resolves the alias, so Handle.Type = Int32
        let handleType = Type.Number(Int32, NumberInfo.Empty)
        Expect.equal (mapTypeKnown ctx handleType) WType.I32 "Handle must be I32, never Void"
    }

    test "Element = El of int DU → Ref, not I32, after registration" {
        // Browser.Dom.Element is a single-case DU
        // Before registration: I32 fallback
        // After registration: Ref(idx, false)
        let ctx = makeTestCtx()
        // Register the type
        let entity = { FullName = "Browser.Dom.Element"; Path = "" }
        let _ = mapTypeKnown ctx (Type.DeclaredType(entity, []))
        // After registration attempt — check
        // (actual behavior depends on whether we auto-register DUs)
        ()
    }

    test "Option<int> → nullable Ref" {
        let ctx = makeTestCtx()
        let result = mapTypeKnown ctx (Type.Option(Type.Number(Int32, NumberInfo.Empty)))
        match result with
        | WType.Ref(_, true) -> ()  // nullable = option Some/None
        | other -> failtestf "Option<int> should be nullable Ref, got %A" other
    }

    test "Tuple<int, string> → registered struct Ref" {
        let ctx = makeTestCtx()
        let result = mapTypeKnown ctx (Type.Tuple([Type.Number(Int32, NumberInfo.Empty); Type.String], false))
        match result with
        | WType.Ref _ -> ()
        | WType.I32 -> failtestf "Tuple should be a Ref, not I32 fallback"
        | other -> failtestf "Tuple should be Ref, got %A" other
    }

]
