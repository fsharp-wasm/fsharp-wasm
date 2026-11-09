/// Scope-aware unique-name supply shared by every pass that must guarantee
/// "one binder, one name" per function (Fable-AST `FableNormalize`, WExpr `UniqueLocals`).
///
/// WASM locals are flat (name → one slot), while both Fable and the backend's own builders only
/// guarantee uniqueness per *scope*: nested `for` loops, pipelines, decision-tree targets and
/// helper temporaries (`$limit`, `$iofi_tmp`, …) all re-bind the same name.  Rather than hunting
/// fixed names one by one, a pass renames colliding binders and rewrites exactly the references in
/// their scope.
namespace WasmGc.Core

open System.Collections.Generic

/// `taken`    every name that occurs anywhere in the unit (binders and references): never generated.
/// `reserved` names owned from outside the tree (function parameters): a binder with such a
///            name is renamed, so it can never shadow the parameter.
type UniqueNamer private (taken: HashSet<string>, claimed: HashSet<string>) =
    let counters = Dictionary<string, int>()
    let mutable renames = 0

    static member Create(existing: string seq, reserved: string seq) : UniqueNamer =
        let reserved = Seq.toList reserved
        let taken = HashSet<string>(existing)
        let claimed = HashSet<string>(reserved)
        for r in reserved do taken.Add r |> ignore
        UniqueNamer(taken, claimed)

    /// How many binders had to be renamed (0 ⇒ the tree is unchanged).
    member _.RenameCount = renames

    /// Bind `name` in scope `env` (env maps original → current name).
    /// The first binder of a name keeps it; later ones get `name_N`.
    member _.Bind(env: Map<string, string>, name: string) : string * Map<string, string> =
        if claimed.Add name then
            name, Map.add name name env
        else
            let rec pick n =
                let candidate = sprintf "%s_%d" name n
                if taken.Contains candidate then pick (n + 1) else n, candidate

            let start =
                match counters.TryGetValue name with
                | true, n -> n + 1
                | _ -> 1

            let n, fresh = pick start
            counters.[name] <- n
            taken.Add fresh |> ignore
            claimed.Add fresh |> ignore
            renames <- renames + 1
            fresh, Map.add name fresh env

    /// Bind several names left-to-right (all visible afterwards).
    member this.BindAll(env: Map<string, string>, names: string list) : string list * Map<string, string> =
        let rev, env' =
            names
            |> List.fold
                (fun (acc, env) n ->
                    let n', env' = this.Bind(env, n)
                    n' :: acc, env')
                ([], env)

        List.rev rev, env'
