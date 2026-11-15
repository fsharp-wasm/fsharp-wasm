#!/usr/bin/env bash
# Compile the Wasmecto test project with fsharp-wasm and run it in Node (WasmGC + the js-string builtins).
#   tests/Wasm/run-tests.sh [project.fsproj]
# The Wasmecto sources come from a sibling checkout of fsharp-wasmecto (FSHARP_WASMECTO_DIR overrides its location).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
export FSHARP_WASMECTO_DIR="${FSHARP_WASMECTO_DIR:-$ROOT/../fsharp-wasmecto}"
PROJ="${1:-$HERE/Wasmecto.WasmTests.fsproj}"
OUT="$HERE/output"

[ -d "$FSHARP_WASMECTO_DIR/src" ] || { echo "fsharp-wasmecto not found at $FSHARP_WASMECTO_DIR (set FSHARP_WASMECTO_DIR)" >&2; exit 2; }

echo "==> Compiling the tests with fsharp-wasm..."
rm -rf "$OUT"
dotnet run -c Release --project "$ROOT/tools/FSharp.Wasm.Cli" -- "$PROJ" --outDir "$OUT" --noCache

WASM="$(ls "$OUT"/*.wasm | head -1)"
command -v wasm-tools >/dev/null && wasm-tools validate "$WASM" --features gc

echo "==> Running $(basename "$WASM") in Node..."
node "$HERE/run.mjs" "$WASM"
