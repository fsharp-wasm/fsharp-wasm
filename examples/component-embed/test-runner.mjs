// Component-embed test runner.
//
// Demonstrates two F# WasmGC modules composed at Wasm runtime, showcasing
// GC-managed arrays and strings inside each module:
//
//   MathCore — math primitives + array/string demos (no imports)
//   App      — imports MathCore, adds HOF wrappers, builds GC arrays locally,
//              does string operations that return lengths to JS
//
// Key points about WasmGC arrays and strings:
//   - Strings are `(array i32)` on the GC heap — no null terminator, no overflow.
//   - Arrays are GC-managed — no malloc/free, automatically collected.
//   - Primitive results (i32/f64) cross module boundaries; rich GC types stay local.
//
// Usage (called by run.sh):
//   node test-runner.mjs <path-to-MathCore.wasm> <path-to-App.wasm>
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const [, , mathCorePath, appPath] = process.argv;
if (!mathCorePath || !appPath) {
  console.error("Usage: node test-runner.mjs <MathCore.wasm> <App.wasm>");
  process.exit(1);
}

const env = {
  consolePrint: (_strRef) => {
    /* printfn output; ignored in tests */
  },
};

// Step 1: instantiate MathCore (no imports except env)
const mathCoreBuf = readFileSync(resolve(mathCorePath));
const { instance: mathCoreInst } = await WebAssembly.instantiate(mathCoreBuf, {
  env,
});
const mc = mathCoreInst.exports;

// Step 2: instantiate App — 'math-core' imports satisfied by MathCore exports
const appBuf = readFileSync(resolve(appPath));
const { instance: appInst } = await WebAssembly.instantiate(appBuf, {
  env,
  "math-core": mathCoreInst.exports,
});
const app = appInst.exports;

let pass = 0,
  fail = 0;
function check(label, expected, actual) {
  if (expected === actual) {
    console.log(`  ✓  ${label}: ${actual}`);
    pass++;
  } else {
    console.error(`  ✗  ${label}: expected ${expected}, got ${actual}`);
    fail++;
  }
}
function checkF(label, expected, actual, eps = 1e-9) {
  if (Math.abs(expected - actual) <= eps) {
    console.log(`  ✓  ${label}: ${actual}`);
    pass++;
  } else {
    console.error(`  ✗  ${label}: expected ${expected}, got ${actual}`);
    fail++;
  }
}

// ── MathCore: arithmetic primitives ──────────────────────────────────────────
console.log("\n─── MathCore: arithmetic primitives ────────────────\n");
check("add(3, 4)", 7, mc.add(3, 4));
check("add(-5, 5)", 0, mc.add(-5, 5));
check("clamp(15, 0, 10)", 10, mc.clamp(15, 0, 10));
check("clamp(-5, 0, 10)", 0, mc.clamp(-5, 0, 10));
check("fibonacci(10)", 55, mc.fibonacci(10));
check("fibonacci(20)", 6765, mc.fibonacci(20));
checkF("dotProduct(3,4,3,4)", 25, mc.dotProduct(3, 4, 3, 4));
check("intPow(2, 10)", 1024, mc.intPow(2, 10));
check("intPow(3, 3)", 27, mc.intPow(3, 3));

// ── MathCore: GC ARRAY showcase 1 — bubble sort + in-place mutation ──────────
console.log("\n─── MathCore: GC arrays (mutation + HOF) ───────────\n");

// sortMedian5: allocates [| a;b;c;d;e |] on GC heap, bubble-sorts in-place, returns arr.[2]
check("sortMedian5(5,3,1,4,2)→3", 3, mc.sortMedian5(5, 3, 1, 4, 2));
check("sortMedian5(10,10,10,5,15)→10", 10, mc.sortMedian5(10, 10, 10, 5, 15));
check("sortMedian5(100,1,50,25,75)→50", 50, mc.sortMedian5(100, 1, 50, 25, 75));
check("sortMedian5(1,1,1,1,1)→1", 1, mc.sortMedian5(1, 1, 1, 1, 1));

