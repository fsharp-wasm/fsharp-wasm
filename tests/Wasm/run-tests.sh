#!/usr/bin/env bash
# run-tests.sh — compile and run Wasmecto tests via wasmtime
# Usage: ./run-tests.sh [test-project-dir]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR" && pwd)"
FSHARP_WASM="${FSHARP_WASM:-$ROOT/../..}"
TEST_PROJ="${1:-$ROOT/Wasmecto.WasmTests.fsproj}"
OUT="$ROOT/dist"

mkdir -p "$OUT"

echo "==> Compiling Wasmecto + tests via fsharp-wasm..."
dotnet run --project "$FSHARP_WASM/tools/FSharp.Wasm.Cli" -- \
    "$TEST_PROJ" \
    --outDir "$OUT"

echo "==> Running tests in wasmtime..."
wasmtime run "$OUT/wasmtests.wasm" 2>&1
STATUS=$?

if [ $STATUS -eq 0 ]; then
    echo "All tests passed."
else
    echo "FAILED: $STATUS test(s) failed."
fi

exit $STATUS
