/// Lists, arrays, closures and higher-order functions.  Collections are built from the int inputs with a fixed
/// length (the inputs only steer the values), results are ints / bools.  Same rules as Props.fs.
module PropsLists

let private xs (a: int) (b: int) : int list = [ a; b; a + b; a - b; b * 2; a ^^^ b ]
let private arr (a: int) (b: int) : int[] = [| a; b; a + b; a - b; b * 2; a ^^^ b |]

// ── lists ───────────────────────────────────────────────────────────────────────────────────────
let prop_ls_length (a: int) (b: int) : int = List.length (xs a b)
let prop_ls_sum (a: int) (b: int) : int = List.sum (xs a b)
let prop_ls_map (a: int) (b: int) : int = xs a b |> List.map (fun v -> v * 3 + 1) |> List.sum
let prop_ls_filter (a: int) (b: int) : int = xs a b |> List.filter (fun v -> v > 0) |> List.length
let prop_ls_fold (a: int) (b: int) : int = xs a b |> List.fold (fun acc v -> acc * 31 + v) 7
let prop_ls_foldBack (a: int) (b: int) : int = List.foldBack (fun v acc -> acc * 31 + v) (xs a b) 7
let prop_ls_reduce (a: int) (b: int) : int = xs a b |> List.reduce (fun x y -> x - y)
let prop_ls_rev (a: int) (b: int) : int = xs a b |> List.rev |> List.fold (fun acc v -> acc * 31 + v) 7
let prop_ls_head (a: int) (b: int) : int = List.head (xs a b)
let prop_ls_last (a: int) (b: int) : int = List.last (xs a b)
let prop_ls_tail (a: int) (b: int) : int = xs a b |> List.tail |> List.length
let prop_ls_nth (a: int) (b: int) (i: int) : int = List.item (i % 8) (xs a b)
let prop_ls_append (a: int) (b: int) : int = (xs a b @ xs b a) |> List.fold (fun acc v -> acc * 31 + v) 7
let prop_ls_cons (a: int) (b: int) : int = (a :: b :: []) |> List.sum
let prop_ls_isEmpty (a: int) : bool = List.isEmpty (if a % 2 = 0 then [] else [ a ])
let prop_ls_exists (a: int) (b: int) : bool = xs a b |> List.exists (fun v -> v = a)
let prop_ls_forall (a: int) (b: int) : bool = xs a b |> List.forall (fun v -> v >= b)
let prop_ls_contains (a: int) (b: int) : bool = List.contains (a + b) (xs a b)
let prop_ls_tryFind (a: int) (b: int) : int = xs a b |> List.tryFind (fun v -> v > b) |> Option.defaultValue -1
let prop_ls_tryFindIndex (a: int) (b: int) : int = xs a b |> List.tryFindIndex (fun v -> v > b) |> Option.defaultValue -1
let prop_ls_choose (a: int) (b: int) : int = xs a b |> List.choose (fun v -> if v % 2 = 0 then Some(v / 2) else None) |> List.sum
let prop_ls_collect (a: int) (b: int) : int = xs a b |> List.collect (fun v -> [ v; v + 1 ]) |> List.length
let prop_ls_zip (a: int) (b: int) : int = List.zip (xs a b) (xs b a) |> List.sumBy (fun (x, y) -> x * y)
let prop_ls_mapi (a: int) (b: int) : int = xs a b |> List.mapi (fun i v -> i * v) |> List.sum
let prop_ls_iteri (a: int) (b: int) : int = let s = ref 0 in xs a b |> List.iteri (fun i v -> s.Value <- s.Value + i * v); s.Value
let prop_ls_sort (a: int) (b: int) : int = xs a b |> List.sort |> List.fold (fun acc v -> acc * 31 + v) 7
let prop_ls_sortDesc (a: int) (b: int) : int = xs a b |> List.sortDescending |> List.fold (fun acc v -> acc * 31 + v) 7
let prop_ls_sortBy (a: int) (b: int) : int = xs a b |> List.sortBy (fun v -> -v) |> List.fold (fun acc v -> acc * 31 + v) 7
let prop_ls_max (a: int) (b: int) : int = List.max (xs a b)
let prop_ls_min (a: int) (b: int) : int = List.min (xs a b)
let prop_ls_take (a: int) (b: int) (n: int) : int = xs a b |> List.take (n % 8) |> List.sum
let prop_ls_skip (a: int) (b: int) (n: int) : int = xs a b |> List.skip (n % 8) |> List.sum
let prop_ls_distinct (a: int) (b: int) : int = [ a; b; a; b; a + b ] |> List.distinct |> List.length
let prop_ls_partition (a: int) (b: int) : int = let (p, q) = xs a b |> List.partition (fun v -> v > 0) in p.Length * 10 + q.Length
let prop_ls_init (a: int) : int = List.init (abs (a % 16)) (fun i -> i * i) |> List.sum
let prop_ls_replicate (a: int) (b: int) : int = List.replicate (abs (a % 16)) b |> List.sum
let prop_ls_eq (a: int) (b: int) : bool = xs a b = xs a b
let prop_ls_ne (a: int) (b: int) : bool = xs a b <> xs b a
let prop_ls_compare (a: int) (b: int) : int = sign (compare (xs a b) (xs b a))
let prop_ls_pairwise (a: int) (b: int) : int = xs a b |> List.pairwise |> List.sumBy (fun (x, y) -> x - y)
let prop_ls_windowed (a: int) (b: int) : int = xs a b |> List.windowed 3 |> List.length
let prop_ls_rangeSum (a: int) : int = [ 0 .. abs (a % 50) ] |> List.sum
let prop_ls_comprehension (a: int) : int = [ for i in 0 .. abs (a % 20) do if i % 2 = 0 then yield i * i ] |> List.sum

