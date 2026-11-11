/// .NET side of the benchmark: runs every `bench_*` of Bench.fs and prints "name <checksum> <best ms>" per size.
module BenchProgram
open System
open System.Diagnostics
open System.Reflection

let sizes : (string * int) list =
    [ "bench_fib", 32; "bench_loop", 200000; "bench_sieve", 2000000; "bench_collatz", 300000; "bench_float", 5000000
      "bench_list", 1000000; "bench_array", 1000000; "bench_sort", 3000; "bench_tree", 100000; "bench_closure", 1000000
      "bench_string", 200000; "bench_record", 5000000 ]

[<EntryPoint>]
let main _ =
    let t = typeof<Bench.Tree>.DeclaringType
    for (name, n) in sizes do
        let m = t.GetMethod(name, BindingFlags.Public ||| BindingFlags.Static)
        let f = m.CreateDelegate(typeof<Func<int, int>>) :?> Func<int, int>
        let checksum = f.Invoke n                    // warm-up + checksum
        let mutable best = Double.MaxValue
        for _ in 1 .. 7 do
            let sw = Stopwatch.StartNew()
            f.Invoke n |> ignore
            best <- min best sw.Elapsed.TotalMilliseconds
        printfn "%s %d %.3f" name checksum best
    0
