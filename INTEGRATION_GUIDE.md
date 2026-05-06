# TEIL 1, TEIL 2, TEIL 3 Implementation Guide

## Overview

This guide documents the implementation of the Pipeline Robustness plan from `PIPELINE_SPEC.fs`:

- **TEIL 1**: Pipeline phase decomposition (8-phase pipeline with clear concerns)
- **TEIL 2**: Debug dump system for introspection at each phase
- **TEIL 3**: Query DSL for clean tree traversal and analysis

All components have been implemented and added to the project compilation order.

---

## TEIL 1: Pipeline Phases

### Architecture

The 8-phase pipeline replaces the monolithic `transformExpr` function with clear, sequential phases:

```
Phase 0: Fable AST (Input)
   ↓
Phase 1: ScopeAnalyzer → ScopeMap
   ↓
Phase 2: TypeResolver (extract from Types.fs)
   ↓
Phase 3: Fable → WExpr (Fable2WasmGc.fs using ScopeMap)
   ↓
Phase 4: Normalizer → clean WExpr
   ↓
Phase 5: Locals Collection (existing WasmGcLocals.fs)
   ↓
Phase 6: Validation → catch errors early
   ↓
Phase 7: Optimization (existing Optimize.fs)
   ↓
Phase 8: Emission → binary + optional WAT
```

### Phase 1: ScopeAnalyzer.fs

**Location**: `src/Pipeline/ScopeAnalyzer.fs`

**Purpose**: Single-pass scope analysis of Fable AST to build a `ScopeMap`.

**Key Types**:
- `ScopeKind`: `Local | FreeVar | ModuleValue | KnownFunc`
- `ScopeEntry`: `{ Kind, WType, Depth }`
- `ScopeMap`: `Map<string, ScopeEntry>`

**Key Functions**:
- `analyzeScopeOfExpr`: Analyze an expression, return ScopeMap
- `classifyIdent`: Determine scope kind for an identifier
- `markFreeVars`: Mark variables captured across lambda boundary
- `analyzeModuleScope`: Analyze all functions in a module

**Benefits**:
- Replaces `collectFreeVars` re-traversal
- Replaces scattered `ctx.Locals.TryFind` calls
- Single upfront analysis, used throughout Phase 3

**Integration Point**:
```fsharp
// In Fable2WasmGc.transformExpr:
let scope = ScopeAnalyzer.analyzeScopeOfExpr ctx expr
// Instead of: collectFreeVars / ctx.Locals / ctx.KnownFuncs lookups
match scope.TryFind(identName) with
| Some entry when entry.Kind = Local -> WExpr.LocalGet(name, entry.WType)
| Some entry when entry.Kind = FreeVar -> buildCapture(name, entry.WType)
| _ -> WExpr.LocalGet(name, WType.I32)
```

### Phase 4: Normalizer.fs

**Location**: `src/Pipeline/Normalizer.fs`

**Purpose**: Clean WExpr tree after Phase 3 transformation.

**Problems It Solves**:
1. Nested Sequences: `Sequence([Sequence([...]), ...])` → flat list
2. Unnecessary Nops in sequences
3. Double-counted Let bindings: `Let(x, e, Let(x, e', body))`

**Key Functions**:
- `flattenSequences`: Flatten nested Sequences
- `removeUnnecessaryNops`: Remove Nop except when it's the only expr
- `normalizeExpr`: Recursive bottom-up normalization
- `normalizeFuncDecl`, `normalizeModule`: Apply to all functions

**Why It's Needed**:
- `Phase 5 (collectLocals)` must count each local name exactly once
- Without normalization, double-counted Let names cause inconsistency
- Validation catches missing locals → cryptic WAT traps

**Integration Point**:
```fsharp
// In Pipeline.Phases.runPipeline:
let phase4_Normalize (wmod: WModule) : WModule =
    normalizeModule wmod
```

### Phase Orchestration: Phases.fs

**Location**: `src/Pipeline/Phases.fs`

**Purpose**: Coordinate all 8 phases with debug output.

**Key Type**:
```fsharp
type PipelineOptions = {
    DumpPhases: Set<int>      // Which phases to dump (0-8)
    DumpDir: string           // Output directory for dumps
    StrictValidation: bool    // Fail on first error
}
```

