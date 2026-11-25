module PLL_ANALOG_MACRO (DCO_EN,
    INJ_EDGE,
    INJ_EN,
    MID_OUT,
    OUT,
    REF,
    COARSE_MUX,
    FINE_MUX,
    MID_MUX,
    SS_BBPD,
    VSS,
    VDD);
 input DCO_EN;
 output INJ_EDGE;
 input INJ_EN;
 output MID_OUT;
 output OUT;
 input REF;
 input [14:0] COARSE_MUX;
 input [30:0] FINE_MUX;
 input [14:0] MID_MUX;
 output [1:0] SS_BBPD;
 inout VSS;
 inout VDD;

 wire pll_ana_INJ_WIN;
 wire \pll_ana_dco/COARSE_OUT ;
 wire \pll_ana_dco/FINE_OUT ;
 wire \pll_ana_dco/SS_BBPD_WIRE_0_ ;
 wire \pll_ana_dco/SS_BBPD_WIRE_1_ ;
 wire \pll_ana_dco/dff_x_CLK ;
 wire \pll_ana_dco/dff_x_RESET_B ;
 wire \pll_ana_dco/dff_y_CLK ;
 wire \pll_ana_dco/dff_y_RESET_B ;
 wire \pll_ana_dco/coarse/FCHAIN_10_ ;
 wire \pll_ana_dco/coarse/FCHAIN_11_ ;
 wire \pll_ana_dco/coarse/FCHAIN_12_ ;
 wire \pll_ana_dco/coarse/FCHAIN_13_ ;
 wire \pll_ana_dco/coarse/FCHAIN_14_ ;
 wire \pll_ana_dco/coarse/FCHAIN_15_ ;
 wire \pll_ana_dco/coarse/FCHAIN_1_ ;
 wire \pll_ana_dco/coarse/FCHAIN_2_ ;
 wire \pll_ana_dco/coarse/FCHAIN_3_ ;
 wire \pll_ana_dco/coarse/FCHAIN_4_ ;
 wire \pll_ana_dco/coarse/FCHAIN_5_ ;
 wire \pll_ana_dco/coarse/FCHAIN_6_ ;
 wire \pll_ana_dco/coarse/FCHAIN_7_ ;
 wire \pll_ana_dco/coarse/FCHAIN_8_ ;
 wire \pll_ana_dco/coarse/FCHAIN_9_ ;
 wire \pll_ana_dco/coarse/RCHAIN_10_ ;
 wire \pll_ana_dco/coarse/RCHAIN_11_ ;
 wire \pll_ana_dco/coarse/RCHAIN_12_ ;
 wire \pll_ana_dco/coarse/RCHAIN_13_ ;
 wire \pll_ana_dco/coarse/RCHAIN_14_ ;
 wire \pll_ana_dco/coarse/RCHAIN_15_ ;
 wire \pll_ana_dco/coarse/RCHAIN_1_ ;
 wire \pll_ana_dco/coarse/RCHAIN_2_ ;
 wire \pll_ana_dco/coarse/RCHAIN_3_ ;
 wire \pll_ana_dco/coarse/RCHAIN_4_ ;
 wire \pll_ana_dco/coarse/RCHAIN_5_ ;
 wire \pll_ana_dco/coarse/RCHAIN_6_ ;
 wire \pll_ana_dco/coarse/RCHAIN_7_ ;
 wire \pll_ana_dco/coarse/RCHAIN_8_ ;
 wire \pll_ana_dco/coarse/RCHAIN_9_ ;
 wire \pll_ana_dco/coarse/stage_0_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_10_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_11_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_12_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_13_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_14_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_1_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_2_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_3_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_4_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_5_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_6_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_7_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_8_impl/PATH_0 ;
 wire \pll_ana_dco/coarse/stage_9_impl/PATH_0 ;
 wire \pll_ana_dco/fine/LOAD ;
 wire \pll_ana_dco/fine/MUXB_0_ ;
 wire \pll_ana_dco/fine/MUXB_10_ ;
 wire \pll_ana_dco/fine/MUXB_11_ ;
 wire \pll_ana_dco/fine/MUXB_12_ ;
 wire \pll_ana_dco/fine/MUXB_13_ ;
 wire \pll_ana_dco/fine/MUXB_14_ ;
 wire \pll_ana_dco/fine/MUXB_15_ ;
 wire \pll_ana_dco/fine/MUXB_16_ ;
 wire \pll_ana_dco/fine/MUXB_17_ ;
 wire \pll_ana_dco/fine/MUXB_18_ ;
 wire \pll_ana_dco/fine/MUXB_19_ ;
 wire \pll_ana_dco/fine/MUXB_1_ ;
 wire \pll_ana_dco/fine/MUXB_20_ ;
 wire \pll_ana_dco/fine/MUXB_21_ ;
 wire \pll_ana_dco/fine/MUXB_22_ ;
 wire \pll_ana_dco/fine/MUXB_23_ ;
 wire \pll_ana_dco/fine/MUXB_24_ ;
 wire \pll_ana_dco/fine/MUXB_25_ ;
 wire \pll_ana_dco/fine/MUXB_26_ ;
 wire \pll_ana_dco/fine/MUXB_27_ ;
 wire \pll_ana_dco/fine/MUXB_28_ ;
 wire \pll_ana_dco/fine/MUXB_29_ ;
 wire \pll_ana_dco/fine/MUXB_2_ ;
 wire \pll_ana_dco/fine/MUXB_30_ ;
 wire \pll_ana_dco/fine/MUXB_3_ ;
 wire \pll_ana_dco/fine/MUXB_4_ ;
 wire \pll_ana_dco/fine/MUXB_5_ ;
 wire \pll_ana_dco/fine/MUXB_6_ ;
 wire \pll_ana_dco/fine/MUXB_7_ ;
 wire \pll_ana_dco/fine/MUXB_8_ ;
 wire \pll_ana_dco/fine/MUXB_9_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_0_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_10_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_11_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_12_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_13_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_14_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_15_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_16_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_17_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_18_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_19_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_1_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_20_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_21_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_22_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_23_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_24_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_25_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_26_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_27_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_28_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_29_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_2_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_30_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_3_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_4_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_5_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_6_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_7_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_8_ ;
 wire \pll_ana_dco/fine/UNCONNECTED_9_ ;
 wire \pll_ana_dco/mid/LOAD ;
 wire \pll_ana_dco/mid/MUXB_0_ ;
 wire \pll_ana_dco/mid/MUXB_10_ ;
 wire \pll_ana_dco/mid/MUXB_11_ ;
 wire \pll_ana_dco/mid/MUXB_12_ ;
 wire \pll_ana_dco/mid/MUXB_13_ ;
 wire \pll_ana_dco/mid/MUXB_14_ ;
 wire \pll_ana_dco/mid/MUXB_1_ ;
 wire \pll_ana_dco/mid/MUXB_2_ ;
 wire \pll_ana_dco/mid/MUXB_3_ ;
 wire \pll_ana_dco/mid/MUXB_4_ ;
 wire \pll_ana_dco/mid/MUXB_5_ ;
 wire \pll_ana_dco/mid/MUXB_6_ ;
 wire \pll_ana_dco/mid/MUXB_7_ ;
 wire \pll_ana_dco/mid/MUXB_8_ ;
 wire \pll_ana_dco/mid/MUXB_9_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_0_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_10_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_11_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_12_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_13_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_14_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_1_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_2_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_3_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_4_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_5_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_6_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_7_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_8_ ;
 wire \pll_ana_dco/mid/UNCONNECTED_9_ ;
 wire \pll_ana_dco/sym/INJ_DUMMY ;
 wire \pll_ana_dco/sym/INJ_EDGE_BALANCED ;
 wire \pll_ana_dco/sym/OSC_BALANCED ;
 wire \pll_ana_dco/sym/OSC_DUMMY ;
 wire \pll_ana_dco/sym/ssbbpd_impl/OUT_NANDX ;
 wire \pll_ana_dco/sym/ssbbpd_impl/OUT_NANDY ;
 wire \pll_ana_dco/sym/sym_mux/DCO_EN_INJ_WIN ;
 wire \pll_ana_dco/sym/sym_mux/OSC_INJ ;
 wire \pll_ana_dco/sym/sym_mux/REF_INJ ;
 wire \pll_ana_inj/CHAIN_1_1_ ;
 wire \pll_ana_inj/CHAIN_1_2_ ;
 wire \pll_ana_inj/CHAIN_1_3_ ;
 wire \pll_ana_inj/CHAIN_2_1_ ;
 wire \pll_ana_inj/CHAIN_2_2_ ;
 wire \pll_ana_inj/CHAIN_2_3_ ;
 wire \pll_ana_inj/CHAIN_2_4_ ;
 wire \pll_ana_inj/CHAIN_OUT ;

 sg13g2_decap_8 FILLER_0_0 ();
 sg13g2_decap_8 FILLER_0_105 ();
 sg13g2_decap_8 FILLER_0_112 ();
 sg13g2_decap_8 FILLER_0_119 ();
 sg13g2_decap_8 FILLER_0_126 ();
 sg13g2_decap_8 FILLER_0_133 ();
 sg13g2_decap_8 FILLER_0_14 ();
 sg13g2_decap_8 FILLER_0_140 ();
 sg13g2_decap_8 FILLER_0_147 ();
 sg13g2_decap_8 FILLER_0_154 ();
 sg13g2_decap_8 FILLER_0_161 ();
 sg13g2_decap_8 FILLER_0_168 ();
 sg13g2_decap_8 FILLER_0_175 ();
 sg13g2_decap_8 FILLER_0_182 ();
 sg13g2_decap_8 FILLER_0_189 ();
 sg13g2_decap_8 FILLER_0_196 ();
 sg13g2_decap_8 FILLER_0_203 ();
 sg13g2_decap_8 FILLER_0_21 ();
 sg13g2_decap_8 FILLER_0_210 ();
 sg13g2_decap_8 FILLER_0_217 ();
 sg13g2_decap_8 FILLER_0_224 ();
 sg13g2_decap_8 FILLER_0_231 ();
 sg13g2_decap_8 FILLER_0_238 ();
 sg13g2_decap_8 FILLER_0_245 ();
 sg13g2_fill_2 FILLER_0_252 ();
 sg13g2_fill_1 FILLER_0_254 ();
 sg13g2_decap_8 FILLER_0_28 ();
 sg13g2_decap_8 FILLER_0_35 ();
 sg13g2_decap_8 FILLER_0_42 ();
 sg13g2_decap_8 FILLER_0_49 ();
 sg13g2_decap_8 FILLER_0_56 ();
 sg13g2_decap_8 FILLER_0_63 ();
 sg13g2_decap_8 FILLER_0_7 ();
 sg13g2_decap_8 FILLER_0_70 ();
 sg13g2_decap_8 FILLER_0_77 ();
 sg13g2_decap_8 FILLER_0_84 ();
 sg13g2_decap_8 FILLER_0_91 ();
 sg13g2_decap_8 FILLER_0_98 ();
 sg13g2_decap_8 FILLER_10_0 ();
 sg13g2_decap_8 FILLER_10_101 ();
 sg13g2_decap_8 FILLER_10_108 ();
 sg13g2_decap_8 FILLER_10_115 ();
 sg13g2_decap_8 FILLER_10_122 ();
 sg13g2_decap_8 FILLER_10_129 ();
 sg13g2_fill_2 FILLER_10_13 ();
 sg13g2_fill_1 FILLER_10_15 ();
 sg13g2_decap_8 FILLER_10_151 ();
 sg13g2_decap_8 FILLER_10_158 ();
 sg13g2_decap_8 FILLER_10_165 ();
 sg13g2_decap_4 FILLER_10_172 ();
 sg13g2_fill_1 FILLER_10_176 ();
 sg13g2_decap_8 FILLER_10_182 ();
 sg13g2_decap_8 FILLER_10_189 ();
 sg13g2_decap_4 FILLER_10_196 ();
 sg13g2_decap_8 FILLER_10_20 ();
 sg13g2_decap_8 FILLER_10_216 ();
 sg13g2_decap_8 FILLER_10_223 ();
 sg13g2_fill_2 FILLER_10_230 ();
 sg13g2_fill_1 FILLER_10_232 ();
 sg13g2_decap_8 FILLER_10_244 ();
 sg13g2_decap_4 FILLER_10_251 ();
 sg13g2_decap_8 FILLER_10_27 ();
 sg13g2_fill_1 FILLER_10_34 ();
 sg13g2_decap_8 FILLER_10_64 ();
 sg13g2_fill_2 FILLER_10_7 ();
 sg13g2_decap_4 FILLER_11_0 ();
 sg13g2_decap_8 FILLER_11_100 ();
 sg13g2_decap_8 FILLER_11_107 ();
 sg13g2_fill_2 FILLER_11_119 ();
 sg13g2_fill_1 FILLER_11_121 ();
 sg13g2_decap_4 FILLER_11_132 ();
 sg13g2_fill_1 FILLER_11_15 ();
 sg13g2_decap_8 FILLER_11_151 ();
 sg13g2_decap_8 FILLER_11_158 ();
 sg13g2_decap_4 FILLER_11_165 ();
 sg13g2_decap_8 FILLER_11_192 ();
 sg13g2_fill_1 FILLER_11_199 ();
 sg13g2_decap_8 FILLER_11_208 ();
 sg13g2_decap_8 FILLER_11_223 ();
 sg13g2_fill_2 FILLER_11_230 ();
 sg13g2_decap_8 FILLER_11_25 ();
 sg13g2_decap_4 FILLER_11_250 ();
 sg13g2_fill_1 FILLER_11_254 ();
 sg13g2_fill_2 FILLER_11_32 ();
 sg13g2_fill_2 FILLER_11_4 ();
 sg13g2_decap_4 FILLER_11_47 ();
 sg13g2_decap_8 FILLER_11_61 ();
 sg13g2_decap_8 FILLER_11_68 ();
 sg13g2_decap_4 FILLER_11_75 ();
 sg13g2_fill_2 FILLER_11_79 ();
 sg13g2_decap_8 FILLER_11_86 ();
 sg13g2_fill_2 FILLER_11_93 ();
 sg13g2_decap_8 FILLER_12_0 ();
 sg13g2_decap_4 FILLER_12_106 ();
 sg13g2_fill_1 FILLER_12_110 ();
 sg13g2_decap_8 FILLER_12_126 ();
 sg13g2_decap_4 FILLER_12_133 ();
 sg13g2_fill_1 FILLER_12_141 ();
 sg13g2_fill_2 FILLER_12_145 ();
 sg13g2_decap_4 FILLER_12_150 ();
 sg13g2_fill_2 FILLER_12_158 ();
 sg13g2_fill_1 FILLER_12_160 ();
 sg13g2_decap_4 FILLER_12_165 ();
 sg13g2_fill_2 FILLER_12_169 ();
 sg13g2_fill_2 FILLER_12_17 ();
 sg13g2_decap_8 FILLER_12_174 ();
 sg13g2_decap_8 FILLER_12_184 ();
 sg13g2_decap_8 FILLER_12_191 ();
 sg13g2_decap_4 FILLER_12_198 ();
 sg13g2_fill_1 FILLER_12_202 ();
 sg13g2_decap_8 FILLER_12_211 ();
 sg13g2_decap_8 FILLER_12_218 ();
 sg13g2_decap_8 FILLER_12_225 ();
 sg13g2_decap_8 FILLER_12_232 ();
 sg13g2_decap_8 FILLER_12_24 ();
 sg13g2_decap_8 FILLER_12_242 ();
 sg13g2_decap_4 FILLER_12_249 ();
 sg13g2_fill_2 FILLER_12_253 ();
 sg13g2_decap_8 FILLER_12_31 ();
 sg13g2_decap_4 FILLER_12_38 ();
 sg13g2_fill_1 FILLER_12_42 ();
 sg13g2_fill_2 FILLER_12_48 ();
 sg13g2_decap_4 FILLER_12_53 ();
 sg13g2_fill_1 FILLER_12_57 ();
 sg13g2_fill_2 FILLER_12_7 ();
 sg13g2_decap_8 FILLER_12_73 ();
 sg13g2_decap_8 FILLER_12_80 ();
 sg13g2_decap_4 FILLER_12_87 ();
 sg13g2_decap_4 FILLER_13_0 ();
 sg13g2_decap_8 FILLER_13_101 ();
 sg13g2_decap_8 FILLER_13_108 ();
 sg13g2_decap_8 FILLER_13_115 ();
 sg13g2_decap_8 FILLER_13_122 ();
 sg13g2_decap_8 FILLER_13_129 ();
 sg13g2_decap_8 FILLER_13_136 ();
 sg13g2_decap_8 FILLER_13_143 ();
 sg13g2_decap_8 FILLER_13_150 ();
 sg13g2_decap_4 FILLER_13_157 ();
 sg13g2_decap_8 FILLER_13_190 ();
 sg13g2_decap_8 FILLER_13_197 ();
 sg13g2_decap_8 FILLER_13_204 ();
 sg13g2_decap_8 FILLER_13_211 ();
 sg13g2_fill_2 FILLER_13_218 ();
 sg13g2_decap_8 FILLER_13_228 ();
 sg13g2_decap_8 FILLER_13_24 ();
 sg13g2_decap_4 FILLER_13_251 ();
 sg13g2_decap_8 FILLER_13_31 ();
 sg13g2_decap_8 FILLER_13_53 ();
 sg13g2_decap_8 FILLER_13_60 ();
 sg13g2_fill_1 FILLER_13_67 ();
 sg13g2_decap_8 FILLER_13_83 ();
 sg13g2_decap_8 FILLER_13_90 ();
 sg13g2_fill_1 FILLER_13_97 ();
 sg13g2_decap_8 FILLER_14_0 ();
 sg13g2_decap_8 FILLER_14_102 ();
 sg13g2_decap_8 FILLER_14_109 ();
 sg13g2_decap_8 FILLER_14_116 ();
 sg13g2_decap_4 FILLER_14_123 ();
 sg13g2_decap_8 FILLER_14_160 ();
 sg13g2_decap_8 FILLER_14_167 ();
 sg13g2_decap_8 FILLER_14_174 ();
 sg13g2_decap_8 FILLER_14_181 ();
 sg13g2_decap_8 FILLER_14_188 ();
 sg13g2_decap_8 FILLER_14_195 ();
 sg13g2_decap_8 FILLER_14_202 ();
 sg13g2_decap_8 FILLER_14_209 ();
 sg13g2_decap_8 FILLER_14_216 ();
 sg13g2_decap_8 FILLER_14_223 ();
 sg13g2_decap_8 FILLER_14_230 ();
 sg13g2_decap_8 FILLER_14_237 ();
 sg13g2_decap_8 FILLER_14_244 ();
 sg13g2_decap_4 FILLER_14_251 ();
 sg13g2_decap_8 FILLER_14_26 ();
 sg13g2_fill_2 FILLER_14_36 ();
 sg13g2_decap_8 FILLER_14_53 ();
 sg13g2_decap_8 FILLER_14_60 ();
 sg13g2_decap_8 FILLER_14_67 ();
 sg13g2_decap_4 FILLER_14_7 ();
 sg13g2_decap_8 FILLER_14_74 ();
 sg13g2_decap_8 FILLER_14_81 ();
 sg13g2_decap_8 FILLER_14_88 ();
 sg13g2_decap_8 FILLER_14_95 ();
 sg13g2_decap_8 FILLER_15_0 ();
 sg13g2_decap_8 FILLER_15_105 ();
 sg13g2_decap_8 FILLER_15_112 ();
 sg13g2_decap_8 FILLER_15_119 ();
 sg13g2_decap_8 FILLER_15_126 ();
 sg13g2_decap_8 FILLER_15_133 ();
 sg13g2_decap_8 FILLER_15_14 ();
 sg13g2_decap_8 FILLER_15_140 ();
 sg13g2_decap_8 FILLER_15_147 ();
 sg13g2_decap_8 FILLER_15_154 ();
 sg13g2_decap_8 FILLER_15_161 ();
 sg13g2_decap_8 FILLER_15_168 ();
 sg13g2_decap_8 FILLER_15_175 ();
 sg13g2_decap_8 FILLER_15_182 ();
 sg13g2_decap_8 FILLER_15_189 ();
 sg13g2_decap_8 FILLER_15_196 ();
 sg13g2_decap_8 FILLER_15_203 ();
 sg13g2_decap_8 FILLER_15_21 ();
 sg13g2_decap_8 FILLER_15_210 ();
 sg13g2_decap_8 FILLER_15_217 ();
 sg13g2_decap_8 FILLER_15_224 ();
 sg13g2_decap_8 FILLER_15_231 ();
 sg13g2_decap_8 FILLER_15_238 ();
 sg13g2_decap_8 FILLER_15_245 ();
 sg13g2_fill_2 FILLER_15_252 ();
 sg13g2_fill_1 FILLER_15_254 ();
 sg13g2_decap_8 FILLER_15_28 ();
 sg13g2_decap_8 FILLER_15_35 ();
 sg13g2_decap_8 FILLER_15_42 ();
 sg13g2_decap_8 FILLER_15_49 ();
 sg13g2_decap_8 FILLER_15_56 ();
 sg13g2_decap_8 FILLER_15_63 ();
 sg13g2_decap_8 FILLER_15_7 ();
 sg13g2_decap_8 FILLER_15_70 ();
 sg13g2_decap_8 FILLER_15_77 ();
 sg13g2_decap_8 FILLER_15_84 ();
 sg13g2_decap_8 FILLER_15_91 ();
 sg13g2_decap_8 FILLER_15_98 ();
 sg13g2_decap_8 FILLER_16_0 ();
 sg13g2_decap_8 FILLER_16_105 ();
 sg13g2_decap_8 FILLER_16_112 ();
 sg13g2_decap_8 FILLER_16_119 ();
 sg13g2_decap_8 FILLER_16_126 ();
 sg13g2_decap_8 FILLER_16_133 ();
 sg13g2_decap_8 FILLER_16_14 ();
 sg13g2_decap_8 FILLER_16_140 ();
 sg13g2_decap_8 FILLER_16_147 ();
 sg13g2_decap_8 FILLER_16_154 ();
 sg13g2_decap_8 FILLER_16_161 ();
 sg13g2_decap_8 FILLER_16_168 ();
 sg13g2_decap_8 FILLER_16_175 ();
 sg13g2_decap_8 FILLER_16_182 ();
 sg13g2_decap_8 FILLER_16_189 ();
 sg13g2_decap_8 FILLER_16_196 ();
 sg13g2_decap_8 FILLER_16_203 ();
 sg13g2_decap_8 FILLER_16_21 ();
 sg13g2_decap_8 FILLER_16_210 ();
 sg13g2_decap_8 FILLER_16_217 ();
 sg13g2_decap_8 FILLER_16_224 ();
 sg13g2_decap_8 FILLER_16_231 ();
 sg13g2_decap_8 FILLER_16_238 ();
 sg13g2_decap_8 FILLER_16_245 ();
 sg13g2_fill_2 FILLER_16_252 ();
 sg13g2_fill_1 FILLER_16_254 ();
 sg13g2_decap_8 FILLER_16_28 ();
 sg13g2_decap_8 FILLER_16_35 ();
 sg13g2_decap_8 FILLER_16_42 ();
 sg13g2_decap_8 FILLER_16_49 ();
 sg13g2_decap_8 FILLER_16_56 ();
 sg13g2_decap_8 FILLER_16_63 ();
 sg13g2_decap_8 FILLER_16_7 ();
 sg13g2_decap_8 FILLER_16_70 ();
 sg13g2_decap_8 FILLER_16_77 ();
 sg13g2_decap_8 FILLER_16_84 ();
 sg13g2_decap_8 FILLER_16_91 ();
 sg13g2_decap_8 FILLER_16_98 ();
 sg13g2_decap_8 FILLER_1_0 ();
 sg13g2_decap_8 FILLER_1_105 ();
 sg13g2_decap_8 FILLER_1_112 ();
 sg13g2_decap_8 FILLER_1_119 ();
 sg13g2_decap_8 FILLER_1_126 ();
 sg13g2_decap_8 FILLER_1_133 ();
 sg13g2_decap_8 FILLER_1_14 ();
 sg13g2_decap_8 FILLER_1_140 ();
 sg13g2_decap_8 FILLER_1_147 ();
 sg13g2_decap_8 FILLER_1_154 ();
 sg13g2_decap_8 FILLER_1_161 ();
 sg13g2_decap_8 FILLER_1_168 ();
 sg13g2_decap_8 FILLER_1_175 ();
 sg13g2_decap_8 FILLER_1_182 ();
 sg13g2_decap_8 FILLER_1_189 ();
 sg13g2_decap_8 FILLER_1_196 ();
 sg13g2_decap_8 FILLER_1_203 ();
 sg13g2_decap_8 FILLER_1_21 ();
 sg13g2_decap_8 FILLER_1_210 ();
 sg13g2_decap_8 FILLER_1_217 ();
 sg13g2_decap_8 FILLER_1_224 ();
 sg13g2_decap_8 FILLER_1_231 ();
 sg13g2_decap_8 FILLER_1_238 ();
 sg13g2_decap_8 FILLER_1_245 ();
 sg13g2_fill_2 FILLER_1_252 ();
 sg13g2_fill_1 FILLER_1_254 ();
 sg13g2_decap_8 FILLER_1_28 ();
 sg13g2_decap_8 FILLER_1_35 ();
 sg13g2_decap_8 FILLER_1_42 ();
 sg13g2_decap_8 FILLER_1_49 ();
 sg13g2_decap_8 FILLER_1_56 ();
 sg13g2_decap_8 FILLER_1_63 ();
 sg13g2_decap_8 FILLER_1_7 ();
 sg13g2_decap_8 FILLER_1_70 ();
 sg13g2_decap_8 FILLER_1_77 ();
 sg13g2_decap_8 FILLER_1_84 ();
 sg13g2_decap_8 FILLER_1_91 ();
 sg13g2_decap_8 FILLER_1_98 ();
 sg13g2_decap_8 FILLER_2_0 ();
 sg13g2_decap_8 FILLER_2_105 ();
 sg13g2_decap_8 FILLER_2_112 ();
 sg13g2_decap_8 FILLER_2_119 ();
 sg13g2_decap_8 FILLER_2_126 ();
 sg13g2_decap_8 FILLER_2_133 ();
 sg13g2_decap_8 FILLER_2_14 ();
 sg13g2_decap_8 FILLER_2_140 ();
 sg13g2_decap_8 FILLER_2_147 ();
 sg13g2_decap_8 FILLER_2_154 ();
 sg13g2_decap_8 FILLER_2_161 ();
 sg13g2_decap_8 FILLER_2_168 ();
 sg13g2_decap_8 FILLER_2_175 ();
 sg13g2_decap_8 FILLER_2_182 ();
 sg13g2_decap_8 FILLER_2_189 ();
 sg13g2_decap_8 FILLER_2_196 ();
 sg13g2_decap_8 FILLER_2_203 ();
 sg13g2_decap_8 FILLER_2_21 ();
 sg13g2_decap_8 FILLER_2_210 ();
 sg13g2_decap_8 FILLER_2_217 ();
 sg13g2_decap_8 FILLER_2_224 ();
 sg13g2_decap_8 FILLER_2_231 ();
 sg13g2_decap_8 FILLER_2_238 ();
 sg13g2_decap_8 FILLER_2_245 ();
 sg13g2_fill_2 FILLER_2_252 ();
 sg13g2_fill_1 FILLER_2_254 ();
 sg13g2_decap_4 FILLER_2_28 ();
 sg13g2_decap_8 FILLER_2_35 ();
 sg13g2_decap_8 FILLER_2_42 ();
 sg13g2_decap_8 FILLER_2_49 ();
 sg13g2_decap_8 FILLER_2_56 ();
 sg13g2_decap_8 FILLER_2_63 ();
 sg13g2_fill_2 FILLER_2_7 ();
 sg13g2_decap_8 FILLER_2_70 ();
 sg13g2_decap_8 FILLER_2_77 ();
 sg13g2_decap_8 FILLER_2_84 ();
 sg13g2_decap_8 FILLER_2_91 ();
 sg13g2_decap_8 FILLER_2_98 ();
 sg13g2_decap_4 FILLER_3_0 ();
 sg13g2_decap_8 FILLER_3_100 ();
 sg13g2_decap_8 FILLER_3_107 ();
 sg13g2_decap_8 FILLER_3_114 ();
 sg13g2_decap_8 FILLER_3_121 ();
 sg13g2_decap_8 FILLER_3_128 ();
 sg13g2_decap_8 FILLER_3_135 ();
 sg13g2_fill_2 FILLER_3_14 ();
 sg13g2_decap_8 FILLER_3_142 ();
 sg13g2_decap_8 FILLER_3_149 ();
 sg13g2_decap_8 FILLER_3_156 ();
 sg13g2_decap_8 FILLER_3_163 ();
 sg13g2_decap_8 FILLER_3_170 ();
 sg13g2_decap_8 FILLER_3_177 ();
 sg13g2_decap_8 FILLER_3_184 ();
 sg13g2_decap_8 FILLER_3_191 ();
 sg13g2_decap_8 FILLER_3_198 ();
 sg13g2_decap_8 FILLER_3_205 ();
 sg13g2_decap_8 FILLER_3_212 ();
 sg13g2_decap_8 FILLER_3_219 ();
 sg13g2_decap_8 FILLER_3_226 ();
 sg13g2_decap_8 FILLER_3_233 ();
 sg13g2_fill_2 FILLER_3_240 ();
 sg13g2_decap_8 FILLER_3_245 ();
 sg13g2_fill_2 FILLER_3_252 ();
 sg13g2_fill_1 FILLER_3_254 ();
 sg13g2_fill_1 FILLER_3_31 ();
 sg13g2_decap_8 FILLER_3_42 ();
 sg13g2_decap_8 FILLER_3_49 ();
 sg13g2_decap_8 FILLER_3_56 ();
 sg13g2_decap_8 FILLER_3_63 ();
 sg13g2_decap_8 FILLER_3_70 ();
 sg13g2_decap_4 FILLER_3_77 ();
 sg13g2_decap_8 FILLER_3_86 ();
 sg13g2_decap_8 FILLER_3_93 ();
 sg13g2_decap_8 FILLER_4_0 ();
 sg13g2_decap_8 FILLER_4_102 ();
 sg13g2_decap_8 FILLER_4_109 ();
 sg13g2_decap_8 FILLER_4_126 ();
 sg13g2_decap_8 FILLER_4_133 ();
 sg13g2_decap_8 FILLER_4_14 ();
 sg13g2_decap_8 FILLER_4_155 ();
 sg13g2_decap_8 FILLER_4_162 ();
 sg13g2_decap_8 FILLER_4_169 ();
 sg13g2_decap_8 FILLER_4_184 ();
 sg13g2_decap_8 FILLER_4_191 ();
 sg13g2_decap_8 FILLER_4_198 ();
 sg13g2_decap_8 FILLER_4_205 ();
 sg13g2_decap_8 FILLER_4_21 ();
 sg13g2_decap_8 FILLER_4_212 ();
 sg13g2_decap_8 FILLER_4_219 ();
 sg13g2_decap_8 FILLER_4_226 ();
 sg13g2_decap_4 FILLER_4_233 ();
 sg13g2_decap_4 FILLER_4_250 ();
 sg13g2_fill_1 FILLER_4_254 ();
 sg13g2_decap_8 FILLER_4_28 ();
 sg13g2_decap_8 FILLER_4_35 ();
 sg13g2_decap_8 FILLER_4_42 ();
 sg13g2_fill_2 FILLER_4_49 ();
 sg13g2_decap_8 FILLER_4_56 ();
 sg13g2_decap_8 FILLER_4_63 ();
 sg13g2_fill_2 FILLER_4_7 ();
 sg13g2_decap_8 FILLER_4_70 ();
 sg13g2_decap_8 FILLER_4_95 ();
 sg13g2_fill_2 FILLER_5_0 ();
 sg13g2_fill_1 FILLER_5_103 ();
 sg13g2_decap_8 FILLER_5_124 ();
 sg13g2_decap_4 FILLER_5_131 ();
 sg13g2_fill_1 FILLER_5_135 ();
 sg13g2_decap_8 FILLER_5_154 ();
 sg13g2_decap_8 FILLER_5_161 ();
 sg13g2_decap_4 FILLER_5_168 ();
 sg13g2_fill_1 FILLER_5_172 ();
 sg13g2_decap_4 FILLER_5_190 ();
 sg13g2_fill_1 FILLER_5_198 ();
 sg13g2_fill_1 FILLER_5_20 ();
 sg13g2_decap_8 FILLER_5_207 ();
 sg13g2_decap_4 FILLER_5_214 ();
 sg13g2_fill_1 FILLER_5_218 ();
 sg13g2_fill_2 FILLER_5_227 ();
 sg13g2_fill_1 FILLER_5_229 ();
 sg13g2_decap_8 FILLER_5_238 ();
 sg13g2_decap_8 FILLER_5_245 ();
 sg13g2_fill_2 FILLER_5_252 ();
 sg13g2_fill_1 FILLER_5_254 ();
 sg13g2_fill_2 FILLER_5_41 ();
 sg13g2_decap_4 FILLER_5_48 ();
 sg13g2_decap_8 FILLER_5_65 ();
 sg13g2_decap_4 FILLER_5_72 ();
 sg13g2_decap_8 FILLER_5_96 ();
 sg13g2_decap_8 FILLER_6_0 ();
 sg13g2_decap_8 FILLER_6_100 ();
 sg13g2_decap_4 FILLER_6_107 ();
 sg13g2_fill_1 FILLER_6_111 ();
 sg13g2_decap_8 FILLER_6_120 ();
 sg13g2_decap_8 FILLER_6_127 ();
 sg13g2_decap_8 FILLER_6_134 ();
 sg13g2_fill_1 FILLER_6_141 ();
 sg13g2_decap_8 FILLER_6_15 ();
 sg13g2_decap_8 FILLER_6_152 ();
 sg13g2_decap_8 FILLER_6_159 ();
 sg13g2_decap_4 FILLER_6_166 ();
 sg13g2_fill_1 FILLER_6_170 ();
 sg13g2_decap_8 FILLER_6_183 ();
 sg13g2_decap_8 FILLER_6_190 ();
 sg13g2_decap_4 FILLER_6_197 ();
 sg13g2_decap_8 FILLER_6_22 ();
 sg13g2_decap_8 FILLER_6_220 ();
 sg13g2_decap_8 FILLER_6_227 ();
 sg13g2_fill_1 FILLER_6_234 ();
 sg13g2_decap_4 FILLER_6_251 ();
 sg13g2_decap_8 FILLER_6_29 ();
 sg13g2_fill_2 FILLER_6_36 ();
 sg13g2_fill_1 FILLER_6_38 ();
 sg13g2_decap_8 FILLER_6_54 ();
 sg13g2_decap_8 FILLER_6_61 ();
 sg13g2_decap_8 FILLER_6_68 ();
 sg13g2_decap_8 FILLER_6_75 ();
 sg13g2_decap_8 FILLER_6_86 ();
 sg13g2_decap_8 FILLER_6_93 ();
 sg13g2_fill_2 FILLER_7_0 ();
 sg13g2_fill_2 FILLER_7_105 ();
 sg13g2_decap_8 FILLER_7_122 ();
 sg13g2_decap_8 FILLER_7_129 ();
 sg13g2_fill_1 FILLER_7_15 ();
 sg13g2_decap_8 FILLER_7_156 ();
 sg13g2_decap_8 FILLER_7_163 ();
 sg13g2_decap_4 FILLER_7_170 ();
 sg13g2_decap_8 FILLER_7_187 ();
 sg13g2_decap_8 FILLER_7_194 ();
 sg13g2_decap_4 FILLER_7_201 ();
 sg13g2_fill_1 FILLER_7_205 ();
 sg13g2_decap_8 FILLER_7_217 ();
 sg13g2_decap_8 FILLER_7_224 ();
 sg13g2_decap_8 FILLER_7_247 ();
 sg13g2_fill_1 FILLER_7_254 ();
 sg13g2_decap_8 FILLER_7_29 ();
 sg13g2_decap_4 FILLER_7_36 ();
 sg13g2_fill_1 FILLER_7_40 ();
 sg13g2_decap_8 FILLER_7_46 ();
 sg13g2_decap_8 FILLER_7_53 ();
 sg13g2_decap_8 FILLER_7_60 ();
 sg13g2_fill_2 FILLER_7_67 ();
 sg13g2_decap_8 FILLER_7_91 ();
 sg13g2_decap_8 FILLER_7_98 ();
 sg13g2_decap_8 FILLER_8_0 ();
 sg13g2_fill_2 FILLER_8_100 ();
 sg13g2_decap_8 FILLER_8_120 ();
 sg13g2_decap_8 FILLER_8_127 ();
 sg13g2_fill_2 FILLER_8_13 ();
 sg13g2_decap_8 FILLER_8_134 ();
 sg13g2_fill_1 FILLER_8_146 ();
 sg13g2_decap_8 FILLER_8_155 ();
 sg13g2_decap_8 FILLER_8_162 ();
 sg13g2_decap_4 FILLER_8_169 ();
 sg13g2_fill_2 FILLER_8_173 ();
 sg13g2_decap_8 FILLER_8_180 ();
 sg13g2_decap_4 FILLER_8_187 ();
 sg13g2_fill_2 FILLER_8_19 ();
 sg13g2_fill_2 FILLER_8_191 ();
 sg13g2_decap_8 FILLER_8_209 ();
 sg13g2_decap_8 FILLER_8_216 ();
 sg13g2_decap_8 FILLER_8_223 ();
 sg13g2_decap_4 FILLER_8_230 ();
 sg13g2_decap_4 FILLER_8_250 ();
 sg13g2_fill_1 FILLER_8_254 ();
 sg13g2_decap_8 FILLER_8_30 ();
 sg13g2_decap_4 FILLER_8_37 ();
 sg13g2_fill_1 FILLER_8_50 ();
 sg13g2_decap_4 FILLER_8_59 ();
 sg13g2_fill_1 FILLER_8_63 ();
 sg13g2_fill_2 FILLER_8_7 ();
 sg13g2_fill_2 FILLER_8_73 ();
 sg13g2_fill_1 FILLER_8_75 ();
 sg13g2_decap_8 FILLER_8_89 ();
 sg13g2_decap_4 FILLER_8_96 ();
 sg13g2_decap_4 FILLER_9_0 ();
 sg13g2_decap_4 FILLER_9_101 ();
 sg13g2_fill_2 FILLER_9_105 ();
 sg13g2_decap_8 FILLER_9_132 ();
 sg13g2_decap_8 FILLER_9_139 ();
 sg13g2_decap_4 FILLER_9_146 ();
 sg13g2_fill_2 FILLER_9_150 ();
 sg13g2_decap_4 FILLER_9_155 ();
 sg13g2_fill_2 FILLER_9_159 ();
 sg13g2_decap_8 FILLER_9_191 ();
 sg13g2_decap_8 FILLER_9_198 ();
 sg13g2_decap_4 FILLER_9_205 ();
 sg13g2_decap_8 FILLER_9_225 ();
 sg13g2_decap_8 FILLER_9_23 ();
 sg13g2_decap_8 FILLER_9_248 ();
 sg13g2_decap_8 FILLER_9_30 ();
 sg13g2_decap_8 FILLER_9_37 ();
 sg13g2_fill_1 FILLER_9_4 ();
 sg13g2_decap_8 FILLER_9_44 ();
 sg13g2_decap_8 FILLER_9_51 ();
 sg13g2_decap_8 FILLER_9_58 ();
 sg13g2_fill_2 FILLER_9_65 ();
 sg13g2_fill_1 FILLER_9_67 ();
 sg13g2_decap_8 FILLER_9_72 ();
 sg13g2_fill_2 FILLER_9_79 ();
 sg13g2_fill_1 FILLER_9_81 ();
 sg13g2_decap_8 FILLER_9_87 ();
 sg13g2_decap_8 FILLER_9_94 ();
 sg13g2_buf_1 \pll_ana_dco/coarse/impl_last_impl  (.A(\pll_ana_dco/coarse/FCHAIN_15_ ),
    .X(\pll_ana_dco/coarse/RCHAIN_15_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_0_impl/dwn_impl  (.Y(\pll_ana_dco/COARSE_OUT ),
    .A(\pll_ana_dco/coarse/stage_0_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_1_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_0_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_0_impl/PATH_0 ),
    .B(OUT),
    .A_N(COARSE_MUX[0]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_0_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_1_ ),
    .A(COARSE_MUX[0]),
    .B(OUT));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_10_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_10_ ),
    .A(\pll_ana_dco/coarse/stage_10_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_11_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_10_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_10_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_10_ ),
    .A_N(COARSE_MUX[10]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_10_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_11_ ),
    .A(COARSE_MUX[10]),
    .B(\pll_ana_dco/coarse/FCHAIN_10_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_11_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_11_ ),
    .A(\pll_ana_dco/coarse/stage_11_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_12_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_11_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_11_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_11_ ),
    .A_N(COARSE_MUX[11]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_11_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_12_ ),
    .A(COARSE_MUX[11]),
    .B(\pll_ana_dco/coarse/FCHAIN_11_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_12_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_12_ ),
    .A(\pll_ana_dco/coarse/stage_12_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_13_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_12_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_12_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_12_ ),
    .A_N(COARSE_MUX[12]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_12_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_13_ ),
    .A(COARSE_MUX[12]),
    .B(\pll_ana_dco/coarse/FCHAIN_12_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_13_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_13_ ),
    .A(\pll_ana_dco/coarse/stage_13_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_14_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_13_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_13_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_13_ ),
    .A_N(COARSE_MUX[13]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_13_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_14_ ),
    .A(COARSE_MUX[13]),
    .B(\pll_ana_dco/coarse/FCHAIN_13_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_14_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_14_ ),
    .A(\pll_ana_dco/coarse/stage_14_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_15_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_14_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_14_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_14_ ),
    .A_N(COARSE_MUX[14]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_14_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_15_ ),
    .A(COARSE_MUX[14]),
    .B(\pll_ana_dco/coarse/FCHAIN_14_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_1_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_1_ ),
    .A(\pll_ana_dco/coarse/stage_1_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_2_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_1_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_1_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_1_ ),
    .A_N(COARSE_MUX[1]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_1_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_2_ ),
    .A(COARSE_MUX[1]),
    .B(\pll_ana_dco/coarse/FCHAIN_1_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_2_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_2_ ),
    .A(\pll_ana_dco/coarse/stage_2_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_3_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_2_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_2_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_2_ ),
    .A_N(COARSE_MUX[2]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_2_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_3_ ),
    .A(COARSE_MUX[2]),
    .B(\pll_ana_dco/coarse/FCHAIN_2_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_3_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_3_ ),
    .A(\pll_ana_dco/coarse/stage_3_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_4_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_3_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_3_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_3_ ),
    .A_N(COARSE_MUX[3]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_3_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_4_ ),
    .A(COARSE_MUX[3]),
    .B(\pll_ana_dco/coarse/FCHAIN_3_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_4_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_4_ ),
    .A(\pll_ana_dco/coarse/stage_4_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_5_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_4_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_4_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_4_ ),
    .A_N(COARSE_MUX[4]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_4_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_5_ ),
    .A(COARSE_MUX[4]),
    .B(\pll_ana_dco/coarse/FCHAIN_4_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_5_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_5_ ),
    .A(\pll_ana_dco/coarse/stage_5_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_6_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_5_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_5_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_5_ ),
    .A_N(COARSE_MUX[5]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_5_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_6_ ),
    .A(COARSE_MUX[5]),
    .B(\pll_ana_dco/coarse/FCHAIN_5_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_6_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_6_ ),
    .A(\pll_ana_dco/coarse/stage_6_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_7_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_6_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_6_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_6_ ),
    .A_N(COARSE_MUX[6]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_6_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_7_ ),
    .A(COARSE_MUX[6]),
    .B(\pll_ana_dco/coarse/FCHAIN_6_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_7_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_7_ ),
    .A(\pll_ana_dco/coarse/stage_7_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_8_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_7_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_7_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_7_ ),
    .A_N(COARSE_MUX[7]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_7_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_8_ ),
    .A(COARSE_MUX[7]),
    .B(\pll_ana_dco/coarse/FCHAIN_7_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_8_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_8_ ),
    .A(\pll_ana_dco/coarse/stage_8_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_9_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_8_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_8_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_8_ ),
    .A_N(COARSE_MUX[8]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_8_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_9_ ),
    .A(COARSE_MUX[8]),
    .B(\pll_ana_dco/coarse/FCHAIN_8_ ));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_9_impl/dwn_impl  (.Y(\pll_ana_dco/coarse/RCHAIN_9_ ),
    .A(\pll_ana_dco/coarse/stage_9_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/RCHAIN_10_ ));
 sg13g2_nand2b_1 \pll_ana_dco/coarse/stage_9_impl/mid_impl  (.Y(\pll_ana_dco/coarse/stage_9_impl/PATH_0 ),
    .B(\pll_ana_dco/coarse/FCHAIN_9_ ),
    .A_N(COARSE_MUX[9]));
 sg13g2_nand2_1 \pll_ana_dco/coarse/stage_9_impl/upp_impl  (.Y(\pll_ana_dco/coarse/FCHAIN_10_ ),
    .A(COARSE_MUX[9]),
    .B(\pll_ana_dco/coarse/FCHAIN_9_ ));
 sg13g2_dfrbp_1 \pll_ana_dco/dff_x_impl  (.RESET_B(\pll_ana_dco/dff_x_RESET_B ),
    .D(\pll_ana_dco/SS_BBPD_WIRE_1_ ),
    .Q(SS_BBPD[1]),
    .CLK(\pll_ana_dco/dff_x_CLK ));
 sg13g2_inv_1 \pll_ana_dco/dff_x_impl_inv  (.Y(\pll_ana_dco/dff_x_CLK ),
    .A(INJ_EDGE));
 sg13g2_tiehi \pll_ana_dco/dff_x_impl_tiehi  (.L_HI(\pll_ana_dco/dff_x_RESET_B ));
 sg13g2_dfrbp_1 \pll_ana_dco/dff_y_impl  (.RESET_B(\pll_ana_dco/dff_y_RESET_B ),
    .D(\pll_ana_dco/SS_BBPD_WIRE_0_ ),
    .Q(SS_BBPD[0]),
    .CLK(\pll_ana_dco/dff_y_CLK ));
 sg13g2_inv_1 \pll_ana_dco/dff_y_impl_inv  (.Y(\pll_ana_dco/dff_y_CLK ),
    .A(INJ_EDGE));
 sg13g2_tiehi \pll_ana_dco/dff_y_impl_tiehi  (.L_HI(\pll_ana_dco/dff_y_RESET_B ));
 sg13g2_inv_4 \pll_ana_dco/fine/inv_0_impl  (.A(MID_OUT),
    .Y(\pll_ana_dco/fine/LOAD ));
 sg13g2_inv_4 \pll_ana_dco/fine/inv_1_impl  (.A(\pll_ana_dco/fine/LOAD ),
    .Y(\pll_ana_dco/FINE_OUT ));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_0_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[0]),
    .A(\pll_ana_dco/fine/MUXB_0_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_0_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_0_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_0_ ),
    .A(FINE_MUX[0]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_10_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[10]),
    .A(\pll_ana_dco/fine/MUXB_10_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_10_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_10_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_10_ ),
    .A(FINE_MUX[10]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_11_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[11]),
    .A(\pll_ana_dco/fine/MUXB_11_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_11_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_11_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_11_ ),
    .A(FINE_MUX[11]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_12_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[12]),
    .A(\pll_ana_dco/fine/MUXB_12_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_12_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_12_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_12_ ),
    .A(FINE_MUX[12]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_13_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[13]),
    .A(\pll_ana_dco/fine/MUXB_13_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_13_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_13_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_13_ ),
    .A(FINE_MUX[13]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_14_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[14]),
    .A(\pll_ana_dco/fine/MUXB_14_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_14_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_14_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_14_ ),
    .A(FINE_MUX[14]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_15_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[15]),
    .A(\pll_ana_dco/fine/MUXB_15_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_15_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_15_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_15_ ),
    .A(FINE_MUX[15]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_16_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[16]),
    .A(\pll_ana_dco/fine/MUXB_16_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_16_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_16_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_16_ ),
    .A(FINE_MUX[16]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_17_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[17]),
    .A(\pll_ana_dco/fine/MUXB_17_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_17_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_17_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_17_ ),
    .A(FINE_MUX[17]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_18_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[18]),
    .A(\pll_ana_dco/fine/MUXB_18_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_18_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_18_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_18_ ),
    .A(FINE_MUX[18]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_19_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[19]),
    .A(\pll_ana_dco/fine/MUXB_19_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_19_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_19_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_19_ ),
    .A(FINE_MUX[19]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_1_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[1]),
    .A(\pll_ana_dco/fine/MUXB_1_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_1_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_1_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_1_ ),
    .A(FINE_MUX[1]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_20_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[20]),
    .A(\pll_ana_dco/fine/MUXB_20_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_20_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_20_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_20_ ),
    .A(FINE_MUX[20]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_21_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[21]),
    .A(\pll_ana_dco/fine/MUXB_21_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_21_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_21_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_21_ ),
    .A(FINE_MUX[21]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_22_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[22]),
    .A(\pll_ana_dco/fine/MUXB_22_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_22_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_22_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_22_ ),
    .A(FINE_MUX[22]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_23_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[23]),
    .A(\pll_ana_dco/fine/MUXB_23_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_23_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_23_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_23_ ),
    .A(FINE_MUX[23]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_24_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[24]),
    .A(\pll_ana_dco/fine/MUXB_24_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_24_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_24_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_24_ ),
    .A(FINE_MUX[24]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_25_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[25]),
    .A(\pll_ana_dco/fine/MUXB_25_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_25_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_25_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_25_ ),
    .A(FINE_MUX[25]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_26_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[26]),
    .A(\pll_ana_dco/fine/MUXB_26_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_26_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_26_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_26_ ),
    .A(FINE_MUX[26]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_27_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[27]),
    .A(\pll_ana_dco/fine/MUXB_27_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_27_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_27_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_27_ ),
    .A(FINE_MUX[27]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_28_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[28]),
    .A(\pll_ana_dco/fine/MUXB_28_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_28_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_28_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_28_ ),
    .A(FINE_MUX[28]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_29_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[29]),
    .A(\pll_ana_dco/fine/MUXB_29_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_29_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_29_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_29_ ),
    .A(FINE_MUX[29]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_2_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[2]),
    .A(\pll_ana_dco/fine/MUXB_2_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_2_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_2_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_2_ ),
    .A(FINE_MUX[2]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_30_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[30]),
    .A(\pll_ana_dco/fine/MUXB_30_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_30_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_30_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_30_ ),
    .A(FINE_MUX[30]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_3_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[3]),
    .A(\pll_ana_dco/fine/MUXB_3_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_3_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_3_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_3_ ),
    .A(FINE_MUX[3]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_4_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[4]),
    .A(\pll_ana_dco/fine/MUXB_4_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_4_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_4_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_4_ ),
    .A(FINE_MUX[4]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_5_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[5]),
    .A(\pll_ana_dco/fine/MUXB_5_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_5_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_5_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_5_ ),
    .A(FINE_MUX[5]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_6_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[6]),
    .A(\pll_ana_dco/fine/MUXB_6_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_6_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_6_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_6_ ),
    .A(FINE_MUX[6]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_7_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[7]),
    .A(\pll_ana_dco/fine/MUXB_7_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_7_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_7_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_7_ ),
    .A(FINE_MUX[7]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_8_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[8]),
    .A(\pll_ana_dco/fine/MUXB_8_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_8_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_8_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_8_ ),
    .A(FINE_MUX[8]));
 sg13g2_nand3_1 \pll_ana_dco/fine/stage_9_dyn_impl  (.B(\pll_ana_dco/fine/LOAD ),
    .C(FINE_MUX[9]),
    .A(\pll_ana_dco/fine/MUXB_9_ ),
    .Y(\pll_ana_dco/fine/UNCONNECTED_9_ ));
 sg13g2_inv_1 \pll_ana_dco/fine/stage_9_inv_b_impl  (.Y(\pll_ana_dco/fine/MUXB_9_ ),
    .A(FINE_MUX[9]));
 sg13g2_inv_2 \pll_ana_dco/mid/inv_0_impl  (.Y(\pll_ana_dco/mid/LOAD ),
    .A(\pll_ana_dco/COARSE_OUT ));
 sg13g2_inv_2 \pll_ana_dco/mid/inv_1_impl  (.Y(MID_OUT),
    .A(\pll_ana_dco/mid/LOAD ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_0_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_0_ ),
    .A(MID_MUX[0]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_10_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_10_ ),
    .A(MID_MUX[10]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_11_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_11_ ),
    .A(MID_MUX[11]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_12_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_12_ ),
    .A(MID_MUX[12]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_13_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_13_ ),
    .A(MID_MUX[13]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_14_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_14_ ),
    .A(MID_MUX[14]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_1_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_1_ ),
    .A(MID_MUX[1]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_2_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_2_ ),
    .A(MID_MUX[2]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_3_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_3_ ),
    .A(MID_MUX[3]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_4_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_4_ ),
    .A(MID_MUX[4]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_5_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_5_ ),
    .A(MID_MUX[5]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_6_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_6_ ),
    .A(MID_MUX[6]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_7_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[7]),
    .A(\pll_ana_dco/mid/MUXB_7_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_7_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_7_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_7_ ),
    .A(MID_MUX[7]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_8_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[8]),
    .A(\pll_ana_dco/mid/MUXB_8_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_8_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_8_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_8_ ),
    .A(MID_MUX[8]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_0  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_1  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_2  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_3  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_4  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_5  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_6  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_9_dyn_impl_7  (.B(\pll_ana_dco/mid/LOAD ),
    .C(MID_MUX[9]),
    .A(\pll_ana_dco/mid/MUXB_9_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_9_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_9_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_9_ ),
    .A(MID_MUX[9]));
 sg13g2_inv_1 \pll_ana_dco/sym/inj_dummy_inv_impl  (.Y(\pll_ana_dco/sym/INJ_DUMMY ),
    .A(\pll_ana_dco/sym/INJ_EDGE_BALANCED ));
 sg13g2_inv_1 \pll_ana_dco/sym/inj_slope_balancer_impl  (.Y(\pll_ana_dco/sym/INJ_EDGE_BALANCED ),
    .A(INJ_EDGE));
 sg13g2_inv_1 \pll_ana_dco/sym/osc_dummy_inv_impl  (.Y(\pll_ana_dco/sym/OSC_DUMMY ),
    .A(\pll_ana_dco/sym/OSC_BALANCED ));
 sg13g2_inv_1 \pll_ana_dco/sym/osc_slope_balancer_impl  (.Y(\pll_ana_dco/sym/OSC_BALANCED ),
    .A(\pll_ana_dco/FINE_OUT ));
 sg13g2_buf_1 \pll_ana_dco/sym/ssbbpd_impl/buf_nand_x_impl  (.A(\pll_ana_dco/sym/ssbbpd_impl/OUT_NANDX ),
    .X(\pll_ana_dco/SS_BBPD_WIRE_1_ ));
 sg13g2_buf_1 \pll_ana_dco/sym/ssbbpd_impl/buf_nand_y_impl  (.A(\pll_ana_dco/sym/ssbbpd_impl/OUT_NANDY ),
    .X(\pll_ana_dco/SS_BBPD_WIRE_0_ ));
 sg13g2_nand2_1 \pll_ana_dco/sym/ssbbpd_impl/nand_x_impl  (.Y(\pll_ana_dco/sym/ssbbpd_impl/OUT_NANDX ),
    .A(\pll_ana_dco/sym/OSC_BALANCED ),
    .B(\pll_ana_dco/sym/ssbbpd_impl/OUT_NANDY ));
 sg13g2_nand2_1 \pll_ana_dco/sym/ssbbpd_impl/nand_y_impl  (.Y(\pll_ana_dco/sym/ssbbpd_impl/OUT_NANDY ),
    .A(\pll_ana_dco/sym/INJ_EDGE_BALANCED ),
    .B(\pll_ana_dco/sym/ssbbpd_impl/OUT_NANDX ));
 sg13g2_nand2_1 \pll_ana_dco/sym/sym_mux/nand_inj_impl  (.Y(\pll_ana_dco/sym/sym_mux/OSC_INJ ),
    .A(\pll_ana_dco/sym/OSC_BALANCED ),
    .B(\pll_ana_dco/sym/sym_mux/DCO_EN_INJ_WIN ));
 sg13g2_nand2_1 \pll_ana_dco/sym/sym_mux/nand_pll_impl  (.Y(OUT),
    .A(\pll_ana_dco/sym/sym_mux/REF_INJ ),
    .B(\pll_ana_dco/sym/sym_mux/OSC_INJ ));
 sg13g2_nand2b_1 \pll_ana_dco/sym/sym_mux/nand_ref_impl  (.Y(\pll_ana_dco/sym/sym_mux/REF_INJ ),
    .B(pll_ana_INJ_WIN),
    .A_N(\pll_ana_dco/sym/INJ_EDGE_BALANCED ));
 sg13g2_nor2b_1 \pll_ana_dco/sym/sym_mux/norb_en_inj_impl  (.A(pll_ana_INJ_WIN),
    .B_N(DCO_EN),
    .Y(\pll_ana_dco/sym/sym_mux/DCO_EN_INJ_WIN ));
 sg13g2_nor2_1 \pll_ana_inj/cmp_nor_cmp_impl  (.A(\pll_ana_inj/CHAIN_OUT ),
    .B(REF),
    .Y(pll_ana_INJ_WIN));
 sg13g2_nand2_1 \pll_ana_inj/cmp_nor_del_en_impl  (.Y(\pll_ana_inj/CHAIN_OUT ),
    .A(INJ_EN),
    .B(\pll_ana_inj/CHAIN_2_4_ ));
 sg13g2_buf_1 \pll_ana_inj/stage_0_del_1_impl  (.A(REF),
    .X(\pll_ana_inj/CHAIN_1_1_ ));
 sg13g2_buf_1 \pll_ana_inj/stage_0_del_2_impl  (.A(INJ_EDGE),
    .X(\pll_ana_inj/CHAIN_2_1_ ));
 sg13g2_buf_1 \pll_ana_inj/stage_1_del_1_impl  (.A(\pll_ana_inj/CHAIN_1_1_ ),
    .X(\pll_ana_inj/CHAIN_1_2_ ));
 sg13g2_buf_1 \pll_ana_inj/stage_1_del_2_impl  (.A(\pll_ana_inj/CHAIN_2_1_ ),
    .X(\pll_ana_inj/CHAIN_2_2_ ));
 sg13g2_buf_1 \pll_ana_inj/stage_2_del_1_impl  (.A(\pll_ana_inj/CHAIN_1_2_ ),
    .X(\pll_ana_inj/CHAIN_1_3_ ));
 sg13g2_buf_1 \pll_ana_inj/stage_2_del_2_impl  (.A(\pll_ana_inj/CHAIN_2_2_ ),
    .X(\pll_ana_inj/CHAIN_2_3_ ));
 sg13g2_buf_1 \pll_ana_inj/stage_3_del_1_impl  (.A(\pll_ana_inj/CHAIN_1_3_ ),
    .X(INJ_EDGE));
 sg13g2_buf_1 \pll_ana_inj/stage_3_del_2_impl  (.A(\pll_ana_inj/CHAIN_2_3_ ),
    .X(\pll_ana_inj/CHAIN_2_4_ ));
endmodule
