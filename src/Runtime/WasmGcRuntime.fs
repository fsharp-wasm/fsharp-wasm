/// String and char runtime helpers for WasmGC.
/// Local variable collection lives in WasmGcLocals.fs.
/// Structural equality lives in WasmGcEquality.fs.
module Fable.Transforms.WasmGc.WasmGcRuntime

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder
open Fable.Transforms.WasmGc.WasmGcLocals
open Fable.Transforms.WasmGc.WasmGcQuotationWalker

// ─────────────────────────────────────────────────────────────────
// String runtime helpers
// ─────────────────────────────────────────────────────────────────

/// Runtime helper: $strConcat(a, b) → concatenate two (array i32) strings.
let makeStrConcatHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let aG = localGet "$a" strRef
    let bG = localGet "$b" strRef
    makeFunc "$strConcat" [("$a", strRef); ("$b", strRef)] strRef (
        wasm {
            let! la = arrayLen aG
            let! lb = arrayLen bG
            let! result = arrayNew StringTypeIdx (add la lb) (i32Const 0) strRef
            do! arrayCopy result (i32Const 0) aG (i32Const 0) la
            do! arrayCopy result la bG (i32Const 0) lb
            return result
        })

/// Runtime helper: $strEq(a, b) → 1 if equal, 0 if not (element-wise comparison).
let makeStrEqHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let aG  = localGet "$a"  strRef
    let bG  = localGet "$b"  strRef
    makeFunc "$strEq" [("$a", strRef); ("$b", strRef)] i32 (
        wasm {
            let! la = arrayLen aG
            let! lb = arrayLen bG
            return WExpr.Block("$eq_outer",
                wasmIf (ne la lb)
                    (WExpr.Break("$eq_outer", Some(i32Const 0)))
                    (sequence [
                        countLoop "$eq" la (fun i ->
                            wasmWhen (ne (arrayGet aG i i32) (arrayGet bG i i32))
                                (WExpr.Break("$eq_outer", Some(i32Const 0))))
                        i32Const 1]),
                i32)
        })

/// Runtime helper: $strIndexOf(haystack, needle) → first position, or -1 if not found.
/// Brute-force O(n·m). needle="" always returns 0.
/// Tier 2 with Sprint 18 DSL: WVar, WArray, WasmDsl, loopResult.
/// NOTE: The inner j-loop uses block+loop instead of while_(&&.) to avoid
/// non-short-circuit evaluation of the array accesses — WASM i32.and always
/// evaluates both operands, which would cause an out-of-bounds trap when j = lb.
let makeStrIndexOfHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let gen = LabelGen "sio"
    makeFunc "$strIndexOf" [("$ha", strRef); ("$ne", strRef)] WType.I32 (
        let ha = WArray.wrap WType.I32 (localGet "$ha" strRef)
        let ne = WArray.wrap WType.I32 (localGet "$ne" strRef)
        wasm {
            let! la = ha.Len
            let! lb = ne.Len
            return
                wasmIf (lb =. i32Const 0)
                    (i32Const 0)
                    (WVar.letMut gen "i" WType.I32 (i32Const 0) (fun i ->
                        loopResult WType.I32 (i32Const -1) (fun brk ->
                            wasmIf (i.Val <=. la -. lb)
                                (WVar.letMut gen "j" WType.I32 (i32Const 0) (fun j ->
                                    let jBlkLbl = gen.Next("jlb")
                                    let jLpLbl  = gen.Next("jl")
                                    sequence [
                                        WExpr.Block(jBlkLbl,
                                            WExpr.Loop(jLpLbl,
                                                sequence [
                                                    wasmWhen (j.Val >=. lb) (brk i.Val)
                                                    wasmWhen (ha.[i.Val +. j.Val] <>. ne.[j.Val])
                                                        (WExpr.Break(jBlkLbl, None))
                                                    j.Update (fun v -> v +. i32Const 1)
                                                    WExpr.Continue(jLpLbl, [])
                                                ],
                                                WType.Void),
                                            WType.Void)
                                        i.Update (fun v -> v +. i32Const 1)
                                    ]))
                                (brk (i32Const -1)))))
        })

