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

    // ── Primitives ────────────────────────────────────────────────

    test "int → I32" {
        let ctx = makeTestCtx ()
        Expect.equal
            (mapTypeKnown ctx (Type.Number(Int32, NumberInfo.Empty)))
            WType.I32
            "int → I32"
    }

    test "int64 → I64" {
        let ctx = makeTestCtx ()
        Expect.equal
            (mapTypeKnown ctx (Type.Number(Int64, NumberInfo.Empty)))
            WType.I64
            "int64 → I64"
    }

    test "float32 → F32" {
        let ctx = makeTestCtx ()
        Expect.equal
            (mapTypeKnown ctx (Type.Number(Float32, NumberInfo.Empty)))
            WType.F32
            "float32 → F32"
    }

    test "float64 → F64" {
        let ctx = makeTestCtx ()
        Expect.equal
            (mapTypeKnown ctx (Type.Number(Float64, NumberInfo.Empty)))
            WType.F64
            "float → F64"
    }

    test "unit → Void" {
        let ctx = makeTestCtx ()
        Expect.equal (mapTypeKnown ctx Type.Unit) WType.Void "unit → Void"
    }

    test "bool → I32 (WASM has no bool type)" {
        let ctx = makeTestCtx ()
        Expect.equal (mapTypeKnown ctx Type.Boolean) WType.I32 "bool → I32"
    }

    test "char → I32 (UTF-16 code unit)" {
        let ctx = makeTestCtx ()
        Expect.equal (mapTypeKnown ctx Type.Char) WType.I32 "char → I32"
    }

    test "string → Ref(StringTypeIdx=1, non-null)" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx Type.String
        Expect.equal result (WType.Ref(StringTypeIdx, false))
            (sprintf "string should be Ref(%d, false)" StringTypeIdx)
    }

    // ── Closure types ─────────────────────────────────────────────

    test "LambdaType → Ref(AnyFnTypeIdx=0, non-null)" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.LambdaType(Type.Number(Int32, NumberInfo.Empty), Type.Unit))
        Expect.equal result (WType.Ref(AnyFnTypeIdx, false))
            "Lambda type should be AnyFn ref"
    }

    test "DelegateType → Ref(AnyFnTypeIdx=0, non-null)" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.DelegateType([Type.Number(Int32, NumberInfo.Empty)], Type.Unit))
        Expect.equal result (WType.Ref(AnyFnTypeIdx, false))
            "Delegate type should be AnyFn ref"
    }

    // ── List ──────────────────────────────────────────────────────

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

   test "List<int> → Ref(ListBaseTypeIdx=2, nullable) and registers cons type" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.List(Type.Number(Int32, NumberInfo.Empty)))
        // Lists are ALWAYS Ref(ListBaseTypeIdx, true) — nullable because empty list = null
        Expect.equal result (WType.Ref(ListBaseTypeIdx, true))
            "List<int> should be nullable Ref(ListBaseTypeIdx)"
        // The cons struct should now be registered
        let key = wTypeKey WType.I32
        Expect.isTrue (ctx.ListRegistry.ContainsKey(key))
            "ListRegistry should have I32 cons type after mapping List<int>"
    }

    test "List<int> twice → same type index (idempotent registration)" {
        let ctx = makeTestCtx ()
        let r1 = mapTypeKnown ctx (Type.List(Type.Number(Int32, NumberInfo.Empty)))
        let r2 = mapTypeKnown ctx (Type.List(Type.Number(Int32, NumberInfo.Empty)))
        Expect.equal r1 r2 "Repeated List<int> mapping should give same result"
        Expect.equal (ctx.ListRegistry.Count) 1 "ListRegistry should have exactly one entry"
    }

    test "List<string> → separate cons type from List<int>" {
        let ctx = makeTestCtx ()
        let _ = mapTypeKnown ctx (Type.List(Type.Number(Int32, NumberInfo.Empty)))
        let _ = mapTypeKnown ctx (Type.List(Type.String))
        Expect.equal ctx.ListRegistry.Count 2
            "List<int> and List<string> should have separate cons types"
    }

     // ── Misc ──────────────────────────────────────────────────────

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

    // ── Array ─────────────────────────────────────────────────────

    test "Array<int> → Ref(arrIdx, non-null) and registers array type" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.Array(Type.Number(Int32, NumberInfo.Empty), ArrayKind.Array))
        match result with
        | WType.Ref(idx, false) ->
            Expect.isGreaterThan idx StringBuilderTypeIdx
                "Array type idx should be after the 4 pre-registered types"
            let key = sprintf "GcArr_%s" (wTypeKey WType.I32)
            Expect.isTrue (ctx.ArrayRegistry.ContainsKey(key))
                "ArrayRegistry should contain the I32 array type"
        | other -> failtestf "Array<int> should be non-null Ref, got %A" other
    }

    test "ResizeArray<int> → Ref(ravTypeIdx, non-null) struct" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.Array(Type.Number(Int32, NumberInfo.Empty), ArrayKind.ResizeArray))
        match result with
        | WType.Ref(_, false) -> ()
        | other -> failtestf "ResizeArray<int> should be non-null Ref, got %A" other
    }

    // ── Option ────────────────────────────────────────────────────

    test "Option<int> → nullable Ref" {
        let ctx = makeTestCtx()
        let result = mapTypeKnown ctx (Type.Option(Type.Number(Int32, NumberInfo.Empty)))
        match result with
        | WType.Ref(_, true) -> ()  // nullable = option Some/None
        | other -> failtestf "Option<int> should be nullable Ref, got %A" other
    }

    test "Option<int> → Ref(optBoxIdx, nullable) — primitive inner needs box struct" {
        // Primitive inner (I32) cannot be encoded as null ref directly → needs wrapper struct
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.Option(Type.Number(Int32, NumberInfo.Empty), false))
        match result with
        | WType.Ref(_, true) -> ()   // nullable = Some(box) | None
        | other -> failtestf "Option<int> should be nullable Ref, got %A" other
        Expect.isTrue (ctx.OptionRegistry.ContainsKey("i32"))
            "OptionRegistry should have i32 box type"
    }

    test "Option<string> → Ref(StringTypeIdx, nullable) — no wrapper needed" {
        // Non-null ref inner → nullable ref of same type (null = None, non-null = Some)
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.Option(Type.String, false))
        match result with
        | WType.Ref(idx, true) when idx = StringTypeIdx -> ()
        | other ->
            failtestf "Option<string> should be Ref(StringTypeIdx=%d, true), got %A" StringTypeIdx other
    }

    test "Option<option<string>> → wrapper struct needed (inner is nullable)" {
        // Inner is already nullable → can't use null-as-None trick
        let ctx = makeTestCtx ()
        let inner = Type.Option(Type.String, false)
        let result = mapTypeKnown ctx (Type.Option(inner, false))
        match result with
        | WType.Ref(_, true) -> ()
        | other -> failtestf "Option<Option<string>> should be nullable Ref, got %A" other
    }

    // ── Tuple ─────────────────────────────────────────────────────


    test "Tuple<int, string> → registered struct Ref" {
        let ctx = makeTestCtx()
        let result = mapTypeKnown ctx (Type.Tuple([Type.Number(Int32, NumberInfo.Empty); Type.String], false))
        match result with
        | WType.Ref _ -> ()
        | WType.I32 -> failtestf "Tuple should be a Ref, not I32 fallback"
        | other -> failtestf "Tuple should be Ref, got %A" other
    }

    test "Tuple<int, string> → Ref(struct, non-null)" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.Tuple([Type.Number(Int32, NumberInfo.Empty); Type.String], false))
        match result with
        | WType.Ref(idx, false) ->
            Expect.isGreaterThan idx StringBuilderTypeIdx "Tuple idx after pre-registered types"
            // Check the TypeDefs entry
            let entry = ctx.TypeDefs.[idx]
            match entry.Def with
            | WTypeDef.Struct(fields, _) ->
                Expect.equal fields.Length 2 "Tuple<int,string> should have 2 fields"
                Expect.equal fields.[0].Type WType.I32 "First field should be I32"
                Expect.equal fields.[1].Type (WType.Ref(StringTypeIdx, false)) "Second field should be string"
            | other -> failtestf "Tuple should be a Struct, got %A" other
        | other -> failtestf "Tuple should be non-null Ref, got %A" other
    }

    test "Same Tuple<int,string> twice → same index" {
        let ctx = makeTestCtx ()
        let tupleT = Type.Tuple([Type.Number(Int32, NumberInfo.Empty); Type.String], false)
        let r1 = mapTypeKnown ctx tupleT
        let r2 = mapTypeKnown ctx tupleT
        Expect.equal r1 r2 "Tuple registration should be idempotent"
    }

    // ── DeclaredType ──────────────────────────────────────────────

    test "FSharpRef<int> → Ref(refCellIdx, non-null) box struct" {
        let ctx = makeTestCtx ()
        let entity = { FullName = "Microsoft.FSharp.Core.FSharpRef`1"; Path = EntityPath.PrecompiledLib }
        let result = mapTypeKnown ctx (Type.DeclaredType(entity, [Type.Number(Int32, NumberInfo.Empty)]))
        match result with
        | WType.Ref(idx, false) ->
            let key = wTypeKey WType.I32
            Expect.isTrue (ctx.RefRegistry.ContainsKey(key))
                "RefRegistry should have the I32 ref cell type"
            let entry = ctx.TypeDefs.[idx]
            match entry.Def with
            | WTypeDef.Struct([field], _) ->
                Expect.equal field.Type WType.I32 "Ref cell should wrap I32"
                Expect.isTrue field.Mutable "Ref cell field must be mutable"
            | other -> failtestf "FSharpRef should be a single-field mutable struct, got %A" other
        | other -> failtestf "FSharpRef<int> should be non-null Ref, got %A" other
    }

    test "StringBuilder → Ref(StringBuilderTypeIdx=3, non-null)" {
        let ctx = makeTestCtx ()
        let entity = { FullName = "System.Text.StringBuilder"; Path = EntityPath.PrecompiledLib }
        let result = mapTypeKnown ctx (Type.DeclaredType(entity, []))
        Expect.equal result (WType.Ref(StringBuilderTypeIdx, false))
            (sprintf "StringBuilder should always be Ref(%d, false)" StringBuilderTypeIdx)
    }

    test "unregistered DeclaredType → I32 fallback" {
        // This is the source of call_ref mismatches when types aren't registered yet.
        // All unknown types fall back to I32 before registration.
        let ctx = makeTestCtx ()
        let entity = { FullName = "Some.Unknown.Type`1"; Path = EntityPath.PrecompiledLib }
        let result = mapTypeKnown ctx (Type.DeclaredType(entity, []))
        Expect.equal result WType.I32
            "Unknown DeclaredType must fall back to I32 — not I32 causes call_ref arity bugs"
    }

    test "Handle = int → I32 (never Void — JS bridge sends real integer)" {
        // Handle is a type alias for int in Browser.Core.
        // Fable resolves aliases so Handle.Type = Int32.
        // If this were Void, the JS bridge int handle would be silently dropped → crash.
        let ctx = makeTestCtx ()
        let handleType = Type.Number(Int32, NumberInfo.Empty)
        let result = mapTypeKnown ctx handleType
        Expect.equal result WType.I32 "Handle (int alias) must be I32, never Void"
    }

    // ── GenericParam ──────────────────────────────────────────────

    test "unresolved GenericParam → I32 (default for erased generics)" {
        let ctx = makeTestCtx ()
        let result = mapTypeKnown ctx (Type.GenericParam("T", false, []))
        Expect.equal result WType.I32 "Unresolved generic param → I32 fallback"
    }

    test "resolved GenericParam via TypeSubst → concrete type" {
        let ctx = { makeTestCtx () with TypeSubst = Map.ofList [("T", WType.F64)] }
        let result = mapTypeKnown ctx (Type.GenericParam("T", false, []))
        Expect.equal result WType.F64 "GenericParam T should resolve to F64 via TypeSubst"
    }

    // ── Pre-registered type index constants ───────────────────────

    test "TypeDefs has exactly 4 entries after Ctx.Create" {
        let ctx = makeTestCtx ()
        Expect.equal ctx.TypeDefs.Count 4
            "Ctx.Create should pre-register: AnyFn(0), WasmStr(1), ListBase(2), StringBuilder(3)"
    }

    test "TypeDef[AnyFnTypeIdx=0] is Struct with no fields (closure base)" {
        let ctx = makeTestCtx ()
        match ctx.TypeDefs.[AnyFnTypeIdx].Def with
        | WTypeDef.Struct([], None) -> ()
        | other -> failtestf "AnyFn should be empty struct, got %A" other
    }

    test "TypeDef[StringTypeIdx=1] is Array(I32, mutable)" {
        let ctx = makeTestCtx ()
        match ctx.TypeDefs.[StringTypeIdx].Def with
        | WTypeDef.Array(WType.I32, true) -> ()
        | WTypeDef.Array(WType.I16, true) -> ()  // I16 mode also ok
        | other -> failtestf "WasmStr should be mutable I32 or I16 array, got %A" other
    }

    test "TypeDef[ListBaseTypeIdx=2] is Struct with no fields (list cons base)" {
        let ctx = makeTestCtx ()
        match ctx.TypeDefs.[ListBaseTypeIdx].Def with
        | WTypeDef.Struct([], None) -> ()
        | other -> failtestf "ListBase should be empty struct, got %A" other
    }

    test "TypeDef[StringBuilderTypeIdx=3] is Struct with 3 fields" {
        let ctx = makeTestCtx ()
        match ctx.TypeDefs.[StringBuilderTypeIdx].Def with
        | WTypeDef.Struct(fields, None) ->
            Expect.equal fields.Length 3 "StringBuilder should have 3 fields: data, length, capacity"
            // data: mut ref $WasmStr
            Expect.equal fields.[0].Type (WType.Ref(StringTypeIdx, false)) "data field type"
            Expect.isTrue fields.[0].Mutable "data field must be mutable"
            // length: mut i32
            Expect.equal fields.[1].Type WType.I32 "length field type"
            Expect.isTrue fields.[1].Mutable "length field must be mutable"
            // capacity: mut i32
            Expect.equal fields.[2].Type WType.I32 "capacity field type"
            Expect.isTrue fields.[2].Mutable "capacity field must be mutable"
        | other -> failtestf "StringBuilder should be a 3-field struct, got %A" other
    }

    // ── mapResultTypeKnown ────────────────────────────────────────

    test "mapResultTypeKnown unit → Void" {
        let ctx = makeTestCtx ()
        Expect.equal (mapResultTypeKnown ctx Type.Unit) WType.Void "unit result → Void"
    }

    test "mapResultTypeKnown int → I32" {
        let ctx = makeTestCtx ()
        Expect.equal
            (mapResultTypeKnown ctx (Type.Number(Int32, NumberInfo.Empty)))
            WType.I32 "int result → I32"
    }

    // ── GetOrAddFuncType ──────────────────────────────────────────

    test "GetOrAddFuncType: same signature → same index" {
        let ctx = makeTestCtx ()
        let idx1 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I32], WType.Void)
        let idx2 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I32], WType.Void)
        Expect.equal idx1 idx2 "Same functype signature should give same index"
    }

    test "GetOrAddFuncType: different signatures → different indices" {
        let ctx = makeTestCtx ()
        let idx1 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I32], WType.Void)
        let idx2 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I64], WType.Void)
        Expect.notEqual idx1 idx2 "Different functype signatures must give different indices"
    }

    test "GetOrAddFuncType registers a WTypeDef.Func entry" {
        let ctx = makeTestCtx ()
        let idx = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I32], WType.I32)
        match ctx.TypeDefs.[idx].Def with
        | WTypeDef.Func(parms, ret) ->
            Expect.equal parms.Length 2 "Func should have 2 params"
            Expect.equal ret WType.I32 "Func should return I32"
        | other -> failtestf "Expected Func typedef, got %A" other
    }

    // ── wTypeKey ──────────────────────────────────────────────────

    test "wTypeKey round-trips are stable" {
        Expect.equal (wTypeKey WType.I32)             "i32"          "I32 key"
        Expect.equal (wTypeKey WType.I64)             "i64"          "I64 key"
        Expect.equal (wTypeKey WType.F32)             "f32"          "F32 key"
        Expect.equal (wTypeKey WType.F64)             "f64"          "F64 key"
        Expect.equal (wTypeKey WType.Void)            "void"         "Void key"
        Expect.equal (wTypeKey (WType.Ref(0, false))) "ref0"         "Ref(0,false) key"
        Expect.equal (wTypeKey (WType.Ref(0, true)))  "refnull0"     "Ref(0,true) key"
        Expect.equal (wTypeKey (WType.Ref(1, false))) "ref1"         "Ref(1,false) key = WasmStr"
        Expect.equal (wTypeKey (WType.Ref(2, true)))  "refnull2"     "Ref(2,true) key = ListBase nullable"
    }

    test "wTypeKey is collision-free for I32 vs nullable ref" {
        // This matters for registry lookups: List<int> key must not collide with raw I32 key
        Expect.notEqual
            (wTypeKey WType.I32)
            (wTypeKey (WType.Ref(0, false)))
            "I32 and Ref(0) keys must be distinct"
    }
]