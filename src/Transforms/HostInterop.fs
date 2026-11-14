/// HostInterop — the ABI between WasmGC values and JavaScript for `[<Import("name", "module.js")>]` externs.
///
/// JS cannot read a WasmGC array or call a wasm closure, so values that are not plain numbers are marshalled at the
/// extern call site:
///
///   string arg / result   →  `externref`, converted by the JS String Builtins (`wasm:js-string`, no glue needed;
///                            the host instantiates with `{ builtins: ["js-string"] }`).  Our strings are `i32` arrays,
///                            the builtins read / write `i16` arrays, so each direction is one bulk call + one copy loop.
///   `string array` result →  `externref` JS array, read element-wise through `fsharp:host.arrLen / arrGet`.
///   function-typed arg    →  the closure is registered in a table (`$cb_clos`) and the host receives a JS function
///                            (`fsharp:host.callback(id)`) that calls back through the single export
///                            `__cb(id, a0..a3) → externref`.  One trampoline per distinct callback signature unboxes the
///                            `externref` arguments (`fsharp:host.x2i / x2f`, strings via the builtins), applies the closure
///                            and boxes the result (`i2x / f2x`).
///
/// Everything is demand-driven: a program without such externs gets none of it.
module WasmGc.Transforms.HostInterop

open Fable.AST
open WasmGc.Core.AST
open WasmGc.Runtime.Types
module Lc = WasmGc.Runtime.Locals

let private hostModule = "fsharp:host"
let private jsStringModule = "wasm:js-string"
/// A callback takes at most this many JS arguments (`float -> float -> int -> unit` has three).
let private maxCallbackArgs = 4

let private i32 (n: int) = WExpr.Const(WConst.I32 n)
let private nullOf (t: WType) = WExpr.Const(WConst.Null t)
let private local (n: string) (t: WType) = WExpr.LocalGet(n, t)
let private strTy = WType.Ref(StringTypeIdx, false)
let private isString (t: WType) = (t = strTy)

let private hasFunc (ctx: Ctx) (name: string) = ctx.Functions.Exists(fun f -> f.Name = name)
let private hasGlobal (ctx: Ctx) (name: string) = ctx.GlobalDecls.Exists(fun g -> g.Name = name)

/// Define a helper function once.
let private define (ctx: Ctx) (name: string) (parms: (string * WType) list) (result: WType) (build: unit -> WExpr) =
    if not (hasFunc ctx name) then
        ctx.Functions.Add(
            { Name = name; Params = parms; Result = result; Locals = []; Body = build (); Exported = false }
            |> Lc.resolveLocals)

/// `for $i in 0 .. n-1 do body $i` — `n` must be a local (it is re-read on every iteration).
let private forEach (n: WExpr) (body: WExpr -> WExpr) : WExpr =
    let i = local "$i" WType.I32
    WExpr.Let("$i", i32 0,
        WExpr.Loop("$hl",
            WExpr.If(
                WExpr.Compare(WCompareOp.LtS, i, n),
                WExpr.Sequence [ body i; WExpr.Assign("$i", WExpr.Binary(WBinaryOp.Add, i, i32 1, WType.I32)); WExpr.Continue("$hl", []) ],
                WExpr.Nop, WType.Void),
            WType.Void))

let private hostFn (ctx: Ctx) (name: string) (parms: WType list) (result: WType) =
    ctx.RegisterExternFunc(hostModule, name, parms, result)

let private jsString (ctx: Ctx) (name: string) (parms: WType list) (result: WType) =
    ctx.RegisterExternFunc(jsStringModule, name, parms, result)

// ─────────────────────────────────────────────────────────────────
// Strings
// ─────────────────────────────────────────────────────────────────