/// Runtime helper: $strLastIndexOf(haystack, needle) → last position, or -1 if not found.
/// Brute-force O(n·m) backward scan. needle="" always returns la (length of haystack).
/// Tier 2 with Sprint 18 DSL: WVar, WArray, WasmDsl, loopResult.
/// NOTE: Same non-short-circuit AND avoidance as makeStrIndexOfHelper.
let makeStrLastIndexOfHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let gen = LabelGen "slio"
    makeFunc "$strLastIndexOf" [("$ha", strRef); ("$ne", strRef)] WType.I32 (
        let ha = WArray.wrap WType.I32 (localGet "$ha" strRef)
        let ne = WArray.wrap WType.I32 (localGet "$ne" strRef)
        wasm {
            let! la = ha.Len
            let! lb = ne.Len
            return
                wasmIf (lb =. i32Const 0)
                    la
                    (WVar.letMut gen "i" WType.I32 (la -. lb) (fun i ->
                        loopResult WType.I32 (i32Const -1) (fun brk ->
                            wasmIf (i.Val >=. i32Const 0)
                                (WVar.letMut gen "j" WType.I32 (i32Const 0) (fun j ->
                                    let jBlkLbl = gen.Next("jlb")
                                    let jLpLbl  = gen.Next("jl")
                                    sequence [
                                        WExpr.Block(jBlkLbl,
                                            WExpr.Loop(jLpLbl,
                                                sequence [
                                                    wasmWhen (j.Val >=. lb) (brk i.Val)
                                                    wasmWhen (ha.[i.Val +. j.Val] <>. ne.[j.Val])
                                                        (WExpr.Break(jBlkLbl, None))
                                                    j.Update (fun v -> v +. i32Const 1)
                                                    WExpr.Continue(jLpLbl, [])
                                                ],
                                                WType.Void),
                                            WType.Void)
                                        i.Update (fun v -> v -. i32Const 1)
                                    ]))
                                (brk (i32Const -1)))))
        })

/// Runtime helper: $strSubstring(str, start, len) → new string sub-array.
let makeStrSubstringHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let srcG  = localGet "$ssub_src"   strRef
    let startG = localGet "$ssub_start" WType.I32
    let lenG   = localGet "$ssub_len"   WType.I32
    makeFunc "$strSubstring" [("$ssub_src", strRef); ("$ssub_start", WType.I32); ("$ssub_len", WType.I32)] strRef (
        wasm {
            let! res = arrayNew StringTypeIdx lenG (i32Const 0) strRef
            do! arrayCopy res (i32Const 0) srcG startG lenG
            return res
        })

/// Runtime helper: $strToLower(s) → ASCII-only case fold (A-Z → a-z).
let makeStrToLowerHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet = localGet "$stl_src" strRef
    makeFunc "$strToLower" [("$stl_src", strRef)] strRef (
        wasm {
            let! len = arrayLen srcGet
            let! res = arrayNew StringTypeIdx len (i32Const 0) strRef
            do! countLoop "$stl" len (fun i ->
                    WExpr.Let("$stl_c", arrayGet srcGet i i32,
                        let cGet = localGet "$stl_c" i32
                        arraySet res i
                            (wasmIf (wasmAnd (geS cGet (i32Const 65)) (leS cGet (i32Const 90)))
                                (add cGet (i32Const 32))
                                cGet)))
            return res
        })

/// Runtime helper: $strToUpper(s) → ASCII-only case fold (a-z → A-Z).
let makeStrToUpperHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet = localGet "$stu_src" strRef
    makeFunc "$strToUpper" [("$stu_src", strRef)] strRef (
        wasm {
            let! len = arrayLen srcGet
            let! res = arrayNew StringTypeIdx len (i32Const 0) strRef
            do! countLoop "$stu" len (fun i ->
                    WExpr.Let("$stu_c", arrayGet srcGet i i32,
                        let cGet = localGet "$stu_c" i32
                        arraySet res i
                            (wasmIf (wasmAnd (geS cGet (i32Const 97)) (leS cGet (i32Const 122)))
                                (sub cGet (i32Const 32))
                                cGet)))
            return res
        })

