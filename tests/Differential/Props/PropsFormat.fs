/// Text formatting: printf flags / width / precision, `string` of every primitive, float printing.  The produced text is
/// hashed, so a single wrong character shows.  Same rules as Props.fs.
module PropsFormat

let private hf (s: string) : int =
    let mutable h = 17
    for i in 0 .. s.Length - 1 do
        h <- h * 31 + int s.[i]
    h

let private flt (a: int) (b: int) : float = float a / (float (abs b % 1000) + 1.0)

// ── integers ────────────────────────────────────────────────────────────────────────────────────
let prop_fm_d (a: int) : int = hf (sprintf "%d" a)
let prop_fm_d5 (a: int) : int = hf (sprintf "%5d|" a)
let prop_fm_dLeft (a: int) : int = hf (sprintf "%-5d|" a)
let prop_fm_d05 (a: int) : int = hf (sprintf "%05d" a)
let prop_fm_dPlus (a: int) : int = hf (sprintf "%+d" a)
let prop_fm_dSpace (a: int) : int = hf (sprintf "% d" a)
let prop_fm_x (a: int) : int = hf (sprintf "%x" a)
let prop_fm_X8 (a: int) : int = hf (sprintf "%08X" a)
let prop_fm_o (a: int) : int = hf (sprintf "%o" a)
let prop_fm_b (a: int) : int = hf (sprintf "%b" (a % 2 = 0))
let prop_fm_i (a: int) : int = hf (sprintf "%i" a)
let prop_fm_int64 (a: int) (b: int) : int = hf (sprintf "%d" (int64 a * int64 b))
let prop_fm_int64w (a: int) (b: int) : int = hf (sprintf "%12d|" (int64 a * int64 b))
let prop_fm_uint (a: int) : int = hf (sprintf "%d" (uint32 a))
let prop_fm_byte (a: int) : int = hf (sprintf "%d" (byte a))
let prop_fm_sbyte (a: int) : int = hf (sprintf "%d" (sbyte a))
let prop_fm_int16 (a: int) : int = hf (sprintf "%d" (int16 a))
let prop_fm_uint16 (a: int) : int = hf (sprintf "%d" (uint16 a))

// ── floats ──────────────────────────────────────────────────────────────────────────────────────
let prop_fm_f (a: int) (b: int) : int = hf (sprintf "%f" (flt a b))
let prop_fm_f0 (a: int) (b: int) : int = hf (sprintf "%.0f" (flt a b))
let prop_fm_f1 (a: int) (b: int) : int = hf (sprintf "%.1f" (flt a b))
let prop_fm_f3 (a: int) (b: int) : int = hf (sprintf "%.3f" (flt a b))
let prop_fm_f10 (a: int) (b: int) : int = hf (sprintf "%.10f" (flt a b))
let prop_fm_f8w (a: int) (b: int) : int = hf (sprintf "%8.2f|" (flt a b))
let prop_fm_fLeft (a: int) (b: int) : int = hf (sprintf "%-8.2f|" (flt a b))
let prop_fm_fPlus (a: int) (b: int) : int = hf (sprintf "%+.2f" (flt a b))
let prop_fm_f08 (a: int) (b: int) : int = hf (sprintf "%08.2f" (flt a b))
let prop_fm_fSpecial (a: int) : int = hf (sprintf "%f %f %f" nan infinity -infinity) + a * 0
let prop_fm_floatStr (a: int) (b: int) : int = hf (string (flt a b))
let prop_fm_floatStrInt (a: int) : int = hf (string (float a))
let prop_fm_floatStrSmall (a: int) : int = hf (string (float a / 1000000.0))
let prop_fm_floatStrBig (a: int) : int = hf (string (float a * 1000000.0))
let prop_fm_floatToString (a: int) (b: int) : int = hf ((flt a b).ToString())
let prop_fm_float32 (a: int) (b: int) : int = hf (string (float32 (flt a b)))
let prop_fm_floatNeg0 (a: int) : int = hf (string (-0.0 * float (abs a))) + 0
let prop_fm_floatSpecial (a: int) : int = hf (string nan + string infinity + string -infinity) + a * 0
let prop_fm_floatRound (a: int) (b: int) : int = hf (string (System.Math.Round(flt a b, 2)))

// ── other types ─────────────────────────────────────────────────────────────────────────────────
let prop_fm_bool (a: int) : int = hf (string (a % 2 = 0))
let prop_fm_char (a: int) : int = hf (string (char (32 + abs (a % 90))))
let prop_fm_s (a: int) : int = hf (sprintf "%s|%5s|%-5s|" (string a) (string (abs a % 100)) (string (abs a % 10)))
let prop_fm_c (a: int) : int = hf (sprintf "%c%c" (char (65 + abs (a % 26))) (char (97 + abs (a % 26))))
let prop_fm_percent (a: int) : int = hf (sprintf "100%% %d" a)
let prop_fm_multi (a: int) (b: int) : int = hf (sprintf "%d,%d,%s,%b,%.1f" a b (string (a + b)) (a > b) (flt a b))
let prop_fm_interp (a: int) (b: int) : int = hf $"a={a} b={b} sum={a + b}"
let prop_fm_concatMixed (a: int) (b: int) : int = hf ("x" + string a + string (a > b) + string (char (65 + abs a % 26)))
let prop_fm_stringJoin (a: int) (b: int) : int = hf (System.String.Join(";", [ a; b; a + b ]))
let prop_fm_stringJoinArr (a: int) (b: int) : int = hf (System.String.Join("-", [| string a; string b |]))
