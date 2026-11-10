// Wasm side + comparison: call every exported function of arity 0 and compare with the .NET reference.
//
//   node --experimental-wasm-exnref compare.mjs <module.wasm> <reference.json> [known-differences.txt]
//
// Exit code 1 if any function disagrees (a wasm trap counts as a disagreement) that is not listed as known.
import { readFileSync, existsSync } from "node:fs";

const [wasmPath, refPath, knownPath] = process.argv.slice(2);
const reference = JSON.parse(readFileSync(refPath, "utf8"));
const known = new Map(
  knownPath && existsSync(knownPath)
    ? readFileSync(knownPath, "utf8").split("\n").map((l) => l.trim()).filter((l) => l && !l.startsWith("#"))
        .map((l) => { const [name, ...why] = l.split(/\s+/); return [name, why.join(" ")]; })
    : [],
);

// Host imports the compiled tests expect (same as the hand-written runners).
const imports = {
  env: { consolePrint: () => {} },
  testEnv: { wasmAdd: (a, b) => (a + b) | 0, wasmMul: (a, b) => (a * b) | 0 },
};
const { instance } = await WebAssembly.instantiate(readFileSync(wasmPath), imports);

const rows = { match: 0, mismatch: [], trap: [], known: [], noReference: 0, referenceError: [] };
for (const [name, ref] of Object.entries(reference)) {
  const f = instance.exports[name];
  if (typeof f !== "function" || f.length !== 0) { rows.noReference++; continue; }
  let got, trapped = null;
  try { got = f(); } catch (e) { trapped = e.message; }
  if ("error" in ref) { rows.referenceError.push(`${name}: .NET raised ${ref.error}  |  wasm ${trapped ? "trap: " + trapped : "= " + got}`); continue; }
  if (trapped === null && got === ref.ok) { rows.match++; continue; }
  const line = `${name}: .NET = ${ref.ok}, wasm ${trapped !== null ? "trap: " + trapped : "= " + got}`;
  if (known.has(name)) rows.known.push(`${line}   [known: ${known.get(name)}]`);
  else (trapped !== null ? rows.trap : rows.mismatch).push(line);
}

const total = Object.keys(reference).length;
console.log(`differential: ${total} functions on the reference side`);
console.log(`  ✓ identical             ${rows.match}`);
console.log(`  ✗ different value       ${rows.mismatch.length}`);
console.log(`  ✗ wasm trap             ${rows.trap.length}`);
console.log(`  ~ known differences     ${rows.known.length}`);
console.log(`  ~ .NET raised (skipped) ${rows.referenceError.length}`);
console.log(`  - not exported by wasm  ${rows.noReference}`);
for (const [title, list] of [["DIFFERENT VALUE", rows.mismatch], ["WASM TRAP", rows.trap], ["KNOWN", rows.known]])
  if (list.length) { console.log(`\n${title}`); list.forEach((l) => console.log("  " + l)); }
if (process.env.DIFF_VERBOSE && rows.referenceError.length) {
  console.log("\n.NET RAISED (reference unavailable)"); rows.referenceError.forEach((l) => console.log("  " + l));
}
process.exit(rows.mismatch.length + rows.trap.length ? 1 : 0);
