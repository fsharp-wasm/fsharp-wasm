#!/usr/bin/env bash
# Backend regression suite.  Needs: dotnet, node (V8 with GC + exnref), wasm-tools.
#   ./run.sh            run everything
# Every scenario is checked through the binary encoder AND through WAT -> `wasm-tools parse`.
set -u
cd "$(dirname "$0")"
export OUT_DIR="${OUT_DIR:-out}"
NODE="${NODE:-node}"; NODEFLAGS="${NODEFLAGS:---experimental-wasm-exnref}"   # add --experimental-wasm-gc only if your node still knows it
rm -rf "$OUT_DIR" "${OUT_DIR}_ops" "${OUT_DIR}"_fuzz_* "${OUT_DIR}"_cfuzz_*
dotnet build -c Release -v q 2>&1 | grep -E "error|Build succeeded" | sort -u
H="dotnet bin/Release/net10.0/BackendHarness.dll"
$H >/dev/null 2>&1 || true
fail=0
chk() { # name call expected-substring
  local n=$1 c=$2 exp=$3
  for path in wasm wat; do
    if [ $path = wasm ]; then f="$OUT_DIR/$n.wasm"
    else f="$OUT_DIR/$n.wat.wasm"; wasm-tools parse "$OUT_DIR/$n.wat" -o "$f" 2>"$OUT_DIR/$n.err" || { printf "FAIL %-22s %-4s WAT: %s\n" "$n" $path "$(head -c 100 "$OUT_DIR/$n.err")"; fail=1; continue; }; fi
    out=$($NODE $NODEFLAGS run.mjs "$f" $c 2>&1 | tr '\n' ' ')
    if echo "$out" | grep -q -- "$exp"; then printf "PASS %-22s %-4s %s\n" "$n" $path "${out:0:60}"
    else printf "FAIL %-22s %-4s %s\n" "$n" $path "${out:0:120}"; fail=1; fi
  done
}
chk s1_capture        run=3,4  "run => 7"
chk s2_nocapture      run=21   "run => 42"
chk s3_knownfunc      run=41   "run => 42"
chk s4_letrec_mutual  run=6    "run => 1 "
chk s5_letrec_self    run=5    "run => 120"
chk s6_array_sortwith run=0    "run => 123"
chk s7_closure_arg    run=40   "run => 43"
chk s8_return_apply   run=14   "run => 42"
chk s9_nested         run=1    "run => 111"
chk s10_deep_tail     run=3000000 "run => 3000000"     # needs return_call_ref
chk s11_unit_closure  run=41   "run => 42"
chk s12_mixed_captures run=7   "run => 115"
chk s13_three_way_letrec "run=10,7" "run => 11"
chk s14_closure_captures_closure run=5 "run => 7"
chk s15_throw_in_closure run=77 "run => 77"
chk e1_break_in_try   run=5    "run => 10"
chk e2_exn_payload    run=7    "run => 7"
chk e3_shared_join    run=1    "run => 1017"
chk e3_shared_join    run=2    "run => 2027"
chk e5_div_neg        run=-7   "run => -1"
chk e6_nan_i64        nan=0    "nan => NaN"
chk e6_nan_i64        ltu=0    "ltu => 1"
chk e7_forward_types  run=9    "run => 9"
# try/finally: normal path + exception path must both run the finalizer
f="$OUT_DIR/e4_try_finally.wasm"
out=$($NODE $NODEFLAGS run.mjs "$f" normal=5 thrown=0 count=0 2>&1 | tr '\n' ' ')
echo "$out" | grep -q "normal => 5 thrown => 2 count => 2" && echo "PASS e4_try_finally        wasm $out" || { echo "FAIL e4_try_finally        wasm $out"; fail=1; }
# operator table: every (op, type) through both emitters
OUT_DIR="$OUT_DIR" $H optable >/dev/null 2>&1
bad=0
for w in "${OUT_DIR}_ops"/*.wasm; do $NODE $NODEFLAGS -e "new WebAssembly.Module(require('fs').readFileSync('$w'))" 2>/dev/null || { echo "FAIL optable(bin) $(basename $w)"; bad=1; }; done
for w in "${OUT_DIR}_ops"/*.wat;  do wasm-tools parse "$w" -o /tmp/_op.wasm 2>/dev/null && $NODE $NODEFLAGS -e "new WebAssembly.Module(require('fs').readFileSync('/tmp/_op.wasm'))" 2>/dev/null || { echo "FAIL optable(wat) $(basename $w)"; bad=1; }; done
[ $bad = 0 ] && echo "PASS operator table (binary + WAT)" || fail=1
# differential fuzzing: random programs vs. an independent reference interpreter, 4 variants each
FUZZ_SEEDS="${FUZZ_SEEDS:-1 2 3}"
for seed in $FUZZ_SEEDS; do
  FUZZ_DIR="${OUT_DIR}_fuzz_$seed"  $H fuzz        $seed 400 >/dev/null 2>&1 && $NODE $NODEFLAGS fuzzcheck.mjs "${OUT_DIR}_fuzz_$seed"  | tail -1 | sed "s/^/expr-fuzz seed $seed: /" | tee /dev/stderr | grep -q " 0 failures" || { echo "FAIL expression fuzz seed $seed"; fail=1; }
  FUZZ_DIR="${OUT_DIR}_cfuzz_$seed" $H closurefuzz $seed 120 >/dev/null 2>&1 && $NODE $NODEFLAGS fuzzcheck.mjs "${OUT_DIR}_cfuzz_$seed" | tail -1 | sed "s/^/closure-fuzz seed $seed: /" | tee /dev/stderr | grep -q " 0 failures" || { echo "FAIL closure fuzz seed $seed"; fail=1; }
done
$H freevars   >/dev/null || { echo "FAIL freevars";  fail=1; }
$H optchecks  >/dev/null || { echo "FAIL optimizer"; fail=1; }
$H validator  >/dev/null 2>&1 || { echo "FAIL validator"; fail=1; }
[ $fail = 0 ] && echo "ALL OK" || { echo "FAILURES"; exit 1; }
