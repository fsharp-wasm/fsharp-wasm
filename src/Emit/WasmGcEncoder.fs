/// WasmGc Binary Encoder: WasmModule → byte array (.wasm binary format).
/// Encodes all WASM sections following the spec: magic, version, type section,
/// function section, export section, code section, etc.
module Fable.Transforms.WasmGc.WasmGcEncoder

open Fable.AST.WasmGc

// ─────────────────────────────────────────────────────────────────
// LEB128 encoding
// ─────────────────────────────────────────────────────────────────

let encodeLEB128Unsigned (buf: ResizeArray<byte>) (value: uint32) =
    let mutable v = value
    let mutable more = true
    while more do
        let b = byte (v &&& 0x7Fu)
        v <- v >>> 7
        more <- v <> 0u
        buf.Add(if more then b ||| 0x80uy else b)

let encodeLEB128Signed (buf: ResizeArray<byte>) (value: int32) =
    let mutable v = value
    let mutable more = true
    while more do
        let b = byte (v &&& 0x7F)
        v <- v >>> 7 // arithmetic shift for signed
        let signBit = (b &&& 0x40uy) <> 0uy
        more <- not ((v = 0 && not signBit) || (v = -1 && signBit))
        buf.Add(if more then b ||| 0x80uy else b)

let encodeLEB128Signed64 (buf: ResizeArray<byte>) (value: int64) =
    let mutable v = value
    let mutable more = true
    while more do
        let b = byte (v &&& 0x7FL)
        v <- v >>> 7 // arithmetic shift for signed
        let signBit = (b &&& 0x40uy) <> 0uy
        more <- not ((v = 0L && not signBit) || (v = -1L && signBit))
        buf.Add(if more then b ||| 0x80uy else b)

// ─────────────────────────────────────────────────────────────────
// Primitive encoding
// ─────────────────────────────────────────────────────────────────

let encodeF32 (buf: ResizeArray<byte>) (value: float32) =
    let bytes = System.BitConverter.GetBytes(value)
    buf.AddRange(bytes)

let encodeF64 (buf: ResizeArray<byte>) (value: float) =
    let bytes = System.BitConverter.GetBytes(value)
    buf.AddRange(bytes)

let encodeString (buf: ResizeArray<byte>) (s: string) =
    let bytes = System.Text.Encoding.UTF8.GetBytes(s)
    encodeLEB128Unsigned buf (uint32 bytes.Length)
    buf.AddRange(bytes)

let encodeVector (buf: ResizeArray<byte>) (items: 'a list) (encodeItem: ResizeArray<byte> -> 'a -> unit) =
    encodeLEB128Unsigned buf (uint32 items.Length)
    for item in items do
        encodeItem buf item

// ─────────────────────────────────────────────────────────────────
// Value type encoding
// ─────────────────────────────────────────────────────────────────

let rec encodeValType (buf: ResizeArray<byte>) (ty: WType) =
    match ty with
    | WType.I32 -> buf.Add(0x7Fuy)
    | WType.I64 -> buf.Add(0x7Euy)
    | WType.F32 -> buf.Add(0x7Duy)
    | WType.F64 -> buf.Add(0x7Cuy)
    // Packed i16 type — only valid as an array element storage type.
    // Encoding: 0x79 (storagetype = packedi16) per the GC extension spec.
    | WType.I16 -> buf.Add(0x79uy)
    | WType.Ref(typeIdx, nullable) ->
        if nullable then
            buf.Add(0x63uy) // ref null typeIdx
        else
            buf.Add(0x64uy) // ref typeIdx
        encodeLEB128Signed buf typeIdx
    | WType.Externref -> buf.Add(0x6Fuy)
    | WType.I31ref ->
        buf.Add(0x64uy) // ref
        buf.Add(0x6Cuy) // i31
    | WType.EqRef ->
        buf.Add(0x64uy) // ref
        buf.Add(0x6Duy) // eq  (non-nullable eqref)
    | WType.Func _ ->
        buf.Add(0x64uy) // ref
        buf.Add(0x70uy) // func
    | WType.Void -> () // no encoding needed — 0 results
    | _ -> buf.Add(0x7Fuy) // fallback to i32

let encodeResultType (buf: ResizeArray<byte>) (types: WType list) =
    encodeLEB128Unsigned buf (uint32 types.Length)
    for ty in types do
        encodeValType buf ty

