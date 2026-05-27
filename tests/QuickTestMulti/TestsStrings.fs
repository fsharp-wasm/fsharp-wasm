module QuickTestWasmGc.TestsStrings

open QuickTestWasmGc.Preamble
open Fable.Core

// ── Strings (83 tests) ───────────────────────────────────────

let testRectWidth (x1: float) (y1: float) (x2: float) (y2: float) : float =
    rectWidth { TopLeft = { X = x1; Y = y1 }; BottomRight = { X = x2; Y = y2 } }

// ─── Phase 4: Discriminated Unions ───────────────────────────────

// Enum-like DU (no fields) — stored as plain i32 tag
type Direction = North | South | East | West

let directionToInt (d: Direction) : int =
    match d with
    | North -> 0
    | South -> 1
    | East -> 2
    | West -> 3

let intToDirection (n: int) : Direction =
    match n with
    | 0 -> North
    | 1 -> South
    | 2 -> East
    | _ -> West

// Data-carrying DU — stored as WasmGC struct subtype hierarchy
type Shape =
    | Circle of float      // radius
    | Square of float      // side
    | Rectangle of float * float  // width, height

/// Area: Circle → r², Square → s², Rectangle → w*h  (no π for simplicity)
let shapeArea (s: Shape) : float =
    match s with
    | Circle r -> r * r
    | Square s -> s * s
    | Rectangle(w, h) -> w * h

/// Perimeter: Circle → 4r (approx, no π), Square → 4s, Rectangle → 2w+2h
let shapePerimeter (s: Shape) : float =
    match s with
    | Circle r -> 4.0 * r
    | Square s -> 4.0 * s
    | Rectangle(w, h) -> 2.0 * w + 2.0 * h

// JS-callable wrappers (WasmGC struct refs can't cross the JS boundary)

let testStringLen () : int = "hello".Length

/// Test: string literal length — empty string

let testEmptyStringLen () : int = "".Length

/// Test: character code at index 1 of "ABC" → 66 (B)

let testStringChar () : int = int "ABC".[1]

/// Test: first character of "xyz" → 120 (x)

let testStringFirstChar () : int = int "xyz".[0]

/// Test: length of a longer string

let testStringLen2 () : int = "fable wasm".Length
// ─── Phase 6b: String concat & equality ──────────────────────────

/// Test: concat length — "foo" + "bar" → 6

let testStringConcatLen () : int = ("foo" + "bar").Length

/// Test: concat then index — ("foo" + "bar").[3] → 'b' = 98

let testStringConcatChar () : int = int ("foo" + "bar").[3]

/// Test: string equality true → 1

let testStringEqTrue () : int = if "hello" = "hello" then 1 else 0

/// Test: string equality false → 0

let testStringEqFalse () : int = if "hello" = "world" then 1 else 0

/// Test: string inequality true → 1

let testStringNeq () : int = if "abc" <> "xyz" then 1 else 0

/// Test: concat of two variables

let testStringConcatVars () : int =
    let a = "hello"
    let b = " world"
    (a + b).Length

// ─── Option combinators ───────────────────────────────────────────


let testRefCell () : int =
    let r = ref 5
    r.Value <- r.Value + 1
    r.Value

/// Test: ref 0, conditionally set to 1, return .Value = 1

let testRefCellBool () : int =
    let r = ref 0
    if 3 > 2 then r.Value <- 1
    r.Value

// ─── Recursive discriminated union (Tree) ──────────────────────────────────

type Tree = Leaf | Node of Tree * Tree * int

let rec treeSum (t: Tree) : int =
    match t with
    | Leaf -> 0
    | Node(l, r, v) -> v + treeSum l + treeSum r

/// Test: Node(Node(Leaf,Leaf,1), Node(Leaf,Leaf,2), 3) → 1+2+3 = 6

let testStringIndexOf () : int =
    "hello world".IndexOf("world")

/// Test: "hello world".IndexOf("xyz") = -1

let testStringIndexOfMiss () : int =
    "hello world".IndexOf("xyz")

/// Test: "abcabc".LastIndexOf("bc") = 4 (last occurrence)

let testStringLastIndexOf () : int =
    "abcabc".LastIndexOf("bc")

/// Test: "abcabc".LastIndexOf("xyz") = -1 (not found)

let testStringLastIndexOfMiss () : int =
    "abcabc".LastIndexOf("xyz")

/// Test: "hello world hello".IndexOf("hello", 5) = 12 (after fromIndex)

let testStringIndexOfFrom () : int =
    "hello world hello".IndexOf("hello", 5)

