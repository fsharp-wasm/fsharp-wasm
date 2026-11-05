import sys, wasmtime
src = open(sys.argv[1], encoding='utf-8').read()
try:
    b = wasmtime.wat2wasm(src)
except Exception as e:
    print("WAT PARSE ERROR:", str(e)[:600]); sys.exit(2)
open(sys.argv[2], 'wb').write(bytes(b))