/// string → externref: a JS string (Builtins), or the module's own string made opaque (Exports: the host reads it through
/// `__str_len` / `__str_at`).
let strToHost (ctx: Ctx) (s: WExpr) : WExpr =
    let name = "$host_strToHost"
    define ctx name [ "$s", strTy ] WType.Externref (fun () ->
      match ctx.StringAbi with
      | Exports -> WExpr.Cast(local "$s" strTy, WType.Externref)
      | Builtins ->
        let arr = getOrAddArrayType ctx WType.I16
        let fromChars = jsString ctx "fromCharCodeArray" [ WType.Ref(arr, true); WType.I32; WType.I32 ] WType.ExternNonNull
        let n, tmp = local "$n" WType.I32, local "$tmp" (WType.Ref(arr, false))
        let s = local "$s" strTy
        WExpr.Let("$n", WExpr.ArrayLen s,
            WExpr.Let("$tmp", WExpr.ArrayNew(arr, n, i32 0, WType.Ref(arr, false)),
                WExpr.Sequence [
                    forEach n (fun i -> WExpr.ArraySet(tmp, i, WExpr.ArrayGet(s, i, WType.I32)))
                    WExpr.Call(fromChars, [ tmp; i32 0; n ], WType.Externref) ])))
    WExpr.Call(name, [ s ], WType.Externref)

/// externref → string: a JS string (Builtins), or a string the host built with `__str_new` / `__str_set` (Exports).
let strFromHost (ctx: Ctx) (x: WExpr) : WExpr =
    let name = "$host_strFromHost"
    define ctx name [ "$x", WType.Externref ] strTy (fun () ->
      match ctx.StringAbi with
      | Exports ->
        let x = local "$x" WType.Externref
        // our strings are never null: a host null / undefined arrives as ""
        WExpr.If(WExpr.RefIsNull x, WExpr.ArrayNew(StringTypeIdx, i32 0, i32 0, strTy), WExpr.Cast(x, strTy), strTy)
      | Builtins ->
        let arr = getOrAddArrayType ctx WType.I16
        let length = jsString ctx "length" [ WType.Externref ] WType.I32
        let into = jsString ctx "intoCharCodeArray" [ WType.Externref; WType.Ref(arr, true); WType.I32 ] WType.I32
        let x = local "$x" WType.Externref
        let n, tmp, res = local "$n" WType.I32, local "$tmp" (WType.Ref(arr, false)), local "$res" strTy
        // our strings are never null: a JS null / undefined (`localStorage.getItem` of a missing key) arrives as ""
        WExpr.If(
            WExpr.RefIsNull x,
            WExpr.ArrayNew(StringTypeIdx, i32 0, i32 0, strTy),
            WExpr.Let("$n", WExpr.Call(length, [ x ], WType.I32),
                WExpr.Let("$tmp", WExpr.ArrayNew(arr, n, i32 0, WType.Ref(arr, false)),
                    WExpr.Let("$res", WExpr.ArrayNew(StringTypeIdx, n, i32 0, strTy),
                        WExpr.Sequence [
                            WExpr.Call(into, [ x; tmp; i32 0 ], WType.I32)
                            // the i16 array reads sign-extended: mask to the unsigned UTF-16 code unit
                            forEach n (fun i ->
                                WExpr.ArraySet(res, i, WExpr.Binary(WBinaryOp.And, WExpr.ArrayGet(tmp, i, WType.I32), i32 0xFFFF, WType.I32)))
                            res ]))),
            strTy))
    WExpr.Call(name, [ x ], strTy)

/// externref (a JS array of strings) → string array.
let private stringArrayFromHost (ctx: Ctx) (x: WExpr) : WExpr =
    let name = "$host_strArrFromHost"
    let arr = getOrAddArrayType ctx strTy
    define ctx name [ "$x", WType.Externref ] (WType.Ref(arr, false)) (fun () ->
        let len = hostFn ctx "arrLen" [ WType.Externref ] WType.I32
        let get = hostFn ctx "arrGet" [ WType.Externref; WType.I32 ] WType.Externref
        let x = local "$x" WType.Externref
        let n, res = local "$n" WType.I32, local "$res" (WType.Ref(arr, false))
        WExpr.Let("$n", WExpr.Call(len, [ x ], WType.I32),
            WExpr.Let("$res", WExpr.ArrayNew(arr, n, nullOf (WType.Ref(StringTypeIdx, true)), WType.Ref(arr, false)),
                WExpr.Sequence [
                    forEach n (fun i -> WExpr.ArraySet(res, i, strFromHost ctx (WExpr.Call(get, [ x; i ], WType.Externref))))
                    res ])))
    WExpr.Call(name, [ x ], WType.Ref(arr, false))

