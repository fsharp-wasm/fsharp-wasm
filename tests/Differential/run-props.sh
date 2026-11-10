#!/usr/bin/env bash
# Property-style differential test: generated inputs, .NET reference vs wasm.
#   tests/Differential/run-props.sh            (env: DIFF_CASES, DIFF_SEED, DIFF_VERBOSE)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
PROPS="$HERE/Props"
OUT="$PROPS/output"

echo "=== Compiling the properties to wasm ==="
dotnet run --project "$ROOT/tools/FSharp.Wasm.Cli" -- "$PROPS" --outDir "$OUT" --noCache
wasm-tools validate "$OUT/Props.wasm" --features gc && echo "    ✅ wasm-tools validate passed"

bash "$HERE/run.sh" "$PROPS" "$OUT/Props.wasm" prop_
