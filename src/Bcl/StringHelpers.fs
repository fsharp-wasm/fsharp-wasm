module WasmGc.Bcl.StringHelpers

open WasmGc.Core.AST
open WasmGc.Runtime.Types

// ─────────────────────────────────────────────────────────────────
// Quotation walker helpers — shared by all Tier 1 string/char helpers
// ─────────────────────────────────────────────────────────────────

/// Type-map used when translating runtime quotations: strings map to StringTypeIdx,
/// StringBuilder struct maps to StringBuilderTypeIdx.
let private runtimeTypeMap : QTypeMap =
    { StrTypeIdx = StringTypeIdx; SbTypeIdx = StringBuilderTypeIdx; ResolveCustom = fun _ -> None }

/// Intrinsics used when translating runtime quotations.
let private runtimeIntrinsics = standardIntrinsics StringTypeIdx StringBuilderTypeIdx

/// Translate an inline quotation to a WFuncDecl and collect locals.
/// The WFuncDecl returned by translateReflected has Locals = [];
/// resolveLocals fills them in so the function is self-contained.
let private q (name: string) (qexpr: Microsoft.FSharp.Quotations.Expr) : WFuncDecl =
    translateReflected name runtimeTypeMap runtimeIntrinsics qexpr
    |> resolveLocals

// ─── Phantom functions for cross-runtime-helper calls inside quotations ───────
// The QW translates these as WExpr.Call("$" + mi.Name, ...) — never called from F#.
let private intToStr    (_n: int)                                    : WasmStr = WasmStr
let private strConcat   (_a: WasmStr) (_b: WasmStr)                 : WasmStr = WasmStr
let private strSubstring (_s: WasmStr) (_start: int) (_len: int)    : WasmStr = WasmStr
let private strIndexOf  (_ha: WasmStr) (_ne: WasmStr)               : int     = 0


// ─────────────────────────────────────────────────────────────────
// Tier 1 — string runtime helpers (QuotationWalker-translated)
// ─────────────────────────────────────────────────────────────────

/// Runtime helper: $strConcat(a, b) → concatenate two strings.
let makeStrConcatHelper () : WFuncDecl =
    q "$strConcat"
        <@ fun (a: WasmStr) (b: WasmStr) ->
            let la = wsLen a
            let lb = wsLen b
            let res = wsCreate (la + lb)
            wsCopy res 0 a 0 la
            wsCopy res la b 0 lb
            res @>

/// Runtime helper: $strEq(a, b) → 1 if equal, 0 if not.
let makeStrEqHelper () : WFuncDecl =
    q "$strEq"
        <@ fun (a: WasmStr) (b: WasmStr) ->
            let la = wsLen a
            let lb = wsLen b
            if la <> lb then 0
            else
                let mutable i = 0
                while i < la && wsGet a i = wsGet b i do i <- i + 1
                if i = la then 1 else 0 @>

/// Runtime helper: $strIndexOf(haystack, needle) → first position, or -1 if not found.
/// Brute-force O(n·m). needle="" always returns 0.
/// Short-circuit `&&` from the QuotationWalker prevents out-of-bounds array access.
// let makeStrIndexOfHelper () : WFuncDecl =
//     q "$strIndexOf"
//         <@ fun (ha: WasmStr) (ne: WasmStr) ->
//             let la = wsLen ha
//             let lb = wsLen ne
//             if lb = 0 then 0
//             else
//                 let mutable result = -1
//                 let mutable i = 0
//                 while result = -1 && i <= la - lb do
//                     let mutable j = 0
//                     while j < lb && wsGet ha (i + j) = wsGet ne j do j <- j + 1
//                     if j >= lb then result <- i
//                     i <- i + 1
//                 result @>

