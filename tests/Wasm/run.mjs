// node tests/Wasm/run.mjs <module.wasm> — runs a Wasmecto test module and exits with its number of failures.
// The module imports `wasmecto.writeLine` (TAP lines) and exports `wasmecto_run`; the host side of everything else
// (strings, closures) is the same ABI as tests/HostInterop, docs/host-interop.md.
import fs from "node:fs";
import { hostImports, compileOptions } from "../HostInterop/host.mjs";

const file = process.argv[2];
if (!file) { console.error("usage: run.mjs <module.wasm>"); process.exit(2); }

let instance;
const imports = {
  ...hostImports(() => instance),
  wasmecto: { writeLine: (line) => console.log(line) },
};
({ instance } = await WebAssembly.instantiate(fs.readFileSync(file), imports, compileOptions));
if (typeof instance.exports.wasmecto_run !== "function") {
  console.error(`${file}: no wasmecto_run export (the module was not built from a Wasmecto test project)`);
  process.exit(2);
}
const failures = instance.exports.wasmecto_run();
process.exit(failures === 0 ? 0 : 1);