let encodeBlockType (buf: ResizeArray<byte>) (bt: BlockType) =
    match bt with
    | BlockType.Empty -> buf.Add(0x40uy)
    | BlockType.Val ty -> encodeValType buf ty
    | BlockType.TypeIdx idx -> encodeLEB128Signed buf idx

let encodeHeapType (buf: ResizeArray<byte>) (ht: HeapType) =
    match ht with
    | HeapType.Func -> buf.Add(0x70uy)
    | HeapType.Extern -> buf.Add(0x6Fuy)
    | HeapType.Any -> buf.Add(0x6Euy)
    | HeapType.None_ -> buf.Add(0x71uy)
    | HeapType.NoExtern -> buf.Add(0x72uy)
    | HeapType.NoFunc -> buf.Add(0x73uy)
    | HeapType.Eq -> buf.Add(0x6Duy)
    | HeapType.I31 -> buf.Add(0x6Cuy)
    | HeapType.Struct -> buf.Add(0x6Buy)
    | HeapType.Array -> buf.Add(0x6Auy)
    | HeapType.TypeIdx idx -> encodeLEB128Signed buf idx

let encodeRefType (buf: ResizeArray<byte>) (rt: RefType) =
    if rt.Nullable then
        buf.Add(0x63uy)
    else
        buf.Add(0x64uy)
    encodeHeapType buf rt.HeapType

// ─────────────────────────────────────────────────────────────────
// Instruction encoding
// ─────────────────────────────────────────────────────────────────

