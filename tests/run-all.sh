#!/usr/bin/env bash
# Run EVERY test suite in the repo, keep going after failures, print one summary table.
# Exit code is non-zero if any suite failed.
#
#   ./tests/run-all.sh                 run everything
#   ./tests/run-all.sh --list          list suites
#   ./tests/run-all.sh --only unit,quicktest,showcase
#   ./tests/run-all.sh --fail-fast     stop at the first failing suite
#   ./tests/run-all.sh --verbose       stream each suite's output live (default: log files + tail on failure)
#
# Logs: tests/.results/<suite>.log
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS="$ROOT/tests/.results"
mkdir -p "$RESULTS"

#        name           | command (run from repo root)
SUITES=(
  "unit|dotnet run -c Release --project tests/PassTests"
  "quicktest|tests/QuickTest/run.sh"
  "showcase|tests/Showcase/run.sh"
  "properties|tests/Differential/run-props.sh"
  "quicktestmulti|tests/QuickTestMulti/run.sh"
  "wasm|tests/Wasm/run-tests.sh"
  "bclbootstrap|tests/BclBootstrap/run.sh"
  "backendharness|tests/BackendHarness/run.sh"
  "component-embed|examples/component-embed/run.sh"
  "component-linking|examples/component-linking/run.sh"
  "wasmecto|fsharp-wasmecto/run-tests.sh"
)

ONLY=""; FAIL_FAST=0; VERBOSE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --list)       for s in "${SUITES[@]}"; do echo "${s%%|*}"; done; exit 0 ;;
    --only)       ONLY=",$2,"; shift ;;
    --fail-fast)  FAIL_FAST=1 ;;
    --verbose|-v) VERBOSE=1 ;;
    -h|--help)    sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

# Scripts that swallow failures (exit 0 after printing ✗) are still caught by these markers.
FAIL_MARKERS='✗|FAILED|error\[WGC|failed to validate|[1-9][0-9]* failed|Unhandled exception'

names=(); results=(); times=()
print_summary() {
  echo; echo "══════════════════════════════════════════════════════════════"
  printf "  %-20s %-8s %s\n" SUITE RESULT TIME
  echo "──────────────────────────────────────────────────────────────"
  local failed=0
  for i in "${!names[@]}"; do
    printf "  %-20s %-8s %ss\n" "${names[$i]}" "${results[$i]}" "${times[$i]}"
    [ "${results[$i]}" = "PASS" ] || failed=$((failed+1))
  done
  echo "══════════════════════════════════════════════════════════════"
  echo "  $((${#names[@]}-failed))/${#names[@]} suites passed   (logs: tests/.results/)"
  return $failed
}
trap 'echo; echo "interrupted"; print_summary; exit 130' INT

for entry in "${SUITES[@]}"; do
  name="${entry%%|*}"; cmd="${entry#*|}"
  [ -n "$ONLY" ] && [[ "$ONLY" != *",$name,"* ]] && continue
  script="${cmd%% *}"
  if [[ "$cmd" != dotnet* ]] && [ ! -f "$ROOT/$script" ]; then
    names+=("$name"); results+=("MISSING"); times+=("0"); continue
  fi

  log="$RESULTS/$name.log"
  echo; echo "▶ $name   ($cmd)"
  start=$SECONDS
  if [ "$VERBOSE" = 1 ]; then
    ( cd "$ROOT" && bash -c "$cmd" ) 2>&1 | tee "$log"; rc=${PIPESTATUS[0]}
  else
    ( cd "$ROOT" && bash -c "$cmd" ) >"$log" 2>&1; rc=$?
  fi
  dur=$((SECONDS-start))

  verdict=PASS
  if [ "$rc" -ne 0 ]; then verdict=FAIL
  elif grep -Eq "$FAIL_MARKERS" "$log"; then verdict="FAIL*"; fi
  names+=("$name"); results+=("$verdict"); times+=("$dur")

  if [ "$verdict" != PASS ]; then
    echo "  ✗ $verdict (exit $rc) — last lines of $log:"
    tail -n 12 "$log" | sed 's/^/    | /'
    [ "$FAIL_FAST" = 1 ] && break
  else
    echo "  ✓ PASS (${dur}s)"
  fi
done

print_summary; exit $?