// ─────────────────────────────────────────────────────────────────
// Boxing of scalars (externref ↔ number)
// ─────────────────────────────────────────────────────────────────

let private unbox (ctx: Ctx) (t: WType) (x: WExpr) : WExpr =
    match t with
    | WType.I32 -> WExpr.Call(hostFn ctx "x2i" [ WType.Externref ] WType.I32, [ x ], WType.I32)
    | WType.F64 -> WExpr.Call(hostFn ctx "x2f" [ WType.Externref ] WType.F64, [ x ], WType.F64)
    | WType.F32 -> WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(hostFn ctx "x2f" [ WType.Externref ] WType.F64, [ x ], WType.F64), WType.F32)
    | WType.Externref -> x
    | t when isString t -> strFromHost ctx x
    | t when t = WType.Ref(getOrAddArrayType ctx strTy, false) -> stringArrayFromHost ctx x
    | t ->
        WasmGc.Core.Diagnostics.unsupported ctx.Diagnostics
            $"a host callback parameter of type {wTypeKey t}"
            "Callbacks called from JavaScript can take int, bool, char, float, string and string array arguments."
        x

let private box (ctx: Ctx) (t: WType) (v: WExpr) : WExpr =
    match t with
    | WType.Void -> WExpr.Sequence [ v; nullOf WType.Externref ]
    | WType.I32 -> WExpr.Call(hostFn ctx "i2x" [ WType.I32 ] WType.Externref, [ v ], WType.Externref)
    | WType.F64 -> WExpr.Call(hostFn ctx "f2x" [ WType.F64 ] WType.Externref, [ v ], WType.Externref)
    | WType.F32 -> WExpr.Call(hostFn ctx "f2x" [ WType.F64 ] WType.Externref, [ WExpr.Unary(WUnaryOp.PromoteF32, v, WType.F64) ], WType.Externref)
    | WType.Externref -> v
    | t when isString t -> strToHost ctx v
    | t ->
        WasmGc.Core.Diagnostics.unsupported ctx.Diagnostics
            $"a host callback result of type {wTypeKey t}"
            "Callbacks called from JavaScript can return unit, int, bool, char, float and string."
        WExpr.Sequence [ v; nullOf WType.Externref ]

// ─────────────────────────────────────────────────────────────────
// Callbacks
// ─────────────────────────────────────────────────────────────────

let private closureArray (ctx: Ctx) = getOrAddArrayType ctx (WType.Ref(AnyFnTypeIdx, true))
let private sigArray (ctx: Ctx) = getOrAddArrayType ctx WType.I32

