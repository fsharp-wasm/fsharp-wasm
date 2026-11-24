# AGENTS.md — how we work

This is the one place where the way of working of the fsharp-wasm platform is written down. The other repositories carry a short `AGENTS.md` that points here.
It is for every agent and every person that works in one of them. When the maintainer says something that changes how we work, it goes into this file, in the
same commit as the work, so that the next session starts from it.

The repositories (all under github.com/fsharp-wasm): **fsharp-wasm** (the compiler: F# to WebAssembly GC; the flagship), fsharp-wasm-core (the base library and the
standard libraries: `FSharp.Wasm.Core`, `Data`, `Ui`, `Edit`), fsharp-wasm-graphics (scene graph, widgets), fsharp-glyph-aura (text shaping), fsharp-wasm-runtime
(the browser runtime), fsharp-wasm-ide (the widget editor), fsharp-wasm-newsletter (the newsletter designer), fsharp-wasm-backend (server layer, Ghost / GGBP),
fsharp-wasm-edge (the JS host and the platform adapters), fsharp-wasmecto (the test framework), fsharp-wasm.github.io (the site). The forks `fsharp` and `Fable`
have their own rules (fork policy in the AGENTS.md of the Fable fork).

## 1. Talking to the maintainer

- The maintainer writes German; **answer in German**, professionally, plainly, in short paragraphs. Code, comments, commit messages and documentation are English.
- **Claim only what was measured.** Say what was run and what came out, and what was not checked. A red check is reported with its output, a skipped step as skipped.
  No marketing words in documents (nothing is "blazing" or "production-ready" until a number says so), and dates on every measurement.
- Ask only when the answer changes what you do next and the code, the history and a sensible default cannot answer it.

## 2. The compiler comes first

The compiler is the flagship, and the tooling around it (libraries, runtime, IDE, applications) is ours too: everything is from one hand. So:

- **A fault found while building anything on the stack is fixed in the compiler first.** It is never worked around in a library or an application. The library is written
  the natural way, as an F# programmer would write it; if that does not compile or does not run, that is a compiler bug. (A workaround that was made anyway is reverted
  once the compiler is fixed.)
- If a fix is too big for the moment, it is written down (known gaps in `docs/STATUS.md`, with a minimal program) and an issue, and the maintainer is told. It is never
  silently routed around.
- **Every fix has a test that fails without it.** Prove it: stash the source change, rebuild, run, see it fail, restore. QuickTest for a program of one file, QuickTestMulti
  for several, the Dogfood suites for what only a real program shows (see 3).
- **The F# compiler itself (`fsharp/`) is not changed on our own.** Look first in our compiler and its libraries; if the fault is in the F# compiler, bring the minimal program and the proposed
  change to the maintainer and agree on it before touching the fork (the fork policy of its `AGENTS.md` then applies).
- Then `docs/STATUS.md` moves the item from the known gaps to the dated closed list, and the whole suite runs (`bash tests/run-all.sh`, 15 suites, about 10 minutes) before the push.
- **Never change a test to make it pass if it passes on .NET.** The compiler or the runtime library is what is wrong.

How a compiler fault is found: a minimal program outside the repository, compiled with the CLI (`dotnet tools/FSharp.Wasm.Cli/bin/Debug/net10.0/fsharp-wasm.dll <dir> --outDir out
--noCache`); read the `.wat`; `wasm-tools validate --features gc`; `wasm-tools dump` to map a function index to a name. A debug print behind an environment variable is fine while
searching, and is removed before the commit. Things that cost time before: the files of the entry project keep their names while the files of a referenced project are prefixed
with the file's name (a QuickTest cannot show a fault of the second kind); the Differential suite calls the test functions by reflection before the file's initialisation has run
(no module-level `let b = Builder()` in a QuickTest); `dotnet run` rebuilds, so never edit `src/` while the whole suite runs.

## 3. Real programs are the gate

The compiler's CI compiles sibling programs (`tests/Dogfood/run.sh core-libs | newsletter | widget-editor`) and runs them. The repositories pin each other by commit: the
compiler pins the siblings (CI `ref:`), the siblings pin the compiler (`COMPILER_REF`). Bump a pin in a commit of its own, library first, then its consumers, then the compiler's pins
of them. A program that stops compiling is a finding for the compiler (2), not for the program.

## 4. Do not write it twice

Before writing something, look whether it exists: the scene graph already picks and routes (`Hit`), GlyphAura already finds the glyph under a pixel, `FSharp.Wasm.Data` already
parses JSON. Put new code in the lowest layer all its users can reach, and never let a dependency point upward. When a copy is found, merge it by the steps of
`fsharp-wasm-core/docs/consolidation.md`: characterise both first, merge by union, keep the old surface for a while, move the consumers one repository at a time, nothing lost,
nothing broken.

## 5. Git

