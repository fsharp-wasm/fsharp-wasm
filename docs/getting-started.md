# Getting started

From nothing to an F# program running as WebAssembly GC, then to a program that uses a library from NuGet.

**What was verified, and when (2026-11-27):** steps 1, 2 and 4 were run in an empty `HOME` with an empty NuGet packages folder, against nuget.org: `FSharp.Wasm.Cli` and `FSharp.Wasm.Templates`
`0.1.0-preview` installed, the template created, `fsharp-wasm . --outDir out` compiled it in 4.9 s and `node run.mjs` printed what step 2 shows; step 4 restored `FSharp.Wasm.Data 0.1.0-preview` and `total ()` was 19.
Step 3 was run earlier the same day against packages built from this repository. **Not verified:** macOS and Windows (Linux only), and the from-source route of step 1 was not run again for this page.

## What you need

| | version | for |
|---|---|---|
| [.NET SDK](https://dotnet.microsoft.com/download) | 10 | the compiler runs on it, and your project is an ordinary F# project |
| [Node.js](https://nodejs.org/) | 22 or later | to run the module (any engine with WebAssembly GC does: Chrome and Edge 119+, Firefox 120+, Safari 18.2+) |
| [wasm-tools](https://github.com/bytecodealliance/wasm-tools/releases) | 1.263.0 | optional: `wasm-tools validate out/Hello.wasm --features gc` |

## 1. The compiler and the template

```bash
dotnet tool install -g FSharp.Wasm.Cli --prerelease
dotnet new install FSharp.Wasm.Templates
```

Or from source, to work on the compiler itself:

```bash
git clone https://github.com/fsharp-wasm/fsharp-wasm.git && cd fsharp-wasm
git submodule update --init --depth 1 vendor/Fable vendor/fsharp core
(cd vendor/fsharp && mkdir -p artifacts && ./build/build.sh -c Release)      # the patched F# compiler the front end uses: once, a few minutes
export FSHARP_COMPILER=$PWD/vendor/fsharp/artifacts/bin/fsc/Release/net10.0/fsc.dll
dotnet build tools/FSharp.Wasm.Cli -c Release
# then use  dotnet tools/FSharp.Wasm.Cli/bin/Release/net10.0/fsharp-wasm.dll  where this page says  fsharp-wasm
```

## 2. A program

```bash
dotnet new fsharp-wasm -o hello && cd hello
fsharp-wasm . --outDir out        # hello.fs -> out/hello.wasm
node run.mjs
```

```text
fibonacci 10          = 55
isPrime 97, 100       = 1 0
sum of odd squares 9  = 165
```

`hello.fs` is ordinary F#; its public top-level functions are the exports of the module (a `bool` is an `i32` on the other side, hence `1 0`). The names follow the folder you give `-o`.

```fsharp
module hello

let fibonacci (n: int) : int =
    let mutable a, b = 0, 1
    for _ in 1 .. n do
        let t = a + b
        a <- b
        b <- t
    a

// isPrime and a list pipeline (sumOfSquaresOfOdds) follow in the file
```

`out/hello.wat` is the same module as text: read it. `out/wit/` is the WIT description of its exports. The page of the template runs the same module in a browser: `npx serve .` and open it.

## 3. The same program under .NET

The project is an ordinary F# project: `dotnet build` builds it, and its functions can be called from a test project or from `dotnet fsi` (`#load "Hello.fs"`). It has no entry point
(`dotnet run` says so and does nothing). That is the point of the platform: the code is written once and means the same thing in both places, and the suites of the platform run both ways
and compare (the compiler's `tests/Differential`, and the gates that run the libraries' own tests as WebAssembly).

## 4. A library from NuGet

```bash
dotnet add package FSharp.Wasm.Data --prerelease
```

Put the code below in a file, `Json.fs`, and list it in the project (`<Compile Include="Json.fs" />`) in place of `hello.fs`:

```fsharp
module Json

open FSharp.Wasm.Data

let total () : int =
    match Json.parse """{ "items": [ { "qty": 2, "price": 3.5 }, { "qty": 1, "price": 12 } ] }""" with
    | Error _ -> -1
    | Ok doc -> doc |> Json.listOf "items" |> List.sumBy (fun i -> Json.numberOr "qty" 0.0 i * Json.numberOr "price" 0.0 i) |> int
```

`fsharp-wasm . --outDir out` restores the package, takes its sources (they are in the package under `fable/`, next to the dll that .NET uses) into `out/fable_modules/` and compiles them with your code; `total ()` is 19.
The libraries of the platform are packages in this way: `FSharp.Wasm.Core`, `Data`, `Ui`, `Edit`, `Frame`, `Graph`, `Live`, `FSharp.Graphics.*` (charts, diagrams, widgets) and `GlyphAura`.

## 5. In the browser, with a canvas

The runtime is an npm package (`@fsharp-wasm/runtime`: the Elmish loop, the `Browser.Html` DSL, the glue for the canvas and the DOM). The demos are the way in:
[charts](https://fsharp-wasm.github.io/fsharp-wasm-runtime/demos/charts/) (400 000 points, a live histogram on the data graph, contours, a diagram of the graph itself),
[widget editor](https://fsharp-wasm.github.io/fsharp-wasm-runtime/demos/widget-editor/), [accounting grid](https://fsharp-wasm.github.io/fsharp-wasm-runtime/demos/accounting-grid/)
(a million lines), [WasmOS](https://fsharp-wasm.github.io/fsharp-wasm-runtime/demos/wasmos/); each is a few hundred kilobytes of WebAssembly.

## When something does not work

| you see | it means |
|---|---|
| `Unhandled import call '…'` or `error[WGC008]` | the program uses something the compiler does not compile yet. A minimal program and the compiler's [status](STATUS.md) (the known gaps) are what we want: [open an issue](https://github.com/fsharp-wasm/fsharp-wasm/issues) |
| `dotnet tool install` finds no package | add `--prerelease` (every version is 0.x) |
| `node run.mjs` says `WebAssembly.instantiate(): … gc` | Node older than 22 |
| a library compiles under .NET but not here | the same: a finding for the compiler, not for your program (we fix it there, not in the library) |

## Where next

[Live demos](https://fsharp-wasm.github.io/demos/) · [examples](https://fsharp-wasm.github.io/examples/) · [science charts and diagrams](https://github.com/fsharp-wasm/fsharp-wasm-graphics/blob/main/docs/science-charts.md) ·
[what is tested](https://fsharp-wasm.github.io/tests/) · [the state of every repository](https://fsharp-wasm.github.io/status/) · [how we work](../AGENTS.md)
