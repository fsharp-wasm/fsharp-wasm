module Consumer

open Fixture.Pkg

let private totals () : Totals =
    [ "1"; "2"; "x"; "40" ]
    |> List.choose Numbers.parseInt
    |> List.fold (fun t n -> Totals.add t (float n)) Totals.empty

/// 1 + 2 + 40 (the "x" is not a number)
let sum () : int = (totals ()).Sum
let count () : int = (totals ()).Count
/// 1: a finite number is finite, and the quotient of a division by zero is not
let finiteOnly () : int = (if Numbers.isFinite 2.5 then 1 else 0) + (if Numbers.isFinite (1.0 / 0.0) then 10 else 0)