let rec encodeInstr (buf: ResizeArray<byte>) (instr: Instr) =
    match instr with
    // ── Control ───────────────────────────────────────────
    | Instr.Unreachable -> buf.Add(0x00uy)
    | Instr.Nop -> buf.Add(0x01uy)

    | Instr.Block(bt, body) ->
        buf.Add(0x02uy)
        encodeBlockType buf bt
        for i in body do encodeInstr buf i
        buf.Add(0x0Buy) // end

    | Instr.Loop(bt, body) ->
        buf.Add(0x03uy)
        encodeBlockType buf bt
        for i in body do encodeInstr buf i
        buf.Add(0x0Buy) // end

    | Instr.If(bt, then_, else_) ->
        buf.Add(0x04uy)
        encodeBlockType buf bt
        for i in then_ do encodeInstr buf i
        if not (List.isEmpty else_) then
            buf.Add(0x05uy) // else
            for i in else_ do encodeInstr buf i
        buf.Add(0x0Buy) // end

    | Instr.Br labelIdx ->
        buf.Add(0x0Cuy)
        encodeLEB128Unsigned buf (uint32 labelIdx)

    | Instr.BrIf labelIdx ->
        buf.Add(0x0Duy)
        encodeLEB128Unsigned buf (uint32 labelIdx)

    | Instr.BrTable(labels, default_) ->
        buf.Add(0x0Euy)
        encodeLEB128Unsigned buf (uint32 labels.Length)
        for l in labels do
            encodeLEB128Unsigned buf (uint32 l)
        encodeLEB128Unsigned buf (uint32 default_)

    | Instr.Return -> buf.Add(0x0Fuy)

    | Instr.ReturnCall funcIdx ->
        // return_call: 0x12 + funcidx
        buf.Add(0x12uy)
        encodeLEB128Unsigned buf (uint32 funcIdx)

    | Instr.ReturnCallRef typeIdx ->
        // return_call_ref: 0x15 + typeidx (tail call via function reference)
        buf.Add(0x15uy)
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.Call funcIdx ->
        buf.Add(0x10uy)
        encodeLEB128Unsigned buf (uint32 funcIdx)

    | Instr.CallRef typeIdx ->
        buf.Add(0x14uy)
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.CallIndirect(typeIdx, tableIdx) ->
        buf.Add(0x11uy)
        encodeLEB128Unsigned buf (uint32 typeIdx)
        encodeLEB128Unsigned buf (uint32 tableIdx)

    | Instr.TryTable(bt, catches, body) ->
        buf.Add(0x1Fuy)
        encodeBlockType buf bt
        encodeLEB128Unsigned buf (uint32 catches.Length)
        for c in catches do
            encodeCatch buf c
        for i in body do encodeInstr buf i
        buf.Add(0x0Buy) // end

    // ── Locals & globals ──────────────────────────────────
    | Instr.LocalGet idx ->
        buf.Add(0x20uy)
        encodeLEB128Unsigned buf (uint32 idx)

    | Instr.LocalSet idx ->
        buf.Add(0x21uy)
        encodeLEB128Unsigned buf (uint32 idx)

    | Instr.LocalTee idx ->
        buf.Add(0x22uy)
        encodeLEB128Unsigned buf (uint32 idx)

    | Instr.GlobalGet idx ->
        buf.Add(0x23uy)
        encodeLEB128Unsigned buf (uint32 idx)

    | Instr.GlobalSet idx ->
        buf.Add(0x24uy)
        encodeLEB128Unsigned buf (uint32 idx)

    // ── i32 ───────────────────────────────────────────────
    | Instr.I32Const n ->
        buf.Add(0x41uy)
        encodeLEB128Signed buf n

    | Instr.I32Add -> buf.Add(0x6Auy)
    | Instr.I32Sub -> buf.Add(0x6Buy)
    | Instr.I32Mul -> buf.Add(0x6Cuy)
    | Instr.I32DivS -> buf.Add(0x6Duy)
    | Instr.I32DivU -> buf.Add(0x6Euy)
    | Instr.I32RemS -> buf.Add(0x6Fuy)
    | Instr.I32RemU -> buf.Add(0x70uy)
    | Instr.I32And -> buf.Add(0x71uy)
    | Instr.I32Or -> buf.Add(0x72uy)
    | Instr.I32Xor -> buf.Add(0x73uy)
    | Instr.I32Shl -> buf.Add(0x74uy)
    | Instr.I32ShrS -> buf.Add(0x75uy)
    | Instr.I32ShrU -> buf.Add(0x76uy)
    | Instr.I32Rotl -> buf.Add(0x77uy)
    | Instr.I32Rotr -> buf.Add(0x78uy)
    | Instr.I32Eqz -> buf.Add(0x45uy)
    | Instr.I32Eq -> buf.Add(0x46uy)
    | Instr.I32Ne -> buf.Add(0x47uy)
    | Instr.I32LtS -> buf.Add(0x48uy)
    | Instr.I32LtU -> buf.Add(0x49uy)
    | Instr.I32GtS -> buf.Add(0x4Auy)
    | Instr.I32GtU -> buf.Add(0x4Buy)
    | Instr.I32LeS -> buf.Add(0x4Cuy)
    | Instr.I32LeU -> buf.Add(0x4Duy)
    | Instr.I32GeS -> buf.Add(0x4Euy)
    | Instr.I32GeU -> buf.Add(0x4Fuy)
    | Instr.I32WrapI64 -> buf.Add(0xA7uy)
    | Instr.I32TruncF64S -> buf.Add(0xAAuy)
    | Instr.I32TruncF32S -> buf.Add(0xA8uy)
    | Instr.I32Clz -> buf.Add(0x67uy)
    | Instr.I32Ctz -> buf.Add(0x68uy)
    | Instr.I32Popcnt -> buf.Add(0x69uy)

    // ── i64 ───────────────────────────────────────────────
    | Instr.I64Const n ->
        buf.Add(0x42uy)
        encodeLEB128Signed64 buf n

    | Instr.I64Add -> buf.Add(0x7Cuy)
    | Instr.I64Sub -> buf.Add(0x7Duy)
    | Instr.I64Mul -> buf.Add(0x7Euy)
    | Instr.I64DivS -> buf.Add(0x7Fuy)
    | Instr.I64DivU -> buf.Add(0x80uy)
    | Instr.I64RemS -> buf.Add(0x81uy)
    | Instr.I64RemU -> buf.Add(0x82uy)
    | Instr.I64And -> buf.Add(0x83uy)
    | Instr.I64Or -> buf.Add(0x84uy)
    | Instr.I64Xor -> buf.Add(0x85uy)
    | Instr.I64Shl -> buf.Add(0x86uy)
    | Instr.I64ShrS -> buf.Add(0x87uy)
    | Instr.I64ShrU -> buf.Add(0x88uy)
    | Instr.I64Rotl -> buf.Add(0x89uy)
    | Instr.I64Rotr -> buf.Add(0x8Auy)
    | Instr.I64Eqz -> buf.Add(0x50uy)
    | Instr.I64Eq -> buf.Add(0x51uy)
    | Instr.I64Ne -> buf.Add(0x52uy)
    | Instr.I64LtS -> buf.Add(0x53uy)
    | Instr.I64LtU -> buf.Add(0x54uy)
    | Instr.I64GtS -> buf.Add(0x55uy)
    | Instr.I64GtU -> buf.Add(0x56uy)
    | Instr.I64LeS -> buf.Add(0x57uy)
    | Instr.I64LeU -> buf.Add(0x58uy)
    | Instr.I64GeS -> buf.Add(0x59uy)
    | Instr.I64GeU -> buf.Add(0x5Auy)
    | Instr.I64ExtendI32S -> buf.Add(0xACuy)
    | Instr.I64ExtendI32U -> buf.Add(0xADuy)
    | Instr.I64TruncF64S -> buf.Add(0xB0uy)
    | Instr.I64Clz -> buf.Add(0x79uy)
    | Instr.I64Ctz -> buf.Add(0x7Auy)
    | Instr.I64Popcnt -> buf.Add(0x7Buy)

    // ── f32 ───────────────────────────────────────────────
    | Instr.F32Const f ->
        buf.Add(0x43uy)
        encodeF32 buf f

    | Instr.F32Add -> buf.Add(0x92uy)
    | Instr.F32Sub -> buf.Add(0x93uy)
    | Instr.F32Mul -> buf.Add(0x94uy)
    | Instr.F32Div -> buf.Add(0x95uy)
    | Instr.F32Eq -> buf.Add(0x5Buy)
    | Instr.F32Ne -> buf.Add(0x5Cuy)
    | Instr.F32Lt -> buf.Add(0x5Duy)
    | Instr.F32Gt -> buf.Add(0x5Euy)
    | Instr.F32Le -> buf.Add(0x5Fuy)
    | Instr.F32Ge -> buf.Add(0x60uy)
    | Instr.F32Neg -> buf.Add(0x8Cuy)
    | Instr.F32Abs -> buf.Add(0x8Buy)
    | Instr.F32Sqrt -> buf.Add(0x91uy)
    | Instr.F32Ceil -> buf.Add(0x8Duy)
    | Instr.F32Floor -> buf.Add(0x8Euy)
    | Instr.F32Trunc -> buf.Add(0x8Fuy)
    | Instr.F32Nearest -> buf.Add(0x90uy)
    | Instr.F32Min -> buf.Add(0x96uy)
    | Instr.F32Max -> buf.Add(0x97uy)
    | Instr.F32CopySign -> buf.Add(0x98uy)
    | Instr.F32ConvertI32S -> buf.Add(0xB2uy)
    | Instr.F32ConvertI64S -> buf.Add(0xB4uy)
    | Instr.F32DemoteF64 -> buf.Add(0xB6uy)

    // ── f64 ───────────────────────────────────────────────
    | Instr.F64Const f ->
        buf.Add(0x44uy)
        encodeF64 buf f

    | Instr.F64Add -> buf.Add(0xA0uy)
    | Instr.F64Sub -> buf.Add(0xA1uy)
    | Instr.F64Mul -> buf.Add(0xA2uy)
    | Instr.F64Div -> buf.Add(0xA3uy)
    | Instr.F64Eq -> buf.Add(0x61uy)
    | Instr.F64Ne -> buf.Add(0x62uy)
    | Instr.F64Lt -> buf.Add(0x63uy)
    | Instr.F64Gt -> buf.Add(0x64uy)
    | Instr.F64Le -> buf.Add(0x65uy)
    | Instr.F64Ge -> buf.Add(0x66uy)
    | Instr.F64Neg -> buf.Add(0x9Auy)
    | Instr.F64Abs -> buf.Add(0x99uy)
    | Instr.F64Sqrt -> buf.Add(0x9Fuy)
    | Instr.F64Ceil -> buf.Add(0x9Buy)
    | Instr.F64Floor -> buf.Add(0x9Cuy)
    | Instr.F64Trunc -> buf.Add(0x9Duy)
    | Instr.F64Nearest -> buf.Add(0x9Euy)
    | Instr.F64Min -> buf.Add(0xA4uy)
    | Instr.F64Max -> buf.Add(0xA5uy)
    | Instr.F64CopySign -> buf.Add(0xA6uy)
    | Instr.F64ConvertI32S -> buf.Add(0xB7uy)
    | Instr.F64ConvertI64S -> buf.Add(0xB9uy)
    | Instr.F64PromoteF32 -> buf.Add(0xBBuy)

    // ── GC instructions (0xFB prefix) ─────────────────────
    | Instr.StructNew typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 0u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.StructNewDefault typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 1u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.StructGet(typeIdx, fieldIdx) ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 2u
        encodeLEB128Unsigned buf (uint32 typeIdx)
        encodeLEB128Unsigned buf (uint32 fieldIdx)

    | Instr.StructGetS(typeIdx, fieldIdx) ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 3u
        encodeLEB128Unsigned buf (uint32 typeIdx)
        encodeLEB128Unsigned buf (uint32 fieldIdx)

    | Instr.StructGetU(typeIdx, fieldIdx) ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 4u
        encodeLEB128Unsigned buf (uint32 typeIdx)
        encodeLEB128Unsigned buf (uint32 fieldIdx)

    | Instr.StructSet(typeIdx, fieldIdx) ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 5u
        encodeLEB128Unsigned buf (uint32 typeIdx)
        encodeLEB128Unsigned buf (uint32 fieldIdx)

    | Instr.ArrayNew typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 6u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.ArrayNewDefault typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 7u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.ArrayNewFixed(typeIdx, length) ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 8u
        encodeLEB128Unsigned buf (uint32 typeIdx)
        encodeLEB128Unsigned buf (uint32 length)

    | Instr.ArrayGet typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 11u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.ArrayGetS typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 12u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.ArrayGetU typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 13u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.ArraySet typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 14u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.ArrayLen ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 15u

    | Instr.ArrayFill typeIdx ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 16u
        encodeLEB128Unsigned buf (uint32 typeIdx)

    | Instr.ArrayCopy(dstTypeIdx, srcTypeIdx) ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 17u
        encodeLEB128Unsigned buf (uint32 dstTypeIdx)
        encodeLEB128Unsigned buf (uint32 srcTypeIdx)

    | Instr.RefNull ht ->
        buf.Add(0xD0uy)
        encodeHeapType buf ht

    | Instr.RefIsNull -> buf.Add(0xD1uy)

    | Instr.RefFunc funcIdx ->
        buf.Add(0xD2uy)
        encodeLEB128Unsigned buf (uint32 funcIdx)

    | Instr.RefEq -> buf.Add(0xD3uy)

    | Instr.RefCast rt ->
        // WASM GC MVP binary format (proposals/gc/MVP.md §Binary Format):
        //   0xFB 0x16  ref.cast (ref ht)       → non-null cast, traps if wrong type or null
        //   0xFB 0x17  ref.cast (ref null ht)  → nullable cast, passes null through
        if rt.Nullable then
            buf.Add(0xFBuy); encodeLEB128Unsigned buf 0x17u   // ref.cast (ref null ht)
        else
            buf.Add(0xFBuy); encodeLEB128Unsigned buf 0x16u   // ref.cast (ref ht)
        encodeHeapType buf rt.HeapType

    | Instr.RefCastNullable rt ->
        // Always emit nullable cast variant
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 0x17u
        encodeHeapType buf rt.HeapType

    | Instr.RefTest rt ->
        // WASM GC MVP binary format (proposals/gc/MVP.md §Binary Format):
        //   0xFB 0x14  ref.test (ref ht)       → non-null test (returns 0 for null)
        //   0xFB 0x15  ref.test (ref null ht)  → nullable test (returns 1 for null if ht matches)
        if rt.Nullable then
            buf.Add(0xFBuy); encodeLEB128Unsigned buf 0x15u   // ref.test (ref null ht)
        else
            buf.Add(0xFBuy); encodeLEB128Unsigned buf 0x14u   // ref.test (ref ht)
        encodeHeapType buf rt.HeapType

    | Instr.RefTestNullable rt ->
        // Always emit nullable test variant
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 0x15u
        encodeHeapType buf rt.HeapType

    | Instr.ExternConvertAny ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 26u

    | Instr.AnyConvertExtern ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 27u

    | Instr.I31New ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 28u

    | Instr.I31GetS ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 29u

    | Instr.I31GetU ->
        buf.Add(0xFBuy); encodeLEB128Unsigned buf 30u

    // ── Exception handling ────────────────────────────────
    | Instr.Throw tagIdx ->
        buf.Add(0x08uy)
        encodeLEB128Unsigned buf (uint32 tagIdx)

    | Instr.ThrowRef -> buf.Add(0x0Auy)

    // ── Misc ──────────────────────────────────────────────
    | Instr.Drop -> buf.Add(0x1Auy)

    | Instr.Select types ->
        match types with
        | None | Some [] ->
            buf.Add(0x1Buy)
        | Some ts ->
            buf.Add(0x1Cuy)
            encodeLEB128Unsigned buf (uint32 ts.Length)
            for t in ts do encodeValType buf t

    | Instr.MemorySize ->
        buf.Add(0x3Fuy)
        buf.Add(0x00uy) // memory index

    | Instr.MemoryGrow ->
        buf.Add(0x40uy)
        buf.Add(0x00uy) // memory index

