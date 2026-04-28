module Fable.Transforms.WasmGc.Transforms.TransformClosures

open Fable.AST
open Fable.AST.Fable
open Fable.AST.Wasm
open Fable.Transforms.WasmGc.Runtime.Types
open Fable.Transforms.WasmGc.Runtime.FreeVars
module Lc = Fable.Transforms.WasmGc.Runtime.Locals

let rec buildClosure (ctx: Ctx) (eval: Ctx -> Fable.Expr -> WExpr) (args: Ident list) (body: Fable.Expr) (maybeName: string option) : WExpr =
    let baseName = defaultArg maybeName "$closure"
    let funcName = $"{baseName}_{ctx.TypeDefs.Count}"

    let argNames = args |> List.map (fun a -> a.Name) |> Set.ofList
    let allFreeVarNames = collectFreeVars argNames body |> Set.toList
    let freeVarNames =
        allFreeVarNames
        |> List.filter (fun name -> 
            Map.containsKey name ctx.Locals &&
            let q = ctx.FuncNameAlias |> Map.tryFind name |> Option.defaultValue name
            match Map.tryFind q ctx.KnownFuncs with
            | Some([], _) -> false
            | _ -> true
        )

    let captures =
        freeVarNames
        |> List.map (fun name -> name, Map.tryFind name ctx.Locals |> Option.defaultValue WType.I32)
        |> List.filter (fun (_, ty) -> ty <> WType.Void)

    let captureCount = List.length captures

    let argParams =
        args |> List.choose (fun a ->
            let ty = mapTypeKnown ctx a.Type
            if ty = WType.Void then None else Some(a.Name, ty))

    let selfType = WType.Ref(AnyFnTypeIdx, false)
    let argParamTypes = argParams |> List.map snd
    let retType = mapResultTypeKnown ctx body.Type
    let funcTypeIdx = ctx.GetOrAddFuncType(selfType :: argParamTypes, retType)

    let codeFieldType = WType.Ref(funcTypeIdx, false)
    let captureFields =
        captures |> List.mapi (fun i (name, ty) -> { Name = $"cap_{i}_{name}"; Type = ty; Mutable = false })
    let codeField = { Name = "code"; Type = codeFieldType; Mutable = false }

    let baseClosureTypeIdx =
        match ctx.ClosureBaseTypeMap.TryGetValue(funcTypeIdx) with
        | true, idx -> idx
        | false, _ ->
            let idx = ctx.TypeDefs.Count
            ctx.TypeDefs.Add({ Name = $"ClosureBase_{idx}"; Def = WTypeDef.Struct([codeField], Some AnyFnTypeIdx) })
            ctx.ClosureBaseTypeMap.[funcTypeIdx] <- idx
            idx

    let closureTypeIdx = ctx.TypeDefs.Count
    ctx.TypeDefs.Add({ Name = $"ClosureType_{closureTypeIdx}"; Def = WTypeDef.Struct(codeField :: captureFields, Some baseClosureTypeIdx) })
    ctx.ClosureRegistry.[funcName] <- (closureTypeIdx, funcTypeIdx, captureCount)
    
    if not (ctx.FuncTypeToClosureMap.ContainsKey(funcTypeIdx)) then
        ctx.FuncTypeToClosureMap.[funcTypeIdx] <- baseClosureTypeIdx

    let allParams = [("$self", selfType)] @ argParams
    let ctxWithCaptures = captures |> List.fold (fun (c: Ctx) (name, ty) -> c.WithLocal(name, ty)) ctx
    let ctx' = allParams |> List.fold (fun (c: Ctx) (name, ty) -> c.WithLocal(name, ty)) ctxWithCaptures
    let ctx' = { ctx' with CurrentFunc = Some funcName }
    
    // HIER WIRD DIE ABHÄNGIGKEIT AUFGELÖST:
    let wBody = eval ctx' body

    let wBodyWithCaptures =
        if captureCount = 0 then wBody
        else
            let selfCastTy = WType.Ref(closureTypeIdx, false)
            let selfGet = WExpr.LocalGet("$self", selfType)
            let selfCast = WExpr.Cast(selfGet, selfCastTy)
            let bodyWithExtracts =
                captures
                |> List.mapi (fun i (name, ty) -> (name, WExpr.StructGet(WExpr.LocalGet("$self_cast", selfCastTy), i + 1, ty)))
                |> List.foldBack (fun (name, capExpr) innerBody -> WExpr.Let(name, capExpr, innerBody)) <| wBody
            WExpr.Let("$self_cast", selfCast, bodyWithExtracts)

    let closureFunc =
        { Name = funcName; Params = allParams; Result = retType; Locals = []; Body = wBodyWithCaptures; Exported = false }
        |> Lc.resolveLocals
    ctx.Functions.Add(closureFunc)

    let captureExprs = captures |> List.map (fun (name, ty) -> WExpr.LocalGet(name, ty))
    WExpr.Closure(funcName, captureExprs, WType.Ref(closureTypeIdx, false))

// HINWEIS: buildLetRecLambdas funktioniert nach genau dem gleichen Prinzip.
// Füge hier deinen Code aus Zeile 223 bis 261 ein und ersetze 'transformExpr' durch 'eval'.