let makeStrIndexOfHelper () : WFuncDecl =
    let strRefT  = WType.Ref(StringTypeIdx, false)
    let haParam  = "$strIdx_ha"
    let neParam  = "$strIdx_ne"
    let laName   = "$strIdx_la"
    let lbName   = "$strIdx_lb"
    let gen      = LabelGen("strIdx")
    let ha       = localGet haParam strRefT
    let ne       = localGet neParam strRefT
    let la       = WExpr.Let(laName, arrayLen ha, localGet laName WType.I32)
    let lb       = WExpr.Let(lbName, arrayLen ne, localGet lbName WType.I32)
    // Build body using the makeStrIndexOfBody combinator from array combinators:
    //
    //   block $outer : i32 {
    //     if lb = 0 then br $outer 0
    //     let mut i = 0
    //     while i ≤ la - lb {
    //       block $match : void {
    //         let mut j = 0
    //         while j < lb {
    //           if ha[i+j] ≠ ne[j] then br $match
    //           j++
    //         }
    //         br $outer i     // full match
    //       }
    //       i++
    //     }
    //     -1
    //   }
    let body =
        wasm {
            let! laVal = arrayLen ha
            let! lbVal = arrayLen ne
            return! Wasm.labeledBlock gen "outer" WType.I32 (fun outer -> wasm {
                if (lbVal =. i32Const 0) then
                    do! outer.BreakWith (i32Const 0)
                let! i = mut (i32Const 0)
                while (i.Val <=. (laVal -. lbVal)) do
                    do! Wasm.labeledBlock gen "match" WType.Void (fun inner -> wasm {
                        let! j = mut (i32Const 0)
                        while (j.Val <. lbVal) do
                            let charHa = arrayGet ha (i.Val +. j.Val) WType.I32
                            let charNe = arrayGet ne j.Val             WType.I32
                            if (charHa <>. charNe) then
                                do! inner.Break
                            do! j <== (j.Val +. i32Const 1)
                        do! outer.BreakWith i.Val
                    })
                    do! i <== (i.Val +. i32Const 1)
                return i32Const (-1)
            })
        }
    { Name     = "$strIndexOf"
      Params   = [haParam, strRefT; neParam, strRefT]
      Result   = WType.I32
      Locals   = []
      Body     = body
      Exported = false }
    |> Locals.resolveLocals

/// Runtime helper: $strLastIndexOf(haystack, needle) → last position, or -1 if not found.
/// Brute-force O(n·m) backward scan. needle="" always returns la (length of haystack).
/// Short-circuit `&&` from the QuotationWalker prevents out-of-bounds array access.
let makeStrLastIndexOfHelper () : WFuncDecl =
    q "$strLastIndexOf"
        <@ fun (ha: WasmStr) (ne: WasmStr) ->
            let la = wsLen ha
            let lb = wsLen ne
            if lb = 0 then la
            else
                let mutable result = -1
                let mutable i = la - lb
                while result = -1 && i >= 0 do
                    let mutable j = 0
                    while j < lb && wsGet ha (i + j) = wsGet ne j do j <- j + 1
                    if j >= lb then result <- i
                    i <- i - 1
                result @>

/// Runtime helper: $strSubstring(src, start, len) → new string slice.
let makeStrSubstringHelper () : WFuncDecl =
    q "$strSubstring"
        <@ fun (src: WasmStr) (start: int) (len: int) ->
            let res = wsCreate len
            wsCopy res 0 src start len
            res @>

/// Runtime helper: $strToLower(s) → ASCII-only case fold (A-Z → a-z).
let makeStrToLowerHelper () : WFuncDecl =
    q "$strToLower"
        <@ fun (s: WasmStr) ->
            let len = wsLen s
            let res = wsCreate len
            for i = 0 to len - 1 do
                let c = wsGet s i
                wsSet res i (if c >= 65 && c <= 90 then c + 32 else c)
            res @>

/// Runtime helper: $strToUpper(s) → ASCII-only case fold (a-z → A-Z).
let makeStrToUpperHelper () : WFuncDecl =
    q "$strToUpper"
        <@ fun (s: WasmStr) ->
            let len = wsLen s
            let res = wsCreate len
            for i = 0 to len - 1 do
                let c = wsGet s i
                wsSet res i (if c >= 97 && c <= 122 then c - 32 else c)
            res @>

/// Runtime helper: $strTrim(s) → strip leading/trailing whitespace (chars ≤ 32).
let makeStrTrimHelper () : WFuncDecl =
    q "$strTrim"
        <@ fun (src: WasmStr) ->
            let len = wsLen src
            let mutable s = 0
            let mutable e = len
            while s < len && wsGet src s <= 32 do s <- s + 1
            while e > s && wsGet src (e - 1) <= 32 do e <- e - 1
            let resLen = e - s
            let res = wsCreate resLen
            wsCopy res 0 src s resLen
            res @>

/// Runtime helper: $strTrimStart(s) → strip leading whitespace (chars ≤ 32).
let makeStrTrimStartHelper () : WFuncDecl =
    q "$strTrimStart"
        <@ fun (src: WasmStr) ->
            let len = wsLen src
            let mutable s = 0
            while s < len && wsGet src s <= 32 do s <- s + 1
            let res = wsCreate (len - s)
            wsCopy res 0 src s (len - s)
            res @>

