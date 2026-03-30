/// Runtime helpers and local-variable analysis for WasmGC.
/// Extracted from Fable2WasmGc.fs — contains: collectLocals, resolveLocals,
/// string runtime helpers ($strConcat, $strEq), and fixClosureApply.
module Fable.Transforms.WasmGc.WasmGcRuntime

open Fable.AST.WasmGc
open Fable.Transforms.WasmGc.WasmGcTypes
open Fable.Transforms.WasmGc.WasmGcBuilder

// ─────────────────────────────────────────────────────────────────
// Local variable collection
// ─────────────────────────────────────────────────────────────────

/// Collect all locals used within a WExpr (for the WASM code section).
/// Returns (name, WType) pairs for all Let/LetMut bindings not in paramNames.
let rec collectLocals (paramNames: Set<string>) (expr: WExpr) : (string * WType) list =
    match expr with
    | WExpr.Let(name, value, body) | WExpr.LetMut(name, value, body) ->
        let valueTy = exprWType value
        let local =
            if Set.contains name paramNames then []
            else
                // If the value has Void type (e.g., WExpr.Nop from unhandled calls),
                // infer the local type from how it's used (LocalGet) in the body.
                let ty =
                    if valueTy <> WType.Void then valueTy
                    else
                        // Find first LocalGet(name, ty) in body to get the actual type
                        let rec findType (e: WExpr) =
                            match e with
                            | WExpr.LocalGet(n, ty) when n = name && ty <> WType.Void -> Some ty
                            | WExpr.Let(_, v, b) | WExpr.LetMut(_, v, b) ->
                                match findType v with
                                | Some ty -> Some ty
                                | None -> findType b
                            | WExpr.If(c, thenE, elseE, _) ->
                                match findType c with
                                | Some ty -> Some ty
                                | None ->
                                    match findType thenE with
                                    | Some ty -> Some ty
                                    | None -> findType elseE
                            | WExpr.Sequence exprs ->
                                exprs |> List.tryPick findType
                            | WExpr.Call(_, args, _) | WExpr.TailCall(_, args, _) ->
                                args |> List.tryPick findType
                            | WExpr.StructGet(obj, _, _) | WExpr.ArrayLen obj
                            | WExpr.Cast(obj, _) | WExpr.RefIsNull obj
                            | WExpr.TagOf obj | WExpr.Loop(_, obj, _) | WExpr.Block(_, obj, _) ->
                                findType obj
                            | WExpr.Unary(_, obj, _) -> findType obj
                            | WExpr.Binary(_, l, r, _) | WExpr.Compare(_, l, r) ->
                                match findType l with
                                | Some ty -> Some ty
                                | None -> findType r
                            | WExpr.JoinPoint(_, _, b, cont, _) ->
                                match findType b with
                                | Some ty -> Some ty
                                | None -> findType cont
                            | WExpr.JoinApply(_, args, _) -> args |> List.tryPick findType
                            | WExpr.StructNew(_, fields, _) -> fields |> List.tryPick findType
                            | WExpr.ArrayNewFixed(_, elems, _) -> elems |> List.tryPick findType
                            | WExpr.ArrayGet(arr, idx, _) ->
                                match findType arr with
                                | Some ty -> Some ty
                                | None -> findType idx
                            | _ -> None
                        match findType body with
                        | Some t -> t
                        | None -> WType.I32  // last resort: assume I32
                if ty = WType.Void then []
                else [(name, ty)]
        local @ collectLocals paramNames value @ collectLocals paramNames body
    | WExpr.If(c, t, e, _) ->
        collectLocals paramNames c @ collectLocals paramNames t @ collectLocals paramNames e
    | WExpr.Sequence exprs ->
        exprs |> List.collect (collectLocals paramNames)
    | WExpr.Loop(_, body, _) ->
        collectLocals paramNames body
    | WExpr.Block(_, body, _) ->
        collectLocals paramNames body
    | WExpr.Call(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.CallIndirect(func, args, _) ->
        collectLocals paramNames func @ (args |> List.collect (collectLocals paramNames))
    | WExpr.Binary(_, l, r, _) ->
        collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Unary(_, op, _) ->
        collectLocals paramNames op
    | WExpr.Compare(_, l, r) ->
        collectLocals paramNames l @ collectLocals paramNames r
    | WExpr.Assign(_, v) ->
        collectLocals paramNames v
    | WExpr.GlobalSet(_, v) ->
        collectLocals paramNames v
    | WExpr.JoinPoint(_, _, body, cont, _) ->
        collectLocals paramNames body @ collectLocals paramNames cont
    | WExpr.JoinApply(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.TryCatch(body, catch, fin, _) ->
        let catchLocals =
            match catch with
            | Some(name, expr) -> [name, WType.I32] @ collectLocals paramNames expr
            | None -> []
        let finLocals =
            match fin with
            | Some expr -> collectLocals paramNames expr
            | None -> []
        collectLocals paramNames body @ catchLocals @ finLocals
    | WExpr.StructNew(_, fields, _) ->
        fields |> List.collect (collectLocals paramNames)
    | WExpr.StructGet(obj, _, _) ->
        collectLocals paramNames obj
    | WExpr.StructSet(obj, _, v) ->
        collectLocals paramNames obj @ collectLocals paramNames v
    | WExpr.ArrayNewFixed(_, elems, _) ->
        elems |> List.collect (collectLocals paramNames)
    | WExpr.ArrayGet(arr, idx, _) ->
        collectLocals paramNames arr @ collectLocals paramNames idx
    | WExpr.ArraySet(arr, idx, v) ->
        collectLocals paramNames arr @ collectLocals paramNames idx @ collectLocals paramNames v
    | WExpr.ArrayLen(arr) ->
        collectLocals paramNames arr
    | WExpr.ArrayCopy(dst, dstOff, src, srcOff, len) ->
        collectLocals paramNames dst
        @ collectLocals paramNames dstOff
        @ collectLocals paramNames src
        @ collectLocals paramNames srcOff
        @ collectLocals paramNames len
    | WExpr.ArrayNew(_, size, init, _) ->
        collectLocals paramNames size @ collectLocals paramNames init
    | WExpr.RefIsNull obj ->
        collectLocals paramNames obj
    | WExpr.Cast(obj, _) ->
        collectLocals paramNames obj
    | WExpr.Closure(_, captures, _) ->
        captures |> List.collect (collectLocals paramNames)
    | WExpr.ClosureApply(closure, args, _, _, _, _) ->
        // Always register $clo_apply_tmp (emitter uses local.tee unconditionally)
        let tmpLocal = ["$clo_apply_tmp", WType.Ref(AnyFnTypeIdx, false)]
        tmpLocal
        @ collectLocals paramNames closure
        @ (args |> List.collect (collectLocals paramNames))
    | WExpr.TailCall(_, args, _) ->
        args |> List.collect (collectLocals paramNames)
    | WExpr.TailCallRef(closure, args, _, _, _, _) ->
        let tmpLocal = ["$clo_apply_tmp", WType.Ref(AnyFnTypeIdx, false)]
        tmpLocal
        @ collectLocals paramNames closure
        @ (args |> List.collect (collectLocals paramNames))
    | _ -> []

/// Fill in the Locals field of a WFuncDecl by scanning the body.
let resolveLocals (func: WFuncDecl) : WFuncDecl =
    let paramNames = func.Params |> List.map fst |> Set.ofList
    let locals =
        collectLocals paramNames func.Body
        |> List.distinctBy fst
        |> List.filter (fun (_, ty) -> ty <> WType.Void)
    { func with Locals = locals }

/// Build a WFuncDecl with automatic local collection.
/// Eliminates the collectLocals boilerplate that appears on every helper.
let makeFunc (name: string) (parms: (string * WType) list) (result: WType) (body: WExpr) : WFuncDecl =
    let paramNames = parms |> List.map fst |> Set.ofList
    { Name     = name
      Params   = parms
      Result   = result
      Locals   = collectLocals paramNames body
                 |> List.distinctBy fst
                 |> List.filter (fun (_, ty) -> ty <> WType.Void)
      Body     = body
      Exported = false }

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
let makeStrIndexOfHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let haGet = localGet "$sio_ha" strRef
    let neGet = localGet "$sio_ne" strRef
    let iGet  = localGet "$sio_i"  i32
    let jGet  = localGet "$sio_j"  i32
    makeFunc "$strIndexOf" [("$sio_ha", strRef); ("$sio_ne", strRef)] i32 (
        wasm {
            let! la = arrayLen haGet
            let! lb = arrayLen neGet
            return wasmIf (eq lb (i32Const 0))
                (i32Const 0)
                (WExpr.LetMut("$sio_i", i32Const 0,
                    loopWithResult "$sio" i32
                        (wasmIf (leS iGet (sub la lb))
                            (WExpr.LetMut("$sio_j", i32Const 0,
                                sequence [
                                    whileLoop "$sio_jl"
                                        (wasmAnd (ltS jGet lb)
                                                 (eq (arrayGet haGet (add iGet jGet) i32)
                                                     (arrayGet neGet jGet i32)))
                                        (localSet "$sio_j" (add jGet (i32Const 1)))
                                    wasmIf (geS jGet lb)
                                        (WExpr.Break("$sio_exit", Some iGet))
                                        (localSet "$sio_i" (add iGet (i32Const 1)))
                                ]))
                            (WExpr.Break("$sio_exit", Some (i32Const -1))))
                        (i32Const -1)))
        })

/// Runtime helper: $strLastIndexOf(haystack, needle) → last position, or -1 if not found.
/// Brute-force O(n·m) backward scan. needle="" always returns la (length of haystack).
let makeStrLastIndexOfHelper () : WFuncDecl =
    let strRef = WType.Ref(StringTypeIdx, false)
    let i32 = WType.I32
    let haGet = localGet "$slio_ha" strRef
    let neGet = localGet "$slio_ne" strRef
    let iGet  = localGet "$slio_i"  i32
    let jGet  = localGet "$slio_j"  i32
    makeFunc "$strLastIndexOf" [("$slio_ha", strRef); ("$slio_ne", strRef)] i32 (
        wasm {
            let! la = arrayLen haGet
            let! lb = arrayLen neGet
            return wasmIf (eq lb (i32Const 0))
                la
                (WExpr.LetMut("$slio_i", sub la lb,
                    loopWithResult "$slio" i32
                        (wasmIf (geS iGet (i32Const 0))
                            (WExpr.LetMut("$slio_j", i32Const 0,
                                sequence [
                                    whileLoop "$slio_jl"
                                        (wasmAnd (ltS jGet lb)
                                                 (eq (arrayGet haGet (add iGet jGet) i32)
                                                     (arrayGet neGet jGet i32)))
                                        (localSet "$slio_j" (add jGet (i32Const 1)))
                                    wasmIf (geS jGet lb)
                                        (WExpr.Break("$slio_exit", Some iGet))
                                        (localSet "$slio_i" (sub iGet (i32Const 1)))
                                ]))
                            (WExpr.Break("$slio_exit", Some (i32Const -1))))
                        (i32Const -1)))
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

// ─────────────────────────────────────────────────────────────────
// Structural equality — Sprint 6
// ─────────────────────────────────────────────────────────────────

/// Return a WExpr (result: i32) that compares two WExprs of the given WType.
/// Uses registered equality functions for nested struct/DU types.
let rec compareByWType (ctx: Ctx) (ty: WType) (a: WExpr) (b: WExpr) : WExpr =
    match ty with
    | WType.I32 | WType.I64 | WType.F32 | WType.F64 ->
        WExpr.Compare(WCompareOp.Eq, a, b)
    | WType.Ref(idx, false) when idx = StringTypeIdx ->
        WExpr.Call("$strEq", [a; b], WType.I32)
    | WType.Ref(idx, false) ->
        // Non-nullable ref: look up or generate structural equality
        match ctx.EqualityRegistry.TryGetValue(idx) with
        | true, funcName -> WExpr.Call(funcName, [a; b], WType.I32)
        | false, _ ->
            // No equality function registered — fall back to reference equality
            WExpr.Compare(WCompareOp.Eq, a, b)
    | WType.Ref(idx, true) ->
        // Nullable ref: if both null → 1, one null → 0, both non-null → recurse
        let nullA = WExpr.RefIsNull a
        let nullB = WExpr.RefIsNull b
        WExpr.If(
            // if both null
            WExpr.Binary(WBinaryOp.And, nullA, nullB, WType.I32),
            WExpr.Const(WConst.I32 1),
            WExpr.If(
                // else if one null
                WExpr.Binary(WBinaryOp.Or, nullA, nullB, WType.I32),
                WExpr.Const(WConst.I32 0),
                // both non-null: cast to non-nullable and compare
                (match ctx.EqualityRegistry.TryGetValue(idx) with
                 | true, funcName ->
                     let aFixed = WExpr.Cast(a, WType.Ref(idx, false))
                     let bFixed = WExpr.Cast(b, WType.Ref(idx, false))
                     WExpr.Call(funcName, [aFixed; bFixed], WType.I32)
                 | false, _ -> WExpr.Compare(WCompareOp.Eq, a, b)),
                WType.I32),
            WType.I32)
    | _ -> WExpr.Compare(WCompareOp.Eq, a, b)

/// Generate an equality function for a record struct type.
/// `typeIdx` must be in ctx.TypeDefs; `fields` are the struct fields.
let makeRecordEqualsFunc (ctx: Ctx) (funcName: string) (typeIdx: int) (fields: WField list) : WFuncDecl =
    let refT = WType.Ref(typeIdx, false)
    let aGet = WExpr.LocalGet("$eq_a", refT)
    let bGet = WExpr.LocalGet("$eq_b", refT)
    let body =
        if fields.IsEmpty then
            WExpr.Const(WConst.I32 1)  // empty struct: always equal
        else
            let comps =
                fields |> List.mapi (fun i field ->
                    let fa = WExpr.StructGet(aGet, i, field.Type)
                    let fb = WExpr.StructGet(bGet, i, field.Type)
                    compareByWType ctx field.Type fa fb)
            comps |> List.fold (fun acc cmp ->
                WExpr.Binary(WBinaryOp.And, acc, cmp, WType.I32)
            ) (WExpr.Const(WConst.I32 1))
    let parms = [("$eq_a", refT); ("$eq_b", refT)]
    let paramNames = parms |> List.map fst |> Set.ofList
    { Name = funcName; Params = parms; Result = WType.I32
      Locals = collectLocals paramNames body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// Generate an equality function for a data-carrying DU base type.
/// `baseIdx` = type index of the base struct (tag field only).
/// `caseTypeIdxs` = type indices of case structs (baseIdx+1, baseIdx+2, ...).
let makeDuEqualsFunc (ctx: Ctx) (funcName: string) (baseIdx: int) (caseTypeIdxs: int list) : WFuncDecl =
    let baseRefT = WType.Ref(baseIdx, false)
    let aGet = WExpr.LocalGet("$eq_a", baseRefT)
    let bGet = WExpr.LocalGet("$eq_b", baseRefT)
    let tagA = WExpr.StructGet(aGet, 0, WType.I32)
    let tagB = WExpr.StructGet(bGet, 0, WType.I32)
    // If tags differ → 0. If same → compare case fields.
    let caseEquality =
        if caseTypeIdxs.IsEmpty then WExpr.Const(WConst.I32 1) else
        // Build if-else chain: if tag=0 then compare_case0 else if tag=1 then ...
        let tagLocal = WExpr.LocalGet("$eq_tag", WType.I32)
        let indexedCases = caseTypeIdxs |> List.mapi (fun i caseIdx -> (i, caseIdx))
        let caseChain =
            List.foldBack (fun (i, caseIdx) (elseExpr: WExpr) ->
                let caseRef = WType.Ref(caseIdx, false)
                let caseDef = (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[caseIdx]
                let caseFields =
                    match caseDef.Def with
                    | WTypeDef.Struct(fields, _) -> fields |> List.tail  // skip tag field
                    | _ -> []
                let caseEq =
                    if caseFields.IsEmpty then WExpr.Const(WConst.I32 1)
                    else
                        let castedA = WExpr.Cast(aGet, caseRef)
                        let castedB = WExpr.Cast(bGet, caseRef)
                        let comps =
                            caseFields |> List.mapi (fun fi field ->
                                let fa = WExpr.StructGet(castedA, fi + 1, field.Type)
                                let fb = WExpr.StructGet(castedB, fi + 1, field.Type)
                                compareByWType ctx field.Type fa fb)
                        comps |> List.fold (fun acc cmp ->
                            WExpr.Binary(WBinaryOp.And, acc, cmp, WType.I32)
                        ) (WExpr.Const(WConst.I32 1))
                WExpr.If(
                    WExpr.Compare(WCompareOp.Eq, tagLocal, WExpr.Const(WConst.I32 i)),
                    caseEq, elseExpr, WType.I32)
            ) indexedCases (WExpr.Const(WConst.I32 0))
        WExpr.Let("$eq_tag", tagA, caseChain)
    let body =
        WExpr.If(
            WExpr.Compare(WCompareOp.Ne, tagA, tagB),
            WExpr.Const(WConst.I32 0),
            caseEquality,
            WType.I32)
    let parms = [("$eq_a", baseRefT); ("$eq_b", baseRefT)]
    let paramNames = parms |> List.map fst |> Set.ofList
    { Name = funcName; Params = parms; Result = WType.I32
      Locals = collectLocals paramNames body |> List.distinctBy fst |> List.filter (fun (_, t) -> t <> WType.Void)
      Body = body; Exported = false }

/// Get or create a structural equality function for the struct/DU at `typeIdx`.
/// Registers in ctx.EqualityRegistry and adds to ctx.Functions.
/// Returns the function name.
let rec getOrAddStructuralEquals (ctx: Ctx) (typeIdx: int) : string option =
    match ctx.EqualityRegistry.TryGetValue(typeIdx) with
    | true, funcName -> Some funcName
    | false, _ ->
        if typeIdx >= ctx.TypeDefs.Count then None else
        let entry = (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[typeIdx]
        match entry.Def with
        | WTypeDef.Struct(fields, None) ->
            // Record or DU base — need to distinguish
            let isDuBase =
                // Check if there's a sub-type at typeIdx+1 that has superType = Some typeIdx
                typeIdx + 1 < ctx.TypeDefs.Count &&
                (match (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[typeIdx + 1].Def with
                 | WTypeDef.Struct(_, Some parent) -> parent = typeIdx
                 | _ -> false)
            let funcName = $"$equals_{typeIdx}"
            // Pre-register to prevent infinite recursion on recursive types
            ctx.EqualityRegistry.[typeIdx] <- funcName
            let func =
                if isDuBase then
                    // Collect all case type indices (consecutive sub-types)
                    let mutable caseIdx = typeIdx + 1
                    let caseTypeIdxs = System.Collections.Generic.List<int>()
                    while caseIdx < ctx.TypeDefs.Count &&
                          (match (ctx.TypeDefs :> System.Collections.Generic.IList<_>).[caseIdx].Def with
                           | WTypeDef.Struct(_, Some parent) -> parent = typeIdx
                           | _ -> false) do
                        caseTypeIdxs.Add(caseIdx)
                        caseIdx <- caseIdx + 1
                    makeDuEqualsFunc ctx funcName typeIdx (Seq.toList caseTypeIdxs)
                else
                    makeRecordEqualsFunc ctx funcName typeIdx fields
            ctx.Functions.Add(func)
            Some funcName
        | _ -> None

/// Get or create a structural equality function for a tuple type.
/// The tuple struct is in ctx.TupleRegistry by its wTypesKey.
let getOrAddTupleEquals (ctx: Ctx) (tupleTypeIdx: int) : string option =
    getOrAddStructuralEquals ctx tupleTypeIdx
