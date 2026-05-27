#!/usr/bin/env bash
# QuickTest runner — supports all-in-one and per-domain modes.
# Usage:
#   ./run.sh                  — compile + run all 498 tests
#   ./run.sh Array            — compile + run only the Array domain
#   ./run.sh --multi          — compile each domain separately, link, run
#   ./run.sh --list           — show all available domains
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUT="$SCRIPT_DIR/output"
# FABLE="${FABLE:-dotnet fable --lang wasmgc}"
FABLE="dotnet run --project ${ROOT}/tools/FSharp.Wasm.Cli"
NODE="${NODE:-node}"

DOMAINS=(Array Bitwise Closures DU Exceptions Interop List Map Math Option \
         Primitives Printf Result Seq Set StringBuilder Strings)

mkdir -p "$OUT"

case "${1:-}" in

  --list)
    echo "Available domains:"
    for d in "${DOMAINS[@]}"; do echo "  $d"; done
    ;;

  --multi)
    # ── Multi-domain mode ───────────────────────────────────────────────────
    # Compile each domain independently, then link via our static linker.
    echo ""
    echo "📦 Multi-domain compilation mode"
    echo "════════════════════════════════════════════════════════════════"
    echo "  Compiling ${#DOMAINS[@]} domains separately..."
    echo ""
    WASM_FILES=()
    for d in "${DOMAINS[@]}"; do
      echo "  ▶ $d..."
      $FABLE "$d/$d.fsproj" --outDir "$OUT/modules/$d" --noCache 2>&1 | tail -1
      if [ -f "$OUT/modules/$d/$d.wasm" ]; then
        WASM_FILES+=("$OUT/modules/$d/$d.wasm")
        echo "    ✓ $d.wasm"
      else
        echo "    ✗ FAILED: $d.wasm not found"
      fi
    done

    echo ""
    echo "  Linking ${#WASM_FILES[@]} modules..."
    # Use our WasmGC linker (dotnet tool or inline script)
    dotnet run --project "$ROOT/src/Fable.WasmGc.fsproj" -- \
      link "${WASM_FILES[@]}" --output "$OUT/QuickTestLinked.wasm" \
      2>&1 | tail -5

    echo ""
    echo "=== Running linked binary ==="
    $NODE --experimental-wasm-gc "$OUT/QuickTestLinked.wasm" \
      || echo "Note: use a WASM host (wasmtime/node) that supports WasmGC"
    ;;

  "")
    # ── All-in-one mode (default) ───────────────────────────────────────────
    echo ""
    echo "🔗 MultiEntry mode (all tests combined)"
    echo "════════════════════════════════════════════════════════════════"
    $FABLE MultiEntry/MultiEntry.fsproj --outDir "$OUT" --noCache 2>&1 \
      | grep -E 'Compiled|error|warning\[WGC' || true

    WASM="$OUT/MultiEntry.wasm"
    if [ ! -f "$WASM" ]; then
      echo "ERROR: $WASM not found after compilation"
      exit 1
    fi

    echo ""
    echo "=== Validating WASM binary ==="
    if command -v wasm-tools &>/dev/null; then
      wasm-tools validate "$WASM" --features gc && echo "✓ WASM binary valid"
    fi

    echo ""
    echo "=== Running tests ==="
    $NODE --experimental-wasm-exnref "$WASM" 2>&1
    ;;

  *)
    # ── Single domain mode ──────────────────────────────────────────────────
    DOMAIN="$1"
    if [[ ! " ${DOMAINS[*]} " =~ " $DOMAIN " ]]; then
      echo "Unknown domain '$DOMAIN'. Run with --list to see options."
      exit 1
    fi

    echo "=== QuickTest: $DOMAIN domain only ==="
    # Create a temporary single-domain fsproj
    TMP_FSPROJ="$OUT/QuickTest_${DOMAIN}.fsproj"
    cat > "$TMP_FSPROJ" << FSPROJEOF
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework><LangVersion>preview</LangVersion></PropertyGroup>
  <ItemGroup>
    <Compile Include="$ROOT/fable-library-wasmgc/Core/Interop.fs" />
    <Compile Include="$ROOT/fable-library-wasmgc/Collections/Map.fs" />
    <Compile Include="$ROOT/fable-library-wasmgc/Collections/Set.fs" />
    <Compile Include="Preamble.fs" />
    <Compile Include="Tests${DOMAIN}.fs" />
    <Compile Include="Runner.fs" />
  </ItemGroup>
</Project>
FSPROJEOF

    $FABLE "$TMP_FSPROJ" --outDir "$OUT" --noCache 2>&1 | tail -5
    WASM="$OUT/QuickTest_${DOMAIN}.wasm"
    [ -f "$WASM" ] && $NODE --experimental-wasm-gc "$WASM" || echo "Build failed"
    rm -f "$TMP_FSPROJ"
    ;;
esac