/// Runtime helper: $strTrim(s) → skip leading/trailing whitespace (chars ≤ 32).
let makeStrTrimHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet = localGet "$str_src" strRef
    let sGet   = localGet "$str_s"   i32
    let eGet   = localGet "$str_e"   i32
    makeFunc "$strTrim" [("$str_src", strRef)] strRef (
        wasm {
            let! len = arrayLen srcGet
            return WExpr.LetMut("$str_s", i32Const 0,
                WExpr.LetMut("$str_e", len,
                    sequence [
                        whileLoop "$str_sl"
                            (wasmAnd (ltS sGet len) (leS (arrayGet srcGet sGet i32) (i32Const 32)))
                            (localSet "$str_s" (add sGet (i32Const 1)))
                        whileLoop "$str_el"
                            (wasmAnd (gtS eGet sGet) (leS (arrayGet srcGet (sub eGet (i32Const 1)) i32) (i32Const 32)))
                            (localSet "$str_e" (sub eGet (i32Const 1)))
                        call "$strSubstring" [srcGet; sGet; sub eGet sGet] strRef
                    ]))
        })

/// Runtime helper: $strTrimStart(s) → skip leading whitespace (chars ≤ 32).
let makeStrTrimStartHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet = localGet "$strs_src" strRef
    let sGet   = localGet "$strs_s"   i32
    makeFunc "$strTrimStart" [("$strs_src", strRef)] strRef (
        wasm {
            let! len = arrayLen srcGet
            return WExpr.LetMut("$strs_s", i32Const 0,
                sequence [
                    whileLoop "$strs_sl"
                        (wasmAnd (ltS sGet len) (leS (arrayGet srcGet sGet i32) (i32Const 32)))
                        (localSet "$strs_s" (add sGet (i32Const 1)))
                    call "$strSubstring" [srcGet; sGet; sub len sGet] strRef
                ])
        })

/// Runtime helper: $strTrimEnd(s) → skip trailing whitespace (chars ≤ 32).
let makeStrTrimEndHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet = localGet "$stre_src" strRef
    let eGet   = localGet "$stre_e"   i32
    makeFunc "$strTrimEnd" [("$stre_src", strRef)] strRef (
        wasm {
            let! len = arrayLen srcGet
            return WExpr.LetMut("$stre_e", len,
                sequence [
                    whileLoop "$stre_el"
                        (wasmAnd (gtS eGet (i32Const 0)) (leS (arrayGet srcGet (sub eGet (i32Const 1)) i32) (i32Const 32)))
                        (localSet "$stre_e" (sub eGet (i32Const 1)))
                    call "$strSubstring" [srcGet; i32Const 0; eGet] strRef
                ])
        })

/// Runtime helper: $intToStr(n) → decimal string representation of an i32.
let makeIntToStrHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let nGet   = localGet "$its_n"   i32
    let negGet = localGet "$its_neg" i32
    let vGet   = localGet "$its_v"   i32
    let bufGet = localGet "$its_buf" strRef
    let lenGet = localGet "$its_len" i32
    let resGet = localGet "$its_res" strRef
    let zeroStr   = WExpr.ArrayNewFixed(StringTypeIdx, [i32Const 48], strRef) // "0"
    let minusPfx  = WExpr.ArrayNewFixed(StringTypeIdx, [i32Const 45], strRef) // "-"
    makeFunc "$intToStr" [("$its_n", i32)] strRef (
        block_ "$its_outer" strRef (
            wasmIf (eq nGet (i32Const 0))
                (WExpr.Break("$its_outer", Some zeroStr))
                (WExpr.LetMut("$its_neg", i32Const 0,
                 WExpr.LetMut("$its_v", nGet,
                    sequence [
                        wasmWhen (ltS nGet (i32Const 0))
                            (sequence [
                                localSet "$its_neg" (i32Const 1)
                                localSet "$its_v" (sub (i32Const 0) nGet)
                            ])
                        WExpr.Let("$its_buf", arrayNew StringTypeIdx (i32Const 12) (i32Const 0) strRef,
                        WExpr.LetMut("$its_len", i32Const 0,
                            sequence [
                                // Extract digits in reverse
                                whileLoop "$its_ext" (ne vGet (i32Const 0))
                                    (sequence [
                                        arraySet bufGet lenGet (add (rem_ vGet (i32Const 10)) (i32Const 48))
                                        localSet "$its_v" (div_ vGet (i32Const 10))
                                        localSet "$its_len" (add lenGet (i32Const 1))
                                    ])
                                // Copy digits in correct order
                                WExpr.Let("$its_res", arrayNew StringTypeIdx lenGet (i32Const 0) strRef,
                                    sequence [
                                        countLoop "$its_cpy" lenGet (fun iGet ->
                                            arraySet resGet iGet
                                                (arrayGet bufGet (sub (sub lenGet iGet) (i32Const 1)) i32))
                                        wasmIf (ne negGet (i32Const 0))
                                            (call "$strConcat" [minusPfx; resGet] strRef)
                                            resGet
                                    ])
                            ]))
                    ])))))

