/// WasmGc intermediate representation types.
/// Layer 2 (WasmIR — high-level typed IR) and Layer 3 (WASM instructions).
///
/// Design principles:
///   - Every expression carries a concrete (monomorphized) WASM type
///   - A-normal form: complex sub-expressions are let-bound
///   - Explicit join points for efficient decision-tree compilation
///   - Explicit tail calls for loop optimization
///   - No generics — everything is mono-typed
module rec WasmGc.Core.AST

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
    /// Packed 8-bit integer — only valid as a WTypeDef.Array element type (bool[] and byte[] under WASMGC_PACKED_BYTES=1).
    /// Reads back unsigned (array.get_u): 0..255.
    | I8
    | Ref of typeIdx: int * nullable: bool
    | Func of args: WType list * results: WType list
    | Struct of fields: WField list
    | Array of elem: WType * mutable_: bool
    /// Used for statements / expressions that produce no value.
    | Void
    /// Externref (for JS interop bridge).
    | Externref
    /// Non-nullable `(ref extern)`.  Only for import declarations, where the JS String Builtins prescribe it exactly.
    | ExternNonNull
    /// i31ref — small unboxed integer on the GC heap.
    | I31ref
    /// Non-nullable (ref eq) — supertype of all GC-managed structs, arrays, and i31.
    /// Used for vtable method self-parameters that can receive any concrete type.
    /// Encoded as 0x64 0x6D in binary.
    | EqRef
    /// Nullable anyref (ref null any) — supertype of all GC-managed references.
    /// Used for the $fsharp_exn_carrier global and exception catch variables.
    /// Encoded as 0x6E (single-byte heap type shorthand).
    | AnyRef

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
        | WType.I8 -> "i8"
        | WType.Void -> "void"
        | WType.Externref -> "extern"
        | WType.ExternNonNull -> "externnn"
        | WType.I31ref -> "i31"
        | WType.EqRef -> "eqref"
        | WType.AnyRef -> "anyref"
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

/// The element kind for a linear-memory load or store.
/// Determines which WASM instruction is emitted (e.g. i32.load8_u, f32.store).
[<RequireQualifiedAccess>]
type WMemKind =
    | Byte  // i32.load8_u / i32.store8  — result/param type is I32
    | I32   // i32.load   / i32.store
    | I64   // i64.load   / i64.store
    | F32   // f32.load   / f32.store
    | F64   // f64.load   / f64.store

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

    // ── Numeric operations ────────────────────────────────
    | Unary of WUnaryOp * operand: WExpr * WType
    | Binary of WBinaryOp * left: WExpr * right: WExpr * WType
    | Compare of WCompareOp * left: WExpr * right: WExpr

    // ── Closures (before closure conversion) ──────────────
    | Closure of funcName: string * captures: WExpr list * WType
    | ClosureApply of closure: WExpr * args: WExpr list * funcTypeIdx: int * closureTypeIdx: int * captureCount: int * WType

    // ── Tail calls (for stack-safe recursion / mutual recursion) ─────────
    /// return_call funcName args — exits current frame and jumps to callee.
    /// Semantics: return_call behaves like Call followed by Return, but without
    /// growing the call stack. Valid only when callee's result type == current function result.
    | TailCall of func: string * args: WExpr list * WType
    /// return_call_ref typeIdx — indirect tail call via closure code pointer.
    | TailCallRef of funcRef: WExpr * args: WExpr list * funcTypeIdx: int * closureTypeIdx: int * captureCount: int * WType

    // ── LIR closure dispatch (produced by Lower.fs, consumed by Emit.fs) ──
    //
    // CallRef and ReturnCallRef are the lowered form of ClosureApply/TailCallRef.
    // They are explicit about the calling convention:
    //   args.(0) = self (ref $AnyFn)     ← bound by Lower as Let($lo_clo_N, ...)
    //   args.(1..) = user arguments      ← non-void only
    //   codePtr = StructGet(self, 0)     ← extracted by Lower
    //
    // The emitter does:  args... codePtr call_ref funcTypeIdx
    // No local.tee, no $clo_apply_tmp, no emitter state.

    /// Lowered call_ref — self is args.(0), codePtr is the func ref expression.
    /// Produced by Lower.lowerClosureApply.
    | CallRef of funcTypeIdx: int * args: WExpr list * codePtr: WExpr * WType

    /// Lowered return_call_ref — same layout as CallRef but tail-calls.
    /// Produced by Lower.lowerTailCallRef.
    | ReturnCallRef of funcTypeIdx: int * args: WExpr list * codePtr: WExpr * WType

    // ── Error handling ────────────────────────────────────
    | TryCatch of body: WExpr * catch: (string * WExpr) option * finally_: WExpr option * WType
    | Throw of exn: WExpr

    // ── Linear memory (WasmGC + linear memory coexist in the same module) ────
    /// Load a value from linear memory at byte address (addr + offset).
    | MemLoad  of kind: WMemKind * offset: int * addr: WExpr
    /// Store a value to linear memory at byte address (addr + offset).
    | MemStore of kind: WMemKind * offset: int * addr: WExpr * value: WExpr
    /// memory.size — current number of 64KB pages; result is I32.
    | MemorySize
    /// memory.grow — grow linear memory by N pages; result is I32 (old size or -1).
    | MemoryGrow of pages: WExpr

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
    | TruncSatF64S  // f64 → i32/i64 (signed, saturating: NaN → 0, out of range → MIN/MAX; never traps)
    | TruncSatF32S  // f32 → i32/i64 (signed, saturating)
    | ConvertI32S   // i32 → f32/f64 (signed)
    | ConvertI64S   // i64 → f32/f64 (signed)
    | PromoteF32    // f32 → f64
    | DemoteF64     // f64 → f32
    | ReinterpretI32ToF32  // f32.reinterpret_i32 (bit-cast i32 → f32)
    | ReinterpretF32ToI32  // i32.reinterpret_f32 (bit-cast f32 → i32)
    | ReinterpretI64ToF64  // f64.reinterpret_i64 (bit-cast i64 → f64)
    | ReinterpretF64ToI64  // i64.reinterpret_f64 (bit-cast f64 → i64)

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

