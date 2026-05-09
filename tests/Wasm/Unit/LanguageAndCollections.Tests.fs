module WasmTests.Unit.LanguageAndCollectionsTests

open Wasmecto

[<AutoOpen>]
module LanguageAndCollectionsTests =

    type Point = { X: int; Y: int }

    type Shape =
        | Circle of int
        | Rect of int * int

    let private shapeArea s =
        match s with
        | Circle r -> r * r
        | Rect (w, h) -> w * h

    let tests =
        testList "Unit/LanguageAndCollections" [
            testCase "integers: arithmetic basics" <| fun () ->
                let a = 10
                let b = 3
                Expect.equal (a + b) 13 "a+b"
                Expect.equal (a - b) 7 "a-b"
                Expect.equal (a * b) 30 "a*b"
                Expect.equal (a / b) 3 "a/b"

            testCase "bool + if/elif/else" <| fun () ->
                let classify n =
                    if n < 0 then -1
                    elif n = 0 then 0
                    else 1
                Expect.equal (classify -7) -1 "negative"
                Expect.equal (classify 0) 0 "zero"
                Expect.equal (classify 5) 1 "positive"

            testCase "match expression with guards" <| fun () ->
                let describe n =
                    match n with
                    | x when x % 2 = 0 -> "even"
                    | _ -> "odd"
                Expect.equal (describe 4) "even" "4 is even"
                Expect.equal (describe 9) "odd" "9 is odd"

            testCase "tuple creation and destructuring" <| fun () ->
                let pair = (7, 11)
                let a, b = pair
                Expect.equal a 7 "fst"
                Expect.equal b 11 "snd"

            testCase "record creation and field read" <| fun () ->
                let p = { X = 4; Y = 5 }
                Expect.equal p.X 4 "X"
                Expect.equal p.Y 5 "Y"

            testCase "record update syntax" <| fun () ->
                let p1 = { X = 1; Y = 2 }
                let p2 = { p1 with Y = 99 }
                Expect.equal p1.Y 2 "source unchanged"
                Expect.equal p2.Y 99 "updated copy"

            testCase "discriminated union pattern matching" <| fun () ->
                Expect.equal (shapeArea (Circle 3)) 9 "circle area proxy"
                Expect.equal (shapeArea (Rect (4, 6))) 24 "rect area"

            testCase "option basic Some/None flow" <| fun () ->
                let defaultOf opt def =
                    match opt with
                    | Some v -> v
                    | None -> def
                Expect.equal (defaultOf (Some 42) 0) 42 "some"
                Expect.equal (defaultOf None 7) 7 "none"

            testCase "result basic Ok/Error flow" <| fun () ->
                let bindPlusOne r =
                    match r with
                    | Ok v -> Ok (v + 1)
                    | Error e -> Error e
                Expect.equal (bindPlusOne (Ok 9)) (Ok 10) "ok path"
                Expect.equal (bindPlusOne (Error "boom")) (Error "boom") "error path"

            testCase "string concat and length" <| fun () ->
                let s = "fsharp" + "-" + "wasm"
                Expect.equal s "fsharp-wasm" "concat"
                Expect.equal s.Length 11 "length"

            testCase "list: head/tail and pattern match" <| fun () ->
                let xs = [1; 2; 3; 4]
                match xs with
                | h :: t ->
                    Expect.equal h 1 "head"
                    Expect.listEqual t [2; 3; 4] "tail"
                | [] ->
                    failwith "unexpected empty list"

            testCase "list: map/filter/fold" <| fun () ->
                let xs = [1; 2; 3; 4; 5]
                let mapped = List.map (fun x -> x * 2) xs
                let filtered = List.filter (fun x -> x > 5) mapped
                let sum = List.fold (fun acc x -> acc + x) 0 filtered
                Expect.listEqual mapped [2; 4; 6; 8; 10] "map"
                Expect.listEqual filtered [6; 8; 10] "filter"
                Expect.equal sum 24 "fold sum"

            testCase "list: collect and choose" <| fun () ->
                let xs = [1; 2; 3]
                let collected = List.collect (fun x -> [x; x * 10]) xs
                let chosen =
                    List.choose
                        (fun x -> if x % 2 = 0 then Some (x / 2) else None)
                        [1; 2; 3; 4; 5; 6]
                Expect.listEqual collected [1; 10; 2; 20; 3; 30] "collect"
                Expect.listEqual chosen [1; 2; 3] "choose"

            testCase "list: contains/min/max/sort" <| fun () ->
                let xs = [4; 1; 9; 2; 7]
                Expect.isTrue (List.contains 9 xs) "contains 9"
                Expect.equal (List.min xs) 1 "min"
                Expect.equal (List.max xs) 9 "max"
                Expect.listEqual (List.sort xs) [1; 2; 4; 7; 9] "sort"

            testCase "array: create, set, index, length" <| fun () ->
                let arr = Array.create 3 0
                arr.[0] <- 5
                arr.[1] <- 6
                arr.[2] <- 7
                Expect.equal arr.[0] 5 "idx0"
                Expect.equal arr.[2] 7 "idx2"
                Expect.equal arr.Length 3 "length"

            testCase "array: map/filter/fold" <| fun () ->
                let src = [|1; 2; 3; 4; 5|]
                let mapped = Array.map (fun x -> x + 1) src
                let filtered = Array.filter (fun x -> x % 2 = 0) mapped
                let sum = Array.fold (+) 0 filtered
                Expect.arrayEqual mapped [|2; 3; 4; 5; 6|] "map"
                Expect.arrayEqual filtered [|2; 4; 6|] "filter"
                Expect.equal sum 12 "fold"

            testCase "array append + rev basics" <| fun () ->
                let a = [|1; 2|]
                let b = [|3; 4; 5|]
                let c = Array.append a b
                let r = Array.rev c
                Expect.arrayEqual c [|1; 2; 3; 4; 5|] "append"
                Expect.arrayEqual r [|5; 4; 3; 2; 1|] "rev"

            testCase "mutable binding in loop" <| fun () ->
                let mutable acc = 0
                for i in 1..5 do
                    acc <- acc + i
                Expect.equal acc 15 "sum 1..5"

            testCase "function values and partial application" <| fun () ->
                let add a b = a + b
                let add10 = add 10
                let values = [1; 2; 3] |> List.map add10
                Expect.listEqual values [11; 12; 13] "partial application"
        ]
