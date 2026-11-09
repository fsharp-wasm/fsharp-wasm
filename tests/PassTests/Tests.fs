module Tests

open System
open System.Collections.Generic
open Fable.AST
open Fable.AST.Fable
open Fable.Transforms
open WasmGc.Transforms

let intT = Number(NumberKind.Int32, NumberInfo.Empty)
let ident n t : Ident =
    { Name = n; Type = t; IsMutable = false; IsThisArgument = false
      IsCompilerGenerated = false; Range = None; IsInlineIfLambda = false }
let num (n: int) = Value(NumberConstant(NumberValue.Int32 n, NumberInfo.Empty), None)
let var n t = IdentExpr(ident n t)
let plus a b = Operation(Binary(BinaryOperator.BinaryPlus, a, b), [], intT, None)
let app f args t = CurriedApply(f, args, t, None)

// ── tiny interpreter over the subset the pass touches ──────────────────────────
type V = I of int | C of (V -> V)
let rec eval (env: Map<string, V>) (e: Expr) : V =
    match e with
    | Value(NumberConstant(NumberValue.Int32 n, _), _) -> I n
    | Value(UnitConstant, _) -> I 0
    | IdentExpr i -> env.[i.Name]
    | Let(i, v, b) -> eval (Map.add i.Name (eval env v) env) b
    | Lambda(a, b, _) -> C(fun x -> eval (Map.add a.Name x env) b)
    | Sequential es -> es |> List.map (eval env) |> List.last
    | Operation(Binary(_, a, b), _, _, _) ->
        match eval env a, eval env b with
        | I x, I y -> I(x + y)
        | _ -> failwith "plus on closure"
    | CurriedApply(f, args, _, _) ->
        let fv = eval env f
        let avs = args |> List.map (eval env)
        avs |> List.fold (fun acc a -> match acc with C g -> g a | _ -> failwith "apply int") fv
    | _ -> failwithf "eval: unsupported %A" e
let rec observe d v = match v with I n -> n | C f -> (if d > 8 then -1 else observe (d + 1) (f (I (7 + d))))

// ── random well-typed programs, tiny name pool → lots of shadowing ───────────
type Ty = TI | TF of Ty * Ty
let rec fty = function TI -> intT | TF(a, r) -> LambdaType(fty a, fty r)
let names = [| "x"; "y"; "z" |]
let rec gen (rnd: Random) (ty: Ty) (scope: (string * Ty) list) (d: int) : Expr =
    let pick () = names.[rnd.Next names.Length]
    let vars = scope |> List.filter (fun (_, t) -> t = ty) |> List.map fst |> List.distinct
    // a name only counts as visible if its *innermost* binding has the wanted type
    let visible = vars |> List.filter (fun n -> match List.tryFind (fun (m, _) -> m = n) scope with Some(_, t) -> t = ty | _ -> false)
    let leaf () =
        match ty with
        | TI -> if not visible.IsEmpty && rnd.Next 3 > 0 then var visible.[rnd.Next visible.Length] (fty ty) else num (rnd.Next 100)
        | TF(a, r) ->
            let n = pick ()
            Lambda(ident n (fty a), gen rnd r ((n, a) :: scope) 0, None)
    if d <= 0 then leaf ()
    else
    match rnd.Next 6 with
    | 0 -> leaf ()
    | 1 ->
        let t = if rnd.Next 2 = 0 then TI else TF(TI, TI)
        let n = pick ()
        Let(ident n (fty t), gen rnd t scope (d - 1), gen rnd ty ((n, t) :: scope) (d - 1))
    | 2 ->
        let a = if rnd.Next 2 = 0 then TI else TF(TI, TI)
        app (gen rnd (TF(a, ty)) scope (d - 1)) [ gen rnd a scope (d - 1) ] (fty ty)
    | 3 ->   // two-arg application of nested lambdas / partial pipelines
        let a, b = TI, TI
        app (gen rnd (TF(a, TF(b, ty))) scope (d - 1)) [ gen rnd a scope (d - 1); gen rnd b scope (d - 1) ] (fty ty)
    | 4 when ty = TI -> plus (gen rnd TI scope (d - 1)) (gen rnd TI scope (d - 1))
    | 5 ->   // pipeline shape: x |> (fun p -> body)  nested twice with the SAME param name
        let a = TI
        let n = pick ()
        let inner = app (Lambda(ident n (fty a), gen rnd a ((n, a) :: scope) (d - 1), None)) [ gen rnd a scope (d - 1) ] (fty a)
        app (Lambda(ident n (fty a), gen rnd ty ((n, a) :: scope) (d - 1), None)) [ inner ] (fty ty)
    | _ -> leaf ()

