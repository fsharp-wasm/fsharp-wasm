#!/usr/bin/env bash
# Property-style differential test: generated inputs, .NET reference vs wasm.
#   tests/Differential/run-props.sh            (env: DIFF_CASES, DIFF_SEED, DIFF_VERBOSE)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
PROPS="$HERE/Props"
OUT="$PROPS/output"

echo "=== Compiling the properties to wasm ==="
# never compare a stale module: the CLI names the module after the LAST source file, so an older build may sit beside it
mkdir -p "$OUT"
find "$OUT" -maxdepth 1 -type f \( -name '*.wasm' -o -name '*.wat' \) -delete
dotnet run --project "$ROOT/tools/FSharp.Wasm.Cli" -- "$PROPS" --outDir "$OUT" --noCache
WASM="$(ls -t "$OUT"/*.wasm | head -n1)"
wasm-tools validate "$WASM" --features gc && echo "    ✅ wasm-tools validate passed ($(basename "$WASM"))"

bash "$HERE/run.sh" "$PROPS" "$WASM" prop_
