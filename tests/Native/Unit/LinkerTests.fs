/// Unit tests for the static module linker.
/// Tests are structured around four invariants:
///   1. Type deduplication  — same structural type from two modules → one entry in merged
///   2. Index remapping     — all WExpr type indices are correctly rewritten
///   3. Import resolution   — B imports A.foo → no import in merged module
///   4. BCL deduplication   — $strConcat in both modules → one copy in merged
module Tests.Unit.LinkerTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Emit.Linker
open Tests.WasmTestHelper

// ─────────────────────────────────────────────────────────────────────────────
// Helpers for building minimal WModules
// ─────────────────────────────────────────────────────────────────────────────

let private strArrayDef = WTypeDef.Array(WType.I32, true)  // our string type
let private intArrayDef = WTypeDef.Array(WType.I32, true)  // same layout!

let private emptyModule name = {
    Types    = []
    Imports  = []
    Functions= []
    Globals  = []
    Exports  = []
    DataSegments = []
    Tags     = []
    Start    = None
    HasLinearMemory = false
}

let private withType (entry: WTypeDeclEntry) (m: WModule) =
    { m with Types = m.Types @ [entry] }

let private withFunc (f: WFuncDecl) (m: WModule) =
    { m with Functions = m.Functions @ [f] }

let private withExport (name: string) (internal_: string) (m: WModule) =
    { m with Exports = m.Exports @ [{ ExportName = name; InternalName = internal_; Kind = ExportFunc }] }

let private withImport (modName: string) (name: string) (ps: WType list) (ret: WType) (m: WModule) =
    { m with Imports = m.Imports @ [{ ModuleName = modName; Name = name; CallName = name
                                       Desc = ImportFunc(ps, ret) }] }