// ── invariants ───────────────────────────────────────────────────────────────
let binders (e: Expr) =
    let acc = System.Collections.Generic.List<string>()
    e |> visitFromInsideOut (fun x ->
        (match x with
         | Let(i, _, _) -> acc.Add i.Name
         | Lambda(a, _, _) -> acc.Add a.Name
         | _ -> ())
        x) |> ignore
    List.ofSeq acc
let remainingBeta (e: Expr) =
    let n = ref 0
    e |> visitFromInsideOut (fun x ->
        (match x with CurriedApply(Lambda _, _ :: _, _, _) -> n.Value <- n.Value + 1 | _ -> ())
        x) |> ignore
    n.Value
let refs name e =
    let n = ref 0
    e |> visitFromInsideOut (fun x -> (match x with IdentExpr i when i.Name = name -> n.Value <- n.Value + 1 | _ -> ()); x) |> ignore
    n.Value
let singleUseLambdaLets (e: Expr) =
    let n = ref 0
    e |> visitFromInsideOut (fun x ->
        (match x with Let(i, Lambda _, b) when refs i.Name b = 1 -> n.Value <- n.Value + 1 | _ -> ())
        x) |> ignore
    n.Value

let mutable failures = 0
let check name cond = if not cond then (failures <- failures + 1; printfn "FAIL: %s" name) else printfn "ok:   %s" name

let mkCall2 (fn: Expr) (listArg: Expr) =
    Call(Import({ Selector = "sumBy"; Path = "List.fs"; Kind = LibraryImport(LibraryImportInfo.Create()) }, Any, None),
         { ThisArg = None; Args = [ fn; listArg ]; SignatureArgTypes = []; GenericArgs = []; MemberRef = None; Tags = [] },
         intT, None)

