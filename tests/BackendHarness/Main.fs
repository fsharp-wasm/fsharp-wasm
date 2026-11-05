module Main
open System
open WasmGc.Core.AST
open Lib
[<EntryPoint>]
let main argv =
    let only = if argv.Length > 0 then Some argv.[0] else None
    let run (name: string) (mk: unit -> WModule) =
        if only.IsNone || name.StartsWith only.Value then
            printfn "== %s" name
            try emitAll name (mk ())
            with ex -> printfn "  PIPELINE EXCEPTION: %s" (ex.Message.Split('\n').[0])
    for sc in Scenarios.all do
        let name, ctx = sc ()
        run name (fun () ->
            let funcs = ctx.Functions |> Seq.toList |> WasmGc.Runtime.ArraySort.specialize ctx |> WasmGc.Runtime.Runtime.fixClosureApply ctx.TypeDefs
            mkModule ctx.TypeDefs funcs)
    if only = Some "fuzzone" then
        // fuzzone <seed> <idx> : build ONE body, print it, then optimize it
        let g = Fuzz.Gen(int argv.[1])
        let k = int argv.[2]
        let mutable body = WExpr.Nop
        for j in 0 .. k do
            g.Reset()
            body <- g.I32(2 + j % 3, [ "a"; "b" ], [])
        printfn "SRC: %s" (Fuzz.show body)
        stdout.Flush()
        let o = WasmGc.Emit.Optimize.optimizeFuncBody body
        printfn "OPT: %s" (Fuzz.show o)
        exit 0
    if only = Some "closurefuzz" then
        let n = ClosureFuzz.generate (int argv.[1]) (int argv.[2]) (match System.Environment.GetEnvironmentVariable "FUZZ_DIR" with null | "" -> "out_cfuzz" | d -> d)
        printfn "generated %d closure programs" n
        exit 0
    if only = Some "fuzz" then
        let seed = if argv.Length > 1 then int argv.[1] else 1
        let count = if argv.Length > 2 then int argv.[2] else 300
        let n = Fuzz.generate seed count (match System.Environment.GetEnvironmentVariable "FUZZ_DIR" with null | "" -> "out_fuzz" | d -> d)
        printfn "generated %d functions (seed %d)" n seed
        exit 0
    if only = Some "validator" then exit (if FreeVarChecks.ValidatorChecks.run () then 0 else 1)
    if only = Some "optchecks" then exit (if FreeVarChecks.OptChecks.run () then 0 else 1)
    if only = Some "freevars" then exit (if FreeVarChecks.run () then 0 else 1)
    if only = Some "optable" then
        let outd = (match System.Environment.GetEnvironmentVariable "OUT_DIR" with null | "" -> "out" | d -> d) + "_ops"
        System.IO.Directory.CreateDirectory outd |> ignore
        for (name, m) in OpTable.build () do
            try
                let mm, _ = runPhases m
                System.IO.File.WriteAllText(System.IO.Path.Combine(outd, name + ".wat"), WasmGc.Emit.Wat.moduleToWat mm)
            with ex -> printfn "WAT-EXC %s: %s" name (ex.Message.Split('\n').[0])
            try
                let mm, _ = runPhases m
                System.IO.File.WriteAllBytes(System.IO.Path.Combine(outd, name + ".wasm"), WasmGc.Emit.Encoder.encodeModule (WasmGc.Emit.Emit.emitModule mm))
            with ex -> printfn "BIN-EXC %s: %s" name (ex.Message.Split('\n').[0])
        exit 0
    for sc in EmitScenarios.all do
        let name, m = sc ()
        run name (fun () -> m)
    0
