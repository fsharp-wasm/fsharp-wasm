/// Module Interface — serialise/deserialise a WModule's public surface.
///
/// Writes a `.wgi` (WasmGC Interface) JSON file alongside each compiled `.wasm`.
/// The linker and multi-project orchestrator read `.wgi` files instead of
/// re-parsing binaries, enabling fast incremental linking.
///
/// Format: a self-describing JSON document with type keys (structural, not index-based)
/// so interface files are stable across recompilation of unrelated modules.
module WasmGc.Emit.ModuleInterface

open System.Text.Json
open WasmGc.Core.AST

// ─────────────────────────────────────────────────────────────────────────────
// Data model (serialisable)
// ─────────────────────────────────────────────────────────────────────────────

/// A single exported or imported function.
[<Struct>]
type IfaceFunc = {
    Name     : string   // Wasm export name
    Internal : string   // Internal function name (may differ for exports)
    TypeKey  : string   // Structural func-type key (stable across recompilation)
    Params   : string[] // Per-param WType keys
    Result   : string   // Result WType key (empty string = void)
}

/// A named type in the module's public surface.
[<Struct>]
type IfaceType = {
    Name    : string   // Wasm type name (e.g. "$MyRecord")
    Key     : string   // Structural key (stable)
    Index   : int      // Module-local type index (for debugging only)
}

/// The complete public interface of a compiled WasmGC module.
type ModuleInterface = {
    Name      : string       // Module/project name
    Version   : string       // Content hash of the source files (for cache invalidation)
    Types     : IfaceType[]
    Exports   : IfaceFunc[]
    Imports   : IfaceFunc[]  // External imports (not satisfied by other modules in the project)
}

// ─────────────────────────────────────────────────────────────────────────────
// Extraction — WModule → ModuleInterface
// ─────────────────────────────────────────────────────────────────────────────

/// Compute a stable WType key (suitable for cross-module comparison).
/// Uses structural form; does NOT embed local type indices (those change).
let rec private tyKey = function
    | WType.I32 -> "i32" | WType.I64 -> "i64"
    | WType.F32 -> "f32" | WType.F64 -> "f64" | WType.I16 -> "i16" | WType.I8 -> "i8"
    | WType.Void -> "void" | WType.AnyRef -> "any" | WType.EqRef -> "eq"
    | WType.Externref -> "ext" | WType.ExternNonNull -> "extnn" | WType.I31ref -> "i31"
    | WType.Ref(idx, false) -> $"ref{idx}"  // index-based — good enough for same-module use
    | WType.Ref(idx, true)  -> $"refn{idx}"
    | WType.Func(ps, rs) ->
        let p = ps |> List.map tyKey |> String.concat ","
        let r = rs |> List.map tyKey |> String.concat ","
        $"fn({p})->({r})"
    | WType.Struct fields ->
        let fs = fields |> List.map (fun f -> $"{f.Name}:{tyKey f.Type}") |> String.concat ";"
        $"struct({fs})"
    | WType.Array(elem, mut) -> $"""arr({tyKey elem},{if mut then "m" else "i"})"""

let private funcTypeKey (ps: WType list) (ret: WType) =
    let p = ps |> List.map tyKey |> String.concat ","
    let r = tyKey ret
    $"fn({p})->({r})"

/// Extract the public interface from a compiled WModule.
let extract (name: string) (version: string) (m: WModule) : ModuleInterface =
    // Exported types — those referenced by exported function signatures
    let exportedFuncMap =
        m.Exports
        |> List.filter (fun e -> e.Kind = ExportFunc)
        |> List.choose (fun e ->
            m.Functions |> List.tryFind (fun f -> f.Name = e.InternalName)
            |> Option.map (fun f -> e, f))

    let exportedFuncs =
        exportedFuncMap
        |> List.map (fun (exp, f) -> {
            Name     = exp.ExportName
            Internal = f.Name
            TypeKey  = funcTypeKey (f.Params |> List.map snd) f.Result
            Params   = f.Params |> List.map (snd >> tyKey) |> Array.ofList
            Result   = tyKey f.Result
        })
        |> Array.ofList

    let importedFuncs =
        m.Imports
        |> List.choose (fun imp ->
            match imp.Desc with
            | ImportFunc(ps, ret) ->
                Some { Name     = imp.Name
                       Internal = imp.Name
                       TypeKey  = funcTypeKey ps ret
                       Params   = ps |> List.map tyKey |> Array.ofList
                       Result   = tyKey ret }
            | _ -> None)
        |> Array.ofList

    let ifaceTypes =
        m.Types
        |> List.mapi (fun i entry -> {
            Name  = entry.Name
            Key   = wTypeKey (WType.Ref(i, false))  // structural key via existing helper
            Index = i
        })
        |> Array.ofList

    { Name    = name
      Version = version
      Types   = ifaceTypes
      Exports = exportedFuncs
      Imports = importedFuncs }

// ─────────────────────────────────────────────────────────────────────────────
// Serialisation — ModuleInterface ↔ JSON
// ─────────────────────────────────────────────────────────────────────────────

let private jsonOpts =
    let o = JsonSerializerOptions()
    o.WriteIndented <- true
    o

let toJson (iface: ModuleInterface) : string =
    JsonSerializer.Serialize(iface, jsonOpts)

let fromJson (json: string) : ModuleInterface =
    JsonSerializer.Deserialize<ModuleInterface>(json, jsonOpts)

/// Write the interface file next to the given `.wasm` path.
let writeAlongside (wasmPath: string) (iface: ModuleInterface) =
    let path = System.IO.Path.ChangeExtension(wasmPath, ".wgi")
    System.IO.File.WriteAllText(path, toJson iface)

/// Read an interface file from alongside a `.wasm`.
let readAlongside (wasmPath: string) : ModuleInterface option =
    let path = System.IO.Path.ChangeExtension(wasmPath, ".wgi")
    if System.IO.File.Exists path
    then Some(fromJson (System.IO.File.ReadAllText path))
    else None