/// Runtime helper: $floatToStr(f) → decimal string representation of an f64.
/// Produces up to 6 significant decimal digits with trailing zeros trimmed.
/// Examples: 3.14 → "3.14", -2.5 → "-2.5", 42.0 → "42.0", 0.0 → "0".
/// Limitation: integer part is truncated to i32 range (~±2.1×10⁹).
let makeFloatToStrHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let f64 = WType.F64
    let fG   = localGet "$fts_f"   f64
    let faG  = localGet "$fts_fa"  f64
    let ipG  = localGet "$fts_ip"  i32
    let fiG  = localGet "$fts_fi"  i32
    let fvG  = localGet "$fts_fv"  i32
    let feG  = localGet "$fts_fe"  i32
    let fbG  = localGet "$fts_fb"  strRef
    let dfG  = localGet "$fts_df"  strRef
    let isG  = localGet "$fts_is"  strRef
    let resG = localGet "$fts_res" strRef
    let c0 = i32Const 48
    let divI x n = WExpr.Binary(WBinaryOp.DivS, x, i32Const n, i32)
    let remI x n = WExpr.Binary(WBinaryOp.RemS, x, i32Const n, i32)
    let toDigit x = add x c0
    let litStr (s: string) =
        WExpr.ArrayNewFixed(StringTypeIdx,
            s |> Seq.map (fun c -> i32Const (int c)) |> Seq.toList, strRef)
    let setDigit idx divisor =
        sequence [
            arraySet fbG (i32Const idx) (toDigit (divI fvG divisor))
            localSet "$fts_fv" (remI fvG divisor)
        ]
    let buildWithFrac =
        WExpr.Let("$fts_fb", arrayNew StringTypeIdx (i32Const 6) c0 strRef,
        WExpr.LetMut("$fts_fv", fiG,
        WExpr.LetMut("$fts_fe", i32Const 6,
        sequence [
            setDigit 0 100000; setDigit 1 10000; setDigit 2 1000
            setDigit 3 100; setDigit 4 10
            arraySet fbG (i32Const 5) (toDigit fvG)
            // Trim trailing '0' chars but keep at least 1 digit
            whileLoop "$fts_trim"
                (wasmAnd (gtS feG (i32Const 1))
                         (eq (arrayGet fbG (sub feG (i32Const 1)) i32) c0))
                (localSet "$fts_fe" (sub feG (i32Const 1)))
            WExpr.Let("$fts_df", arrayNew StringTypeIdx (add feG (i32Const 1)) c0 strRef,
                sequence [
                    arraySet dfG (i32Const 0) (i32Const 46) // '.'
                    arrayCopy dfG (i32Const 1) fbG (i32Const 0) feG
                    call "$strConcat" [isG; dfG] strRef
                ])
        ])))
    let absExpr =
        WExpr.If(WExpr.Compare(WCompareOp.LtS, fG, f64Const 0.0),
            WExpr.Unary(WUnaryOp.Neg, fG, f64), fG, f64)
    let fracPartMul =
        mulf64 (subf64 faG (WExpr.Unary(WUnaryOp.ConvertI32S, ipG, f64))) (f64Const 1000000.0)
    makeFunc "$floatToStr" [("$fts_f", f64)] strRef (
        block_ "$fts_ret" strRef (
            wasmIf (WExpr.Compare(WCompareOp.Eq, fG, f64Const 0.0))
                (WExpr.Break("$fts_ret", Some (litStr "0")))
                (WExpr.Let("$fts_fa", absExpr,
                 WExpr.Let("$fts_ip", WExpr.Unary(WUnaryOp.TruncF64S, faG, i32),
                 WExpr.Let("$fts_fi", WExpr.Unary(WUnaryOp.TruncF64S, fracPartMul, i32),
                 WExpr.Let("$fts_is", call "$intToStr" [ipG] strRef,
                 WExpr.Let("$fts_res",
                    wasmIf (eq fiG (i32Const 0))
                        (call "$strConcat" [isG; litStr ".0"] strRef)
                        buildWithFrac,
                    wasmIf (WExpr.Compare(WCompareOp.LtS, fG, f64Const 0.0))
                        (call "$strConcat" [litStr "-"; resG] strRef)
                        resG))))))))