/// Test: "hello world".StartsWith("hello") = true → 1

let testStringStartsWith () : int =
    if "hello world".StartsWith("hello") then 1 else 0

/// Test: "hello world".StartsWith("world") = false → 0

let testStringStartsWithFalse () : int =
    if "hello world".StartsWith("world") then 1 else 0

/// Test: "hello world".EndsWith("world") = true → 1

let testStringEndsWith () : int =
    if "hello world".EndsWith("world") then 1 else 0

/// Test: "hello world".EndsWith("hello") = false → 0

let testStringEndsWithFalse () : int =
    if "hello world".EndsWith("hello") then 1 else 0

/// Test: "hello world".Substring(6) = "world"; length = 5

let testStringSubstring () : int =
    "hello world".Substring(6).Length

/// Test: "hello world".Substring(6, 3) = "wor"; length = 3

let testStringSubstringLen () : int =
    "hello world".Substring(6, 3).Length

// ── List.findIndex ────────────────────────────────────────────────

/// Test: List.findIndex (fun x -> x > 3) [1;5;2;4] = 1 (index of 5)

let testToLowerLength () : int =
    let s = "Hello".ToLower()
    s.Length

/// Test: "hello".ToUpper() = "HELLO" → first char

let testToUpperFirstChar () : int =
    let s = "hello".ToUpper()
    int s.[0]  // 'H' = 72

/// Test: toLower roundtrip

let testToLowerChars () : int =
    let s = "ABC".ToLower()
    // a=97, b=98, c=99, sum=294
    int s.[0] + int s.[1] + int s.[2]

/// Test: toUpper roundtrip

let testToUpperChars () : int =
    let s = "xyz".ToUpper()
    // X=88, Y=89, Z=90, sum=267
    int s.[0] + int s.[1] + int s.[2]

/// Test: String.trim leading/trailing spaces

let testTrimBasic () : int =
    let s = "  hi  ".Trim()
    s.Length  // "hi" → 2

/// Test: trimStart only

let testTrimStart () : int =
    let s = "  abc".TrimStart()
    s.Length  // "abc" → 3

/// Test: trimEnd only

let testTrimEnd () : int =
    let s = "abc  ".TrimEnd()
    s.Length  // "abc" → 3

/// Test: String.contains "hello" "ell" = true

let testContains () : int =
    if "hello".Contains("ell") then 1 else 0

/// Test: String.contains "hello" "xyz" = false

let testContainsNot () : int =
    if "hello".Contains("xyz") then 1 else 0

/// Test: toLower on mixed string

let testToLowerMixed () : int =
    let s = "HeLLo".ToLower()
    // should equal "hello", first char = 104
    int s.[0]  // 'h' = 104

// ─── Number-to-string + String interpolation ──────────────────────

/// Test: string(42).Length = 2

let testStringOfInt () : int =
    (string 42).Length

/// Test: string(-1).Length = 2

let testStringOfNegInt () : int =
    (string -1).Length

/// Test: string(0).Length = 1

let testStringOfZero () : int =
    (string 0).Length

/// Test: string(123) starts with '1' (= 49)

let testStringOfIntChar () : int =
    int (string 123).[0]  // '1' = 49

/// Test: F# interpolated string $"x={x}" produces correct length

let testPadLeft () : int =
    ("42".PadLeft(5)).Length

/// Test: "42".PadRight(5) → "42   " — length 5

let testPadRight () : int =
    ("42".PadRight(5)).Length

/// Test: "42".PadLeft(1) → "42" (no change needed) — length 2

let testPadLeftNoop () : int =
    ("42".PadLeft(1)).Length

/// Test: "42".PadLeft(4) first char = ' ' (32)

let testPadLeftChar () : int =
    int ("42".PadLeft(4)).[0]  // '  42'[0] = 32

/// Test: "hello world".Replace("world", "F#") — result "hello F#", length 8

let testReplace () : int =
    ("hello world".Replace("world", "F#")).Length

/// Test: "aabbcc".Replace("bb", "") — result "aacc", length 4

let testReplaceRemove () : int =
    ("aabbcc".Replace("bb", "")).Length

/// Test: "abc".Replace("x", "y") — no match, same string, length 3

let testReplaceNoMatch () : int =
    ("abc".Replace("x", "y")).Length

/// Test printfn with string literal (just checking doesn't crash)

let testIsUpper () : int =
    if System.Char.IsUpper('A') then 1 else 0

/// Test: Char.IsLower 'a' = true

let testIsLower () : int =
    if System.Char.IsLower('a') then 1 else 0

/// Test: Char.IsWhiteSpace ' ' = true

