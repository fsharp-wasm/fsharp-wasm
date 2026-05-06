module WasmTests.TestsClosures

open Wasmecto
open Wasmecto.Expect

// ─── helpers (local to this module, not polluting global scope) ───────────────

/// Run a function n times and collect results into a list.
let private collect n (f: int -> 'a) : 'a list =
    let mutable acc = []
    for i = n - 1 downto 0 do
        acc <- f i :: acc
    acc

/// Apply f repeatedly n times starting from seed.
let private iterate n (f: 'a -> 'a) (seed: 'a) : 'a =
    let mutable v = seed
    for _ in 1..n do v <- f v
    v

// ─────────────────────────────────────────────────────────────────────────────
[<AutoOpen>]
module ClosureTests =

    // TODO: this was inside a lambda
    type Transformer = { Apply: int -> int; Name: string }
    type Config = { Factor: int; Offset: int }
    type Op =
        | Add of int
        | Mul of int
        | Custom of (int -> int)
    type Transform = Transform of (int -> int)


    let tests =
        testList "Closures & Captures" [

            // ══════════════════════════════════════════════════════════════════
            // 1. VALUE CAPTURE
            // ══════════════════════════════════════════════════════════════════

            testCase "capture immutable int" <| fun () ->
                let x = 42
                let f () = x
                Expect.equal (f ()) 42 "closed-over int is accessible"

            testCase "capture immutable float" <| fun () ->
                let scale = 2.5
                let double v = v * scale
                Expect.approxEqual (double 4.0) 10.0 1e-12 "float capture"

            testCase "capture immutable string" <| fun () ->
                let prefix = "hello"
                let greet name = prefix + " " + name
                Expect.equal (greet "world") "hello world" "string capture"

            testCase "capture multiple immutable values" <| fun () ->
                let a = 10
                let b = 20
                let c = 30
                let sum () = a + b + c
                Expect.equal (sum ()) 60 "three captured ints"

            testCase "capture value from let binding in another let" <| fun () ->
                let outer = 100
                let inner =
                    let mid = outer + 1
                    fun () -> mid * 2
                Expect.equal (inner ()) 202 "nested let captures"

            // ══════════════════════════════════════════════════════════════════
            // 2. MUTABLE VARIABLE CAPTURE  (ref cells under the hood)
            // ══════════════════════════════════════════════════════════════════

            testCase "capture and mutate mutable int" <| fun () ->
                let mutable counter = 0
                let tick () = counter <- counter + 1
                tick (); tick (); tick ()
                Expect.equal counter 3 "mutable capture via closure"

            testCase "closure sees mutation from outside" <| fun () ->
                let mutable x = 0
                let read () = x
                x <- 99
                Expect.equal (read ()) 99 "closure reads updated mutable"

            testCase "outside sees mutation from closure" <| fun () ->
                let mutable total = 0
                let add n = total <- total + n
                add 5; add 10; add 15
                Expect.equal total 30 "outer mutable updated by closure"

            testCase "two closures share mutable capture" <| fun () ->
                let mutable shared = 0
                let inc () = shared <- shared + 1
                let dec () = shared <- shared - 1
                inc (); inc (); inc (); dec ()
                Expect.equal shared 2 "two closures mutate same ref cell"

            testCase "capture mutable string" <| fun () ->
                let mutable s = "a"
                let append c = s <- s + c
                append "b"; append "c"
                Expect.equal s "abc" "mutable string capture"

            // ══════════════════════════════════════════════════════════════════
            // 3. CLOSURES RETURNED FROM FUNCTIONS  (upward funargs)
            // ══════════════════════════════════════════════════════════════════

            testCase "factory returns closure over local" <| fun () ->
                let makeAdder n = fun x -> x + n
                let add5  = makeAdder 5
                let add10 = makeAdder 10
                Expect.equal (add5  3) 8  "add5 returns 8"
                Expect.equal (add10 3) 13 "add10 returns 13"
                Expect.equal (add5  0) 5  "add5 is independent of add10"

            testCase "factory captures float" <| fun () ->
                let makeScaler factor = fun x -> x * factor
                let triple = makeScaler 3.0
                let half   = makeScaler 0.5
                Expect.approxEqual (triple 4.0) 12.0 1e-12 "triple"
                Expect.approxEqual (half   9.0) 4.5  1e-12 "half"

            testCase "counter factory — independent instances" <| fun () ->
                let makeCounter () =
                    let mutable n = 0
                    fun () -> n <- n + 1; n
                let c1 = makeCounter ()
                let c2 = makeCounter ()
                Expect.equal (c1 ()) 1 "c1 first tick"
                Expect.equal (c1 ()) 2 "c1 second tick"
                Expect.equal (c2 ()) 1 "c2 independent from c1"
                Expect.equal (c1 ()) 3 "c1 third tick"

            testCase "counter factory — mutable state persists across calls" <| fun () ->
                let makeAccumulator () =
                    let mutable total = 0
                    fun n -> total <- total + n; total
                let acc = makeAccumulator ()
                Expect.equal (acc 5)  5  "after 5"
                Expect.equal (acc 10) 15 "after 10"
                Expect.equal (acc 3)  18 "after 3"

            testCase "closure over closure (currying by hand)" <| fun () ->
                let add a = fun b -> fun c -> a + b + c
                let f = add 1
                let g = f 2
                Expect.equal (g 3)   6  "1+2+3"
                Expect.equal (g 100) 103 "1+2+100"
                Expect.equal (f 0 0)  1  "1+0+0"

            // ══════════════════════════════════════════════════════════════════
            // 4. CLOSURES PASSED AS ARGUMENTS  (downward funargs / callbacks)
            // ══════════════════════════════════════════════════════════════════

            testCase "List.map with capturing lambda" <| fun () ->
                let offset = 10
                let result = List.map (fun x -> x + offset) [1; 2; 3; 4; 5]
                Expect.sequenceEqual result [11; 12; 13; 14; 15] "map with capture"

            testCase "List.filter with capturing predicate" <| fun () ->
                let threshold = 3
                let result = List.filter (fun x -> x > threshold) [1; 2; 3; 4; 5]
                Expect.sequenceEqual result [4; 5] "filter with captured threshold"

            testCase "List.fold with capturing accumulator function" <| fun () ->
                let multiplier = 2
                // sum of (x * multiplier) for x in list
                let result = List.fold (fun acc x -> acc + x * multiplier) 0 [1; 2; 3; 4]
                Expect.equal result 20 "fold with captured multiplier: 2*(1+2+3+4)=20"

            testCase "List.exists with capturing predicate" <| fun () ->
                let target = 7
                let found = List.exists (fun x -> x = target) [1; 3; 5; 7; 9]
                Expect.isTrue found "exists with captured target"

            testCase "List.forall with capturing predicate" <| fun () ->
                let bound = 10
                let allSmall = List.forall (fun x -> x < bound) [1; 2; 3; 9]
                Expect.isTrue allSmall "forall with captured bound"

            testCase "callback receives and updates captured mutable" <| fun () ->
                let mutable log = []
                let record x = log <- x :: log
                List.iter record [3; 2; 1]
                Expect.sequenceEqual (List.rev log) [3; 2; 1] "iter callback mutates captured list"

            // ══════════════════════════════════════════════════════════════════
            // 5. CLOSURES STORED IN DATA STRUCTURES
            // ══════════════════════════════════════════════════════════════════

            testCase "list of closures, each with distinct capture" <| fun () ->
                let fns = [ for i in 1..5 -> let n = i in fun () -> n * n ]
                let results = List.map (fun f -> f ()) fns
                Expect.sequenceEqual results [1; 4; 9; 16; 25] "each closure captures its own i"

            
            testCase "record containing a closure" <| fun () ->
                // type Transformer = { Apply: int -> int; Name: string }v
                let double = { Apply = fun x -> x * 2;    Name = "double" }
                let square = { Apply = fun x -> x * x;    Name = "square" }
                Expect.equal (double.Apply 5) 10 "double.Apply 5 = 10"
                Expect.equal (square.Apply 5) 25 "square.Apply 5 = 25"
                Expect.equal double.Name "double" "double name"

            testCase "option containing a closure" <| fun () ->
                let factor = 3
                let maybeF : (int -> int) option = Some(fun x -> x * factor)
                let result =
                    match maybeF with
                    | Some f -> f 7
                    | None   -> 0
                Expect.equal result 21 "closure inside option"

            // ══════════════════════════════════════════════════════════════════
            // 6. PARTIAL APPLICATION
            // ══════════════════════════════════════════════════════════════════

            testCase "partial application of 2-arg function" <| fun () ->
                let add x y = x + y
                let add7 = add 7
                Expect.equal (add7 3)  10 "add7 3 = 10"
                Expect.equal (add7 93) 100 "add7 93 = 100"

            testCase "partial application of 3-arg function" <| fun () ->
                let between lo hi x = x >= lo && x <= hi
                let inRange = between 1 10
                Expect.isTrue  (inRange 5)  "5 is in [1,10]"
                Expect.isFalse (inRange 11) "11 is not in [1,10]"
                Expect.isTrue  (inRange 1)  "1 is in [1,10]"
                Expect.isFalse (inRange 0)  "0 is not in [1,10]"

            testCase "pipeline with partial application" <| fun () ->
                let clamp lo hi x = if x < lo then lo elif x > hi then hi else x
                let clamp0to100 = clamp 0 100
                let result = [-5; 0; 50; 100; 150] |> List.map clamp0to100
                Expect.sequenceEqual result [0; 0; 50; 100; 100] "clamped list"

            testCase "partial application captures caller-scope value" <| fun () ->
                let baseVal = 1000
                let offset n x = baseVal + n + x
                let f = offset 5     // captures baseVal=1000 and n=5
                Expect.equal (f 0) 1005 "f 0 = 1005"
                Expect.equal (f 1) 1006 "f 1 = 1006"

            // ══════════════════════════════════════════════════════════════════
            // 7. RECURSIVE CLOSURES  (let rec + closure)
            // ══════════════════════════════════════════════════════════════════

            testCase "let rec inside closure" <| fun () ->
                let makeFactorial () =
                    let rec fact n =
                        if n <= 1 then 1 else n * fact (n - 1)
                    fact
                let factorial = makeFactorial ()
                Expect.equal (factorial 0)  1    "0! = 1"
                Expect.equal (factorial 1)  1    "1! = 1"
                Expect.equal (factorial 5)  120  "5! = 120"
                Expect.equal (factorial 10) 3628800 "10! = 3628800"

            testCase "mutual recursion inside factory" <| fun () ->
                let makeEvenOdd () =
                    let rec isEven n = if n = 0 then true  else isOdd  (n - 1)
                    and     isOdd  n = if n = 0 then false else isEven (n - 1)
                    isEven, isOdd
                let isEven, isOdd = makeEvenOdd ()
                Expect.isTrue  (isEven 0)  "0 is even"
                Expect.isFalse (isOdd  0)  "0 is not odd"
                Expect.isTrue  (isEven 10) "10 is even"
                Expect.isTrue  (isOdd  7)  "7 is odd"

            testCase "recursive closure over mutable accumulator" <| fun () ->
                let mutable total = 0
                let rec sumTo n =
                    if n > 0 then
                        total <- total + n
                        sumTo (n - 1)
                sumTo 10
                Expect.equal total 55 "sum 1..10 via recursive mutable closure"

            testCase "Fibonacci via recursive closure" <| fun () ->
                let rec fib n =
                    if n <= 1 then n else fib (n - 1) + fib (n - 2)
                let results = List.map fib [0; 1; 2; 3; 4; 5; 6; 7; 8]
                Expect.sequenceEqual results [0; 1; 1; 2; 3; 5; 8; 13; 21] "fib sequence"

            // ══════════════════════════════════════════════════════════════════
            // 8. CLOSURES AND CONTROL FLOW
            // ══════════════════════════════════════════════════════════════════

            testCase "closure captures value from if-branch" <| fun () ->
                let flag = true
                let chosen = if flag then (fun x -> x + 1) else (fun x -> x - 1)
                Expect.equal (chosen 5) 6 "if-branch closure"

            testCase "closure captures value from match" <| fun () ->
                let op = "mul"
                let f =
                    match op with
                    | "add" -> fun a b -> a + b
                    | "mul" -> fun a b -> a * b
                    | _     -> fun a b -> a - b
                Expect.equal (f 3 4) 12 "match-selected closure"

            testCase "loop body closure captures loop variable correctly" <| fun () ->
                // Classic closure-in-loop trap — F# for loops create fresh bindings
                let mutable results = []
                for i in 1..5 do
                    let captured = i         // explicit fresh binding
                    results <- (fun () -> captured) :: results
                let values = List.map (fun f -> f ()) (List.rev results)
                Expect.sequenceEqual values [1; 2; 3; 4; 5]
                    "each closure captures its own loop iteration value"

            testCase "closure in while loop accumulates correctly" <| fun () ->
                let mutable i    = 0
                let mutable sum  = 0
                let step () = i <- i + 1; sum <- sum + i
                while i < 5 do step ()
                Expect.equal sum 15 "1+2+3+4+5 via closure step"

            // ══════════════════════════════════════════════════════════════════
            // 9. HIGHER-ORDER FUNCTION COMPOSITION
            // ══════════════════════════════════════════════════════════════════

            testCase "compose: (f >> g) x = g(f(x))" <| fun () ->
                let double  x = x * 2
                let addOne  x = x + 1
                let doubleThenAdd = double >> addOne
                Expect.equal (doubleThenAdd 5) 11 "2*5+1=11"
                Expect.equal (doubleThenAdd 0) 1  "2*0+1=1"

            testCase "compose three functions" <| fun () ->
                let f x = x + 1
                let g x = x * 3
                let h x = x - 2
                let composed = f >> g >> h
                // composed 4 = h(g(f(4))) = h(g(5)) = h(15) = 13
                Expect.equal (composed 4) 13 "h(g(f(4)))=13"

            testCase "flip: swap arguments of a 2-arg function" <| fun () ->
                let flip f x y = f y x
                let sub a b = a - b
                let subFlipped = flip sub
                Expect.equal (sub 10 3)         7 "sub 10 3 = 7"
                Expect.equal (subFlipped 10 3) (-7) "flip sub 10 3 = 3-10 = -7"

            testCase "memoize via mutable capture" <| fun () ->
                // Simple single-value cache
                let memoize (f: int -> int) : int -> int =
                    let mutable cachedArg = System.Int32.MinValue
                    let mutable cachedVal = 0
                    let mutable callCount = 0
                    fun x ->
                        if x = cachedArg then
                            cachedVal
                        else
                            callCount <- callCount + 1
                            cachedArg <- x
                            cachedVal <- f x
                            cachedVal
                let mutable invocations = 0
                let expensiveFn x =
                    invocations <- invocations + 1
                    x * x
                let memoized = memoize expensiveFn
                Expect.equal (memoized 5) 25 "first call: 25"
                Expect.equal invocations  1  "computed once"
                Expect.equal (memoized 5) 25 "second call: cached"
                Expect.equal invocations  1  "still computed once"
                Expect.equal (memoized 6) 36 "new arg: 36"
                Expect.equal invocations  2  "computed again for new arg"

            testCase "pipeline operator chains with captured values" <| fun () ->
                let threshold = 3
                let multiplier = 10
                let result =
                    [1; 2; 3; 4; 5; 6]
                    |> List.filter (fun x -> x > threshold)
                    |> List.map    (fun x -> x * multiplier)
                    |> List.fold   (+) 0
                // filter: [4;5;6]  map: [40;50;60]  sum: 150
                Expect.equal result 150 "pipeline with captured values"

            // ══════════════════════════════════════════════════════════════════
            // 10. DEEP CAPTURE CHAINS
            // ══════════════════════════════════════════════════════════════════

            testCase "3-level deep capture chain" <| fun () ->
                // Each level captures the previous level's local
                let level1 x =
                    let a = x * 2          // a lives here
                    let level2 y =
                        let b = a + y      // b captures a from level1
                        let level3 z =
                            b * z          // captures b from level2
                        level3
                    level2
                let f = level1 3   // a = 6
                let g = f 4        // b = 6+4 = 10
                Expect.equal (g 5)  50 "3*2=6, 6+4=10, 10*5=50"
                Expect.equal (g 1)  10 "same g, z=1: 10*1=10"
                let h = f 0        // b = 6+0 = 6
                Expect.equal (h 7)  42 "f 0 → b=6, 6*7=42"

            testCase "closure capturing another closure" <| fun () ->
                let adder n     = fun x -> x + n
                let scaler s    = fun x -> x * s
                let add3  = adder  3
                let times2 = scaler 2
                // Compose them manually, capturing the closures themselves
                let add3ThenDouble x = times2 (add3 x)
                Expect.equal (add3ThenDouble 5) 16 "(5+3)*2=16"
                Expect.equal (add3ThenDouble 0) 6  "(0+3)*2=6"

            testCase "closure captures tuple" <| fun () ->
                let pair = (10, 20)
                let sumPair () =
                    let a, b = pair
                    a + b
                Expect.equal (sumPair ()) 30 "closure captures and destructs tuple"

            testCase "closure captures list" <| fun () ->
                let data = [1; 2; 3; 4; 5]
                let sumData () = List.fold (+) 0 data
                let lenData  () = List.length data
                Expect.equal (sumData ()) 15 "closure over list: sum"
                Expect.equal (lenData ())  5 "closure over list: length"

            testCase "closure captures record" <| fun () ->
                // type Config = { Factor: int; Offset: int }
                let cfg = { Factor = 3; Offset = 7 }
                let transform x = x * cfg.Factor + cfg.Offset
                Expect.equal (transform 0)  7  "0*3+7=7"
                Expect.equal (transform 1)  10 "1*3+7=10"
                Expect.equal (transform 10) 37 "10*3+7=37"

            // ══════════════════════════════════════════════════════════════════
            // 11. CLOSURE IDENTITY AND ALIASING
            // ══════════════════════════════════════════════════════════════════

            testCase "two aliases to same closure share state" <| fun () ->
                let mutable n = 0
                let inc = fun () -> n <- n + 1; n
                let alias = inc       // same closure object
                Expect.equal (inc   ()) 1 "inc first call"
                Expect.equal (alias ()) 2 "alias sees same counter"
                Expect.equal (inc   ()) 3 "inc again"

            testCase "passing closure to another function preserves capture" <| fun () ->
                let applyTwice (f: unit -> int) = f () + f ()
                let mutable k = 0
                let step () = k <- k + 1; k
                let result = applyTwice step
                Expect.equal result 3 "step() → 1, step() → 2, sum = 3"
                Expect.equal k      2 "k is 2 after two calls"

            // ══════════════════════════════════════════════════════════════════
            // 12. DISCRIMINATED UNION PATTERNS WITH CLOSURES
            // ══════════════════════════════════════════════════════════════════

            testCase "DU carrying a function" <| fun () ->
                // type Op =
                //     | Add of int
                //     | Mul of int
                //     | Custom of (int -> int)

                let applyOp op x =
                    match op with
                    | Add n    -> x + n
                    | Mul n    -> x * n
                    | Custom f -> f x

                let ops = [Add 5; Mul 3; Custom(fun x -> x * x)]
                let results = List.map (fun op -> applyOp op 4) ops
                Expect.sequenceEqual results [9; 12; 16]
                    "DU ops applied to 4: [4+5=9; 4*3=12; 4^2=16]"

            testCase "accumulate closures in DU list, apply in sequence" <| fun () ->
                // type Transform = Transform of (int -> int)

                let pipeline =
                    [ Transform (fun x -> x + 1)     // +1
                      Transform (fun x -> x * 2)     // *2
                      Transform (fun x -> x - 3) ]   // -3

                let applyAll (xs: Transform list) (v: int) =
                    List.fold (fun acc (Transform f) -> f acc) v xs

                // (((5 + 1) * 2) - 3) = 12 - 3 = 9
                Expect.equal (applyAll pipeline 5) 9 "pipeline of transforms"

            // ══════════════════════════════════════════════════════════════════
            // 13. ITERATOR / GENERATOR PATTERNS VIA MUTABLE CLOSURES
            // ══════════════════════════════════════════════════════════════════

            testCase "range generator via mutable closure" <| fun () ->
                let makeRange from to_ =
                    let mutable current = from
                    fun () ->
                        if current > to_ then None
                        else
                            let v = current
                            current <- current + 1
                            Some v
                let next = makeRange 1 5
                Expect.equal (next ()) (Some 1) "step 1"
                Expect.equal (next ()) (Some 2) "step 2"
                Expect.equal (next ()) (Some 3) "step 3"
                Expect.equal (next ()) (Some 4) "step 4"
                Expect.equal (next ()) (Some 5) "step 5"
                Expect.equal (next ()) None      "exhausted"

            testCase "stateful fibonacci generator" <| fun () ->
                let makeFibGen () =
                    let mutable a = 0
                    let mutable b = 1
                    fun () ->
                        let v = a
                        let next = a + b
                        a <- b
                        b <- next
                        v
                let next = makeFibGen ()
                let fibs = collect 8 (fun _ -> next ())
                Expect.sequenceEqual fibs [0; 1; 1; 2; 3; 5; 8; 13]
                    "fib generator: 0 1 1 2 3 5 8 13"

            testCase "two independent generators don't share state" <| fun () ->
                let makeCounter start =
                    let mutable n = start
                    fun () -> n <- n + 1; n
                let c1 = makeCounter 0
                let c2 = makeCounter 100
                Expect.equal (c1 ()) 1   "c1 step 1"
                Expect.equal (c2 ()) 101 "c2 step 1"
                Expect.equal (c1 ()) 2   "c1 step 2"
                Expect.equal (c2 ()) 102 "c2 step 2"
                Expect.equal (c1 ()) 3   "c1 step 3"

            // ══════════════════════════════════════════════════════════════════
            // 14. STRESS: MANY CLOSURES, MANY CAPTURES
            // ══════════════════════════════════════════════════════════════════

            testCase "100 independent counters" <| fun () ->
                let makeCounter seed =
                    let mutable n = seed
                    fun () -> n <- n + 1; n
                let counters = [ for i in 0..99 -> makeCounter (i * 100) ]
                // Tick each counter once
                let vals = List.map (fun f -> f ()) counters
                // counter i started at i*100, one tick → i*100 + 1
                let expected = [ for i in 0..99 -> i * 100 + 1 ]
                Expect.sequenceEqual vals expected "100 independent counters"

            testCase "closure over large captured list" <| fun () ->
                let data = [ for i in 1..50 -> i ]
                let sumFn () = List.fold (+) 0 data
                let lenFn  () = List.length data
                Expect.equal (sumFn ()) 1275 "sum 1..50 = 1275"
                Expect.equal (lenFn ())   50 "length = 50"

            testCase "iterating closures that each capture distinct list slice" <| fun () ->
                // Each closure captures a different sub-list
                let slices =
                    [ for start in [0; 3; 6; 9] ->
                        let slice = [ start; start+1; start+2 ]
                        fun () -> List.fold (+) 0 slice ]
                let sums = List.map (fun f -> f ()) slices
                // [0+1+2; 3+4+5; 6+7+8; 9+10+11] = [3; 12; 21; 30]
                Expect.sequenceEqual sums [3; 12; 21; 30]
                    "distinct list slices captured independently"
        ]