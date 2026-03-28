#!/usr/bin/env bash
# Build MathCore: F# → WasmGC (WAT + WASM + WIT world)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/output"

# Always delete prior output so Fable's per-file freshness check forces a full recompile.
rm -f "$OUT"/*.wasm "$OUT"/*.wat "$OUT"/*-embedded.wasm "$OUT"/*-component.wasm

echo ""
echo "=== MathCore: Compiling F# → WasmGc ==="
dotnet run --project "$ROOT/vendor/Fable/src/Fable.Cli" -- \
    "$HERE" \
    --lang wasmgc \
    --outDir "$OUT" \
    --noCache \
    --noParallelTypeCheck

echo ""
echo "=== MathCore: Validating WASM binary ==="
if command -v wasm-tools &>/dev/null; then
    wasm-tools validate "$OUT/MathCore.wasm" --features gc
    echo "    ✅ wasm-tools validate passed"
else
    echo "    ⚠️  wasm-tools not found — skipping validation"
fi

echo "    Output: $OUT/MathCore.wasm"
