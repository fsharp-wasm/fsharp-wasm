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
| function argument (`'a -> 'b`, up to four arguments) | a JS function | the closure is stored in a table; JS gets `fsharp:host.callback(id)`, a function that calls the single export `__cb(id, a0 … a3)`; when that JS function is garbage collected the host calls `__cbFree(id)` and the slot is reused; one trampoline per signature unboxes the arguments (`x2i`, `x2f`, strings) and boxes the result (`i2x`, `f2x`) |
| unit | dropped (argument) / `undefined` (result) | |

## What the host provides

```js
const imports = {
  "runtime/<module>.js": { /* your functions */ },
  "fsharp:host": {
    callback: (id) => {
      const f = (...args) => instance.exports.__cb(id, ...args);
      released.register(f, id);              // const released = new FinalizationRegistry((id) => instance.exports.__cbFree(id))
      return f;
    },
    i2x: (n) => n, f2x: (n) => n,
    x2i: (x) => Number(x) | 0, x2f: (x) => Number(x),
    arrLen: (a) => a.length, arrGet: (a, i) => a[i],
  },
};
await WebAssembly.instantiateStreaming(fetch(url), imports, { builtins: ["js-string"] });
```

`runtime/boot.js` in fsharp-wasm-runtime is a complete example, including `env.consolePrint` for `printfn`
(the module passes an opaque string and exports `__str_len` / `__str_at` to read it).

## Strings without the builtins: the Exports ABI

The builtins are the default. They need an engine that compiles the module with `{ builtins: ["js-string"] }` — and a precompiled
module is compiled by the platform, not by you: Cloudflare Workers (workerd) and Vercel Edge import a `.wasm` as a ready
`WebAssembly.Module`, without builtins, and instantiating it fails with `Import "wasm:js-string": module is not an object or function`.

`WASMGC_STRING_ABI=exports` compiles the module without any `wasm:js-string` import. A string then crosses as an opaque reference
to the module's own string (`extern.convert_any`), and the host uses four exports of the module:

| export | use |
|---|---|
| `__str_len(s) → i32`, `__str_at(s, i) → i32` | read a string the module passed out (an argument of a host function) |
| `__str_new(length) → string`, `__str_set(s, i, utf16CodeUnit)` | build a string for the module (the result of a host function: return the reference `__str_new` made) |

```js
const read = (ref) => { let s = ""; for (let i = 0, n = ex.__str_len(ref); i < n; i++) s += String.fromCharCode(ex.__str_at(ref, i)); return s; };
const make = (s) => { const ref = ex.__str_new(s.length); for (let i = 0; i < s.length; i++) ex.__str_set(ref, i, s.charCodeAt(i)); return ref; };
```

A host that returns `null` / `undefined` gives `""`. Nothing else is needed from the engine but WasmGC, so the module also runs on Node 22,
Deno, Bun, Cloudflare Workers and Vercel Edge; the cost is one call per character, which is fine for headers, paths and JSON
bodies (`tests/StringAbi` checks round trips of non-ASCII text, an empty string, null and 10000 characters on a host without
builtins; the backend modules of fsharp-wasm-backend are built this way).

## Consequences

* Asynchronous JS APIs take a callback; the callback continues the program (in Elmish: it dispatches a message).
  A module cannot block on a promise.
* The default string ABI needs an engine with WasmGC and the JS String Builtins: Chrome / Edge 130+, Firefox 134+, Node 24+ (Node 22 has WasmGC but not the builtins), Deno 2.1+. To my knowledge Safari has not shipped the string builtins yet; the Exports ABI above is the way there, and on platforms that precompile modules.
* The import set of a module is exactly what its surviving code calls; its exports are the functions of the entry
  project (plus `__cb`, `__str_len` / `__str_at` when it prints, and the four `__str_*` accessors in the Exports ABI).
