/// BCL Helper Registry — single point of truth for inline BCL helper builders.
/// — maps "$helperName" → builder function.
///
/// Callers use `BclRegistry.emitUsed ctx` / `BclRegistry.forModule ctx`
/// to get only the helpers that were
/// referenced during compilation (tracked via ctx.UsedHelpers).
///
/// Dependency resolution (e.g. $floatToStr needs $intToStr + $strConcat) is
/// handled here once, not scattered across the codebase.
module WasmGc.Bcl.Registry

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────────────────
// Dependency graph — transitive closure computed by resolve
// ─────────────────────────────────────────────────────────────────────────────

/// Static inter-helper dependencies.  Key uses all names listed as values.
let private deps : (string * string list) list = [
    "$arraySortWith", []  // self-contained
    "$floatToStr",   ["$fdShortest"]
    "$floatToFixed", ["$fdExact"]
    "$fdShortest",   ["$fdScale"; "$fdLoad"; "$fdDigit"; "$fdCmp"; "$fdExact"]
    "$fdExact",      ["$fdScale"; "$fdLoad"]
    "$fdScale",      ["$fdMulSmall"]
    "$fdCmp",        ["$fdDigit"]
    "$fdLoad",       []
    "$fdDigit",      []
    "$fdMulSmall",   []
    "$uintToStr",    ["$intToStr"]
    "$strSplit",     ["$strIndexOf"; "$strSubstring"]
    "$strReplace",   ["$strIndexOf"; "$strSubstring"; "$strConcat"]
    "$strJoin",      ["$strConcat"]
    "$strJoinList",  ["$strConcat"]
    "$strRepeat",    ["$strConcat"]
    "$int64ToStr",   []
    "$uintToRadix",  []
    "$parseInt",     ["$strSubstring"]
    "$strTrimStart", ["$strIndexOf"]
    "$strTrimEnd",   ["$strLastIndexOf"]
    "$strTrim",      ["$strTrimStart"; "$strTrimEnd"]
]

/// Compute the transitive closure of used helpers under the dependency graph.
/// Expand `used` with all transitive dependencies.  Mutates in place.
let resolve (used: System.Collections.Generic.HashSet<string>) : unit =
    let mutable changed = true
    while changed do
        changed <- false
        for name, dependsOn in deps do
            if used.Contains name then
                for dep in dependsOn do
                    if used.Add dep then changed <- true

// ─────────────────────────────────────────────────────────────────────────────
// Registry
// ─────────────────────────────────────────────────────────────────────────────