and encodeCatch (buf: ResizeArray<byte>) (catch: Catch) =
    match catch with
    | Catch.Tag(tagIdx, labelIdx) ->
        buf.Add(0x00uy)
        encodeLEB128Unsigned buf (uint32 tagIdx)
        encodeLEB128Unsigned buf (uint32 labelIdx)
    | Catch.TagRef(tagIdx, labelIdx) ->
        buf.Add(0x01uy)
        encodeLEB128Unsigned buf (uint32 tagIdx)
        encodeLEB128Unsigned buf (uint32 labelIdx)
    | Catch.All labelIdx ->
        buf.Add(0x02uy)
        encodeLEB128Unsigned buf (uint32 labelIdx)
    | Catch.AllRef labelIdx ->
        buf.Add(0x03uy)
        encodeLEB128Unsigned buf (uint32 labelIdx)

// ─────────────────────────────────────────────────────────────────
// Section encoding
// ─────────────────────────────────────────────────────────────────

/// Write a section: section_id + length + content bytes
let writeSection (buf: ResizeArray<byte>) (sectionId: byte) (content: ResizeArray<byte>) =
    if content.Count > 0 then
        buf.Add(sectionId)
        encodeLEB128Unsigned buf (uint32 content.Count)
        buf.AddRange(content)