/// Runtime helper: $strPadLeft(str, width) → pad with spaces on the left.
let makeStrPadLeftHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet = localGet "$spl_src" strRef
    let widthGet = localGet "$spl_w" i32
    let laGet = localGet "$spl_la" i32
    let padGet = localGet "$spl_pad" i32
    let resGet = localGet "$spl_res" strRef
    makeFunc "$strPadLeft" [("$spl_src", strRef); ("$spl_w", i32)] strRef (
        WExpr.Let("$spl_la", arrayLen srcGet,
        block_ "$spl_ret" strRef (
            wasmIf (geS laGet widthGet)
                (WExpr.Break("$spl_ret", Some srcGet))
                (WExpr.Let("$spl_pad", sub widthGet laGet,
                 WExpr.Let("$spl_res", arrayNew StringTypeIdx widthGet (i32Const 32) strRef,
                    sequence [
                        arrayCopy resGet padGet srcGet (i32Const 0) laGet
                        resGet
                    ]))))))

/// Runtime helper: $strPadRight(str, width) → pad with spaces on the right.
let makeStrPadRightHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet = localGet "$spr_src" strRef
    let widthGet = localGet "$spr_w" i32
    let laGet = localGet "$spr_la" i32
    let resGet = localGet "$spr_res" strRef
    makeFunc "$strPadRight" [("$spr_src", strRef); ("$spr_w", i32)] strRef (
        WExpr.Let("$spr_la", arrayLen srcGet,
        block_ "$spr_ret" strRef (
            wasmIf (geS laGet widthGet)
                (WExpr.Break("$spr_ret", Some srcGet))
                (WExpr.Let("$spr_res", arrayNew StringTypeIdx widthGet (i32Const 32) strRef,
                    sequence [
                        arrayCopy resGet (i32Const 0) srcGet (i32Const 0) laGet
                        resGet
                    ])))))

