module ClosureFuzz
// Random closure programs (Fable AST) → reference interpreter vs. the real ClosureBuilder → Lower → Emit → V8.
open System
open System.Collections.Generic
open System.Text
open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open Lib
open Scenarios
module CB = WasmGc.Transforms.ClosureBuilder

// ───────────── reference interpreter over the Fable subset ─────────────
type Value = VInt of int32 | VFn of (Value list -> Value)
exception Budget
let mutable private steps = 0
let private tick () = steps <- steps + 1; if steps > 60000 then raise Budget
let private asInt = function VInt n -> n | _ -> failwith "int expected"
let private moduleFns : Map<string, Value> =
    Map.ofList [ "m0", VFn(fun [ x ] -> VInt(asInt x * 3 + 1)); "m1", VFn(fun [ x ] -> VInt(asInt x - 5)) ]

let rec private ev (env: Map<string, Value ref>) (e: Fable.Expr) : Value =
    match e with
    | Fable.Value(Fable.NumberConstant(Fable.NumberValue.Int32 n, _), _) -> VInt n
    | Fable.IdentExpr id ->
        match Map.tryFind id.Name env with
        | Some r -> r.Value
        | None -> moduleFns.[id.Name]
    | Fable.Operation(Fable.Binary(op, l, r), _, _, _) ->
        let a, b = asInt (ev env l), asInt (ev env r)
        VInt(match op with
             | BinaryOperator.BinaryPlus -> a + b | BinaryOperator.BinaryMinus -> a - b | BinaryOperator.BinaryMultiply -> a * b
             | BinaryOperator.BinaryEqual -> (if a = b then 1 else 0)
             | BinaryOperator.BinaryLessOrEqual -> (if a <= b then 1 else 0)
             | BinaryOperator.BinaryLess -> (if a < b then 1 else 0)
             | o -> failwithf "op %A" o)
    | Fable.IfThenElse(c, t, el, _) -> if asInt (ev env c) <> 0 then ev env t else ev env el
    | Fable.Let(id, v, body) -> ev (Map.add id.Name (ref (ev env v)) env) body
    | Fable.LetRec(bs, body) ->
        let cells = bs |> List.map (fun (id, _) -> id.Name, ref (VInt 0))
        let env' = cells |> List.fold (fun m (n, c) -> Map.add n c m) env
        List.iter2 (fun (_, (c: Value ref)) (_, v) -> c.Value <- ev env' v) cells bs
        ev env' body
    | Fable.Lambda(p, body, _) -> VFn(fun [ a ] -> tick (); ev (Map.add p.Name (ref a) env) body)
    | Fable.Delegate(ps, body, _, _) ->
        VFn(fun args -> tick (); ev (List.fold2 (fun m (p: Fable.Ident) a -> Map.add p.Name (ref a) m) env ps args) body)
    | Fable.CurriedApply(callee, args, _, _) ->
        match ev env callee with
        | VFn f -> f (args |> List.map (ev env))
        | _ -> failwith "not a function"
    | o -> failwithf "ref: %A" o

// ───────────── generator ─────────────
let private fnT = fn1 i32T i32T
let private fn2T = Fable.Type.DelegateType([ i32T; i32T ], i32T)
let private hoT = Fable.Type.DelegateType([ fnT; i32T ], i32T)

type Gen(seed: int) =
    let r = Random(seed)
    let mutable uid = 0
    let fresh p = uid <- uid + 1; sprintf "%s%d" p uid
    let pick (xs: 'a list) = List.item (r.Next xs.Length) xs
    /// env entries: (name, kind)  kind: 0 = int, 1 = Int→Int closure, 2 = (Int,Int)→Int closure
    member g.Int(d: int, env: (string * int) list) : Fable.Expr =
        let ints = env |> List.filter (fun (_, k) -> k = 0) |> List.map fst
        let fns1 = env |> List.filter (fun (_, k) -> k = 1) |> List.map fst
        let fns2 = env |> List.filter (fun (_, k) -> k = 2) |> List.map fst
        let leaf () = if ints.IsEmpty || r.Next 3 = 0 then num (r.Next(-9, 10)) else var (id32 (pick ints))
        if d <= 0 then leaf ()
        else
            match r.Next 12 with
            | 0 | 1 -> (pick [ add; sub; mul ]) (g.Int(d - 1, env)) (g.Int(d - 1, env))
            | 2 -> ite (Fable.Operation(Fable.Binary((pick [ BinaryOperator.BinaryEqual; BinaryOperator.BinaryLessOrEqual; BinaryOperator.BinaryLess ]), g.Int(d - 1, env), g.Int(d - 1, env)), [], boolT, None))
                       (g.Int(d - 1, env)) (g.Int(d - 1, env))
            | 3 -> let n = fresh "x" in Fable.Let(id32 n, g.Int(d - 1, env), g.Int(d - 1, (n, 0) :: env))
            | 4 | 5 -> app (g.Fn1(d - 1, env)) [ g.Int(d - 1, env) ] i32T                       // apply (possibly a literal / known function)
            | 6 -> let n = fresh "f" in Fable.Let(ident n fnT, g.Fn1(d - 1, env), g.Int(d - 1, (n, 1) :: env))
            | 7 ->  // 2-ary closure literal applied directly, or a bound one
                if fns2.IsEmpty || r.Next 2 = 0 then
                    let p, q = fresh "p", fresh "q"
                    let c = Fable.Delegate([ id32 p; id32 q ], g.Int(d - 1, (p, 0) :: (q, 0) :: env), None, [])
                    app c [ g.Int(d - 1, env); g.Int(d - 1, env) ] i32T
                else app (var (ident (pick fns2) fn2T)) [ g.Int(d - 1, env); g.Int(d - 1, env) ] i32T
            | 8 ->  // higher-order: h = fun (g: Int→Int) (x: Int) -> body using g;  h <closure literal> arg
                let gp, xp = fresh "g", fresh "x"
                let body = g.Int(d - 1, (xp, 0) :: (gp, 1) :: env)
                let h = Fable.Delegate([ ident gp fnT; id32 xp ], body, None, [])
                let hn = fresh "h"
                Fable.Let(ident hn hoT, h, app (var (ident hn hoT)) [ g.Fn1(d - 1, env); g.Int(d - 1, env) ] i32T)
            | 9 -> g.LetRec(d, env)
            | 10 -> if fns2.IsEmpty then leaf () else app (var (ident (pick fns2) fn2T)) [ g.Int(d - 1, env); g.Int(d - 1, env) ] i32T
            | _ -> leaf ()
    member g.Fn1(d: int, env: (string * int) list) : Fable.Expr =
        let fns1 = env |> List.filter (fun (_, k) -> k = 1) |> List.map fst
        match r.Next 6 with
        | 0 when not fns1.IsEmpty -> var (ident (pick fns1) fnT)
        | 1 -> var (ident (pick [ "m0"; "m1" ]) fnT)                                                // module function used as a value
        | 2 when d > 0 ->                                                                         // compose f ∘ g
            let p = fresh "c"
            Fable.Lambda(id32 p, app (g.Fn1(d - 1, env)) [ app (g.Fn1(d - 1, env)) [ var (id32 p) ] i32T ] i32T, None)
        | _ ->
            let p = fresh "p"
            Fable.Lambda(id32 p, g.Int(max 0 (d - 1), (p, 0) :: env), None)
    /// group of 2–3 mutually recursive closures; fuel parameter strictly decreases, so evaluation terminates
    member g.LetRec(d: int, env: (string * int) list) : Fable.Expr =
        let n = r.Next(2, 4)
        let names = [ for _ in 1 .. n -> fresh "rf" ]
        let idents = names |> List.map (fun nm -> ident nm fnT)
        let sd = max 0 (d - 2)
        let bindings =
            [ for (nm, idn) in List.zip names idents ->
                let pn = fresh "n"
                let recEnv = (pn, 0) :: (names |> List.map (fun x -> x, 1)) @ env
                let next () = app (var (ident (pick names) fnT)) [ sub (var (id32 pn)) (num 1) ] i32T
                let baseCase = g.Int(sd, (pn, 0) :: env)
                let step = (pick [ add; sub; mul ]) (next ()) (g.Int(sd, recEnv |> List.filter (fun (x, k) -> k = 0 || not (List.contains x names))))
                idn, Fable.Lambda(id32 pn, ite (Fable.Operation(Fable.Binary(BinaryOperator.BinaryLessOrEqual, var (id32 pn), num 0), [], boolT, None)) baseCase step, None) ]
        let startArg = Fable.Operation(Fable.Binary(BinaryOperator.BinaryPlus, num (r.Next(0, 5)), num 0), [], i32T, None)
        Fable.LetRec(bindings, app (var (pick idents)) [ add startArg (num (r.Next(0, 4))) ] i32T)

// ───────────── driver ─────────────
let private jstr (s: string) = "\"" + s.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\""
let private inputs =
    let e = [| 0; 1; -1; 2; 7; Int32.MinValue; Int32.MaxValue; -8 |]
    [ for a in e do for b in e -> a, b ]

/// Returns number of programs written (discarded programs are replaced by a constant).
let generate (seed: int) (count: int) (dir: string) : int =
    IO.Directory.CreateDirectory dir |> ignore
    let g = Gen(seed)
    let ctx0 = newCtx ()
    // module-level functions (also used as first-class values through KnownFuncs)
    let x = id32 "x"
    defFunc ctx0 "m0" [ x ] (add (mul (var x) (num 3)) (num 1)) false |> ignore
    defFunc ctx0 "m1" [ x ] (sub (var x) (num 5)) false |> ignore
    let ctx = { ctx0 with KnownFuncs = Map.ofList [ "m0", ([ WType.I32 ], WType.I32); "m1", ([ WType.I32 ], WType.I32) ] }
    let rows = System.Collections.Generic.List<string * string * string list>()
    for k in 0 .. count - 1 do
        let env = [ "a", 0; "b", 0 ]
        let rec attempt tries =
            let prog = g.Int(3 + k % 3, env)
            let results =
                try
                    inputs |> List.map (fun (a, b) ->
                        steps <- 0
                        string (asInt (ev (Map.ofList [ "a", ref (VInt a); "b", ref (VInt b) ]) prog)))
                    |> Some
                with Budget -> None
            match results with
            | Some rs -> prog, rs
            | None -> if tries > 20 then num 0, inputs |> List.map (fun _ -> "0") else attempt (tries + 1)
        let prog, results = attempt 0
        let name = sprintf "f%d" k
        defFunc ctx name [ id32 "a"; id32 "b" ] prog true |> ignore
        let text = (sprintf "%A" prog).Replace("\n", " ")
        rows.Add((name, text.Substring(0, min 400 text.Length), results))
    let funcs = ctx.Functions |> Seq.toList |> WasmGc.Runtime.ArraySort.specialize ctx |> WasmGc.Runtime.Runtime.fixClosureApply ctx.TypeDefs
    let m = mkModule ctx.TypeDefs funcs
    let mo, errs = runPhases m
    for e in errs do eprintfn "  [validator] %s %s: %s" e.FuncName e.NodeDesc e.Message
    IO.File.WriteAllText(IO.Path.Combine(dir, "opt.wat"), WasmGc.Emit.Wat.moduleToWat mo)
    IO.File.WriteAllBytes(IO.Path.Combine(dir, "opt.wasm"), WasmGc.Emit.Encoder.encodeModule (WasmGc.Emit.Emit.emitModule mo))
    let n = WasmGc.Pipeline.Normalizer.normalizeModule m
    let l = WasmGc.Pipeline.Lower.lowerModule n
    let mn = { l with Functions = List.map WasmGc.Runtime.Locals.resolveLocals l.Functions }
    IO.File.WriteAllText(IO.Path.Combine(dir, "noopt.wat"), WasmGc.Emit.Wat.moduleToWat mn)
    IO.File.WriteAllBytes(IO.Path.Combine(dir, "noopt.wasm"), WasmGc.Emit.Encoder.encodeModule (WasmGc.Emit.Emit.emitModule mn))
    let sb = StringBuilder()
    sb.Append("{\"inputs\":[").Append(String.Join(",", inputs |> List.map (fun (a, b) -> sprintf "[%d,%d]" a b))).Append("],\"funcs\":[") |> ignore
    sb.Append(String.Join(",", rows |> Seq.map (fun (nm, src, rs) -> sprintf "{\"name\":\"%s\",\"src\":%s,\"expected\":[%s]}" nm (jstr src) (String.Join(",", rs |> List.map jstr))))).Append("]}") |> ignore
    IO.File.WriteAllText(IO.Path.Combine(dir, "expected.json"), sb.ToString())
    count
