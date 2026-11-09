/// WasmGC-specific transform pipeline.
///
/// ICompilerCore and ISharpCompilerProvider are now defined in Fable.AST/Plugins.fs
/// and Fable.Transforms/Global/Compiler.fs respectively.  This module only owns
/// the WasmGC transform logic; no platform-agnostic interface definitions here.
///
/// Drop-in replacement for FableTransforms.transformFile in the compile pipeline.
/// Passes an empty expression-transform list to transformDeclaration, deliberately
/// skipping every JS-specific rewrite while still running transformDeclaration's
/// built-in structural passes (uncurryMemberArgs, plugin dispatch no-op).
///
/// Replaces FableTransforms.transformFile in the compile pipeline.
/// Passes an empty expression-transform list to transformDeclaration:
///   ✓  uncurryMemberArgs          — structural, safe for WasmGC
///   ✓  ApplyMemberDeclarationPlugin — no-op (TryGetPluginHelper → None)
///   ✗  curryReceivedArgs           — JS partial-application wrappers
///   ✗  uncurrySendingArgs           — JS argument curry shims
///   ✗  propagateCurryingThroughLets — JS arity annotation propagation
///
/// ICompilerCore is defined in Fable.AST/Plugins.fs — no FCS dependency here.
namespace WasmGc.Transforms

open System
open Fable
open Fable.AST

// ──────────────────────────────────────────────────────────────────────────────
// WasmGC transform pipeline
// ──────────────────────────────────────────────────────────────────────────────

module FableAstGate =

    // /// WasmGC expression-transform list.
    // ///
    // /// Empty by design — we want transformDeclaration's structural work
    // /// (uncurryMemberArgs, ApplyMemberDeclarationPlugin) without any of the
    // /// JS-oriented rewrites in FableTransforms.getTransformations:
    // ///
    // ///   skipped: curryReceivedArgs         (JS partial-application wrappers)
    // ///   skipped: uncurrySendingArgs         (JS argument curry shims)
    // ///   skipped: propagateCurryingThroughLets (JS arity annotation propagation)
    // ///
    // /// ApplyMemberDeclarationPlugin short-circuits via TryGetPluginHelper → None
    // /// for every WasmGC ICompilerCore implementation.
    // ///
    // /// These are the ONLY Fable transformations WasmGC truly requires.
    // /// Everything else (JS uncurrying, prototype generation, etc.) is stripped out.
    // ///
    // /// The 4 core transformations:
    // /// 1. Inline expansion - resolves `inline` functions to their bodies
    // /// 2. Uncurrying - converts curried calls to multi-argument calls (Wasm requires fixed arity)
    // /// 3. Tail-call elimination - converts tail-recursive functions to loops
    // /// 4. Decision tree flattening - simplifies pattern matching to switchable structures
    // let private wasmTransforms : (ICompilerCore -> Fable.AST.Fable.Expr -> Fable.AST.Fable.Expr) list =
    //     [
    //         // 1. Inline expansion (required for FSharp.Core operators like +, -, etc.)
    //         // This resolves `inline` functions to their bodies, which is essential
    //         // because F# operators (like +, -, *) are often defined as inline.
    //         (fun (c: ICompilerCore) (expr: Fable.AST.Fable.Expr) -> 
    //             // Identity pass for now - actual inlining is complex and depends on having
    //             // full GetInlineExpr capability. This will be called by transformDeclaration
    //             // which Fable handles transparently.
    //             expr)
            
    //         // 2. Uncurrying optimization (required for Wasm fixed-arity calls)
    //         // Converts let f a b = ... into direct 2-arg calls instead of nested 1-arg calls.
    //         // WasmGC functions require fixed arity, so this is critical.
    //         (fun (c: ICompilerCore) (expr: Fable.AST.Fable.Expr) -> 
    //             // Identity pass - Fable's transformDeclaration handles this when we
    //             // provide the right transformations list. The uncurrying is applied
    //             // at the declaration level by Fable's infrastructure.
    //             expr)
            
    //         // 3. Tail-call elimination (performance + stack safety)
    //         // Converts tail-recursive patterns into while-loops or special call types.
    //         // Note: This is complex and may require custom implementation or
    //         // integration with Fable's existing passes.
    //         (fun (c: ICompilerCore) (expr: Fable.AST.Fable.Expr) -> 
    //             // Pass-through: Will be handled by Fable's transformDeclaration
    //             // if TCO support is enabled in the transformation pipeline
    //             expr)
            
    //         // 4. Decision tree / match flattening
    //         // Simplifies complex pattern-match trees into switchable structures.
    //         // This makes pattern matches easier to lower to WasmGC control flow.
    //         (fun (c: ICompilerCore) (expr: Fable.AST.Fable.Expr) -> 
    //             // Pass-through: Fable's transformDeclaration applies pattern simplification
    //             expr)
    //     ]

    /// WasmGC-safe transform list. Uses Fable's own
    /// getUncurryOnlyTransformations (FableTransforms.fsi) — the curry-
    /// handling passes confirmed backend-agnostic, plus eraseCurryMarkers
    /// as a final catch-all. Excludes only uncurrySendingArgs (the one
    /// genuinely JS/TS/Dart/Python-biased pass) and the beta-reduction
    /// passes (pure optimizations, not required for correctness — can be
    /// added later for code-quality gains).
    let private wasmTransforms = Fable.Transforms.FableTransforms.getUncurryOnlyTransformations

    /// Core transformation function: applies WasmGC-specific transformations
    /// to a Fable file WITHOUT the JavaScript-specific passes.
    ///
    /// This is the key function that replaces FableTransforms.transformFile
    /// in your main compiler pipeline. It:
    /// 1. Gets the transformation list (4 core passes)
    /// 2. Applies them to each declaration using Fable's standard walker
    /// 3. Returns the cleaned AST
    ///
    /// Key design: We use Fable's transformDeclaration function but with our
    /// own minimal transformation list, avoiding all JS-specific corruption.
    /// Drop-in replacement for FableTransforms.transformFile that is safe for WasmGC.
    ///
    /// Takes ICompilerCore (not Fable.Compiler) — the WasmGC backend has no FCS
    /// dependency after Phase 1 (FSharp2Fable).  Fable.Compiler implements
    /// ICompilerCore, so passing a Compiler value works via implicit upcast.
    let transformFileForWasm
            (com  : ICompilerCore)
            (file : Fable.AST.Fable.File)
            : Fable.AST.Fable.File =
        try
            // Use Fable's native AST walker, but feed it ONLY our transformations.
            // This ensures proper scoping and declaration handling while avoiding JS pollution.
            let newDecls =
                file.Declarations
                |> List.map (fun decl ->
                    try
                        Fable.Transforms.FableTransforms.transformDeclaration (wasmTransforms com) com file (FableNormalize.normalizeDeclaration decl)
                    with ex ->
                        com.AddLog(
                            $"FableAstGate: declaration transform failed: {ex.Message}",
                            Severity.Error)
                        decl)

            // Return the cleaned AST
            Fable.AST.Fable.File(newDecls, usedRootNames = file.UsedNamesInRootScope)
        with ex ->
            // If transformation fails completely, return the raw file
            com.AddLog(
                $"FableAstGate: transformFileForWasm failed: {ex.Message}",
                Severity.Error)
            file

    // ──────────────────────────────────────────────────────────────────────────────
    // Export module for public API
    // ──────────────────────────────────────────────────────────────────────────────


    // Namespace-level re-export: open WasmGc.Transforms gives you transformFileForWasm.
    // let transformFileForWasm = WasmTransformPipeline.transformFileForWasm
