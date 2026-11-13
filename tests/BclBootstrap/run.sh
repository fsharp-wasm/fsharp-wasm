#!/usr/bin/env bash
# Compile core/FSharp.Wasm.Core/Exception.fs (fsharp-wasm-core) through our WasmGC backend and run tests.

set -x 
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
CORE="${FSHARP_WASM_CORE_DIR:-$ROOT/core}"
if [ ! -f "$CORE/FSharp.Wasm.Core/Exception.fs" ]; then
  echo "SKIP: no Exception.fs in the core library (init the core submodule, or set FSHARP_WASM_CORE_DIR to a checkout of fsharp-wasm-core)"
  exit 77
fi
export FSHARP_WASM_CORE_DIR="$CORE"
OUT="$HERE/output"
mkdir -p "$OUT"

echo ""
echo "=== BCL Bootstrap: Compiling Exception.fs ===" 
dotnet run --project "$ROOT/tools/FSharp.Wasm.Cli" -- \
    "$HERE" \
    --outDir "$OUT" \
    --noCache

echo ""
echo "=== Validating WASM ==="
wasm-tools validate "$OUT"/*.wasm && echo "✓ valid"

echo ""
echo "=== Running tests ==="
HERE="$HERE" node - <<'NODEEOF'   # stdin script: import.meta.url is the CWD, so pass the directory explicitly
import { readFileSync } from 'fs';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dir = process.env.HERE;
const wasm = readFileSync(resolve(__dir, 'output', 'BclBootstrapTests.wasm'));
const { instance } = await WebAssembly.instantiate(wasm, {
  env: { consolePrint: () => {} }
});
const e = instance.exports;

const tests = [
  ['testMathAbsInt → 42',                    () => e.testMathAbsInt(),                   42],
  ['testMathAbsFloat → 1',                   () => e.testMathAbsFloat(),                  1],
  ['testMathSignNeg → -1',                   () => e.testMathSignNeg(),                  -1],
  ['testMathSignPos → 1',                    () => e.testMathSignPos(),                   1],
  ['testMathMinInt → 3',                     () => e.testMathMinInt(),                    3],
  ['testMathMaxInt → 7',                     () => e.testMathMaxInt(),                    7],
  ['testMathConstPI → 1',                    () => e.testMathConstPI(),                   1],
  ['testExceptionBasic → 1',                 () => e.testExceptionBasic(),                1],
  ['testArgumentExceptionParam → 1',         () => e.testArgumentExceptionParam(),        1],
  ['testThrowCatchArgumentException → 42',   () => e.testThrowCatchArgumentException(),  42],
  ['testDiscriminateExcType → 1',            () => e.testDiscriminateExcType(),           1],
];

let passed = 0, failed = 0;
for (const [name, fn, expected] of tests) {
  try {
    const got = fn();
    if (got === expected) { console.log(`  ✓  ${name}: ${got}`); passed++; }
    else                  { console.log(`  ✗  ${name}: expected ${expected}, got ${got}`); failed++; }
  } catch(ex) { console.log(`  ✗  ${name}: threw ${ex?.message ?? ex}`); failed++; }
}
console.log(`\n  ${passed} passed, ${failed} failed`);
if (failed > 0) process.exit(1);
NODEEOF