/// Encode a struct field type (used in GC struct type section)
let encodeFieldType (buf: ResizeArray<byte>) (field: WField) =
    // storagetype = valtype (using the simple valtype encoding)
    encodeValType buf field.Type
    // mutability: 0x00 = immutable, 0x01 = mutable
    buf.Add(if field.Mutable then 0x01uy else 0x00uy)

/// Encode a single WC GC type definition entry
let encodeGcTypeDef (buf: ResizeArray<byte>) (def: WTypeDef) =
    match def with
    | WTypeDef.Struct(fields, superType) ->
        match superType with
        | Some superIdx ->
            // Sub type with explicit supertype: sub + one supertype + comptype
            buf.Add(0x50uy)                              // SUB (non-final)
            encodeLEB128Unsigned buf 1u                  // one supertype
            encodeLEB128Unsigned buf (uint32 superIdx)
        | None ->
            // No supertype but still non-final, so case structs can extend us.
            buf.Add(0x50uy)                              // SUB (non-final)
            encodeLEB128Unsigned buf 0u                  // zero supertypes
        // struct comptype: 0x5F + vec(fieldtype)
        buf.Add(0x5Fuy)
        encodeLEB128Unsigned buf (uint32 fields.Length)
        for f in fields do
            encodeFieldType buf f
    | WTypeDef.Array(elemType, mutable_) ->
        // GC array type: sub (non-final, no supertypes) + 0x5E + storagetype + mut
        buf.Add(0x50uy)                              // SUB (non-final)
        encodeLEB128Unsigned buf 0u                  // zero supertypes
        buf.Add(0x5Euy)                              // array comptype
        encodeValType buf elemType
        buf.Add(if mutable_ then 0x01uy else 0x00uy)
    | WTypeDef.Func(parms, result) ->
        // func type: 0x60 + vec(params) + vec(results)
        buf.Add(0x60uy)
        encodeResultType buf parms
        let results = match result with | WType.Void -> [] | t -> [t]
        encodeResultType buf results

