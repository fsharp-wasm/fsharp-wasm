// The host side of the ABI, as docs/host-interop.md specifies it.
// A closure passed to JS becomes a JS function; when that function is garbage collected its slot in the module's
// closure table is released (`__cbFree`), so a program that registers handlers all the time does not grow the table.
export const hostImports = (getInstance, onCallback = () => {}) => {
  const released = new FinalizationRegistry((id) => getInstance().exports.__cbFree(id));
  return {
    "fsharp:host": {
      callback: (id) => {
        const f = (...args) => getInstance().exports.__cb(id, ...args);
        released.register(f, id);
        onCallback(id);
        return f;
      },
      i2x: (n) => n,
      f2x: (n) => n,
      x2i: (x) => Number(x) | 0,
      x2f: (x) => Number(x),
      arrLen: (a) => a.length,
      arrGet: (a, i) => a[i],
    },
  };
};
export const compileOptions = { builtins: ["js-string"] };
