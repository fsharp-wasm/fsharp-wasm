#!/usr/bin/env bash
# Differential test: run the same F# functions on .NET (reference) and as WasmGC, compare the results.
#
#   tests/Differential/run.sh <project-dir> <module.wasm> [name-prefix]
#   e.g.  tests/Differential/run.sh tests/QuickTest tests/QuickTest/output/QuickTestWasmGc.wasm test
#
# The wasm must already be compiled (tests/QuickTest/run.sh does that).  Needs: dotnet, node, FSHARP_COMPILER.
# Functions that raise on .NET (extern stubs, `nativeOnly`) are skipped; DIFF_VERBOSE=1 lists them.
# Disagreements that are understood belong in known-differences.txt (name + reason), never silently ignored.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJECT="$(cd "$1" && pwd)"
WASM="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
PREFIX="${3:-}"
OUT="$HERE/output/$(basename "$PROJECT")"
mkdir -p "$OUT"

echo "=== 1/3  Build the reference assembly (.NET) ==="
dotnet build "$PROJECT"/*.fsproj -c Release -v q -nologo 2>&1 | grep -E "error|Build succeeded" | sort -u || true
DLL="$(ls -t "$PROJECT"/bin/Release/net*/"$(basename "$PROJECT"/*.fsproj .fsproj)".dll | head -n1)"

echo "=== 2/3  Run on .NET ==="
dotnet run -c Release --project "$HERE/Reference" -- "$DLL" "$OUT/reference.json" "$PREFIX"

echo "=== 3/3  Run as wasm and compare ==="
node --experimental-wasm-exnref "$HERE/compare.mjs" "$WASM" "$OUT/reference.json" "$HERE/known-differences.txt"
