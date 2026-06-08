module WasmGc.Transforms.TransformHelpers

/// Parse a printf-style format string into prefix parts and specifier chars.
/// e.g. "Hello %s, you are %d!" → (["Hello "; ", you are "; "!"], ['s'; 'd'])
/// %% is treated as a literal '%'.
let (* private *) parseFormatString (fmt: string) : string list * char list =
    let parts = System.Collections.Generic.List<string>()
    let specs = System.Collections.Generic.List<char>()
    let sb = System.Text.StringBuilder()
    let mutable i = 0
    while i < fmt.Length do
        if fmt.[i] = '%' && i + 1 < fmt.Length then
            let mutable j = i + 1
            while j < fmt.Length && (System.Char.IsDigit(fmt.[j]) || fmt.[j] = '.' || fmt.[j] = '-' || fmt.[j] = '+' || fmt.[j] = ' ') do
                j <- j + 1
            if j < fmt.Length && fmt.[j] = '%' then
                sb.Append('%') |> ignore
                i <- j + 1
            elif j < fmt.Length then
                parts.Add(sb.ToString())
                sb.Clear() |> ignore
                specs.Add(fmt.[j])
                i <- j + 1
            else
                i <- j
        else
            sb.Append(fmt.[i]) |> ignore
            i <- i + 1
    parts.Add(sb.ToString())
    List.ofSeq parts, List.ofSeq specs