// countAbove: Array.filter with closure — higher-order function over GC array
// [10,20,30,40,50] above 25 → [30,40,50] → length 3
check(
  "countAbove(10,20,30,40,50,25)→3",
  3,
  mc.countAbove(10, 20, 30, 40, 50, 25),
);
check("countAbove(1,2,3,4,5,10)→0", 0, mc.countAbove(1, 2, 3, 4, 5, 10));
check("countAbove(1,2,3,4,5,0)→5", 5, mc.countAbove(1, 2, 3, 4, 5, 0));
check("countAbove(5,5,5,5,5,4)→5", 5, mc.countAbove(5, 5, 5, 5, 5, 4));

// ── MathCore: GC STRING showcase ─────────────────────────────────────────────
console.log("\n─── MathCore: GC strings ────────────────────────────\n");

// greetingLen: selects a string literal by branch, returns .Length
// "Hi!" = 3, "Hello!" = 6, "Hello, friend!" = 14
check('greetingLen(0)→3  ("Hi!")', 3, mc.greetingLen(0));
check('greetingLen(3)→6  ("Hello!")', 6, mc.greetingLen(3));
check('greetingLen(10)→14 ("Hello, friend!")', 14, mc.greetingLen(10));

// ── App: primitives wired through MathCore ────────────────────────────────────
console.log("\n─── App: cross-module primitive calls ───────────────\n");

check("sumOfFibs(4)", 7, app.sumOfFibs(4));
check("sumOfFibs(7)", 33, app.sumOfFibs(7));
checkF("magnitudeSquared(3,4)", 25, app.magnitudeSquared(3, 4));
check("triangleNumber(10)", 55, app.triangleNumber(10));

// ── App: GC ARRAY showcase — collect cross-module results into a local GC array
console.log("\n─── App: GC arrays (cross-module results collected) ─\n");

// powersAndSum([1,2,3,4,5], exp=2) = 1+4+9+16+25 = 55
// Each square is computed by MathCore.intPow (cross-module import),
// stored in a WasmGC array inside App, then summed by a loop inside App.
check("powersAndSum(1,2,3,4,5)→55", 55, app.powersAndSum(1, 2, 3, 4, 5));
check("powersAndSum(2,2,2,2,2)→20", 20, app.powersAndSum(2, 2, 2, 2, 2));
check("powersAndSum(1,1,1,1,1)→5", 5, app.powersAndSum(1, 1, 1, 1, 1));
check("powersAndSum(3,4,0,0,0)→25", 25, app.powersAndSum(3, 4, 0, 0, 0));

// medianIsEven: delegates sort to MathCore, checks parity in App
// sortMedian5(5,3,1,4,2)=3 → odd → 0
check(
  "medianIsEven(5,3,1,4,2)→0 (median 3 is odd)",
  0,
  app.medianIsEven(5, 3, 1, 4, 2),
);
// sortMedian5(10,10,10,5,15)=10 → even → 1
check(
  "medianIsEven(10,10,10,5,15)→1 (median 10 is even)",
  1,
  app.medianIsEven(10, 10, 10, 5, 15),
);

// ── App: GC STRING showcase ───────────────────────────────────────────────────
console.log("\n─── App: GC strings (concat, branch, .Length) ───────\n");

// parityLabel: builds "even"/"odd" strings, concatenates with "+", returns .Length
// All strings are GC-managed (array i32) — no null terminators, no buffer overflow.
check('parityLabel(2, 4)→9  ("even+even")', 9, app.parityLabel(2, 4));
check('parityLabel(1, 2)→8  ("odd+even")', 8, app.parityLabel(1, 2));
check('parityLabel(2, 1)→8  ("even+odd")', 8, app.parityLabel(2, 1));
check('parityLabel(1, 3)→7  ("odd+odd")', 7, app.parityLabel(1, 3));

// gradeMessage: maps score to label string, returns its length
// "Excellent"=9, "Good"=4, "Pass"=4, "Borderline"=10, "Fail"=4
check("gradeMessage(95)→9  (Excellent)", 9, app.gradeMessage(95));
check("gradeMessage(85)→4  (Good)", 4, app.gradeMessage(85));
check("gradeMessage(72)→4  (Pass)", 4, app.gradeMessage(72));
check("gradeMessage(62)→10 (Borderline)", 10, app.gradeMessage(62));
check("gradeMessage(50)→4  (Fail)", 4, app.gradeMessage(50));

// ─────────────────────────────────────────────────────────────────────────────
console.log(
  `\n─── Result: ${pass} passed, ${fail} failed ─────────────────────\n`,
);
if (fail > 0) process.exit(1);
