(module
  ;; ── Types ───────────────────────────────────────────
  (type $AnyFn (sub (struct)))
  (type $WasmStr (array (mut i32)))
  (type $ListBase (sub (struct)))
  (type $StringBuilder (sub (struct (field (mut (ref $WasmStr))) (field (mut i32)) (field (mut i32)))))
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
  (type $QuickTestWasmGc_TestsExceptions_MyTypedException (sub (struct (field i32))))
  (type $Exception (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_21 (func (param (ref $AnyFn)) (result i32)))
  (type $ClosureBase_22 (sub $AnyFn (struct (field (ref $FuncType_21)))))
  (type $ClosureType_23 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $FuncType_24 (func (param (ref $AnyFn))))
  (type $FuncType_25 (func (param (ref $AnyFn)) (param i32) (result i32)))
  (type $ClosureBase_26 (sub $AnyFn (struct (field (ref $FuncType_25)))))
  (type $ClosureType_27 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_28 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_29 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ListCons_30 (sub $ListBase (struct (field i32) (field (ref null $ListBase)))))
  (type $ClosureType_31 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $FuncType_32 (func (param (ref $AnyFn)) (param (ref null $ListBase)) (result i32)))
  (type $ClosureBase_33 (sub $AnyFn (struct (field (ref $FuncType_32)))))
  (type $ClosureType_34 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_35 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $FuncType_36 (func (param (ref $AnyFn)) (param (ref null $ListBase)) (result (ref null $ListBase))))
  (type $ClosureBase_37 (sub $AnyFn (struct (field (ref $FuncType_36)))))
  (type $ClosureType_38 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $ClosureType_39 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_40 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_41 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $ClosureType_42 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32) (field i32))))
  (type $FuncType_43 (func (param (ref $AnyFn)) (param i32) (result (ref $AnyFn))))
  (type $ClosureBase_44 (sub $AnyFn (struct (field (ref $FuncType_43)))))
  (type $ClosureType_45 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_46 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_47 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $RefCell_48 (sub (struct (field (mut i32)))))
  (type $ClosureBase_49 (sub $AnyFn (struct (field (ref $FuncType_24)))))
  (type $ClosureType_50 (sub $ClosureBase_49 (struct (field (ref $FuncType_24)) (field (ref $RefCell_48)))))
  (type $ClosureType_51 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32) (field i32))))
  (type $ClosureType_52 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $SetModule_SetNode`1 (sub (struct (field i32))))
  (type $SetModule_SetNode`1#0 (sub $SetModule_SetNode`1 (struct (field i32))))
  (type $SetModule_SetNode`1#1 (sub $SetModule_SetNode`1 (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1)) (field (ref $SetModule_SetNode`1)))))
  (type $SetModule_SetHandle`1 (sub (struct (field (ref $SetModule_SetNode`1)) (field (ref $AnyFn)))))
  (type $SetModule_SetNode`1<i32> (sub (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#0 (sub $SetModule_SetNode`1<i32> (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#1 (sub $SetModule_SetNode`1<i32> (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $SetModule_SetNode`1<i32>)))))
  (type $FuncType_60 (func (param (ref $AnyFn)) (param i32)))
  (type $ClosureType_61 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_62 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_63 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_64 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $FuncType_65 (func (param (ref $AnyFn)) (param i32) (result (ref $SetModule_SetNode`1<i32>))))
  (type $ClosureBase_66 (sub $AnyFn (struct (field (ref $FuncType_65)))))
  (type $ClosureType_67 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_68 (func (param (ref $AnyFn)) (param (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))))
  (type $ClosureBase_69 (sub $AnyFn (struct (field (ref $FuncType_68)))))
  (type $ClosureType_70 (sub $ClosureBase_69 (struct (field (ref $FuncType_68)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_71 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_72 (sub $ClosureBase_69 (struct (field (ref $FuncType_68)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_73 (func (param (ref $AnyFn)) (param i32) (result (ref $SetModule_SetHandle`1))))
  (type $ClosureBase_74 (sub $AnyFn (struct (field (ref $FuncType_73)))))
  (type $ClosureType_75 (sub $ClosureBase_74 (struct (field (ref $FuncType_73)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_76 (func (param (ref $AnyFn)) (param (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))))
  (type $ClosureBase_77 (sub $AnyFn (struct (field (ref $FuncType_76)))))
  (type $ClosureType_78 (sub $ClosureBase_77 (struct (field (ref $FuncType_76)))))
  (type $GcArray_79 (array (mut i32)))
  (type $ClosureType_80 (sub $ClosureBase_74 (struct (field (ref $FuncType_73)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_81 (sub $ClosureBase_77 (struct (field (ref $FuncType_76)))))
  (type $MapModule_MapNode`2 (sub (struct (field i32))))
  (type $MapModule_MapNode`2#0 (sub $MapModule_MapNode`2 (struct (field i32))))
  (type $MapModule_MapNode`2#1 (sub $MapModule_MapNode`2 (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2)) (field (ref $MapModule_MapNode`2)))))
  (type $MapModule_MapHandle`2 (sub (struct (field (ref $MapModule_MapNode`2)) (field (ref $AnyFn)))))
  (type $MapModule_MapNode`2<i32~i32> (sub (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#0 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#1 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2<i32~i32>)) (field (ref $MapModule_MapNode`2<i32~i32>)))))
  (type $Option_89 (sub (struct (field i32))))
  (type $Tuple_90 (sub (struct (field i32) (field i32))))
  (type $ListCons_91 (sub $ListBase (struct (field (ref $Tuple_90)) (field (ref null $ListBase)))))
  (type $ClosureType_92 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_93 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_94 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_95 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_96 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_97 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $Option_98 (sub (struct (field (ref null $Option_89)))))
  (type $GcArray_99 (array (mut f64)))
  (type $ClosureType_100 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_101 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $FuncType_102 (func (param (ref $AnyFn)) (param f64) (result f64)))
  (type $ClosureBase_103 (sub $AnyFn (struct (field (ref $FuncType_102)))))
  (type $ClosureType_104 (sub $ClosureBase_103 (struct (field (ref $FuncType_102)) (field f64))))
  (type $FuncType_105 (func (param (ref $AnyFn)) (param f64) (result (ref $AnyFn))))
  (type $ClosureBase_106 (sub $AnyFn (struct (field (ref $FuncType_105)))))
  (type $ClosureType_107 (sub $ClosureBase_106 (struct (field (ref $FuncType_105)))))
  (type $ClosureType_108 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_109 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_110 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_111 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_112 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_113 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_114 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_115 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_116 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_117 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_118 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_119 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_120 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_121 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_122 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureBase_123 (sub $AnyFn (struct (field (ref $FuncType_60)))))
  (type $ClosureType_124 (sub $ClosureBase_123 (struct (field (ref $FuncType_60)) (field i32))))
  (type $ClosureType_125 (sub $ClosureBase_123 (struct (field (ref $FuncType_60)) (field i32) (field i32))))
  (type $ClosureType_126 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_127 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_128 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_129 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $FuncType_130 (func (param (ref $AnyFn)) (param i32) (param i32) (result i32)))
  (type $ClosureBase_131 (sub $AnyFn (struct (field (ref $FuncType_130)))))
  (type $ClosureType_132 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_133 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_134 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_135 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_136 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_137 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_138 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_139 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_140 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_141 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_142 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_143 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_144 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_145 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_146 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_147 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $GcArray_148 (array (mut (ref $Tuple_90))))
  (type $ClosureType_149 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $FuncType_150 (func (param (ref $AnyFn)) (param (ref $GcArray_79)) (result i32)))
  (type $ClosureBase_151 (sub $AnyFn (struct (field (ref $FuncType_150)))))
  (type $ClosureType_152 (sub $ClosureBase_151 (struct (field (ref $FuncType_150)))))
  (type $ClosureType_153 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_154 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_155 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_156 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $FuncType_157 (func (param (ref $AnyFn)) (param i32) (result (ref null $Option_89))))
  (type $ClosureBase_158 (sub $AnyFn (struct (field (ref $FuncType_157)))))
  (type $ClosureType_159 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_160 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_161 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_162 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_163 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $FuncType_164 (func (param (ref $AnyFn)) (param i32) (result (ref $GcArray_79))))
  (type $ClosureBase_165 (sub $AnyFn (struct (field (ref $FuncType_164)))))
  (type $ClosureType_166 (sub $ClosureBase_165 (struct (field (ref $FuncType_164)))))
  (type $ClosureType_167 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_168 (sub $ClosureBase_165 (struct (field (ref $FuncType_164)))))
  (type $ClosureType_169 (sub $ClosureBase_165 (struct (field (ref $FuncType_164)))))
  (type $ClosureType_170 (sub $ClosureBase_165 (struct (field (ref $FuncType_164)))))
  (type $ResizeArray_171 (sub (struct (field (mut (ref null $GcArray_79))) (field (mut i32)))))
  (type $Tuple_172 (sub (struct (field (ref $GcArray_79)) (field (ref $GcArray_79)))))
  (type $ClosureType_173 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_174 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_175 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $QuickTestWasmGc_TestsInterop_EnglishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_177 (func (param (ref eq)) (result i32)))
  (type $vtbl_QuickTestWasmGc_TestsInterop_IGreeter (sub (struct (field (ref $FuncType_177)))))
  (type $box_QuickTestWasmGc_TestsInterop_IGreeter (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsInterop_IGreeter)) (field (ref eq)))))
  (type $QuickTestWasmGc_TestsInterop_SpanishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $ListCons_181 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (field (ref null $ListBase)))))
  (type $FuncType_182 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (result i32)))
  (type $ClosureBase_183 (sub $AnyFn (struct (field (ref $FuncType_182)))))
  (type $ClosureType_184 (sub $ClosureBase_183 (struct (field (ref $FuncType_182)))))
  (type $ClosureType_185 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_186 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsInterop_IntShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsInterop_IntShape#0 (sub $QuickTestWasmGc_TestsInterop_IntShape (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsInterop_IntShape#1 (sub $QuickTestWasmGc_TestsInterop_IntShape (struct (field i32) (field i32) (field i32))))
  (type $vtbl_QuickTestWasmGc_TestsInterop_IShape (sub (struct (field (ref $FuncType_177)))))
  (type $box_QuickTestWasmGc_TestsInterop_IShape (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsInterop_IShape)) (field (ref eq)))))
  (type $ListCons_192 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (field (ref null $ListBase)))))
  (type $FuncType_193 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)))
  (type $ClosureBase_194 (sub $AnyFn (struct (field (ref $FuncType_193)))))
  (type $ClosureType_195 (sub $ClosureBase_194 (struct (field (ref $FuncType_193)))))
  (type $ClosureType_196 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_197 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsInterop_ClassCircle (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsInterop_ClassRect (sub (struct (field i32) (field i32))))
  (type $ClosureType_200 (sub $ClosureBase_194 (struct (field (ref $FuncType_193)))))
  (type $ClosureType_201 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_202 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $FuncType_203 (func (param (ref $AnyFn)) (param f64) (param f64) (result f64)))
  (type $ClosureBase_204 (sub $AnyFn (struct (field (ref $FuncType_203)))))
  (type $ClosureType_205 (sub $ClosureBase_204 (struct (field (ref $FuncType_203)))))
  (type $ClosureType_206 (sub $ClosureBase_204 (struct (field (ref $FuncType_203)))))
  (type $ClosureType_207 (sub $ClosureBase_204 (struct (field (ref $FuncType_203)))))
  (type $QuickTestWasmGc_TestsMath_GeoShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#0 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#1 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#2 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32))))
  (type $FuncType_212 (func (param (ref $AnyFn)) (param (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))))
  (type $ClosureBase_213 (sub $AnyFn (struct (field (ref $FuncType_212)))))
  (type $ClosureType_214 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_215 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_216 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_217 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $FuncType_218 (func (param (ref $AnyFn)) (param (ref null $Option_89)) (result i32)))
  (type $ClosureBase_219 (sub $AnyFn (struct (field (ref $FuncType_218)))))
  (type $ClosureType_220 (sub $ClosureBase_219 (struct (field (ref $FuncType_218)) (field i32))))
  (type $ClosureType_221 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_222 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_223 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_224 (sub $ClosureBase_219 (struct (field (ref $FuncType_218)) (field i32))))
  (type $ClosureType_225 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_226 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_227 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_228 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_229 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_230 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_231 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_232 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_233 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_234 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_235 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_236 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_237 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_238 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_239 (sub $ClosureBase_219 (struct (field (ref $FuncType_218)) (field i32))))
  (type $ClosureType_240 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_241 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_242 (sub $ClosureBase_219 (struct (field (ref $FuncType_218)) (field i32))))
  (type $ClosureType_243 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_244 (sub $ClosureBase_219 (struct (field (ref $FuncType_218)) (field i32))))
  (type $ClosureType_245 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_246 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32) (field i32))))
  (type $ClosureType_247 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $FuncType_248 (func (param (ref $AnyFn)) (param (ref $MapModule_MapHandle`2)) (result i32)))
  (type $ClosureType_249 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_250 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_251 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_252 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_253 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_254 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_255 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_256 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_257 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_258 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_259 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_260 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_261 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_262 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_263 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_264 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_265 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_266 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_267 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_268 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_269 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_270 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_271 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_272 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_273 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_274 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_275 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_276 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_277 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_278 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_279 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_280 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_281 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_282 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_283 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_284 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_285 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_286 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_287 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_288 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_289 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_290 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_291 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_292 (sub $ClosureBase_219 (struct (field (ref $FuncType_218)) (field i32))))
  (type $ClosureType_293 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_294 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_295 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_296 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_297 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_298 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_299 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_300 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_301 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_302 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_303 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_304 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_305 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_306 (sub $ClosureBase_123 (struct (field (ref $FuncType_60)) (field i32))))
  (type $ClosureType_307 (sub $ClosureBase_123 (struct (field (ref $FuncType_60)) (field i32))))
  (type $ClosureType_308 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_309 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_310 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_311 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_312 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_313 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_314 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_315 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_316 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_317 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_318 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_319 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_320 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_321 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_322 (sub $ClosureBase_123 (struct (field (ref $FuncType_60)) (field i32) (field i32))))
  (type $ClosureType_323 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $FuncType_324 (func (param (ref $AnyFn)) (param i32) (result (ref null $ListBase))))
  (type $ClosureBase_325 (sub $AnyFn (struct (field (ref $FuncType_324)))))
  (type $ClosureType_326 (sub $ClosureBase_325 (struct (field (ref $FuncType_324)))))
  (type $ClosureType_327 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_328 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_329 (sub $ClosureBase_325 (struct (field (ref $FuncType_324)))))
  (type $ClosureType_330 (sub $ClosureBase_325 (struct (field (ref $FuncType_324)))))
  (type $ClosureType_331 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_332 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_333 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_334 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_335 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_336 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field i32))))
  (type $ClosureType_337 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_338 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_339 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_340 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_341 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_342 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_343 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_344 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_345 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_346 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_347 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_348 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_349 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_350 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_351 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_352 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_353 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_354 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_355 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_356 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_357 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_358 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_359 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_360 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_361 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_362 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_363 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $QuickTestWasmGc_TestsList_EnglishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $vtbl_QuickTestWasmGc_TestsList_IGreeter (sub (struct (field (ref $FuncType_177)))))
  (type $box_QuickTestWasmGc_TestsList_IGreeter (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsList_IGreeter)) (field (ref eq)))))
  (type $QuickTestWasmGc_TestsList_SpanishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $ClosureType_368 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_369 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_370 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_371 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_372 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_373 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_374 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_375 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $Tuple_376 (sub (struct (field (ref null $ListBase)) (field (ref null $ListBase)))))
  (type $ClosureType_377 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_378 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_379 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_380 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_381 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_382 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_383 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_384 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_385 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ListCons_386 (sub $ListBase (struct (field (ref $WasmStr)) (field (ref null $ListBase)))))
  (type $FuncType_387 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $WasmStr)) (result i32)))
  (type $ClosureBase_388 (sub $AnyFn (struct (field (ref $FuncType_387)))))
  (type $ClosureType_389 (sub $ClosureBase_388 (struct (field (ref $FuncType_387)))))
  (type $GcArray_390 (array (mut (ref null $WasmStr))))
  (type $ClosureType_391 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_392 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_393 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_394 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $Tuple_395 (sub (struct (field i32) (field (ref null $ListBase)))))
  (type $ListCons_396 (sub $ListBase (struct (field (ref $Tuple_395)) (field (ref null $ListBase)))))
  (type $ClosureType_397 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_398 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_399 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsList_MathExpr (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsList_MathExpr#0 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsList_MathExpr#1 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsList_MathExpr)) (field (ref $QuickTestWasmGc_TestsList_MathExpr)))))
  (type $QuickTestWasmGc_TestsList_MathExpr#2 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsList_MathExpr)) (field (ref $QuickTestWasmGc_TestsList_MathExpr)))))
  (type $ClosureType_404 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_405 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_406 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_407 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $ClosureType_408 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_409 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_410 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_411 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_412 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_413 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_414 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_415 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_416 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_417 (sub $ClosureBase_213 (struct (field (ref $FuncType_212)) (field i32) (field i32))))
  (type $ClosureType_418 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_419 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_420 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_421 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_422 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_423 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_424 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_425 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_426 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_427 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_428 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $QuickTestWasmGc_TestsPrimitives_Point (sub (struct (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsPrimitives_Counter (sub (struct (field (mut i32)))))
  (type $QuickTestWasmGc_TestsPrimitives_Rect (sub (struct (field (ref $QuickTestWasmGc_TestsPrimitives_Point)) (field (ref $QuickTestWasmGc_TestsPrimitives_Point)))))
  (type $Tuple_432 (sub (struct (field f64) (field f64))))
  (type $Tuple_433 (sub (struct (field i32) (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsPrimitives_SWItem (sub (struct (field i32))))
  (type $ListCons_435 (sub $ListBase (struct (field (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (field (ref null $ListBase)))))
  (type $FuncType_436 (func (param (ref $AnyFn)) (param (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (result i32)))
  (type $ClosureBase_437 (sub $AnyFn (struct (field (ref $FuncType_436)))))
  (type $ClosureType_438 (sub $ClosureBase_437 (struct (field (ref $FuncType_436)))))
  (type $ClosureType_439 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $GcArray_440 (array (mut (ref $QuickTestWasmGc_TestsPrimitives_SWItem))))
  (type $FuncType_441 (func (param (ref $AnyFn)) (param i32) (result (ref $WasmStr))))
  (type $ClosureBase_442 (sub $AnyFn (struct (field (ref $FuncType_441)))))
  (type $ClosureType_443 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $ClosureType_444 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $FuncType_445 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureBase_446 (sub $AnyFn (struct (field (ref $FuncType_445)))))
  (type $ClosureType_447 (sub $ClosureBase_446 (struct (field (ref $FuncType_445)) (field (ref $AnyFn)))))
  (type $ClosureType_448 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $ClosureType_449 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $ClosureType_450 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $FuncType_451 (func (param (ref $AnyFn)) (param i32) (param i32) (result (ref $WasmStr))))
  (type $Tuple_452 (sub (struct (field (ref $WasmStr)) (field (ref $WasmStr)))))
  (type $FuncType_453 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (result (ref $AnyFn))))
  (type $ClosureType_454 (sub $ClosureBase_446 (struct (field (ref $FuncType_445)) (field (ref $AnyFn)))))
  (type $ClosureBase_455 (sub $AnyFn (struct (field (ref $FuncType_453)))))
  (type $ClosureType_456 (sub $ClosureBase_455 (struct (field (ref $FuncType_453)) (field (ref $AnyFn)))))
  (type $FuncType_457 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureType_458 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $ClosureType_459 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $Tuple_460 (sub (struct (field i32) (field (ref $WasmStr)))))
  (type $ClosureType_461 (sub $ClosureBase_446 (struct (field (ref $FuncType_445)) (field (ref $AnyFn)))))
  (type $ClosureType_462 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $FuncType_463 (func (param (ref $AnyFn)) (param i32) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureType_464 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $ClosureType_465 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $FuncType_466 (func (param (ref $AnyFn)) (param f64) (result (ref $WasmStr))))
  (type $ClosureBase_467 (sub $AnyFn (struct (field (ref $FuncType_466)))))
  (type $ClosureType_468 (sub $ClosureBase_467 (struct (field (ref $FuncType_466)) (field (ref $AnyFn)))))
  (type $ClosureType_469 (sub $ClosureBase_467 (struct (field (ref $FuncType_466)) (field (ref $AnyFn)))))
  (type $ClosureType_470 (sub $ClosureBase_467 (struct (field (ref $FuncType_466)) (field (ref $AnyFn)))))
  (type $ClosureType_471 (sub $ClosureBase_467 (struct (field (ref $FuncType_466)) (field (ref $AnyFn)))))
  (type $ClosureType_472 (sub $ClosureBase_467 (struct (field (ref $FuncType_466)) (field (ref $AnyFn)))))
  (type $ClosureType_473 (sub $ClosureBase_123 (struct (field (ref $FuncType_60)) (field (ref $AnyFn)))))
  (type $FuncType_474 (func (param (ref $AnyFn)) (param (ref $WasmStr))))
  (type $ClosureBase_475 (sub $AnyFn (struct (field (ref $FuncType_474)))))
  (type $ClosureType_476 (sub $ClosureBase_475 (struct (field (ref $FuncType_474)) (field (ref $AnyFn)))))
  (type $ClosureType_477 (sub $ClosureBase_123 (struct (field (ref $FuncType_60)) (field (ref $AnyFn)))))
  (type $ClosureType_478 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $ClosureType_479 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $FuncType_480 (func (param (ref $AnyFn)) (param i32) (param i32) (param i32)))
  (type $ClosureType_481 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $ClosureType_482 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $ClosureType_483 (sub $ClosureBase_446 (struct (field (ref $FuncType_445)) (field (ref $AnyFn)))))
  (type $ClosureType_484 (sub $ClosureBase_442 (struct (field (ref $FuncType_441)) (field (ref $AnyFn)))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field (ref $WasmStr)))))
  (type $ClosureType_491 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $FuncType_492 (func (param (ref $AnyFn)) (param i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))))
  (type $ClosureBase_493 (sub $AnyFn (struct (field (ref $FuncType_492)))))
  (type $ClosureType_494 (sub $ClosureBase_493 (struct (field (ref $FuncType_492)))))
  (type $ClosureType_495 (sub $ClosureBase_493 (struct (field (ref $FuncType_492)))))
  (type $ClosureType_496 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_497 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_498 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_499 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_500 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_501 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_502 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_503 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_504 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_505 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_506 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_507 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_508 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_509 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_510 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_511 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_512 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_513 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_514 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_515 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_516 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_517 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_518 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_519 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_520 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_521 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_522 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_523 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_524 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_525 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32) (field i32))))
  (type $ClosureType_526 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_527 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $FuncType_528 (func (param (ref $AnyFn)) (param (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))))
  (type $ClosureBase_529 (sub $AnyFn (struct (field (ref $FuncType_528)))))
  (type $ClosureType_530 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_531 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_532 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_533 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_534 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_535 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_536 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_537 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_538 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_539 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_540 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_541 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_542 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_543 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_544 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_545 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_546 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_547 (sub $ClosureBase_529 (struct (field (ref $FuncType_528)) (field i32))))
  (type $ClosureType_548 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_549 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_550 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_551 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_552 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_553 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_554 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_555 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_556 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_557 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_558 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_559 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_560 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_561 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_562 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_563 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_564 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_565 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_566 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_567 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_568 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_569 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $FuncType_570 (func (param (ref $AnyFn)) (param (ref $Tuple_90)) (result i32)))
  (type $ClosureBase_571 (sub $AnyFn (struct (field (ref $FuncType_570)))))
  (type $ClosureType_572 (sub $ClosureBase_571 (struct (field (ref $FuncType_570)))))
  (type $ClosureType_573 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field (ref $AnyFn)))))
  (type $ClosureType_574 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_575 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_576 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_577 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_578 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_579 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_580 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_581 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_582 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_583 (sub $ClosureBase_158 (struct (field (ref $FuncType_157)))))
  (type $ClosureType_584 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_585 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_586 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_587 (sub $ClosureBase_325 (struct (field (ref $FuncType_324)))))
  (type $ClosureType_588 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_589 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_590 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_591 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_592 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_593 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_594 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_595 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_596 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_597 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_598 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_599 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_600 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_601 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_602 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_603 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $ClosureType_604 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_605 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_606 (sub $ClosureBase_22 (struct (field (ref $FuncType_21)))))
  (type $ClosureType_607 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_608 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field i32))))
  (type $ClosureType_609 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field i32))))
  (type $ClosureType_610 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_611 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_612 (sub $ClosureBase_131 (struct (field (ref $FuncType_130)))))
  (type $ClosureType_613 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $FuncType_614 (func (param (ref $AnyFn)) (param (ref $StringBuilder))))
  (type $ClosureBase_615 (sub $AnyFn (struct (field (ref $FuncType_614)))))
  (type $ClosureType_616 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_617 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_618 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_619 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_620 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_621 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_622 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_623 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_624 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $QuickTestWasmGc_TestsStrings_Shape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Shape#0 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Shape#1 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Shape#2 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Tree (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Tree#0 (sub $QuickTestWasmGc_TestsStrings_Tree (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Tree#1 (sub $QuickTestWasmGc_TestsStrings_Tree (struct (field i32) (field (ref $QuickTestWasmGc_TestsStrings_Tree)) (field (ref $QuickTestWasmGc_TestsStrings_Tree)) (field i32))))
  (type $GcArray_632 (array (mut (ref $WasmStr))))
  (type $ClosureType_633 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_634 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $ClosureType_635 (sub $ClosureBase_615 (struct (field (ref $FuncType_614)))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#0 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#1 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $FuncType_639 (func (param (ref $AnyFn)) (param (ref $AnyFn))))
  (type $ClosureBase_640 (sub $AnyFn (struct (field (ref $FuncType_639)))))
  (type $ClosureType_641 (sub $ClosureBase_640 (struct (field (ref $FuncType_639)) (field i32) (field i32))))
  (type $ClosureType_642 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32) (field i32))))
  (type $ClosureBase_643 (sub $AnyFn (struct (field (ref $FuncType_248)))))
  (type $ClosureBase_644 (sub $AnyFn (struct (field (ref $FuncType_480)))))
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
  (func $strSplit (param $ssp_src (ref $WasmStr)) (param $ssp_del (ref $WasmStr)) (result (ref $GcArray_632))
    (local $ssp_dl i32)
    (local $ssp_pos i32)
    (local $ssp_cnt i32)
    (local $ssp_j i32)
    (local $ssp_arr (ref $GcArray_632))
    (local $ssp_idx i32)
    local.get $ssp_del
    array.len
    local.set $ssp_dl
    local.get $ssp_dl
    i32.const 0
    i32.eq
    if (result (ref $GcArray_632))
      local.get $ssp_src
      array.new_fixed $GcArray_632 1
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
      array.new $GcArray_632
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
            array.set $GcArray_632
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
      array.set $GcArray_632
      local.get $ssp_arr
    end
  )
  (func $strJoin (param $sj_sep (ref $WasmStr)) (param $sj_arr (ref $GcArray_632)) (result (ref $WasmStr))
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
        array.get $GcArray_632
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
              array.get $GcArray_632
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
  (func $equals_4 (param $eq_a (ref $QuickTestWasmGc_TestsDU_Shape)) (param $eq_b (ref $QuickTestWasmGc_TestsDU_Shape)) (result i32)
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
    call $equals_4
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
    call $equals_4
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
    call $equals_4
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $runDUTests (param $check (ref $AnyFn)) ;; exported as "runDUTests"
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
  (func $closure_21 (param $self (ref $AnyFn)) (result i32)
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
    (local $f (ref $ClosureType_23))
    (local $lo_clo_1 (ref $ClosureBase_49))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                ref.func $closure_21
                struct.new $ClosureType_23
                local.set $f
                local.get $f
                ref.cast (ref $ClosureBase_49)
                local.set $lo_clo_1
                local.get $lo_clo_1
                local.get $lo_clo_1
                struct.get $ClosureBase_49 0
                call_ref $FuncType_24
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
  (func $closure_25 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
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
    (local $lo_clo_3 (ref $ClosureBase_26))
    (local $lo_clo_2 (ref $ClosureBase_26))
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_3
    local.get $lo_clo_3
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_2
    local.get $lo_clo_2
    local.get $x
    local.get $lo_clo_2
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $lo_clo_3
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_28 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
  )
  (func $testApplyTwice (param $x i32) (result i32) ;; exported as "testApplyTwice"
    ref.func $closure_28
    struct.new $ClosureType_28
    local.get $x
    return_call $applyTwice
  )
  (func $makeMultiplier (param $n i32) (param $x i32) (result i32) ;; exported as "makeMultiplier"
    local.get $x
    local.get $n
    i32.mul
  )
  (func $closure_29 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_29))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_29)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_29 1
    local.set $n
    local.get $n
    local.get $x_1
    call $makeMultiplier
  )
  (func $testLetCapture (param $n i32) (param $x i32) (result i32) ;; exported as "testLetCapture"
    (local $mult (ref $ClosureType_29))
    (local $lo_clo_4 (ref $ClosureBase_26))
    ref.func $closure_29
    local.get $n
    struct.new $ClosureType_29
    local.set $mult
    local.get $mult
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_4
    local.get $lo_clo_4
    local.get $x
    local.get $lo_clo_4
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_31 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_30 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w8 (ref null $ListBase))
    (local $w9 i32)
    local.get $list_1
    local.set $w8
    i32.const 0
    local.set $w9
    block $while_10_exit
      loop $while_10_lp
        local.get $w8
        ref.is_null
        i32.eqz
        if
          local.get $w9
          local.get $w8
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w9
          local.get $w8
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w8
          br $while_10_lp
        else
          br $while_10_exit
        end
      end
    end
    local.get $w9
  )
  (func $closure_35 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_35))
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_35)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_35 1
    local.set $offset
    local.get $x
    local.get $offset
    i32.add
  )
  (func $closure_36 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testClosureCapMap (result i32) ;; exported as "testClosureCapMap"
    (local $lo_clo_6 (ref $ClosureBase_33))
    (local $lo_clo_5 (ref $ClosureBase_37))
    (local $mapping (ref $ClosureType_35))
    ref.func $closure_30
    struct.new $ClosureType_34
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_6
    local.get $lo_clo_6
    ref.func $closure_35
    i32.const 10
    struct.new $ClosureType_35
    local.set $mapping
    ref.func $closure_36
    local.get $mapping
    struct.new $ClosureType_38
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_5
    local.get $lo_clo_5
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_5
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_6
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_39 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w12 (ref null $ListBase))
    (local $w13 i32)
    local.get $list_1
    local.set $w12
    i32.const 0
    local.set $w13
    block $while_14_exit
      loop $while_14_lp
        local.get $w12
        ref.is_null
        i32.eqz
        if
          local.get $w13
          i32.const 1
          i32.add
          local.set $w13
          local.get $w12
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w12
          br $while_14_lp
        else
          br $while_14_exit
        end
      end
    end
    local.get $w13
  )
  (func $closure_40 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_40))
    (local $threshold i32)
    local.get $self
    ref.cast (ref $ClosureType_40)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_40 1
    local.set $threshold
    local.get $x
    local.get $threshold
    i32.gt_s
  )
  (func $closure_41 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testClosureCapFilter (result i32) ;; exported as "testClosureCapFilter"
    (local $lo_clo_8 (ref $ClosureBase_33))
    (local $lo_clo_7 (ref $ClosureBase_37))
    (local $predicate (ref $ClosureType_40))
    ref.func $closure_39
    struct.new $ClosureType_39
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_8
    local.get $lo_clo_8
    ref.func $closure_40
    i32.const 3
    struct.new $ClosureType_40
    local.set $predicate
    ref.func $closure_41
    local.get $predicate
    struct.new $ClosureType_41
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_7
    local.get $lo_clo_7
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_7
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_8
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_42 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_42))
    (local $acc i32)
    (local $multiplier i32)
    local.get $self
    ref.cast (ref $ClosureType_42)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_42 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_42 2
    local.set $multiplier
    local.get $acc
    local.get $x
    local.get $multiplier
    i32.mul
    i32.add
  )
  (func $closure_42 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_45))
    (local $multiplier i32)
    local.get $self
    ref.cast (ref $ClosureType_45)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_45 1
    local.set $multiplier
    ref.func $closure_42
    local.get $acc
    local.get $multiplier
    struct.new $ClosureType_42
  )
  (func $testClosureCapFold (result i32) ;; exported as "testClosureCapFold"
    (local $w16 (ref null $ListBase))
    (local $w17 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w16
    i32.const 0
    local.set $w17
    block $while_18_exit
      loop $while_18_lp
        local.get $w16
        ref.is_null
        i32.eqz
        if
          local.get $w16
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $w17
          local.get $x
          i32.const 1
          i32.shl
          i32.add
          local.set $w17
          local.get $w16
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w16
          br $while_18_lp
        else
          br $while_18_exit
        end
      end
    end
    local.get $w17
  )
  (func $closure_46 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_46))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_46)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_46 1
    local.set $n
    local.get $x
    local.get $n
    i32.add
  )
  (func $closure_46 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_46
    local.get $n
    struct.new $ClosureType_46
  )
  (func $testClosureHigherOrder (result i32) ;; exported as "testClosureHigherOrder"
    (local $makeAdder_1 (ref $ClosureType_47))
    (local $add5 (ref $AnyFn))
    (local $lo_clo_9 (ref $ClosureBase_44))
    (local $add10 (ref $AnyFn))
    (local $lo_clo_10 (ref $ClosureBase_44))
    (local $lo_clo_11 (ref $ClosureBase_26))
    (local $lo_clo_12 (ref $ClosureBase_26))
    ref.func $closure_46
    struct.new $ClosureType_47
    local.set $makeAdder_1
    local.get $makeAdder_1
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_9
    local.get $lo_clo_9
    i32.const 5
    local.get $lo_clo_9
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $add5
    local.get $makeAdder_1
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_10
    local.get $lo_clo_10
    i32.const 10
    local.get $lo_clo_10
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $add10
    local.get $add5
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_11
    local.get $lo_clo_11
    i32.const 3
    local.get $lo_clo_11
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $add10
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_12
    local.get $lo_clo_12
    i32.const 7
    local.get $lo_clo_12
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    i32.add
  )
  (func $closure_49 (param $self (ref $AnyFn))
    (local $self_cast (ref $ClosureType_50))
    (local $counter (ref $RefCell_48))
    local.get $self
    ref.cast (ref $ClosureType_50)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_50 1
    local.set $counter
    local.get $counter
    local.get $counter
    struct.get $RefCell_48 0
    i32.const 1
    i32.add
    struct.set $RefCell_48 0
  )
  (func $testClosureCapRef (result i32) ;; exported as "testClosureCapRef"
    (local $counter (ref $RefCell_48))
    (local $increment (ref $ClosureType_50))
    (local $lo_clo_13 (ref $ClosureBase_49))
    (local $lo_clo_14 (ref $ClosureBase_49))
    (local $lo_clo_15 (ref $ClosureBase_49))
    i32.const 0
    struct.new $RefCell_48
    local.set $counter
    ref.func $closure_49
    local.get $counter
    struct.new $ClosureType_50
    local.set $increment
    local.get $increment
    ref.cast (ref $ClosureBase_49)
    local.set $lo_clo_13
    local.get $lo_clo_13
    local.get $lo_clo_13
    struct.get $ClosureBase_49 0
    call_ref $FuncType_24
    local.get $increment
    ref.cast (ref $ClosureBase_49)
    local.set $lo_clo_14
    local.get $lo_clo_14
    local.get $lo_clo_14
    struct.get $ClosureBase_49 0
    call_ref $FuncType_24
    local.get $increment
    ref.cast (ref $ClosureBase_49)
    local.set $lo_clo_15
    local.get $lo_clo_15
    local.get $lo_clo_15
    struct.get $ClosureBase_49 0
    call_ref $FuncType_24
    local.get $counter
    struct.get $RefCell_48 0
  )
  (func $closure_51 (param $self (ref $AnyFn)) (param $m i32) (result i32)
    (local $self_cast (ref $ClosureType_51))
    (local $base_ i32)
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_51)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_51 1
    local.set $base_
    local.get $self_cast
    struct.get $ClosureType_51 2
    local.set $n
    local.get $base_
    local.get $n
    i32.add
    local.get $m
    i32.add
  )
  (func $closure_51 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_52))
    (local $base_ i32)
    local.get $self
    ref.cast (ref $ClosureType_52)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_52 1
    local.set $base_
    ref.func $closure_51
    local.get $base_
    local.get $n
    struct.new $ClosureType_51
  )
  (func $testClosureNestedCapture (result i32) ;; exported as "testClosureNestedCapture"
    (local $outer (ref $ClosureType_52))
    (local $f (ref $AnyFn))
    (local $lo_clo_16 (ref $ClosureBase_44))
    (local $lo_clo_17 (ref $ClosureBase_26))
    ref.func $closure_51
    i32.const 100
    struct.new $ClosureType_52
    local.set $outer
    local.get $outer
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_16
    local.get $lo_clo_16
    i32.const 5
    local.get $lo_clo_16
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $f
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_17
    local.get $lo_clo_17
    i32.const 3
    local.get $lo_clo_17
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $runClosuresTests (param $check (ref $AnyFn)) ;; exported as "runClosuresTests"
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
    (local $lo_clo_18 (ref $ClosureBase_123))
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
      ref.cast (ref $ClosureBase_123)
      local.set $lo_clo_18
      local.get $lo_clo_18
      local.get $v
      local.get $lo_clo_18
      struct.get $ClosureBase_123 0
      call_ref $FuncType_60
      local.get $action
      local.get $r
      call $nodeIter_i32
    end
  )
  (func $Set_nodeIter (param $action (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_19 (ref $ClosureBase_123))
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
      ref.cast (ref $ClosureBase_123)
      local.set $lo_clo_19
      local.get $lo_clo_19
      local.get $v
      local.get $lo_clo_19
      struct.get $ClosureBase_123 0
      call_ref $FuncType_60
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
    (local $lo_clo_20 (ref $ClosureBase_26))
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
      ref.cast (ref $ClosureBase_26)
      local.set $lo_clo_20
      local.get $lo_clo_20
      local.get $v
      local.get $lo_clo_20
      struct.get $ClosureBase_26 0
      call_ref $FuncType_25
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
    (local $lo_clo_21 (ref $ClosureBase_26))
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
      ref.cast (ref $ClosureBase_26)
      local.set $lo_clo_21
      local.get $lo_clo_21
      local.get $v
      local.get $lo_clo_21
      struct.get $ClosureBase_26 0
      call_ref $FuncType_25
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
    (local $lo_clo_22 (ref $ClosureBase_26))
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
      ref.cast (ref $ClosureBase_26)
      local.set $lo_clo_22
      local.get $lo_clo_22
      local.get $v
      local.get $lo_clo_22
      struct.get $ClosureBase_26 0
      call_ref $FuncType_25
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
    (local $lo_clo_23 (ref $ClosureBase_26))
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
      ref.cast (ref $ClosureBase_26)
      local.set $lo_clo_23
      local.get $lo_clo_23
      local.get $v
      local.get $lo_clo_23
      struct.get $ClosureBase_26 0
      call_ref $FuncType_25
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
    (local $lo_clo_24 (ref $ClosureBase_26))
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
      ref.cast (ref $ClosureBase_26)
      local.set $lo_clo_24
      local.get $lo_clo_24
      local.get $v
      local.get $lo_clo_24
      struct.get $ClosureBase_26 0
      call_ref $FuncType_25
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
    (local $lo_clo_25 (ref $ClosureBase_26))
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
      ref.cast (ref $ClosureBase_26)
      local.set $lo_clo_25
      local.get $lo_clo_25
      local.get $v
      local.get $lo_clo_25
      struct.get $ClosureBase_26 0
      call_ref $FuncType_25
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
      struct.new $ListCons_30
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
      struct.new $ListCons_30
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
  (func $closure_61 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    (local $self_cast (ref $ClosureType_61))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_61)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_61 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_61 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_61
    local.get $n
    struct.new $ClosureType_61
  )
  (func $closure_63 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    (local $self_cast (ref $ClosureType_63))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_63)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_63 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_63 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_63
    local.get $n
    struct.new $ClosureType_63
  )
  (func $Set_count (param $s (ref $SetModule_SetHandle`1)) (result i32)
    ref.func $closure_63
    struct.new $ClosureType_64
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
  (func $closure_65 (param $self (ref $AnyFn)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_67))
    (local $acc (ref $SetModule_SetNode`1<i32>))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_26 (ref $ClosureBase_26))
    local.get $self
    ref.cast (ref $ClosureType_67)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_67 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_67 2
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_67 3
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_26
    local.get $lo_clo_26
    local.get $v
    local.get $lo_clo_26
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $acc
    call $nodeAdd_i32
  )
  (func $closure_65 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_70))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_70)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_70 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_70 2
    local.set $s
    ref.func $closure_65
    local.get $acc
    local.get $mapping
    local.get $s
    struct.new $ClosureType_67
  )
  (func $closure_71 (param $self (ref $AnyFn)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_71))
    (local $acc (ref $SetModule_SetNode`1<i32>))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_27 (ref $ClosureBase_26))
    local.get $self
    ref.cast (ref $ClosureType_71)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_71 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_71 2
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_71 3
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_27
    local.get $lo_clo_27
    local.get $v
    local.get $lo_clo_27
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $acc
    call $nodeAdd_i32
  )
  (func $closure_71 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_72))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_72)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_72 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_72 2
    local.set $s
    ref.func $closure_71
    local.get $acc
    local.get $mapping
    local.get $s
    struct.new $ClosureType_71
  )
  (func $nodeFold_ref57~i32 (param $folder (ref $AnyFn)) (param $state (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
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
      call $nodeFold_ref57~i32
      local.set $s1
      local.get $s2
      local.get $r
      call $nodeFold_ref57~i32
    else
      local.get $state
    end
  )
  (func $Set_map (param $mapping (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $mapped (ref $SetModule_SetNode`1<i32>))
    ref.func $closure_71
    local.get $mapping
    local.get $s
    struct.new $ClosureType_72
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeFold_ref57~i32
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
  (func $closure_73 (param $self (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_75))
    (local $acc (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_75)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_75 1
    local.set $acc
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $closure_73 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))
    ref.func $closure_73
    local.get $acc
    struct.new $ClosureType_75
  )
  (func $empty_i32 (param $cmp (ref $AnyFn)) (result (ref $SetModule_SetHandle`1))
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_ofList (param $cmp (ref $AnyFn)) (param $xs (ref null $ListBase)) (result (ref $SetModule_SetHandle`1))
    (local $w20 (ref null $ListBase))
    (local $w21 (ref $SetModule_SetHandle`1))
    (local $x i32)
    local.get $xs
    local.set $w20
    call $empty_i32
    local.set $w21
    block $while_22_exit
      loop $while_22_lp
        local.get $w20
        ref.is_null
        i32.eqz
        if
          local.get $w20
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w21
          call $add_i32
          local.set $w21
          local.get $w20
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w20
          br $while_22_lp
        else
          br $while_22_exit
        end
      end
    end
    local.get $w21
  )
  (func $closure_80 (param $self (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_80))
    (local $acc (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_80)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_80 1
    local.set $acc
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $closure_80 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))
    ref.func $closure_80
    local.get $acc
    struct.new $ClosureType_80
  )
  (func $Set_ofArray (param $cmp (ref $AnyFn)) (param $xs (ref $GcArray_79)) (result (ref $SetModule_SetHandle`1))
    (local $w25 i32)
    (local $w26 (ref $SetModule_SetHandle`1))
    (local $w27 i32)
    (local $x i32)
    local.get $xs
    array.len
    local.set $w25
    call $empty_i32
    local.set $w26
    i32.const 0
    local.set $w27
    block $while_28_exit
      loop $while_28_lp
        local.get $w27
        local.get $w25
        i32.lt_s
        if
          local.get $xs
          local.get $w27
          array.get $GcArray_79
          local.set $x
          local.get $x
          local.get $w26
          call $add_i32
          local.set $w26
          local.get $w27
          i32.const 1
          i32.add
          local.set $w27
          br $while_28_lp
        else
          br $while_28_exit
        end
      end
    end
    local.get $w26
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
  (func $nodeTryFind_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_89))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_89))
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
      if (result (ref null $Option_89))
        local.get $key
        local.get $l
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_89))
          local.get $key
          local.get $r
          call $nodeTryFind_i32~i32
        else
          local.get $v
          struct.new $Option_89
        end
      end
    else
      ref.null $Option_89
    end
  )
  (func $Map_nodeTryFind (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_89))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_89))
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
      if (result (ref null $Option_89))
        local.get $key
        local.get $l
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_89))
          local.get $key
          local.get $r
          call $nodeTryFind_i32~i32
        else
          local.get $v
          struct.new $Option_89
        end
      end
    else
      ref.null $Option_89
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
      struct.new $Tuple_90
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_91
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
      struct.new $Tuple_90
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_91
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
  (func $Map_tryFind (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_89))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeTryFind_i32~i32
  )
  (func $tryFind_i32~i32 (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_89))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeTryFind_i32~i32
  )
  (func $Map_find (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    (local $matchValue (ref null $Option_89))
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
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
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
  (func $closure_92 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_92))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_92)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_92 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_92 (param $self (ref $AnyFn)) (param $_arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_93))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_93)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_93 1
    local.set $n
    ref.func $closure_92
    local.get $n
    struct.new $ClosureType_92
  )
  (func $closure_92 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_92
    local.get $n
    struct.new $ClosureType_93
  )
  (func $closure_95 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_95))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_95)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_95 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_95 (param $self (ref $AnyFn)) (param $_arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_96))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_96)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_96 1
    local.set $n
    ref.func $closure_95
    local.get $n
    struct.new $ClosureType_95
  )
  (func $closure_95 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_95
    local.get $n
    struct.new $ClosureType_96
  )
  (func $Map_count (param $m (ref $MapModule_MapHandle`2)) (result i32)
    ref.func $closure_95
    struct.new $ClosureType_97
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
      ref.cast (ref $ListCons_91)
      struct.get $ListCons_91 0
      struct.get $Tuple_90 1
      local.set $v
      local.get $pairs
      ref.cast (ref $ListCons_91)
      struct.get $ListCons_91 1
      local.set $rest
      local.get $pairs
      ref.cast (ref $ListCons_91)
      struct.get $ListCons_91 0
      struct.get $Tuple_90 0
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
      ref.cast (ref $ListCons_91)
      struct.get $ListCons_91 0
      struct.get $Tuple_90 1
      local.set $v
      local.get $pairs
      ref.cast (ref $ListCons_91)
      struct.get $ListCons_91 1
      local.set $rest
      local.get $pairs
      ref.cast (ref $ListCons_91)
      struct.get $ListCons_91 0
      struct.get $Tuple_90 0
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
    (local $lo_clo_28 (ref $ClosureBase_26))
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_28
    local.get $lo_clo_28
    local.get $x
    local.get $lo_clo_28
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
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
    (local $lo_clo_30 (ref $ClosureBase_26))
    (local $lo_clo_29 (ref $ClosureBase_26))
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_30
    local.get $lo_clo_30
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_29
    local.get $lo_clo_29
    local.get $x
    local.get $lo_clo_29
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $lo_clo_30
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $makeMultiplier (param $n i32) (param $x i32) (result i32) ;; exported as "makeMultiplier"
    local.get $x
    local.get $n
    i32.mul
  )
  (func $optionOrDefault (param $opt (ref null $Option_89)) (param $def i32) (result i32) ;; exported as "optionOrDefault"
    local.get $opt
    ref.is_null
    if (result i32)
      local.get $def
    else
      local.get $opt
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $optionDouble (param $opt (ref null $Option_89)) (result i32) ;; exported as "optionDouble"
    (local $v i32)
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $opt
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
      local.set $v
      local.get $v
      i32.const 1
      i32.shl
    end
  )
  (func $optionIsSome (param $opt (ref null $Option_89)) (result i32) ;; exported as "optionIsSome"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
  )
  (func $optionIsNone (param $opt (ref null $Option_89)) (result i32) ;; exported as "optionIsNone"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $optionNested (param $v i32) (result i32) ;; exported as "optionNested"
    (local $outer (ref null $Option_98))
    (local $inner (ref null $Option_89))
    local.get $v
    struct.new $Option_89
    struct.new $Option_98
    local.set $outer
    local.get $outer
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $outer
      ref.cast (ref $Option_98)
      struct.get $Option_98 0
      local.set $inner
      local.get $inner
      ref.is_null
      if (result i32)
        i32.const -2
      else
        local.get $inner
        ref.cast (ref $Option_89)
        struct.get $Option_89 0
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
  (func $testArrayLiteral (result i32) ;; exported as "testArrayLiteral"
    (local $arr (ref $GcArray_79))
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_79 3
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_79
  )
  (func $testArrayCreate (result i32) ;; exported as "testArrayCreate"
    (local $arr (ref $GcArray_79))
    i32.const 0
    i32.const 3
    array.new $GcArray_79
    local.set $arr
    local.get $arr
    i32.const 0
    i32.const 10
    array.set $GcArray_79
    local.get $arr
    i32.const 1
    i32.const 20
    array.set $GcArray_79
    local.get $arr
    i32.const 2
    i32.const 30
    array.set $GcArray_79
    local.get $arr
    i32.const 0
    array.get $GcArray_79
    local.get $arr
    i32.const 1
    array.get $GcArray_79
    i32.add
    local.get $arr
    i32.const 2
    array.get $GcArray_79
    i32.add
  )
  (func $testArrayZeroCreate (result i32) ;; exported as "testArrayZeroCreate"
    (local $arr (ref $GcArray_79))
    i32.const 0
    i32.const 4
    array.new $GcArray_79
    local.set $arr
    local.get $arr
    i32.const 2
    i32.const 7
    array.set $GcArray_79
    local.get $arr
    i32.const 2
    array.get $GcArray_79
  )
  (func $testArrayLength (result i32) ;; exported as "testArrayLength"
    (local $arr (ref $GcArray_79))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $arr
    local.get $arr
    array.len
  )
  (func $testArraySumLoop (result i32) ;; exported as "testArraySumLoop"
    (local $arr (ref $GcArray_79))
    (local $s i32)
    (local $i i32)
    (local $limit i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
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
        array.get $GcArray_79
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
    (local $arr (ref $GcArray_99))
    f64.const 1
    f64.const 3.1400000000000001
    f64.const 2.71
    array.new_fixed $GcArray_99 3
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_99
  )
  (func $closure_100 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_100))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_100)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_100 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_100 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_100
    local.get $acc
    struct.new $ClosureType_100
  )
  (func $testArrayFold (result i32) ;; exported as "testArrayFold"
    (local $w35 (ref $GcArray_79))
    (local $w36 i32)
    (local $w37 i32)
    (local $w38 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w35
    local.get $w35
    array.len
    local.set $w36
    i32.const 0
    local.set $w37
    i32.const 0
    local.set $w38
    block $while_39_exit
      loop $while_39_lp
        local.get $w38
        local.get $w36
        i32.lt_s
        if
          local.get $w35
          local.get $w38
          array.get $GcArray_79
          local.set $x
          local.get $w37
          local.get $x
          i32.add
          local.set $w37
          local.get $w38
          i32.const 1
          i32.add
          local.set $w38
          br $while_39_lp
        else
          br $while_39_exit
        end
      end
    end
    local.get $w37
  )
  (func $closure_102 (param $self (ref $AnyFn)) (param $x f64) (result f64)
    (local $self_cast (ref $ClosureType_104))
    (local $acc f64)
    local.get $self
    ref.cast (ref $ClosureType_104)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_104 1
    local.set $acc
    local.get $acc
    local.get $x
    f64.add
  )
  (func $closure_102 (param $self (ref $AnyFn)) (param $acc f64) (result (ref $AnyFn))
    ref.func $closure_102
    local.get $acc
    struct.new $ClosureType_104
  )
  (func $testArrayFoldFloat (result f64) ;; exported as "testArrayFoldFloat"
    (local $w41 (ref $GcArray_99))
    (local $w42 i32)
    (local $w43 f64)
    (local $w44 i32)
    (local $x f64)
    f64.const 0.5
    f64.const 0.5
    f64.const 0.5
    array.new_fixed $GcArray_99 3
    local.set $w41
    local.get $w41
    array.len
    local.set $w42
    f64.const 0
    local.set $w43
    i32.const 0
    local.set $w44
    block $while_45_exit
      loop $while_45_lp
        local.get $w44
        local.get $w42
        i32.lt_s
        if
          local.get $w41
          local.get $w44
          array.get $GcArray_99
          local.set $x
          local.get $w43
          local.get $x
          f64.add
          local.set $w43
          local.get $w44
          i32.const 1
          i32.add
          local.set $w44
          br $while_45_lp
        else
          br $while_45_exit
        end
      end
    end
    local.get $w43
  )
  (func $closure_108 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testArrayMap (result i32) ;; exported as "testArrayMap"
    (local $result (ref $GcArray_79))
    (local $w47 (ref $GcArray_79))
    (local $w48 i32)
    (local $w49 (ref $GcArray_79))
    (local $w51 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w47
    local.get $w47
    array.len
    local.set $w48
    i32.const 0
    local.get $w48
    array.new $GcArray_79
    local.set $w49
    i32.const 0
    local.set $w51
    block $while_52_exit
      loop $while_52_lp
        local.get $w51
        local.get $w48
        i32.lt_s
        if
          local.get $w49
          local.get $w51
          local.get $w47
          local.get $w51
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          array.set $GcArray_79
          local.get $w51
          i32.const 1
          i32.add
          local.set $w51
          br $while_52_lp
        else
          br $while_52_exit
        end
      end
    end
    local.get $w49
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_79
    local.get $result
    i32.const 4
    array.get $GcArray_79
    i32.add
  )
  (func $closure_109 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul
  )
  (func $testArrayMapStr (result i32) ;; exported as "testArrayMapStr"
    (local $src (ref $GcArray_79))
    (local $doubled (ref $GcArray_79))
    (local $w55 i32)
    (local $w56 (ref $GcArray_79))
    (local $w58 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $src
    local.get $src
    array.len
    local.set $w55
    i32.const 0
    local.get $w55
    array.new $GcArray_79
    local.set $w56
    i32.const 0
    local.set $w58
    block $while_59_exit
      loop $while_59_lp
        local.get $w58
        local.get $w55
        i32.lt_s
        if
          local.get $w56
          local.get $w58
          local.get $src
          local.get $w58
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 3
          i32.mul
          array.set $GcArray_79
          local.get $w58
          i32.const 1
          i32.add
          local.set $w58
          br $while_59_lp
        else
          br $while_59_exit
        end
      end
    end
    local.get $w56
    local.set $doubled
    local.get $doubled
    i32.const 2
    array.get $GcArray_79
  )
  (func $closure_110 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_110))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_110)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_110 1
    local.set $i
    local.get $i
    local.get $x
    i32.add
  )
  (func $closure_110 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_110
    local.get $i
    struct.new $ClosureType_110
  )
  (func $testArrayMapi (result i32) ;; exported as "testArrayMapi"
    (local $arr (ref $GcArray_79))
    (local $w61 (ref $GcArray_79))
    (local $w62 i32)
    (local $w63 (ref $GcArray_79))
    (local $w65 i32)
    (local $x i32)
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_79 3
    local.set $w61
    local.get $w61
    array.len
    local.set $w62
    i32.const 0
    local.get $w62
    array.new $GcArray_79
    local.set $w63
    i32.const 0
    local.set $w65
    block $while_66_exit
      loop $while_66_lp
        local.get $w65
        local.get $w62
        i32.lt_s
        if
          local.get $w63
          local.get $w65
          local.get $w61
          local.get $w65
          array.get $GcArray_79
          local.set $x
          local.get $w65
          local.get $x
          i32.add
          array.set $GcArray_79
          local.get $w65
          i32.const 1
          i32.add
          local.set $w65
          br $while_66_lp
        else
          br $while_66_exit
        end
      end
    end
    local.get $w63
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_79
  )
  (func $closure_112 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testArrayFilter (result i32) ;; exported as "testArrayFilter"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w68 i32)
    (local $w69 i32)
    (local $w70 i32)
    (local $x i32)
    (local $w72 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $arr
    local.get $arr
    array.len
    local.set $w68
    i32.const 0
    local.set $w69
    i32.const 0
    local.set $w70
    block $while_71_exit
      loop $while_71_lp
        local.get $w70
        local.get $w68
        i32.lt_s
        if
          local.get $arr
          local.get $w70
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            local.get $w69
            i32.const 1
            i32.add
            local.set $w69
          end
          local.get $w70
          i32.const 1
          i32.add
          local.set $w70
          br $while_71_lp
        else
          br $while_71_exit
        end
      end
    end
    i32.const 0
    local.set $w72
    i32.const 0
    local.set $w70
    block $while_73_exit
      loop $while_73_lp
        local.get $w70
        local.get $w68
        i32.lt_s
        if
          local.get $arr
          local.get $w70
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            i32.const 0
            local.get $w69
            array.new $GcArray_79
            local.get $w72
            local.get $arr
            local.get $w70
            array.get $GcArray_79
            array.set $GcArray_79
            local.get $w72
            i32.const 1
            i32.add
            local.set $w72
          end
          local.get $w70
          i32.const 1
          i32.add
          local.set $w70
          br $while_73_lp
        else
          br $while_73_exit
        end
      end
    end
    i32.const 0
    local.get $w69
    array.new $GcArray_79
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_113 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayFilterAll (result i32) ;; exported as "testArrayFilterAll"
    (local $result (ref $GcArray_79))
    (local $w75 i32)
    (local $w76 i32)
    (local $w77 i32)
    (local $x i32)
    (local $w79 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    array.len
    local.set $w75
    i32.const 0
    local.set $w76
    i32.const 0
    local.set $w77
    block $while_78_exit
      loop $while_78_lp
        local.get $w77
        local.get $w75
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_79 5
          local.get $w77
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            local.get $w76
            i32.const 1
            i32.add
            local.set $w76
          end
          local.get $w77
          i32.const 1
          i32.add
          local.set $w77
          br $while_78_lp
        else
          br $while_78_exit
        end
      end
    end
    i32.const 0
    local.set $w79
    i32.const 0
    local.set $w77
    block $while_80_exit
      loop $while_80_lp
        local.get $w77
        local.get $w75
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_79 5
          local.get $w77
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            i32.const 0
            local.get $w76
            array.new $GcArray_79
            local.get $w79
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_79 5
            local.get $w77
            array.get $GcArray_79
            array.set $GcArray_79
            local.get $w79
            i32.const 1
            i32.add
            local.set $w79
          end
          local.get $w77
          i32.const 1
          i32.add
          local.set $w77
          br $while_80_lp
        else
          br $while_80_exit
        end
      end
    end
    i32.const 0
    local.get $w76
    array.new $GcArray_79
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_114 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayFilterNone (result i32) ;; exported as "testArrayFilterNone"
    (local $result (ref $GcArray_79))
    (local $w82 i32)
    (local $w83 i32)
    (local $w84 i32)
    (local $x i32)
    (local $w86 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    array.len
    local.set $w82
    i32.const 0
    local.set $w83
    i32.const 0
    local.set $w84
    block $while_85_exit
      loop $while_85_lp
        local.get $w84
        local.get $w82
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_79 5
          local.get $w84
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w83
            i32.const 1
            i32.add
            local.set $w83
          end
          local.get $w84
          i32.const 1
          i32.add
          local.set $w84
          br $while_85_lp
        else
          br $while_85_exit
        end
      end
    end
    i32.const 0
    local.set $w86
    i32.const 0
    local.set $w84
    block $while_87_exit
      loop $while_87_lp
        local.get $w84
        local.get $w82
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_79 5
          local.get $w84
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            i32.const 0
            local.get $w83
            array.new $GcArray_79
            local.get $w86
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_79 5
            local.get $w84
            array.get $GcArray_79
            array.set $GcArray_79
            local.get $w86
            i32.const 1
            i32.add
            local.set $w86
          end
          local.get $w84
          i32.const 1
          i32.add
          local.set $w84
          br $while_87_lp
        else
          br $while_87_exit
        end
      end
    end
    i32.const 0
    local.get $w83
    array.new $GcArray_79
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_115 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 4
    i32.gt_s
  )
  (func $testArrayExists (result i32) ;; exported as "testArrayExists"
    (local $w89 i32)
    (local $w90 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    array.len
    local.set $w89
    i32.const 0
    local.set $w90
    block $isome_88_blk (result i32)
      block $while_91_exit
        loop $while_91_lp
          local.get $w90
          local.get $w89
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_79 5
            local.get $w90
            array.get $GcArray_79
            local.set $x
            local.get $x
            i32.const 4
            i32.gt_s
            if
              i32.const 1
              br $isome_88_blk
            end
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
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_116 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayExistsFalse (result i32) ;; exported as "testArrayExistsFalse"
    (local $w93 i32)
    (local $w94 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    array.len
    local.set $w93
    i32.const 0
    local.set $w94
    block $isome_92_blk (result i32)
      block $while_95_exit
        loop $while_95_lp
          local.get $w94
          local.get $w93
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_79 5
            local.get $w94
            array.get $GcArray_79
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $isome_92_blk
            end
            local.get $w94
            i32.const 1
            i32.add
            local.set $w94
            br $while_95_lp
          else
            br $while_95_exit
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
  (func $closure_117 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayForAll (result i32) ;; exported as "testArrayForAll"
    (local $w97 i32)
    (local $w98 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    array.len
    local.set $w97
    i32.const 0
    local.set $w98
    block $ievery_96_blk (result i32)
      block $while_99_exit
        loop $while_99_lp
          local.get $w98
          local.get $w97
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_79 5
            local.get $w98
            array.get $GcArray_79
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w98
              i32.const 1
              i32.add
              local.set $w98
            else
              i32.const 0
              br $ievery_96_blk
            end
            br $while_99_lp
          else
            br $while_99_exit
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
  (func $closure_118 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayForAllFalse (result i32) ;; exported as "testArrayForAllFalse"
    (local $w101 i32)
    (local $w102 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    array.len
    local.set $w101
    i32.const 0
    local.set $w102
    block $ievery_100_blk (result i32)
      block $while_103_exit
        loop $while_103_lp
          local.get $w102
          local.get $w101
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_79 5
            local.get $w102
            array.get $GcArray_79
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w102
              i32.const 1
              i32.add
              local.set $w102
            else
              i32.const 0
              br $ievery_100_blk
            end
            br $while_103_lp
          else
            br $while_103_exit
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
  (func $closure_119 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $testArrayInit (result i32) ;; exported as "testArrayInit"
    (local $arr (ref $GcArray_79))
    (local $w105 (ref $GcArray_79))
    (local $w106 i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_79
    local.set $w105
    i32.const 0
    local.set $w106
    block $while_107_exit
      loop $while_107_lp
        local.get $w106
        local.get $w105
        array.len
        i32.lt_s
        if
          local.get $w105
          local.get $w106
          local.get $w106
          local.get $w106
          i32.mul
          array.set $GcArray_79
          local.get $w106
          i32.const 1
          i32.add
          local.set $w106
          br $while_107_lp
        else
          br $while_107_exit
        end
      end
    end
    local.get $w105
    local.set $arr
    local.get $arr
    i32.const 3
    array.get $GcArray_79
  )
  (func $closure_120 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
  )
  (func $closure_121 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_121))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_121)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_121 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_121 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_121
    local.get $x
    struct.new $ClosureType_121
  )
  (func $testArrayInitFold (result i32) ;; exported as "testArrayInitFold"
    (local $arr (ref $GcArray_79))
    (local $w109 (ref $GcArray_79))
    (local $w110 i32)
    (local $w114 i32)
    (local $w115 i32)
    (local $w116 i32)
    (local $y i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_79
    local.set $w109
    i32.const 0
    local.set $w110
    block $while_111_exit
      loop $while_111_lp
        local.get $w110
        local.get $w109
        array.len
        i32.lt_s
        if
          local.get $w109
          local.get $w110
          local.get $w110
          array.set $GcArray_79
          local.get $w110
          i32.const 1
          i32.add
          local.set $w110
          br $while_111_lp
        else
          br $while_111_exit
        end
      end
    end
    local.get $w109
    local.set $arr
    local.get $arr
    array.len
    local.set $w114
    i32.const 0
    local.set $w115
    i32.const 0
    local.set $w116
    block $while_117_exit
      loop $while_117_lp
        local.get $w116
        local.get $w114
        i32.lt_s
        if
          local.get $arr
          local.get $w116
          array.get $GcArray_79
          local.set $y
          local.get $w115
          local.get $y
          i32.add
          local.set $w115
          local.get $w116
          i32.const 1
          i32.add
          local.set $w116
          br $while_117_lp
        else
          br $while_117_exit
        end
      end
    end
    local.get $w115
  )
  (func $closure_123 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_124))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_124)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_124 1
    local.set $s
    local.get $s
    local.get $x
    i32.add
    local.set $s
  )
  (func $testArrayIter (result i32) ;; exported as "testArrayIter"
    (local $s i32)
    (local $w119 (ref $GcArray_79))
    (local $w120 i32)
    (local $w121 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w119
    local.get $w119
    array.len
    local.set $w120
    i32.const 0
    local.set $w121
    block $while_122_exit
      loop $while_122_lp
        local.get $w121
        local.get $w120
        i32.lt_s
        if
          local.get $w119
          local.get $w121
          array.get $GcArray_79
          local.set $x
          local.get $s
          local.get $x
          i32.add
          local.set $s
          local.get $w121
          i32.const 1
          i32.add
          local.set $w121
          br $while_122_lp
        else
          br $while_122_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_125 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_125))
    (local $i i32)
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_125)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_125 1
    local.set $i
    local.get $self_cast
    struct.get $ClosureType_125 2
    local.set $s
    local.get $s
    local.get $i
    local.get $x
    i32.mul
    i32.add
    local.set $s
  )
  (func $closure_125 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_126))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_126)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_126 1
    local.set $s
    ref.func $closure_125
    local.get $i
    local.get $s
    struct.new $ClosureType_125
  )
  (func $testArrayIteri (result i32) ;; exported as "testArrayIteri"
    (local $s i32)
    (local $w124 (ref $GcArray_79))
    (local $w125 i32)
    (local $w126 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w124
    local.get $w124
    array.len
    local.set $w125
    i32.const 0
    local.set $w126
    block $while_127_exit
      loop $while_127_lp
        local.get $w126
        local.get $w125
        i32.lt_s
        if
          local.get $w124
          local.get $w126
          array.get $GcArray_79
          local.set $x
          local.get $s
          local.get $w126
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w126
          i32.const 1
          i32.add
          local.set $w126
          br $while_127_lp
        else
          br $while_127_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_127 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_127))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_127)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_127 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_127 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_127
    local.get $x
    struct.new $ClosureType_127
  )
  (func $testArrayReduce (result i32) ;; exported as "testArrayReduce"
    (local $w129 (ref $GcArray_79))
    (local $w130 i32)
    (local $w131 i32)
    (local $w132 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w129
    local.get $w129
    array.len
    local.set $w130
    local.get $w129
    i32.const 0
    array.get $GcArray_79
    local.set $w131
    i32.const 1
    local.set $w132
    block $while_133_exit
      loop $while_133_lp
        local.get $w132
        local.get $w130
        i32.lt_s
        if
          local.get $w129
          local.get $w132
          array.get $GcArray_79
          local.set $y
          local.get $w131
          local.get $y
          i32.add
          local.set $w131
          local.get $w132
          i32.const 1
          i32.add
          local.set $w132
          br $while_133_lp
        else
          br $while_133_exit
        end
      end
    end
    local.get $w131
  )
  (func $closure_129 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArraySum (result i32) ;; exported as "testArraySum"
    (local $w135 (ref $GcArray_79))
    (local $w136 i32)
    (local $w137 i32)
    (local $w138 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w135
    local.get $w135
    array.len
    local.set $w136
    i32.const 0
    local.set $w137
    i32.const 0
    local.set $w138
    block $while_139_exit
      loop $while_139_lp
        local.get $w138
        local.get $w136
        i32.lt_s
        if
          local.get $w137
          local.get $w135
          local.get $w138
          array.get $GcArray_79
          i32.add
          local.set $w137
          local.get $w138
          i32.const 1
          i32.add
          local.set $w138
          br $while_139_lp
        else
          br $while_139_exit
        end
      end
    end
    local.get $w137
  )
  (func $closure_130 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w141 (ref $GcArray_79))
    (local $w142 i32)
    (local $w143 i32)
    (local $w144 i32)
    (local $w145 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w141
    local.get $w141
    array.len
    local.set $w142
    local.get $w141
    i32.const 0
    array.get $GcArray_79
    local.set $w143
    i32.const 1
    local.set $w144
    block $while_146_exit
      loop $while_146_lp
        local.get $w144
        local.get $w142
        i32.lt_s
        if
          local.get $w141
          local.get $w144
          array.get $GcArray_79
          local.set $w145
          local.get $w145
          local.get $w143
          i32.lt_s
          if (result i32)
            local.get $w145
          else
            local.get $w143
          end
          local.set $w143
          local.get $w144
          i32.const 1
          i32.add
          local.set $w144
          br $while_146_lp
        else
          br $while_146_exit
        end
      end
    end
    local.get $w143
  )
  (func $closure_133 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w148 (ref $GcArray_79))
    (local $w149 i32)
    (local $w150 i32)
    (local $w151 i32)
    (local $w152 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $w148
    local.get $w148
    array.len
    local.set $w149
    local.get $w148
    i32.const 0
    array.get $GcArray_79
    local.set $w150
    i32.const 1
    local.set $w151
    block $while_153_exit
      loop $while_153_lp
        local.get $w151
        local.get $w149
        i32.lt_s
        if
          local.get $w148
          local.get $w151
          array.get $GcArray_79
          local.set $w152
          local.get $w152
          local.get $w150
          i32.gt_s
          if (result i32)
            local.get $w152
          else
            local.get $w150
          end
          local.set $w150
          local.get $w151
          i32.const 1
          i32.add
          local.set $w151
          br $while_153_lp
        else
          br $while_153_exit
        end
      end
    end
    local.get $w150
  )
  (func $testArrayRev (result i32) ;; exported as "testArrayRev"
    (local $w155 (ref $GcArray_79))
    (local $w156 i32)
    (local $w157 (ref $GcArray_79))
    (local $w158 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $w155
    local.get $w155
    array.len
    local.set $w156
    i32.const 0
    local.get $w156
    array.new $GcArray_79
    local.set $w157
    i32.const 0
    local.set $w158
    block $while_159_exit
      loop $while_159_lp
        local.get $w158
        local.get $w156
        i32.lt_s
        if
          local.get $w157
          local.get $w158
          local.get $w155
          local.get $w156
          i32.const 1
          i32.sub
          local.get $w158
          i32.sub
          array.get $GcArray_79
          array.set $GcArray_79
          local.get $w158
          i32.const 1
          i32.add
          local.set $w158
          br $while_159_lp
        else
          br $while_159_exit
        end
      end
    end
    local.get $w157
    i32.const 0
    array.get $GcArray_79
  )
  (func $closure_134 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w161 (ref $GcArray_79))
    (local $w162 i32)
    (local $w163 (ref $GcArray_79))
    (local $w164 i32)
    (local $w165 i32)
    (local $w166 i32)
    i32.const 3
    i32.const 1
    i32.const 2
    array.new_fixed $GcArray_79 3
    local.set $w161
    local.get $w161
    array.len
    local.set $w162
    i32.const 0
    local.get $w162
    array.new $GcArray_79
    local.set $w163
    local.get $w163
    i32.const 0
    local.get $w161
    i32.const 0
    local.get $w162
    array.copy $GcArray_79 $GcArray_79
    i32.const 1
    local.set $w164
    block $while_168_exit
      loop $while_168_lp
        local.get $w164
        local.get $w162
        i32.lt_s
        if
          local.get $w163
          local.get $w164
          array.get $GcArray_79
          local.set $w165
          local.get $w164
          i32.const 1
          i32.sub
          local.set $w166
          block $while_167_exit
            loop $while_167_lp
              local.get $w166
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w163
                local.get $w166
                array.get $GcArray_79
                local.get $w165
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w163
                  local.get $w166
                  array.get $GcArray_79
                  local.get $w165
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
                local.get $w163
                local.get $w166
                i32.const 1
                i32.add
                local.get $w163
                local.get $w166
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w166
                i32.const 1
                i32.sub
                local.set $w166
                br $while_167_lp
              else
                br $while_167_exit
              end
            end
          end
          local.get $w163
          local.get $w166
          i32.const 1
          i32.add
          local.get $w165
          array.set $GcArray_79
          local.get $w164
          i32.const 1
          i32.add
          local.set $w164
          br $while_168_lp
        else
          br $while_168_exit
        end
      end
    end
    local.get $w163
    i32.const 0
    array.get $GcArray_79
  )
  (func $closure_135 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayFindIndex (result i32) ;; exported as "testArrayFindIndex"
    (local $w170 i32)
    (local $w171 i32)
    (local $x i32)
    i32.const 1
    i32.const 5
    i32.const 2
    i32.const 4
    array.new_fixed $GcArray_79 4
    array.len
    local.set $w170
    i32.const 0
    local.set $w171
    block $afidx_169_search (result i32)
      block $while_172_exit
        loop $while_172_lp
          local.get $w171
          local.get $w170
          i32.lt_s
          if
            i32.const 1
            i32.const 5
            i32.const 2
            i32.const 4
            array.new_fixed $GcArray_79 4
            local.get $w171
            array.get $GcArray_79
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w171
              br $afidx_169_search
            end
            local.get $w171
            i32.const 1
            i32.add
            local.set $w171
            br $while_172_lp
          else
            br $while_172_exit
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_136 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContains (result i32) ;; exported as "testArrayContains"
    (local $w175 i32)
    (local $w176 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_79 4
    array.len
    local.set $w175
    i32.const 0
    local.set $w176
    block $acont_173_blk (result i32)
      block $while_177_exit
        loop $while_177_lp
          local.get $w176
          local.get $w175
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_79 4
            local.get $w176
            array.get $GcArray_79
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $acont_173_blk
            end
            local.get $w176
            i32.const 1
            i32.add
            local.set $w176
            br $while_177_lp
          else
            br $while_177_exit
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
  (func $closure_137 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContainsFalse (result i32) ;; exported as "testArrayContainsFalse"
    (local $w180 i32)
    (local $w181 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_79 4
    array.len
    local.set $w180
    i32.const 0
    local.set $w181
    block $acont_178_blk (result i32)
      block $while_182_exit
        loop $while_182_lp
          local.get $w181
          local.get $w180
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_79 4
            local.get $w181
            array.get $GcArray_79
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $acont_178_blk
            end
            local.get $w181
            i32.const 1
            i32.add
            local.set $w181
            br $while_182_lp
          else
            br $while_182_exit
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
  (func $closure_138 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_138))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_138)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_138 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_138 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_138
    local.get $x
    struct.new $ClosureType_138
  )
  (func $testArrayScan (result i32) ;; exported as "testArrayScan"
    (local $r (ref $GcArray_79))
    (local $w184 (ref $GcArray_79))
    (local $w185 (ref $GcArray_79))
    (local $w186 i32)
    (local $w188 i32)
    (local $w189 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_79 4
    local.set $w184
    i32.const 0
    local.get $w184
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_79
    local.set $w185
    i32.const 0
    local.set $w186
    local.get $w185
    i32.const 0
    local.get $w186
    array.set $GcArray_79
    local.get $w184
    array.len
    local.set $w188
    i32.const 0
    local.set $w189
    block $while_190_exit
      loop $while_190_lp
        local.get $w189
        local.get $w188
        i32.lt_s
        if
          local.get $w184
          local.get $w189
          array.get $GcArray_79
          local.set $y
          local.get $w186
          local.get $y
          i32.add
          local.set $w186
          local.get $w185
          local.get $w189
          i32.const 1
          i32.add
          local.get $w186
          array.set $GcArray_79
          local.get $w189
          i32.const 1
          i32.add
          local.set $w189
          br $while_190_lp
        else
          br $while_190_exit
        end
      end
    end
    local.get $w185
    local.set $r
    local.get $r
    local.get $r
    array.len
    i32.const 1
    i32.sub
    array.get $GcArray_79
  )
  (func $closure_140 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_140))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_140)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_140 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_140 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_140
    local.get $x
    struct.new $ClosureType_140
  )
  (func $testArrayScanLen (result i32) ;; exported as "testArrayScanLen"
    (local $w192 (ref $GcArray_79))
    (local $w193 (ref $GcArray_79))
    (local $w194 i32)
    (local $w196 i32)
    (local $w197 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_79 4
    local.set $w192
    i32.const 0
    local.get $w192
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_79
    local.set $w193
    i32.const 0
    local.set $w194
    local.get $w193
    i32.const 0
    local.get $w194
    array.set $GcArray_79
    local.get $w192
    array.len
    local.set $w196
    i32.const 0
    local.set $w197
    block $while_198_exit
      loop $while_198_lp
        local.get $w197
        local.get $w196
        i32.lt_s
        if
          local.get $w192
          local.get $w197
          array.get $GcArray_79
          local.set $y
          local.get $w194
          local.get $y
          i32.add
          local.set $w194
          local.get $w193
          local.get $w197
          i32.const 1
          i32.add
          local.get $w194
          array.set $GcArray_79
          local.get $w197
          i32.const 1
          i32.add
          local.set $w197
          br $while_198_lp
        else
          br $while_198_exit
        end
      end
    end
    local.get $w193
    array.len
  )
  (func $testArrayAppend (result i32) ;; exported as "testArrayAppend"
    (local $w200 (ref $GcArray_79))
    (local $w201 (ref $GcArray_79))
    (local $w202 i32)
    (local $w203 (ref $GcArray_79))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $w200
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 2
    local.set $w201
    local.get $w200
    array.len
    local.set $w202
    i32.const 0
    local.get $w202
    local.get $w201
    array.len
    i32.add
    array.new $GcArray_79
    local.set $w203
    local.get $w203
    i32.const 0
    local.get $w200
    i32.const 0
    local.get $w202
    array.copy $GcArray_79 $GcArray_79
    local.get $w203
    local.get $w202
    local.get $w201
    i32.const 0
    local.get $w201
    array.len
    array.copy $GcArray_79 $GcArray_79
    local.get $w203
    i32.const 3
    array.get $GcArray_79
  )
  (func $testArrayAppendLen (result i32) ;; exported as "testArrayAppendLen"
    (local $w205 (ref $GcArray_79))
    (local $w206 (ref $GcArray_79))
    (local $w207 i32)
    (local $w208 (ref $GcArray_79))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $w205
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 2
    local.set $w206
    local.get $w205
    array.len
    local.set $w207
    i32.const 0
    local.get $w207
    local.get $w206
    array.len
    i32.add
    array.new $GcArray_79
    local.set $w208
    local.get $w208
    i32.const 0
    local.get $w205
    i32.const 0
    local.get $w207
    array.copy $GcArray_79 $GcArray_79
    local.get $w208
    local.get $w207
    local.get $w206
    i32.const 0
    local.get $w206
    array.len
    array.copy $GcArray_79 $GcArray_79
    local.get $w208
    array.len
  )
  (func $closure_142 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayToList (result i32) ;; exported as "testArrayToList"
    (local $arr (ref $GcArray_79))
    (local $lst (ref null $ListBase))
    (local $w211 i32)
    (local $w212 (ref null $ListBase))
    (local $w215 (ref null $ListBase))
    (local $w216 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $arr
    local.get $arr
    array.len
    i32.const 1
    i32.sub
    local.set $w211
    ref.null $ListBase
    local.set $w212
    block $while_213_exit
      loop $while_213_lp
        local.get $w211
        i32.const 0
        i32.ge_s
        if
          local.get $arr
          local.get $w211
          array.get $GcArray_79
          local.get $w212
          struct.new $ListCons_30
          local.set $w212
          local.get $w211
          i32.const 1
          i32.sub
          local.set $w211
          br $while_213_lp
        else
          br $while_213_exit
        end
      end
    end
    local.get $w212
    local.set $lst
    local.get $lst
    local.set $w215
    i32.const 0
    local.set $w216
    block $while_217_exit
      loop $while_217_lp
        local.get $w215
        ref.is_null
        i32.eqz
        if
          local.get $w216
          local.get $w215
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w216
          local.get $w215
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w215
          br $while_217_lp
        else
          br $while_217_exit
        end
      end
    end
    local.get $w216
  )
  (func $closure_143 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListOfArray (result i32) ;; exported as "testListOfArray"
    (local $arr (ref $GcArray_79))
    (local $lst (ref null $ListBase))
    (local $w220 i32)
    (local $w221 (ref null $ListBase))
    (local $w224 (ref null $ListBase))
    (local $w225 i32)
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_79 3
    local.set $arr
    local.get $arr
    array.len
    i32.const 1
    i32.sub
    local.set $w220
    ref.null $ListBase
    local.set $w221
    block $while_222_exit
      loop $while_222_lp
        local.get $w220
        i32.const 0
        i32.ge_s
        if
          local.get $arr
          local.get $w220
          array.get $GcArray_79
          local.get $w221
          struct.new $ListCons_30
          local.set $w221
          local.get $w220
          i32.const 1
          i32.sub
          local.set $w220
          br $while_222_lp
        else
          br $while_222_exit
        end
      end
    end
    local.get $w221
    local.set $lst
    local.get $lst
    local.set $w224
    i32.const 0
    local.set $w225
    block $while_226_exit
      loop $while_226_lp
        local.get $w224
        ref.is_null
        i32.eqz
        if
          local.get $w225
          local.get $w224
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w225
          local.get $w224
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w224
          br $while_226_lp
        else
          br $while_226_exit
        end
      end
    end
    local.get $w225
  )
  (func $closure_144 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_144))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_144)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_144 1
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
  (func $closure_144 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_144
    local.get $a
    struct.new $ClosureType_144
  )
  (func $testArraySortWith (result i32) ;; exported as "testArraySortWith"
    (local $arr (ref $GcArray_79))
    (local $sorted (ref $GcArray_79))
    (local $w229 i32)
    (local $w230 (ref $GcArray_79))
    (local $w231 i32)
    (local $w232 i32)
    (local $w233 i32)
    (local $a i32)
    (local $w228 (ref $GcArray_79))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_79 4
    local.set $arr
    local.get $arr
    array.len
    local.set $w229
    i32.const 0
    local.get $w229
    array.new $GcArray_79
    local.set $w230
    local.get $w230
    i32.const 0
    local.get $w228
    i32.const 0
    local.get $w229
    array.copy $GcArray_79 $GcArray_79
    i32.const 1
    local.set $w231
    block $while_235_exit
      loop $while_235_lp
        local.get $w231
        local.get $w229
        i32.lt_s
        if
          local.get $w230
          local.get $w231
          array.get $GcArray_79
          local.set $w232
          local.get $w231
          i32.const 1
          i32.sub
          local.set $w233
          block $while_234_exit
            loop $while_234_lp
              local.get $w233
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w230
                local.get $w233
                array.get $GcArray_79
                local.set $a
                local.get $a
                local.get $w232
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $a
                  local.get $w232
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
                local.get $w230
                local.get $w233
                i32.const 1
                i32.add
                local.get $w230
                local.get $w233
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w233
                i32.const 1
                i32.sub
                local.set $w233
                br $while_234_lp
              else
                br $while_234_exit
              end
            end
          end
          local.get $w230
          local.get $w233
          i32.const 1
          i32.add
          local.get $w232
          array.set $GcArray_79
          local.get $w231
          i32.const 1
          i32.add
          local.set $w231
          br $while_235_lp
        else
          br $while_235_exit
        end
      end
    end
    local.get $w230
    local.set $sorted
    local.get $sorted
    i32.const 0
    array.get $GcArray_79
  )
  (func $closure_146 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_146))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_146)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_146 1
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
  (func $closure_146 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_146
    local.get $a
    struct.new $ClosureType_146
  )
  (func $testArraySortWithDesc (result i32) ;; exported as "testArraySortWithDesc"
    (local $arr (ref $GcArray_79))
    (local $sorted (ref $GcArray_79))
    (local $w238 i32)
    (local $w239 (ref $GcArray_79))
    (local $w240 i32)
    (local $w241 i32)
    (local $w242 i32)
    (local $a i32)
    (local $w237 (ref $GcArray_79))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_79 4
    local.set $arr
    local.get $arr
    array.len
    local.set $w238
    i32.const 0
    local.get $w238
    array.new $GcArray_79
    local.set $w239
    local.get $w239
    i32.const 0
    local.get $w237
    i32.const 0
    local.get $w238
    array.copy $GcArray_79 $GcArray_79
    i32.const 1
    local.set $w240
    block $while_244_exit
      loop $while_244_lp
        local.get $w240
        local.get $w238
        i32.lt_s
        if
          local.get $w239
          local.get $w240
          array.get $GcArray_79
          local.set $w241
          local.get $w240
          i32.const 1
          i32.sub
          local.set $w242
          block $while_243_exit
            loop $while_243_lp
              local.get $w242
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w239
                local.get $w242
                array.get $GcArray_79
                local.set $a
                local.get $w241
                local.get $a
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w241
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
                local.get $w239
                local.get $w242
                i32.const 1
                i32.add
                local.get $w239
                local.get $w242
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w242
                i32.const 1
                i32.sub
                local.set $w242
                br $while_243_lp
              else
                br $while_243_exit
              end
            end
          end
          local.get $w239
          local.get $w242
          i32.const 1
          i32.add
          local.get $w241
          array.set $GcArray_79
          local.get $w240
          i32.const 1
          i32.add
          local.set $w240
          br $while_244_lp
        else
          br $while_244_exit
        end
      end
    end
    local.get $w239
    local.set $sorted
    local.get $sorted
    i32.const 0
    array.get $GcArray_79
  )
  (func $testArrayZip (result i32) ;; exported as "testArrayZip"
    (local $arr1 (ref $GcArray_79))
    (local $arr2 (ref $GcArray_79))
    (local $zipped (ref $GcArray_148))
    (local $w248 (ref $GcArray_148))
    (local $w249 i32)
    (local $patternInput (ref $Tuple_90))
    (local $b i32)
    (local $a i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $arr1
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_79 3
    local.set $arr2
    i32.const 0
    i32.const 0
    struct.new $Tuple_90
    local.get $arr1
    array.len
    array.new $GcArray_148
    local.set $w248
    i32.const 0
    local.set $w249
    block $while_250_exit
      loop $while_250_lp
        local.get $w249
        local.get $arr1
        array.len
        i32.lt_s
        if
          local.get $w248
          local.get $w249
          local.get $arr1
          local.get $w249
          array.get $GcArray_79
          local.get $arr2
          local.get $w249
          array.get $GcArray_79
          struct.new $Tuple_90
          array.set $GcArray_148
          local.get $w249
          i32.const 1
          i32.add
          local.set $w249
          br $while_250_lp
        else
          br $while_250_exit
        end
      end
    end
    local.get $w248
    local.set $zipped
    local.get $zipped
    i32.const 0
    array.get $GcArray_148
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_90 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_90 0
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $testArrayZipLen (result i32) ;; exported as "testArrayZipLen"
    (local $zipped (ref $GcArray_148))
    (local $w252 (ref $GcArray_79))
    (local $w253 (ref $GcArray_79))
    (local $w254 (ref $GcArray_148))
    (local $w255 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $w252
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_79 3
    local.set $w253
    i32.const 0
    i32.const 0
    struct.new $Tuple_90
    local.get $w252
    array.len
    array.new $GcArray_148
    local.set $w254
    i32.const 0
    local.set $w255
    block $while_256_exit
      loop $while_256_lp
        local.get $w255
        local.get $w252
        array.len
        i32.lt_s
        if
          local.get $w254
          local.get $w255
          local.get $w252
          local.get $w255
          array.get $GcArray_79
          local.get $w253
          local.get $w255
          array.get $GcArray_79
          struct.new $Tuple_90
          array.set $GcArray_148
          local.get $w255
          i32.const 1
          i32.add
          local.set $w255
          br $while_256_lp
        else
          br $while_256_exit
        end
      end
    end
    local.get $w254
    local.set $zipped
    local.get $zipped
    array.len
  )
  (func $closure_149 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_149 (param $self (ref $AnyFn)) (param $array (ref $GcArray_79)) (result i32)
    (local $w259 i32)
    (local $w260 i32)
    (local $w261 i32)
    local.get $array
    array.len
    local.set $w259
    i32.const 0
    local.set $w260
    i32.const 0
    local.set $w261
    block $while_262_exit
      loop $while_262_lp
        local.get $w261
        local.get $w259
        i32.lt_s
        if
          local.get $w260
          local.get $array
          local.get $w261
          array.get $GcArray_79
          i32.add
          local.set $w260
          local.get $w261
          i32.const 1
          i32.add
          local.set $w261
          br $while_262_lp
        else
          br $while_262_exit
        end
      end
    end
    local.get $w260
  )
  (func $closure_153 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_153))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_153)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_153 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_153 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_153
    local.get $a
    struct.new $ClosureType_153
  )
  (func $testArrayMap2Sum (result i32) ;; exported as "testArrayMap2Sum"
    (local $lo_clo_31 (ref $ClosureBase_151))
    (local $w264 (ref $GcArray_79))
    (local $w265 (ref $GcArray_79))
    (local $w266 i32)
    (local $w267 (ref $GcArray_79))
    (local $w268 i32)
    (local $a i32)
    (local $b i32)
    ref.func $closure_149
    struct.new $ClosureType_152
    ref.cast (ref $ClosureBase_151)
    local.set $lo_clo_31
    local.get $lo_clo_31
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $w264
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_79 3
    local.set $w265
    local.get $w264
    array.len
    local.set $w266
    i32.const 0
    local.get $w266
    array.new $GcArray_79
    local.set $w267
    i32.const 0
    local.set $w268
    block $while_269_exit
      loop $while_269_lp
        local.get $w268
        local.get $w266
        i32.lt_s
        if
          local.get $w267
          local.get $w268
          local.get $w264
          local.get $w268
          array.get $GcArray_79
          local.set $a
          local.get $w265
          local.get $w268
          array.get $GcArray_79
          local.set $b
          local.get $a
          local.get $b
          i32.add
          array.set $GcArray_79
          local.get $w268
          i32.const 1
          i32.add
          local.set $w268
          br $while_269_lp
        else
          br $while_269_exit
        end
      end
    end
    local.get $w267
    local.get $lo_clo_31
    struct.get $ClosureBase_151 0
    call_ref $FuncType_150
  )
  (func $closure_155 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_155))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_155)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_155 1
    local.set $a
    local.get $a
    local.get $b
    i32.mul
  )
  (func $closure_155 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_155
    local.get $a
    struct.new $ClosureType_155
  )
  (func $testArrayMap2Head (result i32) ;; exported as "testArrayMap2Head"
    (local $w271 (ref $GcArray_79))
    (local $w272 (ref $GcArray_79))
    (local $w273 i32)
    (local $w274 (ref $GcArray_79))
    (local $w275 i32)
    (local $a i32)
    (local $b i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $w271
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_79 3
    local.set $w272
    local.get $w271
    array.len
    local.set $w273
    i32.const 0
    local.get $w273
    array.new $GcArray_79
    local.set $w274
    i32.const 0
    local.set $w275
    block $while_276_exit
      loop $while_276_lp
        local.get $w275
        local.get $w273
        i32.lt_s
        if
          local.get $w274
          local.get $w275
          local.get $w271
          local.get $w275
          array.get $GcArray_79
          local.set $a
          local.get $w272
          local.get $w275
          array.get $GcArray_79
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          array.set $GcArray_79
          local.get $w275
          i32.const 1
          i32.add
          local.set $w275
          br $while_276_lp
        else
          br $while_276_exit
        end
      end
    end
    local.get $w274
    i32.const 0
    array.get $GcArray_79
  )
  (func $closure_157 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_89))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_89))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_89
    else
      ref.null $Option_89
    end
  )
  (func $closure_160 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayChooseBasic (result i32) ;; exported as "testArrayChooseBasic"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w283 i32)
    (local $w279 i32)
    (local $w280 i32)
    (local $x i32)
    (local $w281 (ref null $Option_89))
    (local $w284 (ref $GcArray_79))
    (local $w285 i32)
    (local $w286 i32)
    (local $w287 (ref null $Option_89))
    (local $w291 i32)
    (local $w292 i32)
    (local $w293 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_79 5
    local.set $arr
    i32.const 0
    local.set $w279
    i32.const 0
    local.set $w280
    block $while_282_exit
      loop $while_282_lp
        local.get $w280
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w280
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_89))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_89
          else
            ref.null $Option_89
          end
          local.set $w281
          local.get $w281
          ref.is_null
          i32.eqz
          if
            local.get $w279
            i32.const 1
            i32.add
            local.set $w279
          end
          local.get $w280
          i32.const 1
          i32.add
          local.set $w280
          br $while_282_lp
        else
          br $while_282_exit
        end
      end
    end
    local.get $w279
    local.set $w283
    i32.const 0
    local.get $w283
    array.new $GcArray_79
    local.set $w284
    i32.const 0
    local.set $w285
    i32.const 0
    local.set $w286
    block $while_288_exit
      loop $while_288_lp
        local.get $w286
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w286
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_89))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_89
          else
            ref.null $Option_89
          end
          local.set $w287
          local.get $w287
          ref.is_null
          i32.eqz
          if
            local.get $w284
            local.get $w285
            local.get $w287
            ref.cast (ref $Option_89)
            struct.get $Option_89 0
            array.set $GcArray_79
            local.get $w285
            i32.const 1
            i32.add
            local.set $w285
          end
          local.get $w286
          i32.const 1
          i32.add
          local.set $w286
          br $while_288_lp
        else
          br $while_288_exit
        end
      end
    end
    local.get $w284
    local.set $result
    local.get $result
    array.len
    local.set $w291
    i32.const 0
    local.set $w292
    i32.const 0
    local.set $w293
    block $while_294_exit
      loop $while_294_lp
        local.get $w293
        local.get $w291
        i32.lt_s
        if
          local.get $w292
          local.get $result
          local.get $w293
          array.get $GcArray_79
          i32.add
          local.set $w292
          local.get $w293
          i32.const 1
          i32.add
          local.set $w293
          br $while_294_lp
        else
          br $while_294_exit
        end
      end
    end
    local.get $w292
  )
  (func $closure_161 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_89))
    local.get $x
    i32.const 3
    i32.gt_s
    if (result (ref null $Option_89))
      local.get $x
      struct.new $Option_89
    else
      ref.null $Option_89
    end
  )
  (func $testArrayChooseLength (result i32) ;; exported as "testArrayChooseLength"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w301 i32)
    (local $w297 i32)
    (local $w298 i32)
    (local $x i32)
    (local $w299 (ref null $Option_89))
    (local $w302 (ref $GcArray_79))
    (local $w303 i32)
    (local $w304 i32)
    (local $w305 (ref null $Option_89))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_79 6
    local.set $arr
    i32.const 0
    local.set $w297
    i32.const 0
    local.set $w298
    block $while_300_exit
      loop $while_300_lp
        local.get $w298
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w298
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_89))
            local.get $x
            struct.new $Option_89
          else
            ref.null $Option_89
          end
          local.set $w299
          local.get $w299
          ref.is_null
          i32.eqz
          if
            local.get $w297
            i32.const 1
            i32.add
            local.set $w297
          end
          local.get $w298
          i32.const 1
          i32.add
          local.set $w298
          br $while_300_lp
        else
          br $while_300_exit
        end
      end
    end
    local.get $w297
    local.set $w301
    i32.const 0
    local.get $w301
    array.new $GcArray_79
    local.set $w302
    i32.const 0
    local.set $w303
    i32.const 0
    local.set $w304
    block $while_306_exit
      loop $while_306_lp
        local.get $w304
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w304
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_89))
            local.get $x
            struct.new $Option_89
          else
            ref.null $Option_89
          end
          local.set $w305
          local.get $w305
          ref.is_null
          i32.eqz
          if
            local.get $w302
            local.get $w303
            local.get $w305
            ref.cast (ref $Option_89)
            struct.get $Option_89 0
            array.set $GcArray_79
            local.get $w303
            i32.const 1
            i32.add
            local.set $w303
          end
          local.get $w304
          i32.const 1
          i32.add
          local.set $w304
          br $while_306_lp
        else
          br $while_306_exit
        end
      end
    end
    local.get $w302
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_162 (param $self (ref $AnyFn)) (param $_x i32) (result (ref null $Option_89))
    ref.null $Option_89
  )
  (func $testArrayChooseEmpty (result i32) ;; exported as "testArrayChooseEmpty"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w313 i32)
    (local $w309 i32)
    (local $w310 i32)
    (local $w314 (ref $GcArray_79))
    (local $w315 i32)
    (local $w316 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $arr
    i32.const 0
    local.set $w309
    i32.const 0
    local.set $w310
    block $while_312_exit
      loop $while_312_lp
        local.get $w310
        local.get $arr
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w309
            i32.const 1
            i32.add
            local.set $w309
          end
          local.get $w310
          i32.const 1
          i32.add
          local.set $w310
          br $while_312_lp
        else
          br $while_312_exit
        end
      end
    end
    local.get $w309
    local.set $w313
    i32.const 0
    local.get $w313
    array.new $GcArray_79
    local.set $w314
    i32.const 0
    local.set $w315
    i32.const 0
    local.set $w316
    block $while_318_exit
      loop $while_318_lp
        local.get $w316
        local.get $arr
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w314
            local.get $w315
            ref.null $Option_89
            ref.cast (ref $Option_89)
            struct.get $Option_89 0
            array.set $GcArray_79
            local.get $w315
            i32.const 1
            i32.add
            local.set $w315
          end
          local.get $w316
          i32.const 1
          i32.add
          local.set $w316
          br $while_318_lp
        else
          br $while_318_exit
        end
      end
    end
    local.get $w314
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_163 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_89))
    local.get $x
    i32.const 10
    i32.add
    struct.new $Option_89
  )
  (func $testArrayChooseAllSome (result i32) ;; exported as "testArrayChooseAllSome"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w325 i32)
    (local $w321 i32)
    (local $w322 i32)
    (local $x i32)
    (local $w323 (ref null $Option_89))
    (local $w326 (ref $GcArray_79))
    (local $w327 i32)
    (local $w328 i32)
    (local $w329 (ref null $Option_89))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $arr
    i32.const 0
    local.set $w321
    i32.const 0
    local.set $w322
    block $while_324_exit
      loop $while_324_lp
        local.get $w322
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w322
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_89
          local.set $w323
          local.get $w323
          ref.is_null
          i32.eqz
          if
            local.get $w321
            i32.const 1
            i32.add
            local.set $w321
          end
          local.get $w322
          i32.const 1
          i32.add
          local.set $w322
          br $while_324_lp
        else
          br $while_324_exit
        end
      end
    end
    local.get $w321
    local.set $w325
    i32.const 0
    local.get $w325
    array.new $GcArray_79
    local.set $w326
    i32.const 0
    local.set $w327
    i32.const 0
    local.set $w328
    block $while_330_exit
      loop $while_330_lp
        local.get $w328
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w328
          array.get $GcArray_79
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_89
          local.set $w329
          local.get $w329
          ref.is_null
          i32.eqz
          if
            local.get $w326
            local.get $w327
            local.get $w329
            ref.cast (ref $Option_89)
            struct.get $Option_89 0
            array.set $GcArray_79
            local.get $w327
            i32.const 1
            i32.add
            local.set $w327
          end
          local.get $w328
          i32.const 1
          i32.add
          local.set $w328
          br $while_330_lp
        else
          br $while_330_exit
        end
      end
    end
    local.get $w326
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_79
    local.get $result
    i32.const 1
    array.get $GcArray_79
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_79
    i32.add
  )
  (func $closure_164 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_79))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    array.new_fixed $GcArray_79 2
  )
  (func $closure_167 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayCollectBasic (result i32) ;; exported as "testArrayCollectBasic"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w337 i32)
    (local $w333 i32)
    (local $w334 i32)
    (local $x i32)
    (local $w335 (ref $GcArray_79))
    (local $w338 (ref $GcArray_79))
    (local $w339 i32)
    (local $w340 i32)
    (local $w341 (ref $GcArray_79))
    (local $w345 i32)
    (local $w346 i32)
    (local $w347 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $arr
    i32.const 0
    local.set $w333
    i32.const 0
    local.set $w334
    block $while_336_exit
      loop $while_336_lp
        local.get $w334
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w334
          array.get $GcArray_79
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_79 2
          local.set $w335
          local.get $w333
          local.get $w335
          array.len
          i32.add
          local.set $w333
          local.get $w334
          i32.const 1
          i32.add
          local.set $w334
          br $while_336_lp
        else
          br $while_336_exit
        end
      end
    end
    local.get $w333
    local.set $w337
    i32.const 0
    local.get $w337
    array.new $GcArray_79
    local.set $w338
    i32.const 0
    local.set $w339
    i32.const 0
    local.set $w340
    block $while_342_exit
      loop $while_342_lp
        local.get $w340
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w340
          array.get $GcArray_79
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_79 2
          local.set $w341
          local.get $w338
          local.get $w339
          local.get $w341
          i32.const 0
          local.get $w341
          array.len
          array.copy $GcArray_79 $GcArray_79
          local.get $w339
          local.get $w341
          array.len
          i32.add
          local.set $w339
          local.get $w340
          i32.const 1
          i32.add
          local.set $w340
          br $while_342_lp
        else
          br $while_342_exit
        end
      end
    end
    local.get $w338
    local.set $result
    local.get $result
    array.len
    local.set $w345
    i32.const 0
    local.set $w346
    i32.const 0
    local.set $w347
    block $while_348_exit
      loop $while_348_lp
        local.get $w347
        local.get $w345
        i32.lt_s
        if
          local.get $w346
          local.get $result
          local.get $w347
          array.get $GcArray_79
          i32.add
          local.set $w346
          local.get $w347
          i32.const 1
          i32.add
          local.set $w347
          br $while_348_lp
        else
          br $while_348_exit
        end
      end
    end
    local.get $w346
  )
  (func $closure_168 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_79))
    local.get $x
    local.get $x
    array.new_fixed $GcArray_79 2
  )
  (func $testArrayCollectLength (result i32) ;; exported as "testArrayCollectLength"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w355 i32)
    (local $w351 i32)
    (local $w352 i32)
    (local $x i32)
    (local $w353 (ref $GcArray_79))
    (local $w356 (ref $GcArray_79))
    (local $w357 i32)
    (local $w358 i32)
    (local $w359 (ref $GcArray_79))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $arr
    i32.const 0
    local.set $w351
    i32.const 0
    local.set $w352
    block $while_354_exit
      loop $while_354_lp
        local.get $w352
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w352
          array.get $GcArray_79
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_79 2
          local.set $w353
          local.get $w351
          local.get $w353
          array.len
          i32.add
          local.set $w351
          local.get $w352
          i32.const 1
          i32.add
          local.set $w352
          br $while_354_lp
        else
          br $while_354_exit
        end
      end
    end
    local.get $w351
    local.set $w355
    i32.const 0
    local.get $w355
    array.new $GcArray_79
    local.set $w356
    i32.const 0
    local.set $w357
    i32.const 0
    local.set $w358
    block $while_360_exit
      loop $while_360_lp
        local.get $w358
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w358
          array.get $GcArray_79
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_79 2
          local.set $w359
          local.get $w356
          local.get $w357
          local.get $w359
          i32.const 0
          local.get $w359
          array.len
          array.copy $GcArray_79 $GcArray_79
          local.get $w357
          local.get $w359
          array.len
          i32.add
          local.set $w357
          local.get $w358
          i32.const 1
          i32.add
          local.set $w358
          br $while_360_lp
        else
          br $while_360_exit
        end
      end
    end
    local.get $w356
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_169 (param $self (ref $AnyFn)) (param $_x i32) (result (ref $GcArray_79))
    array.new_fixed $GcArray_79 0
  )
  (func $testArrayCollectEmpty (result i32) ;; exported as "testArrayCollectEmpty"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w367 i32)
    (local $w363 i32)
    (local $w364 i32)
    (local $w365 (ref $GcArray_79))
    (local $w368 (ref $GcArray_79))
    (local $w369 i32)
    (local $w370 i32)
    (local $w371 (ref $GcArray_79))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_79 3
    local.set $arr
    i32.const 0
    local.set $w363
    i32.const 0
    local.set $w364
    block $while_366_exit
      loop $while_366_lp
        local.get $w364
        local.get $arr
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_79 0
          local.set $w365
          local.get $w363
          local.get $w365
          array.len
          i32.add
          local.set $w363
          local.get $w364
          i32.const 1
          i32.add
          local.set $w364
          br $while_366_lp
        else
          br $while_366_exit
        end
      end
    end
    local.get $w363
    local.set $w367
    i32.const 0
    local.get $w367
    array.new $GcArray_79
    local.set $w368
    i32.const 0
    local.set $w369
    i32.const 0
    local.set $w370
    block $while_372_exit
      loop $while_372_lp
        local.get $w370
        local.get $arr
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_79 0
          local.set $w371
          local.get $w368
          local.get $w369
          local.get $w371
          i32.const 0
          local.get $w371
          array.len
          array.copy $GcArray_79 $GcArray_79
          local.get $w369
          local.get $w371
          array.len
          i32.add
          local.set $w369
          local.get $w370
          i32.const 1
          i32.add
          local.set $w370
          br $while_372_lp
        else
          br $while_372_exit
        end
      end
    end
    local.get $w368
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_170 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_79))
    local.get $x
    array.new_fixed $GcArray_79 1
  )
  (func $testArrayCollectSingleton (result i32) ;; exported as "testArrayCollectSingleton"
    (local $arr (ref $GcArray_79))
    (local $result (ref $GcArray_79))
    (local $w379 i32)
    (local $w375 i32)
    (local $w376 i32)
    (local $x i32)
    (local $w377 (ref $GcArray_79))
    (local $w380 (ref $GcArray_79))
    (local $w381 i32)
    (local $w382 i32)
    (local $w383 (ref $GcArray_79))
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_79 3
    local.set $arr
    i32.const 0
    local.set $w375
    i32.const 0
    local.set $w376
    block $while_378_exit
      loop $while_378_lp
        local.get $w376
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w376
          array.get $GcArray_79
          local.set $x
          local.get $x
          array.new_fixed $GcArray_79 1
          local.set $w377
          local.get $w375
          local.get $w377
          array.len
          i32.add
          local.set $w375
          local.get $w376
          i32.const 1
          i32.add
          local.set $w376
          br $while_378_lp
        else
          br $while_378_exit
        end
      end
    end
    local.get $w375
    local.set $w379
    i32.const 0
    local.get $w379
    array.new $GcArray_79
    local.set $w380
    i32.const 0
    local.set $w381
    i32.const 0
    local.set $w382
    block $while_384_exit
      loop $while_384_lp
        local.get $w382
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w382
          array.get $GcArray_79
          local.set $x
          local.get $x
          array.new_fixed $GcArray_79 1
          local.set $w383
          local.get $w380
          local.get $w381
          local.get $w383
          i32.const 0
          local.get $w383
          array.len
          array.copy $GcArray_79 $GcArray_79
          local.get $w381
          local.get $w383
          array.len
          i32.add
          local.set $w381
          local.get $w382
          i32.const 1
          i32.add
          local.set $w382
          br $while_384_lp
        else
          br $while_384_exit
        end
      end
    end
    local.get $w380
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_79
    local.get $result
    i32.const 1
    array.get $GcArray_79
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_79
    i32.add
  )
  (func $testResizeArrayBasic (result i32) ;; exported as "testResizeArrayBasic"
    (local $xs (ref $ResizeArray_171))
    (local $w386 i32)
    (local $w387 (ref $GcArray_79))
    (local $w388 i32)
    (local $w389 (ref $GcArray_79))
    (local $w391 i32)
    (local $w392 (ref $GcArray_79))
    (local $w393 i32)
    (local $w394 (ref $GcArray_79))
    (local $w396 i32)
    (local $w397 (ref $GcArray_79))
    (local $w398 i32)
    (local $w399 (ref $GcArray_79))
    i32.const 0
    i32.const 4
    array.new $GcArray_79
    i32.const 0
    struct.new $ResizeArray_171
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_171 1
    local.set $w386
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.set $w387
    local.get $w386
    local.get $w387
    array.len
    i32.ge_u
    if
      local.get $w387
      array.len
      i32.const 1
      i32.shl
      local.set $w388
      i32.const 0
      local.get $w388
      array.new $GcArray_79
      local.set $w389
      local.get $w389
      i32.const 0
      local.get $w387
      i32.const 0
      local.get $w386
      array.copy $GcArray_79 $GcArray_79
      local.get $xs
      local.get $w389
      struct.set $ResizeArray_171 0
    end
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.get $w386
    i32.const 10
    array.set $GcArray_79
    local.get $xs
    local.get $w386
    i32.const 1
    i32.add
    struct.set $ResizeArray_171 1
    local.get $xs
    struct.get $ResizeArray_171 1
    local.set $w391
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.set $w392
    local.get $w391
    local.get $w392
    array.len
    i32.ge_u
    if
      local.get $w392
      array.len
      i32.const 1
      i32.shl
      local.set $w393
      i32.const 0
      local.get $w393
      array.new $GcArray_79
      local.set $w394
      local.get $w394
      i32.const 0
      local.get $w392
      i32.const 0
      local.get $w391
      array.copy $GcArray_79 $GcArray_79
      local.get $xs
      local.get $w394
      struct.set $ResizeArray_171 0
    end
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.get $w391
    i32.const 20
    array.set $GcArray_79
    local.get $xs
    local.get $w391
    i32.const 1
    i32.add
    struct.set $ResizeArray_171 1
    local.get $xs
    struct.get $ResizeArray_171 1
    local.set $w396
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.set $w397
    local.get $w396
    local.get $w397
    array.len
    i32.ge_u
    if
      local.get $w397
      array.len
      i32.const 1
      i32.shl
      local.set $w398
      i32.const 0
      local.get $w398
      array.new $GcArray_79
      local.set $w399
      local.get $w399
      i32.const 0
      local.get $w397
      i32.const 0
      local.get $w396
      array.copy $GcArray_79 $GcArray_79
      local.get $xs
      local.get $w399
      struct.set $ResizeArray_171 0
    end
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.get $w396
    i32.const 30
    array.set $GcArray_79
    local.get $xs
    local.get $w396
    i32.const 1
    i32.add
    struct.set $ResizeArray_171 1
    local.get $xs
    struct.get $ResizeArray_171 1
  )
  (func $closure_173 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_174 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayUnzip (result i32) ;; exported as "testArrayUnzip"
    (local $pairs (ref $GcArray_148))
    (local $patternInput (ref $Tuple_172))
    (local $w402 i32)
    (local $w403 (ref $GcArray_79))
    (local $w404 (ref $GcArray_79))
    (local $w405 i32)
    (local $w406 (ref $Tuple_90))
    (local $ys (ref $GcArray_79))
    (local $xs (ref $GcArray_79))
    (local $w410 i32)
    (local $w411 i32)
    (local $w412 i32)
    (local $w416 i32)
    (local $w417 i32)
    (local $w418 i32)
    i32.const 1
    i32.const 4
    struct.new $Tuple_90
    i32.const 2
    i32.const 5
    struct.new $Tuple_90
    i32.const 3
    i32.const 6
    struct.new $Tuple_90
    array.new_fixed $GcArray_148 3
    local.set $pairs
    local.get $pairs
    array.len
    local.set $w402
    i32.const 0
    local.get $w402
    array.new $GcArray_79
    local.set $w403
    i32.const 0
    local.get $w402
    array.new $GcArray_79
    local.set $w404
    i32.const 0
    local.set $w405
    block $while_407_exit
      loop $while_407_lp
        local.get $w405
        local.get $w402
        i32.lt_s
        if
          local.get $pairs
          local.get $w405
          array.get $GcArray_148
          local.set $w406
          local.get $w403
          local.get $w405
          local.get $w406
          struct.get $Tuple_90 0
          array.set $GcArray_79
          local.get $w404
          local.get $w405
          local.get $w406
          struct.get $Tuple_90 1
          array.set $GcArray_79
          local.get $w405
          i32.const 1
          i32.add
          local.set $w405
          br $while_407_lp
        else
          br $while_407_exit
        end
      end
    end
    local.get $w403
    local.get $w404
    struct.new $Tuple_172
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_172 1
    local.set $ys
    local.get $patternInput
    struct.get $Tuple_172 0
    local.set $xs
    local.get $xs
    array.len
    local.set $w410
    i32.const 0
    local.set $w411
    i32.const 0
    local.set $w412
    block $while_413_exit
      loop $while_413_lp
        local.get $w412
        local.get $w410
        i32.lt_s
        if
          local.get $w411
          local.get $xs
          local.get $w412
          array.get $GcArray_79
          i32.add
          local.set $w411
          local.get $w412
          i32.const 1
          i32.add
          local.set $w412
          br $while_413_lp
        else
          br $while_413_exit
        end
      end
    end
    local.get $w411
    local.get $ys
    array.len
    local.set $w416
    i32.const 0
    local.set $w417
    i32.const 0
    local.set $w418
    block $while_419_exit
      loop $while_419_lp
        local.get $w418
        local.get $w416
        i32.lt_s
        if
          local.get $w417
          local.get $ys
          local.get $w418
          array.get $GcArray_79
          i32.add
          local.set $w417
          local.get $w418
          i32.const 1
          i32.add
          local.set $w418
          br $while_419_lp
        else
          br $while_419_exit
        end
      end
    end
    local.get $w417
    i32.add
  )
  (func $testResizeArrayIndex (result i32) ;; exported as "testResizeArrayIndex"
    (local $xs (ref $ResizeArray_171))
    (local $w421 i32)
    (local $w422 (ref $GcArray_79))
    (local $w423 i32)
    (local $w424 (ref $GcArray_79))
    (local $w426 i32)
    (local $w427 (ref $GcArray_79))
    (local $w428 i32)
    (local $w429 (ref $GcArray_79))
    (local $w431 i32)
    (local $w432 (ref $GcArray_79))
    (local $w433 i32)
    (local $w434 (ref $GcArray_79))
    i32.const 0
    i32.const 4
    array.new $GcArray_79
    i32.const 0
    struct.new $ResizeArray_171
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_171 1
    local.set $w421
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.set $w422
    local.get $w421
    local.get $w422
    array.len
    i32.ge_u
    if
      local.get $w422
      array.len
      i32.const 1
      i32.shl
      local.set $w423
      i32.const 0
      local.get $w423
      array.new $GcArray_79
      local.set $w424
      local.get $w424
      i32.const 0
      local.get $w422
      i32.const 0
      local.get $w421
      array.copy $GcArray_79 $GcArray_79
      local.get $xs
      local.get $w424
      struct.set $ResizeArray_171 0
    end
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.get $w421
    i32.const 100
    array.set $GcArray_79
    local.get $xs
    local.get $w421
    i32.const 1
    i32.add
    struct.set $ResizeArray_171 1
    local.get $xs
    struct.get $ResizeArray_171 1
    local.set $w426
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.set $w427
    local.get $w426
    local.get $w427
    array.len
    i32.ge_u
    if
      local.get $w427
      array.len
      i32.const 1
      i32.shl
      local.set $w428
      i32.const 0
      local.get $w428
      array.new $GcArray_79
      local.set $w429
      local.get $w429
      i32.const 0
      local.get $w427
      i32.const 0
      local.get $w426
      array.copy $GcArray_79 $GcArray_79
      local.get $xs
      local.get $w429
      struct.set $ResizeArray_171 0
    end
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.get $w426
    i32.const 200
    array.set $GcArray_79
    local.get $xs
    local.get $w426
    i32.const 1
    i32.add
    struct.set $ResizeArray_171 1
    local.get $xs
    struct.get $ResizeArray_171 1
    local.set $w431
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.set $w432
    local.get $w431
    local.get $w432
    array.len
    i32.ge_u
    if
      local.get $w432
      array.len
      i32.const 1
      i32.shl
      local.set $w433
      i32.const 0
      local.get $w433
      array.new $GcArray_79
      local.set $w434
      local.get $w434
      i32.const 0
      local.get $w432
      i32.const 0
      local.get $w431
      array.copy $GcArray_79 $GcArray_79
      local.get $xs
      local.get $w434
      struct.set $ResizeArray_171 0
    end
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    local.get $w431
    i32.const 300
    array.set $GcArray_79
    local.get $xs
    local.get $w431
    i32.const 1
    i32.add
    struct.set $ResizeArray_171 1
    local.get $xs
    struct.get $ResizeArray_171 0
    ref.cast (ref $GcArray_79)
    i32.const 1
    array.get $GcArray_79
  )
  (func $closure_175 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_175
    struct.new $ClosureType_175
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 2
    array.new_fixed $GcArray_79 4
    call $Set_ofArray
    local.set $s
    local.get $s
    return_call $Set_count
  )
  (func $runArrayTests (param $check (ref $AnyFn)) ;; exported as "runArrayTests"
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
    call_ref $FuncType_177
  )
  (func $closure_182 (param $self (ref $AnyFn)) (param $g (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (result i32)
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 1
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IGreeter 0
    call_ref $FuncType_177
  )
  (func $closure_185 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_185 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testInterfacePolymorphism (result i32) ;; exported as "testInterfacePolymorphism"
    (local $greeters (ref null $ListBase))
    (local $lo_clo_32 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_184))
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
    struct.new $ListCons_181
    struct.new $ListCons_181
    local.set $greeters
    ref.func $closure_182
    struct.new $ClosureType_184
    local.set $projection
    ref.func $closure_185
    local.get $projection
    struct.new $ClosureType_186
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_32
    local.get $lo_clo_32
    local.get $greeters
    local.get $lo_clo_32
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
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
    call_ref $FuncType_177
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
    call_ref $FuncType_177
  )
  (func $closure_193 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_177
  )
  (func $closure_196 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_196 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testDuInterfacePoly (result i32) ;; exported as "testDuInterfacePoly"
    (local $shapes (ref null $ListBase))
    (local $lo_clo_33 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_195))
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
    struct.new $ListCons_192
    struct.new $ListCons_192
    local.set $shapes
    ref.func $closure_193
    struct.new $ClosureType_195
    local.set $projection
    ref.func $closure_196
    local.get $projection
    struct.new $ClosureType_197
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_33
    local.get $lo_clo_33
    local.get $shapes
    local.get $lo_clo_33
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
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
    call_ref $FuncType_177
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
    call_ref $FuncType_177
  )
  (func $closure_200 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_177
  )
  (func $closure_201 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_201 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testMixedShapes (result i32) ;; exported as "testMixedShapes"
    (local $shapes (ref null $ListBase))
    (local $lo_clo_34 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_200))
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
    struct.new $ListCons_192
    struct.new $ListCons_192
    struct.new $ListCons_192
    local.set $shapes
    ref.func $closure_200
    struct.new $ClosureType_200
    local.set $projection
    ref.func $closure_201
    local.get $projection
    struct.new $ClosureType_202
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_34
    local.get $lo_clo_34
    local.get $shapes
    local.get $lo_clo_34
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $runInteropTests (param $check (ref $AnyFn)) ;; exported as "runInteropTests"
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
  (func $closure_203 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_2_10 (result i32) ;; exported as "testPowF64_2_10"
    f64.const 2
    f64.const 10
    ref.func $closure_203
    struct.new $ClosureType_205
    call_ref $ClosureType_205
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_206 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_zero (result i32) ;; exported as "testPowF64_zero"
    f64.const 3
    f64.const 0
    ref.func $closure_206
    struct.new $ClosureType_206
    call_ref $ClosureType_206
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_207 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_cube (result i32) ;; exported as "testPowF64_cube"
    f64.const 5
    f64.const 3
    ref.func $closure_207
    struct.new $ClosureType_207
    call_ref $ClosureType_207
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
  (func $closure_212 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_214))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_214)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_214 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_214 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_215 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_215))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_215)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_215 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_215 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_216 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_216))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_216)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_216 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_216 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_216
    local.get $a
    struct.new $ClosureType_216
  )
  (func $closure_218 (param $self (ref $AnyFn)) (param $option (ref null $Option_89)) (result i32)
    (local $self_cast (ref $ClosureType_220))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_220)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_220 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      local.get $value_2
    end
  )
  (func $testMapAddFind (result i32) ;; exported as "testMapAddFind"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_36 (ref $ClosureBase_213))
    (local $lo_clo_35 (ref $ClosureBase_213))
    (local $lo_clo_37 (ref $ClosureBase_219))
    ref.func $closure_212
    i32.const 2
    i32.const 200
    struct.new $ClosureType_214
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_36
    local.get $lo_clo_36
    ref.func $closure_215
    i32.const 1
    i32.const 100
    struct.new $ClosureType_215
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_35
    local.get $lo_clo_35
    ref.func $closure_216
    struct.new $ClosureType_217
    call $Map_empty
    local.get $lo_clo_35
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_36
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.set $m_2
    ref.func $closure_218
    i32.const 0
    struct.new $ClosureType_220
    ref.cast (ref $ClosureBase_219)
    local.set $lo_clo_37
    local.get $lo_clo_37
    i32.const 1
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_37
    struct.get $ClosureBase_219 0
    call_ref $FuncType_218
  )
  (func $closure_221 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_221))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_221)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_221 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_221 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_222 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_222))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_222)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_222 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_222 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_222
    local.get $a
    struct.new $ClosureType_222
  )
  (func $closure_224 (param $self (ref $AnyFn)) (param $option (ref null $Option_89)) (result i32)
    (local $self_cast (ref $ClosureType_224))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_224)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_224 1
    local.set $value_1
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      local.get $value_1
    end
  )
  (func $testMapFindMissing (result i32) ;; exported as "testMapFindMissing"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_38 (ref $ClosureBase_213))
    (local $lo_clo_39 (ref $ClosureBase_219))
    ref.func $closure_221
    i32.const 1
    i32.const 100
    struct.new $ClosureType_221
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_38
    local.get $lo_clo_38
    ref.func $closure_222
    struct.new $ClosureType_223
    call $Map_empty
    local.get $lo_clo_38
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.set $m_1
    ref.func $closure_224
    i32.const 0
    struct.new $ClosureType_224
    ref.cast (ref $ClosureBase_219)
    local.set $lo_clo_39
    local.get $lo_clo_39
    i32.const 99
    local.get $m_1
    call $Map_tryFind
    local.get $lo_clo_39
    struct.get $ClosureBase_219 0
    call_ref $FuncType_218
  )
  (func $closure_225 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_225))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_225)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_225 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_225 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_226 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_226))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_226)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_226 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_226 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_227 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_227))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_227)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_227 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_227 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_227
    local.get $a
    struct.new $ClosureType_227
  )
  (func $testMapCount (result i32) ;; exported as "testMapCount"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_41 (ref $ClosureBase_213))
    (local $lo_clo_40 (ref $ClosureBase_213))
    ref.func $closure_225
    i32.const 2
    i32.const 200
    struct.new $ClosureType_225
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_41
    local.get $lo_clo_41
    ref.func $closure_226
    i32.const 1
    i32.const 100
    struct.new $ClosureType_226
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_40
    local.get $lo_clo_40
    ref.func $closure_227
    struct.new $ClosureType_228
    call $Map_empty
    local.get $lo_clo_40
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_41
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.set $m_2
    local.get $m_2
    return_call $Map_count
  )
  (func $closure_229 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_229))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_229)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_229 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_229 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_230 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_230))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_230)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_230 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_230 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_230
    local.get $a
    struct.new $ClosureType_230
  )
  (func $testMapContainsKey (result i32) ;; exported as "testMapContainsKey"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_42 (ref $ClosureBase_213))
    ref.func $closure_229
    i32.const 42
    i32.const 999
    struct.new $ClosureType_229
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_42
    local.get $lo_clo_42
    ref.func $closure_230
    struct.new $ClosureType_231
    call $Map_empty
    local.get $lo_clo_42
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
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
  (func $closure_232 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_232))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_232)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_232 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_232 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_233 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_233))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_233)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_233 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_233 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_233
    local.get $a
    struct.new $ClosureType_233
  )
  (func $testMapContainsKeyMissing (result i32) ;; exported as "testMapContainsKeyMissing"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_43 (ref $ClosureBase_213))
    ref.func $closure_232
    i32.const 42
    i32.const 999
    struct.new $ClosureType_232
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_43
    local.get $lo_clo_43
    ref.func $closure_233
    struct.new $ClosureType_234
    call $Map_empty
    local.get $lo_clo_43
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
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
  (func $closure_235 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_235))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_235)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_235 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_235 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_236 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_236))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_236)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_236 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_236 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_237 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_237))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_237)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_237 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_237 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_237
    local.get $a
    struct.new $ClosureType_237
  )
  (func $closure_239 (param $self (ref $AnyFn)) (param $option (ref null $Option_89)) (result i32)
    (local $self_cast (ref $ClosureType_239))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_239)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_239 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      local.get $value_2
    end
  )
  (func $testMapAddReplace (result i32) ;; exported as "testMapAddReplace"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_45 (ref $ClosureBase_213))
    (local $lo_clo_44 (ref $ClosureBase_213))
    (local $lo_clo_46 (ref $ClosureBase_219))
    ref.func $closure_235
    i32.const 1
    i32.const 555
    struct.new $ClosureType_235
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_45
    local.get $lo_clo_45
    ref.func $closure_236
    i32.const 1
    i32.const 100
    struct.new $ClosureType_236
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_44
    local.get $lo_clo_44
    ref.func $closure_237
    struct.new $ClosureType_238
    call $Map_empty
    local.get $lo_clo_44
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_45
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.set $m_2
    ref.func $closure_239
    i32.const 0
    struct.new $ClosureType_239
    ref.cast (ref $ClosureBase_219)
    local.set $lo_clo_46
    local.get $lo_clo_46
    i32.const 1
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_46
    struct.get $ClosureBase_219 0
    call_ref $FuncType_218
  )
  (func $closure_240 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_240
    struct.new $ClosureType_240
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    i32.const 2
    local.get $m
    return_call $Map_find
  )
  (func $closure_241 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_242 (param $self (ref $AnyFn)) (param $option (ref null $Option_89)) (result i32)
    (local $self_cast (ref $ClosureType_242))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_242)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_242 1
    local.set $value
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      local.get $value
    end
  )
  (func $testStdMapTryFind (result i32) ;; exported as "testStdMapTryFind"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_47 (ref $ClosureBase_219))
    ref.func $closure_241
    struct.new $ClosureType_241
    i32.const 10
    i32.const 100
    struct.new $Tuple_90
    i32.const 20
    i32.const 200
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_242
    i32.const 0
    struct.new $ClosureType_242
    ref.cast (ref $ClosureBase_219)
    local.set $lo_clo_47
    local.get $lo_clo_47
    i32.const 20
    local.get $m
    call $Map_tryFind
    local.get $lo_clo_47
    struct.get $ClosureBase_219 0
    call_ref $FuncType_218
  )
  (func $closure_243 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_244 (param $self (ref $AnyFn)) (param $option (ref null $Option_89)) (result i32)
    (local $self_cast (ref $ClosureType_244))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_244)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_244 1
    local.set $value
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      local.get $value
    end
  )
  (func $testStdMapTryFindMissing (result i32) ;; exported as "testStdMapTryFindMissing"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_48 (ref $ClosureBase_219))
    ref.func $closure_243
    struct.new $ClosureType_243
    i32.const 1
    i32.const 1
    struct.new $Tuple_90
    i32.const 2
    i32.const 2
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_244
    i32.const 0
    struct.new $ClosureType_244
    ref.cast (ref $ClosureBase_219)
    local.set $lo_clo_48
    local.get $lo_clo_48
    i32.const 99
    local.get $m
    call $Map_tryFind
    local.get $lo_clo_48
    struct.get $ClosureBase_219 0
    call_ref $FuncType_218
  )
  (func $closure_245 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_245
    struct.new $ClosureType_245
    i32.const 5
    i32.const 50
    struct.new $Tuple_90
    i32.const 6
    i32.const 60
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
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
  (func $closure_246 (param $self (ref $AnyFn)) (param $table i32) (result i32)
    (local $self_cast (ref $ClosureType_246))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_246)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_246 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_246 2
    local.set $value
    local.get $key
    local.get $value
    local.get $table
    call $Map_add
  )
  (func $closure_247 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $lo_clo_49 (ref $ClosureBase_643))
    ref.func $closure_246
    i32.const 2
    i32.const 20
    struct.new $ClosureType_246
    ref.cast (ref $ClosureBase_643)
    local.set $lo_clo_49
    local.get $lo_clo_49
    ref.func $closure_247
    struct.new $ClosureType_247
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    call $Map_ofList
    local.get $lo_clo_49
    struct.get $ClosureBase_643 0
    call_ref $FuncType_248
    local.set $m
    i32.const 2
    local.get $m
    return_call $Map_find
  )
  (func $closure_249 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_250 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_249
    struct.new $ClosureType_249
    ref.null $ListBase
    call $Map_ofList
    local.set $e
    ref.func $closure_250
    struct.new $ClosureType_250
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    local.get $e
    call $Map_count
    local.get $m
    call $Map_count
    i32.add
  )
  (func $closure_251 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_251
    struct.new $ClosureType_251
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    i32.const 2
    local.get $m
    call $Map_remove
    local.set $m2
    local.get $m2
    return_call $Map_count
  )
  (func $closure_252 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_252
    struct.new $ClosureType_252
    i32.const 10
    i32.const 100
    struct.new $Tuple_90
    i32.const 20
    i32.const 200
    struct.new $Tuple_90
    i32.const 30
    i32.const 300
    struct.new $Tuple_90
    i32.const 40
    i32.const 400
    struct.new $Tuple_90
    i32.const 50
    i32.const 500
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    i32.const 30
    local.get $m
    return_call $Map_find
  )
  (func $closure_253 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
                ref.func $closure_253
                struct.new $ClosureType_253
                i32.const 1
                i32.const 10
                struct.new $Tuple_90
                i32.const 2
                i32.const 20
                struct.new $Tuple_90
                ref.null $ListBase
                struct.new $ListCons_91
                struct.new $ListCons_91
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
  (func $closure_254 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_255 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_255))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_255)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_255 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_255 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_256))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_256)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_256 1
    local.set $acc
    ref.func $closure_255
    local.get $acc
    struct.new $ClosureType_255
  )
  (func $closure_255 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_255
    local.get $acc
    struct.new $ClosureType_256
  )
  (func $testMapFold (result i32) ;; exported as "testMapFold"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_254
    struct.new $ClosureType_254
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_255
    struct.new $ClosureType_257
    i32.const 0
    local.get $m
    return_call $Map_fold
  )
  (func $closure_258 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_259 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_259))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_259)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_259 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_259 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_260))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_260)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_260 1
    local.set $acc
    ref.func $closure_259
    local.get $acc
    struct.new $ClosureType_259
  )
  (func $closure_259 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_259
    local.get $acc
    struct.new $ClosureType_260
  )
  (func $testMapIter (result i32) ;; exported as "testMapIter"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_258
    struct.new $ClosureType_258
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_259
    struct.new $ClosureType_261
    i32.const 0
    local.get $m
    return_call $Map_fold
  )
  (func $closure_262 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_263 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 15
    i32.gt_s
  )
  (func $closure_263 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_263
    struct.new $ClosureType_263
  )
  (func $testMapFilter (result i32) ;; exported as "testMapFilter"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_262
    struct.new $ClosureType_262
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_263
    struct.new $ClosureType_264
    local.get $m
    call $Map_filter
    local.set $m2
    local.get $m2
    return_call $Map_count
  )
  (func $closure_265 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_266 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 25
    i32.gt_s
  )
  (func $closure_266 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_266
    struct.new $ClosureType_266
  )
  (func $testMapExists (result i32) ;; exported as "testMapExists"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_265
    struct.new $ClosureType_265
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_266
    struct.new $ClosureType_267
    local.get $m
    call $Map_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_268 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_269 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 10
    i32.ge_s
  )
  (func $closure_269 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_269
    struct.new $ClosureType_269
  )
  (func $testMapForall (result i32) ;; exported as "testMapForall"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_268
    struct.new $ClosureType_268
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_269
    struct.new $ClosureType_270
    local.get $m
    call $Map_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_271 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_272 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 1
    i32.shl
  )
  (func $closure_272 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_272
    struct.new $ClosureType_272
  )
  (func $testMapMap (result i32) ;; exported as "testMapMap"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_271
    struct.new $ClosureType_271
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_272
    struct.new $ClosureType_273
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
  (func $closure_274 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_274))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_274)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_274 1
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
  (func $closure_274 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_274
    local.get $a
    struct.new $ClosureType_274
  )
  (func $closure_276 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_277 (param $self (ref $AnyFn)) (param $m_3 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_277))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_277)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_277 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_277 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_3
    call $Map_add
  )
  (func $closure_278 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_278))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_278)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_278 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_278 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_2
    call $Map_add
  )
  (func $closure_279 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_279))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_279)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_279 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_279 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m_1
    call $Map_add
  )
  (func $closure_280 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_280))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_280)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_280 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_280 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_281))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_281)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_281 1
    local.set $acc
    ref.func $closure_280
    local.get $acc
    struct.new $ClosureType_280
  )
  (func $closure_280 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_280
    local.get $acc
    struct.new $ClosureType_281
  )
  (func $testMapCustomCmpReverse (result i32) ;; exported as "testMapCustomCmpReverse"
    (local $reverseCmp (ref $ClosureType_275))
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_52 (ref $ClosureBase_213))
    (local $lo_clo_51 (ref $ClosureBase_213))
    (local $lo_clo_50 (ref $ClosureBase_213))
    ref.func $closure_274
    struct.new $ClosureType_275
    local.set $reverseCmp
    ref.func $closure_276
    struct.new $ClosureType_276
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_277
    i32.const 3
    i32.const 30
    struct.new $ClosureType_277
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_52
    local.get $lo_clo_52
    ref.func $closure_278
    i32.const 2
    i32.const 20
    struct.new $ClosureType_278
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_51
    local.get $lo_clo_51
    ref.func $closure_279
    i32.const 1
    i32.const 10
    struct.new $ClosureType_279
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_50
    local.get $lo_clo_50
    local.get $reverseCmp
    call $Map_empty
    local.get $lo_clo_50
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_51
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_52
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.set $m2
    ref.func $closure_280
    struct.new $ClosureType_282
    i32.const 0
    local.get $m2
    return_call $Map_fold
  )
  (func $closure_283 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_283))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_283)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_283 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_283 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_284 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_284))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_284)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_284 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_284 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_285 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_285))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_285)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_285 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_285 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_286 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_286))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_286)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_286 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_286 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_286
    local.get $a
    struct.new $ClosureType_286
  )
  (func $testMapModuleContainsKey (result i32) ;; exported as "testMapModuleContainsKey"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_55 (ref $ClosureBase_213))
    (local $lo_clo_54 (ref $ClosureBase_213))
    (local $lo_clo_53 (ref $ClosureBase_213))
    ref.func $closure_283
    i32.const 30
    i32.const 300
    struct.new $ClosureType_283
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_55
    local.get $lo_clo_55
    ref.func $closure_284
    i32.const 20
    i32.const 200
    struct.new $ClosureType_284
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_54
    local.get $lo_clo_54
    ref.func $closure_285
    i32.const 10
    i32.const 100
    struct.new $ClosureType_285
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_53
    local.get $lo_clo_53
    ref.func $closure_286
    struct.new $ClosureType_287
    call $Map_empty
    local.get $lo_clo_53
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_54
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_55
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
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
  (func $closure_288 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_288))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_288)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_288 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_288 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_289 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_289))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_289)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_289 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_289 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_290 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_290))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_290)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_290 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_290 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_290
    local.get $a
    struct.new $ClosureType_290
  )
  (func $closure_292 (param $self (ref $AnyFn)) (param $option (ref null $Option_89)) (result i32)
    (local $self_cast (ref $ClosureType_292))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_292)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_292 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      local.get $value_2
    end
  )
  (func $testMapModuleFindRoundTrip (result i32) ;; exported as "testMapModuleFindRoundTrip"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_57 (ref $ClosureBase_213))
    (local $lo_clo_56 (ref $ClosureBase_213))
    (local $lo_clo_58 (ref $ClosureBase_219))
    ref.func $closure_288
    i32.const 8
    i32.const 88
    struct.new $ClosureType_288
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_57
    local.get $lo_clo_57
    ref.func $closure_289
    i32.const 7
    i32.const 77
    struct.new $ClosureType_289
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_56
    local.get $lo_clo_56
    ref.func $closure_290
    struct.new $ClosureType_291
    call $Map_empty
    local.get $lo_clo_56
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_57
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.set $m_2
    i32.const 7
    local.get $m_2
    call $Map_find
    ref.func $closure_292
    i32.const 0
    struct.new $ClosureType_292
    ref.cast (ref $ClosureBase_219)
    local.set $lo_clo_58
    local.get $lo_clo_58
    i32.const 8
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_58
    struct.get $ClosureBase_219 0
    call_ref $FuncType_218
    i32.add
  )
  (func $closure_293 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_293))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_293)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_293 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_293 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_294 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_294))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_294)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_294 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_294 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_295 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_295))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_295)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_295 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_295 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_296 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_296))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_296)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_296 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_296 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_296
    local.get $a
    struct.new $ClosureType_296
  )
  (func $testMapModuleRemove (result i32) ;; exported as "testMapModuleRemove"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_61 (ref $ClosureBase_213))
    (local $lo_clo_60 (ref $ClosureBase_213))
    (local $lo_clo_59 (ref $ClosureBase_213))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_293
    i32.const 3
    i32.const 30
    struct.new $ClosureType_293
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_61
    local.get $lo_clo_61
    ref.func $closure_294
    i32.const 2
    i32.const 20
    struct.new $ClosureType_294
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_60
    local.get $lo_clo_60
    ref.func $closure_295
    i32.const 1
    i32.const 10
    struct.new $ClosureType_295
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_59
    local.get $lo_clo_59
    ref.func $closure_296
    struct.new $ClosureType_297
    call $Map_empty
    local.get $lo_clo_59
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_60
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_61
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
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
  (func $testListHead (result i32) ;; exported as "testListHead"
    (local $xs (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    local.get $xs
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
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
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    local.get $xs
    ref.is_null
    i32.eqz
    if (result i32)
      local.get $xs
      ref.cast (ref $ListCons_30)
      struct.get $ListCons_30 0
    else
      i32.const 0
    end
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
  (func $testListFoldSum (result i32) ;; exported as "testListFoldSum"
    (local $xs (ref null $ListBase))
    (local $w442 (ref null $ListBase))
    (local $w443 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    local.get $xs
    local.set $w442
    i32.const 0
    local.set $w443
    block $while_444_exit
      loop $while_444_lp
        local.get $w442
        ref.is_null
        i32.eqz
        if
          local.get $w442
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $w443
          local.get $x
          i32.add
          local.set $w443
          local.get $w442
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w442
          br $while_444_lp
        else
          br $while_444_exit
        end
      end
    end
    local.get $w443
  )
  (func $closure_300 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_301 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_301))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_301)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_301 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_301 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_301
    local.get $acc
    struct.new $ClosureType_301
  )
  (func $testListMapSum (result i32) ;; exported as "testListMapSum"
    (local $xs (ref null $ListBase))
    (local $doubled (ref null $ListBase))
    (local $w449 (ref null $ListBase))
    (local $w446 (ref null $ListBase))
    (local $w447 (ref null $ListBase))
    (local $x i32)
    (local $w450 (ref null $ListBase))
    (local $w453 (ref null $ListBase))
    (local $w454 i32)
    (local $x_1 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    local.get $xs
    local.set $w446
    ref.null $ListBase
    local.set $w447
    block $while_448_exit
      loop $while_448_lp
        local.get $w446
        ref.is_null
        i32.eqz
        if
          local.get $w446
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          local.get $w447
          struct.new $ListCons_30
          local.set $w447
          local.get $w446
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w446
          br $while_448_lp
        else
          br $while_448_exit
        end
      end
    end
    local.get $w447
    local.set $w449
    ref.null $ListBase
    local.set $w450
    block $while_451_exit
      loop $while_451_lp
        local.get $w449
        ref.is_null
        i32.eqz
        if
          local.get $w449
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w450
          struct.new $ListCons_30
          local.set $w450
          local.get $w449
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w449
          br $while_451_lp
        else
          br $while_451_exit
        end
      end
    end
    local.get $w450
    local.set $doubled
    local.get $doubled
    local.set $w453
    i32.const 0
    local.set $w454
    block $while_455_exit
      loop $while_455_lp
        local.get $w453
        ref.is_null
        i32.eqz
        if
          local.get $w453
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w454
          local.get $x_1
          i32.add
          local.set $w454
          local.get $w453
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w453
          br $while_455_lp
        else
          br $while_455_exit
        end
      end
    end
    local.get $w454
  )
  (func $closure_303 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $closure_304 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_304))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_304)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_304 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_304 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_304
    local.get $acc
    struct.new $ClosureType_304
  )
  (func $testListFilterSum (result i32) ;; exported as "testListFilterSum"
    (local $xs (ref null $ListBase))
    (local $big (ref null $ListBase))
    (local $w460 (ref null $ListBase))
    (local $w457 (ref null $ListBase))
    (local $w458 (ref null $ListBase))
    (local $x i32)
    (local $w461 (ref null $ListBase))
    (local $w464 (ref null $ListBase))
    (local $w465 i32)
    (local $x_1 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    local.get $xs
    local.set $w457
    ref.null $ListBase
    local.set $w458
    block $while_459_exit
      loop $while_459_lp
        local.get $w457
        ref.is_null
        i32.eqz
        if
          local.get $w457
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w457
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.get $w458
            struct.new $ListCons_30
          else
            local.get $w458
          end
          local.set $w458
          local.get $w457
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w457
          br $while_459_lp
        else
          br $while_459_exit
        end
      end
    end
    local.get $w458
    local.set $w460
    ref.null $ListBase
    local.set $w461
    block $while_462_exit
      loop $while_462_lp
        local.get $w460
        ref.is_null
        i32.eqz
        if
          local.get $w460
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w461
          struct.new $ListCons_30
          local.set $w461
          local.get $w460
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w460
          br $while_462_lp
        else
          br $while_462_exit
        end
      end
    end
    local.get $w461
    local.set $big
    local.get $big
    local.set $w464
    i32.const 0
    local.set $w465
    block $while_466_exit
      loop $while_466_lp
        local.get $w464
        ref.is_null
        i32.eqz
        if
          local.get $w464
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w465
          local.get $x_1
          i32.add
          local.set $w465
          local.get $w464
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w464
          br $while_466_lp
        else
          br $while_466_exit
        end
      end
    end
    local.get $w465
  )
  (func $testListRevHead (result i32) ;; exported as "testListRevHead"
    (local $xs (ref null $ListBase))
    (local $w468 (ref null $ListBase))
    (local $w469 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    local.get $xs
    local.set $w468
    ref.null $ListBase
    local.set $w469
    block $while_470_exit
      loop $while_470_lp
        local.get $w468
        ref.is_null
        i32.eqz
        if
          local.get $w468
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w469
          struct.new $ListCons_30
          local.set $w469
          local.get $w468
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w468
          br $while_470_lp
        else
          br $while_470_exit
        end
      end
    end
    local.get $w469
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListAppendLen (result i32) ;; exported as "testListAppendLen"
    (local $xs (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $w479 (ref null $ListBase))
    (local $w472 (ref null $ListBase))
    (local $w473 (ref null $ListBase))
    (local $w475 (ref null $ListBase))
    (local $w476 (ref null $ListBase))
    (local $w480 i32)
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $ys
    local.get $xs
    local.set $w472
    local.get $ys
    local.set $w473
    block $while_474_exit
      loop $while_474_lp
        local.get $w472
        ref.is_null
        i32.eqz
        if
          local.get $w472
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w473
          struct.new $ListCons_30
          local.set $w473
          local.get $w472
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w472
          br $while_474_lp
        else
          br $while_474_exit
        end
      end
    end
    local.get $w473
    local.set $w475
    ref.null $ListBase
    local.set $w476
    block $while_477_exit
      loop $while_477_lp
        local.get $w475
        ref.is_null
        i32.eqz
        if
          local.get $w475
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w476
          struct.new $ListCons_30
          local.set $w476
          local.get $w475
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w475
          br $while_477_lp
        else
          br $while_477_exit
        end
      end
    end
    local.get $w476
    local.set $w479
    i32.const 0
    local.set $w480
    block $while_481_exit
      loop $while_481_lp
        local.get $w479
        ref.is_null
        i32.eqz
        if
          local.get $w480
          i32.const 1
          i32.add
          local.set $w480
          local.get $w479
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w479
          br $while_481_lp
        else
          br $while_481_exit
        end
      end
    end
    local.get $w480
  )
  (func $closure_306 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_306))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_306)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_306 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIter (result i32) ;; exported as "testListIter"
    (local $acc i32)
    (local $w483 (ref null $ListBase))
    (local $x i32)
    i32.const 0
    local.set $acc
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w483
    block $while_484_exit
      loop $while_484_lp
        local.get $w483
        ref.is_null
        i32.eqz
        if
          local.get $w483
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w483
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w483
          br $while_484_lp
        else
          br $while_484_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_307 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_307))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_307)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_307 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIterEmpty (result i32) ;; exported as "testListIterEmpty"
    (local $acc i32)
    (local $w486 (ref null $ListBase))
    (local $x i32)
    i32.const 0
    local.set $acc
    ref.null $ListBase
    local.set $w486
    block $while_487_exit
      loop $while_487_lp
        local.get $w486
        ref.is_null
        i32.eqz
        if
          local.get $w486
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w486
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w486
          br $while_487_lp
        else
          br $while_487_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_308 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListExists (result i32) ;; exported as "testListExists"
    (local $w489 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w489
    block $exi_488_blk (result i32)
      block $exi_488_lp_exit
        loop $exi_488_lp
          local.get $w489
          ref.is_null
          i32.eqz
          if
            local.get $w489
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              i32.const 1
              br $exi_488_blk
            end
            local.get $w489
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w489
          else
            br $exi_488_lp_exit
          end
          br $exi_488_lp
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
  (func $closure_309 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListExistsFalse (result i32) ;; exported as "testListExistsFalse"
    (local $w491 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w491
    block $exi_490_blk (result i32)
      block $exi_490_lp_exit
        loop $exi_490_lp
          local.get $w491
          ref.is_null
          i32.eqz
          if
            local.get $w491
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $exi_490_blk
            end
            local.get $w491
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w491
          else
            br $exi_490_lp_exit
          end
          br $exi_490_lp
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
  (func $closure_310 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListForAll (result i32) ;; exported as "testListForAll"
    (local $w493 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w493
    block $all_492_blk (result i32)
      block $all_492_lp_exit
        loop $all_492_lp
          local.get $w493
          ref.is_null
          i32.eqz
          if
            local.get $w493
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w493
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w493
            else
              i32.const 0
              br $all_492_blk
            end
          else
            br $all_492_lp_exit
          end
          br $all_492_lp
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
  (func $closure_311 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testListForAllFalse (result i32) ;; exported as "testListForAllFalse"
    (local $w495 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w495
    block $all_494_blk (result i32)
      block $all_494_lp_exit
        loop $all_494_lp
          local.get $w495
          ref.is_null
          i32.eqz
          if
            local.get $w495
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 2
            i32.gt_s
            if
              local.get $w495
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w495
            else
              i32.const 0
              br $all_494_blk
            end
          else
            br $all_494_lp_exit
          end
          br $all_494_lp
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
  (func $closure_312 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSum (result i32) ;; exported as "testListSum"
    (local $w497 (ref null $ListBase))
    (local $w498 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w497
    i32.const 0
    local.set $w498
    block $while_499_exit
      loop $while_499_lp
        local.get $w497
        ref.is_null
        i32.eqz
        if
          local.get $w498
          local.get $w497
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w498
          local.get $w497
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w497
          br $while_499_lp
        else
          br $while_499_exit
        end
      end
    end
    local.get $w498
  )
  (func $closure_313 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumEmpty (result i32) ;; exported as "testListSumEmpty"
    (local $w501 (ref null $ListBase))
    (local $w502 i32)
    ref.null $ListBase
    local.set $w501
    i32.const 0
    local.set $w502
    block $while_503_exit
      loop $while_503_lp
        local.get $w501
        ref.is_null
        i32.eqz
        if
          local.get $w502
          local.get $w501
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w502
          local.get $w501
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w501
          br $while_503_lp
        else
          br $while_503_exit
        end
      end
    end
    local.get $w502
  )
  (func $closure_314 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListTryFindSome (result i32) ;; exported as "testListTryFindSome"
    (local $matchValue (ref null $Option_89))
    (local $w505 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w505
    block $tryf_504_exit (result (ref null $Option_89))
      block $tryf_504_lp_exit
        loop $tryf_504_lp
          local.get $w505
          ref.is_null
          i32.eqz
          if
            local.get $w505
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w505
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 0
              struct.new $Option_89
              br $tryf_504_exit
            end
            local.get $w505
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w505
          else
            br $tryf_504_lp_exit
          end
          br $tryf_504_lp
        end
      end
      ref.null $Option_89
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $closure_315 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindNone (result i32) ;; exported as "testListTryFindNone"
    (local $matchValue (ref null $Option_89))
    (local $w507 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w507
    block $tryf_506_exit (result (ref null $Option_89))
      block $tryf_506_lp_exit
        loop $tryf_506_lp
          local.get $w507
          ref.is_null
          i32.eqz
          if
            local.get $w507
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              local.get $w507
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 0
              struct.new $Option_89
              br $tryf_506_exit
            end
            local.get $w507
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w507
          else
            br $tryf_506_lp_exit
          end
          br $tryf_506_lp
        end
      end
      ref.null $Option_89
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $testListTryHeadSome (result i32) ;; exported as "testListTryHeadSome"
    (local $matchValue (ref null $Option_89))
    (local $w509 (ref null $ListBase))
    i32.const 7
    i32.const 8
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w509
    local.get $w509
    ref.is_null
    if (result (ref null $Option_89))
      ref.null $Option_89
    else
      local.get $w509
      ref.cast (ref $ListCons_30)
      struct.get $ListCons_30 0
      struct.new $Option_89
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $testListTryHeadNone (result i32) ;; exported as "testListTryHeadNone"
    (local $matchValue (ref null $Option_89))
    ref.null $Option_89
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $closure_316 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_316))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_316)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_316 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_316 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_316
    local.get $x
    struct.new $ClosureType_316
  )
  (func $closure_318 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_318))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_318)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_318 1
    local.set $i
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $closure_318 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_318
    local.get $i
    struct.new $ClosureType_318
  )
  (func $closure_320 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_320))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_320)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_320 1
    local.set $i
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $closure_320 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_320
    local.get $i
    struct.new $ClosureType_320
  )
  (func $testListMapi (result i32) ;; exported as "testListMapi"
    (local $w529 (ref null $ListBase))
    (local $w526 (ref null $ListBase))
    (local $w522 (ref null $ListBase))
    (local $w523 (ref null $ListBase))
    (local $w524 i32)
    (local $x_1 i32)
    (local $w527 (ref null $ListBase))
    (local $w530 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w522
    ref.null $ListBase
    local.set $w523
    i32.const 0
    local.set $w524
    block $while_525_exit
      loop $while_525_lp
        local.get $w522
        ref.is_null
        i32.eqz
        if
          local.get $w522
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w524
          local.get $x_1
          i32.mul
          local.get $w523
          struct.new $ListCons_30
          local.set $w523
          local.get $w524
          i32.const 1
          i32.add
          local.set $w524
          local.get $w522
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w522
          br $while_525_lp
        else
          br $while_525_exit
        end
      end
    end
    local.get $w523
    local.set $w526
    ref.null $ListBase
    local.set $w527
    block $while_528_exit
      loop $while_528_lp
        local.get $w526
        ref.is_null
        i32.eqz
        if
          local.get $w526
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w527
          struct.new $ListCons_30
          local.set $w527
          local.get $w526
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w526
          br $while_528_lp
        else
          br $while_528_exit
        end
      end
    end
    local.get $w527
    local.set $w529
    i32.const 0
    local.set $w530
    block $while_531_exit
      loop $while_531_lp
        local.get $w529
        ref.is_null
        i32.eqz
        if
          local.get $w529
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w530
          local.get $y
          i32.add
          local.set $w530
          local.get $w529
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w529
          br $while_531_lp
        else
          br $while_531_exit
        end
      end
    end
    local.get $w530
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
  (func $testListIteri (result i32) ;; exported as "testListIteri"
    (local $s i32)
    (local $w533 (ref null $ListBase))
    (local $w534 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w533
    i32.const 0
    local.set $w534
    block $while_535_exit
      loop $while_535_lp
        local.get $w533
        ref.is_null
        i32.eqz
        if
          local.get $w533
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $s
          local.get $w534
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w534
          i32.const 1
          i32.add
          local.set $w534
          local.get $w533
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w533
          br $while_535_lp
        else
          br $while_535_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_324 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $testListCollect (result i32) ;; exported as "testListCollect"
    (local $w549 (ref null $ListBase))
    (local $w537 (ref null $ListBase))
    (local $w538 (ref null $ListBase))
    (local $w539 (ref null $ListBase))
    (local $x i32)
    (local $w543 (ref null $ListBase))
    (local $w540 (ref null $ListBase))
    (local $w541 (ref null $ListBase))
    (local $w545 (ref null $ListBase))
    (local $w546 (ref null $ListBase))
    (local $w550 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w537
    ref.null $ListBase
    local.set $w538
    block $while_544_exit
      loop $while_544_lp
        local.get $w537
        ref.is_null
        i32.eqz
        if
          local.get $w537
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $x
          i32.const 1
          i32.shl
          ref.null $ListBase
          struct.new $ListCons_30
          struct.new $ListCons_30
          local.set $w539
          local.get $w539
          local.set $w540
          local.get $w538
          local.set $w541
          block $while_542_exit
            loop $while_542_lp
              local.get $w540
              ref.is_null
              i32.eqz
              if
                local.get $w540
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w541
                struct.new $ListCons_30
                local.set $w541
                local.get $w540
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w540
                br $while_542_lp
              else
                br $while_542_exit
              end
            end
          end
          local.get $w541
          local.set $w543
          local.get $w543
          local.set $w538
          local.get $w537
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w537
          br $while_544_lp
        else
          br $while_544_exit
        end
      end
    end
    local.get $w538
    local.set $w545
    ref.null $ListBase
    local.set $w546
    block $while_547_exit
      loop $while_547_lp
        local.get $w545
        ref.is_null
        i32.eqz
        if
          local.get $w545
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w546
          struct.new $ListCons_30
          local.set $w546
          local.get $w545
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w545
          br $while_547_lp
        else
          br $while_547_exit
        end
      end
    end
    local.get $w546
    local.set $w549
    i32.const 0
    local.set $w550
    block $while_551_exit
      loop $while_551_lp
        local.get $w549
        ref.is_null
        i32.eqz
        if
          local.get $w550
          i32.const 1
          i32.add
          local.set $w550
          local.get $w549
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w549
          br $while_551_lp
        else
          br $while_551_exit
        end
      end
    end
    local.get $w550
  )
  (func $closure_327 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_327))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_327)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_327 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_327 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_327
    local.get $x
    struct.new $ClosureType_327
  )
  (func $closure_329 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $closure_330 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $testListCollectOrder (result i32) ;; exported as "testListCollectOrder"
    (local $w577 (ref null $ListBase))
    (local $w566 (ref null $ListBase))
    (local $w567 (ref null $ListBase))
    (local $w568 (ref null $ListBase))
    (local $x_1 i32)
    (local $w572 (ref null $ListBase))
    (local $w569 (ref null $ListBase))
    (local $w570 (ref null $ListBase))
    (local $w574 (ref null $ListBase))
    (local $w575 (ref null $ListBase))
    (local $w578 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w566
    ref.null $ListBase
    local.set $w567
    block $while_573_exit
      loop $while_573_lp
        local.get $w566
        ref.is_null
        i32.eqz
        if
          local.get $w566
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $x_1
          local.get $x_1
          i32.const 1
          i32.shl
          ref.null $ListBase
          struct.new $ListCons_30
          struct.new $ListCons_30
          local.set $w568
          local.get $w568
          local.set $w569
          local.get $w567
          local.set $w570
          block $while_571_exit
            loop $while_571_lp
              local.get $w569
              ref.is_null
              i32.eqz
              if
                local.get $w569
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w570
                struct.new $ListCons_30
                local.set $w570
                local.get $w569
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w569
                br $while_571_lp
              else
                br $while_571_exit
              end
            end
          end
          local.get $w570
          local.set $w572
          local.get $w572
          local.set $w567
          local.get $w566
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w566
          br $while_573_lp
        else
          br $while_573_exit
        end
      end
    end
    local.get $w567
    local.set $w574
    ref.null $ListBase
    local.set $w575
    block $while_576_exit
      loop $while_576_lp
        local.get $w574
        ref.is_null
        i32.eqz
        if
          local.get $w574
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w575
          struct.new $ListCons_30
          local.set $w575
          local.get $w574
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w574
          br $while_576_lp
        else
          br $while_576_exit
        end
      end
    end
    local.get $w575
    local.set $w577
    i32.const 0
    local.set $w578
    block $while_579_exit
      loop $while_579_lp
        local.get $w577
        ref.is_null
        i32.eqz
        if
          local.get $w577
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w578
          local.get $y
          i32.add
          local.set $w578
          local.get $w577
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w577
          br $while_579_lp
        else
          br $while_579_exit
        end
      end
    end
    local.get $w578
  )
  (func $closure_331 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_89))
    local.get $x
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_89))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_89
    else
      ref.null $Option_89
    end
  )
  (func $testListChoose (result i32) ;; exported as "testListChoose"
    (local $w588 (ref null $ListBase))
    (local $w584 (ref null $ListBase))
    (local $w581 (ref null $ListBase))
    (local $w582 (ref null $ListBase))
    (local $cho_580_opt (ref null $Option_89))
    (local $x i32)
    (local $w585 (ref null $ListBase))
    (local $w589 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w581
    ref.null $ListBase
    local.set $w582
    block $while_583_exit
      loop $while_583_lp
        local.get $w581
        ref.is_null
        i32.eqz
        if
          local.get $w581
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_89))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_89
          else
            ref.null $Option_89
          end
          local.set $cho_580_opt
          local.get $cho_580_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_580_opt
            ref.cast (ref $Option_89)
            struct.get $Option_89 0
            local.get $w582
            struct.new $ListCons_30
          else
            local.get $w582
          end
          local.set $w582
          local.get $w581
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w581
          br $while_583_lp
        else
          br $while_583_exit
        end
      end
    end
    local.get $w582
    local.set $w584
    ref.null $ListBase
    local.set $w585
    block $while_586_exit
      loop $while_586_lp
        local.get $w584
        ref.is_null
        i32.eqz
        if
          local.get $w584
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w585
          struct.new $ListCons_30
          local.set $w585
          local.get $w584
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w584
          br $while_586_lp
        else
          br $while_586_exit
        end
      end
    end
    local.get $w585
    local.set $w588
    i32.const 0
    local.set $w589
    block $while_590_exit
      loop $while_590_lp
        local.get $w588
        ref.is_null
        i32.eqz
        if
          local.get $w589
          i32.const 1
          i32.add
          local.set $w589
          local.get $w588
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w588
          br $while_590_lp
        else
          br $while_590_exit
        end
      end
    end
    local.get $w589
  )
  (func $closure_332 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_332))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_332)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_332 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_332 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_332
    local.get $x
    struct.new $ClosureType_332
  )
  (func $closure_334 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_89))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_89))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_89
    else
      ref.null $Option_89
    end
  )
  (func $closure_335 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_89))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_89))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_89
    else
      ref.null $Option_89
    end
  )
  (func $testListChooseSum (result i32) ;; exported as "testListChooseSum"
    (local $w606 (ref null $ListBase))
    (local $w603 (ref null $ListBase))
    (local $w600 (ref null $ListBase))
    (local $w601 (ref null $ListBase))
    (local $cho_599_opt (ref null $Option_89))
    (local $x_1 i32)
    (local $w604 (ref null $ListBase))
    (local $w607 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w600
    ref.null $ListBase
    local.set $w601
    block $while_602_exit
      loop $while_602_lp
        local.get $w600
        ref.is_null
        i32.eqz
        if
          local.get $w600
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $x_1
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_89))
            local.get $x_1
            i32.const 10
            i32.mul
            struct.new $Option_89
          else
            ref.null $Option_89
          end
          local.set $cho_599_opt
          local.get $cho_599_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_599_opt
            ref.cast (ref $Option_89)
            struct.get $Option_89 0
            local.get $w601
            struct.new $ListCons_30
          else
            local.get $w601
          end
          local.set $w601
          local.get $w600
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w600
          br $while_602_lp
        else
          br $while_602_exit
        end
      end
    end
    local.get $w601
    local.set $w603
    ref.null $ListBase
    local.set $w604
    block $while_605_exit
      loop $while_605_lp
        local.get $w603
        ref.is_null
        i32.eqz
        if
          local.get $w603
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w604
          struct.new $ListCons_30
          local.set $w604
          local.get $w603
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w603
          br $while_605_lp
        else
          br $while_605_exit
        end
      end
    end
    local.get $w604
    local.set $w606
    i32.const 0
    local.set $w607
    block $while_608_exit
      loop $while_608_lp
        local.get $w606
        ref.is_null
        i32.eqz
        if
          local.get $w606
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w607
          local.get $y
          i32.add
          local.set $w607
          local.get $w606
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w606
          br $while_608_lp
        else
          br $while_608_exit
        end
      end
    end
    local.get $w607
  )
  (func $closure_336 (param $self (ref $AnyFn)) (param $acc (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_336))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_336)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_336 1
    local.set $x
    local.get $x
    local.get $acc
    struct.new $ListCons_30
  )
  (func $closure_336 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_336
    local.get $x
    struct.new $ClosureType_336
  )
  (func $testListFoldBack (result i32) ;; exported as "testListFoldBack"
    (local $w617 (ref null $ListBase))
    (local $w613 (ref null $ListBase))
    (local $w610 (ref null $ListBase))
    (local $w611 (ref null $ListBase))
    (local $w614 (ref null $ListBase))
    (local $x i32)
    (local $w618 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w610
    ref.null $ListBase
    local.set $w611
    block $while_612_exit
      loop $while_612_lp
        local.get $w610
        ref.is_null
        i32.eqz
        if
          local.get $w610
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w611
          struct.new $ListCons_30
          local.set $w611
          local.get $w610
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w610
          br $while_612_lp
        else
          br $while_612_exit
        end
      end
    end
    local.get $w611
    local.set $w613
    ref.null $ListBase
    local.set $w614
    block $while_615_exit
      loop $while_615_lp
        local.get $w613
        ref.is_null
        i32.eqz
        if
          local.get $w613
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w614
          struct.new $ListCons_30
          local.set $w614
          local.get $w613
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w613
          br $while_615_lp
        else
          br $while_615_exit
        end
      end
    end
    local.get $w614
    local.set $w617
    i32.const 0
    local.set $w618
    block $while_619_exit
      loop $while_619_lp
        local.get $w617
        ref.is_null
        i32.eqz
        if
          local.get $w618
          i32.const 1
          i32.add
          local.set $w618
          local.get $w617
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w617
          br $while_619_lp
        else
          br $while_619_exit
        end
      end
    end
    local.get $w618
  )
  (func $closure_338 (param $self (ref $AnyFn)) (param $acc i32) (result i32)
    (local $self_cast (ref $ClosureType_338))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_338)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_338 1
    local.set $x
    local.get $x
    local.get $acc
    i32.sub
  )
  (func $closure_338 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_338
    local.get $x
    struct.new $ClosureType_338
  )
  (func $testListFoldBackOrder (result i32) ;; exported as "testListFoldBackOrder"
    (local $w624 (ref null $ListBase))
    (local $w621 (ref null $ListBase))
    (local $w622 (ref null $ListBase))
    (local $w625 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w621
    ref.null $ListBase
    local.set $w622
    block $while_623_exit
      loop $while_623_lp
        local.get $w621
        ref.is_null
        i32.eqz
        if
          local.get $w621
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w622
          struct.new $ListCons_30
          local.set $w622
          local.get $w621
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w621
          br $while_623_lp
        else
          br $while_623_exit
        end
      end
    end
    local.get $w622
    local.set $w624
    i32.const 0
    local.set $w625
    block $while_626_exit
      loop $while_626_lp
        local.get $w624
        ref.is_null
        i32.eqz
        if
          local.get $w624
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w625
          i32.sub
          local.set $w625
          local.get $w624
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w624
          br $while_626_lp
        else
          br $while_626_exit
        end
      end
    end
    local.get $w625
  )
  (func $closure_340 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    local.get $x
    i32.mul
  )
  (func $closure_341 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumBy (result i32) ;; exported as "testListSumBy"
    (local $w628 (ref null $ListBase))
    (local $w629 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w628
    i32.const 0
    local.set $w629
    block $while_630_exit
      loop $while_630_lp
        local.get $w628
        ref.is_null
        i32.eqz
        if
          local.get $w629
          local.get $w628
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $x
          i32.mul
          i32.add
          local.set $w629
          local.get $w628
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w628
          br $while_630_lp
        else
          br $while_630_exit
        end
      end
    end
    local.get $w629
  )
  (func $closure_342 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_343 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w632 (ref null $ListBase))
    (local $w633 (ref $ListCons_30))
    (local $w634 i32)
    (local $w635 i32)
    (local $x i32)
    (local $w636 (ref null $ListBase))
    (local $w637 i32)
    (local $w638 i32)
    i32.const 4
    i32.const 2
    i32.const 7
    i32.const 1
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w632
    local.get $w632
    ref.cast (ref $ListCons_30)
    local.set $w633
    local.get $w633
    struct.get $ListCons_30 0
    local.set $w634
    local.get $w633
    struct.get $ListCons_30 0
    local.set $x
    local.get $x
    i32.const 3
    i32.rem_s
    local.set $w635
    local.get $w633
    struct.get $ListCons_30 1
    local.set $w636
    block $while_639_exit
      loop $while_639_lp
        local.get $w636
        ref.is_null
        i32.eqz
        if
          local.get $w636
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w637
          local.get $w637
          i32.const 3
          i32.rem_s
          local.set $w638
          local.get $w638
          local.get $w635
          i32.lt_s
          if
            local.get $w637
            local.set $w634
            local.get $w638
            local.set $w635
          end
          local.get $w636
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w636
          br $while_639_lp
        else
          br $while_639_exit
        end
      end
    end
    local.get $w634
  )
  (func $closure_344 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 5
    i32.rem_s
  )
  (func $closure_345 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w641 (ref null $ListBase))
    (local $w642 (ref $ListCons_30))
    (local $w643 i32)
    (local $w644 i32)
    (local $x i32)
    (local $w645 (ref null $ListBase))
    (local $w646 i32)
    (local $w647 i32)
    i32.const 3
    i32.const 8
    i32.const 1
    i32.const 6
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w641
    local.get $w641
    ref.cast (ref $ListCons_30)
    local.set $w642
    local.get $w642
    struct.get $ListCons_30 0
    local.set $w643
    local.get $w642
    struct.get $ListCons_30 0
    local.set $x
    local.get $x
    i32.const 5
    i32.rem_s
    local.set $w644
    local.get $w642
    struct.get $ListCons_30 1
    local.set $w645
    block $while_648_exit
      loop $while_648_lp
        local.get $w645
        ref.is_null
        i32.eqz
        if
          local.get $w645
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w646
          local.get $w646
          i32.const 5
          i32.rem_s
          local.set $w647
          local.get $w647
          local.get $w644
          i32.gt_s
          if
            local.get $w646
            local.set $w643
            local.get $w647
            local.set $w644
          end
          local.get $w645
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w645
          br $while_648_lp
        else
          br $while_648_exit
        end
      end
    end
    local.get $w643
  )
  (func $closure_346 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w650 (ref null $ListBase))
    (local $w651 (ref $ListCons_30))
    (local $w652 i32)
    (local $w653 (ref null $ListBase))
    (local $w654 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w650
    local.get $w650
    ref.cast (ref $ListCons_30)
    local.set $w651
    local.get $w651
    struct.get $ListCons_30 0
    local.set $w652
    local.get $w651
    struct.get $ListCons_30 1
    local.set $w653
    block $while_655_exit
      loop $while_655_lp
        local.get $w653
        ref.is_null
        i32.eqz
        if
          local.get $w653
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w654
          local.get $w654
          local.get $w652
          i32.lt_s
          if
            local.get $w654
            local.set $w652
          end
          local.get $w653
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w653
          br $while_655_lp
        else
          br $while_655_exit
        end
      end
    end
    local.get $w652
  )
  (func $closure_347 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w657 (ref null $ListBase))
    (local $w658 (ref $ListCons_30))
    (local $w659 i32)
    (local $w660 (ref null $ListBase))
    (local $w661 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w657
    local.get $w657
    ref.cast (ref $ListCons_30)
    local.set $w658
    local.get $w658
    struct.get $ListCons_30 0
    local.set $w659
    local.get $w658
    struct.get $ListCons_30 1
    local.set $w660
    block $while_662_exit
      loop $while_662_lp
        local.get $w660
        ref.is_null
        i32.eqz
        if
          local.get $w660
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w661
          local.get $w661
          local.get $w659
          i32.gt_s
          if
            local.get $w661
            local.set $w659
          end
          local.get $w660
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w660
          br $while_662_lp
        else
          br $while_662_exit
        end
      end
    end
    local.get $w659
  )
  (func $closure_348 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContains (result i32) ;; exported as "testListContains"
    (local $w665 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w665
    block $lcont_663_exit (result i32)
      block $lcont_663_lp_exit
        loop $lcont_663_lp
          local.get $w665
          ref.is_null
          i32.eqz
          if
            local.get $w665
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $lcont_663_exit
            end
            local.get $w665
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w665
          else
            br $lcont_663_lp_exit
          end
          br $lcont_663_lp
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
  (func $closure_349 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContainsFalse (result i32) ;; exported as "testListContainsFalse"
    (local $w668 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w668
    block $lcont_666_exit (result i32)
      block $lcont_666_lp_exit
        loop $lcont_666_lp
          local.get $w668
          ref.is_null
          i32.eqz
          if
            local.get $w668
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $lcont_666_exit
            end
            local.get $w668
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w668
          else
            br $lcont_666_lp_exit
          end
          br $lcont_666_lp
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
  (func $closure_350 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    i32.const 1
  )
  (func $testListInit (result i32) ;; exported as "testListInit"
    (local $w674 (ref null $ListBase))
    (local $w670 i32)
    (local $w671 (ref null $ListBase))
    (local $w675 i32)
    i32.const 4
    local.set $w670
    ref.null $ListBase
    local.set $w671
    block $while_672_exit
      loop $while_672_lp
        local.get $w670
        i32.const 0
        i32.ge_s
        if
          i32.const 1
          local.get $w671
          struct.new $ListCons_30
          local.set $w671
          local.get $w670
          i32.const 1
          i32.sub
          local.set $w670
          br $while_672_lp
        else
          br $while_672_exit
        end
      end
    end
    local.get $w671
    local.set $w674
    i32.const 0
    local.set $w675
    block $while_676_exit
      loop $while_676_lp
        local.get $w674
        ref.is_null
        i32.eqz
        if
          local.get $w675
          i32.const 1
          i32.add
          local.set $w675
          local.get $w674
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w674
          br $while_676_lp
        else
          br $while_676_exit
        end
      end
    end
    local.get $w675
  )
  (func $testListReplicate (result i32) ;; exported as "testListReplicate"
    (local $w680 i32)
    (local $w681 (ref null $ListBase))
    i32.const 0
    local.set $w680
    ref.null $ListBase
    local.set $w681
    block $while_682_exit
      loop $while_682_lp
        local.get $w680
        i32.const 4
        i32.lt_s
        if
          i32.const 7
          local.get $w681
          struct.new $ListCons_30
          local.set $w681
          local.get $w680
          i32.const 1
          i32.add
          local.set $w680
          br $while_682_lp
        else
          br $while_682_exit
        end
      end
    end
    local.get $w681
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListTake (result i32) ;; exported as "testListTake"
    (local $w692 i32)
    (local $w693 (ref null $ListBase))
    (local $w688 (ref null $ListBase))
    (local $w684 i32)
    (local $w685 (ref null $ListBase))
    (local $w686 (ref null $ListBase))
    (local $w689 (ref null $ListBase))
    i32.const 2
    local.set $w692
    i32.const 3
    local.set $w684
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w685
    ref.null $ListBase
    local.set $w686
    block $while_687_exit
      loop $while_687_lp
        local.get $w684
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w685
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w685
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w686
          struct.new $ListCons_30
          local.set $w686
          local.get $w685
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w685
          local.get $w684
          i32.const 1
          i32.sub
          local.set $w684
          br $while_687_lp
        else
          br $while_687_exit
        end
      end
    end
    local.get $w686
    local.set $w688
    ref.null $ListBase
    local.set $w689
    block $while_690_exit
      loop $while_690_lp
        local.get $w688
        ref.is_null
        i32.eqz
        if
          local.get $w688
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w689
          struct.new $ListCons_30
          local.set $w689
          local.get $w688
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w688
          br $while_690_lp
        else
          br $while_690_exit
        end
      end
    end
    local.get $w689
    local.set $w693
    block $while_694_exit
      loop $while_694_lp
        local.get $w692
        i32.const 0
        i32.gt_s
        if
          local.get $w693
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w693
          local.get $w692
          i32.const 1
          i32.sub
          local.set $w692
          br $while_694_lp
        else
          br $while_694_exit
        end
      end
    end
    local.get $w693
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListSkip (result i32) ;; exported as "testListSkip"
    (local $w696 i32)
    (local $w697 (ref null $ListBase))
    i32.const 2
    local.set $w696
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w697
    block $while_698_exit
      loop $while_698_lp
        local.get $w696
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w697
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w697
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w697
          local.get $w696
          i32.const 1
          i32.sub
          local.set $w696
          br $while_698_lp
        else
          br $while_698_exit
        end
      end
    end
    local.get $w697
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_351 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w700 (ref null $ListBase))
    (local $w704 i32)
    (local $w701 (ref null $ListBase))
    (local $w702 i32)
    (local $w705 (ref $GcArray_79))
    (local $w706 (ref null $ListBase))
    (local $w707 i32)
    (local $w709 i32)
    (local $w710 i32)
    (local $w711 i32)
    (local $w714 i32)
    (local $w715 (ref null $ListBase))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w700
    local.get $w700
    local.set $w701
    i32.const 0
    local.set $w702
    block $while_703_exit
      loop $while_703_lp
        local.get $w701
        ref.is_null
        i32.eqz
        if
          local.get $w702
          i32.const 1
          i32.add
          local.set $w702
          local.get $w701
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w701
          br $while_703_lp
        else
          br $while_703_exit
        end
      end
    end
    local.get $w702
    local.set $w704
    i32.const 0
    local.get $w704
    array.new $GcArray_79
    local.set $w705
    local.get $w700
    local.set $w706
    i32.const 0
    local.set $w707
    block $while_708_exit
      loop $while_708_lp
        local.get $w706
        ref.is_null
        i32.eqz
        if
          local.get $w705
          local.get $w707
          local.get $w706
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_79
          local.get $w707
          i32.const 1
          i32.add
          local.set $w707
          local.get $w706
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w706
          br $while_708_lp
        else
          br $while_708_exit
        end
      end
    end
    local.get $w707
    drop
    i32.const 1
    local.set $w709
    block $while_713_exit
      loop $while_713_lp
        local.get $w709
        local.get $w704
        i32.lt_s
        if
          local.get $w705
          local.get $w709
          array.get $GcArray_79
          local.set $w710
          local.get $w709
          i32.const 1
          i32.sub
          local.set $w711
          block $while_712_exit
            loop $while_712_lp
              local.get $w711
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w705
                local.get $w711
                array.get $GcArray_79
                local.get $w710
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
                local.get $w705
                local.get $w711
                i32.const 1
                i32.add
                local.get $w705
                local.get $w711
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w711
                i32.const 1
                i32.sub
                local.set $w711
                br $while_712_lp
              else
                br $while_712_exit
              end
            end
          end
          local.get $w705
          local.get $w711
          i32.const 1
          i32.add
          local.get $w710
          array.set $GcArray_79
          local.get $w709
          i32.const 1
          i32.add
          local.set $w709
          br $while_713_lp
        else
          br $while_713_exit
        end
      end
    end
    local.get $w704
    i32.const 1
    i32.sub
    local.set $w714
    ref.null $ListBase
    local.set $w715
    block $while_716_exit
      loop $while_716_lp
        local.get $w714
        i32.const 0
        i32.ge_s
        if
          local.get $w705
          local.get $w714
          array.get $GcArray_79
          local.get $w715
          struct.new $ListCons_30
          local.set $w715
          local.get $w714
          i32.const 1
          i32.sub
          local.set $w714
          br $while_716_lp
        else
          br $while_716_exit
        end
      end
    end
    local.get $w715
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_352 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListFindIndex (result i32) ;; exported as "testListFindIndex"
    (local $w718 (ref null $ListBase))
    (local $w719 i32)
    (local $x i32)
    i32.const 1
    i32.const 5
    i32.const 2
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w718
    i32.const 0
    local.set $w719
    block $fdi_717_exit (result i32)
      loop $fdi_717_lp
        local.get $w718
        ref.is_null
        i32.eqz
        if
          local.get $w718
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if
            local.get $w719
            br $fdi_717_exit
          else
            local.get $w719
            i32.const 1
            i32.add
            local.set $w719
            local.get $w718
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w718
            br $fdi_717_lp
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_353 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindIndex (result i32) ;; exported as "testListTryFindIndex"
    (local $matchValue (ref null $Option_89))
    (local $w721 (ref null $ListBase))
    (local $w722 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w721
    i32.const 0
    local.set $w722
    block $fdi_720_exit (result (ref null $Option_89))
      loop $fdi_720_lp
        local.get $w721
        ref.is_null
        i32.eqz
        if
          local.get $w721
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w722
            struct.new $Option_89
            br $fdi_720_exit
          else
            local.get $w722
            i32.const 1
            i32.add
            local.set $w722
            local.get $w721
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w721
            br $fdi_720_lp
          end
        end
      end
      ref.null $Option_89
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $testListItem (result i32) ;; exported as "testListItem"
    (local $w724 i32)
    (local $w725 (ref null $ListBase))
    i32.const 2
    local.set $w724
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    i32.const 50
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w725
    block $while_726_exit
      loop $while_726_lp
        local.get $w724
        i32.const 0
        i32.gt_s
        if
          local.get $w725
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w725
          local.get $w724
          i32.const 1
          i32.sub
          local.set $w724
          br $while_726_lp
        else
          br $while_726_exit
        end
      end
    end
    local.get $w725
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListTailHead (result i32) ;; exported as "testListTailHead"
    i32.const 100
    i32.const 200
    i32.const 300
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 1
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListLength (result i32) ;; exported as "testListLength"
    (local $w728 (ref null $ListBase))
    (local $w729 i32)
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w728
    i32.const 0
    local.set $w729
    block $while_730_exit
      loop $while_730_lp
        local.get $w728
        ref.is_null
        i32.eqz
        if
          local.get $w729
          i32.const 1
          i32.add
          local.set $w729
          local.get $w728
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w728
          br $while_730_lp
        else
          br $while_730_exit
        end
      end
    end
    local.get $w729
  )
  (func $closure_354 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_354))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_354)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_354 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_354 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_354
    local.get $a
    struct.new $ClosureType_354
  )
  (func $testListReduce (result i32) ;; exported as "testListReduce"
    (local $w731 (ref null $ListBase))
    (local $w732 (ref $ListCons_30))
    (local $w734 (ref null $ListBase))
    (local $w735 i32)
    (local $b i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w731
    local.get $w731
    ref.cast (ref $ListCons_30)
    local.set $w732
    local.get $w732
    struct.get $ListCons_30 1
    local.set $w734
    local.get $w732
    struct.get $ListCons_30 0
    local.set $w735
    block $while_736_exit
      loop $while_736_lp
        local.get $w734
        ref.is_null
        i32.eqz
        if
          local.get $w734
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $w735
          local.get $b
          i32.add
          local.set $w735
          local.get $w734
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w734
          br $while_736_lp
        else
          br $while_736_exit
        end
      end
    end
    local.get $w735
  )
  (func $closure_356 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_356))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_356)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_356 1
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
  (func $closure_356 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_356
    local.get $a
    struct.new $ClosureType_356
  )
  (func $testListReduceMax (result i32) ;; exported as "testListReduceMax"
    (local $w737 (ref null $ListBase))
    (local $w738 (ref $ListCons_30))
    (local $w740 (ref null $ListBase))
    (local $w741 i32)
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
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w737
    local.get $w737
    ref.cast (ref $ListCons_30)
    local.set $w738
    local.get $w738
    struct.get $ListCons_30 1
    local.set $w740
    local.get $w738
    struct.get $ListCons_30 0
    local.set $w741
    block $while_742_exit
      loop $while_742_lp
        local.get $w740
        ref.is_null
        i32.eqz
        if
          local.get $w740
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $w741
          local.get $b
          i32.gt_s
          if (result i32)
            local.get $w741
          else
            local.get $b
          end
          local.set $w741
          local.get $w740
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w740
          br $while_742_lp
        else
          br $while_742_exit
        end
      end
    end
    local.get $w741
  )
  (func $testListLast (result i32) ;; exported as "testListLast"
    (local $w744 (ref null $ListBase))
    (local $w745 (ref $ListCons_30))
    (local $w746 i32)
    (local $w747 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w744
    local.get $w744
    ref.cast (ref $ListCons_30)
    local.set $w745
    local.get $w745
    struct.get $ListCons_30 0
    local.set $w746
    local.get $w745
    struct.get $ListCons_30 1
    local.set $w747
    block $while_748_exit
      loop $while_748_lp
        local.get $w747
        ref.is_null
        i32.eqz
        if
          local.get $w747
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w746
          local.get $w747
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w747
          br $while_748_lp
        else
          br $while_748_exit
        end
      end
    end
    local.get $w746
  )
  (func $testListLastSingle (result i32) ;; exported as "testListLastSingle"
    (local $w750 (ref null $ListBase))
    (local $w751 (ref $ListCons_30))
    (local $w752 i32)
    (local $w753 (ref null $ListBase))
    i32.const 42
    ref.null $ListBase
    struct.new $ListCons_30
    local.set $w750
    local.get $w750
    ref.cast (ref $ListCons_30)
    local.set $w751
    local.get $w751
    struct.get $ListCons_30 0
    local.set $w752
    local.get $w751
    struct.get $ListCons_30 1
    local.set $w753
    block $while_754_exit
      loop $while_754_lp
        local.get $w753
        ref.is_null
        i32.eqz
        if
          local.get $w753
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w752
          local.get $w753
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w753
          br $while_754_lp
        else
          br $while_754_exit
        end
      end
    end
    local.get $w752
  )
  (func $closure_358 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w756 (ref null $ListBase))
    (local $w760 i32)
    (local $w757 (ref null $ListBase))
    (local $w758 i32)
    (local $w761 (ref $GcArray_79))
    (local $w762 (ref null $ListBase))
    (local $w763 i32)
    (local $w765 i32)
    (local $w766 i32)
    (local $w767 i32)
    (local $w770 i32)
    (local $w771 (ref null $ListBase))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w756
    local.get $w756
    local.set $w757
    i32.const 0
    local.set $w758
    block $while_759_exit
      loop $while_759_lp
        local.get $w757
        ref.is_null
        i32.eqz
        if
          local.get $w758
          i32.const 1
          i32.add
          local.set $w758
          local.get $w757
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w757
          br $while_759_lp
        else
          br $while_759_exit
        end
      end
    end
    local.get $w758
    local.set $w760
    i32.const 0
    local.get $w760
    array.new $GcArray_79
    local.set $w761
    local.get $w756
    local.set $w762
    i32.const 0
    local.set $w763
    block $while_764_exit
      loop $while_764_lp
        local.get $w762
        ref.is_null
        i32.eqz
        if
          local.get $w761
          local.get $w763
          local.get $w762
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_79
          local.get $w763
          i32.const 1
          i32.add
          local.set $w763
          local.get $w762
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w762
          br $while_764_lp
        else
          br $while_764_exit
        end
      end
    end
    local.get $w763
    drop
    i32.const 1
    local.set $w765
    block $while_769_exit
      loop $while_769_lp
        local.get $w765
        local.get $w760
        i32.lt_s
        if
          local.get $w761
          local.get $w765
          array.get $GcArray_79
          local.set $w766
          local.get $w765
          i32.const 1
          i32.sub
          local.set $w767
          block $while_768_exit
            loop $while_768_lp
              local.get $w767
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w761
                local.get $w767
                array.get $GcArray_79
                local.get $w766
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
                local.get $w761
                local.get $w767
                i32.const 1
                i32.add
                local.get $w761
                local.get $w767
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w767
                i32.const 1
                i32.sub
                local.set $w767
                br $while_768_lp
              else
                br $while_768_exit
              end
            end
          end
          local.get $w761
          local.get $w767
          i32.const 1
          i32.add
          local.get $w766
          array.set $GcArray_79
          local.get $w765
          i32.const 1
          i32.add
          local.set $w765
          br $while_769_lp
        else
          br $while_769_exit
        end
      end
    end
    local.get $w760
    i32.const 1
    i32.sub
    local.set $w770
    ref.null $ListBase
    local.set $w771
    block $while_772_exit
      loop $while_772_lp
        local.get $w770
        i32.const 0
        i32.ge_s
        if
          local.get $w761
          local.get $w770
          array.get $GcArray_79
          local.get $w771
          struct.new $ListCons_30
          local.set $w771
          local.get $w770
          i32.const 1
          i32.sub
          local.set $w770
          br $while_772_lp
        else
          br $while_772_exit
        end
      end
    end
    local.get $w771
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_359 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_360 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_361 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $lo_clo_62 (ref $ClosureBase_33))
    (local $w774 (ref null $ListBase))
    (local $w778 i32)
    (local $w775 (ref null $ListBase))
    (local $w776 i32)
    (local $w779 (ref $GcArray_79))
    (local $w780 (ref $GcArray_79))
    (local $w781 (ref null $ListBase))
    (local $w782 i32)
    (local $w783 i32)
    (local $w786 i32)
    (local $w787 i32)
    (local $w788 i32)
    (local $w789 i32)
    (local $w792 i32)
    (local $w793 (ref null $ListBase))
    ref.func $closure_359
    struct.new $ClosureType_359
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_62
    local.get $lo_clo_62
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 9
    i32.const 2
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w774
    local.get $w774
    local.set $w775
    i32.const 0
    local.set $w776
    block $while_777_exit
      loop $while_777_lp
        local.get $w775
        ref.is_null
        i32.eqz
        if
          local.get $w776
          i32.const 1
          i32.add
          local.set $w776
          local.get $w775
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w775
          br $while_777_lp
        else
          br $while_777_exit
        end
      end
    end
    local.get $w776
    local.set $w778
    i32.const 0
    local.get $w778
    array.new $GcArray_79
    local.set $w779
    i32.const 0
    local.get $w778
    array.new $GcArray_79
    local.set $w780
    local.get $w774
    local.set $w781
    i32.const 0
    local.set $w782
    block $while_785_exit
      loop $while_785_lp
        local.get $w781
        ref.is_null
        i32.eqz
        if
          local.get $w781
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w783
          local.get $w779
          local.get $w782
          local.get $w783
          array.set $GcArray_79
          local.get $w780
          local.get $w782
          local.get $w783
          array.set $GcArray_79
          local.get $w782
          i32.const 1
          i32.add
          local.set $w782
          local.get $w781
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w781
          br $while_785_lp
        else
          br $while_785_exit
        end
      end
    end
    local.get $w782
    drop
    i32.const 1
    local.set $w786
    block $while_791_exit
      loop $while_791_lp
        local.get $w786
        local.get $w778
        i32.lt_s
        if
          local.get $w779
          local.get $w786
          array.get $GcArray_79
          local.set $w787
          local.get $w780
          local.get $w786
          array.get $GcArray_79
          local.set $w788
          local.get $w786
          i32.const 1
          i32.sub
          local.set $w789
          block $while_790_exit
            loop $while_790_lp
              local.get $w789
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w780
                local.get $w789
                array.get $GcArray_79
                local.get $w788
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w779
                local.get $w789
                i32.const 1
                i32.add
                local.get $w779
                local.get $w789
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w780
                local.get $w789
                i32.const 1
                i32.add
                local.get $w780
                local.get $w789
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w789
                i32.const 1
                i32.sub
                local.set $w789
                br $while_790_lp
              else
                br $while_790_exit
              end
            end
          end
          local.get $w779
          local.get $w789
          i32.const 1
          i32.add
          local.get $w787
          array.set $GcArray_79
          local.get $w780
          local.get $w789
          i32.const 1
          i32.add
          local.get $w788
          array.set $GcArray_79
          local.get $w786
          i32.const 1
          i32.add
          local.set $w786
          br $while_791_lp
        else
          br $while_791_exit
        end
      end
    end
    local.get $w778
    i32.const 1
    i32.sub
    local.set $w792
    ref.null $ListBase
    local.set $w793
    block $while_794_exit
      loop $while_794_lp
        local.get $w792
        i32.const 0
        i32.ge_s
        if
          local.get $w779
          local.get $w792
          array.get $GcArray_79
          local.get $w793
          struct.new $ListCons_30
          local.set $w793
          local.get $w792
          i32.const 1
          i32.sub
          local.set $w792
          br $while_794_lp
        else
          br $while_794_exit
        end
      end
    end
    local.get $w793
    local.get $lo_clo_62
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_362 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_362 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w796 (ref null $ListBase))
    (local $w797 i32)
    local.get $list
    local.set $w796
    i32.const 0
    local.set $w797
    block $while_798_exit
      loop $while_798_lp
        local.get $w796
        ref.is_null
        i32.eqz
        if
          local.get $w797
          local.get $w796
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w797
          local.get $w796
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w796
          br $while_798_lp
        else
          br $while_798_exit
        end
      end
    end
    local.get $w797
  )
  (func $testListFlatten (result i32) ;; exported as "testListFlatten"
    (local $lo_clo_63 (ref $ClosureBase_33))
    (local $w800 (ref null $ListBase))
    (local $w801 (ref null $ListBase))
    (local $w803 (ref null $ListBase))
    (local $w804 (ref null $ListBase))
    ref.func $closure_362
    struct.new $ClosureType_363
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_63
    local.get $lo_clo_63
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w800
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w801
    block $while_802_exit
      loop $while_802_lp
        local.get $w800
        ref.is_null
        i32.eqz
        if
          local.get $w800
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w801
          struct.new $ListCons_30
          local.set $w801
          local.get $w800
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w800
          br $while_802_lp
        else
          br $while_802_exit
        end
      end
    end
    local.get $w801
    local.set $w803
    ref.null $ListBase
    local.set $w804
    block $while_805_exit
      loop $while_805_lp
        local.get $w803
        ref.is_null
        i32.eqz
        if
          local.get $w803
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w804
          struct.new $ListCons_30
          local.set $w804
          local.get $w803
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w803
          br $while_805_lp
        else
          br $while_805_exit
        end
      end
    end
    local.get $w804
    local.get $lo_clo_63
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
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
    (local $w807 (ref null $ListBase))
    (local $w808 (ref null $ListBase))
    (local $w809 (ref null $ListBase))
    (local $w811 (ref null $ListBase))
    (local $w812 (ref null $ListBase))
    (local $patternInput (ref $Tuple_90))
    (local $b i32)
    (local $a i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $ys
    local.get $xs
    local.set $w807
    local.get $ys
    local.set $w808
    ref.null $ListBase
    local.set $w809
    block $while_810_exit
      loop $while_810_lp
        local.get $w807
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w808
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w807
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w808
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          struct.new $Tuple_90
          local.get $w809
          struct.new $ListCons_91
          local.set $w809
          local.get $w807
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w807
          local.get $w808
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w808
          br $while_810_lp
        else
          br $while_810_exit
        end
      end
    end
    local.get $w809
    local.set $w811
    ref.null $ListBase
    local.set $w812
    block $while_813_exit
      loop $while_813_lp
        local.get $w811
        ref.is_null
        i32.eqz
        if
          local.get $w811
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 0
          local.get $w812
          struct.new $ListCons_91
          local.set $w812
          local.get $w811
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 1
          local.set $w811
          br $while_813_lp
        else
          br $while_813_exit
        end
      end
    end
    local.get $w812
    local.set $zipped
    local.get $zipped
    ref.cast (ref $ListCons_91)
    struct.get $ListCons_91 0
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_90 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_90 0
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_368 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w815 (ref null $ListBase))
    (local $w816 i32)
    local.get $list
    local.set $w815
    i32.const 0
    local.set $w816
    block $while_817_exit
      loop $while_817_lp
        local.get $w815
        ref.is_null
        i32.eqz
        if
          local.get $w816
          i32.const 1
          i32.add
          local.set $w816
          local.get $w815
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 1
          local.set $w815
          br $while_817_lp
        else
          br $while_817_exit
        end
      end
    end
    local.get $w816
  )
  (func $testListZipLen (result i32) ;; exported as "testListZipLen"
    (local $xs (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $lo_clo_64 (ref $ClosureBase_33))
    (local $w819 (ref null $ListBase))
    (local $w820 (ref null $ListBase))
    (local $w821 (ref null $ListBase))
    (local $w823 (ref null $ListBase))
    (local $w824 (ref null $ListBase))
    i32.const 97
    i32.const 98
    i32.const 99
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $ys
    ref.func $closure_368
    struct.new $ClosureType_368
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_64
    local.get $lo_clo_64
    local.get $xs
    local.set $w819
    local.get $ys
    local.set $w820
    ref.null $ListBase
    local.set $w821
    block $while_822_exit
      loop $while_822_lp
        local.get $w819
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w820
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w819
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w820
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          struct.new $Tuple_90
          local.get $w821
          struct.new $ListCons_91
          local.set $w821
          local.get $w819
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w819
          local.get $w820
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w820
          br $while_822_lp
        else
          br $while_822_exit
        end
      end
    end
    local.get $w821
    local.set $w823
    ref.null $ListBase
    local.set $w824
    block $while_825_exit
      loop $while_825_lp
        local.get $w823
        ref.is_null
        i32.eqz
        if
          local.get $w823
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 0
          local.get $w824
          struct.new $ListCons_91
          local.set $w824
          local.get $w823
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 1
          local.set $w823
          br $while_825_lp
        else
          br $while_825_exit
        end
      end
    end
    local.get $w824
    local.get $lo_clo_64
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_369 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_369 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w827 (ref null $ListBase))
    (local $w828 i32)
    local.get $list
    local.set $w827
    i32.const 0
    local.set $w828
    block $while_829_exit
      loop $while_829_lp
        local.get $w827
        ref.is_null
        i32.eqz
        if
          local.get $w828
          local.get $w827
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w828
          local.get $w827
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w827
          br $while_829_lp
        else
          br $while_829_exit
        end
      end
    end
    local.get $w828
  )
  (func $closure_371 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_371))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_371)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_371 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_371 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_371
    local.get $a
    struct.new $ClosureType_371
  )
  (func $testListMap2Sum (result i32) ;; exported as "testListMap2Sum"
    (local $lo_clo_65 (ref $ClosureBase_33))
    (local $w831 (ref null $ListBase))
    (local $w832 (ref null $ListBase))
    (local $w833 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w835 (ref null $ListBase))
    (local $w836 (ref null $ListBase))
    ref.func $closure_369
    struct.new $ClosureType_370
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_65
    local.get $lo_clo_65
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w831
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w832
    ref.null $ListBase
    local.set $w833
    block $while_834_exit
      loop $while_834_lp
        local.get $w831
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w832
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w831
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $a
          local.get $w832
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $a
          local.get $b
          i32.add
          local.get $w833
          struct.new $ListCons_30
          local.set $w833
          local.get $w831
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w831
          local.get $w832
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w832
          br $while_834_lp
        else
          br $while_834_exit
        end
      end
    end
    local.get $w833
    local.set $w835
    ref.null $ListBase
    local.set $w836
    block $while_837_exit
      loop $while_837_lp
        local.get $w835
        ref.is_null
        i32.eqz
        if
          local.get $w835
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w836
          struct.new $ListCons_30
          local.set $w836
          local.get $w835
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w835
          br $while_837_lp
        else
          br $while_837_exit
        end
      end
    end
    local.get $w836
    local.get $lo_clo_65
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_373 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_374 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_374))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_374)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_374 1
    local.set $a
    local.get $a
    local.get $b
    i32.mul
  )
  (func $closure_374 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_374
    local.get $a
    struct.new $ClosureType_374
  )
  (func $testListMap2Head (result i32) ;; exported as "testListMap2Head"
    (local $lo_clo_66 (ref $ClosureBase_33))
    (local $w839 (ref null $ListBase))
    (local $w840 (ref null $ListBase))
    (local $w841 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w843 (ref null $ListBase))
    (local $w844 (ref null $ListBase))
    ref.func $closure_373
    struct.new $ClosureType_373
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_66
    local.get $lo_clo_66
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w839
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w840
    ref.null $ListBase
    local.set $w841
    block $while_842_exit
      loop $while_842_lp
        local.get $w839
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w840
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w839
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $a
          local.get $w840
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          local.get $w841
          struct.new $ListCons_30
          local.set $w841
          local.get $w839
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w839
          local.get $w840
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w840
          br $while_842_lp
        else
          br $while_842_exit
        end
      end
    end
    local.get $w841
    local.set $w843
    ref.null $ListBase
    local.set $w844
    block $while_845_exit
      loop $while_845_lp
        local.get $w843
        ref.is_null
        i32.eqz
        if
          local.get $w843
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w844
          struct.new $ListCons_30
          local.set $w844
          local.get $w843
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w843
          br $while_845_lp
        else
          br $while_845_exit
        end
      end
    end
    local.get $w844
    local.get $lo_clo_66
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_377 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionCounts (result i32) ;; exported as "testListPartitionCounts"
    (local $patternInput (ref $Tuple_376))
    (local $w847 (ref null $ListBase))
    (local $w848 (ref null $ListBase))
    (local $w849 (ref null $ListBase))
    (local $w850 i32)
    (local $w852 (ref null $ListBase))
    (local $w853 (ref null $ListBase))
    (local $w855 (ref null $ListBase))
    (local $w856 (ref null $ListBase))
    (local $odds (ref null $ListBase))
    (local $evens (ref null $ListBase))
    (local $w859 (ref null $ListBase))
    (local $w860 i32)
    (local $w863 (ref null $ListBase))
    (local $w864 i32)
    ref.null $ListBase
    local.set $w847
    ref.null $ListBase
    local.set $w848
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w849
    block $while_851_exit
      loop $while_851_lp
        local.get $w849
        ref.is_null
        i32.eqz
        if
          local.get $w849
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w850
          local.get $w850
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w850
            local.get $w847
            struct.new $ListCons_30
            local.set $w847
          else
            local.get $w850
            local.get $w848
            struct.new $ListCons_30
            local.set $w848
          end
          local.get $w849
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w849
          br $while_851_lp
        else
          br $while_851_exit
        end
      end
    end
    local.get $w847
    local.set $w852
    ref.null $ListBase
    local.set $w853
    block $while_854_exit
      loop $while_854_lp
        local.get $w852
        ref.is_null
        i32.eqz
        if
          local.get $w852
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w853
          struct.new $ListCons_30
          local.set $w853
          local.get $w852
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w852
          br $while_854_lp
        else
          br $while_854_exit
        end
      end
    end
    local.get $w853
    local.get $w848
    local.set $w855
    ref.null $ListBase
    local.set $w856
    block $while_857_exit
      loop $while_857_lp
        local.get $w855
        ref.is_null
        i32.eqz
        if
          local.get $w855
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w856
          struct.new $ListCons_30
          local.set $w856
          local.get $w855
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w855
          br $while_857_lp
        else
          br $while_857_exit
        end
      end
    end
    local.get $w856
    struct.new $Tuple_376
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_376 1
    local.set $odds
    local.get $patternInput
    struct.get $Tuple_376 0
    local.set $evens
    local.get $evens
    local.set $w859
    i32.const 0
    local.set $w860
    block $while_861_exit
      loop $while_861_lp
        local.get $w859
        ref.is_null
        i32.eqz
        if
          local.get $w860
          i32.const 1
          i32.add
          local.set $w860
          local.get $w859
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w859
          br $while_861_lp
        else
          br $while_861_exit
        end
      end
    end
    local.get $w860
    i32.const 10
    i32.mul
    local.get $odds
    local.set $w863
    i32.const 0
    local.set $w864
    block $while_865_exit
      loop $while_865_lp
        local.get $w863
        ref.is_null
        i32.eqz
        if
          local.get $w864
          i32.const 1
          i32.add
          local.set $w864
          local.get $w863
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w863
          br $while_865_lp
        else
          br $while_865_exit
        end
      end
    end
    local.get $w864
    i32.add
  )
  (func $closure_378 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_379 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionEvens (result i32) ;; exported as "testListPartitionEvens"
    (local $patternInput (ref $Tuple_376))
    (local $w867 (ref null $ListBase))
    (local $w868 (ref null $ListBase))
    (local $w869 (ref null $ListBase))
    (local $w870 i32)
    (local $w872 (ref null $ListBase))
    (local $w873 (ref null $ListBase))
    (local $w875 (ref null $ListBase))
    (local $w876 (ref null $ListBase))
    (local $evens (ref null $ListBase))
    (local $w879 (ref null $ListBase))
    (local $w880 i32)
    ref.null $ListBase
    local.set $w867
    ref.null $ListBase
    local.set $w868
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w869
    block $while_871_exit
      loop $while_871_lp
        local.get $w869
        ref.is_null
        i32.eqz
        if
          local.get $w869
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w870
          local.get $w870
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w870
            local.get $w867
            struct.new $ListCons_30
            local.set $w867
          else
            local.get $w870
            local.get $w868
            struct.new $ListCons_30
            local.set $w868
          end
          local.get $w869
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w869
          br $while_871_lp
        else
          br $while_871_exit
        end
      end
    end
    local.get $w867
    local.set $w872
    ref.null $ListBase
    local.set $w873
    block $while_874_exit
      loop $while_874_lp
        local.get $w872
        ref.is_null
        i32.eqz
        if
          local.get $w872
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w873
          struct.new $ListCons_30
          local.set $w873
          local.get $w872
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w872
          br $while_874_lp
        else
          br $while_874_exit
        end
      end
    end
    local.get $w873
    local.get $w868
    local.set $w875
    ref.null $ListBase
    local.set $w876
    block $while_877_exit
      loop $while_877_lp
        local.get $w875
        ref.is_null
        i32.eqz
        if
          local.get $w875
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w876
          struct.new $ListCons_30
          local.set $w876
          local.get $w875
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w875
          br $while_877_lp
        else
          br $while_877_exit
        end
      end
    end
    local.get $w876
    struct.new $Tuple_376
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_376 0
    local.set $evens
    local.get $evens
    local.set $w879
    i32.const 0
    local.set $w880
    block $while_881_exit
      loop $while_881_lp
        local.get $w879
        ref.is_null
        i32.eqz
        if
          local.get $w880
          local.get $w879
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w880
          local.get $w879
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w879
          br $while_881_lp
        else
          br $while_881_exit
        end
      end
    end
    local.get $w880
  )
  (func $closure_380 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_381 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionOdds (result i32) ;; exported as "testListPartitionOdds"
    (local $patternInput (ref $Tuple_376))
    (local $w883 (ref null $ListBase))
    (local $w884 (ref null $ListBase))
    (local $w885 (ref null $ListBase))
    (local $w886 i32)
    (local $w888 (ref null $ListBase))
    (local $w889 (ref null $ListBase))
    (local $w891 (ref null $ListBase))
    (local $w892 (ref null $ListBase))
    (local $odds (ref null $ListBase))
    (local $w895 (ref null $ListBase))
    (local $w896 i32)
    ref.null $ListBase
    local.set $w883
    ref.null $ListBase
    local.set $w884
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w885
    block $while_887_exit
      loop $while_887_lp
        local.get $w885
        ref.is_null
        i32.eqz
        if
          local.get $w885
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w886
          local.get $w886
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w886
            local.get $w883
            struct.new $ListCons_30
            local.set $w883
          else
            local.get $w886
            local.get $w884
            struct.new $ListCons_30
            local.set $w884
          end
          local.get $w885
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w885
          br $while_887_lp
        else
          br $while_887_exit
        end
      end
    end
    local.get $w883
    local.set $w888
    ref.null $ListBase
    local.set $w889
    block $while_890_exit
      loop $while_890_lp
        local.get $w888
        ref.is_null
        i32.eqz
        if
          local.get $w888
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w889
          struct.new $ListCons_30
          local.set $w889
          local.get $w888
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w888
          br $while_890_lp
        else
          br $while_890_exit
        end
      end
    end
    local.get $w889
    local.get $w884
    local.set $w891
    ref.null $ListBase
    local.set $w892
    block $while_893_exit
      loop $while_893_lp
        local.get $w891
        ref.is_null
        i32.eqz
        if
          local.get $w891
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w892
          struct.new $ListCons_30
          local.set $w892
          local.get $w891
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w891
          br $while_893_lp
        else
          br $while_893_exit
        end
      end
    end
    local.get $w892
    struct.new $Tuple_376
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_376 1
    local.set $odds
    local.get $odds
    local.set $w895
    i32.const 0
    local.set $w896
    block $while_897_exit
      loop $while_897_lp
        local.get $w895
        ref.is_null
        i32.eqz
        if
          local.get $w896
          local.get $w895
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w896
          local.get $w895
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w895
          br $while_897_lp
        else
          br $while_897_exit
        end
      end
    end
    local.get $w896
  )
  (func $closure_382 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionEmpty (result i32) ;; exported as "testListPartitionEmpty"
    (local $patternInput (ref $Tuple_376))
    (local $w899 (ref null $ListBase))
    (local $w900 (ref null $ListBase))
    (local $w901 (ref null $ListBase))
    (local $w902 i32)
    (local $w904 (ref null $ListBase))
    (local $w905 (ref null $ListBase))
    (local $w907 (ref null $ListBase))
    (local $w908 (ref null $ListBase))
    (local $b (ref null $ListBase))
    (local $a (ref null $ListBase))
    (local $w911 (ref null $ListBase))
    (local $w912 i32)
    (local $w915 (ref null $ListBase))
    (local $w916 i32)
    ref.null $ListBase
    local.set $w899
    ref.null $ListBase
    local.set $w900
    ref.null $ListBase
    local.set $w901
    block $while_903_exit
      loop $while_903_lp
        local.get $w901
        ref.is_null
        i32.eqz
        if
          local.get $w901
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w902
          local.get $w902
          i32.const 0
          i32.gt_s
          if
            local.get $w902
            local.get $w899
            struct.new $ListCons_30
            local.set $w899
          else
            local.get $w902
            local.get $w900
            struct.new $ListCons_30
            local.set $w900
          end
          local.get $w901
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w901
          br $while_903_lp
        else
          br $while_903_exit
        end
      end
    end
    local.get $w899
    local.set $w904
    ref.null $ListBase
    local.set $w905
    block $while_906_exit
      loop $while_906_lp
        local.get $w904
        ref.is_null
        i32.eqz
        if
          local.get $w904
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w905
          struct.new $ListCons_30
          local.set $w905
          local.get $w904
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w904
          br $while_906_lp
        else
          br $while_906_exit
        end
      end
    end
    local.get $w905
    local.get $w900
    local.set $w907
    ref.null $ListBase
    local.set $w908
    block $while_909_exit
      loop $while_909_lp
        local.get $w907
        ref.is_null
        i32.eqz
        if
          local.get $w907
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w908
          struct.new $ListCons_30
          local.set $w908
          local.get $w907
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w907
          br $while_909_lp
        else
          br $while_909_exit
        end
      end
    end
    local.get $w908
    struct.new $Tuple_376
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_376 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_376 0
    local.set $a
    local.get $a
    local.set $w911
    i32.const 0
    local.set $w912
    block $while_913_exit
      loop $while_913_lp
        local.get $w911
        ref.is_null
        i32.eqz
        if
          local.get $w912
          i32.const 1
          i32.add
          local.set $w912
          local.get $w911
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w911
          br $while_913_lp
        else
          br $while_913_exit
        end
      end
    end
    local.get $w912
    local.get $b
    local.set $w915
    i32.const 0
    local.set $w916
    block $while_917_exit
      loop $while_917_lp
        local.get $w915
        ref.is_null
        i32.eqz
        if
          local.get $w916
          i32.const 1
          i32.add
          local.set $w916
          local.get $w915
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w915
          br $while_917_lp
        else
          br $while_917_exit
        end
      end
    end
    local.get $w916
    i32.add
  )
  (func $closure_383 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionAllTrue (result i32) ;; exported as "testListPartitionAllTrue"
    (local $patternInput (ref $Tuple_376))
    (local $w919 (ref null $ListBase))
    (local $w920 (ref null $ListBase))
    (local $w921 (ref null $ListBase))
    (local $w922 i32)
    (local $w924 (ref null $ListBase))
    (local $w925 (ref null $ListBase))
    (local $w927 (ref null $ListBase))
    (local $w928 (ref null $ListBase))
    (local $b (ref null $ListBase))
    (local $a (ref null $ListBase))
    (local $w931 (ref null $ListBase))
    (local $w932 i32)
    (local $w935 (ref null $ListBase))
    (local $w936 i32)
    ref.null $ListBase
    local.set $w919
    ref.null $ListBase
    local.set $w920
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w921
    block $while_923_exit
      loop $while_923_lp
        local.get $w921
        ref.is_null
        i32.eqz
        if
          local.get $w921
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w922
          local.get $w922
          i32.const 0
          i32.gt_s
          if
            local.get $w922
            local.get $w919
            struct.new $ListCons_30
            local.set $w919
          else
            local.get $w922
            local.get $w920
            struct.new $ListCons_30
            local.set $w920
          end
          local.get $w921
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w921
          br $while_923_lp
        else
          br $while_923_exit
        end
      end
    end
    local.get $w919
    local.set $w924
    ref.null $ListBase
    local.set $w925
    block $while_926_exit
      loop $while_926_lp
        local.get $w924
        ref.is_null
        i32.eqz
        if
          local.get $w924
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w925
          struct.new $ListCons_30
          local.set $w925
          local.get $w924
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w924
          br $while_926_lp
        else
          br $while_926_exit
        end
      end
    end
    local.get $w925
    local.get $w920
    local.set $w927
    ref.null $ListBase
    local.set $w928
    block $while_929_exit
      loop $while_929_lp
        local.get $w927
        ref.is_null
        i32.eqz
        if
          local.get $w927
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w928
          struct.new $ListCons_30
          local.set $w928
          local.get $w927
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w927
          br $while_929_lp
        else
          br $while_929_exit
        end
      end
    end
    local.get $w928
    struct.new $Tuple_376
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_376 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_376 0
    local.set $a
    local.get $a
    local.set $w931
    i32.const 0
    local.set $w932
    block $while_933_exit
      loop $while_933_lp
        local.get $w931
        ref.is_null
        i32.eqz
        if
          local.get $w932
          i32.const 1
          i32.add
          local.set $w932
          local.get $w931
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w931
          br $while_933_lp
        else
          br $while_933_exit
        end
      end
    end
    local.get $w932
    i32.const 10
    i32.mul
    local.get $b
    local.set $w935
    i32.const 0
    local.set $w936
    block $while_937_exit
      loop $while_937_lp
        local.get $w935
        ref.is_null
        i32.eqz
        if
          local.get $w936
          i32.const 1
          i32.add
          local.set $w936
          local.get $w935
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w935
          br $while_937_lp
        else
          br $while_937_exit
        end
      end
    end
    local.get $w936
    i32.add
  )
  (func $closure_384 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionOrder (result i32) ;; exported as "testListPartitionOrder"
    (local $patternInput (ref $Tuple_376))
    (local $w939 (ref null $ListBase))
    (local $w940 (ref null $ListBase))
    (local $w941 (ref null $ListBase))
    (local $w942 i32)
    (local $w944 (ref null $ListBase))
    (local $w945 (ref null $ListBase))
    (local $w947 (ref null $ListBase))
    (local $w948 (ref null $ListBase))
    (local $evens (ref null $ListBase))
    ref.null $ListBase
    local.set $w939
    ref.null $ListBase
    local.set $w940
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w941
    block $while_943_exit
      loop $while_943_lp
        local.get $w941
        ref.is_null
        i32.eqz
        if
          local.get $w941
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w942
          local.get $w942
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w942
            local.get $w939
            struct.new $ListCons_30
            local.set $w939
          else
            local.get $w942
            local.get $w940
            struct.new $ListCons_30
            local.set $w940
          end
          local.get $w941
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w941
          br $while_943_lp
        else
          br $while_943_exit
        end
      end
    end
    local.get $w939
    local.set $w944
    ref.null $ListBase
    local.set $w945
    block $while_946_exit
      loop $while_946_lp
        local.get $w944
        ref.is_null
        i32.eqz
        if
          local.get $w944
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w945
          struct.new $ListCons_30
          local.set $w945
          local.get $w944
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w944
          br $while_946_lp
        else
          br $while_946_exit
        end
      end
    end
    local.get $w945
    local.get $w940
    local.set $w947
    ref.null $ListBase
    local.set $w948
    block $while_949_exit
      loop $while_949_lp
        local.get $w947
        ref.is_null
        i32.eqz
        if
          local.get $w947
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w948
          struct.new $ListCons_30
          local.set $w948
          local.get $w947
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w947
          br $while_949_lp
        else
          br $while_949_exit
        end
      end
    end
    local.get $w948
    struct.new $Tuple_376
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_376 0
    local.set $evens
    local.get $evens
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_385 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w951 (ref null $ListBase))
    (local $w955 i32)
    (local $w952 (ref null $ListBase))
    (local $w953 i32)
    (local $w956 (ref $GcArray_79))
    (local $w957 (ref null $ListBase))
    (local $w958 i32)
    (local $w960 i32)
    (local $w961 i32)
    (local $w962 i32)
    (local $w965 i32)
    (local $w966 (ref null $ListBase))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    i32.const 9
    i32.const 2
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w951
    local.get $w951
    local.set $w952
    i32.const 0
    local.set $w953
    block $while_954_exit
      loop $while_954_lp
        local.get $w952
        ref.is_null
        i32.eqz
        if
          local.get $w953
          i32.const 1
          i32.add
          local.set $w953
          local.get $w952
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w952
          br $while_954_lp
        else
          br $while_954_exit
        end
      end
    end
    local.get $w953
    local.set $w955
    i32.const 0
    local.get $w955
    array.new $GcArray_79
    local.set $w956
    local.get $w951
    local.set $w957
    i32.const 0
    local.set $w958
    block $while_959_exit
      loop $while_959_lp
        local.get $w957
        ref.is_null
        i32.eqz
        if
          local.get $w956
          local.get $w958
          local.get $w957
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_79
          local.get $w958
          i32.const 1
          i32.add
          local.set $w958
          local.get $w957
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w957
          br $while_959_lp
        else
          br $while_959_exit
        end
      end
    end
    local.get $w958
    drop
    i32.const 1
    local.set $w960
    block $while_964_exit
      loop $while_964_lp
        local.get $w960
        local.get $w955
        i32.lt_s
        if
          local.get $w956
          local.get $w960
          array.get $GcArray_79
          local.set $w961
          local.get $w960
          i32.const 1
          i32.sub
          local.set $w962
          block $while_963_exit
            loop $while_963_lp
              local.get $w962
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w956
                local.get $w962
                array.get $GcArray_79
                local.get $w961
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
                local.get $w956
                local.get $w962
                i32.const 1
                i32.add
                local.get $w956
                local.get $w962
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w962
                i32.const 1
                i32.sub
                local.set $w962
                br $while_963_lp
              else
                br $while_963_exit
              end
            end
          end
          local.get $w956
          local.get $w962
          i32.const 1
          i32.add
          local.get $w961
          array.set $GcArray_79
          local.get $w960
          i32.const 1
          i32.add
          local.set $w960
          br $while_964_lp
        else
          br $while_964_exit
        end
      end
    end
    local.get $w955
    i32.const 1
    i32.sub
    local.set $w965
    ref.null $ListBase
    local.set $w966
    block $while_967_exit
      loop $while_967_lp
        local.get $w965
        i32.const 0
        i32.ge_s
        if
          local.get $w956
          local.get $w965
          array.get $GcArray_79
          local.get $w966
          struct.new $ListCons_30
          local.set $w966
          local.get $w965
          i32.const 1
          i32.sub
          local.set $w965
          br $while_967_lp
        else
          br $while_967_exit
        end
      end
    end
    local.get $w966
    local.set $sorted
    local.get $sorted
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_387 (param $self (ref $AnyFn)) (param $x (ref $WasmStr)) (param $y (ref $WasmStr)) (result i32)
    local.get $x
    local.get $y
    call $strCompare
  )
  (func $testListSortStrAsc (result i32) ;; exported as "testListSortStrAsc"
    (local $sorted (ref null $ListBase))
    (local $w969 (ref null $ListBase))
    (local $w973 i32)
    (local $w970 (ref null $ListBase))
    (local $w971 i32)
    (local $w974 (ref $GcArray_390))
    (local $w975 (ref null $ListBase))
    (local $w976 i32)
    (local $w978 i32)
    (local $w979 (ref $WasmStr))
    (local $w980 i32)
    (local $w983 i32)
    (local $w984 (ref null $ListBase))
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
    struct.new $ListCons_386
    struct.new $ListCons_386
    struct.new $ListCons_386
    local.set $w969
    local.get $w969
    local.set $w970
    i32.const 0
    local.set $w971
    block $while_972_exit
      loop $while_972_lp
        local.get $w970
        ref.is_null
        i32.eqz
        if
          local.get $w971
          i32.const 1
          i32.add
          local.set $w971
          local.get $w970
          ref.cast (ref $ListCons_386)
          struct.get $ListCons_386 1
          local.set $w970
          br $while_972_lp
        else
          br $while_972_exit
        end
      end
    end
    local.get $w971
    local.set $w973
    ref.null $WasmStr
    local.get $w973
    array.new $GcArray_390
    local.set $w974
    local.get $w969
    local.set $w975
    i32.const 0
    local.set $w976
    block $while_977_exit
      loop $while_977_lp
        local.get $w975
        ref.is_null
        i32.eqz
        if
          local.get $w974
          local.get $w976
          local.get $w975
          ref.cast (ref $ListCons_386)
          struct.get $ListCons_386 0
          array.set $GcArray_390
          local.get $w976
          i32.const 1
          i32.add
          local.set $w976
          local.get $w975
          ref.cast (ref $ListCons_386)
          struct.get $ListCons_386 1
          local.set $w975
          br $while_977_lp
        else
          br $while_977_exit
        end
      end
    end
    local.get $w976
    drop
    i32.const 1
    local.set $w978
    block $while_982_exit
      loop $while_982_lp
        local.get $w978
        local.get $w973
        i32.lt_s
        if
          local.get $w974
          local.get $w978
          array.get $GcArray_390
          ref.cast (ref $WasmStr)
          local.set $w979
          local.get $w978
          i32.const 1
          i32.sub
          local.set $w980
          block $while_981_exit
            loop $while_981_lp
              local.get $w980
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w974
                local.get $w980
                array.get $GcArray_390
                ref.cast (ref $WasmStr)
                local.get $w979
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
                local.get $w974
                local.get $w980
                i32.const 1
                i32.add
                local.get $w974
                local.get $w980
                array.get $GcArray_390
                ref.cast (ref $WasmStr)
                array.set $GcArray_390
                local.get $w980
                i32.const 1
                i32.sub
                local.set $w980
                br $while_981_lp
              else
                br $while_981_exit
              end
            end
          end
          local.get $w974
          local.get $w980
          i32.const 1
          i32.add
          local.get $w979
          array.set $GcArray_390
          local.get $w978
          i32.const 1
          i32.add
          local.set $w978
          br $while_982_lp
        else
          br $while_982_exit
        end
      end
    end
    local.get $w973
    i32.const 1
    i32.sub
    local.set $w983
    ref.null $ListBase
    local.set $w984
    block $while_985_exit
      loop $while_985_lp
        local.get $w983
        i32.const 0
        i32.ge_s
        if
          local.get $w974
          local.get $w983
          array.get $GcArray_390
          ref.cast (ref $WasmStr)
          local.get $w984
          struct.new $ListCons_386
          local.set $w984
          local.get $w983
          i32.const 1
          i32.sub
          local.set $w983
          br $while_985_lp
        else
          br $while_985_exit
        end
      end
    end
    local.get $w984
    local.set $sorted
    local.get $sorted
    ref.cast (ref $ListCons_386)
    struct.get $ListCons_386 0
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
  (func $closure_391 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_391 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w987 (ref null $ListBase))
    (local $w988 i32)
    local.get $list
    local.set $w987
    i32.const 0
    local.set $w988
    block $while_989_exit
      loop $while_989_lp
        local.get $w987
        ref.is_null
        i32.eqz
        if
          local.get $w988
          local.get $w987
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w988
          local.get $w987
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w987
          br $while_989_lp
        else
          br $while_989_exit
        end
      end
    end
    local.get $w988
  )
  (func $testSeqToList (result i32) ;; exported as "testSeqToList"
    (local $xs (ref null $ListBase))
    (local $lo_clo_67 (ref $ClosureBase_33))
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    ref.func $closure_391
    struct.new $ClosureType_392
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_67
    local.get $lo_clo_67
    local.get $xs
    local.get $lo_clo_67
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_393 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_394 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListUnzip (result i32) ;; exported as "testListUnzip"
    (local $pairs (ref null $ListBase))
    (local $patternInput (ref $Tuple_376))
    (local $w991 (ref null $ListBase))
    (local $w996 (ref null $ListBase))
    (local $w992 (ref null $ListBase))
    (local $w993 (ref null $ListBase))
    (local $w994 (ref $Tuple_90))
    (local $w997 (ref null $ListBase))
    (local $w999 (ref null $ListBase))
    (local $w1000 (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $xs (ref null $ListBase))
    (local $w1003 (ref null $ListBase))
    (local $w1004 i32)
    (local $w1007 (ref null $ListBase))
    (local $w1008 i32)
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    local.set $pairs
    ref.null $ListBase
    local.set $w991
    local.get $pairs
    local.set $w992
    ref.null $ListBase
    local.set $w993
    block $while_995_exit
      loop $while_995_lp
        local.get $w992
        ref.is_null
        i32.eqz
        if
          local.get $w992
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 0
          local.set $w994
          local.get $w994
          struct.get $Tuple_90 1
          local.get $w991
          struct.new $ListCons_30
          local.set $w991
          local.get $w994
          struct.get $Tuple_90 0
          local.get $w993
          struct.new $ListCons_30
          local.set $w993
          local.get $w992
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 1
          local.set $w992
          br $while_995_lp
        else
          br $while_995_exit
        end
      end
    end
    local.get $w993
    local.set $w996
    ref.null $ListBase
    local.set $w997
    block $while_998_exit
      loop $while_998_lp
        local.get $w996
        ref.is_null
        i32.eqz
        if
          local.get $w996
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w997
          struct.new $ListCons_30
          local.set $w997
          local.get $w996
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w996
          br $while_998_lp
        else
          br $while_998_exit
        end
      end
    end
    local.get $w997
    local.get $w991
    local.set $w999
    ref.null $ListBase
    local.set $w1000
    block $while_1001_exit
      loop $while_1001_lp
        local.get $w999
        ref.is_null
        i32.eqz
        if
          local.get $w999
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1000
          struct.new $ListCons_30
          local.set $w1000
          local.get $w999
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w999
          br $while_1001_lp
        else
          br $while_1001_exit
        end
      end
    end
    local.get $w1000
    struct.new $Tuple_376
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_376 1
    local.set $ys
    local.get $patternInput
    struct.get $Tuple_376 0
    local.set $xs
    local.get $xs
    local.set $w1003
    i32.const 0
    local.set $w1004
    block $while_1005_exit
      loop $while_1005_lp
        local.get $w1003
        ref.is_null
        i32.eqz
        if
          local.get $w1004
          local.get $w1003
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1004
          local.get $w1003
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1003
          br $while_1005_lp
        else
          br $while_1005_exit
        end
      end
    end
    local.get $w1004
    local.get $ys
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
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1008
          local.get $w1007
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1007
          br $while_1009_lp
        else
          br $while_1009_exit
        end
      end
    end
    local.get $w1008
    i32.add
  )
  (func $closure_397 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_398 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_398 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testListGroupBy (result i32) ;; exported as "testListGroupBy"
    (local $groups (ref null $ListBase))
    (local $lo_clo_68 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_397))
    (local $w1011 (ref null $ListBase))
    (local $w1012 i32)
    ref.func $closure_397
    struct.new $ClosureType_397
    local.set $projection
    ref.func $closure_398
    local.get $projection
    struct.new $ClosureType_399
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_68
    local.get $lo_clo_68
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_68
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.set $groups
    local.get $groups
    local.set $w1011
    i32.const 0
    local.set $w1012
    block $while_1013_exit
      loop $while_1013_lp
        local.get $w1011
        ref.is_null
        i32.eqz
        if
          local.get $w1012
          i32.const 1
          i32.add
          local.set $w1012
          local.get $w1011
          ref.cast (ref $ListCons_396)
          struct.get $ListCons_396 1
          local.set $w1011
          br $while_1013_lp
        else
          br $while_1013_exit
        end
      end
    end
    local.get $w1012
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
  (func $closure_404 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w1015 (ref null $ListBase))
    (local $w1016 i32)
    local.get $list_1
    local.set $w1015
    i32.const 0
    local.set $w1016
    block $while_1017_exit
      loop $while_1017_lp
        local.get $w1015
        ref.is_null
        i32.eqz
        if
          local.get $w1016
          i32.const 1
          i32.add
          local.set $w1016
          local.get $w1015
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1015
          br $while_1017_lp
        else
          br $while_1017_exit
        end
      end
    end
    local.get $w1016
  )
  (func $closure_405 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_406 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_406 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testListDistinctBy (result i32) ;; exported as "testListDistinctBy"
    (local $lo_clo_70 (ref $ClosureBase_33))
    (local $lo_clo_69 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_405))
    ref.func $closure_404
    struct.new $ClosureType_404
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_70
    local.get $lo_clo_70
    ref.func $closure_405
    struct.new $ClosureType_405
    local.set $projection
    ref.func $closure_406
    local.get $projection
    struct.new $ClosureType_407
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_69
    local.get $lo_clo_69
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_69
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_70
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_408 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_409 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1019 (ref null $ListBase))
    (local $w1020 i32)
    local.get $list
    local.set $w1019
    i32.const 0
    local.set $w1020
    block $while_1021_exit
      loop $while_1021_lp
        local.get $w1019
        ref.is_null
        i32.eqz
        if
          local.get $w1020
          i32.const 1
          i32.add
          local.set $w1020
          local.get $w1019
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 1
          local.set $w1019
          br $while_1021_lp
        else
          br $while_1021_exit
        end
      end
    end
    local.get $w1020
  )
  (func $testMapToList (result i32) ;; exported as "testMapToList"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_71 (ref $ClosureBase_33))
    ref.func $closure_408
    struct.new $ClosureType_408
    i32.const 1
    i32.const 10
    struct.new $Tuple_90
    i32.const 2
    i32.const 20
    struct.new $Tuple_90
    i32.const 3
    i32.const 30
    struct.new $Tuple_90
    ref.null $ListBase
    struct.new $ListCons_91
    struct.new $ListCons_91
    struct.new $ListCons_91
    call $Map_ofList
    local.set $m
    ref.func $closure_409
    struct.new $ClosureType_409
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_71
    local.get $lo_clo_71
    local.get $m
    call $Map_toList
    local.get $lo_clo_71
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
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
  (func $testSetOfListCount (result i32) ;; exported as "testSetOfListCount"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_410
    struct.new $ClosureType_410
    i32.const 3
    i32.const 1
    i32.const 2
    i32.const 1
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    local.get $s
    return_call $Set_count
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
  (func $closure_412 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1023 (ref null $ListBase))
    (local $w1024 i32)
    local.get $list
    local.set $w1023
    i32.const 0
    local.set $w1024
    block $while_1025_exit
      loop $while_1025_lp
        local.get $w1023
        ref.is_null
        i32.eqz
        if
          local.get $w1024
          i32.const 1
          i32.add
          local.set $w1024
          local.get $w1023
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1023
          br $while_1025_lp
        else
          br $while_1025_exit
        end
      end
    end
    local.get $w1024
  )
  (func $testSetToList (result i32) ;; exported as "testSetToList"
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_72 (ref $ClosureBase_33))
    ref.func $closure_411
    struct.new $ClosureType_411
    i32.const 3
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_412
    struct.new $ClosureType_412
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_72
    local.get $lo_clo_72
    local.get $s
    call $Set_toList
    local.get $lo_clo_72
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_413 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_413))
    (local $target i32)
    local.get $self
    ref.cast (ref $ClosureType_413)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_413 1
    local.set $target
    local.get $x
    local.get $target
    i32.eq
  )
  (func $testClosureCapListExists (result i32) ;; exported as "testClosureCapListExists"
    (local $w1027 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 4
    i32.const 7
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1027
    block $exi_1026_blk (result i32)
      block $exi_1026_lp_exit
        loop $exi_1026_lp
          local.get $w1027
          ref.is_null
          i32.eqz
          if
            local.get $w1027
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 7
            i32.eq
            if
              i32.const 1
              br $exi_1026_blk
            end
            local.get $w1027
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1027
          else
            br $exi_1026_lp_exit
          end
          br $exi_1026_lp
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
  (func $closure_414 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_414))
    (local $bound i32)
    local.get $self
    ref.cast (ref $ClosureType_414)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_414 1
    local.set $bound
    local.get $x
    local.get $bound
    i32.lt_s
  )
  (func $testClosureCapListForAll (result i32) ;; exported as "testClosureCapListForAll"
    (local $w1029 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 3
    i32.const 5
    i32.const 7
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1029
    block $all_1028_blk (result i32)
      block $all_1028_lp_exit
        loop $all_1028_lp
          local.get $w1029
          ref.is_null
          i32.eqz
          if
            local.get $w1029
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.lt_s
            if
              local.get $w1029
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w1029
            else
              i32.const 0
              br $all_1028_blk
            end
          else
            br $all_1028_lp_exit
          end
          br $all_1028_lp
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
  (func $closure_415 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_415))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_415)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_415 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_415 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_416 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_416))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_416)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_416 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_416 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_417 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_417))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_417)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_417 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_417 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_418 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_418))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_418)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_418 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_418 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_418
    local.get $a
    struct.new $ClosureType_418
  )
  (func $closure_420 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1031 (ref null $ListBase))
    (local $w1032 i32)
    local.get $list
    local.set $w1031
    i32.const 0
    local.set $w1032
    block $while_1033_exit
      loop $while_1033_lp
        local.get $w1031
        ref.is_null
        i32.eqz
        if
          local.get $w1032
          i32.const 1
          i32.add
          local.set $w1032
          local.get $w1031
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 1
          local.set $w1031
          br $while_1033_lp
        else
          br $while_1033_exit
        end
      end
    end
    local.get $w1032
  )
  (func $testMapModuleToList (result i32) ;; exported as "testMapModuleToList"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_75 (ref $ClosureBase_213))
    (local $lo_clo_74 (ref $ClosureBase_213))
    (local $lo_clo_73 (ref $ClosureBase_213))
    (local $lo_clo_76 (ref $ClosureBase_33))
    ref.func $closure_415
    i32.const 2
    i32.const 20
    struct.new $ClosureType_415
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_75
    local.get $lo_clo_75
    ref.func $closure_416
    i32.const 1
    i32.const 10
    struct.new $ClosureType_416
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_74
    local.get $lo_clo_74
    ref.func $closure_417
    i32.const 3
    i32.const 30
    struct.new $ClosureType_417
    ref.cast (ref $ClosureBase_213)
    local.set $lo_clo_73
    local.get $lo_clo_73
    ref.func $closure_418
    struct.new $ClosureType_419
    call $Map_empty
    local.get $lo_clo_73
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_74
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.get $lo_clo_75
    struct.get $ClosureBase_213 0
    call_ref $FuncType_212
    local.set $m_3
    ref.func $closure_420
    struct.new $ClosureType_420
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_76
    local.get $lo_clo_76
    local.get $m_3
    call $Map_toList
    local.get $lo_clo_76
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $runListTests (param $check (ref $AnyFn)) ;; exported as "runListTests"
  )
  (func $testOptionSome (param $v i32) (param $def i32) (result i32) ;; exported as "testOptionSome"
    local.get $v
    struct.new $Option_89
    local.get $def
    return_call $optionOrDefault
  )
  (func $testOptionNone (param $def i32) (result i32) ;; exported as "testOptionNone"
    ref.null $Option_89
    local.get $def
    return_call $optionOrDefault
  )
  (func $testOptionDoubleSome (param $v i32) (result i32) ;; exported as "testOptionDoubleSome"
    local.get $v
    struct.new $Option_89
    return_call $optionDouble
  )
  (func $testOptionDoubleNone (result i32) ;; exported as "testOptionDoubleNone"
    ref.null $Option_89
    return_call $optionDouble
  )
  (func $testOptionIsSome (param $v i32) (result i32) ;; exported as "testOptionIsSome"
    local.get $v
    struct.new $Option_89
    call $optionIsSome
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionIsNone (result i32) ;; exported as "testOptionIsNone"
    ref.null $Option_89
    call $optionIsNone
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionNested (param $v i32) (result i32) ;; exported as "testOptionNested"
    local.get $v
    return_call $optionNested
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
    (local $lo_clo_77 (ref $ClosureBase_26))
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_77
    local.get $lo_clo_77
    local.get $x
    local.get $lo_clo_77
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $doubleVal (param $x i32) (result i32) ;; exported as "doubleVal"
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_421 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 3
    i32.mul
  )
  (func $testOptionMap (result i32) ;; exported as "testOptionMap"
    (local $x (ref null $Option_89))
    (local $y (ref null $Option_89))
    (local $v i32)
    i32.const 5
    struct.new $Option_89
    local.set $x
    local.get $x
    ref.is_null
    if (result (ref null $Option_89))
      local.get $x
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
      local.set $v
      local.get $v
      i32.const 3
      i32.mul
      struct.new $Option_89
    else
      ref.null $Option_89
    end
    local.set $y
    local.get $y
    ref.is_null
    if (result i32)
      local.get $y
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      i32.const 0
    end
  )
  (func $closure_422 (param $self (ref $AnyFn)) (param $v i32) (result (ref null $Option_89))
    local.get $v
    i32.const 0
    i32.gt_s
    if (result (ref null $Option_89))
      local.get $v
      i32.const 1
      i32.shl
      struct.new $Option_89
    else
      ref.null $Option_89
    end
  )
  (func $testOptionBind (result i32) ;; exported as "testOptionBind"
    (local $x (ref null $Option_89))
    (local $y (ref null $Option_89))
    (local $v i32)
    i32.const 4
    struct.new $Option_89
    local.set $x
    local.get $x
    ref.is_null
    if (result (ref null $Option_89))
      local.get $x
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
      local.set $v
      local.get $v
      i32.const 0
      i32.gt_s
      if (result (ref null $Option_89))
        local.get $v
        i32.const 1
        i32.shl
        struct.new $Option_89
      else
        ref.null $Option_89
      end
    else
      ref.null $Option_89
    end
    local.set $y
    local.get $y
    ref.is_null
    if (result i32)
      local.get $y
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      i32.const -1
    end
  )
  (func $testOptionValue (result i32) ;; exported as "testOptionValue"
    (local $w1043 (ref null $Option_89))
    i32.const 42
    struct.new $Option_89
    local.set $w1043
    local.get $w1043
    ref.cast (ref $Option_89)
    struct.get $Option_89 0
  )
  (func $closure_423 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_424 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testOptionMapValue (result i32) ;; exported as "testOptionMapValue"
    (local $w1046 (ref null $Option_89))
    (local $w1045 (ref null $Option_89))
    (local $x i32)
    i32.const 42
    struct.new $Option_89
    local.set $w1045
    local.get $w1045
    ref.is_null
    if (result (ref null $Option_89))
      local.get $w1045
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
      local.set $x
      local.get $x
      i32.const 1
      i32.shl
      struct.new $Option_89
    else
      ref.null $Option_89
    end
    local.set $w1046
    local.get $w1046
    ref.cast (ref $Option_89)
    struct.get $Option_89 0
  )
  (func $testOptionDefaultValue (result i32) ;; exported as "testOptionDefaultValue"
    (local $w1047 (ref null $Option_89))
    i32.const 42
    struct.new $Option_89
    local.set $w1047
    local.get $w1047
    ref.is_null
    if (result i32)
      local.get $w1047
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      i32.const 99
    end
  )
  (func $testOptionDefaultValueNone (result i32) ;; exported as "testOptionDefaultValueNone"
    ref.null $Option_89
    ref.cast (ref $Option_89)
    struct.get $Option_89 0
  )
  (func $closure_425 (param $self (ref $AnyFn)) (result i32)
    i32.const 42
  )
  (func $testOptionDefaultWith (result i32) ;; exported as "testOptionDefaultWith"
    ref.null $Option_89
    ref.cast (ref $Option_89)
    struct.get $Option_89 0
  )
  (func $closure_426 (param $self (ref $AnyFn)) (result i32)
    i32.const 99
  )
  (func $testOptionDefaultWithSome (result i32) ;; exported as "testOptionDefaultWithSome"
    (local $w1050 (ref null $Option_89))
    i32.const 5
    struct.new $Option_89
    local.set $w1050
    local.get $w1050
    ref.is_null
    if (result i32)
      local.get $w1050
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    else
      i32.const 99
    end
  )
  (func $closure_427 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testOptionFilter (result i32) ;; exported as "testOptionFilter"
    (local $matchValue (ref null $Option_89))
    (local $w1051 (ref null $Option_89))
    (local $x i32)
    i32.const 5
    struct.new $Option_89
    local.set $w1051
    local.get $w1051
    ref.is_null
    if (result (ref null $Option_89))
      local.get $w1051
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
      local.set $x
      local.get $x
      i32.const 3
      i32.gt_s
      if (result (ref null $Option_89))
        local.get $w1051
      else
        ref.null $Option_89
      end
    else
      ref.null $Option_89
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $closure_428 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testOptionFilterNone (result i32) ;; exported as "testOptionFilterNone"
    (local $matchValue (ref null $Option_89))
    (local $w1052 (ref null $Option_89))
    (local $x i32)
    i32.const 5
    struct.new $Option_89
    local.set $w1052
    local.get $w1052
    ref.is_null
    if (result (ref null $Option_89))
      local.get $w1052
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
      local.set $x
      local.get $x
      i32.const 10
      i32.gt_s
      if (result (ref null $Option_89))
        local.get $w1052
      else
        ref.null $Option_89
      end
    else
      ref.null $Option_89
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
    ref.null $Option_89
    ref.cast (ref $Option_89)
    struct.get $Option_89 0
  )
  (func $testOptionModuleDefaultValueSome (result i32) ;; exported as "testOptionModuleDefaultValueSome"
    (local $w1054 (ref null $Option_89))
    i32.const 99
    struct.new $Option_89
    local.set $w1054
    local.get $w1054
    ref.is_null
    if (result i32)
      local.get $w1054
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
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
  (func $equals_429 (param $eq_a (ref $QuickTestWasmGc_TestsPrimitives_Point)) (param $eq_b (ref $QuickTestWasmGc_TestsPrimitives_Point)) (result i32)
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
    call $equals_429
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
    call $equals_429
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
    call $equals_429
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
  (func $swapPair (param $a i32) (param $b i32) (result (ref $Tuple_90)) ;; exported as "swapPair"
    local.get $b
    local.get $a
    struct.new $Tuple_90
  )
  (func $testSwapPairFst (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairFst"
    (local $patternInput (ref $Tuple_90))
    local.get $a
    local.get $b
    call $swapPair
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_90 0
  )
  (func $testSwapPairSnd (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairSnd"
    (local $patternInput (ref $Tuple_90))
    local.get $a
    local.get $b
    call $swapPair
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_90 1
  )
  (func $minMax (param $a f64) (param $b f64) (result (ref $Tuple_432)) ;; exported as "minMax"
    local.get $a
    local.get $b
    f64.le
    if (result (ref $Tuple_432))
      local.get $a
      local.get $b
      struct.new $Tuple_432
    else
      local.get $b
      local.get $a
      struct.new $Tuple_432
    end
  )
  (func $testMinMaxFirst (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxFirst"
    (local $patternInput (ref $Tuple_432))
    local.get $a
    local.get $b
    call $minMax
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_432 0
  )
  (func $testMinMaxSecond (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxSecond"
    (local $patternInput (ref $Tuple_432))
    local.get $a
    local.get $b
    call $minMax
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_432 1
  )
  (func $tripleSum (param $t_ i32) (param $t__1 i32) (param $t__2 i32) (result i32) ;; exported as "tripleSum"
    (local $t (ref $Tuple_433))
    (local $c i32)
    (local $b i32)
    (local $a i32)
    local.get $t_
    local.get $t__1
    local.get $t__2
    struct.new $Tuple_433
    local.set $t
    local.get $t
    struct.get $Tuple_433 2
    local.set $c
    local.get $t
    struct.get $Tuple_433 1
    local.set $b
    local.get $t
    struct.get $Tuple_433 0
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
  (func $closure_436 (param $self (ref $AnyFn)) (param $x (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (result i32)
    local.get $x
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
  )
  (func $closure_439 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w1060 i32)
    (local $w1057 (ref null $ListBase))
    (local $w1058 i32)
    (local $w1061 (ref $GcArray_440))
    (local $w1062 (ref $GcArray_79))
    (local $w1063 (ref null $ListBase))
    (local $w1064 i32)
    (local $w1065 (ref $QuickTestWasmGc_TestsPrimitives_SWItem))
    (local $w1066 i32)
    (local $w1068 i32)
    (local $w1069 (ref $QuickTestWasmGc_TestsPrimitives_SWItem))
    (local $w1070 i32)
    (local $w1071 i32)
    (local $w1074 i32)
    (local $w1075 (ref null $ListBase))
    (local $w1078 i32)
    (local $w1079 (ref null $ListBase))
    (local $w1082 i32)
    (local $w1083 (ref null $ListBase))
    (local $w1086 i32)
    (local $w1087 (ref null $ListBase))
    i32.const 3
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    i32.const 1
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    i32.const 2
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    ref.null $ListBase
    struct.new $ListCons_435
    struct.new $ListCons_435
    struct.new $ListCons_435
    local.set $items
    local.get $items
    local.set $w1057
    i32.const 0
    local.set $w1058
    block $while_1059_exit
      loop $while_1059_lp
        local.get $w1057
        ref.is_null
        i32.eqz
        if
          local.get $w1058
          i32.const 1
          i32.add
          local.set $w1058
          local.get $w1057
          ref.cast (ref $ListCons_435)
          struct.get $ListCons_435 1
          local.set $w1057
          br $while_1059_lp
        else
          br $while_1059_exit
        end
      end
    end
    local.get $w1058
    local.set $w1060
    ref.null $QuickTestWasmGc_TestsPrimitives_SWItem
    local.get $w1060
    array.new $GcArray_440
    local.set $w1061
    i32.const 0
    local.get $w1060
    array.new $GcArray_79
    local.set $w1062
    local.get $items
    local.set $w1063
    i32.const 0
    local.set $w1064
    block $while_1067_exit
      loop $while_1067_lp
        local.get $w1063
        ref.is_null
        i32.eqz
        if
          local.get $w1063
          ref.cast (ref $ListCons_435)
          struct.get $ListCons_435 0
          local.set $w1065
          local.get $w1065
          struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
          local.set $w1066
          local.get $w1061
          local.get $w1064
          local.get $w1065
          array.set $GcArray_440
          local.get $w1062
          local.get $w1064
          local.get $w1066
          array.set $GcArray_79
          local.get $w1064
          i32.const 1
          i32.add
          local.set $w1064
          local.get $w1063
          ref.cast (ref $ListCons_435)
          struct.get $ListCons_435 1
          local.set $w1063
          br $while_1067_lp
        else
          br $while_1067_exit
        end
      end
    end
    local.get $w1064
    drop
    i32.const 1
    local.set $w1068
    block $while_1073_exit
      loop $while_1073_lp
        local.get $w1068
        local.get $w1060
        i32.lt_s
        if
          local.get $w1061
          local.get $w1068
          array.get $GcArray_440
          local.set $w1069
          local.get $w1062
          local.get $w1068
          array.get $GcArray_79
          local.set $w1070
          local.get $w1068
          i32.const 1
          i32.sub
          local.set $w1071
          block $while_1072_exit
            loop $while_1072_lp
              local.get $w1071
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1062
                local.get $w1071
                array.get $GcArray_79
                local.get $w1070
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w1061
                local.get $w1071
                i32.const 1
                i32.add
                local.get $w1061
                local.get $w1071
                array.get $GcArray_440
                array.set $GcArray_440
                local.get $w1062
                local.get $w1071
                i32.const 1
                i32.add
                local.get $w1062
                local.get $w1071
                array.get $GcArray_79
                array.set $GcArray_79
                local.get $w1071
                i32.const 1
                i32.sub
                local.set $w1071
                br $while_1072_lp
              else
                br $while_1072_exit
              end
            end
          end
          local.get $w1061
          local.get $w1071
          i32.const 1
          i32.add
          local.get $w1069
          array.set $GcArray_440
          local.get $w1062
          local.get $w1071
          i32.const 1
          i32.add
          local.get $w1070
          array.set $GcArray_79
          local.get $w1068
          i32.const 1
          i32.add
          local.set $w1068
          br $while_1073_lp
        else
          br $while_1073_exit
        end
      end
    end
    local.get $w1060
    i32.const 1
    i32.sub
    local.set $w1074
    ref.null $ListBase
    local.set $w1075
    block $while_1076_exit
      loop $while_1076_lp
        local.get $w1074
        i32.const 0
        i32.ge_s
        if
          local.get $w1061
          local.get $w1074
          array.get $GcArray_440
          local.get $w1075
          struct.new $ListCons_435
          local.set $w1075
          local.get $w1074
          i32.const 1
          i32.sub
          local.set $w1074
          br $while_1076_lp
        else
          br $while_1076_exit
        end
      end
    end
    local.get $w1075
    local.set $sorted
    i32.const 0
    local.set $w1078
    local.get $sorted
    local.set $w1079
    block $while_1080_exit
      loop $while_1080_lp
        local.get $w1078
        i32.const 0
        i32.gt_s
        if
          local.get $w1079
          ref.cast (ref $ListCons_435)
          struct.get $ListCons_435 1
          local.set $w1079
          local.get $w1078
          i32.const 1
          i32.sub
          local.set $w1078
          br $while_1080_lp
        else
          br $while_1080_exit
        end
      end
    end
    local.get $w1079
    ref.cast (ref $ListCons_435)
    struct.get $ListCons_435 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.const 1
    local.set $w1082
    local.get $sorted
    local.set $w1083
    block $while_1084_exit
      loop $while_1084_lp
        local.get $w1082
        i32.const 0
        i32.gt_s
        if
          local.get $w1083
          ref.cast (ref $ListCons_435)
          struct.get $ListCons_435 1
          local.set $w1083
          local.get $w1082
          i32.const 1
          i32.sub
          local.set $w1082
          br $while_1084_lp
        else
          br $while_1084_exit
        end
      end
    end
    local.get $w1083
    ref.cast (ref $ListCons_435)
    struct.get $ListCons_435 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.add
    i32.const 2
    local.set $w1086
    local.get $sorted
    local.set $w1087
    block $while_1088_exit
      loop $while_1088_lp
        local.get $w1086
        i32.const 0
        i32.gt_s
        if
          local.get $w1087
          ref.cast (ref $ListCons_435)
          struct.get $ListCons_435 1
          local.set $w1087
          local.get $w1086
          i32.const 1
          i32.sub
          local.set $w1086
          br $while_1088_lp
        else
          br $while_1088_exit
        end
      end
    end
    local.get $w1087
    ref.cast (ref $ListCons_435)
    struct.get $ListCons_435 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.add
  )
  (func $runPrimitivesTests (param $check (ref $AnyFn)) ;; exported as "runPrimitivesTests"
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
  (func $closure_441 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_443))
    (local $clo (ref $AnyFn))
    (local $lo_clo_78 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_443)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_443 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_78
    local.get $lo_clo_78
    local.get $arg
    local.get $lo_clo_78
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfInt (result i32) ;; exported as "testSprintfInt"
    (local $lo_clo_79 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_441
    local.get $clo
    struct.new $ClosureType_443
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_79
    local.get $lo_clo_79
    i32.const 42
    local.get $lo_clo_79
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    array.len
  )
  (func $closure_444 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_444))
    (local $clo (ref $AnyFn))
    (local $lo_clo_80 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_444)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_444 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_80
    local.get $lo_clo_80
    local.get $arg
    local.get $lo_clo_80
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfNegInt (result i32) ;; exported as "testSprintfNegInt"
    (local $lo_clo_81 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_444
    local.get $clo
    struct.new $ClosureType_444
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_81
    local.get $lo_clo_81
    i32.const -7
    local.get $lo_clo_81
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    array.len
  )
  (func $closure_445 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_447))
    (local $clo (ref $AnyFn))
    (local $lo_clo_82 (ref $ClosureBase_446))
    local.get $self
    ref.cast (ref $ClosureType_447)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_447 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_446)
    local.set $lo_clo_82
    local.get $lo_clo_82
    local.get $arg
    local.get $lo_clo_82
    struct.get $ClosureBase_446 0
    call_ref $FuncType_445
  )
  (func $testSprintfStr (result i32) ;; exported as "testSprintfStr"
    (local $lo_clo_83 (ref $ClosureBase_446))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_445
    local.get $clo
    struct.new $ClosureType_447
    ref.cast (ref $ClosureBase_446)
    local.set $lo_clo_83
    local.get $lo_clo_83
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    local.get $lo_clo_83
    struct.get $ClosureBase_446 0
    call_ref $FuncType_445
    array.len
  )
  (func $closure_448 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_448))
    (local $clo (ref $AnyFn))
    (local $lo_clo_84 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_448)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_448 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_84
    local.get $lo_clo_84
    local.get $arg
    local.get $lo_clo_84
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfIntLiteral (result i32) ;; exported as "testSprintfIntLiteral"
    (local $lo_clo_85 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 120
    i32.const 61
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 4
    local.set $clo
    ref.func $closure_448
    local.get $clo
    struct.new $ClosureType_448
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_85
    local.get $lo_clo_85
    i32.const 100
    local.get $lo_clo_85
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    array.len
  )
  (func $closure_449 (param $self (ref $AnyFn)) (param $arg_1 i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_449))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_86 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_449)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_449 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_86
    local.get $lo_clo_86
    local.get $arg_1
    local.get $lo_clo_86
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $closure_449 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_450))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_87 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_450)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_450 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_87
    local.get $lo_clo_87
    local.get $arg
    local.get $lo_clo_87
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_1
    ref.func $closure_449
    local.get $clo_1
    struct.new $ClosureType_449
  )
  (func $testSprintfTwoInts (result i32) ;; exported as "testSprintfTwoInts"
    (local $lo_clo_88 (ref $ClosureType_450))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    i32.const 32
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 5
    local.set $clo
    ref.func $closure_449
    local.get $clo
    struct.new $ClosureType_450
    local.set $lo_clo_88
    local.get $lo_clo_88
    i32.const 3
    i32.const 7
    local.get $lo_clo_88
    struct.get $AnyFn 0
    call_ref $FuncType_451
    array.len
  )
  (func $closure_454 (param $self (ref $AnyFn)) (param $arg_1 (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_454))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_89 (ref $ClosureBase_446))
    local.get $self
    ref.cast (ref $ClosureType_454)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_454 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_446)
    local.set $lo_clo_89
    local.get $lo_clo_89
    local.get $arg_1
    local.get $lo_clo_89
    struct.get $ClosureBase_446 0
    call_ref $FuncType_445
  )
  (func $closure_453 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_456))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_90 (ref $ClosureBase_455))
    local.get $self
    ref.cast (ref $ClosureType_456)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_456 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_455)
    local.set $lo_clo_90
    local.get $lo_clo_90
    local.get $arg
    local.get $lo_clo_90
    struct.get $ClosureBase_455 0
    call_ref $FuncType_453
    local.set $clo_1
    ref.func $closure_454
    local.get $clo_1
    struct.new $ClosureType_454
  )
  (func $testSprintfTwoStrs (result i32) ;; exported as "testSprintfTwoStrs"
    (local $lo_clo_91 (ref $ClosureType_456))
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
    ref.func $closure_453
    local.get $clo
    struct.new $ClosureType_456
    local.set $lo_clo_91
    local.get $lo_clo_91
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    local.get $lo_clo_91
    struct.get $AnyFn 0
    call_ref $FuncType_457
    array.len
  )
  (func $closure_458 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_458))
    (local $clo (ref $AnyFn))
    (local $lo_clo_92 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_458)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_458 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_92
    local.get $lo_clo_92
    local.get $arg
    local.get $lo_clo_92
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfBoolTrue (result i32) ;; exported as "testSprintfBoolTrue"
    (local $lo_clo_93 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 98
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_458
    local.get $clo
    struct.new $ClosureType_458
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_93
    local.get $lo_clo_93
    i32.const 1
    local.get $lo_clo_93
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    array.len
  )
  (func $closure_459 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_459))
    (local $clo (ref $AnyFn))
    (local $lo_clo_94 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_459)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_459 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_94
    local.get $lo_clo_94
    local.get $arg
    local.get $lo_clo_94
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfBoolFalse (result i32) ;; exported as "testSprintfBoolFalse"
    (local $lo_clo_95 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 98
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_459
    local.get $clo
    struct.new $ClosureType_459
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_95
    local.get $lo_clo_95
    i32.const 0
    local.get $lo_clo_95
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    array.len
  )
  (func $closure_461 (param $self (ref $AnyFn)) (param $arg_1 (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_461))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_96 (ref $ClosureBase_446))
    local.get $self
    ref.cast (ref $ClosureType_461)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_461 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_446)
    local.set $lo_clo_96
    local.get $lo_clo_96
    local.get $arg_1
    local.get $lo_clo_96
    struct.get $ClosureBase_446 0
    call_ref $FuncType_445
  )
  (func $closure_461 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_462))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_97 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_462)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_462 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_97
    local.get $lo_clo_97
    local.get $arg
    local.get $lo_clo_97
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_1
    ref.func $closure_461
    local.get $clo_1
    struct.new $ClosureType_461
  )
  (func $testSprintfMixed (result i32) ;; exported as "testSprintfMixed"
    (local $lo_clo_98 (ref $ClosureType_462))
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
    ref.func $closure_461
    local.get $clo
    struct.new $ClosureType_462
    local.set $lo_clo_98
    local.get $lo_clo_98
    i32.const 7
    i32.const 104
    i32.const 105
    array.new_fixed $WasmStr 2
    local.get $lo_clo_98
    struct.get $AnyFn 0
    call_ref $FuncType_463
    array.len
  )
  (func $closure_464 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_464))
    (local $clo (ref $AnyFn))
    (local $lo_clo_99 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_464)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_464 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_99
    local.get $lo_clo_99
    local.get $arg
    local.get $lo_clo_99
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfZero (result i32) ;; exported as "testSprintfZero"
    (local $lo_clo_100 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_464
    local.get $clo
    struct.new $ClosureType_464
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_100
    local.get $lo_clo_100
    i32.const 0
    local.get $lo_clo_100
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_465 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_465))
    (local $clo (ref $AnyFn))
    (local $lo_clo_101 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_465)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_465 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_101
    local.get $lo_clo_101
    local.get $arg
    local.get $lo_clo_101
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfPrefix (result i32) ;; exported as "testSprintfPrefix"
    (local $lo_clo_102 (ref $ClosureBase_442))
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
    ref.func $closure_465
    local.get $clo
    struct.new $ClosureType_465
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_102
    local.get $lo_clo_102
    i32.const 99
    local.get $lo_clo_102
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_466 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_468))
    (local $clo (ref $AnyFn))
    (local $lo_clo_103 (ref $ClosureBase_467))
    local.get $self
    ref.cast (ref $ClosureType_468)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_468 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_103
    local.get $lo_clo_103
    local.get $arg
    local.get $lo_clo_103
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
  )
  (func $testSprintfFloat (result i32) ;; exported as "testSprintfFloat"
    (local $lo_clo_104 (ref $ClosureBase_467))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_466
    local.get $clo
    struct.new $ClosureType_468
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_104
    local.get $lo_clo_104
    f64.const 3.1400000000000001
    local.get $lo_clo_104
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
    array.len
  )
  (func $closure_469 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_469))
    (local $clo (ref $AnyFn))
    (local $lo_clo_105 (ref $ClosureBase_467))
    local.get $self
    ref.cast (ref $ClosureType_469)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_469 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_105
    local.get $lo_clo_105
    local.get $arg
    local.get $lo_clo_105
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
  )
  (func $testSprintfFloatHalf (result i32) ;; exported as "testSprintfFloatHalf"
    (local $lo_clo_106 (ref $ClosureBase_467))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_469
    local.get $clo
    struct.new $ClosureType_469
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_106
    local.get $lo_clo_106
    f64.const 0.5
    local.get $lo_clo_106
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
    array.len
  )
  (func $closure_470 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_470))
    (local $clo (ref $AnyFn))
    (local $lo_clo_107 (ref $ClosureBase_467))
    local.get $self
    ref.cast (ref $ClosureType_470)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_470 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_107
    local.get $lo_clo_107
    local.get $arg
    local.get $lo_clo_107
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
  )
  (func $testSprintfFloatWhole (result i32) ;; exported as "testSprintfFloatWhole"
    (local $lo_clo_108 (ref $ClosureBase_467))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_470
    local.get $clo
    struct.new $ClosureType_470
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_108
    local.get $lo_clo_108
    f64.const 2
    local.get $lo_clo_108
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
    array.len
  )
  (func $closure_471 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_471))
    (local $clo (ref $AnyFn))
    (local $lo_clo_109 (ref $ClosureBase_467))
    local.get $self
    ref.cast (ref $ClosureType_471)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_471 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_109
    local.get $lo_clo_109
    local.get $arg
    local.get $lo_clo_109
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
  )
  (func $testSprintfFloatNeg (result i32) ;; exported as "testSprintfFloatNeg"
    (local $lo_clo_110 (ref $ClosureBase_467))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_471
    local.get $clo
    struct.new $ClosureType_471
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_110
    local.get $lo_clo_110
    f64.const -1.5
    local.get $lo_clo_110
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
    array.len
  )
  (func $closure_472 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_472))
    (local $clo (ref $AnyFn))
    (local $lo_clo_111 (ref $ClosureBase_467))
    local.get $self
    ref.cast (ref $ClosureType_472)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_472 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_111
    local.get $lo_clo_111
    local.get $arg
    local.get $lo_clo_111
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
  )
  (func $testSprintfFloatInStr (result i32) ;; exported as "testSprintfFloatInStr"
    (local $lo_clo_112 (ref $ClosureBase_467))
    (local $clo (ref $WasmStr))
    i32.const 112
    i32.const 105
    i32.const 61
    i32.const 126
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 6
    local.set $clo
    ref.func $closure_472
    local.get $clo
    struct.new $ClosureType_472
    ref.cast (ref $ClosureBase_467)
    local.set $lo_clo_112
    local.get $lo_clo_112
    f64.const 3.1415899999999999
    local.get $lo_clo_112
    struct.get $ClosureBase_467 0
    call_ref $FuncType_466
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_473 (param $self (ref $AnyFn)) (param $arg i32)
    (local $self_cast (ref $ClosureType_473))
    (local $clo (ref $AnyFn))
    (local $lo_clo_113 (ref $ClosureBase_123))
    local.get $self
    ref.cast (ref $ClosureType_473)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_473 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_123)
    local.set $lo_clo_113
    local.get $lo_clo_113
    local.get $arg
    local.get $lo_clo_113
    struct.get $ClosureBase_123 0
    call_ref $FuncType_60
  )
  (func $testPrintfnInt (result i32) ;; exported as "testPrintfnInt"
    (local $lo_clo_114 (ref $ClosureBase_123))
    (local $clo i32)
    ref.func $closure_473
    local.get $clo
    struct.new $ClosureType_473
    ref.cast (ref $ClosureBase_123)
    local.set $lo_clo_114
    local.get $lo_clo_114
    i32.const 42
    local.get $lo_clo_114
    struct.get $ClosureBase_123 0
    call_ref $FuncType_60
    i32.const 1
  )
  (func $closure_474 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr))
    (local $self_cast (ref $ClosureType_476))
    (local $clo (ref $AnyFn))
    (local $lo_clo_115 (ref $ClosureBase_475))
    local.get $self
    ref.cast (ref $ClosureType_476)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_476 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_475)
    local.set $lo_clo_115
    local.get $lo_clo_115
    local.get $arg
    local.get $lo_clo_115
    struct.get $ClosureBase_475 0
    call_ref $FuncType_474
  )
  (func $testPrintfnStr (result i32) ;; exported as "testPrintfnStr"
    (local $lo_clo_116 (ref $ClosureBase_475))
    (local $clo i32)
    ref.func $closure_474
    local.get $clo
    struct.new $ClosureType_476
    ref.cast (ref $ClosureBase_475)
    local.set $lo_clo_116
    local.get $lo_clo_116
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    local.get $lo_clo_116
    struct.get $ClosureBase_475 0
    call_ref $FuncType_474
    i32.const 1
  )
  (func $closure_477 (param $self (ref $AnyFn)) (param $arg_2 i32)
    (local $self_cast (ref $ClosureType_477))
    (local $clo_2 (ref $AnyFn))
    (local $lo_clo_117 (ref $ClosureBase_123))
    local.get $self
    ref.cast (ref $ClosureType_477)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_477 1
    local.set $clo_2
    local.get $clo_2
    ref.cast (ref $ClosureBase_123)
    local.set $lo_clo_117
    local.get $lo_clo_117
    local.get $arg_2
    local.get $lo_clo_117
    struct.get $ClosureBase_123 0
    call_ref $FuncType_60
  )
  (func $closure_477 (param $self (ref $AnyFn)) (param $arg_1 i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_478))
    (local $clo_1 (ref $AnyFn))
    (local $clo_2 (ref $AnyFn))
    (local $lo_clo_118 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_478)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_478 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_118
    local.get $lo_clo_118
    local.get $arg_1
    local.get $lo_clo_118
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_2
    ref.func $closure_477
    local.get $clo_2
    struct.new $ClosureType_477
  )
  (func $closure_477 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_479))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_119 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_479)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_479 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_119
    local.get $lo_clo_119
    local.get $arg
    local.get $lo_clo_119
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_1
    ref.func $closure_477
    local.get $clo_1
    struct.new $ClosureType_478
  )
  (func $testPrintfnMulti (result i32) ;; exported as "testPrintfnMulti"
    (local $lo_clo_120 (ref $ClosureBase_644))
    (local $clo i32)
    ref.func $closure_477
    local.get $clo
    struct.new $ClosureType_479
    ref.cast (ref $ClosureBase_644)
    local.set $lo_clo_120
    local.get $lo_clo_120
    i32.const 3
    i32.const 7
    i32.const 10
    local.get $lo_clo_120
    struct.get $ClosureBase_644 0
    call_ref $FuncType_480
    i32.const 1
  )
  (func $closure_481 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_481))
    (local $clo (ref $AnyFn))
    (local $lo_clo_121 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_481)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_481 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_121
    local.get $lo_clo_121
    local.get $arg
    local.get $lo_clo_121
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfI (result i32) ;; exported as "testSprintfI"
    (local $lo_clo_122 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 105
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_481
    local.get $clo
    struct.new $ClosureType_481
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_122
    local.get $lo_clo_122
    i32.const 99
    local.get $lo_clo_122
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
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
  (func $closure_482 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_482))
    (local $clo (ref $AnyFn))
    (local $lo_clo_123 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_482)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_482 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_123
    local.get $lo_clo_123
    local.get $arg
    local.get $lo_clo_123
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfIntZeroChar (result i32) ;; exported as "testSprintfIntZeroChar"
    (local $lo_clo_124 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_482
    local.get $clo
    struct.new $ClosureType_482
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_124
    local.get $lo_clo_124
    i32.const 0
    local.get $lo_clo_124
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_483 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_483))
    (local $clo (ref $AnyFn))
    (local $lo_clo_125 (ref $ClosureBase_446))
    local.get $self
    ref.cast (ref $ClosureType_483)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_483 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_446)
    local.set $lo_clo_125
    local.get $lo_clo_125
    local.get $arg
    local.get $lo_clo_125
    struct.get $ClosureBase_446 0
    call_ref $FuncType_445
  )
  (func $testSprintfEmptyStr (result i32) ;; exported as "testSprintfEmptyStr"
    (local $lo_clo_126 (ref $ClosureBase_446))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_483
    local.get $clo
    struct.new $ClosureType_483
    ref.cast (ref $ClosureBase_446)
    local.set $lo_clo_126
    local.get $lo_clo_126
    array.new_fixed $WasmStr 0
    local.get $lo_clo_126
    struct.get $ClosureBase_446 0
    call_ref $FuncType_445
    array.len
  )
  (func $closure_484 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_484))
    (local $clo (ref $AnyFn))
    (local $lo_clo_127 (ref $ClosureBase_442))
    local.get $self
    ref.cast (ref $ClosureType_484)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_484 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_127
    local.get $lo_clo_127
    local.get $arg
    local.get $lo_clo_127
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
  )
  (func $testSprintfIntFirstChar (result i32) ;; exported as "testSprintfIntFirstChar"
    (local $lo_clo_128 (ref $ClosureBase_442))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_484
    local.get $clo
    struct.new $ClosureType_484
    ref.cast (ref $ClosureBase_442)
    local.set $lo_clo_128
    local.get $lo_clo_128
    i32.const 42
    local.get $lo_clo_128
    struct.get $ClosureBase_442 0
    call_ref $FuncType_441
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
  (func $closure_491 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testResultMap (result i32) ;; exported as "testResultMap"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w1089 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 21
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w1089
    local.get $w1089
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w1089
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.shl
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w1089
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
  (func $closure_492 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBind (result i32) ;; exported as "testResultBind"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w1090 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 5
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w1090
    local.get $w1090
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w1090
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w1090
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
  (func $closure_495 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBindError (result i32) ;; exported as "testResultBindError"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w1091 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 1
    i32.const -99
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    local.set $w1091
    local.get $w1091
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w1091
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w1091
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
  (func $testSetContains (result i32) ;; exported as "testSetContains"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_496
    struct.new $ClosureType_496
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
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
  (func $closure_497 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_497
    struct.new $ClosureType_497
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
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
  (func $closure_498 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_498
    struct.new $ClosureType_498
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    i32.const 3
    local.get $s
    call $Set_remove
    local.set $s2
    local.get $s2
    return_call $Set_count
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
  (func $closure_500 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_499
    struct.new $ClosureType_499
    ref.null $ListBase
    call $Set_ofList
    local.set $e
    ref.func $closure_500
    struct.new $ClosureType_500
    i32.const 1
    ref.null $ListBase
    struct.new $ListCons_30
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
  (func $closure_501 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_502 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_502))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_502)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_502 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_502 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_502
    local.get $acc
    struct.new $ClosureType_502
  )
  (func $testSetFold (result i32) ;; exported as "testSetFold"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_501
    struct.new $ClosureType_501
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_502
    struct.new $ClosureType_503
    i32.const 0
    local.get $s
    return_call $Set_fold
  )
  (func $closure_504 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_505 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testSetFilter (result i32) ;; exported as "testSetFilter"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_504
    struct.new $ClosureType_504
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_505
    struct.new $ClosureType_505
    local.get $s
    call $Set_filter
    local.set $s2
    local.get $s2
    return_call $Set_count
  )
  (func $closure_506 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_507 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 4
    i32.gt_s
  )
  (func $testSetExists (result i32) ;; exported as "testSetExists"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_506
    struct.new $ClosureType_506
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_507
    struct.new $ClosureType_507
    local.get $s
    call $Set_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_508 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_509 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 0
    i32.gt_s
  )
  (func $testSetForall (result i32) ;; exported as "testSetForall"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_508
    struct.new $ClosureType_508
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_509
    struct.new $ClosureType_509
    local.get $s
    call $Set_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_510 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_511 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_510
    struct.new $ClosureType_510
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $a
    ref.func $closure_511
    struct.new $ClosureType_511
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $b
    local.get $a
    local.get $b
    call $Set_union
    return_call $Set_count
  )
  (func $closure_512 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_513 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_512
    struct.new $ClosureType_512
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $a
    ref.func $closure_513
    struct.new $ClosureType_513
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $b
    local.get $a
    local.get $b
    call $Set_intersect
    return_call $Set_count
  )
  (func $closure_514 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_515 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_514
    struct.new $ClosureType_514
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $a
    ref.func $closure_515
    struct.new $ClosureType_515
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $b
    local.get $a
    local.get $b
    call $Set_difference
    return_call $Set_count
  )
  (func $closure_516 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_517 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_516
    struct.new $ClosureType_516
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $a
    ref.func $closure_517
    struct.new $ClosureType_517
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
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
  (func $closure_518 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_519 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 1
    i32.shl
  )
  (func $closure_520 (param $self (ref $AnyFn)) (param $x_2 i32) (param $y_1 i32) (result i32)
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
  (func $closure_521 (param $self (ref $AnyFn)) (param $x_3 i32) (result i32)
    (local $self_cast (ref $ClosureType_521))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_521)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_521 1
    local.set $acc
    local.get $acc
    local.get $x_3
    i32.add
  )
  (func $closure_521 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_521
    local.get $acc
    struct.new $ClosureType_521
  )
  (func $testSetMap (result i32) ;; exported as "testSetMap"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_518
    struct.new $ClosureType_518
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_519
    struct.new $ClosureType_519
    local.get $s
    call $Set_map
    local.set $s2
    ref.func $closure_521
    struct.new $ClosureType_522
    i32.const 0
    local.get $s2
    return_call $Set_fold
  )
  (func $closure_523 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_523
    struct.new $ClosureType_523
    i32.const 5
    i32.const 1
    i32.const 3
    i32.const 2
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    local.get $s
    call $Set_minElement
    local.get $s
    call $Set_maxElement
    i32.add
  )
  (func $closure_524 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_524
    struct.new $ClosureType_524
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
  (func $closure_525 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_525))
    (local $acc i32)
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_525)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_525 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_525 2
    local.set $offset
    local.get $acc
    local.get $v
    i32.add
    local.get $offset
    i32.add
  )
  (func $closure_525 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_526))
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_526)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_526 1
    local.set $offset
    ref.func $closure_525
    local.get $acc
    local.get $offset
    struct.new $ClosureType_525
  )
  (func $closure_527 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_525
    i32.const 100
    struct.new $ClosureType_526
    i32.const 0
    ref.func $closure_527
    struct.new $ClosureType_527
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    return_call $Set_fold
  )
  (func $closure_528 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_530))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_530)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_530 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_531 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_531))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_531)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_531 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_532 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_532))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_532)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_532 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_533 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_533))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_533)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_533 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_533 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_533
    local.get $a
    struct.new $ClosureType_533
  )
  (func $testSetModuleBasic (result i32) ;; exported as "testSetModuleBasic"
    (local $s_3 (ref $SetModule_SetHandle`1))
    (local $lo_clo_131 (ref $ClosureBase_529))
    (local $lo_clo_130 (ref $ClosureBase_529))
    (local $lo_clo_129 (ref $ClosureBase_529))
    ref.func $closure_528
    i32.const 7
    struct.new $ClosureType_530
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_131
    local.get $lo_clo_131
    ref.func $closure_531
    i32.const 3
    struct.new $ClosureType_531
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_130
    local.get $lo_clo_130
    ref.func $closure_532
    i32.const 5
    struct.new $ClosureType_532
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_129
    local.get $lo_clo_129
    ref.func $closure_533
    struct.new $ClosureType_534
    call $Set_empty
    local.get $lo_clo_129
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_130
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_131
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.set $s_3
    local.get $s_3
    return_call $Set_count
  )
  (func $closure_535 (param $self (ref $AnyFn)) (param $s_3 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_535))
    (local $value_3 i32)
    local.get $self
    ref.cast (ref $ClosureType_535)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_535 1
    local.set $value_3
    local.get $value_3
    local.get $s_3
    call $Set_add
  )
  (func $closure_536 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_536))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_536)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_536 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_537 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_537))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_537)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_537 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_538 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_538))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_538)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_538 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_539 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_539))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_539)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_539 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_539 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_539
    local.get $a
    struct.new $ClosureType_539
  )
  (func $testSetModuleDedup (result i32) ;; exported as "testSetModuleDedup"
    (local $s_4 (ref $SetModule_SetHandle`1))
    (local $lo_clo_135 (ref $ClosureBase_529))
    (local $lo_clo_134 (ref $ClosureBase_529))
    (local $lo_clo_133 (ref $ClosureBase_529))
    (local $lo_clo_132 (ref $ClosureBase_529))
    ref.func $closure_535
    i32.const 2
    struct.new $ClosureType_535
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_135
    local.get $lo_clo_135
    ref.func $closure_536
    i32.const 2
    struct.new $ClosureType_536
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_134
    local.get $lo_clo_134
    ref.func $closure_537
    i32.const 1
    struct.new $ClosureType_537
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_133
    local.get $lo_clo_133
    ref.func $closure_538
    i32.const 1
    struct.new $ClosureType_538
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_132
    local.get $lo_clo_132
    ref.func $closure_539
    struct.new $ClosureType_540
    call $Set_empty
    local.get $lo_clo_132
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_133
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_134
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_135
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.set $s_4
    local.get $s_4
    return_call $Set_count
  )
  (func $closure_541 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_541))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_541)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_541 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_542 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_542))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_542)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_542 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_543 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_543))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_543)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_543 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_543 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_543
    local.get $a
    struct.new $ClosureType_543
  )
  (func $testSetModuleContains (result i32) ;; exported as "testSetModuleContains"
    (local $s_2 (ref $SetModule_SetHandle`1))
    (local $lo_clo_137 (ref $ClosureBase_529))
    (local $lo_clo_136 (ref $ClosureBase_529))
    ref.func $closure_541
    i32.const 99
    struct.new $ClosureType_541
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_137
    local.get $lo_clo_137
    ref.func $closure_542
    i32.const 42
    struct.new $ClosureType_542
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_136
    local.get $lo_clo_136
    ref.func $closure_543
    struct.new $ClosureType_544
    call $Set_empty
    local.get $lo_clo_136
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_137
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
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
  (func $closure_545 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_545))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_545)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_545 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_546 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_546))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_546)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_546 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_547 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_547))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_547)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_547 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_548 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_548))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_548)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_548 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_548 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_548
    local.get $a
    struct.new $ClosureType_548
  )
  (func $closure_550 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_550))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_550)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_550 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_550 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_550
    local.get $acc
    struct.new $ClosureType_550
  )
  (func $testSetModuleFold (result i32) ;; exported as "testSetModuleFold"
    (local $s_3 (ref $SetModule_SetHandle`1))
    (local $lo_clo_140 (ref $ClosureBase_529))
    (local $lo_clo_139 (ref $ClosureBase_529))
    (local $lo_clo_138 (ref $ClosureBase_529))
    ref.func $closure_545
    i32.const 30
    struct.new $ClosureType_545
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_140
    local.get $lo_clo_140
    ref.func $closure_546
    i32.const 20
    struct.new $ClosureType_546
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_139
    local.get $lo_clo_139
    ref.func $closure_547
    i32.const 10
    struct.new $ClosureType_547
    ref.cast (ref $ClosureBase_529)
    local.set $lo_clo_138
    local.get $lo_clo_138
    ref.func $closure_548
    struct.new $ClosureType_549
    call $Set_empty
    local.get $lo_clo_138
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_139
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.get $lo_clo_140
    struct.get $ClosureBase_529 0
    call_ref $FuncType_528
    local.set $s_3
    ref.func $closure_550
    struct.new $ClosureType_551
    i32.const 0
    local.get $s_3
    return_call $Set_fold
  )
  (func $runSetTests (param $check (ref $AnyFn)) ;; exported as "runSetTests"
  )
  (func $closure_552 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_552 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w1093 i32)
    (local $w1094 i32)
    local.get $source_1
    local.set $w1093
    i32.const 0
    local.set $w1094
    block $while_1095_exit
      loop $while_1095_lp
        local.get $w1093
        ref.is_null
        i32.eqz
        if
          local.get $w1094
          local.get $w1093
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1094
          local.get $w1093
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1093
          br $while_1095_lp
        else
          br $while_1095_exit
        end
      end
    end
    local.get $w1094
  )
  (func $closure_554 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_555 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqMap (result i32) ;; exported as "testSeqMap"
    (local $lo_clo_142 (ref $ClosureBase_26))
    (local $lo_clo_141 (ref $ClosureBase_33))
    (local $mapping (ref $ClosureType_554))
    ref.func $closure_552
    struct.new $ClosureType_553
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_142
    local.get $lo_clo_142
    ref.func $closure_554
    struct.new $ClosureType_554
    local.set $mapping
    ref.func $closure_555
    local.get $mapping
    struct.new $ClosureType_555
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_141
    local.get $lo_clo_141
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_141
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_142
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_556 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w1097 i32)
    (local $w1098 i32)
    local.get $source_1
    local.set $w1097
    i32.const 0
    local.set $w1098
    block $while_1099_exit
      loop $while_1099_lp
        local.get $w1097
        ref.is_null
        i32.eqz
        if
          local.get $w1098
          i32.const 1
          i32.add
          local.set $w1098
          local.get $w1097
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1097
          br $while_1099_lp
        else
          br $while_1099_exit
        end
      end
    end
    local.get $w1098
  )
  (func $closure_557 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_558 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqFilter (result i32) ;; exported as "testSeqFilter"
    (local $lo_clo_144 (ref $ClosureBase_26))
    (local $lo_clo_143 (ref $ClosureBase_33))
    (local $predicate (ref $ClosureType_557))
    ref.func $closure_556
    struct.new $ClosureType_556
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_144
    local.get $lo_clo_144
    ref.func $closure_557
    struct.new $ClosureType_557
    local.set $predicate
    ref.func $closure_558
    local.get $predicate
    struct.new $ClosureType_558
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_143
    local.get $lo_clo_143
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_143
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_144
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_559 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_559))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_559)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_559 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_559 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_559
    local.get $acc
    struct.new $ClosureType_559
  )
  (func $testSeqFold (result i32) ;; exported as "testSeqFold"
    (local $w1101 (ref null $ListBase))
    (local $w1102 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1101
    i32.const 0
    local.set $w1102
    block $while_1103_exit
      loop $while_1103_lp
        local.get $w1101
        ref.is_null
        i32.eqz
        if
          local.get $w1101
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $w1102
          local.get $x
          i32.add
          local.set $w1102
          local.get $w1101
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1101
          br $while_1103_lp
        else
          br $while_1103_exit
        end
      end
    end
    local.get $w1102
  )
  (func $closure_561 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testSeqExists (result i32) ;; exported as "testSeqExists"
    (local $w1105 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1105
    block $exi_1104_blk (result i32)
      block $exi_1104_lp_exit
        loop $exi_1104_lp
          local.get $w1105
          ref.is_null
          i32.eqz
          if
            local.get $w1105
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              i32.const 1
              br $exi_1104_blk
            end
            local.get $w1105
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1105
          else
            br $exi_1104_lp_exit
          end
          br $exi_1104_lp
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
  (func $closure_562 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_563 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_563 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqSumBy (result i32) ;; exported as "testSeqSumBy"
    (local $lo_clo_145 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_562))
    ref.func $closure_562
    struct.new $ClosureType_562
    local.set $projection
    ref.func $closure_563
    local.get $projection
    struct.new $ClosureType_564
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_145
    local.get $lo_clo_145
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_145
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_565 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_565 (param $self (ref $AnyFn)) (param $source i32) (result i32)
    (local $w1107 i32)
    (local $w1108 i32)
    local.get $source
    local.set $w1107
    i32.const 0
    local.set $w1108
    block $while_1109_exit
      loop $while_1109_lp
        local.get $w1107
        ref.is_null
        i32.eqz
        if
          local.get $w1108
          local.get $w1107
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1108
          local.get $w1107
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1107
          br $while_1109_lp
        else
          br $while_1109_exit
        end
      end
    end
    local.get $w1108
  )
  (func $closure_567 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $testSeqInit (result i32) ;; exported as "testSeqInit"
    (local $lo_clo_146 (ref $ClosureBase_33))
    (local $w1111 i32)
    (local $w1112 (ref null $ListBase))
    ref.func $closure_565
    struct.new $ClosureType_566
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_146
    local.get $lo_clo_146
    i32.const 4
    local.set $w1111
    ref.null $ListBase
    local.set $w1112
    block $while_1113_exit
      loop $while_1113_lp
        local.get $w1111
        i32.const 0
        i32.ge_s
        if
          local.get $w1111
          local.get $w1111
          i32.mul
          local.get $w1112
          struct.new $ListCons_30
          local.set $w1112
          local.get $w1111
          i32.const 1
          i32.sub
          local.set $w1111
          br $while_1113_lp
        else
          br $while_1113_exit
        end
      end
    end
    local.get $w1112
    local.get $lo_clo_146
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_568 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_568 (param $self (ref $AnyFn)) (param $source_2 i32) (result i32)
    (local $w1115 i32)
    (local $w1116 i32)
    local.get $source_2
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
          local.get $w1115
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1116
          local.get $w1115
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1115
          br $while_1117_lp
        else
          br $while_1117_exit
        end
      end
    end
    local.get $w1116
  )
  (func $closure_570 (param $self (ref $AnyFn)) (param $tupledArg (ref $Tuple_90)) (result i32)
    (local $a i32)
    (local $b i32)
    local.get $tupledArg
    struct.get $Tuple_90 0
    local.set $a
    local.get $tupledArg
    struct.get $Tuple_90 1
    local.set $b
    local.get $b
    local.get $a
    i32.sub
  )
  (func $closure_573 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
  )
  (func $closure_574 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
    (local $w1120 (ref $ListCons_30))
    (local $w1121 i32)
    (local $w1127 (ref null $ListBase))
    (local $w1122 (ref null $ListBase))
    (local $w1123 (ref null $ListBase))
    (local $w1124 i32)
    (local $w1125 (ref $Tuple_90))
    (local $w1128 (ref null $ListBase))
    local.get $source
    ref.is_null
    if (result (ref null $ListBase))
      ref.null $ListBase
    else
      local.get $source
      ref.cast (ref $ListCons_30)
      local.set $w1120
      local.get $w1120
      struct.get $ListCons_30 0
      local.set $w1121
      local.get $w1120
      struct.get $ListCons_30 1
      local.set $w1122
      ref.null $ListBase
      local.set $w1123
      block $while_1126_exit
        loop $while_1126_lp
          local.get $w1122
          ref.is_null
          i32.eqz
          if
            local.get $w1122
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $w1124
            local.get $w1121
            local.get $w1124
            struct.new $Tuple_90
            local.set $w1125
            local.get $w1124
            local.set $w1121
            local.get $w1125
            local.get $w1123
            struct.new $ListCons_91
            local.set $w1123
            local.get $w1122
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1122
            br $while_1126_lp
          else
            br $while_1126_exit
          end
        end
      end
      local.get $w1123
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
            ref.cast (ref $ListCons_91)
            struct.get $ListCons_91 0
            local.get $w1128
            struct.new $ListCons_91
            local.set $w1128
            local.get $w1127
            ref.cast (ref $ListCons_91)
            struct.get $ListCons_91 1
            local.set $w1127
            br $while_1129_lp
          else
            br $while_1129_exit
          end
        end
      end
      local.get $w1128
    end
  )
  (func $testSeqPairwise (result i32) ;; exported as "testSeqPairwise"
    (local $lo_clo_149 (ref $ClosureBase_26))
    (local $lo_clo_148 (ref $ClosureBase_26))
    (local $mapping (ref $ClosureType_572))
    (local $lo_clo_147 (ref $ClosureBase_33))
    ref.func $closure_568
    struct.new $ClosureType_569
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_149
    local.get $lo_clo_149
    ref.func $closure_570
    struct.new $ClosureType_572
    local.set $mapping
    ref.func $closure_573
    local.get $mapping
    struct.new $ClosureType_573
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_148
    local.get $lo_clo_148
    ref.func $closure_574
    struct.new $ClosureType_574
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_147
    local.get $lo_clo_147
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_147
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_148
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $lo_clo_149
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_575 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_576 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_576 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqCountBy (result i32) ;; exported as "testSeqCountBy"
    (local $result i32)
    (local $lo_clo_150 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_575))
    (local $w1131 i32)
    (local $w1132 i32)
    ref.func $closure_575
    struct.new $ClosureType_575
    local.set $projection
    ref.func $closure_576
    local.get $projection
    struct.new $ClosureType_577
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_150
    local.get $lo_clo_150
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_150
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.set $result
    local.get $result
    local.set $w1131
    i32.const 0
    local.set $w1132
    block $while_1133_exit
      loop $while_1133_lp
        local.get $w1131
        ref.is_null
        i32.eqz
        if
          local.get $w1132
          i32.const 1
          i32.add
          local.set $w1132
          local.get $w1131
          ref.cast (ref $ListCons_91)
          struct.get $ListCons_91 1
          local.set $w1131
          br $while_1133_lp
        else
          br $while_1133_exit
        end
      end
    end
    local.get $w1132
  )
  (func $closure_578 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w1135 i32)
    (local $w1136 i32)
    local.get $source_1
    local.set $w1135
    i32.const 0
    local.set $w1136
    block $while_1137_exit
      loop $while_1137_lp
        local.get $w1135
        ref.is_null
        i32.eqz
        if
          local.get $w1136
          i32.const 1
          i32.add
          local.set $w1136
          local.get $w1135
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1135
          br $while_1137_lp
        else
          br $while_1137_exit
        end
      end
    end
    local.get $w1136
  )
  (func $closure_579 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $closure_579 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
    (local $w1139 (ref null $ListBase))
    (local $w1140 (ref null $ListBase))
    (local $w1141 (ref null $ListBase))
    (local $dst_1138_de i32)
    (local $w1142 (ref null $ListBase))
    (local $w1144 (ref null $ListBase))
    (local $w1145 (ref null $ListBase))
    ref.null $ListBase
    local.set $w1139
    ref.null $ListBase
    local.set $w1140
    local.get $source
    local.set $w1141
    block $while_1143_exit
      loop $while_1143_lp
        local.get $w1141
        ref.is_null
        i32.eqz
        if
          local.get $w1141
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $dst_1138_de
          local.get $w1140
          local.set $w1142
          block $dst_1138_blk (result i32)
            block $dst_1138_lp_exit
              loop $dst_1138_lp
                local.get $w1142
                ref.is_null
                i32.eqz
                if
                  local.get $w1142
                  ref.cast (ref $ListCons_30)
                  struct.get $ListCons_30 0
                  local.get $dst_1138_de
                  i32.eq
                  if
                    i32.const 1
                    br $dst_1138_blk
                  end
                  local.get $w1142
                  ref.cast (ref $ListCons_30)
                  struct.get $ListCons_30 1
                  local.set $w1142
                else
                  br $dst_1138_lp_exit
                end
                br $dst_1138_lp
              end
            end
            i32.const 0
          end
          if
          else
            local.get $dst_1138_de
            local.get $w1140
            struct.new $ListCons_30
            local.set $w1140
            local.get $dst_1138_de
            local.get $w1139
            struct.new $ListCons_30
            local.set $w1139
          end
          local.get $w1141
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1141
          br $while_1143_lp
        else
          br $while_1143_exit
        end
      end
    end
    local.get $w1139
    local.set $w1144
    ref.null $ListBase
    local.set $w1145
    block $while_1146_exit
      loop $while_1146_lp
        local.get $w1144
        ref.is_null
        i32.eqz
        if
          local.get $w1144
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1145
          struct.new $ListCons_30
          local.set $w1145
          local.get $w1144
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1144
          br $while_1146_lp
        else
          br $while_1146_exit
        end
      end
    end
    local.get $w1145
  )
  (func $testSeqDistinct (result i32) ;; exported as "testSeqDistinct"
    (local $lo_clo_152 (ref $ClosureBase_26))
    (local $lo_clo_151 (ref $ClosureBase_33))
    ref.func $closure_578
    struct.new $ClosureType_578
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_152
    local.get $lo_clo_152
    ref.func $closure_579
    struct.new $ClosureType_580
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_151
    local.get $lo_clo_151
    i32.const 1
    i32.const 2
    i32.const 2
    i32.const 3
    i32.const 3
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_151
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_152
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_581 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_581 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w1148 i32)
    (local $w1149 i32)
    local.get $source_1
    local.set $w1148
    i32.const 0
    local.set $w1149
    block $while_1150_exit
      loop $while_1150_lp
        local.get $w1148
        ref.is_null
        i32.eqz
        if
          local.get $w1149
          local.get $w1148
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1149
          local.get $w1148
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1148
          br $while_1150_lp
        else
          br $while_1150_exit
        end
      end
    end
    local.get $w1149
  )
  (func $closure_583 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_89))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_89))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_89
    else
      ref.null $Option_89
    end
  )
  (func $closure_584 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqChoose (result i32) ;; exported as "testSeqChoose"
    (local $lo_clo_154 (ref $ClosureBase_26))
    (local $lo_clo_153 (ref $ClosureBase_33))
    (local $chooser (ref $ClosureType_583))
    ref.func $closure_581
    struct.new $ClosureType_582
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_154
    local.get $lo_clo_154
    ref.func $closure_583
    struct.new $ClosureType_583
    local.set $chooser
    ref.func $closure_584
    local.get $chooser
    struct.new $ClosureType_584
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_153
    local.get $lo_clo_153
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_153
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_154
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_585 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_585 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w1152 i32)
    (local $w1153 i32)
    local.get $source_1
    local.set $w1152
    i32.const 0
    local.set $w1153
    block $while_1154_exit
      loop $while_1154_lp
        local.get $w1152
        ref.is_null
        i32.eqz
        if
          local.get $w1153
          local.get $w1152
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1153
          local.get $w1152
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1152
          br $while_1154_lp
        else
          br $while_1154_exit
        end
      end
    end
    local.get $w1153
  )
  (func $closure_587 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $closure_588 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqCollect (result i32) ;; exported as "testSeqCollect"
    (local $lo_clo_156 (ref $ClosureBase_26))
    (local $lo_clo_155 (ref $ClosureBase_33))
    (local $mapping (ref $ClosureType_587))
    ref.func $closure_585
    struct.new $ClosureType_586
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_156
    local.get $lo_clo_156
    ref.func $closure_587
    struct.new $ClosureType_587
    local.set $mapping
    ref.func $closure_588
    local.get $mapping
    struct.new $ClosureType_588
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_155
    local.get $lo_clo_155
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_155
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_156
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_589 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_589))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_589)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_589 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_589 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_589
    local.get $a
    struct.new $ClosureType_589
  )
  (func $closure_591 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqReduce (result i32) ;; exported as "testSeqReduce"
    (local $lo_clo_157 (ref $ClosureBase_33))
    (local $reduction (ref $ClosureType_590))
    ref.func $closure_589
    struct.new $ClosureType_590
    local.set $reduction
    ref.func $closure_591
    local.get $reduction
    struct.new $ClosureType_591
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_157
    local.get $lo_clo_157
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_157
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_592 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_592 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
    (local $w1156 i32)
    (local $w1157 i32)
    local.get $source_1
    local.set $w1156
    i32.const 0
    local.set $w1157
    block $while_1158_exit
      loop $while_1158_lp
        local.get $w1156
        ref.is_null
        i32.eqz
        if
          local.get $w1157
          local.get $w1156
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1157
          local.get $w1156
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1156
          br $while_1158_lp
        else
          br $while_1158_exit
        end
      end
    end
    local.get $w1157
  )
  (func $closure_594 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_594))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_594)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_594 1
    local.set $i
    local.get $i
    local.get $x
    i32.add
  )
  (func $closure_594 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_594
    local.get $i
    struct.new $ClosureType_594
  )
  (func $closure_596 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqMapIndexed (result i32) ;; exported as "testSeqMapIndexed"
    (local $lo_clo_159 (ref $ClosureBase_26))
    (local $lo_clo_158 (ref $ClosureBase_33))
    (local $mapping (ref $ClosureType_595))
    ref.func $closure_592
    struct.new $ClosureType_593
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_159
    local.get $lo_clo_159
    ref.func $closure_594
    struct.new $ClosureType_595
    local.set $mapping
    ref.func $closure_596
    local.get $mapping
    struct.new $ClosureType_596
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_158
    local.get $lo_clo_158
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_158
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_159
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_597 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testSeqForall (result i32) ;; exported as "testSeqForall"
    (local $w1160 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1160
    block $all_1159_blk (result i32)
      block $all_1159_lp_exit
        loop $all_1159_lp
          local.get $w1160
          ref.is_null
          i32.eqz
          if
            local.get $w1160
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w1160
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w1160
            else
              i32.const 0
              br $all_1159_blk
            end
          else
            br $all_1159_lp_exit
          end
          br $all_1159_lp
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
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testSeqTryHead (result i32) ;; exported as "testSeqTryHead"
    (local $matchValue (ref null $Option_89))
    (local $w1162 (ref null $ListBase))
    i32.const 42
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1162
    local.get $w1162
    ref.is_null
    if (result (ref null $Option_89))
      ref.null $Option_89
    else
      local.get $w1162
      ref.cast (ref $ListCons_30)
      struct.get $ListCons_30 0
      struct.new $Option_89
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_89)
      struct.get $Option_89 0
    end
  )
  (func $testSeqTryHeadEmpty (result i32) ;; exported as "testSeqTryHeadEmpty"
    (local $matchValue (ref null $Option_89))
    ref.null $Option_89
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
    (local $w1166 (ref null $ListBase))
    (local $w1167 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1166
    i32.const 0
    local.set $w1167
    block $while_1168_exit
      loop $while_1168_lp
        local.get $w1166
        ref.is_null
        i32.eqz
        if
          local.get $w1167
          i32.const 1
          i32.add
          local.set $w1167
          local.get $w1166
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1166
          br $while_1168_lp
        else
          br $while_1168_exit
        end
      end
    end
    local.get $w1167
  )
  (func $testSeqItem (result i32) ;; exported as "testSeqItem"
    (local $w1170 i32)
    (local $w1171 (ref null $ListBase))
    i32.const 2
    local.set $w1170
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1171
    block $while_1172_exit
      loop $while_1172_lp
        local.get $w1170
        i32.const 0
        i32.gt_s
        if
          local.get $w1171
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1171
          local.get $w1170
          i32.const 1
          i32.sub
          local.set $w1170
          br $while_1172_lp
        else
          br $while_1172_exit
        end
      end
    end
    local.get $w1171
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_598 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_599 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    (local $w1174 (ref null $ListBase))
    (local $w1175 (ref $ListCons_30))
    (local $w1176 i32)
    (local $w1177 (ref null $ListBase))
    (local $w1178 i32)
    (local $w1181 (ref null $ListBase))
    (local $w1182 (ref $ListCons_30))
    (local $w1183 i32)
    (local $w1184 (ref null $ListBase))
    (local $w1185 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1174
    local.get $w1174
    ref.cast (ref $ListCons_30)
    local.set $w1175
    local.get $w1175
    struct.get $ListCons_30 0
    local.set $w1176
    local.get $w1175
    struct.get $ListCons_30 1
    local.set $w1177
    block $while_1179_exit
      loop $while_1179_lp
        local.get $w1177
        ref.is_null
        i32.eqz
        if
          local.get $w1177
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w1178
          local.get $w1178
          local.get $w1176
          i32.lt_s
          if
            local.get $w1178
            local.set $w1176
          end
          local.get $w1177
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1177
          br $while_1179_lp
        else
          br $while_1179_exit
        end
      end
    end
    local.get $w1176
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1181
    local.get $w1181
    ref.cast (ref $ListCons_30)
    local.set $w1182
    local.get $w1182
    struct.get $ListCons_30 0
    local.set $w1183
    local.get $w1182
    struct.get $ListCons_30 1
    local.set $w1184
    block $while_1186_exit
      loop $while_1186_lp
        local.get $w1184
        ref.is_null
        i32.eqz
        if
          local.get $w1184
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w1185
          local.get $w1185
          local.get $w1183
          i32.gt_s
          if
            local.get $w1185
            local.set $w1183
          end
          local.get $w1184
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1184
          br $while_1186_lp
        else
          br $while_1186_exit
        end
      end
    end
    local.get $w1183
    i32.add
  )
  (func $closure_600 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    local.get $list_1
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_601 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_602 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
  (func $closure_602 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testSeqSortBy (result i32) ;; exported as "testSeqSortBy"
    (local $lo_clo_161 (ref $ClosureBase_33))
    (local $lo_clo_160 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_601))
    ref.func $closure_600
    struct.new $ClosureType_600
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_161
    local.get $lo_clo_161
    ref.func $closure_601
    struct.new $ClosureType_601
    local.set $projection
    ref.func $closure_602
    local.get $projection
    struct.new $ClosureType_603
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_160
    local.get $lo_clo_160
    i32.const 30
    i32.const 10
    i32.const 20
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_160
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_161
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_604 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testSeqRev (result i32) ;; exported as "testSeqRev"
    (local $lo_clo_162 (ref $ClosureBase_33))
    (local $w1188 (ref null $ListBase))
    (local $w1189 (ref null $ListBase))
    ref.func $closure_604
    struct.new $ClosureType_604
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_162
    local.get $lo_clo_162
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1188
    ref.null $ListBase
    local.set $w1189
    block $while_1190_exit
      loop $while_1190_lp
        local.get $w1188
        ref.is_null
        i32.eqz
        if
          local.get $w1188
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1189
          struct.new $ListCons_30
          local.set $w1189
          local.get $w1188
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1188
          br $while_1190_lp
        else
          br $while_1190_exit
        end
      end
    end
    local.get $w1189
    local.get $lo_clo_162
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_605 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 20
    i32.gt_s
  )
  (func $testSeqFindIndex (result i32) ;; exported as "testSeqFindIndex"
    (local $w1192 (ref null $ListBase))
    (local $w1193 i32)
    (local $x i32)
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1192
    i32.const 0
    local.set $w1193
    block $fdi_1191_exit (result i32)
      loop $fdi_1191_lp
        local.get $w1192
        ref.is_null
        i32.eqz
        if
          local.get $w1192
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 20
          i32.gt_s
          if
            local.get $w1193
            br $fdi_1191_exit
          else
            local.get $w1193
            i32.const 1
            i32.add
            local.set $w1193
            local.get $w1192
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1192
            br $fdi_1191_lp
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_606 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_606 (param $self (ref $AnyFn)) (param $list_2 (ref null $ListBase)) (result i32)
    (local $w1195 (ref null $ListBase))
    (local $w1196 i32)
    local.get $list_2
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
          local.get $w1195
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1196
          local.get $w1195
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1195
          br $while_1197_lp
        else
          br $while_1197_exit
        end
      end
    end
    local.get $w1196
  )
  (func $closure_608 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_608))
    (local $count_1 i32)
    (local $w1203 (ref null $ListBase))
    (local $w1199 i32)
    (local $w1200 (ref null $ListBase))
    (local $w1201 (ref null $ListBase))
    (local $w1204 (ref null $ListBase))
    local.get $self
    ref.cast (ref $ClosureType_608)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_608 1
    local.set $count_1
    local.get $count_1
    local.set $w1199
    local.get $list_1
    local.set $w1200
    ref.null $ListBase
    local.set $w1201
    block $while_1202_exit
      loop $while_1202_lp
        local.get $w1199
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w1200
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w1200
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1201
          struct.new $ListCons_30
          local.set $w1201
          local.get $w1200
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1200
          local.get $w1199
          i32.const 1
          i32.sub
          local.set $w1199
          br $while_1202_lp
        else
          br $while_1202_exit
        end
      end
    end
    local.get $w1201
    local.set $w1203
    ref.null $ListBase
    local.set $w1204
    block $while_1205_exit
      loop $while_1205_lp
        local.get $w1203
        ref.is_null
        i32.eqz
        if
          local.get $w1203
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1204
          struct.new $ListCons_30
          local.set $w1204
          local.get $w1203
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1203
          br $while_1205_lp
        else
          br $while_1205_exit
        end
      end
    end
    local.get $w1204
  )
  (func $closure_609 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_609))
    (local $count i32)
    (local $w1207 i32)
    (local $w1208 (ref null $ListBase))
    local.get $self
    ref.cast (ref $ClosureType_609)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_609 1
    local.set $count
    local.get $count
    local.set $w1207
    local.get $list
    local.set $w1208
    block $while_1209_exit
      loop $while_1209_lp
        local.get $w1207
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w1208
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w1208
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1208
          local.get $w1207
          i32.const 1
          i32.sub
          local.set $w1207
          br $while_1209_lp
        else
          br $while_1209_exit
        end
      end
    end
    local.get $w1208
  )
  (func $testSeqSkipTake (result i32) ;; exported as "testSeqSkipTake"
    (local $lo_clo_165 (ref $ClosureBase_33))
    (local $lo_clo_164 (ref $ClosureBase_37))
    (local $lo_clo_163 (ref $ClosureBase_37))
    ref.func $closure_606
    struct.new $ClosureType_607
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_165
    local.get $lo_clo_165
    ref.func $closure_608
    i32.const 2
    struct.new $ClosureType_608
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_164
    local.get $lo_clo_164
    ref.func $closure_609
    i32.const 2
    struct.new $ClosureType_609
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_163
    local.get $lo_clo_163
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_163
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_164
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_165
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_610 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w1211 (ref null $ListBase))
    (local $w1212 i32)
    local.get $list_1
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
          ref.cast (ref $ListCons_396)
          struct.get $ListCons_396 1
          local.set $w1211
          br $while_1213_lp
        else
          br $while_1213_exit
        end
      end
    end
    local.get $w1212
  )
  (func $closure_611 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_612 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_612 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testSeqGroupByCount (result i32) ;; exported as "testSeqGroupByCount"
    (local $lo_clo_167 (ref $ClosureBase_33))
    (local $lo_clo_166 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_611))
    ref.func $closure_610
    struct.new $ClosureType_610
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_167
    local.get $lo_clo_167
    ref.func $closure_611
    struct.new $ClosureType_611
    local.set $projection
    ref.func $closure_612
    local.get $projection
    struct.new $ClosureType_613
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_166
    local.get $lo_clo_166
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_166
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_167
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $runSeqTests (param $check (ref $AnyFn)) ;; exported as "runSeqTests"
  )
  (func $closure_614 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbLength (result i32) ;; exported as "testSbLength"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_168 (ref $ClosureBase_615))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_614
    struct.new $ClosureType_616
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_168
    local.get $lo_clo_168
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    local.get $lo_clo_168
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $closure_617 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_618 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $testSbAppendTwo (result i32) ;; exported as "testSbAppendTwo"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_169 (ref $ClosureBase_615))
    (local $lo_clo_170 (ref $ClosureBase_615))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_617
    struct.new $ClosureType_617
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_169
    local.get $lo_clo_169
    local.get $sb
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_169
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    ref.func $closure_618
    struct.new $ClosureType_618
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_170
    local.get $lo_clo_170
    local.get $sb
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_170
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $closure_619 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbGrow (result i32) ;; exported as "testSbGrow"
    (local $sb (ref $StringBuilder))
    (local $forLoopVar i32)
    (local $lo_clo_171 (ref $ClosureBase_615))
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
        ref.func $closure_619
        struct.new $ClosureType_619
        ref.cast (ref $ClosureBase_615)
        local.set $lo_clo_171
        local.get $lo_clo_171
        local.get $sb
        i32.const 120
        array.new_fixed $WasmStr 1
        call $sbAppend
        local.get $lo_clo_171
        struct.get $ClosureBase_615 0
        call_ref $FuncType_614
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
  (func $closure_620 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_621 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $closure_622 (param $self (ref $AnyFn)) (param $value_2 (ref $StringBuilder))
    local.get $value_2
  )
  (func $closure_623 (param $self (ref $AnyFn)) (param $value_3 (ref $StringBuilder))
    local.get $value_3
  )
  (func $closure_624 (param $self (ref $AnyFn)) (param $value_4 (ref $StringBuilder))
    local.get $value_4
  )
  (func $testSbChained (result i32) ;; exported as "testSbChained"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_172 (ref $ClosureBase_615))
    (local $lo_clo_173 (ref $ClosureBase_615))
    (local $lo_clo_174 (ref $ClosureBase_615))
    (local $lo_clo_175 (ref $ClosureBase_615))
    (local $lo_clo_176 (ref $ClosureBase_615))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_620
    struct.new $ClosureType_620
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_172
    local.get $lo_clo_172
    local.get $sb
    i32.const 97
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_172
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    ref.func $closure_621
    struct.new $ClosureType_621
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_173
    local.get $lo_clo_173
    local.get $sb
    i32.const 98
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_173
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    ref.func $closure_622
    struct.new $ClosureType_622
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_174
    local.get $lo_clo_174
    local.get $sb
    i32.const 99
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_174
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    ref.func $closure_623
    struct.new $ClosureType_623
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_175
    local.get $lo_clo_175
    local.get $sb
    i32.const 100
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_175
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    ref.func $closure_624
    struct.new $ClosureType_624
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_176
    local.get $lo_clo_176
    local.get $sb
    i32.const 101
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_176
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
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
    (local $r (ref $RefCell_48))
    i32.const 5
    struct.new $RefCell_48
    local.set $r
    local.get $r
    local.get $r
    struct.get $RefCell_48 0
    i32.const 1
    i32.add
    struct.set $RefCell_48 0
    local.get $r
    struct.get $RefCell_48 0
  )
  (func $testRefCellBool (result i32) ;; exported as "testRefCellBool"
    (local $r (ref $RefCell_48))
    i32.const 0
    struct.new $RefCell_48
    local.set $r
    local.get $r
    i32.const 1
    struct.set $RefCell_48 0
    local.get $r
    struct.get $RefCell_48 0
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
    (local $parts (ref $GcArray_632))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_632 1
    i32.const 0
    array.get $GcArray_632
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitFirst (result i32) ;; exported as "testStrSplitFirst"
    (local $parts (ref $GcArray_632))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_632 1
    i32.const 0
    array.get $GcArray_632
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 0
    array.get $GcArray_632
    array.len
  )
  (func $testStrSplitSecond (result i32) ;; exported as "testStrSplitSecond"
    (local $parts (ref $GcArray_632))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_632 1
    i32.const 0
    array.get $GcArray_632
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 1
    array.get $GcArray_632
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStrSplitWords (result i32) ;; exported as "testStrSplitWords"
    (local $parts (ref $GcArray_632))
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
    array.new_fixed $GcArray_632 1
    i32.const 0
    array.get $GcArray_632
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitNoDelim (result i32) ;; exported as "testStrSplitNoDelim"
    (local $parts (ref $GcArray_632))
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
    array.new_fixed $GcArray_632 1
    i32.const 0
    array.get $GcArray_632
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitEmpty (result i32) ;; exported as "testStrSplitEmpty"
    (local $parts (ref $GcArray_632))
    array.new_fixed $WasmStr 0
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_632 1
    i32.const 0
    array.get $GcArray_632
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitMultiChar (result i32) ;; exported as "testStrSplitMultiChar"
    (local $parts (ref $GcArray_632))
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
    array.new_fixed $GcArray_632 1
    i32.const 0
    array.get $GcArray_632
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrJoinLen (result i32) ;; exported as "testStrJoinLen"
    (local $parts (ref $GcArray_632))
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
    array.new_fixed $GcArray_632 3
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
    array.new_fixed $GcArray_632 2
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
    array.new_fixed $GcArray_632 1
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
  (func $closure_633 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbToStringLength (result i32) ;; exported as "testSbToStringLength"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_177 (ref $ClosureBase_615))
    (local $s (ref $WasmStr))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_633
    struct.new $ClosureType_633
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_177
    local.get $lo_clo_177
    local.get $sb
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_177
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    local.get $sb
    call $sbToString
    local.set $s
    local.get $s
    array.len
  )
  (func $closure_634 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_635 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $testSbToStringContent (result i32) ;; exported as "testSbToStringContent"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_178 (ref $ClosureBase_615))
    (local $lo_clo_179 (ref $ClosureBase_615))
    (local $s (ref $WasmStr))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_634
    struct.new $ClosureType_634
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_178
    local.get $lo_clo_178
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    local.get $lo_clo_178
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
    ref.func $closure_635
    struct.new $ClosureType_635
    ref.cast (ref $ClosureBase_615)
    local.set $lo_clo_179
    local.get $lo_clo_179
    local.get $sb
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 6
    call $sbAppend
    local.get $lo_clo_179
    struct.get $ClosureBase_615 0
    call_ref $FuncType_614
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
  (func $runAllTests (param $check (ref $AnyFn)) ;; exported as "runAllTests"
    call $runArrayTests
    call $runBitwiseTests
    call $runClosuresTests
    call $runDUTests
    call $runExceptionsTests
    call $runInteropTests
    call $runListTests
    call $runMapTests
    call $runMathTests
    call $runOptionTests
    call $runPrimitivesTests
    call $runPrintfTests
    call $runResultTests
    call $runSeqTests
    call $runSetTests
    call $runStringBuilderTests
    call $runStringsTests
  )
  (func $closure_639 (param $self (ref $AnyFn)) (param $f (ref $AnyFn))
    (local $self_cast (ref $ClosureType_641))
    (local $failed i32)
    (local $passed i32)
    (local $lo_clo_180 (ref $ClosureBase_49))
    local.get $self
    ref.cast (ref $ClosureType_641)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_641 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_641 2
    local.set $passed
    (block
      (block
        (try_table (catch_all 0)
                local.get $f
                ref.cast (ref $ClosureBase_49)
                local.set $lo_clo_180
                local.get $lo_clo_180
                local.get $lo_clo_180
                struct.get $ClosureBase_49 0
                call_ref $FuncType_24
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
  (func $closure_639 (param $self (ref $AnyFn)) (param $name i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_642))
    (local $failed i32)
    (local $passed i32)
    local.get $self
    ref.cast (ref $ClosureType_642)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_642 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_642 2
    local.set $passed
    ref.func $closure_639
    local.get $failed
    local.get $passed
    struct.new $ClosureType_641
  )
  (func $main (param $_arg (ref $GcArray_632)) (result i32) ;; exported as "main"
    (local $passed i32)
    (local $failed i32)
    (local $check (ref $ClosureType_642))
    i32.const 0
    local.set $passed
    i32.const 0
    local.set $failed
    ref.func $closure_639
    local.get $failed
    local.get $passed
    struct.new $ClosureType_642
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
  ;; ── Elem declare (func refs) ────────────────────────
  (elem declare func $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_SpanishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap $QuickTestWasmGc_TestsList_EnglishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap $QuickTestWasmGc_TestsList_SpanishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap $closure_100 $closure_102 $closure_110 $closure_121 $closure_125 $closure_127 $closure_138 $closure_140 $closure_144 $closure_146 $closure_149 $closure_153 $closure_155 $closure_175 $closure_182 $closure_185 $closure_193 $closure_196 $closure_200 $closure_201 $closure_203 $closure_206 $closure_207 $closure_21 $closure_212 $closure_215 $closure_216 $closure_218 $closure_221 $closure_222 $closure_224 $closure_225 $closure_226 $closure_227 $closure_229 $closure_230 $closure_232 $closure_233 $closure_235 $closure_236 $closure_237 $closure_239 $closure_240 $closure_241 $closure_242 $closure_243 $closure_244 $closure_245 $closure_246 $closure_247 $closure_249 $closure_250 $closure_251 $closure_252 $closure_253 $closure_254 $closure_255 $closure_258 $closure_259 $closure_262 $closure_263 $closure_265 $closure_266 $closure_268 $closure_269 $closure_271 $closure_272 $closure_274 $closure_276 $closure_277 $closure_278 $closure_279 $closure_28 $closure_280 $closure_283 $closure_284 $closure_285 $closure_286 $closure_288 $closure_289 $closure_29 $closure_290 $closure_292 $closure_293 $closure_294 $closure_295 $closure_296 $closure_298 $closure_30 $closure_301 $closure_304 $closure_316 $closure_318 $closure_320 $closure_322 $closure_327 $closure_332 $closure_336 $closure_338 $closure_35 $closure_354 $closure_356 $closure_359 $closure_36 $closure_362 $closure_368 $closure_369 $closure_371 $closure_373 $closure_374 $closure_39 $closure_391 $closure_397 $closure_398 $closure_40 $closure_404 $closure_405 $closure_406 $closure_408 $closure_409 $closure_41 $closure_410 $closure_411 $closure_412 $closure_415 $closure_416 $closure_417 $closure_418 $closure_42 $closure_420 $closure_441 $closure_444 $closure_445 $closure_448 $closure_449 $closure_453 $closure_454 $closure_458 $closure_459 $closure_46 $closure_461 $closure_464 $closure_465 $closure_466 $closure_469 $closure_470 $closure_471 $closure_472 $closure_473 $closure_474 $closure_477 $closure_481 $closure_482 $closure_483 $closure_484 $closure_49 $closure_496 $closure_497 $closure_498 $closure_499 $closure_500 $closure_501 $closure_502 $closure_504 $closure_505 $closure_506 $closure_507 $closure_508 $closure_509 $closure_51 $closure_510 $closure_511 $closure_512 $closure_513 $closure_514 $closure_515 $closure_516 $closure_517 $closure_518 $closure_519 $closure_521 $closure_523 $closure_524 $closure_525 $closure_527 $closure_528 $closure_531 $closure_532 $closure_533 $closure_535 $closure_536 $closure_537 $closure_538 $closure_539 $closure_541 $closure_542 $closure_543 $closure_545 $closure_546 $closure_547 $closure_548 $closure_550 $closure_552 $closure_554 $closure_555 $closure_556 $closure_557 $closure_558 $closure_559 $closure_562 $closure_563 $closure_565 $closure_568 $closure_570 $closure_573 $closure_574 $closure_575 $closure_576 $closure_578 $closure_579 $closure_581 $closure_583 $closure_584 $closure_585 $closure_587 $closure_588 $closure_589 $closure_591 $closure_592 $closure_594 $closure_596 $closure_600 $closure_601 $closure_602 $closure_604 $closure_606 $closure_608 $closure_609 $closure_61 $closure_610 $closure_611 $closure_612 $closure_614 $closure_617 $closure_618 $closure_619 $closure_620 $closure_621 $closure_622 $closure_623 $closure_624 $closure_63 $closure_633 $closure_634 $closure_635 $closure_639 $closure_65 $closure_71 $closure_73 $closure_80 $closure_92 $closure_95)
  ;; ── Exports ────────────────────────────────────────
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
  (export "testSbLength" (func $testSbLength))
  (export "testSbAppendTwo" (func $testSbAppendTwo))
  (export "testSbGrow" (func $testSbGrow))
  (export "testSbChained" (func $testSbChained))
  (export "roundTo6" (func $roundTo6))
  (export "runStringBuilderTests" (func $runStringBuilderTests))
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
  (export "runAllTests" (func $runAllTests))
  (export "main" (func $main))
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
