module Tests.Unit.EmitTests

open Expecto
open WasmGc.Core.AST
open WasmGc.Emit
open Tests.WasmTestHelper
open Tests.Snapshot.Framework

// ─────────────────────────────────────────────────────────────────────────────
// Minimal WModule factory
// ─────────────────────────────────────────────────────────────────────────────

let private func name ps result body : WFuncDecl =
    { Name = name; Params = ps; Result = result; Locals = []; Body = body; Exported = false }

let private exportedFunc name ps result body : WFuncDecl =
    { Name = name; Params = ps; Result = result; Locals = []; Body = body; Exported = true }

let private emptyModule : WModule = {
    Types = []; Imports = []; Functions = []; Globals = []
    Exports = []; DataSegments = []; Tags = []; Start = None; HasLinearMemory = false }

let private moduleWith (funcs: WFuncDecl list) : WModule =
    let exports =
        funcs |> List.filter (fun f -> f.Exported)
              |> List.map (fun f -> { ExportName = f.Name; InternalName = f.Name; Kind = ExportFunc })
    { emptyModule with Functions = funcs; Exports = exports }

// ─────────────────────────────────────────────────────────────────────────────
// EmitCtx / instruction-level tests
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let emitTests = testList "Emit / instruction lowering" [

    test "i32 constant → I32Const" {
        let m = moduleWith [func "f" [] WType.I32 (WExpr.Const(WConst.I32 42))]
        let wm = Emit.emitModule m
        let f = List.head wm.Functions
        Expect.equal f.Body [Instr.I32Const 42] "i32 42 → [I32Const 42]"
    }

    test "i32 add → I32Add" {
        let body = WExpr.Binary(WBinaryOp.Add,
                     WExpr.Const(WConst.I32 1),
                     WExpr.Const(WConst.I32 2), WType.I32)
        let m = moduleWith [func "f" [] WType.I32 body]
        let wm = Emit.emitModule m
        let f = List.head wm.Functions
        Expect.contains f.Body Instr.I32Add "add must emit I32Add"
    }

    test "LocalGet → LocalGet index" {
        let body = WExpr.LocalGet("x", WType.I32)
        let m = moduleWith [func "f" [("x", WType.I32)] WType.I32 body]
        let wm = Emit.emitModule m
        let f = List.head wm.Functions
        Expect.equal f.Body [Instr.LocalGet 0] "param x at index 0"
    }

    test "Let binding → LocalSet + body" {
        // let x = 5 in x + x
        let body = WExpr.Let("x", WExpr.Const(WConst.I32 5),
                     WExpr.Binary(WBinaryOp.Add, WExpr.LocalGet("x", WType.I32),
                                                  WExpr.LocalGet("x", WType.I32), WType.I32))
        let f = { func "f" [] WType.I32 body with Locals = [("x", WType.I32)] }
        let m = moduleWith [f]
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        Expect.contains ef.Body (Instr.I32Const 5) "init value 5"
        Expect.contains ef.Body (Instr.LocalSet 0)  "set x"
        Expect.contains ef.Body Instr.I32Add         "add in body"
    }

    test "If → If block with then/else branches" {
        let body = WExpr.If(WExpr.Const(WConst.I32 1),
                     WExpr.Const(WConst.I32 10),
                     WExpr.Const(WConst.I32 20),
                     WType.I32)
        let m = moduleWith [func "f" [] WType.I32 body]
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        let hasIf = ef.Body |> List.exists (function Instr.If _ -> true | _ -> false)
        Expect.isTrue hasIf "if expr must emit If instruction"
    }

    test "Call to known function → Call funcIdx" {
        let callee = func "callee" [] WType.I32 (WExpr.Const(WConst.I32 1))
        let caller = func "caller" [] WType.I32 (WExpr.Call("callee", [], WType.I32))
        let m = moduleWith [callee; caller]
        let wm = Emit.emitModule m
        let callerFunc = wm.Functions |> List.find (fun f -> f.Name = "caller")
        let hasCall = callerFunc.Body |> List.exists (function Instr.Call _ -> true | _ -> false)
        Expect.isTrue hasCall "Call to known function must emit Call instruction"
    }

    test "Nop → empty instruction list" {
        let m = moduleWith [func "f" [] WType.Void WExpr.Nop]
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        Expect.equal ef.Body [] "Nop produces no instructions"
    }

    test "Sequence drops intermediate void results" {
        // [call_void; i32_lit] — call_void is void so no Drop needed
        let voidCall = WExpr.Call("sideEffect", [], WType.Void)
        let body = WExpr.Sequence [voidCall; WExpr.Const(WConst.I32 5)]
        let sideEffect = func "sideEffect" [] WType.Void WExpr.Nop
        let caller = func "f" [] WType.I32 body
        let m = moduleWith [sideEffect; caller]
        let wm = Emit.emitModule m
        let ef = wm.Functions |> List.find (fun f -> f.Name = "f")
        // Must NOT have a Drop before the I32Const (void call has no value to drop)
        let dropCount = ef.Body |> List.filter ((=) Instr.Drop) |> List.length
        Expect.equal dropCount 0 "void-returning call must not emit Drop"
    }

    test "Sequence drops intermediate i32 values" {
        // [pure_i32_expr; i32_result] — first is dropped
        let body = WExpr.Sequence [WExpr.Const(WConst.I32 0); WExpr.Const(WConst.I32 5)]
        let m = moduleWith [func "f" [] WType.I32 body]
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        Expect.contains ef.Body Instr.Drop "i32-returning non-last in sequence must emit Drop"
    }

    test "RefIsNull → RefIsNull instruction" {
        let f = func "f" [("r", WType.Ref(0, true))] WType.I32
                    (WExpr.RefIsNull(WExpr.LocalGet("r", WType.Ref(0, true))))
        let m = moduleWith [f]
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        Expect.contains ef.Body Instr.RefIsNull "refIsNull must emit RefIsNull instruction"
    }

    test "ArrayLen → ArrayLen instruction" {
        let arrTy = WType.Ref(0, false)
        let f = func "f" [("arr", arrTy)] WType.I32
                    (WExpr.ArrayLen(WExpr.LocalGet("arr", arrTy)))
        let m = { moduleWith [f] with
                    Types = [{ Name = "$IntArr"; Def = WTypeDef.Array(WType.I32, true) }] }
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        Expect.contains ef.Body Instr.ArrayLen "arrayLen must emit ArrayLen instruction"
    }

    test "Return → Return instruction" {
        let body = WExpr.Return(Some(WExpr.Const(WConst.I32 42)))
        let m = moduleWith [func "f" [] WType.I32 body]
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        Expect.contains ef.Body Instr.Return "return must emit Return instruction"
    }

    test "Break label → Br depth 0 (innermost block)" {
        let body = WExpr.Block("exit",
                     WExpr.Break("exit", None),
                     WType.Void)
        let m = moduleWith [func "f" [] WType.Void body]
        let wm = Emit.emitModule m
        let ef = List.head wm.Functions
        let hasBr = ef.Body |> List.exists (function
            | Instr.Block(_, inner) -> inner |> List.contains (Instr.Br 0)
            | _ -> false)
        Expect.isTrue hasBr "break to innermost label must emit Br 0"
    }

    test "Closure → RefFunc + StructNew" {
        // A zero-capture closure should emit: [ref.func $fn, struct.new $closureType]
        let closureType = { Name = "$clo"; Def = WTypeDef.Struct(
                              [{ Name = "code"; Type = WType.Ref(1, false); Mutable = false }], None) }
        let funcType = { Name = "$fn"; Def = WTypeDef.Func([WType.Ref(0, false)], WType.I32) }
        let body = WExpr.Closure("innerFn", [], WType.Ref(0, false))
        let innerFn = func "innerFn" [] WType.I32 (WExpr.Const(WConst.I32 1))
        let outerFn = func "f" [] (WType.Ref(0, false)) body
        let m = { moduleWith [innerFn; outerFn] with
                    Types = [closureType; funcType] }
        let wm = Emit.emitModule m
        let ef = wm.Functions |> List.find (fun f -> f.Name = "f")
        let hasRefFunc = ef.Body |> List.exists (function Instr.RefFunc _ -> true | _ -> false)
        let hasStructNew = ef.Body |> List.exists (function Instr.StructNew _ -> true | _ -> false)
        Expect.isTrue hasRefFunc "closure must emit RefFunc"
        Expect.isTrue hasStructNew "closure must emit StructNew"
    }
]