**Main Function**:
```fsharp
let runPipeline (ctx: Ctx) (decls: Declaration list) (opts: PipelineOptions)
    : Result<WModule, string list>
```

**Current Stubs** (to be integrated):
- `phase2_TypeResolver`: Extract from Types.fs
- `phase3_TransformToWExpr`: Pass ScopeMap to Fable2WasmGc
- `phase6_Validate`: Call existing Validator.validate

---

## TEIL 2: Debug Dumps

### Overview

Four dump formats for introspection:

| Phase | File | Format | Use Case |
|-------|------|--------|----------|
| 0 | FableAstDump.fs | F#-like pseudo-code | Understand input AST structure |
| 3 | IrDump.fs | S-expression (WASM-like) | Understand IR after transform |
| 8 | Existing WAT dump | WASM text | Check final code |

Enable with CLI flag: `--dump-phases 0,3,8`

### FableAstDump.fs

**Location**: `src/Util/FableAstDump.fs`

**Output Example**:
```
[Function] iterate : float -> float -> int -> int
  let x : float = 0.0
  let y : float = 0.0
  let mutable i : int = 0
  [While]
    [Cond] (i < maxIter) && (x*x + y*y < 4.0)
    [Body]
      let xn : float = (sub (mul x x) (mul y y))
      set y = (add (mul 2.0 (mul x y)) cy)
      set x = xn
      set i = (add i 1)
  i
```

**Key Functions**:
- `typeToString`: Convert Fable.Type → readable string
- `dumpExpr`: Format expression with indentation and structure tags
- `dumpModule`: Format all declarations
- `dumpToFile`: Write to output file

### IrDump.fs

**Location**: `src/Util/IrDump.fs`

**Output Example** (S-expression format):
```
(func $iterate (param cx f64) (param cy f64) (param maxIter i32) → i32
  (let-mut $w3 i32 0
    (loop $w4 void
      (if (and (lt-s-s $w3 maxIter) (lt-f64 (add-f64 (* $w1 $w1) (* $w2 $w2)) 4.0))
        (seq
          (let $w5 f64 (sub-f64 (sub-f64 (* $w1 $w1) (* $w2 $w2)) cx)
            (seq
              (set $w2 (add-f64 (* 2.0 (* $w1 $w2)) cy))
              (set $w1 $w5)
              (set $w3 (add-s $w3 1))
              (continue $w4))))
        (break $w4_exit)))))
  $w3)
```

**Key Functions**:
- `wTypeToString`, `wUnOpToString`, `wBinOpToString`, `wCompOpToString`: Type/op formatters
- `dumpExpr`: Recursively format WExpr as S-expression
- `dumpModule`: Format all functions
- `dumpToFile`: Write to output file

### Usage

**CLI Integration** (to be added to Pipeline.fs):
```fsharp
// Parse --dump-phases flag from CLI
let opts = {
    DumpPhases = parseDumpPhases argv
    DumpDir = parseDumpDir argv
    StrictValidation = true
}

// In runPipeline:
if opts.DumpPhases.Contains(0) then
    FableAstDump.dumpToFile (Path.Combine(opts.DumpDir, "phase0.fs")) decls

if opts.DumpPhases.Contains(3) then
    IrDump.dumpToFile (Path.Combine(opts.DumpDir, "phase3.sexp")) wmod
```

---

## TEIL 3: Query DSL

### FableQuery.fs (Enhanced)

**Location**: `src/Util/FableQuery.fs`

**New Active Patterns** (added to existing ones):

**Literal Patterns**:
- `IntLit`, `StrLit`, `BoolLit`, `UnitVal`: Existing
- `NullLit`, `FloatLit`, `CharLit`: New

**Type Patterns**:
- `ListOf`, `ArrayOf`, `ResizeArrayOf`, `OptionOf`, `TupleOf`: Existing
- `NamedType`, `GenericType`, `FunctionType`, `MaybeTuple`: New

**Declaration Patterns**:
- `IsExported`, `IsAbstract`: Check declaration attributes

**Field/Array Access**:
- `GetField`, `SetField`: Field access patterns
- `GetIndex`, `SetIndex`: Array indexing patterns

