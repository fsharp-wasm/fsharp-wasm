module WasmTests.Integration.CompilerPipelineSmokeTests

open Wasmecto
open Wasmecto.Expect
open System

type Customer = { Name: string; Tier: int }

type Discount =
    | NoDiscount
    | Percent of int
    | Fixed of int

type Op =
    | Add of int
    | Mul of int
    | Custom of (int -> int)

type Point = { X: int; Y: int }
type Segment = { A: Point; B: Point }

let private applyDiscount (basePrice: int) (d: Discount) =
    match d with
    | NoDiscount -> basePrice
    | Percent p -> basePrice - (basePrice * p / 100)
    | Fixed f -> basePrice - f

let private tierDiscount tier =
    if tier >= 3 then Percent 15
    elif tier = 2 then Percent 10
    elif tier = 1 then Fixed 2
    else NoDiscount

let private runOp (op: Op) (value: int) =
    match op with
    | Add n -> value + n
    | Mul n -> value * n
    | Custom f -> f value

[<AutoOpen>]
module CompilerPipelineSmokeTests =

    let tests =
        testList "Integration/CompilerPipeline.Smoke" [

            testCase "record + DU + list.fold => pricing pipeline" <| fun () ->
                let customer = { Name = "alpha"; Tier = 2 }
                let lines = [10; 20; 30; 40]
                let subtotal = List.fold (+) 0 lines
                let discount = tierDiscount customer.Tier
                let total = applyDiscount subtotal discount
                Expect.equal subtotal 100 "subtotal from list.fold"
                Expect.equal total 90 "tier-2 applies 10%"

            testCase "array -> map/filter -> List.tryHead -> Option.defaultValue" <| fun () ->
                let raw = [|1; 2; 3; 4; 5; 6|]
                let transformed =
                    raw
                    |> Array.map (fun x -> x * 3)
                    |> Array.filter (fun x -> x % 2 = 0)
                    |> Array.toList
                // transformed = [6; 12; 18]
                let headOrFallback =
                    transformed
                    |> List.tryHead
                    |> Option.defaultValue -1
                Expect.sequenceEqual transformed [6; 12; 18] "array/list combinators composed"
                Expect.equal headOrFallback 6 "option default path chooses head"

            testCase "closure capture + recursion + HOF composition" <| fun () ->
                let rec fib n =
                    if n <= 1 then n
                    else fib (n - 1) + fib (n - 2)

                let makeThresholdFilter threshold =
                    fun x -> x >= threshold

                let keep = makeThresholdFilter 5
                let values = [0; 1; 2; 3; 4; 5; 6; 7] |> List.map fib |> List.filter keep
                // fibs: [0;1;1;2;3;5;8;13] -> keep >=5 => [5;8;13]
                let sum = List.fold (+) 0 values

                Expect.sequenceEqual values [5; 8; 13] "closure filter over recursive results"
                Expect.equal sum 26 "sum after integration pipeline"

            testCase "Result + Option + String + Math in one flow" <| fun () ->
                let parsePositiveInt (s: string) : Result<int, string> =
                    if s = "7" then Ok 7
                    elif s = "12" then Ok 12
                    elif s = "-2" then Ok -2
                    else Error "not-supported"

                let normalize (s: string) =
                    match parsePositiveInt s with
                    | Error e -> Error e
                    | Ok n ->
                        if n <= 0 then Error "non-positive"
                        else
                            let clamped = Math.Clamp(n * 2, 0, 20)
                            Ok clamped

                let r1 = normalize "7"
                let r2 = normalize "-2"
                let firstOk =
                    [r1; r2]
                    |> List.tryPick (function Ok v -> Some v | Error _ -> None)
                    |> Option.defaultValue -1

                Expect.equal r1 (Ok 14) "parse + validate + clamp"
                Expect.equal r2 (Error "non-positive") "validation branch"
                Expect.equal firstOk 14 "option over result list"

            testCase "while loop + mutable state + DU function application" <| fun () ->
                let program : Op list =
                    [ Add 2
                      Mul 3
                      Custom (fun x -> x - 4)
                      Add 1 ]

                let mutable i = 0
                let mutable acc = 0
                let arr = List.toArray program

                while i < arr.Length do
                    acc <- runOp arr.[i] acc
                    i <- i + 1

                // ((((0 + 2) * 3) - 4) + 1) = 3
                Expect.equal acc 3 "imperative execution over DU-program"

            testCase "integration smoke: nested records + tuples + arrays + folds" <| fun () ->
                // type Point = { X: int; Y: int }
                // type Segment = { A: Point; B: Point }

                let segments =
                    [| { A = { X = 0; Y = 0 }; B = { X = 3; Y = 4 } }   // manhattan 7
                       { A = { X = 1; Y = 1 }; B = { X = 4; Y = 5 } } |] // manhattan 7

                let lengths =
                    segments
                    |> Array.map (fun s ->
                        let dx = Math.Abs(s.B.X - s.A.X)
                        let dy = Math.Abs(s.B.Y - s.A.Y)
                        (dx, dy))
                    |> Array.map (fun (dx, dy) -> dx + dy)

                let total = Array.fold (+) 0 lengths

                Expect.arrayEqual lengths [|7; 7|] "tuple + record projection through array pipeline"
                Expect.equal total 14 "fold over transformed array"
        ]