let testCharToLower () : int =
    int (System.Char.ToLower('A'))

/// Test: Char.ToUpper 'a' = 'A' (65)

let testCharToUpper () : int =
    int (System.Char.ToUpper('a'))

// ─── Option additional operations ────────────────────────────────

/// Test: Option.defaultValue 99 (Some 42) = 42

let testFloatCompare () : int =
    if 1.5 < 2.5 then 1 else 0

// ─── Sprint 6: Structural Equality ─────────────────────────────────────────────

/// Test: record equality — same values → 1

let testRecordEqTrue () : int =
    let p1 = { X = 1.0; Y = 2.0 }
    let p2 = { X = 1.0; Y = 2.0 }
    if p1 = p2 then 1 else 0

/// Test: record equality — different Y → 0

let testRecordEqFalse () : int =
    let p1 = { X = 1.0; Y = 2.0 }
    let p2 = { X = 1.0; Y = 3.0 }
    if p1 = p2 then 1 else 0

/// Test: record inequality — different Y → 1

let testRecordNeq () : int =
    let p1 = { X = 5.0; Y = 6.0 }
    let p2 = { X = 5.0; Y = 7.0 }
    if p1 <> p2 then 1 else 0

/// Test: DU equality — same enum tag → 1

let testStrSplitLen () : int =
    let parts = "a,b,c".Split([| "," |], System.StringSplitOptions.None)
    parts.Length

/// Test: "a,b,c".Split(",") → first part is "a" → length 1

let testStrSplitFirst () : int =
    let parts = "a,b,c".Split([| "," |], System.StringSplitOptions.None)
    parts.[0].Length

/// Test: "a,b,c".Split(",") → second part "b" → first char = 98 ('b')

let testStrSplitSecond () : int =
    let parts = "a,b,c".Split([| "," |], System.StringSplitOptions.None)
    int parts.[1].[0]

/// Test: "hello world foo".Split(" ") → 3 parts

let testStrSplitWords () : int =
    let parts = "hello world foo".Split([| " " |], System.StringSplitOptions.None)
    parts.Length

/// Test: "no-delim".Split(",") → 1 part (no delimiter found)

let testStrSplitNoDelim () : int =
    let parts = "no-delim".Split([| "," |], System.StringSplitOptions.None)
    parts.Length

/// Test: "".Split(",") → 1 part (empty string gives 1 segment)

let testStrSplitEmpty () : int =
    let parts = "".Split([| "," |], System.StringSplitOptions.None)
    parts.Length

/// Test: split and re-join length — "x::y::z" split by "::" → 3 parts

let testStrSplitMultiChar () : int =
    let parts = "x::y::z".Split([| "::" |], System.StringSplitOptions.None)
    parts.Length

// ── String.Join tests ──────────────────────────────────────────────────────

/// Test: String.Join(", ", [|"hello";"world";"foo"|]) → "hello, world, foo" (length 17)

let testStrJoinLen () : int =
    let parts = [| "hello"; "world"; "foo" |]
    System.String.Join(", ", parts).Length

/// Test: String.Join with empty sep → "helloworld" (length 10)

let testStrJoinNoSep () : int =
    System.String.Join("", [| "hello"; "world" |]).Length

/// Test: String.Join with single element → same as element (length 5)

let testStrJoinOne () : int =
    System.String.Join(",", [| "hello" |]).Length

// ── Int32.Parse tests ──────────────────────────────────────────────────────

/// Test: Int32.Parse("42") = 42

let testStrIsNullOrEmptyTrue () : int =
    if System.String.IsNullOrEmpty("") then 1 else 0

/// Test: String.IsNullOrEmpty "hi" = false (0)

let testStrIsNullOrEmptyFalse () : int =
    if System.String.IsNullOrEmpty("hi") then 1 else 0

/// Test: String.compare "abc" "abc" = 0

let testStrCompareEq () : int =
    System.String.Compare("abc", "abc")

/// Test: String.compare "abc" "abd" < 0 → -1

let testStrCompareLt () : int =
    System.String.Compare("abc", "abd")

/// Test: String.compare "b" "a" > 0 → 1

let testStrCompareGt () : int =
    System.String.Compare("b", "a")

// ── Showcase: Recursion ───────────────────────────────────────────────────

/// Fibonacci (recursive)
let rec fibonacci (n: int) : int =
    if n <= 1 then n else fibonacci (n - 1) + fibonacci (n - 2)

/// Test: fibonacci 10 = 55

let testRefTestCircle () : int =
    let s = GeoShape.GeoCircle 5.0
    match s with
    | GeoShape.GeoCircle r -> int r
    | _ -> 0

