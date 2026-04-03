# Project Status

> **As of Sprint 19e** — 377/377 QuickTests passing  
> **Build:** `dotnet build src/Fable.WasmGc.fsproj` — 0 errors, 0 warnings  
> **Toolchain:** `wasm-tools` v1.245+ validates all binary output

## Test Results

| Test Suite             | Count   | Status         |
| ---------------------- | ------- | -------------- |
| QuickTest (unit tests) | 377     | ✅ All passing |
| Showcase (algorithms)  | 26      | ✅ All passing |
| Component Embed        | 39      | ✅ All passing |
| Component Linking      | 22      | ✅ All passing |
| **Total**              | **424** | ✅             |

## Feature Matrix

### Core Language

| Feature                               | Status | Since      |
| ------------------------------------- | ------ | ---------- |
| Let bindings, `let rec`               | ✅     | Sprint 1   |
| Arithmetic (i32, i64, f32, f64)       | ✅     | Sprint 1–2 |
| Tail calls (`return_call`)            | ✅     | Sprint 1   |
| Mutual recursion                      | ✅     | Sprint 1   |
| If/then/else                          | ✅     | Sprint 1   |
| For loops (`for i in 0..n`)           | ✅     | Sprint 2   |
| While loops                           | ✅     | Sprint 2   |
| Global variables                      | ✅     | Sprint 2.5 |
| Exception handling (basic `try/with`) | ✅     | Sprint 3   |
| Math library (`System.Math.*`)        | ✅     | Sprint 2   |
| `Math.Exp`, `Math.Log` (software)     | ✅     | Sprint 19e |
| Type casts                            | ✅     | Sprint 2   |

### Type System

| Feature                                         | Status | Since      |
| ----------------------------------------------- | ------ | ---------- |
| Records (immutable)                             | ✅     | Sprint 3   |
| Records (mutable fields)                        | ✅     | Sprint 13  |
| Discriminated Unions                            | ✅     | Sprint 4   |
| Pattern matching (DUs, records, decision trees) | ✅     | Sprint 4   |
| `br_on_cast` for pattern dispatch               | ✅     | Sprint 4   |
| `WExpr.RefTest` AST node (`ref.test`)           | ✅     | Sprint 19d |
| Structural equality                             | ✅     | Sprint 6   |
| Nested records/DUs                              | ✅     | Sprint 4   |
| Single-case DUs (zero-cost)                     | ✅     | Sprint 5   |
| Generics (monomorphization)                     | ✅     | Sprint 5   |
| Cross-file generic specialization               | ✅     | Sprint 10c |

### Functions and Closures

| Feature                           | Status | Since    |
| --------------------------------- | ------ | -------- |
| Closures / higher-order functions | ✅     | Sprint 5 |
| `$AnyFn` closure hierarchy        | ✅     | Sprint 5 |
| `call_ref` dispatch               | ✅     | Sprint 5 |
| Partial application               | ✅     | Sprint 5 |
| Currying                          | ✅     | Sprint 5 |
| Free variable analysis            | ✅     | Sprint 5 |

### Strings

| Feature                                    | Status | Since        |
| ------------------------------------------ | ------ | ------------ |
| String literals                            | ✅     | Sprint 6     |
| String concatenation                       | ✅     | Sprint 6     |
| String comparison                          | ✅     | Sprint 6     |
| String indexing                            | ✅     | Sprint 6     |
| String length                              | ✅     | Sprint 6     |
| `String.indexOf` / `lastIndexOf`           | ✅     | Sprint 6     |
| `String.toUpper` / `toLower`               | ✅     | Sprint 9     |
| `String.trim` / `trimStart` / `trimEnd`    | ✅     | Sprint 9     |
| `String.replace`                           | ✅     | Sprint 9     |
| `String.startsWith` / `endsWith`           | ✅     | Sprint 9     |
| `String.split` (char + string delimiter)   | ✅     | Sprint 13/15 |
| `String.join`                              | ✅     | Sprint 15    |
| `sprintf` / `printfn` / `printf`           | ✅     | Sprint 10e   |
| `$"string interpolation"`                  | ✅     | Sprint 10e   |
| `%%` format escape                         | ✅     | Sprint 10e   |
| `char` → `string` conversion               | ✅     | Sprint 13    |
| i16 string mode (`WASMGC_STRING_MODE=i16`) | ✅     | Sprint 16    |

### Collections

| Feature                                       | Status | Since      |
| --------------------------------------------- | ------ | ---------- |
| `List<'T>` (linked list)                      | ✅     | Sprint 9   |
| `List.map`, `filter`, `fold`, `rev`           | ✅     | Sprint 9   |
| `List.iter`, `length`, `head`, `tail`         | ✅     | Sprint 9   |
| `List.append`, `concat`                       | ✅     | Sprint 10  |
| `Array<'T>` — construction, indexing          | ✅     | Sprint 9   |
| `Array.length`                                | ✅     | Sprint 9   |
| `Array.map`                                   | ✅     | Sprint 9   |
| `Array.filter`, `some`, `every`, `forEach`    | ✅     | Sprint 10  |
| `Option<'T>` — all combinators                | ✅     | Sprint 9   |
| `Option<RefType>` — nullable ref optimization | ✅     | Sprint 10d |
| `Result<'T,'E>` — all combinators             | ✅     | Sprint 10  |

