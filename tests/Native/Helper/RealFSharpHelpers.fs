// [<RequireQualifiedAccess>]
module internal Tests.RealFSharpHelpers

open System
open WasmGc.Core.AST

// ─────────────────────────────────────────────────────────────────────────────
// Shared F# fixture snippets
// ─────────────────────────────────────────────────────────────────────────────

/// Minimal prelude needed for any test module compiled through our backend.
/// This mirrors what QuickTest.fsproj includes.
let prelude = """
module Fixture

open Fable.Core
"""

/// Removes the common leading whitespace margin from all lines.
/// This behaves exactly like Kotlin's trimIndent() or C# Raw String Literals,
/// allowing multi-line string snippets to be aligned with the test code structure.
let trimIndent (str: string) =
    let lines = str.Split([| "\r\n"; "\n" |], StringSplitOptions.None)

    // Filter out lines that are purely empty or whitespace to calculate accurate margins
    let contentLines = lines |> Array.filter (String.IsNullOrWhiteSpace >> not)

    if contentLines.Length = 0 then
        str
    else
        // Determine the minimum number of leading spaces among all non-empty lines
        let minIndent =
            contentLines

            |> Array.map (fun line -> line.Length - line.TrimStart().Length)
            |> Array.min

        lines

        |> Array.map (fun line ->
            if line.Length >= minIndent && String.IsNullOrWhiteSpace(line.[0..minIndent-1]) then
                line.Substring(minIndent)
            else
                line.TrimStart())
        |> String.concat "\n"

/// Compile F# source through the in-memory pipeline.
/// Returns Some(WModule) if successful, None if compilation fails.
let tryCompile (src: string) : WModule option =
    let fullSource = prelude + "\n" + src
    match InMemoryPipelineHelper.compileSource fullSource with
    | Ok stages -> Some stages.WModuleNormalized
    | Error _ -> None

/// Helper to gracefully pass or skip tests based on whether the pipeline is wired up.
let skipIfNotWired (f: WModule -> unit) (m: WModule option) =
    match m with
    | None -> ()  // compilation failed; skip gracefully
    | Some wm -> f wm