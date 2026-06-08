/// Interop domain: interfaces, classes, FFI
module QuickTestWasmGc.TestsInterop

open QuickTestWasmGc.Preamble
open Fable.Core

// ─── External FFI tests ────────────────────────────────────────

let testExternAdd () : int = externWasmAdd 3 4  // 7
let testExternAddNeg () : int = externWasmAdd (-5) 2  // -3
let testExternMul () : int = externWasmMul 3 4  // 12
let testExternChain () : int = externWasmAdd (externWasmMul 2 3) 4  // (2*3)+4=10

// ─── Interface types ───────────────────────────────────────────

type IGreeter =
    abstract Greet: unit -> int

type EnglishGreeter = { Word: string }
    with
        interface IGreeter with
            member this.Greet() = this.Word.Length

type SpanishGreeter = { Palabra: string }
    with
        interface IGreeter with
            member this.Greet() = this.Palabra.Length

let testInterfaceDispatch () : int =
    let g : IGreeter = { Word = "hello" } :> IGreeter
    g.Greet()

let testInterfacePolymorphism () : int =
    let greeters : IGreeter list =
        [ { Word = "hello" } :> IGreeter
          { Palabra = "hola" } :> IGreeter ]
    greeters |> List.sumBy (fun g -> g.Greet())

// ─── DU with interface ──────────────────────────────────────────

type IShape =
    abstract Area: unit -> int

type IntShape =
    | ICircle of Radius: int
    | IRect of Width: int * Height: int
    interface IShape with
        member this.Area() =
            match this with
            | ICircle r -> r * r
            | IRect(w, h) -> w * h

let testDuInterfaceCircle () : int =
    let s : IShape = ICircle 3 :> IShape
    s.Area()

let testDuInterfaceRect () : int =
    let s : IShape = IRect(4, 5) :> IShape
    s.Area()

let testDuInterfacePoly () : int =
    let shapes : IShape list = [ ICircle 2 :> IShape; IRect(3, 4) :> IShape ]
    shapes |> List.sumBy (fun s -> s.Area())  // 4 + 12 = 16

// ─── Class with interface ───────────────────────────────────────

type ClassCircle(radius: int) =
    interface IShape with
        member this.Area() = radius * radius

type ClassRect(width: int, height: int) =
    interface IShape with
        member this.Area() = width * height

let testClassCircleArea () : int =
    let c = ClassCircle(5)
    let s : IShape = c :> IShape
    s.Area()

let testClassRectArea () : int =
    let r = ClassRect(3, 4)
    let s : IShape = r :> IShape
    s.Area()

let testMixedShapes () : int =
    let shapes : IShape list =
        [ ClassCircle(2) :> IShape
          ClassRect(3, 4) :> IShape
          ICircle 1 :> IShape ]
    shapes |> List.sumBy (fun s -> s.Area())  // 4 + 12 + 1 = 17

// ─── Suite runner ──────────────────────────────────────────────

let runInteropTests (check: string -> (unit -> unit) -> unit) : unit =
    check "testExternAdd" (fun () -> ignore (testExternAdd ()))
    check "testExternAddNeg" (fun () -> ignore (testExternAddNeg ()))
    check "testExternMul" (fun () -> ignore (testExternMul ()))
    check "testExternChain" (fun () -> ignore (testExternChain ()))
    check "testInterfaceDispatch" (fun () -> ignore (testInterfaceDispatch ()))
    check "testInterfacePolymorphism" (fun () -> ignore (testInterfacePolymorphism ()))
    check "testDuInterfaceCircle" (fun () -> ignore (testDuInterfaceCircle ()))
    check "testDuInterfaceRect" (fun () -> ignore (testDuInterfaceRect ()))
    check "testDuInterfacePoly" (fun () -> ignore (testDuInterfacePoly ()))
    check "testClassCircleArea" (fun () -> ignore (testClassCircleArea ()))
    check "testClassRectArea" (fun () -> ignore (testClassRectArea ()))
    check "testMixedShapes" (fun () -> ignore (testMixedShapes ()))
