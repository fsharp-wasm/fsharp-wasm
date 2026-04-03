/// WasmGc intermediate representation types.
/// Layer 2 (WasmIR — high-level typed IR) and Layer 3 (WASM instructions).
///
/// Design principles:
///   - Every expression carries a concrete (monomorphized) WASM type
///   - A-normal form: complex sub-expressions are let-bound
///   - Explicit join points for efficient decision-tree compilation
///   - Explicit tail calls for loop optimization
///   - No generics — everything is mono-typed
module rec Fable.AST.WasmGc

// ─────────────────────────────────────────────────────────────────
// Layer 2: WasmIR — our primary optimization IR
// ─────────────────────────────────────────────────────────────────

/// Concrete WASM value types (no generics).
[<RequireQualifiedAccess>]
type WType =
    | I32
    | I64
    | F32
    | F64
    /// Packed 16-bit integer — only valid as a WTypeDef.Array element type (i16 strings).
    /// Automatically uses array.get_s on read-back.
    | I16
    | Ref of typeIdx: int * nullable: bool
    | Func of args: WType list * results: WType list
    | Struct of fields: WField list
    | Array of elem: WType * mutable_: bool
    /// Used for statements / expressions that produce no value.
    | Void
    /// Externref (for JS interop bridge).
    | Externref
    /// i31ref — small unboxed integer on the GC heap.
    | I31ref
    /// Non-nullable (ref eq) — supertype of all GC-managed structs, arrays, and i31.
    /// Used for vtable method self-parameters that can receive any concrete type.
    /// Encoded as 0x64 0x6D in binary.
    | EqRef

and WField =
    {
        Name: string
        Type: WType
        Mutable: bool
    }

// ─────────────────────────────────────────────────────────────────
// Stable key helpers on WType (used by registries — no sprintf "%A")
// ─────────────────────────────────────────────────────────────────

/// Stable, human-readable string key for a WType.
/// Used as dictionary keys in type registries — never relies on sprintf "%A".
[<AutoOpen>]
module WTypeKeys =
    let rec wTypeKey (t: WType) =
        match t with
        | WType.I32 -> "i32"
        | WType.I64 -> "i64"
        | WType.F32 -> "f32"
        | WType.F64 -> "f64"
        | WType.I16 -> "i16"
        | WType.Void -> "void"
        | WType.Externref -> "extern"
        | WType.I31ref -> "i31"
        | WType.EqRef -> "eqref"
        | WType.Ref(idx, false) -> $"ref{idx}"
        | WType.Ref(idx, true) -> $"refnull{idx}"
        | WType.Func(ps, rs) ->
            let pk = ps |> List.map wTypeKey |> String.concat ","
            let rk = rs |> List.map wTypeKey |> String.concat ","
            $"fn({pk})->({rk})"
        | WType.Struct fields ->
            let fk = fields |> List.map (fun f -> $"{f.Name}:{wTypeKey f.Type}") |> String.concat ";"
            $"struct{{{fk}}}"
        | WType.Array(elem, mut_) ->
            let m = if mut_ then "mut" else "imm"
            $"arr_{m}_{wTypeKey elem}"

    /// Join a list of WTypes into a single registry key string.
    let wTypesKey (ts: WType list) =
        ts |> List.map wTypeKey |> String.concat ","

/// Literal constants.
[<RequireQualifiedAccess>]
type WConst =
    | I32 of int
    | I64 of int64
    | F32 of float32
    | F64 of float
    | String of string
    | Null of WType
    | Unit