/// Test: ref.test on data-carrying DU — GeoRect branch.

let testRefTestRect () : int =
    let s = GeoShape.GeoRect(3.0, 4.0)
    match s with
    | GeoShape.GeoRect(w, h) -> int (w * h)
    | _ -> 0

/// Test: ref.test when last case has no fields (not enum-like; still a struct).

let testRefTestDot () : int =
    let s = GeoShape.GeoDot
    match s with
    | GeoShape.GeoDot -> 42
    | _ -> 0

// ─── Math.Exp ────────────────────────────────────────────────────────────────

/// Test: Math.exp(0) = 1

let testSbToStringLength () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("abc") |> ignore
    let s = sb.ToString()
    s.Length  // 3


let testSbToStringContent () : int =
    let sb = System.Text.StringBuilder()
    sb.Append("hello") |> ignore
    sb.Append(" world") |> ignore
    let s = sb.ToString()
    if s = "hello world" then 1 else 0


let testCompareIntLt () : int = compare 3 5      // -1

let testCompareIntEq () : int = compare 7 7      // 0

let testCompareIntGt () : int = compare 9 2      // 1

let testCompareStrLt () : int = compare "abc" "abd"    // -1

let testCompareStrEq () : int = compare "abc" "abc"    // 0

let testCompareStrGt () : int = compare "abd" "abc"    // 1


let testRecursiveDU () : int =
    let expr = Mul(Add(Lit 2, Lit 3), Add(Lit 1, Lit 4))
    evalExpr expr  // (2+3)*(1+4) = 25

let (|Even|Odd|) n = if n % 2 = 0 then Even else Odd


let testStringConcat () : int =
    let s = "hello" + " " + "world"
    String.length s  // 11


let testStringInterp () : int =
    let name = "Alice"
    let s = $"Hello {name}!"
    String.length s  // 12