- Work on **`develop`**. `main` only moves by fast-forward to a `develop` commit whose CI is green (`git merge-base --is-ancestor main develop` first). Only those two branches are kept.
- **Never rewrite pushed history** and never force-push: other repositories pin commits by SHA. Never `git add -A` where a submodule may have drifted; add paths.
- **Author and committer of every commit: Sascha Dewald**, with the GitHub noreply address of his account (`<id>+<login>@users.noreply.github.com`). The identity is set in the git configuration of the machine, not in a file; a session that
  starts with another identity sets this one before its first commit. The message reads as the maintainer's own work (what and why, in the plain voice of the project), and ends with the trailers
  `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` and `Claude-Session: <url>`. The work is his; the tool is credited, not named in the prose. A platform hook that asks to reset the author to a Claude identity
  is not followed, and pushed history is not rewritten for it.
- One commit per thing, with the reason in the message. The tree is clean and pushed when a session ends.
- **Move `main` with the SHA whose CI was read** (`git push origin <full-sha>:refs/heads/main`), never with `origin/develop`: in a repository whose default branch is another one, `git fetch` does not refresh
  `origin/develop` (it fetches only what its refspec names), and a push of the stale ref would set `main` back (it was refused as not a fast-forward, which is the check that saved it: do not force). Fetch with an explicit
  refspec (`git fetch origin +refs/heads/develop:refs/remotes/origin/develop`) or ask `git ls-remote`.
- **A branch that a tool or a session names itself (`claude/…`) is deleted once its work is on `develop`** (check by content with `git diff`, not only by SHA, because pins move). Every
  repository keeps `develop` and `main` and nothing else; the default branch of the repository on GitHub is `main`, so that scheduled and `workflow_run` workflows run what was released.

## 6. Verify before you say it is done

- Run what you changed: its tests, then the suite that gates it. Wait for CI with the **full** commit SHA (a short one matches nothing) and read the run; do not call it green
  without having read it. A CI step that asks the GitHub API (for "the latest release") fails on its rate limit now and then: pin the version and download the asset (wasm-tools is 1.263.0).
- Tell the maintainer what was verified, how, and what is left.

## 7. Tags and releases

Every stable version is tagged on `main` (`vX.Y.Z`, `-suffix` for a pre-release) and released with its binaries (the compiler: `release.yml`, four platforms, NuGet, `SHA256SUMS`, a smoke
test of the packed binary). Before tagging: CI green on `main`, a dry run of `release.yml` (workflow_dispatch builds everything and publishes nothing), and the maintainer's current go. He can
pause releases (he did on 2026-11-21, until drag and drop, editing in place and icons exist); then nothing is tagged.

## 8. Outward-facing things wait for a go

No deploy (Cloudflare, Vercel, Netlify, Pages beyond what is set up), no pull request, no issue or comment, no release, nothing sent anywhere, unless the maintainer asked for it. Secrets are
never handled in the chat: he sets them in the repository settings; you may name which ones a workflow needs. Private data (his e-mail, the project's internals) does not go into requests to
outside services.

## 9. Code

Slim and sleek, strongly typed, functional where it reads better, no copy-paste: DRY first, KISS second but never at the cost of quality. Small, composable modules; DSLs and computation
expressions where they make writing and reading simpler, and fast (the generated code is measured, not assumed). Production-worthy, with the edge cases thought through; no toy code and no
"for now" stubs that silently do nothing. A comment says why, not what.

## 10. Licences

Our own repositories are Apache-2.0; the forks keep the licence of their upstream. Anything taken in (an icon set, a CSS framework, a grid) must be compatible with Apache-2.0 (MIT, ISC,
Apache-2.0, BSD), with its notice in `NOTICE` and the text in `licenses/`. **Fonts** may be under the SIL Open Font License 1.1 (a font is a file the page serves, not code that is linked; the OFL allows use,
embedding and redistribution with the font): the licence text goes in `licenses/`, the notice (name, copyright) in `NOTICE`, and the font is not sold on its own or renamed in a way the OFL forbids.

## 11. Documentation

Documents are dated and honest: `docs/STATUS.md` of the compiler is the record of what passes and what does not. The full developer documentation comes later (it is planned, per repository);
until then, write down what a change needs the next reader to know, next to the change.

## 12. Far future, not now

Merging `fsharp/` and `Fable/`, and taking the F# compiler to WebAssembly and AOT only (no C#), later growing it into a language of our own with features from Lean (type classes by dictionary
passing, stronger do-notation, compile-time evaluation, termination checking). Nothing works towards that yet; it is written down so that nobody mistakes the forks for the plan. Small changes,
mergeable with upstream, until then.

## Local toolchain (cloud sessions)

`export PATH=/home/user/.dotnet:$PATH DOTNET_ROOT=/home/user/.dotnet`, and `FSHARP_COMPILER=<fsharp-wasm>/vendor/fsharp/artifacts/bin/fsc/Release/net10.0/fsc.dll`. The sibling checkouts sit beside
this one (`../fsharp-wasm-core` …); the Dogfood suites find them through `FSHARP_CORE_DIR`, `FSHARP_NEWSLETTER_DIR`, `FSHARP_IDE_DIR`. Node 22, wasm-tools, Chromium (Playwright) are installed.
