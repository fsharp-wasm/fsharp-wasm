/// Properties for the differential test (tests/Differential).
///
/// Rules: every function is named `prop_*`, takes only int / float / bool and returns int / float / bool.
/// It must be total and terminating for ALL inputs (the reference cannot recover from a stack overflow).
/// Raising is fine: .NET exception and wasm trap count as agreement; only one side failing does not.
/// Names ending in `_approx` compare floats with a relative tolerance (transcendental functions).
module Props

// ── int arithmetic: wrap-around, division, remainder ────────────────────────────────────────────
let prop_add (a: int) (b: int) : int = a + b
let prop_sub (a: int) (b: int) : int = a - b
let prop_mul (a: int) (b: int) : int = a * b
let prop_neg (a: int) : int = -a
let prop_div (a: int) (b: int) : int = a / b
let prop_rem (a: int) (b: int) : int = a % b
let prop_divRem (a: int) (b: int) : int = (a / b) * b + (a % b)      // == a whenever it does not fail
let prop_abs (a: int) : int = abs a
let prop_sign (a: int) : int = sign a
let prop_min (a: int) (b: int) : int = min a b
let prop_max (a: int) (b: int) : int = max a b
let prop_clamp (lo: int) (hi: int) (v: int) : int = max lo (min hi v)
let prop_compare (a: int) (b: int) : int = compare a b
let prop_lt (a: int) (b: int) : bool = a < b
let prop_eq (a: int) (b: int) : bool = a = b
let prop_ge (a: int) (b: int) : bool = a >= b

// ── bit operations ──────────────────────────────────────────────────────────────────────────────
let prop_and (a: int) (b: int) : int = a &&& b
let prop_or (a: int) (b: int) : int = a ||| b
let prop_xor (a: int) (b: int) : int = a ^^^ b
let prop_not (a: int) : int = ~~~a
let prop_shl (a: int) (n: int) : int = a <<< n          // count is taken modulo 32
let prop_shr (a: int) (n: int) : int = a >>> n          // arithmetic shift
let prop_rotl (a: int) (n: int) : int = (a <<< n) ||| int ((uint32 a) >>> (32 - (n &&& 31)))
let prop_popcount (a: int) : int =
    let mutable x = uint32 a
    let mutable c = 0
    while x <> 0u do
        c <- c + int (x &&& 1u)
        x <- x >>> 1
    c

// ── narrowing and unsigned conversions ──────────────────────────────────────────────────────────
let prop_byte (a: int) : int = int (byte a)
let prop_sbyte (a: int) : int = int (sbyte a)
let prop_uint16 (a: int) : int = int (uint16 a)
let prop_int16 (a: int) : int = int (int16 a)
let prop_uint32 (a: int) : int = int (uint32 a)
let prop_uintDiv (a: int) (b: int) : int = if b = 0 then 0 else int ((uint32 a) / (uint32 b))
let prop_uintLt (a: int) (b: int) : bool = (uint32 a) < (uint32 b)

// ── small and unsigned integer arithmetic ───────────────────────────────────────────────────────
let prop_byteAdd (a: int) (b: int) : int = int (byte a + byte b)          // wraps at 256
let prop_byteMul (a: int) (b: int) : int = int (byte a * byte b)
let prop_uint16Sub (a: int) (b: int) : int = int (uint16 a - uint16 b)    // wraps at 65536
let prop_uintRem (a: int) (b: int) : int = if b = 0 then 0 else int ((uint32 a) % (uint32 b))
let prop_uintShr (a: int) (n: int) : int = int ((uint32 a) >>> n)
let prop_uintGe (a: int) (b: int) : bool = (uint32 a) >= (uint32 b)
let prop_uintMax (a: int) (b: int) : int = int (max (uint32 a) (uint32 b))
let prop_uintToFloat (a: int) : float = float (uint32 a)
let prop_uintStrLen (a: int) : int = (string (uint32 a)).Length
