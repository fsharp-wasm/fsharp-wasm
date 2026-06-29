(module
  ;; ── Types ───────────────────────────────────────────
  (type $AnyFn (sub (struct)))
  (type $WasmStr (array (mut i32)))
  (type $ListBase (sub (struct)))
  (type $StringBuilder (sub (struct (field (mut (ref $WasmStr))) (field (mut i32)) (field (mut i32)))))
  (type $FuncType_4 (func (param (ref $AnyFn)) (param (ref $StringBuilder))))
  (type $ClosureBase_5 (sub $AnyFn (struct (field (ref $FuncType_4)))))
  (type $ClosureType_6 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_7 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_8 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_9 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_10 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_11 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_12 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_13 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_14 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $QuickTestWasmGc_TestsExceptions_MyTypedException (sub (struct (field i32))))
  (type $Exception (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_17 (func (param (ref $AnyFn)) (result i32)))
  (type $ClosureBase_18 (sub $AnyFn (struct (field (ref $FuncType_17)))))
  (type $ClosureType_19 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_20 (func (param (ref $AnyFn))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field (ref $WasmStr)))))
  (type $FuncType_27 (func (param (ref $AnyFn)) (param i32) (result i32)))
  (type $ClosureBase_28 (sub $AnyFn (struct (field (ref $FuncType_27)))))
  (type $ClosureType_29 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $FuncType_30 (func (param (ref $AnyFn)) (param i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))))
  (type $ClosureBase_31 (sub $AnyFn (struct (field (ref $FuncType_30)))))
  (type $ClosureType_32 (sub $ClosureBase_31 (struct (field (ref $FuncType_30)))))
  (type $ClosureType_33 (sub $ClosureBase_31 (struct (field (ref $FuncType_30)))))
  (type $ClosureType_34 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_35 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_36 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ListCons_37 (sub $ListBase (struct (field i32) (field (ref null $ListBase)))))
  (type $ClosureType_38 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_39 (func (param (ref $AnyFn)) (param (ref null $ListBase)) (result i32)))
  (type $ClosureBase_40 (sub $AnyFn (struct (field (ref $FuncType_39)))))
  (type $ClosureType_41 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_42 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $FuncType_43 (func (param (ref $AnyFn)) (param (ref null $ListBase)) (result (ref null $ListBase))))
  (type $ClosureBase_44 (sub $AnyFn (struct (field (ref $FuncType_43)))))
  (type $ClosureType_45 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $ClosureType_46 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_47 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_48 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $ClosureType_49 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32) (field i32))))
  (type $FuncType_50 (func (param (ref $AnyFn)) (param i32) (result (ref $AnyFn))))
  (type $ClosureBase_51 (sub $AnyFn (struct (field (ref $FuncType_50)))))
  (type $ClosureType_52 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_53 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_54 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $RefCell_55 (sub (struct (field (mut i32)))))
  (type $ClosureBase_56 (sub $AnyFn (struct (field (ref $FuncType_20)))))
  (type $ClosureType_57 (sub $ClosureBase_56 (struct (field (ref $FuncType_20)) (field (ref $RefCell_55)))))
  (type $ClosureType_58 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32) (field i32))))
  (type $ClosureType_59 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $QuickTestWasmGc_TestsInterop_EnglishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_61 (func (param (ref eq)) (result i32)))
  (type $vtbl_QuickTestWasmGc_TestsInterop_IGreeter (sub (struct (field (ref $FuncType_61)))))
  (type $box_QuickTestWasmGc_TestsInterop_IGreeter (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsInterop_IGreeter)) (field (ref eq)))))
  (type $QuickTestWasmGc_TestsInterop_SpanishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $ListCons_65 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (field (ref null $ListBase)))))
  (type $FuncType_66 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (result i32)))
  (type $ClosureBase_67 (sub $AnyFn (struct (field (ref $FuncType_66)))))
  (type $ClosureType_68 (sub $ClosureBase_67 (struct (field (ref $FuncType_66)))))
  (type $ClosureType_69 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_70 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsInterop_IntShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsInterop_IntShape#0 (sub $QuickTestWasmGc_TestsInterop_IntShape (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsInterop_IntShape#1 (sub $QuickTestWasmGc_TestsInterop_IntShape (struct (field i32) (field i32) (field i32))))
  (type $vtbl_QuickTestWasmGc_TestsInterop_IShape (sub (struct (field (ref $FuncType_61)))))
  (type $box_QuickTestWasmGc_TestsInterop_IShape (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsInterop_IShape)) (field (ref eq)))))
  (type $ListCons_76 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (field (ref null $ListBase)))))
  (type $FuncType_77 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)))
  (type $ClosureBase_78 (sub $AnyFn (struct (field (ref $FuncType_77)))))
  (type $ClosureType_79 (sub $ClosureBase_78 (struct (field (ref $FuncType_77)))))
  (type $ClosureType_80 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_81 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsInterop_ClassCircle (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsInterop_ClassRect (sub (struct (field i32) (field i32))))
  (type $ClosureType_84 (sub $ClosureBase_78 (struct (field (ref $FuncType_77)))))
  (type $ClosureType_85 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_86 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsDU_Shape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsDU_Shape#0 (sub $QuickTestWasmGc_TestsDU_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsDU_Shape#1 (sub $QuickTestWasmGc_TestsDU_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsDU_Shape#2 (sub $QuickTestWasmGc_TestsDU_Shape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsDU_Tree (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsDU_Tree#0 (sub $QuickTestWasmGc_TestsDU_Tree (struct (field i32))))
  (type $QuickTestWasmGc_TestsDU_Tree#1 (sub $QuickTestWasmGc_TestsDU_Tree (struct (field i32) (field (ref $QuickTestWasmGc_TestsDU_Tree)) (field (ref $QuickTestWasmGc_TestsDU_Tree)) (field i32))))
  (type $QuickTestWasmGc_TestsDU_GeoShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsDU_GeoShape#0 (sub $QuickTestWasmGc_TestsDU_GeoShape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsDU_GeoShape#1 (sub $QuickTestWasmGc_TestsDU_GeoShape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsDU_GeoShape#2 (sub $QuickTestWasmGc_TestsDU_GeoShape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsDU_MathExpr (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsDU_MathExpr#0 (sub $QuickTestWasmGc_TestsDU_MathExpr (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsDU_MathExpr#1 (sub $QuickTestWasmGc_TestsDU_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsDU_MathExpr)) (field (ref $QuickTestWasmGc_TestsDU_MathExpr)))))
  (type $QuickTestWasmGc_TestsDU_MathExpr#2 (sub $QuickTestWasmGc_TestsDU_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsDU_MathExpr)) (field (ref $QuickTestWasmGc_TestsDU_MathExpr)))))
  (type $QuickTestWasmGc_TestsPrimitives_Point (sub (struct (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsPrimitives_Counter (sub (struct (field (mut i32)))))
  (type $QuickTestWasmGc_TestsPrimitives_Rect (sub (struct (field (ref $QuickTestWasmGc_TestsPrimitives_Point)) (field (ref $QuickTestWasmGc_TestsPrimitives_Point)))))
  (type $Tuple_105 (sub (struct (field i32) (field i32))))
  (type $Tuple_106 (sub (struct (field f64) (field f64))))
  (type $Tuple_107 (sub (struct (field i32) (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsPrimitives_SWItem (sub (struct (field i32))))
  (type $ListCons_109 (sub $ListBase (struct (field (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (field (ref null $ListBase)))))
  (type $FuncType_110 (func (param (ref $AnyFn)) (param (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (result i32)))
  (type $ClosureBase_111 (sub $AnyFn (struct (field (ref $FuncType_110)))))
  (type $ClosureType_112 (sub $ClosureBase_111 (struct (field (ref $FuncType_110)))))
  (type $FuncType_113 (func (param (ref $AnyFn)) (param i32) (param i32) (result i32)))
  (type $ClosureBase_114 (sub $AnyFn (struct (field (ref $FuncType_113)))))
  (type $ClosureType_115 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $GcArray_116 (array (mut (ref $QuickTestWasmGc_TestsPrimitives_SWItem))))
  (type $GcArray_117 (array (mut i32)))
  (type $Option_118 (sub (struct (field i32))))
  (type $ClosureType_119 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $FuncType_120 (func (param (ref $AnyFn)) (param i32) (result (ref null $Option_118))))
  (type $ClosureBase_121 (sub $AnyFn (struct (field (ref $FuncType_120)))))
  (type $ClosureType_122 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_123 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_124 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_125 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_126 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_127 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_128 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $Option_129 (sub (struct (field (ref null $Option_118)))))
  (type $MapModule_MapNode`2 (sub (struct (field i32))))
  (type $MapModule_MapNode`2#0 (sub $MapModule_MapNode`2 (struct (field i32))))
  (type $MapModule_MapNode`2#1 (sub $MapModule_MapNode`2 (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2)) (field (ref $MapModule_MapNode`2)))))
  (type $MapModule_MapHandle`2 (sub (struct (field (ref $MapModule_MapNode`2)) (field (ref $AnyFn)))))
  (type $MapModule_MapNode`2<i32~i32> (sub (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#0 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#1 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2<i32~i32>)) (field (ref $MapModule_MapNode`2<i32~i32>)))))
  (type $ListCons_137 (sub $ListBase (struct (field (ref $Tuple_105)) (field (ref null $ListBase)))))
  (type $ClosureType_138 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_139 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_140 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_141 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_142 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_143 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $SetModule_SetNode`1 (sub (struct (field i32))))
  (type $SetModule_SetNode`1#0 (sub $SetModule_SetNode`1 (struct (field i32))))
  (type $SetModule_SetNode`1#1 (sub $SetModule_SetNode`1 (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1)) (field (ref $SetModule_SetNode`1)))))
  (type $SetModule_SetHandle`1 (sub (struct (field (ref $SetModule_SetNode`1)) (field (ref $AnyFn)))))
  (type $SetModule_SetNode`1<i32> (sub (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#0 (sub $SetModule_SetNode`1<i32> (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#1 (sub $SetModule_SetNode`1<i32> (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $SetModule_SetNode`1<i32>)))))
  (type $FuncType_151 (func (param (ref $AnyFn)) (param i32)))
  (type $ClosureType_152 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_153 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_154 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_155 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $FuncType_156 (func (param (ref $AnyFn)) (param i32) (result (ref $SetModule_SetNode`1<i32>))))
  (type $ClosureBase_157 (sub $AnyFn (struct (field (ref $FuncType_156)))))
  (type $ClosureType_158 (sub $ClosureBase_157 (struct (field (ref $FuncType_156)) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_159 (func (param (ref $AnyFn)) (param (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))))
  (type $ClosureBase_160 (sub $AnyFn (struct (field (ref $FuncType_159)))))
  (type $ClosureType_161 (sub $ClosureBase_160 (struct (field (ref $FuncType_159)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_162 (sub $ClosureBase_157 (struct (field (ref $FuncType_156)) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_163 (sub $ClosureBase_160 (struct (field (ref $FuncType_159)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_164 (func (param (ref $AnyFn)) (param i32) (result (ref $SetModule_SetHandle`1))))
  (type $ClosureBase_165 (sub $AnyFn (struct (field (ref $FuncType_164)))))
  (type $ClosureType_166 (sub $ClosureBase_165 (struct (field (ref $FuncType_164)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_167 (func (param (ref $AnyFn)) (param (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))))
  (type $ClosureBase_168 (sub $AnyFn (struct (field (ref $FuncType_167)))))
  (type $ClosureType_169 (sub $ClosureBase_168 (struct (field (ref $FuncType_167)))))
  (type $ClosureType_170 (sub $ClosureBase_165 (struct (field (ref $FuncType_164)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_171 (sub $ClosureBase_168 (struct (field (ref $FuncType_167)))))
  (type $GcArray_172 (array (mut (ref $WasmStr))))
  (type $FuncType_173 (func (param (ref $AnyFn)) (param (ref $AnyFn))))
  (type $ClosureBase_174 (sub $AnyFn (struct (field (ref $FuncType_173)))))
  (type $ClosureType_175 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)) (field i32) (field i32))))
  (type $ClosureType_176 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32) (field i32))))
  (type $FuncType_177 (func (param (ref $AnyFn)) (param i32) (result (ref $WasmStr))))
  (type $ClosureBase_178 (sub $AnyFn (struct (field (ref $FuncType_177)))))
  (type $ClosureType_179 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_180 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $FuncType_181 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureBase_182 (sub $AnyFn (struct (field (ref $FuncType_181)))))
  (type $ClosureType_183 (sub $ClosureBase_182 (struct (field (ref $FuncType_181)) (field (ref $AnyFn)))))
  (type $ClosureType_184 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_185 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_186 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field (ref $AnyFn)))))
  (type $FuncType_187 (func (param (ref $AnyFn)) (param i32) (param i32) (result (ref $WasmStr))))
  (type $Tuple_188 (sub (struct (field (ref $WasmStr)) (field (ref $WasmStr)))))
  (type $FuncType_189 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (result (ref $AnyFn))))
  (type $ClosureType_190 (sub $ClosureBase_182 (struct (field (ref $FuncType_181)) (field (ref $AnyFn)))))
  (type $ClosureBase_191 (sub $AnyFn (struct (field (ref $FuncType_189)))))
  (type $ClosureType_192 (sub $ClosureBase_191 (struct (field (ref $FuncType_189)) (field (ref $AnyFn)))))
  (type $FuncType_193 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureType_194 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_195 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $Tuple_196 (sub (struct (field i32) (field (ref $WasmStr)))))
  (type $ClosureType_197 (sub $ClosureBase_182 (struct (field (ref $FuncType_181)) (field (ref $AnyFn)))))
  (type $ClosureType_198 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field (ref $AnyFn)))))
  (type $FuncType_199 (func (param (ref $AnyFn)) (param i32) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureType_200 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_201 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $FuncType_202 (func (param (ref $AnyFn)) (param f64) (result (ref $WasmStr))))
  (type $ClosureBase_203 (sub $AnyFn (struct (field (ref $FuncType_202)))))
  (type $ClosureType_204 (sub $ClosureBase_203 (struct (field (ref $FuncType_202)) (field (ref $AnyFn)))))
  (type $ClosureType_205 (sub $ClosureBase_203 (struct (field (ref $FuncType_202)) (field (ref $AnyFn)))))
  (type $ClosureType_206 (sub $ClosureBase_203 (struct (field (ref $FuncType_202)) (field (ref $AnyFn)))))
  (type $ClosureType_207 (sub $ClosureBase_203 (struct (field (ref $FuncType_202)) (field (ref $AnyFn)))))
  (type $ClosureType_208 (sub $ClosureBase_203 (struct (field (ref $FuncType_202)) (field (ref $AnyFn)))))
  (type $ClosureBase_209 (sub $AnyFn (struct (field (ref $FuncType_151)))))
  (type $ClosureType_210 (sub $ClosureBase_209 (struct (field (ref $FuncType_151)) (field (ref $AnyFn)))))
  (type $FuncType_211 (func (param (ref $AnyFn)) (param (ref $WasmStr))))
  (type $ClosureBase_212 (sub $AnyFn (struct (field (ref $FuncType_211)))))
  (type $ClosureType_213 (sub $ClosureBase_212 (struct (field (ref $FuncType_211)) (field (ref $AnyFn)))))
  (type $ClosureType_214 (sub $ClosureBase_209 (struct (field (ref $FuncType_151)) (field (ref $AnyFn)))))
  (type $ClosureType_215 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field (ref $AnyFn)))))
  (type $ClosureType_216 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field (ref $AnyFn)))))
  (type $FuncType_217 (func (param (ref $AnyFn)) (param i32) (param i32) (param i32)))
  (type $ClosureType_218 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_219 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_220 (sub $ClosureBase_182 (struct (field (ref $FuncType_181)) (field (ref $AnyFn)))))
  (type $ClosureType_221 (sub $ClosureBase_178 (struct (field (ref $FuncType_177)) (field (ref $AnyFn)))))
  (type $ClosureType_222 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_223 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_224 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_225 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_226 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_227 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_228 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_229 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_230 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_231 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_232 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_233 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_234 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_235 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_236 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_237 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_238 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_239 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $FuncType_240 (func (param (ref $AnyFn)) (param (ref $Tuple_105)) (result i32)))
  (type $ClosureBase_241 (sub $AnyFn (struct (field (ref $FuncType_240)))))
  (type $ClosureType_242 (sub $ClosureBase_241 (struct (field (ref $FuncType_240)))))
  (type $ClosureType_243 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field (ref $AnyFn)))))
  (type $ClosureType_244 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_245 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_246 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_247 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_248 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_249 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_250 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_251 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_252 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_253 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_254 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_255 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_256 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $FuncType_257 (func (param (ref $AnyFn)) (param i32) (result (ref null $ListBase))))
  (type $ClosureBase_258 (sub $AnyFn (struct (field (ref $FuncType_257)))))
  (type $ClosureType_259 (sub $ClosureBase_258 (struct (field (ref $FuncType_257)))))
  (type $ClosureType_260 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_261 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_262 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_263 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_264 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_265 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_266 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_267 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_268 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)) (field (ref $AnyFn)))))
  (type $ClosureType_269 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_270 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_271 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_272 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_273 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_274 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_275 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $ClosureType_276 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_277 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_278 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_279 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_280 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_281 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $Tuple_282 (sub (struct (field i32) (field (ref null $ListBase)))))
  (type $ListCons_283 (sub $ListBase (struct (field (ref $Tuple_282)) (field (ref null $ListBase)))))
  (type $ClosureType_284 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_285 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_286 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_287 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $FuncType_288 (func (param (ref $AnyFn)) (param f64) (param f64) (result f64)))
  (type $ClosureBase_289 (sub $AnyFn (struct (field (ref $FuncType_288)))))
  (type $ClosureType_290 (sub $ClosureBase_289 (struct (field (ref $FuncType_288)))))
  (type $ClosureType_291 (sub $ClosureBase_289 (struct (field (ref $FuncType_288)))))
  (type $ClosureType_292 (sub $ClosureBase_289 (struct (field (ref $FuncType_288)))))
  (type $QuickTestWasmGc_TestsMath_GeoShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#0 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#1 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#2 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32))))
  (type $GcArray_297 (array (mut f64)))
  (type $ClosureType_298 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_299 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $FuncType_300 (func (param (ref $AnyFn)) (param f64) (result f64)))
  (type $ClosureBase_301 (sub $AnyFn (struct (field (ref $FuncType_300)))))
  (type $ClosureType_302 (sub $ClosureBase_301 (struct (field (ref $FuncType_300)) (field f64))))
  (type $FuncType_303 (func (param (ref $AnyFn)) (param f64) (result (ref $AnyFn))))
  (type $ClosureBase_304 (sub $AnyFn (struct (field (ref $FuncType_303)))))
  (type $ClosureType_305 (sub $ClosureBase_304 (struct (field (ref $FuncType_303)))))
  (type $ClosureType_306 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_307 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_308 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_309 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_310 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_311 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_312 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_313 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_314 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_315 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_316 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_317 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_318 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_319 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_320 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_321 (sub $ClosureBase_209 (struct (field (ref $FuncType_151)) (field i32))))
  (type $ClosureType_322 (sub $ClosureBase_209 (struct (field (ref $FuncType_151)) (field i32) (field i32))))
  (type $ClosureType_323 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_324 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_325 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_326 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_327 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_328 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_329 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_330 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_331 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_332 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_333 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_334 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_335 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_336 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_337 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_338 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_339 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_340 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_341 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_342 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $GcArray_343 (array (mut (ref $Tuple_105))))
  (type $ClosureType_344 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_345 (func (param (ref $AnyFn)) (param (ref $GcArray_117)) (result i32)))
  (type $ClosureBase_346 (sub $AnyFn (struct (field (ref $FuncType_345)))))
  (type $ClosureType_347 (sub $ClosureBase_346 (struct (field (ref $FuncType_345)))))
  (type $ClosureType_348 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_349 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_350 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_351 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_352 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_353 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_354 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_355 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_356 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $FuncType_357 (func (param (ref $AnyFn)) (param i32) (result (ref $GcArray_117))))
  (type $ClosureBase_358 (sub $AnyFn (struct (field (ref $FuncType_357)))))
  (type $ClosureType_359 (sub $ClosureBase_358 (struct (field (ref $FuncType_357)))))
  (type $ClosureType_360 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_361 (sub $ClosureBase_358 (struct (field (ref $FuncType_357)))))
  (type $ClosureType_362 (sub $ClosureBase_358 (struct (field (ref $FuncType_357)))))
  (type $ClosureType_363 (sub $ClosureBase_358 (struct (field (ref $FuncType_357)))))
  (type $ResizeArray_364 (sub (struct (field (mut (ref null $GcArray_117))) (field (mut i32)))))
  (type $Tuple_365 (sub (struct (field (ref $GcArray_117)) (field (ref $GcArray_117)))))
  (type $ClosureType_366 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_367 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_368 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $QuickTestWasmGc_TestsStrings_Shape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Shape#0 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Shape#1 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Shape#2 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Tree (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Tree#0 (sub $QuickTestWasmGc_TestsStrings_Tree (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Tree#1 (sub $QuickTestWasmGc_TestsStrings_Tree (struct (field i32) (field (ref $QuickTestWasmGc_TestsStrings_Tree)) (field (ref $QuickTestWasmGc_TestsStrings_Tree)) (field i32))))
  (type $ClosureType_376 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_377 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $ClosureType_378 (sub $ClosureBase_5 (struct (field (ref $FuncType_4)))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#0 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#1 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $FuncType_382 (func (param (ref $AnyFn)) (param (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))))
  (type $ClosureBase_383 (sub $AnyFn (struct (field (ref $FuncType_382)))))
  (type $ClosureType_384 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_385 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_386 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_387 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $FuncType_388 (func (param (ref $AnyFn)) (param (ref null $Option_118)) (result i32)))
  (type $ClosureBase_389 (sub $AnyFn (struct (field (ref $FuncType_388)))))
  (type $ClosureType_390 (sub $ClosureBase_389 (struct (field (ref $FuncType_388)) (field i32))))
  (type $ClosureType_391 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_392 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_393 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_394 (sub $ClosureBase_389 (struct (field (ref $FuncType_388)) (field i32))))
  (type $ClosureType_395 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_396 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_397 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_398 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_399 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_400 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_401 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_402 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_403 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_404 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_405 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_406 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_407 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_408 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_409 (sub $ClosureBase_389 (struct (field (ref $FuncType_388)) (field i32))))
  (type $ClosureType_410 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_411 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_412 (sub $ClosureBase_389 (struct (field (ref $FuncType_388)) (field i32))))
  (type $ClosureType_413 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_414 (sub $ClosureBase_389 (struct (field (ref $FuncType_388)) (field i32))))
  (type $ClosureType_415 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_416 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32) (field i32))))
  (type $ClosureType_417 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $FuncType_418 (func (param (ref $AnyFn)) (param (ref $MapModule_MapHandle`2)) (result i32)))
  (type $ClosureType_419 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_420 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_421 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_422 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_423 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_424 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_425 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_426 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_427 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_428 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_429 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_430 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_431 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_432 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_433 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_434 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_435 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_436 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_437 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_438 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_439 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_440 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_441 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_442 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_443 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_444 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_445 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_446 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_447 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_448 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_449 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_450 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_451 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_452 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_453 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_454 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_455 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_456 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_457 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_458 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_459 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_460 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_461 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_462 (sub $ClosureBase_389 (struct (field (ref $FuncType_388)) (field i32))))
  (type $ClosureType_463 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_464 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_465 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_466 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_467 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_468 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_469 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_470 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_471 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_472 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_473 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_474 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_475 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_476 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_477 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_478 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_479 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_480 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_481 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_482 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_483 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_484 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_485 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_486 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_487 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_488 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_489 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_490 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_491 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_492 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_493 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_494 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_495 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_496 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_497 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32) (field i32))))
  (type $ClosureType_498 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_499 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $FuncType_500 (func (param (ref $AnyFn)) (param (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))))
  (type $ClosureBase_501 (sub $AnyFn (struct (field (ref $FuncType_500)))))
  (type $ClosureType_502 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_503 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_504 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_505 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_506 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_507 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_508 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_509 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_510 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_511 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_512 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_513 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_514 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_515 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_516 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_517 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_518 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_519 (sub $ClosureBase_501 (struct (field (ref $FuncType_500)) (field i32))))
  (type $ClosureType_520 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_521 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_522 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_523 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_524 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_525 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_526 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_527 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_528 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_529 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_530 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_531 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_532 (sub $ClosureBase_209 (struct (field (ref $FuncType_151)) (field i32))))
  (type $ClosureType_533 (sub $ClosureBase_209 (struct (field (ref $FuncType_151)) (field i32))))
  (type $ClosureType_534 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_535 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_536 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_537 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_538 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_539 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_540 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_541 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_542 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_543 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_544 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_545 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_546 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_547 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_548 (sub $ClosureBase_209 (struct (field (ref $FuncType_151)) (field i32) (field i32))))
  (type $ClosureType_549 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)) (field i32))))
  (type $ClosureType_550 (sub $ClosureBase_258 (struct (field (ref $FuncType_257)))))
  (type $ClosureType_551 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_552 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_553 (sub $ClosureBase_258 (struct (field (ref $FuncType_257)))))
  (type $ClosureType_554 (sub $ClosureBase_258 (struct (field (ref $FuncType_257)))))
  (type $ClosureType_555 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_556 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_557 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_558 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_559 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $ClosureType_560 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_561 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_562 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_563 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_564 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_565 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_566 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_567 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_568 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_569 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_570 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_571 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_572 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_573 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_574 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_575 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_576 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_577 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_578 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_579 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_580 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_581 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_582 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_583 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_584 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_585 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_586 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_587 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $QuickTestWasmGc_TestsList_EnglishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $vtbl_QuickTestWasmGc_TestsList_IGreeter (sub (struct (field (ref $FuncType_61)))))
  (type $box_QuickTestWasmGc_TestsList_IGreeter (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsList_IGreeter)) (field (ref eq)))))
  (type $QuickTestWasmGc_TestsList_SpanishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $ClosureType_592 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_593 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_594 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_595 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_596 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_597 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_598 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_599 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $Tuple_600 (sub (struct (field (ref null $ListBase)) (field (ref null $ListBase)))))
  (type $ClosureType_601 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_602 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_603 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_604 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_605 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_606 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_607 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_608 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_609 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ListCons_610 (sub $ListBase (struct (field (ref $WasmStr)) (field (ref null $ListBase)))))
  (type $FuncType_611 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $WasmStr)) (result i32)))
  (type $ClosureBase_612 (sub $AnyFn (struct (field (ref $FuncType_611)))))
  (type $ClosureType_613 (sub $ClosureBase_612 (struct (field (ref $FuncType_611)))))
  (type $GcArray_614 (array (mut (ref null $WasmStr))))
  (type $ClosureType_615 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_616 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_617 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_618 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_619 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_620 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_621 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsList_MathExpr (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsList_MathExpr#0 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsList_MathExpr#1 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsList_MathExpr)) (field (ref $QuickTestWasmGc_TestsList_MathExpr)))))
  (type $QuickTestWasmGc_TestsList_MathExpr#2 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsList_MathExpr)) (field (ref $QuickTestWasmGc_TestsList_MathExpr)))))
  (type $ClosureType_626 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_627 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)))))
  (type $ClosureType_628 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_629 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $ClosureType_630 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_631 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_632 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_633 (sub $ClosureBase_114 (struct (field (ref $FuncType_113)))))
  (type $ClosureType_634 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureType_635 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_636 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_637 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_638 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_639 (sub $ClosureBase_383 (struct (field (ref $FuncType_382)) (field i32) (field i32))))
  (type $ClosureType_640 (sub $ClosureBase_28 (struct (field (ref $FuncType_27)) (field i32))))
  (type $ClosureType_641 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_642 (sub $ClosureBase_40 (struct (field (ref $FuncType_39)))))
  (type $ClosureBase_643 (sub $AnyFn (struct (field (ref $FuncType_217)))))
  (type $ClosureBase_644 (sub $AnyFn (struct (field (ref $FuncType_418)))))
  ;; ── Imports ────────────────────────────────────────
  (import "testEnv" "wasmAdd" (func $testEnv_wasmAdd (param i32) (param i32) (result i32)))
  (import "testEnv" "wasmMul" (func $testEnv_wasmMul (param i32) (param i32) (result i32)))
  (import "env" "consolePrint" (func $consolePrint (param (ref $WasmStr))))
  ;; ── Tags (exception handling) ──────────────────────
  (tag $fsharp_exn)
  ;; ── Functions ──────────────────────────────────────
  (func $strConcat (param $a (ref $WasmStr)) (param $b (ref $WasmStr)) (result (ref $WasmStr))
    (local $la i32)
    (local $lb i32)
    (local $res (ref $WasmStr))
    local.get $a
    array.len
    local.set $la
    local.get $b
    array.len
    local.set $lb
    i32.const 0
    local.get $la
    local.get $lb
    i32.add
    array.new $WasmStr
    local.set $res
    local.get $res
    i32.const 0
    local.get $a
    i32.const 0
    local.get $la
    array.copy $WasmStr $WasmStr
    local.get $res
    local.get $la
    local.get $b
    i32.const 0
    local.get $lb
    array.copy $WasmStr $WasmStr
    local.get $res
  )
  (func $strEq (param $a (ref $WasmStr)) (param $b (ref $WasmStr)) (result i32)
    (local $la i32)
    (local $lb i32)
    (local $i i32)
    local.get $a
    array.len
    local.set $la
    local.get $b
    array.len
    local.set $lb
    local.get $la
    local.get $lb
    i32.ne
    if (result i32)
      i32.const 0
    else
      i32.const 0
      local.set $i
      block $q_wl_1_exit
        loop $q_wl_1
          local.get $i
          local.get $la
          i32.lt_s
          if (result i32)
            local.get $a
            local.get $i
            array.get $WasmStr
            local.get $b
            local.get $i
            array.get $WasmStr
            i32.eq
          else
            i32.const 0
          end
          if
            local.get $i
            i32.const 1
            i32.add
            local.set $i
            br $q_wl_1
          else
            br $q_wl_1_exit
          end
        end
      end
      local.get $i
      local.get $la
      i32.eq
      if (result i32)
        i32.const 1
      else
        i32.const 0
      end
    end
  )
  (func $strIndexOf (param $strIdx_ha (ref $WasmStr)) (param $strIdx_ne (ref $WasmStr)) (result i32)
    (local $w1215 i32)
    (local $w1216 i32)
    (local $w1217 i32)
    (local $w1218 i32)
    local.get $strIdx_ha
    array.len
    local.set $w1215
    local.get $strIdx_ne
    array.len
    local.set $w1216
    block $strIdx_1214_outer (result i32)
      local.get $w1216
      i32.const 0
      i32.eq
      if
        i32.const 0
        br $strIdx_1214_outer
      end
      i32.const 0
      local.set $w1217
      block $while_1220_exit
        loop $while_1220_lp
          local.get $w1217
          local.get $w1215
          local.get $w1216
          i32.sub
          i32.le_s
          if
            block $strIdx_1214_match
              i32.const 0
              local.set $w1218
              block $while_1219_exit
                loop $while_1219_lp
                  local.get $w1218
                  local.get $w1216
                  i32.lt_s
                  if
                    local.get $strIdx_ha
                    local.get $w1217
                    local.get $w1218
                    i32.add
                    array.get $WasmStr
                    local.get $strIdx_ne
                    local.get $w1218
                    array.get $WasmStr
                    i32.ne
                    if
                      br $strIdx_1214_match
                    end
                    local.get $w1218
                    i32.const 1
                    i32.add
                    local.set $w1218
                    br $while_1219_lp
                  else
                    br $while_1219_exit
                  end
                end
              end
              local.get $w1217
              br $strIdx_1214_outer
            end
            local.get $w1217
            i32.const 1
            i32.add
            local.set $w1217
            br $while_1220_lp
          else
            br $while_1220_exit
          end
        end
      end
      i32.const -1
    end
  )
  (func $strLastIndexOf (param $ha (ref $WasmStr)) (param $ne (ref $WasmStr)) (result i32)
    (local $la i32)
    (local $lb i32)
    (local $result i32)
    (local $i i32)
    (local $j i32)
    local.get $ha
    array.len
    local.set $la
    local.get $ne
    array.len
    local.set $lb
    local.get $lb
    i32.const 0
    i32.eq
    if (result i32)
      local.get $la
    else
      i32.const -1
      local.set $result
      local.get $la
      local.get $lb
      i32.sub
      local.set $i
      block $q_wl_1_exit
        loop $q_wl_1
          local.get $result
          i32.const -1
          i32.eq
          if (result i32)
            local.get $i
            i32.const 0
            i32.ge_s
          else
            i32.const 0
          end
          if
            i32.const 0
            local.set $j
            block $q_wl_2_exit
              loop $q_wl_2
                local.get $j
                local.get $lb
                i32.lt_s
                if (result i32)
                  local.get $ha
                  local.get $i
                  local.get $j
                  i32.add
                  array.get $WasmStr
                  local.get $ne
                  local.get $j
                  array.get $WasmStr
                  i32.eq
                else
                  i32.const 0
                end
                if
                  local.get $j
                  i32.const 1
                  i32.add
                  local.set $j
                  br $q_wl_2
                else
                  br $q_wl_2_exit
                end
              end
            end
            local.get $j
            local.get $lb
            i32.ge_s
            if
              local.get $i
              local.set $result
            end
            local.get $i
            i32.const 1
            i32.sub
            local.set $i
            br $q_wl_1
          else
            br $q_wl_1_exit
          end
        end
      end
      local.get $result
    end
  )
  (func $strSubstring (param $src (ref $WasmStr)) (param $start i32) (param $len i32) (result (ref $WasmStr))
    (local $res (ref $WasmStr))
    i32.const 0
    local.get $len
    array.new $WasmStr
    local.set $res
    local.get $res
    i32.const 0
    local.get $src
    local.get $start
    local.get $len
    array.copy $WasmStr $WasmStr
    local.get $res
  )
  (func $strToLower (param $s (ref $WasmStr)) (result (ref $WasmStr))
    (local $len i32)
    (local $res (ref $WasmStr))
    (local $i i32)
    (local $c i32)
    local.get $s
    array.len
    local.set $len
    i32.const 0
    local.get $len
    array.new $WasmStr
    local.set $res
    i32.const 0
    local.set $i
    block $q_fl_1_exit
      loop $q_fl_1
        local.get $i
        local.get $len
        i32.const 1
        i32.sub
        i32.le_s
        if
          local.get $s
          local.get $i
          array.get $WasmStr
          local.set $c
          local.get $res
          local.get $i
          local.get $c
          i32.const 65
          i32.ge_s
          if (result i32)
            local.get $c
            i32.const 90
            i32.le_s
          else
            i32.const 0
          end
          if (result i32)
            local.get $c
            i32.const 32
            i32.add
          else
            local.get $c
          end
          array.set $WasmStr
          local.get $i
          i32.const 1
          i32.add
          local.set $i
          br $q_fl_1
        else
          br $q_fl_1_exit
        end
      end
    end
    local.get $res
  )
  (func $strToUpper (param $s (ref $WasmStr)) (result (ref $WasmStr))
    (local $len i32)
    (local $res (ref $WasmStr))
    (local $i i32)
    (local $c i32)
    local.get $s
    array.len
    local.set $len
    i32.const 0
    local.get $len
    array.new $WasmStr
    local.set $res
    i32.const 0
    local.set $i
    block $q_fl_1_exit
      loop $q_fl_1
        local.get $i
        local.get $len
        i32.const 1
        i32.sub
        i32.le_s
        if
          local.get $s
          local.get $i
          array.get $WasmStr
          local.set $c
          local.get $res
          local.get $i
          local.get $c
          i32.const 97
          i32.ge_s
          if (result i32)
            local.get $c
            i32.const 122
            i32.le_s
          else
            i32.const 0
          end
          if (result i32)
            local.get $c
            i32.const 32
            i32.sub
          else
            local.get $c
          end
          array.set $WasmStr
          local.get $i
          i32.const 1
          i32.add
          local.set $i
          br $q_fl_1
        else
          br $q_fl_1_exit
        end
      end
    end
    local.get $res
  )
  (func $strTrim (param $src (ref $WasmStr)) (result (ref $WasmStr))
    (local $len i32)
    (local $s i32)
    (local $e i32)
    (local $resLen i32)
    (local $res (ref $WasmStr))
    local.get $src
    array.len
    local.set $len
    i32.const 0
    local.set $s
    local.get $len
    local.set $e
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $s
        local.get $len
        i32.lt_s
        if (result i32)
          local.get $src
          local.get $s
          array.get $WasmStr
          i32.const 32
          i32.le_s
        else
          i32.const 0
        end
        if
          local.get $s
          i32.const 1
          i32.add
          local.set $s
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    block $q_wl_2_exit
      loop $q_wl_2
        local.get $e
        local.get $s
        i32.gt_s
        if (result i32)
          local.get $src
          local.get $e
          i32.const 1
          i32.sub
          array.get $WasmStr
          i32.const 32
          i32.le_s
        else
          i32.const 0
        end
        if
          local.get $e
          i32.const 1
          i32.sub
          local.set $e
          br $q_wl_2
        else
          br $q_wl_2_exit
        end
      end
    end
    local.get $e
    local.get $s
    i32.sub
    local.set $resLen
    i32.const 0
    local.get $resLen
    array.new $WasmStr
    local.set $res
    local.get $res
    i32.const 0
    local.get $src
    local.get $s
    local.get $resLen
    array.copy $WasmStr $WasmStr
    local.get $res
  )
  (func $strTrimStart (param $src (ref $WasmStr)) (result (ref $WasmStr))
    (local $len i32)
    (local $s i32)
    (local $res (ref $WasmStr))
    local.get $src
    array.len
    local.set $len
    i32.const 0
    local.set $s
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $s
        local.get $len
        i32.lt_s
        if (result i32)
          local.get $src
          local.get $s
          array.get $WasmStr
          i32.const 32
          i32.le_s
        else
          i32.const 0
        end
        if
          local.get $s
          i32.const 1
          i32.add
          local.set $s
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    i32.const 0
    local.get $len
    local.get $s
    i32.sub
    array.new $WasmStr
    local.set $res
    local.get $res
    i32.const 0
    local.get $src
    local.get $s
    local.get $len
    local.get $s
    i32.sub
    array.copy $WasmStr $WasmStr
    local.get $res
  )
  (func $strTrimEnd (param $src (ref $WasmStr)) (result (ref $WasmStr))
    (local $len i32)
    (local $e i32)
    (local $res (ref $WasmStr))
    local.get $src
    array.len
    local.set $len
    local.get $len
    local.set $e
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $e
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $src
          local.get $e
          i32.const 1
          i32.sub
          array.get $WasmStr
          i32.const 32
          i32.le_s
        else
          i32.const 0
        end
        if
          local.get $e
          i32.const 1
          i32.sub
          local.set $e
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    i32.const 0
    local.get $e
    array.new $WasmStr
    local.set $res
    local.get $res
    i32.const 0
    local.get $src
    i32.const 0
    local.get $e
    array.copy $WasmStr $WasmStr
    local.get $res
  )
  (func $strPadLeft (param $src (ref $WasmStr)) (param $width i32) (result (ref $WasmStr))
    (local $la i32)
    (local $res (ref $WasmStr))
    local.get $src
    array.len
    local.set $la
    local.get $la
    local.get $width
    i32.ge_s
    if (result (ref $WasmStr))
      local.get $src
    else
      i32.const 32
      local.get $width
      array.new $WasmStr
      local.set $res
      local.get $res
      local.get $width
      local.get $la
      i32.sub
      local.get $src
      i32.const 0
      local.get $la
      array.copy $WasmStr $WasmStr
      local.get $res
    end
  )
  (func $strPadRight (param $src (ref $WasmStr)) (param $width i32) (result (ref $WasmStr))
    (local $la i32)
    (local $res (ref $WasmStr))
    local.get $src
    array.len
    local.set $la
    local.get $la
    local.get $width
    i32.ge_s
    if (result (ref $WasmStr))
      local.get $src
    else
      i32.const 32
      local.get $width
      array.new $WasmStr
      local.set $res
      local.get $res
      i32.const 0
      local.get $src
      i32.const 0
      local.get $la
      array.copy $WasmStr $WasmStr
      local.get $res
    end
  )
  (func $strReplace (param $src (ref $WasmStr)) (param $frm (ref $WasmStr)) (param $repl (ref $WasmStr)) (result (ref $WasmStr))
    (local $lo i32)
    (local $la i32)
    (local $pos i32)
    (local $acc (ref $WasmStr))
    (local $more i32)
    (local $j i32)
    local.get $frm
    array.len
    local.set $lo
    local.get $lo
    i32.const 0
    i32.eq
    if (result (ref $WasmStr))
      local.get $src
    else
      local.get $src
      array.len
      local.set $la
      i32.const 0
      local.set $pos
      i32.const 0
      i32.const 0
      array.new $WasmStr
      local.set $acc
      i32.const 1
      local.set $more
      block $q_wl_1_exit
        loop $q_wl_1
          local.get $more
          i32.const 1
          i32.eq
          if
            local.get $src
            local.get $pos
            local.get $la
            local.get $pos
            i32.sub
            call $strSubstring
            local.get $frm
            call $strIndexOf
            local.set $j
            local.get $j
            i32.const 0
            i32.lt_s
            if
              i32.const 0
              local.set $more
            else
              local.get $acc
              local.get $src
              local.get $pos
              local.get $j
              call $strSubstring
              call $strConcat
              local.get $repl
              call $strConcat
              local.set $acc
              local.get $pos
              local.get $j
              i32.add
              local.get $lo
              i32.add
              local.set $pos
            end
            br $q_wl_1
          else
            br $q_wl_1_exit
          end
        end
      end
      local.get $acc
      local.get $src
      local.get $pos
      local.get $la
      local.get $pos
      i32.sub
      call $strSubstring
      call $strConcat
    end
  )
  (func $strCompare (param $a (ref $WasmStr)) (param $b (ref $WasmStr)) (result i32)
    (local $la i32)
    (local $lb i32)
    (local $minLen i32)
    (local $i i32)
    local.get $a
    array.len
    local.set $la
    local.get $b
    array.len
    local.set $lb
    local.get $la
    local.get $lb
    i32.lt_s
    if (result i32)
      local.get $la
    else
      local.get $lb
    end
    local.set $minLen
    i32.const 0
    local.set $i
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $i
        local.get $minLen
        i32.lt_s
        if (result i32)
          local.get $a
          local.get $i
          array.get $WasmStr
          local.get $b
          local.get $i
          array.get $WasmStr
          i32.eq
        else
          i32.const 0
        end
        if
          local.get $i
          i32.const 1
          i32.add
          local.set $i
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    local.get $i
    local.get $minLen
    i32.eq
    if (result i32)
      local.get $la
      local.get $lb
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        local.get $la
        local.get $lb
        i32.lt_s
        if (result i32)
          i32.const -1
        else
          i32.const 0
        end
      end
    else
      local.get $a
      local.get $i
      array.get $WasmStr
      local.get $b
      local.get $i
      array.get $WasmStr
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        i32.const -1
      end
    end
  )
  (func $strSplit (param $ssp_src (ref $WasmStr)) (param $ssp_del (ref $WasmStr)) (result (ref $GcArray_172))
    (local $ssp_dl i32)
    (local $ssp_pos i32)
    (local $ssp_cnt i32)
    (local $ssp_j i32)
    (local $ssp_arr (ref $GcArray_172))
    (local $ssp_idx i32)
    local.get $ssp_del
    array.len
    local.set $ssp_dl
    local.get $ssp_dl
    i32.const 0
    i32.eq
    if (result (ref $GcArray_172))
      local.get $ssp_src
      array.new_fixed $GcArray_172 1
    else
      i32.const 0
      local.set $ssp_pos
      i32.const 1
      local.set $ssp_cnt
      block $ssp_cnt_done
        loop $ssp_cnt_loop
          local.get $ssp_src
          local.get $ssp_pos
          local.get $ssp_src
          array.len
          local.get $ssp_pos
          i32.sub
          call $strSubstring
          local.get $ssp_del
          call $strIndexOf
          local.set $ssp_j
          local.get $ssp_j
          i32.const 0
          i32.lt_s
          if
            br $ssp_cnt_done
          else
            local.get $ssp_cnt
            i32.const 1
            i32.add
            local.set $ssp_cnt
            local.get $ssp_pos
            local.get $ssp_j
            local.get $ssp_dl
            i32.add
            i32.add
            local.set $ssp_pos
            br $ssp_cnt_loop
          end
        end
      end
      array.new_fixed $WasmStr 0
      local.get $ssp_cnt
      array.new $GcArray_172
      local.set $ssp_arr
      i32.const 0
      local.set $ssp_pos
      i32.const 0
      local.set $ssp_idx
      block $ssp_fill_done
        loop $ssp_fill_loop
          local.get $ssp_src
          local.get $ssp_pos
          local.get $ssp_src
          array.len
          local.get $ssp_pos
          i32.sub
          call $strSubstring
          local.get $ssp_del
          call $strIndexOf
          local.set $ssp_j
          local.get $ssp_j
          i32.const 0
          i32.lt_s
          if
            br $ssp_fill_done
          else
            local.get $ssp_arr
            local.get $ssp_idx
            local.get $ssp_src
            local.get $ssp_pos
            local.get $ssp_j
            call $strSubstring
            array.set $GcArray_172
            local.get $ssp_idx
            i32.const 1
            i32.add
            local.set $ssp_idx
            local.get $ssp_pos
            local.get $ssp_j
            local.get $ssp_dl
            i32.add
            i32.add
            local.set $ssp_pos
            br $ssp_fill_loop
          end
        end
      end
      local.get $ssp_arr
      local.get $ssp_idx
      local.get $ssp_src
      local.get $ssp_pos
      local.get $ssp_src
      array.len
      local.get $ssp_pos
      i32.sub
      call $strSubstring
      array.set $GcArray_172
      local.get $ssp_arr
    end
  )
  (func $strJoin (param $sj_sep (ref $WasmStr)) (param $sj_arr (ref $GcArray_172)) (result (ref $WasmStr))
    (local $sj_len i32)
    (local $sj_res (ref $WasmStr))
    (local $sj_i i32)
    local.get $sj_arr
    array.len
    local.set $sj_len
    block $sj_ret (result (ref $WasmStr))
      local.get $sj_len
      i32.const 0
      i32.eq
      if (result (ref $WasmStr))
        array.new_fixed $WasmStr 0
        br $sj_ret
      else
        local.get $sj_arr
        i32.const 0
        array.get $GcArray_172
        local.set $sj_res
        i32.const 1
        local.set $sj_i
        block $sj_loop_exit
          loop $sj_loop
            local.get $sj_i
            local.get $sj_len
            i32.lt_s
            if
              local.get $sj_res
              local.get $sj_sep
              call $strConcat
              local.get $sj_arr
              local.get $sj_i
              array.get $GcArray_172
              call $strConcat
              local.set $sj_res
              local.get $sj_i
              i32.const 1
              i32.add
              local.set $sj_i
              br $sj_loop
            else
              br $sj_loop_exit
            end
          end
        end
        local.get $sj_res
      end
    end
  )
  (func $intToStr (param $n i32) (result (ref $WasmStr))
    (local $neg i32)
    (local $v i32)
    (local $buf (ref $WasmStr))
    (local $len i32)
    (local $res (ref $WasmStr))
    (local $i i32)
    (local $r2 (ref $WasmStr))
    local.get $n
    i32.const 0
    i32.eq
    if (result (ref $WasmStr))
      i32.const 48
      i32.const 1
      array.new $WasmStr
    else
      i32.const 0
      local.set $neg
      local.get $n
      local.set $v
      local.get $n
      i32.const 0
      i32.lt_s
      if
        i32.const 1
        local.set $neg
        i32.const 0
        local.get $n
        i32.sub
        local.set $v
      end
      i32.const 0
      i32.const 12
      array.new $WasmStr
      local.set $buf
      i32.const 0
      local.set $len
      block $q_wl_1_exit
        loop $q_wl_1
          local.get $v
          i32.const 0
          i32.ne
          if
            local.get $buf
            local.get $len
            local.get $v
            i32.const 10
            i32.rem_s
            i32.const 48
            i32.add
            array.set $WasmStr
            local.get $v
            i32.const 10
            i32.div_s
            local.set $v
            local.get $len
            i32.const 1
            i32.add
            local.set $len
            br $q_wl_1
          else
            br $q_wl_1_exit
          end
        end
      end
      i32.const 0
      local.get $len
      array.new $WasmStr
      local.set $res
      i32.const 0
      local.set $i
      block $q_fl_2_exit
        loop $q_fl_2
          local.get $i
          local.get $len
          i32.const 1
          i32.sub
          i32.le_s
          if
            local.get $res
            local.get $i
            local.get $buf
            local.get $len
            local.get $i
            i32.sub
            i32.const 1
            i32.sub
            array.get $WasmStr
            array.set $WasmStr
            local.get $i
            i32.const 1
            i32.add
            local.set $i
            br $q_fl_2
          else
            br $q_fl_2_exit
          end
        end
      end
      local.get $neg
      i32.const 0
      i32.ne
      if (result (ref $WasmStr))
        i32.const 0
        local.get $len
        i32.const 1
        i32.add
        array.new $WasmStr
        local.set $r2
        local.get $r2
        i32.const 0
        i32.const 45
        array.set $WasmStr
        local.get $r2
        i32.const 1
        local.get $res
        i32.const 0
        local.get $len
        array.copy $WasmStr $WasmStr
        local.get $r2
      else
        local.get $res
      end
    end
  )
  (func $charIsUpper (param $c i32) (result i32)
    local.get $c
    i32.const 65
    i32.ge_s
    if (result i32)
      local.get $c
      i32.const 90
      i32.le_s
    else
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $charIsLower (param $c i32) (result i32)
    local.get $c
    i32.const 97
    i32.ge_s
    if (result i32)
      local.get $c
      i32.const 122
      i32.le_s
    else
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $pown (param $x i32) (param $n i32) (result i32)
    (local $result i32)
    (local $b i32)
    (local $e i32)
    i32.const 1
    local.set $result
    local.get $x
    local.set $b
    local.get $n
    local.set $e
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $e
        i32.const 0
        i32.gt_s
        if
          local.get $e
          i32.const 1
          i32.and
          i32.const 0
          i32.ne
          if
            local.get $result
            local.get $b
            i32.mul
            local.set $result
          end
          local.get $b
          local.get $b
          i32.mul
          local.set $b
          local.get $e
          i32.const 1
          i32.shr_s
          local.set $e
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    local.get $result
  )
  (func $powF64 (param $x f64) (param $n f64) (result f64)
    (local $result f64)
    (local $b f64)
    (local $e i32)
    f64.const 1
    local.set $result
    local.get $x
    local.set $b
    local.get $n
    i32.trunc_f64_s
    local.set $e
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $e
        i32.const 0
        i32.gt_s
        if
          local.get $e
          i32.const 1
          i32.and
          i32.const 0
          i32.ne
          if
            local.get $result
            local.get $b
            f64.mul
            local.set $result
          end
          local.get $b
          local.get $b
          f64.mul
          local.set $b
          local.get $e
          i32.const 1
          i32.shr_s
          local.set $e
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    local.get $result
  )
  (func $mathExp (param $x f64) (result f64)
    (local $k i32)
    (local $r f64)
    (local $er f64)
    (local $pw f64)
    (local $bv f64)
    (local $ki i32)
    local.get $x
    f64.const 0.69314718055994529
    f64.div
    f64.const 0.5
    f64.add
    i32.trunc_f64_s
    local.set $k
    local.get $x
    local.get $k
    f64.convert_i32_s
    f64.const 0.69314718055994529
    f64.mul
    f64.sub
    local.set $r
    f64.const 1
    local.get $r
    f64.const 1
    local.get $r
    f64.const 0.5
    local.get $r
    f64.const 0.16666666666666666
    local.get $r
    f64.const 0.041666666666666664
    local.get $r
    f64.const 0.0083333333333333332
    local.get $r
    f64.const 0.0013888888888888889
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    local.set $er
    f64.const 1
    local.set $pw
    f64.const 2
    local.set $bv
    local.get $k
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
      local.get $k
      i32.sub
    else
      local.get $k
    end
    local.set $ki
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $ki
        i32.const 0
        i32.gt_s
        if
          local.get $ki
          i32.const 1
          i32.and
          i32.const 0
          i32.ne
          if
            local.get $pw
            local.get $bv
            f64.mul
            local.set $pw
          end
          local.get $bv
          local.get $bv
          f64.mul
          local.set $bv
          local.get $ki
          i32.const 1
          i32.shr_s
          local.set $ki
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    local.get $k
    i32.const 0
    i32.lt_s
    if (result f64)
      local.get $er
      local.get $pw
      f64.div
    else
      local.get $er
      local.get $pw
      f64.mul
    end
  )
  (func $mathLog (param $x f64) (result f64)
    (local $xx f64)
    (local $adj f64)
    (local $z f64)
    (local $z2 f64)
    (local $term f64)
    (local $res f64)
    (local $denom f64)
    (local $i i32)
    local.get $x
    local.set $xx
    f64.const 0
    local.set $adj
    block $q_wl_1_exit
      loop $q_wl_1
        local.get $xx
        f64.const 2
        f64.gt
        if
          local.get $xx
          f64.const 2
          f64.div
          local.set $xx
          local.get $adj
          f64.const 0.69314718055994529
          f64.add
          local.set $adj
          br $q_wl_1
        else
          br $q_wl_1_exit
        end
      end
    end
    block $q_wl_2_exit
      loop $q_wl_2
        local.get $xx
        f64.const 0.5
        f64.lt
        if
          local.get $xx
          f64.const 2
          f64.mul
          local.set $xx
          local.get $adj
          f64.const 0.69314718055994529
          f64.sub
          local.set $adj
          br $q_wl_2
        else
          br $q_wl_2_exit
        end
      end
    end
    local.get $xx
    f64.const 1
    f64.sub
    local.get $xx
    f64.const 1
    f64.add
    f64.div
    local.set $z
    local.get $z
    local.get $z
    f64.mul
    local.set $z2
    local.get $z
    local.set $term
    f64.const 0
    local.set $res
    f64.const 1
    local.set $denom
    i32.const 0
    local.set $i
    block $q_wl_3_exit
      loop $q_wl_3
        local.get $i
        i32.const 15
        i32.lt_s
        if
          local.get $res
          local.get $term
          local.get $denom
          f64.div
          f64.add
          local.set $res
          local.get $term
          local.get $z2
          f64.mul
          local.set $term
          local.get $denom
          f64.const 2
          f64.add
          local.set $denom
          local.get $i
          i32.const 1
          i32.add
          local.set $i
          br $q_wl_3
        else
          br $q_wl_3_exit
        end
      end
    end
    local.get $res
    f64.const 2
    f64.mul
    local.get $adj
    f64.add
  )
  (func $mathSin (param $x f64) (result f64)
    (local $k f64)
    (local $r f64)
    (local $t f64)
    local.get $x
    f64.const 6.2831853071795862
    f64.div
    i32.trunc_f64_s
    f64.convert_i32_s
    local.set $k
    local.get $x
    f64.const 6.2831853071795862
    local.get $k
    f64.mul
    f64.sub
    local.set $r
    local.get $r
    f64.const 3.1415926535897931
    f64.gt
    if
      local.get $r
      f64.const 6.2831853071795862
      f64.sub
      local.set $r
    end
    local.get $r
    f64.const 3.1415926535897931
    f64.neg
    f64.lt
    if
      local.get $r
      f64.const 6.2831853071795862
      f64.add
      local.set $r
    end
    local.get $r
    local.get $r
    f64.mul
    local.set $t
    local.get $r
    f64.const 1
    local.get $t
    f64.const -0.16666666666666666
    local.get $t
    f64.const 0.0083333333333333332
    local.get $t
    f64.const -0.00019841269841269841
    local.get $t
    f64.const 2.7557319223985888e-06
    local.get $t
    f64.const -2.505210838544172e-08
    local.get $t
    f64.const 1.6059043836821613e-10
    local.get $t
    f64.const -7.6471637318198164e-13
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
  )
  (func $mathCos (param $x f64) (result f64)
    (local $k f64)
    (local $r f64)
    (local $t f64)
    local.get $x
    f64.const 6.2831853071795862
    f64.div
    i32.trunc_f64_s
    f64.convert_i32_s
    local.set $k
    local.get $x
    f64.const 6.2831853071795862
    local.get $k
    f64.mul
    f64.sub
    local.set $r
    local.get $r
    f64.const 3.1415926535897931
    f64.gt
    if
      local.get $r
      f64.const 6.2831853071795862
      f64.sub
      local.set $r
    end
    local.get $r
    f64.const 3.1415926535897931
    f64.neg
    f64.lt
    if
      local.get $r
      f64.const 6.2831853071795862
      f64.add
      local.set $r
    end
    local.get $r
    local.get $r
    f64.mul
    local.set $t
    f64.const 1
    local.get $t
    f64.const -0.5
    local.get $t
    f64.const 0.041666666666666664
    local.get $t
    f64.const -0.0013888888888888889
    local.get $t
    f64.const 2.4801587301587302e-05
    local.get $t
    f64.const -2.7557319223985888e-07
    local.get $t
    f64.const 2.08767569878681e-09
    local.get $t
    f64.const -1.1470745597729725e-11
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
  )
  (func $mathTan (param $x f64) (result f64)
    (local $k f64)
    (local $r f64)
    (local $t f64)
    (local $sinR f64)
    (local $cosR f64)
    local.get $x
    f64.const 6.2831853071795862
    f64.div
    i32.trunc_f64_s
    f64.convert_i32_s
    local.set $k
    local.get $x
    f64.const 6.2831853071795862
    local.get $k
    f64.mul
    f64.sub
    local.set $r
    local.get $r
    f64.const 3.1415926535897931
    f64.gt
    if
      local.get $r
      f64.const 6.2831853071795862
      f64.sub
      local.set $r
    end
    local.get $r
    f64.const 3.1415926535897931
    f64.neg
    f64.lt
    if
      local.get $r
      f64.const 6.2831853071795862
      f64.add
      local.set $r
    end
    local.get $r
    local.get $r
    f64.mul
    local.set $t
    local.get $r
    f64.const 1
    local.get $t
    f64.const -0.16666666666666666
    local.get $t
    f64.const 0.0083333333333333332
    local.get $t
    f64.const -0.00019841269841269841
    local.get $t
    f64.const 2.7557319223985888e-06
    local.get $t
    f64.const -2.505210838544172e-08
    local.get $t
    f64.const 1.6059043836821613e-10
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    local.set $sinR
    f64.const 1
    local.get $t
    f64.const -0.5
    local.get $t
    f64.const 0.041666666666666664
    local.get $t
    f64.const -0.0013888888888888889
    local.get $t
    f64.const 2.4801587301587302e-05
    local.get $t
    f64.const -2.7557319223985888e-07
    local.get $t
    f64.const 2.08767569878681e-09
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    f64.mul
    f64.add
    local.set $cosR
    local.get $sinR
    local.get $cosR
    f64.div
  )
  (func $sbCreate (param $cap i32) (result (ref $StringBuilder))
    i32.const 0
    local.get $cap
    array.new $WasmStr
    i32.const 0
    local.get $cap
    struct.new $StringBuilder
  )
  (func $sbAppend (param $sb (ref $StringBuilder)) (param $s (ref $WasmStr)) (result (ref $StringBuilder))
    (local $oldLen i32)
    (local $sLen i32)
    (local $newLen i32)
    (local $cap i32)
    (local $doubleCap i32)
    (local $newCap i32)
    (local $newBuf (ref $WasmStr))
    local.get $sb
    struct.get $StringBuilder 1
    local.set $oldLen
    local.get $s
    array.len
    local.set $sLen
    local.get $oldLen
    local.get $sLen
    i32.add
    local.set $newLen
    local.get $sb
    struct.get $StringBuilder 2
    local.set $cap
    local.get $newLen
    local.get $cap
    i32.gt_s
    if
      local.get $cap
      i32.const 1
      i32.shl
      local.set $doubleCap
      local.get $doubleCap
      local.get $newLen
      i32.gt_s
      if (result i32)
        local.get $doubleCap
      else
        local.get $newLen
      end
      local.set $newCap
      i32.const 0
      local.get $newCap
      array.new $WasmStr
      local.set $newBuf
      local.get $newBuf
      i32.const 0
      local.get $sb
      struct.get $StringBuilder 0
      i32.const 0
      local.get $oldLen
      array.copy $WasmStr $WasmStr
      local.get $sb
      local.get $newBuf
      struct.set $StringBuilder 0
      local.get $sb
      local.get $newCap
      struct.set $StringBuilder 2
    end
    local.get $sb
    struct.get $StringBuilder 0
    local.get $oldLen
    local.get $s
    i32.const 0
    local.get $sLen
    array.copy $WasmStr $WasmStr
    local.get $sb
    local.get $newLen
    struct.set $StringBuilder 1
    local.get $sb
  )
  (func $sbToString (param $sb (ref $StringBuilder)) (result (ref $WasmStr))
    (local $len i32)
    (local $res (ref $WasmStr))
    local.get $sb
    struct.get $StringBuilder 1
    local.set $len
    i32.const 0
    local.get $len
    array.new $WasmStr
    local.set $res
    local.get $res
    i32.const 0
    local.get $sb
    struct.get $StringBuilder 0
    i32.const 0
    local.get $len
    array.copy $WasmStr $WasmStr
    local.get $res
  )
  (func $closure_4 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbLength (result i32) ;; exported as "testSbLength"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_1 (ref $ClosureBase_5))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_4
    struct.new $ClosureType_6
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_1
    local.get $lo_clo_1
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    local.get $lo_clo_1
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $closure_7 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_8 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $testSbAppendTwo (result i32) ;; exported as "testSbAppendTwo"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_2 (ref $ClosureBase_5))
    (local $lo_clo_3 (ref $ClosureBase_5))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_7
    struct.new $ClosureType_7
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_2
    local.get $lo_clo_2
    local.get $sb
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_2
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    ref.func $closure_8
    struct.new $ClosureType_8
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_3
    local.get $lo_clo_3
    local.get $sb
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_3
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $closure_9 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbGrow (result i32) ;; exported as "testSbGrow"
    (local $sb (ref $StringBuilder))
    (local $forLoopVar i32)
    (local $lo_clo_4 (ref $ClosureBase_5))
    i32.const 16
    call $sbCreate
    local.set $sb
    i32.const 1
    local.set $forLoopVar
    loop $for
      local.get $forLoopVar
      i32.const 20
      i32.le_s
      if
        ref.func $closure_9
        struct.new $ClosureType_9
        ref.cast (ref $ClosureBase_5)
        local.set $lo_clo_4
        local.get $lo_clo_4
        local.get $sb
        i32.const 120
        array.new_fixed $WasmStr 1
        call $sbAppend
        local.get $lo_clo_4
        struct.get $ClosureBase_5 0
        call_ref $FuncType_4
        local.get $forLoopVar
        i32.const 1
        i32.add
        local.set $forLoopVar
        br $for
      end
    end
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $closure_10 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_11 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $closure_12 (param $self (ref $AnyFn)) (param $value_2 (ref $StringBuilder))
    local.get $value_2
  )
  (func $closure_13 (param $self (ref $AnyFn)) (param $value_3 (ref $StringBuilder))
    local.get $value_3
  )
  (func $closure_14 (param $self (ref $AnyFn)) (param $value_4 (ref $StringBuilder))
    local.get $value_4
  )
  (func $testSbChained (result i32) ;; exported as "testSbChained"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_5 (ref $ClosureBase_5))
    (local $lo_clo_6 (ref $ClosureBase_5))
    (local $lo_clo_7 (ref $ClosureBase_5))
    (local $lo_clo_8 (ref $ClosureBase_5))
    (local $lo_clo_9 (ref $ClosureBase_5))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_10
    struct.new $ClosureType_10
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_5
    local.get $lo_clo_5
    local.get $sb
    i32.const 97
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_5
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    ref.func $closure_11
    struct.new $ClosureType_11
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_6
    local.get $lo_clo_6
    local.get $sb
    i32.const 98
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_6
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    ref.func $closure_12
    struct.new $ClosureType_12
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_7
    local.get $lo_clo_7
    local.get $sb
    i32.const 99
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_7
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    ref.func $closure_13
    struct.new $ClosureType_13
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_8
    local.get $lo_clo_8
    local.get $sb
    i32.const 100
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_8
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    ref.func $closure_14
    struct.new $ClosureType_14
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_9
    local.get $lo_clo_9
    local.get $sb
    i32.const 101
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_9
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $roundTo6 (param $x f64) (result i32) ;; exported as "roundTo6"
    local.get $x
    f64.const 1000000
    f64.mul
    f64.nearest
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $runStringBuilderTests (param $check (ref $AnyFn)) ;; exported as "runStringBuilderTests"
  )
  (func $testBitwiseAnd (result i32) ;; exported as "testBitwiseAnd"
    i32.const 1
  )
  (func $testBitwiseOr (result i32) ;; exported as "testBitwiseOr"
    i32.const 7
  )
  (func $testBitwiseXor (result i32) ;; exported as "testBitwiseXor"
    i32.const 6
  )
  (func $testShiftLeft (result i32) ;; exported as "testShiftLeft"
    i32.const 8
  )
  (func $testShiftRight (result i32) ;; exported as "testShiftRight"
    i32.const 8
  )
  (func $testIntDiv (result i32) ;; exported as "testIntDiv"
    i32.const 3
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testIntMod (result i32) ;; exported as "testIntMod"
    i32.const 1
  )
  (func $testAbsNeg (result i32) ;; exported as "testAbsNeg"
    i32.const 42
  )
  (func $testAbsPos (result i32) ;; exported as "testAbsPos"
    i32.const 7
  )
  (func $testMinScalar (result i32) ;; exported as "testMinScalar"
    i32.const 3
  )
  (func $testMaxScalar (result i32) ;; exported as "testMaxScalar"
    i32.const 7
  )
  (func $testNegation (result i32) ;; exported as "testNegation"
    i32.const 5
  )
  (func $runBitwiseTests (param $check (ref $AnyFn)) ;; exported as "runBitwiseTests"
  )
  (func $testExnNestedFailwith (result i32) ;; exported as "testExnNestedFailwith"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                (block (result i32)
                  (block
                    (try_table (result i32) (catch_all 0)
                            i32.const 108
                            i32.const 101
                            i32.const 118
                            i32.const 101
                            i32.const 108
                            i32.const 32
                            i32.const 49
                            array.new_fixed $WasmStr 7
                            struct.new $Exception
                            global.set $fsharp_exn_carrier
                            ref.null any
                            global.set $fsharp_exn_carrier
                            throw $fsharp_exn
                    )
                    br 1
                  )
                    i32.const 108
                    i32.const 101
                    i32.const 118
                    i32.const 101
                    i32.const 108
                    i32.const 32
                    i32.const 50
                    array.new_fixed $WasmStr 7
                    struct.new $Exception
                    global.set $fsharp_exn_carrier
                    ref.null any
                    global.set $fsharp_exn_carrier
                    throw $fsharp_exn
                )
        )
        br 1
      )
        i32.const 42
    )
  )
  (func $closure_17 (param $self (ref $AnyFn)) (result i32)
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 102
    array.new_fixed $WasmStr 4
    struct.new $Exception
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testExnUnit (result i32) ;; exported as "testExnUnit"
    (local $f (ref $ClosureType_19))
    (local $lo_clo_10 (ref $ClosureBase_56))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                ref.func $closure_17
                struct.new $ClosureType_19
                local.set $f
                local.get $f
                ref.cast (ref $ClosureBase_56)
                local.set $lo_clo_10
                local.get $lo_clo_10
                local.get $lo_clo_10
                struct.get $ClosureBase_56 0
                call_ref $FuncType_20
                i32.const 0
        )
        br 1
      )
        i32.const 7
    )
  )
  (func $testExnNormalPath (result i32) ;; exported as "testExnNormalPath"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 2
        )
        br 1
      )
        i32.const 0
    )
  )
  (func $testExnNestedInnerCatch (result i32) ;; exported as "testExnNestedInnerCatch"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                (block (result i32)
                  (block
                    (try_table (result i32) (catch_all 0)
                            i32.const 105
                            i32.const 110
                            i32.const 110
                            i32.const 101
                            i32.const 114
                            array.new_fixed $WasmStr 5
                            struct.new $Exception
                            global.set $fsharp_exn_carrier
                            ref.null any
                            global.set $fsharp_exn_carrier
                            throw $fsharp_exn
                    )
                    br 1
                  )
                    i32.const 55
                )
        )
        br 1
      )
        i32.const 0
    )
  )
  (func $testExnNestedRethrow (result i32) ;; exported as "testExnNestedRethrow"
    (local $caught i32)
    i32.const 0
    local.set $caught
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                (block (result i32)
                  (block
                    (try_table (result i32) (catch_all 0)
                            i32.const 116
                            i32.const 101
                            i32.const 115
                            i32.const 116
                            array.new_fixed $WasmStr 4
                            struct.new $Exception
                            global.set $fsharp_exn_carrier
                            ref.null any
                            global.set $fsharp_exn_carrier
                            throw $fsharp_exn
                    )
                    br 1
                  )
                    i32.const 1
                    local.set $caught
                    i32.const 114
                    i32.const 101
                    i32.const 116
                    i32.const 104
                    i32.const 114
                    i32.const 111
                    i32.const 119
                    array.new_fixed $WasmStr 7
                    struct.new $Exception
                    global.set $fsharp_exn_carrier
                    ref.null any
                    global.set $fsharp_exn_carrier
                    throw $fsharp_exn
                )
        )
        br 1
      )
        local.get $caught
        i32.const 10
        i32.add
    )
  )
  (func $testExnPairsCatchOrder (result i32) ;; exported as "testExnPairsCatchOrder"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 109
                i32.const 115
                i32.const 103
                array.new_fixed $WasmStr 3
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
        )
        br 1
      )
        i32.const 1
    )
  )
  (func $testExnIntCatch (result i32) ;; exported as "testExnIntCatch"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 109
                i32.const 115
                i32.const 103
                array.new_fixed $WasmStr 3
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
        )
        br 1
      )
        i32.const 2
    )
  )
  (func $testExnStringCatch (result i32) ;; exported as "testExnStringCatch"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 109
                i32.const 115
                i32.const 103
                array.new_fixed $WasmStr 3
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
        )
        br 1
      )
        i32.const 3
    )
  )
  (func $testExnTryFinally (result i32) ;; exported as "testExnTryFinally"
    (local $x i32)
    i32.const 0
    local.set $x
    (block
      (block
        (try_table (catch_all 0)
                i32.const 1
                local.set $x
                i32.const 98
                i32.const 111
                i32.const 111
                i32.const 109
                array.new_fixed $WasmStr 4
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
        )
        br 1
      )
    )
    local.get $x
  )
  (func $testExnTryFinallyWithCatch (result i32) ;; exported as "testExnTryFinallyWithCatch"
    (local $x i32)
    i32.const 0
    local.set $x
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                (block (result i32)
                  (block
                    (try_table (result i32) (catch_all 0)
                            i32.const 1
                            local.set $x
                            i32.const 98
                            i32.const 111
                            i32.const 111
                            i32.const 109
                            array.new_fixed $WasmStr 4
                            struct.new $Exception
                            global.set $fsharp_exn_carrier
                            ref.null any
                            global.set $fsharp_exn_carrier
                            throw $fsharp_exn
                    )
                    br 1
                  )
                )
        )
        br 1
      )
        local.get $x
    )
  )
  (func $testExnCarrierBasic (result i32) ;; exported as "testExnCarrierBasic"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 99
                struct.new $QuickTestWasmGc_TestsExceptions_MyTypedException
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
                i32.const 0
        )
        br 1
      )
        i32.const 42
    )
  )
  (func $testExnTypedPayload (result i32) ;; exported as "testExnTypedPayload"
    (local $matchValue anyref)
    (local $e (ref $QuickTestWasmGc_TestsExceptions_MyTypedException))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 77
                struct.new $QuickTestWasmGc_TestsExceptions_MyTypedException
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
                i32.const 0
        )
        br 1
      )
        global.get $fsharp_exn_carrier
        local.set $matchValue
        local.get $matchValue
        ref.test (ref $QuickTestWasmGc_TestsExceptions_MyTypedException)
        if (result i32)
          local.get $matchValue
          ref.cast (ref $QuickTestWasmGc_TestsExceptions_MyTypedException)
          local.set $e
          local.get $e
          struct.get $QuickTestWasmGc_TestsExceptions_MyTypedException 0
        else
          i32.const 0
        end
    )
  )
  (func $testExnTypeTestDiscriminate (result i32) ;; exported as "testExnTypeTestDiscriminate"
    (local $result i32)
    (local $matchValue anyref)
    i32.const 0
    local.set $result
    (block
      (block
        (try_table (catch_all 0)
                i32.const 103
                i32.const 101
                i32.const 110
                i32.const 101
                i32.const 114
                i32.const 105
                i32.const 99
                i32.const 32
                i32.const 101
                i32.const 114
                i32.const 114
                i32.const 111
                i32.const 114
                array.new_fixed $WasmStr 13
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
                i32.const 1
                local.set $result
        )
        br 1
      )
        global.get $fsharp_exn_carrier
        local.set $matchValue
        local.get $matchValue
        ref.test (ref $QuickTestWasmGc_TestsExceptions_MyTypedException)
        if
          i32.const 20
          local.set $result
        else
          i32.const 99
          local.set $result
        end
    )
    local.get $result
  )
  (func $testExnTypeTestMatch (result i32) ;; exported as "testExnTypeTestMatch"
    (local $matchValue anyref)
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 55
                struct.new $QuickTestWasmGc_TestsExceptions_MyTypedException
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
                i32.const 0
        )
        br 1
      )
        global.get $fsharp_exn_carrier
        local.set $matchValue
        local.get $matchValue
        ref.test (ref $QuickTestWasmGc_TestsExceptions_MyTypedException)
        if (result i32)
          i32.const 1
        else
          i32.const 0
        end
    )
  )
  (func $testExnCarrierInt (result i32) ;; exported as "testExnCarrierInt"
    (local $acc i32)
    (local $i i32)
    (local $matchValue anyref)
    (local $e (ref $QuickTestWasmGc_TestsExceptions_MyTypedException))
    i32.const 0
    local.set $acc
    i32.const 1
    local.set $i
    loop $for
      local.get $i
      i32.const 5
      i32.le_s
      if
        (block
          (block
            (try_table (catch_all 0)
                    local.get $i
                    i32.const 2
                    i32.rem_s
                    i32.const 0
                    i32.eq
                    if
                      local.get $i
                      i32.const 10
                      i32.mul
                      struct.new $QuickTestWasmGc_TestsExceptions_MyTypedException
                      global.set $fsharp_exn_carrier
                      ref.null any
                      global.set $fsharp_exn_carrier
                      throw $fsharp_exn
                    end
            )
            br 1
          )
            global.get $fsharp_exn_carrier
            local.set $matchValue
            local.get $matchValue
            ref.test (ref $QuickTestWasmGc_TestsExceptions_MyTypedException)
            if
              local.get $matchValue
              ref.cast (ref $QuickTestWasmGc_TestsExceptions_MyTypedException)
              local.set $e
              local.get $acc
              local.get $e
              struct.get $QuickTestWasmGc_TestsExceptions_MyTypedException 0
              i32.add
              local.set $acc
            end
        )
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $for
      end
    end
    local.get $acc
  )
  (func $runExceptionsTests (param $check (ref $AnyFn)) ;; exported as "runExceptionsTests"
  )
  (func $testResultMatchOk (result i32) ;; exported as "testResultMatchOk"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    i32.const 42
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
    end
  )
  (func $testResultMatchError (result i32) ;; exported as "testResultMatchError"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 1
    i32.const 7
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 1
    else
      i32.const -1
    end
  )
  (func $testResultIsOk (result i32) ;; exported as "testResultIsOk"
    i32.const 0
    i32.const 1
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testResultIsError (result i32) ;; exported as "testResultIsError"
    i32.const 1
    i32.const 120
    array.new_fixed $WasmStr 1
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> 0
    i32.const 0
    i32.ne
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_27 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testResultMap (result i32) ;; exported as "testResultMap"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w7 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 21
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w7
    local.get $w7
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w7
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.shl
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w7
    end
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
    end
  )
  (func $closure_30 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBind (result i32) ;; exported as "testResultBind"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w8 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 5
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w8
    local.get $w8
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w8
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w8
    end
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
    end
  )
  (func $closure_33 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBindError (result i32) ;; exported as "testResultBindError"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w9 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 1
    i32.const -99
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    local.set $w9
    local.get $w9
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w9
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w9
    end
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 1
    else
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
    end
  )
  (func $testResultModuleIsOk (result i32) ;; exported as "testResultModuleIsOk"
    i32.const 0
    i32.const 5
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testResultModuleIsOkFalse (result i32) ;; exported as "testResultModuleIsOkFalse"
    i32.const 1
    i32.const 0
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testResultModuleIsError (result i32) ;; exported as "testResultModuleIsError"
    i32.const 1
    i32.const 0
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.ne
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testResultModuleIsErrorFalse (result i32) ;; exported as "testResultModuleIsErrorFalse"
    i32.const 0
    i32.const 5
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.ne
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testResultModuleDefaultValueError (result i32) ;; exported as "testResultModuleDefaultValueError"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 1
    i32.const 0
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 42
    else
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
    end
  )
  (func $testResultModuleDefaultValueOk (result i32) ;; exported as "testResultModuleDefaultValueOk"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    i32.const 99
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 42
    else
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
    end
  )
  (func $testResultModuleDefaultErrorOk (result i32) ;; exported as "testResultModuleDefaultErrorOk"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    i32.const 0
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 1
    else
      i32.const 42
    end
  )
  (func $testResultModuleDefaultErrorError (result i32) ;; exported as "testResultModuleDefaultErrorError"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 1
    i32.const 7
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 1
    else
      i32.const 42
    end
  )
  (func $runResultTests (param $check (ref $AnyFn)) ;; exported as "runResultTests"
  )
  (func $closure_34 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
  )
  (func $testHOFSimple (param $x i32) (result i32) ;; exported as "testHOFSimple"
  )
  (func $makeAdder (param $n i32) (param $x i32) (result i32) ;; exported as "makeAdder"
    local.get $x
    local.get $n
    i32.add
  )
  (func $testCapture (param $n i32) (param $x i32) (result i32) ;; exported as "testCapture"
    local.get $n
    local.get $x
    return_call $makeAdder
  )
  (func $applyTwice (param $f (ref $AnyFn)) (param $x i32) (result i32) ;; exported as "applyTwice"
    (local $lo_clo_12 (ref $ClosureBase_28))
    (local $lo_clo_11 (ref $ClosureBase_28))
    local.get $f
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_12
    local.get $lo_clo_12
    local.get $f
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_11
    local.get $lo_clo_11
    local.get $x
    local.get $lo_clo_11
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
    local.get $lo_clo_12
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_35 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
  )
  (func $testApplyTwice (param $x i32) (result i32) ;; exported as "testApplyTwice"
    ref.func $closure_35
    struct.new $ClosureType_35
    local.get $x
    return_call $applyTwice
  )
  (func $makeMultiplier (param $n i32) (param $x i32) (result i32) ;; exported as "makeMultiplier"
    local.get $x
    local.get $n
    i32.mul
  )
  (func $closure_36 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_36))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_36)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_36 1
    local.set $n
    local.get $n
    local.get $x_1
    call $makeMultiplier
  )
  (func $testLetCapture (param $n i32) (param $x i32) (result i32) ;; exported as "testLetCapture"
    (local $mult (ref $ClosureType_36))
    (local $lo_clo_13 (ref $ClosureBase_28))
    ref.func $closure_36
    local.get $n
    struct.new $ClosureType_36
    local.set $mult
    local.get $mult
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_13
    local.get $lo_clo_13
    local.get $x
    local.get $lo_clo_13
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_38 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_37 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w11 (ref null $ListBase))
    (local $w12 i32)
    local.get $list_1
    local.set $w11
    i32.const 0
    local.set $w12
    block $while_13_exit
      loop $while_13_lp
        local.get $w11
        ref.is_null
        i32.eqz
        if
          local.get $w12
          local.get $w11
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w12
          local.get $w11
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w11
          br $while_13_lp
        else
          br $while_13_exit
        end
      end
    end
    local.get $w12
  )
  (func $closure_42 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_42))
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_42)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_42 1
    local.set $offset
    local.get $x
    local.get $offset
    i32.add
  )
  (func $closure_43 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testClosureCapMap (result i32) ;; exported as "testClosureCapMap"
    (local $lo_clo_15 (ref $ClosureBase_40))
    (local $lo_clo_14 (ref $ClosureBase_44))
    (local $mapping (ref $ClosureType_42))
    ref.func $closure_37
    struct.new $ClosureType_41
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_15
    local.get $lo_clo_15
    ref.func $closure_42
    i32.const 10
    struct.new $ClosureType_42
    local.set $mapping
    ref.func $closure_43
    local.get $mapping
    struct.new $ClosureType_45
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_14
    local.get $lo_clo_14
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_14
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.get $lo_clo_15
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_46 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w15 (ref null $ListBase))
    (local $w16 i32)
    local.get $list_1
    local.set $w15
    i32.const 0
    local.set $w16
    block $while_17_exit
      loop $while_17_lp
        local.get $w15
        ref.is_null
        i32.eqz
        if
          local.get $w16
          i32.const 1
          i32.add
          local.set $w16
          local.get $w15
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w15
          br $while_17_lp
        else
          br $while_17_exit
        end
      end
    end
    local.get $w16
  )
  (func $closure_47 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_47))
    (local $threshold i32)
    local.get $self
    ref.cast (ref $ClosureType_47)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_47 1
    local.set $threshold
    local.get $x
    local.get $threshold
    i32.gt_s
  )
  (func $closure_48 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testClosureCapFilter (result i32) ;; exported as "testClosureCapFilter"
    (local $lo_clo_17 (ref $ClosureBase_40))
    (local $lo_clo_16 (ref $ClosureBase_44))
    (local $predicate (ref $ClosureType_47))
    ref.func $closure_46
    struct.new $ClosureType_46
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_17
    local.get $lo_clo_17
    ref.func $closure_47
    i32.const 3
    struct.new $ClosureType_47
    local.set $predicate
    ref.func $closure_48
    local.get $predicate
    struct.new $ClosureType_48
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_16
    local.get $lo_clo_16
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_16
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.get $lo_clo_17
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_49 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_49))
    (local $acc i32)
    (local $multiplier i32)
    local.get $self
    ref.cast (ref $ClosureType_49)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_49 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_49 2
    local.set $multiplier
    local.get $acc
    local.get $x
    local.get $multiplier
    i32.mul
    i32.add
  )
  (func $closure_49 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_52))
    (local $multiplier i32)
    local.get $self
    ref.cast (ref $ClosureType_52)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_52 1
    local.set $multiplier
    ref.func $closure_49
    local.get $acc
    local.get $multiplier
    struct.new $ClosureType_49
  )
  (func $testClosureCapFold (result i32) ;; exported as "testClosureCapFold"
    (local $w19 (ref null $ListBase))
    (local $w20 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w19
    i32.const 0
    local.set $w20
    block $while_21_exit
      loop $while_21_lp
        local.get $w19
        ref.is_null
        i32.eqz
        if
          local.get $w19
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $w20
          local.get $x
          i32.const 1
          i32.shl
          i32.add
          local.set $w20
          local.get $w19
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w19
          br $while_21_lp
        else
          br $while_21_exit
        end
      end
    end
    local.get $w20
  )
  (func $closure_53 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_53))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_53)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_53 1
    local.set $n
    local.get $x
    local.get $n
    i32.add
  )
  (func $closure_53 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_53
    local.get $n
    struct.new $ClosureType_53
  )
  (func $testClosureHigherOrder (result i32) ;; exported as "testClosureHigherOrder"
    (local $makeAdder_1 (ref $ClosureType_54))
    (local $add5 (ref $AnyFn))
    (local $lo_clo_18 (ref $ClosureBase_51))
    (local $add10 (ref $AnyFn))
    (local $lo_clo_19 (ref $ClosureBase_51))
    (local $lo_clo_20 (ref $ClosureBase_28))
    (local $lo_clo_21 (ref $ClosureBase_28))
    ref.func $closure_53
    struct.new $ClosureType_54
    local.set $makeAdder_1
    local.get $makeAdder_1
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_18
    local.get $lo_clo_18
    i32.const 5
    local.get $lo_clo_18
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    local.set $add5
    local.get $makeAdder_1
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_19
    local.get $lo_clo_19
    i32.const 10
    local.get $lo_clo_19
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    local.set $add10
    local.get $add5
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_20
    local.get $lo_clo_20
    i32.const 3
    local.get $lo_clo_20
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
    local.get $add10
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_21
    local.get $lo_clo_21
    i32.const 7
    local.get $lo_clo_21
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
    i32.add
  )
  (func $closure_56 (param $self (ref $AnyFn))
    (local $self_cast (ref $ClosureType_57))
    (local $counter (ref $RefCell_55))
    local.get $self
    ref.cast (ref $ClosureType_57)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_57 1
    local.set $counter
    local.get $counter
    local.get $counter
    struct.get $RefCell_55 0
    i32.const 1
    i32.add
    struct.set $RefCell_55 0
  )
  (func $testClosureCapRef (result i32) ;; exported as "testClosureCapRef"
    (local $counter (ref $RefCell_55))
    (local $increment (ref $ClosureType_57))
    (local $lo_clo_22 (ref $ClosureBase_56))
    (local $lo_clo_23 (ref $ClosureBase_56))
    (local $lo_clo_24 (ref $ClosureBase_56))
    i32.const 0
    struct.new $RefCell_55
    local.set $counter
    ref.func $closure_56
    local.get $counter
    struct.new $ClosureType_57
    local.set $increment
    local.get $increment
    ref.cast (ref $ClosureBase_56)
    local.set $lo_clo_22
    local.get $lo_clo_22
    local.get $lo_clo_22
    struct.get $ClosureBase_56 0
    call_ref $FuncType_20
    local.get $increment
    ref.cast (ref $ClosureBase_56)
    local.set $lo_clo_23
    local.get $lo_clo_23
    local.get $lo_clo_23
    struct.get $ClosureBase_56 0
    call_ref $FuncType_20
    local.get $increment
    ref.cast (ref $ClosureBase_56)
    local.set $lo_clo_24
    local.get $lo_clo_24
    local.get $lo_clo_24
    struct.get $ClosureBase_56 0
    call_ref $FuncType_20
    local.get $counter
    struct.get $RefCell_55 0
  )
  (func $closure_58 (param $self (ref $AnyFn)) (param $m i32) (result i32)
    (local $self_cast (ref $ClosureType_58))
    (local $base_ i32)
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_58)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_58 1
    local.set $base_
    local.get $self_cast
    struct.get $ClosureType_58 2
    local.set $n
    local.get $base_
    local.get $n
    i32.add
    local.get $m
    i32.add
  )
  (func $closure_58 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_59))
    (local $base_ i32)
    local.get $self
    ref.cast (ref $ClosureType_59)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_59 1
    local.set $base_
    ref.func $closure_58
    local.get $base_
    local.get $n
    struct.new $ClosureType_58
  )
  (func $testClosureNestedCapture (result i32) ;; exported as "testClosureNestedCapture"
    (local $outer (ref $ClosureType_59))
    (local $f (ref $AnyFn))
    (local $lo_clo_25 (ref $ClosureBase_51))
    (local $lo_clo_26 (ref $ClosureBase_28))
    ref.func $closure_58
    i32.const 100
    struct.new $ClosureType_59
    local.set $outer
    local.get $outer
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_25
    local.get $lo_clo_25
    i32.const 5
    local.get $lo_clo_25
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    local.set $f
    local.get $f
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_26
    local.get $lo_clo_26
    i32.const 3
    local.get $lo_clo_26
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $runClosuresTests (param $check (ref $AnyFn)) ;; exported as "runClosuresTests"
  )
  (func $testExternAdd (result i32) ;; exported as "testExternAdd"
    i32.const 3
    i32.const 4
    return_call $testEnv_wasmAdd
  )
  (func $testExternAddNeg (result i32) ;; exported as "testExternAddNeg"
    i32.const -5
    i32.const 2
    return_call $testEnv_wasmAdd
  )
  (func $testExternMul (result i32) ;; exported as "testExternMul"
    i32.const 3
    i32.const 4
    return_call $testEnv_wasmMul
  )
  (func $testExternChain (result i32) ;; exported as "testExternChain"
    i32.const 2
    i32.const 3
    call $testEnv_wasmMul
    i32.const 4
    return_call $testEnv_wasmAdd
  )
  (func $QuickTestWasmGc_TestsInterop_EnglishGreeter_Greet (param $this$ (ref $QuickTestWasmGc_TestsInterop_EnglishGreeter)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_TestsInterop_EnglishGreeter 0
    array.len
  )
  (func $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_TestsInterop_EnglishGreeter)
    call $QuickTestWasmGc_TestsInterop_EnglishGreeter_Greet
  )
  (func $QuickTestWasmGc_TestsInterop_SpanishGreeter_Greet (param $this$ (ref $QuickTestWasmGc_TestsInterop_SpanishGreeter)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_TestsInterop_SpanishGreeter 0
    array.len
  )
  (func $QuickTestWasmGc_TestsInterop_SpanishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_TestsInterop_SpanishGreeter)
    call $QuickTestWasmGc_TestsInterop_SpanishGreeter_Greet
  )
  (func $testInterfaceDispatch (result i32) ;; exported as "testInterfaceDispatch"
    (local $g (ref $box_QuickTestWasmGc_TestsInterop_IGreeter))
    global.get $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_vtable
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    struct.new $QuickTestWasmGc_TestsInterop_EnglishGreeter
    struct.new $box_QuickTestWasmGc_TestsInterop_IGreeter
    local.set $g
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 1
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IGreeter 0
    call_ref $FuncType_61
  )
  (func $closure_66 (param $self (ref $AnyFn)) (param $g (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (result i32)
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 1
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IGreeter 0
    call_ref $FuncType_61
  )
  (func $closure_69 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_69 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testInterfacePolymorphism (result i32) ;; exported as "testInterfacePolymorphism"
    (local $greeters (ref null $ListBase))
    (local $lo_clo_27 (ref $ClosureBase_40))
    (local $projection (ref $ClosureType_68))
    global.get $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_vtable
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    struct.new $QuickTestWasmGc_TestsInterop_EnglishGreeter
    struct.new $box_QuickTestWasmGc_TestsInterop_IGreeter
    global.get $QuickTestWasmGc_TestsInterop_SpanishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_vtable
    i32.const 104
    i32.const 111
    i32.const 108
    i32.const 97
    array.new_fixed $WasmStr 4
    struct.new $QuickTestWasmGc_TestsInterop_SpanishGreeter
    struct.new $box_QuickTestWasmGc_TestsInterop_IGreeter
    ref.null $ListBase
    struct.new $ListCons_65
    struct.new $ListCons_65
    local.set $greeters
    ref.func $closure_66
    struct.new $ClosureType_68
    local.set $projection
    ref.func $closure_69
    local.get $projection
    struct.new $ClosureType_70
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_27
    local.get $lo_clo_27
    local.get $greeters
    local.get $lo_clo_27
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $QuickTestWasmGc_TestsInterop_IntShape_Area (param $this$ (ref $QuickTestWasmGc_TestsInterop_IntShape)) (result i32)
    (local $w i32)
    (local $h i32)
    (local $r i32)
    local.get $this$
    struct.get $QuickTestWasmGc_TestsInterop_IntShape 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $this$
      ref.cast (ref $QuickTestWasmGc_TestsInterop_IntShape#1)
      struct.get $QuickTestWasmGc_TestsInterop_IntShape#1 1
      local.set $w
      local.get $this$
      ref.cast (ref $QuickTestWasmGc_TestsInterop_IntShape#1)
      struct.get $QuickTestWasmGc_TestsInterop_IntShape#1 2
      local.set $h
      local.get $w
      local.get $h
      i32.mul
    else
      local.get $this$
      ref.cast (ref $QuickTestWasmGc_TestsInterop_IntShape#0)
      struct.get $QuickTestWasmGc_TestsInterop_IntShape#0 1
      local.set $r
      local.get $r
      local.get $r
      i32.mul
    end
  )
  (func $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_Area_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_TestsInterop_IntShape)
    call $QuickTestWasmGc_TestsInterop_IntShape_Area
  )
  (func $testDuInterfaceCircle (result i32) ;; exported as "testDuInterfaceCircle"
    (local $s (ref $box_QuickTestWasmGc_TestsInterop_IShape))
    global.get $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_vtable
    i32.const 0
    i32.const 3
    struct.new $QuickTestWasmGc_TestsInterop_IntShape#0
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_61
  )
  (func $testDuInterfaceRect (result i32) ;; exported as "testDuInterfaceRect"
    (local $s (ref $box_QuickTestWasmGc_TestsInterop_IShape))
    global.get $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_vtable
    i32.const 1
    i32.const 4
    i32.const 5
    struct.new $QuickTestWasmGc_TestsInterop_IntShape#1
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_61
  )
  (func $closure_77 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_61
  )
  (func $closure_80 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_80 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testDuInterfacePoly (result i32) ;; exported as "testDuInterfacePoly"
    (local $shapes (ref null $ListBase))
    (local $lo_clo_28 (ref $ClosureBase_40))
    (local $projection (ref $ClosureType_79))
    global.get $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_vtable
    i32.const 0
    i32.const 2
    struct.new $QuickTestWasmGc_TestsInterop_IntShape#0
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    global.get $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_vtable
    i32.const 1
    i32.const 3
    i32.const 4
    struct.new $QuickTestWasmGc_TestsInterop_IntShape#1
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    ref.null $ListBase
    struct.new $ListCons_76
    struct.new $ListCons_76
    local.set $shapes
    ref.func $closure_77
    struct.new $ClosureType_79
    local.set $projection
    ref.func $closure_80
    local.get $projection
    struct.new $ClosureType_81
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_28
    local.get $lo_clo_28
    local.get $shapes
    local.get $lo_clo_28
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $ClassCircle_$ctor_Z524259A4 (param $radius i32) (result (ref $QuickTestWasmGc_TestsInterop_ClassCircle))
    local.get $radius
    struct.new $QuickTestWasmGc_TestsInterop_ClassCircle
  )
  (func $QuickTestWasmGc_TestsInterop_ClassCircle_Area (param $this$ (ref $QuickTestWasmGc_TestsInterop_ClassCircle)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_TestsInterop_ClassCircle 0
    local.get $this$
    struct.get $QuickTestWasmGc_TestsInterop_ClassCircle 0
    i32.mul
  )
  (func $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_Area_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_TestsInterop_ClassCircle)
    call $QuickTestWasmGc_TestsInterop_ClassCircle_Area
  )
  (func $ClassRect_$ctor_Z37302880 (param $width i32) (param $height i32) (result (ref $QuickTestWasmGc_TestsInterop_ClassRect))
    local.get $width
    local.get $height
    struct.new $QuickTestWasmGc_TestsInterop_ClassRect
  )
  (func $QuickTestWasmGc_TestsInterop_ClassRect_Area (param $this$ (ref $QuickTestWasmGc_TestsInterop_ClassRect)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_TestsInterop_ClassRect 0
    local.get $this$
    struct.get $QuickTestWasmGc_TestsInterop_ClassRect 1
    i32.mul
  )
  (func $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_Area_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_TestsInterop_ClassRect)
    call $QuickTestWasmGc_TestsInterop_ClassRect_Area
  )
  (func $testClassCircleArea (result i32) ;; exported as "testClassCircleArea"
    (local $c (ref $QuickTestWasmGc_TestsInterop_ClassCircle))
    (local $s (ref $box_QuickTestWasmGc_TestsInterop_IShape))
    i32.const 5
    call $ClassCircle_$ctor_Z524259A4
    local.set $c
    global.get $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_vtable
    local.get $c
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_61
  )
  (func $testClassRectArea (result i32) ;; exported as "testClassRectArea"
    (local $r (ref $QuickTestWasmGc_TestsInterop_ClassRect))
    (local $s (ref $box_QuickTestWasmGc_TestsInterop_IShape))
    i32.const 3
    i32.const 4
    call $ClassRect_$ctor_Z37302880
    local.set $r
    global.get $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_vtable
    local.get $r
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_61
  )
  (func $closure_84 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_61
  )
  (func $closure_85 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_85 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testMixedShapes (result i32) ;; exported as "testMixedShapes"
    (local $shapes (ref null $ListBase))
    (local $lo_clo_29 (ref $ClosureBase_40))
    (local $projection (ref $ClosureType_84))
    global.get $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_vtable
    i32.const 2
    call $ClassCircle_$ctor_Z524259A4
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    global.get $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_vtable
    i32.const 3
    i32.const 4
    call $ClassRect_$ctor_Z37302880
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    global.get $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_vtable
    i32.const 0
    i32.const 1
    struct.new $QuickTestWasmGc_TestsInterop_IntShape#0
    struct.new $box_QuickTestWasmGc_TestsInterop_IShape
    ref.null $ListBase
    struct.new $ListCons_76
    struct.new $ListCons_76
    struct.new $ListCons_76
    local.set $shapes
    ref.func $closure_84
    struct.new $ClosureType_84
    local.set $projection
    ref.func $closure_85
    local.get $projection
    struct.new $ClosureType_86
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_29
    local.get $lo_clo_29
    local.get $shapes
    local.get $lo_clo_29
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $runInteropTests (param $check (ref $AnyFn)) ;; exported as "runInteropTests"
  )
  (func $directionToInt (param $d i32) (result i32) ;; exported as "directionToInt"
    local.get $d
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $d
      i32.const 2
      i32.eq
      if (result i32)
        i32.const 2
      else
        local.get $d
        i32.const 3
        i32.eq
        if (result i32)
          i32.const 3
        else
          i32.const 0
        end
      end
    end
  )
  (func $intToDirection (param $n i32) (result i32) ;; exported as "intToDirection"
    local.get $n
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $n
      i32.const 1
      i32.eq
      if (result i32)
        i32.const 1
      else
        local.get $n
        i32.const 2
        i32.eq
        if (result i32)
          i32.const 2
        else
          i32.const 3
        end
      end
    end
  )
  (func $shapeArea (param $s (ref $QuickTestWasmGc_TestsDU_Shape)) (result f64) ;; exported as "shapeArea"
    (local $s_1 f64)
    (local $w f64)
    (local $h f64)
    (local $r f64)
    local.get $s
    struct.get $QuickTestWasmGc_TestsDU_Shape 0
    i32.const 1
    i32.eq
    if (result f64)
      local.get $s
      ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#1)
      struct.get $QuickTestWasmGc_TestsDU_Shape#1 1
      local.set $s_1
      local.get $s_1
      local.get $s_1
      f64.mul
    else
      local.get $s
      struct.get $QuickTestWasmGc_TestsDU_Shape 0
      i32.const 2
      i32.eq
      if (result f64)
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
        struct.get $QuickTestWasmGc_TestsDU_Shape#2 1
        local.set $w
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
        struct.get $QuickTestWasmGc_TestsDU_Shape#2 2
        local.set $h
        local.get $w
        local.get $h
        f64.mul
      else
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#0)
        struct.get $QuickTestWasmGc_TestsDU_Shape#0 1
        local.set $r
        local.get $r
        local.get $r
        f64.mul
      end
    end
  )
  (func $shapePerimeter (param $s (ref $QuickTestWasmGc_TestsDU_Shape)) (result f64) ;; exported as "shapePerimeter"
    (local $s_1 f64)
    (local $w f64)
    (local $h f64)
    (local $r f64)
    local.get $s
    struct.get $QuickTestWasmGc_TestsDU_Shape 0
    i32.const 1
    i32.eq
    if (result f64)
      local.get $s
      ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#1)
      struct.get $QuickTestWasmGc_TestsDU_Shape#1 1
      local.set $s_1
      f64.const 4
      local.get $s_1
      f64.mul
    else
      local.get $s
      struct.get $QuickTestWasmGc_TestsDU_Shape 0
      i32.const 2
      i32.eq
      if (result f64)
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
        struct.get $QuickTestWasmGc_TestsDU_Shape#2 1
        local.set $w
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
        struct.get $QuickTestWasmGc_TestsDU_Shape#2 2
        local.set $h
        f64.const 2
        local.get $w
        f64.mul
        f64.const 2
        local.get $h
        f64.mul
        f64.add
      else
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#0)
        struct.get $QuickTestWasmGc_TestsDU_Shape#0 1
        local.set $r
        f64.const 4
        local.get $r
        f64.mul
      end
    end
  )
  (func $testShapeAreaCircle (param $r f64) (result f64) ;; exported as "testShapeAreaCircle"
    i32.const 0
    local.get $r
    struct.new $QuickTestWasmGc_TestsDU_Shape#0
    return_call $shapeArea
  )
  (func $testShapeAreaSquare (param $s f64) (result f64) ;; exported as "testShapeAreaSquare"
    i32.const 1
    local.get $s
    struct.new $QuickTestWasmGc_TestsDU_Shape#1
    return_call $shapeArea
  )
  (func $testShapeAreaRect (param $w f64) (param $h f64) (result f64) ;; exported as "testShapeAreaRect"
    i32.const 2
    local.get $w
    local.get $h
    struct.new $QuickTestWasmGc_TestsDU_Shape#2
    return_call $shapeArea
  )
  (func $testShapePerimCircle (param $r f64) (result f64) ;; exported as "testShapePerimCircle"
    i32.const 0
    local.get $r
    struct.new $QuickTestWasmGc_TestsDU_Shape#0
    return_call $shapePerimeter
  )
  (func $testShapePerimSquare (param $s f64) (result f64) ;; exported as "testShapePerimSquare"
    i32.const 1
    local.get $s
    struct.new $QuickTestWasmGc_TestsDU_Shape#1
    return_call $shapePerimeter
  )
  (func $testShapePerimRect (param $w f64) (param $h f64) (result f64) ;; exported as "testShapePerimRect"
    i32.const 2
    local.get $w
    local.get $h
    struct.new $QuickTestWasmGc_TestsDU_Shape#2
    return_call $shapePerimeter
  )
  (func $treeSum (param $t (ref $QuickTestWasmGc_TestsDU_Tree)) (result i32) ;; exported as "treeSum"
    (local $v i32)
    (local $r (ref $QuickTestWasmGc_TestsDU_Tree))
    (local $l (ref $QuickTestWasmGc_TestsDU_Tree))
    local.get $t
    struct.get $QuickTestWasmGc_TestsDU_Tree 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $t
      ref.cast (ref $QuickTestWasmGc_TestsDU_Tree#1)
      struct.get $QuickTestWasmGc_TestsDU_Tree#1 3
      local.set $v
      local.get $t
      ref.cast (ref $QuickTestWasmGc_TestsDU_Tree#1)
      struct.get $QuickTestWasmGc_TestsDU_Tree#1 2
      local.set $r
      local.get $t
      ref.cast (ref $QuickTestWasmGc_TestsDU_Tree#1)
      struct.get $QuickTestWasmGc_TestsDU_Tree#1 1
      local.set $l
      local.get $l
      call $treeSum
      local.get $r
      call $treeSum
      i32.add
      local.get $v
      i32.add
    else
      i32.const 0
    end
  )
  (func $testTreeSum (result i32) ;; exported as "testTreeSum"
    (local $t (ref $QuickTestWasmGc_TestsDU_Tree))
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_TestsDU_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_TestsDU_Tree#0
    i32.const 5
    struct.new $QuickTestWasmGc_TestsDU_Tree#1
    local.set $t
    local.get $t
    return_call $treeSum
  )
  (func $testTreeSum2 (result i32) ;; exported as "testTreeSum2"
    (local $t (ref $QuickTestWasmGc_TestsDU_Tree))
    i32.const 1
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_TestsDU_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_TestsDU_Tree#0
    i32.const 2
    struct.new $QuickTestWasmGc_TestsDU_Tree#1
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_TestsDU_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_TestsDU_Tree#0
    i32.const 3
    struct.new $QuickTestWasmGc_TestsDU_Tree#1
    i32.const 10
    struct.new $QuickTestWasmGc_TestsDU_Tree#1
    local.set $t
    local.get $t
    return_call $treeSum
  )
  (func $testRefTestCircle (result i32) ;; exported as "testRefTestCircle"
    (local $s (ref $QuickTestWasmGc_TestsDU_GeoShape))
    i32.const 0
    f64.const 1.5
    struct.new $QuickTestWasmGc_TestsDU_GeoShape#0
    local.set $s
    local.get $s
    struct.get $QuickTestWasmGc_TestsDU_GeoShape 0
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testRefTestRect (result i32) ;; exported as "testRefTestRect"
    (local $s (ref $QuickTestWasmGc_TestsDU_GeoShape))
    i32.const 1
    f64.const 2
    f64.const 3
    struct.new $QuickTestWasmGc_TestsDU_GeoShape#1
    local.set $s
    local.get $s
    struct.get $QuickTestWasmGc_TestsDU_GeoShape 0
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testRefTestDot (result i32) ;; exported as "testRefTestDot"
    (local $s (ref $QuickTestWasmGc_TestsDU_GeoShape))
    i32.const 2
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_TestsDU_GeoShape#2
    local.set $s
    local.get $s
    struct.get $QuickTestWasmGc_TestsDU_GeoShape 0
    i32.const 2
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $evalExpr (param $_arg (ref $QuickTestWasmGc_TestsDU_MathExpr)) (result i32) ;; exported as "evalExpr"
    (local $r (ref $QuickTestWasmGc_TestsDU_MathExpr))
    (local $l (ref $QuickTestWasmGc_TestsDU_MathExpr))
    (local $r_1 (ref $QuickTestWasmGc_TestsDU_MathExpr))
    (local $l_1 (ref $QuickTestWasmGc_TestsDU_MathExpr))
    local.get $_arg
    struct.get $QuickTestWasmGc_TestsDU_MathExpr 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $_arg
      ref.cast (ref $QuickTestWasmGc_TestsDU_MathExpr#1)
      struct.get $QuickTestWasmGc_TestsDU_MathExpr#1 2
      local.set $r
      local.get $_arg
      ref.cast (ref $QuickTestWasmGc_TestsDU_MathExpr#1)
      struct.get $QuickTestWasmGc_TestsDU_MathExpr#1 1
      local.set $l
      local.get $l
      call $evalExpr
      local.get $r
      call $evalExpr
      i32.add
    else
      local.get $_arg
      struct.get $QuickTestWasmGc_TestsDU_MathExpr 0
      i32.const 2
      i32.eq
      if (result i32)
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_TestsDU_MathExpr#2)
        struct.get $QuickTestWasmGc_TestsDU_MathExpr#2 2
        local.set $r_1
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_TestsDU_MathExpr#2)
        struct.get $QuickTestWasmGc_TestsDU_MathExpr#2 1
        local.set $l_1
        local.get $l_1
        call $evalExpr
        local.get $r_1
        call $evalExpr
        i32.mul
      else
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_TestsDU_MathExpr#0)
        struct.get $QuickTestWasmGc_TestsDU_MathExpr#0 1
      end
    end
  )
  (func $testRecursiveDU (result i32) ;; exported as "testRecursiveDU"
    (local $expr (ref $QuickTestWasmGc_TestsDU_MathExpr))
    i32.const 1
    i32.const 2
    i32.const 0
    i32.const 2
    struct.new $QuickTestWasmGc_TestsDU_MathExpr#0
    i32.const 0
    i32.const 3
    struct.new $QuickTestWasmGc_TestsDU_MathExpr#0
    struct.new $QuickTestWasmGc_TestsDU_MathExpr#2
    i32.const 0
    i32.const 4
    struct.new $QuickTestWasmGc_TestsDU_MathExpr#0
    struct.new $QuickTestWasmGc_TestsDU_MathExpr#1
    local.set $expr
    local.get $expr
    return_call $evalExpr
  )
  (func $testDuEnumEqTrue (result i32) ;; exported as "testDuEnumEqTrue"
    i32.const 1
  )
  (func $testDuEnumEqFalse (result i32) ;; exported as "testDuEnumEqFalse"
    i32.const 0
  )
  (func $equals_87 (param $eq_a (ref $QuickTestWasmGc_TestsDU_Shape)) (param $eq_b (ref $QuickTestWasmGc_TestsDU_Shape)) (result i32)
    (local $eq_tag i32)
    local.get $eq_a
    struct.get $QuickTestWasmGc_TestsDU_Shape 0
    local.get $eq_b
    struct.get $QuickTestWasmGc_TestsDU_Shape 0
    i32.ne
    if (result i32)
      i32.const 0
    else
      local.get $eq_a
      struct.get $QuickTestWasmGc_TestsDU_Shape 0
      local.set $eq_tag
      local.get $eq_tag
      i32.const 0
      i32.eq
      if (result i32)
        i32.const 1
        local.get $eq_a
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#0)
        struct.get $QuickTestWasmGc_TestsDU_Shape#0 1
        local.get $eq_b
        ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#0)
        struct.get $QuickTestWasmGc_TestsDU_Shape#0 1
        f64.eq
        i32.and
      else
        local.get $eq_tag
        i32.const 1
        i32.eq
        if (result i32)
          i32.const 1
          local.get $eq_a
          ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#1)
          struct.get $QuickTestWasmGc_TestsDU_Shape#1 1
          local.get $eq_b
          ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#1)
          struct.get $QuickTestWasmGc_TestsDU_Shape#1 1
          f64.eq
          i32.and
        else
          local.get $eq_tag
          i32.const 2
          i32.eq
          if (result i32)
            i32.const 1
            local.get $eq_a
            ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
            struct.get $QuickTestWasmGc_TestsDU_Shape#2 1
            local.get $eq_b
            ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
            struct.get $QuickTestWasmGc_TestsDU_Shape#2 1
            f64.eq
            i32.and
            local.get $eq_a
            ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
            struct.get $QuickTestWasmGc_TestsDU_Shape#2 2
            local.get $eq_b
            ref.cast (ref $QuickTestWasmGc_TestsDU_Shape#2)
            struct.get $QuickTestWasmGc_TestsDU_Shape#2 2
            f64.eq
            i32.and
          else
            i32.const 0
          end
        end
      end
    end
  )
  (func $testDuDataEqTrue (result i32) ;; exported as "testDuDataEqTrue"
    (local $s1 (ref $QuickTestWasmGc_TestsDU_Shape))
    (local $s2 (ref $QuickTestWasmGc_TestsDU_Shape))
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_TestsDU_Shape#0
    local.set $s1
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_TestsDU_Shape#0
    local.set $s2
    local.get $s1
    local.get $s2
    call $equals_87
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testDuDataEqFalse (result i32) ;; exported as "testDuDataEqFalse"
    (local $s1 (ref $QuickTestWasmGc_TestsDU_Shape))
    (local $s2 (ref $QuickTestWasmGc_TestsDU_Shape))
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_TestsDU_Shape#0
    local.set $s1
    i32.const 0
    f64.const 5
    struct.new $QuickTestWasmGc_TestsDU_Shape#0
    local.set $s2
    local.get $s1
    local.get $s2
    call $equals_87
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testDuDataEqDiffCtor (result i32) ;; exported as "testDuDataEqDiffCtor"
    (local $s1 (ref $QuickTestWasmGc_TestsDU_Shape))
    (local $s2 (ref $QuickTestWasmGc_TestsDU_Shape))
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_TestsDU_Shape#0
    local.set $s1
    i32.const 1
    f64.const 3
    struct.new $QuickTestWasmGc_TestsDU_Shape#1
    local.set $s2
    local.get $s1
    local.get $s2
    call $equals_87
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $runDUTests (param $check (ref $AnyFn)) ;; exported as "runDUTests"
  )
  (func $distanceFromOrigin (param $p (ref $QuickTestWasmGc_TestsPrimitives_Point)) (result f64) ;; exported as "distanceFromOrigin"
    local.get $p
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 0
    local.get $p
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 0
    f64.mul
    local.get $p
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 1
    local.get $p
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 1
    f64.mul
    f64.add
  )
  (func $pointSum (param $x f64) (param $y f64) (result f64) ;; exported as "pointSum"
    (local $p (ref $QuickTestWasmGc_TestsPrimitives_Point))
    local.get $x
    local.get $y
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.set $p
    local.get $p
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 0
    local.get $p
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 1
    f64.add
  )
  (func $testDistanceFromOrigin (param $x f64) (param $y f64) (result f64) ;; exported as "testDistanceFromOrigin"
    local.get $x
    local.get $y
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    return_call $distanceFromOrigin
  )
  (func $equals_102 (param $eq_a (ref $QuickTestWasmGc_TestsPrimitives_Point)) (param $eq_b (ref $QuickTestWasmGc_TestsPrimitives_Point)) (result i32)
    i32.const 1
    local.get $eq_a
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 0
    local.get $eq_b
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 0
    f64.eq
    i32.and
    local.get $eq_a
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 1
    local.get $eq_b
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 1
    f64.eq
    i32.and
  )
  (func $testRecordEqTrue (result i32) ;; exported as "testRecordEqTrue"
    (local $p1 (ref $QuickTestWasmGc_TestsPrimitives_Point))
    (local $p2 (ref $QuickTestWasmGc_TestsPrimitives_Point))
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.set $p1
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.set $p2
    local.get $p1
    local.get $p2
    call $equals_102
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testRecordEqFalse (result i32) ;; exported as "testRecordEqFalse"
    (local $p1 (ref $QuickTestWasmGc_TestsPrimitives_Point))
    (local $p2 (ref $QuickTestWasmGc_TestsPrimitives_Point))
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.set $p1
    f64.const 2
    f64.const 1
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.set $p2
    local.get $p1
    local.get $p2
    call $equals_102
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testRecordNeq (result i32) ;; exported as "testRecordNeq"
    (local $p1 (ref $QuickTestWasmGc_TestsPrimitives_Point))
    (local $p2 (ref $QuickTestWasmGc_TestsPrimitives_Point))
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.set $p1
    f64.const 3
    f64.const 4
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.set $p2
    local.get $p1
    local.get $p2
    call $equals_102
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testMutRecord (result i32) ;; exported as "testMutRecord"
    (local $c (ref $QuickTestWasmGc_TestsPrimitives_Counter))
    i32.const 0
    struct.new $QuickTestWasmGc_TestsPrimitives_Counter
    local.set $c
    local.get $c
    local.get $c
    struct.get $QuickTestWasmGc_TestsPrimitives_Counter 0
    i32.const 1
    i32.add
    struct.set $QuickTestWasmGc_TestsPrimitives_Counter 0
    local.get $c
    local.get $c
    struct.get $QuickTestWasmGc_TestsPrimitives_Counter 0
    i32.const 1
    i32.add
    struct.set $QuickTestWasmGc_TestsPrimitives_Counter 0
    local.get $c
    struct.get $QuickTestWasmGc_TestsPrimitives_Counter 0
  )
  (func $rectWidth (param $r (ref $QuickTestWasmGc_TestsPrimitives_Rect)) (result f64) ;; exported as "rectWidth"
    local.get $r
    struct.get $QuickTestWasmGc_TestsPrimitives_Rect 1
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 0
    local.get $r
    struct.get $QuickTestWasmGc_TestsPrimitives_Rect 0
    struct.get $QuickTestWasmGc_TestsPrimitives_Point 0
    f64.sub
  )
  (func $testRectWidth (param $x1 f64) (param $y1 f64) (param $x2 f64) (param $y2 f64) (result f64) ;; exported as "testRectWidth"
    local.get $x1
    local.get $y1
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    local.get $x2
    local.get $y2
    struct.new $QuickTestWasmGc_TestsPrimitives_Point
    struct.new $QuickTestWasmGc_TestsPrimitives_Rect
    return_call $rectWidth
  )
  (func $swapPair (param $a i32) (param $b i32) (result (ref $Tuple_105)) ;; exported as "swapPair"
    local.get $b
    local.get $a
    struct.new $Tuple_105
  )
  (func $testSwapPairFst (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairFst"
    (local $patternInput (ref $Tuple_105))
    local.get $a
    local.get $b
    call $swapPair
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_105 0
  )
  (func $testSwapPairSnd (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairSnd"
    (local $patternInput (ref $Tuple_105))
    local.get $a
    local.get $b
    call $swapPair
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_105 1
  )
  (func $minMax (param $a f64) (param $b f64) (result (ref $Tuple_106)) ;; exported as "minMax"
    local.get $a
    local.get $b
    f64.le
    if (result (ref $Tuple_106))
      local.get $a
      local.get $b
      struct.new $Tuple_106
    else
      local.get $b
      local.get $a
      struct.new $Tuple_106
    end
  )
  (func $testMinMaxFirst (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxFirst"
    (local $patternInput (ref $Tuple_106))
    local.get $a
    local.get $b
    call $minMax
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_106 0
  )
  (func $testMinMaxSecond (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxSecond"
    (local $patternInput (ref $Tuple_106))
    local.get $a
    local.get $b
    call $minMax
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_106 1
  )
  (func $tripleSum (param $t_ i32) (param $t__1 i32) (param $t__2 i32) (result i32) ;; exported as "tripleSum"
    (local $t (ref $Tuple_107))
    (local $c i32)
    (local $b i32)
    (local $a i32)
    local.get $t_
    local.get $t__1
    local.get $t__2
    struct.new $Tuple_107
    local.set $t
    local.get $t
    struct.get $Tuple_107 2
    local.set $c
    local.get $t
    struct.get $Tuple_107 1
    local.set $b
    local.get $t
    struct.get $Tuple_107 0
    local.set $a
    local.get $a
    local.get $b
    i32.add
    local.get $c
    i32.add
  )
  (func $testTripleSum (param $a i32) (param $b i32) (param $c i32) (result i32) ;; exported as "testTripleSum"
    local.get $a
    local.get $b
    local.get $c
    return_call $tripleSum
  )
  (func $closure_110 (param $self (ref $AnyFn)) (param $x (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (result i32)
    local.get $x
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
  )
  (func $closure_113 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSortWith (result i32) ;; exported as "testSortWith"
    (local $items (ref null $ListBase))
    (local $sorted (ref null $ListBase))
    (local $w27 i32)
    (local $w24 (ref null $ListBase))
    (local $w25 i32)
    (local $w28 (ref $GcArray_116))
    (local $w29 (ref $GcArray_117))
    (local $w30 (ref null $ListBase))
    (local $w31 i32)
    (local $w32 (ref $QuickTestWasmGc_TestsPrimitives_SWItem))
    (local $w33 i32)
    (local $w35 i32)
    (local $w36 (ref $QuickTestWasmGc_TestsPrimitives_SWItem))
    (local $w37 i32)
    (local $w38 i32)
    (local $w41 i32)
    (local $w42 (ref null $ListBase))
    (local $w45 i32)
    (local $w46 (ref null $ListBase))
    (local $w49 i32)
    (local $w50 (ref null $ListBase))
    (local $w53 i32)
    (local $w54 (ref null $ListBase))
    i32.const 3
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    i32.const 1
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    i32.const 2
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    ref.null $ListBase
    struct.new $ListCons_109
    struct.new $ListCons_109
    struct.new $ListCons_109
    local.set $items
    local.get $items
    local.set $w24
    i32.const 0
    local.set $w25
    block $while_26_exit
      loop $while_26_lp
        local.get $w24
        ref.is_null
        i32.eqz
        if
          local.get $w25
          i32.const 1
          i32.add
          local.set $w25
          local.get $w24
          ref.cast (ref $ListCons_109)
          struct.get $ListCons_109 1
          local.set $w24
          br $while_26_lp
        else
          br $while_26_exit
        end
      end
    end
    local.get $w25
    local.set $w27
    ref.null $QuickTestWasmGc_TestsPrimitives_SWItem
    local.get $w27
    array.new $GcArray_116
    local.set $w28
    i32.const 0
    local.get $w27
    array.new $GcArray_117
    local.set $w29
    local.get $items
    local.set $w30
    i32.const 0
    local.set $w31
    block $while_34_exit
      loop $while_34_lp
        local.get $w30
        ref.is_null
        i32.eqz
        if
          local.get $w30
          ref.cast (ref $ListCons_109)
          struct.get $ListCons_109 0
          local.set $w32
          local.get $w32
          struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
          local.set $w33
          local.get $w28
          local.get $w31
          local.get $w32
          array.set $GcArray_116
          local.get $w29
          local.get $w31
          local.get $w33
          array.set $GcArray_117
          local.get $w31
          i32.const 1
          i32.add
          local.set $w31
          local.get $w30
          ref.cast (ref $ListCons_109)
          struct.get $ListCons_109 1
          local.set $w30
          br $while_34_lp
        else
          br $while_34_exit
        end
      end
    end
    local.get $w31
    drop
    i32.const 1
    local.set $w35
    block $while_40_exit
      loop $while_40_lp
        local.get $w35
        local.get $w27
        i32.lt_s
        if
          local.get $w28
          local.get $w35
          array.get $GcArray_116
          local.set $w36
          local.get $w29
          local.get $w35
          array.get $GcArray_117
          local.set $w37
          local.get $w35
          i32.const 1
          i32.sub
          local.set $w38
          block $while_39_exit
            loop $while_39_lp
              local.get $w38
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w29
                local.get $w38
                array.get $GcArray_117
                local.get $w37
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w28
                local.get $w38
                i32.const 1
                i32.add
                local.get $w28
                local.get $w38
                array.get $GcArray_116
                array.set $GcArray_116
                local.get $w29
                local.get $w38
                i32.const 1
                i32.add
                local.get $w29
                local.get $w38
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w38
                i32.const 1
                i32.sub
                local.set $w38
                br $while_39_lp
              else
                br $while_39_exit
              end
            end
          end
          local.get $w28
          local.get $w38
          i32.const 1
          i32.add
          local.get $w36
          array.set $GcArray_116
          local.get $w29
          local.get $w38
          i32.const 1
          i32.add
          local.get $w37
          array.set $GcArray_117
          local.get $w35
          i32.const 1
          i32.add
          local.set $w35
          br $while_40_lp
        else
          br $while_40_exit
        end
      end
    end
    local.get $w27
    i32.const 1
    i32.sub
    local.set $w41
    ref.null $ListBase
    local.set $w42
    block $while_43_exit
      loop $while_43_lp
        local.get $w41
        i32.const 0
        i32.ge_s
        if
          local.get $w28
          local.get $w41
          array.get $GcArray_116
          local.get $w42
          struct.new $ListCons_109
          local.set $w42
          local.get $w41
          i32.const 1
          i32.sub
          local.set $w41
          br $while_43_lp
        else
          br $while_43_exit
        end
      end
    end
    local.get $w42
    local.set $sorted
    i32.const 0
    local.set $w45
    local.get $sorted
    local.set $w46
    block $while_47_exit
      loop $while_47_lp
        local.get $w45
        i32.const 0
        i32.gt_s
        if
          local.get $w46
          ref.cast (ref $ListCons_109)
          struct.get $ListCons_109 1
          local.set $w46
          local.get $w45
          i32.const 1
          i32.sub
          local.set $w45
          br $while_47_lp
        else
          br $while_47_exit
        end
      end
    end
    local.get $w46
    ref.cast (ref $ListCons_109)
    struct.get $ListCons_109 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.const 1
    local.set $w49
    local.get $sorted
    local.set $w50
    block $while_51_exit
      loop $while_51_lp
        local.get $w49
        i32.const 0
        i32.gt_s
        if
          local.get $w50
          ref.cast (ref $ListCons_109)
          struct.get $ListCons_109 1
          local.set $w50
          local.get $w49
          i32.const 1
          i32.sub
          local.set $w49
          br $while_51_lp
        else
          br $while_51_exit
        end
      end
    end
    local.get $w50
    ref.cast (ref $ListCons_109)
    struct.get $ListCons_109 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.add
    i32.const 2
    local.set $w53
    local.get $sorted
    local.set $w54
    block $while_55_exit
      loop $while_55_lp
        local.get $w53
        i32.const 0
        i32.gt_s
        if
          local.get $w54
          ref.cast (ref $ListCons_109)
          struct.get $ListCons_109 1
          local.set $w54
          local.get $w53
          i32.const 1
          i32.sub
          local.set $w53
          br $while_55_lp
        else
          br $while_55_exit
        end
      end
    end
    local.get $w54
    ref.cast (ref $ListCons_109)
    struct.get $ListCons_109 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.add
  )
  (func $runPrimitivesTests (param $check (ref $AnyFn)) ;; exported as "runPrimitivesTests"
  )
  (func $testOptionSome (param $v i32) (param $def i32) (result i32) ;; exported as "testOptionSome"
  )
  (func $testOptionNone (param $def i32) (result i32) ;; exported as "testOptionNone"
  )
  (func $testOptionDoubleSome (param $v i32) (result i32) ;; exported as "testOptionDoubleSome"
  )
  (func $testOptionDoubleNone (result i32) ;; exported as "testOptionDoubleNone"
  )
  (func $testOptionIsSome (param $v i32) (result i32) ;; exported as "testOptionIsSome"
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionIsNone (result i32) ;; exported as "testOptionIsNone"
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionNested (param $v i32) (result i32) ;; exported as "testOptionNested"
  )
  (func $mathAbsF (param $x f64) (result f64) ;; exported as "mathAbsF"
    local.get $x
    f64.abs
  )
  (func $mathAbsI (param $x i32) (result i32) ;; exported as "mathAbsI"
    local.get $x
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
      local.get $x
      i32.sub
    else
      local.get $x
    end
  )
  (func $mathSqrt (param $x f64) (result f64) ;; exported as "mathSqrt"
    local.get $x
    f64.sqrt
  )
  (func $mathFloor (param $x f64) (result f64) ;; exported as "mathFloor"
    local.get $x
    f64.floor
  )
  (func $mathCeil (param $x f64) (result f64) ;; exported as "mathCeil"
    local.get $x
    f64.ceil
  )
  (func $mathTrunc (param $x f64) (result f64) ;; exported as "mathTrunc"
    local.get $x
    f64.trunc
  )
  (func $mathRound (param $x f64) (result f64) ;; exported as "mathRound"
    local.get $x
    f64.nearest
  )
  (func $mathMinF (param $a f64) (param $b f64) (result f64) ;; exported as "mathMinF"
    local.get $a
    local.get $b
    f64.min
  )
  (func $mathMaxF (param $a f64) (param $b f64) (result f64) ;; exported as "mathMaxF"
    local.get $a
    local.get $b
    f64.max
  )
  (func $mathMinI (param $a i32) (param $b i32) (result i32) ;; exported as "mathMinI"
    local.get $a
    local.get $b
    i32.lt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end
  )
  (func $mathMaxI (param $a i32) (param $b i32) (result i32) ;; exported as "mathMaxI"
    local.get $a
    local.get $b
    i32.gt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end
  )
  (func $applyFn (param $f (ref $AnyFn)) (param $x i32) (result i32) ;; exported as "applyFn"
    (local $lo_clo_30 (ref $ClosureBase_28))
    local.get $f
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_30
    local.get $lo_clo_30
    local.get $x
    local.get $lo_clo_30
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $doubleVal (param $x i32) (result i32) ;; exported as "doubleVal"
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_119 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 3
    i32.mul
  )
  (func $testOptionMap (result i32) ;; exported as "testOptionMap"
    (local $x (ref null $Option_118))
    (local $y (ref null $Option_118))
    (local $v i32)
    i32.const 5
    struct.new $Option_118
    local.set $x
    local.get $x
    ref.is_null
    if (result (ref null $Option_118))
      local.get $x
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
      local.set $v
      local.get $v
      i32.const 3
      i32.mul
      struct.new $Option_118
    else
      ref.null $Option_118
    end
    local.set $y
    local.get $y
    ref.is_null
    if (result i32)
      local.get $y
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      i32.const 0
    end
  )
  (func $closure_120 (param $self (ref $AnyFn)) (param $v i32) (result (ref null $Option_118))
    local.get $v
    i32.const 0
    i32.gt_s
    if (result (ref null $Option_118))
      local.get $v
      i32.const 1
      i32.shl
      struct.new $Option_118
    else
      ref.null $Option_118
    end
  )
  (func $testOptionBind (result i32) ;; exported as "testOptionBind"
    (local $x (ref null $Option_118))
    (local $y (ref null $Option_118))
    (local $v i32)
    i32.const 4
    struct.new $Option_118
    local.set $x
    local.get $x
    ref.is_null
    if (result (ref null $Option_118))
      local.get $x
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
      local.set $v
      local.get $v
      i32.const 0
      i32.gt_s
      if (result (ref null $Option_118))
        local.get $v
        i32.const 1
        i32.shl
        struct.new $Option_118
      else
        ref.null $Option_118
      end
    else
      ref.null $Option_118
    end
    local.set $y
    local.get $y
    ref.is_null
    if (result i32)
      local.get $y
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      i32.const -1
    end
  )
  (func $testOptionValue (result i32) ;; exported as "testOptionValue"
    (local $w65 (ref null $Option_118))
    i32.const 42
    struct.new $Option_118
    local.set $w65
    local.get $w65
    ref.cast (ref $Option_118)
    struct.get $Option_118 0
  )
  (func $closure_123 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_124 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testOptionMapValue (result i32) ;; exported as "testOptionMapValue"
    (local $w68 (ref null $Option_118))
    (local $w67 (ref null $Option_118))
    (local $x i32)
    i32.const 42
    struct.new $Option_118
    local.set $w67
    local.get $w67
    ref.is_null
    if (result (ref null $Option_118))
      local.get $w67
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
      local.set $x
      local.get $x
      i32.const 1
      i32.shl
      struct.new $Option_118
    else
      ref.null $Option_118
    end
    local.set $w68
    local.get $w68
    ref.cast (ref $Option_118)
    struct.get $Option_118 0
  )
  (func $testOptionDefaultValue (result i32) ;; exported as "testOptionDefaultValue"
    (local $w69 (ref null $Option_118))
    i32.const 42
    struct.new $Option_118
    local.set $w69
    local.get $w69
    ref.is_null
    if (result i32)
      local.get $w69
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      i32.const 99
    end
  )
  (func $testOptionDefaultValueNone (result i32) ;; exported as "testOptionDefaultValueNone"
    ref.null $Option_118
    ref.cast (ref $Option_118)
    struct.get $Option_118 0
  )
  (func $closure_125 (param $self (ref $AnyFn)) (result i32)
    i32.const 42
  )
  (func $testOptionDefaultWith (result i32) ;; exported as "testOptionDefaultWith"
    ref.null $Option_118
    ref.cast (ref $Option_118)
    struct.get $Option_118 0
  )
  (func $closure_126 (param $self (ref $AnyFn)) (result i32)
    i32.const 99
  )
  (func $testOptionDefaultWithSome (result i32) ;; exported as "testOptionDefaultWithSome"
    (local $w72 (ref null $Option_118))
    i32.const 5
    struct.new $Option_118
    local.set $w72
    local.get $w72
    ref.is_null
    if (result i32)
      local.get $w72
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      i32.const 99
    end
  )
  (func $closure_127 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testOptionFilter (result i32) ;; exported as "testOptionFilter"
    (local $matchValue (ref null $Option_118))
    (local $w73 (ref null $Option_118))
    (local $x i32)
    i32.const 5
    struct.new $Option_118
    local.set $w73
    local.get $w73
    ref.is_null
    if (result (ref null $Option_118))
      local.get $w73
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
      local.set $x
      local.get $x
      i32.const 3
      i32.gt_s
      if (result (ref null $Option_118))
        local.get $w73
      else
        ref.null $Option_118
      end
    else
      ref.null $Option_118
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $closure_128 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testOptionFilterNone (result i32) ;; exported as "testOptionFilterNone"
    (local $matchValue (ref null $Option_118))
    (local $w74 (ref null $Option_118))
    (local $x i32)
    i32.const 5
    struct.new $Option_118
    local.set $w74
    local.get $w74
    ref.is_null
    if (result (ref null $Option_118))
      local.get $w74
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
      local.set $x
      local.get $x
      i32.const 10
      i32.gt_s
      if (result (ref null $Option_118))
        local.get $w74
      else
        ref.null $Option_118
      end
    else
      ref.null $Option_118
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
  )
  (func $testOptionModuleIsSome (result i32) ;; exported as "testOptionModuleIsSome"
    i32.const 0
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionModuleIsSomeNone (result i32) ;; exported as "testOptionModuleIsSomeNone"
    i32.const 1
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionModuleIsNone (result i32) ;; exported as "testOptionModuleIsNone"
    i32.const 1
  )
  (func $testOptionModuleIsNoneSome (result i32) ;; exported as "testOptionModuleIsNoneSome"
    i32.const 0
  )
  (func $testOptionModuleDefaultValueNone (result i32) ;; exported as "testOptionModuleDefaultValueNone"
    ref.null $Option_118
    ref.cast (ref $Option_118)
    struct.get $Option_118 0
  )
  (func $testOptionModuleDefaultValueSome (result i32) ;; exported as "testOptionModuleDefaultValueSome"
    (local $w76 (ref null $Option_118))
    i32.const 99
    struct.new $Option_118
    local.set $w76
    local.get $w76
    ref.is_null
    if (result i32)
      local.get $w76
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      i32.const 42
    end
  )
  (func $testOptionModuleCountNone (result i32) ;; exported as "testOptionModuleCountNone"
    i32.const 0
  )
  (func $testOptionModuleCountSome (result i32) ;; exported as "testOptionModuleCountSome"
    i32.const 0
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $runOptionTests (param $check (ref $AnyFn)) ;; exported as "runOptionTests"
  )
  (func $add (param $a i32) (param $b i32) (result i32) ;; exported as "add"
    local.get $a
    local.get $b
    i32.add
  )
  (func $sub (param $a i32) (param $b i32) (result i32) ;; exported as "sub"
    local.get $a
    local.get $b
    i32.sub
  )
  (func $mul (param $a i32) (param $b i32) (result i32) ;; exported as "mul"
    local.get $a
    local.get $b
    i32.mul
  )
  (func $fib (param $n i32) (result i32) ;; exported as "fib"
    local.get $n
    i32.const 1
    i32.le_s
    if (result i32)
      local.get $n
    else
      local.get $n
      i32.const 1
      i32.sub
      call $fib
      local.get $n
      i32.const 2
      i32.sub
      call $fib
      i32.add
    end
  )
  (func $fact (param $n i32) (result i32) ;; exported as "fact"
    local.get $n
    i32.const 1
    i32.le_s
    if (result i32)
      i32.const 1
    else
      local.get $n
      local.get $n
      i32.const 1
      i32.sub
      call $fact
      i32.mul
    end
  )
  (func $clamp (param $lo i32) (param $hi i32) (param $v i32) (result i32) ;; exported as "clamp"
    local.get $v
    local.get $lo
    i32.lt_s
    if (result i32)
      local.get $lo
    else
      local.get $v
      local.get $hi
      i32.gt_s
      if (result i32)
        local.get $hi
      else
        local.get $v
      end
    end
  )
  (func $myAbs (param $n i32) (result i32) ;; exported as "myAbs"
    local.get $n
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
      local.get $n
      i32.sub
    else
      local.get $n
    end
  )
  (func $isqrt (param $n i32) (result i32) ;; exported as "isqrt"
    (local $x i32)
    (local $y i32)
    local.get $n
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
    else
      local.get $n
      i32.const 0
      i32.eq
      if (result i32)
        i32.const 0
      else
        local.get $n
        local.set $x
        local.get $x
        i32.const 1
        i32.add
        i32.const 1
        i32.shr_s
        i32.const -1
        i32.xor
        i32.const -1
        i32.xor
        local.set $y
        loop $while
          local.get $y
          local.get $x
          i32.lt_s
          if
            local.get $y
            local.set $x
            local.get $y
            local.get $n
            local.get $y
            i32.div_s
            i32.const -1
            i32.xor
            i32.const -1
            i32.xor
            i32.add
            i32.const 1
            i32.shr_s
            i32.const -1
            i32.xor
            i32.const -1
            i32.xor
            local.set $y
            br $while
          end
        end
        local.get $x
      end
    end
  )
  (func $applyFn (param $f (ref $AnyFn)) (param $x i32) (result i32) ;; exported as "applyFn"
    (local $lo_clo_31 (ref $ClosureBase_28))
    local.get $f
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_31
    local.get $lo_clo_31
    local.get $x
    local.get $lo_clo_31
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $doubleVal (param $x i32) (result i32) ;; exported as "doubleVal"
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $makeAdder (param $n i32) (param $x i32) (result i32) ;; exported as "makeAdder"
    local.get $x
    local.get $n
    i32.add
  )
  (func $applyTwice (param $f (ref $AnyFn)) (param $x i32) (result i32) ;; exported as "applyTwice"
    (local $lo_clo_33 (ref $ClosureBase_28))
    (local $lo_clo_32 (ref $ClosureBase_28))
    local.get $f
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_33
    local.get $lo_clo_33
    local.get $f
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_32
    local.get $lo_clo_32
    local.get $x
    local.get $lo_clo_32
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
    local.get $lo_clo_33
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $makeMultiplier (param $n i32) (param $x i32) (result i32) ;; exported as "makeMultiplier"
    local.get $x
    local.get $n
    i32.mul
  )
  (func $optionOrDefault (param $opt (ref null $Option_118)) (param $def i32) (result i32) ;; exported as "optionOrDefault"
    local.get $opt
    ref.is_null
    if (result i32)
      local.get $def
    else
      local.get $opt
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $optionDouble (param $opt (ref null $Option_118)) (result i32) ;; exported as "optionDouble"
    (local $v i32)
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $opt
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
      local.set $v
      local.get $v
      i32.const 1
      i32.shl
    end
  )
  (func $optionIsSome (param $opt (ref null $Option_118)) (result i32) ;; exported as "optionIsSome"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
  )
  (func $optionIsNone (param $opt (ref null $Option_118)) (result i32) ;; exported as "optionIsNone"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $optionNested (param $v i32) (result i32) ;; exported as "optionNested"
    (local $outer (ref null $Option_129))
    (local $inner (ref null $Option_118))
    local.get $v
    struct.new $Option_118
    struct.new $Option_129
    local.set $outer
    local.get $outer
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $outer
      ref.cast (ref $Option_129)
      struct.get $Option_129 0
      local.set $inner
      local.get $inner
      ref.is_null
      if (result i32)
        i32.const -2
      else
        local.get $inner
        ref.cast (ref $Option_118)
        struct.get $Option_118 0
      end
    end
  )
  (func $mathAbsF (param $x f64) (result f64) ;; exported as "mathAbsF"
    local.get $x
    f64.abs
  )
  (func $mathAbsI (param $x i32) (result i32) ;; exported as "mathAbsI"
    local.get $x
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
      local.get $x
      i32.sub
    else
      local.get $x
    end
  )
  (func $mathSqrt (param $x f64) (result f64) ;; exported as "mathSqrt"
    local.get $x
    f64.sqrt
  )
  (func $mathFloor (param $x f64) (result f64) ;; exported as "mathFloor"
    local.get $x
    f64.floor
  )
  (func $mathCeil (param $x f64) (result f64) ;; exported as "mathCeil"
    local.get $x
    f64.ceil
  )
  (func $mathTrunc (param $x f64) (result f64) ;; exported as "mathTrunc"
    local.get $x
    f64.trunc
  )
  (func $mathRound (param $x f64) (result f64) ;; exported as "mathRound"
    local.get $x
    f64.nearest
  )
  (func $mathMinF (param $a f64) (param $b f64) (result f64) ;; exported as "mathMinF"
    local.get $a
    local.get $b
    f64.min
  )
  (func $mathMaxF (param $a f64) (param $b f64) (result f64) ;; exported as "mathMaxF"
    local.get $a
    local.get $b
    f64.max
  )
  (func $mathMinI (param $a i32) (param $b i32) (result i32) ;; exported as "mathMinI"
    local.get $a
    local.get $b
    i32.lt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end
  )
  (func $mathMaxI (param $a i32) (param $b i32) (result i32) ;; exported as "mathMaxI"
    local.get $a
    local.get $b
    i32.gt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end
  )
  (func $intCmp (param $a i32) (param $b i32) (result i32) ;; exported as "intCmp"
    local.get $a
    local.get $b
    i32.lt_s
    if (result i32)
      i32.const -1
    else
      local.get $a
      local.get $b
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        i32.const 0
      end
    end
  )
  (func $roundTo6 (param $x f64) (result f64) ;; exported as "roundTo6"
    local.get $x
    f64.const 1000000
    f64.mul
    f64.nearest
    f64.const 1000000
    f64.div
  )
  (func $nodeAdd_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $value i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $key
        local.get $value
        local.get $l
        call $nodeAdd_i32~i32
        local.get $r
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $MapModule_MapNode`2<i32~i32>))
          i32.const 1
          local.get $k
          local.get $v
          local.get $l
          local.get $key
          local.get $value
          local.get $r
          call $nodeAdd_i32~i32
          struct.new $MapModule_MapNode`2<i32~i32>#1
        else
          i32.const 1
          local.get $key
          local.get $value
          local.get $l
          local.get $r
          struct.new $MapModule_MapNode`2<i32~i32>#1
        end
      end
    else
      i32.const 1
      local.get $key
      local.get $value
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
      struct.new $MapModule_MapNode`2<i32~i32>#1
    end
  )
  (func $Map_nodeAdd (param $cmp (ref $AnyFn)) (param $key i32) (param $value i32) (param $node (ref $MapModule_MapNode`2)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $key
        local.get $value
        local.get $l
        call $nodeAdd_i32~i32
        local.get $r
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $MapModule_MapNode`2<i32~i32>))
          i32.const 1
          local.get $k
          local.get $v
          local.get $l
          local.get $key
          local.get $value
          local.get $r
          call $nodeAdd_i32~i32
          struct.new $MapModule_MapNode`2<i32~i32>#1
        else
          i32.const 1
          local.get $key
          local.get $value
          local.get $l
          local.get $r
          struct.new $MapModule_MapNode`2<i32~i32>#1
        end
      end
    else
      i32.const 1
      local.get $key
      local.get $value
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
      struct.new $MapModule_MapNode`2<i32~i32>#1
    end
  )
  (func $nodeTryFind_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_118))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_118))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref null $Option_118))
        local.get $key
        local.get $l
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_118))
          local.get $key
          local.get $r
          call $nodeTryFind_i32~i32
        else
          local.get $v
          struct.new $Option_118
        end
      end
    else
      ref.null $Option_118
    end
  )
  (func $Map_nodeTryFind (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_118))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_118))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref null $Option_118))
        local.get $key
        local.get $l
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_118))
          local.get $key
          local.get $r
          call $nodeTryFind_i32~i32
        else
          local.get $v
          struct.new $Option_118
        end
      end
    else
      ref.null $Option_118
    end
  )
  (func $nodeContainsKey_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $key
        local.get $l
        call $nodeContainsKey_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $key
          local.get $r
          call $nodeContainsKey_i32~i32
        else
          i32.const 1
        end
      end
    else
      i32.const 0
    end
  )
  (func $Map_nodeContainsKey (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $key
        local.get $l
        call $nodeContainsKey_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $key
          local.get $r
          call $nodeContainsKey_i32~i32
        else
          i32.const 1
        end
      end
    else
      i32.const 0
    end
  )
  (func $nodeMergeInto_i32~i32 (param $cmp (ref $AnyFn)) (param $source (ref $MapModule_MapNode`2<i32~i32>)) (param $target (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $sv i32)
    (local $sr (ref $MapModule_MapNode`2<i32~i32>))
    (local $sl (ref $MapModule_MapNode`2<i32~i32>))
    (local $sk i32)
    local.get $source
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $sv
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $sr
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $sl
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $sk
      local.get $sr
      local.get $sl
      local.get $sk
      local.get $sv
      local.get $target
      call $nodeAdd_i32~i32
      call $nodeMergeInto_i32~i32
      call $nodeMergeInto_i32~i32
    else
      local.get $target
    end
  )
  (func $Map_nodeMergeInto (param $cmp (ref $AnyFn)) (param $source (ref $MapModule_MapNode`2<i32~i32>)) (param $target (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $sv i32)
    (local $sr (ref $MapModule_MapNode`2<i32~i32>))
    (local $sl (ref $MapModule_MapNode`2<i32~i32>))
    (local $sk i32)
    local.get $source
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $sv
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $sr
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $sl
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $sk
      local.get $sr
      local.get $sl
      local.get $sk
      local.get $sv
      local.get $target
      call $nodeAdd_i32~i32
      call $nodeMergeInto_i32~i32
      call $nodeMergeInto_i32~i32
    else
      local.get $target
    end
  )
  (func $nodeRemove_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $key
        local.get $l
        call $nodeRemove_i32~i32
        local.get $r
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $MapModule_MapNode`2<i32~i32>))
          i32.const 1
          local.get $k
          local.get $v
          local.get $l
          local.get $key
          local.get $r
          call $nodeRemove_i32~i32
          struct.new $MapModule_MapNode`2<i32~i32>#1
        else
          local.get $r
          local.get $l
          call $nodeMergeInto_i32~i32
        end
      end
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $Map_nodeRemove (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $key
        local.get $l
        call $nodeRemove_i32~i32
        local.get $r
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $MapModule_MapNode`2<i32~i32>))
          i32.const 1
          local.get $k
          local.get $v
          local.get $l
          local.get $key
          local.get $r
          call $nodeRemove_i32~i32
          struct.new $MapModule_MapNode`2<i32~i32>#1
        else
          local.get $r
          local.get $l
          call $nodeMergeInto_i32~i32
        end
      end
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $nodeFold_i32~i32~i32 (param $folder (ref $AnyFn)) (param $state i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $s1 i32)
    (local $s2 i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $state
      local.get $l
      call $nodeFold_i32~i32~i32
      local.set $s1
      local.get $s2
      local.get $r
      call $nodeFold_i32~i32~i32
    else
      local.get $state
    end
  )
  (func $Map_nodeFold (param $folder (ref $AnyFn)) (param $state i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $s1 i32)
    (local $s2 i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $state
      local.get $l
      call $nodeFold_i32~i32~i32
      local.set $s1
      local.get $s2
      local.get $r
      call $nodeFold_i32~i32~i32
    else
      local.get $state
    end
  )
  (func $nodeIter_i32~i32 (param $action (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>))
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $l
      call $nodeIter_i32~i32
      local.get $r
      call $nodeIter_i32~i32
    end
  )
  (func $Map_nodeIter (param $action (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>))
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $l
      call $nodeIter_i32~i32
      local.get $r
      call $nodeIter_i32~i32
    end
  )
  (func $nodeMapValues_i32~i32~i32 (param $mapping (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      i32.const 1
      local.get $k
      local.get $l
      call $nodeMapValues_i32~i32~i32
      local.get $r
      call $nodeMapValues_i32~i32~i32
      struct.new $MapModule_MapNode`2<i32~i32>#1
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $Map_nodeMapValues (param $mapping (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      i32.const 1
      local.get $k
      local.get $l
      call $nodeMapValues_i32~i32~i32
      local.get $r
      call $nodeMapValues_i32~i32~i32
      struct.new $MapModule_MapNode`2<i32~i32>#1
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $nodeFilter_i32~i32 (param $cmp (ref $AnyFn)) (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $fl (ref $MapModule_MapNode`2<i32~i32>))
    (local $fr (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $l
      call $nodeFilter_i32~i32
      local.set $fl
      local.get $r
      call $nodeFilter_i32~i32
      local.set $fr
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $fr
        local.get $fl
        call $nodeMergeInto_i32~i32
      end
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $Map_nodeFilter (param $cmp (ref $AnyFn)) (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $fl (ref $MapModule_MapNode`2<i32~i32>))
    (local $fr (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $l
      call $nodeFilter_i32~i32
      local.set $fl
      local.get $r
      call $nodeFilter_i32~i32
      local.set $fr
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $fr
        local.get $fl
        call $nodeMergeInto_i32~i32
      end
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $nodeExists_i32~i32 (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      if (result i32)
        i32.const 1
      else
        local.get $l
        call $nodeExists_i32~i32
        if (result i32)
          i32.const 1
        else
          local.get $r
          call $nodeExists_i32~i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $Map_nodeExists (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      if (result i32)
        i32.const 1
      else
        local.get $l
        call $nodeExists_i32~i32
        if (result i32)
          i32.const 1
        else
          local.get $r
          call $nodeExists_i32~i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $nodeForAll_i32~i32 (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $l
        call $nodeForAll_i32~i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $r
          call $nodeForAll_i32~i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $Map_nodeForAll (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $l
        call $nodeForAll_i32~i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $r
          call $nodeForAll_i32~i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $nodeToListAcc_i32~i32 (param $acc (ref null $ListBase)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $ListBase))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $k
      local.get $v
      struct.new $Tuple_105
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_137
      local.get $l
      call $nodeToListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $Map_nodeToListAcc (param $acc (ref null $ListBase)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $ListBase))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.set $v
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.set $r
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.set $l
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $k
      local.get $v
      struct.new $Tuple_105
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_137
      local.get $l
      call $nodeToListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $Map_empty (param $cmp (ref $AnyFn)) (result (ref $MapModule_MapHandle`2))
    i32.const 0
    struct.new $MapModule_MapNode`2<i32~i32>#0
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_isEmpty (param $m (ref $MapModule_MapHandle`2)) (result i32)
    (local $matchValue (ref $MapModule_MapNode`2<i32~i32>))
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    local.set $matchValue
    local.get $matchValue
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $Map_add (param $key i32) (param $value i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $value
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeAdd_i32~i32
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_tryFind (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_118))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeTryFind_i32~i32
  )
  (func $tryFind_i32~i32 (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_118))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeTryFind_i32~i32
  )
  (func $Map_find (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    (local $matchValue (ref null $Option_118))
    local.get $key
    local.get $m
    call $tryFind_i32~i32
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 75
      i32.const 101
      i32.const 121
      i32.const 32
      i32.const 110
      i32.const 111
      i32.const 116
      i32.const 32
      i32.const 102
      i32.const 111
      i32.const 117
      i32.const 110
      i32.const 100
      array.new_fixed $WasmStr 13
      struct.new $Exception
      global.set $fsharp_exn_carrier
      ref.null any
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $Map_containsKey (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeContainsKey_i32~i32
  )
  (func $Map_remove (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeRemove_i32~i32
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    struct.new $MapModule_MapHandle`2
  )
  (func $closure_138 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_138))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_138)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_138 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_138 (param $self (ref $AnyFn)) (param $_arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_139))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_139)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_139 1
    local.set $n
    ref.func $closure_138
    local.get $n
    struct.new $ClosureType_138
  )
  (func $closure_138 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_138
    local.get $n
    struct.new $ClosureType_139
  )
  (func $closure_141 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_141))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_141)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_141 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_141 (param $self (ref $AnyFn)) (param $_arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_142))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_142)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_142 1
    local.set $n
    ref.func $closure_141
    local.get $n
    struct.new $ClosureType_141
  )
  (func $closure_141 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_141
    local.get $n
    struct.new $ClosureType_142
  )
  (func $Map_count (param $m (ref $MapModule_MapHandle`2)) (result i32)
    ref.func $closure_141
    struct.new $ClosureType_143
    i32.const 0
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeFold_i32~i32~i32
  )
  (func $Map_fold (param $folder (ref $AnyFn)) (param $state i32) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $state
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeFold_i32~i32~i32
  )
  (func $Map_iter (param $action (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2))
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeIter_i32~i32
  )
  (func $Map_mapValues (param $mapping (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeMapValues_i32~i32~i32
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_filter (param $predicate (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeFilter_i32~i32
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_exists (param $predicate (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeExists_i32~i32
  )
  (func $Map_forAll (param $predicate (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeForAll_i32~i32
  )
  (func $Map_toList (param $m (ref $MapModule_MapHandle`2)) (result (ref null $ListBase))
    ref.null $ListBase
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeToListAcc_i32~i32
  )
  (func $add_i32~i32 (param $key i32) (param $value i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $value
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeAdd_i32~i32
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    struct.new $MapModule_MapHandle`2
  )
  (func $ofListAcc_i32~i32 (param $cmp (ref $AnyFn)) (param $acc (ref $MapModule_MapHandle`2)) (param $pairs (ref null $ListBase)) (result (ref $MapModule_MapHandle`2))
    (local $v i32)
    (local $rest (ref null $ListBase))
    (local $k i32)
    local.get $pairs
    ref.is_null
    i32.eqz
    if (result (ref $MapModule_MapHandle`2))
      local.get $pairs
      ref.cast (ref $ListCons_137)
      struct.get $ListCons_137 0
      struct.get $Tuple_105 1
      local.set $v
      local.get $pairs
      ref.cast (ref $ListCons_137)
      struct.get $ListCons_137 1
      local.set $rest
      local.get $pairs
      ref.cast (ref $ListCons_137)
      struct.get $ListCons_137 0
      struct.get $Tuple_105 0
      local.set $k
      local.get $k
      local.get $v
      local.get $acc
      call $add_i32~i32
      local.get $rest
      call $ofListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $Map_ofListAcc (param $cmp (ref $AnyFn)) (param $acc (ref $MapModule_MapHandle`2)) (param $pairs (ref null $ListBase)) (result (ref $MapModule_MapHandle`2))
    (local $v i32)
    (local $rest (ref null $ListBase))
    (local $k i32)
    local.get $pairs
    ref.is_null
    i32.eqz
    if (result (ref $MapModule_MapHandle`2))
      local.get $pairs
      ref.cast (ref $ListCons_137)
      struct.get $ListCons_137 0
      struct.get $Tuple_105 1
      local.set $v
      local.get $pairs
      ref.cast (ref $ListCons_137)
      struct.get $ListCons_137 1
      local.set $rest
      local.get $pairs
      ref.cast (ref $ListCons_137)
      struct.get $ListCons_137 0
      struct.get $Tuple_105 0
      local.set $k
      local.get $k
      local.get $v
      local.get $acc
      call $add_i32~i32
      local.get $rest
      call $ofListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $empty_i32~i32 (param $cmp (ref $AnyFn)) (result (ref $MapModule_MapHandle`2))
    i32.const 0
    struct.new $MapModule_MapNode`2<i32~i32>#0
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_ofList (param $cmp (ref $AnyFn)) (param $pairs (ref null $ListBase)) (result (ref $MapModule_MapHandle`2))
    call $empty_i32~i32
    local.get $pairs
    return_call $ofListAcc_i32~i32
  )
  (func $nodeAdd_i32 (param $cmp (ref $AnyFn)) (param $value i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $c i32)
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $value
        local.get $l
        call $nodeAdd_i32
        local.get $r
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $SetModule_SetNode`1<i32>))
          i32.const 1
          local.get $v
          local.get $l
          local.get $value
          local.get $r
          call $nodeAdd_i32
          struct.new $SetModule_SetNode`1<i32>#1
        else
          local.get $node
        end
      end
    else
      i32.const 1
      local.get $value
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
      struct.new $SetModule_SetNode`1<i32>#1
    end
  )
  (func $Set_nodeAdd (param $cmp (ref $AnyFn)) (param $value i32) (param $node (ref $SetModule_SetNode`1)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $c i32)
    local.get $node
    struct.get $SetModule_SetNode`1 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $value
        local.get $l
        call $nodeAdd_i32
        local.get $r
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $SetModule_SetNode`1<i32>))
          i32.const 1
          local.get $v
          local.get $l
          local.get $value
          local.get $r
          call $nodeAdd_i32
          struct.new $SetModule_SetNode`1<i32>#1
        else
          local.get $node
        end
      end
    else
      i32.const 1
      local.get $value
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
      struct.new $SetModule_SetNode`1<i32>#1
    end
  )
  (func $nodeContains_i32 (param $cmp (ref $AnyFn)) (param $value i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $c i32)
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $value
        local.get $l
        call $nodeContains_i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $value
          local.get $r
          call $nodeContains_i32
        else
          i32.const 1
        end
      end
    else
      i32.const 0
    end
  )
  (func $Set_nodeContains (param $cmp (ref $AnyFn)) (param $value i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $c i32)
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $value
        local.get $l
        call $nodeContains_i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $value
          local.get $r
          call $nodeContains_i32
        else
          i32.const 1
        end
      end
    else
      i32.const 0
    end
  )
  (func $nodeMergeInto_i32 (param $cmp (ref $AnyFn)) (param $source (ref $SetModule_SetNode`1<i32>)) (param $target (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $sv i32)
    (local $sr (ref $SetModule_SetNode`1<i32>))
    (local $sl (ref $SetModule_SetNode`1<i32>))
    local.get $source
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $sv
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $sr
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $sl
      local.get $sr
      local.get $sl
      local.get $sv
      local.get $target
      call $nodeAdd_i32
      call $nodeMergeInto_i32
      call $nodeMergeInto_i32
    else
      local.get $target
    end
  )
  (func $Set_nodeMergeInto (param $cmp (ref $AnyFn)) (param $source (ref $SetModule_SetNode`1<i32>)) (param $target (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $sv i32)
    (local $sr (ref $SetModule_SetNode`1<i32>))
    (local $sl (ref $SetModule_SetNode`1<i32>))
    local.get $source
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $sv
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $sr
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $sl
      local.get $sr
      local.get $sl
      local.get $sv
      local.get $target
      call $nodeAdd_i32
      call $nodeMergeInto_i32
      call $nodeMergeInto_i32
    else
      local.get $target
    end
  )
  (func $nodeRemove_i32 (param $cmp (ref $AnyFn)) (param $value i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $c i32)
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $value
        local.get $l
        call $nodeRemove_i32
        local.get $r
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $SetModule_SetNode`1<i32>))
          i32.const 1
          local.get $v
          local.get $l
          local.get $value
          local.get $r
          call $nodeRemove_i32
          struct.new $SetModule_SetNode`1<i32>#1
        else
          local.get $r
          local.get $l
          call $nodeMergeInto_i32
        end
      end
    else
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
    end
  )
  (func $Set_nodeRemove (param $cmp (ref $AnyFn)) (param $value i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $c i32)
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $value
        local.get $l
        call $nodeRemove_i32
        local.get $r
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref $SetModule_SetNode`1<i32>))
          i32.const 1
          local.get $v
          local.get $l
          local.get $value
          local.get $r
          call $nodeRemove_i32
          struct.new $SetModule_SetNode`1<i32>#1
        else
          local.get $r
          local.get $l
          call $nodeMergeInto_i32
        end
      end
    else
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
    end
  )
  (func $nodeFold_i32~i32 (param $folder (ref $AnyFn)) (param $state i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $s1 i32)
    (local $s2 i32)
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $state
      local.get $l
      call $nodeFold_i32~i32
      local.set $s1
      local.get $s2
      local.get $r
      call $nodeFold_i32~i32
    else
      local.get $state
    end
  )
  (func $Set_nodeFold (param $folder (ref $AnyFn)) (param $state i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $s1 i32)
    (local $s2 i32)
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $state
      local.get $l
      call $nodeFold_i32~i32
      local.set $s1
      local.get $s2
      local.get $r
      call $nodeFold_i32~i32
    else
      local.get $state
    end
  )
  (func $nodeIter_i32 (param $action (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_34 (ref $ClosureBase_209))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $action
      local.get $l
      call $nodeIter_i32
      local.get $action
      ref.cast (ref $ClosureBase_209)
      local.set $lo_clo_34
      local.get $lo_clo_34
      local.get $v
      local.get $lo_clo_34
      struct.get $ClosureBase_209 0
      call_ref $FuncType_151
      local.get $action
      local.get $r
      call $nodeIter_i32
    end
  )
  (func $Set_nodeIter (param $action (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_35 (ref $ClosureBase_209))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $action
      local.get $l
      call $nodeIter_i32
      local.get $action
      ref.cast (ref $ClosureBase_209)
      local.set $lo_clo_35
      local.get $lo_clo_35
      local.get $v
      local.get $lo_clo_35
      struct.get $ClosureBase_209 0
      call_ref $FuncType_151
      local.get $action
      local.get $r
      call $nodeIter_i32
    end
  )
  (func $nodeFilter_i32 (param $cmp (ref $AnyFn)) (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $fl (ref $SetModule_SetNode`1<i32>))
    (local $fr (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_36 (ref $ClosureBase_28))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $predicate
      local.get $l
      call $nodeFilter_i32
      local.set $fl
      local.get $predicate
      local.get $r
      call $nodeFilter_i32
      local.set $fr
      local.get $predicate
      ref.cast (ref $ClosureBase_28)
      local.set $lo_clo_36
      local.get $lo_clo_36
      local.get $v
      local.get $lo_clo_36
      struct.get $ClosureBase_28 0
      call_ref $FuncType_27
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $fr
        local.get $fl
        call $nodeMergeInto_i32
      end
    else
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
    end
  )
  (func $Set_nodeFilter (param $cmp (ref $AnyFn)) (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $fl (ref $SetModule_SetNode`1<i32>))
    (local $fr (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_37 (ref $ClosureBase_28))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $predicate
      local.get $l
      call $nodeFilter_i32
      local.set $fl
      local.get $predicate
      local.get $r
      call $nodeFilter_i32
      local.set $fr
      local.get $predicate
      ref.cast (ref $ClosureBase_28)
      local.set $lo_clo_37
      local.get $lo_clo_37
      local.get $v
      local.get $lo_clo_37
      struct.get $ClosureBase_28 0
      call_ref $FuncType_27
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $fr
        local.get $fl
        call $nodeMergeInto_i32
      end
    else
      i32.const 0
      struct.new $SetModule_SetNode`1<i32>#0
    end
  )
  (func $nodeExists_i32 (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_38 (ref $ClosureBase_28))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $predicate
      ref.cast (ref $ClosureBase_28)
      local.set $lo_clo_38
      local.get $lo_clo_38
      local.get $v
      local.get $lo_clo_38
      struct.get $ClosureBase_28 0
      call_ref $FuncType_27
      if (result i32)
        i32.const 1
      else
        local.get $predicate
        local.get $l
        call $nodeExists_i32
        if (result i32)
          i32.const 1
        else
          local.get $predicate
          local.get $r
          call $nodeExists_i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $Set_nodeExists (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_39 (ref $ClosureBase_28))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $predicate
      ref.cast (ref $ClosureBase_28)
      local.set $lo_clo_39
      local.get $lo_clo_39
      local.get $v
      local.get $lo_clo_39
      struct.get $ClosureBase_28 0
      call_ref $FuncType_27
      if (result i32)
        i32.const 1
      else
        local.get $predicate
        local.get $l
        call $nodeExists_i32
        if (result i32)
          i32.const 1
        else
          local.get $predicate
          local.get $r
          call $nodeExists_i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $nodeForAll_i32 (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_40 (ref $ClosureBase_28))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $predicate
      ref.cast (ref $ClosureBase_28)
      local.set $lo_clo_40
      local.get $lo_clo_40
      local.get $v
      local.get $lo_clo_40
      struct.get $ClosureBase_28 0
      call_ref $FuncType_27
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $predicate
        local.get $l
        call $nodeForAll_i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $predicate
          local.get $r
          call $nodeForAll_i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $Set_nodeForAll (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_41 (ref $ClosureBase_28))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $predicate
      ref.cast (ref $ClosureBase_28)
      local.set $lo_clo_41
      local.get $lo_clo_41
      local.get $v
      local.get $lo_clo_41
      struct.get $ClosureBase_28 0
      call_ref $FuncType_27
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $predicate
        local.get $l
        call $nodeForAll_i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $predicate
          local.get $r
          call $nodeForAll_i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $nodeUnion_i32 (param $cmp (ref $AnyFn)) (param $a (ref $SetModule_SetNode`1<i32>)) (param $b (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $r
      local.get $l
      local.get $v
      local.get $b
      call $nodeAdd_i32
      call $nodeUnion_i32
      call $nodeUnion_i32
    else
      local.get $b
    end
  )
  (func $Set_nodeUnion (param $cmp (ref $AnyFn)) (param $a (ref $SetModule_SetNode`1<i32>)) (param $b (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $r
      local.get $l
      local.get $v
      local.get $b
      call $nodeAdd_i32
      call $nodeUnion_i32
      call $nodeUnion_i32
    else
      local.get $b
    end
  )
  (func $nodeIntersectAcc_i32 (param $cmp (ref $AnyFn)) (param $b (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    (local $acc2 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $b
      local.get $l
      local.get $acc
      call $nodeIntersectAcc_i32
      local.set $acc1
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      else
        local.get $acc1
      end
      local.set $acc2
      local.get $b
      local.get $r
      local.get $acc2
      call $nodeIntersectAcc_i32
    else
      local.get $acc
    end
  )
  (func $Set_nodeIntersectAcc (param $cmp (ref $AnyFn)) (param $b (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    (local $acc2 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $b
      local.get $l
      local.get $acc
      call $nodeIntersectAcc_i32
      local.set $acc1
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      else
        local.get $acc1
      end
      local.set $acc2
      local.get $b
      local.get $r
      local.get $acc2
      call $nodeIntersectAcc_i32
    else
      local.get $acc
    end
  )
  (func $nodeDifferenceAcc_i32 (param $cmp (ref $AnyFn)) (param $b (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    (local $acc2 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $b
      local.get $l
      local.get $acc
      call $nodeDifferenceAcc_i32
      local.set $acc1
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $acc1
      else
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      end
      local.set $acc2
      local.get $b
      local.get $r
      local.get $acc2
      call $nodeDifferenceAcc_i32
    else
      local.get $acc
    end
  )
  (func $Set_nodeDifferenceAcc (param $cmp (ref $AnyFn)) (param $b (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    (local $acc2 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $b
      local.get $l
      local.get $acc
      call $nodeDifferenceAcc_i32
      local.set $acc1
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $acc1
      else
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      end
      local.set $acc2
      local.get $b
      local.get $r
      local.get $acc2
      call $nodeDifferenceAcc_i32
    else
      local.get $acc
    end
  )
  (func $nodeIsSubset_i32 (param $cmp (ref $AnyFn)) (param $a (ref $SetModule_SetNode`1<i32>)) (param $b (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result i32)
        local.get $l
        local.get $b
        call $nodeIsSubset_i32
      else
        i32.const 0
      end
      if (result i32)
        local.get $r
        local.get $b
        call $nodeIsSubset_i32
      else
        i32.const 0
      end
    else
      i32.const 1
    end
  )
  (func $Set_nodeIsSubset (param $cmp (ref $AnyFn)) (param $a (ref $SetModule_SetNode`1<i32>)) (param $b (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result i32)
        local.get $l
        local.get $b
        call $nodeIsSubset_i32
      else
        i32.const 0
      end
      if (result i32)
        local.get $r
        local.get $b
        call $nodeIsSubset_i32
      else
        i32.const 0
      end
    else
      i32.const 1
    end
  )
  (func $nodeToListAcc_i32 (param $acc (ref null $ListBase)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref null $ListBase))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $v
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32
      struct.new $ListCons_37
      local.get $l
      call $nodeToListAcc_i32
    else
      local.get $acc
    end
  )
  (func $Set_nodeToListAcc (param $acc (ref null $ListBase)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref null $ListBase))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $v
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32
      struct.new $ListCons_37
      local.get $l
      call $nodeToListAcc_i32
    else
      local.get $acc
    end
  )
  (func $nodeMinElement_i32 (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $l
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $v
      else
        local.get $l
        call $nodeMinElement_i32
      end
    else
      i32.const 83
      i32.const 101
      i32.const 116
      i32.const 32
      i32.const 105
      i32.const 115
      i32.const 32
      i32.const 101
      i32.const 109
      i32.const 112
      i32.const 116
      i32.const 121
      array.new_fixed $WasmStr 12
      struct.new $Exception
      global.set $fsharp_exn_carrier
      ref.null any
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $Set_nodeMinElement (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $l
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $v
      else
        local.get $l
        call $nodeMinElement_i32
      end
    else
      i32.const 83
      i32.const 101
      i32.const 116
      i32.const 32
      i32.const 105
      i32.const 115
      i32.const 32
      i32.const 101
      i32.const 109
      i32.const 112
      i32.const 116
      i32.const 121
      array.new_fixed $WasmStr 12
      struct.new $Exception
      global.set $fsharp_exn_carrier
      ref.null any
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $nodeMaxElement_i32 (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $r
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $v
      else
        local.get $r
        call $nodeMaxElement_i32
      end
    else
      i32.const 83
      i32.const 101
      i32.const 116
      i32.const 32
      i32.const 105
      i32.const 115
      i32.const 32
      i32.const 101
      i32.const 109
      i32.const 112
      i32.const 116
      i32.const 121
      array.new_fixed $WasmStr 12
      struct.new $Exception
      global.set $fsharp_exn_carrier
      ref.null any
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $Set_nodeMaxElement (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $r
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $v
      else
        local.get $r
        call $nodeMaxElement_i32
      end
    else
      i32.const 83
      i32.const 101
      i32.const 116
      i32.const 32
      i32.const 105
      i32.const 115
      i32.const 32
      i32.const 101
      i32.const 109
      i32.const 112
      i32.const 116
      i32.const 121
      array.new_fixed $WasmStr 12
      struct.new $Exception
      global.set $fsharp_exn_carrier
      ref.null any
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $Set_empty (param $cmp (ref $AnyFn)) (result (ref $SetModule_SetHandle`1))
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_isEmpty (param $s (ref $SetModule_SetHandle`1)) (result i32)
    (local $matchValue (ref $SetModule_SetNode`1<i32>))
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    local.set $matchValue
    local.get $matchValue
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $Set_add (param $value i32) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $value
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeAdd_i32
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_contains (param $value i32) (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $value
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeContains_i32
  )
  (func $Set_remove (param $value i32) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $value
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeRemove_i32
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $closure_152 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    (local $self_cast (ref $ClosureType_152))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_152)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_152 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_152 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_152
    local.get $n
    struct.new $ClosureType_152
  )
  (func $closure_154 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    (local $self_cast (ref $ClosureType_154))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_154)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_154 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_154 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_154
    local.get $n
    struct.new $ClosureType_154
  )
  (func $Set_count (param $s (ref $SetModule_SetHandle`1)) (result i32)
    ref.func $closure_154
    struct.new $ClosureType_155
    i32.const 0
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeFold_i32~i32
  )
  (func $Set_fold (param $folder (ref $AnyFn)) (param $state i32) (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $state
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeFold_i32~i32
  )
  (func $Set_iter (param $action (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1))
    local.get $action
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeIter_i32
  )
  (func $Set_filter (param $predicate (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $predicate
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeFilter_i32
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_exists (param $predicate (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $predicate
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeExists_i32
  )
  (func $Set_forAll (param $predicate (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $predicate
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeForAll_i32
  )
  (func $closure_156 (param $self (ref $AnyFn)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_158))
    (local $acc (ref $SetModule_SetNode`1<i32>))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_42 (ref $ClosureBase_28))
    local.get $self
    ref.cast (ref $ClosureType_158)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_158 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_158 2
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_158 3
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_42
    local.get $lo_clo_42
    local.get $v
    local.get $lo_clo_42
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
    local.get $acc
    call $nodeAdd_i32
  )
  (func $closure_156 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_161))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_161)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_161 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_161 2
    local.set $s
    ref.func $closure_156
    local.get $acc
    local.get $mapping
    local.get $s
    struct.new $ClosureType_158
  )
  (func $closure_162 (param $self (ref $AnyFn)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_162))
    (local $acc (ref $SetModule_SetNode`1<i32>))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_43 (ref $ClosureBase_28))
    local.get $self
    ref.cast (ref $ClosureType_162)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_162 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_162 2
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_162 3
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_43
    local.get $lo_clo_43
    local.get $v
    local.get $lo_clo_43
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
    local.get $acc
    call $nodeAdd_i32
  )
  (func $closure_162 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_163))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_163)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_163 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_163 2
    local.set $s
    ref.func $closure_162
    local.get $acc
    local.get $mapping
    local.get $s
    struct.new $ClosureType_162
  )
  (func $nodeFold_ref148~i32 (param $folder (ref $AnyFn)) (param $state (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $s1 (ref $SetModule_SetNode`1<i32>))
    (local $s2 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $state
      local.get $l
      call $nodeFold_ref148~i32
      local.set $s1
      local.get $s2
      local.get $r
      call $nodeFold_ref148~i32
    else
      local.get $state
    end
  )
  (func $Set_map (param $mapping (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $mapped (ref $SetModule_SetNode`1<i32>))
    ref.func $closure_162
    local.get $mapping
    local.get $s
    struct.new $ClosureType_163
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeFold_ref148~i32
    local.set $mapped
    local.get $mapped
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_union (param $a (ref $SetModule_SetHandle`1)) (param $b (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    local.get $a
    struct.get $SetModule_SetHandle`1 1
    local.get $a
    struct.get $SetModule_SetHandle`1 0
    local.get $b
    struct.get $SetModule_SetHandle`1 0
    call $nodeUnion_i32
    local.get $a
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_intersect (param $a (ref $SetModule_SetHandle`1)) (param $b (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    local.get $a
    struct.get $SetModule_SetHandle`1 1
    local.get $b
    struct.get $SetModule_SetHandle`1 0
    local.get $a
    struct.get $SetModule_SetHandle`1 0
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    call $nodeIntersectAcc_i32
    local.get $a
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_difference (param $a (ref $SetModule_SetHandle`1)) (param $b (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    local.get $a
    struct.get $SetModule_SetHandle`1 1
    local.get $b
    struct.get $SetModule_SetHandle`1 0
    local.get $a
    struct.get $SetModule_SetHandle`1 0
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    call $nodeDifferenceAcc_i32
    local.get $a
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_isSubset (param $a (ref $SetModule_SetHandle`1)) (param $b (ref $SetModule_SetHandle`1)) (result i32)
    local.get $a
    struct.get $SetModule_SetHandle`1 1
    local.get $a
    struct.get $SetModule_SetHandle`1 0
    local.get $b
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeIsSubset_i32
  )
  (func $Set_toList (param $s (ref $SetModule_SetHandle`1)) (result (ref null $ListBase))
    ref.null $ListBase
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeToListAcc_i32
  )
  (func $add_i32 (param $value i32) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $value
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeAdd_i32
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    struct.new $SetModule_SetHandle`1
  )
  (func $closure_164 (param $self (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_166))
    (local $acc (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_166)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_166 1
    local.set $acc
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $closure_164 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))
    ref.func $closure_164
    local.get $acc
    struct.new $ClosureType_166
  )
  (func $empty_i32 (param $cmp (ref $AnyFn)) (result (ref $SetModule_SetHandle`1))
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_ofList (param $cmp (ref $AnyFn)) (param $xs (ref null $ListBase)) (result (ref $SetModule_SetHandle`1))
    (local $w83 (ref null $ListBase))
    (local $w84 (ref $SetModule_SetHandle`1))
    (local $x i32)
    local.get $xs
    local.set $w83
    call $empty_i32
    local.set $w84
    block $while_85_exit
      loop $while_85_lp
        local.get $w83
        ref.is_null
        i32.eqz
        if
          local.get $w83
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          local.get $w84
          call $add_i32
          local.set $w84
          local.get $w83
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w83
          br $while_85_lp
        else
          br $while_85_exit
        end
      end
    end
    local.get $w84
  )
  (func $closure_170 (param $self (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_170))
    (local $acc (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_170)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_170 1
    local.set $acc
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $closure_170 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))
    ref.func $closure_170
    local.get $acc
    struct.new $ClosureType_170
  )
  (func $Set_ofArray (param $cmp (ref $AnyFn)) (param $xs (ref $GcArray_117)) (result (ref $SetModule_SetHandle`1))
    (local $w88 i32)
    (local $w89 (ref $SetModule_SetHandle`1))
    (local $w90 i32)
    (local $x i32)
    local.get $xs
    array.len
    local.set $w88
    call $empty_i32
    local.set $w89
    i32.const 0
    local.set $w90
    block $while_91_exit
      loop $while_91_lp
        local.get $w90
        local.get $w88
        i32.lt_s
        if
          local.get $xs
          local.get $w90
          array.get $GcArray_117
          local.set $x
          local.get $x
          local.get $w89
          call $add_i32
          local.set $w89
          local.get $w90
          i32.const 1
          i32.add
          local.set $w90
          br $while_91_lp
        else
          br $while_91_exit
        end
      end
    end
    local.get $w89
  )
  (func $Set_singleton (param $cmp (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    local.get $x
    call $empty_i32
    return_call $add_i32
  )
  (func $Set_minElement (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeMinElement_i32
  )
  (func $Set_maxElement (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeMaxElement_i32
  )
  (func $runAllTests (param $check (ref $AnyFn)) ;; exported as "runAllTests"
    call $runBitwiseTests
    call $runClosuresTests
    call $runDUTests
    call $runExceptionsTests
    call $runInteropTests
    call $runOptionTests
    call $runPrimitivesTests
    call $runResultTests
    call $runStringBuilderTests
  )
  (func $closure_173 (param $self (ref $AnyFn)) (param $f (ref $AnyFn))
    (local $self_cast (ref $ClosureType_175))
    (local $failed i32)
    (local $passed i32)
    (local $lo_clo_44 (ref $ClosureBase_56))
    local.get $self
    ref.cast (ref $ClosureType_175)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_175 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_175 2
    local.set $passed
    (block
      (block
        (try_table (catch_all 0)
                local.get $f
                ref.cast (ref $ClosureBase_56)
                local.set $lo_clo_44
                local.get $lo_clo_44
                local.get $lo_clo_44
                struct.get $ClosureBase_56 0
                call_ref $FuncType_20
                local.get $passed
                i32.const 1
                i32.add
                local.set $passed
        )
        br 1
      )
        local.get $failed
        i32.const 1
        i32.add
        local.set $failed
    )
  )
  (func $closure_173 (param $self (ref $AnyFn)) (param $name i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_176))
    (local $failed i32)
    (local $passed i32)
    local.get $self
    ref.cast (ref $ClosureType_176)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_176 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_176 2
    local.set $passed
    ref.func $closure_173
    local.get $failed
    local.get $passed
    struct.new $ClosureType_175
  )
  (func $main (param $_arg (ref $GcArray_172)) (result i32) ;; exported as "main"
    (local $passed i32)
    (local $failed i32)
    (local $check (ref $ClosureType_176))
    i32.const 0
    local.set $passed
    i32.const 0
    local.set $failed
    ref.func $closure_173
    local.get $failed
    local.get $passed
    struct.new $ClosureType_176
    local.set $check
    local.get $check
    call $runAllTests
    local.get $failed
    i32.const 0
    i32.gt_s
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringInterpolation (result i32) ;; exported as "testStringInterpolation"
    (local $s (ref $WasmStr))
    i32.const 120
    i32.const 61
    array.new_fixed $WasmStr 2
    i32.const 42
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    local.set $s
    local.get $s
    array.len
  )
  (func $testStringInterpolationConcat (result i32) ;; exported as "testStringInterpolationConcat"
    (local $s (ref $WasmStr))
    array.new_fixed $WasmStr 0
    i32.const 3
    call $intToStr
    call $strConcat
    i32.const 43
    array.new_fixed $WasmStr 1
    call $strConcat
    i32.const 7
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    local.set $s
    local.get $s
    array.len
  )
  (func $testPrintfnLiteral (result i32) ;; exported as "testPrintfnLiteral"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $consolePrint
    i32.const 42
  )
  (func $closure_177 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_179))
    (local $clo (ref $AnyFn))
    (local $lo_clo_45 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_179)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_179 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_45
    local.get $lo_clo_45
    local.get $arg
    local.get $lo_clo_45
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfInt (result i32) ;; exported as "testSprintfInt"
    (local $lo_clo_46 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_177
    local.get $clo
    struct.new $ClosureType_179
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_46
    local.get $lo_clo_46
    i32.const 42
    local.get $lo_clo_46
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    array.len
  )
  (func $closure_180 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_180))
    (local $clo (ref $AnyFn))
    (local $lo_clo_47 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_180)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_180 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_47
    local.get $lo_clo_47
    local.get $arg
    local.get $lo_clo_47
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfNegInt (result i32) ;; exported as "testSprintfNegInt"
    (local $lo_clo_48 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_180
    local.get $clo
    struct.new $ClosureType_180
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_48
    local.get $lo_clo_48
    i32.const -7
    local.get $lo_clo_48
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    array.len
  )
  (func $closure_181 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_183))
    (local $clo (ref $AnyFn))
    (local $lo_clo_49 (ref $ClosureBase_182))
    local.get $self
    ref.cast (ref $ClosureType_183)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_183 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_182)
    local.set $lo_clo_49
    local.get $lo_clo_49
    local.get $arg
    local.get $lo_clo_49
    struct.get $ClosureBase_182 0
    call_ref $FuncType_181
  )
  (func $testSprintfStr (result i32) ;; exported as "testSprintfStr"
    (local $lo_clo_50 (ref $ClosureBase_182))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_181
    local.get $clo
    struct.new $ClosureType_183
    ref.cast (ref $ClosureBase_182)
    local.set $lo_clo_50
    local.get $lo_clo_50
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    local.get $lo_clo_50
    struct.get $ClosureBase_182 0
    call_ref $FuncType_181
    array.len
  )
  (func $closure_184 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_184))
    (local $clo (ref $AnyFn))
    (local $lo_clo_51 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_184)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_184 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_51
    local.get $lo_clo_51
    local.get $arg
    local.get $lo_clo_51
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfIntLiteral (result i32) ;; exported as "testSprintfIntLiteral"
    (local $lo_clo_52 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 120
    i32.const 61
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 4
    local.set $clo
    ref.func $closure_184
    local.get $clo
    struct.new $ClosureType_184
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_52
    local.get $lo_clo_52
    i32.const 100
    local.get $lo_clo_52
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    array.len
  )
  (func $closure_185 (param $self (ref $AnyFn)) (param $arg_1 i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_185))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_53 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_185)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_185 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_53
    local.get $lo_clo_53
    local.get $arg_1
    local.get $lo_clo_53
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $closure_185 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_186))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_54 (ref $ClosureBase_51))
    local.get $self
    ref.cast (ref $ClosureType_186)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_186 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_54
    local.get $lo_clo_54
    local.get $arg
    local.get $lo_clo_54
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    local.set $clo_1
    ref.func $closure_185
    local.get $clo_1
    struct.new $ClosureType_185
  )
  (func $testSprintfTwoInts (result i32) ;; exported as "testSprintfTwoInts"
    (local $lo_clo_55 (ref $ClosureType_186))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    i32.const 32
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 5
    local.set $clo
    ref.func $closure_185
    local.get $clo
    struct.new $ClosureType_186
    local.set $lo_clo_55
    local.get $lo_clo_55
    i32.const 3
    i32.const 7
    local.get $lo_clo_55
    struct.get $AnyFn 0
    call_ref $FuncType_187
    array.len
  )
  (func $closure_190 (param $self (ref $AnyFn)) (param $arg_1 (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_190))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_56 (ref $ClosureBase_182))
    local.get $self
    ref.cast (ref $ClosureType_190)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_190 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_182)
    local.set $lo_clo_56
    local.get $lo_clo_56
    local.get $arg_1
    local.get $lo_clo_56
    struct.get $ClosureBase_182 0
    call_ref $FuncType_181
  )
  (func $closure_189 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_192))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_57 (ref $ClosureBase_191))
    local.get $self
    ref.cast (ref $ClosureType_192)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_192 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_191)
    local.set $lo_clo_57
    local.get $lo_clo_57
    local.get $arg
    local.get $lo_clo_57
    struct.get $ClosureBase_191 0
    call_ref $FuncType_189
    local.set $clo_1
    ref.func $closure_190
    local.get $clo_1
    struct.new $ClosureType_190
  )
  (func $testSprintfTwoStrs (result i32) ;; exported as "testSprintfTwoStrs"
    (local $lo_clo_58 (ref $ClosureType_192))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 115
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 9
    local.set $clo
    ref.func $closure_189
    local.get $clo
    struct.new $ClosureType_192
    local.set $lo_clo_58
    local.get $lo_clo_58
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    local.get $lo_clo_58
    struct.get $AnyFn 0
    call_ref $FuncType_193
    array.len
  )
  (func $closure_194 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_194))
    (local $clo (ref $AnyFn))
    (local $lo_clo_59 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_194)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_194 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_59
    local.get $lo_clo_59
    local.get $arg
    local.get $lo_clo_59
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfBoolTrue (result i32) ;; exported as "testSprintfBoolTrue"
    (local $lo_clo_60 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 98
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_194
    local.get $clo
    struct.new $ClosureType_194
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_60
    local.get $lo_clo_60
    i32.const 1
    local.get $lo_clo_60
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    array.len
  )
  (func $closure_195 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_195))
    (local $clo (ref $AnyFn))
    (local $lo_clo_61 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_195)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_195 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_61
    local.get $lo_clo_61
    local.get $arg
    local.get $lo_clo_61
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfBoolFalse (result i32) ;; exported as "testSprintfBoolFalse"
    (local $lo_clo_62 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 98
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_195
    local.get $clo
    struct.new $ClosureType_195
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_62
    local.get $lo_clo_62
    i32.const 0
    local.get $lo_clo_62
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    array.len
  )
  (func $closure_197 (param $self (ref $AnyFn)) (param $arg_1 (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_197))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_63 (ref $ClosureBase_182))
    local.get $self
    ref.cast (ref $ClosureType_197)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_197 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_182)
    local.set $lo_clo_63
    local.get $lo_clo_63
    local.get $arg_1
    local.get $lo_clo_63
    struct.get $ClosureBase_182 0
    call_ref $FuncType_181
  )
  (func $closure_197 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_198))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_64 (ref $ClosureBase_51))
    local.get $self
    ref.cast (ref $ClosureType_198)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_198 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_64
    local.get $lo_clo_64
    local.get $arg
    local.get $lo_clo_64
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    local.set $clo_1
    ref.func $closure_197
    local.get $clo_1
    struct.new $ClosureType_197
  )
  (func $testSprintfMixed (result i32) ;; exported as "testSprintfMixed"
    (local $lo_clo_65 (ref $ClosureType_198))
    (local $clo (ref $WasmStr))
    i32.const 110
    i32.const 61
    i32.const 37
    i32.const 100
    i32.const 44
    i32.const 115
    i32.const 61
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 9
    local.set $clo
    ref.func $closure_197
    local.get $clo
    struct.new $ClosureType_198
    local.set $lo_clo_65
    local.get $lo_clo_65
    i32.const 7
    i32.const 104
    i32.const 105
    array.new_fixed $WasmStr 2
    local.get $lo_clo_65
    struct.get $AnyFn 0
    call_ref $FuncType_199
    array.len
  )
  (func $closure_200 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_200))
    (local $clo (ref $AnyFn))
    (local $lo_clo_66 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_200)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_200 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_66
    local.get $lo_clo_66
    local.get $arg
    local.get $lo_clo_66
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfZero (result i32) ;; exported as "testSprintfZero"
    (local $lo_clo_67 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_200
    local.get $clo
    struct.new $ClosureType_200
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_67
    local.get $lo_clo_67
    i32.const 0
    local.get $lo_clo_67
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_201 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_201))
    (local $clo (ref $AnyFn))
    (local $lo_clo_68 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_201)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_201 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_68
    local.get $lo_clo_68
    local.get $arg
    local.get $lo_clo_68
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfPrefix (result i32) ;; exported as "testSprintfPrefix"
    (local $lo_clo_69 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 82
    i32.const 101
    i32.const 115
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 58
    i32.const 32
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 10
    local.set $clo
    ref.func $closure_201
    local.get $clo
    struct.new $ClosureType_201
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_69
    local.get $lo_clo_69
    i32.const 99
    local.get $lo_clo_69
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_202 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_204))
    (local $clo (ref $AnyFn))
    (local $lo_clo_70 (ref $ClosureBase_203))
    local.get $self
    ref.cast (ref $ClosureType_204)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_204 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_70
    local.get $lo_clo_70
    local.get $arg
    local.get $lo_clo_70
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
  )
  (func $testSprintfFloat (result i32) ;; exported as "testSprintfFloat"
    (local $lo_clo_71 (ref $ClosureBase_203))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_202
    local.get $clo
    struct.new $ClosureType_204
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_71
    local.get $lo_clo_71
    f64.const 3.1400000000000001
    local.get $lo_clo_71
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
    array.len
  )
  (func $closure_205 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_205))
    (local $clo (ref $AnyFn))
    (local $lo_clo_72 (ref $ClosureBase_203))
    local.get $self
    ref.cast (ref $ClosureType_205)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_205 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_72
    local.get $lo_clo_72
    local.get $arg
    local.get $lo_clo_72
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
  )
  (func $testSprintfFloatHalf (result i32) ;; exported as "testSprintfFloatHalf"
    (local $lo_clo_73 (ref $ClosureBase_203))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_205
    local.get $clo
    struct.new $ClosureType_205
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_73
    local.get $lo_clo_73
    f64.const 0.5
    local.get $lo_clo_73
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
    array.len
  )
  (func $closure_206 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_206))
    (local $clo (ref $AnyFn))
    (local $lo_clo_74 (ref $ClosureBase_203))
    local.get $self
    ref.cast (ref $ClosureType_206)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_206 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_74
    local.get $lo_clo_74
    local.get $arg
    local.get $lo_clo_74
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
  )
  (func $testSprintfFloatWhole (result i32) ;; exported as "testSprintfFloatWhole"
    (local $lo_clo_75 (ref $ClosureBase_203))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_206
    local.get $clo
    struct.new $ClosureType_206
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_75
    local.get $lo_clo_75
    f64.const 2
    local.get $lo_clo_75
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
    array.len
  )
  (func $closure_207 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_207))
    (local $clo (ref $AnyFn))
    (local $lo_clo_76 (ref $ClosureBase_203))
    local.get $self
    ref.cast (ref $ClosureType_207)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_207 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_76
    local.get $lo_clo_76
    local.get $arg
    local.get $lo_clo_76
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
  )
  (func $testSprintfFloatNeg (result i32) ;; exported as "testSprintfFloatNeg"
    (local $lo_clo_77 (ref $ClosureBase_203))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_207
    local.get $clo
    struct.new $ClosureType_207
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_77
    local.get $lo_clo_77
    f64.const -1.5
    local.get $lo_clo_77
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
    array.len
  )
  (func $closure_208 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_208))
    (local $clo (ref $AnyFn))
    (local $lo_clo_78 (ref $ClosureBase_203))
    local.get $self
    ref.cast (ref $ClosureType_208)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_208 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_78
    local.get $lo_clo_78
    local.get $arg
    local.get $lo_clo_78
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
  )
  (func $testSprintfFloatInStr (result i32) ;; exported as "testSprintfFloatInStr"
    (local $lo_clo_79 (ref $ClosureBase_203))
    (local $clo (ref $WasmStr))
    i32.const 112
    i32.const 105
    i32.const 61
    i32.const 126
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 6
    local.set $clo
    ref.func $closure_208
    local.get $clo
    struct.new $ClosureType_208
    ref.cast (ref $ClosureBase_203)
    local.set $lo_clo_79
    local.get $lo_clo_79
    f64.const 3.1415899999999999
    local.get $lo_clo_79
    struct.get $ClosureBase_203 0
    call_ref $FuncType_202
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_209 (param $self (ref $AnyFn)) (param $arg i32)
    (local $self_cast (ref $ClosureType_210))
    (local $clo (ref $AnyFn))
    (local $lo_clo_80 (ref $ClosureBase_209))
    local.get $self
    ref.cast (ref $ClosureType_210)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_210 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_209)
    local.set $lo_clo_80
    local.get $lo_clo_80
    local.get $arg
    local.get $lo_clo_80
    struct.get $ClosureBase_209 0
    call_ref $FuncType_151
  )
  (func $testPrintfnInt (result i32) ;; exported as "testPrintfnInt"
    (local $lo_clo_81 (ref $ClosureBase_209))
    (local $clo i32)
    ref.func $closure_209
    local.get $clo
    struct.new $ClosureType_210
    ref.cast (ref $ClosureBase_209)
    local.set $lo_clo_81
    local.get $lo_clo_81
    i32.const 42
    local.get $lo_clo_81
    struct.get $ClosureBase_209 0
    call_ref $FuncType_151
    i32.const 1
  )
  (func $closure_211 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr))
    (local $self_cast (ref $ClosureType_213))
    (local $clo (ref $AnyFn))
    (local $lo_clo_82 (ref $ClosureBase_212))
    local.get $self
    ref.cast (ref $ClosureType_213)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_213 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_212)
    local.set $lo_clo_82
    local.get $lo_clo_82
    local.get $arg
    local.get $lo_clo_82
    struct.get $ClosureBase_212 0
    call_ref $FuncType_211
  )
  (func $testPrintfnStr (result i32) ;; exported as "testPrintfnStr"
    (local $lo_clo_83 (ref $ClosureBase_212))
    (local $clo i32)
    ref.func $closure_211
    local.get $clo
    struct.new $ClosureType_213
    ref.cast (ref $ClosureBase_212)
    local.set $lo_clo_83
    local.get $lo_clo_83
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    local.get $lo_clo_83
    struct.get $ClosureBase_212 0
    call_ref $FuncType_211
    i32.const 1
  )
  (func $closure_214 (param $self (ref $AnyFn)) (param $arg_2 i32)
    (local $self_cast (ref $ClosureType_214))
    (local $clo_2 (ref $AnyFn))
    (local $lo_clo_84 (ref $ClosureBase_209))
    local.get $self
    ref.cast (ref $ClosureType_214)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_214 1
    local.set $clo_2
    local.get $clo_2
    ref.cast (ref $ClosureBase_209)
    local.set $lo_clo_84
    local.get $lo_clo_84
    local.get $arg_2
    local.get $lo_clo_84
    struct.get $ClosureBase_209 0
    call_ref $FuncType_151
  )
  (func $closure_214 (param $self (ref $AnyFn)) (param $arg_1 i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_215))
    (local $clo_1 (ref $AnyFn))
    (local $clo_2 (ref $AnyFn))
    (local $lo_clo_85 (ref $ClosureBase_51))
    local.get $self
    ref.cast (ref $ClosureType_215)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_215 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_85
    local.get $lo_clo_85
    local.get $arg_1
    local.get $lo_clo_85
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    local.set $clo_2
    ref.func $closure_214
    local.get $clo_2
    struct.new $ClosureType_214
  )
  (func $closure_214 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_216))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_86 (ref $ClosureBase_51))
    local.get $self
    ref.cast (ref $ClosureType_216)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_216 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_86
    local.get $lo_clo_86
    local.get $arg
    local.get $lo_clo_86
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    local.set $clo_1
    ref.func $closure_214
    local.get $clo_1
    struct.new $ClosureType_215
  )
  (func $testPrintfnMulti (result i32) ;; exported as "testPrintfnMulti"
    (local $lo_clo_87 (ref $ClosureBase_643))
    (local $clo i32)
    ref.func $closure_214
    local.get $clo
    struct.new $ClosureType_216
    ref.cast (ref $ClosureBase_643)
    local.set $lo_clo_87
    local.get $lo_clo_87
    i32.const 3
    i32.const 7
    i32.const 10
    local.get $lo_clo_87
    struct.get $ClosureBase_643 0
    call_ref $FuncType_217
    i32.const 1
  )
  (func $closure_218 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_218))
    (local $clo (ref $AnyFn))
    (local $lo_clo_88 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_218)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_218 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_88
    local.get $lo_clo_88
    local.get $arg
    local.get $lo_clo_88
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfI (result i32) ;; exported as "testSprintfI"
    (local $lo_clo_89 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 105
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_218
    local.get $clo
    struct.new $ClosureType_218
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_89
    local.get $lo_clo_89
    i32.const 99
    local.get $lo_clo_89
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    array.len
  )
  (func $testSprintfPercent (result i32) ;; exported as "testSprintfPercent"
    i32.const 49
    i32.const 48
    i32.const 48
    i32.const 37
    array.new_fixed $WasmStr 4
    array.len
  )
  (func $closure_219 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_219))
    (local $clo (ref $AnyFn))
    (local $lo_clo_90 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_219)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_219 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_90
    local.get $lo_clo_90
    local.get $arg
    local.get $lo_clo_90
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfIntZeroChar (result i32) ;; exported as "testSprintfIntZeroChar"
    (local $lo_clo_91 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_219
    local.get $clo
    struct.new $ClosureType_219
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_91
    local.get $lo_clo_91
    i32.const 0
    local.get $lo_clo_91
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_220 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_220))
    (local $clo (ref $AnyFn))
    (local $lo_clo_92 (ref $ClosureBase_182))
    local.get $self
    ref.cast (ref $ClosureType_220)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_220 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_182)
    local.set $lo_clo_92
    local.get $lo_clo_92
    local.get $arg
    local.get $lo_clo_92
    struct.get $ClosureBase_182 0
    call_ref $FuncType_181
  )
  (func $testSprintfEmptyStr (result i32) ;; exported as "testSprintfEmptyStr"
    (local $lo_clo_93 (ref $ClosureBase_182))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_220
    local.get $clo
    struct.new $ClosureType_220
    ref.cast (ref $ClosureBase_182)
    local.set $lo_clo_93
    local.get $lo_clo_93
    array.new_fixed $WasmStr 0
    local.get $lo_clo_93
    struct.get $ClosureBase_182 0
    call_ref $FuncType_181
    array.len
  )
  (func $closure_221 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_221))
    (local $clo (ref $AnyFn))
    (local $lo_clo_94 (ref $ClosureBase_178))
    local.get $self
    ref.cast (ref $ClosureType_221)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_221 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_94
    local.get $lo_clo_94
    local.get $arg
    local.get $lo_clo_94
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
  )
  (func $testSprintfIntFirstChar (result i32) ;; exported as "testSprintfIntFirstChar"
    (local $lo_clo_95 (ref $ClosureBase_178))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_221
    local.get $clo
    struct.new $ClosureType_221
    ref.cast (ref $ClosureBase_178)
    local.set $lo_clo_95
    local.get $lo_clo_95
    i32.const 42
    local.get $lo_clo_95
    struct.get $ClosureBase_178 0
    call_ref $FuncType_177
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testInterpolationWithSprintf (result i32) ;; exported as "testInterpolationWithSprintf"
    (local $s (ref $WasmStr))
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 61
    array.new_fixed $WasmStr 4
    i32.const 99
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    local.set $s
    local.get $s
    array.len
  )
  (func $runPrintfTests (param $check (ref $AnyFn)) ;; exported as "runPrintfTests"
  )
  (func $closure_222 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_222 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w93 i32)
    (local $w94 i32)
    local.get $source_1
    local.set $w93
    i32.const 0
    local.set $w94
    block $while_95_exit
      loop $while_95_lp
        local.get $w93
        ref.is_null
        i32.eqz
        if
          local.get $w94
          local.get $w93
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w94
          local.get $w93
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w93
          br $while_95_lp
        else
          br $while_95_exit
        end
      end
    end
    local.get $w94
  )
  (func $closure_224 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_225 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqMap (result i32) ;; exported as "testSeqMap"
    (local $lo_clo_97 (ref $ClosureBase_28))
    (local $lo_clo_96 (ref $ClosureBase_40))
    (local $mapping (ref $ClosureType_224))
    ref.func $closure_222
    struct.new $ClosureType_223
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_97
    local.get $lo_clo_97
    ref.func $closure_224
    struct.new $ClosureType_224
    local.set $mapping
    ref.func $closure_225
    local.get $mapping
    struct.new $ClosureType_225
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_96
    local.get $lo_clo_96
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_96
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.get $lo_clo_97
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_226 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w97 i32)
    (local $w98 i32)
    local.get $source_1
    local.set $w97
    i32.const 0
    local.set $w98
    block $while_99_exit
      loop $while_99_lp
        local.get $w97
        ref.is_null
        i32.eqz
        if
          local.get $w98
          i32.const 1
          i32.add
          local.set $w98
          local.get $w97
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w97
          br $while_99_lp
        else
          br $while_99_exit
        end
      end
    end
    local.get $w98
  )
  (func $closure_227 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_228 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqFilter (result i32) ;; exported as "testSeqFilter"
    (local $lo_clo_99 (ref $ClosureBase_28))
    (local $lo_clo_98 (ref $ClosureBase_40))
    (local $predicate (ref $ClosureType_227))
    ref.func $closure_226
    struct.new $ClosureType_226
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_99
    local.get $lo_clo_99
    ref.func $closure_227
    struct.new $ClosureType_227
    local.set $predicate
    ref.func $closure_228
    local.get $predicate
    struct.new $ClosureType_228
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_98
    local.get $lo_clo_98
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_98
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.get $lo_clo_99
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_229 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_229))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_229)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_229 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_229 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_229
    local.get $acc
    struct.new $ClosureType_229
  )
  (func $testSeqFold (result i32) ;; exported as "testSeqFold"
    (local $w101 (ref null $ListBase))
    (local $w102 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w101
    i32.const 0
    local.set $w102
    block $while_103_exit
      loop $while_103_lp
        local.get $w101
        ref.is_null
        i32.eqz
        if
          local.get $w101
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $w102
          local.get $x
          i32.add
          local.set $w102
          local.get $w101
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w101
          br $while_103_lp
        else
          br $while_103_exit
        end
      end
    end
    local.get $w102
  )
  (func $closure_231 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testSeqExists (result i32) ;; exported as "testSeqExists"
    (local $w105 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w105
    block $exi_104_blk (result i32)
      block $exi_104_lp_exit
        loop $exi_104_lp
          local.get $w105
          ref.is_null
          i32.eqz
          if
            local.get $w105
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              i32.const 1
              br $exi_104_blk
            end
            local.get $w105
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w105
          else
            br $exi_104_lp_exit
          end
          br $exi_104_lp
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_232 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_233 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_233 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqSumBy (result i32) ;; exported as "testSeqSumBy"
    (local $lo_clo_100 (ref $ClosureBase_40))
    (local $projection (ref $ClosureType_232))
    ref.func $closure_232
    struct.new $ClosureType_232
    local.set $projection
    ref.func $closure_233
    local.get $projection
    struct.new $ClosureType_234
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_100
    local.get $lo_clo_100
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_100
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_235 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_235 (param $self (ref $AnyFn)) (param $source i32) (result i32)
    (local $w107 i32)
    (local $w108 i32)
    local.get $source
    local.set $w107
    i32.const 0
    local.set $w108
    block $while_109_exit
      loop $while_109_lp
        local.get $w107
        ref.is_null
        i32.eqz
        if
          local.get $w108
          local.get $w107
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w108
          local.get $w107
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w107
          br $while_109_lp
        else
          br $while_109_exit
        end
      end
    end
    local.get $w108
  )
  (func $closure_237 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $testSeqInit (result i32) ;; exported as "testSeqInit"
    (local $lo_clo_101 (ref $ClosureBase_40))
    (local $w111 i32)
    (local $w112 (ref null $ListBase))
    ref.func $closure_235
    struct.new $ClosureType_236
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_101
    local.get $lo_clo_101
    i32.const 4
    local.set $w111
    ref.null $ListBase
    local.set $w112
    block $while_113_exit
      loop $while_113_lp
        local.get $w111
        i32.const 0
        i32.ge_s
        if
          local.get $w111
          local.get $w111
          i32.mul
          local.get $w112
          struct.new $ListCons_37
          local.set $w112
          local.get $w111
          i32.const 1
          i32.sub
          local.set $w111
          br $while_113_lp
        else
          br $while_113_exit
        end
      end
    end
    local.get $w112
    local.get $lo_clo_101
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_238 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_238 (param $self (ref $AnyFn)) (param $source_2 i32) (result i32)
    (local $w115 i32)
    (local $w116 i32)
    local.get $source_2
    local.set $w115
    i32.const 0
    local.set $w116
    block $while_117_exit
      loop $while_117_lp
        local.get $w115
        ref.is_null
        i32.eqz
        if
          local.get $w116
          local.get $w115
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w116
          local.get $w115
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w115
          br $while_117_lp
        else
          br $while_117_exit
        end
      end
    end
    local.get $w116
  )
  (func $closure_240 (param $self (ref $AnyFn)) (param $tupledArg (ref $Tuple_105)) (result i32)
    (local $a i32)
    (local $b i32)
    local.get $tupledArg
    struct.get $Tuple_105 0
    local.set $a
    local.get $tupledArg
    struct.get $Tuple_105 1
    local.set $b
    local.get $b
    local.get $a
    i32.sub
  )
  (func $closure_243 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
  )
  (func $closure_244 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
    (local $w120 (ref $ListCons_37))
    (local $w121 i32)
    (local $w127 (ref null $ListBase))
    (local $w122 (ref null $ListBase))
    (local $w123 (ref null $ListBase))
    (local $w124 i32)
    (local $w125 (ref $Tuple_105))
    (local $w128 (ref null $ListBase))
    local.get $source
    ref.is_null
    if (result (ref null $ListBase))
      ref.null $ListBase
    else
      local.get $source
      ref.cast (ref $ListCons_37)
      local.set $w120
      local.get $w120
      struct.get $ListCons_37 0
      local.set $w121
      local.get $w120
      struct.get $ListCons_37 1
      local.set $w122
      ref.null $ListBase
      local.set $w123
      block $while_126_exit
        loop $while_126_lp
          local.get $w122
          ref.is_null
          i32.eqz
          if
            local.get $w122
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $w124
            local.get $w121
            local.get $w124
            struct.new $Tuple_105
            local.set $w125
            local.get $w124
            local.set $w121
            local.get $w125
            local.get $w123
            struct.new $ListCons_137
            local.set $w123
            local.get $w122
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w122
            br $while_126_lp
          else
            br $while_126_exit
          end
        end
      end
      local.get $w123
      local.set $w127
      ref.null $ListBase
      local.set $w128
      block $while_129_exit
        loop $while_129_lp
          local.get $w127
          ref.is_null
          i32.eqz
          if
            local.get $w127
            ref.cast (ref $ListCons_137)
            struct.get $ListCons_137 0
            local.get $w128
            struct.new $ListCons_137
            local.set $w128
            local.get $w127
            ref.cast (ref $ListCons_137)
            struct.get $ListCons_137 1
            local.set $w127
            br $while_129_lp
          else
            br $while_129_exit
          end
        end
      end
      local.get $w128
    end
  )
  (func $testSeqPairwise (result i32) ;; exported as "testSeqPairwise"
    (local $lo_clo_104 (ref $ClosureBase_28))
    (local $lo_clo_103 (ref $ClosureBase_28))
    (local $mapping (ref $ClosureType_242))
    (local $lo_clo_102 (ref $ClosureBase_40))
    ref.func $closure_238
    struct.new $ClosureType_239
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_104
    local.get $lo_clo_104
    ref.func $closure_240
    struct.new $ClosureType_242
    local.set $mapping
    ref.func $closure_243
    local.get $mapping
    struct.new $ClosureType_243
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_103
    local.get $lo_clo_103
    ref.func $closure_244
    struct.new $ClosureType_244
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_102
    local.get $lo_clo_102
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_102
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.get $lo_clo_103
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
    local.get $lo_clo_104
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_245 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_246 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_246 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqCountBy (result i32) ;; exported as "testSeqCountBy"
    (local $result i32)
    (local $lo_clo_105 (ref $ClosureBase_40))
    (local $projection (ref $ClosureType_245))
    (local $w131 i32)
    (local $w132 i32)
    ref.func $closure_245
    struct.new $ClosureType_245
    local.set $projection
    ref.func $closure_246
    local.get $projection
    struct.new $ClosureType_247
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_105
    local.get $lo_clo_105
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_105
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.set $result
    local.get $result
    local.set $w131
    i32.const 0
    local.set $w132
    block $while_133_exit
      loop $while_133_lp
        local.get $w131
        ref.is_null
        i32.eqz
        if
          local.get $w132
          i32.const 1
          i32.add
          local.set $w132
          local.get $w131
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 1
          local.set $w131
          br $while_133_lp
        else
          br $while_133_exit
        end
      end
    end
    local.get $w132
  )
  (func $closure_248 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w135 i32)
    (local $w136 i32)
    local.get $source_1
    local.set $w135
    i32.const 0
    local.set $w136
    block $while_137_exit
      loop $while_137_lp
        local.get $w135
        ref.is_null
        i32.eqz
        if
          local.get $w136
          i32.const 1
          i32.add
          local.set $w136
          local.get $w135
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w135
          br $while_137_lp
        else
          br $while_137_exit
        end
      end
    end
    local.get $w136
  )
  (func $closure_249 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $closure_249 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
    (local $w139 (ref null $ListBase))
    (local $w140 (ref null $ListBase))
    (local $w141 (ref null $ListBase))
    (local $dst_138_de i32)
    (local $w142 (ref null $ListBase))
    (local $w144 (ref null $ListBase))
    (local $w145 (ref null $ListBase))
    ref.null $ListBase
    local.set $w139
    ref.null $ListBase
    local.set $w140
    local.get $source
    local.set $w141
    block $while_143_exit
      loop $while_143_lp
        local.get $w141
        ref.is_null
        i32.eqz
        if
          local.get $w141
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $dst_138_de
          local.get $w140
          local.set $w142
          block $dst_138_blk (result i32)
            block $dst_138_lp_exit
              loop $dst_138_lp
                local.get $w142
                ref.is_null
                i32.eqz
                if
                  local.get $w142
                  ref.cast (ref $ListCons_37)
                  struct.get $ListCons_37 0
                  local.get $dst_138_de
                  i32.eq
                  if
                    i32.const 1
                    br $dst_138_blk
                  end
                  local.get $w142
                  ref.cast (ref $ListCons_37)
                  struct.get $ListCons_37 1
                  local.set $w142
                else
                  br $dst_138_lp_exit
                end
                br $dst_138_lp
              end
            end
            i32.const 0
          end
          if
          else
            local.get $dst_138_de
            local.get $w140
            struct.new $ListCons_37
            local.set $w140
            local.get $dst_138_de
            local.get $w139
            struct.new $ListCons_37
            local.set $w139
          end
          local.get $w141
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w141
          br $while_143_lp
        else
          br $while_143_exit
        end
      end
    end
    local.get $w139
    local.set $w144
    ref.null $ListBase
    local.set $w145
    block $while_146_exit
      loop $while_146_lp
        local.get $w144
        ref.is_null
        i32.eqz
        if
          local.get $w144
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w145
          struct.new $ListCons_37
          local.set $w145
          local.get $w144
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w144
          br $while_146_lp
        else
          br $while_146_exit
        end
      end
    end
    local.get $w145
  )
  (func $testSeqDistinct (result i32) ;; exported as "testSeqDistinct"
    (local $lo_clo_107 (ref $ClosureBase_28))
    (local $lo_clo_106 (ref $ClosureBase_40))
    ref.func $closure_248
    struct.new $ClosureType_248
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_107
    local.get $lo_clo_107
    ref.func $closure_249
    struct.new $ClosureType_250
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_106
    local.get $lo_clo_106
    i32.const 1
    i32.const 2
    i32.const 2
    i32.const 3
    i32.const 3
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_106
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.get $lo_clo_107
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_251 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_251 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w148 i32)
    (local $w149 i32)
    local.get $source_1
    local.set $w148
    i32.const 0
    local.set $w149
    block $while_150_exit
      loop $while_150_lp
        local.get $w148
        ref.is_null
        i32.eqz
        if
          local.get $w149
          local.get $w148
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w149
          local.get $w148
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w148
          br $while_150_lp
        else
          br $while_150_exit
        end
      end
    end
    local.get $w149
  )
  (func $closure_253 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_118))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_118))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_118
    else
      ref.null $Option_118
    end
  )
  (func $closure_254 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqChoose (result i32) ;; exported as "testSeqChoose"
    (local $lo_clo_109 (ref $ClosureBase_28))
    (local $lo_clo_108 (ref $ClosureBase_40))
    (local $chooser (ref $ClosureType_253))
    ref.func $closure_251
    struct.new $ClosureType_252
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_109
    local.get $lo_clo_109
    ref.func $closure_253
    struct.new $ClosureType_253
    local.set $chooser
    ref.func $closure_254
    local.get $chooser
    struct.new $ClosureType_254
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_108
    local.get $lo_clo_108
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_108
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.get $lo_clo_109
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_255 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_255 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w152 i32)
    (local $w153 i32)
    local.get $source_1
    local.set $w152
    i32.const 0
    local.set $w153
    block $while_154_exit
      loop $while_154_lp
        local.get $w152
        ref.is_null
        i32.eqz
        if
          local.get $w153
          local.get $w152
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w153
          local.get $w152
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w152
          br $while_154_lp
        else
          br $while_154_exit
        end
      end
    end
    local.get $w153
  )
  (func $closure_257 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
  )
  (func $closure_260 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqCollect (result i32) ;; exported as "testSeqCollect"
    (local $lo_clo_111 (ref $ClosureBase_28))
    (local $lo_clo_110 (ref $ClosureBase_40))
    (local $mapping (ref $ClosureType_259))
    ref.func $closure_255
    struct.new $ClosureType_256
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_111
    local.get $lo_clo_111
    ref.func $closure_257
    struct.new $ClosureType_259
    local.set $mapping
    ref.func $closure_260
    local.get $mapping
    struct.new $ClosureType_260
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_110
    local.get $lo_clo_110
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_110
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.get $lo_clo_111
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_261 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_261))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_261)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_261 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_261 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_261
    local.get $a
    struct.new $ClosureType_261
  )
  (func $closure_263 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqReduce (result i32) ;; exported as "testSeqReduce"
    (local $lo_clo_112 (ref $ClosureBase_40))
    (local $reduction (ref $ClosureType_262))
    ref.func $closure_261
    struct.new $ClosureType_262
    local.set $reduction
    ref.func $closure_263
    local.get $reduction
    struct.new $ClosureType_263
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_112
    local.get $lo_clo_112
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_112
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_264 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_264 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w156 i32)
    (local $w157 i32)
    local.get $source_1
    local.set $w156
    i32.const 0
    local.set $w157
    block $while_158_exit
      loop $while_158_lp
        local.get $w156
        ref.is_null
        i32.eqz
        if
          local.get $w157
          local.get $w156
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w157
          local.get $w156
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w156
          br $while_158_lp
        else
          br $while_158_exit
        end
      end
    end
    local.get $w157
  )
  (func $closure_266 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_266))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_266)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_266 1
    local.set $i
    local.get $i
    local.get $x
    i32.add
  )
  (func $closure_266 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_266
    local.get $i
    struct.new $ClosureType_266
  )
  (func $closure_268 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqMapIndexed (result i32) ;; exported as "testSeqMapIndexed"
    (local $lo_clo_114 (ref $ClosureBase_28))
    (local $lo_clo_113 (ref $ClosureBase_40))
    (local $mapping (ref $ClosureType_267))
    ref.func $closure_264
    struct.new $ClosureType_265
    ref.cast (ref $ClosureBase_28)
    local.set $lo_clo_114
    local.get $lo_clo_114
    ref.func $closure_266
    struct.new $ClosureType_267
    local.set $mapping
    ref.func $closure_268
    local.get $mapping
    struct.new $ClosureType_268
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_113
    local.get $lo_clo_113
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_113
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
    local.get $lo_clo_114
    struct.get $ClosureBase_28 0
    call_ref $FuncType_27
  )
  (func $closure_269 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testSeqForall (result i32) ;; exported as "testSeqForall"
    (local $w160 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w160
    block $all_159_blk (result i32)
      block $all_159_lp_exit
        loop $all_159_lp
          local.get $w160
          ref.is_null
          i32.eqz
          if
            local.get $w160
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w160
              ref.cast (ref $ListCons_37)
              struct.get $ListCons_37 1
              local.set $w160
            else
              i32.const 0
              br $all_159_blk
            end
          else
            br $all_159_lp_exit
          end
          br $all_159_lp
        end
      end
      i32.const 1
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testSeqHead (result i32) ;; exported as "testSeqHead"
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testSeqTryHead (result i32) ;; exported as "testSeqTryHead"
    (local $matchValue (ref null $Option_118))
    (local $w162 (ref null $ListBase))
    i32.const 42
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w162
    local.get $w162
    ref.is_null
    if (result (ref null $Option_118))
      ref.null $Option_118
    else
      local.get $w162
      ref.cast (ref $ListCons_37)
      struct.get $ListCons_37 0
      struct.new $Option_118
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $testSeqTryHeadEmpty (result i32) ;; exported as "testSeqTryHeadEmpty"
    (local $matchValue (ref null $Option_118))
    ref.null $Option_118
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
  )
  (func $testSeqIsEmpty (result i32) ;; exported as "testSeqIsEmpty"
    i32.const 2
  )
  (func $testSeqLength (result i32) ;; exported as "testSeqLength"
    (local $w166 (ref null $ListBase))
    (local $w167 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w166
    i32.const 0
    local.set $w167
    block $while_168_exit
      loop $while_168_lp
        local.get $w166
        ref.is_null
        i32.eqz
        if
          local.get $w167
          i32.const 1
          i32.add
          local.set $w167
          local.get $w166
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w166
          br $while_168_lp
        else
          br $while_168_exit
        end
      end
    end
    local.get $w167
  )
  (func $testSeqItem (result i32) ;; exported as "testSeqItem"
    (local $w170 i32)
    (local $w171 (ref null $ListBase))
    i32.const 2
    local.set $w170
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w171
    block $while_172_exit
      loop $while_172_lp
        local.get $w170
        i32.const 0
        i32.gt_s
        if
          local.get $w171
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w171
          local.get $w170
          i32.const 1
          i32.sub
          local.set $w170
          br $while_172_lp
        else
          br $while_172_exit
        end
      end
    end
    local.get $w171
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_270 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_271 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
    local.get $x_1
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSeqMinMax (result i32) ;; exported as "testSeqMinMax"
    (local $w174 (ref null $ListBase))
    (local $w175 (ref $ListCons_37))
    (local $w176 i32)
    (local $w177 (ref null $ListBase))
    (local $w178 i32)
    (local $w181 (ref null $ListBase))
    (local $w182 (ref $ListCons_37))
    (local $w183 i32)
    (local $w184 (ref null $ListBase))
    (local $w185 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w174
    local.get $w174
    ref.cast (ref $ListCons_37)
    local.set $w175
    local.get $w175
    struct.get $ListCons_37 0
    local.set $w176
    local.get $w175
    struct.get $ListCons_37 1
    local.set $w177
    block $while_179_exit
      loop $while_179_lp
        local.get $w177
        ref.is_null
        i32.eqz
        if
          local.get $w177
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w178
          local.get $w178
          local.get $w176
          i32.lt_s
          if
            local.get $w178
            local.set $w176
          end
          local.get $w177
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w177
          br $while_179_lp
        else
          br $while_179_exit
        end
      end
    end
    local.get $w176
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w181
    local.get $w181
    ref.cast (ref $ListCons_37)
    local.set $w182
    local.get $w182
    struct.get $ListCons_37 0
    local.set $w183
    local.get $w182
    struct.get $ListCons_37 1
    local.set $w184
    block $while_186_exit
      loop $while_186_lp
        local.get $w184
        ref.is_null
        i32.eqz
        if
          local.get $w184
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w185
          local.get $w185
          local.get $w183
          i32.gt_s
          if
            local.get $w185
            local.set $w183
          end
          local.get $w184
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w184
          br $while_186_lp
        else
          br $while_186_exit
        end
      end
    end
    local.get $w183
    i32.add
  )
  (func $closure_272 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    local.get $list_1
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_273 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_274 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_274 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testSeqSortBy (result i32) ;; exported as "testSeqSortBy"
    (local $lo_clo_116 (ref $ClosureBase_40))
    (local $lo_clo_115 (ref $ClosureBase_44))
    (local $projection (ref $ClosureType_273))
    ref.func $closure_272
    struct.new $ClosureType_272
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_116
    local.get $lo_clo_116
    ref.func $closure_273
    struct.new $ClosureType_273
    local.set $projection
    ref.func $closure_274
    local.get $projection
    struct.new $ClosureType_275
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_115
    local.get $lo_clo_115
    i32.const 30
    i32.const 10
    i32.const 20
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_115
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.get $lo_clo_116
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_276 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testSeqRev (result i32) ;; exported as "testSeqRev"
    (local $lo_clo_117 (ref $ClosureBase_40))
    (local $w188 (ref null $ListBase))
    (local $w189 (ref null $ListBase))
    ref.func $closure_276
    struct.new $ClosureType_276
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_117
    local.get $lo_clo_117
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w188
    ref.null $ListBase
    local.set $w189
    block $while_190_exit
      loop $while_190_lp
        local.get $w188
        ref.is_null
        i32.eqz
        if
          local.get $w188
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w189
          struct.new $ListCons_37
          local.set $w189
          local.get $w188
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w188
          br $while_190_lp
        else
          br $while_190_exit
        end
      end
    end
    local.get $w189
    local.get $lo_clo_117
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_277 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 20
    i32.gt_s
  )
  (func $testSeqFindIndex (result i32) ;; exported as "testSeqFindIndex"
    (local $w192 (ref null $ListBase))
    (local $w193 i32)
    (local $x i32)
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w192
    i32.const 0
    local.set $w193
    block $fdi_191_exit (result i32)
      loop $fdi_191_lp
        local.get $w192
        ref.is_null
        i32.eqz
        if
          local.get $w192
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          i32.const 20
          i32.gt_s
          if
            local.get $w193
            br $fdi_191_exit
          else
            local.get $w193
            i32.const 1
            i32.add
            local.set $w193
            local.get $w192
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w192
            br $fdi_191_lp
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_278 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_278 (param $self (ref $AnyFn)) (param $list_2 (ref null $ListBase)) (result i32)
    (local $w195 (ref null $ListBase))
    (local $w196 i32)
    local.get $list_2
    local.set $w195
    i32.const 0
    local.set $w196
    block $while_197_exit
      loop $while_197_lp
        local.get $w195
        ref.is_null
        i32.eqz
        if
          local.get $w196
          local.get $w195
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w196
          local.get $w195
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w195
          br $while_197_lp
        else
          br $while_197_exit
        end
      end
    end
    local.get $w196
  )
  (func $closure_280 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_280))
    (local $count_1 i32)
    (local $w203 (ref null $ListBase))
    (local $w199 i32)
    (local $w200 (ref null $ListBase))
    (local $w201 (ref null $ListBase))
    (local $w204 (ref null $ListBase))
    local.get $self
    ref.cast (ref $ClosureType_280)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_280 1
    local.set $count_1
    local.get $count_1
    local.set $w199
    local.get $list_1
    local.set $w200
    ref.null $ListBase
    local.set $w201
    block $while_202_exit
      loop $while_202_lp
        local.get $w199
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w200
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w200
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w201
          struct.new $ListCons_37
          local.set $w201
          local.get $w200
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w200
          local.get $w199
          i32.const 1
          i32.sub
          local.set $w199
          br $while_202_lp
        else
          br $while_202_exit
        end
      end
    end
    local.get $w201
    local.set $w203
    ref.null $ListBase
    local.set $w204
    block $while_205_exit
      loop $while_205_lp
        local.get $w203
        ref.is_null
        i32.eqz
        if
          local.get $w203
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w204
          struct.new $ListCons_37
          local.set $w204
          local.get $w203
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w203
          br $while_205_lp
        else
          br $while_205_exit
        end
      end
    end
    local.get $w204
  )
  (func $closure_281 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_281))
    (local $count i32)
    (local $w207 i32)
    (local $w208 (ref null $ListBase))
    local.get $self
    ref.cast (ref $ClosureType_281)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_281 1
    local.set $count
    local.get $count
    local.set $w207
    local.get $list
    local.set $w208
    block $while_209_exit
      loop $while_209_lp
        local.get $w207
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w208
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w208
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w208
          local.get $w207
          i32.const 1
          i32.sub
          local.set $w207
          br $while_209_lp
        else
          br $while_209_exit
        end
      end
    end
    local.get $w208
  )
  (func $testSeqSkipTake (result i32) ;; exported as "testSeqSkipTake"
    (local $lo_clo_120 (ref $ClosureBase_40))
    (local $lo_clo_119 (ref $ClosureBase_44))
    (local $lo_clo_118 (ref $ClosureBase_44))
    ref.func $closure_278
    struct.new $ClosureType_279
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_120
    local.get $lo_clo_120
    ref.func $closure_280
    i32.const 2
    struct.new $ClosureType_280
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_119
    local.get $lo_clo_119
    ref.func $closure_281
    i32.const 2
    struct.new $ClosureType_281
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_118
    local.get $lo_clo_118
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_118
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.get $lo_clo_119
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.get $lo_clo_120
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_282 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w211 (ref null $ListBase))
    (local $w212 i32)
    local.get $list_1
    local.set $w211
    i32.const 0
    local.set $w212
    block $while_213_exit
      loop $while_213_lp
        local.get $w211
        ref.is_null
        i32.eqz
        if
          local.get $w212
          i32.const 1
          i32.add
          local.set $w212
          local.get $w211
          ref.cast (ref $ListCons_283)
          struct.get $ListCons_283 1
          local.set $w211
          br $while_213_lp
        else
          br $while_213_exit
        end
      end
    end
    local.get $w212
  )
  (func $closure_285 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_286 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_286 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testSeqGroupByCount (result i32) ;; exported as "testSeqGroupByCount"
    (local $lo_clo_122 (ref $ClosureBase_40))
    (local $lo_clo_121 (ref $ClosureBase_44))
    (local $projection (ref $ClosureType_285))
    ref.func $closure_282
    struct.new $ClosureType_284
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_122
    local.get $lo_clo_122
    ref.func $closure_285
    struct.new $ClosureType_285
    local.set $projection
    ref.func $closure_286
    local.get $projection
    struct.new $ClosureType_287
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_121
    local.get $lo_clo_121
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_121
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.get $lo_clo_122
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $runSeqTests (param $check (ref $AnyFn)) ;; exported as "runSeqTests"
  )
  (func $testDistanceFromOrigin (param $x f64) (param $y f64) (result f64) ;; exported as "testDistanceFromOrigin"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testFib10 (result i32) ;; exported as "testFib10"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testFib15 (result i32) ;; exported as "testFib15"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $isPrime (param $n i32) (result i32) ;; exported as "isPrime"
    (local $i i32)
    (local $ok i32)
    local.get $n
    i32.const 2
    i32.lt_s
    if (result i32)
      i32.const 0
    else
      i32.const 2
      local.set $i
      i32.const 1
      local.set $ok
      loop $while
        local.get $i
        local.get $i
        i32.mul
        local.get $n
        i32.le_s
        if (result i32)
          local.get $ok
        else
          i32.const 0
        end
        if
          local.get $n
          local.get $i
          i32.rem_s
          i32.const 0
          i32.eq
          if
            i32.const 0
            local.set $ok
          end
          local.get $i
          i32.const 1
          i32.add
          local.set $i
          br $while
        end
      end
      local.get $ok
    end
  )
  (func $testIsPrime7 (result i32) ;; exported as "testIsPrime7"
    i32.const 7
    call $isPrime
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testIsPrime4 (result i32) ;; exported as "testIsPrime4"
    i32.const 4
    call $isPrime
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testCountPrimesTo50 (result i32) ;; exported as "testCountPrimesTo50"
    (local $count i32)
    (local $i i32)
    i32.const 0
    local.set $count
    i32.const 2
    local.set $i
    loop $for
      local.get $i
      i32.const 50
      i32.le_s
      if
        local.get $i
        call $isPrime
        if
          local.get $count
          i32.const 1
          i32.add
          local.set $count
        end
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $for
      end
    end
    local.get $count
  )
  (func $testCollatz27 (result i32) ;; exported as "testCollatz27"
    (local $n i32)
    (local $steps i32)
    i32.const 27
    local.set $n
    i32.const 0
    local.set $steps
    loop $while
      local.get $n
      i32.const 1
      i32.ne
      if
        local.get $n
        i32.const 2
        i32.rem_s
        i32.const 0
        i32.eq
        if
          local.get $n
          i32.const 1
          i32.shr_s
          i32.const -1
          i32.xor
          i32.const -1
          i32.xor
          local.set $n
        else
          i32.const 3
          local.get $n
          i32.mul
          i32.const 1
          i32.add
          local.set $n
        end
        local.get $steps
        i32.const 1
        i32.add
        local.set $steps
        br $while
      end
    end
    local.get $steps
  )
  (func $testPown2_10 (result i32) ;; exported as "testPown2_10"
    i32.const 2
    i32.const 10
    call $pown
  )
  (func $testPownZero (result i32) ;; exported as "testPownZero"
    i32.const 3
    i32.const 0
    call $pown
  )
  (func $testPownCube (result i32) ;; exported as "testPownCube"
    i32.const 5
    i32.const 3
    call $pown
  )
  (func $testPownOne (result i32) ;; exported as "testPownOne"
    i32.const 1
    i32.const 100
    call $pown
  )
  (func $closure_288 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_2_10 (result i32) ;; exported as "testPowF64_2_10"
    f64.const 2
    f64.const 10
    ref.func $closure_288
    struct.new $ClosureType_290
    call_ref $ClosureType_290
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_291 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_zero (result i32) ;; exported as "testPowF64_zero"
    f64.const 3
    f64.const 0
    ref.func $closure_291
    struct.new $ClosureType_291
    call_ref $ClosureType_291
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_292 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_cube (result i32) ;; exported as "testPowF64_cube"
    f64.const 5
    f64.const 3
    ref.func $closure_292
    struct.new $ClosureType_292
    call_ref $ClosureType_292
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathPow (result i32) ;; exported as "testMathPow"
    f64.const 2
    f64.const 8
    call $powF64
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathExp_zero (result i32) ;; exported as "testMathExp_zero"
    f64.const 0
    call $mathExp
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathExp_one (result i32) ;; exported as "testMathExp_one"
    f64.const 1
    call $mathExp
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathExp_ten (result i32) ;; exported as "testMathExp_ten"
    f64.const 10
    call $mathExp
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathExp_neg (result i32) ;; exported as "testMathExp_neg"
    f64.const -1
    call $mathExp
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathLog_one (result i32) ;; exported as "testMathLog_one"
    f64.const 1
    call $mathLog
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathLog_e (result i32) ;; exported as "testMathLog_e"
    f64.const 1
    call $mathExp
    call $mathLog
    f64.nearest
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathLog_1024 (result i32) ;; exported as "testMathLog_1024"
    f64.const 1024
    call $mathLog
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathExpLogRoundtrip (result i32) ;; exported as "testMathExpLogRoundtrip"
    f64.const 100
    call $mathLog
    f64.const 0.5
    f64.add
    call $mathExp
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathSin_zero (result i32) ;; exported as "testMathSin_zero"
    f64.const 0
    call $mathSin
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathSin_90deg (result i32) ;; exported as "testMathSin_90deg"
    f64.const 1.5707963267948966
    call $mathSin
    f64.nearest
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathCos_zero (result i32) ;; exported as "testMathCos_zero"
    f64.const 0
    call $mathCos
    f64.nearest
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathCos_180deg (result i32) ;; exported as "testMathCos_180deg"
    f64.const 3.1415926535897931
    call $mathCos
    f64.nearest
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathTan_zero (result i32) ;; exported as "testMathTan_zero"
    f64.const 0
    call $mathTan
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testMathTan_45deg (result i32) ;; exported as "testMathTan_45deg"
    f64.const 0.78539816339744828
    call $mathTan
    f64.nearest
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testClz_one (result i32) ;; exported as "testClz_one"
    i32.const 1
    i32.clz
  )
  (func $testClz_highBit (result i32) ;; exported as "testClz_highBit"
    i32.const -2147483648
    i32.clz
  )
  (func $testCtz_eight (result i32) ;; exported as "testCtz_eight"
    i32.const 8
    i32.ctz
  )
  (func $testCtz_one (result i32) ;; exported as "testCtz_one"
    i32.const 1
    i32.ctz
  )
  (func $testPopcnt_seven (result i32) ;; exported as "testPopcnt_seven"
    i32.const 7
    i32.popcnt
  )
  (func $testPopcnt_allOnes (result i32) ;; exported as "testPopcnt_allOnes"
    i32.const -1
    i32.popcnt
  )
  (func $testAtan2Origin (result i32) ;; exported as "testAtan2Origin"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testAtan2PosX (result i32) ;; exported as "testAtan2PosX"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testAtan2NegX (result i32) ;; exported as "testAtan2NegX"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testAtan2PosY (result i32) ;; exported as "testAtan2PosY"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testAtan2NegY (result i32) ;; exported as "testAtan2NegY"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $testAtan2Q3 (result i32) ;; exported as "testAtan2Q3"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $runMathTests (param $check (ref $AnyFn)) ;; exported as "runMathTests"
  )
  (func $testArrayLiteral (result i32) ;; exported as "testArrayLiteral"
    (local $arr (ref $GcArray_117))
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_117 3
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_117
  )
  (func $testArrayCreate (result i32) ;; exported as "testArrayCreate"
    (local $arr (ref $GcArray_117))
    i32.const 0
    i32.const 3
    array.new $GcArray_117
    local.set $arr
    local.get $arr
    i32.const 0
    i32.const 10
    array.set $GcArray_117
    local.get $arr
    i32.const 1
    i32.const 20
    array.set $GcArray_117
    local.get $arr
    i32.const 2
    i32.const 30
    array.set $GcArray_117
    local.get $arr
    i32.const 0
    array.get $GcArray_117
    local.get $arr
    i32.const 1
    array.get $GcArray_117
    i32.add
    local.get $arr
    i32.const 2
    array.get $GcArray_117
    i32.add
  )
  (func $testArrayZeroCreate (result i32) ;; exported as "testArrayZeroCreate"
    (local $arr (ref $GcArray_117))
    i32.const 0
    i32.const 4
    array.new $GcArray_117
    local.set $arr
    local.get $arr
    i32.const 2
    i32.const 7
    array.set $GcArray_117
    local.get $arr
    i32.const 2
    array.get $GcArray_117
  )
  (func $testArrayLength (result i32) ;; exported as "testArrayLength"
    (local $arr (ref $GcArray_117))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $arr
    local.get $arr
    array.len
  )
  (func $testArraySumLoop (result i32) ;; exported as "testArraySumLoop"
    (local $arr (ref $GcArray_117))
    (local $s i32)
    (local $i i32)
    (local $limit i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $arr
    i32.const 0
    local.set $s
    i32.const 0
    local.set $i
    local.get $arr
    array.len
    i32.const 1
    i32.sub
    local.set $limit
    loop $for
      local.get $i
      local.get $limit
      i32.le_s
      if
        local.get $s
        local.get $arr
        local.get $i
        array.get $GcArray_117
        i32.add
        local.set $s
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $for
      end
    end
    local.get $s
  )
  (func $testArrayFloat (result f64) ;; exported as "testArrayFloat"
    (local $arr (ref $GcArray_297))
    f64.const 1
    f64.const 3.1400000000000001
    f64.const 2.71
    array.new_fixed $GcArray_297 3
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_297
  )
  (func $closure_298 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_298))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_298)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_298 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_298 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_298
    local.get $acc
    struct.new $ClosureType_298
  )
  (func $testArrayFold (result i32) ;; exported as "testArrayFold"
    (local $w215 (ref $GcArray_117))
    (local $w216 i32)
    (local $w217 i32)
    (local $w218 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w215
    local.get $w215
    array.len
    local.set $w216
    i32.const 0
    local.set $w217
    i32.const 0
    local.set $w218
    block $while_219_exit
      loop $while_219_lp
        local.get $w218
        local.get $w216
        i32.lt_s
        if
          local.get $w215
          local.get $w218
          array.get $GcArray_117
          local.set $x
          local.get $w217
          local.get $x
          i32.add
          local.set $w217
          local.get $w218
          i32.const 1
          i32.add
          local.set $w218
          br $while_219_lp
        else
          br $while_219_exit
        end
      end
    end
    local.get $w217
  )
  (func $closure_300 (param $self (ref $AnyFn)) (param $x f64) (result f64)
    (local $self_cast (ref $ClosureType_302))
    (local $acc f64)
    local.get $self
    ref.cast (ref $ClosureType_302)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_302 1
    local.set $acc
    local.get $acc
    local.get $x
    f64.add
  )
  (func $closure_300 (param $self (ref $AnyFn)) (param $acc f64) (result (ref $AnyFn))
    ref.func $closure_300
    local.get $acc
    struct.new $ClosureType_302
  )
  (func $testArrayFoldFloat (result f64) ;; exported as "testArrayFoldFloat"
    (local $w221 (ref $GcArray_297))
    (local $w222 i32)
    (local $w223 f64)
    (local $w224 i32)
    (local $x f64)
    f64.const 0.5
    f64.const 0.5
    f64.const 0.5
    array.new_fixed $GcArray_297 3
    local.set $w221
    local.get $w221
    array.len
    local.set $w222
    f64.const 0
    local.set $w223
    i32.const 0
    local.set $w224
    block $while_225_exit
      loop $while_225_lp
        local.get $w224
        local.get $w222
        i32.lt_s
        if
          local.get $w221
          local.get $w224
          array.get $GcArray_297
          local.set $x
          local.get $w223
          local.get $x
          f64.add
          local.set $w223
          local.get $w224
          i32.const 1
          i32.add
          local.set $w224
          br $while_225_lp
        else
          br $while_225_exit
        end
      end
    end
    local.get $w223
  )
  (func $closure_306 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testArrayMap (result i32) ;; exported as "testArrayMap"
    (local $result (ref $GcArray_117))
    (local $w227 (ref $GcArray_117))
    (local $w228 i32)
    (local $w229 (ref $GcArray_117))
    (local $w231 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w227
    local.get $w227
    array.len
    local.set $w228
    i32.const 0
    local.get $w228
    array.new $GcArray_117
    local.set $w229
    i32.const 0
    local.set $w231
    block $while_232_exit
      loop $while_232_lp
        local.get $w231
        local.get $w228
        i32.lt_s
        if
          local.get $w229
          local.get $w231
          local.get $w227
          local.get $w231
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          array.set $GcArray_117
          local.get $w231
          i32.const 1
          i32.add
          local.set $w231
          br $while_232_lp
        else
          br $while_232_exit
        end
      end
    end
    local.get $w229
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_117
    local.get $result
    i32.const 4
    array.get $GcArray_117
    i32.add
  )
  (func $closure_307 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul
  )
  (func $testArrayMapStr (result i32) ;; exported as "testArrayMapStr"
    (local $src (ref $GcArray_117))
    (local $doubled (ref $GcArray_117))
    (local $w235 i32)
    (local $w236 (ref $GcArray_117))
    (local $w238 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $src
    local.get $src
    array.len
    local.set $w235
    i32.const 0
    local.get $w235
    array.new $GcArray_117
    local.set $w236
    i32.const 0
    local.set $w238
    block $while_239_exit
      loop $while_239_lp
        local.get $w238
        local.get $w235
        i32.lt_s
        if
          local.get $w236
          local.get $w238
          local.get $src
          local.get $w238
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 3
          i32.mul
          array.set $GcArray_117
          local.get $w238
          i32.const 1
          i32.add
          local.set $w238
          br $while_239_lp
        else
          br $while_239_exit
        end
      end
    end
    local.get $w236
    local.set $doubled
    local.get $doubled
    i32.const 2
    array.get $GcArray_117
  )
  (func $closure_308 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_308))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_308)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_308 1
    local.set $i
    local.get $i
    local.get $x
    i32.add
  )
  (func $closure_308 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_308
    local.get $i
    struct.new $ClosureType_308
  )
  (func $testArrayMapi (result i32) ;; exported as "testArrayMapi"
    (local $arr (ref $GcArray_117))
    (local $w241 (ref $GcArray_117))
    (local $w242 i32)
    (local $w243 (ref $GcArray_117))
    (local $w245 i32)
    (local $x i32)
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_117 3
    local.set $w241
    local.get $w241
    array.len
    local.set $w242
    i32.const 0
    local.get $w242
    array.new $GcArray_117
    local.set $w243
    i32.const 0
    local.set $w245
    block $while_246_exit
      loop $while_246_lp
        local.get $w245
        local.get $w242
        i32.lt_s
        if
          local.get $w243
          local.get $w245
          local.get $w241
          local.get $w245
          array.get $GcArray_117
          local.set $x
          local.get $w245
          local.get $x
          i32.add
          array.set $GcArray_117
          local.get $w245
          i32.const 1
          i32.add
          local.set $w245
          br $while_246_lp
        else
          br $while_246_exit
        end
      end
    end
    local.get $w243
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_117
  )
  (func $closure_310 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testArrayFilter (result i32) ;; exported as "testArrayFilter"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w248 i32)
    (local $w249 i32)
    (local $w250 i32)
    (local $x i32)
    (local $w252 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $arr
    local.get $arr
    array.len
    local.set $w248
    i32.const 0
    local.set $w249
    i32.const 0
    local.set $w250
    block $while_251_exit
      loop $while_251_lp
        local.get $w250
        local.get $w248
        i32.lt_s
        if
          local.get $arr
          local.get $w250
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            local.get $w249
            i32.const 1
            i32.add
            local.set $w249
          end
          local.get $w250
          i32.const 1
          i32.add
          local.set $w250
          br $while_251_lp
        else
          br $while_251_exit
        end
      end
    end
    i32.const 0
    local.set $w252
    i32.const 0
    local.set $w250
    block $while_253_exit
      loop $while_253_lp
        local.get $w250
        local.get $w248
        i32.lt_s
        if
          local.get $arr
          local.get $w250
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            i32.const 0
            local.get $w249
            array.new $GcArray_117
            local.get $w252
            local.get $arr
            local.get $w250
            array.get $GcArray_117
            array.set $GcArray_117
            local.get $w252
            i32.const 1
            i32.add
            local.set $w252
          end
          local.get $w250
          i32.const 1
          i32.add
          local.set $w250
          br $while_253_lp
        else
          br $while_253_exit
        end
      end
    end
    i32.const 0
    local.get $w249
    array.new $GcArray_117
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_311 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayFilterAll (result i32) ;; exported as "testArrayFilterAll"
    (local $result (ref $GcArray_117))
    (local $w255 i32)
    (local $w256 i32)
    (local $w257 i32)
    (local $x i32)
    (local $w259 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    array.len
    local.set $w255
    i32.const 0
    local.set $w256
    i32.const 0
    local.set $w257
    block $while_258_exit
      loop $while_258_lp
        local.get $w257
        local.get $w255
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_117 5
          local.get $w257
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            local.get $w256
            i32.const 1
            i32.add
            local.set $w256
          end
          local.get $w257
          i32.const 1
          i32.add
          local.set $w257
          br $while_258_lp
        else
          br $while_258_exit
        end
      end
    end
    i32.const 0
    local.set $w259
    i32.const 0
    local.set $w257
    block $while_260_exit
      loop $while_260_lp
        local.get $w257
        local.get $w255
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_117 5
          local.get $w257
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            i32.const 0
            local.get $w256
            array.new $GcArray_117
            local.get $w259
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_117 5
            local.get $w257
            array.get $GcArray_117
            array.set $GcArray_117
            local.get $w259
            i32.const 1
            i32.add
            local.set $w259
          end
          local.get $w257
          i32.const 1
          i32.add
          local.set $w257
          br $while_260_lp
        else
          br $while_260_exit
        end
      end
    end
    i32.const 0
    local.get $w256
    array.new $GcArray_117
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_312 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayFilterNone (result i32) ;; exported as "testArrayFilterNone"
    (local $result (ref $GcArray_117))
    (local $w262 i32)
    (local $w263 i32)
    (local $w264 i32)
    (local $x i32)
    (local $w266 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    array.len
    local.set $w262
    i32.const 0
    local.set $w263
    i32.const 0
    local.set $w264
    block $while_265_exit
      loop $while_265_lp
        local.get $w264
        local.get $w262
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_117 5
          local.get $w264
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w263
            i32.const 1
            i32.add
            local.set $w263
          end
          local.get $w264
          i32.const 1
          i32.add
          local.set $w264
          br $while_265_lp
        else
          br $while_265_exit
        end
      end
    end
    i32.const 0
    local.set $w266
    i32.const 0
    local.set $w264
    block $while_267_exit
      loop $while_267_lp
        local.get $w264
        local.get $w262
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_117 5
          local.get $w264
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            i32.const 0
            local.get $w263
            array.new $GcArray_117
            local.get $w266
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_117 5
            local.get $w264
            array.get $GcArray_117
            array.set $GcArray_117
            local.get $w266
            i32.const 1
            i32.add
            local.set $w266
          end
          local.get $w264
          i32.const 1
          i32.add
          local.set $w264
          br $while_267_lp
        else
          br $while_267_exit
        end
      end
    end
    i32.const 0
    local.get $w263
    array.new $GcArray_117
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_313 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 4
    i32.gt_s
  )
  (func $testArrayExists (result i32) ;; exported as "testArrayExists"
    (local $w269 i32)
    (local $w270 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    array.len
    local.set $w269
    i32.const 0
    local.set $w270
    block $isome_268_blk (result i32)
      block $while_271_exit
        loop $while_271_lp
          local.get $w270
          local.get $w269
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_117 5
            local.get $w270
            array.get $GcArray_117
            local.set $x
            local.get $x
            i32.const 4
            i32.gt_s
            if
              i32.const 1
              br $isome_268_blk
            end
            local.get $w270
            i32.const 1
            i32.add
            local.set $w270
            br $while_271_lp
          else
            br $while_271_exit
          end
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_314 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayExistsFalse (result i32) ;; exported as "testArrayExistsFalse"
    (local $w273 i32)
    (local $w274 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    array.len
    local.set $w273
    i32.const 0
    local.set $w274
    block $isome_272_blk (result i32)
      block $while_275_exit
        loop $while_275_lp
          local.get $w274
          local.get $w273
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_117 5
            local.get $w274
            array.get $GcArray_117
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $isome_272_blk
            end
            local.get $w274
            i32.const 1
            i32.add
            local.set $w274
            br $while_275_lp
          else
            br $while_275_exit
          end
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_315 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayForAll (result i32) ;; exported as "testArrayForAll"
    (local $w277 i32)
    (local $w278 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    array.len
    local.set $w277
    i32.const 0
    local.set $w278
    block $ievery_276_blk (result i32)
      block $while_279_exit
        loop $while_279_lp
          local.get $w278
          local.get $w277
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_117 5
            local.get $w278
            array.get $GcArray_117
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w278
              i32.const 1
              i32.add
              local.set $w278
            else
              i32.const 0
              br $ievery_276_blk
            end
            br $while_279_lp
          else
            br $while_279_exit
          end
        end
      end
      i32.const 1
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_316 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayForAllFalse (result i32) ;; exported as "testArrayForAllFalse"
    (local $w281 i32)
    (local $w282 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    array.len
    local.set $w281
    i32.const 0
    local.set $w282
    block $ievery_280_blk (result i32)
      block $while_283_exit
        loop $while_283_lp
          local.get $w282
          local.get $w281
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_117 5
            local.get $w282
            array.get $GcArray_117
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w282
              i32.const 1
              i32.add
              local.set $w282
            else
              i32.const 0
              br $ievery_280_blk
            end
            br $while_283_lp
          else
            br $while_283_exit
          end
        end
      end
      i32.const 1
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_317 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $testArrayInit (result i32) ;; exported as "testArrayInit"
    (local $arr (ref $GcArray_117))
    (local $w285 (ref $GcArray_117))
    (local $w286 i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_117
    local.set $w285
    i32.const 0
    local.set $w286
    block $while_287_exit
      loop $while_287_lp
        local.get $w286
        local.get $w285
        array.len
        i32.lt_s
        if
          local.get $w285
          local.get $w286
          local.get $w286
          local.get $w286
          i32.mul
          array.set $GcArray_117
          local.get $w286
          i32.const 1
          i32.add
          local.set $w286
          br $while_287_lp
        else
          br $while_287_exit
        end
      end
    end
    local.get $w285
    local.set $arr
    local.get $arr
    i32.const 3
    array.get $GcArray_117
  )
  (func $closure_318 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
  )
  (func $closure_319 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_319))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_319)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_319 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_319 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_319
    local.get $x
    struct.new $ClosureType_319
  )
  (func $testArrayInitFold (result i32) ;; exported as "testArrayInitFold"
    (local $arr (ref $GcArray_117))
    (local $w289 (ref $GcArray_117))
    (local $w290 i32)
    (local $w294 i32)
    (local $w295 i32)
    (local $w296 i32)
    (local $y i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_117
    local.set $w289
    i32.const 0
    local.set $w290
    block $while_291_exit
      loop $while_291_lp
        local.get $w290
        local.get $w289
        array.len
        i32.lt_s
        if
          local.get $w289
          local.get $w290
          local.get $w290
          array.set $GcArray_117
          local.get $w290
          i32.const 1
          i32.add
          local.set $w290
          br $while_291_lp
        else
          br $while_291_exit
        end
      end
    end
    local.get $w289
    local.set $arr
    local.get $arr
    array.len
    local.set $w294
    i32.const 0
    local.set $w295
    i32.const 0
    local.set $w296
    block $while_297_exit
      loop $while_297_lp
        local.get $w296
        local.get $w294
        i32.lt_s
        if
          local.get $arr
          local.get $w296
          array.get $GcArray_117
          local.set $y
          local.get $w295
          local.get $y
          i32.add
          local.set $w295
          local.get $w296
          i32.const 1
          i32.add
          local.set $w296
          br $while_297_lp
        else
          br $while_297_exit
        end
      end
    end
    local.get $w295
  )
  (func $closure_321 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_321))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_321)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_321 1
    local.set $s
    local.get $s
    local.get $x
    i32.add
    local.set $s
  )
  (func $testArrayIter (result i32) ;; exported as "testArrayIter"
    (local $s i32)
    (local $w299 (ref $GcArray_117))
    (local $w300 i32)
    (local $w301 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w299
    local.get $w299
    array.len
    local.set $w300
    i32.const 0
    local.set $w301
    block $while_302_exit
      loop $while_302_lp
        local.get $w301
        local.get $w300
        i32.lt_s
        if
          local.get $w299
          local.get $w301
          array.get $GcArray_117
          local.set $x
          local.get $s
          local.get $x
          i32.add
          local.set $s
          local.get $w301
          i32.const 1
          i32.add
          local.set $w301
          br $while_302_lp
        else
          br $while_302_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_322 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_322))
    (local $i i32)
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_322)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_322 1
    local.set $i
    local.get $self_cast
    struct.get $ClosureType_322 2
    local.set $s
    local.get $s
    local.get $i
    local.get $x
    i32.mul
    i32.add
    local.set $s
  )
  (func $closure_322 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_323))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_323)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_323 1
    local.set $s
    ref.func $closure_322
    local.get $i
    local.get $s
    struct.new $ClosureType_322
  )
  (func $testArrayIteri (result i32) ;; exported as "testArrayIteri"
    (local $s i32)
    (local $w304 (ref $GcArray_117))
    (local $w305 i32)
    (local $w306 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w304
    local.get $w304
    array.len
    local.set $w305
    i32.const 0
    local.set $w306
    block $while_307_exit
      loop $while_307_lp
        local.get $w306
        local.get $w305
        i32.lt_s
        if
          local.get $w304
          local.get $w306
          array.get $GcArray_117
          local.set $x
          local.get $s
          local.get $w306
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w306
          i32.const 1
          i32.add
          local.set $w306
          br $while_307_lp
        else
          br $while_307_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_324 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_324))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_324)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_324 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_324 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_324
    local.get $x
    struct.new $ClosureType_324
  )
  (func $testArrayReduce (result i32) ;; exported as "testArrayReduce"
    (local $w309 (ref $GcArray_117))
    (local $w310 i32)
    (local $w311 i32)
    (local $w312 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w309
    local.get $w309
    array.len
    local.set $w310
    local.get $w309
    i32.const 0
    array.get $GcArray_117
    local.set $w311
    i32.const 1
    local.set $w312
    block $while_313_exit
      loop $while_313_lp
        local.get $w312
        local.get $w310
        i32.lt_s
        if
          local.get $w309
          local.get $w312
          array.get $GcArray_117
          local.set $y
          local.get $w311
          local.get $y
          i32.add
          local.set $w311
          local.get $w312
          i32.const 1
          i32.add
          local.set $w312
          br $while_313_lp
        else
          br $while_313_exit
        end
      end
    end
    local.get $w311
  )
  (func $closure_326 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArraySum (result i32) ;; exported as "testArraySum"
    (local $w315 (ref $GcArray_117))
    (local $w316 i32)
    (local $w317 i32)
    (local $w318 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w315
    local.get $w315
    array.len
    local.set $w316
    i32.const 0
    local.set $w317
    i32.const 0
    local.set $w318
    block $while_319_exit
      loop $while_319_lp
        local.get $w318
        local.get $w316
        i32.lt_s
        if
          local.get $w317
          local.get $w315
          local.get $w318
          array.get $GcArray_117
          i32.add
          local.set $w317
          local.get $w318
          i32.const 1
          i32.add
          local.set $w318
          br $while_319_lp
        else
          br $while_319_exit
        end
      end
    end
    local.get $w317
  )
  (func $closure_327 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testArrayMin (result i32) ;; exported as "testArrayMin"
    (local $w321 (ref $GcArray_117))
    (local $w322 i32)
    (local $w323 i32)
    (local $w324 i32)
    (local $w325 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w321
    local.get $w321
    array.len
    local.set $w322
    local.get $w321
    i32.const 0
    array.get $GcArray_117
    local.set $w323
    i32.const 1
    local.set $w324
    block $while_326_exit
      loop $while_326_lp
        local.get $w324
        local.get $w322
        i32.lt_s
        if
          local.get $w321
          local.get $w324
          array.get $GcArray_117
          local.set $w325
          local.get $w325
          local.get $w323
          i32.lt_s
          if (result i32)
            local.get $w325
          else
            local.get $w323
          end
          local.set $w323
          local.get $w324
          i32.const 1
          i32.add
          local.set $w324
          br $while_326_lp
        else
          br $while_326_exit
        end
      end
    end
    local.get $w323
  )
  (func $closure_328 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testArrayMax (result i32) ;; exported as "testArrayMax"
    (local $w328 (ref $GcArray_117))
    (local $w329 i32)
    (local $w330 i32)
    (local $w331 i32)
    (local $w332 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $w328
    local.get $w328
    array.len
    local.set $w329
    local.get $w328
    i32.const 0
    array.get $GcArray_117
    local.set $w330
    i32.const 1
    local.set $w331
    block $while_333_exit
      loop $while_333_lp
        local.get $w331
        local.get $w329
        i32.lt_s
        if
          local.get $w328
          local.get $w331
          array.get $GcArray_117
          local.set $w332
          local.get $w332
          local.get $w330
          i32.gt_s
          if (result i32)
            local.get $w332
          else
            local.get $w330
          end
          local.set $w330
          local.get $w331
          i32.const 1
          i32.add
          local.set $w331
          br $while_333_lp
        else
          br $while_333_exit
        end
      end
    end
    local.get $w330
  )
  (func $testArrayRev (result i32) ;; exported as "testArrayRev"
    (local $w335 (ref $GcArray_117))
    (local $w336 i32)
    (local $w337 (ref $GcArray_117))
    (local $w338 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $w335
    local.get $w335
    array.len
    local.set $w336
    i32.const 0
    local.get $w336
    array.new $GcArray_117
    local.set $w337
    i32.const 0
    local.set $w338
    block $while_339_exit
      loop $while_339_lp
        local.get $w338
        local.get $w336
        i32.lt_s
        if
          local.get $w337
          local.get $w338
          local.get $w335
          local.get $w336
          i32.const 1
          i32.sub
          local.get $w338
          i32.sub
          array.get $GcArray_117
          array.set $GcArray_117
          local.get $w338
          i32.const 1
          i32.add
          local.set $w338
          br $while_339_lp
        else
          br $while_339_exit
        end
      end
    end
    local.get $w337
    i32.const 0
    array.get $GcArray_117
  )
  (func $closure_329 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testArraySort (result i32) ;; exported as "testArraySort"
    (local $w341 (ref $GcArray_117))
    (local $w342 i32)
    (local $w343 (ref $GcArray_117))
    (local $w344 i32)
    (local $w345 i32)
    (local $w346 i32)
    i32.const 3
    i32.const 1
    i32.const 2
    array.new_fixed $GcArray_117 3
    local.set $w341
    local.get $w341
    array.len
    local.set $w342
    i32.const 0
    local.get $w342
    array.new $GcArray_117
    local.set $w343
    local.get $w343
    i32.const 0
    local.get $w341
    i32.const 0
    local.get $w342
    array.copy $GcArray_117 $GcArray_117
    i32.const 1
    local.set $w344
    block $while_348_exit
      loop $while_348_lp
        local.get $w344
        local.get $w342
        i32.lt_s
        if
          local.get $w343
          local.get $w344
          array.get $GcArray_117
          local.set $w345
          local.get $w344
          i32.const 1
          i32.sub
          local.set $w346
          block $while_347_exit
            loop $while_347_lp
              local.get $w346
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w343
                local.get $w346
                array.get $GcArray_117
                local.get $w345
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w343
                  local.get $w346
                  array.get $GcArray_117
                  local.get $w345
                  i32.eq
                  if (result i32)
                    i32.const 0
                  else
                    i32.const 1
                  end
                end
                i32.const 0
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w343
                local.get $w346
                i32.const 1
                i32.add
                local.get $w343
                local.get $w346
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w346
                i32.const 1
                i32.sub
                local.set $w346
                br $while_347_lp
              else
                br $while_347_exit
              end
            end
          end
          local.get $w343
          local.get $w346
          i32.const 1
          i32.add
          local.get $w345
          array.set $GcArray_117
          local.get $w344
          i32.const 1
          i32.add
          local.set $w344
          br $while_348_lp
        else
          br $while_348_exit
        end
      end
    end
    local.get $w343
    i32.const 0
    array.get $GcArray_117
  )
  (func $closure_330 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayFindIndex (result i32) ;; exported as "testArrayFindIndex"
    (local $w350 i32)
    (local $w351 i32)
    (local $x i32)
    i32.const 1
    i32.const 5
    i32.const 2
    i32.const 4
    array.new_fixed $GcArray_117 4
    array.len
    local.set $w350
    i32.const 0
    local.set $w351
    block $afidx_349_search (result i32)
      block $while_352_exit
        loop $while_352_lp
          local.get $w351
          local.get $w350
          i32.lt_s
          if
            i32.const 1
            i32.const 5
            i32.const 2
            i32.const 4
            array.new_fixed $GcArray_117 4
            local.get $w351
            array.get $GcArray_117
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w351
              br $afidx_349_search
            end
            local.get $w351
            i32.const 1
            i32.add
            local.set $w351
            br $while_352_lp
          else
            br $while_352_exit
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_331 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContains (result i32) ;; exported as "testArrayContains"
    (local $w355 i32)
    (local $w356 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_117 4
    array.len
    local.set $w355
    i32.const 0
    local.set $w356
    block $acont_353_blk (result i32)
      block $while_357_exit
        loop $while_357_lp
          local.get $w356
          local.get $w355
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_117 4
            local.get $w356
            array.get $GcArray_117
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $acont_353_blk
            end
            local.get $w356
            i32.const 1
            i32.add
            local.set $w356
            br $while_357_lp
          else
            br $while_357_exit
          end
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_332 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContainsFalse (result i32) ;; exported as "testArrayContainsFalse"
    (local $w360 i32)
    (local $w361 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_117 4
    array.len
    local.set $w360
    i32.const 0
    local.set $w361
    block $acont_358_blk (result i32)
      block $while_362_exit
        loop $while_362_lp
          local.get $w361
          local.get $w360
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_117 4
            local.get $w361
            array.get $GcArray_117
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $acont_358_blk
            end
            local.get $w361
            i32.const 1
            i32.add
            local.set $w361
            br $while_362_lp
          else
            br $while_362_exit
          end
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_333 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_333))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_333)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_333 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_333 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_333
    local.get $x
    struct.new $ClosureType_333
  )
  (func $testArrayScan (result i32) ;; exported as "testArrayScan"
    (local $r (ref $GcArray_117))
    (local $w364 (ref $GcArray_117))
    (local $w365 (ref $GcArray_117))
    (local $w366 i32)
    (local $w368 i32)
    (local $w369 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_117 4
    local.set $w364
    i32.const 0
    local.get $w364
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_117
    local.set $w365
    i32.const 0
    local.set $w366
    local.get $w365
    i32.const 0
    local.get $w366
    array.set $GcArray_117
    local.get $w364
    array.len
    local.set $w368
    i32.const 0
    local.set $w369
    block $while_370_exit
      loop $while_370_lp
        local.get $w369
        local.get $w368
        i32.lt_s
        if
          local.get $w364
          local.get $w369
          array.get $GcArray_117
          local.set $y
          local.get $w366
          local.get $y
          i32.add
          local.set $w366
          local.get $w365
          local.get $w369
          i32.const 1
          i32.add
          local.get $w366
          array.set $GcArray_117
          local.get $w369
          i32.const 1
          i32.add
          local.set $w369
          br $while_370_lp
        else
          br $while_370_exit
        end
      end
    end
    local.get $w365
    local.set $r
    local.get $r
    local.get $r
    array.len
    i32.const 1
    i32.sub
    array.get $GcArray_117
  )
  (func $closure_335 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_335))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_335)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_335 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_335 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_335
    local.get $x
    struct.new $ClosureType_335
  )
  (func $testArrayScanLen (result i32) ;; exported as "testArrayScanLen"
    (local $w372 (ref $GcArray_117))
    (local $w373 (ref $GcArray_117))
    (local $w374 i32)
    (local $w376 i32)
    (local $w377 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_117 4
    local.set $w372
    i32.const 0
    local.get $w372
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_117
    local.set $w373
    i32.const 0
    local.set $w374
    local.get $w373
    i32.const 0
    local.get $w374
    array.set $GcArray_117
    local.get $w372
    array.len
    local.set $w376
    i32.const 0
    local.set $w377
    block $while_378_exit
      loop $while_378_lp
        local.get $w377
        local.get $w376
        i32.lt_s
        if
          local.get $w372
          local.get $w377
          array.get $GcArray_117
          local.set $y
          local.get $w374
          local.get $y
          i32.add
          local.set $w374
          local.get $w373
          local.get $w377
          i32.const 1
          i32.add
          local.get $w374
          array.set $GcArray_117
          local.get $w377
          i32.const 1
          i32.add
          local.set $w377
          br $while_378_lp
        else
          br $while_378_exit
        end
      end
    end
    local.get $w373
    array.len
  )
  (func $testArrayAppend (result i32) ;; exported as "testArrayAppend"
    (local $w380 (ref $GcArray_117))
    (local $w381 (ref $GcArray_117))
    (local $w382 i32)
    (local $w383 (ref $GcArray_117))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $w380
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 2
    local.set $w381
    local.get $w380
    array.len
    local.set $w382
    i32.const 0
    local.get $w382
    local.get $w381
    array.len
    i32.add
    array.new $GcArray_117
    local.set $w383
    local.get $w383
    i32.const 0
    local.get $w380
    i32.const 0
    local.get $w382
    array.copy $GcArray_117 $GcArray_117
    local.get $w383
    local.get $w382
    local.get $w381
    i32.const 0
    local.get $w381
    array.len
    array.copy $GcArray_117 $GcArray_117
    local.get $w383
    i32.const 3
    array.get $GcArray_117
  )
  (func $testArrayAppendLen (result i32) ;; exported as "testArrayAppendLen"
    (local $w385 (ref $GcArray_117))
    (local $w386 (ref $GcArray_117))
    (local $w387 i32)
    (local $w388 (ref $GcArray_117))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $w385
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 2
    local.set $w386
    local.get $w385
    array.len
    local.set $w387
    i32.const 0
    local.get $w387
    local.get $w386
    array.len
    i32.add
    array.new $GcArray_117
    local.set $w388
    local.get $w388
    i32.const 0
    local.get $w385
    i32.const 0
    local.get $w387
    array.copy $GcArray_117 $GcArray_117
    local.get $w388
    local.get $w387
    local.get $w386
    i32.const 0
    local.get $w386
    array.len
    array.copy $GcArray_117 $GcArray_117
    local.get $w388
    array.len
  )
  (func $closure_337 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayToList (result i32) ;; exported as "testArrayToList"
    (local $arr (ref $GcArray_117))
    (local $lst (ref null $ListBase))
    (local $w391 i32)
    (local $w392 (ref null $ListBase))
    (local $w395 (ref null $ListBase))
    (local $w396 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $arr
    local.get $arr
    array.len
    i32.const 1
    i32.sub
    local.set $w391
    ref.null $ListBase
    local.set $w392
    block $while_393_exit
      loop $while_393_lp
        local.get $w391
        i32.const 0
        i32.ge_s
        if
          local.get $arr
          local.get $w391
          array.get $GcArray_117
          local.get $w392
          struct.new $ListCons_37
          local.set $w392
          local.get $w391
          i32.const 1
          i32.sub
          local.set $w391
          br $while_393_lp
        else
          br $while_393_exit
        end
      end
    end
    local.get $w392
    local.set $lst
    local.get $lst
    local.set $w395
    i32.const 0
    local.set $w396
    block $while_397_exit
      loop $while_397_lp
        local.get $w395
        ref.is_null
        i32.eqz
        if
          local.get $w396
          local.get $w395
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w396
          local.get $w395
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w395
          br $while_397_lp
        else
          br $while_397_exit
        end
      end
    end
    local.get $w396
  )
  (func $closure_338 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListOfArray (result i32) ;; exported as "testListOfArray"
    (local $arr (ref $GcArray_117))
    (local $lst (ref null $ListBase))
    (local $w400 i32)
    (local $w401 (ref null $ListBase))
    (local $w404 (ref null $ListBase))
    (local $w405 i32)
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_117 3
    local.set $arr
    local.get $arr
    array.len
    i32.const 1
    i32.sub
    local.set $w400
    ref.null $ListBase
    local.set $w401
    block $while_402_exit
      loop $while_402_lp
        local.get $w400
        i32.const 0
        i32.ge_s
        if
          local.get $arr
          local.get $w400
          array.get $GcArray_117
          local.get $w401
          struct.new $ListCons_37
          local.set $w401
          local.get $w400
          i32.const 1
          i32.sub
          local.set $w400
          br $while_402_lp
        else
          br $while_402_exit
        end
      end
    end
    local.get $w401
    local.set $lst
    local.get $lst
    local.set $w404
    i32.const 0
    local.set $w405
    block $while_406_exit
      loop $while_406_lp
        local.get $w404
        ref.is_null
        i32.eqz
        if
          local.get $w405
          local.get $w404
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w405
          local.get $w404
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w404
          br $while_406_lp
        else
          br $while_406_exit
        end
      end
    end
    local.get $w405
  )
  (func $closure_339 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_339))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_339)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_339 1
    local.set $a
    local.get $a
    local.get $b
    i32.lt_s
    if (result i32)
      i32.const -1
    else
      local.get $a
      local.get $b
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        i32.const 0
      end
    end
  )
  (func $closure_339 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_339
    local.get $a
    struct.new $ClosureType_339
  )
  (func $testArraySortWith (result i32) ;; exported as "testArraySortWith"
    (local $arr (ref $GcArray_117))
    (local $sorted (ref $GcArray_117))
    (local $w409 i32)
    (local $w410 (ref $GcArray_117))
    (local $w411 i32)
    (local $w412 i32)
    (local $w413 i32)
    (local $a i32)
    (local $w408 (ref $GcArray_117))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_117 4
    local.set $arr
    local.get $arr
    array.len
    local.set $w409
    i32.const 0
    local.get $w409
    array.new $GcArray_117
    local.set $w410
    local.get $w410
    i32.const 0
    local.get $w408
    i32.const 0
    local.get $w409
    array.copy $GcArray_117 $GcArray_117
    i32.const 1
    local.set $w411
    block $while_415_exit
      loop $while_415_lp
        local.get $w411
        local.get $w409
        i32.lt_s
        if
          local.get $w410
          local.get $w411
          array.get $GcArray_117
          local.set $w412
          local.get $w411
          i32.const 1
          i32.sub
          local.set $w413
          block $while_414_exit
            loop $while_414_lp
              local.get $w413
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w410
                local.get $w413
                array.get $GcArray_117
                local.set $a
                local.get $a
                local.get $w412
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $a
                  local.get $w412
                  i32.gt_s
                  if (result i32)
                    i32.const 1
                  else
                    i32.const 0
                  end
                end
                i32.const 0
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w410
                local.get $w413
                i32.const 1
                i32.add
                local.get $w410
                local.get $w413
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w413
                i32.const 1
                i32.sub
                local.set $w413
                br $while_414_lp
              else
                br $while_414_exit
              end
            end
          end
          local.get $w410
          local.get $w413
          i32.const 1
          i32.add
          local.get $w412
          array.set $GcArray_117
          local.get $w411
          i32.const 1
          i32.add
          local.set $w411
          br $while_415_lp
        else
          br $while_415_exit
        end
      end
    end
    local.get $w410
    local.set $sorted
    local.get $sorted
    i32.const 0
    array.get $GcArray_117
  )
  (func $closure_341 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_341))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_341)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_341 1
    local.set $a
    local.get $b
    local.get $a
    i32.lt_s
    if (result i32)
      i32.const -1
    else
      local.get $b
      local.get $a
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        i32.const 0
      end
    end
  )
  (func $closure_341 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_341
    local.get $a
    struct.new $ClosureType_341
  )
  (func $testArraySortWithDesc (result i32) ;; exported as "testArraySortWithDesc"
    (local $arr (ref $GcArray_117))
    (local $sorted (ref $GcArray_117))
    (local $w418 i32)
    (local $w419 (ref $GcArray_117))
    (local $w420 i32)
    (local $w421 i32)
    (local $w422 i32)
    (local $a i32)
    (local $w417 (ref $GcArray_117))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_117 4
    local.set $arr
    local.get $arr
    array.len
    local.set $w418
    i32.const 0
    local.get $w418
    array.new $GcArray_117
    local.set $w419
    local.get $w419
    i32.const 0
    local.get $w417
    i32.const 0
    local.get $w418
    array.copy $GcArray_117 $GcArray_117
    i32.const 1
    local.set $w420
    block $while_424_exit
      loop $while_424_lp
        local.get $w420
        local.get $w418
        i32.lt_s
        if
          local.get $w419
          local.get $w420
          array.get $GcArray_117
          local.set $w421
          local.get $w420
          i32.const 1
          i32.sub
          local.set $w422
          block $while_423_exit
            loop $while_423_lp
              local.get $w422
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w419
                local.get $w422
                array.get $GcArray_117
                local.set $a
                local.get $w421
                local.get $a
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w421
                  local.get $a
                  i32.gt_s
                  if (result i32)
                    i32.const 1
                  else
                    i32.const 0
                  end
                end
                i32.const 0
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w419
                local.get $w422
                i32.const 1
                i32.add
                local.get $w419
                local.get $w422
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w422
                i32.const 1
                i32.sub
                local.set $w422
                br $while_423_lp
              else
                br $while_423_exit
              end
            end
          end
          local.get $w419
          local.get $w422
          i32.const 1
          i32.add
          local.get $w421
          array.set $GcArray_117
          local.get $w420
          i32.const 1
          i32.add
          local.set $w420
          br $while_424_lp
        else
          br $while_424_exit
        end
      end
    end
    local.get $w419
    local.set $sorted
    local.get $sorted
    i32.const 0
    array.get $GcArray_117
  )
  (func $testArrayZip (result i32) ;; exported as "testArrayZip"
    (local $arr1 (ref $GcArray_117))
    (local $arr2 (ref $GcArray_117))
    (local $zipped (ref $GcArray_343))
    (local $w428 (ref $GcArray_343))
    (local $w429 i32)
    (local $patternInput (ref $Tuple_105))
    (local $b i32)
    (local $a i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $arr1
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_117 3
    local.set $arr2
    i32.const 0
    i32.const 0
    struct.new $Tuple_105
    local.get $arr1
    array.len
    array.new $GcArray_343
    local.set $w428
    i32.const 0
    local.set $w429
    block $while_430_exit
      loop $while_430_lp
        local.get $w429
        local.get $arr1
        array.len
        i32.lt_s
        if
          local.get $w428
          local.get $w429
          local.get $arr1
          local.get $w429
          array.get $GcArray_117
          local.get $arr2
          local.get $w429
          array.get $GcArray_117
          struct.new $Tuple_105
          array.set $GcArray_343
          local.get $w429
          i32.const 1
          i32.add
          local.set $w429
          br $while_430_lp
        else
          br $while_430_exit
        end
      end
    end
    local.get $w428
    local.set $zipped
    local.get $zipped
    i32.const 0
    array.get $GcArray_343
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_105 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_105 0
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $testArrayZipLen (result i32) ;; exported as "testArrayZipLen"
    (local $zipped (ref $GcArray_343))
    (local $w432 (ref $GcArray_117))
    (local $w433 (ref $GcArray_117))
    (local $w434 (ref $GcArray_343))
    (local $w435 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $w432
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_117 3
    local.set $w433
    i32.const 0
    i32.const 0
    struct.new $Tuple_105
    local.get $w432
    array.len
    array.new $GcArray_343
    local.set $w434
    i32.const 0
    local.set $w435
    block $while_436_exit
      loop $while_436_lp
        local.get $w435
        local.get $w432
        array.len
        i32.lt_s
        if
          local.get $w434
          local.get $w435
          local.get $w432
          local.get $w435
          array.get $GcArray_117
          local.get $w433
          local.get $w435
          array.get $GcArray_117
          struct.new $Tuple_105
          array.set $GcArray_343
          local.get $w435
          i32.const 1
          i32.add
          local.set $w435
          br $while_436_lp
        else
          br $while_436_exit
        end
      end
    end
    local.get $w434
    local.set $zipped
    local.get $zipped
    array.len
  )
  (func $closure_344 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_344 (param $self (ref $AnyFn)) (param $array (ref $GcArray_117)) (result i32)
    (local $w439 i32)
    (local $w440 i32)
    (local $w441 i32)
    local.get $array
    array.len
    local.set $w439
    i32.const 0
    local.set $w440
    i32.const 0
    local.set $w441
    block $while_442_exit
      loop $while_442_lp
        local.get $w441
        local.get $w439
        i32.lt_s
        if
          local.get $w440
          local.get $array
          local.get $w441
          array.get $GcArray_117
          i32.add
          local.set $w440
          local.get $w441
          i32.const 1
          i32.add
          local.set $w441
          br $while_442_lp
        else
          br $while_442_exit
        end
      end
    end
    local.get $w440
  )
  (func $closure_348 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_348))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_348)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_348 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_348 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_348
    local.get $a
    struct.new $ClosureType_348
  )
  (func $testArrayMap2Sum (result i32) ;; exported as "testArrayMap2Sum"
    (local $lo_clo_123 (ref $ClosureBase_346))
    (local $w444 (ref $GcArray_117))
    (local $w445 (ref $GcArray_117))
    (local $w446 i32)
    (local $w447 (ref $GcArray_117))
    (local $w448 i32)
    (local $a i32)
    (local $b i32)
    ref.func $closure_344
    struct.new $ClosureType_347
    ref.cast (ref $ClosureBase_346)
    local.set $lo_clo_123
    local.get $lo_clo_123
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $w444
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_117 3
    local.set $w445
    local.get $w444
    array.len
    local.set $w446
    i32.const 0
    local.get $w446
    array.new $GcArray_117
    local.set $w447
    i32.const 0
    local.set $w448
    block $while_449_exit
      loop $while_449_lp
        local.get $w448
        local.get $w446
        i32.lt_s
        if
          local.get $w447
          local.get $w448
          local.get $w444
          local.get $w448
          array.get $GcArray_117
          local.set $a
          local.get $w445
          local.get $w448
          array.get $GcArray_117
          local.set $b
          local.get $a
          local.get $b
          i32.add
          array.set $GcArray_117
          local.get $w448
          i32.const 1
          i32.add
          local.set $w448
          br $while_449_lp
        else
          br $while_449_exit
        end
      end
    end
    local.get $w447
    local.get $lo_clo_123
    struct.get $ClosureBase_346 0
    call_ref $FuncType_345
  )
  (func $closure_350 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_350))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_350)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_350 1
    local.set $a
    local.get $a
    local.get $b
    i32.mul
  )
  (func $closure_350 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_350
    local.get $a
    struct.new $ClosureType_350
  )
  (func $testArrayMap2Head (result i32) ;; exported as "testArrayMap2Head"
    (local $w451 (ref $GcArray_117))
    (local $w452 (ref $GcArray_117))
    (local $w453 i32)
    (local $w454 (ref $GcArray_117))
    (local $w455 i32)
    (local $a i32)
    (local $b i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $w451
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_117 3
    local.set $w452
    local.get $w451
    array.len
    local.set $w453
    i32.const 0
    local.get $w453
    array.new $GcArray_117
    local.set $w454
    i32.const 0
    local.set $w455
    block $while_456_exit
      loop $while_456_lp
        local.get $w455
        local.get $w453
        i32.lt_s
        if
          local.get $w454
          local.get $w455
          local.get $w451
          local.get $w455
          array.get $GcArray_117
          local.set $a
          local.get $w452
          local.get $w455
          array.get $GcArray_117
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          array.set $GcArray_117
          local.get $w455
          i32.const 1
          i32.add
          local.set $w455
          br $while_456_lp
        else
          br $while_456_exit
        end
      end
    end
    local.get $w454
    i32.const 0
    array.get $GcArray_117
  )
  (func $closure_352 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_118))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_118))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_118
    else
      ref.null $Option_118
    end
  )
  (func $closure_353 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayChooseBasic (result i32) ;; exported as "testArrayChooseBasic"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w463 i32)
    (local $w459 i32)
    (local $w460 i32)
    (local $x i32)
    (local $w461 (ref null $Option_118))
    (local $w464 (ref $GcArray_117))
    (local $w465 i32)
    (local $w466 i32)
    (local $w467 (ref null $Option_118))
    (local $w471 i32)
    (local $w472 i32)
    (local $w473 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_117 5
    local.set $arr
    i32.const 0
    local.set $w459
    i32.const 0
    local.set $w460
    block $while_462_exit
      loop $while_462_lp
        local.get $w460
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w460
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_118))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_118
          else
            ref.null $Option_118
          end
          local.set $w461
          local.get $w461
          ref.is_null
          i32.eqz
          if
            local.get $w459
            i32.const 1
            i32.add
            local.set $w459
          end
          local.get $w460
          i32.const 1
          i32.add
          local.set $w460
          br $while_462_lp
        else
          br $while_462_exit
        end
      end
    end
    local.get $w459
    local.set $w463
    i32.const 0
    local.get $w463
    array.new $GcArray_117
    local.set $w464
    i32.const 0
    local.set $w465
    i32.const 0
    local.set $w466
    block $while_468_exit
      loop $while_468_lp
        local.get $w466
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w466
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_118))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_118
          else
            ref.null $Option_118
          end
          local.set $w467
          local.get $w467
          ref.is_null
          i32.eqz
          if
            local.get $w464
            local.get $w465
            local.get $w467
            ref.cast (ref $Option_118)
            struct.get $Option_118 0
            array.set $GcArray_117
            local.get $w465
            i32.const 1
            i32.add
            local.set $w465
          end
          local.get $w466
          i32.const 1
          i32.add
          local.set $w466
          br $while_468_lp
        else
          br $while_468_exit
        end
      end
    end
    local.get $w464
    local.set $result
    local.get $result
    array.len
    local.set $w471
    i32.const 0
    local.set $w472
    i32.const 0
    local.set $w473
    block $while_474_exit
      loop $while_474_lp
        local.get $w473
        local.get $w471
        i32.lt_s
        if
          local.get $w472
          local.get $result
          local.get $w473
          array.get $GcArray_117
          i32.add
          local.set $w472
          local.get $w473
          i32.const 1
          i32.add
          local.set $w473
          br $while_474_lp
        else
          br $while_474_exit
        end
      end
    end
    local.get $w472
  )
  (func $closure_354 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_118))
    local.get $x
    i32.const 3
    i32.gt_s
    if (result (ref null $Option_118))
      local.get $x
      struct.new $Option_118
    else
      ref.null $Option_118
    end
  )
  (func $testArrayChooseLength (result i32) ;; exported as "testArrayChooseLength"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w481 i32)
    (local $w477 i32)
    (local $w478 i32)
    (local $x i32)
    (local $w479 (ref null $Option_118))
    (local $w482 (ref $GcArray_117))
    (local $w483 i32)
    (local $w484 i32)
    (local $w485 (ref null $Option_118))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_117 6
    local.set $arr
    i32.const 0
    local.set $w477
    i32.const 0
    local.set $w478
    block $while_480_exit
      loop $while_480_lp
        local.get $w478
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w478
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_118))
            local.get $x
            struct.new $Option_118
          else
            ref.null $Option_118
          end
          local.set $w479
          local.get $w479
          ref.is_null
          i32.eqz
          if
            local.get $w477
            i32.const 1
            i32.add
            local.set $w477
          end
          local.get $w478
          i32.const 1
          i32.add
          local.set $w478
          br $while_480_lp
        else
          br $while_480_exit
        end
      end
    end
    local.get $w477
    local.set $w481
    i32.const 0
    local.get $w481
    array.new $GcArray_117
    local.set $w482
    i32.const 0
    local.set $w483
    i32.const 0
    local.set $w484
    block $while_486_exit
      loop $while_486_lp
        local.get $w484
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w484
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_118))
            local.get $x
            struct.new $Option_118
          else
            ref.null $Option_118
          end
          local.set $w485
          local.get $w485
          ref.is_null
          i32.eqz
          if
            local.get $w482
            local.get $w483
            local.get $w485
            ref.cast (ref $Option_118)
            struct.get $Option_118 0
            array.set $GcArray_117
            local.get $w483
            i32.const 1
            i32.add
            local.set $w483
          end
          local.get $w484
          i32.const 1
          i32.add
          local.set $w484
          br $while_486_lp
        else
          br $while_486_exit
        end
      end
    end
    local.get $w482
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_355 (param $self (ref $AnyFn)) (param $_x i32) (result (ref null $Option_118))
    ref.null $Option_118
  )
  (func $testArrayChooseEmpty (result i32) ;; exported as "testArrayChooseEmpty"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w493 i32)
    (local $w489 i32)
    (local $w490 i32)
    (local $w494 (ref $GcArray_117))
    (local $w495 i32)
    (local $w496 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $arr
    i32.const 0
    local.set $w489
    i32.const 0
    local.set $w490
    block $while_492_exit
      loop $while_492_lp
        local.get $w490
        local.get $arr
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w489
            i32.const 1
            i32.add
            local.set $w489
          end
          local.get $w490
          i32.const 1
          i32.add
          local.set $w490
          br $while_492_lp
        else
          br $while_492_exit
        end
      end
    end
    local.get $w489
    local.set $w493
    i32.const 0
    local.get $w493
    array.new $GcArray_117
    local.set $w494
    i32.const 0
    local.set $w495
    i32.const 0
    local.set $w496
    block $while_498_exit
      loop $while_498_lp
        local.get $w496
        local.get $arr
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w494
            local.get $w495
            ref.null $Option_118
            ref.cast (ref $Option_118)
            struct.get $Option_118 0
            array.set $GcArray_117
            local.get $w495
            i32.const 1
            i32.add
            local.set $w495
          end
          local.get $w496
          i32.const 1
          i32.add
          local.set $w496
          br $while_498_lp
        else
          br $while_498_exit
        end
      end
    end
    local.get $w494
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_356 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_118))
    local.get $x
    i32.const 10
    i32.add
    struct.new $Option_118
  )
  (func $testArrayChooseAllSome (result i32) ;; exported as "testArrayChooseAllSome"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w505 i32)
    (local $w501 i32)
    (local $w502 i32)
    (local $x i32)
    (local $w503 (ref null $Option_118))
    (local $w506 (ref $GcArray_117))
    (local $w507 i32)
    (local $w508 i32)
    (local $w509 (ref null $Option_118))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $arr
    i32.const 0
    local.set $w501
    i32.const 0
    local.set $w502
    block $while_504_exit
      loop $while_504_lp
        local.get $w502
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w502
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_118
          local.set $w503
          local.get $w503
          ref.is_null
          i32.eqz
          if
            local.get $w501
            i32.const 1
            i32.add
            local.set $w501
          end
          local.get $w502
          i32.const 1
          i32.add
          local.set $w502
          br $while_504_lp
        else
          br $while_504_exit
        end
      end
    end
    local.get $w501
    local.set $w505
    i32.const 0
    local.get $w505
    array.new $GcArray_117
    local.set $w506
    i32.const 0
    local.set $w507
    i32.const 0
    local.set $w508
    block $while_510_exit
      loop $while_510_lp
        local.get $w508
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w508
          array.get $GcArray_117
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_118
          local.set $w509
          local.get $w509
          ref.is_null
          i32.eqz
          if
            local.get $w506
            local.get $w507
            local.get $w509
            ref.cast (ref $Option_118)
            struct.get $Option_118 0
            array.set $GcArray_117
            local.get $w507
            i32.const 1
            i32.add
            local.set $w507
          end
          local.get $w508
          i32.const 1
          i32.add
          local.set $w508
          br $while_510_lp
        else
          br $while_510_exit
        end
      end
    end
    local.get $w506
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_117
    local.get $result
    i32.const 1
    array.get $GcArray_117
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_117
    i32.add
  )
  (func $closure_357 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_117))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    array.new_fixed $GcArray_117 2
  )
  (func $closure_360 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayCollectBasic (result i32) ;; exported as "testArrayCollectBasic"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w517 i32)
    (local $w513 i32)
    (local $w514 i32)
    (local $x i32)
    (local $w515 (ref $GcArray_117))
    (local $w518 (ref $GcArray_117))
    (local $w519 i32)
    (local $w520 i32)
    (local $w521 (ref $GcArray_117))
    (local $w525 i32)
    (local $w526 i32)
    (local $w527 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $arr
    i32.const 0
    local.set $w513
    i32.const 0
    local.set $w514
    block $while_516_exit
      loop $while_516_lp
        local.get $w514
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w514
          array.get $GcArray_117
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_117 2
          local.set $w515
          local.get $w513
          local.get $w515
          array.len
          i32.add
          local.set $w513
          local.get $w514
          i32.const 1
          i32.add
          local.set $w514
          br $while_516_lp
        else
          br $while_516_exit
        end
      end
    end
    local.get $w513
    local.set $w517
    i32.const 0
    local.get $w517
    array.new $GcArray_117
    local.set $w518
    i32.const 0
    local.set $w519
    i32.const 0
    local.set $w520
    block $while_522_exit
      loop $while_522_lp
        local.get $w520
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w520
          array.get $GcArray_117
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_117 2
          local.set $w521
          local.get $w518
          local.get $w519
          local.get $w521
          i32.const 0
          local.get $w521
          array.len
          array.copy $GcArray_117 $GcArray_117
          local.get $w519
          local.get $w521
          array.len
          i32.add
          local.set $w519
          local.get $w520
          i32.const 1
          i32.add
          local.set $w520
          br $while_522_lp
        else
          br $while_522_exit
        end
      end
    end
    local.get $w518
    local.set $result
    local.get $result
    array.len
    local.set $w525
    i32.const 0
    local.set $w526
    i32.const 0
    local.set $w527
    block $while_528_exit
      loop $while_528_lp
        local.get $w527
        local.get $w525
        i32.lt_s
        if
          local.get $w526
          local.get $result
          local.get $w527
          array.get $GcArray_117
          i32.add
          local.set $w526
          local.get $w527
          i32.const 1
          i32.add
          local.set $w527
          br $while_528_lp
        else
          br $while_528_exit
        end
      end
    end
    local.get $w526
  )
  (func $closure_361 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_117))
    local.get $x
    local.get $x
    array.new_fixed $GcArray_117 2
  )
  (func $testArrayCollectLength (result i32) ;; exported as "testArrayCollectLength"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w535 i32)
    (local $w531 i32)
    (local $w532 i32)
    (local $x i32)
    (local $w533 (ref $GcArray_117))
    (local $w536 (ref $GcArray_117))
    (local $w537 i32)
    (local $w538 i32)
    (local $w539 (ref $GcArray_117))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $arr
    i32.const 0
    local.set $w531
    i32.const 0
    local.set $w532
    block $while_534_exit
      loop $while_534_lp
        local.get $w532
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w532
          array.get $GcArray_117
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_117 2
          local.set $w533
          local.get $w531
          local.get $w533
          array.len
          i32.add
          local.set $w531
          local.get $w532
          i32.const 1
          i32.add
          local.set $w532
          br $while_534_lp
        else
          br $while_534_exit
        end
      end
    end
    local.get $w531
    local.set $w535
    i32.const 0
    local.get $w535
    array.new $GcArray_117
    local.set $w536
    i32.const 0
    local.set $w537
    i32.const 0
    local.set $w538
    block $while_540_exit
      loop $while_540_lp
        local.get $w538
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w538
          array.get $GcArray_117
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_117 2
          local.set $w539
          local.get $w536
          local.get $w537
          local.get $w539
          i32.const 0
          local.get $w539
          array.len
          array.copy $GcArray_117 $GcArray_117
          local.get $w537
          local.get $w539
          array.len
          i32.add
          local.set $w537
          local.get $w538
          i32.const 1
          i32.add
          local.set $w538
          br $while_540_lp
        else
          br $while_540_exit
        end
      end
    end
    local.get $w536
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_362 (param $self (ref $AnyFn)) (param $_x i32) (result (ref $GcArray_117))
    array.new_fixed $GcArray_117 0
  )
  (func $testArrayCollectEmpty (result i32) ;; exported as "testArrayCollectEmpty"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w547 i32)
    (local $w543 i32)
    (local $w544 i32)
    (local $w545 (ref $GcArray_117))
    (local $w548 (ref $GcArray_117))
    (local $w549 i32)
    (local $w550 i32)
    (local $w551 (ref $GcArray_117))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_117 3
    local.set $arr
    i32.const 0
    local.set $w543
    i32.const 0
    local.set $w544
    block $while_546_exit
      loop $while_546_lp
        local.get $w544
        local.get $arr
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_117 0
          local.set $w545
          local.get $w543
          local.get $w545
          array.len
          i32.add
          local.set $w543
          local.get $w544
          i32.const 1
          i32.add
          local.set $w544
          br $while_546_lp
        else
          br $while_546_exit
        end
      end
    end
    local.get $w543
    local.set $w547
    i32.const 0
    local.get $w547
    array.new $GcArray_117
    local.set $w548
    i32.const 0
    local.set $w549
    i32.const 0
    local.set $w550
    block $while_552_exit
      loop $while_552_lp
        local.get $w550
        local.get $arr
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_117 0
          local.set $w551
          local.get $w548
          local.get $w549
          local.get $w551
          i32.const 0
          local.get $w551
          array.len
          array.copy $GcArray_117 $GcArray_117
          local.get $w549
          local.get $w551
          array.len
          i32.add
          local.set $w549
          local.get $w550
          i32.const 1
          i32.add
          local.set $w550
          br $while_552_lp
        else
          br $while_552_exit
        end
      end
    end
    local.get $w548
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_363 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_117))
    local.get $x
    array.new_fixed $GcArray_117 1
  )
  (func $testArrayCollectSingleton (result i32) ;; exported as "testArrayCollectSingleton"
    (local $arr (ref $GcArray_117))
    (local $result (ref $GcArray_117))
    (local $w559 i32)
    (local $w555 i32)
    (local $w556 i32)
    (local $x i32)
    (local $w557 (ref $GcArray_117))
    (local $w560 (ref $GcArray_117))
    (local $w561 i32)
    (local $w562 i32)
    (local $w563 (ref $GcArray_117))
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_117 3
    local.set $arr
    i32.const 0
    local.set $w555
    i32.const 0
    local.set $w556
    block $while_558_exit
      loop $while_558_lp
        local.get $w556
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w556
          array.get $GcArray_117
          local.set $x
          local.get $x
          array.new_fixed $GcArray_117 1
          local.set $w557
          local.get $w555
          local.get $w557
          array.len
          i32.add
          local.set $w555
          local.get $w556
          i32.const 1
          i32.add
          local.set $w556
          br $while_558_lp
        else
          br $while_558_exit
        end
      end
    end
    local.get $w555
    local.set $w559
    i32.const 0
    local.get $w559
    array.new $GcArray_117
    local.set $w560
    i32.const 0
    local.set $w561
    i32.const 0
    local.set $w562
    block $while_564_exit
      loop $while_564_lp
        local.get $w562
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w562
          array.get $GcArray_117
          local.set $x
          local.get $x
          array.new_fixed $GcArray_117 1
          local.set $w563
          local.get $w560
          local.get $w561
          local.get $w563
          i32.const 0
          local.get $w563
          array.len
          array.copy $GcArray_117 $GcArray_117
          local.get $w561
          local.get $w563
          array.len
          i32.add
          local.set $w561
          local.get $w562
          i32.const 1
          i32.add
          local.set $w562
          br $while_564_lp
        else
          br $while_564_exit
        end
      end
    end
    local.get $w560
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_117
    local.get $result
    i32.const 1
    array.get $GcArray_117
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_117
    i32.add
  )
  (func $testResizeArrayBasic (result i32) ;; exported as "testResizeArrayBasic"
    (local $xs (ref $ResizeArray_364))
    (local $w566 i32)
    (local $w567 (ref $GcArray_117))
    (local $w568 i32)
    (local $w569 (ref $GcArray_117))
    (local $w571 i32)
    (local $w572 (ref $GcArray_117))
    (local $w573 i32)
    (local $w574 (ref $GcArray_117))
    (local $w576 i32)
    (local $w577 (ref $GcArray_117))
    (local $w578 i32)
    (local $w579 (ref $GcArray_117))
    i32.const 0
    i32.const 4
    array.new $GcArray_117
    i32.const 0
    struct.new $ResizeArray_364
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_364 1
    local.set $w566
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.set $w567
    local.get $w566
    local.get $w567
    array.len
    i32.ge_u
    if
      local.get $w567
      array.len
      i32.const 1
      i32.shl
      local.set $w568
      i32.const 0
      local.get $w568
      array.new $GcArray_117
      local.set $w569
      local.get $w569
      i32.const 0
      local.get $w567
      i32.const 0
      local.get $w566
      array.copy $GcArray_117 $GcArray_117
      local.get $xs
      local.get $w569
      struct.set $ResizeArray_364 0
    end
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.get $w566
    i32.const 10
    array.set $GcArray_117
    local.get $xs
    local.get $w566
    i32.const 1
    i32.add
    struct.set $ResizeArray_364 1
    local.get $xs
    struct.get $ResizeArray_364 1
    local.set $w571
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.set $w572
    local.get $w571
    local.get $w572
    array.len
    i32.ge_u
    if
      local.get $w572
      array.len
      i32.const 1
      i32.shl
      local.set $w573
      i32.const 0
      local.get $w573
      array.new $GcArray_117
      local.set $w574
      local.get $w574
      i32.const 0
      local.get $w572
      i32.const 0
      local.get $w571
      array.copy $GcArray_117 $GcArray_117
      local.get $xs
      local.get $w574
      struct.set $ResizeArray_364 0
    end
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.get $w571
    i32.const 20
    array.set $GcArray_117
    local.get $xs
    local.get $w571
    i32.const 1
    i32.add
    struct.set $ResizeArray_364 1
    local.get $xs
    struct.get $ResizeArray_364 1
    local.set $w576
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.set $w577
    local.get $w576
    local.get $w577
    array.len
    i32.ge_u
    if
      local.get $w577
      array.len
      i32.const 1
      i32.shl
      local.set $w578
      i32.const 0
      local.get $w578
      array.new $GcArray_117
      local.set $w579
      local.get $w579
      i32.const 0
      local.get $w577
      i32.const 0
      local.get $w576
      array.copy $GcArray_117 $GcArray_117
      local.get $xs
      local.get $w579
      struct.set $ResizeArray_364 0
    end
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.get $w576
    i32.const 30
    array.set $GcArray_117
    local.get $xs
    local.get $w576
    i32.const 1
    i32.add
    struct.set $ResizeArray_364 1
    local.get $xs
    struct.get $ResizeArray_364 1
  )
  (func $closure_366 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_367 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayUnzip (result i32) ;; exported as "testArrayUnzip"
    (local $pairs (ref $GcArray_343))
    (local $patternInput (ref $Tuple_365))
    (local $w582 i32)
    (local $w583 (ref $GcArray_117))
    (local $w584 (ref $GcArray_117))
    (local $w585 i32)
    (local $w586 (ref $Tuple_105))
    (local $ys (ref $GcArray_117))
    (local $xs (ref $GcArray_117))
    (local $w590 i32)
    (local $w591 i32)
    (local $w592 i32)
    (local $w596 i32)
    (local $w597 i32)
    (local $w598 i32)
    i32.const 1
    i32.const 4
    struct.new $Tuple_105
    i32.const 2
    i32.const 5
    struct.new $Tuple_105
    i32.const 3
    i32.const 6
    struct.new $Tuple_105
    array.new_fixed $GcArray_343 3
    local.set $pairs
    local.get $pairs
    array.len
    local.set $w582
    i32.const 0
    local.get $w582
    array.new $GcArray_117
    local.set $w583
    i32.const 0
    local.get $w582
    array.new $GcArray_117
    local.set $w584
    i32.const 0
    local.set $w585
    block $while_587_exit
      loop $while_587_lp
        local.get $w585
        local.get $w582
        i32.lt_s
        if
          local.get $pairs
          local.get $w585
          array.get $GcArray_343
          local.set $w586
          local.get $w583
          local.get $w585
          local.get $w586
          struct.get $Tuple_105 0
          array.set $GcArray_117
          local.get $w584
          local.get $w585
          local.get $w586
          struct.get $Tuple_105 1
          array.set $GcArray_117
          local.get $w585
          i32.const 1
          i32.add
          local.set $w585
          br $while_587_lp
        else
          br $while_587_exit
        end
      end
    end
    local.get $w583
    local.get $w584
    struct.new $Tuple_365
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_365 1
    local.set $ys
    local.get $patternInput
    struct.get $Tuple_365 0
    local.set $xs
    local.get $xs
    array.len
    local.set $w590
    i32.const 0
    local.set $w591
    i32.const 0
    local.set $w592
    block $while_593_exit
      loop $while_593_lp
        local.get $w592
        local.get $w590
        i32.lt_s
        if
          local.get $w591
          local.get $xs
          local.get $w592
          array.get $GcArray_117
          i32.add
          local.set $w591
          local.get $w592
          i32.const 1
          i32.add
          local.set $w592
          br $while_593_lp
        else
          br $while_593_exit
        end
      end
    end
    local.get $w591
    local.get $ys
    array.len
    local.set $w596
    i32.const 0
    local.set $w597
    i32.const 0
    local.set $w598
    block $while_599_exit
      loop $while_599_lp
        local.get $w598
        local.get $w596
        i32.lt_s
        if
          local.get $w597
          local.get $ys
          local.get $w598
          array.get $GcArray_117
          i32.add
          local.set $w597
          local.get $w598
          i32.const 1
          i32.add
          local.set $w598
          br $while_599_lp
        else
          br $while_599_exit
        end
      end
    end
    local.get $w597
    i32.add
  )
  (func $testResizeArrayIndex (result i32) ;; exported as "testResizeArrayIndex"
    (local $xs (ref $ResizeArray_364))
    (local $w601 i32)
    (local $w602 (ref $GcArray_117))
    (local $w603 i32)
    (local $w604 (ref $GcArray_117))
    (local $w606 i32)
    (local $w607 (ref $GcArray_117))
    (local $w608 i32)
    (local $w609 (ref $GcArray_117))
    (local $w611 i32)
    (local $w612 (ref $GcArray_117))
    (local $w613 i32)
    (local $w614 (ref $GcArray_117))
    i32.const 0
    i32.const 4
    array.new $GcArray_117
    i32.const 0
    struct.new $ResizeArray_364
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_364 1
    local.set $w601
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.set $w602
    local.get $w601
    local.get $w602
    array.len
    i32.ge_u
    if
      local.get $w602
      array.len
      i32.const 1
      i32.shl
      local.set $w603
      i32.const 0
      local.get $w603
      array.new $GcArray_117
      local.set $w604
      local.get $w604
      i32.const 0
      local.get $w602
      i32.const 0
      local.get $w601
      array.copy $GcArray_117 $GcArray_117
      local.get $xs
      local.get $w604
      struct.set $ResizeArray_364 0
    end
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.get $w601
    i32.const 100
    array.set $GcArray_117
    local.get $xs
    local.get $w601
    i32.const 1
    i32.add
    struct.set $ResizeArray_364 1
    local.get $xs
    struct.get $ResizeArray_364 1
    local.set $w606
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.set $w607
    local.get $w606
    local.get $w607
    array.len
    i32.ge_u
    if
      local.get $w607
      array.len
      i32.const 1
      i32.shl
      local.set $w608
      i32.const 0
      local.get $w608
      array.new $GcArray_117
      local.set $w609
      local.get $w609
      i32.const 0
      local.get $w607
      i32.const 0
      local.get $w606
      array.copy $GcArray_117 $GcArray_117
      local.get $xs
      local.get $w609
      struct.set $ResizeArray_364 0
    end
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.get $w606
    i32.const 200
    array.set $GcArray_117
    local.get $xs
    local.get $w606
    i32.const 1
    i32.add
    struct.set $ResizeArray_364 1
    local.get $xs
    struct.get $ResizeArray_364 1
    local.set $w611
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.set $w612
    local.get $w611
    local.get $w612
    array.len
    i32.ge_u
    if
      local.get $w612
      array.len
      i32.const 1
      i32.shl
      local.set $w613
      i32.const 0
      local.get $w613
      array.new $GcArray_117
      local.set $w614
      local.get $w614
      i32.const 0
      local.get $w612
      i32.const 0
      local.get $w611
      array.copy $GcArray_117 $GcArray_117
      local.get $xs
      local.get $w614
      struct.set $ResizeArray_364 0
    end
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    local.get $w611
    i32.const 300
    array.set $GcArray_117
    local.get $xs
    local.get $w611
    i32.const 1
    i32.add
    struct.set $ResizeArray_364 1
    local.get $xs
    struct.get $ResizeArray_364 0
    ref.cast (ref $GcArray_117)
    i32.const 1
    array.get $GcArray_117
  )
  (func $closure_368 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetOfArray (result i32) ;; exported as "testSetOfArray"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_368
    struct.new $ClosureType_368
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 2
    array.new_fixed $GcArray_117 4
    call $Set_ofArray
    local.set $s
    local.get $s
    return_call $Set_count
  )
  (func $runArrayTests (param $check (ref $AnyFn)) ;; exported as "runArrayTests"
  )
  (func $testRectWidth (param $x1 f64) (param $y1 f64) (param $x2 f64) (param $y2 f64) (result f64) ;; exported as "testRectWidth"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $directionToInt (param $d i32) (result i32) ;; exported as "directionToInt"
    local.get $d
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $d
      i32.const 2
      i32.eq
      if (result i32)
        i32.const 2
      else
        local.get $d
        i32.const 3
        i32.eq
        if (result i32)
          i32.const 3
        else
          i32.const 0
        end
      end
    end
  )
  (func $intToDirection (param $n i32) (result i32) ;; exported as "intToDirection"
    local.get $n
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $n
      i32.const 1
      i32.eq
      if (result i32)
        i32.const 1
      else
        local.get $n
        i32.const 2
        i32.eq
        if (result i32)
          i32.const 2
        else
          i32.const 3
        end
      end
    end
  )
  (func $shapeArea (param $s (ref $QuickTestWasmGc_TestsStrings_Shape)) (result f64) ;; exported as "shapeArea"
    (local $s_1 f64)
    (local $w f64)
    (local $h f64)
    (local $r f64)
    local.get $s
    struct.get $QuickTestWasmGc_TestsStrings_Shape 0
    i32.const 1
    i32.eq
    if (result f64)
      local.get $s
      ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#1)
      struct.get $QuickTestWasmGc_TestsStrings_Shape#1 1
      local.set $s_1
      local.get $s_1
      local.get $s_1
      f64.mul
    else
      local.get $s
      struct.get $QuickTestWasmGc_TestsStrings_Shape 0
      i32.const 2
      i32.eq
      if (result f64)
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#2)
        struct.get $QuickTestWasmGc_TestsStrings_Shape#2 1
        local.set $w
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#2)
        struct.get $QuickTestWasmGc_TestsStrings_Shape#2 2
        local.set $h
        local.get $w
        local.get $h
        f64.mul
      else
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#0)
        struct.get $QuickTestWasmGc_TestsStrings_Shape#0 1
        local.set $r
        local.get $r
        local.get $r
        f64.mul
      end
    end
  )
  (func $shapePerimeter (param $s (ref $QuickTestWasmGc_TestsStrings_Shape)) (result f64) ;; exported as "shapePerimeter"
    (local $s_1 f64)
    (local $w f64)
    (local $h f64)
    (local $r f64)
    local.get $s
    struct.get $QuickTestWasmGc_TestsStrings_Shape 0
    i32.const 1
    i32.eq
    if (result f64)
      local.get $s
      ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#1)
      struct.get $QuickTestWasmGc_TestsStrings_Shape#1 1
      local.set $s_1
      f64.const 4
      local.get $s_1
      f64.mul
    else
      local.get $s
      struct.get $QuickTestWasmGc_TestsStrings_Shape 0
      i32.const 2
      i32.eq
      if (result f64)
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#2)
        struct.get $QuickTestWasmGc_TestsStrings_Shape#2 1
        local.set $w
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#2)
        struct.get $QuickTestWasmGc_TestsStrings_Shape#2 2
        local.set $h
        f64.const 2
        local.get $w
        f64.mul
        f64.const 2
        local.get $h
        f64.mul
        f64.add
      else
        local.get $s
        ref.cast (ref $QuickTestWasmGc_TestsStrings_Shape#0)
        struct.get $QuickTestWasmGc_TestsStrings_Shape#0 1
        local.set $r
        f64.const 4
        local.get $r
        f64.mul
      end
    end
  )
  (func $testStringLen (result i32) ;; exported as "testStringLen"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    array.len
  )
  (func $testEmptyStringLen (result i32) ;; exported as "testEmptyStringLen"
    array.new_fixed $WasmStr 0
    array.len
  )
  (func $testStringChar (result i32) ;; exported as "testStringChar"
    i32.const 65
    i32.const 66
    i32.const 67
    array.new_fixed $WasmStr 3
    i32.const 1
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStringFirstChar (result i32) ;; exported as "testStringFirstChar"
    i32.const 120
    i32.const 121
    i32.const 122
    array.new_fixed $WasmStr 3
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStringLen2 (result i32) ;; exported as "testStringLen2"
    i32.const 102
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 119
    i32.const 97
    i32.const 115
    i32.const 109
    array.new_fixed $WasmStr 10
    array.len
  )
  (func $testStringConcatLen (result i32) ;; exported as "testStringConcatLen"
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    call $strConcat
    array.len
  )
  (func $testStringConcatChar (result i32) ;; exported as "testStringConcatChar"
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    call $strConcat
    i32.const 3
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStringEqTrue (result i32) ;; exported as "testStringEqTrue"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strEq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringEqFalse (result i32) ;; exported as "testStringEqFalse"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    call $strEq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringNeq (result i32) ;; exported as "testStringNeq"
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    i32.const 120
    i32.const 121
    i32.const 122
    array.new_fixed $WasmStr 3
    call $strEq
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringConcatVars (result i32) ;; exported as "testStringConcatVars"
    (local $a (ref $WasmStr))
    (local $b (ref $WasmStr))
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    local.set $a
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 6
    local.set $b
    local.get $a
    local.get $b
    call $strConcat
    array.len
  )
  (func $testRefCell (result i32) ;; exported as "testRefCell"
    (local $r (ref $RefCell_55))
    i32.const 5
    struct.new $RefCell_55
    local.set $r
    local.get $r
    local.get $r
    struct.get $RefCell_55 0
    i32.const 1
    i32.add
    struct.set $RefCell_55 0
    local.get $r
    struct.get $RefCell_55 0
  )
  (func $testRefCellBool (result i32) ;; exported as "testRefCellBool"
    (local $r (ref $RefCell_55))
    i32.const 0
    struct.new $RefCell_55
    local.set $r
    local.get $r
    i32.const 1
    struct.set $RefCell_55 0
    local.get $r
    struct.get $RefCell_55 0
  )
  (func $treeSum (param $t (ref $QuickTestWasmGc_TestsStrings_Tree)) (result i32) ;; exported as "treeSum"
    (local $v i32)
    (local $r (ref $QuickTestWasmGc_TestsStrings_Tree))
    (local $l (ref $QuickTestWasmGc_TestsStrings_Tree))
    local.get $t
    struct.get $QuickTestWasmGc_TestsStrings_Tree 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $t
      ref.cast (ref $QuickTestWasmGc_TestsStrings_Tree#1)
      struct.get $QuickTestWasmGc_TestsStrings_Tree#1 3
      local.set $v
      local.get $t
      ref.cast (ref $QuickTestWasmGc_TestsStrings_Tree#1)
      struct.get $QuickTestWasmGc_TestsStrings_Tree#1 2
      local.set $r
      local.get $t
      ref.cast (ref $QuickTestWasmGc_TestsStrings_Tree#1)
      struct.get $QuickTestWasmGc_TestsStrings_Tree#1 1
      local.set $l
      local.get $v
      local.get $l
      call $treeSum
      i32.add
      local.get $r
      call $treeSum
      i32.add
    else
      i32.const 0
    end
  )
  (func $testStringIndexOf (result i32) ;; exported as "testStringIndexOf"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    call $strIndexOf
  )
  (func $testStringIndexOfMiss (result i32) ;; exported as "testStringIndexOfMiss"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 120
    i32.const 121
    i32.const 122
    array.new_fixed $WasmStr 3
    call $strIndexOf
  )
  (func $testStringLastIndexOf (result i32) ;; exported as "testStringLastIndexOf"
    i32.const 97
    i32.const 98
    i32.const 99
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 6
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 2
    call $strLastIndexOf
  )
  (func $testStringLastIndexOfMiss (result i32) ;; exported as "testStringLastIndexOfMiss"
    i32.const 97
    i32.const 98
    i32.const 99
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 6
    i32.const 120
    i32.const 121
    i32.const 122
    array.new_fixed $WasmStr 3
    call $strLastIndexOf
  )
  (func $testStringIndexOfFrom (result i32) ;; exported as "testStringIndexOfFrom"
    (local $iofi_tmp i32)
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 17
    i32.const 5
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 17
    array.len
    i32.const 5
    i32.sub
    call $strSubstring
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strIndexOf
    local.set $iofi_tmp
    local.get $iofi_tmp
    i32.const 0
    i32.ge_s
    if (result i32)
      local.get $iofi_tmp
      i32.const 5
      i32.add
    else
      i32.const -1
    end
  )
  (func $testStringStartsWith (result i32) ;; exported as "testStringStartsWith"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strIndexOf
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringStartsWithFalse (result i32) ;; exported as "testStringStartsWithFalse"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    call $strIndexOf
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringEndsWith (result i32) ;; exported as "testStringEndsWith"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    array.len
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    array.len
    i32.sub
    i32.const 0
    i32.ge_s
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    call $strIndexOf
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    array.len
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    array.len
    i32.sub
    i32.eq
    i32.and
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringEndsWithFalse (result i32) ;; exported as "testStringEndsWithFalse"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    array.len
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    array.len
    i32.sub
    i32.const 0
    i32.ge_s
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strIndexOf
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    array.len
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    array.len
    i32.sub
    i32.eq
    i32.and
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStringSubstring (result i32) ;; exported as "testStringSubstring"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 6
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    array.len
    i32.const 6
    i32.sub
    call $strSubstring
    array.len
  )
  (func $testStringSubstringLen (result i32) ;; exported as "testStringSubstringLen"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 6
    i32.const 3
    call $strSubstring
    array.len
  )
  (func $testToLowerLength (result i32) ;; exported as "testToLowerLength"
    (local $s (ref $WasmStr))
    i32.const 72
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strToLower
    local.set $s
    local.get $s
    array.len
  )
  (func $testToUpperFirstChar (result i32) ;; exported as "testToUpperFirstChar"
    (local $s (ref $WasmStr))
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strToUpper
    local.set $s
    local.get $s
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testToLowerChars (result i32) ;; exported as "testToLowerChars"
    (local $s (ref $WasmStr))
    i32.const 65
    i32.const 66
    i32.const 67
    array.new_fixed $WasmStr 3
    call $strToLower
    local.set $s
    local.get $s
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
    local.get $s
    i32.const 1
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
    i32.add
    local.get $s
    i32.const 2
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
    i32.add
  )
  (func $testToUpperChars (result i32) ;; exported as "testToUpperChars"
    (local $s (ref $WasmStr))
    i32.const 120
    i32.const 121
    i32.const 122
    array.new_fixed $WasmStr 3
    call $strToUpper
    local.set $s
    local.get $s
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
    local.get $s
    i32.const 1
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
    i32.add
    local.get $s
    i32.const 2
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
    i32.add
  )
  (func $testTrimBasic (result i32) ;; exported as "testTrimBasic"
    (local $s (ref $WasmStr))
    i32.const 32
    i32.const 32
    i32.const 104
    i32.const 105
    i32.const 32
    i32.const 32
    array.new_fixed $WasmStr 6
    call $strTrim
    local.set $s
    local.get $s
    array.len
  )
  (func $testTrimStart (result i32) ;; exported as "testTrimStart"
    (local $s (ref $WasmStr))
    i32.const 32
    i32.const 32
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 5
    call $strTrimStart
    local.set $s
    local.get $s
    array.len
  )
  (func $testTrimEnd (result i32) ;; exported as "testTrimEnd"
    (local $s (ref $WasmStr))
    i32.const 97
    i32.const 98
    i32.const 99
    i32.const 32
    i32.const 32
    array.new_fixed $WasmStr 5
    call $strTrimEnd
    local.set $s
    local.get $s
    array.len
  )
  (func $testContains (result i32) ;; exported as "testContains"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    i32.const 101
    i32.const 108
    i32.const 108
    array.new_fixed $WasmStr 3
    call $strIndexOf
    i32.const 0
    i32.ge_s
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testContainsNot (result i32) ;; exported as "testContainsNot"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    i32.const 120
    i32.const 121
    i32.const 122
    array.new_fixed $WasmStr 3
    call $strIndexOf
    i32.const 0
    i32.ge_s
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testToLowerMixed (result i32) ;; exported as "testToLowerMixed"
    (local $s (ref $WasmStr))
    i32.const 72
    i32.const 101
    i32.const 76
    i32.const 76
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strToLower
    local.set $s
    local.get $s
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStringOfInt (result i32) ;; exported as "testStringOfInt"
    i32.const 42
    call $intToStr
    array.len
  )
  (func $testStringOfNegInt (result i32) ;; exported as "testStringOfNegInt"
    i32.const -1
    call $intToStr
    array.len
  )
  (func $testStringOfZero (result i32) ;; exported as "testStringOfZero"
    i32.const 0
    call $intToStr
    array.len
  )
  (func $testStringOfIntChar (result i32) ;; exported as "testStringOfIntChar"
    i32.const 123
    call $intToStr
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testPadLeft (result i32) ;; exported as "testPadLeft"
    i32.const 52
    i32.const 50
    array.new_fixed $WasmStr 2
    i32.const 5
    call $strPadLeft
    array.len
  )
  (func $testPadRight (result i32) ;; exported as "testPadRight"
    i32.const 52
    i32.const 50
    array.new_fixed $WasmStr 2
    i32.const 5
    call $strPadRight
    array.len
  )
  (func $testPadLeftNoop (result i32) ;; exported as "testPadLeftNoop"
    i32.const 52
    i32.const 50
    array.new_fixed $WasmStr 2
    i32.const 1
    call $strPadLeft
    array.len
  )
  (func $testPadLeftChar (result i32) ;; exported as "testPadLeftChar"
    i32.const 52
    i32.const 50
    array.new_fixed $WasmStr 2
    i32.const 4
    call $strPadLeft
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testReplace (result i32) ;; exported as "testReplace"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    i32.const 70
    i32.const 35
    array.new_fixed $WasmStr 2
    call $strReplace
    array.len
  )
  (func $testReplaceRemove (result i32) ;; exported as "testReplaceRemove"
    i32.const 97
    i32.const 97
    i32.const 98
    i32.const 98
    i32.const 99
    i32.const 99
    array.new_fixed $WasmStr 6
    i32.const 98
    i32.const 98
    array.new_fixed $WasmStr 2
    array.new_fixed $WasmStr 0
    call $strReplace
    array.len
  )
  (func $testReplaceNoMatch (result i32) ;; exported as "testReplaceNoMatch"
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    i32.const 120
    array.new_fixed $WasmStr 1
    i32.const 121
    array.new_fixed $WasmStr 1
    call $strReplace
    array.len
  )
  (func $testIsUpper (result i32) ;; exported as "testIsUpper"
    i32.const 65
    call $charIsUpper
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testIsLower (result i32) ;; exported as "testIsLower"
    i32.const 97
    call $charIsLower
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testCharToLower (result i32) ;; exported as "testCharToLower"
    i32.const 97
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testCharToUpper (result i32) ;; exported as "testCharToUpper"
    i32.const 65
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testFloatCompare (result i32) ;; exported as "testFloatCompare"
    f64.const 1.5
    f64.const 2.5
    f64.lt
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testRecordEqTrue (result i32) ;; exported as "testRecordEqTrue"
    i32.const 1
  )
  (func $testRecordEqFalse (result i32) ;; exported as "testRecordEqFalse"
    i32.const 1
  )
  (func $testRecordNeq (result i32) ;; exported as "testRecordNeq"
    i32.const 1
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStrSplitLen (result i32) ;; exported as "testStrSplitLen"
    (local $parts (ref $GcArray_172))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_172 1
    i32.const 0
    array.get $GcArray_172
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitFirst (result i32) ;; exported as "testStrSplitFirst"
    (local $parts (ref $GcArray_172))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_172 1
    i32.const 0
    array.get $GcArray_172
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 0
    array.get $GcArray_172
    array.len
  )
  (func $testStrSplitSecond (result i32) ;; exported as "testStrSplitSecond"
    (local $parts (ref $GcArray_172))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_172 1
    i32.const 0
    array.get $GcArray_172
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 1
    array.get $GcArray_172
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStrSplitWords (result i32) ;; exported as "testStrSplitWords"
    (local $parts (ref $GcArray_172))
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 15
    i32.const 32
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_172 1
    i32.const 0
    array.get $GcArray_172
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitNoDelim (result i32) ;; exported as "testStrSplitNoDelim"
    (local $parts (ref $GcArray_172))
    i32.const 110
    i32.const 111
    i32.const 45
    i32.const 100
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 109
    array.new_fixed $WasmStr 8
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_172 1
    i32.const 0
    array.get $GcArray_172
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitEmpty (result i32) ;; exported as "testStrSplitEmpty"
    (local $parts (ref $GcArray_172))
    array.new_fixed $WasmStr 0
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_172 1
    i32.const 0
    array.get $GcArray_172
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitMultiChar (result i32) ;; exported as "testStrSplitMultiChar"
    (local $parts (ref $GcArray_172))
    i32.const 120
    i32.const 58
    i32.const 58
    i32.const 121
    i32.const 58
    i32.const 58
    i32.const 122
    array.new_fixed $WasmStr 7
    i32.const 58
    i32.const 58
    array.new_fixed $WasmStr 2
    array.new_fixed $GcArray_172 1
    i32.const 0
    array.get $GcArray_172
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrJoinLen (result i32) ;; exported as "testStrJoinLen"
    (local $parts (ref $GcArray_172))
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    array.new_fixed $GcArray_172 3
    local.set $parts
    i32.const 44
    i32.const 32
    array.new_fixed $WasmStr 2
    local.get $parts
    call $strJoin
    array.len
  )
  (func $testStrJoinNoSep (result i32) ;; exported as "testStrJoinNoSep"
    array.new_fixed $WasmStr 0
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    array.new_fixed $GcArray_172 2
    call $strJoin
    array.len
  )
  (func $testStrJoinOne (result i32) ;; exported as "testStrJoinOne"
    i32.const 44
    array.new_fixed $WasmStr 1
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    array.new_fixed $GcArray_172 1
    call $strJoin
    array.len
  )
  (func $testStrIsNullOrEmptyTrue (result i32) ;; exported as "testStrIsNullOrEmptyTrue"
    array.new_fixed $WasmStr 0
    array.len
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStrIsNullOrEmptyFalse (result i32) ;; exported as "testStrIsNullOrEmptyFalse"
    i32.const 104
    i32.const 105
    array.new_fixed $WasmStr 2
    array.len
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testStrCompareEq (result i32) ;; exported as "testStrCompareEq"
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    call $strCompare
  )
  (func $testStrCompareLt (result i32) ;; exported as "testStrCompareLt"
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    i32.const 97
    i32.const 98
    i32.const 100
    array.new_fixed $WasmStr 3
    call $strCompare
  )
  (func $testStrCompareGt (result i32) ;; exported as "testStrCompareGt"
    i32.const 98
    array.new_fixed $WasmStr 1
    i32.const 97
    array.new_fixed $WasmStr 1
    call $strCompare
  )
  (func $fibonacci (param $n i32) (result i32) ;; exported as "fibonacci"
    local.get $n
    i32.const 1
    i32.le_s
    if (result i32)
      local.get $n
    else
      local.get $n
      i32.const 1
      i32.sub
      call $fibonacci
      local.get $n
      i32.const 2
      i32.sub
      call $fibonacci
      i32.add
    end
  )
  (func $closure_376 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbToStringLength (result i32) ;; exported as "testSbToStringLength"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_124 (ref $ClosureBase_5))
    (local $s (ref $WasmStr))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_376
    struct.new $ClosureType_376
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_124
    local.get $lo_clo_124
    local.get $sb
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_124
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    local.get $sb
    call $sbToString
    local.set $s
    local.get $s
    array.len
  )
  (func $closure_377 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_378 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $testSbToStringContent (result i32) ;; exported as "testSbToStringContent"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_125 (ref $ClosureBase_5))
    (local $lo_clo_126 (ref $ClosureBase_5))
    (local $s (ref $WasmStr))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_377
    struct.new $ClosureType_377
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_125
    local.get $lo_clo_125
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    local.get $lo_clo_125
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    ref.func $closure_378
    struct.new $ClosureType_378
    ref.cast (ref $ClosureBase_5)
    local.set $lo_clo_126
    local.get $lo_clo_126
    local.get $sb
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 6
    call $sbAppend
    local.get $lo_clo_126
    struct.get $ClosureBase_5 0
    call_ref $FuncType_4
    local.get $sb
    call $sbToString
    local.set $s
    local.get $s
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    call $strEq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testCompareIntLt (result i32) ;; exported as "testCompareIntLt"
    i32.const -1
  )
  (func $testCompareIntEq (result i32) ;; exported as "testCompareIntEq"
    i32.const 0
  )
  (func $testCompareIntGt (result i32) ;; exported as "testCompareIntGt"
    i32.const 1
  )
  (func $testCompareStrLt (result i32) ;; exported as "testCompareStrLt"
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    i32.const 97
    i32.const 98
    i32.const 100
    array.new_fixed $WasmStr 3
    call $strCompare
  )
  (func $testCompareStrEq (result i32) ;; exported as "testCompareStrEq"
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    call $strCompare
  )
  (func $testCompareStrGt (result i32) ;; exported as "testCompareStrGt"
    i32.const 97
    i32.const 98
    i32.const 100
    array.new_fixed $WasmStr 3
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    call $strCompare
  )
  (func $007CEven$007COdd$007C (param $n i32) (result (ref $Microsoft_FSharp_Core_FSharpChoice`2<void~void>)) ;; exported as "$007CEven$007COdd$007C"
    local.get $n
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpChoice`2<void~void>))
      i32.const 0
      struct.new $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#0
    else
      i32.const 1
      struct.new $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#1
    end
  )
  (func $testStringConcat (result i32) ;; exported as "testStringConcat"
    (local $s (ref $WasmStr))
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    i32.const 32
    array.new_fixed $WasmStr 1
    call $strConcat
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    call $strConcat
    local.set $s
    local.get $s
    array.len
  )
  (func $testStringInterp (result i32) ;; exported as "testStringInterp"
    (local $name (ref $WasmStr))
    (local $s (ref $WasmStr))
    i32.const 65
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 101
    array.new_fixed $WasmStr 5
    local.set $name
    i32.const 72
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    array.new_fixed $WasmStr 6
    local.get $name
    call $strConcat
    i32.const 33
    array.new_fixed $WasmStr 1
    call $strConcat
    local.set $s
    local.get $s
    array.len
  )
  (func $runStringsTests (param $check (ref $AnyFn)) ;; exported as "runStringsTests"
  )
  (func $closure_382 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_384))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_384)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_384 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_384 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_385 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_385))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_385)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_385 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_385 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_386 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_386))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_386)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_386 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_386 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_386
    local.get $a
    struct.new $ClosureType_386
  )
  (func $closure_388 (param $self (ref $AnyFn)) (param $option (ref null $Option_118)) (result i32)
    (local $self_cast (ref $ClosureType_390))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_390)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_390 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      local.get $value_2
    end
  )
  (func $testMapAddFind (result i32) ;; exported as "testMapAddFind"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_128 (ref $ClosureBase_383))
    (local $lo_clo_127 (ref $ClosureBase_383))
    (local $lo_clo_129 (ref $ClosureBase_389))
    ref.func $closure_382
    i32.const 2
    i32.const 200
    struct.new $ClosureType_384
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_128
    local.get $lo_clo_128
    ref.func $closure_385
    i32.const 1
    i32.const 100
    struct.new $ClosureType_385
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_127
    local.get $lo_clo_127
    ref.func $closure_386
    struct.new $ClosureType_387
    call $Map_empty
    local.get $lo_clo_127
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_128
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_2
    ref.func $closure_388
    i32.const 0
    struct.new $ClosureType_390
    ref.cast (ref $ClosureBase_389)
    local.set $lo_clo_129
    local.get $lo_clo_129
    i32.const 1
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_129
    struct.get $ClosureBase_389 0
    call_ref $FuncType_388
  )
  (func $closure_391 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_391))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_391)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_391 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_391 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_392 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_392))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_392)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_392 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_392 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_392
    local.get $a
    struct.new $ClosureType_392
  )
  (func $closure_394 (param $self (ref $AnyFn)) (param $option (ref null $Option_118)) (result i32)
    (local $self_cast (ref $ClosureType_394))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_394)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_394 1
    local.set $value_1
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      local.get $value_1
    end
  )
  (func $testMapFindMissing (result i32) ;; exported as "testMapFindMissing"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_130 (ref $ClosureBase_383))
    (local $lo_clo_131 (ref $ClosureBase_389))
    ref.func $closure_391
    i32.const 1
    i32.const 100
    struct.new $ClosureType_391
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_130
    local.get $lo_clo_130
    ref.func $closure_392
    struct.new $ClosureType_393
    call $Map_empty
    local.get $lo_clo_130
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_1
    ref.func $closure_394
    i32.const 0
    struct.new $ClosureType_394
    ref.cast (ref $ClosureBase_389)
    local.set $lo_clo_131
    local.get $lo_clo_131
    i32.const 99
    local.get $m_1
    call $Map_tryFind
    local.get $lo_clo_131
    struct.get $ClosureBase_389 0
    call_ref $FuncType_388
  )
  (func $closure_395 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_395))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_395)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_395 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_395 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_396 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_396))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_396)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_396 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_396 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_397 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_397))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_397)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_397 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_397 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_397
    local.get $a
    struct.new $ClosureType_397
  )
  (func $testMapCount (result i32) ;; exported as "testMapCount"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_133 (ref $ClosureBase_383))
    (local $lo_clo_132 (ref $ClosureBase_383))
    ref.func $closure_395
    i32.const 2
    i32.const 200
    struct.new $ClosureType_395
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_133
    local.get $lo_clo_133
    ref.func $closure_396
    i32.const 1
    i32.const 100
    struct.new $ClosureType_396
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_132
    local.get $lo_clo_132
    ref.func $closure_397
    struct.new $ClosureType_398
    call $Map_empty
    local.get $lo_clo_132
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_133
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_2
    local.get $m_2
    return_call $Map_count
  )
  (func $closure_399 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_399))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_399)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_399 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_399 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_400 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_400))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_400)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_400 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_400 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_400
    local.get $a
    struct.new $ClosureType_400
  )
  (func $testMapContainsKey (result i32) ;; exported as "testMapContainsKey"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_134 (ref $ClosureBase_383))
    ref.func $closure_399
    i32.const 42
    i32.const 999
    struct.new $ClosureType_399
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_134
    local.get $lo_clo_134
    ref.func $closure_400
    struct.new $ClosureType_401
    call $Map_empty
    local.get $lo_clo_134
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_1
    i32.const 42
    local.get $m_1
    call $Map_containsKey
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_402 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_402))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_402)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_402 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_402 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_403 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_403))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_403)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_403 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_403 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_403
    local.get $a
    struct.new $ClosureType_403
  )
  (func $testMapContainsKeyMissing (result i32) ;; exported as "testMapContainsKeyMissing"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_135 (ref $ClosureBase_383))
    ref.func $closure_402
    i32.const 42
    i32.const 999
    struct.new $ClosureType_402
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_135
    local.get $lo_clo_135
    ref.func $closure_403
    struct.new $ClosureType_404
    call $Map_empty
    local.get $lo_clo_135
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_1
    i32.const 7
    local.get $m_1
    call $Map_containsKey
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_405 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_405))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_405)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_405 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_405 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_406 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_406))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_406)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_406 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_406 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_407 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_407))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_407)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_407 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_407 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_407
    local.get $a
    struct.new $ClosureType_407
  )
  (func $closure_409 (param $self (ref $AnyFn)) (param $option (ref null $Option_118)) (result i32)
    (local $self_cast (ref $ClosureType_409))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_409)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_409 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      local.get $value_2
    end
  )
  (func $testMapAddReplace (result i32) ;; exported as "testMapAddReplace"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_137 (ref $ClosureBase_383))
    (local $lo_clo_136 (ref $ClosureBase_383))
    (local $lo_clo_138 (ref $ClosureBase_389))
    ref.func $closure_405
    i32.const 1
    i32.const 555
    struct.new $ClosureType_405
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_137
    local.get $lo_clo_137
    ref.func $closure_406
    i32.const 1
    i32.const 100
    struct.new $ClosureType_406
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_136
    local.get $lo_clo_136
    ref.func $closure_407
    struct.new $ClosureType_408
    call $Map_empty
    local.get $lo_clo_136
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_137
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_2
    ref.func $closure_409
    i32.const 0
    struct.new $ClosureType_409
    ref.cast (ref $ClosureBase_389)
    local.set $lo_clo_138
    local.get $lo_clo_138
    i32.const 1
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_138
    struct.get $ClosureBase_389 0
    call_ref $FuncType_388
  )
  (func $closure_410 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testStdMapFind (result i32) ;; exported as "testStdMapFind"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_410
    struct.new $ClosureType_410
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    i32.const 2
    local.get $m
    return_call $Map_find
  )
  (func $closure_411 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_412 (param $self (ref $AnyFn)) (param $option (ref null $Option_118)) (result i32)
    (local $self_cast (ref $ClosureType_412))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_412)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_412 1
    local.set $value
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      local.get $value
    end
  )
  (func $testStdMapTryFind (result i32) ;; exported as "testStdMapTryFind"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_139 (ref $ClosureBase_389))
    ref.func $closure_411
    struct.new $ClosureType_411
    i32.const 10
    i32.const 100
    struct.new $Tuple_105
    i32.const 20
    i32.const 200
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_412
    i32.const 0
    struct.new $ClosureType_412
    ref.cast (ref $ClosureBase_389)
    local.set $lo_clo_139
    local.get $lo_clo_139
    i32.const 20
    local.get $m
    call $Map_tryFind
    local.get $lo_clo_139
    struct.get $ClosureBase_389 0
    call_ref $FuncType_388
  )
  (func $closure_413 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_414 (param $self (ref $AnyFn)) (param $option (ref null $Option_118)) (result i32)
    (local $self_cast (ref $ClosureType_414))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_414)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_414 1
    local.set $value
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      local.get $value
    end
  )
  (func $testStdMapTryFindMissing (result i32) ;; exported as "testStdMapTryFindMissing"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_140 (ref $ClosureBase_389))
    ref.func $closure_413
    struct.new $ClosureType_413
    i32.const 1
    i32.const 1
    struct.new $Tuple_105
    i32.const 2
    i32.const 2
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_414
    i32.const 0
    struct.new $ClosureType_414
    ref.cast (ref $ClosureBase_389)
    local.set $lo_clo_140
    local.get $lo_clo_140
    i32.const 99
    local.get $m
    call $Map_tryFind
    local.get $lo_clo_140
    struct.get $ClosureBase_389 0
    call_ref $FuncType_388
  )
  (func $closure_415 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testStdMapContainsKey (result i32) ;; exported as "testStdMapContainsKey"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_415
    struct.new $ClosureType_415
    i32.const 5
    i32.const 50
    struct.new $Tuple_105
    i32.const 6
    i32.const 60
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    i32.const 5
    local.get $m
    call $Map_containsKey
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_416 (param $self (ref $AnyFn)) (param $table i32) (result i32)
    (local $self_cast (ref $ClosureType_416))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_416)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_416 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_416 2
    local.set $value
    local.get $key
    local.get $value
    local.get $table
    call $Map_add
  )
  (func $closure_417 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testStdMapAdd (result i32) ;; exported as "testStdMapAdd"
    (local $m i32)
    (local $lo_clo_141 (ref $ClosureBase_644))
    ref.func $closure_416
    i32.const 2
    i32.const 20
    struct.new $ClosureType_416
    ref.cast (ref $ClosureBase_644)
    local.set $lo_clo_141
    local.get $lo_clo_141
    ref.func $closure_417
    struct.new $ClosureType_417
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    call $Map_ofList
    local.get $lo_clo_141
    struct.get $ClosureBase_644 0
    call_ref $FuncType_418
    local.set $m
    i32.const 2
    local.get $m
    return_call $Map_find
  )
  (func $closure_419 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_420 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
    local.get $x_1
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testMapIsEmpty (result i32) ;; exported as "testMapIsEmpty"
    (local $e (ref $MapModule_MapHandle`2))
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_419
    struct.new $ClosureType_419
    ref.null $ListBase
    call $Map_ofList
    local.set $e
    ref.func $closure_420
    struct.new $ClosureType_420
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    local.get $e
    call $Map_count
    local.get $m
    call $Map_count
    i32.add
  )
  (func $closure_421 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testMapRemove (result i32) ;; exported as "testMapRemove"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_421
    struct.new $ClosureType_421
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    i32.const 2
    local.get $m
    call $Map_remove
    local.set $m2
    local.get $m2
    return_call $Map_count
  )
  (func $closure_422 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testMapLargeAddFind (result i32) ;; exported as "testMapLargeAddFind"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_422
    struct.new $ClosureType_422
    i32.const 10
    i32.const 100
    struct.new $Tuple_105
    i32.const 20
    i32.const 200
    struct.new $Tuple_105
    i32.const 30
    i32.const 300
    struct.new $Tuple_105
    i32.const 40
    i32.const 400
    struct.new $Tuple_105
    i32.const 50
    i32.const 500
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    i32.const 30
    local.get $m
    return_call $Map_find
  )
  (func $closure_423 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testMapFindRaises (result i32) ;; exported as "testMapFindRaises"
    (local $m (ref $MapModule_MapHandle`2))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                ref.func $closure_423
                struct.new $ClosureType_423
                i32.const 1
                i32.const 10
                struct.new $Tuple_105
                i32.const 2
                i32.const 20
                struct.new $Tuple_105
                ref.null $ListBase
                struct.new $ListCons_137
                struct.new $ListCons_137
                call $Map_ofList
                local.set $m
                i32.const 99
                local.get $m
                call $Map_find
        )
        br 1
      )
        i32.const -1
    )
  )
  (func $closure_424 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_425 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_425))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_425)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_425 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_425 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_426))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_426)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_426 1
    local.set $acc
    ref.func $closure_425
    local.get $acc
    struct.new $ClosureType_425
  )
  (func $closure_425 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_425
    local.get $acc
    struct.new $ClosureType_426
  )
  (func $testMapFold (result i32) ;; exported as "testMapFold"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_424
    struct.new $ClosureType_424
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_425
    struct.new $ClosureType_427
    i32.const 0
    local.get $m
    return_call $Map_fold
  )
  (func $closure_428 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_429 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_429))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_429)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_429 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_429 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_430))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_430)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_430 1
    local.set $acc
    ref.func $closure_429
    local.get $acc
    struct.new $ClosureType_429
  )
  (func $closure_429 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_429
    local.get $acc
    struct.new $ClosureType_430
  )
  (func $testMapIter (result i32) ;; exported as "testMapIter"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_428
    struct.new $ClosureType_428
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_429
    struct.new $ClosureType_431
    i32.const 0
    local.get $m
    return_call $Map_fold
  )
  (func $closure_432 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_433 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 15
    i32.gt_s
  )
  (func $closure_433 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_433
    struct.new $ClosureType_433
  )
  (func $testMapFilter (result i32) ;; exported as "testMapFilter"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_432
    struct.new $ClosureType_432
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_433
    struct.new $ClosureType_434
    local.get $m
    call $Map_filter
    local.set $m2
    local.get $m2
    return_call $Map_count
  )
  (func $closure_435 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_436 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 25
    i32.gt_s
  )
  (func $closure_436 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_436
    struct.new $ClosureType_436
  )
  (func $testMapExists (result i32) ;; exported as "testMapExists"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_435
    struct.new $ClosureType_435
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_436
    struct.new $ClosureType_437
    local.get $m
    call $Map_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_438 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_439 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 10
    i32.ge_s
  )
  (func $closure_439 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_439
    struct.new $ClosureType_439
  )
  (func $testMapForall (result i32) ;; exported as "testMapForall"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_438
    struct.new $ClosureType_438
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_439
    struct.new $ClosureType_440
    local.get $m
    call $Map_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_441 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_442 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 1
    i32.shl
  )
  (func $closure_442 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_442
    struct.new $ClosureType_442
  )
  (func $testMapMap (result i32) ;; exported as "testMapMap"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_441
    struct.new $ClosureType_441
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_442
    struct.new $ClosureType_443
    local.get $m
    call $Map_mapValues
    local.set $m2
    i32.const 1
    local.get $m2
    call $Map_find
    i32.const 2
    local.get $m2
    call $Map_find
    i32.add
  )
  (func $closure_444 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_444))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_444)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_444 1
    local.set $a
    local.get $a
    local.get $b
    i32.gt_s
    if (result i32)
      i32.const -1
    else
      local.get $a
      local.get $b
      i32.lt_s
      if (result i32)
        i32.const 1
      else
        i32.const 0
      end
    end
  )
  (func $closure_444 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_444
    local.get $a
    struct.new $ClosureType_444
  )
  (func $closure_446 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_447 (param $self (ref $AnyFn)) (param $m_3 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_447))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_447)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_447 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_447 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_3
    call $Map_add
  )
  (func $closure_448 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_448))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_448)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_448 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_448 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_2
    call $Map_add
  )
  (func $closure_449 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_449))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_449)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_449 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_449 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m_1
    call $Map_add
  )
  (func $closure_450 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_450))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_450)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_450 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_450 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_451))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_451)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_451 1
    local.set $acc
    ref.func $closure_450
    local.get $acc
    struct.new $ClosureType_450
  )
  (func $closure_450 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_450
    local.get $acc
    struct.new $ClosureType_451
  )
  (func $testMapCustomCmpReverse (result i32) ;; exported as "testMapCustomCmpReverse"
    (local $reverseCmp (ref $ClosureType_445))
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_144 (ref $ClosureBase_383))
    (local $lo_clo_143 (ref $ClosureBase_383))
    (local $lo_clo_142 (ref $ClosureBase_383))
    ref.func $closure_444
    struct.new $ClosureType_445
    local.set $reverseCmp
    ref.func $closure_446
    struct.new $ClosureType_446
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_447
    i32.const 3
    i32.const 30
    struct.new $ClosureType_447
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_144
    local.get $lo_clo_144
    ref.func $closure_448
    i32.const 2
    i32.const 20
    struct.new $ClosureType_448
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_143
    local.get $lo_clo_143
    ref.func $closure_449
    i32.const 1
    i32.const 10
    struct.new $ClosureType_449
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_142
    local.get $lo_clo_142
    local.get $reverseCmp
    call $Map_empty
    local.get $lo_clo_142
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_143
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_144
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m2
    ref.func $closure_450
    struct.new $ClosureType_452
    i32.const 0
    local.get $m2
    return_call $Map_fold
  )
  (func $closure_453 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_453))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_453)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_453 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_453 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_454 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_454))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_454)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_454 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_454 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_455 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_455))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_455)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_455 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_455 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_456 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_456))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_456)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_456 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_456 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_456
    local.get $a
    struct.new $ClosureType_456
  )
  (func $testMapModuleContainsKey (result i32) ;; exported as "testMapModuleContainsKey"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_147 (ref $ClosureBase_383))
    (local $lo_clo_146 (ref $ClosureBase_383))
    (local $lo_clo_145 (ref $ClosureBase_383))
    ref.func $closure_453
    i32.const 30
    i32.const 300
    struct.new $ClosureType_453
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_147
    local.get $lo_clo_147
    ref.func $closure_454
    i32.const 20
    i32.const 200
    struct.new $ClosureType_454
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_146
    local.get $lo_clo_146
    ref.func $closure_455
    i32.const 10
    i32.const 100
    struct.new $ClosureType_455
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_145
    local.get $lo_clo_145
    ref.func $closure_456
    struct.new $ClosureType_457
    call $Map_empty
    local.get $lo_clo_145
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_146
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_147
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_3
    i32.const 20
    local.get $m_3
    call $Map_containsKey
    if (result i32)
      i32.const 99
      local.get $m_3
      call $Map_containsKey
      i32.eqz
    else
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_458 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_458))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_458)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_458 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_458 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_459 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_459))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_459)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_459 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_459 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_460 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_460))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_460)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_460 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_460 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_460
    local.get $a
    struct.new $ClosureType_460
  )
  (func $closure_462 (param $self (ref $AnyFn)) (param $option (ref null $Option_118)) (result i32)
    (local $self_cast (ref $ClosureType_462))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_462)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_462 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    else
      local.get $value_2
    end
  )
  (func $testMapModuleFindRoundTrip (result i32) ;; exported as "testMapModuleFindRoundTrip"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_149 (ref $ClosureBase_383))
    (local $lo_clo_148 (ref $ClosureBase_383))
    (local $lo_clo_150 (ref $ClosureBase_389))
    ref.func $closure_458
    i32.const 8
    i32.const 88
    struct.new $ClosureType_458
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_149
    local.get $lo_clo_149
    ref.func $closure_459
    i32.const 7
    i32.const 77
    struct.new $ClosureType_459
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_148
    local.get $lo_clo_148
    ref.func $closure_460
    struct.new $ClosureType_461
    call $Map_empty
    local.get $lo_clo_148
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_149
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_2
    i32.const 7
    local.get $m_2
    call $Map_find
    ref.func $closure_462
    i32.const 0
    struct.new $ClosureType_462
    ref.cast (ref $ClosureBase_389)
    local.set $lo_clo_150
    local.get $lo_clo_150
    i32.const 8
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_150
    struct.get $ClosureBase_389 0
    call_ref $FuncType_388
    i32.add
  )
  (func $closure_463 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_463))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_463)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_463 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_463 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_464 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_464))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_464)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_464 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_464 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_465 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_465))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_465)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_465 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_465 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_466 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_466))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_466)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_466 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_466 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_466
    local.get $a
    struct.new $ClosureType_466
  )
  (func $testMapModuleRemove (result i32) ;; exported as "testMapModuleRemove"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_153 (ref $ClosureBase_383))
    (local $lo_clo_152 (ref $ClosureBase_383))
    (local $lo_clo_151 (ref $ClosureBase_383))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_463
    i32.const 3
    i32.const 30
    struct.new $ClosureType_463
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_153
    local.get $lo_clo_153
    ref.func $closure_464
    i32.const 2
    i32.const 20
    struct.new $ClosureType_464
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_152
    local.get $lo_clo_152
    ref.func $closure_465
    i32.const 1
    i32.const 10
    struct.new $ClosureType_465
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_151
    local.get $lo_clo_151
    ref.func $closure_466
    struct.new $ClosureType_467
    call $Map_empty
    local.get $lo_clo_151
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_152
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_153
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_3
    i32.const 2
    local.get $m_3
    call $Map_remove
    local.set $m2
    local.get $m2
    return_call $Map_count
  )
  (func $runMapTests (param $check (ref $AnyFn)) ;; exported as "runMapTests"
  )
  (func $closure_468 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetContains (result i32) ;; exported as "testSetContains"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_468
    struct.new $ClosureType_468
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    i32.const 2
    local.get $s
    call $Set_contains
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
    i32.const 5
    local.get $s
    call $Set_contains
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
    i32.add
  )
  (func $closure_469 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetAdd (result i32) ;; exported as "testSetAdd"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_469
    struct.new $ClosureType_469
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    i32.const 4
    local.get $s
    call $Set_add
    local.set $s2
    i32.const 4
    local.get $s2
    call $Set_contains
    if (result i32)
      local.get $s2
      return_call $Set_count
    else
      i32.const 0
    end
  )
  (func $closure_470 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetRemove (result i32) ;; exported as "testSetRemove"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_470
    struct.new $ClosureType_470
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    i32.const 3
    local.get $s
    call $Set_remove
    local.set $s2
    local.get $s2
    return_call $Set_count
  )
  (func $closure_471 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_472 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
    local.get $x_1
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetIsEmpty (result i32) ;; exported as "testSetIsEmpty"
    (local $e (ref $SetModule_SetHandle`1))
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_471
    struct.new $ClosureType_471
    ref.null $ListBase
    call $Set_ofList
    local.set $e
    ref.func $closure_472
    struct.new $ClosureType_472
    i32.const 1
    ref.null $ListBase
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    local.get $e
    call $Set_isEmpty
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
    local.get $s
    call $Set_isEmpty
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
    i32.add
  )
  (func $closure_473 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_474 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_474))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_474)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_474 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_474 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_474
    local.get $acc
    struct.new $ClosureType_474
  )
  (func $testSetFold (result i32) ;; exported as "testSetFold"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_473
    struct.new $ClosureType_473
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    ref.func $closure_474
    struct.new $ClosureType_475
    i32.const 0
    local.get $s
    return_call $Set_fold
  )
  (func $closure_476 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_477 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testSetFilter (result i32) ;; exported as "testSetFilter"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_476
    struct.new $ClosureType_476
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    ref.func $closure_477
    struct.new $ClosureType_477
    local.get $s
    call $Set_filter
    local.set $s2
    local.get $s2
    return_call $Set_count
  )
  (func $closure_478 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_479 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 4
    i32.gt_s
  )
  (func $testSetExists (result i32) ;; exported as "testSetExists"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_478
    struct.new $ClosureType_478
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    ref.func $closure_479
    struct.new $ClosureType_479
    local.get $s
    call $Set_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_480 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_481 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 0
    i32.gt_s
  )
  (func $testSetForall (result i32) ;; exported as "testSetForall"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_480
    struct.new $ClosureType_480
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    ref.func $closure_481
    struct.new $ClosureType_481
    local.get $s
    call $Set_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_482 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_483 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
    local.get $x_1
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetUnion (result i32) ;; exported as "testSetUnion"
    (local $a (ref $SetModule_SetHandle`1))
    (local $b (ref $SetModule_SetHandle`1))
    ref.func $closure_482
    struct.new $ClosureType_482
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $a
    ref.func $closure_483
    struct.new $ClosureType_483
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $b
    local.get $a
    local.get $b
    call $Set_union
    return_call $Set_count
  )
  (func $closure_484 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_485 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
    local.get $x_1
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetIntersect (result i32) ;; exported as "testSetIntersect"
    (local $a (ref $SetModule_SetHandle`1))
    (local $b (ref $SetModule_SetHandle`1))
    ref.func $closure_484
    struct.new $ClosureType_484
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $a
    ref.func $closure_485
    struct.new $ClosureType_485
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $b
    local.get $a
    local.get $b
    call $Set_intersect
    return_call $Set_count
  )
  (func $closure_486 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_487 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
    local.get $x_1
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetDifference (result i32) ;; exported as "testSetDifference"
    (local $a (ref $SetModule_SetHandle`1))
    (local $b (ref $SetModule_SetHandle`1))
    ref.func $closure_486
    struct.new $ClosureType_486
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $a
    ref.func $closure_487
    struct.new $ClosureType_487
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $b
    local.get $a
    local.get $b
    call $Set_difference
    return_call $Set_count
  )
  (func $closure_488 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_489 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
    local.get $x_1
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetIsSubset (result i32) ;; exported as "testSetIsSubset"
    (local $a (ref $SetModule_SetHandle`1))
    (local $b (ref $SetModule_SetHandle`1))
    ref.func $closure_488
    struct.new $ClosureType_488
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $a
    ref.func $closure_489
    struct.new $ClosureType_489
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $b
    local.get $a
    local.get $b
    call $Set_isSubset
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
    local.get $b
    local.get $a
    call $Set_isSubset
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
    i32.add
  )
  (func $closure_490 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_491 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 1
    i32.shl
  )
  (func $closure_492 (param $self (ref $AnyFn)) (param $x_2 i32) (param $y_1 i32) (result i32)
    local.get $x_2
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_2
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_493 (param $self (ref $AnyFn)) (param $x_3 i32) (result i32)
    (local $self_cast (ref $ClosureType_493))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_493)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_493 1
    local.set $acc
    local.get $acc
    local.get $x_3
    i32.add
  )
  (func $closure_493 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_493
    local.get $acc
    struct.new $ClosureType_493
  )
  (func $testSetMap (result i32) ;; exported as "testSetMap"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_490
    struct.new $ClosureType_490
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    ref.func $closure_491
    struct.new $ClosureType_491
    local.get $s
    call $Set_map
    local.set $s2
    ref.func $closure_493
    struct.new $ClosureType_494
    i32.const 0
    local.get $s2
    return_call $Set_fold
  )
  (func $closure_495 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetMinMax (result i32) ;; exported as "testSetMinMax"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_495
    struct.new $ClosureType_495
    i32.const 5
    i32.const 1
    i32.const 3
    i32.const 2
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    local.get $s
    call $Set_minElement
    local.get $s
    call $Set_maxElement
    i32.add
  )
  (func $closure_496 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetSingleton (result i32) ;; exported as "testSetSingleton"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_496
    struct.new $ClosureType_496
    i32.const 42
    call $Set_singleton
    local.set $s
    i32.const 42
    local.get $s
    call $Set_contains
    if (result i32)
      local.get $s
      return_call $Set_count
    else
      i32.const 0
    end
  )
  (func $closure_497 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_497))
    (local $acc i32)
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_497)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_497 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_497 2
    local.set $offset
    local.get $acc
    local.get $v
    i32.add
    local.get $offset
    i32.add
  )
  (func $closure_497 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_498))
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_498)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_498 1
    local.set $offset
    ref.func $closure_497
    local.get $acc
    local.get $offset
    struct.new $ClosureType_497
  )
  (func $closure_499 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testClosureCapSetFold (result i32) ;; exported as "testClosureCapSetFold"
    ref.func $closure_497
    i32.const 100
    struct.new $ClosureType_498
    i32.const 0
    ref.func $closure_499
    struct.new $ClosureType_499
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    return_call $Set_fold
  )
  (func $closure_500 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_502))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_502)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_502 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_503 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_503))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_503)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_503 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_504 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_504))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_504)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_504 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_505 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_505))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_505)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_505 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_505 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_505
    local.get $a
    struct.new $ClosureType_505
  )
  (func $testSetModuleBasic (result i32) ;; exported as "testSetModuleBasic"
    (local $s_3 (ref $SetModule_SetHandle`1))
    (local $lo_clo_156 (ref $ClosureBase_501))
    (local $lo_clo_155 (ref $ClosureBase_501))
    (local $lo_clo_154 (ref $ClosureBase_501))
    ref.func $closure_500
    i32.const 7
    struct.new $ClosureType_502
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_156
    local.get $lo_clo_156
    ref.func $closure_503
    i32.const 3
    struct.new $ClosureType_503
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_155
    local.get $lo_clo_155
    ref.func $closure_504
    i32.const 5
    struct.new $ClosureType_504
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_154
    local.get $lo_clo_154
    ref.func $closure_505
    struct.new $ClosureType_506
    call $Set_empty
    local.get $lo_clo_154
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_155
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_156
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.set $s_3
    local.get $s_3
    return_call $Set_count
  )
  (func $closure_507 (param $self (ref $AnyFn)) (param $s_3 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_507))
    (local $value_3 i32)
    local.get $self
    ref.cast (ref $ClosureType_507)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_507 1
    local.set $value_3
    local.get $value_3
    local.get $s_3
    call $Set_add
  )
  (func $closure_508 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_508))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_508)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_508 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_509 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_509))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_509)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_509 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_510 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_510))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_510)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_510 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_511 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_511))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_511)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_511 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_511 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_511
    local.get $a
    struct.new $ClosureType_511
  )
  (func $testSetModuleDedup (result i32) ;; exported as "testSetModuleDedup"
    (local $s_4 (ref $SetModule_SetHandle`1))
    (local $lo_clo_160 (ref $ClosureBase_501))
    (local $lo_clo_159 (ref $ClosureBase_501))
    (local $lo_clo_158 (ref $ClosureBase_501))
    (local $lo_clo_157 (ref $ClosureBase_501))
    ref.func $closure_507
    i32.const 2
    struct.new $ClosureType_507
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_160
    local.get $lo_clo_160
    ref.func $closure_508
    i32.const 2
    struct.new $ClosureType_508
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_159
    local.get $lo_clo_159
    ref.func $closure_509
    i32.const 1
    struct.new $ClosureType_509
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_158
    local.get $lo_clo_158
    ref.func $closure_510
    i32.const 1
    struct.new $ClosureType_510
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_157
    local.get $lo_clo_157
    ref.func $closure_511
    struct.new $ClosureType_512
    call $Set_empty
    local.get $lo_clo_157
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_158
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_159
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_160
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.set $s_4
    local.get $s_4
    return_call $Set_count
  )
  (func $closure_513 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_513))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_513)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_513 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_514 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_514))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_514)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_514 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_515 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_515))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_515)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_515 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_515 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_515
    local.get $a
    struct.new $ClosureType_515
  )
  (func $testSetModuleContains (result i32) ;; exported as "testSetModuleContains"
    (local $s_2 (ref $SetModule_SetHandle`1))
    (local $lo_clo_162 (ref $ClosureBase_501))
    (local $lo_clo_161 (ref $ClosureBase_501))
    ref.func $closure_513
    i32.const 99
    struct.new $ClosureType_513
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_162
    local.get $lo_clo_162
    ref.func $closure_514
    i32.const 42
    struct.new $ClosureType_514
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_161
    local.get $lo_clo_161
    ref.func $closure_515
    struct.new $ClosureType_516
    call $Set_empty
    local.get $lo_clo_161
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_162
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.set $s_2
    i32.const 42
    local.get $s_2
    call $Set_contains
    if (result i32)
      i32.const 1
      local.get $s_2
      call $Set_contains
      i32.eqz
    else
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_517 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_517))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_517)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_517 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_518 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_518))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_518)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_518 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_519 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_519))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_519)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_519 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_520 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_520))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_520)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_520 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_520 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_520
    local.get $a
    struct.new $ClosureType_520
  )
  (func $closure_522 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_522))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_522)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_522 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_522 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_522
    local.get $acc
    struct.new $ClosureType_522
  )
  (func $testSetModuleFold (result i32) ;; exported as "testSetModuleFold"
    (local $s_3 (ref $SetModule_SetHandle`1))
    (local $lo_clo_165 (ref $ClosureBase_501))
    (local $lo_clo_164 (ref $ClosureBase_501))
    (local $lo_clo_163 (ref $ClosureBase_501))
    ref.func $closure_517
    i32.const 30
    struct.new $ClosureType_517
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_165
    local.get $lo_clo_165
    ref.func $closure_518
    i32.const 20
    struct.new $ClosureType_518
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_164
    local.get $lo_clo_164
    ref.func $closure_519
    i32.const 10
    struct.new $ClosureType_519
    ref.cast (ref $ClosureBase_501)
    local.set $lo_clo_163
    local.get $lo_clo_163
    ref.func $closure_520
    struct.new $ClosureType_521
    call $Set_empty
    local.get $lo_clo_163
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_164
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.get $lo_clo_165
    struct.get $ClosureBase_501 0
    call_ref $FuncType_500
    local.set $s_3
    ref.func $closure_522
    struct.new $ClosureType_523
    i32.const 0
    local.get $s_3
    return_call $Set_fold
  )
  (func $runSetTests (param $check (ref $AnyFn)) ;; exported as "runSetTests"
  )
  (func $testListHead (result i32) ;; exported as "testListHead"
    (local $xs (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    local.get $xs
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testListEmpty (result i32) ;; exported as "testListEmpty"
    i32.const 1
  )
  (func $testListMatch (result i32) ;; exported as "testListMatch"
    (local $xs (ref null $ListBase))
    i32.const 5
    i32.const 6
    i32.const 7
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    local.get $xs
    ref.is_null
    i32.eqz
    if (result i32)
      local.get $xs
      ref.cast (ref $ListCons_37)
      struct.get $ListCons_37 0
    else
      i32.const 0
    end
  )
  (func $closure_524 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_524))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_524)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_524 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_524 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_524
    local.get $acc
    struct.new $ClosureType_524
  )
  (func $testListFoldSum (result i32) ;; exported as "testListFoldSum"
    (local $xs (ref null $ListBase))
    (local $w622 (ref null $ListBase))
    (local $w623 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    local.get $xs
    local.set $w622
    i32.const 0
    local.set $w623
    block $while_624_exit
      loop $while_624_lp
        local.get $w622
        ref.is_null
        i32.eqz
        if
          local.get $w622
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $w623
          local.get $x
          i32.add
          local.set $w623
          local.get $w622
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w622
          br $while_624_lp
        else
          br $while_624_exit
        end
      end
    end
    local.get $w623
  )
  (func $closure_526 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_527 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_527))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_527)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_527 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_527 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_527
    local.get $acc
    struct.new $ClosureType_527
  )
  (func $testListMapSum (result i32) ;; exported as "testListMapSum"
    (local $xs (ref null $ListBase))
    (local $doubled (ref null $ListBase))
    (local $w629 (ref null $ListBase))
    (local $w626 (ref null $ListBase))
    (local $w627 (ref null $ListBase))
    (local $x i32)
    (local $w630 (ref null $ListBase))
    (local $w633 (ref null $ListBase))
    (local $w634 i32)
    (local $x_1 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    local.get $xs
    local.set $w626
    ref.null $ListBase
    local.set $w627
    block $while_628_exit
      loop $while_628_lp
        local.get $w626
        ref.is_null
        i32.eqz
        if
          local.get $w626
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          local.get $w627
          struct.new $ListCons_37
          local.set $w627
          local.get $w626
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w626
          br $while_628_lp
        else
          br $while_628_exit
        end
      end
    end
    local.get $w627
    local.set $w629
    ref.null $ListBase
    local.set $w630
    block $while_631_exit
      loop $while_631_lp
        local.get $w629
        ref.is_null
        i32.eqz
        if
          local.get $w629
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w630
          struct.new $ListCons_37
          local.set $w630
          local.get $w629
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w629
          br $while_631_lp
        else
          br $while_631_exit
        end
      end
    end
    local.get $w630
    local.set $doubled
    local.get $doubled
    local.set $w633
    i32.const 0
    local.set $w634
    block $while_635_exit
      loop $while_635_lp
        local.get $w633
        ref.is_null
        i32.eqz
        if
          local.get $w633
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x_1
          local.get $w634
          local.get $x_1
          i32.add
          local.set $w634
          local.get $w633
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w633
          br $while_635_lp
        else
          br $while_635_exit
        end
      end
    end
    local.get $w634
  )
  (func $closure_529 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $closure_530 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_530))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_530)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_530 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_530 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_530
    local.get $acc
    struct.new $ClosureType_530
  )
  (func $testListFilterSum (result i32) ;; exported as "testListFilterSum"
    (local $xs (ref null $ListBase))
    (local $big (ref null $ListBase))
    (local $w640 (ref null $ListBase))
    (local $w637 (ref null $ListBase))
    (local $w638 (ref null $ListBase))
    (local $x i32)
    (local $w641 (ref null $ListBase))
    (local $w644 (ref null $ListBase))
    (local $w645 i32)
    (local $x_1 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    local.get $xs
    local.set $w637
    ref.null $ListBase
    local.set $w638
    block $while_639_exit
      loop $while_639_lp
        local.get $w637
        ref.is_null
        i32.eqz
        if
          local.get $w637
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w637
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.get $w638
            struct.new $ListCons_37
          else
            local.get $w638
          end
          local.set $w638
          local.get $w637
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w637
          br $while_639_lp
        else
          br $while_639_exit
        end
      end
    end
    local.get $w638
    local.set $w640
    ref.null $ListBase
    local.set $w641
    block $while_642_exit
      loop $while_642_lp
        local.get $w640
        ref.is_null
        i32.eqz
        if
          local.get $w640
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w641
          struct.new $ListCons_37
          local.set $w641
          local.get $w640
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w640
          br $while_642_lp
        else
          br $while_642_exit
        end
      end
    end
    local.get $w641
    local.set $big
    local.get $big
    local.set $w644
    i32.const 0
    local.set $w645
    block $while_646_exit
      loop $while_646_lp
        local.get $w644
        ref.is_null
        i32.eqz
        if
          local.get $w644
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x_1
          local.get $w645
          local.get $x_1
          i32.add
          local.set $w645
          local.get $w644
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w644
          br $while_646_lp
        else
          br $while_646_exit
        end
      end
    end
    local.get $w645
  )
  (func $testListRevHead (result i32) ;; exported as "testListRevHead"
    (local $xs (ref null $ListBase))
    (local $w648 (ref null $ListBase))
    (local $w649 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    local.get $xs
    local.set $w648
    ref.null $ListBase
    local.set $w649
    block $while_650_exit
      loop $while_650_lp
        local.get $w648
        ref.is_null
        i32.eqz
        if
          local.get $w648
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w649
          struct.new $ListCons_37
          local.set $w649
          local.get $w648
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w648
          br $while_650_lp
        else
          br $while_650_exit
        end
      end
    end
    local.get $w649
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testListAppendLen (result i32) ;; exported as "testListAppendLen"
    (local $xs (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $w659 (ref null $ListBase))
    (local $w652 (ref null $ListBase))
    (local $w653 (ref null $ListBase))
    (local $w655 (ref null $ListBase))
    (local $w656 (ref null $ListBase))
    (local $w660 i32)
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $ys
    local.get $xs
    local.set $w652
    local.get $ys
    local.set $w653
    block $while_654_exit
      loop $while_654_lp
        local.get $w652
        ref.is_null
        i32.eqz
        if
          local.get $w652
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w653
          struct.new $ListCons_37
          local.set $w653
          local.get $w652
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w652
          br $while_654_lp
        else
          br $while_654_exit
        end
      end
    end
    local.get $w653
    local.set $w655
    ref.null $ListBase
    local.set $w656
    block $while_657_exit
      loop $while_657_lp
        local.get $w655
        ref.is_null
        i32.eqz
        if
          local.get $w655
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w656
          struct.new $ListCons_37
          local.set $w656
          local.get $w655
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w655
          br $while_657_lp
        else
          br $while_657_exit
        end
      end
    end
    local.get $w656
    local.set $w659
    i32.const 0
    local.set $w660
    block $while_661_exit
      loop $while_661_lp
        local.get $w659
        ref.is_null
        i32.eqz
        if
          local.get $w660
          i32.const 1
          i32.add
          local.set $w660
          local.get $w659
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w659
          br $while_661_lp
        else
          br $while_661_exit
        end
      end
    end
    local.get $w660
  )
  (func $closure_532 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_532))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_532)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_532 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIter (result i32) ;; exported as "testListIter"
    (local $acc i32)
    (local $w663 (ref null $ListBase))
    (local $x i32)
    i32.const 0
    local.set $acc
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w663
    block $while_664_exit
      loop $while_664_lp
        local.get $w663
        ref.is_null
        i32.eqz
        if
          local.get $w663
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w663
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w663
          br $while_664_lp
        else
          br $while_664_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_533 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_533))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_533)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_533 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIterEmpty (result i32) ;; exported as "testListIterEmpty"
    (local $acc i32)
    (local $w666 (ref null $ListBase))
    (local $x i32)
    i32.const 0
    local.set $acc
    ref.null $ListBase
    local.set $w666
    block $while_667_exit
      loop $while_667_lp
        local.get $w666
        ref.is_null
        i32.eqz
        if
          local.get $w666
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w666
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w666
          br $while_667_lp
        else
          br $while_667_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_534 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListExists (result i32) ;; exported as "testListExists"
    (local $w669 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w669
    block $exi_668_blk (result i32)
      block $exi_668_lp_exit
        loop $exi_668_lp
          local.get $w669
          ref.is_null
          i32.eqz
          if
            local.get $w669
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              i32.const 1
              br $exi_668_blk
            end
            local.get $w669
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w669
          else
            br $exi_668_lp_exit
          end
          br $exi_668_lp
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_535 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListExistsFalse (result i32) ;; exported as "testListExistsFalse"
    (local $w671 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w671
    block $exi_670_blk (result i32)
      block $exi_670_lp_exit
        loop $exi_670_lp
          local.get $w671
          ref.is_null
          i32.eqz
          if
            local.get $w671
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $exi_670_blk
            end
            local.get $w671
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w671
          else
            br $exi_670_lp_exit
          end
          br $exi_670_lp
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_536 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListForAll (result i32) ;; exported as "testListForAll"
    (local $w673 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w673
    block $all_672_blk (result i32)
      block $all_672_lp_exit
        loop $all_672_lp
          local.get $w673
          ref.is_null
          i32.eqz
          if
            local.get $w673
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w673
              ref.cast (ref $ListCons_37)
              struct.get $ListCons_37 1
              local.set $w673
            else
              i32.const 0
              br $all_672_blk
            end
          else
            br $all_672_lp_exit
          end
          br $all_672_lp
        end
      end
      i32.const 1
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_537 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testListForAllFalse (result i32) ;; exported as "testListForAllFalse"
    (local $w675 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w675
    block $all_674_blk (result i32)
      block $all_674_lp_exit
        loop $all_674_lp
          local.get $w675
          ref.is_null
          i32.eqz
          if
            local.get $w675
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 2
            i32.gt_s
            if
              local.get $w675
              ref.cast (ref $ListCons_37)
              struct.get $ListCons_37 1
              local.set $w675
            else
              i32.const 0
              br $all_674_blk
            end
          else
            br $all_674_lp_exit
          end
          br $all_674_lp
        end
      end
      i32.const 1
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_538 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSum (result i32) ;; exported as "testListSum"
    (local $w677 (ref null $ListBase))
    (local $w678 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w677
    i32.const 0
    local.set $w678
    block $while_679_exit
      loop $while_679_lp
        local.get $w677
        ref.is_null
        i32.eqz
        if
          local.get $w678
          local.get $w677
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w678
          local.get $w677
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w677
          br $while_679_lp
        else
          br $while_679_exit
        end
      end
    end
    local.get $w678
  )
  (func $closure_539 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumEmpty (result i32) ;; exported as "testListSumEmpty"
    (local $w681 (ref null $ListBase))
    (local $w682 i32)
    ref.null $ListBase
    local.set $w681
    i32.const 0
    local.set $w682
    block $while_683_exit
      loop $while_683_lp
        local.get $w681
        ref.is_null
        i32.eqz
        if
          local.get $w682
          local.get $w681
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w682
          local.get $w681
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w681
          br $while_683_lp
        else
          br $while_683_exit
        end
      end
    end
    local.get $w682
  )
  (func $closure_540 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListTryFindSome (result i32) ;; exported as "testListTryFindSome"
    (local $matchValue (ref null $Option_118))
    (local $w685 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w685
    block $tryf_684_exit (result (ref null $Option_118))
      block $tryf_684_lp_exit
        loop $tryf_684_lp
          local.get $w685
          ref.is_null
          i32.eqz
          if
            local.get $w685
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w685
              ref.cast (ref $ListCons_37)
              struct.get $ListCons_37 0
              struct.new $Option_118
              br $tryf_684_exit
            end
            local.get $w685
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w685
          else
            br $tryf_684_lp_exit
          end
          br $tryf_684_lp
        end
      end
      ref.null $Option_118
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $closure_541 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindNone (result i32) ;; exported as "testListTryFindNone"
    (local $matchValue (ref null $Option_118))
    (local $w687 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w687
    block $tryf_686_exit (result (ref null $Option_118))
      block $tryf_686_lp_exit
        loop $tryf_686_lp
          local.get $w687
          ref.is_null
          i32.eqz
          if
            local.get $w687
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              local.get $w687
              ref.cast (ref $ListCons_37)
              struct.get $ListCons_37 0
              struct.new $Option_118
              br $tryf_686_exit
            end
            local.get $w687
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w687
          else
            br $tryf_686_lp_exit
          end
          br $tryf_686_lp
        end
      end
      ref.null $Option_118
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $testListTryHeadSome (result i32) ;; exported as "testListTryHeadSome"
    (local $matchValue (ref null $Option_118))
    (local $w689 (ref null $ListBase))
    i32.const 7
    i32.const 8
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w689
    local.get $w689
    ref.is_null
    if (result (ref null $Option_118))
      ref.null $Option_118
    else
      local.get $w689
      ref.cast (ref $ListCons_37)
      struct.get $ListCons_37 0
      struct.new $Option_118
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $testListTryHeadNone (result i32) ;; exported as "testListTryHeadNone"
    (local $matchValue (ref null $Option_118))
    ref.null $Option_118
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $closure_542 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_542))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_542)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_542 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_542 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_542
    local.get $x
    struct.new $ClosureType_542
  )
  (func $closure_544 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_544))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_544)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_544 1
    local.set $i
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $closure_544 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_544
    local.get $i
    struct.new $ClosureType_544
  )
  (func $closure_546 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_546))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_546)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_546 1
    local.set $i
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $closure_546 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_546
    local.get $i
    struct.new $ClosureType_546
  )
  (func $testListMapi (result i32) ;; exported as "testListMapi"
    (local $w709 (ref null $ListBase))
    (local $w706 (ref null $ListBase))
    (local $w702 (ref null $ListBase))
    (local $w703 (ref null $ListBase))
    (local $w704 i32)
    (local $x_1 i32)
    (local $w707 (ref null $ListBase))
    (local $w710 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w702
    ref.null $ListBase
    local.set $w703
    i32.const 0
    local.set $w704
    block $while_705_exit
      loop $while_705_lp
        local.get $w702
        ref.is_null
        i32.eqz
        if
          local.get $w702
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x_1
          local.get $w704
          local.get $x_1
          i32.mul
          local.get $w703
          struct.new $ListCons_37
          local.set $w703
          local.get $w704
          i32.const 1
          i32.add
          local.set $w704
          local.get $w702
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w702
          br $while_705_lp
        else
          br $while_705_exit
        end
      end
    end
    local.get $w703
    local.set $w706
    ref.null $ListBase
    local.set $w707
    block $while_708_exit
      loop $while_708_lp
        local.get $w706
        ref.is_null
        i32.eqz
        if
          local.get $w706
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w707
          struct.new $ListCons_37
          local.set $w707
          local.get $w706
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w706
          br $while_708_lp
        else
          br $while_708_exit
        end
      end
    end
    local.get $w707
    local.set $w709
    i32.const 0
    local.set $w710
    block $while_711_exit
      loop $while_711_lp
        local.get $w709
        ref.is_null
        i32.eqz
        if
          local.get $w709
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $y
          local.get $w710
          local.get $y
          i32.add
          local.set $w710
          local.get $w709
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w709
          br $while_711_lp
        else
          br $while_711_exit
        end
      end
    end
    local.get $w710
  )
  (func $closure_548 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_548))
    (local $i i32)
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_548)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_548 1
    local.set $i
    local.get $self_cast
    struct.get $ClosureType_548 2
    local.set $s
    local.get $s
    local.get $i
    local.get $x
    i32.mul
    i32.add
    local.set $s
  )
  (func $closure_548 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_549))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_549)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_549 1
    local.set $s
    ref.func $closure_548
    local.get $i
    local.get $s
    struct.new $ClosureType_548
  )
  (func $testListIteri (result i32) ;; exported as "testListIteri"
    (local $s i32)
    (local $w713 (ref null $ListBase))
    (local $w714 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w713
    i32.const 0
    local.set $w714
    block $while_715_exit
      loop $while_715_lp
        local.get $w713
        ref.is_null
        i32.eqz
        if
          local.get $w713
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $s
          local.get $w714
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w714
          i32.const 1
          i32.add
          local.set $w714
          local.get $w713
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w713
          br $while_715_lp
        else
          br $while_715_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_550 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
  )
  (func $testListCollect (result i32) ;; exported as "testListCollect"
    (local $w729 (ref null $ListBase))
    (local $w717 (ref null $ListBase))
    (local $w718 (ref null $ListBase))
    (local $w719 (ref null $ListBase))
    (local $x i32)
    (local $w723 (ref null $ListBase))
    (local $w720 (ref null $ListBase))
    (local $w721 (ref null $ListBase))
    (local $w725 (ref null $ListBase))
    (local $w726 (ref null $ListBase))
    (local $w730 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w717
    ref.null $ListBase
    local.set $w718
    block $while_724_exit
      loop $while_724_lp
        local.get $w717
        ref.is_null
        i32.eqz
        if
          local.get $w717
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          local.get $x
          i32.const 1
          i32.shl
          ref.null $ListBase
          struct.new $ListCons_37
          struct.new $ListCons_37
          local.set $w719
          local.get $w719
          local.set $w720
          local.get $w718
          local.set $w721
          block $while_722_exit
            loop $while_722_lp
              local.get $w720
              ref.is_null
              i32.eqz
              if
                local.get $w720
                ref.cast (ref $ListCons_37)
                struct.get $ListCons_37 0
                local.get $w721
                struct.new $ListCons_37
                local.set $w721
                local.get $w720
                ref.cast (ref $ListCons_37)
                struct.get $ListCons_37 1
                local.set $w720
                br $while_722_lp
              else
                br $while_722_exit
              end
            end
          end
          local.get $w721
          local.set $w723
          local.get $w723
          local.set $w718
          local.get $w717
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w717
          br $while_724_lp
        else
          br $while_724_exit
        end
      end
    end
    local.get $w718
    local.set $w725
    ref.null $ListBase
    local.set $w726
    block $while_727_exit
      loop $while_727_lp
        local.get $w725
        ref.is_null
        i32.eqz
        if
          local.get $w725
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w726
          struct.new $ListCons_37
          local.set $w726
          local.get $w725
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w725
          br $while_727_lp
        else
          br $while_727_exit
        end
      end
    end
    local.get $w726
    local.set $w729
    i32.const 0
    local.set $w730
    block $while_731_exit
      loop $while_731_lp
        local.get $w729
        ref.is_null
        i32.eqz
        if
          local.get $w730
          i32.const 1
          i32.add
          local.set $w730
          local.get $w729
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w729
          br $while_731_lp
        else
          br $while_731_exit
        end
      end
    end
    local.get $w730
  )
  (func $closure_551 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_551))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_551)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_551 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_551 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_551
    local.get $x
    struct.new $ClosureType_551
  )
  (func $closure_553 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
  )
  (func $closure_554 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
  )
  (func $testListCollectOrder (result i32) ;; exported as "testListCollectOrder"
    (local $w757 (ref null $ListBase))
    (local $w746 (ref null $ListBase))
    (local $w747 (ref null $ListBase))
    (local $w748 (ref null $ListBase))
    (local $x_1 i32)
    (local $w752 (ref null $ListBase))
    (local $w749 (ref null $ListBase))
    (local $w750 (ref null $ListBase))
    (local $w754 (ref null $ListBase))
    (local $w755 (ref null $ListBase))
    (local $w758 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w746
    ref.null $ListBase
    local.set $w747
    block $while_753_exit
      loop $while_753_lp
        local.get $w746
        ref.is_null
        i32.eqz
        if
          local.get $w746
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x_1
          local.get $x_1
          local.get $x_1
          i32.const 1
          i32.shl
          ref.null $ListBase
          struct.new $ListCons_37
          struct.new $ListCons_37
          local.set $w748
          local.get $w748
          local.set $w749
          local.get $w747
          local.set $w750
          block $while_751_exit
            loop $while_751_lp
              local.get $w749
              ref.is_null
              i32.eqz
              if
                local.get $w749
                ref.cast (ref $ListCons_37)
                struct.get $ListCons_37 0
                local.get $w750
                struct.new $ListCons_37
                local.set $w750
                local.get $w749
                ref.cast (ref $ListCons_37)
                struct.get $ListCons_37 1
                local.set $w749
                br $while_751_lp
              else
                br $while_751_exit
              end
            end
          end
          local.get $w750
          local.set $w752
          local.get $w752
          local.set $w747
          local.get $w746
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w746
          br $while_753_lp
        else
          br $while_753_exit
        end
      end
    end
    local.get $w747
    local.set $w754
    ref.null $ListBase
    local.set $w755
    block $while_756_exit
      loop $while_756_lp
        local.get $w754
        ref.is_null
        i32.eqz
        if
          local.get $w754
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w755
          struct.new $ListCons_37
          local.set $w755
          local.get $w754
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w754
          br $while_756_lp
        else
          br $while_756_exit
        end
      end
    end
    local.get $w755
    local.set $w757
    i32.const 0
    local.set $w758
    block $while_759_exit
      loop $while_759_lp
        local.get $w757
        ref.is_null
        i32.eqz
        if
          local.get $w757
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $y
          local.get $w758
          local.get $y
          i32.add
          local.set $w758
          local.get $w757
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w757
          br $while_759_lp
        else
          br $while_759_exit
        end
      end
    end
    local.get $w758
  )
  (func $closure_555 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_118))
    local.get $x
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_118))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_118
    else
      ref.null $Option_118
    end
  )
  (func $testListChoose (result i32) ;; exported as "testListChoose"
    (local $w768 (ref null $ListBase))
    (local $w764 (ref null $ListBase))
    (local $w761 (ref null $ListBase))
    (local $w762 (ref null $ListBase))
    (local $cho_760_opt (ref null $Option_118))
    (local $x i32)
    (local $w765 (ref null $ListBase))
    (local $w769 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w761
    ref.null $ListBase
    local.set $w762
    block $while_763_exit
      loop $while_763_lp
        local.get $w761
        ref.is_null
        i32.eqz
        if
          local.get $w761
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_118))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_118
          else
            ref.null $Option_118
          end
          local.set $cho_760_opt
          local.get $cho_760_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_760_opt
            ref.cast (ref $Option_118)
            struct.get $Option_118 0
            local.get $w762
            struct.new $ListCons_37
          else
            local.get $w762
          end
          local.set $w762
          local.get $w761
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w761
          br $while_763_lp
        else
          br $while_763_exit
        end
      end
    end
    local.get $w762
    local.set $w764
    ref.null $ListBase
    local.set $w765
    block $while_766_exit
      loop $while_766_lp
        local.get $w764
        ref.is_null
        i32.eqz
        if
          local.get $w764
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w765
          struct.new $ListCons_37
          local.set $w765
          local.get $w764
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w764
          br $while_766_lp
        else
          br $while_766_exit
        end
      end
    end
    local.get $w765
    local.set $w768
    i32.const 0
    local.set $w769
    block $while_770_exit
      loop $while_770_lp
        local.get $w768
        ref.is_null
        i32.eqz
        if
          local.get $w769
          i32.const 1
          i32.add
          local.set $w769
          local.get $w768
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w768
          br $while_770_lp
        else
          br $while_770_exit
        end
      end
    end
    local.get $w769
  )
  (func $closure_556 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_556))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_556)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_556 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_556 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_556
    local.get $x
    struct.new $ClosureType_556
  )
  (func $closure_558 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_118))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_118))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_118
    else
      ref.null $Option_118
    end
  )
  (func $closure_559 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_118))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_118))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_118
    else
      ref.null $Option_118
    end
  )
  (func $testListChooseSum (result i32) ;; exported as "testListChooseSum"
    (local $w786 (ref null $ListBase))
    (local $w783 (ref null $ListBase))
    (local $w780 (ref null $ListBase))
    (local $w781 (ref null $ListBase))
    (local $cho_779_opt (ref null $Option_118))
    (local $x_1 i32)
    (local $w784 (ref null $ListBase))
    (local $w787 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w780
    ref.null $ListBase
    local.set $w781
    block $while_782_exit
      loop $while_782_lp
        local.get $w780
        ref.is_null
        i32.eqz
        if
          local.get $w780
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x_1
          local.get $x_1
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_118))
            local.get $x_1
            i32.const 10
            i32.mul
            struct.new $Option_118
          else
            ref.null $Option_118
          end
          local.set $cho_779_opt
          local.get $cho_779_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_779_opt
            ref.cast (ref $Option_118)
            struct.get $Option_118 0
            local.get $w781
            struct.new $ListCons_37
          else
            local.get $w781
          end
          local.set $w781
          local.get $w780
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w780
          br $while_782_lp
        else
          br $while_782_exit
        end
      end
    end
    local.get $w781
    local.set $w783
    ref.null $ListBase
    local.set $w784
    block $while_785_exit
      loop $while_785_lp
        local.get $w783
        ref.is_null
        i32.eqz
        if
          local.get $w783
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w784
          struct.new $ListCons_37
          local.set $w784
          local.get $w783
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w783
          br $while_785_lp
        else
          br $while_785_exit
        end
      end
    end
    local.get $w784
    local.set $w786
    i32.const 0
    local.set $w787
    block $while_788_exit
      loop $while_788_lp
        local.get $w786
        ref.is_null
        i32.eqz
        if
          local.get $w786
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $y
          local.get $w787
          local.get $y
          i32.add
          local.set $w787
          local.get $w786
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w786
          br $while_788_lp
        else
          br $while_788_exit
        end
      end
    end
    local.get $w787
  )
  (func $closure_560 (param $self (ref $AnyFn)) (param $acc (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_560))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_560)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_560 1
    local.set $x
    local.get $x
    local.get $acc
    struct.new $ListCons_37
  )
  (func $closure_560 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_560
    local.get $x
    struct.new $ClosureType_560
  )
  (func $testListFoldBack (result i32) ;; exported as "testListFoldBack"
    (local $w797 (ref null $ListBase))
    (local $w793 (ref null $ListBase))
    (local $w790 (ref null $ListBase))
    (local $w791 (ref null $ListBase))
    (local $w794 (ref null $ListBase))
    (local $x i32)
    (local $w798 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w790
    ref.null $ListBase
    local.set $w791
    block $while_792_exit
      loop $while_792_lp
        local.get $w790
        ref.is_null
        i32.eqz
        if
          local.get $w790
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w791
          struct.new $ListCons_37
          local.set $w791
          local.get $w790
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w790
          br $while_792_lp
        else
          br $while_792_exit
        end
      end
    end
    local.get $w791
    local.set $w793
    ref.null $ListBase
    local.set $w794
    block $while_795_exit
      loop $while_795_lp
        local.get $w793
        ref.is_null
        i32.eqz
        if
          local.get $w793
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          local.get $w794
          struct.new $ListCons_37
          local.set $w794
          local.get $w793
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w793
          br $while_795_lp
        else
          br $while_795_exit
        end
      end
    end
    local.get $w794
    local.set $w797
    i32.const 0
    local.set $w798
    block $while_799_exit
      loop $while_799_lp
        local.get $w797
        ref.is_null
        i32.eqz
        if
          local.get $w798
          i32.const 1
          i32.add
          local.set $w798
          local.get $w797
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w797
          br $while_799_lp
        else
          br $while_799_exit
        end
      end
    end
    local.get $w798
  )
  (func $closure_562 (param $self (ref $AnyFn)) (param $acc i32) (result i32)
    (local $self_cast (ref $ClosureType_562))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_562)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_562 1
    local.set $x
    local.get $x
    local.get $acc
    i32.sub
  )
  (func $closure_562 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_562
    local.get $x
    struct.new $ClosureType_562
  )
  (func $testListFoldBackOrder (result i32) ;; exported as "testListFoldBackOrder"
    (local $w804 (ref null $ListBase))
    (local $w801 (ref null $ListBase))
    (local $w802 (ref null $ListBase))
    (local $w805 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w801
    ref.null $ListBase
    local.set $w802
    block $while_803_exit
      loop $while_803_lp
        local.get $w801
        ref.is_null
        i32.eqz
        if
          local.get $w801
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w802
          struct.new $ListCons_37
          local.set $w802
          local.get $w801
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w801
          br $while_803_lp
        else
          br $while_803_exit
        end
      end
    end
    local.get $w802
    local.set $w804
    i32.const 0
    local.set $w805
    block $while_806_exit
      loop $while_806_lp
        local.get $w804
        ref.is_null
        i32.eqz
        if
          local.get $w804
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          local.get $w805
          i32.sub
          local.set $w805
          local.get $w804
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w804
          br $while_806_lp
        else
          br $while_806_exit
        end
      end
    end
    local.get $w805
  )
  (func $closure_564 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    local.get $x
    i32.mul
  )
  (func $closure_565 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumBy (result i32) ;; exported as "testListSumBy"
    (local $w808 (ref null $ListBase))
    (local $w809 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w808
    i32.const 0
    local.set $w809
    block $while_810_exit
      loop $while_810_lp
        local.get $w808
        ref.is_null
        i32.eqz
        if
          local.get $w809
          local.get $w808
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          local.get $x
          i32.mul
          i32.add
          local.set $w809
          local.get $w808
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w808
          br $while_810_lp
        else
          br $while_810_exit
        end
      end
    end
    local.get $w809
  )
  (func $closure_566 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_567 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListMinBy (result i32) ;; exported as "testListMinBy"
    (local $w812 (ref null $ListBase))
    (local $w813 (ref $ListCons_37))
    (local $w814 i32)
    (local $w815 i32)
    (local $x i32)
    (local $w816 (ref null $ListBase))
    (local $w817 i32)
    (local $w818 i32)
    i32.const 4
    i32.const 2
    i32.const 7
    i32.const 1
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w812
    local.get $w812
    ref.cast (ref $ListCons_37)
    local.set $w813
    local.get $w813
    struct.get $ListCons_37 0
    local.set $w814
    local.get $w813
    struct.get $ListCons_37 0
    local.set $x
    local.get $x
    i32.const 3
    i32.rem_s
    local.set $w815
    local.get $w813
    struct.get $ListCons_37 1
    local.set $w816
    block $while_819_exit
      loop $while_819_lp
        local.get $w816
        ref.is_null
        i32.eqz
        if
          local.get $w816
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w817
          local.get $w817
          i32.const 3
          i32.rem_s
          local.set $w818
          local.get $w818
          local.get $w815
          i32.lt_s
          if
            local.get $w817
            local.set $w814
            local.get $w818
            local.set $w815
          end
          local.get $w816
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w816
          br $while_819_lp
        else
          br $while_819_exit
        end
      end
    end
    local.get $w814
  )
  (func $closure_568 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 5
    i32.rem_s
  )
  (func $closure_569 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListMaxBy (result i32) ;; exported as "testListMaxBy"
    (local $w821 (ref null $ListBase))
    (local $w822 (ref $ListCons_37))
    (local $w823 i32)
    (local $w824 i32)
    (local $x i32)
    (local $w825 (ref null $ListBase))
    (local $w826 i32)
    (local $w827 i32)
    i32.const 3
    i32.const 8
    i32.const 1
    i32.const 6
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w821
    local.get $w821
    ref.cast (ref $ListCons_37)
    local.set $w822
    local.get $w822
    struct.get $ListCons_37 0
    local.set $w823
    local.get $w822
    struct.get $ListCons_37 0
    local.set $x
    local.get $x
    i32.const 5
    i32.rem_s
    local.set $w824
    local.get $w822
    struct.get $ListCons_37 1
    local.set $w825
    block $while_828_exit
      loop $while_828_lp
        local.get $w825
        ref.is_null
        i32.eqz
        if
          local.get $w825
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w826
          local.get $w826
          i32.const 5
          i32.rem_s
          local.set $w827
          local.get $w827
          local.get $w824
          i32.gt_s
          if
            local.get $w826
            local.set $w823
            local.get $w827
            local.set $w824
          end
          local.get $w825
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w825
          br $while_828_lp
        else
          br $while_828_exit
        end
      end
    end
    local.get $w823
  )
  (func $closure_570 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListMin (result i32) ;; exported as "testListMin"
    (local $w830 (ref null $ListBase))
    (local $w831 (ref $ListCons_37))
    (local $w832 i32)
    (local $w833 (ref null $ListBase))
    (local $w834 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w830
    local.get $w830
    ref.cast (ref $ListCons_37)
    local.set $w831
    local.get $w831
    struct.get $ListCons_37 0
    local.set $w832
    local.get $w831
    struct.get $ListCons_37 1
    local.set $w833
    block $while_835_exit
      loop $while_835_lp
        local.get $w833
        ref.is_null
        i32.eqz
        if
          local.get $w833
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w834
          local.get $w834
          local.get $w832
          i32.lt_s
          if
            local.get $w834
            local.set $w832
          end
          local.get $w833
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w833
          br $while_835_lp
        else
          br $while_835_exit
        end
      end
    end
    local.get $w832
  )
  (func $closure_571 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListMax (result i32) ;; exported as "testListMax"
    (local $w837 (ref null $ListBase))
    (local $w838 (ref $ListCons_37))
    (local $w839 i32)
    (local $w840 (ref null $ListBase))
    (local $w841 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w837
    local.get $w837
    ref.cast (ref $ListCons_37)
    local.set $w838
    local.get $w838
    struct.get $ListCons_37 0
    local.set $w839
    local.get $w838
    struct.get $ListCons_37 1
    local.set $w840
    block $while_842_exit
      loop $while_842_lp
        local.get $w840
        ref.is_null
        i32.eqz
        if
          local.get $w840
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w841
          local.get $w841
          local.get $w839
          i32.gt_s
          if
            local.get $w841
            local.set $w839
          end
          local.get $w840
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w840
          br $while_842_lp
        else
          br $while_842_exit
        end
      end
    end
    local.get $w839
  )
  (func $closure_572 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContains (result i32) ;; exported as "testListContains"
    (local $w845 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w845
    block $lcont_843_exit (result i32)
      block $lcont_843_lp_exit
        loop $lcont_843_lp
          local.get $w845
          ref.is_null
          i32.eqz
          if
            local.get $w845
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $lcont_843_exit
            end
            local.get $w845
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w845
          else
            br $lcont_843_lp_exit
          end
          br $lcont_843_lp
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_573 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContainsFalse (result i32) ;; exported as "testListContainsFalse"
    (local $w848 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w848
    block $lcont_846_exit (result i32)
      block $lcont_846_lp_exit
        loop $lcont_846_lp
          local.get $w848
          ref.is_null
          i32.eqz
          if
            local.get $w848
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $lcont_846_exit
            end
            local.get $w848
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w848
          else
            br $lcont_846_lp_exit
          end
          br $lcont_846_lp
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_574 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    i32.const 1
  )
  (func $testListInit (result i32) ;; exported as "testListInit"
    (local $w854 (ref null $ListBase))
    (local $w850 i32)
    (local $w851 (ref null $ListBase))
    (local $w855 i32)
    i32.const 4
    local.set $w850
    ref.null $ListBase
    local.set $w851
    block $while_852_exit
      loop $while_852_lp
        local.get $w850
        i32.const 0
        i32.ge_s
        if
          i32.const 1
          local.get $w851
          struct.new $ListCons_37
          local.set $w851
          local.get $w850
          i32.const 1
          i32.sub
          local.set $w850
          br $while_852_lp
        else
          br $while_852_exit
        end
      end
    end
    local.get $w851
    local.set $w854
    i32.const 0
    local.set $w855
    block $while_856_exit
      loop $while_856_lp
        local.get $w854
        ref.is_null
        i32.eqz
        if
          local.get $w855
          i32.const 1
          i32.add
          local.set $w855
          local.get $w854
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w854
          br $while_856_lp
        else
          br $while_856_exit
        end
      end
    end
    local.get $w855
  )
  (func $testListReplicate (result i32) ;; exported as "testListReplicate"
    (local $w860 i32)
    (local $w861 (ref null $ListBase))
    i32.const 0
    local.set $w860
    ref.null $ListBase
    local.set $w861
    block $while_862_exit
      loop $while_862_lp
        local.get $w860
        i32.const 4
        i32.lt_s
        if
          i32.const 7
          local.get $w861
          struct.new $ListCons_37
          local.set $w861
          local.get $w860
          i32.const 1
          i32.add
          local.set $w860
          br $while_862_lp
        else
          br $while_862_exit
        end
      end
    end
    local.get $w861
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testListTake (result i32) ;; exported as "testListTake"
    (local $w872 i32)
    (local $w873 (ref null $ListBase))
    (local $w868 (ref null $ListBase))
    (local $w864 i32)
    (local $w865 (ref null $ListBase))
    (local $w866 (ref null $ListBase))
    (local $w869 (ref null $ListBase))
    i32.const 2
    local.set $w872
    i32.const 3
    local.set $w864
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w865
    ref.null $ListBase
    local.set $w866
    block $while_867_exit
      loop $while_867_lp
        local.get $w864
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w865
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w865
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w866
          struct.new $ListCons_37
          local.set $w866
          local.get $w865
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w865
          local.get $w864
          i32.const 1
          i32.sub
          local.set $w864
          br $while_867_lp
        else
          br $while_867_exit
        end
      end
    end
    local.get $w866
    local.set $w868
    ref.null $ListBase
    local.set $w869
    block $while_870_exit
      loop $while_870_lp
        local.get $w868
        ref.is_null
        i32.eqz
        if
          local.get $w868
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w869
          struct.new $ListCons_37
          local.set $w869
          local.get $w868
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w868
          br $while_870_lp
        else
          br $while_870_exit
        end
      end
    end
    local.get $w869
    local.set $w873
    block $while_874_exit
      loop $while_874_lp
        local.get $w872
        i32.const 0
        i32.gt_s
        if
          local.get $w873
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w873
          local.get $w872
          i32.const 1
          i32.sub
          local.set $w872
          br $while_874_lp
        else
          br $while_874_exit
        end
      end
    end
    local.get $w873
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testListSkip (result i32) ;; exported as "testListSkip"
    (local $w876 i32)
    (local $w877 (ref null $ListBase))
    i32.const 2
    local.set $w876
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w877
    block $while_878_exit
      loop $while_878_lp
        local.get $w876
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w877
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w877
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w877
          local.get $w876
          i32.const 1
          i32.sub
          local.set $w876
          br $while_878_lp
        else
          br $while_878_exit
        end
      end
    end
    local.get $w877
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_575 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListSort (result i32) ;; exported as "testListSort"
    (local $w880 (ref null $ListBase))
    (local $w884 i32)
    (local $w881 (ref null $ListBase))
    (local $w882 i32)
    (local $w885 (ref $GcArray_117))
    (local $w886 (ref null $ListBase))
    (local $w887 i32)
    (local $w889 i32)
    (local $w890 i32)
    (local $w891 i32)
    (local $w894 i32)
    (local $w895 (ref null $ListBase))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w880
    local.get $w880
    local.set $w881
    i32.const 0
    local.set $w882
    block $while_883_exit
      loop $while_883_lp
        local.get $w881
        ref.is_null
        i32.eqz
        if
          local.get $w882
          i32.const 1
          i32.add
          local.set $w882
          local.get $w881
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w881
          br $while_883_lp
        else
          br $while_883_exit
        end
      end
    end
    local.get $w882
    local.set $w884
    i32.const 0
    local.get $w884
    array.new $GcArray_117
    local.set $w885
    local.get $w880
    local.set $w886
    i32.const 0
    local.set $w887
    block $while_888_exit
      loop $while_888_lp
        local.get $w886
        ref.is_null
        i32.eqz
        if
          local.get $w885
          local.get $w887
          local.get $w886
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          array.set $GcArray_117
          local.get $w887
          i32.const 1
          i32.add
          local.set $w887
          local.get $w886
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w886
          br $while_888_lp
        else
          br $while_888_exit
        end
      end
    end
    local.get $w887
    drop
    i32.const 1
    local.set $w889
    block $while_893_exit
      loop $while_893_lp
        local.get $w889
        local.get $w884
        i32.lt_s
        if
          local.get $w885
          local.get $w889
          array.get $GcArray_117
          local.set $w890
          local.get $w889
          i32.const 1
          i32.sub
          local.set $w891
          block $while_892_exit
            loop $while_892_lp
              local.get $w891
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w885
                local.get $w891
                array.get $GcArray_117
                local.get $w890
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  i32.const 1
                end
                i32.const 0
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w885
                local.get $w891
                i32.const 1
                i32.add
                local.get $w885
                local.get $w891
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w891
                i32.const 1
                i32.sub
                local.set $w891
                br $while_892_lp
              else
                br $while_892_exit
              end
            end
          end
          local.get $w885
          local.get $w891
          i32.const 1
          i32.add
          local.get $w890
          array.set $GcArray_117
          local.get $w889
          i32.const 1
          i32.add
          local.set $w889
          br $while_893_lp
        else
          br $while_893_exit
        end
      end
    end
    local.get $w884
    i32.const 1
    i32.sub
    local.set $w894
    ref.null $ListBase
    local.set $w895
    block $while_896_exit
      loop $while_896_lp
        local.get $w894
        i32.const 0
        i32.ge_s
        if
          local.get $w885
          local.get $w894
          array.get $GcArray_117
          local.get $w895
          struct.new $ListCons_37
          local.set $w895
          local.get $w894
          i32.const 1
          i32.sub
          local.set $w894
          br $while_896_lp
        else
          br $while_896_exit
        end
      end
    end
    local.get $w895
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_576 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListFindIndex (result i32) ;; exported as "testListFindIndex"
    (local $w898 (ref null $ListBase))
    (local $w899 i32)
    (local $x i32)
    i32.const 1
    i32.const 5
    i32.const 2
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w898
    i32.const 0
    local.set $w899
    block $fdi_897_exit (result i32)
      loop $fdi_897_lp
        local.get $w898
        ref.is_null
        i32.eqz
        if
          local.get $w898
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if
            local.get $w899
            br $fdi_897_exit
          else
            local.get $w899
            i32.const 1
            i32.add
            local.set $w899
            local.get $w898
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w898
            br $fdi_897_lp
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_577 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindIndex (result i32) ;; exported as "testListTryFindIndex"
    (local $matchValue (ref null $Option_118))
    (local $w901 (ref null $ListBase))
    (local $w902 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w901
    i32.const 0
    local.set $w902
    block $fdi_900_exit (result (ref null $Option_118))
      loop $fdi_900_lp
        local.get $w901
        ref.is_null
        i32.eqz
        if
          local.get $w901
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w902
            struct.new $Option_118
            br $fdi_900_exit
          else
            local.get $w902
            i32.const 1
            i32.add
            local.set $w902
            local.get $w901
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w901
            br $fdi_900_lp
          end
        end
      end
      ref.null $Option_118
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_118)
      struct.get $Option_118 0
    end
  )
  (func $testListItem (result i32) ;; exported as "testListItem"
    (local $w904 i32)
    (local $w905 (ref null $ListBase))
    i32.const 2
    local.set $w904
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    i32.const 50
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w905
    block $while_906_exit
      loop $while_906_lp
        local.get $w904
        i32.const 0
        i32.gt_s
        if
          local.get $w905
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w905
          local.get $w904
          i32.const 1
          i32.sub
          local.set $w904
          br $while_906_lp
        else
          br $while_906_exit
        end
      end
    end
    local.get $w905
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testListTailHead (result i32) ;; exported as "testListTailHead"
    i32.const 100
    i32.const 200
    i32.const 300
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 1
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $testListLength (result i32) ;; exported as "testListLength"
    (local $w908 (ref null $ListBase))
    (local $w909 i32)
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w908
    i32.const 0
    local.set $w909
    block $while_910_exit
      loop $while_910_lp
        local.get $w908
        ref.is_null
        i32.eqz
        if
          local.get $w909
          i32.const 1
          i32.add
          local.set $w909
          local.get $w908
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w908
          br $while_910_lp
        else
          br $while_910_exit
        end
      end
    end
    local.get $w909
  )
  (func $closure_578 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_578))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_578)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_578 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_578 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_578
    local.get $a
    struct.new $ClosureType_578
  )
  (func $testListReduce (result i32) ;; exported as "testListReduce"
    (local $w911 (ref null $ListBase))
    (local $w912 (ref $ListCons_37))
    (local $w914 (ref null $ListBase))
    (local $w915 i32)
    (local $b i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w911
    local.get $w911
    ref.cast (ref $ListCons_37)
    local.set $w912
    local.get $w912
    struct.get $ListCons_37 1
    local.set $w914
    local.get $w912
    struct.get $ListCons_37 0
    local.set $w915
    block $while_916_exit
      loop $while_916_lp
        local.get $w914
        ref.is_null
        i32.eqz
        if
          local.get $w914
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $b
          local.get $w915
          local.get $b
          i32.add
          local.set $w915
          local.get $w914
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w914
          br $while_916_lp
        else
          br $while_916_exit
        end
      end
    end
    local.get $w915
  )
  (func $closure_580 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_580))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_580)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_580 1
    local.set $a
    local.get $a
    local.get $b
    i32.gt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end
  )
  (func $closure_580 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_580
    local.get $a
    struct.new $ClosureType_580
  )
  (func $testListReduceMax (result i32) ;; exported as "testListReduceMax"
    (local $w917 (ref null $ListBase))
    (local $w918 (ref $ListCons_37))
    (local $w920 (ref null $ListBase))
    (local $w921 i32)
    (local $b i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 9
    i32.const 2
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w917
    local.get $w917
    ref.cast (ref $ListCons_37)
    local.set $w918
    local.get $w918
    struct.get $ListCons_37 1
    local.set $w920
    local.get $w918
    struct.get $ListCons_37 0
    local.set $w921
    block $while_922_exit
      loop $while_922_lp
        local.get $w920
        ref.is_null
        i32.eqz
        if
          local.get $w920
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $b
          local.get $w921
          local.get $b
          i32.gt_s
          if (result i32)
            local.get $w921
          else
            local.get $b
          end
          local.set $w921
          local.get $w920
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w920
          br $while_922_lp
        else
          br $while_922_exit
        end
      end
    end
    local.get $w921
  )
  (func $testListLast (result i32) ;; exported as "testListLast"
    (local $w924 (ref null $ListBase))
    (local $w925 (ref $ListCons_37))
    (local $w926 i32)
    (local $w927 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w924
    local.get $w924
    ref.cast (ref $ListCons_37)
    local.set $w925
    local.get $w925
    struct.get $ListCons_37 0
    local.set $w926
    local.get $w925
    struct.get $ListCons_37 1
    local.set $w927
    block $while_928_exit
      loop $while_928_lp
        local.get $w927
        ref.is_null
        i32.eqz
        if
          local.get $w927
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w926
          local.get $w927
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w927
          br $while_928_lp
        else
          br $while_928_exit
        end
      end
    end
    local.get $w926
  )
  (func $testListLastSingle (result i32) ;; exported as "testListLastSingle"
    (local $w930 (ref null $ListBase))
    (local $w931 (ref $ListCons_37))
    (local $w932 i32)
    (local $w933 (ref null $ListBase))
    i32.const 42
    ref.null $ListBase
    struct.new $ListCons_37
    local.set $w930
    local.get $w930
    ref.cast (ref $ListCons_37)
    local.set $w931
    local.get $w931
    struct.get $ListCons_37 0
    local.set $w932
    local.get $w931
    struct.get $ListCons_37 1
    local.set $w933
    block $while_934_exit
      loop $while_934_lp
        local.get $w933
        ref.is_null
        i32.eqz
        if
          local.get $w933
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w932
          local.get $w933
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w933
          br $while_934_lp
        else
          br $while_934_exit
        end
      end
    end
    local.get $w932
  )
  (func $closure_582 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListSortDesc (result i32) ;; exported as "testListSortDesc"
    (local $w936 (ref null $ListBase))
    (local $w940 i32)
    (local $w937 (ref null $ListBase))
    (local $w938 i32)
    (local $w941 (ref $GcArray_117))
    (local $w942 (ref null $ListBase))
    (local $w943 i32)
    (local $w945 i32)
    (local $w946 i32)
    (local $w947 i32)
    (local $w950 i32)
    (local $w951 (ref null $ListBase))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w936
    local.get $w936
    local.set $w937
    i32.const 0
    local.set $w938
    block $while_939_exit
      loop $while_939_lp
        local.get $w937
        ref.is_null
        i32.eqz
        if
          local.get $w938
          i32.const 1
          i32.add
          local.set $w938
          local.get $w937
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w937
          br $while_939_lp
        else
          br $while_939_exit
        end
      end
    end
    local.get $w938
    local.set $w940
    i32.const 0
    local.get $w940
    array.new $GcArray_117
    local.set $w941
    local.get $w936
    local.set $w942
    i32.const 0
    local.set $w943
    block $while_944_exit
      loop $while_944_lp
        local.get $w942
        ref.is_null
        i32.eqz
        if
          local.get $w941
          local.get $w943
          local.get $w942
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          array.set $GcArray_117
          local.get $w943
          i32.const 1
          i32.add
          local.set $w943
          local.get $w942
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w942
          br $while_944_lp
        else
          br $while_944_exit
        end
      end
    end
    local.get $w943
    drop
    i32.const 1
    local.set $w945
    block $while_949_exit
      loop $while_949_lp
        local.get $w945
        local.get $w940
        i32.lt_s
        if
          local.get $w941
          local.get $w945
          array.get $GcArray_117
          local.set $w946
          local.get $w945
          i32.const 1
          i32.sub
          local.set $w947
          block $while_948_exit
            loop $while_948_lp
              local.get $w947
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w941
                local.get $w947
                array.get $GcArray_117
                local.get $w946
                i32.gt_s
                if (result i32)
                  i32.const -1
                else
                  i32.const 1
                end
                i32.const 0
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w941
                local.get $w947
                i32.const 1
                i32.add
                local.get $w941
                local.get $w947
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w947
                i32.const 1
                i32.sub
                local.set $w947
                br $while_948_lp
              else
                br $while_948_exit
              end
            end
          end
          local.get $w941
          local.get $w947
          i32.const 1
          i32.add
          local.get $w946
          array.set $GcArray_117
          local.get $w945
          i32.const 1
          i32.add
          local.set $w945
          br $while_949_lp
        else
          br $while_949_exit
        end
      end
    end
    local.get $w940
    i32.const 1
    i32.sub
    local.set $w950
    ref.null $ListBase
    local.set $w951
    block $while_952_exit
      loop $while_952_lp
        local.get $w950
        i32.const 0
        i32.ge_s
        if
          local.get $w941
          local.get $w950
          array.get $GcArray_117
          local.get $w951
          struct.new $ListCons_37
          local.set $w951
          local.get $w950
          i32.const 1
          i32.sub
          local.set $w950
          br $while_952_lp
        else
          br $while_952_exit
        end
      end
    end
    local.get $w951
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_583 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_584 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_585 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_1
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListSortBy (result i32) ;; exported as "testListSortBy"
    (local $lo_clo_166 (ref $ClosureBase_40))
    (local $w954 (ref null $ListBase))
    (local $w958 i32)
    (local $w955 (ref null $ListBase))
    (local $w956 i32)
    (local $w959 (ref $GcArray_117))
    (local $w960 (ref $GcArray_117))
    (local $w961 (ref null $ListBase))
    (local $w962 i32)
    (local $w963 i32)
    (local $w966 i32)
    (local $w967 i32)
    (local $w968 i32)
    (local $w969 i32)
    (local $w972 i32)
    (local $w973 (ref null $ListBase))
    ref.func $closure_583
    struct.new $ClosureType_583
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_166
    local.get $lo_clo_166
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 9
    i32.const 2
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w954
    local.get $w954
    local.set $w955
    i32.const 0
    local.set $w956
    block $while_957_exit
      loop $while_957_lp
        local.get $w955
        ref.is_null
        i32.eqz
        if
          local.get $w956
          i32.const 1
          i32.add
          local.set $w956
          local.get $w955
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w955
          br $while_957_lp
        else
          br $while_957_exit
        end
      end
    end
    local.get $w956
    local.set $w958
    i32.const 0
    local.get $w958
    array.new $GcArray_117
    local.set $w959
    i32.const 0
    local.get $w958
    array.new $GcArray_117
    local.set $w960
    local.get $w954
    local.set $w961
    i32.const 0
    local.set $w962
    block $while_965_exit
      loop $while_965_lp
        local.get $w961
        ref.is_null
        i32.eqz
        if
          local.get $w961
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w963
          local.get $w959
          local.get $w962
          local.get $w963
          array.set $GcArray_117
          local.get $w960
          local.get $w962
          local.get $w963
          array.set $GcArray_117
          local.get $w962
          i32.const 1
          i32.add
          local.set $w962
          local.get $w961
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w961
          br $while_965_lp
        else
          br $while_965_exit
        end
      end
    end
    local.get $w962
    drop
    i32.const 1
    local.set $w966
    block $while_971_exit
      loop $while_971_lp
        local.get $w966
        local.get $w958
        i32.lt_s
        if
          local.get $w959
          local.get $w966
          array.get $GcArray_117
          local.set $w967
          local.get $w960
          local.get $w966
          array.get $GcArray_117
          local.set $w968
          local.get $w966
          i32.const 1
          i32.sub
          local.set $w969
          block $while_970_exit
            loop $while_970_lp
              local.get $w969
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w960
                local.get $w969
                array.get $GcArray_117
                local.get $w968
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w959
                local.get $w969
                i32.const 1
                i32.add
                local.get $w959
                local.get $w969
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w960
                local.get $w969
                i32.const 1
                i32.add
                local.get $w960
                local.get $w969
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w969
                i32.const 1
                i32.sub
                local.set $w969
                br $while_970_lp
              else
                br $while_970_exit
              end
            end
          end
          local.get $w959
          local.get $w969
          i32.const 1
          i32.add
          local.get $w967
          array.set $GcArray_117
          local.get $w960
          local.get $w969
          i32.const 1
          i32.add
          local.get $w968
          array.set $GcArray_117
          local.get $w966
          i32.const 1
          i32.add
          local.set $w966
          br $while_971_lp
        else
          br $while_971_exit
        end
      end
    end
    local.get $w958
    i32.const 1
    i32.sub
    local.set $w972
    ref.null $ListBase
    local.set $w973
    block $while_974_exit
      loop $while_974_lp
        local.get $w972
        i32.const 0
        i32.ge_s
        if
          local.get $w959
          local.get $w972
          array.get $GcArray_117
          local.get $w973
          struct.new $ListCons_37
          local.set $w973
          local.get $w972
          i32.const 1
          i32.sub
          local.set $w972
          br $while_974_lp
        else
          br $while_974_exit
        end
      end
    end
    local.get $w973
    local.get $lo_clo_166
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_586 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_586 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w976 (ref null $ListBase))
    (local $w977 i32)
    local.get $list
    local.set $w976
    i32.const 0
    local.set $w977
    block $while_978_exit
      loop $while_978_lp
        local.get $w976
        ref.is_null
        i32.eqz
        if
          local.get $w977
          local.get $w976
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w977
          local.get $w976
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w976
          br $while_978_lp
        else
          br $while_978_exit
        end
      end
    end
    local.get $w977
  )
  (func $testListFlatten (result i32) ;; exported as "testListFlatten"
    (local $lo_clo_167 (ref $ClosureBase_40))
    (local $w980 (ref null $ListBase))
    (local $w981 (ref null $ListBase))
    (local $w983 (ref null $ListBase))
    (local $w984 (ref null $ListBase))
    ref.func $closure_586
    struct.new $ClosureType_587
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_167
    local.get $lo_clo_167
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w980
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w981
    block $while_982_exit
      loop $while_982_lp
        local.get $w980
        ref.is_null
        i32.eqz
        if
          local.get $w980
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w981
          struct.new $ListCons_37
          local.set $w981
          local.get $w980
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w980
          br $while_982_lp
        else
          br $while_982_exit
        end
      end
    end
    local.get $w981
    local.set $w983
    ref.null $ListBase
    local.set $w984
    block $while_985_exit
      loop $while_985_lp
        local.get $w983
        ref.is_null
        i32.eqz
        if
          local.get $w983
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w984
          struct.new $ListCons_37
          local.set $w984
          local.get $w983
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w983
          br $while_985_lp
        else
          br $while_985_exit
        end
      end
    end
    local.get $w984
    local.get $lo_clo_167
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $QuickTestWasmGc_TestsList_EnglishGreeter_Greet (param $this$ (ref $QuickTestWasmGc_TestsList_EnglishGreeter)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_TestsList_EnglishGreeter 0
    array.len
  )
  (func $QuickTestWasmGc_TestsList_EnglishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_TestsList_EnglishGreeter)
    call $QuickTestWasmGc_TestsList_EnglishGreeter_Greet
  )
  (func $QuickTestWasmGc_TestsList_SpanishGreeter_Greet (param $this$ (ref $QuickTestWasmGc_TestsList_SpanishGreeter)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_TestsList_SpanishGreeter 0
    array.len
  )
  (func $QuickTestWasmGc_TestsList_SpanishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_TestsList_SpanishGreeter)
    call $QuickTestWasmGc_TestsList_SpanishGreeter_Greet
  )
  (func $testListZip (result i32) ;; exported as "testListZip"
    (local $xs (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $zipped (ref null $ListBase))
    (local $w987 (ref null $ListBase))
    (local $w988 (ref null $ListBase))
    (local $w989 (ref null $ListBase))
    (local $w991 (ref null $ListBase))
    (local $w992 (ref null $ListBase))
    (local $patternInput (ref $Tuple_105))
    (local $b i32)
    (local $a i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $ys
    local.get $xs
    local.set $w987
    local.get $ys
    local.set $w988
    ref.null $ListBase
    local.set $w989
    block $while_990_exit
      loop $while_990_lp
        local.get $w987
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w988
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w987
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w988
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          struct.new $Tuple_105
          local.get $w989
          struct.new $ListCons_137
          local.set $w989
          local.get $w987
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w987
          local.get $w988
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w988
          br $while_990_lp
        else
          br $while_990_exit
        end
      end
    end
    local.get $w989
    local.set $w991
    ref.null $ListBase
    local.set $w992
    block $while_993_exit
      loop $while_993_lp
        local.get $w991
        ref.is_null
        i32.eqz
        if
          local.get $w991
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 0
          local.get $w992
          struct.new $ListCons_137
          local.set $w992
          local.get $w991
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 1
          local.set $w991
          br $while_993_lp
        else
          br $while_993_exit
        end
      end
    end
    local.get $w992
    local.set $zipped
    local.get $zipped
    ref.cast (ref $ListCons_137)
    struct.get $ListCons_137 0
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_105 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_105 0
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_592 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w995 (ref null $ListBase))
    (local $w996 i32)
    local.get $list
    local.set $w995
    i32.const 0
    local.set $w996
    block $while_997_exit
      loop $while_997_lp
        local.get $w995
        ref.is_null
        i32.eqz
        if
          local.get $w996
          i32.const 1
          i32.add
          local.set $w996
          local.get $w995
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 1
          local.set $w995
          br $while_997_lp
        else
          br $while_997_exit
        end
      end
    end
    local.get $w996
  )
  (func $testListZipLen (result i32) ;; exported as "testListZipLen"
    (local $xs (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $lo_clo_168 (ref $ClosureBase_40))
    (local $w999 (ref null $ListBase))
    (local $w1000 (ref null $ListBase))
    (local $w1001 (ref null $ListBase))
    (local $w1003 (ref null $ListBase))
    (local $w1004 (ref null $ListBase))
    i32.const 97
    i32.const 98
    i32.const 99
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $ys
    ref.func $closure_592
    struct.new $ClosureType_592
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_168
    local.get $lo_clo_168
    local.get $xs
    local.set $w999
    local.get $ys
    local.set $w1000
    ref.null $ListBase
    local.set $w1001
    block $while_1002_exit
      loop $while_1002_lp
        local.get $w999
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w1000
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w999
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1000
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          struct.new $Tuple_105
          local.get $w1001
          struct.new $ListCons_137
          local.set $w1001
          local.get $w999
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w999
          local.get $w1000
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1000
          br $while_1002_lp
        else
          br $while_1002_exit
        end
      end
    end
    local.get $w1001
    local.set $w1003
    ref.null $ListBase
    local.set $w1004
    block $while_1005_exit
      loop $while_1005_lp
        local.get $w1003
        ref.is_null
        i32.eqz
        if
          local.get $w1003
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 0
          local.get $w1004
          struct.new $ListCons_137
          local.set $w1004
          local.get $w1003
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 1
          local.set $w1003
          br $while_1005_lp
        else
          br $while_1005_exit
        end
      end
    end
    local.get $w1004
    local.get $lo_clo_168
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_593 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_593 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1007 (ref null $ListBase))
    (local $w1008 i32)
    local.get $list
    local.set $w1007
    i32.const 0
    local.set $w1008
    block $while_1009_exit
      loop $while_1009_lp
        local.get $w1007
        ref.is_null
        i32.eqz
        if
          local.get $w1008
          local.get $w1007
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w1008
          local.get $w1007
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1007
          br $while_1009_lp
        else
          br $while_1009_exit
        end
      end
    end
    local.get $w1008
  )
  (func $closure_595 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_595))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_595)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_595 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_595 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_595
    local.get $a
    struct.new $ClosureType_595
  )
  (func $testListMap2Sum (result i32) ;; exported as "testListMap2Sum"
    (local $lo_clo_169 (ref $ClosureBase_40))
    (local $w1011 (ref null $ListBase))
    (local $w1012 (ref null $ListBase))
    (local $w1013 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w1015 (ref null $ListBase))
    (local $w1016 (ref null $ListBase))
    ref.func $closure_593
    struct.new $ClosureType_594
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_169
    local.get $lo_clo_169
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1011
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1012
    ref.null $ListBase
    local.set $w1013
    block $while_1014_exit
      loop $while_1014_lp
        local.get $w1011
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w1012
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w1011
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $a
          local.get $w1012
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $b
          local.get $a
          local.get $b
          i32.add
          local.get $w1013
          struct.new $ListCons_37
          local.set $w1013
          local.get $w1011
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1011
          local.get $w1012
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1012
          br $while_1014_lp
        else
          br $while_1014_exit
        end
      end
    end
    local.get $w1013
    local.set $w1015
    ref.null $ListBase
    local.set $w1016
    block $while_1017_exit
      loop $while_1017_lp
        local.get $w1015
        ref.is_null
        i32.eqz
        if
          local.get $w1015
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1016
          struct.new $ListCons_37
          local.set $w1016
          local.get $w1015
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1015
          br $while_1017_lp
        else
          br $while_1017_exit
        end
      end
    end
    local.get $w1016
    local.get $lo_clo_169
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_597 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_598 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_598))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_598)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_598 1
    local.set $a
    local.get $a
    local.get $b
    i32.mul
  )
  (func $closure_598 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_598
    local.get $a
    struct.new $ClosureType_598
  )
  (func $testListMap2Head (result i32) ;; exported as "testListMap2Head"
    (local $lo_clo_170 (ref $ClosureBase_40))
    (local $w1019 (ref null $ListBase))
    (local $w1020 (ref null $ListBase))
    (local $w1021 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w1023 (ref null $ListBase))
    (local $w1024 (ref null $ListBase))
    ref.func $closure_597
    struct.new $ClosureType_597
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_170
    local.get $lo_clo_170
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1019
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1020
    ref.null $ListBase
    local.set $w1021
    block $while_1022_exit
      loop $while_1022_lp
        local.get $w1019
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w1020
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w1019
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $a
          local.get $w1020
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          local.get $w1021
          struct.new $ListCons_37
          local.set $w1021
          local.get $w1019
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1019
          local.get $w1020
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1020
          br $while_1022_lp
        else
          br $while_1022_exit
        end
      end
    end
    local.get $w1021
    local.set $w1023
    ref.null $ListBase
    local.set $w1024
    block $while_1025_exit
      loop $while_1025_lp
        local.get $w1023
        ref.is_null
        i32.eqz
        if
          local.get $w1023
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1024
          struct.new $ListCons_37
          local.set $w1024
          local.get $w1023
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1023
          br $while_1025_lp
        else
          br $while_1025_exit
        end
      end
    end
    local.get $w1024
    local.get $lo_clo_170
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_601 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionCounts (result i32) ;; exported as "testListPartitionCounts"
    (local $patternInput (ref $Tuple_600))
    (local $w1027 (ref null $ListBase))
    (local $w1028 (ref null $ListBase))
    (local $w1029 (ref null $ListBase))
    (local $w1030 i32)
    (local $w1032 (ref null $ListBase))
    (local $w1033 (ref null $ListBase))
    (local $w1035 (ref null $ListBase))
    (local $w1036 (ref null $ListBase))
    (local $odds (ref null $ListBase))
    (local $evens (ref null $ListBase))
    (local $w1039 (ref null $ListBase))
    (local $w1040 i32)
    (local $w1043 (ref null $ListBase))
    (local $w1044 i32)
    ref.null $ListBase
    local.set $w1027
    ref.null $ListBase
    local.set $w1028
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1029
    block $while_1031_exit
      loop $while_1031_lp
        local.get $w1029
        ref.is_null
        i32.eqz
        if
          local.get $w1029
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w1030
          local.get $w1030
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w1030
            local.get $w1027
            struct.new $ListCons_37
            local.set $w1027
          else
            local.get $w1030
            local.get $w1028
            struct.new $ListCons_37
            local.set $w1028
          end
          local.get $w1029
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1029
          br $while_1031_lp
        else
          br $while_1031_exit
        end
      end
    end
    local.get $w1027
    local.set $w1032
    ref.null $ListBase
    local.set $w1033
    block $while_1034_exit
      loop $while_1034_lp
        local.get $w1032
        ref.is_null
        i32.eqz
        if
          local.get $w1032
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1033
          struct.new $ListCons_37
          local.set $w1033
          local.get $w1032
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1032
          br $while_1034_lp
        else
          br $while_1034_exit
        end
      end
    end
    local.get $w1033
    local.get $w1028
    local.set $w1035
    ref.null $ListBase
    local.set $w1036
    block $while_1037_exit
      loop $while_1037_lp
        local.get $w1035
        ref.is_null
        i32.eqz
        if
          local.get $w1035
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1036
          struct.new $ListCons_37
          local.set $w1036
          local.get $w1035
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1035
          br $while_1037_lp
        else
          br $while_1037_exit
        end
      end
    end
    local.get $w1036
    struct.new $Tuple_600
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_600 1
    local.set $odds
    local.get $patternInput
    struct.get $Tuple_600 0
    local.set $evens
    local.get $evens
    local.set $w1039
    i32.const 0
    local.set $w1040
    block $while_1041_exit
      loop $while_1041_lp
        local.get $w1039
        ref.is_null
        i32.eqz
        if
          local.get $w1040
          i32.const 1
          i32.add
          local.set $w1040
          local.get $w1039
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1039
          br $while_1041_lp
        else
          br $while_1041_exit
        end
      end
    end
    local.get $w1040
    i32.const 10
    i32.mul
    local.get $odds
    local.set $w1043
    i32.const 0
    local.set $w1044
    block $while_1045_exit
      loop $while_1045_lp
        local.get $w1043
        ref.is_null
        i32.eqz
        if
          local.get $w1044
          i32.const 1
          i32.add
          local.set $w1044
          local.get $w1043
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1043
          br $while_1045_lp
        else
          br $while_1045_exit
        end
      end
    end
    local.get $w1044
    i32.add
  )
  (func $closure_602 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_603 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionEvens (result i32) ;; exported as "testListPartitionEvens"
    (local $patternInput (ref $Tuple_600))
    (local $w1047 (ref null $ListBase))
    (local $w1048 (ref null $ListBase))
    (local $w1049 (ref null $ListBase))
    (local $w1050 i32)
    (local $w1052 (ref null $ListBase))
    (local $w1053 (ref null $ListBase))
    (local $w1055 (ref null $ListBase))
    (local $w1056 (ref null $ListBase))
    (local $evens (ref null $ListBase))
    (local $w1059 (ref null $ListBase))
    (local $w1060 i32)
    ref.null $ListBase
    local.set $w1047
    ref.null $ListBase
    local.set $w1048
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1049
    block $while_1051_exit
      loop $while_1051_lp
        local.get $w1049
        ref.is_null
        i32.eqz
        if
          local.get $w1049
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w1050
          local.get $w1050
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w1050
            local.get $w1047
            struct.new $ListCons_37
            local.set $w1047
          else
            local.get $w1050
            local.get $w1048
            struct.new $ListCons_37
            local.set $w1048
          end
          local.get $w1049
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1049
          br $while_1051_lp
        else
          br $while_1051_exit
        end
      end
    end
    local.get $w1047
    local.set $w1052
    ref.null $ListBase
    local.set $w1053
    block $while_1054_exit
      loop $while_1054_lp
        local.get $w1052
        ref.is_null
        i32.eqz
        if
          local.get $w1052
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1053
          struct.new $ListCons_37
          local.set $w1053
          local.get $w1052
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1052
          br $while_1054_lp
        else
          br $while_1054_exit
        end
      end
    end
    local.get $w1053
    local.get $w1048
    local.set $w1055
    ref.null $ListBase
    local.set $w1056
    block $while_1057_exit
      loop $while_1057_lp
        local.get $w1055
        ref.is_null
        i32.eqz
        if
          local.get $w1055
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1056
          struct.new $ListCons_37
          local.set $w1056
          local.get $w1055
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1055
          br $while_1057_lp
        else
          br $while_1057_exit
        end
      end
    end
    local.get $w1056
    struct.new $Tuple_600
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_600 0
    local.set $evens
    local.get $evens
    local.set $w1059
    i32.const 0
    local.set $w1060
    block $while_1061_exit
      loop $while_1061_lp
        local.get $w1059
        ref.is_null
        i32.eqz
        if
          local.get $w1060
          local.get $w1059
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w1060
          local.get $w1059
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1059
          br $while_1061_lp
        else
          br $while_1061_exit
        end
      end
    end
    local.get $w1060
  )
  (func $closure_604 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_605 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionOdds (result i32) ;; exported as "testListPartitionOdds"
    (local $patternInput (ref $Tuple_600))
    (local $w1063 (ref null $ListBase))
    (local $w1064 (ref null $ListBase))
    (local $w1065 (ref null $ListBase))
    (local $w1066 i32)
    (local $w1068 (ref null $ListBase))
    (local $w1069 (ref null $ListBase))
    (local $w1071 (ref null $ListBase))
    (local $w1072 (ref null $ListBase))
    (local $odds (ref null $ListBase))
    (local $w1075 (ref null $ListBase))
    (local $w1076 i32)
    ref.null $ListBase
    local.set $w1063
    ref.null $ListBase
    local.set $w1064
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1065
    block $while_1067_exit
      loop $while_1067_lp
        local.get $w1065
        ref.is_null
        i32.eqz
        if
          local.get $w1065
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w1066
          local.get $w1066
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w1066
            local.get $w1063
            struct.new $ListCons_37
            local.set $w1063
          else
            local.get $w1066
            local.get $w1064
            struct.new $ListCons_37
            local.set $w1064
          end
          local.get $w1065
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1065
          br $while_1067_lp
        else
          br $while_1067_exit
        end
      end
    end
    local.get $w1063
    local.set $w1068
    ref.null $ListBase
    local.set $w1069
    block $while_1070_exit
      loop $while_1070_lp
        local.get $w1068
        ref.is_null
        i32.eqz
        if
          local.get $w1068
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1069
          struct.new $ListCons_37
          local.set $w1069
          local.get $w1068
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1068
          br $while_1070_lp
        else
          br $while_1070_exit
        end
      end
    end
    local.get $w1069
    local.get $w1064
    local.set $w1071
    ref.null $ListBase
    local.set $w1072
    block $while_1073_exit
      loop $while_1073_lp
        local.get $w1071
        ref.is_null
        i32.eqz
        if
          local.get $w1071
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1072
          struct.new $ListCons_37
          local.set $w1072
          local.get $w1071
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1071
          br $while_1073_lp
        else
          br $while_1073_exit
        end
      end
    end
    local.get $w1072
    struct.new $Tuple_600
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_600 1
    local.set $odds
    local.get $odds
    local.set $w1075
    i32.const 0
    local.set $w1076
    block $while_1077_exit
      loop $while_1077_lp
        local.get $w1075
        ref.is_null
        i32.eqz
        if
          local.get $w1076
          local.get $w1075
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w1076
          local.get $w1075
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1075
          br $while_1077_lp
        else
          br $while_1077_exit
        end
      end
    end
    local.get $w1076
  )
  (func $closure_606 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionEmpty (result i32) ;; exported as "testListPartitionEmpty"
    (local $patternInput (ref $Tuple_600))
    (local $w1079 (ref null $ListBase))
    (local $w1080 (ref null $ListBase))
    (local $w1081 (ref null $ListBase))
    (local $w1082 i32)
    (local $w1084 (ref null $ListBase))
    (local $w1085 (ref null $ListBase))
    (local $w1087 (ref null $ListBase))
    (local $w1088 (ref null $ListBase))
    (local $b (ref null $ListBase))
    (local $a (ref null $ListBase))
    (local $w1091 (ref null $ListBase))
    (local $w1092 i32)
    (local $w1095 (ref null $ListBase))
    (local $w1096 i32)
    ref.null $ListBase
    local.set $w1079
    ref.null $ListBase
    local.set $w1080
    ref.null $ListBase
    local.set $w1081
    block $while_1083_exit
      loop $while_1083_lp
        local.get $w1081
        ref.is_null
        i32.eqz
        if
          local.get $w1081
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w1082
          local.get $w1082
          i32.const 0
          i32.gt_s
          if
            local.get $w1082
            local.get $w1079
            struct.new $ListCons_37
            local.set $w1079
          else
            local.get $w1082
            local.get $w1080
            struct.new $ListCons_37
            local.set $w1080
          end
          local.get $w1081
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1081
          br $while_1083_lp
        else
          br $while_1083_exit
        end
      end
    end
    local.get $w1079
    local.set $w1084
    ref.null $ListBase
    local.set $w1085
    block $while_1086_exit
      loop $while_1086_lp
        local.get $w1084
        ref.is_null
        i32.eqz
        if
          local.get $w1084
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1085
          struct.new $ListCons_37
          local.set $w1085
          local.get $w1084
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1084
          br $while_1086_lp
        else
          br $while_1086_exit
        end
      end
    end
    local.get $w1085
    local.get $w1080
    local.set $w1087
    ref.null $ListBase
    local.set $w1088
    block $while_1089_exit
      loop $while_1089_lp
        local.get $w1087
        ref.is_null
        i32.eqz
        if
          local.get $w1087
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1088
          struct.new $ListCons_37
          local.set $w1088
          local.get $w1087
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1087
          br $while_1089_lp
        else
          br $while_1089_exit
        end
      end
    end
    local.get $w1088
    struct.new $Tuple_600
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_600 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_600 0
    local.set $a
    local.get $a
    local.set $w1091
    i32.const 0
    local.set $w1092
    block $while_1093_exit
      loop $while_1093_lp
        local.get $w1091
        ref.is_null
        i32.eqz
        if
          local.get $w1092
          i32.const 1
          i32.add
          local.set $w1092
          local.get $w1091
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1091
          br $while_1093_lp
        else
          br $while_1093_exit
        end
      end
    end
    local.get $w1092
    local.get $b
    local.set $w1095
    i32.const 0
    local.set $w1096
    block $while_1097_exit
      loop $while_1097_lp
        local.get $w1095
        ref.is_null
        i32.eqz
        if
          local.get $w1096
          i32.const 1
          i32.add
          local.set $w1096
          local.get $w1095
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1095
          br $while_1097_lp
        else
          br $while_1097_exit
        end
      end
    end
    local.get $w1096
    i32.add
  )
  (func $closure_607 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionAllTrue (result i32) ;; exported as "testListPartitionAllTrue"
    (local $patternInput (ref $Tuple_600))
    (local $w1099 (ref null $ListBase))
    (local $w1100 (ref null $ListBase))
    (local $w1101 (ref null $ListBase))
    (local $w1102 i32)
    (local $w1104 (ref null $ListBase))
    (local $w1105 (ref null $ListBase))
    (local $w1107 (ref null $ListBase))
    (local $w1108 (ref null $ListBase))
    (local $b (ref null $ListBase))
    (local $a (ref null $ListBase))
    (local $w1111 (ref null $ListBase))
    (local $w1112 i32)
    (local $w1115 (ref null $ListBase))
    (local $w1116 i32)
    ref.null $ListBase
    local.set $w1099
    ref.null $ListBase
    local.set $w1100
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1101
    block $while_1103_exit
      loop $while_1103_lp
        local.get $w1101
        ref.is_null
        i32.eqz
        if
          local.get $w1101
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w1102
          local.get $w1102
          i32.const 0
          i32.gt_s
          if
            local.get $w1102
            local.get $w1099
            struct.new $ListCons_37
            local.set $w1099
          else
            local.get $w1102
            local.get $w1100
            struct.new $ListCons_37
            local.set $w1100
          end
          local.get $w1101
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1101
          br $while_1103_lp
        else
          br $while_1103_exit
        end
      end
    end
    local.get $w1099
    local.set $w1104
    ref.null $ListBase
    local.set $w1105
    block $while_1106_exit
      loop $while_1106_lp
        local.get $w1104
        ref.is_null
        i32.eqz
        if
          local.get $w1104
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1105
          struct.new $ListCons_37
          local.set $w1105
          local.get $w1104
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1104
          br $while_1106_lp
        else
          br $while_1106_exit
        end
      end
    end
    local.get $w1105
    local.get $w1100
    local.set $w1107
    ref.null $ListBase
    local.set $w1108
    block $while_1109_exit
      loop $while_1109_lp
        local.get $w1107
        ref.is_null
        i32.eqz
        if
          local.get $w1107
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1108
          struct.new $ListCons_37
          local.set $w1108
          local.get $w1107
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1107
          br $while_1109_lp
        else
          br $while_1109_exit
        end
      end
    end
    local.get $w1108
    struct.new $Tuple_600
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_600 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_600 0
    local.set $a
    local.get $a
    local.set $w1111
    i32.const 0
    local.set $w1112
    block $while_1113_exit
      loop $while_1113_lp
        local.get $w1111
        ref.is_null
        i32.eqz
        if
          local.get $w1112
          i32.const 1
          i32.add
          local.set $w1112
          local.get $w1111
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1111
          br $while_1113_lp
        else
          br $while_1113_exit
        end
      end
    end
    local.get $w1112
    i32.const 10
    i32.mul
    local.get $b
    local.set $w1115
    i32.const 0
    local.set $w1116
    block $while_1117_exit
      loop $while_1117_lp
        local.get $w1115
        ref.is_null
        i32.eqz
        if
          local.get $w1116
          i32.const 1
          i32.add
          local.set $w1116
          local.get $w1115
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1115
          br $while_1117_lp
        else
          br $while_1117_exit
        end
      end
    end
    local.get $w1116
    i32.add
  )
  (func $closure_608 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionOrder (result i32) ;; exported as "testListPartitionOrder"
    (local $patternInput (ref $Tuple_600))
    (local $w1119 (ref null $ListBase))
    (local $w1120 (ref null $ListBase))
    (local $w1121 (ref null $ListBase))
    (local $w1122 i32)
    (local $w1124 (ref null $ListBase))
    (local $w1125 (ref null $ListBase))
    (local $w1127 (ref null $ListBase))
    (local $w1128 (ref null $ListBase))
    (local $evens (ref null $ListBase))
    ref.null $ListBase
    local.set $w1119
    ref.null $ListBase
    local.set $w1120
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1121
    block $while_1123_exit
      loop $while_1123_lp
        local.get $w1121
        ref.is_null
        i32.eqz
        if
          local.get $w1121
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.set $w1122
          local.get $w1122
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w1122
            local.get $w1119
            struct.new $ListCons_37
            local.set $w1119
          else
            local.get $w1122
            local.get $w1120
            struct.new $ListCons_37
            local.set $w1120
          end
          local.get $w1121
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1121
          br $while_1123_lp
        else
          br $while_1123_exit
        end
      end
    end
    local.get $w1119
    local.set $w1124
    ref.null $ListBase
    local.set $w1125
    block $while_1126_exit
      loop $while_1126_lp
        local.get $w1124
        ref.is_null
        i32.eqz
        if
          local.get $w1124
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1125
          struct.new $ListCons_37
          local.set $w1125
          local.get $w1124
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1124
          br $while_1126_lp
        else
          br $while_1126_exit
        end
      end
    end
    local.get $w1125
    local.get $w1120
    local.set $w1127
    ref.null $ListBase
    local.set $w1128
    block $while_1129_exit
      loop $while_1129_lp
        local.get $w1127
        ref.is_null
        i32.eqz
        if
          local.get $w1127
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1128
          struct.new $ListCons_37
          local.set $w1128
          local.get $w1127
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1127
          br $while_1129_lp
        else
          br $while_1129_exit
        end
      end
    end
    local.get $w1128
    struct.new $Tuple_600
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_600 0
    local.set $evens
    local.get $evens
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_609 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testListSortIntAsc (result i32) ;; exported as "testListSortIntAsc"
    (local $sorted (ref null $ListBase))
    (local $w1131 (ref null $ListBase))
    (local $w1135 i32)
    (local $w1132 (ref null $ListBase))
    (local $w1133 i32)
    (local $w1136 (ref $GcArray_117))
    (local $w1137 (ref null $ListBase))
    (local $w1138 i32)
    (local $w1140 i32)
    (local $w1141 i32)
    (local $w1142 i32)
    (local $w1145 i32)
    (local $w1146 (ref null $ListBase))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 9
    i32.const 2
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1131
    local.get $w1131
    local.set $w1132
    i32.const 0
    local.set $w1133
    block $while_1134_exit
      loop $while_1134_lp
        local.get $w1132
        ref.is_null
        i32.eqz
        if
          local.get $w1133
          i32.const 1
          i32.add
          local.set $w1133
          local.get $w1132
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1132
          br $while_1134_lp
        else
          br $while_1134_exit
        end
      end
    end
    local.get $w1133
    local.set $w1135
    i32.const 0
    local.get $w1135
    array.new $GcArray_117
    local.set $w1136
    local.get $w1131
    local.set $w1137
    i32.const 0
    local.set $w1138
    block $while_1139_exit
      loop $while_1139_lp
        local.get $w1137
        ref.is_null
        i32.eqz
        if
          local.get $w1136
          local.get $w1138
          local.get $w1137
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          array.set $GcArray_117
          local.get $w1138
          i32.const 1
          i32.add
          local.set $w1138
          local.get $w1137
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1137
          br $while_1139_lp
        else
          br $while_1139_exit
        end
      end
    end
    local.get $w1138
    drop
    i32.const 1
    local.set $w1140
    block $while_1144_exit
      loop $while_1144_lp
        local.get $w1140
        local.get $w1135
        i32.lt_s
        if
          local.get $w1136
          local.get $w1140
          array.get $GcArray_117
          local.set $w1141
          local.get $w1140
          i32.const 1
          i32.sub
          local.set $w1142
          block $while_1143_exit
            loop $while_1143_lp
              local.get $w1142
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1136
                local.get $w1142
                array.get $GcArray_117
                local.get $w1141
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  i32.const 1
                end
                i32.const 0
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w1136
                local.get $w1142
                i32.const 1
                i32.add
                local.get $w1136
                local.get $w1142
                array.get $GcArray_117
                array.set $GcArray_117
                local.get $w1142
                i32.const 1
                i32.sub
                local.set $w1142
                br $while_1143_lp
              else
                br $while_1143_exit
              end
            end
          end
          local.get $w1136
          local.get $w1142
          i32.const 1
          i32.add
          local.get $w1141
          array.set $GcArray_117
          local.get $w1140
          i32.const 1
          i32.add
          local.set $w1140
          br $while_1144_lp
        else
          br $while_1144_exit
        end
      end
    end
    local.get $w1135
    i32.const 1
    i32.sub
    local.set $w1145
    ref.null $ListBase
    local.set $w1146
    block $while_1147_exit
      loop $while_1147_lp
        local.get $w1145
        i32.const 0
        i32.ge_s
        if
          local.get $w1136
          local.get $w1145
          array.get $GcArray_117
          local.get $w1146
          struct.new $ListCons_37
          local.set $w1146
          local.get $w1145
          i32.const 1
          i32.sub
          local.set $w1145
          br $while_1147_lp
        else
          br $while_1147_exit
        end
      end
    end
    local.get $w1146
    local.set $sorted
    local.get $sorted
    ref.cast (ref $ListCons_37)
    struct.get $ListCons_37 0
  )
  (func $closure_611 (param $self (ref $AnyFn)) (param $x (ref $WasmStr)) (param $y (ref $WasmStr)) (result i32)
    local.get $x
    local.get $y
    call $strCompare
  )
  (func $testListSortStrAsc (result i32) ;; exported as "testListSortStrAsc"
    (local $sorted (ref null $ListBase))
    (local $w1149 (ref null $ListBase))
    (local $w1153 i32)
    (local $w1150 (ref null $ListBase))
    (local $w1151 i32)
    (local $w1154 (ref $GcArray_614))
    (local $w1155 (ref null $ListBase))
    (local $w1156 i32)
    (local $w1158 i32)
    (local $w1159 (ref $WasmStr))
    (local $w1160 i32)
    (local $w1163 i32)
    (local $w1164 (ref null $ListBase))
    i32.const 99
    i32.const 104
    i32.const 101
    i32.const 114
    i32.const 114
    i32.const 121
    array.new_fixed $WasmStr 6
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 5
    i32.const 98
    i32.const 97
    i32.const 110
    i32.const 97
    i32.const 110
    i32.const 97
    array.new_fixed $WasmStr 6
    ref.null $ListBase
    struct.new $ListCons_610
    struct.new $ListCons_610
    struct.new $ListCons_610
    local.set $w1149
    local.get $w1149
    local.set $w1150
    i32.const 0
    local.set $w1151
    block $while_1152_exit
      loop $while_1152_lp
        local.get $w1150
        ref.is_null
        i32.eqz
        if
          local.get $w1151
          i32.const 1
          i32.add
          local.set $w1151
          local.get $w1150
          ref.cast (ref $ListCons_610)
          struct.get $ListCons_610 1
          local.set $w1150
          br $while_1152_lp
        else
          br $while_1152_exit
        end
      end
    end
    local.get $w1151
    local.set $w1153
    ref.null $WasmStr
    local.get $w1153
    array.new $GcArray_614
    local.set $w1154
    local.get $w1149
    local.set $w1155
    i32.const 0
    local.set $w1156
    block $while_1157_exit
      loop $while_1157_lp
        local.get $w1155
        ref.is_null
        i32.eqz
        if
          local.get $w1154
          local.get $w1156
          local.get $w1155
          ref.cast (ref $ListCons_610)
          struct.get $ListCons_610 0
          array.set $GcArray_614
          local.get $w1156
          i32.const 1
          i32.add
          local.set $w1156
          local.get $w1155
          ref.cast (ref $ListCons_610)
          struct.get $ListCons_610 1
          local.set $w1155
          br $while_1157_lp
        else
          br $while_1157_exit
        end
      end
    end
    local.get $w1156
    drop
    i32.const 1
    local.set $w1158
    block $while_1162_exit
      loop $while_1162_lp
        local.get $w1158
        local.get $w1153
        i32.lt_s
        if
          local.get $w1154
          local.get $w1158
          array.get $GcArray_614
          ref.cast (ref $WasmStr)
          local.set $w1159
          local.get $w1158
          i32.const 1
          i32.sub
          local.set $w1160
          block $while_1161_exit
            loop $while_1161_lp
              local.get $w1160
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1154
                local.get $w1160
                array.get $GcArray_614
                ref.cast (ref $WasmStr)
                local.get $w1159
                call $strCompare
                i32.const 0
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  i32.const 1
                end
                i32.const 0
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w1154
                local.get $w1160
                i32.const 1
                i32.add
                local.get $w1154
                local.get $w1160
                array.get $GcArray_614
                ref.cast (ref $WasmStr)
                array.set $GcArray_614
                local.get $w1160
                i32.const 1
                i32.sub
                local.set $w1160
                br $while_1161_lp
              else
                br $while_1161_exit
              end
            end
          end
          local.get $w1154
          local.get $w1160
          i32.const 1
          i32.add
          local.get $w1159
          array.set $GcArray_614
          local.get $w1158
          i32.const 1
          i32.add
          local.set $w1158
          br $while_1162_lp
        else
          br $while_1162_exit
        end
      end
    end
    local.get $w1153
    i32.const 1
    i32.sub
    local.set $w1163
    ref.null $ListBase
    local.set $w1164
    block $while_1165_exit
      loop $while_1165_lp
        local.get $w1163
        i32.const 0
        i32.ge_s
        if
          local.get $w1154
          local.get $w1163
          array.get $GcArray_614
          ref.cast (ref $WasmStr)
          local.get $w1164
          struct.new $ListCons_610
          local.set $w1164
          local.get $w1163
          i32.const 1
          i32.sub
          local.set $w1163
          br $while_1165_lp
        else
          br $while_1165_exit
        end
      end
    end
    local.get $w1164
    local.set $sorted
    local.get $sorted
    ref.cast (ref $ListCons_610)
    struct.get $ListCons_610 0
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 5
    call $strEq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_615 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_615 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1167 (ref null $ListBase))
    (local $w1168 i32)
    local.get $list
    local.set $w1167
    i32.const 0
    local.set $w1168
    block $while_1169_exit
      loop $while_1169_lp
        local.get $w1167
        ref.is_null
        i32.eqz
        if
          local.get $w1168
          local.get $w1167
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w1168
          local.get $w1167
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1167
          br $while_1169_lp
        else
          br $while_1169_exit
        end
      end
    end
    local.get $w1168
  )
  (func $testSeqToList (result i32) ;; exported as "testSeqToList"
    (local $xs (ref null $ListBase))
    (local $lo_clo_171 (ref $ClosureBase_40))
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $xs
    ref.func $closure_615
    struct.new $ClosureType_616
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_171
    local.get $lo_clo_171
    local.get $xs
    local.get $lo_clo_171
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_617 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_618 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListUnzip (result i32) ;; exported as "testListUnzip"
    (local $pairs (ref null $ListBase))
    (local $patternInput (ref $Tuple_600))
    (local $w1171 (ref null $ListBase))
    (local $w1176 (ref null $ListBase))
    (local $w1172 (ref null $ListBase))
    (local $w1173 (ref null $ListBase))
    (local $w1174 (ref $Tuple_105))
    (local $w1177 (ref null $ListBase))
    (local $w1179 (ref null $ListBase))
    (local $w1180 (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $xs (ref null $ListBase))
    (local $w1183 (ref null $ListBase))
    (local $w1184 i32)
    (local $w1187 (ref null $ListBase))
    (local $w1188 i32)
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    local.set $pairs
    ref.null $ListBase
    local.set $w1171
    local.get $pairs
    local.set $w1172
    ref.null $ListBase
    local.set $w1173
    block $while_1175_exit
      loop $while_1175_lp
        local.get $w1172
        ref.is_null
        i32.eqz
        if
          local.get $w1172
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 0
          local.set $w1174
          local.get $w1174
          struct.get $Tuple_105 1
          local.get $w1171
          struct.new $ListCons_37
          local.set $w1171
          local.get $w1174
          struct.get $Tuple_105 0
          local.get $w1173
          struct.new $ListCons_37
          local.set $w1173
          local.get $w1172
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 1
          local.set $w1172
          br $while_1175_lp
        else
          br $while_1175_exit
        end
      end
    end
    local.get $w1173
    local.set $w1176
    ref.null $ListBase
    local.set $w1177
    block $while_1178_exit
      loop $while_1178_lp
        local.get $w1176
        ref.is_null
        i32.eqz
        if
          local.get $w1176
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1177
          struct.new $ListCons_37
          local.set $w1177
          local.get $w1176
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1176
          br $while_1178_lp
        else
          br $while_1178_exit
        end
      end
    end
    local.get $w1177
    local.get $w1171
    local.set $w1179
    ref.null $ListBase
    local.set $w1180
    block $while_1181_exit
      loop $while_1181_lp
        local.get $w1179
        ref.is_null
        i32.eqz
        if
          local.get $w1179
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          local.get $w1180
          struct.new $ListCons_37
          local.set $w1180
          local.get $w1179
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1179
          br $while_1181_lp
        else
          br $while_1181_exit
        end
      end
    end
    local.get $w1180
    struct.new $Tuple_600
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_600 1
    local.set $ys
    local.get $patternInput
    struct.get $Tuple_600 0
    local.set $xs
    local.get $xs
    local.set $w1183
    i32.const 0
    local.set $w1184
    block $while_1185_exit
      loop $while_1185_lp
        local.get $w1183
        ref.is_null
        i32.eqz
        if
          local.get $w1184
          local.get $w1183
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w1184
          local.get $w1183
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1183
          br $while_1185_lp
        else
          br $while_1185_exit
        end
      end
    end
    local.get $w1184
    local.get $ys
    local.set $w1187
    i32.const 0
    local.set $w1188
    block $while_1189_exit
      loop $while_1189_lp
        local.get $w1187
        ref.is_null
        i32.eqz
        if
          local.get $w1188
          local.get $w1187
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 0
          i32.add
          local.set $w1188
          local.get $w1187
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1187
          br $while_1189_lp
        else
          br $while_1189_exit
        end
      end
    end
    local.get $w1188
    i32.add
  )
  (func $closure_619 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_620 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_620 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testListGroupBy (result i32) ;; exported as "testListGroupBy"
    (local $groups (ref null $ListBase))
    (local $lo_clo_172 (ref $ClosureBase_44))
    (local $projection (ref $ClosureType_619))
    (local $w1191 (ref null $ListBase))
    (local $w1192 i32)
    ref.func $closure_619
    struct.new $ClosureType_619
    local.set $projection
    ref.func $closure_620
    local.get $projection
    struct.new $ClosureType_621
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_172
    local.get $lo_clo_172
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_172
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $groups
    local.get $groups
    local.set $w1191
    i32.const 0
    local.set $w1192
    block $while_1193_exit
      loop $while_1193_lp
        local.get $w1191
        ref.is_null
        i32.eqz
        if
          local.get $w1192
          i32.const 1
          i32.add
          local.set $w1192
          local.get $w1191
          ref.cast (ref $ListCons_283)
          struct.get $ListCons_283 1
          local.set $w1191
          br $while_1193_lp
        else
          br $while_1193_exit
        end
      end
    end
    local.get $w1192
  )
  (func $evalExpr (param $_arg (ref $QuickTestWasmGc_TestsList_MathExpr)) (result i32) ;; exported as "evalExpr"
    (local $b (ref $QuickTestWasmGc_TestsList_MathExpr))
    (local $a (ref $QuickTestWasmGc_TestsList_MathExpr))
    (local $b_1 (ref $QuickTestWasmGc_TestsList_MathExpr))
    (local $a_1 (ref $QuickTestWasmGc_TestsList_MathExpr))
    local.get $_arg
    struct.get $QuickTestWasmGc_TestsList_MathExpr 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $_arg
      ref.cast (ref $QuickTestWasmGc_TestsList_MathExpr#1)
      struct.get $QuickTestWasmGc_TestsList_MathExpr#1 2
      local.set $b
      local.get $_arg
      ref.cast (ref $QuickTestWasmGc_TestsList_MathExpr#1)
      struct.get $QuickTestWasmGc_TestsList_MathExpr#1 1
      local.set $a
      local.get $a
      call $evalExpr
      local.get $b
      call $evalExpr
      i32.add
    else
      local.get $_arg
      struct.get $QuickTestWasmGc_TestsList_MathExpr 0
      i32.const 2
      i32.eq
      if (result i32)
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_TestsList_MathExpr#2)
        struct.get $QuickTestWasmGc_TestsList_MathExpr#2 2
        local.set $b_1
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_TestsList_MathExpr#2)
        struct.get $QuickTestWasmGc_TestsList_MathExpr#2 1
        local.set $a_1
        local.get $a_1
        call $evalExpr
        local.get $b_1
        call $evalExpr
        i32.mul
      else
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_TestsList_MathExpr#0)
        struct.get $QuickTestWasmGc_TestsList_MathExpr#0 1
      end
    end
  )
  (func $closure_626 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w1195 (ref null $ListBase))
    (local $w1196 i32)
    local.get $list_1
    local.set $w1195
    i32.const 0
    local.set $w1196
    block $while_1197_exit
      loop $while_1197_lp
        local.get $w1195
        ref.is_null
        i32.eqz
        if
          local.get $w1196
          i32.const 1
          i32.add
          local.set $w1196
          local.get $w1195
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1195
          br $while_1197_lp
        else
          br $while_1197_exit
        end
      end
    end
    local.get $w1196
  )
  (func $closure_627 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_628 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_628 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testListDistinctBy (result i32) ;; exported as "testListDistinctBy"
    (local $lo_clo_174 (ref $ClosureBase_40))
    (local $lo_clo_173 (ref $ClosureBase_44))
    (local $projection (ref $ClosureType_627))
    ref.func $closure_626
    struct.new $ClosureType_626
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_174
    local.get $lo_clo_174
    ref.func $closure_627
    struct.new $ClosureType_627
    local.set $projection
    ref.func $closure_628
    local.get $projection
    struct.new $ClosureType_629
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_173
    local.get $lo_clo_173
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.get $lo_clo_173
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.get $lo_clo_174
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_630 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_631 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1199 (ref null $ListBase))
    (local $w1200 i32)
    local.get $list
    local.set $w1199
    i32.const 0
    local.set $w1200
    block $while_1201_exit
      loop $while_1201_lp
        local.get $w1199
        ref.is_null
        i32.eqz
        if
          local.get $w1200
          i32.const 1
          i32.add
          local.set $w1200
          local.get $w1199
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 1
          local.set $w1199
          br $while_1201_lp
        else
          br $while_1201_exit
        end
      end
    end
    local.get $w1200
  )
  (func $testMapToList (result i32) ;; exported as "testMapToList"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_175 (ref $ClosureBase_40))
    ref.func $closure_630
    struct.new $ClosureType_630
    i32.const 1
    i32.const 10
    struct.new $Tuple_105
    i32.const 2
    i32.const 20
    struct.new $Tuple_105
    i32.const 3
    i32.const 30
    struct.new $Tuple_105
    ref.null $ListBase
    struct.new $ListCons_137
    struct.new $ListCons_137
    struct.new $ListCons_137
    call $Map_ofList
    local.set $m
    ref.func $closure_631
    struct.new $ClosureType_631
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_175
    local.get $lo_clo_175
    local.get $m
    call $Map_toList
    local.get $lo_clo_175
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_632 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $testSetOfListCount (result i32) ;; exported as "testSetOfListCount"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_632
    struct.new $ClosureType_632
    i32.const 3
    i32.const 1
    i32.const 2
    i32.const 1
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    local.get $s
    return_call $Set_count
  )
  (func $closure_633 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x
      local.get $y
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_634 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1203 (ref null $ListBase))
    (local $w1204 i32)
    local.get $list
    local.set $w1203
    i32.const 0
    local.set $w1204
    block $while_1205_exit
      loop $while_1205_lp
        local.get $w1203
        ref.is_null
        i32.eqz
        if
          local.get $w1204
          i32.const 1
          i32.add
          local.set $w1204
          local.get $w1203
          ref.cast (ref $ListCons_37)
          struct.get $ListCons_37 1
          local.set $w1203
          br $while_1205_lp
        else
          br $while_1205_exit
        end
      end
    end
    local.get $w1204
  )
  (func $testSetToList (result i32) ;; exported as "testSetToList"
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_176 (ref $ClosureBase_40))
    ref.func $closure_633
    struct.new $ClosureType_633
    i32.const 3
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    call $Set_ofList
    local.set $s
    ref.func $closure_634
    struct.new $ClosureType_634
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_176
    local.get $lo_clo_176
    local.get $s
    call $Set_toList
    local.get $lo_clo_176
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $closure_635 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_635))
    (local $target i32)
    local.get $self
    ref.cast (ref $ClosureType_635)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_635 1
    local.set $target
    local.get $x
    local.get $target
    i32.eq
  )
  (func $testClosureCapListExists (result i32) ;; exported as "testClosureCapListExists"
    (local $w1207 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 4
    i32.const 7
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1207
    block $exi_1206_blk (result i32)
      block $exi_1206_lp_exit
        loop $exi_1206_lp
          local.get $w1207
          ref.is_null
          i32.eqz
          if
            local.get $w1207
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 7
            i32.eq
            if
              i32.const 1
              br $exi_1206_blk
            end
            local.get $w1207
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 1
            local.set $w1207
          else
            br $exi_1206_lp_exit
          end
          br $exi_1206_lp
        end
      end
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_636 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_636))
    (local $bound i32)
    local.get $self
    ref.cast (ref $ClosureType_636)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_636 1
    local.set $bound
    local.get $x
    local.get $bound
    i32.lt_s
  )
  (func $testClosureCapListForAll (result i32) ;; exported as "testClosureCapListForAll"
    (local $w1209 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 3
    i32.const 5
    i32.const 7
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    struct.new $ListCons_37
    local.set $w1209
    block $all_1208_blk (result i32)
      block $all_1208_lp_exit
        loop $all_1208_lp
          local.get $w1209
          ref.is_null
          i32.eqz
          if
            local.get $w1209
            ref.cast (ref $ListCons_37)
            struct.get $ListCons_37 0
            local.set $x
            local.get $x
            i32.const 10
            i32.lt_s
            if
              local.get $w1209
              ref.cast (ref $ListCons_37)
              struct.get $ListCons_37 1
              local.set $w1209
            else
              i32.const 0
              br $all_1208_blk
            end
          else
            br $all_1208_lp_exit
          end
          br $all_1208_lp
        end
      end
      i32.const 1
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_637 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_637))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_637)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_637 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_637 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_638 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_638))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_638)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_638 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_638 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_639 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_639))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_639)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_639 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_639 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_640 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_640))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_640)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_640 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_640 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_640
    local.get $a
    struct.new $ClosureType_640
  )
  (func $closure_642 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1211 (ref null $ListBase))
    (local $w1212 i32)
    local.get $list
    local.set $w1211
    i32.const 0
    local.set $w1212
    block $while_1213_exit
      loop $while_1213_lp
        local.get $w1211
        ref.is_null
        i32.eqz
        if
          local.get $w1212
          i32.const 1
          i32.add
          local.set $w1212
          local.get $w1211
          ref.cast (ref $ListCons_137)
          struct.get $ListCons_137 1
          local.set $w1211
          br $while_1213_lp
        else
          br $while_1213_exit
        end
      end
    end
    local.get $w1212
  )
  (func $testMapModuleToList (result i32) ;; exported as "testMapModuleToList"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_179 (ref $ClosureBase_383))
    (local $lo_clo_178 (ref $ClosureBase_383))
    (local $lo_clo_177 (ref $ClosureBase_383))
    (local $lo_clo_180 (ref $ClosureBase_40))
    ref.func $closure_637
    i32.const 2
    i32.const 20
    struct.new $ClosureType_637
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_179
    local.get $lo_clo_179
    ref.func $closure_638
    i32.const 1
    i32.const 10
    struct.new $ClosureType_638
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_178
    local.get $lo_clo_178
    ref.func $closure_639
    i32.const 3
    i32.const 30
    struct.new $ClosureType_639
    ref.cast (ref $ClosureBase_383)
    local.set $lo_clo_177
    local.get $lo_clo_177
    ref.func $closure_640
    struct.new $ClosureType_641
    call $Map_empty
    local.get $lo_clo_177
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_178
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.get $lo_clo_179
    struct.get $ClosureBase_383 0
    call_ref $FuncType_382
    local.set $m_3
    ref.func $closure_642
    struct.new $ClosureType_642
    ref.cast (ref $ClosureBase_40)
    local.set $lo_clo_180
    local.get $lo_clo_180
    local.get $m_3
    call $Map_toList
    local.get $lo_clo_180
    struct.get $ClosureBase_40 0
    call_ref $FuncType_39
  )
  (func $runListTests (param $check (ref $AnyFn)) ;; exported as "runListTests"
  )
  ;; ── Elem declare (func refs) ────────────────────────
  (elem declare func $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_SpanishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap $QuickTestWasmGc_TestsList_EnglishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap $QuickTestWasmGc_TestsList_SpanishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap $closure_10 $closure_11 $closure_12 $closure_13 $closure_138 $closure_14 $closure_141 $closure_152 $closure_154 $closure_156 $closure_162 $closure_164 $closure_17 $closure_170 $closure_173 $closure_177 $closure_180 $closure_181 $closure_184 $closure_185 $closure_189 $closure_190 $closure_194 $closure_195 $closure_197 $closure_200 $closure_201 $closure_202 $closure_205 $closure_206 $closure_207 $closure_208 $closure_209 $closure_211 $closure_214 $closure_218 $closure_219 $closure_220 $closure_221 $closure_222 $closure_224 $closure_225 $closure_226 $closure_227 $closure_228 $closure_229 $closure_232 $closure_233 $closure_235 $closure_238 $closure_240 $closure_243 $closure_244 $closure_245 $closure_246 $closure_248 $closure_249 $closure_251 $closure_253 $closure_254 $closure_255 $closure_257 $closure_260 $closure_261 $closure_263 $closure_264 $closure_266 $closure_268 $closure_272 $closure_273 $closure_274 $closure_276 $closure_278 $closure_280 $closure_281 $closure_282 $closure_285 $closure_286 $closure_288 $closure_291 $closure_292 $closure_298 $closure_300 $closure_308 $closure_319 $closure_322 $closure_324 $closure_333 $closure_335 $closure_339 $closure_341 $closure_344 $closure_348 $closure_35 $closure_350 $closure_36 $closure_368 $closure_37 $closure_376 $closure_377 $closure_378 $closure_382 $closure_385 $closure_386 $closure_388 $closure_391 $closure_392 $closure_394 $closure_395 $closure_396 $closure_397 $closure_399 $closure_4 $closure_400 $closure_402 $closure_403 $closure_405 $closure_406 $closure_407 $closure_409 $closure_410 $closure_411 $closure_412 $closure_413 $closure_414 $closure_415 $closure_416 $closure_417 $closure_419 $closure_42 $closure_420 $closure_421 $closure_422 $closure_423 $closure_424 $closure_425 $closure_428 $closure_429 $closure_43 $closure_432 $closure_433 $closure_435 $closure_436 $closure_438 $closure_439 $closure_441 $closure_442 $closure_444 $closure_446 $closure_447 $closure_448 $closure_449 $closure_450 $closure_453 $closure_454 $closure_455 $closure_456 $closure_458 $closure_459 $closure_46 $closure_460 $closure_462 $closure_463 $closure_464 $closure_465 $closure_466 $closure_468 $closure_469 $closure_47 $closure_470 $closure_471 $closure_472 $closure_473 $closure_474 $closure_476 $closure_477 $closure_478 $closure_479 $closure_48 $closure_480 $closure_481 $closure_482 $closure_483 $closure_484 $closure_485 $closure_486 $closure_487 $closure_488 $closure_489 $closure_49 $closure_490 $closure_491 $closure_493 $closure_495 $closure_496 $closure_497 $closure_499 $closure_500 $closure_503 $closure_504 $closure_505 $closure_507 $closure_508 $closure_509 $closure_510 $closure_511 $closure_513 $closure_514 $closure_515 $closure_517 $closure_518 $closure_519 $closure_520 $closure_522 $closure_524 $closure_527 $closure_53 $closure_530 $closure_542 $closure_544 $closure_546 $closure_548 $closure_551 $closure_556 $closure_56 $closure_560 $closure_562 $closure_578 $closure_58 $closure_580 $closure_583 $closure_586 $closure_592 $closure_593 $closure_595 $closure_597 $closure_598 $closure_615 $closure_619 $closure_620 $closure_626 $closure_627 $closure_628 $closure_630 $closure_631 $closure_632 $closure_633 $closure_634 $closure_637 $closure_638 $closure_639 $closure_640 $closure_642 $closure_66 $closure_69 $closure_7 $closure_77 $closure_8 $closure_80 $closure_84 $closure_85 $closure_9)
  ;; ── Exports ────────────────────────────────────────
  (export "testSbLength" (func $testSbLength))
  (export "testSbAppendTwo" (func $testSbAppendTwo))
  (export "testSbGrow" (func $testSbGrow))
  (export "testSbChained" (func $testSbChained))
  (export "roundTo6" (func $roundTo6))
  (export "runStringBuilderTests" (func $runStringBuilderTests))
  (export "testBitwiseAnd" (func $testBitwiseAnd))
  (export "testBitwiseOr" (func $testBitwiseOr))
  (export "testBitwiseXor" (func $testBitwiseXor))
  (export "testShiftLeft" (func $testShiftLeft))
  (export "testShiftRight" (func $testShiftRight))
  (export "testIntDiv" (func $testIntDiv))
  (export "testIntMod" (func $testIntMod))
  (export "testAbsNeg" (func $testAbsNeg))
  (export "testAbsPos" (func $testAbsPos))
  (export "testMinScalar" (func $testMinScalar))
  (export "testMaxScalar" (func $testMaxScalar))
  (export "testNegation" (func $testNegation))
  (export "runBitwiseTests" (func $runBitwiseTests))
  (export "testExnNestedFailwith" (func $testExnNestedFailwith))
  (export "testExnUnit" (func $testExnUnit))
  (export "testExnNormalPath" (func $testExnNormalPath))
  (export "testExnNestedInnerCatch" (func $testExnNestedInnerCatch))
  (export "testExnNestedRethrow" (func $testExnNestedRethrow))
  (export "testExnPairsCatchOrder" (func $testExnPairsCatchOrder))
  (export "testExnIntCatch" (func $testExnIntCatch))
  (export "testExnStringCatch" (func $testExnStringCatch))
  (export "testExnTryFinally" (func $testExnTryFinally))
  (export "testExnTryFinallyWithCatch" (func $testExnTryFinallyWithCatch))
  (export "testExnCarrierBasic" (func $testExnCarrierBasic))
  (export "testExnTypedPayload" (func $testExnTypedPayload))
  (export "testExnTypeTestDiscriminate" (func $testExnTypeTestDiscriminate))
  (export "testExnTypeTestMatch" (func $testExnTypeTestMatch))
  (export "testExnCarrierInt" (func $testExnCarrierInt))
  (export "runExceptionsTests" (func $runExceptionsTests))
  (export "testResultMatchOk" (func $testResultMatchOk))
  (export "testResultMatchError" (func $testResultMatchError))
  (export "testResultIsOk" (func $testResultIsOk))
  (export "testResultIsError" (func $testResultIsError))
  (export "testResultMap" (func $testResultMap))
  (export "testResultBind" (func $testResultBind))
  (export "testResultBindError" (func $testResultBindError))
  (export "testResultModuleIsOk" (func $testResultModuleIsOk))
  (export "testResultModuleIsOkFalse" (func $testResultModuleIsOkFalse))
  (export "testResultModuleIsError" (func $testResultModuleIsError))
  (export "testResultModuleIsErrorFalse" (func $testResultModuleIsErrorFalse))
  (export "testResultModuleDefaultValueError" (func $testResultModuleDefaultValueError))
  (export "testResultModuleDefaultValueOk" (func $testResultModuleDefaultValueOk))
  (export "testResultModuleDefaultErrorOk" (func $testResultModuleDefaultErrorOk))
  (export "testResultModuleDefaultErrorError" (func $testResultModuleDefaultErrorError))
  (export "runResultTests" (func $runResultTests))
  (export "testHOFSimple" (func $testHOFSimple))
  (export "makeAdder" (func $makeAdder))
  (export "testCapture" (func $testCapture))
  (export "applyTwice" (func $applyTwice))
  (export "testApplyTwice" (func $testApplyTwice))
  (export "makeMultiplier" (func $makeMultiplier))
  (export "testLetCapture" (func $testLetCapture))
  (export "testClosureCapMap" (func $testClosureCapMap))
  (export "testClosureCapFilter" (func $testClosureCapFilter))
  (export "testClosureCapFold" (func $testClosureCapFold))
  (export "testClosureHigherOrder" (func $testClosureHigherOrder))
  (export "testClosureCapRef" (func $testClosureCapRef))
  (export "testClosureNestedCapture" (func $testClosureNestedCapture))
  (export "runClosuresTests" (func $runClosuresTests))
  (export "testExternAdd" (func $testExternAdd))
  (export "testExternAddNeg" (func $testExternAddNeg))
  (export "testExternMul" (func $testExternMul))
  (export "testExternChain" (func $testExternChain))
  (export "testInterfaceDispatch" (func $testInterfaceDispatch))
  (export "testInterfacePolymorphism" (func $testInterfacePolymorphism))
  (export "testDuInterfaceCircle" (func $testDuInterfaceCircle))
  (export "testDuInterfaceRect" (func $testDuInterfaceRect))
  (export "testDuInterfacePoly" (func $testDuInterfacePoly))
  (export "testClassCircleArea" (func $testClassCircleArea))
  (export "testClassRectArea" (func $testClassRectArea))
  (export "testMixedShapes" (func $testMixedShapes))
  (export "runInteropTests" (func $runInteropTests))
  (export "directionToInt" (func $directionToInt))
  (export "intToDirection" (func $intToDirection))
  (export "shapeArea" (func $shapeArea))
  (export "shapePerimeter" (func $shapePerimeter))
  (export "testShapeAreaCircle" (func $testShapeAreaCircle))
  (export "testShapeAreaSquare" (func $testShapeAreaSquare))
  (export "testShapeAreaRect" (func $testShapeAreaRect))
  (export "testShapePerimCircle" (func $testShapePerimCircle))
  (export "testShapePerimSquare" (func $testShapePerimSquare))
  (export "testShapePerimRect" (func $testShapePerimRect))
  (export "treeSum" (func $treeSum))
  (export "testTreeSum" (func $testTreeSum))
  (export "testTreeSum2" (func $testTreeSum2))
  (export "testRefTestCircle" (func $testRefTestCircle))
  (export "testRefTestRect" (func $testRefTestRect))
  (export "testRefTestDot" (func $testRefTestDot))
  (export "evalExpr" (func $evalExpr))
  (export "testRecursiveDU" (func $testRecursiveDU))
  (export "testDuEnumEqTrue" (func $testDuEnumEqTrue))
  (export "testDuEnumEqFalse" (func $testDuEnumEqFalse))
  (export "testDuDataEqTrue" (func $testDuDataEqTrue))
  (export "testDuDataEqFalse" (func $testDuDataEqFalse))
  (export "testDuDataEqDiffCtor" (func $testDuDataEqDiffCtor))
  (export "runDUTests" (func $runDUTests))
  (export "distanceFromOrigin" (func $distanceFromOrigin))
  (export "pointSum" (func $pointSum))
  (export "testDistanceFromOrigin" (func $testDistanceFromOrigin))
  (export "testRecordEqTrue" (func $testRecordEqTrue))
  (export "testRecordEqFalse" (func $testRecordEqFalse))
  (export "testRecordNeq" (func $testRecordNeq))
  (export "testMutRecord" (func $testMutRecord))
  (export "rectWidth" (func $rectWidth))
  (export "testRectWidth" (func $testRectWidth))
  (export "swapPair" (func $swapPair))
  (export "testSwapPairFst" (func $testSwapPairFst))
  (export "testSwapPairSnd" (func $testSwapPairSnd))
  (export "minMax" (func $minMax))
  (export "testMinMaxFirst" (func $testMinMaxFirst))
  (export "testMinMaxSecond" (func $testMinMaxSecond))
  (export "tripleSum" (func $tripleSum))
  (export "testTripleSum" (func $testTripleSum))
  (export "testSortWith" (func $testSortWith))
  (export "runPrimitivesTests" (func $runPrimitivesTests))
  (export "testOptionSome" (func $testOptionSome))
  (export "testOptionNone" (func $testOptionNone))
  (export "testOptionDoubleSome" (func $testOptionDoubleSome))
  (export "testOptionDoubleNone" (func $testOptionDoubleNone))
  (export "testOptionIsSome" (func $testOptionIsSome))
  (export "testOptionIsNone" (func $testOptionIsNone))
  (export "testOptionNested" (func $testOptionNested))
  (export "mathAbsF" (func $mathAbsF))
  (export "mathAbsI" (func $mathAbsI))
  (export "mathSqrt" (func $mathSqrt))
  (export "mathFloor" (func $mathFloor))
  (export "mathCeil" (func $mathCeil))
  (export "mathTrunc" (func $mathTrunc))
  (export "mathRound" (func $mathRound))
  (export "mathMinF" (func $mathMinF))
  (export "mathMaxF" (func $mathMaxF))
  (export "mathMinI" (func $mathMinI))
  (export "mathMaxI" (func $mathMaxI))
  (export "applyFn" (func $applyFn))
  (export "doubleVal" (func $doubleVal))
  (export "testOptionMap" (func $testOptionMap))
  (export "testOptionBind" (func $testOptionBind))
  (export "testOptionValue" (func $testOptionValue))
  (export "testOptionMapValue" (func $testOptionMapValue))
  (export "testOptionDefaultValue" (func $testOptionDefaultValue))
  (export "testOptionDefaultValueNone" (func $testOptionDefaultValueNone))
  (export "testOptionDefaultWith" (func $testOptionDefaultWith))
  (export "testOptionDefaultWithSome" (func $testOptionDefaultWithSome))
  (export "testOptionFilter" (func $testOptionFilter))
  (export "testOptionFilterNone" (func $testOptionFilterNone))
  (export "testOptionModuleIsSome" (func $testOptionModuleIsSome))
  (export "testOptionModuleIsSomeNone" (func $testOptionModuleIsSomeNone))
  (export "testOptionModuleIsNone" (func $testOptionModuleIsNone))
  (export "testOptionModuleIsNoneSome" (func $testOptionModuleIsNoneSome))
  (export "testOptionModuleDefaultValueNone" (func $testOptionModuleDefaultValueNone))
  (export "testOptionModuleDefaultValueSome" (func $testOptionModuleDefaultValueSome))
  (export "testOptionModuleCountNone" (func $testOptionModuleCountNone))
  (export "testOptionModuleCountSome" (func $testOptionModuleCountSome))
  (export "runOptionTests" (func $runOptionTests))
  (export "add" (func $add))
  (export "sub" (func $sub))
  (export "mul" (func $mul))
  (export "fib" (func $fib))
  (export "fact" (func $fact))
  (export "clamp" (func $clamp))
  (export "myAbs" (func $myAbs))
  (export "isqrt" (func $isqrt))
  (export "applyFn" (func $applyFn))
  (export "doubleVal" (func $doubleVal))
  (export "makeAdder" (func $makeAdder))
  (export "applyTwice" (func $applyTwice))
  (export "makeMultiplier" (func $makeMultiplier))
  (export "optionOrDefault" (func $optionOrDefault))
  (export "optionDouble" (func $optionDouble))
  (export "optionIsSome" (func $optionIsSome))
  (export "optionIsNone" (func $optionIsNone))
  (export "optionNested" (func $optionNested))
  (export "mathAbsF" (func $mathAbsF))
  (export "mathAbsI" (func $mathAbsI))
  (export "mathSqrt" (func $mathSqrt))
  (export "mathFloor" (func $mathFloor))
  (export "mathCeil" (func $mathCeil))
  (export "mathTrunc" (func $mathTrunc))
  (export "mathRound" (func $mathRound))
  (export "mathMinF" (func $mathMinF))
  (export "mathMaxF" (func $mathMaxF))
  (export "mathMinI" (func $mathMinI))
  (export "mathMaxI" (func $mathMaxI))
  (export "intCmp" (func $intCmp))
  (export "roundTo6" (func $roundTo6))
  (export "runAllTests" (func $runAllTests))
  (export "main" (func $main))
  (export "testStringInterpolation" (func $testStringInterpolation))
  (export "testStringInterpolationConcat" (func $testStringInterpolationConcat))
  (export "testPrintfnLiteral" (func $testPrintfnLiteral))
  (export "testSprintfInt" (func $testSprintfInt))
  (export "testSprintfNegInt" (func $testSprintfNegInt))
  (export "testSprintfStr" (func $testSprintfStr))
  (export "testSprintfIntLiteral" (func $testSprintfIntLiteral))
  (export "testSprintfTwoInts" (func $testSprintfTwoInts))
  (export "testSprintfTwoStrs" (func $testSprintfTwoStrs))
  (export "testSprintfBoolTrue" (func $testSprintfBoolTrue))
  (export "testSprintfBoolFalse" (func $testSprintfBoolFalse))
  (export "testSprintfMixed" (func $testSprintfMixed))
  (export "testSprintfZero" (func $testSprintfZero))
  (export "testSprintfPrefix" (func $testSprintfPrefix))
  (export "testSprintfFloat" (func $testSprintfFloat))
  (export "testSprintfFloatHalf" (func $testSprintfFloatHalf))
  (export "testSprintfFloatWhole" (func $testSprintfFloatWhole))
  (export "testSprintfFloatNeg" (func $testSprintfFloatNeg))
  (export "testSprintfFloatInStr" (func $testSprintfFloatInStr))
  (export "testPrintfnInt" (func $testPrintfnInt))
  (export "testPrintfnStr" (func $testPrintfnStr))
  (export "testPrintfnMulti" (func $testPrintfnMulti))
  (export "testSprintfI" (func $testSprintfI))
  (export "testSprintfPercent" (func $testSprintfPercent))
  (export "testSprintfIntZeroChar" (func $testSprintfIntZeroChar))
  (export "testSprintfEmptyStr" (func $testSprintfEmptyStr))
  (export "testSprintfIntFirstChar" (func $testSprintfIntFirstChar))
  (export "testInterpolationWithSprintf" (func $testInterpolationWithSprintf))
  (export "runPrintfTests" (func $runPrintfTests))
  (export "testSeqMap" (func $testSeqMap))
  (export "testSeqFilter" (func $testSeqFilter))
  (export "testSeqFold" (func $testSeqFold))
  (export "testSeqExists" (func $testSeqExists))
  (export "testSeqSumBy" (func $testSeqSumBy))
  (export "testSeqInit" (func $testSeqInit))
  (export "testSeqPairwise" (func $testSeqPairwise))
  (export "testSeqCountBy" (func $testSeqCountBy))
  (export "testSeqDistinct" (func $testSeqDistinct))
  (export "testSeqChoose" (func $testSeqChoose))
  (export "testSeqCollect" (func $testSeqCollect))
  (export "testSeqReduce" (func $testSeqReduce))
  (export "testSeqMapIndexed" (func $testSeqMapIndexed))
  (export "testSeqForall" (func $testSeqForall))
  (export "testSeqHead" (func $testSeqHead))
  (export "testSeqTryHead" (func $testSeqTryHead))
  (export "testSeqTryHeadEmpty" (func $testSeqTryHeadEmpty))
  (export "testSeqIsEmpty" (func $testSeqIsEmpty))
  (export "testSeqLength" (func $testSeqLength))
  (export "testSeqItem" (func $testSeqItem))
  (export "testSeqMinMax" (func $testSeqMinMax))
  (export "testSeqSortBy" (func $testSeqSortBy))
  (export "testSeqRev" (func $testSeqRev))
  (export "testSeqFindIndex" (func $testSeqFindIndex))
  (export "testSeqSkipTake" (func $testSeqSkipTake))
  (export "testSeqGroupByCount" (func $testSeqGroupByCount))
  (export "runSeqTests" (func $runSeqTests))
  (export "testDistanceFromOrigin" (func $testDistanceFromOrigin))
  (export "testFib10" (func $testFib10))
  (export "testFib15" (func $testFib15))
  (export "isPrime" (func $isPrime))
  (export "testIsPrime7" (func $testIsPrime7))
  (export "testIsPrime4" (func $testIsPrime4))
  (export "testCountPrimesTo50" (func $testCountPrimesTo50))
  (export "testCollatz27" (func $testCollatz27))
  (export "testPown2_10" (func $testPown2_10))
  (export "testPownZero" (func $testPownZero))
  (export "testPownCube" (func $testPownCube))
  (export "testPownOne" (func $testPownOne))
  (export "testPowF64_2_10" (func $testPowF64_2_10))
  (export "testPowF64_zero" (func $testPowF64_zero))
  (export "testPowF64_cube" (func $testPowF64_cube))
  (export "testMathPow" (func $testMathPow))
  (export "testMathExp_zero" (func $testMathExp_zero))
  (export "testMathExp_one" (func $testMathExp_one))
  (export "testMathExp_ten" (func $testMathExp_ten))
  (export "testMathExp_neg" (func $testMathExp_neg))
  (export "testMathLog_one" (func $testMathLog_one))
  (export "testMathLog_e" (func $testMathLog_e))
  (export "testMathLog_1024" (func $testMathLog_1024))
  (export "testMathExpLogRoundtrip" (func $testMathExpLogRoundtrip))
  (export "testMathSin_zero" (func $testMathSin_zero))
  (export "testMathSin_90deg" (func $testMathSin_90deg))
  (export "testMathCos_zero" (func $testMathCos_zero))
  (export "testMathCos_180deg" (func $testMathCos_180deg))
  (export "testMathTan_zero" (func $testMathTan_zero))
  (export "testMathTan_45deg" (func $testMathTan_45deg))
  (export "testClz_one" (func $testClz_one))
  (export "testClz_highBit" (func $testClz_highBit))
  (export "testCtz_eight" (func $testCtz_eight))
  (export "testCtz_one" (func $testCtz_one))
  (export "testPopcnt_seven" (func $testPopcnt_seven))
  (export "testPopcnt_allOnes" (func $testPopcnt_allOnes))
  (export "testAtan2Origin" (func $testAtan2Origin))
  (export "testAtan2PosX" (func $testAtan2PosX))
  (export "testAtan2NegX" (func $testAtan2NegX))
  (export "testAtan2PosY" (func $testAtan2PosY))
  (export "testAtan2NegY" (func $testAtan2NegY))
  (export "testAtan2Q3" (func $testAtan2Q3))
  (export "runMathTests" (func $runMathTests))
  (export "testArrayLiteral" (func $testArrayLiteral))
  (export "testArrayCreate" (func $testArrayCreate))
  (export "testArrayZeroCreate" (func $testArrayZeroCreate))
  (export "testArrayLength" (func $testArrayLength))
  (export "testArraySumLoop" (func $testArraySumLoop))
  (export "testArrayFloat" (func $testArrayFloat))
  (export "testArrayFold" (func $testArrayFold))
  (export "testArrayFoldFloat" (func $testArrayFoldFloat))
  (export "testArrayMap" (func $testArrayMap))
  (export "testArrayMapStr" (func $testArrayMapStr))
  (export "testArrayMapi" (func $testArrayMapi))
  (export "testArrayFilter" (func $testArrayFilter))
  (export "testArrayFilterAll" (func $testArrayFilterAll))
  (export "testArrayFilterNone" (func $testArrayFilterNone))
  (export "testArrayExists" (func $testArrayExists))
  (export "testArrayExistsFalse" (func $testArrayExistsFalse))
  (export "testArrayForAll" (func $testArrayForAll))
  (export "testArrayForAllFalse" (func $testArrayForAllFalse))
  (export "testArrayInit" (func $testArrayInit))
  (export "testArrayInitFold" (func $testArrayInitFold))
  (export "testArrayIter" (func $testArrayIter))
  (export "testArrayIteri" (func $testArrayIteri))
  (export "testArrayReduce" (func $testArrayReduce))
  (export "testArraySum" (func $testArraySum))
  (export "testArrayMin" (func $testArrayMin))
  (export "testArrayMax" (func $testArrayMax))
  (export "testArrayRev" (func $testArrayRev))
  (export "testArraySort" (func $testArraySort))
  (export "testArrayFindIndex" (func $testArrayFindIndex))
  (export "testArrayContains" (func $testArrayContains))
  (export "testArrayContainsFalse" (func $testArrayContainsFalse))
  (export "testArrayScan" (func $testArrayScan))
  (export "testArrayScanLen" (func $testArrayScanLen))
  (export "testArrayAppend" (func $testArrayAppend))
  (export "testArrayAppendLen" (func $testArrayAppendLen))
  (export "testArrayToList" (func $testArrayToList))
  (export "testListOfArray" (func $testListOfArray))
  (export "testArraySortWith" (func $testArraySortWith))
  (export "testArraySortWithDesc" (func $testArraySortWithDesc))
  (export "testArrayZip" (func $testArrayZip))
  (export "testArrayZipLen" (func $testArrayZipLen))
  (export "testArrayMap2Sum" (func $testArrayMap2Sum))
  (export "testArrayMap2Head" (func $testArrayMap2Head))
  (export "testArrayChooseBasic" (func $testArrayChooseBasic))
  (export "testArrayChooseLength" (func $testArrayChooseLength))
  (export "testArrayChooseEmpty" (func $testArrayChooseEmpty))
  (export "testArrayChooseAllSome" (func $testArrayChooseAllSome))
  (export "testArrayCollectBasic" (func $testArrayCollectBasic))
  (export "testArrayCollectLength" (func $testArrayCollectLength))
  (export "testArrayCollectEmpty" (func $testArrayCollectEmpty))
  (export "testArrayCollectSingleton" (func $testArrayCollectSingleton))
  (export "testResizeArrayBasic" (func $testResizeArrayBasic))
  (export "testArrayUnzip" (func $testArrayUnzip))
  (export "testResizeArrayIndex" (func $testResizeArrayIndex))
  (export "testSetOfArray" (func $testSetOfArray))
  (export "runArrayTests" (func $runArrayTests))
  (export "testRectWidth" (func $testRectWidth))
  (export "directionToInt" (func $directionToInt))
  (export "intToDirection" (func $intToDirection))
  (export "shapeArea" (func $shapeArea))
  (export "shapePerimeter" (func $shapePerimeter))
  (export "testStringLen" (func $testStringLen))
  (export "testEmptyStringLen" (func $testEmptyStringLen))
  (export "testStringChar" (func $testStringChar))
  (export "testStringFirstChar" (func $testStringFirstChar))
  (export "testStringLen2" (func $testStringLen2))
  (export "testStringConcatLen" (func $testStringConcatLen))
  (export "testStringConcatChar" (func $testStringConcatChar))
  (export "testStringEqTrue" (func $testStringEqTrue))
  (export "testStringEqFalse" (func $testStringEqFalse))
  (export "testStringNeq" (func $testStringNeq))
  (export "testStringConcatVars" (func $testStringConcatVars))
  (export "testRefCell" (func $testRefCell))
  (export "testRefCellBool" (func $testRefCellBool))
  (export "treeSum" (func $treeSum))
  (export "testStringIndexOf" (func $testStringIndexOf))
  (export "testStringIndexOfMiss" (func $testStringIndexOfMiss))
  (export "testStringLastIndexOf" (func $testStringLastIndexOf))
  (export "testStringLastIndexOfMiss" (func $testStringLastIndexOfMiss))
  (export "testStringIndexOfFrom" (func $testStringIndexOfFrom))
  (export "testStringStartsWith" (func $testStringStartsWith))
  (export "testStringStartsWithFalse" (func $testStringStartsWithFalse))
  (export "testStringEndsWith" (func $testStringEndsWith))
  (export "testStringEndsWithFalse" (func $testStringEndsWithFalse))
  (export "testStringSubstring" (func $testStringSubstring))
  (export "testStringSubstringLen" (func $testStringSubstringLen))
  (export "testToLowerLength" (func $testToLowerLength))
  (export "testToUpperFirstChar" (func $testToUpperFirstChar))
  (export "testToLowerChars" (func $testToLowerChars))
  (export "testToUpperChars" (func $testToUpperChars))
  (export "testTrimBasic" (func $testTrimBasic))
  (export "testTrimStart" (func $testTrimStart))
  (export "testTrimEnd" (func $testTrimEnd))
  (export "testContains" (func $testContains))
  (export "testContainsNot" (func $testContainsNot))
  (export "testToLowerMixed" (func $testToLowerMixed))
  (export "testStringOfInt" (func $testStringOfInt))
  (export "testStringOfNegInt" (func $testStringOfNegInt))
  (export "testStringOfZero" (func $testStringOfZero))
  (export "testStringOfIntChar" (func $testStringOfIntChar))
  (export "testPadLeft" (func $testPadLeft))
  (export "testPadRight" (func $testPadRight))
  (export "testPadLeftNoop" (func $testPadLeftNoop))
  (export "testPadLeftChar" (func $testPadLeftChar))
  (export "testReplace" (func $testReplace))
  (export "testReplaceRemove" (func $testReplaceRemove))
  (export "testReplaceNoMatch" (func $testReplaceNoMatch))
  (export "testIsUpper" (func $testIsUpper))
  (export "testIsLower" (func $testIsLower))
  (export "testCharToLower" (func $testCharToLower))
  (export "testCharToUpper" (func $testCharToUpper))
  (export "testFloatCompare" (func $testFloatCompare))
  (export "testRecordEqTrue" (func $testRecordEqTrue))
  (export "testRecordEqFalse" (func $testRecordEqFalse))
  (export "testRecordNeq" (func $testRecordNeq))
  (export "testStrSplitLen" (func $testStrSplitLen))
  (export "testStrSplitFirst" (func $testStrSplitFirst))
  (export "testStrSplitSecond" (func $testStrSplitSecond))
  (export "testStrSplitWords" (func $testStrSplitWords))
  (export "testStrSplitNoDelim" (func $testStrSplitNoDelim))
  (export "testStrSplitEmpty" (func $testStrSplitEmpty))
  (export "testStrSplitMultiChar" (func $testStrSplitMultiChar))
  (export "testStrJoinLen" (func $testStrJoinLen))
  (export "testStrJoinNoSep" (func $testStrJoinNoSep))
  (export "testStrJoinOne" (func $testStrJoinOne))
  (export "testStrIsNullOrEmptyTrue" (func $testStrIsNullOrEmptyTrue))
  (export "testStrIsNullOrEmptyFalse" (func $testStrIsNullOrEmptyFalse))
  (export "testStrCompareEq" (func $testStrCompareEq))
  (export "testStrCompareLt" (func $testStrCompareLt))
  (export "testStrCompareGt" (func $testStrCompareGt))
  (export "fibonacci" (func $fibonacci))
  (export "testSbToStringLength" (func $testSbToStringLength))
  (export "testSbToStringContent" (func $testSbToStringContent))
  (export "testCompareIntLt" (func $testCompareIntLt))
  (export "testCompareIntEq" (func $testCompareIntEq))
  (export "testCompareIntGt" (func $testCompareIntGt))
  (export "testCompareStrLt" (func $testCompareStrLt))
  (export "testCompareStrEq" (func $testCompareStrEq))
  (export "testCompareStrGt" (func $testCompareStrGt))
  (export "$007CEven$007COdd$007C" (func $007CEven$007COdd$007C))
  (export "testStringConcat" (func $testStringConcat))
  (export "testStringInterp" (func $testStringInterp))
  (export "runStringsTests" (func $runStringsTests))
  (export "testMapAddFind" (func $testMapAddFind))
  (export "testMapFindMissing" (func $testMapFindMissing))
  (export "testMapCount" (func $testMapCount))
  (export "testMapContainsKey" (func $testMapContainsKey))
  (export "testMapContainsKeyMissing" (func $testMapContainsKeyMissing))
  (export "testMapAddReplace" (func $testMapAddReplace))
  (export "testStdMapFind" (func $testStdMapFind))
  (export "testStdMapTryFind" (func $testStdMapTryFind))
  (export "testStdMapTryFindMissing" (func $testStdMapTryFindMissing))
  (export "testStdMapContainsKey" (func $testStdMapContainsKey))
  (export "testStdMapAdd" (func $testStdMapAdd))
  (export "testMapIsEmpty" (func $testMapIsEmpty))
  (export "testMapRemove" (func $testMapRemove))
  (export "testMapLargeAddFind" (func $testMapLargeAddFind))
  (export "testMapFindRaises" (func $testMapFindRaises))
  (export "testMapFold" (func $testMapFold))
  (export "testMapIter" (func $testMapIter))
  (export "testMapFilter" (func $testMapFilter))
  (export "testMapExists" (func $testMapExists))
  (export "testMapForall" (func $testMapForall))
  (export "testMapMap" (func $testMapMap))
  (export "testMapCustomCmpReverse" (func $testMapCustomCmpReverse))
  (export "testMapModuleContainsKey" (func $testMapModuleContainsKey))
  (export "testMapModuleFindRoundTrip" (func $testMapModuleFindRoundTrip))
  (export "testMapModuleRemove" (func $testMapModuleRemove))
  (export "runMapTests" (func $runMapTests))
  (export "testSetContains" (func $testSetContains))
  (export "testSetAdd" (func $testSetAdd))
  (export "testSetRemove" (func $testSetRemove))
  (export "testSetIsEmpty" (func $testSetIsEmpty))
  (export "testSetFold" (func $testSetFold))
  (export "testSetFilter" (func $testSetFilter))
  (export "testSetExists" (func $testSetExists))
  (export "testSetForall" (func $testSetForall))
  (export "testSetUnion" (func $testSetUnion))
  (export "testSetIntersect" (func $testSetIntersect))
  (export "testSetDifference" (func $testSetDifference))
  (export "testSetIsSubset" (func $testSetIsSubset))
  (export "testSetMap" (func $testSetMap))
  (export "testSetMinMax" (func $testSetMinMax))
  (export "testSetSingleton" (func $testSetSingleton))
  (export "testClosureCapSetFold" (func $testClosureCapSetFold))
  (export "testSetModuleBasic" (func $testSetModuleBasic))
  (export "testSetModuleDedup" (func $testSetModuleDedup))
  (export "testSetModuleContains" (func $testSetModuleContains))
  (export "testSetModuleFold" (func $testSetModuleFold))
  (export "runSetTests" (func $runSetTests))
  (export "testListHead" (func $testListHead))
  (export "testListEmpty" (func $testListEmpty))
  (export "testListMatch" (func $testListMatch))
  (export "testListFoldSum" (func $testListFoldSum))
  (export "testListMapSum" (func $testListMapSum))
  (export "testListFilterSum" (func $testListFilterSum))
  (export "testListRevHead" (func $testListRevHead))
  (export "testListAppendLen" (func $testListAppendLen))
  (export "testListIter" (func $testListIter))
  (export "testListIterEmpty" (func $testListIterEmpty))
  (export "testListExists" (func $testListExists))
  (export "testListExistsFalse" (func $testListExistsFalse))
  (export "testListForAll" (func $testListForAll))
  (export "testListForAllFalse" (func $testListForAllFalse))
  (export "testListSum" (func $testListSum))
  (export "testListSumEmpty" (func $testListSumEmpty))
  (export "testListTryFindSome" (func $testListTryFindSome))
  (export "testListTryFindNone" (func $testListTryFindNone))
  (export "testListTryHeadSome" (func $testListTryHeadSome))
  (export "testListTryHeadNone" (func $testListTryHeadNone))
  (export "testListMapi" (func $testListMapi))
  (export "testListIteri" (func $testListIteri))
  (export "testListCollect" (func $testListCollect))
  (export "testListCollectOrder" (func $testListCollectOrder))
  (export "testListChoose" (func $testListChoose))
  (export "testListChooseSum" (func $testListChooseSum))
  (export "testListFoldBack" (func $testListFoldBack))
  (export "testListFoldBackOrder" (func $testListFoldBackOrder))
  (export "testListSumBy" (func $testListSumBy))
  (export "testListMinBy" (func $testListMinBy))
  (export "testListMaxBy" (func $testListMaxBy))
  (export "testListMin" (func $testListMin))
  (export "testListMax" (func $testListMax))
  (export "testListContains" (func $testListContains))
  (export "testListContainsFalse" (func $testListContainsFalse))
  (export "testListInit" (func $testListInit))
  (export "testListReplicate" (func $testListReplicate))
  (export "testListTake" (func $testListTake))
  (export "testListSkip" (func $testListSkip))
  (export "testListSort" (func $testListSort))
  (export "testListFindIndex" (func $testListFindIndex))
  (export "testListTryFindIndex" (func $testListTryFindIndex))
  (export "testListItem" (func $testListItem))
  (export "testListTailHead" (func $testListTailHead))
  (export "testListLength" (func $testListLength))
  (export "testListReduce" (func $testListReduce))
  (export "testListReduceMax" (func $testListReduceMax))
  (export "testListLast" (func $testListLast))
  (export "testListLastSingle" (func $testListLastSingle))
  (export "testListSortDesc" (func $testListSortDesc))
  (export "testListSortBy" (func $testListSortBy))
  (export "testListFlatten" (func $testListFlatten))
  (export "testListZip" (func $testListZip))
  (export "testListZipLen" (func $testListZipLen))
  (export "testListMap2Sum" (func $testListMap2Sum))
  (export "testListMap2Head" (func $testListMap2Head))
  (export "testListPartitionCounts" (func $testListPartitionCounts))
  (export "testListPartitionEvens" (func $testListPartitionEvens))
  (export "testListPartitionOdds" (func $testListPartitionOdds))
  (export "testListPartitionEmpty" (func $testListPartitionEmpty))
  (export "testListPartitionAllTrue" (func $testListPartitionAllTrue))
  (export "testListPartitionOrder" (func $testListPartitionOrder))
  (export "testListSortIntAsc" (func $testListSortIntAsc))
  (export "testListSortStrAsc" (func $testListSortStrAsc))
  (export "testSeqToList" (func $testSeqToList))
  (export "testListUnzip" (func $testListUnzip))
  (export "testListGroupBy" (func $testListGroupBy))
  (export "evalExpr" (func $evalExpr))
  (export "testListDistinctBy" (func $testListDistinctBy))
  (export "testMapToList" (func $testMapToList))
  (export "testSetOfListCount" (func $testSetOfListCount))
  (export "testSetToList" (func $testSetToList))
  (export "testClosureCapListExists" (func $testClosureCapListExists))
  (export "testClosureCapListForAll" (func $testClosureCapListForAll))
  (export "testMapModuleToList" (func $testMapModuleToList))
  (export "runListTests" (func $runListTests))
  ;; ── Globals ─────────────────────────────────────────
  (global $fsharp_exn_carrier (mut anyref)ref.null any
)
  (global $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_vtable (ref $vtbl_QuickTestWasmGc_TestsInterop_IGreeter)ref.func $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap
struct.new $vtbl_QuickTestWasmGc_TestsInterop_IGreeter
)
  (global $QuickTestWasmGc_TestsInterop_SpanishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_vtable (ref $vtbl_QuickTestWasmGc_TestsInterop_IGreeter)ref.func $QuickTestWasmGc_TestsInterop_SpanishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap
struct.new $vtbl_QuickTestWasmGc_TestsInterop_IGreeter
)
  (global $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_vtable (ref $vtbl_QuickTestWasmGc_TestsInterop_IShape)ref.func $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_Area_wrap
struct.new $vtbl_QuickTestWasmGc_TestsInterop_IShape
)
  (global $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_vtable (ref $vtbl_QuickTestWasmGc_TestsInterop_IShape)ref.func $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_Area_wrap
struct.new $vtbl_QuickTestWasmGc_TestsInterop_IShape
)
  (global $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_vtable (ref $vtbl_QuickTestWasmGc_TestsInterop_IShape)ref.func $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_Area_wrap
struct.new $vtbl_QuickTestWasmGc_TestsInterop_IShape
)
  (global $QuickTestWasmGc_TestsList_EnglishGreeter_QuickTestWasmGc_TestsList_IGreeter_vtable (ref $vtbl_QuickTestWasmGc_TestsList_IGreeter)ref.func $QuickTestWasmGc_TestsList_EnglishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap
struct.new $vtbl_QuickTestWasmGc_TestsList_IGreeter
)
  (global $QuickTestWasmGc_TestsList_SpanishGreeter_QuickTestWasmGc_TestsList_IGreeter_vtable (ref $vtbl_QuickTestWasmGc_TestsList_IGreeter)ref.func $QuickTestWasmGc_TestsList_SpanishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap
struct.new $vtbl_QuickTestWasmGc_TestsList_IGreeter
)
)
