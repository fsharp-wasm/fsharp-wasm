/// JS imports with strings, arrays and closures: the host interop ABI (docs/host-interop.md), driven by test-runner.mjs.
module HostInterop

open Fable.Core

[<Import("shout", "host.js")>]
let shout (s: string) : string = nativeOnly

[<Import("maybeNull", "host.js")>]
let maybeNull () : string = nativeOnly

[<Import("length", "host.js")>]
let jsLength (s: string) : int = nativeOnly

[<Import("each", "host.js")>]
let each (n: int) (f: int -> unit) : unit = nativeOnly

[<Import("fold", "host.js")>]
let fold (n: int) (seed: float) (f: float -> int -> float) : float = nativeOnly

[<Import("onText", "host.js")>]
let onText (cb: string -> unit) : unit = nativeOnly

[<Import("onMixed", "host.js")>]
let onMixed (cb: string -> float -> int -> unit) : unit = nativeOnly

[<Import("later", "host.js")>]
let later (cb: unit -> unit) : unit = nativeOnly

[<Import("names", "host.js")>]
let names () : string array = nativeOnly

[<Import("withNames", "host.js")>]
let withNames (cb: string array -> unit) : unit = nativeOnly

[<Import("eachRect", "host.js")>]
let eachRect (n: int) (f: int -> float -> float -> float -> float -> bool -> unit) : unit = nativeOnly

[<Import("eachEight", "host.js")>]
let eachEight (f: int -> int -> int -> int -> int -> int -> int -> int -> unit) : unit = nativeOnly

[<Import("report", "host.js")>]
let report (s: string) : unit = nativeOnly

[<Import("isEven", "host.js")>]
let isEven (n: int) : bool = nativeOnly

let mutable private collected = ""

/// A string crosses both ways, non-ASCII included: "héllo" → "HÉLLO!".
let testShout () : int =
    let s = shout "héllo"
    if s = "HÉLLO!" then s.Length else -1   // 6

/// A JS null / undefined arrives as the empty string.
let testNullIsEmpty () : int = (maybeNull ()).Length   // 0

/// The host reads an F# string (UTF-16 code units, a surrogate pair counts twice).
let testStringToJs () : int = jsLength "wörld" + jsLength "a😀"   // 5 + 3

/// A closure the host calls repeatedly; it captures and updates a mutable local.
let testEach () : int =
    let mutable total = 0
    each 5 (fun i -> total <- total + i)
    total   // 0+1+2+3+4 = 10

/// A closure with a result and two arguments: the host folds.
let testFold () : float = fold 4 0.5 (fun acc i -> acc + float i * 2.0)   // 0.5 + 0 + 2 + 4 + 6 = 12.5

/// Callbacks that receive a string / several mixed arguments, delivered later by the host (test-runner fires them).
let testRegister () : int =
    collected <- ""
    onText (fun s -> collected <- collected + s + ";")
    onMixed (fun s x n -> collected <- collected + s + "|" + string x + "|" + string n + ";")
    later (fun () -> collected <- collected + "later;")
    0

/// What the callbacks collected, handed to the host as a string.
let testReport () : unit = report collected

/// A JS array of strings comes back as a string array.
let testNames () : int = names () |> Array.sumBy (fun s -> s.Length)   // "a" "bb" "ccc" = 6

/// … and a callback may receive one.
let testWithNames () : int =
    let mutable n = 0
    withNames (fun xs -> n <- xs.Length * 100 + xs.[0].Length)
    n   // 3 names, first "a" → 301

/// A callback with six arguments (an id, four floats and a bool: what measuring the drop slots of a page delivers), then the widest one the ABI carries (eight).
let testWideCallbacks () : int =
    let mutable area = 0.0
    let mutable nests = 0
    eachRect 3 (fun id x y w h n -> area <- area + float id * w * h + x + y; if n then nests <- nests + 1)
    let mutable digits = 0
    eachEight (fun a b c d e f g h -> digits <- a * 10000000 + b * 1000000 + c * 100000 + d * 10000 + e * 1000 + f * 100 + g * 10 + h)
    int area * 100 + nests * 10 + (if digits = 12345678 then 1 else 0)
    // ids 0..2, x = id, y = 2 id, w = 10, h = 2: area = (0 + 1 + 2) * 20 + (0 + 1 + 2) + (0 + 2 + 4) = 69; odd ids nest: 1 → 6900 + 10 + 1

/// Registers a closure with the host `n` times; each is dropped by the host right away.
let testChurn (n: int) : int =
    let mutable calls = 0
    for _ in 1 .. n do
        each 1 (fun _ -> calls <- calls + 1)
    calls

let testBool () : int = (if isEven 4 then 1 else 0) + (if isEven 5 then 10 else 0)   // 1
