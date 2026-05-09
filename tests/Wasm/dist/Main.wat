(module
  ;; ── Types ───────────────────────────────────────────
  (type $AnyFn (sub (struct)))
  (type $WasmStr (array (mut i32)))
  (type $ListBase (sub (struct)))
  (type $StringBuilder (sub (struct (field (mut (ref $WasmStr))) (field (mut i32)) (field (mut i32)))))
  (type $Wasmecto_TestCode (sub (struct (field i32))))
  (type $Wasmecto_TestCode#0 (sub $Wasmecto_TestCode (struct (field i32) (field (ref $AnyFn)))))
  (type $Wasmecto_Test (sub (struct (field i32))))
  (type $Wasmecto_Test#0 (sub $Wasmecto_Test (struct (field i32) (field (ref $WasmStr)) (field (ref $Wasmecto_TestCode)) (field i32))))
  (type $ListCons_8 (sub $ListBase (struct (field (ref $Wasmecto_Test)) (field (ref null $ListBase)))))
  (type $Wasmecto_Test#1 (sub $Wasmecto_Test (struct (field i32) (field (ref $WasmStr)) (field (ref null $ListBase)) (field i32))))
  (type $Wasmecto_Test#2 (sub $Wasmecto_Test (struct (field i32) (field (ref $WasmStr)) (field (ref $Wasmecto_Test)) (field i32))))
  (type $Wasmecto_TestResult (sub (struct (field i32))))
  (type $Wasmecto_TestResult#0 (sub $Wasmecto_TestResult (struct (field i32))))
  (type $Wasmecto_TestResult#1 (sub $Wasmecto_TestResult (struct (field i32) (field (ref $WasmStr)))))
  (type $Wasmecto_TestResult#2 (sub $Wasmecto_TestResult (struct (field i32) (field (ref $WasmStr)))))
  (type $Wasmecto_TestResult#3 (sub $Wasmecto_TestResult (struct (field i32) (field (ref $WasmStr)))))
  (type $Wasmecto_TestSummary (sub (struct (field (ref $WasmStr)) (field (ref $Wasmecto_TestResult)))))
  (type $FuncType_17 (func (param (ref $AnyFn))))
  (type $ClosureBase_18 (sub $AnyFn (struct (field (ref $FuncType_17)))))
  (type $ClosureType_19 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_20 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $Wasmecto_Expect_FailException (sub (struct (field (ref $WasmStr)))))
  (type $ListCons_22 (sub $ListBase (struct (field i32) (field (ref null $ListBase)))))
  (type $Option_23 (sub (struct (field i32))))
  (type $Wasmecto_Runner_FlatTest (sub (struct (field (ref $WasmStr)) (field (ref $Wasmecto_TestCode)) (field i32))))
  (type $ListCons_25 (sub $ListBase (struct (field (ref $Wasmecto_Runner_FlatTest)) (field (ref null $ListBase)))))
  (type $FuncType_26 (func (param (ref $AnyFn)) (param (ref $Wasmecto_Test)) (param (ref null $ListBase)) (result (ref null $ListBase))))
  (type $ClosureBase_27 (sub $AnyFn (struct (field (ref $FuncType_26)))))
  (type $ClosureType_28 (sub $ClosureBase_27 (struct (field (ref $FuncType_26)) (field (ref $WasmStr)) (field i32) (field (ref $WasmStr)) (field (ref $Wasmecto_Test)))))
  (type $FuncType_29 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (param i32) (param (ref $Wasmecto_Test)) (param (ref null $ListBase)) (result (ref null $ListBase))))
  (type $ClosureBase_30 (sub $AnyFn (struct (field (ref $FuncType_29)))))
  (type $ClosureType_31 (sub $ClosureBase_30 (struct (field (ref $FuncType_29)))))
  (type $FuncType_32 (func (param (ref $AnyFn)) (param (ref $Wasmecto_Runner_FlatTest)) (result i32)))
  (type $ClosureBase_33 (sub $AnyFn (struct (field (ref $FuncType_32)))))
  (type $ClosureType_34 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $FuncType_35 (func (param (ref $AnyFn)) (param (ref $WasmStr))))
  (type $GcArray_36 (array (mut (ref $Wasmecto_Test))))
  (type $ResizeArray_37 (sub (struct (field (mut (ref null $GcArray_36))) (field (mut i32)))))
  (type $ClosureType_38 (sub $ClosureBase_27 (struct (field (ref $FuncType_26)) (field (ref $WasmStr)) (field i32) (field (ref $WasmStr)) (field (ref $Wasmecto_Test)))))
  (type $ClosureType_39 (sub $ClosureBase_30 (struct (field (ref $FuncType_29)))))
  (type $ClosureType_40 (sub $ClosureBase_33 (struct (field (ref $FuncType_32)))))
  (type $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point (sub (struct (field i32) (field i32))))
  (type $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape (sub (struct (field i32))))
  (type $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#0 (sub $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape (struct (field i32) (field i32))))
  (type $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#1 (sub $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape (struct (field i32) (field i32) (field i32))))
  (type $ClosureType_45 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_46 (func (param (ref $AnyFn)) (param i32) (result i32)))
  (type $ClosureBase_47 (sub $AnyFn (struct (field (ref $FuncType_46)))))
  (type $ClosureType_48 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_49 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_50 (func (param (ref $AnyFn)) (param i32) (result (ref $WasmStr))))
  (type $ClosureBase_51 (sub $AnyFn (struct (field (ref $FuncType_50)))))
  (type $ClosureType_52 (sub $ClosureBase_51 (struct (field (ref $FuncType_50)))))
  (type $ClosureType_53 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $Tuple_54 (sub (struct (field i32) (field i32))))
  (type $ClosureType_55 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_56 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_57 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_58 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_59 (func (param (ref $AnyFn)) (param (ref null $Option_23)) (param i32) (result i32)))
  (type $ClosureBase_60 (sub $AnyFn (struct (field (ref $FuncType_59)))))
  (type $ClosureType_61 (sub $ClosureBase_60 (struct (field (ref $FuncType_59)))))
  (type $ClosureType_62 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~i32> (struct (field i32) (field i32))))
  (type $ClosureType_66 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $FuncType_67 (func (param (ref $AnyFn)) (param (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>)) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (sub (struct (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field i32))))
  (type $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1 (sub $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> (struct (field i32) (field (ref $WasmStr)))))
  (type $FuncType_71 (func (param (ref $AnyFn)) (param (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>)) (result i32)))
  (type $ClosureType_72 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_73 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_74 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_75 (func (param (ref $AnyFn)) (param i32) (param i32) (result i32)))
  (type $ClosureBase_76 (sub $AnyFn (struct (field (ref $FuncType_75)))))
  (type $ClosureType_77 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_78 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_79 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_80 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_81 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_82 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_83 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_84 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_85 (func (param (ref $AnyFn)) (param i32) (result (ref null $ListBase))))
  (type $ClosureBase_86 (sub $AnyFn (struct (field (ref $FuncType_85)))))
  (type $ClosureType_87 (sub $ClosureBase_86 (struct (field (ref $FuncType_85)))))
  (type $FuncType_88 (func (param (ref $AnyFn)) (param i32) (result (ref null $Option_23))))
  (type $ClosureBase_89 (sub $AnyFn (struct (field (ref $FuncType_88)))))
  (type $ClosureType_90 (sub $ClosureBase_89 (struct (field (ref $FuncType_88)))))
  (type $ClosureType_91 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_92 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_93 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_94 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_95 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $GcArray_96 (array (mut i32)))
  (type $ClosureType_97 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_98 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_99 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_100 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_101 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_102 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_103 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_104 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_105 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_106 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $WasmTests_TestsClosures_ClosureTests_Transformer (sub (struct (field (ref $AnyFn)) (field (ref $WasmStr)))))
  (type $WasmTests_TestsClosures_ClosureTests_Config (sub (struct (field i32) (field i32))))
  (type $WasmTests_TestsClosures_ClosureTests_Op (sub (struct (field i32))))
  (type $WasmTests_TestsClosures_ClosureTests_Op#0 (sub $WasmTests_TestsClosures_ClosureTests_Op (struct (field i32) (field i32))))
  (type $WasmTests_TestsClosures_ClosureTests_Op#1 (sub $WasmTests_TestsClosures_ClosureTests_Op (struct (field i32) (field i32))))
  (type $WasmTests_TestsClosures_ClosureTests_Op#2 (sub $WasmTests_TestsClosures_ClosureTests_Op (struct (field i32) (field (ref $AnyFn)))))
  (type $WasmTests_TestsClosures_ClosureTests_Transform (sub (struct (field i32))))
  (type $WasmTests_TestsClosures_ClosureTests_Transform#0 (sub $WasmTests_TestsClosures_ClosureTests_Transform (struct (field i32) (field (ref $AnyFn)))))
  (type $ClosureType_115 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_116 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_117 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_118 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_119 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_120 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)) (field i32))))
  (type $ClosureType_121 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_122 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_123 (func (param (ref $AnyFn)) (param i32)))
  (type $ClosureBase_124 (sub $AnyFn (struct (field (ref $FuncType_123)))))
  (type $ClosureType_125 (sub $ClosureBase_124 (struct (field (ref $FuncType_123)) (field i32))))
  (type $ClosureType_126 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_127 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)) (field i32))))
  (type $ClosureType_128 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureBase_129 (sub $AnyFn (struct (field (ref $FuncType_35)))))
  (type $ClosureType_130 (sub $ClosureBase_129 (struct (field (ref $FuncType_35)) (field (ref $WasmStr)))))
  (type $ClosureType_131 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_132 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_133 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $AnyFn)))))
  (type $ClosureType_134 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $AnyFn)))))
  (type $ClosureType_135 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_136 (func (param (ref $AnyFn)) (param f64) (param f64) (result f64)))
  (type $ClosureBase_137 (sub $AnyFn (struct (field (ref $FuncType_136)))))
  (type $ClosureType_138 (sub $ClosureBase_137 (struct (field (ref $FuncType_136)))))
  (type $FuncType_139 (func (param (ref $AnyFn)) (param f64) (result f64)))
  (type $ClosureBase_140 (sub $AnyFn (struct (field (ref $FuncType_139)))))
  (type $ClosureType_141 (sub $ClosureBase_140 (struct (field (ref $FuncType_139)) (field (ref $AnyFn)))))
  (type $ClosureType_142 (sub $ClosureBase_140 (struct (field (ref $FuncType_139)) (field (ref $AnyFn)))))
  (type $ClosureType_143 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_144 (func (param (ref $AnyFn)) (result i32)))
  (type $ClosureBase_145 (sub $AnyFn (struct (field (ref $FuncType_144)))))
  (type $ClosureType_146 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $FuncType_147 (func (param (ref $AnyFn)) (result (ref $AnyFn))))
  (type $ClosureBase_148 (sub $AnyFn (struct (field (ref $FuncType_147)))))
  (type $ClosureType_149 (sub $ClosureBase_148 (struct (field (ref $FuncType_147)))))
  (type $ClosureType_150 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_151 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field i32))))
  (type $ClosureType_152 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_153 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_154 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $AnyFn)))))
  (type $ClosureType_155 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_156 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_157 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_158 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_159 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_160 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_161 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_162 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_163 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_164 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_165 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_166 (sub $ClosureBase_124 (struct (field (ref $FuncType_123)) (field (ref null $ListBase)))))
  (type $ClosureType_167 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_168 (func (param (ref $AnyFn)) (param (ref $AnyFn)) (result i32)))
  (type $ClosureBase_169 (sub $AnyFn (struct (field (ref $FuncType_168)))))
  (type $ClosureType_170 (sub $ClosureBase_169 (struct (field (ref $FuncType_168)))))
  (type $ListCons_171 (sub $ListBase (struct (field (ref $AnyFn)) (field (ref null $ListBase)))))
  (type $ClosureType_172 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $FuncType_173 (func (param (ref $AnyFn)) (param i32) (result (ref $AnyFn))))
  (type $ClosureBase_174 (sub $AnyFn (struct (field (ref $FuncType_173)))))
  (type $ClosureType_175 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_176 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_177 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_178 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_179 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_180 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_181 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_182 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_183 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_184 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_185 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_186 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_187 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_188 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_189 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_190 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_191 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_192 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_193 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_194 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_195 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $RefCell_196 (sub (struct (field (mut (ref null $AnyFn))))))
  (type $ClosureType_197 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $RefCell_196)))))
  (type $ClosureType_198 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $RefCell_196)))))
  (type $Tuple_199 (sub (struct (field (ref $AnyFn)) (field (ref $AnyFn)))))
  (type $ClosureType_200 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_201 (sub $ClosureBase_124 (struct (field (ref $FuncType_123)) (field i32))))
  (type $ClosureType_202 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_203 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_204 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_205 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_206 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_207 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field i32))))
  (type $ClosureType_208 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_209 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field i32))))
  (type $ClosureType_210 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_211 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field i32))))
  (type $ClosureType_212 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_213 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_214 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_215 (sub $ClosureBase_169 (struct (field (ref $FuncType_168)))))
  (type $ClosureType_216 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_217 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_218 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_219 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_220 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_221 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_222 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)) (field (ref $AnyFn)))))
  (type $ClosureType_223 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_224 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field i32))))
  (type $ClosureType_225 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field i32) (field i32) (field i32) (field i32))))
  (type $ClosureType_226 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_227 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_228 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_229 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_230 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_231 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_232 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_233 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_234 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_235 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field i32))))
  (type $ClosureType_236 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)) (field i32))))
  (type $ClosureType_237 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_238 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_239 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_240 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_241 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_242 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_243 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_244 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_245 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $WasmTests_TestsClosures_ClosureTests_Config)))))
  (type $ClosureType_246 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_247 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_248 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_249 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_250 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_251 (func (param (ref $AnyFn)) (param (ref $WasmTests_TestsClosures_ClosureTests_Op)) (result i32)))
  (type $ClosureBase_252 (sub $AnyFn (struct (field (ref $FuncType_251)))))
  (type $ClosureType_253 (sub $ClosureBase_252 (struct (field (ref $FuncType_251)))))
  (type $ListCons_254 (sub $ListBase (struct (field (ref $WasmTests_TestsClosures_ClosureTests_Op)) (field (ref null $ListBase)))))
  (type $ClosureType_255 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_256 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_257 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_258 (func (param (ref $AnyFn)) (param i32) (param (ref $WasmTests_TestsClosures_ClosureTests_Transform)) (result i32)))
  (type $ClosureBase_259 (sub $AnyFn (struct (field (ref $FuncType_258)))))
  (type $ClosureType_260 (sub $ClosureBase_259 (struct (field (ref $FuncType_258)))))
  (type $ListCons_261 (sub $ListBase (struct (field (ref $WasmTests_TestsClosures_ClosureTests_Transform)) (field (ref null $ListBase)))))
  (type $ClosureType_262 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_263 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_264 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_265 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_266 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_267 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_268 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_269 (func (param (ref $AnyFn)) (result (ref null $Option_23))))
  (type $ClosureBase_270 (sub $AnyFn (struct (field (ref $FuncType_269)))))
  (type $ClosureType_271 (sub $ClosureBase_270 (struct (field (ref $FuncType_269)) (field i32))))
  (type $ClosureType_272 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_273 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32) (field i32))))
  (type $ClosureType_274 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $AnyFn)))))
  (type $ClosureType_275 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)) (field (ref $AnyFn)))))
  (type $ClosureType_276 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_277 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_278 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_279 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_280 (sub $ClosureBase_169 (struct (field (ref $FuncType_168)))))
  (type $ClosureType_281 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_282 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_283 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_284 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_285 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_286 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_287 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field i32))))
  (type $ClosureType_288 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_289 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_290 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_291 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_292 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_293 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_294 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_295 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_296 (sub $ClosureBase_169 (struct (field (ref $FuncType_168)))))
  (type $ClosureType_297 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_298 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field (ref null $ListBase)))))
  (type $ClosureType_299 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_300 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_301 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field (ref null $ListBase)))))
  (type $ClosureType_302 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_303 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_304 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field (ref null $ListBase)))))
  (type $ClosureType_305 (sub $ClosureBase_174 (struct (field (ref $FuncType_173)))))
  (type $ClosureType_306 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_307 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)) (field (ref null $ListBase)))))
  (type $ClosureType_308 (sub $ClosureBase_145 (struct (field (ref $FuncType_144)))))
  (type $ClosureType_309 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Customer (sub (struct (field (ref $WasmStr)) (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Discount (sub (struct (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#0 (sub $WasmTests_Integration_CompilerPipelineSmokeTests_Discount (struct (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#1 (sub $WasmTests_Integration_CompilerPipelineSmokeTests_Discount (struct (field i32) (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#2 (sub $WasmTests_Integration_CompilerPipelineSmokeTests_Discount (struct (field i32) (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Op (sub (struct (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Op#0 (sub $WasmTests_Integration_CompilerPipelineSmokeTests_Op (struct (field i32) (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Op#1 (sub $WasmTests_Integration_CompilerPipelineSmokeTests_Op (struct (field i32) (field i32))))
  (type $WasmTests_Integration_CompilerPipelineSmokeTests_Op#2 (sub $WasmTests_Integration_CompilerPipelineSmokeTests_Op (struct (field i32) (field (ref $AnyFn)))))
  (type $ClosureType_319 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_320 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_321 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_322 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_323 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureType_324 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_325 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_326 (sub $ClosureBase_76 (struct (field (ref $FuncType_75)))))
  (type $ClosureType_327 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $FuncType_328 (func (param (ref $AnyFn)) (param (ref $WasmStr)) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))))
  (type $ClosureBase_329 (sub $AnyFn (struct (field (ref $FuncType_328)))))
  (type $ClosureType_330 (sub $ClosureBase_329 (struct (field (ref $FuncType_328)))))
  (type $FuncType_331 (func (param (ref $AnyFn)) (param (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>)) (result (ref null $Option_23))))
  (type $ClosureBase_332 (sub $AnyFn (struct (field (ref $FuncType_331)))))
  (type $ClosureType_333 (sub $ClosureBase_332 (struct (field (ref $FuncType_331)))))
  (type $ListCons_334 (sub $ListBase (struct (field (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>)) (field (ref null $ListBase)))))
  (type $ClosureType_335 (sub $ClosureBase_332 (struct (field (ref $FuncType_331)))))
  (type $ClosureType_336 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $GcArray_337 (array (mut (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Op))))
  (type $ListCons_338 (sub $ListBase (struct (field (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Op)) (field (ref null $ListBase)))))
  (type $ClosureType_339 (sub $ClosureBase_47 (struct (field (ref $FuncType_46)))))
  (type $ClosureType_340 (sub $ClosureBase_18 (struct (field (ref $FuncType_17)))))
  (type $ClosureBase_341 (sub $AnyFn (struct (field (ref $FuncType_67)))))
  (type $ClosureBase_342 (sub $AnyFn (struct (field (ref $FuncType_71)))))
  ;; ── Imports ────────────────────────────────────────
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
    (local $w255 i32)
    (local $w256 i32)
    (local $w257 i32)
    (local $w258 i32)
    local.get $strIdx_ha
    array.len
    local.set $w255
    local.get $strIdx_ne
    array.len
    local.set $w256
    block $strIdx_outer_1 (result i32)
      local.get $w256
      i32.const 0
      i32.eq
      if
        i32.const 0
        br $strIdx_outer_1
      end
      i32.const 0
      local.set $w257
      block $while_lp_104_exit
        loop $while_lp_104
          local.get $w257
          local.get $w255
          local.get $w256
          i32.sub
          i32.le_s
          if
            block $strIdx_match_2
              i32.const 0
              local.set $w258
              block $while_lp_103_exit
                loop $while_lp_103
                  local.get $w258
                  local.get $w256
                  i32.lt_s
                  if
                    local.get $strIdx_ha
                    local.get $w257
                    local.get $w258
                    i32.add
                    array.get $WasmStr
                    local.get $strIdx_ne
                    local.get $w258
                    array.get $WasmStr
                    i32.ne
                    if
                      br $strIdx_match_2
                    end
                    local.get $w258
                    i32.const 1
                    i32.add
                    local.set $w258
                    br $while_lp_103
                  else
                    br $while_lp_103_exit
                  end
                end
              end
              local.get $w257
              br $strIdx_outer_1
            end
            local.get $w257
            i32.const 1
            i32.add
            local.set $w257
            br $while_lp_104
          else
            br $while_lp_104_exit
          end
        end
      end
      i32.const -1
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
  (func $Kind (result i32) ;; exported as "Kind"
    i32.const 0
  )
  (func $Msg (result (ref $WasmStr)) ;; exported as "Msg"
    array.new_fixed $WasmStr 0
  )
  (func $reset ;; exported as "reset"
    i32.const 0
    local.set $Kind
    array.new_fixed $WasmStr 0
    local.set $Msg
  )
  (func $testCase (param $name (ref $WasmStr)) (param $body (ref $AnyFn)) (result (ref $Wasmecto_Test)) ;; exported as "testCase"
    i32.const 0
    local.get $name
    i32.const 0
    local.get $body
    struct.new $Wasmecto_TestCode#0
    i32.const 0
    struct.new $Wasmecto_Test#0
  )
  (func $test (param $name (ref $WasmStr)) (param $body (ref $AnyFn)) (result (ref $Wasmecto_Test)) ;; exported as "test"
    i32.const 0
    local.get $name
    i32.const 0
    local.get $body
    struct.new $Wasmecto_TestCode#0
    i32.const 0
    struct.new $Wasmecto_Test#0
  )
  (func $testList (param $name (ref $WasmStr)) (param $tests (ref null $ListBase)) (result (ref $Wasmecto_Test)) ;; exported as "testList"
    i32.const 1
    local.get $name
    local.get $tests
    i32.const 0
    struct.new $ListCons_8
  )
  (func $closure_17 (param $self (ref $AnyFn))
  )
  (func $ptestCase (param $name (ref $WasmStr)) (param $_body (ref $AnyFn)) (result (ref $Wasmecto_Test)) ;; exported as "ptestCase"
    i32.const 0
    local.get $name
    i32.const 0
    ref.func $closure_17
    struct.new $ClosureType_19
    struct.new $Wasmecto_TestCode#0
    i32.const 1
    struct.new $Wasmecto_Test#0
  )
  (func $closure_20 (param $self (ref $AnyFn))
  )
  (func $pending (param $name (ref $WasmStr)) (result (ref $Wasmecto_Test)) ;; exported as "pending"
    i32.const 0
    local.get $name
    i32.const 0
    ref.func $closure_20
    struct.new $ClosureType_20
    struct.new $Wasmecto_TestCode#0
    i32.const 1
    struct.new $Wasmecto_Test#0
  )
  (func $ptestList (param $name (ref $WasmStr)) (param $tests (ref null $ListBase)) (result (ref $Wasmecto_Test)) ;; exported as "ptestList"
    i32.const 1
    local.get $name
    local.get $tests
    i32.const 1
    struct.new $ListCons_8
  )
  (func $ftestCase (param $name (ref $WasmStr)) (param $body (ref $AnyFn)) (result (ref $Wasmecto_Test)) ;; exported as "ftestCase"
    i32.const 0
    local.get $name
    i32.const 0
    local.get $body
    struct.new $Wasmecto_TestCode#0
    i32.const 2
    struct.new $Wasmecto_Test#0
  )
  (func $ftestList (param $name (ref $WasmStr)) (param $tests (ref null $ListBase)) (result (ref $Wasmecto_Test)) ;; exported as "ftestList"
    i32.const 1
    local.get $name
    local.get $tests
    i32.const 2
    struct.new $ListCons_8
  )
  (func $equal (param $actual i32) (param $expected i32) (param $msg (ref $WasmStr)) ;; exported as "equal"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $expected
    i32.eq
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 58
      i32.const 32
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $expected
      call $intToStr
      call $strConcat
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 65
      i32.const 99
      i32.const 116
      i32.const 117
      i32.const 97
      i32.const 108
      i32.const 58
      i32.const 32
      i32.const 32
      i32.const 32
      array.new_fixed $WasmStr 13
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      array.new_fixed $WasmStr 0
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $notEqual (param $actual i32) (param $expected i32) (param $msg (ref $WasmStr)) ;; exported as "notEqual"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $expected
    i32.eq
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 68
      i32.const 105
      i32.const 100
      i32.const 32
      i32.const 110
      i32.const 111
      i32.const 116
      i32.const 32
      i32.const 101
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 58
      i32.const 32
      array.new_fixed $WasmStr 18
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      array.new_fixed $WasmStr 0
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isTrue (param $actual i32) (param $msg (ref $WasmStr)) ;; exported as "isTrue"
    local.get $actual
    i32.eqz
    if
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isFalse (param $actual i32) (param $msg (ref $WasmStr)) ;; exported as "isFalse"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 102
      i32.const 97
      i32.const 108
      i32.const 115
      i32.const 101
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 32
      i32.const 116
      i32.const 114
      i32.const 117
      i32.const 101
      i32.const 46
      array.new_fixed $WasmStr 30
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isNull (param $actual i32) (param $msg (ref $WasmStr)) ;; exported as "isNull"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    ref.null none
    i32.eq
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 110
      i32.const 117
      i32.const 108
      i32.const 108
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 58
      i32.const 32
      array.new_fixed $WasmStr 25
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      array.new_fixed $WasmStr 0
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isNotNull (param $actual i32) (param $msg (ref $WasmStr)) ;; exported as "isNotNull"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    ref.null none
    i32.eq
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 110
      i32.const 111
      i32.const 110
      i32.const 45
      i32.const 110
      i32.const 117
      i32.const 108
      i32.const 108
      i32.const 46
      array.new_fixed $WasmStr 20
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $throws (param $f (ref $AnyFn)) (param $msg (ref $WasmStr)) ;; exported as "throws"
    (local $lo_clo_1 (ref $ClosureBase_18))
    (local $msg_1 (ref $WasmStr))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                local.get $f
                ref.cast (ref $ClosureBase_18)
                local.set $lo_clo_1
                local.get $lo_clo_1
                local.get $lo_clo_1
                struct.get $ClosureBase_18 0
                call_ref $FuncType_17
                i32.const 0
        )
        br 1
      )
        i32.const 1
    )
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 102
      i32.const 32
      i32.const 116
      i32.const 111
      i32.const 32
      i32.const 116
      i32.const 104
      i32.const 114
      i32.const 111
      i32.const 119
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 105
      i32.const 116
      i32.const 32
      i32.const 100
      i32.const 105
      i32.const 100
      i32.const 32
      i32.const 110
      i32.const 111
      i32.const 116
      i32.const 46
      array.new_fixed $WasmStr 37
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $throwsT (param $f (ref $AnyFn)) (param $msg (ref $WasmStr)) ;; exported as "throwsT"
    (local $lo_clo_2 (ref $ClosureBase_18))
    (local $msg_1 (ref $WasmStr))
    (block (result i32)
      (block
        (try_table (result i32) (catch_all 0)
                local.get $f
                ref.cast (ref $ClosureBase_18)
                local.set $lo_clo_2
                local.get $lo_clo_2
                local.get $lo_clo_2
                struct.get $ClosureBase_18 0
                call_ref $FuncType_17
                i32.const 0
        )
        br 1
      )
        i32.const 1
    )
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 102
      i32.const 32
      i32.const 116
      i32.const 111
      i32.const 32
      i32.const 116
      i32.const 104
      i32.const 114
      i32.const 111
      i32.const 119
      i32.const 32
      array.new_fixed $WasmStr 22
      call $strConcat
      i32.const 69
      array.new_fixed $WasmStr 1
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $stringContains (param $actual (ref $WasmStr)) (param $substring (ref $WasmStr)) (param $msg (ref $WasmStr)) ;; exported as "stringContains"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $substring
    call $strIndexOf
    i32.const 0
    i32.ge_s
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 39
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $actual
      call $strConcat
      i32.const 39
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 116
      i32.const 111
      i32.const 32
      i32.const 99
      i32.const 111
      i32.const 110
      i32.const 116
      i32.const 97
      i32.const 105
      i32.const 110
      i32.const 32
      i32.const 39
      array.new_fixed $WasmStr 16
      call $strConcat
      local.get $substring
      call $strConcat
      i32.const 39
      i32.const 46
      array.new_fixed $WasmStr 2
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $stringStarts (param $actual (ref $WasmStr)) (param $prefix (ref $WasmStr)) (param $msg (ref $WasmStr)) ;; exported as "stringStarts"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $prefix
    call $strIndexOf
    i32.const 0
    i32.eq
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 39
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $actual
      call $strConcat
      i32.const 39
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 116
      i32.const 111
      i32.const 32
      i32.const 115
      i32.const 116
      i32.const 97
      i32.const 114
      i32.const 116
      i32.const 32
      i32.const 119
      i32.const 105
      i32.const 116
      i32.const 104
      i32.const 32
      i32.const 39
      array.new_fixed $WasmStr 19
      call $strConcat
      local.get $prefix
      call $strConcat
      i32.const 39
      i32.const 46
      array.new_fixed $WasmStr 2
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $stringEnds (param $actual (ref $WasmStr)) (param $suffix (ref $WasmStr)) (param $msg (ref $WasmStr)) ;; exported as "stringEnds"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    array.len
    local.get $suffix
    array.len
    i32.sub
    i32.const 0
    i32.ge_s
    local.get $actual
    local.get $suffix
    call $strIndexOf
    local.get $actual
    array.len
    local.get $suffix
    array.len
    i32.sub
    i32.eq
    i32.and
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 39
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $actual
      call $strConcat
      i32.const 39
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 116
      i32.const 111
      i32.const 32
      i32.const 101
      i32.const 110
      i32.const 100
      i32.const 32
      i32.const 119
      i32.const 105
      i32.const 116
      i32.const 104
      i32.const 32
      i32.const 39
      array.new_fixed $WasmStr 17
      call $strConcat
      local.get $suffix
      call $strConcat
      i32.const 39
      i32.const 46
      array.new_fixed $WasmStr 2
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $stringHasLength (param $actual (ref $WasmStr)) (param $expected i32) (param $msg (ref $WasmStr)) ;; exported as "stringHasLength"
    (local $msg_1 (ref $WasmStr))
    (local $arg_2 i32)
    local.get $actual
    array.len
    local.get $expected
    i32.ne
    if
      local.get $actual
      array.len
      local.set $arg_2
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 108
      i32.const 101
      i32.const 110
      i32.const 103
      i32.const 116
      i32.const 104
      i32.const 32
      array.new_fixed $WasmStr 18
      call $strConcat
      local.get $expected
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 32
      array.new_fixed $WasmStr 9
      call $strConcat
      local.get $arg_2
      call $intToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $equals_2 (param $eq_a (ref $ListBase)) (param $eq_b (ref $ListBase)) (result i32)
    i32.const 1
  )
  (func $sequenceEqual (param $actual i32) (param $expected i32) (param $msg (ref $WasmStr)) ;; exported as "sequenceEqual"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $expected
    call $equals_2
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 58
      i32.const 32
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $expected
      call $intToStr
      call $strConcat
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 65
      i32.const 99
      i32.const 116
      i32.const 117
      i32.const 97
      i32.const 108
      i32.const 58
      i32.const 32
      i32.const 32
      i32.const 32
      array.new_fixed $WasmStr 13
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      array.new_fixed $WasmStr 0
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isEmpty (param $actual i32) (param $msg (ref $WasmStr)) ;; exported as "isEmpty"
    (local $msg_1 (ref $WasmStr))
    (local $arg_1 i32)
    (local $w1 i32)
    (local $w2 i32)
    local.get $actual
    i32.const 0
    i32.eq
    i32.eqz
    if
      local.get $actual
      local.set $w1
      i32.const 0
      local.set $w2
      block $while_lp_1_exit
        loop $while_lp_1
          local.get $w1
          ref.is_null
          i32.eqz
          if
            local.get $w2
            i32.const 1
            i32.add
            local.set $w2
            local.get $w1
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 1
            local.set $w1
            br $while_lp_1
          else
            br $while_lp_1_exit
          end
        end
      end
      local.get $w2
      local.set $arg_1
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 101
      i32.const 109
      i32.const 112
      i32.const 116
      i32.const 121
      i32.const 32
      i32.const 115
      i32.const 101
      i32.const 113
      i32.const 117
      i32.const 101
      i32.const 110
      i32.const 99
      i32.const 101
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 32
      array.new_fixed $WasmStr 34
      call $strConcat
      local.get $arg_1
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 101
      i32.const 108
      i32.const 101
      i32.const 109
      i32.const 101
      i32.const 110
      i32.const 116
      i32.const 115
      i32.const 46
      array.new_fixed $WasmStr 10
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isNonEmpty (param $actual i32) (param $msg (ref $WasmStr)) ;; exported as "isNonEmpty"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    i32.const 0
    i32.eq
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 110
      i32.const 111
      i32.const 110
      i32.const 45
      i32.const 101
      i32.const 109
      i32.const 112
      i32.const 116
      i32.const 121
      i32.const 32
      i32.const 115
      i32.const 101
      i32.const 113
      i32.const 117
      i32.const 101
      i32.const 110
      i32.const 99
      i32.const 101
      i32.const 46
      array.new_fixed $WasmStr 30
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $hasLength (param $actual i32) (param $expected i32) (param $msg (ref $WasmStr)) ;; exported as "hasLength"
    (local $len i32)
    (local $w3 i32)
    (local $w4 i32)
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.set $w3
    i32.const 0
    local.set $w4
    block $while_lp_2_exit
      loop $while_lp_2
        local.get $w3
        ref.is_null
        i32.eqz
        if
          local.get $w4
          i32.const 1
          i32.add
          local.set $w4
          local.get $w3
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w3
          br $while_lp_2
        else
          br $while_lp_2_exit
        end
      end
    end
    local.get $w4
    local.set $len
    local.get $len
    local.get $expected
    i32.ne
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 108
      i32.const 101
      i32.const 110
      i32.const 103
      i32.const 116
      i32.const 104
      i32.const 32
      array.new_fixed $WasmStr 18
      call $strConcat
      local.get $expected
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 32
      array.new_fixed $WasmStr 9
      call $strConcat
      local.get $len
      call $intToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $approxEqual (param $actual f64) (param $expected f64) (param $epsilon f64) (param $msg (ref $WasmStr)) ;; exported as "approxEqual"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $expected
    f64.sub
    f64.abs
    local.get $epsilon
    f64.gt
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 10
      i32.const 32
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 126
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $expected
      call $floatToStr
      call $strConcat
      i32.const 32
      i32.const 40
      i32.const 177
      array.new_fixed $WasmStr 3
      call $strConcat
      local.get $epsilon
      call $floatToStr
      call $strConcat
      i32.const 41
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 32
      array.new_fixed $WasmStr 10
      call $strConcat
      local.get $actual
      call $floatToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isLessThan (param $actual i32) (param $limit i32) (param $msg (ref $WasmStr)) ;; exported as "isLessThan"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $limit
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $actual
      local.get $limit
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
    i32.const 0
    i32.lt_s
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      array.new_fixed $WasmStr 11
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 60
      i32.const 32
      array.new_fixed $WasmStr 3
      call $strConcat
      local.get $limit
      call $intToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isGreaterThan (param $actual i32) (param $limit i32) (param $msg (ref $WasmStr)) ;; exported as "isGreaterThan"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $limit
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $actual
      local.get $limit
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
    i32.const 0
    i32.gt_s
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      array.new_fixed $WasmStr 11
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 62
      i32.const 32
      array.new_fixed $WasmStr 3
      call $strConcat
      local.get $limit
      call $intToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isLessThanOrEqual (param $actual i32) (param $limit i32) (param $msg (ref $WasmStr)) ;; exported as "isLessThanOrEqual"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $limit
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $actual
      local.get $limit
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
    i32.const 0
    i32.le_s
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      array.new_fixed $WasmStr 11
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 8804
      i32.const 32
      array.new_fixed $WasmStr 3
      call $strConcat
      local.get $limit
      call $intToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $isGreaterThanOrEqual (param $actual i32) (param $limit i32) (param $msg (ref $WasmStr)) ;; exported as "isGreaterThanOrEqual"
    (local $msg_1 (ref $WasmStr))
    local.get $actual
    local.get $limit
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $actual
      local.get $limit
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
    i32.const 0
    i32.ge_s
    i32.eqz
    if
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      array.new_fixed $WasmStr 11
      call $strConcat
      local.get $actual
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 8805
      i32.const 32
      array.new_fixed $WasmStr 3
      call $strConcat
      local.get $limit
      call $intToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $wantSome (param $opt (ref null $Option_23)) (param $msg (ref $WasmStr)) (result i32) ;; exported as "wantSome"
    (local $msg_1 (ref $WasmStr))
    local.get $opt
    ref.is_null
    if (result i32)
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 83
      i32.const 111
      i32.const 109
      i32.const 101
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 32
      i32.const 78
      i32.const 111
      i32.const 110
      i32.const 101
      i32.const 46
      array.new_fixed $WasmStr 29
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
      i32.const 0
    else
      local.get $opt
      ref.cast (ref $Option_23)
      struct.get $Option_23 0
    end
  )
  (func $wantOk (param $r i32) (param $msg (ref $WasmStr)) (result i32) ;; exported as "wantOk"
    (local $msg_1 (ref $WasmStr))
    local.get $r
    i32.const 1
    i32.eq
    if (result i32)
      array.new_fixed $WasmStr 0
      local.get $msg
      call $strConcat
      i32.const 46
      i32.const 32
      i32.const 69
      i32.const 120
      i32.const 112
      i32.const 101
      i32.const 99
      i32.const 116
      i32.const 101
      i32.const 100
      i32.const 32
      i32.const 79
      i32.const 107
      i32.const 32
      i32.const 98
      i32.const 117
      i32.const 116
      i32.const 32
      i32.const 103
      i32.const 111
      i32.const 116
      i32.const 32
      i32.const 69
      i32.const 114
      i32.const 114
      i32.const 111
      i32.const 114
      i32.const 58
      i32.const 32
      array.new_fixed $WasmStr 29
      call $strConcat
      i32.const 0
      call $intToStr
      call $strConcat
      i32.const 46
      array.new_fixed $WasmStr 1
      call $strConcat
      local.set $msg_1
      local.get $msg_1
      struct.new $Wasmecto_Expect_FailException
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
      i32.const 0
    else
      i32.const 0
    end
  )
  (func $closure_26 (param $self (ref $AnyFn)) (param $b0 (ref $Wasmecto_Test)) (param $b1 (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_28))
    (local $name_1 (ref $WasmStr))
    (local $parentState i32)
    (local $prefix (ref $WasmStr))
    (local $t (ref $Wasmecto_Test))
    local.get $self
    ref.cast (ref $ClosureType_28)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_28 1
    local.set $name_1
    local.get $self_cast
    struct.get $ClosureType_28 2
    local.set $parentState
    local.get $self_cast
    struct.get $ClosureType_28 3
    local.set $prefix
    local.get $self_cast
    struct.get $ClosureType_28 4
    local.set $t
    local.get $prefix
    array.new_fixed $WasmStr 0
    call $strEq
    if (result (ref $WasmStr))
      local.get $name_1
    else
      local.get $prefix
      i32.const 47
      array.new_fixed $WasmStr 1
      call $strConcat
      local.get $name_1
      call $strConcat
    end
    local.get $parentState
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $t
      ref.cast (ref $ListCons_8)
      struct.get $ListCons_8 3
    end
    local.get $b0
    local.get $b1
    call $go
  )
  (func $closure_25 (param $self (ref $AnyFn)) (param $prefix (ref $WasmStr)) (param $parentState i32) (param $t (ref $Wasmecto_Test)) (param $acc (ref null $ListBase)) (result (ref null $ListBase))
    (local $name_1 (ref $WasmStr))
    (local $w7 (ref null $ListBase))
    (local $w5 (ref null $ListBase))
    (local $w6 (ref null $ListBase))
    (local $w8 (ref null $ListBase))
    (local $b0 (ref $Wasmecto_Test))
    (local $name_2 (ref $WasmStr))
    (local $state i32)
    (local $name (ref $WasmStr))
    local.get $t
    struct.get $Wasmecto_Test 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $t
      ref.cast (ref $ListCons_8)
      struct.get $ListCons_8 1
      local.set $name_1
      local.get $t
      ref.cast (ref $ListCons_8)
      struct.get $ListCons_8 2
      local.set $w5
      ref.null $ListBase
      local.set $w6
      block $while_lp_3_exit
        loop $while_lp_3
          local.get $w5
          ref.is_null
          i32.eqz
          if
            local.get $w5
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 0
            local.get $w6
            struct.new $ListCons_8
            local.set $w6
            local.get $w5
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 1
            local.set $w5
            br $while_lp_3
          else
            br $while_lp_3_exit
          end
        end
      end
      local.get $w6
      local.set $w7
      local.get $acc
      local.set $w8
      block $while_lp_4_exit
        loop $while_lp_4
          local.get $w7
          ref.is_null
          i32.eqz
          if
            local.get $w7
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 0
            local.set $b0
            local.get $prefix
            array.new_fixed $WasmStr 0
            call $strEq
            if (result (ref $WasmStr))
              local.get $name_1
            else
              local.get $prefix
              i32.const 47
              array.new_fixed $WasmStr 1
              call $strConcat
              local.get $name_1
              call $strConcat
            end
            local.get $parentState
            i32.const 1
            i32.eq
            if (result i32)
              i32.const 1
            else
              local.get $t
              ref.cast (ref $ListCons_8)
              struct.get $ListCons_8 3
            end
            local.get $b0
            local.get $w8
            call $go
            local.set $w8
            local.get $w7
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 1
            local.set $w7
            br $while_lp_4
          else
            br $while_lp_4_exit
          end
        end
      end
      local.get $w8
    else
      local.get $t
      struct.get $Wasmecto_Test 0
      i32.const 2
      i32.eq
      if (result (ref null $ListBase))
        local.get $t
        ref.cast (ref $Wasmecto_Test#1)
        struct.get $Wasmecto_Test#1 1
        local.set $name_2
        local.get $prefix
        array.new_fixed $WasmStr 0
        call $strEq
        if (result (ref $WasmStr))
          local.get $name_2
        else
          local.get $prefix
          i32.const 47
          array.new_fixed $WasmStr 1
          call $strConcat
          local.get $name_2
          call $strConcat
        end
        local.get $parentState
        i32.const 1
        i32.eq
        if (result i32)
          i32.const 1
        else
          local.get $t
          ref.cast (ref $Wasmecto_Test#1)
          struct.get $Wasmecto_Test#1 3
        end
        local.get $t
        ref.cast (ref $Wasmecto_Test#1)
        struct.get $Wasmecto_Test#1 2
        local.get $acc
        call $go
      else
        local.get $t
        ref.cast (ref $Wasmecto_Test#0)
        struct.get $Wasmecto_Test#0 3
        local.set $state
        local.get $t
        ref.cast (ref $Wasmecto_Test#0)
        struct.get $Wasmecto_Test#0 1
        local.set $name
        local.get $prefix
        array.new_fixed $WasmStr 0
        call $strEq
        if (result (ref $WasmStr))
          local.get $name
        else
          local.get $prefix
          i32.const 47
          array.new_fixed $WasmStr 1
          call $strConcat
          local.get $name
          call $strConcat
        end
        local.get $t
        ref.cast (ref $Wasmecto_Test#0)
        struct.get $Wasmecto_Test#0 2
        local.get $parentState
        i32.const 1
        i32.eq
        if (result i32)
          i32.const 1
        else
          local.get $parentState
          i32.const 2
          i32.eq
          if (result i32)
            local.get $state
            i32.const 2
            i32.eq
            if (result i32)
              i32.const 2
            else
              local.get $state
              i32.const 0
              i32.eq
              if (result i32)
                i32.const 2
              else
                local.get $state
              end
            end
          else
            local.get $state
            i32.const 2
            i32.eq
            if (result i32)
              i32.const 2
            else
              local.get $state
            end
          end
        end
        struct.new $Wasmecto_Runner_FlatTest
        local.get $acc
        struct.new $ListCons_25
      end
    end
  )
  (func $flatten (param $test (ref $Wasmecto_Test)) (result (ref null $ListBase)) ;; exported as "flatten"
    (local $go (ref $ClosureType_31))
    (local $lo_clo_3 (ref $ClosureBase_30))
    ref.func $closure_25
    struct.new $ClosureType_31
    local.set $go
    local.get $go
    ref.cast (ref $ClosureBase_30)
    local.set $lo_clo_3
    local.get $lo_clo_3
    array.new_fixed $WasmStr 0
    i32.const 0
    local.get $test
    ref.null $ListBase
    local.get $lo_clo_3
    struct.get $ClosureBase_30 0
    call_ref $FuncType_29
  )
  (func $closure_32 (param $self (ref $AnyFn)) (param $t (ref $Wasmecto_Runner_FlatTest)) (result i32)
    local.get $t
    struct.get $Wasmecto_Runner_FlatTest 2
    i32.const 2
    i32.eq
  )
  (func $hasFocus (param $tests (ref null $ListBase)) (result i32) ;; exported as "hasFocus"
    (local $w9 (ref null $ListBase))
    (local $t (ref $Wasmecto_Runner_FlatTest))
    local.get $tests
    local.set $w9
    block $exi_blk_1 (result i32)
      block $exi_lp_2_exit
        loop $exi_lp_2
          local.get $w9
          ref.is_null
          i32.eqz
          if
            local.get $w9
            ref.cast (ref $ListCons_25)
            struct.get $ListCons_25 0
            local.set $t
            local.get $t
            struct.get $Wasmecto_Runner_FlatTest 2
            i32.const 2
            i32.eq
            if
              i32.const 1
              br $exi_blk_1
            end
            local.get $w9
            ref.cast (ref $ListCons_25)
            struct.get $ListCons_25 1
            local.set $w9
          else
            br $exi_lp_2_exit
          end
          br $exi_lp_2
        end
      end
      i32.const 0
    end
  )
  (func $run (param $writeLine (ref $AnyFn)) (param $test (ref $Wasmecto_Test)) (result i32) ;; exported as "run"
    (local $flat (ref null $ListBase))
    (local $total i32)
    (local $w10 (ref null $ListBase))
    (local $w11 i32)
    (local $focused i32)
    (local $lo_clo_4 (ref $ClosureBase_129))
    (local $lo_clo_5 (ref $ClosureBase_129))
    (local $n i32)
    (local $failed i32)
    (local $ft (ref $Wasmecto_Runner_FlatTest))
    (local $skip (ref null $WasmStr))
    (local $matchValue i32)
    (local $result i32)
    (local $lo_clo_7 (ref $ClosureBase_18))
    (local $lo_clo_9 (ref $ClosureBase_129))
    (local $lo_clo_10 (ref $ClosureBase_129))
    (local $lo_clo_11 (ref $ClosureBase_129))
    (local $lo_clo_12 (ref $ClosureBase_129))
    (local $lo_clo_13 (ref $ClosureBase_129))
    (local $lo_clo_14 (ref $ClosureBase_129))
    (local $lo_clo_15 (ref $ClosureBase_129))
    (local $lo_clo_16 (ref $ClosureBase_129))
    (local $lo_clo_17 (ref $ClosureBase_129))
    (local $lo_clo_8 (ref $ClosureBase_129))
    (local $reason (ref $WasmStr))
    (local $lo_clo_6 (ref $ClosureBase_129))
    (local $lo_clo_18 (ref $ClosureBase_129))
    (local $lo_clo_19 (ref $ClosureBase_129))
    (local $lo_clo_20 (ref $ClosureBase_129))
    local.get $test
    call $flatten
    local.set $flat
    local.get $flat
    local.set $w10
    i32.const 0
    local.set $w11
    block $while_lp_5_exit
      loop $while_lp_5
        local.get $w10
        ref.is_null
        i32.eqz
        if
          local.get $w11
          i32.const 1
          i32.add
          local.set $w11
          local.get $w10
          ref.cast (ref $ListCons_25)
          struct.get $ListCons_25 1
          local.set $w10
          br $while_lp_5
        else
          br $while_lp_5_exit
        end
      end
    end
    local.get $w11
    local.set $total
    local.get $flat
    call $hasFocus
    local.set $focused
    local.get $writeLine
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_4
    local.get $lo_clo_4
    i32.const 84
    i32.const 65
    i32.const 80
    i32.const 32
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 49
    i32.const 51
    array.new_fixed $WasmStr 14
    local.get $lo_clo_4
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    local.get $writeLine
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_5
    local.get $lo_clo_5
    i32.const 49
    i32.const 46
    i32.const 46
    array.new_fixed $WasmStr 3
    local.get $total
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    local.get $lo_clo_5
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    i32.const 0
    local.set $n
    i32.const 0
    local.set $failed
    (block
      (block
        (try_table (catch_all 0)
                loop $while
                  i32.const 0
                  call_ref 0 ;; TODO: resolve functype
                  if
                    i32.const 0
                    call_ref 0 ;; TODO: resolve functype
                    local.set $ft
                    local.get $n
                    i32.const 1
                    i32.add
                    local.set $n
                    local.get $ft
                    struct.get $Wasmecto_Runner_FlatTest 2
                    local.set $matchValue
                    local.get $matchValue
                    i32.const 1
                    i32.eq
                    if (result (ref null $WasmStr))
                      i32.const 112
                      i32.const 101
                      i32.const 110
                      i32.const 100
                      i32.const 105
                      i32.const 110
                      i32.const 103
                      array.new_fixed $WasmStr 7
                    else
                      local.get $matchValue
                      i32.const 0
                      i32.eq
                      if (result (ref null $WasmStr))
                        local.get $focused
                        if (result (ref null $WasmStr))
                          i32.const 110
                          i32.const 111
                          i32.const 116
                          i32.const 32
                          i32.const 102
                          i32.const 111
                          i32.const 99
                          i32.const 117
                          i32.const 115
                          i32.const 101
                          i32.const 100
                          array.new_fixed $WasmStr 11
                        else
                          ref.null $WasmStr
                        end
                      else
                        ref.null $WasmStr
                      end
                    end
                    local.set $skip
                    local.get $skip
                    ref.is_null
                    if
                      call $reset
                      (block (result i32)
                        (block
                          (try_table (result i32) (catch_all 0)
                                  local.get $ft
                                  struct.get $Wasmecto_Runner_FlatTest 1
                                  ref.cast (ref $Wasmecto_TestCode#0)
                                  struct.get $Wasmecto_TestCode#0 1
                                  ref.cast (ref $ClosureBase_18)
                                  local.set $lo_clo_7
                                  local.get $lo_clo_7
                                  local.get $lo_clo_7
                                  struct.get $ClosureBase_18 0
                                  call_ref $FuncType_17
                                  i32.const 0
                                  struct.new $Wasmecto_TestResult#0
                          )
                          br 1
                        )
                          ref.func $Kind
                          i32.const 1
                          ref.eq
                          if (result (ref $Wasmecto_TestResult))
                            i32.const 1
                            ref.func $Msg
                            struct.new $Wasmecto_TestResult#1
                          else
                            i32.const 2
                            i32.const 117
                            i32.const 110
                            i32.const 101
                            i32.const 120
                            i32.const 112
                            i32.const 101
                            i32.const 99
                            i32.const 116
                            i32.const 101
                            i32.const 100
                            i32.const 32
                            i32.const 114
                            i32.const 117
                            i32.const 110
                            i32.const 116
                            i32.const 105
                            i32.const 109
                            i32.const 101
                            i32.const 32
                            i32.const 101
                            i32.const 120
                            i32.const 99
                            i32.const 101
                            i32.const 112
                            i32.const 116
                            i32.const 105
                            i32.const 111
                            i32.const 110
                            array.new_fixed $WasmStr 28
                            struct.new $Wasmecto_TestResult#2
                          end
                      )
                      local.set $result
                      local.get $result
                      struct.get $Wasmecto_TestResult 0
                      i32.const 1
                      i32.eq
                      if
                        local.get $failed
                        i32.const 1
                        i32.add
                        local.set $failed
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_9
                        local.get $lo_clo_9
                        i32.const 110
                        i32.const 111
                        i32.const 116
                        i32.const 32
                        i32.const 111
                        i32.const 107
                        i32.const 32
                        array.new_fixed $WasmStr 7
                        local.get $n
                        call $intToStr
                        call $strConcat
                        i32.const 32
                        i32.const 45
                        i32.const 32
                        array.new_fixed $WasmStr 3
                        call $strConcat
                        local.get $ft
                        struct.get $Wasmecto_Runner_FlatTest 0
                        call $strConcat
                        array.new_fixed $WasmStr 0
                        call $strConcat
                        local.get $lo_clo_9
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_10
                        local.get $lo_clo_10
                        i32.const 32
                        i32.const 32
                        i32.const 45
                        i32.const 45
                        i32.const 45
                        array.new_fixed $WasmStr 5
                        local.get $lo_clo_10
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_11
                        local.get $lo_clo_11
                        i32.const 32
                        i32.const 32
                        i32.const 109
                        i32.const 101
                        i32.const 115
                        i32.const 115
                        i32.const 97
                        i32.const 103
                        i32.const 101
                        i32.const 58
                        i32.const 32
                        array.new_fixed $WasmStr 11
                        local.get $result
                        ref.cast (ref $Wasmecto_TestResult#1)
                        struct.get $Wasmecto_TestResult#1 1
                        call $strConcat
                        array.new_fixed $WasmStr 0
                        call $strConcat
                        local.get $lo_clo_11
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_12
                        local.get $lo_clo_12
                        i32.const 32
                        i32.const 32
                        i32.const 46
                        i32.const 46
                        i32.const 46
                        array.new_fixed $WasmStr 5
                        local.get $lo_clo_12
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                      else
                        local.get $result
                        struct.get $Wasmecto_TestResult 0
                        i32.const 2
                        i32.eq
                        if
                          local.get $failed
                          i32.const 1
                          i32.add
                          local.set $failed
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_13
                          local.get $lo_clo_13
                          i32.const 110
                          i32.const 111
                          i32.const 116
                          i32.const 32
                          i32.const 111
                          i32.const 107
                          i32.const 32
                          array.new_fixed $WasmStr 7
                          local.get $n
                          call $intToStr
                          call $strConcat
                          i32.const 32
                          i32.const 45
                          i32.const 32
                          array.new_fixed $WasmStr 3
                          call $strConcat
                          local.get $ft
                          struct.get $Wasmecto_Runner_FlatTest 0
                          call $strConcat
                          array.new_fixed $WasmStr 0
                          call $strConcat
                          local.get $lo_clo_13
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_14
                          local.get $lo_clo_14
                          i32.const 32
                          i32.const 32
                          i32.const 45
                          i32.const 45
                          i32.const 45
                          array.new_fixed $WasmStr 5
                          local.get $lo_clo_14
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_15
                          local.get $lo_clo_15
                          i32.const 32
                          i32.const 32
                          i32.const 109
                          i32.const 101
                          i32.const 115
                          i32.const 115
                          i32.const 97
                          i32.const 103
                          i32.const 101
                          i32.const 58
                          i32.const 32
                          i32.const 69
                          i32.const 88
                          i32.const 67
                          i32.const 69
                          i32.const 80
                          i32.const 84
                          i32.const 73
                          i32.const 79
                          i32.const 78
                          i32.const 58
                          i32.const 32
                          array.new_fixed $WasmStr 22
                          local.get $result
                          ref.cast (ref $Wasmecto_TestResult#2)
                          struct.get $Wasmecto_TestResult#2 1
                          call $strConcat
                          array.new_fixed $WasmStr 0
                          call $strConcat
                          local.get $lo_clo_15
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_16
                          local.get $lo_clo_16
                          i32.const 32
                          i32.const 32
                          i32.const 46
                          i32.const 46
                          i32.const 46
                          array.new_fixed $WasmStr 5
                          local.get $lo_clo_16
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                        else
                          local.get $result
                          struct.get $Wasmecto_TestResult 0
                          i32.const 3
                          i32.eq
                          if
                            local.get $writeLine
                            ref.cast (ref $ClosureBase_129)
                            local.set $lo_clo_17
                            local.get $lo_clo_17
                            i32.const 111
                            i32.const 107
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            local.get $n
                            call $intToStr
                            call $strConcat
                            i32.const 32
                            i32.const 45
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            call $strConcat
                            local.get $ft
                            struct.get $Wasmecto_Runner_FlatTest 0
                            call $strConcat
                            i32.const 32
                            i32.const 35
                            i32.const 32
                            i32.const 83
                            i32.const 75
                            i32.const 73
                            i32.const 80
                            i32.const 32
                            array.new_fixed $WasmStr 8
                            call $strConcat
                            local.get $result
                            ref.cast (ref $Wasmecto_TestResult#3)
                            struct.get $Wasmecto_TestResult#3 1
                            call $strConcat
                            array.new_fixed $WasmStr 0
                            call $strConcat
                            local.get $lo_clo_17
                            struct.get $ClosureBase_129 0
                            call_ref $FuncType_35
                          else
                            local.get $writeLine
                            ref.cast (ref $ClosureBase_129)
                            local.set $lo_clo_8
                            local.get $lo_clo_8
                            i32.const 111
                            i32.const 107
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            local.get $n
                            call $intToStr
                            call $strConcat
                            i32.const 32
                            i32.const 45
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            call $strConcat
                            local.get $ft
                            struct.get $Wasmecto_Runner_FlatTest 0
                            call $strConcat
                            array.new_fixed $WasmStr 0
                            call $strConcat
                            local.get $lo_clo_8
                            struct.get $ClosureBase_129 0
                            call_ref $FuncType_35
                          end
                        end
                      end
                    else
                      local.get $skip
                      ref.cast (ref $WasmStr)
                      local.set $reason
                      local.get $writeLine
                      ref.cast (ref $ClosureBase_129)
                      local.set $lo_clo_6
                      local.get $lo_clo_6
                      i32.const 111
                      i32.const 107
                      i32.const 32
                      array.new_fixed $WasmStr 3
                      local.get $n
                      call $intToStr
                      call $strConcat
                      i32.const 32
                      i32.const 45
                      i32.const 32
                      array.new_fixed $WasmStr 3
                      call $strConcat
                      local.get $ft
                      struct.get $Wasmecto_Runner_FlatTest 0
                      call $strConcat
                      i32.const 32
                      i32.const 35
                      i32.const 32
                      i32.const 83
                      i32.const 75
                      i32.const 73
                      i32.const 80
                      i32.const 32
                      array.new_fixed $WasmStr 8
                      call $strConcat
                      local.get $reason
                      call $strConcat
                      array.new_fixed $WasmStr 0
                      call $strConcat
                      local.get $lo_clo_6
                      struct.get $ClosureBase_129 0
                      call_ref $FuncType_35
                    end
                    br $while
                  end
                end
        )
        br 1
      )
    )
    local.get $writeLine
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_18
    local.get $lo_clo_18
    array.new_fixed $WasmStr 0
    local.get $lo_clo_18
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    local.get $failed
    i32.const 0
    i32.eq
    if
      local.get $writeLine
      ref.cast (ref $ClosureBase_129)
      local.set $lo_clo_19
      local.get $lo_clo_19
      i32.const 35
      i32.const 32
      i32.const 65
      i32.const 108
      i32.const 108
      i32.const 32
      array.new_fixed $WasmStr 6
      local.get $total
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 116
      i32.const 101
      i32.const 115
      i32.const 116
      i32.const 115
      i32.const 32
      i32.const 112
      i32.const 97
      i32.const 115
      i32.const 115
      i32.const 101
      i32.const 100
      i32.const 46
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $lo_clo_19
      struct.get $ClosureBase_129 0
      call_ref $FuncType_35
    else
      local.get $writeLine
      ref.cast (ref $ClosureBase_129)
      local.set $lo_clo_20
      local.get $lo_clo_20
      i32.const 35
      i32.const 32
      array.new_fixed $WasmStr 2
      local.get $failed
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 111
      i32.const 102
      i32.const 32
      array.new_fixed $WasmStr 4
      call $strConcat
      local.get $total
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 116
      i32.const 101
      i32.const 115
      i32.const 116
      i32.const 115
      i32.const 32
      i32.const 70
      i32.const 65
      i32.const 73
      i32.const 76
      i32.const 69
      i32.const 68
      i32.const 46
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $lo_clo_20
      struct.get $ClosureBase_129 0
      call_ref $FuncType_35
    end
    local.get $failed
  )
  (func $runAll (param $writeLine (ref $AnyFn)) (param $tests (ref null $ListBase)) (result i32) ;; exported as "runAll"
    local.get $writeLine
    i32.const 1
    array.new_fixed $WasmStr 0
    local.get $tests
    i32.const 0
    struct.new $ListCons_8
    return_call $run
  )
  (func $registry (result (ref $ResizeArray_37)) ;; exported as "registry"
    ref.null $Wasmecto_Test
    i32.const 4
    array.new $GcArray_36
    i32.const 0
    struct.new $ResizeArray_37
  )
  (func $register (param $tests (ref null $ListBase)) ;; exported as "register"
    (local $t (ref $Wasmecto_Test))
    (local $w12 (ref $ResizeArray_37))
    (local $w13 i32)
    (local $w14 (ref $GcArray_36))
    (local $w15 i32)
    (local $w16 (ref $GcArray_36))
    (block
      (block
        (try_table (catch_all 0)
                loop $while
                  i32.const 0
                  call_ref 0 ;; TODO: resolve functype
                  if
                    i32.const 0
                    call_ref 0 ;; TODO: resolve functype
                    local.set $t
                    call $registry
                    local.set $w12
                    local.get $w12
                    struct.get $ResizeArray_37 1
                    local.set $w13
                    local.get $w12
                    struct.get $ResizeArray_37 0
                    ref.cast (ref $GcArray_36)
                    local.set $w14
                    local.get $w13
                    local.get $w14
                    array.len
                    i32.ge_u
                    if
                      local.get $w14
                      array.len
                      i32.const 1
                      i32.shl
                      local.set $w15
                      ref.null $Wasmecto_Test
                      local.get $w15
                      array.new $GcArray_36
                      local.set $w16
                      local.get $w16
                      i32.const 0
                      local.get $w14
                      i32.const 0
                      local.get $w13
                      array.copy $GcArray_36 $GcArray_36
                      local.get $w12
                      local.get $w16
                      struct.set $ResizeArray_37 0
                    end
                    local.get $w12
                    struct.get $ResizeArray_37 0
                    ref.cast (ref $GcArray_36)
                    local.get $w13
                    local.get $t
                    array.set $GcArray_36
                    local.get $w12
                    local.get $w13
                    i32.const 1
                    i32.add
                    struct.set $ResizeArray_37 1
                    br $while
                  end
                end
        )
        br 1
      )
    )
  )
  (func $wasmecto_run (param $writeLine (ref $AnyFn)) (result i32) ;; exported as "wasmecto_run"
    local.get $writeLine
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    return_call $runAll
  )
  (func $closure_38 (param $self (ref $AnyFn)) (param $b0 (ref $Wasmecto_Test)) (param $b1 (ref null $ListBase)) (result (ref null $ListBase))
    (local $self_cast (ref $ClosureType_38))
    (local $name_1 (ref $WasmStr))
    (local $parentState i32)
    (local $prefix (ref $WasmStr))
    (local $t (ref $Wasmecto_Test))
    local.get $self
    ref.cast (ref $ClosureType_38)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_38 1
    local.set $name_1
    local.get $self_cast
    struct.get $ClosureType_38 2
    local.set $parentState
    local.get $self_cast
    struct.get $ClosureType_38 3
    local.set $prefix
    local.get $self_cast
    struct.get $ClosureType_38 4
    local.set $t
    local.get $prefix
    array.new_fixed $WasmStr 0
    call $strEq
    if (result (ref $WasmStr))
      local.get $name_1
    else
      local.get $prefix
      i32.const 47
      array.new_fixed $WasmStr 1
      call $strConcat
      local.get $name_1
      call $strConcat
    end
    local.get $parentState
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $t
      ref.cast (ref $ListCons_8)
      struct.get $ListCons_8 3
    end
    local.get $b0
    local.get $b1
    call $go
  )
  (func $closure_38 (param $self (ref $AnyFn)) (param $prefix (ref $WasmStr)) (param $parentState i32) (param $t (ref $Wasmecto_Test)) (param $acc (ref null $ListBase)) (result (ref null $ListBase))
    (local $name_1 (ref $WasmStr))
    (local $w19 (ref null $ListBase))
    (local $w17 (ref null $ListBase))
    (local $w18 (ref null $ListBase))
    (local $w20 (ref null $ListBase))
    (local $b0 (ref $Wasmecto_Test))
    (local $name_2 (ref $WasmStr))
    (local $state i32)
    (local $name (ref $WasmStr))
    local.get $t
    struct.get $Wasmecto_Test 0
    i32.const 1
    i32.eq
    if (result (ref null $ListBase))
      local.get $t
      ref.cast (ref $ListCons_8)
      struct.get $ListCons_8 1
      local.set $name_1
      local.get $t
      ref.cast (ref $ListCons_8)
      struct.get $ListCons_8 2
      local.set $w17
      ref.null $ListBase
      local.set $w18
      block $while_lp_6_exit
        loop $while_lp_6
          local.get $w17
          ref.is_null
          i32.eqz
          if
            local.get $w17
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 0
            local.get $w18
            struct.new $ListCons_8
            local.set $w18
            local.get $w17
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 1
            local.set $w17
            br $while_lp_6
          else
            br $while_lp_6_exit
          end
        end
      end
      local.get $w18
      local.set $w19
      local.get $acc
      local.set $w20
      block $while_lp_7_exit
        loop $while_lp_7
          local.get $w19
          ref.is_null
          i32.eqz
          if
            local.get $w19
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 0
            local.set $b0
            local.get $prefix
            array.new_fixed $WasmStr 0
            call $strEq
            if (result (ref $WasmStr))
              local.get $name_1
            else
              local.get $prefix
              i32.const 47
              array.new_fixed $WasmStr 1
              call $strConcat
              local.get $name_1
              call $strConcat
            end
            local.get $parentState
            i32.const 1
            i32.eq
            if (result i32)
              i32.const 1
            else
              local.get $t
              ref.cast (ref $ListCons_8)
              struct.get $ListCons_8 3
            end
            local.get $b0
            local.get $w20
            call $go
            local.set $w20
            local.get $w19
            ref.cast (ref $ListCons_8)
            struct.get $ListCons_8 1
            local.set $w19
            br $while_lp_7
          else
            br $while_lp_7_exit
          end
        end
      end
      local.get $w20
    else
      local.get $t
      struct.get $Wasmecto_Test 0
      i32.const 2
      i32.eq
      if (result (ref null $ListBase))
        local.get $t
        ref.cast (ref $Wasmecto_Test#1)
        struct.get $Wasmecto_Test#1 1
        local.set $name_2
        local.get $prefix
        array.new_fixed $WasmStr 0
        call $strEq
        if (result (ref $WasmStr))
          local.get $name_2
        else
          local.get $prefix
          i32.const 47
          array.new_fixed $WasmStr 1
          call $strConcat
          local.get $name_2
          call $strConcat
        end
        local.get $parentState
        i32.const 1
        i32.eq
        if (result i32)
          i32.const 1
        else
          local.get $t
          ref.cast (ref $Wasmecto_Test#1)
          struct.get $Wasmecto_Test#1 3
        end
        local.get $t
        ref.cast (ref $Wasmecto_Test#1)
        struct.get $Wasmecto_Test#1 2
        local.get $acc
        call $go
      else
        local.get $t
        ref.cast (ref $Wasmecto_Test#0)
        struct.get $Wasmecto_Test#0 3
        local.set $state
        local.get $t
        ref.cast (ref $Wasmecto_Test#0)
        struct.get $Wasmecto_Test#0 1
        local.set $name
        local.get $prefix
        array.new_fixed $WasmStr 0
        call $strEq
        if (result (ref $WasmStr))
          local.get $name
        else
          local.get $prefix
          i32.const 47
          array.new_fixed $WasmStr 1
          call $strConcat
          local.get $name
          call $strConcat
        end
        local.get $t
        ref.cast (ref $Wasmecto_Test#0)
        struct.get $Wasmecto_Test#0 2
        local.get $parentState
        i32.const 1
        i32.eq
        if (result i32)
          i32.const 1
        else
          local.get $parentState
          i32.const 2
          i32.eq
          if (result i32)
            local.get $state
            i32.const 2
            i32.eq
            if (result i32)
              i32.const 2
            else
              local.get $state
              i32.const 0
              i32.eq
              if (result i32)
                i32.const 2
              else
                local.get $state
              end
            end
          else
            local.get $state
            i32.const 2
            i32.eq
            if (result i32)
              i32.const 2
            else
              local.get $state
            end
          end
        end
        struct.new $Wasmecto_Runner_FlatTest
        local.get $acc
        struct.new $ListCons_25
      end
    end
  )
  (func $flatten (param $test (ref $Wasmecto_Test)) (result (ref null $ListBase)) ;; exported as "flatten"
    (local $go (ref $ClosureType_39))
    (local $lo_clo_21 (ref $ClosureBase_30))
    ref.func $closure_38
    struct.new $ClosureType_39
    local.set $go
    local.get $go
    ref.cast (ref $ClosureBase_30)
    local.set $lo_clo_21
    local.get $lo_clo_21
    array.new_fixed $WasmStr 0
    i32.const 0
    local.get $test
    ref.null $ListBase
    local.get $lo_clo_21
    struct.get $ClosureBase_30 0
    call_ref $FuncType_29
  )
  (func $closure_40 (param $self (ref $AnyFn)) (param $t (ref $Wasmecto_Runner_FlatTest)) (result i32)
    local.get $t
    struct.get $Wasmecto_Runner_FlatTest 2
    i32.const 2
    i32.eq
  )
  (func $hasFocus (param $tests (ref null $ListBase)) (result i32) ;; exported as "hasFocus"
    (local $w21 (ref null $ListBase))
    (local $t (ref $Wasmecto_Runner_FlatTest))
    local.get $tests
    local.set $w21
    block $exi_blk_3 (result i32)
      block $exi_lp_4_exit
        loop $exi_lp_4
          local.get $w21
          ref.is_null
          i32.eqz
          if
            local.get $w21
            ref.cast (ref $ListCons_25)
            struct.get $ListCons_25 0
            local.set $t
            local.get $t
            struct.get $Wasmecto_Runner_FlatTest 2
            i32.const 2
            i32.eq
            if
              i32.const 1
              br $exi_blk_3
            end
            local.get $w21
            ref.cast (ref $ListCons_25)
            struct.get $ListCons_25 1
            local.set $w21
          else
            br $exi_lp_4_exit
          end
          br $exi_lp_4
        end
      end
      i32.const 0
    end
  )
  (func $run (param $writeLine (ref $AnyFn)) (param $test (ref $Wasmecto_Test)) (result i32) ;; exported as "run"
    (local $flat (ref null $ListBase))
    (local $total i32)
    (local $w22 (ref null $ListBase))
    (local $w23 i32)
    (local $focused i32)
    (local $lo_clo_22 (ref $ClosureBase_129))
    (local $lo_clo_23 (ref $ClosureBase_129))
    (local $n i32)
    (local $failed i32)
    (local $ft (ref $Wasmecto_Runner_FlatTest))
    (local $skip (ref null $WasmStr))
    (local $matchValue i32)
    (local $result i32)
    (local $lo_clo_25 (ref $ClosureBase_18))
    (local $matchValue_2 anyref)
    (local $e (ref $Wasmecto_Expect_FailException))
    (local $lo_clo_27 (ref $ClosureBase_129))
    (local $lo_clo_28 (ref $ClosureBase_129))
    (local $lo_clo_29 (ref $ClosureBase_129))
    (local $lo_clo_30 (ref $ClosureBase_129))
    (local $lo_clo_31 (ref $ClosureBase_129))
    (local $lo_clo_32 (ref $ClosureBase_129))
    (local $lo_clo_33 (ref $ClosureBase_129))
    (local $arg_12 (ref $WasmStr))
    (local $lo_clo_34 (ref $ClosureBase_129))
    (local $lo_clo_35 (ref $ClosureBase_129))
    (local $lo_clo_26 (ref $ClosureBase_129))
    (local $reason (ref $WasmStr))
    (local $lo_clo_24 (ref $ClosureBase_129))
    (local $lo_clo_36 (ref $ClosureBase_129))
    (local $lo_clo_37 (ref $ClosureBase_129))
    (local $lo_clo_38 (ref $ClosureBase_129))
    local.get $test
    call $flatten
    local.set $flat
    local.get $flat
    local.set $w22
    i32.const 0
    local.set $w23
    block $while_lp_8_exit
      loop $while_lp_8
        local.get $w22
        ref.is_null
        i32.eqz
        if
          local.get $w23
          i32.const 1
          i32.add
          local.set $w23
          local.get $w22
          ref.cast (ref $ListCons_25)
          struct.get $ListCons_25 1
          local.set $w22
          br $while_lp_8
        else
          br $while_lp_8_exit
        end
      end
    end
    local.get $w23
    local.set $total
    local.get $flat
    call $hasFocus
    local.set $focused
    local.get $writeLine
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_22
    local.get $lo_clo_22
    i32.const 84
    i32.const 65
    i32.const 80
    i32.const 32
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 49
    i32.const 51
    array.new_fixed $WasmStr 14
    local.get $lo_clo_22
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    local.get $writeLine
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_23
    local.get $lo_clo_23
    i32.const 49
    i32.const 46
    i32.const 46
    array.new_fixed $WasmStr 3
    local.get $total
    call $intToStr
    call $strConcat
    array.new_fixed $WasmStr 0
    call $strConcat
    local.get $lo_clo_23
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    i32.const 0
    local.set $n
    i32.const 0
    local.set $failed
    (block
      (block
        (try_table (catch_all 0)
                loop $while
                  i32.const 0
                  call_ref 0 ;; TODO: resolve functype
                  if
                    i32.const 0
                    call_ref 0 ;; TODO: resolve functype
                    local.set $ft
                    local.get $n
                    i32.const 1
                    i32.add
                    local.set $n
                    local.get $ft
                    struct.get $Wasmecto_Runner_FlatTest 2
                    local.set $matchValue
                    local.get $matchValue
                    i32.const 1
                    i32.eq
                    if (result (ref null $WasmStr))
                      i32.const 112
                      i32.const 101
                      i32.const 110
                      i32.const 100
                      i32.const 105
                      i32.const 110
                      i32.const 103
                      array.new_fixed $WasmStr 7
                    else
                      local.get $matchValue
                      i32.const 0
                      i32.eq
                      if (result (ref null $WasmStr))
                        local.get $focused
                        if (result (ref null $WasmStr))
                          i32.const 110
                          i32.const 111
                          i32.const 116
                          i32.const 32
                          i32.const 102
                          i32.const 111
                          i32.const 99
                          i32.const 117
                          i32.const 115
                          i32.const 101
                          i32.const 100
                          array.new_fixed $WasmStr 11
                        else
                          ref.null $WasmStr
                        end
                      else
                        ref.null $WasmStr
                      end
                    end
                    local.set $skip
                    local.get $skip
                    ref.is_null
                    if
                      (block (result i32)
                        (block
                          (try_table (result i32) (catch_all 0)
                                  local.get $ft
                                  struct.get $Wasmecto_Runner_FlatTest 1
                                  ref.cast (ref $Wasmecto_TestCode#0)
                                  struct.get $Wasmecto_TestCode#0 1
                                  ref.cast (ref $ClosureBase_18)
                                  local.set $lo_clo_25
                                  local.get $lo_clo_25
                                  local.get $lo_clo_25
                                  struct.get $ClosureBase_18 0
                                  call_ref $FuncType_17
                                  i32.const 0
                                  struct.new $Wasmecto_TestResult#0
                          )
                          br 1
                        )
                          global.get $fsharp_exn_carrier
                          local.set $matchValue_2
                          local.get $matchValue_2
                          ref.test (ref $Wasmecto_Expect_FailException)
                          if (result (ref $Wasmecto_TestResult))
                            local.get $matchValue_2
                            ref.cast (ref $Wasmecto_Expect_FailException)
                            local.set $e
                            i32.const 1
                            local.get $e
                            struct.get $Wasmecto_Expect_FailException 0
                            struct.new $Wasmecto_TestResult#1
                          else
                            i32.const 2
                            i32.const 1
                            global.set $fsharp_exn_carrier
                            throw $fsharp_exn
                            struct.new $Wasmecto_TestResult#2
                          end
                      )
                      local.set $result
                      local.get $result
                      struct.get $Wasmecto_TestResult 0
                      i32.const 1
                      i32.eq
                      if
                        local.get $failed
                        i32.const 1
                        i32.add
                        local.set $failed
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_27
                        local.get $lo_clo_27
                        i32.const 110
                        i32.const 111
                        i32.const 116
                        i32.const 32
                        i32.const 111
                        i32.const 107
                        i32.const 32
                        array.new_fixed $WasmStr 7
                        local.get $n
                        call $intToStr
                        call $strConcat
                        i32.const 32
                        i32.const 45
                        i32.const 32
                        array.new_fixed $WasmStr 3
                        call $strConcat
                        local.get $ft
                        struct.get $Wasmecto_Runner_FlatTest 0
                        call $strConcat
                        array.new_fixed $WasmStr 0
                        call $strConcat
                        local.get $lo_clo_27
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_28
                        local.get $lo_clo_28
                        i32.const 32
                        i32.const 32
                        i32.const 45
                        i32.const 45
                        i32.const 45
                        array.new_fixed $WasmStr 5
                        local.get $lo_clo_28
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_29
                        local.get $lo_clo_29
                        i32.const 32
                        i32.const 32
                        i32.const 109
                        i32.const 101
                        i32.const 115
                        i32.const 115
                        i32.const 97
                        i32.const 103
                        i32.const 101
                        i32.const 58
                        i32.const 32
                        array.new_fixed $WasmStr 11
                        local.get $result
                        ref.cast (ref $Wasmecto_TestResult#1)
                        struct.get $Wasmecto_TestResult#1 1
                        call $strConcat
                        array.new_fixed $WasmStr 0
                        call $strConcat
                        local.get $lo_clo_29
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                        local.get $writeLine
                        ref.cast (ref $ClosureBase_129)
                        local.set $lo_clo_30
                        local.get $lo_clo_30
                        i32.const 32
                        i32.const 32
                        i32.const 46
                        i32.const 46
                        i32.const 46
                        array.new_fixed $WasmStr 5
                        local.get $lo_clo_30
                        struct.get $ClosureBase_129 0
                        call_ref $FuncType_35
                      else
                        local.get $result
                        struct.get $Wasmecto_TestResult 0
                        i32.const 2
                        i32.eq
                        if
                          local.get $failed
                          i32.const 1
                          i32.add
                          local.set $failed
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_31
                          local.get $lo_clo_31
                          i32.const 110
                          i32.const 111
                          i32.const 116
                          i32.const 32
                          i32.const 111
                          i32.const 107
                          i32.const 32
                          array.new_fixed $WasmStr 7
                          local.get $n
                          call $intToStr
                          call $strConcat
                          i32.const 32
                          i32.const 45
                          i32.const 32
                          array.new_fixed $WasmStr 3
                          call $strConcat
                          local.get $ft
                          struct.get $Wasmecto_Runner_FlatTest 0
                          call $strConcat
                          array.new_fixed $WasmStr 0
                          call $strConcat
                          local.get $lo_clo_31
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_32
                          local.get $lo_clo_32
                          i32.const 32
                          i32.const 32
                          i32.const 45
                          i32.const 45
                          i32.const 45
                          array.new_fixed $WasmStr 5
                          local.get $lo_clo_32
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_33
                          local.get $lo_clo_33
                          i32.const 1
                          global.set $fsharp_exn_carrier
                          throw $fsharp_exn
                          local.set $arg_12
                          i32.const 32
                          i32.const 32
                          i32.const 109
                          i32.const 101
                          i32.const 115
                          i32.const 115
                          i32.const 97
                          i32.const 103
                          i32.const 101
                          i32.const 58
                          i32.const 32
                          i32.const 69
                          i32.const 88
                          i32.const 67
                          i32.const 69
                          i32.const 80
                          i32.const 84
                          i32.const 73
                          i32.const 79
                          i32.const 78
                          i32.const 32
                          array.new_fixed $WasmStr 21
                          i32.const 83
                          i32.const 116
                          i32.const 114
                          i32.const 105
                          i32.const 110
                          i32.const 103
                          array.new_fixed $WasmStr 6
                          call $strConcat
                          i32.const 58
                          i32.const 32
                          array.new_fixed $WasmStr 2
                          call $strConcat
                          local.get $arg_12
                          call $strConcat
                          array.new_fixed $WasmStr 0
                          call $strConcat
                          local.get $lo_clo_33
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                          local.get $writeLine
                          ref.cast (ref $ClosureBase_129)
                          local.set $lo_clo_34
                          local.get $lo_clo_34
                          i32.const 32
                          i32.const 32
                          i32.const 46
                          i32.const 46
                          i32.const 46
                          array.new_fixed $WasmStr 5
                          local.get $lo_clo_34
                          struct.get $ClosureBase_129 0
                          call_ref $FuncType_35
                        else
                          local.get $result
                          struct.get $Wasmecto_TestResult 0
                          i32.const 3
                          i32.eq
                          if
                            local.get $writeLine
                            ref.cast (ref $ClosureBase_129)
                            local.set $lo_clo_35
                            local.get $lo_clo_35
                            i32.const 111
                            i32.const 107
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            local.get $n
                            call $intToStr
                            call $strConcat
                            i32.const 32
                            i32.const 45
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            call $strConcat
                            local.get $ft
                            struct.get $Wasmecto_Runner_FlatTest 0
                            call $strConcat
                            i32.const 32
                            i32.const 35
                            i32.const 32
                            i32.const 83
                            i32.const 75
                            i32.const 73
                            i32.const 80
                            array.new_fixed $WasmStr 7
                            call $strConcat
                            local.get $lo_clo_35
                            struct.get $ClosureBase_129 0
                            call_ref $FuncType_35
                          else
                            local.get $writeLine
                            ref.cast (ref $ClosureBase_129)
                            local.set $lo_clo_26
                            local.get $lo_clo_26
                            i32.const 111
                            i32.const 107
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            local.get $n
                            call $intToStr
                            call $strConcat
                            i32.const 32
                            i32.const 45
                            i32.const 32
                            array.new_fixed $WasmStr 3
                            call $strConcat
                            local.get $ft
                            struct.get $Wasmecto_Runner_FlatTest 0
                            call $strConcat
                            array.new_fixed $WasmStr 0
                            call $strConcat
                            local.get $lo_clo_26
                            struct.get $ClosureBase_129 0
                            call_ref $FuncType_35
                          end
                        end
                      end
                    else
                      local.get $skip
                      ref.cast (ref $WasmStr)
                      local.set $reason
                      local.get $writeLine
                      ref.cast (ref $ClosureBase_129)
                      local.set $lo_clo_24
                      local.get $lo_clo_24
                      i32.const 111
                      i32.const 107
                      i32.const 32
                      array.new_fixed $WasmStr 3
                      local.get $n
                      call $intToStr
                      call $strConcat
                      i32.const 32
                      i32.const 45
                      i32.const 32
                      array.new_fixed $WasmStr 3
                      call $strConcat
                      local.get $ft
                      struct.get $Wasmecto_Runner_FlatTest 0
                      call $strConcat
                      i32.const 32
                      i32.const 35
                      i32.const 32
                      i32.const 83
                      i32.const 75
                      i32.const 73
                      i32.const 80
                      i32.const 32
                      array.new_fixed $WasmStr 8
                      call $strConcat
                      local.get $reason
                      call $strConcat
                      array.new_fixed $WasmStr 0
                      call $strConcat
                      local.get $lo_clo_24
                      struct.get $ClosureBase_129 0
                      call_ref $FuncType_35
                    end
                    br $while
                  end
                end
        )
        br 1
      )
    )
    local.get $writeLine
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_36
    local.get $lo_clo_36
    array.new_fixed $WasmStr 0
    local.get $lo_clo_36
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    local.get $failed
    i32.const 0
    i32.eq
    if
      local.get $writeLine
      ref.cast (ref $ClosureBase_129)
      local.set $lo_clo_37
      local.get $lo_clo_37
      i32.const 35
      i32.const 32
      i32.const 65
      i32.const 108
      i32.const 108
      i32.const 32
      array.new_fixed $WasmStr 6
      local.get $total
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 116
      i32.const 101
      i32.const 115
      i32.const 116
      i32.const 115
      i32.const 32
      i32.const 112
      i32.const 97
      i32.const 115
      i32.const 115
      i32.const 101
      i32.const 100
      i32.const 46
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $lo_clo_37
      struct.get $ClosureBase_129 0
      call_ref $FuncType_35
    else
      local.get $writeLine
      ref.cast (ref $ClosureBase_129)
      local.set $lo_clo_38
      local.get $lo_clo_38
      i32.const 35
      i32.const 32
      array.new_fixed $WasmStr 2
      local.get $failed
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 111
      i32.const 102
      i32.const 32
      array.new_fixed $WasmStr 4
      call $strConcat
      local.get $total
      call $intToStr
      call $strConcat
      i32.const 32
      i32.const 116
      i32.const 101
      i32.const 115
      i32.const 116
      i32.const 115
      i32.const 32
      i32.const 70
      i32.const 65
      i32.const 73
      i32.const 76
      i32.const 69
      i32.const 68
      i32.const 46
      array.new_fixed $WasmStr 14
      call $strConcat
      local.get $lo_clo_38
      struct.get $ClosureBase_129 0
      call_ref $FuncType_35
    end
    local.get $failed
  )
  (func $runAll (param $writeLine (ref $AnyFn)) (param $tests (ref null $ListBase)) (result i32) ;; exported as "runAll"
    local.get $writeLine
    i32.const 1
    array.new_fixed $WasmStr 0
    local.get $tests
    i32.const 0
    struct.new $ListCons_8
    return_call $run
  )
  (func $registry (result (ref $ResizeArray_37)) ;; exported as "registry"
    ref.null $Wasmecto_Test
    i32.const 4
    array.new $GcArray_36
    i32.const 0
    struct.new $ResizeArray_37
  )
  (func $register (param $tests (ref null $ListBase)) ;; exported as "register"
    (local $t (ref $Wasmecto_Test))
    (local $w24 (ref $ResizeArray_37))
    (local $w25 i32)
    (local $w26 (ref $GcArray_36))
    (local $w27 i32)
    (local $w28 (ref $GcArray_36))
    (block
      (block
        (try_table (catch_all 0)
                loop $while
                  i32.const 0
                  call_ref 0 ;; TODO: resolve functype
                  if
                    i32.const 0
                    call_ref 0 ;; TODO: resolve functype
                    local.set $t
                    call $registry
                    local.set $w24
                    local.get $w24
                    struct.get $ResizeArray_37 1
                    local.set $w25
                    local.get $w24
                    struct.get $ResizeArray_37 0
                    ref.cast (ref $GcArray_36)
                    local.set $w26
                    local.get $w25
                    local.get $w26
                    array.len
                    i32.ge_u
                    if
                      local.get $w26
                      array.len
                      i32.const 1
                      i32.shl
                      local.set $w27
                      ref.null $Wasmecto_Test
                      local.get $w27
                      array.new $GcArray_36
                      local.set $w28
                      local.get $w28
                      i32.const 0
                      local.get $w26
                      i32.const 0
                      local.get $w25
                      array.copy $GcArray_36 $GcArray_36
                      local.get $w24
                      local.get $w28
                      struct.set $ResizeArray_37 0
                    end
                    local.get $w24
                    struct.get $ResizeArray_37 0
                    ref.cast (ref $GcArray_36)
                    local.get $w25
                    local.get $t
                    array.set $GcArray_36
                    local.get $w24
                    local.get $w25
                    i32.const 1
                    i32.add
                    struct.set $ResizeArray_37 1
                    br $while
                  end
                end
        )
        br 1
      )
    )
  )
  (func $wasmecto_run (param $writeLine (ref $AnyFn)) (result i32) ;; exported as "wasmecto_run"
    local.get $writeLine
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    return_call $runAll
  )
  (func $shapeArea (param $s (ref $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape)) (result i32) ;; exported as "shapeArea"
    (local $r i32)
    local.get $s
    struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $s
      ref.cast (ref $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#1)
      struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#1 1
      local.get $s
      ref.cast (ref $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#1)
      struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#1 2
      i32.mul
    else
      local.get $s
      ref.cast (ref $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#0)
      struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#0 1
      local.set $r
      local.get $r
      local.get $r
      i32.mul
    end
  )
  (func $body_45 (param $self (ref $AnyFn))
    i32.const 13
    i32.const 13
    i32.const 97
    i32.const 43
    i32.const 98
    array.new_fixed $WasmStr 3
    call $equal
    i32.const 7
    i32.const 7
    i32.const 97
    i32.const 45
    i32.const 98
    array.new_fixed $WasmStr 3
    call $equal
    i32.const 30
    i32.const 30
    i32.const 97
    i32.const 42
    i32.const 98
    array.new_fixed $WasmStr 3
    call $equal
    i32.const 3
    i32.const -1
    i32.xor
    i32.const -1
    i32.xor
    i32.const 3
    i32.const 97
    i32.const 47
    i32.const 98
    array.new_fixed $WasmStr 3
    call $equal
  )
  (func $closure_46 (param $self (ref $AnyFn)) (param $n i32) (result i32)
    local.get $n
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const -1
    else
      local.get $n
      i32.const 0
      i32.eq
      if (result i32)
        i32.const 0
      else
        i32.const 1
      end
    end
  )
  (func $body_1_46 (param $self (ref $AnyFn))
    (local $classify (ref $ClosureType_48))
    (local $lo_clo_39 (ref $ClosureBase_47))
    (local $lo_clo_40 (ref $ClosureBase_47))
    (local $lo_clo_41 (ref $ClosureBase_47))
    ref.func $closure_46
    struct.new $ClosureType_48
    local.set $classify
    local.get $classify
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_39
    local.get $lo_clo_39
    i32.const -7
    local.get $lo_clo_39
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const -1
    i32.const 110
    i32.const 101
    i32.const 103
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 118
    i32.const 101
    array.new_fixed $WasmStr 8
    call $equal
    local.get $classify
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_40
    local.get $lo_clo_40
    i32.const 0
    local.get $lo_clo_40
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 0
    i32.const 122
    i32.const 101
    i32.const 114
    i32.const 111
    array.new_fixed $WasmStr 4
    call $equal
    local.get $classify
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_41
    local.get $lo_clo_41
    i32.const 5
    local.get $lo_clo_41
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 1
    i32.const 112
    i32.const 111
    i32.const 115
    i32.const 105
    i32.const 116
    i32.const 105
    i32.const 118
    i32.const 101
    array.new_fixed $WasmStr 8
    call $equal
  )
  (func $closure_50 (param $self (ref $AnyFn)) (param $n_1 i32) (result (ref $WasmStr))
    local.get $n_1
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref $WasmStr))
      i32.const 101
      i32.const 118
      i32.const 101
      i32.const 110
      array.new_fixed $WasmStr 4
    else
      i32.const 111
      i32.const 100
      i32.const 100
      array.new_fixed $WasmStr 3
    end
  )
  (func $body_2_50 (param $self (ref $AnyFn))
    (local $describe (ref $ClosureType_52))
    (local $lo_clo_42 (ref $ClosureBase_51))
    (local $lo_clo_43 (ref $ClosureBase_51))
    ref.func $closure_50
    struct.new $ClosureType_52
    local.set $describe
    local.get $describe
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_42
    local.get $lo_clo_42
    i32.const 4
    local.get $lo_clo_42
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    i32.const 101
    i32.const 118
    i32.const 101
    i32.const 110
    array.new_fixed $WasmStr 4
    i32.const 52
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 101
    i32.const 118
    i32.const 101
    i32.const 110
    array.new_fixed $WasmStr 9
    call $equal
    local.get $describe
    ref.cast (ref $ClosureBase_51)
    local.set $lo_clo_43
    local.get $lo_clo_43
    i32.const 9
    local.get $lo_clo_43
    struct.get $ClosureBase_51 0
    call_ref $FuncType_50
    i32.const 111
    i32.const 100
    i32.const 100
    array.new_fixed $WasmStr 3
    i32.const 57
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 111
    i32.const 100
    i32.const 100
    array.new_fixed $WasmStr 8
    call $equal
  )
  (func $body_3_54 (param $self (ref $AnyFn))
    (local $pair (ref $Tuple_54))
    i32.const 7
    i32.const 11
    struct.new $Tuple_54
    local.set $pair
    local.get $pair
    struct.get $Tuple_54 0
    i32.const 7
    i32.const 102
    i32.const 115
    i32.const 116
    array.new_fixed $WasmStr 3
    call $equal
    local.get $pair
    struct.get $Tuple_54 1
    i32.const 11
    i32.const 115
    i32.const 110
    i32.const 100
    array.new_fixed $WasmStr 3
    call $equal
  )
  (func $body_4_56 (param $self (ref $AnyFn))
    (local $p (ref $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point))
    i32.const 4
    i32.const 5
    struct.new $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point
    local.set $p
    local.get $p
    struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point 0
    i32.const 4
    i32.const 88
    array.new_fixed $WasmStr 1
    call $equal
    local.get $p
    struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point 1
    i32.const 5
    i32.const 89
    array.new_fixed $WasmStr 1
    call $equal
  )
  (func $body_5_57 (param $self (ref $AnyFn))
    (local $p1 (ref $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point))
    (local $p2 (ref $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point))
    i32.const 1
    i32.const 2
    struct.new $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point
    local.set $p1
    local.get $p1
    struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point 0
    i32.const 99
    struct.new $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point
    local.set $p2
    local.get $p1
    struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point 1
    i32.const 2
    i32.const 115
    i32.const 111
    i32.const 117
    i32.const 114
    i32.const 99
    i32.const 101
    i32.const 32
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 104
    i32.const 97
    i32.const 110
    i32.const 103
    i32.const 101
    i32.const 100
    array.new_fixed $WasmStr 16
    call $equal
    local.get $p2
    struct.get $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Point 1
    i32.const 99
    i32.const 117
    i32.const 112
    i32.const 100
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 112
    i32.const 121
    array.new_fixed $WasmStr 12
    call $equal
  )
  (func $body_6_58 (param $self (ref $AnyFn))
    i32.const 0
    i32.const 3
    struct.new $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#0
    call $shapeArea
    i32.const 9
    i32.const 99
    i32.const 105
    i32.const 114
    i32.const 99
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 97
    i32.const 114
    i32.const 101
    i32.const 97
    i32.const 32
    i32.const 112
    i32.const 114
    i32.const 111
    i32.const 120
    i32.const 121
    array.new_fixed $WasmStr 17
    call $equal
    i32.const 1
    i32.const 4
    i32.const 6
    struct.new $WasmTests_Unit_LanguageAndCollectionsTests_LanguageAndCollectionsTests_Shape#1
    call $shapeArea
    i32.const 24
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 116
    i32.const 32
    i32.const 97
    i32.const 114
    i32.const 101
    i32.const 97
    array.new_fixed $WasmStr 9
    call $equal
  )
  (func $closure_59 (param $self (ref $AnyFn)) (param $opt (ref null $Option_23)) (param $def i32) (result i32)
    local.get $opt
    ref.is_null
    if (result i32)
      local.get $def
    else
      local.get $opt
      ref.cast (ref $Option_23)
      struct.get $Option_23 0
    end
  )
  (func $body_7_59 (param $self (ref $AnyFn))
    (local $defaultOf (ref $ClosureType_61))
    (local $lo_clo_44 (ref $ClosureBase_60))
    (local $lo_clo_45 (ref $ClosureBase_60))
    ref.func $closure_59
    struct.new $ClosureType_61
    local.set $defaultOf
    local.get $defaultOf
    ref.cast (ref $ClosureBase_60)
    local.set $lo_clo_44
    local.get $lo_clo_44
    i32.const 42
    struct.new $Option_23
    i32.const 0
    local.get $lo_clo_44
    struct.get $ClosureBase_60 0
    call_ref $FuncType_59
    i32.const 42
    i32.const 115
    i32.const 111
    i32.const 109
    i32.const 101
    array.new_fixed $WasmStr 4
    call $equal
    local.get $defaultOf
    ref.cast (ref $ClosureBase_60)
    local.set $lo_clo_45
    local.get $lo_clo_45
    ref.null $Option_23
    i32.const 7
    local.get $lo_clo_45
    struct.get $ClosureBase_60 0
    call_ref $FuncType_59
    i32.const 7
    i32.const 110
    i32.const 111
    i32.const 110
    i32.const 101
    array.new_fixed $WasmStr 4
    call $equal
  )
  (func $closure_63 (param $self (ref $AnyFn)) (param $r i32) (result i32)
    local.get $r
    i32.const 1
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>))
      i32.const 1
      local.get $r
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1 1
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#1
    else
      i32.const 0
      local.get $r
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0 1
      i32.const 1
      i32.add
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    end
  )
  (func $body_8_63 (param $self (ref $AnyFn))
    (local $bindPlusOne (ref $ClosureType_66))
    (local $lo_clo_46 (ref $ClosureBase_341))
    (local $lo_clo_47 (ref $ClosureBase_342))
    ref.func $closure_63
    struct.new $ClosureType_66
    local.set $bindPlusOne
    local.get $bindPlusOne
    ref.cast (ref $ClosureBase_341)
    local.set $lo_clo_46
    local.get $lo_clo_46
    i32.const 0
    i32.const 9
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    local.get $lo_clo_46
    struct.get $ClosureBase_341 0
    call_ref $FuncType_67
    i32.const 0
    i32.const 10
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~i32>#0
    i32.const 111
    i32.const 107
    i32.const 32
    i32.const 112
    i32.const 97
    i32.const 116
    i32.const 104
    array.new_fixed $WasmStr 7
    call $equal
    local.get $bindPlusOne
    ref.cast (ref $ClosureBase_342)
    local.set $lo_clo_47
    local.get $lo_clo_47
    i32.const 1
    i32.const 98
    i32.const 111
    i32.const 111
    i32.const 109
    array.new_fixed $WasmStr 4
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1
    local.get $lo_clo_47
    struct.get $ClosureBase_342 0
    call_ref $FuncType_71
    i32.const 1
    i32.const 98
    i32.const 111
    i32.const 111
    i32.const 109
    array.new_fixed $WasmStr 4
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1
    i32.const 101
    i32.const 114
    i32.const 114
    i32.const 111
    i32.const 114
    i32.const 32
    i32.const 112
    i32.const 97
    i32.const 116
    i32.const 104
    array.new_fixed $WasmStr 10
    call $equal
  )
  (func $body_9_73 (param $self (ref $AnyFn))
    (local $s (ref $WasmStr))
    i32.const 102
    i32.const 115
    i32.const 104
    i32.const 97
    i32.const 114
    i32.const 112
    i32.const 45
    i32.const 119
    i32.const 97
    i32.const 115
    i32.const 109
    array.new_fixed $WasmStr 11
    local.set $s
    local.get $s
    i32.const 102
    i32.const 115
    i32.const 104
    i32.const 97
    i32.const 114
    i32.const 112
    i32.const 45
    i32.const 119
    i32.const 97
    i32.const 115
    i32.const 109
    array.new_fixed $WasmStr 11
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 99
    i32.const 97
    i32.const 116
    array.new_fixed $WasmStr 6
    call $equal
    local.get $s
    array.len
    i32.const 11
    i32.const 108
    i32.const 101
    i32.const 110
    i32.const 103
    i32.const 116
    i32.const 104
    array.new_fixed $WasmStr 6
    call $equal
  )
  (func $body_10_74 (param $self (ref $AnyFn))
    (local $xs (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $xs
    local.get $xs
    ref.is_null
    if
      ref.null any
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    else
      local.get $xs
      ref.cast (ref $ListCons_22)
      struct.get $ListCons_22 0
      i32.const 1
      i32.const 104
      i32.const 101
      i32.const 97
      i32.const 100
      array.new_fixed $WasmStr 4
      call $equal
      i32.const 1
      global.set $fsharp_exn_carrier
      throw $fsharp_exn
    end
  )
  (func $closure_75 (param $self (ref $AnyFn)) (param $acc i32) (param $x_4 i32) (result i32)
    local.get $acc
    local.get $x_4
    i32.add
  )
  (func $closure_78 (param $self (ref $AnyFn)) (param $x_3 i32) (result i32)
    local.get $x_3
    i32.const 5
    i32.gt_s
  )
  (func $closure_79 (param $self (ref $AnyFn)) (param $x_2 i32) (result i32)
    local.get $x_2
    i32.const 1
    i32.shl
  )
  (func $closure_80 (param $self (ref $AnyFn)) (param $x_2 i32) (result i32)
    local.get $x_2
    i32.const 1
    i32.shl
  )
  (func $closure_81 (param $self (ref $AnyFn)) (param $x_3 i32) (result i32)
    local.get $x_3
    i32.const 5
    i32.gt_s
  )
  (func $closure_82 (param $self (ref $AnyFn)) (param $x_2 i32) (result i32)
    local.get $x_2
    i32.const 1
    i32.shl
  )
  (func $closure_83 (param $self (ref $AnyFn)) (param $x_2 i32) (result i32)
    local.get $x_2
    i32.const 1
    i32.shl
  )
  (func $body_11_75 (param $self (ref $AnyFn))
    (local $w53 (ref null $ListBase))
    (local $w51 (ref null $ListBase))
    (local $w49 (ref null $ListBase))
    (local $w47 (ref null $ListBase))
    (local $w45 (ref null $ListBase))
    (local $w46 (ref null $ListBase))
    (local $x_2 i32)
    (local $w48 (ref null $ListBase))
    (local $w50 (ref null $ListBase))
    (local $x_3 i32)
    (local $w52 (ref null $ListBase))
    (local $w54 i32)
    (local $x_4 i32)
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w45
    ref.null $ListBase
    local.set $w46
    block $while_lp_17_exit
      loop $while_lp_17
        local.get $w45
        ref.is_null
        i32.eqz
        if
          local.get $w45
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_2
          local.get $x_2
          i32.const 1
          i32.shl
          local.get $w46
          struct.new $ListCons_22
          local.set $w46
          local.get $w45
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w45
          br $while_lp_17
        else
          br $while_lp_17_exit
        end
      end
    end
    local.get $w46
    local.set $w47
    ref.null $ListBase
    local.set $w48
    block $while_lp_18_exit
      loop $while_lp_18
        local.get $w47
        ref.is_null
        i32.eqz
        if
          local.get $w47
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w48
          struct.new $ListCons_22
          local.set $w48
          local.get $w47
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w47
          br $while_lp_18
        else
          br $while_lp_18_exit
        end
      end
    end
    local.get $w48
    local.set $w49
    ref.null $ListBase
    local.set $w50
    block $while_lp_19_exit
      loop $while_lp_19
        local.get $w49
        ref.is_null
        i32.eqz
        if
          local.get $w49
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_3
          local.get $x_3
          i32.const 5
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w49
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 0
            local.get $w50
            struct.new $ListCons_22
          else
            local.get $w50
          end
          local.set $w50
          local.get $w49
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w49
          br $while_lp_19
        else
          br $while_lp_19_exit
        end
      end
    end
    local.get $w50
    local.set $w51
    ref.null $ListBase
    local.set $w52
    block $while_lp_20_exit
      loop $while_lp_20
        local.get $w51
        ref.is_null
        i32.eqz
        if
          local.get $w51
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w52
          struct.new $ListCons_22
          local.set $w52
          local.get $w51
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w51
          br $while_lp_20
        else
          br $while_lp_20_exit
        end
      end
    end
    local.get $w52
    local.set $w53
    i32.const 0
    local.set $w54
    block $while_lp_21_exit
      loop $while_lp_21
        local.get $w53
        ref.is_null
        i32.eqz
        if
          local.get $w53
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_4
          local.get $w54
          local.get $x_4
          i32.add
          local.set $w54
          local.get $w53
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w53
          br $while_lp_21
        else
          br $while_lp_21_exit
        end
      end
    end
    local.get $w54
    i32.const 24
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 115
    i32.const 117
    i32.const 109
    array.new_fixed $WasmStr 8
    call $equal
  )
  (func $closure_85 (param $self (ref $AnyFn)) (param $x_5 i32) (result (ref null $ListBase))
    local.get $x_5
    local.get $x_5
    i32.const 10
    i32.mul
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
  )
  (func $closure_88 (param $self (ref $AnyFn)) (param $x_6 i32) (result (ref null $Option_23))
    local.get $x_6
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
    if (result (ref null $Option_23))
      local.get $x_6
      i32.const 2
      i32.div_s
      i32.const -1
      i32.xor
      i32.const -1
      i32.xor
      struct.new $Option_23
    else
      ref.null $Option_23
    end
  )
  (func $body_12_85 (param $self (ref $AnyFn))
    (local $collected (ref null $ListBase))
    (local $w55 (ref null $ListBase))
    (local $w56 (ref null $ListBase))
    (local $w57 (ref null $ListBase))
    (local $x_5 i32)
    (local $w60 (ref null $ListBase))
    (local $w58 (ref null $ListBase))
    (local $w59 (ref null $ListBase))
    (local $w61 (ref null $ListBase))
    (local $w62 (ref null $ListBase))
    (local $chosen (ref null $ListBase))
    (local $w65 (ref null $ListBase))
    (local $w63 (ref null $ListBase))
    (local $w64 (ref null $ListBase))
    (local $cho_opt_1 (ref null $Option_23))
    (local $x_6 i32)
    (local $w66 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w55
    ref.null $ListBase
    local.set $w56
    block $while_lp_23_exit
      loop $while_lp_23
        local.get $w55
        ref.is_null
        i32.eqz
        if
          local.get $w55
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_5
          local.get $x_5
          local.get $x_5
          i32.const 10
          i32.mul
          ref.null $ListBase
          struct.new $ListCons_22
          struct.new $ListCons_22
          local.set $w57
          local.get $w57
          local.set $w58
          local.get $w56
          local.set $w59
          block $while_lp_22_exit
            loop $while_lp_22
              local.get $w58
              ref.is_null
              i32.eqz
              if
                local.get $w58
                ref.cast (ref $ListCons_22)
                struct.get $ListCons_22 0
                local.get $w59
                struct.new $ListCons_22
                local.set $w59
                local.get $w58
                ref.cast (ref $ListCons_22)
                struct.get $ListCons_22 1
                local.set $w58
                br $while_lp_22
              else
                br $while_lp_22_exit
              end
            end
          end
          local.get $w59
          local.set $w60
          local.get $w60
          local.set $w56
          local.get $w55
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w55
          br $while_lp_23
        else
          br $while_lp_23_exit
        end
      end
    end
    local.get $w56
    local.set $w61
    ref.null $ListBase
    local.set $w62
    block $while_lp_24_exit
      loop $while_lp_24
        local.get $w61
        ref.is_null
        i32.eqz
        if
          local.get $w61
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w62
          struct.new $ListCons_22
          local.set $w62
          local.get $w61
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w61
          br $while_lp_24
        else
          br $while_lp_24_exit
        end
      end
    end
    local.get $w62
    local.set $collected
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w63
    ref.null $ListBase
    local.set $w64
    block $while_lp_25_exit
      loop $while_lp_25
        local.get $w63
        ref.is_null
        i32.eqz
        if
          local.get $w63
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_6
          local.get $x_6
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if (result (ref null $Option_23))
            local.get $x_6
            i32.const 2
            i32.div_s
            i32.const -1
            i32.xor
            i32.const -1
            i32.xor
            struct.new $Option_23
          else
            ref.null $Option_23
          end
          local.set $cho_opt_1
          local.get $cho_opt_1
          ref.is_null
          i32.eqz
          if (result (ref null $ListBase))
            local.get $cho_opt_1
            ref.cast (ref $Option_23)
            struct.get $Option_23 0
            local.get $w64
            struct.new $ListCons_22
          else
            local.get $w64
          end
          local.set $w64
          local.get $w63
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w63
          br $while_lp_25
        else
          br $while_lp_25_exit
        end
      end
    end
    local.get $w64
    local.set $w65
    ref.null $ListBase
    local.set $w66
    block $while_lp_26_exit
      loop $while_lp_26
        local.get $w65
        ref.is_null
        i32.eqz
        if
          local.get $w65
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w66
          struct.new $ListCons_22
          local.set $w66
          local.get $w65
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w65
          br $while_lp_26
        else
          br $while_lp_26_exit
        end
      end
    end
    local.get $w66
    local.set $chosen
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $closure_92 (param $self (ref $AnyFn)) (param $x_7 i32) (param $y i32) (result i32)
    local.get $x_7
    local.get $y
    i32.eq
  )
  (func $closure_93 (param $self (ref $AnyFn)) (param $x_8 i32) (param $y_1 i32) (result i32)
    local.get $x_8
    local.get $y_1
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_8
      local.get $y_1
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $closure_94 (param $self (ref $AnyFn)) (param $x_9 i32) (param $y_2 i32) (result i32)
    local.get $x_9
    local.get $y_2
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_9
      local.get $y_2
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
  )
  (func $body_13_92 (param $self (ref $AnyFn))
    (local $xs_3 (ref null $ListBase))
    (local $w67 i32)
    (local $w68 (ref null $ListBase))
    (local $w70 (ref $ListCons_22))
    (local $w71 i32)
    (local $w72 (ref null $ListBase))
    (local $w73 i32)
    (local $w75 (ref $ListCons_22))
    (local $w76 i32)
    (local $w77 (ref null $ListBase))
    (local $w78 i32)
    i32.const 4
    i32.const 1
    i32.const 9
    i32.const 2
    i32.const 7
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $xs_3
    i32.const 9
    local.set $w67
    local.get $xs_3
    local.set $w68
    block $lcont_exit_1 (result i32)
      block $lcont_lp_2_exit
        loop $lcont_lp_2
          local.get $w68
          ref.is_null
          i32.eqz
          if
            local.get $w68
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 0
            local.get $w67
            i32.eq
            if
              i32.const 1
              br $lcont_exit_1
            end
            local.get $w68
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 1
            local.set $w68
          else
            br $lcont_lp_2_exit
          end
          br $lcont_lp_2
        end
      end
      i32.const 0
    end
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 116
    i32.const 97
    i32.const 105
    i32.const 110
    i32.const 115
    i32.const 32
    i32.const 57
    array.new_fixed $WasmStr 10
    call $isTrue
    local.get $xs_3
    ref.cast (ref $ListCons_22)
    local.set $w70
    local.get $w70
    struct.get $ListCons_22 0
    local.set $w71
    local.get $w70
    struct.get $ListCons_22 1
    local.set $w72
    block $while_lp_27_exit
      loop $while_lp_27
        local.get $w72
        ref.is_null
        i32.eqz
        if
          local.get $w72
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $w73
          local.get $w73
          local.get $w71
          i32.lt_s
          if
            local.get $w73
            local.set $w71
          end
          local.get $w72
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w72
          br $while_lp_27
        else
          br $while_lp_27_exit
        end
      end
    end
    local.get $w71
    i32.const 1
    i32.const 109
    i32.const 105
    i32.const 110
    array.new_fixed $WasmStr 3
    call $equal
    local.get $xs_3
    ref.cast (ref $ListCons_22)
    local.set $w75
    local.get $w75
    struct.get $ListCons_22 0
    local.set $w76
    local.get $w75
    struct.get $ListCons_22 1
    local.set $w77
    block $while_lp_28_exit
      loop $while_lp_28
        local.get $w77
        ref.is_null
        i32.eqz
        if
          local.get $w77
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $w78
          local.get $w78
          local.get $w76
          i32.gt_s
          if
            local.get $w78
            local.set $w76
          end
          local.get $w77
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w77
          br $while_lp_28
        else
          br $while_lp_28_exit
        end
      end
    end
    local.get $w76
    i32.const 9
    i32.const 109
    i32.const 97
    i32.const 120
    array.new_fixed $WasmStr 3
    call $equal
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $body_14_96 (param $self (ref $AnyFn))
    (local $arr (ref $GcArray_96))
    i32.const 0
    i32.const 3
    array.new $GcArray_96
    local.set $arr
    local.get $arr
    i32.const 0
    i32.const 5
    array.set $GcArray_96
    local.get $arr
    i32.const 1
    i32.const 6
    array.set $GcArray_96
    local.get $arr
    i32.const 2
    i32.const 7
    array.set $GcArray_96
    local.get $arr
    i32.const 0
    array.get $GcArray_96
    i32.const 5
    i32.const 105
    i32.const 100
    i32.const 120
    i32.const 48
    array.new_fixed $WasmStr 4
    call $equal
    local.get $arr
    i32.const 2
    array.get $GcArray_96
    i32.const 7
    i32.const 105
    i32.const 100
    i32.const 120
    i32.const 50
    array.new_fixed $WasmStr 4
    call $equal
    local.get $arr
    array.len
    i32.const 3
    i32.const 108
    i32.const 101
    i32.const 110
    i32.const 103
    i32.const 116
    i32.const 104
    array.new_fixed $WasmStr 6
    call $equal
  )
  (func $closure_98 (param $self (ref $AnyFn)) (param $x_12 i32) (param $y_3 i32) (result i32)
    local.get $x_12
    local.get $y_3
    i32.add
  )
  (func $closure_99 (param $self (ref $AnyFn)) (param $x_11 i32) (result i32)
    local.get $x_11
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $closure_100 (param $self (ref $AnyFn)) (param $x_10 i32) (result i32)
    local.get $x_10
    i32.const 1
    i32.add
  )
  (func $closure_101 (param $self (ref $AnyFn)) (param $x_10 i32) (result i32)
    local.get $x_10
    i32.const 1
    i32.add
  )
  (func $body_15_98 (param $self (ref $AnyFn))
    (local $w93 (ref $GcArray_96))
    (local $w89 i32)
    (local $w84 (ref $GcArray_96))
    (local $w85 i32)
    (local $w86 (ref $GcArray_96))
    (local $w88 i32)
    (local $x_10 i32)
    (local $w90 i32)
    (local $w91 i32)
    (local $x_11 i32)
    (local $w92 i32)
    (local $w94 i32)
    (local $w95 i32)
    (local $w96 i32)
    (local $y_3 i32)
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_96 5
    local.set $w84
    local.get $w84
    array.len
    local.set $w85
    i32.const 0
    local.get $w85
    array.new $GcArray_96
    local.set $w86
    i32.const 0
    local.set $w88
    block $while_lp_30_exit
      loop $while_lp_30
        local.get $w88
        local.get $w85
        i32.lt_s
        if
          local.get $w86
          local.get $w88
          local.get $w84
          local.get $w88
          array.get $GcArray_96
          local.set $x_10
          local.get $x_10
          i32.const 1
          i32.add
          array.set $GcArray_96
          local.get $w88
          i32.const 1
          i32.add
          local.set $w88
          br $while_lp_30
        else
          br $while_lp_30_exit
        end
      end
    end
    local.get $w86
    array.len
    local.set $w89
    i32.const 0
    local.set $w90
    i32.const 0
    local.set $w91
    block $while_lp_31_exit
      loop $while_lp_31
        local.get $w91
        local.get $w89
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_96 5
          local.set $w84
          local.get $w84
          array.len
          local.set $w85
          i32.const 0
          local.get $w85
          array.new $GcArray_96
          local.set $w86
          i32.const 0
          local.set $w88
          block $while_lp_30_exit
            loop $while_lp_30
              local.get $w88
              local.get $w85
              i32.lt_s
              if
                local.get $w86
                local.get $w88
                local.get $w84
                local.get $w88
                array.get $GcArray_96
                local.set $x_10
                local.get $x_10
                i32.const 1
                i32.add
                array.set $GcArray_96
                local.get $w88
                i32.const 1
                i32.add
                local.set $w88
                br $while_lp_30
              else
                br $while_lp_30_exit
              end
            end
          end
          local.get $w86
          local.get $w91
          array.get $GcArray_96
          local.set $x_11
          local.get $x_11
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
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
          br $while_lp_31
        else
          br $while_lp_31_exit
        end
      end
    end
    i32.const 0
    local.set $w92
    i32.const 0
    local.set $w91
    block $while_lp_32_exit
      loop $while_lp_32
        local.get $w91
        local.get $w89
        i32.lt_s
        if
          i32.const 1
          i32.const 2
          i32.const 3
          i32.const 4
          i32.const 5
          array.new_fixed $GcArray_96 5
          local.set $w84
          local.get $w84
          array.len
          local.set $w85
          i32.const 0
          local.get $w85
          array.new $GcArray_96
          local.set $w86
          i32.const 0
          local.set $w88
          block $while_lp_30_exit
            loop $while_lp_30
              local.get $w88
              local.get $w85
              i32.lt_s
              if
                local.get $w86
                local.get $w88
                local.get $w84
                local.get $w88
                array.get $GcArray_96
                local.set $x_10
                local.get $x_10
                i32.const 1
                i32.add
                array.set $GcArray_96
                local.get $w88
                i32.const 1
                i32.add
                local.set $w88
                br $while_lp_30
              else
                br $while_lp_30_exit
              end
            end
          end
          local.get $w86
          local.get $w91
          array.get $GcArray_96
          local.set $x_11
          local.get $x_11
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            i32.const 0
            local.get $w90
            array.new $GcArray_96
            local.get $w92
            i32.const 1
            i32.const 2
            i32.const 3
            i32.const 4
            i32.const 5
            array.new_fixed $GcArray_96 5
            local.set $w84
            local.get $w84
            array.len
            local.set $w85
            i32.const 0
            local.get $w85
            array.new $GcArray_96
            local.set $w86
            i32.const 0
            local.set $w88
            block $while_lp_30_exit
              loop $while_lp_30
                local.get $w88
                local.get $w85
                i32.lt_s
                if
                  local.get $w86
                  local.get $w88
                  local.get $w84
                  local.get $w88
                  array.get $GcArray_96
                  local.set $x_10
                  local.get $x_10
                  i32.const 1
                  i32.add
                  array.set $GcArray_96
                  local.get $w88
                  i32.const 1
                  i32.add
                  local.set $w88
                  br $while_lp_30
                else
                  br $while_lp_30_exit
                end
              end
            end
            local.get $w86
            local.get $w91
            array.get $GcArray_96
            array.set $GcArray_96
            local.get $w92
            i32.const 1
            i32.add
            local.set $w92
          end
          local.get $w91
          i32.const 1
          i32.add
          local.set $w91
          br $while_lp_32
        else
          br $while_lp_32_exit
        end
      end
    end
    i32.const 0
    local.get $w90
    array.new $GcArray_96
    local.set $w93
    local.get $w93
    array.len
    local.set $w94
    i32.const 0
    local.set $w95
    i32.const 0
    local.set $w96
    block $while_lp_33_exit
      loop $while_lp_33
        local.get $w96
        local.get $w94
        i32.lt_s
        if
          local.get $w93
          local.get $w96
          array.get $GcArray_96
          local.set $y_3
          local.get $w95
          local.get $y_3
          i32.add
          local.set $w95
          local.get $w96
          i32.const 1
          i32.add
          local.set $w96
          br $while_lp_33
        else
          br $while_lp_33_exit
        end
      end
    end
    local.get $w95
    i32.const 12
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 4
    call $equal
  )
  (func $body_16_103 (param $self (ref $AnyFn))
    (local $r_1 (ref $GcArray_96))
    (local $w105 (ref $GcArray_96))
    (local $w101 (ref $GcArray_96))
    (local $w102 (ref $GcArray_96))
    (local $w103 i32)
    (local $w104 (ref $GcArray_96))
    (local $w106 i32)
    (local $w107 (ref $GcArray_96))
    (local $for_lp_1_i i32)
    i32.const 1
    i32.const 2
    array.new_fixed $GcArray_96 2
    local.set $w101
    i32.const 3
    i32.const 4
    i32.const 5
    array.new_fixed $GcArray_96 3
    local.set $w102
    local.get $w101
    array.len
    local.set $w103
    i32.const 0
    local.get $w103
    local.get $w102
    array.len
    i32.add
    array.new $GcArray_96
    local.set $w104
    local.get $w104
    i32.const 0
    local.get $w101
    i32.const 0
    local.get $w103
    array.copy $GcArray_96 $GcArray_96
    local.get $w104
    local.get $w103
    local.get $w102
    i32.const 0
    local.get $w102
    array.len
    array.copy $GcArray_96 $GcArray_96
    local.get $w104
    local.set $w105
    local.get $w105
    array.len
    local.set $w106
    i32.const 0
    local.get $w106
    array.new $GcArray_96
    local.set $w107
    i32.const 0
    local.set $for_lp_1_i
    block $for_lp_1_exit
      loop $for_lp_1
        local.get $for_lp_1_i
        local.get $w106
        i32.lt_s
        if
          local.get $w107
          local.get $for_lp_1_i
          local.get $w105
          local.get $w106
          i32.const 1
          i32.sub
          local.get $for_lp_1_i
          i32.sub
          array.get $GcArray_96
          array.set $GcArray_96
          local.get $for_lp_1_i
          i32.const 1
          i32.add
          local.set $for_lp_1_i
          br $for_lp_1
        else
          br $for_lp_1_exit
        end
      end
    end
    local.get $w107
    local.set $r_1
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $body_17_104 (param $self (ref $AnyFn))
    (local $acc_1 i32)
    (local $i i32)
    (local $limit i32)
    i32.const 0
    local.set $acc_1
    i32.const 1
    local.set $i
    i32.const 5
    local.set $limit
    loop $for
      local.get $i
      local.get $limit
      i32.le_s
      if
        local.get $acc_1
        local.get $i
        i32.add
        local.set $acc_1
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $for
      end
    end
    local.get $acc_1
    i32.const 15
    i32.const 115
    i32.const 117
    i32.const 109
    i32.const 32
    i32.const 49
    i32.const 46
    i32.const 46
    i32.const 53
    array.new_fixed $WasmStr 8
    call $equal
  )
  (func $add10_105 (param $self (ref $AnyFn)) (param $b_3 i32) (result i32)
    i32.const 10
    local.get $b_3
    i32.add
  )
  (func $body_18_105 (param $self (ref $AnyFn))
    (local $values (ref null $ListBase))
    (local $w110 (ref null $ListBase))
    (local $w108 (ref null $ListBase))
    (local $w109 (ref null $ListBase))
    (local $b_3 i32)
    (local $w111 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w108
    ref.null $ListBase
    local.set $w109
    block $while_lp_34_exit
      loop $while_lp_34
        local.get $w108
        ref.is_null
        i32.eqz
        if
          local.get $w108
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $b_3
          i32.const 10
          local.get $b_3
          i32.add
          local.get $w109
          struct.new $ListCons_22
          local.set $w109
          local.get $w108
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w108
          br $while_lp_34
        else
          br $while_lp_34_exit
        end
      end
    end
    local.get $w109
    local.set $w110
    ref.null $ListBase
    local.set $w111
    block $while_lp_35_exit
      loop $while_lp_35
        local.get $w110
        ref.is_null
        i32.eqz
        if
          local.get $w110
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w111
          struct.new $ListCons_22
          local.set $w111
          local.get $w110
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w110
          br $while_lp_35
        else
          br $while_lp_35_exit
        end
      end
    end
    local.get $w111
    local.set $values
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
  )
  (func $tests (result (ref $Wasmecto_Test)) ;; exported as "tests"
    i32.const 85
    i32.const 110
    i32.const 105
    i32.const 116
    i32.const 47
    i32.const 76
    i32.const 97
    i32.const 110
    i32.const 103
    i32.const 117
    i32.const 97
    i32.const 103
    i32.const 101
    i32.const 65
    i32.const 110
    i32.const 100
    i32.const 67
    i32.const 111
    i32.const 108
    i32.const 108
    i32.const 101
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 115
    array.new_fixed $WasmStr 27
    i32.const 105
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 103
    i32.const 101
    i32.const 114
    i32.const 115
    i32.const 58
    i32.const 32
    i32.const 97
    i32.const 114
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 109
    i32.const 101
    i32.const 116
    i32.const 105
    i32.const 99
    i32.const 32
    i32.const 98
    i32.const 97
    i32.const 115
    i32.const 105
    i32.const 99
    i32.const 115
    array.new_fixed $WasmStr 27
    ref.func $body_45
    struct.new $ClosureType_45
    call $testCase
    i32.const 98
    i32.const 111
    i32.const 111
    i32.const 108
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 105
    i32.const 102
    i32.const 47
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 102
    i32.const 47
    i32.const 101
    i32.const 108
    i32.const 115
    i32.const 101
    array.new_fixed $WasmStr 19
    ref.func $body_1_46
    struct.new $ClosureType_49
    call $testCase
    i32.const 109
    i32.const 97
    i32.const 116
    i32.const 99
    i32.const 104
    i32.const 32
    i32.const 101
    i32.const 120
    i32.const 112
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 115
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 103
    i32.const 117
    i32.const 97
    i32.const 114
    i32.const 100
    i32.const 115
    array.new_fixed $WasmStr 28
    ref.func $body_2_50
    struct.new $ClosureType_53
    call $testCase
    i32.const 116
    i32.const 117
    i32.const 112
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 114
    i32.const 101
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 100
    i32.const 101
    i32.const 115
    i32.const 116
    i32.const 114
    i32.const 117
    i32.const 99
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    array.new_fixed $WasmStr 32
    ref.func $body_3_54
    struct.new $ClosureType_55
    call $testCase
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 100
    i32.const 32
    i32.const 99
    i32.const 114
    i32.const 101
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 102
    i32.const 105
    i32.const 101
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 97
    i32.const 100
    array.new_fixed $WasmStr 30
    ref.func $body_4_56
    struct.new $ClosureType_56
    call $testCase
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 100
    i32.const 32
    i32.const 117
    i32.const 112
    i32.const 100
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 121
    i32.const 110
    i32.const 116
    i32.const 97
    i32.const 120
    array.new_fixed $WasmStr 20
    ref.func $body_5_57
    struct.new $ClosureType_57
    call $testCase
    i32.const 100
    i32.const 105
    i32.const 115
    i32.const 99
    i32.const 114
    i32.const 105
    i32.const 109
    i32.const 105
    i32.const 110
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 117
    i32.const 110
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 112
    i32.const 97
    i32.const 116
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 110
    i32.const 32
    i32.const 109
    i32.const 97
    i32.const 116
    i32.const 99
    i32.const 104
    i32.const 105
    i32.const 110
    i32.const 103
    array.new_fixed $WasmStr 36
    ref.func $body_6_58
    struct.new $ClosureType_58
    call $testCase
    i32.const 111
    i32.const 112
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 98
    i32.const 97
    i32.const 115
    i32.const 105
    i32.const 99
    i32.const 32
    i32.const 83
    i32.const 111
    i32.const 109
    i32.const 101
    i32.const 47
    i32.const 78
    i32.const 111
    i32.const 110
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 108
    i32.const 111
    i32.const 119
    array.new_fixed $WasmStr 27
    ref.func $body_7_59
    struct.new $ClosureType_62
    call $testCase
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 32
    i32.const 98
    i32.const 97
    i32.const 115
    i32.const 105
    i32.const 99
    i32.const 32
    i32.const 79
    i32.const 107
    i32.const 47
    i32.const 69
    i32.const 114
    i32.const 114
    i32.const 111
    i32.const 114
    i32.const 32
    i32.const 102
    i32.const 108
    i32.const 111
    i32.const 119
    array.new_fixed $WasmStr 26
    ref.func $body_8_63
    struct.new $ClosureType_72
    call $testCase
    i32.const 115
    i32.const 116
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 108
    i32.const 101
    i32.const 110
    i32.const 103
    i32.const 116
    i32.const 104
    array.new_fixed $WasmStr 24
    ref.func $body_9_73
    struct.new $ClosureType_73
    call $testCase
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 58
    i32.const 32
    i32.const 104
    i32.const 101
    i32.const 97
    i32.const 100
    i32.const 47
    i32.const 116
    i32.const 97
    i32.const 105
    i32.const 108
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 112
    i32.const 97
    i32.const 116
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 110
    i32.const 32
    i32.const 109
    i32.const 97
    i32.const 116
    i32.const 99
    i32.const 104
    array.new_fixed $WasmStr 33
    ref.func $body_10_74
    struct.new $ClosureType_74
    call $testCase
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 58
    i32.const 32
    i32.const 109
    i32.const 97
    i32.const 112
    i32.const 47
    i32.const 102
    i32.const 105
    i32.const 108
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 47
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 21
    ref.func $body_11_75
    struct.new $ClosureType_84
    call $testCase
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 58
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 108
    i32.const 108
    i32.const 101
    i32.const 99
    i32.const 116
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 99
    i32.const 104
    i32.const 111
    i32.const 111
    i32.const 115
    i32.const 101
    array.new_fixed $WasmStr 24
    ref.func $body_12_85
    struct.new $ClosureType_91
    call $testCase
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 58
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 116
    i32.const 97
    i32.const 105
    i32.const 110
    i32.const 115
    i32.const 47
    i32.const 109
    i32.const 105
    i32.const 110
    i32.const 47
    i32.const 109
    i32.const 97
    i32.const 120
    i32.const 47
    i32.const 115
    i32.const 111
    i32.const 114
    i32.const 116
    array.new_fixed $WasmStr 27
    ref.func $body_13_92
    struct.new $ClosureType_95
    call $testCase
    i32.const 97
    i32.const 114
    i32.const 114
    i32.const 97
    i32.const 121
    i32.const 58
    i32.const 32
    i32.const 99
    i32.const 114
    i32.const 101
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 44
    i32.const 32
    i32.const 115
    i32.const 101
    i32.const 116
    i32.const 44
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 120
    i32.const 44
    i32.const 32
    i32.const 108
    i32.const 101
    i32.const 110
    i32.const 103
    i32.const 116
    i32.const 104
    array.new_fixed $WasmStr 33
    ref.func $body_14_96
    struct.new $ClosureType_97
    call $testCase
    i32.const 97
    i32.const 114
    i32.const 114
    i32.const 97
    i32.const 121
    i32.const 58
    i32.const 32
    i32.const 109
    i32.const 97
    i32.const 112
    i32.const 47
    i32.const 102
    i32.const 105
    i32.const 108
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 47
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 22
    ref.func $body_15_98
    struct.new $ClosureType_102
    call $testCase
    i32.const 97
    i32.const 114
    i32.const 114
    i32.const 97
    i32.const 121
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 118
    i32.const 32
    i32.const 98
    i32.const 97
    i32.const 115
    i32.const 105
    i32.const 99
    i32.const 115
    array.new_fixed $WasmStr 25
    ref.func $body_16_103
    struct.new $ClosureType_103
    call $testCase
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 98
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 108
    i32.const 111
    i32.const 111
    i32.const 112
    array.new_fixed $WasmStr 23
    ref.func $body_17_104
    struct.new $ClosureType_104
    call $testCase
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 112
    i32.const 97
    i32.const 114
    i32.const 116
    i32.const 105
    i32.const 97
    i32.const 108
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 39
    ref.func $body_18_105
    struct.new $ClosureType_106
    call $testCase
    ref.null $ListBase
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    return_call $testList
  )
  (func $collect (param $n i32) (param $f (ref $AnyFn)) (result (ref null $ListBase)) ;; exported as "collect"
    (local $acc (ref null $ListBase))
    (local $i i32)
    (local $limit i32)
    (local $lo_clo_48 (ref $ClosureBase_47))
    ref.null $ListBase
    local.set $acc
    local.get $n
    i32.const 1
    i32.sub
    local.set $i
    i32.const 0
    local.set $limit
    loop $for
      local.get $i
      local.get $limit
      i32.ge_s
      if
        local.get $f
        ref.cast (ref $ClosureBase_47)
        local.set $lo_clo_48
        local.get $lo_clo_48
        local.get $i
        local.get $lo_clo_48
        struct.get $ClosureBase_47 0
        call_ref $FuncType_46
        local.get $acc
        struct.new $ListCons_22
        local.set $acc
        local.get $i
        i32.const 1
        i32.sub
        local.set $i
        br $for
      end
    end
    local.get $acc
  )
  (func $iterate (param $n i32) (param $f (ref $AnyFn)) (param $seed i32) (result i32) ;; exported as "iterate"
    (local $v i32)
    (local $forLoopVar i32)
    (local $lo_clo_49 (ref $ClosureBase_47))
    local.get $seed
    local.set $v
    i32.const 1
    local.set $forLoopVar
    loop $for
      local.get $forLoopVar
      local.get $n
      i32.le_s
      if
        local.get $f
        ref.cast (ref $ClosureBase_47)
        local.set $lo_clo_49
        local.get $lo_clo_49
        local.get $v
        local.get $lo_clo_49
        struct.get $ClosureBase_47 0
        call_ref $FuncType_46
        local.set $v
        local.get $forLoopVar
        i32.const 1
        i32.add
        local.set $forLoopVar
        br $for
      end
    end
    local.get $v
  )
  (func $body_115 (param $self (ref $AnyFn))
    i32.const 42
    i32.const 42
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 101
    i32.const 100
    i32.const 45
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 97
    i32.const 99
    i32.const 99
    i32.const 101
    i32.const 115
    i32.const 115
    i32.const 105
    i32.const 98
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 29
    call $equal
  )
  (func $body_1_116 (param $self (ref $AnyFn))
    f64.const 10
    f64.const 10
    f64.const 9.9999999999999998e-13
    i32.const 102
    i32.const 108
    i32.const 111
    i32.const 97
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 13
    call $approxEqual
  )
  (func $body_2_117 (param $self (ref $AnyFn))
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
    i32.const 32
    i32.const 119
    i32.const 111
    i32.const 114
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 11
    i32.const 115
    i32.const 116
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 14
    call $equal
  )
  (func $body_3_118 (param $self (ref $AnyFn))
    i32.const 60
    i32.const 60
    i32.const 116
    i32.const 104
    i32.const 114
    i32.const 101
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 116
    i32.const 115
    array.new_fixed $WasmStr 19
    call $equal
  )
  (func $body_4_119 (param $self (ref $AnyFn))
    i32.const 202
    i32.const 202
    i32.const 110
    i32.const 101
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 108
    i32.const 101
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    array.new_fixed $WasmStr 19
    call $equal
  )
  (func $closure_120 (param $self (ref $AnyFn))
    (local $self_cast (ref $ClosureType_120))
    (local $counter i32)
    local.get $self
    ref.cast (ref $ClosureType_120)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_120 1
    local.set $counter
    local.get $counter
    i32.const 1
    i32.add
    local.set $counter
  )
  (func $body_5_120 (param $self (ref $AnyFn))
    (local $counter i32)
    (local $tick (ref $ClosureType_120))
    (local $lo_clo_50 (ref $ClosureBase_18))
    (local $lo_clo_51 (ref $ClosureBase_18))
    (local $lo_clo_52 (ref $ClosureBase_18))
    i32.const 0
    local.set $counter
    ref.func $closure_120
    local.get $counter
    struct.new $ClosureType_120
    local.set $tick
    local.get $tick
    ref.cast (ref $ClosureBase_18)
    local.set $lo_clo_50
    local.get $lo_clo_50
    local.get $lo_clo_50
    struct.get $ClosureBase_18 0
    call_ref $FuncType_17
    local.get $tick
    ref.cast (ref $ClosureBase_18)
    local.set $lo_clo_51
    local.get $lo_clo_51
    local.get $lo_clo_51
    struct.get $ClosureBase_18 0
    call_ref $FuncType_17
    local.get $tick
    ref.cast (ref $ClosureBase_18)
    local.set $lo_clo_52
    local.get $lo_clo_52
    local.get $lo_clo_52
    struct.get $ClosureBase_18 0
    call_ref $FuncType_17
    local.get $counter
    i32.const 3
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 118
    i32.const 105
    i32.const 97
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 27
    call $equal
  )
  (func $body_6_122 (param $self (ref $AnyFn))
    (local $x_1 i32)
    i32.const 0
    local.set $x_1
    i32.const 99
    local.set $x_1
    local.get $x_1
    i32.const 99
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 97
    i32.const 100
    i32.const 115
    i32.const 32
    i32.const 117
    i32.const 112
    i32.const 100
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 29
    call $equal
  )
  (func $closure_123 (param $self (ref $AnyFn)) (param $n i32)
    (local $self_cast (ref $ClosureType_125))
    (local $total i32)
    local.get $self
    ref.cast (ref $ClosureType_125)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_125 1
    local.set $total
    local.get $total
    local.get $n
    i32.add
    local.set $total
  )
  (func $body_7_123 (param $self (ref $AnyFn))
    (local $total i32)
    (local $add (ref $ClosureType_125))
    (local $lo_clo_53 (ref $ClosureBase_124))
    (local $lo_clo_54 (ref $ClosureBase_124))
    (local $lo_clo_55 (ref $ClosureBase_124))
    i32.const 0
    local.set $total
    ref.func $closure_123
    local.get $total
    struct.new $ClosureType_125
    local.set $add
    local.get $add
    ref.cast (ref $ClosureBase_124)
    local.set $lo_clo_53
    local.get $lo_clo_53
    i32.const 5
    local.get $lo_clo_53
    struct.get $ClosureBase_124 0
    call_ref $FuncType_123
    local.get $add
    ref.cast (ref $ClosureBase_124)
    local.set $lo_clo_54
    local.get $lo_clo_54
    i32.const 10
    local.get $lo_clo_54
    struct.get $ClosureBase_124 0
    call_ref $FuncType_123
    local.get $add
    ref.cast (ref $ClosureBase_124)
    local.set $lo_clo_55
    local.get $lo_clo_55
    i32.const 15
    local.get $lo_clo_55
    struct.get $ClosureBase_124 0
    call_ref $FuncType_123
    local.get $total
    i32.const 30
    i32.const 111
    i32.const 117
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 117
    i32.const 112
    i32.const 100
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 98
    i32.const 121
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 32
    call $equal
  )
  (func $closure_127 (param $self (ref $AnyFn))
    (local $self_cast (ref $ClosureType_127))
    (local $shared i32)
    local.get $self
    ref.cast (ref $ClosureType_127)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_127 1
    local.set $shared
    local.get $shared
    i32.const 1
    i32.add
    local.set $shared
  )
  (func $body_8_127 (param $self (ref $AnyFn))
    (local $shared i32)
    (local $inc (ref $ClosureType_127))
    (local $lo_clo_56 (ref $ClosureBase_18))
    (local $lo_clo_57 (ref $ClosureBase_18))
    (local $lo_clo_58 (ref $ClosureBase_18))
    i32.const 0
    local.set $shared
    ref.func $closure_127
    local.get $shared
    struct.new $ClosureType_127
    local.set $inc
    local.get $inc
    ref.cast (ref $ClosureBase_18)
    local.set $lo_clo_56
    local.get $lo_clo_56
    local.get $lo_clo_56
    struct.get $ClosureBase_18 0
    call_ref $FuncType_17
    local.get $inc
    ref.cast (ref $ClosureBase_18)
    local.set $lo_clo_57
    local.get $lo_clo_57
    local.get $lo_clo_57
    struct.get $ClosureBase_18 0
    call_ref $FuncType_17
    local.get $inc
    ref.cast (ref $ClosureBase_18)
    local.set $lo_clo_58
    local.get $lo_clo_58
    local.get $lo_clo_58
    struct.get $ClosureBase_18 0
    call_ref $FuncType_17
    local.get $shared
    i32.const 1
    i32.sub
    local.set $shared
    local.get $shared
    i32.const 2
    i32.const 116
    i32.const 119
    i32.const 111
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 97
    i32.const 109
    i32.const 101
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 102
    i32.const 32
    i32.const 99
    i32.const 101
    i32.const 108
    i32.const 108
    array.new_fixed $WasmStr 33
    call $equal
  )
  (func $closure_129 (param $self (ref $AnyFn)) (param $c_1 (ref $WasmStr))
    (local $self_cast (ref $ClosureType_130))
    (local $s (ref $WasmStr))
    local.get $self
    ref.cast (ref $ClosureType_130)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_130 1
    local.set $s
    local.get $s
    local.get $c_1
    call $strConcat
    local.set $s
  )
  (func $body_9_129 (param $self (ref $AnyFn))
    (local $s (ref $WasmStr))
    (local $append (ref $ClosureType_130))
    (local $lo_clo_59 (ref $ClosureBase_129))
    (local $lo_clo_60 (ref $ClosureBase_129))
    i32.const 97
    array.new_fixed $WasmStr 1
    local.set $s
    ref.func $closure_129
    local.get $s
    struct.new $ClosureType_130
    local.set $append
    local.get $append
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_59
    local.get $lo_clo_59
    i32.const 98
    array.new_fixed $WasmStr 1
    local.get $lo_clo_59
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    local.get $append
    ref.cast (ref $ClosureBase_129)
    local.set $lo_clo_60
    local.get $lo_clo_60
    i32.const 99
    array.new_fixed $WasmStr 1
    local.get $lo_clo_60
    struct.get $ClosureBase_129 0
    call_ref $FuncType_35
    local.get $s
    i32.const 97
    i32.const 98
    i32.const 99
    array.new_fixed $WasmStr 3
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 22
    call $equal
  )
  (func $closure_132 (param $self (ref $AnyFn)) (param $n_1 i32) (param $x_2 i32) (result i32)
    local.get $x_2
    local.get $n_1
    i32.add
  )
  (func $closure_133 (param $self (ref $AnyFn)) (param $a0 i32) (result i32)
    (local $self_cast (ref $ClosureType_133))
    (local $makeAdder (ref $AnyFn))
    (local $lo_clo_61 (ref $ClosureBase_76))
    local.get $self
    ref.cast (ref $ClosureType_133)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_133 1
    local.set $makeAdder
    local.get $makeAdder
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_61
    local.get $lo_clo_61
    i32.const 5
    local.get $a0
    local.get $lo_clo_61
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
  )
  (func $closure_134 (param $self (ref $AnyFn)) (param $a0 i32) (result i32)
    (local $self_cast (ref $ClosureType_134))
    (local $makeAdder (ref $AnyFn))
    (local $lo_clo_62 (ref $ClosureBase_76))
    local.get $self
    ref.cast (ref $ClosureType_134)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_134 1
    local.set $makeAdder
    local.get $makeAdder
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_62
    local.get $lo_clo_62
    i32.const 10
    local.get $a0
    local.get $lo_clo_62
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
  )
  (func $body_10_132 (param $self (ref $AnyFn))
    (local $makeAdder (ref $ClosureType_132))
    (local $add5 (ref $ClosureType_133))
    (local $add10 (ref $ClosureType_134))
    (local $lo_clo_63 (ref $ClosureBase_47))
    (local $lo_clo_64 (ref $ClosureBase_47))
    (local $lo_clo_65 (ref $ClosureBase_47))
    ref.func $closure_132
    struct.new $ClosureType_132
    local.set $makeAdder
    ref.func $closure_133
    local.get $makeAdder
    struct.new $ClosureType_133
    local.set $add5
    ref.func $closure_134
    local.get $makeAdder
    struct.new $ClosureType_134
    local.set $add10
    local.get $add5
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_63
    local.get $lo_clo_63
    i32.const 3
    local.get $lo_clo_63
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 8
    i32.const 97
    i32.const 100
    i32.const 100
    i32.const 53
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 110
    i32.const 115
    i32.const 32
    i32.const 56
    array.new_fixed $WasmStr 14
    call $equal
    local.get $add10
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_64
    local.get $lo_clo_64
    i32.const 3
    local.get $lo_clo_64
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 13
    i32.const 97
    i32.const 100
    i32.const 100
    i32.const 49
    i32.const 48
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 110
    i32.const 115
    i32.const 32
    i32.const 49
    i32.const 51
    array.new_fixed $WasmStr 16
    call $equal
    local.get $add5
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_65
    local.get $lo_clo_65
    i32.const 0
    local.get $lo_clo_65
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 5
    i32.const 97
    i32.const 100
    i32.const 100
    i32.const 53
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 111
    i32.const 102
    i32.const 32
    i32.const 97
    i32.const 100
    i32.const 100
    i32.const 49
    i32.const 48
    array.new_fixed $WasmStr 28
    call $equal
  )
  (func $closure_136 (param $self (ref $AnyFn)) (param $factor f64) (param $x_3 f64) (result f64)
    local.get $x_3
    local.get $factor
    f64.mul
  )
  (func $closure_139 (param $self (ref $AnyFn)) (param $a0 f64) (result f64)
    (local $self_cast (ref $ClosureType_141))
    (local $makeScaler (ref $AnyFn))
    (local $lo_clo_66 (ref $ClosureBase_137))
    local.get $self
    ref.cast (ref $ClosureType_141)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_141 1
    local.set $makeScaler
    local.get $makeScaler
    ref.cast (ref $ClosureBase_137)
    local.set $lo_clo_66
    local.get $lo_clo_66
    f64.const 3
    local.get $a0
    local.get $lo_clo_66
    struct.get $ClosureBase_137 0
    call_ref $FuncType_136
  )
  (func $closure_142 (param $self (ref $AnyFn)) (param $a0 f64) (result f64)
    (local $self_cast (ref $ClosureType_142))
    (local $makeScaler (ref $AnyFn))
    (local $lo_clo_67 (ref $ClosureBase_137))
    local.get $self
    ref.cast (ref $ClosureType_142)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_142 1
    local.set $makeScaler
    local.get $makeScaler
    ref.cast (ref $ClosureBase_137)
    local.set $lo_clo_67
    local.get $lo_clo_67
    f64.const 0.5
    local.get $a0
    local.get $lo_clo_67
    struct.get $ClosureBase_137 0
    call_ref $FuncType_136
  )
  (func $body_11_136 (param $self (ref $AnyFn))
    (local $makeScaler (ref $ClosureType_138))
    (local $triple (ref $ClosureType_141))
    (local $half (ref $ClosureType_142))
    (local $lo_clo_68 (ref $ClosureBase_140))
    (local $lo_clo_69 (ref $ClosureBase_140))
    ref.func $closure_136
    struct.new $ClosureType_138
    local.set $makeScaler
    ref.func $closure_139
    local.get $makeScaler
    struct.new $ClosureType_141
    local.set $triple
    ref.func $closure_142
    local.get $makeScaler
    struct.new $ClosureType_142
    local.set $half
    local.get $triple
    ref.cast (ref $ClosureBase_140)
    local.set $lo_clo_68
    local.get $lo_clo_68
    f64.const 4
    local.get $lo_clo_68
    struct.get $ClosureBase_140 0
    call_ref $FuncType_139
    f64.const 12
    f64.const 9.9999999999999998e-13
    i32.const 116
    i32.const 114
    i32.const 105
    i32.const 112
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 6
    call $approxEqual
    local.get $half
    ref.cast (ref $ClosureBase_140)
    local.set $lo_clo_69
    local.get $lo_clo_69
    f64.const 9
    local.get $lo_clo_69
    struct.get $ClosureBase_140 0
    call_ref $FuncType_139
    f64.const 4.5
    f64.const 9.9999999999999998e-13
    i32.const 104
    i32.const 97
    i32.const 108
    i32.const 102
    array.new_fixed $WasmStr 4
    call $approxEqual
  )
  (func $closure_144 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_146))
    (local $n_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_146)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_146 1
    local.set $n_2
    local.get $n_2
    i32.const 1
    i32.add
    local.set $n_2
    local.get $n_2
  )
  (func $closure_144 (param $self (ref $AnyFn)) (result (ref $AnyFn))
    (local $n_2 i32)
    i32.const 0
    local.set $n_2
    ref.func $closure_144
    local.get $n_2
    struct.new $ClosureType_146
  )
  (func $body_12_144 (param $self (ref $AnyFn))
    (local $makeCounter (ref $ClosureType_149))
    (local $c1 (ref $AnyFn))
    (local $lo_clo_70 (ref $ClosureBase_148))
    (local $c2 (ref $AnyFn))
    (local $lo_clo_71 (ref $ClosureBase_148))
    (local $lo_clo_72 (ref $ClosureBase_145))
    (local $lo_clo_73 (ref $ClosureBase_145))
    (local $lo_clo_74 (ref $ClosureBase_145))
    (local $lo_clo_75 (ref $ClosureBase_145))
    ref.func $closure_144
    struct.new $ClosureType_149
    local.set $makeCounter
    local.get $makeCounter
    ref.cast (ref $ClosureBase_148)
    local.set $lo_clo_70
    local.get $lo_clo_70
    local.get $lo_clo_70
    struct.get $ClosureBase_148 0
    call_ref $FuncType_147
    local.set $c1
    local.get $makeCounter
    ref.cast (ref $ClosureBase_148)
    local.set $lo_clo_71
    local.get $lo_clo_71
    local.get $lo_clo_71
    struct.get $ClosureBase_148 0
    call_ref $FuncType_147
    local.set $c2
    local.get $c1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_72
    local.get $lo_clo_72
    local.get $lo_clo_72
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 1
    i32.const 99
    i32.const 49
    i32.const 32
    i32.const 102
    i32.const 105
    i32.const 114
    i32.const 115
    i32.const 116
    i32.const 32
    i32.const 116
    i32.const 105
    i32.const 99
    i32.const 107
    array.new_fixed $WasmStr 13
    call $equal
    local.get $c1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_73
    local.get $lo_clo_73
    local.get $lo_clo_73
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 2
    i32.const 99
    i32.const 49
    i32.const 32
    i32.const 115
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 116
    i32.const 105
    i32.const 99
    i32.const 107
    array.new_fixed $WasmStr 14
    call $equal
    local.get $c2
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_74
    local.get $lo_clo_74
    local.get $lo_clo_74
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 1
    i32.const 99
    i32.const 50
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 102
    i32.const 114
    i32.const 111
    i32.const 109
    i32.const 32
    i32.const 99
    i32.const 49
    array.new_fixed $WasmStr 22
    call $equal
    local.get $c1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_75
    local.get $lo_clo_75
    local.get $lo_clo_75
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 3
    i32.const 99
    i32.const 49
    i32.const 32
    i32.const 116
    i32.const 104
    i32.const 105
    i32.const 114
    i32.const 100
    i32.const 32
    i32.const 116
    i32.const 105
    i32.const 99
    i32.const 107
    array.new_fixed $WasmStr 13
    call $equal
  )
  (func $closure_151 (param $self (ref $AnyFn)) (param $n_3 i32) (result i32)
    (local $self_cast (ref $ClosureType_151))
    (local $total_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_151)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_151 1
    local.set $total_1
    local.get $total_1
    local.get $n_3
    i32.add
    local.set $total_1
    local.get $total_1
  )
  (func $body_13_151 (param $self (ref $AnyFn))
    (local $acc (ref $ClosureType_151))
    (local $total_1 i32)
    (local $lo_clo_76 (ref $ClosureBase_47))
    (local $lo_clo_77 (ref $ClosureBase_47))
    (local $lo_clo_78 (ref $ClosureBase_47))
    i32.const 0
    local.set $total_1
    ref.func $closure_151
    local.get $total_1
    struct.new $ClosureType_151
    local.set $acc
    local.get $acc
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_76
    local.get $lo_clo_76
    i32.const 5
    local.get $lo_clo_76
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 5
    i32.const 97
    i32.const 102
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 53
    array.new_fixed $WasmStr 7
    call $equal
    local.get $acc
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_77
    local.get $lo_clo_77
    i32.const 10
    local.get $lo_clo_77
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 15
    i32.const 97
    i32.const 102
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 49
    i32.const 48
    array.new_fixed $WasmStr 8
    call $equal
    local.get $acc
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_78
    local.get $lo_clo_78
    i32.const 3
    local.get $lo_clo_78
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 18
    i32.const 97
    i32.const 102
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 51
    array.new_fixed $WasmStr 7
    call $equal
  )
  (func $closure_153 (param $self (ref $AnyFn)) (param $b_1 i32) (param $c_2 i32) (result i32)
    i32.const 1
    local.get $b_1
    i32.add
    local.get $c_2
    i32.add
  )
  (func $closure_154 (param $self (ref $AnyFn)) (param $a0 i32) (result i32)
    (local $self_cast (ref $ClosureType_154))
    (local $f_1 (ref $AnyFn))
    (local $lo_clo_79 (ref $ClosureBase_76))
    local.get $self
    ref.cast (ref $ClosureType_154)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_154 1
    local.set $f_1
    local.get $f_1
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_79
    local.get $lo_clo_79
    i32.const 2
    local.get $a0
    local.get $lo_clo_79
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
  )
  (func $body_14_153 (param $self (ref $AnyFn))
    (local $f_1 (ref $ClosureType_153))
    (local $g (ref $ClosureType_154))
    (local $lo_clo_80 (ref $ClosureBase_47))
    (local $lo_clo_81 (ref $ClosureBase_47))
    (local $lo_clo_82 (ref $ClosureBase_76))
    ref.func $closure_153
    struct.new $ClosureType_153
    local.set $f_1
    ref.func $closure_154
    local.get $f_1
    struct.new $ClosureType_154
    local.set $g
    local.get $g
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_80
    local.get $lo_clo_80
    i32.const 3
    local.get $lo_clo_80
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 6
    i32.const 49
    i32.const 43
    i32.const 50
    i32.const 43
    i32.const 51
    array.new_fixed $WasmStr 5
    call $equal
    local.get $g
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_81
    local.get $lo_clo_81
    i32.const 100
    local.get $lo_clo_81
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 103
    i32.const 49
    i32.const 43
    i32.const 50
    i32.const 43
    i32.const 49
    i32.const 48
    i32.const 48
    array.new_fixed $WasmStr 7
    call $equal
    local.get $f_1
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_82
    local.get $lo_clo_82
    i32.const 0
    i32.const 0
    local.get $lo_clo_82
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
    i32.const 1
    i32.const 49
    i32.const 43
    i32.const 48
    i32.const 43
    i32.const 48
    array.new_fixed $WasmStr 5
    call $equal
  )
  (func $closure_156 (param $self (ref $AnyFn)) (param $x_4 i32) (result i32)
    local.get $x_4
    i32.const 10
    i32.add
  )
  (func $body_15_156 (param $self (ref $AnyFn))
    (local $w114 (ref null $ListBase))
    (local $w112 (ref null $ListBase))
    (local $w113 (ref null $ListBase))
    (local $x_4 i32)
    (local $w115 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w112
    ref.null $ListBase
    local.set $w113
    block $while_lp_36_exit
      loop $while_lp_36
        local.get $w112
        ref.is_null
        i32.eqz
        if
          local.get $w112
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_4
          local.get $x_4
          i32.const 10
          i32.add
          local.get $w113
          struct.new $ListCons_22
          local.set $w113
          local.get $w112
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w112
          br $while_lp_36
        else
          br $while_lp_36_exit
        end
      end
    end
    local.get $w113
    local.set $w114
    ref.null $ListBase
    local.set $w115
    block $while_lp_37_exit
      loop $while_lp_37
        local.get $w114
        ref.is_null
        i32.eqz
        if
          local.get $w114
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w115
          struct.new $ListCons_22
          local.set $w115
          local.get $w114
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w114
          br $while_lp_37
        else
          br $while_lp_37_exit
        end
      end
    end
    local.get $w115
    i32.const 11
    i32.const 12
    i32.const 13
    i32.const 14
    i32.const 15
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 109
    i32.const 97
    i32.const 112
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 49
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 17
    call $sequenceEqual
  )
  (func $closure_158 (param $self (ref $AnyFn)) (param $x_5 i32) (result i32)
    local.get $x_5
    i32.const 3
    i32.gt_s
  )
  (func $body_16_158 (param $self (ref $AnyFn))
    (local $w118 (ref null $ListBase))
    (local $w116 (ref null $ListBase))
    (local $w117 (ref null $ListBase))
    (local $x_5 i32)
    (local $w119 (ref null $ListBase))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w116
    ref.null $ListBase
    local.set $w117
    block $while_lp_38_exit
      loop $while_lp_38
        local.get $w116
        ref.is_null
        i32.eqz
        if
          local.get $w116
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_5
          local.get $x_5
          i32.const 3
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w116
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 0
            local.get $w117
            struct.new $ListCons_22
          else
            local.get $w117
          end
          local.set $w117
          local.get $w116
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w116
          br $while_lp_38
        else
          br $while_lp_38_exit
        end
      end
    end
    local.get $w117
    local.set $w118
    ref.null $ListBase
    local.set $w119
    block $while_lp_39_exit
      loop $while_lp_39
        local.get $w118
        ref.is_null
        i32.eqz
        if
          local.get $w118
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w119
          struct.new $ListCons_22
          local.set $w119
          local.get $w118
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w118
          br $while_lp_39
        else
          br $while_lp_39_exit
        end
      end
    end
    local.get $w119
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 102
    i32.const 105
    i32.const 108
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 116
    i32.const 104
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 104
    i32.const 111
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 30
    call $sequenceEqual
  )
  (func $closure_160 (param $self (ref $AnyFn)) (param $acc_1 i32) (param $x_6 i32) (result i32)
    local.get $acc_1
    local.get $x_6
    i32.const 1
    i32.shl
    i32.add
  )
  (func $body_17_160 (param $self (ref $AnyFn))
    (local $w120 (ref null $ListBase))
    (local $w121 i32)
    (local $x_6 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w120
    i32.const 0
    local.set $w121
    block $while_lp_40_exit
      loop $while_lp_40
        local.get $w120
        ref.is_null
        i32.eqz
        if
          local.get $w120
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_6
          local.get $w121
          local.get $x_6
          i32.const 1
          i32.shl
          i32.add
          local.set $w121
          local.get $w120
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w120
          br $while_lp_40
        else
          br $while_lp_40_exit
        end
      end
    end
    local.get $w121
    i32.const 20
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 105
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 101
    i32.const 114
    i32.const 58
    i32.const 32
    i32.const 50
    i32.const 42
    i32.const 40
    i32.const 49
    i32.const 43
    i32.const 50
    i32.const 43
    i32.const 51
    i32.const 43
    i32.const 52
    i32.const 41
    i32.const 61
    i32.const 50
    i32.const 48
    array.new_fixed $WasmStr 45
    call $equal
  )
  (func $closure_162 (param $self (ref $AnyFn)) (param $x_7 i32) (result i32)
    local.get $x_7
    i32.const 7
    i32.eq
  )
  (func $body_18_162 (param $self (ref $AnyFn))
    (local $w122 (ref null $ListBase))
    (local $x_7 i32)
    i32.const 1
    i32.const 3
    i32.const 5
    i32.const 7
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w122
    block $exi_blk_5 (result i32)
      block $exi_lp_6_exit
        loop $exi_lp_6
          local.get $w122
          ref.is_null
          i32.eqz
          if
            local.get $w122
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 0
            local.set $x_7
            local.get $x_7
            i32.const 7
            i32.eq
            if
              i32.const 1
              br $exi_blk_5
            end
            local.get $w122
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 1
            local.set $w122
          else
            br $exi_lp_6_exit
          end
          br $exi_lp_6
        end
      end
      i32.const 0
    end
    i32.const 101
    i32.const 120
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 115
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 116
    i32.const 97
    i32.const 114
    i32.const 103
    i32.const 101
    i32.const 116
    array.new_fixed $WasmStr 27
    call $isTrue
  )
  (func $closure_164 (param $self (ref $AnyFn)) (param $x_8 i32) (result i32)
    local.get $x_8
    i32.const 10
    i32.lt_s
  )
  (func $body_19_164 (param $self (ref $AnyFn))
    (local $w123 (ref null $ListBase))
    (local $x_8 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w123
    block $all_blk_1 (result i32)
      block $all_lp_2_exit
        loop $all_lp_2
          local.get $w123
          ref.is_null
          i32.eqz
          if
            local.get $w123
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 0
            local.set $x_8
            local.get $x_8
            i32.const 10
            i32.lt_s
            if
              local.get $w123
              ref.cast (ref $ListCons_22)
              struct.get $ListCons_22 1
              local.set $w123
            else
              i32.const 0
              br $all_blk_1
            end
          else
            br $all_lp_2_exit
          end
          br $all_lp_2
        end
      end
      i32.const 1
    end
    i32.const 102
    i32.const 111
    i32.const 114
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 98
    i32.const 111
    i32.const 117
    i32.const 110
    i32.const 100
    array.new_fixed $WasmStr 26
    call $isTrue
  )
  (func $record_166 (param $self (ref $AnyFn)) (param $x_9 i32)
    (local $self_cast (ref $ClosureType_166))
    (local $log (ref null $ListBase))
    local.get $self
    ref.cast (ref $ClosureType_166)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_166 1
    local.set $log
    local.get $x_9
    local.get $log
    struct.new $ListCons_22
    local.set $log
  )
  (func $body_20_166 (param $self (ref $AnyFn))
    (local $log (ref null $ListBase))
    (local $w124 (ref null $ListBase))
    (local $x_9 i32)
    (local $w125 (ref null $ListBase))
    (local $w126 (ref null $ListBase))
    ref.null $ListBase
    local.set $log
    i32.const 3
    i32.const 2
    i32.const 1
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w124
    block $while_lp_41_exit
      loop $while_lp_41
        local.get $w124
        ref.is_null
        i32.eqz
        if
          local.get $w124
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_9
          local.get $x_9
          local.get $log
          struct.new $ListCons_22
          local.set $log
          local.get $w124
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w124
          br $while_lp_41
        else
          br $while_lp_41_exit
        end
      end
    end
    local.get $log
    local.set $w125
    ref.null $ListBase
    local.set $w126
    block $while_lp_42_exit
      loop $while_lp_42
        local.get $w125
        ref.is_null
        i32.eqz
        if
          local.get $w125
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w126
          struct.new $ListCons_22
          local.set $w126
          local.get $w125
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w125
          br $while_lp_42
        else
          br $while_lp_42_exit
        end
      end
    end
    local.get $w126
    i32.const 3
    i32.const 2
    i32.const 1
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 105
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 98
    i32.const 97
    i32.const 99
    i32.const 107
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    array.new_fixed $WasmStr 35
    call $sequenceEqual
  )
  (func $closure_168 (param $self (ref $AnyFn)) (param $f_2 (ref $AnyFn)) (result i32)
    (local $lo_clo_83 (ref $ClosureBase_145))
    local.get $f_2
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_83
    local.get $lo_clo_83
    local.get $lo_clo_83
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
  )
  (func $closure_172 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_172))
    (local $n_4 i32)
    local.get $self
    ref.cast (ref $ClosureType_172)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_172 1
    local.set $n_4
    local.get $n_4
    local.get $n_4
    i32.mul
  )
  (func $closure_172 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_172
    local.get $i
    struct.new $ClosureType_172
  )
  (func $closure_176 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_176))
    (local $n_4 i32)
    local.get $self
    ref.cast (ref $ClosureType_176)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_176 1
    local.set $n_4
    local.get $n_4
    local.get $n_4
    i32.mul
  )
  (func $closure_172 (param $self (ref $AnyFn)) (result i32)
    (local $w129 (ref null $ListBase))
    (local $w127 (ref null $ListBase))
    (local $w128 (ref null $ListBase))
    (local $i i32)
    (local $w130 (ref null $ListBase))
    local.set $w127
    ref.null $ListBase
    local.set $w128
    block $while_lp_43_exit
      loop $while_lp_43
        local.get $w127
        ref.is_null
        i32.eqz
        if
          local.get $w127
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $i
          ref.func $closure_176
          local.get $i
          struct.new $ClosureType_176
          local.get $w128
          struct.new $ListCons_171
          local.set $w128
          local.get $w127
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w127
          br $while_lp_43
        else
          br $while_lp_43_exit
        end
      end
    end
    local.get $w128
    local.set $w129
    ref.null $ListBase
    local.set $w130
    block $while_lp_44_exit
      loop $while_lp_44
        local.get $w129
        ref.is_null
        i32.eqz
        if
          local.get $w129
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.get $w130
          struct.new $ListCons_171
          local.set $w130
          local.get $w129
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w129
          br $while_lp_44
        else
          br $while_lp_44_exit
        end
      end
    end
    local.get $w130
  )
  (func $closure_178 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_178))
    (local $n_4 i32)
    local.get $self
    ref.cast (ref $ClosureType_178)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_178 1
    local.set $n_4
    local.get $n_4
    local.get $n_4
    i32.mul
  )
  (func $closure_178 (param $self (ref $AnyFn)) (param $i i32) (result (ref $AnyFn))
    ref.func $closure_178
    local.get $i
    struct.new $ClosureType_178
  )
  (func $closure_180 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_180))
    (local $n_4 i32)
    local.get $self
    ref.cast (ref $ClosureType_180)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_180 1
    local.set $n_4
    local.get $n_4
    local.get $n_4
    i32.mul
  )
  (func $closure_178 (param $self (ref $AnyFn)) (result i32)
    (local $w133 (ref null $ListBase))
    (local $w131 (ref null $ListBase))
    (local $w132 (ref null $ListBase))
    (local $i i32)
    (local $w134 (ref null $ListBase))
    local.set $w131
    ref.null $ListBase
    local.set $w132
    block $while_lp_45_exit
      loop $while_lp_45
        local.get $w131
        ref.is_null
        i32.eqz
        if
          local.get $w131
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $i
          ref.func $closure_180
          local.get $i
          struct.new $ClosureType_180
          local.get $w132
          struct.new $ListCons_171
          local.set $w132
          local.get $w131
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w131
          br $while_lp_45
        else
          br $while_lp_45_exit
        end
      end
    end
    local.get $w132
    local.set $w133
    ref.null $ListBase
    local.set $w134
    block $while_lp_46_exit
      loop $while_lp_46
        local.get $w133
        ref.is_null
        i32.eqz
        if
          local.get $w133
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.get $w134
          struct.new $ListCons_171
          local.set $w134
          local.get $w133
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w133
          br $while_lp_46
        else
          br $while_lp_46_exit
        end
      end
    end
    local.get $w134
  )
  (func $body_21_168 (param $self (ref $AnyFn))
    (local $w137 (ref null $ListBase))
    (local $w135 (ref null $ListBase))
    (local $w136 (ref null $ListBase))
    (local $f_2 (ref $AnyFn))
    (local $lo_clo_84 (ref $ClosureBase_145))
    (local $w138 (ref null $ListBase))
    local.set $w135
    ref.null $ListBase
    local.set $w136
    block $while_lp_47_exit
      loop $while_lp_47
        local.get $w135
        ref.is_null
        i32.eqz
        if
          local.get $w135
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.set $f_2
          local.get $f_2
          ref.cast (ref $ClosureBase_145)
          local.set $lo_clo_84
          local.get $lo_clo_84
          local.get $lo_clo_84
          struct.get $ClosureBase_145 0
          call_ref $FuncType_144
          local.get $w136
          struct.new $ListCons_22
          local.set $w136
          local.get $w135
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w135
          br $while_lp_47
        else
          br $while_lp_47_exit
        end
      end
    end
    local.get $w136
    local.set $w137
    ref.null $ListBase
    local.set $w138
    block $while_lp_48_exit
      loop $while_lp_48
        local.get $w137
        ref.is_null
        i32.eqz
        if
          local.get $w137
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w138
          struct.new $ListCons_22
          local.set $w138
          local.get $w137
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w137
          br $while_lp_48
        else
          br $while_lp_48_exit
        end
      end
    end
    local.get $w138
    i32.const 1
    i32.const 4
    i32.const 9
    i32.const 16
    i32.const 25
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 101
    i32.const 97
    i32.const 99
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 105
    i32.const 116
    i32.const 115
    i32.const 32
    i32.const 111
    i32.const 119
    i32.const 110
    i32.const 32
    i32.const 105
    array.new_fixed $WasmStr 31
    call $sequenceEqual
  )
  (func $body_22_183 (param $self (ref $AnyFn))
    (local $double_1 (ref $WasmTests_TestsClosures_ClosureTests_Transformer))
    (local $square (ref $WasmTests_TestsClosures_ClosureTests_Transformer))
    (local $lo_clo_85 (ref $ClosureBase_47))
    (local $lo_clo_86 (ref $ClosureBase_47))
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    local.set $double_1
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    local.set $square
    local.get $double_1
    struct.get $WasmTests_TestsClosures_ClosureTests_Transformer 0
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_85
    local.get $lo_clo_85
    i32.const 5
    local.get $lo_clo_85
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 10
    i32.const 100
    i32.const 111
    i32.const 117
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 46
    i32.const 65
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 121
    i32.const 32
    i32.const 53
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    i32.const 48
    array.new_fixed $WasmStr 19
    call $equal
    local.get $square
    struct.get $WasmTests_TestsClosures_ClosureTests_Transformer 0
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_86
    local.get $lo_clo_86
    i32.const 5
    local.get $lo_clo_86
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 25
    i32.const 115
    i32.const 113
    i32.const 117
    i32.const 97
    i32.const 114
    i32.const 101
    i32.const 46
    i32.const 65
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 121
    i32.const 32
    i32.const 53
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 50
    i32.const 53
    array.new_fixed $WasmStr 19
    call $equal
    local.get $double_1
    struct.get $WasmTests_TestsClosures_ClosureTests_Transformer 1
    i32.const 100
    i32.const 111
    i32.const 117
    i32.const 98
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 6
    i32.const 100
    i32.const 111
    i32.const 117
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 110
    i32.const 97
    i32.const 109
    i32.const 101
    array.new_fixed $WasmStr 11
    call $equal
  )
  (func $closure_184 (param $self (ref $AnyFn)) (param $x_10 i32) (result i32)
    local.get $x_10
    i32.const 3
    i32.mul
  )
  (func $body_23_184 (param $self (ref $AnyFn))
    (local $maybeF (ref $ClosureType_184))
    (local $lo_clo_87 (ref $ClosureBase_47))
    ref.func $closure_184
    struct.new $ClosureType_184
    local.set $maybeF
    local.get $maybeF
    ref.is_null
    if (result i32)
      i32.const 0
    else
      local.get $maybeF
      ref.cast (ref $AnyFn)
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_87
      local.get $lo_clo_87
      i32.const 7
      local.get $lo_clo_87
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
    end
    i32.const 21
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 115
    i32.const 105
    i32.const 100
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 112
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 21
    call $equal
  )
  (func $closure_186 (param $self (ref $AnyFn)) (param $y i32) (result i32)
    i32.const 7
    local.get $y
    i32.add
  )
  (func $body_24_186 (param $self (ref $AnyFn))
    (local $add7 (ref $ClosureType_186))
    (local $lo_clo_88 (ref $ClosureBase_47))
    (local $lo_clo_89 (ref $ClosureBase_47))
    ref.func $closure_186
    struct.new $ClosureType_186
    local.set $add7
    local.get $add7
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_88
    local.get $lo_clo_88
    i32.const 3
    local.get $lo_clo_88
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 10
    i32.const 97
    i32.const 100
    i32.const 100
    i32.const 55
    i32.const 32
    i32.const 51
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    i32.const 48
    array.new_fixed $WasmStr 11
    call $equal
    local.get $add7
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_89
    local.get $lo_clo_89
    i32.const 93
    local.get $lo_clo_89
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 100
    i32.const 97
    i32.const 100
    i32.const 100
    i32.const 55
    i32.const 32
    i32.const 57
    i32.const 51
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 48
    array.new_fixed $WasmStr 13
    call $equal
  )
  (func $closure_188 (param $self (ref $AnyFn)) (param $x_12 i32) (result i32)
    (local $cmp_b i32)
    i32.const 1
    local.set $cmp_b
    local.get $x_12
    local.get $cmp_b
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_12
      local.get $cmp_b
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
    i32.const 0
    i32.ge_s
    if (result i32)
      i32.const 10
      local.set $cmp_b
      local.get $x_12
      local.get $cmp_b
      i32.eq
      if (result i32)
        i32.const 0
      else
        local.get $x_12
        local.get $cmp_b
        i32.lt_s
        if (result i32)
          i32.const -1
        else
          i32.const 1
        end
      end
      i32.const 0
      i32.le_s
    else
      i32.const 0
    end
  )
  (func $body_25_188 (param $self (ref $AnyFn))
    (local $inRange (ref $ClosureType_188))
    (local $lo_clo_90 (ref $ClosureBase_47))
    (local $lo_clo_91 (ref $ClosureBase_47))
    (local $lo_clo_92 (ref $ClosureBase_47))
    (local $lo_clo_93 (ref $ClosureBase_47))
    ref.func $closure_188
    struct.new $ClosureType_188
    local.set $inRange
    local.get $inRange
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_90
    local.get $lo_clo_90
    i32.const 5
    local.get $lo_clo_90
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 53
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 91
    i32.const 49
    i32.const 44
    i32.const 49
    i32.const 48
    i32.const 93
    array.new_fixed $WasmStr 14
    call $isTrue
    local.get $inRange
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_91
    local.get $lo_clo_91
    i32.const 11
    local.get $lo_clo_91
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 49
    i32.const 49
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 110
    i32.const 111
    i32.const 116
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 91
    i32.const 49
    i32.const 44
    i32.const 49
    i32.const 48
    i32.const 93
    array.new_fixed $WasmStr 19
    call $isFalse
    local.get $inRange
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_92
    local.get $lo_clo_92
    i32.const 1
    local.get $lo_clo_92
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 49
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 91
    i32.const 49
    i32.const 44
    i32.const 49
    i32.const 48
    i32.const 93
    array.new_fixed $WasmStr 14
    call $isTrue
    local.get $inRange
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_93
    local.get $lo_clo_93
    i32.const 0
    local.get $lo_clo_93
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 48
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 110
    i32.const 111
    i32.const 116
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 91
    i32.const 49
    i32.const 44
    i32.const 49
    i32.const 48
    i32.const 93
    array.new_fixed $WasmStr 18
    call $isFalse
  )
  (func $clamp0to100_190 (param $self (ref $AnyFn)) (param $x_13 i32) (result i32)
    (local $cmp_b i32)
    i32.const 0
    local.set $cmp_b
    local.get $x_13
    local.get $cmp_b
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_13
      local.get $cmp_b
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
    else
      i32.const 100
      local.set $cmp_b
      local.get $x_13
      local.get $cmp_b
      i32.eq
      if (result i32)
        i32.const 0
      else
        local.get $x_13
        local.get $cmp_b
        i32.lt_s
        if (result i32)
          i32.const -1
        else
          i32.const 1
        end
      end
      i32.const 0
      i32.gt_s
      if (result i32)
        i32.const 100
      else
        local.get $x_13
      end
    end
  )
  (func $body_26_190 (param $self (ref $AnyFn))
    (local $w141 (ref null $ListBase))
    (local $w139 (ref null $ListBase))
    (local $w140 (ref null $ListBase))
    (local $x_13 i32)
    (local $cmp_b i32)
    (local $w142 (ref null $ListBase))
    i32.const -5
    i32.const 0
    i32.const 50
    i32.const 100
    i32.const 150
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w139
    ref.null $ListBase
    local.set $w140
    block $while_lp_49_exit
      loop $while_lp_49
        local.get $w139
        ref.is_null
        i32.eqz
        if
          local.get $w139
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_13
          i32.const 0
          local.set $cmp_b
          local.get $x_13
          local.get $cmp_b
          i32.eq
          if (result i32)
            i32.const 0
          else
            local.get $x_13
            local.get $cmp_b
            i32.lt_s
            if (result i32)
              i32.const -1
            else
              i32.const 1
            end
          end
          i32.const 0
          i32.lt_s
          if (result i32)
            i32.const 0
          else
            i32.const 100
            local.set $cmp_b
            local.get $x_13
            local.get $cmp_b
            i32.eq
            if (result i32)
              i32.const 0
            else
              local.get $x_13
              local.get $cmp_b
              i32.lt_s
              if (result i32)
                i32.const -1
              else
                i32.const 1
              end
            end
            i32.const 0
            i32.gt_s
            if (result i32)
              i32.const 100
            else
              local.get $x_13
            end
          end
          local.get $w140
          struct.new $ListCons_22
          local.set $w140
          local.get $w139
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w139
          br $while_lp_49
        else
          br $while_lp_49_exit
        end
      end
    end
    local.get $w140
    local.set $w141
    ref.null $ListBase
    local.set $w142
    block $while_lp_50_exit
      loop $while_lp_50
        local.get $w141
        ref.is_null
        i32.eqz
        if
          local.get $w141
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w142
          struct.new $ListCons_22
          local.set $w142
          local.get $w141
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w141
          br $while_lp_50
        else
          br $while_lp_50_exit
        end
      end
    end
    local.get $w142
    i32.const 0
    i32.const 0
    i32.const 50
    i32.const 100
    i32.const 100
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 99
    i32.const 108
    i32.const 97
    i32.const 109
    i32.const 112
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    array.new_fixed $WasmStr 12
    call $sequenceEqual
  )
  (func $closure_192 (param $self (ref $AnyFn)) (param $x_14 i32) (result i32)
    i32.const 1005
    local.get $x_14
    i32.add
  )
  (func $body_27_192 (param $self (ref $AnyFn))
    (local $f_4 (ref $ClosureType_192))
    (local $lo_clo_94 (ref $ClosureBase_47))
    (local $lo_clo_95 (ref $ClosureBase_47))
    ref.func $closure_192
    struct.new $ClosureType_192
    local.set $f_4
    local.get $f_4
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_94
    local.get $lo_clo_94
    i32.const 0
    local.get $lo_clo_94
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 1005
    i32.const 102
    i32.const 32
    i32.const 48
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 48
    i32.const 53
    array.new_fixed $WasmStr 10
    call $equal
    local.get $f_4
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_95
    local.get $lo_clo_95
    i32.const 1
    local.get $lo_clo_95
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 1006
    i32.const 102
    i32.const 32
    i32.const 49
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 48
    i32.const 54
    array.new_fixed $WasmStr 10
    call $equal
  )
  (func $closure_194 (param $self (ref $AnyFn)) (param $n_6 i32) (result i32)
    (local $lo_clo_96 (ref $ClosureBase_47))
    (local $fact (ref $AnyFn))
    local.get $n_6
    i32.const 1
    i32.le_s
    if (result i32)
      i32.const 1
    else
      local.get $n_6
      local.get $fact
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_96
      local.get $lo_clo_96
      local.get $n_6
      i32.const 1
      i32.sub
      local.get $lo_clo_96
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
      i32.mul
    end
  )
  (func $body_28_194 (param $self (ref $AnyFn))
    (local $factorial (ref $AnyFn))
    (local $fact (ref $ClosureType_194))
    (local $lo_clo_97 (ref $ClosureBase_47))
    (local $lo_clo_98 (ref $ClosureBase_47))
    (local $lo_clo_99 (ref $ClosureBase_47))
    (local $lo_clo_100 (ref $ClosureBase_47))
    ref.func $closure_194
    struct.new $ClosureType_194
    local.set $fact
    local.get $fact
    local.set $factorial
    local.get $factorial
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_97
    local.get $lo_clo_97
    i32.const 0
    local.get $lo_clo_97
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 1
    i32.const 48
    i32.const 33
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    array.new_fixed $WasmStr 6
    call $equal
    local.get $factorial
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_98
    local.get $lo_clo_98
    i32.const 1
    local.get $lo_clo_98
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 1
    i32.const 49
    i32.const 33
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    array.new_fixed $WasmStr 6
    call $equal
    local.get $factorial
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_99
    local.get $lo_clo_99
    i32.const 5
    local.get $lo_clo_99
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 120
    i32.const 53
    i32.const 33
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    i32.const 50
    i32.const 48
    array.new_fixed $WasmStr 8
    call $equal
    local.get $factorial
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_100
    local.get $lo_clo_100
    i32.const 10
    local.get $lo_clo_100
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 3628800
    i32.const 49
    i32.const 48
    i32.const 33
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 51
    i32.const 54
    i32.const 50
    i32.const 56
    i32.const 56
    i32.const 48
    i32.const 48
    array.new_fixed $WasmStr 13
    call $equal
  )
  (func $letrec_isEven_197 (param $self (ref $AnyFn)) (param $n_7 i32) (result i32)
    (local $lo_clo_101 (ref $ClosureBase_47))
    (local $isOdd (ref $AnyFn))
    local.get $n_7
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      local.get $isOdd
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_101
      local.get $lo_clo_101
      local.get $n_7
      i32.const 1
      i32.sub
      local.get $lo_clo_101
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
    end
  )
  (func $letrec_isOdd_198 (param $self (ref $AnyFn)) (param $n_8 i32) (result i32)
    (local $lo_clo_102 (ref $ClosureBase_47))
    (local $isEven (ref $AnyFn))
    local.get $n_8
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $isEven
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_102
      local.get $lo_clo_102
      local.get $n_8
      i32.const 1
      i32.sub
      local.get $lo_clo_102
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
    end
  )
  (func $body_29_196 (param $self (ref $AnyFn))
    (local $patternInput (ref $Tuple_199))
    (local $letrec_cell_isEven (ref $RefCell_196))
    (local $letrec_cell_isOdd (ref $RefCell_196))
    (local $isOdd_1 (ref $AnyFn))
    (local $isEven_1 (ref $AnyFn))
    (local $lo_clo_103 (ref $ClosureBase_47))
    (local $lo_clo_104 (ref $ClosureBase_47))
    (local $lo_clo_105 (ref $ClosureBase_47))
    (local $lo_clo_106 (ref $ClosureBase_47))
    (local $isEven (ref $AnyFn))
    (local $isOdd (ref $AnyFn))
    ref.func $letrec_isEven_197
    local.get $letrec_cell_isOdd
    struct.new $ClosureType_197
    struct.new $RefCell_196
    local.set $letrec_cell_isEven
    ref.func $letrec_isOdd_198
    local.get $letrec_cell_isEven
    struct.new $ClosureType_198
    struct.new $RefCell_196
    local.set $letrec_cell_isOdd
    local.get $isEven
    local.get $isOdd
    struct.new $Tuple_199
    local.set $patternInput
    local.get $patternInput
    struct.get $Tuple_199 1
    local.set $isOdd_1
    local.get $patternInput
    struct.get $Tuple_199 0
    local.set $isEven_1
    local.get $isEven_1
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_103
    local.get $lo_clo_103
    i32.const 0
    local.get $lo_clo_103
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 48
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 101
    i32.const 118
    i32.const 101
    i32.const 110
    array.new_fixed $WasmStr 9
    call $isTrue
    local.get $isOdd_1
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_104
    local.get $lo_clo_104
    i32.const 0
    local.get $lo_clo_104
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 48
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 110
    i32.const 111
    i32.const 116
    i32.const 32
    i32.const 111
    i32.const 100
    i32.const 100
    array.new_fixed $WasmStr 12
    call $isFalse
    local.get $isEven_1
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_105
    local.get $lo_clo_105
    i32.const 10
    local.get $lo_clo_105
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 49
    i32.const 48
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 101
    i32.const 118
    i32.const 101
    i32.const 110
    array.new_fixed $WasmStr 10
    call $isTrue
    local.get $isOdd_1
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_106
    local.get $lo_clo_106
    i32.const 7
    local.get $lo_clo_106
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 55
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 111
    i32.const 100
    i32.const 100
    array.new_fixed $WasmStr 8
    call $isTrue
  )
  (func $closure_201 (param $self (ref $AnyFn)) (param $n_9 i32)
    (local $self_cast (ref $ClosureType_201))
    (local $total_2 i32)
    (local $lo_clo_107 (ref $ClosureBase_124))
    (local $sumTo (ref $AnyFn))
    local.get $self
    ref.cast (ref $ClosureType_201)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_201 1
    local.set $total_2
    local.get $n_9
    i32.const 0
    i32.gt_s
    if
      local.get $total_2
      local.get $n_9
      i32.add
      local.set $total_2
      local.get $sumTo
      ref.cast (ref $ClosureBase_124)
      local.set $lo_clo_107
      local.get $lo_clo_107
      local.get $n_9
      i32.const 1
      i32.sub
      local.get $lo_clo_107
      struct.get $ClosureBase_124 0
      call_ref $FuncType_123
    end
  )
  (func $body_30_201 (param $self (ref $AnyFn))
    (local $total_2 i32)
    (local $sumTo (ref $ClosureType_201))
    (local $lo_clo_108 (ref $ClosureBase_124))
    i32.const 0
    local.set $total_2
    ref.func $closure_201
    local.get $total_2
    struct.new $ClosureType_201
    local.set $sumTo
    local.get $sumTo
    ref.cast (ref $ClosureBase_124)
    local.set $lo_clo_108
    local.get $lo_clo_108
    i32.const 10
    local.get $lo_clo_108
    struct.get $ClosureBase_124 0
    call_ref $FuncType_123
    local.get $total_2
    i32.const 55
    i32.const 115
    i32.const 117
    i32.const 109
    i32.const 32
    i32.const 49
    i32.const 46
    i32.const 46
    i32.const 49
    i32.const 48
    i32.const 32
    i32.const 118
    i32.const 105
    i32.const 97
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 117
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 118
    i32.const 101
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 39
    call $equal
  )
  (func $closure_203 (param $self (ref $AnyFn)) (param $n_10 i32) (result i32)
    (local $lo_clo_109 (ref $ClosureBase_47))
    (local $lo_clo_110 (ref $ClosureBase_47))
    (local $fib (ref $AnyFn))
    local.get $n_10
    i32.const 1
    i32.le_s
    if (result i32)
      local.get $n_10
    else
      local.get $fib
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_109
      local.get $lo_clo_109
      local.get $n_10
      i32.const 1
      i32.sub
      local.get $lo_clo_109
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
      local.get $fib
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_110
      local.get $lo_clo_110
      local.get $n_10
      i32.const 2
      i32.sub
      local.get $lo_clo_110
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
      i32.add
    end
  )
  (func $body_31_203 (param $self (ref $AnyFn))
    (local $fib (ref $ClosureType_203))
    ref.func $closure_203
    struct.new $ClosureType_203
    local.set $fib
    i32.const 0
    i32.const 1
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 5
    i32.const 8
    i32.const 13
    i32.const 21
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 102
    i32.const 105
    i32.const 98
    i32.const 32
    i32.const 115
    i32.const 101
    i32.const 113
    i32.const 117
    i32.const 101
    i32.const 110
    i32.const 99
    i32.const 101
    array.new_fixed $WasmStr 12
    call $sequenceEqual
  )
  (func $closure_205 (param $self (ref $AnyFn)) (param $x_15 i32) (result i32)
    local.get $x_15
    i32.const 1
    i32.add
  )
  (func $body_32_205 (param $self (ref $AnyFn))
    (local $lo_clo_111 (ref $ClosureBase_47))
    ref.func $closure_205
    struct.new $ClosureType_205
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_111
    local.get $lo_clo_111
    i32.const 5
    local.get $lo_clo_111
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 6
    i32.const 105
    i32.const 102
    i32.const 45
    i32.const 98
    i32.const 114
    i32.const 97
    i32.const 110
    i32.const 99
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 17
    call $equal
  )
  (func $closure_207 (param $self (ref $AnyFn)) (param $b_2 i32) (result i32)
    (local $self_cast (ref $ClosureType_207))
    (local $a_2 i32)
    local.get $self
    ref.cast (ref $ClosureType_207)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_207 1
    local.set $a_2
    local.get $a_2
    local.get $b_2
    i32.add
  )
  (func $closure_207 (param $self (ref $AnyFn)) (param $a_2 i32) (result (ref $AnyFn))
    ref.func $closure_207
    local.get $a_2
    struct.new $ClosureType_207
  )
  (func $closure_209 (param $self (ref $AnyFn)) (param $b_3 i32) (result i32)
    (local $self_cast (ref $ClosureType_209))
    (local $a_3 i32)
    local.get $self
    ref.cast (ref $ClosureType_209)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_209 1
    local.set $a_3
    local.get $a_3
    local.get $b_3
    i32.mul
  )
  (func $closure_209 (param $self (ref $AnyFn)) (param $a_3 i32) (result (ref $AnyFn))
    ref.func $closure_209
    local.get $a_3
    struct.new $ClosureType_209
  )
  (func $closure_211 (param $self (ref $AnyFn)) (param $b_4 i32) (result i32)
    (local $self_cast (ref $ClosureType_211))
    (local $a_4 i32)
    local.get $self
    ref.cast (ref $ClosureType_211)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_211 1
    local.set $a_4
    local.get $a_4
    local.get $b_4
    i32.sub
  )
  (func $closure_211 (param $self (ref $AnyFn)) (param $a_4 i32) (result (ref $AnyFn))
    ref.func $closure_211
    local.get $a_4
    struct.new $ClosureType_211
  )
  (func $body_33_207 (param $self (ref $AnyFn))
    (local $lo_clo_112 (ref $ClosureBase_76))
    ref.func $closure_209
    struct.new $ClosureType_210
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_112
    local.get $lo_clo_112
    i32.const 3
    i32.const 4
    local.get $lo_clo_112
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
    i32.const 12
    i32.const 109
    i32.const 97
    i32.const 116
    i32.const 99
    i32.const 104
    i32.const 45
    i32.const 115
    i32.const 101
    i32.const 108
    i32.const 101
    i32.const 99
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 22
    call $equal
  )
  (func $closure_214 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_214))
    (local $i_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_214)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_214 1
    local.set $i_1
    local.get $i_1
  )
  (func $closure_215 (param $self (ref $AnyFn)) (param $f_6 (ref $AnyFn)) (result i32)
    (local $lo_clo_113 (ref $ClosureBase_145))
    local.get $f_6
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_113
    local.get $lo_clo_113
    local.get $lo_clo_113
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
  )
  (func $body_34_214 (param $self (ref $AnyFn))
    (local $results_2 (ref null $ListBase))
    (local $i_1 i32)
    (local $limit i32)
    (local $w149 (ref null $ListBase))
    (local $w147 (ref null $ListBase))
    (local $w145 (ref null $ListBase))
    (local $w146 (ref null $ListBase))
    (local $w148 (ref null $ListBase))
    (local $f_6 (ref $AnyFn))
    (local $lo_clo_114 (ref $ClosureBase_145))
    (local $w150 (ref null $ListBase))
    ref.null $ListBase
    local.set $results_2
    i32.const 1
    local.set $i_1
    i32.const 5
    local.set $limit
    loop $for
      local.get $i_1
      local.get $limit
      i32.le_s
      if
        ref.func $closure_214
        local.get $i_1
        struct.new $ClosureType_214
        local.get $results_2
        struct.new $ListCons_171
        local.set $results_2
        local.get $i_1
        i32.const 1
        i32.add
        local.set $i_1
        br $for
      end
    end
    local.get $results_2
    local.set $w145
    ref.null $ListBase
    local.set $w146
    block $while_lp_52_exit
      loop $while_lp_52
        local.get $w145
        ref.is_null
        i32.eqz
        if
          local.get $w145
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.get $w146
          struct.new $ListCons_171
          local.set $w146
          local.get $w145
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w145
          br $while_lp_52
        else
          br $while_lp_52_exit
        end
      end
    end
    local.get $w146
    local.set $w147
    ref.null $ListBase
    local.set $w148
    block $while_lp_53_exit
      loop $while_lp_53
        local.get $w147
        ref.is_null
        i32.eqz
        if
          local.get $w147
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.set $f_6
          local.get $f_6
          ref.cast (ref $ClosureBase_145)
          local.set $lo_clo_114
          local.get $lo_clo_114
          local.get $lo_clo_114
          struct.get $ClosureBase_145 0
          call_ref $FuncType_144
          local.get $w148
          struct.new $ListCons_22
          local.set $w148
          local.get $w147
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w147
          br $while_lp_53
        else
          br $while_lp_53_exit
        end
      end
    end
    local.get $w148
    local.set $w149
    ref.null $ListBase
    local.set $w150
    block $while_lp_54_exit
      loop $while_lp_54
        local.get $w149
        ref.is_null
        i32.eqz
        if
          local.get $w149
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w150
          struct.new $ListCons_22
          local.set $w150
          local.get $w149
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w149
          br $while_lp_54
        else
          br $while_lp_54_exit
        end
      end
    end
    local.get $w150
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 101
    i32.const 97
    i32.const 99
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 105
    i32.const 116
    i32.const 115
    i32.const 32
    i32.const 111
    i32.const 119
    i32.const 110
    i32.const 32
    i32.const 108
    i32.const 111
    i32.const 111
    i32.const 112
    i32.const 32
    i32.const 105
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    array.new_fixed $WasmStr 50
    call $sequenceEqual
  )
  (func $body_35_217 (param $self (ref $AnyFn))
    (local $i_2 i32)
    (local $sum_1 i32)
    i32.const 0
    local.set $i_2
    i32.const 0
    local.set $sum_1
    loop $while
      local.get $i_2
      i32.const 5
      i32.lt_s
      if
        local.get $i_2
        i32.const 1
        i32.add
        local.set $i_2
        local.get $sum_1
        local.get $i_2
        i32.add
        local.set $sum_1
        br $while
      end
    end
    local.get $sum_1
    i32.const 15
    i32.const 49
    i32.const 43
    i32.const 50
    i32.const 43
    i32.const 51
    i32.const 43
    i32.const 52
    i32.const 43
    i32.const 53
    i32.const 32
    i32.const 118
    i32.const 105
    i32.const 97
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    array.new_fixed $WasmStr 26
    call $equal
  )
  (func $closure_218 (param $self (ref $AnyFn)) (param $arg i32) (result i32)
    local.get $arg
    i32.const 1
    i32.shl
    i32.const 1
    i32.add
  )
  (func $body_36_218 (param $self (ref $AnyFn))
    (local $doubleThenAdd (ref $ClosureType_218))
    (local $lo_clo_115 (ref $ClosureBase_47))
    (local $lo_clo_116 (ref $ClosureBase_47))
    ref.func $closure_218
    struct.new $ClosureType_218
    local.set $doubleThenAdd
    local.get $doubleThenAdd
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_115
    local.get $lo_clo_115
    i32.const 5
    local.get $lo_clo_115
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 11
    i32.const 50
    i32.const 42
    i32.const 53
    i32.const 43
    i32.const 49
    i32.const 61
    i32.const 49
    i32.const 49
    array.new_fixed $WasmStr 8
    call $equal
    local.get $doubleThenAdd
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_116
    local.get $lo_clo_116
    i32.const 0
    local.get $lo_clo_116
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 1
    i32.const 50
    i32.const 42
    i32.const 48
    i32.const 43
    i32.const 49
    i32.const 61
    i32.const 49
    array.new_fixed $WasmStr 7
    call $equal
  )
  (func $body_37_220 (param $self (ref $AnyFn))
    i32.const 13
    i32.const 13
    i32.const 104
    i32.const 40
    i32.const 103
    i32.const 40
    i32.const 102
    i32.const 40
    i32.const 52
    i32.const 41
    i32.const 41
    i32.const 41
    i32.const 61
    i32.const 49
    i32.const 51
    array.new_fixed $WasmStr 13
    call $equal
  )
  (func $closure_221 (param $self (ref $AnyFn)) (param $a_5 i32) (param $b_5 i32) (result i32)
    local.get $a_5
    local.get $b_5
    i32.sub
  )
  (func $subFlipped_222 (param $self (ref $AnyFn)) (param $x_22 i32) (param $y_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_222))
    (local $sub (ref $AnyFn))
    (local $lo_clo_117 (ref $ClosureBase_76))
    local.get $self
    ref.cast (ref $ClosureType_222)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_222 1
    local.set $sub
    local.get $sub
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_117
    local.get $lo_clo_117
    local.get $y_1
    local.get $x_22
    local.get $lo_clo_117
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
  )
  (func $body_38_221 (param $self (ref $AnyFn))
    (local $sub (ref $ClosureType_221))
    (local $lo_clo_118 (ref $ClosureBase_76))
    ref.func $closure_221
    struct.new $ClosureType_221
    local.set $sub
    local.get $sub
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_118
    local.get $lo_clo_118
    i32.const 10
    i32.const 3
    local.get $lo_clo_118
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
    i32.const 7
    i32.const 115
    i32.const 117
    i32.const 98
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 32
    i32.const 51
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 55
    array.new_fixed $WasmStr 12
    call $equal
    i32.const 10
    i32.const 3
    ref.func $subFlipped_222
    local.get $sub
    struct.new $ClosureType_222
    call_ref 0 ;; TODO: resolve functype
    i32.const -7
    i32.const 102
    i32.const 108
    i32.const 105
    i32.const 112
    i32.const 32
    i32.const 115
    i32.const 117
    i32.const 98
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 32
    i32.const 51
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 51
    i32.const 45
    i32.const 49
    i32.const 48
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 45
    i32.const 55
    array.new_fixed $WasmStr 25
    call $equal
  )
  (func $f_9_224 (param $self (ref $AnyFn)) (param $x_24 i32) (result i32)
    (local $self_cast (ref $ClosureType_224))
    (local $invocations i32)
    local.get $self
    ref.cast (ref $ClosureType_224)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_224 1
    local.set $invocations
    local.get $invocations
    i32.const 1
    i32.add
    local.set $invocations
    local.get $x_24
    local.get $x_24
    i32.mul
  )
  (func $closure_224 (param $self (ref $AnyFn)) (param $x_23 i32) (result i32)
    (local $self_cast (ref $ClosureType_225))
    (local $cachedArg i32)
    (local $cachedVal i32)
    (local $callCount i32)
    (local $invocations i32)
    (local $lo_clo_119 (ref $ClosureBase_47))
    local.get $self
    ref.cast (ref $ClosureType_225)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_225 1
    local.set $cachedArg
    local.get $self_cast
    struct.get $ClosureType_225 2
    local.set $cachedVal
    local.get $self_cast
    struct.get $ClosureType_225 3
    local.set $callCount
    local.get $self_cast
    struct.get $ClosureType_225 4
    local.set $invocations
    local.get $x_23
    local.get $cachedArg
    i32.eq
    if (result i32)
      local.get $cachedVal
    else
      local.get $callCount
      i32.const 1
      i32.add
      local.set $callCount
      local.get $x_23
      local.set $cachedArg
      ref.func $f_9_224
      local.get $invocations
      struct.new $ClosureType_224
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_119
      local.get $lo_clo_119
      local.get $x_23
      local.get $lo_clo_119
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
      local.set $cachedVal
      local.get $cachedVal
    end
  )
  (func $body_39_224 (param $self (ref $AnyFn))
    (local $invocations i32)
    (local $memoized (ref $ClosureType_225))
    (local $cachedArg i32)
    (local $cachedVal i32)
    (local $callCount i32)
    (local $lo_clo_120 (ref $ClosureBase_47))
    (local $lo_clo_121 (ref $ClosureBase_47))
    (local $lo_clo_122 (ref $ClosureBase_47))
    i32.const 0
    local.set $invocations
    i32.const -2147483648
    local.set $cachedArg
    i32.const 0
    local.set $cachedVal
    i32.const 0
    local.set $callCount
    ref.func $closure_224
    local.get $cachedArg
    local.get $cachedVal
    local.get $callCount
    local.get $invocations
    struct.new $ClosureType_225
    local.set $memoized
    local.get $memoized
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_120
    local.get $lo_clo_120
    i32.const 5
    local.get $lo_clo_120
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 25
    i32.const 102
    i32.const 105
    i32.const 114
    i32.const 115
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 58
    i32.const 32
    i32.const 50
    i32.const 53
    array.new_fixed $WasmStr 14
    call $equal
    local.get $invocations
    i32.const 1
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 117
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 111
    i32.const 110
    i32.const 99
    i32.const 101
    array.new_fixed $WasmStr 13
    call $equal
    local.get $memoized
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_121
    local.get $lo_clo_121
    i32.const 5
    local.get $lo_clo_121
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 25
    i32.const 115
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 58
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 99
    i32.const 104
    i32.const 101
    i32.const 100
    array.new_fixed $WasmStr 19
    call $equal
    local.get $invocations
    i32.const 1
    i32.const 115
    i32.const 116
    i32.const 105
    i32.const 108
    i32.const 108
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 117
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 111
    i32.const 110
    i32.const 99
    i32.const 101
    array.new_fixed $WasmStr 19
    call $equal
    local.get $memoized
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_122
    local.get $lo_clo_122
    i32.const 6
    local.get $lo_clo_122
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 36
    i32.const 110
    i32.const 101
    i32.const 119
    i32.const 32
    i32.const 97
    i32.const 114
    i32.const 103
    i32.const 58
    i32.const 32
    i32.const 51
    i32.const 54
    array.new_fixed $WasmStr 11
    call $equal
    local.get $invocations
    i32.const 2
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 117
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 97
    i32.const 103
    i32.const 97
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 102
    i32.const 111
    i32.const 114
    i32.const 32
    i32.const 110
    i32.const 101
    i32.const 119
    i32.const 32
    i32.const 97
    i32.const 114
    i32.const 103
    array.new_fixed $WasmStr 26
    call $equal
  )
  (func $folder_227 (param $self (ref $AnyFn)) (param $x_27 i32) (param $y_2 i32) (result i32)
    local.get $x_27
    local.get $y_2
    i32.add
  )
  (func $mapping_228 (param $self (ref $AnyFn)) (param $x_26 i32) (result i32)
    local.get $x_26
    i32.const 10
    i32.mul
  )
  (func $predicate_229 (param $self (ref $AnyFn)) (param $x_25 i32) (result i32)
    local.get $x_25
    i32.const 3
    i32.gt_s
  )
  (func $predicate_230 (param $self (ref $AnyFn)) (param $x_25 i32) (result i32)
    local.get $x_25
    i32.const 3
    i32.gt_s
  )
  (func $mapping_231 (param $self (ref $AnyFn)) (param $x_26 i32) (result i32)
    local.get $x_26
    i32.const 10
    i32.mul
  )
  (func $predicate_232 (param $self (ref $AnyFn)) (param $x_25 i32) (result i32)
    local.get $x_25
    i32.const 3
    i32.gt_s
  )
  (func $predicate_233 (param $self (ref $AnyFn)) (param $x_25 i32) (result i32)
    local.get $x_25
    i32.const 3
    i32.gt_s
  )
  (func $body_40_227 (param $self (ref $AnyFn))
    (local $w175 (ref null $ListBase))
    (local $w173 (ref null $ListBase))
    (local $w171 (ref null $ListBase))
    (local $w169 (ref null $ListBase))
    (local $w167 (ref null $ListBase))
    (local $w168 (ref null $ListBase))
    (local $x_25 i32)
    (local $w170 (ref null $ListBase))
    (local $w172 (ref null $ListBase))
    (local $x_26 i32)
    (local $w174 (ref null $ListBase))
    (local $w176 i32)
    (local $y_2 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w167
    ref.null $ListBase
    local.set $w168
    block $while_lp_63_exit
      loop $while_lp_63
        local.get $w167
        ref.is_null
        i32.eqz
        if
          local.get $w167
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_25
          local.get $x_25
          i32.const 3
          i32.gt_s
          if (result (ref null $ListBase))
            local.get $w167
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 0
            local.get $w168
            struct.new $ListCons_22
          else
            local.get $w168
          end
          local.set $w168
          local.get $w167
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w167
          br $while_lp_63
        else
          br $while_lp_63_exit
        end
      end
    end
    local.get $w168
    local.set $w169
    ref.null $ListBase
    local.set $w170
    block $while_lp_64_exit
      loop $while_lp_64
        local.get $w169
        ref.is_null
        i32.eqz
        if
          local.get $w169
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w170
          struct.new $ListCons_22
          local.set $w170
          local.get $w169
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w169
          br $while_lp_64
        else
          br $while_lp_64_exit
        end
      end
    end
    local.get $w170
    local.set $w171
    ref.null $ListBase
    local.set $w172
    block $while_lp_65_exit
      loop $while_lp_65
        local.get $w171
        ref.is_null
        i32.eqz
        if
          local.get $w171
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_26
          local.get $x_26
          i32.const 10
          i32.mul
          local.get $w172
          struct.new $ListCons_22
          local.set $w172
          local.get $w171
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w171
          br $while_lp_65
        else
          br $while_lp_65_exit
        end
      end
    end
    local.get $w172
    local.set $w173
    ref.null $ListBase
    local.set $w174
    block $while_lp_66_exit
      loop $while_lp_66
        local.get $w173
        ref.is_null
        i32.eqz
        if
          local.get $w173
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w174
          struct.new $ListCons_22
          local.set $w174
          local.get $w173
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w173
          br $while_lp_66
        else
          br $while_lp_66_exit
        end
      end
    end
    local.get $w174
    local.set $w175
    i32.const 0
    local.set $w176
    block $while_lp_67_exit
      loop $while_lp_67
        local.get $w175
        ref.is_null
        i32.eqz
        if
          local.get $w175
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_2
          local.get $w176
          local.get $y_2
          i32.add
          local.set $w176
          local.get $w175
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w175
          br $while_lp_67
        else
          br $while_lp_67_exit
        end
      end
    end
    local.get $w176
    i32.const 150
    i32.const 112
    i32.const 105
    i32.const 112
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 110
    i32.const 101
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    i32.const 115
    array.new_fixed $WasmStr 29
    call $equal
  )
  (func $level3_235 (param $self (ref $AnyFn)) (param $z i32) (result i32)
    (local $self_cast (ref $ClosureType_235))
    (local $b_6 i32)
    local.get $self
    ref.cast (ref $ClosureType_235)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_235 1
    local.set $b_6
    local.get $b_6
    local.get $z
    i32.mul
  )
  (func $level2_235 (param $self (ref $AnyFn)) (param $y_3 i32) (result (ref $AnyFn))
    (local $self_cast (ref $ClosureType_236))
    (local $a_6 i32)
    (local $b_6 i32)
    local.get $self
    ref.cast (ref $ClosureType_236)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_236 1
    local.set $a_6
    local.get $a_6
    local.get $y_3
    i32.add
    local.set $b_6
    ref.func $level3_235
    local.get $b_6
    struct.new $ClosureType_235
  )
  (func $body_41_235 (param $self (ref $AnyFn))
    (local $f_10 (ref $ClosureType_236))
    (local $a_6 i32)
    (local $g_2 (ref $AnyFn))
    (local $lo_clo_123 (ref $ClosureBase_174))
    (local $lo_clo_124 (ref $ClosureBase_47))
    (local $lo_clo_125 (ref $ClosureBase_47))
    (local $lo_clo_126 (ref $ClosureBase_76))
    i32.const 6
    local.set $a_6
    ref.func $level2_235
    local.get $a_6
    struct.new $ClosureType_236
    local.set $f_10
    local.get $f_10
    ref.cast (ref $ClosureBase_174)
    local.set $lo_clo_123
    local.get $lo_clo_123
    i32.const 4
    local.get $lo_clo_123
    struct.get $ClosureBase_174 0
    call_ref $FuncType_173
    local.set $g_2
    local.get $g_2
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_124
    local.get $lo_clo_124
    i32.const 5
    local.get $lo_clo_124
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 50
    i32.const 51
    i32.const 42
    i32.const 50
    i32.const 61
    i32.const 54
    i32.const 44
    i32.const 32
    i32.const 54
    i32.const 43
    i32.const 52
    i32.const 61
    i32.const 49
    i32.const 48
    i32.const 44
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 42
    i32.const 53
    i32.const 61
    i32.const 53
    i32.const 48
    array.new_fixed $WasmStr 22
    call $equal
    local.get $g_2
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_125
    local.get $lo_clo_125
    i32.const 1
    local.get $lo_clo_125
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 10
    i32.const 115
    i32.const 97
    i32.const 109
    i32.const 101
    i32.const 32
    i32.const 103
    i32.const 44
    i32.const 32
    i32.const 122
    i32.const 61
    i32.const 49
    i32.const 58
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 42
    i32.const 49
    i32.const 61
    i32.const 49
    i32.const 48
    array.new_fixed $WasmStr 20
    call $equal
    local.get $f_10
    ref.cast (ref $ClosureBase_76)
    local.set $lo_clo_126
    local.get $lo_clo_126
    i32.const 0
    i32.const 7
    local.get $lo_clo_126
    struct.get $ClosureBase_76 0
    call_ref $FuncType_75
    i32.const 42
    i32.const 102
    i32.const 32
    i32.const 48
    i32.const 32
    i32.const 8594
    i32.const 32
    i32.const 98
    i32.const 61
    i32.const 54
    i32.const 44
    i32.const 32
    i32.const 54
    i32.const 42
    i32.const 55
    i32.const 61
    i32.const 52
    i32.const 50
    array.new_fixed $WasmStr 17
    call $equal
  )
  (func $times2_238 (param $self (ref $AnyFn)) (param $x_30 i32) (result i32)
    local.get $x_30
    i32.const 1
    i32.shl
  )
  (func $add3_239 (param $self (ref $AnyFn)) (param $x_29 i32) (result i32)
    local.get $x_29
    i32.const 3
    i32.add
  )
  (func $closure_238 (param $self (ref $AnyFn)) (param $x_31 i32) (result i32)
    (local $lo_clo_128 (ref $ClosureBase_47))
    (local $lo_clo_127 (ref $ClosureBase_47))
    ref.func $times2_238
    struct.new $ClosureType_238
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_128
    local.get $lo_clo_128
    ref.func $add3_239
    struct.new $ClosureType_239
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_127
    local.get $lo_clo_127
    local.get $x_31
    local.get $lo_clo_127
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    local.get $lo_clo_128
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
  )
  (func $body_42_238 (param $self (ref $AnyFn))
    (local $add3ThenDouble (ref $ClosureType_240))
    (local $lo_clo_129 (ref $ClosureBase_47))
    (local $lo_clo_130 (ref $ClosureBase_47))
    ref.func $closure_238
    struct.new $ClosureType_240
    local.set $add3ThenDouble
    local.get $add3ThenDouble
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_129
    local.get $lo_clo_129
    i32.const 5
    local.get $lo_clo_129
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 16
    i32.const 40
    i32.const 53
    i32.const 43
    i32.const 51
    i32.const 41
    i32.const 42
    i32.const 50
    i32.const 61
    i32.const 49
    i32.const 54
    array.new_fixed $WasmStr 10
    call $equal
    local.get $add3ThenDouble
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_130
    local.get $lo_clo_130
    i32.const 0
    local.get $lo_clo_130
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 6
    i32.const 40
    i32.const 48
    i32.const 43
    i32.const 51
    i32.const 41
    i32.const 42
    i32.const 50
    i32.const 61
    i32.const 54
    array.new_fixed $WasmStr 9
    call $equal
  )
  (func $body_43_242 (param $self (ref $AnyFn))
    (local $pair (ref $Tuple_54))
    i32.const 10
    i32.const 20
    struct.new $Tuple_54
    local.set $pair
    local.get $pair
    struct.get $Tuple_54 0
    local.get $pair
    struct.get $Tuple_54 1
    i32.add
    i32.const 30
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 100
    i32.const 101
    i32.const 115
    i32.const 116
    i32.const 114
    i32.const 117
    i32.const 99
    i32.const 116
    i32.const 115
    i32.const 32
    i32.const 116
    i32.const 117
    i32.const 112
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 36
    call $equal
  )
  (func $closure_243 (param $self (ref $AnyFn)) (param $x_32 i32) (param $y_4 i32) (result i32)
    local.get $x_32
    local.get $y_4
    i32.add
  )
  (func $body_44_243 (param $self (ref $AnyFn))
    (local $data (ref null $ListBase))
    (local $w177 (ref null $ListBase))
    (local $w178 i32)
    (local $y_4 i32)
    (local $w179 (ref null $ListBase))
    (local $w180 i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $data
    local.get $data
    local.set $w177
    i32.const 0
    local.set $w178
    block $while_lp_68_exit
      loop $while_lp_68
        local.get $w177
        ref.is_null
        i32.eqz
        if
          local.get $w177
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_4
          local.get $w178
          local.get $y_4
          i32.add
          local.set $w178
          local.get $w177
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w177
          br $while_lp_68
        else
          br $while_lp_68_exit
        end
      end
    end
    local.get $w178
    i32.const 15
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 58
    i32.const 32
    i32.const 115
    i32.const 117
    i32.const 109
    array.new_fixed $WasmStr 22
    call $equal
    local.get $data
    local.set $w179
    i32.const 0
    local.set $w180
    block $while_lp_69_exit
      loop $while_lp_69
        local.get $w179
        ref.is_null
        i32.eqz
        if
          local.get $w180
          i32.const 1
          i32.add
          local.set $w180
          local.get $w179
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w179
          br $while_lp_69
        else
          br $while_lp_69_exit
        end
      end
    end
    local.get $w180
    i32.const 5
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 58
    i32.const 32
    i32.const 108
    i32.const 101
    i32.const 110
    i32.const 103
    i32.const 116
    i32.const 104
    array.new_fixed $WasmStr 25
    call $equal
  )
  (func $closure_245 (param $self (ref $AnyFn)) (param $x_33 i32) (result i32)
    (local $self_cast (ref $ClosureType_245))
    (local $cfg (ref $WasmTests_TestsClosures_ClosureTests_Config))
    local.get $self
    ref.cast (ref $ClosureType_245)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_245 1
    local.set $cfg
    local.get $x_33
    local.get $cfg
    struct.get $WasmTests_TestsClosures_ClosureTests_Config 0
    i32.mul
    local.get $cfg
    struct.get $WasmTests_TestsClosures_ClosureTests_Config 1
    i32.add
  )
  (func $body_45_245 (param $self (ref $AnyFn))
    (local $cfg (ref $WasmTests_TestsClosures_ClosureTests_Config))
    (local $transform (ref $ClosureType_245))
    (local $lo_clo_131 (ref $ClosureBase_47))
    (local $lo_clo_132 (ref $ClosureBase_47))
    (local $lo_clo_133 (ref $ClosureBase_47))
    i32.const 3
    i32.const 7
    struct.new $WasmTests_TestsClosures_ClosureTests_Config
    local.set $cfg
    ref.func $closure_245
    local.get $cfg
    struct.new $ClosureType_245
    local.set $transform
    local.get $transform
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_131
    local.get $lo_clo_131
    i32.const 0
    local.get $lo_clo_131
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 7
    i32.const 48
    i32.const 42
    i32.const 51
    i32.const 43
    i32.const 55
    i32.const 61
    i32.const 55
    array.new_fixed $WasmStr 7
    call $equal
    local.get $transform
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_132
    local.get $lo_clo_132
    i32.const 1
    local.get $lo_clo_132
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 10
    i32.const 49
    i32.const 42
    i32.const 51
    i32.const 43
    i32.const 55
    i32.const 61
    i32.const 49
    i32.const 48
    array.new_fixed $WasmStr 8
    call $equal
    local.get $transform
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_133
    local.get $lo_clo_133
    i32.const 10
    local.get $lo_clo_133
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
    i32.const 37
    i32.const 49
    i32.const 48
    i32.const 42
    i32.const 51
    i32.const 43
    i32.const 55
    i32.const 61
    i32.const 51
    i32.const 55
    array.new_fixed $WasmStr 9
    call $equal
  )
  (func $closure_247 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_247))
    (local $n_12 i32)
    local.get $self
    ref.cast (ref $ClosureType_247)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_247 1
    local.set $n_12
    local.get $n_12
    i32.const 1
    i32.add
    local.set $n_12
    local.get $n_12
  )
  (func $body_46_247 (param $self (ref $AnyFn))
    (local $n_12 i32)
    (local $inc_1 (ref $ClosureType_247))
    (local $lo_clo_134 (ref $ClosureBase_145))
    (local $lo_clo_135 (ref $ClosureBase_145))
    (local $lo_clo_136 (ref $ClosureBase_145))
    i32.const 0
    local.set $n_12
    ref.func $closure_247
    local.get $n_12
    struct.new $ClosureType_247
    local.set $inc_1
    local.get $inc_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_134
    local.get $lo_clo_134
    local.get $lo_clo_134
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 1
    i32.const 105
    i32.const 110
    i32.const 99
    i32.const 32
    i32.const 102
    i32.const 105
    i32.const 114
    i32.const 115
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    array.new_fixed $WasmStr 14
    call $equal
    local.get $inc_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_135
    local.get $lo_clo_135
    local.get $lo_clo_135
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 2
    i32.const 97
    i32.const 108
    i32.const 105
    i32.const 97
    i32.const 115
    i32.const 32
    i32.const 115
    i32.const 101
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 115
    i32.const 97
    i32.const 109
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 117
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 114
    array.new_fixed $WasmStr 23
    call $equal
    local.get $inc_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_136
    local.get $lo_clo_136
    local.get $lo_clo_136
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 3
    i32.const 105
    i32.const 110
    i32.const 99
    i32.const 32
    i32.const 97
    i32.const 103
    i32.const 97
    i32.const 105
    i32.const 110
    array.new_fixed $WasmStr 9
    call $equal
  )
  (func $step_1_249 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_249))
    (local $k i32)
    local.get $self
    ref.cast (ref $ClosureType_249)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_249 1
    local.set $k
    local.get $k
    i32.const 1
    i32.add
    local.set $k
    local.get $k
  )
  (func $body_47_249 (param $self (ref $AnyFn))
    (local $k i32)
    (local $f_11 (ref $ClosureType_249))
    (local $lo_clo_137 (ref $ClosureBase_145))
    (local $lo_clo_138 (ref $ClosureBase_145))
    i32.const 0
    local.set $k
    ref.func $step_1_249
    local.get $k
    struct.new $ClosureType_249
    local.set $f_11
    local.get $f_11
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_137
    local.get $lo_clo_137
    local.get $lo_clo_137
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    local.get $f_11
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_138
    local.get $lo_clo_138
    local.get $lo_clo_138
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.add
    i32.const 3
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 40
    i32.const 41
    i32.const 32
    i32.const 8594
    i32.const 32
    i32.const 49
    i32.const 44
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 40
    i32.const 41
    i32.const 32
    i32.const 8594
    i32.const 32
    i32.const 50
    i32.const 44
    i32.const 32
    i32.const 115
    i32.const 117
    i32.const 109
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 51
    array.new_fixed $WasmStr 31
    call $equal
    local.get $k
    i32.const 2
    i32.const 107
    i32.const 32
    i32.const 105
    i32.const 115
    i32.const 32
    i32.const 50
    i32.const 32
    i32.const 97
    i32.const 102
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 116
    i32.const 119
    i32.const 111
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 115
    array.new_fixed $WasmStr 22
    call $equal
  )
  (func $closure_251 (param $self (ref $AnyFn)) (param $op_2 (ref $WasmTests_TestsClosures_ClosureTests_Op)) (result i32)
    (local $lo_clo_139 (ref $ClosureBase_47))
    local.get $op_2
    struct.get $WasmTests_TestsClosures_ClosureTests_Op 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $op_2
      ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Op#1)
      struct.get $WasmTests_TestsClosures_ClosureTests_Op#1 1
      i32.const 2
      i32.shl
    else
      local.get $op_2
      struct.get $WasmTests_TestsClosures_ClosureTests_Op 0
      i32.const 2
      i32.eq
      if (result i32)
        local.get $op_2
        ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Op#2)
        struct.get $WasmTests_TestsClosures_ClosureTests_Op#2 1
        ref.cast (ref $ClosureBase_47)
        local.set $lo_clo_139
        local.get $lo_clo_139
        i32.const 4
        local.get $lo_clo_139
        struct.get $ClosureBase_47 0
        call_ref $FuncType_46
      else
        i32.const 4
        local.get $op_2
        ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Op#0)
        struct.get $WasmTests_TestsClosures_ClosureTests_Op#0 1
        i32.add
      end
    end
  )
  (func $closure_255 (param $self (ref $AnyFn)) (param $x_35 i32) (result i32)
    local.get $x_35
    local.get $x_35
    i32.mul
  )
  (func $closure_256 (param $self (ref $AnyFn)) (param $x_35 i32) (result i32)
    local.get $x_35
    local.get $x_35
    i32.mul
  )
  (func $body_48_251 (param $self (ref $AnyFn))
    (local $w183 (ref null $ListBase))
    (local $w181 (ref null $ListBase))
    (local $w182 (ref null $ListBase))
    (local $op_2 (ref $WasmTests_TestsClosures_ClosureTests_Op))
    (local $lo_clo_140 (ref $ClosureBase_47))
    (local $w184 (ref null $ListBase))
    i32.const 0
    i32.const 5
    struct.new $WasmTests_TestsClosures_ClosureTests_Op#0
    i32.const 1
    i32.const 3
    struct.new $WasmTests_TestsClosures_ClosureTests_Op#1
    i32.const 2
    ref.func $closure_256
    struct.new $ClosureType_256
    struct.new $WasmTests_TestsClosures_ClosureTests_Op#2
    ref.null $ListBase
    struct.new $ListCons_254
    struct.new $ListCons_254
    struct.new $ListCons_254
    local.set $w181
    ref.null $ListBase
    local.set $w182
    block $while_lp_70_exit
      loop $while_lp_70
        local.get $w181
        ref.is_null
        i32.eqz
        if
          local.get $w181
          ref.cast (ref $ListCons_254)
          struct.get $ListCons_254 0
          local.set $op_2
          local.get $op_2
          struct.get $WasmTests_TestsClosures_ClosureTests_Op 0
          i32.const 1
          i32.eq
          if (result i32)
            local.get $op_2
            ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Op#1)
            struct.get $WasmTests_TestsClosures_ClosureTests_Op#1 1
            i32.const 2
            i32.shl
          else
            local.get $op_2
            struct.get $WasmTests_TestsClosures_ClosureTests_Op 0
            i32.const 2
            i32.eq
            if (result i32)
              local.get $op_2
              ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Op#2)
              struct.get $WasmTests_TestsClosures_ClosureTests_Op#2 1
              ref.cast (ref $ClosureBase_47)
              local.set $lo_clo_140
              local.get $lo_clo_140
              i32.const 4
              local.get $lo_clo_140
              struct.get $ClosureBase_47 0
              call_ref $FuncType_46
            else
              i32.const 4
              local.get $op_2
              ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Op#0)
              struct.get $WasmTests_TestsClosures_ClosureTests_Op#0 1
              i32.add
            end
          end
          local.get $w182
          struct.new $ListCons_22
          local.set $w182
          local.get $w181
          ref.cast (ref $ListCons_254)
          struct.get $ListCons_254 1
          local.set $w181
          br $while_lp_70
        else
          br $while_lp_70_exit
        end
      end
    end
    local.get $w182
    local.set $w183
    ref.null $ListBase
    local.set $w184
    block $while_lp_71_exit
      loop $while_lp_71
        local.get $w183
        ref.is_null
        i32.eqz
        if
          local.get $w183
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w184
          struct.new $ListCons_22
          local.set $w184
          local.get $w183
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w183
          br $while_lp_71
        else
          br $while_lp_71_exit
        end
      end
    end
    local.get $w184
    i32.const 9
    i32.const 12
    i32.const 16
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 68
    i32.const 85
    i32.const 32
    i32.const 111
    i32.const 112
    i32.const 115
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 116
    i32.const 111
    i32.const 32
    i32.const 52
    i32.const 58
    i32.const 32
    i32.const 91
    i32.const 52
    i32.const 43
    i32.const 53
    i32.const 61
    i32.const 57
    i32.const 59
    i32.const 32
    i32.const 52
    i32.const 42
    i32.const 51
    i32.const 61
    i32.const 49
    i32.const 50
    i32.const 59
    i32.const 32
    i32.const 52
    i32.const 94
    i32.const 50
    i32.const 61
    i32.const 49
    i32.const 54
    i32.const 93
    array.new_fixed $WasmStr 44
    call $sequenceEqual
  )
  (func $closure_258 (param $self (ref $AnyFn)) (param $acc_2 i32) (param $_arg (ref $WasmTests_TestsClosures_ClosureTests_Transform)) (result i32)
    (local $lo_clo_141 (ref $ClosureBase_47))
    local.get $_arg
    ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Transform#0)
    struct.get $WasmTests_TestsClosures_ClosureTests_Transform#0 1
    ref.cast (ref $ClosureBase_47)
    local.set $lo_clo_141
    local.get $lo_clo_141
    local.get $acc_2
    local.get $lo_clo_141
    struct.get $ClosureBase_47 0
    call_ref $FuncType_46
  )
  (func $closure_262 (param $self (ref $AnyFn)) (param $x_36 i32) (result i32)
    local.get $x_36
    i32.const 1
    i32.add
  )
  (func $closure_263 (param $self (ref $AnyFn)) (param $x_37 i32) (result i32)
    local.get $x_37
    i32.const 1
    i32.shl
  )
  (func $closure_264 (param $self (ref $AnyFn)) (param $x_38 i32) (result i32)
    local.get $x_38
    i32.const 3
    i32.sub
  )
  (func $closure_265 (param $self (ref $AnyFn)) (param $x_36 i32) (result i32)
    local.get $x_36
    i32.const 1
    i32.add
  )
  (func $closure_266 (param $self (ref $AnyFn)) (param $x_37 i32) (result i32)
    local.get $x_37
    i32.const 1
    i32.shl
  )
  (func $closure_267 (param $self (ref $AnyFn)) (param $x_38 i32) (result i32)
    local.get $x_38
    i32.const 3
    i32.sub
  )
  (func $body_49_258 (param $self (ref $AnyFn))
    (local $w185 (ref null $ListBase))
    (local $w186 i32)
    (local $_arg (ref $WasmTests_TestsClosures_ClosureTests_Transform))
    (local $lo_clo_142 (ref $ClosureBase_47))
    i32.const 0
    ref.func $closure_265
    struct.new $ClosureType_265
    struct.new $WasmTests_TestsClosures_ClosureTests_Transform#0
    i32.const 0
    ref.func $closure_266
    struct.new $ClosureType_266
    struct.new $WasmTests_TestsClosures_ClosureTests_Transform#0
    i32.const 0
    ref.func $closure_267
    struct.new $ClosureType_267
    struct.new $WasmTests_TestsClosures_ClosureTests_Transform#0
    ref.null $ListBase
    struct.new $ListCons_261
    struct.new $ListCons_261
    struct.new $ListCons_261
    local.set $w185
    i32.const 5
    local.set $w186
    block $while_lp_72_exit
      loop $while_lp_72
        local.get $w185
        ref.is_null
        i32.eqz
        if
          local.get $w185
          ref.cast (ref $ListCons_261)
          struct.get $ListCons_261 0
          local.set $_arg
          local.get $_arg
          ref.cast (ref $WasmTests_TestsClosures_ClosureTests_Transform#0)
          struct.get $WasmTests_TestsClosures_ClosureTests_Transform#0 1
          ref.cast (ref $ClosureBase_47)
          local.set $lo_clo_142
          local.get $lo_clo_142
          local.get $w186
          local.get $lo_clo_142
          struct.get $ClosureBase_47 0
          call_ref $FuncType_46
          local.set $w186
          local.get $w185
          ref.cast (ref $ListCons_261)
          struct.get $ListCons_261 1
          local.set $w185
          br $while_lp_72
        else
          br $while_lp_72_exit
        end
      end
    end
    local.get $w186
    i32.const 9
    i32.const 112
    i32.const 105
    i32.const 112
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 110
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 102
    i32.const 32
    i32.const 116
    i32.const 114
    i32.const 97
    i32.const 110
    i32.const 115
    i32.const 102
    i32.const 111
    i32.const 114
    i32.const 109
    i32.const 115
    array.new_fixed $WasmStr 22
    call $equal
  )
  (func $closure_269 (param $self (ref $AnyFn)) (result (ref null $Option_23))
    (local $self_cast (ref $ClosureType_271))
    (local $current i32)
    local.get $self
    ref.cast (ref $ClosureType_271)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_271 1
    local.set $current
    local.get $current
    i32.const 5
    i32.gt_s
    if (result (ref null $Option_23))
      ref.null $Option_23
    else
      local.get $current
      i32.const 1
      i32.add
      local.set $current
      local.get $current
      struct.new $Option_23
    end
  )
  (func $body_50_269 (param $self (ref $AnyFn))
    (local $next (ref $ClosureType_271))
    (local $current i32)
    (local $lo_clo_143 (ref $ClosureBase_270))
    (local $lo_clo_144 (ref $ClosureBase_270))
    (local $lo_clo_145 (ref $ClosureBase_270))
    (local $lo_clo_146 (ref $ClosureBase_270))
    (local $lo_clo_147 (ref $ClosureBase_270))
    (local $lo_clo_148 (ref $ClosureBase_270))
    i32.const 1
    local.set $current
    ref.func $closure_269
    local.get $current
    struct.new $ClosureType_271
    local.set $next
    local.get $next
    ref.cast (ref $ClosureBase_270)
    local.set $lo_clo_143
    local.get $lo_clo_143
    local.get $lo_clo_143
    struct.get $ClosureBase_270 0
    call_ref $FuncType_269
    i32.const 1
    struct.new $Option_23
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 49
    array.new_fixed $WasmStr 6
    call $equal
    local.get $next
    ref.cast (ref $ClosureBase_270)
    local.set $lo_clo_144
    local.get $lo_clo_144
    local.get $lo_clo_144
    struct.get $ClosureBase_270 0
    call_ref $FuncType_269
    i32.const 2
    struct.new $Option_23
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 50
    array.new_fixed $WasmStr 6
    call $equal
    local.get $next
    ref.cast (ref $ClosureBase_270)
    local.set $lo_clo_145
    local.get $lo_clo_145
    local.get $lo_clo_145
    struct.get $ClosureBase_270 0
    call_ref $FuncType_269
    i32.const 3
    struct.new $Option_23
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 51
    array.new_fixed $WasmStr 6
    call $equal
    local.get $next
    ref.cast (ref $ClosureBase_270)
    local.set $lo_clo_146
    local.get $lo_clo_146
    local.get $lo_clo_146
    struct.get $ClosureBase_270 0
    call_ref $FuncType_269
    i32.const 4
    struct.new $Option_23
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 52
    array.new_fixed $WasmStr 6
    call $equal
    local.get $next
    ref.cast (ref $ClosureBase_270)
    local.set $lo_clo_147
    local.get $lo_clo_147
    local.get $lo_clo_147
    struct.get $ClosureBase_270 0
    call_ref $FuncType_269
    i32.const 5
    struct.new $Option_23
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 53
    array.new_fixed $WasmStr 6
    call $equal
    local.get $next
    ref.cast (ref $ClosureBase_270)
    local.set $lo_clo_148
    local.get $lo_clo_148
    local.get $lo_clo_148
    struct.get $ClosureBase_270 0
    call_ref $FuncType_269
    ref.null $Option_23
    i32.const 101
    i32.const 120
    i32.const 104
    i32.const 97
    i32.const 117
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 100
    array.new_fixed $WasmStr 9
    call $equal
  )
  (func $closure_273 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_273))
    (local $a_8 i32)
    (local $b_8 i32)
    (local $next_1 i32)
    local.get $self
    ref.cast (ref $ClosureType_273)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_273 1
    local.set $a_8
    local.get $self_cast
    struct.get $ClosureType_273 2
    local.set $b_8
    local.get $a_8
    local.get $b_8
    i32.add
    local.set $next_1
    local.get $b_8
    local.set $a_8
    local.get $next_1
    local.set $b_8
    local.get $a_8
  )
  (func $closure_274 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_274))
    (local $next_2 (ref $AnyFn))
    (local $lo_clo_149 (ref $ClosureBase_145))
    local.get $self
    ref.cast (ref $ClosureType_274)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_274 1
    local.set $next_2
    local.get $next_2
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_149
    local.get $lo_clo_149
    local.get $lo_clo_149
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
  )
  (func $closure_275 (param $self (ref $AnyFn)) (param $_arg_1 i32) (result i32)
    (local $self_cast (ref $ClosureType_275))
    (local $next_2 (ref $AnyFn))
    (local $lo_clo_150 (ref $ClosureBase_145))
    local.get $self
    ref.cast (ref $ClosureType_275)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_275 1
    local.set $next_2
    local.get $next_2
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_150
    local.get $lo_clo_150
    local.get $lo_clo_150
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
  )
  (func $collect_i32 (param $n i32) (param $f (ref $AnyFn)) (result (ref null $ListBase))
    (local $acc (ref null $ListBase))
    (local $i i32)
    (local $limit i32)
    (local $lo_clo_151 (ref $ClosureBase_47))
    ref.null $ListBase
    local.set $acc
    local.get $n
    i32.const 1
    i32.sub
    local.set $i
    i32.const 0
    local.set $limit
    loop $for
      local.get $i
      local.get $limit
      i32.ge_s
      if
        local.get $f
        ref.cast (ref $ClosureBase_47)
        local.set $lo_clo_151
        local.get $lo_clo_151
        local.get $i
        local.get $lo_clo_151
        struct.get $ClosureBase_47 0
        call_ref $FuncType_46
        local.get $acc
        struct.new $ListCons_22
        local.set $acc
        local.get $i
        i32.const 1
        i32.sub
        local.set $i
        br $for
      end
    end
    local.get $acc
  )
  (func $body_51_273 (param $self (ref $AnyFn))
    (local $next_2 (ref $ClosureType_273))
    (local $a_8 i32)
    (local $b_8 i32)
    i32.const 0
    local.set $a_8
    i32.const 1
    local.set $b_8
    ref.func $closure_273
    local.get $a_8
    local.get $b_8
    struct.new $ClosureType_273
    local.set $next_2
    i32.const 8
    ref.func $closure_275
    local.get $next_2
    struct.new $ClosureType_275
    call $collect_i32
    i32.const 0
    i32.const 1
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 5
    i32.const 8
    i32.const 13
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 102
    i32.const 105
    i32.const 98
    i32.const 32
    i32.const 103
    i32.const 101
    i32.const 110
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 58
    i32.const 32
    i32.const 48
    i32.const 32
    i32.const 49
    i32.const 32
    i32.const 49
    i32.const 32
    i32.const 50
    i32.const 32
    i32.const 51
    i32.const 32
    i32.const 53
    i32.const 32
    i32.const 56
    i32.const 32
    i32.const 49
    i32.const 51
    array.new_fixed $WasmStr 31
    call $sequenceEqual
  )
  (func $closure_277 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_277))
    (local $n_15 i32)
    local.get $self
    ref.cast (ref $ClosureType_277)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_277 1
    local.set $n_15
    local.get $n_15
    i32.const 1
    i32.add
    local.set $n_15
    local.get $n_15
  )
  (func $closure_277 (param $self (ref $AnyFn)) (param $start i32) (result (ref $AnyFn))
    (local $n_15 i32)
    local.get $start
    local.set $n_15
    ref.func $closure_277
    local.get $n_15
    struct.new $ClosureType_277
  )
  (func $body_52_277 (param $self (ref $AnyFn))
    (local $makeCounter_1 (ref $ClosureType_278))
    (local $c1_1 (ref $AnyFn))
    (local $lo_clo_152 (ref $ClosureBase_174))
    (local $c2_1 (ref $AnyFn))
    (local $lo_clo_153 (ref $ClosureBase_174))
    (local $lo_clo_154 (ref $ClosureBase_145))
    (local $lo_clo_155 (ref $ClosureBase_145))
    (local $lo_clo_156 (ref $ClosureBase_145))
    (local $lo_clo_157 (ref $ClosureBase_145))
    (local $lo_clo_158 (ref $ClosureBase_145))
    ref.func $closure_277
    struct.new $ClosureType_278
    local.set $makeCounter_1
    local.get $makeCounter_1
    ref.cast (ref $ClosureBase_174)
    local.set $lo_clo_152
    local.get $lo_clo_152
    i32.const 0
    local.get $lo_clo_152
    struct.get $ClosureBase_174 0
    call_ref $FuncType_173
    local.set $c1_1
    local.get $makeCounter_1
    ref.cast (ref $ClosureBase_174)
    local.set $lo_clo_153
    local.get $lo_clo_153
    i32.const 100
    local.get $lo_clo_153
    struct.get $ClosureBase_174 0
    call_ref $FuncType_173
    local.set $c2_1
    local.get $c1_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_154
    local.get $lo_clo_154
    local.get $lo_clo_154
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 1
    i32.const 99
    i32.const 49
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 49
    array.new_fixed $WasmStr 9
    call $equal
    local.get $c2_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_155
    local.get $lo_clo_155
    local.get $lo_clo_155
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 101
    i32.const 99
    i32.const 50
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 49
    array.new_fixed $WasmStr 9
    call $equal
    local.get $c1_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_156
    local.get $lo_clo_156
    local.get $lo_clo_156
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 2
    i32.const 99
    i32.const 49
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 50
    array.new_fixed $WasmStr 9
    call $equal
    local.get $c2_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_157
    local.get $lo_clo_157
    local.get $lo_clo_157
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 102
    i32.const 99
    i32.const 50
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 50
    array.new_fixed $WasmStr 9
    call $equal
    local.get $c1_1
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_158
    local.get $lo_clo_158
    local.get $lo_clo_158
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
    i32.const 3
    i32.const 99
    i32.const 49
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 51
    array.new_fixed $WasmStr 9
    call $equal
  )
  (func $closure_280 (param $self (ref $AnyFn)) (param $f_14 (ref $AnyFn)) (result i32)
    (local $lo_clo_159 (ref $ClosureBase_145))
    local.get $f_14
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_159
    local.get $lo_clo_159
    local.get $lo_clo_159
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
  )
  (func $closure_281 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_281))
    (local $n_16 i32)
    local.get $self
    ref.cast (ref $ClosureType_281)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_281 1
    local.set $n_16
    local.get $n_16
    i32.const 1
    i32.add
    local.set $n_16
    local.get $n_16
  )
  (func $closure_281 (param $self (ref $AnyFn)) (param $i_3 i32) (result (ref $AnyFn))
    (local $n_16 i32)
    local.get $i_3
    i32.const 100
    i32.mul
    local.set $n_16
    ref.func $closure_281
    local.get $n_16
    struct.new $ClosureType_281
  )
  (func $closure_283 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_283))
    (local $n_16 i32)
    local.get $self
    ref.cast (ref $ClosureType_283)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_283 1
    local.set $n_16
    local.get $n_16
    i32.const 1
    i32.add
    local.set $n_16
    local.get $n_16
  )
  (func $closure_281 (param $self (ref $AnyFn)) (result i32)
    (local $w189 (ref null $ListBase))
    (local $w187 (ref null $ListBase))
    (local $w188 (ref null $ListBase))
    (local $i_3 i32)
    (local $n_16 i32)
    (local $w190 (ref null $ListBase))
    local.set $w187
    ref.null $ListBase
    local.set $w188
    block $while_lp_73_exit
      loop $while_lp_73
        local.get $w187
        ref.is_null
        i32.eqz
        if
          local.get $w187
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $i_3
          local.get $i_3
          i32.const 100
          i32.mul
          local.set $n_16
          ref.func $closure_283
          local.get $n_16
          struct.new $ClosureType_283
          local.get $w188
          struct.new $ListCons_171
          local.set $w188
          local.get $w187
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w187
          br $while_lp_73
        else
          br $while_lp_73_exit
        end
      end
    end
    local.get $w188
    local.set $w189
    ref.null $ListBase
    local.set $w190
    block $while_lp_74_exit
      loop $while_lp_74
        local.get $w189
        ref.is_null
        i32.eqz
        if
          local.get $w189
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.get $w190
          struct.new $ListCons_171
          local.set $w190
          local.get $w189
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w189
          br $while_lp_74
        else
          br $while_lp_74_exit
        end
      end
    end
    local.get $w190
  )
  (func $closure_285 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_285))
    (local $n_16 i32)
    local.get $self
    ref.cast (ref $ClosureType_285)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_285 1
    local.set $n_16
    local.get $n_16
    i32.const 1
    i32.add
    local.set $n_16
    local.get $n_16
  )
  (func $closure_285 (param $self (ref $AnyFn)) (param $i_3 i32) (result (ref $AnyFn))
    (local $n_16 i32)
    local.get $i_3
    i32.const 100
    i32.mul
    local.set $n_16
    ref.func $closure_285
    local.get $n_16
    struct.new $ClosureType_285
  )
  (func $closure_287 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_287))
    (local $n_16 i32)
    local.get $self
    ref.cast (ref $ClosureType_287)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_287 1
    local.set $n_16
    local.get $n_16
    i32.const 1
    i32.add
    local.set $n_16
    local.get $n_16
  )
  (func $closure_285 (param $self (ref $AnyFn)) (result i32)
    (local $w193 (ref null $ListBase))
    (local $w191 (ref null $ListBase))
    (local $w192 (ref null $ListBase))
    (local $i_3 i32)
    (local $n_16 i32)
    (local $w194 (ref null $ListBase))
    local.set $w191
    ref.null $ListBase
    local.set $w192
    block $while_lp_75_exit
      loop $while_lp_75
        local.get $w191
        ref.is_null
        i32.eqz
        if
          local.get $w191
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $i_3
          local.get $i_3
          i32.const 100
          i32.mul
          local.set $n_16
          ref.func $closure_287
          local.get $n_16
          struct.new $ClosureType_287
          local.get $w192
          struct.new $ListCons_171
          local.set $w192
          local.get $w191
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w191
          br $while_lp_75
        else
          br $while_lp_75_exit
        end
      end
    end
    local.get $w192
    local.set $w193
    ref.null $ListBase
    local.set $w194
    block $while_lp_76_exit
      loop $while_lp_76
        local.get $w193
        ref.is_null
        i32.eqz
        if
          local.get $w193
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.get $w194
          struct.new $ListCons_171
          local.set $w194
          local.get $w193
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w193
          br $while_lp_76
        else
          br $while_lp_76_exit
        end
      end
    end
    local.get $w194
  )
  (func $closure_289 (param $self (ref $AnyFn)) (param $i_4 i32) (result i32)
    local.get $i_4
    i32.const 100
    i32.mul
    i32.const 1
    i32.add
  )
  (func $closure_289 (param $self (ref $AnyFn)) (result i32)
    (local $w201 (ref null $ListBase))
    (local $w199 (ref null $ListBase))
    (local $w200 (ref null $ListBase))
    (local $i_4 i32)
    (local $w202 (ref null $ListBase))
    local.set $w199
    ref.null $ListBase
    local.set $w200
    block $while_lp_79_exit
      loop $while_lp_79
        local.get $w199
        ref.is_null
        i32.eqz
        if
          local.get $w199
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $i_4
          local.get $i_4
          i32.const 100
          i32.mul
          i32.const 1
          i32.add
          local.get $w200
          struct.new $ListCons_22
          local.set $w200
          local.get $w199
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w199
          br $while_lp_79
        else
          br $while_lp_79_exit
        end
      end
    end
    local.get $w200
    local.set $w201
    ref.null $ListBase
    local.set $w202
    block $while_lp_80_exit
      loop $while_lp_80
        local.get $w201
        ref.is_null
        i32.eqz
        if
          local.get $w201
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w202
          struct.new $ListCons_22
          local.set $w202
          local.get $w201
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w201
          br $while_lp_80
        else
          br $while_lp_80_exit
        end
      end
    end
    local.get $w202
  )
  (func $body_53_280 (param $self (ref $AnyFn))
    (local $w197 (ref null $ListBase))
    (local $w195 (ref null $ListBase))
    (local $w196 (ref null $ListBase))
    (local $f_14 (ref $AnyFn))
    (local $lo_clo_160 (ref $ClosureBase_145))
    (local $w198 (ref null $ListBase))
    local.set $w195
    ref.null $ListBase
    local.set $w196
    block $while_lp_77_exit
      loop $while_lp_77
        local.get $w195
        ref.is_null
        i32.eqz
        if
          local.get $w195
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.set $f_14
          local.get $f_14
          ref.cast (ref $ClosureBase_145)
          local.set $lo_clo_160
          local.get $lo_clo_160
          local.get $lo_clo_160
          struct.get $ClosureBase_145 0
          call_ref $FuncType_144
          local.get $w196
          struct.new $ListCons_22
          local.set $w196
          local.get $w195
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w195
          br $while_lp_77
        else
          br $while_lp_77_exit
        end
      end
    end
    local.get $w196
    local.set $w197
    ref.null $ListBase
    local.set $w198
    block $while_lp_78_exit
      loop $while_lp_78
        local.get $w197
        ref.is_null
        i32.eqz
        if
          local.get $w197
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w198
          struct.new $ListCons_22
          local.set $w198
          local.get $w197
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w197
          br $while_lp_78
        else
          br $while_lp_78_exit
        end
      end
    end
    local.get $w198
    i32.const 49
    i32.const 48
    i32.const 48
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 117
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 115
    array.new_fixed $WasmStr 24
    call $sequenceEqual
  )
  (func $closure_292 (param $self (ref $AnyFn)) (param $i_5 i32) (result i32)
    local.get $i_5
  )
  (func $closure_292 (param $self (ref $AnyFn)) (result i32)
    (local $w205 (ref null $ListBase))
    (local $w203 (ref null $ListBase))
    (local $w204 (ref null $ListBase))
    (local $i_5 i32)
    (local $w206 (ref null $ListBase))
    local.set $w203
    ref.null $ListBase
    local.set $w204
    block $while_lp_81_exit
      loop $while_lp_81
        local.get $w203
        ref.is_null
        i32.eqz
        if
          local.get $w203
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $i_5
          local.get $i_5
          local.get $w204
          struct.new $ListCons_22
          local.set $w204
          local.get $w203
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w203
          br $while_lp_81
        else
          br $while_lp_81_exit
        end
      end
    end
    local.get $w204
    local.set $w205
    ref.null $ListBase
    local.set $w206
    block $while_lp_82_exit
      loop $while_lp_82
        local.get $w205
        ref.is_null
        i32.eqz
        if
          local.get $w205
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w206
          struct.new $ListCons_22
          local.set $w206
          local.get $w205
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w205
          br $while_lp_82
        else
          br $while_lp_82_exit
        end
      end
    end
    local.get $w206
  )
  (func $closure_294 (param $self (ref $AnyFn)) (param $x_39 i32) (param $y_5 i32) (result i32)
    local.get $x_39
    local.get $y_5
    i32.add
  )
  (func $body_54_292 (param $self (ref $AnyFn))
    (local $data_1 (ref null $ListBase))
    (local $w207 (ref null $ListBase))
    (local $w208 i32)
    (local $y_5 i32)
    (local $w209 (ref null $ListBase))
    (local $w210 i32)
    local.set $data_1
    local.get $data_1
    local.set $w207
    i32.const 0
    local.set $w208
    block $while_lp_83_exit
      loop $while_lp_83
        local.get $w207
        ref.is_null
        i32.eqz
        if
          local.get $w207
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_5
          local.get $w208
          local.get $y_5
          i32.add
          local.set $w208
          local.get $w207
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w207
          br $while_lp_83
        else
          br $while_lp_83_exit
        end
      end
    end
    local.get $w208
    i32.const 1275
    i32.const 115
    i32.const 117
    i32.const 109
    i32.const 32
    i32.const 49
    i32.const 46
    i32.const 46
    i32.const 53
    i32.const 48
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 49
    i32.const 50
    i32.const 55
    i32.const 53
    array.new_fixed $WasmStr 16
    call $equal
    local.get $data_1
    local.set $w209
    i32.const 0
    local.set $w210
    block $while_lp_84_exit
      loop $while_lp_84
        local.get $w209
        ref.is_null
        i32.eqz
        if
          local.get $w210
          i32.const 1
          i32.add
          local.set $w210
          local.get $w209
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w209
          br $while_lp_84
        else
          br $while_lp_84_exit
        end
      end
    end
    local.get $w210
    i32.const 50
    i32.const 108
    i32.const 101
    i32.const 110
    i32.const 103
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 53
    i32.const 48
    array.new_fixed $WasmStr 11
    call $equal
  )
  (func $closure_296 (param $self (ref $AnyFn)) (param $f_15 (ref $AnyFn)) (result i32)
    (local $lo_clo_161 (ref $ClosureBase_145))
    local.get $f_15
    ref.cast (ref $ClosureBase_145)
    local.set $lo_clo_161
    local.get $lo_clo_161
    local.get $lo_clo_161
    struct.get $ClosureBase_145 0
    call_ref $FuncType_144
  )
  (func $closure_297 (param $self (ref $AnyFn)) (param $x_40 i32) (param $y_6 i32) (result i32)
    local.get $x_40
    local.get $y_6
    i32.add
  )
  (func $closure_297 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_298))
    (local $slice (ref null $ListBase))
    (local $w211 (ref null $ListBase))
    (local $w212 i32)
    (local $y_6 i32)
    local.get $self
    ref.cast (ref $ClosureType_298)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_298 1
    local.set $slice
    local.get $slice
    local.set $w211
    i32.const 0
    local.set $w212
    block $while_lp_85_exit
      loop $while_lp_85
        local.get $w211
        ref.is_null
        i32.eqz
        if
          local.get $w211
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_6
          local.get $w212
          local.get $y_6
          i32.add
          local.set $w212
          local.get $w211
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w211
          br $while_lp_85
        else
          br $while_lp_85_exit
        end
      end
    end
    local.get $w212
  )
  (func $closure_297 (param $self (ref $AnyFn)) (param $start_1 i32) (result (ref $AnyFn))
    (local $slice (ref null $ListBase))
    local.get $start_1
    local.get $start_1
    i32.const 1
    i32.add
    local.get $start_1
    i32.const 2
    i32.add
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $slice
    ref.func $closure_297
    local.get $slice
    struct.new $ClosureType_298
  )
  (func $closure_300 (param $self (ref $AnyFn)) (param $x_40 i32) (param $y_6 i32) (result i32)
    local.get $x_40
    local.get $y_6
    i32.add
  )
  (func $closure_300 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_301))
    (local $slice (ref null $ListBase))
    (local $w213 (ref null $ListBase))
    (local $w214 i32)
    (local $y_6 i32)
    local.get $self
    ref.cast (ref $ClosureType_301)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_301 1
    local.set $slice
    local.get $slice
    local.set $w213
    i32.const 0
    local.set $w214
    block $while_lp_86_exit
      loop $while_lp_86
        local.get $w213
        ref.is_null
        i32.eqz
        if
          local.get $w213
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_6
          local.get $w214
          local.get $y_6
          i32.add
          local.set $w214
          local.get $w213
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w213
          br $while_lp_86
        else
          br $while_lp_86_exit
        end
      end
    end
    local.get $w214
  )
  (func $closure_297 (param $self (ref $AnyFn)) (result i32)
    (local $w217 (ref null $ListBase))
    (local $w215 (ref null $ListBase))
    (local $w216 (ref null $ListBase))
    (local $start_1 i32)
    (local $slice (ref null $ListBase))
    (local $w218 (ref null $ListBase))
    i32.const 0
    i32.const 3
    i32.const 6
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w215
    ref.null $ListBase
    local.set $w216
    block $while_lp_87_exit
      loop $while_lp_87
        local.get $w215
        ref.is_null
        i32.eqz
        if
          local.get $w215
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $start_1
          local.get $start_1
          local.get $start_1
          i32.const 1
          i32.add
          local.get $start_1
          i32.const 2
          i32.add
          ref.null $ListBase
          struct.new $ListCons_22
          struct.new $ListCons_22
          struct.new $ListCons_22
          local.set $slice
          ref.func $closure_300
          local.get $slice
          struct.new $ClosureType_301
          local.get $w216
          struct.new $ListCons_171
          local.set $w216
          local.get $w215
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w215
          br $while_lp_87
        else
          br $while_lp_87_exit
        end
      end
    end
    local.get $w216
    local.set $w217
    ref.null $ListBase
    local.set $w218
    block $while_lp_88_exit
      loop $while_lp_88
        local.get $w217
        ref.is_null
        i32.eqz
        if
          local.get $w217
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.get $w218
          struct.new $ListCons_171
          local.set $w218
          local.get $w217
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w217
          br $while_lp_88
        else
          br $while_lp_88_exit
        end
      end
    end
    local.get $w218
  )
  (func $closure_303 (param $self (ref $AnyFn)) (param $x_40 i32) (param $y_6 i32) (result i32)
    local.get $x_40
    local.get $y_6
    i32.add
  )
  (func $closure_303 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_304))
    (local $slice (ref null $ListBase))
    (local $w219 (ref null $ListBase))
    (local $w220 i32)
    (local $y_6 i32)
    local.get $self
    ref.cast (ref $ClosureType_304)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_304 1
    local.set $slice
    local.get $slice
    local.set $w219
    i32.const 0
    local.set $w220
    block $while_lp_89_exit
      loop $while_lp_89
        local.get $w219
        ref.is_null
        i32.eqz
        if
          local.get $w219
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_6
          local.get $w220
          local.get $y_6
          i32.add
          local.set $w220
          local.get $w219
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w219
          br $while_lp_89
        else
          br $while_lp_89_exit
        end
      end
    end
    local.get $w220
  )
  (func $closure_303 (param $self (ref $AnyFn)) (param $start_1 i32) (result (ref $AnyFn))
    (local $slice (ref null $ListBase))
    local.get $start_1
    local.get $start_1
    i32.const 1
    i32.add
    local.get $start_1
    i32.const 2
    i32.add
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $slice
    ref.func $closure_303
    local.get $slice
    struct.new $ClosureType_304
  )
  (func $closure_306 (param $self (ref $AnyFn)) (param $x_40 i32) (param $y_6 i32) (result i32)
    local.get $x_40
    local.get $y_6
    i32.add
  )
  (func $closure_306 (param $self (ref $AnyFn)) (result i32)
    (local $self_cast (ref $ClosureType_307))
    (local $slice (ref null $ListBase))
    (local $w221 (ref null $ListBase))
    (local $w222 i32)
    (local $y_6 i32)
    local.get $self
    ref.cast (ref $ClosureType_307)
    local.set $self_cast
    local.get $self_cast
    struct.get $ClosureType_307 1
    local.set $slice
    local.get $slice
    local.set $w221
    i32.const 0
    local.set $w222
    block $while_lp_90_exit
      loop $while_lp_90
        local.get $w221
        ref.is_null
        i32.eqz
        if
          local.get $w221
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_6
          local.get $w222
          local.get $y_6
          i32.add
          local.set $w222
          local.get $w221
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w221
          br $while_lp_90
        else
          br $while_lp_90_exit
        end
      end
    end
    local.get $w222
  )
  (func $closure_303 (param $self (ref $AnyFn)) (result i32)
    (local $w225 (ref null $ListBase))
    (local $w223 (ref null $ListBase))
    (local $w224 (ref null $ListBase))
    (local $start_1 i32)
    (local $slice (ref null $ListBase))
    (local $w226 (ref null $ListBase))
    i32.const 0
    i32.const 3
    i32.const 6
    i32.const 9
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w223
    ref.null $ListBase
    local.set $w224
    block $while_lp_91_exit
      loop $while_lp_91
        local.get $w223
        ref.is_null
        i32.eqz
        if
          local.get $w223
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $start_1
          local.get $start_1
          local.get $start_1
          i32.const 1
          i32.add
          local.get $start_1
          i32.const 2
          i32.add
          ref.null $ListBase
          struct.new $ListCons_22
          struct.new $ListCons_22
          struct.new $ListCons_22
          local.set $slice
          ref.func $closure_306
          local.get $slice
          struct.new $ClosureType_307
          local.get $w224
          struct.new $ListCons_171
          local.set $w224
          local.get $w223
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w223
          br $while_lp_91
        else
          br $while_lp_91_exit
        end
      end
    end
    local.get $w224
    local.set $w225
    ref.null $ListBase
    local.set $w226
    block $while_lp_92_exit
      loop $while_lp_92
        local.get $w225
        ref.is_null
        i32.eqz
        if
          local.get $w225
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.get $w226
          struct.new $ListCons_171
          local.set $w226
          local.get $w225
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w225
          br $while_lp_92
        else
          br $while_lp_92_exit
        end
      end
    end
    local.get $w226
  )
  (func $body_55_296 (param $self (ref $AnyFn))
    (local $w229 (ref null $ListBase))
    (local $w227 (ref null $ListBase))
    (local $w228 (ref null $ListBase))
    (local $f_15 (ref $AnyFn))
    (local $lo_clo_162 (ref $ClosureBase_145))
    (local $w230 (ref null $ListBase))
    local.set $w227
    ref.null $ListBase
    local.set $w228
    block $while_lp_93_exit
      loop $while_lp_93
        local.get $w227
        ref.is_null
        i32.eqz
        if
          local.get $w227
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 0
          local.set $f_15
          local.get $f_15
          ref.cast (ref $ClosureBase_145)
          local.set $lo_clo_162
          local.get $lo_clo_162
          local.get $lo_clo_162
          struct.get $ClosureBase_145 0
          call_ref $FuncType_144
          local.get $w228
          struct.new $ListCons_22
          local.set $w228
          local.get $w227
          ref.cast (ref $ListCons_171)
          struct.get $ListCons_171 1
          local.set $w227
          br $while_lp_93
        else
          br $while_lp_93_exit
        end
      end
    end
    local.get $w228
    local.set $w229
    ref.null $ListBase
    local.set $w230
    block $while_lp_94_exit
      loop $while_lp_94
        local.get $w229
        ref.is_null
        i32.eqz
        if
          local.get $w229
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w230
          struct.new $ListCons_22
          local.set $w230
          local.get $w229
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w229
          br $while_lp_94
        else
          br $while_lp_94_exit
        end
      end
    end
    local.get $w230
    i32.const 3
    i32.const 12
    i32.const 21
    i32.const 30
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 100
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 105
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 32
    i32.const 115
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 108
    i32.const 121
    array.new_fixed $WasmStr 43
    call $sequenceEqual
  )
  (func $ClosureTests_tests (result (ref $Wasmecto_Test)) ;; exported as "ClosureTests_tests"
    i32.const 67
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 38
    i32.const 32
    i32.const 67
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    array.new_fixed $WasmStr 19
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 109
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 116
    array.new_fixed $WasmStr 21
    ref.func $body_115
    struct.new $ClosureType_115
    call $testCase
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 109
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 108
    i32.const 111
    i32.const 97
    i32.const 116
    array.new_fixed $WasmStr 23
    ref.func $body_1_116
    struct.new $ClosureType_116
    call $testCase
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 109
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    array.new_fixed $WasmStr 24
    ref.func $body_2_117
    struct.new $ClosureType_117
    call $testCase
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 105
    i32.const 112
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 109
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    i32.const 115
    array.new_fixed $WasmStr 33
    ref.func $body_3_118
    struct.new $ClosureType_118
    call $testCase
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 114
    i32.const 111
    i32.const 109
    i32.const 32
    i32.const 108
    i32.const 101
    i32.const 116
    i32.const 32
    i32.const 98
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 111
    i32.const 116
    i32.const 104
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 108
    i32.const 101
    i32.const 116
    array.new_fixed $WasmStr 45
    ref.func $body_4_119
    struct.new $ClosureType_119
    call $testCase
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 116
    array.new_fixed $WasmStr 30
    ref.func $body_5_120
    struct.new $ClosureType_121
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 101
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 102
    i32.const 114
    i32.const 111
    i32.const 109
    i32.const 32
    i32.const 111
    i32.const 117
    i32.const 116
    i32.const 115
    i32.const 105
    i32.const 100
    i32.const 101
    array.new_fixed $WasmStr 34
    ref.func $body_6_122
    struct.new $ClosureType_122
    call $testCase
    i32.const 111
    i32.const 117
    i32.const 116
    i32.const 115
    i32.const 105
    i32.const 100
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 101
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 102
    i32.const 114
    i32.const 111
    i32.const 109
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 34
    ref.func $body_7_123
    struct.new $ClosureType_126
    call $testCase
    i32.const 116
    i32.const 119
    i32.const 111
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 115
    i32.const 104
    i32.const 97
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 34
    ref.func $body_8_127
    struct.new $ClosureType_128
    call $testCase
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    array.new_fixed $WasmStr 22
    ref.func $body_9_129
    struct.new $ClosureType_131
    call $testCase
    i32.const 102
    i32.const 97
    i32.const 99
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 121
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 110
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 108
    i32.const 111
    i32.const 99
    i32.const 97
    i32.const 108
    array.new_fixed $WasmStr 34
    ref.func $body_10_132
    struct.new $ClosureType_135
    call $testCase
    i32.const 102
    i32.const 97
    i32.const 99
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 121
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 102
    i32.const 108
    i32.const 111
    i32.const 97
    i32.const 116
    array.new_fixed $WasmStr 22
    ref.func $body_11_136
    struct.new $ClosureType_143
    call $testCase
    i32.const 99
    i32.const 111
    i32.const 117
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 102
    i32.const 97
    i32.const 99
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 121
    i32.const 32
    i32.const 8212
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 115
    i32.const 116
    i32.const 97
    i32.const 110
    i32.const 99
    i32.const 101
    i32.const 115
    array.new_fixed $WasmStr 39
    ref.func $body_12_144
    struct.new $ClosureType_150
    call $testCase
    i32.const 99
    i32.const 111
    i32.const 117
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 102
    i32.const 97
    i32.const 99
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 121
    i32.const 32
    i32.const 8212
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 32
    i32.const 112
    i32.const 101
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 115
    i32.const 32
    i32.const 97
    i32.const 99
    i32.const 114
    i32.const 111
    i32.const 115
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 115
    array.new_fixed $WasmStr 53
    ref.func $body_13_151
    struct.new $ClosureType_152
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 40
    i32.const 99
    i32.const 117
    i32.const 114
    i32.const 114
    i32.const 121
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 98
    i32.const 121
    i32.const 32
    i32.const 104
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 41
    array.new_fixed $WasmStr 39
    ref.func $body_14_153
    struct.new $ClosureType_155
    call $testCase
    i32.const 76
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 109
    i32.const 97
    i32.const 112
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 108
    i32.const 97
    i32.const 109
    i32.const 98
    i32.const 100
    i32.const 97
    array.new_fixed $WasmStr 30
    ref.func $body_15_156
    struct.new $ClosureType_157
    call $testCase
    i32.const 76
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 102
    i32.const 105
    i32.const 108
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 112
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 101
    array.new_fixed $WasmStr 36
    ref.func $body_16_158
    struct.new $ClosureType_159
    call $testCase
    i32.const 76
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 97
    i32.const 99
    i32.const 99
    i32.const 117
    i32.const 109
    i32.const 117
    i32.const 108
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 45
    ref.func $body_17_160
    struct.new $ClosureType_161
    call $testCase
    i32.const 76
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 101
    i32.const 120
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 115
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 112
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 101
    array.new_fixed $WasmStr 36
    ref.func $body_18_162
    struct.new $ClosureType_163
    call $testCase
    i32.const 76
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 102
    i32.const 111
    i32.const 114
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 112
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 101
    array.new_fixed $WasmStr 36
    ref.func $body_19_164
    struct.new $ClosureType_165
    call $testCase
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 98
    i32.const 97
    i32.const 99
    i32.const 107
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 101
    i32.const 105
    i32.const 118
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 100
    i32.const 32
    i32.const 117
    i32.const 112
    i32.const 100
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 46
    ref.func $body_20_166
    struct.new $ClosureType_167
    call $testCase
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 32
    i32.const 111
    i32.const 102
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 44
    i32.const 32
    i32.const 101
    i32.const 97
    i32.const 99
    i32.const 104
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 100
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 105
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 44
    ref.func $body_21_168
    struct.new $ClosureType_182
    call $testCase
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 100
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 116
    i32.const 97
    i32.const 105
    i32.const 110
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 97
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 27
    ref.func $body_22_183
    struct.new $ClosureType_183
    call $testCase
    i32.const 111
    i32.const 112
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 110
    i32.const 116
    i32.const 97
    i32.const 105
    i32.const 110
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 97
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 27
    ref.func $body_23_184
    struct.new $ClosureType_185
    call $testCase
    i32.const 112
    i32.const 97
    i32.const 114
    i32.const 116
    i32.const 105
    i32.const 97
    i32.const 108
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 111
    i32.const 102
    i32.const 32
    i32.const 50
    i32.const 45
    i32.const 97
    i32.const 114
    i32.const 103
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 37
    ref.func $body_24_186
    struct.new $ClosureType_187
    call $testCase
    i32.const 112
    i32.const 97
    i32.const 114
    i32.const 116
    i32.const 105
    i32.const 97
    i32.const 108
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 111
    i32.const 102
    i32.const 32
    i32.const 51
    i32.const 45
    i32.const 97
    i32.const 114
    i32.const 103
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 37
    ref.func $body_25_188
    struct.new $ClosureType_189
    call $testCase
    i32.const 112
    i32.const 105
    i32.const 112
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 110
    i32.const 101
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 112
    i32.const 97
    i32.const 114
    i32.const 116
    i32.const 105
    i32.const 97
    i32.const 108
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 33
    ref.func $body_26_190
    struct.new $ClosureType_191
    call $testCase
    i32.const 112
    i32.const 97
    i32.const 114
    i32.const 116
    i32.const 105
    i32.const 97
    i32.const 108
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 108
    i32.const 108
    i32.const 101
    i32.const 114
    i32.const 45
    i32.const 115
    i32.const 99
    i32.const 111
    i32.const 112
    i32.const 101
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    array.new_fixed $WasmStr 47
    ref.func $body_27_192
    struct.new $ClosureType_193
    call $testCase
    i32.const 108
    i32.const 101
    i32.const 116
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 115
    i32.const 105
    i32.const 100
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 22
    ref.func $body_28_194
    struct.new $ClosureType_195
    call $testCase
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 117
    i32.const 97
    i32.const 108
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 117
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 115
    i32.const 105
    i32.const 100
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 97
    i32.const 99
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 121
    array.new_fixed $WasmStr 31
    ref.func $body_29_196
    struct.new $ClosureType_200
    call $testCase
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 117
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 118
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 97
    i32.const 99
    i32.const 99
    i32.const 117
    i32.const 109
    i32.const 117
    i32.const 108
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    array.new_fixed $WasmStr 42
    ref.func $body_30_201
    struct.new $ClosureType_202
    call $testCase
    i32.const 70
    i32.const 105
    i32.const 98
    i32.const 111
    i32.const 110
    i32.const 97
    i32.const 99
    i32.const 99
    i32.const 105
    i32.const 32
    i32.const 118
    i32.const 105
    i32.const 97
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 117
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 118
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 31
    ref.func $body_31_203
    struct.new $ClosureType_204
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 114
    i32.const 111
    i32.const 109
    i32.const 32
    i32.const 105
    i32.const 102
    i32.const 45
    i32.const 98
    i32.const 114
    i32.const 97
    i32.const 110
    i32.const 99
    i32.const 104
    array.new_fixed $WasmStr 37
    ref.func $body_32_205
    struct.new $ClosureType_206
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 114
    i32.const 111
    i32.const 109
    i32.const 32
    i32.const 109
    i32.const 97
    i32.const 116
    i32.const 99
    i32.const 104
    array.new_fixed $WasmStr 33
    ref.func $body_33_207
    struct.new $ClosureType_213
    call $testCase
    i32.const 108
    i32.const 111
    i32.const 111
    i32.const 112
    i32.const 32
    i32.const 98
    i32.const 111
    i32.const 100
    i32.const 121
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 108
    i32.const 111
    i32.const 111
    i32.const 112
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 114
    i32.const 105
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 116
    i32.const 108
    i32.const 121
    array.new_fixed $WasmStr 50
    ref.func $body_34_214
    struct.new $ClosureType_216
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 119
    i32.const 104
    i32.const 105
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 108
    i32.const 111
    i32.const 111
    i32.const 112
    i32.const 32
    i32.const 97
    i32.const 99
    i32.const 99
    i32.const 117
    i32.const 109
    i32.const 117
    i32.const 108
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 116
    i32.const 108
    i32.const 121
    array.new_fixed $WasmStr 43
    ref.func $body_35_217
    struct.new $ClosureType_217
    call $testCase
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 111
    i32.const 115
    i32.const 101
    i32.const 58
    i32.const 32
    i32.const 40
    i32.const 102
    i32.const 32
    i32.const 62
    i32.const 62
    i32.const 32
    i32.const 103
    i32.const 41
    i32.const 32
    i32.const 120
    i32.const 32
    i32.const 61
    i32.const 32
    i32.const 103
    i32.const 40
    i32.const 102
    i32.const 40
    i32.const 120
    i32.const 41
    i32.const 41
    array.new_fixed $WasmStr 29
    ref.func $body_36_218
    struct.new $ClosureType_219
    call $testCase
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 111
    i32.const 115
    i32.const 101
    i32.const 32
    i32.const 116
    i32.const 104
    i32.const 114
    i32.const 101
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 115
    array.new_fixed $WasmStr 23
    ref.func $body_37_220
    struct.new $ClosureType_220
    call $testCase
    i32.const 102
    i32.const 108
    i32.const 105
    i32.const 112
    i32.const 58
    i32.const 32
    i32.const 115
    i32.const 119
    i32.const 97
    i32.const 112
    i32.const 32
    i32.const 97
    i32.const 114
    i32.const 103
    i32.const 117
    i32.const 109
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 115
    i32.const 32
    i32.const 111
    i32.const 102
    i32.const 32
    i32.const 97
    i32.const 32
    i32.const 50
    i32.const 45
    i32.const 97
    i32.const 114
    i32.const 103
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 40
    ref.func $body_38_221
    struct.new $ClosureType_223
    call $testCase
    i32.const 109
    i32.const 101
    i32.const 109
    i32.const 111
    i32.const 105
    i32.const 122
    i32.const 101
    i32.const 32
    i32.const 118
    i32.const 105
    i32.const 97
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 27
    ref.func $body_39_224
    struct.new $ClosureType_226
    call $testCase
    i32.const 112
    i32.const 105
    i32.const 112
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 110
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 112
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 32
    i32.const 99
    i32.const 104
    i32.const 97
    i32.const 105
    i32.const 110
    i32.const 115
    i32.const 32
    i32.const 119
    i32.const 105
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    i32.const 115
    array.new_fixed $WasmStr 45
    ref.func $body_40_227
    struct.new $ClosureType_234
    call $testCase
    i32.const 51
    i32.const 45
    i32.const 108
    i32.const 101
    i32.const 118
    i32.const 101
    i32.const 108
    i32.const 32
    i32.const 100
    i32.const 101
    i32.const 101
    i32.const 112
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 104
    i32.const 97
    i32.const 105
    i32.const 110
    array.new_fixed $WasmStr 26
    ref.func $body_41_235
    struct.new $ClosureType_237
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 111
    i32.const 116
    i32.const 104
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 33
    ref.func $body_42_238
    struct.new $ClosureType_241
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 116
    i32.const 117
    i32.const 112
    i32.const 108
    i32.const 101
    array.new_fixed $WasmStr 22
    ref.func $body_43_242
    struct.new $ClosureType_242
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    array.new_fixed $WasmStr 21
    ref.func $body_44_243
    struct.new $ClosureType_244
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 100
    array.new_fixed $WasmStr 23
    ref.func $body_45_245
    struct.new $ClosureType_246
    call $testCase
    i32.const 116
    i32.const 119
    i32.const 111
    i32.const 32
    i32.const 97
    i32.const 108
    i32.const 105
    i32.const 97
    i32.const 115
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 116
    i32.const 111
    i32.const 32
    i32.const 115
    i32.const 97
    i32.const 109
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 104
    i32.const 97
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    array.new_fixed $WasmStr 39
    ref.func $body_46_247
    struct.new $ClosureType_248
    call $testCase
    i32.const 112
    i32.const 97
    i32.const 115
    i32.const 115
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 116
    i32.const 111
    i32.const 32
    i32.const 97
    i32.const 110
    i32.const 111
    i32.const 116
    i32.const 104
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 112
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 101
    i32.const 114
    i32.const 118
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 53
    ref.func $body_47_249
    struct.new $ClosureType_250
    call $testCase
    i32.const 68
    i32.const 85
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 114
    i32.const 114
    i32.const 121
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 97
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 22
    ref.func $body_48_251
    struct.new $ClosureType_257
    call $testCase
    i32.const 97
    i32.const 99
    i32.const 99
    i32.const 117
    i32.const 109
    i32.const 117
    i32.const 108
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 68
    i32.const 85
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 44
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 121
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 115
    i32.const 101
    i32.const 113
    i32.const 117
    i32.const 101
    i32.const 110
    i32.const 99
    i32.const 101
    array.new_fixed $WasmStr 49
    ref.func $body_49_258
    struct.new $ClosureType_268
    call $testCase
    i32.const 114
    i32.const 97
    i32.const 110
    i32.const 103
    i32.const 101
    i32.const 32
    i32.const 103
    i32.const 101
    i32.const 110
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 32
    i32.const 118
    i32.const 105
    i32.const 97
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    array.new_fixed $WasmStr 35
    ref.func $body_50_269
    struct.new $ClosureType_272
    call $testCase
    i32.const 115
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 102
    i32.const 117
    i32.const 108
    i32.const 32
    i32.const 102
    i32.const 105
    i32.const 98
    i32.const 111
    i32.const 110
    i32.const 97
    i32.const 99
    i32.const 99
    i32.const 105
    i32.const 32
    i32.const 103
    i32.const 101
    i32.const 110
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    array.new_fixed $WasmStr 28
    ref.func $body_51_273
    struct.new $ClosureType_276
    call $testCase
    i32.const 116
    i32.const 119
    i32.const 111
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 103
    i32.const 101
    i32.const 110
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 115
    i32.const 32
    i32.const 100
    i32.const 111
    i32.const 110
    i32.const 39
    i32.const 116
    i32.const 32
    i32.const 115
    i32.const 104
    i32.const 97
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    array.new_fixed $WasmStr 44
    ref.func $body_52_277
    struct.new $ClosureType_279
    call $testCase
    i32.const 49
    i32.const 48
    i32.const 48
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 112
    i32.const 101
    i32.const 110
    i32.const 100
    i32.const 101
    i32.const 110
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 117
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 115
    array.new_fixed $WasmStr 24
    ref.func $body_53_280
    struct.new $ClosureType_291
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 108
    i32.const 97
    i32.const 114
    i32.const 103
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    array.new_fixed $WasmStr 32
    ref.func $body_54_292
    struct.new $ClosureType_295
    call $testCase
    i32.const 105
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 116
    i32.const 104
    i32.const 97
    i32.const 116
    i32.const 32
    i32.const 101
    i32.const 97
    i32.const 99
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 100
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 105
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 32
    i32.const 115
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 101
    array.new_fixed $WasmStr 56
    ref.func $body_55_296
    struct.new $ClosureType_309
    call $testCase
    ref.null $ListBase
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    return_call $testList
  )
  (func $applyDiscount (param $basePrice i32) (param $d (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Discount)) (result i32) ;; exported as "applyDiscount"
    local.get $d
    struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Discount 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $basePrice
      local.get $basePrice
      local.get $d
      ref.cast (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#1)
      struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#1 1
      i32.mul
      i32.const 100
      i32.div_s
      i32.const -1
      i32.xor
      i32.const -1
      i32.xor
      i32.sub
    else
      local.get $d
      struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Discount 0
      i32.const 2
      i32.eq
      if (result i32)
        local.get $basePrice
        local.get $d
        ref.cast (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#2)
        struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#2 1
        i32.sub
      else
        local.get $basePrice
      end
    end
  )
  (func $tierDiscount (param $tier i32) (result (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Discount)) ;; exported as "tierDiscount"
    local.get $tier
    i32.const 3
    i32.ge_s
    if (result (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Discount))
      i32.const 1
      i32.const 15
      struct.new $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#1
    else
      local.get $tier
      i32.const 2
      i32.eq
      if (result (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Discount))
        i32.const 1
        i32.const 10
        struct.new $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#1
      else
        local.get $tier
        i32.const 1
        i32.eq
        if (result (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Discount))
          i32.const 2
          i32.const 2
          struct.new $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#2
        else
          i32.const 0
          struct.new $WasmTests_Integration_CompilerPipelineSmokeTests_Discount#0
        end
      end
    end
  )
  (func $runOp (param $op (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Op)) (param $value i32) (result i32) ;; exported as "runOp"
    (local $lo_clo_163 (ref $ClosureBase_47))
    local.get $op
    struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Op 0
    i32.const 1
    i32.eq
    if (result i32)
      local.get $value
      local.get $op
      ref.cast (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Op#1)
      struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Op#1 1
      i32.mul
    else
      local.get $op
      struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Op 0
      i32.const 2
      i32.eq
      if (result i32)
        local.get $op
        ref.cast (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Op#2)
        struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Op#2 1
        ref.cast (ref $ClosureBase_47)
        local.set $lo_clo_163
        local.get $lo_clo_163
        local.get $value
        local.get $lo_clo_163
        struct.get $ClosureBase_47 0
        call_ref $FuncType_46
      else
        local.get $value
        local.get $op
        ref.cast (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Op#0)
        struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Op#0 1
        i32.add
      end
    end
  )
  (func $closure_319 (param $self (ref $AnyFn)) (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add
  )
  (func $body_319 (param $self (ref $AnyFn))
    (local $customer (ref $WasmTests_Integration_CompilerPipelineSmokeTests_Customer))
    (local $subtotal i32)
    (local $w231 (ref null $ListBase))
    (local $w232 i32)
    (local $y i32)
    (local $total i32)
    i32.const 97
    i32.const 108
    i32.const 112
    i32.const 104
    i32.const 97
    array.new_fixed $WasmStr 5
    i32.const 2
    struct.new $WasmTests_Integration_CompilerPipelineSmokeTests_Customer
    local.set $customer
    i32.const 10
    i32.const 20
    i32.const 30
    i32.const 40
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    local.set $w231
    i32.const 0
    local.set $w232
    block $while_lp_95_exit
      loop $while_lp_95
        local.get $w231
        ref.is_null
        i32.eqz
        if
          local.get $w231
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y
          local.get $w232
          local.get $y
          i32.add
          local.set $w232
          local.get $w231
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w231
          br $while_lp_95
        else
          br $while_lp_95_exit
        end
      end
    end
    local.get $w232
    local.set $subtotal
    local.get $subtotal
    local.get $customer
    struct.get $WasmTests_Integration_CompilerPipelineSmokeTests_Customer 1
    call $tierDiscount
    call $applyDiscount
    local.set $total
    local.get $subtotal
    i32.const 100
    i32.const 115
    i32.const 117
    i32.const 98
    i32.const 116
    i32.const 111
    i32.const 116
    i32.const 97
    i32.const 108
    i32.const 32
    i32.const 102
    i32.const 114
    i32.const 111
    i32.const 109
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    array.new_fixed $WasmStr 23
    call $equal
    local.get $total
    i32.const 90
    i32.const 116
    i32.const 105
    i32.const 101
    i32.const 114
    i32.const 45
    i32.const 50
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 49
    i32.const 48
    i32.const 37
    array.new_fixed $WasmStr 18
    call $equal
  )
  (func $mapping_321 (param $self (ref $AnyFn)) (param $x_1 i32) (result i32)
    local.get $x_1
    i32.const 3
    i32.mul
  )
  (func $predicate_322 (param $self (ref $AnyFn)) (param $x_2 i32) (result i32)
    local.get $x_2
    i32.const 2
    i32.rem_s
    i32.const 0
    i32.eq
  )
  (func $body_1_321 (param $self (ref $AnyFn))
    (local $transformed (ref null $ListBase))
    (local $w242 (ref $GcArray_96))
    (local $array_1 (ref $GcArray_96))
    (local $w233 (ref $GcArray_96))
    (local $w234 i32)
    (local $w235 (ref $GcArray_96))
    (local $w237 i32)
    (local $x_1 i32)
    (local $w238 i32)
    (local $w239 i32)
    (local $w240 i32)
    (local $x_2 i32)
    (local $w241 i32)
    (local $w243 i32)
    (local $w244 (ref null $ListBase))
    (local $headOrFallback i32)
    (local $w248 (ref null $Option_23))
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    i32.const 6
    array.new_fixed $GcArray_96 6
    local.set $w233
    local.get $w233
    array.len
    local.set $w234
    i32.const 0
    local.get $w234
    array.new $GcArray_96
    local.set $w235
    i32.const 0
    local.set $w237
    block $while_lp_96_exit
      loop $while_lp_96
        local.get $w237
        local.get $w234
        i32.lt_s
        if
          local.get $w235
          local.get $w237
          local.get $w233
          local.get $w237
          array.get $GcArray_96
          local.set $x_1
          local.get $x_1
          i32.const 3
          i32.mul
          array.set $GcArray_96
          local.get $w237
          i32.const 1
          i32.add
          local.set $w237
          br $while_lp_96
        else
          br $while_lp_96_exit
        end
      end
    end
    local.get $w235
    local.set $array_1
    local.get $array_1
    array.len
    local.set $w238
    i32.const 0
    local.set $w239
    i32.const 0
    local.set $w240
    block $while_lp_97_exit
      loop $while_lp_97
        local.get $w240
        local.get $w238
        i32.lt_s
        if
          local.get $array_1
          local.get $w240
          array.get $GcArray_96
          local.set $x_2
          local.get $x_2
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            local.get $w239
            i32.const 1
            i32.add
            local.set $w239
          end
          local.get $w240
          i32.const 1
          i32.add
          local.set $w240
          br $while_lp_97
        else
          br $while_lp_97_exit
        end
      end
    end
    i32.const 0
    local.set $w241
    i32.const 0
    local.set $w240
    block $while_lp_98_exit
      loop $while_lp_98
        local.get $w240
        local.get $w238
        i32.lt_s
        if
          local.get $array_1
          local.get $w240
          array.get $GcArray_96
          local.set $x_2
          local.get $x_2
          i32.const 2
          i32.rem_s
          i32.const 0
          i32.eq
          if
            i32.const 0
            local.get $w239
            array.new $GcArray_96
            local.get $w241
            local.get $array_1
            local.get $w240
            array.get $GcArray_96
            array.set $GcArray_96
            local.get $w241
            i32.const 1
            i32.add
            local.set $w241
          end
          local.get $w240
          i32.const 1
          i32.add
          local.set $w240
          br $while_lp_98
        else
          br $while_lp_98_exit
        end
      end
    end
    i32.const 0
    local.get $w239
    array.new $GcArray_96
    local.set $w242
    local.get $w242
    array.len
    i32.const 1
    i32.sub
    local.set $w243
    ref.null $ListBase
    local.set $w244
    block $while_lp_99_exit
      loop $while_lp_99
        local.get $w243
        i32.const 0
        i32.ge_s
        if
          local.get $w242
          local.get $w243
          array.get $GcArray_96
          local.get $w244
          struct.new $ListCons_22
          local.set $w244
          local.get $w243
          i32.const 1
          i32.sub
          local.set $w243
          br $while_lp_99
        else
          br $while_lp_99_exit
        end
      end
    end
    local.get $w244
    local.set $transformed
    local.get $transformed
    ref.is_null
    if (result (ref null $Option_23))
      ref.null $Option_23
    else
      local.get $transformed
      ref.cast (ref $ListCons_22)
      struct.get $ListCons_22 0
      struct.new $Option_23
    end
    local.set $w248
    local.get $w248
    ref.is_null
    if (result i32)
      i32.const -1
    else
      local.get $w248
      ref.cast (ref $Option_23)
      struct.get $Option_23 0
    end
    local.set $headOrFallback
    local.get $transformed
    i32.const 6
    i32.const 12
    i32.const 18
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 97
    i32.const 114
    i32.const 114
    i32.const 97
    i32.const 121
    i32.const 47
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 98
    i32.const 105
    i32.const 110
    i32.const 97
    i32.const 116
    i32.const 111
    i32.const 114
    i32.const 115
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 111
    i32.const 115
    i32.const 101
    i32.const 100
    array.new_fixed $WasmStr 31
    call $sequenceEqual
    local.get $headOrFallback
    i32.const 6
    i32.const 111
    i32.const 112
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 100
    i32.const 101
    i32.const 102
    i32.const 97
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 32
    i32.const 112
    i32.const 97
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 99
    i32.const 104
    i32.const 111
    i32.const 111
    i32.const 115
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 104
    i32.const 101
    i32.const 97
    i32.const 100
    array.new_fixed $WasmStr 32
    call $equal
  )
  (func $closure_324 (param $self (ref $AnyFn)) (param $n i32) (result i32)
    (local $lo_clo_164 (ref $ClosureBase_47))
    (local $lo_clo_165 (ref $ClosureBase_47))
    (local $fib (ref $AnyFn))
    local.get $n
    i32.const 1
    i32.le_s
    if (result i32)
      local.get $n
    else
      local.get $fib
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_164
      local.get $lo_clo_164
      local.get $n
      i32.const 1
      i32.sub
      local.get $lo_clo_164
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
      local.get $fib
      ref.cast (ref $ClosureBase_47)
      local.set $lo_clo_165
      local.get $lo_clo_165
      local.get $n
      i32.const 2
      i32.sub
      local.get $lo_clo_165
      struct.get $ClosureBase_47 0
      call_ref $FuncType_46
      i32.add
    end
  )
  (func $keep_325 (param $self (ref $AnyFn)) (param $x_3 i32) (result i32)
    (local $cmp_b i32)
    i32.const 5
    local.set $cmp_b
    local.get $x_3
    local.get $cmp_b
    i32.eq
    if (result i32)
      i32.const 0
    else
      local.get $x_3
      local.get $cmp_b
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 1
      end
    end
    i32.const 0
    i32.ge_s
  )
  (func $closure_326 (param $self (ref $AnyFn)) (param $x_4 i32) (param $y_1 i32) (result i32)
    local.get $x_4
    local.get $y_1
    i32.add
  )
  (func $body_2_324 (param $self (ref $AnyFn))
    (local $fib (ref $ClosureType_324))
    (local $values (ref null $ListBase))
    (local $w251 (ref null $ListBase))
    (local $w249 (ref null $ListBase))
    (local $w250 (ref null $ListBase))
    (local $x_3 i32)
    (local $cmp_b i32)
    (local $w252 (ref null $ListBase))
    (local $sum i32)
    (local $w253 (ref null $ListBase))
    (local $w254 i32)
    (local $y_1 i32)
    ref.func $closure_324
    struct.new $ClosureType_324
    local.set $fib
    local.set $w249
    ref.null $ListBase
    local.set $w250
    block $while_lp_100_exit
      loop $while_lp_100
        local.get $w249
        ref.is_null
        i32.eqz
        if
          local.get $w249
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $x_3
          i32.const 5
          local.set $cmp_b
          local.get $x_3
          local.get $cmp_b
          i32.eq
          if (result i32)
            i32.const 0
          else
            local.get $x_3
            local.get $cmp_b
            i32.lt_s
            if (result i32)
              i32.const -1
            else
              i32.const 1
            end
          end
          i32.const 0
          i32.ge_s
          if (result (ref null $ListBase))
            local.get $w249
            ref.cast (ref $ListCons_22)
            struct.get $ListCons_22 0
            local.get $w250
            struct.new $ListCons_22
          else
            local.get $w250
          end
          local.set $w250
          local.get $w249
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w249
          br $while_lp_100
        else
          br $while_lp_100_exit
        end
      end
    end
    local.get $w250
    local.set $w251
    ref.null $ListBase
    local.set $w252
    block $while_lp_101_exit
      loop $while_lp_101
        local.get $w251
        ref.is_null
        i32.eqz
        if
          local.get $w251
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.get $w252
          struct.new $ListCons_22
          local.set $w252
          local.get $w251
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w251
          br $while_lp_101
        else
          br $while_lp_101_exit
        end
      end
    end
    local.get $w252
    local.set $values
    local.get $values
    local.set $w253
    i32.const 0
    local.set $w254
    block $while_lp_102_exit
      loop $while_lp_102
        local.get $w253
        ref.is_null
        i32.eqz
        if
          local.get $w253
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 0
          local.set $y_1
          local.get $w254
          local.get $y_1
          i32.add
          local.set $w254
          local.get $w253
          ref.cast (ref $ListCons_22)
          struct.get $ListCons_22 1
          local.set $w253
          br $while_lp_102
        else
          br $while_lp_102_exit
        end
      end
    end
    local.get $w254
    local.set $sum
    local.get $values
    i32.const 5
    i32.const 8
    i32.const 13
    ref.null $ListBase
    struct.new $ListCons_22
    struct.new $ListCons_22
    struct.new $ListCons_22
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 105
    i32.const 108
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 117
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 118
    i32.const 101
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 115
    array.new_fixed $WasmStr 37
    call $sequenceEqual
    local.get $sum
    i32.const 26
    i32.const 115
    i32.const 117
    i32.const 109
    i32.const 32
    i32.const 97
    i32.const 102
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 103
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 112
    i32.const 105
    i32.const 112
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 110
    i32.const 101
    array.new_fixed $WasmStr 30
    call $equal
  )
  (func $closure_328 (param $self (ref $AnyFn)) (param $s_1 (ref $WasmStr)) (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
    (local $matchValue (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
    (local $n_1 i32)
    local.get $s_1
    i32.const 55
    array.new_fixed $WasmStr 1
    call $strEq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
      i32.const 0
      i32.const 7
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0
    else
      local.get $s_1
      i32.const 49
      i32.const 50
      array.new_fixed $WasmStr 2
      call $strEq
      if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
        i32.const 0
        i32.const 12
        struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0
      else
        local.get $s_1
        i32.const 45
        i32.const 50
        array.new_fixed $WasmStr 2
        call $strEq
        if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
          i32.const 0
          i32.const -2
          struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0
        else
          i32.const 1
          i32.const 110
          i32.const 111
          i32.const 116
          i32.const 45
          i32.const 115
          i32.const 117
          i32.const 112
          i32.const 112
          i32.const 111
          i32.const 114
          i32.const 116
          i32.const 101
          i32.const 100
          array.new_fixed $WasmStr 13
          struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1
        end
      end
    end
    local.set $matchValue
    local.get $matchValue
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> 0
    i32.const 0
    i32.eq
    if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 1
      local.set $n_1
      local.get $n_1
      i32.const 0
      i32.le_s
      if (result (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
        i32.const 1
        i32.const 110
        i32.const 111
        i32.const 110
        i32.const 45
        i32.const 112
        i32.const 111
        i32.const 115
        i32.const 105
        i32.const 116
        i32.const 105
        i32.const 118
        i32.const 101
        array.new_fixed $WasmStr 12
        struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1
      else
        i32.const 0
        struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0
      end
    else
      i32.const 1
      local.get $matchValue
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1 1
      struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1
    end
  )
  (func $chooser_331 (param $self (ref $AnyFn)) (param $_arg (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>)) (result (ref null $Option_23))
    local.get $_arg
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_23))
      ref.null $Option_23
    else
      local.get $_arg
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 1
      struct.new $Option_23
    end
  )
  (func $chooser_335 (param $self (ref $AnyFn)) (param $_arg (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>)) (result (ref null $Option_23))
    local.get $_arg
    struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1> 0
    i32.const 1
    i32.eq
    if (result (ref null $Option_23))
      ref.null $Option_23
    else
      local.get $_arg
      ref.cast (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0)
      struct.get $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0 1
      struct.new $Option_23
    end
  )
  (func $body_3_328 (param $self (ref $AnyFn))
    (local $normalize (ref $ClosureType_330))
    (local $r1 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
    (local $lo_clo_166 (ref $ClosureBase_329))
    (local $r2 (ref $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>))
    (local $lo_clo_167 (ref $ClosureBase_329))
    (local $firstOk i32)
    ref.func $closure_328
    struct.new $ClosureType_330
    local.set $normalize
    local.get $normalize
    ref.cast (ref $ClosureBase_329)
    local.set $lo_clo_166
    local.get $lo_clo_166
    i32.const 55
    array.new_fixed $WasmStr 1
    local.get $lo_clo_166
    struct.get $ClosureBase_329 0
    call_ref $FuncType_328
    local.set $r1
    local.get $normalize
    ref.cast (ref $ClosureBase_329)
    local.set $lo_clo_167
    local.get $lo_clo_167
    i32.const 45
    i32.const 50
    array.new_fixed $WasmStr 2
    local.get $lo_clo_167
    struct.get $ClosureBase_329 0
    call_ref $FuncType_328
    local.set $r2
    local.set $firstOk
    local.get $r1
    i32.const 0
    i32.const 14
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#0
    i32.const 112
    i32.const 97
    i32.const 114
    i32.const 115
    i32.const 101
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 105
    i32.const 100
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 99
    i32.const 108
    i32.const 97
    i32.const 109
    i32.const 112
    array.new_fixed $WasmStr 24
    call $equal
    local.get $r2
    i32.const 1
    i32.const 110
    i32.const 111
    i32.const 110
    i32.const 45
    i32.const 112
    i32.const 111
    i32.const 115
    i32.const 105
    i32.const 116
    i32.const 105
    i32.const 118
    i32.const 101
    array.new_fixed $WasmStr 12
    struct.new $Microsoft_FSharp_Core_FSharpResult`2<i32~ref1>#1
    i32.const 118
    i32.const 97
    i32.const 108
    i32.const 105
    i32.const 100
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 98
    i32.const 114
    i32.const 97
    i32.const 110
    i32.const 99
    i32.const 104
    array.new_fixed $WasmStr 17
    call $equal
    local.get $firstOk
    i32.const 14
    i32.const 111
    i32.const 112
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 115
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    array.new_fixed $WasmStr 23
    call $equal
  )
  (func $closure_339 (param $self (ref $AnyFn)) (param $x_5 i32) (result i32)
    local.get $x_5
    i32.const 4
    i32.sub
  )
  (func $body_4_337 (param $self (ref $AnyFn))
    (local $i i32)
    (local $acc i32)
    (local $arr (ref $GcArray_337))
    i32.const 0
    local.set $i
    i32.const 0
    local.set $acc
    local.set $arr
    loop $while
      local.get $i
      local.get $arr
      array.len
      i32.lt_s
      if
        local.get $arr
        local.get $i
        array.get $GcArray_337
        local.get $acc
        call $runOp
        local.set $acc
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $while
      end
    end
    local.get $acc
    i32.const 3
    i32.const 105
    i32.const 109
    i32.const 112
    i32.const 101
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 118
    i32.const 101
    i32.const 32
    i32.const 101
    i32.const 120
    i32.const 101
    i32.const 99
    i32.const 117
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 111
    i32.const 118
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 68
    i32.const 85
    i32.const 45
    i32.const 112
    i32.const 114
    i32.const 111
    i32.const 103
    i32.const 114
    i32.const 97
    i32.const 109
    array.new_fixed $WasmStr 36
    call $equal
  )
  (func $CompilerPipelineSmokeTests_tests (result (ref $Wasmecto_Test)) ;; exported as "CompilerPipelineSmokeTests_tests"
    i32.const 73
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 103
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 47
    i32.const 67
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 105
    i32.const 108
    i32.const 101
    i32.const 114
    i32.const 80
    i32.const 105
    i32.const 112
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 110
    i32.const 101
    i32.const 46
    i32.const 83
    i32.const 109
    i32.const 111
    i32.const 107
    i32.const 101
    array.new_fixed $WasmStr 34
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 100
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 68
    i32.const 85
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 108
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    i32.const 32
    i32.const 61
    i32.const 62
    i32.const 32
    i32.const 112
    i32.const 114
    i32.const 105
    i32.const 99
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 112
    i32.const 105
    i32.const 112
    i32.const 101
    i32.const 108
    i32.const 105
    i32.const 110
    i32.const 101
    array.new_fixed $WasmStr 43
    ref.func $body_319
    struct.new $ClosureType_320
    call $testCase
    i32.const 97
    i32.const 114
    i32.const 114
    i32.const 97
    i32.const 121
    i32.const 32
    i32.const 45
    i32.const 62
    i32.const 32
    i32.const 109
    i32.const 97
    i32.const 112
    i32.const 47
    i32.const 102
    i32.const 105
    i32.const 108
    i32.const 116
    i32.const 101
    i32.const 114
    i32.const 32
    i32.const 45
    i32.const 62
    i32.const 32
    i32.const 76
    i32.const 105
    i32.const 115
    i32.const 116
    i32.const 46
    i32.const 116
    i32.const 114
    i32.const 121
    i32.const 72
    i32.const 101
    i32.const 97
    i32.const 100
    i32.const 32
    i32.const 45
    i32.const 62
    i32.const 32
    i32.const 79
    i32.const 112
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 46
    i32.const 100
    i32.const 101
    i32.const 102
    i32.const 97
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 86
    i32.const 97
    i32.const 108
    i32.const 117
    i32.const 101
    array.new_fixed $WasmStr 58
    ref.func $body_1_321
    struct.new $ClosureType_323
    call $testCase
    i32.const 99
    i32.const 108
    i32.const 111
    i32.const 115
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 99
    i32.const 97
    i32.const 112
    i32.const 116
    i32.const 117
    i32.const 114
    i32.const 101
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 117
    i32.const 114
    i32.const 115
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 72
    i32.const 79
    i32.const 70
    i32.const 32
    i32.const 99
    i32.const 111
    i32.const 109
    i32.const 112
    i32.const 111
    i32.const 115
    i32.const 105
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 45
    ref.func $body_2_324
    struct.new $ClosureType_327
    call $testCase
    i32.const 82
    i32.const 101
    i32.const 115
    i32.const 117
    i32.const 108
    i32.const 116
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 79
    i32.const 112
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 83
    i32.const 116
    i32.const 114
    i32.const 105
    i32.const 110
    i32.const 103
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 77
    i32.const 97
    i32.const 116
    i32.const 104
    i32.const 32
    i32.const 105
    i32.const 110
    i32.const 32
    i32.const 111
    i32.const 110
    i32.const 101
    i32.const 32
    i32.const 102
    i32.const 108
    i32.const 111
    i32.const 119
    array.new_fixed $WasmStr 43
    ref.func $body_3_328
    struct.new $ClosureType_336
    call $testCase
    i32.const 119
    i32.const 104
    i32.const 105
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 108
    i32.const 111
    i32.const 111
    i32.const 112
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 109
    i32.const 117
    i32.const 116
    i32.const 97
    i32.const 98
    i32.const 108
    i32.const 101
    i32.const 32
    i32.const 115
    i32.const 116
    i32.const 97
    i32.const 116
    i32.const 101
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 68
    i32.const 85
    i32.const 32
    i32.const 102
    i32.const 117
    i32.const 110
    i32.const 99
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 97
    i32.const 112
    i32.const 112
    i32.const 108
    i32.const 105
    i32.const 99
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    array.new_fixed $WasmStr 52
    ref.func $body_4_337
    struct.new $ClosureType_340
    call $testCase
    i32.const 105
    i32.const 110
    i32.const 116
    i32.const 101
    i32.const 103
    i32.const 114
    i32.const 97
    i32.const 116
    i32.const 105
    i32.const 111
    i32.const 110
    i32.const 32
    i32.const 115
    i32.const 109
    i32.const 111
    i32.const 107
    i32.const 101
    i32.const 58
    i32.const 32
    i32.const 110
    i32.const 101
    i32.const 115
    i32.const 116
    i32.const 101
    i32.const 100
    i32.const 32
    i32.const 114
    i32.const 101
    i32.const 99
    i32.const 111
    i32.const 114
    i32.const 100
    i32.const 115
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 116
    i32.const 117
    i32.const 112
    i32.const 108
    i32.const 101
    i32.const 115
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 97
    i32.const 114
    i32.const 114
    i32.const 97
    i32.const 121
    i32.const 115
    i32.const 32
    i32.const 43
    i32.const 32
    i32.const 102
    i32.const 111
    i32.const 108
    i32.const 100
    i32.const 115
    array.new_fixed $WasmStr 59
    ref.null $AnyFn
    call $testCase
    ref.null $ListBase
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    return_call $testList
  )
  (func $init
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    ref.func $ClosureTests_tests
    i32.const 1
    global.set $fsharp_exn_carrier
    throw $fsharp_exn
    ref.null $ListBase
    struct.new $ListCons_8
    struct.new $ListCons_8
    struct.new $ListCons_8
    call $register
  )
  ;; ── Elem declare (func refs) ────────────────────────
  (elem declare func $closure_120 $closure_123 $closure_127 $closure_129 $closure_132 $closure_133 $closure_134 $closure_136 $closure_139 $closure_142 $closure_144 $closure_151 $closure_153 $closure_154 $closure_17 $closure_172 $closure_176 $closure_178 $closure_180 $closure_184 $closure_186 $closure_188 $closure_192 $closure_194 $closure_20 $closure_201 $closure_203 $closure_205 $closure_207 $closure_209 $closure_211 $closure_214 $closure_218 $closure_221 $closure_224 $closure_238 $closure_245 $closure_247 $closure_25 $closure_256 $closure_265 $closure_266 $closure_267 $closure_269 $closure_273 $closure_275 $closure_277 $closure_281 $closure_283 $closure_285 $closure_287 $closure_297 $closure_300 $closure_303 $closure_306 $closure_324 $closure_328 $closure_38 $closure_46 $closure_50 $closure_59 $closure_63 $letrec_isEven_197 $letrec_isOdd_198 $ClosureTests_tests $Kind $Msg $add3_239 $body_10_132 $body_10_74 $body_115 $body_11_136 $body_11_75 $body_12_144 $body_12_85 $body_13_151 $body_13_92 $body_14_153 $body_14_96 $body_15_156 $body_15_98 $body_16_103 $body_16_158 $body_17_104 $body_17_160 $body_18_105 $body_18_162 $body_19_164 $body_1_116 $body_1_321 $body_1_46 $body_20_166 $body_21_168 $body_22_183 $body_23_184 $body_24_186 $body_25_188 $body_26_190 $body_27_192 $body_28_194 $body_29_196 $body_2_117 $body_2_324 $body_2_50 $body_30_201 $body_319 $body_31_203 $body_32_205 $body_33_207 $body_34_214 $body_35_217 $body_36_218 $body_37_220 $body_38_221 $body_39_224 $body_3_118 $body_3_328 $body_3_54 $body_40_227 $body_41_235 $body_42_238 $body_43_242 $body_44_243 $body_45 $body_45_245 $body_46_247 $body_47_249 $body_48_251 $body_49_258 $body_4_119 $body_4_337 $body_4_56 $body_50_269 $body_51_273 $body_52_277 $body_53_280 $body_54_292 $body_55_296 $body_5_120 $body_5_57 $body_6_122 $body_6_58 $body_7_123 $body_7_59 $body_8_127 $body_8_63 $body_9_129 $body_9_73 $f_9_224 $level2_235 $level3_235 $step_1_249 $subFlipped_222 $times2_238)
  ;; ── Exports ────────────────────────────────────────
  (export "Kind" (func $Kind))
  (export "Msg" (func $Msg))
  (export "reset" (func $reset))
  (export "testCase" (func $testCase))
  (export "test" (func $test))
  (export "testList" (func $testList))
  (export "ptestCase" (func $ptestCase))
  (export "pending" (func $pending))
  (export "ptestList" (func $ptestList))
  (export "ftestCase" (func $ftestCase))
  (export "ftestList" (func $ftestList))
  (export "equal" (func $equal))
  (export "notEqual" (func $notEqual))
  (export "isTrue" (func $isTrue))
  (export "isFalse" (func $isFalse))
  (export "isNull" (func $isNull))
  (export "isNotNull" (func $isNotNull))
  (export "throws" (func $throws))
  (export "throwsT" (func $throwsT))
  (export "stringContains" (func $stringContains))
  (export "stringStarts" (func $stringStarts))
  (export "stringEnds" (func $stringEnds))
  (export "stringHasLength" (func $stringHasLength))
  (export "sequenceEqual" (func $sequenceEqual))
  (export "isEmpty" (func $isEmpty))
  (export "isNonEmpty" (func $isNonEmpty))
  (export "hasLength" (func $hasLength))
  (export "approxEqual" (func $approxEqual))
  (export "isLessThan" (func $isLessThan))
  (export "isGreaterThan" (func $isGreaterThan))
  (export "isLessThanOrEqual" (func $isLessThanOrEqual))
  (export "isGreaterThanOrEqual" (func $isGreaterThanOrEqual))
  (export "wantSome" (func $wantSome))
  (export "wantOk" (func $wantOk))
  (export "flatten" (func $flatten))
  (export "hasFocus" (func $hasFocus))
  (export "run" (func $run))
  (export "runAll" (func $runAll))
  (export "registry" (func $registry))
  (export "register" (func $register))
  (export "wasmecto_run" (func $wasmecto_run))
  (export "flatten" (func $flatten))
  (export "hasFocus" (func $hasFocus))
  (export "run" (func $run))
  (export "runAll" (func $runAll))
  (export "registry" (func $registry))
  (export "register" (func $register))
  (export "wasmecto_run" (func $wasmecto_run))
  (export "shapeArea" (func $shapeArea))
  (export "tests" (func $tests))
  (export "collect" (func $collect))
  (export "iterate" (func $iterate))
  (export "ClosureTests_tests" (func $ClosureTests_tests))
  (export "applyDiscount" (func $applyDiscount))
  (export "tierDiscount" (func $tierDiscount))
  (export "runOp" (func $runOp))
  (export "CompilerPipelineSmokeTests_tests" (func $CompilerPipelineSmokeTests_tests))
  ;; ── Globals ─────────────────────────────────────────
  (global $fsharp_exn_carrier (mut anyref)ref.null any
)
)
