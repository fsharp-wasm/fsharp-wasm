
/// Current state: Fable routes `Seq.*` calls to `List.*` via its own replacement layer. This works for operations that exist on List, but fails for Seq-specific operations (`Seq.delay`, `Seq.cache`, `Seq.unfold`, range expressions `[1..10]`).
module SeqModule

// MVP: Seq<'T> = 'T list (eager evaluation)
// Fable desugars seq { } to LibCall("Seq", "delay/append/singleton/...")

let delay (f: unit -> 'T list) : 'T list = f ()
let singleton (x: 'T) : 'T list = [x]
let empty<'T> : 'T list = []
let append (a: 'T list) (b: 'T list) : 'T list = a @ b

let map (f: 'T -> 'U) (xs: 'T list) : 'U list = List.map f xs
let mapi (f: int -> 'T -> 'U) (xs: 'T list) : 'U list = List.mapi f xs
let filter (f: 'T -> bool) (xs: 'T list) : 'T list = List.filter f xs
let choose (f: 'T -> 'U option) (xs: 'T list) : 'U list = List.choose f xs
let collect (f: 'T -> 'U list) (xs: 'T list) : 'U list = List.collect f xs

let fold (f: 'S -> 'T -> 'S) (state: 'S) (xs: 'T list) : 'S = List.fold f state xs
let reduce (f: 'T -> 'T -> 'T) (xs: 'T list) : 'T = List.reduce f xs
let iter (f: 'T -> unit) (xs: 'T list) : unit = List.iter f xs
let iteri (f: int -> 'T -> unit) (xs: 'T list) : unit = List.iteri f xs

let toList (xs: 'T list) : 'T list = xs
let toArray (xs: 'T list) : 'T array = List.toArray xs
let ofList (xs: 'T list) : 'T list = xs
let ofArray (xs: 'T array) : 'T list = Array.toList xs
let length (xs: 'T list) : int = List.length xs
let head (xs: 'T list) : 'T = List.head xs
let tryHead (xs: 'T list) : 'T option = List.tryHead xs
let tail (xs: 'T list) : 'T list = List.tail xs
let isEmpty (xs: 'T list) : bool = List.isEmpty xs
let item (i: int) (xs: 'T list) : 'T = List.item i xs

let contains (eq: 'T -> 'T -> bool) (x: 'T) (xs: 'T list) : bool =
    List.exists (fun e -> eq e x) xs
let exists (f: 'T -> bool) (xs: 'T list) : bool = List.exists f xs
let forall (f: 'T -> bool) (xs: 'T list) : bool = List.forall f xs
let find (f: 'T -> bool) (xs: 'T list) : 'T = List.find f xs
let tryFind (f: 'T -> bool) (xs: 'T list) : 'T option = List.tryFind f xs
let findIndex (f: 'T -> bool) (xs: 'T list) : int = List.findIndex f xs

let sum (xs: int list) : int = List.sum xs
let sumBy (f: 'T -> int) (xs: 'T list) : int = List.sumBy f xs
let min (xs: int list) : int = List.min xs
let max (xs: int list) : int = List.max xs
let minBy (f: 'T -> int) (xs: 'T list) : 'T = List.minBy f xs
let maxBy (f: 'T -> int) (xs: 'T list) : 'T = List.maxBy f xs
let average (xs: float list) : float = List.average xs

let sort (xs: 'T list) : 'T list = List.sort xs
let sortBy (f: 'T -> 'K) (xs: 'T list) : 'T list = List.sortBy f xs
let sortWith (cmp: 'T -> 'T -> int) (xs: 'T list) : 'T list = List.sortWith cmp xs
let rev (xs: 'T list) : 'T list = List.rev xs

let zip (a: 'T list) (b: 'U list) : ('T * 'U) list = List.zip a b
let unzip (xs: ('T * 'U) list) : 'T list * 'U list = List.unzip xs
let pairwise (xs: 'T list) : ('T * 'T) list = List.pairwise xs
let distinct (xs: 'T list) : 'T list = List.distinct xs
let distinctBy (f: 'T -> 'K) (xs: 'T list) : 'T list = List.distinctBy f xs
let groupBy (f: 'T -> 'K) (xs: 'T list) : ('K * 'T list) list = List.groupBy f xs
let countBy (f: 'T -> 'K) (xs: 'T list) : ('K * int) list = List.countBy f xs

let skip (n: int) (xs: 'T list) : 'T list = List.skip n xs
let take (n: int) (xs: 'T list) : 'T list = List.take n xs
let truncate (n: int) (xs: 'T list) : 'T list = List.truncate n xs

// Range — Fable emits this for [start..stop] and [start..step..stop]
let rangeNumber (start: int) (step: int) (stop: int) : int list =
    let rec go acc i =
        if (step > 0 && i > stop) || (step < 0 && i < stop) then List.rev acc
        else go (i :: acc) (i + step)
    go [] start

// Unfold — generates elements from a state function
let unfold (f: 'S -> ('T * 'S) option) (state: 'S) : 'T list =
    let rec go acc s =
        match f s with
        | None -> List.rev acc
        | Some (x, s') -> go (x :: acc) s'
    go [] state

// Init — generate n elements
let init (n: int) (f: int -> 'T) : 'T list =
    let rec go acc i =
        if i >= n then List.rev acc
        else go (f i :: acc) (i + 1)
    go [] 0