/// The closure table — `$cb_clos` (the closures), `$cb_sigs` (their signatures), `$cb_free` (a stack of released ids),
/// `$cb_n` (ids handed out so far), `$cb_nfree` — and `$host_cbRegister(closure, signature) → id`.  An id is reused once
/// the host has released it (`__cbFree`, called when the JS function that stood for the closure is garbage collected).
let private cbRegister (ctx: Ctx) : string =
    let name = "$host_cbRegister"
    let closArr, sigArr = closureArray ctx, sigArray ctx
    let freeArr = sigArr                               // an i32 array
    if not (hasGlobal ctx "$cb_n") then
        let initial = 16
        let table name (arr: int) (init: WExpr) =
            ctx.GlobalDecls.Add
                { Name = name; Type = WType.Ref(arr, true); Mutable = true; Exported = false
                  Init = WExpr.ArrayNew(arr, i32 initial, init, WType.Ref(arr, false)) }
        table "$cb_clos" closArr (nullOf (WType.Ref(AnyFnTypeIdx, true)))
        table "$cb_sigs" sigArr (i32 0)
        table "$cb_free" freeArr (i32 0)
        for counter in [ "$cb_n"; "$cb_nfree" ] do
            ctx.GlobalDecls.Add { Name = counter; Type = WType.I32; Mutable = true; Exported = false; Init = i32 0 }
    define ctx name [ "$clo", closureSelfTy; "$sig", WType.I32 ] WType.I32 (fun () ->
        let nullableArr idx = WType.Ref(idx, true)
        let clos () = WExpr.GlobalGet("$cb_clos", nullableArr closArr)
        let sigs () = WExpr.GlobalGet("$cb_sigs", nullableArr sigArr)
        let free () = WExpr.GlobalGet("$cb_free", nullableArr freeArr)
        let n, nfree, id = local "$n" WType.I32, local "$nfree" WType.I32, local "$id" WType.I32
        let add (a: WExpr) (b: int) = WExpr.Binary(WBinaryOp.Add, a, i32 b, WType.I32)
        let grow (arr: string) (arrIdx: int) (elemInit: WExpr) (current: WExpr) =
            let fresh = local $"$fresh{arr}" (WType.Ref(arrIdx, false))
            WExpr.Let($"$fresh{arr}", WExpr.ArrayNew(arrIdx, WExpr.Binary(WBinaryOp.Mul, n, i32 2, WType.I32), elemInit, WType.Ref(arrIdx, false)),
                WExpr.Sequence [ WExpr.ArrayCopy(fresh, i32 0, current, i32 0, n); WExpr.GlobalSet(arr, fresh) ])
        // a released id, else a new one (growing the three tables together: the free stack never outgrows them)
        let nextId =
            WExpr.If(
                WExpr.Compare(WCompareOp.GtS, nfree, i32 0),
                WExpr.Let("$top", add nfree -1,
                    WExpr.Sequence [ WExpr.GlobalSet("$cb_nfree", local "$top" WType.I32)
                                     WExpr.ArrayGet(free (), local "$top" WType.I32, WType.I32) ]),
                WExpr.Let("$n", WExpr.GlobalGet("$cb_n", WType.I32),
                    WExpr.Sequence [
                        WExpr.If(
                            WExpr.Compare(WCompareOp.GeS, n, WExpr.ArrayLen (clos ())),
                            WExpr.Sequence [
                                grow "$cb_clos" closArr (nullOf (WType.Ref(AnyFnTypeIdx, true))) (clos ())
                                grow "$cb_sigs" sigArr (i32 0) (sigs ())
                                grow "$cb_free" freeArr (i32 0) (free ()) ],
                            WExpr.Nop, WType.Void)
                        WExpr.GlobalSet("$cb_n", add n 1)
                        n ]),
                WType.I32)
        WExpr.Let("$nfree", WExpr.GlobalGet("$cb_nfree", WType.I32),
            WExpr.Let("$id", nextId,
                WExpr.Sequence [
                    WExpr.ArraySet(clos (), id, local "$clo" closureSelfTy)
                    WExpr.ArraySet(sigs (), id, local "$sig" WType.I32)
                    id ])))
    name

/// Parameter and result types of a function type (`a -> b -> c` → [a; b], c).
let private signature (t: Fable.Type) : Fable.Type list * Fable.Type =
    let rec go acc (t: Fable.Type) =
        match t with
        | Fable.LambdaType(a, r) -> go (a :: acc) r
        | _ -> List.rev acc, t
    match t with
    | Fable.DelegateType(args, r) -> args, r
    | _ -> go [] t

/// Signature index of a callback type; builds its trampoline on first use.
let private callbackSignature (ctx: Ctx) (calleeTy: Fable.Type) : int =
    let argTys, retTy = signature calleeTy
    let wArgs = argTys |> List.map (mapTypeKnown ctx)
    let wRet = mapTypeKnown ctx retTy
    let key = $"{wTypesKey wArgs}->{wTypeKey wRet}"
    match ctx.CallbackSigs.TryGetValue key with
    | true, idx -> idx
    | _ ->
        let idx = ctx.CallbackTramps.Count
        let name = $"$host_cb_tramp_{idx}"
        // one JS argument per non-unit parameter
        let jsArgs = wArgs |> List.filter (fun t -> t <> WType.Void)
        if jsArgs.Length > maxCallbackArgs then
            WasmGc.Core.Diagnostics.unsupported ctx.Diagnostics
                $"a host callback with {jsArgs.Length} arguments" $"Callbacks take at most {maxCallbackArgs} arguments."
        let jsParams = jsArgs |> List.mapi (fun i _ -> $"$a{i}", WType.Externref)
        let unboxed =
            let mutable next = 0
            wArgs |> List.map (fun t ->
                if t = WType.Void then WExpr.Const WConst.Unit
                else
                    let a = local $"$a{next}" WType.Externref
                    next <- next + 1
                    unbox ctx t a)
        define ctx name (("$clo", closureSelfTy) :: jsParams) WType.Externref (fun () ->
            ClosureBuilder.applyClosure ctx calleeTy (local "$clo" closureSelfTy) argTys unboxed wRet |> box ctx wRet)
        ctx.CallbackSigs[key] <- idx
        ctx.CallbackTramps.Add((name, jsParams.Length))
        idx