// ── arrays ──────────────────────────────────────────────────────────────────────────────────────
let prop_a_length (a: int) (b: int) : int = (arr a b).Length
let prop_a_sum (a: int) (b: int) : int = Array.sum (arr a b)
let prop_a_map (a: int) (b: int) : int = arr a b |> Array.map (fun v -> v * 3 + 1) |> Array.sum
let prop_a_filter (a: int) (b: int) : int = arr a b |> Array.filter (fun v -> v > 0) |> Array.length
let prop_a_fold (a: int) (b: int) : int = arr a b |> Array.fold (fun acc v -> acc * 31 + v) 7
let prop_a_foldBack (a: int) (b: int) : int = Array.foldBack (fun v acc -> acc * 31 + v) (arr a b) 7
let prop_a_rev (a: int) (b: int) : int = arr a b |> Array.rev |> Array.fold (fun acc v -> acc * 31 + v) 7
let prop_a_get (a: int) (b: int) (i: int) : int = (arr a b).[i % 8]
let prop_a_set (a: int) (b: int) : int = let x = arr a b in x.[2] <- a * 7; Array.sum x
let prop_a_copy (a: int) (b: int) : int = let x = arr a b in let y = Array.copy x in y.[0] <- 99; x.[0] + y.[0]
let prop_a_append (a: int) (b: int) : int = Array.append (arr a b) (arr b a) |> Array.fold (fun acc v -> acc * 31 + v) 7
let prop_a_sort (a: int) (b: int) : int = arr a b |> Array.sort |> Array.fold (fun acc v -> acc * 31 + v) 7
let prop_a_sortBy (a: int) (b: int) : int = arr a b |> Array.sortBy (fun v -> -v) |> Array.fold (fun acc v -> acc * 31 + v) 7
let prop_a_sortInPlace (a: int) (b: int) : int = let x = arr a b in Array.sortInPlace x; x.[0] * 3 + x.[5]
let prop_a_max (a: int) (b: int) : int = Array.max (arr a b)
let prop_a_min (a: int) (b: int) : int = Array.min (arr a b)
let prop_a_exists (a: int) (b: int) : bool = arr a b |> Array.exists (fun v -> v = a)
let prop_a_forall (a: int) (b: int) : bool = arr a b |> Array.forall (fun v -> v >= b)
let prop_a_contains (a: int) (b: int) : bool = Array.contains (a + b) (arr a b)
let prop_a_tryFindIndex (a: int) (b: int) : int = arr a b |> Array.tryFindIndex (fun v -> v > b) |> Option.defaultValue -1
let prop_a_choose (a: int) (b: int) : int = arr a b |> Array.choose (fun v -> if v % 2 = 0 then Some(v / 2) else None) |> Array.sum
let prop_a_collect (a: int) (b: int) : int = arr a b |> Array.collect (fun v -> [| v; v + 1 |]) |> Array.length
let prop_a_zip (a: int) (b: int) : int = Array.zip (arr a b) (arr b a) |> Array.sumBy (fun (x, y) -> x * y)
let prop_a_mapi (a: int) (b: int) : int = arr a b |> Array.mapi (fun i v -> i * v) |> Array.sum
let prop_a_init (a: int) : int = Array.init (abs (a % 16)) (fun i -> i * i) |> Array.sum
let prop_a_create (a: int) (b: int) : int = Array.create (abs (a % 16)) b |> Array.sum
let prop_a_zeroCreate (a: int) : int = (Array.zeroCreate<int> (abs (a % 16))) |> Array.sum
let prop_a_sub (a: int) (b: int) (i: int) : int = Array.sub (arr a b) (abs (i % 3)) 3 |> Array.sum
let prop_a_eq (a: int) (b: int) : bool = arr a b = arr a b
let prop_a_ofList (a: int) (b: int) : int = xs a b |> Array.ofList |> Array.sum
let prop_a_toList (a: int) (b: int) : int = arr a b |> Array.toList |> List.fold (fun acc v -> acc * 31 + v) 7
let prop_a_loop (a: int) (b: int) : int =
    let x = arr a b
    let mutable s = 0
    for i in 0 .. x.Length - 1 do s <- s + x.[i] * (i + 1)
    s
