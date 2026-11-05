import fs from 'node:fs';
import { execFileSync } from 'node:child_process';
const dir = '/home/claude/out_ops';
const names = [...new Set(fs.readdirSync(dir).map(f => f.replace(/\.(wat|wasm)$/, '')))].sort();
const bad = { bin: [], wat: [] };
// convert all WATs at once with python (one process)
const py = `
import wasmtime, sys, os
d='${dir}'
for f in sorted(os.listdir(d)):
    if f.endswith('.wat'):
        try:
            open(os.path.join(d, f[:-4]+'.watbin'),'wb').write(bytes(wasmtime.wat2wasm(open(os.path.join(d,f),encoding='utf-8').read())))
        except Exception as e:
            open(os.path.join(d, f[:-4]+'.watbin.err'),'w').write(str(e)[:300])
`;
execFileSync('python3', ['-c', py]);
for (const n of names) {
  for (const [kind, file] of [['bin', n + '.wasm'], ['wat', n + '.watbin']]) {
    const p = dir + '/' + file;
    if (!fs.existsSync(p)) { bad[kind].push(`${n}: ${fs.existsSync(p + '.err') ? 'WAT parse error' : 'no output'}`); continue; }
    try { new WebAssembly.Module(fs.readFileSync(p)); }
    catch (e) { bad[kind].push(`${n}: ${e.message.split('\n')[0].slice(0, 110)}`); }
  }
}
console.log(`combinations: ${names.length}`);
console.log(`binary encoder failures: ${bad.bin.length}`); bad.bin.slice(0, 40).forEach(x => console.log('  BIN ' + x));
console.log(`WAT path failures:      ${bad.wat.length}`); bad.wat.slice(0, 40).forEach(x => console.log('  WAT ' + x));
