// The host side of the ABI, as docs/host-interop.md specifies it.
export const hostImports = (getInstance) => ({
  "fsharp:host": {
    callback: (id) => (...args) => getInstance().exports.__cb(id, ...args),
    i2x: (n) => n,
    f2x: (n) => n,
    x2i: (x) => Number(x) | 0,
    x2f: (x) => Number(x),
    arrLen: (a) => a.length,
    arrGet: (a, i) => a[i],
  },
});
export const compileOptions = { builtins: ["js-string"] };