### Parsing and Formatting

| Feature                       | Status | Since     |
| ----------------------------- | ------ | --------- |
| `Int32.Parse`                 | ✅     | Sprint 15 |
| `Double.Parse` / `float` cast | ✅     | Sprint 15 |
| `string` → `int` conversion   | ✅     | Sprint 15 |

### Multi-File and Modules

| Feature                          | Status | Since      |
| -------------------------------- | ------ | ---------- |
| Multi-file pipeline (shared Ctx) | ✅     | Sprint 9   |
| Cross-file function calls        | ✅     | Sprint 9   |
| F# library (`Map.fs` int-BST)    | ✅     | Sprint 9   |
| Standalone NuGet backend         | ✅     | Sprint 10  |
| Fable 5 CLI integration          | ✅     | Sprint 10e |

### FFI and Component Model

| Feature                                  | Status | Since        |
| ---------------------------------------- | ------ | ------------ |
| `[<Import("name","module")>]` FFI        | ✅     | Sprint 11b   |
| `nativeOnly` bindings                    | ✅     | Sprint 11b   |
| WIT file generation                      | ✅     | Sprint 11c   |
| `wasm-tools component embed` integration | ✅     | Sprint 11c   |
| Two-component module linking             | ✅     | Sprint 12/14 |

### Infrastructure

| Feature                            | Status | Since      |
| ---------------------------------- | ------ | ---------- |
| `wasm {}` CE builder in Runtime    | ✅     | Sprint 10b |
| `makeFunc` + loop sugar            | ✅     | Sprint 11a |
| `LabelGen` + `letVal`/`letMut`     | ✅     | Sprint 16  |
| `WasmGcLoopCombinators`            | ✅     | Sprint 16  |
| `WasmGcQuotationWalker`            | ✅     | Sprint 16  |
| `watId` underscore-separator fix   | ✅     | Sprint 15  |
| Binary validation via `wasm-tools` | ✅     | Sprint 10  |

## Not Yet Implemented

| Feature                     | Priority  | Notes                                                  |
| --------------------------- | --------- | ------------------------------------------------------ |
| Interface dispatch / vtable | High      | Design complete in `design/vtable-generics.md`         |
| Generic `Map<'K,'V>`        | High      | Only `int` keys work today                             |
| Generic `Set<'T>`           | High      | Stub only                                              |
| `seq { }` / `IEnumerable`   | Medium    | Lazy sequences                                         |
| Typed exception throws      | Medium    | Basic try/with works; typed `exn` not fully integrated |
| Async / JSPI                | Medium    | Needs JSPI (Node.js 22+, Chrome 123+)                  |
| SRTPs / generic comparison  | Medium    | Needed for generic Map/Set                             |
| Full `fable-library-wasmgc` | Long-term | Compile F# BCL through own backend                     |

## Source File Sizes

| File                               | LOC   | Purpose                          |
| ---------------------------------- | ----- | -------------------------------- |
| `Transforms/WasmGcReplacements.fs` | ~2444 | All BCL inline replacements      |
| `Transforms/Fable2WasmGc.fs`       | ~1100 | Main Fable AST → WasmGC IR       |
| `Runtime/WasmGcRuntime.fs`         | ~830  | makeFunc + runtime helpers       |
| `Emit/WasmGcEmit.fs`               | ~870  | WExpr → Instr lowering           |
| `Emit/WasmGcEncoder.fs`            | ~800  | Binary .wasm encoder             |
| `Emit/WasmGcWat.fs`                | ~720  | WAT text emitter                 |
| `WasmGc.AST.fs`                    | ~590  | IR type definitions              |
| `Runtime/WasmGcLoopCombinators.fs` | ~280  | Composable traversal combinators |
| `Runtime/WasmGcQuotationWalker.fs` | ~280  | Quotation → WFuncDecl translator |
| `Runtime/WasmGcBuilder.fs`         | ~360  | CE builder + smart constructors  |
| `Emit/WasmGcOptimize.fs`           | ~300  | Optimization passes              |
| `Runtime/WasmGcTypes.fs`           | ~300  | Ctx record, type registries      |
| `Runtime/WasmGcLoopHelpers.fs`     | ~128  | Stack helpers for loops          |
| `Runtime/WasmGcFreeVars.fs`        | ~82   | Free variable analysis           |
| `WasmGcPipeline.fs`                | ~80   | Pipeline entry point             |
