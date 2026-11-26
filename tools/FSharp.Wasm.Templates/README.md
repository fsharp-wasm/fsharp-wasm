# FSharp.Wasm.Templates

`dotnet new` templates for [fsharp-wasm](https://fsharp-wasm.github.io), which compiles F# to WebAssembly GC.

```bash
dotnet tool install -g FSharp.Wasm.Cli      # the compiler (add --prerelease while the version is 0.x-experimental)
dotnet new install FSharp.Wasm.Templates
dotnet new fsharp-wasm -n hello
cd hello
fsharp-wasm . --outDir out                  # hello.fs -> out/hello.wasm
node run.mjs                                # Node 22 or later; or serve the folder and open index.html
```
