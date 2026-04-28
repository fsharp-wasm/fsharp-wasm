module WasmGc.Transforms.TransformDispatch

open Fable.AST.Fable
open Fable.AST.Wasm
open WasmGc.Runtime.Types
module RT = WasmGc.Runtime.Runtime
module VT = WasmGc.Runtime.VTable

/// Demand-driven generic specialization (aus Zeile 775)
let trySpecializeCall (ctx: Ctx) (eval: Ctx -> Expr -> WExpr) (funcName: string) (info: CallInfo) (resultFableType: Type) : WExpr option =
    if info.GenericArgs.IsEmpty then None else
    match ctx.GenericFuncRegistry.TryGetValue(funcName) with
    | false, _ -> None
    | true, (declCom, regObj) ->
        let memberDecl = regObj :?> MemberDecl
        let wTypeArgs = info.GenericArgs |> List.map (mapTypeKnown ctx)
        let mangledName = RT.mangleGenericName funcName wTypeArgs
        let wArgs = info.Args |> List.map (eval ctx)
        let retTy = mapTypeKnown ctx resultFableType
        
        if ctx.MonoCache.ContainsKey(mangledName) then
            Some(WExpr.Call(mangledName, wArgs, retTy))
        else
            // (Hier kommt der Rest deiner Logik ab Zeile 786 hin, 
            // setze einfach eval ctx' statt transformExpr ein).
            None 

/// Behandelt String, Math und Import Calls
let dispatchImportCall (ctx: Ctx) (eval: Ctx -> Expr -> WExpr) (importInfo: ImportInfo) (info: CallInfo) (typ: Type) (wArgs: WExpr list) : WExpr =
    let ty = mapTypeKnown ctx typ
    let sel = importInfo.Selector
    let path = importInfo.Path
    
    // (Optional: Hier kannst du die ListReplacements etc. aus Zeile 468 aufrufen)

    match sel, wArgs, ty with
    | ("equals" | "op_Equality" | "equalArrays"), [a; b], WType.I32 ->
        let wty = exprWType a
        let typeIdx = match wty with WType.Ref(idx, _) -> idx | _ -> -1
        if typeIdx >= 0 then
            ctx.UseHelper("$strEq") |> ignore
            match RT.getOrAddStructuralEquals ctx typeIdx with
            | Some funcName -> WExpr.Call(funcName, [a; b], WType.I32)
            | None -> WExpr.Compare(WCompareOp.Eq, a, b)
        else WExpr.Compare(WCompareOp.Eq, a, b)

    // Math
    | "exp", [arg], WType.F32 ->
        WExpr.Unary(WUnaryOp.DemoteF64, WExpr.Call(ctx.UseHelper("$mathExp"), [WExpr.Unary(WUnaryOp.PromoteF32, arg, WType.F64)], WType.F64), WType.F32)
    | "exp", [arg], _ -> WExpr.Call(ctx.UseHelper("$mathExp"), [arg], WType.F64)
    
    // String
    | "indexOf", [str; needle], WType.I32 ->
        WExpr.Call(ctx.UseHelper("$strIndexOf"), [str; needle], WType.I32)
    | ("toLower" | "toLowerInvariant"), [str], _ ->
        WExpr.Call(ctx.UseHelper("$strToLower"), [str], WType.Ref(StringTypeIdx, false))
    | "FSharpRef", [initVal], _ ->
        let innerWType = exprWType initVal
        let refTypeIdx = RT.getOrAddRefCellType ctx innerWType
        WExpr.StructNew(refTypeIdx, [initVal], WType.Ref(refTypeIdx, false))
    
    // Wasm Memory
    | "i32.load", [addr], _ when path = "wasm:memory" -> 
        ctx.HasLinearMemory := true
        WExpr.MemLoad(WMemKind.I32, 0, addr)

    // Füge hier die restlichen String / Math / Lib Calls aus Zeile 487-665 ein
    | _ -> 
        eprintfn "[WasmGc] WARNING: unhandled import call '%s' from '%s'" sel path
        WExpr.Nop

/// Haupt-Dispatcher für alle Call-Ausdrücke
let transformCall (ctx: Ctx) (eval: Ctx -> Expr -> WExpr) (callee: Expr) (info: CallInfo) (typ: Type) : WExpr =
    let ty = mapTypeKnown ctx typ
    let wArgs = info.Args |> List.map (eval ctx)
    
    // 1. Interface vtable dispatch (aus Zeile 441)
    let ifaceDispatch =
        match info.MemberRef, info.ThisArg with
        | Some(MemberRef(ifaceEntityRef, ifaceMemberInfo)), Some thisArg ->
            let ifaceName = ifaceEntityRef.FullName
            match ctx.VTableRegistry.TryGetValue(ifaceName) with
            | true, (vtableTypeIdx, boxTypeIdx, funcTypeIndices, methodNames) ->
                let methodName = ifaceMemberInfo.CompiledName
                match methodNames |> List.tryFindIndex (fun n -> n = methodName) with
                | Some methodIdx ->
                    let boxExpr = eval ctx thisArg
                    Some (VT.emitCallVirtual ifaceName vtableTypeIdx boxTypeIdx funcTypeIndices methodIdx boxExpr wArgs ty)
                | None -> None
            | false, _ -> None
        | _ -> None

    match ifaceDispatch with
    | Some result -> result
    | None ->
        match callee with
        | IdentExpr ident ->
            match trySpecializeCall ctx eval ident.Name info typ with
            | Some specialized -> specialized
            | None ->
                let actualName = ctx.FuncNameAlias |> Map.tryFind ident.Name |> Option.defaultValue ident.Name
                match Map.tryFind ident.Name ctx.Locals with
                | Some(WType.Ref(idx, _)) when idx = AnyFnTypeIdx ->
                    let wClosure = WExpr.LocalGet(ident.Name, WType.Ref(AnyFnTypeIdx, false))
                    let selfType = WType.Ref(AnyFnTypeIdx, false)
                    let wArgsFilt = wArgs |> List.filter (fun a -> exprWType a <> WType.Void)
                    let argTypes = wArgsFilt |> List.map exprWType
                    let funcTypeIdx = ctx.GetOrAddFuncType(selfType :: argTypes, ty)
                    let closureTypeIdx = match ctx.FuncTypeToClosureMap.TryGetValue(funcTypeIdx) with | true, cti -> cti | false, _ -> AnyFnTypeIdx
                    WExpr.ClosureApply(wClosure, wArgsFilt, funcTypeIdx, closureTypeIdx, 0, ty)
                | _ -> WExpr.Call(actualName, wArgs, ty)
                
        | Import(importInfo, _, _) ->
            let fullWArgs = match info.ThisArg with | Some t -> eval ctx t :: wArgs | None -> wArgs
            dispatchImportCall ctx eval importInfo info typ fullWArgs
            
        | _ ->
            let wCallee = eval ctx callee
            WExpr.CallIndirect(wCallee, wArgs, ty)