let private simpleFunc name (body: WExpr) result =
    { Name = name; Params = []; Result = result; Locals = []; Body = body; Exported = false }

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let linkerTests = testList "Linker" [

    // ── Invariant 1: type deduplication ──────────────────────────────────────

    test "identical array types from two modules deduplicate to one entry" {
        // Both modules define `array i32` with the same layout.
        // The merged module must have exactly ONE such type.
        let def = { Name = "$IntArray"; Def = WTypeDef.Array(WType.I32, true) }
        let modA = emptyModule "A" |> withType def
        let modB = emptyModule "B" |> withType def

        let merged = linkModules [("A", modA); ("B", modB)]

        let arrayI32Count =
            merged.Types
            |> List.filter (fun e ->
                match e.Def with WTypeDef.Array(WType.I32, true) -> true | _ -> false)
            |> List.length

        Expect.equal arrayI32Count 1
            "Two modules with identical array types should produce one merged type"
    }

    test "distinct types are both preserved" {
        let defA = { Name = "$StructA"; Def = WTypeDef.Struct([{Name="x"; Type=WType.I32; Mutable=false}], None) }
        let defB = { Name = "$StructB"; Def = WTypeDef.Struct([{Name="y"; Type=WType.I64; Mutable=false}], None) }
        let modA = emptyModule "A" |> withType defA
        let modB = emptyModule "B" |> withType defB

        let merged = linkModules [("A", modA); ("B", modB)]

        Expect.equal merged.Types.Length 2 "Two distinct struct types → two entries in merged module"
    }

    // ── Invariant 2: index remapping ─────────────────────────────────────────

    test "LocalGet type index is remapped after linking" {
        // Module A has one type (idx 0). Module B has same type (→ also idx 0 after dedup)
        // plus its own struct (→ idx 1). A LocalGet in B's func that references idx 1
        // must still reference the correct type in the merged module.
        let sharedArr = { Name = "$Arr"; Def = WTypeDef.Array(WType.I32, true) }
        let bStruct   = { Name = "$BStruct"; Def = WTypeDef.Struct([{Name="v"; Type=WType.I32; Mutable=false}], None) }
        let modA = emptyModule "A" |> withType sharedArr
        let modB = emptyModule "B" |> withType sharedArr |> withType bStruct

        // In B's local, index 1 = $BStruct
        let bFunc = simpleFunc "bFunc"
            (WExpr.LocalGet("x", WType.Ref(1, false)))
            (WType.Ref(1, false))
        let modB = modB |> withFunc bFunc

        let merged = linkModules [("A", modA); ("B", modB)]

        // $BStruct is at index 1 in merged (0 = shared arr, 1 = BStruct)
        let mergedFunc = merged.Functions |> List.find (fun f -> f.Name = "bFunc")
        match mergedFunc.Body with
        | WExpr.LocalGet(_, WType.Ref(idx, false)) ->
            Expect.equal merged.Types.[idx].Name "$BStruct"
                "LocalGet after link must reference $BStruct (not $Arr or undefined)"
        | other ->
            failtestf "Expected LocalGet but got %A" other
    }

    test "ArrayNew type index is remapped" {
        let arrDef = { Name = "$IntArr"; Def = WTypeDef.Array(WType.I32, true) }
        // Module B's array-new uses local idx 0; after dedup with A (which also has idx 0),
        // the merged index might differ.
        let modA = emptyModule "A" |> withType arrDef
        let modB =
            emptyModule "B"
            |> withType arrDef
            |> withFunc (simpleFunc "allocArr"
                (WExpr.ArrayNew(0, WExpr.Const(WConst.I32 10), WExpr.Const(WConst.I32 0), WType.Ref(0, false)))
                (WType.Ref(0, false)))

        let merged = linkModules [("A", modA); ("B", modB)]
        let f = merged.Functions |> List.find (fun f -> f.Name = "allocArr")
        match f.Body with
        | WExpr.ArrayNew(idx, _, _, _) ->
            Expect.equal merged.Types.[idx].Name "$IntArr"
                "ArrayNew after link must reference correct deduplicated type"
        | other -> failtestf "Expected ArrayNew got %A" other
    }

    // ── Invariant 3: import resolution ───────────────────────────────────────

    test "import satisfied by earlier module is removed from merged module" {
        // A exports "compute"; B imports "compute" from A.
        // Merged module: no import for "compute", just the function.
        let fn = simpleFunc "compute" (WExpr.Const(WConst.I32 42)) WType.I32
        let modA =
            emptyModule "A"
            |> withFunc { fn with Exported = true }
            |> withExport "compute" "compute"
        let modB =
            emptyModule "B"
            |> withImport "A" "compute" [] WType.I32
            |> withFunc (simpleFunc "useCompute"
                (WExpr.Call("compute", [], WType.I32))
                WType.I32)

        let merged = linkModules [("A", modA); ("B", modB)]

        let hasComputeImport =
            merged.Imports |> List.exists (fun i -> i.Name = "compute")
        Expect.isFalse hasComputeImport
            "Import 'compute' must be resolved (removed) in merged module"

        let hasComputeFunc =
            merged.Functions |> List.exists (fun f -> f.Name = "compute")
        Expect.isTrue hasComputeFunc
            "Function 'compute' must exist in merged module"
    }

    test "external import (not in any module) is preserved" {
        let modA = emptyModule "A"
                   |> withImport "env" "consolePrint" [WType.Ref(0, false)] WType.Void
        let merged = linkModules [("A", modA)]
        let hasEnvImport = merged.Imports |> List.exists (fun i -> i.ModuleName = "env")
        Expect.isTrue hasEnvImport "External 'env/consolePrint' import must be preserved"
    }

    // ── Invariant 4: BCL helper deduplication ─────────────────────────────────

    test "$strConcat BCL helper is not duplicated across modules" {
        // Both A and B include the $strConcat helper (same name, same body).
        // The merged module must have exactly one copy.
        let helper = simpleFunc "$strConcat"
            (WExpr.Const(WConst.I32 0))
            WType.I32
        let modA = emptyModule "A" |> withFunc helper
        let modB = emptyModule "B" |> withFunc helper

        let merged = linkModules [("A", modA); ("B", modB)]

        let count = merged.Functions |> List.filter (fun f -> f.Name = "$strConcat") |> List.length
        Expect.equal count 1 "$strConcat must appear exactly once in merged module"
    }

    // ── Linker result diagnostics ─────────────────────────────────────────────

    test "link result reports duplicate exports as diagnostics, not exceptions" {
        let fn  = simpleFunc "myFn" (WExpr.Const(WConst.I32 0)) WType.I32
        let modA = emptyModule "A" |> withFunc fn |> withExport "myFn" "myFn"
        let modB = emptyModule "B" |> withFunc fn |> withExport "myFn" "myFn"

        let result = link LinkOptions.defaults [("A", modA); ("B", modB)]
        let hasDupDiag = result.Diagnostics |> List.exists (function DuplicateExport("myFn", _) -> true | _ -> false)
        Expect.isTrue hasDupDiag "Duplicate export 'myFn' must be reported in diagnostics"
        // Must not throw
        Expect.isNotNull result.Module "Linker must produce a module even with duplicate export warning"
    }

    test "type deduplication is recorded in diagnostics" {
        let def = { Name = "$Shared"; Def = WTypeDef.Array(WType.I32, true) }
        let modA = emptyModule "A" |> withType def
        let modB = emptyModule "B" |> withType def

        let result = link LinkOptions.defaults [("A", modA); ("B", modB)]
        let hasDedupDiag = result.Diagnostics |> List.exists (function TypeDeduplication _ -> true | _ -> false)
        Expect.isTrue hasDedupDiag "Type deduplication must be recorded in diagnostics"
    }

    // ── Snapshot test ─────────────────────────────────────────────────────────

    wexprSnapshot "linker/remapped-local-get" (
        // Simulate what a linked function body looks like after remapping
        WExpr.Let("x",
            WExpr.ArrayNew(3, WExpr.Const(WConst.I32 5), WExpr.Const(WConst.I32 0), WType.Ref(3, false)),
            WExpr.ArrayGet(WExpr.LocalGet("x", WType.Ref(3, false)), WExpr.Const(WConst.I32 0), WType.I32))
    )
]
