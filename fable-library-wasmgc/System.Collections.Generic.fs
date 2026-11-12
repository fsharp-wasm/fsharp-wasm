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

/// Walks the live entries in index order; `hashes.[i] < 0` marks a removed one.
type DictionaryEnumerator<'K, 'V>(keys: 'K array, values: 'V array, hashes: int array, used: int) =
    let mutable index = -1
    member _.MoveNext() : bool =
        index <- index + 1
        while index < used && hashes.[index] < 0 do index <- index + 1
        index < used
    member _.Current : KeyValuePair<'K, 'V> = KeyValuePair(keys.[index], values.[index])
    member _.Dispose() : unit = ()

/// Chained hash table with the .NET layout: entries are handed out in index order, a removed entry joins a free
/// list that the next insert reuses first — so enumeration order is the BCL's.
type Dictionary<'K, 'V when 'K : equality>() =
    let mutable buckets : int array = Array.zeroCreate 0      // entry index + 1; 0 = empty bucket
    let mutable hashes : int array = Array.zeroCreate 0       // < 0: the entry is on the free list
    let mutable next : int array = Array.zeroCreate 0         // next entry of the chain, or of the free list (index + 1)
    let mutable keys : 'K array = Array.zeroCreate 0
    let mutable values : 'V array = Array.zeroCreate 0
    let mutable used = 0                                      // entries handed out (live + free)
    let mutable count = 0                                     // live entries
    let mutable freeHead = 0                                  // first free entry + 1; 0 = none

    let find (key: 'K) : int =
        if buckets.Length = 0 then -1 else
        let h = hash key &&& 0x7FFFFFFF
        let mutable i = buckets.[h % buckets.Length] - 1
        while i >= 0 && not (hashes.[i] = h && keys.[i] = key) do i <- next.[i] - 1
        i

    let resize () : unit =
        // capacity: the smallest prime >= 2 * entries (prime sizes spread identity-hashed ints and FNV-mixed hashes alike)
        let mutable size = max 3 (used * 2) ||| 1
        let mutable prime = false
        while not prime do
            prime <- true
            let mutable d = 2
            while prime && d * d <= size do
                if size % d = 0 then prime <- false
                d <- d + 1
            if not prime then size <- size + 2
        let newHashes : int array = Array.zeroCreate size
        let newNext : int array = Array.zeroCreate size
        let newKeys : 'K array = Array.zeroCreate size
        let newValues : 'V array = Array.zeroCreate size
        for i in 0 .. used - 1 do
            newHashes.[i] <- hashes.[i]
            newNext.[i] <- next.[i]
            newKeys.[i] <- keys.[i]
            newValues.[i] <- values.[i]
        hashes <- newHashes; next <- newNext; keys <- newKeys; values <- newValues
        buckets <- Array.zeroCreate size
        for i in 0 .. used - 1 do
            if hashes.[i] >= 0 then
                let b = hashes.[i] % size
                next.[i] <- buckets.[b]
                buckets.[b] <- i + 1

    /// Insert or overwrite; `overwrite = false` leaves an existing entry alone.  True when a new entry was added.
    let insert (key: 'K) (value: 'V) (overwrite: bool) (throwOnDuplicate: bool) : bool =
        let existing = find key
        if existing >= 0 then
            if throwOnDuplicate then failwith "An item with the same key has already been added."
            if overwrite then values.[existing] <- value
            false
        else
            let h = hash key &&& 0x7FFFFFFF
            let slot =
                if freeHead <> 0 then
                    let i = freeHead - 1
                    freeHead <- next.[i]
                    i
                else
                    if used = hashes.Length then resize ()
                    used <- used + 1
                    used - 1
            let b = h % buckets.Length
            hashes.[slot] <- h
            keys.[slot] <- key
            values.[slot] <- value
            next.[slot] <- buckets.[b]
            buckets.[b] <- slot + 1
            count <- count + 1
            true

    member _.Count : int = count

    member _.Item
        with get (key: 'K) : 'V =
            let i = find key
            if i < 0 then raise (KeyNotFoundException "The given key was not present in the dictionary.")
            values.[i]
        and set (key: 'K) (value: 'V) = insert key value true false |> ignore

    member _.Add(key: 'K, value: 'V) : unit = insert key value false true |> ignore
    member _.TryAdd(key: 'K, value: 'V) : bool = insert key value false false
    member _.ContainsKey(key: 'K) : bool = find key >= 0

    member _.TryGetValue(key: 'K, [<System.Runtime.InteropServices.Out>] value: byref<'V>) : bool =
        let i = find key
        if i >= 0 then value <- values.[i]
        i >= 0

    member _.Remove(key: 'K) : bool =
        let i = find key
        if i < 0 then false else
        let b = hashes.[i] % buckets.Length
        // unlink from its chain
        if buckets.[b] = i + 1 then buckets.[b] <- next.[i]
        else
            let mutable p = buckets.[b] - 1
            while next.[p] <> i + 1 do p <- next.[p] - 1
            next.[p] <- next.[i]
        hashes.[i] <- -1
        keys.[i] <- Unchecked.defaultof<'K>
        values.[i] <- Unchecked.defaultof<'V>
        next.[i] <- freeHead
        freeHead <- i + 1
        count <- count - 1
        true

    member _.Clear() : unit =
        buckets <- Array.zeroCreate 0
        hashes <- Array.zeroCreate 0
        next <- Array.zeroCreate 0
        keys <- Array.zeroCreate 0
        values <- Array.zeroCreate 0
        used <- 0; count <- 0; freeHead <- 0

    /// Keys in enumeration order (the BCL returns a KeyCollection; here it is an array).
    member _.Keys : 'K array =
        let r : 'K array = Array.zeroCreate count
        let mutable n = 0
        for i in 0 .. used - 1 do
            if hashes.[i] >= 0 then
                r.[n] <- keys.[i]
                n <- n + 1
        r

    member _.Values : 'V array =
        let r : 'V array = Array.zeroCreate count
        let mutable n = 0
        for i in 0 .. used - 1 do
            if hashes.[i] >= 0 then
                r.[n] <- values.[i]
                n <- n + 1
        r

    member _.GetEnumerator() : DictionaryEnumerator<'K, 'V> = DictionaryEnumerator(keys, values, hashes, used)

type HashSetEnumerator<'T>(items: 'T array, hashes: int array, used: int) =
    let mutable index = -1
    member _.MoveNext() : bool =
        index <- index + 1
        while index < used && hashes.[index] < 0 do index <- index + 1
        index < used
    member _.Current : 'T = items.[index]
    member _.Dispose() : unit = ()

/// A Dictionary without values (same layout, same enumeration order).
type HashSet<'T when 'T : equality>() =
    let table = Dictionary<'T, bool>()

    member _.Count : int = table.Count
    member _.Add(item: 'T) : bool = table.TryAdd(item, true)
    member _.Contains(item: 'T) : bool = table.ContainsKey item
    member _.Remove(item: 'T) : bool = table.Remove item
    member _.Clear() : unit = table.Clear()
    member _.ToArray() : 'T array = table.Keys
    member this.UnionWith(other: 'T array) : unit = for x in other do this.Add x |> ignore
    member _.GetEnumerator() : DictionaryEnumerator<'T, bool> = table.GetEnumerator()
