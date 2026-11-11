/// Generic functions and types instantiated at several types (ints, floats, strings, records, tuples, lists).
/// Same rules as Props.fs; results are ints / floats / bools.
module PropsGenerics

type Box<'T> = { Value: 'T }
type Pair<'A, 'B> = { First: 'A; Second: 'B }
type Opt<'T> =
    | No
    | Yes of 'T
type P = { X: int; Y: string }

let identityGen (x: 'a) : 'a = x
let swapGen (a: 'a, b: 'b) : 'b * 'a = (b, a)
let mapPairGen (f: 'a -> 'b) (a: 'a, b: 'a) : 'b * 'b = (f a, f b)
let rec lengthGen (xs: 'a list) : int = match xs with [] -> 0 | _ :: t -> 1 + lengthGen t
let rec foldGen (f: 's -> 'a -> 's) (s: 's) (xs: 'a list) : 's = match xs with [] -> s | h :: t -> foldGen f (f s h) t
let applyGen (f: 'a -> 'b) (x: 'a) : 'b = f x
let twiceGen (f: 'a -> 'a) (x: 'a) : 'a = f (f x)
let composeGen (f: 'b -> 'c) (g: 'a -> 'b) : 'a -> 'c = fun x -> f (g x)
let firstOrGen (d: 'a) (xs: 'a list) : 'a = match xs with [] -> d | h :: _ -> h
let maxByGen (f: 'a -> int) (a: 'a) (b: 'a) : 'a = if f a >= f b then a else b
let unwrapGen (d: 'a) (o: Opt<'a>) : 'a = match o with No -> d | Yes v -> v
let mapOptGen (f: 'a -> 'b) (o: Opt<'a>) : Opt<'b> = match o with No -> No | Yes v -> Yes(f v)

// ── generic functions at int / float / string / bool ────────────────────────────────────────────
let prop_g_idInt (a: int) : int = identityGen a
let prop_g_idFloat (a: float) : float = identityGen a
let prop_g_idBool (a: bool) : bool = identityGen a
let prop_g_idStr (a: int) : int = (identityGen (string a)).Length
let prop_g_idTuple (a: int) (b: int) : int = let (x, y) = identityGen (a, b) in x - y
let prop_g_idList (a: int) : int = identityGen [ a; a + 1 ] |> List.sum
let prop_g_swapIntStr (a: int) : int = let (s, i) = swapGen (a, string a) in s.Length + i
let prop_g_swapFloatInt (a: float) (b: int) : float = let (i, f) = swapGen (a, b) in float i + f
let prop_g_mapPairInt (a: int) (b: int) : int = let (x, y) = mapPairGen (fun v -> v * 2) (a, b) in x - y
let prop_g_mapPairToStr (a: int) (b: int) : int = let (x, y) = mapPairGen string (a, b) in x.Length + y.Length
let prop_g_mapPairFloat (a: float) (b: float) : float = let (x, y) = mapPairGen (fun v -> v / 2.0) (a, b) in x + y
let prop_g_lenInt (a: int) : int = lengthGen [ a; a; a ]
let prop_g_lenStr (a: int) : int = lengthGen [ "x"; string a ]
let prop_g_lenFloat (a: float) : int = lengthGen [ a ]
let prop_g_foldIntInt (a: int) (b: int) : int = foldGen (fun s v -> s * 31 + v) 7 [ a; b; a + b ]
let prop_g_foldFloat (a: float) (b: float) : float = foldGen (fun s v -> s + v * 0.5) 0.0 [ a; b ]
let prop_g_foldStrLen (a: int) : int = foldGen (fun s (v: string) -> s + v.Length) 0 [ string a; "ab" ]
let prop_g_foldToStr (a: int) (b: int) : int = (foldGen (fun (s: string) v -> s + string v) "" [ a; b ]).Length
let prop_g_apply (a: int) : int = applyGen (fun v -> v + 1) a
let prop_g_applyFloat (a: float) : float = applyGen (fun v -> v * 2.0) a
let prop_g_applyStr (a: int) : int = applyGen (fun (s: string) -> s.Length) (string a)
let prop_g_twiceInt (a: int) : int = twiceGen (fun v -> v * 3) a
let prop_g_twiceFloat (a: float) : float = twiceGen (fun v -> v + 0.25) a
let prop_g_twiceStr (a: int) : int = (twiceGen (fun (s: string) -> s + "ab") (string a)).Length
let prop_g_compose (a: int) : int = (composeGen (fun v -> v * 2) (fun v -> v + 1)) a
let prop_g_composeMixed (a: int) : int = (composeGen (fun (s: string) -> s.Length) string) a
let prop_g_firstOrInt (a: int) : int = firstOrGen -1 (if a > 0 then [ a ] else [])
let prop_g_firstOrStr (a: int) : int = (firstOrGen "none" (if a > 0 then [ string a ] else [])).Length
let prop_g_firstOrFloat (a: float) : float = firstOrGen nan (if a > 0.0 then [ a ] else [])
let prop_g_maxByInt (a: int) (b: int) : int = maxByGen (fun v -> v) a b
let prop_g_maxByStr (a: int) (b: int) : int = (maxByGen (fun (s: string) -> s.Length) (string a) (string b)).Length
let prop_g_maxByTuple (a: int) (b: int) : int = let (x, y) = maxByGen (fun (p, _) -> p) (a, 1) (b, 2) in x + y

// ── generic records / unions ────────────────────────────────────────────────────────────────────
let prop_g_boxInt (a: int) : int = ({ Value = a }: Box<int>).Value
let prop_g_boxFloat (a: float) : float = ({ Value = a }: Box<float>).Value
let prop_g_boxStr (a: int) : int = ({ Value = string a }: Box<string>).Value.Length
let prop_g_boxBox (a: int) : int = ({ Value = { Value = a } }: Box<Box<int>>).Value.Value
let prop_g_boxEq (a: int) (b: int) : bool = ({ Value = a }: Box<int>) = { Value = b }
let prop_g_boxEqStr (a: int) (b: int) : bool = ({ Value = string a }: Box<string>) = { Value = string b }
let prop_g_boxCompare (a: int) (b: int) : int = sign (compare ({ Value = a }: Box<int>) { Value = b })
let prop_g_pairIntStr (a: int) (b: int) : int = let p = { First = a; Second = string b } in p.First + p.Second.Length
let prop_g_pairFloatInt (a: float) (b: int) : float = let p = { First = a; Second = b } in p.First + float p.Second
let prop_g_pairEq (a: int) (b: int) : bool = { First = a; Second = "x" } = { First = b; Second = "x" }
let prop_g_pairUpdate (a: int) (b: int) : int = let p = { First = a; Second = b } in ({ p with Second = a }).Second - p.Second
let prop_g_optInt (a: int) : int = unwrapGen -1 (if a > 0 then Yes a else No)
let prop_g_optStr (a: int) : int = (unwrapGen "none" (if a > 0 then Yes(string a) else No)).Length
let prop_g_optFloat (a: float) : float = unwrapGen nan (if a > 0.0 then Yes a else No)
let prop_g_optMap (a: int) : int = unwrapGen -1 (mapOptGen (fun v -> v * 2) (if a > 0 then Yes a else No))
let prop_g_optMapStr (a: int) : int = unwrapGen -1 (mapOptGen (fun (s: string) -> s.Length) (if a > 0 then Yes(string a) else No))
let prop_g_optEq (a: int) (b: int) : bool = (if a > 0 then Yes a else No) = (if b > 0 then Yes b else No)
let prop_g_optRecord (a: int) : int = unwrapGen { X = -1; Y = "" } (if a > 0 then Yes { X = a; Y = "y" } else No) |> fun p -> p.X + p.Y.Length

// ── generic helpers over the standard collections ───────────────────────────────────────────────
let private mapAllGen (f: 'a -> 'b) (xs: 'a list) : 'b list = List.map f xs
let prop_g_mapAllInt (a: int) : int = mapAllGen (fun v -> v + 1) [ a; a ] |> List.sum
let prop_g_mapAllStr (a: int) : int = mapAllGen string [ a; a + 1 ] |> List.sumBy (fun (s: string) -> s.Length)
let prop_g_mapAllTuple (a: int) : int = mapAllGen (fun v -> (v, v * 2)) [ a; a + 1 ] |> List.sumBy (fun (x, y) -> x + y)
let prop_g_arrayGeneric (a: int) : int = Array.map (fun v -> (v, string v)) [| a; a + 1 |] |> Array.sumBy (fun (x, s) -> x + s.Length)
let prop_g_optionGeneric (a: int) : int = Some(string a) |> Option.map (fun (s: string) -> s.Length) |> Option.defaultValue 0
let prop_g_listOfLists (a: int) : int = [ [ a ]; [ a; a ] ] |> List.collect id |> List.sum
let prop_g_listOfTuples (a: int) : int = [ (a, "x"); (a + 1, "yy") ] |> List.sumBy (fun (n, s) -> n + s.Length)
let prop_g_listOfRecords (a: int) : int = [ { X = a; Y = "p" }; { X = a + 1; Y = "qq" } ] |> List.sumBy (fun p -> p.X + p.Y.Length)
