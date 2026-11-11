/// Micro benchmarks: the SAME functions run as .NET (Release, JIT) and as wasm (node / V8).  Each takes a size `n`
/// and returns a checksum, so both sides can be compared for equal results and the work cannot be optimised away.
/// Functions named `bench_*` are picked up by tests/Bench/run.sh.
module Bench

type Tree =
    | Leaf
    | Node of Tree * int * Tree

let rec private fibRec (n: int) : int = if n < 2 then n else fibRec (n - 1) + fibRec (n - 2)

let rec private insert (t: Tree) (v: int) : Tree =
    match t with
    | Leaf -> Node(Leaf, v, Leaf)
    | Node(l, x, r) -> if v < x then Node(insert l v, x, r) elif v > x then Node(l, x, insert r v) else t

let rec private sumTree (t: Tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, x, r) -> sumTree l + x + sumTree r

/// recursion + calls
let bench_fib (n: int) : int = fibRec n

/// tight integer loops
let bench_loop (n: int) : int =
    let mutable s = 0
    for i in 1 .. n do
        for j in 1 .. 100 do
            s <- s + (i ^^^ j) % 7
    s

/// array of bools, nested loops
let bench_sieve (n: int) : int =
    let composite = Array.zeroCreate<bool> (n + 1)
    let mutable count = 0
    for i in 2 .. n do
        if not composite.[i] then
            count <- count + 1
            let mutable j = i * 2
            while j <= n do
                composite.[j] <- true
                j <- j + i
    count

/// integer division and remainder in a loop with data-dependent control flow
let bench_collatz (n: int) : int =
    let mutable best = 0
    for start in 1 .. n do
        let mutable x = int64 start
        let mutable steps = 0
        while x <> 1L do
            x <- if x % 2L = 0L then x / 2L else 3L * x + 1L
            steps <- steps + 1
        if steps > best then best <- steps
    best

/// float arithmetic
let bench_float (n: int) : int =
    let mutable x = 0.0
    let mutable v = 1.0
    for i in 1 .. n do
        v <- v * 0.999999 + 0.000001 * float i
        x <- x + sqrt (v * v + 1.0)
    int x

/// list allocation + map / filter / fold
let bench_list (n: int) : int =
    [ 1 .. n ] |> List.map (fun v -> v * 3) |> List.filter (fun v -> v % 2 = 0) |> List.fold (fun a v -> a + v % 1000) 0

/// array map / filter / sum
let bench_array (n: int) : int =
    Array.init n id |> Array.map (fun v -> v * 3) |> Array.filter (fun v -> v % 2 = 0) |> Array.sumBy (fun v -> v % 1000)

/// sort (the backend sorts with insertion sort for now)
let bench_sort (n: int) : int =
    let a = Array.init n (fun i -> (i * 7919) % 10007)
    let s = Array.sort a
    s.[0] + s.[n / 2] + s.[n - 1]

/// allocation of unions + recursion
let bench_tree (n: int) : int =
    let mutable t = Leaf
    for i in 1 .. n do
        t <- insert t ((i * 7919) % 100003)
    sumTree t

/// closures: a fold with a captured variable
let bench_closure (n: int) : int =
    let k = n % 7 + 1
    let add = fun acc v -> acc + v * k
    let mutable s = 0
    for round in 1 .. 100 do
        s <- s + ([| 1 .. n / 100 |] |> Array.fold add 0)
    s

/// strings: concatenation and formatting
let bench_string (n: int) : int =
    let mutable len = 0
    for i in 1 .. n do
        len <- len + (string i + "-" + string (i * 2)).Length
    len

/// records: allocation + field access
type P = { X: int; Y: int }
let bench_record (n: int) : int =
    let mutable acc = { X = 0; Y = 0 }
    for i in 1 .. n do
        acc <- { X = acc.X + i; Y = acc.Y ^^^ i }
    acc.X + acc.Y
