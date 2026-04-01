# BCL Coverage

This document lists the .NET Base Class Library (BCL) functions currently supported by fsharp-wasm.
All supported functions are implemented as **inline WasmGC IR** in `WasmGcReplacements.fs` —
they produce no runtime library dependency.

## `List<'T>`

| Function                    | Status | Notes             |
| --------------------------- | ------ | ----------------- |
| `List.map`                  | ✅     |                   |
| `List.filter`               | ✅     |                   |
| `List.fold`                 | ✅     |                   |
| `List.foldBack`             | ✅     |                   |
| `List.iter`                 | ✅     |                   |
| `List.iteri`                | ✅     |                   |
| `List.rev`                  | ✅     |                   |
| `List.length`               | ✅     |                   |
| `List.head`                 | ✅     |                   |
| `List.tail`                 | ✅     |                   |
| `List.append`               | ✅     | `@` operator      |
| `List.concat`               | ✅     |                   |
| `List.isEmpty`              | ✅     |                   |
| `List.exists`               | ✅     |                   |
| `List.forall`               | ✅     |                   |
| `List.find`                 | ✅     |                   |
| `List.tryFind`              | ✅     |                   |
| `List.item`                 | ✅     |                   |
| `List.mapi`                 | ✅     |                   |
| `List.choose`               | ✅     |                   |
| `List.collect`              | ✅     |                   |
| `List.sum`                  | ✅     | `int` and `float` |
| `List.sumBy`                | ✅     |                   |
| `List.min` / `List.max`     | ✅     | `int` and `float` |
| `List.minBy` / `List.maxBy` | ✅     |                   |
| `List.sortBy`               | ⏳     | Planned           |
| `List.distinctBy`           | ⏳     | Planned           |
| `List.groupBy`              | ⏳     | Planned           |
| `List.zip`                  | ⏳     | Planned           |
| `List.unzip`                | ⏳     | Planned           |

## `Array<'T>`

| Function                | Status | Notes              |
| ----------------------- | ------ | ------------------ |
| `Array.length`          | ✅     | `.Length` property |
| `Array.get` / `.[i]`    | ✅     |                    |
| `Array.set` / `.[i] <-` | ✅     |                    |
| `Array.map`             | ✅     |                    |
| `Array.filter`          | ✅     |                    |
| `Array.iter`            | ✅     | `forEach`          |
| `Array.exists`          | ✅     | `some`             |
| `Array.forall`          | ✅     | `every`            |
| `Array.fold`            | ✅     |                    |
| `Array.zeroCreate`      | ✅     |                    |
| `Array.create`          | ✅     |                    |
| `Array.init`            | ✅     |                    |
| `Array.copy`            | ✅     |                    |
| `Array.append`          | ✅     |                    |
| `Array.sum`             | ✅     | `int` and `float`  |
| `Array.mapi`            | ⏳     | Planned            |
| `Array.sortBy`          | ⏳     | Planned            |
| `Array.sort`            | ⏳     | Planned            |
| `Array.distinct`        | ⏳     | Planned            |

## `Option<'T>`

| Function              | Status | Notes |
| --------------------- | ------ | ----- |
| `Option.map`          | ✅     |       |
| `Option.bind`         | ✅     |       |
| `Option.filter`       | ✅     |       |
| `Option.defaultValue` | ✅     |       |
| `Option.defaultWith`  | ✅     |       |
| `Option.orElse`       | ✅     |       |
| `Option.orElseWith`   | ✅     |       |
| `Option.iter`         | ✅     |       |
| `Option.isSome`       | ✅     |       |
| `Option.isNone`       | ✅     |       |
| `Option.get`          | ✅     |       |
| `Option.toList`       | ✅     |       |
| `Option.toArray`      | ✅     |       |
| `Option.count`        | ✅     |       |
| `Option.contains`     | ✅     |       |

## `Result<'T,'E>`

| Function              | Status | Notes |
| --------------------- | ------ | ----- |
| `Result.map`          | ✅     |       |
| `Result.mapError`     | ✅     |       |
| `Result.bind`         | ✅     |       |
| `Result.isOk`         | ✅     |       |
| `Result.isError`      | ✅     |       |
| `Result.toOption`     | ✅     |       |
| `Result.defaultValue` | ✅     |       |
| `Result.defaultWith`  | ✅     |       |
| `Result.iter`         | ✅     |       |

## `String`

