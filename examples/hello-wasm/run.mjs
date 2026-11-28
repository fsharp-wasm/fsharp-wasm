// node run.mjs: the module that the compiler wrote, run by Node (any engine with WebAssembly GC does).
import { readFileSync } from "node:fs";

const { instance } = await WebAssembly.instantiate(readFileSync("out/Hello.wasm"), {});
const { fibonacci, isPrime, sumOfSquaresOfOdds, distinctSquaresModulo } = instance.exports;

console.log("fibonacci 10          =", fibonacci(10));              // 55
console.log("isPrime 97, 100       =", isPrime(97), isPrime(100));  // 1 0 (a bool is an i32)
console.log("sum of odd squares 9  =", sumOfSquaresOfOdds(9));      // 1 + 9 + 25 + 49 + 81 = 165
console.log("squares modulo 13     =", distinctSquaresModulo(13));   // 0 1 4 9 3 12 10: seven different remainders (a HashSet)
