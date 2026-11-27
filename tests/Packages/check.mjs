// node check.mjs <module.wasm>: the module of a program that uses a package, run.
import { readFileSync } from "node:fs";

const { instance } = await WebAssembly.instantiate(readFileSync(process.argv[2]), {});
const want = { sum: 43, count: 3, finiteOnly: 1 };
let failed = 0;
for (const [name, expected] of Object.entries(want)) {
  const got = instance.exports[name]?.();
  const ok = got === expected;
  console.log(`${ok ? "✓" : "✗"} ${name}: ${got} (expected ${expected})`);
  if (!ok) failed++;
}
process.exit(failed ? 1 : 0);
