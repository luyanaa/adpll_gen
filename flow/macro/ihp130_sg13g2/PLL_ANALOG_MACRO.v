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
    VDD,
    VSS);
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
 inout VDD;
 inout VSS;

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
 wire net1;
 wire net2;

 sg13g2_fill_2 FILLER_0_0 ();
 sg13g2_fill_1 FILLER_0_103 ();
 sg13g2_decap_8 FILLER_0_109 ();
 sg13g2_decap_8 FILLER_0_116 ();
 sg13g2_decap_8 FILLER_0_12 ();
 sg13g2_decap_8 FILLER_0_123 ();
 sg13g2_decap_8 FILLER_0_130 ();
 sg13g2_decap_8 FILLER_0_137 ();
 sg13g2_decap_8 FILLER_0_144 ();
 sg13g2_decap_8 FILLER_0_151 ();
 sg13g2_decap_8 FILLER_0_158 ();
 sg13g2_decap_8 FILLER_0_165 ();
 sg13g2_decap_8 FILLER_0_172 ();
 sg13g2_decap_8 FILLER_0_179 ();
 sg13g2_decap_8 FILLER_0_186 ();
 sg13g2_decap_4 FILLER_0_19 ();
 sg13g2_decap_8 FILLER_0_193 ();
 sg13g2_fill_1 FILLER_0_2 ();
 sg13g2_decap_8 FILLER_0_200 ();
 sg13g2_fill_1 FILLER_0_207 ();
 sg13g2_decap_8 FILLER_0_213 ();
 sg13g2_fill_2 FILLER_0_220 ();
 sg13g2_fill_1 FILLER_0_222 ();
 sg13g2_fill_2 FILLER_0_23 ();
 sg13g2_decap_8 FILLER_0_30 ();
 sg13g2_decap_8 FILLER_0_37 ();
 sg13g2_decap_8 FILLER_0_44 ();
 sg13g2_decap_8 FILLER_0_56 ();
 sg13g2_decap_8 FILLER_0_63 ();
 sg13g2_decap_8 FILLER_0_70 ();
 sg13g2_decap_8 FILLER_0_82 ();
 sg13g2_decap_8 FILLER_0_89 ();
 sg13g2_decap_8 FILLER_0_96 ();
 sg13g2_decap_8 FILLER_10_0 ();
 sg13g2_decap_8 FILLER_10_101 ();
 sg13g2_decap_8 FILLER_10_108 ();
 sg13g2_decap_8 FILLER_10_115 ();
 sg13g2_decap_8 FILLER_10_122 ();
 sg13g2_decap_8 FILLER_10_129 ();
 sg13g2_fill_1 FILLER_10_136 ();
 sg13g2_decap_8 FILLER_10_14 ();
 sg13g2_decap_8 FILLER_10_145 ();
 sg13g2_decap_8 FILLER_10_152 ();
 sg13g2_decap_8 FILLER_10_159 ();
 sg13g2_decap_4 FILLER_10_166 ();
 sg13g2_fill_1 FILLER_10_180 ();
 sg13g2_fill_1 FILLER_10_189 ();
 sg13g2_decap_8 FILLER_10_198 ();
 sg13g2_decap_4 FILLER_10_205 ();
 sg13g2_fill_2 FILLER_10_209 ();
 sg13g2_decap_8 FILLER_10_21 ();
 sg13g2_decap_8 FILLER_10_216 ();
 sg13g2_decap_8 FILLER_10_28 ();
 sg13g2_decap_8 FILLER_10_35 ();
 sg13g2_decap_8 FILLER_10_42 ();
 sg13g2_decap_8 FILLER_10_49 ();
 sg13g2_decap_8 FILLER_10_56 ();
 sg13g2_decap_8 FILLER_10_63 ();
 sg13g2_decap_8 FILLER_10_7 ();
 sg13g2_decap_4 FILLER_10_70 ();
 sg13g2_decap_8 FILLER_10_80 ();
 sg13g2_decap_8 FILLER_10_87 ();
 sg13g2_decap_8 FILLER_10_94 ();
 sg13g2_decap_8 FILLER_11_0 ();
 sg13g2_decap_8 FILLER_11_104 ();
 sg13g2_decap_4 FILLER_11_111 ();
 sg13g2_fill_2 FILLER_11_115 ();
 sg13g2_decap_8 FILLER_11_125 ();
 sg13g2_decap_8 FILLER_11_132 ();
 sg13g2_fill_2 FILLER_11_139 ();
 sg13g2_fill_1 FILLER_11_141 ();
 sg13g2_decap_8 FILLER_11_16 ();
 sg13g2_decap_8 FILLER_11_171 ();
 sg13g2_decap_8 FILLER_11_178 ();
 sg13g2_decap_8 FILLER_11_185 ();
 sg13g2_decap_8 FILLER_11_192 ();
 sg13g2_decap_8 FILLER_11_199 ();
 sg13g2_fill_2 FILLER_11_206 ();
 sg13g2_fill_1 FILLER_11_208 ();
 sg13g2_decap_4 FILLER_11_218 ();
 sg13g2_fill_1 FILLER_11_222 ();
 sg13g2_decap_8 FILLER_11_23 ();
 sg13g2_decap_8 FILLER_11_30 ();
 sg13g2_decap_8 FILLER_11_42 ();
 sg13g2_decap_8 FILLER_11_49 ();
 sg13g2_decap_8 FILLER_11_56 ();
 sg13g2_fill_1 FILLER_11_63 ();
 sg13g2_decap_8 FILLER_11_69 ();
 sg13g2_decap_4 FILLER_11_7 ();
 sg13g2_decap_8 FILLER_11_76 ();
 sg13g2_decap_8 FILLER_11_83 ();
 sg13g2_fill_2 FILLER_11_90 ();
 sg13g2_decap_8 FILLER_11_97 ();
 sg13g2_fill_1 FILLER_12_0 ();
 sg13g2_fill_2 FILLER_12_107 ();
 sg13g2_fill_1 FILLER_12_109 ();
 sg13g2_fill_1 FILLER_12_11 ();
 sg13g2_decap_8 FILLER_12_135 ();
 sg13g2_decap_8 FILLER_12_142 ();
 sg13g2_decap_8 FILLER_12_149 ();
 sg13g2_fill_1 FILLER_12_15 ();
 sg13g2_decap_8 FILLER_12_156 ();
 sg13g2_decap_8 FILLER_12_163 ();
 sg13g2_decap_8 FILLER_12_170 ();
 sg13g2_decap_8 FILLER_12_177 ();
 sg13g2_decap_8 FILLER_12_184 ();
 sg13g2_decap_8 FILLER_12_191 ();
 sg13g2_fill_2 FILLER_12_198 ();
 sg13g2_fill_1 FILLER_12_200 ();
 sg13g2_fill_1 FILLER_12_211 ();
 sg13g2_fill_1 FILLER_12_215 ();
 sg13g2_fill_2 FILLER_12_221 ();
 sg13g2_fill_1 FILLER_12_26 ();
 sg13g2_fill_2 FILLER_12_37 ();
 sg13g2_fill_2 FILLER_12_52 ();
 sg13g2_fill_2 FILLER_12_64 ();
 sg13g2_fill_2 FILLER_12_79 ();
 sg13g2_fill_1 FILLER_12_81 ();
 sg13g2_fill_1 FILLER_12_92 ();
 sg13g2_fill_1 FILLER_12_96 ();
 sg13g2_decap_4 FILLER_13_0 ();
 sg13g2_decap_8 FILLER_13_102 ();
 sg13g2_decap_4 FILLER_13_109 ();
 sg13g2_fill_2 FILLER_13_113 ();
 sg13g2_decap_8 FILLER_13_125 ();
 sg13g2_decap_8 FILLER_13_132 ();
 sg13g2_decap_8 FILLER_13_139 ();
 sg13g2_decap_8 FILLER_13_146 ();
 sg13g2_decap_8 FILLER_13_153 ();
 sg13g2_decap_8 FILLER_13_160 ();
 sg13g2_decap_8 FILLER_13_167 ();
 sg13g2_decap_8 FILLER_13_174 ();
 sg13g2_decap_8 FILLER_13_181 ();
 sg13g2_decap_8 FILLER_13_188 ();
 sg13g2_decap_8 FILLER_13_195 ();
 sg13g2_decap_8 FILLER_13_202 ();
 sg13g2_fill_2 FILLER_13_209 ();
 sg13g2_decap_8 FILLER_13_21 ();
 sg13g2_decap_8 FILLER_13_216 ();
 sg13g2_decap_4 FILLER_13_28 ();
 sg13g2_fill_2 FILLER_13_4 ();
 sg13g2_decap_8 FILLER_13_47 ();
 sg13g2_decap_4 FILLER_13_54 ();
 sg13g2_fill_1 FILLER_13_58 ();
 sg13g2_decap_8 FILLER_13_74 ();
 sg13g2_decap_4 FILLER_13_81 ();
 sg13g2_fill_2 FILLER_13_85 ();
 sg13g2_fill_2 FILLER_1_0 ();
 sg13g2_fill_1 FILLER_1_104 ();
 sg13g2_fill_1 FILLER_1_108 ();
 sg13g2_decap_8 FILLER_1_119 ();
 sg13g2_decap_8 FILLER_1_126 ();
 sg13g2_decap_8 FILLER_1_133 ();
 sg13g2_decap_8 FILLER_1_140 ();
 sg13g2_decap_8 FILLER_1_147 ();
 sg13g2_decap_8 FILLER_1_154 ();
 sg13g2_decap_8 FILLER_1_161 ();
 sg13g2_decap_8 FILLER_1_168 ();
 sg13g2_decap_8 FILLER_1_175 ();
 sg13g2_decap_8 FILLER_1_182 ();
 sg13g2_decap_4 FILLER_1_189 ();
 sg13g2_fill_2 FILLER_1_193 ();
 sg13g2_fill_1 FILLER_1_2 ();
 sg13g2_decap_4 FILLER_1_203 ();
 sg13g2_fill_2 FILLER_1_221 ();
 sg13g2_fill_1 FILLER_1_40 ();
 sg13g2_fill_1 FILLER_1_51 ();
 sg13g2_fill_1 FILLER_1_55 ();
 sg13g2_fill_1 FILLER_1_66 ();
 sg13g2_decap_4 FILLER_1_7 ();
 sg13g2_fill_1 FILLER_1_77 ();
 sg13g2_fill_1 FILLER_1_81 ();
 sg13g2_fill_2 FILLER_1_92 ();
 sg13g2_decap_4 FILLER_2_0 ();
 sg13g2_decap_8 FILLER_2_114 ();
 sg13g2_decap_8 FILLER_2_12 ();
 sg13g2_decap_8 FILLER_2_121 ();
 sg13g2_decap_8 FILLER_2_128 ();
 sg13g2_decap_8 FILLER_2_135 ();
 sg13g2_decap_8 FILLER_2_142 ();
 sg13g2_decap_8 FILLER_2_149 ();
 sg13g2_decap_8 FILLER_2_156 ();
 sg13g2_decap_8 FILLER_2_163 ();
 sg13g2_decap_8 FILLER_2_170 ();
 sg13g2_decap_8 FILLER_2_177 ();
 sg13g2_decap_8 FILLER_2_184 ();
 sg13g2_fill_2 FILLER_2_19 ();
 sg13g2_decap_8 FILLER_2_191 ();
 sg13g2_decap_8 FILLER_2_198 ();
 sg13g2_fill_2 FILLER_2_205 ();
 sg13g2_fill_1 FILLER_2_207 ();
 sg13g2_decap_8 FILLER_2_213 ();
 sg13g2_fill_2 FILLER_2_220 ();
 sg13g2_fill_1 FILLER_2_222 ();
 sg13g2_decap_8 FILLER_2_34 ();
 sg13g2_decap_4 FILLER_2_41 ();
 sg13g2_fill_1 FILLER_2_45 ();
 sg13g2_decap_8 FILLER_2_61 ();
 sg13g2_decap_4 FILLER_2_68 ();
 sg13g2_decap_8 FILLER_2_87 ();
 sg13g2_decap_4 FILLER_2_94 ();
 sg13g2_fill_1 FILLER_2_98 ();
 sg13g2_decap_8 FILLER_3_0 ();
 sg13g2_decap_8 FILLER_3_103 ();
 sg13g2_decap_8 FILLER_3_110 ();
 sg13g2_decap_8 FILLER_3_117 ();
 sg13g2_decap_8 FILLER_3_12 ();
 sg13g2_decap_8 FILLER_3_124 ();
 sg13g2_decap_8 FILLER_3_131 ();
 sg13g2_decap_8 FILLER_3_138 ();
 sg13g2_decap_8 FILLER_3_145 ();
 sg13g2_decap_8 FILLER_3_152 ();
 sg13g2_decap_8 FILLER_3_159 ();
 sg13g2_decap_8 FILLER_3_166 ();
 sg13g2_decap_8 FILLER_3_173 ();
 sg13g2_decap_8 FILLER_3_180 ();
 sg13g2_fill_2 FILLER_3_187 ();
 sg13g2_decap_8 FILLER_3_19 ();
 sg13g2_decap_8 FILLER_3_197 ();
 sg13g2_decap_8 FILLER_3_212 ();
 sg13g2_decap_4 FILLER_3_219 ();
 sg13g2_decap_8 FILLER_3_26 ();
 sg13g2_decap_8 FILLER_3_33 ();
 sg13g2_decap_8 FILLER_3_40 ();
 sg13g2_decap_8 FILLER_3_47 ();
 sg13g2_decap_8 FILLER_3_54 ();
 sg13g2_decap_8 FILLER_3_61 ();
 sg13g2_decap_8 FILLER_3_68 ();
 sg13g2_decap_8 FILLER_3_75 ();
 sg13g2_decap_8 FILLER_3_82 ();
 sg13g2_decap_8 FILLER_3_89 ();
 sg13g2_decap_8 FILLER_3_96 ();
 sg13g2_fill_2 FILLER_4_0 ();
 sg13g2_decap_8 FILLER_4_102 ();
 sg13g2_decap_8 FILLER_4_109 ();
 sg13g2_fill_1 FILLER_4_116 ();
 sg13g2_fill_2 FILLER_4_12 ();
 sg13g2_decap_8 FILLER_4_122 ();
 sg13g2_decap_8 FILLER_4_129 ();
 sg13g2_fill_1 FILLER_4_136 ();
 sg13g2_fill_1 FILLER_4_14 ();
 sg13g2_fill_2 FILLER_4_142 ();
 sg13g2_fill_2 FILLER_4_148 ();
 sg13g2_fill_1 FILLER_4_150 ();
 sg13g2_decap_4 FILLER_4_155 ();
 sg13g2_decap_8 FILLER_4_171 ();
 sg13g2_decap_4 FILLER_4_178 ();
 sg13g2_fill_1 FILLER_4_182 ();
 sg13g2_decap_8 FILLER_4_19 ();
 sg13g2_decap_4 FILLER_4_199 ();
 sg13g2_fill_1 FILLER_4_2 ();
 sg13g2_fill_2 FILLER_4_203 ();
 sg13g2_fill_2 FILLER_4_210 ();
 sg13g2_decap_8 FILLER_4_26 ();
 sg13g2_fill_1 FILLER_4_33 ();
 sg13g2_decap_8 FILLER_4_43 ();
 sg13g2_decap_8 FILLER_4_50 ();
 sg13g2_decap_4 FILLER_4_57 ();
 sg13g2_fill_2 FILLER_4_61 ();
 sg13g2_decap_8 FILLER_4_68 ();
 sg13g2_decap_8 FILLER_4_75 ();
 sg13g2_decap_8 FILLER_4_82 ();
 sg13g2_fill_1 FILLER_4_89 ();
 sg13g2_decap_8 FILLER_4_95 ();
 sg13g2_fill_1 FILLER_5_0 ();
 sg13g2_fill_2 FILLER_5_105 ();
 sg13g2_fill_1 FILLER_5_117 ();
 sg13g2_fill_1 FILLER_5_121 ();
 sg13g2_fill_2 FILLER_5_132 ();
 sg13g2_decap_4 FILLER_5_137 ();
 sg13g2_fill_2 FILLER_5_14 ();
 sg13g2_fill_1 FILLER_5_141 ();
 sg13g2_fill_1 FILLER_5_154 ();
 sg13g2_fill_1 FILLER_5_166 ();
 sg13g2_decap_8 FILLER_5_185 ();
 sg13g2_decap_8 FILLER_5_192 ();
 sg13g2_decap_8 FILLER_5_199 ();
 sg13g2_fill_1 FILLER_5_206 ();
 sg13g2_decap_8 FILLER_5_215 ();
 sg13g2_fill_1 FILLER_5_222 ();
 sg13g2_fill_2 FILLER_5_24 ();
 sg13g2_fill_1 FILLER_5_26 ();
 sg13g2_fill_2 FILLER_5_55 ();
 sg13g2_fill_1 FILLER_5_57 ();
 sg13g2_fill_1 FILLER_5_63 ();
 sg13g2_fill_1 FILLER_5_67 ();
 sg13g2_fill_2 FILLER_5_78 ();
 sg13g2_fill_1 FILLER_5_90 ();
 sg13g2_fill_1 FILLER_5_94 ();
 sg13g2_decap_8 FILLER_6_0 ();
 sg13g2_decap_8 FILLER_6_100 ();
 sg13g2_decap_4 FILLER_6_107 ();
 sg13g2_fill_1 FILLER_6_111 ();
 sg13g2_decap_8 FILLER_6_127 ();
 sg13g2_decap_8 FILLER_6_148 ();
 sg13g2_fill_2 FILLER_6_155 ();
 sg13g2_fill_1 FILLER_6_157 ();
 sg13g2_decap_8 FILLER_6_16 ();
 sg13g2_fill_2 FILLER_6_161 ();
 sg13g2_decap_8 FILLER_6_171 ();
 sg13g2_decap_8 FILLER_6_178 ();
 sg13g2_fill_2 FILLER_6_185 ();
 sg13g2_decap_4 FILLER_6_195 ();
 sg13g2_decap_8 FILLER_6_215 ();
 sg13g2_fill_1 FILLER_6_222 ();
 sg13g2_decap_8 FILLER_6_23 ();
 sg13g2_decap_4 FILLER_6_30 ();
 sg13g2_fill_2 FILLER_6_34 ();
 sg13g2_fill_2 FILLER_6_50 ();
 sg13g2_fill_1 FILLER_6_52 ();
 sg13g2_decap_4 FILLER_6_7 ();
 sg13g2_decap_4 FILLER_6_73 ();
 sg13g2_fill_1 FILLER_6_77 ();
 sg13g2_fill_1 FILLER_6_84 ();
 sg13g2_decap_4 FILLER_7_0 ();
 sg13g2_decap_8 FILLER_7_101 ();
 sg13g2_decap_4 FILLER_7_108 ();
 sg13g2_fill_2 FILLER_7_112 ();
 sg13g2_decap_8 FILLER_7_122 ();
 sg13g2_decap_8 FILLER_7_129 ();
 sg13g2_decap_4 FILLER_7_136 ();
 sg13g2_decap_8 FILLER_7_173 ();
 sg13g2_decap_8 FILLER_7_18 ();
 sg13g2_decap_8 FILLER_7_180 ();
 sg13g2_fill_1 FILLER_7_187 ();
 sg13g2_decap_8 FILLER_7_196 ();
 sg13g2_decap_4 FILLER_7_203 ();
 sg13g2_decap_8 FILLER_7_215 ();
 sg13g2_fill_1 FILLER_7_222 ();
 sg13g2_decap_8 FILLER_7_25 ();
 sg13g2_fill_1 FILLER_7_4 ();
 sg13g2_decap_8 FILLER_7_40 ();
 sg13g2_decap_8 FILLER_7_47 ();
 sg13g2_decap_8 FILLER_7_54 ();
 sg13g2_decap_8 FILLER_7_66 ();
 sg13g2_decap_8 FILLER_7_73 ();
 sg13g2_decap_8 FILLER_7_80 ();
 sg13g2_fill_2 FILLER_7_87 ();
 sg13g2_decap_8 FILLER_7_94 ();
 sg13g2_fill_1 FILLER_8_0 ();
 sg13g2_fill_2 FILLER_8_104 ();
 sg13g2_fill_1 FILLER_8_106 ();
 sg13g2_decap_8 FILLER_8_132 ();
 sg13g2_fill_2 FILLER_8_139 ();
 sg13g2_fill_1 FILLER_8_141 ();
 sg13g2_decap_8 FILLER_8_146 ();
 sg13g2_decap_4 FILLER_8_153 ();
 sg13g2_decap_8 FILLER_8_160 ();
 sg13g2_fill_2 FILLER_8_167 ();
 sg13g2_fill_2 FILLER_8_172 ();
 sg13g2_fill_2 FILLER_8_182 ();
 sg13g2_decap_4 FILLER_8_192 ();
 sg13g2_decap_8 FILLER_8_204 ();
 sg13g2_fill_1 FILLER_8_211 ();
 sg13g2_decap_8 FILLER_8_215 ();
 sg13g2_fill_1 FILLER_8_222 ();
 sg13g2_decap_4 FILLER_8_35 ();
 sg13g2_fill_2 FILLER_8_48 ();
 sg13g2_decap_4 FILLER_8_5 ();
 sg13g2_fill_1 FILLER_8_50 ();
 sg13g2_fill_1 FILLER_8_61 ();
 sg13g2_fill_1 FILLER_8_65 ();
 sg13g2_fill_2 FILLER_8_76 ();
 sg13g2_fill_1 FILLER_8_78 ();
 sg13g2_fill_1 FILLER_8_89 ();
 sg13g2_fill_1 FILLER_8_93 ();
 sg13g2_fill_2 FILLER_9_0 ();
 sg13g2_decap_4 FILLER_9_106 ();
 sg13g2_fill_2 FILLER_9_110 ();
 sg13g2_decap_8 FILLER_9_122 ();
 sg13g2_decap_8 FILLER_9_129 ();
 sg13g2_fill_2 FILLER_9_136 ();
 sg13g2_fill_1 FILLER_9_138 ();
 sg13g2_decap_8 FILLER_9_143 ();
 sg13g2_decap_4 FILLER_9_150 ();
 sg13g2_fill_1 FILLER_9_154 ();
 sg13g2_decap_8 FILLER_9_158 ();
 sg13g2_decap_8 FILLER_9_165 ();
 sg13g2_decap_8 FILLER_9_177 ();
 sg13g2_decap_4 FILLER_9_184 ();
 sg13g2_fill_1 FILLER_9_188 ();
 sg13g2_decap_8 FILLER_9_19 ();
 sg13g2_decap_4 FILLER_9_197 ();
 sg13g2_fill_2 FILLER_9_201 ();
 sg13g2_fill_1 FILLER_9_211 ();
 sg13g2_fill_1 FILLER_9_215 ();
 sg13g2_fill_2 FILLER_9_221 ();
 sg13g2_decap_4 FILLER_9_26 ();
 sg13g2_fill_1 FILLER_9_30 ();
 sg13g2_decap_8 FILLER_9_45 ();
 sg13g2_decap_4 FILLER_9_52 ();
 sg13g2_decap_8 FILLER_9_71 ();
 sg13g2_decap_4 FILLER_9_78 ();
 sg13g2_fill_2 FILLER_9_82 ();
 sg13g2_decap_8 FILLER_9_99 ();
 sg13g2_inv_4 clone1 (.A(\pll_ana_dco/COARSE_OUT ),
    .Y(net1));
 sg13g2_inv_4 clone2 (.A(\pll_ana_dco/COARSE_OUT ),
    .Y(net2));
 sg13g2_buf_1 \pll_ana_dco/coarse/impl_last_impl  (.A(\pll_ana_dco/coarse/FCHAIN_15_ ),
    .X(\pll_ana_dco/coarse/RCHAIN_15_ ));
 sg13g2_nand2_2 \pll_ana_dco/coarse/stage_0_impl/dwn_impl  (.Y(\pll_ana_dco/COARSE_OUT ),
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
 sg13g2_inv_8 \pll_ana_dco/fine/inv_0_impl  (.Y(\pll_ana_dco/fine/LOAD ),
    .A(MID_OUT));
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
 sg13g2_inv_8 \pll_ana_dco/mid/inv_0_impl  (.Y(\pll_ana_dco/mid/LOAD ),
    .A(\pll_ana_dco/COARSE_OUT ));
 sg13g2_inv_2 \pll_ana_dco/mid/inv_1_impl  (.Y(MID_OUT),
    .A(\pll_ana_dco/mid/LOAD ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_0  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_1  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_2  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_3  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_4  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_5  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_6  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_0_dyn_impl_7  (.B(net1),
    .C(MID_MUX[0]),
    .A(\pll_ana_dco/mid/MUXB_0_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_0_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_0_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_0_ ),
    .A(MID_MUX[0]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_0  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_1  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_2  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_3  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_4  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_5  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_6  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_10_dyn_impl_7  (.B(net1),
    .C(MID_MUX[10]),
    .A(\pll_ana_dco/mid/MUXB_10_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_10_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_10_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_10_ ),
    .A(MID_MUX[10]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_0  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_1  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_2  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_3  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_4  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_5  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_6  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_11_dyn_impl_7  (.B(net1),
    .C(MID_MUX[11]),
    .A(\pll_ana_dco/mid/MUXB_11_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_11_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_11_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_11_ ),
    .A(MID_MUX[11]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_0  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_1  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_2  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_3  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_4  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_5  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_6  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_12_dyn_impl_7  (.B(net1),
    .C(MID_MUX[12]),
    .A(\pll_ana_dco/mid/MUXB_12_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_12_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_12_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_12_ ),
    .A(MID_MUX[12]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_0  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_1  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_2  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_3  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_4  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_5  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_6  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_13_dyn_impl_7  (.B(net1),
    .C(MID_MUX[13]),
    .A(\pll_ana_dco/mid/MUXB_13_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_13_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_13_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_13_ ),
    .A(MID_MUX[13]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_0  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_1  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_2  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_3  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_4  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_5  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_6  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_14_dyn_impl_7  (.B(net1),
    .C(MID_MUX[14]),
    .A(\pll_ana_dco/mid/MUXB_14_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_14_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_14_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_14_ ),
    .A(MID_MUX[14]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_0  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_1  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_2  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_3  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_4  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_5  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_6  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_1_dyn_impl_7  (.B(net1),
    .C(MID_MUX[1]),
    .A(\pll_ana_dco/mid/MUXB_1_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_1_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_1_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_1_ ),
    .A(MID_MUX[1]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_0  (.B(net1),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_1  (.B(net1),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_2  (.B(net1),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_3  (.B(net1),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_4  (.B(net2),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_5  (.B(net2),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_6  (.B(net2),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_2_dyn_impl_7  (.B(net2),
    .C(MID_MUX[2]),
    .A(\pll_ana_dco/mid/MUXB_2_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_2_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_2_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_2_ ),
    .A(MID_MUX[2]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_0  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_1  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_2  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_3  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_4  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_5  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_6  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_3_dyn_impl_7  (.B(net2),
    .C(MID_MUX[3]),
    .A(\pll_ana_dco/mid/MUXB_3_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_3_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_3_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_3_ ),
    .A(MID_MUX[3]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_0  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_1  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_2  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_3  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_4  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_5  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_6  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_4_dyn_impl_7  (.B(net2),
    .C(MID_MUX[4]),
    .A(\pll_ana_dco/mid/MUXB_4_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_4_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_4_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_4_ ),
    .A(MID_MUX[4]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_0  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_1  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_2  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_3  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_4  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_5  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_6  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_5_dyn_impl_7  (.B(net2),
    .C(MID_MUX[5]),
    .A(\pll_ana_dco/mid/MUXB_5_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_5_ ));
 sg13g2_inv_1 \pll_ana_dco/mid/stage_5_inv_b_impl  (.Y(\pll_ana_dco/mid/MUXB_5_ ),
    .A(MID_MUX[5]));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_0  (.B(net2),
    .C(MID_MUX[6]),
    .A(\pll_ana_dco/mid/MUXB_6_ ),
    .Y(\pll_ana_dco/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \pll_ana_dco/mid/stage_6_dyn_impl_1  (.B(net2),
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
 sg13g2_nand2_2 \pll_ana_dco/sym/sym_mux/nand_pll_impl  (.Y(OUT),
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
