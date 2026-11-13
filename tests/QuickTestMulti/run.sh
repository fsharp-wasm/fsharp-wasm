#!/usr/bin/env bash
# QuickTestMulti runner — per-domain isolation by default, so a failure
# points at exactly which compiler area broke (Array, Closures, Map, ...).
#
# Usage:
#   ./run.sh                  — compile + run EVERY domain separately, print a summary  (default)
#   ./run.sh Array             — compile + run only the Array domain, full detail
#   ./run.sh --combined        — old behavior: all domains in ONE MultiEntry.wasm
#   ./run.sh --list            — show all available domains
#
# All paths are anchored to SCRIPT_DIR — this script works from any cwd.
#
# Per-domain projects are generated on the fly as self-contained Exe fsprojs
# (Interop.fs + Map.fs + Set.fs + Preamble.fs + Tests<Domain>.fs + Runner.fs).
# The checked-in Array.fsproj/List.fsproj are OutputType=Library for the
# static linker (--combined path's sibling, not currently wired into this
# script) and have no entry point — they can't run standalone with Node,
# so per-domain runs always use the generated Exe project below.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUT="$SCRIPT_DIR/output"
FABLE="dotnet run --project $ROOT/tools/FSharp.Wasm.Cli --"
NODE="${NODE:-node}"

DOMAINS=(Array Bitwise Closures DU Exceptions Interop List Map Math Option \
         Primitives Printf Result Seq Set StringBuilder Strings)

mkdir -p "$OUT"

gen_domain_fsproj() {
    local d="$1"
    local fsproj="$2"
    cat > "$fsproj" << FSPROJEOF
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
    <LangVersion>preview</LangVersion>
  </PropertyGroup>
  <ItemGroup>
    <Compile Include="$ROOT/core/FSharp.Wasm.Core/Interop.fs" />
    <Compile Include="$ROOT/core/FSharp.Wasm.Core/Collections/Map.fs" />
    <Compile Include="$ROOT/core/FSharp.Wasm.Core/Collections/Set.fs" />
    <Compile Include="$SCRIPT_DIR/Preamble.fs" />
    <Compile Include="$SCRIPT_DIR/Tests${d}.fs" />
    <!-- Compile Include="$SCRIPT_DIR/Runner.fs" / -->
  </ItemGroup>
</Project>
FSPROJEOF
}

# ── per-domain compile + run, full CLI detail (no grep filtering) ──────────
run_domain() {
    local d="$1"
    local domain_out="$OUT/$d"
    mkdir -p "$domain_out"

    echo ""
    echo "────────────────────────────────────────────────────────────────"
    echo "▶ $d"
    echo "────────────────────────────────────────────────────────────────"

    local tests_fs="$SCRIPT_DIR/Tests${d}.fs"
    if [ ! -f "$tests_fs" ]; then
        echo "  ✗ FAILED: $tests_fs not found"
        return 1
    fi

    local fsproj="$domain_out/QuickTest_${d}.fsproj"
    gen_domain_fsproj "$d" "$fsproj"

    # Full detail by default — no grep filter. Tee so it's visible live AND
    # saved for later inspection without re-running.
    local log="$domain_out/compile.log"
    rm -f "$domain_out"/*.wasm "$domain_out"/*.wat "$OUT/Tests${d}".wasm "$OUT/Tests${d}".wat   # never validate a stale artifact
    if ! $FABLE "$fsproj" --outDir "$domain_out" --noCache --verbose 2>&1 | tee "$log"; then
        echo "  ✗ FAILED: compilation error (see $log)"
        return 1
    fi

    # The CLI lays its output out relative to the project directory.  The generated project lives in
    # $domain_out while the sources are one level up, so Tests<Domain>.wasm/.wat land in $OUT: pull them in.
    for ext in wasm wat; do
        [ -f "$OUT/Tests${d}.$ext" ] && mv -f "$OUT/Tests${d}.$ext" "$domain_out/"
    done

    # The CLI names the module after the LAST source file (Tests<Domain>.wasm), not after the
    # generated project.  Prefer that name, else take the newest .wasm in the output dir.
    local wasm="$domain_out/Tests${d}.wasm"
    if [ ! -f "$wasm" ]; then
        wasm="$(find "$domain_out" -maxdepth 1 -name '*.wasm' -printf '%T@ %p\n' 2>/dev/null \
                 | sort -nr | head -n1 | cut -d' ' -f2- || true)"
    fi
    if [ -z "$wasm" ] || [ ! -f "$wasm" ]; then
        echo "  ✗ FAILED: no .wasm produced in $domain_out (see $log)"
        return 1
    fi

    if command -v wasm-tools &>/dev/null; then
        if ! wasm-tools validate "$wasm" --features gc 2>&1 | tee "$domain_out/validate.log"; then
            echo "  ✗ FAILED: wasm-tools validate"
            return 1
        fi
    fi

    if ! $NODE --experimental-wasm-exnref "$wasm" 2>&1 | tee "$domain_out/run.log"; then
        echo "  ✗ FAILED: runtime error (see $domain_out/run.log)"
        return 1
    fi

    echo "  ✓ $d passed"
    return 0
}

run_all_separately() {
    echo ""
    echo "🔍 Per-domain mode — ${#DOMAINS[@]} domains, isolated compile+run"
    echo "════════════════════════════════════════════════════════════════"

    local passed=() failed=()
    for d in "${DOMAINS[@]}"; do
        if run_domain "$d"; then
            passed+=("$d")
        else
            failed+=("$d")
        fi
    done

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Summary: ${#passed[@]}/${#DOMAINS[@]} domains passed"
    echo "════════════════════════════════════════════════════════════════"
    if [ ${#passed[@]} -gt 0 ]; then
        echo "  ✓ Passed: ${passed[*]}"
    fi
    if [ ${#failed[@]} -gt 0 ]; then
        echo "  ✗ Failed: ${failed[*]}"
        echo ""
        echo "  Per-domain logs: $OUT/<Domain>/{compile,validate,run}.log"
        exit 1
    fi
}

case "${1:-}" in

  --list)
    echo "Available domains:"
    for d in "${DOMAINS[@]}"; do echo "  $d"; done
    ;;

  --combined)
    # ── Old behavior: all domains compiled as ONE MultiEntry.wasm ──────────
    echo ""
    echo "🔗 Combined mode (all tests in one binary)"
    echo "════════════════════════════════════════════════════════════════"
    $FABLE "$SCRIPT_DIR/MultiEntry/MultiEntry.fsproj" --outDir "$OUT" --noCache --verbose 2>&1

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

  "")
    # ── Default: every domain, separately, with summary ────────────────────
    run_all_separately
    ;;

  *)
    # ── Single named domain ─────────────────────────────────────────────────
    DOMAIN="$1"
    if [[ ! " ${DOMAINS[*]} " =~ " $DOMAIN " ]]; then
      echo "Unknown domain '$DOMAIN'. Run with --list to see options."
      exit 1
    fi
    run_domain "$DOMAIN" || exit 1
    ;;
esac
