# WasmGC Backend

This document explains how F# language constructs are compiled to WebAssembly GC instructions.
It is intended for contributors who want to understand the codegen or extend the backend.

## Overview

WebAssembly GC adds first-class heap-allocated structs and arrays to WebAssembly.
The fsharp-wasm backend maps F# type system constructs to these primitives.

Key WasmGC instructions used:

| Instruction   | Purpose                                                     |
| ------------- | ----------------------------------------------------------- |
| `struct.new`  | Allocate a new struct on the GC heap                        |
| `struct.get`  | Read a struct field                                         |
| `struct.set`  | Write a mutable struct field                                |
| `array.new`   | Allocate a new GC-managed array                             |
| `array.get`   | Read an array element                                       |
| `array.set`   | Write an array element                                      |
| `array.len`   | Get array length                                            |
| `br_on_cast`  | Branch if a reference matches a type (used for DU dispatch) |
| `ref.cast`    | Cast a reference to a subtype                               |
| `call_ref`    | Call through a function reference (used for closures)       |
| `return_call` | Tail call (used for F# tail recursion, mutual recursion)    |

## Records

F# records compile to WasmGC structs with one field per record member.

**F# source:**

```fsharp
type Point = { X: float; Y: float }
let p = { X = 1.0; Y = 2.0 }
let x = p.X
```

**Generated WAT:**

```wat
(type $Point (struct
  (field $X f64)
  (field $Y f64)
))

;; Construction
struct.new $Point   ;; pops Y, X from stack, produces $Point ref

;; Field access
struct.get $Point $X   ;; pops $Point ref, produces f64
```

### Mutable Records

Mutable record fields use `struct.set`:

```fsharp
type Counter = { mutable Count: int }
let c = { Count = 0 }
c.Count <- c.Count + 1
```

```wat
(type $Counter (struct (field $Count (mut i32))))

struct.set $Counter $Count   ;; pops value and $Counter ref
```

## Discriminated Unions

DUs compile to a struct hierarchy: a base struct with a tag field, and one subtype per case.

**F# source:**

```fsharp
type Shape =
    | Circle of radius: float
    | Rectangle of width: float * height: float
    | Point
```

**Generated WAT:**

```wat
(type $Shape (struct (field $tag i32)))
(type $Shape_Circle (sub $Shape (struct
  (field $tag i32)
  (field $radius f64)
)))
(type $Shape_Rectangle (sub $Shape (struct
  (field $tag i32)
  (field $width f64)
  (field $height f64)
)))
;; Point has no data fields, uses the base $Shape struct directly
```

### Pattern Matching

Pattern matching on DUs uses `br_on_cast` for efficient type dispatch:

```fsharp
match shape with
| Circle r -> r * r * System.Math.PI
| Rectangle(w, h) -> w * h
| Point -> 0.0
```

```wat
block $match_end (result f64)
  block $case_rect
    block $case_point
      local.get $shape      ;; push the DU value
      br_on_cast $case_point $Shape $Shape    ;; if Point, jump to $case_point
      br_on_cast $case_rect $Shape $Shape_Rectangle  ;; if Rect, jump
      ;; Must be Circle
      ref.cast $Shape_Circle
      struct.get $Shape_Circle $radius
      ;; ... * Math.PI ...
      br $match_end
    end
    ;; Point case
    f64.const 0.0
    br $match_end
  end
  ;; Rectangle case
  struct.get $Shape_Rectangle $width
  ;; ...
end
```

## Closures

Closures compile to a `$AnyFn` struct hierarchy. The base struct holds a function reference;
each closure subtype adds fields for captured variables.

**F# source:**

```fsharp
let adder n = fun x -> x + n
let add5 = adder 5
```

**Generated WAT:**

```wat
;; Base type (always index 0)
(type $AnyFn (struct (field $fn (ref func))))

;; Specialized closure for adder's returned function
(type $AnyFn_adder_closure (sub $AnyFn (struct
  (field $fn (ref func))
  (field $n i32)            ;; captured variable
)))

;; The closure function (takes AnyFn ref + arg)
(func $adder_closure_impl (param $self (ref $AnyFn)) (param $x i32) (result i32)
  local.get $self
  ref.cast $AnyFn_adder_closure
  struct.get $AnyFn_adder_closure $n     ;; get captured n
  local.get $x
  i32.add
)

;; Calling a closure uses call_ref
(call_ref $closure_type (local.get $fn_ref) (local.get $arg))
```

## Lists

Lists are a linked-list struct hierarchy with `$ListBase` at the root (always index 2).

```wat
;; Empty list = null ref to $ListBase
(type $ListBase (struct))

;; Cons cell
(type $ListCons_i32 (sub $ListBase (struct
  (field $head i32)
  (field $tail (ref null $ListBase))
)))
```

F# list operations (`List.map`, `List.filter`, `List.fold`, etc.) are inlined as WasmGC
loops that traverse the cons-cell chain.

## Strings

Strings are represented as GC-managed arrays of UTF-16 code units (type index 1):

```wat
(type $WasmStr (array i32))   ;; default mode
;; or with WASMGC_STRING_MODE=i16:
(type $WasmStr (array i16))
```

String literals are stored in the Wasm data section and loaded at module initialization.

String operations (35+) are inlined by `WasmGcReplacements.fs`:

- `String.length` → `array.len`
- `String.get` → `array.get`
- `String.concat` → allocate new array, copy both halves
- `String.indexOf` → linear scan loop
- `String.split` → scan for delimiter, collect into list of arrays
- `String.toUpper` / `String.toLower` → character-by-character transformation
- `sprintf` / `$"..."` → assembled from format parts

## Arrays

F# arrays map directly to WasmGC typed arrays:

```wat
;; int array
(type $Array_i32 (array (mut i32)))

;; struct array
(type $Array_Point (array (mut (ref null $Point))))
```

## Options

`Option<'T>` uses a zero-overhead representation:

- If `'T` is a reference type: `None = null ref`, `Some x = the ref itself` (no wrapper struct)
- If `'T` is a value type (`int`, `float`, etc.): a nullable wrapper struct

```wat
;; Option<Point> — nullable ref, no allocation for None
;; None  = (ref.null $Point)
;; Some p = p   (the Point ref directly)

;; Option<int> — struct wrapper needed
(type $OptionInt (struct (field $hasValue i32) (field $value i32)))
```

## Generics and Monomorphization

F# generics are eliminated via demand-driven monomorphization. Each generic function is
specialized for its concrete type arguments at each call site.

```fsharp
let identity<'T> (x: 'T) = x

identity<int> 42      // → specialized identity_i32
identity<float> 3.14  // → specialized identity_f64
```

The monomorphization system:

1. Detects generic function calls
2. Checks the cache for an existing specialization
3. If not cached, re-compiles the function body with concrete types substituted
4. Provides the specialization to subsequent calls

Cross-file generics are supported via a `(Compiler * MemberDecl)` registry.

## Tail Calls

F# tail-recursive functions use Wasm's native `return_call` instruction:

```fsharp
let rec sum acc = function
    | [] -> acc
    | x :: rest -> sum (acc + x) rest
```

```wat
(func $sum (param $acc i32) (param $list (ref null $ListBase)) (result i32)
  ;; ...match on list...
  ;; tail-recursive case:
  return_call $sum   ;; zero-cost tail call
)
```

Mutual recursion between functions is handled transparently — `return_call` handles
arbitrary call chains without stack buildup.

## FFI Imports

Host functions are imported via `[<Import>]` attributes:

```fsharp
[<Import("sin", "Math")>]
let mathSin (x: float) : float = nativeOnly
```

This registers an import declaration in the Wasm module header:

```wat
(import "Math" "sin" (func $Math_sin (param f64) (result f64)))
```

## Binary Encoding

The `WasmGcEncoder.fs` module encodes the IR directly to binary `.wasm` format:

- **LEB128 encoding** for all integers
- **Type section** (`0x01`) — GC struct/array/func types
- **Import section** (`0x02`) — FFI imports
- **Function section** (`0x03`) — function type indices
- **Export section** (`0x07`) — exported function names
- **Code section** (`0x0A`) — function bodies with locals
- **Data section** (`0x0B`) — string literal data

GC type opcodes follow the WasmGC MVP specification:

- `(array T)` → `0x5E`
- `(struct ...)` → `0x5F`
- `i16` (packed) → `0x79`
- `(sub ...)` → `0x50`
