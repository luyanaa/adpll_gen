module PLL_ANALOG_MACRO (DCO_EN,
    INJ_EDGE,
    INJ_EN,
    MID_OUT,
    OUT,
    REF,
    COARSE_MUX,
    FINE_MUX,
    MID_MUX,
    SS_BBPD);
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

 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire net10;
 wire net11;
 wire net12;
 wire net13;
 wire net14;
 wire net15;
 wire net16;
 wire net17;
 wire net18;
 wire net19;
 wire net20;
 wire net21;
 wire net22;
 wire net23;
 wire net24;
 wire net25;
 wire net26;
 wire net27;
 wire net28;
 wire net29;
 wire net30;
 wire net31;
 wire net32;
 wire net33;
 wire net34;
 wire net35;
 wire net36;
 wire net37;
 wire net38;
 wire net39;
 wire net40;
 wire net41;
 wire net42;
 wire net43;
 wire net44;
 wire net45;
 wire net46;
 wire net47;
 wire net64;
 wire net48;
 wire net49;
 wire net50;
 wire net51;
 wire net52;
 wire net53;
 wire net54;
 wire net55;
 wire net56;
 wire net57;
 wire net58;
 wire net59;
 wire net60;
 wire net61;
 wire net62;
 wire net63;
 wire net65;
 wire net66;
 wire net67;
 wire net68;
 wire \pll_ana.INJ_WIN ;
 wire \pll_ana.dco/COARSE_OUT ;
 wire \pll_ana.dco/FINE_OUT ;
 wire \pll_ana.dco/SS_BBPD_WIRE[0] ;
 wire \pll_ana.dco/SS_BBPD_WIRE[1] ;
 wire \pll_ana.dco/dff_x.Q ;
 wire \pll_ana.dco/dff_y.Q ;
 wire \pll_ana.dco/coarse/FCHAIN[10] ;
 wire \pll_ana.dco/coarse/FCHAIN[11] ;
 wire \pll_ana.dco/coarse/FCHAIN[12] ;
 wire \pll_ana.dco/coarse/FCHAIN[13] ;
 wire \pll_ana.dco/coarse/FCHAIN[14] ;
 wire \pll_ana.dco/coarse/FCHAIN[15] ;
 wire \pll_ana.dco/coarse/FCHAIN[1] ;
 wire \pll_ana.dco/coarse/FCHAIN[2] ;
 wire \pll_ana.dco/coarse/FCHAIN[3] ;
 wire \pll_ana.dco/coarse/FCHAIN[4] ;
 wire \pll_ana.dco/coarse/FCHAIN[5] ;
 wire \pll_ana.dco/coarse/FCHAIN[6] ;
 wire \pll_ana.dco/coarse/FCHAIN[7] ;
 wire \pll_ana.dco/coarse/FCHAIN[8] ;
 wire \pll_ana.dco/coarse/FCHAIN[9] ;
 wire \pll_ana.dco/coarse/RCHAIN[10] ;
 wire \pll_ana.dco/coarse/RCHAIN[11] ;
 wire \pll_ana.dco/coarse/RCHAIN[12] ;
 wire \pll_ana.dco/coarse/RCHAIN[13] ;
 wire \pll_ana.dco/coarse/RCHAIN[14] ;
 wire \pll_ana.dco/coarse/RCHAIN[15] ;
 wire \pll_ana.dco/coarse/RCHAIN[1] ;
 wire \pll_ana.dco/coarse/RCHAIN[2] ;
 wire \pll_ana.dco/coarse/RCHAIN[3] ;
 wire \pll_ana.dco/coarse/RCHAIN[4] ;
 wire \pll_ana.dco/coarse/RCHAIN[5] ;
 wire \pll_ana.dco/coarse/RCHAIN[6] ;
 wire \pll_ana.dco/coarse/RCHAIN[7] ;
 wire \pll_ana.dco/coarse/RCHAIN[8] ;
 wire \pll_ana.dco/coarse/RCHAIN[9] ;
 wire \pll_ana.dco/coarse/stage[0].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[10].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[11].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[12].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[13].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[14].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[1].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[2].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[3].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[4].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[5].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[6].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[7].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[8].impl/PATH_0 ;
 wire \pll_ana.dco/coarse/stage[9].impl/PATH_0 ;
 wire \pll_ana.dco/fine/LOAD ;
 wire \pll_ana.dco/fine/stage[0].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[0].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[10].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[10].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[11].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[11].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[12].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[12].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[13].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[13].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[14].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[14].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[15].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[15].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[16].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[16].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[17].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[17].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[18].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[18].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[19].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[19].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[1].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[1].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[20].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[20].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[21].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[21].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[22].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[22].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[23].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[23].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[24].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[24].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[25].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[25].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[26].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[26].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[27].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[27].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[28].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[28].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[29].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[29].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[2].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[2].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[30].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[30].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[3].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[3].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[4].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[4].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[5].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[5].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[6].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[6].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[7].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[7].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[8].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[8].dyn.ZN ;
 wire \pll_ana.dco/fine/stage[9].dyn.A2 ;
 wire \pll_ana.dco/fine/stage[9].dyn.ZN ;
 wire \pll_ana.dco/mid/LOAD ;
 wire \pll_ana.dco/mid/stage[0].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[0].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[10].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[10].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[11].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[11].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[12].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[12].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[13].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[13].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[14].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[14].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[1].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[1].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[2].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[2].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[3].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[3].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[4].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[4].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[5].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[5].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[6].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[6].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[7].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[7].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[8].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[8].dyn.ZN ;
 wire \pll_ana.dco/mid/stage[9].dyn.A2 ;
 wire \pll_ana.dco/mid/stage[9].dyn.ZN ;
 wire \pll_ana.dco/sym/INJ_DUMMY ;
 wire \pll_ana.dco/sym/INJ_EDGE_BALANCED ;
 wire \pll_ana.dco/sym/OSC_BALANCED ;
 wire \pll_ana.dco/sym/OSC_DUMMY ;
 wire \pll_ana.dco/sym/ssbbpd_impl/OUT_NANDX ;
 wire \pll_ana.dco/sym/ssbbpd_impl/OUT_NANDY ;
 wire \pll_ana.dco/sym/ssbbpd_impl/buf_nand_x.Z ;
 wire \pll_ana.dco/sym/ssbbpd_impl/buf_nand_y.Z ;
 wire \pll_ana.dco/sym/sym_mux/DCO_EN_INJ_WIN ;
 wire \pll_ana.dco/sym/sym_mux/OSC_INJ ;
 wire \pll_ana.dco/sym/sym_mux/REF_INJ ;
 wire \pll_ana.inj/CHAIN_OUT ;
 wire \pll_ana.inj/cmp_nor.del_en.A1 ;
 wire \pll_ana.inj/stage[0].del_1.Z ;
 wire \pll_ana.inj/stage[0].del_2.Z ;
 wire \pll_ana.inj/stage[1].del_1.Z ;
 wire \pll_ana.inj/stage[1].del_2.Z ;
 wire \pll_ana.inj/stage[2].del_1.Z ;
 wire \pll_ana.inj/stage[2].del_2.Z ;

 sky130_as_sc_hs__decap_16 FILLER_0_1 ();
 sky130_as_sc_hs__decap_4 FILLER_0_105 ();
 sky130_as_sc_hs__fill_1 FILLER_0_109 ();
 sky130_as_sc_hs__decap_16 FILLER_0_113 ();
 sky130_as_sc_hs__decap_16 FILLER_0_130 ();
 sky130_as_sc_hs__decap_3 FILLER_0_146 ();
 sky130_as_sc_hs__fill_8 FILLER_0_17 ();
 sky130_as_sc_hs__fill_1 FILLER_0_25 ();
 sky130_as_sc_hs__fill_2 FILLER_0_29 ();
 sky130_as_sc_hs__fill_2 FILLER_0_44 ();
 sky130_as_sc_hs__fill_2 FILLER_0_91 ();
 sky130_as_sc_hs__fill_2 FILLER_10_1 ();
 sky130_as_sc_hs__decap_4 FILLER_10_108 ();
 sky130_as_sc_hs__decap_3 FILLER_10_112 ();
 sky130_as_sc_hs__decap_4 FILLER_10_123 ();
 sky130_as_sc_hs__fill_2 FILLER_10_127 ();
 sky130_as_sc_hs__decap_3 FILLER_10_138 ();
 sky130_as_sc_hs__fill_8 FILLER_10_18 ();
 sky130_as_sc_hs__decap_3 FILLER_10_26 ();
 sky130_as_sc_hs__fill_8 FILLER_10_34 ();
 sky130_as_sc_hs__fill_1 FILLER_10_42 ();
 sky130_as_sc_hs__decap_16 FILLER_10_44 ();
 sky130_as_sc_hs__decap_16 FILLER_10_60 ();
 sky130_as_sc_hs__decap_16 FILLER_10_76 ();
 sky130_as_sc_hs__decap_16 FILLER_10_92 ();
 sky130_as_sc_hs__fill_2 FILLER_11_1 ();
 sky130_as_sc_hs__fill_8 FILLER_11_106 ();
 sky130_as_sc_hs__fill_2 FILLER_11_114 ();
 sky130_as_sc_hs__decap_16 FILLER_11_121 ();
 sky130_as_sc_hs__decap_4 FILLER_11_25 ();
 sky130_as_sc_hs__decap_16 FILLER_11_42 ();
 sky130_as_sc_hs__decap_16 FILLER_11_58 ();
 sky130_as_sc_hs__fill_8 FILLER_11_74 ();
 sky130_as_sc_hs__decap_4 FILLER_11_82 ();
 sky130_as_sc_hs__fill_8 FILLER_11_87 ();
 sky130_as_sc_hs__decap_4 FILLER_11_95 ();
 sky130_as_sc_hs__fill_2 FILLER_11_99 ();
 sky130_as_sc_hs__decap_4 FILLER_12_109 ();
 sky130_as_sc_hs__fill_2 FILLER_12_113 ();
 sky130_as_sc_hs__fill_8 FILLER_12_119 ();
 sky130_as_sc_hs__fill_2 FILLER_12_127 ();
 sky130_as_sc_hs__decap_3 FILLER_12_13 ();
 sky130_as_sc_hs__fill_1 FILLER_12_148 ();
 sky130_as_sc_hs__fill_8 FILLER_12_19 ();
 sky130_as_sc_hs__decap_3 FILLER_12_27 ();
 sky130_as_sc_hs__fill_8 FILLER_12_35 ();
 sky130_as_sc_hs__decap_16 FILLER_12_44 ();
 sky130_as_sc_hs__decap_16 FILLER_12_60 ();
 sky130_as_sc_hs__decap_3 FILLER_12_76 ();
 sky130_as_sc_hs__fill_2 FILLER_12_84 ();
 sky130_as_sc_hs__fill_2 FILLER_12_99 ();
 sky130_as_sc_hs__decap_4 FILLER_13_104 ();
 sky130_as_sc_hs__decap_3 FILLER_13_108 ();
 sky130_as_sc_hs__decap_3 FILLER_13_116 ();
 sky130_as_sc_hs__fill_1 FILLER_13_13 ();
 sky130_as_sc_hs__fill_8 FILLER_13_131 ();
 sky130_as_sc_hs__fill_2 FILLER_13_139 ();
 sky130_as_sc_hs__decap_4 FILLER_13_22 ();
 sky130_as_sc_hs__decap_3 FILLER_13_26 ();
 sky130_as_sc_hs__decap_16 FILLER_13_42 ();
 sky130_as_sc_hs__fill_8 FILLER_13_58 ();
 sky130_as_sc_hs__decap_4 FILLER_13_66 ();
 sky130_as_sc_hs__decap_3 FILLER_13_83 ();
 sky130_as_sc_hs__decap_4 FILLER_13_87 ();
 sky130_as_sc_hs__decap_3 FILLER_13_91 ();
 sky130_as_sc_hs__fill_2 FILLER_14_1 ();
 sky130_as_sc_hs__fill_2 FILLER_14_100 ();
 sky130_as_sc_hs__decap_3 FILLER_14_107 ();
 sky130_as_sc_hs__fill_8 FILLER_14_117 ();
 sky130_as_sc_hs__decap_4 FILLER_14_125 ();
 sky130_as_sc_hs__decap_4 FILLER_14_130 ();
 sky130_as_sc_hs__decap_3 FILLER_14_134 ();
 sky130_as_sc_hs__fill_8 FILLER_14_14 ();
 sky130_as_sc_hs__decap_4 FILLER_14_22 ();
 sky130_as_sc_hs__decap_3 FILLER_14_26 ();
 sky130_as_sc_hs__fill_8 FILLER_14_34 ();
 sky130_as_sc_hs__fill_1 FILLER_14_42 ();
 sky130_as_sc_hs__decap_16 FILLER_14_44 ();
 sky130_as_sc_hs__decap_16 FILLER_14_60 ();
 sky130_as_sc_hs__decap_16 FILLER_14_76 ();
 sky130_as_sc_hs__fill_8 FILLER_14_92 ();
 sky130_as_sc_hs__fill_2 FILLER_15_1 ();
 sky130_as_sc_hs__decap_16 FILLER_15_103 ();
 sky130_as_sc_hs__decap_3 FILLER_15_119 ();
 sky130_as_sc_hs__fill_1 FILLER_15_133 ();
 sky130_as_sc_hs__fill_2 FILLER_15_15 ();
 sky130_as_sc_hs__decap_4 FILLER_15_22 ();
 sky130_as_sc_hs__fill_2 FILLER_15_26 ();
 sky130_as_sc_hs__decap_16 FILLER_15_36 ();
 sky130_as_sc_hs__decap_16 FILLER_15_52 ();
 sky130_as_sc_hs__decap_16 FILLER_15_68 ();
 sky130_as_sc_hs__fill_2 FILLER_15_84 ();
 sky130_as_sc_hs__decap_16 FILLER_15_87 ();
 sky130_as_sc_hs__fill_8 FILLER_16_108 ();
 sky130_as_sc_hs__decap_4 FILLER_16_116 ();
 sky130_as_sc_hs__decap_4 FILLER_16_12 ();
 sky130_as_sc_hs__fill_1 FILLER_16_128 ();
 sky130_as_sc_hs__fill_8 FILLER_16_130 ();
 sky130_as_sc_hs__fill_8 FILLER_16_24 ();
 sky130_as_sc_hs__decap_4 FILLER_16_37 ();
 sky130_as_sc_hs__fill_2 FILLER_16_41 ();
 sky130_as_sc_hs__decap_16 FILLER_16_44 ();
 sky130_as_sc_hs__decap_16 FILLER_16_60 ();
 sky130_as_sc_hs__decap_16 FILLER_16_76 ();
 sky130_as_sc_hs__decap_16 FILLER_16_92 ();
 sky130_as_sc_hs__decap_16 FILLER_17_103 ();
 sky130_as_sc_hs__decap_4 FILLER_17_119 ();
 sky130_as_sc_hs__fill_8 FILLER_17_12 ();
 sky130_as_sc_hs__fill_8 FILLER_17_126 ();
 sky130_as_sc_hs__decap_4 FILLER_17_20 ();
 sky130_as_sc_hs__fill_1 FILLER_17_24 ();
 sky130_as_sc_hs__decap_16 FILLER_17_30 ();
 sky130_as_sc_hs__decap_16 FILLER_17_46 ();
 sky130_as_sc_hs__fill_2 FILLER_17_5 ();
 sky130_as_sc_hs__decap_16 FILLER_17_62 ();
 sky130_as_sc_hs__fill_8 FILLER_17_78 ();
 sky130_as_sc_hs__decap_16 FILLER_17_87 ();
 sky130_as_sc_hs__decap_16 FILLER_18_108 ();
 sky130_as_sc_hs__decap_4 FILLER_18_124 ();
 sky130_as_sc_hs__fill_1 FILLER_18_128 ();
 sky130_as_sc_hs__fill_8 FILLER_18_13 ();
 sky130_as_sc_hs__decap_4 FILLER_18_130 ();
 sky130_as_sc_hs__fill_1 FILLER_18_21 ();
 sky130_as_sc_hs__decap_16 FILLER_18_27 ();
 sky130_as_sc_hs__decap_16 FILLER_18_44 ();
 sky130_as_sc_hs__decap_16 FILLER_18_60 ();
 sky130_as_sc_hs__decap_16 FILLER_18_76 ();
 sky130_as_sc_hs__decap_16 FILLER_18_92 ();
 sky130_as_sc_hs__decap_16 FILLER_19_103 ();
 sky130_as_sc_hs__decap_4 FILLER_19_119 ();
 sky130_as_sc_hs__fill_2 FILLER_19_123 ();
 sky130_as_sc_hs__fill_8 FILLER_19_13 ();
 sky130_as_sc_hs__decap_4 FILLER_19_136 ();
 sky130_as_sc_hs__fill_1 FILLER_19_140 ();
 sky130_as_sc_hs__fill_8 FILLER_19_26 ();
 sky130_as_sc_hs__fill_1 FILLER_19_34 ();
 sky130_as_sc_hs__decap_16 FILLER_19_40 ();
 sky130_as_sc_hs__fill_8 FILLER_19_56 ();
 sky130_as_sc_hs__decap_4 FILLER_19_64 ();
 sky130_as_sc_hs__decap_3 FILLER_19_68 ();
 sky130_as_sc_hs__fill_2 FILLER_19_84 ();
 sky130_as_sc_hs__decap_16 FILLER_19_87 ();
 sky130_as_sc_hs__decap_16 FILLER_1_1 ();
 sky130_as_sc_hs__decap_16 FILLER_1_116 ();
 sky130_as_sc_hs__decap_16 FILLER_1_132 ();
 sky130_as_sc_hs__fill_1 FILLER_1_148 ();
 sky130_as_sc_hs__decap_4 FILLER_1_17 ();
 sky130_as_sc_hs__fill_2 FILLER_1_21 ();
 sky130_as_sc_hs__fill_1 FILLER_1_31 ();
 sky130_as_sc_hs__fill_2 FILLER_1_40 ();
 sky130_as_sc_hs__fill_2 FILLER_1_87 ();
 sky130_as_sc_hs__decap_16 FILLER_20_109 ();
 sky130_as_sc_hs__decap_3 FILLER_20_11 ();
 sky130_as_sc_hs__decap_4 FILLER_20_125 ();
 sky130_as_sc_hs__decap_4 FILLER_20_130 ();
 sky130_as_sc_hs__decap_4 FILLER_20_22 ();
 sky130_as_sc_hs__decap_4 FILLER_20_39 ();
 sky130_as_sc_hs__fill_8 FILLER_20_44 ();
 sky130_as_sc_hs__fill_1 FILLER_20_5 ();
 sky130_as_sc_hs__decap_4 FILLER_20_52 ();
 sky130_as_sc_hs__fill_8 FILLER_20_61 ();
 sky130_as_sc_hs__decap_3 FILLER_20_69 ();
 sky130_as_sc_hs__decap_16 FILLER_20_77 ();
 sky130_as_sc_hs__decap_16 FILLER_20_93 ();
 sky130_as_sc_hs__fill_8 FILLER_21_1 ();
 sky130_as_sc_hs__decap_16 FILLER_21_101 ();
 sky130_as_sc_hs__decap_16 FILLER_21_117 ();
 sky130_as_sc_hs__decap_4 FILLER_21_133 ();
 sky130_as_sc_hs__fill_1 FILLER_21_137 ();
 sky130_as_sc_hs__decap_4 FILLER_21_15 ();
 sky130_as_sc_hs__decap_3 FILLER_21_19 ();
 sky130_as_sc_hs__decap_16 FILLER_21_27 ();
 sky130_as_sc_hs__decap_4 FILLER_21_43 ();
 sky130_as_sc_hs__fill_2 FILLER_21_47 ();
 sky130_as_sc_hs__fill_2 FILLER_21_62 ();
 sky130_as_sc_hs__decap_4 FILLER_21_82 ();
 sky130_as_sc_hs__decap_3 FILLER_21_87 ();
 sky130_as_sc_hs__fill_1 FILLER_21_9 ();
 sky130_as_sc_hs__decap_16 FILLER_22_1 ();
 sky130_as_sc_hs__decap_4 FILLER_22_101 ();
 sky130_as_sc_hs__decap_4 FILLER_22_108 ();
 sky130_as_sc_hs__fill_1 FILLER_22_112 ();
 sky130_as_sc_hs__fill_8 FILLER_22_116 ();
 sky130_as_sc_hs__decap_4 FILLER_22_124 ();
 sky130_as_sc_hs__fill_1 FILLER_22_128 ();
 sky130_as_sc_hs__fill_8 FILLER_22_130 ();
 sky130_as_sc_hs__decap_4 FILLER_22_138 ();
 sky130_as_sc_hs__decap_3 FILLER_22_142 ();
 sky130_as_sc_hs__decap_16 FILLER_22_17 ();
 sky130_as_sc_hs__fill_8 FILLER_22_33 ();
 sky130_as_sc_hs__fill_2 FILLER_22_41 ();
 sky130_as_sc_hs__decap_16 FILLER_22_44 ();
 sky130_as_sc_hs__decap_16 FILLER_22_60 ();
 sky130_as_sc_hs__fill_8 FILLER_22_76 ();
 sky130_as_sc_hs__fill_8 FILLER_22_90 ();
 sky130_as_sc_hs__decap_16 FILLER_23_1 ();
 sky130_as_sc_hs__decap_16 FILLER_23_120 ();
 sky130_as_sc_hs__fill_8 FILLER_23_136 ();
 sky130_as_sc_hs__decap_4 FILLER_23_144 ();
 sky130_as_sc_hs__fill_1 FILLER_23_148 ();
 sky130_as_sc_hs__decap_16 FILLER_23_17 ();
 sky130_as_sc_hs__decap_16 FILLER_23_33 ();
 sky130_as_sc_hs__decap_16 FILLER_23_49 ();
 sky130_as_sc_hs__fill_8 FILLER_23_65 ();
 sky130_as_sc_hs__decap_4 FILLER_23_73 ();
 sky130_as_sc_hs__fill_1 FILLER_23_77 ();
 sky130_as_sc_hs__fill_1 FILLER_23_95 ();
 sky130_as_sc_hs__decap_16 FILLER_24_1 ();
 sky130_as_sc_hs__decap_16 FILLER_24_113 ();
 sky130_as_sc_hs__decap_16 FILLER_24_130 ();
 sky130_as_sc_hs__decap_3 FILLER_24_146 ();
 sky130_as_sc_hs__decap_16 FILLER_24_17 ();
 sky130_as_sc_hs__fill_8 FILLER_24_33 ();
 sky130_as_sc_hs__fill_2 FILLER_24_41 ();
 sky130_as_sc_hs__fill_8 FILLER_24_44 ();
 sky130_as_sc_hs__decap_4 FILLER_24_52 ();
 sky130_as_sc_hs__decap_3 FILLER_24_56 ();
 sky130_as_sc_hs__decap_4 FILLER_24_63 ();
 sky130_as_sc_hs__fill_2 FILLER_24_67 ();
 sky130_as_sc_hs__fill_8 FILLER_24_77 ();
 sky130_as_sc_hs__fill_1 FILLER_24_85 ();
 sky130_as_sc_hs__fill_2 FILLER_24_87 ();
 sky130_as_sc_hs__decap_16 FILLER_2_1 ();
 sky130_as_sc_hs__decap_16 FILLER_2_105 ();
 sky130_as_sc_hs__fill_8 FILLER_2_121 ();
 sky130_as_sc_hs__decap_16 FILLER_2_130 ();
 sky130_as_sc_hs__decap_3 FILLER_2_146 ();
 sky130_as_sc_hs__decap_16 FILLER_2_17 ();
 sky130_as_sc_hs__fill_2 FILLER_2_44 ();
 sky130_as_sc_hs__fill_1 FILLER_2_49 ();
 sky130_as_sc_hs__fill_2 FILLER_2_57 ();
 sky130_as_sc_hs__fill_2 FILLER_2_75 ();
 sky130_as_sc_hs__fill_2 FILLER_2_80 ();
 sky130_as_sc_hs__decap_4 FILLER_2_85 ();
 sky130_as_sc_hs__fill_2 FILLER_2_89 ();
 sky130_as_sc_hs__fill_8 FILLER_2_94 ();
 sky130_as_sc_hs__decap_16 FILLER_3_1 ();
 sky130_as_sc_hs__decap_16 FILLER_3_109 ();
 sky130_as_sc_hs__decap_16 FILLER_3_125 ();
 sky130_as_sc_hs__fill_8 FILLER_3_141 ();
 sky130_as_sc_hs__decap_16 FILLER_3_17 ();
 sky130_as_sc_hs__decap_3 FILLER_3_33 ();
 sky130_as_sc_hs__decap_4 FILLER_3_44 ();
 sky130_as_sc_hs__fill_2 FILLER_3_48 ();
 sky130_as_sc_hs__fill_8 FILLER_3_53 ();
 sky130_as_sc_hs__fill_1 FILLER_3_64 ();
 sky130_as_sc_hs__fill_1 FILLER_3_68 ();
 sky130_as_sc_hs__fill_2 FILLER_3_72 ();
 sky130_as_sc_hs__fill_8 FILLER_3_77 ();
 sky130_as_sc_hs__fill_1 FILLER_3_85 ();
 sky130_as_sc_hs__fill_2 FILLER_3_87 ();
 sky130_as_sc_hs__fill_1 FILLER_3_97 ();
 sky130_as_sc_hs__decap_16 FILLER_4_1 ();
 sky130_as_sc_hs__decap_16 FILLER_4_108 ();
 sky130_as_sc_hs__decap_4 FILLER_4_124 ();
 sky130_as_sc_hs__fill_1 FILLER_4_128 ();
 sky130_as_sc_hs__decap_16 FILLER_4_130 ();
 sky130_as_sc_hs__decap_3 FILLER_4_146 ();
 sky130_as_sc_hs__decap_16 FILLER_4_17 ();
 sky130_as_sc_hs__fill_8 FILLER_4_33 ();
 sky130_as_sc_hs__fill_2 FILLER_4_41 ();
 sky130_as_sc_hs__fill_1 FILLER_4_63 ();
 sky130_as_sc_hs__fill_1 FILLER_4_80 ();
 sky130_as_sc_hs__decap_4 FILLER_4_84 ();
 sky130_as_sc_hs__fill_1 FILLER_4_88 ();
 sky130_as_sc_hs__decap_16 FILLER_4_92 ();
 sky130_as_sc_hs__decap_4 FILLER_5_1 ();
 sky130_as_sc_hs__decap_16 FILLER_5_111 ();
 sky130_as_sc_hs__decap_16 FILLER_5_127 ();
 sky130_as_sc_hs__decap_4 FILLER_5_143 ();
 sky130_as_sc_hs__fill_2 FILLER_5_147 ();
 sky130_as_sc_hs__decap_16 FILLER_5_24 ();
 sky130_as_sc_hs__decap_16 FILLER_5_40 ();
 sky130_as_sc_hs__decap_4 FILLER_5_56 ();
 sky130_as_sc_hs__fill_1 FILLER_5_60 ();
 sky130_as_sc_hs__decap_4 FILLER_5_72 ();
 sky130_as_sc_hs__fill_2 FILLER_5_76 ();
 sky130_as_sc_hs__decap_16 FILLER_5_8 ();
 sky130_as_sc_hs__decap_16 FILLER_5_95 ();
 sky130_as_sc_hs__fill_2 FILLER_6_1 ();
 sky130_as_sc_hs__fill_8 FILLER_6_108 ();
 sky130_as_sc_hs__decap_16 FILLER_6_11 ();
 sky130_as_sc_hs__decap_3 FILLER_6_116 ();
 sky130_as_sc_hs__fill_1 FILLER_6_123 ();
 sky130_as_sc_hs__fill_1 FILLER_6_128 ();
 sky130_as_sc_hs__decap_16 FILLER_6_27 ();
 sky130_as_sc_hs__decap_16 FILLER_6_44 ();
 sky130_as_sc_hs__decap_16 FILLER_6_60 ();
 sky130_as_sc_hs__decap_16 FILLER_6_76 ();
 sky130_as_sc_hs__decap_16 FILLER_6_92 ();
 sky130_as_sc_hs__decap_4 FILLER_7_103 ();
 sky130_as_sc_hs__fill_2 FILLER_7_107 ();
 sky130_as_sc_hs__decap_16 FILLER_7_12 ();
 sky130_as_sc_hs__decap_16 FILLER_7_122 ();
 sky130_as_sc_hs__decap_3 FILLER_7_138 ();
 sky130_as_sc_hs__decap_16 FILLER_7_33 ();
 sky130_as_sc_hs__decap_16 FILLER_7_49 ();
 sky130_as_sc_hs__decap_3 FILLER_7_65 ();
 sky130_as_sc_hs__decap_4 FILLER_7_79 ();
 sky130_as_sc_hs__decap_3 FILLER_7_83 ();
 sky130_as_sc_hs__decap_16 FILLER_7_87 ();
 sky130_as_sc_hs__fill_2 FILLER_8_1 ();
 sky130_as_sc_hs__fill_8 FILLER_8_108 ();
 sky130_as_sc_hs__decap_4 FILLER_8_116 ();
 sky130_as_sc_hs__fill_1 FILLER_8_120 ();
 sky130_as_sc_hs__decap_4 FILLER_8_130 ();
 sky130_as_sc_hs__decap_3 FILLER_8_134 ();
 sky130_as_sc_hs__fill_8 FILLER_8_15 ();
 sky130_as_sc_hs__decap_4 FILLER_8_23 ();
 sky130_as_sc_hs__decap_4 FILLER_8_39 ();
 sky130_as_sc_hs__decap_16 FILLER_8_44 ();
 sky130_as_sc_hs__decap_16 FILLER_8_60 ();
 sky130_as_sc_hs__decap_16 FILLER_8_76 ();
 sky130_as_sc_hs__decap_16 FILLER_8_92 ();
 sky130_as_sc_hs__fill_2 FILLER_9_111 ();
 sky130_as_sc_hs__fill_1 FILLER_9_116 ();
 sky130_as_sc_hs__fill_8 FILLER_9_122 ();
 sky130_as_sc_hs__fill_8 FILLER_9_20 ();
 sky130_as_sc_hs__decap_4 FILLER_9_28 ();
 sky130_as_sc_hs__decap_16 FILLER_9_37 ();
 sky130_as_sc_hs__decap_16 FILLER_9_53 ();
 sky130_as_sc_hs__decap_16 FILLER_9_69 ();
 sky130_as_sc_hs__fill_1 FILLER_9_85 ();
 sky130_as_sc_hs__fill_8 FILLER_9_87 ();
 sky130_as_sc_hs__decap_3 FILLER_9_95 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_0_Left_25 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_0_Right_0 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_10_Left_35 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_10_Right_10 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_11_Left_36 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_11_Right_11 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_12_Left_37 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_12_Right_12 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_13_Left_38 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_13_Right_13 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_14_Left_39 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_14_Right_14 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_15_Left_40 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_15_Right_15 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_16_Left_41 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_16_Right_16 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_17_Left_42 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_17_Right_17 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_18_Left_43 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_18_Right_18 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_19_Left_44 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_19_Right_19 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_1_Left_26 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_1_Right_1 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_20_Left_45 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_20_Right_20 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_21_Left_46 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_21_Right_21 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_22_Left_47 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_22_Right_22 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_23_Left_48 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_23_Right_23 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_24_Left_49 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_24_Right_24 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_2_Left_27 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_2_Right_2 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_3_Left_28 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_3_Right_3 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_4_Left_29 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_4_Right_4 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_5_Left_30 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_5_Right_5 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_6_Left_31 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_6_Right_6 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_7_Left_32 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_7_Right_7 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_8_Left_33 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_8_Right_8 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_9_Left_34 ();
 sky130_as_sc_hs__tap_1 PHY_EDGE_ROW_9_Right_9 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_0_50 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_0_51 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_0_52 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_10_66 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_10_67 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_11_68 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_12_69 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_12_70 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_13_71 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_14_72 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_14_73 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_15_74 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_16_75 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_16_76 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_17_77 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_18_78 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_18_79 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_19_80 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_1_53 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_20_81 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_20_82 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_21_83 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_22_84 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_22_85 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_23_86 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_24_87 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_24_88 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_24_89 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_2_54 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_2_55 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_3_56 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_4_57 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_4_58 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_5_59 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_6_60 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_6_61 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_7_62 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_8_63 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_8_64 ();
 sky130_as_sc_hs__tap_1 TAP_TAPCELL_ROW_9_65 ();
 sky130_as_sc_hs__buff_2 input1 (.A(COARSE_MUX[0]),
    .Y(net1));
 sky130_as_sc_hs__buff_2 input10 (.A(COARSE_MUX[4]),
    .Y(net10));
 sky130_as_sc_hs__buff_2 input11 (.A(COARSE_MUX[5]),
    .Y(net11));
 sky130_as_sc_hs__buff_2 input12 (.A(COARSE_MUX[6]),
    .Y(net12));
 sky130_as_sc_hs__buff_2 input13 (.A(COARSE_MUX[7]),
    .Y(net13));
 sky130_as_sc_hs__buff_2 input14 (.A(COARSE_MUX[8]),
    .Y(net14));
 sky130_as_sc_hs__buff_2 input15 (.A(COARSE_MUX[9]),
    .Y(net15));
 sky130_as_sc_hs__buff_2 input16 (.A(DCO_EN),
    .Y(net16));
 sky130_as_sc_hs__buff_2 input17 (.A(FINE_MUX[0]),
    .Y(net17));
 sky130_as_sc_hs__buff_2 input18 (.A(FINE_MUX[10]),
    .Y(net18));
 sky130_as_sc_hs__buff_2 input19 (.A(FINE_MUX[11]),
    .Y(net19));
 sky130_as_sc_hs__buff_2 input2 (.A(COARSE_MUX[10]),
    .Y(net2));
 sky130_as_sc_hs__buff_2 input20 (.A(FINE_MUX[12]),
    .Y(net20));
 sky130_as_sc_hs__buff_2 input21 (.A(FINE_MUX[13]),
    .Y(net21));
 sky130_as_sc_hs__buff_2 input22 (.A(FINE_MUX[14]),
    .Y(net22));
 sky130_as_sc_hs__buff_2 input23 (.A(FINE_MUX[15]),
    .Y(net23));
 sky130_as_sc_hs__buff_2 input24 (.A(FINE_MUX[16]),
    .Y(net24));
 sky130_as_sc_hs__buff_2 input25 (.A(FINE_MUX[17]),
    .Y(net25));
 sky130_as_sc_hs__buff_2 input26 (.A(FINE_MUX[18]),
    .Y(net26));
 sky130_as_sc_hs__buff_2 input27 (.A(FINE_MUX[19]),
    .Y(net27));
 sky130_as_sc_hs__buff_2 input28 (.A(FINE_MUX[1]),
    .Y(net28));
 sky130_as_sc_hs__buff_2 input29 (.A(FINE_MUX[20]),
    .Y(net29));
 sky130_as_sc_hs__buff_2 input3 (.A(COARSE_MUX[11]),
    .Y(net3));
 sky130_as_sc_hs__buff_2 input30 (.A(FINE_MUX[21]),
    .Y(net30));
 sky130_as_sc_hs__buff_2 input31 (.A(FINE_MUX[22]),
    .Y(net31));
 sky130_as_sc_hs__buff_2 input32 (.A(FINE_MUX[23]),
    .Y(net32));
 sky130_as_sc_hs__buff_2 input33 (.A(FINE_MUX[24]),
    .Y(net33));
 sky130_as_sc_hs__buff_2 input34 (.A(FINE_MUX[25]),
    .Y(net34));
 sky130_as_sc_hs__buff_2 input35 (.A(FINE_MUX[26]),
    .Y(net35));
 sky130_as_sc_hs__buff_2 input36 (.A(FINE_MUX[27]),
    .Y(net36));
 sky130_as_sc_hs__buff_2 input37 (.A(FINE_MUX[28]),
    .Y(net37));
 sky130_as_sc_hs__buff_2 input38 (.A(FINE_MUX[29]),
    .Y(net38));
 sky130_as_sc_hs__buff_2 input39 (.A(FINE_MUX[2]),
    .Y(net39));
 sky130_as_sc_hs__buff_2 input4 (.A(COARSE_MUX[12]),
    .Y(net4));
 sky130_as_sc_hs__buff_2 input40 (.A(FINE_MUX[30]),
    .Y(net40));
 sky130_as_sc_hs__buff_2 input41 (.A(FINE_MUX[3]),
    .Y(net41));
 sky130_as_sc_hs__buff_2 input42 (.A(FINE_MUX[4]),
    .Y(net42));
 sky130_as_sc_hs__buff_2 input43 (.A(FINE_MUX[5]),
    .Y(net43));
 sky130_as_sc_hs__buff_2 input44 (.A(FINE_MUX[6]),
    .Y(net44));
 sky130_as_sc_hs__buff_2 input45 (.A(FINE_MUX[7]),
    .Y(net45));
 sky130_as_sc_hs__buff_2 input46 (.A(FINE_MUX[8]),
    .Y(net46));
 sky130_as_sc_hs__buff_2 input47 (.A(FINE_MUX[9]),
    .Y(net47));
 sky130_as_sc_hs__buff_2 input48 (.A(INJ_EN),
    .Y(net48));
 sky130_as_sc_hs__buff_2 input49 (.A(MID_MUX[0]),
    .Y(net49));
 sky130_as_sc_hs__buff_2 input5 (.A(COARSE_MUX[13]),
    .Y(net5));
 sky130_as_sc_hs__buff_2 input50 (.A(MID_MUX[10]),
    .Y(net50));
 sky130_as_sc_hs__buff_2 input51 (.A(MID_MUX[11]),
    .Y(net51));
 sky130_as_sc_hs__buff_2 input52 (.A(MID_MUX[12]),
    .Y(net52));
 sky130_as_sc_hs__buff_2 input53 (.A(MID_MUX[13]),
    .Y(net53));
 sky130_as_sc_hs__buff_2 input54 (.A(MID_MUX[14]),
    .Y(net54));
 sky130_as_sc_hs__buff_2 input55 (.A(MID_MUX[1]),
    .Y(net55));
 sky130_as_sc_hs__buff_2 input56 (.A(MID_MUX[2]),
    .Y(net56));
 sky130_as_sc_hs__buff_2 input57 (.A(MID_MUX[3]),
    .Y(net57));
 sky130_as_sc_hs__buff_2 input58 (.A(MID_MUX[4]),
    .Y(net58));
 sky130_as_sc_hs__buff_2 input59 (.A(MID_MUX[5]),
    .Y(net59));
 sky130_as_sc_hs__buff_2 input6 (.A(COARSE_MUX[14]),
    .Y(net6));
 sky130_as_sc_hs__buff_2 input60 (.A(MID_MUX[6]),
    .Y(net60));
 sky130_as_sc_hs__buff_2 input61 (.A(MID_MUX[7]),
    .Y(net61));
 sky130_as_sc_hs__buff_2 input62 (.A(MID_MUX[8]),
    .Y(net62));
 sky130_as_sc_hs__buff_2 input63 (.A(MID_MUX[9]),
    .Y(net63));
 sky130_as_sc_hs__buff_2 input7 (.A(COARSE_MUX[1]),
    .Y(net7));
 sky130_as_sc_hs__buff_2 input8 (.A(COARSE_MUX[2]),
    .Y(net8));
 sky130_as_sc_hs__buff_2 input9 (.A(COARSE_MUX[3]),
    .Y(net9));
 sky130_as_sc_hs__buff_2 output64 (.A(net64),
    .Y(INJ_EDGE));
 sky130_as_sc_hs__buff_2 output65 (.A(net65),
    .Y(MID_OUT));
 sky130_as_sc_hs__buff_2 output66 (.A(net66),
    .Y(OUT));
 sky130_as_sc_hs__buff_2 output67 (.A(net67),
    .Y(SS_BBPD[0]));
 sky130_as_sc_hs__buff_2 output68 (.A(net68),
    .Y(SS_BBPD[1]));
 sky130_as_sc_hs__buff_2 \pll_ana.dco/_0_  (.A(\pll_ana.dco/dff_y.Q ),
    .Y(net67));
 sky130_as_sc_hs__buff_2 \pll_ana.dco/_1_  (.A(\pll_ana.dco/dff_x.Q ),
    .Y(net68));
 sky130_as_sc_hs__buff_2 \pll_ana.dco/coarse/impl_last.impl  (.A(\pll_ana.dco/coarse/FCHAIN[15] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[15] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[0].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[0].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[1] ),
    .Y(\pll_ana.dco/COARSE_OUT ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[0].impl/mid.impl  (.B(net66),
    .Y(\pll_ana.dco/coarse/stage[0].impl/PATH_0 ),
    .A(net1));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[0].impl/upp.impl  (.A(net1),
    .B(net66),
    .Y(\pll_ana.dco/coarse/FCHAIN[1] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[10].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[10].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[11] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[10] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[10].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[10] ),
    .Y(\pll_ana.dco/coarse/stage[10].impl/PATH_0 ),
    .A(net2));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[10].impl/upp.impl  (.A(net2),
    .B(\pll_ana.dco/coarse/FCHAIN[10] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[11] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[11].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[11].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[12] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[11] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[11].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[11] ),
    .Y(\pll_ana.dco/coarse/stage[11].impl/PATH_0 ),
    .A(net3));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[11].impl/upp.impl  (.A(net3),
    .B(\pll_ana.dco/coarse/FCHAIN[11] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[12] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[12].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[12].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[13] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[12] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[12].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[12] ),
    .Y(\pll_ana.dco/coarse/stage[12].impl/PATH_0 ),
    .A(net4));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[12].impl/upp.impl  (.A(net4),
    .B(\pll_ana.dco/coarse/FCHAIN[12] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[13] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[13].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[13].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[14] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[13] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[13].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[13] ),
    .Y(\pll_ana.dco/coarse/stage[13].impl/PATH_0 ),
    .A(net5));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[13].impl/upp.impl  (.A(net5),
    .B(\pll_ana.dco/coarse/FCHAIN[13] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[14] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[14].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[14].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[15] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[14] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[14].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[14] ),
    .Y(\pll_ana.dco/coarse/stage[14].impl/PATH_0 ),
    .A(net6));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[14].impl/upp.impl  (.A(net6),
    .B(\pll_ana.dco/coarse/FCHAIN[14] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[15] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[1].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[1].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[2] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[1] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[1].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[1] ),
    .Y(\pll_ana.dco/coarse/stage[1].impl/PATH_0 ),
    .A(net7));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[1].impl/upp.impl  (.A(net7),
    .B(\pll_ana.dco/coarse/FCHAIN[1] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[2] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[2].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[2].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[3] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[2] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[2].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[2] ),
    .Y(\pll_ana.dco/coarse/stage[2].impl/PATH_0 ),
    .A(net8));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[2].impl/upp.impl  (.A(net8),
    .B(\pll_ana.dco/coarse/FCHAIN[2] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[3] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[3].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[3].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[4] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[3] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[3].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[3] ),
    .Y(\pll_ana.dco/coarse/stage[3].impl/PATH_0 ),
    .A(net9));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[3].impl/upp.impl  (.A(net9),
    .B(\pll_ana.dco/coarse/FCHAIN[3] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[4] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[4].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[4].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[5] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[4] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[4].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[4] ),
    .Y(\pll_ana.dco/coarse/stage[4].impl/PATH_0 ),
    .A(net10));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[4].impl/upp.impl  (.A(net10),
    .B(\pll_ana.dco/coarse/FCHAIN[4] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[5] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[5].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[5].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[6] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[5] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[5].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[5] ),
    .Y(\pll_ana.dco/coarse/stage[5].impl/PATH_0 ),
    .A(net11));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[5].impl/upp.impl  (.A(net11),
    .B(\pll_ana.dco/coarse/FCHAIN[5] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[6] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[6].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[6].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[7] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[6] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[6].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[6] ),
    .Y(\pll_ana.dco/coarse/stage[6].impl/PATH_0 ),
    .A(net12));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[6].impl/upp.impl  (.A(net12),
    .B(\pll_ana.dco/coarse/FCHAIN[6] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[7] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[7].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[7].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[8] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[7] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[7].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[7] ),
    .Y(\pll_ana.dco/coarse/stage[7].impl/PATH_0 ),
    .A(net13));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[7].impl/upp.impl  (.A(net13),
    .B(\pll_ana.dco/coarse/FCHAIN[7] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[8] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[8].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[8].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[9] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[8] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[8].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[8] ),
    .Y(\pll_ana.dco/coarse/stage[8].impl/PATH_0 ),
    .A(net14));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[8].impl/upp.impl  (.A(net14),
    .B(\pll_ana.dco/coarse/FCHAIN[8] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[9] ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[9].impl/dwn.impl  (.A(\pll_ana.dco/coarse/stage[9].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/RCHAIN[10] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[9] ));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/coarse/stage[9].impl/mid.impl  (.B(\pll_ana.dco/coarse/FCHAIN[9] ),
    .Y(\pll_ana.dco/coarse/stage[9].impl/PATH_0 ),
    .A(net15));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/coarse/stage[9].impl/upp.impl  (.A(net15),
    .B(\pll_ana.dco/coarse/FCHAIN[9] ),
    .Y(\pll_ana.dco/coarse/FCHAIN[10] ));
 sky130_as_sc_hs__dfxtn_2 \pll_ana.dco/dff_x.impl  (.CLK(net64),
    .Q(\pll_ana.dco/dff_x.Q ),
    .D(\pll_ana.dco/SS_BBPD_WIRE[1] ));
 sky130_as_sc_hs__dfxtn_2 \pll_ana.dco/dff_y.impl  (.CLK(net64),
    .Q(\pll_ana.dco/dff_y.Q ),
    .D(\pll_ana.dco/SS_BBPD_WIRE[0] ));
 sky130_as_sc_hs__inv_6 \pll_ana.dco/fine/inv_0.impl  (.A(net65),
    .Y(\pll_ana.dco/fine/LOAD ));
 sky130_as_sc_hs__inv_6 \pll_ana.dco/fine/inv_1.impl  (.A(\pll_ana.dco/fine/LOAD ),
    .Y(\pll_ana.dco/FINE_OUT ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[0].dyn.impl  (.A(net17),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[0].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[0].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[0].inv_b.impl  (.A(net17),
    .Y(\pll_ana.dco/fine/stage[0].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[10].dyn.impl  (.A(net18),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[10].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[10].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[10].inv_b.impl  (.A(net18),
    .Y(\pll_ana.dco/fine/stage[10].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[11].dyn.impl  (.A(net19),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[11].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[11].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[11].inv_b.impl  (.A(net19),
    .Y(\pll_ana.dco/fine/stage[11].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[12].dyn.impl  (.A(net20),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[12].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[12].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[12].inv_b.impl  (.A(net20),
    .Y(\pll_ana.dco/fine/stage[12].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[13].dyn.impl  (.A(net21),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[13].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[13].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[13].inv_b.impl  (.A(net21),
    .Y(\pll_ana.dco/fine/stage[13].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[14].dyn.impl  (.A(net22),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[14].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[14].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[14].inv_b.impl  (.A(net22),
    .Y(\pll_ana.dco/fine/stage[14].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[15].dyn.impl  (.A(net23),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[15].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[15].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[15].inv_b.impl  (.A(net23),
    .Y(\pll_ana.dco/fine/stage[15].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[16].dyn.impl  (.A(net24),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[16].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[16].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[16].inv_b.impl  (.A(net24),
    .Y(\pll_ana.dco/fine/stage[16].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[17].dyn.impl  (.A(net25),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[17].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[17].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[17].inv_b.impl  (.A(net25),
    .Y(\pll_ana.dco/fine/stage[17].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[18].dyn.impl  (.A(net26),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[18].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[18].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[18].inv_b.impl  (.A(net26),
    .Y(\pll_ana.dco/fine/stage[18].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[19].dyn.impl  (.A(net27),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[19].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[19].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[19].inv_b.impl  (.A(net27),
    .Y(\pll_ana.dco/fine/stage[19].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[1].dyn.impl  (.A(net28),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[1].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[1].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[1].inv_b.impl  (.A(net28),
    .Y(\pll_ana.dco/fine/stage[1].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[20].dyn.impl  (.A(net29),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[20].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[20].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[20].inv_b.impl  (.A(net29),
    .Y(\pll_ana.dco/fine/stage[20].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[21].dyn.impl  (.A(net30),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[21].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[21].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[21].inv_b.impl  (.A(net30),
    .Y(\pll_ana.dco/fine/stage[21].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[22].dyn.impl  (.A(net31),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[22].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[22].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[22].inv_b.impl  (.A(net31),
    .Y(\pll_ana.dco/fine/stage[22].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[23].dyn.impl  (.A(net32),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[23].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[23].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[23].inv_b.impl  (.A(net32),
    .Y(\pll_ana.dco/fine/stage[23].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[24].dyn.impl  (.A(net33),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[24].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[24].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[24].inv_b.impl  (.A(net33),
    .Y(\pll_ana.dco/fine/stage[24].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[25].dyn.impl  (.A(net34),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[25].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[25].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[25].inv_b.impl  (.A(net34),
    .Y(\pll_ana.dco/fine/stage[25].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[26].dyn.impl  (.A(net35),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[26].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[26].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[26].inv_b.impl  (.A(net35),
    .Y(\pll_ana.dco/fine/stage[26].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[27].dyn.impl  (.A(net36),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[27].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[27].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[27].inv_b.impl  (.A(net36),
    .Y(\pll_ana.dco/fine/stage[27].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[28].dyn.impl  (.A(net37),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[28].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[28].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[28].inv_b.impl  (.A(net37),
    .Y(\pll_ana.dco/fine/stage[28].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[29].dyn.impl  (.A(net38),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[29].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[29].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[29].inv_b.impl  (.A(net38),
    .Y(\pll_ana.dco/fine/stage[29].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[2].dyn.impl  (.A(net39),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[2].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[2].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[2].inv_b.impl  (.A(net39),
    .Y(\pll_ana.dco/fine/stage[2].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[30].dyn.impl  (.A(net40),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[30].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[30].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[30].inv_b.impl  (.A(net40),
    .Y(\pll_ana.dco/fine/stage[30].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[3].dyn.impl  (.A(net41),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[3].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[3].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[3].inv_b.impl  (.A(net41),
    .Y(\pll_ana.dco/fine/stage[3].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[4].dyn.impl  (.A(net42),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[4].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[4].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[4].inv_b.impl  (.A(net42),
    .Y(\pll_ana.dco/fine/stage[4].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[5].dyn.impl  (.A(net43),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[5].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[5].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[5].inv_b.impl  (.A(net43),
    .Y(\pll_ana.dco/fine/stage[5].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[6].dyn.impl  (.A(net44),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[6].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[6].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[6].inv_b.impl  (.A(net44),
    .Y(\pll_ana.dco/fine/stage[6].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[7].dyn.impl  (.A(net45),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[7].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[7].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[7].inv_b.impl  (.A(net45),
    .Y(\pll_ana.dco/fine/stage[7].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[8].dyn.impl  (.A(net46),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[8].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[8].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[8].inv_b.impl  (.A(net46),
    .Y(\pll_ana.dco/fine/stage[8].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/fine/stage[9].dyn.impl  (.A(net47),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[9].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[9].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/fine/stage[9].inv_b.impl  (.A(net47),
    .Y(\pll_ana.dco/fine/stage[9].dyn.A2 ));
 sky130_as_sc_hs__inv_4 \pll_ana.dco/mid/inv_0.impl  (.A(\pll_ana.dco/COARSE_OUT ),
    .Y(\pll_ana.dco/mid/LOAD ));
 sky130_as_sc_hs__inv_4 \pll_ana.dco/mid/inv_1.impl  (.A(\pll_ana.dco/mid/LOAD ),
    .Y(net65));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[0].dyn.impl  (.A(net49),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[0].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[0].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[0].inv_b.impl  (.A(net49),
    .Y(\pll_ana.dco/mid/stage[0].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[10].dyn.impl  (.A(net50),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[10].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[10].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[10].inv_b.impl  (.A(net50),
    .Y(\pll_ana.dco/mid/stage[10].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[11].dyn.impl  (.A(net51),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[11].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[11].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[11].inv_b.impl  (.A(net51),
    .Y(\pll_ana.dco/mid/stage[11].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[12].dyn.impl  (.A(net52),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[12].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[12].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[12].inv_b.impl  (.A(net52),
    .Y(\pll_ana.dco/mid/stage[12].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[13].dyn.impl  (.A(net53),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[13].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[13].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[13].inv_b.impl  (.A(net53),
    .Y(\pll_ana.dco/mid/stage[13].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[14].dyn.impl  (.A(net54),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[14].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[14].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[14].inv_b.impl  (.A(net54),
    .Y(\pll_ana.dco/mid/stage[14].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[1].dyn.impl  (.A(net55),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[1].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[1].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[1].inv_b.impl  (.A(net55),
    .Y(\pll_ana.dco/mid/stage[1].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[2].dyn.impl  (.A(net56),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[2].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[2].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[2].inv_b.impl  (.A(net56),
    .Y(\pll_ana.dco/mid/stage[2].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[3].dyn.impl  (.A(net57),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[3].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[3].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[3].inv_b.impl  (.A(net57),
    .Y(\pll_ana.dco/mid/stage[3].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[4].dyn.impl  (.A(net58),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[4].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[4].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[4].inv_b.impl  (.A(net58),
    .Y(\pll_ana.dco/mid/stage[4].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[5].dyn.impl  (.A(net59),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[5].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[5].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[5].inv_b.impl  (.A(net59),
    .Y(\pll_ana.dco/mid/stage[5].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[6].dyn.impl  (.A(net60),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[6].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[6].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[6].inv_b.impl  (.A(net60),
    .Y(\pll_ana.dco/mid/stage[6].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[7].dyn.impl  (.A(net61),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[7].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[7].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[7].inv_b.impl  (.A(net61),
    .Y(\pll_ana.dco/mid/stage[7].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[8].dyn.impl  (.A(net62),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[8].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[8].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[8].inv_b.impl  (.A(net62),
    .Y(\pll_ana.dco/mid/stage[8].dyn.A2 ));
 sky130_as_sc_hs__nand3_2 \pll_ana.dco/mid/stage[9].dyn.impl  (.A(net63),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[9].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[9].dyn.ZN ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/mid/stage[9].inv_b.impl  (.A(net63),
    .Y(\pll_ana.dco/mid/stage[9].dyn.A2 ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/sym/inj_dummy_inv.impl  (.A(\pll_ana.dco/sym/INJ_EDGE_BALANCED ),
    .Y(\pll_ana.dco/sym/INJ_DUMMY ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/sym/inj_slope_balancer.impl  (.A(net64),
    .Y(\pll_ana.dco/sym/INJ_EDGE_BALANCED ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/sym/osc_dummy_inv.impl  (.A(\pll_ana.dco/sym/OSC_BALANCED ),
    .Y(\pll_ana.dco/sym/OSC_DUMMY ));
 sky130_as_sc_hs__inv_2 \pll_ana.dco/sym/osc_slope_balancer.impl  (.A(\pll_ana.dco/FINE_OUT ),
    .Y(\pll_ana.dco/sym/OSC_BALANCED ));
 sky130_as_sc_hs__buff_2 \pll_ana.dco/sym/ssbbpd_impl/_0_  (.A(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_y.Z ),
    .Y(\pll_ana.dco/SS_BBPD_WIRE[0] ));
 sky130_as_sc_hs__buff_2 \pll_ana.dco/sym/ssbbpd_impl/_1_  (.A(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_x.Z ),
    .Y(\pll_ana.dco/SS_BBPD_WIRE[1] ));
 sky130_as_sc_hs__buff_2 \pll_ana.dco/sym/ssbbpd_impl/buf_nand_x.impl  (.A(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDX ),
    .Y(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_x.Z ));
 sky130_as_sc_hs__buff_2 \pll_ana.dco/sym/ssbbpd_impl/buf_nand_y.impl  (.A(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDY ),
    .Y(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_y.Z ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/sym/ssbbpd_impl/nand_x.impl  (.A(\pll_ana.dco/sym/OSC_BALANCED ),
    .B(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDY ),
    .Y(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDX ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/sym/ssbbpd_impl/nand_y.impl  (.A(\pll_ana.dco/sym/INJ_EDGE_BALANCED ),
    .B(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDX ),
    .Y(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDY ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/sym/sym_mux/nand_inj.impl  (.A(\pll_ana.dco/sym/OSC_BALANCED ),
    .B(\pll_ana.dco/sym/sym_mux/DCO_EN_INJ_WIN ),
    .Y(\pll_ana.dco/sym/sym_mux/OSC_INJ ));
 sky130_as_sc_hs__nand2_2 \pll_ana.dco/sym/sym_mux/nand_pll.impl  (.A(\pll_ana.dco/sym/sym_mux/REF_INJ ),
    .B(\pll_ana.dco/sym/sym_mux/OSC_INJ ),
    .Y(net66));
 sky130_as_sc_hs__nand2b_2 \pll_ana.dco/sym/sym_mux/nand_ref.impl  (.B(\pll_ana.INJ_WIN ),
    .Y(\pll_ana.dco/sym/sym_mux/REF_INJ ),
    .A(\pll_ana.dco/sym/INJ_EDGE_BALANCED ));
 sky130_as_sc_hs__nor2b_2 \pll_ana.dco/sym/sym_mux/norb_en_inj.impl  (.A(net16),
    .Y(\pll_ana.dco/sym/sym_mux/DCO_EN_INJ_WIN ),
    .B(\pll_ana.INJ_WIN ));
 sky130_as_sc_hs__nor2_2 \pll_ana.inj/cmp_nor.cmp.impl  (.A(\pll_ana.inj/CHAIN_OUT ),
    .B(REF),
    .Y(\pll_ana.INJ_WIN ));
 sky130_as_sc_hs__nand2_2 \pll_ana.inj/cmp_nor.del_en.impl  (.A(net48),
    .B(\pll_ana.inj/cmp_nor.del_en.A1 ),
    .Y(\pll_ana.inj/CHAIN_OUT ));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[0].del_1.impl  (.A(REF),
    .Y(\pll_ana.inj/stage[0].del_1.Z ));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[0].del_2.impl  (.A(net64),
    .Y(\pll_ana.inj/stage[0].del_2.Z ));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[1].del_1.impl  (.A(\pll_ana.inj/stage[0].del_1.Z ),
    .Y(\pll_ana.inj/stage[1].del_1.Z ));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[1].del_2.impl  (.A(\pll_ana.inj/stage[0].del_2.Z ),
    .Y(\pll_ana.inj/stage[1].del_2.Z ));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[2].del_1.impl  (.A(\pll_ana.inj/stage[1].del_1.Z ),
    .Y(\pll_ana.inj/stage[2].del_1.Z ));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[2].del_2.impl  (.A(\pll_ana.inj/stage[1].del_2.Z ),
    .Y(\pll_ana.inj/stage[2].del_2.Z ));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[3].del_1.impl  (.A(\pll_ana.inj/stage[2].del_1.Z ),
    .Y(net64));
 sky130_as_sc_hs__buff_2 \pll_ana.inj/stage[3].del_2.impl  (.A(\pll_ana.inj/stage[2].del_2.Z ),
    .Y(\pll_ana.inj/cmp_nor.del_en.A1 ));
endmodule