**Control Flow**:
- `IfExpr`, `WhileExpr`, `ForExpr`, `TryExpr`: Deconstruct control flow

**Common Operations**:
- `ListCons`, `ListEmpty`, `ListMap`: List operations
- `ArrayCreate`: Array creation
- `StringConcat`, `StringLength`, `StringIndex`: String operations

**N-ary Lambdas**:
- `NaryLambda`: Pattern for N-argument lambda deconstruction

**Example Usage**:
```fsharp
// Old: scatter pattern matching
match selector, fableArgs with
| "map", [Lambda(farg, fbody, _); listArg] -> ...
| "map", [Delegate([farg], fbody, _, _); listArg] -> ...

// New: clean with FableQuery
match selector, fableArgs with
| "map", HofArgs(farg, fbody, ListOf elemType) ->
    // NaryLambda helps with curried functions
    let (args, body) = (NaryLambda 3 lambda)
```

### WExprQuery.fs (New)

**Location**: `src/Util/WExprQuery.fs`

**Purpose**: Traverse, analyze, and transform WExpr trees.

**Core Functions**:

#### Traversal:
- `children`: List all immediate subexpressions (no recursion)

#### Aggregation (bottom-up):
- `fold`: Fold over all nodes
- `collect`: Gather all nodes matching a predicate
- `localRefs`: All LocalGet references
- `closureApplys`: All ClosureApply nodes
- `allLoops`: All Loop nodes
- `breaksForLabel`: All Breaks targeting a label
- `loopNestingDepth`: Max loop nesting depth

#### Transformation:
- `rewrite`: Bottom-up transformation with optional rewriting

#### Analysis:
- `referencesLocal`: Check if a name is referenced
- `removeNops`: Eliminate Nop expressions
- `flattenSequences`: Flatten nested Sequences

**Example Usage**:

```fsharp
// In Validator.fs — check ClosureApply arities:
let mismatches =
    WExprQuery.closureApplys expr
    |> List.choose (fun ca ->
        match ca with
        | WExpr.ClosureApply(_, args, fti, _, _, _) ->
            let actual = List.length args
            match arityMap.TryFind(fti) with
            | Some expected when actual <> expected ->
                Some(fti, expected, actual)
            | _ -> None
        | _ -> None)

// In Optimize.fs — dead code elimination:
let optimized = WExprQuery.rewrite (fun expr ->
    match expr with
    | WExpr.Sequence([single]) -> Some single
    | WExpr.Sequence es ->
        let filtered = es |> List.filter (isNotDeadCode)
        if filtered.Length < es.Length then Some(WExpr.Sequence filtered)
        else None
    | _ -> None
) expr
```

---

## Integration Checklist

### ✓ Completed

- [x] ScopeAnalyzer.fs implementation
- [x] Normalizer.fs implementation
- [x] Phases.fs orchestration
- [x] FableAstDump.fs implementation
- [x] IrDump.fs implementation
- [x] WExprQuery.fs implementation
- [x] FableQuery.fs enhancement
- [x] Added to Fable.WasmGc.fsproj in correct order

### ⚠ Next Steps (Integration Points)

- [ ] **Phase 2**: Extract TypeResolver from Types.fs into separate module
  - Candidates: `mapTypeKnown`, registry logic, type caching

- [ ] **Phase 3**: Integrate ScopeMap into Fable2WasmGc
  - Pass `ScopeMap` to `transformExpr`
  - Replace `collectFreeVars` calls with `ScopeMap.Kind = FreeVar`
  - Replace `ctx.Locals.TryFind` with `ScopeMap.TryFind`
  - Simplify IdentExpr handling

- [ ] **Phase 6**: Use WExprQuery in Validator
  - Call `WExprQuery.closureApplys` for arity checking
  - Call `WExprQuery.localRefs` for unknown local detection
  - Improve error messages with line ranges

- [ ] **Phase 7**: Use WExprQuery in Optimize
  - Use `WExprQuery.rewrite` for transformations
  - Use `WExprQuery.collect` for analysis passes

- [ ] **Pipeline.fs**: Integrate Phases.runPipeline
  - Call `Phases.runPipeline` instead of inline transformation
  - Parse `--dump-phases` CLI flag
  - Return `Result<WModule, string list>` from compilation