// ═════════════════════════ WExpr: UniqueLocals ═════════════════════════
module WT =
    open WasmGc.Core.AST
    type WE = WasmGc.Core.AST.WExpr
    exception ContinueEx of string

    type Sem =
        abstract Get: string -> int
        abstract Set: string * int -> unit
        abstract Bind: string * int * (unit -> int) -> int

    type Lexical() =
        let mutable env: Map<string, int ref> = Map.empty
        interface Sem with
            member _.Get n = env.[n].Value
            member _.Set(n, v) = env.[n].Value <- v
            member _.Bind(n, v, k) =
                let saved = env
                env <- Map.add n (ref v) env
                try k () finally env <- saved

    /// what WASM actually does: one slot per name
    type Flat() =
        let d = Dictionary<string, int>()
        interface Sem with
            member _.Get n = d.[n]
            member _.Set(n, v) = d.[n] <- v
            member _.Bind(n, v, k) = d.[n] <- v; k ()

    let i32 n = WE.Const(WConst.I32 n)
    let get n = WE.LocalGet(n, WType.I32)
    let add a b = WE.Binary(WBinaryOp.Add, a, b, WType.I32)

    let rec ev (s: Sem) (e: WE) : int =
        match e with
        | WE.Const(WConst.I32 n) -> n
        | WE.LocalGet(n, _) -> s.Get n
        | WE.Let(n, v, b) | WE.LetMut(n, v, b) -> let x = ev s v in s.Bind(n, x, fun () -> ev s b)
        | WE.Assign(n, v) -> s.Set(n, ev s v); 0
        | WE.Binary(_, a, b, _) -> let x = ev s a in x + ev s b
        | WE.Compare(_, a, b) -> let x = ev s a in if x <= ev s b then 1 else 0
        | WE.If(c, t, f, _) -> if ev s c <> 0 then ev s t else ev s f
        | WE.Sequence xs -> xs |> List.fold (fun _ x -> ev s x) 0
        | WE.Nop -> 0
        | WE.Continue(l, _) -> raise (ContinueEx l)
        | WE.Loop(l, b, _) ->
            let rec run () = try ev s b |> ignore with ContinueEx m when m = l -> run ()
            run (); 0
        | _ -> failwithf "ev: %A" e

    /// exactly the shape TransformConstruct.buildFor emits
    let forLoop (i: string) (start: int) (limit: int) (body: WE) =
        WE.Let(i, i32 start,
          WE.Let("$limit", i32 limit,
            WE.Loop("$for",
              WE.If(WE.Compare(WCompareOp.LeS, get i, get "$limit"),
                    WE.Sequence [ body; WE.Assign(i, add (get i) (i32 1)); WE.Continue("$for", []) ],
                    WE.Nop, WType.Void), WType.Void)))

    let func ps body : WFuncDecl = { Name = "f"; Params = ps; Result = WType.I32; Locals = []; Body = body; Exported = false }
    let run (sem: Sem) (f: WFuncDecl) (args: (string * int) list) =
        let rec bindAll = function [] -> ev sem f.Body | (n, v) :: r -> sem.Bind(n, v, fun () -> bindAll r)
        bindAll args
    let binders (e: WE) =
        let acc = System.Collections.Generic.List<string>()
        let rec go x =
            (match x with
             | WE.Let(n, _, _) | WE.LetMut(n, _, _) -> acc.Add n
             | _ -> ())
            WasmGc.Core.Traverse.children x |> List.iter go
        go e
        List.ofSeq acc

    let tests () =
        // nested for loops: the inner `$limit` used to overwrite the outer one
        let nested = WE.LetMut("acc", i32 0, WE.Sequence [ forLoop "i" 0 2 (forLoop "j" 0 5 (WE.Assign("acc", add (get "acc") (i32 1)))); get "acc" ])
        let f = func [] nested
        let before = run (Flat()) f []
        let after = run (Flat()) (WasmGc.Pipeline.UniqueLocals.uniqueFunc f) []
        check (sprintf "nested for: lexical = 18 (flat before pass = %d)" before) (run (Lexical()) f [] = 18)
        check "nested for: flat execution WRONG before the pass" (before <> 18)
        check "nested for: flat execution correct after the pass" (after = 18)
        // sequential loops: a single `$limit` binder each → unique names (no duplicate-local WAT)
        let seq2 = WE.Sequence [ forLoop "i" 0 1 (WE.Nop); forLoop "k" 0 1 (WE.Nop); i32 0 ]
        let b = binders (WasmGc.Pipeline.UniqueLocals.uniqueFunc (func [] seq2)).Body
        check "sequential loops: binders unique" (b.Length = (List.distinct b).Length)
        // parameters are reserved
        let shadow = WE.Let("p", i32 5, add (get "p") (i32 1))
        check "param reserved: inner `p` renamed, result unchanged"
            (let f2 = WasmGc.Pipeline.UniqueLocals.uniqueFunc (func [ "p", WType.I32 ] shadow)
             run (Flat()) f2 [ "p", 100 ] = 6 && (match f2.Body with WE.Let(n, _, _) -> n <> "p" | _ -> false))
        // unchanged function is returned as is (cheap path)
        let plain = func [] (WE.Let("x", i32 1, get "x"))
        check "no collisions: function returned untouched" (obj.ReferenceEquals(WasmGc.Pipeline.UniqueLocals.uniqueFunc plain, plain))
        // property: flat(unique p) == lexical(p) for shadow-heavy programs
        let rnd = Random(777)
        let names = [| "a"; "b"; "$limit"; "p" |]
        let rec gen (scope: string list) d : WE =
            let leaf () = if scope.IsEmpty || rnd.Next 3 = 0 then i32 (rnd.Next 50) else get scope.[rnd.Next scope.Length]
            if d <= 0 then leaf ()
            else
                match rnd.Next 7 with
                | 0 -> leaf ()
                | 1 -> add (gen scope (d - 1)) (gen scope (d - 1))
                | 2 | 3 ->
                    let n = names.[rnd.Next names.Length]
                    let v = gen scope (d - 1)
                    let body = gen (n :: scope) (d - 1)
                    if rnd.Next 2 = 0 then WE.Let(n, v, body) else WE.LetMut(n, v, body)
                | 4 when not scope.IsEmpty ->
                    let n = scope.[rnd.Next scope.Length]
                    WE.Sequence [ WE.Assign(n, gen scope (d - 1)); gen scope (d - 1) ]
                | 5 -> WE.If(WE.Compare(WCompareOp.LeS, gen scope (d - 1), gen scope (d - 1)), gen scope (d - 1), gen scope (d - 1), WType.I32)
                | _ -> WE.Sequence [ gen scope (d - 1); gen scope (d - 1) ]
        let mutable bad = 0
        let N = 20000
        for _ in 1 .. N do
            let body = gen [ "p" ] 6
            let f = func [ "p", WType.I32 ] body
            let g = WasmGc.Pipeline.UniqueLocals.uniqueFunc f
            let bs = binders g.Body
            if run (Lexical()) f [ "p", 9 ] <> run (Flat()) g [ "p", 9 ] then bad <- bad + 1
            if bs.Length <> (List.distinct bs).Length || List.contains "p" bs then bad <- bad + 1
        check (sprintf "property: %d random programs — flat(unique p) = lexical(p), binders unique" N) (bad = 0)