/// A function-typed extern argument → a JS function (externref) that calls the closure.
let private callbackToHost (ctx: Ctx) (fnTy: Fable.Type) (closure: WExpr) : WExpr =
    let register = cbRegister ctx
    let sigIdx = callbackSignature ctx fnTy
    let make = hostFn ctx "callback" [ WType.I32 ] WType.Externref
    WExpr.Call(make, [ WExpr.Call(register, [ closure; i32 sigIdx ], WType.I32) ], WType.Externref)

/// `printfn` hands the host an opaque string (`env.consolePrint`); two exports let it read the characters.
let private exportStringReaders (ctx: Ctx) =
    if not (hasFunc ctx "__str_len") then
        let s = local "$s" strTy
        let reader name parms body =
            ctx.Functions.Add({ Name = name; Params = parms; Result = WType.I32; Locals = []; Body = body; Exported = true })
        reader "__str_len" [ "$s", strTy ] (WExpr.ArrayLen s)
        reader "__str_at" [ "$s", strTy; "$i", WType.I32 ] (WExpr.ArrayGet(s, local "$i" WType.I32, WType.I32))

/// The two exports with which a host builds a string for the module (the Exports string ABI): `__str_new(length)` and
/// `__str_set(string, index, utf16CodeUnit)`.
let private exportStringWriters (ctx: Ctx) =
    if not (hasFunc ctx "__str_new") then
        ctx.Functions.Add(
            { Name = "__str_new"; Params = [ "$n", WType.I32 ]; Result = strTy; Locals = []; Exported = true
              Body = WExpr.ArrayNew(StringTypeIdx, local "$n" WType.I32, i32 0, strTy) })
        ctx.Functions.Add(
            { Name = "__str_set"; Params = [ "$s", strTy; "$i", WType.I32; "$c", WType.I32 ]; Result = WType.Void; Locals = []; Exported = true
              Body = WExpr.ArraySet(local "$s" strTy, local "$i" WType.I32, local "$c" WType.I32) })

/// The calls in a function body: callee name → argument lists.
let private callsIn (funcs: WFuncDecl list) : (string * WExpr list) list =
    let found = ResizeArray<string * WExpr list>()
    let rec visit (e: WExpr) =
        (match e with WExpr.Call(n, args, _) -> found.Add((n, args)) | _ -> ())
        WasmGc.Core.Traverse.children e |> List.iter visit
    funcs |> List.iter (fun f -> visit f.Body)
    List.ofSeq found

