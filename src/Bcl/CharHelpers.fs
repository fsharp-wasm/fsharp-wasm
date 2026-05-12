module WasmGc.Bcl.CharHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Tier 1 — char helpers
// ─────────────────────────────────────────────────────────────────

/// Runtime helper: $charIsDigit(c) → 1 if '0'..'9' else 0.
let makeCharIsDigitHelper () : WFuncDecl =
    q "$charIsDigit" <@ fun (c: int) -> if c >= 48 && c <= 57 then 1 else 0 @>

/// Runtime helper: $charIsLetter(c) → 1 if 'A'..'Z' or 'a'..'z' else 0.
let makeCharIsLetterHelper () : WFuncDecl =
    q "$charIsLetter"
        <@ fun (c: int) ->
            if (c >= 65 && c <= 90) || (c >= 97 && c <= 122) then 1 else 0 @>

/// Runtime helper: $charIsUpper(c) → 1 if 'A'..'Z' else 0.
let makeCharIsUpperHelper () : WFuncDecl =
    q "$charIsUpper" <@ fun (c: int) -> if c >= 65 && c <= 90 then 1 else 0 @>

/// Runtime helper: $charIsLower(c) → 1 if 'a'..'z' else 0.
let makeCharIsLowerHelper () : WFuncDecl =
    q "$charIsLower" <@ fun (c: int) -> if c >= 97 && c <= 122 then 1 else 0 @>

/// Runtime helper: $charIsWhitespace(c) → 1 if space or ASCII ctrl (9..13) else 0.
let makeCharIsWhitespaceHelper () : WFuncDecl =
    q "$charIsWhitespace"
        <@ fun (c: int) ->
            if c = 32 || (c >= 9 && c <= 13) then 1 else 0 @>

/// Runtime helper: $charToLower(c) → lowercase: A-Z → a-z, others unchanged.
let makeCharToLowerHelper () : WFuncDecl =
    q "$charToLower"
        <@ fun (c: int) ->
            if c >= 65 && c <= 90 then c + 32 else c @>

/// Runtime helper: $charToUpper(c) → uppercase: a-z → A-Z, others unchanged.
let makeCharToUpperHelper () : WFuncDecl =
    q "$charToUpper"
        <@ fun (c: int) ->
            if c >= 97 && c <= 122 then c - 32 else c @>

/// Runtime helper: $charIsLetterOrDigit(c) → 1 if letter or digit else 0.
let makeCharIsLetterOrDigitHelper () : WFuncDecl =
    q "$charIsLetterOrDigit"
        <@ fun (c: int) ->
            if (c >= 65 && c <= 90) || (c >= 97 && c <= 122) || (c >= 48 && c <= 57)
            then 1 else 0 @>
