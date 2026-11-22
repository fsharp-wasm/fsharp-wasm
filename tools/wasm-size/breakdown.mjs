// Where the bytes of a compiled module are: its sections, and the size of the code of its functions added up by the part of the program they come from.
//   node tools/wasm-size/breakdown.mjs <module.wasm> [--top 25] [--functions 15]
//   --others N   also list the N largest functions that no group claims
// The name of a function is `Module_function` (what the compiler writes into the name section), so the part before the first underscore is the F# module or type it came from;
// helpers the compiler makes itself (`$host_…`, `__str_…`, the generic instances) have their own groups. A module without a name section can only be told by section.
import { readFileSync } from "node:fs";

const [file, ...rest] = process.argv.slice(2);
if (!file) { console.error("usage: breakdown.mjs <module.wasm> [--top N] [--functions N]"); process.exit(2); }
const flag = (name, fallback) => { const i = rest.indexOf(`--${name}`); return i >= 0 ? Number(rest[i + 1]) : fallback; };
const bytes = readFileSync(file);

let pos = 8;                                                   // magic and version
const u32 = () => { let r = 0, shift = 0, b; do { b = bytes[pos++]; r |= (b & 0x7f) << shift; shift += 7; } while (b & 0x80); return r >>> 0; };
const text = (n) => { const s = bytes.toString("utf8", pos, pos + n); pos += n; return s; };
const sectionNames = { 1: "type", 2: "import", 3: "function", 4: "table", 5: "memory", 6: "global", 7: "export", 8: "start", 9: "element", 10: "code", 11: "data", 12: "data count", 13: "tag" };

const sections = [];                                           // { name, bytes }
let importedFunctions = 0, bodies = [], names = new Map();
while (pos < bytes.length) {
  const id = bytes[pos++]; const size = u32(); const end = pos + size; const start = pos;
  if (id === 0) {                                              // a custom section: only "name" is read
    const name = text(u32());
    sections.push({ name: `custom "${name}"`, bytes: size });
    if (name === "name") while (pos < end) {
      const sub = bytes[pos++]; const subSize = u32(); const subEnd = pos + subSize;
      if (sub === 1) for (let n = u32(); n > 0; n--) { const idx = u32(); names.set(idx, text(u32())); }
      pos = subEnd;
    }
  } else {
    sections.push({ name: sectionNames[id] ?? `section ${id}`, bytes: size });
    if (id === 2) for (let n = u32(); n > 0; n--) {            // imports: count the functions, they come first in the index space
      text(u32()); text(u32()); const kind = bytes[pos++];
      if (kind === 0) { u32(); importedFunctions++; } else if (kind === 1) { pos++; const f = bytes[pos++]; u32(); if (f & 1) u32(); } else if (kind === 2) { const f = bytes[pos++]; u32(); if (f & 1) u32(); } else if (kind === 3) { pos += 2; } else { u32(); u32(); }
    }
    if (id === 10) for (let n = u32(); n > 0; n--) { const size = u32(); bodies.push(size); pos += size; }
  }
  pos = end;
}

const group = (name) => {
  if (!name) return "(no name)";
  const n = name.replace(/^\$/, "");
  if (/^(host|str|__str|__)/.test(n)) return "(runtime and host glue)";
  const m = /^([A-Z][A-Za-z0-9]*)_/.exec(n);
  return m ? m[1] : "(other)";
};
const groups = new Map(); const functions = [];
bodies.forEach((size, i) => {
  const name = names.get(importedFunctions + i) ?? `func ${importedFunctions + i}`;
  functions.push({ name, size });
  const g = group(name); const e = groups.get(g) ?? { bytes: 0, count: 0 }; e.bytes += size; e.count++; groups.set(g, e);
});
const code = bodies.reduce((a, b) => a + b, 0);
const pct = (n, of) => `${(n / of * 100).toFixed(1).padStart(5)} %`;

console.log(`${file}: ${bytes.length} bytes, ${bodies.length} functions defined (${importedFunctions} imported), ${names.size ? "names present" : "no name section"}\n`);
console.log("sections:");
for (const s of [...sections].sort((a, b) => b.bytes - a.bytes)) console.log(`  ${String(s.bytes).padStart(8)}  ${pct(s.bytes, bytes.length)}  ${s.name}`);
console.log(`\ncode of the functions by the part of the program they come from (${code} bytes):`);
for (const [g, e] of [...groups].sort((a, b) => b[1].bytes - a[1].bytes).slice(0, flag("top", 25))) console.log(`  ${String(e.bytes).padStart(8)}  ${pct(e.bytes, code)}  ${String(e.count).padStart(4)} functions  ${g}`);
if (flag("others", 0)) {
  console.log(`\nthe largest functions in (other):`);
  for (const f of functions.filter((f) => group(f.name) === "(other)").sort((a, b) => b.size - a.size).slice(0, flag("others", 0))) console.log(`  ${String(f.size).padStart(8)}  ${f.name}`);
}
console.log(`\nthe largest functions:`);
for (const f of functions.sort((a, b) => b.size - a.size).slice(0, flag("functions", 15))) console.log(`  ${String(f.size).padStart(8)}  ${f.name}`);