/// Add the exports the HOST needs, for what the functions that are kept actually do — a runtime library declares
/// hundreds of externs, an app uses a few, and a module that uses none must not need any of this:
///   `__cb(id, a0..a3) → externref`  the single way JS calls a registered closure (only the signatures in use),
///   `__str_len` / `__str_at`        how JS reads the opaque string `printfn` hands it.
/// Returns true when it added functions (the caller then assembles the module again).
let finalize (ctx: Ctx) (kept: WFuncDecl list) : bool =
    let calls = callsIn kept
    let mutable added = false
    if calls |> List.exists (fun (n, _) -> n = "consolePrint") && not (hasFunc ctx "__str_len") then
        exportStringReaders ctx
        added <- true
    // the Exports string ABI: the host reads and builds strings through accessors the module exports
    if ctx.StringAbi = Exports && calls |> List.exists (fun (n, _) -> n = "$host_strToHost" || n = "$host_strFromHost") then
        if not (hasFunc ctx "__str_len") then exportStringReaders ctx
        if not (hasFunc ctx "__str_new") then exportStringWriters ctx
        added <- true
    let used =
        calls
        |> List.choose (function
            | "$host_cbRegister", [ _; WExpr.Const(WConst.I32 k) ] -> Some k
            | _ -> None)
        |> List.distinct |> List.sort
    if not used.IsEmpty && not (hasFunc ctx "__cb") then
        let closArr, sigArr = closureArray ctx, sigArray ctx
        let args = [ for i in 0 .. maxCallbackArgs - 1 -> $"$a{i}", WType.Externref ]
        let sigv = local "$sig" WType.I32
        let clo = local "$clo" closureSelfTy
        let dispatch =
            used
            |> List.foldBack
                (fun k rest ->
                    let name, arity = ctx.CallbackTramps[k]
                    let callArgs = clo :: (args |> List.take arity |> List.map (fun (n, t) -> local n t))
                    WExpr.If(WExpr.Compare(WCompareOp.Eq, sigv, i32 k), WExpr.Call(name, callArgs, WType.Externref), rest, WType.Externref))
                <| nullOf WType.Externref
        let id = local "$id" WType.I32
        ctx.Functions.Add(
            { Name = "__cb"
              Params = ("$id", WType.I32) :: args
              Result = WType.Externref
              Locals = []
              Exported = true
              Body =
                WExpr.Let("$sig", WExpr.ArrayGet(WExpr.GlobalGet("$cb_sigs", WType.Ref(sigArr, true)), id, WType.I32),
                    WExpr.Let("$clo",
                        WExpr.Cast(WExpr.ArrayGet(WExpr.GlobalGet("$cb_clos", WType.Ref(closArr, true)), id, WType.Ref(AnyFnTypeIdx, true)), closureSelfTy),
                        dispatch)) }
            |> Lc.resolveLocals)
        // the host's garbage collector found the JS function of a closure unreachable: free its slot (idempotent)
        let freeArr = sigArr
        let clos () = WExpr.GlobalGet("$cb_clos", WType.Ref(closArr, true))
        let nfree = WExpr.GlobalGet("$cb_nfree", WType.I32)
        ctx.Functions.Add(
            { Name = "__cbFree"
              Params = [ "$id", WType.I32 ]
              Result = WType.Void
              Locals = []
              Exported = true
              Body =
                WExpr.If(
                    WExpr.RefIsNull(WExpr.ArrayGet(clos (), id, WType.Ref(AnyFnTypeIdx, true))),
                    WExpr.Nop,
                    WExpr.Sequence [
                        WExpr.ArraySet(clos (), id, nullOf (WType.Ref(AnyFnTypeIdx, true)))
                        WExpr.ArraySet(WExpr.GlobalGet("$cb_free", WType.Ref(freeArr, true)), nfree, id)
                        WExpr.GlobalSet("$cb_nfree", WExpr.Binary(WBinaryOp.Add, nfree, i32 1, WType.I32)) ],
                    WType.Void) }
            |> Lc.resolveLocals)
        added <- true
    added

// ─────────────────────────────────────────────────────────────────
// The extern call site
// ─────────────────────────────────────────────────────────────────

/// A call of `[<Import(selector, path)>] let f … = nativeOnly`: marshal the arguments and the result around the
/// plain import.  Unit arguments are dropped; numbers and bools pass through.
let call (ctx: Ctx) (path: string) (selector: string) (info: Fable.CallInfo) (wArgs: WExpr list) (retTy: Fable.Type) (ty: WType) : WExpr =
    let args =
        List.zip (info.Args |> List.map (fun a -> a.Type)) wArgs
        |> List.choose (fun (t, w) ->
            match t with
            | Fable.String -> Some(strToHost ctx w, WType.Externref)
            | Fable.LambdaType _ | Fable.DelegateType _ -> Some(callbackToHost ctx t w, WType.Externref)
            | _ when exprWType w = WType.Void -> None
            | _ -> Some(w, exprWType w))
    let isStringArray = (match retTy with Fable.Array(Fable.String, _) -> true | _ -> false)
    let importTy = if isString ty || isStringArray then WType.Externref else ty
    let callName = ctx.RegisterExternFunc(path, selector, List.map snd args, importTy)
    let invoke = WExpr.Call(callName, List.map fst args, importTy)
    if isString ty then strFromHost ctx invoke
    elif isStringArray then stringArrayFromHost ctx invoke
    else invoke