/// Runtime helper: $strReplace(src, from, to) → replace all occurrences of `from` with `to`.
let makeStrReplaceHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let srcGet  = localGet "$srep_src"  strRef
    let fromGet = localGet "$srep_from" strRef
    let toGet   = localGet "$srep_to"   strRef
    let laGet   = localGet "$srep_la"   i32
    let loGet   = localGet "$srep_lo"   i32
    let posGet  = localGet "$srep_pos"  i32
    let resGet  = localGet "$srep_res"  strRef
    let jGet    = localGet "$srep_j"    i32
    let srcTail = call "$strSubstring" [srcGet; posGet; sub laGet posGet] strRef
    let emptyStr = WExpr.ArrayNewFixed(StringTypeIdx, [], strRef)
    makeFunc "$strReplace" [("$srep_src", strRef); ("$srep_from", strRef); ("$srep_to", strRef)] strRef (
        WExpr.Let("$srep_la", arrayLen srcGet,
        WExpr.Let("$srep_lo", arrayLen fromGet,
        block_ "$srep_ret" strRef (
            wasmIf (eq loGet (i32Const 0))
                (WExpr.Break("$srep_ret", Some srcGet))
                (WExpr.LetMut("$srep_pos", i32Const 0,
                 WExpr.LetMut("$srep_res", emptyStr,
                    sequence [
                        WExpr.Block("$srep_inner",
                            WExpr.Loop("$srep_loop",
                                WExpr.Let("$srep_j", call "$strIndexOf" [srcTail; fromGet] i32,
                                    wasmIf (ltS jGet (i32Const 0))
                                        (WExpr.Break("$srep_inner", None))
                                        (sequence [
                                            localSet "$srep_res" (call "$strConcat" [
                                                resGet
                                                call "$strSubstring" [srcGet; posGet; jGet] strRef
                                            ] strRef)
                                            localSet "$srep_res" (call "$strConcat" [resGet; toGet] strRef)
                                            localSet "$srep_pos" (add posGet (add jGet loGet))
                                            WExpr.Continue("$srep_loop", [])
                                        ])),
                                WType.Void),
                            WType.Void)
                        call "$strConcat" [resGet; srcTail] strRef
                    ])))))))
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
let makeIntParseHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32    = WType.I32
    let sGet   = localGet "$ip_s"   strRef
    let lenGet = localGet "$ip_len" i32
    let iGet   = localGet "$ip_i"   i32
    let negGet = localGet "$ip_neg" i32
    let accGet = localGet "$ip_acc" i32
    let chGet  = localGet "$ip_ch"  i32
    makeFunc "$parseInt" [("$ip_s", strRef)] i32 (
        WExpr.Let("$ip_len", arrayLen sGet,
        block_ "$ip_ret" i32 (
            wasmIf (eq lenGet (i32Const 0))
                (WExpr.Break("$ip_ret", Some (i32Const 0)))
                (WExpr.LetMut("$ip_i",   i32Const 0,
                 WExpr.LetMut("$ip_neg", i32Const 0,
                 WExpr.LetMut("$ip_acc", i32Const 0,
                    sequence [
                        // Check for leading '-'
                        WExpr.Let("$ip_ch", arrayGet sGet (i32Const 0) i32,
                            wasmWhen (eq chGet (i32Const 45)) // '-'
                                (sequence [
                                    localSet "$ip_neg" (i32Const 1)
                                    localSet "$ip_i"   (i32Const 1)
                                ]))
                        // Accumulate digits
                        whileLoop "$ip_loop" (ltS iGet lenGet)
                            (WExpr.Let("$ip_ch", arrayGet sGet iGet i32,
                                sequence [
                                    wasmWhen (wasmOr
                                            (ltS chGet (i32Const 48))  // < '0'
                                            (gtS chGet (i32Const 57))) // > '9'
                                        (WExpr.Break("$ip_ret", Some (i32Const 0)))
                                    localSet "$ip_acc" (add (mul accGet (i32Const 10)) (sub chGet (i32Const 48)))
                                    localSet "$ip_i" (add iGet (i32Const 1))
                                ]))
                        wasmIf (ne negGet (i32Const 0))
                            (sub (i32Const 0) accGet)
                            accGet
                    ])))))))