/// A module-level exception tag declaration.
/// WASM tags have a function type (params only, no results).
and WTagDecl =
    {
        Name: string
        ParamTypes: WType list
    }

/// A complete WASM module in our IR.
type WModule =
    {
        Types: WTypeDeclEntry list
        Imports: WImport list
        Functions: WFuncDecl list
        Globals: WGlobalDecl list
        Exports: WExport list
        DataSegments: WDataSegment list
        Tags: WTagDecl list
        Start: string option
        /// When true, emit a linear memory section (1 initial page) + export it as "memory".
        /// WasmGC and linear memory coexist fine — the engine allocates both independently.
        HasLinearMemory: bool
    }

    static member Empty =
        {
            Types = []
            Imports = []
            Functions = []
            Globals = []
            Exports = []
            DataSegments = []
            Tags = []
            Start = None
            HasLinearMemory = false
        }

// ─────────────────────────────────────────────────────────────────
// Layer 3: Low-level WASM instruction set
// ─────────────────────────────────────────────────────────────────

/// Raw WASM instructions — emitted by the Emit phase and
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
    | I32TruncSatF64S
    | I32TruncSatF32S
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
    | I64TruncSatF64S
    | I64TruncSatF32S
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
    | F32ReinterpretI32

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
    | F64ReinterpretI64
    | I32ReinterpretF32
    | I64ReinterpretF64

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

    // ── Linear memory load/store ──────────────────────────────────────────
    | I32Load    of align: int * offset: int  // i32.load
    | I64Load    of align: int * offset: int  // i64.load
    | F32Load    of align: int * offset: int  // f32.load
    | F64Load    of align: int * offset: int  // f64.load
    | I32Load8U  of align: int * offset: int  // i32.load8_u
    | I32Store   of align: int * offset: int  // i32.store
    | I64Store   of align: int * offset: int  // i64.store
    | F32Store   of align: int * offset: int  // f32.store
    | F64Store   of align: int * offset: int  // f64.store
    | I32Store8  of align: int * offset: int  // i32.store8

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