- [ ] **CLI**: Add flags for debugging
  - `--dump-phases N,M,P`: Dump phases N, M, P
  - `--dump-dir PATH`: Output directory for dumps
  - `--strict-validation`: Fail on first error

---

## Testing

### Unit Tests (TEIL 4 — Future)

Test files to create (referenced in PIPELINE_SPEC.fs):

**TEIL 1 Tests**:
- `tests/Unit/LocalsTests.fs`: collectLocals correctness
- `tests/Unit/IdentExprTests.fs`: Module-level function vs. local resolution
- `tests/Unit/TypeResolutionTests.fs`: Type mapping edge cases

**TEIL 2 Tests**:
- `tests/Snapshot/MandelbrotTests.fs`: Full pipeline, WAT snapshot

**TEIL 3 Tests**:
- Property-based tests for WExprQuery transformations

### Manual Testing

```bash
# Compile with dumps
dotnet build src/Fable.WasmGc.fsproj

# Run compiler with debug output
./fable --target WasmGc --input src/demo.fs --dump-phases 0,3,8 --dump-dir ./debug

# Inspect dumps
cat debug/phase0.fs       # Fable AST
cat debug/phase3.sexp    # WExpr IR
cat debug/phase8.wat     # Final WASM
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│  Fable.Compiler (input)                                         │
│  Fable.Declaration list                                         │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 0: Input
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  [Optional Dump] FableAstDump.dumpToFile                        │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 1: ScopeAnalyzer
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  ScopeMap = Map<string, ScopeEntry>                             │
│  - Local | FreeVar | ModuleValue | KnownFunc                    │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 2: TypeResolver
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  Type registries updated (ListRegistry, TypeRegistry, etc.)    │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 3: Fable → WExpr
                       │ (with ScopeMap integration)
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  WModule (raw, possibly messy)                                  │
│  - Nested Sequences, Nops, double-counted Lets                 │
└──────────────────────┬──────────────────────────────────────────┘
                       │ [Optional Dump] IrDump.dumpToFile
                       │ Phase 4: Normalizer
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  WModule (normalized, clean)                                    │
│  - Flat Sequences, no Nops, unique Let names                   │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 5: Locals Collection
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  WFuncDecl with populated Locals list                           │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 6: Validation (with WExprQuery)
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  ValidationResult (errors or success)                           │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 7: Optimization (with WExprQuery)
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  WModule (optimized)                                            │
└──────────────────────┬──────────────────────────────────────────┘
                       │ Phase 8: Emission
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│  Binary WASM + optional WAT dump                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## FAQ

**Q: Why is Phase 4 (Normalizer) necessary?**
A: Phase 3 produces raw WExpr with potential issues (nested Sequences, Nops, duplicate Let bindings). Phase 5 (locals collection) needs clean input. Without normalization, locals are double-counted.

**Q: Can I use ScopeMap without the rest?**
A: Yes. ScopeAnalyzer is independent. Use it in any transform that needs upfront scope analysis.

**Q: How do I extend the dump system?**
A: Add a new `DumpX.fs` file in `src/Util/`, implement `dumpToFile : outPath → data → unit`, and integrate in `Phases.fs`.

**Q: Can WExprQuery be used outside the pipeline?**
A: Yes. It's a pure query library with no side effects. Use `fold`, `collect`, `rewrite` anywhere you need tree analysis.

---

## Files

| File | Purpose | Lines |
|------|---------|-------|
| ScopeAnalyzer.fs | Phase 1 scope analysis | ~250 |
| Normalizer.fs | Phase 4 WExpr normalization | ~250 |
| Phases.fs | Pipeline orchestration | ~150 |
| FableAstDump.fs | Phase 0 dump format | ~200 |
| IrDump.fs | Phase 3 dump format | ~350 |
| WExprQuery.fs | WExpr tree queries | ~350 |
| FableQuery.fs | Enhanced active patterns | +150 |

**Total**: ~1650 lines of new code

---

## References

- **PIPELINE_SPEC.fs**: Original detailed specification
- **Pipeline.fs**: Main entry point (to be updated)
- **Fable2WasmGc.fs**: Main transform (integration point)
- **Validator.fs**: Validation (to use WExprQuery)
- **Optimize.fs**: Optimization (to use WExprQuery)
