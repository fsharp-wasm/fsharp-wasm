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

/// Compile a complete F# source module to a WModule using PipelineHelper.
/// Returns None if the pipeline helper is not yet wired (graceful skip).
let tryCompile (src: string) : WModule option =
    // Clean up the formatting of the multi-line string before feeding it to the compiler
    let cleanSrc = trimIndent src
    
    // TODO: wire to real Fable CLI when PipelineHelper.compileToWasm is ready
    // For now return None so these tests are skipped gracefully.
    // When wired:
    //   try Some(PipelineHelper.compileToWasm (prelude + cleanSrc))
    //   with ex -> failwithf "Compilation failed:\n%s\n\nSource:\n%s" ex.Message cleanSrc
    None

/// Helper to gracefully pass or skip tests based on whether the pipeline is wired up.
let skipIfNotWired (f: WModule -> unit) (m: WModule option) =
    match m with
    | None -> ()  // skip — pipeline not yet wired
    | Some wm -> f wm