#!/usr/bin/env bash
# Component-linking example: compile MathCore + App, then run combined Node.js tests.
# Demonstrates two independent F# WasmGC modules composed at Wasm runtime.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Component Linking Example: MathCore + App               ║"
echo "╚══════════════════════════════════════════════════════════╝"

# ── Step 1: compile MathCore ─────────────────────────────────────
bash "$HERE/MathCore/run.sh"

# ── Step 2: compile App ──────────────────────────────────────────
bash "$HERE/App/run.sh"

# ── Step 3: combined runtime test ────────────────────────────────
echo ""
echo "=== Running combined test (MathCore + App instantiated together) ==="
node "$HERE/test-runner.mjs" \
    "$HERE/MathCore/output/MathCore.wasm" \
    "$HERE/App/output/App.wasm"
