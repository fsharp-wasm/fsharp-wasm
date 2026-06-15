namespace Fable

// 1. Give the module the explicit literal name you want
module Core =
    
    // 2. Open the source module automatically inside this scope
    [<AutoOpen>]
    module Bridge =
        open WasmGc.Core
