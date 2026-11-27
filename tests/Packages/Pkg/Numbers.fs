namespace Fixture.Pkg

module Numbers =
    /// A name that is also a JavaScript global: the front end keeps the two apart (`isFinite$`), and a program must still find this function by it.
    let isFinite (n: float) : bool = n - n = 0.0

    /// The same for `parseInt`; `None` for anything that is not decimal digits.
    let parseInt (s: string) : int option =
        let mutable acc = 0
        let mutable ok = s.Length > 0
        for c in s do
            if c >= '0' && c <= '9' then acc <- acc * 10 + (int c - int '0') else ok <- false
        if ok then Some acc else None