let prop_a_float (a: float) (b: float) : float = [| a; b; a + b |] |> Array.sum
let prop_a_floatMax (a: float) (b: float) : float = [| a; b; a * b |] |> Array.max

// ── closures and higher-order functions ─────────────────────────────────────────────────────────
let private adder (n: int) : int -> int = fun x -> x + n
let private twice (f: int -> int) (x: int) : int = f (f x)
let private compose (f: int -> int) (g: int -> int) : int -> int = fun x -> g (f x)
let private curried (a: int) (b: int) (c: int) : int = a * 100 + b * 10 + c

let prop_c_adder (a: int) (b: int) : int = adder a b
let prop_c_twice (a: int) (b: int) : int = twice (adder a) b
let prop_c_compose (a: int) (b: int) : int = compose (adder a) (fun x -> x * 2) b
let prop_c_captureMutable (a: int) (b: int) : int =
    let r = ref a
    let f () = r.Value <- r.Value + b
    f (); f ()
    r.Value
let prop_c_partial2 (a: int) (b: int) (c: int) : int = let f = curried a in f b c
let prop_c_partial1 (a: int) (b: int) (c: int) : int = let f = curried a b in f c
let prop_c_partialMap (a: int) (b: int) : int = [ 1; 2; 3 ] |> List.map (curried a b) |> List.sum
let prop_c_pipeline (a: int) (b: int) : int = a |> adder b |> (fun x -> x * 2) |> adder 1
let prop_c_composeOp (a: int) (b: int) : int = ((adder a) >> (fun x -> x * 3) >> (adder b)) 5
let prop_c_composeBack (a: int) (b: int) : int = ((adder a) << (fun x -> x * 3)) b
let prop_c_listOfClosures (a: int) (b: int) : int = [ adder a; adder b; (fun x -> x * 2) ] |> List.fold (fun acc f -> f acc) 1
let prop_c_closureInRecord (a: int) (b: int) : int = let r = {| f = adder a; g = adder b |} in r.f (r.g 1)
let prop_c_rec (a: int) : int =
    let rec fact n = if n <= 1 then 1 else n * fact (n - 1)
    fact (abs (a % 12))
let prop_c_mutualRec (a: int) : bool =
    let rec isEven n = if n = 0 then true else isOdd (n - 1)
    and isOdd n = if n = 0 then false else isEven (n - 1)
    isEven (abs (a % 100))
let prop_c_inner (a: int) (b: int) : int =
    let k = a * 2
    let f x = x + k
    let g x = f x + b
    g 1
let prop_c_ignore (a: int) : int = ignore (a + 1); a
let prop_c_ifThenElseClosure (a: int) (b: int) : int = (if a > b then adder a else adder b) 10
let prop_c_matchClosure (a: int) (b: int) : int =
    let f = match a % 3 with 0 -> adder 1 | 1 -> (fun x -> x * 2) | _ -> twice (adder b)
    f 7

// ── sorting at sizes that exercise the merge passes (stability, odd lengths, many duplicates) ───
let private many (a: int) (b: int) (n: int) : int list = [ for i in 0 .. n - 1 -> (a * i + b * i * i) % 17 ]
let private checksum (xs: int list) : int = xs |> List.fold (fun acc v -> acc * 31 + v) 7
let private checksumA (xs: int[]) : int = xs |> Array.fold (fun acc v -> acc * 31 + v) 7
let prop_ls_sortBig (a: int) (b: int) (n: int) : int = many a b (abs (n % 60)) |> List.sort |> checksum
let prop_ls_sortDescBig (a: int) (b: int) (n: int) : int = many a b (abs (n % 60)) |> List.sortDescending |> checksum
let prop_ls_sortWithBig (a: int) (b: int) (n: int) : int = many a b (abs (n % 60)) |> List.sortWith (fun x y -> compare (y % 5) (x % 5)) |> checksum
let prop_ls_sortByStable (a: int) (b: int) (n: int) : int =
    many a b (abs (n % 60)) |> List.mapi (fun i v -> (v % 5, i)) |> List.sortBy fst |> List.map snd |> checksum
