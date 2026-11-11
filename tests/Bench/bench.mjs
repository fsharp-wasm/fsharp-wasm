// wasm side of the benchmark: node bench.mjs <module.wasm>  → "name checksum best-ms" per benchmark (same sizes as Program.fs)
import { readFileSync } from 'node:fs';
import { performance } from 'node:perf_hooks';
const sizes = { bench_fib: 32, bench_loop: 200000, bench_sieve: 2000000, bench_collatz: 300000, bench_float: 5000000,
  bench_list: 1000000, bench_array: 1000000, bench_sort: 3000, bench_tree: 100000, bench_closure: 1000000,
  bench_string: 200000, bench_record: 5000000 };
const bytes = readFileSync(process.argv[2]);
const { instance } = await WebAssembly.instantiate(bytes, new Proxy({}, { get: (_, m) => new Proxy({}, { get: (_, n) => () => 0 }) }));
const ex = instance.exports;
for (const [name, n] of Object.entries(sizes)) {
  const f = ex[name];
  if (!f) { console.log(`${name} missing`); continue; }
  let checksum;
  try { checksum = f(n); } catch (e) { console.log(`${name} trap ${e.message.split('\n')[0]}`); continue; }
  let best = Infinity;
  for (let i = 0; i < 7; i++) { const t = performance.now(); f(n); best = Math.min(best, performance.now() - t); }
  console.log(`${name} ${checksum} ${best.toFixed(3)}`);
}
