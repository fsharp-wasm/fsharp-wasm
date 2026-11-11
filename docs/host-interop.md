# Host interop: how F# talks to JavaScript

A WasmGC module cannot hand JavaScript a string or a closure — both are GC objects JS can neither read nor call.
A JS import is declared in F# as a function marked `nativeOnly`; the compiler marshals around it
(`src/Transforms/HostInterop.fs`). Nothing is generated unless the program uses it.

```fsharp
[<Import("subscribe", "runtime/pubsub.js")>]
let jsSubscribe (topic: string) (cb: string -> unit) : unit = nativeOnly
```

| F# at the boundary | in JavaScript | mechanism |
|---|---|---|
| `int`, `bool`, `char`, `float`, `float32`, handles | a number | passed as is |
| `string` (argument or result) | a JS string | the engine's [JS String Builtins](https://github.com/WebAssembly/js-string-builtins): `fromCharCodeArray`, `intoCharCodeArray`, `length`. Our strings are `i32` arrays, the builtins read `i16` arrays, so each direction is one bulk call plus one copy loop (`$host_strToHost` / `$host_strFromHost`). A JS `null` / `undefined` arrives as `""`. |
| `string array` (result, or a callback parameter) | a JS array | read through `fsharp:host.arrLen` / `arrGet` |
| function argument (`'a -> 'b`, up to four arguments) | a JS function | the closure is stored in a table; JS gets `fsharp:host.callback(id)`, a function that calls the single export `__cb(id, a0 … a3)`; one trampoline per signature unboxes the arguments (`x2i`, `x2f`, strings) and boxes the result (`i2x`, `f2x`) |
| unit | dropped (argument) / `undefined` (result) | |

## What the host provides

```js
const imports = {
  "runtime/<module>.js": { /* your functions */ },
  "fsharp:host": {
    callback: (id) => (...args) => instance.exports.__cb(id, ...args),
    i2x: (n) => n, f2x: (n) => n,
    x2i: (x) => Number(x) | 0, x2f: (x) => Number(x),
    arrLen: (a) => a.length, arrGet: (a, i) => a[i],
  },
};
await WebAssembly.instantiateStreaming(fetch(url), imports, { builtins: ["js-string"] });
```

`runtime/boot.js` in fsharp-wasm-runtime is a complete example, including `env.consolePrint` for `printfn`
(the module passes an opaque string and exports `__str_len` / `__str_at` to read it).

## Consequences

* Asynchronous JS APIs take a callback; the callback continues the program (in Elmish: it dispatches a message).
  A module cannot block on a promise.
* The module needs an engine with WasmGC and the JS String Builtins: Chrome / Edge 130+, Firefox 134+, Node 22+. To my knowledge Safari has not shipped the string builtins yet — a fallback that copies text through two integer imports (as an earlier runtime did) would be needed there.
* The import set of a module is exactly what its surviving code calls; its exports are the functions of the entry
  project (plus `__cb`, and `__str_len` / `__str_at` when it prints).
