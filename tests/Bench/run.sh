#!/usr/bin/env bash
# Benchmarks: .NET (Release) vs wasm (node).  tests/Bench/run.sh   — prints a table; exit 1 on a checksum mismatch.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"; ROOT="$(cd "$HERE/../.." && pwd)"
OUT="$HERE/output"; mkdir -p "$OUT"; rm -f "$OUT"/*.wasm "$OUT"/*.wat "$HERE"/Bench.wasm "$HERE"/Bench.wat
echo "=== wasm: compile ==="
dotnet run --project "$ROOT/tools/FSharp.Wasm.Cli" -- "$HERE/Wasm" --outDir "$OUT" --noCache >"$OUT/compile.log" 2>&1 || { tail -20 "$OUT/compile.log"; exit 1; }
# Fable places the output next to the source file it compiled (Bench.fs, one level above the project)
WASM="$HERE/Bench.wasm"
wasm-tools validate "$WASM" --features gc
echo "=== .NET (Release) ==="
dotnet run -c Release --project "$HERE/Bench.fsproj" 2>/dev/null > "$OUT/dotnet.txt"
echo "=== wasm (node $(node --version)) ==="
node "$HERE/bench.mjs" "$WASM" > "$OUT/wasm.txt"
echo
printf "%-16s %12s %12s %8s   %s\n" benchmark ".NET ms" "wasm ms" "ratio" ""
status=0
while read -r name csum ms; do
  read -r wname wcsum wms < <(grep "^$name " "$OUT/wasm.txt" || echo "$name - -")
  ok=""; [ "$csum" = "$wcsum" ] || { ok="CHECKSUM $csum ≠ $wcsum"; status=1; }
  ratio=$(python3 -c "print('%.1fx' % (float('$wms')/float('$ms')))" 2>/dev/null || echo "-")
  printf "%-16s %12s %12s %8s   %s\n" "$name" "$ms" "$wms" "$ratio" "$ok"
done < "$OUT/dotnet.txt"
echo; echo "wasm module: $(stat -c %s "$WASM") bytes"
exit $status
