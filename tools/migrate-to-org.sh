#!/usr/bin/env bash
# migrate-to-org.sh — move a repository into the fsharp-wasm GitHub organization as a clean open-source start.
#
#   tools/migrate-to-org.sh <repo-name>              dry run: prepare everything, push nothing
#   tools/migrate-to-org.sh <repo-name> --execute    push main and develop, delete every other branch
#
# What it does (for repositories of our own — not for forks of upstream projects, whose history must stay):
#   1. clones the source branch (default: develop) of github.com/aiqs4/<repo>
#   2. squashes it into ONE root commit, authored and committed by Sascha Dewald — no agent or session trailers
#   3. rewrites links github.com/aiqs4/… to github.com/fsharp-wasm/… in text files (the sponsor link, which points to
#      the person, is not touched)
#   4. makes both `main` and `develop` that commit, so develop can later be merged into main with a fast-forward
#   5. with --execute: force-pushes main and develop to github.com/fsharp-wasm/<repo> and deletes all other branches
#
# Environment (all optional):
#   SRC_URL      source repository      (default https://github.com/aiqs4/<repo>.git)
#   DST_URL      destination repository (default https://github.com/fsharp-wasm/<repo>.git)
#   SRC_BRANCH   branch to take         (default develop)
#   AUTHOR_NAME / AUTHOR_EMAIL          (default Sascha Dewald / sascha.dewald@gmail.com)
#   COMMIT_MESSAGE                      (default "Initial open-source release")
#   DROP_SUBMODULES  space-separated submodule paths to remove (default: lib/* for fsharp-wasm-runtime — build-time
#                    clutter that points back at the compiler and at private repositories; none otherwise)
#   KEEP_DIR=1   keep the working directory after the run
set -euo pipefail

REPO="${1:-}"; [ -n "$REPO" ] || { sed -n '2,19p' "$0"; exit 2; }
EXECUTE=0; [ "${2:-}" = "--execute" ] && EXECUTE=1

SRC_URL="${SRC_URL:-https://github.com/aiqs4/$REPO.git}"
DST_URL="${DST_URL:-https://github.com/fsharp-wasm/$REPO.git}"
SRC_BRANCH="${SRC_BRANCH:-develop}"
AUTHOR_NAME="${AUTHOR_NAME:-Sascha Dewald}"
AUTHOR_EMAIL="${AUTHOR_EMAIL:-sascha.dewald@gmail.com}"
COMMIT_MESSAGE="${COMMIT_MESSAGE:-Initial open-source release}"

if [ -z "${DROP_SUBMODULES+x}" ]; then
  case "$REPO" in
    fsharp-wasm-runtime) DROP_SUBMODULES="lib/Fable lib/fsharp lib/fsharp-wasm lib/fsharp-wasm-core lib/fsharp-wasmecto" ;;
    *) DROP_SUBMODULES="" ;;
  esac
fi

WORK="$(mktemp -d)"
[ -n "${KEEP_DIR:-}" ] || trap 'rm -rf "$WORK"' EXIT
say() { printf '\n\033[1m▸ %s\033[0m\n' "$*"; }

say "clone $SRC_URL ($SRC_BRANCH)"
git clone --quiet --branch "$SRC_BRANCH" --single-branch "$SRC_URL" "$WORK/repo"
cd "$WORK/repo"
SRC_SHA="$(git rev-parse --short HEAD)"
SRC_COMMITS="$(git rev-list --count HEAD)"

say "squash $SRC_COMMITS commits ($SRC_SHA) into one"
git checkout --quiet --orphan clean

if [ -n "$DROP_SUBMODULES" ]; then
  say "drop submodules: $DROP_SUBMODULES"
  for p in $DROP_SUBMODULES; do
    if git ls-files --error-unmatch "$p" >/dev/null 2>&1; then git rm -q --cached "$p"; rm -rf "$p"; fi
  done
  # then their .gitmodules sections (git refuses to unstage a gitlink while .gitmodules has unstaged edits)
  for p in $DROP_SUBMODULES; do git config -f .gitmodules --remove-section "submodule.$p" 2>/dev/null || true; done
  if [ -f .gitmodules ]; then
    if grep -q '\[submodule' .gitmodules; then git add .gitmodules; else git rm -q -f .gitmodules; fi
  fi
fi

say "rewrite github.com/aiqs4/ → github.com/fsharp-wasm/ in text files"
# git grep: tracked text files only (-I skips binaries such as the prebuilt .wasm; submodule paths are not searched).
# The sponsor link is github.com/sponsors/aiqs4, which does not match.
changed=0
while IFS= read -r -d '' f; do
  sed -i 's#github\.com/aiqs4/#github.com/fsharp-wasm/#g; s#raw\.githubusercontent\.com/aiqs4/#raw.githubusercontent.com/fsharp-wasm/#g' "$f"
  changed=$((changed + 1))
done < <(git grep -Il --null -e 'github\.com/aiqs4/' -e 'raw\.githubusercontent\.com/aiqs4/' || true)
echo "  $changed file(s) rewritten"

export GIT_AUTHOR_NAME="$AUTHOR_NAME" GIT_AUTHOR_EMAIL="$AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$AUTHOR_NAME" GIT_COMMITTER_EMAIL="$AUTHOR_EMAIL"
git add -A
git commit --quiet -m "$COMMIT_MESSAGE"
git branch -M main
git branch -f develop main

say "result"
echo "  commit   $(git rev-parse --short main)  by $(git log -1 --format='%an <%ae>')"
echo "  files    $(git ls-files | wc -l)"
echo "  authors  $(git log --format='%an <%ae>' main develop | sort -u | tr '\n' ';')"
if git grep -Iq 'github\.com/aiqs4/' ; then
  echo "  ⚠ links to github.com/aiqs4/ remain:"; git grep -In 'github\.com/aiqs4/' | head -5
fi

say "destination $DST_URL"
mapfile -t existing < <(git ls-remote --heads "$DST_URL" 2>/dev/null | sed 's#.*refs/heads/##')
echo "  existing branches: ${existing[*]:-(none, or the repository is empty)}"
stale=(); for b in "${existing[@]:-}"; do [ -n "$b" ] && [ "$b" != main ] && [ "$b" != develop ] && stale+=("$b"); done
echo "  will be force-pushed: main, develop     will be deleted: ${stale[*]:-(none)}"

if [ "$EXECUTE" = 1 ]; then
  say "push"
  git push --force "$DST_URL" main develop
  for b in "${stale[@]:-}"; do [ -n "$b" ] && git push "$DST_URL" --delete "$b"; done
  say "done — ${DST_URL%.git}"
else
  say "dry run: nothing was pushed.  Re-run with --execute to push."
fi
[ -z "${KEEP_DIR:-}" ] || echo "working copy kept in $WORK/repo"
