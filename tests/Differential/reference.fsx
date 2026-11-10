// Reference side of the differential test: run every public static `unit -> int` function of an assembly
// on .NET and write { name: { ok: <int> } | { error: "<message>" } } as JSON.
//
//   dotnet fsi reference.fsx <assembly.dll> <out.json> [name-prefix]
open System
open System.IO
open System.Reflection
open System.Text.Json

let args = fsi.CommandLineArgs |> Array.skip 1
let dll, out, prefix = args.[0], args.[1], (if args.Length > 2 then args.[2] else "")

// F# module functions compile to static methods; only `unit -> int` ones are comparable with a wasm export of arity 0.
let isCandidate (m: MethodInfo) =
    m.IsStatic && m.IsPublic && m.GetParameters().Length = 0 && m.ReturnType = typeof<int>
    && not m.IsSpecialName && m.Name <> "main" && m.Name.StartsWith prefix

let asm = Assembly.LoadFrom(Path.GetFullPath dll)
let results = Collections.Generic.SortedDictionary<string, obj>()

for t in asm.GetTypes() |> Array.filter (fun t -> t.IsAbstract && t.IsSealed) do   // F# modules
    for m in t.GetMethods(BindingFlags.Public ||| BindingFlags.Static ||| BindingFlags.DeclaredOnly) |> Array.filter isCandidate do
        results.[m.Name] <-
            try dict [ "ok", box (m.Invoke(null, [||]) :?> int) ]
            with e ->
                let inner = match e with :? TargetInvocationException as te when not (isNull te.InnerException) -> te.InnerException | _ -> e
                dict [ "error", box (inner.GetType().Name + ": " + inner.Message) ]

File.WriteAllText(out, JsonSerializer.Serialize(results, JsonSerializerOptions(WriteIndented = true)))
printfn "reference: %d functions (%d ok, %d raised)" results.Count
    (results.Values |> Seq.filter (fun v -> (v :?> Collections.Generic.IDictionary<string, obj>).ContainsKey "ok") |> Seq.length)
    (results.Values |> Seq.filter (fun v -> (v :?> Collections.Generic.IDictionary<string, obj>).ContainsKey "error") |> Seq.length)
