// Portable generic collections — plain F#: arrays, counters and generic equality, nothing target specific.
// The compiler instantiates a generic class once per type-argument list (like a generic function), so `Stack<int>` and
/// `Stack<string>` are two struct types with two sets of methods.  The names are what the Fable frontend calls
// (`Stack$1__Push_…`), which is why the types and members are named exactly like the BCL ones.
namespace System.Collections.Generic

/// LIFO.  `for x in s` is not supported yet; use `ToArray()`.
type Stack<'T when 'T : equality>() =
    let mutable items : 'T array = Array.zeroCreate 4
    let mutable count = 0

    member _.Count : int = count

    member _.Push(item: 'T) : unit =
        if count = items.Length then
            let bigger : 'T array = Array.zeroCreate (items.Length * 2)
            for i in 0 .. count - 1 do bigger.[i] <- items.[i]
            items <- bigger
        items.[count] <- item
        count <- count + 1

    member _.Pop() : 'T =
        if count = 0 then failwith "Stack empty."
        count <- count - 1
        let item = items.[count]
        items.[count] <- Unchecked.defaultof<'T>     // do not keep a popped reference alive
        item

    member _.Peek() : 'T =
        if count = 0 then failwith "Stack empty."
        items.[count - 1]

    member _.Clear() : unit =
        items <- Array.zeroCreate 4
        count <- 0

    member _.Contains(item: 'T) : bool =
        let mutable found = false
        let mutable i = 0
        while not found && i < count do
            if items.[i] = item then found <- true
            i <- i + 1
        found

    /// Top of the stack first, like the BCL.
    member _.ToArray() : 'T array =
        let result : 'T array = Array.zeroCreate count
        for i in 0 .. count - 1 do result.[i] <- items.[count - 1 - i]
        result

/// FIFO over a growing ring buffer.
type Queue<'T when 'T : equality>() =
    let mutable items : 'T array = Array.zeroCreate 4
    let mutable head = 0
    let mutable count = 0

    member _.Count : int = count

    member _.Enqueue(item: 'T) : unit =
        if count = items.Length then
            let bigger : 'T array = Array.zeroCreate (items.Length * 2)
            for i in 0 .. count - 1 do bigger.[i] <- items.[(head + i) % items.Length]
            items <- bigger
            head <- 0
        items.[(head + count) % items.Length] <- item
        count <- count + 1

    member _.Dequeue() : 'T =
        if count = 0 then failwith "Queue empty."
        let item = items.[head]
        items.[head] <- Unchecked.defaultof<'T>
        head <- (head + 1) % items.Length
        count <- count - 1
        item

    member _.Peek() : 'T =
        if count = 0 then failwith "Queue empty."
        items.[head]

    member _.Clear() : unit =
        items <- Array.zeroCreate 4
        head <- 0
        count <- 0

    member _.Contains(item: 'T) : bool =
        let mutable found = false
        let mutable i = 0
        while not found && i < count do
            if items.[(head + i) % items.Length] = item then found <- true
            i <- i + 1
        found

    /// Front of the queue first.
    member _.ToArray() : 'T array =
        let result : 'T array = Array.zeroCreate count
        for i in 0 .. count - 1 do result.[i] <- items.[(head + i) % items.Length]
        result
