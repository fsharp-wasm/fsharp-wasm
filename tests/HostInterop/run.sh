#!/usr/bin/env bash
# Compile HostInterop.fs and run it against a JS host that implements the host interop ABI.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/output"

dotnet run --project "$ROOT/tools/FSharp.Wasm.Cli" -- "$HERE" --outDir "$OUT" --noCache
if command -v wasm-tools &>/dev/null; then wasm-tools validate "$OUT/HostInterop.wasm" --features gc; fi
node --expose-gc "$HERE/test-runner.mjs"
