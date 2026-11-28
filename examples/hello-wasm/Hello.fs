module Hello

open System.Collections.Generic

// Public top-level functions become exports of the module.  A bool is an i32 on the other side (0 or 1).

let fibonacci (n: int) : int =
    let mutable a, b = 0, 1
    for _ in 1 .. n do
        let t = a + b
        a <- b
        b <- t
    a

let isPrime (n: int) : bool =
    if n < 2 then false
    else
        let mutable i = 2
        let mutable result = true
        while i * i <= n && result do
            if n % i = 0 then result <- false
            i <- i + 1
        result

/// F# with the usual tools: a list pipeline, compiled to WebAssembly GC.
let sumOfSquaresOfOdds (n: int) : int =
    [ 1 .. n ] |> List.filter (fun x -> x % 2 = 1) |> List.map (fun x -> x * x) |> List.sum

/// The collections of the .NET base library (Dictionary, HashSet, Stack, Queue, StringBuilder, comparers) are in the package FSharp.Wasm.Core,
/// which this project references: the number of different remainders of i * i modulo n.
let distinctSquaresModulo (n: int) : int =
    let seen = HashSet<int>()
    for i in 0 .. n - 1 do
        seen.Add((i * i) % n) |> ignore
    seen.Count