let prop_a_sortBig (a: int) (b: int) (n: int) : int = many a b (abs (n % 60)) |> Array.ofList |> Array.sort |> checksumA
let prop_a_sortDescBig (a: int) (b: int) (n: int) : int = many a b (abs (n % 60)) |> Array.ofList |> Array.sortDescending |> checksumA
let prop_a_sortWithBig (a: int) (b: int) (n: int) : int =
    many a b (abs (n % 60)) |> Array.ofList |> Array.sortWith (fun x y -> compare (y % 5, y) (x % 5, x)) |> checksumA   // total order: .NET's array sort is not stable
let prop_a_sortByInjective (a: int) (b: int) (n: int) : int =
    many a b (abs (n % 60)) |> List.mapi (fun i v -> v * 100 + i) |> Array.ofList |> Array.sortBy (fun v -> -v) |> checksumA
let prop_a_sortInPlaceBig (a: int) (b: int) (n: int) : int =
    let x = many a b (abs (n % 60)) |> Array.ofList
    Array.sortInPlace x
    checksumA x
let prop_ls_sortStrings (a: int) (n: int) : int =
    many a 3 (abs (n % 40)) |> List.map (fun v -> string (v * 7919 % 1000)) |> List.sort |> List.sumBy (fun s -> s.Length * 31 + int s.[0])

// ── fused pipelines: the same answers as the stage-by-stage evaluation ──────────────────────────
let prop_f_mapFilterSum (a: int) (n: int) : int = [ 1 .. abs (n % 40) ] |> List.map (fun v -> v * a) |> List.filter (fun v -> v % 3 = 0) |> List.sum
let prop_f_mapFold (a: int) (n: int) : int = [ 0 .. abs (n % 40) ] |> List.map (fun v -> v + a) |> List.fold (fun s v -> s * 31 + v) 7
let prop_f_filterLength (a: int) (n: int) : int = [ a .. a + abs (n % 40) ] |> List.filter (fun v -> v % 2 = 0) |> List.length
let prop_f_sumBy (a: int) (n: int) : int = [ 1 .. abs (n % 40) ] |> List.map (fun v -> v + a) |> List.sumBy (fun v -> v % 7)
let prop_f_toArray (a: int) (n: int) : int = [ 1 .. abs (n % 40) ] |> List.map (fun v -> v * a) |> Array.ofList |> Array.fold (fun s v -> s * 31 + v) 7
let prop_f_arrayChain (a: int) (n: int) : int =
    Array.init (abs (n % 40)) (fun i -> i * a) |> Array.map (fun v -> v + 1) |> Array.filter (fun v -> v % 2 = 0) |> Array.sum
let prop_f_listInit (a: int) (n: int) : int = List.init (abs (n % 40)) (fun i -> i * a) |> List.map (fun v -> v ^^^ a) |> List.sum
let prop_f_arrayToList (a: int) (n: int) : int =
    Array.init (abs (n % 40)) (fun i -> i + a) |> Array.map (fun v -> v * 2) |> Array.toList |> List.fold (fun s v -> s * 31 + v) 7
let prop_f_empty (a: int) : int = [ 1 .. 0 ] |> List.map (fun v -> v * a) |> List.sum
let prop_f_reverseRange (a: int) (n: int) : int = [ 10 .. -1 .. (abs (n % 10)) ] |> List.map (fun v -> v - a) |> List.fold (fun s v -> s * 31 + v) 7
let prop_f_steps (a: int) (n: int) : int = [ 0 .. 3 .. abs (n % 100) ] |> List.filter (fun v -> v > a % 50) |> List.length
let prop_f_tupleStage (a: int) (n: int) : int =
    [ 1 .. abs (n % 30) ] |> List.map (fun v -> (v, v * a)) |> List.filter (fun (x, _) -> x % 2 = 1) |> List.sumBy (fun (x, y) -> x + y)
let prop_f_stringStage (a: int) (n: int) : int = [ 1 .. abs (n % 30) ] |> List.map (fun v -> string (v * a)) |> List.sumBy (fun s -> s.Length)
let prop_f_overflowSum (a: int) : int = [ 1 .. 3 ] |> List.map (fun v -> v * a) |> List.sum        // Checked.(+): raises on overflow
let prop_f_nested (a: int) (n: int) : int =
    [ 1 .. abs (n % 10) ] |> List.map (fun i -> [ 1 .. i ] |> List.map (fun j -> j * a) |> List.sum) |> List.sum
let prop_f_impureStage (a: int) (n: int) : int =
    let log = ref 0
    let r = [ 1 .. abs (n % 10) ] |> List.map (fun v -> log.Value <- log.Value * 31 + v; v + a) |> List.map (fun v -> log.Value <- log.Value * 17 + v; v) |> List.sum
    r + log.Value                                   // not fused: the stage runs completely before the next one (strict lists)
