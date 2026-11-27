#!/usr/bin/env bash
# A program that uses a NuGet package, compiled the way a user does it: the package is packed from a fixture, restored into an empty packages
# folder, its sources land in `out/fable_modules/` INSIDE the program's folder (the default of `--outDir out`), and the program runs.
#
# Why a suite of its own: the other suites compile libraries by path (a sibling checkout, a project reference), where the library's files are outside the
# program's folder.  A package's are inside it, and the compiler took them for the program's own files: functions kept their names (and were exported)
# instead of the file's prefix, so every call from the program to the package found nothing (`Unhandled import call 'isFinite$'`, 2026-11-27).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"

dotnet build "$ROOT/tools/FSharp.Wasm.Cli" -c Release --nologo -v q > /dev/null
CLI="$ROOT/tools/FSharp.Wasm.Cli/bin/Release/net10.0/fsharp-wasm.dll"

DIR="$(mktemp -d)"; trap 'rm -rf "$DIR"' EXIT
mkdir "$DIR/feed" "$DIR/app"
cp -r "$HERE/Pkg" "$DIR/pkg"
echo "==> Packing the fixture..."
dotnet pack "$DIR/pkg" -c Release -o "$DIR/feed" --nologo -v q > /dev/null

cp "$HERE/Consumer/consumer.fs" "$HERE/Consumer/Consumer.fsproj" "$DIR/app/"
cat > "$DIR/app/nuget.config" <<XML
<configuration><packageSources><clear/><add key="local" value="$DIR/feed"/><add key="nuget.org" value="https://api.nuget.org/v3/index.json"/></packageSources></configuration>
XML

# an empty packages folder: the only Fixture.Pkg there is the one that was just packed
export NUGET_PACKAGES="$DIR/packages"
cd "$DIR/app"
echo "==> Compiling the program that uses it..."
dotnet "$CLI" . --outDir out --noCache
ls out/fable_modules/Fixture.Pkg.1.0.0/Numbers.fs > /dev/null   # the layout this test is about: the package's sources inside the program's folder
if command -v wasm-tools >/dev/null; then wasm-tools validate out/consumer.wasm --features gc; fi
node "$HERE/check.mjs" out/consumer.wasm