// ── Suite runner ──────────────────────────────────────────────────────────
let runStringsTests (check: string -> (unit -> unit) -> unit) =
    check "testRectWidth" (fun () -> ignore (testRectWidth ()))
    check "testStringLen" (fun () -> ignore (testStringLen ()))
    check "testEmptyStringLen" (fun () -> ignore (testEmptyStringLen ()))
    check "testStringChar" (fun () -> ignore (testStringChar ()))
    check "testStringFirstChar" (fun () -> ignore (testStringFirstChar ()))
    check "testStringLen2" (fun () -> ignore (testStringLen2 ()))
    check "testStringConcatLen" (fun () -> ignore (testStringConcatLen ()))
    check "testStringConcatChar" (fun () -> ignore (testStringConcatChar ()))
    check "testStringEqTrue" (fun () -> ignore (testStringEqTrue ()))
    check "testStringEqFalse" (fun () -> ignore (testStringEqFalse ()))
    check "testStringNeq" (fun () -> ignore (testStringNeq ()))
    check "testStringConcatVars" (fun () -> ignore (testStringConcatVars ()))
    check "testRefCell" (fun () -> ignore (testRefCell ()))
    check "testRefCellBool" (fun () -> ignore (testRefCellBool ()))
    check "testStringIndexOf" (fun () -> ignore (testStringIndexOf ()))
    check "testStringIndexOfMiss" (fun () -> ignore (testStringIndexOfMiss ()))
    check "testStringLastIndexOf" (fun () -> ignore (testStringLastIndexOf ()))
    check "testStringLastIndexOfMiss" (fun () -> ignore (testStringLastIndexOfMiss ()))
    check "testStringIndexOfFrom" (fun () -> ignore (testStringIndexOfFrom ()))
    check "testStringStartsWith" (fun () -> ignore (testStringStartsWith ()))
    check "testStringStartsWithFalse" (fun () -> ignore (testStringStartsWithFalse ()))
    check "testStringEndsWith" (fun () -> ignore (testStringEndsWith ()))
    check "testStringEndsWithFalse" (fun () -> ignore (testStringEndsWithFalse ()))
    check "testStringSubstring" (fun () -> ignore (testStringSubstring ()))
    check "testStringSubstringLen" (fun () -> ignore (testStringSubstringLen ()))
    check "testToLowerLength" (fun () -> ignore (testToLowerLength ()))
    check "testToUpperFirstChar" (fun () -> ignore (testToUpperFirstChar ()))
    check "testToLowerChars" (fun () -> ignore (testToLowerChars ()))
    check "testToUpperChars" (fun () -> ignore (testToUpperChars ()))
    check "testTrimBasic" (fun () -> ignore (testTrimBasic ()))
    check "testTrimStart" (fun () -> ignore (testTrimStart ()))
    check "testTrimEnd" (fun () -> ignore (testTrimEnd ()))
    check "testContains" (fun () -> ignore (testContains ()))
    check "testContainsNot" (fun () -> ignore (testContainsNot ()))
    check "testToLowerMixed" (fun () -> ignore (testToLowerMixed ()))
    check "testStringOfInt" (fun () -> ignore (testStringOfInt ()))
    check "testStringOfNegInt" (fun () -> ignore (testStringOfNegInt ()))
    check "testStringOfZero" (fun () -> ignore (testStringOfZero ()))
    check "testStringOfIntChar" (fun () -> ignore (testStringOfIntChar ()))
    check "testPadLeft" (fun () -> ignore (testPadLeft ()))
    check "testPadRight" (fun () -> ignore (testPadRight ()))
    check "testPadLeftNoop" (fun () -> ignore (testPadLeftNoop ()))
    check "testPadLeftChar" (fun () -> ignore (testPadLeftChar ()))
    check "testReplace" (fun () -> ignore (testReplace ()))
    check "testReplaceRemove" (fun () -> ignore (testReplaceRemove ()))
    check "testReplaceNoMatch" (fun () -> ignore (testReplaceNoMatch ()))
    check "testIsUpper" (fun () -> ignore (testIsUpper ()))
    check "testIsLower" (fun () -> ignore (testIsLower ()))
    check "testCharToLower" (fun () -> ignore (testCharToLower ()))
    check "testCharToUpper" (fun () -> ignore (testCharToUpper ()))
    check "testFloatCompare" (fun () -> ignore (testFloatCompare ()))
    check "testRecordEqTrue" (fun () -> ignore (testRecordEqTrue ()))
    check "testRecordEqFalse" (fun () -> ignore (testRecordEqFalse ()))
    check "testRecordNeq" (fun () -> ignore (testRecordNeq ()))
    check "testStrSplitLen" (fun () -> ignore (testStrSplitLen ()))
    check "testStrSplitFirst" (fun () -> ignore (testStrSplitFirst ()))
    check "testStrSplitSecond" (fun () -> ignore (testStrSplitSecond ()))
    check "testStrSplitWords" (fun () -> ignore (testStrSplitWords ()))
    check "testStrSplitNoDelim" (fun () -> ignore (testStrSplitNoDelim ()))
    check "testStrSplitEmpty" (fun () -> ignore (testStrSplitEmpty ()))
    check "testStrSplitMultiChar" (fun () -> ignore (testStrSplitMultiChar ()))
    check "testStrJoinLen" (fun () -> ignore (testStrJoinLen ()))
    check "testStrJoinNoSep" (fun () -> ignore (testStrJoinNoSep ()))
    check "testStrJoinOne" (fun () -> ignore (testStrJoinOne ()))
    check "testStrIsNullOrEmptyTrue" (fun () -> ignore (testStrIsNullOrEmptyTrue ()))
    check "testStrIsNullOrEmptyFalse" (fun () -> ignore (testStrIsNullOrEmptyFalse ()))
    check "testStrCompareEq" (fun () -> ignore (testStrCompareEq ()))
    check "testStrCompareLt" (fun () -> ignore (testStrCompareLt ()))
    check "testStrCompareGt" (fun () -> ignore (testStrCompareGt ()))
    check "testRefTestCircle" (fun () -> ignore (testRefTestCircle ()))
    check "testRefTestRect" (fun () -> ignore (testRefTestRect ()))
    check "testRefTestDot" (fun () -> ignore (testRefTestDot ()))
    check "testSbToStringLength" (fun () -> ignore (testSbToStringLength ()))
    check "testSbToStringContent" (fun () -> ignore (testSbToStringContent ()))
    check "testCompareIntLt" (fun () -> ignore (testCompareIntLt ()))
    check "testCompareIntEq" (fun () -> ignore (testCompareIntEq ()))
    check "testCompareIntGt" (fun () -> ignore (testCompareIntGt ()))
    check "testCompareStrLt" (fun () -> ignore (testCompareStrLt ()))
    check "testCompareStrEq" (fun () -> ignore (testCompareStrEq ()))
    check "testCompareStrGt" (fun () -> ignore (testCompareStrGt ()))
    check "testRecursiveDU" (fun () -> ignore (testRecursiveDU ()))
    check "testStringConcat" (fun () -> ignore (testStringConcat ()))
    check "testStringInterp" (fun () -> ignore (testStringInterp ()))
