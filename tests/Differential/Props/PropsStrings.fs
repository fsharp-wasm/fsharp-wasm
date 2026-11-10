/// String properties.  Strings are built from ints so the generated inputs reach them; results are ints / bools.
/// Same rules as Props.fs: total functions (raising is fine, both sides must then fail).
module PropsStrings

open System

let private letter (n: int) : char = char (97 + ((n % 26) + 26) % 26)

/// A deterministic word of 0..11 letters derived from two ints.
let private word (seed: int) (len: int) : string =
    let n = ((len % 12) + 12) % 12
    let mutable s = ""
    for i in 0 .. n - 1 do
        s <- s + string (letter (seed + i * 7))
    s

let private idx (b: int) (n: int) = if n = 0 then 0 else ((b % n) + n) % n

let prop_s_len (a: int) (b: int) : int = (word a b).Length
let prop_s_concat (a: int) (b: int) : int = (word a 5 + word b 3).Length
let prop_s_eq (a: int) (b: int) : bool = word a 5 = word b 5
let prop_s_ne (a: int) (b: int) : bool = word a 3 <> word b 3
let prop_s_compare (a: int) (b: int) : int = sign (compare (word a 4) (word b 4))
let prop_s_lt (a: int) (b: int) : bool = word a 4 < word b 4
let prop_s_isEmpty (a: int) (b: int) : bool = String.IsNullOrEmpty(word a b)
let prop_s_charAt (a: int) (b: int) : int = let w = word a 8 in int w.[idx b w.Length]
let prop_s_substring (a: int) (b: int) : int = let w = word a 10 in (w.Substring(idx b w.Length)).Length
let prop_s_substring2 (a: int) (b: int) : int = let w = word a 10 in (w.Substring(idx b 5, idx a 5)).Length
let prop_s_indexOf (a: int) (b: int) : int = (word a 10).IndexOf(letter b)
let prop_s_lastIndexOf (a: int) (b: int) : int = (word a 10).LastIndexOf(letter b)
let prop_s_contains (a: int) (b: int) : bool = (word a 10).Contains(string (letter b))
let prop_s_startsWith (a: int) (b: int) : bool = (word a 10).StartsWith(string (letter b))
let prop_s_endsWith (a: int) (b: int) : bool = (word a 10).EndsWith(string (letter b))
let prop_s_toUpper (a: int) (b: int) : int = let w = (word a 6).ToUpper() in if w.Length = 0 then -1 else int w.[0]
let prop_s_toLower (a: int) (b: int) : int = let w = (word a 6).ToUpper().ToLower() in if w.Length = 0 then -1 else int w.[0]
let prop_s_replace (a: int) (b: int) : int = (word a 8).Replace(string (letter b), "xy").Length
let prop_s_trim (a: int) (b: int) : int = ("  " + word a 4 + "  ").Trim().Length
let prop_s_trimStart (a: int) (b: int) : int = ("  " + word a 4).TrimStart().Length
let prop_s_trimEnd (a: int) (b: int) : int = (word a 4 + "  ").TrimEnd().Length
let prop_s_split (a: int) (b: int) : int = (word a 10).Split(letter b).Length
let prop_s_padLeft (a: int) (b: int) : int = (word a 4).PadLeft(idx b 12).Length
let prop_s_padRight (a: int) (b: int) : int = (word a 4).PadRight(idx b 12).Length
let prop_s_intToString (a: int) : int = (string a).Length
let prop_s_intRoundTrip (a: int) : int = int (string a)
let prop_s_parse (a: int) : int = Int32.Parse(string a)
let prop_s_sprintfD (a: int) (b: int) : int = (sprintf "%d-%s" a (word b 3)).Length
let prop_s_sprintfX (a: int) : int = (sprintf "%x" a).Length
let prop_s_concatMany (a: int) (b: int) : int = String.concat "," [ word a 2; word b 3; word (a + b) 4 ] |> fun s -> s.Length
let prop_s_replicate (a: int) (b: int) : int = (String.replicate (idx a 6) (word b 2)).Length
let prop_s_char (a: int) : int = int (char (abs (a % 1000)))
let prop_s_charIsDigit (a: int) : bool = Char.IsDigit(char (abs (a % 128)))
let prop_s_charIsLetter (a: int) : bool = Char.IsLetter(char (abs (a % 128)))
let prop_s_charToUpper (a: int) : int = int (Char.ToUpper(char (abs (a % 128))))
