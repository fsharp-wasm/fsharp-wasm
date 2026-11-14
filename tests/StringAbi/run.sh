#!/usr/bin/env bash
# The Exports string ABI: compile with WASMGC_STRING_ABI=exports, validate, and run on Node with a host that needs no builtins.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/output"

echo ""
echo "=== 1/3  Compiling F# → WasmGc (string ABI: exports) ==="
WASMGC_STRING_ABI=exports dotnet run --project "$ROOT/tools/FSharp.Wasm.Cli" -- \
    "$HERE" \
    --outDir "$OUT" \
    --noCache

echo ""
echo "=== 2/3  Validating WASM binary ==="
if command -v wasm-tools &>/dev/null; then
    wasm-tools validate "$OUT/StringAbi.wasm" --features gc
    echo "    ✅ wasm-tools validate passed"
else
    echo "    ⚠️  wasm-tools not found — skipping validation"
fi

echo ""
echo "=== 3/3  Running on a host without the JS String Builtins ==="
node "$HERE/run.mjs"