/// Expression — main IR node.
/// Every constructor that produces a value carries its result `WType`.
[<RequireQualifiedAccess>]
type WExpr =
    // ── Atoms ──────────────────────────────────────────────
    | Const of WConst
    | LocalGet of name: string * WType
    | GlobalGet of name: string * WType
    | GlobalSet of name: string * WExpr

    // ── Binding ────────────────────────────────────────────
    | Let of name: string * value: WExpr * body: WExpr
    | LetMut of name: string * value: WExpr * body: WExpr
    | Assign of name: string * value: WExpr

    // ── Functions ──────────────────────────────────────────
    | Call of func: string * args: WExpr list * WType
    | CallIndirect of funcRef: WExpr * args: WExpr list * WType
    /// Vtable dispatch: extract vtable from box[0], self from box[1], funcref from vtable[methodIdx].
    /// boxTypeIdx, vtableTypeIdx, funcTypeIdx must be registered type indices.
    | CallVirtual of obj: WExpr * boxTypeIdx: int * vtableTypeIdx: int * methodIdx: int * funcTypeIdx: int * args: WExpr list * WType
    /// ref.func $funcName — creates a typed function reference for vtable global initialization.
    | FuncRef of funcName: string

    // ── Struct operations (WASM GC) ───────────────────────
    | StructNew of typeIdx: int * fields: WExpr list * WType
    | StructGet of obj: WExpr * fieldIdx: int * WType
    | StructSet of obj: WExpr * fieldIdx: int * value: WExpr

    // ── Array operations (WASM GC) ────────────────────────
    | ArrayNew of typeIdx: int * size: WExpr * init: WExpr * WType
    | ArrayNewFixed of typeIdx: int * elems: WExpr list * WType
    | ArrayGet of arr: WExpr * idx: WExpr * WType
    | ArraySet of arr: WExpr * idx: WExpr * value: WExpr
    | ArrayLen of arr: WExpr
    // array.copy dst dstOff src srcOff len
    | ArrayCopy of dst: WExpr * dstOff: WExpr * src: WExpr * srcOff: WExpr * len: WExpr

    // ── Control flow ──────────────────────────────────────
    | If of cond: WExpr * then_: WExpr * else_: WExpr * WType
    | Loop of label: string * body: WExpr * WType
    | Break of label: string * value: WExpr option
    | Continue of label: string * args: WExpr list
    | Block of label: string * body: WExpr * WType
    | Return of WExpr option
    | Sequence of WExpr list
    | Nop

    // ── Join points (for decision tree optimization) ──────
    | JoinPoint of label: string * parms: (string * WType) list * body: WExpr * cont: WExpr * WType
    | JoinApply of label: string * args: WExpr list * WType

    // ── Pattern matching (lowered from Fable DecisionTree) ─
    | SwitchInt of scrutinee: WExpr * cases: (int * WExpr) list * default_: WExpr * WType
    | TagOf of obj: WExpr
    | Cast of obj: WExpr * targetType: WType
    /// ref.is_null — test whether a nullable ref is null; result is i32 (1=null, 0=non-null)
    | RefIsNull of obj: WExpr
    /// ref.test (ref $T) — type test; result is i32 (1 = is subtype, 0 = not)
    | RefTest of obj: WExpr * targetType: WType

    // ── Closures (before closure conversion) ──────────────
    | Closure of funcName: string * captures: WExpr list * WType
    | ClosureApply of closure: WExpr * args: WExpr list * funcTypeIdx: int * closureTypeIdx: int * captureCount: int * WType

    // ── Numeric operations ────────────────────────────────
    | Unary of WUnaryOp * operand: WExpr * WType
    | Binary of WBinaryOp * left: WExpr * right: WExpr * WType
    | Compare of WCompareOp * left: WExpr * right: WExpr

    // ── Tail calls (for stack-safe recursion / mutual recursion) ─────────
    /// return_call funcName args — exits current frame and jumps to callee.
    /// Semantics: return_call behaves like Call followed by Return, but without
    /// growing the call stack. Valid only when callee's result type == current function result.
    | TailCall of func: string * args: WExpr list * WType
    /// return_call_ref typeIdx — indirect tail call via closure code pointer.
    | TailCallRef of funcRef: WExpr * args: WExpr list * funcTypeIdx: int * closureTypeIdx: int * captureCount: int * WType

    // ── Error handling ────────────────────────────────────
    | TryCatch of body: WExpr * catch: (string * WExpr) option * finally_: WExpr option * WType
    | Throw of exn: WExpr

/// Unary numeric operations.
[<RequireQualifiedAccess>]
type WUnaryOp =
    | Neg
    | Abs
    | Sqrt
    | Ceil
    | Floor
    | Trunc
    | Nearest   // f64.nearest / f32.nearest (round to nearest even)
    | Not
    | Clz
    | Ctz
    | Popcnt
    | Eqz
    | WrapI64       // i64 → i32
    | ExtendI32S    // i32 → i64 (signed)
    | ExtendI32U    // i32 → i64 (unsigned)
    | TruncF64S     // f64 → i32/i64 (signed)
    | TruncF32S     // f32 → i32/i64 (signed)
    | ConvertI32S   // i32 → f32/f64 (signed)
    | ConvertI64S   // i64 → f32/f64 (signed)
    | PromoteF32    // f32 → f64
    | DemoteF64     // f64 → f32

/// Binary numeric operations.
[<RequireQualifiedAccess>]
type WBinaryOp =
    | Add
    | Sub
    | Mul
    | DivS
    | DivU
    | RemS
    | RemU
    | And
    | Or
    | Xor
    | Shl
    | ShrS
    | ShrU
    | Rotl
    | Rotr
    | Min   // f32.min / f64.min
    | Max   // f32.max / f64.max
    | CopySign  // f32.copysign / f64.copysign

/// Comparison operations.
[<RequireQualifiedAccess>]
type WCompareOp =
    | Eq
    | Ne
    | LtS
    | LtU
    | GtS
    | GtU
    | LeS
    | LeU
    | GeS
    | GeU
    | RefEq