/// Encode the Type Section (section 1) — both GC struct/array types and func types.
/// Each type is emitted as an individual entry (implicit singleton rec group).
/// Recursive DU types (e.g. Tree = Leaf | Node of Tree * Tree) work via nullable
/// ref types (ref null $Base) — they don't need explicit rec-group wrapping.
let encodeTypeSection (buf: ResizeArray<byte>) (structTypes: WTypeDeclEntry list) (funcTypes: (WType list * WType list) list) =
    let content = ResizeArray<byte>()
    let totalCount = structTypes.Length + funcTypes.Length
    encodeLEB128Unsigned content (uint32 totalCount)
    // 1. Struct/GC types first (occupying indices 0..N-1)
    for entry in structTypes do
        encodeGcTypeDef content entry.Def
    // 2. Function types (from call_indirect and closure dispatch)
    for (parms, results) in funcTypes do
        content.Add(0x60uy) // func type tag
        encodeResultType content parms
        encodeResultType content results
    writeSection buf SectionId.Type content

/// Encode the Function Section (section 3): maps func idx → type idx
let encodeFunctionSection (buf: ResizeArray<byte>) (funcTypeIndices: int list) =
    let content = ResizeArray<byte>()
    encodeLEB128Unsigned content (uint32 funcTypeIndices.Length)
    for idx in funcTypeIndices do
        encodeLEB128Unsigned content (uint32 idx)
    writeSection buf SectionId.Function content

