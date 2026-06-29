(module
  ;; ── Types ───────────────────────────────────────────
  (type $AnyFn (sub (struct)))
  (type $WasmStr (array (mut i32)))
  (type $ListBase (sub (struct)))
  (type $StringBuilder (sub (struct (field (mut (ref $WasmStr))) (field (mut i32)) (field (mut i32)))))
  (type $QuickTestWasmGc_TestsExceptions_MyTypedException (sub (struct (field i32))))
  (type $Exception (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_6 (func (param (ref $AnyFn)) (result i32)))
  (type $ClosureBase_7 (sub $AnyFn (struct (field (ref $FuncType_6)))))
  (type $ClosureType_8 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $FuncType_9 (func (param (ref $AnyFn))))
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
  (type $FuncType_25 (func (param (ref $AnyFn)) (param i32) (result i32)))
  (type $ClosureBase_26 (sub $AnyFn (struct (field (ref $FuncType_25)))))
  (type $ClosureType_27 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_28 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_29 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ListCons_30 (sub $ListBase (struct (field i32) (field (ref null $ListBase)))))
  (type $ClosureType_31 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
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
  (type $ClosureBase_49 (sub $AnyFn (struct (field (ref $FuncType_9)))))
  (type $ClosureType_50 (sub $ClosureBase_49 (struct (field (ref $FuncType_9)) (field (ref $RefCell_48)))))
  (type $ClosureType_51 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32) (field i32))))
  (type $ClosureType_52 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $Option_53 (sub (struct (field i32))))
  (type $Option_54 (sub (struct (field (ref null $Option_53)))))
  (type $MapModule_MapNode`2 (sub (struct (field i32))))
  (type $MapModule_MapNode`2#0 (sub $MapModule_MapNode`2 (struct (field i32))))
  (type $MapModule_MapNode`2#1 (sub $MapModule_MapNode`2 (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2)) (field (ref $MapModule_MapNode`2)))))
  (type $MapModule_MapHandle`2 (sub (struct (field (ref $MapModule_MapNode`2)) (field (ref $AnyFn)))))
  (type $MapModule_MapNode`2<i32~i32> (sub (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#0 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#1 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2<i32~i32>)) (field (ref $MapModule_MapNode`2<i32~i32>)))))
  (type $Tuple_62 (sub (struct (field i32) (field i32))))
  (type $ListCons_63 (sub $ListBase (struct (field (ref $Tuple_62)) (field (ref null $ListBase)))))
  (type $ClosureType_64 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_65 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_66 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_67 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_68 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_69 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $QuickTestWasmGc_TestsInterop_EnglishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_71 (func (param (ref eq)) (result i32)))
  (type $vtbl_QuickTestWasmGc_TestsInterop_IGreeter (sub (struct (field (ref $FuncType_71)))))
  (type $box_QuickTestWasmGc_TestsInterop_IGreeter (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsInterop_IGreeter)) (field (ref eq)))))
  (type $QuickTestWasmGc_TestsInterop_SpanishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $ListCons_75 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (field (ref null $ListBase)))))
  (type $FuncType_76 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (result i32)))
  (type $ClosureBase_77 (sub $AnyFn (struct (field (ref $FuncType_76)))))
  (type $ClosureType_78 (sub $ClosureBase_77 (struct (field (ref $FuncType_76)))))
  (type $ClosureType_79 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_80 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsInterop_IntShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsInterop_IntShape#0 (sub $QuickTestWasmGc_TestsInterop_IntShape (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsInterop_IntShape#1 (sub $QuickTestWasmGc_TestsInterop_IntShape (struct (field i32) (field i32) (field i32))))
  (type $vtbl_QuickTestWasmGc_TestsInterop_IShape (sub (struct (field (ref $FuncType_71)))))
  (type $box_QuickTestWasmGc_TestsInterop_IShape (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsInterop_IShape)) (field (ref eq)))))
  (type $ListCons_86 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (field (ref null $ListBase)))))
  (type $FuncType_87 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)))
  (type $ClosureBase_88 (sub $AnyFn (struct (field (ref $FuncType_87)))))
  (type $ClosureType_89 (sub $ClosureBase_88 (struct (field (ref $FuncType_87)))))
  (type $ClosureType_90 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_91 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsInterop_ClassCircle (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsInterop_ClassRect (sub (struct (field i32) (field i32))))
  (type $ClosureType_94 (sub $ClosureBase_88 (struct (field (ref $FuncType_87)))))
  (type $ClosureType_95 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_96 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $SetModule_SetNode`1 (sub (struct (field i32))))
  (type $SetModule_SetNode`1#0 (sub $SetModule_SetNode`1 (struct (field i32))))
  (type $SetModule_SetNode`1#1 (sub $SetModule_SetNode`1 (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1)) (field (ref $SetModule_SetNode`1)))))
  (type $SetModule_SetHandle`1 (sub (struct (field (ref $SetModule_SetNode`1)) (field (ref $AnyFn)))))
  (type $SetModule_SetNode`1<i32> (sub (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#0 (sub $SetModule_SetNode`1<i32> (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#1 (sub $SetModule_SetNode`1<i32> (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $SetModule_SetNode`1<i32>)))))
  (type $FuncType_104 (func (param (ref $AnyFn)) (param i32)))
  (type $ClosureType_105 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_106 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_107 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_108 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $FuncType_109 (func (param (ref $AnyFn)) (param i32) (result (ref $SetModule_SetNode`1<i32>))))
  (type $ClosureBase_110 (sub $AnyFn (struct (field (ref $FuncType_109)))))
  (type $ClosureType_111 (sub $ClosureBase_110 (struct (field (ref $FuncType_109)) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_112 (func (param (ref $AnyFn)) (param (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))))
  (type $ClosureBase_113 (sub $AnyFn (struct (field (ref $FuncType_112)))))
  (type $ClosureType_114 (sub $ClosureBase_113 (struct (field (ref $FuncType_112)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_115 (sub $ClosureBase_110 (struct (field (ref $FuncType_109)) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_116 (sub $ClosureBase_113 (struct (field (ref $FuncType_112)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_117 (func (param (ref $AnyFn)) (param i32) (result (ref $SetModule_SetHandle`1))))
  (type $ClosureBase_118 (sub $AnyFn (struct (field (ref $FuncType_117)))))
  (type $ClosureType_119 (sub $ClosureBase_118 (struct (field (ref $FuncType_117)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_120 (func (param (ref $AnyFn)) (param (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))))
  (type $ClosureBase_121 (sub $AnyFn (struct (field (ref $FuncType_120)))))
  (type $ClosureType_122 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $GcArray_123 (array (mut i32)))
  (type $ClosureType_124 (sub $ClosureBase_118 (struct (field (ref $FuncType_117)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_125 (sub $ClosureBase_121 (struct (field (ref $FuncType_120)))))
  (type $FuncType_126 (func (param (ref $AnyFn)) (param f64) (param f64) (result f64)))
  (type $ClosureBase_127 (sub $AnyFn (struct (field (ref $FuncType_126)))))
  (type $ClosureType_128 (sub $ClosureBase_127 (struct (field (ref $FuncType_126)))))
  (type $ClosureType_129 (sub $ClosureBase_127 (struct (field (ref $FuncType_126)))))
  (type $ClosureType_130 (sub $ClosureBase_127 (struct (field (ref $FuncType_126)))))
  (type $QuickTestWasmGc_TestsMath_GeoShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#0 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#1 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsMath_GeoShape#2 (sub $QuickTestWasmGc_TestsMath_GeoShape (struct (field i32))))
  (type $ClosureType_135 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $FuncType_136 (func (param (ref $AnyFn)) (param i32) (result (ref null $Option_53))))
  (type $ClosureBase_137 (sub $AnyFn (struct (field (ref $FuncType_136)))))
  (type $ClosureType_138 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_139 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_140 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_141 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_142 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_143 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_144 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $GcArray_145 (array (mut f64)))
  (type $ClosureType_146 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_147 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $FuncType_148 (func (param (ref $AnyFn)) (param f64) (result f64)))
  (type $ClosureBase_149 (sub $AnyFn (struct (field (ref $FuncType_148)))))
  (type $ClosureType_150 (sub $ClosureBase_149 (struct (field (ref $FuncType_148)) (field f64))))
  (type $FuncType_151 (func (param (ref $AnyFn)) (param f64) (result (ref $AnyFn))))
  (type $ClosureBase_152 (sub $AnyFn (struct (field (ref $FuncType_151)))))
  (type $ClosureType_153 (sub $ClosureBase_152 (struct (field (ref $FuncType_151)))))
  (type $ClosureType_154 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_155 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_156 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_157 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_158 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_159 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_160 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_161 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_162 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_163 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_164 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_165 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_166 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_167 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_168 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureBase_169 (sub $AnyFn (struct (field (ref $FuncType_104)))))
  (type $ClosureType_170 (sub $ClosureBase_169 (struct (field (ref $FuncType_104)) (field i32))))
  (type $ClosureType_171 (sub $ClosureBase_169 (struct (field (ref $FuncType_104)) (field i32) (field i32))))
  (type $ClosureType_172 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_173 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_174 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_175 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $FuncType_176 (func (param (ref $AnyFn)) (param i32) (param i32) (result i32)))
  (type $ClosureBase_177 (sub $AnyFn (struct (field (ref $FuncType_176)))))
  (type $ClosureType_178 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_179 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_180 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_181 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_182 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_183 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_184 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_185 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_186 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_187 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_188 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_189 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_190 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_191 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_192 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_193 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $GcArray_194 (array (mut (ref $Tuple_62))))
  (type $ClosureType_195 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $FuncType_196 (func (param (ref $AnyFn)) (param (ref $GcArray_123)) (result i32)))
  (type $ClosureBase_197 (sub $AnyFn (struct (field (ref $FuncType_196)))))
  (type $ClosureType_198 (sub $ClosureBase_197 (struct (field (ref $FuncType_196)))))
  (type $ClosureType_199 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_200 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_201 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_202 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_203 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_204 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_205 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_206 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_207 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $FuncType_208 (func (param (ref $AnyFn)) (param i32) (result (ref $GcArray_123))))
  (type $ClosureBase_209 (sub $AnyFn (struct (field (ref $FuncType_208)))))
  (type $ClosureType_210 (sub $ClosureBase_209 (struct (field (ref $FuncType_208)))))
  (type $ClosureType_211 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_212 (sub $ClosureBase_209 (struct (field (ref $FuncType_208)))))
  (type $ClosureType_213 (sub $ClosureBase_209 (struct (field (ref $FuncType_208)))))
  (type $ClosureType_214 (sub $ClosureBase_209 (struct (field (ref $FuncType_208)))))
  (type $ResizeArray_215 (sub (struct (field (mut (ref null $GcArray_123))) (field (mut i32)))))
  (type $Tuple_216 (sub (struct (field (ref $GcArray_123)) (field (ref $GcArray_123)))))
  (type $ClosureType_217 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_218 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_219 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $QuickTestWasmGc_TestsPrimitives_Point (sub (struct (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsPrimitives_Counter (sub (struct (field (mut i32)))))
  (type $QuickTestWasmGc_TestsPrimitives_Rect (sub (struct (field (ref $QuickTestWasmGc_TestsPrimitives_Point)) (field (ref $QuickTestWasmGc_TestsPrimitives_Point)))))
  (type $Tuple_223 (sub (struct (field f64) (field f64))))
  (type $Tuple_224 (sub (struct (field i32) (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsPrimitives_SWItem (sub (struct (field i32))))
  (type $ListCons_226 (sub $ListBase (struct (field (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (field (ref null $ListBase)))))
  (type $FuncType_227 (func (param (ref $AnyFn)) (param (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (result i32)))
  (type $ClosureBase_228 (sub $AnyFn (struct (field (ref $FuncType_227)))))
  (type $ClosureType_229 (sub $ClosureBase_228 (struct (field (ref $FuncType_227)))))
  (type $ClosureType_230 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $GcArray_231 (array (mut (ref $QuickTestWasmGc_TestsPrimitives_SWItem))))
  (type $FuncType_232 (func (param (ref $AnyFn)) (param (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))))
  (type $ClosureBase_233 (sub $AnyFn (struct (field (ref $FuncType_232)))))
  (type $ClosureType_234 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_235 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_236 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_237 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $FuncType_238 (func (param (ref $AnyFn)) (param (ref null $Option_53)) (result i32)))
  (type $ClosureBase_239 (sub $AnyFn (struct (field (ref $FuncType_238)))))
  (type $ClosureType_240 (sub $ClosureBase_239 (struct (field (ref $FuncType_238)) (field i32))))
  (type $ClosureType_241 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_242 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_243 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_244 (sub $ClosureBase_239 (struct (field (ref $FuncType_238)) (field i32))))
  (type $ClosureType_245 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_246 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_247 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_248 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_249 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_250 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_251 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_252 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_253 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_254 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_255 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_256 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_257 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_258 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_259 (sub $ClosureBase_239 (struct (field (ref $FuncType_238)) (field i32))))
  (type $ClosureType_260 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_261 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_262 (sub $ClosureBase_239 (struct (field (ref $FuncType_238)) (field i32))))
  (type $ClosureType_263 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_264 (sub $ClosureBase_239 (struct (field (ref $FuncType_238)) (field i32))))
  (type $ClosureType_265 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_266 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32) (field i32))))
  (type $ClosureType_267 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $FuncType_268 (func (param (ref $AnyFn)) (param (ref $MapModule_MapHandle`2)) (result i32)))
  (type $ClosureType_269 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_270 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_271 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_272 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_273 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_274 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_275 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_276 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_277 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_278 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_279 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_280 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_281 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_282 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_283 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_284 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_285 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_286 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_287 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_288 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_289 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_290 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_291 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_292 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_293 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_294 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_295 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_296 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_297 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_298 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_299 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_300 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_301 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_302 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_303 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_304 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_305 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_306 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_307 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_308 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_309 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_310 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_311 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_312 (sub $ClosureBase_239 (struct (field (ref $FuncType_238)) (field i32))))
  (type $ClosureType_313 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_314 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_315 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_316 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_317 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field (ref $WasmStr)))))
  (type $ClosureType_324 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $FuncType_325 (func (param (ref $AnyFn)) (param i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))))
  (type $ClosureBase_326 (sub $AnyFn (struct (field (ref $FuncType_325)))))
  (type $ClosureType_327 (sub $ClosureBase_326 (struct (field (ref $FuncType_325)))))
  (type $ClosureType_328 (sub $ClosureBase_326 (struct (field (ref $FuncType_325)))))
  (type $FuncType_329 (func (param (ref $AnyFn)) (param i32) (result (ref $WasmStr))))
  (type $ClosureBase_330 (sub $AnyFn (struct (field (ref $FuncType_329)))))
  (type $ClosureType_331 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_332 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $FuncType_333 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureBase_334 (sub $AnyFn (struct (field (ref $FuncType_333)))))
  (type $ClosureType_335 (sub $ClosureBase_334 (struct (field (ref $FuncType_333)) (field (ref $AnyFn)))))
  (type $ClosureType_336 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_337 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_338 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $FuncType_339 (func (param (ref $AnyFn)) (param i32) (param i32) (result (ref $WasmStr))))
  (type $Tuple_340 (sub (struct (field (ref $WasmStr)) (field (ref $WasmStr)))))
  (type $FuncType_341 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (result (ref $AnyFn))))
  (type $ClosureType_342 (sub $ClosureBase_334 (struct (field (ref $FuncType_333)) (field (ref $AnyFn)))))
  (type $ClosureBase_343 (sub $AnyFn (struct (field (ref $FuncType_341)))))
  (type $ClosureType_344 (sub $ClosureBase_343 (struct (field (ref $FuncType_341)) (field (ref $AnyFn)))))
  (type $FuncType_345 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureType_346 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_347 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $Tuple_348 (sub (struct (field i32) (field (ref $WasmStr)))))
  (type $ClosureType_349 (sub $ClosureBase_334 (struct (field (ref $FuncType_333)) (field (ref $AnyFn)))))
  (type $ClosureType_350 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $FuncType_351 (func (param (ref $AnyFn)) (param i32) (param (ref $WasmStr)) (result (ref $WasmStr))))
  (type $ClosureType_352 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_353 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $FuncType_354 (func (param (ref $AnyFn)) (param f64) (result (ref $WasmStr))))
  (type $ClosureBase_355 (sub $AnyFn (struct (field (ref $FuncType_354)))))
  (type $ClosureType_356 (sub $ClosureBase_355 (struct (field (ref $FuncType_354)) (field (ref $AnyFn)))))
  (type $ClosureType_357 (sub $ClosureBase_355 (struct (field (ref $FuncType_354)) (field (ref $AnyFn)))))
  (type $ClosureType_358 (sub $ClosureBase_355 (struct (field (ref $FuncType_354)) (field (ref $AnyFn)))))
  (type $ClosureType_359 (sub $ClosureBase_355 (struct (field (ref $FuncType_354)) (field (ref $AnyFn)))))
  (type $ClosureType_360 (sub $ClosureBase_355 (struct (field (ref $FuncType_354)) (field (ref $AnyFn)))))
  (type $ClosureType_361 (sub $ClosureBase_169 (struct (field (ref $FuncType_104)) (field (ref $AnyFn)))))
  (type $FuncType_362 (func (param (ref $AnyFn)) (param (ref $WasmStr))))
  (type $ClosureBase_363 (sub $AnyFn (struct (field (ref $FuncType_362)))))
  (type $ClosureType_364 (sub $ClosureBase_363 (struct (field (ref $FuncType_362)) (field (ref $AnyFn)))))
  (type $ClosureType_365 (sub $ClosureBase_169 (struct (field (ref $FuncType_104)) (field (ref $AnyFn)))))
  (type $ClosureType_366 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $ClosureType_367 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field (ref $AnyFn)))))
  (type $FuncType_368 (func (param (ref $AnyFn)) (param i32) (param i32) (param i32)))
  (type $ClosureType_369 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_370 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_371 (sub $ClosureBase_334 (struct (field (ref $FuncType_333)) (field (ref $AnyFn)))))
  (type $ClosureType_372 (sub $ClosureBase_330 (struct (field (ref $FuncType_329)) (field (ref $AnyFn)))))
  (type $ClosureType_373 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_374 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_375 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_376 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_377 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_378 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_379 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_380 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_381 (sub $ClosureBase_169 (struct (field (ref $FuncType_104)) (field i32))))
  (type $ClosureType_382 (sub $ClosureBase_169 (struct (field (ref $FuncType_104)) (field i32))))
  (type $ClosureType_383 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_384 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_385 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_386 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_387 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_388 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_389 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_390 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_391 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_392 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_393 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_394 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_395 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_396 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_397 (sub $ClosureBase_169 (struct (field (ref $FuncType_104)) (field i32) (field i32))))
  (type $ClosureType_398 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $FuncType_399 (func (param (ref $AnyFn)) (param i32) (result (ref null $ListBase))))
  (type $ClosureBase_400 (sub $AnyFn (struct (field (ref $FuncType_399)))))
  (type $ClosureType_401 (sub $ClosureBase_400 (struct (field (ref $FuncType_399)))))
  (type $ClosureType_402 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_403 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_404 (sub $ClosureBase_400 (struct (field (ref $FuncType_399)))))
  (type $ClosureType_405 (sub $ClosureBase_400 (struct (field (ref $FuncType_399)))))
  (type $ClosureType_406 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_407 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_408 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_409 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_410 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_411 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field i32))))
  (type $ClosureType_412 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_413 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_414 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_415 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_416 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_417 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_418 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_419 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_420 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_421 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_422 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_423 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_424 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_425 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_426 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_427 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_428 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_429 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_430 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_431 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_432 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_433 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_434 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_435 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_436 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_437 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_438 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $QuickTestWasmGc_TestsList_EnglishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $vtbl_QuickTestWasmGc_TestsList_IGreeter (sub (struct (field (ref $FuncType_71)))))
  (type $box_QuickTestWasmGc_TestsList_IGreeter (sub (struct (field (ref $vtbl_QuickTestWasmGc_TestsList_IGreeter)) (field (ref eq)))))
  (type $QuickTestWasmGc_TestsList_SpanishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $ClosureType_443 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_444 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_445 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_446 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_447 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_448 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_449 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_450 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $Tuple_451 (sub (struct (field (ref null $ListBase)) (field (ref null $ListBase)))))
  (type $ClosureType_452 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_453 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_454 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_455 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_456 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_457 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_458 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_459 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_460 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ListCons_461 (sub $ListBase (struct (field (ref $WasmStr)) (field (ref null $ListBase)))))
  (type $FuncType_462 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $WasmStr)) (result i32)))
  (type $ClosureBase_463 (sub $AnyFn (struct (field (ref $FuncType_462)))))
  (type $ClosureType_464 (sub $ClosureBase_463 (struct (field (ref $FuncType_462)))))
  (type $GcArray_465 (array (mut (ref null $WasmStr))))
  (type $ClosureType_466 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_467 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_468 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_469 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $Tuple_470 (sub (struct (field i32) (field (ref null $ListBase)))))
  (type $ListCons_471 (sub $ListBase (struct (field (ref $Tuple_470)) (field (ref null $ListBase)))))
  (type $ClosureType_472 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_473 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_474 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $QuickTestWasmGc_TestsList_MathExpr (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsList_MathExpr#0 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsList_MathExpr#1 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsList_MathExpr)) (field (ref $QuickTestWasmGc_TestsList_MathExpr)))))
  (type $QuickTestWasmGc_TestsList_MathExpr#2 (sub $QuickTestWasmGc_TestsList_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_TestsList_MathExpr)) (field (ref $QuickTestWasmGc_TestsList_MathExpr)))))
  (type $ClosureType_479 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_480 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_481 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_482 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $ClosureType_483 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_484 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_485 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_486 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_487 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_488 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_489 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_490 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_491 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_492 (sub $ClosureBase_233 (struct (field (ref $FuncType_232)) (field i32) (field i32))))
  (type $ClosureType_493 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_494 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_495 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $FuncType_496 (func (param (ref $AnyFn)) (param (ref $StringBuilder))))
  (type $ClosureBase_497 (sub $AnyFn (struct (field (ref $FuncType_496)))))
  (type $ClosureType_498 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_499 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_500 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_501 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_502 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_503 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_504 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_505 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_506 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_507 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_508 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_509 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_510 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_511 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_512 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_513 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_514 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_515 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_516 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_517 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_518 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_519 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_520 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_521 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_522 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_523 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_524 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $FuncType_525 (func (param (ref $AnyFn)) (param (ref $Tuple_62)) (result i32)))
  (type $ClosureBase_526 (sub $AnyFn (struct (field (ref $FuncType_525)))))
  (type $ClosureType_527 (sub $ClosureBase_526 (struct (field (ref $FuncType_525)))))
  (type $ClosureType_528 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field (ref $AnyFn)))))
  (type $ClosureType_529 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_530 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_531 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_532 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_533 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_534 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_535 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_536 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_537 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_538 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $ClosureType_539 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_540 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_541 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_542 (sub $ClosureBase_400 (struct (field (ref $FuncType_399)))))
  (type $ClosureType_543 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_544 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_545 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_546 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_547 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_548 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_549 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_550 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_551 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)) (field (ref $AnyFn)))))
  (type $ClosureType_552 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_553 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_554 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_555 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_556 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_557 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_558 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $ClosureType_559 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_560 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_561 (sub $ClosureBase_7 (struct (field (ref $FuncType_6)))))
  (type $ClosureType_562 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_563 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field i32))))
  (type $ClosureType_564 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field i32))))
  (type $ClosureType_565 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $ClosureType_566 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_567 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_568 (sub $ClosureBase_37 (struct (field (ref $FuncType_36)) (field (ref $AnyFn)))))
  (type $GcArray_569 (array (mut (ref $WasmStr))))
  (type $FuncType_570 (func (param (ref $AnyFn)) (param (ref $AnyFn))))
  (type $ClosureBase_571 (sub $AnyFn (struct (field (ref $FuncType_570)))))
  (type $ClosureType_572 (sub $ClosureBase_571 (struct (field (ref $FuncType_570)) (field i32) (field i32))))
  (type $ClosureType_573 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32) (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Shape (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Shape#0 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Shape#1 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Shape#2 (sub $QuickTestWasmGc_TestsStrings_Shape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_TestsStrings_Tree (sub (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Tree#0 (sub $QuickTestWasmGc_TestsStrings_Tree (struct (field i32))))
  (type $QuickTestWasmGc_TestsStrings_Tree#1 (sub $QuickTestWasmGc_TestsStrings_Tree (struct (field i32) (field (ref $QuickTestWasmGc_TestsStrings_Tree)) (field (ref $QuickTestWasmGc_TestsStrings_Tree)) (field i32))))
  (type $ClosureType_581 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_582 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $ClosureType_583 (sub $ClosureBase_497 (struct (field (ref $FuncType_496)))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#0 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#1 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $ClosureType_587 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_588 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_589 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_590 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_591 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_592 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_593 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_594 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_595 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_596 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_597 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_598 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_599 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_600 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_601 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_602 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_603 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_604 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_605 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_606 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_607 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_608 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_609 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_610 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)))))
  (type $ClosureType_611 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_612 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_613 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_614 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_615 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $ClosureType_616 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32) (field i32))))
  (type $ClosureType_617 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)) (field i32))))
  (type $ClosureType_618 (sub $ClosureBase_177 (struct (field (ref $FuncType_176)))))
  (type $FuncType_619 (func (param (ref $AnyFn)) (param (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))))
  (type $ClosureBase_620 (sub $AnyFn (struct (field (ref $FuncType_619)))))
  (type $ClosureType_621 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_622 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_623 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_624 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_625 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_626 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_627 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_628 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_629 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_630 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_631 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_632 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_633 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_634 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_635 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_636 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_637 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_638 (sub $ClosureBase_620 (struct (field (ref $FuncType_619)) (field i32))))
  (type $ClosureType_639 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_640 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureType_641 (sub $ClosureBase_26 (struct (field (ref $FuncType_25)) (field i32))))
  (type $ClosureType_642 (sub $ClosureBase_44 (struct (field (ref $FuncType_43)))))
  (type $ClosureBase_643 (sub $AnyFn (struct (field (ref $FuncType_268)))))
  (type $ClosureBase_644 (sub $AnyFn (struct (field (ref $FuncType_368)))))
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
  (func $strSplit (param $ssp_src (ref $WasmStr)) (param $ssp_del (ref $WasmStr)) (result (ref $GcArray_569))
    (local $ssp_dl i32)
    (local $ssp_pos i32)
    (local $ssp_cnt i32)
    (local $ssp_j i32)
    (local $ssp_arr (ref $GcArray_569))
    (local $ssp_idx i32)
    local.get $ssp_del
    array.len
    local.set $ssp_dl
    local.get $ssp_dl
    i32.const 0
    i32.eq
    if (result (ref $GcArray_569))
      local.get $ssp_src
      array.new_fixed $GcArray_569 1
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
      array.new $GcArray_569
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
            array.set $GcArray_569
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
      array.set $GcArray_569
      local.get $ssp_arr
    end
  )
  (func $strJoin (param $sj_sep (ref $WasmStr)) (param $sj_arr (ref $GcArray_569)) (result (ref $WasmStr))
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
        array.get $GcArray_569
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
              array.get $GcArray_569
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
  (func $closure_6 (param $self (ref $AnyFn)) (result i32)
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
    (local $f (ref $ClosureType_8))
    (local $lo_clo_1 (ref $ClosureBase_49))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                ref.func $closure_6
                struct.new $ClosureType_8
                local.set $f
                local.get $f
                ref.cast (ref $ClosureBase_49)
                local.set $lo_clo_1
                local.get $lo_clo_1
                local.get $lo_clo_1
                struct.get $ClosureBase_49 0
                call_ref $FuncType_9
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
  (func $equals_10 (param $eq_a (ref $QuickTestWasmGc_TestsDU_Shape)) (param $eq_b (ref $QuickTestWasmGc_TestsDU_Shape)) (result i32)
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
    call $equals_10
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
    call $equals_10
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
    call $equals_10
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $runDUTests (param $check (ref $AnyFn)) ;; exported as "runDUTests"
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
    call_ref $FuncType_9
    local.get $increment
    ref.cast (ref $ClosureBase_49)
    local.set $lo_clo_14
    local.get $lo_clo_14
    local.get $lo_clo_14
    struct.get $ClosureBase_49 0
    call_ref $FuncType_9
    local.get $increment
    ref.cast (ref $ClosureBase_49)
    local.set $lo_clo_15
    local.get $lo_clo_15
    local.get $lo_clo_15
    struct.get $ClosureBase_49 0
    call_ref $FuncType_9
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
    (local $lo_clo_18 (ref $ClosureBase_26))
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_18
    local.get $lo_clo_18
    local.get $x
    local.get $lo_clo_18
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
    (local $lo_clo_20 (ref $ClosureBase_26))
    (local $lo_clo_19 (ref $ClosureBase_26))
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_20
    local.get $lo_clo_20
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_19
    local.get $lo_clo_19
    local.get $x
    local.get $lo_clo_19
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $lo_clo_20
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $makeMultiplier (param $n i32) (param $x i32) (result i32) ;; exported as "makeMultiplier"
    local.get $x
    local.get $n
    i32.mul
  )
  (func $optionOrDefault (param $opt (ref null $Option_53)) (param $def i32) (result i32) ;; exported as "optionOrDefault"
    local.get $opt
    ref.is_null
    if (result i32)
      local.get $def
    else
      local.get $opt
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $optionDouble (param $opt (ref null $Option_53)) (result i32) ;; exported as "optionDouble"
    (local $v i32)
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $opt
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
      local.set $v
      local.get $v
      i32.const 1
      i32.shl
    end
  )
  (func $optionIsSome (param $opt (ref null $Option_53)) (result i32) ;; exported as "optionIsSome"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
  )
  (func $optionIsNone (param $opt (ref null $Option_53)) (result i32) ;; exported as "optionIsNone"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $optionNested (param $v i32) (result i32) ;; exported as "optionNested"
    (local $outer (ref null $Option_54))
    (local $inner (ref null $Option_53))
    local.get $v
    struct.new $Option_53
    struct.new $Option_54
    local.set $outer
    local.get $outer
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $outer
      ref.cast (ref $Option_54)
      struct.get $Option_54 0
      local.set $inner
      local.get $inner
      ref.is_null
      if (result i32)
        i32.const -2
      else
        local.get $inner
        ref.cast (ref $Option_53)
        struct.get $Option_53 0
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
  (func $nodeTryFind_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_53))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_53))
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
      if (result (ref null $Option_53))
        local.get $key
        local.get $l
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_53))
          local.get $key
          local.get $r
          call $nodeTryFind_i32~i32
        else
          local.get $v
          struct.new $Option_53
        end
      end
    else
      ref.null $Option_53
    end
  )
  (func $Map_nodeTryFind (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_53))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $c i32)
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_53))
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
      if (result (ref null $Option_53))
        local.get $key
        local.get $l
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_53))
          local.get $key
          local.get $r
          call $nodeTryFind_i32~i32
        else
          local.get $v
          struct.new $Option_53
        end
      end
    else
      ref.null $Option_53
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
      struct.new $Tuple_62
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_63
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
      struct.new $Tuple_62
      local.get $acc
      local.get $r
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_63
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
  (func $Map_tryFind (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_53))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeTryFind_i32~i32
  )
  (func $tryFind_i32~i32 (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_53))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeTryFind_i32~i32
  )
  (func $Map_find (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    (local $matchValue (ref null $Option_53))
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
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
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
  (func $closure_64 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_64))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_64)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_64 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_64 (param $self (ref $AnyFn)) (param $_arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_65))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_65)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_65 1
    local.set $n
    ref.func $closure_64
    local.get $n
    struct.new $ClosureType_64
  )
  (func $closure_64 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_64
    local.get $n
    struct.new $ClosureType_65
  )
  (func $closure_67 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_67))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_67)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_67 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_67 (param $self (ref $AnyFn)) (param $_arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_68))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_68)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_68 1
    local.set $n
    ref.func $closure_67
    local.get $n
    struct.new $ClosureType_67
  )
  (func $closure_67 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_67
    local.get $n
    struct.new $ClosureType_68
  )
  (func $Map_count (param $m (ref $MapModule_MapHandle`2)) (result i32)
    ref.func $closure_67
    struct.new $ClosureType_69
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
      ref.cast (ref $ListCons_63)
      struct.get $ListCons_63 0
      struct.get $Tuple_62 1
      local.set $v
      local.get $pairs
      ref.cast (ref $ListCons_63)
      struct.get $ListCons_63 1
      local.set $rest
      local.get $pairs
      ref.cast (ref $ListCons_63)
      struct.get $ListCons_63 0
      struct.get $Tuple_62 0
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
      ref.cast (ref $ListCons_63)
      struct.get $ListCons_63 0
      struct.get $Tuple_62 1
      local.set $v
      local.get $pairs
      ref.cast (ref $ListCons_63)
      struct.get $ListCons_63 1
      local.set $rest
      local.get $pairs
      ref.cast (ref $ListCons_63)
      struct.get $ListCons_63 0
      struct.get $Tuple_62 0
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
    call_ref $FuncType_71
  )
  (func $closure_76 (param $self (ref $AnyFn)) (param $g (ref $box_QuickTestWasmGc_TestsInterop_IGreeter)) (result i32)
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 1
    local.get $g
    struct.get $box_QuickTestWasmGc_TestsInterop_IGreeter 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IGreeter 0
    call_ref $FuncType_71
  )
  (func $closure_79 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_79 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testInterfacePolymorphism (result i32) ;; exported as "testInterfacePolymorphism"
    (local $greeters (ref null $ListBase))
    (local $lo_clo_21 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_78))
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
    struct.new $ListCons_75
    struct.new $ListCons_75
    local.set $greeters
    ref.func $closure_76
    struct.new $ClosureType_78
    local.set $projection
    ref.func $closure_79
    local.get $projection
    struct.new $ClosureType_80
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_21
    local.get $lo_clo_21
    local.get $greeters
    local.get $lo_clo_21
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
    call_ref $FuncType_71
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
    call_ref $FuncType_71
  )
  (func $closure_87 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_71
  )
  (func $closure_90 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_90 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testDuInterfacePoly (result i32) ;; exported as "testDuInterfacePoly"
    (local $shapes (ref null $ListBase))
    (local $lo_clo_22 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_89))
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
    struct.new $ListCons_86
    struct.new $ListCons_86
    local.set $shapes
    ref.func $closure_87
    struct.new $ClosureType_89
    local.set $projection
    ref.func $closure_90
    local.get $projection
    struct.new $ClosureType_91
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_22
    local.get $lo_clo_22
    local.get $shapes
    local.get $lo_clo_22
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
    call_ref $FuncType_71
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
    call_ref $FuncType_71
  )
  (func $closure_94 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_TestsInterop_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_TestsInterop_IShape 0
    struct.get $vtbl_QuickTestWasmGc_TestsInterop_IShape 0
    call_ref $FuncType_71
  )
  (func $closure_95 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_95 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
  )
  (func $testMixedShapes (result i32) ;; exported as "testMixedShapes"
    (local $shapes (ref null $ListBase))
    (local $lo_clo_23 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_94))
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
    struct.new $ListCons_86
    struct.new $ListCons_86
    struct.new $ListCons_86
    local.set $shapes
    ref.func $closure_94
    struct.new $ClosureType_94
    local.set $projection
    ref.func $closure_95
    local.get $projection
    struct.new $ClosureType_96
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_23
    local.get $lo_clo_23
    local.get $shapes
    local.get $lo_clo_23
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $runInteropTests (param $check (ref $AnyFn)) ;; exported as "runInteropTests"
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
    (local $lo_clo_24 (ref $ClosureBase_169))
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
      ref.cast (ref $ClosureBase_169)
      local.set $lo_clo_24
      local.get $lo_clo_24
      local.get $v
      local.get $lo_clo_24
      struct.get $ClosureBase_169 0
      call_ref $FuncType_104
      local.get $action
      local.get $r
      call $nodeIter_i32
    end
  )
  (func $Set_nodeIter (param $action (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_25 (ref $ClosureBase_169))
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
      ref.cast (ref $ClosureBase_169)
      local.set $lo_clo_25
      local.get $lo_clo_25
      local.get $v
      local.get $lo_clo_25
      struct.get $ClosureBase_169 0
      call_ref $FuncType_104
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
    (local $lo_clo_26 (ref $ClosureBase_26))
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
      local.set $lo_clo_26
      local.get $lo_clo_26
      local.get $v
      local.get $lo_clo_26
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
    (local $lo_clo_27 (ref $ClosureBase_26))
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
      local.set $lo_clo_27
      local.get $lo_clo_27
      local.get $v
      local.get $lo_clo_27
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
    (local $lo_clo_28 (ref $ClosureBase_26))
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
      local.set $lo_clo_28
      local.get $lo_clo_28
      local.get $v
      local.get $lo_clo_28
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
    (local $lo_clo_29 (ref $ClosureBase_26))
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
      local.set $lo_clo_29
      local.get $lo_clo_29
      local.get $v
      local.get $lo_clo_29
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
    (local $lo_clo_30 (ref $ClosureBase_26))
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
      local.set $lo_clo_30
      local.get $lo_clo_30
      local.get $v
      local.get $lo_clo_30
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
    (local $lo_clo_31 (ref $ClosureBase_26))
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
      local.set $lo_clo_31
      local.get $lo_clo_31
      local.get $v
      local.get $lo_clo_31
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
  (func $closure_105 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    (local $self_cast (ref $ClosureType_105))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_105)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_105 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_105 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_105
    local.get $n
    struct.new $ClosureType_105
  )
  (func $closure_107 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    (local $self_cast (ref $ClosureType_107))
    (local $n i32)
    local.get $self
    ref.cast (ref $ClosureType_107)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_107 1
    local.set $n
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_107 (param $self (ref $AnyFn)) (param $n i32) (result (ref $AnyFn))
    ref.func $closure_107
    local.get $n
    struct.new $ClosureType_107
  )
  (func $Set_count (param $s (ref $SetModule_SetHandle`1)) (result i32)
    ref.func $closure_107
    struct.new $ClosureType_108
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
  (func $closure_109 (param $self (ref $AnyFn)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_111))
    (local $acc (ref $SetModule_SetNode`1<i32>))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_32 (ref $ClosureBase_26))
    local.get $self
    ref.cast (ref $ClosureType_111)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_111 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_111 2
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_111 3
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_32
    local.get $lo_clo_32
    local.get $v
    local.get $lo_clo_32
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $acc
    call $nodeAdd_i32
  )
  (func $closure_109 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_114))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_114)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_114 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_114 2
    local.set $s
    ref.func $closure_109
    local.get $acc
    local.get $mapping
    local.get $s
    struct.new $ClosureType_111
  )
  (func $closure_115 (param $self (ref $AnyFn)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_115))
    (local $acc (ref $SetModule_SetNode`1<i32>))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_33 (ref $ClosureBase_26))
    local.get $self
    ref.cast (ref $ClosureType_115)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_115 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_115 2
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_115 3
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_33
    local.get $lo_clo_33
    local.get $v
    local.get $lo_clo_33
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $acc
    call $nodeAdd_i32
  )
  (func $closure_115 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_116))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_116)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_116 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_116 2
    local.set $s
    ref.func $closure_115
    local.get $acc
    local.get $mapping
    local.get $s
    struct.new $ClosureType_115
  )
  (func $nodeFold_ref101~i32 (param $folder (ref $AnyFn)) (param $state (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
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
      call $nodeFold_ref101~i32
      local.set $s1
      local.get $s2
      local.get $r
      call $nodeFold_ref101~i32
    else
      local.get $state
    end
  )
  (func $Set_map (param $mapping (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $mapped (ref $SetModule_SetNode`1<i32>))
    ref.func $closure_115
    local.get $mapping
    local.get $s
    struct.new $ClosureType_116
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeFold_ref101~i32
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
  (func $closure_117 (param $self (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_119))
    (local $acc (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_119)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_119 1
    local.set $acc
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $closure_117 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))
    ref.func $closure_117
    local.get $acc
    struct.new $ClosureType_119
  )
  (func $empty_i32 (param $cmp (ref $AnyFn)) (result (ref $SetModule_SetHandle`1))
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_ofList (param $cmp (ref $AnyFn)) (param $xs (ref null $ListBase)) (result (ref $SetModule_SetHandle`1))
    (local $w25 (ref null $ListBase))
    (local $w26 (ref $SetModule_SetHandle`1))
    (local $x i32)
    local.get $xs
    local.set $w25
    call $empty_i32
    local.set $w26
    block $while_27_exit
      loop $while_27_lp
        local.get $w25
        ref.is_null
        i32.eqz
        if
          local.get $w25
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w26
          call $add_i32
          local.set $w26
          local.get $w25
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w25
          br $while_27_lp
        else
          br $while_27_exit
        end
      end
    end
    local.get $w26
  )
  (func $closure_124 (param $self (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_124))
    (local $acc (ref $SetModule_SetHandle`1))
    local.get $self
    ref.cast (ref $ClosureType_124)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_124 1
    local.set $acc
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $closure_124 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (result (ref $AnyFn))
    ref.func $closure_124
    local.get $acc
    struct.new $ClosureType_124
  )
  (func $Set_ofArray (param $cmp (ref $AnyFn)) (param $xs (ref $GcArray_123)) (result (ref $SetModule_SetHandle`1))
    (local $w30 i32)
    (local $w31 (ref $SetModule_SetHandle`1))
    (local $w32 i32)
    (local $x i32)
    local.get $xs
    array.len
    local.set $w30
    call $empty_i32
    local.set $w31
    i32.const 0
    local.set $w32
    block $while_33_exit
      loop $while_33_lp
        local.get $w32
        local.get $w30
        i32.lt_s
        if
          local.get $xs
          local.get $w32
          array.get $GcArray_123
          local.set $x
          local.get $x
          local.get $w31
          call $add_i32
          local.set $w31
          local.get $w32
          i32.const 1
          i32.add
          local.set $w32
          br $while_33_lp
        else
          br $while_33_exit
        end
      end
    end
    local.get $w31
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
  (func $closure_126 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_2_10 (result i32) ;; exported as "testPowF64_2_10"
    f64.const 2
    f64.const 10
    ref.func $closure_126
    struct.new $ClosureType_128
    call_ref $ClosureType_128
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_129 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_zero (result i32) ;; exported as "testPowF64_zero"
    f64.const 3
    f64.const 0
    ref.func $closure_129
    struct.new $ClosureType_129
    call_ref $ClosureType_129
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_130 (param $self (ref $AnyFn)) (param $arg0_ f64) (param $arg1_ f64) (result f64)
    local.get $arg0_
    local.get $arg1_
    call $powF64
  )
  (func $testPowF64_cube (result i32) ;; exported as "testPowF64_cube"
    f64.const 5
    f64.const 3
    ref.func $closure_130
    struct.new $ClosureType_130
    call_ref $ClosureType_130
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
  (func $testOptionSome (param $v i32) (param $def i32) (result i32) ;; exported as "testOptionSome"
    local.get $v
    struct.new $Option_53
    local.get $def
    return_call $optionOrDefault
  )
  (func $testOptionNone (param $def i32) (result i32) ;; exported as "testOptionNone"
    ref.null $Option_53
    local.get $def
    return_call $optionOrDefault
  )
  (func $testOptionDoubleSome (param $v i32) (result i32) ;; exported as "testOptionDoubleSome"
    local.get $v
    struct.new $Option_53
    return_call $optionDouble
  )
  (func $testOptionDoubleNone (result i32) ;; exported as "testOptionDoubleNone"
    ref.null $Option_53
    return_call $optionDouble
  )
  (func $testOptionIsSome (param $v i32) (result i32) ;; exported as "testOptionIsSome"
    local.get $v
    struct.new $Option_53
    call $optionIsSome
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionIsNone (result i32) ;; exported as "testOptionIsNone"
    ref.null $Option_53
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
    (local $lo_clo_34 (ref $ClosureBase_26))
    local.get $f
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_34
    local.get $lo_clo_34
    local.get $x
    local.get $lo_clo_34
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $doubleVal (param $x i32) (result i32) ;; exported as "doubleVal"
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_135 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 3
    i32.mul
  )
  (func $testOptionMap (result i32) ;; exported as "testOptionMap"
    (local $x (ref null $Option_53))
    (local $y (ref null $Option_53))
    (local $v i32)
    i32.const 5
    struct.new $Option_53
    local.set $x
    local.get $x
    ref.is_null
    if (result (ref null $Option_53))
      local.get $x
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
      local.set $v
      local.get $v
      i32.const 3
      i32.mul
      struct.new $Option_53
    else
      ref.null $Option_53
    end
    local.set $y
    local.get $y
    ref.is_null
    if (result i32)
      local.get $y
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      i32.const 0
    end
  )
  (func $closure_136 (param $self (ref $AnyFn)) (param $v i32) (result (ref null $Option_53))
    local.get $v
    i32.const 0
    i32.gt_s
    if (result (ref null $Option_53))
      local.get $v
      i32.const 1
      i32.shl
      struct.new $Option_53
    else
      ref.null $Option_53
    end
  )
  (func $testOptionBind (result i32) ;; exported as "testOptionBind"
    (local $x (ref null $Option_53))
    (local $y (ref null $Option_53))
    (local $v i32)
    i32.const 4
    struct.new $Option_53
    local.set $x
    local.get $x
    ref.is_null
    if (result (ref null $Option_53))
      local.get $x
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
      local.set $v
      local.get $v
      i32.const 0
      i32.gt_s
      if (result (ref null $Option_53))
        local.get $v
        i32.const 1
        i32.shl
        struct.new $Option_53
      else
        ref.null $Option_53
      end
    else
      ref.null $Option_53
    end
    local.set $y
    local.get $y
    ref.is_null
    if (result i32)
      local.get $y
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      i32.const -1
    end
  )
  (func $testOptionValue (result i32) ;; exported as "testOptionValue"
    (local $w43 (ref null $Option_53))
    i32.const 42
    struct.new $Option_53
    local.set $w43
    local.get $w43
    ref.cast (ref $Option_53)
    struct.get $Option_53 0
  )
  (func $closure_139 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_140 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testOptionMapValue (result i32) ;; exported as "testOptionMapValue"
    (local $w46 (ref null $Option_53))
    (local $w45 (ref null $Option_53))
    (local $x i32)
    i32.const 42
    struct.new $Option_53
    local.set $w45
    local.get $w45
    ref.is_null
    if (result (ref null $Option_53))
      local.get $w45
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
      local.set $x
      local.get $x
      i32.const 1
      i32.shl
      struct.new $Option_53
    else
      ref.null $Option_53
    end
    local.set $w46
    local.get $w46
    ref.cast (ref $Option_53)
    struct.get $Option_53 0
  )
  (func $testOptionDefaultValue (result i32) ;; exported as "testOptionDefaultValue"
    (local $w47 (ref null $Option_53))
    i32.const 42
    struct.new $Option_53
    local.set $w47
    local.get $w47
    ref.is_null
    if (result i32)
      local.get $w47
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      i32.const 99
    end
  )
  (func $testOptionDefaultValueNone (result i32) ;; exported as "testOptionDefaultValueNone"
    ref.null $Option_53
    ref.cast (ref $Option_53)
    struct.get $Option_53 0
  )
  (func $closure_141 (param $self (ref $AnyFn)) (result i32)
    i32.const 42
  )
  (func $testOptionDefaultWith (result i32) ;; exported as "testOptionDefaultWith"
    ref.null $Option_53
    ref.cast (ref $Option_53)
    struct.get $Option_53 0
  )
  (func $closure_142 (param $self (ref $AnyFn)) (result i32)
    i32.const 99
  )
  (func $testOptionDefaultWithSome (result i32) ;; exported as "testOptionDefaultWithSome"
    (local $w50 (ref null $Option_53))
    i32.const 5
    struct.new $Option_53
    local.set $w50
    local.get $w50
    ref.is_null
    if (result i32)
      local.get $w50
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      i32.const 99
    end
  )
  (func $closure_143 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testOptionFilter (result i32) ;; exported as "testOptionFilter"
    (local $matchValue (ref null $Option_53))
    (local $w51 (ref null $Option_53))
    (local $x i32)
    i32.const 5
    struct.new $Option_53
    local.set $w51
    local.get $w51
    ref.is_null
    if (result (ref null $Option_53))
      local.get $w51
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
      local.set $x
      local.get $x
      i32.const 3
      i32.gt_s
      if (result (ref null $Option_53))
        local.get $w51
      else
        ref.null $Option_53
      end
    else
      ref.null $Option_53
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $closure_144 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testOptionFilterNone (result i32) ;; exported as "testOptionFilterNone"
    (local $matchValue (ref null $Option_53))
    (local $w52 (ref null $Option_53))
    (local $x i32)
    i32.const 5
    struct.new $Option_53
    local.set $w52
    local.get $w52
    ref.is_null
    if (result (ref null $Option_53))
      local.get $w52
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
      local.set $x
      local.get $x
      i32.const 10
      i32.gt_s
      if (result (ref null $Option_53))
        local.get $w52
      else
        ref.null $Option_53
      end
    else
      ref.null $Option_53
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
    ref.null $Option_53
    ref.cast (ref $Option_53)
    struct.get $Option_53 0
  )
  (func $testOptionModuleDefaultValueSome (result i32) ;; exported as "testOptionModuleDefaultValueSome"
    (local $w54 (ref null $Option_53))
    i32.const 99
    struct.new $Option_53
    local.set $w54
    local.get $w54
    ref.is_null
    if (result i32)
      local.get $w54
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
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
  (func $testArrayLiteral (result i32) ;; exported as "testArrayLiteral"
    (local $arr (ref $GcArray_123))
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_123 3
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_123
  )
  (func $testArrayCreate (result i32) ;; exported as "testArrayCreate"
    (local $arr (ref $GcArray_123))
    i32.const 0
    i32.const 3
    array.new $GcArray_123
    local.set $arr
    local.get $arr
    i32.const 0
    i32.const 10
    array.set $GcArray_123
    local.get $arr
    i32.const 1
    i32.const 20
    array.set $GcArray_123
    local.get $arr
    i32.const 2
    i32.const 30
    array.set $GcArray_123
    local.get $arr
    i32.const 0
    array.get $GcArray_123
    local.get $arr
    i32.const 1
    array.get $GcArray_123
    i32.add
    local.get $arr
    i32.const 2
    array.get $GcArray_123
    i32.add
  )
  (func $testArrayZeroCreate (result i32) ;; exported as "testArrayZeroCreate"
    (local $arr (ref $GcArray_123))
    i32.const 0
    i32.const 4
    array.new $GcArray_123
    local.set $arr
    local.get $arr
    i32.const 2
    i32.const 7
    array.set $GcArray_123
    local.get $arr
    i32.const 2
    array.get $GcArray_123
  )
  (func $testArrayLength (result i32) ;; exported as "testArrayLength"
    (local $arr (ref $GcArray_123))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $arr
    local.get $arr
    array.len
  )
  (func $testArraySumLoop (result i32) ;; exported as "testArraySumLoop"
    (local $arr (ref $GcArray_123))
    (local $s i32)
    (local $i i32)
    (local $limit i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
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
        array.get $GcArray_123
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
    (local $arr (ref $GcArray_145))
    f64.const 1
    f64.const 3.1400000000000001
    f64.const 2.71
    array.new_fixed $GcArray_145 3
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_145
  )
  (func $closure_146 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_146))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_146)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_146 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_146 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_146
    local.get $acc
    struct.new $ClosureType_146
  )
  (func $testArrayFold (result i32) ;; exported as "testArrayFold"
    (local $w56 (ref $GcArray_123))
    (local $w57 i32)
    (local $w58 i32)
    (local $w59 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w56
    local.get $w56
    array.len
    local.set $w57
    i32.const 0
    local.set $w58
    i32.const 0
    local.set $w59
    block $while_60_exit
      loop $while_60_lp
        local.get $w59
        local.get $w57
        i32.lt_s
        if
          local.get $w56
          local.get $w59
          array.get $GcArray_123
          local.set $x
          local.get $w58
          local.get $x
          i32.add
          local.set $w58
          local.get $w59
          i32.const 1
          i32.add
          local.set $w59
          br $while_60_lp
        else
          br $while_60_exit
        end
      end
    end
    local.get $w58
  )
  (func $closure_148 (param $self (ref $AnyFn)) (param $x f64) (result f64)
    (local $self_cast (ref $ClosureType_150))
    (local $acc f64)
    local.get $self
    ref.cast (ref $ClosureType_150)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_150 1
    local.set $acc
    local.get $acc
    local.get $x
    f64.add
  )
  (func $closure_148 (param $self (ref $AnyFn)) (param $acc f64) (result (ref $AnyFn))
    ref.func $closure_148
    local.get $acc
    struct.new $ClosureType_150
  )
  (func $testArrayFoldFloat (result f64) ;; exported as "testArrayFoldFloat"
    (local $w62 (ref $GcArray_145))
    (local $w63 i32)
    (local $w64 f64)
    (local $w65 i32)
    (local $x f64)
    f64.const 0.5
    f64.const 0.5
    f64.const 0.5
    array.new_fixed $GcArray_145 3
    local.set $w62
    local.get $w62
    array.len
    local.set $w63
    f64.const 0
    local.set $w64
    i32.const 0
    local.set $w65
    block $while_66_exit
      loop $while_66_lp
        local.get $w65
        local.get $w63
        i32.lt_s
        if
          local.get $w62
          local.get $w65
          array.get $GcArray_145
          local.set $x
          local.get $w64
          local.get $x
          f64.add
          local.set $w64
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
    local.get $w64
  )
  (func $closure_154 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testArrayMap (result i32) ;; exported as "testArrayMap"
    (local $result (ref $GcArray_123))
    (local $w68 (ref $GcArray_123))
    (local $w69 i32)
    (local $w70 (ref $GcArray_123))
    (local $w72 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w68
    local.get $w68
    array.len
    local.set $w69
    i32.const 0
    local.get $w69
    array.new $GcArray_123
    local.set $w70
    i32.const 0
    local.set $w72
    block $while_73_exit
      loop $while_73_lp
        local.get $w72
        local.get $w69
        i32.lt_s
        if
          local.get $w70
          local.get $w72
          local.get $w68
          local.get $w72
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          array.set $GcArray_123
          local.get $w72
          i32.const 1
          i32.add
          local.set $w72
          br $while_73_lp
        else
          br $while_73_exit
        end
      end
    end
    local.get $w70
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_123
    local.get $result
    i32.const 4
    array.get $GcArray_123
    i32.add
  )
  (func $closure_155 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul
  )
  (func $testArrayMapStr (result i32) ;; exported as "testArrayMapStr"
    (local $src (ref $GcArray_123))
    (local $doubled (ref $GcArray_123))
    (local $w76 i32)
    (local $w77 (ref $GcArray_123))
    (local $w79 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $src
    local.get $src
    array.len
    local.set $w76
    i32.const 0
    local.get $w76
    array.new $GcArray_123
    local.set $w77
    i32.const 0
    local.set $w79
    block $while_80_exit
      loop $while_80_lp
        local.get $w79
        local.get $w76
        i32.lt_s
        if
          local.get $w77
          local.get $w79
          local.get $src
          local.get $w79
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 3
          i32.mul
          array.set $GcArray_123
          local.get $w79
          i32.const 1
          i32.add
          local.set $w79
          br $while_80_lp
        else
          br $while_80_exit
        end
      end
    end
    local.get $w77
    local.set $doubled
    local.get $doubled
    i32.const 2
    array.get $GcArray_123
  )
  (func $closure_156 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_156))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_156)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_156 1
    local.set $i
    local.get $i
    local.get $x
    i32.add
  )
  (func $closure_156 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_156
    local.get $i
    struct.new $ClosureType_156
  )
  (func $testArrayMapi (result i32) ;; exported as "testArrayMapi"
    (local $arr (ref $GcArray_123))
    (local $w82 (ref $GcArray_123))
    (local $w83 i32)
    (local $w84 (ref $GcArray_123))
    (local $w86 i32)
    (local $x i32)
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_123 3
    local.set $w82
    local.get $w82
    array.len
    local.set $w83
    i32.const 0
    local.get $w83
    array.new $GcArray_123
    local.set $w84
    i32.const 0
    local.set $w86
    block $while_87_exit
      loop $while_87_lp
        local.get $w86
        local.get $w83
        i32.lt_s
        if
          local.get $w84
          local.get $w86
          local.get $w82
          local.get $w86
          array.get $GcArray_123
          local.set $x
          local.get $w86
          local.get $x
          i32.add
          array.set $GcArray_123
          local.get $w86
          i32.const 1
          i32.add
          local.set $w86
          br $while_87_lp
        else
          br $while_87_exit
        end
      end
    end
    local.get $w84
    local.set $arr
    local.get $arr
    i32.const 1
    array.get $GcArray_123
  )
  (func $closure_158 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testArrayFilter (result i32) ;; exported as "testArrayFilter"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w89 i32)
    (local $w90 i32)
    (local $w91 i32)
    (local $x i32)
    (local $w93 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $arr
    local.get $arr
    array.len
    local.set $w89
    i32.const 0
    local.set $w90
    i32.const 0
    local.set $w91
    block $while_92_exit
      loop $while_92_lp
        local.get $w91
        local.get $w89
        i32.lt_s
        if
          local.get $arr
          local.get $w91
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            local.get $w90
            i32.const 1
            i32.add
            local.set $w90
          end
          local.get $w91
          i32.const 1
          i32.add
          local.set $w91
          br $while_92_lp
        else
          br $while_92_exit
        end
      end
    end
    i32.const 0
    local.set $w93
    i32.const 0
    local.set $w91
    block $while_94_exit
      loop $while_94_lp
        local.get $w91
        local.get $w89
        i32.lt_s
        if
          local.get $arr
          local.get $w91
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            i32.const 0
            local.get $w90
            array.new $GcArray_123
            local.get $w93
            local.get $arr
            local.get $w91
            array.get $GcArray_123
            array.set $GcArray_123
            local.get $w93
            i32.const 1
            i32.add
            local.set $w93
          end
          local.get $w91
          i32.const 1
          i32.add
          local.set $w91
          br $while_94_lp
        else
          br $while_94_exit
        end
      end
    end
    i32.const 0
    local.get $w90
    array.new $GcArray_123
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_159 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayFilterAll (result i32) ;; exported as "testArrayFilterAll"
    (local $result (ref $GcArray_123))
    (local $w96 i32)
    (local $w97 i32)
    (local $w98 i32)
    (local $x i32)
    (local $w100 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    array.len
    local.set $w96
    i32.const 0
    local.set $w97
    i32.const 0
    local.set $w98
    block $while_99_exit
      loop $while_99_lp
        local.get $w98
        local.get $w96
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_123 5
          local.get $w98
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            local.get $w97
            i32.const 1
            i32.add
            local.set $w97
          end
          local.get $w98
          i32.const 1
          i32.add
          local.set $w98
          br $while_99_lp
        else
          br $while_99_exit
        end
      end
    end
    i32.const 0
    local.set $w100
    i32.const 0
    local.set $w98
    block $while_101_exit
      loop $while_101_lp
        local.get $w98
        local.get $w96
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_123 5
          local.get $w98
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            i32.const 0
            local.get $w97
            array.new $GcArray_123
            local.get $w100
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_123 5
            local.get $w98
            array.get $GcArray_123
            array.set $GcArray_123
            local.get $w100
            i32.const 1
            i32.add
            local.set $w100
          end
          local.get $w98
          i32.const 1
          i32.add
          local.set $w98
          br $while_101_lp
        else
          br $while_101_exit
        end
      end
    end
    i32.const 0
    local.get $w97
    array.new $GcArray_123
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_160 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayFilterNone (result i32) ;; exported as "testArrayFilterNone"
    (local $result (ref $GcArray_123))
    (local $w103 i32)
    (local $w104 i32)
    (local $w105 i32)
    (local $x i32)
    (local $w107 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    array.len
    local.set $w103
    i32.const 0
    local.set $w104
    i32.const 0
    local.set $w105
    block $while_106_exit
      loop $while_106_lp
        local.get $w105
        local.get $w103
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_123 5
          local.get $w105
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w104
            i32.const 1
            i32.add
            local.set $w104
          end
          local.get $w105
          i32.const 1
          i32.add
          local.set $w105
          br $while_106_lp
        else
          br $while_106_exit
        end
      end
    end
    i32.const 0
    local.set $w107
    i32.const 0
    local.set $w105
    block $while_108_exit
      loop $while_108_lp
        local.get $w105
        local.get $w103
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_123 5
          local.get $w105
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            i32.const 0
            local.get $w104
            array.new $GcArray_123
            local.get $w107
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_123 5
            local.get $w105
            array.get $GcArray_123
            array.set $GcArray_123
            local.get $w107
            i32.const 1
            i32.add
            local.set $w107
          end
          local.get $w105
          i32.const 1
          i32.add
          local.set $w105
          br $while_108_lp
        else
          br $while_108_exit
        end
      end
    end
    i32.const 0
    local.get $w104
    array.new $GcArray_123
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_161 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 4
    i32.gt_s
  )
  (func $testArrayExists (result i32) ;; exported as "testArrayExists"
    (local $w110 i32)
    (local $w111 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    array.len
    local.set $w110
    i32.const 0
    local.set $w111
    block $isome_109_blk (result i32)
      block $while_112_exit
        loop $while_112_lp
          local.get $w111
          local.get $w110
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_123 5
            local.get $w111
            array.get $GcArray_123
            local.set $x
            local.get $x
            i32.const 4
            i32.gt_s
            if
              i32.const 1
              br $isome_109_blk
            end
            local.get $w111
            i32.const 1
            i32.add
            local.set $w111
            br $while_112_lp
          else
            br $while_112_exit
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
  (func $closure_162 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayExistsFalse (result i32) ;; exported as "testArrayExistsFalse"
    (local $w114 i32)
    (local $w115 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    array.len
    local.set $w114
    i32.const 0
    local.set $w115
    block $isome_113_blk (result i32)
      block $while_116_exit
        loop $while_116_lp
          local.get $w115
          local.get $w114
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_123 5
            local.get $w115
            array.get $GcArray_123
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $isome_113_blk
            end
            local.get $w115
            i32.const 1
            i32.add
            local.set $w115
            br $while_116_lp
          else
            br $while_116_exit
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
  (func $closure_163 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayForAll (result i32) ;; exported as "testArrayForAll"
    (local $w118 i32)
    (local $w119 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    array.len
    local.set $w118
    i32.const 0
    local.set $w119
    block $ievery_117_blk (result i32)
      block $while_120_exit
        loop $while_120_lp
          local.get $w119
          local.get $w118
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_123 5
            local.get $w119
            array.get $GcArray_123
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w119
              i32.const 1
              i32.add
              local.set $w119
            else
              i32.const 0
              br $ievery_117_blk
            end
            br $while_120_lp
          else
            br $while_120_exit
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
  (func $closure_164 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayForAllFalse (result i32) ;; exported as "testArrayForAllFalse"
    (local $w122 i32)
    (local $w123 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    array.len
    local.set $w122
    i32.const 0
    local.set $w123
    block $ievery_121_blk (result i32)
      block $while_124_exit
        loop $while_124_lp
          local.get $w123
          local.get $w122
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_123 5
            local.get $w123
            array.get $GcArray_123
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w123
              i32.const 1
              i32.add
              local.set $w123
            else
              i32.const 0
              br $ievery_121_blk
            end
            br $while_124_lp
          else
            br $while_124_exit
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
  (func $closure_165 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $testArrayInit (result i32) ;; exported as "testArrayInit"
    (local $arr (ref $GcArray_123))
    (local $w126 (ref $GcArray_123))
    (local $w127 i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_123
    local.set $w126
    i32.const 0
    local.set $w127
    block $while_128_exit
      loop $while_128_lp
        local.get $w127
        local.get $w126
        array.len
        i32.lt_s
        if
          local.get $w126
          local.get $w127
          local.get $w127
          local.get $w127
          i32.mul
          array.set $GcArray_123
          local.get $w127
          i32.const 1
          i32.add
          local.set $w127
          br $while_128_lp
        else
          br $while_128_exit
        end
      end
    end
    local.get $w126
    local.set $arr
    local.get $arr
    i32.const 3
    array.get $GcArray_123
  )
  (func $closure_166 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
  )
  (func $closure_167 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_167))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_167)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_167 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_167 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_167
    local.get $x
    struct.new $ClosureType_167
  )
  (func $testArrayInitFold (result i32) ;; exported as "testArrayInitFold"
    (local $arr (ref $GcArray_123))
    (local $w130 (ref $GcArray_123))
    (local $w131 i32)
    (local $w135 i32)
    (local $w136 i32)
    (local $w137 i32)
    (local $y i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_123
    local.set $w130
    i32.const 0
    local.set $w131
    block $while_132_exit
      loop $while_132_lp
        local.get $w131
        local.get $w130
        array.len
        i32.lt_s
        if
          local.get $w130
          local.get $w131
          local.get $w131
          array.set $GcArray_123
          local.get $w131
          i32.const 1
          i32.add
          local.set $w131
          br $while_132_lp
        else
          br $while_132_exit
        end
      end
    end
    local.get $w130
    local.set $arr
    local.get $arr
    array.len
    local.set $w135
    i32.const 0
    local.set $w136
    i32.const 0
    local.set $w137
    block $while_138_exit
      loop $while_138_lp
        local.get $w137
        local.get $w135
        i32.lt_s
        if
          local.get $arr
          local.get $w137
          array.get $GcArray_123
          local.set $y
          local.get $w136
          local.get $y
          i32.add
          local.set $w136
          local.get $w137
          i32.const 1
          i32.add
          local.set $w137
          br $while_138_lp
        else
          br $while_138_exit
        end
      end
    end
    local.get $w136
  )
  (func $closure_169 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_170))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_170)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_170 1
    local.set $s
    local.get $s
    local.get $x
    i32.add
    local.set $s
  )
  (func $testArrayIter (result i32) ;; exported as "testArrayIter"
    (local $s i32)
    (local $w140 (ref $GcArray_123))
    (local $w141 i32)
    (local $w142 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w140
    local.get $w140
    array.len
    local.set $w141
    i32.const 0
    local.set $w142
    block $while_143_exit
      loop $while_143_lp
        local.get $w142
        local.get $w141
        i32.lt_s
        if
          local.get $w140
          local.get $w142
          array.get $GcArray_123
          local.set $x
          local.get $s
          local.get $x
          i32.add
          local.set $s
          local.get $w142
          i32.const 1
          i32.add
          local.set $w142
          br $while_143_lp
        else
          br $while_143_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_171 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_171))
    (local $i i32)
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_171)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_171 1
    local.set $i
    local.get $self_cast
    struct.get $ClosureType_171 2
    local.set $s
    local.get $s
    local.get $i
    local.get $x
    i32.mul
    i32.add
    local.set $s
  )
  (func $closure_171 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_172))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_172)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_172 1
    local.set $s
    ref.func $closure_171
    local.get $i
    local.get $s
    struct.new $ClosureType_171
  )
  (func $testArrayIteri (result i32) ;; exported as "testArrayIteri"
    (local $s i32)
    (local $w145 (ref $GcArray_123))
    (local $w146 i32)
    (local $w147 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w145
    local.get $w145
    array.len
    local.set $w146
    i32.const 0
    local.set $w147
    block $while_148_exit
      loop $while_148_lp
        local.get $w147
        local.get $w146
        i32.lt_s
        if
          local.get $w145
          local.get $w147
          array.get $GcArray_123
          local.set $x
          local.get $s
          local.get $w147
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w147
          i32.const 1
          i32.add
          local.set $w147
          br $while_148_lp
        else
          br $while_148_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_173 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_173))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_173)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_173 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_173 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_173
    local.get $x
    struct.new $ClosureType_173
  )
  (func $testArrayReduce (result i32) ;; exported as "testArrayReduce"
    (local $w150 (ref $GcArray_123))
    (local $w151 i32)
    (local $w152 i32)
    (local $w153 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w150
    local.get $w150
    array.len
    local.set $w151
    local.get $w150
    i32.const 0
    array.get $GcArray_123
    local.set $w152
    i32.const 1
    local.set $w153
    block $while_154_exit
      loop $while_154_lp
        local.get $w153
        local.get $w151
        i32.lt_s
        if
          local.get $w150
          local.get $w153
          array.get $GcArray_123
          local.set $y
          local.get $w152
          local.get $y
          i32.add
          local.set $w152
          local.get $w153
          i32.const 1
          i32.add
          local.set $w153
          br $while_154_lp
        else
          br $while_154_exit
        end
      end
    end
    local.get $w152
  )
  (func $closure_175 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArraySum (result i32) ;; exported as "testArraySum"
    (local $w156 (ref $GcArray_123))
    (local $w157 i32)
    (local $w158 i32)
    (local $w159 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w156
    local.get $w156
    array.len
    local.set $w157
    i32.const 0
    local.set $w158
    i32.const 0
    local.set $w159
    block $while_160_exit
      loop $while_160_lp
        local.get $w159
        local.get $w157
        i32.lt_s
        if
          local.get $w158
          local.get $w156
          local.get $w159
          array.get $GcArray_123
          i32.add
          local.set $w158
          local.get $w159
          i32.const 1
          i32.add
          local.set $w159
          br $while_160_lp
        else
          br $while_160_exit
        end
      end
    end
    local.get $w158
  )
  (func $closure_176 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w162 (ref $GcArray_123))
    (local $w163 i32)
    (local $w164 i32)
    (local $w165 i32)
    (local $w166 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w162
    local.get $w162
    array.len
    local.set $w163
    local.get $w162
    i32.const 0
    array.get $GcArray_123
    local.set $w164
    i32.const 1
    local.set $w165
    block $while_167_exit
      loop $while_167_lp
        local.get $w165
        local.get $w163
        i32.lt_s
        if
          local.get $w162
          local.get $w165
          array.get $GcArray_123
          local.set $w166
          local.get $w166
          local.get $w164
          i32.lt_s
          if (result i32)
            local.get $w166
          else
            local.get $w164
          end
          local.set $w164
          local.get $w165
          i32.const 1
          i32.add
          local.set $w165
          br $while_167_lp
        else
          br $while_167_exit
        end
      end
    end
    local.get $w164
  )
  (func $closure_179 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w169 (ref $GcArray_123))
    (local $w170 i32)
    (local $w171 i32)
    (local $w172 i32)
    (local $w173 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $w169
    local.get $w169
    array.len
    local.set $w170
    local.get $w169
    i32.const 0
    array.get $GcArray_123
    local.set $w171
    i32.const 1
    local.set $w172
    block $while_174_exit
      loop $while_174_lp
        local.get $w172
        local.get $w170
        i32.lt_s
        if
          local.get $w169
          local.get $w172
          array.get $GcArray_123
          local.set $w173
          local.get $w173
          local.get $w171
          i32.gt_s
          if (result i32)
            local.get $w173
          else
            local.get $w171
          end
          local.set $w171
          local.get $w172
          i32.const 1
          i32.add
          local.set $w172
          br $while_174_lp
        else
          br $while_174_exit
        end
      end
    end
    local.get $w171
  )
  (func $testArrayRev (result i32) ;; exported as "testArrayRev"
    (local $w176 (ref $GcArray_123))
    (local $w177 i32)
    (local $w178 (ref $GcArray_123))
    (local $w179 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $w176
    local.get $w176
    array.len
    local.set $w177
    i32.const 0
    local.get $w177
    array.new $GcArray_123
    local.set $w178
    i32.const 0
    local.set $w179
    block $while_180_exit
      loop $while_180_lp
        local.get $w179
        local.get $w177
        i32.lt_s
        if
          local.get $w178
          local.get $w179
          local.get $w176
          local.get $w177
          i32.const 1
          i32.sub
          local.get $w179
          i32.sub
          array.get $GcArray_123
          array.set $GcArray_123
          local.get $w179
          i32.const 1
          i32.add
          local.set $w179
          br $while_180_lp
        else
          br $while_180_exit
        end
      end
    end
    local.get $w178
    i32.const 0
    array.get $GcArray_123
  )
  (func $closure_180 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w182 (ref $GcArray_123))
    (local $w183 i32)
    (local $w184 (ref $GcArray_123))
    (local $w185 i32)
    (local $w186 i32)
    (local $w187 i32)
    i32.const 3
    i32.const 1
    i32.const 2
    array.new_fixed $GcArray_123 3
    local.set $w182
    local.get $w182
    array.len
    local.set $w183
    i32.const 0
    local.get $w183
    array.new $GcArray_123
    local.set $w184
    local.get $w184
    i32.const 0
    local.get $w182
    i32.const 0
    local.get $w183
    array.copy $GcArray_123 $GcArray_123
    i32.const 1
    local.set $w185
    block $while_189_exit
      loop $while_189_lp
        local.get $w185
        local.get $w183
        i32.lt_s
        if
          local.get $w184
          local.get $w185
          array.get $GcArray_123
          local.set $w186
          local.get $w185
          i32.const 1
          i32.sub
          local.set $w187
          block $while_188_exit
            loop $while_188_lp
              local.get $w187
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w184
                local.get $w187
                array.get $GcArray_123
                local.get $w186
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w184
                  local.get $w187
                  array.get $GcArray_123
                  local.get $w186
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
                local.get $w184
                local.get $w187
                i32.const 1
                i32.add
                local.get $w184
                local.get $w187
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w187
                i32.const 1
                i32.sub
                local.set $w187
                br $while_188_lp
              else
                br $while_188_exit
              end
            end
          end
          local.get $w184
          local.get $w187
          i32.const 1
          i32.add
          local.get $w186
          array.set $GcArray_123
          local.get $w185
          i32.const 1
          i32.add
          local.set $w185
          br $while_189_lp
        else
          br $while_189_exit
        end
      end
    end
    local.get $w184
    i32.const 0
    array.get $GcArray_123
  )
  (func $closure_181 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayFindIndex (result i32) ;; exported as "testArrayFindIndex"
    (local $w191 i32)
    (local $w192 i32)
    (local $x i32)
    i32.const 1
    i32.const 5
    i32.const 2
    i32.const 4
    array.new_fixed $GcArray_123 4
    array.len
    local.set $w191
    i32.const 0
    local.set $w192
    block $afidx_190_search (result i32)
      block $while_193_exit
        loop $while_193_lp
          local.get $w192
          local.get $w191
          i32.lt_s
          if
            i32.const 1
            i32.const 5
            i32.const 2
            i32.const 4
            array.new_fixed $GcArray_123 4
            local.get $w192
            array.get $GcArray_123
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w192
              br $afidx_190_search
            end
            local.get $w192
            i32.const 1
            i32.add
            local.set $w192
            br $while_193_lp
          else
            br $while_193_exit
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_182 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContains (result i32) ;; exported as "testArrayContains"
    (local $w196 i32)
    (local $w197 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_123 4
    array.len
    local.set $w196
    i32.const 0
    local.set $w197
    block $acont_194_blk (result i32)
      block $while_198_exit
        loop $while_198_lp
          local.get $w197
          local.get $w196
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_123 4
            local.get $w197
            array.get $GcArray_123
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $acont_194_blk
            end
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
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_183 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContainsFalse (result i32) ;; exported as "testArrayContainsFalse"
    (local $w201 i32)
    (local $w202 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_123 4
    array.len
    local.set $w201
    i32.const 0
    local.set $w202
    block $acont_199_blk (result i32)
      block $while_203_exit
        loop $while_203_lp
          local.get $w202
          local.get $w201
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_123 4
            local.get $w202
            array.get $GcArray_123
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $acont_199_blk
            end
            local.get $w202
            i32.const 1
            i32.add
            local.set $w202
            br $while_203_lp
          else
            br $while_203_exit
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
  (func $closure_184 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_184))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_184)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_184 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_184 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_184
    local.get $x
    struct.new $ClosureType_184
  )
  (func $testArrayScan (result i32) ;; exported as "testArrayScan"
    (local $r (ref $GcArray_123))
    (local $w205 (ref $GcArray_123))
    (local $w206 (ref $GcArray_123))
    (local $w207 i32)
    (local $w209 i32)
    (local $w210 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_123 4
    local.set $w205
    i32.const 0
    local.get $w205
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_123
    local.set $w206
    i32.const 0
    local.set $w207
    local.get $w206
    i32.const 0
    local.get $w207
    array.set $GcArray_123
    local.get $w205
    array.len
    local.set $w209
    i32.const 0
    local.set $w210
    block $while_211_exit
      loop $while_211_lp
        local.get $w210
        local.get $w209
        i32.lt_s
        if
          local.get $w205
          local.get $w210
          array.get $GcArray_123
          local.set $y
          local.get $w207
          local.get $y
          i32.add
          local.set $w207
          local.get $w206
          local.get $w210
          i32.const 1
          i32.add
          local.get $w207
          array.set $GcArray_123
          local.get $w210
          i32.const 1
          i32.add
          local.set $w210
          br $while_211_lp
        else
          br $while_211_exit
        end
      end
    end
    local.get $w206
    local.set $r
    local.get $r
    local.get $r
    array.len
    i32.const 1
    i32.sub
    array.get $GcArray_123
  )
  (func $closure_186 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_186))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_186)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_186 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_186 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_186
    local.get $x
    struct.new $ClosureType_186
  )
  (func $testArrayScanLen (result i32) ;; exported as "testArrayScanLen"
    (local $w213 (ref $GcArray_123))
    (local $w214 (ref $GcArray_123))
    (local $w215 i32)
    (local $w217 i32)
    (local $w218 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_123 4
    local.set $w213
    i32.const 0
    local.get $w213
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_123
    local.set $w214
    i32.const 0
    local.set $w215
    local.get $w214
    i32.const 0
    local.get $w215
    array.set $GcArray_123
    local.get $w213
    array.len
    local.set $w217
    i32.const 0
    local.set $w218
    block $while_219_exit
      loop $while_219_lp
        local.get $w218
        local.get $w217
        i32.lt_s
        if
          local.get $w213
          local.get $w218
          array.get $GcArray_123
          local.set $y
          local.get $w215
          local.get $y
          i32.add
          local.set $w215
          local.get $w214
          local.get $w218
          i32.const 1
          i32.add
          local.get $w215
          array.set $GcArray_123
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
    local.get $w214
    array.len
  )
  (func $testArrayAppend (result i32) ;; exported as "testArrayAppend"
    (local $w221 (ref $GcArray_123))
    (local $w222 (ref $GcArray_123))
    (local $w223 i32)
    (local $w224 (ref $GcArray_123))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $w221
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 2
    local.set $w222
    local.get $w221
    array.len
    local.set $w223
    i32.const 0
    local.get $w223
    local.get $w222
    array.len
    i32.add
    array.new $GcArray_123
    local.set $w224
    local.get $w224
    i32.const 0
    local.get $w221
    i32.const 0
    local.get $w223
    array.copy $GcArray_123 $GcArray_123
    local.get $w224
    local.get $w223
    local.get $w222
    i32.const 0
    local.get $w222
    array.len
    array.copy $GcArray_123 $GcArray_123
    local.get $w224
    i32.const 3
    array.get $GcArray_123
  )
  (func $testArrayAppendLen (result i32) ;; exported as "testArrayAppendLen"
    (local $w226 (ref $GcArray_123))
    (local $w227 (ref $GcArray_123))
    (local $w228 i32)
    (local $w229 (ref $GcArray_123))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $w226
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 2
    local.set $w227
    local.get $w226
    array.len
    local.set $w228
    i32.const 0
    local.get $w228
    local.get $w227
    array.len
    i32.add
    array.new $GcArray_123
    local.set $w229
    local.get $w229
    i32.const 0
    local.get $w226
    i32.const 0
    local.get $w228
    array.copy $GcArray_123 $GcArray_123
    local.get $w229
    local.get $w228
    local.get $w227
    i32.const 0
    local.get $w227
    array.len
    array.copy $GcArray_123 $GcArray_123
    local.get $w229
    array.len
  )
  (func $closure_188 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayToList (result i32) ;; exported as "testArrayToList"
    (local $arr (ref $GcArray_123))
    (local $lst (ref null $ListBase))
    (local $w232 i32)
    (local $w233 (ref null $ListBase))
    (local $w236 (ref null $ListBase))
    (local $w237 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $arr
    local.get $arr
    array.len
    i32.const 1
    i32.sub
    local.set $w232
    ref.null $ListBase
    local.set $w233
    block $while_234_exit
      loop $while_234_lp
        local.get $w232
        i32.const 0
        i32.ge_s
        if
          local.get $arr
          local.get $w232
          array.get $GcArray_123
          local.get $w233
          struct.new $ListCons_30
          local.set $w233
          local.get $w232
          i32.const 1
          i32.sub
          local.set $w232
          br $while_234_lp
        else
          br $while_234_exit
        end
      end
    end
    local.get $w233
    local.set $lst
    local.get $lst
    local.set $w236
    i32.const 0
    local.set $w237
    block $while_238_exit
      loop $while_238_lp
        local.get $w236
        ref.is_null
        i32.eqz
        if
          local.get $w237
          local.get $w236
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w237
          local.get $w236
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w236
          br $while_238_lp
        else
          br $while_238_exit
        end
      end
    end
    local.get $w237
  )
  (func $closure_189 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListOfArray (result i32) ;; exported as "testListOfArray"
    (local $arr (ref $GcArray_123))
    (local $lst (ref null $ListBase))
    (local $w241 i32)
    (local $w242 (ref null $ListBase))
    (local $w245 (ref null $ListBase))
    (local $w246 i32)
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_123 3
    local.set $arr
    local.get $arr
    array.len
    i32.const 1
    i32.sub
    local.set $w241
    ref.null $ListBase
    local.set $w242
    block $while_243_exit
      loop $while_243_lp
        local.get $w241
        i32.const 0
        i32.ge_s
        if
          local.get $arr
          local.get $w241
          array.get $GcArray_123
          local.get $w242
          struct.new $ListCons_30
          local.set $w242
          local.get $w241
          i32.const 1
          i32.sub
          local.set $w241
          br $while_243_lp
        else
          br $while_243_exit
        end
      end
    end
    local.get $w242
    local.set $lst
    local.get $lst
    local.set $w245
    i32.const 0
    local.set $w246
    block $while_247_exit
      loop $while_247_lp
        local.get $w245
        ref.is_null
        i32.eqz
        if
          local.get $w246
          local.get $w245
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w246
          local.get $w245
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w245
          br $while_247_lp
        else
          br $while_247_exit
        end
      end
    end
    local.get $w246
  )
  (func $closure_190 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_190))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_190)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_190 1
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
  (func $closure_190 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_190
    local.get $a
    struct.new $ClosureType_190
  )
  (func $testArraySortWith (result i32) ;; exported as "testArraySortWith"
    (local $arr (ref $GcArray_123))
    (local $sorted (ref $GcArray_123))
    (local $w250 i32)
    (local $w251 (ref $GcArray_123))
    (local $w252 i32)
    (local $w253 i32)
    (local $w254 i32)
    (local $a i32)
    (local $w249 (ref $GcArray_123))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_123 4
    local.set $arr
    local.get $arr
    array.len
    local.set $w250
    i32.const 0
    local.get $w250
    array.new $GcArray_123
    local.set $w251
    local.get $w251
    i32.const 0
    local.get $w249
    i32.const 0
    local.get $w250
    array.copy $GcArray_123 $GcArray_123
    i32.const 1
    local.set $w252
    block $while_256_exit
      loop $while_256_lp
        local.get $w252
        local.get $w250
        i32.lt_s
        if
          local.get $w251
          local.get $w252
          array.get $GcArray_123
          local.set $w253
          local.get $w252
          i32.const 1
          i32.sub
          local.set $w254
          block $while_255_exit
            loop $while_255_lp
              local.get $w254
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w251
                local.get $w254
                array.get $GcArray_123
                local.set $a
                local.get $a
                local.get $w253
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $a
                  local.get $w253
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
                local.get $w251
                local.get $w254
                i32.const 1
                i32.add
                local.get $w251
                local.get $w254
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w254
                i32.const 1
                i32.sub
                local.set $w254
                br $while_255_lp
              else
                br $while_255_exit
              end
            end
          end
          local.get $w251
          local.get $w254
          i32.const 1
          i32.add
          local.get $w253
          array.set $GcArray_123
          local.get $w252
          i32.const 1
          i32.add
          local.set $w252
          br $while_256_lp
        else
          br $while_256_exit
        end
      end
    end
    local.get $w251
    local.set $sorted
    local.get $sorted
    i32.const 0
    array.get $GcArray_123
  )
  (func $closure_192 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_192))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_192)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_192 1
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
  (func $closure_192 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_192
    local.get $a
    struct.new $ClosureType_192
  )
  (func $testArraySortWithDesc (result i32) ;; exported as "testArraySortWithDesc"
    (local $arr (ref $GcArray_123))
    (local $sorted (ref $GcArray_123))
    (local $w259 i32)
    (local $w260 (ref $GcArray_123))
    (local $w261 i32)
    (local $w262 i32)
    (local $w263 i32)
    (local $a i32)
    (local $w258 (ref $GcArray_123))
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_123 4
    local.set $arr
    local.get $arr
    array.len
    local.set $w259
    i32.const 0
    local.get $w259
    array.new $GcArray_123
    local.set $w260
    local.get $w260
    i32.const 0
    local.get $w258
    i32.const 0
    local.get $w259
    array.copy $GcArray_123 $GcArray_123
    i32.const 1
    local.set $w261
    block $while_265_exit
      loop $while_265_lp
        local.get $w261
        local.get $w259
        i32.lt_s
        if
          local.get $w260
          local.get $w261
          array.get $GcArray_123
          local.set $w262
          local.get $w261
          i32.const 1
          i32.sub
          local.set $w263
          block $while_264_exit
            loop $while_264_lp
              local.get $w263
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w260
                local.get $w263
                array.get $GcArray_123
                local.set $a
                local.get $w262
                local.get $a
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w262
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
                local.get $w260
                local.get $w263
                i32.const 1
                i32.add
                local.get $w260
                local.get $w263
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w263
                i32.const 1
                i32.sub
                local.set $w263
                br $while_264_lp
              else
                br $while_264_exit
              end
            end
          end
          local.get $w260
          local.get $w263
          i32.const 1
          i32.add
          local.get $w262
          array.set $GcArray_123
          local.get $w261
          i32.const 1
          i32.add
          local.set $w261
          br $while_265_lp
        else
          br $while_265_exit
        end
      end
    end
    local.get $w260
    local.set $sorted
    local.get $sorted
    i32.const 0
    array.get $GcArray_123
  )
  (func $testArrayZip (result i32) ;; exported as "testArrayZip"
    (local $arr1 (ref $GcArray_123))
    (local $arr2 (ref $GcArray_123))
    (local $zipped (ref $GcArray_194))
    (local $w269 (ref $GcArray_194))
    (local $w270 i32)
    (local $patternInput (ref $Tuple_62))
    (local $b i32)
    (local $a i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $arr1
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_123 3
    local.set $arr2
    i32.const 0
    i32.const 0
    struct.new $Tuple_62
    local.get $arr1
    array.len
    array.new $GcArray_194
    local.set $w269
    i32.const 0
    local.set $w270
    block $while_271_exit
      loop $while_271_lp
        local.get $w270
        local.get $arr1
        array.len
        i32.lt_s
        if
          local.get $w269
          local.get $w270
          local.get $arr1
          local.get $w270
          array.get $GcArray_123
          local.get $arr2
          local.get $w270
          array.get $GcArray_123
          struct.new $Tuple_62
          array.set $GcArray_194
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
    local.get $w269
    local.set $zipped
    local.get $zipped
    i32.const 0
    array.get $GcArray_194
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_62 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_62 0
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $testArrayZipLen (result i32) ;; exported as "testArrayZipLen"
    (local $zipped (ref $GcArray_194))
    (local $w273 (ref $GcArray_123))
    (local $w274 (ref $GcArray_123))
    (local $w275 (ref $GcArray_194))
    (local $w276 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $w273
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_123 3
    local.set $w274
    i32.const 0
    i32.const 0
    struct.new $Tuple_62
    local.get $w273
    array.len
    array.new $GcArray_194
    local.set $w275
    i32.const 0
    local.set $w276
    block $while_277_exit
      loop $while_277_lp
        local.get $w276
        local.get $w273
        array.len
        i32.lt_s
        if
          local.get $w275
          local.get $w276
          local.get $w273
          local.get $w276
          array.get $GcArray_123
          local.get $w274
          local.get $w276
          array.get $GcArray_123
          struct.new $Tuple_62
          array.set $GcArray_194
          local.get $w276
          i32.const 1
          i32.add
          local.set $w276
          br $while_277_lp
        else
          br $while_277_exit
        end
      end
    end
    local.get $w275
    local.set $zipped
    local.get $zipped
    array.len
  )
  (func $closure_195 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_195 (param $self (ref $AnyFn)) (param $array (ref $GcArray_123)) (result i32)
    (local $w280 i32)
    (local $w281 i32)
    (local $w282 i32)
    local.get $array
    array.len
    local.set $w280
    i32.const 0
    local.set $w281
    i32.const 0
    local.set $w282
    block $while_283_exit
      loop $while_283_lp
        local.get $w282
        local.get $w280
        i32.lt_s
        if
          local.get $w281
          local.get $array
          local.get $w282
          array.get $GcArray_123
          i32.add
          local.set $w281
          local.get $w282
          i32.const 1
          i32.add
          local.set $w282
          br $while_283_lp
        else
          br $while_283_exit
        end
      end
    end
    local.get $w281
  )
  (func $closure_199 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_199))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_199)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_199 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_199 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_199
    local.get $a
    struct.new $ClosureType_199
  )
  (func $testArrayMap2Sum (result i32) ;; exported as "testArrayMap2Sum"
    (local $lo_clo_35 (ref $ClosureBase_197))
    (local $w285 (ref $GcArray_123))
    (local $w286 (ref $GcArray_123))
    (local $w287 i32)
    (local $w288 (ref $GcArray_123))
    (local $w289 i32)
    (local $a i32)
    (local $b i32)
    ref.func $closure_195
    struct.new $ClosureType_198
    ref.cast (ref $ClosureBase_197)
    local.set $lo_clo_35
    local.get $lo_clo_35
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $w285
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_123 3
    local.set $w286
    local.get $w285
    array.len
    local.set $w287
    i32.const 0
    local.get $w287
    array.new $GcArray_123
    local.set $w288
    i32.const 0
    local.set $w289
    block $while_290_exit
      loop $while_290_lp
        local.get $w289
        local.get $w287
        i32.lt_s
        if
          local.get $w288
          local.get $w289
          local.get $w285
          local.get $w289
          array.get $GcArray_123
          local.set $a
          local.get $w286
          local.get $w289
          array.get $GcArray_123
          local.set $b
          local.get $a
          local.get $b
          i32.add
          array.set $GcArray_123
          local.get $w289
          i32.const 1
          i32.add
          local.set $w289
          br $while_290_lp
        else
          br $while_290_exit
        end
      end
    end
    local.get $w288
    local.get $lo_clo_35
    struct.get $ClosureBase_197 0
    call_ref $FuncType_196
  )
  (func $closure_201 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_201))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_201)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_201 1
    local.set $a
    local.get $a
    local.get $b
    i32.mul
  )
  (func $closure_201 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_201
    local.get $a
    struct.new $ClosureType_201
  )
  (func $testArrayMap2Head (result i32) ;; exported as "testArrayMap2Head"
    (local $w292 (ref $GcArray_123))
    (local $w293 (ref $GcArray_123))
    (local $w294 i32)
    (local $w295 (ref $GcArray_123))
    (local $w296 i32)
    (local $a i32)
    (local $b i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $w292
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_123 3
    local.set $w293
    local.get $w292
    array.len
    local.set $w294
    i32.const 0
    local.get $w294
    array.new $GcArray_123
    local.set $w295
    i32.const 0
    local.set $w296
    block $while_297_exit
      loop $while_297_lp
        local.get $w296
        local.get $w294
        i32.lt_s
        if
          local.get $w295
          local.get $w296
          local.get $w292
          local.get $w296
          array.get $GcArray_123
          local.set $a
          local.get $w293
          local.get $w296
          array.get $GcArray_123
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          array.set $GcArray_123
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
    i32.const 0
    array.get $GcArray_123
  )
  (func $closure_203 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_53))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_53))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_53
    else
      ref.null $Option_53
    end
  )
  (func $closure_204 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayChooseBasic (result i32) ;; exported as "testArrayChooseBasic"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w304 i32)
    (local $w300 i32)
    (local $w301 i32)
    (local $x i32)
    (local $w302 (ref null $Option_53))
    (local $w305 (ref $GcArray_123))
    (local $w306 i32)
    (local $w307 i32)
    (local $w308 (ref null $Option_53))
    (local $w312 i32)
    (local $w313 i32)
    (local $w314 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_123 5
    local.set $arr
    i32.const 0
    local.set $w300
    i32.const 0
    local.set $w301
    block $while_303_exit
      loop $while_303_lp
        local.get $w301
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w301
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_53))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_53
          else
            ref.null $Option_53
          end
          local.set $w302
          local.get $w302
          ref.is_null
          i32.eqz
          if
            local.get $w300
            i32.const 1
            i32.add
            local.set $w300
          end
          local.get $w301
          i32.const 1
          i32.add
          local.set $w301
          br $while_303_lp
        else
          br $while_303_exit
        end
      end
    end
    local.get $w300
    local.set $w304
    i32.const 0
    local.get $w304
    array.new $GcArray_123
    local.set $w305
    i32.const 0
    local.set $w306
    i32.const 0
    local.set $w307
    block $while_309_exit
      loop $while_309_lp
        local.get $w307
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w307
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_53))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_53
          else
            ref.null $Option_53
          end
          local.set $w308
          local.get $w308
          ref.is_null
          i32.eqz
          if
            local.get $w305
            local.get $w306
            local.get $w308
            ref.cast (ref $Option_53)
            struct.get $Option_53 0
            array.set $GcArray_123
            local.get $w306
            i32.const 1
            i32.add
            local.set $w306
          end
          local.get $w307
          i32.const 1
          i32.add
          local.set $w307
          br $while_309_lp
        else
          br $while_309_exit
        end
      end
    end
    local.get $w305
    local.set $result
    local.get $result
    array.len
    local.set $w312
    i32.const 0
    local.set $w313
    i32.const 0
    local.set $w314
    block $while_315_exit
      loop $while_315_lp
        local.get $w314
        local.get $w312
        i32.lt_s
        if
          local.get $w313
          local.get $result
          local.get $w314
          array.get $GcArray_123
          i32.add
          local.set $w313
          local.get $w314
          i32.const 1
          i32.add
          local.set $w314
          br $while_315_lp
        else
          br $while_315_exit
        end
      end
    end
    local.get $w313
  )
  (func $closure_205 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_53))
    local.get $x
    i32.const 3
    i32.gt_s
    if (result (ref null $Option_53))
      local.get $x
      struct.new $Option_53
    else
      ref.null $Option_53
    end
  )
  (func $testArrayChooseLength (result i32) ;; exported as "testArrayChooseLength"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w322 i32)
    (local $w318 i32)
    (local $w319 i32)
    (local $x i32)
    (local $w320 (ref null $Option_53))
    (local $w323 (ref $GcArray_123))
    (local $w324 i32)
    (local $w325 i32)
    (local $w326 (ref null $Option_53))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_123 6
    local.set $arr
    i32.const 0
    local.set $w318
    i32.const 0
    local.set $w319
    block $while_321_exit
      loop $while_321_lp
        local.get $w319
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w319
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_53))
            local.get $x
            struct.new $Option_53
          else
            ref.null $Option_53
          end
          local.set $w320
          local.get $w320
          ref.is_null
          i32.eqz
          if
            local.get $w318
            i32.const 1
            i32.add
            local.set $w318
          end
          local.get $w319
          i32.const 1
          i32.add
          local.set $w319
          br $while_321_lp
        else
          br $while_321_exit
        end
      end
    end
    local.get $w318
    local.set $w322
    i32.const 0
    local.get $w322
    array.new $GcArray_123
    local.set $w323
    i32.const 0
    local.set $w324
    i32.const 0
    local.set $w325
    block $while_327_exit
      loop $while_327_lp
        local.get $w325
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w325
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_53))
            local.get $x
            struct.new $Option_53
          else
            ref.null $Option_53
          end
          local.set $w326
          local.get $w326
          ref.is_null
          i32.eqz
          if
            local.get $w323
            local.get $w324
            local.get $w326
            ref.cast (ref $Option_53)
            struct.get $Option_53 0
            array.set $GcArray_123
            local.get $w324
            i32.const 1
            i32.add
            local.set $w324
          end
          local.get $w325
          i32.const 1
          i32.add
          local.set $w325
          br $while_327_lp
        else
          br $while_327_exit
        end
      end
    end
    local.get $w323
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_206 (param $self (ref $AnyFn)) (param $_x i32) (result (ref null $Option_53))
    ref.null $Option_53
  )
  (func $testArrayChooseEmpty (result i32) ;; exported as "testArrayChooseEmpty"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w334 i32)
    (local $w330 i32)
    (local $w331 i32)
    (local $w335 (ref $GcArray_123))
    (local $w336 i32)
    (local $w337 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $arr
    i32.const 0
    local.set $w330
    i32.const 0
    local.set $w331
    block $while_333_exit
      loop $while_333_lp
        local.get $w331
        local.get $arr
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w330
            i32.const 1
            i32.add
            local.set $w330
          end
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
    local.set $w334
    i32.const 0
    local.get $w334
    array.new $GcArray_123
    local.set $w335
    i32.const 0
    local.set $w336
    i32.const 0
    local.set $w337
    block $while_339_exit
      loop $while_339_lp
        local.get $w337
        local.get $arr
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w335
            local.get $w336
            ref.null $Option_53
            ref.cast (ref $Option_53)
            struct.get $Option_53 0
            array.set $GcArray_123
            local.get $w336
            i32.const 1
            i32.add
            local.set $w336
          end
          local.get $w337
          i32.const 1
          i32.add
          local.set $w337
          br $while_339_lp
        else
          br $while_339_exit
        end
      end
    end
    local.get $w335
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_207 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_53))
    local.get $x
    i32.const 10
    i32.add
    struct.new $Option_53
  )
  (func $testArrayChooseAllSome (result i32) ;; exported as "testArrayChooseAllSome"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w346 i32)
    (local $w342 i32)
    (local $w343 i32)
    (local $x i32)
    (local $w344 (ref null $Option_53))
    (local $w347 (ref $GcArray_123))
    (local $w348 i32)
    (local $w349 i32)
    (local $w350 (ref null $Option_53))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $arr
    i32.const 0
    local.set $w342
    i32.const 0
    local.set $w343
    block $while_345_exit
      loop $while_345_lp
        local.get $w343
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w343
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_53
          local.set $w344
          local.get $w344
          ref.is_null
          i32.eqz
          if
            local.get $w342
            i32.const 1
            i32.add
            local.set $w342
          end
          local.get $w343
          i32.const 1
          i32.add
          local.set $w343
          br $while_345_lp
        else
          br $while_345_exit
        end
      end
    end
    local.get $w342
    local.set $w346
    i32.const 0
    local.get $w346
    array.new $GcArray_123
    local.set $w347
    i32.const 0
    local.set $w348
    i32.const 0
    local.set $w349
    block $while_351_exit
      loop $while_351_lp
        local.get $w349
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w349
          array.get $GcArray_123
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_53
          local.set $w350
          local.get $w350
          ref.is_null
          i32.eqz
          if
            local.get $w347
            local.get $w348
            local.get $w350
            ref.cast (ref $Option_53)
            struct.get $Option_53 0
            array.set $GcArray_123
            local.get $w348
            i32.const 1
            i32.add
            local.set $w348
          end
          local.get $w349
          i32.const 1
          i32.add
          local.set $w349
          br $while_351_lp
        else
          br $while_351_exit
        end
      end
    end
    local.get $w347
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_123
    local.get $result
    i32.const 1
    array.get $GcArray_123
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_123
    i32.add
  )
  (func $closure_208 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_123))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    array.new_fixed $GcArray_123 2
  )
  (func $closure_211 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayCollectBasic (result i32) ;; exported as "testArrayCollectBasic"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w358 i32)
    (local $w354 i32)
    (local $w355 i32)
    (local $x i32)
    (local $w356 (ref $GcArray_123))
    (local $w359 (ref $GcArray_123))
    (local $w360 i32)
    (local $w361 i32)
    (local $w362 (ref $GcArray_123))
    (local $w366 i32)
    (local $w367 i32)
    (local $w368 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $arr
    i32.const 0
    local.set $w354
    i32.const 0
    local.set $w355
    block $while_357_exit
      loop $while_357_lp
        local.get $w355
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w355
          array.get $GcArray_123
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_123 2
          local.set $w356
          local.get $w354
          local.get $w356
          array.len
          i32.add
          local.set $w354
          local.get $w355
          i32.const 1
          i32.add
          local.set $w355
          br $while_357_lp
        else
          br $while_357_exit
        end
      end
    end
    local.get $w354
    local.set $w358
    i32.const 0
    local.get $w358
    array.new $GcArray_123
    local.set $w359
    i32.const 0
    local.set $w360
    i32.const 0
    local.set $w361
    block $while_363_exit
      loop $while_363_lp
        local.get $w361
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w361
          array.get $GcArray_123
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_123 2
          local.set $w362
          local.get $w359
          local.get $w360
          local.get $w362
          i32.const 0
          local.get $w362
          array.len
          array.copy $GcArray_123 $GcArray_123
          local.get $w360
          local.get $w362
          array.len
          i32.add
          local.set $w360
          local.get $w361
          i32.const 1
          i32.add
          local.set $w361
          br $while_363_lp
        else
          br $while_363_exit
        end
      end
    end
    local.get $w359
    local.set $result
    local.get $result
    array.len
    local.set $w366
    i32.const 0
    local.set $w367
    i32.const 0
    local.set $w368
    block $while_369_exit
      loop $while_369_lp
        local.get $w368
        local.get $w366
        i32.lt_s
        if
          local.get $w367
          local.get $result
          local.get $w368
          array.get $GcArray_123
          i32.add
          local.set $w367
          local.get $w368
          i32.const 1
          i32.add
          local.set $w368
          br $while_369_lp
        else
          br $while_369_exit
        end
      end
    end
    local.get $w367
  )
  (func $closure_212 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_123))
    local.get $x
    local.get $x
    array.new_fixed $GcArray_123 2
  )
  (func $testArrayCollectLength (result i32) ;; exported as "testArrayCollectLength"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w376 i32)
    (local $w372 i32)
    (local $w373 i32)
    (local $x i32)
    (local $w374 (ref $GcArray_123))
    (local $w377 (ref $GcArray_123))
    (local $w378 i32)
    (local $w379 i32)
    (local $w380 (ref $GcArray_123))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $arr
    i32.const 0
    local.set $w372
    i32.const 0
    local.set $w373
    block $while_375_exit
      loop $while_375_lp
        local.get $w373
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w373
          array.get $GcArray_123
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_123 2
          local.set $w374
          local.get $w372
          local.get $w374
          array.len
          i32.add
          local.set $w372
          local.get $w373
          i32.const 1
          i32.add
          local.set $w373
          br $while_375_lp
        else
          br $while_375_exit
        end
      end
    end
    local.get $w372
    local.set $w376
    i32.const 0
    local.get $w376
    array.new $GcArray_123
    local.set $w377
    i32.const 0
    local.set $w378
    i32.const 0
    local.set $w379
    block $while_381_exit
      loop $while_381_lp
        local.get $w379
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w379
          array.get $GcArray_123
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_123 2
          local.set $w380
          local.get $w377
          local.get $w378
          local.get $w380
          i32.const 0
          local.get $w380
          array.len
          array.copy $GcArray_123 $GcArray_123
          local.get $w378
          local.get $w380
          array.len
          i32.add
          local.set $w378
          local.get $w379
          i32.const 1
          i32.add
          local.set $w379
          br $while_381_lp
        else
          br $while_381_exit
        end
      end
    end
    local.get $w377
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_213 (param $self (ref $AnyFn)) (param $_x i32) (result (ref $GcArray_123))
    array.new_fixed $GcArray_123 0
  )
  (func $testArrayCollectEmpty (result i32) ;; exported as "testArrayCollectEmpty"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w388 i32)
    (local $w384 i32)
    (local $w385 i32)
    (local $w386 (ref $GcArray_123))
    (local $w389 (ref $GcArray_123))
    (local $w390 i32)
    (local $w391 i32)
    (local $w392 (ref $GcArray_123))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_123 3
    local.set $arr
    i32.const 0
    local.set $w384
    i32.const 0
    local.set $w385
    block $while_387_exit
      loop $while_387_lp
        local.get $w385
        local.get $arr
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_123 0
          local.set $w386
          local.get $w384
          local.get $w386
          array.len
          i32.add
          local.set $w384
          local.get $w385
          i32.const 1
          i32.add
          local.set $w385
          br $while_387_lp
        else
          br $while_387_exit
        end
      end
    end
    local.get $w384
    local.set $w388
    i32.const 0
    local.get $w388
    array.new $GcArray_123
    local.set $w389
    i32.const 0
    local.set $w390
    i32.const 0
    local.set $w391
    block $while_393_exit
      loop $while_393_lp
        local.get $w391
        local.get $arr
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_123 0
          local.set $w392
          local.get $w389
          local.get $w390
          local.get $w392
          i32.const 0
          local.get $w392
          array.len
          array.copy $GcArray_123 $GcArray_123
          local.get $w390
          local.get $w392
          array.len
          i32.add
          local.set $w390
          local.get $w391
          i32.const 1
          i32.add
          local.set $w391
          br $while_393_lp
        else
          br $while_393_exit
        end
      end
    end
    local.get $w389
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_214 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_123))
    local.get $x
    array.new_fixed $GcArray_123 1
  )
  (func $testArrayCollectSingleton (result i32) ;; exported as "testArrayCollectSingleton"
    (local $arr (ref $GcArray_123))
    (local $result (ref $GcArray_123))
    (local $w400 i32)
    (local $w396 i32)
    (local $w397 i32)
    (local $x i32)
    (local $w398 (ref $GcArray_123))
    (local $w401 (ref $GcArray_123))
    (local $w402 i32)
    (local $w403 i32)
    (local $w404 (ref $GcArray_123))
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_123 3
    local.set $arr
    i32.const 0
    local.set $w396
    i32.const 0
    local.set $w397
    block $while_399_exit
      loop $while_399_lp
        local.get $w397
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w397
          array.get $GcArray_123
          local.set $x
          local.get $x
          array.new_fixed $GcArray_123 1
          local.set $w398
          local.get $w396
          local.get $w398
          array.len
          i32.add
          local.set $w396
          local.get $w397
          i32.const 1
          i32.add
          local.set $w397
          br $while_399_lp
        else
          br $while_399_exit
        end
      end
    end
    local.get $w396
    local.set $w400
    i32.const 0
    local.get $w400
    array.new $GcArray_123
    local.set $w401
    i32.const 0
    local.set $w402
    i32.const 0
    local.set $w403
    block $while_405_exit
      loop $while_405_lp
        local.get $w403
        local.get $arr
        array.len
        i32.lt_s
        if
          local.get $arr
          local.get $w403
          array.get $GcArray_123
          local.set $x
          local.get $x
          array.new_fixed $GcArray_123 1
          local.set $w404
          local.get $w401
          local.get $w402
          local.get $w404
          i32.const 0
          local.get $w404
          array.len
          array.copy $GcArray_123 $GcArray_123
          local.get $w402
          local.get $w404
          array.len
          i32.add
          local.set $w402
          local.get $w403
          i32.const 1
          i32.add
          local.set $w403
          br $while_405_lp
        else
          br $while_405_exit
        end
      end
    end
    local.get $w401
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_123
    local.get $result
    i32.const 1
    array.get $GcArray_123
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_123
    i32.add
  )
  (func $testResizeArrayBasic (result i32) ;; exported as "testResizeArrayBasic"
    (local $xs (ref $ResizeArray_215))
    (local $w407 i32)
    (local $w408 (ref $GcArray_123))
    (local $w409 i32)
    (local $w410 (ref $GcArray_123))
    (local $w412 i32)
    (local $w413 (ref $GcArray_123))
    (local $w414 i32)
    (local $w415 (ref $GcArray_123))
    (local $w417 i32)
    (local $w418 (ref $GcArray_123))
    (local $w419 i32)
    (local $w420 (ref $GcArray_123))
    i32.const 0
    i32.const 4
    array.new $GcArray_123
    i32.const 0
    struct.new $ResizeArray_215
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_215 1
    local.set $w407
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.set $w408
    local.get $w407
    local.get $w408
    array.len
    i32.ge_u
    if
      local.get $w408
      array.len
      i32.const 1
      i32.shl
      local.set $w409
      i32.const 0
      local.get $w409
      array.new $GcArray_123
      local.set $w410
      local.get $w410
      i32.const 0
      local.get $w408
      i32.const 0
      local.get $w407
      array.copy $GcArray_123 $GcArray_123
      local.get $xs
      local.get $w410
      struct.set $ResizeArray_215 0
    end
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.get $w407
    i32.const 10
    array.set $GcArray_123
    local.get $xs
    local.get $w407
    i32.const 1
    i32.add
    struct.set $ResizeArray_215 1
    local.get $xs
    struct.get $ResizeArray_215 1
    local.set $w412
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.set $w413
    local.get $w412
    local.get $w413
    array.len
    i32.ge_u
    if
      local.get $w413
      array.len
      i32.const 1
      i32.shl
      local.set $w414
      i32.const 0
      local.get $w414
      array.new $GcArray_123
      local.set $w415
      local.get $w415
      i32.const 0
      local.get $w413
      i32.const 0
      local.get $w412
      array.copy $GcArray_123 $GcArray_123
      local.get $xs
      local.get $w415
      struct.set $ResizeArray_215 0
    end
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.get $w412
    i32.const 20
    array.set $GcArray_123
    local.get $xs
    local.get $w412
    i32.const 1
    i32.add
    struct.set $ResizeArray_215 1
    local.get $xs
    struct.get $ResizeArray_215 1
    local.set $w417
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.set $w418
    local.get $w417
    local.get $w418
    array.len
    i32.ge_u
    if
      local.get $w418
      array.len
      i32.const 1
      i32.shl
      local.set $w419
      i32.const 0
      local.get $w419
      array.new $GcArray_123
      local.set $w420
      local.get $w420
      i32.const 0
      local.get $w418
      i32.const 0
      local.get $w417
      array.copy $GcArray_123 $GcArray_123
      local.get $xs
      local.get $w420
      struct.set $ResizeArray_215 0
    end
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.get $w417
    i32.const 30
    array.set $GcArray_123
    local.get $xs
    local.get $w417
    i32.const 1
    i32.add
    struct.set $ResizeArray_215 1
    local.get $xs
    struct.get $ResizeArray_215 1
  )
  (func $closure_217 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_218 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayUnzip (result i32) ;; exported as "testArrayUnzip"
    (local $pairs (ref $GcArray_194))
    (local $patternInput (ref $Tuple_216))
    (local $w423 i32)
    (local $w424 (ref $GcArray_123))
    (local $w425 (ref $GcArray_123))
    (local $w426 i32)
    (local $w427 (ref $Tuple_62))
    (local $ys (ref $GcArray_123))
    (local $xs (ref $GcArray_123))
    (local $w431 i32)
    (local $w432 i32)
    (local $w433 i32)
    (local $w437 i32)
    (local $w438 i32)
    (local $w439 i32)
    i32.const 1
    i32.const 4
    struct.new $Tuple_62
    i32.const 2
    i32.const 5
    struct.new $Tuple_62
    i32.const 3
    i32.const 6
    struct.new $Tuple_62
    array.new_fixed $GcArray_194 3
    local.set $pairs
    local.get $pairs
    array.len
    local.set $w423
    i32.const 0
    local.get $w423
    array.new $GcArray_123
    local.set $w424
    i32.const 0
    local.get $w423
    array.new $GcArray_123
    local.set $w425
    i32.const 0
    local.set $w426
    block $while_428_exit
      loop $while_428_lp
        local.get $w426
        local.get $w423
        i32.lt_s
        if
          local.get $pairs
          local.get $w426
          array.get $GcArray_194
          local.set $w427
          local.get $w424
          local.get $w426
          local.get $w427
          struct.get $Tuple_62 0
          array.set $GcArray_123
          local.get $w425
          local.get $w426
          local.get $w427
          struct.get $Tuple_62 1
          array.set $GcArray_123
          local.get $w426
          i32.const 1
          i32.add
          local.set $w426
          br $while_428_lp
        else
          br $while_428_exit
        end
      end
    end
    local.get $w424
    local.get $w425
    struct.new $Tuple_216
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_216 1
    local.set $ys
    local.get $patternInput
    struct.get $Tuple_216 0
    local.set $xs
    local.get $xs
    array.len
    local.set $w431
    i32.const 0
    local.set $w432
    i32.const 0
    local.set $w433
    block $while_434_exit
      loop $while_434_lp
        local.get $w433
        local.get $w431
        i32.lt_s
        if
          local.get $w432
          local.get $xs
          local.get $w433
          array.get $GcArray_123
          i32.add
          local.set $w432
          local.get $w433
          i32.const 1
          i32.add
          local.set $w433
          br $while_434_lp
        else
          br $while_434_exit
        end
      end
    end
    local.get $w432
    local.get $ys
    array.len
    local.set $w437
    i32.const 0
    local.set $w438
    i32.const 0
    local.set $w439
    block $while_440_exit
      loop $while_440_lp
        local.get $w439
        local.get $w437
        i32.lt_s
        if
          local.get $w438
          local.get $ys
          local.get $w439
          array.get $GcArray_123
          i32.add
          local.set $w438
          local.get $w439
          i32.const 1
          i32.add
          local.set $w439
          br $while_440_lp
        else
          br $while_440_exit
        end
      end
    end
    local.get $w438
    i32.add
  )
  (func $testResizeArrayIndex (result i32) ;; exported as "testResizeArrayIndex"
    (local $xs (ref $ResizeArray_215))
    (local $w442 i32)
    (local $w443 (ref $GcArray_123))
    (local $w444 i32)
    (local $w445 (ref $GcArray_123))
    (local $w447 i32)
    (local $w448 (ref $GcArray_123))
    (local $w449 i32)
    (local $w450 (ref $GcArray_123))
    (local $w452 i32)
    (local $w453 (ref $GcArray_123))
    (local $w454 i32)
    (local $w455 (ref $GcArray_123))
    i32.const 0
    i32.const 4
    array.new $GcArray_123
    i32.const 0
    struct.new $ResizeArray_215
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_215 1
    local.set $w442
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.set $w443
    local.get $w442
    local.get $w443
    array.len
    i32.ge_u
    if
      local.get $w443
      array.len
      i32.const 1
      i32.shl
      local.set $w444
      i32.const 0
      local.get $w444
      array.new $GcArray_123
      local.set $w445
      local.get $w445
      i32.const 0
      local.get $w443
      i32.const 0
      local.get $w442
      array.copy $GcArray_123 $GcArray_123
      local.get $xs
      local.get $w445
      struct.set $ResizeArray_215 0
    end
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.get $w442
    i32.const 100
    array.set $GcArray_123
    local.get $xs
    local.get $w442
    i32.const 1
    i32.add
    struct.set $ResizeArray_215 1
    local.get $xs
    struct.get $ResizeArray_215 1
    local.set $w447
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.set $w448
    local.get $w447
    local.get $w448
    array.len
    i32.ge_u
    if
      local.get $w448
      array.len
      i32.const 1
      i32.shl
      local.set $w449
      i32.const 0
      local.get $w449
      array.new $GcArray_123
      local.set $w450
      local.get $w450
      i32.const 0
      local.get $w448
      i32.const 0
      local.get $w447
      array.copy $GcArray_123 $GcArray_123
      local.get $xs
      local.get $w450
      struct.set $ResizeArray_215 0
    end
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.get $w447
    i32.const 200
    array.set $GcArray_123
    local.get $xs
    local.get $w447
    i32.const 1
    i32.add
    struct.set $ResizeArray_215 1
    local.get $xs
    struct.get $ResizeArray_215 1
    local.set $w452
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.set $w453
    local.get $w452
    local.get $w453
    array.len
    i32.ge_u
    if
      local.get $w453
      array.len
      i32.const 1
      i32.shl
      local.set $w454
      i32.const 0
      local.get $w454
      array.new $GcArray_123
      local.set $w455
      local.get $w455
      i32.const 0
      local.get $w453
      i32.const 0
      local.get $w452
      array.copy $GcArray_123 $GcArray_123
      local.get $xs
      local.get $w455
      struct.set $ResizeArray_215 0
    end
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    local.get $w452
    i32.const 300
    array.set $GcArray_123
    local.get $xs
    local.get $w452
    i32.const 1
    i32.add
    struct.set $ResizeArray_215 1
    local.get $xs
    struct.get $ResizeArray_215 0
    ref.cast (ref $GcArray_123)
    i32.const 1
    array.get $GcArray_123
  )
  (func $closure_219 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_219
    struct.new $ClosureType_219
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 2
    array.new_fixed $GcArray_123 4
    call $Set_ofArray
    local.set $s
    local.get $s
    return_call $Set_count
  )
  (func $runArrayTests (param $check (ref $AnyFn)) ;; exported as "runArrayTests"
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
  (func $equals_220 (param $eq_a (ref $QuickTestWasmGc_TestsPrimitives_Point)) (param $eq_b (ref $QuickTestWasmGc_TestsPrimitives_Point)) (result i32)
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
    call $equals_220
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
    call $equals_220
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
    call $equals_220
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
  (func $swapPair (param $a i32) (param $b i32) (result (ref $Tuple_62)) ;; exported as "swapPair"
    local.get $b
    local.get $a
    struct.new $Tuple_62
  )
  (func $testSwapPairFst (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairFst"
    (local $patternInput (ref $Tuple_62))
    local.get $a
    local.get $b
    call $swapPair
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_62 0
  )
  (func $testSwapPairSnd (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairSnd"
    (local $patternInput (ref $Tuple_62))
    local.get $a
    local.get $b
    call $swapPair
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_62 1
  )
  (func $minMax (param $a f64) (param $b f64) (result (ref $Tuple_223)) ;; exported as "minMax"
    local.get $a
    local.get $b
    f64.le
    if (result (ref $Tuple_223))
      local.get $a
      local.get $b
      struct.new $Tuple_223
    else
      local.get $b
      local.get $a
      struct.new $Tuple_223
    end
  )
  (func $testMinMaxFirst (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxFirst"
    (local $patternInput (ref $Tuple_223))
    local.get $a
    local.get $b
    call $minMax
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_223 0
  )
  (func $testMinMaxSecond (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxSecond"
    (local $patternInput (ref $Tuple_223))
    local.get $a
    local.get $b
    call $minMax
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_223 1
  )
  (func $tripleSum (param $t_ i32) (param $t__1 i32) (param $t__2 i32) (result i32) ;; exported as "tripleSum"
    (local $t (ref $Tuple_224))
    (local $c i32)
    (local $b i32)
    (local $a i32)
    local.get $t_
    local.get $t__1
    local.get $t__2
    struct.new $Tuple_224
    local.set $t
    local.get $t
    struct.get $Tuple_224 2
    local.set $c
    local.get $t
    struct.get $Tuple_224 1
    local.set $b
    local.get $t
    struct.get $Tuple_224 0
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
  (func $closure_227 (param $self (ref $AnyFn)) (param $x (ref $QuickTestWasmGc_TestsPrimitives_SWItem)) (result i32)
    local.get $x
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
  )
  (func $closure_230 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w461 i32)
    (local $w458 (ref null $ListBase))
    (local $w459 i32)
    (local $w462 (ref $GcArray_231))
    (local $w463 (ref $GcArray_123))
    (local $w464 (ref null $ListBase))
    (local $w465 i32)
    (local $w466 (ref $QuickTestWasmGc_TestsPrimitives_SWItem))
    (local $w467 i32)
    (local $w469 i32)
    (local $w470 (ref $QuickTestWasmGc_TestsPrimitives_SWItem))
    (local $w471 i32)
    (local $w472 i32)
    (local $w475 i32)
    (local $w476 (ref null $ListBase))
    (local $w479 i32)
    (local $w480 (ref null $ListBase))
    (local $w483 i32)
    (local $w484 (ref null $ListBase))
    (local $w487 i32)
    (local $w488 (ref null $ListBase))
    i32.const 3
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    i32.const 1
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    i32.const 2
    struct.new $QuickTestWasmGc_TestsPrimitives_SWItem
    ref.null $ListBase
    struct.new $ListCons_226
    struct.new $ListCons_226
    struct.new $ListCons_226
    local.set $items
    local.get $items
    local.set $w458
    i32.const 0
    local.set $w459
    block $while_460_exit
      loop $while_460_lp
        local.get $w458
        ref.is_null
        i32.eqz
        if
          local.get $w459
          i32.const 1
          i32.add
          local.set $w459
          local.get $w458
          ref.cast (ref $ListCons_226)
          struct.get $ListCons_226 1
          local.set $w458
          br $while_460_lp
        else
          br $while_460_exit
        end
      end
    end
    local.get $w459
    local.set $w461
    ref.null $QuickTestWasmGc_TestsPrimitives_SWItem
    local.get $w461
    array.new $GcArray_231
    local.set $w462
    i32.const 0
    local.get $w461
    array.new $GcArray_123
    local.set $w463
    local.get $items
    local.set $w464
    i32.const 0
    local.set $w465
    block $while_468_exit
      loop $while_468_lp
        local.get $w464
        ref.is_null
        i32.eqz
        if
          local.get $w464
          ref.cast (ref $ListCons_226)
          struct.get $ListCons_226 0
          local.set $w466
          local.get $w466
          struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
          local.set $w467
          local.get $w462
          local.get $w465
          local.get $w466
          array.set $GcArray_231
          local.get $w463
          local.get $w465
          local.get $w467
          array.set $GcArray_123
          local.get $w465
          i32.const 1
          i32.add
          local.set $w465
          local.get $w464
          ref.cast (ref $ListCons_226)
          struct.get $ListCons_226 1
          local.set $w464
          br $while_468_lp
        else
          br $while_468_exit
        end
      end
    end
    local.get $w465
    drop
    i32.const 1
    local.set $w469
    block $while_474_exit
      loop $while_474_lp
        local.get $w469
        local.get $w461
        i32.lt_s
        if
          local.get $w462
          local.get $w469
          array.get $GcArray_231
          local.set $w470
          local.get $w463
          local.get $w469
          array.get $GcArray_123
          local.set $w471
          local.get $w469
          i32.const 1
          i32.sub
          local.set $w472
          block $while_473_exit
            loop $while_473_lp
              local.get $w472
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w463
                local.get $w472
                array.get $GcArray_123
                local.get $w471
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w462
                local.get $w472
                i32.const 1
                i32.add
                local.get $w462
                local.get $w472
                array.get $GcArray_231
                array.set $GcArray_231
                local.get $w463
                local.get $w472
                i32.const 1
                i32.add
                local.get $w463
                local.get $w472
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w472
                i32.const 1
                i32.sub
                local.set $w472
                br $while_473_lp
              else
                br $while_473_exit
              end
            end
          end
          local.get $w462
          local.get $w472
          i32.const 1
          i32.add
          local.get $w470
          array.set $GcArray_231
          local.get $w463
          local.get $w472
          i32.const 1
          i32.add
          local.get $w471
          array.set $GcArray_123
          local.get $w469
          i32.const 1
          i32.add
          local.set $w469
          br $while_474_lp
        else
          br $while_474_exit
        end
      end
    end
    local.get $w461
    i32.const 1
    i32.sub
    local.set $w475
    ref.null $ListBase
    local.set $w476
    block $while_477_exit
      loop $while_477_lp
        local.get $w475
        i32.const 0
        i32.ge_s
        if
          local.get $w462
          local.get $w475
          array.get $GcArray_231
          local.get $w476
          struct.new $ListCons_226
          local.set $w476
          local.get $w475
          i32.const 1
          i32.sub
          local.set $w475
          br $while_477_lp
        else
          br $while_477_exit
        end
      end
    end
    local.get $w476
    local.set $sorted
    i32.const 0
    local.set $w479
    local.get $sorted
    local.set $w480
    block $while_481_exit
      loop $while_481_lp
        local.get $w479
        i32.const 0
        i32.gt_s
        if
          local.get $w480
          ref.cast (ref $ListCons_226)
          struct.get $ListCons_226 1
          local.set $w480
          local.get $w479
          i32.const 1
          i32.sub
          local.set $w479
          br $while_481_lp
        else
          br $while_481_exit
        end
      end
    end
    local.get $w480
    ref.cast (ref $ListCons_226)
    struct.get $ListCons_226 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.const 1
    local.set $w483
    local.get $sorted
    local.set $w484
    block $while_485_exit
      loop $while_485_lp
        local.get $w483
        i32.const 0
        i32.gt_s
        if
          local.get $w484
          ref.cast (ref $ListCons_226)
          struct.get $ListCons_226 1
          local.set $w484
          local.get $w483
          i32.const 1
          i32.sub
          local.set $w483
          br $while_485_lp
        else
          br $while_485_exit
        end
      end
    end
    local.get $w484
    ref.cast (ref $ListCons_226)
    struct.get $ListCons_226 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.add
    i32.const 2
    local.set $w487
    local.get $sorted
    local.set $w488
    block $while_489_exit
      loop $while_489_lp
        local.get $w487
        i32.const 0
        i32.gt_s
        if
          local.get $w488
          ref.cast (ref $ListCons_226)
          struct.get $ListCons_226 1
          local.set $w488
          local.get $w487
          i32.const 1
          i32.sub
          local.set $w487
          br $while_489_lp
        else
          br $while_489_exit
        end
      end
    end
    local.get $w488
    ref.cast (ref $ListCons_226)
    struct.get $ListCons_226 0
    struct.get $QuickTestWasmGc_TestsPrimitives_SWItem 0
    i32.add
  )
  (func $runPrimitivesTests (param $check (ref $AnyFn)) ;; exported as "runPrimitivesTests"
  )
  (func $closure_232 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_234))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_234)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_234 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_234 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_235 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_235))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_235)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_235 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_235 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_236 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_236))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_236)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_236 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_236 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_236
    local.get $a
    struct.new $ClosureType_236
  )
  (func $closure_238 (param $self (ref $AnyFn)) (param $option (ref null $Option_53)) (result i32)
    (local $self_cast (ref $ClosureType_240))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_240)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_240 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      local.get $value_2
    end
  )
  (func $testMapAddFind (result i32) ;; exported as "testMapAddFind"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_37 (ref $ClosureBase_233))
    (local $lo_clo_36 (ref $ClosureBase_233))
    (local $lo_clo_38 (ref $ClosureBase_239))
    ref.func $closure_232
    i32.const 2
    i32.const 200
    struct.new $ClosureType_234
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_37
    local.get $lo_clo_37
    ref.func $closure_235
    i32.const 1
    i32.const 100
    struct.new $ClosureType_235
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_36
    local.get $lo_clo_36
    ref.func $closure_236
    struct.new $ClosureType_237
    call $Map_empty
    local.get $lo_clo_36
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_37
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.set $m_2
    ref.func $closure_238
    i32.const 0
    struct.new $ClosureType_240
    ref.cast (ref $ClosureBase_239)
    local.set $lo_clo_38
    local.get $lo_clo_38
    i32.const 1
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_38
    struct.get $ClosureBase_239 0
    call_ref $FuncType_238
  )
  (func $closure_241 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_241))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_241)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_241 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_241 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_242 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_242))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_242)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_242 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_242 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_242
    local.get $a
    struct.new $ClosureType_242
  )
  (func $closure_244 (param $self (ref $AnyFn)) (param $option (ref null $Option_53)) (result i32)
    (local $self_cast (ref $ClosureType_244))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_244)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_244 1
    local.set $value_1
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      local.get $value_1
    end
  )
  (func $testMapFindMissing (result i32) ;; exported as "testMapFindMissing"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_39 (ref $ClosureBase_233))
    (local $lo_clo_40 (ref $ClosureBase_239))
    ref.func $closure_241
    i32.const 1
    i32.const 100
    struct.new $ClosureType_241
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_39
    local.get $lo_clo_39
    ref.func $closure_242
    struct.new $ClosureType_243
    call $Map_empty
    local.get $lo_clo_39
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.set $m_1
    ref.func $closure_244
    i32.const 0
    struct.new $ClosureType_244
    ref.cast (ref $ClosureBase_239)
    local.set $lo_clo_40
    local.get $lo_clo_40
    i32.const 99
    local.get $m_1
    call $Map_tryFind
    local.get $lo_clo_40
    struct.get $ClosureBase_239 0
    call_ref $FuncType_238
  )
  (func $closure_245 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_245))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_245)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_245 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_245 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_246 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
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
    local.get $m
    call $Map_add
  )
  (func $closure_247 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_247))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_247)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_247 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_247 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_247
    local.get $a
    struct.new $ClosureType_247
  )
  (func $testMapCount (result i32) ;; exported as "testMapCount"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_42 (ref $ClosureBase_233))
    (local $lo_clo_41 (ref $ClosureBase_233))
    ref.func $closure_245
    i32.const 2
    i32.const 200
    struct.new $ClosureType_245
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_42
    local.get $lo_clo_42
    ref.func $closure_246
    i32.const 1
    i32.const 100
    struct.new $ClosureType_246
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_41
    local.get $lo_clo_41
    ref.func $closure_247
    struct.new $ClosureType_248
    call $Map_empty
    local.get $lo_clo_41
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_42
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.set $m_2
    local.get $m_2
    return_call $Map_count
  )
  (func $closure_249 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_249))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_249)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_249 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_249 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_250 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_250))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_250)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_250 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_250 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_250
    local.get $a
    struct.new $ClosureType_250
  )
  (func $testMapContainsKey (result i32) ;; exported as "testMapContainsKey"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_43 (ref $ClosureBase_233))
    ref.func $closure_249
    i32.const 42
    i32.const 999
    struct.new $ClosureType_249
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_43
    local.get $lo_clo_43
    ref.func $closure_250
    struct.new $ClosureType_251
    call $Map_empty
    local.get $lo_clo_43
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
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
  (func $closure_252 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_252))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_252)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_252 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_252 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_253 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_253))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_253)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_253 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_253 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_253
    local.get $a
    struct.new $ClosureType_253
  )
  (func $testMapContainsKeyMissing (result i32) ;; exported as "testMapContainsKeyMissing"
    (local $m_1 (ref $MapModule_MapHandle`2))
    (local $lo_clo_44 (ref $ClosureBase_233))
    ref.func $closure_252
    i32.const 42
    i32.const 999
    struct.new $ClosureType_252
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_44
    local.get $lo_clo_44
    ref.func $closure_253
    struct.new $ClosureType_254
    call $Map_empty
    local.get $lo_clo_44
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
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
  (func $closure_255 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_255))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_255)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_255 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_255 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_256 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_256))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_256)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_256 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_256 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_257 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_257))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_257)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_257 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_257 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_257
    local.get $a
    struct.new $ClosureType_257
  )
  (func $closure_259 (param $self (ref $AnyFn)) (param $option (ref null $Option_53)) (result i32)
    (local $self_cast (ref $ClosureType_259))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_259)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_259 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      local.get $value_2
    end
  )
  (func $testMapAddReplace (result i32) ;; exported as "testMapAddReplace"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_46 (ref $ClosureBase_233))
    (local $lo_clo_45 (ref $ClosureBase_233))
    (local $lo_clo_47 (ref $ClosureBase_239))
    ref.func $closure_255
    i32.const 1
    i32.const 555
    struct.new $ClosureType_255
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_46
    local.get $lo_clo_46
    ref.func $closure_256
    i32.const 1
    i32.const 100
    struct.new $ClosureType_256
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_45
    local.get $lo_clo_45
    ref.func $closure_257
    struct.new $ClosureType_258
    call $Map_empty
    local.get $lo_clo_45
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_46
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.set $m_2
    ref.func $closure_259
    i32.const 0
    struct.new $ClosureType_259
    ref.cast (ref $ClosureBase_239)
    local.set $lo_clo_47
    local.get $lo_clo_47
    i32.const 1
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_47
    struct.get $ClosureBase_239 0
    call_ref $FuncType_238
  )
  (func $closure_260 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_260
    struct.new $ClosureType_260
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    i32.const 2
    local.get $m
    return_call $Map_find
  )
  (func $closure_261 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_262 (param $self (ref $AnyFn)) (param $option (ref null $Option_53)) (result i32)
    (local $self_cast (ref $ClosureType_262))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_262)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_262 1
    local.set $value
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      local.get $value
    end
  )
  (func $testStdMapTryFind (result i32) ;; exported as "testStdMapTryFind"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_48 (ref $ClosureBase_239))
    ref.func $closure_261
    struct.new $ClosureType_261
    i32.const 10
    i32.const 100
    struct.new $Tuple_62
    i32.const 20
    i32.const 200
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_262
    i32.const 0
    struct.new $ClosureType_262
    ref.cast (ref $ClosureBase_239)
    local.set $lo_clo_48
    local.get $lo_clo_48
    i32.const 20
    local.get $m
    call $Map_tryFind
    local.get $lo_clo_48
    struct.get $ClosureBase_239 0
    call_ref $FuncType_238
  )
  (func $closure_263 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_264 (param $self (ref $AnyFn)) (param $option (ref null $Option_53)) (result i32)
    (local $self_cast (ref $ClosureType_264))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_264)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_264 1
    local.set $value
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      local.get $value
    end
  )
  (func $testStdMapTryFindMissing (result i32) ;; exported as "testStdMapTryFindMissing"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_49 (ref $ClosureBase_239))
    ref.func $closure_263
    struct.new $ClosureType_263
    i32.const 1
    i32.const 1
    struct.new $Tuple_62
    i32.const 2
    i32.const 2
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_264
    i32.const 0
    struct.new $ClosureType_264
    ref.cast (ref $ClosureBase_239)
    local.set $lo_clo_49
    local.get $lo_clo_49
    i32.const 99
    local.get $m
    call $Map_tryFind
    local.get $lo_clo_49
    struct.get $ClosureBase_239 0
    call_ref $FuncType_238
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
  (func $testStdMapContainsKey (result i32) ;; exported as "testStdMapContainsKey"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_265
    struct.new $ClosureType_265
    i32.const 5
    i32.const 50
    struct.new $Tuple_62
    i32.const 6
    i32.const 60
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
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
  (func $closure_266 (param $self (ref $AnyFn)) (param $table i32) (result i32)
    (local $self_cast (ref $ClosureType_266))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_266)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_266 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_266 2
    local.set $value
    local.get $key
    local.get $value
    local.get $table
    call $Map_add
  )
  (func $closure_267 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $lo_clo_50 (ref $ClosureBase_643))
    ref.func $closure_266
    i32.const 2
    i32.const 20
    struct.new $ClosureType_266
    ref.cast (ref $ClosureBase_643)
    local.set $lo_clo_50
    local.get $lo_clo_50
    ref.func $closure_267
    struct.new $ClosureType_267
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    call $Map_ofList
    local.get $lo_clo_50
    struct.get $ClosureBase_643 0
    call_ref $FuncType_268
    local.set $m
    i32.const 2
    local.get $m
    return_call $Map_find
  )
  (func $closure_269 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_270 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_269
    struct.new $ClosureType_269
    ref.null $ListBase
    call $Map_ofList
    local.set $e
    ref.func $closure_270
    struct.new $ClosureType_270
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    local.get $e
    call $Map_count
    local.get $m
    call $Map_count
    i32.add
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
  (func $testMapRemove (result i32) ;; exported as "testMapRemove"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_271
    struct.new $ClosureType_271
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    i32.const 2
    local.get $m
    call $Map_remove
    local.set $m2
    local.get $m2
    return_call $Map_count
  )
  (func $closure_272 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_272
    struct.new $ClosureType_272
    i32.const 10
    i32.const 100
    struct.new $Tuple_62
    i32.const 20
    i32.const 200
    struct.new $Tuple_62
    i32.const 30
    i32.const 300
    struct.new $Tuple_62
    i32.const 40
    i32.const 400
    struct.new $Tuple_62
    i32.const 50
    i32.const 500
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    i32.const 30
    local.get $m
    return_call $Map_find
  )
  (func $closure_273 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
                ref.func $closure_273
                struct.new $ClosureType_273
                i32.const 1
                i32.const 10
                struct.new $Tuple_62
                i32.const 2
                i32.const 20
                struct.new $Tuple_62
                ref.null $ListBase
                struct.new $ListCons_63
                struct.new $ListCons_63
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
  (func $closure_274 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_275 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_275))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_275)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_275 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_275 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_276))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_276)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_276 1
    local.set $acc
    ref.func $closure_275
    local.get $acc
    struct.new $ClosureType_275
  )
  (func $closure_275 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_275
    local.get $acc
    struct.new $ClosureType_276
  )
  (func $testMapFold (result i32) ;; exported as "testMapFold"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_274
    struct.new $ClosureType_274
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_275
    struct.new $ClosureType_277
    i32.const 0
    local.get $m
    return_call $Map_fold
  )
  (func $closure_278 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_279 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_279))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_279)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_279 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_279 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_280))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_280)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_280 1
    local.set $acc
    ref.func $closure_279
    local.get $acc
    struct.new $ClosureType_279
  )
  (func $closure_279 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_279
    local.get $acc
    struct.new $ClosureType_280
  )
  (func $testMapIter (result i32) ;; exported as "testMapIter"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_278
    struct.new $ClosureType_278
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_279
    struct.new $ClosureType_281
    i32.const 0
    local.get $m
    return_call $Map_fold
  )
  (func $closure_282 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_283 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 15
    i32.gt_s
  )
  (func $closure_283 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_283
    struct.new $ClosureType_283
  )
  (func $testMapFilter (result i32) ;; exported as "testMapFilter"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_282
    struct.new $ClosureType_282
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_283
    struct.new $ClosureType_284
    local.get $m
    call $Map_filter
    local.set $m2
    local.get $m2
    return_call $Map_count
  )
  (func $closure_285 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_286 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 25
    i32.gt_s
  )
  (func $closure_286 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_286
    struct.new $ClosureType_286
  )
  (func $testMapExists (result i32) ;; exported as "testMapExists"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_285
    struct.new $ClosureType_285
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_286
    struct.new $ClosureType_287
    local.get $m
    call $Map_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_288 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_289 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 10
    i32.ge_s
  )
  (func $closure_289 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_289
    struct.new $ClosureType_289
  )
  (func $testMapForall (result i32) ;; exported as "testMapForall"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_288
    struct.new $ClosureType_288
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_289
    struct.new $ClosureType_290
    local.get $m
    call $Map_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_291 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_292 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 1
    i32.shl
  )
  (func $closure_292 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    ref.func $closure_292
    struct.new $ClosureType_292
  )
  (func $testMapMap (result i32) ;; exported as "testMapMap"
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_291
    struct.new $ClosureType_291
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_292
    struct.new $ClosureType_293
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
  (func $closure_294 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_294))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_294)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_294 1
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
  (func $closure_294 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_294
    local.get $a
    struct.new $ClosureType_294
  )
  (func $closure_296 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_297 (param $self (ref $AnyFn)) (param $m_3 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_297))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_297)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_297 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_297 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_3
    call $Map_add
  )
  (func $closure_298 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_298))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_298)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_298 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_298 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_2
    call $Map_add
  )
  (func $closure_299 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_299))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_299)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_299 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_299 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m_1
    call $Map_add
  )
  (func $closure_300 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_300))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_300)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_300 1
    local.set $acc
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_300 (param $self (ref $AnyFn)) (param $_k i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_301))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_301)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_301 1
    local.set $acc
    ref.func $closure_300
    local.get $acc
    struct.new $ClosureType_300
  )
  (func $closure_300 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_300
    local.get $acc
    struct.new $ClosureType_301
  )
  (func $testMapCustomCmpReverse (result i32) ;; exported as "testMapCustomCmpReverse"
    (local $reverseCmp (ref $ClosureType_295))
    (local $m (ref $MapModule_MapHandle`2))
    (local $m2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_53 (ref $ClosureBase_233))
    (local $lo_clo_52 (ref $ClosureBase_233))
    (local $lo_clo_51 (ref $ClosureBase_233))
    ref.func $closure_294
    struct.new $ClosureType_295
    local.set $reverseCmp
    ref.func $closure_296
    struct.new $ClosureType_296
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_297
    i32.const 3
    i32.const 30
    struct.new $ClosureType_297
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_53
    local.get $lo_clo_53
    ref.func $closure_298
    i32.const 2
    i32.const 20
    struct.new $ClosureType_298
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_52
    local.get $lo_clo_52
    ref.func $closure_299
    i32.const 1
    i32.const 10
    struct.new $ClosureType_299
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_51
    local.get $lo_clo_51
    local.get $reverseCmp
    call $Map_empty
    local.get $lo_clo_51
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_52
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_53
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.set $m2
    ref.func $closure_300
    struct.new $ClosureType_302
    i32.const 0
    local.get $m2
    return_call $Map_fold
  )
  (func $closure_303 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_303))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_303)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_303 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_303 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_304 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_304))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_304)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_304 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_304 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_305 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_305))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_305)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_305 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_305 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_306 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_306))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_306)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_306 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_306 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_306
    local.get $a
    struct.new $ClosureType_306
  )
  (func $testMapModuleContainsKey (result i32) ;; exported as "testMapModuleContainsKey"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_56 (ref $ClosureBase_233))
    (local $lo_clo_55 (ref $ClosureBase_233))
    (local $lo_clo_54 (ref $ClosureBase_233))
    ref.func $closure_303
    i32.const 30
    i32.const 300
    struct.new $ClosureType_303
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_56
    local.get $lo_clo_56
    ref.func $closure_304
    i32.const 20
    i32.const 200
    struct.new $ClosureType_304
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_55
    local.get $lo_clo_55
    ref.func $closure_305
    i32.const 10
    i32.const 100
    struct.new $ClosureType_305
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_54
    local.get $lo_clo_54
    ref.func $closure_306
    struct.new $ClosureType_307
    call $Map_empty
    local.get $lo_clo_54
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_55
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_56
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
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
  (func $closure_308 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_308))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_308)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_308 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_308 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_309 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_309))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_309)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_309 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_309 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_310 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_310))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_310)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_310 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_310 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_310
    local.get $a
    struct.new $ClosureType_310
  )
  (func $closure_312 (param $self (ref $AnyFn)) (param $option (ref null $Option_53)) (result i32)
    (local $self_cast (ref $ClosureType_312))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_312)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_312 1
    local.set $value_2
    local.get $option
    ref.is_null
    if (result i32)
      local.get $option
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    else
      local.get $value_2
    end
  )
  (func $testMapModuleFindRoundTrip (result i32) ;; exported as "testMapModuleFindRoundTrip"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $lo_clo_58 (ref $ClosureBase_233))
    (local $lo_clo_57 (ref $ClosureBase_233))
    (local $lo_clo_59 (ref $ClosureBase_239))
    ref.func $closure_308
    i32.const 8
    i32.const 88
    struct.new $ClosureType_308
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_58
    local.get $lo_clo_58
    ref.func $closure_309
    i32.const 7
    i32.const 77
    struct.new $ClosureType_309
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_57
    local.get $lo_clo_57
    ref.func $closure_310
    struct.new $ClosureType_311
    call $Map_empty
    local.get $lo_clo_57
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_58
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.set $m_2
    i32.const 7
    local.get $m_2
    call $Map_find
    ref.func $closure_312
    i32.const 0
    struct.new $ClosureType_312
    ref.cast (ref $ClosureBase_239)
    local.set $lo_clo_59
    local.get $lo_clo_59
    i32.const 8
    local.get $m_2
    call $Map_tryFind
    local.get $lo_clo_59
    struct.get $ClosureBase_239 0
    call_ref $FuncType_238
    i32.add
  )
  (func $closure_313 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_313))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_313)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_313 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_313 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_314 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_314))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_314)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_314 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_314 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_315 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_315))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_315)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_315 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_315 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_316 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_316))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_316)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_316 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_316 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_316
    local.get $a
    struct.new $ClosureType_316
  )
  (func $testMapModuleRemove (result i32) ;; exported as "testMapModuleRemove"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_62 (ref $ClosureBase_233))
    (local $lo_clo_61 (ref $ClosureBase_233))
    (local $lo_clo_60 (ref $ClosureBase_233))
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_313
    i32.const 3
    i32.const 30
    struct.new $ClosureType_313
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_62
    local.get $lo_clo_62
    ref.func $closure_314
    i32.const 2
    i32.const 20
    struct.new $ClosureType_314
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_61
    local.get $lo_clo_61
    ref.func $closure_315
    i32.const 1
    i32.const 10
    struct.new $ClosureType_315
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_60
    local.get $lo_clo_60
    ref.func $closure_316
    struct.new $ClosureType_317
    call $Map_empty
    local.get $lo_clo_60
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_61
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_62
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
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
  (func $closure_324 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testResultMap (result i32) ;; exported as "testResultMap"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w496 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 21
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w496
    local.get $w496
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w496
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.shl
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w496
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
  (func $closure_325 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBind (result i32) ;; exported as "testResultBind"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w497 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 5
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w497
    local.get $w497
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w497
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w497
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
  (func $closure_328 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBindError (result i32) ;; exported as "testResultBindError"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w498 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 1
    i32.const -99
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    local.set $w498
    local.get $w498
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w498
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w498
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
  (func $closure_329 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_331))
    (local $clo (ref $AnyFn))
    (local $lo_clo_63 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_331)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_331 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_63
    local.get $lo_clo_63
    local.get $arg
    local.get $lo_clo_63
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfInt (result i32) ;; exported as "testSprintfInt"
    (local $lo_clo_64 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_329
    local.get $clo
    struct.new $ClosureType_331
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_64
    local.get $lo_clo_64
    i32.const 42
    local.get $lo_clo_64
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    array.len
  )
  (func $closure_332 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_332))
    (local $clo (ref $AnyFn))
    (local $lo_clo_65 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_332)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_332 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_65
    local.get $lo_clo_65
    local.get $arg
    local.get $lo_clo_65
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfNegInt (result i32) ;; exported as "testSprintfNegInt"
    (local $lo_clo_66 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_332
    local.get $clo
    struct.new $ClosureType_332
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_66
    local.get $lo_clo_66
    i32.const -7
    local.get $lo_clo_66
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    array.len
  )
  (func $closure_333 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_335))
    (local $clo (ref $AnyFn))
    (local $lo_clo_67 (ref $ClosureBase_334))
    local.get $self
    ref.cast (ref $ClosureType_335)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_335 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_334)
    local.set $lo_clo_67
    local.get $lo_clo_67
    local.get $arg
    local.get $lo_clo_67
    struct.get $ClosureBase_334 0
    call_ref $FuncType_333
  )
  (func $testSprintfStr (result i32) ;; exported as "testSprintfStr"
    (local $lo_clo_68 (ref $ClosureBase_334))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_333
    local.get $clo
    struct.new $ClosureType_335
    ref.cast (ref $ClosureBase_334)
    local.set $lo_clo_68
    local.get $lo_clo_68
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    local.get $lo_clo_68
    struct.get $ClosureBase_334 0
    call_ref $FuncType_333
    array.len
  )
  (func $closure_336 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_336))
    (local $clo (ref $AnyFn))
    (local $lo_clo_69 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_336)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_336 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_69
    local.get $lo_clo_69
    local.get $arg
    local.get $lo_clo_69
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfIntLiteral (result i32) ;; exported as "testSprintfIntLiteral"
    (local $lo_clo_70 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 120
    i32.const 61
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 4
    local.set $clo
    ref.func $closure_336
    local.get $clo
    struct.new $ClosureType_336
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_70
    local.get $lo_clo_70
    i32.const 100
    local.get $lo_clo_70
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    array.len
  )
  (func $closure_337 (param $self (ref $AnyFn)) (param $arg_1 i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_337))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_71 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_337)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_337 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_71
    local.get $lo_clo_71
    local.get $arg_1
    local.get $lo_clo_71
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $closure_337 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_338))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_72 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_338)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_338 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_72
    local.get $lo_clo_72
    local.get $arg
    local.get $lo_clo_72
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_1
    ref.func $closure_337
    local.get $clo_1
    struct.new $ClosureType_337
  )
  (func $testSprintfTwoInts (result i32) ;; exported as "testSprintfTwoInts"
    (local $lo_clo_73 (ref $ClosureType_338))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    i32.const 32
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 5
    local.set $clo
    ref.func $closure_337
    local.get $clo
    struct.new $ClosureType_338
    local.set $lo_clo_73
    local.get $lo_clo_73
    i32.const 3
    i32.const 7
    local.get $lo_clo_73
    struct.get $AnyFn 0
    call_ref $FuncType_339
    array.len
  )
  (func $closure_342 (param $self (ref $AnyFn)) (param $arg_1 (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_342))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_74 (ref $ClosureBase_334))
    local.get $self
    ref.cast (ref $ClosureType_342)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_342 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_334)
    local.set $lo_clo_74
    local.get $lo_clo_74
    local.get $arg_1
    local.get $lo_clo_74
    struct.get $ClosureBase_334 0
    call_ref $FuncType_333
  )
  (func $closure_341 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_344))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_75 (ref $ClosureBase_343))
    local.get $self
    ref.cast (ref $ClosureType_344)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_344 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_343)
    local.set $lo_clo_75
    local.get $lo_clo_75
    local.get $arg
    local.get $lo_clo_75
    struct.get $ClosureBase_343 0
    call_ref $FuncType_341
    local.set $clo_1
    ref.func $closure_342
    local.get $clo_1
    struct.new $ClosureType_342
  )
  (func $testSprintfTwoStrs (result i32) ;; exported as "testSprintfTwoStrs"
    (local $lo_clo_76 (ref $ClosureType_344))
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
    ref.func $closure_341
    local.get $clo
    struct.new $ClosureType_344
    local.set $lo_clo_76
    local.get $lo_clo_76
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    local.get $lo_clo_76
    struct.get $AnyFn 0
    call_ref $FuncType_345
    array.len
  )
  (func $closure_346 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_346))
    (local $clo (ref $AnyFn))
    (local $lo_clo_77 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_346)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_346 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_77
    local.get $lo_clo_77
    local.get $arg
    local.get $lo_clo_77
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfBoolTrue (result i32) ;; exported as "testSprintfBoolTrue"
    (local $lo_clo_78 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 98
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_346
    local.get $clo
    struct.new $ClosureType_346
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_78
    local.get $lo_clo_78
    i32.const 1
    local.get $lo_clo_78
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    array.len
  )
  (func $closure_347 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_347))
    (local $clo (ref $AnyFn))
    (local $lo_clo_79 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_347)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_347 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_79
    local.get $lo_clo_79
    local.get $arg
    local.get $lo_clo_79
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfBoolFalse (result i32) ;; exported as "testSprintfBoolFalse"
    (local $lo_clo_80 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 98
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_347
    local.get $clo
    struct.new $ClosureType_347
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_80
    local.get $lo_clo_80
    i32.const 0
    local.get $lo_clo_80
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    array.len
  )
  (func $closure_349 (param $self (ref $AnyFn)) (param $arg_1 (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_349))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_81 (ref $ClosureBase_334))
    local.get $self
    ref.cast (ref $ClosureType_349)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_349 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_334)
    local.set $lo_clo_81
    local.get $lo_clo_81
    local.get $arg_1
    local.get $lo_clo_81
    struct.get $ClosureBase_334 0
    call_ref $FuncType_333
  )
  (func $closure_349 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_350))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_82 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_350)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_350 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_82
    local.get $lo_clo_82
    local.get $arg
    local.get $lo_clo_82
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_1
    ref.func $closure_349
    local.get $clo_1
    struct.new $ClosureType_349
  )
  (func $testSprintfMixed (result i32) ;; exported as "testSprintfMixed"
    (local $lo_clo_83 (ref $ClosureType_350))
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
    ref.func $closure_349
    local.get $clo
    struct.new $ClosureType_350
    local.set $lo_clo_83
    local.get $lo_clo_83
    i32.const 7
    i32.const 104
    i32.const 105
    array.new_fixed $WasmStr 2
    local.get $lo_clo_83
    struct.get $AnyFn 0
    call_ref $FuncType_351
    array.len
  )
  (func $closure_352 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_352))
    (local $clo (ref $AnyFn))
    (local $lo_clo_84 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_352)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_352 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_84
    local.get $lo_clo_84
    local.get $arg
    local.get $lo_clo_84
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfZero (result i32) ;; exported as "testSprintfZero"
    (local $lo_clo_85 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_352
    local.get $clo
    struct.new $ClosureType_352
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_85
    local.get $lo_clo_85
    i32.const 0
    local.get $lo_clo_85
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_353 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_353))
    (local $clo (ref $AnyFn))
    (local $lo_clo_86 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_353)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_353 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_86
    local.get $lo_clo_86
    local.get $arg
    local.get $lo_clo_86
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfPrefix (result i32) ;; exported as "testSprintfPrefix"
    (local $lo_clo_87 (ref $ClosureBase_330))
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
    ref.func $closure_353
    local.get $clo
    struct.new $ClosureType_353
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_87
    local.get $lo_clo_87
    i32.const 99
    local.get $lo_clo_87
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_354 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_356))
    (local $clo (ref $AnyFn))
    (local $lo_clo_88 (ref $ClosureBase_355))
    local.get $self
    ref.cast (ref $ClosureType_356)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_356 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_88
    local.get $lo_clo_88
    local.get $arg
    local.get $lo_clo_88
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
  )
  (func $testSprintfFloat (result i32) ;; exported as "testSprintfFloat"
    (local $lo_clo_89 (ref $ClosureBase_355))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_354
    local.get $clo
    struct.new $ClosureType_356
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_89
    local.get $lo_clo_89
    f64.const 3.1400000000000001
    local.get $lo_clo_89
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
    array.len
  )
  (func $closure_357 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_357))
    (local $clo (ref $AnyFn))
    (local $lo_clo_90 (ref $ClosureBase_355))
    local.get $self
    ref.cast (ref $ClosureType_357)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_357 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_90
    local.get $lo_clo_90
    local.get $arg
    local.get $lo_clo_90
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
  )
  (func $testSprintfFloatHalf (result i32) ;; exported as "testSprintfFloatHalf"
    (local $lo_clo_91 (ref $ClosureBase_355))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_357
    local.get $clo
    struct.new $ClosureType_357
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_91
    local.get $lo_clo_91
    f64.const 0.5
    local.get $lo_clo_91
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
    array.len
  )
  (func $closure_358 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_358))
    (local $clo (ref $AnyFn))
    (local $lo_clo_92 (ref $ClosureBase_355))
    local.get $self
    ref.cast (ref $ClosureType_358)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_358 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_92
    local.get $lo_clo_92
    local.get $arg
    local.get $lo_clo_92
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
  )
  (func $testSprintfFloatWhole (result i32) ;; exported as "testSprintfFloatWhole"
    (local $lo_clo_93 (ref $ClosureBase_355))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_358
    local.get $clo
    struct.new $ClosureType_358
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_93
    local.get $lo_clo_93
    f64.const 2
    local.get $lo_clo_93
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
    array.len
  )
  (func $closure_359 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_359))
    (local $clo (ref $AnyFn))
    (local $lo_clo_94 (ref $ClosureBase_355))
    local.get $self
    ref.cast (ref $ClosureType_359)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_359 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_94
    local.get $lo_clo_94
    local.get $arg
    local.get $lo_clo_94
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
  )
  (func $testSprintfFloatNeg (result i32) ;; exported as "testSprintfFloatNeg"
    (local $lo_clo_95 (ref $ClosureBase_355))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_359
    local.get $clo
    struct.new $ClosureType_359
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_95
    local.get $lo_clo_95
    f64.const -1.5
    local.get $lo_clo_95
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
    array.len
  )
  (func $closure_360 (param $self (ref $AnyFn)) (param $arg f64) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_360))
    (local $clo (ref $AnyFn))
    (local $lo_clo_96 (ref $ClosureBase_355))
    local.get $self
    ref.cast (ref $ClosureType_360)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_360 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_96
    local.get $lo_clo_96
    local.get $arg
    local.get $lo_clo_96
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
  )
  (func $testSprintfFloatInStr (result i32) ;; exported as "testSprintfFloatInStr"
    (local $lo_clo_97 (ref $ClosureBase_355))
    (local $clo (ref $WasmStr))
    i32.const 112
    i32.const 105
    i32.const 61
    i32.const 126
    i32.const 37
    i32.const 102
    array.new_fixed $WasmStr 6
    local.set $clo
    ref.func $closure_360
    local.get $clo
    struct.new $ClosureType_360
    ref.cast (ref $ClosureBase_355)
    local.set $lo_clo_97
    local.get $lo_clo_97
    f64.const 3.1415899999999999
    local.get $lo_clo_97
    struct.get $ClosureBase_355 0
    call_ref $FuncType_354
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_361 (param $self (ref $AnyFn)) (param $arg i32)
    (local $self_cast (ref $ClosureType_361))
    (local $clo (ref $AnyFn))
    (local $lo_clo_98 (ref $ClosureBase_169))
    local.get $self
    ref.cast (ref $ClosureType_361)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_361 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_169)
    local.set $lo_clo_98
    local.get $lo_clo_98
    local.get $arg
    local.get $lo_clo_98
    struct.get $ClosureBase_169 0
    call_ref $FuncType_104
  )
  (func $testPrintfnInt (result i32) ;; exported as "testPrintfnInt"
    (local $lo_clo_99 (ref $ClosureBase_169))
    (local $clo i32)
    ref.func $closure_361
    local.get $clo
    struct.new $ClosureType_361
    ref.cast (ref $ClosureBase_169)
    local.set $lo_clo_99
    local.get $lo_clo_99
    i32.const 42
    local.get $lo_clo_99
    struct.get $ClosureBase_169 0
    call_ref $FuncType_104
    i32.const 1
  )
  (func $closure_362 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr))
    (local $self_cast (ref $ClosureType_364))
    (local $clo (ref $AnyFn))
    (local $lo_clo_100 (ref $ClosureBase_363))
    local.get $self
    ref.cast (ref $ClosureType_364)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_364 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_363)
    local.set $lo_clo_100
    local.get $lo_clo_100
    local.get $arg
    local.get $lo_clo_100
    struct.get $ClosureBase_363 0
    call_ref $FuncType_362
  )
  (func $testPrintfnStr (result i32) ;; exported as "testPrintfnStr"
    (local $lo_clo_101 (ref $ClosureBase_363))
    (local $clo i32)
    ref.func $closure_362
    local.get $clo
    struct.new $ClosureType_364
    ref.cast (ref $ClosureBase_363)
    local.set $lo_clo_101
    local.get $lo_clo_101
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    local.get $lo_clo_101
    struct.get $ClosureBase_363 0
    call_ref $FuncType_362
    i32.const 1
  )
  (func $closure_365 (param $self (ref $AnyFn)) (param $arg_2 i32)
    (local $self_cast (ref $ClosureType_365))
    (local $clo_2 (ref $AnyFn))
    (local $lo_clo_102 (ref $ClosureBase_169))
    local.get $self
    ref.cast (ref $ClosureType_365)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_365 1
    local.set $clo_2
    local.get $clo_2
    ref.cast (ref $ClosureBase_169)
    local.set $lo_clo_102
    local.get $lo_clo_102
    local.get $arg_2
    local.get $lo_clo_102
    struct.get $ClosureBase_169 0
    call_ref $FuncType_104
  )
  (func $closure_365 (param $self (ref $AnyFn)) (param $arg_1 i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_366))
    (local $clo_1 (ref $AnyFn))
    (local $clo_2 (ref $AnyFn))
    (local $lo_clo_103 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_366)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_366 1
    local.set $clo_1
    local.get $clo_1
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_103
    local.get $lo_clo_103
    local.get $arg_1
    local.get $lo_clo_103
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_2
    ref.func $closure_365
    local.get $clo_2
    struct.new $ClosureType_365
  )
  (func $closure_365 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_367))
    (local $clo (ref $AnyFn))
    (local $clo_1 (ref $AnyFn))
    (local $lo_clo_104 (ref $ClosureBase_44))
    local.get $self
    ref.cast (ref $ClosureType_367)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_367 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_44)
    local.set $lo_clo_104
    local.get $lo_clo_104
    local.get $arg
    local.get $lo_clo_104
    struct.get $ClosureBase_44 0
    call_ref $FuncType_43
    local.set $clo_1
    ref.func $closure_365
    local.get $clo_1
    struct.new $ClosureType_366
  )
  (func $testPrintfnMulti (result i32) ;; exported as "testPrintfnMulti"
    (local $lo_clo_105 (ref $ClosureBase_644))
    (local $clo i32)
    ref.func $closure_365
    local.get $clo
    struct.new $ClosureType_367
    ref.cast (ref $ClosureBase_644)
    local.set $lo_clo_105
    local.get $lo_clo_105
    i32.const 3
    i32.const 7
    i32.const 10
    local.get $lo_clo_105
    struct.get $ClosureBase_644 0
    call_ref $FuncType_368
    i32.const 1
  )
  (func $closure_369 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_369))
    (local $clo (ref $AnyFn))
    (local $lo_clo_106 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_369)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_369 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_106
    local.get $lo_clo_106
    local.get $arg
    local.get $lo_clo_106
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfI (result i32) ;; exported as "testSprintfI"
    (local $lo_clo_107 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 105
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_369
    local.get $clo
    struct.new $ClosureType_369
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_107
    local.get $lo_clo_107
    i32.const 99
    local.get $lo_clo_107
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
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
  (func $closure_370 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_370))
    (local $clo (ref $AnyFn))
    (local $lo_clo_108 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_370)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_370 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_108
    local.get $lo_clo_108
    local.get $arg
    local.get $lo_clo_108
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfIntZeroChar (result i32) ;; exported as "testSprintfIntZeroChar"
    (local $lo_clo_109 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_370
    local.get $clo
    struct.new $ClosureType_370
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_109
    local.get $lo_clo_109
    i32.const 0
    local.get $lo_clo_109
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_371 (param $self (ref $AnyFn)) (param $arg (ref $WasmStr)) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_371))
    (local $clo (ref $AnyFn))
    (local $lo_clo_110 (ref $ClosureBase_334))
    local.get $self
    ref.cast (ref $ClosureType_371)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_371 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_334)
    local.set $lo_clo_110
    local.get $lo_clo_110
    local.get $arg
    local.get $lo_clo_110
    struct.get $ClosureBase_334 0
    call_ref $FuncType_333
  )
  (func $testSprintfEmptyStr (result i32) ;; exported as "testSprintfEmptyStr"
    (local $lo_clo_111 (ref $ClosureBase_334))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 115
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_371
    local.get $clo
    struct.new $ClosureType_371
    ref.cast (ref $ClosureBase_334)
    local.set $lo_clo_111
    local.get $lo_clo_111
    array.new_fixed $WasmStr 0
    local.get $lo_clo_111
    struct.get $ClosureBase_334 0
    call_ref $FuncType_333
    array.len
  )
  (func $closure_372 (param $self (ref $AnyFn)) (param $arg i32) (result (ref $WasmStr))
    (local $self_cast (ref $ClosureType_372))
    (local $clo (ref $AnyFn))
    (local $lo_clo_112 (ref $ClosureBase_330))
    local.get $self
    ref.cast (ref $ClosureType_372)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_372 1
    local.set $clo
    local.get $clo
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_112
    local.get $lo_clo_112
    local.get $arg
    local.get $lo_clo_112
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
  )
  (func $testSprintfIntFirstChar (result i32) ;; exported as "testSprintfIntFirstChar"
    (local $lo_clo_113 (ref $ClosureBase_330))
    (local $clo (ref $WasmStr))
    i32.const 37
    i32.const 100
    array.new_fixed $WasmStr 2
    local.set $clo
    ref.func $closure_372
    local.get $clo
    struct.new $ClosureType_372
    ref.cast (ref $ClosureBase_330)
    local.set $lo_clo_113
    local.get $lo_clo_113
    i32.const 42
    local.get $lo_clo_113
    struct.get $ClosureBase_330 0
    call_ref $FuncType_329
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
  (func $closure_373 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_373))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_373)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_373 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_373 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_373
    local.get $acc
    struct.new $ClosureType_373
  )
  (func $testListFoldSum (result i32) ;; exported as "testListFoldSum"
    (local $xs (ref null $ListBase))
    (local $w500 (ref null $ListBase))
    (local $w501 i32)
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
    local.set $w500
    i32.const 0
    local.set $w501
    block $while_502_exit
      loop $while_502_lp
        local.get $w500
        ref.is_null
        i32.eqz
        if
          local.get $w500
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $w501
          local.get $x
          i32.add
          local.set $w501
          local.get $w500
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w500
          br $while_502_lp
        else
          br $while_502_exit
        end
      end
    end
    local.get $w501
  )
  (func $closure_375 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_376 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_376))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_376)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_376 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_376 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_376
    local.get $acc
    struct.new $ClosureType_376
  )
  (func $testListMapSum (result i32) ;; exported as "testListMapSum"
    (local $xs (ref null $ListBase))
    (local $doubled (ref null $ListBase))
    (local $w507 (ref null $ListBase))
    (local $w504 (ref null $ListBase))
    (local $w505 (ref null $ListBase))
    (local $x i32)
    (local $w508 (ref null $ListBase))
    (local $w511 (ref null $ListBase))
    (local $w512 i32)
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
    local.set $w504
    ref.null $ListBase
    local.set $w505
    block $while_506_exit
      loop $while_506_lp
        local.get $w504
        ref.is_null
        i32.eqz
        if
          local.get $w504
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          local.get $w505
          struct.new $ListCons_30
          local.set $w505
          local.get $w504
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w504
          br $while_506_lp
        else
          br $while_506_exit
        end
      end
    end
    local.get $w505
    local.set $w507
    ref.null $ListBase
    local.set $w508
    block $while_509_exit
      loop $while_509_lp
        local.get $w507
        ref.is_null
        i32.eqz
        if
          local.get $w507
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w508
          struct.new $ListCons_30
          local.set $w508
          local.get $w507
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w507
          br $while_509_lp
        else
          br $while_509_exit
        end
      end
    end
    local.get $w508
    local.set $doubled
    local.get $doubled
    local.set $w511
    i32.const 0
    local.set $w512
    block $while_513_exit
      loop $while_513_lp
        local.get $w511
        ref.is_null
        i32.eqz
        if
          local.get $w511
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w512
          local.get $x_1
          i32.add
          local.set $w512
          local.get $w511
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w511
          br $while_513_lp
        else
          br $while_513_exit
        end
      end
    end
    local.get $w512
  )
  (func $closure_378 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $closure_379 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_379))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_379)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_379 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_379 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_379
    local.get $acc
    struct.new $ClosureType_379
  )
  (func $testListFilterSum (result i32) ;; exported as "testListFilterSum"
    (local $xs (ref null $ListBase))
    (local $big (ref null $ListBase))
    (local $w518 (ref null $ListBase))
    (local $w515 (ref null $ListBase))
    (local $w516 (ref null $ListBase))
    (local $x i32)
    (local $w519 (ref null $ListBase))
    (local $w522 (ref null $ListBase))
    (local $w523 i32)
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
    local.set $w515
    ref.null $ListBase
    local.set $w516
    block $while_517_exit
      loop $while_517_lp
        local.get $w515
        ref.is_null
        i32.eqz
        if
          local.get $w515
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w515
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.get $w516
            struct.new $ListCons_30
          else
            local.get $w516
          end
          local.set $w516
          local.get $w515
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w515
          br $while_517_lp
        else
          br $while_517_exit
        end
      end
    end
    local.get $w516
    local.set $w518
    ref.null $ListBase
    local.set $w519
    block $while_520_exit
      loop $while_520_lp
        local.get $w518
        ref.is_null
        i32.eqz
        if
          local.get $w518
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w519
          struct.new $ListCons_30
          local.set $w519
          local.get $w518
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w518
          br $while_520_lp
        else
          br $while_520_exit
        end
      end
    end
    local.get $w519
    local.set $big
    local.get $big
    local.set $w522
    i32.const 0
    local.set $w523
    block $while_524_exit
      loop $while_524_lp
        local.get $w522
        ref.is_null
        i32.eqz
        if
          local.get $w522
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w523
          local.get $x_1
          i32.add
          local.set $w523
          local.get $w522
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w522
          br $while_524_lp
        else
          br $while_524_exit
        end
      end
    end
    local.get $w523
  )
  (func $testListRevHead (result i32) ;; exported as "testListRevHead"
    (local $xs (ref null $ListBase))
    (local $w526 (ref null $ListBase))
    (local $w527 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    local.get $xs
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
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListAppendLen (result i32) ;; exported as "testListAppendLen"
    (local $xs (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $w537 (ref null $ListBase))
    (local $w530 (ref null $ListBase))
    (local $w531 (ref null $ListBase))
    (local $w533 (ref null $ListBase))
    (local $w534 (ref null $ListBase))
    (local $w538 i32)
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
    local.set $w530
    local.get $ys
    local.set $w531
    block $while_532_exit
      loop $while_532_lp
        local.get $w530
        ref.is_null
        i32.eqz
        if
          local.get $w530
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w531
          struct.new $ListCons_30
          local.set $w531
          local.get $w530
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w530
          br $while_532_lp
        else
          br $while_532_exit
        end
      end
    end
    local.get $w531
    local.set $w533
    ref.null $ListBase
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
          local.get $w534
          struct.new $ListCons_30
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
    local.get $w534
    local.set $w537
    i32.const 0
    local.set $w538
    block $while_539_exit
      loop $while_539_lp
        local.get $w537
        ref.is_null
        i32.eqz
        if
          local.get $w538
          i32.const 1
          i32.add
          local.set $w538
          local.get $w537
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w537
          br $while_539_lp
        else
          br $while_539_exit
        end
      end
    end
    local.get $w538
  )
  (func $closure_381 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_381))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_381)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_381 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIter (result i32) ;; exported as "testListIter"
    (local $acc i32)
    (local $w541 (ref null $ListBase))
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
    local.set $w541
    block $while_542_exit
      loop $while_542_lp
        local.get $w541
        ref.is_null
        i32.eqz
        if
          local.get $w541
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w541
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w541
          br $while_542_lp
        else
          br $while_542_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_382 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_382))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_382)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_382 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIterEmpty (result i32) ;; exported as "testListIterEmpty"
    (local $acc i32)
    (local $w544 (ref null $ListBase))
    (local $x i32)
    i32.const 0
    local.set $acc
    ref.null $ListBase
    local.set $w544
    block $while_545_exit
      loop $while_545_lp
        local.get $w544
        ref.is_null
        i32.eqz
        if
          local.get $w544
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w544
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w544
          br $while_545_lp
        else
          br $while_545_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_383 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListExists (result i32) ;; exported as "testListExists"
    (local $w547 (ref null $ListBase))
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
    local.set $w547
    block $exi_546_blk (result i32)
      block $exi_546_lp_exit
        loop $exi_546_lp
          local.get $w547
          ref.is_null
          i32.eqz
          if
            local.get $w547
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              i32.const 1
              br $exi_546_blk
            end
            local.get $w547
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w547
          else
            br $exi_546_lp_exit
          end
          br $exi_546_lp
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
  (func $closure_384 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListExistsFalse (result i32) ;; exported as "testListExistsFalse"
    (local $w549 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w549
    block $exi_548_blk (result i32)
      block $exi_548_lp_exit
        loop $exi_548_lp
          local.get $w549
          ref.is_null
          i32.eqz
          if
            local.get $w549
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $exi_548_blk
            end
            local.get $w549
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w549
          else
            br $exi_548_lp_exit
          end
          br $exi_548_lp
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
  (func $closure_385 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListForAll (result i32) ;; exported as "testListForAll"
    (local $w551 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w551
    block $all_550_blk (result i32)
      block $all_550_lp_exit
        loop $all_550_lp
          local.get $w551
          ref.is_null
          i32.eqz
          if
            local.get $w551
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w551
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w551
            else
              i32.const 0
              br $all_550_blk
            end
          else
            br $all_550_lp_exit
          end
          br $all_550_lp
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
  (func $closure_386 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testListForAllFalse (result i32) ;; exported as "testListForAllFalse"
    (local $w553 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w553
    block $all_552_blk (result i32)
      block $all_552_lp_exit
        loop $all_552_lp
          local.get $w553
          ref.is_null
          i32.eqz
          if
            local.get $w553
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 2
            i32.gt_s
            if
              local.get $w553
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w553
            else
              i32.const 0
              br $all_552_blk
            end
          else
            br $all_552_lp_exit
          end
          br $all_552_lp
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
  (func $closure_387 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSum (result i32) ;; exported as "testListSum"
    (local $w555 (ref null $ListBase))
    (local $w556 i32)
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
    local.set $w555
    i32.const 0
    local.set $w556
    block $while_557_exit
      loop $while_557_lp
        local.get $w555
        ref.is_null
        i32.eqz
        if
          local.get $w556
          local.get $w555
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w556
          local.get $w555
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w555
          br $while_557_lp
        else
          br $while_557_exit
        end
      end
    end
    local.get $w556
  )
  (func $closure_388 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumEmpty (result i32) ;; exported as "testListSumEmpty"
    (local $w559 (ref null $ListBase))
    (local $w560 i32)
    ref.null $ListBase
    local.set $w559
    i32.const 0
    local.set $w560
    block $while_561_exit
      loop $while_561_lp
        local.get $w559
        ref.is_null
        i32.eqz
        if
          local.get $w560
          local.get $w559
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w560
          local.get $w559
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w559
          br $while_561_lp
        else
          br $while_561_exit
        end
      end
    end
    local.get $w560
  )
  (func $closure_389 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListTryFindSome (result i32) ;; exported as "testListTryFindSome"
    (local $matchValue (ref null $Option_53))
    (local $w563 (ref null $ListBase))
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
    local.set $w563
    block $tryf_562_exit (result (ref null $Option_53))
      block $tryf_562_lp_exit
        loop $tryf_562_lp
          local.get $w563
          ref.is_null
          i32.eqz
          if
            local.get $w563
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w563
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 0
              struct.new $Option_53
              br $tryf_562_exit
            end
            local.get $w563
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w563
          else
            br $tryf_562_lp_exit
          end
          br $tryf_562_lp
        end
      end
      ref.null $Option_53
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $closure_390 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindNone (result i32) ;; exported as "testListTryFindNone"
    (local $matchValue (ref null $Option_53))
    (local $w565 (ref null $ListBase))
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
    local.set $w565
    block $tryf_564_exit (result (ref null $Option_53))
      block $tryf_564_lp_exit
        loop $tryf_564_lp
          local.get $w565
          ref.is_null
          i32.eqz
          if
            local.get $w565
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              local.get $w565
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 0
              struct.new $Option_53
              br $tryf_564_exit
            end
            local.get $w565
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w565
          else
            br $tryf_564_lp_exit
          end
          br $tryf_564_lp
        end
      end
      ref.null $Option_53
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $testListTryHeadSome (result i32) ;; exported as "testListTryHeadSome"
    (local $matchValue (ref null $Option_53))
    (local $w567 (ref null $ListBase))
    i32.const 7
    i32.const 8
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w567
    local.get $w567
    ref.is_null
    if (result (ref null $Option_53))
      ref.null $Option_53
    else
      local.get $w567
      ref.cast (ref $ListCons_30)
      struct.get $ListCons_30 0
      struct.new $Option_53
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $testListTryHeadNone (result i32) ;; exported as "testListTryHeadNone"
    (local $matchValue (ref null $Option_53))
    ref.null $Option_53
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $closure_391 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_391))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_391)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_391 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_391 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_391
    local.get $x
    struct.new $ClosureType_391
  )
  (func $closure_393 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_393))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_393)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_393 1
    local.set $i
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $closure_393 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_393
    local.get $i
    struct.new $ClosureType_393
  )
  (func $closure_395 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_395))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_395)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_395 1
    local.set $i
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $closure_395 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_395
    local.get $i
    struct.new $ClosureType_395
  )
  (func $testListMapi (result i32) ;; exported as "testListMapi"
    (local $w587 (ref null $ListBase))
    (local $w584 (ref null $ListBase))
    (local $w580 (ref null $ListBase))
    (local $w581 (ref null $ListBase))
    (local $w582 i32)
    (local $x_1 i32)
    (local $w585 (ref null $ListBase))
    (local $w588 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w580
    ref.null $ListBase
    local.set $w581
    i32.const 0
    local.set $w582
    block $while_583_exit
      loop $while_583_lp
        local.get $w580
        ref.is_null
        i32.eqz
        if
          local.get $w580
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w582
          local.get $x_1
          i32.mul
          local.get $w581
          struct.new $ListCons_30
          local.set $w581
          local.get $w582
          i32.const 1
          i32.add
          local.set $w582
          local.get $w580
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w580
          br $while_583_lp
        else
          br $while_583_exit
        end
      end
    end
    local.get $w581
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
    local.set $w587
    i32.const 0
    local.set $w588
    block $while_589_exit
      loop $while_589_lp
        local.get $w587
        ref.is_null
        i32.eqz
        if
          local.get $w587
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w588
          local.get $y
          i32.add
          local.set $w588
          local.get $w587
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w587
          br $while_589_lp
        else
          br $while_589_exit
        end
      end
    end
    local.get $w588
  )
  (func $closure_397 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_397))
    (local $i i32)
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_397)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_397 1
    local.set $i
    local.get $self_cast
    struct.get $ClosureType_397 2
    local.set $s
    local.get $s
    local.get $i
    local.get $x
    i32.mul
    i32.add
    local.set $s
  )
  (func $closure_397 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_398))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_398)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_398 1
    local.set $s
    ref.func $closure_397
    local.get $i
    local.get $s
    struct.new $ClosureType_397
  )
  (func $testListIteri (result i32) ;; exported as "testListIteri"
    (local $s i32)
    (local $w591 (ref null $ListBase))
    (local $w592 i32)
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
    local.set $w591
    i32.const 0
    local.set $w592
    block $while_593_exit
      loop $while_593_lp
        local.get $w591
        ref.is_null
        i32.eqz
        if
          local.get $w591
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $s
          local.get $w592
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w592
          i32.const 1
          i32.add
          local.set $w592
          local.get $w591
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w591
          br $while_593_lp
        else
          br $while_593_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_399 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $testListCollect (result i32) ;; exported as "testListCollect"
    (local $w607 (ref null $ListBase))
    (local $w595 (ref null $ListBase))
    (local $w596 (ref null $ListBase))
    (local $w597 (ref null $ListBase))
    (local $x i32)
    (local $w601 (ref null $ListBase))
    (local $w598 (ref null $ListBase))
    (local $w599 (ref null $ListBase))
    (local $w603 (ref null $ListBase))
    (local $w604 (ref null $ListBase))
    (local $w608 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w595
    ref.null $ListBase
    local.set $w596
    block $while_602_exit
      loop $while_602_lp
        local.get $w595
        ref.is_null
        i32.eqz
        if
          local.get $w595
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
          local.set $w597
          local.get $w597
          local.set $w598
          local.get $w596
          local.set $w599
          block $while_600_exit
            loop $while_600_lp
              local.get $w598
              ref.is_null
              i32.eqz
              if
                local.get $w598
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w599
                struct.new $ListCons_30
                local.set $w599
                local.get $w598
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w598
                br $while_600_lp
              else
                br $while_600_exit
              end
            end
          end
          local.get $w599
          local.set $w601
          local.get $w601
          local.set $w596
          local.get $w595
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w595
          br $while_602_lp
        else
          br $while_602_exit
        end
      end
    end
    local.get $w596
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
    local.set $w607
    i32.const 0
    local.set $w608
    block $while_609_exit
      loop $while_609_lp
        local.get $w607
        ref.is_null
        i32.eqz
        if
          local.get $w608
          i32.const 1
          i32.add
          local.set $w608
          local.get $w607
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w607
          br $while_609_lp
        else
          br $while_609_exit
        end
      end
    end
    local.get $w608
  )
  (func $closure_402 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_402))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_402)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_402 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_402 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_402
    local.get $x
    struct.new $ClosureType_402
  )
  (func $closure_404 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $closure_405 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $testListCollectOrder (result i32) ;; exported as "testListCollectOrder"
    (local $w635 (ref null $ListBase))
    (local $w624 (ref null $ListBase))
    (local $w625 (ref null $ListBase))
    (local $w626 (ref null $ListBase))
    (local $x_1 i32)
    (local $w630 (ref null $ListBase))
    (local $w627 (ref null $ListBase))
    (local $w628 (ref null $ListBase))
    (local $w632 (ref null $ListBase))
    (local $w633 (ref null $ListBase))
    (local $w636 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w624
    ref.null $ListBase
    local.set $w625
    block $while_631_exit
      loop $while_631_lp
        local.get $w624
        ref.is_null
        i32.eqz
        if
          local.get $w624
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
          local.set $w626
          local.get $w626
          local.set $w627
          local.get $w625
          local.set $w628
          block $while_629_exit
            loop $while_629_lp
              local.get $w627
              ref.is_null
              i32.eqz
              if
                local.get $w627
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w628
                struct.new $ListCons_30
                local.set $w628
                local.get $w627
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w627
                br $while_629_lp
              else
                br $while_629_exit
              end
            end
          end
          local.get $w628
          local.set $w630
          local.get $w630
          local.set $w625
          local.get $w624
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w624
          br $while_631_lp
        else
          br $while_631_exit
        end
      end
    end
    local.get $w625
    local.set $w632
    ref.null $ListBase
    local.set $w633
    block $while_634_exit
      loop $while_634_lp
        local.get $w632
        ref.is_null
        i32.eqz
        if
          local.get $w632
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w633
          struct.new $ListCons_30
          local.set $w633
          local.get $w632
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w632
          br $while_634_lp
        else
          br $while_634_exit
        end
      end
    end
    local.get $w633
    local.set $w635
    i32.const 0
    local.set $w636
    block $while_637_exit
      loop $while_637_lp
        local.get $w635
        ref.is_null
        i32.eqz
        if
          local.get $w635
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w636
          local.get $y
          i32.add
          local.set $w636
          local.get $w635
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w635
          br $while_637_lp
        else
          br $while_637_exit
        end
      end
    end
    local.get $w636
  )
  (func $closure_406 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_53))
    local.get $x
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_53))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_53
    else
      ref.null $Option_53
    end
  )
  (func $testListChoose (result i32) ;; exported as "testListChoose"
    (local $w646 (ref null $ListBase))
    (local $w642 (ref null $ListBase))
    (local $w639 (ref null $ListBase))
    (local $w640 (ref null $ListBase))
    (local $cho_638_opt (ref null $Option_53))
    (local $x i32)
    (local $w643 (ref null $ListBase))
    (local $w647 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w639
    ref.null $ListBase
    local.set $w640
    block $while_641_exit
      loop $while_641_lp
        local.get $w639
        ref.is_null
        i32.eqz
        if
          local.get $w639
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_53))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_53
          else
            ref.null $Option_53
          end
          local.set $cho_638_opt
          local.get $cho_638_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_638_opt
            ref.cast (ref $Option_53)
            struct.get $Option_53 0
            local.get $w640
            struct.new $ListCons_30
          else
            local.get $w640
          end
          local.set $w640
          local.get $w639
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w639
          br $while_641_lp
        else
          br $while_641_exit
        end
      end
    end
    local.get $w640
    local.set $w642
    ref.null $ListBase
    local.set $w643
    block $while_644_exit
      loop $while_644_lp
        local.get $w642
        ref.is_null
        i32.eqz
        if
          local.get $w642
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w643
          struct.new $ListCons_30
          local.set $w643
          local.get $w642
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w642
          br $while_644_lp
        else
          br $while_644_exit
        end
      end
    end
    local.get $w643
    local.set $w646
    i32.const 0
    local.set $w647
    block $while_648_exit
      loop $while_648_lp
        local.get $w646
        ref.is_null
        i32.eqz
        if
          local.get $w647
          i32.const 1
          i32.add
          local.set $w647
          local.get $w646
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w646
          br $while_648_lp
        else
          br $while_648_exit
        end
      end
    end
    local.get $w647
  )
  (func $closure_407 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    (local $self_cast (ref $ClosureType_407))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_407)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_407 1
    local.set $x
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_407 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_407
    local.get $x
    struct.new $ClosureType_407
  )
  (func $closure_409 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_53))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_53))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_53
    else
      ref.null $Option_53
    end
  )
  (func $closure_410 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_53))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_53))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_53
    else
      ref.null $Option_53
    end
  )
  (func $testListChooseSum (result i32) ;; exported as "testListChooseSum"
    (local $w664 (ref null $ListBase))
    (local $w661 (ref null $ListBase))
    (local $w658 (ref null $ListBase))
    (local $w659 (ref null $ListBase))
    (local $cho_657_opt (ref null $Option_53))
    (local $x_1 i32)
    (local $w662 (ref null $ListBase))
    (local $w665 i32)
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
    local.set $w658
    ref.null $ListBase
    local.set $w659
    block $while_660_exit
      loop $while_660_lp
        local.get $w658
        ref.is_null
        i32.eqz
        if
          local.get $w658
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $x_1
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_53))
            local.get $x_1
            i32.const 10
            i32.mul
            struct.new $Option_53
          else
            ref.null $Option_53
          end
          local.set $cho_657_opt
          local.get $cho_657_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_657_opt
            ref.cast (ref $Option_53)
            struct.get $Option_53 0
            local.get $w659
            struct.new $ListCons_30
          else
            local.get $w659
          end
          local.set $w659
          local.get $w658
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w658
          br $while_660_lp
        else
          br $while_660_exit
        end
      end
    end
    local.get $w659
    local.set $w661
    ref.null $ListBase
    local.set $w662
    block $while_663_exit
      loop $while_663_lp
        local.get $w661
        ref.is_null
        i32.eqz
        if
          local.get $w661
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w662
          struct.new $ListCons_30
          local.set $w662
          local.get $w661
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w661
          br $while_663_lp
        else
          br $while_663_exit
        end
      end
    end
    local.get $w662
    local.set $w664
    i32.const 0
    local.set $w665
    block $while_666_exit
      loop $while_666_lp
        local.get $w664
        ref.is_null
        i32.eqz
        if
          local.get $w664
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w665
          local.get $y
          i32.add
          local.set $w665
          local.get $w664
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w664
          br $while_666_lp
        else
          br $while_666_exit
        end
      end
    end
    local.get $w665
  )
  (func $closure_411 (param $self (ref $AnyFn)) (param $acc (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_411))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_411)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_411 1
    local.set $x
    local.get $x
    local.get $acc
    struct.new $ListCons_30
  )
  (func $closure_411 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_411
    local.get $x
    struct.new $ClosureType_411
  )
  (func $testListFoldBack (result i32) ;; exported as "testListFoldBack"
    (local $w675 (ref null $ListBase))
    (local $w671 (ref null $ListBase))
    (local $w668 (ref null $ListBase))
    (local $w669 (ref null $ListBase))
    (local $w672 (ref null $ListBase))
    (local $x i32)
    (local $w676 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w668
    ref.null $ListBase
    local.set $w669
    block $while_670_exit
      loop $while_670_lp
        local.get $w668
        ref.is_null
        i32.eqz
        if
          local.get $w668
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w669
          struct.new $ListCons_30
          local.set $w669
          local.get $w668
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w668
          br $while_670_lp
        else
          br $while_670_exit
        end
      end
    end
    local.get $w669
    local.set $w671
    ref.null $ListBase
    local.set $w672
    block $while_673_exit
      loop $while_673_lp
        local.get $w671
        ref.is_null
        i32.eqz
        if
          local.get $w671
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w672
          struct.new $ListCons_30
          local.set $w672
          local.get $w671
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w671
          br $while_673_lp
        else
          br $while_673_exit
        end
      end
    end
    local.get $w672
    local.set $w675
    i32.const 0
    local.set $w676
    block $while_677_exit
      loop $while_677_lp
        local.get $w675
        ref.is_null
        i32.eqz
        if
          local.get $w676
          i32.const 1
          i32.add
          local.set $w676
          local.get $w675
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w675
          br $while_677_lp
        else
          br $while_677_exit
        end
      end
    end
    local.get $w676
  )
  (func $closure_413 (param $self (ref $AnyFn)) (param $acc i32) (result i32)
    (local $self_cast (ref $ClosureType_413))
    (local $x i32)
    local.get $self
    ref.cast (ref $ClosureType_413)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_413 1
    local.set $x
    local.get $x
    local.get $acc
    i32.sub
  )
  (func $closure_413 (param $self (ref $AnyFn)) (param $x i32) (result (ref $AnyFn))
    ref.func $closure_413
    local.get $x
    struct.new $ClosureType_413
  )
  (func $testListFoldBackOrder (result i32) ;; exported as "testListFoldBackOrder"
    (local $w682 (ref null $ListBase))
    (local $w679 (ref null $ListBase))
    (local $w680 (ref null $ListBase))
    (local $w683 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w679
    ref.null $ListBase
    local.set $w680
    block $while_681_exit
      loop $while_681_lp
        local.get $w679
        ref.is_null
        i32.eqz
        if
          local.get $w679
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w680
          struct.new $ListCons_30
          local.set $w680
          local.get $w679
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w679
          br $while_681_lp
        else
          br $while_681_exit
        end
      end
    end
    local.get $w680
    local.set $w682
    i32.const 0
    local.set $w683
    block $while_684_exit
      loop $while_684_lp
        local.get $w682
        ref.is_null
        i32.eqz
        if
          local.get $w682
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w683
          i32.sub
          local.set $w683
          local.get $w682
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w682
          br $while_684_lp
        else
          br $while_684_exit
        end
      end
    end
    local.get $w683
  )
  (func $closure_415 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    local.get $x
    i32.mul
  )
  (func $closure_416 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumBy (result i32) ;; exported as "testListSumBy"
    (local $w686 (ref null $ListBase))
    (local $w687 i32)
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
    local.set $w686
    i32.const 0
    local.set $w687
    block $while_688_exit
      loop $while_688_lp
        local.get $w686
        ref.is_null
        i32.eqz
        if
          local.get $w687
          local.get $w686
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $x
          i32.mul
          i32.add
          local.set $w687
          local.get $w686
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w686
          br $while_688_lp
        else
          br $while_688_exit
        end
      end
    end
    local.get $w687
  )
  (func $closure_417 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_418 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w690 (ref null $ListBase))
    (local $w691 (ref $ListCons_30))
    (local $w692 i32)
    (local $w693 i32)
    (local $x i32)
    (local $w694 (ref null $ListBase))
    (local $w695 i32)
    (local $w696 i32)
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
    local.set $w690
    local.get $w690
    ref.cast (ref $ListCons_30)
    local.set $w691
    local.get $w691
    struct.get $ListCons_30 0
    local.set $w692
    local.get $w691
    struct.get $ListCons_30 0
    local.set $x
    local.get $x
    i32.const 3
    i32.rem_s
    local.set $w693
    local.get $w691
    struct.get $ListCons_30 1
    local.set $w694
    block $while_697_exit
      loop $while_697_lp
        local.get $w694
        ref.is_null
        i32.eqz
        if
          local.get $w694
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w695
          local.get $w695
          i32.const 3
          i32.rem_s
          local.set $w696
          local.get $w696
          local.get $w693
          i32.lt_s
          if
            local.get $w695
            local.set $w692
            local.get $w696
            local.set $w693
          end
          local.get $w694
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w694
          br $while_697_lp
        else
          br $while_697_exit
        end
      end
    end
    local.get $w692
  )
  (func $closure_419 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 5
    i32.rem_s
  )
  (func $closure_420 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w699 (ref null $ListBase))
    (local $w700 (ref $ListCons_30))
    (local $w701 i32)
    (local $w702 i32)
    (local $x i32)
    (local $w703 (ref null $ListBase))
    (local $w704 i32)
    (local $w705 i32)
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
    local.set $w699
    local.get $w699
    ref.cast (ref $ListCons_30)
    local.set $w700
    local.get $w700
    struct.get $ListCons_30 0
    local.set $w701
    local.get $w700
    struct.get $ListCons_30 0
    local.set $x
    local.get $x
    i32.const 5
    i32.rem_s
    local.set $w702
    local.get $w700
    struct.get $ListCons_30 1
    local.set $w703
    block $while_706_exit
      loop $while_706_lp
        local.get $w703
        ref.is_null
        i32.eqz
        if
          local.get $w703
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w704
          local.get $w704
          i32.const 5
          i32.rem_s
          local.set $w705
          local.get $w705
          local.get $w702
          i32.gt_s
          if
            local.get $w704
            local.set $w701
            local.get $w705
            local.set $w702
          end
          local.get $w703
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w703
          br $while_706_lp
        else
          br $while_706_exit
        end
      end
    end
    local.get $w701
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
  (func $testListMin (result i32) ;; exported as "testListMin"
    (local $w708 (ref null $ListBase))
    (local $w709 (ref $ListCons_30))
    (local $w710 i32)
    (local $w711 (ref null $ListBase))
    (local $w712 i32)
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
    local.set $w708
    local.get $w708
    ref.cast (ref $ListCons_30)
    local.set $w709
    local.get $w709
    struct.get $ListCons_30 0
    local.set $w710
    local.get $w709
    struct.get $ListCons_30 1
    local.set $w711
    block $while_713_exit
      loop $while_713_lp
        local.get $w711
        ref.is_null
        i32.eqz
        if
          local.get $w711
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w712
          local.get $w712
          local.get $w710
          i32.lt_s
          if
            local.get $w712
            local.set $w710
          end
          local.get $w711
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w711
          br $while_713_lp
        else
          br $while_713_exit
        end
      end
    end
    local.get $w710
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
  (func $testListMax (result i32) ;; exported as "testListMax"
    (local $w715 (ref null $ListBase))
    (local $w716 (ref $ListCons_30))
    (local $w717 i32)
    (local $w718 (ref null $ListBase))
    (local $w719 i32)
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
    local.set $w715
    local.get $w715
    ref.cast (ref $ListCons_30)
    local.set $w716
    local.get $w716
    struct.get $ListCons_30 0
    local.set $w717
    local.get $w716
    struct.get $ListCons_30 1
    local.set $w718
    block $while_720_exit
      loop $while_720_lp
        local.get $w718
        ref.is_null
        i32.eqz
        if
          local.get $w718
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w719
          local.get $w719
          local.get $w717
          i32.gt_s
          if
            local.get $w719
            local.set $w717
          end
          local.get $w718
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w718
          br $while_720_lp
        else
          br $while_720_exit
        end
      end
    end
    local.get $w717
  )
  (func $closure_423 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContains (result i32) ;; exported as "testListContains"
    (local $w723 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w723
    block $lcont_721_exit (result i32)
      block $lcont_721_lp_exit
        loop $lcont_721_lp
          local.get $w723
          ref.is_null
          i32.eqz
          if
            local.get $w723
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $lcont_721_exit
            end
            local.get $w723
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w723
          else
            br $lcont_721_lp_exit
          end
          br $lcont_721_lp
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
  (func $closure_424 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContainsFalse (result i32) ;; exported as "testListContainsFalse"
    (local $w726 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w726
    block $lcont_724_exit (result i32)
      block $lcont_724_lp_exit
        loop $lcont_724_lp
          local.get $w726
          ref.is_null
          i32.eqz
          if
            local.get $w726
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $lcont_724_exit
            end
            local.get $w726
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w726
          else
            br $lcont_724_lp_exit
          end
          br $lcont_724_lp
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
  (func $closure_425 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    i32.const 1
  )
  (func $testListInit (result i32) ;; exported as "testListInit"
    (local $w732 (ref null $ListBase))
    (local $w728 i32)
    (local $w729 (ref null $ListBase))
    (local $w733 i32)
    i32.const 4
    local.set $w728
    ref.null $ListBase
    local.set $w729
    block $while_730_exit
      loop $while_730_lp
        local.get $w728
        i32.const 0
        i32.ge_s
        if
          i32.const 1
          local.get $w729
          struct.new $ListCons_30
          local.set $w729
          local.get $w728
          i32.const 1
          i32.sub
          local.set $w728
          br $while_730_lp
        else
          br $while_730_exit
        end
      end
    end
    local.get $w729
    local.set $w732
    i32.const 0
    local.set $w733
    block $while_734_exit
      loop $while_734_lp
        local.get $w732
        ref.is_null
        i32.eqz
        if
          local.get $w733
          i32.const 1
          i32.add
          local.set $w733
          local.get $w732
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w732
          br $while_734_lp
        else
          br $while_734_exit
        end
      end
    end
    local.get $w733
  )
  (func $testListReplicate (result i32) ;; exported as "testListReplicate"
    (local $w738 i32)
    (local $w739 (ref null $ListBase))
    i32.const 0
    local.set $w738
    ref.null $ListBase
    local.set $w739
    block $while_740_exit
      loop $while_740_lp
        local.get $w738
        i32.const 4
        i32.lt_s
        if
          i32.const 7
          local.get $w739
          struct.new $ListCons_30
          local.set $w739
          local.get $w738
          i32.const 1
          i32.add
          local.set $w738
          br $while_740_lp
        else
          br $while_740_exit
        end
      end
    end
    local.get $w739
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListTake (result i32) ;; exported as "testListTake"
    (local $w750 i32)
    (local $w751 (ref null $ListBase))
    (local $w746 (ref null $ListBase))
    (local $w742 i32)
    (local $w743 (ref null $ListBase))
    (local $w744 (ref null $ListBase))
    (local $w747 (ref null $ListBase))
    i32.const 2
    local.set $w750
    i32.const 3
    local.set $w742
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
    local.set $w743
    ref.null $ListBase
    local.set $w744
    block $while_745_exit
      loop $while_745_lp
        local.get $w742
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w743
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w743
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w744
          struct.new $ListCons_30
          local.set $w744
          local.get $w743
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w743
          local.get $w742
          i32.const 1
          i32.sub
          local.set $w742
          br $while_745_lp
        else
          br $while_745_exit
        end
      end
    end
    local.get $w744
    local.set $w746
    ref.null $ListBase
    local.set $w747
    block $while_748_exit
      loop $while_748_lp
        local.get $w746
        ref.is_null
        i32.eqz
        if
          local.get $w746
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w747
          struct.new $ListCons_30
          local.set $w747
          local.get $w746
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w746
          br $while_748_lp
        else
          br $while_748_exit
        end
      end
    end
    local.get $w747
    local.set $w751
    block $while_752_exit
      loop $while_752_lp
        local.get $w750
        i32.const 0
        i32.gt_s
        if
          local.get $w751
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w751
          local.get $w750
          i32.const 1
          i32.sub
          local.set $w750
          br $while_752_lp
        else
          br $while_752_exit
        end
      end
    end
    local.get $w751
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListSkip (result i32) ;; exported as "testListSkip"
    (local $w754 i32)
    (local $w755 (ref null $ListBase))
    i32.const 2
    local.set $w754
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
    local.set $w755
    block $while_756_exit
      loop $while_756_lp
        local.get $w754
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w755
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w755
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w755
          local.get $w754
          i32.const 1
          i32.sub
          local.set $w754
          br $while_756_lp
        else
          br $while_756_exit
        end
      end
    end
    local.get $w755
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_426 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w758 (ref null $ListBase))
    (local $w762 i32)
    (local $w759 (ref null $ListBase))
    (local $w760 i32)
    (local $w763 (ref $GcArray_123))
    (local $w764 (ref null $ListBase))
    (local $w765 i32)
    (local $w767 i32)
    (local $w768 i32)
    (local $w769 i32)
    (local $w772 i32)
    (local $w773 (ref null $ListBase))
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
    local.set $w758
    local.get $w758
    local.set $w759
    i32.const 0
    local.set $w760
    block $while_761_exit
      loop $while_761_lp
        local.get $w759
        ref.is_null
        i32.eqz
        if
          local.get $w760
          i32.const 1
          i32.add
          local.set $w760
          local.get $w759
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w759
          br $while_761_lp
        else
          br $while_761_exit
        end
      end
    end
    local.get $w760
    local.set $w762
    i32.const 0
    local.get $w762
    array.new $GcArray_123
    local.set $w763
    local.get $w758
    local.set $w764
    i32.const 0
    local.set $w765
    block $while_766_exit
      loop $while_766_lp
        local.get $w764
        ref.is_null
        i32.eqz
        if
          local.get $w763
          local.get $w765
          local.get $w764
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_123
          local.get $w765
          i32.const 1
          i32.add
          local.set $w765
          local.get $w764
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w764
          br $while_766_lp
        else
          br $while_766_exit
        end
      end
    end
    local.get $w765
    drop
    i32.const 1
    local.set $w767
    block $while_771_exit
      loop $while_771_lp
        local.get $w767
        local.get $w762
        i32.lt_s
        if
          local.get $w763
          local.get $w767
          array.get $GcArray_123
          local.set $w768
          local.get $w767
          i32.const 1
          i32.sub
          local.set $w769
          block $while_770_exit
            loop $while_770_lp
              local.get $w769
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w763
                local.get $w769
                array.get $GcArray_123
                local.get $w768
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
                local.get $w763
                local.get $w769
                i32.const 1
                i32.add
                local.get $w763
                local.get $w769
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w769
                i32.const 1
                i32.sub
                local.set $w769
                br $while_770_lp
              else
                br $while_770_exit
              end
            end
          end
          local.get $w763
          local.get $w769
          i32.const 1
          i32.add
          local.get $w768
          array.set $GcArray_123
          local.get $w767
          i32.const 1
          i32.add
          local.set $w767
          br $while_771_lp
        else
          br $while_771_exit
        end
      end
    end
    local.get $w762
    i32.const 1
    i32.sub
    local.set $w772
    ref.null $ListBase
    local.set $w773
    block $while_774_exit
      loop $while_774_lp
        local.get $w772
        i32.const 0
        i32.ge_s
        if
          local.get $w763
          local.get $w772
          array.get $GcArray_123
          local.get $w773
          struct.new $ListCons_30
          local.set $w773
          local.get $w772
          i32.const 1
          i32.sub
          local.set $w772
          br $while_774_lp
        else
          br $while_774_exit
        end
      end
    end
    local.get $w773
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_427 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListFindIndex (result i32) ;; exported as "testListFindIndex"
    (local $w776 (ref null $ListBase))
    (local $w777 i32)
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
    local.set $w776
    i32.const 0
    local.set $w777
    block $fdi_775_exit (result i32)
      loop $fdi_775_lp
        local.get $w776
        ref.is_null
        i32.eqz
        if
          local.get $w776
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if
            local.get $w777
            br $fdi_775_exit
          else
            local.get $w777
            i32.const 1
            i32.add
            local.set $w777
            local.get $w776
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w776
            br $fdi_775_lp
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_428 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindIndex (result i32) ;; exported as "testListTryFindIndex"
    (local $matchValue (ref null $Option_53))
    (local $w779 (ref null $ListBase))
    (local $w780 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w779
    i32.const 0
    local.set $w780
    block $fdi_778_exit (result (ref null $Option_53))
      loop $fdi_778_lp
        local.get $w779
        ref.is_null
        i32.eqz
        if
          local.get $w779
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w780
            struct.new $Option_53
            br $fdi_778_exit
          else
            local.get $w780
            i32.const 1
            i32.add
            local.set $w780
            local.get $w779
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w779
            br $fdi_778_lp
          end
        end
      end
      ref.null $Option_53
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $testListItem (result i32) ;; exported as "testListItem"
    (local $w782 i32)
    (local $w783 (ref null $ListBase))
    i32.const 2
    local.set $w782
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
    local.set $w783
    block $while_784_exit
      loop $while_784_lp
        local.get $w782
        i32.const 0
        i32.gt_s
        if
          local.get $w783
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w783
          local.get $w782
          i32.const 1
          i32.sub
          local.set $w782
          br $while_784_lp
        else
          br $while_784_exit
        end
      end
    end
    local.get $w783
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
    (local $w786 (ref null $ListBase))
    (local $w787 i32)
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w786
    i32.const 0
    local.set $w787
    block $while_788_exit
      loop $while_788_lp
        local.get $w786
        ref.is_null
        i32.eqz
        if
          local.get $w787
          i32.const 1
          i32.add
          local.set $w787
          local.get $w786
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w786
          br $while_788_lp
        else
          br $while_788_exit
        end
      end
    end
    local.get $w787
  )
  (func $closure_429 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_429))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_429)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_429 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_429 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_429
    local.get $a
    struct.new $ClosureType_429
  )
  (func $testListReduce (result i32) ;; exported as "testListReduce"
    (local $w789 (ref null $ListBase))
    (local $w790 (ref $ListCons_30))
    (local $w792 (ref null $ListBase))
    (local $w793 i32)
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
    local.set $w789
    local.get $w789
    ref.cast (ref $ListCons_30)
    local.set $w790
    local.get $w790
    struct.get $ListCons_30 1
    local.set $w792
    local.get $w790
    struct.get $ListCons_30 0
    local.set $w793
    block $while_794_exit
      loop $while_794_lp
        local.get $w792
        ref.is_null
        i32.eqz
        if
          local.get $w792
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $w793
          local.get $b
          i32.add
          local.set $w793
          local.get $w792
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w792
          br $while_794_lp
        else
          br $while_794_exit
        end
      end
    end
    local.get $w793
  )
  (func $closure_431 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_431))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_431)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_431 1
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
  (func $closure_431 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_431
    local.get $a
    struct.new $ClosureType_431
  )
  (func $testListReduceMax (result i32) ;; exported as "testListReduceMax"
    (local $w795 (ref null $ListBase))
    (local $w796 (ref $ListCons_30))
    (local $w798 (ref null $ListBase))
    (local $w799 i32)
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
    local.set $w795
    local.get $w795
    ref.cast (ref $ListCons_30)
    local.set $w796
    local.get $w796
    struct.get $ListCons_30 1
    local.set $w798
    local.get $w796
    struct.get $ListCons_30 0
    local.set $w799
    block $while_800_exit
      loop $while_800_lp
        local.get $w798
        ref.is_null
        i32.eqz
        if
          local.get $w798
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $w799
          local.get $b
          i32.gt_s
          if (result i32)
            local.get $w799
          else
            local.get $b
          end
          local.set $w799
          local.get $w798
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w798
          br $while_800_lp
        else
          br $while_800_exit
        end
      end
    end
    local.get $w799
  )
  (func $testListLast (result i32) ;; exported as "testListLast"
    (local $w802 (ref null $ListBase))
    (local $w803 (ref $ListCons_30))
    (local $w804 i32)
    (local $w805 (ref null $ListBase))
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
    local.set $w802
    local.get $w802
    ref.cast (ref $ListCons_30)
    local.set $w803
    local.get $w803
    struct.get $ListCons_30 0
    local.set $w804
    local.get $w803
    struct.get $ListCons_30 1
    local.set $w805
    block $while_806_exit
      loop $while_806_lp
        local.get $w805
        ref.is_null
        i32.eqz
        if
          local.get $w805
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w804
          local.get $w805
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w805
          br $while_806_lp
        else
          br $while_806_exit
        end
      end
    end
    local.get $w804
  )
  (func $testListLastSingle (result i32) ;; exported as "testListLastSingle"
    (local $w808 (ref null $ListBase))
    (local $w809 (ref $ListCons_30))
    (local $w810 i32)
    (local $w811 (ref null $ListBase))
    i32.const 42
    ref.null $ListBase
    struct.new $ListCons_30
    local.set $w808
    local.get $w808
    ref.cast (ref $ListCons_30)
    local.set $w809
    local.get $w809
    struct.get $ListCons_30 0
    local.set $w810
    local.get $w809
    struct.get $ListCons_30 1
    local.set $w811
    block $while_812_exit
      loop $while_812_lp
        local.get $w811
        ref.is_null
        i32.eqz
        if
          local.get $w811
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w810
          local.get $w811
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w811
          br $while_812_lp
        else
          br $while_812_exit
        end
      end
    end
    local.get $w810
  )
  (func $closure_433 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w814 (ref null $ListBase))
    (local $w818 i32)
    (local $w815 (ref null $ListBase))
    (local $w816 i32)
    (local $w819 (ref $GcArray_123))
    (local $w820 (ref null $ListBase))
    (local $w821 i32)
    (local $w823 i32)
    (local $w824 i32)
    (local $w825 i32)
    (local $w828 i32)
    (local $w829 (ref null $ListBase))
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
    local.set $w814
    local.get $w814
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
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w815
          br $while_817_lp
        else
          br $while_817_exit
        end
      end
    end
    local.get $w816
    local.set $w818
    i32.const 0
    local.get $w818
    array.new $GcArray_123
    local.set $w819
    local.get $w814
    local.set $w820
    i32.const 0
    local.set $w821
    block $while_822_exit
      loop $while_822_lp
        local.get $w820
        ref.is_null
        i32.eqz
        if
          local.get $w819
          local.get $w821
          local.get $w820
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_123
          local.get $w821
          i32.const 1
          i32.add
          local.set $w821
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
    drop
    i32.const 1
    local.set $w823
    block $while_827_exit
      loop $while_827_lp
        local.get $w823
        local.get $w818
        i32.lt_s
        if
          local.get $w819
          local.get $w823
          array.get $GcArray_123
          local.set $w824
          local.get $w823
          i32.const 1
          i32.sub
          local.set $w825
          block $while_826_exit
            loop $while_826_lp
              local.get $w825
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w819
                local.get $w825
                array.get $GcArray_123
                local.get $w824
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
                local.get $w819
                local.get $w825
                i32.const 1
                i32.add
                local.get $w819
                local.get $w825
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w825
                i32.const 1
                i32.sub
                local.set $w825
                br $while_826_lp
              else
                br $while_826_exit
              end
            end
          end
          local.get $w819
          local.get $w825
          i32.const 1
          i32.add
          local.get $w824
          array.set $GcArray_123
          local.get $w823
          i32.const 1
          i32.add
          local.set $w823
          br $while_827_lp
        else
          br $while_827_exit
        end
      end
    end
    local.get $w818
    i32.const 1
    i32.sub
    local.set $w828
    ref.null $ListBase
    local.set $w829
    block $while_830_exit
      loop $while_830_lp
        local.get $w828
        i32.const 0
        i32.ge_s
        if
          local.get $w819
          local.get $w828
          array.get $GcArray_123
          local.get $w829
          struct.new $ListCons_30
          local.set $w829
          local.get $w828
          i32.const 1
          i32.sub
          local.set $w828
          br $while_830_lp
        else
          br $while_830_exit
        end
      end
    end
    local.get $w829
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_434 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_435 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_436 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $lo_clo_114 (ref $ClosureBase_33))
    (local $w832 (ref null $ListBase))
    (local $w836 i32)
    (local $w833 (ref null $ListBase))
    (local $w834 i32)
    (local $w837 (ref $GcArray_123))
    (local $w838 (ref $GcArray_123))
    (local $w839 (ref null $ListBase))
    (local $w840 i32)
    (local $w841 i32)
    (local $w844 i32)
    (local $w845 i32)
    (local $w846 i32)
    (local $w847 i32)
    (local $w850 i32)
    (local $w851 (ref null $ListBase))
    ref.func $closure_434
    struct.new $ClosureType_434
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_114
    local.get $lo_clo_114
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
    local.set $w832
    local.get $w832
    local.set $w833
    i32.const 0
    local.set $w834
    block $while_835_exit
      loop $while_835_lp
        local.get $w833
        ref.is_null
        i32.eqz
        if
          local.get $w834
          i32.const 1
          i32.add
          local.set $w834
          local.get $w833
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w833
          br $while_835_lp
        else
          br $while_835_exit
        end
      end
    end
    local.get $w834
    local.set $w836
    i32.const 0
    local.get $w836
    array.new $GcArray_123
    local.set $w837
    i32.const 0
    local.get $w836
    array.new $GcArray_123
    local.set $w838
    local.get $w832
    local.set $w839
    i32.const 0
    local.set $w840
    block $while_843_exit
      loop $while_843_lp
        local.get $w839
        ref.is_null
        i32.eqz
        if
          local.get $w839
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w841
          local.get $w837
          local.get $w840
          local.get $w841
          array.set $GcArray_123
          local.get $w838
          local.get $w840
          local.get $w841
          array.set $GcArray_123
          local.get $w840
          i32.const 1
          i32.add
          local.set $w840
          local.get $w839
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w839
          br $while_843_lp
        else
          br $while_843_exit
        end
      end
    end
    local.get $w840
    drop
    i32.const 1
    local.set $w844
    block $while_849_exit
      loop $while_849_lp
        local.get $w844
        local.get $w836
        i32.lt_s
        if
          local.get $w837
          local.get $w844
          array.get $GcArray_123
          local.set $w845
          local.get $w838
          local.get $w844
          array.get $GcArray_123
          local.set $w846
          local.get $w844
          i32.const 1
          i32.sub
          local.set $w847
          block $while_848_exit
            loop $while_848_lp
              local.get $w847
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w838
                local.get $w847
                array.get $GcArray_123
                local.get $w846
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w837
                local.get $w847
                i32.const 1
                i32.add
                local.get $w837
                local.get $w847
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w838
                local.get $w847
                i32.const 1
                i32.add
                local.get $w838
                local.get $w847
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w847
                i32.const 1
                i32.sub
                local.set $w847
                br $while_848_lp
              else
                br $while_848_exit
              end
            end
          end
          local.get $w837
          local.get $w847
          i32.const 1
          i32.add
          local.get $w845
          array.set $GcArray_123
          local.get $w838
          local.get $w847
          i32.const 1
          i32.add
          local.get $w846
          array.set $GcArray_123
          local.get $w844
          i32.const 1
          i32.add
          local.set $w844
          br $while_849_lp
        else
          br $while_849_exit
        end
      end
    end
    local.get $w836
    i32.const 1
    i32.sub
    local.set $w850
    ref.null $ListBase
    local.set $w851
    block $while_852_exit
      loop $while_852_lp
        local.get $w850
        i32.const 0
        i32.ge_s
        if
          local.get $w837
          local.get $w850
          array.get $GcArray_123
          local.get $w851
          struct.new $ListCons_30
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
    local.get $lo_clo_114
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_437 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_437 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w854 (ref null $ListBase))
    (local $w855 i32)
    local.get $list
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
          local.get $w854
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w855
          local.get $w854
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w854
          br $while_856_lp
        else
          br $while_856_exit
        end
      end
    end
    local.get $w855
  )
  (func $testListFlatten (result i32) ;; exported as "testListFlatten"
    (local $lo_clo_115 (ref $ClosureBase_33))
    (local $w858 (ref null $ListBase))
    (local $w859 (ref null $ListBase))
    (local $w861 (ref null $ListBase))
    (local $w862 (ref null $ListBase))
    ref.func $closure_437
    struct.new $ClosureType_438
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_115
    local.get $lo_clo_115
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w858
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w859
    block $while_860_exit
      loop $while_860_lp
        local.get $w858
        ref.is_null
        i32.eqz
        if
          local.get $w858
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w859
          struct.new $ListCons_30
          local.set $w859
          local.get $w858
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w858
          br $while_860_lp
        else
          br $while_860_exit
        end
      end
    end
    local.get $w859
    local.set $w861
    ref.null $ListBase
    local.set $w862
    block $while_863_exit
      loop $while_863_lp
        local.get $w861
        ref.is_null
        i32.eqz
        if
          local.get $w861
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w862
          struct.new $ListCons_30
          local.set $w862
          local.get $w861
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w861
          br $while_863_lp
        else
          br $while_863_exit
        end
      end
    end
    local.get $w862
    local.get $lo_clo_115
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
    (local $w865 (ref null $ListBase))
    (local $w866 (ref null $ListBase))
    (local $w867 (ref null $ListBase))
    (local $w869 (ref null $ListBase))
    (local $w870 (ref null $ListBase))
    (local $patternInput (ref $Tuple_62))
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
    local.set $w865
    local.get $ys
    local.set $w866
    ref.null $ListBase
    local.set $w867
    block $while_868_exit
      loop $while_868_lp
        local.get $w865
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w866
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w865
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w866
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          struct.new $Tuple_62
          local.get $w867
          struct.new $ListCons_63
          local.set $w867
          local.get $w865
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w865
          local.get $w866
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w866
          br $while_868_lp
        else
          br $while_868_exit
        end
      end
    end
    local.get $w867
    local.set $w869
    ref.null $ListBase
    local.set $w870
    block $while_871_exit
      loop $while_871_lp
        local.get $w869
        ref.is_null
        i32.eqz
        if
          local.get $w869
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 0
          local.get $w870
          struct.new $ListCons_63
          local.set $w870
          local.get $w869
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 1
          local.set $w869
          br $while_871_lp
        else
          br $while_871_exit
        end
      end
    end
    local.get $w870
    local.set $zipped
    local.get $zipped
    ref.cast (ref $ListCons_63)
    struct.get $ListCons_63 0
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_62 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_62 0
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_443 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w873 (ref null $ListBase))
    (local $w874 i32)
    local.get $list
    local.set $w873
    i32.const 0
    local.set $w874
    block $while_875_exit
      loop $while_875_lp
        local.get $w873
        ref.is_null
        i32.eqz
        if
          local.get $w874
          i32.const 1
          i32.add
          local.set $w874
          local.get $w873
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 1
          local.set $w873
          br $while_875_lp
        else
          br $while_875_exit
        end
      end
    end
    local.get $w874
  )
  (func $testListZipLen (result i32) ;; exported as "testListZipLen"
    (local $xs (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $lo_clo_116 (ref $ClosureBase_33))
    (local $w877 (ref null $ListBase))
    (local $w878 (ref null $ListBase))
    (local $w879 (ref null $ListBase))
    (local $w881 (ref null $ListBase))
    (local $w882 (ref null $ListBase))
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
    ref.func $closure_443
    struct.new $ClosureType_443
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_116
    local.get $lo_clo_116
    local.get $xs
    local.set $w877
    local.get $ys
    local.set $w878
    ref.null $ListBase
    local.set $w879
    block $while_880_exit
      loop $while_880_lp
        local.get $w877
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w878
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w877
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w878
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          struct.new $Tuple_62
          local.get $w879
          struct.new $ListCons_63
          local.set $w879
          local.get $w877
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w877
          local.get $w878
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w878
          br $while_880_lp
        else
          br $while_880_exit
        end
      end
    end
    local.get $w879
    local.set $w881
    ref.null $ListBase
    local.set $w882
    block $while_883_exit
      loop $while_883_lp
        local.get $w881
        ref.is_null
        i32.eqz
        if
          local.get $w881
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 0
          local.get $w882
          struct.new $ListCons_63
          local.set $w882
          local.get $w881
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 1
          local.set $w881
          br $while_883_lp
        else
          br $while_883_exit
        end
      end
    end
    local.get $w882
    local.get $lo_clo_116
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_444 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_444 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w885 (ref null $ListBase))
    (local $w886 i32)
    local.get $list
    local.set $w885
    i32.const 0
    local.set $w886
    block $while_887_exit
      loop $while_887_lp
        local.get $w885
        ref.is_null
        i32.eqz
        if
          local.get $w886
          local.get $w885
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w886
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
    local.get $w886
  )
  (func $closure_446 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_446))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_446)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_446 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_446 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_446
    local.get $a
    struct.new $ClosureType_446
  )
  (func $testListMap2Sum (result i32) ;; exported as "testListMap2Sum"
    (local $lo_clo_117 (ref $ClosureBase_33))
    (local $w889 (ref null $ListBase))
    (local $w890 (ref null $ListBase))
    (local $w891 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w893 (ref null $ListBase))
    (local $w894 (ref null $ListBase))
    ref.func $closure_444
    struct.new $ClosureType_445
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_117
    local.get $lo_clo_117
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w889
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w890
    ref.null $ListBase
    local.set $w891
    block $while_892_exit
      loop $while_892_lp
        local.get $w889
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w890
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w889
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $a
          local.get $w890
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $a
          local.get $b
          i32.add
          local.get $w891
          struct.new $ListCons_30
          local.set $w891
          local.get $w889
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w889
          local.get $w890
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w890
          br $while_892_lp
        else
          br $while_892_exit
        end
      end
    end
    local.get $w891
    local.set $w893
    ref.null $ListBase
    local.set $w894
    block $while_895_exit
      loop $while_895_lp
        local.get $w893
        ref.is_null
        i32.eqz
        if
          local.get $w893
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w894
          struct.new $ListCons_30
          local.set $w894
          local.get $w893
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w893
          br $while_895_lp
        else
          br $while_895_exit
        end
      end
    end
    local.get $w894
    local.get $lo_clo_117
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_448 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_449 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_449))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_449)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_449 1
    local.set $a
    local.get $a
    local.get $b
    i32.mul
  )
  (func $closure_449 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_449
    local.get $a
    struct.new $ClosureType_449
  )
  (func $testListMap2Head (result i32) ;; exported as "testListMap2Head"
    (local $lo_clo_118 (ref $ClosureBase_33))
    (local $w897 (ref null $ListBase))
    (local $w898 (ref null $ListBase))
    (local $w899 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w901 (ref null $ListBase))
    (local $w902 (ref null $ListBase))
    ref.func $closure_448
    struct.new $ClosureType_448
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_118
    local.get $lo_clo_118
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w897
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w898
    ref.null $ListBase
    local.set $w899
    block $while_900_exit
      loop $while_900_lp
        local.get $w897
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w898
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w897
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $a
          local.get $w898
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          local.get $w899
          struct.new $ListCons_30
          local.set $w899
          local.get $w897
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w897
          local.get $w898
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w898
          br $while_900_lp
        else
          br $while_900_exit
        end
      end
    end
    local.get $w899
    local.set $w901
    ref.null $ListBase
    local.set $w902
    block $while_903_exit
      loop $while_903_lp
        local.get $w901
        ref.is_null
        i32.eqz
        if
          local.get $w901
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w902
          struct.new $ListCons_30
          local.set $w902
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
    local.get $w902
    local.get $lo_clo_118
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_452 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionCounts (result i32) ;; exported as "testListPartitionCounts"
    (local $patternInput (ref $Tuple_451))
    (local $w905 (ref null $ListBase))
    (local $w906 (ref null $ListBase))
    (local $w907 (ref null $ListBase))
    (local $w908 i32)
    (local $w910 (ref null $ListBase))
    (local $w911 (ref null $ListBase))
    (local $w913 (ref null $ListBase))
    (local $w914 (ref null $ListBase))
    (local $odds (ref null $ListBase))
    (local $evens (ref null $ListBase))
    (local $w917 (ref null $ListBase))
    (local $w918 i32)
    (local $w921 (ref null $ListBase))
    (local $w922 i32)
    ref.null $ListBase
    local.set $w905
    ref.null $ListBase
    local.set $w906
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
    local.set $w907
    block $while_909_exit
      loop $while_909_lp
        local.get $w907
        ref.is_null
        i32.eqz
        if
          local.get $w907
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w908
          local.get $w908
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w908
            local.get $w905
            struct.new $ListCons_30
            local.set $w905
          else
            local.get $w908
            local.get $w906
            struct.new $ListCons_30
            local.set $w906
          end
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
    local.get $w905
    local.set $w910
    ref.null $ListBase
    local.set $w911
    block $while_912_exit
      loop $while_912_lp
        local.get $w910
        ref.is_null
        i32.eqz
        if
          local.get $w910
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w911
          struct.new $ListCons_30
          local.set $w911
          local.get $w910
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w910
          br $while_912_lp
        else
          br $while_912_exit
        end
      end
    end
    local.get $w911
    local.get $w906
    local.set $w913
    ref.null $ListBase
    local.set $w914
    block $while_915_exit
      loop $while_915_lp
        local.get $w913
        ref.is_null
        i32.eqz
        if
          local.get $w913
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w914
          struct.new $ListCons_30
          local.set $w914
          local.get $w913
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w913
          br $while_915_lp
        else
          br $while_915_exit
        end
      end
    end
    local.get $w914
    struct.new $Tuple_451
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_451 1
    local.set $odds
    local.get $patternInput
    struct.get $Tuple_451 0
    local.set $evens
    local.get $evens
    local.set $w917
    i32.const 0
    local.set $w918
    block $while_919_exit
      loop $while_919_lp
        local.get $w917
        ref.is_null
        i32.eqz
        if
          local.get $w918
          i32.const 1
          i32.add
          local.set $w918
          local.get $w917
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w917
          br $while_919_lp
        else
          br $while_919_exit
        end
      end
    end
    local.get $w918
    i32.const 10
    i32.mul
    local.get $odds
    local.set $w921
    i32.const 0
    local.set $w922
    block $while_923_exit
      loop $while_923_lp
        local.get $w921
        ref.is_null
        i32.eqz
        if
          local.get $w922
          i32.const 1
          i32.add
          local.set $w922
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
    local.get $w922
    i32.add
  )
  (func $closure_453 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_454 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionEvens (result i32) ;; exported as "testListPartitionEvens"
    (local $patternInput (ref $Tuple_451))
    (local $w925 (ref null $ListBase))
    (local $w926 (ref null $ListBase))
    (local $w927 (ref null $ListBase))
    (local $w928 i32)
    (local $w930 (ref null $ListBase))
    (local $w931 (ref null $ListBase))
    (local $w933 (ref null $ListBase))
    (local $w934 (ref null $ListBase))
    (local $evens (ref null $ListBase))
    (local $w937 (ref null $ListBase))
    (local $w938 i32)
    ref.null $ListBase
    local.set $w925
    ref.null $ListBase
    local.set $w926
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
    local.set $w927
    block $while_929_exit
      loop $while_929_lp
        local.get $w927
        ref.is_null
        i32.eqz
        if
          local.get $w927
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w928
          local.get $w928
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w928
            local.get $w925
            struct.new $ListCons_30
            local.set $w925
          else
            local.get $w928
            local.get $w926
            struct.new $ListCons_30
            local.set $w926
          end
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
    local.get $w925
    local.set $w930
    ref.null $ListBase
    local.set $w931
    block $while_932_exit
      loop $while_932_lp
        local.get $w930
        ref.is_null
        i32.eqz
        if
          local.get $w930
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w931
          struct.new $ListCons_30
          local.set $w931
          local.get $w930
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w930
          br $while_932_lp
        else
          br $while_932_exit
        end
      end
    end
    local.get $w931
    local.get $w926
    local.set $w933
    ref.null $ListBase
    local.set $w934
    block $while_935_exit
      loop $while_935_lp
        local.get $w933
        ref.is_null
        i32.eqz
        if
          local.get $w933
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w934
          struct.new $ListCons_30
          local.set $w934
          local.get $w933
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w933
          br $while_935_lp
        else
          br $while_935_exit
        end
      end
    end
    local.get $w934
    struct.new $Tuple_451
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_451 0
    local.set $evens
    local.get $evens
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
          local.get $w937
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w938
          local.get $w937
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w937
          br $while_939_lp
        else
          br $while_939_exit
        end
      end
    end
    local.get $w938
  )
  (func $closure_455 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_456 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionOdds (result i32) ;; exported as "testListPartitionOdds"
    (local $patternInput (ref $Tuple_451))
    (local $w941 (ref null $ListBase))
    (local $w942 (ref null $ListBase))
    (local $w943 (ref null $ListBase))
    (local $w944 i32)
    (local $w946 (ref null $ListBase))
    (local $w947 (ref null $ListBase))
    (local $w949 (ref null $ListBase))
    (local $w950 (ref null $ListBase))
    (local $odds (ref null $ListBase))
    (local $w953 (ref null $ListBase))
    (local $w954 i32)
    ref.null $ListBase
    local.set $w941
    ref.null $ListBase
    local.set $w942
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
    local.set $w943
    block $while_945_exit
      loop $while_945_lp
        local.get $w943
        ref.is_null
        i32.eqz
        if
          local.get $w943
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w944
          local.get $w944
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w944
            local.get $w941
            struct.new $ListCons_30
            local.set $w941
          else
            local.get $w944
            local.get $w942
            struct.new $ListCons_30
            local.set $w942
          end
          local.get $w943
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w943
          br $while_945_lp
        else
          br $while_945_exit
        end
      end
    end
    local.get $w941
    local.set $w946
    ref.null $ListBase
    local.set $w947
    block $while_948_exit
      loop $while_948_lp
        local.get $w946
        ref.is_null
        i32.eqz
        if
          local.get $w946
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w947
          struct.new $ListCons_30
          local.set $w947
          local.get $w946
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w946
          br $while_948_lp
        else
          br $while_948_exit
        end
      end
    end
    local.get $w947
    local.get $w942
    local.set $w949
    ref.null $ListBase
    local.set $w950
    block $while_951_exit
      loop $while_951_lp
        local.get $w949
        ref.is_null
        i32.eqz
        if
          local.get $w949
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w950
          struct.new $ListCons_30
          local.set $w950
          local.get $w949
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w949
          br $while_951_lp
        else
          br $while_951_exit
        end
      end
    end
    local.get $w950
    struct.new $Tuple_451
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_451 1
    local.set $odds
    local.get $odds
    local.set $w953
    i32.const 0
    local.set $w954
    block $while_955_exit
      loop $while_955_lp
        local.get $w953
        ref.is_null
        i32.eqz
        if
          local.get $w954
          local.get $w953
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w954
          local.get $w953
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w953
          br $while_955_lp
        else
          br $while_955_exit
        end
      end
    end
    local.get $w954
  )
  (func $closure_457 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionEmpty (result i32) ;; exported as "testListPartitionEmpty"
    (local $patternInput (ref $Tuple_451))
    (local $w957 (ref null $ListBase))
    (local $w958 (ref null $ListBase))
    (local $w959 (ref null $ListBase))
    (local $w960 i32)
    (local $w962 (ref null $ListBase))
    (local $w963 (ref null $ListBase))
    (local $w965 (ref null $ListBase))
    (local $w966 (ref null $ListBase))
    (local $b (ref null $ListBase))
    (local $a (ref null $ListBase))
    (local $w969 (ref null $ListBase))
    (local $w970 i32)
    (local $w973 (ref null $ListBase))
    (local $w974 i32)
    ref.null $ListBase
    local.set $w957
    ref.null $ListBase
    local.set $w958
    ref.null $ListBase
    local.set $w959
    block $while_961_exit
      loop $while_961_lp
        local.get $w959
        ref.is_null
        i32.eqz
        if
          local.get $w959
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w960
          local.get $w960
          i32.const 0
          i32.gt_s
          if
            local.get $w960
            local.get $w957
            struct.new $ListCons_30
            local.set $w957
          else
            local.get $w960
            local.get $w958
            struct.new $ListCons_30
            local.set $w958
          end
          local.get $w959
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w959
          br $while_961_lp
        else
          br $while_961_exit
        end
      end
    end
    local.get $w957
    local.set $w962
    ref.null $ListBase
    local.set $w963
    block $while_964_exit
      loop $while_964_lp
        local.get $w962
        ref.is_null
        i32.eqz
        if
          local.get $w962
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w963
          struct.new $ListCons_30
          local.set $w963
          local.get $w962
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w962
          br $while_964_lp
        else
          br $while_964_exit
        end
      end
    end
    local.get $w963
    local.get $w958
    local.set $w965
    ref.null $ListBase
    local.set $w966
    block $while_967_exit
      loop $while_967_lp
        local.get $w965
        ref.is_null
        i32.eqz
        if
          local.get $w965
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w966
          struct.new $ListCons_30
          local.set $w966
          local.get $w965
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w965
          br $while_967_lp
        else
          br $while_967_exit
        end
      end
    end
    local.get $w966
    struct.new $Tuple_451
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_451 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_451 0
    local.set $a
    local.get $a
    local.set $w969
    i32.const 0
    local.set $w970
    block $while_971_exit
      loop $while_971_lp
        local.get $w969
        ref.is_null
        i32.eqz
        if
          local.get $w970
          i32.const 1
          i32.add
          local.set $w970
          local.get $w969
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w969
          br $while_971_lp
        else
          br $while_971_exit
        end
      end
    end
    local.get $w970
    local.get $b
    local.set $w973
    i32.const 0
    local.set $w974
    block $while_975_exit
      loop $while_975_lp
        local.get $w973
        ref.is_null
        i32.eqz
        if
          local.get $w974
          i32.const 1
          i32.add
          local.set $w974
          local.get $w973
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w973
          br $while_975_lp
        else
          br $while_975_exit
        end
      end
    end
    local.get $w974
    i32.add
  )
  (func $closure_458 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionAllTrue (result i32) ;; exported as "testListPartitionAllTrue"
    (local $patternInput (ref $Tuple_451))
    (local $w977 (ref null $ListBase))
    (local $w978 (ref null $ListBase))
    (local $w979 (ref null $ListBase))
    (local $w980 i32)
    (local $w982 (ref null $ListBase))
    (local $w983 (ref null $ListBase))
    (local $w985 (ref null $ListBase))
    (local $w986 (ref null $ListBase))
    (local $b (ref null $ListBase))
    (local $a (ref null $ListBase))
    (local $w989 (ref null $ListBase))
    (local $w990 i32)
    (local $w993 (ref null $ListBase))
    (local $w994 i32)
    ref.null $ListBase
    local.set $w977
    ref.null $ListBase
    local.set $w978
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w979
    block $while_981_exit
      loop $while_981_lp
        local.get $w979
        ref.is_null
        i32.eqz
        if
          local.get $w979
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w980
          local.get $w980
          i32.const 0
          i32.gt_s
          if
            local.get $w980
            local.get $w977
            struct.new $ListCons_30
            local.set $w977
          else
            local.get $w980
            local.get $w978
            struct.new $ListCons_30
            local.set $w978
          end
          local.get $w979
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w979
          br $while_981_lp
        else
          br $while_981_exit
        end
      end
    end
    local.get $w977
    local.set $w982
    ref.null $ListBase
    local.set $w983
    block $while_984_exit
      loop $while_984_lp
        local.get $w982
        ref.is_null
        i32.eqz
        if
          local.get $w982
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w983
          struct.new $ListCons_30
          local.set $w983
          local.get $w982
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w982
          br $while_984_lp
        else
          br $while_984_exit
        end
      end
    end
    local.get $w983
    local.get $w978
    local.set $w985
    ref.null $ListBase
    local.set $w986
    block $while_987_exit
      loop $while_987_lp
        local.get $w985
        ref.is_null
        i32.eqz
        if
          local.get $w985
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w986
          struct.new $ListCons_30
          local.set $w986
          local.get $w985
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w985
          br $while_987_lp
        else
          br $while_987_exit
        end
      end
    end
    local.get $w986
    struct.new $Tuple_451
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_451 1
    local.set $b
    local.get $patternInput
    struct.get $Tuple_451 0
    local.set $a
    local.get $a
    local.set $w989
    i32.const 0
    local.set $w990
    block $while_991_exit
      loop $while_991_lp
        local.get $w989
        ref.is_null
        i32.eqz
        if
          local.get $w990
          i32.const 1
          i32.add
          local.set $w990
          local.get $w989
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w989
          br $while_991_lp
        else
          br $while_991_exit
        end
      end
    end
    local.get $w990
    i32.const 10
    i32.mul
    local.get $b
    local.set $w993
    i32.const 0
    local.set $w994
    block $while_995_exit
      loop $while_995_lp
        local.get $w993
        ref.is_null
        i32.eqz
        if
          local.get $w994
          i32.const 1
          i32.add
          local.set $w994
          local.get $w993
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w993
          br $while_995_lp
        else
          br $while_995_exit
        end
      end
    end
    local.get $w994
    i32.add
  )
  (func $closure_459 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionOrder (result i32) ;; exported as "testListPartitionOrder"
    (local $patternInput (ref $Tuple_451))
    (local $w997 (ref null $ListBase))
    (local $w998 (ref null $ListBase))
    (local $w999 (ref null $ListBase))
    (local $w1000 i32)
    (local $w1002 (ref null $ListBase))
    (local $w1003 (ref null $ListBase))
    (local $w1005 (ref null $ListBase))
    (local $w1006 (ref null $ListBase))
    (local $evens (ref null $ListBase))
    ref.null $ListBase
    local.set $w997
    ref.null $ListBase
    local.set $w998
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
    local.set $w999
    block $while_1001_exit
      loop $while_1001_lp
        local.get $w999
        ref.is_null
        i32.eqz
        if
          local.get $w999
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w1000
          local.get $w1000
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w1000
            local.get $w997
            struct.new $ListCons_30
            local.set $w997
          else
            local.get $w1000
            local.get $w998
            struct.new $ListCons_30
            local.set $w998
          end
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
    local.get $w997
    local.set $w1002
    ref.null $ListBase
    local.set $w1003
    block $while_1004_exit
      loop $while_1004_lp
        local.get $w1002
        ref.is_null
        i32.eqz
        if
          local.get $w1002
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1003
          struct.new $ListCons_30
          local.set $w1003
          local.get $w1002
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1002
          br $while_1004_lp
        else
          br $while_1004_exit
        end
      end
    end
    local.get $w1003
    local.get $w998
    local.set $w1005
    ref.null $ListBase
    local.set $w1006
    block $while_1007_exit
      loop $while_1007_lp
        local.get $w1005
        ref.is_null
        i32.eqz
        if
          local.get $w1005
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1006
          struct.new $ListCons_30
          local.set $w1006
          local.get $w1005
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1005
          br $while_1007_lp
        else
          br $while_1007_exit
        end
      end
    end
    local.get $w1006
    struct.new $Tuple_451
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_451 0
    local.set $evens
    local.get $evens
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_460 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w1009 (ref null $ListBase))
    (local $w1013 i32)
    (local $w1010 (ref null $ListBase))
    (local $w1011 i32)
    (local $w1014 (ref $GcArray_123))
    (local $w1015 (ref null $ListBase))
    (local $w1016 i32)
    (local $w1018 i32)
    (local $w1019 i32)
    (local $w1020 i32)
    (local $w1023 i32)
    (local $w1024 (ref null $ListBase))
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
    local.set $w1009
    local.get $w1009
    local.set $w1010
    i32.const 0
    local.set $w1011
    block $while_1012_exit
      loop $while_1012_lp
        local.get $w1010
        ref.is_null
        i32.eqz
        if
          local.get $w1011
          i32.const 1
          i32.add
          local.set $w1011
          local.get $w1010
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1010
          br $while_1012_lp
        else
          br $while_1012_exit
        end
      end
    end
    local.get $w1011
    local.set $w1013
    i32.const 0
    local.get $w1013
    array.new $GcArray_123
    local.set $w1014
    local.get $w1009
    local.set $w1015
    i32.const 0
    local.set $w1016
    block $while_1017_exit
      loop $while_1017_lp
        local.get $w1015
        ref.is_null
        i32.eqz
        if
          local.get $w1014
          local.get $w1016
          local.get $w1015
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_123
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
    drop
    i32.const 1
    local.set $w1018
    block $while_1022_exit
      loop $while_1022_lp
        local.get $w1018
        local.get $w1013
        i32.lt_s
        if
          local.get $w1014
          local.get $w1018
          array.get $GcArray_123
          local.set $w1019
          local.get $w1018
          i32.const 1
          i32.sub
          local.set $w1020
          block $while_1021_exit
            loop $while_1021_lp
              local.get $w1020
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1014
                local.get $w1020
                array.get $GcArray_123
                local.get $w1019
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
                local.get $w1014
                local.get $w1020
                i32.const 1
                i32.add
                local.get $w1014
                local.get $w1020
                array.get $GcArray_123
                array.set $GcArray_123
                local.get $w1020
                i32.const 1
                i32.sub
                local.set $w1020
                br $while_1021_lp
              else
                br $while_1021_exit
              end
            end
          end
          local.get $w1014
          local.get $w1020
          i32.const 1
          i32.add
          local.get $w1019
          array.set $GcArray_123
          local.get $w1018
          i32.const 1
          i32.add
          local.set $w1018
          br $while_1022_lp
        else
          br $while_1022_exit
        end
      end
    end
    local.get $w1013
    i32.const 1
    i32.sub
    local.set $w1023
    ref.null $ListBase
    local.set $w1024
    block $while_1025_exit
      loop $while_1025_lp
        local.get $w1023
        i32.const 0
        i32.ge_s
        if
          local.get $w1014
          local.get $w1023
          array.get $GcArray_123
          local.get $w1024
          struct.new $ListCons_30
          local.set $w1024
          local.get $w1023
          i32.const 1
          i32.sub
          local.set $w1023
          br $while_1025_lp
        else
          br $while_1025_exit
        end
      end
    end
    local.get $w1024
    local.set $sorted
    local.get $sorted
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_462 (param $self (ref $AnyFn)) (param $x (ref $WasmStr)) (param $y (ref $WasmStr)) (result i32)
    local.get $x
    local.get $y
    call $strCompare
  )
  (func $testListSortStrAsc (result i32) ;; exported as "testListSortStrAsc"
    (local $sorted (ref null $ListBase))
    (local $w1027 (ref null $ListBase))
    (local $w1031 i32)
    (local $w1028 (ref null $ListBase))
    (local $w1029 i32)
    (local $w1032 (ref $GcArray_465))
    (local $w1033 (ref null $ListBase))
    (local $w1034 i32)
    (local $w1036 i32)
    (local $w1037 (ref $WasmStr))
    (local $w1038 i32)
    (local $w1041 i32)
    (local $w1042 (ref null $ListBase))
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
    struct.new $ListCons_461
    struct.new $ListCons_461
    struct.new $ListCons_461
    local.set $w1027
    local.get $w1027
    local.set $w1028
    i32.const 0
    local.set $w1029
    block $while_1030_exit
      loop $while_1030_lp
        local.get $w1028
        ref.is_null
        i32.eqz
        if
          local.get $w1029
          i32.const 1
          i32.add
          local.set $w1029
          local.get $w1028
          ref.cast (ref $ListCons_461)
          struct.get $ListCons_461 1
          local.set $w1028
          br $while_1030_lp
        else
          br $while_1030_exit
        end
      end
    end
    local.get $w1029
    local.set $w1031
    ref.null $WasmStr
    local.get $w1031
    array.new $GcArray_465
    local.set $w1032
    local.get $w1027
    local.set $w1033
    i32.const 0
    local.set $w1034
    block $while_1035_exit
      loop $while_1035_lp
        local.get $w1033
        ref.is_null
        i32.eqz
        if
          local.get $w1032
          local.get $w1034
          local.get $w1033
          ref.cast (ref $ListCons_461)
          struct.get $ListCons_461 0
          array.set $GcArray_465
          local.get $w1034
          i32.const 1
          i32.add
          local.set $w1034
          local.get $w1033
          ref.cast (ref $ListCons_461)
          struct.get $ListCons_461 1
          local.set $w1033
          br $while_1035_lp
        else
          br $while_1035_exit
        end
      end
    end
    local.get $w1034
    drop
    i32.const 1
    local.set $w1036
    block $while_1040_exit
      loop $while_1040_lp
        local.get $w1036
        local.get $w1031
        i32.lt_s
        if
          local.get $w1032
          local.get $w1036
          array.get $GcArray_465
          ref.cast (ref $WasmStr)
          local.set $w1037
          local.get $w1036
          i32.const 1
          i32.sub
          local.set $w1038
          block $while_1039_exit
            loop $while_1039_lp
              local.get $w1038
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1032
                local.get $w1038
                array.get $GcArray_465
                ref.cast (ref $WasmStr)
                local.get $w1037
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
                local.get $w1032
                local.get $w1038
                i32.const 1
                i32.add
                local.get $w1032
                local.get $w1038
                array.get $GcArray_465
                ref.cast (ref $WasmStr)
                array.set $GcArray_465
                local.get $w1038
                i32.const 1
                i32.sub
                local.set $w1038
                br $while_1039_lp
              else
                br $while_1039_exit
              end
            end
          end
          local.get $w1032
          local.get $w1038
          i32.const 1
          i32.add
          local.get $w1037
          array.set $GcArray_465
          local.get $w1036
          i32.const 1
          i32.add
          local.set $w1036
          br $while_1040_lp
        else
          br $while_1040_exit
        end
      end
    end
    local.get $w1031
    i32.const 1
    i32.sub
    local.set $w1041
    ref.null $ListBase
    local.set $w1042
    block $while_1043_exit
      loop $while_1043_lp
        local.get $w1041
        i32.const 0
        i32.ge_s
        if
          local.get $w1032
          local.get $w1041
          array.get $GcArray_465
          ref.cast (ref $WasmStr)
          local.get $w1042
          struct.new $ListCons_461
          local.set $w1042
          local.get $w1041
          i32.const 1
          i32.sub
          local.set $w1041
          br $while_1043_lp
        else
          br $while_1043_exit
        end
      end
    end
    local.get $w1042
    local.set $sorted
    local.get $sorted
    ref.cast (ref $ListCons_461)
    struct.get $ListCons_461 0
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
  (func $closure_466 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_466 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1045 (ref null $ListBase))
    (local $w1046 i32)
    local.get $list
    local.set $w1045
    i32.const 0
    local.set $w1046
    block $while_1047_exit
      loop $while_1047_lp
        local.get $w1045
        ref.is_null
        i32.eqz
        if
          local.get $w1046
          local.get $w1045
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1046
          local.get $w1045
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1045
          br $while_1047_lp
        else
          br $while_1047_exit
        end
      end
    end
    local.get $w1046
  )
  (func $testSeqToList (result i32) ;; exported as "testSeqToList"
    (local $xs (ref null $ListBase))
    (local $lo_clo_119 (ref $ClosureBase_33))
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $xs
    ref.func $closure_466
    struct.new $ClosureType_467
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_119
    local.get $lo_clo_119
    local.get $xs
    local.get $lo_clo_119
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_468 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_469 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListUnzip (result i32) ;; exported as "testListUnzip"
    (local $pairs (ref null $ListBase))
    (local $patternInput (ref $Tuple_451))
    (local $w1049 (ref null $ListBase))
    (local $w1054 (ref null $ListBase))
    (local $w1050 (ref null $ListBase))
    (local $w1051 (ref null $ListBase))
    (local $w1052 (ref $Tuple_62))
    (local $w1055 (ref null $ListBase))
    (local $w1057 (ref null $ListBase))
    (local $w1058 (ref null $ListBase))
    (local $ys (ref null $ListBase))
    (local $xs (ref null $ListBase))
    (local $w1061 (ref null $ListBase))
    (local $w1062 i32)
    (local $w1065 (ref null $ListBase))
    (local $w1066 i32)
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    local.set $pairs
    ref.null $ListBase
    local.set $w1049
    local.get $pairs
    local.set $w1050
    ref.null $ListBase
    local.set $w1051
    block $while_1053_exit
      loop $while_1053_lp
        local.get $w1050
        ref.is_null
        i32.eqz
        if
          local.get $w1050
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 0
          local.set $w1052
          local.get $w1052
          struct.get $Tuple_62 1
          local.get $w1049
          struct.new $ListCons_30
          local.set $w1049
          local.get $w1052
          struct.get $Tuple_62 0
          local.get $w1051
          struct.new $ListCons_30
          local.set $w1051
          local.get $w1050
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 1
          local.set $w1050
          br $while_1053_lp
        else
          br $while_1053_exit
        end
      end
    end
    local.get $w1051
    local.set $w1054
    ref.null $ListBase
    local.set $w1055
    block $while_1056_exit
      loop $while_1056_lp
        local.get $w1054
        ref.is_null
        i32.eqz
        if
          local.get $w1054
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1055
          struct.new $ListCons_30
          local.set $w1055
          local.get $w1054
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1054
          br $while_1056_lp
        else
          br $while_1056_exit
        end
      end
    end
    local.get $w1055
    local.get $w1049
    local.set $w1057
    ref.null $ListBase
    local.set $w1058
    block $while_1059_exit
      loop $while_1059_lp
        local.get $w1057
        ref.is_null
        i32.eqz
        if
          local.get $w1057
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1058
          struct.new $ListCons_30
          local.set $w1058
          local.get $w1057
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1057
          br $while_1059_lp
        else
          br $while_1059_exit
        end
      end
    end
    local.get $w1058
    struct.new $Tuple_451
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_451 1
    local.set $ys
    local.get $patternInput
    struct.get $Tuple_451 0
    local.set $xs
    local.get $xs
    local.set $w1061
    i32.const 0
    local.set $w1062
    block $while_1063_exit
      loop $while_1063_lp
        local.get $w1061
        ref.is_null
        i32.eqz
        if
          local.get $w1062
          local.get $w1061
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1062
          local.get $w1061
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1061
          br $while_1063_lp
        else
          br $while_1063_exit
        end
      end
    end
    local.get $w1062
    local.get $ys
    local.set $w1065
    i32.const 0
    local.set $w1066
    block $while_1067_exit
      loop $while_1067_lp
        local.get $w1065
        ref.is_null
        i32.eqz
        if
          local.get $w1066
          local.get $w1065
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1066
          local.get $w1065
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1065
          br $while_1067_lp
        else
          br $while_1067_exit
        end
      end
    end
    local.get $w1066
    i32.add
  )
  (func $closure_472 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_473 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_473 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testListGroupBy (result i32) ;; exported as "testListGroupBy"
    (local $groups (ref null $ListBase))
    (local $lo_clo_120 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_472))
    (local $w1069 (ref null $ListBase))
    (local $w1070 i32)
    ref.func $closure_472
    struct.new $ClosureType_472
    local.set $projection
    ref.func $closure_473
    local.get $projection
    struct.new $ClosureType_474
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_120
    local.get $lo_clo_120
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
    local.get $lo_clo_120
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.set $groups
    local.get $groups
    local.set $w1069
    i32.const 0
    local.set $w1070
    block $while_1071_exit
      loop $while_1071_lp
        local.get $w1069
        ref.is_null
        i32.eqz
        if
          local.get $w1070
          i32.const 1
          i32.add
          local.set $w1070
          local.get $w1069
          ref.cast (ref $ListCons_471)
          struct.get $ListCons_471 1
          local.set $w1069
          br $while_1071_lp
        else
          br $while_1071_exit
        end
      end
    end
    local.get $w1070
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
  (func $closure_479 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    (local $w1073 (ref null $ListBase))
    (local $w1074 i32)
    local.get $list_1
    local.set $w1073
    i32.const 0
    local.set $w1074
    block $while_1075_exit
      loop $while_1075_lp
        local.get $w1073
        ref.is_null
        i32.eqz
        if
          local.get $w1074
          i32.const 1
          i32.add
          local.set $w1074
          local.get $w1073
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1073
          br $while_1075_lp
        else
          br $while_1075_exit
        end
      end
    end
    local.get $w1074
  )
  (func $closure_480 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_481 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_481 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testListDistinctBy (result i32) ;; exported as "testListDistinctBy"
    (local $lo_clo_122 (ref $ClosureBase_33))
    (local $lo_clo_121 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_480))
    ref.func $closure_479
    struct.new $ClosureType_479
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_122
    local.get $lo_clo_122
    ref.func $closure_480
    struct.new $ClosureType_480
    local.set $projection
    ref.func $closure_481
    local.get $projection
    struct.new $ClosureType_482
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_121
    local.get $lo_clo_121
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
    local.get $lo_clo_121
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_122
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_483 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_484 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1077 (ref null $ListBase))
    (local $w1078 i32)
    local.get $list
    local.set $w1077
    i32.const 0
    local.set $w1078
    block $while_1079_exit
      loop $while_1079_lp
        local.get $w1077
        ref.is_null
        i32.eqz
        if
          local.get $w1078
          i32.const 1
          i32.add
          local.set $w1078
          local.get $w1077
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 1
          local.set $w1077
          br $while_1079_lp
        else
          br $while_1079_exit
        end
      end
    end
    local.get $w1078
  )
  (func $testMapToList (result i32) ;; exported as "testMapToList"
    (local $m (ref $MapModule_MapHandle`2))
    (local $lo_clo_123 (ref $ClosureBase_33))
    ref.func $closure_483
    struct.new $ClosureType_483
    i32.const 1
    i32.const 10
    struct.new $Tuple_62
    i32.const 2
    i32.const 20
    struct.new $Tuple_62
    i32.const 3
    i32.const 30
    struct.new $Tuple_62
    ref.null $ListBase
    struct.new $ListCons_63
    struct.new $ListCons_63
    struct.new $ListCons_63
    call $Map_ofList
    local.set $m
    ref.func $closure_484
    struct.new $ClosureType_484
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_123
    local.get $lo_clo_123
    local.get $m
    call $Map_toList
    local.get $lo_clo_123
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_485 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_485
    struct.new $ClosureType_485
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
  (func $closure_487 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1081 (ref null $ListBase))
    (local $w1082 i32)
    local.get $list
    local.set $w1081
    i32.const 0
    local.set $w1082
    block $while_1083_exit
      loop $while_1083_lp
        local.get $w1081
        ref.is_null
        i32.eqz
        if
          local.get $w1082
          i32.const 1
          i32.add
          local.set $w1082
          local.get $w1081
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1081
          br $while_1083_lp
        else
          br $while_1083_exit
        end
      end
    end
    local.get $w1082
  )
  (func $testSetToList (result i32) ;; exported as "testSetToList"
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_124 (ref $ClosureBase_33))
    ref.func $closure_486
    struct.new $ClosureType_486
    i32.const 3
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_487
    struct.new $ClosureType_487
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_124
    local.get $lo_clo_124
    local.get $s
    call $Set_toList
    local.get $lo_clo_124
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_488 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_488))
    (local $target i32)
    local.get $self
    ref.cast (ref $ClosureType_488)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_488 1
    local.set $target
    local.get $x
    local.get $target
    i32.eq
  )
  (func $testClosureCapListExists (result i32) ;; exported as "testClosureCapListExists"
    (local $w1085 (ref null $ListBase))
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
    local.set $w1085
    block $exi_1084_blk (result i32)
      block $exi_1084_lp_exit
        loop $exi_1084_lp
          local.get $w1085
          ref.is_null
          i32.eqz
          if
            local.get $w1085
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 7
            i32.eq
            if
              i32.const 1
              br $exi_1084_blk
            end
            local.get $w1085
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1085
          else
            br $exi_1084_lp_exit
          end
          br $exi_1084_lp
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
  (func $closure_489 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_489))
    (local $bound i32)
    local.get $self
    ref.cast (ref $ClosureType_489)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_489 1
    local.set $bound
    local.get $x
    local.get $bound
    i32.lt_s
  )
  (func $testClosureCapListForAll (result i32) ;; exported as "testClosureCapListForAll"
    (local $w1087 (ref null $ListBase))
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
    local.set $w1087
    block $all_1086_blk (result i32)
      block $all_1086_lp_exit
        loop $all_1086_lp
          local.get $w1087
          ref.is_null
          i32.eqz
          if
            local.get $w1087
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.lt_s
            if
              local.get $w1087
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w1087
            else
              i32.const 0
              br $all_1086_blk
            end
          else
            br $all_1086_lp_exit
          end
          br $all_1086_lp
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
  (func $closure_490 (param $self (ref $AnyFn)) (param $m_2 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_490))
    (local $key_2 i32)
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_490)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_490 1
    local.set $key_2
    local.get $self_cast
    struct.get $ClosureType_490 2
    local.set $value_2
    local.get $key_2
    local.get $value_2
    local.get $m_2
    call $Map_add
  )
  (func $closure_491 (param $self (ref $AnyFn)) (param $m_1 (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_491))
    (local $key_1 i32)
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_491)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_491 1
    local.set $key_1
    local.get $self_cast
    struct.get $ClosureType_491 2
    local.set $value_1
    local.get $key_1
    local.get $value_1
    local.get $m_1
    call $Map_add
  )
  (func $closure_492 (param $self (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    (local $self_cast (ref $ClosureType_492))
    (local $key i32)
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_492)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_492 1
    local.set $key
    local.get $self_cast
    struct.get $ClosureType_492 2
    local.set $value
    local.get $key
    local.get $value
    local.get $m
    call $Map_add
  )
  (func $closure_493 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_493))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_493)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_493 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_493 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_493
    local.get $a
    struct.new $ClosureType_493
  )
  (func $closure_495 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    (local $w1089 (ref null $ListBase))
    (local $w1090 i32)
    local.get $list
    local.set $w1089
    i32.const 0
    local.set $w1090
    block $while_1091_exit
      loop $while_1091_lp
        local.get $w1089
        ref.is_null
        i32.eqz
        if
          local.get $w1090
          i32.const 1
          i32.add
          local.set $w1090
          local.get $w1089
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 1
          local.set $w1089
          br $while_1091_lp
        else
          br $while_1091_exit
        end
      end
    end
    local.get $w1090
  )
  (func $testMapModuleToList (result i32) ;; exported as "testMapModuleToList"
    (local $m_3 (ref $MapModule_MapHandle`2))
    (local $lo_clo_127 (ref $ClosureBase_233))
    (local $lo_clo_126 (ref $ClosureBase_233))
    (local $lo_clo_125 (ref $ClosureBase_233))
    (local $lo_clo_128 (ref $ClosureBase_33))
    ref.func $closure_490
    i32.const 2
    i32.const 20
    struct.new $ClosureType_490
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_127
    local.get $lo_clo_127
    ref.func $closure_491
    i32.const 1
    i32.const 10
    struct.new $ClosureType_491
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_126
    local.get $lo_clo_126
    ref.func $closure_492
    i32.const 3
    i32.const 30
    struct.new $ClosureType_492
    ref.cast (ref $ClosureBase_233)
    local.set $lo_clo_125
    local.get $lo_clo_125
    ref.func $closure_493
    struct.new $ClosureType_494
    call $Map_empty
    local.get $lo_clo_125
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_126
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.get $lo_clo_127
    struct.get $ClosureBase_233 0
    call_ref $FuncType_232
    local.set $m_3
    ref.func $closure_495
    struct.new $ClosureType_495
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_128
    local.get $lo_clo_128
    local.get $m_3
    call $Map_toList
    local.get $lo_clo_128
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $runListTests (param $check (ref $AnyFn)) ;; exported as "runListTests"
  )
  (func $closure_496 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbLength (result i32) ;; exported as "testSbLength"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_129 (ref $ClosureBase_497))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_496
    struct.new $ClosureType_498
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_129
    local.get $lo_clo_129
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    local.get $lo_clo_129
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $closure_499 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_500 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $testSbAppendTwo (result i32) ;; exported as "testSbAppendTwo"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_130 (ref $ClosureBase_497))
    (local $lo_clo_131 (ref $ClosureBase_497))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_499
    struct.new $ClosureType_499
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_130
    local.get $lo_clo_130
    local.get $sb
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_130
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    ref.func $closure_500
    struct.new $ClosureType_500
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_131
    local.get $lo_clo_131
    local.get $sb
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_131
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $closure_501 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbGrow (result i32) ;; exported as "testSbGrow"
    (local $sb (ref $StringBuilder))
    (local $forLoopVar i32)
    (local $lo_clo_132 (ref $ClosureBase_497))
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
        ref.func $closure_501
        struct.new $ClosureType_501
        ref.cast (ref $ClosureBase_497)
        local.set $lo_clo_132
        local.get $lo_clo_132
        local.get $sb
        i32.const 120
        array.new_fixed $WasmStr 1
        call $sbAppend
        local.get $lo_clo_132
        struct.get $ClosureBase_497 0
        call_ref $FuncType_496
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
  (func $closure_502 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_503 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $closure_504 (param $self (ref $AnyFn)) (param $value_2 (ref $StringBuilder))
    local.get $value_2
  )
  (func $closure_505 (param $self (ref $AnyFn)) (param $value_3 (ref $StringBuilder))
    local.get $value_3
  )
  (func $closure_506 (param $self (ref $AnyFn)) (param $value_4 (ref $StringBuilder))
    local.get $value_4
  )
  (func $testSbChained (result i32) ;; exported as "testSbChained"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_133 (ref $ClosureBase_497))
    (local $lo_clo_134 (ref $ClosureBase_497))
    (local $lo_clo_135 (ref $ClosureBase_497))
    (local $lo_clo_136 (ref $ClosureBase_497))
    (local $lo_clo_137 (ref $ClosureBase_497))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_502
    struct.new $ClosureType_502
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_133
    local.get $lo_clo_133
    local.get $sb
    i32.const 97
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_133
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    ref.func $closure_503
    struct.new $ClosureType_503
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_134
    local.get $lo_clo_134
    local.get $sb
    i32.const 98
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_134
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    ref.func $closure_504
    struct.new $ClosureType_504
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_135
    local.get $lo_clo_135
    local.get $sb
    i32.const 99
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_135
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    ref.func $closure_505
    struct.new $ClosureType_505
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_136
    local.get $lo_clo_136
    local.get $sb
    i32.const 100
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_136
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    ref.func $closure_506
    struct.new $ClosureType_506
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_137
    local.get $lo_clo_137
    local.get $sb
    i32.const 101
    array.new_fixed $WasmStr 1
    call $sbAppend
    local.get $lo_clo_137
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
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
  (func $closure_507 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_507 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
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
  (func $closure_509 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_510 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqMap (result i32) ;; exported as "testSeqMap"
    (local $lo_clo_139 (ref $ClosureBase_26))
    (local $lo_clo_138 (ref $ClosureBase_33))
    (local $mapping (ref $ClosureType_509))
    ref.func $closure_507
    struct.new $ClosureType_508
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_139
    local.get $lo_clo_139
    ref.func $closure_509
    struct.new $ClosureType_509
    local.set $mapping
    ref.func $closure_510
    local.get $mapping
    struct.new $ClosureType_510
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_138
    local.get $lo_clo_138
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
    local.get $lo_clo_138
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_139
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_511 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
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
  (func $closure_512 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_513 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqFilter (result i32) ;; exported as "testSeqFilter"
    (local $lo_clo_141 (ref $ClosureBase_26))
    (local $lo_clo_140 (ref $ClosureBase_33))
    (local $predicate (ref $ClosureType_512))
    ref.func $closure_511
    struct.new $ClosureType_511
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_141
    local.get $lo_clo_141
    ref.func $closure_512
    struct.new $ClosureType_512
    local.set $predicate
    ref.func $closure_513
    local.get $predicate
    struct.new $ClosureType_513
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_140
    local.get $lo_clo_140
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
    local.get $lo_clo_140
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_141
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_514 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_514))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_514)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_514 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_514 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_514
    local.get $acc
    struct.new $ClosureType_514
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
  (func $closure_516 (param $self (ref $AnyFn)) (param $x i32) (result i32)
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
  (func $closure_517 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_518 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_518 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqSumBy (result i32) ;; exported as "testSeqSumBy"
    (local $lo_clo_142 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_517))
    ref.func $closure_517
    struct.new $ClosureType_517
    local.set $projection
    ref.func $closure_518
    local.get $projection
    struct.new $ClosureType_519
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_142
    local.get $lo_clo_142
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
    local.get $lo_clo_142
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_520 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_520 (param $self (ref $AnyFn)) (param $source i32) (result i32)
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
  (func $closure_522 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $testSeqInit (result i32) ;; exported as "testSeqInit"
    (local $lo_clo_143 (ref $ClosureBase_33))
    (local $w1111 i32)
    (local $w1112 (ref null $ListBase))
    ref.func $closure_520
    struct.new $ClosureType_521
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_143
    local.get $lo_clo_143
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
    local.get $lo_clo_143
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_523 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_523 (param $self (ref $AnyFn)) (param $source_2 i32) (result i32)
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
  (func $closure_525 (param $self (ref $AnyFn)) (param $tupledArg (ref $Tuple_62)) (result i32)
    (local $a i32)
    (local $b i32)
    local.get $tupledArg
    struct.get $Tuple_62 0
    local.set $a
    local.get $tupledArg
    struct.get $Tuple_62 1
    local.set $b
    local.get $b
    local.get $a
    i32.sub
  )
  (func $closure_528 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
  )
  (func $closure_529 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
    (local $w1120 (ref $ListCons_30))
    (local $w1121 i32)
    (local $w1127 (ref null $ListBase))
    (local $w1122 (ref null $ListBase))
    (local $w1123 (ref null $ListBase))
    (local $w1124 i32)
    (local $w1125 (ref $Tuple_62))
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
            struct.new $Tuple_62
            local.set $w1125
            local.get $w1124
            local.set $w1121
            local.get $w1125
            local.get $w1123
            struct.new $ListCons_63
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
            ref.cast (ref $ListCons_63)
            struct.get $ListCons_63 0
            local.get $w1128
            struct.new $ListCons_63
            local.set $w1128
            local.get $w1127
            ref.cast (ref $ListCons_63)
            struct.get $ListCons_63 1
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
    (local $lo_clo_146 (ref $ClosureBase_26))
    (local $lo_clo_145 (ref $ClosureBase_26))
    (local $mapping (ref $ClosureType_527))
    (local $lo_clo_144 (ref $ClosureBase_33))
    ref.func $closure_523
    struct.new $ClosureType_524
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_146
    local.get $lo_clo_146
    ref.func $closure_525
    struct.new $ClosureType_527
    local.set $mapping
    ref.func $closure_528
    local.get $mapping
    struct.new $ClosureType_528
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_145
    local.get $lo_clo_145
    ref.func $closure_529
    struct.new $ClosureType_529
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_144
    local.get $lo_clo_144
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
    local.get $lo_clo_144
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_145
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
    local.get $lo_clo_146
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_530 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_531 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_531 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqCountBy (result i32) ;; exported as "testSeqCountBy"
    (local $result i32)
    (local $lo_clo_147 (ref $ClosureBase_33))
    (local $projection (ref $ClosureType_530))
    (local $w1131 i32)
    (local $w1132 i32)
    ref.func $closure_530
    struct.new $ClosureType_530
    local.set $projection
    ref.func $closure_531
    local.get $projection
    struct.new $ClosureType_532
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_147
    local.get $lo_clo_147
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
    local.get $lo_clo_147
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
          ref.cast (ref $ListCons_63)
          struct.get $ListCons_63 1
          local.set $w1131
          br $while_1133_lp
        else
          br $while_1133_exit
        end
      end
    end
    local.get $w1132
  )
  (func $closure_533 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
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
  (func $closure_534 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $closure_534 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
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
    (local $lo_clo_149 (ref $ClosureBase_26))
    (local $lo_clo_148 (ref $ClosureBase_33))
    ref.func $closure_533
    struct.new $ClosureType_533
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_149
    local.get $lo_clo_149
    ref.func $closure_534
    struct.new $ClosureType_535
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_148
    local.get $lo_clo_148
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
    local.get $lo_clo_148
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_149
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_536 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_536 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
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
  (func $closure_538 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_53))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_53))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_53
    else
      ref.null $Option_53
    end
  )
  (func $closure_539 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqChoose (result i32) ;; exported as "testSeqChoose"
    (local $lo_clo_151 (ref $ClosureBase_26))
    (local $lo_clo_150 (ref $ClosureBase_33))
    (local $chooser (ref $ClosureType_538))
    ref.func $closure_536
    struct.new $ClosureType_537
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_151
    local.get $lo_clo_151
    ref.func $closure_538
    struct.new $ClosureType_538
    local.set $chooser
    ref.func $closure_539
    local.get $chooser
    struct.new $ClosureType_539
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_150
    local.get $lo_clo_150
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
    local.get $lo_clo_150
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_151
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_540 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_540 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
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
  (func $closure_542 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $closure_543 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqCollect (result i32) ;; exported as "testSeqCollect"
    (local $lo_clo_153 (ref $ClosureBase_26))
    (local $lo_clo_152 (ref $ClosureBase_33))
    (local $mapping (ref $ClosureType_542))
    ref.func $closure_540
    struct.new $ClosureType_541
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_153
    local.get $lo_clo_153
    ref.func $closure_542
    struct.new $ClosureType_542
    local.set $mapping
    ref.func $closure_543
    local.get $mapping
    struct.new $ClosureType_543
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_152
    local.get $lo_clo_152
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_152
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
    local.get $lo_clo_153
    struct.get $ClosureBase_26 0
    call_ref $FuncType_25
  )
  (func $closure_544 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_544))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_544)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_544 1
    local.set $a
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_544 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_544
    local.get $a
    struct.new $ClosureType_544
  )
  (func $closure_546 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqReduce (result i32) ;; exported as "testSeqReduce"
    (local $lo_clo_154 (ref $ClosureBase_33))
    (local $reduction (ref $ClosureType_545))
    ref.func $closure_544
    struct.new $ClosureType_545
    local.set $reduction
    ref.func $closure_546
    local.get $reduction
    struct.new $ClosureType_546
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_154
    local.get $lo_clo_154
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
    local.get $lo_clo_154
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_547 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_547 (param $self (ref $AnyFn)) (param $source_1 i32) (result i32)
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
  (func $closure_549 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_549))
    (local $i i32)
    local.get $self
    ref.cast (ref $ClosureType_549)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_549 1
    local.set $i
    local.get $i
    local.get $x
    i32.add
  )
  (func $closure_549 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_549
    local.get $i
    struct.new $ClosureType_549
  )
  (func $closure_551 (param $self (ref $AnyFn)) (param $source (ref null $ListBase)) (result i32)
  )
  (func $testSeqMapIndexed (result i32) ;; exported as "testSeqMapIndexed"
    (local $lo_clo_156 (ref $ClosureBase_26))
    (local $lo_clo_155 (ref $ClosureBase_33))
    (local $mapping (ref $ClosureType_550))
    ref.func $closure_547
    struct.new $ClosureType_548
    ref.cast (ref $ClosureBase_26)
    local.set $lo_clo_156
    local.get $lo_clo_156
    ref.func $closure_549
    struct.new $ClosureType_550
    local.set $mapping
    ref.func $closure_551
    local.get $mapping
    struct.new $ClosureType_551
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_155
    local.get $lo_clo_155
    i32.const 10
    i32.const 20
    i32.const 30
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
  (func $closure_552 (param $self (ref $AnyFn)) (param $x i32) (result i32)
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
    (local $matchValue (ref null $Option_53))
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
    if (result (ref null $Option_53))
      ref.null $Option_53
    else
      local.get $w1162
      ref.cast (ref $ListCons_30)
      struct.get $ListCons_30 0
      struct.new $Option_53
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_53)
      struct.get $Option_53 0
    end
  )
  (func $testSeqTryHeadEmpty (result i32) ;; exported as "testSeqTryHeadEmpty"
    (local $matchValue (ref null $Option_53))
    ref.null $Option_53
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
  (func $closure_553 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_554 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
  (func $closure_555 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
    local.get $list_1
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_556 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_557 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
  (func $closure_557 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testSeqSortBy (result i32) ;; exported as "testSeqSortBy"
    (local $lo_clo_158 (ref $ClosureBase_33))
    (local $lo_clo_157 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_556))
    ref.func $closure_555
    struct.new $ClosureType_555
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_158
    local.get $lo_clo_158
    ref.func $closure_556
    struct.new $ClosureType_556
    local.set $projection
    ref.func $closure_557
    local.get $projection
    struct.new $ClosureType_558
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_157
    local.get $lo_clo_157
    i32.const 30
    i32.const 10
    i32.const 20
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.get $lo_clo_157
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_158
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_559 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result i32)
    local.get $list
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testSeqRev (result i32) ;; exported as "testSeqRev"
    (local $lo_clo_159 (ref $ClosureBase_33))
    (local $w1188 (ref null $ListBase))
    (local $w1189 (ref null $ListBase))
    ref.func $closure_559
    struct.new $ClosureType_559
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_159
    local.get $lo_clo_159
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
    local.get $lo_clo_159
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_560 (param $self (ref $AnyFn)) (param $x i32) (result i32)
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
  (func $closure_561 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_561 (param $self (ref $AnyFn)) (param $list_2 (ref null $ListBase)) (result i32)
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
  (func $closure_563 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_563))
    (local $count_1 i32)
    (local $w1203 (ref null $ListBase))
    (local $w1199 i32)
    (local $w1200 (ref null $ListBase))
    (local $w1201 (ref null $ListBase))
    (local $w1204 (ref null $ListBase))
    local.get $self
    ref.cast (ref $ClosureType_563)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_563 1
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
  (func $closure_564 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_564))
    (local $count i32)
    (local $w1207 i32)
    (local $w1208 (ref null $ListBase))
    local.get $self
    ref.cast (ref $ClosureType_564)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_564 1
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
    (local $lo_clo_162 (ref $ClosureBase_33))
    (local $lo_clo_161 (ref $ClosureBase_37))
    (local $lo_clo_160 (ref $ClosureBase_37))
    ref.func $closure_561
    struct.new $ClosureType_562
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_162
    local.get $lo_clo_162
    ref.func $closure_563
    i32.const 2
    struct.new $ClosureType_563
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_161
    local.get $lo_clo_161
    ref.func $closure_564
    i32.const 2
    struct.new $ClosureType_564
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_160
    local.get $lo_clo_160
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
    local.get $lo_clo_160
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_161
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_162
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $closure_565 (param $self (ref $AnyFn)) (param $list_1 (ref null $ListBase)) (result i32)
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
          ref.cast (ref $ListCons_471)
          struct.get $ListCons_471 1
          local.set $w1211
          br $while_1213_lp
        else
          br $while_1213_exit
        end
      end
    end
    local.get $w1212
  )
  (func $closure_566 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_567 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $closure_567 (param $self (ref $AnyFn)) (param $list (ref null $ListBase)) (result (ref null $ListBase))
  )
  (func $testSeqGroupByCount (result i32) ;; exported as "testSeqGroupByCount"
    (local $lo_clo_164 (ref $ClosureBase_33))
    (local $lo_clo_163 (ref $ClosureBase_37))
    (local $projection (ref $ClosureType_566))
    ref.func $closure_565
    struct.new $ClosureType_565
    ref.cast (ref $ClosureBase_33)
    local.set $lo_clo_164
    local.get $lo_clo_164
    ref.func $closure_566
    struct.new $ClosureType_566
    local.set $projection
    ref.func $closure_567
    local.get $projection
    struct.new $ClosureType_568
    ref.cast (ref $ClosureBase_37)
    local.set $lo_clo_163
    local.get $lo_clo_163
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
    local.get $lo_clo_163
    struct.get $ClosureBase_37 0
    call_ref $FuncType_36
    local.get $lo_clo_164
    struct.get $ClosureBase_33 0
    call_ref $FuncType_32
  )
  (func $runSeqTests (param $check (ref $AnyFn)) ;; exported as "runSeqTests"
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
    call $runStringBuilderTests
  )
  (func $closure_570 (param $self (ref $AnyFn)) (param $f (ref $AnyFn))
    (local $self_cast (ref $ClosureType_572))
    (local $failed i32)
    (local $passed i32)
    (local $lo_clo_165 (ref $ClosureBase_49))
    local.get $self
    ref.cast (ref $ClosureType_572)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_572 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_572 2
    local.set $passed
    (block
      (block
        (try_table (catch_all 0)
                local.get $f
                ref.cast (ref $ClosureBase_49)
                local.set $lo_clo_165
                local.get $lo_clo_165
                local.get $lo_clo_165
                struct.get $ClosureBase_49 0
                call_ref $FuncType_9
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
  (func $closure_570 (param $self (ref $AnyFn)) (param $name i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_573))
    (local $failed i32)
    (local $passed i32)
    local.get $self
    ref.cast (ref $ClosureType_573)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_573 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_573 2
    local.set $passed
    ref.func $closure_570
    local.get $failed
    local.get $passed
    struct.new $ClosureType_572
  )
  (func $main (param $_arg (ref $GcArray_569)) (result i32) ;; exported as "main"
    (local $passed i32)
    (local $failed i32)
    (local $check (ref $ClosureType_573))
    i32.const 0
    local.set $passed
    i32.const 0
    local.set $failed
    ref.func $closure_570
    local.get $failed
    local.get $passed
    struct.new $ClosureType_573
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
    (local $parts (ref $GcArray_569))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_569 1
    i32.const 0
    array.get $GcArray_569
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitFirst (result i32) ;; exported as "testStrSplitFirst"
    (local $parts (ref $GcArray_569))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_569 1
    i32.const 0
    array.get $GcArray_569
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 0
    array.get $GcArray_569
    array.len
  )
  (func $testStrSplitSecond (result i32) ;; exported as "testStrSplitSecond"
    (local $parts (ref $GcArray_569))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_569 1
    i32.const 0
    array.get $GcArray_569
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 1
    array.get $GcArray_569
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStrSplitWords (result i32) ;; exported as "testStrSplitWords"
    (local $parts (ref $GcArray_569))
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
    array.new_fixed $GcArray_569 1
    i32.const 0
    array.get $GcArray_569
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitNoDelim (result i32) ;; exported as "testStrSplitNoDelim"
    (local $parts (ref $GcArray_569))
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
    array.new_fixed $GcArray_569 1
    i32.const 0
    array.get $GcArray_569
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitEmpty (result i32) ;; exported as "testStrSplitEmpty"
    (local $parts (ref $GcArray_569))
    array.new_fixed $WasmStr 0
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_569 1
    i32.const 0
    array.get $GcArray_569
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitMultiChar (result i32) ;; exported as "testStrSplitMultiChar"
    (local $parts (ref $GcArray_569))
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
    array.new_fixed $GcArray_569 1
    i32.const 0
    array.get $GcArray_569
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrJoinLen (result i32) ;; exported as "testStrJoinLen"
    (local $parts (ref $GcArray_569))
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
    array.new_fixed $GcArray_569 3
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
    array.new_fixed $GcArray_569 2
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
    array.new_fixed $GcArray_569 1
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
  (func $closure_581 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $testSbToStringLength (result i32) ;; exported as "testSbToStringLength"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_166 (ref $ClosureBase_497))
    (local $s (ref $WasmStr))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_581
    struct.new $ClosureType_581
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_166
    local.get $lo_clo_166
    local.get $sb
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    call $sbAppend
    local.get $lo_clo_166
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    local.get $sb
    call $sbToString
    local.set $s
    local.get $s
    array.len
  )
  (func $closure_582 (param $self (ref $AnyFn)) (param $value (ref $StringBuilder))
    local.get $value
  )
  (func $closure_583 (param $self (ref $AnyFn)) (param $value_1 (ref $StringBuilder))
    local.get $value_1
  )
  (func $testSbToStringContent (result i32) ;; exported as "testSbToStringContent"
    (local $sb (ref $StringBuilder))
    (local $lo_clo_167 (ref $ClosureBase_497))
    (local $lo_clo_168 (ref $ClosureBase_497))
    (local $s (ref $WasmStr))
    i32.const 16
    call $sbCreate
    local.set $sb
    ref.func $closure_582
    struct.new $ClosureType_582
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_167
    local.get $lo_clo_167
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    local.get $lo_clo_167
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
    ref.func $closure_583
    struct.new $ClosureType_583
    ref.cast (ref $ClosureBase_497)
    local.set $lo_clo_168
    local.get $lo_clo_168
    local.get $sb
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 6
    call $sbAppend
    local.get $lo_clo_168
    struct.get $ClosureBase_497 0
    call_ref $FuncType_496
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
  (func $closure_587 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_587
    struct.new $ClosureType_587
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
  (func $closure_588 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_588
    struct.new $ClosureType_588
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
  (func $closure_589 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_589
    struct.new $ClosureType_589
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
  (func $closure_590 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_591 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_590
    struct.new $ClosureType_590
    ref.null $ListBase
    call $Set_ofList
    local.set $e
    ref.func $closure_591
    struct.new $ClosureType_591
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
  (func $closure_592 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_593 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_593))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_593)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_593 1
    local.set $acc
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_593 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_593
    local.get $acc
    struct.new $ClosureType_593
  )
  (func $testSetFold (result i32) ;; exported as "testSetFold"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_592
    struct.new $ClosureType_592
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
    ref.func $closure_593
    struct.new $ClosureType_594
    i32.const 0
    local.get $s
    return_call $Set_fold
  )
  (func $closure_595 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_596 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testSetFilter (result i32) ;; exported as "testSetFilter"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_595
    struct.new $ClosureType_595
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
    ref.func $closure_596
    struct.new $ClosureType_596
    local.get $s
    call $Set_filter
    local.set $s2
    local.get $s2
    return_call $Set_count
  )
  (func $closure_597 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_598 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 4
    i32.gt_s
  )
  (func $testSetExists (result i32) ;; exported as "testSetExists"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_597
    struct.new $ClosureType_597
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
    ref.func $closure_598
    struct.new $ClosureType_598
    local.get $s
    call $Set_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_599 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_600 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 0
    i32.gt_s
  )
  (func $testSetForall (result i32) ;; exported as "testSetForall"
    (local $s (ref $SetModule_SetHandle`1))
    ref.func $closure_599
    struct.new $ClosureType_599
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_600
    struct.new $ClosureType_600
    local.get $s
    call $Set_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_601 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_602 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_601
    struct.new $ClosureType_601
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $a
    ref.func $closure_602
    struct.new $ClosureType_602
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
  (func $closure_603 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_604 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_603
    struct.new $ClosureType_603
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
    ref.func $closure_604
    struct.new $ClosureType_604
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
  (func $closure_605 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_606 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_605
    struct.new $ClosureType_605
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
    ref.func $closure_606
    struct.new $ClosureType_606
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
  (func $closure_607 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_608 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_607
    struct.new $ClosureType_607
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $a
    ref.func $closure_608
    struct.new $ClosureType_608
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
  (func $closure_610 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 1
    i32.shl
  )
  (func $closure_611 (param $self (ref $AnyFn)) (param $x_2 i32) (param $y_1 i32) (result i32)
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
  (func $closure_612 (param $self (ref $AnyFn)) (param $x_3 i32) (result i32)
    (local $self_cast (ref $ClosureType_612))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_612)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_612 1
    local.set $acc
    local.get $acc
    local.get $x_3
    i32.add
  )
  (func $closure_612 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_612
    local.get $acc
    struct.new $ClosureType_612
  )
  (func $testSetMap (result i32) ;; exported as "testSetMap"
    (local $s (ref $SetModule_SetHandle`1))
    (local $s2 (ref $SetModule_SetHandle`1))
    ref.func $closure_609
    struct.new $ClosureType_609
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $s
    ref.func $closure_610
    struct.new $ClosureType_610
    local.get $s
    call $Set_map
    local.set $s2
    ref.func $closure_612
    struct.new $ClosureType_613
    i32.const 0
    local.get $s2
    return_call $Set_fold
  )
  (func $closure_614 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_614
    struct.new $ClosureType_614
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
  (func $closure_615 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_615
    struct.new $ClosureType_615
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
  (func $closure_616 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    (local $self_cast (ref $ClosureType_616))
    (local $acc i32)
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_616)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_616 1
    local.set $acc
    local.get $self_cast
    struct.get $ClosureType_616 2
    local.set $offset
    local.get $acc
    local.get $v
    i32.add
    local.get $offset
    i32.add
  )
  (func $closure_616 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_617))
    (local $offset i32)
    local.get $self
    ref.cast (ref $ClosureType_617)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_617 1
    local.set $offset
    ref.func $closure_616
    local.get $acc
    local.get $offset
    struct.new $ClosureType_616
  )
  (func $closure_618 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_616
    i32.const 100
    struct.new $ClosureType_617
    i32.const 0
    ref.func $closure_618
    struct.new $ClosureType_618
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
  (func $closure_619 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_621))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_621)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_621 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_622 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_622))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_622)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_622 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_623 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_623))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_623)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_623 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_624 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_624))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_624)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_624 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_624 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_624
    local.get $a
    struct.new $ClosureType_624
  )
  (func $testSetModuleBasic (result i32) ;; exported as "testSetModuleBasic"
    (local $s_3 (ref $SetModule_SetHandle`1))
    (local $lo_clo_171 (ref $ClosureBase_620))
    (local $lo_clo_170 (ref $ClosureBase_620))
    (local $lo_clo_169 (ref $ClosureBase_620))
    ref.func $closure_619
    i32.const 7
    struct.new $ClosureType_621
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_171
    local.get $lo_clo_171
    ref.func $closure_622
    i32.const 3
    struct.new $ClosureType_622
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_170
    local.get $lo_clo_170
    ref.func $closure_623
    i32.const 5
    struct.new $ClosureType_623
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_169
    local.get $lo_clo_169
    ref.func $closure_624
    struct.new $ClosureType_625
    call $Set_empty
    local.get $lo_clo_169
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_170
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_171
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.set $s_3
    local.get $s_3
    return_call $Set_count
  )
  (func $closure_626 (param $self (ref $AnyFn)) (param $s_3 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_626))
    (local $value_3 i32)
    local.get $self
    ref.cast (ref $ClosureType_626)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_626 1
    local.set $value_3
    local.get $value_3
    local.get $s_3
    call $Set_add
  )
  (func $closure_627 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_627))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_627)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_627 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_628 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_628))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_628)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_628 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_629 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_629))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_629)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_629 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_630 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_630))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_630)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_630 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_630 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_630
    local.get $a
    struct.new $ClosureType_630
  )
  (func $testSetModuleDedup (result i32) ;; exported as "testSetModuleDedup"
    (local $s_4 (ref $SetModule_SetHandle`1))
    (local $lo_clo_175 (ref $ClosureBase_620))
    (local $lo_clo_174 (ref $ClosureBase_620))
    (local $lo_clo_173 (ref $ClosureBase_620))
    (local $lo_clo_172 (ref $ClosureBase_620))
    ref.func $closure_626
    i32.const 2
    struct.new $ClosureType_626
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_175
    local.get $lo_clo_175
    ref.func $closure_627
    i32.const 2
    struct.new $ClosureType_627
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_174
    local.get $lo_clo_174
    ref.func $closure_628
    i32.const 1
    struct.new $ClosureType_628
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_173
    local.get $lo_clo_173
    ref.func $closure_629
    i32.const 1
    struct.new $ClosureType_629
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_172
    local.get $lo_clo_172
    ref.func $closure_630
    struct.new $ClosureType_631
    call $Set_empty
    local.get $lo_clo_172
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_173
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_174
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_175
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.set $s_4
    local.get $s_4
    return_call $Set_count
  )
  (func $closure_632 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_632))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_632)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_632 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_633 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_633))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_633)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_633 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_634 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_634))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_634)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_634 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_634 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_634
    local.get $a
    struct.new $ClosureType_634
  )
  (func $testSetModuleContains (result i32) ;; exported as "testSetModuleContains"
    (local $s_2 (ref $SetModule_SetHandle`1))
    (local $lo_clo_177 (ref $ClosureBase_620))
    (local $lo_clo_176 (ref $ClosureBase_620))
    ref.func $closure_632
    i32.const 99
    struct.new $ClosureType_632
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_177
    local.get $lo_clo_177
    ref.func $closure_633
    i32.const 42
    struct.new $ClosureType_633
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_176
    local.get $lo_clo_176
    ref.func $closure_634
    struct.new $ClosureType_635
    call $Set_empty
    local.get $lo_clo_176
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_177
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
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
  (func $closure_636 (param $self (ref $AnyFn)) (param $s_2 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_636))
    (local $value_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_636)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_636 1
    local.set $value_2
    local.get $value_2
    local.get $s_2
    call $Set_add
  )
  (func $closure_637 (param $self (ref $AnyFn)) (param $s_1 (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_637))
    (local $value_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_637)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_637 1
    local.set $value_1
    local.get $value_1
    local.get $s_1
    call $Set_add
  )
  (func $closure_638 (param $self (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    (local $self_cast (ref $ClosureType_638))
    (local $value i32)
    local.get $self
    ref.cast (ref $ClosureType_638)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_638 1
    local.set $value
    local.get $value
    local.get $s
    call $Set_add
  )
  (func $closure_639 (param $self (ref $AnyFn)) (param $b i32) (result i32)
    (local $self_cast (ref $ClosureType_639))
    (local $a i32)
    local.get $self
    ref.cast (ref $ClosureType_639)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_639 1
    local.set $a
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_639 (param $self (ref $AnyFn)) (param $a i32) (result (ref $AnyFn))
    ref.func $closure_639
    local.get $a
    struct.new $ClosureType_639
  )
  (func $closure_641 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    (local $self_cast (ref $ClosureType_641))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_641)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_641 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_641 (param $self (ref $AnyFn)) (param $acc i32) (result (ref $AnyFn))
    ref.func $closure_641
    local.get $acc
    struct.new $ClosureType_641
  )
  (func $testSetModuleFold (result i32) ;; exported as "testSetModuleFold"
    (local $s_3 (ref $SetModule_SetHandle`1))
    (local $lo_clo_180 (ref $ClosureBase_620))
    (local $lo_clo_179 (ref $ClosureBase_620))
    (local $lo_clo_178 (ref $ClosureBase_620))
    ref.func $closure_636
    i32.const 30
    struct.new $ClosureType_636
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_180
    local.get $lo_clo_180
    ref.func $closure_637
    i32.const 20
    struct.new $ClosureType_637
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_179
    local.get $lo_clo_179
    ref.func $closure_638
    i32.const 10
    struct.new $ClosureType_638
    ref.cast (ref $ClosureBase_620)
    local.set $lo_clo_178
    local.get $lo_clo_178
    ref.func $closure_639
    struct.new $ClosureType_640
    call $Set_empty
    local.get $lo_clo_178
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_179
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.get $lo_clo_180
    struct.get $ClosureBase_620 0
    call_ref $FuncType_619
    local.set $s_3
    ref.func $closure_641
    struct.new $ClosureType_642
    i32.const 0
    local.get $s_3
    return_call $Set_fold
  )
  (func $runSetTests (param $check (ref $AnyFn)) ;; exported as "runSetTests"
  )
  ;; ── Elem declare (func refs) ────────────────────────
  (elem declare func $QuickTestWasmGc_TestsInterop_ClassCircle_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_ClassRect_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_EnglishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap $QuickTestWasmGc_TestsInterop_IntShape_QuickTestWasmGc_TestsInterop_IShape_Area_wrap $QuickTestWasmGc_TestsInterop_SpanishGreeter_QuickTestWasmGc_TestsInterop_IGreeter_Greet_wrap $QuickTestWasmGc_TestsList_EnglishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap $QuickTestWasmGc_TestsList_SpanishGreeter_QuickTestWasmGc_TestsList_IGreeter_Greet_wrap $closure_105 $closure_107 $closure_109 $closure_115 $closure_117 $closure_124 $closure_126 $closure_129 $closure_130 $closure_146 $closure_148 $closure_156 $closure_167 $closure_171 $closure_173 $closure_184 $closure_186 $closure_190 $closure_192 $closure_195 $closure_199 $closure_201 $closure_219 $closure_232 $closure_235 $closure_236 $closure_238 $closure_241 $closure_242 $closure_244 $closure_245 $closure_246 $closure_247 $closure_249 $closure_250 $closure_252 $closure_253 $closure_255 $closure_256 $closure_257 $closure_259 $closure_260 $closure_261 $closure_262 $closure_263 $closure_264 $closure_265 $closure_266 $closure_267 $closure_269 $closure_270 $closure_271 $closure_272 $closure_273 $closure_274 $closure_275 $closure_278 $closure_279 $closure_28 $closure_282 $closure_283 $closure_285 $closure_286 $closure_288 $closure_289 $closure_29 $closure_291 $closure_292 $closure_294 $closure_296 $closure_297 $closure_298 $closure_299 $closure_30 $closure_300 $closure_303 $closure_304 $closure_305 $closure_306 $closure_308 $closure_309 $closure_310 $closure_312 $closure_313 $closure_314 $closure_315 $closure_316 $closure_329 $closure_332 $closure_333 $closure_336 $closure_337 $closure_341 $closure_342 $closure_346 $closure_347 $closure_349 $closure_35 $closure_352 $closure_353 $closure_354 $closure_357 $closure_358 $closure_359 $closure_36 $closure_360 $closure_361 $closure_362 $closure_365 $closure_369 $closure_370 $closure_371 $closure_372 $closure_373 $closure_376 $closure_379 $closure_39 $closure_391 $closure_393 $closure_395 $closure_397 $closure_40 $closure_402 $closure_407 $closure_41 $closure_411 $closure_413 $closure_42 $closure_429 $closure_431 $closure_434 $closure_437 $closure_443 $closure_444 $closure_446 $closure_448 $closure_449 $closure_46 $closure_466 $closure_472 $closure_473 $closure_479 $closure_480 $closure_481 $closure_483 $closure_484 $closure_485 $closure_486 $closure_487 $closure_49 $closure_490 $closure_491 $closure_492 $closure_493 $closure_495 $closure_496 $closure_499 $closure_500 $closure_501 $closure_502 $closure_503 $closure_504 $closure_505 $closure_506 $closure_507 $closure_509 $closure_51 $closure_510 $closure_511 $closure_512 $closure_513 $closure_514 $closure_517 $closure_518 $closure_520 $closure_523 $closure_525 $closure_528 $closure_529 $closure_530 $closure_531 $closure_533 $closure_534 $closure_536 $closure_538 $closure_539 $closure_540 $closure_542 $closure_543 $closure_544 $closure_546 $closure_547 $closure_549 $closure_551 $closure_555 $closure_556 $closure_557 $closure_559 $closure_561 $closure_563 $closure_564 $closure_565 $closure_566 $closure_567 $closure_570 $closure_581 $closure_582 $closure_583 $closure_587 $closure_588 $closure_589 $closure_590 $closure_591 $closure_592 $closure_593 $closure_595 $closure_596 $closure_597 $closure_598 $closure_599 $closure_6 $closure_600 $closure_601 $closure_602 $closure_603 $closure_604 $closure_605 $closure_606 $closure_607 $closure_608 $closure_609 $closure_610 $closure_612 $closure_614 $closure_615 $closure_616 $closure_618 $closure_619 $closure_622 $closure_623 $closure_624 $closure_626 $closure_627 $closure_628 $closure_629 $closure_630 $closure_632 $closure_633 $closure_634 $closure_636 $closure_637 $closure_638 $closure_639 $closure_64 $closure_641 $closure_67 $closure_76 $closure_79 $closure_87 $closure_90 $closure_94 $closure_95)
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
  (export "testSbLength" (func $testSbLength))
  (export "testSbAppendTwo" (func $testSbAppendTwo))
  (export "testSbGrow" (func $testSbGrow))
  (export "testSbChained" (func $testSbChained))
  (export "roundTo6" (func $roundTo6))
  (export "runStringBuilderTests" (func $runStringBuilderTests))
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
  (export "runAllTests" (func $runAllTests))
  (export "main" (func $main))
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
