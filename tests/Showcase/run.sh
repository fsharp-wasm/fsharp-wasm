#!/usr/bin/env bash
# Showcase: compile F# → WasmGC and run test-runner.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/output"

echo ""
echo "=== 1/3  Compiling F# → WasmGc ==="
dotnet run --project "$ROOT/vendor/Fable/src/Fable.Cli" -- \
    "$HERE" \
    --lang wasmgc \
    --outDir "$OUT" \
    --noCache

echo ""
echo "=== 2/3  Validating WASM binary ==="
if command -v wasm-tools &>/dev/null; then
    wasm-tools validate "$OUT/Showcase.wasm" --features gc
    echo "    ✅ wasm-tools validate passed"
else
    echo "    ⚠️  wasm-tools not found — skipping validation"
fi

echo ""
echo "=== 3/3  Running showcase test suite ==="
node --experimental-wasm-exnref "$HERE/test-runner.mjs"
