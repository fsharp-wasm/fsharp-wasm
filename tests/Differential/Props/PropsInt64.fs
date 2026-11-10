/// int64 properties.  The harness compares int / float / bool, so each result is narrowed to an int
/// (a low half, a high half, or a remainder).
module PropsInt64

let prop_l_add (a: int) (b: int) : int = int ((int64 a + int64 b) &&& 0xFFFFFFFFL)
let prop_l_addHigh (a: int) (b: int) : int = int ((int64 a + int64 b) >>> 32)
let prop_l_mul (a: int) (b: int) : int = int ((int64 a * int64 b) &&& 0xFFFFFFFFL)
let prop_l_mulHigh (a: int) (b: int) : int = int ((int64 a * int64 b) >>> 32)
let prop_l_wrapMul (a: int) (b: int) : int = int (((int64 a * 4294967296L + int64 b) * 6364136223846793005L) >>> 40)
let prop_l_div (a: int) (b: int) : int = int ((int64 a * 1000003L) / int64 b)
let prop_l_rem (a: int) (b: int) : int = int ((int64 a * 1000003L) % int64 b)
let prop_l_neg (a: int) : int = int ((-(int64 a)) >>> 8)
let prop_l_shl (a: int) (n: int) : int = int ((int64 a <<< n) >>> 16)
let prop_l_shr (a: int) (n: int) : int = int ((int64 a * 65536L) >>> n)
let prop_l_and (a: int) (b: int) : int = int ((int64 a &&& (int64 b <<< 7)) >>> 3)
let prop_l_xor (a: int) (b: int) : int = int ((int64 a ^^^ (int64 b <<< 31)) >>> 20)
let prop_l_lt (a: int) (b: int) : bool = int64 a * 100000L < int64 b * 99999L
let prop_l_eq (a: int) (b: int) : bool = int64 a = int64 b
let prop_l_compare (a: int) (b: int) : int = compare (int64 a * 3000000000L) (int64 b * 3000000000L)
let prop_l_narrow (a: int) (b: int) : int = int (int64 a * int64 b)                  // wraps to 32 bits
let prop_l_toFloat (a: int) (b: int) : float = float (int64 a * int64 b)
let prop_l_ofFloat (a: float) : int = int (int64 a >>> 4)                            // saturating, NaN → 0
let prop_l_abs (a: int) : int = int ((abs (int64 a * 7L)) >>> 4)
let prop_l_min (a: int) (b: int) : int = int ((min (int64 a * 65537L) (int64 b * 65537L)) >>> 8)
let prop_l_max (a: int) (b: int) : int = int ((max (int64 a * 65537L) (int64 b * 65537L)) >>> 8)
let prop_l_strLen (a: int) (b: int) : int = (string (int64 a * int64 b)).Length
let prop_l_uint32Mul (a: int) (b: int) : int = int ((uint64 (uint32 a) * uint64 (uint32 b)) >>> 16)