// ─────────────────────────────────────────────────────────────────
// Top-level declarations
// ─────────────────────────────────────────────────────────────────

/// Top-level function/global/type declarations in WasmIR.
[<RequireQualifiedAccess>]
type WDecl =
    | Func of WFuncDecl
    | Global of WGlobalDecl
    | Type of WTypeDeclEntry
    | Import of WImport
    | Export of WExport
    | Data of WDataSegment

and WFuncDecl =
    {
        Name: string
        Params: (string * WType) list
        Result: WType
        Locals: (string * WType) list
        Body: WExpr
        Exported: bool
    }

and WGlobalDecl =
    {
        Name: string
        Type: WType
        Init: WExpr
        Mutable: bool
        Exported: bool
    }

and WTypeDeclEntry =
    {
        Name: string
        Def: WTypeDef
    }

and WImport =
    {
        ModuleName: string
        /// External name used in the Wasm import declaration (e.g. "wasmAdd").
        Name: string
        /// Internal identifier used for call resolution. Defaults to Name when empty.
        CallName: string
        Desc: WImportDesc
    }

and WImportDesc =
    | ImportFunc of parms: WType list * result: WType
    | ImportGlobal of WType * mutable_: bool
    | ImportMemory of min: int * max: int option
    | ImportTag of parms: WType list

and WExport =
    {
        InternalName: string
        ExportName: string
        Kind: WExportKind
    }

and WExportKind =
    | ExportFunc
    | ExportGlobal
    | ExportMemory
    | ExportTag

and WDataSegment =
    {
        Name: string
        Bytes: byte array
        Offset: int option // None = passive segment
    }

/// Type definitions for WASM GC structured types.
[<RequireQualifiedAccess>]
type WTypeDef =
    | Struct of fields: WField list * superType: int option
    | Array of elem: WType * mutable_: bool
    | Func of parms: WType list * result: WType

/// A complete WASM module in our IR.
type WModule =
    {
        Types: WTypeDeclEntry list
        Imports: WImport list
        Functions: WFuncDecl list
        Globals: WGlobalDecl list
        Exports: WExport list
        DataSegments: WDataSegment list
        Start: string option
    }

    static member Empty =
        {
            Types = []
            Imports = []
            Functions = []
            Globals = []
            Exports = []
            DataSegments = []
            Start = None
        }

// ─────────────────────────────────────────────────────────────────
// Layer 3: Low-level WASM instruction set
// ─────────────────────────────────────────────────────────────────

