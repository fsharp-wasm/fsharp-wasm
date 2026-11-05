module Lib
open System
open System.IO
open Fable
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Pipeline.Scope
module Lc = WasmGc.Runtime.Locals

let stubCompiler : ICompilerCore =
    { new ICompilerCore with
        member _.Options = Unchecked.defaultof<_>
        member _.CurrentFile = "test.fs"
        member _.LibraryDir = ""
        member _.TryGetEntity _ = None
        member _.Plugins = { MemberDeclarationPlugins = Map.empty }
        member _.TryGetPluginHelper() = None
        member _.IncrementCounter() = 0
        member _.AddLog(_, _, _, _, _) = () }

let newCtx () = Ctx.Create(stubCompiler)

let i32T = Fable.Type.Number(Fable.AST.NumberKind.Int32, Fable.NumberInfo.Empty)
let ident n t : Fable.Ident = { Name = n; Type = t; IsMutable = false; IsThisArgument = false; IsCompilerGenerated = false; Range = None; IsInlineIfLambda = false }
let id32 n = ident n i32T
let fn1 a r = Fable.Type.LambdaType(a, r)
let num (n: int) = Fable.Value(Fable.ValueKind.NumberConstant(Fable.NumberValue.Int32 n, Fable.NumberInfo.Empty), None)
let var (i: Fable.Ident) = Fable.IdentExpr i
let bin op l r = Fable.Operation(Fable.Binary(op, l, r), [], i32T, None)
let add = bin BinaryOperator.BinaryPlus
let mul = bin BinaryOperator.BinaryMultiply
let sub = bin BinaryOperator.BinaryMinus
let boolT = Fable.Type.Boolean
let eq l r = Fable.Operation(Fable.Binary(BinaryOperator.BinaryEqual, l, r), [], boolT, None)
let ite c t e = Fable.IfThenElse(c, t, e, None)
let app f args t = Fable.CurriedApply(f, args, t, None)

/// ---- Pipeline (mirrors Phases.runPipeline from Normalize onwards) ----
let carrier : WGlobalDecl = { Name = "$fsharp_exn_carrier"; Type = WType.AnyRef; Init = WExpr.Const(WConst.Null WType.AnyRef); Mutable = true; Exported = false }

let mkModule (types: seq<WTypeDeclEntry>) (funcs: WFuncDecl list) : WModule =
    { WModule.Empty with
        Types = Seq.toList types
        Functions = funcs
        Globals = [ carrier ]
        Imports = [ { ModuleName = "env"; Name = "consolePrint"; CallName = ""; Desc = ImportFunc([WType.Ref(StringTypeIdx, false)], WType.Void) } ]
        Tags = [ { Name = "$fsharp_exn"; ParamTypes = [] } ]
        Exports = funcs |> List.filter (fun f -> f.Exported) |> List.map (fun f -> { InternalName = f.Name; ExportName = f.Name; Kind = ExportFunc }) }

let runPhases (w: WModule) : WModule * WasmGc.Pipeline.Validator.ValidationError list =
    let n = WasmGc.Pipeline.Normalizer.normalizeModule w
    let l = WasmGc.Pipeline.Lower.lowerModule n
    let r = { l with Functions = List.map Lc.resolveLocals l.Functions }
    let errs = WasmGc.Pipeline.Validator.validate false (System.Collections.Generic.List<WTypeDeclEntry>(r.Types)) r.Functions
    let o = WasmGc.Emit.Optimize.optimizeModule r
    { o with Functions = List.map Lc.resolveLocals o.Functions }, errs

let outDir = match System.Environment.GetEnvironmentVariable "OUT_DIR" with null | "" -> "out" | d -> d

/// Returns (name, wasmPath, watPath). Writes binary via built-in Encoder AND wat via Wat.fs.
let emitAll (name: string) (w: WModule) =
    Directory.CreateDirectory outDir |> ignore
    let m, errs = runPhases w
    for e in errs do eprintfn "  [validator] %s %s: %s" e.FuncName e.NodeDesc e.Message
    let wat = WasmGc.Emit.Wat.moduleToWat m
    File.WriteAllText(Path.Combine(outDir, name + ".wat"), wat)
    let bytes = WasmGc.Emit.Encoder.encodeModule (WasmGc.Emit.Emit.emitModule m)
    File.WriteAllBytes(Path.Combine(outDir, name + ".wasm"), bytes)