/// Runtime helper: $strTrimEnd(s) → strip trailing whitespace (chars ≤ 32).
let makeStrTrimEndHelper () : WFuncDecl =
    q "$strTrimEnd"
        <@ fun (src: WasmStr) ->
            let len = wsLen src
            let mutable e = len
            while e > 0 && wsGet src (e - 1) <= 32 do e <- e - 1
            let res = wsCreate e
            wsCopy res 0 src 0 e
            res @>

/// Runtime helper: $intToStr(n) → decimal string representation of an i32.
let makeIntToStrHelper () : WFuncDecl =
    q "$intToStr"
        <@ fun (n: int) ->
            if n = 0 then wsCreateFill 1 48   // "0"
            else
                let mutable neg = 0
                let mutable v = n
                if n < 0 then
                    neg <- 1
                    v <- 0 - n
                let buf = wsCreate 12
                let mutable len = 0
                while v <> 0 do
                    wsSet buf len (v % 10 + 48)
                    v <- v / 10
                    len <- len + 1
                let res = wsCreate len
                for i = 0 to len - 1 do
                    wsSet res i (wsGet buf (len - i - 1))
                if neg <> 0 then
                    let r2 = wsCreate (len + 1)
                    wsSet r2 0 45   // '-'
                    wsCopy r2 1 res 0 len
                    r2
                else res @>

/// Runtime helper: $floatToStr(f) → decimal string representation of an f64.
/// Produces up to 6 significant decimal digits with trailing zeros trimmed.
/// Examples: 3.14 → "3.14", -2.5 → "-2.5", 42.0 → "42.0", 0.0 → "0".
/// Limitation: integer part is truncated to i32 range (~±2.1×10⁹).
let makeFloatToStrHelper () : WFuncDecl =
    q "$floatToStr"
        <@ fun (f: float) ->
            if f = 0.0 then wsCreateFill 1 48   // "0"
            else
                let fa = absF64 f
                let ip = truncF64 fa
                let fi = truncF64 ((fa - intToF64 ip) * 1000000.0)
                let is = intToStr ip
                let la = wsLen is
                if fi = 0 then
                    let dot0 = wsCreate (la + 2)
                    wsCopy dot0 0 is 0 la
                    wsSet dot0 la 46        // '.'
                    wsSet dot0 (la + 1) 48  // '0'
                    if f < 0.0 then
                        let r = wsCreate (la + 3)
                        wsSet r 0 45           // '-'
                        wsCopy r 1 dot0 0 (la + 2)
                        r
                    else dot0
                else
                    let fb = wsCreate 6
                    let mutable fv = fi
                    wsSet fb 0 (fv / 100000 + 48)
                    fv <- fv % 100000
                    wsSet fb 1 (fv / 10000 + 48)
                    fv <- fv % 10000
                    wsSet fb 2 (fv / 1000 + 48)
                    fv <- fv % 1000
                    wsSet fb 3 (fv / 100 + 48)
                    fv <- fv % 100
                    wsSet fb 4 (fv / 10 + 48)
                    fv <- fv % 10
                    wsSet fb 5 (fv + 48)
                    let mutable fe = 6
                    while fe > 1 && wsGet fb (fe - 1) = 48 do fe <- fe - 1
                    let res = wsCreate (la + 1 + fe)
                    wsCopy res 0 is 0 la
                    wsSet res la 46     // '.'
                    wsCopy res (la + 1) fb 0 fe
                    if f < 0.0 then
                        let r = wsCreate (la + 2 + fe)
                        wsSet r 0 45       // '-'
                        wsCopy r 1 res 0 (la + 1 + fe)
                        r
                    else res @>

/// Runtime helper: $strPadLeft(str, width) → pad with spaces on the left.
let makeStrPadLeftHelper () : WFuncDecl =
    q "$strPadLeft"
        <@ fun (src: WasmStr) (width: int) ->
            let la = wsLen src
            if la >= width then src
            else
                let res = wsCreateFill width 32
                wsCopy res (width - la) src 0 la
                res @>

/// Runtime helper: $strPadRight(str, width) → pad with spaces on the right.
let makeStrPadRightHelper () : WFuncDecl =
    q "$strPadRight"
        <@ fun (src: WasmStr) (width: int) ->
            let la = wsLen src
            if la >= width then src
            else
                let res = wsCreateFill width 32
                wsCopy res 0 src 0 la
                res @>

