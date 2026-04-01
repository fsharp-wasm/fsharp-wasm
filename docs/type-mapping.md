# Type Mapping

This document describes how F# types map to WebAssembly GC types.

## Primitive Types

| F# Type              | WasmGC Type | Notes                        |
| -------------------- | ----------- | ---------------------------- |
| `int` / `int32`      | `i32`       | 32-bit signed integer        |
| `int64` / `int64`    | `i64`       | 64-bit signed integer        |
| `float32` / `single` | `f32`       | 32-bit IEEE float            |
| `float` / `double`   | `f64`       | 64-bit IEEE float            |
| `bool`               | `i32`       | `0` = false, `1` = true      |
| `char`               | `i32`       | UTF-16 code unit             |
| `unit`               | —           | No Wasm value (void)         |
| `byte` / `uint8`     | `i32`       | Stored as i32, masked        |
| `int16`              | `i32`       | Stored as i32, sign-extended |

## Reference Types

| F# Type                   | WasmGC Type            | Representation                                     |
| ------------------------- | ---------------------- | -------------------------------------------------- |
| `string`                  | `(ref $WasmStr)`       | `$WasmStr = (array i32)` — GC-managed UTF-16 array |
| `'T list`                 | `(ref null $ListBase)` | Linked list of `$ListCons_T` nodes                 |
| `'T[]`                    | `(ref $Array_T)`       | `$Array_T = (array (mut T))`                       |
| `Option<'T>` (ref type)   | `(ref null $T)`        | `null` = None, non-null = Some                     |
| `Option<'T>` (value type) | `(ref $OptionInt_T)`   | Struct with hasValue + value                       |
| `Result<'T,'E>`           | `(ref $Result_T_E)`    | Struct with tag + Ok/Error value                   |

## User-Defined Types

### Records

Each record type generates a WasmGC struct type:

| F#                                             | WasmGC                                                              |
| ---------------------------------------------- | ------------------------------------------------------------------- |
| `type Point = { X: float; Y: float }`          | `(struct (field $X f64) (field $Y f64))`                            |
| `type Mutable = { mutable Count: int }`        | `(struct (field $Count (mut i32)))`                                 |
| `type Nested = { Inner: Point; Name: string }` | `(struct (field $Inner (ref $Point)) (field $Name (ref $WasmStr)))` |

### Discriminated Unions

DUs generate a base struct + one subtype per union case:

```fsharp
type Expr =
    | Num of int
    | Add of Expr * Expr
    | Var of string
```

| Type          | WasmGC                                                                                       |
| ------------- | -------------------------------------------------------------------------------------------- |
| `Expr` (base) | `(struct (field $tag i32))`                                                                  |
| `Expr.Num`    | `(sub $Expr (struct (field $tag i32) (field $value i32)))`                                   |
| `Expr.Add`    | `(sub $Expr (struct (field $tag i32) (field $left (ref $Expr)) (field $right (ref $Expr))))` |
| `Expr.Var`    | `(sub $Expr (struct (field $tag i32) (field $name (ref $WasmStr))))`                         |

Single-case DUs with data are zero-overhead — the inner value may be used directly depending on the context.

### Enums / Flags

F# enum/flag types with integer backing compile to plain `i32` — no struct allocation.

## Function Types

| F#                        | WasmGC                                                      |
| ------------------------- | ----------------------------------------------------------- |
| `int -> int`              | `(func (param i32) (result i32))`                           |
| `float -> float -> float` | `(func (param f64 f64) (result f64))`                       |
| `'a -> 'b -> 'c`          | Monomorphized: concrete types substituted at each call site |

### Closures

| F#                      | WasmGC                                                           |
| ----------------------- | ---------------------------------------------------------------- |
| Closure value           | `(ref $AnyFn)` — base struct with func ref + captured vars       |
| Closure type (specific) | `(sub $AnyFn (struct (field $fn (ref func)) [captured fields]))` |
| Closure call            | `call_ref $fn_type` — dispatch through func reference            |

## Collections in Detail

### `'T list`

```
$ListBase        = (struct)                  ← empty list = null ref to this
$ListCons_i32    = (sub $ListBase (struct
                     (field $head i32)
                     (field $tail (ref null $ListBase))
                   ))
```

Each concrete element type gets its own `$ListCons_T` subtype.

### `'T[]` (Array)

```
$Array_i32   = (array (mut i32))
$Array_f64   = (array (mut f64))
$Array_Point = (array (mut (ref null $Point)))
```

### `string`

```
$WasmStr = (array i32)          ← default (I32 mode, UTF-16 code units as i32)
$WasmStr = (array i16)          ← with WASMGC_STRING_MODE=i16 (packed UTF-16)
```

## Pre-Registered Type Indices

These types are always registered at fixed indices — changing their order would break the compiler:

| Index | Name        | Definition                                       |
| ----- | ----------- | ------------------------------------------------ |
| 0     | `$AnyFn`    | `(struct (field $fn (ref func)))` — closure base |
| 1     | `$WasmStr`  | `(array i32)` (or `i16`) — string                |
| 2     | `$ListBase` | `(struct)` — list base                           |

## Option Representation Detail

`Option<'T>` uses a nullable-ref optimization to avoid allocating a wrapper struct for reference-typed values:

| `'T`                                             | None                                       | Some x                               |
| ------------------------------------------------ | ------------------------------------------ | ------------------------------------ |
| Reference type (record, DU, list, array, string) | `ref.null T`                               | `ref T` (the value itself)           |
| Value type (int, float, bool)                    | Struct `{ hasValue = 0; value = default }` | Struct `{ hasValue = 1; value = x }` |

This means `None : Option<string>` allocates exactly zero bytes — it is a null reference.

## Null Handling

WasmGC uses typed null references (`ref null T`). The compiler ensures null safety by:

- Reference types that can be `None` use `(ref null T)` types
- Non-nullable references use `(ref T)` (no null allowed)
- Pattern matching on `Option` generates `ref.is_null` checks

## Type Abbreviations

Type abbreviations are always resolved to their underlying types at compile time:

```fsharp
type Name = string     // → $WasmStr everywhere
type Matrix = float[]  // → $Array_f64 everywhere
```

## Generic Constraints

Generic constraints (e.g., `'T when 'T : comparison`) are currently resolved by:

- Monomorphization with concrete types (int, float, string)
- For `int` keys: direct `i32.lt_s` / `i32.gt_s` comparison
- Generic `IComparable` dispatch via vtable (planned, Sprint 17+)