/// Return the full list of (helperName, buildFn) pairs for the given Ctx.
/// Callers filter by `ctx.UsedHelpers` after calling `resolve`.
/// The builder is a `unit -> WFuncDecl` thunk — helpers are only built when used.
let forModule (ctx: Ctx) : (string * (unit -> WFuncDecl)) list =
    let strArrTypeIdx = getOrAddArrayType ctx (WType.Ref(StringTypeIdx, false))
    let charArrTypeIdx = getOrAddArrayType ctx WType.I32
    [
        // ── String ────────────────────────────────────────────────────────
        "$strConcat",         StringHelpers.makeStrConcatHelper
        "$strEq",             StringHelpers.makeStrEqHelper
        "$strHash",           StringHelpers.makeStrHashHelper
        "$strIndexOf",        StringHelpers.makeStrIndexOfHelper
        "$strLastIndexOf",    StringHelpers.makeStrLastIndexOfHelper
        "$strSubstring",      StringHelpers.makeStrSubstringHelper
        "$strToLower",        StringHelpers.makeStrToLowerHelper
        "$strToUpper",        StringHelpers.makeStrToUpperHelper
        "$strTrim",           StringHelpers.makeStrTrimHelper
        "$strTrimStart",      StringHelpers.makeStrTrimStartHelper
        "$strTrimEnd",        StringHelpers.makeStrTrimEndHelper
        "$fmtPad",            StringHelpers.makeFmtPadHelper
        "$strPadLeft",        StringHelpers.makeStrPadLeftHelper
        "$strPadRight",       StringHelpers.makeStrPadRightHelper
        "$strReplace",        StringHelpers.makeStrReplaceHelper
        "$strCompare",        StringHelpers.makeStrCompareHelper
        "$strSplit",          StringHelpers.makeStrSplitHelper strArrTypeIdx
        "$strToChars",        StringHelpers.makeStrToCharsHelper charArrTypeIdx
        "$strJoin",           StringHelpers.makeStrJoinHelper  strArrTypeIdx
        "$strRepeat",         StringHelpers.makeStrRepeatHelper
        "$int64ToStr",        StringHelpers.makeInt64ToStrHelper
        "$uintToRadix",       StringHelpers.makeUIntToRadixHelper
        // the ListCons<string> struct is registered when first needed, not for every module
        "$strJoinList",       (fun () ->
                                  mapTypeKnown ctx (Fable.AST.Fable.Type.List Fable.AST.Fable.Type.String) |> ignore
                                  StringHelpers.makeStrJoinListHelper ctx.ListRegistry.[wTypeKey (WType.Ref(StringTypeIdx, false))] ())
        "$intToStr",          StringHelpers.makeIntToStrHelper
        "$floatToStr",        FloatFormat.makeFloatToStrHelper
        "$floatToFixed",      FloatFormat.makeFloatToFixedHelper
        "$fdShortest",        FloatFormat.makeFdShortestHelper
        "$fdExact",           FloatFormat.makeFdExactHelper
        "$fdScale",           FloatFormat.makeFdScaleHelper
        "$fdLoad",            FloatFormat.makeFdLoadHelper
        "$fdDigit",           FloatFormat.makeFdDigitHelper
        "$fdCmp",             FloatFormat.makeFdCmpHelper
        "$fdMulSmall",        FloatFormat.makeFdMulSmallHelper
        "$uintToStr",         StringHelpers.makeUIntToStrHelper
        "$parseInt",          StringHelpers.makeIntParseHelper
        "$parseFloat",        StringHelpers.makeFloatParseHelper
        // ── Char ──────────────────────────────────────────────────────────
        "$charIsDigit",          CharHelpers.makeCharIsDigitHelper
        "$charIsLetter",         CharHelpers.makeCharIsLetterHelper
        "$charIsUpper",          CharHelpers.makeCharIsUpperHelper
        "$charIsLower",          CharHelpers.makeCharIsLowerHelper
        "$charIsWhitespace",     CharHelpers.makeCharIsWhitespaceHelper
        "$charToLower",          CharHelpers.makeCharToLowerHelper
        "$charToUpper",          CharHelpers.makeCharToUpperHelper
        "$charIsLetterOrDigit",  CharHelpers.makeCharIsLetterOrDigitHelper
        // ── Math ──────────────────────────────────────────────────────────
        "$pown",              MathHelpers.makePownHelper
        "$powF64",            MathHelpers.makePowF64Helper
        "$mathExp",           MathHelpers.makeMathExpHelper
        "$mathLog",           MathHelpers.makeMathLogHelper
        "$mathSin",           MathHelpers.makeMathSinHelper
        "$mathCos",           MathHelpers.makeMathCosHelper
        "$mathTan",           MathHelpers.makeMathTanHelper
        "$mathAtan2",         MathHelpers.makeMathAtan2Helper
        // ── StringBuilder ─────────────────────────────────────────────────
        "$sbCreate",          StringBuilderHelpers.makeStringBuilderCreateHelper
        "$sbAppend",          StringBuilderHelpers.makeStringBuilderAppendHelper
        "$sbToString",        StringBuilderHelpers.makeStringBuilderToStringHelper
        // ── Array ────────────────────────────────────────────────────────────
        "$arraySortWith", ArrayHelpers.makeArraySortWithHelper
    ]

/// Build and return all helpers that are in `ctx.UsedHelpers`,
/// including transitively-required dependencies.
let emitUsed (ctx: Ctx) : WFuncDecl list =
    resolve ctx.UsedHelpers
    forModule ctx
    |> List.choose (fun (name, build) ->
        if ctx.UsedHelpers.Contains name then Some(build()) else None)
