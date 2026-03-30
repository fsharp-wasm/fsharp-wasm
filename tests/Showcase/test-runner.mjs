// Showcase test runner — verifies the WasmGC compiled showcase app.
import { readFileSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dir = dirname(fileURLToPath(import.meta.url));
const wasmPath = resolve(__dir, "output", "Showcase.wasm");

const buf = readFileSync(wasmPath);
const importObject = {
  env: {
    consolePrint: (_strRef) => {
      /* suppress printfn */
    },
  },
};
const { instance } = await WebAssembly.instantiate(buf, importObject);
const exp = instance.exports;

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

console.log("\n─── Showcase: WasmGC F# Compilation Demo ───────────────\n");

// ── Fibonacci ─────────────────────────────────────────────────────────────────
console.log("\n─── Recursion: Fibonacci ────────────────────────────────\n");
check("fib(10) = 55", 55, exp.showcaseFib10());
check("fib(20) = 6765", 6765, exp.showcaseFib20());

// ── Primes ────────────────────────────────────────────────────────────────────
console.log("\n─── Loops: Primality ────────────────────────────────────\n");
check("isPrime(97) = 1", 1, exp.showcaseIsPrime97());
check("isPrime(100) = 0", 0, exp.showcaseIsPrime100());
check("π(100) = 25", 25, exp.showcaseCountPrimesTo100());

// ── Project Euler ─────────────────────────────────────────────────────────────
console.log("\n─── Project Euler ───────────────────────────────────────\n");
check(
  "PE#1: sum multiples(3|5) < 1000 = 233168",
  233168,
  exp.showcaseSumMultiples35(),
);
check("PE#2: sum even fibs ≤ 4M = 4613732", 4613732, exp.showcaseSumEvenFibs());
check("Collatz(27) = 111 steps", 111, exp.showcaseCollatz27());

// ── FizzBuzz ──────────────────────────────────────────────────────────────────
console.log("\n─── FizzBuzz (1..100) ───────────────────────────────────\n");
// fizz=27, buzz=14, fb=6 → 27 | (14 << 8) | (6 << 16) = 396827
check("FizzBuzz counts encoded = 396827", 396827, exp.showcaseFizzBuzz());

// ── List operations ───────────────────────────────────────────────────────────
console.log("\n─── Lists ───────────────────────────────────────────────\n");
check("List.sum [1..100] = 5050", 5050, exp.showcaseListSum());
check("filter evens, sum = 110", 110, exp.showcaseListFilter());
check("map squares, sum = 55", 55, exp.showcaseListMap());
check("fold sum [1..10] = 55", 55, exp.showcaseListFold());

// ── Array ─────────────────────────────────────────────────────────────────────
console.log("\n─── Arrays ──────────────────────────────────────────────\n");
check("Array.init + fold = 55", 55, exp.showcaseArraySum());
check("Array.map *2, sum = 30", 30, exp.showcaseArrayMap());
check("Array.filter odds = 25", 25, exp.showcaseArrayFilter());

// ── Records ───────────────────────────────────────────────────────────────────
console.log("\n─── Records ─────────────────────────────────────────────\n");
check("Point {3,4}: dist² = 25", 25, exp.showcaseRecord());
check("Stats.Sum = 31", 31, exp.showcaseStats());
check("Stats.Max = 9", 9, exp.showcaseStatsMax());

// ── Sorting ───────────────────────────────────────────────────────────────────
console.log("\n─── Sorting ──────────────────────────────────────────────\n");
check("sortBy asc head = 1", 1, exp.showcaseSort());
check("sortBy desc head = 9", 9, exp.showcaseSortDesc());

// ── Strings ───────────────────────────────────────────────────────────────────
console.log("\n─── Strings ─────────────────────────────────────────────\n");
check("'Hello, WasmGC!'.Length = 14", 14, exp.showcaseStringLen());
check("'hello'.ToUpper().Length = 5", 5, exp.showcaseStringUpper());
check("Contains 'rocks' = 1", 1, exp.showcaseStringContains());


// ── Option ────────────────────────────────────────────────────────────────────
console.log("\n─── Option ──────────────────────────────────────────────\n");
check("safeDiv 10 2 = Some 5", 5, exp.showcaseSafeDiv());
check("safeDiv 10 0 = None → -1", -1, exp.showcaseSafeDivZero());

console.log(`\n────────────────────────────────────────────────────────`);
console.log(`  ${pass} passed, ${fail} failed`);
if (fail > 0) process.exit(1);
