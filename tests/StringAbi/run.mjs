// Runs StringAbi.wasm on Node with a host that reads and builds strings through the accessor exports only.
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const wasm = fileURLToPath(new URL("./output/StringAbi.wasm", import.meta.url));
const module = new WebAssembly.Module(readFileSync(wasm));          // plain compile: no builtins
const needed = WebAssembly.Module.imports(module);
let failed = 0;
const check = (name, ok, extra = "") => { console.log(`${ok ? "✓" : "✗"} ${name}${ok ? "" : "  " + extra}`); if (!ok) failed++; };

check("the module does not import wasm:js-string", !needed.some((i) => i.module === "wasm:js-string"), JSON.stringify(needed));

let ex;
const read = (ref) => { let s = ""; for (let i = 0, n = ex.__str_len(ref); i < n; i++) s += String.fromCharCode(ex.__str_at(ref, i)); return s; };
const make = (s) => { const ref = ex.__str_new(s.length); for (let i = 0; i < s.length; i++) ex.__str_set(ref, i, s.charCodeAt(i)); return ref; };
const instance = new WebAssembly.Instance(module, {
  host: {
    hostLength: (ref) => read(ref).length,
    hostUpper: (ref) => make(read(ref).toUpperCase()),
    hostNothing: () => null,
  },
});
ex = instance.exports;

check("the accessor exports exist", ["__str_len", "__str_at", "__str_new", "__str_set"].every((n) => typeof ex[n] === "function"));
check("round trip of non-ASCII text through the host", ex.roundTrip() === 11, String(ex.roundTrip()));
check("empty string, and null from the host", ex.emptyAndNull() === 11, String(ex.emptyAndNull()));
check("a string of 10000 characters", ex.longString() === 10000, String(ex.longString()));
console.log(failed ? `\n${failed} check(s) failed` : "\nall string ABI checks passed");
process.exit(failed ? 1 : 0);