| Function                         | Status | Notes              |
| -------------------------------- | ------ | ------------------ |
| `String.length`                  | ✅     | `.Length` property |
| `String.concat`                  | ✅     | `+` operator       |
| `String.get`                     | ✅     | `.[i]`             |
| `String.indexOf`                 | ✅     |                    |
| `String.lastIndexOf`             | ✅     |                    |
| `String.contains`                | ✅     |                    |
| `String.startsWith`              | ✅     |                    |
| `String.endsWith`                | ✅     |                    |
| `String.toUpper`                 | ✅     |                    |
| `String.toLower`                 | ✅     |                    |
| `String.trim`                    | ✅     |                    |
| `String.trimStart`               | ✅     |                    |
| `String.trimEnd`                 | ✅     |                    |
| `String.replace`                 | ✅     |                    |
| `String.split` (char)            | ✅     |                    |
| `String.split` (string)          | ✅     |                    |
| `String.join`                    | ✅     |                    |
| `String.compare`                 | ✅     |                    |
| `String.isEmpty`                 | ✅     |                    |
| `char` → `string`                | ✅     |                    |
| `sprintf` / `printf` / `printfn` | ✅     | Format strings     |
| `$"string interpolation"`        | ✅     |                    |
| `String.padLeft`                 | ⏳     | Planned            |
| `String.padRight`                | ⏳     | Planned            |
| `String.substring`               | ⏳     | Planned            |
| `String.Format`                  | ⏳     | Planned            |

## `System.Math`

| Function                                | Status | Notes             |
| --------------------------------------- | ------ | ----------------- |
| `Math.Sin` / `Cos` / `Tan`              | ✅     |                   |
| `Math.Asin` / `Acos` / `Atan` / `Atan2` | ✅     |                   |
| `Math.Sqrt`                             | ✅     |                   |
| `Math.Pow`                              | ✅     | `**` operator     |
| `Math.Exp`                              | ✅     |                   |
| `Math.Log` / `Log10`                    | ✅     |                   |
| `Math.Abs`                              | ✅     | `int` and `float` |
| `Math.Min` / `Max`                      | ✅     | `int` and `float` |
| `Math.Floor` / `Ceiling` / `Round`      | ✅     |                   |
| `Math.Truncate`                         | ✅     |                   |
| `Math.Sign`                             | ✅     |                   |
| `Math.PI`                               | ✅     | Constant          |
| `Math.E`                                | ✅     | Constant          |

## Parsing

| Function                        | Status | Notes                |
| ------------------------------- | ------ | -------------------- |
| `int "42"` / `Int32.Parse`      | ✅     |                      |
| `float "3.14"` / `Double.Parse` | ✅     |                      |
| `Int32.TryParse`                | ⏳     | Returns `bool * int` |
| `Double.TryParse`               | ⏳     |                      |

## `Char`

| Function                        | Status | Notes   |
| ------------------------------- | ------ | ------- |
| Char comparison (`=`, `<`, `>`) | ✅     |         |
| Char → int (`int c`)            | ✅     |         |
| Char → string (`string c`)      | ✅     |         |
| `Char.IsLetter`                 | ⏳     | Planned |
| `Char.IsDigit`                  | ⏳     | Planned |
| `Char.IsWhiteSpace`             | ⏳     | Planned |
| `Char.ToUpper` / `ToLower`      | ⏳     | Planned |

## `Map<'K,'V>`

| Function               | Status | Notes                              |
| ---------------------- | ------ | ---------------------------------- |
| `Map.empty`            | ✅     | `int` keys only                    |
| `Map.add`              | ✅     | `int` keys only                    |
| `Map.find` / `tryFind` | ✅     | `int` keys only                    |
| `Map.containsKey`      | ✅     | `int` keys only                    |
| `Map.remove`           | ✅     | `int` keys only                    |
| Generic `Map<'K,'V>`   | ❌     | Needs vtable dispatch — Sprint 17+ |

## `Set<'T>`

| Function          | Status | Notes                  |
| ----------------- | ------ | ---------------------- |
| Generic `Set<'T>` | ❌     | Stub only — Sprint 17+ |

## `Seq<'T>`

| Function                  | Status | Notes                 |
| ------------------------- | ------ | --------------------- |
| `seq { }` / `IEnumerable` | ❌     | Planned (medium-term) |

## Operators

| Operator                        | Status | Notes                |
| ------------------------------- | ------ | -------------------- | ------------- |
| `+`, `-`, `*`, `/`, `%`         | ✅     | All numeric types    |
| `**` (power)                    | ✅     | `float`              |
| `=`, `<>`, `<`, `<=`, `>`, `>=` | ✅     | All comparable types |
| `&&`, `\|\|`, `not`             | ✅     | Boolean              |
| `&&&`, `\|\|\|`, `^^^`, `~~~`   | ✅     | Bitwise (int)        |
| `<<<`, `>>>`                    | ✅     | Bit shifts           |
| `@`                             | ✅     | List append          |
| `::`                            | ✅     | List cons            |
| `                               | >`     | ✅                   | Forward pipe  |
| `<                              | `      | ✅                   | Backward pipe |
| `>>`                            | ✅     | Function composition |
| `<<`                            | ✅     | Backward composition |
