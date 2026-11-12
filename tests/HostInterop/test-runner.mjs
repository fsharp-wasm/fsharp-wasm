// node tests/HostInterop/test-runner.mjs — the module compiled from HostInterop.fs, with a JS host.
import fs from "node:fs";
import { hostImports, compileOptions } from "./host.mjs";

const here = new URL(".", import.meta.url).pathname;
let instance;
const registered = { text: null, mixed: null, later: null };
let reported = null;
const ids = [];
const imports = {
  ...hostImports(() => instance, (id) => ids.push(id)),
  "host.js": {
    shout: (s) => s.toUpperCase() + "!",
    maybeNull: () => null,
    length: (s) => s.length,
    each: (n, f) => { for (let i = 0; i < n; i++) f(i); },
    fold: (n, seed, f) => { let acc = seed; for (let i = 0; i < n; i++) acc = f(acc, i); return acc; },
    onText: (cb) => { registered.text = cb; },
    onMixed: (cb) => { registered.mixed = cb; },
    later: (cb) => { registered.later = cb; },
    names: () => ["a", "bb", "ccc"],
    withNames: (cb) => cb(["a", "bb", "ccc"]),
    isEven: (n) => n % 2 === 0,
    report: (s) => { reported = s; },
  },
};

const wasm = fs.readFileSync(`${here}output/HostInterop.wasm`);
({ instance } = await WebAssembly.instantiate(wasm, imports, compileOptions));
const exp = instance.exports;

let failed = 0;
const check = (name, expected, actual) => {
  const ok = Object.is(expected, actual);
  console.log(`  ${ok ? "✓" : "✗"}  ${name}: ${actual}${ok ? "" : `  (expected ${expected})`}`);
  if (!ok) failed++;
};

check("string both ways, non-ASCII", 6, exp.testShout());
check("JS null arrives as the empty string", 0, exp.testNullIsEmpty());
check("host reads an F# string (surrogate pair = 2 units)", 8, exp.testStringToJs());
check("closure called by the host updates a captured mutable", 10, exp.testEach());
check("closure with a result and two arguments", 12.5, exp.testFold());
check("string array result", 6, exp.testNames());
check("callback receiving a string array", 301, exp.testWithNames());
check("bool result", 1, exp.testBool());

// callbacks the host fires later, with strings and mixed arguments
exp.testRegister();
registered.text("hi"); registered.text("there");
registered.mixed("x", 1.5, 7);
registered.later();
exp.testReport();
check("callbacks delivered later", "hi;there;x|1.5|7;later;", reported);

// a closure's slot is released when its JS function is garbage collected, and the id is reused
{
  ids.length = 0;
  check("churn: 500 closures, all called", 500, exp.testChurn(500));
  const firstRound = Math.max(...ids);
  await new Promise((r) => setTimeout(r, 0));
  for (let i = 0; i < 5; i++) { globalThis.gc(); await new Promise((r) => setTimeout(r, 20)); }
  ids.length = 0;
  check("churn again after GC", 500, exp.testChurn(500));
  const secondRound = Math.max(...ids);
  check("closure table does not grow (ids are reused)", true, secondRound <= firstRound);
  console.log(`      highest id: first round ${firstRound}, second round ${secondRound}`);
}

// the surface of the module: the exports the host needs, no more
const names = Object.keys(exp);
check("exports __cb and __cbFree", true, names.includes("__cb") && names.includes("__cbFree"));
check("exports only the program's functions", false, names.some((n) => /^\$|host_|^__str/.test(n)));

console.log(failed ? `\n${failed} check(s) failed` : "\nhost interop: all checks passed");
process.exit(failed ? 1 : 0);
