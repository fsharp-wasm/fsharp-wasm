#!/usr/bin/env bash
# Real programs as a gate: the compiler compiles the test suites of the platform's own libraries and the newsletter designer, and runs them.
#
#   tests/Dogfood/run.sh core-libs     FSharp.Wasm.Data, FSharp.Wasm.Ui and FSharp.Wasm.Edit (JSON, typed CSS/HTML, the email grid, edit operations), as a Wasmecto project
#   tests/Dogfood/run.sh newsletter    the newsletter library's suite, and the designer module (it must compile, validate and keep its exports)
#   tests/Dogfood/run.sh widget-editor the widget editor of fsharp-wasm-ide: the whole FSharp.Graphics stack, as a module that must keep its exports
#
# Why: the QuickTests are small programs written to hit one feature each.  A real program meets the combinations: since these libraries
# compile, seven faults were found and fixed that no QuickTest had shown (equality of unions with lists, list-of-class equality, `contains`
# by reference, Math.Pow's exponent, float `%`, String.EndsWith, name clashes).  The suites stay here so that they cannot come back.
#
# The programs come from sibling checkouts, like fsharp-wasmecto (the CI pins both to a commit):
#   FSHARP_CORE_DIR        fsharp-wasm-core, with `git submodule update --init lib/wasmecto`   (default ../fsharp-wasm-core)
#   FSHARP_NEWSLETTER_DIR  fsharp-wasm-newsletter, with `git submodule update --init`           (default ../fsharp-wasm-newsletter)
#   FSHARP_IDE_DIR         fsharp-wasm-ide, with `git submodule update --init`                  (default ../fsharp-wasm-ide)
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
WHAT="${1:?usage: run.sh core-libs|newsletter|widget-editor}"
OUT="$HERE/output/$WHAT"

compile() {   # <project directory> <output directory>
  rm -rf "$2"; mkdir -p "$2"
  dotnet run -c Release --project "$ROOT/tools/FSharp.Wasm.Cli" -- "$1" --outDir "$2" --noCache
}
validate() { command -v wasm-tools >/dev/null && wasm-tools validate "$1" --features gc || true; }
need() { [ -d "$1" ] || { echo "$2 not found at $1 (set $3)" >&2; exit 2; }; }

case "$WHAT" in
  core-libs)
    CORE="${FSHARP_CORE_DIR:-$ROOT/../fsharp-wasm-core}"
    need "$CORE/tests/FSharp.Wasm.Libs.WasmTests" fsharp-wasm-core "$CORE" FSHARP_CORE_DIR
    [ -d "$CORE/lib/wasmecto/src" ] || { echo "$CORE/lib/wasmecto is empty: git submodule update --init lib/wasmecto" >&2; exit 2; }
    export FSHARP_WASM_CORE_DIR="$CORE"       # Wasmecto finds the base library here
    dotnet build "$CORE/FSharp.Wasm.Core/FSharp.Wasm.Core.fsproj" -c Release --nologo -v q > /dev/null
    echo "==> Compiling the suites of FSharp.Wasm.Data, FSharp.Wasm.Ui and FSharp.Wasm.Edit..."
    compile "$CORE/tests/FSharp.Wasm.Libs.WasmTests" "$OUT"
    validate "$OUT/WasmTests.wasm"
    echo "==> Running WasmTests.wasm in Node..."
    node "$ROOT/tests/Wasm/run.mjs" "$OUT/WasmTests.wasm"
    ;;
  newsletter)
    NL="${FSHARP_NEWSLETTER_DIR:-$ROOT/../fsharp-wasm-newsletter}"
    need "$NL/tests/Newsletter.WasmTests" fsharp-wasm-newsletter "$NL" FSHARP_NEWSLETTER_DIR
    [ -d "$NL/lib/runtime/src" ] && [ -d "$NL/lib/fsharp-wasm-core/FSharp.Wasm.Core" ] && [ -d "$NL/lib/graphics/src" ] && [ -d "$NL/lib/wasmecto/src" ] \
      || { echo "the submodules of $NL are empty: git submodule update --init" >&2; exit 2; }
    source "$NL/build/env.sh"                 # FSHARP_WASM_CORE_DIR = its lib/fsharp-wasm-core
    dotnet build "$FSHARP_WASM_CORE_DIR/FSharp.Wasm.Core/FSharp.Wasm.Core.fsproj" -c Release --nologo -v q > /dev/null
    echo "==> Compiling the newsletter library's suite..."
    compile "$NL/tests/Newsletter.WasmTests" "$OUT/tests"
    validate "$OUT/tests/WasmTests.wasm"
    echo "==> Running WasmTests.wasm in Node..."
    node "$ROOT/tests/Wasm/run.mjs" "$OUT/tests/WasmTests.wasm"
    echo "==> Compiling the designer (the Elmish program on the HTML DSL of fsharp-wasm-runtime)..."
    compile "$NL/src/Newsletter.Designer" "$OUT/designer"
    validate "$OUT/designer/NewsletterDesigner.wasm"
    # the host calls `start`: the module must still export it (and run nothing before that)
    node -e '
      const fs = require("fs");
      const m = new WebAssembly.Module(fs.readFileSync(process.argv[1]));
      const names = WebAssembly.Module.exports(m).map((e) => e.name);
      if (!names.includes("start")) { console.error("the designer module no longer exports `start`: " + names.join(", ")); process.exit(1); }
      console.log("the designer module is " + fs.statSync(process.argv[1]).size + " bytes and exports `start`");' "$OUT/designer/NewsletterDesigner.wasm"
    ;;
  widget-editor)
    IDE="${FSHARP_IDE_DIR:-$ROOT/../fsharp-wasm-ide}"
    need "$IDE/src/WidgetEditor.Browser" fsharp-wasm-ide "$IDE" FSHARP_IDE_DIR
    [ -d "$IDE/lib/graphics/src" ] && [ -d "$IDE/lib/runtime/runtime" ] && [ -d "$IDE/lib/fsharp-wasm-core/FSharp.Wasm.Core" ] \
      || { echo "the submodules of $IDE are empty: git submodule update --init lib/graphics lib/runtime lib/fsharp-wasm-core" >&2; exit 2; }
    source "$IDE/build/env.sh"                # FSHARP_WASM_CORE_DIR = its lib/fsharp-wasm-core
    dotnet build "$FSHARP_WASM_CORE_DIR/FSharp.Wasm.Core/FSharp.Wasm.Core.fsproj" -c Release --nologo -v q > /dev/null
    echo "==> Compiling the widget editor (FSharp.Graphics.Widgets, Scene, Tea, Canvas, as one module)..."
    compile "$IDE/src/WidgetEditor.Browser" "$OUT"
    validate "$OUT/WidgetEditor.wasm"
    # runtime/gfx.js calls these; the module must keep them (and `start` is what the page boots)
    node -e '
      const fs = require("fs");
      const m = new WebAssembly.Module(fs.readFileSync(process.argv[1]));
      const names = WebAssembly.Module.exports(m).map((e) => e.name);
      const missing = ["start", "onResize", "onPointer", "onWheel", "onKey", "frame"].filter((n) => !names.includes(n));
      if (missing.length) { console.error("the widget editor module no longer exports: " + missing.join(", ") + " (has " + names.join(", ") + ")"); process.exit(1); }
      console.log("the widget editor module is " + fs.statSync(process.argv[1]).size + " bytes and exports start, onResize, onPointer, onWheel, onKey, frame");' "$OUT/WidgetEditor.wasm"
    ;;
  *) echo "unknown suite: $WHAT" >&2; exit 2 ;;
esac