// ─────────────────────────────────────────────────────────────────────────────
// WAT text tests
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let watTests = testList "Emit / WAT text output" [

    test "simple function appears in WAT with correct name" {
        let m = moduleWith [exportedFunc "myFunc" [] WType.I32 (WExpr.Const(WConst.I32 42))]
        let wat = Wat.moduleToWat m
        Expect.stringContains wat "myFunc" "exported func name must appear in WAT"
        Expect.stringContains wat "i32.const 42" "constant 42 must appear as i32.const"
    }

    test "WAT contains (module ...) wrapper" {
        let m = emptyModule
        let wat = Wat.moduleToWat m
        Expect.stringContains wat "(module" "WAT output must start with (module"
    }

    test "exported function appears in export section" {
        let m = moduleWith [exportedFunc "answer" [] WType.I32 (WExpr.Const(WConst.I32 42))]
        let wat = Wat.moduleToWat m
        Expect.stringContains wat "(export \"answer\"" "export name must appear in WAT"
    }

    test "type definitions appear in WAT" {
        let m = { emptyModule with
                    Types = [{ Name = "$StrArr"; Def = WTypeDef.Array(WType.I32, true) }] }
        let wat = Wat.moduleToWat m
        Expect.stringContains wat "$StrArr" "type name must appear in WAT type section"
    }

    test "i32.add appears for Binary Add i32" {
        let body = WExpr.Binary(WBinaryOp.Add,
                     WExpr.Const(WConst.I32 1), WExpr.Const(WConst.I32 2), WType.I32)
        let m = moduleWith [func "f" [] WType.I32 body]
        let wat = Wat.moduleToWat m
        Expect.stringContains wat "i32.add" "Binary Add on i32 must emit i32.add in WAT"
    }

    test "WAT output is deterministic across multiple calls" {
        let m = moduleWith [exportedFunc "f" [("x", WType.I32)] WType.I32
                              (WExpr.LocalGet("x", WType.I32))]
        let wat1 = Wat.moduleToWat m
        let wat2 = Wat.moduleToWat m
        Expect.equal wat1 wat2 "WAT output must be deterministic"
    }

    watSnapshot "emit/simple-add-function"
        (moduleWith [exportedFunc "add"
                        [("a", WType.I32); ("b", WType.I32)] WType.I32
                        (WExpr.Binary(WBinaryOp.Add,
                            WExpr.LocalGet("a", WType.I32),
                            WExpr.LocalGet("b", WType.I32),
                            WType.I32))])
]