/// Raw WASM instructions — emitted by the WasmGcEmit phase and
/// consumed by the binary encoder.
[<RequireQualifiedAccess>]
type Instr =
    // ── Control ───────────────────────────────────────────
    | Unreachable
    | Nop
    | Block of blockType: BlockType * body: Instr list
    | Loop of blockType: BlockType * body: Instr list
    | If of blockType: BlockType * then_: Instr list * else_: Instr list
    | Br of labelIdx: int
    | BrIf of labelIdx: int
    | BrTable of labels: int list * default_: int
    | Return
    | Call of funcIdx: int
    | CallRef of typeIdx: int
    | CallIndirect of typeIdx: int * tableIdx: int
    | TryTable of blockType: BlockType * catches: Catch list * body: Instr list

    // ── Locals & globals ──────────────────────────────────
    | LocalGet of idx: int
    | LocalSet of idx: int
    | LocalTee of idx: int
    | GlobalGet of idx: int
    | GlobalSet of idx: int

    // ── Numeric (i32) ─────────────────────────────────────
    | I32Const of int
    | I32Add
    | I32Sub
    | I32Mul
    | I32DivS
    | I32DivU
    | I32RemS
    | I32RemU
    | I32And
    | I32Or
    | I32Xor
    | I32Shl
    | I32ShrS
    | I32ShrU
    | I32Rotl
    | I32Rotr
    | I32Eqz
    | I32Eq
    | I32Ne
    | I32LtS
    | I32LtU
    | I32GtS
    | I32GtU
    | I32LeS
    | I32LeU
    | I32GeS
    | I32GeU
    | I32WrapI64
    | I32TruncF64S
    | I32TruncF32S
    | I32Clz
    | I32Ctz
    | I32Popcnt

    // ── Numeric (i64) ─────────────────────────────────────
    | I64Const of int64
    | I64Add
    | I64Sub
    | I64Mul
    | I64DivS
    | I64DivU
    | I64RemS
    | I64RemU
    | I64And
    | I64Or
    | I64Xor
    | I64Shl
    | I64ShrS
    | I64ShrU
    | I64Rotl
    | I64Rotr
    | I64Eqz
    | I64Eq
    | I64Ne
    | I64LtS
    | I64LtU
    | I64GtS
    | I64GtU
    | I64LeS
    | I64LeU
    | I64GeS
    | I64GeU
    | I64ExtendI32S
    | I64ExtendI32U
    | I64TruncF64S
    | I64Clz
    | I64Ctz
    | I64Popcnt

    // ── Numeric (f32) ─────────────────────────────────────
    | F32Const of float32
    | F32Add
    | F32Sub
    | F32Mul
    | F32Div
    | F32Eq
    | F32Ne
    | F32Lt
    | F32Gt
    | F32Le
    | F32Ge
    | F32Neg
    | F32Abs
    | F32Sqrt
    | F32Ceil
    | F32Floor
    | F32Trunc
    | F32Nearest
    | F32Min
    | F32Max
    | F32CopySign
    | F32ConvertI32S
    | F32ConvertI64S
    | F32DemoteF64

    // ── Numeric (f64) ─────────────────────────────────────
    | F64Const of float
    | F64Add
    | F64Sub
    | F64Mul
    | F64Div
    | F64Eq
    | F64Ne
    | F64Lt
    | F64Gt
    | F64Le
    | F64Ge
    | F64Neg
    | F64Abs
    | F64Sqrt
    | F64Ceil
    | F64Floor
    | F64Trunc
    | F64Nearest
    | F64Min
    | F64Max
    | F64CopySign
    | F64ConvertI32S
    | F64ConvertI64S
    | F64PromoteF32

    // ── GC instructions ───────────────────────────────────
    | StructNew of typeIdx: int
    | StructNewDefault of typeIdx: int
    | StructGet of typeIdx: int * fieldIdx: int
    | StructGetS of typeIdx: int * fieldIdx: int
    | StructGetU of typeIdx: int * fieldIdx: int
    | StructSet of typeIdx: int * fieldIdx: int
    | ArrayNew of typeIdx: int
    | ArrayNewDefault of typeIdx: int
    | ArrayNewFixed of typeIdx: int * length: int
    | ArrayGet of typeIdx: int
    | ArrayGetS of typeIdx: int
    | ArrayGetU of typeIdx: int
    | ArraySet of typeIdx: int
    | ArrayLen
    | ArrayFill of typeIdx: int
    | ArrayCopy of dstTypeIdx: int * srcTypeIdx: int
    | RefNull of heapType: HeapType
    | RefIsNull
    | RefCast of refType: RefType
    | RefCastNullable of refType: RefType
    | RefTest of refType: RefType
    | RefTestNullable of refType: RefType
    | RefFunc of funcIdx: int
    | RefEq
    | ExternConvertAny
    | AnyConvertExtern
    | I31New
    | I31GetS
    | I31GetU

    // ── Tail calls ────────────────────────────────────────
    /// return_call funcIdx — tail call to a named function (same as call+return but reuses frame)
    | ReturnCall of funcIdx: int
    /// return_call_ref typeIdx — indirect tail call via function reference
    | ReturnCallRef of typeIdx: int

    // ── Exception handling ────────────────────────────────
    | Throw of tagIdx: int
    | ThrowRef

    // ── Misc ──────────────────────────────────────────────
    | Drop
    | Select of WType list option
    | MemorySize
    | MemoryGrow

/// Block type for structured control flow.
[<RequireQualifiedAccess>]
type BlockType =
    | Empty
    | Val of WType
    | TypeIdx of int

/// Try-table catch clauses.
[<RequireQualifiedAccess>]
type Catch =
    | Tag of tagIdx: int * labelIdx: int
    | TagRef of tagIdx: int * labelIdx: int
    | All of labelIdx: int
    | AllRef of labelIdx: int

/// Heap types for ref.null and casts.
[<RequireQualifiedAccess>]
type HeapType =
    | Func
    | Extern
    | Any
    | None_
    | NoExtern
    | NoFunc
    | Eq
    | I31
    | Struct
    | Array
    | TypeIdx of int

/// Reference type descriptor.
type RefType =
    {
        Nullable: bool
        HeapType: HeapType
    }

// ─────────────────────────────────────────────────────────────────
// Encoding helpers — WASM binary section IDs
// ─────────────────────────────────────────────────────────────────

/// WASM binary section identifiers.
[<RequireQualifiedAccess>]
module SectionId =
    [<Literal>]
    let Custom = 0uy

    [<Literal>]
    let Type = 1uy

    [<Literal>]
    let Import = 2uy

    [<Literal>]
    let Function = 3uy

    [<Literal>]
    let Table = 4uy

    [<Literal>]
    let Memory = 5uy

    [<Literal>]
    let Global = 6uy

    [<Literal>]
    let Export = 7uy

    [<Literal>]
    let Start = 8uy

    [<Literal>]
    let Element = 9uy

    [<Literal>]
    let Code = 10uy

    [<Literal>]
    let Data = 11uy

    [<Literal>]
    let DataCount = 12uy

    [<Literal>]
    let Tag = 13uy
