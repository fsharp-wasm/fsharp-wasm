// node --experimental-wasm-exnref run.mjs file.wasm name=arg,arg ...   (imports: env.consolePrint)
import fs from 'node:fs';
const [,, file, ...calls] = process.argv;
let inst;
try { inst = (await WebAssembly.instantiate(fs.readFileSync(file), { env: { consolePrint: () => {} } })).instance; }
catch (e) { console.log('INVALID:', e.message); process.exit(2); }
for (const c of calls) {
  const [name, ...a] = c.split(/[=,]/);
  try { console.log(name, '=>', inst.exports[name](...a.map(Number))); }
  catch (e) { console.log(name, 'TRAP:', e.message); }
}
