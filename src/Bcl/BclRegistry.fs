/// BCL Helper Registry — maps "$helperName" → builder function.
///
/// The compiler calls `BclRegistry.forModule ctx` to get the list of helper
/// builders; `buildWModule` then emits only the ones in `ctx.UsedHelpers`.
///
/// Dependency resolution (e.g. $floatToStr depends on $intToStr + $strConcat)
/// is handled HERE, not scattered across buildWModule.
module WasmGc.Bcl.Registry

open WasmGc.Core.AST
open WasmGc.Runtime.Types    // Ctx, StringTypeIdx, getOrAddArrayType

// ─────────────────────────────────────────────────────────────────────────────
// Dependency graph
// ─────────────────────────────────────────────────────────────────────────────

/// Static inter-helper dependency map.
/// Key depends on all values; transitive closure is computed by `resolve`.
let private deps : Map<string, string list> =
    [ "$floatToStr",  ["$intToStr"; "$strConcat"]
      "$strSplit",    ["$strIndexOf"; "$strSubstring"]
      "$strJoin",     ["$strConcat"]
      "$parseInt",    ["$strSubstring"]
      "$strTrimStart",["$strIndexOf"]
      "$strTrimEnd",  ["$strLastIndexOf"]
      "$strTrim",     ["$strTrimStart"; "$strTrimEnd"] ]
    |> Map.ofList

/// Compute the transitive closure of used helpers under the dependency graph.
let resolve (used: System.Collections.Generic.HashSet<string>) : unit =
    let mutable changed = true
    while changed do
        changed <- false
        for kvp in Map.toSeq deps do
            let name, dependsOn = kvp
            if used.Contains(name) then
                for dep in dependsOn do
                    if used.Add(dep) then changed <- true

// ─────────────────────────────────────────────────────────────────────────────
// Registry builder
// ─────────────────────────────────────────────────────────────────────────────

/// Return the full list of (helperName, buildFn) pairs for the given Ctx.
/// Callers filter by `ctx.UsedHelpers` after calling `resolve`.
let forModule (ctx: Ctx) : (string * (unit -> WFuncDecl)) list =
    let strArrTypeIdx = getOrAddArrayType ctx (WType.Ref(StringTypeIdx, false))
    [
        // ── String helpers (from StringHelpers.fs) ────────────────────────
        "$strConcat",         StringHelpers.makeStrConcatHelper
        "$strEq",             StringHelpers.makeStrEqHelper
        "$strIndexOf",        StringHelpers.makeStrIndexOfHelper
        "$strLastIndexOf",    StringHelpers.makeStrLastIndexOfHelper
        "$strSubstring",      StringHelpers.makeStrSubstringHelper
        "$strToLower",        StringHelpers.makeStrToLowerHelper
        "$strToUpper",        StringHelpers.makeStrToUpperHelper
        "$strTrim",           StringHelpers.makeStrTrimHelper
        "$strTrimStart",      StringHelpers.makeStrTrimStartHelper
        "$strTrimEnd",        StringHelpers.makeStrTrimEndHelper
        "$strPadLeft",        StringHelpers.makeStrPadLeftHelper
        "$strPadRight",       StringHelpers.makeStrPadRightHelper
        "$strReplace",        StringHelpers.makeStrReplaceHelper
        "$strCompare",        StringHelpers.makeStrCompareHelper
        "$strSplit",    fun () -> StringHelpers.makeStrSplitHelper strArrTypeIdx
        "$strJoin",     fun () -> StringHelpers.makeStrJoinHelper  strArrTypeIdx
        "$intToStr",          StringHelpers.makeIntToStrHelper
        "$floatToStr",        StringHelpers.makeFloatToStrHelper
        "$parseInt",          StringHelpers.makeIntParseHelper
        "$parseFloat",        StringHelpers.makeFloatParseHelper
        // ── Char helpers (from CharHelpers.fs) ───────────────────────────
        "$charIsDigit",       CharHelpers.makeCharIsDigitHelper
        "$charIsLetter",      CharHelpers.makeCharIsLetterHelper
        "$charIsUpper",       CharHelpers.makeCharIsUpperHelper
        "$charIsLower",       CharHelpers.makeCharIsLowerHelper
        "$charIsWhitespace",  CharHelpers.makeCharIsWhitespaceHelper
        "$charToLower",       CharHelpers.makeCharToLowerHelper
        "$charToUpper",       CharHelpers.makeCharToUpperHelper
        "$charIsLetterOrDigit", CharHelpers.makeCharIsLetterOrDigitHelper
        // ── Math helpers (from MathHelpers.fs) ───────────────────────────
        "$pown",              MathHelpers.makePownHelper
        "$powF64",            MathHelpers.makePowF64Helper
        "$mathExp",           MathHelpers.makeMathExpHelper
        "$mathLog",           MathHelpers.makeMathLogHelper
        "$mathSin",           MathHelpers.makeMathSinHelper
        "$mathCos",           MathHelpers.makeMathCosHelper
        "$mathTan",           MathHelpers.makeMathTanHelper
        "$mathAtan2",         MathHelpers.makeMathAtan2Helper
        // ── StringBuilder (from StringBuilderHelpers.fs) ─────────────────
        "$sbCreate",          StringBuilderHelpers.makeStringBuilderCreateHelper
        "$sbAppend",          StringBuilderHelpers.makeStringBuilderAppendHelper
        "$sbToString",        StringBuilderHelpers.makeStringBuilderToStringHelper
    ]

/// Build and return all helpers that are in `ctx.UsedHelpers`,
/// including transitively-required dependencies.
let emitUsed (ctx: Ctx) : WFuncDecl list =
    resolve ctx.UsedHelpers
    forModule ctx
    |> List.choose (fun (name, build) ->
        if ctx.UsedHelpers.Contains name then Some(build()) else None)
