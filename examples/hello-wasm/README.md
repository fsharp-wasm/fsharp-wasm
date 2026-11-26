# Hello, WebAssembly GC

An F# file, compiled to a WebAssembly GC module by [fsharp-wasm](https://github.com/fsharp-wasm/fsharp-wasm), run by Node and by a web page.

```bash
dotnet tool install -g FSharp.Wasm.Cli       # the compiler; once (add --prerelease while the version is 0.x-experimental)
fsharp-wasm . --outDir out                   # Hello.fs -> out/Hello.wasm
node run.mjs                                 # Node 22 or later
```

The page: `python3 -m http.server` (or `npx serve .`) in this folder, then open `http://localhost:8000/`.

`out/Hello.wat` is the same module as text: read it. `wasm-tools validate out/Hello.wasm --features gc` checks it, if you have [wasm-tools](https://github.com/bytecodealliance/wasm-tools).

Public top-level functions of `Hello.fs` are the exports. What compiles and what does not yet is in the
[status page](https://github.com/fsharp-wasm/fsharp-wasm/blob/main/docs/STATUS.md); more to run is on the [demos](https://fsharp-wasm.github.io/demos/).
