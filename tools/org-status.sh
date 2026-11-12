#!/usr/bin/env bash
# org-status.sh — is the fsharp-wasm GitHub organization in the shape we agreed on?  Read-only: public refs only.
#
#   tools/org-status.sh                 branches / tags per repository, and every submodule pin of this checkout
#
# Target state: every repository has exactly `main` and `develop`; develop is where work happens; every submodule
# commit that this repository pins exists in the organization's copy of that repository.
set -uo pipefail

ORG="${ORG:-fsharp-wasm}"
REPOS="${REPOS:-fsharp-wasm fsharp-wasm-runtime fsharp-wasm-core fsharp-wasm-graphics fsharp-wasmecto fsharp-glyph-aura fsharp Fable .github fsharp-wasm.github.io}"
# forks of upstream projects keep their upstream branches and tags until we decide to prune them
FORKS="${FORKS:-fsharp Fable}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ok() { printf '  \033[32m✓\033[0m %s\n' "$*"; }
bad() { printf '  \033[31m✗\033[0m %s\n' "$*"; }
url() { echo "https://github.com/$ORG/$1.git"; }

echo "── branches and tags in github.com/$ORG"
for r in $REPOS; do
  refs="$(timeout 60 git ls-remote --heads --tags "$(url "$r")" 2>/dev/null | grep -v '\^{}')" || refs=""
  if [ -z "$refs" ]; then bad "$r: not reachable (missing, empty or private)"; continue; fi
  heads="$(echo "$refs" | sed -n 's#.*refs/heads/##p')"
  extra="$(echo "$heads" | grep -vx -e main -e develop | tr '\n' ' ')"
  ntags="$(echo "$refs" | grep -c 'refs/tags/')"
  has() { echo "$heads" | grep -qx "$1"; }
  line="$r: $(echo "$heads" | wc -l | tr -d ' ') branches, $ntags tags"
  if ! has main || ! has develop; then bad "$line — missing: $(has main || echo -n 'main ')$(has develop || echo -n 'develop')"
  elif [ -n "$extra" ] && ! echo " $FORKS " | grep -q " $r "; then bad "$line — besides main/develop: ${extra:0:160}"
  elif [ -n "$extra" ]; then echo "  · $line (fork: upstream branches kept)"
  else ok "$line"; fi
done

echo "── submodule pins of this checkout, looked up in the organization"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT; git init -q --bare "$tmp/p"
git -C "$ROOT" ls-files -s | awk '$1==160000 {print $2, $4}' | while read -r sha path; do
  repo="$(basename "$path")"
  case "$repo" in fsharp) repo=fsharp ;; esac
  if git -C "$tmp/p" fetch -q --depth=1 "$(url "$repo")" "$sha" 2>/dev/null; then ok "$path @ ${sha:0:7} exists in $ORG/$repo"
  else bad "$path @ ${sha:0:7} is NOT in $ORG/$repo — bump the pin to a commit that is"; fi
done

echo "── .gitmodules urls that still point outside the organization"
git -C "$ROOT" show HEAD:.gitmodules 2>/dev/null | grep -E 'url *= *https?://' | grep -v "github.com/$ORG/" | sed 's/^/  ✗ /' || ok "none"
