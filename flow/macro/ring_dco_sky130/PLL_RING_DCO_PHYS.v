module PLL_RING_DCO_PHYS (DCO_EN,
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
 wire net63;
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
 wire net64;
 wire net65;
 wire net66;
 wire net67;
 wire \ring.COARSE_OUT ;
 wire \ring.DCO_IN ;
 wire \ring.FINE_OUT ;
 wire \ring.base_delay.stage[0].delay_cell.Z ;
 wire \ring.base_delay.stage[100].delay_cell.I ;
 wire \ring.base_delay.stage[100].delay_cell.Z ;
 wire \ring.base_delay.stage[101].delay_cell.Z ;
 wire \ring.base_delay.stage[102].delay_cell.Z ;
 wire \ring.base_delay.stage[103].delay_cell.Z ;
 wire \ring.base_delay.stage[104].delay_cell.Z ;
 wire \ring.base_delay.stage[105].delay_cell.Z ;
 wire \ring.base_delay.stage[106].delay_cell.Z ;
 wire \ring.base_delay.stage[107].delay_cell.Z ;
 wire \ring.base_delay.stage[108].delay_cell.Z ;
 wire \ring.base_delay.stage[109].delay_cell.Z ;
 wire \ring.base_delay.stage[10].delay_cell.I ;
 wire \ring.base_delay.stage[10].delay_cell.Z ;
 wire \ring.base_delay.stage[110].delay_cell.Z ;
 wire \ring.base_delay.stage[111].delay_cell.Z ;
 wire \ring.base_delay.stage[112].delay_cell.Z ;
 wire \ring.base_delay.stage[113].delay_cell.Z ;
 wire \ring.base_delay.stage[114].delay_cell.Z ;
 wire \ring.base_delay.stage[115].delay_cell.Z ;
 wire \ring.base_delay.stage[116].delay_cell.Z ;
 wire \ring.base_delay.stage[117].delay_cell.Z ;
 wire \ring.base_delay.stage[118].delay_cell.Z ;
 wire \ring.base_delay.stage[119].delay_cell.Z ;
 wire \ring.base_delay.stage[11].delay_cell.Z ;
 wire \ring.base_delay.stage[120].delay_cell.Z ;
 wire \ring.base_delay.stage[121].delay_cell.Z ;
 wire \ring.base_delay.stage[122].delay_cell.Z ;
 wire \ring.base_delay.stage[123].delay_cell.Z ;
 wire \ring.base_delay.stage[124].delay_cell.Z ;
 wire \ring.base_delay.stage[125].delay_cell.Z ;
 wire \ring.base_delay.stage[126].delay_cell.Z ;
 wire \ring.base_delay.stage[127].delay_cell.Z ;
 wire \ring.base_delay.stage[128].delay_cell.Z ;
 wire \ring.base_delay.stage[129].delay_cell.Z ;
 wire \ring.base_delay.stage[12].delay_cell.Z ;
 wire \ring.base_delay.stage[130].delay_cell.Z ;
 wire \ring.base_delay.stage[131].delay_cell.Z ;
 wire \ring.base_delay.stage[132].delay_cell.Z ;
 wire \ring.base_delay.stage[133].delay_cell.Z ;
 wire \ring.base_delay.stage[134].delay_cell.Z ;
 wire \ring.base_delay.stage[135].delay_cell.Z ;
 wire \ring.base_delay.stage[136].delay_cell.Z ;
 wire \ring.base_delay.stage[137].delay_cell.Z ;
 wire \ring.base_delay.stage[138].delay_cell.Z ;
 wire \ring.base_delay.stage[139].delay_cell.Z ;
 wire \ring.base_delay.stage[13].delay_cell.Z ;
 wire \ring.base_delay.stage[140].delay_cell.Z ;
 wire \ring.base_delay.stage[141].delay_cell.Z ;
 wire \ring.base_delay.stage[142].delay_cell.Z ;
 wire \ring.base_delay.stage[143].delay_cell.Z ;
 wire \ring.base_delay.stage[144].delay_cell.Z ;
 wire \ring.base_delay.stage[145].delay_cell.Z ;
 wire \ring.base_delay.stage[146].delay_cell.Z ;
 wire \ring.base_delay.stage[147].delay_cell.Z ;
 wire \ring.base_delay.stage[148].delay_cell.Z ;
 wire \ring.base_delay.stage[149].delay_cell.Z ;
 wire \ring.base_delay.stage[14].delay_cell.Z ;
 wire \ring.base_delay.stage[150].delay_cell.Z ;
 wire \ring.base_delay.stage[151].delay_cell.Z ;
 wire \ring.base_delay.stage[152].delay_cell.Z ;
 wire \ring.base_delay.stage[153].delay_cell.Z ;
 wire \ring.base_delay.stage[154].delay_cell.Z ;
 wire \ring.base_delay.stage[155].delay_cell.Z ;
 wire \ring.base_delay.stage[156].delay_cell.Z ;
 wire \ring.base_delay.stage[157].delay_cell.Z ;
 wire \ring.base_delay.stage[158].delay_cell.Z ;
 wire \ring.base_delay.stage[159].delay_cell.Z ;
 wire \ring.base_delay.stage[15].delay_cell.Z ;
 wire \ring.base_delay.stage[160].delay_cell.Z ;
 wire \ring.base_delay.stage[161].delay_cell.Z ;
 wire \ring.base_delay.stage[162].delay_cell.Z ;
 wire \ring.base_delay.stage[163].delay_cell.Z ;
 wire \ring.base_delay.stage[164].delay_cell.Z ;
 wire \ring.base_delay.stage[165].delay_cell.Z ;
 wire \ring.base_delay.stage[166].delay_cell.Z ;
 wire \ring.base_delay.stage[167].delay_cell.Z ;
 wire \ring.base_delay.stage[168].delay_cell.Z ;
 wire \ring.base_delay.stage[169].delay_cell.Z ;
 wire \ring.base_delay.stage[16].delay_cell.Z ;
 wire \ring.base_delay.stage[170].delay_cell.Z ;
 wire \ring.base_delay.stage[171].delay_cell.Z ;
 wire \ring.base_delay.stage[172].delay_cell.Z ;
 wire \ring.base_delay.stage[173].delay_cell.Z ;
 wire \ring.base_delay.stage[174].delay_cell.Z ;
 wire \ring.base_delay.stage[175].delay_cell.Z ;
 wire \ring.base_delay.stage[176].delay_cell.Z ;
 wire \ring.base_delay.stage[177].delay_cell.Z ;
 wire \ring.base_delay.stage[178].delay_cell.Z ;
 wire \ring.base_delay.stage[179].delay_cell.Z ;
 wire \ring.base_delay.stage[17].delay_cell.Z ;
 wire \ring.base_delay.stage[180].delay_cell.Z ;
 wire \ring.base_delay.stage[181].delay_cell.Z ;
 wire \ring.base_delay.stage[182].delay_cell.Z ;
 wire \ring.base_delay.stage[183].delay_cell.Z ;
 wire \ring.base_delay.stage[184].delay_cell.Z ;
 wire \ring.base_delay.stage[185].delay_cell.Z ;
 wire \ring.base_delay.stage[186].delay_cell.Z ;
 wire \ring.base_delay.stage[187].delay_cell.Z ;
 wire \ring.base_delay.stage[188].delay_cell.Z ;
 wire \ring.base_delay.stage[189].delay_cell.Z ;
 wire \ring.base_delay.stage[18].delay_cell.Z ;
 wire \ring.base_delay.stage[190].delay_cell.Z ;
 wire \ring.base_delay.stage[191].delay_cell.Z ;
 wire \ring.base_delay.stage[192].delay_cell.Z ;
 wire \ring.base_delay.stage[193].delay_cell.Z ;
 wire \ring.base_delay.stage[194].delay_cell.Z ;
 wire \ring.base_delay.stage[195].delay_cell.Z ;
 wire \ring.base_delay.stage[196].delay_cell.Z ;
 wire \ring.base_delay.stage[197].delay_cell.Z ;
 wire \ring.base_delay.stage[198].delay_cell.Z ;
 wire \ring.base_delay.stage[199].delay_cell.Z ;
 wire \ring.base_delay.stage[19].delay_cell.Z ;
 wire \ring.base_delay.stage[1].delay_cell.Z ;
 wire \ring.base_delay.stage[200].delay_cell.Z ;
 wire \ring.base_delay.stage[201].delay_cell.Z ;
 wire \ring.base_delay.stage[202].delay_cell.Z ;
 wire \ring.base_delay.stage[203].delay_cell.Z ;
 wire \ring.base_delay.stage[204].delay_cell.Z ;
 wire \ring.base_delay.stage[205].delay_cell.Z ;
 wire \ring.base_delay.stage[206].delay_cell.Z ;
 wire \ring.base_delay.stage[207].delay_cell.Z ;
 wire \ring.base_delay.stage[208].delay_cell.Z ;
 wire \ring.base_delay.stage[209].delay_cell.Z ;
 wire \ring.base_delay.stage[20].delay_cell.Z ;
 wire \ring.base_delay.stage[210].delay_cell.Z ;
 wire \ring.base_delay.stage[211].delay_cell.Z ;
 wire \ring.base_delay.stage[212].delay_cell.Z ;
 wire \ring.base_delay.stage[213].delay_cell.Z ;
 wire \ring.base_delay.stage[214].delay_cell.Z ;
 wire \ring.base_delay.stage[215].delay_cell.Z ;
 wire \ring.base_delay.stage[216].delay_cell.Z ;
 wire \ring.base_delay.stage[217].delay_cell.Z ;
 wire \ring.base_delay.stage[218].delay_cell.Z ;
 wire \ring.base_delay.stage[219].delay_cell.Z ;
 wire \ring.base_delay.stage[21].delay_cell.Z ;
 wire \ring.base_delay.stage[220].delay_cell.Z ;
 wire \ring.base_delay.stage[221].delay_cell.Z ;
 wire \ring.base_delay.stage[222].delay_cell.Z ;
 wire \ring.base_delay.stage[223].delay_cell.Z ;
 wire \ring.base_delay.stage[224].delay_cell.Z ;
 wire \ring.base_delay.stage[225].delay_cell.Z ;
 wire \ring.base_delay.stage[226].delay_cell.Z ;
 wire \ring.base_delay.stage[227].delay_cell.Z ;
 wire \ring.base_delay.stage[228].delay_cell.Z ;
 wire \ring.base_delay.stage[229].delay_cell.Z ;
 wire \ring.base_delay.stage[22].delay_cell.Z ;
 wire \ring.base_delay.stage[230].delay_cell.Z ;
 wire \ring.base_delay.stage[231].delay_cell.Z ;
 wire \ring.base_delay.stage[232].delay_cell.Z ;
 wire \ring.base_delay.stage[233].delay_cell.Z ;
 wire \ring.base_delay.stage[234].delay_cell.Z ;
 wire \ring.base_delay.stage[235].delay_cell.Z ;
 wire \ring.base_delay.stage[236].delay_cell.Z ;
 wire \ring.base_delay.stage[237].delay_cell.Z ;
 wire \ring.base_delay.stage[238].delay_cell.Z ;
 wire \ring.base_delay.stage[239].delay_cell.Z ;
 wire \ring.base_delay.stage[23].delay_cell.Z ;
 wire \ring.base_delay.stage[240].delay_cell.Z ;
 wire \ring.base_delay.stage[241].delay_cell.Z ;
 wire \ring.base_delay.stage[242].delay_cell.Z ;
 wire \ring.base_delay.stage[243].delay_cell.Z ;
 wire \ring.base_delay.stage[244].delay_cell.Z ;
 wire \ring.base_delay.stage[245].delay_cell.Z ;
 wire \ring.base_delay.stage[246].delay_cell.Z ;
 wire \ring.base_delay.stage[247].delay_cell.Z ;
 wire \ring.base_delay.stage[248].delay_cell.Z ;
 wire \ring.base_delay.stage[249].delay_cell.Z ;
 wire \ring.base_delay.stage[24].delay_cell.Z ;
 wire \ring.base_delay.stage[250].delay_cell.Z ;
 wire \ring.base_delay.stage[251].delay_cell.Z ;
 wire \ring.base_delay.stage[252].delay_cell.Z ;
 wire \ring.base_delay.stage[253].delay_cell.Z ;
 wire \ring.base_delay.stage[254].delay_cell.Z ;
 wire \ring.base_delay.stage[25].delay_cell.Z ;
 wire \ring.base_delay.stage[26].delay_cell.Z ;
 wire \ring.base_delay.stage[27].delay_cell.Z ;
 wire \ring.base_delay.stage[28].delay_cell.Z ;
 wire \ring.base_delay.stage[29].delay_cell.Z ;
 wire \ring.base_delay.stage[2].delay_cell.Z ;
 wire \ring.base_delay.stage[30].delay_cell.Z ;
 wire \ring.base_delay.stage[31].delay_cell.Z ;
 wire \ring.base_delay.stage[32].delay_cell.Z ;
 wire \ring.base_delay.stage[33].delay_cell.Z ;
 wire \ring.base_delay.stage[34].delay_cell.Z ;
 wire \ring.base_delay.stage[35].delay_cell.Z ;
 wire \ring.base_delay.stage[36].delay_cell.Z ;
 wire \ring.base_delay.stage[37].delay_cell.Z ;
 wire \ring.base_delay.stage[38].delay_cell.Z ;
 wire \ring.base_delay.stage[39].delay_cell.Z ;
 wire \ring.base_delay.stage[3].delay_cell.Z ;
 wire \ring.base_delay.stage[40].delay_cell.Z ;
 wire \ring.base_delay.stage[41].delay_cell.Z ;
 wire \ring.base_delay.stage[42].delay_cell.Z ;
 wire \ring.base_delay.stage[43].delay_cell.Z ;
 wire \ring.base_delay.stage[44].delay_cell.Z ;
 wire \ring.base_delay.stage[45].delay_cell.Z ;
 wire \ring.base_delay.stage[46].delay_cell.Z ;
 wire \ring.base_delay.stage[47].delay_cell.Z ;
 wire \ring.base_delay.stage[48].delay_cell.Z ;
 wire \ring.base_delay.stage[49].delay_cell.Z ;
 wire \ring.base_delay.stage[4].delay_cell.Z ;
 wire \ring.base_delay.stage[50].delay_cell.Z ;
 wire \ring.base_delay.stage[51].delay_cell.Z ;
 wire \ring.base_delay.stage[52].delay_cell.Z ;
 wire \ring.base_delay.stage[53].delay_cell.Z ;
 wire \ring.base_delay.stage[54].delay_cell.Z ;
 wire \ring.base_delay.stage[55].delay_cell.Z ;
 wire \ring.base_delay.stage[56].delay_cell.Z ;
 wire \ring.base_delay.stage[57].delay_cell.Z ;
 wire \ring.base_delay.stage[58].delay_cell.Z ;
 wire \ring.base_delay.stage[59].delay_cell.Z ;
 wire \ring.base_delay.stage[5].delay_cell.Z ;
 wire \ring.base_delay.stage[60].delay_cell.Z ;
 wire \ring.base_delay.stage[61].delay_cell.Z ;
 wire \ring.base_delay.stage[62].delay_cell.Z ;
 wire \ring.base_delay.stage[63].delay_cell.Z ;
 wire \ring.base_delay.stage[64].delay_cell.Z ;
 wire \ring.base_delay.stage[65].delay_cell.Z ;
 wire \ring.base_delay.stage[66].delay_cell.Z ;
 wire \ring.base_delay.stage[67].delay_cell.Z ;
 wire \ring.base_delay.stage[68].delay_cell.Z ;
 wire \ring.base_delay.stage[69].delay_cell.Z ;
 wire \ring.base_delay.stage[6].delay_cell.Z ;
 wire \ring.base_delay.stage[70].delay_cell.Z ;
 wire \ring.base_delay.stage[71].delay_cell.Z ;
 wire \ring.base_delay.stage[72].delay_cell.Z ;
 wire \ring.base_delay.stage[73].delay_cell.Z ;
 wire \ring.base_delay.stage[74].delay_cell.Z ;
 wire \ring.base_delay.stage[75].delay_cell.Z ;
 wire \ring.base_delay.stage[76].delay_cell.Z ;
 wire \ring.base_delay.stage[77].delay_cell.Z ;
 wire \ring.base_delay.stage[78].delay_cell.Z ;
 wire \ring.base_delay.stage[79].delay_cell.Z ;
 wire \ring.base_delay.stage[7].delay_cell.Z ;
 wire \ring.base_delay.stage[80].delay_cell.Z ;
 wire \ring.base_delay.stage[81].delay_cell.Z ;
 wire \ring.base_delay.stage[82].delay_cell.Z ;
 wire \ring.base_delay.stage[83].delay_cell.Z ;
 wire \ring.base_delay.stage[84].delay_cell.Z ;
 wire \ring.base_delay.stage[85].delay_cell.Z ;
 wire \ring.base_delay.stage[86].delay_cell.Z ;
 wire \ring.base_delay.stage[87].delay_cell.Z ;
 wire \ring.base_delay.stage[88].delay_cell.Z ;
 wire \ring.base_delay.stage[89].delay_cell.Z ;
 wire \ring.base_delay.stage[8].delay_cell.Z ;
 wire \ring.base_delay.stage[90].delay_cell.Z ;
 wire \ring.base_delay.stage[91].delay_cell.Z ;
 wire \ring.base_delay.stage[92].delay_cell.Z ;
 wire \ring.base_delay.stage[93].delay_cell.Z ;
 wire \ring.base_delay.stage[94].delay_cell.Z ;
 wire \ring.base_delay.stage[95].delay_cell.Z ;
 wire \ring.base_delay.stage[96].delay_cell.Z ;
 wire \ring.base_delay.stage[97].delay_cell.Z ;
 wire \ring.base_delay.stage[98].delay_cell.Z ;
 wire \ring.coarse.impl_last.I ;
 wire \ring.coarse.impl_last.Z ;
 wire \ring.coarse.stage[0].impl.CHAIN_IN ;
 wire \ring.coarse.stage[0].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[0].impl.PATH_0 ;
 wire \ring.coarse.stage[10].impl.CHAIN_IN ;
 wire \ring.coarse.stage[10].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[10].impl.IN ;
 wire \ring.coarse.stage[10].impl.OUT ;
 wire \ring.coarse.stage[10].impl.PATH_0 ;
 wire \ring.coarse.stage[11].impl.CHAIN_IN ;
 wire \ring.coarse.stage[11].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[11].impl.PATH_0 ;
 wire \ring.coarse.stage[12].impl.CHAIN_IN ;
 wire \ring.coarse.stage[12].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[12].impl.PATH_0 ;
 wire \ring.coarse.stage[13].impl.CHAIN_IN ;
 wire \ring.coarse.stage[13].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[13].impl.PATH_0 ;
 wire \ring.coarse.stage[14].impl.PATH_0 ;
 wire \ring.coarse.stage[1].impl.CHAIN_IN ;
 wire \ring.coarse.stage[1].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[1].impl.PATH_0 ;
 wire \ring.coarse.stage[2].impl.CHAIN_IN ;
 wire \ring.coarse.stage[2].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[2].impl.PATH_0 ;
 wire \ring.coarse.stage[3].impl.CHAIN_IN ;
 wire \ring.coarse.stage[3].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[3].impl.PATH_0 ;
 wire \ring.coarse.stage[4].impl.CHAIN_IN ;
 wire \ring.coarse.stage[4].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[4].impl.PATH_0 ;
 wire \ring.coarse.stage[5].impl.CHAIN_IN ;
 wire \ring.coarse.stage[5].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[5].impl.PATH_0 ;
 wire \ring.coarse.stage[6].impl.CHAIN_IN ;
 wire \ring.coarse.stage[6].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[6].impl.PATH_0 ;
 wire \ring.coarse.stage[7].impl.CHAIN_IN ;
 wire \ring.coarse.stage[7].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[7].impl.PATH_0 ;
 wire \ring.coarse.stage[8].impl.CHAIN_IN ;
 wire \ring.coarse.stage[8].impl.CHAIN_OUT ;
 wire \ring.coarse.stage[8].impl.PATH_0 ;
 wire \ring.coarse.stage[9].impl.PATH_0 ;
 wire \ring.dff_x.CKN_B ;
 wire \ring.dff_x.D ;
 wire \ring.dff_x.Q ;
 wire \ring.dff_y.CKN_B ;
 wire \ring.dff_y.D ;
 wire \ring.dff_y.Q ;
 wire \ring.fine.LOAD ;
 wire \ring.fine.stage[0].dyn.A2 ;
 wire \ring.fine.stage[0].dyn.ZN ;
 wire \ring.fine.stage[10].dyn.A2 ;
 wire \ring.fine.stage[10].dyn.ZN ;
 wire \ring.fine.stage[11].dyn.A2 ;
 wire \ring.fine.stage[11].dyn.ZN ;
 wire \ring.fine.stage[12].dyn.A2 ;
 wire \ring.fine.stage[12].dyn.ZN ;
 wire \ring.fine.stage[13].dyn.A2 ;
 wire \ring.fine.stage[13].dyn.ZN ;
 wire \ring.fine.stage[14].dyn.A2 ;
 wire \ring.fine.stage[14].dyn.ZN ;
 wire \ring.fine.stage[15].dyn.A2 ;
 wire \ring.fine.stage[15].dyn.ZN ;
 wire \ring.fine.stage[16].dyn.A2 ;
 wire \ring.fine.stage[16].dyn.ZN ;
 wire \ring.fine.stage[17].dyn.A2 ;
 wire \ring.fine.stage[17].dyn.ZN ;
 wire \ring.fine.stage[18].dyn.A2 ;
 wire \ring.fine.stage[18].dyn.ZN ;
 wire \ring.fine.stage[19].dyn.A2 ;
 wire \ring.fine.stage[19].dyn.ZN ;
 wire \ring.fine.stage[1].dyn.A2 ;
 wire \ring.fine.stage[1].dyn.ZN ;
 wire \ring.fine.stage[20].dyn.A2 ;
 wire \ring.fine.stage[20].dyn.ZN ;
 wire \ring.fine.stage[21].dyn.A2 ;
 wire \ring.fine.stage[21].dyn.ZN ;
 wire \ring.fine.stage[22].dyn.A2 ;
 wire \ring.fine.stage[22].dyn.ZN ;
 wire \ring.fine.stage[23].dyn.A2 ;
 wire \ring.fine.stage[23].dyn.ZN ;
 wire \ring.fine.stage[24].dyn.A2 ;
 wire \ring.fine.stage[24].dyn.ZN ;
 wire \ring.fine.stage[25].dyn.A2 ;
 wire \ring.fine.stage[25].dyn.ZN ;
 wire \ring.fine.stage[26].dyn.A2 ;
 wire \ring.fine.stage[26].dyn.ZN ;
 wire \ring.fine.stage[27].dyn.A2 ;
 wire \ring.fine.stage[27].dyn.ZN ;
 wire \ring.fine.stage[28].dyn.A2 ;
 wire \ring.fine.stage[28].dyn.ZN ;
 wire \ring.fine.stage[29].dyn.A2 ;
 wire \ring.fine.stage[29].dyn.ZN ;
 wire \ring.fine.stage[2].dyn.A2 ;
 wire \ring.fine.stage[2].dyn.ZN ;
 wire \ring.fine.stage[30].dyn.A2 ;
 wire \ring.fine.stage[30].dyn.ZN ;
 wire \ring.fine.stage[3].dyn.A2 ;
 wire \ring.fine.stage[3].dyn.ZN ;
 wire \ring.fine.stage[4].dyn.A2 ;
 wire \ring.fine.stage[4].dyn.ZN ;
 wire \ring.fine.stage[5].dyn.A2 ;
 wire \ring.fine.stage[5].dyn.ZN ;
 wire \ring.fine.stage[6].dyn.A2 ;
 wire \ring.fine.stage[6].dyn.ZN ;
 wire \ring.fine.stage[7].dyn.A2 ;
 wire \ring.fine.stage[7].dyn.ZN ;
 wire \ring.fine.stage[8].dyn.A2 ;
 wire \ring.fine.stage[8].dyn.ZN ;
 wire \ring.fine.stage[9].dyn.A2 ;
 wire \ring.fine.stage[9].dyn.ZN ;
 wire \ring.mid.LOAD ;
 wire \ring.mid.stage[0].dyn.A2 ;
 wire \ring.mid.stage[0].dyn.ZN ;
 wire \ring.mid.stage[10].dyn.A2 ;
 wire \ring.mid.stage[10].dyn.ZN ;
 wire \ring.mid.stage[11].dyn.A2 ;
 wire \ring.mid.stage[11].dyn.ZN ;
 wire \ring.mid.stage[12].dyn.A2 ;
 wire \ring.mid.stage[12].dyn.ZN ;
 wire \ring.mid.stage[13].dyn.A2 ;
 wire \ring.mid.stage[13].dyn.ZN ;
 wire \ring.mid.stage[14].dyn.A2 ;
 wire \ring.mid.stage[14].dyn.ZN ;
 wire \ring.mid.stage[1].dyn.A2 ;
 wire \ring.mid.stage[1].dyn.ZN ;
 wire \ring.mid.stage[2].dyn.A2 ;
 wire \ring.mid.stage[2].dyn.ZN ;
 wire \ring.mid.stage[3].dyn.A2 ;
 wire \ring.mid.stage[3].dyn.ZN ;
 wire \ring.mid.stage[4].dyn.A2 ;
 wire \ring.mid.stage[4].dyn.ZN ;
 wire \ring.mid.stage[5].dyn.A2 ;
 wire \ring.mid.stage[5].dyn.ZN ;
 wire \ring.mid.stage[6].dyn.A2 ;
 wire \ring.mid.stage[6].dyn.ZN ;
 wire \ring.mid.stage[7].dyn.A2 ;
 wire \ring.mid.stage[7].dyn.ZN ;
 wire \ring.mid.stage[8].dyn.A2 ;
 wire \ring.mid.stage[8].dyn.ZN ;
 wire \ring.mid.stage[9].dyn.A2 ;
 wire \ring.mid.stage[9].dyn.ZN ;
 wire \ring.sym.INJ_DUMMY ;
 wire \ring.sym.INJ_EDGE_BALANCED ;
 wire \ring.sym.OSC_BALANCED ;
 wire \ring.sym.OSC_DUMMY ;
 wire \ring.sym.ssbbpd_impl.OUT_NANDX ;
 wire \ring.sym.ssbbpd_impl.OUT_NANDY ;
 wire \ring.sym.sym_mux.DCO_EN_INJ_WIN ;
 wire \ring.sym.sym_mux.OSC_INJ ;
 wire \ring.sym.sym_mux.REF_INJ ;
 wire net;

 sky130_fd_sc_hd__decap_12 FILLER_0_1 ();
 sky130_fd_sc_hd__decap_8 FILLER_0_118 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_126 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_154 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_166 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_173 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_185 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_197 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_209 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_0_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_0_56 ();
 sky130_fd_sc_hd__decap_8 FILLER_0_68 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_76 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_105 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_117 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_130 ();
 sky130_fd_sc_hd__decap_6 FILLER_10_142 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_148 ();
 sky130_fd_sc_hd__decap_8 FILLER_10_161 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_169 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_182 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_194 ();
 sky130_fd_sc_hd__decap_6 FILLER_10_206 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_28 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_40 ();
 sky130_fd_sc_hd__decap_8 FILLER_10_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_60 ();
 sky130_fd_sc_hd__decap_8 FILLER_10_72 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_10_93 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_111 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_123 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_135 ();
 sky130_fd_sc_hd__decap_4 FILLER_11_147 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_159 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_17 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_171 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_173 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_182 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_194 ();
 sky130_fd_sc_hd__decap_6 FILLER_11_206 ();
 sky130_fd_sc_hd__decap_6 FILLER_11_41 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_51 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_62 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_74 ();
 sky130_fd_sc_hd__decap_12 FILLER_11_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_12_111 ();
 sky130_fd_sc_hd__decap_6 FILLER_12_123 ();
 sky130_fd_sc_hd__decap_12 FILLER_12_130 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_146 ();
 sky130_fd_sc_hd__decap_8 FILLER_12_159 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_167 ();
 sky130_fd_sc_hd__decap_12 FILLER_12_181 ();
 sky130_fd_sc_hd__decap_12 FILLER_12_193 ();
 sky130_fd_sc_hd__decap_6 FILLER_12_205 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_211 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_33 ();
 sky130_fd_sc_hd__decap_12 FILLER_12_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_12_68 ();
 sky130_fd_sc_hd__decap_6 FILLER_12_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_86 ();
 sky130_fd_sc_hd__decap_12 FILLER_12_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_102 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_114 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_126 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_154 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_166 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_181 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_193 ();
 sky130_fd_sc_hd__decap_6 FILLER_13_205 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_211 ();
 sky130_fd_sc_hd__decap_4 FILLER_13_28 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_40 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_52 ();
 sky130_fd_sc_hd__decap_12 FILLER_13_64 ();
 sky130_fd_sc_hd__decap_8 FILLER_13_76 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_84 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_14_107 ();
 sky130_fd_sc_hd__decap_8 FILLER_14_119 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_127 ();
 sky130_fd_sc_hd__decap_6 FILLER_14_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_14_148 ();
 sky130_fd_sc_hd__decap_6 FILLER_14_160 ();
 sky130_fd_sc_hd__decap_12 FILLER_14_178 ();
 sky130_fd_sc_hd__decap_12 FILLER_14_190 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_20 ();
 sky130_fd_sc_hd__decap_8 FILLER_14_202 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_210 ();
 sky130_fd_sc_hd__decap_8 FILLER_14_34 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_42 ();
 sky130_fd_sc_hd__decap_12 FILLER_14_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_14_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_14_68 ();
 sky130_fd_sc_hd__decap_8 FILLER_14_80 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_88 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_113 ();
 sky130_fd_sc_hd__decap_6 FILLER_15_125 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_131 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_140 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_152 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_164 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_177 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_189 ();
 sky130_fd_sc_hd__decap_8 FILLER_15_201 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_209 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_25 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_40 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_52 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_57 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_69 ();
 sky130_fd_sc_hd__decap_4 FILLER_15_81 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_85 ();
 sky130_fd_sc_hd__decap_12 FILLER_15_87 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_99 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_103 ();
 sky130_fd_sc_hd__decap_12 FILLER_16_117 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_16_145 ();
 sky130_fd_sc_hd__decap_8 FILLER_16_157 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_165 ();
 sky130_fd_sc_hd__decap_12 FILLER_16_178 ();
 sky130_fd_sc_hd__decap_12 FILLER_16_190 ();
 sky130_fd_sc_hd__decap_8 FILLER_16_202 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_210 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_33 ();
 sky130_fd_sc_hd__decap_6 FILLER_16_37 ();
 sky130_fd_sc_hd__decap_6 FILLER_16_44 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_50 ();
 sky130_fd_sc_hd__decap_12 FILLER_16_79 ();
 sky130_fd_sc_hd__decap_12 FILLER_16_91 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_1 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_101 ();
 sky130_fd_sc_hd__decap_12 FILLER_17_114 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_126 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_17_143 ();
 sky130_fd_sc_hd__decap_8 FILLER_17_155 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_163 ();
 sky130_fd_sc_hd__decap_12 FILLER_17_177 ();
 sky130_fd_sc_hd__decap_12 FILLER_17_189 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_201 ();
 sky130_fd_sc_hd__decap_8 FILLER_17_40 ();
 sky130_fd_sc_hd__decap_8 FILLER_17_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_68 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_85 ();
 sky130_fd_sc_hd__decap_4 FILLER_17_87 ();
 sky130_fd_sc_hd__decap_6 FILLER_17_95 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_18_105 ();
 sky130_fd_sc_hd__decap_12 FILLER_18_117 ();
 sky130_fd_sc_hd__decap_6 FILLER_18_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_18_148 ();
 sky130_fd_sc_hd__decap_6 FILLER_18_160 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_166 ();
 sky130_fd_sc_hd__decap_12 FILLER_18_179 ();
 sky130_fd_sc_hd__decap_6 FILLER_18_191 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_197 ();
 sky130_fd_sc_hd__decap_6 FILLER_18_206 ();
 sky130_fd_sc_hd__decap_12 FILLER_18_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_41 ();
 sky130_fd_sc_hd__decap_6 FILLER_18_44 ();
 sky130_fd_sc_hd__decap_8 FILLER_18_62 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_70 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_111 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_123 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_135 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_150 ();
 sky130_fd_sc_hd__decap_6 FILLER_19_162 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_177 ();
 sky130_fd_sc_hd__decap_6 FILLER_19_189 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_209 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_36 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_48 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_62 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_83 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_19_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_118 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_154 ();
 sky130_fd_sc_hd__decap_6 FILLER_1_166 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_173 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_185 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_197 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_209 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_25 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_49 ();
 sky130_fd_sc_hd__decap_12 FILLER_1_61 ();
 sky130_fd_sc_hd__decap_4 FILLER_1_73 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_77 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_95 ();
 sky130_fd_sc_hd__decap_6 FILLER_20_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_20_108 ();
 sky130_fd_sc_hd__decap_8 FILLER_20_120 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_128 ();
 sky130_fd_sc_hd__decap_12 FILLER_20_130 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_20_156 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_168 ();
 sky130_fd_sc_hd__decap_8 FILLER_20_179 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_187 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_209 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_23 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_40 ();
 sky130_fd_sc_hd__decap_8 FILLER_20_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_20_60 ();
 sky130_fd_sc_hd__decap_12 FILLER_20_72 ();
 sky130_fd_sc_hd__decap_12 FILLER_20_84 ();
 sky130_fd_sc_hd__decap_12 FILLER_20_96 ();
 sky130_fd_sc_hd__decap_12 FILLER_21_105 ();
 sky130_fd_sc_hd__decap_12 FILLER_21_117 ();
 sky130_fd_sc_hd__decap_12 FILLER_21_129 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_141 ();
 sky130_fd_sc_hd__decap_12 FILLER_21_153 ();
 sky130_fd_sc_hd__decap_6 FILLER_21_165 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_171 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_185 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_208 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_23 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_29 ();
 sky130_fd_sc_hd__decap_12 FILLER_21_33 ();
 sky130_fd_sc_hd__decap_4 FILLER_21_45 ();
 sky130_fd_sc_hd__decap_12 FILLER_21_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_74 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_85 ();
 sky130_fd_sc_hd__fill_2 FILLER_21_87 ();
 sky130_fd_sc_hd__fill_1 FILLER_21_93 ();
 sky130_fd_sc_hd__decap_3 FILLER_21_98 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_22_112 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_124 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_128 ();
 sky130_fd_sc_hd__decap_12 FILLER_22_130 ();
 sky130_fd_sc_hd__decap_4 FILLER_22_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_22_154 ();
 sky130_fd_sc_hd__fill_2 FILLER_22_166 ();
 sky130_fd_sc_hd__decap_12 FILLER_22_180 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_192 ();
 sky130_fd_sc_hd__decap_12 FILLER_22_23 ();
 sky130_fd_sc_hd__decap_8 FILLER_22_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_22_44 ();
 sky130_fd_sc_hd__decap_8 FILLER_22_55 ();
 sky130_fd_sc_hd__fill_1 FILLER_22_63 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_1 ();
 sky130_fd_sc_hd__decap_6 FILLER_23_102 ();
 sky130_fd_sc_hd__decap_12 FILLER_23_120 ();
 sky130_fd_sc_hd__decap_12 FILLER_23_132 ();
 sky130_fd_sc_hd__fill_2 FILLER_23_144 ();
 sky130_fd_sc_hd__decap_8 FILLER_23_158 ();
 sky130_fd_sc_hd__decap_12 FILLER_23_16 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_166 ();
 sky130_fd_sc_hd__decap_4 FILLER_23_183 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_187 ();
 sky130_fd_sc_hd__decap_12 FILLER_23_28 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_40 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_53 ();
 sky130_fd_sc_hd__decap_8 FILLER_23_78 ();
 sky130_fd_sc_hd__decap_6 FILLER_23_91 ();
 sky130_fd_sc_hd__fill_1 FILLER_23_97 ();
 sky130_fd_sc_hd__decap_4 FILLER_24_1 ();
 sky130_fd_sc_hd__decap_4 FILLER_24_107 ();
 sky130_fd_sc_hd__fill_1 FILLER_24_111 ();
 sky130_fd_sc_hd__fill_1 FILLER_24_128 ();
 sky130_fd_sc_hd__fill_2 FILLER_24_130 ();
 sky130_fd_sc_hd__fill_1 FILLER_24_136 ();
 sky130_fd_sc_hd__decap_3 FILLER_24_141 ();
 sky130_fd_sc_hd__decap_12 FILLER_24_16 ();
 sky130_fd_sc_hd__decap_12 FILLER_24_160 ();
 sky130_fd_sc_hd__fill_1 FILLER_24_172 ();
 sky130_fd_sc_hd__decap_4 FILLER_24_178 ();
 sky130_fd_sc_hd__decap_12 FILLER_24_28 ();
 sky130_fd_sc_hd__decap_3 FILLER_24_40 ();
 sky130_fd_sc_hd__decap_3 FILLER_24_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_24_59 ();
 sky130_fd_sc_hd__decap_12 FILLER_24_71 ();
 sky130_fd_sc_hd__decap_12 FILLER_24_83 ();
 sky130_fd_sc_hd__decap_12 FILLER_24_95 ();
 sky130_fd_sc_hd__decap_8 FILLER_25_112 ();
 sky130_fd_sc_hd__decap_3 FILLER_25_120 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_159 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_171 ();
 sky130_fd_sc_hd__decap_8 FILLER_25_180 ();
 sky130_fd_sc_hd__fill_2 FILLER_25_188 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_21 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_33 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_45 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_57 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_69 ();
 sky130_fd_sc_hd__decap_4 FILLER_25_81 ();
 sky130_fd_sc_hd__fill_1 FILLER_25_85 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_25_9 ();
 sky130_fd_sc_hd__decap_6 FILLER_25_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_104 ();
 sky130_fd_sc_hd__decap_8 FILLER_26_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_124 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_154 ();
 sky130_fd_sc_hd__decap_4 FILLER_26_166 ();
 sky130_fd_sc_hd__fill_1 FILLER_26_170 ();
 sky130_fd_sc_hd__decap_8 FILLER_26_183 ();
 sky130_fd_sc_hd__fill_2 FILLER_26_210 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_26_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_68 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_26_92 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_1 ();
 sky130_fd_sc_hd__decap_3 FILLER_27_107 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_115 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_127 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_139 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_151 ();
 sky130_fd_sc_hd__decap_8 FILLER_27_163 ();
 sky130_fd_sc_hd__fill_1 FILLER_27_171 ();
 sky130_fd_sc_hd__fill_2 FILLER_27_173 ();
 sky130_fd_sc_hd__decap_3 FILLER_27_180 ();
 sky130_fd_sc_hd__fill_1 FILLER_27_190 ();
 sky130_fd_sc_hd__decap_4 FILLER_27_207 ();
 sky130_fd_sc_hd__fill_1 FILLER_27_211 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_25 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_49 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_61 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_73 ();
 sky130_fd_sc_hd__fill_1 FILLER_27_85 ();
 sky130_fd_sc_hd__decap_12 FILLER_27_87 ();
 sky130_fd_sc_hd__decap_8 FILLER_27_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_104 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_28_128 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_154 ();
 sky130_fd_sc_hd__decap_8 FILLER_28_166 ();
 sky130_fd_sc_hd__fill_2 FILLER_28_174 ();
 sky130_fd_sc_hd__decap_3 FILLER_28_186 ();
 sky130_fd_sc_hd__fill_2 FILLER_28_194 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_28_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_68 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_28_92 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_111 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_123 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_135 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_147 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_159 ();
 sky130_fd_sc_hd__fill_1 FILLER_29_171 ();
 sky130_fd_sc_hd__decap_8 FILLER_29_173 ();
 sky130_fd_sc_hd__decap_3 FILLER_29_181 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_25 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_49 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_61 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_73 ();
 sky130_fd_sc_hd__fill_1 FILLER_29_85 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_29_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_111 ();
 sky130_fd_sc_hd__decap_6 FILLER_2_123 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_154 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_166 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_178 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_190 ();
 sky130_fd_sc_hd__decap_8 FILLER_2_202 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_210 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_2_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_2_68 ();
 sky130_fd_sc_hd__decap_4 FILLER_2_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_104 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_30_128 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_142 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_154 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_166 ();
 sky130_fd_sc_hd__decap_8 FILLER_30_178 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_30_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_68 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_30_92 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_111 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_123 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_13 ();
 sky130_fd_sc_hd__fill_2 FILLER_31_135 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_141 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_153 ();
 sky130_fd_sc_hd__decap_6 FILLER_31_165 ();
 sky130_fd_sc_hd__fill_1 FILLER_31_171 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_173 ();
 sky130_fd_sc_hd__fill_1 FILLER_31_185 ();
 sky130_fd_sc_hd__fill_1 FILLER_31_203 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_25 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_49 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_61 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_73 ();
 sky130_fd_sc_hd__fill_1 FILLER_31_85 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_31_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_1 ();
 sky130_fd_sc_hd__decap_6 FILLER_32_104 ();
 sky130_fd_sc_hd__decap_4 FILLER_32_124 ();
 sky130_fd_sc_hd__fill_1 FILLER_32_128 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_13 ();
 sky130_fd_sc_hd__decap_3 FILLER_32_130 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_148 ();
 sky130_fd_sc_hd__decap_4 FILLER_32_160 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_169 ();
 sky130_fd_sc_hd__decap_8 FILLER_32_181 ();
 sky130_fd_sc_hd__fill_1 FILLER_32_203 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_32_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_68 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_32_92 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_13 ();
 sky130_fd_sc_hd__decap_4 FILLER_33_183 ();
 sky130_fd_sc_hd__decap_8 FILLER_33_202 ();
 sky130_fd_sc_hd__fill_2 FILLER_33_210 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_25 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_49 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_61 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_73 ();
 sky130_fd_sc_hd__fill_1 FILLER_33_85 ();
 sky130_fd_sc_hd__decap_12 FILLER_33_87 ();
 sky130_fd_sc_hd__decap_8 FILLER_33_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_1 ();
 sky130_fd_sc_hd__fill_2 FILLER_34_119 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_13 ();
 sky130_fd_sc_hd__fill_1 FILLER_34_151 ();
 sky130_fd_sc_hd__decap_3 FILLER_34_164 ();
 sky130_fd_sc_hd__fill_1 FILLER_34_175 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_183 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_195 ();
 sky130_fd_sc_hd__decap_4 FILLER_34_207 ();
 sky130_fd_sc_hd__fill_1 FILLER_34_211 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_34_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_68 ();
 sky130_fd_sc_hd__decap_12 FILLER_34_80 ();
 sky130_fd_sc_hd__decap_8 FILLER_34_92 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_1 ();
 sky130_fd_sc_hd__fill_2 FILLER_35_117 ();
 sky130_fd_sc_hd__fill_2 FILLER_35_127 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_13 ();
 sky130_fd_sc_hd__fill_2 FILLER_35_170 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_178 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_190 ();
 sky130_fd_sc_hd__decap_8 FILLER_35_202 ();
 sky130_fd_sc_hd__fill_2 FILLER_35_210 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_25 ();
 sky130_fd_sc_hd__decap_6 FILLER_35_37 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_68 ();
 sky130_fd_sc_hd__decap_6 FILLER_35_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_35_87 ();
 sky130_fd_sc_hd__fill_2 FILLER_35_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_108 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_120 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_13 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_132 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_144 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_156 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_168 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_173 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_185 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_197 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_209 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_25 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_33 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_45 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_57 ();
 sky130_fd_sc_hd__decap_12 FILLER_3_69 ();
 sky130_fd_sc_hd__decap_4 FILLER_3_81 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_85 ();
 sky130_fd_sc_hd__decap_8 FILLER_3_87 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_95 ();
 sky130_fd_sc_hd__decap_6 FILLER_4_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_104 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_11 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_128 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_130 ();
 sky130_fd_sc_hd__decap_8 FILLER_4_142 ();
 sky130_fd_sc_hd__decap_8 FILLER_4_15 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_154 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_166 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_178 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_190 ();
 sky130_fd_sc_hd__decap_8 FILLER_4_202 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_210 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_23 ();
 sky130_fd_sc_hd__decap_8 FILLER_4_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_40 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_68 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_7 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_4_92 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_111 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_123 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_135 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_156 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_163 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_171 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_181 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_193 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_20 ();
 sky130_fd_sc_hd__decap_6 FILLER_5_205 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_211 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_34 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_46 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_58 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_70 ();
 sky130_fd_sc_hd__decap_4 FILLER_5_82 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_5_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_104 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_128 ();
 sky130_fd_sc_hd__decap_8 FILLER_6_142 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_150 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_185 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_197 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_209 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_22 ();
 sky130_fd_sc_hd__decap_4 FILLER_6_38 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_42 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_44 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_56 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_68 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_80 ();
 sky130_fd_sc_hd__decap_12 FILLER_6_92 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_123 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_134 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_146 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_158 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_170 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_173 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_186 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_198 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_210 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_34 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_39 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_51 ();
 sky130_fd_sc_hd__decap_8 FILLER_7_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_83 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_87 ();
 sky130_fd_sc_hd__decap_12 FILLER_7_99 ();
 sky130_fd_sc_hd__decap_12 FILLER_8_105 ();
 sky130_fd_sc_hd__decap_8 FILLER_8_117 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_130 ();
 sky130_fd_sc_hd__decap_8 FILLER_8_143 ();
 sky130_fd_sc_hd__decap_12 FILLER_8_155 ();
 sky130_fd_sc_hd__decap_6 FILLER_8_167 ();
 sky130_fd_sc_hd__decap_12 FILLER_8_185 ();
 sky130_fd_sc_hd__decap_12 FILLER_8_197 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_209 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_21 ();
 sky130_fd_sc_hd__decap_12 FILLER_8_44 ();
 sky130_fd_sc_hd__decap_4 FILLER_8_56 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_60 ();
 sky130_fd_sc_hd__decap_12 FILLER_8_81 ();
 sky130_fd_sc_hd__decap_12 FILLER_8_93 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_1 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_103 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_115 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_127 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_159 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_171 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_173 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_184 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_196 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_208 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_27 ();
 sky130_fd_sc_hd__decap_8 FILLER_9_43 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_51 ();
 sky130_fd_sc_hd__decap_4 FILLER_9_69 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_73 ();
 sky130_fd_sc_hd__decap_12 FILLER_9_91 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_0_Left_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_0_Right_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_10_Left_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_10_Right_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_11_Left_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_11_Right_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_12_Left_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_12_Right_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_13_Left_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_13_Right_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_14_Left_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_14_Right_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_15_Left_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_15_Right_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_16_Left_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_16_Right_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_17_Left_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_17_Right_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_18_Left_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_18_Right_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_19_Left_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_19_Right_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_1_Left_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_1_Right_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_20_Left_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_20_Right_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_21_Left_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_21_Right_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_22_Left_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_22_Right_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_23_Left_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_23_Right_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_24_Left_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_24_Right_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_25_Left_61 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_25_Right_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_26_Left_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_26_Right_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_27_Left_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_27_Right_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_28_Left_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_28_Right_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_29_Left_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_29_Right_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_2_Left_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_2_Right_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_30_Left_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_30_Right_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_31_Left_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_31_Right_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_32_Left_68 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_32_Right_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_33_Left_69 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_33_Right_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_34_Left_70 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_34_Right_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_35_Left_71 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_35_Right_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_3_Left_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_3_Right_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_4_Left_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_4_Right_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_5_Left_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_5_Right_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_6_Left_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_6_Right_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_7_Left_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_7_Right_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_8_Left_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_8_Right_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_9_Left_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 PHY_EDGE_ROW_9_Right_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_72 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_73 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_74 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_75 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_94 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_95 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_96 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_97 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_98 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_99 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_100 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_101 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_102 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_103 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_104 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_105 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_106 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_107 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_108 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_109 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_110 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_111 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_112 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_113 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_76 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_77 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_114 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_115 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_21_116 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_21_117 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_118 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_119 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_23_120 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_23_121 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_122 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_123 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_25_124 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_25_125 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_26_126 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_26_127 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_27_128 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_27_129 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_28_130 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_28_131 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_29_132 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_29_133 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_78 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_79 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_30_134 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_30_135 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_31_136 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_31_137 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_32_138 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_32_139 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_33_140 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_33_141 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_34_142 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_34_143 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_35_144 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_35_145 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_35_146 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_35_147 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_80 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_81 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_82 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_83 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_84 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_85 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_86 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_87 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_88 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_89 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_90 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_91 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_92 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_93 ();
 sky130_fd_sc_hd__buf_2 _4_ (.A(REF),
    .X(net63));
 sky130_fd_sc_hd__buf_2 _5_ (.A(\ring.dff_y.Q ),
    .X(net65));
 sky130_fd_sc_hd__buf_2 _6_ (.A(\ring.dff_x.Q ),
    .X(net66));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input1 (.A(COARSE_MUX[0]),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input10 (.A(COARSE_MUX[4]),
    .X(net10));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input11 (.A(COARSE_MUX[5]),
    .X(net11));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input12 (.A(COARSE_MUX[6]),
    .X(net12));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input13 (.A(COARSE_MUX[7]),
    .X(net13));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input14 (.A(COARSE_MUX[8]),
    .X(net14));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input15 (.A(COARSE_MUX[9]),
    .X(net15));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input16 (.A(DCO_EN),
    .X(net16));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input17 (.A(FINE_MUX[0]),
    .X(net17));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input18 (.A(FINE_MUX[10]),
    .X(net18));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input19 (.A(FINE_MUX[11]),
    .X(net19));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input2 (.A(COARSE_MUX[10]),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input20 (.A(FINE_MUX[12]),
    .X(net20));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input21 (.A(FINE_MUX[13]),
    .X(net21));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input22 (.A(FINE_MUX[14]),
    .X(net22));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input23 (.A(FINE_MUX[15]),
    .X(net23));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input24 (.A(FINE_MUX[16]),
    .X(net24));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input25 (.A(FINE_MUX[17]),
    .X(net25));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input26 (.A(FINE_MUX[18]),
    .X(net26));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input27 (.A(FINE_MUX[19]),
    .X(net27));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input28 (.A(FINE_MUX[1]),
    .X(net28));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input29 (.A(FINE_MUX[20]),
    .X(net29));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input3 (.A(COARSE_MUX[11]),
    .X(net3));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input30 (.A(FINE_MUX[21]),
    .X(net30));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input31 (.A(FINE_MUX[22]),
    .X(net31));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input32 (.A(FINE_MUX[23]),
    .X(net32));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input33 (.A(FINE_MUX[24]),
    .X(net33));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input34 (.A(FINE_MUX[25]),
    .X(net34));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input35 (.A(FINE_MUX[26]),
    .X(net35));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input36 (.A(FINE_MUX[27]),
    .X(net36));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input37 (.A(FINE_MUX[28]),
    .X(net37));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input38 (.A(FINE_MUX[29]),
    .X(net38));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input39 (.A(FINE_MUX[2]),
    .X(net39));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input4 (.A(COARSE_MUX[12]),
    .X(net4));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input40 (.A(FINE_MUX[30]),
    .X(net40));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input41 (.A(FINE_MUX[3]),
    .X(net41));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input42 (.A(FINE_MUX[4]),
    .X(net42));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input43 (.A(FINE_MUX[5]),
    .X(net43));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input44 (.A(FINE_MUX[6]),
    .X(net44));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input45 (.A(FINE_MUX[7]),
    .X(net45));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input46 (.A(FINE_MUX[8]),
    .X(net46));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input47 (.A(FINE_MUX[9]),
    .X(net47));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input48 (.A(MID_MUX[0]),
    .X(net48));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input49 (.A(MID_MUX[10]),
    .X(net49));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input5 (.A(COARSE_MUX[13]),
    .X(net5));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input50 (.A(MID_MUX[11]),
    .X(net50));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input51 (.A(MID_MUX[12]),
    .X(net51));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input52 (.A(MID_MUX[13]),
    .X(net52));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input53 (.A(MID_MUX[14]),
    .X(net53));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input54 (.A(MID_MUX[1]),
    .X(net54));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input55 (.A(MID_MUX[2]),
    .X(net55));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input56 (.A(MID_MUX[3]),
    .X(net56));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input57 (.A(MID_MUX[4]),
    .X(net57));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input58 (.A(MID_MUX[5]),
    .X(net58));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input59 (.A(MID_MUX[6]),
    .X(net59));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input6 (.A(COARSE_MUX[14]),
    .X(net6));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input60 (.A(MID_MUX[7]),
    .X(net60));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input61 (.A(MID_MUX[8]),
    .X(net61));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input62 (.A(MID_MUX[9]),
    .X(net62));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input7 (.A(COARSE_MUX[1]),
    .X(net7));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input8 (.A(COARSE_MUX[2]),
    .X(net8));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input9 (.A(COARSE_MUX[3]),
    .X(net9));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output63 (.A(net63),
    .X(INJ_EDGE));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output64 (.A(net64),
    .X(MID_OUT));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output65 (.A(net65),
    .X(SS_BBPD[0]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output66 (.A(net66),
    .X(SS_BBPD[1]));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[0].delay_cell.impl  (.A(OUT),
    .X(\ring.base_delay.stage[0].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[100].delay_cell.impl  (.A(\ring.base_delay.stage[100].delay_cell.I ),
    .X(\ring.base_delay.stage[100].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[101].delay_cell.impl  (.A(\ring.base_delay.stage[100].delay_cell.Z ),
    .X(\ring.base_delay.stage[101].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[102].delay_cell.impl  (.A(\ring.base_delay.stage[101].delay_cell.Z ),
    .X(\ring.base_delay.stage[102].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[103].delay_cell.impl  (.A(\ring.base_delay.stage[102].delay_cell.Z ),
    .X(\ring.base_delay.stage[103].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[104].delay_cell.impl  (.A(\ring.base_delay.stage[103].delay_cell.Z ),
    .X(\ring.base_delay.stage[104].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[105].delay_cell.impl  (.A(\ring.base_delay.stage[104].delay_cell.Z ),
    .X(\ring.base_delay.stage[105].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[106].delay_cell.impl  (.A(\ring.base_delay.stage[105].delay_cell.Z ),
    .X(\ring.base_delay.stage[106].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[107].delay_cell.impl  (.A(\ring.base_delay.stage[106].delay_cell.Z ),
    .X(\ring.base_delay.stage[107].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[108].delay_cell.impl  (.A(\ring.base_delay.stage[107].delay_cell.Z ),
    .X(\ring.base_delay.stage[108].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[109].delay_cell.impl  (.A(\ring.base_delay.stage[108].delay_cell.Z ),
    .X(\ring.base_delay.stage[109].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[10].delay_cell.impl  (.A(\ring.base_delay.stage[10].delay_cell.I ),
    .X(\ring.base_delay.stage[10].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[110].delay_cell.impl  (.A(\ring.base_delay.stage[109].delay_cell.Z ),
    .X(\ring.base_delay.stage[110].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[111].delay_cell.impl  (.A(\ring.base_delay.stage[110].delay_cell.Z ),
    .X(\ring.base_delay.stage[111].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[112].delay_cell.impl  (.A(\ring.base_delay.stage[111].delay_cell.Z ),
    .X(\ring.base_delay.stage[112].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[113].delay_cell.impl  (.A(\ring.base_delay.stage[112].delay_cell.Z ),
    .X(\ring.base_delay.stage[113].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[114].delay_cell.impl  (.A(\ring.base_delay.stage[113].delay_cell.Z ),
    .X(\ring.base_delay.stage[114].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[115].delay_cell.impl  (.A(\ring.base_delay.stage[114].delay_cell.Z ),
    .X(\ring.base_delay.stage[115].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[116].delay_cell.impl  (.A(\ring.base_delay.stage[115].delay_cell.Z ),
    .X(\ring.base_delay.stage[116].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[117].delay_cell.impl  (.A(\ring.base_delay.stage[116].delay_cell.Z ),
    .X(\ring.base_delay.stage[117].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[118].delay_cell.impl  (.A(\ring.base_delay.stage[117].delay_cell.Z ),
    .X(\ring.base_delay.stage[118].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[119].delay_cell.impl  (.A(\ring.base_delay.stage[118].delay_cell.Z ),
    .X(\ring.base_delay.stage[119].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[11].delay_cell.impl  (.A(\ring.base_delay.stage[10].delay_cell.Z ),
    .X(\ring.base_delay.stage[11].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[120].delay_cell.impl  (.A(\ring.base_delay.stage[119].delay_cell.Z ),
    .X(\ring.base_delay.stage[120].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[121].delay_cell.impl  (.A(\ring.base_delay.stage[120].delay_cell.Z ),
    .X(\ring.base_delay.stage[121].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[122].delay_cell.impl  (.A(\ring.base_delay.stage[121].delay_cell.Z ),
    .X(\ring.base_delay.stage[122].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[123].delay_cell.impl  (.A(\ring.base_delay.stage[122].delay_cell.Z ),
    .X(\ring.base_delay.stage[123].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[124].delay_cell.impl  (.A(\ring.base_delay.stage[123].delay_cell.Z ),
    .X(\ring.base_delay.stage[124].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[125].delay_cell.impl  (.A(\ring.base_delay.stage[124].delay_cell.Z ),
    .X(\ring.base_delay.stage[125].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[126].delay_cell.impl  (.A(\ring.base_delay.stage[125].delay_cell.Z ),
    .X(\ring.base_delay.stage[126].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[127].delay_cell.impl  (.A(\ring.base_delay.stage[126].delay_cell.Z ),
    .X(\ring.base_delay.stage[127].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[128].delay_cell.impl  (.A(\ring.base_delay.stage[127].delay_cell.Z ),
    .X(\ring.base_delay.stage[128].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[129].delay_cell.impl  (.A(\ring.base_delay.stage[128].delay_cell.Z ),
    .X(\ring.base_delay.stage[129].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[12].delay_cell.impl  (.A(\ring.base_delay.stage[11].delay_cell.Z ),
    .X(\ring.base_delay.stage[12].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[130].delay_cell.impl  (.A(\ring.base_delay.stage[129].delay_cell.Z ),
    .X(\ring.base_delay.stage[130].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[131].delay_cell.impl  (.A(\ring.base_delay.stage[130].delay_cell.Z ),
    .X(\ring.base_delay.stage[131].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[132].delay_cell.impl  (.A(\ring.base_delay.stage[131].delay_cell.Z ),
    .X(\ring.base_delay.stage[132].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[133].delay_cell.impl  (.A(\ring.base_delay.stage[132].delay_cell.Z ),
    .X(\ring.base_delay.stage[133].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[134].delay_cell.impl  (.A(\ring.base_delay.stage[133].delay_cell.Z ),
    .X(\ring.base_delay.stage[134].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[135].delay_cell.impl  (.A(\ring.base_delay.stage[134].delay_cell.Z ),
    .X(\ring.base_delay.stage[135].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[136].delay_cell.impl  (.A(\ring.base_delay.stage[135].delay_cell.Z ),
    .X(\ring.base_delay.stage[136].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[137].delay_cell.impl  (.A(\ring.base_delay.stage[136].delay_cell.Z ),
    .X(\ring.base_delay.stage[137].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[138].delay_cell.impl  (.A(\ring.base_delay.stage[137].delay_cell.Z ),
    .X(\ring.base_delay.stage[138].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[139].delay_cell.impl  (.A(\ring.base_delay.stage[138].delay_cell.Z ),
    .X(\ring.base_delay.stage[139].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[13].delay_cell.impl  (.A(\ring.base_delay.stage[12].delay_cell.Z ),
    .X(\ring.base_delay.stage[13].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[140].delay_cell.impl  (.A(\ring.base_delay.stage[139].delay_cell.Z ),
    .X(\ring.base_delay.stage[140].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[141].delay_cell.impl  (.A(\ring.base_delay.stage[140].delay_cell.Z ),
    .X(\ring.base_delay.stage[141].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[142].delay_cell.impl  (.A(\ring.base_delay.stage[141].delay_cell.Z ),
    .X(\ring.base_delay.stage[142].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[143].delay_cell.impl  (.A(\ring.base_delay.stage[142].delay_cell.Z ),
    .X(\ring.base_delay.stage[143].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[144].delay_cell.impl  (.A(\ring.base_delay.stage[143].delay_cell.Z ),
    .X(\ring.base_delay.stage[144].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[145].delay_cell.impl  (.A(\ring.base_delay.stage[144].delay_cell.Z ),
    .X(\ring.base_delay.stage[145].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[146].delay_cell.impl  (.A(\ring.base_delay.stage[145].delay_cell.Z ),
    .X(\ring.base_delay.stage[146].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[147].delay_cell.impl  (.A(\ring.base_delay.stage[146].delay_cell.Z ),
    .X(\ring.base_delay.stage[147].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[148].delay_cell.impl  (.A(\ring.base_delay.stage[147].delay_cell.Z ),
    .X(\ring.base_delay.stage[148].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[149].delay_cell.impl  (.A(\ring.base_delay.stage[148].delay_cell.Z ),
    .X(\ring.base_delay.stage[149].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[14].delay_cell.impl  (.A(\ring.base_delay.stage[13].delay_cell.Z ),
    .X(\ring.base_delay.stage[14].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[150].delay_cell.impl  (.A(\ring.base_delay.stage[149].delay_cell.Z ),
    .X(\ring.base_delay.stage[150].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[151].delay_cell.impl  (.A(\ring.base_delay.stage[150].delay_cell.Z ),
    .X(\ring.base_delay.stage[151].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[152].delay_cell.impl  (.A(\ring.base_delay.stage[151].delay_cell.Z ),
    .X(\ring.base_delay.stage[152].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[153].delay_cell.impl  (.A(\ring.base_delay.stage[152].delay_cell.Z ),
    .X(\ring.base_delay.stage[153].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[154].delay_cell.impl  (.A(\ring.base_delay.stage[153].delay_cell.Z ),
    .X(\ring.base_delay.stage[154].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[155].delay_cell.impl  (.A(\ring.base_delay.stage[154].delay_cell.Z ),
    .X(\ring.base_delay.stage[155].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[156].delay_cell.impl  (.A(\ring.base_delay.stage[155].delay_cell.Z ),
    .X(\ring.base_delay.stage[156].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[157].delay_cell.impl  (.A(\ring.base_delay.stage[156].delay_cell.Z ),
    .X(\ring.base_delay.stage[157].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[158].delay_cell.impl  (.A(\ring.base_delay.stage[157].delay_cell.Z ),
    .X(\ring.base_delay.stage[158].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[159].delay_cell.impl  (.A(\ring.base_delay.stage[158].delay_cell.Z ),
    .X(\ring.base_delay.stage[159].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[15].delay_cell.impl  (.A(\ring.base_delay.stage[14].delay_cell.Z ),
    .X(\ring.base_delay.stage[15].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[160].delay_cell.impl  (.A(\ring.base_delay.stage[159].delay_cell.Z ),
    .X(\ring.base_delay.stage[160].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[161].delay_cell.impl  (.A(\ring.base_delay.stage[160].delay_cell.Z ),
    .X(\ring.base_delay.stage[161].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[162].delay_cell.impl  (.A(\ring.base_delay.stage[161].delay_cell.Z ),
    .X(\ring.base_delay.stage[162].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[163].delay_cell.impl  (.A(\ring.base_delay.stage[162].delay_cell.Z ),
    .X(\ring.base_delay.stage[163].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[164].delay_cell.impl  (.A(\ring.base_delay.stage[163].delay_cell.Z ),
    .X(\ring.base_delay.stage[164].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[165].delay_cell.impl  (.A(\ring.base_delay.stage[164].delay_cell.Z ),
    .X(\ring.base_delay.stage[165].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[166].delay_cell.impl  (.A(\ring.base_delay.stage[165].delay_cell.Z ),
    .X(\ring.base_delay.stage[166].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[167].delay_cell.impl  (.A(\ring.base_delay.stage[166].delay_cell.Z ),
    .X(\ring.base_delay.stage[167].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[168].delay_cell.impl  (.A(\ring.base_delay.stage[167].delay_cell.Z ),
    .X(\ring.base_delay.stage[168].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[169].delay_cell.impl  (.A(\ring.base_delay.stage[168].delay_cell.Z ),
    .X(\ring.base_delay.stage[169].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[16].delay_cell.impl  (.A(\ring.base_delay.stage[15].delay_cell.Z ),
    .X(\ring.base_delay.stage[16].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[170].delay_cell.impl  (.A(\ring.base_delay.stage[169].delay_cell.Z ),
    .X(\ring.base_delay.stage[170].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[171].delay_cell.impl  (.A(\ring.base_delay.stage[170].delay_cell.Z ),
    .X(\ring.base_delay.stage[171].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[172].delay_cell.impl  (.A(\ring.base_delay.stage[171].delay_cell.Z ),
    .X(\ring.base_delay.stage[172].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[173].delay_cell.impl  (.A(\ring.base_delay.stage[172].delay_cell.Z ),
    .X(\ring.base_delay.stage[173].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[174].delay_cell.impl  (.A(\ring.base_delay.stage[173].delay_cell.Z ),
    .X(\ring.base_delay.stage[174].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[175].delay_cell.impl  (.A(\ring.base_delay.stage[174].delay_cell.Z ),
    .X(\ring.base_delay.stage[175].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[176].delay_cell.impl  (.A(\ring.base_delay.stage[175].delay_cell.Z ),
    .X(\ring.base_delay.stage[176].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[177].delay_cell.impl  (.A(\ring.base_delay.stage[176].delay_cell.Z ),
    .X(\ring.base_delay.stage[177].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[178].delay_cell.impl  (.A(\ring.base_delay.stage[177].delay_cell.Z ),
    .X(\ring.base_delay.stage[178].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[179].delay_cell.impl  (.A(\ring.base_delay.stage[178].delay_cell.Z ),
    .X(\ring.base_delay.stage[179].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[17].delay_cell.impl  (.A(\ring.base_delay.stage[16].delay_cell.Z ),
    .X(\ring.base_delay.stage[17].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[180].delay_cell.impl  (.A(\ring.base_delay.stage[179].delay_cell.Z ),
    .X(\ring.base_delay.stage[180].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[181].delay_cell.impl  (.A(\ring.base_delay.stage[180].delay_cell.Z ),
    .X(\ring.base_delay.stage[181].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[182].delay_cell.impl  (.A(\ring.base_delay.stage[181].delay_cell.Z ),
    .X(\ring.base_delay.stage[182].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[183].delay_cell.impl  (.A(\ring.base_delay.stage[182].delay_cell.Z ),
    .X(\ring.base_delay.stage[183].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[184].delay_cell.impl  (.A(\ring.base_delay.stage[183].delay_cell.Z ),
    .X(\ring.base_delay.stage[184].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[185].delay_cell.impl  (.A(\ring.base_delay.stage[184].delay_cell.Z ),
    .X(\ring.base_delay.stage[185].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[186].delay_cell.impl  (.A(\ring.base_delay.stage[185].delay_cell.Z ),
    .X(\ring.base_delay.stage[186].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[187].delay_cell.impl  (.A(\ring.base_delay.stage[186].delay_cell.Z ),
    .X(\ring.base_delay.stage[187].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[188].delay_cell.impl  (.A(\ring.base_delay.stage[187].delay_cell.Z ),
    .X(\ring.base_delay.stage[188].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[189].delay_cell.impl  (.A(\ring.base_delay.stage[188].delay_cell.Z ),
    .X(\ring.base_delay.stage[189].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[18].delay_cell.impl  (.A(\ring.base_delay.stage[17].delay_cell.Z ),
    .X(\ring.base_delay.stage[18].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[190].delay_cell.impl  (.A(\ring.base_delay.stage[189].delay_cell.Z ),
    .X(\ring.base_delay.stage[190].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[191].delay_cell.impl  (.A(\ring.base_delay.stage[190].delay_cell.Z ),
    .X(\ring.base_delay.stage[191].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[192].delay_cell.impl  (.A(\ring.base_delay.stage[191].delay_cell.Z ),
    .X(\ring.base_delay.stage[192].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[193].delay_cell.impl  (.A(\ring.base_delay.stage[192].delay_cell.Z ),
    .X(\ring.base_delay.stage[193].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[194].delay_cell.impl  (.A(\ring.base_delay.stage[193].delay_cell.Z ),
    .X(\ring.base_delay.stage[194].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[195].delay_cell.impl  (.A(\ring.base_delay.stage[194].delay_cell.Z ),
    .X(\ring.base_delay.stage[195].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[196].delay_cell.impl  (.A(\ring.base_delay.stage[195].delay_cell.Z ),
    .X(\ring.base_delay.stage[196].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[197].delay_cell.impl  (.A(\ring.base_delay.stage[196].delay_cell.Z ),
    .X(\ring.base_delay.stage[197].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[198].delay_cell.impl  (.A(\ring.base_delay.stage[197].delay_cell.Z ),
    .X(\ring.base_delay.stage[198].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[199].delay_cell.impl  (.A(\ring.base_delay.stage[198].delay_cell.Z ),
    .X(\ring.base_delay.stage[199].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[19].delay_cell.impl  (.A(\ring.base_delay.stage[18].delay_cell.Z ),
    .X(\ring.base_delay.stage[19].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[1].delay_cell.impl  (.A(\ring.base_delay.stage[0].delay_cell.Z ),
    .X(\ring.base_delay.stage[1].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[200].delay_cell.impl  (.A(\ring.base_delay.stage[199].delay_cell.Z ),
    .X(\ring.base_delay.stage[200].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[201].delay_cell.impl  (.A(\ring.base_delay.stage[200].delay_cell.Z ),
    .X(\ring.base_delay.stage[201].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[202].delay_cell.impl  (.A(\ring.base_delay.stage[201].delay_cell.Z ),
    .X(\ring.base_delay.stage[202].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[203].delay_cell.impl  (.A(\ring.base_delay.stage[202].delay_cell.Z ),
    .X(\ring.base_delay.stage[203].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[204].delay_cell.impl  (.A(\ring.base_delay.stage[203].delay_cell.Z ),
    .X(\ring.base_delay.stage[204].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[205].delay_cell.impl  (.A(\ring.base_delay.stage[204].delay_cell.Z ),
    .X(\ring.base_delay.stage[205].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[206].delay_cell.impl  (.A(\ring.base_delay.stage[205].delay_cell.Z ),
    .X(\ring.base_delay.stage[206].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[207].delay_cell.impl  (.A(\ring.base_delay.stage[206].delay_cell.Z ),
    .X(\ring.base_delay.stage[207].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[208].delay_cell.impl  (.A(\ring.base_delay.stage[207].delay_cell.Z ),
    .X(\ring.base_delay.stage[208].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[209].delay_cell.impl  (.A(\ring.base_delay.stage[208].delay_cell.Z ),
    .X(\ring.base_delay.stage[209].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[20].delay_cell.impl  (.A(\ring.base_delay.stage[19].delay_cell.Z ),
    .X(\ring.base_delay.stage[20].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[210].delay_cell.impl  (.A(\ring.base_delay.stage[209].delay_cell.Z ),
    .X(\ring.base_delay.stage[210].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[211].delay_cell.impl  (.A(\ring.base_delay.stage[210].delay_cell.Z ),
    .X(\ring.base_delay.stage[211].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[212].delay_cell.impl  (.A(\ring.base_delay.stage[211].delay_cell.Z ),
    .X(\ring.base_delay.stage[212].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[213].delay_cell.impl  (.A(\ring.base_delay.stage[212].delay_cell.Z ),
    .X(\ring.base_delay.stage[213].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[214].delay_cell.impl  (.A(\ring.base_delay.stage[213].delay_cell.Z ),
    .X(\ring.base_delay.stage[214].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[215].delay_cell.impl  (.A(\ring.base_delay.stage[214].delay_cell.Z ),
    .X(\ring.base_delay.stage[215].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[216].delay_cell.impl  (.A(\ring.base_delay.stage[215].delay_cell.Z ),
    .X(\ring.base_delay.stage[216].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[217].delay_cell.impl  (.A(\ring.base_delay.stage[216].delay_cell.Z ),
    .X(\ring.base_delay.stage[217].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[218].delay_cell.impl  (.A(\ring.base_delay.stage[217].delay_cell.Z ),
    .X(\ring.base_delay.stage[218].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[219].delay_cell.impl  (.A(\ring.base_delay.stage[218].delay_cell.Z ),
    .X(\ring.base_delay.stage[219].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[21].delay_cell.impl  (.A(\ring.base_delay.stage[20].delay_cell.Z ),
    .X(\ring.base_delay.stage[21].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[220].delay_cell.impl  (.A(\ring.base_delay.stage[219].delay_cell.Z ),
    .X(\ring.base_delay.stage[220].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[221].delay_cell.impl  (.A(\ring.base_delay.stage[220].delay_cell.Z ),
    .X(\ring.base_delay.stage[221].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[222].delay_cell.impl  (.A(\ring.base_delay.stage[221].delay_cell.Z ),
    .X(\ring.base_delay.stage[222].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[223].delay_cell.impl  (.A(\ring.base_delay.stage[222].delay_cell.Z ),
    .X(\ring.base_delay.stage[223].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[224].delay_cell.impl  (.A(\ring.base_delay.stage[223].delay_cell.Z ),
    .X(\ring.base_delay.stage[224].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[225].delay_cell.impl  (.A(\ring.base_delay.stage[224].delay_cell.Z ),
    .X(\ring.base_delay.stage[225].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[226].delay_cell.impl  (.A(\ring.base_delay.stage[225].delay_cell.Z ),
    .X(\ring.base_delay.stage[226].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[227].delay_cell.impl  (.A(\ring.base_delay.stage[226].delay_cell.Z ),
    .X(\ring.base_delay.stage[227].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[228].delay_cell.impl  (.A(\ring.base_delay.stage[227].delay_cell.Z ),
    .X(\ring.base_delay.stage[228].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[229].delay_cell.impl  (.A(\ring.base_delay.stage[228].delay_cell.Z ),
    .X(\ring.base_delay.stage[229].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[22].delay_cell.impl  (.A(\ring.base_delay.stage[21].delay_cell.Z ),
    .X(\ring.base_delay.stage[22].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[230].delay_cell.impl  (.A(\ring.base_delay.stage[229].delay_cell.Z ),
    .X(\ring.base_delay.stage[230].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[231].delay_cell.impl  (.A(\ring.base_delay.stage[230].delay_cell.Z ),
    .X(\ring.base_delay.stage[231].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[232].delay_cell.impl  (.A(\ring.base_delay.stage[231].delay_cell.Z ),
    .X(\ring.base_delay.stage[232].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[233].delay_cell.impl  (.A(\ring.base_delay.stage[232].delay_cell.Z ),
    .X(\ring.base_delay.stage[233].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[234].delay_cell.impl  (.A(\ring.base_delay.stage[233].delay_cell.Z ),
    .X(\ring.base_delay.stage[234].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[235].delay_cell.impl  (.A(\ring.base_delay.stage[234].delay_cell.Z ),
    .X(\ring.base_delay.stage[235].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[236].delay_cell.impl  (.A(\ring.base_delay.stage[235].delay_cell.Z ),
    .X(\ring.base_delay.stage[236].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[237].delay_cell.impl  (.A(\ring.base_delay.stage[236].delay_cell.Z ),
    .X(\ring.base_delay.stage[237].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[238].delay_cell.impl  (.A(\ring.base_delay.stage[237].delay_cell.Z ),
    .X(\ring.base_delay.stage[238].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[239].delay_cell.impl  (.A(\ring.base_delay.stage[238].delay_cell.Z ),
    .X(\ring.base_delay.stage[239].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[23].delay_cell.impl  (.A(\ring.base_delay.stage[22].delay_cell.Z ),
    .X(\ring.base_delay.stage[23].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[240].delay_cell.impl  (.A(\ring.base_delay.stage[239].delay_cell.Z ),
    .X(\ring.base_delay.stage[240].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[241].delay_cell.impl  (.A(\ring.base_delay.stage[240].delay_cell.Z ),
    .X(\ring.base_delay.stage[241].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[242].delay_cell.impl  (.A(\ring.base_delay.stage[241].delay_cell.Z ),
    .X(\ring.base_delay.stage[242].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[243].delay_cell.impl  (.A(\ring.base_delay.stage[242].delay_cell.Z ),
    .X(\ring.base_delay.stage[243].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[244].delay_cell.impl  (.A(\ring.base_delay.stage[243].delay_cell.Z ),
    .X(\ring.base_delay.stage[244].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[245].delay_cell.impl  (.A(\ring.base_delay.stage[244].delay_cell.Z ),
    .X(\ring.base_delay.stage[245].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[246].delay_cell.impl  (.A(\ring.base_delay.stage[245].delay_cell.Z ),
    .X(\ring.base_delay.stage[246].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[247].delay_cell.impl  (.A(\ring.base_delay.stage[246].delay_cell.Z ),
    .X(\ring.base_delay.stage[247].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[248].delay_cell.impl  (.A(\ring.base_delay.stage[247].delay_cell.Z ),
    .X(\ring.base_delay.stage[248].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[249].delay_cell.impl  (.A(\ring.base_delay.stage[248].delay_cell.Z ),
    .X(\ring.base_delay.stage[249].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[24].delay_cell.impl  (.A(\ring.base_delay.stage[23].delay_cell.Z ),
    .X(\ring.base_delay.stage[24].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[250].delay_cell.impl  (.A(\ring.base_delay.stage[249].delay_cell.Z ),
    .X(\ring.base_delay.stage[250].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[251].delay_cell.impl  (.A(\ring.base_delay.stage[250].delay_cell.Z ),
    .X(\ring.base_delay.stage[251].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[252].delay_cell.impl  (.A(\ring.base_delay.stage[251].delay_cell.Z ),
    .X(\ring.base_delay.stage[252].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[253].delay_cell.impl  (.A(\ring.base_delay.stage[252].delay_cell.Z ),
    .X(\ring.base_delay.stage[253].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[254].delay_cell.impl  (.A(\ring.base_delay.stage[253].delay_cell.Z ),
    .X(\ring.base_delay.stage[254].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[255].delay_cell.impl  (.A(\ring.base_delay.stage[254].delay_cell.Z ),
    .X(\ring.DCO_IN ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[25].delay_cell.impl  (.A(\ring.base_delay.stage[24].delay_cell.Z ),
    .X(\ring.base_delay.stage[25].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[26].delay_cell.impl  (.A(\ring.base_delay.stage[25].delay_cell.Z ),
    .X(\ring.base_delay.stage[26].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[27].delay_cell.impl  (.A(\ring.base_delay.stage[26].delay_cell.Z ),
    .X(\ring.base_delay.stage[27].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[28].delay_cell.impl  (.A(\ring.base_delay.stage[27].delay_cell.Z ),
    .X(\ring.base_delay.stage[28].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[29].delay_cell.impl  (.A(\ring.base_delay.stage[28].delay_cell.Z ),
    .X(\ring.base_delay.stage[29].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[2].delay_cell.impl  (.A(\ring.base_delay.stage[1].delay_cell.Z ),
    .X(\ring.base_delay.stage[2].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[30].delay_cell.impl  (.A(\ring.base_delay.stage[29].delay_cell.Z ),
    .X(\ring.base_delay.stage[30].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[31].delay_cell.impl  (.A(\ring.base_delay.stage[30].delay_cell.Z ),
    .X(\ring.base_delay.stage[31].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[32].delay_cell.impl  (.A(\ring.base_delay.stage[31].delay_cell.Z ),
    .X(\ring.base_delay.stage[32].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[33].delay_cell.impl  (.A(\ring.base_delay.stage[32].delay_cell.Z ),
    .X(\ring.base_delay.stage[33].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[34].delay_cell.impl  (.A(\ring.base_delay.stage[33].delay_cell.Z ),
    .X(\ring.base_delay.stage[34].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[35].delay_cell.impl  (.A(\ring.base_delay.stage[34].delay_cell.Z ),
    .X(\ring.base_delay.stage[35].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[36].delay_cell.impl  (.A(\ring.base_delay.stage[35].delay_cell.Z ),
    .X(\ring.base_delay.stage[36].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[37].delay_cell.impl  (.A(\ring.base_delay.stage[36].delay_cell.Z ),
    .X(\ring.base_delay.stage[37].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[38].delay_cell.impl  (.A(\ring.base_delay.stage[37].delay_cell.Z ),
    .X(\ring.base_delay.stage[38].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[39].delay_cell.impl  (.A(\ring.base_delay.stage[38].delay_cell.Z ),
    .X(\ring.base_delay.stage[39].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[3].delay_cell.impl  (.A(\ring.base_delay.stage[2].delay_cell.Z ),
    .X(\ring.base_delay.stage[3].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[40].delay_cell.impl  (.A(\ring.base_delay.stage[39].delay_cell.Z ),
    .X(\ring.base_delay.stage[40].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[41].delay_cell.impl  (.A(\ring.base_delay.stage[40].delay_cell.Z ),
    .X(\ring.base_delay.stage[41].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[42].delay_cell.impl  (.A(\ring.base_delay.stage[41].delay_cell.Z ),
    .X(\ring.base_delay.stage[42].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[43].delay_cell.impl  (.A(\ring.base_delay.stage[42].delay_cell.Z ),
    .X(\ring.base_delay.stage[43].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[44].delay_cell.impl  (.A(\ring.base_delay.stage[43].delay_cell.Z ),
    .X(\ring.base_delay.stage[44].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[45].delay_cell.impl  (.A(\ring.base_delay.stage[44].delay_cell.Z ),
    .X(\ring.base_delay.stage[45].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[46].delay_cell.impl  (.A(\ring.base_delay.stage[45].delay_cell.Z ),
    .X(\ring.base_delay.stage[46].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[47].delay_cell.impl  (.A(\ring.base_delay.stage[46].delay_cell.Z ),
    .X(\ring.base_delay.stage[47].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[48].delay_cell.impl  (.A(\ring.base_delay.stage[47].delay_cell.Z ),
    .X(\ring.base_delay.stage[48].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[49].delay_cell.impl  (.A(\ring.base_delay.stage[48].delay_cell.Z ),
    .X(\ring.base_delay.stage[49].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[4].delay_cell.impl  (.A(\ring.base_delay.stage[3].delay_cell.Z ),
    .X(\ring.base_delay.stage[4].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[50].delay_cell.impl  (.A(\ring.base_delay.stage[49].delay_cell.Z ),
    .X(\ring.base_delay.stage[50].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[51].delay_cell.impl  (.A(\ring.base_delay.stage[50].delay_cell.Z ),
    .X(\ring.base_delay.stage[51].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[52].delay_cell.impl  (.A(\ring.base_delay.stage[51].delay_cell.Z ),
    .X(\ring.base_delay.stage[52].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[53].delay_cell.impl  (.A(\ring.base_delay.stage[52].delay_cell.Z ),
    .X(\ring.base_delay.stage[53].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[54].delay_cell.impl  (.A(\ring.base_delay.stage[53].delay_cell.Z ),
    .X(\ring.base_delay.stage[54].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[55].delay_cell.impl  (.A(\ring.base_delay.stage[54].delay_cell.Z ),
    .X(\ring.base_delay.stage[55].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[56].delay_cell.impl  (.A(\ring.base_delay.stage[55].delay_cell.Z ),
    .X(\ring.base_delay.stage[56].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[57].delay_cell.impl  (.A(\ring.base_delay.stage[56].delay_cell.Z ),
    .X(\ring.base_delay.stage[57].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[58].delay_cell.impl  (.A(\ring.base_delay.stage[57].delay_cell.Z ),
    .X(\ring.base_delay.stage[58].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[59].delay_cell.impl  (.A(\ring.base_delay.stage[58].delay_cell.Z ),
    .X(\ring.base_delay.stage[59].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[5].delay_cell.impl  (.A(\ring.base_delay.stage[4].delay_cell.Z ),
    .X(\ring.base_delay.stage[5].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[60].delay_cell.impl  (.A(\ring.base_delay.stage[59].delay_cell.Z ),
    .X(\ring.base_delay.stage[60].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[61].delay_cell.impl  (.A(\ring.base_delay.stage[60].delay_cell.Z ),
    .X(\ring.base_delay.stage[61].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[62].delay_cell.impl  (.A(\ring.base_delay.stage[61].delay_cell.Z ),
    .X(\ring.base_delay.stage[62].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[63].delay_cell.impl  (.A(\ring.base_delay.stage[62].delay_cell.Z ),
    .X(\ring.base_delay.stage[63].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[64].delay_cell.impl  (.A(\ring.base_delay.stage[63].delay_cell.Z ),
    .X(\ring.base_delay.stage[64].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[65].delay_cell.impl  (.A(\ring.base_delay.stage[64].delay_cell.Z ),
    .X(\ring.base_delay.stage[65].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[66].delay_cell.impl  (.A(\ring.base_delay.stage[65].delay_cell.Z ),
    .X(\ring.base_delay.stage[66].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[67].delay_cell.impl  (.A(\ring.base_delay.stage[66].delay_cell.Z ),
    .X(\ring.base_delay.stage[67].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[68].delay_cell.impl  (.A(\ring.base_delay.stage[67].delay_cell.Z ),
    .X(\ring.base_delay.stage[68].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[69].delay_cell.impl  (.A(\ring.base_delay.stage[68].delay_cell.Z ),
    .X(\ring.base_delay.stage[69].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[6].delay_cell.impl  (.A(\ring.base_delay.stage[5].delay_cell.Z ),
    .X(\ring.base_delay.stage[6].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[70].delay_cell.impl  (.A(\ring.base_delay.stage[69].delay_cell.Z ),
    .X(\ring.base_delay.stage[70].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[71].delay_cell.impl  (.A(\ring.base_delay.stage[70].delay_cell.Z ),
    .X(\ring.base_delay.stage[71].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[72].delay_cell.impl  (.A(\ring.base_delay.stage[71].delay_cell.Z ),
    .X(\ring.base_delay.stage[72].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[73].delay_cell.impl  (.A(\ring.base_delay.stage[72].delay_cell.Z ),
    .X(\ring.base_delay.stage[73].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[74].delay_cell.impl  (.A(\ring.base_delay.stage[73].delay_cell.Z ),
    .X(\ring.base_delay.stage[74].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[75].delay_cell.impl  (.A(\ring.base_delay.stage[74].delay_cell.Z ),
    .X(\ring.base_delay.stage[75].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[76].delay_cell.impl  (.A(\ring.base_delay.stage[75].delay_cell.Z ),
    .X(\ring.base_delay.stage[76].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[77].delay_cell.impl  (.A(\ring.base_delay.stage[76].delay_cell.Z ),
    .X(\ring.base_delay.stage[77].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[78].delay_cell.impl  (.A(\ring.base_delay.stage[77].delay_cell.Z ),
    .X(\ring.base_delay.stage[78].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[79].delay_cell.impl  (.A(\ring.base_delay.stage[78].delay_cell.Z ),
    .X(\ring.base_delay.stage[79].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[7].delay_cell.impl  (.A(\ring.base_delay.stage[6].delay_cell.Z ),
    .X(\ring.base_delay.stage[7].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[80].delay_cell.impl  (.A(\ring.base_delay.stage[79].delay_cell.Z ),
    .X(\ring.base_delay.stage[80].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[81].delay_cell.impl  (.A(\ring.base_delay.stage[80].delay_cell.Z ),
    .X(\ring.base_delay.stage[81].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[82].delay_cell.impl  (.A(\ring.base_delay.stage[81].delay_cell.Z ),
    .X(\ring.base_delay.stage[82].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[83].delay_cell.impl  (.A(\ring.base_delay.stage[82].delay_cell.Z ),
    .X(\ring.base_delay.stage[83].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[84].delay_cell.impl  (.A(\ring.base_delay.stage[83].delay_cell.Z ),
    .X(\ring.base_delay.stage[84].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[85].delay_cell.impl  (.A(\ring.base_delay.stage[84].delay_cell.Z ),
    .X(\ring.base_delay.stage[85].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[86].delay_cell.impl  (.A(\ring.base_delay.stage[85].delay_cell.Z ),
    .X(\ring.base_delay.stage[86].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[87].delay_cell.impl  (.A(\ring.base_delay.stage[86].delay_cell.Z ),
    .X(\ring.base_delay.stage[87].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[88].delay_cell.impl  (.A(\ring.base_delay.stage[87].delay_cell.Z ),
    .X(\ring.base_delay.stage[88].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[89].delay_cell.impl  (.A(\ring.base_delay.stage[88].delay_cell.Z ),
    .X(\ring.base_delay.stage[89].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[8].delay_cell.impl  (.A(\ring.base_delay.stage[7].delay_cell.Z ),
    .X(\ring.base_delay.stage[8].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[90].delay_cell.impl  (.A(\ring.base_delay.stage[89].delay_cell.Z ),
    .X(\ring.base_delay.stage[90].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[91].delay_cell.impl  (.A(\ring.base_delay.stage[90].delay_cell.Z ),
    .X(\ring.base_delay.stage[91].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[92].delay_cell.impl  (.A(\ring.base_delay.stage[91].delay_cell.Z ),
    .X(\ring.base_delay.stage[92].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[93].delay_cell.impl  (.A(\ring.base_delay.stage[92].delay_cell.Z ),
    .X(\ring.base_delay.stage[93].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[94].delay_cell.impl  (.A(\ring.base_delay.stage[93].delay_cell.Z ),
    .X(\ring.base_delay.stage[94].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[95].delay_cell.impl  (.A(\ring.base_delay.stage[94].delay_cell.Z ),
    .X(\ring.base_delay.stage[95].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[96].delay_cell.impl  (.A(\ring.base_delay.stage[95].delay_cell.Z ),
    .X(\ring.base_delay.stage[96].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[97].delay_cell.impl  (.A(\ring.base_delay.stage[96].delay_cell.Z ),
    .X(\ring.base_delay.stage[97].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[98].delay_cell.impl  (.A(\ring.base_delay.stage[97].delay_cell.Z ),
    .X(\ring.base_delay.stage[98].delay_cell.Z ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[99].delay_cell.impl  (.A(\ring.base_delay.stage[98].delay_cell.Z ),
    .X(\ring.base_delay.stage[100].delay_cell.I ));
 sky130_fd_sc_hd__buf_2 \ring.base_delay.stage[9].delay_cell.impl  (.A(\ring.base_delay.stage[8].delay_cell.Z ),
    .X(\ring.base_delay.stage[10].delay_cell.I ));
 sky130_fd_sc_hd__buf_2 \ring.coarse.impl_last.impl  (.A(\ring.coarse.impl_last.I ),
    .X(\ring.coarse.impl_last.Z ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[0].impl.dwn.impl  (.A(\ring.coarse.stage[0].impl.PATH_0 ),
    .B(\ring.coarse.stage[0].impl.CHAIN_IN ),
    .Y(\ring.COARSE_OUT ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[0].impl.mid.impl  (.A_N(net1),
    .B(\ring.DCO_IN ),
    .Y(\ring.coarse.stage[0].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[0].impl.upp.impl  (.A(net1),
    .B(\ring.DCO_IN ),
    .Y(\ring.coarse.stage[0].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[10].impl.dwn.impl  (.A(\ring.coarse.stage[10].impl.PATH_0 ),
    .B(\ring.coarse.stage[10].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[10].impl.OUT ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[10].impl.mid.impl  (.A_N(net2),
    .B(\ring.coarse.stage[10].impl.IN ),
    .Y(\ring.coarse.stage[10].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[10].impl.upp.impl  (.A(net2),
    .B(\ring.coarse.stage[10].impl.IN ),
    .Y(\ring.coarse.stage[10].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[11].impl.dwn.impl  (.A(\ring.coarse.stage[11].impl.PATH_0 ),
    .B(\ring.coarse.stage[11].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[10].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[11].impl.mid.impl  (.A_N(net3),
    .B(\ring.coarse.stage[10].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[11].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[11].impl.upp.impl  (.A(net3),
    .B(\ring.coarse.stage[10].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[11].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[12].impl.dwn.impl  (.A(\ring.coarse.stage[12].impl.PATH_0 ),
    .B(\ring.coarse.stage[12].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[11].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[12].impl.mid.impl  (.A_N(net4),
    .B(\ring.coarse.stage[11].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[12].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[12].impl.upp.impl  (.A(net4),
    .B(\ring.coarse.stage[11].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[12].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[13].impl.dwn.impl  (.A(\ring.coarse.stage[13].impl.PATH_0 ),
    .B(\ring.coarse.stage[13].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[12].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[13].impl.mid.impl  (.A_N(net5),
    .B(\ring.coarse.stage[12].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[13].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[13].impl.upp.impl  (.A(net5),
    .B(\ring.coarse.stage[12].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[13].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[14].impl.dwn.impl  (.A(\ring.coarse.stage[14].impl.PATH_0 ),
    .B(\ring.coarse.impl_last.Z ),
    .Y(\ring.coarse.stage[13].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[14].impl.mid.impl  (.A_N(net6),
    .B(\ring.coarse.stage[13].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[14].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[14].impl.upp.impl  (.A(net6),
    .B(\ring.coarse.stage[13].impl.CHAIN_OUT ),
    .Y(\ring.coarse.impl_last.I ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[1].impl.dwn.impl  (.A(\ring.coarse.stage[1].impl.PATH_0 ),
    .B(\ring.coarse.stage[1].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[0].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[1].impl.mid.impl  (.A_N(net7),
    .B(\ring.coarse.stage[0].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[1].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[1].impl.upp.impl  (.A(net7),
    .B(\ring.coarse.stage[0].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[1].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[2].impl.dwn.impl  (.A(\ring.coarse.stage[2].impl.PATH_0 ),
    .B(\ring.coarse.stage[2].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[1].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[2].impl.mid.impl  (.A_N(net8),
    .B(\ring.coarse.stage[1].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[2].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[2].impl.upp.impl  (.A(net8),
    .B(\ring.coarse.stage[1].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[2].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[3].impl.dwn.impl  (.A(\ring.coarse.stage[3].impl.PATH_0 ),
    .B(\ring.coarse.stage[3].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[2].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[3].impl.mid.impl  (.A_N(net9),
    .B(\ring.coarse.stage[2].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[3].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[3].impl.upp.impl  (.A(net9),
    .B(\ring.coarse.stage[2].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[3].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[4].impl.dwn.impl  (.A(\ring.coarse.stage[4].impl.PATH_0 ),
    .B(\ring.coarse.stage[4].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[3].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[4].impl.mid.impl  (.A_N(net10),
    .B(\ring.coarse.stage[3].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[4].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[4].impl.upp.impl  (.A(net10),
    .B(\ring.coarse.stage[3].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[4].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[5].impl.dwn.impl  (.A(\ring.coarse.stage[5].impl.PATH_0 ),
    .B(\ring.coarse.stage[5].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[4].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[5].impl.mid.impl  (.A_N(net11),
    .B(\ring.coarse.stage[4].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[5].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[5].impl.upp.impl  (.A(net11),
    .B(\ring.coarse.stage[4].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[5].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[6].impl.dwn.impl  (.A(\ring.coarse.stage[6].impl.PATH_0 ),
    .B(\ring.coarse.stage[6].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[5].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[6].impl.mid.impl  (.A_N(net12),
    .B(\ring.coarse.stage[5].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[6].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[6].impl.upp.impl  (.A(net12),
    .B(\ring.coarse.stage[5].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[6].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[7].impl.dwn.impl  (.A(\ring.coarse.stage[7].impl.PATH_0 ),
    .B(\ring.coarse.stage[7].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[6].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[7].impl.mid.impl  (.A_N(net13),
    .B(\ring.coarse.stage[6].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[7].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[7].impl.upp.impl  (.A(net13),
    .B(\ring.coarse.stage[6].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[7].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[8].impl.dwn.impl  (.A(\ring.coarse.stage[8].impl.PATH_0 ),
    .B(\ring.coarse.stage[8].impl.CHAIN_IN ),
    .Y(\ring.coarse.stage[7].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[8].impl.mid.impl  (.A_N(net14),
    .B(\ring.coarse.stage[7].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[8].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[8].impl.upp.impl  (.A(net14),
    .B(\ring.coarse.stage[7].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[8].impl.CHAIN_OUT ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[9].impl.dwn.impl  (.A(\ring.coarse.stage[9].impl.PATH_0 ),
    .B(\ring.coarse.stage[10].impl.OUT ),
    .Y(\ring.coarse.stage[8].impl.CHAIN_IN ));
 sky130_fd_sc_hd__nand2b_2 \ring.coarse.stage[9].impl.mid.impl  (.A_N(net15),
    .B(\ring.coarse.stage[8].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[9].impl.PATH_0 ));
 sky130_fd_sc_hd__nand2_2 \ring.coarse.stage[9].impl.upp.impl  (.A(net15),
    .B(\ring.coarse.stage[8].impl.CHAIN_OUT ),
    .Y(\ring.coarse.stage[10].impl.IN ));
 sky130_fd_sc_hd__dfxtp_2 \ring.dff_x.impl  (.CLK(\ring.dff_x.CKN_B ),
    .D(\ring.dff_x.D ),
    .Q(\ring.dff_x.Q ));
 sky130_fd_sc_hd__inv_2 \ring.dff_x.inv_ck.impl  (.A(REF),
    .Y(\ring.dff_x.CKN_B ));
 sky130_fd_sc_hd__dfxtp_2 \ring.dff_y.impl  (.CLK(\ring.dff_y.CKN_B ),
    .D(\ring.dff_y.D ),
    .Q(\ring.dff_y.Q ));
 sky130_fd_sc_hd__inv_2 \ring.dff_y.inv_ck.impl  (.A(REF),
    .Y(\ring.dff_y.CKN_B ));
 sky130_fd_sc_hd__inv_6 \ring.fine.inv_0.impl  (.A(net64),
    .Y(\ring.fine.LOAD ));
 sky130_fd_sc_hd__inv_6 \ring.fine.inv_1.impl  (.A(\ring.fine.LOAD ),
    .Y(\ring.FINE_OUT ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[0].dyn.impl  (.A(net17),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[0].dyn.A2 ),
    .Y(\ring.fine.stage[0].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[0].inv_b.impl  (.A(net17),
    .Y(\ring.fine.stage[0].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[10].dyn.impl  (.A(net18),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[10].dyn.A2 ),
    .Y(\ring.fine.stage[10].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[10].inv_b.impl  (.A(net18),
    .Y(\ring.fine.stage[10].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[11].dyn.impl  (.A(net19),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[11].dyn.A2 ),
    .Y(\ring.fine.stage[11].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[11].inv_b.impl  (.A(net19),
    .Y(\ring.fine.stage[11].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[12].dyn.impl  (.A(net20),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[12].dyn.A2 ),
    .Y(\ring.fine.stage[12].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[12].inv_b.impl  (.A(net20),
    .Y(\ring.fine.stage[12].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[13].dyn.impl  (.A(net21),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[13].dyn.A2 ),
    .Y(\ring.fine.stage[13].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[13].inv_b.impl  (.A(net21),
    .Y(\ring.fine.stage[13].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[14].dyn.impl  (.A(net22),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[14].dyn.A2 ),
    .Y(\ring.fine.stage[14].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[14].inv_b.impl  (.A(net22),
    .Y(\ring.fine.stage[14].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[15].dyn.impl  (.A(net23),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[15].dyn.A2 ),
    .Y(\ring.fine.stage[15].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[15].inv_b.impl  (.A(net23),
    .Y(\ring.fine.stage[15].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[16].dyn.impl  (.A(net24),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[16].dyn.A2 ),
    .Y(\ring.fine.stage[16].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[16].inv_b.impl  (.A(net24),
    .Y(\ring.fine.stage[16].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[17].dyn.impl  (.A(net25),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[17].dyn.A2 ),
    .Y(\ring.fine.stage[17].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[17].inv_b.impl  (.A(net25),
    .Y(\ring.fine.stage[17].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[18].dyn.impl  (.A(net26),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[18].dyn.A2 ),
    .Y(\ring.fine.stage[18].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[18].inv_b.impl  (.A(net26),
    .Y(\ring.fine.stage[18].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[19].dyn.impl  (.A(net27),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[19].dyn.A2 ),
    .Y(\ring.fine.stage[19].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[19].inv_b.impl  (.A(net27),
    .Y(\ring.fine.stage[19].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[1].dyn.impl  (.A(net28),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[1].dyn.A2 ),
    .Y(\ring.fine.stage[1].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[1].inv_b.impl  (.A(net28),
    .Y(\ring.fine.stage[1].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[20].dyn.impl  (.A(net29),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[20].dyn.A2 ),
    .Y(\ring.fine.stage[20].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[20].inv_b.impl  (.A(net29),
    .Y(\ring.fine.stage[20].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[21].dyn.impl  (.A(net30),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[21].dyn.A2 ),
    .Y(\ring.fine.stage[21].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[21].inv_b.impl  (.A(net30),
    .Y(\ring.fine.stage[21].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[22].dyn.impl  (.A(net31),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[22].dyn.A2 ),
    .Y(\ring.fine.stage[22].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[22].inv_b.impl  (.A(net31),
    .Y(\ring.fine.stage[22].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[23].dyn.impl  (.A(net32),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[23].dyn.A2 ),
    .Y(\ring.fine.stage[23].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[23].inv_b.impl  (.A(net32),
    .Y(\ring.fine.stage[23].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[24].dyn.impl  (.A(net33),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[24].dyn.A2 ),
    .Y(\ring.fine.stage[24].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[24].inv_b.impl  (.A(net33),
    .Y(\ring.fine.stage[24].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[25].dyn.impl  (.A(net34),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[25].dyn.A2 ),
    .Y(\ring.fine.stage[25].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[25].inv_b.impl  (.A(net34),
    .Y(\ring.fine.stage[25].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[26].dyn.impl  (.A(net35),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[26].dyn.A2 ),
    .Y(\ring.fine.stage[26].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[26].inv_b.impl  (.A(net35),
    .Y(\ring.fine.stage[26].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[27].dyn.impl  (.A(net36),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[27].dyn.A2 ),
    .Y(\ring.fine.stage[27].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[27].inv_b.impl  (.A(net36),
    .Y(\ring.fine.stage[27].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[28].dyn.impl  (.A(net37),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[28].dyn.A2 ),
    .Y(\ring.fine.stage[28].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[28].inv_b.impl  (.A(net37),
    .Y(\ring.fine.stage[28].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[29].dyn.impl  (.A(net38),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[29].dyn.A2 ),
    .Y(\ring.fine.stage[29].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[29].inv_b.impl  (.A(net38),
    .Y(\ring.fine.stage[29].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[2].dyn.impl  (.A(net39),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[2].dyn.A2 ),
    .Y(\ring.fine.stage[2].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[2].inv_b.impl  (.A(net39),
    .Y(\ring.fine.stage[2].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[30].dyn.impl  (.A(net40),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[30].dyn.A2 ),
    .Y(\ring.fine.stage[30].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[30].inv_b.impl  (.A(net40),
    .Y(\ring.fine.stage[30].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[3].dyn.impl  (.A(net41),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[3].dyn.A2 ),
    .Y(\ring.fine.stage[3].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[3].inv_b.impl  (.A(net41),
    .Y(\ring.fine.stage[3].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[4].dyn.impl  (.A(net42),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[4].dyn.A2 ),
    .Y(\ring.fine.stage[4].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[4].inv_b.impl  (.A(net42),
    .Y(\ring.fine.stage[4].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[5].dyn.impl  (.A(net43),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[5].dyn.A2 ),
    .Y(\ring.fine.stage[5].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[5].inv_b.impl  (.A(net43),
    .Y(\ring.fine.stage[5].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[6].dyn.impl  (.A(net44),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[6].dyn.A2 ),
    .Y(\ring.fine.stage[6].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[6].inv_b.impl  (.A(net44),
    .Y(\ring.fine.stage[6].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[7].dyn.impl  (.A(net45),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[7].dyn.A2 ),
    .Y(\ring.fine.stage[7].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[7].inv_b.impl  (.A(net45),
    .Y(\ring.fine.stage[7].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[8].dyn.impl  (.A(net46),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[8].dyn.A2 ),
    .Y(\ring.fine.stage[8].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[8].inv_b.impl  (.A(net46),
    .Y(\ring.fine.stage[8].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.fine.stage[9].dyn.impl  (.A(net47),
    .B(\ring.fine.LOAD ),
    .C(\ring.fine.stage[9].dyn.A2 ),
    .Y(\ring.fine.stage[9].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.fine.stage[9].inv_b.impl  (.A(net47),
    .Y(\ring.fine.stage[9].dyn.A2 ));
 sky130_fd_sc_hd__inv_4 \ring.mid.inv_0.impl  (.A(\ring.COARSE_OUT ),
    .Y(\ring.mid.LOAD ));
 sky130_fd_sc_hd__inv_4 \ring.mid.inv_1.impl  (.A(\ring.mid.LOAD ),
    .Y(net64));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[0].dyn.impl  (.A(net48),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[0].dyn.A2 ),
    .Y(\ring.mid.stage[0].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[0].inv_b.impl  (.A(net48),
    .Y(\ring.mid.stage[0].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[10].dyn.impl  (.A(net49),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[10].dyn.A2 ),
    .Y(\ring.mid.stage[10].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[10].inv_b.impl  (.A(net49),
    .Y(\ring.mid.stage[10].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[11].dyn.impl  (.A(net50),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[11].dyn.A2 ),
    .Y(\ring.mid.stage[11].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[11].inv_b.impl  (.A(net50),
    .Y(\ring.mid.stage[11].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[12].dyn.impl  (.A(net51),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[12].dyn.A2 ),
    .Y(\ring.mid.stage[12].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[12].inv_b.impl  (.A(net51),
    .Y(\ring.mid.stage[12].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[13].dyn.impl  (.A(net52),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[13].dyn.A2 ),
    .Y(\ring.mid.stage[13].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[13].inv_b.impl  (.A(net52),
    .Y(\ring.mid.stage[13].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[14].dyn.impl  (.A(net53),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[14].dyn.A2 ),
    .Y(\ring.mid.stage[14].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[14].inv_b.impl  (.A(net53),
    .Y(\ring.mid.stage[14].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[1].dyn.impl  (.A(net54),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[1].dyn.A2 ),
    .Y(\ring.mid.stage[1].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[1].inv_b.impl  (.A(net54),
    .Y(\ring.mid.stage[1].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[2].dyn.impl  (.A(net55),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[2].dyn.A2 ),
    .Y(\ring.mid.stage[2].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[2].inv_b.impl  (.A(net55),
    .Y(\ring.mid.stage[2].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[3].dyn.impl  (.A(net56),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[3].dyn.A2 ),
    .Y(\ring.mid.stage[3].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[3].inv_b.impl  (.A(net56),
    .Y(\ring.mid.stage[3].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[4].dyn.impl  (.A(net57),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[4].dyn.A2 ),
    .Y(\ring.mid.stage[4].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[4].inv_b.impl  (.A(net57),
    .Y(\ring.mid.stage[4].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[5].dyn.impl  (.A(net58),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[5].dyn.A2 ),
    .Y(\ring.mid.stage[5].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[5].inv_b.impl  (.A(net58),
    .Y(\ring.mid.stage[5].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[6].dyn.impl  (.A(net59),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[6].dyn.A2 ),
    .Y(\ring.mid.stage[6].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[6].inv_b.impl  (.A(net59),
    .Y(\ring.mid.stage[6].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[7].dyn.impl  (.A(net60),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[7].dyn.A2 ),
    .Y(\ring.mid.stage[7].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[7].inv_b.impl  (.A(net60),
    .Y(\ring.mid.stage[7].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[8].dyn.impl  (.A(net61),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[8].dyn.A2 ),
    .Y(\ring.mid.stage[8].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[8].inv_b.impl  (.A(net61),
    .Y(\ring.mid.stage[8].dyn.A2 ));
 sky130_fd_sc_hd__nand3_2 \ring.mid.stage[9].dyn.impl  (.A(net62),
    .B(\ring.mid.LOAD ),
    .C(\ring.mid.stage[9].dyn.A2 ),
    .Y(\ring.mid.stage[9].dyn.ZN ));
 sky130_fd_sc_hd__inv_2 \ring.mid.stage[9].inv_b.impl  (.A(net62),
    .Y(\ring.mid.stage[9].dyn.A2 ));
 sky130_fd_sc_hd__inv_2 \ring.sym.inj_dummy_inv.impl  (.A(\ring.sym.INJ_EDGE_BALANCED ),
    .Y(\ring.sym.INJ_DUMMY ));
 sky130_fd_sc_hd__inv_2 \ring.sym.inj_slope_balancer.impl  (.A(REF),
    .Y(\ring.sym.INJ_EDGE_BALANCED ));
 sky130_fd_sc_hd__inv_2 \ring.sym.osc_dummy_inv.impl  (.A(\ring.sym.OSC_BALANCED ),
    .Y(\ring.sym.OSC_DUMMY ));
 sky130_fd_sc_hd__inv_2 \ring.sym.osc_slope_balancer.impl  (.A(\ring.FINE_OUT ),
    .Y(\ring.sym.OSC_BALANCED ));
 sky130_fd_sc_hd__buf_2 \ring.sym.ssbbpd_impl.buf_nand_x.impl  (.A(\ring.sym.ssbbpd_impl.OUT_NANDX ),
    .X(\ring.dff_x.D ));
 sky130_fd_sc_hd__buf_2 \ring.sym.ssbbpd_impl.buf_nand_y.impl  (.A(\ring.sym.ssbbpd_impl.OUT_NANDY ),
    .X(\ring.dff_y.D ));
 sky130_fd_sc_hd__nand2_2 \ring.sym.ssbbpd_impl.nand_x.impl  (.A(\ring.sym.OSC_BALANCED ),
    .B(\ring.sym.ssbbpd_impl.OUT_NANDY ),
    .Y(\ring.sym.ssbbpd_impl.OUT_NANDX ));
 sky130_fd_sc_hd__nand2_2 \ring.sym.ssbbpd_impl.nand_y.impl  (.A(\ring.sym.INJ_EDGE_BALANCED ),
    .B(\ring.sym.ssbbpd_impl.OUT_NANDX ),
    .Y(\ring.sym.ssbbpd_impl.OUT_NANDY ));
 sky130_fd_sc_hd__nand2_2 \ring.sym.sym_mux.nand_inj.impl  (.A(\ring.sym.OSC_BALANCED ),
    .B(\ring.sym.sym_mux.DCO_EN_INJ_WIN ),
    .Y(\ring.sym.sym_mux.OSC_INJ ));
 sky130_fd_sc_hd__nand2_2 \ring.sym.sym_mux.nand_pll.impl  (.A(\ring.sym.sym_mux.REF_INJ ),
    .B(\ring.sym.sym_mux.OSC_INJ ),
    .Y(OUT));
 sky130_fd_sc_hd__nand2b_2 \ring.sym.sym_mux.nand_ref.impl  (.A_N(\ring.sym.INJ_EDGE_BALANCED ),
    .B(net),
    .Y(\ring.sym.sym_mux.REF_INJ ));
 sky130_fd_sc_hd__conb_1 \ring.sym.sym_mux.nand_ref.impl_67  (.LO(net));
 sky130_fd_sc_hd__nor2b_2 \ring.sym.sym_mux.norb_en_inj.impl  (.A(net16),
    .B_N(net67),
    .Y(\ring.sym.sym_mux.DCO_EN_INJ_WIN ));
 sky130_fd_sc_hd__conb_1 \ring.sym.sym_mux.norb_en_inj.impl_68  (.LO(net67));
endmodule
