module PLL_RING_DCO_PHYS (DCO_EN,
    INJ_EN,
    MID_OUT,
    OUT,
    INJ_EDGE,
    REF,
    COARSE_MUX,
    FINE_MUX,
    MID_MUX,
    SS_BBPD,
    VSS,
    VDD);
 input DCO_EN;
 input INJ_EN;
 output MID_OUT;
 output OUT;
 output INJ_EDGE;
 input REF;
 input [14:0] COARSE_MUX;
 input [30:0] FINE_MUX;
 input [14:0] MID_MUX;
 output [1:0] SS_BBPD;
 inout VSS;
 inout VDD;

 wire zero_;
 wire \ring/COARSE_OUT ;
 wire \ring/DCO_IN ;
 wire \ring/FINE_OUT ;
 wire \ring/SS_BBPD_WIRE_0_ ;
 wire \ring/SS_BBPD_WIRE_1_ ;
 wire \ring/base_delay_BASE_CHAIN_100_ ;
 wire \ring/base_delay_BASE_CHAIN_101_ ;
 wire \ring/base_delay_BASE_CHAIN_102_ ;
 wire \ring/base_delay_BASE_CHAIN_103_ ;
 wire \ring/base_delay_BASE_CHAIN_104_ ;
 wire \ring/base_delay_BASE_CHAIN_105_ ;
 wire \ring/base_delay_BASE_CHAIN_106_ ;
 wire \ring/base_delay_BASE_CHAIN_107_ ;
 wire \ring/base_delay_BASE_CHAIN_108_ ;
 wire \ring/base_delay_BASE_CHAIN_109_ ;
 wire \ring/base_delay_BASE_CHAIN_10_ ;
 wire \ring/base_delay_BASE_CHAIN_110_ ;
 wire \ring/base_delay_BASE_CHAIN_111_ ;
 wire \ring/base_delay_BASE_CHAIN_112_ ;
 wire \ring/base_delay_BASE_CHAIN_113_ ;
 wire \ring/base_delay_BASE_CHAIN_114_ ;
 wire \ring/base_delay_BASE_CHAIN_115_ ;
 wire \ring/base_delay_BASE_CHAIN_116_ ;
 wire \ring/base_delay_BASE_CHAIN_117_ ;
 wire \ring/base_delay_BASE_CHAIN_118_ ;
 wire \ring/base_delay_BASE_CHAIN_119_ ;
 wire \ring/base_delay_BASE_CHAIN_11_ ;
 wire \ring/base_delay_BASE_CHAIN_120_ ;
 wire \ring/base_delay_BASE_CHAIN_121_ ;
 wire \ring/base_delay_BASE_CHAIN_122_ ;
 wire \ring/base_delay_BASE_CHAIN_123_ ;
 wire \ring/base_delay_BASE_CHAIN_124_ ;
 wire \ring/base_delay_BASE_CHAIN_125_ ;
 wire \ring/base_delay_BASE_CHAIN_126_ ;
 wire \ring/base_delay_BASE_CHAIN_127_ ;
 wire \ring/base_delay_BASE_CHAIN_128_ ;
 wire \ring/base_delay_BASE_CHAIN_129_ ;
 wire \ring/base_delay_BASE_CHAIN_12_ ;
 wire \ring/base_delay_BASE_CHAIN_130_ ;
 wire \ring/base_delay_BASE_CHAIN_131_ ;
 wire \ring/base_delay_BASE_CHAIN_132_ ;
 wire \ring/base_delay_BASE_CHAIN_133_ ;
 wire \ring/base_delay_BASE_CHAIN_134_ ;
 wire \ring/base_delay_BASE_CHAIN_135_ ;
 wire \ring/base_delay_BASE_CHAIN_136_ ;
 wire \ring/base_delay_BASE_CHAIN_137_ ;
 wire \ring/base_delay_BASE_CHAIN_138_ ;
 wire \ring/base_delay_BASE_CHAIN_139_ ;
 wire \ring/base_delay_BASE_CHAIN_13_ ;
 wire \ring/base_delay_BASE_CHAIN_140_ ;
 wire \ring/base_delay_BASE_CHAIN_141_ ;
 wire \ring/base_delay_BASE_CHAIN_142_ ;
 wire \ring/base_delay_BASE_CHAIN_143_ ;
 wire \ring/base_delay_BASE_CHAIN_144_ ;
 wire \ring/base_delay_BASE_CHAIN_145_ ;
 wire \ring/base_delay_BASE_CHAIN_146_ ;
 wire \ring/base_delay_BASE_CHAIN_147_ ;
 wire \ring/base_delay_BASE_CHAIN_148_ ;
 wire \ring/base_delay_BASE_CHAIN_149_ ;
 wire \ring/base_delay_BASE_CHAIN_14_ ;
 wire \ring/base_delay_BASE_CHAIN_150_ ;
 wire \ring/base_delay_BASE_CHAIN_151_ ;
 wire \ring/base_delay_BASE_CHAIN_152_ ;
 wire \ring/base_delay_BASE_CHAIN_153_ ;
 wire \ring/base_delay_BASE_CHAIN_154_ ;
 wire \ring/base_delay_BASE_CHAIN_155_ ;
 wire \ring/base_delay_BASE_CHAIN_156_ ;
 wire \ring/base_delay_BASE_CHAIN_157_ ;
 wire \ring/base_delay_BASE_CHAIN_158_ ;
 wire \ring/base_delay_BASE_CHAIN_159_ ;
 wire \ring/base_delay_BASE_CHAIN_15_ ;
 wire \ring/base_delay_BASE_CHAIN_160_ ;
 wire \ring/base_delay_BASE_CHAIN_161_ ;
 wire \ring/base_delay_BASE_CHAIN_162_ ;
 wire \ring/base_delay_BASE_CHAIN_163_ ;
 wire \ring/base_delay_BASE_CHAIN_164_ ;
 wire \ring/base_delay_BASE_CHAIN_165_ ;
 wire \ring/base_delay_BASE_CHAIN_166_ ;
 wire \ring/base_delay_BASE_CHAIN_167_ ;
 wire \ring/base_delay_BASE_CHAIN_168_ ;
 wire \ring/base_delay_BASE_CHAIN_169_ ;
 wire \ring/base_delay_BASE_CHAIN_16_ ;
 wire \ring/base_delay_BASE_CHAIN_170_ ;
 wire \ring/base_delay_BASE_CHAIN_171_ ;
 wire \ring/base_delay_BASE_CHAIN_172_ ;
 wire \ring/base_delay_BASE_CHAIN_173_ ;
 wire \ring/base_delay_BASE_CHAIN_174_ ;
 wire \ring/base_delay_BASE_CHAIN_175_ ;
 wire \ring/base_delay_BASE_CHAIN_176_ ;
 wire \ring/base_delay_BASE_CHAIN_177_ ;
 wire \ring/base_delay_BASE_CHAIN_178_ ;
 wire \ring/base_delay_BASE_CHAIN_179_ ;
 wire \ring/base_delay_BASE_CHAIN_17_ ;
 wire \ring/base_delay_BASE_CHAIN_180_ ;
 wire \ring/base_delay_BASE_CHAIN_181_ ;
 wire \ring/base_delay_BASE_CHAIN_182_ ;
 wire \ring/base_delay_BASE_CHAIN_183_ ;
 wire \ring/base_delay_BASE_CHAIN_184_ ;
 wire \ring/base_delay_BASE_CHAIN_185_ ;
 wire \ring/base_delay_BASE_CHAIN_186_ ;
 wire \ring/base_delay_BASE_CHAIN_187_ ;
 wire \ring/base_delay_BASE_CHAIN_188_ ;
 wire \ring/base_delay_BASE_CHAIN_189_ ;
 wire \ring/base_delay_BASE_CHAIN_18_ ;
 wire \ring/base_delay_BASE_CHAIN_190_ ;
 wire \ring/base_delay_BASE_CHAIN_191_ ;
 wire \ring/base_delay_BASE_CHAIN_192_ ;
 wire \ring/base_delay_BASE_CHAIN_193_ ;
 wire \ring/base_delay_BASE_CHAIN_194_ ;
 wire \ring/base_delay_BASE_CHAIN_195_ ;
 wire \ring/base_delay_BASE_CHAIN_196_ ;
 wire \ring/base_delay_BASE_CHAIN_197_ ;
 wire \ring/base_delay_BASE_CHAIN_198_ ;
 wire \ring/base_delay_BASE_CHAIN_199_ ;
 wire \ring/base_delay_BASE_CHAIN_19_ ;
 wire \ring/base_delay_BASE_CHAIN_1_ ;
 wire \ring/base_delay_BASE_CHAIN_200_ ;
 wire \ring/base_delay_BASE_CHAIN_201_ ;
 wire \ring/base_delay_BASE_CHAIN_202_ ;
 wire \ring/base_delay_BASE_CHAIN_203_ ;
 wire \ring/base_delay_BASE_CHAIN_204_ ;
 wire \ring/base_delay_BASE_CHAIN_205_ ;
 wire \ring/base_delay_BASE_CHAIN_206_ ;
 wire \ring/base_delay_BASE_CHAIN_207_ ;
 wire \ring/base_delay_BASE_CHAIN_208_ ;
 wire \ring/base_delay_BASE_CHAIN_209_ ;
 wire \ring/base_delay_BASE_CHAIN_20_ ;
 wire \ring/base_delay_BASE_CHAIN_210_ ;
 wire \ring/base_delay_BASE_CHAIN_211_ ;
 wire \ring/base_delay_BASE_CHAIN_212_ ;
 wire \ring/base_delay_BASE_CHAIN_213_ ;
 wire \ring/base_delay_BASE_CHAIN_214_ ;
 wire \ring/base_delay_BASE_CHAIN_215_ ;
 wire \ring/base_delay_BASE_CHAIN_216_ ;
 wire \ring/base_delay_BASE_CHAIN_217_ ;
 wire \ring/base_delay_BASE_CHAIN_218_ ;
 wire \ring/base_delay_BASE_CHAIN_219_ ;
 wire \ring/base_delay_BASE_CHAIN_21_ ;
 wire \ring/base_delay_BASE_CHAIN_220_ ;
 wire \ring/base_delay_BASE_CHAIN_221_ ;
 wire \ring/base_delay_BASE_CHAIN_222_ ;
 wire \ring/base_delay_BASE_CHAIN_223_ ;
 wire \ring/base_delay_BASE_CHAIN_224_ ;
 wire \ring/base_delay_BASE_CHAIN_225_ ;
 wire \ring/base_delay_BASE_CHAIN_226_ ;
 wire \ring/base_delay_BASE_CHAIN_227_ ;
 wire \ring/base_delay_BASE_CHAIN_228_ ;
 wire \ring/base_delay_BASE_CHAIN_229_ ;
 wire \ring/base_delay_BASE_CHAIN_22_ ;
 wire \ring/base_delay_BASE_CHAIN_230_ ;
 wire \ring/base_delay_BASE_CHAIN_231_ ;
 wire \ring/base_delay_BASE_CHAIN_232_ ;
 wire \ring/base_delay_BASE_CHAIN_233_ ;
 wire \ring/base_delay_BASE_CHAIN_234_ ;
 wire \ring/base_delay_BASE_CHAIN_235_ ;
 wire \ring/base_delay_BASE_CHAIN_236_ ;
 wire \ring/base_delay_BASE_CHAIN_237_ ;
 wire \ring/base_delay_BASE_CHAIN_238_ ;
 wire \ring/base_delay_BASE_CHAIN_239_ ;
 wire \ring/base_delay_BASE_CHAIN_23_ ;
 wire \ring/base_delay_BASE_CHAIN_240_ ;
 wire \ring/base_delay_BASE_CHAIN_241_ ;
 wire \ring/base_delay_BASE_CHAIN_242_ ;
 wire \ring/base_delay_BASE_CHAIN_243_ ;
 wire \ring/base_delay_BASE_CHAIN_244_ ;
 wire \ring/base_delay_BASE_CHAIN_245_ ;
 wire \ring/base_delay_BASE_CHAIN_246_ ;
 wire \ring/base_delay_BASE_CHAIN_247_ ;
 wire \ring/base_delay_BASE_CHAIN_248_ ;
 wire \ring/base_delay_BASE_CHAIN_249_ ;
 wire \ring/base_delay_BASE_CHAIN_24_ ;
 wire \ring/base_delay_BASE_CHAIN_250_ ;
 wire \ring/base_delay_BASE_CHAIN_251_ ;
 wire \ring/base_delay_BASE_CHAIN_252_ ;
 wire \ring/base_delay_BASE_CHAIN_253_ ;
 wire \ring/base_delay_BASE_CHAIN_254_ ;
 wire \ring/base_delay_BASE_CHAIN_255_ ;
 wire \ring/base_delay_BASE_CHAIN_25_ ;
 wire \ring/base_delay_BASE_CHAIN_26_ ;
 wire \ring/base_delay_BASE_CHAIN_27_ ;
 wire \ring/base_delay_BASE_CHAIN_28_ ;
 wire \ring/base_delay_BASE_CHAIN_29_ ;
 wire \ring/base_delay_BASE_CHAIN_2_ ;
 wire \ring/base_delay_BASE_CHAIN_30_ ;
 wire \ring/base_delay_BASE_CHAIN_31_ ;
 wire \ring/base_delay_BASE_CHAIN_32_ ;
 wire \ring/base_delay_BASE_CHAIN_33_ ;
 wire \ring/base_delay_BASE_CHAIN_34_ ;
 wire \ring/base_delay_BASE_CHAIN_35_ ;
 wire \ring/base_delay_BASE_CHAIN_36_ ;
 wire \ring/base_delay_BASE_CHAIN_37_ ;
 wire \ring/base_delay_BASE_CHAIN_38_ ;
 wire \ring/base_delay_BASE_CHAIN_39_ ;
 wire \ring/base_delay_BASE_CHAIN_3_ ;
 wire \ring/base_delay_BASE_CHAIN_40_ ;
 wire \ring/base_delay_BASE_CHAIN_41_ ;
 wire \ring/base_delay_BASE_CHAIN_42_ ;
 wire \ring/base_delay_BASE_CHAIN_43_ ;
 wire \ring/base_delay_BASE_CHAIN_44_ ;
 wire \ring/base_delay_BASE_CHAIN_45_ ;
 wire \ring/base_delay_BASE_CHAIN_46_ ;
 wire \ring/base_delay_BASE_CHAIN_47_ ;
 wire \ring/base_delay_BASE_CHAIN_48_ ;
 wire \ring/base_delay_BASE_CHAIN_49_ ;
 wire \ring/base_delay_BASE_CHAIN_4_ ;
 wire \ring/base_delay_BASE_CHAIN_50_ ;
 wire \ring/base_delay_BASE_CHAIN_51_ ;
 wire \ring/base_delay_BASE_CHAIN_52_ ;
 wire \ring/base_delay_BASE_CHAIN_53_ ;
 wire \ring/base_delay_BASE_CHAIN_54_ ;
 wire \ring/base_delay_BASE_CHAIN_55_ ;
 wire \ring/base_delay_BASE_CHAIN_56_ ;
 wire \ring/base_delay_BASE_CHAIN_57_ ;
 wire \ring/base_delay_BASE_CHAIN_58_ ;
 wire \ring/base_delay_BASE_CHAIN_59_ ;
 wire \ring/base_delay_BASE_CHAIN_5_ ;
 wire \ring/base_delay_BASE_CHAIN_60_ ;
 wire \ring/base_delay_BASE_CHAIN_61_ ;
 wire \ring/base_delay_BASE_CHAIN_62_ ;
 wire \ring/base_delay_BASE_CHAIN_63_ ;
 wire \ring/base_delay_BASE_CHAIN_64_ ;
 wire \ring/base_delay_BASE_CHAIN_65_ ;
 wire \ring/base_delay_BASE_CHAIN_66_ ;
 wire \ring/base_delay_BASE_CHAIN_67_ ;
 wire \ring/base_delay_BASE_CHAIN_68_ ;
 wire \ring/base_delay_BASE_CHAIN_69_ ;
 wire \ring/base_delay_BASE_CHAIN_6_ ;
 wire \ring/base_delay_BASE_CHAIN_70_ ;
 wire \ring/base_delay_BASE_CHAIN_71_ ;
 wire \ring/base_delay_BASE_CHAIN_72_ ;
 wire \ring/base_delay_BASE_CHAIN_73_ ;
 wire \ring/base_delay_BASE_CHAIN_74_ ;
 wire \ring/base_delay_BASE_CHAIN_75_ ;
 wire \ring/base_delay_BASE_CHAIN_76_ ;
 wire \ring/base_delay_BASE_CHAIN_77_ ;
 wire \ring/base_delay_BASE_CHAIN_78_ ;
 wire \ring/base_delay_BASE_CHAIN_79_ ;
 wire \ring/base_delay_BASE_CHAIN_7_ ;
 wire \ring/base_delay_BASE_CHAIN_80_ ;
 wire \ring/base_delay_BASE_CHAIN_81_ ;
 wire \ring/base_delay_BASE_CHAIN_82_ ;
 wire \ring/base_delay_BASE_CHAIN_83_ ;
 wire \ring/base_delay_BASE_CHAIN_84_ ;
 wire \ring/base_delay_BASE_CHAIN_85_ ;
 wire \ring/base_delay_BASE_CHAIN_86_ ;
 wire \ring/base_delay_BASE_CHAIN_87_ ;
 wire \ring/base_delay_BASE_CHAIN_88_ ;
 wire \ring/base_delay_BASE_CHAIN_89_ ;
 wire \ring/base_delay_BASE_CHAIN_8_ ;
 wire \ring/base_delay_BASE_CHAIN_90_ ;
 wire \ring/base_delay_BASE_CHAIN_91_ ;
 wire \ring/base_delay_BASE_CHAIN_92_ ;
 wire \ring/base_delay_BASE_CHAIN_93_ ;
 wire \ring/base_delay_BASE_CHAIN_94_ ;
 wire \ring/base_delay_BASE_CHAIN_95_ ;
 wire \ring/base_delay_BASE_CHAIN_96_ ;
 wire \ring/base_delay_BASE_CHAIN_97_ ;
 wire \ring/base_delay_BASE_CHAIN_98_ ;
 wire \ring/base_delay_BASE_CHAIN_99_ ;
 wire \ring/base_delay_BASE_CHAIN_9_ ;
 wire \ring/dff_x_CLK ;
 wire \ring/dff_x_RESET_B ;
 wire \ring/dff_y_CLK ;
 wire \ring/dff_y_RESET_B ;
 wire \ring/coarse/FCHAIN_10_ ;
 wire \ring/coarse/FCHAIN_11_ ;
 wire \ring/coarse/FCHAIN_12_ ;
 wire \ring/coarse/FCHAIN_13_ ;
 wire \ring/coarse/FCHAIN_14_ ;
 wire \ring/coarse/FCHAIN_15_ ;
 wire \ring/coarse/FCHAIN_1_ ;
 wire \ring/coarse/FCHAIN_2_ ;
 wire \ring/coarse/FCHAIN_3_ ;
 wire \ring/coarse/FCHAIN_4_ ;
 wire \ring/coarse/FCHAIN_5_ ;
 wire \ring/coarse/FCHAIN_6_ ;
 wire \ring/coarse/FCHAIN_7_ ;
 wire \ring/coarse/FCHAIN_8_ ;
 wire \ring/coarse/FCHAIN_9_ ;
 wire \ring/coarse/RCHAIN_10_ ;
 wire \ring/coarse/RCHAIN_11_ ;
 wire \ring/coarse/RCHAIN_12_ ;
 wire \ring/coarse/RCHAIN_13_ ;
 wire \ring/coarse/RCHAIN_14_ ;
 wire \ring/coarse/RCHAIN_15_ ;
 wire \ring/coarse/RCHAIN_1_ ;
 wire \ring/coarse/RCHAIN_2_ ;
 wire \ring/coarse/RCHAIN_3_ ;
 wire \ring/coarse/RCHAIN_4_ ;
 wire \ring/coarse/RCHAIN_5_ ;
 wire \ring/coarse/RCHAIN_6_ ;
 wire \ring/coarse/RCHAIN_7_ ;
 wire \ring/coarse/RCHAIN_8_ ;
 wire \ring/coarse/RCHAIN_9_ ;
 wire \ring/coarse/stage_0_impl/PATH_0 ;
 wire \ring/coarse/stage_10_impl/PATH_0 ;
 wire \ring/coarse/stage_11_impl/PATH_0 ;
 wire \ring/coarse/stage_12_impl/PATH_0 ;
 wire \ring/coarse/stage_13_impl/PATH_0 ;
 wire \ring/coarse/stage_14_impl/PATH_0 ;
 wire \ring/coarse/stage_1_impl/PATH_0 ;
 wire \ring/coarse/stage_2_impl/PATH_0 ;
 wire \ring/coarse/stage_3_impl/PATH_0 ;
 wire \ring/coarse/stage_4_impl/PATH_0 ;
 wire \ring/coarse/stage_5_impl/PATH_0 ;
 wire \ring/coarse/stage_6_impl/PATH_0 ;
 wire \ring/coarse/stage_7_impl/PATH_0 ;
 wire \ring/coarse/stage_8_impl/PATH_0 ;
 wire \ring/coarse/stage_9_impl/PATH_0 ;
 wire \ring/fine/LOAD ;
 wire \ring/fine/MUXB_0_ ;
 wire \ring/fine/MUXB_10_ ;
 wire \ring/fine/MUXB_11_ ;
 wire \ring/fine/MUXB_12_ ;
 wire \ring/fine/MUXB_13_ ;
 wire \ring/fine/MUXB_14_ ;
 wire \ring/fine/MUXB_15_ ;
 wire \ring/fine/MUXB_16_ ;
 wire \ring/fine/MUXB_17_ ;
 wire \ring/fine/MUXB_18_ ;
 wire \ring/fine/MUXB_19_ ;
 wire \ring/fine/MUXB_1_ ;
 wire \ring/fine/MUXB_20_ ;
 wire \ring/fine/MUXB_21_ ;
 wire \ring/fine/MUXB_22_ ;
 wire \ring/fine/MUXB_23_ ;
 wire \ring/fine/MUXB_24_ ;
 wire \ring/fine/MUXB_25_ ;
 wire \ring/fine/MUXB_26_ ;
 wire \ring/fine/MUXB_27_ ;
 wire \ring/fine/MUXB_28_ ;
 wire \ring/fine/MUXB_29_ ;
 wire \ring/fine/MUXB_2_ ;
 wire \ring/fine/MUXB_30_ ;
 wire \ring/fine/MUXB_3_ ;
 wire \ring/fine/MUXB_4_ ;
 wire \ring/fine/MUXB_5_ ;
 wire \ring/fine/MUXB_6_ ;
 wire \ring/fine/MUXB_7_ ;
 wire \ring/fine/MUXB_8_ ;
 wire \ring/fine/MUXB_9_ ;
 wire \ring/fine/UNCONNECTED_0_ ;
 wire \ring/fine/UNCONNECTED_10_ ;
 wire \ring/fine/UNCONNECTED_11_ ;
 wire \ring/fine/UNCONNECTED_12_ ;
 wire \ring/fine/UNCONNECTED_13_ ;
 wire \ring/fine/UNCONNECTED_14_ ;
 wire \ring/fine/UNCONNECTED_15_ ;
 wire \ring/fine/UNCONNECTED_16_ ;
 wire \ring/fine/UNCONNECTED_17_ ;
 wire \ring/fine/UNCONNECTED_18_ ;
 wire \ring/fine/UNCONNECTED_19_ ;
 wire \ring/fine/UNCONNECTED_1_ ;
 wire \ring/fine/UNCONNECTED_20_ ;
 wire \ring/fine/UNCONNECTED_21_ ;
 wire \ring/fine/UNCONNECTED_22_ ;
 wire \ring/fine/UNCONNECTED_23_ ;
 wire \ring/fine/UNCONNECTED_24_ ;
 wire \ring/fine/UNCONNECTED_25_ ;
 wire \ring/fine/UNCONNECTED_26_ ;
 wire \ring/fine/UNCONNECTED_27_ ;
 wire \ring/fine/UNCONNECTED_28_ ;
 wire \ring/fine/UNCONNECTED_29_ ;
 wire \ring/fine/UNCONNECTED_2_ ;
 wire \ring/fine/UNCONNECTED_30_ ;
 wire \ring/fine/UNCONNECTED_3_ ;
 wire \ring/fine/UNCONNECTED_4_ ;
 wire \ring/fine/UNCONNECTED_5_ ;
 wire \ring/fine/UNCONNECTED_6_ ;
 wire \ring/fine/UNCONNECTED_7_ ;
 wire \ring/fine/UNCONNECTED_8_ ;
 wire \ring/fine/UNCONNECTED_9_ ;
 wire \ring/mid/LOAD ;
 wire \ring/mid/MUXB_0_ ;
 wire \ring/mid/MUXB_10_ ;
 wire \ring/mid/MUXB_11_ ;
 wire \ring/mid/MUXB_12_ ;
 wire \ring/mid/MUXB_13_ ;
 wire \ring/mid/MUXB_14_ ;
 wire \ring/mid/MUXB_1_ ;
 wire \ring/mid/MUXB_2_ ;
 wire \ring/mid/MUXB_3_ ;
 wire \ring/mid/MUXB_4_ ;
 wire \ring/mid/MUXB_5_ ;
 wire \ring/mid/MUXB_6_ ;
 wire \ring/mid/MUXB_7_ ;
 wire \ring/mid/MUXB_8_ ;
 wire \ring/mid/MUXB_9_ ;
 wire \ring/mid/UNCONNECTED_0_ ;
 wire \ring/mid/UNCONNECTED_10_ ;
 wire \ring/mid/UNCONNECTED_11_ ;
 wire \ring/mid/UNCONNECTED_12_ ;
 wire \ring/mid/UNCONNECTED_13_ ;
 wire \ring/mid/UNCONNECTED_14_ ;
 wire \ring/mid/UNCONNECTED_1_ ;
 wire \ring/mid/UNCONNECTED_2_ ;
 wire \ring/mid/UNCONNECTED_3_ ;
 wire \ring/mid/UNCONNECTED_4_ ;
 wire \ring/mid/UNCONNECTED_5_ ;
 wire \ring/mid/UNCONNECTED_6_ ;
 wire \ring/mid/UNCONNECTED_7_ ;
 wire \ring/mid/UNCONNECTED_8_ ;
 wire \ring/mid/UNCONNECTED_9_ ;
 wire \ring/sym/INJ_DUMMY ;
 wire \ring/sym/INJ_EDGE_BALANCED ;
 wire \ring/sym/OSC_BALANCED ;
 wire \ring/sym/OSC_DUMMY ;
 wire \ring/sym/ssbbpd_impl/OUT_NANDX ;
 wire \ring/sym/ssbbpd_impl/OUT_NANDY ;
 wire \ring/sym/sym_mux/DCO_EN_INJ_WIN ;
 wire \ring/sym/sym_mux/OSC_INJ ;
 wire \ring/sym/sym_mux/REF_INJ ;
 wire \ring/fine/net1 ;
 wire \ring/fine/net2 ;
 wire \ring/fine/net3 ;
 wire \ring/fine/net4 ;
 wire \ring/fine/net5 ;
 wire \ring/mid/net6 ;
 wire \ring/mid/net7 ;
 wire \ring/mid/net8 ;
 wire \ring/mid/net9 ;
 wire \ring/mid/net10 ;
 wire \ring/mid/net11 ;
 wire \ring/mid/net12 ;
 wire \ring/mid/net13 ;
 wire \ring/mid/net14 ;
 wire \ring/mid/net15 ;
 wire \ring/mid/net16 ;
 wire \ring/mid/net17 ;
 wire \ring/mid/net18 ;
 wire \ring/mid/net19 ;
 wire \ring/mid/net20 ;
 wire \ring/mid/net21 ;
 wire \ring/mid/net22 ;
 wire \ring/mid/net23 ;
 wire \ring/mid/net24 ;
 wire \ring/mid/net25 ;
 wire \ring/mid/net26 ;
 wire \ring/mid/net27 ;
 wire \ring/mid/net28 ;

 sg13g2_decap_4 FILLER_0_0 ();
 sg13g2_decap_8 FILLER_0_110 ();
 sg13g2_decap_8 FILLER_0_117 ();
 sg13g2_fill_2 FILLER_0_124 ();
 sg13g2_decap_8 FILLER_0_130 ();
 sg13g2_decap_8 FILLER_0_137 ();
 sg13g2_fill_2 FILLER_0_144 ();
 sg13g2_decap_8 FILLER_0_150 ();
 sg13g2_decap_8 FILLER_0_157 ();
 sg13g2_decap_8 FILLER_0_16 ();
 sg13g2_decap_8 FILLER_0_164 ();
 sg13g2_decap_8 FILLER_0_171 ();
 sg13g2_decap_8 FILLER_0_178 ();
 sg13g2_decap_4 FILLER_0_185 ();
 sg13g2_fill_1 FILLER_0_189 ();
 sg13g2_decap_4 FILLER_0_194 ();
 sg13g2_decap_8 FILLER_0_206 ();
 sg13g2_decap_8 FILLER_0_213 ();
 sg13g2_decap_8 FILLER_0_220 ();
 sg13g2_decap_4 FILLER_0_227 ();
 sg13g2_decap_8 FILLER_0_23 ();
 sg13g2_fill_2 FILLER_0_231 ();
 sg13g2_decap_8 FILLER_0_241 ();
 sg13g2_decap_8 FILLER_0_248 ();
 sg13g2_decap_4 FILLER_0_255 ();
 sg13g2_fill_2 FILLER_0_259 ();
 sg13g2_decap_8 FILLER_0_265 ();
 sg13g2_decap_8 FILLER_0_272 ();
 sg13g2_decap_8 FILLER_0_279 ();
 sg13g2_decap_8 FILLER_0_286 ();
 sg13g2_decap_4 FILLER_0_293 ();
 sg13g2_decap_8 FILLER_0_30 ();
 sg13g2_decap_8 FILLER_0_37 ();
 sg13g2_decap_8 FILLER_0_44 ();
 sg13g2_decap_8 FILLER_0_51 ();
 sg13g2_decap_8 FILLER_0_58 ();
 sg13g2_decap_8 FILLER_0_65 ();
 sg13g2_decap_8 FILLER_0_72 ();
 sg13g2_decap_8 FILLER_0_79 ();
 sg13g2_decap_8 FILLER_0_9 ();
 sg13g2_fill_1 FILLER_0_94 ();
 sg13g2_decap_8 FILLER_0_99 ();
 sg13g2_decap_4 FILLER_10_0 ();
 sg13g2_decap_4 FILLER_10_10 ();
 sg13g2_decap_8 FILLER_10_103 ();
 sg13g2_decap_8 FILLER_10_110 ();
 sg13g2_decap_8 FILLER_10_117 ();
 sg13g2_decap_8 FILLER_10_139 ();
 sg13g2_fill_2 FILLER_10_14 ();
 sg13g2_decap_4 FILLER_10_146 ();
 sg13g2_fill_1 FILLER_10_150 ();
 sg13g2_decap_8 FILLER_10_191 ();
 sg13g2_fill_1 FILLER_10_198 ();
 sg13g2_decap_8 FILLER_10_207 ();
 sg13g2_decap_8 FILLER_10_21 ();
 sg13g2_fill_2 FILLER_10_214 ();
 sg13g2_decap_8 FILLER_10_228 ();
 sg13g2_decap_4 FILLER_10_235 ();
 sg13g2_fill_1 FILLER_10_239 ();
 sg13g2_decap_8 FILLER_10_248 ();
 sg13g2_decap_4 FILLER_10_255 ();
 sg13g2_fill_1 FILLER_10_259 ();
 sg13g2_decap_8 FILLER_10_268 ();
 sg13g2_fill_2 FILLER_10_28 ();
 sg13g2_fill_2 FILLER_10_283 ();
 sg13g2_decap_4 FILLER_10_293 ();
 sg13g2_fill_1 FILLER_10_34 ();
 sg13g2_fill_2 FILLER_10_4 ();
 sg13g2_fill_2 FILLER_10_44 ();
 sg13g2_fill_1 FILLER_10_46 ();
 sg13g2_decap_4 FILLER_10_56 ();
 sg13g2_fill_1 FILLER_10_60 ();
 sg13g2_fill_1 FILLER_10_78 ();
 sg13g2_decap_8 FILLER_10_89 ();
 sg13g2_decap_8 FILLER_10_96 ();
 sg13g2_fill_2 FILLER_11_0 ();
 sg13g2_decap_8 FILLER_11_105 ();
 sg13g2_fill_1 FILLER_11_112 ();
 sg13g2_decap_8 FILLER_11_121 ();
 sg13g2_decap_8 FILLER_11_128 ();
 sg13g2_fill_2 FILLER_11_135 ();
 sg13g2_fill_2 FILLER_11_145 ();
 sg13g2_decap_8 FILLER_11_15 ();
 sg13g2_fill_2 FILLER_11_150 ();
 sg13g2_decap_8 FILLER_11_155 ();
 sg13g2_decap_8 FILLER_11_162 ();
 sg13g2_decap_8 FILLER_11_169 ();
 sg13g2_decap_8 FILLER_11_176 ();
 sg13g2_fill_2 FILLER_11_183 ();
 sg13g2_fill_1 FILLER_11_185 ();
 sg13g2_decap_8 FILLER_11_194 ();
 sg13g2_decap_8 FILLER_11_213 ();
 sg13g2_fill_2 FILLER_11_22 ();
 sg13g2_decap_4 FILLER_11_220 ();
 sg13g2_decap_8 FILLER_11_232 ();
 sg13g2_decap_8 FILLER_11_239 ();
 sg13g2_fill_2 FILLER_11_246 ();
 sg13g2_decap_4 FILLER_11_256 ();
 sg13g2_fill_1 FILLER_11_260 ();
 sg13g2_decap_4 FILLER_11_269 ();
 sg13g2_fill_2 FILLER_11_273 ();
 sg13g2_decap_8 FILLER_11_28 ();
 sg13g2_decap_4 FILLER_11_283 ();
 sg13g2_fill_2 FILLER_11_295 ();
 sg13g2_decap_8 FILLER_11_35 ();
 sg13g2_decap_4 FILLER_11_42 ();
 sg13g2_fill_2 FILLER_11_46 ();
 sg13g2_fill_2 FILLER_11_52 ();
 sg13g2_decap_8 FILLER_11_63 ();
 sg13g2_decap_8 FILLER_11_70 ();
 sg13g2_decap_8 FILLER_11_77 ();
 sg13g2_decap_8 FILLER_11_84 ();
 sg13g2_decap_4 FILLER_11_91 ();
 sg13g2_decap_8 FILLER_12_0 ();
 sg13g2_fill_2 FILLER_12_104 ();
 sg13g2_fill_1 FILLER_12_106 ();
 sg13g2_decap_8 FILLER_12_126 ();
 sg13g2_fill_2 FILLER_12_133 ();
 sg13g2_fill_1 FILLER_12_135 ();
 sg13g2_fill_2 FILLER_12_14 ();
 sg13g2_fill_2 FILLER_12_144 ();
 sg13g2_fill_1 FILLER_12_16 ();
 sg13g2_decap_8 FILLER_12_178 ();
 sg13g2_decap_4 FILLER_12_185 ();
 sg13g2_decap_8 FILLER_12_197 ();
 sg13g2_decap_4 FILLER_12_204 ();
 sg13g2_fill_1 FILLER_12_21 ();
 sg13g2_decap_8 FILLER_12_216 ();
 sg13g2_decap_4 FILLER_12_223 ();
 sg13g2_decap_4 FILLER_12_239 ();
 sg13g2_fill_1 FILLER_12_249 ();
 sg13g2_decap_8 FILLER_12_254 ();
 sg13g2_fill_1 FILLER_12_261 ();
 sg13g2_fill_2 FILLER_12_27 ();
 sg13g2_decap_8 FILLER_12_270 ();
 sg13g2_decap_4 FILLER_12_281 ();
 sg13g2_decap_4 FILLER_12_293 ();
 sg13g2_fill_1 FILLER_12_38 ();
 sg13g2_decap_8 FILLER_12_43 ();
 sg13g2_decap_8 FILLER_12_50 ();
 sg13g2_decap_4 FILLER_12_61 ();
 sg13g2_decap_8 FILLER_12_7 ();
 sg13g2_decap_4 FILLER_12_89 ();
 sg13g2_fill_1 FILLER_12_93 ();
 sg13g2_fill_2 FILLER_13_0 ();
 sg13g2_fill_2 FILLER_13_103 ();
 sg13g2_decap_8 FILLER_13_109 ();
 sg13g2_decap_8 FILLER_13_116 ();
 sg13g2_decap_8 FILLER_13_123 ();
 sg13g2_fill_2 FILLER_13_130 ();
 sg13g2_decap_8 FILLER_13_140 ();
 sg13g2_decap_8 FILLER_13_147 ();
 sg13g2_decap_4 FILLER_13_15 ();
 sg13g2_decap_8 FILLER_13_157 ();
 sg13g2_decap_8 FILLER_13_164 ();
 sg13g2_fill_2 FILLER_13_171 ();
 sg13g2_decap_8 FILLER_13_181 ();
 sg13g2_fill_2 FILLER_13_188 ();
 sg13g2_fill_2 FILLER_13_19 ();
 sg13g2_decap_8 FILLER_13_198 ();
 sg13g2_decap_4 FILLER_13_205 ();
 sg13g2_fill_2 FILLER_13_209 ();
 sg13g2_decap_8 FILLER_13_223 ();
 sg13g2_decap_8 FILLER_13_230 ();
 sg13g2_fill_2 FILLER_13_237 ();
 sg13g2_fill_1 FILLER_13_239 ();
 sg13g2_decap_8 FILLER_13_244 ();
 sg13g2_decap_4 FILLER_13_255 ();
 sg13g2_decap_8 FILLER_13_267 ();
 sg13g2_fill_1 FILLER_13_274 ();
 sg13g2_decap_4 FILLER_13_283 ();
 sg13g2_fill_2 FILLER_13_287 ();
 sg13g2_decap_8 FILLER_13_29 ();
 sg13g2_decap_4 FILLER_13_292 ();
 sg13g2_fill_1 FILLER_13_296 ();
 sg13g2_fill_2 FILLER_13_36 ();
 sg13g2_decap_8 FILLER_13_41 ();
 sg13g2_fill_2 FILLER_13_48 ();
 sg13g2_fill_1 FILLER_13_50 ();
 sg13g2_decap_4 FILLER_13_64 ();
 sg13g2_fill_1 FILLER_13_68 ();
 sg13g2_decap_8 FILLER_13_77 ();
 sg13g2_decap_8 FILLER_13_84 ();
 sg13g2_decap_8 FILLER_13_91 ();
 sg13g2_fill_2 FILLER_13_98 ();
 sg13g2_decap_4 FILLER_14_0 ();
 sg13g2_fill_2 FILLER_14_108 ();
 sg13g2_fill_1 FILLER_14_110 ();
 sg13g2_fill_2 FILLER_14_119 ();
 sg13g2_fill_1 FILLER_14_121 ();
 sg13g2_fill_1 FILLER_14_13 ();
 sg13g2_decap_4 FILLER_14_134 ();
 sg13g2_fill_2 FILLER_14_171 ();
 sg13g2_fill_1 FILLER_14_173 ();
 sg13g2_decap_4 FILLER_14_186 ();
 sg13g2_decap_8 FILLER_14_214 ();
 sg13g2_fill_2 FILLER_14_221 ();
 sg13g2_fill_1 FILLER_14_223 ();
 sg13g2_decap_8 FILLER_14_236 ();
 sg13g2_fill_2 FILLER_14_24 ();
 sg13g2_decap_8 FILLER_14_255 ();
 sg13g2_fill_1 FILLER_14_26 ();
 sg13g2_decap_8 FILLER_14_262 ();
 sg13g2_fill_2 FILLER_14_269 ();
 sg13g2_fill_1 FILLER_14_271 ();
 sg13g2_fill_2 FILLER_14_280 ();
 sg13g2_fill_1 FILLER_14_282 ();
 sg13g2_fill_1 FILLER_14_296 ();
 sg13g2_fill_1 FILLER_14_4 ();
 sg13g2_decap_8 FILLER_14_46 ();
 sg13g2_fill_1 FILLER_14_53 ();
 sg13g2_fill_1 FILLER_14_77 ();
 sg13g2_fill_1 FILLER_14_82 ();
 sg13g2_fill_1 FILLER_14_91 ();
 sg13g2_fill_1 FILLER_14_97 ();
 sg13g2_decap_4 FILLER_15_0 ();
 sg13g2_decap_8 FILLER_15_106 ();
 sg13g2_decap_8 FILLER_15_11 ();
 sg13g2_decap_4 FILLER_15_113 ();
 sg13g2_fill_2 FILLER_15_117 ();
 sg13g2_decap_8 FILLER_15_127 ();
 sg13g2_decap_8 FILLER_15_134 ();
 sg13g2_decap_8 FILLER_15_141 ();
 sg13g2_decap_8 FILLER_15_148 ();
 sg13g2_decap_8 FILLER_15_155 ();
 sg13g2_decap_8 FILLER_15_162 ();
 sg13g2_fill_1 FILLER_15_169 ();
 sg13g2_decap_8 FILLER_15_178 ();
 sg13g2_decap_8 FILLER_15_18 ();
 sg13g2_decap_8 FILLER_15_185 ();
 sg13g2_decap_8 FILLER_15_192 ();
 sg13g2_decap_8 FILLER_15_199 ();
 sg13g2_decap_4 FILLER_15_206 ();
 sg13g2_fill_2 FILLER_15_210 ();
 sg13g2_decap_8 FILLER_15_220 ();
 sg13g2_fill_2 FILLER_15_227 ();
 sg13g2_fill_1 FILLER_15_229 ();
 sg13g2_decap_4 FILLER_15_242 ();
 sg13g2_fill_1 FILLER_15_246 ();
 sg13g2_decap_8 FILLER_15_25 ();
 sg13g2_decap_8 FILLER_15_251 ();
 sg13g2_decap_8 FILLER_15_258 ();
 sg13g2_decap_8 FILLER_15_265 ();
 sg13g2_decap_8 FILLER_15_272 ();
 sg13g2_decap_8 FILLER_15_279 ();
 sg13g2_decap_8 FILLER_15_286 ();
 sg13g2_decap_4 FILLER_15_293 ();
 sg13g2_decap_8 FILLER_15_32 ();
 sg13g2_decap_8 FILLER_15_39 ();
 sg13g2_fill_2 FILLER_15_4 ();
 sg13g2_decap_8 FILLER_15_46 ();
 sg13g2_decap_8 FILLER_15_53 ();
 sg13g2_fill_2 FILLER_15_60 ();
 sg13g2_fill_2 FILLER_15_66 ();
 sg13g2_fill_1 FILLER_15_68 ();
 sg13g2_decap_8 FILLER_15_72 ();
 sg13g2_decap_8 FILLER_15_79 ();
 sg13g2_decap_8 FILLER_15_86 ();
 sg13g2_fill_1 FILLER_15_93 ();
 sg13g2_decap_8 FILLER_15_99 ();
 sg13g2_fill_1 FILLER_16_0 ();
 sg13g2_fill_1 FILLER_16_100 ();
 sg13g2_fill_2 FILLER_16_11 ();
 sg13g2_decap_8 FILLER_16_111 ();
 sg13g2_decap_8 FILLER_16_118 ();
 sg13g2_decap_4 FILLER_16_125 ();
 sg13g2_fill_1 FILLER_16_129 ();
 sg13g2_fill_1 FILLER_16_13 ();
 sg13g2_decap_8 FILLER_16_138 ();
 sg13g2_fill_2 FILLER_16_145 ();
 sg13g2_fill_1 FILLER_16_147 ();
 sg13g2_decap_8 FILLER_16_151 ();
 sg13g2_decap_8 FILLER_16_158 ();
 sg13g2_decap_4 FILLER_16_173 ();
 sg13g2_fill_2 FILLER_16_177 ();
 sg13g2_decap_4 FILLER_16_195 ();
 sg13g2_decap_8 FILLER_16_211 ();
 sg13g2_decap_8 FILLER_16_226 ();
 sg13g2_decap_8 FILLER_16_233 ();
 sg13g2_fill_2 FILLER_16_24 ();
 sg13g2_decap_8 FILLER_16_240 ();
 sg13g2_decap_8 FILLER_16_247 ();
 sg13g2_decap_8 FILLER_16_254 ();
 sg13g2_decap_8 FILLER_16_261 ();
 sg13g2_decap_8 FILLER_16_268 ();
 sg13g2_decap_8 FILLER_16_275 ();
 sg13g2_decap_8 FILLER_16_282 ();
 sg13g2_decap_8 FILLER_16_289 ();
 sg13g2_fill_1 FILLER_16_296 ();
 sg13g2_fill_2 FILLER_16_36 ();
 sg13g2_fill_1 FILLER_16_53 ();
 sg13g2_fill_2 FILLER_16_64 ();
 sg13g2_fill_1 FILLER_16_66 ();
 sg13g2_decap_4 FILLER_16_82 ();
 sg13g2_fill_2 FILLER_16_86 ();
 sg13g2_fill_2 FILLER_16_98 ();
 sg13g2_decap_8 FILLER_17_0 ();
 sg13g2_decap_8 FILLER_17_102 ();
 sg13g2_decap_8 FILLER_17_109 ();
 sg13g2_decap_8 FILLER_17_116 ();
 sg13g2_decap_8 FILLER_17_123 ();
 sg13g2_decap_4 FILLER_17_130 ();
 sg13g2_decap_8 FILLER_17_14 ();
 sg13g2_fill_2 FILLER_17_163 ();
 sg13g2_decap_8 FILLER_17_173 ();
 sg13g2_fill_2 FILLER_17_180 ();
 sg13g2_decap_8 FILLER_17_186 ();
 sg13g2_decap_8 FILLER_17_193 ();
 sg13g2_decap_4 FILLER_17_200 ();
 sg13g2_decap_8 FILLER_17_21 ();
 sg13g2_decap_4 FILLER_17_212 ();
 sg13g2_fill_1 FILLER_17_216 ();
 sg13g2_decap_8 FILLER_17_225 ();
 sg13g2_decap_8 FILLER_17_232 ();
 sg13g2_decap_8 FILLER_17_239 ();
 sg13g2_decap_8 FILLER_17_246 ();
 sg13g2_decap_8 FILLER_17_253 ();
 sg13g2_decap_8 FILLER_17_260 ();
 sg13g2_decap_8 FILLER_17_267 ();
 sg13g2_decap_8 FILLER_17_274 ();
 sg13g2_decap_8 FILLER_17_28 ();
 sg13g2_decap_8 FILLER_17_281 ();
 sg13g2_decap_8 FILLER_17_288 ();
 sg13g2_fill_2 FILLER_17_295 ();
 sg13g2_decap_8 FILLER_17_35 ();
 sg13g2_decap_8 FILLER_17_42 ();
 sg13g2_decap_8 FILLER_17_49 ();
 sg13g2_decap_8 FILLER_17_56 ();
 sg13g2_decap_8 FILLER_17_67 ();
 sg13g2_decap_8 FILLER_17_7 ();
 sg13g2_decap_8 FILLER_17_74 ();
 sg13g2_decap_8 FILLER_17_81 ();
 sg13g2_decap_8 FILLER_17_88 ();
 sg13g2_decap_8 FILLER_17_95 ();
 sg13g2_fill_1 FILLER_1_0 ();
 sg13g2_decap_4 FILLER_1_19 ();
 sg13g2_decap_8 FILLER_1_190 ();
 sg13g2_fill_1 FILLER_1_197 ();
 sg13g2_decap_8 FILLER_1_206 ();
 sg13g2_decap_8 FILLER_1_213 ();
 sg13g2_decap_8 FILLER_1_220 ();
 sg13g2_fill_1 FILLER_1_227 ();
 sg13g2_decap_8 FILLER_1_236 ();
 sg13g2_fill_1 FILLER_1_243 ();
 sg13g2_fill_2 FILLER_1_264 ();
 sg13g2_fill_1 FILLER_1_266 ();
 sg13g2_decap_8 FILLER_1_275 ();
 sg13g2_decap_8 FILLER_1_282 ();
 sg13g2_decap_8 FILLER_1_289 ();
 sg13g2_fill_1 FILLER_1_296 ();
 sg13g2_fill_2 FILLER_1_33 ();
 sg13g2_fill_1 FILLER_1_60 ();
 sg13g2_fill_1 FILLER_1_64 ();
 sg13g2_fill_2 FILLER_1_80 ();
 sg13g2_fill_1 FILLER_1_82 ();
 sg13g2_decap_8 FILLER_1_91 ();
 sg13g2_decap_4 FILLER_2_0 ();
 sg13g2_decap_8 FILLER_2_101 ();
 sg13g2_fill_2 FILLER_2_108 ();
 sg13g2_fill_1 FILLER_2_110 ();
 sg13g2_decap_8 FILLER_2_115 ();
 sg13g2_fill_1 FILLER_2_122 ();
 sg13g2_decap_8 FILLER_2_127 ();
 sg13g2_decap_8 FILLER_2_134 ();
 sg13g2_decap_8 FILLER_2_141 ();
 sg13g2_decap_8 FILLER_2_148 ();
 sg13g2_decap_8 FILLER_2_155 ();
 sg13g2_decap_8 FILLER_2_16 ();
 sg13g2_decap_8 FILLER_2_162 ();
 sg13g2_decap_8 FILLER_2_169 ();
 sg13g2_decap_8 FILLER_2_176 ();
 sg13g2_decap_8 FILLER_2_183 ();
 sg13g2_decap_8 FILLER_2_190 ();
 sg13g2_fill_2 FILLER_2_197 ();
 sg13g2_decap_8 FILLER_2_207 ();
 sg13g2_decap_8 FILLER_2_214 ();
 sg13g2_decap_8 FILLER_2_221 ();
 sg13g2_decap_4 FILLER_2_23 ();
 sg13g2_decap_8 FILLER_2_236 ();
 sg13g2_decap_8 FILLER_2_243 ();
 sg13g2_decap_8 FILLER_2_250 ();
 sg13g2_decap_8 FILLER_2_257 ();
 sg13g2_fill_1 FILLER_2_27 ();
 sg13g2_decap_8 FILLER_2_272 ();
 sg13g2_decap_8 FILLER_2_279 ();
 sg13g2_decap_8 FILLER_2_286 ();
 sg13g2_decap_4 FILLER_2_293 ();
 sg13g2_decap_8 FILLER_2_33 ();
 sg13g2_decap_8 FILLER_2_40 ();
 sg13g2_decap_8 FILLER_2_47 ();
 sg13g2_fill_2 FILLER_2_54 ();
 sg13g2_decap_8 FILLER_2_75 ();
 sg13g2_decap_4 FILLER_2_82 ();
 sg13g2_decap_8 FILLER_2_9 ();
 sg13g2_decap_8 FILLER_2_94 ();
 sg13g2_fill_2 FILLER_3_0 ();
 sg13g2_decap_4 FILLER_3_150 ();
 sg13g2_decap_8 FILLER_3_18 ();
 sg13g2_fill_1 FILLER_3_186 ();
 sg13g2_fill_1 FILLER_3_2 ();
 sg13g2_decap_8 FILLER_3_203 ();
 sg13g2_decap_8 FILLER_3_210 ();
 sg13g2_decap_4 FILLER_3_217 ();
 sg13g2_fill_1 FILLER_3_221 ();
 sg13g2_fill_2 FILLER_3_226 ();
 sg13g2_decap_4 FILLER_3_236 ();
 sg13g2_fill_2 FILLER_3_240 ();
 sg13g2_fill_2 FILLER_3_25 ();
 sg13g2_decap_8 FILLER_3_274 ();
 sg13g2_decap_8 FILLER_3_281 ();
 sg13g2_decap_8 FILLER_3_288 ();
 sg13g2_fill_2 FILLER_3_295 ();
 sg13g2_decap_4 FILLER_3_32 ();
 sg13g2_fill_2 FILLER_3_36 ();
 sg13g2_decap_8 FILLER_3_46 ();
 sg13g2_decap_8 FILLER_3_53 ();
 sg13g2_decap_8 FILLER_3_60 ();
 sg13g2_decap_8 FILLER_3_67 ();
 sg13g2_decap_8 FILLER_3_74 ();
 sg13g2_decap_8 FILLER_3_81 ();
 sg13g2_fill_2 FILLER_3_88 ();
 sg13g2_decap_8 FILLER_4_0 ();
 sg13g2_decap_8 FILLER_4_102 ();
 sg13g2_decap_8 FILLER_4_109 ();
 sg13g2_decap_8 FILLER_4_116 ();
 sg13g2_decap_8 FILLER_4_123 ();
 sg13g2_decap_8 FILLER_4_130 ();
 sg13g2_decap_8 FILLER_4_137 ();
 sg13g2_fill_1 FILLER_4_14 ();
 sg13g2_fill_1 FILLER_4_144 ();
 sg13g2_decap_8 FILLER_4_149 ();
 sg13g2_fill_1 FILLER_4_156 ();
 sg13g2_decap_8 FILLER_4_161 ();
 sg13g2_decap_8 FILLER_4_168 ();
 sg13g2_decap_8 FILLER_4_175 ();
 sg13g2_decap_8 FILLER_4_182 ();
 sg13g2_decap_8 FILLER_4_189 ();
 sg13g2_decap_8 FILLER_4_19 ();
 sg13g2_decap_8 FILLER_4_196 ();
 sg13g2_decap_8 FILLER_4_203 ();
 sg13g2_fill_2 FILLER_4_210 ();
 sg13g2_fill_1 FILLER_4_212 ();
 sg13g2_decap_8 FILLER_4_225 ();
 sg13g2_decap_4 FILLER_4_232 ();
 sg13g2_fill_1 FILLER_4_236 ();
 sg13g2_decap_8 FILLER_4_249 ();
 sg13g2_decap_8 FILLER_4_256 ();
 sg13g2_fill_1 FILLER_4_26 ();
 sg13g2_decap_4 FILLER_4_263 ();
 sg13g2_fill_2 FILLER_4_267 ();
 sg13g2_decap_4 FILLER_4_274 ();
 sg13g2_fill_2 FILLER_4_286 ();
 sg13g2_fill_1 FILLER_4_296 ();
 sg13g2_decap_8 FILLER_4_41 ();
 sg13g2_fill_2 FILLER_4_48 ();
 sg13g2_fill_1 FILLER_4_50 ();
 sg13g2_fill_2 FILLER_4_68 ();
 sg13g2_decap_8 FILLER_4_7 ();
 sg13g2_decap_4 FILLER_4_80 ();
 sg13g2_fill_1 FILLER_4_84 ();
 sg13g2_decap_8 FILLER_4_95 ();
 sg13g2_decap_4 FILLER_5_0 ();
 sg13g2_fill_2 FILLER_5_102 ();
 sg13g2_decap_4 FILLER_5_114 ();
 sg13g2_fill_2 FILLER_5_118 ();
 sg13g2_decap_8 FILLER_5_133 ();
 sg13g2_fill_2 FILLER_5_148 ();
 sg13g2_fill_1 FILLER_5_150 ();
 sg13g2_decap_4 FILLER_5_179 ();
 sg13g2_decap_8 FILLER_5_195 ();
 sg13g2_decap_4 FILLER_5_202 ();
 sg13g2_decap_8 FILLER_5_218 ();
 sg13g2_decap_8 FILLER_5_22 ();
 sg13g2_decap_4 FILLER_5_225 ();
 sg13g2_fill_1 FILLER_5_229 ();
 sg13g2_decap_8 FILLER_5_242 ();
 sg13g2_decap_8 FILLER_5_249 ();
 sg13g2_fill_2 FILLER_5_256 ();
 sg13g2_fill_1 FILLER_5_258 ();
 sg13g2_decap_4 FILLER_5_267 ();
 sg13g2_decap_8 FILLER_5_274 ();
 sg13g2_fill_2 FILLER_5_281 ();
 sg13g2_fill_2 FILLER_5_29 ();
 sg13g2_decap_4 FILLER_5_291 ();
 sg13g2_fill_2 FILLER_5_295 ();
 sg13g2_fill_1 FILLER_5_4 ();
 sg13g2_decap_8 FILLER_5_41 ();
 sg13g2_decap_8 FILLER_5_48 ();
 sg13g2_decap_8 FILLER_5_65 ();
 sg13g2_fill_2 FILLER_5_72 ();
 sg13g2_fill_1 FILLER_5_74 ();
 sg13g2_decap_8 FILLER_5_78 ();
 sg13g2_decap_8 FILLER_5_95 ();
 sg13g2_fill_2 FILLER_6_0 ();
 sg13g2_decap_8 FILLER_6_100 ();
 sg13g2_fill_2 FILLER_6_107 ();
 sg13g2_decap_8 FILLER_6_11 ();
 sg13g2_decap_8 FILLER_6_114 ();
 sg13g2_decap_8 FILLER_6_121 ();
 sg13g2_decap_8 FILLER_6_128 ();
 sg13g2_decap_4 FILLER_6_135 ();
 sg13g2_fill_2 FILLER_6_139 ();
 sg13g2_decap_8 FILLER_6_149 ();
 sg13g2_decap_4 FILLER_6_156 ();
 sg13g2_fill_1 FILLER_6_160 ();
 sg13g2_decap_8 FILLER_6_165 ();
 sg13g2_decap_8 FILLER_6_172 ();
 sg13g2_decap_8 FILLER_6_179 ();
 sg13g2_fill_2 FILLER_6_18 ();
 sg13g2_decap_4 FILLER_6_186 ();
 sg13g2_decap_8 FILLER_6_198 ();
 sg13g2_fill_1 FILLER_6_20 ();
 sg13g2_fill_2 FILLER_6_205 ();
 sg13g2_decap_8 FILLER_6_215 ();
 sg13g2_decap_4 FILLER_6_222 ();
 sg13g2_fill_1 FILLER_6_226 ();
 sg13g2_decap_8 FILLER_6_239 ();
 sg13g2_decap_4 FILLER_6_246 ();
 sg13g2_decap_8 FILLER_6_25 ();
 sg13g2_decap_8 FILLER_6_258 ();
 sg13g2_fill_2 FILLER_6_265 ();
 sg13g2_fill_1 FILLER_6_267 ();
 sg13g2_decap_4 FILLER_6_280 ();
 sg13g2_fill_1 FILLER_6_284 ();
 sg13g2_decap_4 FILLER_6_293 ();
 sg13g2_decap_8 FILLER_6_32 ();
 sg13g2_decap_8 FILLER_6_39 ();
 sg13g2_decap_8 FILLER_6_46 ();
 sg13g2_decap_8 FILLER_6_53 ();
 sg13g2_decap_8 FILLER_6_60 ();
 sg13g2_fill_2 FILLER_6_67 ();
 sg13g2_decap_8 FILLER_6_79 ();
 sg13g2_decap_8 FILLER_6_86 ();
 sg13g2_decap_8 FILLER_6_93 ();
 sg13g2_fill_2 FILLER_7_0 ();
 sg13g2_decap_4 FILLER_7_104 ();
 sg13g2_fill_1 FILLER_7_108 ();
 sg13g2_decap_4 FILLER_7_114 ();
 sg13g2_fill_2 FILLER_7_118 ();
 sg13g2_decap_8 FILLER_7_130 ();
 sg13g2_decap_4 FILLER_7_137 ();
 sg13g2_fill_2 FILLER_7_141 ();
 sg13g2_decap_4 FILLER_7_151 ();
 sg13g2_fill_2 FILLER_7_155 ();
 sg13g2_fill_2 FILLER_7_16 ();
 sg13g2_decap_8 FILLER_7_175 ();
 sg13g2_fill_1 FILLER_7_18 ();
 sg13g2_fill_2 FILLER_7_182 ();
 sg13g2_decap_4 FILLER_7_196 ();
 sg13g2_fill_1 FILLER_7_2 ();
 sg13g2_fill_1 FILLER_7_200 ();
 sg13g2_decap_8 FILLER_7_213 ();
 sg13g2_decap_4 FILLER_7_220 ();
 sg13g2_decap_8 FILLER_7_240 ();
 sg13g2_fill_1 FILLER_7_247 ();
 sg13g2_decap_8 FILLER_7_256 ();
 sg13g2_fill_2 FILLER_7_263 ();
 sg13g2_fill_1 FILLER_7_265 ();
 sg13g2_decap_8 FILLER_7_274 ();
 sg13g2_decap_8 FILLER_7_289 ();
 sg13g2_fill_1 FILLER_7_296 ();
 sg13g2_decap_4 FILLER_7_32 ();
 sg13g2_fill_2 FILLER_7_36 ();
 sg13g2_fill_2 FILLER_7_51 ();
 sg13g2_decap_8 FILLER_7_63 ();
 sg13g2_decap_8 FILLER_7_70 ();
 sg13g2_decap_8 FILLER_7_77 ();
 sg13g2_decap_8 FILLER_7_97 ();
 sg13g2_decap_8 FILLER_8_0 ();
 sg13g2_decap_8 FILLER_8_103 ();
 sg13g2_fill_1 FILLER_8_110 ();
 sg13g2_fill_1 FILLER_8_123 ();
 sg13g2_decap_8 FILLER_8_134 ();
 sg13g2_decap_8 FILLER_8_14 ();
 sg13g2_decap_4 FILLER_8_141 ();
 sg13g2_fill_2 FILLER_8_145 ();
 sg13g2_decap_8 FILLER_8_155 ();
 sg13g2_decap_8 FILLER_8_162 ();
 sg13g2_fill_2 FILLER_8_169 ();
 sg13g2_fill_1 FILLER_8_171 ();
 sg13g2_decap_8 FILLER_8_175 ();
 sg13g2_decap_4 FILLER_8_190 ();
 sg13g2_decap_8 FILLER_8_202 ();
 sg13g2_fill_1 FILLER_8_209 ();
 sg13g2_decap_8 FILLER_8_218 ();
 sg13g2_decap_8 FILLER_8_225 ();
 sg13g2_decap_8 FILLER_8_232 ();
 sg13g2_decap_4 FILLER_8_239 ();
 sg13g2_fill_2 FILLER_8_255 ();
 sg13g2_decap_8 FILLER_8_265 ();
 sg13g2_decap_4 FILLER_8_280 ();
 sg13g2_fill_1 FILLER_8_284 ();
 sg13g2_decap_4 FILLER_8_293 ();
 sg13g2_decap_8 FILLER_8_30 ();
 sg13g2_fill_1 FILLER_8_37 ();
 sg13g2_decap_4 FILLER_8_48 ();
 sg13g2_fill_1 FILLER_8_52 ();
 sg13g2_fill_2 FILLER_8_63 ();
 sg13g2_fill_1 FILLER_8_65 ();
 sg13g2_decap_8 FILLER_8_7 ();
 sg13g2_fill_2 FILLER_8_85 ();
 sg13g2_fill_1 FILLER_8_87 ();
 sg13g2_fill_1 FILLER_9_0 ();
 sg13g2_decap_4 FILLER_9_10 ();
 sg13g2_decap_4 FILLER_9_102 ();
 sg13g2_decap_8 FILLER_9_120 ();
 sg13g2_decap_8 FILLER_9_127 ();
 sg13g2_decap_8 FILLER_9_134 ();
 sg13g2_fill_1 FILLER_9_14 ();
 sg13g2_fill_2 FILLER_9_141 ();
 sg13g2_fill_1 FILLER_9_151 ();
 sg13g2_decap_8 FILLER_9_156 ();
 sg13g2_decap_8 FILLER_9_163 ();
 sg13g2_decap_8 FILLER_9_170 ();
 sg13g2_decap_8 FILLER_9_177 ();
 sg13g2_decap_8 FILLER_9_184 ();
 sg13g2_fill_1 FILLER_9_19 ();
 sg13g2_decap_4 FILLER_9_191 ();
 sg13g2_fill_1 FILLER_9_195 ();
 sg13g2_decap_8 FILLER_9_204 ();
 sg13g2_fill_2 FILLER_9_211 ();
 sg13g2_fill_1 FILLER_9_213 ();
 sg13g2_decap_8 FILLER_9_222 ();
 sg13g2_fill_2 FILLER_9_229 ();
 sg13g2_fill_2 FILLER_9_24 ();
 sg13g2_decap_8 FILLER_9_240 ();
 sg13g2_fill_2 FILLER_9_247 ();
 sg13g2_decap_8 FILLER_9_257 ();
 sg13g2_decap_8 FILLER_9_264 ();
 sg13g2_decap_8 FILLER_9_271 ();
 sg13g2_decap_8 FILLER_9_278 ();
 sg13g2_decap_8 FILLER_9_285 ();
 sg13g2_decap_4 FILLER_9_292 ();
 sg13g2_fill_1 FILLER_9_296 ();
 sg13g2_decap_8 FILLER_9_30 ();
 sg13g2_decap_8 FILLER_9_37 ();
 sg13g2_decap_8 FILLER_9_44 ();
 sg13g2_decap_4 FILLER_9_51 ();
 sg13g2_fill_2 FILLER_9_55 ();
 sg13g2_decap_8 FILLER_9_65 ();
 sg13g2_decap_8 FILLER_9_72 ();
 sg13g2_decap_8 FILLER_9_79 ();
 sg13g2_fill_1 FILLER_9_86 ();
 sg13g2_decap_8 FILLER_9_95 ();
 sg13g2_tielo TIE_ZERO_zero_ (.L_LO(zero_));
 sg13g2_buf_1 \ring/base_delay_stage_0_delay_cell_impl  (.A(OUT),
    .X(\ring/base_delay_BASE_CHAIN_1_ ));
 sg13g2_buf_1 \ring/base_delay_stage_100_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_100_ ),
    .X(\ring/base_delay_BASE_CHAIN_101_ ));
 sg13g2_buf_1 \ring/base_delay_stage_101_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_101_ ),
    .X(\ring/base_delay_BASE_CHAIN_102_ ));
 sg13g2_buf_1 \ring/base_delay_stage_102_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_102_ ),
    .X(\ring/base_delay_BASE_CHAIN_103_ ));
 sg13g2_buf_1 \ring/base_delay_stage_103_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_103_ ),
    .X(\ring/base_delay_BASE_CHAIN_104_ ));
 sg13g2_buf_1 \ring/base_delay_stage_104_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_104_ ),
    .X(\ring/base_delay_BASE_CHAIN_105_ ));
 sg13g2_buf_1 \ring/base_delay_stage_105_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_105_ ),
    .X(\ring/base_delay_BASE_CHAIN_106_ ));
 sg13g2_buf_1 \ring/base_delay_stage_106_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_106_ ),
    .X(\ring/base_delay_BASE_CHAIN_107_ ));
 sg13g2_buf_1 \ring/base_delay_stage_107_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_107_ ),
    .X(\ring/base_delay_BASE_CHAIN_108_ ));
 sg13g2_buf_1 \ring/base_delay_stage_108_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_108_ ),
    .X(\ring/base_delay_BASE_CHAIN_109_ ));
 sg13g2_buf_1 \ring/base_delay_stage_109_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_109_ ),
    .X(\ring/base_delay_BASE_CHAIN_110_ ));
 sg13g2_buf_1 \ring/base_delay_stage_10_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_10_ ),
    .X(\ring/base_delay_BASE_CHAIN_11_ ));
 sg13g2_buf_1 \ring/base_delay_stage_110_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_110_ ),
    .X(\ring/base_delay_BASE_CHAIN_111_ ));
 sg13g2_buf_1 \ring/base_delay_stage_111_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_111_ ),
    .X(\ring/base_delay_BASE_CHAIN_112_ ));
 sg13g2_buf_1 \ring/base_delay_stage_112_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_112_ ),
    .X(\ring/base_delay_BASE_CHAIN_113_ ));
 sg13g2_buf_1 \ring/base_delay_stage_113_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_113_ ),
    .X(\ring/base_delay_BASE_CHAIN_114_ ));
 sg13g2_buf_1 \ring/base_delay_stage_114_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_114_ ),
    .X(\ring/base_delay_BASE_CHAIN_115_ ));
 sg13g2_buf_1 \ring/base_delay_stage_115_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_115_ ),
    .X(\ring/base_delay_BASE_CHAIN_116_ ));
 sg13g2_buf_1 \ring/base_delay_stage_116_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_116_ ),
    .X(\ring/base_delay_BASE_CHAIN_117_ ));
 sg13g2_buf_1 \ring/base_delay_stage_117_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_117_ ),
    .X(\ring/base_delay_BASE_CHAIN_118_ ));
 sg13g2_buf_1 \ring/base_delay_stage_118_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_118_ ),
    .X(\ring/base_delay_BASE_CHAIN_119_ ));
 sg13g2_buf_1 \ring/base_delay_stage_119_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_119_ ),
    .X(\ring/base_delay_BASE_CHAIN_120_ ));
 sg13g2_buf_1 \ring/base_delay_stage_11_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_11_ ),
    .X(\ring/base_delay_BASE_CHAIN_12_ ));
 sg13g2_buf_1 \ring/base_delay_stage_120_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_120_ ),
    .X(\ring/base_delay_BASE_CHAIN_121_ ));
 sg13g2_buf_1 \ring/base_delay_stage_121_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_121_ ),
    .X(\ring/base_delay_BASE_CHAIN_122_ ));
 sg13g2_buf_1 \ring/base_delay_stage_122_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_122_ ),
    .X(\ring/base_delay_BASE_CHAIN_123_ ));
 sg13g2_buf_1 \ring/base_delay_stage_123_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_123_ ),
    .X(\ring/base_delay_BASE_CHAIN_124_ ));
 sg13g2_buf_1 \ring/base_delay_stage_124_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_124_ ),
    .X(\ring/base_delay_BASE_CHAIN_125_ ));
 sg13g2_buf_1 \ring/base_delay_stage_125_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_125_ ),
    .X(\ring/base_delay_BASE_CHAIN_126_ ));
 sg13g2_buf_1 \ring/base_delay_stage_126_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_126_ ),
    .X(\ring/base_delay_BASE_CHAIN_127_ ));
 sg13g2_buf_1 \ring/base_delay_stage_127_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_127_ ),
    .X(\ring/base_delay_BASE_CHAIN_128_ ));
 sg13g2_buf_1 \ring/base_delay_stage_128_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_128_ ),
    .X(\ring/base_delay_BASE_CHAIN_129_ ));
 sg13g2_buf_1 \ring/base_delay_stage_129_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_129_ ),
    .X(\ring/base_delay_BASE_CHAIN_130_ ));
 sg13g2_buf_1 \ring/base_delay_stage_12_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_12_ ),
    .X(\ring/base_delay_BASE_CHAIN_13_ ));
 sg13g2_buf_1 \ring/base_delay_stage_130_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_130_ ),
    .X(\ring/base_delay_BASE_CHAIN_131_ ));
 sg13g2_buf_1 \ring/base_delay_stage_131_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_131_ ),
    .X(\ring/base_delay_BASE_CHAIN_132_ ));
 sg13g2_buf_1 \ring/base_delay_stage_132_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_132_ ),
    .X(\ring/base_delay_BASE_CHAIN_133_ ));
 sg13g2_buf_1 \ring/base_delay_stage_133_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_133_ ),
    .X(\ring/base_delay_BASE_CHAIN_134_ ));
 sg13g2_buf_1 \ring/base_delay_stage_134_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_134_ ),
    .X(\ring/base_delay_BASE_CHAIN_135_ ));
 sg13g2_buf_1 \ring/base_delay_stage_135_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_135_ ),
    .X(\ring/base_delay_BASE_CHAIN_136_ ));
 sg13g2_buf_1 \ring/base_delay_stage_136_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_136_ ),
    .X(\ring/base_delay_BASE_CHAIN_137_ ));
 sg13g2_buf_1 \ring/base_delay_stage_137_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_137_ ),
    .X(\ring/base_delay_BASE_CHAIN_138_ ));
 sg13g2_buf_1 \ring/base_delay_stage_138_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_138_ ),
    .X(\ring/base_delay_BASE_CHAIN_139_ ));
 sg13g2_buf_1 \ring/base_delay_stage_139_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_139_ ),
    .X(\ring/base_delay_BASE_CHAIN_140_ ));
 sg13g2_buf_1 \ring/base_delay_stage_13_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_13_ ),
    .X(\ring/base_delay_BASE_CHAIN_14_ ));
 sg13g2_buf_1 \ring/base_delay_stage_140_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_140_ ),
    .X(\ring/base_delay_BASE_CHAIN_141_ ));
 sg13g2_buf_1 \ring/base_delay_stage_141_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_141_ ),
    .X(\ring/base_delay_BASE_CHAIN_142_ ));
 sg13g2_buf_1 \ring/base_delay_stage_142_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_142_ ),
    .X(\ring/base_delay_BASE_CHAIN_143_ ));
 sg13g2_buf_1 \ring/base_delay_stage_143_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_143_ ),
    .X(\ring/base_delay_BASE_CHAIN_144_ ));
 sg13g2_buf_1 \ring/base_delay_stage_144_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_144_ ),
    .X(\ring/base_delay_BASE_CHAIN_145_ ));
 sg13g2_buf_1 \ring/base_delay_stage_145_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_145_ ),
    .X(\ring/base_delay_BASE_CHAIN_146_ ));
 sg13g2_buf_1 \ring/base_delay_stage_146_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_146_ ),
    .X(\ring/base_delay_BASE_CHAIN_147_ ));
 sg13g2_buf_1 \ring/base_delay_stage_147_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_147_ ),
    .X(\ring/base_delay_BASE_CHAIN_148_ ));
 sg13g2_buf_1 \ring/base_delay_stage_148_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_148_ ),
    .X(\ring/base_delay_BASE_CHAIN_149_ ));
 sg13g2_buf_1 \ring/base_delay_stage_149_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_149_ ),
    .X(\ring/base_delay_BASE_CHAIN_150_ ));
 sg13g2_buf_1 \ring/base_delay_stage_14_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_14_ ),
    .X(\ring/base_delay_BASE_CHAIN_15_ ));
 sg13g2_buf_1 \ring/base_delay_stage_150_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_150_ ),
    .X(\ring/base_delay_BASE_CHAIN_151_ ));
 sg13g2_buf_1 \ring/base_delay_stage_151_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_151_ ),
    .X(\ring/base_delay_BASE_CHAIN_152_ ));
 sg13g2_buf_1 \ring/base_delay_stage_152_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_152_ ),
    .X(\ring/base_delay_BASE_CHAIN_153_ ));
 sg13g2_buf_1 \ring/base_delay_stage_153_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_153_ ),
    .X(\ring/base_delay_BASE_CHAIN_154_ ));
 sg13g2_buf_1 \ring/base_delay_stage_154_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_154_ ),
    .X(\ring/base_delay_BASE_CHAIN_155_ ));
 sg13g2_buf_1 \ring/base_delay_stage_155_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_155_ ),
    .X(\ring/base_delay_BASE_CHAIN_156_ ));
 sg13g2_buf_1 \ring/base_delay_stage_156_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_156_ ),
    .X(\ring/base_delay_BASE_CHAIN_157_ ));
 sg13g2_buf_1 \ring/base_delay_stage_157_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_157_ ),
    .X(\ring/base_delay_BASE_CHAIN_158_ ));
 sg13g2_buf_1 \ring/base_delay_stage_158_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_158_ ),
    .X(\ring/base_delay_BASE_CHAIN_159_ ));
 sg13g2_buf_1 \ring/base_delay_stage_159_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_159_ ),
    .X(\ring/base_delay_BASE_CHAIN_160_ ));
 sg13g2_buf_1 \ring/base_delay_stage_15_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_15_ ),
    .X(\ring/base_delay_BASE_CHAIN_16_ ));
 sg13g2_buf_1 \ring/base_delay_stage_160_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_160_ ),
    .X(\ring/base_delay_BASE_CHAIN_161_ ));
 sg13g2_buf_1 \ring/base_delay_stage_161_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_161_ ),
    .X(\ring/base_delay_BASE_CHAIN_162_ ));
 sg13g2_buf_1 \ring/base_delay_stage_162_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_162_ ),
    .X(\ring/base_delay_BASE_CHAIN_163_ ));
 sg13g2_buf_1 \ring/base_delay_stage_163_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_163_ ),
    .X(\ring/base_delay_BASE_CHAIN_164_ ));
 sg13g2_buf_1 \ring/base_delay_stage_164_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_164_ ),
    .X(\ring/base_delay_BASE_CHAIN_165_ ));
 sg13g2_buf_1 \ring/base_delay_stage_165_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_165_ ),
    .X(\ring/base_delay_BASE_CHAIN_166_ ));
 sg13g2_buf_1 \ring/base_delay_stage_166_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_166_ ),
    .X(\ring/base_delay_BASE_CHAIN_167_ ));
 sg13g2_buf_1 \ring/base_delay_stage_167_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_167_ ),
    .X(\ring/base_delay_BASE_CHAIN_168_ ));
 sg13g2_buf_1 \ring/base_delay_stage_168_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_168_ ),
    .X(\ring/base_delay_BASE_CHAIN_169_ ));
 sg13g2_buf_1 \ring/base_delay_stage_169_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_169_ ),
    .X(\ring/base_delay_BASE_CHAIN_170_ ));
 sg13g2_buf_1 \ring/base_delay_stage_16_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_16_ ),
    .X(\ring/base_delay_BASE_CHAIN_17_ ));
 sg13g2_buf_1 \ring/base_delay_stage_170_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_170_ ),
    .X(\ring/base_delay_BASE_CHAIN_171_ ));
 sg13g2_buf_1 \ring/base_delay_stage_171_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_171_ ),
    .X(\ring/base_delay_BASE_CHAIN_172_ ));
 sg13g2_buf_1 \ring/base_delay_stage_172_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_172_ ),
    .X(\ring/base_delay_BASE_CHAIN_173_ ));
 sg13g2_buf_1 \ring/base_delay_stage_173_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_173_ ),
    .X(\ring/base_delay_BASE_CHAIN_174_ ));
 sg13g2_buf_1 \ring/base_delay_stage_174_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_174_ ),
    .X(\ring/base_delay_BASE_CHAIN_175_ ));
 sg13g2_buf_1 \ring/base_delay_stage_175_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_175_ ),
    .X(\ring/base_delay_BASE_CHAIN_176_ ));
 sg13g2_buf_1 \ring/base_delay_stage_176_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_176_ ),
    .X(\ring/base_delay_BASE_CHAIN_177_ ));
 sg13g2_buf_1 \ring/base_delay_stage_177_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_177_ ),
    .X(\ring/base_delay_BASE_CHAIN_178_ ));
 sg13g2_buf_1 \ring/base_delay_stage_178_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_178_ ),
    .X(\ring/base_delay_BASE_CHAIN_179_ ));
 sg13g2_buf_1 \ring/base_delay_stage_179_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_179_ ),
    .X(\ring/base_delay_BASE_CHAIN_180_ ));
 sg13g2_buf_1 \ring/base_delay_stage_17_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_17_ ),
    .X(\ring/base_delay_BASE_CHAIN_18_ ));
 sg13g2_buf_1 \ring/base_delay_stage_180_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_180_ ),
    .X(\ring/base_delay_BASE_CHAIN_181_ ));
 sg13g2_buf_1 \ring/base_delay_stage_181_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_181_ ),
    .X(\ring/base_delay_BASE_CHAIN_182_ ));
 sg13g2_buf_1 \ring/base_delay_stage_182_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_182_ ),
    .X(\ring/base_delay_BASE_CHAIN_183_ ));
 sg13g2_buf_1 \ring/base_delay_stage_183_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_183_ ),
    .X(\ring/base_delay_BASE_CHAIN_184_ ));
 sg13g2_buf_1 \ring/base_delay_stage_184_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_184_ ),
    .X(\ring/base_delay_BASE_CHAIN_185_ ));
 sg13g2_buf_1 \ring/base_delay_stage_185_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_185_ ),
    .X(\ring/base_delay_BASE_CHAIN_186_ ));
 sg13g2_buf_1 \ring/base_delay_stage_186_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_186_ ),
    .X(\ring/base_delay_BASE_CHAIN_187_ ));
 sg13g2_buf_1 \ring/base_delay_stage_187_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_187_ ),
    .X(\ring/base_delay_BASE_CHAIN_188_ ));
 sg13g2_buf_1 \ring/base_delay_stage_188_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_188_ ),
    .X(\ring/base_delay_BASE_CHAIN_189_ ));
 sg13g2_buf_1 \ring/base_delay_stage_189_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_189_ ),
    .X(\ring/base_delay_BASE_CHAIN_190_ ));
 sg13g2_buf_1 \ring/base_delay_stage_18_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_18_ ),
    .X(\ring/base_delay_BASE_CHAIN_19_ ));
 sg13g2_buf_1 \ring/base_delay_stage_190_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_190_ ),
    .X(\ring/base_delay_BASE_CHAIN_191_ ));
 sg13g2_buf_1 \ring/base_delay_stage_191_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_191_ ),
    .X(\ring/base_delay_BASE_CHAIN_192_ ));
 sg13g2_buf_1 \ring/base_delay_stage_192_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_192_ ),
    .X(\ring/base_delay_BASE_CHAIN_193_ ));
 sg13g2_buf_1 \ring/base_delay_stage_193_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_193_ ),
    .X(\ring/base_delay_BASE_CHAIN_194_ ));
 sg13g2_buf_1 \ring/base_delay_stage_194_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_194_ ),
    .X(\ring/base_delay_BASE_CHAIN_195_ ));
 sg13g2_buf_1 \ring/base_delay_stage_195_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_195_ ),
    .X(\ring/base_delay_BASE_CHAIN_196_ ));
 sg13g2_buf_1 \ring/base_delay_stage_196_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_196_ ),
    .X(\ring/base_delay_BASE_CHAIN_197_ ));
 sg13g2_buf_1 \ring/base_delay_stage_197_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_197_ ),
    .X(\ring/base_delay_BASE_CHAIN_198_ ));
 sg13g2_buf_1 \ring/base_delay_stage_198_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_198_ ),
    .X(\ring/base_delay_BASE_CHAIN_199_ ));
 sg13g2_buf_1 \ring/base_delay_stage_199_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_199_ ),
    .X(\ring/base_delay_BASE_CHAIN_200_ ));
 sg13g2_buf_1 \ring/base_delay_stage_19_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_19_ ),
    .X(\ring/base_delay_BASE_CHAIN_20_ ));
 sg13g2_buf_1 \ring/base_delay_stage_1_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_1_ ),
    .X(\ring/base_delay_BASE_CHAIN_2_ ));
 sg13g2_buf_1 \ring/base_delay_stage_200_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_200_ ),
    .X(\ring/base_delay_BASE_CHAIN_201_ ));
 sg13g2_buf_1 \ring/base_delay_stage_201_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_201_ ),
    .X(\ring/base_delay_BASE_CHAIN_202_ ));
 sg13g2_buf_1 \ring/base_delay_stage_202_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_202_ ),
    .X(\ring/base_delay_BASE_CHAIN_203_ ));
 sg13g2_buf_1 \ring/base_delay_stage_203_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_203_ ),
    .X(\ring/base_delay_BASE_CHAIN_204_ ));
 sg13g2_buf_1 \ring/base_delay_stage_204_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_204_ ),
    .X(\ring/base_delay_BASE_CHAIN_205_ ));
 sg13g2_buf_1 \ring/base_delay_stage_205_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_205_ ),
    .X(\ring/base_delay_BASE_CHAIN_206_ ));
 sg13g2_buf_1 \ring/base_delay_stage_206_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_206_ ),
    .X(\ring/base_delay_BASE_CHAIN_207_ ));
 sg13g2_buf_1 \ring/base_delay_stage_207_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_207_ ),
    .X(\ring/base_delay_BASE_CHAIN_208_ ));
 sg13g2_buf_1 \ring/base_delay_stage_208_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_208_ ),
    .X(\ring/base_delay_BASE_CHAIN_209_ ));
 sg13g2_buf_1 \ring/base_delay_stage_209_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_209_ ),
    .X(\ring/base_delay_BASE_CHAIN_210_ ));
 sg13g2_buf_1 \ring/base_delay_stage_20_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_20_ ),
    .X(\ring/base_delay_BASE_CHAIN_21_ ));
 sg13g2_buf_1 \ring/base_delay_stage_210_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_210_ ),
    .X(\ring/base_delay_BASE_CHAIN_211_ ));
 sg13g2_buf_1 \ring/base_delay_stage_211_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_211_ ),
    .X(\ring/base_delay_BASE_CHAIN_212_ ));
 sg13g2_buf_1 \ring/base_delay_stage_212_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_212_ ),
    .X(\ring/base_delay_BASE_CHAIN_213_ ));
 sg13g2_buf_1 \ring/base_delay_stage_213_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_213_ ),
    .X(\ring/base_delay_BASE_CHAIN_214_ ));
 sg13g2_buf_1 \ring/base_delay_stage_214_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_214_ ),
    .X(\ring/base_delay_BASE_CHAIN_215_ ));
 sg13g2_buf_1 \ring/base_delay_stage_215_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_215_ ),
    .X(\ring/base_delay_BASE_CHAIN_216_ ));
 sg13g2_buf_1 \ring/base_delay_stage_216_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_216_ ),
    .X(\ring/base_delay_BASE_CHAIN_217_ ));
 sg13g2_buf_1 \ring/base_delay_stage_217_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_217_ ),
    .X(\ring/base_delay_BASE_CHAIN_218_ ));
 sg13g2_buf_1 \ring/base_delay_stage_218_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_218_ ),
    .X(\ring/base_delay_BASE_CHAIN_219_ ));
 sg13g2_buf_1 \ring/base_delay_stage_219_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_219_ ),
    .X(\ring/base_delay_BASE_CHAIN_220_ ));
 sg13g2_buf_1 \ring/base_delay_stage_21_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_21_ ),
    .X(\ring/base_delay_BASE_CHAIN_22_ ));
 sg13g2_buf_1 \ring/base_delay_stage_220_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_220_ ),
    .X(\ring/base_delay_BASE_CHAIN_221_ ));
 sg13g2_buf_1 \ring/base_delay_stage_221_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_221_ ),
    .X(\ring/base_delay_BASE_CHAIN_222_ ));
 sg13g2_buf_1 \ring/base_delay_stage_222_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_222_ ),
    .X(\ring/base_delay_BASE_CHAIN_223_ ));
 sg13g2_buf_1 \ring/base_delay_stage_223_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_223_ ),
    .X(\ring/base_delay_BASE_CHAIN_224_ ));
 sg13g2_buf_1 \ring/base_delay_stage_224_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_224_ ),
    .X(\ring/base_delay_BASE_CHAIN_225_ ));
 sg13g2_buf_1 \ring/base_delay_stage_225_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_225_ ),
    .X(\ring/base_delay_BASE_CHAIN_226_ ));
 sg13g2_buf_1 \ring/base_delay_stage_226_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_226_ ),
    .X(\ring/base_delay_BASE_CHAIN_227_ ));
 sg13g2_buf_1 \ring/base_delay_stage_227_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_227_ ),
    .X(\ring/base_delay_BASE_CHAIN_228_ ));
 sg13g2_buf_1 \ring/base_delay_stage_228_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_228_ ),
    .X(\ring/base_delay_BASE_CHAIN_229_ ));
 sg13g2_buf_1 \ring/base_delay_stage_229_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_229_ ),
    .X(\ring/base_delay_BASE_CHAIN_230_ ));
 sg13g2_buf_1 \ring/base_delay_stage_22_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_22_ ),
    .X(\ring/base_delay_BASE_CHAIN_23_ ));
 sg13g2_buf_1 \ring/base_delay_stage_230_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_230_ ),
    .X(\ring/base_delay_BASE_CHAIN_231_ ));
 sg13g2_buf_1 \ring/base_delay_stage_231_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_231_ ),
    .X(\ring/base_delay_BASE_CHAIN_232_ ));
 sg13g2_buf_1 \ring/base_delay_stage_232_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_232_ ),
    .X(\ring/base_delay_BASE_CHAIN_233_ ));
 sg13g2_buf_1 \ring/base_delay_stage_233_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_233_ ),
    .X(\ring/base_delay_BASE_CHAIN_234_ ));
 sg13g2_buf_1 \ring/base_delay_stage_234_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_234_ ),
    .X(\ring/base_delay_BASE_CHAIN_235_ ));
 sg13g2_buf_1 \ring/base_delay_stage_235_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_235_ ),
    .X(\ring/base_delay_BASE_CHAIN_236_ ));
 sg13g2_buf_1 \ring/base_delay_stage_236_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_236_ ),
    .X(\ring/base_delay_BASE_CHAIN_237_ ));
 sg13g2_buf_1 \ring/base_delay_stage_237_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_237_ ),
    .X(\ring/base_delay_BASE_CHAIN_238_ ));
 sg13g2_buf_1 \ring/base_delay_stage_238_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_238_ ),
    .X(\ring/base_delay_BASE_CHAIN_239_ ));
 sg13g2_buf_1 \ring/base_delay_stage_239_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_239_ ),
    .X(\ring/base_delay_BASE_CHAIN_240_ ));
 sg13g2_buf_1 \ring/base_delay_stage_23_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_23_ ),
    .X(\ring/base_delay_BASE_CHAIN_24_ ));
 sg13g2_buf_1 \ring/base_delay_stage_240_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_240_ ),
    .X(\ring/base_delay_BASE_CHAIN_241_ ));
 sg13g2_buf_1 \ring/base_delay_stage_241_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_241_ ),
    .X(\ring/base_delay_BASE_CHAIN_242_ ));
 sg13g2_buf_1 \ring/base_delay_stage_242_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_242_ ),
    .X(\ring/base_delay_BASE_CHAIN_243_ ));
 sg13g2_buf_1 \ring/base_delay_stage_243_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_243_ ),
    .X(\ring/base_delay_BASE_CHAIN_244_ ));
 sg13g2_buf_1 \ring/base_delay_stage_244_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_244_ ),
    .X(\ring/base_delay_BASE_CHAIN_245_ ));
 sg13g2_buf_1 \ring/base_delay_stage_245_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_245_ ),
    .X(\ring/base_delay_BASE_CHAIN_246_ ));
 sg13g2_buf_1 \ring/base_delay_stage_246_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_246_ ),
    .X(\ring/base_delay_BASE_CHAIN_247_ ));
 sg13g2_buf_1 \ring/base_delay_stage_247_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_247_ ),
    .X(\ring/base_delay_BASE_CHAIN_248_ ));
 sg13g2_buf_1 \ring/base_delay_stage_248_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_248_ ),
    .X(\ring/base_delay_BASE_CHAIN_249_ ));
 sg13g2_buf_1 \ring/base_delay_stage_249_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_249_ ),
    .X(\ring/base_delay_BASE_CHAIN_250_ ));
 sg13g2_buf_1 \ring/base_delay_stage_24_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_24_ ),
    .X(\ring/base_delay_BASE_CHAIN_25_ ));
 sg13g2_buf_1 \ring/base_delay_stage_250_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_250_ ),
    .X(\ring/base_delay_BASE_CHAIN_251_ ));
 sg13g2_buf_1 \ring/base_delay_stage_251_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_251_ ),
    .X(\ring/base_delay_BASE_CHAIN_252_ ));
 sg13g2_buf_1 \ring/base_delay_stage_252_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_252_ ),
    .X(\ring/base_delay_BASE_CHAIN_253_ ));
 sg13g2_buf_1 \ring/base_delay_stage_253_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_253_ ),
    .X(\ring/base_delay_BASE_CHAIN_254_ ));
 sg13g2_buf_1 \ring/base_delay_stage_254_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_254_ ),
    .X(\ring/base_delay_BASE_CHAIN_255_ ));
 sg13g2_buf_1 \ring/base_delay_stage_255_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_255_ ),
    .X(\ring/DCO_IN ));
 sg13g2_buf_1 \ring/base_delay_stage_25_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_25_ ),
    .X(\ring/base_delay_BASE_CHAIN_26_ ));
 sg13g2_buf_1 \ring/base_delay_stage_26_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_26_ ),
    .X(\ring/base_delay_BASE_CHAIN_27_ ));
 sg13g2_buf_1 \ring/base_delay_stage_27_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_27_ ),
    .X(\ring/base_delay_BASE_CHAIN_28_ ));
 sg13g2_buf_1 \ring/base_delay_stage_28_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_28_ ),
    .X(\ring/base_delay_BASE_CHAIN_29_ ));
 sg13g2_buf_1 \ring/base_delay_stage_29_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_29_ ),
    .X(\ring/base_delay_BASE_CHAIN_30_ ));
 sg13g2_buf_1 \ring/base_delay_stage_2_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_2_ ),
    .X(\ring/base_delay_BASE_CHAIN_3_ ));
 sg13g2_buf_1 \ring/base_delay_stage_30_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_30_ ),
    .X(\ring/base_delay_BASE_CHAIN_31_ ));
 sg13g2_buf_1 \ring/base_delay_stage_31_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_31_ ),
    .X(\ring/base_delay_BASE_CHAIN_32_ ));
 sg13g2_buf_1 \ring/base_delay_stage_32_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_32_ ),
    .X(\ring/base_delay_BASE_CHAIN_33_ ));
 sg13g2_buf_1 \ring/base_delay_stage_33_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_33_ ),
    .X(\ring/base_delay_BASE_CHAIN_34_ ));
 sg13g2_buf_1 \ring/base_delay_stage_34_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_34_ ),
    .X(\ring/base_delay_BASE_CHAIN_35_ ));
 sg13g2_buf_1 \ring/base_delay_stage_35_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_35_ ),
    .X(\ring/base_delay_BASE_CHAIN_36_ ));
 sg13g2_buf_1 \ring/base_delay_stage_36_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_36_ ),
    .X(\ring/base_delay_BASE_CHAIN_37_ ));
 sg13g2_buf_1 \ring/base_delay_stage_37_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_37_ ),
    .X(\ring/base_delay_BASE_CHAIN_38_ ));
 sg13g2_buf_1 \ring/base_delay_stage_38_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_38_ ),
    .X(\ring/base_delay_BASE_CHAIN_39_ ));
 sg13g2_buf_1 \ring/base_delay_stage_39_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_39_ ),
    .X(\ring/base_delay_BASE_CHAIN_40_ ));
 sg13g2_buf_1 \ring/base_delay_stage_3_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_3_ ),
    .X(\ring/base_delay_BASE_CHAIN_4_ ));
 sg13g2_buf_1 \ring/base_delay_stage_40_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_40_ ),
    .X(\ring/base_delay_BASE_CHAIN_41_ ));
 sg13g2_buf_1 \ring/base_delay_stage_41_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_41_ ),
    .X(\ring/base_delay_BASE_CHAIN_42_ ));
 sg13g2_buf_1 \ring/base_delay_stage_42_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_42_ ),
    .X(\ring/base_delay_BASE_CHAIN_43_ ));
 sg13g2_buf_1 \ring/base_delay_stage_43_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_43_ ),
    .X(\ring/base_delay_BASE_CHAIN_44_ ));
 sg13g2_buf_1 \ring/base_delay_stage_44_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_44_ ),
    .X(\ring/base_delay_BASE_CHAIN_45_ ));
 sg13g2_buf_1 \ring/base_delay_stage_45_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_45_ ),
    .X(\ring/base_delay_BASE_CHAIN_46_ ));
 sg13g2_buf_1 \ring/base_delay_stage_46_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_46_ ),
    .X(\ring/base_delay_BASE_CHAIN_47_ ));
 sg13g2_buf_1 \ring/base_delay_stage_47_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_47_ ),
    .X(\ring/base_delay_BASE_CHAIN_48_ ));
 sg13g2_buf_1 \ring/base_delay_stage_48_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_48_ ),
    .X(\ring/base_delay_BASE_CHAIN_49_ ));
 sg13g2_buf_1 \ring/base_delay_stage_49_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_49_ ),
    .X(\ring/base_delay_BASE_CHAIN_50_ ));
 sg13g2_buf_1 \ring/base_delay_stage_4_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_4_ ),
    .X(\ring/base_delay_BASE_CHAIN_5_ ));
 sg13g2_buf_1 \ring/base_delay_stage_50_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_50_ ),
    .X(\ring/base_delay_BASE_CHAIN_51_ ));
 sg13g2_buf_1 \ring/base_delay_stage_51_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_51_ ),
    .X(\ring/base_delay_BASE_CHAIN_52_ ));
 sg13g2_buf_1 \ring/base_delay_stage_52_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_52_ ),
    .X(\ring/base_delay_BASE_CHAIN_53_ ));
 sg13g2_buf_1 \ring/base_delay_stage_53_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_53_ ),
    .X(\ring/base_delay_BASE_CHAIN_54_ ));
 sg13g2_buf_1 \ring/base_delay_stage_54_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_54_ ),
    .X(\ring/base_delay_BASE_CHAIN_55_ ));
 sg13g2_buf_1 \ring/base_delay_stage_55_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_55_ ),
    .X(\ring/base_delay_BASE_CHAIN_56_ ));
 sg13g2_buf_1 \ring/base_delay_stage_56_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_56_ ),
    .X(\ring/base_delay_BASE_CHAIN_57_ ));
 sg13g2_buf_1 \ring/base_delay_stage_57_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_57_ ),
    .X(\ring/base_delay_BASE_CHAIN_58_ ));
 sg13g2_buf_1 \ring/base_delay_stage_58_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_58_ ),
    .X(\ring/base_delay_BASE_CHAIN_59_ ));
 sg13g2_buf_1 \ring/base_delay_stage_59_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_59_ ),
    .X(\ring/base_delay_BASE_CHAIN_60_ ));
 sg13g2_buf_1 \ring/base_delay_stage_5_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_5_ ),
    .X(\ring/base_delay_BASE_CHAIN_6_ ));
 sg13g2_buf_1 \ring/base_delay_stage_60_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_60_ ),
    .X(\ring/base_delay_BASE_CHAIN_61_ ));
 sg13g2_buf_1 \ring/base_delay_stage_61_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_61_ ),
    .X(\ring/base_delay_BASE_CHAIN_62_ ));
 sg13g2_buf_1 \ring/base_delay_stage_62_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_62_ ),
    .X(\ring/base_delay_BASE_CHAIN_63_ ));
 sg13g2_buf_1 \ring/base_delay_stage_63_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_63_ ),
    .X(\ring/base_delay_BASE_CHAIN_64_ ));
 sg13g2_buf_1 \ring/base_delay_stage_64_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_64_ ),
    .X(\ring/base_delay_BASE_CHAIN_65_ ));
 sg13g2_buf_1 \ring/base_delay_stage_65_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_65_ ),
    .X(\ring/base_delay_BASE_CHAIN_66_ ));
 sg13g2_buf_1 \ring/base_delay_stage_66_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_66_ ),
    .X(\ring/base_delay_BASE_CHAIN_67_ ));
 sg13g2_buf_1 \ring/base_delay_stage_67_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_67_ ),
    .X(\ring/base_delay_BASE_CHAIN_68_ ));
 sg13g2_buf_1 \ring/base_delay_stage_68_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_68_ ),
    .X(\ring/base_delay_BASE_CHAIN_69_ ));
 sg13g2_buf_1 \ring/base_delay_stage_69_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_69_ ),
    .X(\ring/base_delay_BASE_CHAIN_70_ ));
 sg13g2_buf_1 \ring/base_delay_stage_6_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_6_ ),
    .X(\ring/base_delay_BASE_CHAIN_7_ ));
 sg13g2_buf_1 \ring/base_delay_stage_70_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_70_ ),
    .X(\ring/base_delay_BASE_CHAIN_71_ ));
 sg13g2_buf_1 \ring/base_delay_stage_71_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_71_ ),
    .X(\ring/base_delay_BASE_CHAIN_72_ ));
 sg13g2_buf_1 \ring/base_delay_stage_72_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_72_ ),
    .X(\ring/base_delay_BASE_CHAIN_73_ ));
 sg13g2_buf_1 \ring/base_delay_stage_73_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_73_ ),
    .X(\ring/base_delay_BASE_CHAIN_74_ ));
 sg13g2_buf_1 \ring/base_delay_stage_74_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_74_ ),
    .X(\ring/base_delay_BASE_CHAIN_75_ ));
 sg13g2_buf_1 \ring/base_delay_stage_75_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_75_ ),
    .X(\ring/base_delay_BASE_CHAIN_76_ ));
 sg13g2_buf_1 \ring/base_delay_stage_76_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_76_ ),
    .X(\ring/base_delay_BASE_CHAIN_77_ ));
 sg13g2_buf_1 \ring/base_delay_stage_77_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_77_ ),
    .X(\ring/base_delay_BASE_CHAIN_78_ ));
 sg13g2_buf_1 \ring/base_delay_stage_78_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_78_ ),
    .X(\ring/base_delay_BASE_CHAIN_79_ ));
 sg13g2_buf_1 \ring/base_delay_stage_79_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_79_ ),
    .X(\ring/base_delay_BASE_CHAIN_80_ ));
 sg13g2_buf_1 \ring/base_delay_stage_7_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_7_ ),
    .X(\ring/base_delay_BASE_CHAIN_8_ ));
 sg13g2_buf_1 \ring/base_delay_stage_80_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_80_ ),
    .X(\ring/base_delay_BASE_CHAIN_81_ ));
 sg13g2_buf_1 \ring/base_delay_stage_81_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_81_ ),
    .X(\ring/base_delay_BASE_CHAIN_82_ ));
 sg13g2_buf_1 \ring/base_delay_stage_82_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_82_ ),
    .X(\ring/base_delay_BASE_CHAIN_83_ ));
 sg13g2_buf_1 \ring/base_delay_stage_83_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_83_ ),
    .X(\ring/base_delay_BASE_CHAIN_84_ ));
 sg13g2_buf_1 \ring/base_delay_stage_84_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_84_ ),
    .X(\ring/base_delay_BASE_CHAIN_85_ ));
 sg13g2_buf_1 \ring/base_delay_stage_85_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_85_ ),
    .X(\ring/base_delay_BASE_CHAIN_86_ ));
 sg13g2_buf_1 \ring/base_delay_stage_86_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_86_ ),
    .X(\ring/base_delay_BASE_CHAIN_87_ ));
 sg13g2_buf_1 \ring/base_delay_stage_87_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_87_ ),
    .X(\ring/base_delay_BASE_CHAIN_88_ ));
 sg13g2_buf_1 \ring/base_delay_stage_88_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_88_ ),
    .X(\ring/base_delay_BASE_CHAIN_89_ ));
 sg13g2_buf_1 \ring/base_delay_stage_89_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_89_ ),
    .X(\ring/base_delay_BASE_CHAIN_90_ ));
 sg13g2_buf_1 \ring/base_delay_stage_8_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_8_ ),
    .X(\ring/base_delay_BASE_CHAIN_9_ ));
 sg13g2_buf_1 \ring/base_delay_stage_90_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_90_ ),
    .X(\ring/base_delay_BASE_CHAIN_91_ ));
 sg13g2_buf_1 \ring/base_delay_stage_91_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_91_ ),
    .X(\ring/base_delay_BASE_CHAIN_92_ ));
 sg13g2_buf_1 \ring/base_delay_stage_92_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_92_ ),
    .X(\ring/base_delay_BASE_CHAIN_93_ ));
 sg13g2_buf_1 \ring/base_delay_stage_93_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_93_ ),
    .X(\ring/base_delay_BASE_CHAIN_94_ ));
 sg13g2_buf_1 \ring/base_delay_stage_94_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_94_ ),
    .X(\ring/base_delay_BASE_CHAIN_95_ ));
 sg13g2_buf_1 \ring/base_delay_stage_95_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_95_ ),
    .X(\ring/base_delay_BASE_CHAIN_96_ ));
 sg13g2_buf_1 \ring/base_delay_stage_96_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_96_ ),
    .X(\ring/base_delay_BASE_CHAIN_97_ ));
 sg13g2_buf_1 \ring/base_delay_stage_97_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_97_ ),
    .X(\ring/base_delay_BASE_CHAIN_98_ ));
 sg13g2_buf_1 \ring/base_delay_stage_98_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_98_ ),
    .X(\ring/base_delay_BASE_CHAIN_99_ ));
 sg13g2_buf_1 \ring/base_delay_stage_99_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_99_ ),
    .X(\ring/base_delay_BASE_CHAIN_100_ ));
 sg13g2_buf_1 \ring/base_delay_stage_9_delay_cell_impl  (.A(\ring/base_delay_BASE_CHAIN_9_ ),
    .X(\ring/base_delay_BASE_CHAIN_10_ ));
 sg13g2_buf_1 \ring/coarse/impl_last_impl  (.A(\ring/coarse/FCHAIN_15_ ),
    .X(\ring/coarse/RCHAIN_15_ ));
 sg13g2_nand2_1 \ring/coarse/stage_0_impl/dwn_impl  (.Y(\ring/COARSE_OUT ),
    .A(\ring/coarse/stage_0_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_1_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_0_impl/mid_impl  (.Y(\ring/coarse/stage_0_impl/PATH_0 ),
    .B(\ring/DCO_IN ),
    .A_N(COARSE_MUX[0]));
 sg13g2_nand2_1 \ring/coarse/stage_0_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_1_ ),
    .A(COARSE_MUX[0]),
    .B(\ring/DCO_IN ));
 sg13g2_nand2_1 \ring/coarse/stage_10_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_10_ ),
    .A(\ring/coarse/stage_10_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_11_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_10_impl/mid_impl  (.Y(\ring/coarse/stage_10_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_10_ ),
    .A_N(COARSE_MUX[10]));
 sg13g2_nand2_1 \ring/coarse/stage_10_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_11_ ),
    .A(COARSE_MUX[10]),
    .B(\ring/coarse/FCHAIN_10_ ));
 sg13g2_nand2_1 \ring/coarse/stage_11_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_11_ ),
    .A(\ring/coarse/stage_11_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_12_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_11_impl/mid_impl  (.Y(\ring/coarse/stage_11_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_11_ ),
    .A_N(COARSE_MUX[11]));
 sg13g2_nand2_1 \ring/coarse/stage_11_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_12_ ),
    .A(COARSE_MUX[11]),
    .B(\ring/coarse/FCHAIN_11_ ));
 sg13g2_nand2_1 \ring/coarse/stage_12_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_12_ ),
    .A(\ring/coarse/stage_12_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_13_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_12_impl/mid_impl  (.Y(\ring/coarse/stage_12_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_12_ ),
    .A_N(COARSE_MUX[12]));
 sg13g2_nand2_1 \ring/coarse/stage_12_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_13_ ),
    .A(COARSE_MUX[12]),
    .B(\ring/coarse/FCHAIN_12_ ));
 sg13g2_nand2_1 \ring/coarse/stage_13_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_13_ ),
    .A(\ring/coarse/stage_13_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_14_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_13_impl/mid_impl  (.Y(\ring/coarse/stage_13_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_13_ ),
    .A_N(COARSE_MUX[13]));
 sg13g2_nand2_1 \ring/coarse/stage_13_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_14_ ),
    .A(COARSE_MUX[13]),
    .B(\ring/coarse/FCHAIN_13_ ));
 sg13g2_nand2_1 \ring/coarse/stage_14_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_14_ ),
    .A(\ring/coarse/stage_14_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_15_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_14_impl/mid_impl  (.Y(\ring/coarse/stage_14_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_14_ ),
    .A_N(COARSE_MUX[14]));
 sg13g2_nand2_1 \ring/coarse/stage_14_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_15_ ),
    .A(COARSE_MUX[14]),
    .B(\ring/coarse/FCHAIN_14_ ));
 sg13g2_nand2_1 \ring/coarse/stage_1_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_1_ ),
    .A(\ring/coarse/stage_1_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_2_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_1_impl/mid_impl  (.Y(\ring/coarse/stage_1_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_1_ ),
    .A_N(COARSE_MUX[1]));
 sg13g2_nand2_1 \ring/coarse/stage_1_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_2_ ),
    .A(COARSE_MUX[1]),
    .B(\ring/coarse/FCHAIN_1_ ));
 sg13g2_nand2_1 \ring/coarse/stage_2_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_2_ ),
    .A(\ring/coarse/stage_2_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_3_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_2_impl/mid_impl  (.Y(\ring/coarse/stage_2_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_2_ ),
    .A_N(COARSE_MUX[2]));
 sg13g2_nand2_1 \ring/coarse/stage_2_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_3_ ),
    .A(COARSE_MUX[2]),
    .B(\ring/coarse/FCHAIN_2_ ));
 sg13g2_nand2_1 \ring/coarse/stage_3_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_3_ ),
    .A(\ring/coarse/stage_3_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_4_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_3_impl/mid_impl  (.Y(\ring/coarse/stage_3_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_3_ ),
    .A_N(COARSE_MUX[3]));
 sg13g2_nand2_1 \ring/coarse/stage_3_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_4_ ),
    .A(COARSE_MUX[3]),
    .B(\ring/coarse/FCHAIN_3_ ));
 sg13g2_nand2_1 \ring/coarse/stage_4_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_4_ ),
    .A(\ring/coarse/stage_4_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_5_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_4_impl/mid_impl  (.Y(\ring/coarse/stage_4_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_4_ ),
    .A_N(COARSE_MUX[4]));
 sg13g2_nand2_1 \ring/coarse/stage_4_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_5_ ),
    .A(COARSE_MUX[4]),
    .B(\ring/coarse/FCHAIN_4_ ));
 sg13g2_nand2_1 \ring/coarse/stage_5_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_5_ ),
    .A(\ring/coarse/stage_5_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_6_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_5_impl/mid_impl  (.Y(\ring/coarse/stage_5_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_5_ ),
    .A_N(COARSE_MUX[5]));
 sg13g2_nand2_1 \ring/coarse/stage_5_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_6_ ),
    .A(COARSE_MUX[5]),
    .B(\ring/coarse/FCHAIN_5_ ));
 sg13g2_nand2_1 \ring/coarse/stage_6_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_6_ ),
    .A(\ring/coarse/stage_6_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_7_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_6_impl/mid_impl  (.Y(\ring/coarse/stage_6_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_6_ ),
    .A_N(COARSE_MUX[6]));
 sg13g2_nand2_1 \ring/coarse/stage_6_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_7_ ),
    .A(COARSE_MUX[6]),
    .B(\ring/coarse/FCHAIN_6_ ));
 sg13g2_nand2_1 \ring/coarse/stage_7_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_7_ ),
    .A(\ring/coarse/stage_7_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_8_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_7_impl/mid_impl  (.Y(\ring/coarse/stage_7_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_7_ ),
    .A_N(COARSE_MUX[7]));
 sg13g2_nand2_1 \ring/coarse/stage_7_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_8_ ),
    .A(COARSE_MUX[7]),
    .B(\ring/coarse/FCHAIN_7_ ));
 sg13g2_nand2_1 \ring/coarse/stage_8_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_8_ ),
    .A(\ring/coarse/stage_8_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_9_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_8_impl/mid_impl  (.Y(\ring/coarse/stage_8_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_8_ ),
    .A_N(COARSE_MUX[8]));
 sg13g2_nand2_1 \ring/coarse/stage_8_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_9_ ),
    .A(COARSE_MUX[8]),
    .B(\ring/coarse/FCHAIN_8_ ));
 sg13g2_nand2_1 \ring/coarse/stage_9_impl/dwn_impl  (.Y(\ring/coarse/RCHAIN_9_ ),
    .A(\ring/coarse/stage_9_impl/PATH_0 ),
    .B(\ring/coarse/RCHAIN_10_ ));
 sg13g2_nand2b_1 \ring/coarse/stage_9_impl/mid_impl  (.Y(\ring/coarse/stage_9_impl/PATH_0 ),
    .B(\ring/coarse/FCHAIN_9_ ),
    .A_N(COARSE_MUX[9]));
 sg13g2_nand2_1 \ring/coarse/stage_9_impl/upp_impl  (.Y(\ring/coarse/FCHAIN_10_ ),
    .A(COARSE_MUX[9]),
    .B(\ring/coarse/FCHAIN_9_ ));
 sg13g2_dfrbp_1 \ring/dff_x_impl  (.RESET_B(\ring/dff_x_RESET_B ),
    .D(\ring/SS_BBPD_WIRE_1_ ),
    .Q(SS_BBPD[1]),
    .CLK(\ring/dff_x_CLK ));
 sg13g2_inv_1 \ring/dff_x_impl_inv  (.Y(\ring/dff_x_CLK ),
    .A(REF));
 sg13g2_tiehi \ring/dff_x_impl_tiehi  (.L_HI(\ring/dff_x_RESET_B ));
 sg13g2_dfrbp_1 \ring/dff_y_impl  (.RESET_B(\ring/dff_y_RESET_B ),
    .D(\ring/SS_BBPD_WIRE_0_ ),
    .Q(SS_BBPD[0]),
    .CLK(\ring/dff_y_CLK ));
 sg13g2_inv_1 \ring/dff_y_impl_inv  (.Y(\ring/dff_y_CLK ),
    .A(REF));
 sg13g2_tiehi \ring/dff_y_impl_tiehi  (.L_HI(\ring/dff_y_RESET_B ));
 sg13g2_buf_1 \ring/fine/fanout1  (.A(\ring/fine/net2 ),
    .X(\ring/fine/net1 ));
 sg13g2_buf_1 \ring/fine/fanout2  (.A(\ring/fine/net5 ),
    .X(\ring/fine/net2 ));
 sg13g2_buf_1 \ring/fine/fanout3  (.A(\ring/fine/net5 ),
    .X(\ring/fine/net3 ));
 sg13g2_buf_1 \ring/fine/fanout4  (.A(\ring/fine/net5 ),
    .X(\ring/fine/net4 ));
 sg13g2_buf_1 \ring/fine/fanout5  (.A(\ring/fine/LOAD ),
    .X(\ring/fine/net5 ));
 sg13g2_inv_4 \ring/fine/inv_0_impl  (.A(MID_OUT),
    .Y(\ring/fine/LOAD ));
 sg13g2_inv_4 \ring/fine/inv_1_impl  (.A(\ring/fine/net4 ),
    .Y(\ring/FINE_OUT ));
 sg13g2_nand3_1 \ring/fine/stage_0_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[0]),
    .A(\ring/fine/MUXB_0_ ),
    .Y(\ring/fine/UNCONNECTED_0_ ));
 sg13g2_inv_1 \ring/fine/stage_0_inv_b_impl  (.Y(\ring/fine/MUXB_0_ ),
    .A(FINE_MUX[0]));
 sg13g2_nand3_1 \ring/fine/stage_10_dyn_impl  (.B(\ring/fine/net2 ),
    .C(FINE_MUX[10]),
    .A(\ring/fine/MUXB_10_ ),
    .Y(\ring/fine/UNCONNECTED_10_ ));
 sg13g2_inv_1 \ring/fine/stage_10_inv_b_impl  (.Y(\ring/fine/MUXB_10_ ),
    .A(FINE_MUX[10]));
 sg13g2_nand3_1 \ring/fine/stage_11_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[11]),
    .A(\ring/fine/MUXB_11_ ),
    .Y(\ring/fine/UNCONNECTED_11_ ));
 sg13g2_inv_1 \ring/fine/stage_11_inv_b_impl  (.Y(\ring/fine/MUXB_11_ ),
    .A(FINE_MUX[11]));
 sg13g2_nand3_1 \ring/fine/stage_12_dyn_impl  (.B(\ring/fine/net4 ),
    .C(FINE_MUX[12]),
    .A(\ring/fine/MUXB_12_ ),
    .Y(\ring/fine/UNCONNECTED_12_ ));
 sg13g2_inv_1 \ring/fine/stage_12_inv_b_impl  (.Y(\ring/fine/MUXB_12_ ),
    .A(FINE_MUX[12]));
 sg13g2_nand3_1 \ring/fine/stage_13_dyn_impl  (.B(\ring/fine/net2 ),
    .C(FINE_MUX[13]),
    .A(\ring/fine/MUXB_13_ ),
    .Y(\ring/fine/UNCONNECTED_13_ ));
 sg13g2_inv_1 \ring/fine/stage_13_inv_b_impl  (.Y(\ring/fine/MUXB_13_ ),
    .A(FINE_MUX[13]));
 sg13g2_nand3_1 \ring/fine/stage_14_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[14]),
    .A(\ring/fine/MUXB_14_ ),
    .Y(\ring/fine/UNCONNECTED_14_ ));
 sg13g2_inv_1 \ring/fine/stage_14_inv_b_impl  (.Y(\ring/fine/MUXB_14_ ),
    .A(FINE_MUX[14]));
 sg13g2_nand3_1 \ring/fine/stage_15_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[15]),
    .A(\ring/fine/MUXB_15_ ),
    .Y(\ring/fine/UNCONNECTED_15_ ));
 sg13g2_inv_1 \ring/fine/stage_15_inv_b_impl  (.Y(\ring/fine/MUXB_15_ ),
    .A(FINE_MUX[15]));
 sg13g2_nand3_1 \ring/fine/stage_16_dyn_impl  (.B(\ring/fine/net4 ),
    .C(FINE_MUX[16]),
    .A(\ring/fine/MUXB_16_ ),
    .Y(\ring/fine/UNCONNECTED_16_ ));
 sg13g2_inv_1 \ring/fine/stage_16_inv_b_impl  (.Y(\ring/fine/MUXB_16_ ),
    .A(FINE_MUX[16]));
 sg13g2_nand3_1 \ring/fine/stage_17_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[17]),
    .A(\ring/fine/MUXB_17_ ),
    .Y(\ring/fine/UNCONNECTED_17_ ));
 sg13g2_inv_1 \ring/fine/stage_17_inv_b_impl  (.Y(\ring/fine/MUXB_17_ ),
    .A(FINE_MUX[17]));
 sg13g2_nand3_1 \ring/fine/stage_18_dyn_impl  (.B(\ring/fine/net4 ),
    .C(FINE_MUX[18]),
    .A(\ring/fine/MUXB_18_ ),
    .Y(\ring/fine/UNCONNECTED_18_ ));
 sg13g2_inv_1 \ring/fine/stage_18_inv_b_impl  (.Y(\ring/fine/MUXB_18_ ),
    .A(FINE_MUX[18]));
 sg13g2_nand3_1 \ring/fine/stage_19_dyn_impl  (.B(\ring/fine/net2 ),
    .C(FINE_MUX[19]),
    .A(\ring/fine/MUXB_19_ ),
    .Y(\ring/fine/UNCONNECTED_19_ ));
 sg13g2_inv_1 \ring/fine/stage_19_inv_b_impl  (.Y(\ring/fine/MUXB_19_ ),
    .A(FINE_MUX[19]));
 sg13g2_nand3_1 \ring/fine/stage_1_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[1]),
    .A(\ring/fine/MUXB_1_ ),
    .Y(\ring/fine/UNCONNECTED_1_ ));
 sg13g2_inv_1 \ring/fine/stage_1_inv_b_impl  (.Y(\ring/fine/MUXB_1_ ),
    .A(FINE_MUX[1]));
 sg13g2_nand3_1 \ring/fine/stage_20_dyn_impl  (.B(\ring/fine/net4 ),
    .C(FINE_MUX[20]),
    .A(\ring/fine/MUXB_20_ ),
    .Y(\ring/fine/UNCONNECTED_20_ ));
 sg13g2_inv_1 \ring/fine/stage_20_inv_b_impl  (.Y(\ring/fine/MUXB_20_ ),
    .A(FINE_MUX[20]));
 sg13g2_nand3_1 \ring/fine/stage_21_dyn_impl  (.B(\ring/fine/net2 ),
    .C(FINE_MUX[21]),
    .A(\ring/fine/MUXB_21_ ),
    .Y(\ring/fine/UNCONNECTED_21_ ));
 sg13g2_inv_1 \ring/fine/stage_21_inv_b_impl  (.Y(\ring/fine/MUXB_21_ ),
    .A(FINE_MUX[21]));
 sg13g2_nand3_1 \ring/fine/stage_22_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[22]),
    .A(\ring/fine/MUXB_22_ ),
    .Y(\ring/fine/UNCONNECTED_22_ ));
 sg13g2_inv_1 \ring/fine/stage_22_inv_b_impl  (.Y(\ring/fine/MUXB_22_ ),
    .A(FINE_MUX[22]));
 sg13g2_nand3_1 \ring/fine/stage_23_dyn_impl  (.B(\ring/fine/net4 ),
    .C(FINE_MUX[23]),
    .A(\ring/fine/MUXB_23_ ),
    .Y(\ring/fine/UNCONNECTED_23_ ));
 sg13g2_inv_1 \ring/fine/stage_23_inv_b_impl  (.Y(\ring/fine/MUXB_23_ ),
    .A(FINE_MUX[23]));
 sg13g2_nand3_1 \ring/fine/stage_24_dyn_impl  (.B(\ring/fine/net2 ),
    .C(FINE_MUX[24]),
    .A(\ring/fine/MUXB_24_ ),
    .Y(\ring/fine/UNCONNECTED_24_ ));
 sg13g2_inv_1 \ring/fine/stage_24_inv_b_impl  (.Y(\ring/fine/MUXB_24_ ),
    .A(FINE_MUX[24]));
 sg13g2_nand3_1 \ring/fine/stage_25_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[25]),
    .A(\ring/fine/MUXB_25_ ),
    .Y(\ring/fine/UNCONNECTED_25_ ));
 sg13g2_inv_1 \ring/fine/stage_25_inv_b_impl  (.Y(\ring/fine/MUXB_25_ ),
    .A(FINE_MUX[25]));
 sg13g2_nand3_1 \ring/fine/stage_26_dyn_impl  (.B(\ring/fine/net4 ),
    .C(FINE_MUX[26]),
    .A(\ring/fine/MUXB_26_ ),
    .Y(\ring/fine/UNCONNECTED_26_ ));
 sg13g2_inv_1 \ring/fine/stage_26_inv_b_impl  (.Y(\ring/fine/MUXB_26_ ),
    .A(FINE_MUX[26]));
 sg13g2_nand3_1 \ring/fine/stage_27_dyn_impl  (.B(\ring/fine/net4 ),
    .C(FINE_MUX[27]),
    .A(\ring/fine/MUXB_27_ ),
    .Y(\ring/fine/UNCONNECTED_27_ ));
 sg13g2_inv_1 \ring/fine/stage_27_inv_b_impl  (.Y(\ring/fine/MUXB_27_ ),
    .A(FINE_MUX[27]));
 sg13g2_nand3_1 \ring/fine/stage_28_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[28]),
    .A(\ring/fine/MUXB_28_ ),
    .Y(\ring/fine/UNCONNECTED_28_ ));
 sg13g2_inv_1 \ring/fine/stage_28_inv_b_impl  (.Y(\ring/fine/MUXB_28_ ),
    .A(FINE_MUX[28]));
 sg13g2_nand3_1 \ring/fine/stage_29_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[29]),
    .A(\ring/fine/MUXB_29_ ),
    .Y(\ring/fine/UNCONNECTED_29_ ));
 sg13g2_inv_1 \ring/fine/stage_29_inv_b_impl  (.Y(\ring/fine/MUXB_29_ ),
    .A(FINE_MUX[29]));
 sg13g2_nand3_1 \ring/fine/stage_2_dyn_impl  (.B(\ring/fine/net2 ),
    .C(FINE_MUX[2]),
    .A(\ring/fine/MUXB_2_ ),
    .Y(\ring/fine/UNCONNECTED_2_ ));
 sg13g2_inv_1 \ring/fine/stage_2_inv_b_impl  (.Y(\ring/fine/MUXB_2_ ),
    .A(FINE_MUX[2]));
 sg13g2_nand3_1 \ring/fine/stage_30_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[30]),
    .A(\ring/fine/MUXB_30_ ),
    .Y(\ring/fine/UNCONNECTED_30_ ));
 sg13g2_inv_1 \ring/fine/stage_30_inv_b_impl  (.Y(\ring/fine/MUXB_30_ ),
    .A(FINE_MUX[30]));
 sg13g2_nand3_1 \ring/fine/stage_3_dyn_impl  (.B(\ring/fine/net2 ),
    .C(FINE_MUX[3]),
    .A(\ring/fine/MUXB_3_ ),
    .Y(\ring/fine/UNCONNECTED_3_ ));
 sg13g2_inv_1 \ring/fine/stage_3_inv_b_impl  (.Y(\ring/fine/MUXB_3_ ),
    .A(FINE_MUX[3]));
 sg13g2_nand3_1 \ring/fine/stage_4_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[4]),
    .A(\ring/fine/MUXB_4_ ),
    .Y(\ring/fine/UNCONNECTED_4_ ));
 sg13g2_inv_1 \ring/fine/stage_4_inv_b_impl  (.Y(\ring/fine/MUXB_4_ ),
    .A(FINE_MUX[4]));
 sg13g2_nand3_1 \ring/fine/stage_5_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[5]),
    .A(\ring/fine/MUXB_5_ ),
    .Y(\ring/fine/UNCONNECTED_5_ ));
 sg13g2_inv_1 \ring/fine/stage_5_inv_b_impl  (.Y(\ring/fine/MUXB_5_ ),
    .A(FINE_MUX[5]));
 sg13g2_nand3_1 \ring/fine/stage_6_dyn_impl  (.B(\ring/fine/net5 ),
    .C(FINE_MUX[6]),
    .A(\ring/fine/MUXB_6_ ),
    .Y(\ring/fine/UNCONNECTED_6_ ));
 sg13g2_inv_1 \ring/fine/stage_6_inv_b_impl  (.Y(\ring/fine/MUXB_6_ ),
    .A(FINE_MUX[6]));
 sg13g2_nand3_1 \ring/fine/stage_7_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[7]),
    .A(\ring/fine/MUXB_7_ ),
    .Y(\ring/fine/UNCONNECTED_7_ ));
 sg13g2_inv_1 \ring/fine/stage_7_inv_b_impl  (.Y(\ring/fine/MUXB_7_ ),
    .A(FINE_MUX[7]));
 sg13g2_nand3_1 \ring/fine/stage_8_dyn_impl  (.B(\ring/fine/net1 ),
    .C(FINE_MUX[8]),
    .A(\ring/fine/MUXB_8_ ),
    .Y(\ring/fine/UNCONNECTED_8_ ));
 sg13g2_inv_1 \ring/fine/stage_8_inv_b_impl  (.Y(\ring/fine/MUXB_8_ ),
    .A(FINE_MUX[8]));
 sg13g2_nand3_1 \ring/fine/stage_9_dyn_impl  (.B(\ring/fine/net3 ),
    .C(FINE_MUX[9]),
    .A(\ring/fine/MUXB_9_ ),
    .Y(\ring/fine/UNCONNECTED_9_ ));
 sg13g2_inv_1 \ring/fine/stage_9_inv_b_impl  (.Y(\ring/fine/MUXB_9_ ),
    .A(FINE_MUX[9]));
 sg13g2_buf_1 \ring/mid/fanout10  (.A(\ring/mid/net11 ),
    .X(\ring/mid/net10 ));
 sg13g2_buf_1 \ring/mid/fanout11  (.A(\ring/mid/net12 ),
    .X(\ring/mid/net11 ));
 sg13g2_buf_1 \ring/mid/fanout12  (.A(\ring/mid/net28 ),
    .X(\ring/mid/net12 ));
 sg13g2_buf_1 \ring/mid/fanout13  (.A(\ring/mid/net14 ),
    .X(\ring/mid/net13 ));
 sg13g2_buf_1 \ring/mid/fanout14  (.A(\ring/mid/net28 ),
    .X(\ring/mid/net14 ));
 sg13g2_buf_1 \ring/mid/fanout15  (.A(\ring/mid/net16 ),
    .X(\ring/mid/net15 ));
 sg13g2_buf_1 \ring/mid/fanout16  (.A(\ring/mid/net28 ),
    .X(\ring/mid/net16 ));
 sg13g2_buf_1 \ring/mid/fanout17  (.A(\ring/mid/net27 ),
    .X(\ring/mid/net17 ));
 sg13g2_buf_1 \ring/mid/fanout18  (.A(\ring/mid/net19 ),
    .X(\ring/mid/net18 ));
 sg13g2_buf_1 \ring/mid/fanout19  (.A(\ring/mid/net27 ),
    .X(\ring/mid/net19 ));
 sg13g2_buf_1 \ring/mid/fanout20  (.A(\ring/mid/net21 ),
    .X(\ring/mid/net20 ));
 sg13g2_buf_1 \ring/mid/fanout21  (.A(\ring/mid/net27 ),
    .X(\ring/mid/net21 ));
 sg13g2_buf_1 \ring/mid/fanout22  (.A(\ring/mid/net24 ),
    .X(\ring/mid/net22 ));
 sg13g2_buf_1 \ring/mid/fanout23  (.A(\ring/mid/net24 ),
    .X(\ring/mid/net23 ));
 sg13g2_buf_1 \ring/mid/fanout24  (.A(\ring/mid/net27 ),
    .X(\ring/mid/net24 ));
 sg13g2_buf_1 \ring/mid/fanout25  (.A(\ring/mid/net26 ),
    .X(\ring/mid/net25 ));
 sg13g2_buf_1 \ring/mid/fanout26  (.A(\ring/mid/net27 ),
    .X(\ring/mid/net26 ));
 sg13g2_buf_1 \ring/mid/fanout27  (.A(\ring/mid/net28 ),
    .X(\ring/mid/net27 ));
 sg13g2_buf_1 \ring/mid/fanout28  (.A(\ring/mid/LOAD ),
    .X(\ring/mid/net28 ));
 sg13g2_buf_1 \ring/mid/fanout6  (.A(\ring/mid/net12 ),
    .X(\ring/mid/net6 ));
 sg13g2_buf_1 \ring/mid/fanout7  (.A(\ring/mid/net12 ),
    .X(\ring/mid/net7 ));
 sg13g2_buf_1 \ring/mid/fanout8  (.A(\ring/mid/net11 ),
    .X(\ring/mid/net8 ));
 sg13g2_buf_1 \ring/mid/fanout9  (.A(\ring/mid/net11 ),
    .X(\ring/mid/net9 ));
 sg13g2_inv_2 \ring/mid/inv_0_impl  (.Y(\ring/mid/LOAD ),
    .A(\ring/COARSE_OUT ));
 sg13g2_inv_2 \ring/mid/inv_1_impl  (.Y(MID_OUT),
    .A(\ring/mid/net25 ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_0  (.B(\ring/mid/net23 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_1  (.B(\ring/mid/net23 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_2  (.B(\ring/mid/net23 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_3  (.B(\ring/mid/net26 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_4  (.B(\ring/mid/net23 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_5  (.B(\ring/mid/net23 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_6  (.B(\ring/mid/net24 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_nand3_1 \ring/mid/stage_0_dyn_impl_7  (.B(\ring/mid/net26 ),
    .C(MID_MUX[0]),
    .A(\ring/mid/MUXB_0_ ),
    .Y(\ring/mid/UNCONNECTED_0_ ));
 sg13g2_inv_1 \ring/mid/stage_0_inv_b_impl  (.Y(\ring/mid/MUXB_0_ ),
    .A(MID_MUX[0]));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_0  (.B(\ring/mid/net20 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_1  (.B(\ring/mid/net25 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_2  (.B(\ring/mid/net25 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_3  (.B(\ring/mid/net20 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_4  (.B(\ring/mid/net25 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_5  (.B(\ring/mid/net25 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_6  (.B(\ring/mid/net20 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_nand3_1 \ring/mid/stage_10_dyn_impl_7  (.B(\ring/mid/net26 ),
    .C(MID_MUX[10]),
    .A(\ring/mid/MUXB_10_ ),
    .Y(\ring/mid/UNCONNECTED_10_ ));
 sg13g2_inv_1 \ring/mid/stage_10_inv_b_impl  (.Y(\ring/mid/MUXB_10_ ),
    .A(MID_MUX[10]));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_0  (.B(\ring/mid/net10 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_1  (.B(\ring/mid/net8 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_2  (.B(\ring/mid/net8 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_3  (.B(\ring/mid/net10 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_4  (.B(\ring/mid/net8 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_5  (.B(\ring/mid/net10 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_6  (.B(\ring/mid/net7 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_nand3_1 \ring/mid/stage_11_dyn_impl_7  (.B(\ring/mid/net12 ),
    .C(MID_MUX[11]),
    .A(\ring/mid/MUXB_11_ ),
    .Y(\ring/mid/UNCONNECTED_11_ ));
 sg13g2_inv_1 \ring/mid/stage_11_inv_b_impl  (.Y(\ring/mid/MUXB_11_ ),
    .A(MID_MUX[11]));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_0  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_1  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_2  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_3  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_4  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_5  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_6  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_nand3_1 \ring/mid/stage_12_dyn_impl_7  (.B(\ring/mid/net6 ),
    .C(MID_MUX[12]),
    .A(\ring/mid/MUXB_12_ ),
    .Y(\ring/mid/UNCONNECTED_12_ ));
 sg13g2_inv_1 \ring/mid/stage_12_inv_b_impl  (.Y(\ring/mid/MUXB_12_ ),
    .A(MID_MUX[12]));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_0  (.B(\ring/mid/net22 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_1  (.B(\ring/mid/net22 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_2  (.B(\ring/mid/net22 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_3  (.B(\ring/mid/net22 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_4  (.B(\ring/mid/net22 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_5  (.B(\ring/mid/net16 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_6  (.B(\ring/mid/net22 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_nand3_1 \ring/mid/stage_13_dyn_impl_7  (.B(\ring/mid/net22 ),
    .C(MID_MUX[13]),
    .A(\ring/mid/MUXB_13_ ),
    .Y(\ring/mid/UNCONNECTED_13_ ));
 sg13g2_inv_1 \ring/mid/stage_13_inv_b_impl  (.Y(\ring/mid/MUXB_13_ ),
    .A(MID_MUX[13]));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_0  (.B(\ring/mid/net25 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_1  (.B(\ring/mid/net22 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_2  (.B(\ring/mid/net25 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_3  (.B(\ring/mid/net24 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_4  (.B(\ring/mid/net24 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_5  (.B(\ring/mid/net25 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_6  (.B(\ring/mid/net24 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_nand3_1 \ring/mid/stage_14_dyn_impl_7  (.B(\ring/mid/net26 ),
    .C(MID_MUX[14]),
    .A(\ring/mid/MUXB_14_ ),
    .Y(\ring/mid/UNCONNECTED_14_ ));
 sg13g2_inv_1 \ring/mid/stage_14_inv_b_impl  (.Y(\ring/mid/MUXB_14_ ),
    .A(MID_MUX[14]));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_0  (.B(\ring/mid/net20 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_1  (.B(\ring/mid/net20 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_2  (.B(\ring/mid/net21 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_3  (.B(\ring/mid/net20 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_4  (.B(\ring/mid/net20 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_5  (.B(\ring/mid/net21 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_6  (.B(\ring/mid/net21 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_nand3_1 \ring/mid/stage_1_dyn_impl_7  (.B(\ring/mid/net20 ),
    .C(MID_MUX[1]),
    .A(\ring/mid/MUXB_1_ ),
    .Y(\ring/mid/UNCONNECTED_1_ ));
 sg13g2_inv_1 \ring/mid/stage_1_inv_b_impl  (.Y(\ring/mid/MUXB_1_ ),
    .A(MID_MUX[1]));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_0  (.B(\ring/mid/net17 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_1  (.B(\ring/mid/net17 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_2  (.B(\ring/mid/net19 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_3  (.B(\ring/mid/net19 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_4  (.B(\ring/mid/net17 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_5  (.B(\ring/mid/net19 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_6  (.B(\ring/mid/net19 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_nand3_1 \ring/mid/stage_2_dyn_impl_7  (.B(\ring/mid/net17 ),
    .C(MID_MUX[2]),
    .A(\ring/mid/MUXB_2_ ),
    .Y(\ring/mid/UNCONNECTED_2_ ));
 sg13g2_inv_1 \ring/mid/stage_2_inv_b_impl  (.Y(\ring/mid/MUXB_2_ ),
    .A(MID_MUX[2]));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_0  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_1  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_2  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_3  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_4  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_5  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_6  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_nand3_1 \ring/mid/stage_3_dyn_impl_7  (.B(\ring/mid/net13 ),
    .C(MID_MUX[3]),
    .A(\ring/mid/MUXB_3_ ),
    .Y(\ring/mid/UNCONNECTED_3_ ));
 sg13g2_inv_1 \ring/mid/stage_3_inv_b_impl  (.Y(\ring/mid/MUXB_3_ ),
    .A(MID_MUX[3]));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_0  (.B(\ring/mid/net15 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_1  (.B(\ring/mid/net15 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_2  (.B(\ring/mid/net15 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_3  (.B(\ring/mid/net14 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_4  (.B(\ring/mid/net14 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_5  (.B(\ring/mid/net15 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_6  (.B(\ring/mid/net14 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_nand3_1 \ring/mid/stage_4_dyn_impl_7  (.B(\ring/mid/net15 ),
    .C(MID_MUX[4]),
    .A(\ring/mid/MUXB_4_ ),
    .Y(\ring/mid/UNCONNECTED_4_ ));
 sg13g2_inv_1 \ring/mid/stage_4_inv_b_impl  (.Y(\ring/mid/MUXB_4_ ),
    .A(MID_MUX[4]));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_0  (.B(\ring/mid/net10 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_1  (.B(\ring/mid/net10 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_2  (.B(\ring/mid/net11 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_3  (.B(\ring/mid/net10 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_4  (.B(\ring/mid/net10 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_5  (.B(\ring/mid/net11 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_6  (.B(\ring/mid/net10 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_nand3_1 \ring/mid/stage_5_dyn_impl_7  (.B(\ring/mid/net11 ),
    .C(MID_MUX[5]),
    .A(\ring/mid/MUXB_5_ ),
    .Y(\ring/mid/UNCONNECTED_5_ ));
 sg13g2_inv_1 \ring/mid/stage_5_inv_b_impl  (.Y(\ring/mid/MUXB_5_ ),
    .A(MID_MUX[5]));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_0  (.B(\ring/mid/net7 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_1  (.B(\ring/mid/net8 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_2  (.B(\ring/mid/net7 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_3  (.B(\ring/mid/net8 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_4  (.B(\ring/mid/net7 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_5  (.B(\ring/mid/net8 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_6  (.B(\ring/mid/net8 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_nand3_1 \ring/mid/stage_6_dyn_impl_7  (.B(\ring/mid/net7 ),
    .C(MID_MUX[6]),
    .A(\ring/mid/MUXB_6_ ),
    .Y(\ring/mid/UNCONNECTED_6_ ));
 sg13g2_inv_1 \ring/mid/stage_6_inv_b_impl  (.Y(\ring/mid/MUXB_6_ ),
    .A(MID_MUX[6]));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_0  (.B(\ring/mid/net17 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_1  (.B(\ring/mid/net17 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_2  (.B(\ring/mid/net18 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_3  (.B(\ring/mid/net18 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_4  (.B(\ring/mid/net18 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_5  (.B(\ring/mid/net17 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_6  (.B(\ring/mid/net18 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_nand3_1 \ring/mid/stage_7_dyn_impl_7  (.B(\ring/mid/net17 ),
    .C(MID_MUX[7]),
    .A(\ring/mid/MUXB_7_ ),
    .Y(\ring/mid/UNCONNECTED_7_ ));
 sg13g2_inv_1 \ring/mid/stage_7_inv_b_impl  (.Y(\ring/mid/MUXB_7_ ),
    .A(MID_MUX[7]));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_0  (.B(\ring/mid/net15 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_1  (.B(\ring/mid/net15 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_2  (.B(\ring/mid/net15 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_3  (.B(\ring/mid/net23 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_4  (.B(\ring/mid/net16 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_5  (.B(\ring/mid/net16 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_6  (.B(\ring/mid/net23 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_nand3_1 \ring/mid/stage_8_dyn_impl_7  (.B(\ring/mid/net23 ),
    .C(MID_MUX[8]),
    .A(\ring/mid/MUXB_8_ ),
    .Y(\ring/mid/UNCONNECTED_8_ ));
 sg13g2_inv_1 \ring/mid/stage_8_inv_b_impl  (.Y(\ring/mid/MUXB_8_ ),
    .A(MID_MUX[8]));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_0  (.B(\ring/mid/net9 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_1  (.B(\ring/mid/net19 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_2  (.B(\ring/mid/net19 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_3  (.B(\ring/mid/net9 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_4  (.B(\ring/mid/net9 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_5  (.B(\ring/mid/net9 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_6  (.B(\ring/mid/net8 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_nand3_1 \ring/mid/stage_9_dyn_impl_7  (.B(\ring/mid/net19 ),
    .C(MID_MUX[9]),
    .A(\ring/mid/MUXB_9_ ),
    .Y(\ring/mid/UNCONNECTED_9_ ));
 sg13g2_inv_1 \ring/mid/stage_9_inv_b_impl  (.Y(\ring/mid/MUXB_9_ ),
    .A(MID_MUX[9]));
 sg13g2_inv_1 \ring/sym/inj_dummy_inv_impl  (.Y(\ring/sym/INJ_DUMMY ),
    .A(\ring/sym/INJ_EDGE_BALANCED ));
 sg13g2_inv_1 \ring/sym/inj_slope_balancer_impl  (.Y(\ring/sym/INJ_EDGE_BALANCED ),
    .A(REF));
 sg13g2_inv_1 \ring/sym/osc_dummy_inv_impl  (.Y(\ring/sym/OSC_DUMMY ),
    .A(\ring/sym/OSC_BALANCED ));
 sg13g2_inv_1 \ring/sym/osc_slope_balancer_impl  (.Y(\ring/sym/OSC_BALANCED ),
    .A(\ring/FINE_OUT ));
 sg13g2_buf_1 \ring/sym/ssbbpd_impl/buf_nand_x_impl  (.A(\ring/sym/ssbbpd_impl/OUT_NANDX ),
    .X(\ring/SS_BBPD_WIRE_1_ ));
 sg13g2_buf_1 \ring/sym/ssbbpd_impl/buf_nand_y_impl  (.A(\ring/sym/ssbbpd_impl/OUT_NANDY ),
    .X(\ring/SS_BBPD_WIRE_0_ ));
 sg13g2_nand2_1 \ring/sym/ssbbpd_impl/nand_x_impl  (.Y(\ring/sym/ssbbpd_impl/OUT_NANDX ),
    .A(\ring/sym/OSC_BALANCED ),
    .B(\ring/sym/ssbbpd_impl/OUT_NANDY ));
 sg13g2_nand2_1 \ring/sym/ssbbpd_impl/nand_y_impl  (.Y(\ring/sym/ssbbpd_impl/OUT_NANDY ),
    .A(\ring/sym/INJ_EDGE_BALANCED ),
    .B(\ring/sym/ssbbpd_impl/OUT_NANDX ));
 sg13g2_nand2_1 \ring/sym/sym_mux/nand_inj_impl  (.Y(\ring/sym/sym_mux/OSC_INJ ),
    .A(\ring/sym/OSC_BALANCED ),
    .B(\ring/sym/sym_mux/DCO_EN_INJ_WIN ));
 sg13g2_nand2_1 \ring/sym/sym_mux/nand_pll_impl  (.Y(OUT),
    .A(\ring/sym/sym_mux/REF_INJ ),
    .B(\ring/sym/sym_mux/OSC_INJ ));
 sg13g2_nand2b_1 \ring/sym/sym_mux/nand_ref_impl  (.Y(\ring/sym/sym_mux/REF_INJ ),
    .B(zero_),
    .A_N(\ring/sym/INJ_EDGE_BALANCED ));
 sg13g2_nor2b_1 \ring/sym/sym_mux/norb_en_inj_impl  (.A(zero_),
    .B_N(DCO_EN),
    .Y(\ring/sym/sym_mux/DCO_EN_INJ_WIN ));
 assign INJ_EDGE = REF;
endmodule
