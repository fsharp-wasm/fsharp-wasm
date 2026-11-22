/// Strings across the host boundary in the Exports ABI: the host reads a string through `__str_len` / `__str_at` and builds one
/// through `__str_new` / `__str_set`.  The module must not import `wasm:js-string` (run.sh checks), so it also runs where modules
/// are precompiled without builtins.
module StringAbi

open Fable.Core

/// The host's length of the string it was given (it reads it through the accessor exports).
[<Import("hostLength", "host")>]
let hostLength (s: string) : int = nativeOnly

/// The host's upper-cased copy of a string (it builds the result through the accessor exports).
[<Import("hostUpper", "host")>]
let hostUpper (s: string) : string = nativeOnly

/// The host's copy of a string, character for character (it reads it and builds the copy through the exports).
[<Import("hostEcho", "host")>]
let hostEcho (s: string) : string = nativeOnly

/// The host's answer for a string it does not know: null / undefined, which arrives as "".
[<Import("hostNothing", "host")>]
let hostNothing () : string = nativeOnly

[<CompiledName("lengthOf")>]
let lengthOf (s: string) : int = hostLength s

/// "äöü ✓ 🚀 abc" through the host and back (upper-cased: the same length, and a surrogate pair in the middle); the result is
/// compared inside the module, so the host only ever sees strings it read or built itself
[<CompiledName("roundTrip")>]
let roundTrip () : int =
    let up = hostUpper "äöü ✓ 🚀 abc"
    (if up = "ÄÖÜ ✓ 🚀 ABC" then 1 else 0) + (if up.Length = 12 then 10 else 0)

[<CompiledName("emptyAndNull")>]
let emptyAndNull () : int =
    (if hostUpper "" = "" then 1 else 0) + (if hostNothing () = "" then 10 else 0) + hostLength ""

[<CompiledName("longString")>]
let longString () : int =
    let sb = System.Text.StringBuilder()
    for i in 0 .. 9999 do sb.Append(char (97 + i % 26)) |> ignore
    hostLength (sb.ToString())

/// A string through the host and back, character for character: lone surrogates, the empty string, and one of 70 000 characters (more than the 32 768 that one page of memory holds,
/// so that a host that moves the string through the module's memory makes it grow).
[<CompiledName("echoes")>]
let echoes () : int =
    let lone = (System.Text.StringBuilder().Append('\uD800').Append('x').Append('\uDC00')).ToString()
    let sb = System.Text.StringBuilder()
    for i in 0 .. 69999 do sb.Append(char (0x20 + (i * 7) % 0xFFE0)) |> ignore
    let big = sb.ToString()
    let back = hostEcho big
    (if hostEcho lone = lone then 1 else 0)
    + (if back = big then 10 else 0)
    + (if hostEcho "" = "" then 100 else 0)
    + (if back.Length = 70000 then 1000 else 0)