/// Runtime helper: $strReplace(src, from, repl) → replace all occurrences of `from` with `repl`.
let makeStrReplaceHelper () : WFuncDecl =
    q "$strReplace"
        <@ fun (src: WasmStr) (frm: WasmStr) (repl: WasmStr) ->
            let lo = wsLen frm
            if lo = 0 then src
            else
                let la = wsLen src
                let mutable pos = 0
                let mutable acc = wsCreate 0
                let mutable more = 1
                while more = 1 do
                    let j = strIndexOf (strSubstring src pos (la - pos)) frm
                    if j < 0 then
                        more <- 0
                    else
                        acc <- strConcat (strConcat acc (strSubstring src pos j)) repl
                        pos <- pos + j + lo
                strConcat acc (strSubstring src pos (la - pos)) @>

/// Runtime helper: $strSplit(src, delim) → split src by delim, return array of strings.
/// arrTypeIdx must be the WasmGC array type for (array (ref $WasmStr)).
let makeStrSplitHelper (arrTypeIdx: int) () : WFuncDecl =
    let strRef  = WType.Ref(StringTypeIdx, false)
    let arrRef  = WType.Ref(arrTypeIdx, false)
    let i32     = WType.I32
    let srcGet  = localGet "$ssp_src"  strRef
    let delGet  = localGet "$ssp_del"  strRef
    let delLenG = localGet "$ssp_dl"   i32
    let posGet  = localGet "$ssp_pos"  i32
    let cntGet  = localGet "$ssp_cnt"  i32
    let jGet    = localGet "$ssp_j"    i32
    let arrGet  = localGet "$ssp_arr"  arrRef
    let idxGet  = localGet "$ssp_idx"  i32
    let emptyStr = WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
    // srcTail: the substring of src starting at pos
    let srcTail pos = call "$strSubstring" [srcGet; pos; sub (arrayLen srcGet) pos] strRef
    makeFunc "$strSplit" [("$ssp_src", strRef); ("$ssp_del", strRef)] arrRef (
        WExpr.Let("$ssp_dl", arrayLen delGet,
        // If delim is empty, return [| src |]
        wasmIf (eq delLenG (i32Const 0))
            (arrayNewFixed arrTypeIdx [srcGet] arrRef)
            // Phase 1: count occurrences → number of segments = count + 1
            (WExpr.LetMut("$ssp_pos", i32Const 0,
             WExpr.LetMut("$ssp_cnt", i32Const 1,
                sequence [
                    WExpr.Block("$ssp_cnt_done",
                        WExpr.Loop("$ssp_cnt_loop",
                            WExpr.Let("$ssp_j", call "$strIndexOf" [srcTail posGet; delGet] i32,
                                wasmIf (ltS jGet (i32Const 0))
                                    (WExpr.Break("$ssp_cnt_done", None))
                                    (sequence [
                                        localSet "$ssp_cnt" (add cntGet (i32Const 1))
                                        localSet "$ssp_pos" (add posGet (add jGet delLenG))
                                        WExpr.Continue("$ssp_cnt_loop", [])
                                    ])),
                            WType.Void),
                        WType.Void)
                    // Phase 2: allocate result array and fill
                    WExpr.Let("$ssp_arr", arrayNew arrTypeIdx cntGet emptyStr arrRef,
                    WExpr.LetMut("$ssp_pos", i32Const 0,
                    WExpr.LetMut("$ssp_idx", i32Const 0,
                        sequence [
                            WExpr.Block("$ssp_fill_done",
                                WExpr.Loop("$ssp_fill_loop",
                                    WExpr.Let("$ssp_j", call "$strIndexOf" [srcTail posGet; delGet] i32,
                                        wasmIf (ltS jGet (i32Const 0))
                                            (WExpr.Break("$ssp_fill_done", None))
                                            (sequence [
                                                arraySet arrGet idxGet (call "$strSubstring" [srcGet; posGet; jGet] strRef)
                                                localSet "$ssp_idx" (add idxGet (i32Const 1))
                                                localSet "$ssp_pos" (add posGet (add jGet delLenG))
                                                WExpr.Continue("$ssp_fill_loop", [])
                                            ])),
                                    WType.Void),
                                WType.Void)
                            // Last segment: from pos to end
                            arraySet arrGet idxGet (srcTail posGet)
                            arrGet
                        ])))
                ])))))

