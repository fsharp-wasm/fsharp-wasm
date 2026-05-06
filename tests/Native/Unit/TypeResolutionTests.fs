// ════════════════════════════════════════════════════════════════════════════════
// tests/Unit/TypeResolutionTests.fs
// mapTypeKnown / mapResultTypeKnown / GetOrAddFuncType — every edge case
// that produces wrong call_ref arities or type fallbacks.
// ════════════════════════════════════════════════════════════════════════════════
module Tests.Unit.TypeResolutionTests

open Expecto
open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST

open WasmGc.Runtime.Types
open Tests.WasmTestHelper

[<Tests>]
let typeResolutionTests = testList "mapTypeKnown" [

    // ── Primitives ─────────────────────────────────────────────────────────────

    testList "Primitive types" [

        test "int → I32" {
            let ctx = makeTestCtx()
            Expect.equal
                (mapTypeKnown ctx (Type.Number(NumberKind.Int32, NumberInfo.Empty)))
                WType.I32 "int → I32"
        }

        test "int8 → I32 (byte-width numbers all map to i32)" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.Int8, NumberInfo.Empty))) WType.I32 "int8"
        }

        test "uint8 → I32" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.UInt8, NumberInfo.Empty))) WType.I32 "uint8"
        }

        test "int16 → I32" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.Int16, NumberInfo.Empty))) WType.I32 "int16"
        }

        test "int32 → I32" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.Int32, NumberInfo.Empty))) WType.I32 "int32"
        }

        test "uint32 → I32" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.UInt32, NumberInfo.Empty))) WType.I32 "uint32"
        }

        test "int64 → I64" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.Int64, NumberInfo.Empty))) WType.I64 "int64"
        }

        test "uint64 → I64" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.UInt64, NumberInfo.Empty))) WType.I64 "uint64"
        }

        test "float32 → F32" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.Float32, NumberInfo.Empty))) WType.F32 "float32"
        }

        test "float64 → F64" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx (Type.Number(NumberKind.Float64, NumberInfo.Empty))) WType.F64 "float64"
        }

        test "unit → Void" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx Type.Unit) WType.Void "unit → Void"
        }

        test "bool → I32 (WASM has no boolean type)" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx Type.Boolean) WType.I32 "bool → I32"
        }

        test "char → I32 (UTF-16 code unit)" {
            let ctx = makeTestCtx()
            Expect.equal (mapTypeKnown ctx Type.Char) WType.I32 "char → I32"
        }

        test "string → Ref(StringTypeIdx=1, non-null)" {
            let ctx = makeTestCtx()
            Expect.equal
                (mapTypeKnown ctx Type.String)
                (WType.Ref(StringTypeIdx, false))
                (sprintf "string should be Ref(%d, false)" StringTypeIdx)
        }
    ]

    // ── Closure / delegate types ────────────────────────────────────────────────

    testList "Closure types" [

        test "LambdaType → Ref(AnyFnTypeIdx=0, non-null)" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.LambdaType(Type.Number(NumberKind.Int32, NumberInfo.Empty), Type.Unit))
            Expect.equal result (WType.Ref(AnyFnTypeIdx, false)) "Lambda type should be → AnyFn ref"
        }

        test "DelegateType → Ref(AnyFnTypeIdx=0, non-null)" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.DelegateType([Type.Number(NumberKind.Int32, NumberInfo.Empty)], Type.Unit))
            Expect.equal result (WType.Ref(AnyFnTypeIdx, false)) "Delegate type should be → AnyFn ref"
        }

        test "LambdaType(float, bool) → still AnyFn (all closures share the base)" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.LambdaType(Type.Number(NumberKind.Float64, NumberInfo.Empty), Type.Boolean))
            Expect.equal result (WType.Ref(AnyFnTypeIdx, false)) "f64->bool closure → AnyFn"
        }
    ]

    // ── List types ─────────────────────────────────────────────────────────────

    testList "List<T>" [

        test "List<int> registers in ListRegistry and returns nullable Ref" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.List(Type.Number(NumberKind.Int32, NumberInfo.Empty)))
            match result with
            | WType.Ref(_, true)           // nullable ref (list can be null = empty)
            | WType.Ref(_, false) -> ()  // non-null also acceptable
            | other -> failtestf "List<int> should be a Ref, got %A" other

            // And it should be in ListRegistry
            let key = wTypeKey WType.I32
            Expect.isTrue (ctx.ListRegistry.ContainsKey(key)) "ListRegistry should contain I32 entry"
        }

        test "List<int> → Ref(ListBaseTypeIdx=2, nullable) and registers cons type" {
            let ctx = makeTestCtx ()
            let result = mapTypeKnown ctx (Type.List(Type.Number(NumberKind.Int32, NumberInfo.Empty)))
            // Lists are ALWAYS Ref(ListBaseTypeIdx, true) — nullable because empty list = null
            Expect.equal result (WType.Ref(ListBaseTypeIdx, true))
                "List<int> should be nullable Ref(ListBaseTypeIdx)"
            // The cons struct should now be registered
            let key = wTypeKey WType.I32
            Expect.isTrue (ctx.ListRegistry.ContainsKey(key))
                "ListRegistry should have I32 cons type after mapping List<int>"
        }

        test "List<int> twice → same type index (idempotent registration)" {
            let ctx = makeTestCtx()
            let r1 = mapTypeKnown ctx (Type.List(Type.Number(NumberKind.Int32, NumberInfo.Empty)))
            let r2 = mapTypeKnown ctx (Type.List(Type.Number(NumberKind.Int32, NumberInfo.Empty)))
            Expect.equal r1 r2 "repeated List<int> mapping must be stable;  should give same result"
            Expect.equal ctx.ListRegistry.Count 1 "ListRegistry should have exactly one entry"
        }

        test "List<int> and List<string> get separate cons types" {
            let ctx = makeTestCtx()
            let _ = mapTypeKnown ctx (Type.List(Type.Number(NumberKind.Int32, NumberInfo.Empty)))
            let _ = mapTypeKnown ctx (Type.List(Type.String))
            Expect.equal ctx.ListRegistry.Count 2 "separate cons types for int and string"
        }

        test "List<float64> → Ref registered under f64 key" {
            let ctx = makeTestCtx()
            let _ = mapTypeKnown ctx (Type.List(Type.Number(NumberKind.Float64, NumberInfo.Empty)))
            Expect.isTrue (ctx.ListRegistry.ContainsKey(wTypeKey WType.F64)) "f64 list registered"
        }
    ]

     // ── Misc ──────────────────────────────────────────────────────

    testList "Misc" [

        test "unregistered DeclaredType → I32 fallback with warning" {
            // This is the source of call_ref mismatches when types aren't registered yet
            let ctx = makeTestCtx()
            let unknownEntity = { FullName = "Some.Unknown.Type"; Path = SourcePath "" }
            let result = mapTypeKnown ctx (Type.DeclaredType(unknownEntity, []))
            // Should fall back to I32 (or produce a specific sentinel value)
            Expect.equal result WType.I32 "unknown DeclaredType should fall back to I32"
        }


        test "Handle = int → I32 (not Void)" {
            // Handle is `type Handle = int` — if this resolves to Void, JS bridge breaks
            let ctx = makeTestCtx()
            // Handle maps via type alias — should still be I32
            // In practice: Fable resolves the alias, so Handle.Type = Int32
            let handleType = Type.Number(NumberKind.Int32, NumberInfo.Empty)
            Expect.equal (mapTypeKnown ctx handleType) WType.I32 "Handle must be I32, never Void"
        }

        test "Unknown DeclaredType → I32 fallback (no auto-registration)" {
            // mapTypeKnown is a pure lookup — it does NOT auto-register types.
            // TransformConstruct populates TypeRegistry during ClassDeclaration processing.
            let ctx    = makeTestCtx()
            let entity = { FullName = "Browser.Dom.Element"; Path = SourcePath "" }
            let result = mapTypeKnown ctx (Type.DeclaredType(entity, []))
            Expect.equal result WType.I32
                "Unknown DeclaredType with no TypeRegistry entry → I32 fallback"
        }

        test "DeclaredType → Ref(idx, false) after TypeRegistry injection" {
            // Simulate what TransformConstruct does: register then look up.
            let ctx    = makeTestCtx()
            let entity = { FullName = "Browser.Dom.Element"; Path = SourcePath "" }
            let fakeIdx = 99
            let ctx2   = { ctx with TypeRegistry = Map.add entity.FullName fakeIdx ctx.TypeRegistry }
            let result = mapTypeKnown ctx2 (Type.DeclaredType(entity, []))
            Expect.equal result (WType.Ref(fakeIdx, false))
                "Registered DeclaredType must resolve to Ref(idx, false)"
        }

        test "Generic DU with args → GenericDuRegistry → Ref" {
            // Generic DU instances (Result<int,string>, Choice<T,U>, etc.) are keyed
            // by "FullName<wTypeKey1,wTypeKey2>" in GenericDuRegistry.
            let ctx    = makeTestCtx()
            let entity = { FullName = "Microsoft.FSharp.Core.FSharpResult`2"; Path = SourcePath "" }
            // Pre-compute the key that mapTypeKnown will form from (entity, [Int32; String])
            let argKeys = [Type.Number(Int32, NumberInfo.Empty); Type.String]
                          |> List.map (mapTypeKnown ctx >> wTypeKey)
                          |> String.concat ","
            let instKey = $"{entity.FullName}<{argKeys}>"
            let fakeIdx = 77
            ctx.GenericDuRegistry.[instKey] <- fakeIdx
            let result  = mapTypeKnown ctx (Type.DeclaredType(entity, [Type.Number(Int32, NumberInfo.Empty); Type.String]))
            Expect.equal result (WType.Ref(fakeIdx, false))
                "Generic DU must resolve via GenericDuRegistry before I32 fallback"
        }
    ]

    // ── Array types ─────────────────────────────────────────────────────────────

    testList "Array<T>" [

        test "Array<int> → Ref(arrIdx, non-null) and registers array type" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.Array(Type.Number(NumberKind.Int32, NumberInfo.Empty), ArrayKind.ResizeArray))
            match result with
            | WType.Ref(idx, false) ->
            Expect.isGreaterThan idx StringBuilderTypeIdx
                "Array type idx should be after the 4 pre-registered types"
            let key = sprintf "GcArr_%s" (wTypeKey WType.I32)
            Expect.isTrue (ctx.ArrayRegistry.ContainsKey(key))
                "ArrayRegistry should contain the I32 array type"
            | other -> failtestf "Array<int> should be non-null Ref, got %A" other
        }

        test "Array<int> registers in ArrayRegistry" {
            let ctx = makeTestCtx()
            let _ = mapTypeKnown ctx (Type.Array(Type.Number(NumberKind.Int32, NumberInfo.Empty), ArrayKind.ResizeArray))
            let key = sprintf "GcArr_%s" (wTypeKey WType.I32)
            Expect.isTrue (ctx.ArrayRegistry.ContainsKey(key)) "ArrayRegistry should contain I32 array"
        }

        test "ResizeArray<int> → Ref(ravTypeIdx, non-null) struct" {
            let ctx = makeTestCtx ()
            let result = mapTypeKnown ctx (Type.Array(Type.Number(NumberKind.Int32, NumberInfo.Empty), ArrayKind.ResizeArray))
            match result with
            | WType.Ref(_, false) -> ()
            | other -> failtestf "ResizeArray<int> should be non-null Ref, got %A" other
        }

        test "Array<int> twice → same index" {
            let ctx = makeTestCtx()
            let r1 = mapTypeKnown ctx (Type.Array(Type.Number(NumberKind.Int32, NumberInfo.Empty), ArrayKind.ResizeArray))
            let r2 = mapTypeKnown ctx (Type.Array(Type.Number(NumberKind.Int32, NumberInfo.Empty), ArrayKind.ResizeArray))
            Expect.equal r1 r2 "array type registration must be idempotent"
        }
    ]

    // ── Option types ────────────────────────────────────────────────────────────

    testList "Option<T>" [

        test "Option<int> → nullable Ref" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.Option(Type.Number(NumberKind.Int32, NumberInfo.Empty), false))
            match result with
            | WType.Ref(_, true) -> ()  // nullable = option Some/None
            | other -> failtestf "Option<int> should be nullable Ref, got %A" other
        }

        test "Option<int> → Ref(optBoxIdx, nullable) — primitive inner needs box struct" {
            // Primitive inner (I32) cannot be encoded as null ref directly → needs wrapper struct
            let ctx = makeTestCtx ()
            let result = mapTypeKnown ctx (Type.Option(Type.Number(NumberKind.Int32, NumberInfo.Empty), false))
            match result with
            | WType.Ref(_, true) -> ()   // nullable = Some(box) | None
            | other -> failtestf "Option<int> should be nullable Ref, got %A" other
            Expect.isTrue (ctx.OptionRegistry.ContainsKey("i32")) "OptionRegistry should have i32 box type"
        }

        test "Option<string> → Ref(StringTypeIdx, nullable) — no wrapper needed —  direct encoding" {
            // Non-null ref inner → null = None, non-null = Some(value)
        // Non-null ref inner → nullable ref of same type (null = None, non-null = Some)
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.Option(Type.String, false))
            match result with
            | WType.Ref(idx, true) when idx = StringTypeIdx -> ()
            | other ->
                failtestf "Option<string> should be Ref(StringTypeIdx=%d, true), got %A" StringTypeIdx other
        }

        test "Option<int> → nullable wrapper struct (primitive needs box)" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.Option(Type.Number(NumberKind.Int32, NumberInfo.Empty), false))
            match result with
            | WType.Ref(_, true) -> ()   // nullable = Some(box) | None
            | other -> failtestf "Option<int> should be nullable Ref, got %A" other
            Expect.isTrue (ctx.OptionRegistry.ContainsKey(wTypeKey WType.I32)) "OptionRegistry has i32 box"
            Expect.isTrue (ctx.OptionRegistry.ContainsKey("i32")) "OptionRegistry should have i32 box type"
        }

        test "Option<int> twice → same index" {
            let ctx = makeTestCtx()
            let r1 = mapTypeKnown ctx (Type.Option(Type.Number(NumberKind.Int32, NumberInfo.Empty), false))
            let r2 = mapTypeKnown ctx (Type.Option(Type.Number(NumberKind.Int32, NumberInfo.Empty), false))
            Expect.equal r1 r2 "Option<int> registration must be idempotent"
        }

        test "Option<option<string>> → wrapper struct needed (inner is already nullable)" {
            // Inner is already nullable → can't use null-as-None trick
            let ctx = makeTestCtx()
            let inner = Type.Option(Type.String, false)
            let result = mapTypeKnown ctx (Type.Option(inner, false))
            match result with
            | WType.Ref(_, true) -> ()
            | other -> failtestf "Option<Option<string>> should be nullable Ref, got %A" other
        }
    ]

    // ── Tuple types ─────────────────────────────────────────────────────────────

    testList "Tuple<...>" [

        test "Tuple<int, string> → registered non-null struct Ref" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.Tuple([Type.Number(NumberKind.Int32, NumberInfo.Empty); Type.String], false))
            match result with
            | WType.Ref(_, false) -> ()
            | WType.I32           -> failtest "Tuple should be a Ref, not fall back to I32"
            | other               -> failtestf "Tuple should be Ref, got %A" other
        }

        test "Tuple<int, string>  → Ref(struct, non-null) struct has 2 fields with correct types" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.Tuple([Type.Number(NumberKind.Int32, NumberInfo.Empty); Type.String], false))
            match result with
            | WType.Ref(idx, false) ->
                Expect.isGreaterThan idx StringBuilderTypeIdx "tuple idx must be after pre-registered types"
                match ctx.TypeDefs.[idx].Def with
                | WTypeDef.Struct(fields, _) ->
                    Expect.equal fields.Length 2 "Tuple<int,string> should have 2 fields"
                    Expect.equal fields.[0].Type WType.I32 "First field should be I32"
                    Expect.equal fields.[1].Type (WType.Ref(StringTypeIdx, false)) "Second field should be string"
                | other -> failtestf "Tuple should be a Struct, got %A" other
            | other -> failtestf "Tuple should be non-null Ref, got %A" other
        }

        test "Same Tuple<int, string> twice → same index (idempotent)" {
            let ctx = makeTestCtx()
            let tupleT = Type.Tuple([Type.Number(NumberKind.Int32, NumberInfo.Empty); Type.String], false)
            let r1 = mapTypeKnown ctx tupleT
            let r2 = mapTypeKnown ctx tupleT
            Expect.equal r1 r2 "tuple registration must be idempotent"
        }

        test "Tuple<int, float> ≠ Tuple<float, int> (order matters)" {
            let ctx = makeTestCtx()
            let t1 = mapTypeKnown ctx (Type.Tuple([Type.Number(NumberKind.Int32, NumberInfo.Empty); Type.Number(NumberKind.Float64, NumberInfo.Empty)], false))
            let t2 = mapTypeKnown ctx (Type.Tuple([Type.Number(NumberKind.Float64, NumberInfo.Empty); Type.Number(NumberKind.Int32, NumberInfo.Empty)], false))
            Expect.notEqual t1 t2 "swapped element types must produce different type indices"
        }
    ]

    // ── DeclaredType / GenericParam ─────────────────────────────────────────────

    testList "DeclaredType and GenericParam" [

        test "FSharpRef<int> → Ref(refCellIdx, non-null) box struct" {
            let ctx = makeTestCtx ()
            let entity = { FullName = "Microsoft.FSharp.Core.FSharpRef`1"; Path = SourcePath "" }
            let result = mapTypeKnown ctx (Type.DeclaredType(entity, [Type.Number(NumberKind.Int32, NumberInfo.Empty)]))
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
            let entity =  {
                FullName = "System.Text.StringBuilder"
                Path = SourcePath ""
            }
            let result = mapTypeKnown ctx (Type.DeclaredType(entity, []))
            Expect.equal result (WType.Ref(StringBuilderTypeIdx, false))
                (sprintf "StringBuilder should always be Ref(%d, false)" StringBuilderTypeIdx)
        }

        test "unregistered DeclaredType → I32 fallback" {
            // This is the source of call_ref mismatches when types aren't registered yet.
            // All unknown types fall back to I32 before registration.
            let ctx = makeTestCtx ()
            let entity = { FullName = "Some.Unknown.Type`1"; Path = SourcePath "" }
            let result = mapTypeKnown ctx (Type.DeclaredType(entity, []))
            Expect.equal result WType.I32
                "Unknown DeclaredType must fall back to I32 — not I32 causes call_ref arity bugs"
        }

        test "Handle = int → I32 (never Void — JS bridge sends real integer)" {
            // Handle is a type alias for int in Browser.Core.
            // Fable resolves aliases so Handle.Type = Int32.
            // If this were Void, the JS bridge int handle would be silently dropped → crash.
            let ctx = makeTestCtx ()
            let handleType = Type.Number(NumberKind.Int32, NumberInfo.Empty)
            let result = mapTypeKnown ctx handleType
            Expect.equal result WType.I32 "Handle (int alias) must be I32, never Void"
        }

        // ── GenericParam ──────────────────────────────────────────────

        test "unresolved GenericParam → I32 (default for erased generics)" {
            let ctx = makeTestCtx()
            let result = mapTypeKnown ctx (Type.GenericParam("T", false, []))
            Expect.equal result WType.I32 "Unresolved generic param → I32 fallback"
        }

        test "resolved GenericParam via TypeSubst → concrete type" {
            let ctx = { makeTestCtx() with TypeSubst = Map.ofList [("T", WType.F64)] }
            let result = mapTypeKnown ctx (Type.GenericParam("T", false, []))
            Expect.equal result WType.F64 "GenericParam T should resolve to → F64 via TypeSubst"
        }

        test "GenericParam not in TypeSubst → I32 fallback (not a crash)" {
            let ctx = { makeTestCtx() with TypeSubst = Map.ofList [("U", WType.I32)] }
            let result = mapTypeKnown ctx (Type.GenericParam("T", false, []))
            Expect.equal result WType.I32 "unknown generic param → I32 fallback"
        }
    ]

    // ── mapResultTypeKnown ──────────────────────────────────────────────────────

    testList "mapResultTypeKnown" [

        test "unit result → Void" {
            let ctx = makeTestCtx()
            Expect.equal (mapResultTypeKnown ctx Type.Unit) WType.Void "unit result → Void"
        }

        test "mapResultTypeKnown int result → I32" {
            let ctx = makeTestCtx()
            Expect.equal
                (mapResultTypeKnown ctx (Type.Number(NumberKind.Int32, NumberInfo.Empty)))
                WType.I32 "int result → I32"
        }

        test "string result → Ref(StringTypeIdx, false)" {
            let ctx = makeTestCtx()
            Expect.equal
                (mapResultTypeKnown ctx Type.String)
                (WType.Ref(StringTypeIdx, false)) "string result → string ref"
        }

        test "bool result → I32 (never Void)" {
            let ctx = makeTestCtx()
            let result = mapResultTypeKnown ctx Type.Boolean
            Expect.notEqual result WType.Void "bool result must not be Void"
            Expect.equal result WType.I32 "bool result → I32"
        }
    ]

    // ── Pre-registered type indices ─────────────────────────────────────────────

    testList "Pre-registered type constants" [

        test "TypeDefs has exactly 4 entries after Ctx.Create" {
            let ctx = makeTestCtx()
            Expect.equal ctx.TypeDefs.Count 4
                "Ctx.Create should pre-register: AnyFn(0), WasmStr(1), ListBase(2), StringBuilder(3)"
        }

        test "TypeDef[AnyFnTypeIdx=0] is Struct with no fields (closure base)" {
            let ctx = makeTestCtx()
            match ctx.TypeDefs.[AnyFnTypeIdx].Def with
            | WTypeDef.Struct([], None) -> ()
            | other -> failtestf "AnyFn should be empty struct, got %A" other
        }

        test "TypeDef[StringTypeIdx=1] is Array(I32, mutable)" {
            let ctx = makeTestCtx()
            match ctx.TypeDefs.[StringTypeIdx].Def with
            | WTypeDef.Array(WType.I32, true)
            | WTypeDef.Array(WType.I16, true) -> ()  // I16 mode also ok
            | other -> failtestf "WasmStr should be mutable I32 or I16 array, got %A" other
        }

        test "TypeDef[ListBaseTypeIdx=2] is Struct with no fields (list cons base)" {
            let ctx = makeTestCtx()
            match ctx.TypeDefs.[ListBaseTypeIdx].Def with
            | WTypeDef.Struct([], None) -> ()
            | other -> failtestf "ListBase should be empty struct, got %A" other
        }

        test "TypeDef[StringBuilderTypeIdx=3] is Struct with 3 fields" {
            let ctx = makeTestCtx()
            match ctx.TypeDefs.[StringBuilderTypeIdx].Def with
            | WTypeDef.Struct(fields, None) ->
                Expect.equal fields.Length 3 "StringBuilder has data + length + capacity"
                // data: mut ref $WasmStr
                Expect.equal fields.[0].Type (WType.Ref(StringTypeIdx, false)) "data field is string ref"
                Expect.isTrue fields.[0].Mutable "data field must be mutable"
                // length: mut i32
                Expect.equal fields.[1].Type WType.I32 "length field is I32"
                Expect.isTrue fields.[1].Mutable "length field must be mutable"
                // capacity: mut i32
                Expect.equal fields.[2].Type WType.I32 "capacity field is I32"
                Expect.isTrue fields.[2].Mutable "capacity field must be mutable"
            | other -> failtestf "StringBuilder should be 3-field struct, got %A" other
        }
    ]

    // ── GetOrAddFuncType ────────────────────────────────────────────────────────

    testList "GetOrAddFuncType" [

        test "same signature → same index (idempotent)" {
            let ctx = makeTestCtx()
            let sig1 = [WType.Ref(AnyFnTypeIdx, false); WType.I32]
            let idx1 = ctx.GetOrAddFuncType(sig1, WType.Void)
            let idx2 = ctx.GetOrAddFuncType(sig1, WType.Void)
            Expect.equal idx1 idx2 "same functype signature → same index"
        }

        test "GetOrAddFuncType: different signatures → different indices" {
            let ctx = makeTestCtx()
            let idx1 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I32], WType.Void)
            let idx2 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I64], WType.Void)
            Expect.notEqual idx1 idx2 "Different functype signatures must give different indices"
        }

        test "different result type → different index" {
            let ctx = makeTestCtx()
            let idx1 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false)], WType.I32)
            let idx2 = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false)], WType.Void)
            Expect.notEqual idx1 idx2 "different result types → different indices"
        }

        test "GetOrAddFuncType registers a WTypeDef.Func entry" {
            let ctx = makeTestCtx()
            let idx = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false); WType.I32], WType.I32)
            match ctx.TypeDefs.[idx].Def with
            | WTypeDef.Func(parms, ret) ->
                Expect.equal parms.Length 2 "Func should have 2 params"
                Expect.equal ret WType.I32 "Func should return I32"
            | other -> failtestf "Expected WTypeDef.Func typedef, got %A" other
        }

        test "self-only signature (zero user args) → registers correctly" {
            let ctx = makeTestCtx()
            let idx = ctx.GetOrAddFuncType([WType.Ref(AnyFnTypeIdx, false)], WType.Void)
            match ctx.TypeDefs.[idx].Def with
            | WTypeDef.Func([WType.Ref(0, false)], WType.Void) -> ()
            | other -> failtestf "Expected Func([AnyFn], Void), got %A" other
        }
    ]

    // ── wTypeKey collision resistance ───────────────────────────────────────────

    testList "wTypeKey" [

        test "primitive keys are distinct" {
            Expect.notEqual (wTypeKey WType.I32) (wTypeKey WType.I64)  "i32 ≠ i64"
            Expect.notEqual (wTypeKey WType.I32) (wTypeKey WType.F32)  "i32 ≠ f32"
            Expect.notEqual (wTypeKey WType.I32) (wTypeKey WType.F64)  "i32 ≠ f64"
            Expect.notEqual (wTypeKey WType.F32) (wTypeKey WType.F64)  "f32 ≠ f64"
            Expect.notEqual (wTypeKey WType.I32) (wTypeKey WType.Void) "i32 ≠ void"
        }

        test "I32 ≠ Ref(0, false) — prevents list/primitive registry collisions" {
            Expect.notEqual
                (wTypeKey WType.I32)
                (wTypeKey (WType.Ref(0, false)))
                "I32 key must not collide with Ref(0) key"
        }

        test "nullable and non-nullable refs produce different keys" {
            Expect.notEqual
                (wTypeKey (WType.Ref(1, false)))
                (wTypeKey (WType.Ref(1, true)))
                "Ref(1,false) ≠ Ref(1,true)"
        }

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
]
