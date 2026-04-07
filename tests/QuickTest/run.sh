#!/usr/bin/env bash
# Compile the WasmGc quicktest and run the Node.js test suite.
# Sprint 1:  emits both .wat (human-readable) and .wasm (binary for tests) in one pass.
# Sprint 5:  wasm-tools validate added — catches binary encoding bugs early.
# Sprint 11b: WIT generation + wasm-tools Component Model wrapping.
#   wasm-tools is the modern WasmGC toolchain (Bytecode Alliance); wabt does NOT support (sub ...).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/output"

echo ""
echo "=== 1/4  Compiling F# → WasmGc (WAT + WASM + WIT) ==="
dotnet run --project "$ROOT/vendor/Fable/src/Fable.Cli" -- \
    "$HERE" \
    --lang wasmgc \
    --outDir "$OUT" \
    --noCache

echo ""
echo "=== 2/4  Validating WASM binary (wasm-tools) ==="
if command -v wasm-tools &>/dev/null; then
    wasm-tools validate "$OUT/QuickTestWasmGc.wasm" --features gc
    echo "    ✅ wasm-tools validate passed"
else
    echo "    ⚠️  wasm-tools not found — skipping validation (install via: cargo install wasm-tools OR nix)"
fi

echo ""
echo "=== 3/4  Component Model (wasm-tools) ==="
WIT_DIR="$OUT/wit"
COMPONENT="$OUT/QuickTestWasmGc-component.wasm"
if command -v wasm-tools &>/dev/null && [ -d "$WIT_DIR" ]; then
    EMBEDDED="$OUT/QuickTestWasmGc-embedded.wasm"
    if wasm-tools component embed "$WIT_DIR" "$OUT/QuickTestWasmGc.wasm" -o "$EMBEDDED" 2>&1 \
       && wasm-tools component new "$EMBEDDED" -o "$COMPONENT" 2>&1; then
        echo "    ✅ Component created: $COMPONENT"
    else
        echo "    ⚠️  Component Model wrapping failed (WIT may contain identifiers not yet valid in WIT syntax)"
        echo "    ℹ️  WIT world written to $WIT_DIR"
    fi
elif [ -d "$WIT_DIR" ]; then
    echo "    ℹ️  WIT world written to $WIT_DIR"
    echo "    ℹ️  Install wasm-tools to create a Component: cargo install wasm-tools"
else
    echo "    ⚠️  No WIT output (no primitive-type exports found)"
fi

echo ""
echo "=== 4/4  Running Node.js test suite ==="
node --experimental-wasm-exnref "$HERE/test-runner.mjs"
