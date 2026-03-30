/// Stub: Set<'T> for WasmGC target.
/// Full implementation planned for Sprint 19 (after vtable/interfaces for IComparable<'T>).
/// Currently: int-only set backed by a sorted BST (same strategy as Map.fs).
///
/// Design note (Sprint 17):
///   Generic Set<'T> requires IComparable<'T> dispatch.
///   The planned vtable approach encodes interface method tables as WasmGC struct arrays.
///   Until that lands, this module is a placeholder to establish the BCL structure.
module Fable.Library.WasmGc.Collections.Set

// TODO Sprint 19: implement generic Set<'T> using vtable dispatch for comparisons
