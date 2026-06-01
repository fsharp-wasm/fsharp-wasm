(module
  ;; ── Types ───────────────────────────────────────────
  (type $AnyFn (sub (struct)))
  (type $WasmStr (array (mut i32)))
  (type $ListBase (sub (struct)))
  (type $StringBuilder (sub (struct (field (mut (ref $WasmStr))) (field (mut i32)) (field (mut i32)))))
  (type $MapModule_MapNode`2 (sub (struct (field i32))))
  (type $MapModule_MapNode`2#0 (sub $MapModule_MapNode`2 (struct (field i32))))
  (type $MapModule_MapNode`2#1 (sub $MapModule_MapNode`2 (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2)) (field (ref $MapModule_MapNode`2)))))
  (type $MapModule_MapHandle`2 (sub (struct (field (ref $MapModule_MapNode`2)) (field (ref $AnyFn)))))
  (type $MapModule_MapNode`2<i32~i32> (sub (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#0 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32))))
  (type $MapModule_MapNode`2<i32~i32>#1 (sub $MapModule_MapNode`2<i32~i32> (struct (field i32) (field i32) (field i32) (field (ref $MapModule_MapNode`2<i32~i32>)) (field (ref $MapModule_MapNode`2<i32~i32>)))))
  (type $FuncType_11 (func (param (ref $AnyFn)) (param i32) (param i32) (result i32)))
  (type $Option_12 (sub (struct (field i32))))
  (type $FuncType_13 (func (param (ref $AnyFn)) (param i32) (param i32) (param i32) (result i32)))
  (type $FuncType_14 (func (param (ref $AnyFn)) (param i32) (param i32)))
  (type $Tuple_15 (sub (struct (field i32) (field i32))))
  (type $ListCons_16 (sub $ListBase (struct (field (ref $Tuple_15)) (field (ref null $ListBase)))))
  (type $Exception (sub (struct (field (ref $WasmStr)))))
  (type $ClosureBase_18 (sub $AnyFn (struct (field (ref $FuncType_13)))))
  (type $ClosureType_19 (sub $ClosureBase_18 (struct (field (ref $FuncType_13)))))
  (type $ClosureType_20 (sub $ClosureBase_18 (struct (field (ref $FuncType_13)))))
  (type $SetModule_SetNode`1 (sub (struct (field i32))))
  (type $SetModule_SetNode`1#0 (sub $SetModule_SetNode`1 (struct (field i32))))
  (type $SetModule_SetNode`1#1 (sub $SetModule_SetNode`1 (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1)) (field (ref $SetModule_SetNode`1)))))
  (type $SetModule_SetHandle`1 (sub (struct (field (ref $SetModule_SetNode`1)) (field (ref $AnyFn)))))
  (type $SetModule_SetNode`1<i32> (sub (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#0 (sub $SetModule_SetNode`1<i32> (struct (field i32))))
  (type $SetModule_SetNode`1<i32>#1 (sub $SetModule_SetNode`1<i32> (struct (field i32) (field i32) (field (ref $SetModule_SetNode`1<i32>)) (field (ref $SetModule_SetNode`1<i32>)))))
  (type $FuncType_28 (func (param (ref $AnyFn)) (param i32)))
  (type $FuncType_29 (func (param (ref $AnyFn)) (param i32) (result i32)))
  (type $ListCons_30 (sub $ListBase (struct (field i32) (field (ref null $ListBase)))))
  (type $ClosureBase_31 (sub $AnyFn (struct (field (ref $FuncType_11)))))
  (type $ClosureType_32 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_33 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $FuncType_34 (func (param (ref $AnyFn)) (param (ref $SetModule_SetNode`1<i32>)) (param i32) (result (ref $SetModule_SetNode`1<i32>))))
  (type $ClosureBase_35 (sub $AnyFn (struct (field (ref $FuncType_34)))))
  (type $ClosureType_36 (sub $ClosureBase_35 (struct (field (ref $FuncType_34)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $ClosureType_37 (sub $ClosureBase_35 (struct (field (ref $FuncType_34)) (field (ref $AnyFn)) (field (ref $SetModule_SetHandle`1)))))
  (type $FuncType_38 (func (param (ref $AnyFn)) (param (ref $SetModule_SetHandle`1)) (param i32) (result (ref $SetModule_SetHandle`1))))
  (type $ClosureBase_39 (sub $AnyFn (struct (field (ref $FuncType_38)))))
  (type $ClosureType_40 (sub $ClosureBase_39 (struct (field (ref $FuncType_38)))))
  (type $GcArray_41 (array (mut i32)))
  (type $ClosureType_42 (sub $ClosureBase_39 (struct (field (ref $FuncType_38)))))
  (type $GcArray_43 (array (mut (ref $WasmStr))))
  (type $FuncType_44 (func (param (ref $AnyFn))))
  (type $FuncType_45 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $AnyFn))))
  (type $ClosureBase_46 (sub $AnyFn (struct (field (ref $FuncType_45)))))
  (type $ClosureType_47 (sub $ClosureBase_46 (struct (field (ref $FuncType_45)) (field i32) (field i32))))
  (type $ClosureType_48 (sub $ClosureBase_46 (struct (field (ref $FuncType_45)) (field i32) (field i32))))
  (type $QuickTestWasmGc_Preamble_Point (sub (struct (field f64) (field f64))))
  (type $QuickTestWasmGc_Preamble_Counter (sub (struct (field (mut i32)))))
  (type $QuickTestWasmGc_Preamble_Rect (sub (struct (field (ref $QuickTestWasmGc_Preamble_Point)) (field (ref $QuickTestWasmGc_Preamble_Point)))))
  (type $QuickTestWasmGc_Preamble_Shape (sub (struct (field i32))))
  (type $QuickTestWasmGc_Preamble_Shape#0 (sub $QuickTestWasmGc_Preamble_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_Preamble_Shape#1 (sub $QuickTestWasmGc_Preamble_Shape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_Preamble_Shape#2 (sub $QuickTestWasmGc_Preamble_Shape (struct (field i32) (field f64) (field f64))))
  (type $Tuple_56 (sub (struct (field f64) (field f64))))
  (type $Tuple_57 (sub (struct (field i32) (field i32) (field i32))))
  (type $Option_58 (sub (struct (field (ref null $Option_12)))))
  (type $ClosureBase_59 (sub $AnyFn (struct (field (ref $FuncType_29)))))
  (type $ClosureType_60 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_61 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_62 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_63 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_64 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $FuncType_65 (func (param (ref $AnyFn)) (param i32) (result (ref null $Option_12))))
  (type $ClosureBase_66 (sub $AnyFn (struct (field (ref $FuncType_65)))))
  (type $ClosureType_67 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_68 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_69 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_70 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_71 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_72 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_73 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_74 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_75 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_76 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureBase_77 (sub $AnyFn (struct (field (ref $FuncType_28)))))
  (type $ClosureType_78 (sub $ClosureBase_77 (struct (field (ref $FuncType_28)) (field i32))))
  (type $ClosureType_79 (sub $ClosureBase_77 (struct (field (ref $FuncType_28)) (field i32))))
  (type $ClosureType_80 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_81 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_82 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_83 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $FuncType_84 (func (param (ref $AnyFn)) (result i32)))
  (type $ClosureBase_85 (sub $AnyFn (struct (field (ref $FuncType_84)))))
  (type $ClosureType_86 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_87 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_88 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_89 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $RefCell_90 (sub (struct (field (mut i32)))))
  (type $QuickTestWasmGc_Preamble_Tree (sub (struct (field i32))))
  (type $QuickTestWasmGc_Preamble_Tree#0 (sub $QuickTestWasmGc_Preamble_Tree (struct (field i32))))
  (type $QuickTestWasmGc_Preamble_Tree#1 (sub $QuickTestWasmGc_Preamble_Tree (struct (field i32) (field (ref $QuickTestWasmGc_Preamble_Tree)) (field (ref $QuickTestWasmGc_Preamble_Tree)) (field i32))))
  (type $GcArray_94 (array (mut f64)))
  (type $ClosureType_95 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $FuncType_96 (func (param (ref $AnyFn)) (param f64) (param f64) (result f64)))
  (type $ClosureBase_97 (sub $AnyFn (struct (field (ref $FuncType_96)))))
  (type $ClosureType_98 (sub $ClosureBase_97 (struct (field (ref $FuncType_96)))))
  (type $ClosureType_99 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_100 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_101 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_102 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_103 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_104 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_105 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_106 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_107 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_108 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_109 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_110 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_111 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_112 (sub $ClosureBase_77 (struct (field (ref $FuncType_28)) (field i32))))
  (type $ClosureBase_113 (sub $AnyFn (struct (field (ref $FuncType_14)))))
  (type $ClosureType_114 (sub $ClosureBase_113 (struct (field (ref $FuncType_14)) (field i32))))
  (type $ClosureType_115 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_116 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_117 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_118 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_119 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_120 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_121 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_122 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_123 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_124 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_125 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_126 (sub $ClosureBase_113 (struct (field (ref $FuncType_14)) (field i32))))
  (type $FuncType_127 (func (param (ref $AnyFn)) (param i32) (result (ref null $ListBase))))
  (type $ClosureBase_128 (sub $AnyFn (struct (field (ref $FuncType_127)))))
  (type $ClosureType_129 (sub $ClosureBase_128 (struct (field (ref $FuncType_127)))))
  (type $ClosureType_130 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_131 (sub $ClosureBase_128 (struct (field (ref $FuncType_127)))))
  (type $ClosureType_132 (sub $ClosureBase_128 (struct (field (ref $FuncType_127)))))
  (type $ClosureType_133 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_134 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_135 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_136 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $FuncType_137 (func (param (ref $AnyFn)) (param i32) (param (ref null $ListBase)) (result (ref null $ListBase))))
  (type $ClosureBase_138 (sub $AnyFn (struct (field (ref $FuncType_137)))))
  (type $ClosureType_139 (sub $ClosureBase_138 (struct (field (ref $FuncType_137)))))
  (type $ClosureType_140 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_141 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_142 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_143 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_144 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_145 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_146 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_147 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_148 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_149 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_150 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_151 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_152 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_153 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_154 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_155 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_156 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_157 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_158 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field (ref $WasmStr)))))
  (type $ClosureType_165 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $FuncType_166 (func (param (ref $AnyFn)) (param i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))))
  (type $ClosureBase_167 (sub $AnyFn (struct (field (ref $FuncType_166)))))
  (type $ClosureType_168 (sub $ClosureBase_167 (struct (field (ref $FuncType_166)))))
  (type $ClosureType_169 (sub $ClosureBase_167 (struct (field (ref $FuncType_166)))))
  (type $ClosureType_170 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_171 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_172 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_173 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_174 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_175 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_176 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_177 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_178 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_179 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_180 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_181 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_182 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_183 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_184 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_185 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_186 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_187 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_188 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_189 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_190 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_191 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_192 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_193 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $QuickTestWasmGc_Preamble_EnglishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_195 (func (param (ref eq)) (result i32)))
  (type $vtbl_QuickTestWasmGc_Preamble_IGreeter (sub (struct (field (ref $FuncType_195)))))
  (type $box_QuickTestWasmGc_Preamble_IGreeter (sub (struct (field (ref $vtbl_QuickTestWasmGc_Preamble_IGreeter)) (field (ref eq)))))
  (type $QuickTestWasmGc_Preamble_SpanishGreeter (sub (struct (field (ref $WasmStr)))))
  (type $FuncType_199 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_Preamble_IGreeter)) (result i32)))
  (type $ClosureBase_200 (sub $AnyFn (struct (field (ref $FuncType_199)))))
  (type $ClosureType_201 (sub $ClosureBase_200 (struct (field (ref $FuncType_199)))))
  (type $ListCons_202 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_Preamble_IGreeter)) (field (ref null $ListBase)))))
  (type $ClosureType_203 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $QuickTestWasmGc_Preamble_IntShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_Preamble_IntShape#0 (sub $QuickTestWasmGc_Preamble_IntShape (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_Preamble_IntShape#1 (sub $QuickTestWasmGc_Preamble_IntShape (struct (field i32) (field i32) (field i32))))
  (type $vtbl_QuickTestWasmGc_Preamble_IShape (sub (struct (field (ref $FuncType_195)))))
  (type $box_QuickTestWasmGc_Preamble_IShape (sub (struct (field (ref $vtbl_QuickTestWasmGc_Preamble_IShape)) (field (ref eq)))))
  (type $FuncType_209 (func (param (ref $AnyFn)) (param (ref $box_QuickTestWasmGc_Preamble_IShape)) (result i32)))
  (type $ClosureBase_210 (sub $AnyFn (struct (field (ref $FuncType_209)))))
  (type $ClosureType_211 (sub $ClosureBase_210 (struct (field (ref $FuncType_209)))))
  (type $ListCons_212 (sub $ListBase (struct (field (ref $box_QuickTestWasmGc_Preamble_IShape)) (field (ref null $ListBase)))))
  (type $ClosureType_213 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $QuickTestWasmGc_Preamble_ClassCircle (sub (struct (field i32))))
  (type $QuickTestWasmGc_Preamble_ClassRect (sub (struct (field i32) (field i32))))
  (type $ClosureType_216 (sub $ClosureBase_210 (struct (field (ref $FuncType_209)))))
  (type $ClosureType_217 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $QuickTestWasmGc_Preamble_SWItem (sub (struct (field i32))))
  (type $ListCons_219 (sub $ListBase (struct (field (ref $QuickTestWasmGc_Preamble_SWItem)) (field (ref null $ListBase)))))
  (type $FuncType_220 (func (param (ref $AnyFn)) (param (ref $QuickTestWasmGc_Preamble_SWItem)) (param (ref $QuickTestWasmGc_Preamble_SWItem)) (result i32)))
  (type $ClosureBase_221 (sub $AnyFn (struct (field (ref $FuncType_220)))))
  (type $ClosureType_222 (sub $ClosureBase_221 (struct (field (ref $FuncType_220)))))
  (type $GcArray_223 (array (mut (ref null $QuickTestWasmGc_Preamble_SWItem))))
  (type $ClosureType_224 (sub $ClosureBase_221 (struct (field (ref $FuncType_220)))))
  (type $ClosureType_225 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_226 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_227 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_228 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_229 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_230 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $GcArray_231 (array (mut (ref $Tuple_15))))
  (type $ClosureType_232 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_233 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_234 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_235 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $QuickTestWasmGc_Preamble_GeoShape (sub (struct (field i32))))
  (type $QuickTestWasmGc_Preamble_GeoShape#0 (sub $QuickTestWasmGc_Preamble_GeoShape (struct (field i32) (field f64))))
  (type $QuickTestWasmGc_Preamble_GeoShape#1 (sub $QuickTestWasmGc_Preamble_GeoShape (struct (field i32) (field f64) (field f64))))
  (type $QuickTestWasmGc_Preamble_GeoShape#2 (sub $QuickTestWasmGc_Preamble_GeoShape (struct (field i32))))
  (type $Tuple_240 (sub (struct (field (ref null $ListBase)) (field (ref null $ListBase)))))
  (type $ClosureType_241 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_242 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_243 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_244 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_245 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_246 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_247 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_248 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_249 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_250 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_251 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_252 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_253 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_254 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $FuncType_255 (func (param (ref $AnyFn)) (param i32) (result (ref $GcArray_41))))
  (type $ClosureBase_256 (sub $AnyFn (struct (field (ref $FuncType_255)))))
  (type $ClosureType_257 (sub $ClosureBase_256 (struct (field (ref $FuncType_255)))))
  (type $ClosureType_258 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_259 (sub $ClosureBase_256 (struct (field (ref $FuncType_255)))))
  (type $ClosureType_260 (sub $ClosureBase_256 (struct (field (ref $FuncType_255)))))
  (type $ClosureType_261 (sub $ClosureBase_256 (struct (field (ref $FuncType_255)))))
  (type $ClosureType_262 (sub $ClosureBase_256 (struct (field (ref $FuncType_255)))))
  (type $ClosureType_263 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ListCons_264 (sub $ListBase (struct (field (ref $WasmStr)) (field (ref null $ListBase)))))
  (type $FuncType_265 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param (ref $WasmStr)) (result i32)))
  (type $ClosureBase_266 (sub $AnyFn (struct (field (ref $FuncType_265)))))
  (type $ClosureType_267 (sub $ClosureBase_266 (struct (field (ref $FuncType_265)))))
  (type $GcArray_268 (array (mut (ref null $WasmStr))))
  (type $ClosureType_269 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_270 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_271 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_272 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_273 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_274 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_275 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_276 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_277 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ResizeArray_278 (sub (struct (field (mut (ref null $GcArray_41))) (field (mut i32)))))
  (type $ClosureType_279 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_280 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_281 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_282 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_283 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_284 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_285 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_286 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $Tuple_287 (sub (struct (field (ref $GcArray_41)) (field (ref $GcArray_41)))))
  (type $ClosureType_288 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_289 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_290 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_291 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_292 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_293 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $FuncType_294 (func (param (ref $AnyFn)) (param (ref $Tuple_15)) (result i32)))
  (type $ClosureBase_295 (sub $AnyFn (struct (field (ref $FuncType_294)))))
  (type $ClosureType_296 (sub $ClosureBase_295 (struct (field (ref $FuncType_294)))))
  (type $ClosureType_297 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_298 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_299 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $Tuple_300 (sub (struct (field i32) (field (ref null $ListBase)))))
  (type $ListCons_301 (sub $ListBase (struct (field (ref $Tuple_300)) (field (ref null $ListBase)))))
  (type $ClosureType_302 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_303 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $QuickTestWasmGc_Preamble_MathExpr (sub (struct (field i32))))
  (type $QuickTestWasmGc_Preamble_MathExpr#0 (sub $QuickTestWasmGc_Preamble_MathExpr (struct (field i32) (field i32))))
  (type $QuickTestWasmGc_Preamble_MathExpr#1 (sub $QuickTestWasmGc_Preamble_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_Preamble_MathExpr)) (field (ref $QuickTestWasmGc_Preamble_MathExpr)))))
  (type $QuickTestWasmGc_Preamble_MathExpr#2 (sub $QuickTestWasmGc_Preamble_MathExpr (struct (field i32) (field (ref $QuickTestWasmGc_Preamble_MathExpr)) (field (ref $QuickTestWasmGc_Preamble_MathExpr)))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#0 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpChoice`2<void~void>#1 (sub $Microsoft_FSharp_Core_FSharpChoice`2<void~void> (struct (field i32))))
  (type $ClosureType_311 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_312 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_313 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_314 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_315 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_316 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_317 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_318 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_319 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_320 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_321 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_322 (sub $ClosureBase_18 (struct (field (ref $FuncType_13)))))
  (type $ClosureType_323 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_324 (sub $ClosureBase_18 (struct (field (ref $FuncType_13)))))
  (type $ClosureType_325 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_326 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_327 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_328 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_329 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_330 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_331 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_332 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_333 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_334 (sub $ClosureBase_66 (struct (field (ref $FuncType_65)))))
  (type $ClosureType_335 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_336 (sub $ClosureBase_128 (struct (field (ref $FuncType_127)))))
  (type $ClosureType_337 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_338 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_339 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_340 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_341 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_342 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_343 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_344 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_345 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_346 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_347 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_348 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_349 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_350 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_351 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_352 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_353 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_354 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_355 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_356 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_357 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_358 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_359 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_360 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_361 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_362 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_363 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_364 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_365 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_366 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_367 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_368 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_369 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_370 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_371 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_372 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_373 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_374 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_375 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_376 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_377 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_378 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_379 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_380 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_381 (sub $ClosureBase_85 (struct (field (ref $FuncType_84)))))
  (type $ClosureType_382 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_383 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_384 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_385 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)) (field (ref $AnyFn)))))
  (type $ClosureType_386 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)) (field (ref $AnyFn)))))
  (type $ClosureBase_387 (sub $AnyFn (struct (field (ref $FuncType_44)))))
  (type $ClosureType_388 (sub $ClosureBase_387 (struct (field (ref $FuncType_44)) (field (ref $RefCell_90)))))
  (type $ClosureType_389 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_390 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_391 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_392 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_393 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_394 (sub $ClosureBase_18 (struct (field (ref $FuncType_13)))))
  (type $ClosureType_395 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_396 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_397 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_398 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_399 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_400 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_401 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_402 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_403 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $ClosureType_404 (sub $ClosureBase_31 (struct (field (ref $FuncType_11)))))
  (type $RefCell_405 (sub (struct (field (mut (ref null $AnyFn))))))
  (type $ClosureType_406 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)) (field (ref $RefCell_405)))))
  (type $ClosureType_407 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)) (field (ref $RefCell_405)))))
  (type $ClosureType_408 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)) (field (ref $RefCell_405)))))
  (type $ClosureType_409 (sub $ClosureBase_59 (struct (field (ref $FuncType_29)) (field (ref $RefCell_405)))))
  (type $QuickTestWasmGc_Preamble_MyTypedException (sub (struct (field i32))))
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
    (local $w1465 i32)
    (local $w1466 i32)
    (local $w1467 i32)
    (local $w1468 i32)
    local.get $strIdx_ha
    array.len
    local.set $w1465
    local.get $strIdx_ne
    array.len
    local.set $w1466
    block $strIdx_1464_outer (result i32)
      local.get $w1466
      i32.const 0
      i32.eq
      if
        i32.const 0
        br $strIdx_1464_outer
      end
      i32.const 0
      local.set $w1467
      block $while_1470_exit
        loop $while_1470_lp
          local.get $w1467
          local.get $w1465
          local.get $w1466
          i32.sub
          i32.le_s
          if
            block $strIdx_1464_match
              i32.const 0
              local.set $w1468
              block $while_1469_exit
                loop $while_1469_lp
                  local.get $w1468
                  local.get $w1466
                  i32.lt_s
                  if
                    local.get $strIdx_ha
                    local.get $w1467
                    local.get $w1468
                    i32.add
                    array.get $WasmStr
                    local.get $strIdx_ne
                    local.get $w1468
                    array.get $WasmStr
                    i32.ne
                    if
                      br $strIdx_1464_match
                    end
                    local.get $w1468
                    i32.const 1
                    i32.add
                    local.set $w1468
                    br $while_1469_lp
                  else
                    br $while_1469_exit
                  end
                end
              end
              local.get $w1467
              br $strIdx_1464_outer
            end
            local.get $w1467
            i32.const 1
            i32.add
            local.set $w1467
            br $while_1470_lp
          else
            br $while_1470_exit
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
  (func $strSplit (param $ssp_src (ref $WasmStr)) (param $ssp_del (ref $WasmStr)) (result (ref $GcArray_43))
    (local $ssp_dl i32)
    (local $ssp_pos i32)
    (local $ssp_cnt i32)
    (local $ssp_j i32)
    (local $ssp_arr (ref $GcArray_43))
    (local $ssp_idx i32)
    local.get $ssp_del
    array.len
    local.set $ssp_dl
    local.get $ssp_dl
    i32.const 0
    i32.eq
    if (result (ref $GcArray_43))
      local.get $ssp_src
      array.new_fixed $GcArray_43 1
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
      array.new $GcArray_43
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
            array.set $GcArray_43
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
      array.set $GcArray_43
      local.get $ssp_arr
    end
  )
  (func $strJoin (param $sj_sep (ref $WasmStr)) (param $sj_arr (ref $GcArray_43)) (result (ref $WasmStr))
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
        array.get $GcArray_43
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
              array.get $GcArray_43
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
  (func $floatToStr (param $f f64) (result (ref $WasmStr))
    (local $fa f64)
    (local $ip i32)
    (local $fi i32)
    (local $is (ref $WasmStr))
    (local $la i32)
    (local $dot0 (ref $WasmStr))
    (local $r (ref $WasmStr))
    (local $fb (ref $WasmStr))
    (local $fv i32)
    (local $fe i32)
    (local $res (ref $WasmStr))
    local.get $f
    f64.const 0
    f64.eq
    if (result (ref $WasmStr))
      i32.const 48
      i32.const 1
      array.new $WasmStr
    else
      local.get $f
      f64.abs
      local.set $fa
      local.get $fa
      i32.trunc_f64_s
      local.set $ip
      local.get $fa
      local.get $ip
      f64.convert_i32_s
      f64.sub
      f64.const 1000000
      f64.mul
      i32.trunc_f64_s
      local.set $fi
      local.get $ip
      call $intToStr
      local.set $is
      local.get $is
      array.len
      local.set $la
      local.get $fi
      i32.const 0
      i32.eq
      if (result (ref $WasmStr))
        i32.const 0
        local.get $la
        i32.const 2
        i32.add
        array.new $WasmStr
        local.set $dot0
        local.get $dot0
        i32.const 0
        local.get $is
        i32.const 0
        local.get $la
        array.copy $WasmStr $WasmStr
        local.get $dot0
        local.get $la
        i32.const 46
        array.set $WasmStr
        local.get $dot0
        local.get $la
        i32.const 1
        i32.add
        i32.const 48
        array.set $WasmStr
        local.get $f
        f64.const 0
        f64.lt
        if (result (ref $WasmStr))
          i32.const 0
          local.get $la
          i32.const 3
          i32.add
          array.new $WasmStr
          local.set $r
          local.get $r
          i32.const 0
          i32.const 45
          array.set $WasmStr
          local.get $r
          i32.const 1
          local.get $dot0
          i32.const 0
          local.get $la
          i32.const 2
          i32.add
          array.copy $WasmStr $WasmStr
          local.get $r
        else
          local.get $dot0
        end
      else
        i32.const 0
        i32.const 6
        array.new $WasmStr
        local.set $fb
        local.get $fi
        local.set $fv
        local.get $fb
        i32.const 0
        local.get $fv
        i32.const 100000
        i32.div_s
        i32.const 48
        i32.add
        array.set $WasmStr
        local.get $fv
        i32.const 100000
        i32.rem_s
        local.set $fv
        local.get $fb
        i32.const 1
        local.get $fv
        i32.const 10000
        i32.div_s
        i32.const 48
        i32.add
        array.set $WasmStr
        local.get $fv
        i32.const 10000
        i32.rem_s
        local.set $fv
        local.get $fb
        i32.const 2
        local.get $fv
        i32.const 1000
        i32.div_s
        i32.const 48
        i32.add
        array.set $WasmStr
        local.get $fv
        i32.const 1000
        i32.rem_s
        local.set $fv
        local.get $fb
        i32.const 3
        local.get $fv
        i32.const 100
        i32.div_s
        i32.const 48
        i32.add
        array.set $WasmStr
        local.get $fv
        i32.const 100
        i32.rem_s
        local.set $fv
        local.get $fb
        i32.const 4
        local.get $fv
        i32.const 10
        i32.div_s
        i32.const 48
        i32.add
        array.set $WasmStr
        local.get $fv
        i32.const 10
        i32.rem_s
        local.set $fv
        local.get $fb
        i32.const 5
        local.get $fv
        i32.const 48
        i32.add
        array.set $WasmStr
        i32.const 6
        local.set $fe
        block $q_wl_1_exit
          loop $q_wl_1
            local.get $fe
            i32.const 1
            i32.gt_s
            if (result i32)
              local.get $fb
              local.get $fe
              i32.const 1
              i32.sub
              array.get $WasmStr
              i32.const 48
              i32.eq
            else
              i32.const 0
            end
            if
              local.get $fe
              i32.const 1
              i32.sub
              local.set $fe
              br $q_wl_1
            else
              br $q_wl_1_exit
            end
          end
        end
        i32.const 0
        local.get $la
        i32.const 1
        i32.add
        local.get $fe
        i32.add
        array.new $WasmStr
        local.set $res
        local.get $res
        i32.const 0
        local.get $is
        i32.const 0
        local.get $la
        array.copy $WasmStr $WasmStr
        local.get $res
        local.get $la
        i32.const 46
        array.set $WasmStr
        local.get $res
        local.get $la
        i32.const 1
        i32.add
        local.get $fb
        i32.const 0
        local.get $fe
        array.copy $WasmStr $WasmStr
        local.get $f
        f64.const 0
        f64.lt
        if (result (ref $WasmStr))
          i32.const 0
          local.get $la
          i32.const 2
          i32.add
          local.get $fe
          i32.add
          array.new $WasmStr
          local.set $r
          local.get $r
          i32.const 0
          i32.const 45
          array.set $WasmStr
          local.get $r
          i32.const 1
          local.get $res
          i32.const 0
          local.get $la
          i32.const 1
          i32.add
          local.get $fe
          i32.add
          array.copy $WasmStr $WasmStr
          local.get $r
        else
          local.get $res
        end
      end
    end
  )
  (func $parseInt (param $s (ref $WasmStr)) (result i32)
    (local $len i32)
    (local $i i32)
    (local $neg i32)
    (local $acc i32)
    (local $valid i32)
    (local $ch i32)
    local.get $s
    array.len
    local.set $len
    local.get $len
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 0
    else
      i32.const 0
      local.set $i
      i32.const 0
      local.set $neg
      i32.const 0
      local.set $acc
      i32.const 1
      local.set $valid
      local.get $s
      i32.const 0
      array.get $WasmStr
      i32.const 45
      i32.eq
      if
        i32.const 1
        local.set $neg
        i32.const 1
        local.set $i
      end
      block $q_wl_1_exit
        loop $q_wl_1
          local.get $valid
          i32.const 1
          i32.eq
          if (result i32)
            local.get $i
            local.get $len
            i32.lt_s
          else
            i32.const 0
          end
          if
            local.get $s
            local.get $i
            array.get $WasmStr
            local.set $ch
            local.get $ch
            i32.const 48
            i32.lt_s
            if (result i32)
              i32.const 1
            else
              local.get $ch
              i32.const 57
              i32.gt_s
            end
            if
              i32.const 0
              local.set $valid
            else
              local.get $acc
              i32.const 10
              i32.mul
              local.get $ch
              i32.add
              i32.const 48
              i32.sub
              local.set $acc
              local.get $i
              i32.const 1
              i32.add
              local.set $i
            end
            br $q_wl_1
          else
            br $q_wl_1_exit
          end
        end
      end
      local.get $valid
      i32.const 0
      i32.eq
      if (result i32)
        i32.const 0
      else
        local.get $neg
        i32.const 0
        i32.ne
        if (result i32)
          i32.const 0
          local.get $acc
          i32.sub
        else
          local.get $acc
        end
      end
    end
  )
  (func $parseFloat (param $s (ref $WasmStr)) (result f64)
    (local $len i32)
    (local $i i32)
    (local $neg i32)
    (local $intPart i32)
    (local $frac f64)
    (local $div f64)
    (local $hasDot i32)
    (local $valid i32)
    (local $ch i32)
    (local $result f64)
    local.get $s
    array.len
    local.set $len
    local.get $len
    i32.const 0
    i32.eq
    if (result f64)
      f64.const 0
    else
      i32.const 0
      local.set $i
      i32.const 0
      local.set $neg
      i32.const 0
      local.set $intPart
      f64.const 0
      local.set $frac
      f64.const 1
      local.set $div
      i32.const 0
      local.set $hasDot
      i32.const 1
      local.set $valid
      local.get $s
      i32.const 0
      array.get $WasmStr
      i32.const 45
      i32.eq
      if
        i32.const 1
        local.set $neg
        i32.const 1
        local.set $i
      end
      block $q_wl_1_exit
        loop $q_wl_1
          local.get $valid
          i32.const 1
          i32.eq
          if (result i32)
            local.get $i
            local.get $len
            i32.lt_s
          else
            i32.const 0
          end
          if
            local.get $s
            local.get $i
            array.get $WasmStr
            local.set $ch
            local.get $ch
            i32.const 46
            i32.eq
            if
              i32.const 1
              local.set $hasDot
              local.get $i
              i32.const 1
              i32.add
              local.set $i
            else
              local.get $ch
              i32.const 48
              i32.lt_s
              if (result i32)
                i32.const 1
              else
                local.get $ch
                i32.const 57
                i32.gt_s
              end
              if
                i32.const 0
                local.set $valid
              else
                local.get $hasDot
                i32.const 0
                i32.eq
                if
                  local.get $intPart
                  i32.const 10
                  i32.mul
                  local.get $ch
                  i32.add
                  i32.const 48
                  i32.sub
                  local.set $intPart
                  local.get $i
                  i32.const 1
                  i32.add
                  local.set $i
                else
                  local.get $div
                  f64.const 10
                  f64.mul
                  local.set $div
                  local.get $frac
                  local.get $ch
                  i32.const 48
                  i32.sub
                  f64.convert_i32_s
                  local.get $div
                  f64.div
                  f64.add
                  local.set $frac
                  local.get $i
                  i32.const 1
                  i32.add
                  local.set $i
                end
              end
            end
            br $q_wl_1
          else
            br $q_wl_1_exit
          end
        end
      end
      local.get $valid
      i32.const 0
      i32.eq
      if (result f64)
        f64.const 0
      else
        local.get $intPart
        f64.convert_i32_s
        local.get $frac
        f64.add
        local.set $result
        local.get $neg
        i32.const 0
        i32.ne
        if (result f64)
          local.get $result
          f64.neg
        else
          local.get $result
        end
      end
    end
  )
  (func $charIsDigit (param $c i32) (result i32)
    local.get $c
    i32.const 48
    i32.ge_s
    if (result i32)
      local.get $c
      i32.const 57
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
  (func $charIsLetter (param $c i32) (result i32)
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
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
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
  (func $charIsWhitespace (param $c i32) (result i32)
    local.get $c
    i32.const 32
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $c
      i32.const 9
      i32.ge_s
      if (result i32)
        local.get $c
        i32.const 13
        i32.le_s
      else
        i32.const 0
      end
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $charIsLetterOrDigit (param $c i32) (result i32)
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
    end
    if (result i32)
      i32.const 1
    else
      local.get $c
      i32.const 48
      i32.ge_s
      if (result i32)
        local.get $c
        i32.const 57
        i32.le_s
      else
        i32.const 0
      end
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
  (func $mathAtan2 (param $y f64) (param $x f64) (result f64)
    (local $absX f64)
    (local $absY f64)
    (local $swapped i32)
    (local $t f64)
    (local $a f64)
    (local $adj f64)
    (local $a2 f64)
    (local $poly f64)
    (local $a0 f64)
    (local $a1 f64)
    (local $a2r f64)
    local.get $y
    f64.const 0
    f64.eq
    if (result f64)
      local.get $x
      f64.const 0
      f64.ge
      if (result f64)
        f64.const 0
      else
        f64.const 3.1415926535897931
      end
    else
      local.get $x
      f64.const 0
      f64.eq
      if (result f64)
        local.get $y
        f64.const 0
        f64.gt
        if (result f64)
          f64.const 1.5707963267948966
        else
          f64.const 1.5707963267948966
          f64.neg
        end
      else
        local.get $x
        f64.const 0
        f64.lt
        if (result f64)
          local.get $x
          f64.neg
        else
          local.get $x
        end
        local.set $absX
        local.get $y
        f64.const 0
        f64.lt
        if (result f64)
          local.get $y
          f64.neg
        else
          local.get $y
        end
        local.set $absY
        local.get $absY
        local.get $absX
        f64.gt
        local.set $swapped
        local.get $swapped
        if (result f64)
          local.get $absX
          local.get $absY
          f64.div
        else
          local.get $absY
          local.get $absX
          f64.div
        end
        local.set $t
        local.get $t
        local.set $a
        f64.const 0
        local.set $adj
        local.get $t
        f64.const 0.41421356237309515
        f64.gt
        if
          local.get $t
          f64.const 1
          f64.sub
          local.get $t
          f64.const 1
          f64.add
          f64.div
          local.set $a
          f64.const 0.78539816339744828
          local.set $adj
        end
        local.get $a
        local.get $a
        f64.mul
        local.set $a2
        local.get $a
        f64.const 1
        local.get $a2
        f64.const -0.33333333333333331
        local.get $a2
        f64.const 0.20000000000000001
        local.get $a2
        f64.const 0.14285714285714285
        local.get $a2
        f64.const 0.1111111111111111
        local.get $a2
        f64.const 0.090909090909090912
        f64.mul
        f64.sub
        f64.mul
        f64.sub
        f64.mul
        f64.sub
        f64.mul
        f64.add
        f64.mul
        f64.add
        f64.mul
        local.set $poly
        local.get $adj
        local.get $poly
        f64.add
        local.set $a0
        local.get $swapped
        if (result f64)
          f64.const 1.5707963267948966
          local.get $a0
          f64.sub
        else
          local.get $a0
        end
        local.set $a1
        local.get $x
        f64.const 0
        f64.lt
        if (result f64)
          f64.const 3.1415926535897931
          local.get $a1
          f64.sub
        else
          local.get $a1
        end
        local.set $a2r
        local.get $y
        f64.const 0
        f64.lt
        if (result f64)
          local.get $a2r
          f64.neg
        else
          local.get $a2r
        end
      end
    end
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
  (func $nodeAdd_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $value i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $r (ref $MapModule_MapNode`2<i32~i32>))
    (local $l (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $c i32)
    (local $lo_clo_1 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_1
      local.get $lo_clo_1
      local.get $key
      local.get $k
      local.get $lo_clo_1
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $cmp
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
          local.get $cmp
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
    (local $lo_clo_2 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_2
      local.get $lo_clo_2
      local.get $key
      local.get $k
      local.get $lo_clo_2
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $cmp
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
          local.get $cmp
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
  (func $nodeTryFind_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_12))
    (local $c i32)
    (local $lo_clo_3 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_12))
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_3
      local.get $lo_clo_3
      local.get $key
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $lo_clo_3
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref null $Option_12))
        local.get $cmp
        local.get $key
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_12))
          local.get $cmp
          local.get $key
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
          call $nodeTryFind_i32~i32
        else
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 2
          struct.new $Option_12
        end
      end
    else
      ref.null $Option_12
    end
  )
  (func $Map_nodeTryFind (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $Option_12))
    (local $c i32)
    (local $lo_clo_4 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_12))
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_4
      local.get $lo_clo_4
      local.get $key
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $lo_clo_4
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref null $Option_12))
        local.get $cmp
        local.get $key
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeTryFind_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result (ref null $Option_12))
          local.get $cmp
          local.get $key
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
          call $nodeTryFind_i32~i32
        else
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 2
          struct.new $Option_12
        end
      end
    else
      ref.null $Option_12
    end
  )
  (func $nodeContainsKey_i32~i32 (param $cmp (ref $AnyFn)) (param $key i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $c i32)
    (local $lo_clo_5 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_5
      local.get $lo_clo_5
      local.get $key
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $lo_clo_5
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $cmp
        local.get $key
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeContainsKey_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $cmp
          local.get $key
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
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
    (local $c i32)
    (local $lo_clo_6 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_6
      local.get $lo_clo_6
      local.get $key
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $lo_clo_6
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $cmp
        local.get $key
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeContainsKey_i32~i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $cmp
          local.get $key
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
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
    local.get $source
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $cmp
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.get $cmp
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.get $cmp
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $target
      call $nodeAdd_i32~i32
      call $nodeMergeInto_i32~i32
      call $nodeMergeInto_i32~i32
    else
      local.get $target
    end
  )
  (func $Map_nodeMergeInto (param $cmp (ref $AnyFn)) (param $source (ref $MapModule_MapNode`2<i32~i32>)) (param $target (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    local.get $source
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $cmp
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      local.get $cmp
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      local.get $cmp
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $source
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
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
    (local $lo_clo_7 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_7
      local.get $lo_clo_7
      local.get $key
      local.get $k
      local.get $lo_clo_7
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $cmp
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
          local.get $cmp
          local.get $key
          local.get $r
          call $nodeRemove_i32~i32
          struct.new $MapModule_MapNode`2<i32~i32>#1
        else
          local.get $cmp
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
    (local $lo_clo_8 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_8
      local.get $lo_clo_8
      local.get $key
      local.get $k
      local.get $lo_clo_8
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $cmp
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
          local.get $cmp
          local.get $key
          local.get $r
          call $nodeRemove_i32~i32
          struct.new $MapModule_MapNode`2<i32~i32>#1
        else
          local.get $cmp
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
    (local $lo_clo_9 (ref $ClosureBase_18))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $folder
      local.get $folder
      ref.cast (ref $ClosureBase_18)
      local.set $lo_clo_9
      local.get $lo_clo_9
      local.get $folder
      local.get $state
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeFold_i32~i32~i32
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_9
      struct.get $ClosureBase_18 0
      call_ref $FuncType_13
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeFold_i32~i32~i32
    else
      local.get $state
    end
  )
  (func $Map_nodeFold (param $folder (ref $AnyFn)) (param $state i32) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $lo_clo_10 (ref $ClosureBase_18))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $folder
      local.get $folder
      ref.cast (ref $ClosureBase_18)
      local.set $lo_clo_10
      local.get $lo_clo_10
      local.get $folder
      local.get $state
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeFold_i32~i32~i32
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_10
      struct.get $ClosureBase_18 0
      call_ref $FuncType_13
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeFold_i32~i32~i32
    else
      local.get $state
    end
  )
  (func $nodeIter_i32~i32 (param $action (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>))
    (local $lo_clo_11 (ref $ClosureBase_113))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if
      local.get $action
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeIter_i32~i32
      local.get $action
      ref.cast (ref $ClosureBase_113)
      local.set $lo_clo_11
      local.get $lo_clo_11
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_11
      struct.get $ClosureBase_113 0
      call_ref $FuncType_14
      local.get $action
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeIter_i32~i32
    end
  )
  (func $Map_nodeIter (param $action (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>))
    (local $lo_clo_12 (ref $ClosureBase_113))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if
      local.get $action
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeIter_i32~i32
      local.get $action
      ref.cast (ref $ClosureBase_113)
      local.set $lo_clo_12
      local.get $lo_clo_12
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_12
      struct.get $ClosureBase_113 0
      call_ref $FuncType_14
      local.get $action
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeIter_i32~i32
    end
  )
  (func $nodeMapValues_i32~i32~i32 (param $mapping (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $lo_clo_13 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      i32.const 1
      local.get $k
      local.get $mapping
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_13
      local.get $lo_clo_13
      local.get $k
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_13
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.get $mapping
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeMapValues_i32~i32~i32
      local.get $mapping
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeMapValues_i32~i32~i32
      struct.new $MapModule_MapNode`2<i32~i32>#1
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $Map_nodeMapValues (param $mapping (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $k i32)
    (local $lo_clo_14 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref $MapModule_MapNode`2<i32~i32>))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      i32.const 1
      local.get $k
      local.get $mapping
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_14
      local.get $lo_clo_14
      local.get $k
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_14
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.get $mapping
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeMapValues_i32~i32~i32
      local.get $mapping
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeMapValues_i32~i32~i32
      struct.new $MapModule_MapNode`2<i32~i32>#1
    else
      i32.const 0
      struct.new $MapModule_MapNode`2<i32~i32>#0
    end
  )
  (func $nodeFilter_i32~i32 (param $cmp (ref $AnyFn)) (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref $MapModule_MapNode`2<i32~i32>))
    (local $v i32)
    (local $k i32)
    (local $fl (ref $MapModule_MapNode`2<i32~i32>))
    (local $fr (ref $MapModule_MapNode`2<i32~i32>))
    (local $lo_clo_15 (ref $ClosureBase_31))
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
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeFilter_i32~i32
      local.set $fl
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeFilter_i32~i32
      local.set $fr
      local.get $predicate
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_15
      local.get $lo_clo_15
      local.get $k
      local.get $v
      local.get $lo_clo_15
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $cmp
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
    (local $k i32)
    (local $fl (ref $MapModule_MapNode`2<i32~i32>))
    (local $fr (ref $MapModule_MapNode`2<i32~i32>))
    (local $lo_clo_16 (ref $ClosureBase_31))
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
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.set $k
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeFilter_i32~i32
      local.set $fl
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeFilter_i32~i32
      local.set $fr
      local.get $predicate
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_16
      local.get $lo_clo_16
      local.get $k
      local.get $v
      local.get $lo_clo_16
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      if (result (ref $MapModule_MapNode`2<i32~i32>))
        i32.const 1
        local.get $k
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $MapModule_MapNode`2<i32~i32>#1
      else
        local.get $cmp
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
    (local $lo_clo_17 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_17
      local.get $lo_clo_17
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_17
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      if (result i32)
        i32.const 1
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeExists_i32~i32
        if (result i32)
          i32.const 1
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
          call $nodeExists_i32~i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $Map_nodeExists (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $lo_clo_18 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_18
      local.get $lo_clo_18
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_18
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      if (result i32)
        i32.const 1
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeExists_i32~i32
        if (result i32)
          i32.const 1
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
          call $nodeExists_i32~i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $nodeForAll_i32~i32 (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $lo_clo_19 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_19
      local.get $lo_clo_19
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_19
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeForAll_i32~i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
          call $nodeForAll_i32~i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $Map_nodeForAll (param $predicate (ref $AnyFn)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result i32)
    (local $lo_clo_20 (ref $ClosureBase_31))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_20
      local.get $lo_clo_20
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      local.get $lo_clo_20
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
        struct.get $MapModule_MapNode`2<i32~i32>#1 3
        call $nodeForAll_i32~i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
          struct.get $MapModule_MapNode`2<i32~i32>#1 4
          call $nodeForAll_i32~i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $nodeToListAcc_i32~i32 (param $acc (ref null $ListBase)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $ListBase))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      struct.new $Tuple_15
      local.get $acc
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_16
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeToListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $Map_nodeToListAcc (param $acc (ref null $ListBase)) (param $node (ref $MapModule_MapNode`2<i32~i32>)) (result (ref null $ListBase))
    local.get $node
    struct.get $MapModule_MapNode`2<i32~i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 1
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 2
      struct.new $Tuple_15
      local.get $acc
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 4
      call $nodeToListAcc_i32~i32
      struct.new $ListCons_16
      local.get $node
      ref.cast (ref $MapModule_MapNode`2<i32~i32>#1)
      struct.get $MapModule_MapNode`2<i32~i32>#1 3
      call $nodeToListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $Map_empty (param $cmp (ref $AnyFn)) (result (ref $MapModule_MapHandle`2))
    i32.const 0
    struct.new $MapModule_MapNode`2<i32~i32>#0
    local.get $cmp
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_isEmpty (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $m
    struct.get $MapModule_MapHandle`2 0
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
  (func $Map_tryFind (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_12))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeTryFind_i32~i32
  )
  (func $tryFind_i32~i32 (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result (ref null $Option_12))
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    local.get $key
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeTryFind_i32~i32
  )
  (func $Map_find (param $key i32) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    (local $matchValue (ref null $Option_12))
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
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
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
  (func $closure_18 (param $self (ref $AnyFn)) (param $n i32) (param $_arg i32) (param $_arg_1 i32) (result i32)
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_20 (param $self (ref $AnyFn)) (param $n i32) (param $_arg i32) (param $_arg_1 i32) (result i32)
    local.get $n
    i32.const 1
    i32.add
  )
  (func $Map_count (param $m (ref $MapModule_MapHandle`2)) (result i32)
    ref.func $closure_20
    struct.new $ClosureType_20
    i32.const 0
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeFold_i32~i32~i32
  )
  (func $Map_fold (param $folder (ref $AnyFn)) (param $state i32) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $folder
    local.get $state
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeFold_i32~i32~i32
  )
  (func $Map_iter (param $action (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2))
    local.get $action
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeIter_i32~i32
  )
  (func $Map_mapValues (param $mapping (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result (ref $MapModule_MapHandle`2))
    local.get $mapping
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
    local.get $predicate
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    call $nodeFilter_i32~i32
    local.get $m
    struct.get $MapModule_MapHandle`2 1
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_exists (param $predicate (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $predicate
    local.get $m
    struct.get $MapModule_MapHandle`2 0
    return_call $nodeExists_i32~i32
  )
  (func $Map_forAll (param $predicate (ref $AnyFn)) (param $m (ref $MapModule_MapHandle`2)) (result i32)
    local.get $predicate
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
    local.get $pairs
    ref.is_null
    i32.eqz
    if (result (ref $MapModule_MapHandle`2))
      local.get $cmp
      local.get $pairs
      ref.cast (ref $ListCons_16)
      struct.get $ListCons_16 0
      struct.get $Tuple_15 0
      local.get $pairs
      ref.cast (ref $ListCons_16)
      struct.get $ListCons_16 0
      struct.get $Tuple_15 1
      local.get $acc
      call $add_i32~i32
      local.get $pairs
      ref.cast (ref $ListCons_16)
      struct.get $ListCons_16 1
      call $ofListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $Map_ofListAcc (param $cmp (ref $AnyFn)) (param $acc (ref $MapModule_MapHandle`2)) (param $pairs (ref null $ListBase)) (result (ref $MapModule_MapHandle`2))
    local.get $pairs
    ref.is_null
    i32.eqz
    if (result (ref $MapModule_MapHandle`2))
      local.get $cmp
      local.get $pairs
      ref.cast (ref $ListCons_16)
      struct.get $ListCons_16 0
      struct.get $Tuple_15 0
      local.get $pairs
      ref.cast (ref $ListCons_16)
      struct.get $ListCons_16 0
      struct.get $Tuple_15 1
      local.get $acc
      call $add_i32~i32
      local.get $pairs
      ref.cast (ref $ListCons_16)
      struct.get $ListCons_16 1
      call $ofListAcc_i32~i32
    else
      local.get $acc
    end
  )
  (func $empty_i32~i32 (param $cmp (ref $AnyFn)) (result (ref $MapModule_MapHandle`2))
    i32.const 0
    struct.new $MapModule_MapNode`2<i32~i32>#0
    local.get $cmp
    struct.new $MapModule_MapHandle`2
  )
  (func $Map_ofList (param $cmp (ref $AnyFn)) (param $pairs (ref null $ListBase)) (result (ref $MapModule_MapHandle`2))
    local.get $cmp
    local.get $cmp
    call $empty_i32~i32
    local.get $pairs
    return_call $ofListAcc_i32~i32
  )
  (func $nodeAdd_i32 (param $cmp (ref $AnyFn)) (param $value i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $r (ref $SetModule_SetNode`1<i32>))
    (local $l (ref $SetModule_SetNode`1<i32>))
    (local $c i32)
    (local $lo_clo_21 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_21
      local.get $lo_clo_21
      local.get $value
      local.get $v
      local.get $lo_clo_21
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $cmp
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
          local.get $cmp
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
    (local $lo_clo_22 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_22
      local.get $lo_clo_22
      local.get $value
      local.get $v
      local.get $lo_clo_22
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $cmp
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
          local.get $cmp
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
    (local $c i32)
    (local $lo_clo_23 (ref $ClosureBase_31))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_23
      local.get $lo_clo_23
      local.get $value
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_23
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $cmp
        local.get $value
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        call $nodeContains_i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $cmp
          local.get $value
          local.get $node
          ref.cast (ref $SetModule_SetNode`1<i32>#1)
          struct.get $SetModule_SetNode`1<i32>#1 3
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
    (local $c i32)
    (local $lo_clo_24 (ref $ClosureBase_31))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_24
      local.get $lo_clo_24
      local.get $value
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_24
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result i32)
        local.get $cmp
        local.get $value
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        call $nodeContains_i32
      else
        local.get $c
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $cmp
          local.get $value
          local.get $node
          ref.cast (ref $SetModule_SetNode`1<i32>#1)
          struct.get $SetModule_SetNode`1<i32>#1 3
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
    local.get $source
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $cmp
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $cmp
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $target
      call $nodeAdd_i32
      call $nodeMergeInto_i32
      call $nodeMergeInto_i32
    else
      local.get $target
    end
  )
  (func $Set_nodeMergeInto (param $cmp (ref $AnyFn)) (param $source (ref $SetModule_SetNode`1<i32>)) (param $target (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    local.get $source
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $cmp
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $cmp
      local.get $source
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
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
    (local $lo_clo_25 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_25
      local.get $lo_clo_25
      local.get $value
      local.get $v
      local.get $lo_clo_25
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $cmp
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
          local.get $cmp
          local.get $value
          local.get $r
          call $nodeRemove_i32
          struct.new $SetModule_SetNode`1<i32>#1
        else
          local.get $cmp
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
    (local $lo_clo_26 (ref $ClosureBase_31))
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
      local.get $cmp
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_26
      local.get $lo_clo_26
      local.get $value
      local.get $v
      local.get $lo_clo_26
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.set $c
      local.get $c
      i32.const 0
      i32.lt_s
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $cmp
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
          local.get $cmp
          local.get $value
          local.get $r
          call $nodeRemove_i32
          struct.new $SetModule_SetNode`1<i32>#1
        else
          local.get $cmp
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
    (local $lo_clo_27 (ref $ClosureBase_31))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $folder
      local.get $folder
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_27
      local.get $lo_clo_27
      local.get $folder
      local.get $state
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeFold_i32~i32
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_27
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeFold_i32~i32
    else
      local.get $state
    end
  )
  (func $Set_nodeFold (param $folder (ref $AnyFn)) (param $state i32) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $lo_clo_28 (ref $ClosureBase_31))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $folder
      local.get $folder
      ref.cast (ref $ClosureBase_31)
      local.set $lo_clo_28
      local.get $lo_clo_28
      local.get $folder
      local.get $state
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeFold_i32~i32
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_28
      struct.get $ClosureBase_31 0
      call_ref $FuncType_11
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeFold_i32~i32
    else
      local.get $state
    end
  )
  (func $nodeIter_i32 (param $action (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_29 (ref $ClosureBase_77))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if
      local.get $action
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeIter_i32
      local.get $action
      ref.cast (ref $ClosureBase_77)
      local.set $lo_clo_29
      local.get $lo_clo_29
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_29
      struct.get $ClosureBase_77 0
      call_ref $FuncType_28
      local.get $action
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeIter_i32
    end
  )
  (func $Set_nodeIter (param $action (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_30 (ref $ClosureBase_77))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if
      local.get $action
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeIter_i32
      local.get $action
      ref.cast (ref $ClosureBase_77)
      local.set $lo_clo_30
      local.get $lo_clo_30
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_30
      struct.get $ClosureBase_77 0
      call_ref $FuncType_28
      local.get $action
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeIter_i32
    end
  )
  (func $nodeFilter_i32 (param $cmp (ref $AnyFn)) (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $fl (ref $SetModule_SetNode`1<i32>))
    (local $fr (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_31 (ref $ClosureBase_59))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeFilter_i32
      local.set $fl
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeFilter_i32
      local.set $fr
      local.get $predicate
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_31
      local.get $lo_clo_31
      local.get $v
      local.get $lo_clo_31
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $cmp
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
    (local $fl (ref $SetModule_SetNode`1<i32>))
    (local $fr (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_32 (ref $ClosureBase_59))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeFilter_i32
      local.set $fl
      local.get $cmp
      local.get $predicate
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeFilter_i32
      local.set $fr
      local.get $predicate
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_32
      local.get $lo_clo_32
      local.get $v
      local.get $lo_clo_32
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
      if (result (ref $SetModule_SetNode`1<i32>))
        i32.const 1
        local.get $v
        local.get $fl
        local.get $fr
        struct.new $SetModule_SetNode`1<i32>#1
      else
        local.get $cmp
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
    (local $lo_clo_33 (ref $ClosureBase_59))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_33
      local.get $lo_clo_33
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_33
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
      if (result i32)
        i32.const 1
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        call $nodeExists_i32
        if (result i32)
          i32.const 1
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $SetModule_SetNode`1<i32>#1)
          struct.get $SetModule_SetNode`1<i32>#1 3
          call $nodeExists_i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $Set_nodeExists (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $lo_clo_34 (ref $ClosureBase_59))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_34
      local.get $lo_clo_34
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_34
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
      if (result i32)
        i32.const 1
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        call $nodeExists_i32
        if (result i32)
          i32.const 1
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $SetModule_SetNode`1<i32>#1)
          struct.get $SetModule_SetNode`1<i32>#1 3
          call $nodeExists_i32
        end
      end
    else
      i32.const 0
    end
  )
  (func $nodeForAll_i32 (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $lo_clo_35 (ref $ClosureBase_59))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_35
      local.get $lo_clo_35
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_35
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        call $nodeForAll_i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $SetModule_SetNode`1<i32>#1)
          struct.get $SetModule_SetNode`1<i32>#1 3
          call $nodeForAll_i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $Set_nodeForAll (param $predicate (ref $AnyFn)) (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $lo_clo_36 (ref $ClosureBase_59))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $predicate
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_36
      local.get $lo_clo_36
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_36
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
      i32.eqz
      if (result i32)
        i32.const 0
      else
        local.get $predicate
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        call $nodeForAll_i32
        i32.eqz
        if (result i32)
          i32.const 0
        else
          local.get $predicate
          local.get $node
          ref.cast (ref $SetModule_SetNode`1<i32>#1)
          struct.get $SetModule_SetNode`1<i32>#1 3
          call $nodeForAll_i32
        end
      end
    else
      i32.const 1
    end
  )
  (func $nodeUnion_i32 (param $cmp (ref $AnyFn)) (param $a (ref $SetModule_SetNode`1<i32>)) (param $b (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $b
      call $nodeAdd_i32
      call $nodeUnion_i32
      call $nodeUnion_i32
    else
      local.get $b
    end
  )
  (func $Set_nodeUnion (param $cmp (ref $AnyFn)) (param $a (ref $SetModule_SetNode`1<i32>)) (param $b (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
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
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $acc
      call $nodeIntersectAcc_i32
      local.set $acc1
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $cmp
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      else
        local.get $acc1
      end
      call $nodeIntersectAcc_i32
    else
      local.get $acc
    end
  )
  (func $Set_nodeIntersectAcc (param $cmp (ref $AnyFn)) (param $b (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $acc
      call $nodeIntersectAcc_i32
      local.set $acc1
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $cmp
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      else
        local.get $acc1
      end
      call $nodeIntersectAcc_i32
    else
      local.get $acc
    end
  )
  (func $nodeDifferenceAcc_i32 (param $cmp (ref $AnyFn)) (param $b (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $acc
      call $nodeDifferenceAcc_i32
      local.set $acc1
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $acc1
      else
        local.get $cmp
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      end
      call $nodeDifferenceAcc_i32
    else
      local.get $acc
    end
  )
  (func $Set_nodeDifferenceAcc (param $cmp (ref $AnyFn)) (param $b (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (param $acc (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $v i32)
    (local $acc1 (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.set $v
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.get $acc
      call $nodeDifferenceAcc_i32
      local.set $acc1
      local.get $cmp
      local.get $b
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.get $cmp
      local.get $v
      local.get $b
      call $nodeContains_i32
      if (result (ref $SetModule_SetNode`1<i32>))
        local.get $acc1
      else
        local.get $cmp
        local.get $v
        local.get $acc1
        call $nodeAdd_i32
      end
      call $nodeDifferenceAcc_i32
    else
      local.get $acc
    end
  )
  (func $nodeIsSubset_i32 (param $cmp (ref $AnyFn)) (param $a (ref $SetModule_SetNode`1<i32>)) (param $b (ref $SetModule_SetNode`1<i32>)) (result i32)
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $b
      call $nodeContains_i32
      if (result i32)
        local.get $cmp
        local.get $a
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        local.get $b
        call $nodeIsSubset_i32
      else
        i32.const 0
      end
      if (result i32)
        local.get $cmp
        local.get $a
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 3
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
    local.get $a
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $cmp
      local.get $a
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $b
      call $nodeContains_i32
      if (result i32)
        local.get $cmp
        local.get $a
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 2
        local.get $b
        call $nodeIsSubset_i32
      else
        i32.const 0
      end
      if (result i32)
        local.get $cmp
        local.get $a
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 3
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
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $acc
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeToListAcc_i32
      struct.new $ListCons_30
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeToListAcc_i32
    else
      local.get $acc
    end
  )
  (func $Set_nodeToListAcc (param $acc (ref null $ListBase)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref null $ListBase))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $acc
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeToListAcc_i32
      struct.new $ListCons_30
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeToListAcc_i32
    else
      local.get $acc
    end
  )
  (func $nodeMinElement_i32 (param $node (ref $SetModule_SetNode`1<i32>)) (result i32)
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $l
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 1
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
    (local $l (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      local.set $l
      local.get $l
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 1
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
    (local $r (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $r
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 1
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
    (local $r (ref $SetModule_SetNode`1<i32>))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      local.set $r
      local.get $r
      struct.get $SetModule_SetNode`1<i32> 0
      i32.const 0
      i32.eq
      if (result i32)
        local.get $node
        ref.cast (ref $SetModule_SetNode`1<i32>#1)
        struct.get $SetModule_SetNode`1<i32>#1 1
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
    local.get $cmp
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_isEmpty (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $s
    struct.get $SetModule_SetHandle`1 0
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
  (func $closure_31 (param $self (ref $AnyFn)) (param $n i32) (param $_arg i32) (result i32)
    local.get $n
    i32.const 1
    i32.add
  )
  (func $closure_33 (param $self (ref $AnyFn)) (param $n i32) (param $_arg i32) (result i32)
    local.get $n
    i32.const 1
    i32.add
  )
  (func $Set_count (param $s (ref $SetModule_SetHandle`1)) (result i32)
    ref.func $closure_33
    struct.new $ClosureType_33
    i32.const 0
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    return_call $nodeFold_i32~i32
  )
  (func $Set_fold (param $folder (ref $AnyFn)) (param $state i32) (param $s (ref $SetModule_SetHandle`1)) (result i32)
    local.get $folder
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
  (func $closure_34 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_36))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_37 (ref $ClosureBase_59))
    local.get $self
    ref.cast (ref $ClosureType_36)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_36 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_36 2
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_37
    local.get $lo_clo_37
    local.get $v
    local.get $lo_clo_37
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
    local.get $acc
    call $nodeAdd_i32
  )
  (func $closure_37 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetNode`1<i32>)) (param $v i32) (result (ref $SetModule_SetNode`1<i32>))
    (local $self_cast (ref $ClosureType_37))
    (local $mapping (ref $AnyFn))
    (local $s (ref $SetModule_SetHandle`1))
    (local $lo_clo_38 (ref $ClosureBase_59))
    local.get $self
    ref.cast (ref $ClosureType_37)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_37 1
    local.set $mapping
    local.get $self_cast
    struct.get $ClosureType_37 2
    local.set $s
    local.get $s
    struct.get $SetModule_SetHandle`1 1
    local.get $mapping
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_38
    local.get $lo_clo_38
    local.get $v
    local.get $lo_clo_38
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
    local.get $acc
    call $nodeAdd_i32
  )
  (func $nodeFold_ref25~i32 (param $folder (ref $AnyFn)) (param $state (ref $SetModule_SetNode`1<i32>)) (param $node (ref $SetModule_SetNode`1<i32>)) (result (ref $SetModule_SetNode`1<i32>))
    (local $lo_clo_39 (ref $ClosureBase_35))
    local.get $node
    struct.get $SetModule_SetNode`1<i32> 0
    i32.const 1
    i32.eq
    if (result (ref $SetModule_SetNode`1<i32>))
      local.get $folder
      local.get $folder
      ref.cast (ref $ClosureBase_35)
      local.set $lo_clo_39
      local.get $lo_clo_39
      local.get $folder
      local.get $state
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 2
      call $nodeFold_ref25~i32
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 1
      local.get $lo_clo_39
      struct.get $ClosureBase_35 0
      call_ref $FuncType_34
      local.get $node
      ref.cast (ref $SetModule_SetNode`1<i32>#1)
      struct.get $SetModule_SetNode`1<i32>#1 3
      call $nodeFold_ref25~i32
    else
      local.get $state
    end
  )
  (func $Set_map (param $mapping (ref $AnyFn)) (param $s (ref $SetModule_SetHandle`1)) (result (ref $SetModule_SetHandle`1))
    ref.func $closure_37
    local.get $mapping
    local.get $s
    struct.new $ClosureType_37
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    local.get $s
    struct.get $SetModule_SetHandle`1 0
    call $nodeFold_ref25~i32
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
  (func $closure_38 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $empty_i32 (param $cmp (ref $AnyFn)) (result (ref $SetModule_SetHandle`1))
    i32.const 0
    struct.new $SetModule_SetNode`1<i32>#0
    local.get $cmp
    struct.new $SetModule_SetHandle`1
  )
  (func $Set_ofList (param $cmp (ref $AnyFn)) (param $xs (ref null $ListBase)) (result (ref $SetModule_SetHandle`1))
    (local $w2 (ref null $ListBase))
    (local $w3 (ref $SetModule_SetHandle`1))
    (local $x i32)
    local.get $xs
    local.set $w2
    local.get $cmp
    call $empty_i32
    local.set $w3
    block $while_4_exit
      loop $while_4_lp
        local.get $w2
        ref.is_null
        i32.eqz
        if
          local.get $w2
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w3
          call $add_i32
          local.set $w3
          local.get $w2
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w2
          br $while_4_lp
        else
          br $while_4_exit
        end
      end
    end
    local.get $w3
  )
  (func $closure_42 (param $self (ref $AnyFn)) (param $acc (ref $SetModule_SetHandle`1)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    local.get $x
    local.get $acc
    call $add_i32
  )
  (func $Set_ofArray (param $cmp (ref $AnyFn)) (param $xs (ref $GcArray_41)) (result (ref $SetModule_SetHandle`1))
    (local $w7 i32)
    (local $w8 (ref $SetModule_SetHandle`1))
    (local $w9 i32)
    (local $x i32)
    local.get $xs
    array.len
    local.set $w7
    local.get $cmp
    call $empty_i32
    local.set $w8
    i32.const 0
    local.set $w9
    block $while_10_exit
      loop $while_10_lp
        local.get $w9
        local.get $w7
        i32.lt_s
        if
          local.get $xs
          local.get $w9
          array.get $GcArray_41
          local.set $x
          local.get $x
          local.get $w8
          call $add_i32
          local.set $w8
          local.get $w9
          i32.const 1
          i32.add
          local.set $w9
          br $while_10_lp
        else
          br $while_10_exit
        end
      end
    end
    local.get $w8
  )
  (func $Set_singleton (param $cmp (ref $AnyFn)) (param $x i32) (result (ref $SetModule_SetHandle`1))
    local.get $x
    local.get $cmp
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
  (func $runAllTests (param $check (ref $AnyFn)) (result i32) ;; exported as "runAllTests"
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $check_44 (param $self (ref $AnyFn)) (param $name (ref $WasmStr)) (param $f (ref $AnyFn))
    (local $self_cast (ref $ClosureType_47))
    (local $failed i32)
    (local $passed i32)
    (local $lo_clo_40 (ref $ClosureBase_387))
    local.get $self
    ref.cast (ref $ClosureType_47)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_47 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_47 2
    local.set $passed
    (block
      (block
        (try_table (catch_all 0)
                local.get $f
                ref.cast (ref $ClosureBase_387)
                local.set $lo_clo_40
                local.get $lo_clo_40
                local.get $lo_clo_40
                struct.get $ClosureBase_387 0
                call_ref $FuncType_44
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
        i32.const 1
        global.set $fsharp_exn_carrier
        ref.null any
        global.set $fsharp_exn_carrier
        throw $fsharp_exn
    )
  )
  (func $check_48 (param $self (ref $AnyFn)) (param $name (ref $WasmStr)) (param $f (ref $AnyFn))
    (local $self_cast (ref $ClosureType_48))
    (local $failed i32)
    (local $passed i32)
    (local $lo_clo_41 (ref $ClosureBase_387))
    local.get $self
    ref.cast (ref $ClosureType_48)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_48 1
    local.set $failed
    local.get $self_cast
    struct.get $ClosureType_48 2
    local.set $passed
    (block
      (block
        (try_table (catch_all 0)
                local.get $f
                ref.cast (ref $ClosureBase_387)
                local.set $lo_clo_41
                local.get $lo_clo_41
                local.get $lo_clo_41
                struct.get $ClosureBase_387 0
                call_ref $FuncType_44
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
        i32.const 1
        global.set $fsharp_exn_carrier
        ref.null any
        global.set $fsharp_exn_carrier
        throw $fsharp_exn
    )
  )
  (func $runAllTests_void (param $check (ref $AnyFn))
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $main (param $_arg (ref $GcArray_43)) (result i32) ;; exported as "main"
    (local $passed i32)
    (local $failed i32)
    i32.const 0
    local.set $passed
    i32.const 0
    local.set $failed
    ref.func $check_48
    local.get $failed
    local.get $passed
    struct.new $ClosureType_48
    call $runAllTests_void
    i32.const 1
    global.set $fsharp_exn_carrier
    ref.null any
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    local.get $failed
    i32.const 0
    i32.gt_s
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
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
  (func $distanceFromOrigin (param $p (ref $QuickTestWasmGc_Preamble_Point)) (result f64) ;; exported as "distanceFromOrigin"
    local.get $p
    struct.get $QuickTestWasmGc_Preamble_Point 0
    local.get $p
    struct.get $QuickTestWasmGc_Preamble_Point 0
    f64.mul
    local.get $p
    struct.get $QuickTestWasmGc_Preamble_Point 1
    local.get $p
    struct.get $QuickTestWasmGc_Preamble_Point 1
    f64.mul
    f64.add
  )
  (func $pointSum (param $x f64) (param $y f64) (result f64) ;; exported as "pointSum"
    (local $p (ref $QuickTestWasmGc_Preamble_Point))
    local.get $x
    local.get $y
    struct.new $QuickTestWasmGc_Preamble_Point
    local.set $p
    local.get $p
    struct.get $QuickTestWasmGc_Preamble_Point 0
    local.get $p
    struct.get $QuickTestWasmGc_Preamble_Point 1
    f64.add
  )
  (func $runCounter (result i32) ;; exported as "runCounter"
    (local $c (ref $QuickTestWasmGc_Preamble_Counter))
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Counter
    local.set $c
    local.get $c
    local.get $c
    struct.get $QuickTestWasmGc_Preamble_Counter 0
    i32.const 1
    i32.add
    struct.set $QuickTestWasmGc_Preamble_Counter 0
    local.get $c
    local.get $c
    struct.get $QuickTestWasmGc_Preamble_Counter 0
    i32.const 1
    i32.add
    struct.set $QuickTestWasmGc_Preamble_Counter 0
    local.get $c
    local.get $c
    struct.get $QuickTestWasmGc_Preamble_Counter 0
    i32.const 1
    i32.add
    struct.set $QuickTestWasmGc_Preamble_Counter 0
    local.get $c
    struct.get $QuickTestWasmGc_Preamble_Counter 0
  )
  (func $rectWidth (param $r (ref $QuickTestWasmGc_Preamble_Rect)) (result f64) ;; exported as "rectWidth"
    local.get $r
    struct.get $QuickTestWasmGc_Preamble_Rect 1
    struct.get $QuickTestWasmGc_Preamble_Point 0
    local.get $r
    struct.get $QuickTestWasmGc_Preamble_Rect 0
    struct.get $QuickTestWasmGc_Preamble_Point 0
    f64.sub
  )
  (func $testDistanceFromOrigin (param $x f64) (param $y f64) (result f64) ;; exported as "testDistanceFromOrigin"
    local.get $x
    local.get $y
    struct.new $QuickTestWasmGc_Preamble_Point
    return_call $distanceFromOrigin
  )
  (func $testRectWidth (param $x1 f64) (param $y1 f64) (param $x2 f64) (param $y2 f64) (result f64) ;; exported as "testRectWidth"
    local.get $x1
    local.get $y1
    struct.new $QuickTestWasmGc_Preamble_Point
    local.get $x2
    local.get $y2
    struct.new $QuickTestWasmGc_Preamble_Point
    struct.new $QuickTestWasmGc_Preamble_Rect
    return_call $rectWidth
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
  (func $shapeArea (param $s (ref $QuickTestWasmGc_Preamble_Shape)) (result f64) ;; exported as "shapeArea"
    (local $s_1 f64)
    (local $r f64)
    local.get $s
    struct.get $QuickTestWasmGc_Preamble_Shape 0
    i32.const 1
    i32.eq
    if (result f64)
      local.get $s
      ref.cast (ref $QuickTestWasmGc_Preamble_Shape#1)
      struct.get $QuickTestWasmGc_Preamble_Shape#1 1
      local.set $s_1
      local.get $s_1
      local.get $s_1
      f64.mul
    else
      local.get $s
      struct.get $QuickTestWasmGc_Preamble_Shape 0
      i32.const 2
      i32.eq
      if (result f64)
        local.get $s
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
        struct.get $QuickTestWasmGc_Preamble_Shape#2 1
        local.get $s
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
        struct.get $QuickTestWasmGc_Preamble_Shape#2 2
        f64.mul
      else
        local.get $s
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#0)
        struct.get $QuickTestWasmGc_Preamble_Shape#0 1
        local.set $r
        local.get $r
        local.get $r
        f64.mul
      end
    end
  )
  (func $shapePerimeter (param $s (ref $QuickTestWasmGc_Preamble_Shape)) (result f64) ;; exported as "shapePerimeter"
    local.get $s
    struct.get $QuickTestWasmGc_Preamble_Shape 0
    i32.const 1
    i32.eq
    if (result f64)
      f64.const 4
      local.get $s
      ref.cast (ref $QuickTestWasmGc_Preamble_Shape#1)
      struct.get $QuickTestWasmGc_Preamble_Shape#1 1
      f64.mul
    else
      local.get $s
      struct.get $QuickTestWasmGc_Preamble_Shape 0
      i32.const 2
      i32.eq
      if (result f64)
        f64.const 2
        local.get $s
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
        struct.get $QuickTestWasmGc_Preamble_Shape#2 1
        f64.mul
        f64.const 2
        local.get $s
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
        struct.get $QuickTestWasmGc_Preamble_Shape#2 2
        f64.mul
        f64.add
      else
        f64.const 4
        local.get $s
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#0)
        struct.get $QuickTestWasmGc_Preamble_Shape#0 1
        f64.mul
      end
    end
  )
  (func $testShapeAreaCircle (param $r f64) (result f64) ;; exported as "testShapeAreaCircle"
    i32.const 0
    local.get $r
    struct.new $QuickTestWasmGc_Preamble_Shape#0
    return_call $shapeArea
  )
  (func $testShapeAreaSquare (param $s f64) (result f64) ;; exported as "testShapeAreaSquare"
    i32.const 1
    local.get $s
    struct.new $QuickTestWasmGc_Preamble_Shape#1
    return_call $shapeArea
  )
  (func $testShapeAreaRect (param $w f64) (param $h f64) (result f64) ;; exported as "testShapeAreaRect"
    i32.const 2
    local.get $w
    local.get $h
    struct.new $QuickTestWasmGc_Preamble_Shape#2
    return_call $shapeArea
  )
  (func $testShapePerimCircle (param $r f64) (result f64) ;; exported as "testShapePerimCircle"
    i32.const 0
    local.get $r
    struct.new $QuickTestWasmGc_Preamble_Shape#0
    return_call $shapePerimeter
  )
  (func $testShapePerimSquare (param $s f64) (result f64) ;; exported as "testShapePerimSquare"
    i32.const 1
    local.get $s
    struct.new $QuickTestWasmGc_Preamble_Shape#1
    return_call $shapePerimeter
  )
  (func $testShapePerimRect (param $w f64) (param $h f64) (result f64) ;; exported as "testShapePerimRect"
    i32.const 2
    local.get $w
    local.get $h
    struct.new $QuickTestWasmGc_Preamble_Shape#2
    return_call $shapePerimeter
  )
  (func $swapPair (param $a i32) (param $b i32) (result (ref $Tuple_15)) ;; exported as "swapPair"
    local.get $b
    local.get $a
    struct.new $Tuple_15
  )
  (func $testSwapPairFst (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairFst"
    local.get $a
    local.get $b
    call $swapPair
    struct.get $Tuple_15 0
  )
  (func $testSwapPairSnd (param $a i32) (param $b i32) (result i32) ;; exported as "testSwapPairSnd"
    local.get $a
    local.get $b
    call $swapPair
    struct.get $Tuple_15 1
  )
  (func $minMax (param $a f64) (param $b f64) (result (ref $Tuple_56)) ;; exported as "minMax"
    local.get $a
    local.get $b
    f64.le
    if (result (ref $Tuple_56))
      local.get $a
      local.get $b
      struct.new $Tuple_56
    else
      local.get $b
      local.get $a
      struct.new $Tuple_56
    end
  )
  (func $testMinMaxFirst (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxFirst"
    local.get $a
    local.get $b
    call $minMax
    struct.get $Tuple_56 0
  )
  (func $testMinMaxSecond (param $a f64) (param $b f64) (result f64) ;; exported as "testMinMaxSecond"
    local.get $a
    local.get $b
    call $minMax
    struct.get $Tuple_56 1
  )
  (func $tripleSum (param $t_ i32) (param $t__1 i32) (param $t__2 i32) (result i32) ;; exported as "tripleSum"
    (local $t (ref $Tuple_57))
    local.get $t_
    local.get $t__1
    local.get $t__2
    struct.new $Tuple_57
    local.set $t
    local.get $t
    struct.get $Tuple_57 0
    local.get $t
    struct.get $Tuple_57 1
    i32.add
    local.get $t
    struct.get $Tuple_57 2
    i32.add
  )
  (func $testTripleSum (param $a i32) (param $b i32) (param $c i32) (result i32) ;; exported as "testTripleSum"
    local.get $a
    local.get $b
    local.get $c
    return_call $tripleSum
  )
  (func $optionOrDefault (param $opt (ref null $Option_12)) (param $def i32) (result i32) ;; exported as "optionOrDefault"
    local.get $opt
    ref.is_null
    if (result i32)
      local.get $def
    else
      local.get $opt
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $optionDouble (param $opt (ref null $Option_12)) (result i32) ;; exported as "optionDouble"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $opt
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
      i32.const 1
      i32.shl
    end
  )
  (func $optionIsSome (param $opt (ref null $Option_12)) (result i32) ;; exported as "optionIsSome"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 0
    else
      i32.const 1
    end
  )
  (func $optionIsNone (param $opt (ref null $Option_12)) (result i32) ;; exported as "optionIsNone"
    local.get $opt
    ref.is_null
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $optionNested (param $v i32) (result i32) ;; exported as "optionNested"
    (local $outer (ref null $Option_58))
    (local $inner (ref null $Option_12))
    local.get $v
    struct.new $Option_12
    struct.new $Option_58
    local.set $outer
    local.get $outer
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $outer
      ref.cast (ref $Option_58)
      struct.get $Option_58 0
      local.set $inner
      local.get $inner
      ref.is_null
      if (result i32)
        i32.const -2
      else
        local.get $inner
        ref.cast (ref $Option_12)
        struct.get $Option_12 0
      end
    end
  )
  (func $testOptionSome (param $v i32) (param $def i32) (result i32) ;; exported as "testOptionSome"
    local.get $v
    struct.new $Option_12
    local.get $def
    return_call $optionOrDefault
  )
  (func $testOptionNone (param $def i32) (result i32) ;; exported as "testOptionNone"
    ref.null $Option_12
    local.get $def
    return_call $optionOrDefault
  )
  (func $testOptionDoubleSome (param $v i32) (result i32) ;; exported as "testOptionDoubleSome"
    local.get $v
    struct.new $Option_12
    return_call $optionDouble
  )
  (func $testOptionDoubleNone (result i32) ;; exported as "testOptionDoubleNone"
    ref.null $Option_12
    return_call $optionDouble
  )
  (func $testOptionIsSome (param $v i32) (result i32) ;; exported as "testOptionIsSome"
    local.get $v
    struct.new $Option_12
    call $optionIsSome
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testOptionIsNone (result i32) ;; exported as "testOptionIsNone"
    ref.null $Option_12
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
    (local $lo_clo_42 (ref $ClosureBase_59))
    local.get $f
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_42
    local.get $lo_clo_42
    local.get $x
    local.get $lo_clo_42
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
  )
  (func $doubleVal (param $x i32) (result i32) ;; exported as "doubleVal"
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_59 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    call $doubleVal
  )
  (func $testHOFSimple (param $x i32) (result i32) ;; exported as "testHOFSimple"
    ref.func $closure_59
    struct.new $ClosureType_60
    local.get $x
    return_call $applyFn
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
    (local $lo_clo_44 (ref $ClosureBase_59))
    (local $lo_clo_43 (ref $ClosureBase_59))
    local.get $f
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_44
    local.get $lo_clo_44
    local.get $f
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_43
    local.get $lo_clo_43
    local.get $x
    local.get $lo_clo_43
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
    local.get $lo_clo_44
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
  )
  (func $closure_61 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    call $doubleVal
  )
  (func $testApplyTwice (param $x i32) (result i32) ;; exported as "testApplyTwice"
    ref.func $closure_61
    struct.new $ClosureType_61
    local.get $x
    return_call $applyTwice
  )
  (func $makeMultiplier (param $n i32) (param $x i32) (result i32) ;; exported as "makeMultiplier"
    local.get $x
    local.get $n
    i32.mul
  )
  (func $testLetCapture (param $n i32) (param $x i32) (result i32) ;; exported as "testLetCapture"
    local.get $n
    local.get $x
    return_call $makeMultiplier
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
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 6
    array.len
  )
  (func $testStringConcatChar (result i32) ;; exported as "testStringConcatChar"
    i32.const 102
    i32.const 111
    i32.const 111
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 6
    i32.const 3
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStringEqTrue (result i32) ;; exported as "testStringEqTrue"
    i32.const 1
  )
  (func $testStringEqFalse (result i32) ;; exported as "testStringEqFalse"
    i32.const 0
  )
  (func $testStringNeq (result i32) ;; exported as "testStringNeq"
    i32.const 1
  )
  (func $testStringConcatVars (result i32) ;; exported as "testStringConcatVars"
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
  )
  (func $closure_62 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 3
    i32.mul
  )
  (func $closure_63 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 3
    i32.mul
  )
  (func $closure_64 (param $self (ref $AnyFn)) (param $v i32) (result i32)
    local.get $v
    i32.const 3
    i32.mul
  )
  (func $testOptionMap (result i32) ;; exported as "testOptionMap"
    (local $w19 (ref null $Option_12))
    (local $w18 (ref null $Option_12))
    (local $v i32)
    i32.const 5
    struct.new $Option_12
    local.set $w18
    local.get $w18
    ref.is_null
    if (result (ref null $Option_12))
      local.get $w18
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
      local.set $v
      local.get $v
      i32.const 3
      i32.mul
      struct.new $Option_12
    else
      ref.null $Option_12
    end
    local.set $w19
    local.get $w19
    ref.is_null
    if (result i32)
      local.get $w19
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 0
    end
  )
  (func $closure_65 (param $self (ref $AnyFn)) (param $v i32) (result (ref null $Option_12))
    local.get $v
    i32.const 0
    i32.gt_s
    if (result (ref null $Option_12))
      local.get $v
      i32.const 1
      i32.shl
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $closure_68 (param $self (ref $AnyFn)) (param $v i32) (result (ref null $Option_12))
    local.get $v
    i32.const 0
    i32.gt_s
    if (result (ref null $Option_12))
      local.get $v
      i32.const 1
      i32.shl
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $closure_69 (param $self (ref $AnyFn)) (param $v i32) (result (ref null $Option_12))
    local.get $v
    i32.const 0
    i32.gt_s
    if (result (ref null $Option_12))
      local.get $v
      i32.const 1
      i32.shl
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $testOptionBind (result i32) ;; exported as "testOptionBind"
    (local $w23 (ref null $Option_12))
    (local $w22 (ref null $Option_12))
    (local $v i32)
    i32.const 4
    struct.new $Option_12
    local.set $w22
    local.get $w22
    ref.is_null
    if (result (ref null $Option_12))
      local.get $w22
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
      local.set $v
      local.get $v
      i32.const 0
      i32.gt_s
      if (result (ref null $Option_12))
        local.get $v
        i32.const 1
        i32.shl
        struct.new $Option_12
      else
        ref.null $Option_12
      end
    else
      ref.null $Option_12
    end
    local.set $w23
    local.get $w23
    ref.is_null
    if (result i32)
      local.get $w23
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const -1
    end
  )
  (func $testListHead (result i32) ;; exported as "testListHead"
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
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
  (func $closure_70 (param $self (ref $AnyFn)) (param $acc i32) (param $x i32) (result i32)
    local.get $acc
    local.get $x
    i32.add
  )
  (func $testListFoldSum (result i32) ;; exported as "testListFoldSum"
    (local $w25 (ref null $ListBase))
    (local $w26 i32)
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
    local.set $w25
    i32.const 0
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
          local.get $w26
          local.get $x
          i32.add
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
  (func $closure_71 (param $self (ref $AnyFn)) (param $acc i32) (param $x_1 i32) (result i32)
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_72 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_73 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testListMapSum (result i32) ;; exported as "testListMapSum"
    (local $w43 (ref null $ListBase))
    (local $w40 (ref null $ListBase))
    (local $w37 (ref null $ListBase))
    (local $w38 (ref null $ListBase))
    (local $x i32)
    (local $w41 (ref null $ListBase))
    (local $w44 i32)
    (local $x_1 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w37
    ref.null $ListBase
    local.set $w38
    block $while_39_exit
      loop $while_39_lp
        local.get $w37
        ref.is_null
        i32.eqz
        if
          local.get $w37
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          local.get $w38
          struct.new $ListCons_30
          local.set $w38
          local.get $w37
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w37
          br $while_39_lp
        else
          br $while_39_exit
        end
      end
    end
    local.get $w38
    local.set $w40
    ref.null $ListBase
    local.set $w41
    block $while_42_exit
      loop $while_42_lp
        local.get $w40
        ref.is_null
        i32.eqz
        if
          local.get $w40
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w41
          struct.new $ListCons_30
          local.set $w41
          local.get $w40
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w40
          br $while_42_lp
        else
          br $while_42_exit
        end
      end
    end
    local.get $w41
    local.set $w43
    i32.const 0
    local.set $w44
    block $while_45_exit
      loop $while_45_lp
        local.get $w43
        ref.is_null
        i32.eqz
        if
          local.get $w43
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w44
          local.get $x_1
          i32.add
          local.set $w44
          local.get $w43
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w43
          br $while_45_lp
        else
          br $while_45_exit
        end
      end
    end
    local.get $w44
  )
  (func $closure_74 (param $self (ref $AnyFn)) (param $acc i32) (param $x_1 i32) (result i32)
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_75 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $closure_76 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testListFilterSum (result i32) ;; exported as "testListFilterSum"
    (local $w61 (ref null $ListBase))
    (local $w58 (ref null $ListBase))
    (local $w55 (ref null $ListBase))
    (local $w56 (ref null $ListBase))
    (local $x i32)
    (local $w59 (ref null $ListBase))
    (local $w62 i32)
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
    local.set $w55
    ref.null $ListBase
    local.set $w56
    block $while_57_exit
      loop $while_57_lp
        local.get $w55
        ref.is_null
        i32.eqz
        if
          local.get $w55
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w55
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.get $w56
            struct.new $ListCons_30
          else
            local.get $w56
          end
          local.set $w56
          local.get $w55
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w55
          br $while_57_lp
        else
          br $while_57_exit
        end
      end
    end
    local.get $w56
    local.set $w58
    ref.null $ListBase
    local.set $w59
    block $while_60_exit
      loop $while_60_lp
        local.get $w58
        ref.is_null
        i32.eqz
        if
          local.get $w58
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w59
          struct.new $ListCons_30
          local.set $w59
          local.get $w58
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w58
          br $while_60_lp
        else
          br $while_60_exit
        end
      end
    end
    local.get $w59
    local.set $w61
    i32.const 0
    local.set $w62
    block $while_63_exit
      loop $while_63_lp
        local.get $w61
        ref.is_null
        i32.eqz
        if
          local.get $w61
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w62
          local.get $x_1
          i32.add
          local.set $w62
          local.get $w61
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w61
          br $while_63_lp
        else
          br $while_63_exit
        end
      end
    end
    local.get $w62
  )
  (func $testListRevHead (result i32) ;; exported as "testListRevHead"
    (local $w65 (ref null $ListBase))
    (local $w66 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w65
    ref.null $ListBase
    local.set $w66
    block $while_67_exit
      loop $while_67_lp
        local.get $w65
        ref.is_null
        i32.eqz
        if
          local.get $w65
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w66
          struct.new $ListCons_30
          local.set $w66
          local.get $w65
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w65
          br $while_67_lp
        else
          br $while_67_exit
        end
      end
    end
    local.get $w66
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListAppendLen (result i32) ;; exported as "testListAppendLen"
    (local $w76 (ref null $ListBase))
    (local $w69 (ref null $ListBase))
    (local $w70 (ref null $ListBase))
    (local $w72 (ref null $ListBase))
    (local $w73 (ref null $ListBase))
    (local $w77 i32)
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w69
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w70
    block $while_71_exit
      loop $while_71_lp
        local.get $w69
        ref.is_null
        i32.eqz
        if
          local.get $w69
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w70
          struct.new $ListCons_30
          local.set $w70
          local.get $w69
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w69
          br $while_71_lp
        else
          br $while_71_exit
        end
      end
    end
    local.get $w70
    local.set $w72
    ref.null $ListBase
    local.set $w73
    block $while_74_exit
      loop $while_74_lp
        local.get $w72
        ref.is_null
        i32.eqz
        if
          local.get $w72
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w73
          struct.new $ListCons_30
          local.set $w73
          local.get $w72
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w72
          br $while_74_lp
        else
          br $while_74_exit
        end
      end
    end
    local.get $w73
    local.set $w76
    i32.const 0
    local.set $w77
    block $while_78_exit
      loop $while_78_lp
        local.get $w76
        ref.is_null
        i32.eqz
        if
          local.get $w77
          i32.const 1
          i32.add
          local.set $w77
          local.get $w76
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w76
          br $while_78_lp
        else
          br $while_78_exit
        end
      end
    end
    local.get $w77
  )
  (func $testIntOfFloat (result i32) ;; exported as "testIntOfFloat"
    f64.const 3.7000000000000002
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testIntOfNegFloat (result i32) ;; exported as "testIntOfNegFloat"
    f64.const -2.8999999999999999
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testFloatOfInt (result i32) ;; exported as "testFloatOfInt"
    i32.const 5
    f64.convert_i32_s
    f64.const 2
    f64.mul
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testInt64OfInt (result i32) ;; exported as "testInt64OfInt"
    i32.const 7
    i64.extend_i32_s
    i32.const 3
    i64.extend_i32_s
    i64.add
    i32.wrap_i64
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $closure_77 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_78))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_78)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_78 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIter (result i32) ;; exported as "testListIter"
    (local $acc i32)
    (local $w80 (ref null $ListBase))
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
    local.set $w80
    block $while_81_exit
      loop $while_81_lp
        local.get $w80
        ref.is_null
        i32.eqz
        if
          local.get $w80
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w80
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w80
          br $while_81_lp
        else
          br $while_81_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_79 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_79))
    (local $acc i32)
    local.get $self
    ref.cast (ref $ClosureType_79)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_79 1
    local.set $acc
    local.get $acc
    local.get $x
    i32.add
    local.set $acc
  )
  (func $testListIterEmpty (result i32) ;; exported as "testListIterEmpty"
    (local $acc i32)
    (local $w83 (ref null $ListBase))
    (local $x i32)
    i32.const 0
    local.set $acc
    ref.null $ListBase
    local.set $w83
    block $while_84_exit
      loop $while_84_lp
        local.get $w83
        ref.is_null
        i32.eqz
        if
          local.get $w83
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $acc
          local.get $x
          i32.add
          local.set $acc
          local.get $w83
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w83
          br $while_84_lp
        else
          br $while_84_exit
        end
      end
    end
    local.get $acc
  )
  (func $closure_80 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListExists (result i32) ;; exported as "testListExists"
    (local $w86 (ref null $ListBase))
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
    local.set $w86
    block $exi_85_blk (result i32)
      block $exi_85_lp_exit
        loop $exi_85_lp
          local.get $w86
          ref.is_null
          i32.eqz
          if
            local.get $w86
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              i32.const 1
              br $exi_85_blk
            end
            local.get $w86
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w86
          else
            br $exi_85_lp_exit
          end
          br $exi_85_lp
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
  (func $closure_81 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListExistsFalse (result i32) ;; exported as "testListExistsFalse"
    (local $w88 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w88
    block $exi_87_blk (result i32)
      block $exi_87_lp_exit
        loop $exi_87_lp
          local.get $w88
          ref.is_null
          i32.eqz
          if
            local.get $w88
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $exi_87_blk
            end
            local.get $w88
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w88
          else
            br $exi_87_lp_exit
          end
          br $exi_87_lp
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
  (func $closure_82 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListForAll (result i32) ;; exported as "testListForAll"
    (local $w90 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w90
    block $all_89_blk (result i32)
      block $all_89_lp_exit
        loop $all_89_lp
          local.get $w90
          ref.is_null
          i32.eqz
          if
            local.get $w90
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w90
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w90
            else
              i32.const 0
              br $all_89_blk
            end
          else
            br $all_89_lp_exit
          end
          br $all_89_lp
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
  (func $closure_83 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testListForAllFalse (result i32) ;; exported as "testListForAllFalse"
    (local $w92 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w92
    block $all_91_blk (result i32)
      block $all_91_lp_exit
        loop $all_91_lp
          local.get $w92
          ref.is_null
          i32.eqz
          if
            local.get $w92
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 2
            i32.gt_s
            if
              local.get $w92
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w92
            else
              i32.const 0
              br $all_91_blk
            end
          else
            br $all_91_lp_exit
          end
          br $all_91_lp
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
  (func $closure_84 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSum (result i32) ;; exported as "testListSum"
    (local $w94 (ref null $ListBase))
    (local $w95 i32)
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
    local.set $w94
    i32.const 0
    local.set $w95
    block $while_96_exit
      loop $while_96_lp
        local.get $w94
        ref.is_null
        i32.eqz
        if
          local.get $w95
          local.get $w94
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w95
          local.get $w94
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w94
          br $while_96_lp
        else
          br $while_96_exit
        end
      end
    end
    local.get $w95
  )
  (func $closure_87 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumEmpty (result i32) ;; exported as "testListSumEmpty"
    (local $w98 (ref null $ListBase))
    (local $w99 i32)
    ref.null $ListBase
    local.set $w98
    i32.const 0
    local.set $w99
    block $while_100_exit
      loop $while_100_lp
        local.get $w98
        ref.is_null
        i32.eqz
        if
          local.get $w99
          local.get $w98
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w99
          local.get $w98
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w98
          br $while_100_lp
        else
          br $while_100_exit
        end
      end
    end
    local.get $w99
  )
  (func $closure_88 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListTryFindSome (result i32) ;; exported as "testListTryFindSome"
    (local $matchValue (ref null $Option_12))
    (local $w102 (ref null $ListBase))
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
    local.set $w102
    block $tryf_101_exit (result (ref null $Option_12))
      block $tryf_101_lp_exit
        loop $tryf_101_lp
          local.get $w102
          ref.is_null
          i32.eqz
          if
            local.get $w102
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w102
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 0
              struct.new $Option_12
              br $tryf_101_exit
            end
            local.get $w102
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w102
          else
            br $tryf_101_lp_exit
          end
          br $tryf_101_lp
        end
      end
      ref.null $Option_12
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $closure_89 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindNone (result i32) ;; exported as "testListTryFindNone"
    (local $matchValue (ref null $Option_12))
    (local $w104 (ref null $ListBase))
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
    local.set $w104
    block $tryf_103_exit (result (ref null $Option_12))
      block $tryf_103_lp_exit
        loop $tryf_103_lp
          local.get $w104
          ref.is_null
          i32.eqz
          if
            local.get $w104
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              local.get $w104
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 0
              struct.new $Option_12
              br $tryf_103_exit
            end
            local.get $w104
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w104
          else
            br $tryf_103_lp_exit
          end
          br $tryf_103_lp
        end
      end
      ref.null $Option_12
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $testListTryHeadSome (result i32) ;; exported as "testListTryHeadSome"
    (local $matchValue (ref null $Option_12))
    (local $w106 (ref null $ListBase))
    i32.const 7
    i32.const 8
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w106
    local.get $w106
    ref.is_null
    if (result (ref null $Option_12))
      ref.null $Option_12
    else
      local.get $w106
      ref.cast (ref $ListCons_30)
      struct.get $ListCons_30 0
      struct.new $Option_12
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $testListTryHeadNone (result i32) ;; exported as "testListTryHeadNone"
    (local $matchValue (ref null $Option_12))
    ref.null $Option_12
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $testRefCell (result i32) ;; exported as "testRefCell"
    (local $r (ref $RefCell_90))
    i32.const 5
    struct.new $RefCell_90
    local.set $r
    local.get $r
    local.get $r
    struct.get $RefCell_90 0
    i32.const 1
    i32.add
    struct.set $RefCell_90 0
    local.get $r
    struct.get $RefCell_90 0
  )
  (func $testRefCellBool (result i32) ;; exported as "testRefCellBool"
    (local $r (ref $RefCell_90))
    i32.const 0
    struct.new $RefCell_90
    local.set $r
    local.get $r
    i32.const 1
    struct.set $RefCell_90 0
    local.get $r
    struct.get $RefCell_90 0
  )
  (func $treeSum (param $t (ref $QuickTestWasmGc_Preamble_Tree)) (result i32) ;; exported as "treeSum"
    local.get $t
    struct.get $QuickTestWasmGc_Preamble_Tree 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $t
      ref.cast (ref $QuickTestWasmGc_Preamble_Tree#1)
      struct.get $QuickTestWasmGc_Preamble_Tree#1 3
      local.get $t
      ref.cast (ref $QuickTestWasmGc_Preamble_Tree#1)
      struct.get $QuickTestWasmGc_Preamble_Tree#1 1
      call $treeSum
      i32.add
      local.get $t
      ref.cast (ref $QuickTestWasmGc_Preamble_Tree#1)
      struct.get $QuickTestWasmGc_Preamble_Tree#1 2
      call $treeSum
      i32.add
    else
      i32.const 0
    end
  )
  (func $testTreeSum (result i32) ;; exported as "testTreeSum"
    i32.const 1
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 1
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 2
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    i32.const 3
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    return_call $treeSum
  )
  (func $testTreeSum2 (result i32) ;; exported as "testTreeSum2"
    i32.const 1
    i32.const 1
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 1
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 2
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    i32.const 4
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    i32.const 1
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 0
    struct.new $QuickTestWasmGc_Preamble_Tree#0
    i32.const 3
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    i32.const 10
    struct.new $QuickTestWasmGc_Preamble_Tree#1
    return_call $treeSum
  )
  (func $isEvenTC (param $n i32) (result i32) ;; exported as "isEvenTC"
    local.get $n
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $n
      i32.const 1
      i32.sub
      return_call $isOddTC
    end
  )
  (func $isOddTC (param $n i32) (result i32) ;; exported as "isOddTC"
    local.get $n
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $n
      i32.const 1
      i32.sub
      return_call $isEvenTC
    end
  )
  (func $testMutualTailCall (result i32) ;; exported as "testMutualTailCall"
    i32.const 1000
    call $isEvenTC
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testMutualTailCall2 (result i32) ;; exported as "testMutualTailCall2"
    i32.const 999
    call $isOddTC
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testArrayLiteral (result i32) ;; exported as "testArrayLiteral"
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_41 3
    i32.const 1
    array.get $GcArray_41
  )
  (func $testArrayCreate (result i32) ;; exported as "testArrayCreate"
    (local $arr (ref $GcArray_41))
    i32.const 0
    i32.const 3
    array.new $GcArray_41
    local.set $arr
    local.get $arr
    i32.const 0
    i32.const 10
    array.set $GcArray_41
    local.get $arr
    i32.const 1
    i32.const 20
    array.set $GcArray_41
    local.get $arr
    i32.const 2
    i32.const 30
    array.set $GcArray_41
    local.get $arr
    i32.const 0
    array.get $GcArray_41
    local.get $arr
    i32.const 1
    array.get $GcArray_41
    i32.add
    local.get $arr
    i32.const 2
    array.get $GcArray_41
    i32.add
  )
  (func $testArrayZeroCreate (result i32) ;; exported as "testArrayZeroCreate"
    (local $arr (ref $GcArray_41))
    i32.const 0
    i32.const 4
    array.new $GcArray_41
    local.set $arr
    local.get $arr
    i32.const 2
    i32.const 7
    array.set $GcArray_41
    local.get $arr
    i32.const 2
    array.get $GcArray_41
  )
  (func $testArrayLength (result i32) ;; exported as "testArrayLength"
    (local $arr (ref $GcArray_41))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $arr
    local.get $arr
    array.len
  )
  (func $testArraySumLoop (result i32) ;; exported as "testArraySumLoop"
    (local $arr (ref $GcArray_41))
    (local $s i32)
    (local $i i32)
    (local $limit i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
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
        array.get $GcArray_41
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
    f64.const 1
    f64.const 3.1400000000000001
    f64.const 2.71
    array.new_fixed $GcArray_94 3
    i32.const 1
    array.get $GcArray_94
  )
  (func $closure_95 (param $self (ref $AnyFn)) (param $acc i32) (param $x i32) (result i32)
    local.get $acc
    local.get $x
    i32.add
  )
  (func $testArrayFold (result i32) ;; exported as "testArrayFold"
    (local $w110 (ref $GcArray_41))
    (local $w111 i32)
    (local $w112 i32)
    (local $w113 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w110
    local.get $w110
    array.len
    local.set $w111
    i32.const 0
    local.set $w112
    i32.const 0
    local.set $w113
    block $while_114_exit
      loop $while_114_lp
        local.get $w113
        local.get $w111
        i32.lt_s
        if
          local.get $w110
          local.get $w113
          array.get $GcArray_41
          local.set $x
          local.get $w112
          local.get $x
          i32.add
          local.set $w112
          local.get $w113
          i32.const 1
          i32.add
          local.set $w113
          br $while_114_lp
        else
          br $while_114_exit
        end
      end
    end
    local.get $w112
  )
  (func $closure_96 (param $self (ref $AnyFn)) (param $acc f64) (param $x f64) (result f64)
    local.get $acc
    local.get $x
    f64.add
  )
  (func $testArrayFoldFloat (result f64) ;; exported as "testArrayFoldFloat"
    (local $w116 (ref $GcArray_94))
    (local $w117 i32)
    (local $w118 f64)
    (local $w119 i32)
    (local $x f64)
    f64.const 0.5
    f64.const 0.5
    f64.const 0.5
    array.new_fixed $GcArray_94 3
    local.set $w116
    local.get $w116
    array.len
    local.set $w117
    f64.const 0
    local.set $w118
    i32.const 0
    local.set $w119
    block $while_120_exit
      loop $while_120_lp
        local.get $w119
        local.get $w117
        i32.lt_s
        if
          local.get $w116
          local.get $w119
          array.get $GcArray_94
          local.set $x
          local.get $w118
          local.get $x
          f64.add
          local.set $w118
          local.get $w119
          i32.const 1
          i32.add
          local.set $w119
          br $while_120_lp
        else
          br $while_120_exit
        end
      end
    end
    local.get $w118
  )
  (func $closure_99 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testArrayMap (result i32) ;; exported as "testArrayMap"
    (local $result (ref $GcArray_41))
    (local $w122 (ref $GcArray_41))
    (local $w123 i32)
    (local $w124 (ref $GcArray_41))
    (local $w126 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w122
    local.get $w122
    array.len
    local.set $w123
    i32.const 0
    local.get $w123
    array.new $GcArray_41
    local.set $w124
    i32.const 0
    local.set $w126
    block $while_127_exit
      loop $while_127_lp
        local.get $w126
        local.get $w123
        i32.lt_s
        if
          local.get $w124
          local.get $w126
          local.get $w122
          local.get $w126
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          array.set $GcArray_41
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
    local.get $w124
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_41
    local.get $result
    i32.const 4
    array.get $GcArray_41
    i32.add
  )
  (func $closure_100 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul
  )
  (func $testArrayMapStr (result i32) ;; exported as "testArrayMapStr"
    (local $w129 (ref $GcArray_41))
    (local $w130 i32)
    (local $w131 (ref $GcArray_41))
    (local $w133 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w129
    local.get $w129
    array.len
    local.set $w130
    i32.const 0
    local.get $w130
    array.new $GcArray_41
    local.set $w131
    i32.const 0
    local.set $w133
    block $while_134_exit
      loop $while_134_lp
        local.get $w133
        local.get $w130
        i32.lt_s
        if
          local.get $w131
          local.get $w133
          local.get $w129
          local.get $w133
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 3
          i32.mul
          array.set $GcArray_41
          local.get $w133
          i32.const 1
          i32.add
          local.set $w133
          br $while_134_lp
        else
          br $while_134_exit
        end
      end
    end
    local.get $w131
    i32.const 2
    array.get $GcArray_41
  )
  (func $closure_101 (param $self (ref $AnyFn)) (param $i i32) (param $x i32) (result i32)
    local.get $i
    local.get $x
    i32.add
  )
  (func $testArrayMapi (result i32) ;; exported as "testArrayMapi"
    (local $w136 (ref $GcArray_41))
    (local $w137 i32)
    (local $w138 (ref $GcArray_41))
    (local $w140 i32)
    (local $x i32)
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_41 3
    local.set $w136
    local.get $w136
    array.len
    local.set $w137
    i32.const 0
    local.get $w137
    array.new $GcArray_41
    local.set $w138
    i32.const 0
    local.set $w140
    block $while_141_exit
      loop $while_141_lp
        local.get $w140
        local.get $w137
        i32.lt_s
        if
          local.get $w138
          local.get $w140
          local.get $w136
          local.get $w140
          array.get $GcArray_41
          local.set $x
          local.get $w140
          local.get $x
          i32.add
          array.set $GcArray_41
          local.get $w140
          i32.const 1
          i32.add
          local.set $w140
          br $while_141_lp
        else
          br $while_141_exit
        end
      end
    end
    local.get $w138
    i32.const 1
    array.get $GcArray_41
  )
  (func $closure_102 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.gt_s
  )
  (func $testArrayFilter (result i32) ;; exported as "testArrayFilter"
    (local $arr (ref $GcArray_41))
    (local $result (ref $GcArray_41))
    (local $w143 i32)
    (local $w144 i32)
    (local $w145 i32)
    (local $x i32)
    (local $w147 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $arr
    local.get $arr
    array.len
    local.set $w143
    i32.const 0
    local.set $w144
    i32.const 0
    local.set $w145
    block $while_146_exit
      loop $while_146_lp
        local.get $w145
        local.get $w143
        i32.lt_s
        if
          local.get $arr
          local.get $w145
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            local.get $w144
            i32.const 1
            i32.add
            local.set $w144
          end
          local.get $w145
          i32.const 1
          i32.add
          local.set $w145
          br $while_146_lp
        else
          br $while_146_exit
        end
      end
    end
    i32.const 0
    local.set $w147
    i32.const 0
    local.set $w145
    block $while_148_exit
      loop $while_148_lp
        local.get $w145
        local.get $w143
        i32.lt_s
        if
          local.get $arr
          local.get $w145
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if
            i32.const 0
            local.get $w144
            array.new $GcArray_41
            local.get $w147
            local.get $arr
            local.get $w145
            array.get $GcArray_41
            array.set $GcArray_41
            local.get $w147
            i32.const 1
            i32.add
            local.set $w147
          end
          local.get $w145
          i32.const 1
          i32.add
          local.set $w145
          br $while_148_lp
        else
          br $while_148_exit
        end
      end
    end
    i32.const 0
    local.get $w144
    array.new $GcArray_41
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_103 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayFilterAll (result i32) ;; exported as "testArrayFilterAll"
    (local $result (ref $GcArray_41))
    (local $w150 i32)
    (local $w151 i32)
    (local $w152 i32)
    (local $x i32)
    (local $w154 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    array.len
    local.set $w150
    i32.const 0
    local.set $w151
    i32.const 0
    local.set $w152
    block $while_153_exit
      loop $while_153_lp
        local.get $w152
        local.get $w150
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_41 5
          local.get $w152
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            local.get $w151
            i32.const 1
            i32.add
            local.set $w151
          end
          local.get $w152
          i32.const 1
          i32.add
          local.set $w152
          br $while_153_lp
        else
          br $while_153_exit
        end
      end
    end
    i32.const 0
    local.set $w154
    i32.const 0
    local.set $w152
    block $while_155_exit
      loop $while_155_lp
        local.get $w152
        local.get $w150
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_41 5
          local.get $w152
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 0
          i32.gt_s
          if
            i32.const 0
            local.get $w151
            array.new $GcArray_41
            local.get $w154
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_41 5
            local.get $w152
            array.get $GcArray_41
            array.set $GcArray_41
            local.get $w154
            i32.const 1
            i32.add
            local.set $w154
          end
          local.get $w152
          i32.const 1
          i32.add
          local.set $w152
          br $while_155_lp
        else
          br $while_155_exit
        end
      end
    end
    i32.const 0
    local.get $w151
    array.new $GcArray_41
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_104 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayFilterNone (result i32) ;; exported as "testArrayFilterNone"
    (local $result (ref $GcArray_41))
    (local $w157 i32)
    (local $w158 i32)
    (local $w159 i32)
    (local $x i32)
    (local $w161 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
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
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_41 5
          local.get $w159
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w158
            i32.const 1
            i32.add
            local.set $w158
          end
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
    i32.const 0
    local.set $w161
    i32.const 0
    local.set $w159
    block $while_162_exit
      loop $while_162_lp
        local.get $w159
        local.get $w157
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_41 5
          local.get $w159
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            i32.const 0
            local.get $w158
            array.new $GcArray_41
            local.get $w161
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_41 5
            local.get $w159
            array.get $GcArray_41
            array.set $GcArray_41
            local.get $w161
            i32.const 1
            i32.add
            local.set $w161
          end
          local.get $w159
          i32.const 1
          i32.add
          local.set $w159
          br $while_162_lp
        else
          br $while_162_exit
        end
      end
    end
    i32.const 0
    local.get $w158
    array.new $GcArray_41
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_105 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 4
    i32.gt_s
  )
  (func $testArrayExists (result i32) ;; exported as "testArrayExists"
    (local $w164 i32)
    (local $w165 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    array.len
    local.set $w164
    i32.const 0
    local.set $w165
    block $isome_163_blk (result i32)
      block $while_166_exit
        loop $while_166_lp
          local.get $w165
          local.get $w164
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_41 5
            local.get $w165
            array.get $GcArray_41
            local.set $x
            local.get $x
            i32.const 4
            i32.gt_s
            if
              i32.const 1
              br $isome_163_blk
            end
            local.get $w165
            i32.const 1
            i32.add
            local.set $w165
            br $while_166_lp
          else
            br $while_166_exit
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
  (func $closure_106 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testArrayExistsFalse (result i32) ;; exported as "testArrayExistsFalse"
    (local $w168 i32)
    (local $w169 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    array.len
    local.set $w168
    i32.const 0
    local.set $w169
    block $isome_167_blk (result i32)
      block $while_170_exit
        loop $while_170_lp
          local.get $w169
          local.get $w168
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_41 5
            local.get $w169
            array.get $GcArray_41
            local.set $x
            local.get $x
            i32.const 10
            i32.gt_s
            if
              i32.const 1
              br $isome_167_blk
            end
            local.get $w169
            i32.const 1
            i32.add
            local.set $w169
            br $while_170_lp
          else
            br $while_170_exit
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
  (func $closure_107 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testArrayForAll (result i32) ;; exported as "testArrayForAll"
    (local $w172 i32)
    (local $w173 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    array.len
    local.set $w172
    i32.const 0
    local.set $w173
    block $ievery_171_blk (result i32)
      block $while_174_exit
        loop $while_174_lp
          local.get $w173
          local.get $w172
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_41 5
            local.get $w173
            array.get $GcArray_41
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w173
              i32.const 1
              i32.add
              local.set $w173
            else
              i32.const 0
              br $ievery_171_blk
            end
            br $while_174_lp
          else
            br $while_174_exit
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
  (func $closure_108 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayForAllFalse (result i32) ;; exported as "testArrayForAllFalse"
    (local $w176 i32)
    (local $w177 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    array.len
    local.set $w176
    i32.const 0
    local.set $w177
    block $ievery_175_blk (result i32)
      block $while_178_exit
        loop $while_178_lp
          local.get $w177
          local.get $w176
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_41 5
            local.get $w177
            array.get $GcArray_41
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w177
              i32.const 1
              i32.add
              local.set $w177
            else
              i32.const 0
              br $ievery_175_blk
            end
            br $while_178_lp
          else
            br $while_178_exit
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
  (func $closure_109 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $testArrayInit (result i32) ;; exported as "testArrayInit"
    (local $w180 (ref $GcArray_41))
    (local $w181 i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_41
    local.set $w180
    i32.const 0
    local.set $w181
    block $while_182_exit
      loop $while_182_lp
        local.get $w181
        local.get $w180
        array.len
        i32.lt_s
        if
          local.get $w180
          local.get $w181
          local.get $w181
          local.get $w181
          i32.mul
          array.set $GcArray_41
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
    local.get $w180
    i32.const 3
    array.get $GcArray_41
  )
  (func $closure_110 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_111 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
  )
  (func $testArrayInitFold (result i32) ;; exported as "testArrayInitFold"
    (local $w188 (ref $GcArray_41))
    (local $w184 (ref $GcArray_41))
    (local $w185 i32)
    (local $w189 i32)
    (local $w190 i32)
    (local $w191 i32)
    (local $y i32)
    i32.const 0
    i32.const 5
    array.new $GcArray_41
    local.set $w184
    i32.const 0
    local.set $w185
    block $while_186_exit
      loop $while_186_lp
        local.get $w185
        local.get $w184
        array.len
        i32.lt_s
        if
          local.get $w184
          local.get $w185
          local.get $w185
          array.set $GcArray_41
          local.get $w185
          i32.const 1
          i32.add
          local.set $w185
          br $while_186_lp
        else
          br $while_186_exit
        end
      end
    end
    local.get $w184
    local.set $w188
    local.get $w188
    array.len
    local.set $w189
    i32.const 0
    local.set $w190
    i32.const 0
    local.set $w191
    block $while_192_exit
      loop $while_192_lp
        local.get $w191
        local.get $w189
        i32.lt_s
        if
          local.get $w188
          local.get $w191
          array.get $GcArray_41
          local.set $y
          local.get $w190
          local.get $y
          i32.add
          local.set $w190
          local.get $w191
          i32.const 1
          i32.add
          local.set $w191
          br $while_192_lp
        else
          br $while_192_exit
        end
      end
    end
    local.get $w190
  )
  (func $closure_112 (param $self (ref $AnyFn)) (param $x i32)
    (local $self_cast (ref $ClosureType_112))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_112)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_112 1
    local.set $s
    local.get $s
    local.get $x
    i32.add
    local.set $s
  )
  (func $testArrayIter (result i32) ;; exported as "testArrayIter"
    (local $s i32)
    (local $w194 (ref $GcArray_41))
    (local $w195 i32)
    (local $w196 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w194
    local.get $w194
    array.len
    local.set $w195
    i32.const 0
    local.set $w196
    block $while_197_exit
      loop $while_197_lp
        local.get $w196
        local.get $w195
        i32.lt_s
        if
          local.get $w194
          local.get $w196
          array.get $GcArray_41
          local.set $x
          local.get $s
          local.get $x
          i32.add
          local.set $s
          local.get $w196
          i32.const 1
          i32.add
          local.set $w196
          br $while_197_lp
        else
          br $while_197_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_113 (param $self (ref $AnyFn)) (param $i i32) (param $x i32)
    (local $self_cast (ref $ClosureType_114))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_114)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_114 1
    local.set $s
    local.get $s
    local.get $i
    local.get $x
    i32.mul
    i32.add
    local.set $s
  )
  (func $testArrayIteri (result i32) ;; exported as "testArrayIteri"
    (local $s i32)
    (local $w199 (ref $GcArray_41))
    (local $w200 i32)
    (local $w201 i32)
    (local $x i32)
    i32.const 0
    local.set $s
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w199
    local.get $w199
    array.len
    local.set $w200
    i32.const 0
    local.set $w201
    block $while_202_exit
      loop $while_202_lp
        local.get $w201
        local.get $w200
        i32.lt_s
        if
          local.get $w199
          local.get $w201
          array.get $GcArray_41
          local.set $x
          local.get $s
          local.get $w201
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w201
          i32.const 1
          i32.add
          local.set $w201
          br $while_202_lp
        else
          br $while_202_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_115 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $testArrayReduce (result i32) ;; exported as "testArrayReduce"
    (local $w204 (ref $GcArray_41))
    (local $w205 i32)
    (local $w206 i32)
    (local $w207 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w204
    local.get $w204
    array.len
    local.set $w205
    local.get $w204
    i32.const 0
    array.get $GcArray_41
    local.set $w206
    i32.const 1
    local.set $w207
    block $while_208_exit
      loop $while_208_lp
        local.get $w207
        local.get $w205
        i32.lt_s
        if
          local.get $w204
          local.get $w207
          array.get $GcArray_41
          local.set $y
          local.get $w206
          local.get $y
          i32.add
          local.set $w206
          local.get $w207
          i32.const 1
          i32.add
          local.set $w207
          br $while_208_lp
        else
          br $while_208_exit
        end
      end
    end
    local.get $w206
  )
  (func $closure_116 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArraySum (result i32) ;; exported as "testArraySum"
    (local $w210 (ref $GcArray_41))
    (local $w211 i32)
    (local $w212 i32)
    (local $w213 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w210
    local.get $w210
    array.len
    local.set $w211
    i32.const 0
    local.set $w212
    i32.const 0
    local.set $w213
    block $while_214_exit
      loop $while_214_lp
        local.get $w213
        local.get $w211
        i32.lt_s
        if
          local.get $w212
          local.get $w210
          local.get $w213
          array.get $GcArray_41
          i32.add
          local.set $w212
          local.get $w213
          i32.const 1
          i32.add
          local.set $w213
          br $while_214_lp
        else
          br $while_214_exit
        end
      end
    end
    local.get $w212
  )
  (func $closure_117 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w216 (ref $GcArray_41))
    (local $w217 i32)
    (local $w218 i32)
    (local $w219 i32)
    (local $w220 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w216
    local.get $w216
    array.len
    local.set $w217
    local.get $w216
    i32.const 0
    array.get $GcArray_41
    local.set $w218
    i32.const 1
    local.set $w219
    block $while_221_exit
      loop $while_221_lp
        local.get $w219
        local.get $w217
        i32.lt_s
        if
          local.get $w216
          local.get $w219
          array.get $GcArray_41
          local.set $w220
          local.get $w220
          local.get $w218
          i32.lt_s
          if (result i32)
            local.get $w220
          else
            local.get $w218
          end
          local.set $w218
          local.get $w219
          i32.const 1
          i32.add
          local.set $w219
          br $while_221_lp
        else
          br $while_221_exit
        end
      end
    end
    local.get $w218
  )
  (func $closure_118 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w223 (ref $GcArray_41))
    (local $w224 i32)
    (local $w225 i32)
    (local $w226 i32)
    (local $w227 i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 1
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w223
    local.get $w223
    array.len
    local.set $w224
    local.get $w223
    i32.const 0
    array.get $GcArray_41
    local.set $w225
    i32.const 1
    local.set $w226
    block $while_228_exit
      loop $while_228_lp
        local.get $w226
        local.get $w224
        i32.lt_s
        if
          local.get $w223
          local.get $w226
          array.get $GcArray_41
          local.set $w227
          local.get $w227
          local.get $w225
          i32.gt_s
          if (result i32)
            local.get $w227
          else
            local.get $w225
          end
          local.set $w225
          local.get $w226
          i32.const 1
          i32.add
          local.set $w226
          br $while_228_lp
        else
          br $while_228_exit
        end
      end
    end
    local.get $w225
  )
  (func $testArrayRev (result i32) ;; exported as "testArrayRev"
    (local $w230 (ref $GcArray_41))
    (local $w231 i32)
    (local $w232 (ref $GcArray_41))
    (local $w233 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w230
    local.get $w230
    array.len
    local.set $w231
    i32.const 0
    local.get $w231
    array.new $GcArray_41
    local.set $w232
    i32.const 0
    local.set $w233
    block $while_234_exit
      loop $while_234_lp
        local.get $w233
        local.get $w231
        i32.lt_s
        if
          local.get $w232
          local.get $w233
          local.get $w230
          local.get $w231
          i32.const 1
          i32.sub
          local.get $w233
          i32.sub
          array.get $GcArray_41
          array.set $GcArray_41
          local.get $w233
          i32.const 1
          i32.add
          local.set $w233
          br $while_234_lp
        else
          br $while_234_exit
        end
      end
    end
    local.get $w232
    i32.const 0
    array.get $GcArray_41
  )
  (func $closure_119 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w236 (ref $GcArray_41))
    (local $w237 i32)
    (local $w238 (ref $GcArray_41))
    (local $w239 i32)
    (local $w240 i32)
    (local $w241 i32)
    i32.const 3
    i32.const 1
    i32.const 2
    array.new_fixed $GcArray_41 3
    local.set $w236
    local.get $w236
    array.len
    local.set $w237
    i32.const 0
    local.get $w237
    array.new $GcArray_41
    local.set $w238
    local.get $w238
    i32.const 0
    local.get $w236
    i32.const 0
    local.get $w237
    array.copy $GcArray_41 $GcArray_41
    i32.const 1
    local.set $w239
    block $while_243_exit
      loop $while_243_lp
        local.get $w239
        local.get $w237
        i32.lt_s
        if
          local.get $w238
          local.get $w239
          array.get $GcArray_41
          local.set $w240
          local.get $w239
          i32.const 1
          i32.sub
          local.set $w241
          block $while_242_exit
            loop $while_242_lp
              local.get $w241
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w238
                local.get $w241
                array.get $GcArray_41
                local.get $w240
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w238
                  local.get $w241
                  array.get $GcArray_41
                  local.get $w240
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
                local.get $w238
                local.get $w241
                i32.const 1
                i32.add
                local.get $w238
                local.get $w241
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w241
                i32.const 1
                i32.sub
                local.set $w241
                br $while_242_lp
              else
                br $while_242_exit
              end
            end
          end
          local.get $w238
          local.get $w241
          i32.const 1
          i32.add
          local.get $w240
          array.set $GcArray_41
          local.get $w239
          i32.const 1
          i32.add
          local.set $w239
          br $while_243_lp
        else
          br $while_243_exit
        end
      end
    end
    local.get $w238
    i32.const 0
    array.get $GcArray_41
  )
  (func $closure_120 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testArrayFindIndex (result i32) ;; exported as "testArrayFindIndex"
    (local $w245 i32)
    (local $w246 i32)
    (local $x i32)
    i32.const 1
    i32.const 5
    i32.const 2
    i32.const 4
    array.new_fixed $GcArray_41 4
    array.len
    local.set $w245
    i32.const 0
    local.set $w246
    block $afidx_244_search (result i32)
      block $while_247_exit
        loop $while_247_lp
          local.get $w246
          local.get $w245
          i32.lt_s
          if
            i32.const 1
            i32.const 5
            i32.const 2
            i32.const 4
            array.new_fixed $GcArray_41 4
            local.get $w246
            array.get $GcArray_41
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              local.get $w246
              br $afidx_244_search
            end
            local.get $w246
            i32.const 1
            i32.add
            local.set $w246
            br $while_247_lp
          else
            br $while_247_exit
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_121 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContains (result i32) ;; exported as "testArrayContains"
    (local $w250 i32)
    (local $w251 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_41 4
    array.len
    local.set $w250
    i32.const 0
    local.set $w251
    block $acont_248_blk (result i32)
      block $while_252_exit
        loop $while_252_lp
          local.get $w251
          local.get $w250
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_41 4
            local.get $w251
            array.get $GcArray_41
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $acont_248_blk
            end
            local.get $w251
            i32.const 1
            i32.add
            local.set $w251
            br $while_252_lp
          else
            br $while_252_exit
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
  (func $closure_122 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testArrayContainsFalse (result i32) ;; exported as "testArrayContainsFalse"
    (local $w255 i32)
    (local $w256 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_41 4
    array.len
    local.set $w255
    i32.const 0
    local.set $w256
    block $acont_253_blk (result i32)
      block $while_257_exit
        loop $while_257_lp
          local.get $w256
          local.get $w255
          i32.lt_s
          if
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            array.new_fixed $GcArray_41 4
            local.get $w256
            array.get $GcArray_41
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $acont_253_blk
            end
            local.get $w256
            i32.const 1
            i32.add
            local.set $w256
            br $while_257_lp
          else
            br $while_257_exit
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
  (func $closure_123 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_124 (param $self (ref $AnyFn)) (param $i i32) (param $x_1 i32) (result i32)
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $closure_125 (param $self (ref $AnyFn)) (param $i i32) (param $x_1 i32) (result i32)
    local.get $i
    local.get $x_1
    i32.mul
  )
  (func $testListMapi (result i32) ;; exported as "testListMapi"
    (local $w275 (ref null $ListBase))
    (local $w272 (ref null $ListBase))
    (local $w268 (ref null $ListBase))
    (local $w269 (ref null $ListBase))
    (local $w270 i32)
    (local $x_1 i32)
    (local $w273 (ref null $ListBase))
    (local $w276 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w268
    ref.null $ListBase
    local.set $w269
    i32.const 0
    local.set $w270
    block $while_271_exit
      loop $while_271_lp
        local.get $w268
        ref.is_null
        i32.eqz
        if
          local.get $w268
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $w270
          local.get $x_1
          i32.mul
          local.get $w269
          struct.new $ListCons_30
          local.set $w269
          local.get $w270
          i32.const 1
          i32.add
          local.set $w270
          local.get $w268
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w268
          br $while_271_lp
        else
          br $while_271_exit
        end
      end
    end
    local.get $w269
    local.set $w272
    ref.null $ListBase
    local.set $w273
    block $while_274_exit
      loop $while_274_lp
        local.get $w272
        ref.is_null
        i32.eqz
        if
          local.get $w272
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w273
          struct.new $ListCons_30
          local.set $w273
          local.get $w272
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w272
          br $while_274_lp
        else
          br $while_274_exit
        end
      end
    end
    local.get $w273
    local.set $w275
    i32.const 0
    local.set $w276
    block $while_277_exit
      loop $while_277_lp
        local.get $w275
        ref.is_null
        i32.eqz
        if
          local.get $w275
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w276
          local.get $y
          i32.add
          local.set $w276
          local.get $w275
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w275
          br $while_277_lp
        else
          br $while_277_exit
        end
      end
    end
    local.get $w276
  )
  (func $closure_126 (param $self (ref $AnyFn)) (param $i i32) (param $x i32)
    (local $self_cast (ref $ClosureType_126))
    (local $s i32)
    local.get $self
    ref.cast (ref $ClosureType_126)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_126 1
    local.set $s
    local.get $s
    local.get $i
    local.get $x
    i32.mul
    i32.add
    local.set $s
  )
  (func $testListIteri (result i32) ;; exported as "testListIteri"
    (local $s i32)
    (local $w279 (ref null $ListBase))
    (local $w280 i32)
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
    local.set $w279
    i32.const 0
    local.set $w280
    block $while_281_exit
      loop $while_281_lp
        local.get $w279
        ref.is_null
        i32.eqz
        if
          local.get $w279
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $s
          local.get $w280
          local.get $x
          i32.mul
          i32.add
          local.set $s
          local.get $w280
          i32.const 1
          i32.add
          local.set $w280
          local.get $w279
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w279
          br $while_281_lp
        else
          br $while_281_exit
        end
      end
    end
    local.get $s
  )
  (func $closure_127 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $testListCollect (result i32) ;; exported as "testListCollect"
    (local $w295 (ref null $ListBase))
    (local $w283 (ref null $ListBase))
    (local $w284 (ref null $ListBase))
    (local $w285 (ref null $ListBase))
    (local $x i32)
    (local $w289 (ref null $ListBase))
    (local $w286 (ref null $ListBase))
    (local $w287 (ref null $ListBase))
    (local $w291 (ref null $ListBase))
    (local $w292 (ref null $ListBase))
    (local $w296 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w283
    ref.null $ListBase
    local.set $w284
    block $while_290_exit
      loop $while_290_lp
        local.get $w283
        ref.is_null
        i32.eqz
        if
          local.get $w283
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
          local.set $w285
          local.get $w285
          local.set $w286
          local.get $w284
          local.set $w287
          block $while_288_exit
            loop $while_288_lp
              local.get $w286
              ref.is_null
              i32.eqz
              if
                local.get $w286
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w287
                struct.new $ListCons_30
                local.set $w287
                local.get $w286
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w286
                br $while_288_lp
              else
                br $while_288_exit
              end
            end
          end
          local.get $w287
          local.set $w289
          local.get $w289
          local.set $w284
          local.get $w283
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w283
          br $while_290_lp
        else
          br $while_290_exit
        end
      end
    end
    local.get $w284
    local.set $w291
    ref.null $ListBase
    local.set $w292
    block $while_293_exit
      loop $while_293_lp
        local.get $w291
        ref.is_null
        i32.eqz
        if
          local.get $w291
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w292
          struct.new $ListCons_30
          local.set $w292
          local.get $w291
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w291
          br $while_293_lp
        else
          br $while_293_exit
        end
      end
    end
    local.get $w292
    local.set $w295
    i32.const 0
    local.set $w296
    block $while_297_exit
      loop $while_297_lp
        local.get $w295
        ref.is_null
        i32.eqz
        if
          local.get $w296
          i32.const 1
          i32.add
          local.set $w296
          local.get $w295
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w295
          br $while_297_lp
        else
          br $while_297_exit
        end
      end
    end
    local.get $w296
  )
  (func $closure_130 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_131 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $closure_132 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $ListBase))
    local.get $x_1
    local.get $x_1
    i32.const 1
    i32.shl
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $testListCollectOrder (result i32) ;; exported as "testListCollectOrder"
    (local $w323 (ref null $ListBase))
    (local $w312 (ref null $ListBase))
    (local $w313 (ref null $ListBase))
    (local $w314 (ref null $ListBase))
    (local $x_1 i32)
    (local $w318 (ref null $ListBase))
    (local $w315 (ref null $ListBase))
    (local $w316 (ref null $ListBase))
    (local $w320 (ref null $ListBase))
    (local $w321 (ref null $ListBase))
    (local $w324 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w312
    ref.null $ListBase
    local.set $w313
    block $while_319_exit
      loop $while_319_lp
        local.get $w312
        ref.is_null
        i32.eqz
        if
          local.get $w312
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
          local.set $w314
          local.get $w314
          local.set $w315
          local.get $w313
          local.set $w316
          block $while_317_exit
            loop $while_317_lp
              local.get $w315
              ref.is_null
              i32.eqz
              if
                local.get $w315
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w316
                struct.new $ListCons_30
                local.set $w316
                local.get $w315
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w315
                br $while_317_lp
              else
                br $while_317_exit
              end
            end
          end
          local.get $w316
          local.set $w318
          local.get $w318
          local.set $w313
          local.get $w312
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w312
          br $while_319_lp
        else
          br $while_319_exit
        end
      end
    end
    local.get $w313
    local.set $w320
    ref.null $ListBase
    local.set $w321
    block $while_322_exit
      loop $while_322_lp
        local.get $w320
        ref.is_null
        i32.eqz
        if
          local.get $w320
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w321
          struct.new $ListCons_30
          local.set $w321
          local.get $w320
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w320
          br $while_322_lp
        else
          br $while_322_exit
        end
      end
    end
    local.get $w321
    local.set $w323
    i32.const 0
    local.set $w324
    block $while_325_exit
      loop $while_325_lp
        local.get $w323
        ref.is_null
        i32.eqz
        if
          local.get $w323
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w324
          local.get $y
          i32.add
          local.set $w324
          local.get $w323
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w323
          br $while_325_lp
        else
          br $while_325_exit
        end
      end
    end
    local.get $w324
  )
  (func $closure_133 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_12))
    local.get $x
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_12))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $testListChoose (result i32) ;; exported as "testListChoose"
    (local $w334 (ref null $ListBase))
    (local $w330 (ref null $ListBase))
    (local $w327 (ref null $ListBase))
    (local $w328 (ref null $ListBase))
    (local $cho_326_opt (ref null $Option_12))
    (local $x i32)
    (local $w331 (ref null $ListBase))
    (local $w335 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w327
    ref.null $ListBase
    local.set $w328
    block $while_329_exit
      loop $while_329_lp
        local.get $w327
        ref.is_null
        i32.eqz
        if
          local.get $w327
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_12))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_12
          else
            ref.null $Option_12
          end
          local.set $cho_326_opt
          local.get $cho_326_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_326_opt
            ref.cast (ref $Option_12)
            struct.get $Option_12 0
            local.get $w328
            struct.new $ListCons_30
          else
            local.get $w328
          end
          local.set $w328
          local.get $w327
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w327
          br $while_329_lp
        else
          br $while_329_exit
        end
      end
    end
    local.get $w328
    local.set $w330
    ref.null $ListBase
    local.set $w331
    block $while_332_exit
      loop $while_332_lp
        local.get $w330
        ref.is_null
        i32.eqz
        if
          local.get $w330
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w331
          struct.new $ListCons_30
          local.set $w331
          local.get $w330
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w330
          br $while_332_lp
        else
          br $while_332_exit
        end
      end
    end
    local.get $w331
    local.set $w334
    i32.const 0
    local.set $w335
    block $while_336_exit
      loop $while_336_lp
        local.get $w334
        ref.is_null
        i32.eqz
        if
          local.get $w335
          i32.const 1
          i32.add
          local.set $w335
          local.get $w334
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w334
          br $while_336_lp
        else
          br $while_336_exit
        end
      end
    end
    local.get $w335
  )
  (func $closure_134 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $closure_135 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_12))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_12))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $closure_136 (param $self (ref $AnyFn)) (param $x_1 i32) (result (ref null $Option_12))
    local.get $x_1
    i32.const 2
    i32.gt_s
    if (result (ref null $Option_12))
      local.get $x_1
      i32.const 10
      i32.mul
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $testListChooseSum (result i32) ;; exported as "testListChooseSum"
    (local $w352 (ref null $ListBase))
    (local $w349 (ref null $ListBase))
    (local $w346 (ref null $ListBase))
    (local $w347 (ref null $ListBase))
    (local $cho_345_opt (ref null $Option_12))
    (local $x_1 i32)
    (local $w350 (ref null $ListBase))
    (local $w353 i32)
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
    local.set $w346
    ref.null $ListBase
    local.set $w347
    block $while_348_exit
      loop $while_348_lp
        local.get $w346
        ref.is_null
        i32.eqz
        if
          local.get $w346
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x_1
          local.get $x_1
          i32.const 2
          i32.gt_s
          if (result (ref null $Option_12))
            local.get $x_1
            i32.const 10
            i32.mul
            struct.new $Option_12
          else
            ref.null $Option_12
          end
          local.set $cho_345_opt
          local.get $cho_345_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_345_opt
            ref.cast (ref $Option_12)
            struct.get $Option_12 0
            local.get $w347
            struct.new $ListCons_30
          else
            local.get $w347
          end
          local.set $w347
          local.get $w346
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w346
          br $while_348_lp
        else
          br $while_348_exit
        end
      end
    end
    local.get $w347
    local.set $w349
    ref.null $ListBase
    local.set $w350
    block $while_351_exit
      loop $while_351_lp
        local.get $w349
        ref.is_null
        i32.eqz
        if
          local.get $w349
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w350
          struct.new $ListCons_30
          local.set $w350
          local.get $w349
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w349
          br $while_351_lp
        else
          br $while_351_exit
        end
      end
    end
    local.get $w350
    local.set $w352
    i32.const 0
    local.set $w353
    block $while_354_exit
      loop $while_354_lp
        local.get $w352
        ref.is_null
        i32.eqz
        if
          local.get $w352
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $y
          local.get $w353
          local.get $y
          i32.add
          local.set $w353
          local.get $w352
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w352
          br $while_354_lp
        else
          br $while_354_exit
        end
      end
    end
    local.get $w353
  )
  (func $closure_137 (param $self (ref $AnyFn)) (param $x i32) (param $acc (ref null $ListBase)) (result (ref null $ListBase))
    local.get $x
    local.get $acc
    struct.new $ListCons_30
  )
  (func $testListFoldBack (result i32) ;; exported as "testListFoldBack"
    (local $w363 (ref null $ListBase))
    (local $w359 (ref null $ListBase))
    (local $w356 (ref null $ListBase))
    (local $w357 (ref null $ListBase))
    (local $w360 (ref null $ListBase))
    (local $x i32)
    (local $w364 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w356
    ref.null $ListBase
    local.set $w357
    block $while_358_exit
      loop $while_358_lp
        local.get $w356
        ref.is_null
        i32.eqz
        if
          local.get $w356
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w357
          struct.new $ListCons_30
          local.set $w357
          local.get $w356
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w356
          br $while_358_lp
        else
          br $while_358_exit
        end
      end
    end
    local.get $w357
    local.set $w359
    ref.null $ListBase
    local.set $w360
    block $while_361_exit
      loop $while_361_lp
        local.get $w359
        ref.is_null
        i32.eqz
        if
          local.get $w359
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w360
          struct.new $ListCons_30
          local.set $w360
          local.get $w359
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w359
          br $while_361_lp
        else
          br $while_361_exit
        end
      end
    end
    local.get $w360
    local.set $w363
    i32.const 0
    local.set $w364
    block $while_365_exit
      loop $while_365_lp
        local.get $w363
        ref.is_null
        i32.eqz
        if
          local.get $w364
          i32.const 1
          i32.add
          local.set $w364
          local.get $w363
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w363
          br $while_365_lp
        else
          br $while_365_exit
        end
      end
    end
    local.get $w364
  )
  (func $closure_140 (param $self (ref $AnyFn)) (param $x i32) (param $acc i32) (result i32)
    local.get $x
    local.get $acc
    i32.sub
  )
  (func $testListFoldBackOrder (result i32) ;; exported as "testListFoldBackOrder"
    (local $w370 (ref null $ListBase))
    (local $w367 (ref null $ListBase))
    (local $w368 (ref null $ListBase))
    (local $w371 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w367
    ref.null $ListBase
    local.set $w368
    block $while_369_exit
      loop $while_369_lp
        local.get $w367
        ref.is_null
        i32.eqz
        if
          local.get $w367
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w368
          struct.new $ListCons_30
          local.set $w368
          local.get $w367
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w367
          br $while_369_lp
        else
          br $while_369_exit
        end
      end
    end
    local.get $w368
    local.set $w370
    i32.const 0
    local.set $w371
    block $while_372_exit
      loop $while_372_lp
        local.get $w370
        ref.is_null
        i32.eqz
        if
          local.get $w370
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $w371
          i32.sub
          local.set $w371
          local.get $w370
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w370
          br $while_372_lp
        else
          br $while_372_exit
        end
      end
    end
    local.get $w371
  )
  (func $closure_141 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    local.get $x
    i32.mul
  )
  (func $closure_142 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListSumBy (result i32) ;; exported as "testListSumBy"
    (local $w374 (ref null $ListBase))
    (local $w375 i32)
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
    local.set $w374
    i32.const 0
    local.set $w375
    block $while_376_exit
      loop $while_376_lp
        local.get $w374
        ref.is_null
        i32.eqz
        if
          local.get $w375
          local.get $w374
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $x
          i32.mul
          i32.add
          local.set $w375
          local.get $w374
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w374
          br $while_376_lp
        else
          br $while_376_exit
        end
      end
    end
    local.get $w375
  )
  (func $closure_143 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_144 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w378 (ref null $ListBase))
    (local $w379 (ref $ListCons_30))
    (local $w380 i32)
    (local $w381 i32)
    (local $x i32)
    (local $w382 (ref null $ListBase))
    (local $w383 i32)
    (local $w384 i32)
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
    local.set $w378
    local.get $w378
    ref.cast (ref $ListCons_30)
    local.set $w379
    local.get $w379
    struct.get $ListCons_30 0
    local.set $w380
    local.get $w379
    struct.get $ListCons_30 0
    local.set $x
    local.get $x
    i32.const 3
    i32.rem_s
    local.set $w381
    local.get $w379
    struct.get $ListCons_30 1
    local.set $w382
    block $while_385_exit
      loop $while_385_lp
        local.get $w382
        ref.is_null
        i32.eqz
        if
          local.get $w382
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w383
          local.get $w383
          i32.const 3
          i32.rem_s
          local.set $w384
          local.get $w384
          local.get $w381
          i32.lt_s
          if
            local.get $w383
            local.set $w380
            local.get $w384
            local.set $w381
          end
          local.get $w382
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w382
          br $while_385_lp
        else
          br $while_385_exit
        end
      end
    end
    local.get $w380
  )
  (func $closure_145 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 5
    i32.rem_s
  )
  (func $closure_146 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w387 (ref null $ListBase))
    (local $w388 (ref $ListCons_30))
    (local $w389 i32)
    (local $w390 i32)
    (local $x i32)
    (local $w391 (ref null $ListBase))
    (local $w392 i32)
    (local $w393 i32)
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
    local.set $w387
    local.get $w387
    ref.cast (ref $ListCons_30)
    local.set $w388
    local.get $w388
    struct.get $ListCons_30 0
    local.set $w389
    local.get $w388
    struct.get $ListCons_30 0
    local.set $x
    local.get $x
    i32.const 5
    i32.rem_s
    local.set $w390
    local.get $w388
    struct.get $ListCons_30 1
    local.set $w391
    block $while_394_exit
      loop $while_394_lp
        local.get $w391
        ref.is_null
        i32.eqz
        if
          local.get $w391
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w392
          local.get $w392
          i32.const 5
          i32.rem_s
          local.set $w393
          local.get $w393
          local.get $w390
          i32.gt_s
          if
            local.get $w392
            local.set $w389
            local.get $w393
            local.set $w390
          end
          local.get $w391
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w391
          br $while_394_lp
        else
          br $while_394_exit
        end
      end
    end
    local.get $w389
  )
  (func $closure_147 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w396 (ref null $ListBase))
    (local $w397 (ref $ListCons_30))
    (local $w398 i32)
    (local $w399 (ref null $ListBase))
    (local $w400 i32)
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
    local.set $w396
    local.get $w396
    ref.cast (ref $ListCons_30)
    local.set $w397
    local.get $w397
    struct.get $ListCons_30 0
    local.set $w398
    local.get $w397
    struct.get $ListCons_30 1
    local.set $w399
    block $while_401_exit
      loop $while_401_lp
        local.get $w399
        ref.is_null
        i32.eqz
        if
          local.get $w399
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w400
          local.get $w400
          local.get $w398
          i32.lt_s
          if
            local.get $w400
            local.set $w398
          end
          local.get $w399
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w399
          br $while_401_lp
        else
          br $while_401_exit
        end
      end
    end
    local.get $w398
  )
  (func $closure_148 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w403 (ref null $ListBase))
    (local $w404 (ref $ListCons_30))
    (local $w405 i32)
    (local $w406 (ref null $ListBase))
    (local $w407 i32)
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
    local.set $w403
    local.get $w403
    ref.cast (ref $ListCons_30)
    local.set $w404
    local.get $w404
    struct.get $ListCons_30 0
    local.set $w405
    local.get $w404
    struct.get $ListCons_30 1
    local.set $w406
    block $while_408_exit
      loop $while_408_lp
        local.get $w406
        ref.is_null
        i32.eqz
        if
          local.get $w406
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w407
          local.get $w407
          local.get $w405
          i32.gt_s
          if
            local.get $w407
            local.set $w405
          end
          local.get $w406
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w406
          br $while_408_lp
        else
          br $while_408_exit
        end
      end
    end
    local.get $w405
  )
  (func $closure_149 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContains (result i32) ;; exported as "testListContains"
    (local $w411 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w411
    block $lcont_409_exit (result i32)
      block $lcont_409_lp_exit
        loop $lcont_409_lp
          local.get $w411
          ref.is_null
          i32.eqz
          if
            local.get $w411
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            i32.const 3
            i32.eq
            if
              i32.const 1
              br $lcont_409_exit
            end
            local.get $w411
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w411
          else
            br $lcont_409_lp_exit
          end
          br $lcont_409_lp
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
  (func $closure_150 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testListContainsFalse (result i32) ;; exported as "testListContainsFalse"
    (local $w414 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w414
    block $lcont_412_exit (result i32)
      block $lcont_412_lp_exit
        loop $lcont_412_lp
          local.get $w414
          ref.is_null
          i32.eqz
          if
            local.get $w414
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            i32.const 9
            i32.eq
            if
              i32.const 1
              br $lcont_412_exit
            end
            local.get $w414
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w414
          else
            br $lcont_412_lp_exit
          end
          br $lcont_412_lp
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
  (func $closure_151 (param $self (ref $AnyFn)) (param $_arg i32) (result i32)
    i32.const 1
  )
  (func $testListInit (result i32) ;; exported as "testListInit"
    (local $w420 (ref null $ListBase))
    (local $w416 i32)
    (local $w417 (ref null $ListBase))
    (local $w421 i32)
    i32.const 4
    local.set $w416
    ref.null $ListBase
    local.set $w417
    block $while_418_exit
      loop $while_418_lp
        local.get $w416
        i32.const 0
        i32.ge_s
        if
          i32.const 1
          local.get $w417
          struct.new $ListCons_30
          local.set $w417
          local.get $w416
          i32.const 1
          i32.sub
          local.set $w416
          br $while_418_lp
        else
          br $while_418_exit
        end
      end
    end
    local.get $w417
    local.set $w420
    i32.const 0
    local.set $w421
    block $while_422_exit
      loop $while_422_lp
        local.get $w420
        ref.is_null
        i32.eqz
        if
          local.get $w421
          i32.const 1
          i32.add
          local.set $w421
          local.get $w420
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w420
          br $while_422_lp
        else
          br $while_422_exit
        end
      end
    end
    local.get $w421
  )
  (func $testListReplicate (result i32) ;; exported as "testListReplicate"
    (local $w426 i32)
    (local $w427 (ref null $ListBase))
    i32.const 0
    local.set $w426
    ref.null $ListBase
    local.set $w427
    block $while_428_exit
      loop $while_428_lp
        local.get $w426
        i32.const 4
        i32.lt_s
        if
          i32.const 7
          local.get $w427
          struct.new $ListCons_30
          local.set $w427
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
    local.get $w427
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListTake (result i32) ;; exported as "testListTake"
    (local $w438 i32)
    (local $w439 (ref null $ListBase))
    (local $w434 (ref null $ListBase))
    (local $w430 i32)
    (local $w431 (ref null $ListBase))
    (local $w432 (ref null $ListBase))
    (local $w435 (ref null $ListBase))
    i32.const 2
    local.set $w438
    i32.const 3
    local.set $w430
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
    local.set $w431
    ref.null $ListBase
    local.set $w432
    block $while_433_exit
      loop $while_433_lp
        local.get $w430
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w431
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w431
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w432
          struct.new $ListCons_30
          local.set $w432
          local.get $w431
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w431
          local.get $w430
          i32.const 1
          i32.sub
          local.set $w430
          br $while_433_lp
        else
          br $while_433_exit
        end
      end
    end
    local.get $w432
    local.set $w434
    ref.null $ListBase
    local.set $w435
    block $while_436_exit
      loop $while_436_lp
        local.get $w434
        ref.is_null
        i32.eqz
        if
          local.get $w434
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w435
          struct.new $ListCons_30
          local.set $w435
          local.get $w434
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w434
          br $while_436_lp
        else
          br $while_436_exit
        end
      end
    end
    local.get $w435
    local.set $w439
    block $while_440_exit
      loop $while_440_lp
        local.get $w438
        i32.const 0
        i32.gt_s
        if
          local.get $w439
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w439
          local.get $w438
          i32.const 1
          i32.sub
          local.set $w438
          br $while_440_lp
        else
          br $while_440_exit
        end
      end
    end
    local.get $w439
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testListSkip (result i32) ;; exported as "testListSkip"
    (local $w442 i32)
    (local $w443 (ref null $ListBase))
    i32.const 2
    local.set $w442
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
    local.set $w443
    block $while_444_exit
      loop $while_444_lp
        local.get $w442
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w443
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w443
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w443
          local.get $w442
          i32.const 1
          i32.sub
          local.set $w442
          br $while_444_lp
        else
          br $while_444_exit
        end
      end
    end
    local.get $w443
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_152 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w446 (ref null $ListBase))
    (local $w450 i32)
    (local $w447 (ref null $ListBase))
    (local $w448 i32)
    (local $w451 (ref $GcArray_41))
    (local $w452 (ref null $ListBase))
    (local $w453 i32)
    (local $w455 i32)
    (local $w456 i32)
    (local $w457 i32)
    (local $w460 i32)
    (local $w461 (ref null $ListBase))
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
    local.set $w446
    local.get $w446
    local.set $w447
    i32.const 0
    local.set $w448
    block $while_449_exit
      loop $while_449_lp
        local.get $w447
        ref.is_null
        i32.eqz
        if
          local.get $w448
          i32.const 1
          i32.add
          local.set $w448
          local.get $w447
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w447
          br $while_449_lp
        else
          br $while_449_exit
        end
      end
    end
    local.get $w448
    local.set $w450
    i32.const 0
    local.get $w450
    array.new $GcArray_41
    local.set $w451
    local.get $w446
    local.set $w452
    i32.const 0
    local.set $w453
    block $while_454_exit
      loop $while_454_lp
        local.get $w452
        ref.is_null
        i32.eqz
        if
          local.get $w451
          local.get $w453
          local.get $w452
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_41
          local.get $w453
          i32.const 1
          i32.add
          local.set $w453
          local.get $w452
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w452
          br $while_454_lp
        else
          br $while_454_exit
        end
      end
    end
    local.get $w453
    drop
    i32.const 1
    local.set $w455
    block $while_459_exit
      loop $while_459_lp
        local.get $w455
        local.get $w450
        i32.lt_s
        if
          local.get $w451
          local.get $w455
          array.get $GcArray_41
          local.set $w456
          local.get $w455
          i32.const 1
          i32.sub
          local.set $w457
          block $while_458_exit
            loop $while_458_lp
              local.get $w457
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w451
                local.get $w457
                array.get $GcArray_41
                local.get $w456
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
                local.get $w451
                local.get $w457
                i32.const 1
                i32.add
                local.get $w451
                local.get $w457
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w457
                i32.const 1
                i32.sub
                local.set $w457
                br $while_458_lp
              else
                br $while_458_exit
              end
            end
          end
          local.get $w451
          local.get $w457
          i32.const 1
          i32.add
          local.get $w456
          array.set $GcArray_41
          local.get $w455
          i32.const 1
          i32.add
          local.set $w455
          br $while_459_lp
        else
          br $while_459_exit
        end
      end
    end
    local.get $w450
    i32.const 1
    i32.sub
    local.set $w460
    ref.null $ListBase
    local.set $w461
    block $while_462_exit
      loop $while_462_lp
        local.get $w460
        i32.const 0
        i32.ge_s
        if
          local.get $w451
          local.get $w460
          array.get $GcArray_41
          local.get $w461
          struct.new $ListCons_30
          local.set $w461
          local.get $w460
          i32.const 1
          i32.sub
          local.set $w460
          br $while_462_lp
        else
          br $while_462_exit
        end
      end
    end
    local.get $w461
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_153 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $testArrayScan (result i32) ;; exported as "testArrayScan"
    (local $r (ref $GcArray_41))
    (local $w464 (ref $GcArray_41))
    (local $w465 (ref $GcArray_41))
    (local $w466 i32)
    (local $w468 i32)
    (local $w469 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_41 4
    local.set $w464
    i32.const 0
    local.get $w464
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_41
    local.set $w465
    i32.const 0
    local.set $w466
    local.get $w465
    i32.const 0
    local.get $w466
    array.set $GcArray_41
    local.get $w464
    array.len
    local.set $w468
    i32.const 0
    local.set $w469
    block $while_470_exit
      loop $while_470_lp
        local.get $w469
        local.get $w468
        i32.lt_s
        if
          local.get $w464
          local.get $w469
          array.get $GcArray_41
          local.set $y
          local.get $w466
          local.get $y
          i32.add
          local.set $w466
          local.get $w465
          local.get $w469
          i32.const 1
          i32.add
          local.get $w466
          array.set $GcArray_41
          local.get $w469
          i32.const 1
          i32.add
          local.set $w469
          br $while_470_lp
        else
          br $while_470_exit
        end
      end
    end
    local.get $w465
    local.set $r
    local.get $r
    local.get $r
    array.len
    i32.const 1
    i32.sub
    array.get $GcArray_41
  )
  (func $closure_154 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $testArrayScanLen (result i32) ;; exported as "testArrayScanLen"
    (local $w472 (ref $GcArray_41))
    (local $w473 (ref $GcArray_41))
    (local $w474 i32)
    (local $w476 i32)
    (local $w477 i32)
    (local $y i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    array.new_fixed $GcArray_41 4
    local.set $w472
    i32.const 0
    local.get $w472
    array.len
    i32.const 1
    i32.add
    array.new $GcArray_41
    local.set $w473
    i32.const 0
    local.set $w474
    local.get $w473
    i32.const 0
    local.get $w474
    array.set $GcArray_41
    local.get $w472
    array.len
    local.set $w476
    i32.const 0
    local.set $w477
    block $while_478_exit
      loop $while_478_lp
        local.get $w477
        local.get $w476
        i32.lt_s
        if
          local.get $w472
          local.get $w477
          array.get $GcArray_41
          local.set $y
          local.get $w474
          local.get $y
          i32.add
          local.set $w474
          local.get $w473
          local.get $w477
          i32.const 1
          i32.add
          local.get $w474
          array.set $GcArray_41
          local.get $w477
          i32.const 1
          i32.add
          local.set $w477
          br $while_478_lp
        else
          br $while_478_exit
        end
      end
    end
    local.get $w473
    array.len
  )
  (func $testArrayAppend (result i32) ;; exported as "testArrayAppend"
    (local $w480 (ref $GcArray_41))
    (local $w481 (ref $GcArray_41))
    (local $w482 i32)
    (local $w483 (ref $GcArray_41))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w480
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 2
    local.set $w481
    local.get $w480
    array.len
    local.set $w482
    i32.const 0
    local.get $w482
    local.get $w481
    array.len
    i32.add
    array.new $GcArray_41
    local.set $w483
    local.get $w483
    i32.const 0
    local.get $w480
    i32.const 0
    local.get $w482
    array.copy $GcArray_41 $GcArray_41
    local.get $w483
    local.get $w482
    local.get $w481
    i32.const 0
    local.get $w481
    array.len
    array.copy $GcArray_41 $GcArray_41
    local.get $w483
    i32.const 3
    array.get $GcArray_41
  )
  (func $testArrayAppendLen (result i32) ;; exported as "testArrayAppendLen"
    (local $w485 (ref $GcArray_41))
    (local $w486 (ref $GcArray_41))
    (local $w487 i32)
    (local $w488 (ref $GcArray_41))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w485
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 2
    local.set $w486
    local.get $w485
    array.len
    local.set $w487
    i32.const 0
    local.get $w487
    local.get $w486
    array.len
    i32.add
    array.new $GcArray_41
    local.set $w488
    local.get $w488
    i32.const 0
    local.get $w485
    i32.const 0
    local.get $w487
    array.copy $GcArray_41 $GcArray_41
    local.get $w488
    local.get $w487
    local.get $w486
    i32.const 0
    local.get $w486
    array.len
    array.copy $GcArray_41 $GcArray_41
    local.get $w488
    array.len
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
  (func $closure_155 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testListFindIndex (result i32) ;; exported as "testListFindIndex"
    (local $w490 (ref null $ListBase))
    (local $w491 i32)
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
    local.set $w490
    i32.const 0
    local.set $w491
    block $fdi_489_exit (result i32)
      loop $fdi_489_lp
        local.get $w490
        ref.is_null
        i32.eqz
        if
          local.get $w490
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if
            local.get $w491
            br $fdi_489_exit
          else
            local.get $w491
            i32.const 1
            i32.add
            local.set $w491
            local.get $w490
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w490
            br $fdi_489_lp
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_156 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testListTryFindIndex (result i32) ;; exported as "testListTryFindIndex"
    (local $matchValue (ref null $Option_12))
    (local $w493 (ref null $ListBase))
    (local $w494 i32)
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w493
    i32.const 0
    local.set $w494
    block $fdi_492_exit (result (ref null $Option_12))
      loop $fdi_492_lp
        local.get $w493
        ref.is_null
        i32.eqz
        if
          local.get $w493
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 10
          i32.gt_s
          if
            local.get $w494
            struct.new $Option_12
            br $fdi_492_exit
          else
            local.get $w494
            i32.const 1
            i32.add
            local.set $w494
            local.get $w493
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w493
            br $fdi_492_lp
          end
        end
      end
      ref.null $Option_12
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $matchValue
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $testOptionValue (result i32) ;; exported as "testOptionValue"
    (local $w495 (ref null $Option_12))
    i32.const 42
    struct.new $Option_12
    local.set $w495
    local.get $w495
    ref.cast (ref $Option_12)
    struct.get $Option_12 0
  )
  (func $closure_157 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_158 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testOptionMapValue (result i32) ;; exported as "testOptionMapValue"
    (local $w498 (ref null $Option_12))
    (local $w497 (ref null $Option_12))
    (local $x i32)
    i32.const 42
    struct.new $Option_12
    local.set $w497
    local.get $w497
    ref.is_null
    if (result (ref null $Option_12))
      local.get $w497
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
      local.set $x
      local.get $x
      i32.const 1
      i32.shl
      struct.new $Option_12
    else
      ref.null $Option_12
    end
    local.set $w498
    local.get $w498
    ref.cast (ref $Option_12)
    struct.get $Option_12 0
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
  (func $closure_165 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $testResultMap (result i32) ;; exported as "testResultMap"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w499 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 21
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w499
    local.get $w499
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w499
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      local.get $x
      i32.const 1
      i32.shl
    else
      local.get $w499
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
  (func $closure_166 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBind (result i32) ;; exported as "testResultBind"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w500 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 0
    i32.const 5
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.set $w500
    local.get $w500
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w500
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w500
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
  (func $closure_169 (param $self (ref $AnyFn)) (param $x i32) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    i32.const 0
    local.get $x
    i32.const 1
    i32.add
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
  )
  (func $testResultBindError (result i32) ;; exported as "testResultBindError"
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $w501 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
    (local $x i32)
    i32.const 1
    i32.const -99
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    local.set $w501
    local.get $w501
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      local.get $w501
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      local.set $x
      i32.const 0
      local.get $x
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    else
      local.get $w501
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
  (func $testListItem (result i32) ;; exported as "testListItem"
    (local $w503 i32)
    (local $w504 (ref null $ListBase))
    i32.const 2
    local.set $w503
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
    local.set $w504
    block $while_505_exit
      loop $while_505_lp
        local.get $w503
        i32.const 0
        i32.gt_s
        if
          local.get $w504
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w504
          local.get $w503
          i32.const 1
          i32.sub
          local.set $w503
          br $while_505_lp
        else
          br $while_505_exit
        end
      end
    end
    local.get $w504
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
    (local $w507 (ref null $ListBase))
    (local $w508 i32)
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w507
    i32.const 0
    local.set $w508
    block $while_509_exit
      loop $while_509_lp
        local.get $w507
        ref.is_null
        i32.eqz
        if
          local.get $w508
          i32.const 1
          i32.add
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
  )
  (func $closure_170 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add
  )
  (func $testListReduce (result i32) ;; exported as "testListReduce"
    (local $w510 (ref null $ListBase))
    (local $w511 (ref $ListCons_30))
    (local $w513 (ref null $ListBase))
    (local $w514 i32)
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
    local.set $w510
    local.get $w510
    ref.cast (ref $ListCons_30)
    local.set $w511
    local.get $w511
    struct.get $ListCons_30 1
    local.set $w513
    local.get $w511
    struct.get $ListCons_30 0
    local.set $w514
    block $while_515_exit
      loop $while_515_lp
        local.get $w513
        ref.is_null
        i32.eqz
        if
          local.get $w513
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $w514
          local.get $b
          i32.add
          local.set $w514
          local.get $w513
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w513
          br $while_515_lp
        else
          br $while_515_exit
        end
      end
    end
    local.get $w514
  )
  (func $closure_171 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.gt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end
  )
  (func $testListReduceMax (result i32) ;; exported as "testListReduceMax"
    (local $w516 (ref null $ListBase))
    (local $w517 (ref $ListCons_30))
    (local $w519 (ref null $ListBase))
    (local $w520 i32)
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
    local.set $w516
    local.get $w516
    ref.cast (ref $ListCons_30)
    local.set $w517
    local.get $w517
    struct.get $ListCons_30 1
    local.set $w519
    local.get $w517
    struct.get $ListCons_30 0
    local.set $w520
    block $while_521_exit
      loop $while_521_lp
        local.get $w519
        ref.is_null
        i32.eqz
        if
          local.get $w519
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $w520
          local.get $b
          i32.gt_s
          if (result i32)
            local.get $w520
          else
            local.get $b
          end
          local.set $w520
          local.get $w519
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w519
          br $while_521_lp
        else
          br $while_521_exit
        end
      end
    end
    local.get $w520
  )
  (func $testListLast (result i32) ;; exported as "testListLast"
    (local $w523 (ref null $ListBase))
    (local $w524 (ref $ListCons_30))
    (local $w525 i32)
    (local $w526 (ref null $ListBase))
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
    local.set $w523
    local.get $w523
    ref.cast (ref $ListCons_30)
    local.set $w524
    local.get $w524
    struct.get $ListCons_30 0
    local.set $w525
    local.get $w524
    struct.get $ListCons_30 1
    local.set $w526
    block $while_527_exit
      loop $while_527_lp
        local.get $w526
        ref.is_null
        i32.eqz
        if
          local.get $w526
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w525
          local.get $w526
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w526
          br $while_527_lp
        else
          br $while_527_exit
        end
      end
    end
    local.get $w525
  )
  (func $testListLastSingle (result i32) ;; exported as "testListLastSingle"
    (local $w529 (ref null $ListBase))
    (local $w530 (ref $ListCons_30))
    (local $w531 i32)
    (local $w532 (ref null $ListBase))
    i32.const 42
    ref.null $ListBase
    struct.new $ListCons_30
    local.set $w529
    local.get $w529
    ref.cast (ref $ListCons_30)
    local.set $w530
    local.get $w530
    struct.get $ListCons_30 0
    local.set $w531
    local.get $w530
    struct.get $ListCons_30 1
    local.set $w532
    block $while_533_exit
      loop $while_533_lp
        local.get $w532
        ref.is_null
        i32.eqz
        if
          local.get $w532
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w531
          local.get $w532
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w532
          br $while_533_lp
        else
          br $while_533_exit
        end
      end
    end
    local.get $w531
  )
  (func $closure_172 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $w535 (ref null $ListBase))
    (local $w539 i32)
    (local $w536 (ref null $ListBase))
    (local $w537 i32)
    (local $w540 (ref $GcArray_41))
    (local $w541 (ref null $ListBase))
    (local $w542 i32)
    (local $w544 i32)
    (local $w545 i32)
    (local $w546 i32)
    (local $w549 i32)
    (local $w550 (ref null $ListBase))
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
    local.set $w535
    local.get $w535
    local.set $w536
    i32.const 0
    local.set $w537
    block $while_538_exit
      loop $while_538_lp
        local.get $w536
        ref.is_null
        i32.eqz
        if
          local.get $w537
          i32.const 1
          i32.add
          local.set $w537
          local.get $w536
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w536
          br $while_538_lp
        else
          br $while_538_exit
        end
      end
    end
    local.get $w537
    local.set $w539
    i32.const 0
    local.get $w539
    array.new $GcArray_41
    local.set $w540
    local.get $w535
    local.set $w541
    i32.const 0
    local.set $w542
    block $while_543_exit
      loop $while_543_lp
        local.get $w541
        ref.is_null
        i32.eqz
        if
          local.get $w540
          local.get $w542
          local.get $w541
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_41
          local.get $w542
          i32.const 1
          i32.add
          local.set $w542
          local.get $w541
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w541
          br $while_543_lp
        else
          br $while_543_exit
        end
      end
    end
    local.get $w542
    drop
    i32.const 1
    local.set $w544
    block $while_548_exit
      loop $while_548_lp
        local.get $w544
        local.get $w539
        i32.lt_s
        if
          local.get $w540
          local.get $w544
          array.get $GcArray_41
          local.set $w545
          local.get $w544
          i32.const 1
          i32.sub
          local.set $w546
          block $while_547_exit
            loop $while_547_lp
              local.get $w546
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w540
                local.get $w546
                array.get $GcArray_41
                local.get $w545
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
                local.get $w540
                local.get $w546
                i32.const 1
                i32.add
                local.get $w540
                local.get $w546
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w546
                i32.const 1
                i32.sub
                local.set $w546
                br $while_547_lp
              else
                br $while_547_exit
              end
            end
          end
          local.get $w540
          local.get $w546
          i32.const 1
          i32.add
          local.get $w545
          array.set $GcArray_41
          local.get $w544
          i32.const 1
          i32.add
          local.set $w544
          br $while_548_lp
        else
          br $while_548_exit
        end
      end
    end
    local.get $w539
    i32.const 1
    i32.sub
    local.set $w549
    ref.null $ListBase
    local.set $w550
    block $while_551_exit
      loop $while_551_lp
        local.get $w549
        i32.const 0
        i32.ge_s
        if
          local.get $w540
          local.get $w549
          array.get $GcArray_41
          local.get $w550
          struct.new $ListCons_30
          local.set $w550
          local.get $w549
          i32.const 1
          i32.sub
          local.set $w549
          br $while_551_lp
        else
          br $while_551_exit
        end
      end
    end
    local.get $w550
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
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
  (func $testIsDigit (result i32) ;; exported as "testIsDigit"
    i32.const 53
    call $charIsDigit
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testIsDigitFalse (result i32) ;; exported as "testIsDigitFalse"
    i32.const 65
    call $charIsDigit
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testIsLetter (result i32) ;; exported as "testIsLetter"
    i32.const 65
    call $charIsLetter
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testIsLetterFalse (result i32) ;; exported as "testIsLetterFalse"
    i32.const 53
    call $charIsLetter
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
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
  (func $testIsWhiteSpace (result i32) ;; exported as "testIsWhiteSpace"
    i32.const 32
    call $charIsWhitespace
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testIsLetterOrDigit (result i32) ;; exported as "testIsLetterOrDigit"
    i32.const 57
    call $charIsLetterOrDigit
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
  (func $testOptionDefaultValue (result i32) ;; exported as "testOptionDefaultValue"
    (local $w558 (ref null $Option_12))
    i32.const 42
    struct.new $Option_12
    local.set $w558
    local.get $w558
    ref.is_null
    if (result i32)
      local.get $w558
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 99
    end
  )
  (func $testOptionDefaultValueNone (result i32) ;; exported as "testOptionDefaultValueNone"
    ref.null $Option_12
    ref.cast (ref $Option_12)
    struct.get $Option_12 0
  )
  (func $closure_173 (param $self (ref $AnyFn)) (result i32)
    i32.const 42
  )
  (func $testOptionDefaultWith (result i32) ;; exported as "testOptionDefaultWith"
    ref.null $Option_12
    ref.cast (ref $Option_12)
    struct.get $Option_12 0
  )
  (func $closure_174 (param $self (ref $AnyFn)) (result i32)
    i32.const 99
  )
  (func $testOptionDefaultWithSome (result i32) ;; exported as "testOptionDefaultWithSome"
    (local $w561 (ref null $Option_12))
    i32.const 5
    struct.new $Option_12
    local.set $w561
    local.get $w561
    ref.is_null
    if (result i32)
      local.get $w561
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 99
    end
  )
  (func $closure_175 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testOptionFilter (result i32) ;; exported as "testOptionFilter"
    (local $matchValue (ref null $Option_12))
    (local $w562 (ref null $Option_12))
    (local $x i32)
    i32.const 5
    struct.new $Option_12
    local.set $w562
    local.get $w562
    ref.is_null
    if (result (ref null $Option_12))
      local.get $w562
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
      local.set $x
      local.get $x
      i32.const 3
      i32.gt_s
      if (result (ref null $Option_12))
        local.get $w562
      else
        ref.null $Option_12
      end
    else
      ref.null $Option_12
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $closure_176 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.gt_s
  )
  (func $testOptionFilterNone (result i32) ;; exported as "testOptionFilterNone"
    (local $matchValue (ref null $Option_12))
    (local $w563 (ref null $Option_12))
    (local $x i32)
    i32.const 5
    struct.new $Option_12
    local.set $w563
    local.get $w563
    ref.is_null
    if (result (ref null $Option_12))
      local.get $w563
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
      local.set $x
      local.get $x
      i32.const 10
      i32.gt_s
      if (result (ref null $Option_12))
        local.get $w563
      else
        ref.null $Option_12
      end
    else
      ref.null $Option_12
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
  (func $testFloatMul (result i32) ;; exported as "testFloatMul"
    f64.const 6
    f64.const 6
    f64.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
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
  (func $equals_49 (param $eq_a (ref $QuickTestWasmGc_Preamble_Point)) (param $eq_b (ref $QuickTestWasmGc_Preamble_Point)) (result i32)
    i32.const 1
    local.get $eq_a
    struct.get $QuickTestWasmGc_Preamble_Point 0
    local.get $eq_b
    struct.get $QuickTestWasmGc_Preamble_Point 0
    f64.eq
    i32.and
    local.get $eq_a
    struct.get $QuickTestWasmGc_Preamble_Point 1
    local.get $eq_b
    struct.get $QuickTestWasmGc_Preamble_Point 1
    f64.eq
    i32.and
  )
  (func $testRecordEqTrue (result i32) ;; exported as "testRecordEqTrue"
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_Preamble_Point
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_Preamble_Point
    call $equals_49
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testRecordEqFalse (result i32) ;; exported as "testRecordEqFalse"
    f64.const 1
    f64.const 2
    struct.new $QuickTestWasmGc_Preamble_Point
    f64.const 1
    f64.const 3
    struct.new $QuickTestWasmGc_Preamble_Point
    call $equals_49
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testRecordNeq (result i32) ;; exported as "testRecordNeq"
    f64.const 5
    f64.const 6
    struct.new $QuickTestWasmGc_Preamble_Point
    f64.const 5
    f64.const 7
    struct.new $QuickTestWasmGc_Preamble_Point
    call $equals_49
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testDuEnumEqTrue (result i32) ;; exported as "testDuEnumEqTrue"
    i32.const 1
  )
  (func $testDuEnumEqFalse (result i32) ;; exported as "testDuEnumEqFalse"
    i32.const 0
  )
  (func $equals_52 (param $eq_a (ref $QuickTestWasmGc_Preamble_Shape)) (param $eq_b (ref $QuickTestWasmGc_Preamble_Shape)) (result i32)
    (local $eq_tag i32)
    local.get $eq_a
    struct.get $QuickTestWasmGc_Preamble_Shape 0
    local.get $eq_b
    struct.get $QuickTestWasmGc_Preamble_Shape 0
    i32.ne
    if (result i32)
      i32.const 0
    else
      local.get $eq_a
      struct.get $QuickTestWasmGc_Preamble_Shape 0
      local.set $eq_tag
      local.get $eq_tag
      i32.const 0
      i32.eq
      if (result i32)
        i32.const 1
        local.get $eq_a
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#0)
        struct.get $QuickTestWasmGc_Preamble_Shape#0 1
        local.get $eq_b
        ref.cast (ref $QuickTestWasmGc_Preamble_Shape#0)
        struct.get $QuickTestWasmGc_Preamble_Shape#0 1
        f64.eq
        i32.and
      else
        local.get $eq_tag
        i32.const 1
        i32.eq
        if (result i32)
          i32.const 1
          local.get $eq_a
          ref.cast (ref $QuickTestWasmGc_Preamble_Shape#1)
          struct.get $QuickTestWasmGc_Preamble_Shape#1 1
          local.get $eq_b
          ref.cast (ref $QuickTestWasmGc_Preamble_Shape#1)
          struct.get $QuickTestWasmGc_Preamble_Shape#1 1
          f64.eq
          i32.and
        else
          local.get $eq_tag
          i32.const 2
          i32.eq
          if (result i32)
            i32.const 1
            local.get $eq_a
            ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
            struct.get $QuickTestWasmGc_Preamble_Shape#2 1
            local.get $eq_b
            ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
            struct.get $QuickTestWasmGc_Preamble_Shape#2 1
            f64.eq
            i32.and
            local.get $eq_a
            ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
            struct.get $QuickTestWasmGc_Preamble_Shape#2 2
            local.get $eq_b
            ref.cast (ref $QuickTestWasmGc_Preamble_Shape#2)
            struct.get $QuickTestWasmGc_Preamble_Shape#2 2
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
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_Preamble_Shape#0
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_Preamble_Shape#0
    call $equals_52
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testDuDataEqFalse (result i32) ;; exported as "testDuDataEqFalse"
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_Preamble_Shape#0
    i32.const 0
    f64.const 4
    struct.new $QuickTestWasmGc_Preamble_Shape#0
    call $equals_52
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testDuDataEqDiffCtor (result i32) ;; exported as "testDuDataEqDiffCtor"
    i32.const 0
    f64.const 3
    struct.new $QuickTestWasmGc_Preamble_Shape#0
    i32.const 1
    f64.const 3
    struct.new $QuickTestWasmGc_Preamble_Shape#1
    call $equals_52
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $equals_15 (param $eq_a (ref $Tuple_15)) (param $eq_b (ref $Tuple_15)) (result i32)
    i32.const 1
    local.get $eq_a
    struct.get $Tuple_15 0
    local.get $eq_b
    struct.get $Tuple_15 0
    i32.eq
    i32.and
    local.get $eq_a
    struct.get $Tuple_15 1
    local.get $eq_b
    struct.get $Tuple_15 1
    i32.eq
    i32.and
  )
  (func $testTupleEqTrue (result i32) ;; exported as "testTupleEqTrue"
    i32.const 1
    i32.const 2
    struct.new $Tuple_15
    i32.const 1
    i32.const 2
    struct.new $Tuple_15
    call $equals_15
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testTupleEqFalse (result i32) ;; exported as "testTupleEqFalse"
    i32.const 1
    i32.const 2
    struct.new $Tuple_15
    i32.const 1
    i32.const 3
    struct.new $Tuple_15
    call $equals_15
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $testTupleNeq (result i32) ;; exported as "testTupleNeq"
    i32.const 1
    i32.const 2
    struct.new $Tuple_15
    i32.const 1
    i32.const 3
    struct.new $Tuple_15
    call $equals_15
    i32.eqz
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $identity (param $x i32) (result i32) ;; exported as "identity"
    local.get $x
  )
  (func $identity_i32 (param $x i32) (result i32)
    local.get $x
  )
  (func $testIdentityInt (result i32) ;; exported as "testIdentityInt"
    i32.const 99
    return_call $identity_i32
  )
  (func $identity_f64 (param $x f64) (result f64)
    local.get $x
  )
  (func $testIdentityFloat (result i32) ;; exported as "testIdentityFloat"
    f64.const 2.5
    call $identity_f64
    f64.const 2
    f64.gt
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $const2 (param $a i32) (param $b i32) (result i32) ;; exported as "const2"
    local.get $a
  )
  (func $const2_i32~f64 (param $a i32) (param $b f64) (result i32)
    local.get $a
  )
  (func $testConst2IntFloat (result i32) ;; exported as "testConst2IntFloat"
    i32.const 7
    f64.const 3.1400000000000001
    return_call $const2_i32~f64
  )
  (func $const2_i32~i32 (param $a i32) (param $b i32) (result i32)
    local.get $a
  )
  (func $testConst2IntInt (result i32) ;; exported as "testConst2IntInt"
    i32.const 99
    i32.const 0
    return_call $const2_i32~i32
  )
  (func $const2_f64~i32 (param $a f64) (param $b i32) (result f64)
    local.get $a
  )
  (func $testConst2FloatInt (result i32) ;; exported as "testConst2FloatInt"
    f64.const 2.5
    i32.const 42
    call $const2_f64~i32
    f64.const 2
    f64.gt
    if (result i32)
      i32.const 1
    else
      i32.const 0
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
  (func $closure_177 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_178 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_179 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapAddFind (result i32) ;; exported as "testMapAddFind"
    (local $w564 (ref null $Option_12))
    i32.const 1
    i32.const 2
    i32.const 200
    i32.const 1
    i32.const 100
    ref.func $closure_179
    struct.new $ClosureType_179
    call $Map_empty
    call $Map_add
    call $Map_add
    call $Map_tryFind
    local.set $w564
    local.get $w564
    ref.is_null
    if (result i32)
      local.get $w564
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 0
    end
  )
  (func $closure_180 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_181 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_182 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapFindMissing (result i32) ;; exported as "testMapFindMissing"
    (local $w565 (ref null $Option_12))
    i32.const 99
    i32.const 1
    i32.const 100
    ref.func $closure_182
    struct.new $ClosureType_182
    call $Map_empty
    call $Map_add
    call $Map_tryFind
    local.set $w565
    local.get $w565
    ref.is_null
    if (result i32)
      local.get $w565
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 0
    end
  )
  (func $closure_183 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapCount (result i32) ;; exported as "testMapCount"
    i32.const 2
    i32.const 200
    i32.const 1
    i32.const 100
    ref.func $closure_183
    struct.new $ClosureType_183
    call $Map_empty
    call $Map_add
    call $Map_add
    return_call $Map_count
  )
  (func $closure_184 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapContainsKey (result i32) ;; exported as "testMapContainsKey"
    i32.const 42
    i32.const 42
    i32.const 999
    ref.func $closure_184
    struct.new $ClosureType_184
    call $Map_empty
    call $Map_add
    call $Map_containsKey
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_185 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapContainsKeyMissing (result i32) ;; exported as "testMapContainsKeyMissing"
    i32.const 7
    i32.const 42
    i32.const 999
    ref.func $closure_185
    struct.new $ClosureType_185
    call $Map_empty
    call $Map_add
    call $Map_containsKey
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_186 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_187 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $closure_188 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapAddReplace (result i32) ;; exported as "testMapAddReplace"
    (local $w566 (ref null $Option_12))
    i32.const 1
    i32.const 1
    i32.const 555
    i32.const 1
    i32.const 100
    ref.func $closure_188
    struct.new $ClosureType_188
    call $Map_empty
    call $Map_add
    call $Map_add
    call $Map_tryFind
    local.set $w566
    local.get $w566
    ref.is_null
    if (result i32)
      local.get $w566
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 0
    end
  )
  (func $testOptionModuleIsSome (result i32) ;; exported as "testOptionModuleIsSome"
    i32.const 1
  )
  (func $testOptionModuleIsSomeNone (result i32) ;; exported as "testOptionModuleIsSomeNone"
    i32.const 0
  )
  (func $testOptionModuleIsNone (result i32) ;; exported as "testOptionModuleIsNone"
    i32.const 1
  )
  (func $testOptionModuleIsNoneSome (result i32) ;; exported as "testOptionModuleIsNoneSome"
    i32.const 0
  )
  (func $testOptionModuleDefaultValueNone (result i32) ;; exported as "testOptionModuleDefaultValueNone"
    ref.null $Option_12
    ref.cast (ref $Option_12)
    struct.get $Option_12 0
  )
  (func $testOptionModuleDefaultValueSome (result i32) ;; exported as "testOptionModuleDefaultValueSome"
    (local $w568 (ref null $Option_12))
    i32.const 99
    struct.new $Option_12
    local.set $w568
    local.get $w568
    ref.is_null
    if (result i32)
      local.get $w568
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 42
    end
  )
  (func $testOptionModuleCountNone (result i32) ;; exported as "testOptionModuleCountNone"
    i32.const 0
  )
  (func $testOptionModuleCountSome (result i32) ;; exported as "testOptionModuleCountSome"
    i32.const 1
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
  (func $testSprintfInt (result i32) ;; exported as "testSprintfInt"
    array.new_fixed $WasmStr 0
    i32.const 42
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfNegInt (result i32) ;; exported as "testSprintfNegInt"
    array.new_fixed $WasmStr 0
    i32.const -7
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfStr (result i32) ;; exported as "testSprintfStr"
    array.new_fixed $WasmStr 0
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfIntLiteral (result i32) ;; exported as "testSprintfIntLiteral"
    i32.const 120
    i32.const 61
    array.new_fixed $WasmStr 2
    i32.const 100
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfTwoInts (result i32) ;; exported as "testSprintfTwoInts"
    array.new_fixed $WasmStr 0
    i32.const 3
    call $intToStr
    call $strConcat
    i32.const 32
    array.new_fixed $WasmStr 1
    call $strConcat
    i32.const 7
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfTwoStrs (result i32) ;; exported as "testSprintfTwoStrs"
    array.new_fixed $WasmStr 0
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    call $strConcat
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    array.new_fixed $WasmStr 5
    call $strConcat
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfBoolTrue (result i32) ;; exported as "testSprintfBoolTrue"
    array.new_fixed $WasmStr 0
    i32.const 116
    i32.const 114
    i32.const 117
    i32.const 101
    array.new_fixed $WasmStr 4
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfBoolFalse (result i32) ;; exported as "testSprintfBoolFalse"
    array.new_fixed $WasmStr 0
    i32.const 102
    i32.const 97
    i32.const 108
    i32.const 115
    i32.const 101
    array.new_fixed $WasmStr 5
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfMixed (result i32) ;; exported as "testSprintfMixed"
    i32.const 110
    i32.const 61
    array.new_fixed $WasmStr 2
    i32.const 7
    call $intToStr
    call $strConcat
    i32.const 44
    i32.const 115
    i32.const 61
    array.new_fixed $WasmStr 3
    call $strConcat
    i32.const 104
    i32.const 105
    array.new_fixed $WasmStr 2
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfZero (result i32) ;; exported as "testSprintfZero"
    array.new_fixed $WasmStr 0
    i32.const 0
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testSprintfPrefix (result i32) ;; exported as "testSprintfPrefix"
    i32.const 82
    i32.const 101
    i32.const 115
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 58
    i32.const 32
    array.new_fixed $WasmStr 8
    i32.const 99
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testSprintfFloat (result i32) ;; exported as "testSprintfFloat"
    array.new_fixed $WasmStr 0
    f64.const 3.1400000000000001
    call $floatToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfFloatHalf (result i32) ;; exported as "testSprintfFloatHalf"
    array.new_fixed $WasmStr 0
    f64.const 0.5
    call $floatToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfFloatWhole (result i32) ;; exported as "testSprintfFloatWhole"
    array.new_fixed $WasmStr 0
    f64.const 2
    call $floatToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfFloatNeg (result i32) ;; exported as "testSprintfFloatNeg"
    array.new_fixed $WasmStr 0
    f64.const -1.5
    call $floatToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfFloatInStr (result i32) ;; exported as "testSprintfFloatInStr"
    i32.const 112
    i32.const 105
    i32.const 61
    i32.const 126
    array.new_fixed $WasmStr 4
    f64.const 3.1415899999999999
    call $floatToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testPrintfnInt (result i32) ;; exported as "testPrintfnInt"
    i32.const 99
    i32.const 111
    i32.const 117
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 61
    i32.const 32
    array.new_fixed $WasmStr 8
    i32.const 42
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    call $consolePrint
    i32.const 1
  )
  (func $testPrintfnStr (result i32) ;; exported as "testPrintfnStr"
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 44
    i32.const 32
    array.new_fixed $WasmStr 7
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 5
    call $strConcat
    i32.const 33
    array.new_fixed $WasmStr 1
    call $strConcat
    call $consolePrint
    i32.const 1
  )
  (func $testPrintfnMulti (result i32) ;; exported as "testPrintfnMulti"
    array.new_fixed $WasmStr 0
    i32.const 3
    call $intToStr
    call $strConcat
    i32.const 32
    i32.const 43
    i32.const 32
    array.new_fixed $WasmStr 3
    call $strConcat
    i32.const 7
    call $intToStr
    call $strConcat
    i32.const 32
    i32.const 61
    i32.const 32
    array.new_fixed $WasmStr 3
    call $strConcat
    i32.const 10
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    call $consolePrint
    i32.const 1
  )
  (func $testSprintfI (result i32) ;; exported as "testSprintfI"
    array.new_fixed $WasmStr 0
    i32.const 99
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
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
  (func $testSprintfIntZeroChar (result i32) ;; exported as "testSprintfIntZeroChar"
    array.new_fixed $WasmStr 0
    i32.const 0
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testSprintfEmptyStr (result i32) ;; exported as "testSprintfEmptyStr"
    array.new_fixed $WasmStr 0
    array.new_fixed $WasmStr 0
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    array.len
  )
  (func $testSprintfIntFirstChar (result i32) ;; exported as "testSprintfIntFirstChar"
    array.new_fixed $WasmStr 0
    i32.const 42
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
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
  (func $testExternAdd (result i32) ;; exported as "testExternAdd"
    i32.const 10
    i32.const 32
    return_call $testEnv_wasmAdd
  )
  (func $testExternAddNeg (result i32) ;; exported as "testExternAddNeg"
    i32.const -5
    i32.const 5
    return_call $testEnv_wasmAdd
  )
  (func $testExternMul (result i32) ;; exported as "testExternMul"
    i32.const 6
    i32.const 7
    return_call $testEnv_wasmMul
  )
  (func $testExternChain (result i32) ;; exported as "testExternChain"
    i32.const 2
    i32.const 3
    call $testEnv_wasmAdd
    i32.const 4
    return_call $testEnv_wasmMul
  )
  (func $testStrSplitLen (result i32) ;; exported as "testStrSplitLen"
    (local $parts (ref $GcArray_43))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_43 1
    i32.const 0
    array.get $GcArray_43
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitFirst (result i32) ;; exported as "testStrSplitFirst"
    (local $parts (ref $GcArray_43))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_43 1
    i32.const 0
    array.get $GcArray_43
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 0
    array.get $GcArray_43
    array.len
  )
  (func $testStrSplitSecond (result i32) ;; exported as "testStrSplitSecond"
    (local $parts (ref $GcArray_43))
    i32.const 97
    i32.const 44
    i32.const 98
    i32.const 44
    i32.const 99
    array.new_fixed $WasmStr 5
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_43 1
    i32.const 0
    array.get $GcArray_43
    call $strSplit
    local.set $parts
    local.get $parts
    i32.const 1
    array.get $GcArray_43
    i32.const 0
    array.get $WasmStr
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testStrSplitWords (result i32) ;; exported as "testStrSplitWords"
    (local $parts (ref $GcArray_43))
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
    array.new_fixed $GcArray_43 1
    i32.const 0
    array.get $GcArray_43
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitNoDelim (result i32) ;; exported as "testStrSplitNoDelim"
    (local $parts (ref $GcArray_43))
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
    array.new_fixed $GcArray_43 1
    i32.const 0
    array.get $GcArray_43
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitEmpty (result i32) ;; exported as "testStrSplitEmpty"
    (local $parts (ref $GcArray_43))
    array.new_fixed $WasmStr 0
    i32.const 44
    array.new_fixed $WasmStr 1
    array.new_fixed $GcArray_43 1
    i32.const 0
    array.get $GcArray_43
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrSplitMultiChar (result i32) ;; exported as "testStrSplitMultiChar"
    (local $parts (ref $GcArray_43))
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
    array.new_fixed $GcArray_43 1
    i32.const 0
    array.get $GcArray_43
    call $strSplit
    local.set $parts
    local.get $parts
    array.len
  )
  (func $testStrJoinLen (result i32) ;; exported as "testStrJoinLen"
    (local $parts (ref $GcArray_43))
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
    array.new_fixed $GcArray_43 3
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
    array.new_fixed $GcArray_43 2
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
    array.new_fixed $GcArray_43 1
    call $strJoin
    array.len
  )
  (func $testIntParse (result i32) ;; exported as "testIntParse"
    i32.const 52
    i32.const 50
    array.new_fixed $WasmStr 2
    call $parseInt
  )
  (func $testIntParseNeg (result i32) ;; exported as "testIntParseNeg"
    i32.const 45
    i32.const 49
    i32.const 55
    array.new_fixed $WasmStr 3
    call $parseInt
  )
  (func $testIntParseZero (result i32) ;; exported as "testIntParseZero"
    i32.const 48
    array.new_fixed $WasmStr 1
    call $parseInt
  )
  (func $testFloatParse (result i32) ;; exported as "testFloatParse"
    i32.const 51
    i32.const 46
    i32.const 49
    i32.const 52
    array.new_fixed $WasmStr 4
    call $parseFloat
    f64.const 100
    f64.mul
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testFloatParseNeg (result i32) ;; exported as "testFloatParseNeg"
    i32.const 45
    i32.const 50
    i32.const 46
    i32.const 53
    array.new_fixed $WasmStr 4
    call $parseFloat
    f64.const 10
    f64.mul
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testFloatParseInt (result i32) ;; exported as "testFloatParseInt"
    i32.const 55
    array.new_fixed $WasmStr 1
    call $parseFloat
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
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
  (func $testFib10 (result i32) ;; exported as "testFib10"
    i32.const 10
    return_call $fibonacci
  )
  (func $testFib15 (result i32) ;; exported as "testFib15"
    i32.const 15
    return_call $fibonacci
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
  (func $testSumMultiples35 (result i32) ;; exported as "testSumMultiples35"
    (local $sum i32)
    (local $i i32)
    i32.const 0
    local.set $sum
    i32.const 1
    local.set $i
    loop $for
      local.get $i
      i32.const 999
      i32.le_s
      if
        local.get $i
        i32.const 3
        i32.rem_s
        i32.const 0
        i32.eq
        if (result i32)
          i32.const 1
        else
          local.get $i
          i32.const 5
          i32.rem_s
          i32.const 0
          i32.eq
        end
        if
          local.get $sum
          local.get $i
          i32.add
          local.set $sum
        end
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $for
      end
    end
    local.get $sum
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
  (func $closure_189 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayToList (result i32) ;; exported as "testArrayToList"
    (local $w575 (ref null $ListBase))
    (local $w570 (ref $GcArray_41))
    (local $w571 i32)
    (local $w572 (ref null $ListBase))
    (local $w576 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w570
    local.get $w570
    array.len
    i32.const 1
    i32.sub
    local.set $w571
    ref.null $ListBase
    local.set $w572
    block $while_573_exit
      loop $while_573_lp
        local.get $w571
        i32.const 0
        i32.ge_s
        if
          local.get $w570
          local.get $w571
          array.get $GcArray_41
          local.get $w572
          struct.new $ListCons_30
          local.set $w572
          local.get $w571
          i32.const 1
          i32.sub
          local.set $w571
          br $while_573_lp
        else
          br $while_573_exit
        end
      end
    end
    local.get $w572
    local.set $w575
    i32.const 0
    local.set $w576
    block $while_577_exit
      loop $while_577_lp
        local.get $w575
        ref.is_null
        i32.eqz
        if
          local.get $w576
          local.get $w575
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w576
          local.get $w575
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w575
          br $while_577_lp
        else
          br $while_577_exit
        end
      end
    end
    local.get $w576
  )
  (func $closure_190 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListOfArray (result i32) ;; exported as "testListOfArray"
    (local $w584 (ref null $ListBase))
    (local $w579 (ref $GcArray_41))
    (local $w580 i32)
    (local $w581 (ref null $ListBase))
    (local $w585 i32)
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_41 3
    local.set $w579
    local.get $w579
    array.len
    i32.const 1
    i32.sub
    local.set $w580
    ref.null $ListBase
    local.set $w581
    block $while_582_exit
      loop $while_582_lp
        local.get $w580
        i32.const 0
        i32.ge_s
        if
          local.get $w579
          local.get $w580
          array.get $GcArray_41
          local.get $w581
          struct.new $ListCons_30
          local.set $w581
          local.get $w580
          i32.const 1
          i32.sub
          local.set $w580
          br $while_582_lp
        else
          br $while_582_exit
        end
      end
    end
    local.get $w581
    local.set $w584
    i32.const 0
    local.set $w585
    block $while_586_exit
      loop $while_586_lp
        local.get $w584
        ref.is_null
        i32.eqz
        if
          local.get $w585
          local.get $w584
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
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
  )
  (func $closure_191 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_192 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
    (local $w588 (ref null $ListBase))
    (local $w592 i32)
    (local $w589 (ref null $ListBase))
    (local $w590 i32)
    (local $w593 (ref $GcArray_41))
    (local $w594 (ref $GcArray_41))
    (local $w595 (ref null $ListBase))
    (local $w596 i32)
    (local $w597 i32)
    (local $w600 i32)
    (local $w601 i32)
    (local $w602 i32)
    (local $w603 i32)
    (local $w606 i32)
    (local $w607 (ref null $ListBase))
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
    local.set $w588
    local.get $w588
    local.set $w589
    i32.const 0
    local.set $w590
    block $while_591_exit
      loop $while_591_lp
        local.get $w589
        ref.is_null
        i32.eqz
        if
          local.get $w590
          i32.const 1
          i32.add
          local.set $w590
          local.get $w589
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w589
          br $while_591_lp
        else
          br $while_591_exit
        end
      end
    end
    local.get $w590
    local.set $w592
    i32.const 0
    local.get $w592
    array.new $GcArray_41
    local.set $w593
    i32.const 0
    local.get $w592
    array.new $GcArray_41
    local.set $w594
    local.get $w588
    local.set $w595
    i32.const 0
    local.set $w596
    block $while_599_exit
      loop $while_599_lp
        local.get $w595
        ref.is_null
        i32.eqz
        if
          local.get $w595
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w597
          local.get $w593
          local.get $w596
          local.get $w597
          array.set $GcArray_41
          local.get $w594
          local.get $w596
          local.get $w597
          array.set $GcArray_41
          local.get $w596
          i32.const 1
          i32.add
          local.set $w596
          local.get $w595
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w595
          br $while_599_lp
        else
          br $while_599_exit
        end
      end
    end
    local.get $w596
    drop
    i32.const 1
    local.set $w600
    block $while_605_exit
      loop $while_605_lp
        local.get $w600
        local.get $w592
        i32.lt_s
        if
          local.get $w593
          local.get $w600
          array.get $GcArray_41
          local.set $w601
          local.get $w594
          local.get $w600
          array.get $GcArray_41
          local.set $w602
          local.get $w600
          i32.const 1
          i32.sub
          local.set $w603
          block $while_604_exit
            loop $while_604_lp
              local.get $w603
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w594
                local.get $w603
                array.get $GcArray_41
                local.get $w602
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w593
                local.get $w603
                i32.const 1
                i32.add
                local.get $w593
                local.get $w603
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w594
                local.get $w603
                i32.const 1
                i32.add
                local.get $w594
                local.get $w603
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w603
                i32.const 1
                i32.sub
                local.set $w603
                br $while_604_lp
              else
                br $while_604_exit
              end
            end
          end
          local.get $w593
          local.get $w603
          i32.const 1
          i32.add
          local.get $w601
          array.set $GcArray_41
          local.get $w594
          local.get $w603
          i32.const 1
          i32.add
          local.get $w602
          array.set $GcArray_41
          local.get $w600
          i32.const 1
          i32.add
          local.set $w600
          br $while_605_lp
        else
          br $while_605_exit
        end
      end
    end
    local.get $w592
    i32.const 1
    i32.sub
    local.set $w606
    ref.null $ListBase
    local.set $w607
    block $while_608_exit
      loop $while_608_lp
        local.get $w606
        i32.const 0
        i32.ge_s
        if
          local.get $w593
          local.get $w606
          array.get $GcArray_41
          local.get $w607
          struct.new $ListCons_30
          local.set $w607
          local.get $w606
          i32.const 1
          i32.sub
          local.set $w606
          br $while_608_lp
        else
          br $while_608_exit
        end
      end
    end
    local.get $w607
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_193 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListFlatten (result i32) ;; exported as "testListFlatten"
    (local $w617 (ref null $ListBase))
    (local $w610 (ref null $ListBase))
    (local $w611 (ref null $ListBase))
    (local $w613 (ref null $ListBase))
    (local $w614 (ref null $ListBase))
    (local $w618 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w610
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
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
          local.get $w617
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
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
  (func $QuickTestWasmGc_Preamble_EnglishGreeter_Greet (param $this$ (ref $QuickTestWasmGc_Preamble_EnglishGreeter)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_Preamble_EnglishGreeter 0
    array.len
  )
  (func $QuickTestWasmGc_Preamble_EnglishGreeter_QuickTestWasmGc_Preamble_IGreeter_Greet_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_Preamble_EnglishGreeter)
    call $QuickTestWasmGc_Preamble_EnglishGreeter_Greet
  )
  (func $QuickTestWasmGc_Preamble_SpanishGreeter_Greet (param $this$ (ref $QuickTestWasmGc_Preamble_SpanishGreeter)) (result i32)
    local.get $this$
    struct.get $QuickTestWasmGc_Preamble_SpanishGreeter 0
    array.len
  )
  (func $QuickTestWasmGc_Preamble_SpanishGreeter_QuickTestWasmGc_Preamble_IGreeter_Greet_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_Preamble_SpanishGreeter)
    call $QuickTestWasmGc_Preamble_SpanishGreeter_Greet
  )
  (func $testInterfaceDispatch (result i32) ;; exported as "testInterfaceDispatch"
    (local $g (ref $box_QuickTestWasmGc_Preamble_IGreeter))
    global.get $QuickTestWasmGc_Preamble_EnglishGreeter_QuickTestWasmGc_Preamble_IGreeter_vtable
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    struct.new $QuickTestWasmGc_Preamble_EnglishGreeter
    struct.new $box_QuickTestWasmGc_Preamble_IGreeter
    local.set $g
    local.get $g
    struct.get $box_QuickTestWasmGc_Preamble_IGreeter 1
    local.get $g
    struct.get $box_QuickTestWasmGc_Preamble_IGreeter 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IGreeter 0
    call_ref $FuncType_195
  )
  (func $projection_199 (param $self (ref $AnyFn)) (param $g (ref $box_QuickTestWasmGc_Preamble_IGreeter)) (result i32)
    local.get $g
    struct.get $box_QuickTestWasmGc_Preamble_IGreeter 1
    local.get $g
    struct.get $box_QuickTestWasmGc_Preamble_IGreeter 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IGreeter 0
    call_ref $FuncType_195
  )
  (func $closure_203 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testInterfacePolymorphism (result i32) ;; exported as "testInterfacePolymorphism"
    (local $w621 (ref null $ListBase))
    (local $w622 i32)
    (local $g (ref $box_QuickTestWasmGc_Preamble_IGreeter))
    global.get $QuickTestWasmGc_Preamble_EnglishGreeter_QuickTestWasmGc_Preamble_IGreeter_vtable
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    struct.new $QuickTestWasmGc_Preamble_EnglishGreeter
    struct.new $box_QuickTestWasmGc_Preamble_IGreeter
    global.get $QuickTestWasmGc_Preamble_SpanishGreeter_QuickTestWasmGc_Preamble_IGreeter_vtable
    i32.const 104
    i32.const 111
    i32.const 108
    i32.const 97
    array.new_fixed $WasmStr 4
    struct.new $QuickTestWasmGc_Preamble_SpanishGreeter
    struct.new $box_QuickTestWasmGc_Preamble_IGreeter
    ref.null $ListBase
    struct.new $ListCons_202
    struct.new $ListCons_202
    local.set $w621
    i32.const 0
    local.set $w622
    block $while_623_exit
      loop $while_623_lp
        local.get $w621
        ref.is_null
        i32.eqz
        if
          local.get $w622
          local.get $w621
          ref.cast (ref $ListCons_202)
          struct.get $ListCons_202 0
          local.set $g
          local.get $g
          struct.get $box_QuickTestWasmGc_Preamble_IGreeter 1
          local.get $g
          struct.get $box_QuickTestWasmGc_Preamble_IGreeter 0
          struct.get $vtbl_QuickTestWasmGc_Preamble_IGreeter 0
          call_ref $FuncType_195
          i32.add
          local.set $w622
          local.get $w621
          ref.cast (ref $ListCons_202)
          struct.get $ListCons_202 1
          local.set $w621
          br $while_623_lp
        else
          br $while_623_exit
        end
      end
    end
    local.get $w622
  )
  (func $QuickTestWasmGc_Preamble_IntShape_Area (param $this$ (ref $QuickTestWasmGc_Preamble_IntShape)) (result i32)
    (local $r i32)
    local.get $this$
    struct.get $QuickTestWasmGc_Preamble_IntShape 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $this$
      ref.cast (ref $QuickTestWasmGc_Preamble_IntShape#1)
      struct.get $QuickTestWasmGc_Preamble_IntShape#1 1
      local.get $this$
      ref.cast (ref $QuickTestWasmGc_Preamble_IntShape#1)
      struct.get $QuickTestWasmGc_Preamble_IntShape#1 2
      i32.mul
    else
      local.get $this$
      ref.cast (ref $QuickTestWasmGc_Preamble_IntShape#0)
      struct.get $QuickTestWasmGc_Preamble_IntShape#0 1
      local.set $r
      local.get $r
      local.get $r
      i32.mul
    end
  )
  (func $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_Area_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_Preamble_IntShape)
    call $QuickTestWasmGc_Preamble_IntShape_Area
  )
  (func $testDuInterfaceCircle (result i32) ;; exported as "testDuInterfaceCircle"
    (local $s (ref $box_QuickTestWasmGc_Preamble_IShape))
    global.get $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 0
    i32.const 3
    struct.new $QuickTestWasmGc_Preamble_IntShape#0
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
    call_ref $FuncType_195
  )
  (func $testDuInterfaceRect (result i32) ;; exported as "testDuInterfaceRect"
    (local $s (ref $box_QuickTestWasmGc_Preamble_IShape))
    global.get $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 1
    i32.const 4
    i32.const 5
    struct.new $QuickTestWasmGc_Preamble_IntShape#1
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
    call_ref $FuncType_195
  )
  (func $projection_209 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_Preamble_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
    call_ref $FuncType_195
  )
  (func $closure_213 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testDuInterfacePoly (result i32) ;; exported as "testDuInterfacePoly"
    (local $w625 (ref null $ListBase))
    (local $w626 i32)
    (local $s (ref $box_QuickTestWasmGc_Preamble_IShape))
    global.get $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 0
    i32.const 2
    struct.new $QuickTestWasmGc_Preamble_IntShape#0
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    global.get $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 1
    i32.const 3
    i32.const 4
    struct.new $QuickTestWasmGc_Preamble_IntShape#1
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    ref.null $ListBase
    struct.new $ListCons_212
    struct.new $ListCons_212
    local.set $w625
    i32.const 0
    local.set $w626
    block $while_627_exit
      loop $while_627_lp
        local.get $w625
        ref.is_null
        i32.eqz
        if
          local.get $w626
          local.get $w625
          ref.cast (ref $ListCons_212)
          struct.get $ListCons_212 0
          local.set $s
          local.get $s
          struct.get $box_QuickTestWasmGc_Preamble_IShape 1
          local.get $s
          struct.get $box_QuickTestWasmGc_Preamble_IShape 0
          struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
          call_ref $FuncType_195
          i32.add
          local.set $w626
          local.get $w625
          ref.cast (ref $ListCons_212)
          struct.get $ListCons_212 1
          local.set $w625
          br $while_627_lp
        else
          br $while_627_exit
        end
      end
    end
    local.get $w626
  )
  (func $ClassCircle_$ctor_Z524259A4 (param $radius i32) (result (ref $QuickTestWasmGc_Preamble_ClassCircle))
    local.get $radius
    struct.new $QuickTestWasmGc_Preamble_ClassCircle
  )
  (func $QuickTestWasmGc_Preamble_ClassCircle_Area (param $_ (ref $QuickTestWasmGc_Preamble_ClassCircle)) (result i32)
    local.get $_
    struct.get $QuickTestWasmGc_Preamble_ClassCircle 0
    local.get $_
    struct.get $QuickTestWasmGc_Preamble_ClassCircle 0
    i32.mul
  )
  (func $QuickTestWasmGc_Preamble_ClassCircle_QuickTestWasmGc_Preamble_IShape_Area_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_Preamble_ClassCircle)
    call $QuickTestWasmGc_Preamble_ClassCircle_Area
  )
  (func $ClassRect_$ctor_Z37302880 (param $width i32) (param $height i32) (result (ref $QuickTestWasmGc_Preamble_ClassRect))
    local.get $width
    local.get $height
    struct.new $QuickTestWasmGc_Preamble_ClassRect
  )
  (func $QuickTestWasmGc_Preamble_ClassRect_Area (param $_ (ref $QuickTestWasmGc_Preamble_ClassRect)) (result i32)
    local.get $_
    struct.get $QuickTestWasmGc_Preamble_ClassRect 0
    local.get $_
    struct.get $QuickTestWasmGc_Preamble_ClassRect 1
    i32.mul
  )
  (func $QuickTestWasmGc_Preamble_ClassRect_QuickTestWasmGc_Preamble_IShape_Area_wrap (param $self (ref eq)) (result i32)
    local.get $self
    ref.cast (ref $QuickTestWasmGc_Preamble_ClassRect)
    call $QuickTestWasmGc_Preamble_ClassRect_Area
  )
  (func $testClassCircleArea (result i32) ;; exported as "testClassCircleArea"
    (local $s (ref $box_QuickTestWasmGc_Preamble_IShape))
    global.get $QuickTestWasmGc_Preamble_ClassCircle_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 5
    call $ClassCircle_$ctor_Z524259A4
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
    call_ref $FuncType_195
  )
  (func $testClassRectArea (result i32) ;; exported as "testClassRectArea"
    (local $s (ref $box_QuickTestWasmGc_Preamble_IShape))
    global.get $QuickTestWasmGc_Preamble_ClassRect_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 3
    i32.const 7
    call $ClassRect_$ctor_Z37302880
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    local.set $s
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
    call_ref $FuncType_195
  )
  (func $projection_216 (param $self (ref $AnyFn)) (param $s (ref $box_QuickTestWasmGc_Preamble_IShape)) (result i32)
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 1
    local.get $s
    struct.get $box_QuickTestWasmGc_Preamble_IShape 0
    struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
    call_ref $FuncType_195
  )
  (func $closure_217 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testMixedShapes (result i32) ;; exported as "testMixedShapes"
    (local $w629 (ref null $ListBase))
    (local $w630 i32)
    (local $s (ref $box_QuickTestWasmGc_Preamble_IShape))
    global.get $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 0
    i32.const 3
    struct.new $QuickTestWasmGc_Preamble_IntShape#0
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    global.get $QuickTestWasmGc_Preamble_ClassRect_QuickTestWasmGc_Preamble_IShape_vtable
    i32.const 2
    i32.const 6
    call $ClassRect_$ctor_Z37302880
    struct.new $box_QuickTestWasmGc_Preamble_IShape
    ref.null $ListBase
    struct.new $ListCons_212
    struct.new $ListCons_212
    local.set $w629
    i32.const 0
    local.set $w630
    block $while_631_exit
      loop $while_631_lp
        local.get $w629
        ref.is_null
        i32.eqz
        if
          local.get $w630
          local.get $w629
          ref.cast (ref $ListCons_212)
          struct.get $ListCons_212 0
          local.set $s
          local.get $s
          struct.get $box_QuickTestWasmGc_Preamble_IShape 1
          local.get $s
          struct.get $box_QuickTestWasmGc_Preamble_IShape 0
          struct.get $vtbl_QuickTestWasmGc_Preamble_IShape 0
          call_ref $FuncType_195
          i32.add
          local.set $w630
          local.get $w629
          ref.cast (ref $ListCons_212)
          struct.get $ListCons_212 1
          local.set $w629
          br $while_631_lp
        else
          br $while_631_exit
        end
      end
    end
    local.get $w630
  )
  (func $closure_220 (param $self (ref $AnyFn)) (param $a (ref $QuickTestWasmGc_Preamble_SWItem)) (param $b (ref $QuickTestWasmGc_Preamble_SWItem)) (result i32)
    local.get $a
    struct.get $QuickTestWasmGc_Preamble_SWItem 0
    local.get $b
    struct.get $QuickTestWasmGc_Preamble_SWItem 0
    i32.lt_s
    if (result i32)
      i32.const -1
    else
      local.get $a
      struct.get $QuickTestWasmGc_Preamble_SWItem 0
      local.get $b
      struct.get $QuickTestWasmGc_Preamble_SWItem 0
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        i32.const 0
      end
    end
  )
  (func $testSortWith (result i32) ;; exported as "testSortWith"
    (local $w633 (ref null $ListBase))
    (local $w637 i32)
    (local $w634 (ref null $ListBase))
    (local $w635 i32)
    (local $w638 (ref $GcArray_223))
    (local $w639 (ref null $ListBase))
    (local $w640 i32)
    (local $w642 i32)
    (local $w643 (ref $QuickTestWasmGc_Preamble_SWItem))
    (local $w644 i32)
    (local $a (ref $QuickTestWasmGc_Preamble_SWItem))
    (local $w647 i32)
    (local $w648 (ref null $ListBase))
    i32.const 3
    struct.new $QuickTestWasmGc_Preamble_SWItem
    i32.const 1
    struct.new $QuickTestWasmGc_Preamble_SWItem
    i32.const 4
    struct.new $QuickTestWasmGc_Preamble_SWItem
    i32.const 2
    struct.new $QuickTestWasmGc_Preamble_SWItem
    ref.null $ListBase
    struct.new $ListCons_219
    struct.new $ListCons_219
    struct.new $ListCons_219
    struct.new $ListCons_219
    local.set $w633
    local.get $w633
    local.set $w634
    i32.const 0
    local.set $w635
    block $while_636_exit
      loop $while_636_lp
        local.get $w634
        ref.is_null
        i32.eqz
        if
          local.get $w635
          i32.const 1
          i32.add
          local.set $w635
          local.get $w634
          ref.cast (ref $ListCons_219)
          struct.get $ListCons_219 1
          local.set $w634
          br $while_636_lp
        else
          br $while_636_exit
        end
      end
    end
    local.get $w635
    local.set $w637
    ref.null $QuickTestWasmGc_Preamble_SWItem
    local.get $w637
    array.new $GcArray_223
    local.set $w638
    local.get $w633
    local.set $w639
    i32.const 0
    local.set $w640
    block $while_641_exit
      loop $while_641_lp
        local.get $w639
        ref.is_null
        i32.eqz
        if
          local.get $w638
          local.get $w640
          local.get $w639
          ref.cast (ref $ListCons_219)
          struct.get $ListCons_219 0
          array.set $GcArray_223
          local.get $w640
          i32.const 1
          i32.add
          local.set $w640
          local.get $w639
          ref.cast (ref $ListCons_219)
          struct.get $ListCons_219 1
          local.set $w639
          br $while_641_lp
        else
          br $while_641_exit
        end
      end
    end
    local.get $w640
    drop
    i32.const 1
    local.set $w642
    block $while_646_exit
      loop $while_646_lp
        local.get $w642
        local.get $w637
        i32.lt_s
        if
          local.get $w638
          local.get $w642
          array.get $GcArray_223
          ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
          local.set $w643
          local.get $w642
          i32.const 1
          i32.sub
          local.set $w644
          block $while_645_exit
            loop $while_645_lp
              local.get $w644
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w638
                local.get $w644
                array.get $GcArray_223
                ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
                local.set $a
                local.get $a
                struct.get $QuickTestWasmGc_Preamble_SWItem 0
                local.get $w643
                struct.get $QuickTestWasmGc_Preamble_SWItem 0
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $a
                  struct.get $QuickTestWasmGc_Preamble_SWItem 0
                  local.get $w643
                  struct.get $QuickTestWasmGc_Preamble_SWItem 0
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
                local.get $w638
                local.get $w644
                i32.const 1
                i32.add
                local.get $w638
                local.get $w644
                array.get $GcArray_223
                ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
                array.set $GcArray_223
                local.get $w644
                i32.const 1
                i32.sub
                local.set $w644
                br $while_645_lp
              else
                br $while_645_exit
              end
            end
          end
          local.get $w638
          local.get $w644
          i32.const 1
          i32.add
          local.get $w643
          array.set $GcArray_223
          local.get $w642
          i32.const 1
          i32.add
          local.set $w642
          br $while_646_lp
        else
          br $while_646_exit
        end
      end
    end
    local.get $w637
    i32.const 1
    i32.sub
    local.set $w647
    ref.null $ListBase
    local.set $w648
    block $while_649_exit
      loop $while_649_lp
        local.get $w647
        i32.const 0
        i32.ge_s
        if
          local.get $w638
          local.get $w647
          array.get $GcArray_223
          ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
          local.get $w648
          struct.new $ListCons_219
          local.set $w648
          local.get $w647
          i32.const 1
          i32.sub
          local.set $w647
          br $while_649_lp
        else
          br $while_649_exit
        end
      end
    end
    local.get $w648
    ref.cast (ref $ListCons_219)
    struct.get $ListCons_219 0
    struct.get $QuickTestWasmGc_Preamble_SWItem 0
  )
  (func $closure_224 (param $self (ref $AnyFn)) (param $a (ref $QuickTestWasmGc_Preamble_SWItem)) (param $b (ref $QuickTestWasmGc_Preamble_SWItem)) (result i32)
    local.get $b
    struct.get $QuickTestWasmGc_Preamble_SWItem 0
    local.get $a
    struct.get $QuickTestWasmGc_Preamble_SWItem 0
    i32.lt_s
    if (result i32)
      i32.const -1
    else
      local.get $b
      struct.get $QuickTestWasmGc_Preamble_SWItem 0
      local.get $a
      struct.get $QuickTestWasmGc_Preamble_SWItem 0
      i32.gt_s
      if (result i32)
        i32.const 1
      else
        i32.const 0
      end
    end
  )
  (func $testSortWithDesc (result i32) ;; exported as "testSortWithDesc"
    (local $w651 (ref null $ListBase))
    (local $w655 i32)
    (local $w652 (ref null $ListBase))
    (local $w653 i32)
    (local $w656 (ref $GcArray_223))
    (local $w657 (ref null $ListBase))
    (local $w658 i32)
    (local $w660 i32)
    (local $w661 (ref $QuickTestWasmGc_Preamble_SWItem))
    (local $w662 i32)
    (local $a (ref $QuickTestWasmGc_Preamble_SWItem))
    (local $w665 i32)
    (local $w666 (ref null $ListBase))
    i32.const 3
    struct.new $QuickTestWasmGc_Preamble_SWItem
    i32.const 1
    struct.new $QuickTestWasmGc_Preamble_SWItem
    i32.const 4
    struct.new $QuickTestWasmGc_Preamble_SWItem
    i32.const 2
    struct.new $QuickTestWasmGc_Preamble_SWItem
    ref.null $ListBase
    struct.new $ListCons_219
    struct.new $ListCons_219
    struct.new $ListCons_219
    struct.new $ListCons_219
    local.set $w651
    local.get $w651
    local.set $w652
    i32.const 0
    local.set $w653
    block $while_654_exit
      loop $while_654_lp
        local.get $w652
        ref.is_null
        i32.eqz
        if
          local.get $w653
          i32.const 1
          i32.add
          local.set $w653
          local.get $w652
          ref.cast (ref $ListCons_219)
          struct.get $ListCons_219 1
          local.set $w652
          br $while_654_lp
        else
          br $while_654_exit
        end
      end
    end
    local.get $w653
    local.set $w655
    ref.null $QuickTestWasmGc_Preamble_SWItem
    local.get $w655
    array.new $GcArray_223
    local.set $w656
    local.get $w651
    local.set $w657
    i32.const 0
    local.set $w658
    block $while_659_exit
      loop $while_659_lp
        local.get $w657
        ref.is_null
        i32.eqz
        if
          local.get $w656
          local.get $w658
          local.get $w657
          ref.cast (ref $ListCons_219)
          struct.get $ListCons_219 0
          array.set $GcArray_223
          local.get $w658
          i32.const 1
          i32.add
          local.set $w658
          local.get $w657
          ref.cast (ref $ListCons_219)
          struct.get $ListCons_219 1
          local.set $w657
          br $while_659_lp
        else
          br $while_659_exit
        end
      end
    end
    local.get $w658
    drop
    i32.const 1
    local.set $w660
    block $while_664_exit
      loop $while_664_lp
        local.get $w660
        local.get $w655
        i32.lt_s
        if
          local.get $w656
          local.get $w660
          array.get $GcArray_223
          ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
          local.set $w661
          local.get $w660
          i32.const 1
          i32.sub
          local.set $w662
          block $while_663_exit
            loop $while_663_lp
              local.get $w662
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w656
                local.get $w662
                array.get $GcArray_223
                ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
                local.set $a
                local.get $w661
                struct.get $QuickTestWasmGc_Preamble_SWItem 0
                local.get $a
                struct.get $QuickTestWasmGc_Preamble_SWItem 0
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w661
                  struct.get $QuickTestWasmGc_Preamble_SWItem 0
                  local.get $a
                  struct.get $QuickTestWasmGc_Preamble_SWItem 0
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
                local.get $w656
                local.get $w662
                i32.const 1
                i32.add
                local.get $w656
                local.get $w662
                array.get $GcArray_223
                ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
                array.set $GcArray_223
                local.get $w662
                i32.const 1
                i32.sub
                local.set $w662
                br $while_663_lp
              else
                br $while_663_exit
              end
            end
          end
          local.get $w656
          local.get $w662
          i32.const 1
          i32.add
          local.get $w661
          array.set $GcArray_223
          local.get $w660
          i32.const 1
          i32.add
          local.set $w660
          br $while_664_lp
        else
          br $while_664_exit
        end
      end
    end
    local.get $w655
    i32.const 1
    i32.sub
    local.set $w665
    ref.null $ListBase
    local.set $w666
    block $while_667_exit
      loop $while_667_lp
        local.get $w665
        i32.const 0
        i32.ge_s
        if
          local.get $w656
          local.get $w665
          array.get $GcArray_223
          ref.cast (ref $QuickTestWasmGc_Preamble_SWItem)
          local.get $w666
          struct.new $ListCons_219
          local.set $w666
          local.get $w665
          i32.const 1
          i32.sub
          local.set $w665
          br $while_667_lp
        else
          br $while_667_exit
        end
      end
    end
    local.get $w666
    ref.cast (ref $ListCons_219)
    struct.get $ListCons_219 0
    struct.get $QuickTestWasmGc_Preamble_SWItem 0
  )
  (func $closure_225 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
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
  (func $testSortWithInts (result i32) ;; exported as "testSortWithInts"
    (local $w669 (ref null $ListBase))
    (local $w673 i32)
    (local $w670 (ref null $ListBase))
    (local $w671 i32)
    (local $w674 (ref $GcArray_41))
    (local $w675 (ref null $ListBase))
    (local $w676 i32)
    (local $w678 i32)
    (local $w679 i32)
    (local $w680 i32)
    (local $a i32)
    (local $w683 i32)
    (local $w684 (ref null $ListBase))
    i32.const 5
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w669
    local.get $w669
    local.set $w670
    i32.const 0
    local.set $w671
    block $while_672_exit
      loop $while_672_lp
        local.get $w670
        ref.is_null
        i32.eqz
        if
          local.get $w671
          i32.const 1
          i32.add
          local.set $w671
          local.get $w670
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w670
          br $while_672_lp
        else
          br $while_672_exit
        end
      end
    end
    local.get $w671
    local.set $w673
    i32.const 0
    local.get $w673
    array.new $GcArray_41
    local.set $w674
    local.get $w669
    local.set $w675
    i32.const 0
    local.set $w676
    block $while_677_exit
      loop $while_677_lp
        local.get $w675
        ref.is_null
        i32.eqz
        if
          local.get $w674
          local.get $w676
          local.get $w675
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_41
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
    drop
    i32.const 1
    local.set $w678
    block $while_682_exit
      loop $while_682_lp
        local.get $w678
        local.get $w673
        i32.lt_s
        if
          local.get $w674
          local.get $w678
          array.get $GcArray_41
          local.set $w679
          local.get $w678
          i32.const 1
          i32.sub
          local.set $w680
          block $while_681_exit
            loop $while_681_lp
              local.get $w680
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w674
                local.get $w680
                array.get $GcArray_41
                local.set $a
                local.get $a
                local.get $w679
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $a
                  local.get $w679
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
                local.get $w674
                local.get $w680
                i32.const 1
                i32.add
                local.get $w674
                local.get $w680
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w680
                i32.const 1
                i32.sub
                local.set $w680
                br $while_681_lp
              else
                br $while_681_exit
              end
            end
          end
          local.get $w674
          local.get $w680
          i32.const 1
          i32.add
          local.get $w679
          array.set $GcArray_41
          local.get $w678
          i32.const 1
          i32.add
          local.set $w678
          br $while_682_lp
        else
          br $while_682_exit
        end
      end
    end
    local.get $w673
    i32.const 1
    i32.sub
    local.set $w683
    ref.null $ListBase
    local.set $w684
    block $while_685_exit
      loop $while_685_lp
        local.get $w683
        i32.const 0
        i32.ge_s
        if
          local.get $w674
          local.get $w683
          array.get $GcArray_41
          local.get $w684
          struct.new $ListCons_30
          local.set $w684
          local.get $w683
          i32.const 1
          i32.sub
          local.set $w683
          br $while_685_lp
        else
          br $while_685_exit
        end
      end
    end
    local.get $w684
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_226 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
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
  (func $testArraySortWith (result i32) ;; exported as "testArraySortWith"
    (local $w687 (ref $GcArray_41))
    (local $w688 i32)
    (local $w689 (ref $GcArray_41))
    (local $w690 i32)
    (local $w691 i32)
    (local $w692 i32)
    (local $a i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_41 4
    local.set $w687
    local.get $w687
    array.len
    local.set $w688
    i32.const 0
    local.get $w688
    array.new $GcArray_41
    local.set $w689
    local.get $w689
    i32.const 0
    local.get $w687
    i32.const 0
    local.get $w688
    array.copy $GcArray_41 $GcArray_41
    i32.const 1
    local.set $w690
    block $while_694_exit
      loop $while_694_lp
        local.get $w690
        local.get $w688
        i32.lt_s
        if
          local.get $w689
          local.get $w690
          array.get $GcArray_41
          local.set $w691
          local.get $w690
          i32.const 1
          i32.sub
          local.set $w692
          block $while_693_exit
            loop $while_693_lp
              local.get $w692
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w689
                local.get $w692
                array.get $GcArray_41
                local.set $a
                local.get $a
                local.get $w691
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $a
                  local.get $w691
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
                local.get $w689
                local.get $w692
                i32.const 1
                i32.add
                local.get $w689
                local.get $w692
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w692
                i32.const 1
                i32.sub
                local.set $w692
                br $while_693_lp
              else
                br $while_693_exit
              end
            end
          end
          local.get $w689
          local.get $w692
          i32.const 1
          i32.add
          local.get $w691
          array.set $GcArray_41
          local.get $w690
          i32.const 1
          i32.add
          local.set $w690
          br $while_694_lp
        else
          br $while_694_exit
        end
      end
    end
    local.get $w689
    i32.const 0
    array.get $GcArray_41
  )
  (func $closure_227 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
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
  (func $testArraySortWithDesc (result i32) ;; exported as "testArraySortWithDesc"
    (local $w696 (ref $GcArray_41))
    (local $w697 i32)
    (local $w698 (ref $GcArray_41))
    (local $w699 i32)
    (local $w700 i32)
    (local $w701 i32)
    (local $a i32)
    i32.const 3
    i32.const 1
    i32.const 4
    i32.const 2
    array.new_fixed $GcArray_41 4
    local.set $w696
    local.get $w696
    array.len
    local.set $w697
    i32.const 0
    local.get $w697
    array.new $GcArray_41
    local.set $w698
    local.get $w698
    i32.const 0
    local.get $w696
    i32.const 0
    local.get $w697
    array.copy $GcArray_41 $GcArray_41
    i32.const 1
    local.set $w699
    block $while_703_exit
      loop $while_703_lp
        local.get $w699
        local.get $w697
        i32.lt_s
        if
          local.get $w698
          local.get $w699
          array.get $GcArray_41
          local.set $w700
          local.get $w699
          i32.const 1
          i32.sub
          local.set $w701
          block $while_702_exit
            loop $while_702_lp
              local.get $w701
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w698
                local.get $w701
                array.get $GcArray_41
                local.set $a
                local.get $w700
                local.get $a
                i32.lt_s
                if (result i32)
                  i32.const -1
                else
                  local.get $w700
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
                local.get $w698
                local.get $w701
                i32.const 1
                i32.add
                local.get $w698
                local.get $w701
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w701
                i32.const 1
                i32.sub
                local.set $w701
                br $while_702_lp
              else
                br $while_702_exit
              end
            end
          end
          local.get $w698
          local.get $w701
          i32.const 1
          i32.add
          local.get $w700
          array.set $GcArray_41
          local.get $w699
          i32.const 1
          i32.add
          local.set $w699
          br $while_703_lp
        else
          br $while_703_exit
        end
      end
    end
    local.get $w698
    i32.const 0
    array.get $GcArray_41
  )
  (func $testListZip (result i32) ;; exported as "testListZip"
    (local $patternInput (ref $Tuple_15))
    (local $w705 (ref null $ListBase))
    (local $w706 (ref null $ListBase))
    (local $w707 (ref null $ListBase))
    (local $w709 (ref null $ListBase))
    (local $w710 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w705
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w706
    ref.null $ListBase
    local.set $w707
    block $while_708_exit
      loop $while_708_lp
        local.get $w705
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w706
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w705
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w706
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          struct.new $Tuple_15
          local.get $w707
          struct.new $ListCons_16
          local.set $w707
          local.get $w705
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w705
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
    local.set $w709
    ref.null $ListBase
    local.set $w710
    block $while_711_exit
      loop $while_711_lp
        local.get $w709
        ref.is_null
        i32.eqz
        if
          local.get $w709
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 0
          local.get $w710
          struct.new $ListCons_16
          local.set $w710
          local.get $w709
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w709
          br $while_711_lp
        else
          br $while_711_exit
        end
      end
    end
    local.get $w710
    ref.cast (ref $ListCons_16)
    struct.get $ListCons_16 0
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_15 0
    local.get $patternInput
    struct.get $Tuple_15 1
    i32.add
  )
  (func $testListZipLen (result i32) ;; exported as "testListZipLen"
    (local $w721 (ref null $ListBase))
    (local $w713 (ref null $ListBase))
    (local $w714 (ref null $ListBase))
    (local $w715 (ref null $ListBase))
    (local $w717 (ref null $ListBase))
    (local $w718 (ref null $ListBase))
    (local $w722 i32)
    i32.const 97
    i32.const 98
    i32.const 99
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w713
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w714
    ref.null $ListBase
    local.set $w715
    block $while_716_exit
      loop $while_716_lp
        local.get $w713
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w714
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w713
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w714
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          struct.new $Tuple_15
          local.get $w715
          struct.new $ListCons_16
          local.set $w715
          local.get $w713
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w713
          local.get $w714
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w714
          br $while_716_lp
        else
          br $while_716_exit
        end
      end
    end
    local.get $w715
    local.set $w717
    ref.null $ListBase
    local.set $w718
    block $while_719_exit
      loop $while_719_lp
        local.get $w717
        ref.is_null
        i32.eqz
        if
          local.get $w717
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 0
          local.get $w718
          struct.new $ListCons_16
          local.set $w718
          local.get $w717
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w717
          br $while_719_lp
        else
          br $while_719_exit
        end
      end
    end
    local.get $w718
    local.set $w721
    i32.const 0
    local.set $w722
    block $while_723_exit
      loop $while_723_lp
        local.get $w721
        ref.is_null
        i32.eqz
        if
          local.get $w722
          i32.const 1
          i32.add
          local.set $w722
          local.get $w721
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w721
          br $while_723_lp
        else
          br $while_723_exit
        end
      end
    end
    local.get $w722
  )
  (func $closure_228 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_229 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListMap2Sum (result i32) ;; exported as "testListMap2Sum"
    (local $w733 (ref null $ListBase))
    (local $w725 (ref null $ListBase))
    (local $w726 (ref null $ListBase))
    (local $w727 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w729 (ref null $ListBase))
    (local $w730 (ref null $ListBase))
    (local $w734 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w725
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w726
    ref.null $ListBase
    local.set $w727
    block $while_728_exit
      loop $while_728_lp
        local.get $w725
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w726
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w725
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $a
          local.get $w726
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $a
          local.get $b
          i32.add
          local.get $w727
          struct.new $ListCons_30
          local.set $w727
          local.get $w725
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w725
          local.get $w726
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w726
          br $while_728_lp
        else
          br $while_728_exit
        end
      end
    end
    local.get $w727
    local.set $w729
    ref.null $ListBase
    local.set $w730
    block $while_731_exit
      loop $while_731_lp
        local.get $w729
        ref.is_null
        i32.eqz
        if
          local.get $w729
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w730
          struct.new $ListCons_30
          local.set $w730
          local.get $w729
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w729
          br $while_731_lp
        else
          br $while_731_exit
        end
      end
    end
    local.get $w730
    local.set $w733
    i32.const 0
    local.set $w734
    block $while_735_exit
      loop $while_735_lp
        local.get $w733
        ref.is_null
        i32.eqz
        if
          local.get $w734
          local.get $w733
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w734
          local.get $w733
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w733
          br $while_735_lp
        else
          br $while_735_exit
        end
      end
    end
    local.get $w734
  )
  (func $closure_230 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.mul
  )
  (func $testListMap2Head (result i32) ;; exported as "testListMap2Head"
    (local $w737 (ref null $ListBase))
    (local $w738 (ref null $ListBase))
    (local $w739 (ref null $ListBase))
    (local $a i32)
    (local $b i32)
    (local $w741 (ref null $ListBase))
    (local $w742 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w737
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w738
    ref.null $ListBase
    local.set $w739
    block $while_740_exit
      loop $while_740_lp
        local.get $w737
        ref.is_null
        i32.eqz
        if (result i32)
          local.get $w738
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w737
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $a
          local.get $w738
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          local.get $w739
          struct.new $ListCons_30
          local.set $w739
          local.get $w737
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w737
          local.get $w738
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w738
          br $while_740_lp
        else
          br $while_740_exit
        end
      end
    end
    local.get $w739
    local.set $w741
    ref.null $ListBase
    local.set $w742
    block $while_743_exit
      loop $while_743_lp
        local.get $w741
        ref.is_null
        i32.eqz
        if
          local.get $w741
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w742
          struct.new $ListCons_30
          local.set $w742
          local.get $w741
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w741
          br $while_743_lp
        else
          br $while_743_exit
        end
      end
    end
    local.get $w742
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testArrayZip (result i32) ;; exported as "testArrayZip"
    (local $patternInput (ref $Tuple_15))
    (local $w745 (ref $GcArray_41))
    (local $w746 (ref $GcArray_41))
    (local $w747 (ref $GcArray_231))
    (local $w748 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w745
    i32.const 10
    i32.const 20
    i32.const 30
    array.new_fixed $GcArray_41 3
    local.set $w746
    i32.const 0
    i32.const 0
    struct.new $Tuple_15
    local.get $w745
    array.len
    array.new $GcArray_231
    local.set $w747
    i32.const 0
    local.set $w748
    block $while_749_exit
      loop $while_749_lp
        local.get $w748
        local.get $w745
        array.len
        i32.lt_s
        if
          local.get $w747
          local.get $w748
          local.get $w745
          local.get $w748
          array.get $GcArray_41
          local.get $w746
          local.get $w748
          array.get $GcArray_41
          struct.new $Tuple_15
          array.set $GcArray_231
          local.get $w748
          i32.const 1
          i32.add
          local.set $w748
          br $while_749_lp
        else
          br $while_749_exit
        end
      end
    end
    local.get $w747
    i32.const 0
    array.get $GcArray_231
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_15 0
    local.get $patternInput
    struct.get $Tuple_15 1
    i32.add
  )
  (func $testArrayZipLen (result i32) ;; exported as "testArrayZipLen"
    (local $zipped (ref $GcArray_231))
    (local $w751 (ref $GcArray_41))
    (local $w752 (ref $GcArray_41))
    (local $w753 (ref $GcArray_231))
    (local $w754 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w751
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_41 3
    local.set $w752
    i32.const 0
    i32.const 0
    struct.new $Tuple_15
    local.get $w751
    array.len
    array.new $GcArray_231
    local.set $w753
    i32.const 0
    local.set $w754
    block $while_755_exit
      loop $while_755_lp
        local.get $w754
        local.get $w751
        array.len
        i32.lt_s
        if
          local.get $w753
          local.get $w754
          local.get $w751
          local.get $w754
          array.get $GcArray_41
          local.get $w752
          local.get $w754
          array.get $GcArray_41
          struct.new $Tuple_15
          array.set $GcArray_231
          local.get $w754
          i32.const 1
          i32.add
          local.set $w754
          br $while_755_lp
        else
          br $while_755_exit
        end
      end
    end
    local.get $w753
    local.set $zipped
    local.get $zipped
    array.len
  )
  (func $closure_232 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add
  )
  (func $closure_233 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_234 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add
  )
  (func $testArrayMap2Sum (result i32) ;; exported as "testArrayMap2Sum"
    (local $w771 (ref $GcArray_41))
    (local $w765 (ref $GcArray_41))
    (local $w766 (ref $GcArray_41))
    (local $w767 i32)
    (local $w768 (ref $GcArray_41))
    (local $w769 i32)
    (local $a i32)
    (local $b i32)
    (local $w772 i32)
    (local $w773 i32)
    (local $w774 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w765
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_41 3
    local.set $w766
    local.get $w765
    array.len
    local.set $w767
    i32.const 0
    local.get $w767
    array.new $GcArray_41
    local.set $w768
    i32.const 0
    local.set $w769
    block $while_770_exit
      loop $while_770_lp
        local.get $w769
        local.get $w767
        i32.lt_s
        if
          local.get $w768
          local.get $w769
          local.get $w765
          local.get $w769
          array.get $GcArray_41
          local.set $a
          local.get $w766
          local.get $w769
          array.get $GcArray_41
          local.set $b
          local.get $a
          local.get $b
          i32.add
          array.set $GcArray_41
          local.get $w769
          i32.const 1
          i32.add
          local.set $w769
          br $while_770_lp
        else
          br $while_770_exit
        end
      end
    end
    local.get $w768
    local.set $w771
    local.get $w771
    array.len
    local.set $w772
    i32.const 0
    local.set $w773
    i32.const 0
    local.set $w774
    block $while_775_exit
      loop $while_775_lp
        local.get $w774
        local.get $w772
        i32.lt_s
        if
          local.get $w773
          local.get $w771
          local.get $w774
          array.get $GcArray_41
          i32.add
          local.set $w773
          local.get $w774
          i32.const 1
          i32.add
          local.set $w774
          br $while_775_lp
        else
          br $while_775_exit
        end
      end
    end
    local.get $w773
  )
  (func $closure_235 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.mul
  )
  (func $testArrayMap2Head (result i32) ;; exported as "testArrayMap2Head"
    (local $w777 (ref $GcArray_41))
    (local $w778 (ref $GcArray_41))
    (local $w779 i32)
    (local $w780 (ref $GcArray_41))
    (local $w781 i32)
    (local $a i32)
    (local $b i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w777
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_41 3
    local.set $w778
    local.get $w777
    array.len
    local.set $w779
    i32.const 0
    local.get $w779
    array.new $GcArray_41
    local.set $w780
    i32.const 0
    local.set $w781
    block $while_782_exit
      loop $while_782_lp
        local.get $w781
        local.get $w779
        i32.lt_s
        if
          local.get $w780
          local.get $w781
          local.get $w777
          local.get $w781
          array.get $GcArray_41
          local.set $a
          local.get $w778
          local.get $w781
          array.get $GcArray_41
          local.set $b
          local.get $a
          local.get $b
          i32.mul
          array.set $GcArray_41
          local.get $w781
          i32.const 1
          i32.add
          local.set $w781
          br $while_782_lp
        else
          br $while_782_exit
        end
      end
    end
    local.get $w780
    i32.const 0
    array.get $GcArray_41
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
  (func $testPowF64_2_10 (result i32) ;; exported as "testPowF64_2_10"
    f64.const 2
    f64.const 10
    call $powF64
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testPowF64_zero (result i32) ;; exported as "testPowF64_zero"
    f64.const 3
    f64.const 0
    call $powF64
    i32.trunc_f64_s
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
  )
  (func $testPowF64_cube (result i32) ;; exported as "testPowF64_cube"
    f64.const 5
    f64.const 3
    call $powF64
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
  (func $testRefTestCircle (result i32) ;; exported as "testRefTestCircle"
    (local $s (ref $QuickTestWasmGc_Preamble_GeoShape))
    i32.const 0
    f64.const 5
    struct.new $QuickTestWasmGc_Preamble_GeoShape#0
    local.set $s
    local.get $s
    struct.get $QuickTestWasmGc_Preamble_GeoShape 0
    i32.const 0
    i32.eq
    if (result i32)
      local.get $s
      ref.cast (ref $QuickTestWasmGc_Preamble_GeoShape#0)
      struct.get $QuickTestWasmGc_Preamble_GeoShape#0 1
      i32.trunc_f64_s
      i32.const -1
      i32.xor
      i32.const -1
      i32.xor
    else
      i32.const 0
    end
  )
  (func $testRefTestRect (result i32) ;; exported as "testRefTestRect"
    (local $s (ref $QuickTestWasmGc_Preamble_GeoShape))
    i32.const 1
    f64.const 3
    f64.const 4
    struct.new $QuickTestWasmGc_Preamble_GeoShape#1
    local.set $s
    local.get $s
    struct.get $QuickTestWasmGc_Preamble_GeoShape 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $s
      ref.cast (ref $QuickTestWasmGc_Preamble_GeoShape#1)
      struct.get $QuickTestWasmGc_Preamble_GeoShape#1 1
      local.get $s
      ref.cast (ref $QuickTestWasmGc_Preamble_GeoShape#1)
      struct.get $QuickTestWasmGc_Preamble_GeoShape#1 2
      f64.mul
      i32.trunc_f64_s
      i32.const -1
      i32.xor
      i32.const -1
      i32.xor
    else
      i32.const 0
    end
  )
  (func $testRefTestDot (result i32) ;; exported as "testRefTestDot"
    i32.const 42
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
  (func $testSbLength (result i32) ;; exported as "testSbLength"
    (local $sb (ref $StringBuilder))
    i32.const 16
    call $sbCreate
    local.set $sb
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    drop
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $testSbAppendTwo (result i32) ;; exported as "testSbAppendTwo"
    (local $sb (ref $StringBuilder))
    i32.const 16
    call $sbCreate
    local.set $sb
    local.get $sb
    i32.const 102
    i32.const 111
    i32.const 111
    array.new_fixed $WasmStr 3
    call $sbAppend
    drop
    local.get $sb
    i32.const 98
    i32.const 97
    i32.const 114
    array.new_fixed $WasmStr 3
    call $sbAppend
    drop
    local.get $sb
    struct.get $StringBuilder 1
  )
  (func $testSbToStringLength (result i32) ;; exported as "testSbToStringLength"
    (local $sb (ref $StringBuilder))
    (local $s (ref $WasmStr))
    i32.const 16
    call $sbCreate
    local.set $sb
    local.get $sb
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    call $sbAppend
    drop
    local.get $sb
    call $sbToString
    local.set $s
    local.get $s
    array.len
  )
  (func $testSbGrow (result i32) ;; exported as "testSbGrow"
    (local $sb (ref $StringBuilder))
    (local $forLoopVar i32)
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
        local.get $sb
        i32.const 120
        array.new_fixed $WasmStr 1
        call $sbAppend
        drop
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
  (func $testSbToStringContent (result i32) ;; exported as "testSbToStringContent"
    (local $sb (ref $StringBuilder))
    i32.const 16
    call $sbCreate
    local.set $sb
    local.get $sb
    i32.const 104
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    array.new_fixed $WasmStr 5
    call $sbAppend
    drop
    local.get $sb
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 6
    call $sbAppend
    drop
    local.get $sb
    call $sbToString
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
  (func $testSbChained (result i32) ;; exported as "testSbChained"
    (local $sb (ref $StringBuilder))
    i32.const 16
    call $sbCreate
    local.set $sb
    local.get $sb
    i32.const 97
    array.new_fixed $WasmStr 1
    call $sbAppend
    drop
    local.get $sb
    i32.const 98
    array.new_fixed $WasmStr 1
    call $sbAppend
    drop
    local.get $sb
    i32.const 99
    array.new_fixed $WasmStr 1
    call $sbAppend
    drop
    local.get $sb
    i32.const 100
    array.new_fixed $WasmStr 1
    call $sbAppend
    drop
    local.get $sb
    i32.const 101
    array.new_fixed $WasmStr 1
    call $sbAppend
    drop
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
  (func $testAtan2Origin (result i32) ;; exported as "testAtan2Origin"
    f64.const 0
    f64.const 1
    call $mathAtan2
    return_call $roundTo6
  )
  (func $testAtan2PosX (result i32) ;; exported as "testAtan2PosX"
    f64.const 1
    f64.const 1
    call $mathAtan2
    return_call $roundTo6
  )
  (func $testAtan2NegX (result i32) ;; exported as "testAtan2NegX"
    f64.const 0
    f64.const -1
    call $mathAtan2
    return_call $roundTo6
  )
  (func $testAtan2PosY (result i32) ;; exported as "testAtan2PosY"
    f64.const 1
    f64.const 0
    call $mathAtan2
    return_call $roundTo6
  )
  (func $testAtan2NegY (result i32) ;; exported as "testAtan2NegY"
    f64.const -1
    f64.const 0
    call $mathAtan2
    return_call $roundTo6
  )
  (func $testAtan2Q3 (result i32) ;; exported as "testAtan2Q3"
    f64.const -1
    f64.const -1
    call $mathAtan2
    return_call $roundTo6
  )
  (func $closure_241 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionCounts (result i32) ;; exported as "testListPartitionCounts"
    (local $patternInput (ref $Tuple_240))
    (local $w784 (ref null $ListBase))
    (local $w785 (ref null $ListBase))
    (local $w786 (ref null $ListBase))
    (local $w787 i32)
    (local $w789 (ref null $ListBase))
    (local $w790 (ref null $ListBase))
    (local $w792 (ref null $ListBase))
    (local $w793 (ref null $ListBase))
    (local $w796 (ref null $ListBase))
    (local $w797 i32)
    (local $w800 (ref null $ListBase))
    (local $w801 i32)
    ref.null $ListBase
    local.set $w784
    ref.null $ListBase
    local.set $w785
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
    local.set $w786
    block $while_788_exit
      loop $while_788_lp
        local.get $w786
        ref.is_null
        i32.eqz
        if
          local.get $w786
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w787
          local.get $w787
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w787
            local.get $w784
            struct.new $ListCons_30
            local.set $w784
          else
            local.get $w787
            local.get $w785
            struct.new $ListCons_30
            local.set $w785
          end
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
    local.get $w784
    local.set $w789
    ref.null $ListBase
    local.set $w790
    block $while_791_exit
      loop $while_791_lp
        local.get $w789
        ref.is_null
        i32.eqz
        if
          local.get $w789
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w790
          struct.new $ListCons_30
          local.set $w790
          local.get $w789
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w789
          br $while_791_lp
        else
          br $while_791_exit
        end
      end
    end
    local.get $w790
    local.get $w785
    local.set $w792
    ref.null $ListBase
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
          local.get $w793
          struct.new $ListCons_30
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
    struct.new $Tuple_240
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_240 0
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
          i32.const 1
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
    i32.const 10
    i32.mul
    local.get $patternInput
    struct.get $Tuple_240 1
    local.set $w800
    i32.const 0
    local.set $w801
    block $while_802_exit
      loop $while_802_lp
        local.get $w800
        ref.is_null
        i32.eqz
        if
          local.get $w801
          i32.const 1
          i32.add
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
    i32.add
  )
  (func $closure_242 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_243 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionEvens (result i32) ;; exported as "testListPartitionEvens"
    (local $w816 (ref null $ListBase))
    (local $w804 (ref null $ListBase))
    (local $w805 (ref null $ListBase))
    (local $w806 (ref null $ListBase))
    (local $w807 i32)
    (local $w809 (ref null $ListBase))
    (local $w810 (ref null $ListBase))
    (local $w812 (ref null $ListBase))
    (local $w813 (ref null $ListBase))
    (local $w817 i32)
    ref.null $ListBase
    local.set $w804
    ref.null $ListBase
    local.set $w805
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
    local.set $w806
    block $while_808_exit
      loop $while_808_lp
        local.get $w806
        ref.is_null
        i32.eqz
        if
          local.get $w806
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w807
          local.get $w807
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w807
            local.get $w804
            struct.new $ListCons_30
            local.set $w804
          else
            local.get $w807
            local.get $w805
            struct.new $ListCons_30
            local.set $w805
          end
          local.get $w806
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w806
          br $while_808_lp
        else
          br $while_808_exit
        end
      end
    end
    local.get $w804
    local.set $w809
    ref.null $ListBase
    local.set $w810
    block $while_811_exit
      loop $while_811_lp
        local.get $w809
        ref.is_null
        i32.eqz
        if
          local.get $w809
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w810
          struct.new $ListCons_30
          local.set $w810
          local.get $w809
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w809
          br $while_811_lp
        else
          br $while_811_exit
        end
      end
    end
    local.get $w810
    local.get $w805
    local.set $w812
    ref.null $ListBase
    local.set $w813
    block $while_814_exit
      loop $while_814_lp
        local.get $w812
        ref.is_null
        i32.eqz
        if
          local.get $w812
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w813
          struct.new $ListCons_30
          local.set $w813
          local.get $w812
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w812
          br $while_814_lp
        else
          br $while_814_exit
        end
      end
    end
    local.get $w813
    struct.new $Tuple_240
    struct.get $Tuple_240 0
    local.set $w816
    i32.const 0
    local.set $w817
    block $while_818_exit
      loop $while_818_lp
        local.get $w816
        ref.is_null
        i32.eqz
        if
          local.get $w817
          local.get $w816
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w817
          local.get $w816
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w816
          br $while_818_lp
        else
          br $while_818_exit
        end
      end
    end
    local.get $w817
  )
  (func $closure_244 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_245 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListPartitionOdds (result i32) ;; exported as "testListPartitionOdds"
    (local $w832 (ref null $ListBase))
    (local $w820 (ref null $ListBase))
    (local $w821 (ref null $ListBase))
    (local $w822 (ref null $ListBase))
    (local $w823 i32)
    (local $w825 (ref null $ListBase))
    (local $w826 (ref null $ListBase))
    (local $w828 (ref null $ListBase))
    (local $w829 (ref null $ListBase))
    (local $w833 i32)
    ref.null $ListBase
    local.set $w820
    ref.null $ListBase
    local.set $w821
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
    local.set $w822
    block $while_824_exit
      loop $while_824_lp
        local.get $w822
        ref.is_null
        i32.eqz
        if
          local.get $w822
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w823
          local.get $w823
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w823
            local.get $w820
            struct.new $ListCons_30
            local.set $w820
          else
            local.get $w823
            local.get $w821
            struct.new $ListCons_30
            local.set $w821
          end
          local.get $w822
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w822
          br $while_824_lp
        else
          br $while_824_exit
        end
      end
    end
    local.get $w820
    local.set $w825
    ref.null $ListBase
    local.set $w826
    block $while_827_exit
      loop $while_827_lp
        local.get $w825
        ref.is_null
        i32.eqz
        if
          local.get $w825
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w826
          struct.new $ListCons_30
          local.set $w826
          local.get $w825
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w825
          br $while_827_lp
        else
          br $while_827_exit
        end
      end
    end
    local.get $w826
    local.get $w821
    local.set $w828
    ref.null $ListBase
    local.set $w829
    block $while_830_exit
      loop $while_830_lp
        local.get $w828
        ref.is_null
        i32.eqz
        if
          local.get $w828
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w829
          struct.new $ListCons_30
          local.set $w829
          local.get $w828
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w828
          br $while_830_lp
        else
          br $while_830_exit
        end
      end
    end
    local.get $w829
    struct.new $Tuple_240
    struct.get $Tuple_240 1
    local.set $w832
    i32.const 0
    local.set $w833
    block $while_834_exit
      loop $while_834_lp
        local.get $w832
        ref.is_null
        i32.eqz
        if
          local.get $w833
          local.get $w832
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w833
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
  )
  (func $closure_246 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionEmpty (result i32) ;; exported as "testListPartitionEmpty"
    (local $patternInput (ref $Tuple_240))
    (local $w836 (ref null $ListBase))
    (local $w837 (ref null $ListBase))
    (local $w838 (ref null $ListBase))
    (local $w839 i32)
    (local $w841 (ref null $ListBase))
    (local $w842 (ref null $ListBase))
    (local $w844 (ref null $ListBase))
    (local $w845 (ref null $ListBase))
    (local $w848 (ref null $ListBase))
    (local $w849 i32)
    (local $w852 (ref null $ListBase))
    (local $w853 i32)
    ref.null $ListBase
    local.set $w836
    ref.null $ListBase
    local.set $w837
    ref.null $ListBase
    local.set $w838
    block $while_840_exit
      loop $while_840_lp
        local.get $w838
        ref.is_null
        i32.eqz
        if
          local.get $w838
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w839
          local.get $w839
          i32.const 0
          i32.gt_s
          if
            local.get $w839
            local.get $w836
            struct.new $ListCons_30
            local.set $w836
          else
            local.get $w839
            local.get $w837
            struct.new $ListCons_30
            local.set $w837
          end
          local.get $w838
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w838
          br $while_840_lp
        else
          br $while_840_exit
        end
      end
    end
    local.get $w836
    local.set $w841
    ref.null $ListBase
    local.set $w842
    block $while_843_exit
      loop $while_843_lp
        local.get $w841
        ref.is_null
        i32.eqz
        if
          local.get $w841
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w842
          struct.new $ListCons_30
          local.set $w842
          local.get $w841
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w841
          br $while_843_lp
        else
          br $while_843_exit
        end
      end
    end
    local.get $w842
    local.get $w837
    local.set $w844
    ref.null $ListBase
    local.set $w845
    block $while_846_exit
      loop $while_846_lp
        local.get $w844
        ref.is_null
        i32.eqz
        if
          local.get $w844
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w845
          struct.new $ListCons_30
          local.set $w845
          local.get $w844
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w844
          br $while_846_lp
        else
          br $while_846_exit
        end
      end
    end
    local.get $w845
    struct.new $Tuple_240
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_240 0
    local.set $w848
    i32.const 0
    local.set $w849
    block $while_850_exit
      loop $while_850_lp
        local.get $w848
        ref.is_null
        i32.eqz
        if
          local.get $w849
          i32.const 1
          i32.add
          local.set $w849
          local.get $w848
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w848
          br $while_850_lp
        else
          br $while_850_exit
        end
      end
    end
    local.get $w849
    local.get $patternInput
    struct.get $Tuple_240 1
    local.set $w852
    i32.const 0
    local.set $w853
    block $while_854_exit
      loop $while_854_lp
        local.get $w852
        ref.is_null
        i32.eqz
        if
          local.get $w853
          i32.const 1
          i32.add
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
    i32.add
  )
  (func $closure_247 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testListPartitionAllTrue (result i32) ;; exported as "testListPartitionAllTrue"
    (local $patternInput (ref $Tuple_240))
    (local $w856 (ref null $ListBase))
    (local $w857 (ref null $ListBase))
    (local $w858 (ref null $ListBase))
    (local $w859 i32)
    (local $w861 (ref null $ListBase))
    (local $w862 (ref null $ListBase))
    (local $w864 (ref null $ListBase))
    (local $w865 (ref null $ListBase))
    (local $w868 (ref null $ListBase))
    (local $w869 i32)
    (local $w872 (ref null $ListBase))
    (local $w873 i32)
    ref.null $ListBase
    local.set $w856
    ref.null $ListBase
    local.set $w857
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w858
    block $while_860_exit
      loop $while_860_lp
        local.get $w858
        ref.is_null
        i32.eqz
        if
          local.get $w858
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w859
          local.get $w859
          i32.const 0
          i32.gt_s
          if
            local.get $w859
            local.get $w856
            struct.new $ListCons_30
            local.set $w856
          else
            local.get $w859
            local.get $w857
            struct.new $ListCons_30
            local.set $w857
          end
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
    local.get $w856
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
    local.get $w857
    local.set $w864
    ref.null $ListBase
    local.set $w865
    block $while_866_exit
      loop $while_866_lp
        local.get $w864
        ref.is_null
        i32.eqz
        if
          local.get $w864
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w865
          struct.new $ListCons_30
          local.set $w865
          local.get $w864
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w864
          br $while_866_lp
        else
          br $while_866_exit
        end
      end
    end
    local.get $w865
    struct.new $Tuple_240
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_240 0
    local.set $w868
    i32.const 0
    local.set $w869
    block $while_870_exit
      loop $while_870_lp
        local.get $w868
        ref.is_null
        i32.eqz
        if
          local.get $w869
          i32.const 1
          i32.add
          local.set $w869
          local.get $w868
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w868
          br $while_870_lp
        else
          br $while_870_exit
        end
      end
    end
    local.get $w869
    i32.const 10
    i32.mul
    local.get $patternInput
    struct.get $Tuple_240 1
    local.set $w872
    i32.const 0
    local.set $w873
    block $while_874_exit
      loop $while_874_lp
        local.get $w872
        ref.is_null
        i32.eqz
        if
          local.get $w873
          i32.const 1
          i32.add
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
    i32.add
  )
  (func $closure_248 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testListPartitionOrder (result i32) ;; exported as "testListPartitionOrder"
    (local $w876 (ref null $ListBase))
    (local $w877 (ref null $ListBase))
    (local $w878 (ref null $ListBase))
    (local $w879 i32)
    (local $w881 (ref null $ListBase))
    (local $w882 (ref null $ListBase))
    (local $w884 (ref null $ListBase))
    (local $w885 (ref null $ListBase))
    ref.null $ListBase
    local.set $w876
    ref.null $ListBase
    local.set $w877
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
    local.set $w878
    block $while_880_exit
      loop $while_880_lp
        local.get $w878
        ref.is_null
        i32.eqz
        if
          local.get $w878
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w879
          local.get $w879
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w879
            local.get $w876
            struct.new $ListCons_30
            local.set $w876
          else
            local.get $w879
            local.get $w877
            struct.new $ListCons_30
            local.set $w877
          end
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
    local.get $w876
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
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w882
          struct.new $ListCons_30
          local.set $w882
          local.get $w881
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w881
          br $while_883_lp
        else
          br $while_883_exit
        end
      end
    end
    local.get $w882
    local.get $w877
    local.set $w884
    ref.null $ListBase
    local.set $w885
    block $while_886_exit
      loop $while_886_lp
        local.get $w884
        ref.is_null
        i32.eqz
        if
          local.get $w884
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w885
          struct.new $ListCons_30
          local.set $w885
          local.get $w884
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w884
          br $while_886_lp
        else
          br $while_886_exit
        end
      end
    end
    local.get $w885
    struct.new $Tuple_240
    struct.get $Tuple_240 0
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_249 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_12))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_12))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $closure_250 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_251 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_12))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_12))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $testArrayChooseBasic (result i32) ;; exported as "testArrayChooseBasic"
    (local $w912 (ref $GcArray_41))
    (local $w901 (ref $GcArray_41))
    (local $w906 i32)
    (local $w902 i32)
    (local $w903 i32)
    (local $x i32)
    (local $w904 (ref null $Option_12))
    (local $w907 (ref $GcArray_41))
    (local $w908 i32)
    (local $w909 i32)
    (local $w910 (ref null $Option_12))
    (local $w913 i32)
    (local $w914 i32)
    (local $w915 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_41 5
    local.set $w901
    i32.const 0
    local.set $w902
    i32.const 0
    local.set $w903
    block $while_905_exit
      loop $while_905_lp
        local.get $w903
        local.get $w901
        array.len
        i32.lt_s
        if
          local.get $w901
          local.get $w903
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_12))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_12
          else
            ref.null $Option_12
          end
          local.set $w904
          local.get $w904
          ref.is_null
          i32.eqz
          if
            local.get $w902
            i32.const 1
            i32.add
            local.set $w902
          end
          local.get $w903
          i32.const 1
          i32.add
          local.set $w903
          br $while_905_lp
        else
          br $while_905_exit
        end
      end
    end
    local.get $w902
    local.set $w906
    i32.const 0
    local.get $w906
    array.new $GcArray_41
    local.set $w907
    i32.const 0
    local.set $w908
    i32.const 0
    local.set $w909
    block $while_911_exit
      loop $while_911_lp
        local.get $w909
        local.get $w901
        array.len
        i32.lt_s
        if
          local.get $w901
          local.get $w909
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_12))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_12
          else
            ref.null $Option_12
          end
          local.set $w910
          local.get $w910
          ref.is_null
          i32.eqz
          if
            local.get $w907
            local.get $w908
            local.get $w910
            ref.cast (ref $Option_12)
            struct.get $Option_12 0
            array.set $GcArray_41
            local.get $w908
            i32.const 1
            i32.add
            local.set $w908
          end
          local.get $w909
          i32.const 1
          i32.add
          local.set $w909
          br $while_911_lp
        else
          br $while_911_exit
        end
      end
    end
    local.get $w907
    local.set $w912
    local.get $w912
    array.len
    local.set $w913
    i32.const 0
    local.set $w914
    i32.const 0
    local.set $w915
    block $while_916_exit
      loop $while_916_lp
        local.get $w915
        local.get $w913
        i32.lt_s
        if
          local.get $w914
          local.get $w912
          local.get $w915
          array.get $GcArray_41
          i32.add
          local.set $w914
          local.get $w915
          i32.const 1
          i32.add
          local.set $w915
          br $while_916_lp
        else
          br $while_916_exit
        end
      end
    end
    local.get $w914
  )
  (func $closure_252 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_12))
    local.get $x
    i32.const 3
    i32.gt_s
    if (result (ref null $Option_12))
      local.get $x
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $testArrayChooseLength (result i32) ;; exported as "testArrayChooseLength"
    (local $result (ref $GcArray_41))
    (local $w918 (ref $GcArray_41))
    (local $w923 i32)
    (local $w919 i32)
    (local $w920 i32)
    (local $x i32)
    (local $w921 (ref null $Option_12))
    (local $w924 (ref $GcArray_41))
    (local $w925 i32)
    (local $w926 i32)
    (local $w927 (ref null $Option_12))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_41 6
    local.set $w918
    i32.const 0
    local.set $w919
    i32.const 0
    local.set $w920
    block $while_922_exit
      loop $while_922_lp
        local.get $w920
        local.get $w918
        array.len
        i32.lt_s
        if
          local.get $w918
          local.get $w920
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_12))
            local.get $x
            struct.new $Option_12
          else
            ref.null $Option_12
          end
          local.set $w921
          local.get $w921
          ref.is_null
          i32.eqz
          if
            local.get $w919
            i32.const 1
            i32.add
            local.set $w919
          end
          local.get $w920
          i32.const 1
          i32.add
          local.set $w920
          br $while_922_lp
        else
          br $while_922_exit
        end
      end
    end
    local.get $w919
    local.set $w923
    i32.const 0
    local.get $w923
    array.new $GcArray_41
    local.set $w924
    i32.const 0
    local.set $w925
    i32.const 0
    local.set $w926
    block $while_928_exit
      loop $while_928_lp
        local.get $w926
        local.get $w918
        array.len
        i32.lt_s
        if
          local.get $w918
          local.get $w926
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $Option_12))
            local.get $x
            struct.new $Option_12
          else
            ref.null $Option_12
          end
          local.set $w927
          local.get $w927
          ref.is_null
          i32.eqz
          if
            local.get $w924
            local.get $w925
            local.get $w927
            ref.cast (ref $Option_12)
            struct.get $Option_12 0
            array.set $GcArray_41
            local.get $w925
            i32.const 1
            i32.add
            local.set $w925
          end
          local.get $w926
          i32.const 1
          i32.add
          local.set $w926
          br $while_928_lp
        else
          br $while_928_exit
        end
      end
    end
    local.get $w924
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_253 (param $self (ref $AnyFn)) (param $_x i32) (result (ref null $Option_12))
    ref.null $Option_12
  )
  (func $testArrayChooseEmpty (result i32) ;; exported as "testArrayChooseEmpty"
    (local $result (ref $GcArray_41))
    (local $w930 (ref $GcArray_41))
    (local $w935 i32)
    (local $w931 i32)
    (local $w932 i32)
    (local $w936 (ref $GcArray_41))
    (local $w937 i32)
    (local $w938 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w930
    i32.const 0
    local.set $w931
    i32.const 0
    local.set $w932
    block $while_934_exit
      loop $while_934_lp
        local.get $w932
        local.get $w930
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w931
            i32.const 1
            i32.add
            local.set $w931
          end
          local.get $w932
          i32.const 1
          i32.add
          local.set $w932
          br $while_934_lp
        else
          br $while_934_exit
        end
      end
    end
    local.get $w931
    local.set $w935
    i32.const 0
    local.get $w935
    array.new $GcArray_41
    local.set $w936
    i32.const 0
    local.set $w937
    i32.const 0
    local.set $w938
    block $while_940_exit
      loop $while_940_lp
        local.get $w938
        local.get $w930
        array.len
        i32.lt_s
        if
          i32.const 1
          i32.eqz
          if
            local.get $w936
            local.get $w937
            ref.null $Option_12
            ref.cast (ref $Option_12)
            struct.get $Option_12 0
            array.set $GcArray_41
            local.get $w937
            i32.const 1
            i32.add
            local.set $w937
          end
          local.get $w938
          i32.const 1
          i32.add
          local.set $w938
          br $while_940_lp
        else
          br $while_940_exit
        end
      end
    end
    local.get $w936
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_254 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_12))
    local.get $x
    i32.const 10
    i32.add
    struct.new $Option_12
  )
  (func $testArrayChooseAllSome (result i32) ;; exported as "testArrayChooseAllSome"
    (local $result (ref $GcArray_41))
    (local $w942 (ref $GcArray_41))
    (local $w947 i32)
    (local $w943 i32)
    (local $w944 i32)
    (local $x i32)
    (local $w945 (ref null $Option_12))
    (local $w948 (ref $GcArray_41))
    (local $w949 i32)
    (local $w950 i32)
    (local $w951 (ref null $Option_12))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w942
    i32.const 0
    local.set $w943
    i32.const 0
    local.set $w944
    block $while_946_exit
      loop $while_946_lp
        local.get $w944
        local.get $w942
        array.len
        i32.lt_s
        if
          local.get $w942
          local.get $w944
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_12
          local.set $w945
          local.get $w945
          ref.is_null
          i32.eqz
          if
            local.get $w943
            i32.const 1
            i32.add
            local.set $w943
          end
          local.get $w944
          i32.const 1
          i32.add
          local.set $w944
          br $while_946_lp
        else
          br $while_946_exit
        end
      end
    end
    local.get $w943
    local.set $w947
    i32.const 0
    local.get $w947
    array.new $GcArray_41
    local.set $w948
    i32.const 0
    local.set $w949
    i32.const 0
    local.set $w950
    block $while_952_exit
      loop $while_952_lp
        local.get $w950
        local.get $w942
        array.len
        i32.lt_s
        if
          local.get $w942
          local.get $w950
          array.get $GcArray_41
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          struct.new $Option_12
          local.set $w951
          local.get $w951
          ref.is_null
          i32.eqz
          if
            local.get $w948
            local.get $w949
            local.get $w951
            ref.cast (ref $Option_12)
            struct.get $Option_12 0
            array.set $GcArray_41
            local.get $w949
            i32.const 1
            i32.add
            local.set $w949
          end
          local.get $w950
          i32.const 1
          i32.add
          local.set $w950
          br $while_952_lp
        else
          br $while_952_exit
        end
      end
    end
    local.get $w948
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_41
    local.get $result
    i32.const 1
    array.get $GcArray_41
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_41
    i32.add
  )
  (func $closure_255 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_41))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    array.new_fixed $GcArray_41 2
  )
  (func $closure_258 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_259 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_41))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    array.new_fixed $GcArray_41 2
  )
  (func $testArrayCollectBasic (result i32) ;; exported as "testArrayCollectBasic"
    (local $w978 (ref $GcArray_41))
    (local $w967 (ref $GcArray_41))
    (local $w972 i32)
    (local $w968 i32)
    (local $w969 i32)
    (local $x i32)
    (local $w970 (ref $GcArray_41))
    (local $w973 (ref $GcArray_41))
    (local $w974 i32)
    (local $w975 i32)
    (local $w976 (ref $GcArray_41))
    (local $w979 i32)
    (local $w980 i32)
    (local $w981 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w967
    i32.const 0
    local.set $w968
    i32.const 0
    local.set $w969
    block $while_971_exit
      loop $while_971_lp
        local.get $w969
        local.get $w967
        array.len
        i32.lt_s
        if
          local.get $w967
          local.get $w969
          array.get $GcArray_41
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_41 2
          local.set $w970
          local.get $w968
          local.get $w970
          array.len
          i32.add
          local.set $w968
          local.get $w969
          i32.const 1
          i32.add
          local.set $w969
          br $while_971_lp
        else
          br $while_971_exit
        end
      end
    end
    local.get $w968
    local.set $w972
    i32.const 0
    local.get $w972
    array.new $GcArray_41
    local.set $w973
    i32.const 0
    local.set $w974
    i32.const 0
    local.set $w975
    block $while_977_exit
      loop $while_977_lp
        local.get $w975
        local.get $w967
        array.len
        i32.lt_s
        if
          local.get $w967
          local.get $w975
          array.get $GcArray_41
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          array.new_fixed $GcArray_41 2
          local.set $w976
          local.get $w973
          local.get $w974
          local.get $w976
          i32.const 0
          local.get $w976
          array.len
          array.copy $GcArray_41 $GcArray_41
          local.get $w974
          local.get $w976
          array.len
          i32.add
          local.set $w974
          local.get $w975
          i32.const 1
          i32.add
          local.set $w975
          br $while_977_lp
        else
          br $while_977_exit
        end
      end
    end
    local.get $w973
    local.set $w978
    local.get $w978
    array.len
    local.set $w979
    i32.const 0
    local.set $w980
    i32.const 0
    local.set $w981
    block $while_982_exit
      loop $while_982_lp
        local.get $w981
        local.get $w979
        i32.lt_s
        if
          local.get $w980
          local.get $w978
          local.get $w981
          array.get $GcArray_41
          i32.add
          local.set $w980
          local.get $w981
          i32.const 1
          i32.add
          local.set $w981
          br $while_982_lp
        else
          br $while_982_exit
        end
      end
    end
    local.get $w980
  )
  (func $closure_260 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_41))
    local.get $x
    local.get $x
    array.new_fixed $GcArray_41 2
  )
  (func $testArrayCollectLength (result i32) ;; exported as "testArrayCollectLength"
    (local $result (ref $GcArray_41))
    (local $w984 (ref $GcArray_41))
    (local $w989 i32)
    (local $w985 i32)
    (local $w986 i32)
    (local $x i32)
    (local $w987 (ref $GcArray_41))
    (local $w990 (ref $GcArray_41))
    (local $w991 i32)
    (local $w992 i32)
    (local $w993 (ref $GcArray_41))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w984
    i32.const 0
    local.set $w985
    i32.const 0
    local.set $w986
    block $while_988_exit
      loop $while_988_lp
        local.get $w986
        local.get $w984
        array.len
        i32.lt_s
        if
          local.get $w984
          local.get $w986
          array.get $GcArray_41
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_41 2
          local.set $w987
          local.get $w985
          local.get $w987
          array.len
          i32.add
          local.set $w985
          local.get $w986
          i32.const 1
          i32.add
          local.set $w986
          br $while_988_lp
        else
          br $while_988_exit
        end
      end
    end
    local.get $w985
    local.set $w989
    i32.const 0
    local.get $w989
    array.new $GcArray_41
    local.set $w990
    i32.const 0
    local.set $w991
    i32.const 0
    local.set $w992
    block $while_994_exit
      loop $while_994_lp
        local.get $w992
        local.get $w984
        array.len
        i32.lt_s
        if
          local.get $w984
          local.get $w992
          array.get $GcArray_41
          local.set $x
          local.get $x
          local.get $x
          array.new_fixed $GcArray_41 2
          local.set $w993
          local.get $w990
          local.get $w991
          local.get $w993
          i32.const 0
          local.get $w993
          array.len
          array.copy $GcArray_41 $GcArray_41
          local.get $w991
          local.get $w993
          array.len
          i32.add
          local.set $w991
          local.get $w992
          i32.const 1
          i32.add
          local.set $w992
          br $while_994_lp
        else
          br $while_994_exit
        end
      end
    end
    local.get $w990
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_261 (param $self (ref $AnyFn)) (param $_x i32) (result (ref $GcArray_41))
    array.new_fixed $GcArray_41 0
  )
  (func $testArrayCollectEmpty (result i32) ;; exported as "testArrayCollectEmpty"
    (local $result (ref $GcArray_41))
    (local $w996 (ref $GcArray_41))
    (local $w1001 i32)
    (local $w997 i32)
    (local $w998 i32)
    (local $w999 (ref $GcArray_41))
    (local $w1002 (ref $GcArray_41))
    (local $w1003 i32)
    (local $w1004 i32)
    (local $w1005 (ref $GcArray_41))
    i32.const 1
    i32.const 2
    i32.const 3
    array.new_fixed $GcArray_41 3
    local.set $w996
    i32.const 0
    local.set $w997
    i32.const 0
    local.set $w998
    block $while_1000_exit
      loop $while_1000_lp
        local.get $w998
        local.get $w996
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_41 0
          local.set $w999
          local.get $w997
          local.get $w999
          array.len
          i32.add
          local.set $w997
          local.get $w998
          i32.const 1
          i32.add
          local.set $w998
          br $while_1000_lp
        else
          br $while_1000_exit
        end
      end
    end
    local.get $w997
    local.set $w1001
    i32.const 0
    local.get $w1001
    array.new $GcArray_41
    local.set $w1002
    i32.const 0
    local.set $w1003
    i32.const 0
    local.set $w1004
    block $while_1006_exit
      loop $while_1006_lp
        local.get $w1004
        local.get $w996
        array.len
        i32.lt_s
        if
          array.new_fixed $GcArray_41 0
          local.set $w1005
          local.get $w1002
          local.get $w1003
          local.get $w1005
          i32.const 0
          local.get $w1005
          array.len
          array.copy $GcArray_41 $GcArray_41
          local.get $w1003
          local.get $w1005
          array.len
          i32.add
          local.set $w1003
          local.get $w1004
          i32.const 1
          i32.add
          local.set $w1004
          br $while_1006_lp
        else
          br $while_1006_exit
        end
      end
    end
    local.get $w1002
    local.set $result
    local.get $result
    array.len
  )
  (func $closure_262 (param $self (ref $AnyFn)) (param $x i32) (result (ref $GcArray_41))
    local.get $x
    array.new_fixed $GcArray_41 1
  )
  (func $testArrayCollectSingleton (result i32) ;; exported as "testArrayCollectSingleton"
    (local $result (ref $GcArray_41))
    (local $w1008 (ref $GcArray_41))
    (local $w1013 i32)
    (local $w1009 i32)
    (local $w1010 i32)
    (local $x i32)
    (local $w1011 (ref $GcArray_41))
    (local $w1014 (ref $GcArray_41))
    (local $w1015 i32)
    (local $w1016 i32)
    (local $w1017 (ref $GcArray_41))
    i32.const 5
    i32.const 10
    i32.const 15
    array.new_fixed $GcArray_41 3
    local.set $w1008
    i32.const 0
    local.set $w1009
    i32.const 0
    local.set $w1010
    block $while_1012_exit
      loop $while_1012_lp
        local.get $w1010
        local.get $w1008
        array.len
        i32.lt_s
        if
          local.get $w1008
          local.get $w1010
          array.get $GcArray_41
          local.set $x
          local.get $x
          array.new_fixed $GcArray_41 1
          local.set $w1011
          local.get $w1009
          local.get $w1011
          array.len
          i32.add
          local.set $w1009
          local.get $w1010
          i32.const 1
          i32.add
          local.set $w1010
          br $while_1012_lp
        else
          br $while_1012_exit
        end
      end
    end
    local.get $w1009
    local.set $w1013
    i32.const 0
    local.get $w1013
    array.new $GcArray_41
    local.set $w1014
    i32.const 0
    local.set $w1015
    i32.const 0
    local.set $w1016
    block $while_1018_exit
      loop $while_1018_lp
        local.get $w1016
        local.get $w1008
        array.len
        i32.lt_s
        if
          local.get $w1008
          local.get $w1016
          array.get $GcArray_41
          local.set $x
          local.get $x
          array.new_fixed $GcArray_41 1
          local.set $w1017
          local.get $w1014
          local.get $w1015
          local.get $w1017
          i32.const 0
          local.get $w1017
          array.len
          array.copy $GcArray_41 $GcArray_41
          local.get $w1015
          local.get $w1017
          array.len
          i32.add
          local.set $w1015
          local.get $w1016
          i32.const 1
          i32.add
          local.set $w1016
          br $while_1018_lp
        else
          br $while_1018_exit
        end
      end
    end
    local.get $w1014
    local.set $result
    local.get $result
    i32.const 0
    array.get $GcArray_41
    local.get $result
    i32.const 1
    array.get $GcArray_41
    i32.add
    local.get $result
    i32.const 2
    array.get $GcArray_41
    i32.add
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
  (func $testListSortIntAsc (result i32) ;; exported as "testListSortIntAsc"
    (local $w1020 (ref null $ListBase))
    (local $w1024 i32)
    (local $w1021 (ref null $ListBase))
    (local $w1022 i32)
    (local $w1025 (ref $GcArray_41))
    (local $w1026 (ref null $ListBase))
    (local $w1027 i32)
    (local $w1029 i32)
    (local $w1030 i32)
    (local $w1031 i32)
    (local $w1034 i32)
    (local $w1035 (ref null $ListBase))
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
    local.set $w1020
    local.get $w1020
    local.set $w1021
    i32.const 0
    local.set $w1022
    block $while_1023_exit
      loop $while_1023_lp
        local.get $w1021
        ref.is_null
        i32.eqz
        if
          local.get $w1022
          i32.const 1
          i32.add
          local.set $w1022
          local.get $w1021
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1021
          br $while_1023_lp
        else
          br $while_1023_exit
        end
      end
    end
    local.get $w1022
    local.set $w1024
    i32.const 0
    local.get $w1024
    array.new $GcArray_41
    local.set $w1025
    local.get $w1020
    local.set $w1026
    i32.const 0
    local.set $w1027
    block $while_1028_exit
      loop $while_1028_lp
        local.get $w1026
        ref.is_null
        i32.eqz
        if
          local.get $w1025
          local.get $w1027
          local.get $w1026
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          array.set $GcArray_41
          local.get $w1027
          i32.const 1
          i32.add
          local.set $w1027
          local.get $w1026
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1026
          br $while_1028_lp
        else
          br $while_1028_exit
        end
      end
    end
    local.get $w1027
    drop
    i32.const 1
    local.set $w1029
    block $while_1033_exit
      loop $while_1033_lp
        local.get $w1029
        local.get $w1024
        i32.lt_s
        if
          local.get $w1025
          local.get $w1029
          array.get $GcArray_41
          local.set $w1030
          local.get $w1029
          i32.const 1
          i32.sub
          local.set $w1031
          block $while_1032_exit
            loop $while_1032_lp
              local.get $w1031
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1025
                local.get $w1031
                array.get $GcArray_41
                local.get $w1030
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
                local.get $w1025
                local.get $w1031
                i32.const 1
                i32.add
                local.get $w1025
                local.get $w1031
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w1031
                i32.const 1
                i32.sub
                local.set $w1031
                br $while_1032_lp
              else
                br $while_1032_exit
              end
            end
          end
          local.get $w1025
          local.get $w1031
          i32.const 1
          i32.add
          local.get $w1030
          array.set $GcArray_41
          local.get $w1029
          i32.const 1
          i32.add
          local.set $w1029
          br $while_1033_lp
        else
          br $while_1033_exit
        end
      end
    end
    local.get $w1024
    i32.const 1
    i32.sub
    local.set $w1034
    ref.null $ListBase
    local.set $w1035
    block $while_1036_exit
      loop $while_1036_lp
        local.get $w1034
        i32.const 0
        i32.ge_s
        if
          local.get $w1025
          local.get $w1034
          array.get $GcArray_41
          local.get $w1035
          struct.new $ListCons_30
          local.set $w1035
          local.get $w1034
          i32.const 1
          i32.sub
          local.set $w1034
          br $while_1036_lp
        else
          br $while_1036_exit
        end
      end
    end
    local.get $w1035
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_265 (param $self (ref $AnyFn)) (param $x (ref $WasmStr)) (param $y (ref $WasmStr)) (result i32)
    local.get $x
    local.get $y
    call $strCompare
  )
  (func $testListSortStrAsc (result i32) ;; exported as "testListSortStrAsc"
    (local $w1038 (ref null $ListBase))
    (local $w1042 i32)
    (local $w1039 (ref null $ListBase))
    (local $w1040 i32)
    (local $w1043 (ref $GcArray_268))
    (local $w1044 (ref null $ListBase))
    (local $w1045 i32)
    (local $w1047 i32)
    (local $w1048 (ref $WasmStr))
    (local $w1049 i32)
    (local $w1052 i32)
    (local $w1053 (ref null $ListBase))
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
    struct.new $ListCons_264
    struct.new $ListCons_264
    struct.new $ListCons_264
    local.set $w1038
    local.get $w1038
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
          ref.cast (ref $ListCons_264)
          struct.get $ListCons_264 1
          local.set $w1039
          br $while_1041_lp
        else
          br $while_1041_exit
        end
      end
    end
    local.get $w1040
    local.set $w1042
    ref.null $WasmStr
    local.get $w1042
    array.new $GcArray_268
    local.set $w1043
    local.get $w1038
    local.set $w1044
    i32.const 0
    local.set $w1045
    block $while_1046_exit
      loop $while_1046_lp
        local.get $w1044
        ref.is_null
        i32.eqz
        if
          local.get $w1043
          local.get $w1045
          local.get $w1044
          ref.cast (ref $ListCons_264)
          struct.get $ListCons_264 0
          array.set $GcArray_268
          local.get $w1045
          i32.const 1
          i32.add
          local.set $w1045
          local.get $w1044
          ref.cast (ref $ListCons_264)
          struct.get $ListCons_264 1
          local.set $w1044
          br $while_1046_lp
        else
          br $while_1046_exit
        end
      end
    end
    local.get $w1045
    drop
    i32.const 1
    local.set $w1047
    block $while_1051_exit
      loop $while_1051_lp
        local.get $w1047
        local.get $w1042
        i32.lt_s
        if
          local.get $w1043
          local.get $w1047
          array.get $GcArray_268
          ref.cast (ref $WasmStr)
          local.set $w1048
          local.get $w1047
          i32.const 1
          i32.sub
          local.set $w1049
          block $while_1050_exit
            loop $while_1050_lp
              local.get $w1049
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1043
                local.get $w1049
                array.get $GcArray_268
                ref.cast (ref $WasmStr)
                local.get $w1048
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
                local.get $w1043
                local.get $w1049
                i32.const 1
                i32.add
                local.get $w1043
                local.get $w1049
                array.get $GcArray_268
                ref.cast (ref $WasmStr)
                array.set $GcArray_268
                local.get $w1049
                i32.const 1
                i32.sub
                local.set $w1049
                br $while_1050_lp
              else
                br $while_1050_exit
              end
            end
          end
          local.get $w1043
          local.get $w1049
          i32.const 1
          i32.add
          local.get $w1048
          array.set $GcArray_268
          local.get $w1047
          i32.const 1
          i32.add
          local.set $w1047
          br $while_1051_lp
        else
          br $while_1051_exit
        end
      end
    end
    local.get $w1042
    i32.const 1
    i32.sub
    local.set $w1052
    ref.null $ListBase
    local.set $w1053
    block $while_1054_exit
      loop $while_1054_lp
        local.get $w1052
        i32.const 0
        i32.ge_s
        if
          local.get $w1043
          local.get $w1052
          array.get $GcArray_268
          ref.cast (ref $WasmStr)
          local.get $w1053
          struct.new $ListCons_264
          local.set $w1053
          local.get $w1052
          i32.const 1
          i32.sub
          local.set $w1052
          br $while_1054_lp
        else
          br $while_1054_exit
        end
      end
    end
    local.get $w1053
    ref.cast (ref $ListCons_264)
    struct.get $ListCons_264 0
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
  (func $testStdMapFind (result i32) ;; exported as "testStdMapFind"
    i32.const 2
    ref.func $closure_269
    struct.new $ClosureType_269
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    return_call $Map_find
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
  (func $testStdMapTryFind (result i32) ;; exported as "testStdMapTryFind"
    (local $w1055 (ref null $Option_12))
    i32.const 20
    ref.func $closure_272
    struct.new $ClosureType_272
    i32.const 10
    i32.const 100
    struct.new $Tuple_15
    i32.const 20
    i32.const 200
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_tryFind
    local.set $w1055
    local.get $w1055
    ref.is_null
    if (result i32)
      local.get $w1055
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 0
    end
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
  (func $closure_275 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testStdMapTryFindMissing (result i32) ;; exported as "testStdMapTryFindMissing"
    (local $w1056 (ref null $Option_12))
    i32.const 99
    ref.func $closure_275
    struct.new $ClosureType_275
    i32.const 1
    i32.const 1
    struct.new $Tuple_15
    i32.const 2
    i32.const 2
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_tryFind
    local.set $w1056
    local.get $w1056
    ref.is_null
    if (result i32)
      local.get $w1056
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 0
    end
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
  (func $testStdMapContainsKey (result i32) ;; exported as "testStdMapContainsKey"
    i32.const 5
    ref.func $closure_276
    struct.new $ClosureType_276
    i32.const 5
    i32.const 50
    struct.new $Tuple_15
    i32.const 6
    i32.const 60
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_containsKey
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_277 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    i32.const 2
    i32.const 2
    i32.const 20
    ref.func $closure_277
    struct.new $ClosureType_277
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_add
    return_call $Map_find
  )
  (func $testResizeArrayBasic (result i32) ;; exported as "testResizeArrayBasic"
    (local $xs (ref $ResizeArray_278))
    (local $w1058 i32)
    (local $w1059 (ref $GcArray_41))
    (local $w1060 i32)
    (local $w1061 (ref $GcArray_41))
    (local $w1063 i32)
    (local $w1064 (ref $GcArray_41))
    (local $w1065 i32)
    (local $w1066 (ref $GcArray_41))
    (local $w1068 i32)
    (local $w1069 (ref $GcArray_41))
    (local $w1070 i32)
    (local $w1071 (ref $GcArray_41))
    i32.const 0
    i32.const 4
    array.new $GcArray_41
    i32.const 0
    struct.new $ResizeArray_278
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_278 1
    local.set $w1058
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.set $w1059
    local.get $w1058
    local.get $w1059
    array.len
    i32.ge_u
    if
      local.get $w1059
      array.len
      i32.const 1
      i32.shl
      local.set $w1060
      i32.const 0
      local.get $w1060
      array.new $GcArray_41
      local.set $w1061
      local.get $w1061
      i32.const 0
      local.get $w1059
      i32.const 0
      local.get $w1058
      array.copy $GcArray_41 $GcArray_41
      local.get $xs
      local.get $w1061
      struct.set $ResizeArray_278 0
    end
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.get $w1058
    i32.const 10
    array.set $GcArray_41
    local.get $xs
    local.get $w1058
    i32.const 1
    i32.add
    struct.set $ResizeArray_278 1
    local.get $xs
    struct.get $ResizeArray_278 1
    local.set $w1063
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.set $w1064
    local.get $w1063
    local.get $w1064
    array.len
    i32.ge_u
    if
      local.get $w1064
      array.len
      i32.const 1
      i32.shl
      local.set $w1065
      i32.const 0
      local.get $w1065
      array.new $GcArray_41
      local.set $w1066
      local.get $w1066
      i32.const 0
      local.get $w1064
      i32.const 0
      local.get $w1063
      array.copy $GcArray_41 $GcArray_41
      local.get $xs
      local.get $w1066
      struct.set $ResizeArray_278 0
    end
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.get $w1063
    i32.const 20
    array.set $GcArray_41
    local.get $xs
    local.get $w1063
    i32.const 1
    i32.add
    struct.set $ResizeArray_278 1
    local.get $xs
    struct.get $ResizeArray_278 1
    local.set $w1068
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.set $w1069
    local.get $w1068
    local.get $w1069
    array.len
    i32.ge_u
    if
      local.get $w1069
      array.len
      i32.const 1
      i32.shl
      local.set $w1070
      i32.const 0
      local.get $w1070
      array.new $GcArray_41
      local.set $w1071
      local.get $w1071
      i32.const 0
      local.get $w1069
      i32.const 0
      local.get $w1068
      array.copy $GcArray_41 $GcArray_41
      local.get $xs
      local.get $w1071
      struct.set $ResizeArray_278 0
    end
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.get $w1068
    i32.const 30
    array.set $GcArray_41
    local.get $xs
    local.get $w1068
    i32.const 1
    i32.add
    struct.set $ResizeArray_278 1
    local.get $xs
    struct.get $ResizeArray_278 1
  )
  (func $mapping_279 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_280 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqMap (result i32) ;; exported as "testSeqMap"
    (local $w1080 (ref null $ListBase))
    (local $w1076 (ref null $ListBase))
    (local $w1073 (ref null $ListBase))
    (local $w1074 (ref null $ListBase))
    (local $x i32)
    (local $w1077 (ref null $ListBase))
    (local $w1081 i32)
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
    local.set $w1073
    ref.null $ListBase
    local.set $w1074
    block $while_1075_exit
      loop $while_1075_lp
        local.get $w1073
        ref.is_null
        i32.eqz
        if
          local.get $w1073
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          local.get $w1074
          struct.new $ListCons_30
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
    local.set $w1076
    ref.null $ListBase
    local.set $w1077
    block $while_1078_exit
      loop $while_1078_lp
        local.get $w1076
        ref.is_null
        i32.eqz
        if
          local.get $w1076
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1077
          struct.new $ListCons_30
          local.set $w1077
          local.get $w1076
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1076
          br $while_1078_lp
        else
          br $while_1078_exit
        end
      end
    end
    local.get $w1077
    local.set $w1080
    i32.const 0
    local.set $w1081
    block $while_1082_exit
      loop $while_1082_lp
        local.get $w1080
        ref.is_null
        i32.eqz
        if
          local.get $w1081
          local.get $w1080
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1081
          local.get $w1080
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1080
          br $while_1082_lp
        else
          br $while_1082_exit
        end
      end
    end
    local.get $w1081
  )
  (func $predicate_281 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $testSeqFilter (result i32) ;; exported as "testSeqFilter"
    (local $w1091 (ref null $ListBase))
    (local $w1087 (ref null $ListBase))
    (local $w1084 (ref null $ListBase))
    (local $w1085 (ref null $ListBase))
    (local $x i32)
    (local $w1088 (ref null $ListBase))
    (local $w1092 i32)
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
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $ListBase))
            local.get $w1084
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.get $w1085
            struct.new $ListCons_30
          else
            local.get $w1085
          end
          local.set $w1085
          local.get $w1084
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1084
          br $while_1086_lp
        else
          br $while_1086_exit
        end
      end
    end
    local.get $w1085
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
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1088
          struct.new $ListCons_30
          local.set $w1088
          local.get $w1087
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1087
          br $while_1089_lp
        else
          br $while_1089_exit
        end
      end
    end
    local.get $w1088
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
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1091
          br $while_1093_lp
        else
          br $while_1093_exit
        end
      end
    end
    local.get $w1092
  )
  (func $closure_282 (param $self (ref $AnyFn)) (param $acc i32) (param $x i32) (result i32)
    local.get $acc
    local.get $x
    i32.add
  )
  (func $testSeqFold (result i32) ;; exported as "testSeqFold"
    (local $w1095 (ref null $ListBase))
    (local $w1096 i32)
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
    local.set $w1095
    i32.const 0
    local.set $w1096
    block $while_1097_exit
      loop $while_1097_lp
        local.get $w1095
        ref.is_null
        i32.eqz
        if
          local.get $w1095
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $w1096
          local.get $x
          i32.add
          local.set $w1096
          local.get $w1095
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1095
          br $while_1097_lp
        else
          br $while_1097_exit
        end
      end
    end
    local.get $w1096
  )
  (func $closure_283 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testSeqExists (result i32) ;; exported as "testSeqExists"
    (local $w1099 (ref null $ListBase))
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
    local.set $w1099
    block $exi_1098_blk (result i32)
      block $exi_1098_lp_exit
        loop $exi_1098_lp
          local.get $w1099
          ref.is_null
          i32.eqz
          if
            local.get $w1099
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 3
            i32.gt_s
            if
              i32.const 1
              br $exi_1098_blk
            end
            local.get $w1099
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1099
          else
            br $exi_1098_lp_exit
          end
          br $exi_1098_lp
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
  (func $closure_284 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqToList (result i32) ;; exported as "testSeqToList"
    (local $w1101 (ref null $ListBase))
    (local $w1102 i32)
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
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
          local.get $w1102
          local.get $w1101
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
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
  (func $closure_285 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_286 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testListUnzip (result i32) ;; exported as "testListUnzip"
    (local $patternInput (ref $Tuple_240))
    (local $w1105 (ref null $ListBase))
    (local $w1110 (ref null $ListBase))
    (local $w1106 (ref null $ListBase))
    (local $w1107 (ref null $ListBase))
    (local $w1108 (ref $Tuple_15))
    (local $w1111 (ref null $ListBase))
    (local $w1113 (ref null $ListBase))
    (local $w1114 (ref null $ListBase))
    (local $w1117 (ref null $ListBase))
    (local $w1118 i32)
    (local $w1121 (ref null $ListBase))
    (local $w1122 i32)
    ref.null $ListBase
    local.set $w1105
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    local.set $w1106
    ref.null $ListBase
    local.set $w1107
    block $while_1109_exit
      loop $while_1109_lp
        local.get $w1106
        ref.is_null
        i32.eqz
        if
          local.get $w1106
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 0
          local.set $w1108
          local.get $w1108
          struct.get $Tuple_15 1
          local.get $w1105
          struct.new $ListCons_30
          local.set $w1105
          local.get $w1108
          struct.get $Tuple_15 0
          local.get $w1107
          struct.new $ListCons_30
          local.set $w1107
          local.get $w1106
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w1106
          br $while_1109_lp
        else
          br $while_1109_exit
        end
      end
    end
    local.get $w1107
    local.set $w1110
    ref.null $ListBase
    local.set $w1111
    block $while_1112_exit
      loop $while_1112_lp
        local.get $w1110
        ref.is_null
        i32.eqz
        if
          local.get $w1110
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1111
          struct.new $ListCons_30
          local.set $w1111
          local.get $w1110
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1110
          br $while_1112_lp
        else
          br $while_1112_exit
        end
      end
    end
    local.get $w1111
    local.get $w1105
    local.set $w1113
    ref.null $ListBase
    local.set $w1114
    block $while_1115_exit
      loop $while_1115_lp
        local.get $w1113
        ref.is_null
        i32.eqz
        if
          local.get $w1113
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1114
          struct.new $ListCons_30
          local.set $w1114
          local.get $w1113
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1113
          br $while_1115_lp
        else
          br $while_1115_exit
        end
      end
    end
    local.get $w1114
    struct.new $Tuple_240
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_240 0
    local.set $w1117
    i32.const 0
    local.set $w1118
    block $while_1119_exit
      loop $while_1119_lp
        local.get $w1117
        ref.is_null
        i32.eqz
        if
          local.get $w1118
          local.get $w1117
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1118
          local.get $w1117
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1117
          br $while_1119_lp
        else
          br $while_1119_exit
        end
      end
    end
    local.get $w1118
    local.get $patternInput
    struct.get $Tuple_240 1
    local.set $w1121
    i32.const 0
    local.set $w1122
    block $while_1123_exit
      loop $while_1123_lp
        local.get $w1121
        ref.is_null
        i32.eqz
        if
          local.get $w1122
          local.get $w1121
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1122
          local.get $w1121
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1121
          br $while_1123_lp
        else
          br $while_1123_exit
        end
      end
    end
    local.get $w1122
    i32.add
  )
  (func $closure_288 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $closure_289 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testArrayUnzip (result i32) ;; exported as "testArrayUnzip"
    (local $patternInput (ref $Tuple_287))
    (local $w1125 (ref $GcArray_231))
    (local $w1126 i32)
    (local $w1127 (ref $GcArray_41))
    (local $w1128 (ref $GcArray_41))
    (local $w1129 i32)
    (local $w1130 (ref $Tuple_15))
    (local $w1133 (ref $GcArray_41))
    (local $w1134 i32)
    (local $w1135 i32)
    (local $w1136 i32)
    (local $w1139 (ref $GcArray_41))
    (local $w1140 i32)
    (local $w1141 i32)
    (local $w1142 i32)
    i32.const 1
    i32.const 4
    struct.new $Tuple_15
    i32.const 2
    i32.const 5
    struct.new $Tuple_15
    i32.const 3
    i32.const 6
    struct.new $Tuple_15
    array.new_fixed $GcArray_231 3
    local.set $w1125
    local.get $w1125
    array.len
    local.set $w1126
    i32.const 0
    local.get $w1126
    array.new $GcArray_41
    local.set $w1127
    i32.const 0
    local.get $w1126
    array.new $GcArray_41
    local.set $w1128
    i32.const 0
    local.set $w1129
    block $while_1131_exit
      loop $while_1131_lp
        local.get $w1129
        local.get $w1126
        i32.lt_s
        if
          local.get $w1125
          local.get $w1129
          array.get $GcArray_231
          local.set $w1130
          local.get $w1127
          local.get $w1129
          local.get $w1130
          struct.get $Tuple_15 0
          array.set $GcArray_41
          local.get $w1128
          local.get $w1129
          local.get $w1130
          struct.get $Tuple_15 1
          array.set $GcArray_41
          local.get $w1129
          i32.const 1
          i32.add
          local.set $w1129
          br $while_1131_lp
        else
          br $while_1131_exit
        end
      end
    end
    local.get $w1127
    local.get $w1128
    struct.new $Tuple_287
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_287 0
    local.set $w1133
    local.get $w1133
    array.len
    local.set $w1134
    i32.const 0
    local.set $w1135
    i32.const 0
    local.set $w1136
    block $while_1137_exit
      loop $while_1137_lp
        local.get $w1136
        local.get $w1134
        i32.lt_s
        if
          local.get $w1135
          local.get $w1133
          local.get $w1136
          array.get $GcArray_41
          i32.add
          local.set $w1135
          local.get $w1136
          i32.const 1
          i32.add
          local.set $w1136
          br $while_1137_lp
        else
          br $while_1137_exit
        end
      end
    end
    local.get $w1135
    local.get $patternInput
    struct.get $Tuple_287 1
    local.set $w1139
    local.get $w1139
    array.len
    local.set $w1140
    i32.const 0
    local.set $w1141
    i32.const 0
    local.set $w1142
    block $while_1143_exit
      loop $while_1143_lp
        local.get $w1142
        local.get $w1140
        i32.lt_s
        if
          local.get $w1141
          local.get $w1139
          local.get $w1142
          array.get $GcArray_41
          i32.add
          local.set $w1141
          local.get $w1142
          i32.const 1
          i32.add
          local.set $w1142
          br $while_1143_lp
        else
          br $while_1143_exit
        end
      end
    end
    local.get $w1141
    i32.add
  )
  (func $projection_290 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.shl
  )
  (func $closure_291 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqSumBy (result i32) ;; exported as "testSeqSumBy"
    (local $w1145 (ref null $ListBase))
    (local $w1146 i32)
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
    local.set $w1145
    i32.const 0
    local.set $w1146
    block $while_1147_exit
      loop $while_1147_lp
        local.get $w1145
        ref.is_null
        i32.eqz
        if
          local.get $w1146
          local.get $w1145
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 1
          i32.shl
          i32.add
          local.set $w1146
          local.get $w1145
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1145
          br $while_1147_lp
        else
          br $while_1147_exit
        end
      end
    end
    local.get $w1146
  )
  (func $testLetMutable (result i32) ;; exported as "testLetMutable"
    (local $x i32)
    i32.const 10
    local.set $x
    local.get $x
    i32.const 5
    i32.add
    local.set $x
    local.get $x
    i32.const 1
    i32.shl
    local.set $x
    local.get $x
  )
  (func $testLetMutableLoop (result i32) ;; exported as "testLetMutableLoop"
    (local $sum i32)
    (local $i i32)
    i32.const 0
    local.set $sum
    i32.const 1
    local.set $i
    loop $for
      local.get $i
      i32.const 10
      i32.le_s
      if
        local.get $sum
        local.get $i
        i32.add
        local.set $sum
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $for
      end
    end
    local.get $sum
  )
  (func $closure_292 (param $self (ref $AnyFn)) (param $i i32) (result i32)
    local.get $i
    local.get $i
    i32.mul
  )
  (func $closure_293 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqInit (result i32) ;; exported as "testSeqInit"
    (local $w1153 (ref null $ListBase))
    (local $w1149 i32)
    (local $w1150 (ref null $ListBase))
    (local $w1154 i32)
    i32.const 4
    local.set $w1149
    ref.null $ListBase
    local.set $w1150
    block $while_1151_exit
      loop $while_1151_lp
        local.get $w1149
        i32.const 0
        i32.ge_s
        if
          local.get $w1149
          local.get $w1149
          i32.mul
          local.get $w1150
          struct.new $ListCons_30
          local.set $w1150
          local.get $w1149
          i32.const 1
          i32.sub
          local.set $w1149
          br $while_1151_lp
        else
          br $while_1151_exit
        end
      end
    end
    local.get $w1150
    local.set $w1153
    i32.const 0
    local.set $w1154
    block $while_1155_exit
      loop $while_1155_lp
        local.get $w1153
        ref.is_null
        i32.eqz
        if
          local.get $w1154
          local.get $w1153
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1154
          local.get $w1153
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1153
          br $while_1155_lp
        else
          br $while_1155_exit
        end
      end
    end
    local.get $w1154
  )
  (func $testResizeArrayIndex (result i32) ;; exported as "testResizeArrayIndex"
    (local $xs (ref $ResizeArray_278))
    (local $w1157 i32)
    (local $w1158 (ref $GcArray_41))
    (local $w1159 i32)
    (local $w1160 (ref $GcArray_41))
    (local $w1162 i32)
    (local $w1163 (ref $GcArray_41))
    (local $w1164 i32)
    (local $w1165 (ref $GcArray_41))
    (local $w1167 i32)
    (local $w1168 (ref $GcArray_41))
    (local $w1169 i32)
    (local $w1170 (ref $GcArray_41))
    i32.const 0
    i32.const 4
    array.new $GcArray_41
    i32.const 0
    struct.new $ResizeArray_278
    local.set $xs
    local.get $xs
    struct.get $ResizeArray_278 1
    local.set $w1157
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.set $w1158
    local.get $w1157
    local.get $w1158
    array.len
    i32.ge_u
    if
      local.get $w1158
      array.len
      i32.const 1
      i32.shl
      local.set $w1159
      i32.const 0
      local.get $w1159
      array.new $GcArray_41
      local.set $w1160
      local.get $w1160
      i32.const 0
      local.get $w1158
      i32.const 0
      local.get $w1157
      array.copy $GcArray_41 $GcArray_41
      local.get $xs
      local.get $w1160
      struct.set $ResizeArray_278 0
    end
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.get $w1157
    i32.const 100
    array.set $GcArray_41
    local.get $xs
    local.get $w1157
    i32.const 1
    i32.add
    struct.set $ResizeArray_278 1
    local.get $xs
    struct.get $ResizeArray_278 1
    local.set $w1162
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.set $w1163
    local.get $w1162
    local.get $w1163
    array.len
    i32.ge_u
    if
      local.get $w1163
      array.len
      i32.const 1
      i32.shl
      local.set $w1164
      i32.const 0
      local.get $w1164
      array.new $GcArray_41
      local.set $w1165
      local.get $w1165
      i32.const 0
      local.get $w1163
      i32.const 0
      local.get $w1162
      array.copy $GcArray_41 $GcArray_41
      local.get $xs
      local.get $w1165
      struct.set $ResizeArray_278 0
    end
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.get $w1162
    i32.const 200
    array.set $GcArray_41
    local.get $xs
    local.get $w1162
    i32.const 1
    i32.add
    struct.set $ResizeArray_278 1
    local.get $xs
    struct.get $ResizeArray_278 1
    local.set $w1167
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.set $w1168
    local.get $w1167
    local.get $w1168
    array.len
    i32.ge_u
    if
      local.get $w1168
      array.len
      i32.const 1
      i32.shl
      local.set $w1169
      i32.const 0
      local.get $w1169
      array.new $GcArray_41
      local.set $w1170
      local.get $w1170
      i32.const 0
      local.get $w1168
      i32.const 0
      local.get $w1167
      array.copy $GcArray_41 $GcArray_41
      local.get $xs
      local.get $w1170
      struct.set $ResizeArray_278 0
    end
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    local.get $w1167
    i32.const 300
    array.set $GcArray_41
    local.get $xs
    local.get $w1167
    i32.const 1
    i32.add
    struct.set $ResizeArray_278 1
    local.get $xs
    struct.get $ResizeArray_278 0
    ref.cast (ref $GcArray_41)
    i32.const 1
    array.get $GcArray_41
  )
  (func $mapping_294 (param $self (ref $AnyFn)) (param $tupledArg (ref $Tuple_15)) (result i32)
    local.get $tupledArg
    struct.get $Tuple_15 1
    local.get $tupledArg
    struct.get $Tuple_15 0
    i32.sub
  )
  (func $closure_297 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqPairwise (result i32) ;; exported as "testSeqPairwise"
    (local $w1203 (ref null $ListBase))
    (local $w1199 (ref null $ListBase))
    (local $w1196 (ref null $ListBase))
    (local $w1185 (ref null $ListBase))
    (local $w1186 (ref $ListCons_30))
    (local $w1187 i32)
    (local $w1193 (ref null $ListBase))
    (local $w1188 (ref null $ListBase))
    (local $w1189 (ref null $ListBase))
    (local $w1190 i32)
    (local $w1191 (ref $Tuple_15))
    (local $w1194 (ref null $ListBase))
    (local $w1197 (ref null $ListBase))
    (local $tupledArg (ref $Tuple_15))
    (local $w1200 (ref null $ListBase))
    (local $w1204 i32)
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
    local.set $w1185
    local.get $w1185
    ref.is_null
    if (result (ref null $ListBase))
      ref.null $ListBase
    else
      local.get $w1185
      ref.cast (ref $ListCons_30)
      local.set $w1186
      local.get $w1186
      struct.get $ListCons_30 0
      local.set $w1187
      local.get $w1186
      struct.get $ListCons_30 1
      local.set $w1188
      ref.null $ListBase
      local.set $w1189
      block $while_1192_exit
        loop $while_1192_lp
          local.get $w1188
          ref.is_null
          i32.eqz
          if
            local.get $w1188
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $w1190
            local.get $w1187
            local.get $w1190
            struct.new $Tuple_15
            local.set $w1191
            local.get $w1190
            local.set $w1187
            local.get $w1191
            local.get $w1189
            struct.new $ListCons_16
            local.set $w1189
            local.get $w1188
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1188
            br $while_1192_lp
          else
            br $while_1192_exit
          end
        end
      end
      local.get $w1189
      local.set $w1193
      ref.null $ListBase
      local.set $w1194
      block $while_1195_exit
        loop $while_1195_lp
          local.get $w1193
          ref.is_null
          i32.eqz
          if
            local.get $w1193
            ref.cast (ref $ListCons_16)
            struct.get $ListCons_16 0
            local.get $w1194
            struct.new $ListCons_16
            local.set $w1194
            local.get $w1193
            ref.cast (ref $ListCons_16)
            struct.get $ListCons_16 1
            local.set $w1193
            br $while_1195_lp
          else
            br $while_1195_exit
          end
        end
      end
      local.get $w1194
    end
    local.set $w1196
    ref.null $ListBase
    local.set $w1197
    block $while_1198_exit
      loop $while_1198_lp
        local.get $w1196
        ref.is_null
        i32.eqz
        if
          local.get $w1196
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 0
          local.set $tupledArg
          local.get $tupledArg
          struct.get $Tuple_15 1
          local.get $tupledArg
          struct.get $Tuple_15 0
          i32.sub
          local.get $w1197
          struct.new $ListCons_30
          local.set $w1197
          local.get $w1196
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w1196
          br $while_1198_lp
        else
          br $while_1198_exit
        end
      end
    end
    local.get $w1197
    local.set $w1199
    ref.null $ListBase
    local.set $w1200
    block $while_1201_exit
      loop $while_1201_lp
        local.get $w1199
        ref.is_null
        i32.eqz
        if
          local.get $w1199
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1200
          struct.new $ListCons_30
          local.set $w1200
          local.get $w1199
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1199
          br $while_1201_lp
        else
          br $while_1201_exit
        end
      end
    end
    local.get $w1200
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
          local.get $w1203
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
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
  (func $projection_298 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_299 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $testSeqCountBy (result i32) ;; exported as "testSeqCountBy"
    (local $w1222 (ref null $ListBase))
    (local $w1207 (ref null $ListBase))
    (local $w1208 (ref null $ListBase))
    (local $w1209 i32)
    (local $w1210 (ref null $ListBase))
    (local $x i32)
    (local $cntb_1206_k i32)
    (local $w1211 (ref null $ListBase))
    (local $w1212 (ref null $ListBase))
    (local $cntb_1206_rv (ref null $ListBase))
    (local $w1214 (ref null $ListBase))
    (local $w1215 (ref null $ListBase))
    (local $w1218 (ref null $ListBase))
    (local $w1219 (ref null $ListBase))
    (local $w1223 i32)
    ref.null $ListBase
    local.set $w1207
    ref.null $ListBase
    local.set $w1208
    i32.const 0
    local.set $w1209
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
    local.set $w1210
    block $while_1217_exit
      loop $while_1217_lp
        local.get $w1210
        ref.is_null
        i32.eqz
        if
          local.get $w1210
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          local.set $cntb_1206_k
          i32.const 0
          local.set $w1209
          local.get $w1207
          local.set $w1211
          ref.null $ListBase
          local.set $w1212
          block $while_1213_exit
            loop $while_1213_lp
              local.get $w1211
              ref.is_null
              i32.eqz
              if
                local.get $w1209
                i32.eqz
                local.get $w1211
                ref.cast (ref $ListCons_16)
                struct.get $ListCons_16 0
                struct.get $Tuple_15 0
                local.get $cntb_1206_k
                i32.eq
                i32.and
                if (result (ref null $ListBase))
                  i32.const 1
                  local.set $w1209
                  local.get $w1211
                  ref.cast (ref $ListCons_16)
                  struct.get $ListCons_16 0
                  struct.get $Tuple_15 0
                  local.get $w1211
                  ref.cast (ref $ListCons_16)
                  struct.get $ListCons_16 0
                  struct.get $Tuple_15 1
                  i32.const 1
                  i32.add
                  struct.new $Tuple_15
                  local.get $w1212
                  struct.new $ListCons_16
                else
                  local.get $w1211
                  ref.cast (ref $ListCons_16)
                  struct.get $ListCons_16 0
                  local.get $w1212
                  struct.new $ListCons_16
                end
                local.set $w1212
                local.get $w1211
                ref.cast (ref $ListCons_16)
                struct.get $ListCons_16 1
                local.set $w1211
                br $while_1213_lp
              else
                br $while_1213_exit
              end
            end
          end
          local.get $w1212
          local.set $w1208
          local.get $w1208
          local.set $w1214
          ref.null $ListBase
          local.set $w1215
          block $while_1216_exit
            loop $while_1216_lp
              local.get $w1214
              ref.is_null
              i32.eqz
              if
                local.get $w1214
                ref.cast (ref $ListCons_16)
                struct.get $ListCons_16 0
                local.get $w1215
                struct.new $ListCons_16
                local.set $w1215
                local.get $w1214
                ref.cast (ref $ListCons_16)
                struct.get $ListCons_16 1
                local.set $w1214
                br $while_1216_lp
              else
                br $while_1216_exit
              end
            end
          end
          local.get $w1215
          local.set $cntb_1206_rv
          local.get $w1209
          if (result (ref null $ListBase))
            local.get $cntb_1206_rv
          else
            local.get $cntb_1206_k
            i32.const 1
            struct.new $Tuple_15
            local.get $cntb_1206_rv
            struct.new $ListCons_16
          end
          local.set $w1207
          local.get $w1210
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1210
          br $while_1217_lp
        else
          br $while_1217_exit
        end
      end
    end
    local.get $w1207
    local.set $w1218
    ref.null $ListBase
    local.set $w1219
    block $while_1220_exit
      loop $while_1220_lp
        local.get $w1218
        ref.is_null
        i32.eqz
        if
          local.get $w1218
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 0
          local.get $w1219
          struct.new $ListCons_16
          local.set $w1219
          local.get $w1218
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w1218
          br $while_1220_lp
        else
          br $while_1220_exit
        end
      end
    end
    local.get $w1219
    local.set $w1222
    i32.const 0
    local.set $w1223
    block $while_1224_exit
      loop $while_1224_lp
        local.get $w1222
        ref.is_null
        i32.eqz
        if
          local.get $w1223
          i32.const 1
          i32.add
          local.set $w1223
          local.get $w1222
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w1222
          br $while_1224_lp
        else
          br $while_1224_exit
        end
      end
    end
    local.get $w1223
  )
  (func $projection_302 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_303 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $testListGroupBy (result i32) ;; exported as "testListGroupBy"
    (local $w1244 (ref null $ListBase))
    (local $w1226 (ref null $ListBase))
    (local $w1227 (ref null $ListBase))
    (local $w1228 i32)
    (local $w1229 (ref null $ListBase))
    (local $x i32)
    (local $gb_1225_k i32)
    (local $w1230 (ref null $ListBase))
    (local $w1231 (ref null $ListBase))
    (local $gb_1225_rv (ref null $ListBase))
    (local $w1233 (ref null $ListBase))
    (local $w1234 (ref null $ListBase))
    (local $w1237 (ref null $ListBase))
    (local $w1238 (ref null $ListBase))
    (local $w1239 (ref null $ListBase))
    (local $w1240 (ref null $ListBase))
    (local $w1245 i32)
    ref.null $ListBase
    local.set $w1226
    ref.null $ListBase
    local.set $w1227
    i32.const 0
    local.set $w1228
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
    local.set $w1229
    block $while_1236_exit
      loop $while_1236_lp
        local.get $w1229
        ref.is_null
        i32.eqz
        if
          local.get $w1229
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          local.set $gb_1225_k
          i32.const 0
          local.set $w1228
          local.get $w1226
          local.set $w1230
          ref.null $ListBase
          local.set $w1231
          block $while_1232_exit
            loop $while_1232_lp
              local.get $w1230
              ref.is_null
              i32.eqz
              if
                local.get $w1228
                i32.eqz
                local.get $w1230
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 0
                struct.get $Tuple_300 0
                local.get $gb_1225_k
                i32.eq
                i32.and
                if (result (ref null $ListBase))
                  i32.const 1
                  local.set $w1228
                  local.get $w1230
                  ref.cast (ref $ListCons_301)
                  struct.get $ListCons_301 0
                  struct.get $Tuple_300 0
                  local.get $x
                  local.get $w1230
                  ref.cast (ref $ListCons_301)
                  struct.get $ListCons_301 0
                  struct.get $Tuple_300 1
                  struct.new $ListCons_30
                  struct.new $Tuple_300
                  local.get $w1231
                  struct.new $ListCons_301
                else
                  local.get $w1230
                  ref.cast (ref $ListCons_301)
                  struct.get $ListCons_301 0
                  local.get $w1231
                  struct.new $ListCons_301
                end
                local.set $w1231
                local.get $w1230
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 1
                local.set $w1230
                br $while_1232_lp
              else
                br $while_1232_exit
              end
            end
          end
          local.get $w1231
          local.set $w1227
          local.get $w1227
          local.set $w1233
          ref.null $ListBase
          local.set $w1234
          block $while_1235_exit
            loop $while_1235_lp
              local.get $w1233
              ref.is_null
              i32.eqz
              if
                local.get $w1233
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 0
                local.get $w1234
                struct.new $ListCons_301
                local.set $w1234
                local.get $w1233
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 1
                local.set $w1233
                br $while_1235_lp
              else
                br $while_1235_exit
              end
            end
          end
          local.get $w1234
          local.set $gb_1225_rv
          local.get $w1228
          if (result (ref null $ListBase))
            local.get $gb_1225_rv
          else
            local.get $gb_1225_k
            local.get $x
            ref.null $ListBase
            struct.new $ListCons_30
            struct.new $Tuple_300
            local.get $gb_1225_rv
            struct.new $ListCons_301
          end
          local.set $w1226
          local.get $w1229
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1229
          br $while_1236_lp
        else
          br $while_1236_exit
        end
      end
    end
    ref.null $ListBase
    local.set $w1237
    local.get $w1226
    local.set $w1238
    block $while_1242_exit
      loop $while_1242_lp
        local.get $w1238
        ref.is_null
        i32.eqz
        if
          local.get $w1238
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 0
          struct.get $Tuple_300 0
          local.get $w1238
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 0
          struct.get $Tuple_300 1
          local.set $w1239
          ref.null $ListBase
          local.set $w1240
          block $while_1241_exit
            loop $while_1241_lp
              local.get $w1239
              ref.is_null
              i32.eqz
              if
                local.get $w1239
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w1240
                struct.new $ListCons_30
                local.set $w1240
                local.get $w1239
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w1239
                br $while_1241_lp
              else
                br $while_1241_exit
              end
            end
          end
          local.get $w1240
          struct.new $Tuple_300
          local.get $w1237
          struct.new $ListCons_301
          local.set $w1237
          local.get $w1238
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 1
          local.set $w1238
          br $while_1242_lp
        else
          br $while_1242_exit
        end
      end
    end
    local.get $w1237
    local.set $w1244
    i32.const 0
    local.set $w1245
    block $while_1246_exit
      loop $while_1246_lp
        local.get $w1244
        ref.is_null
        i32.eqz
        if
          local.get $w1245
          i32.const 1
          i32.add
          local.set $w1245
          local.get $w1244
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 1
          local.set $w1244
          br $while_1246_lp
        else
          br $while_1246_exit
        end
      end
    end
    local.get $w1245
  )
  (func $evalExpr (param $_arg (ref $QuickTestWasmGc_Preamble_MathExpr)) (result i32) ;; exported as "evalExpr"
    local.get $_arg
    struct.get $QuickTestWasmGc_Preamble_MathExpr 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $_arg
      ref.cast (ref $QuickTestWasmGc_Preamble_MathExpr#1)
      struct.get $QuickTestWasmGc_Preamble_MathExpr#1 1
      call $evalExpr
      local.get $_arg
      ref.cast (ref $QuickTestWasmGc_Preamble_MathExpr#1)
      struct.get $QuickTestWasmGc_Preamble_MathExpr#1 2
      call $evalExpr
      i32.add
    else
      local.get $_arg
      struct.get $QuickTestWasmGc_Preamble_MathExpr 0
      i32.const 2
      i32.eq
      if (result i32)
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_Preamble_MathExpr#2)
        struct.get $QuickTestWasmGc_Preamble_MathExpr#2 1
        call $evalExpr
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_Preamble_MathExpr#2)
        struct.get $QuickTestWasmGc_Preamble_MathExpr#2 2
        call $evalExpr
        i32.mul
      else
        local.get $_arg
        ref.cast (ref $QuickTestWasmGc_Preamble_MathExpr#0)
        struct.get $QuickTestWasmGc_Preamble_MathExpr#0 1
      end
    end
  )
  (func $testRecursiveDU (result i32) ;; exported as "testRecursiveDU"
    i32.const 2
    i32.const 1
    i32.const 0
    i32.const 2
    struct.new $QuickTestWasmGc_Preamble_MathExpr#0
    i32.const 0
    i32.const 3
    struct.new $QuickTestWasmGc_Preamble_MathExpr#0
    struct.new $QuickTestWasmGc_Preamble_MathExpr#1
    i32.const 1
    i32.const 0
    i32.const 1
    struct.new $QuickTestWasmGc_Preamble_MathExpr#0
    i32.const 0
    i32.const 4
    struct.new $QuickTestWasmGc_Preamble_MathExpr#0
    struct.new $QuickTestWasmGc_Preamble_MathExpr#1
    struct.new $QuickTestWasmGc_Preamble_MathExpr#2
    return_call $evalExpr
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
  (func $classify_311 (param $self (ref $AnyFn)) (param $n i32) (result i32)
    local.get $n
    call $007CEven$007COdd$007C
    struct.get $Microsoft_FSharp_Core_FSharpChoice`2<void~void> 0
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_312 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testActivePattern (result i32) ;; exported as "testActivePattern"
    (local $w1248 (ref null $ListBase))
    (local $w1249 i32)
    (local $n i32)
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
    local.set $w1248
    i32.const 0
    local.set $w1249
    block $while_1250_exit
      loop $while_1250_lp
        local.get $w1248
        ref.is_null
        i32.eqz
        if
          local.get $w1249
          local.get $w1248
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $n
          local.get $n
          call $007CEven$007COdd$007C
          struct.get $Microsoft_FSharp_Core_FSharpChoice`2<void~void> 0
          i32.const 1
          i32.eq
          if (result i32)
            i32.const 1
          else
            i32.const 0
          end
          i32.add
          local.set $w1249
          local.get $w1248
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1248
          br $while_1250_lp
        else
          br $while_1250_exit
        end
      end
    end
    local.get $w1249
  )
  (func $testStringConcat (result i32) ;; exported as "testStringConcat"
    (local $s (ref $WasmStr))
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
    local.set $s
    local.get $s
    array.len
  )
  (func $testStringInterp (result i32) ;; exported as "testStringInterp"
    (local $s (ref $WasmStr))
    i32.const 72
    i32.const 101
    i32.const 108
    i32.const 108
    i32.const 111
    i32.const 32
    array.new_fixed $WasmStr 6
    i32.const 65
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 101
    array.new_fixed $WasmStr 5
    call $strConcat
    i32.const 33
    array.new_fixed $WasmStr 1
    call $strConcat
    local.set $s
    local.get $s
    array.len
  )
  (func $closure_313 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.eq
  )
  (func $testSeqDistinct (result i32) ;; exported as "testSeqDistinct"
    (local $w1261 (ref null $ListBase))
    (local $w1252 (ref null $ListBase))
    (local $w1253 (ref null $ListBase))
    (local $w1254 (ref null $ListBase))
    (local $dst_1251_de i32)
    (local $w1255 (ref null $ListBase))
    (local $w1257 (ref null $ListBase))
    (local $w1258 (ref null $ListBase))
    (local $w1262 i32)
    ref.null $ListBase
    local.set $w1252
    ref.null $ListBase
    local.set $w1253
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
    local.set $w1254
    block $while_1256_exit
      loop $while_1256_lp
        local.get $w1254
        ref.is_null
        i32.eqz
        if
          local.get $w1254
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $dst_1251_de
          local.get $w1253
          local.set $w1255
          block $dst_1251_blk (result i32)
            block $dst_1251_lp_exit
              loop $dst_1251_lp
                local.get $w1255
                ref.is_null
                i32.eqz
                if
                  local.get $w1255
                  ref.cast (ref $ListCons_30)
                  struct.get $ListCons_30 0
                  local.get $dst_1251_de
                  i32.eq
                  if
                    i32.const 1
                    br $dst_1251_blk
                  end
                  local.get $w1255
                  ref.cast (ref $ListCons_30)
                  struct.get $ListCons_30 1
                  local.set $w1255
                else
                  br $dst_1251_lp_exit
                end
                br $dst_1251_lp
              end
            end
            i32.const 0
          end
          if
          else
            local.get $dst_1251_de
            local.get $w1253
            struct.new $ListCons_30
            local.set $w1253
            local.get $dst_1251_de
            local.get $w1252
            struct.new $ListCons_30
            local.set $w1252
          end
          local.get $w1254
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1254
          br $while_1256_lp
        else
          br $while_1256_exit
        end
      end
    end
    local.get $w1252
    local.set $w1257
    ref.null $ListBase
    local.set $w1258
    block $while_1259_exit
      loop $while_1259_lp
        local.get $w1257
        ref.is_null
        i32.eqz
        if
          local.get $w1257
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1258
          struct.new $ListCons_30
          local.set $w1258
          local.get $w1257
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1257
          br $while_1259_lp
        else
          br $while_1259_exit
        end
      end
    end
    local.get $w1258
    local.set $w1261
    i32.const 0
    local.set $w1262
    block $while_1263_exit
      loop $while_1263_lp
        local.get $w1261
        ref.is_null
        i32.eqz
        if
          local.get $w1262
          i32.const 1
          i32.add
          local.set $w1262
          local.get $w1261
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1261
          br $while_1263_lp
        else
          br $while_1263_exit
        end
      end
    end
    local.get $w1262
  )
  (func $projection_314 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.rem_s
  )
  (func $closure_315 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $testListDistinctBy (result i32) ;; exported as "testListDistinctBy"
    (local $w1274 (ref null $ListBase))
    (local $w1265 (ref null $ListBase))
    (local $w1266 (ref null $ListBase))
    (local $w1267 (ref null $ListBase))
    (local $x i32)
    (local $dstby_1264_dk i32)
    (local $w1268 (ref null $ListBase))
    (local $w1270 (ref null $ListBase))
    (local $w1271 (ref null $ListBase))
    (local $w1275 i32)
    ref.null $ListBase
    local.set $w1265
    ref.null $ListBase
    local.set $w1266
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
    local.set $w1267
    block $while_1269_exit
      loop $while_1269_lp
        local.get $w1267
        ref.is_null
        i32.eqz
        if
          local.get $w1267
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 3
          i32.rem_s
          local.set $dstby_1264_dk
          local.get $w1266
          local.set $w1268
          block $dstby_1264_blk (result i32)
            block $dstby_1264_lp_exit
              loop $dstby_1264_lp
                local.get $w1268
                ref.is_null
                i32.eqz
                if
                  local.get $w1268
                  ref.cast (ref $ListCons_30)
                  struct.get $ListCons_30 0
                  local.get $dstby_1264_dk
                  i32.eq
                  if
                    i32.const 1
                    br $dstby_1264_blk
                  end
                  local.get $w1268
                  ref.cast (ref $ListCons_30)
                  struct.get $ListCons_30 1
                  local.set $w1268
                else
                  br $dstby_1264_lp_exit
                end
                br $dstby_1264_lp
              end
            end
            i32.const 0
          end
          if
          else
            local.get $dstby_1264_dk
            local.get $w1266
            struct.new $ListCons_30
            local.set $w1266
            local.get $x
            local.get $w1265
            struct.new $ListCons_30
            local.set $w1265
          end
          local.get $w1267
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1267
          br $while_1269_lp
        else
          br $while_1269_exit
        end
      end
    end
    local.get $w1265
    local.set $w1270
    ref.null $ListBase
    local.set $w1271
    block $while_1272_exit
      loop $while_1272_lp
        local.get $w1270
        ref.is_null
        i32.eqz
        if
          local.get $w1270
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1271
          struct.new $ListCons_30
          local.set $w1271
          local.get $w1270
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1270
          br $while_1272_lp
        else
          br $while_1272_exit
        end
      end
    end
    local.get $w1271
    local.set $w1274
    i32.const 0
    local.set $w1275
    block $while_1276_exit
      loop $while_1276_lp
        local.get $w1274
        ref.is_null
        i32.eqz
        if
          local.get $w1275
          i32.const 1
          i32.add
          local.set $w1275
          local.get $w1274
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1274
          br $while_1276_lp
        else
          br $while_1276_exit
        end
      end
    end
    local.get $w1275
  )
  (func $testTryCatchBasic (result i32) ;; exported as "testTryCatchBasic"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
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
                i32.const 0
        )
        br 1
      )
        i32.const 42
    )
  )
  (func $testTryCatchNoThrow (result i32) ;; exported as "testTryCatchNoThrow"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 30
        )
        br 1
      )
        i32.const 0
    )
  )
  (func $testTryCatchNested (result i32) ;; exported as "testTryCatchNested"
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
                            i32.const 0
                    )
                    br 1
                  )
                    i32.const 100
                )
        )
        br 1
      )
        i32.const 200
    )
  )
  (func $testTryCatchFallback (result i32) ;; exported as "testTryCatchFallback"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 101
                i32.const 114
                i32.const 114
                i32.const 111
                i32.const 114
                array.new_fixed $WasmStr 5
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
                i32.const 15
        )
        br 1
      )
        i32.const 99
    )
  )
  (func $closure_316 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_317 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_316
    struct.new $ClosureType_316
    ref.null $ListBase
    call $Map_ofList
    local.set $e
    ref.func $closure_317
    struct.new $ClosureType_317
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    call $Map_ofList
    local.set $m
    local.get $e
    call $Map_count
    local.get $m
    call $Map_count
    i32.add
  )
  (func $closure_318 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    i32.const 2
    ref.func $closure_318
    struct.new $ClosureType_318
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_remove
    return_call $Map_count
  )
  (func $closure_319 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testMapToList (result i32) ;; exported as "testMapToList"
    (local $w1278 (ref null $ListBase))
    (local $w1279 i32)
    ref.func $closure_319
    struct.new $ClosureType_319
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_toList
    local.set $w1278
    i32.const 0
    local.set $w1279
    block $while_1280_exit
      loop $while_1280_lp
        local.get $w1278
        ref.is_null
        i32.eqz
        if
          local.get $w1279
          i32.const 1
          i32.add
          local.set $w1279
          local.get $w1278
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w1278
          br $while_1280_lp
        else
          br $while_1280_exit
        end
      end
    end
    local.get $w1279
  )
  (func $closure_320 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    i32.const 30
    ref.func $closure_320
    struct.new $ClosureType_320
    i32.const 10
    i32.const 100
    struct.new $Tuple_15
    i32.const 20
    i32.const 200
    struct.new $Tuple_15
    i32.const 30
    i32.const 300
    struct.new $Tuple_15
    i32.const 40
    i32.const 400
    struct.new $Tuple_15
    i32.const 50
    i32.const 500
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    return_call $Map_find
  )
  (func $closure_321 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 99
                ref.func $closure_321
                struct.new $ClosureType_321
                i32.const 1
                i32.const 10
                struct.new $Tuple_15
                i32.const 2
                i32.const 20
                struct.new $Tuple_15
                ref.null $ListBase
                struct.new $ListCons_16
                struct.new $ListCons_16
                call $Map_ofList
                call $Map_find
        )
        br 1
      )
        i32.const -1
    )
  )
  (func $closure_322 (param $self (ref $AnyFn)) (param $acc i32) (param $_k i32) (param $v i32) (result i32)
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_323 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testMapFold (result i32) ;; exported as "testMapFold"
    ref.func $closure_322
    struct.new $ClosureType_322
    i32.const 0
    ref.func $closure_323
    struct.new $ClosureType_323
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    return_call $Map_fold
  )
  (func $closure_324 (param $self (ref $AnyFn)) (param $acc i32) (param $_k i32) (param $v i32) (result i32)
    local.get $acc
    local.get $v
    i32.add
  )
  (func $closure_325 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testMapIter (result i32) ;; exported as "testMapIter"
    ref.func $closure_324
    struct.new $ClosureType_324
    i32.const 0
    ref.func $closure_325
    struct.new $ClosureType_325
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    return_call $Map_fold
  )
  (func $closure_326 (param $self (ref $AnyFn)) (param $_k i32) (param $v i32) (result i32)
    local.get $v
    i32.const 15
    i32.gt_s
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
  (func $testMapFilter (result i32) ;; exported as "testMapFilter"
    ref.func $closure_326
    struct.new $ClosureType_326
    ref.func $closure_327
    struct.new $ClosureType_327
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_filter
    return_call $Map_count
  )
  (func $closure_328 (param $self (ref $AnyFn)) (param $_k i32) (param $v i32) (result i32)
    local.get $v
    i32.const 25
    i32.gt_s
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
  (func $testMapExists (result i32) ;; exported as "testMapExists"
    ref.func $closure_328
    struct.new $ClosureType_328
    ref.func $closure_329
    struct.new $ClosureType_329
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_330 (param $self (ref $AnyFn)) (param $_k i32) (param $v i32) (result i32)
    local.get $v
    i32.const 10
    i32.ge_s
  )
  (func $closure_331 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testMapForall (result i32) ;; exported as "testMapForall"
    ref.func $closure_330
    struct.new $ClosureType_330
    ref.func $closure_331
    struct.new $ClosureType_331
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    call $Map_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_332 (param $self (ref $AnyFn)) (param $_k i32) (param $v i32) (result i32)
    local.get $v
    i32.const 1
    i32.shl
  )
  (func $closure_333 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testMapMap (result i32) ;; exported as "testMapMap"
    (local $m2 (ref $MapModule_MapHandle`2))
    ref.func $closure_332
    struct.new $ClosureType_332
    ref.func $closure_333
    struct.new $ClosureType_333
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
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
  (func $chooser_334 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $Option_12))
    local.get $x
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_12))
      local.get $x
      i32.const 10
      i32.mul
      struct.new $Option_12
    else
      ref.null $Option_12
    end
  )
  (func $closure_335 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqChoose (result i32) ;; exported as "testSeqChoose"
    (local $w1289 (ref null $ListBase))
    (local $w1285 (ref null $ListBase))
    (local $w1282 (ref null $ListBase))
    (local $w1283 (ref null $ListBase))
    (local $cho_1281_opt (ref null $Option_12))
    (local $x i32)
    (local $w1286 (ref null $ListBase))
    (local $w1290 i32)
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
    local.set $w1282
    ref.null $ListBase
    local.set $w1283
    block $while_1284_exit
      loop $while_1284_lp
        local.get $w1282
        ref.is_null
        i32.eqz
        if
          local.get $w1282
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_12))
            local.get $x
            i32.const 10
            i32.mul
            struct.new $Option_12
          else
            ref.null $Option_12
          end
          local.set $cho_1281_opt
          local.get $cho_1281_opt
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_1281_opt
            ref.cast (ref $Option_12)
            struct.get $Option_12 0
            local.get $w1283
            struct.new $ListCons_30
          else
            local.get $w1283
          end
          local.set $w1283
          local.get $w1282
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1282
          br $while_1284_lp
        else
          br $while_1284_exit
        end
      end
    end
    local.get $w1283
    local.set $w1285
    ref.null $ListBase
    local.set $w1286
    block $while_1287_exit
      loop $while_1287_lp
        local.get $w1285
        ref.is_null
        i32.eqz
        if
          local.get $w1285
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1286
          struct.new $ListCons_30
          local.set $w1286
          local.get $w1285
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1285
          br $while_1287_lp
        else
          br $while_1287_exit
        end
      end
    end
    local.get $w1286
    local.set $w1289
    i32.const 0
    local.set $w1290
    block $while_1291_exit
      loop $while_1291_lp
        local.get $w1289
        ref.is_null
        i32.eqz
        if
          local.get $w1290
          local.get $w1289
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1290
          local.get $w1289
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1289
          br $while_1291_lp
        else
          br $while_1291_exit
        end
      end
    end
    local.get $w1290
  )
  (func $mapping_336 (param $self (ref $AnyFn)) (param $x i32) (result (ref null $ListBase))
    local.get $x
    local.get $x
    i32.const 10
    i32.mul
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
  )
  (func $closure_337 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqCollect (result i32) ;; exported as "testSeqCollect"
    (local $w1305 (ref null $ListBase))
    (local $w1293 (ref null $ListBase))
    (local $w1294 (ref null $ListBase))
    (local $w1295 (ref null $ListBase))
    (local $x i32)
    (local $w1299 (ref null $ListBase))
    (local $w1296 (ref null $ListBase))
    (local $w1297 (ref null $ListBase))
    (local $w1301 (ref null $ListBase))
    (local $w1302 (ref null $ListBase))
    (local $w1306 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1293
    ref.null $ListBase
    local.set $w1294
    block $while_1300_exit
      loop $while_1300_lp
        local.get $w1293
        ref.is_null
        i32.eqz
        if
          local.get $w1293
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          local.get $x
          i32.const 10
          i32.mul
          ref.null $ListBase
          struct.new $ListCons_30
          struct.new $ListCons_30
          local.set $w1295
          local.get $w1295
          local.set $w1296
          local.get $w1294
          local.set $w1297
          block $while_1298_exit
            loop $while_1298_lp
              local.get $w1296
              ref.is_null
              i32.eqz
              if
                local.get $w1296
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w1297
                struct.new $ListCons_30
                local.set $w1297
                local.get $w1296
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w1296
                br $while_1298_lp
              else
                br $while_1298_exit
              end
            end
          end
          local.get $w1297
          local.set $w1299
          local.get $w1299
          local.set $w1294
          local.get $w1293
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1293
          br $while_1300_lp
        else
          br $while_1300_exit
        end
      end
    end
    local.get $w1294
    local.set $w1301
    ref.null $ListBase
    local.set $w1302
    block $while_1303_exit
      loop $while_1303_lp
        local.get $w1301
        ref.is_null
        i32.eqz
        if
          local.get $w1301
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1302
          struct.new $ListCons_30
          local.set $w1302
          local.get $w1301
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1301
          br $while_1303_lp
        else
          br $while_1303_exit
        end
      end
    end
    local.get $w1302
    local.set $w1305
    i32.const 0
    local.set $w1306
    block $while_1307_exit
      loop $while_1307_lp
        local.get $w1305
        ref.is_null
        i32.eqz
        if
          local.get $w1306
          local.get $w1305
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1306
          local.get $w1305
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1305
          br $while_1307_lp
        else
          br $while_1307_exit
        end
      end
    end
    local.get $w1306
  )
  (func $reduction_338 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add
  )
  (func $testSeqReduce (result i32) ;; exported as "testSeqReduce"
    (local $w1308 (ref null $ListBase))
    (local $w1309 (ref $ListCons_30))
    (local $w1311 (ref null $ListBase))
    (local $w1312 i32)
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
    local.set $w1308
    local.get $w1308
    ref.cast (ref $ListCons_30)
    local.set $w1309
    local.get $w1309
    struct.get $ListCons_30 1
    local.set $w1311
    local.get $w1309
    struct.get $ListCons_30 0
    local.set $w1312
    block $while_1313_exit
      loop $while_1313_lp
        local.get $w1311
        ref.is_null
        i32.eqz
        if
          local.get $w1311
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $b
          local.get $w1312
          local.get $b
          i32.add
          local.set $w1312
          local.get $w1311
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1311
          br $while_1313_lp
        else
          br $while_1313_exit
        end
      end
    end
    local.get $w1312
  )
  (func $mapping_339 (param $self (ref $AnyFn)) (param $i i32) (param $x i32) (result i32)
    local.get $i
    local.get $x
    i32.add
  )
  (func $closure_340 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqMapIndexed (result i32) ;; exported as "testSeqMapIndexed"
    (local $w1323 (ref null $ListBase))
    (local $w1319 (ref null $ListBase))
    (local $w1315 (ref null $ListBase))
    (local $w1316 (ref null $ListBase))
    (local $w1317 i32)
    (local $x i32)
    (local $w1320 (ref null $ListBase))
    (local $w1324 i32)
    i32.const 10
    i32.const 20
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1315
    ref.null $ListBase
    local.set $w1316
    i32.const 0
    local.set $w1317
    block $while_1318_exit
      loop $while_1318_lp
        local.get $w1315
        ref.is_null
        i32.eqz
        if
          local.get $w1315
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $w1317
          local.get $x
          i32.add
          local.get $w1316
          struct.new $ListCons_30
          local.set $w1316
          local.get $w1317
          i32.const 1
          i32.add
          local.set $w1317
          local.get $w1315
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1315
          br $while_1318_lp
        else
          br $while_1318_exit
        end
      end
    end
    local.get $w1316
    local.set $w1319
    ref.null $ListBase
    local.set $w1320
    block $while_1321_exit
      loop $while_1321_lp
        local.get $w1319
        ref.is_null
        i32.eqz
        if
          local.get $w1319
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1320
          struct.new $ListCons_30
          local.set $w1320
          local.get $w1319
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1319
          br $while_1321_lp
        else
          br $while_1321_exit
        end
      end
    end
    local.get $w1320
    local.set $w1323
    i32.const 0
    local.set $w1324
    block $while_1325_exit
      loop $while_1325_lp
        local.get $w1323
        ref.is_null
        i32.eqz
        if
          local.get $w1324
          local.get $w1323
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1324
          local.get $w1323
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1323
          br $while_1325_lp
        else
          br $while_1325_exit
        end
      end
    end
    local.get $w1324
  )
  (func $closure_341 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
  )
  (func $testSeqForall (result i32) ;; exported as "testSeqForall"
    (local $w1327 (ref null $ListBase))
    (local $x i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1327
    block $all_1326_blk (result i32)
      block $all_1326_lp_exit
        loop $all_1326_lp
          local.get $w1327
          ref.is_null
          i32.eqz
          if
            local.get $w1327
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 0
            i32.gt_s
            if
              local.get $w1327
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w1327
            else
              i32.const 0
              br $all_1326_blk
            end
          else
            br $all_1326_lp_exit
          end
          br $all_1326_lp
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
  (func $closure_342 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_342
    struct.new $ClosureType_342
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
    return_call $Set_count
  )
  (func $closure_343 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_343
    struct.new $ClosureType_343
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
  (func $closure_344 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    (local $s2 (ref $SetModule_SetHandle`1))
    i32.const 4
    ref.func $closure_344
    struct.new $ClosureType_344
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
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
  (func $closure_345 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    i32.const 3
    ref.func $closure_345
    struct.new $ClosureType_345
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
    call $Set_remove
    return_call $Set_count
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
  (func $closure_347 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_346
    struct.new $ClosureType_346
    ref.null $ListBase
    call $Set_ofList
    local.set $e
    ref.func $closure_347
    struct.new $ClosureType_347
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
  (func $closure_348 (param $self (ref $AnyFn)) (param $acc i32) (param $x_1 i32) (result i32)
    local.get $acc
    local.get $x_1
    i32.add
  )
  (func $closure_349 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testSetFold (result i32) ;; exported as "testSetFold"
    ref.func $closure_348
    struct.new $ClosureType_348
    i32.const 0
    ref.func $closure_349
    struct.new $ClosureType_349
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
    return_call $Set_fold
  )
  (func $closure_350 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testSetToList (result i32) ;; exported as "testSetToList"
    (local $w1329 (ref null $ListBase))
    (local $w1330 i32)
    ref.func $closure_350
    struct.new $ClosureType_350
    i32.const 3
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    call $Set_toList
    local.set $w1329
    i32.const 0
    local.set $w1330
    block $while_1331_exit
      loop $while_1331_lp
        local.get $w1329
        ref.is_null
        i32.eqz
        if
          local.get $w1330
          i32.const 1
          i32.add
          local.set $w1330
          local.get $w1329
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1329
          br $while_1331_lp
        else
          br $while_1331_exit
        end
      end
    end
    local.get $w1330
  )
  (func $closure_351 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_352 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testSetFilter (result i32) ;; exported as "testSetFilter"
    ref.func $closure_351
    struct.new $ClosureType_351
    ref.func $closure_352
    struct.new $ClosureType_352
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
    call $Set_filter
    return_call $Set_count
  )
  (func $closure_353 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 4
    i32.gt_s
  )
  (func $closure_354 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testSetExists (result i32) ;; exported as "testSetExists"
    ref.func $closure_353
    struct.new $ClosureType_353
    ref.func $closure_354
    struct.new $ClosureType_354
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
    call $Set_exists
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_355 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 0
    i32.gt_s
  )
  (func $closure_356 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $testSetForall (result i32) ;; exported as "testSetForall"
    ref.func $closure_355
    struct.new $ClosureType_355
    ref.func $closure_356
    struct.new $ClosureType_356
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    call $Set_forAll
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $closure_357 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_358 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_357
    struct.new $ClosureType_357
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    ref.func $closure_358
    struct.new $ClosureType_358
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    call $Set_union
    return_call $Set_count
  )
  (func $closure_359 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_360 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_359
    struct.new $ClosureType_359
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
    ref.func $closure_360
    struct.new $ClosureType_360
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
    call $Set_intersect
    return_call $Set_count
  )
  (func $closure_361 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_362 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_361
    struct.new $ClosureType_361
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
    ref.func $closure_362
    struct.new $ClosureType_362
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    call $Set_difference
    return_call $Set_count
  )
  (func $closure_363 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_364 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    ref.func $closure_363
    struct.new $ClosureType_363
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    local.set $a
    ref.func $closure_364
    struct.new $ClosureType_364
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
  (func $closure_365 (param $self (ref $AnyFn)) (param $acc i32) (param $x_3 i32) (result i32)
    local.get $acc
    local.get $x_3
    i32.add
  )
  (func $closure_366 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 1
    i32.shl
  )
  (func $closure_367 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_368 (param $self (ref $AnyFn)) (param $x_2 i32) (param $y_1 i32) (result i32)
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
  (func $testSetMap (result i32) ;; exported as "testSetMap"
    ref.func $closure_365
    struct.new $ClosureType_365
    i32.const 0
    ref.func $closure_366
    struct.new $ClosureType_366
    ref.func $closure_367
    struct.new $ClosureType_367
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    call $Set_ofList
    call $Set_map
    return_call $Set_fold
  )
  (func $closure_369 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_369
    struct.new $ClosureType_369
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
  (func $closure_370 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_370
    struct.new $ClosureType_370
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
  (func $closure_371 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_371
    struct.new $ClosureType_371
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 2
    array.new_fixed $GcArray_41 4
    call $Set_ofArray
    return_call $Set_count
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
    (local $matchValue (ref null $Option_12))
    (local $w1333 (ref null $ListBase))
    i32.const 42
    i32.const 1
    i32.const 2
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1333
    local.get $w1333
    ref.is_null
    if (result (ref null $Option_12))
      ref.null $Option_12
    else
      local.get $w1333
      ref.cast (ref $ListCons_30)
      struct.get $ListCons_30 0
      struct.new $Option_12
    end
    local.set $matchValue
    local.get $matchValue
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $matchValue
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    end
  )
  (func $testSeqTryHeadEmpty (result i32) ;; exported as "testSeqTryHeadEmpty"
    (local $matchValue (ref null $Option_12))
    ref.null $Option_12
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
    (local $w1337 (ref null $ListBase))
    (local $w1338 i32)
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
    local.set $w1337
    i32.const 0
    local.set $w1338
    block $while_1339_exit
      loop $while_1339_lp
        local.get $w1337
        ref.is_null
        i32.eqz
        if
          local.get $w1338
          i32.const 1
          i32.add
          local.set $w1338
          local.get $w1337
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1337
          br $while_1339_lp
        else
          br $while_1339_exit
        end
      end
    end
    local.get $w1338
  )
  (func $testSeqItem (result i32) ;; exported as "testSeqItem"
    (local $w1341 i32)
    (local $w1342 (ref null $ListBase))
    i32.const 2
    local.set $w1341
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1342
    block $while_1343_exit
      loop $while_1343_lp
        local.get $w1341
        i32.const 0
        i32.gt_s
        if
          local.get $w1342
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1342
          local.get $w1341
          i32.const 1
          i32.sub
          local.set $w1341
          br $while_1343_lp
        else
          br $while_1343_exit
        end
      end
    end
    local.get $w1342
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_372 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_373 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y_1 i32) (result i32)
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
    (local $w1345 (ref null $ListBase))
    (local $w1346 (ref $ListCons_30))
    (local $w1347 i32)
    (local $w1348 (ref null $ListBase))
    (local $w1349 i32)
    (local $w1352 (ref null $ListBase))
    (local $w1353 (ref $ListCons_30))
    (local $w1354 i32)
    (local $w1355 (ref null $ListBase))
    (local $w1356 i32)
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
    local.set $w1345
    local.get $w1345
    ref.cast (ref $ListCons_30)
    local.set $w1346
    local.get $w1346
    struct.get $ListCons_30 0
    local.set $w1347
    local.get $w1346
    struct.get $ListCons_30 1
    local.set $w1348
    block $while_1350_exit
      loop $while_1350_lp
        local.get $w1348
        ref.is_null
        i32.eqz
        if
          local.get $w1348
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w1349
          local.get $w1349
          local.get $w1347
          i32.lt_s
          if
            local.get $w1349
            local.set $w1347
          end
          local.get $w1348
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1348
          br $while_1350_lp
        else
          br $while_1350_exit
        end
      end
    end
    local.get $w1347
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
    local.set $w1352
    local.get $w1352
    ref.cast (ref $ListCons_30)
    local.set $w1353
    local.get $w1353
    struct.get $ListCons_30 0
    local.set $w1354
    local.get $w1353
    struct.get $ListCons_30 1
    local.set $w1355
    block $while_1357_exit
      loop $while_1357_lp
        local.get $w1355
        ref.is_null
        i32.eqz
        if
          local.get $w1355
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w1356
          local.get $w1356
          local.get $w1354
          i32.gt_s
          if
            local.get $w1356
            local.set $w1354
          end
          local.get $w1355
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1355
          br $while_1357_lp
        else
          br $while_1357_exit
        end
      end
    end
    local.get $w1354
    i32.add
  )
  (func $projection_374 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
  )
  (func $closure_375 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
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
  (func $testSeqSortBy (result i32) ;; exported as "testSeqSortBy"
    (local $w1359 (ref null $ListBase))
    (local $w1363 i32)
    (local $w1360 (ref null $ListBase))
    (local $w1361 i32)
    (local $w1364 (ref $GcArray_41))
    (local $w1365 (ref $GcArray_41))
    (local $w1366 (ref null $ListBase))
    (local $w1367 i32)
    (local $w1368 i32)
    (local $w1371 i32)
    (local $w1372 i32)
    (local $w1373 i32)
    (local $w1374 i32)
    (local $w1377 i32)
    (local $w1378 (ref null $ListBase))
    i32.const 30
    i32.const 10
    i32.const 20
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1359
    local.get $w1359
    local.set $w1360
    i32.const 0
    local.set $w1361
    block $while_1362_exit
      loop $while_1362_lp
        local.get $w1360
        ref.is_null
        i32.eqz
        if
          local.get $w1361
          i32.const 1
          i32.add
          local.set $w1361
          local.get $w1360
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1360
          br $while_1362_lp
        else
          br $while_1362_exit
        end
      end
    end
    local.get $w1361
    local.set $w1363
    i32.const 0
    local.get $w1363
    array.new $GcArray_41
    local.set $w1364
    i32.const 0
    local.get $w1363
    array.new $GcArray_41
    local.set $w1365
    local.get $w1359
    local.set $w1366
    i32.const 0
    local.set $w1367
    block $while_1370_exit
      loop $while_1370_lp
        local.get $w1366
        ref.is_null
        i32.eqz
        if
          local.get $w1366
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $w1368
          local.get $w1364
          local.get $w1367
          local.get $w1368
          array.set $GcArray_41
          local.get $w1365
          local.get $w1367
          local.get $w1368
          array.set $GcArray_41
          local.get $w1367
          i32.const 1
          i32.add
          local.set $w1367
          local.get $w1366
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1366
          br $while_1370_lp
        else
          br $while_1370_exit
        end
      end
    end
    local.get $w1367
    drop
    i32.const 1
    local.set $w1371
    block $while_1376_exit
      loop $while_1376_lp
        local.get $w1371
        local.get $w1363
        i32.lt_s
        if
          local.get $w1364
          local.get $w1371
          array.get $GcArray_41
          local.set $w1372
          local.get $w1365
          local.get $w1371
          array.get $GcArray_41
          local.set $w1373
          local.get $w1371
          i32.const 1
          i32.sub
          local.set $w1374
          block $while_1375_exit
            loop $while_1375_lp
              local.get $w1374
              i32.const 0
              i32.ge_s
              if (result i32)
                local.get $w1365
                local.get $w1374
                array.get $GcArray_41
                local.get $w1373
                i32.gt_s
              else
                i32.const 0
              end
              if
                local.get $w1364
                local.get $w1374
                i32.const 1
                i32.add
                local.get $w1364
                local.get $w1374
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w1365
                local.get $w1374
                i32.const 1
                i32.add
                local.get $w1365
                local.get $w1374
                array.get $GcArray_41
                array.set $GcArray_41
                local.get $w1374
                i32.const 1
                i32.sub
                local.set $w1374
                br $while_1375_lp
              else
                br $while_1375_exit
              end
            end
          end
          local.get $w1364
          local.get $w1374
          i32.const 1
          i32.add
          local.get $w1372
          array.set $GcArray_41
          local.get $w1365
          local.get $w1374
          i32.const 1
          i32.add
          local.get $w1373
          array.set $GcArray_41
          local.get $w1371
          i32.const 1
          i32.add
          local.set $w1371
          br $while_1376_lp
        else
          br $while_1376_exit
        end
      end
    end
    local.get $w1363
    i32.const 1
    i32.sub
    local.set $w1377
    ref.null $ListBase
    local.set $w1378
    block $while_1379_exit
      loop $while_1379_lp
        local.get $w1377
        i32.const 0
        i32.ge_s
        if
          local.get $w1364
          local.get $w1377
          array.get $GcArray_41
          local.get $w1378
          struct.new $ListCons_30
          local.set $w1378
          local.get $w1377
          i32.const 1
          i32.sub
          local.set $w1377
          br $while_1379_lp
        else
          br $while_1379_exit
        end
      end
    end
    local.get $w1378
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $testSeqRev (result i32) ;; exported as "testSeqRev"
    (local $w1381 (ref null $ListBase))
    (local $w1382 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1381
    ref.null $ListBase
    local.set $w1382
    block $while_1383_exit
      loop $while_1383_lp
        local.get $w1381
        ref.is_null
        i32.eqz
        if
          local.get $w1381
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1382
          struct.new $ListCons_30
          local.set $w1382
          local.get $w1381
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1381
          br $while_1383_lp
        else
          br $while_1383_exit
        end
      end
    end
    local.get $w1382
    ref.cast (ref $ListCons_30)
    struct.get $ListCons_30 0
  )
  (func $closure_376 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 20
    i32.gt_s
  )
  (func $testSeqFindIndex (result i32) ;; exported as "testSeqFindIndex"
    (local $w1385 (ref null $ListBase))
    (local $w1386 i32)
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
    local.set $w1385
    i32.const 0
    local.set $w1386
    block $fdi_1384_exit (result i32)
      loop $fdi_1384_lp
        local.get $w1385
        ref.is_null
        i32.eqz
        if
          local.get $w1385
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 20
          i32.gt_s
          if
            local.get $w1386
            br $fdi_1384_exit
          else
            local.get $w1386
            i32.const 1
            i32.add
            local.set $w1386
            local.get $w1385
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1385
            br $fdi_1384_lp
          end
        end
      end
      i32.const -1
    end
  )
  (func $closure_377 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testSeqSkipTake (result i32) ;; exported as "testSeqSkipTake"
    (local $w1404 (ref null $ListBase))
    (local $w1400 (ref null $ListBase))
    (local $w1392 i32)
    (local $w1397 (ref null $ListBase))
    (local $w1394 i32)
    (local $w1395 (ref null $ListBase))
    (local $w1398 (ref null $ListBase))
    (local $w1401 (ref null $ListBase))
    (local $w1405 i32)
    i32.const 2
    local.set $w1392
    i32.const 2
    local.set $w1394
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
    local.set $w1395
    block $while_1396_exit
      loop $while_1396_lp
        local.get $w1394
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w1395
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w1395
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1395
          local.get $w1394
          i32.const 1
          i32.sub
          local.set $w1394
          br $while_1396_lp
        else
          br $while_1396_exit
        end
      end
    end
    local.get $w1395
    local.set $w1397
    ref.null $ListBase
    local.set $w1398
    block $while_1399_exit
      loop $while_1399_lp
        local.get $w1392
        i32.const 0
        i32.gt_s
        if (result i32)
          local.get $w1397
          ref.is_null
          i32.eqz
        else
          i32.const 0
        end
        if
          local.get $w1397
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1398
          struct.new $ListCons_30
          local.set $w1398
          local.get $w1397
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1397
          local.get $w1392
          i32.const 1
          i32.sub
          local.set $w1392
          br $while_1399_lp
        else
          br $while_1399_exit
        end
      end
    end
    local.get $w1398
    local.set $w1400
    ref.null $ListBase
    local.set $w1401
    block $while_1402_exit
      loop $while_1402_lp
        local.get $w1400
        ref.is_null
        i32.eqz
        if
          local.get $w1400
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1401
          struct.new $ListCons_30
          local.set $w1401
          local.get $w1400
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1400
          br $while_1402_lp
        else
          br $while_1402_exit
        end
      end
    end
    local.get $w1401
    local.set $w1404
    i32.const 0
    local.set $w1405
    block $while_1406_exit
      loop $while_1406_lp
        local.get $w1404
        ref.is_null
        i32.eqz
        if
          local.get $w1405
          local.get $w1404
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1405
          local.get $w1404
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1404
          br $while_1406_lp
        else
          br $while_1406_exit
        end
      end
    end
    local.get $w1405
  )
  (func $projection_378 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.rem_s
  )
  (func $closure_379 (param $self (ref $AnyFn)) (param $x_1 i32) (param $y i32) (result i32)
    local.get $x_1
    local.get $y
    i32.eq
  )
  (func $testSeqGroupByCount (result i32) ;; exported as "testSeqGroupByCount"
    (local $w1426 (ref null $ListBase))
    (local $w1408 (ref null $ListBase))
    (local $w1409 (ref null $ListBase))
    (local $w1410 i32)
    (local $w1411 (ref null $ListBase))
    (local $x i32)
    (local $gb_1407_k i32)
    (local $w1412 (ref null $ListBase))
    (local $w1413 (ref null $ListBase))
    (local $gb_1407_rv (ref null $ListBase))
    (local $w1415 (ref null $ListBase))
    (local $w1416 (ref null $ListBase))
    (local $w1419 (ref null $ListBase))
    (local $w1420 (ref null $ListBase))
    (local $w1421 (ref null $ListBase))
    (local $w1422 (ref null $ListBase))
    (local $w1427 i32)
    ref.null $ListBase
    local.set $w1408
    ref.null $ListBase
    local.set $w1409
    i32.const 0
    local.set $w1410
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
    local.set $w1411
    block $while_1418_exit
      loop $while_1418_lp
        local.get $w1411
        ref.is_null
        i32.eqz
        if
          local.get $w1411
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 2
          i32.rem_s
          local.set $gb_1407_k
          i32.const 0
          local.set $w1410
          local.get $w1408
          local.set $w1412
          ref.null $ListBase
          local.set $w1413
          block $while_1414_exit
            loop $while_1414_lp
              local.get $w1412
              ref.is_null
              i32.eqz
              if
                local.get $w1410
                i32.eqz
                local.get $w1412
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 0
                struct.get $Tuple_300 0
                local.get $gb_1407_k
                i32.eq
                i32.and
                if (result (ref null $ListBase))
                  i32.const 1
                  local.set $w1410
                  local.get $w1412
                  ref.cast (ref $ListCons_301)
                  struct.get $ListCons_301 0
                  struct.get $Tuple_300 0
                  local.get $x
                  local.get $w1412
                  ref.cast (ref $ListCons_301)
                  struct.get $ListCons_301 0
                  struct.get $Tuple_300 1
                  struct.new $ListCons_30
                  struct.new $Tuple_300
                  local.get $w1413
                  struct.new $ListCons_301
                else
                  local.get $w1412
                  ref.cast (ref $ListCons_301)
                  struct.get $ListCons_301 0
                  local.get $w1413
                  struct.new $ListCons_301
                end
                local.set $w1413
                local.get $w1412
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 1
                local.set $w1412
                br $while_1414_lp
              else
                br $while_1414_exit
              end
            end
          end
          local.get $w1413
          local.set $w1409
          local.get $w1409
          local.set $w1415
          ref.null $ListBase
          local.set $w1416
          block $while_1417_exit
            loop $while_1417_lp
              local.get $w1415
              ref.is_null
              i32.eqz
              if
                local.get $w1415
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 0
                local.get $w1416
                struct.new $ListCons_301
                local.set $w1416
                local.get $w1415
                ref.cast (ref $ListCons_301)
                struct.get $ListCons_301 1
                local.set $w1415
                br $while_1417_lp
              else
                br $while_1417_exit
              end
            end
          end
          local.get $w1416
          local.set $gb_1407_rv
          local.get $w1410
          if (result (ref null $ListBase))
            local.get $gb_1407_rv
          else
            local.get $gb_1407_k
            local.get $x
            ref.null $ListBase
            struct.new $ListCons_30
            struct.new $Tuple_300
            local.get $gb_1407_rv
            struct.new $ListCons_301
          end
          local.set $w1408
          local.get $w1411
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1411
          br $while_1418_lp
        else
          br $while_1418_exit
        end
      end
    end
    ref.null $ListBase
    local.set $w1419
    local.get $w1408
    local.set $w1420
    block $while_1424_exit
      loop $while_1424_lp
        local.get $w1420
        ref.is_null
        i32.eqz
        if
          local.get $w1420
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 0
          struct.get $Tuple_300 0
          local.get $w1420
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 0
          struct.get $Tuple_300 1
          local.set $w1421
          ref.null $ListBase
          local.set $w1422
          block $while_1423_exit
            loop $while_1423_lp
              local.get $w1421
              ref.is_null
              i32.eqz
              if
                local.get $w1421
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 0
                local.get $w1422
                struct.new $ListCons_30
                local.set $w1422
                local.get $w1421
                ref.cast (ref $ListCons_30)
                struct.get $ListCons_30 1
                local.set $w1421
                br $while_1423_lp
              else
                br $while_1423_exit
              end
            end
          end
          local.get $w1422
          struct.new $Tuple_300
          local.get $w1419
          struct.new $ListCons_301
          local.set $w1419
          local.get $w1420
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 1
          local.set $w1420
          br $while_1424_lp
        else
          br $while_1424_exit
        end
      end
    end
    local.get $w1419
    local.set $w1426
    i32.const 0
    local.set $w1427
    block $while_1428_exit
      loop $while_1428_lp
        local.get $w1426
        ref.is_null
        i32.eqz
        if
          local.get $w1427
          i32.const 1
          i32.add
          local.set $w1427
          local.get $w1426
          ref.cast (ref $ListCons_301)
          struct.get $ListCons_301 1
          local.set $w1426
          br $while_1428_lp
        else
          br $while_1428_exit
        end
      end
    end
    local.get $w1427
  )
  (func $testExnNestedFailwith (result i32) ;; exported as "testExnNestedFailwith"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 110
                i32.const 101
                i32.const 115
                i32.const 116
                i32.const 101
                i32.const 100
                i32.const 32
                i32.const 98
                i32.const 111
                i32.const 111
                i32.const 109
                array.new_fixed $WasmStr 11
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
                i32.const 0
        )
        br 1
      )
        i32.const 77
    )
  )
  (func $testExnUnit (result i32) ;; exported as "testExnUnit"
    (local $x i32)
    i32.const 0
    local.set $x
    (block
      (block
        (try_table (catch_all 0)
                i32.const 10
                local.set $x
                i32.const 101
                i32.const 114
                i32.const 114
                array.new_fixed $WasmStr 3
                struct.new $Exception
                global.set $fsharp_exn_carrier
                ref.null any
                global.set $fsharp_exn_carrier
                throw $fsharp_exn
        )
        br 1
      )
        local.get $x
        i32.const 5
        i32.add
        local.set $x
    )
    local.get $x
  )
  (func $testExnNormalPath (result i32) ;; exported as "testExnNormalPath"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 30
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
                            i32.const 0
                    )
                    br 1
                  )
                    i32.const 42
                )
                i32.const 1
                i32.add
        )
        br 1
      )
        i32.const 0
    )
  )
  (func $testExnNestedRethrow (result i32) ;; exported as "testExnNestedRethrow"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                (block (result i32)
                  (block
                    (try_table (result i32) (catch_all 0)
                            i32.const 112
                            i32.const 97
                            i32.const 115
                            i32.const 115
                            i32.const 45
                            i32.const 116
                            i32.const 104
                            i32.const 114
                            i32.const 111
                            i32.const 117
                            i32.const 103
                            i32.const 104
                            array.new_fixed $WasmStr 12
                            struct.new $Exception
                            global.set $fsharp_exn_carrier
                            ref.null any
                            global.set $fsharp_exn_carrier
                            throw $fsharp_exn
                            i32.const 0
                    )
                    br 1
                  )
                    i32.const 111
                    i32.const 117
                    i32.const 116
                    i32.const 101
                    i32.const 114
                    i32.const 45
                    i32.const 98
                    i32.const 111
                    i32.const 111
                    i32.const 109
                    array.new_fixed $WasmStr 10
                    struct.new $Exception
                    global.set $fsharp_exn_carrier
                    ref.null any
                    global.set $fsharp_exn_carrier
                    throw $fsharp_exn
                    i32.const 0
                )
        )
        br 1
      )
        i32.const 99
    )
  )
  (func $mapping_380 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.add
  )
  (func $closure_381 (param $self (ref $AnyFn)) (result i32)
    i32.const 0
  )
  (func $testClosureCapMap (result i32) ;; exported as "testClosureCapMap"
    (local $w1437 (ref null $ListBase))
    (local $w1433 (ref null $ListBase))
    (local $w1430 (ref null $ListBase))
    (local $w1431 (ref null $ListBase))
    (local $x i32)
    (local $w1434 (ref null $ListBase))
    (local $w1438 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_30
    struct.new $ListCons_30
    struct.new $ListCons_30
    local.set $w1430
    ref.null $ListBase
    local.set $w1431
    block $while_1432_exit
      loop $while_1432_lp
        local.get $w1430
        ref.is_null
        i32.eqz
        if
          local.get $w1430
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 10
          i32.add
          local.get $w1431
          struct.new $ListCons_30
          local.set $w1431
          local.get $w1430
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1430
          br $while_1432_lp
        else
          br $while_1432_exit
        end
      end
    end
    local.get $w1431
    local.set $w1433
    ref.null $ListBase
    local.set $w1434
    block $while_1435_exit
      loop $while_1435_lp
        local.get $w1433
        ref.is_null
        i32.eqz
        if
          local.get $w1433
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1434
          struct.new $ListCons_30
          local.set $w1434
          local.get $w1433
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1433
          br $while_1435_lp
        else
          br $while_1435_exit
        end
      end
    end
    local.get $w1434
    local.set $w1437
    i32.const 0
    local.set $w1438
    block $while_1439_exit
      loop $while_1439_lp
        local.get $w1437
        ref.is_null
        i32.eqz
        if
          local.get $w1438
          local.get $w1437
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          i32.add
          local.set $w1438
          local.get $w1437
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1437
          br $while_1439_lp
        else
          br $while_1439_exit
        end
      end
    end
    local.get $w1438
  )
  (func $predicate_382 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.gt_s
  )
  (func $testClosureCapFilter (result i32) ;; exported as "testClosureCapFilter"
    (local $w1448 (ref null $ListBase))
    (local $w1444 (ref null $ListBase))
    (local $w1441 (ref null $ListBase))
    (local $w1442 (ref null $ListBase))
    (local $x i32)
    (local $w1445 (ref null $ListBase))
    (local $w1449 i32)
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
    local.set $w1441
    ref.null $ListBase
    local.set $w1442
    block $while_1443_exit
      loop $while_1443_lp
        local.get $w1441
        ref.is_null
        i32.eqz
        if
          local.get $w1441
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $x
          i32.const 3
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w1441
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.get $w1442
            struct.new $ListCons_30
          else
            local.get $w1442
          end
          local.set $w1442
          local.get $w1441
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1441
          br $while_1443_lp
        else
          br $while_1443_exit
        end
      end
    end
    local.get $w1442
    local.set $w1444
    ref.null $ListBase
    local.set $w1445
    block $while_1446_exit
      loop $while_1446_lp
        local.get $w1444
        ref.is_null
        i32.eqz
        if
          local.get $w1444
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.get $w1445
          struct.new $ListCons_30
          local.set $w1445
          local.get $w1444
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1444
          br $while_1446_lp
        else
          br $while_1446_exit
        end
      end
    end
    local.get $w1445
    local.set $w1448
    i32.const 0
    local.set $w1449
    block $while_1450_exit
      loop $while_1450_lp
        local.get $w1448
        ref.is_null
        i32.eqz
        if
          local.get $w1449
          i32.const 1
          i32.add
          local.set $w1449
          local.get $w1448
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1448
          br $while_1450_lp
        else
          br $while_1450_exit
        end
      end
    end
    local.get $w1449
  )
  (func $closure_383 (param $self (ref $AnyFn)) (param $acc i32) (param $x i32) (result i32)
    local.get $acc
    local.get $x
    i32.const 1
    i32.shl
    i32.add
  )
  (func $testClosureCapFold (result i32) ;; exported as "testClosureCapFold"
    (local $w1452 (ref null $ListBase))
    (local $w1453 i32)
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
    local.set $w1452
    i32.const 0
    local.set $w1453
    block $while_1454_exit
      loop $while_1454_lp
        local.get $w1452
        ref.is_null
        i32.eqz
        if
          local.get $w1452
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 0
          local.set $x
          local.get $w1453
          local.get $x
          i32.const 1
          i32.shl
          i32.add
          local.set $w1453
          local.get $w1452
          ref.cast (ref $ListCons_30)
          struct.get $ListCons_30 1
          local.set $w1452
          br $while_1454_lp
        else
          br $while_1454_exit
        end
      end
    end
    local.get $w1453
  )
  (func $closure_384 (param $self (ref $AnyFn)) (param $n i32) (param $x i32) (result i32)
    local.get $x
    local.get $n
    i32.add
  )
  (func $closure_385 (param $self (ref $AnyFn)) (param $a0 i32) (result i32)
    (local $self_cast (ref $ClosureType_385))
    (local $makeAdder_1 (ref $AnyFn))
    (local $lo_clo_45 (ref $ClosureBase_31))
    local.get $self
    ref.cast (ref $ClosureType_385)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_385 1
    local.set $makeAdder_1
    local.get $makeAdder_1
    ref.cast (ref $ClosureBase_31)
    local.set $lo_clo_45
    local.get $lo_clo_45
    i32.const 5
    local.get $a0
    local.get $lo_clo_45
    struct.get $ClosureBase_31 0
    call_ref $FuncType_11
  )
  (func $closure_386 (param $self (ref $AnyFn)) (param $a0 i32) (result i32)
    (local $self_cast (ref $ClosureType_386))
    (local $makeAdder_1 (ref $AnyFn))
    (local $lo_clo_46 (ref $ClosureBase_31))
    local.get $self
    ref.cast (ref $ClosureType_386)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_386 1
    local.set $makeAdder_1
    local.get $makeAdder_1
    ref.cast (ref $ClosureBase_31)
    local.set $lo_clo_46
    local.get $lo_clo_46
    i32.const 10
    local.get $a0
    local.get $lo_clo_46
    struct.get $ClosureBase_31 0
    call_ref $FuncType_11
  )
  (func $testClosureHigherOrder (result i32) ;; exported as "testClosureHigherOrder"
    (local $makeAdder_1 (ref $ClosureType_384))
    (local $add5 (ref $ClosureType_385))
    (local $add10 (ref $ClosureType_386))
    (local $lo_clo_47 (ref $ClosureBase_59))
    (local $lo_clo_48 (ref $ClosureBase_59))
    ref.func $closure_384
    struct.new $ClosureType_384
    local.set $makeAdder_1
    ref.func $closure_385
    local.get $makeAdder_1
    struct.new $ClosureType_385
    local.set $add5
    ref.func $closure_386
    local.get $makeAdder_1
    struct.new $ClosureType_386
    local.set $add10
    local.get $add5
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_47
    local.get $lo_clo_47
    i32.const 3
    local.get $lo_clo_47
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
    local.get $add10
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_48
    local.get $lo_clo_48
    i32.const 7
    local.get $lo_clo_48
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
    i32.add
  )
  (func $closure_387 (param $self (ref $AnyFn))
    (local $self_cast (ref $ClosureType_388))
    (local $counter (ref $RefCell_90))
    local.get $self
    ref.cast (ref $ClosureType_388)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_388 1
    local.set $counter
    local.get $counter
    local.get $counter
    struct.get $RefCell_90 0
    i32.const 1
    i32.add
    struct.set $RefCell_90 0
  )
  (func $testClosureCapRef (result i32) ;; exported as "testClosureCapRef"
    (local $counter (ref $RefCell_90))
    (local $increment (ref $ClosureType_388))
    (local $lo_clo_49 (ref $ClosureBase_387))
    (local $lo_clo_50 (ref $ClosureBase_387))
    (local $lo_clo_51 (ref $ClosureBase_387))
    i32.const 0
    struct.new $RefCell_90
    local.set $counter
    ref.func $closure_387
    local.get $counter
    struct.new $ClosureType_388
    local.set $increment
    local.get $increment
    ref.cast (ref $ClosureBase_387)
    local.set $lo_clo_49
    local.get $lo_clo_49
    local.get $lo_clo_49
    struct.get $ClosureBase_387 0
    call_ref $FuncType_44
    local.get $increment
    ref.cast (ref $ClosureBase_387)
    local.set $lo_clo_50
    local.get $lo_clo_50
    local.get $lo_clo_50
    struct.get $ClosureBase_387 0
    call_ref $FuncType_44
    local.get $increment
    ref.cast (ref $ClosureBase_387)
    local.set $lo_clo_51
    local.get $lo_clo_51
    local.get $lo_clo_51
    struct.get $ClosureBase_387 0
    call_ref $FuncType_44
    local.get $counter
    struct.get $RefCell_90 0
  )
  (func $testClosureNestedCapture (result i32) ;; exported as "testClosureNestedCapture"
    i32.const 108
  )
  (func $closure_389 (param $self (ref $AnyFn)) (param $acc i32) (param $v i32) (result i32)
    local.get $acc
    local.get $v
    i32.add
    i32.const 100
    i32.add
  )
  (func $closure_390 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
    ref.func $closure_389
    struct.new $ClosureType_389
    i32.const 0
    ref.func $closure_390
    struct.new $ClosureType_390
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
  (func $closure_391 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 7
    i32.eq
  )
  (func $testClosureCapListExists (result i32) ;; exported as "testClosureCapListExists"
    (local $w1456 (ref null $ListBase))
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
    local.set $w1456
    block $exi_1455_blk (result i32)
      block $exi_1455_lp_exit
        loop $exi_1455_lp
          local.get $w1456
          ref.is_null
          i32.eqz
          if
            local.get $w1456
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 7
            i32.eq
            if
              i32.const 1
              br $exi_1455_blk
            end
            local.get $w1456
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 1
            local.set $w1456
          else
            br $exi_1455_lp_exit
          end
          br $exi_1455_lp
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
  (func $closure_392 (param $self (ref $AnyFn)) (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.lt_s
  )
  (func $testClosureCapListForAll (result i32) ;; exported as "testClosureCapListForAll"
    (local $w1458 (ref null $ListBase))
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
    local.set $w1458
    block $all_1457_blk (result i32)
      block $all_1457_lp_exit
        loop $all_1457_lp
          local.get $w1458
          ref.is_null
          i32.eqz
          if
            local.get $w1458
            ref.cast (ref $ListCons_30)
            struct.get $ListCons_30 0
            local.set $x
            local.get $x
            i32.const 10
            i32.lt_s
            if
              local.get $w1458
              ref.cast (ref $ListCons_30)
              struct.get $ListCons_30 1
              local.set $w1458
            else
              i32.const 0
              br $all_1457_blk
            end
          else
            br $all_1457_lp_exit
          end
          br $all_1457_lp
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
  (func $closure_393 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
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
  (func $closure_394 (param $self (ref $AnyFn)) (param $acc i32) (param $_k i32) (param $v i32) (result i32)
    local.get $acc
    local.get $v
    i32.add
  )
  (func $reverseCmp_395 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
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
  (func $testMapCustomCmpReverse (result i32) ;; exported as "testMapCustomCmpReverse"
    (local $m (ref $MapModule_MapHandle`2))
    ref.func $closure_393
    struct.new $ClosureType_393
    i32.const 1
    i32.const 10
    struct.new $Tuple_15
    i32.const 2
    i32.const 20
    struct.new $Tuple_15
    i32.const 3
    i32.const 30
    struct.new $Tuple_15
    ref.null $ListBase
    struct.new $ListCons_16
    struct.new $ListCons_16
    struct.new $ListCons_16
    call $Map_ofList
    local.set $m
    ref.func $closure_394
    struct.new $ClosureType_394
    i32.const 0
    i32.const 3
    i32.const 30
    i32.const 2
    i32.const 20
    i32.const 1
    i32.const 10
    ref.func $reverseCmp_395
    struct.new $ClosureType_395
    call $Map_empty
    call $Map_add
    call $Map_add
    call $Map_add
    return_call $Map_fold
  )
  (func $closure_396 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapModuleContainsKey (result i32) ;; exported as "testMapModuleContainsKey"
    (local $m_3 (ref $MapModule_MapHandle`2))
    i32.const 30
    i32.const 300
    i32.const 20
    i32.const 200
    i32.const 10
    i32.const 100
    ref.func $closure_396
    struct.new $ClosureType_396
    call $Map_empty
    call $Map_add
    call $Map_add
    call $Map_add
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
  (func $closure_397 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapModuleFindRoundTrip (result i32) ;; exported as "testMapModuleFindRoundTrip"
    (local $m_2 (ref $MapModule_MapHandle`2))
    (local $w1459 (ref null $Option_12))
    i32.const 8
    i32.const 88
    i32.const 7
    i32.const 77
    ref.func $closure_397
    struct.new $ClosureType_397
    call $Map_empty
    call $Map_add
    call $Map_add
    local.set $m_2
    i32.const 7
    local.get $m_2
    call $Map_find
    i32.const 8
    local.get $m_2
    call $Map_tryFind
    local.set $w1459
    local.get $w1459
    ref.is_null
    if (result i32)
      local.get $w1459
      ref.cast (ref $Option_12)
      struct.get $Option_12 0
    else
      i32.const 0
    end
    i32.add
  )
  (func $closure_398 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testSetModuleBasic (result i32) ;; exported as "testSetModuleBasic"
    i32.const 7
    i32.const 3
    i32.const 5
    ref.func $closure_398
    struct.new $ClosureType_398
    call $Set_empty
    call $Set_add
    call $Set_add
    call $Set_add
    return_call $Set_count
  )
  (func $closure_399 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testSetModuleDedup (result i32) ;; exported as "testSetModuleDedup"
    i32.const 2
    i32.const 2
    i32.const 1
    i32.const 1
    ref.func $closure_399
    struct.new $ClosureType_399
    call $Set_empty
    call $Set_add
    call $Set_add
    call $Set_add
    call $Set_add
    return_call $Set_count
  )
  (func $closure_400 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testSetModuleContains (result i32) ;; exported as "testSetModuleContains"
    (local $s_2 (ref $SetModule_SetHandle`1))
    i32.const 99
    i32.const 42
    ref.func $closure_400
    struct.new $ClosureType_400
    call $Set_empty
    call $Set_add
    call $Set_add
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
  (func $closure_401 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapModuleRemove (result i32) ;; exported as "testMapModuleRemove"
    i32.const 2
    i32.const 3
    i32.const 30
    i32.const 2
    i32.const 20
    i32.const 1
    i32.const 10
    ref.func $closure_401
    struct.new $ClosureType_401
    call $Map_empty
    call $Map_add
    call $Map_add
    call $Map_add
    call $Map_remove
    return_call $Map_count
  )
  (func $closure_402 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testMapModuleToList (result i32) ;; exported as "testMapModuleToList"
    (local $w1461 (ref null $ListBase))
    (local $w1462 i32)
    i32.const 2
    i32.const 20
    i32.const 1
    i32.const 10
    i32.const 3
    i32.const 30
    ref.func $closure_402
    struct.new $ClosureType_402
    call $Map_empty
    call $Map_add
    call $Map_add
    call $Map_add
    call $Map_toList
    local.set $w1461
    i32.const 0
    local.set $w1462
    block $while_1463_exit
      loop $while_1463_lp
        local.get $w1461
        ref.is_null
        i32.eqz
        if
          local.get $w1462
          i32.const 1
          i32.add
          local.set $w1462
          local.get $w1461
          ref.cast (ref $ListCons_16)
          struct.get $ListCons_16 1
          local.set $w1461
          br $while_1463_lp
        else
          br $while_1463_exit
        end
      end
    end
    local.get $w1462
  )
  (func $closure_403 (param $self (ref $AnyFn)) (param $acc i32) (param $x i32) (result i32)
    local.get $acc
    local.get $x
    i32.add
  )
  (func $closure_404 (param $self (ref $AnyFn)) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $intCmp
  )
  (func $testSetModuleFold (result i32) ;; exported as "testSetModuleFold"
    ref.func $closure_403
    struct.new $ClosureType_403
    i32.const 0
    i32.const 30
    i32.const 20
    i32.const 10
    ref.func $closure_404
    struct.new $ClosureType_404
    call $Set_empty
    call $Set_add
    call $Set_add
    call $Set_add
    return_call $Set_fold
  )
  (func $letrec_isEven_406 (param $self (ref $AnyFn)) (param $n i32) (result i32)
    (local $lo_clo_52 (ref $ClosureBase_59))
    (local $isOdd (ref $AnyFn))
    local.get $n
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $isOdd
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_52
      local.get $lo_clo_52
      local.get $n
      i32.const 1
      i32.sub
      local.get $lo_clo_52
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
    end
  )
  (func $letrec_isOdd_407 (param $self (ref $AnyFn)) (param $n_1 i32) (result i32)
    (local $lo_clo_53 (ref $ClosureBase_59))
    (local $isEven (ref $AnyFn))
    local.get $n_1
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $isEven
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_53
      local.get $lo_clo_53
      local.get $n_1
      i32.const 1
      i32.sub
      local.get $lo_clo_53
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
    end
  )
  (func $testMutualLetRec (result i32) ;; exported as "testMutualLetRec"
    (local $letrec_cell_isEven (ref $RefCell_405))
    (local $letrec_cell_isOdd (ref $RefCell_405))
    (local $lo_clo_54 (ref $ClosureBase_59))
    (local $lo_clo_55 (ref $ClosureBase_59))
    (local $isEven (ref $AnyFn))
    (local $isOdd (ref $AnyFn))
    ref.func $letrec_isEven_406
    local.get $letrec_cell_isOdd
    struct.new $ClosureType_406
    struct.new $RefCell_405
    local.set $letrec_cell_isEven
    ref.func $letrec_isOdd_407
    local.get $letrec_cell_isEven
    struct.new $ClosureType_407
    struct.new $RefCell_405
    local.set $letrec_cell_isOdd
    local.get $isEven
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_54
    local.get $lo_clo_54
    i32.const 4
    local.get $lo_clo_54
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
    if (result i32)
      local.get $isOdd
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_55
      local.get $lo_clo_55
      i32.const 3
      local.get $lo_clo_55
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
    else
      i32.const 0
    end
    if (result i32)
      i32.const 1
    else
      i32.const 0
    end
  )
  (func $letrec_ping_408 (param $self (ref $AnyFn)) (param $n i32) (result i32)
    (local $lo_clo_56 (ref $ClosureBase_59))
    (local $pong (ref $AnyFn))
    local.get $n
    i32.const 10
    i32.ge_s
    if (result i32)
      local.get $n
    else
      local.get $pong
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_56
      local.get $lo_clo_56
      local.get $n
      i32.const 1
      i32.add
      local.get $lo_clo_56
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
    end
  )
  (func $letrec_pong_409 (param $self (ref $AnyFn)) (param $n_1 i32) (result i32)
    (local $lo_clo_57 (ref $ClosureBase_59))
    (local $ping (ref $AnyFn))
    local.get $n_1
    i32.const 10
    i32.ge_s
    if (result i32)
      local.get $n_1
    else
      local.get $ping
      ref.cast (ref $ClosureBase_59)
      local.set $lo_clo_57
      local.get $lo_clo_57
      local.get $n_1
      i32.const 1
      i32.add
      local.get $lo_clo_57
      struct.get $ClosureBase_59 0
      call_ref $FuncType_29
    end
  )
  (func $testMutualLetRecPingPong (result i32) ;; exported as "testMutualLetRecPingPong"
    (local $letrec_cell_ping (ref $RefCell_405))
    (local $letrec_cell_pong (ref $RefCell_405))
    (local $lo_clo_58 (ref $ClosureBase_59))
    (local $ping (ref $AnyFn))
    ref.func $letrec_ping_408
    local.get $letrec_cell_pong
    struct.new $ClosureType_408
    struct.new $RefCell_405
    local.set $letrec_cell_ping
    ref.func $letrec_pong_409
    local.get $letrec_cell_ping
    struct.new $ClosureType_409
    struct.new $RefCell_405
    local.set $letrec_cell_pong
    local.get $ping
    ref.cast (ref $ClosureBase_59)
    local.set $lo_clo_58
    local.get $lo_clo_58
    i32.const 0
    local.get $lo_clo_58
    struct.get $ClosureBase_59 0
    call_ref $FuncType_29
  )
  (func $testExnCarrierBasic (result i32) ;; exported as "testExnCarrierBasic"
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 99
                struct.new $QuickTestWasmGc_Preamble_MyTypedException
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
    (local $e (ref $QuickTestWasmGc_Preamble_MyTypedException))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                i32.const 77
                struct.new $QuickTestWasmGc_Preamble_MyTypedException
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
        ref.test (ref $QuickTestWasmGc_Preamble_MyTypedException)
        if (result i32)
          local.get $matchValue
          ref.cast (ref $QuickTestWasmGc_Preamble_MyTypedException)
          local.set $e
          local.get $e
          struct.get $QuickTestWasmGc_Preamble_MyTypedException 0
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
        ref.test (ref $QuickTestWasmGc_Preamble_MyTypedException)
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
                struct.new $QuickTestWasmGc_Preamble_MyTypedException
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
        ref.test (ref $QuickTestWasmGc_Preamble_MyTypedException)
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
    (local $e (ref $QuickTestWasmGc_Preamble_MyTypedException))
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
                      struct.new $QuickTestWasmGc_Preamble_MyTypedException
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
            ref.test (ref $QuickTestWasmGc_Preamble_MyTypedException)
            if
              local.get $matchValue
              ref.cast (ref $QuickTestWasmGc_Preamble_MyTypedException)
              local.set $e
              local.get $acc
              local.get $e
              struct.get $QuickTestWasmGc_Preamble_MyTypedException 0
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
  ;; ── Elem declare (func refs) ────────────────────────
  (elem declare func $QuickTestWasmGc_Preamble_ClassCircle_QuickTestWasmGc_Preamble_IShape_Area_wrap $QuickTestWasmGc_Preamble_ClassRect_QuickTestWasmGc_Preamble_IShape_Area_wrap $QuickTestWasmGc_Preamble_EnglishGreeter_QuickTestWasmGc_Preamble_IGreeter_Greet_wrap $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_Area_wrap $QuickTestWasmGc_Preamble_SpanishGreeter_QuickTestWasmGc_Preamble_IGreeter_Greet_wrap $closure_179 $closure_182 $closure_183 $closure_184 $closure_185 $closure_188 $closure_20 $closure_269 $closure_272 $closure_275 $closure_276 $closure_277 $closure_316 $closure_317 $closure_318 $closure_319 $closure_320 $closure_321 $closure_322 $closure_323 $closure_324 $closure_325 $closure_326 $closure_327 $closure_328 $closure_329 $closure_33 $closure_330 $closure_331 $closure_332 $closure_333 $closure_342 $closure_343 $closure_344 $closure_345 $closure_346 $closure_347 $closure_348 $closure_349 $closure_350 $closure_351 $closure_352 $closure_353 $closure_354 $closure_355 $closure_356 $closure_357 $closure_358 $closure_359 $closure_360 $closure_361 $closure_362 $closure_363 $closure_364 $closure_365 $closure_366 $closure_367 $closure_369 $closure_37 $closure_370 $closure_371 $closure_384 $closure_385 $closure_386 $closure_387 $closure_389 $closure_390 $closure_393 $closure_394 $closure_396 $closure_397 $closure_398 $closure_399 $closure_400 $closure_401 $closure_402 $closure_403 $closure_404 $closure_59 $closure_61 $letrec_isEven_406 $letrec_isOdd_407 $letrec_ping_408 $letrec_pong_409 $check_48 $reverseCmp_395)
  ;; ── Exports ────────────────────────────────────────
  (export "runAllTests" (func $runAllTests))
  (export "main" (func $main))
  (export "add" (func $add))
  (export "sub" (func $sub))
  (export "mul" (func $mul))
  (export "fib" (func $fib))
  (export "fact" (func $fact))
  (export "clamp" (func $clamp))
  (export "myAbs" (func $myAbs))
  (export "isqrt" (func $isqrt))
  (export "distanceFromOrigin" (func $distanceFromOrigin))
  (export "pointSum" (func $pointSum))
  (export "runCounter" (func $runCounter))
  (export "rectWidth" (func $rectWidth))
  (export "testDistanceFromOrigin" (func $testDistanceFromOrigin))
  (export "testRectWidth" (func $testRectWidth))
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
  (export "swapPair" (func $swapPair))
  (export "testSwapPairFst" (func $testSwapPairFst))
  (export "testSwapPairSnd" (func $testSwapPairSnd))
  (export "minMax" (func $minMax))
  (export "testMinMaxFirst" (func $testMinMaxFirst))
  (export "testMinMaxSecond" (func $testMinMaxSecond))
  (export "tripleSum" (func $tripleSum))
  (export "testTripleSum" (func $testTripleSum))
  (export "optionOrDefault" (func $optionOrDefault))
  (export "optionDouble" (func $optionDouble))
  (export "optionIsSome" (func $optionIsSome))
  (export "optionIsNone" (func $optionIsNone))
  (export "optionNested" (func $optionNested))
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
  (export "testHOFSimple" (func $testHOFSimple))
  (export "makeAdder" (func $makeAdder))
  (export "testCapture" (func $testCapture))
  (export "applyTwice" (func $applyTwice))
  (export "testApplyTwice" (func $testApplyTwice))
  (export "makeMultiplier" (func $makeMultiplier))
  (export "testLetCapture" (func $testLetCapture))
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
  (export "testOptionMap" (func $testOptionMap))
  (export "testOptionBind" (func $testOptionBind))
  (export "testListHead" (func $testListHead))
  (export "testListEmpty" (func $testListEmpty))
  (export "testListMatch" (func $testListMatch))
  (export "testListFoldSum" (func $testListFoldSum))
  (export "testListMapSum" (func $testListMapSum))
  (export "testListFilterSum" (func $testListFilterSum))
  (export "testListRevHead" (func $testListRevHead))
  (export "testListAppendLen" (func $testListAppendLen))
  (export "testIntOfFloat" (func $testIntOfFloat))
  (export "testIntOfNegFloat" (func $testIntOfNegFloat))
  (export "testFloatOfInt" (func $testFloatOfInt))
  (export "testInt64OfInt" (func $testInt64OfInt))
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
  (export "testRefCell" (func $testRefCell))
  (export "testRefCellBool" (func $testRefCellBool))
  (export "treeSum" (func $treeSum))
  (export "testTreeSum" (func $testTreeSum))
  (export "testTreeSum2" (func $testTreeSum2))
  (export "isEvenTC" (func $isEvenTC))
  (export "isOddTC" (func $isOddTC))
  (export "testMutualTailCall" (func $testMutualTailCall))
  (export "testMutualTailCall2" (func $testMutualTailCall2))
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
  (export "testArrayScan" (func $testArrayScan))
  (export "testArrayScanLen" (func $testArrayScanLen))
  (export "testArrayAppend" (func $testArrayAppend))
  (export "testArrayAppendLen" (func $testArrayAppendLen))
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
  (export "testListFindIndex" (func $testListFindIndex))
  (export "testListTryFindIndex" (func $testListTryFindIndex))
  (export "testOptionValue" (func $testOptionValue))
  (export "testOptionMapValue" (func $testOptionMapValue))
  (export "testResultMatchOk" (func $testResultMatchOk))
  (export "testResultMatchError" (func $testResultMatchError))
  (export "testResultIsOk" (func $testResultIsOk))
  (export "testResultIsError" (func $testResultIsError))
  (export "testResultMap" (func $testResultMap))
  (export "testResultBind" (func $testResultBind))
  (export "testResultBindError" (func $testResultBindError))
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
  (export "testStringInterpolation" (func $testStringInterpolation))
  (export "testStringInterpolationConcat" (func $testStringInterpolationConcat))
  (export "testPadLeft" (func $testPadLeft))
  (export "testPadRight" (func $testPadRight))
  (export "testPadLeftNoop" (func $testPadLeftNoop))
  (export "testPadLeftChar" (func $testPadLeftChar))
  (export "testReplace" (func $testReplace))
  (export "testReplaceRemove" (func $testReplaceRemove))
  (export "testReplaceNoMatch" (func $testReplaceNoMatch))
  (export "testPrintfnLiteral" (func $testPrintfnLiteral))
  (export "testListItem" (func $testListItem))
  (export "testListTailHead" (func $testListTailHead))
  (export "testListLength" (func $testListLength))
  (export "testListReduce" (func $testListReduce))
  (export "testListReduceMax" (func $testListReduceMax))
  (export "testListLast" (func $testListLast))
  (export "testListLastSingle" (func $testListLastSingle))
  (export "testListSortDesc" (func $testListSortDesc))
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
  (export "testIsDigit" (func $testIsDigit))
  (export "testIsDigitFalse" (func $testIsDigitFalse))
  (export "testIsLetter" (func $testIsLetter))
  (export "testIsLetterFalse" (func $testIsLetterFalse))
  (export "testIsUpper" (func $testIsUpper))
  (export "testIsLower" (func $testIsLower))
  (export "testIsWhiteSpace" (func $testIsWhiteSpace))
  (export "testIsLetterOrDigit" (func $testIsLetterOrDigit))
  (export "testCharToLower" (func $testCharToLower))
  (export "testCharToUpper" (func $testCharToUpper))
  (export "testOptionDefaultValue" (func $testOptionDefaultValue))
  (export "testOptionDefaultValueNone" (func $testOptionDefaultValueNone))
  (export "testOptionDefaultWith" (func $testOptionDefaultWith))
  (export "testOptionDefaultWithSome" (func $testOptionDefaultWithSome))
  (export "testOptionFilter" (func $testOptionFilter))
  (export "testOptionFilterNone" (func $testOptionFilterNone))
  (export "testFloatMul" (func $testFloatMul))
  (export "testFloatCompare" (func $testFloatCompare))
  (export "testRecordEqTrue" (func $testRecordEqTrue))
  (export "testRecordEqFalse" (func $testRecordEqFalse))
  (export "testRecordNeq" (func $testRecordNeq))
  (export "testDuEnumEqTrue" (func $testDuEnumEqTrue))
  (export "testDuEnumEqFalse" (func $testDuEnumEqFalse))
  (export "testDuDataEqTrue" (func $testDuDataEqTrue))
  (export "testDuDataEqFalse" (func $testDuDataEqFalse))
  (export "testDuDataEqDiffCtor" (func $testDuDataEqDiffCtor))
  (export "testTupleEqTrue" (func $testTupleEqTrue))
  (export "testTupleEqFalse" (func $testTupleEqFalse))
  (export "testTupleNeq" (func $testTupleNeq))
  (export "identity" (func $identity))
  (export "testIdentityInt" (func $testIdentityInt))
  (export "testIdentityFloat" (func $testIdentityFloat))
  (export "const2" (func $const2))
  (export "testConst2IntFloat" (func $testConst2IntFloat))
  (export "testConst2IntInt" (func $testConst2IntInt))
  (export "testConst2FloatInt" (func $testConst2FloatInt))
  (export "intCmp" (func $intCmp))
  (export "testMapAddFind" (func $testMapAddFind))
  (export "testMapFindMissing" (func $testMapFindMissing))
  (export "testMapCount" (func $testMapCount))
  (export "testMapContainsKey" (func $testMapContainsKey))
  (export "testMapContainsKeyMissing" (func $testMapContainsKeyMissing))
  (export "testMapAddReplace" (func $testMapAddReplace))
  (export "testOptionModuleIsSome" (func $testOptionModuleIsSome))
  (export "testOptionModuleIsSomeNone" (func $testOptionModuleIsSomeNone))
  (export "testOptionModuleIsNone" (func $testOptionModuleIsNone))
  (export "testOptionModuleIsNoneSome" (func $testOptionModuleIsNoneSome))
  (export "testOptionModuleDefaultValueNone" (func $testOptionModuleDefaultValueNone))
  (export "testOptionModuleDefaultValueSome" (func $testOptionModuleDefaultValueSome))
  (export "testOptionModuleCountNone" (func $testOptionModuleCountNone))
  (export "testOptionModuleCountSome" (func $testOptionModuleCountSome))
  (export "testResultModuleIsOk" (func $testResultModuleIsOk))
  (export "testResultModuleIsOkFalse" (func $testResultModuleIsOkFalse))
  (export "testResultModuleIsError" (func $testResultModuleIsError))
  (export "testResultModuleIsErrorFalse" (func $testResultModuleIsErrorFalse))
  (export "testResultModuleDefaultValueError" (func $testResultModuleDefaultValueError))
  (export "testResultModuleDefaultValueOk" (func $testResultModuleDefaultValueOk))
  (export "testResultModuleDefaultErrorOk" (func $testResultModuleDefaultErrorOk))
  (export "testResultModuleDefaultErrorError" (func $testResultModuleDefaultErrorError))
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
  (export "testExternAdd" (func $testExternAdd))
  (export "testExternAddNeg" (func $testExternAddNeg))
  (export "testExternMul" (func $testExternMul))
  (export "testExternChain" (func $testExternChain))
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
  (export "testIntParse" (func $testIntParse))
  (export "testIntParseNeg" (func $testIntParseNeg))
  (export "testIntParseZero" (func $testIntParseZero))
  (export "testFloatParse" (func $testFloatParse))
  (export "testFloatParseNeg" (func $testFloatParseNeg))
  (export "testFloatParseInt" (func $testFloatParseInt))
  (export "testStrIsNullOrEmptyTrue" (func $testStrIsNullOrEmptyTrue))
  (export "testStrIsNullOrEmptyFalse" (func $testStrIsNullOrEmptyFalse))
  (export "testStrCompareEq" (func $testStrCompareEq))
  (export "testStrCompareLt" (func $testStrCompareLt))
  (export "testStrCompareGt" (func $testStrCompareGt))
  (export "fibonacci" (func $fibonacci))
  (export "testFib10" (func $testFib10))
  (export "testFib15" (func $testFib15))
  (export "isPrime" (func $isPrime))
  (export "testIsPrime7" (func $testIsPrime7))
  (export "testIsPrime4" (func $testIsPrime4))
  (export "testCountPrimesTo50" (func $testCountPrimesTo50))
  (export "testSumMultiples35" (func $testSumMultiples35))
  (export "testCollatz27" (func $testCollatz27))
  (export "testArrayToList" (func $testArrayToList))
  (export "testListOfArray" (func $testListOfArray))
  (export "testListSortBy" (func $testListSortBy))
  (export "testListFlatten" (func $testListFlatten))
  (export "testInterfaceDispatch" (func $testInterfaceDispatch))
  (export "testInterfacePolymorphism" (func $testInterfacePolymorphism))
  (export "testDuInterfaceCircle" (func $testDuInterfaceCircle))
  (export "testDuInterfaceRect" (func $testDuInterfaceRect))
  (export "testDuInterfacePoly" (func $testDuInterfacePoly))
  (export "testClassCircleArea" (func $testClassCircleArea))
  (export "testClassRectArea" (func $testClassRectArea))
  (export "testMixedShapes" (func $testMixedShapes))
  (export "testSortWith" (func $testSortWith))
  (export "testSortWithDesc" (func $testSortWithDesc))
  (export "testSortWithInts" (func $testSortWithInts))
  (export "testArraySortWith" (func $testArraySortWith))
  (export "testArraySortWithDesc" (func $testArraySortWithDesc))
  (export "testListZip" (func $testListZip))
  (export "testListZipLen" (func $testListZipLen))
  (export "testListMap2Sum" (func $testListMap2Sum))
  (export "testListMap2Head" (func $testListMap2Head))
  (export "testArrayZip" (func $testArrayZip))
  (export "testArrayZipLen" (func $testArrayZipLen))
  (export "testArrayMap2Sum" (func $testArrayMap2Sum))
  (export "testArrayMap2Head" (func $testArrayMap2Head))
  (export "testPown2_10" (func $testPown2_10))
  (export "testPownZero" (func $testPownZero))
  (export "testPownCube" (func $testPownCube))
  (export "testPownOne" (func $testPownOne))
  (export "testPowF64_2_10" (func $testPowF64_2_10))
  (export "testPowF64_zero" (func $testPowF64_zero))
  (export "testPowF64_cube" (func $testPowF64_cube))
  (export "testMathPow" (func $testMathPow))
  (export "testRefTestCircle" (func $testRefTestCircle))
  (export "testRefTestRect" (func $testRefTestRect))
  (export "testRefTestDot" (func $testRefTestDot))
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
  (export "testSbLength" (func $testSbLength))
  (export "testSbAppendTwo" (func $testSbAppendTwo))
  (export "testSbToStringLength" (func $testSbToStringLength))
  (export "testSbGrow" (func $testSbGrow))
  (export "testSbToStringContent" (func $testSbToStringContent))
  (export "testSbChained" (func $testSbChained))
  (export "roundTo6" (func $roundTo6))
  (export "testAtan2Origin" (func $testAtan2Origin))
  (export "testAtan2PosX" (func $testAtan2PosX))
  (export "testAtan2NegX" (func $testAtan2NegX))
  (export "testAtan2PosY" (func $testAtan2PosY))
  (export "testAtan2NegY" (func $testAtan2NegY))
  (export "testAtan2Q3" (func $testAtan2Q3))
  (export "testListPartitionCounts" (func $testListPartitionCounts))
  (export "testListPartitionEvens" (func $testListPartitionEvens))
  (export "testListPartitionOdds" (func $testListPartitionOdds))
  (export "testListPartitionEmpty" (func $testListPartitionEmpty))
  (export "testListPartitionAllTrue" (func $testListPartitionAllTrue))
  (export "testListPartitionOrder" (func $testListPartitionOrder))
  (export "testArrayChooseBasic" (func $testArrayChooseBasic))
  (export "testArrayChooseLength" (func $testArrayChooseLength))
  (export "testArrayChooseEmpty" (func $testArrayChooseEmpty))
  (export "testArrayChooseAllSome" (func $testArrayChooseAllSome))
  (export "testArrayCollectBasic" (func $testArrayCollectBasic))
  (export "testArrayCollectLength" (func $testArrayCollectLength))
  (export "testArrayCollectEmpty" (func $testArrayCollectEmpty))
  (export "testArrayCollectSingleton" (func $testArrayCollectSingleton))
  (export "testCompareIntLt" (func $testCompareIntLt))
  (export "testCompareIntEq" (func $testCompareIntEq))
  (export "testCompareIntGt" (func $testCompareIntGt))
  (export "testCompareStrLt" (func $testCompareStrLt))
  (export "testCompareStrEq" (func $testCompareStrEq))
  (export "testCompareStrGt" (func $testCompareStrGt))
  (export "testListSortIntAsc" (func $testListSortIntAsc))
  (export "testListSortStrAsc" (func $testListSortStrAsc))
  (export "testStdMapFind" (func $testStdMapFind))
  (export "testStdMapTryFind" (func $testStdMapTryFind))
  (export "testStdMapTryFindMissing" (func $testStdMapTryFindMissing))
  (export "testStdMapContainsKey" (func $testStdMapContainsKey))
  (export "testStdMapAdd" (func $testStdMapAdd))
  (export "testResizeArrayBasic" (func $testResizeArrayBasic))
  (export "testSeqMap" (func $testSeqMap))
  (export "testSeqFilter" (func $testSeqFilter))
  (export "testSeqFold" (func $testSeqFold))
  (export "testSeqExists" (func $testSeqExists))
  (export "testSeqToList" (func $testSeqToList))
  (export "testListUnzip" (func $testListUnzip))
  (export "testArrayUnzip" (func $testArrayUnzip))
  (export "testSeqSumBy" (func $testSeqSumBy))
  (export "testLetMutable" (func $testLetMutable))
  (export "testLetMutableLoop" (func $testLetMutableLoop))
  (export "testSeqInit" (func $testSeqInit))
  (export "testResizeArrayIndex" (func $testResizeArrayIndex))
  (export "testSeqPairwise" (func $testSeqPairwise))
  (export "testSeqCountBy" (func $testSeqCountBy))
  (export "testListGroupBy" (func $testListGroupBy))
  (export "evalExpr" (func $evalExpr))
  (export "testRecursiveDU" (func $testRecursiveDU))
  (export "$007CEven$007COdd$007C" (func $007CEven$007COdd$007C))
  (export "testActivePattern" (func $testActivePattern))
  (export "testStringConcat" (func $testStringConcat))
  (export "testStringInterp" (func $testStringInterp))
  (export "testSeqDistinct" (func $testSeqDistinct))
  (export "testListDistinctBy" (func $testListDistinctBy))
  (export "testTryCatchBasic" (func $testTryCatchBasic))
  (export "testTryCatchNoThrow" (func $testTryCatchNoThrow))
  (export "testTryCatchNested" (func $testTryCatchNested))
  (export "testTryCatchFallback" (func $testTryCatchFallback))
  (export "testMapIsEmpty" (func $testMapIsEmpty))
  (export "testMapRemove" (func $testMapRemove))
  (export "testMapToList" (func $testMapToList))
  (export "testMapLargeAddFind" (func $testMapLargeAddFind))
  (export "testMapFindRaises" (func $testMapFindRaises))
  (export "testMapFold" (func $testMapFold))
  (export "testMapIter" (func $testMapIter))
  (export "testMapFilter" (func $testMapFilter))
  (export "testMapExists" (func $testMapExists))
  (export "testMapForall" (func $testMapForall))
  (export "testMapMap" (func $testMapMap))
  (export "testSeqChoose" (func $testSeqChoose))
  (export "testSeqCollect" (func $testSeqCollect))
  (export "testSeqReduce" (func $testSeqReduce))
  (export "testSeqMapIndexed" (func $testSeqMapIndexed))
  (export "testSeqForall" (func $testSeqForall))
  (export "testSetOfListCount" (func $testSetOfListCount))
  (export "testSetContains" (func $testSetContains))
  (export "testSetAdd" (func $testSetAdd))
  (export "testSetRemove" (func $testSetRemove))
  (export "testSetIsEmpty" (func $testSetIsEmpty))
  (export "testSetFold" (func $testSetFold))
  (export "testSetToList" (func $testSetToList))
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
  (export "testSetOfArray" (func $testSetOfArray))
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
  (export "testExnNestedFailwith" (func $testExnNestedFailwith))
  (export "testExnUnit" (func $testExnUnit))
  (export "testExnNormalPath" (func $testExnNormalPath))
  (export "testExnNestedInnerCatch" (func $testExnNestedInnerCatch))
  (export "testExnNestedRethrow" (func $testExnNestedRethrow))
  (export "testClosureCapMap" (func $testClosureCapMap))
  (export "testClosureCapFilter" (func $testClosureCapFilter))
  (export "testClosureCapFold" (func $testClosureCapFold))
  (export "testClosureHigherOrder" (func $testClosureHigherOrder))
  (export "testClosureCapRef" (func $testClosureCapRef))
  (export "testClosureNestedCapture" (func $testClosureNestedCapture))
  (export "testClosureCapSetFold" (func $testClosureCapSetFold))
  (export "testClosureCapListExists" (func $testClosureCapListExists))
  (export "testClosureCapListForAll" (func $testClosureCapListForAll))
  (export "testMapCustomCmpReverse" (func $testMapCustomCmpReverse))
  (export "testMapModuleContainsKey" (func $testMapModuleContainsKey))
  (export "testMapModuleFindRoundTrip" (func $testMapModuleFindRoundTrip))
  (export "testSetModuleBasic" (func $testSetModuleBasic))
  (export "testSetModuleDedup" (func $testSetModuleDedup))
  (export "testSetModuleContains" (func $testSetModuleContains))
  (export "testMapModuleRemove" (func $testMapModuleRemove))
  (export "testMapModuleToList" (func $testMapModuleToList))
  (export "testSetModuleFold" (func $testSetModuleFold))
  (export "testMutualLetRec" (func $testMutualLetRec))
  (export "testMutualLetRecPingPong" (func $testMutualLetRecPingPong))
  (export "testExnCarrierBasic" (func $testExnCarrierBasic))
  (export "testExnTypedPayload" (func $testExnTypedPayload))
  (export "testExnTypeTestDiscriminate" (func $testExnTypeTestDiscriminate))
  (export "testExnTypeTestMatch" (func $testExnTypeTestMatch))
  (export "testExnCarrierInt" (func $testExnCarrierInt))
  ;; ── Globals ─────────────────────────────────────────
  (global $fsharp_exn_carrier (mut anyref)ref.null any
)
  (global $QuickTestWasmGc_Preamble_EnglishGreeter_QuickTestWasmGc_Preamble_IGreeter_vtable (ref $vtbl_QuickTestWasmGc_Preamble_IGreeter)ref.func $QuickTestWasmGc_Preamble_EnglishGreeter_QuickTestWasmGc_Preamble_IGreeter_Greet_wrap
struct.new $vtbl_QuickTestWasmGc_Preamble_IGreeter
)
  (global $QuickTestWasmGc_Preamble_SpanishGreeter_QuickTestWasmGc_Preamble_IGreeter_vtable (ref $vtbl_QuickTestWasmGc_Preamble_IGreeter)ref.func $QuickTestWasmGc_Preamble_SpanishGreeter_QuickTestWasmGc_Preamble_IGreeter_Greet_wrap
struct.new $vtbl_QuickTestWasmGc_Preamble_IGreeter
)
  (global $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_vtable (ref $vtbl_QuickTestWasmGc_Preamble_IShape)ref.func $QuickTestWasmGc_Preamble_IntShape_QuickTestWasmGc_Preamble_IShape_Area_wrap
struct.new $vtbl_QuickTestWasmGc_Preamble_IShape
)
  (global $QuickTestWasmGc_Preamble_ClassCircle_QuickTestWasmGc_Preamble_IShape_vtable (ref $vtbl_QuickTestWasmGc_Preamble_IShape)ref.func $QuickTestWasmGc_Preamble_ClassCircle_QuickTestWasmGc_Preamble_IShape_Area_wrap
struct.new $vtbl_QuickTestWasmGc_Preamble_IShape
)
  (global $QuickTestWasmGc_Preamble_ClassRect_QuickTestWasmGc_Preamble_IShape_vtable (ref $vtbl_QuickTestWasmGc_Preamble_IShape)ref.func $QuickTestWasmGc_Preamble_ClassRect_QuickTestWasmGc_Preamble_IShape_Area_wrap
struct.new $vtbl_QuickTestWasmGc_Preamble_IShape
)
)