/// Encode the Import Section (section 2): function and memory imports
let encodeImportSection (buf: ResizeArray<byte>) (imports: WImport list) (importTypeIndices: int list) =
    let content = ResizeArray<byte>()
    encodeLEB128Unsigned content (uint32 imports.Length)
    for imp, typeIdx in List.zip imports importTypeIndices do
        encodeString content imp.ModuleName
        encodeString content imp.Name
        match imp.Desc with
        | ImportFunc _ ->
            content.Add(0x00uy)  // func import kind
            encodeLEB128Unsigned content (uint32 typeIdx)
        | ImportGlobal(ty, mutable_) ->
            content.Add(0x03uy)
            encodeValType content ty
            content.Add(if mutable_ then 0x01uy else 0x00uy)
        | ImportMemory(min, max) ->
            content.Add(0x02uy)
            match max with
            | None ->
                content.Add(0x00uy)
                encodeLEB128Unsigned content (uint32 min)
            | Some m ->
                content.Add(0x01uy)
                encodeLEB128Unsigned content (uint32 min)
                encodeLEB128Unsigned content (uint32 m)
        | ImportTag _ ->
            content.Add(0x04uy)  // tag import kind
            encodeLEB128Unsigned content (uint32 typeIdx)
    writeSection buf SectionId.Import content

/// Encode the Global Section (section 6)
let encodeGlobalSection (buf: ResizeArray<byte>) (globals: WasmGcEmit.WasmGlobal list) =
    if globals.IsEmpty then () else
    let content = ResizeArray<byte>()
    encodeLEB128Unsigned content (uint32 globals.Length)
    for g in globals do
        encodeValType content g.Type
        content.Add(if g.Mutable then 0x01uy else 0x00uy)
        // Constant initializer expression
        for instr in g.Init do
            encodeInstr content instr
        content.Add(0x0Buy) // end
    writeSection buf SectionId.Global content

/// Encode the Export Section (section 7)
let encodeExportSection (buf: ResizeArray<byte>) (exports: WExport list) =
    let content = ResizeArray<byte>()
    encodeLEB128Unsigned content (uint32 exports.Length)
    for exp in exports do
        encodeString content exp.ExportName
        let kind =
            match exp.Kind with
            | ExportFunc -> 0x00uy
            | ExportGlobal -> 0x03uy
            | ExportMemory -> 0x02uy
            | ExportTag -> 0x04uy
        content.Add(kind)
        // Parse function index from InternalName (set by emitter)
        let idx =
            match System.Int32.TryParse(exp.InternalName) with
            | true, n -> n
            | false, _ -> 0
        encodeLEB128Unsigned content (uint32 idx)
    writeSection buf SectionId.Export content

/// Encode the Code Section (section 10): function bodies
let encodeCodeSection (buf: ResizeArray<byte>) (funcs: WasmGcEmit.WasmFunc list) =
    let content = ResizeArray<byte>()
    encodeLEB128Unsigned content (uint32 funcs.Length)

    for func in funcs do
        let bodyBuf = ResizeArray<byte>()

        // Encode locals: compress runs of same type
        let localGroups =
            func.LocalTypes
            |> List.fold (fun acc ty ->
                match acc with
                | (count, prevTy) :: rest when prevTy = ty -> (count + 1, prevTy) :: rest
                | _ -> (1, ty) :: acc
            ) []
            |> List.rev

        encodeLEB128Unsigned bodyBuf (uint32 localGroups.Length)
        for (count, ty) in localGroups do
            encodeLEB128Unsigned bodyBuf (uint32 count)
            encodeValType bodyBuf ty

        // Encode instructions
        for instr in func.Body do
            encodeInstr bodyBuf instr

        // End of function body
        bodyBuf.Add(0x0Buy)

        // Write body size + body
        encodeLEB128Unsigned content (uint32 bodyBuf.Count)
        content.AddRange(bodyBuf)

    writeSection buf SectionId.Code content

