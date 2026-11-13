/// Object expressions that implement an interface: `{ new IFoo with member _.M(x) = … }`.
///
/// An object expression is an anonymous implementer.  Its type is a struct holding the variables its members capture;
/// each member is lifted to a function taking that struct as `self`; one vtable per source location is static
/// (`VT.wireImplementation`), and evaluating the expression builds the environment and boxes it as the interface.
module WasmGc.Transforms.ObjectExprBuilder

open Fable.AST
open Fable.AST.Fable
open WasmGc.Core.AST
open WasmGc.Runtime.Types
open WasmGc.Runtime.FreeVars
open WasmGc.Pipeline.Scope
open WasmGc.Transforms.ClosureBuilder
module Lc = WasmGc.Runtime.Locals
module VT = WasmGc.Runtime.VTable

/// The lowering of an object expression whose type is an interface the vtable system knows.  None for anything else
/// (`IComparer`-style objects, a generic interface, an object expression with a base-class call), which keep their
/// older treatment.  `eval` is transformExpr, passed in to break the circular reference.
let tryBuild
        (ctx: Ctx)
        (eval: Ctx -> Fable.Expr -> WExpr)
        (members: ObjectExprMember list)
        (typ: Fable.Type)
        (baseCall: Fable.Expr option)
        : WExpr option =
    match typ, baseCall with
    | Fable.Type.DeclaredType(ifaceRef, []), None when ctx.VTableRegistry.ContainsKey ifaceRef.FullName ->
        let implName = closureName "$ObjExpr" ctx
        let ifaceName = ifaceRef.FullName
        // what the members capture from the enclosing scope (their own parameters excluded)
        let captures =
            members
            |> List.collect (fun m ->
                collectFreeVars (m.Args |> List.map (fun a -> a.Name) |> Set.ofList) m.Body |> Set.toList)
            |> List.distinct
            |> filterCaptures ctx
        let envIdx = ctx.TypeDefs.Count
        ctx.TypeDefs.Add
            { Name = implName
              Def = WTypeDef.Struct(captures |> List.mapi (fun i (n, t) -> { Name = $"cap_{i}_{n}"; Type = t; Mutable = false }), None) }
        let envTy = WType.Ref(envIdx, false)
        let env = WExpr.LocalGet("$env", envTy)
        let compiled =
            members
            |> List.map (fun m ->
                // the first parameter of an instance member is `this`: the object expression itself
                let args = match m.Args with a :: rest when a.IsThisArgument -> rest | all -> all
                let argParams =
                    args |> List.choose (fun a ->
                        let ty = mapTypeKnown ctx a.Type
                        if ty = WType.Void then None else Some(a.Name, ty))
                let memberName = match m.MemberRef with MemberRef(_, info) -> info.CompiledName | _ -> m.Name
                let funcName = $"{implName}_{memberName}"
                let bodyCtx =
                    { (ctx |> withLocals (("$env", envTy) :: argParams) |> withLocals captures) with CurrentFunc = Some funcName }
                let body =
                    List.foldBack
                        (fun (i, (name, ty)) acc -> WExpr.Let(name, WExpr.StructGet(env, i, ty), acc))
                        (List.indexed captures)
                        (eval bodyCtx m.Body)
                let ret = mapResultTypeKnown ctx m.Body.Type
                let func =
                    { Name = funcName
                      Params = ("$env", envTy) :: argParams
                      Result = ret
                      Locals = []
                      Body = (if ret <> WType.Void then WasmGc.Core.Traverse.markTailCalls ret body else body)
                      Exported = false }
                    |> Lc.resolveLocals
                ctx.Functions.Add func
                ifaceName, memberName, funcName, List.map snd func.Params, ret)
        VT.wireImplementation ctx implName envIdx compiled
        let boxTypeIdx = let _, b, _, _ = ctx.VTableRegistry.[ifaceName] in b
        let envValue = WExpr.StructNew(envIdx, captures |> List.map (fun (n, t) -> WExpr.LocalGet(n, t)), envTy)
        Some(VT.emitBox ctx envValue implName ifaceName boxTypeIdx)
    | _ -> None
