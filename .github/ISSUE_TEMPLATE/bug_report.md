---
name: Bug Report
about: Report a compilation or runtime bug
title: "[Bug] "
labels: bug
assignees: ''

---

## Description

A clear description of the bug.

## F# Source Code

```fsharp
// Minimal F# code that triggers the bug
module Repro

let buggyFunction x =
    // ...
```

## Expected Behavior

What should happen.

## Actual Behavior

What actually happens. Include error messages, incorrect output, or crash logs.

## Generated WAT (if available)

<details>
<summary>WAT output</summary>

```wat
;; Paste relevant section from output/*.wat
```

</details>

## Environment

- **OS:** (e.g., Ubuntu 24.04, macOS 15, Windows 11)
- **.NET SDK:** (output of `dotnet --version`)
- **Node.js:** (output of `node --version`)
- **wasm-tools:** (output of `wasm-tools --version`, or "not installed")
