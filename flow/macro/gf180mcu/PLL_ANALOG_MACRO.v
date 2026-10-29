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

 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_101 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_0_104 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_0_112 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_0_14 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_18 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_26 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_61 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_0_70 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_0_84 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_0_88 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_10_118 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_10_52 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_10_68 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_10_84 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_10_92 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_11_118 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_2 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_22 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_11_49 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_11_53 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_55 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_11_67 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_11_69 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_11_72 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_11_80 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_118 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_33 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_12_41 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_49 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_12_70 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_12_78 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_12_97 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_125 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_38 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_13_47 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_13_76 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_13_80 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_82 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_13_87 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_13_95 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_13_97 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_14_107 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_14_20 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_30 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_14_37 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_39 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_14_69 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_73 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_78 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_14_90 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_15_25 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_15_27 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_15_45 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_15_67 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_15_69 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_15_72 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_15_96 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_16_103 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_16_107 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_16_109 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_16_125 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_16_30 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_16_37 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_16_61 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_16_63 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_17_19 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_17_21 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_17_36 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_17_48 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_17_70 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_17_72 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_1_19 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_21 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_32 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_1_59 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_1_63 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_1_97 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_2_103 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_113 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_2_2 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_2_24 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_2_37 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_39 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_6 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_2_61 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_2_88 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_2_96 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_3_15 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_3_24 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_3_31 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_3_63 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_3_67 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_3_69 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_3_86 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_3_94 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_3_98 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_4_101 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_113 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_4_2 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_4_30 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_34 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_4_37 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_45 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_4_6 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_4_63 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_4_71 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_5_103 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_5_35 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_5_43 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_5_58 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_5_66 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_5_72 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_5_80 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_5_89 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_6_2 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_6_32 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_6_34 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_6_4 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_6_60 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_6_76 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_6_93 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_6_97 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_19 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_21 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_7_34 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_38 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_7_63 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_67 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_69 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_7_72 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_7_74 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_7_95 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_8_101 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_8_107 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_109 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_125 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_2 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_8_34 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_8_37 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_9_2 ();
 gf180mcu_as_sc_mcu7t3v3__fill_2 FILLER_9_29 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_16 FILLER_9_42 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_9_58 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_9_66 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_9_72 ();
 gf180mcu_as_sc_mcu7t3v3__fill_1 FILLER_9_76 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_8 FILLER_9_84 ();
 gf180mcu_as_sc_mcu7t3v3__fillcap_4 FILLER_9_92 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_0_Left_18 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_0_Right_0 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_10_Left_28 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_10_Right_10 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_11_Left_29 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_11_Right_11 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_12_Left_30 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_12_Right_12 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_13_Left_31 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_13_Right_13 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_14_Left_32 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_14_Right_14 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_15_Left_33 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_15_Right_15 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_16_Left_34 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_16_Right_16 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_17_Left_35 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_17_Right_17 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_1_Left_19 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_1_Right_1 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_2_Left_20 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_2_Right_2 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_3_Left_21 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_3_Right_3 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_4_Left_22 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_4_Right_4 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_5_Left_23 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_5_Right_5 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_6_Left_24 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_6_Right_6 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_7_Left_25 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_7_Right_7 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_8_Left_26 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_8_Right_8 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_9_Left_27 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 PHY_EDGE_ROW_9_Right_9 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_36 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_37 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_0_38 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_10_52 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_10_53 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_11_54 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_12_55 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_12_56 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_13_57 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_14_58 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_14_59 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_15_60 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_16_61 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_16_62 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_17_63 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_17_64 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_17_65 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_1_39 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_2_40 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_2_41 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_3_42 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_4_43 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_4_44 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_5_45 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_6_46 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_6_47 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_7_48 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_8_49 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_8_50 ();
 gf180mcu_as_sc_mcu7t3v3__tap_2 TAP_TAPCELL_ROW_9_51 ();
 gf180mcu_as_sc_mcu7t3v3__buff_2 input1 (.A(COARSE_MUX[0]),
    .Y(net1));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input10 (.A(COARSE_MUX[4]),
    .Y(net10));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input11 (.A(COARSE_MUX[5]),
    .Y(net11));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input12 (.A(COARSE_MUX[6]),
    .Y(net12));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input13 (.A(COARSE_MUX[7]),
    .Y(net13));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input14 (.A(COARSE_MUX[8]),
    .Y(net14));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input15 (.A(COARSE_MUX[9]),
    .Y(net15));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input16 (.A(DCO_EN),
    .Y(net16));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input17 (.A(FINE_MUX[0]),
    .Y(net17));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input18 (.A(FINE_MUX[10]),
    .Y(net18));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input19 (.A(FINE_MUX[11]),
    .Y(net19));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input2 (.A(COARSE_MUX[10]),
    .Y(net2));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input20 (.A(FINE_MUX[12]),
    .Y(net20));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input21 (.A(FINE_MUX[13]),
    .Y(net21));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input22 (.A(FINE_MUX[14]),
    .Y(net22));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input23 (.A(FINE_MUX[15]),
    .Y(net23));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input24 (.A(FINE_MUX[16]),
    .Y(net24));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input25 (.A(FINE_MUX[17]),
    .Y(net25));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input26 (.A(FINE_MUX[18]),
    .Y(net26));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input27 (.A(FINE_MUX[19]),
    .Y(net27));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input28 (.A(FINE_MUX[1]),
    .Y(net28));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input29 (.A(FINE_MUX[20]),
    .Y(net29));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input3 (.A(COARSE_MUX[11]),
    .Y(net3));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input30 (.A(FINE_MUX[21]),
    .Y(net30));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input31 (.A(FINE_MUX[22]),
    .Y(net31));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input32 (.A(FINE_MUX[23]),
    .Y(net32));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input33 (.A(FINE_MUX[24]),
    .Y(net33));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input34 (.A(FINE_MUX[25]),
    .Y(net34));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input35 (.A(FINE_MUX[26]),
    .Y(net35));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input36 (.A(FINE_MUX[27]),
    .Y(net36));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input37 (.A(FINE_MUX[28]),
    .Y(net37));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input38 (.A(FINE_MUX[29]),
    .Y(net38));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input39 (.A(FINE_MUX[2]),
    .Y(net39));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input4 (.A(COARSE_MUX[12]),
    .Y(net4));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input40 (.A(FINE_MUX[30]),
    .Y(net40));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input41 (.A(FINE_MUX[3]),
    .Y(net41));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input42 (.A(FINE_MUX[4]),
    .Y(net42));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input43 (.A(FINE_MUX[5]),
    .Y(net43));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input44 (.A(FINE_MUX[6]),
    .Y(net44));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input45 (.A(FINE_MUX[7]),
    .Y(net45));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input46 (.A(FINE_MUX[8]),
    .Y(net46));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input47 (.A(FINE_MUX[9]),
    .Y(net47));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input48 (.A(INJ_EN),
    .Y(net48));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input49 (.A(MID_MUX[0]),
    .Y(net49));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input5 (.A(COARSE_MUX[13]),
    .Y(net5));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input50 (.A(MID_MUX[10]),
    .Y(net50));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input51 (.A(MID_MUX[11]),
    .Y(net51));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input52 (.A(MID_MUX[12]),
    .Y(net52));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input53 (.A(MID_MUX[13]),
    .Y(net53));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input54 (.A(MID_MUX[14]),
    .Y(net54));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input55 (.A(MID_MUX[1]),
    .Y(net55));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input56 (.A(MID_MUX[2]),
    .Y(net56));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input57 (.A(MID_MUX[3]),
    .Y(net57));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input58 (.A(MID_MUX[4]),
    .Y(net58));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input59 (.A(MID_MUX[5]),
    .Y(net59));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input6 (.A(COARSE_MUX[14]),
    .Y(net6));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input60 (.A(MID_MUX[6]),
    .Y(net60));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input61 (.A(MID_MUX[7]),
    .Y(net61));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input62 (.A(MID_MUX[8]),
    .Y(net62));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input63 (.A(MID_MUX[9]),
    .Y(net63));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input7 (.A(COARSE_MUX[1]),
    .Y(net7));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input8 (.A(COARSE_MUX[2]),
    .Y(net8));
 gf180mcu_as_sc_mcu7t3v3__buff_2 input9 (.A(COARSE_MUX[3]),
    .Y(net9));
 gf180mcu_as_sc_mcu7t3v3__buff_2 output64 (.A(net64),
    .Y(INJ_EDGE));
 gf180mcu_as_sc_mcu7t3v3__buff_2 output65 (.A(net65),
    .Y(MID_OUT));
 gf180mcu_as_sc_mcu7t3v3__buff_2 output66 (.A(net66),
    .Y(OUT));
 gf180mcu_as_sc_mcu7t3v3__buff_2 output67 (.A(net67),
    .Y(SS_BBPD[0]));
 gf180mcu_as_sc_mcu7t3v3__buff_2 output68 (.A(net68),
    .Y(SS_BBPD[1]));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.dco/_0_  (.A(\pll_ana.dco/dff_y.Q ),
    .Y(net67));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.dco/_1_  (.A(\pll_ana.dco/dff_x.Q ),
    .Y(net68));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.dco/coarse/impl_last.impl  (.A(\pll_ana.dco/coarse/FCHAIN[15] ),
    .Y(\pll_ana.dco/coarse/RCHAIN[15] ));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[0].impl/dwn.impl  (.Y(\pll_ana.dco/COARSE_OUT ),
    .B(\pll_ana.dco/coarse/RCHAIN[1] ),
    .A(\pll_ana.dco/coarse/stage[0].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[0].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[0].impl/PATH_0 ),
    .B(net66),
    .A(net1));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[0].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[1] ),
    .B(net66),
    .A(net1));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[10].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[10] ),
    .B(\pll_ana.dco/coarse/RCHAIN[11] ),
    .A(\pll_ana.dco/coarse/stage[10].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[10].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[10].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[10] ),
    .A(net2));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[10].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[11] ),
    .B(\pll_ana.dco/coarse/FCHAIN[10] ),
    .A(net2));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[11].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[11] ),
    .B(\pll_ana.dco/coarse/RCHAIN[12] ),
    .A(\pll_ana.dco/coarse/stage[11].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[11].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[11].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[11] ),
    .A(net3));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[11].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[12] ),
    .B(\pll_ana.dco/coarse/FCHAIN[11] ),
    .A(net3));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[12].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[12] ),
    .B(\pll_ana.dco/coarse/RCHAIN[13] ),
    .A(\pll_ana.dco/coarse/stage[12].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[12].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[12].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[12] ),
    .A(net4));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[12].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[13] ),
    .B(\pll_ana.dco/coarse/FCHAIN[12] ),
    .A(net4));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[13].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[13] ),
    .B(\pll_ana.dco/coarse/RCHAIN[14] ),
    .A(\pll_ana.dco/coarse/stage[13].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[13].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[13].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[13] ),
    .A(net5));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[13].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[14] ),
    .B(\pll_ana.dco/coarse/FCHAIN[13] ),
    .A(net5));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[14].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[14] ),
    .B(\pll_ana.dco/coarse/RCHAIN[15] ),
    .A(\pll_ana.dco/coarse/stage[14].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[14].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[14].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[14] ),
    .A(net6));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[14].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[15] ),
    .B(\pll_ana.dco/coarse/FCHAIN[14] ),
    .A(net6));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[1].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[1] ),
    .B(\pll_ana.dco/coarse/RCHAIN[2] ),
    .A(\pll_ana.dco/coarse/stage[1].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[1].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[1].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[1] ),
    .A(net7));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[1].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[2] ),
    .B(\pll_ana.dco/coarse/FCHAIN[1] ),
    .A(net7));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[2].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[2] ),
    .B(\pll_ana.dco/coarse/RCHAIN[3] ),
    .A(\pll_ana.dco/coarse/stage[2].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[2].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[2].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[2] ),
    .A(net8));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[2].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[3] ),
    .B(\pll_ana.dco/coarse/FCHAIN[2] ),
    .A(net8));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[3].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[3] ),
    .B(\pll_ana.dco/coarse/RCHAIN[4] ),
    .A(\pll_ana.dco/coarse/stage[3].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[3].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[3].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[3] ),
    .A(net9));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[3].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[4] ),
    .B(\pll_ana.dco/coarse/FCHAIN[3] ),
    .A(net9));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[4].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[4] ),
    .B(\pll_ana.dco/coarse/RCHAIN[5] ),
    .A(\pll_ana.dco/coarse/stage[4].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[4].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[4].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[4] ),
    .A(net10));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[4].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[5] ),
    .B(\pll_ana.dco/coarse/FCHAIN[4] ),
    .A(net10));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[5].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[5] ),
    .B(\pll_ana.dco/coarse/RCHAIN[6] ),
    .A(\pll_ana.dco/coarse/stage[5].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[5].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[5].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[5] ),
    .A(net11));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[5].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[6] ),
    .B(\pll_ana.dco/coarse/FCHAIN[5] ),
    .A(net11));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[6].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[6] ),
    .B(\pll_ana.dco/coarse/RCHAIN[7] ),
    .A(\pll_ana.dco/coarse/stage[6].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[6].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[6].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[6] ),
    .A(net12));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[6].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[7] ),
    .B(\pll_ana.dco/coarse/FCHAIN[6] ),
    .A(net12));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[7].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[7] ),
    .B(\pll_ana.dco/coarse/RCHAIN[8] ),
    .A(\pll_ana.dco/coarse/stage[7].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[7].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[7].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[7] ),
    .A(net13));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[7].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[8] ),
    .B(\pll_ana.dco/coarse/FCHAIN[7] ),
    .A(net13));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[8].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[8] ),
    .B(\pll_ana.dco/coarse/RCHAIN[9] ),
    .A(\pll_ana.dco/coarse/stage[8].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[8].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[8].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[8] ),
    .A(net14));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[8].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[9] ),
    .B(\pll_ana.dco/coarse/FCHAIN[8] ),
    .A(net14));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[9].impl/dwn.impl  (.Y(\pll_ana.dco/coarse/RCHAIN[9] ),
    .B(\pll_ana.dco/coarse/RCHAIN[10] ),
    .A(\pll_ana.dco/coarse/stage[9].impl/PATH_0 ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/coarse/stage[9].impl/mid.impl  (.Y(\pll_ana.dco/coarse/stage[9].impl/PATH_0 ),
    .B(\pll_ana.dco/coarse/FCHAIN[9] ),
    .A(net15));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/coarse/stage[9].impl/upp.impl  (.Y(\pll_ana.dco/coarse/FCHAIN[10] ),
    .B(\pll_ana.dco/coarse/FCHAIN[9] ),
    .A(net15));
 gf180mcu_as_sc_mcu7t3v3__dfxtn_2 \pll_ana.dco/dff_x.impl  (.CLK(net64),
    .D(\pll_ana.dco/SS_BBPD_WIRE[1] ),
    .Q(\pll_ana.dco/dff_x.Q ));
 gf180mcu_as_sc_mcu7t3v3__dfxtn_2 \pll_ana.dco/dff_y.impl  (.CLK(net64),
    .D(\pll_ana.dco/SS_BBPD_WIRE[0] ),
    .Q(\pll_ana.dco/dff_y.Q ));
 gf180mcu_as_sc_mcu7t3v3__inv_6 \pll_ana.dco/fine/inv_0.impl  (.Y(\pll_ana.dco/fine/LOAD ),
    .A(net65));
 gf180mcu_as_sc_mcu7t3v3__inv_6 \pll_ana.dco/fine/inv_1.impl  (.Y(\pll_ana.dco/FINE_OUT ),
    .A(\pll_ana.dco/fine/LOAD ));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[0].dyn.impl  (.A(net17),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[0].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[0].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[0].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[0].dyn.A2 ),
    .A(net17));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[10].dyn.impl  (.A(net18),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[10].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[10].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[10].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[10].dyn.A2 ),
    .A(net18));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[11].dyn.impl  (.A(net19),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[11].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[11].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[11].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[11].dyn.A2 ),
    .A(net19));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[12].dyn.impl  (.A(net20),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[12].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[12].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[12].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[12].dyn.A2 ),
    .A(net20));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[13].dyn.impl  (.A(net21),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[13].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[13].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[13].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[13].dyn.A2 ),
    .A(net21));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[14].dyn.impl  (.A(net22),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[14].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[14].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[14].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[14].dyn.A2 ),
    .A(net22));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[15].dyn.impl  (.A(net23),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[15].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[15].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[15].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[15].dyn.A2 ),
    .A(net23));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[16].dyn.impl  (.A(net24),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[16].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[16].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[16].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[16].dyn.A2 ),
    .A(net24));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[17].dyn.impl  (.A(net25),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[17].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[17].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[17].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[17].dyn.A2 ),
    .A(net25));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[18].dyn.impl  (.A(net26),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[18].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[18].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[18].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[18].dyn.A2 ),
    .A(net26));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[19].dyn.impl  (.A(net27),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[19].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[19].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[19].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[19].dyn.A2 ),
    .A(net27));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[1].dyn.impl  (.A(net28),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[1].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[1].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[1].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[1].dyn.A2 ),
    .A(net28));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[20].dyn.impl  (.A(net29),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[20].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[20].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[20].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[20].dyn.A2 ),
    .A(net29));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[21].dyn.impl  (.A(net30),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[21].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[21].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[21].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[21].dyn.A2 ),
    .A(net30));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[22].dyn.impl  (.A(net31),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[22].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[22].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[22].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[22].dyn.A2 ),
    .A(net31));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[23].dyn.impl  (.A(net32),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[23].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[23].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[23].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[23].dyn.A2 ),
    .A(net32));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[24].dyn.impl  (.A(net33),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[24].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[24].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[24].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[24].dyn.A2 ),
    .A(net33));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[25].dyn.impl  (.A(net34),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[25].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[25].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[25].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[25].dyn.A2 ),
    .A(net34));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[26].dyn.impl  (.A(net35),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[26].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[26].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[26].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[26].dyn.A2 ),
    .A(net35));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[27].dyn.impl  (.A(net36),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[27].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[27].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[27].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[27].dyn.A2 ),
    .A(net36));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[28].dyn.impl  (.A(net37),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[28].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[28].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[28].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[28].dyn.A2 ),
    .A(net37));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[29].dyn.impl  (.A(net38),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[29].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[29].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[29].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[29].dyn.A2 ),
    .A(net38));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[2].dyn.impl  (.A(net39),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[2].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[2].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[2].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[2].dyn.A2 ),
    .A(net39));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[30].dyn.impl  (.A(net40),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[30].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[30].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[30].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[30].dyn.A2 ),
    .A(net40));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[3].dyn.impl  (.A(net41),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[3].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[3].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[3].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[3].dyn.A2 ),
    .A(net41));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[4].dyn.impl  (.A(net42),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[4].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[4].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[4].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[4].dyn.A2 ),
    .A(net42));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[5].dyn.impl  (.A(net43),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[5].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[5].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[5].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[5].dyn.A2 ),
    .A(net43));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[6].dyn.impl  (.A(net44),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[6].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[6].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[6].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[6].dyn.A2 ),
    .A(net44));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[7].dyn.impl  (.A(net45),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[7].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[7].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[7].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[7].dyn.A2 ),
    .A(net45));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[8].dyn.impl  (.A(net46),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[8].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[8].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[8].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[8].dyn.A2 ),
    .A(net46));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/fine/stage[9].dyn.impl  (.A(net47),
    .B(\pll_ana.dco/fine/LOAD ),
    .C(\pll_ana.dco/fine/stage[9].dyn.A2 ),
    .Y(\pll_ana.dco/fine/stage[9].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/fine/stage[9].inv_b.impl  (.Y(\pll_ana.dco/fine/stage[9].dyn.A2 ),
    .A(net47));
 gf180mcu_as_sc_mcu7t3v3__inv_4 \pll_ana.dco/mid/inv_0.impl  (.Y(\pll_ana.dco/mid/LOAD ),
    .A(\pll_ana.dco/COARSE_OUT ));
 gf180mcu_as_sc_mcu7t3v3__inv_4 \pll_ana.dco/mid/inv_1.impl  (.Y(net65),
    .A(\pll_ana.dco/mid/LOAD ));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[0].dyn.impl  (.A(net49),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[0].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[0].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[0].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[0].dyn.A2 ),
    .A(net49));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[10].dyn.impl  (.A(net50),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[10].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[10].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[10].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[10].dyn.A2 ),
    .A(net50));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[11].dyn.impl  (.A(net51),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[11].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[11].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[11].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[11].dyn.A2 ),
    .A(net51));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[12].dyn.impl  (.A(net52),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[12].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[12].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[12].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[12].dyn.A2 ),
    .A(net52));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[13].dyn.impl  (.A(net53),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[13].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[13].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[13].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[13].dyn.A2 ),
    .A(net53));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[14].dyn.impl  (.A(net54),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[14].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[14].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[14].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[14].dyn.A2 ),
    .A(net54));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[1].dyn.impl  (.A(net55),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[1].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[1].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[1].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[1].dyn.A2 ),
    .A(net55));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[2].dyn.impl  (.A(net56),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[2].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[2].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[2].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[2].dyn.A2 ),
    .A(net56));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[3].dyn.impl  (.A(net57),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[3].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[3].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[3].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[3].dyn.A2 ),
    .A(net57));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[4].dyn.impl  (.A(net58),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[4].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[4].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[4].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[4].dyn.A2 ),
    .A(net58));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[5].dyn.impl  (.A(net59),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[5].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[5].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[5].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[5].dyn.A2 ),
    .A(net59));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[6].dyn.impl  (.A(net60),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[6].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[6].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[6].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[6].dyn.A2 ),
    .A(net60));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[7].dyn.impl  (.A(net61),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[7].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[7].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[7].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[7].dyn.A2 ),
    .A(net61));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[8].dyn.impl  (.A(net62),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[8].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[8].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[8].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[8].dyn.A2 ),
    .A(net62));
 gf180mcu_as_sc_mcu7t3v3__nand3_2 \pll_ana.dco/mid/stage[9].dyn.impl  (.A(net63),
    .B(\pll_ana.dco/mid/LOAD ),
    .C(\pll_ana.dco/mid/stage[9].dyn.A2 ),
    .Y(\pll_ana.dco/mid/stage[9].dyn.ZN ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/mid/stage[9].inv_b.impl  (.Y(\pll_ana.dco/mid/stage[9].dyn.A2 ),
    .A(net63));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/sym/inj_dummy_inv.impl  (.Y(\pll_ana.dco/sym/INJ_DUMMY ),
    .A(\pll_ana.dco/sym/INJ_EDGE_BALANCED ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/sym/inj_slope_balancer.impl  (.Y(\pll_ana.dco/sym/INJ_EDGE_BALANCED ),
    .A(net64));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/sym/osc_dummy_inv.impl  (.Y(\pll_ana.dco/sym/OSC_DUMMY ),
    .A(\pll_ana.dco/sym/OSC_BALANCED ));
 gf180mcu_as_sc_mcu7t3v3__inv_2 \pll_ana.dco/sym/osc_slope_balancer.impl  (.Y(\pll_ana.dco/sym/OSC_BALANCED ),
    .A(\pll_ana.dco/FINE_OUT ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.dco/sym/ssbbpd_impl/_0_  (.A(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_y.Z ),
    .Y(\pll_ana.dco/SS_BBPD_WIRE[0] ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.dco/sym/ssbbpd_impl/_1_  (.A(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_x.Z ),
    .Y(\pll_ana.dco/SS_BBPD_WIRE[1] ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.dco/sym/ssbbpd_impl/buf_nand_x.impl  (.A(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDX ),
    .Y(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_x.Z ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.dco/sym/ssbbpd_impl/buf_nand_y.impl  (.A(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDY ),
    .Y(\pll_ana.dco/sym/ssbbpd_impl/buf_nand_y.Z ));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/sym/ssbbpd_impl/nand_x.impl  (.Y(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDX ),
    .B(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDY ),
    .A(\pll_ana.dco/sym/OSC_BALANCED ));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/sym/ssbbpd_impl/nand_y.impl  (.Y(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDY ),
    .B(\pll_ana.dco/sym/ssbbpd_impl/OUT_NANDX ),
    .A(\pll_ana.dco/sym/INJ_EDGE_BALANCED ));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/sym/sym_mux/nand_inj.impl  (.Y(\pll_ana.dco/sym/sym_mux/OSC_INJ ),
    .B(\pll_ana.dco/sym/sym_mux/DCO_EN_INJ_WIN ),
    .A(\pll_ana.dco/sym/OSC_BALANCED ));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.dco/sym/sym_mux/nand_pll.impl  (.Y(net66),
    .B(\pll_ana.dco/sym/sym_mux/OSC_INJ ),
    .A(\pll_ana.dco/sym/sym_mux/REF_INJ ));
 gf180mcu_as_sc_mcu7t3v3__nand2b_2 \pll_ana.dco/sym/sym_mux/nand_ref.impl  (.Y(\pll_ana.dco/sym/sym_mux/REF_INJ ),
    .B(\pll_ana.INJ_WIN ),
    .A(\pll_ana.dco/sym/INJ_EDGE_BALANCED ));
 gf180mcu_as_sc_mcu7t3v3__nor2b_2 \pll_ana.dco/sym/sym_mux/norb_en_inj.impl  (.Y(\pll_ana.dco/sym/sym_mux/DCO_EN_INJ_WIN ),
    .B(\pll_ana.INJ_WIN ),
    .A(net16));
 gf180mcu_as_sc_mcu7t3v3__nor2_2 \pll_ana.inj/cmp_nor.cmp.impl  (.Y(\pll_ana.INJ_WIN ),
    .B(REF),
    .A(\pll_ana.inj/CHAIN_OUT ));
 gf180mcu_as_sc_mcu7t3v3__nand2_2 \pll_ana.inj/cmp_nor.del_en.impl  (.Y(\pll_ana.inj/CHAIN_OUT ),
    .B(\pll_ana.inj/cmp_nor.del_en.A1 ),
    .A(net48));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[0].del_1.impl  (.A(REF),
    .Y(\pll_ana.inj/stage[0].del_1.Z ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[0].del_2.impl  (.A(net64),
    .Y(\pll_ana.inj/stage[0].del_2.Z ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[1].del_1.impl  (.A(\pll_ana.inj/stage[0].del_1.Z ),
    .Y(\pll_ana.inj/stage[1].del_1.Z ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[1].del_2.impl  (.A(\pll_ana.inj/stage[0].del_2.Z ),
    .Y(\pll_ana.inj/stage[1].del_2.Z ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[2].del_1.impl  (.A(\pll_ana.inj/stage[1].del_1.Z ),
    .Y(\pll_ana.inj/stage[2].del_1.Z ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[2].del_2.impl  (.A(\pll_ana.inj/stage[1].del_2.Z ),
    .Y(\pll_ana.inj/stage[2].del_2.Z ));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[3].del_1.impl  (.A(\pll_ana.inj/stage[2].del_1.Z ),
    .Y(net64));
 gf180mcu_as_sc_mcu7t3v3__buff_2 \pll_ana.inj/stage[3].del_2.impl  (.A(\pll_ana.inj/stage[2].del_2.Z ),
    .Y(\pll_ana.inj/cmp_nor.del_en.A1 ));
endmodule
