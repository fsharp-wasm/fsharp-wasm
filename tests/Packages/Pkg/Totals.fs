namespace Fixture.Pkg

/// A type and a module of one name: the front end calls the module `TotalsModule`, and its functions are selected by that name.
type Totals = { Count: int; Sum: int }

module Totals =
    let empty : Totals = { Count = 0; Sum = 0 }

    /// Counts and adds a number that is finite; any other is left out.
    let add (t: Totals) (n: float) : Totals =
        if Numbers.isFinite n then { Count = t.Count + 1; Sum = t.Sum + int n } else t