/// Runtime helper: $parseFloat(s) → parse decimal string to f64.
/// Handles optional leading '-' and one decimal point. Returns 0.0 on invalid.
let makeFloatParseHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32    = WType.I32
    let f64    = WType.F64
    let sGet   = localGet "$fp_s"    strRef
    let lenGet = localGet "$fp_len"  i32
    let iGet   = localGet "$fp_i"    i32
    let negGet = localGet "$fp_neg"  i32
    let intGet = localGet "$fp_int"  i32
    let fracGet= localGet "$fp_frac" f64
    let divGet = localGet "$fp_div"  f64
    let chGet  = localGet "$fp_ch"   i32
    let dotGet = localGet "$fp_dot"  i32
    // Helpers to avoid duplicating the final result expression
    let toF64 e  = WExpr.Unary(WUnaryOp.ConvertI32S, e, f64)
    let negResult = WExpr.Unary(WUnaryOp.Neg, addf64 (toF64 intGet) fracGet, f64)
    let posResult = addf64 (toF64 intGet) fracGet
    // The main parsing body — extracted to keep nesting depth manageable
    let innerBody =
        WExpr.LetMut("$fp_i",    i32Const 0,
        WExpr.LetMut("$fp_neg",  i32Const 0,
        WExpr.LetMut("$fp_int",  i32Const 0,
        WExpr.LetMut("$fp_frac", f64Const 0.0,
        WExpr.LetMut("$fp_div",  f64Const 1.0,
        WExpr.LetMut("$fp_dot",  i32Const 0,
            sequence [
                // Check for leading '-'
                WExpr.Let("$fp_ch", arrayGet sGet (i32Const 0) i32,
                    wasmWhen (eq chGet (i32Const 45)) // '-'
                        (sequence [
                            localSet "$fp_neg" (i32Const 1)
                            localSet "$fp_i"   (i32Const 1)
                        ]))
                // Parse integer and fractional parts
                whileLoop "$fp_loop" (ltS iGet lenGet)
                    (WExpr.Let("$fp_ch", arrayGet sGet iGet i32,
                        sequence [
                            wasmWhen (eq chGet (i32Const 46)) // '.'
                                (sequence [
                                    localSet "$fp_dot" (i32Const 1)
                                    localSet "$fp_i" (add iGet (i32Const 1))
                                    WExpr.Continue("$fp_loop", [])
                                ])
                            wasmWhen (wasmOr (ltS chGet (i32Const 48)) (gtS chGet (i32Const 57)))
                                (WExpr.Break("$fp_ret", Some (f64Const 0.0)))
                            WExpr.Let("$fp_ch", sub chGet (i32Const 48),
                                wasmIf (eq dotGet (i32Const 0))
                                    // Integer part
                                    (localSet "$fp_int" (add (mul intGet (i32Const 10)) chGet))
                                    // Fractional part
                                    (sequence [
                                        localSet "$fp_div" (mulf64 divGet (f64Const 10.0))
                                        localSet "$fp_frac"
                                            (addf64 fracGet
                                                (divf64 (WExpr.Unary(WUnaryOp.ConvertI32S, chGet, f64)) divGet))
                                    ]))
                            localSet "$fp_i" (add iGet (i32Const 1))
                        ]))
                wasmIf (ne negGet (i32Const 0)) negResult posResult
            ]))))))
    makeFunc "$parseFloat" [("$fp_s", strRef)] f64 (
        WExpr.Let("$fp_len", arrayLen sGet,
        block_ "$fp_ret" f64 (
            wasmIf (eq lenGet (i32Const 0))
                (WExpr.Break("$fp_ret", Some (f64Const 0.0)))
                innerBody)))

// ─────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────

/// Runtime helper: $strCompare(a, b) → i32  (-1 | 0 | 1)
/// Lexicographic comparison of two WasmStr arrays (char by char, then by length).
let makeStrCompareHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let aGet = localGet "$sc_a" strRef
    let bGet = localGet "$sc_b" strRef
    let iGet = localGet "$sc_i" i32
    let laGet = localGet "$sc_la" i32
    let lbGet = localGet "$sc_lb" i32
    let caGet = localGet "$sc_ca" i32
    let cbGet = localGet "$sc_cb" i32
    let minLen la lb = wasmIf (ltS la lb) la lb
    let charCompare =
        WExpr.Let("$sc_ca", arrayGet aGet iGet i32,
        WExpr.Let("$sc_cb", arrayGet bGet iGet i32,
            wasmIf (gtS caGet cbGet)
                (WExpr.Break("$sc_ret", Some (i32Const 1)))
                (wasmIf (ltS caGet cbGet)
                    (WExpr.Break("$sc_ret", Some (i32Const (-1))))
                    WExpr.Nop)))
    let loopBody =
        wasmIf (geS iGet (minLen laGet lbGet))
            (WExpr.Sequence [
                wasmIf (gtS laGet lbGet) (WExpr.Break("$sc_ret", Some (i32Const 1))) WExpr.Nop
                wasmIf (ltS laGet lbGet) (WExpr.Break("$sc_ret", Some (i32Const (-1)))) WExpr.Nop
                WExpr.Break("$sc_ret", Some (i32Const 0))])
            (WExpr.Sequence [
                charCompare
                localSet "$sc_i" (add iGet (i32Const 1))
                continue_ "$sc_lp"])
    let body =
        WExpr.Let("$sc_la", arrayLen aGet,
        WExpr.Let("$sc_lb", arrayLen bGet,
            block_ "$sc_ret" i32 (
                WExpr.LetMut("$sc_i", i32Const 0,
                    WExpr.Sequence [
                        loop "$sc_lp" loopBody
                        i32Const 0     // unreachable fallthru, satisfies block type
                    ]))))
    makeFunc "$strCompare" [("$sc_a", strRef); ("$sc_b", strRef)] i32 body

