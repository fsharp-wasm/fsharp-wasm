module Fuzz
// Differential fuzzing: random WExpr programs → reference interpreter (independent of the compiler)
// vs. V8 executing {optimized, unoptimized} × {binary encoder, WAT}.
open System
open System.Collections.Generic
open System.Text
open System.Numerics
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open Lib
module Lc = WasmGc.Runtime.Locals

// ───────────── reference interpreter ─────────────
type V = I of int32 | F of float
exception Trap
exception Jump of string * V list
exception BreakEx of string
exception ContinueEx of string
exception Thrown
let private i = function I n -> n | F _ -> failwith "expected i32"
let private f = function F x -> x | I _ -> failwith "expected f64"
let private b2i b = if b then 1 else 0

let rec ev (env: Dictionary<string, V>) (e: WExpr) : V =
    match e with
    | WExpr.Const(WConst.I32 n) -> I n
    | WExpr.Const(WConst.F64 x) -> F x
    | WExpr.LocalGet(n, _) -> env.[n]
    | WExpr.Let(n, v, b) | WExpr.LetMut(n, v, b) -> env.[n] <- ev env v; ev env b
    | WExpr.Assign(n, v) -> env.[n] <- ev env v; I 0
    | WExpr.Sequence xs -> xs |> List.map (ev env) |> List.last
    | WExpr.If(c, t, el, _) -> if i (ev env c) <> 0 then ev env t else ev env el
    | WExpr.Binary(op, a, b, WType.I32) ->
        let x = i (ev env a)
        let y = i (ev env b)
        I(match op with
          | WBinaryOp.Add -> x + y | WBinaryOp.Sub -> x - y | WBinaryOp.Mul -> x * y
          | WBinaryOp.DivS -> if y = 0 || (x = Int32.MinValue && y = -1) then raise Trap else x / y
          | WBinaryOp.DivU -> if y = 0 then raise Trap else int32 (uint32 x / uint32 y)
          | WBinaryOp.RemS -> if y = 0 then raise Trap elif y = -1 then 0 else x % y
          | WBinaryOp.RemU -> if y = 0 then raise Trap else int32 (uint32 x % uint32 y)
          | WBinaryOp.And -> x &&& y | WBinaryOp.Or -> x ||| y | WBinaryOp.Xor -> x ^^^ y
          | WBinaryOp.Shl -> x <<< (y &&& 31) | WBinaryOp.ShrS -> x >>> (y &&& 31)
          | WBinaryOp.ShrU -> int32 (uint32 x >>> (y &&& 31))
          | WBinaryOp.Rotl -> int32 (BitOperations.RotateLeft(uint32 x, y &&& 31))
          | WBinaryOp.Rotr -> int32 (BitOperations.RotateRight(uint32 x, y &&& 31))
          | o -> failwithf "ref: %A" o)
    | WExpr.Binary(op, a, b, WType.F64) ->
        let x = f (ev env a)
        let y = f (ev env b)
        F(match op with
          | WBinaryOp.Add -> x + y | WBinaryOp.Sub -> x - y | WBinaryOp.Mul -> x * y | WBinaryOp.DivS -> x / y
          | WBinaryOp.Min -> Math.Min(x, y) | WBinaryOp.Max -> Math.Max(x, y)
          | o -> failwithf "ref f64: %A" o)
    | WExpr.Compare(op, a, b) ->
        match ev env a, ev env b with
        | I x, I y ->
            I(b2i (match op with
                   | WCompareOp.Eq -> x = y | WCompareOp.Ne -> x <> y
                   | WCompareOp.LtS -> x < y | WCompareOp.GtS -> x > y | WCompareOp.LeS -> x <= y | WCompareOp.GeS -> x >= y
                   | WCompareOp.LtU -> uint32 x < uint32 y | WCompareOp.GtU -> uint32 x > uint32 y
                   | WCompareOp.LeU -> uint32 x <= uint32 y | WCompareOp.GeU -> uint32 x >= uint32 y))
        | F x, F y ->
            I(b2i (match op with
                   | WCompareOp.Eq -> x = y | WCompareOp.Ne -> x <> y
                   | WCompareOp.LtS -> x < y | WCompareOp.GtS -> x > y | WCompareOp.LeS -> x <= y | WCompareOp.GeS -> x >= y
                   | o -> failwithf "ref f64 cmp %A" o))
        | _ -> failwith "mixed compare"
    | WExpr.Unary(WUnaryOp.Eqz, a, _) -> I(b2i (i (ev env a) = 0))
    | WExpr.Unary(WUnaryOp.Clz, a, _) -> I(BitOperations.LeadingZeroCount(uint32 (i (ev env a))))
    | WExpr.Unary(WUnaryOp.Ctz, a, _) -> I(BitOperations.TrailingZeroCount(uint32 (i (ev env a))))
    | WExpr.Unary(WUnaryOp.Popcnt, a, _) -> I(BitOperations.PopCount(uint32 (i (ev env a))))
    | WExpr.Unary(WUnaryOp.ConvertI32S, a, _) -> F(float (i (ev env a)))
    | WExpr.JoinPoint(l, ps, body, cont, _) ->
        (try ev env cont
         with Jump(l', vs) when l' = l ->
            List.iter2 (fun (n, _) v -> env.[n] <- v) ps vs
            ev env body)
    | WExpr.JoinApply(l, args, _) -> raise (Jump(l, args |> List.map (ev env)))
    | WExpr.Nop -> I 0
    | WExpr.Block(l, body, _) -> (try ev env body with BreakEx l' when l' = l -> I 0)
    | WExpr.Loop(l, body, _) ->
        let rec run () = (try ev env body with ContinueEx l' when l' = l -> run ())
        run ()
    | WExpr.Break(l, None) -> raise (BreakEx l)
    | WExpr.Continue(l, []) -> raise (ContinueEx l)
    | WExpr.Throw WExpr.Nop -> raise Thrown
    | WExpr.TryCatch(body, handler, fin, _) ->
        // try body [with h] [finally fin] — the finalizer runs on normal completion and when an
        // exception escapes; traps and break/continue are not intercepted (as in the lowered code).
        let guarded () =
            try ev env body
            with Thrown when handler.IsSome -> ev env (snd handler.Value)
        match fin with
        | None -> guarded ()
        | Some fe ->
            let r = (try guarded () with Thrown -> (ev env fe |> ignore; raise Thrown))
            ev env fe |> ignore
            r
    | o -> failwithf "ref: unsupported %A" o

// ───────────── pretty printer (for failure reports) ─────────────
let rec show (e: WExpr) : string =
    match e with
    | WExpr.Const(WConst.I32 n) -> string n
    | WExpr.Const(WConst.F64 x) -> if Double.IsNaN x then "nan" else sprintf "%gf" x
    | WExpr.LocalGet(n, _) -> n
    | WExpr.Let(n, v, b) -> sprintf "let %s = %s in %s" n (show v) (show b)
    | WExpr.LetMut(n, v, b) -> sprintf "let mut %s = %s in %s" n (show v) (show b)
    | WExpr.Assign(n, v) -> sprintf "%s <- %s" n (show v)
    | WExpr.Sequence xs -> "(" + String.Join("; ", xs |> List.map show) + ")"
    | WExpr.If(c, t, el, _) -> sprintf "(if %s then %s else %s)" (show c) (show t) (show el)
    | WExpr.Binary(op, a, b, _) -> sprintf "(%s %A %s)" (show a) op (show b)
    | WExpr.Compare(op, a, b) -> sprintf "(%s %A %s)" (show a) op (show b)
    | WExpr.Unary(op, a, _) -> sprintf "%A(%s)" op (show a)
    | WExpr.JoinPoint(l, ps, body, cont, _) -> sprintf "join %s(%s) = %s in %s" l (String.Join(",", ps |> List.map fst)) (show body) (show cont)
    | WExpr.JoinApply(l, args, _) -> sprintf "jump %s(%s)" l (String.Join(",", args |> List.map show))
    | WExpr.Nop -> "()"
    | WExpr.Block(l, b, _) -> sprintf "block %s { %s }" l (show b)
    | WExpr.Loop(l, b, _) -> sprintf "loop %s { %s }" l (show b)
    | WExpr.Break(l, _) -> sprintf "break %s" l
    | WExpr.Continue(l, _) -> sprintf "continue %s" l
    | WExpr.Throw _ -> "throw"
    | WExpr.TryCatch(b, h, f, _) ->
        sprintf "try { %s }%s%s" (show b) (match h with Some(_, x) -> sprintf " with { %s }" (show x) | None -> "") (match f with Some x -> sprintf " finally { %s }" (show x) | None -> "")
    | o -> sprintf "%A" o

// ───────────── generator ─────────────
let private edge = [| 0; 1; -1; 2; 3; 4; 7; 8; 16; 31; 32; 33; -2; -8; 255; 65536; Int32.MinValue; Int32.MaxValue; Int32.MinValue + 1; Int32.MaxValue - 1 |]
let private ibins = [| WBinaryOp.Add; WBinaryOp.Sub; WBinaryOp.Mul; WBinaryOp.DivS; WBinaryOp.DivU; WBinaryOp.RemS; WBinaryOp.RemU
                       WBinaryOp.And; WBinaryOp.Or; WBinaryOp.Xor; WBinaryOp.Shl; WBinaryOp.ShrS; WBinaryOp.ShrU; WBinaryOp.Rotl; WBinaryOp.Rotr |]
let private icmps = [| WCompareOp.Eq; WCompareOp.Ne; WCompareOp.LtS; WCompareOp.LtU; WCompareOp.GtS; WCompareOp.GtU
                       WCompareOp.LeS; WCompareOp.LeU; WCompareOp.GeS; WCompareOp.GeU |]
let private fcmps = [| WCompareOp.Eq; WCompareOp.Ne; WCompareOp.LtS; WCompareOp.GtS; WCompareOp.LeS; WCompareOp.GeS |]
let private iuns = [| WUnaryOp.Eqz; WUnaryOp.Clz; WUnaryOp.Ctz; WUnaryOp.Popcnt |]
let private fbins = [| WBinaryOp.Add; WBinaryOp.Sub; WBinaryOp.Mul; WBinaryOp.DivS; WBinaryOp.Min; WBinaryOp.Max |]
let private fconsts = [| 0.0; -0.0; 1.0; -1.5; 2.5; nan; infinity; -infinity; 1e300; 4.9e-324 |]

type Gen(seed: int) =
    let r = Random(seed)
    let mutable uid = 0
    let fresh p = uid <- uid + 1; sprintf "%s%d" p uid
    let pick (a: 'a[]) = a.[r.Next a.Length]
    let i32c n = WExpr.Const(WConst.I32 n)
    let get n = WExpr.LocalGet(n, WType.I32)
    member _.Reset() = uid <- 0
    member g.Const() = i32c (if r.Next 3 = 0 then r.Next(-1000, 1000) else pick edge)
    /// i32 expression; `vars` = i32 locals in scope; `muts` = mutable i32 locals in scope
    member g.I32(d: int, vars: string list, muts: string list) : WExpr =
        let leaf () = if r.Next 3 = 0 || vars.IsEmpty then g.Const() else get (List.item (r.Next vars.Length) vars)
        if d <= 0 then leaf ()
        else
            let sub () = g.I32(d - 1, vars, muts)
            match r.Next 15 with
            | 0 | 1 | 2 -> WExpr.Binary(pick ibins, sub (), sub (), WType.I32)
            | 3 -> WExpr.Compare(pick icmps, sub (), sub ())
            | 4 -> WExpr.Unary(pick iuns, sub (), WType.I32)
            | 5 -> WExpr.If(sub (), sub (), sub (), WType.I32)
            | 6 -> let n = fresh "t" in WExpr.Let(n, sub (), g.I32(d - 1, n :: vars, muts))
            | 7 ->  // mutation + alias:  let mut m = e; let al = m; m <- e2; (al op m)
                let m, al = fresh "m", fresh "al"
                WExpr.LetMut(m, sub (), WExpr.Let(al, get m,
                    WExpr.Sequence [ WExpr.Assign(m, g.I32(d - 1, m :: al :: vars, m :: muts))
                                     WExpr.Binary(pick ibins, get al, get m, WType.I32) ]))
            | 8 -> WExpr.Compare(pick fcmps, g.F64(d - 1, vars), g.F64(d - 1, vars))
            | 9 ->  // f64 self-identities (x - x, x == x) on a let-bound float
                let t = fresh "ft"
                let tv = WExpr.LocalGet(t, WType.F64)
                let body = if r.Next 2 = 0 then WExpr.Compare(pick fcmps, tv, tv)
                           else WExpr.Compare(WCompareOp.Eq, WExpr.Binary(WBinaryOp.Sub, tv, tv, WType.F64), WExpr.Const(WConst.F64 0.0))
                WExpr.Let(t, g.F64(d - 1, vars), body)
            | 10 -> g.Join(d, vars, muts)
            | 11 | 12 -> if d >= 2 then g.Loop(d, vars) else leaf ()
            | 13 -> if d >= 2 then g.TryFinally(d, vars) else leaf ()
            | _ -> leaf ()
    member g.F64(d: int, vars: string list) : WExpr =
        if d <= 0 || r.Next 3 = 0 then
            if r.Next 2 = 0 || vars.IsEmpty then WExpr.Const(WConst.F64(pick fconsts))
            else WExpr.Unary(WUnaryOp.ConvertI32S, get (List.item (r.Next vars.Length) vars), WType.F64)
        else WExpr.Binary(pick fbins, g.F64(d - 1, vars), g.F64(d - 1, vars), WType.F64)
    /// counted loop; break / continue are issued from inside try bodies and catch handlers
    member g.Loop(d: int, vars: string list) : WExpr =
        let i, acc, bl, ll = fresh "i", fresh "acc", fresh "bk", fresh "lp"
        let sd = min 1 (d - 1)
        let vars' = i :: acc :: vars
        let step = WExpr.Assign(acc, WExpr.Binary(pick ibins, get acc, g.I32(sd, vars', []), WType.I32))
        let adv = WExpr.Assign(i, WExpr.Binary(WBinaryOp.Add, get i, i32c 1, WType.I32))
        let cont = WExpr.Continue(ll, [])
        let thr = WExpr.If(g.I32(sd, vars', []), WExpr.Throw WExpr.Nop, WExpr.Nop, WType.Void)
        let body =
            match r.Next 4 with
            | 0 -> WExpr.Sequence [ step; adv; cont ]
            | 1 -> // continue from INSIDE the try body; handler recovers and continues too
                WExpr.TryCatch(WExpr.Sequence [ thr; step; adv; cont ],
                               Some("e", WExpr.Sequence [ WExpr.Assign(acc, g.Const()); adv; cont ]), None, WType.Void)
            | 2 -> // exception in a nested try; break from the handler when it fires
                WExpr.TryCatch(WExpr.Sequence [ step; thr; adv; cont ],
                               Some("e", WExpr.Break(bl, None)), None, WType.Void)
            | _ -> // try/catch around only the step; loop control outside
                WExpr.Sequence [ WExpr.TryCatch(WExpr.Sequence [ thr; step ], Some("e", WExpr.Assign(acc, g.Const())), None, WType.Void); adv; cont ]
        let bound = WExpr.Binary(WBinaryOp.And, get "a", i32c 7, WType.I32)
        WExpr.LetMut(i, i32c 0, WExpr.LetMut(acc, g.I32(sd, vars, []),
            WExpr.Sequence [
                WExpr.Block(bl, WExpr.Loop(ll, WExpr.If(WExpr.Compare(WCompareOp.GeS, get i, bound), WExpr.Break(bl, None), body, WType.Void), WType.Void), WType.Void)
                get acc ]))
    /// try/with/finally with an observable finalizer (mutates `m`), optionally escaping to an outer catch
    member g.TryFinally(d: int, vars: string list) : WExpr =
        let m, res = fresh "fm", fresh "tr"
        let sd = min 1 (d - 1)
        let vars' = m :: vars
        let fin = WExpr.Assign(m, WExpr.Binary(WBinaryOp.Add, get m, i32c 7, WType.I32))
        let thr = WExpr.If(g.I32(sd, vars', []), WExpr.Throw WExpr.Nop, WExpr.Nop, WType.Void)
        let inner =
            WExpr.TryCatch(WExpr.Sequence [ thr; g.I32(sd, vars', []) ],
                           (if r.Next 2 = 0 then Some("e", g.I32(sd, vars', [])) else None), Some fin, WType.I32)
        WExpr.LetMut(m, i32c 0,
            WExpr.Let(res, WExpr.TryCatch(inner, Some("e2", i32c 99), None, WType.I32),
                WExpr.Binary(pick ibins, get res, get m, WType.I32)))
    /// decision-tree shaped join point; the body is deliberately large so that it is not inlined
    member g.Join(d: int, vars: string list, muts: string list) : WExpr =
        let l, p = fresh "j", fresh "p"
        let sd = min 1 (d - 1)          // keep join points shallow: their branching is exponential otherwise
        let body = WExpr.Binary(pick ibins, WExpr.Binary(WBinaryOp.Mul, get p, g.Const(), WType.I32),
                                WExpr.Binary(WBinaryOp.Add, get p, g.I32(sd, p :: vars, muts), WType.I32), WType.I32)
        let rec cont k =
            if k <= 0 || r.Next 3 = 0 then
                if r.Next 4 = 0 then g.I32(sd, vars, muts) else WExpr.JoinApply(l, [ g.I32(sd, vars, muts) ], WType.I32)
            else WExpr.If(g.I32(sd, vars, muts), cont (k - 1), cont (k - 1), WType.I32)
        WExpr.JoinPoint(l, [ p, WType.I32 ], body, cont 2, WType.I32)

// ───────────── driver ─────────────
let private inputs =
    let e = [| 0; 1; -1; 2; 7; Int32.MinValue; Int32.MaxValue; -8 |]
    let r = Random(12345)
    [ for a in e do for b in e -> a, b ]
    @ [ for _ in 1 .. 40 -> r.Next(-300, 300), r.Next(-300, 300) ]

let private outcome (body: WExpr) (a: int) (bv: int) : string =
    let env = Dictionary<string, V>()
    env.["a"] <- I a; env.["b"] <- I bv
    try string (i (ev env body)) with Trap -> "trap"

let private jstr (s: string) = "\"" + s.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\""

/// Writes FUZZ_DIR/{opt,noopt}.wasm|wat and expected.json.  Returns number of functions.
let generate (seed: int) (count: int) (dir: string) : int =
    IO.Directory.CreateDirectory dir |> ignore
    let g = Gen(seed)
    let bodies =
        [ for k in 0 .. count - 1 ->
            g.Reset()
            g.I32(2 + k % 3, [ "a"; "b" ], []) ]
    let funcs =
        bodies |> List.mapi (fun k b ->
            { Name = sprintf "f%d" k; Params = [ "a", WType.I32; "b", WType.I32 ]; Result = WType.I32; Locals = []; Body = b; Exported = true })
    let ctx = newCtx ()
    let m = mkModule ctx.TypeDefs funcs
    // optimized
    let mo, _ = runPhases m
    IO.File.WriteAllText(IO.Path.Combine(dir, "opt.wat"), WasmGc.Emit.Wat.moduleToWat mo)
    IO.File.WriteAllBytes(IO.Path.Combine(dir, "opt.wasm"), WasmGc.Emit.Encoder.encodeModule (WasmGc.Emit.Emit.emitModule mo))
    // NOT optimized: same phases minus Optimize
    let n = WasmGc.Pipeline.Normalizer.normalizeModule m
    let l = WasmGc.Pipeline.Lower.lowerModule n
    let mn = { l with Functions = List.map Lc.resolveLocals l.Functions }
    IO.File.WriteAllText(IO.Path.Combine(dir, "noopt.wat"), WasmGc.Emit.Wat.moduleToWat mn)
    IO.File.WriteAllBytes(IO.Path.Combine(dir, "noopt.wasm"), WasmGc.Emit.Encoder.encodeModule (WasmGc.Emit.Emit.emitModule mn))
    // expected results
    let sb = StringBuilder()
    sb.Append("{\"inputs\":[") |> ignore
    sb.Append(String.Join(",", inputs |> List.map (fun (a, b) -> sprintf "[%d,%d]" a b))) |> ignore
    sb.Append("],\"funcs\":[") |> ignore
    let items =
        bodies |> List.mapi (fun k b ->
            let exp = inputs |> List.map (fun (a, bv) -> jstr (outcome b a bv))
            sprintf "{\"name\":\"f%d\",\"src\":%s,\"expected\":[%s]}" k (jstr (show b)) (String.Join(",", exp)))
    sb.Append(String.Join(",", items)).Append("]}") |> ignore
    IO.File.WriteAllText(IO.Path.Combine(dir, "expected.json"), sb.ToString())
    count