// ─────────────────────────────────────────────────────────────────────────────
// Binary encoding smoke tests
// ─────────────────────────────────────────────────────────────────────────────

[<Tests>]
let encoderTests = testList "Emit / binary encoder" [

    test "encoded binary starts with WASM magic + version" {
        let m = emptyModule
        let wm = Emit.emitModule m
        let bytes = Encoder.encodeModule wm
        // Magic: \0asm, Version: \1\0\0\0
        Expect.isGreaterThanOrEqual bytes.Length 8 "WASM binary must be at least 8 bytes"
        Expect.equal bytes.[0] 0x00uy "byte 0: magic 0x00"
        Expect.equal bytes.[1] 0x61uy "byte 1: magic 'a'"
        Expect.equal bytes.[2] 0x73uy "byte 2: magic 's'"
        Expect.equal bytes.[3] 0x6Duy "byte 3: magic 'm'"
        Expect.equal bytes.[4] 0x01uy "byte 4: version 1"
        Expect.equal bytes.[5] 0x00uy "byte 5: version"
        Expect.equal bytes.[6] 0x00uy "byte 6: version"
        Expect.equal bytes.[7] 0x00uy "byte 7: version"
    }

    test "empty module encodes to exactly 8 bytes (magic + version only)" {
        let m = emptyModule
        let wm = Emit.emitModule m
        let bytes = Encoder.encodeModule wm
        Expect.equal bytes.Length 8 "empty module = 8 bytes (magic + version, no sections)"
    }

    test "encoded binary is different for different function bodies" {
        let m1 = moduleWith [func "f" [] WType.I32 (WExpr.Const(WConst.I32 1))]
        let m2 = moduleWith [func "f" [] WType.I32 (WExpr.Const(WConst.I32 2))]
        let b1 = Encoder.encodeModule (Emit.emitModule m1)
        let b2 = Encoder.encodeModule (Emit.emitModule m2)
        Expect.notEqual b1 b2 "different function bodies must produce different binaries"
    }

    test "module with one exported function encodes export section" {
        let m = moduleWith [exportedFunc "hello" [] WType.Void WExpr.Nop]
        let bytes = Encoder.encodeModule (Emit.emitModule m)
        // Section ID 7 = export section
        let hasExportSection = bytes |> Array.exists ((=) 7uy)
        Expect.isTrue hasExportSection "module with export must contain export section (id=7)"
    }
]