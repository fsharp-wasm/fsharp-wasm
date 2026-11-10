/// Reference side of the differential test: run public static functions of an assembly on .NET with generated
/// inputs and write what happened as JSON, to be compared with the same functions compiled to wasm.
///
///   Reference <assembly.dll> <out.json> [name-prefix]        env: DIFF_CASES (default 300), DIFF_SEED (default 12345)
///
/// A function qualifies if all parameters are int / float / bool and the result is int / float / bool
/// (zero parameters are fine: one call).  Functions with parameters must be TOTAL and terminating for every
/// input — a stack overflow or an endless loop cannot be recovered from.  That is why they are opt-in by name
/// prefix (`prop_`) rather than picked up wholesale.
///
/// Encoding: int → JSON number, bool → 0 / 1, float → its IEEE bits as 16 hex digits (JSON has no NaN/∞).
module Reference

open System
open System.Collections.Generic
open System.IO
open System.Reflection
open System.Threading.Tasks
open System.Text.Json

type Kind = I | F | B

let private kindOf (t: Type) =
    if t = typeof<int> then Some I elif t = typeof<float> then Some F elif t = typeof<bool> then Some B else None

let private kindName = function I -> "int" | F -> "float" | B -> "bool"

// ── input generation ─────────────────────────────────────────────────────────

let private specialInts =
    [| 0; 1; -1; 2; -2; 3; 7; 10; 31; 32; 33; 63; 64; 100; 255; 256; 1000; 65535; 65536; -65536
       Int32.MaxValue; Int32.MinValue; Int32.MaxValue - 1; Int32.MinValue + 1 |]

let private specialFloats =
    [| 0.0; -0.0; 1.0; -1.0; 0.5; -0.5; 1.5; 2.5; -2.5; 3.14159; 1e-10; 1e10; 123456.789; -123456.789
       2147483647.0; -2147483648.0; 4294967296.0; Double.NaN; Double.PositiveInfinity; Double.NegativeInfinity |]

let private genInt (rnd: Random) =
    match rnd.Next 6 with
    | 0 | 1 -> specialInts.[rnd.Next specialInts.Length]
    | 2 | 3 -> rnd.Next(-100, 101)
    | _ -> rnd.Next(Int32.MinValue, Int32.MaxValue)

let private genFloat (rnd: Random) =
    match rnd.Next 6 with
    | 0 | 1 -> specialFloats.[rnd.Next specialFloats.Length]
    | 2 | 3 -> float (rnd.Next(-1000, 1001)) / 8.0                       // exactly representable
    | _ -> (rnd.NextDouble() - 0.5) * Math.Pow(10.0, float (rnd.Next(-5, 10)))

let private gen (rnd: Random) = function
    | I -> box (genInt rnd)
    | F -> box (genFloat rnd)
    | B -> box (rnd.Next 2 = 1)

/// Stable across runs and independent of which other functions exist.
let private seedFor (seed: int) (name: string) = name |> Seq.fold (fun h c -> h * 31 + int c) seed

/// Pairs / triples of the special values first (edge cases), then random combinations.
let private argumentSets (seed: int) (cases: int) (name: string) (kinds: Kind list) : obj[] list =
    let rnd = Random(seedFor seed name)
    match kinds with
    | [] -> [ [||] ]
    | _ ->
        let edge =
            match kinds with
            | [ I ] -> [ for v in specialInts -> [| box v |] ]
            | [ F ] -> [ for v in specialFloats -> [| box v |] ]
            | [ I; I ] -> [ for a in specialInts do for b in specialInts -> [| box a; box b |] ]
            | _ -> []
        let random = [ for _ in 1 .. cases -> kinds |> List.map (gen rnd) |> Array.ofList ]
        (edge @ random) |> List.truncate (max cases edge.Length)

// ── execution ────────────────────────────────────────────────────────────────

let private encode (v: obj) : obj =
    match v with
    | :? int as i -> box i
    | :? bool as b -> box (if b then 1 else 0)
    | :? float as f -> box (BitConverter.DoubleToInt64Bits(f).ToString("x16"))
    | _ -> failwithf "unexpected result %A" v

let private run (m: MethodInfo) (args: obj[]) : IDictionary<string, obj> =
    let task = Task.Run(fun () -> m.Invoke(null, args))
    let argsJson = args |> Array.map encode |> box
    try
        if not (task.Wait 2000) then dict [ "args", argsJson; "error", box "Timeout" ]
        else dict [ "args", argsJson; "ok", encode task.Result ]
    with e ->
        let rec inner (e: exn) = match e with
                                 | :? AggregateException | :? TargetInvocationException when not (isNull e.InnerException) -> inner e.InnerException
                                 | _ -> e
        let e = inner e
        dict [ "args", argsJson; "error", box (e.GetType().Name) ]

let private isCandidate (prefix: string) (m: MethodInfo) =
    m.IsStatic && m.IsPublic && not m.IsSpecialName && not m.IsGenericMethod && m.Name <> "main" && m.Name.StartsWith prefix
    && (m.GetParameters() |> Array.forall (fun p -> (kindOf p.ParameterType).IsSome))
    && (kindOf m.ReturnType).IsSome

[<EntryPoint>]
let main argv =
    let dll, out = argv.[0], argv.[1]
    let prefix = if argv.Length > 2 then argv.[2] else ""
    let env name (d: int) = match Environment.GetEnvironmentVariable name with | null | "" -> d | v -> int v
    let cases, seed = env "DIFF_CASES" 300, env "DIFF_SEED" 12345
    let asm = Assembly.LoadFrom(Path.GetFullPath dll)

    let functions =
        asm.GetTypes()
        |> Array.filter (fun t -> t.IsAbstract && t.IsSealed)   // F# modules
        |> Array.collect (fun t ->
            t.GetMethods(BindingFlags.Public ||| BindingFlags.Static ||| BindingFlags.DeclaredOnly)
            |> Array.filter (isCandidate prefix))
        |> Array.sortBy (fun m -> m.Name)
        |> Array.map (fun m ->
            let kinds = m.GetParameters() |> Array.map (fun p -> (kindOf p.ParameterType).Value) |> List.ofArray
            let results = argumentSets seed cases m.Name kinds |> List.map (run m) |> List.toArray
            m.Name, dict [ "params", box (kinds |> List.map kindName |> List.toArray)
                           "returns", box (kindName (kindOf m.ReturnType).Value)
                           "cases", box results ])

    File.WriteAllText(out, JsonSerializer.Serialize(dict functions, JsonSerializerOptions(WriteIndented = false)))
    let calls = functions |> Array.sumBy (fun (_, f) -> (f.["cases"] :?> IDictionary<string, obj>[]).Length)
    printfn "reference: %d functions, %d calls (seed %d)" functions.Length calls seed
    Environment.Exit 0   // a timed-out call may still be running on a pool thread
    0
