#!/bin/bash
# prints PASS/FAIL per scenario for both emitter paths. $1 = out dir
D=${1:-/home/claude/out}
chk() { # name call expected-substring
  local n=$1 c=$2 exp=$3
  for path in wasm wat; do
    if [ $path = wasm ]; then f=$D/$n.wasm
    else python3 wat2wasm.py $D/$n.wat /tmp/$n.wat.wasm >/tmp/$n.err 2>&1 || { printf "%-22s %-5s %-5s %s\n" $n $path FAIL "WAT-PARSE: $(head -c 90 /tmp/$n.err)"; continue; }; f=/tmp/$n.wat.wasm; fi
    [ -f "$f" ] || { printf "%-22s %-5s %-5s %s\n" $n $path FAIL "no output file"; continue; }
    out=$(node --experimental-wasm-exnref run.mjs $f $c 2>&1 | tr '\n' ' ')
    if echo "$out" | grep -q -- "$exp"; then printf "%-22s %-5s PASS  %s\n" $n $path "$(echo $out | cut -c1-70)"
    else printf "%-22s %-5s FAIL  %s\n" $n $path "$(echo $out | cut -c1-110)"; fi
  done
}
chk s1_capture        run=3,4        "run => 7"
chk s2_nocapture      run=21         "run => 42"
chk s3_knownfunc      run=41         "run => 42"
chk s4_letrec_mutual  run=6          "run => 1 "
chk s5_letrec_self    run=5          "run => 120"
chk s6_array_sortwith run=0         "run => 123"
chk s7_closure_arg    run=40         "run => 43"
chk s8_return_apply   run=14         "run => 42"
chk s9_nested         run=1          "run => 111"
chk s10_deep_tail     run=3000000    "run => 3000000"
chk s11_unit_closure  run=41         "run => 42"
chk s12_mixed_captures run=7         "run => 115"
chk s13_three_way_letrec "run=10,7"  "run => 11"
chk s14_closure_captures_closure run=5 "run => 7"
chk s15_throw_in_closure run=77      "run => 77"
chk e1_break_in_try   run=5          "run => 10"
chk e2_exn_payload    run=7          "run => 7"
chk e3_shared_join    "run=1"        "run => 1017"
chk e3_shared_join    "run=2"        "run => 2027"
chk e5_div_neg        run=-7         "run => -1"
chk e6_nan_i64        nan=0          "nan => NaN"
chk e6_nan_i64        ltu=0          "ltu => 1"
chk e7_forward_types  run=9          "run => 9"
# e4: finally must run: normal=5 then count must be 1; thrown() must report 2
for path in wasm wat; do
  if [ $path = wasm ]; then f=$D/e4_try_finally.wasm; else python3 wat2wasm.py $D/e4_try_finally.wat /tmp/e4.wat.wasm >/dev/null 2>&1; f=/tmp/e4.wat.wasm; fi
  out=$(node --experimental-wasm-exnref run.mjs $f normal=5 thrown=0 count=0 2>&1 | tr '\n' ' ')
  if echo "$out" | grep -q "normal => 5 thrown => 2 count => 2"; then printf "%-22s %-5s PASS  %s\n" e4_try_finally $path "$out"; else printf "%-22s %-5s FAIL  %s\n" e4_try_finally $path "$(echo $out | cut -c1-110)"; fi
done
