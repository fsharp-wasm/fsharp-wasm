module WasmGc.Bcl.StringBuilderHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─── StringBuilder runtime helpers (Tier 1 — phantom struct intrinsics) ──────

/// $sbCreate(cap) → $StringBuilder  — allocate with given initial capacity.
let makeStringBuilderCreateHelper () : WFuncDecl =
    q "$sbCreate"
        <@ fun (cap: int) ->
            sbNew (wsCreateFill cap 0) 0 cap @>

/// $sbAppend(sb, s) → $StringBuilder  — append string s, growing buffer if needed.
let makeStringBuilderAppendHelper () : WFuncDecl =
    q "$sbAppend"
        <@ fun (sb: SbStruct) (s: WasmStr) ->
            let oldLen = sbLen sb
            let sLen   = wsLen s
            let newLen = oldLen + sLen
            let cap    = sbCap sb
            if newLen > cap then
                let doubleCap = cap * 2
                let newCap    = if doubleCap > newLen then doubleCap else newLen
                let newBuf    = wsCreateFill newCap 0
                wsCopy newBuf 0 (sbBuf sb) 0 oldLen
                sbSetBuf sb newBuf
                sbSetCap sb newCap
            wsCopy (sbBuf sb) oldLen s 0 sLen
            sbSetLen sb newLen
            sb @>

/// $sbToString(sb) → $WasmStr  — extract exact-length string from the buffer.
let makeStringBuilderToStringHelper () : WFuncDecl =
    q "$sbToString"
        <@ fun (sb: SbStruct) ->
            let len = sbLen sb
            let res = wsCreateFill len 0
            wsCopy res 0 (sbBuf sb) 0 len
            res @>
