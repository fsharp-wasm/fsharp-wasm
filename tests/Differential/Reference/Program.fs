/// Run every public static `unit -> int` function of an assembly on .NET and write
///   { name: { "ok": <int> } | { "error": "<message>" } }
/// as JSON.   Reference <assembly.dll> <out.json> [name-prefix]
module Reference

open System
open System.Collections.Generic
open System.IO
open System.Reflection
open System.Text.Json

/// F# module functions compile to public static methods; only `unit -> int` ones are comparable with a
/// wasm export of arity 0.
let private isCandidate (prefix: string) (m: MethodInfo) =
    m.IsStatic && m.IsPublic && not m.IsSpecialName && m.Name <> "main" && m.Name.StartsWith prefix
    && m.GetParameters().Length = 0 && m.ReturnType = typeof<int>

let private run (m: MethodInfo) : IDictionary<string, obj> =
    try
        dict [ "ok", box (m.Invoke(null, [||]) :?> int) ]
    with e ->
        let inner = match e with :? TargetInvocationException as t when not (isNull t.InnerException) -> t.InnerException | _ -> e
        dict [ "error", box $"{inner.GetType().Name}: {inner.Message}" ]

[<EntryPoint>]
let main argv =
    let dll, out = argv.[0], argv.[1]
    let prefix = if argv.Length > 2 then argv.[2] else ""
    let asm = Assembly.LoadFrom(Path.GetFullPath dll)

    let results =
        asm.GetTypes()
        |> Array.filter (fun t -> t.IsAbstract && t.IsSealed)   // F# modules
        |> Array.collect (fun t ->
            t.GetMethods(BindingFlags.Public ||| BindingFlags.Static ||| BindingFlags.DeclaredOnly)
            |> Array.filter (isCandidate prefix))
        |> Array.map (fun m -> m.Name, run m)
        |> Array.sortBy fst

    File.WriteAllText(out, JsonSerializer.Serialize(dict results, JsonSerializerOptions(WriteIndented = true)))
    let raised = results |> Array.filter (fun (_, r) -> r.ContainsKey "error") |> Array.length
    printfn "reference: %d functions (%d ok, %d raised)" results.Length (results.Length - raised) raised
    0