/// Encode the Name Custom Section (for debugging)
let encodeNameSection (buf: ResizeArray<byte>) (funcs: WasmGcEmit.WasmFunc list) (importCount: int) =
    let content = ResizeArray<byte>()

    // "name" section name
    encodeString content "name"

    // Subsection 1: function names
    let funcNameBuf = ResizeArray<byte>()
    encodeLEB128Unsigned funcNameBuf (uint32 funcs.Length)
    funcs |> List.iteri (fun i func ->
        // Function indices: imports occupy 0..importCount-1; our funcs start at importCount
        encodeLEB128Unsigned funcNameBuf (uint32 (importCount + i))
        encodeString funcNameBuf func.Name
    )
    // Write subsection 1 header
    content.Add(0x01uy) // function names subsection
    encodeLEB128Unsigned content (uint32 funcNameBuf.Count)
    content.AddRange(funcNameBuf)

    // Subsection 2: local names
    let localNameBuf = ResizeArray<byte>()
    // Count functions that have named locals (for now skip — we only have index-based locals)
    encodeLEB128Unsigned localNameBuf 0u
    content.Add(0x02uy)
    encodeLEB128Unsigned content (uint32 localNameBuf.Count)
    content.AddRange(localNameBuf)

    writeSection buf 0uy content // custom section = 0

/// Encode a declarative element segment (section 9) for func refs used with ref.func.
/// This is required to "declare" all functions that appear in ref.func instructions.
/// Format: kind=0x03 (declarative), reftype=0x70 (funcref), count, func-idx*
let encodeElementSection (buf: ResizeArray<byte>) (funcIdxs: int list) =
    if not (List.isEmpty funcIdxs) then
        let content = ResizeArray<byte>()
        // One element segment
        encodeLEB128Unsigned content 1u
        // Segment flags: 0x03 = declarative
        encodeLEB128Unsigned content 0x03u
        // Element kind: 0x00 = func refs (funcref = 0x70 omitted for kind 0x00)
        // Note: for flags=0x03, the format is: flags elemkind count (func-idx)*
        //   elemkind 0x00 = funcref
        content.Add(0x00uy)
        // Count of func indices
        encodeLEB128Unsigned content (uint32 funcIdxs.Length)
        for idx in funcIdxs do
            encodeLEB128Unsigned content (uint32 idx)
        writeSection buf SectionId.Element content

// ─────────────────────────────────────────────────────────────────
// Top-level: WasmModule → byte[]
// ─────────────────────────────────────────────────────────────────

/// Encode a complete WasmModule to a .wasm binary.
let encodeModule (wmod: WasmGcEmit.WasmModule) : byte array =
    let buf = ResizeArray<byte>()

    // Magic number: \0asm
    buf.Add(0x00uy); buf.Add(0x61uy); buf.Add(0x73uy); buf.Add(0x6Duy)
    // Version: 1
    buf.Add(0x01uy); buf.Add(0x00uy); buf.Add(0x00uy); buf.Add(0x00uy)

    // Section 1: Types (struct types first, then func types)
    let hasTypes = not (List.isEmpty wmod.StructTypes) || not (List.isEmpty wmod.FuncTypes)
    if hasTypes then
        encodeTypeSection buf wmod.StructTypes wmod.FuncTypes

    // Section 2: Imports (must come before functions section)
    if not (List.isEmpty wmod.Imports) then
        encodeImportSection buf wmod.Imports wmod.ImportTypeIndices

    // Section 3: Functions (type indices)
    if not (List.isEmpty wmod.FuncTypeIndices) then
        encodeFunctionSection buf wmod.FuncTypeIndices

    // Section 6: Globals
    if not (List.isEmpty wmod.Globals) then
        encodeGlobalSection buf wmod.Globals

    // Section 7: Exports
    if not (List.isEmpty wmod.Exports) then
        encodeExportSection buf wmod.Exports

    // Section 9: Element (declarative refs for ref.func)
    if not (List.isEmpty wmod.DeclaredFuncRefs) then
        encodeElementSection buf wmod.DeclaredFuncRefs

    // Section 10: Code (function bodies)
    if not (List.isEmpty wmod.Functions) then
        encodeCodeSection buf wmod.Functions

    // Custom section: Name (for debugging)
    if not (List.isEmpty wmod.Functions) then
        encodeNameSection buf wmod.Functions (List.length wmod.Imports)

    buf.ToArray()
