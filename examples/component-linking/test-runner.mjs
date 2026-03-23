// Component-linking test runner.
//
// Demonstrates two F# WasmGC modules composed at Wasm runtime:
//   MathCore — pure math primitives (no imports)
//   App      — higher-level logic that imports MathCore
//
// Usage (called by run.sh):
//   node test-runner.mjs <path-to-MathCore.wasm> <path-to-App.wasm>
//
// The import wiring shows the Component Model link pattern:
//   { 'math-core': mathCoreInstance.exports }
//   This is exactly how Wasm Component Model linking works at the host layer.
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const [, , mathCorePath, appPath] = process.argv;
if (!mathCorePath || !appPath) {
  console.error("Usage: node test-runner.mjs <MathCore.wasm> <App.wasm>");
  process.exit(1);
}

// ── Shared host env (both modules may call consolePrint) ──────────────────────
const env = {
  consolePrint: (_strRef) => { /* printfn output; ignored in tests */ },
};

// ── Step 1: instantiate MathCore (no imports except env) ─────────────────────
const mathCoreBuf = readFileSync(resolve(mathCorePath));
const { instance: mathCoreInst } = await WebAssembly.instantiate(mathCoreBuf, { env });
const mc = mathCoreInst.exports;

// ── Step 2: instantiate App — wiring 'math-core' imports from MathCore ───────
// This is the component composition step: App declares Wasm imports from the
// module named 'math-core'; we satisfy them with MathCore's export table.
const appBuf = readFileSync(resolve(appPath));
const { instance: appInst } = await WebAssembly.instantiate(appBuf, {
  env,
  "math-core": mathCoreInst.exports,
});
const app = appInst.exports;

let pass = 0, fail = 0;
function check(label, expected, actual) {
  if (expected === actual) {
    console.log(`  ✓  ${label}: ${actual}`);
    pass++;
  } else {
    console.error(`  ✗  ${label}: expected ${expected}, got ${actual}`);
    fail++;
  }
}

// floating-point approximate equality
function checkF(label, expected, actual, eps = 1e-9) {
  if (Math.abs(expected - actual) <= eps) {
    console.log(`  ✓  ${label}: ${actual}`);
    pass++;
  } else {
    console.error(`  ✗  ${label}: expected ${expected}, got ${actual}`);
    fail++;
  }
}

// ── MathCore direct tests ─────────────────────────────────────────────────────
console.log("\n─── MathCore direct exports ────────────────────────\n");

check("add(3, 4)",          7,    mc.add(3, 4));
check("add(-5, 5)",         0,    mc.add(-5, 5));
check("mul(6, 7)",          42,   mc.mul(6, 7));
check("clamp(15, 0, 10)",   10,   mc.clamp(15, 0, 10));
check("clamp(-5, 0, 10)",   0,    mc.clamp(-5, 0, 10));
check("clamp(5, 0, 10)",    5,    mc.clamp(5, 0, 10));
check("fibonacci(0)",       0,    mc.fibonacci(0));
check("fibonacci(1)",       1,    mc.fibonacci(1));
check("fibonacci(10)",      55,   mc.fibonacci(10));
check("fibonacci(20)",      6765, mc.fibonacci(20));
checkF("dotProduct(3,4,3,4)", 25, mc.dotProduct(3, 4, 3, 4));
checkF("dotProduct(1,0,0,1)", 0,  mc.dotProduct(1, 0, 0, 1));
check("intPow(2, 10)",      1024, mc.intPow(2, 10));
check("intPow(3, 3)",       27,   mc.intPow(3, 3));
check("intPow(5, 0)",       1,    mc.intPow(5, 0));

// ── App tests (imports wired from MathCore) ───────────────────────────────────
console.log("\n─── App (imports MathCore at runtime) ───────────────\n");

// sumOfFibs(n) = F(0)+F(1)+...+F(n)
// F(0..4) = 0,1,1,2,3 → sum = 7
check("sumOfFibs(4)",        7,   app.sumOfFibs(4));
// F(0..7) = 0,1,1,2,3,5,8,13 → sum = 33
check("sumOfFibs(7)",        33,  app.sumOfFibs(7));

// magnitudeSquared(3,4) = 3²+4² = 25
checkF("magnitudeSquared(3,4)", 25, app.magnitudeSquared(3, 4));
checkF("magnitudeSquared(1,0)", 1,  app.magnitudeSquared(1, 0));

// triangleNumber(n) = n*(n+1)/2
check("triangleNumber(10)",  55,  app.triangleNumber(10));
check("triangleNumber(5)",   15,  app.triangleNumber(5));
check("triangleNumber(1)",   1,   app.triangleNumber(1));

// ─────────────────────────────────────────────────────────────────────────────
console.log(`\n─── Result: ${pass} passed, ${fail} failed ─────────────────────\n`);
if (fail > 0) process.exit(1);
