// Node.js test runner for the WasmGc hello-world output.
// Run *after* compiling with run.sh.
import { readFileSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const __dir = dirname(fileURLToPath(import.meta.url));
const wasmPath = resolve(__dir, "output", "QuickTestWasmGc.wasm");

const buf = readFileSync(wasmPath);
const importObject = {
  env: {
    // consolePrint is called by printfn/printf; receives a WasmGC string array.
    // For test purposes we just log a placeholder; full string conversion is TODO.
    consolePrint: (_strRef) => {
      /* printfn output (WasmGC string ref) */
    }, }, // testEnv: external functions provided by the host (simulates Rust WASM exports).
  // In a real app these would come from a Rust-compiled WASM module.
  testEnv: {
    wasmAdd: (a, b) => (a + b) | 0,   wasmMul: (a, b) => (a * b) | 0, },
};
const { instance } = await WebAssembly.instantiate(buf, importObject);
const exp = instance.exports;

let pass = 0, fail = 0;
function check(label, expected, actual) {
  if (expected === actual) {
    console.log(`  ✓  ${label}: ${actual}`);
    pass++;
  } else {
    console.error(`  ✗  ${label}: expected ${expected}, got ${actual}`);
    fail++;
  }
}

console.log("\n─── WasmGc QuickTest ───────────────────────────\n");

check("add(3, 4)", 7, exp.add(3, 4));
check("add(-1, 1)", 0, exp.add(-1, 1));
check("sub(10, 3)", 7, exp.sub(10, 3));
check("mul(6, 7)", 42, exp.mul(6, 7));
check("fib(0)", 0, exp.fib(0));
check("fib(1)", 1, exp.fib(1));
check("fib(10)", 55, exp.fib(10));
check("fib(20)", 6765, exp.fib(20));
check("fact(0)", 1, exp.fact(0));
check("fact(5)", 120, exp.fact(5));
check("fact(10)", 3628800, exp.fact(10));
check("clamp(0,10,5)", 5, exp.clamp(0, 10, 5));
check("clamp(0,10,-3)", 0, exp.clamp(0, 10, -3));
check("clamp(0,10,15)", 10, exp.clamp(0, 10, 15));
check("myAbs(-7)", 7, exp.myAbs(-7));
check("myAbs(3)", 3, exp.myAbs(3));
check("isqrt(0)", 0, exp.isqrt(0));
check("isqrt(1)", 1, exp.isqrt(1));
check("isqrt(9)", 3, exp.isqrt(9));
check("isqrt(16)", 4, exp.isqrt(16));
check("isqrt(100)", 10, exp.isqrt(100));

// ─── Phase 3: Records / Structs ───────────────────────────────────
check("pointSum(3,4)", 7, exp.pointSum(3, 4));
check("runCounter()", 3, exp.runCounter());
// distanceFromOrigin returns x²+y² (no sqrt yet)
check("testDistanceFromOrigin(3,4)", 25, exp.testDistanceFromOrigin(3, 4));
check("testRectWidth(1,0,6,5)", 5, exp.testRectWidth(1, 0, 6, 5));

// ─── Phase 4: Discriminated Unions ───────────────────────────────
// Enum-like DU (i32 tags)
check("directionToInt(North=0)", 0, exp.directionToInt(0));
check("directionToInt(South=1)", 1, exp.directionToInt(1));
check("directionToInt(East=2)", 2, exp.directionToInt(2));
check("directionToInt(West=3)", 3, exp.directionToInt(3));
// Data-carrying DU (struct subtype hierarchy)
check("shapeAreaCircle(5)", 25, exp.testShapeAreaCircle(5));
check("shapeAreaSquare(3)", 9, exp.testShapeAreaSquare(3));
check("shapeAreaRect(4,5)", 20, exp.testShapeAreaRect(4, 5));
check("shapePerimCircle(3)", 12, exp.testShapePerimCircle(3));
check("shapePerimSquare(3)", 12, exp.testShapePerimSquare(3));
check("shapePerimRect(3,4)", 14, exp.testShapePerimRect(3, 4));

// ─── Tuples ───────────────────────────────────────────────────────
check("swapPair(3,7).fst", 7, exp.testSwapPairFst(3, 7));
check("swapPair(3,7).snd", 3, exp.testSwapPairSnd(3, 7));
check("minMax(5,2).min", 2, exp.testMinMaxFirst(5, 2));
check("minMax(5,2).max", 5, exp.testMinMaxSecond(5, 2));
check("tripleSum(1,2,3)", 6, exp.testTripleSum(1, 2, 3));
check("tripleSum(10,20,30)", 60, exp.testTripleSum(10, 20, 30));

// ─── Phase 5: Option<T> ───────────────────────────────────────────
check("optionSome(42,0)", 42, exp.testOptionSome(42, 0));
check("optionSome(7,99)", 7, exp.testOptionSome(7, 99));
check("optionNone(0)", 0, exp.testOptionNone(0));
check("optionNone(5)", 5, exp.testOptionNone(5));
check("optionDoubleSome(3)", 6, exp.testOptionDoubleSome(3));
check("optionDoubleSome(0)", 0, exp.testOptionDoubleSome(0));
check("optionDoubleNone()", -1, exp.testOptionDoubleNone());
check("optionIsSome(1)", 1, exp.testOptionIsSome(1));
check("optionIsNone()", 1, exp.testOptionIsNone());
check("optionNested(7)", 7, exp.testOptionNested(7));

// ─── Phase 6: Math.* ─────────────────────────────────────────────
check("mathAbsF(-3.5)", 3.5, exp.mathAbsF(-3.5));
check("mathAbsF(3.5)", 3.5, exp.mathAbsF(3.5));
check("mathAbsI(-7)", 7, exp.mathAbsI(-7));
check("mathAbsI(4)", 4, exp.mathAbsI(4));
check("mathSqrt(9.0)", 3.0, exp.mathSqrt(9.0));
check("mathFloor(2.7)", 2.0, exp.mathFloor(2.7));
check("mathFloor(-2.1)", -3.0, exp.mathFloor(-2.1));
check("mathCeil(2.1)", 3.0, exp.mathCeil(2.1));
check("mathCeil(-2.7)", -2.0, exp.mathCeil(-2.7));
check("mathTrunc(-2.9)", -2.0, exp.mathTrunc(-2.9));
check("mathRound(2.4)", 2.0, exp.mathRound(2.4));
check("mathRound(2.6)", 3.0, exp.mathRound(2.6));
check("mathMinF(3,5)", 3.0, exp.mathMinF(3.0, 5.0));
check("mathMaxF(3,5)", 5.0, exp.mathMaxF(3.0, 5.0));
check("mathMinI(3,5)", 3, exp.mathMinI(3, 5));
check("mathMaxI(3,5)", 5, exp.mathMaxI(3, 5));

// ─── Phase 5: Closures & Higher-Order Functions ───────────────────
check("hofSimple: double(5)", 10, exp.testHOFSimple(5));
check("hofSimple: double(7)", 14, exp.testHOFSimple(7));
check("capture: adder(3)(4)", 7, exp.testCapture(3, 4));
check("capture: adder(10)(5)", 15, exp.testCapture(10, 5));
check("applyTwice: double(3)", 12, exp.testApplyTwice(3));
check("applyTwice: double(5)", 20, exp.testApplyTwice(5));
check("letCapture: mult(3)(4)", 12, exp.testLetCapture(3, 4));
check("letCapture: mult(7)(6)", 42, exp.testLetCapture(7, 6));

// ─── Phase 6: Strings ────────────────────────────────────────────
check("stringLen: 'hello'", 5, exp.testStringLen());
check("emptyStringLen: ''", 0, exp.testEmptyStringLen());
check("stringChar: 'ABC'[1]", 66, exp.testStringChar());
check("stringFirstChar: 'xyz'[0]", 120, exp.testStringFirstChar());
check("stringLen2: 'fable wasm'", 10, exp.testStringLen2());

// ─── Phase 6b: String concat & equality ─────────────────────────
check("strConcatLen: 'foo'+'bar'", 6, exp.testStringConcatLen());
check("strConcatChar: ('foo'+'bar')[3]", 98, exp.testStringConcatChar());
check("strEqTrue: 'hello'='hello'", 1, exp.testStringEqTrue());
check("strEqFalse: 'hello'='world'", 0, exp.testStringEqFalse());
check("strNeq: 'abc'<>'xyz'", 1, exp.testStringNeq());
check("strConcatVars: 'hello'+' world' len", 11, exp.testStringConcatVars());

// ─── Option combinators ───────────────────────────────────────────
check("optionMap: Some 5 * 3", 15, exp.testOptionMap());
check("optionBind: Some 4 * 2", 8, exp.testOptionBind());

// ─── List basics ─────────────────────────────────────────────────
check("listHead: [1;2;3].Head", 1, exp.testListHead());
check("listEmpty: [] isEmpty", 1, exp.testListEmpty());
check("listMatch: match [5;6;7] | [] -> 0 | h::_ -> h", 5, exp.testListMatch());
check("listFoldSum: fold (+) 0 [1..5]", 15, exp.testListFoldSum());

// ─── List higher-order combinators ───────────────────────────────
check("listMapSum: map (*2) [1;2;3] |> fold (+) 0", 12, exp.testListMapSum());
check("listFilterSum: filter (>2) [1..5] |> fold (+) 0", 12, exp.testListFilterSum(),);
check("listRevHead: rev [1;2;3] |> head", 3, exp.testListRevHead());
check("listAppendLen: length (append [1;2] [3;4;5])", 5, exp.testListAppendLen(),);

// ─── TypeCast / numeric conversions ──────────────────────────────
check("intOfFloat: int 3.7", 3, exp.testIntOfFloat());
check("intOfNegFloat: int -2.9", -2, exp.testIntOfNegFloat());
check("floatOfInt: float 5 * 2.0 |> int", 10, exp.testFloatOfInt());
check("int64OfInt: int64 7 + int64 3 |> int", 10, exp.testInt64OfInt());

// ─── List.iter ────────────────────────────────────────────────────
check("listIter: sum [1..5]", 15, exp.testListIter());
check("listIterEmpty: sum []", 0, exp.testListIterEmpty());

// ─── List.exists / List.forAll ───────────────────────────────────
check("listExists: >3 in [1..5]", 1, exp.testListExists());
check("listExistsFalse: >10 in [1;2;3]", 0, exp.testListExistsFalse());
check("listForAll: >0 in [1;2;3]", 1, exp.testListForAll());
check("listForAllFalse: >2 in [1;2;3]", 0, exp.testListForAllFalse());

// ─── List.sum ────────────────────────────────────────────────────
check("listSum: sum [1..5]", 15, exp.testListSum());
check("listSumEmpty: sum []", 0, exp.testListSumEmpty());

// ─── List.tryFind ────────────────────────────────────────────────
check("listTryFindSome: tryFind (>3) [1..5] -> Some 4 -> 4", 4, exp.testListTryFindSome(),);
check("listTryFindNone: tryFind (>10) [1..5] -> None -> -1", -1, exp.testListTryFindNone(),);

// ─── List.tryHead ────────────────────────────────────────────────
check("listTryHeadSome: tryHead [7;8;9] -> 7", 7, exp.testListTryHeadSome());
check("listTryHeadNone: tryHead [] -> -1", -1, exp.testListTryHeadNone());

// ─── Ref cells ───────────────────────────────────────────────────
check("refCell: ref 5, inc, return .Value", 6, exp.testRefCell());
check("refCellBool: ref 0, set 1 conditionally, .Value", 1, exp.testRefCellBool(),);

// ─── Recursive DU (Tree) ─────────────────────────────────────────
check("treeSum: Node(Node(Leaf,Leaf,1),Node(Leaf,Leaf,2),3) = 6", 6, exp.testTreeSum(),);
check("treeSum2: nested tree sum = 20", 20, exp.testTreeSum2());

// ─── Mutual tail calls ───────────────────────────────────────────
check("mutualTailCall: isEven 1000 = true → 1", 1, exp.testMutualTailCall());
check("mutualTailCall2: isOdd 999 = true → 1", 1, exp.testMutualTailCall2());

// ─── F# Arrays (WASM GC mutable arrays) ─────────────────────────
check("arrayLiteral: [|5;10;15|].[1]: 10", 10, exp.testArrayLiteral());
check("arrayCreate: create 3 0, fill 10+20+30: 60", 60, exp.testArrayCreate());
check("arrayZeroCreate: zeroCreate 4, arr.[2]<-7, arr.[2]: 7", 7, exp.testArrayZeroCreate(),);
check("arrayLength: [|1..5|].Length: 5", 5, exp.testArrayLength());
check("arraySumLoop: sum [|1..5|] via loop: 15", 15, exp.testArraySumLoop());
check("arrayFloat: [|1.0;3.14;2.71|].[1]: 3.14", 3.14, exp.testArrayFloat());

// ─── Array higher-order functions ─────────────────────────────────
check("arrayFold: fold (+) 0 [|1..5|] = 15", 15, exp.testArrayFold());
check("arrayFoldFloat: fold (+.) 0.0 [0.5,0.5,0.5] = 1.5", 1.5, exp.testArrayFoldFloat(),);
check("arrayMap: map (*2) [1..5], [0]+[4] = 12", 12, exp.testArrayMap());
check("arrayMapStr: map (*3) [1;2;3], [2] = 9", 9, exp.testArrayMapStr());
check("arrayMapi: mapi (i+x) [10;20;30], [1] = 21", 21, exp.testArrayMapi());
check("arrayFilter: filter (>2) [1..5].Length = 3", 3, exp.testArrayFilter());
check("arrayFilterAll: filter (>0) [1..5].Length = 5", 5, exp.testArrayFilterAll(),);
check("arrayFilterNone: filter (>10) [1..5].Length = 0", 0, exp.testArrayFilterNone(),);
check("arrayExists: exists (>4) [1..5] = true → 1", 1, exp.testArrayExists());
check("arrayExistsFalse: exists (>10) [1..5] = false → 0", 0, exp.testArrayExistsFalse(),);
check("arrayForAll: forall (>0) [1..5] = true → 1", 1, exp.testArrayForAll());
check("arrayForAllFalse: forall (>3) [1..5] = false → 0", 0, exp.testArrayForAllFalse(),);
check("arrayInit: init 5 (i*i), [3] = 9", 9, exp.testArrayInit());
check("arrayInitFold: init 5 id |> fold (+) 0 = 10", 10, exp.testArrayInitFold(),);
check("arrayIter: iter sum [1..5] = 15", 15, exp.testArrayIter());
check("arrayIteri: iteri sum i*x [1..5] = 40", 40, exp.testArrayIteri());

// ─── New Array combinators ────────────────────────────────────────
check("arrayReduce: reduce (+) [1..5] = 15", 15, exp.testArrayReduce());
check("arraySum: sum [1..5] = 15", 15, exp.testArraySum());
check("arrayMin: min [3;1;4;1;5] = 1", 1, exp.testArrayMin());
check("arrayMax: max [3;1;4;1;5] = 5", 5, exp.testArrayMax());
check("arrayRev: rev [1;2;3].[0] = 3", 3, exp.testArrayRev());
check("arraySort: sort [3;1;2].[0] = 1", 1, exp.testArraySort());
check("arrayFindIndex: findIndex (>3) [1;5;2;4] = 1", 1, exp.testArrayFindIndex(),);
check("arrayContains: contains 3 [1..4] = 1", 1, exp.testArrayContains());
check("arrayContainsFalse: contains 9 [1..4] = 0", 0, exp.testArrayContainsFalse(),);

// ─── New List combinators ─────────────────────────────────────────────────────
check("listMapi: mapi (i*x) [1;2;3] |> sum = 8", 8, exp.testListMapi());
check("listIteri: iteri (s+=i*x) [1;2;3] = 8", 8, exp.testListIteri());
check("listCollect: collect dup [1;2;3].Length = 6", 6, exp.testListCollect());
check("listCollectOrder: collect dup [1;2;3] sum = 18", 18, exp.testListCollectOrder(),);
check("listChoose: choose (>2) [1..4].Length = 2", 2, exp.testListChoose());
check("listChooseSum: choose (*10 when >2) [1..4] sum = 70", 70, exp.testListChooseSum(),);

// ─── List.foldBack / sumBy / minBy / maxBy ────────────────────────────────────
check("listFoldBack: foldBack (::) [1;2;3] [].Length = 3", 3, exp.testListFoldBack(),);
check("listFoldBackOrder: foldBack (x-acc) [1;2;3] 0 = 2", 2, exp.testListFoldBackOrder(),);
check("listSumBy: sumBy (x*x) [1;2;3;4] = 30", 30, exp.testListSumBy());
check("listMinBy: minBy (x%3) [4;2;7;1;6] = 6", 6, exp.testListMinBy());
check("listMaxBy: maxBy (x%5) [3;8;1;6;4] = 4", 4, exp.testListMaxBy());

// ─── List.min / List.max / List.contains ─────────────────────────────────────
check("listMin: min [3;1;4;1;5] = 1", 1, exp.testListMin());
check("listMax: max [3;1;4;1;5] = 5", 5, exp.testListMax());
check("listContains: contains 3 [1..4] = 1", 1, exp.testListContains());
check("listContainsFalse: contains 9 [1..4] = 0", 0, exp.testListContainsFalse(),);

// ─── List.init / replicate / take / skip / sort ───────────────────────────────
check("listInit: init 5 length = 5", 5, exp.testListInit());
check("listReplicate: replicate 4 7 head = 7", 7, exp.testListReplicate());
check("listTake: take 3 [1..5] item2 = 3", 3, exp.testListTake());
check("listSkip: skip 2 [1..5] head = 3", 3, exp.testListSkip());
check("listSort: sort [3;1;4;1;5;2] head = 1", 1, exp.testListSort());

// ─── Array.scan / Array.append ────────────────────────────────────────────────
check("arrayScan: scan (+) 0 [1..4] last = 10", 10, exp.testArrayScan());
check("arrayScanLen: scan (+) 0 [1..4] length = 5", 5, exp.testArrayScanLen());
check("arrayAppend: append [1;2;3] [4;5] .[3] = 4", 4, exp.testArrayAppend());
check("arrayAppendLen: append [1;2;3] [4;5] length = 5", 5, exp.testArrayAppendLen(),);

// ─── String operations ────────────────────────────────────────────────────────
check("stringIndexOf: 'hello world'.IndexOf('world') = 6", 6, exp.testStringIndexOf(),);
check("stringIndexOfMiss: 'hello world'.IndexOf('xyz') = -1", -1, exp.testStringIndexOfMiss(),);
check("stringLastIndexOf: 'abcabc'.LastIndexOf('bc') = 4", 4, exp.testStringLastIndexOf(),);
check("stringLastIndexOfMiss: 'abcabc'.LastIndexOf('xyz') = -1", -1, exp.testStringLastIndexOfMiss(),);
check("stringIndexOfFrom: 'hello world hello'.IndexOf('hello',5) = 12", 12, exp.testStringIndexOfFrom(),);
check("stringStartsWith: starts 'hello' = 1", 1, exp.testStringStartsWith());
check("stringStartsWithFalse: starts 'world' = 0", 0, exp.testStringStartsWithFalse(),);
check("stringEndsWith: ends 'world' = 1", 1, exp.testStringEndsWith());
check("stringEndsWithFalse: ends 'hello' = 0", 0, exp.testStringEndsWithFalse(),);
check("stringSubstring: Substring(6).Length = 5", 5, exp.testStringSubstring());
check("stringSubstringLen: Substring(6,3).Length = 3", 3, exp.testStringSubstringLen(),);

// ─── List.findIndex ───────────────────────────────────────────────────────────
check("listFindIndex: find (>3) [1;5;2;4] = 1", 1, exp.testListFindIndex());
check("listTryFindIndex: tryFind (>10) [1;2;3] = -1", -1, exp.testListTryFindIndex(),);

// ─── Option.Value ─────────────────────────────────────────────────────────────
check("optionValue: (Some 42).Value = 42", 42, exp.testOptionValue());
check("optionMapValue: map (*2) (Some 42) .Value = 84", 84, exp.testOptionMapValue(),);

// ─── Result<T,E> ──────────────────────────────────────────────────────────────
check("resultMatchOk: match Ok 42 = 42", 42, exp.testResultMatchOk());
check("resultMatchError: match Error 7 = 7", 7, exp.testResultMatchError());
check("resultIsOk: isOk (Ok 1) = 1", 1, exp.testResultIsOk());
check('resultIsError: isError (Error "x") = 1', 1, exp.testResultIsError());
check("resultMap: map (*2) (Ok 21) = 42", 42, exp.testResultMap());
check("resultBind: bind (Ok(x+1)) (Ok 5) = 6", 6, exp.testResultBind());
check("resultBindError: bind on Error(-99) = -99", -99, exp.testResultBindError(),);

// ─── String toLower / toUpper / trim / contains ───────────────────────────────
check("toLowerLength: 'Hello'.ToLower().Length = 5", 5, exp.testToLowerLength(),);
check("toUpperFirstChar: 'hello'.ToUpper()[0] = 72 ('H')", 72, exp.testToUpperFirstChar(),);
check("toLowerChars: 'ABC'.ToLower() sum = 294", 294, exp.testToLowerChars());
check("toUpperChars: 'xyz'.ToUpper() sum = 267", 267, exp.testToUpperChars());
check("trimBasic: '  hi  '.Trim().Length = 2", 2, exp.testTrimBasic());
check("trimStart: '  abc'.TrimStart().Length = 3", 3, exp.testTrimStart());
check("trimEnd: 'abc  '.TrimEnd().Length = 3", 3, exp.testTrimEnd());
check("contains: 'hello'.Contains('ell') = 1", 1, exp.testContains());
check("containsNot: 'hello'.Contains('xyz') = 0", 0, exp.testContainsNot());
check("toLowerMixed: 'HeLLo'.ToLower()[0] = 104 ('h')", 104, exp.testToLowerMixed(),);

// ─── Number-to-string + String interpolation ──────────────────────────────────
check("stringOfInt: string(42).Length = 2", 2, exp.testStringOfInt());
check("stringOfNegInt: string(-1).Length = 2", 2, exp.testStringOfNegInt());
check("stringOfZero: string(0).Length = 1", 1, exp.testStringOfZero());
check("stringOfIntChar: string(123)[0] = 49 ('1')", 49, exp.testStringOfIntChar(),);
check('stringInterpolation: $"x={42}".Length = 4', 4, exp.testStringInterpolation(),);
check('stringInterpolationConcat: $"{3}+{7}".Length = 3', 3, exp.testStringInterpolationConcat(),);

// ─── String.padLeft / padRight / replace ──────────────────────────────────────
check("padLeft: '42'.PadLeft(5).Length = 5", 5, exp.testPadLeft());
check("padRight: '42'.PadRight(5).Length = 5", 5, exp.testPadRight());
check("padLeftNoop: '42'.PadLeft(1).Length = 2", 2, exp.testPadLeftNoop());
check("padLeftChar: '42'.PadLeft(4)[0] = 32 (' ')", 32, exp.testPadLeftChar());
check("replace: 'hello world'.Replace('world','F#').Length = 8", 8, exp.testReplace(),);
check("replaceRemove: 'aabbcc'.Replace('bb','').Length = 4", 4, exp.testReplaceRemove(),);
check("replaceNoMatch: 'abc'.Replace('x','y').Length = 3", 3, exp.testReplaceNoMatch(),);
check("printfnLiteral: printfn 'hello' returns 42", 42, exp.testPrintfnLiteral(),);

// ─── More List operations ──────────────────────────────────────────────────────
check("listItem: List.item 2 [10;20;30;40;50] = 30", 30, exp.testListItem());
check("listTailHead: (List.tail [100;200;300]).Head = 200", 200, exp.testListTailHead(),);
check("listLength: List.length [10;20;30] = 3", 3, exp.testListLength());
check("listReduce: List.reduce (+) [1;2;3;4;5] = 15", 15, exp.testListReduce());
check("listReduceMax: reduce max [3;1;4;1;5;9;2;6] = 9", 9, exp.testListReduceMax(),);
check("listLast: List.last [1;2;3;4;5] = 5", 5, exp.testListLast());
check("listLastSingle: List.last [42] = 42", 42, exp.testListLastSingle());
check("listSortDesc: (sortDescending [3;1;4;1;5;9]).Head = 9", 9, exp.testListSortDesc(),);

// ─── Bitwise / arithmetic ──────────────────────────────────────────────────────
check("bitwiseAnd: 5 &&& 3 = 1", 1, exp.testBitwiseAnd());
check("bitwiseOr: 5 ||| 3 = 7", 7, exp.testBitwiseOr());
check("bitwiseXor: 5 ^^^ 3 = 6", 6, exp.testBitwiseXor());
check("shiftLeft: 1 <<< 3 = 8", 8, exp.testShiftLeft());
check("shiftRight: 32 >>> 2 = 8", 8, exp.testShiftRight());
check("intDiv: 10 / 3 = 3", 3, exp.testIntDiv());
check("intMod: 10 % 3 = 1", 1, exp.testIntMod());

// ─── Math: abs, min, max ───────────────────────────────────────────────────────
check("absNeg: abs(-42) = 42", 42, exp.testAbsNeg());
check("absPos: abs(7) = 7", 7, exp.testAbsPos());
check("minScalar: min 3 7 = 3", 3, exp.testMinScalar());
check("maxScalar: max 3 7 = 7", 7, exp.testMaxScalar());
check("negation: let x = -5 in 0 - x = 5", 5, exp.testNegation());

// ─── Char operations ───────────────────────────────────────────────────────────
check("isDigit: IsDigit('5') = 1", 1, exp.testIsDigit());
check("isDigitFalse: IsDigit('A') = 0", 0, exp.testIsDigitFalse());
check("isLetter: IsLetter('A') = 1", 1, exp.testIsLetter());
check("isLetterFalse: IsLetter('5') = 0", 0, exp.testIsLetterFalse());
check("isUpper: IsUpper('A') = 1", 1, exp.testIsUpper());
check("isLower: IsLower('a') = 1", 1, exp.testIsLower());
check("isWhiteSpace: IsWhiteSpace(' ') = 1", 1, exp.testIsWhiteSpace());
check("isLetterOrDigit: IsLetterOrDigit('9') = 1", 1, exp.testIsLetterOrDigit(),);
check("charToLower: ToLower('A') = 97", 97, exp.testCharToLower());
check("charToUpper: ToUpper('a') = 65", 65, exp.testCharToUpper());

// ─── Option additional operations ──────────────────────────────────────────────
check("optionDefaultValue: defaultValue 99 (Some 42) = 42", 42, exp.testOptionDefaultValue(),);
check("optionDefaultValueNone: defaultValue 99 None = 99", 99, exp.testOptionDefaultValueNone(),);
check("optionDefaultWith: defaultWith (fun()->42) None = 42", 42, exp.testOptionDefaultWith(),);
check("optionDefaultWithSome: defaultWith (fun()->99) (Some 5) = 5", 5, exp.testOptionDefaultWithSome(),);
check("optionFilter: filter (>3) (Some 5) → value 5", 5, exp.testOptionFilter(),);
check("optionFilterNone: filter (>10) (Some 5) → None (0)", 0, exp.testOptionFilterNone(),);

// ─── Float arithmetic ──────────────────────────────────────────────────────────
check("floatMul: 3.0 * 2.0 = 6.0 → 1", 1, exp.testFloatMul());
check("floatCompare: 1.5 < 2.5 → 1", 1, exp.testFloatCompare());

// ─── Sprint 6: Structural Equality ────────────────────────────────────────────
check("recordEqTrue: {X=1,Y=2} = {X=1,Y=2} → 1", 1, exp.testRecordEqTrue());
check("recordEqFalse: {X=1,Y=2} = {X=1,Y=3} → 0", 0, exp.testRecordEqFalse());
check("recordNeq: {X=5,Y=6} <> {X=5,Y=7} → 1", 1, exp.testRecordNeq());
check("duEnumEqTrue: North = North → 1", 1, exp.testDuEnumEqTrue());
check("duEnumEqFalse: North = South → 0", 0, exp.testDuEnumEqFalse());
check("duDataEqTrue: Circle 3.0 = Circle 3.0 → 1", 1, exp.testDuDataEqTrue());
check("duDataEqFalse: Circle 3.0 = Circle 4.0 → 0", 0, exp.testDuDataEqFalse());
check("duDataEqDiffCtor: Circle 3.0 = Square 3.0 → 0", 0, exp.testDuDataEqDiffCtor(),);
check("tupleEqTrue: (1,2) = (1,2) → 1", 1, exp.testTupleEqTrue());
check("tupleEqFalse: (1,2) = (1,3) → 0", 0, exp.testTupleEqFalse());
check("tupleNeq: (1,2) <> (1,3) → 1", 1, exp.testTupleNeq());

// ─── Sprint 5: Monomorphization — demand-driven generic specialization ────────
check("identityInt: identity<int> 99 = 99", 99, exp.testIdentityInt());
check("identityFloat: identity<float> 2.5 > 2.0 → 1", 1, exp.testIdentityFloat(),);
check("const2IntFloat: const2<int,float> 7 3.14 = 7", 7, exp.testConst2IntFloat(),);
check("const2IntInt: const2<int,int> 99 0 = 99", 99, exp.testConst2IntInt());
check("const2FloatInt: const2<float,int> 2.5 42 > 2.0 → 1", 1, exp.testConst2FloatInt(),);

// ─── Sprint 9: fable-library-wasmgc/Map.fs — first F# library compiled by backend ──
check("mapAddFind: MapModule.add 1 100 → tryFind 1 = 100", 100, exp.testMapAddFind(),);
check("mapFindMissing: tryFind 99 on {1→100} = 0 (default)", 0, exp.testMapFindMissing(),);
check("mapCount: {1→100, 2→200} count = 2", 2, exp.testMapCount());
check("mapContainsKey: containsKey 42 on {42→999} = 1", 1, exp.testMapContainsKey(),);
check("mapContainsKeyMissing: containsKey 7 on {42→999} = 0", 0, exp.testMapContainsKeyMissing(),);
check("mapAddReplace: add 1 555 over {1→100} → tryFind 1 = 555", 555, exp.testMapAddReplace(),);

// ─── Sprint 10b: fable-library-wasmgc/Option.fs — BCL migration (Phase A) ────
check("optionModuleIsSome: OptionModule.isSome (Some 5) = 1", 1, exp.testOptionModuleIsSome(),);
check("optionModuleIsSomeNone: OptionModule.isSome None = 0", 0, exp.testOptionModuleIsSomeNone(),);
check("optionModuleIsNone: OptionModule.isNone None = 1", 1, exp.testOptionModuleIsNone(),);
check("optionModuleIsNoneSome: OptionModule.isNone (Some 5) = 0", 0, exp.testOptionModuleIsNoneSome(),);
check("optionModuleDefaultValueNone: defaultValue 42 None = 42", 42, exp.testOptionModuleDefaultValueNone(),);
check("optionModuleDefaultValueSome: defaultValue 42 (Some 99) = 99", 99, exp.testOptionModuleDefaultValueSome(),);
check("optionModuleCountNone: count None = 0", 0, exp.testOptionModuleCountNone(),);
check("optionModuleCountSome: count (Some 5) = 1", 1, exp.testOptionModuleCountSome(),);

// ─── Sprint 10b: fable-library-wasmgc/Result.fs — BCL migration (Phase A) ────
check("resultModuleIsOk: ResultModule.isOk (Ok 5) = 1", 1, exp.testResultModuleIsOk(),);
check("resultModuleIsOkFalse: ResultModule.isOk (Error 0) = 0", 0, exp.testResultModuleIsOkFalse(),);
check("resultModuleIsError: ResultModule.isError (Error 0) = 1", 1, exp.testResultModuleIsError(),);
check("resultModuleIsErrorFalse: ResultModule.isError (Ok 5) = 0", 0, exp.testResultModuleIsErrorFalse(),);
check("resultModuleDefaultValueError: defaultValue 42 (Error 0) = 42", 42, exp.testResultModuleDefaultValueError(),);
check("resultModuleDefaultValueOk: defaultValue 42 (Ok 99) = 99", 99, exp.testResultModuleDefaultValueOk(),);
check("resultModuleDefaultErrorOk: defaultError 42 (Ok 0) = 42", 42, exp.testResultModuleDefaultErrorOk(),);
check("resultModuleDefaultErrorError: defaultError 42 (Error 7) = 7", 7, exp.testResultModuleDefaultErrorError(),);

// ─── Sprint 10e: printf / sprintf format strings ──────────────────────────
check("sprintfInt: sprintf '%d' 42 length = 2", 2, exp.testSprintfInt());
check("sprintfNegInt: sprintf '%d' -7 length = 2", 2, exp.testSprintfNegInt());
check("sprintfStr: sprintf '%s' 'hello' length = 5", 5, exp.testSprintfStr());
check("sprintfIntLiteral: sprintf 'x=%d' 100 length = 5", 5, exp.testSprintfIntLiteral(),);
check("sprintfTwoInts: sprintf '%d %d' 3 7 length = 3", 3, exp.testSprintfTwoInts(),);
check("sprintfTwoStrs: sprintf '%s and %s' 'foo' 'bar' length = 11", 11, exp.testSprintfTwoStrs(),);
check("sprintfBoolTrue: sprintf '%b' true length = 4", 4, exp.testSprintfBoolTrue(),);
check("sprintfBoolFalse: sprintf '%b' false length = 5", 5, exp.testSprintfBoolFalse(),);
check("sprintfMixed: sprintf 'n=%d,s=%s' 7 'hi' length = 8", 8, exp.testSprintfMixed(),);
check("sprintfZero: sprintf '%d' 0 first char = '0'=48", 48, exp.testSprintfZero(),);
check("sprintfPrefix: sprintf 'Result: %d' 99 first char = 'R'=82", 82, exp.testSprintfPrefix(),);
check("sprintfFloat: sprintf '%f' 3.14 length >= 4", 4, exp.testSprintfFloat());
check("sprintfFloatHalf: sprintf '%f' 0.5 length = 3", 3, exp.testSprintfFloatHalf(),);
check("sprintfFloatWhole: sprintf '%f' 2.0 length = 3", 3, exp.testSprintfFloatWhole(),);
check("sprintfFloatNeg: sprintf '%f' -1.5 length = 4", 4, exp.testSprintfFloatNeg(),);
check("sprintfFloatInStr: sprintf 'pi=~%f' 3.14159 first char = 'p'=112", 112, exp.testSprintfFloatInStr(),);
check("printfnInt: printfn 'count=%d' 42 doesn't crash", 1, exp.testPrintfnInt(),);
check("printfnStr: printfn 'hello,%s!' 'world' doesn't crash", 1, exp.testPrintfnStr(),);
check("printfnMulti: printfn '%d+%d=%d' 3 7 10 doesn't crash", 1, exp.testPrintfnMulti(),);
check("sprintfI: sprintf '%i' 99 length = 2", 2, exp.testSprintfI());
check("sprintfPercent: sprintf '100%%' length = 4", 4, exp.testSprintfPercent(),);
check("sprintfIntZeroChar: sprintf '%d' 0 char = 48", 48, exp.testSprintfIntZeroChar(),);
check("sprintfEmptyStr: sprintf '%s' '' length = 0", 0, exp.testSprintfEmptyStr(),);
check("sprintfIntFirstChar: sprintf '%d' 42 first char = '4'=52", 52, exp.testSprintfIntFirstChar(),);
check("interpolationWithSprintf: $'val={99}' length = 6", 6, exp.testInterpolationWithSprintf(),);

console.log("\n─── FFI / External Wasm Import Tests ───────────\n");
check("externAdd: 10 + 32 = 42", 42, exp.testExternAdd());
check("externAddNeg: -5 + 5 = 0", 0, exp.testExternAddNeg());
check("externMul: 6 × 7 = 42", 42, exp.testExternMul());
check("externChain: (2+3)*4 = 20", 20, exp.testExternChain());

console.log("\n─── String.Split Tests ──────────────────────────\n");
check("strSplitLen: 'a,b,c'.Split(',') → 3 parts", 3, exp.testStrSplitLen());
check("strSplitFirst: first part 'a' has length 1", 1, exp.testStrSplitFirst());
check("strSplitSecond: second part 'b' first char = 98", 98, exp.testStrSplitSecond());
check("strSplitWords: 'hello world foo'.Split(' ') → 3", 3, exp.testStrSplitWords());
check("strSplitNoDelim: 'no-delim'.Split(',') → 1", 1, exp.testStrSplitNoDelim());
check("strSplitEmpty: ''.Split(',') → 1", 1, exp.testStrSplitEmpty());
check("strSplitMultiChar: 'x::y::z'.Split('::') → 3", 3, exp.testStrSplitMultiChar());

// String.Join tests
check("strJoinLen: Join(', ', [hello,world,foo]) → length 17", 17, exp.testStrJoinLen());
check("strJoinNoSep: Join('', [hello,world]) → length 10", 10, exp.testStrJoinNoSep());
check("strJoinOne: Join(',', [hello]) → length 5", 5, exp.testStrJoinOne());

// Int32.Parse tests
check("intParse: Int32.Parse('42') = 42", 42, exp.testIntParse());
check("intParseNeg: Int32.Parse('-17') = -17", -17, exp.testIntParseNeg());
check("intParseZero: Int32.Parse('0') = 0", 0, exp.testIntParseZero());

// Double.Parse / float tests
check("floatParse: float '3.14' * 100 = 314", 314, exp.testFloatParse());
check("floatParseNeg: float '-2.5' * 10 = -25", -25, exp.testFloatParseNeg());
check("floatParseInt: float '7' = 7", 7, exp.testFloatParseInt());

// String.IsNullOrEmpty / String.compare tests
check("strIsNullOrEmptyTrue: IsNullOrEmpty('') = 1", 1, exp.testStrIsNullOrEmptyTrue());
check("strIsNullOrEmptyFalse: IsNullOrEmpty('hi') = 0", 0, exp.testStrIsNullOrEmptyFalse());
check("strCompareEq: compare 'abc' 'abc' = 0", 0, exp.testStrCompareEq());
check("strCompareLt: compare 'abc' 'abd' = -1", -1, exp.testStrCompareLt());
check("strCompareGt: compare 'b' 'a' = 1", 1, exp.testStrCompareGt());

console.log("\n─── Showcase: Recursion ─────────────────────────\n");
check("fib10: fibonacci 10 = 55", 55, exp.testFib10());
check("fib15: fibonacci 15 = 610", 610, exp.testFib15());

console.log("\n─── Showcase: Primes ────────────────────────────\n");
check("isPrime7: isPrime 7 = true (1)", 1, exp.testIsPrime7());
check("isPrime4: isPrime 4 = false (0)", 0, exp.testIsPrime4());
check("countPrimesTo50: primes ≤ 50 = 15", 15, exp.testCountPrimesTo50());

console.log("\n─── Showcase: Project Euler ─────────────────────\n");
check("sumMultiples35: sum 3|5 below 1000 = 233168", 233168, exp.testSumMultiples35());
check("collatz27: collatz steps for 27 = 111", 111, exp.testCollatz27());

console.log("\n─── Showcase: List Combinators ──────────────────\n");
check("arrayToList: [|1;2;3|] toList sum = 6", 6, exp.testArrayToList());
check("listOfArray: ofArray [|4;5;6|] sum = 15", 15, exp.testListOfArray());
check("listSortBy: sortBy id [3;1;4;1;5;9;2;6] head = 1", 1, exp.testListSortBy());
check("listFlatten: append [1;2;3] [4;5] sum = 15", 15, exp.testListFlatten());

console.log("\n─── Interface Vtable Dispatch ───────────────────\n");
check("interfaceDispatch: EnglishGreeter 'hello'.Length = 5", 5, exp.testInterfaceDispatch());
check("interfacePolymorphism: 'hello'.Length + 'hola'.Length = 9", 9, exp.testInterfacePolymorphism());

console.log("\n─── pown (integer exponentiation) ───────────────\n");
check("pown 2 10 = 1024", 1024, exp.testPown2_10());
check("pown 3 0 = 1", 1, exp.testPownZero());
check("pown 5 3 = 125", 125, exp.testPownCube());
check("pown 1 100 = 1", 1, exp.testPownOne());

console.log(`\n────────────────────────────────────────────────`);
console.log(`  ${pass} passed, ${fail} failed`);
if (fail > 0) process.exit(1);
