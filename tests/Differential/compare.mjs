// Wasm side + comparison: call every function the reference ran, with the same arguments, and compare.
//
//   node --experimental-wasm-exnref compare.mjs <module.wasm> <reference.json> [known-differences.txt]
//
// Exit code 1 if any call disagrees and is not listed as known.  Rules:
//   * .NET returned a value and wasm the same value               → identical
//   * both failed (exception on .NET, trap in wasm)               → agree  (the kind of failure is not compared)
//   * anything else (different value, only one side failed)        → disagreement
// Floats are compared bit for bit (all NaNs are equal), except in functions whose name ends in `_approx`
// (transcendental functions: relative tolerance 1e-9).
import { readFileSync, existsSync } from "node:fs";

const [wasmPath, refPath, knownPath] = process.argv.slice(2);
const reference = JSON.parse(readFileSync(refPath, "utf8"));
const known = new Map(
  knownPath && existsSync(knownPath)
    ? readFileSync(knownPath, "utf8").split("\n").map((l) => l.trim()).filter((l) => l && !l.startsWith("#"))
        .map((l) => { const [name, ...why] = l.split(/\s+/); return [name, why.join(" ")]; })
    : [],
);

const imports = {
  env: { consolePrint: () => {} },
  testEnv: { wasmAdd: (a, b) => (a + b) | 0, wasmMul: (a, b) => (a * b) | 0 },
};
const { instance } = await WebAssembly.instantiate(readFileSync(wasmPath), imports);

const f64 = new Float64Array(1), u64 = new BigUint64Array(f64.buffer);
const fromBits = (hex) => { u64[0] = BigInt("0x" + hex); return f64[0]; };
const bitsOf = (x) => { f64[0] = x; return u64[0].toString(16).padStart(16, "0"); };
const decode = (kind, v) => (kind === "float" ? fromBits(v) : v);                // bool and int travel as numbers
const show = (kind, v) => (kind === "float" ? `${fromBits(v)}` : `${v}`);
const same = (kind, expected, got, approx) => {
  if (kind !== "float") return expected === got;
  const e = fromBits(expected);
  if (Number.isNaN(e) || Number.isNaN(got)) return Number.isNaN(e) && Number.isNaN(got);
  if (approx) return Math.abs(e - got) <= 1e-9 * Math.max(1, Math.abs(e), Math.abs(got));
  return bitsOf(got) === expected;
};

const stats = { functions: 0, calls: 0, identical: 0, bothFail: 0, known: 0, notExported: 0 };
const problems = []; // { name, lines[] }
for (const [name, fn] of Object.entries(reference)) {
  const f = instance.exports[name];
  if (typeof f !== "function" || f.length !== fn.params.length) { stats.notExported++; continue; }
  stats.functions++;
  const bad = [];
  for (const c of fn.cases) {
    stats.calls++;
    const args = c.args.map((a, i) => decode(fn.params[i], a));
    const shown = c.args.map((a, i) => show(fn.params[i], a)).join(", ");
    let got, trap = null;
    try { got = f(...args); } catch (e) { trap = e.message; }
    if ("error" in c) {
      if (trap !== null) { stats.bothFail++; continue; }
      if (c.error === "Timeout") continue;                                      // reference gave up: nothing to compare
      bad.push(`${name}(${shown}): .NET raised ${c.error}, wasm = ${got}`);
    } else if (trap !== null) {
      bad.push(`${name}(${shown}): .NET = ${show(fn.returns, c.ok)}, wasm trap: ${trap}`);
    } else if (same(fn.returns, c.ok, got, name.endsWith("_approx"))) {
      stats.identical++;
    } else {
      bad.push(`${name}(${shown}): .NET = ${show(fn.returns, c.ok)}, wasm = ${got}`);
    }
  }
  if (bad.length) {
    if (known.has(name)) stats.known += bad.length;
    else problems.push({ name, bad });
  }
}

const disagreeing = problems.reduce((n, p) => n + p.bad.length, 0);
console.log(`differential: ${stats.functions} functions, ${stats.calls} calls`);
console.log(`  ✓ identical             ${stats.identical}`);
console.log(`  ✗ disagreements         ${disagreeing}  (${problems.length} functions)`);
console.log(`  ~ both sides failed     ${stats.bothFail}`);
console.log(`  ~ known differences     ${stats.known}`);
console.log(`  - not exported by wasm  ${stats.notExported}`);
for (const p of problems) {
  console.log(`\n${p.name}: ${p.bad.length} disagreeing call(s)`);
  p.bad.slice(0, 4).forEach((l) => console.log("  " + l));
  if (p.bad.length > 4) console.log(`  … and ${p.bad.length - 4} more`);
}
process.exit(disagreeing ? 1 : 0);