// ─────────────────────────────────────────────────────────────────
// Tier 1 — char helpers (QuotationWalker-translated)
// ─────────────────────────────────────────────────────────────────

/// Type-map used when translating runtime quotations: strings map to StringTypeIdx.
let private runtimeTypeMap : QTypeMap =
    { StrTypeIdx = StringTypeIdx; ResolveCustom = fun _ -> None }

/// Intrinsics used when translating runtime quotations.
let private runtimeIntrinsics = standardIntrinsics StringTypeIdx

/// Translate an inline quotation to a WFuncDecl and collect locals.
/// The WFuncDecl returned by translateReflected has Locals = [];
/// resolveLocals fills them in so the function is self-contained.
let private q (name: string) (qexpr: Microsoft.FSharp.Quotations.Expr) : WFuncDecl =
    translateReflected name runtimeTypeMap runtimeIntrinsics qexpr
    |> resolveLocals

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

// ─────────────────────────────────────────────────────────────────
// Tier 1 — integer math helpers
// ─────────────────────────────────────────────────────────────────

/// Runtime helper: $pown(x, n) → integer exponentiation by repeated squaring.
/// For n ≤ 0 returns 1 (consistent with F#'s pown for nonneg exponents).
let makePownHelper () : WFuncDecl =
    q "$pown"
        <@ fun (x: int) (n: int) ->
            let mutable result = 1
            let mutable b = x
            let mutable e = n
            while e > 0 do
                if e &&& 1 <> 0 then result <- result * b
                b <- b * b
                e <- e >>> 1
            result @>

/// After all functions are translated, fixup any ClosureApply nodes whose
let fixClosureApply (typeDefs: seq<WTypeDeclEntry>) (functions: WFuncDecl list) : WFuncDecl list =
    let funcTypeToClosureMap =
        typeDefs
        |> Seq.mapi (fun i entry -> i, entry)
        |> Seq.choose (fun (i, entry) ->
            match entry.Def with
            | WTypeDef.Struct(codeField :: _, Some _) when codeField.Name = "code" ->
                match codeField.Type with
                | WType.Ref(funcTypeIdx, _) -> Some(funcTypeIdx, i)
                | _ -> None
            | _ -> None)
        |> dict

    let rec fix (expr: WExpr) : WExpr =
        match expr with
        | WExpr.ClosureApply(closure, args, funcTypeIdx, 0, captureCount, ty) ->
            let closureTypeIdx =
                match funcTypeToClosureMap.TryGetValue(funcTypeIdx) with
                | true, cti -> cti
                | false, _ -> 0
            WExpr.ClosureApply(fix closure, List.map fix args, funcTypeIdx, closureTypeIdx, captureCount, ty)
        | WExpr.ClosureApply(closure, args, funcTypeIdx, closureTypeIdx, captureCount, ty) ->
            WExpr.ClosureApply(fix closure, List.map fix args, funcTypeIdx, closureTypeIdx, captureCount, ty)
        | WExpr.Let(n, v, body) -> WExpr.Let(n, fix v, fix body)
        | WExpr.LetMut(n, v, body) -> WExpr.LetMut(n, fix v, fix body)
        | WExpr.If(c, t, e, ty) -> WExpr.If(fix c, fix t, fix e, ty)
        | WExpr.Sequence exprs -> WExpr.Sequence(List.map fix exprs)
        | WExpr.Call(name, args, ty) -> WExpr.Call(name, List.map fix args, ty)
        | WExpr.Loop(l, body, ty) -> WExpr.Loop(l, fix body, ty)
        | WExpr.Block(l, body, ty) -> WExpr.Block(l, fix body, ty)
        | WExpr.JoinPoint(l, p, body, cont, ty) ->
            WExpr.JoinPoint(l, p, fix body, fix cont, ty)
        | WExpr.SwitchInt(s, cases, def, ty) ->
            WExpr.SwitchInt(fix s, List.map (fun (v, e) -> v, fix e) cases, fix def, ty)
        | _ -> expr

    functions |> List.map (fun f -> { f with Body = fix f.Body })
