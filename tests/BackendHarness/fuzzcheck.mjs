// node --experimental-wasm-exnref fuzzcheck.mjs <dir>
// Compares V8 results of {optimized, unoptimized} × {binary encoder, WAT→wasm-tools parse} with the reference
// interpreter's expectations in <dir>/expected.json.  Exit code 1 on any mismatch.
import fs from 'node:fs';
import { execFileSync } from 'node:child_process';
const dir = process.argv[2];
const exp = JSON.parse(fs.readFileSync(dir + '/expected.json', 'utf8'));
const watErr = {};
for (const n of ['opt', 'noopt']) {
  try { execFileSync('wasm-tools', ['parse', `${dir}/${n}.wat`, '-o', `${dir}/${n}.watbin`], { stdio: 'pipe' }); }
  catch (e) { watErr[n] = String(e.stderr).split('\n').slice(0, 2).join(' | '); }
}
const variants = { 'opt/bin': 'opt.wasm', 'opt/wat': 'opt.watbin', 'noopt/bin': 'noopt.wasm', 'noopt/wat': 'noopt.watbin' };
let total = 0, bad = 0; const shown = {};
for (const [vname, file] of Object.entries(variants)) {
  const key = file.replace('.watbin', '');
  if (file.endsWith('.watbin') && watErr[key]) { console.log(`${vname.padEnd(10)} WAT PARSE ERROR: ${watErr[key].slice(0, 160)}`); bad++; continue; }
  let inst;
  try { inst = (await WebAssembly.instantiate(fs.readFileSync(dir + '/' + file), { env: { consolePrint() {} } })).instance; }
  catch (e) { console.log(`${vname.padEnd(10)} INVALID MODULE: ${e.message.slice(0, 200)}`); bad++; continue; }
  let vbad = 0;
  for (const f of exp.funcs) {
    const fn = inst.exports[f.name];
    exp.inputs.forEach(([a, b], k) => {
      total++;
      let got;
      try { got = String(fn(a, b)); } catch (e) { got = /unreachable|divide|remainder|unrepresentable|overflow|out of bounds/i.test(e.message) ? 'trap' : 'EXC:' + e.message.slice(0, 40); }
      if (got !== f.expected[k]) {
        vbad++; bad++;
        if ((shown[vname] = (shown[vname] || 0) + 1) <= 3)
          console.log(`  MISMATCH ${vname} ${f.name}(a=${a}, b=${b}): expected ${f.expected[k]}, got ${got}\n    ${f.src.slice(0, 260)}`);
      }
    });
  }
  console.log(`${vname.padEnd(10)} ${vbad === 0 ? 'OK' : vbad + ' mismatches'}`);
}
console.log(`${exp.funcs.length} functions x ${exp.inputs.length} inputs x 4 variants = ${total} checks, ${bad} failures`);
process.exit(bad ? 1 : 0);