/// Runtime helper: $strJoin(sep, arr) → join array of strings with separator.
/// arrTypeIdx must be the WasmGC array type for (array (ref $WasmStr)).
let makeStrJoinHelper (arrTypeIdx: int) () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let arrRef = WType.Ref(arrTypeIdx, false)
    let i32    = WType.I32
    let sepGet = localGet "$sj_sep" strRef
    let arrG   = localGet "$sj_arr" arrRef
    let lenGet = localGet "$sj_len" i32
    let iGet   = localGet "$sj_i"   i32
    let resGet = localGet "$sj_res" strRef
    let emptyStr = WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
    makeFunc "$strJoin" [("$sj_sep", strRef); ("$sj_arr", arrRef)] strRef (
        WExpr.Let("$sj_len", arrayLen arrG,
        block_ "$sj_ret" strRef (
            // If empty array, return ""
            wasmIf (eq lenGet (i32Const 0))
                (WExpr.Break("$sj_ret", Some emptyStr))
                // Start with first element, then concat sep+elem for rest
                (WExpr.LetMut("$sj_res", arrayGet arrG (i32Const 0) strRef,
                 WExpr.LetMut("$sj_i", i32Const 1,
                    sequence [
                        whileLoop "$sj_loop" (ltS iGet lenGet)
                            (sequence [
                                localSet "$sj_res"
                                    (call "$strConcat" [
                                        call "$strConcat" [resGet; sepGet] strRef
                                        arrayGet arrG iGet strRef
                                    ] strRef)
                                localSet "$sj_i" (add iGet (i32Const 1))
                            ])
                        resGet
                    ]))))))



/// Runtime helper: $parseInt(s) → parse decimal string to i32.
/// Handles optional leading '-'. Returns 0 on empty or non-digit input.
/// Runtime helper: $parseInt(s) → parse decimal string to i32.
/// Handles optional leading '-'. Returns 0 on empty or invalid input.
let makeIntParseHelper () : WFuncDecl =
    q "$parseInt"
        <@ fun (s: WasmStr) ->
            let len = wsLen s
            if len = 0 then 0
            else
                let mutable i = 0
                let mutable neg = 0
                let mutable acc = 0
                let mutable valid = 1
                if wsGet s 0 = 45 then   // '-'
                    neg <- 1
                    i <- 1
                while valid = 1 && i < len do
                    let ch = wsGet s i
                    if ch < 48 || ch > 57 then
                        valid <- 0
                    else
                        acc <- acc * 10 + ch - 48
                        i <- i + 1
                if valid = 0 then 0
                elif neg <> 0 then 0 - acc
                else acc @>

/// Runtime helper: $parseFloat(s) → parse decimal string to f64.
/// Handles optional leading '-' and one decimal point. Returns 0.0 on empty or invalid.
let makeFloatParseHelper () : WFuncDecl =
    q "$parseFloat"
        <@ fun (s: WasmStr) ->
            let len = wsLen s
            if len = 0 then 0.0
            else
                let mutable i = 0
                let mutable neg = 0
                let mutable intPart = 0
                let mutable frac = 0.0
                let mutable div = 1.0
                let mutable hasDot = 0
                let mutable valid = 1
                if wsGet s 0 = 45 then   // '-'
                    neg <- 1
                    i <- 1
                while valid = 1 && i < len do
                    let ch = wsGet s i
                    if ch = 46 then   // '.'
                        hasDot <- 1
                        i <- i + 1
                    elif ch < 48 || ch > 57 then
                        valid <- 0
                    elif hasDot = 0 then
                        intPart <- intPart * 10 + ch - 48
                        i <- i + 1
                    else
                        div <- div * 10.0
                        frac <- frac + intToF64 (ch - 48) / div
                        i <- i + 1
                if valid = 0 then 0.0
                else
                    let result = intToF64 intPart + frac
                    if neg <> 0 then negF64 result else result @>

// ─────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────

/// Runtime helper: $strCompare(a, b) → i32  (-1 | 0 | 1)
/// Lexicographic comparison of two WasmStr arrays (char by char, then by length).
let makeStrCompareHelper () : WFuncDecl =
    q "$strCompare"
        <@ fun (a: WasmStr) (b: WasmStr) ->
            let la = wsLen a
            let lb = wsLen b
            let minLen = if la < lb then la else lb
            let mutable i = 0
            while i < minLen && wsGet a i = wsGet b i do i <- i + 1
            if i = minLen then
                if la > lb then 1 elif la < lb then -1 else 0
            else
                if wsGet a i > wsGet b i then 1 else -1 @>
