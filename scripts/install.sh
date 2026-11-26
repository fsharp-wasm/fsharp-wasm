#!/usr/bin/env sh
# Install the fsharp-wasm compiler from a GitHub release (Linux and macOS):
#
#   curl -fsSL https://raw.githubusercontent.com/fsharp-wasm/fsharp-wasm/main/scripts/install.sh | sh
#
# It downloads the archive of this machine, checks it against SHA256SUMS of the release, unpacks it into ~/.fsharp-wasm/<version> and links
# ~/.fsharp-wasm/bin/fsharp-wasm.  The compiler needs the .NET 10 SDK on the machine (it reads the project and restores FSharp.Core with it).
# Windows: take fsharp-wasm-win-x64.zip from the releases page.  Another way, with the SDK installed:  dotnet tool install -g FSharp.Wasm.Cli
#
#   FSHARP_WASM_VERSION   a tag, e.g. v0.2.0-experimental (default: the newest release, a pre-release too)
#   FSHARP_WASM_HOME      where to install (default: ~/.fsharp-wasm)
#   FSHARP_WASM_BASE_URL  where the release files are (default: the GitHub release of the version); for a mirror or a test
set -eu

repo="fsharp-wasm/fsharp-wasm"
home="${FSHARP_WASM_HOME:-$HOME/.fsharp-wasm}"
say() { printf '%s\n' "$*"; }
fail() { printf 'install: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }
have curl || fail "curl is needed"
have tar || fail "tar is needed"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64)  rid=linux-x64 ;;
  Darwin-x86_64) rid=osx-x64 ;;
  Darwin-arm64)  rid=osx-arm64 ;;
  *) fail "no binary for $(uname -s) $(uname -m); build from source (https://fsharp-wasm.github.io/docs/getting-started/) or use: dotnet tool install -g FSharp.Wasm.Cli" ;;
esac

version="${FSHARP_WASM_VERSION:-}"
if [ -z "$version" ]; then
  # the newest release, whether or not it is a pre-release (/releases/latest would skip those)
  version="$(curl -fsSL "https://api.github.com/repos/$repo/releases?per_page=1" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n 1)"
  [ -n "$version" ] || fail "could not find the newest release of $repo (the GitHub API may be rate limited: set FSHARP_WASM_VERSION)"
fi
base="${FSHARP_WASM_BASE_URL:-https://github.com/$repo/releases/download/$version}"
archive="fsharp-wasm-$rid.tar.gz"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT INT TERM
say "fsharp-wasm $version for $rid"
curl -fSL --progress-bar -o "$tmp/$archive" "$base/$archive"
curl -fsSL -o "$tmp/SHA256SUMS" "$base/SHA256SUMS"

expected="$(grep " $archive\$" "$tmp/SHA256SUMS" | sed 's/ .*//')"
[ -n "$expected" ] || fail "$archive is not in SHA256SUMS"
if have sha256sum; then actual="$(sha256sum "$tmp/$archive" | sed 's/ .*//')"
elif have shasum; then actual="$(shasum -a 256 "$tmp/$archive" | sed 's/ .*//')"
else fail "sha256sum or shasum is needed to check the download"; fi
[ "$expected" = "$actual" ] || fail "the checksum of $archive does not match SHA256SUMS: not installing"

dest="$home/$version"
rm -rf "$dest"; mkdir -p "$dest" "$home/bin"
tar xzf "$tmp/$archive" -C "$dest"
chmod +x "$dest/fsharp-wasm"
ln -sf "$dest/fsharp-wasm" "$home/bin/fsharp-wasm"

say "installed: $home/bin/fsharp-wasm"
case ":$PATH:" in
  *":$home/bin:"*) ;;
  *) say "add it to your PATH:  export PATH=\"$home/bin:\$PATH\"" ;;
esac
have dotnet || say "note: the .NET 10 SDK is not on the PATH; the compiler needs it (https://dotnet.microsoft.com/download)"
say "then:  fsharp-wasm <project folder> --outDir out"
