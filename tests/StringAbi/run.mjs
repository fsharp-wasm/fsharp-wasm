// Runs StringAbi.wasm on Node with a host that reads and builds strings through the accessor exports only.
import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const wasm = fileURLToPath(new URL("./output/StringAbi.wasm", import.meta.url));
const module = new WebAssembly.Module(readFileSync(wasm));          // plain compile: no builtins
const needed = WebAssembly.Module.imports(module);
let failed = 0;
const check = (name, ok, extra = "") => { console.log(`${ok ? "✓" : "✗"} ${name}${ok ? "" : "  " + extra}`); if (!ok) failed++; };

check("the module does not import wasm:js-string", !needed.some((i) => i.module === "wasm:js-string"), JSON.stringify(needed));

// The host, in two ways: one call per character (what every module's exports allow), and in bulk through the memory the module exports.
const perChar = (ex) => ({
  read: (ref) => { let s = ""; for (let i = 0, n = ex.__str_len(ref); i < n; i++) s += String.fromCharCode(ex.__str_at(ref, i)); return s; },
  make: (s) => { const ref = ex.__str_new(s.length); for (let i = 0; i < s.length; i++) ex.__str_set(ref, i, s.charCodeAt(i)); return ref; },
});
const calls = { perChar: 0, bulk: 0 };
const bulk = (ex) => ({
  read: (ref) => {
    const n = ex.__str_to_mem(ref);
    if (n < 0) throw new Error("the module could not make room for the string");
    calls.bulk++;
    const units = new Uint16Array(ex.memory.buffer, 0, n);                          // read after the call: it may have grown the memory
    let s = "";
    for (let i = 0; i < n; i += 8192) s += String.fromCharCode.apply(null, units.subarray(i, i + 8192));
    return s;
  },
  make: (s) => {
    if (ex.__str_reserve(s.length) !== 0) throw new Error("the module could not make room for the string");
    const units = new Uint16Array(ex.memory.buffer, 0, s.length);
    for (let i = 0; i < s.length; i++) units[i] = s.charCodeAt(i);
    calls.bulk++;
    return ex.__str_from_mem(s.length);
  },
});

const run = (name, strings) => {
  let ex;
  const io = () => strings(ex);
  const instance = new WebAssembly.Instance(module, {
    host: {
      hostLength: (ref) => io().read(ref).length,
      hostUpper: (ref) => io().make(io().read(ref).toUpperCase()),
      hostEcho: (ref) => io().make(io().read(ref)),
      hostNothing: () => null,
    },
  });
  ex = instance.exports;
  check(`${name}: round trip of non-ASCII text through the host`, ex.roundTrip() === 11, String(ex.roundTrip()));
  check(`${name}: empty string, and null from the host`, ex.emptyAndNull() === 11, String(ex.emptyAndNull()));
  check(`${name}: a string of 10000 characters`, ex.longString() === 10000, String(ex.longString()));
  check(`${name}: lone surrogates, the empty string and 70000 characters survive unchanged`, ex.echoes() === 1111, String(ex.echoes()));
  return ex;
};

const ex = run("per character", perChar);
check("the accessor exports exist", ["__str_len", "__str_at", "__str_new", "__str_set"].every((n) => typeof ex[n] === "function"));
check("the bulk exports and the memory exist", ["__str_reserve", "__str_to_mem", "__str_from_mem"].every((n) => typeof ex[n] === "function") && ex.memory instanceof WebAssembly.Memory);
if (ex.memory) run("in bulk", bulk);
check("the bulk host moved strings through the memory", calls.bulk > 0, String(calls.bulk));
console.log(failed ? `\n${failed} check(s) failed` : "\nall string ABI checks passed");
process.exit(failed ? 1 : 0);