let norm names e = FableNormalize.normalizeBody names e

[<EntryPoint>]
let main _ =
    // 1. exact shape from the log:  greeters |> List.sumBy (fun g -> g.Greet())
    let listT = Type.List intT
    let mkCall (listArg: Expr) =
        Call(Import({ Selector = "sumBy"; Path = "List.fs"; Kind = LibraryImport(LibraryImportInfo.Create()) }, Any, None),
             { ThisArg = None; Args = [ var "g" Any; listArg ]; SignatureArgTypes = []; GenericArgs = []; MemberRef = None; Tags = [] },
             intT, None)
    let pipe = app (Lambda(ident "x" listT, mkCall (var "x" listT), None)) [ var "greeters" listT ] intT
    let r = norm [] pipe
    check "pipe: wrapper lambda removed" (remainingBeta r = 0)
    check "pipe: becomes Let(x, greeters, Call sumBy [g; x])"
        (match r with
         | Let(x, IdentExpr gr, Call(Import(imp, _, _), info, _, _)) ->
            x.Name = "x" && gr.Name = "greeters" && imp.Selector = "sumBy"
            && (match info.Args with [ _; IdentExpr a ] -> a.Name = "x" && (match a.Type with Type.List _ -> true | _ -> false) | _ -> false)
         | _ -> false)

    // 1b. REAL shape: let arg = (fun g -> …) in (fun list -> sumBy arg list)   applied to the list
    let lam = Lambda(ident "g" Any, num 1, None)
    let partialSumBy = Let(ident "arg" (LambdaType(Any, intT)), lam,
                           Lambda(ident "list" listT, mkCall2 (var "arg" (LambdaType(Any, intT))) (var "list" listT), None))
    let r1b = norm [] (app partialSumBy [ var "greeters" listT ] intT)
    check "partial-app pipe: call receives the LITERAL lambda"
        (match r1b with
         | Let(l, IdentExpr gr, Call(Import(imp, _, _), info, _, _)) ->
            l.Name = "list" && gr.Name = "greeters" && imp.Selector = "sumBy"
            && (match info.Args with [ Lambda _; IdentExpr a ] -> a.Name = "list" | _ -> false)
         | _ -> false)
    check "partial-app pipe: no single-use lambda Let left" (singleUseLambdaLets r1b = 0)
    // multi-use lambda must NOT be inlined
    let twice = Let(ident "f" (LambdaType(intT, intT)), Lambda(ident "a" intT, var "a" intT, None),
                    plus (app (var "f" (LambdaType(intT, intT))) [ num 1 ] intT) (app (var "f" (LambdaType(intT, intT))) [ num 2 ] intT))
    check "multi-use lambda kept as binding" (match norm [] twice with Let(f, Lambda _, _) -> f.Name = "f" | _ -> false)

    // 2. a |> f |> g with the same parameter name in both lambdas → two distinct binders
    let inner = app (Lambda(ident "x" intT, plus (var "x" intT) (num 1), None)) [ num 10 ] intT
    let outer = app (Lambda(ident "x" intT, plus (var "x" intT) (num 100), None)) [ inner ] intT
    let r2 = norm [] outer
    check "double pipe: binders unique" (let b = binders r2 in b.Length = (List.distinct b).Length && b.Length = 2)
    check "double pipe: value preserved" (observe 0 (eval Map.empty outer) = 111 && observe 0 (eval Map.empty r2) = 111)

    // 3. unit-parameter lambda applied to ()  →  just the body, no Let / closure
    let u = app (Lambda(ident "u" Unit, num 5, None)) [ Value(UnitConstant, None) ] intT
    check "unit param: reduces to body" (match norm [] u with Value(NumberConstant(NumberValue.Int32 5, _), _) -> true | _ -> false)

    // 4. partial application keeps the remaining lambda
    let partial = app (Lambda(ident "a" intT, Lambda(ident "b" intT, plus (var "a" intT) (var "b" intT), None), None)) [ num 1 ] (LambdaType(intT, intT))
    check "partial: Let(a,1, Lambda b)" (match norm [] partial with Let(a, _, Lambda(b, _, _)) -> a.Name = "a" && b.Name = "b" | _ -> false)

    // 5. shadowing must not change meaning:  let x = 1 in (let x = x + 10 in x) + x
    let sh = Let(ident "x" intT, num 1, plus (Let(ident "x" intT, plus (var "x" intT) (num 10), var "x" intT)) (var "x" intT))
    let sh' = norm [] sh
    check "shadowing: unique binders" (let b = binders sh' in b.Length = (List.distinct b).Length)
    check "shadowing: value preserved (12)" (observe 0 (eval Map.empty sh') = 12 && observe 0 (eval Map.empty sh) = 12)

    // 6. function parameter names are reserved: inner binder named like a param gets renamed
    let withParam = Let(ident "p" intT, num 3, plus (var "p" intT) (var "p" intT))
    check "param reserved" (match norm [ "p" ] withParam with Let(i, _, _) -> i.Name <> "p" | _ -> false)

    // 7. decision-tree targets reuse names: all unique afterwards
    let dt = DecisionTree(num 0, [ [ ident "v" intT ], var "v" intT; [ ident "v" intT ], plus (var "v" intT) (num 1) ])
    let dt' = norm [] dt
    check "decision tree: target idents unique" (match dt' with DecisionTree(_, [ ([ a ], _); ([ b ], _) ]) -> a.Name <> b.Name | _ -> false)

    // 8. property test: random shadow-heavy programs keep their meaning, binders unique, no redex left
    let rnd = Random(12345)
    let mutable bad = 0
    let mutable redexes = 0
    let N = 30000
    for _ in 1 .. N do
        let ty = if rnd.Next 2 = 0 then TI else TF(TI, TI)
        let p = gen rnd ty [] 6
        let q = norm [] p
        let b = binders q
        if observe 0 (eval Map.empty p) <> observe 0 (eval Map.empty q) then bad <- bad + 1
        if b.Length <> (List.distinct b).Length then bad <- bad + 1
        redexes <- redexes + remainingBeta q + singleUseLambdaLets q
    check (sprintf "property: %d random programs preserved + unique binders" N) (bad = 0)
    check "property: no CurriedApply(Lambda) redex / single-use lambda Let survives" (redexes = 0)
    WT.tests ()
    printfn "%s" (if failures = 0 then "ALL OK" else sprintf "%d FAILURES" failures)
    failures
