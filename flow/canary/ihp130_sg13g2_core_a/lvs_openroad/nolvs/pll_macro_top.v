module pll_macro_top (CK,
    DSM_EN_DT,
    DSM_EN_SHDT,
    ERR,
    INJ_EN,
    LOAD_DIV,
    LOCKED,
    OUT,
    OUT_DIV,
    REF,
    RST_N,
    DSM_ORDER[0],
    DSM_ORDER[1],
    FCW[0],
    FCW[1],
    FCW[2],
    FCW[3],
    FCW[4],
    FCW[5],
    FCW[6],
    FCW[7],
    KI[0],
    KI[1],
    KI[2],
    KI[3],
    KI[4],
    KI[5],
    KI[6],
    KI[7],
    KI[8],
    KI[9],
    KI[10],
    KI[11],
    KI[12],
    KI[13],
    KI[14],
    KI[15],
    KP[0],
    KP[1],
    KP[2],
    KP[3],
    KP[4],
    KP[5],
    KP[6],
    KP[7],
    KP[8],
    KP[9],
    KP[10],
    KP[11],
    KP[12],
    KP[13],
    KP[14],
    KP[15],
    SET_DIV[0],
    SET_DIV[1],
    SET_DIV[2],
    SET_DIV[3],
    SET_DIV[4],
    SET_DIV[5],
    SET_DIV[6],
    SET_DIV[7]);
 output CK;
 input DSM_EN_DT;
 input DSM_EN_SHDT;
 output ERR;
 input INJ_EN;
 input LOAD_DIV;
 output LOCKED;
 output OUT;
 output OUT_DIV;
 input REF;
 input RST_N;
 input [1:0] DSM_ORDER;
 input DSM_ORDER[0];
 input DSM_ORDER[1];
 input [7:0] FCW;
 input FCW[0];
 input FCW[1];
 input FCW[2];
 input FCW[3];
 input FCW[4];
 input FCW[5];
 input FCW[6];
 input FCW[7];
 input [15:0] KI;
 input KI[0];
 input KI[1];
 input KI[2];
 input KI[3];
 input KI[4];
 input KI[5];
 input KI[6];
 input KI[7];
 input KI[8];
 input KI[9];
 input KI[10];
 input KI[11];
 input KI[12];
 input KI[13];
 input KI[14];
 input KI[15];
 input [15:0] KP;
 input KP[0];
 input KP[1];
 input KP[2];
 input KP[3];
 input KP[4];
 input KP[5];
 input KP[6];
 input KP[7];
 input KP[8];
 input KP[9];
 input KP[10];
 input KP[11];
 input KP[12];
 input KP[13];
 input KP[14];
 input KP[15];
 input [7:0] SET_DIV;
 input SET_DIV[0];
 input SET_DIV[1];
 input SET_DIV[2];
 input SET_DIV[3];
 input SET_DIV[4];
 input SET_DIV[5];
 input SET_DIV[6];
 input SET_DIV[7];

 wire net56;
 wire \COARSE_MUX[0] ;
 wire \COARSE_MUX[10] ;
 wire \COARSE_MUX[11] ;
 wire \COARSE_MUX[12] ;
 wire \COARSE_MUX[13] ;
 wire \COARSE_MUX[14] ;
 wire \COARSE_MUX[1] ;
 wire \COARSE_MUX[2] ;
 wire \COARSE_MUX[3] ;
 wire \COARSE_MUX[4] ;
 wire \COARSE_MUX[5] ;
 wire \COARSE_MUX[6] ;
 wire \COARSE_MUX[7] ;
 wire \COARSE_MUX[8] ;
 wire \COARSE_MUX[9] ;
 wire DCO_EN;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net57;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire net10;
 wire net11;
 wire net12;
 wire \FINE_MUX[0] ;
 wire \FINE_MUX[10] ;
 wire \FINE_MUX[11] ;
 wire \FINE_MUX[12] ;
 wire \FINE_MUX[13] ;
 wire \FINE_MUX[14] ;
 wire \FINE_MUX[15] ;
 wire \FINE_MUX[16] ;
 wire \FINE_MUX[17] ;
 wire \FINE_MUX[18] ;
 wire \FINE_MUX[19] ;
 wire \FINE_MUX[1] ;
 wire \FINE_MUX[20] ;
 wire \FINE_MUX[21] ;
 wire \FINE_MUX[22] ;
 wire \FINE_MUX[23] ;
 wire \FINE_MUX[24] ;
 wire \FINE_MUX[25] ;
 wire \FINE_MUX[26] ;
 wire \FINE_MUX[27] ;
 wire \FINE_MUX[28] ;
 wire \FINE_MUX[29] ;
 wire \FINE_MUX[2] ;
 wire \FINE_MUX[30] ;
 wire \FINE_MUX[3] ;
 wire \FINE_MUX[4] ;
 wire \FINE_MUX[5] ;
 wire \FINE_MUX[6] ;
 wire \FINE_MUX[7] ;
 wire \FINE_MUX[8] ;
 wire \FINE_MUX[9] ;
 wire INJ_EDGE;
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
 wire net58;
 wire \MID_MUX[0] ;
 wire \MID_MUX[10] ;
 wire \MID_MUX[11] ;
 wire \MID_MUX[12] ;
 wire \MID_MUX[13] ;
 wire \MID_MUX[14] ;
 wire \MID_MUX[1] ;
 wire \MID_MUX[2] ;
 wire \MID_MUX[3] ;
 wire \MID_MUX[4] ;
 wire \MID_MUX[5] ;
 wire \MID_MUX[6] ;
 wire \MID_MUX[7] ;
 wire \MID_MUX[8] ;
 wire \MID_MUX[9] ;
 wire MID_OUT;
 wire net59;
 wire net60;
 wire net47;
 wire net48;
 wire net49;
 wire net50;
 wire net51;
 wire net52;
 wire net53;
 wire net54;
 wire net55;
 wire \SS_BBPD[0] ;
 wire \SS_BBPD[1] ;
 wire _0000_;
 wire _0001_;
 wire _0002_;
 wire _0003_;
 wire _0004_;
 wire _0005_;
 wire _0006_;
 wire _0007_;
 wire _0008_;
 wire _0009_;
 wire net353;
 wire _0011_;
 wire _0012_;
 wire _0013_;
 wire _0014_;
 wire _0015_;
 wire _0016_;
 wire _0017_;
 wire _0018_;
 wire _0019_;
 wire _0020_;
 wire _0021_;
 wire _0022_;
 wire _0023_;
 wire _0024_;
 wire _0025_;
 wire _0026_;
 wire _0027_;
 wire _0028_;
 wire _0029_;
 wire _0030_;
 wire _0031_;
 wire _0032_;
 wire _0033_;
 wire _0034_;
 wire _0035_;
 wire _0036_;
 wire _0037_;
 wire _0038_;
 wire _0039_;
 wire _0040_;
 wire _0041_;
 wire _0042_;
 wire _0043_;
 wire _0044_;
 wire _0045_;
 wire _0046_;
 wire _0047_;
 wire _0048_;
 wire _0049_;
 wire _0050_;
 wire _0051_;
 wire _0052_;
 wire _0053_;
 wire net244;
 wire _0055_;
 wire _0056_;
 wire _0057_;
 wire _0058_;
 wire _0059_;
 wire _0060_;
 wire net245;
 wire _0062_;
 wire _0063_;
 wire _0064_;
 wire _0065_;
 wire _0066_;
 wire _0067_;
 wire _0068_;
 wire _0069_;
 wire _0070_;
 wire _0071_;
 wire _0072_;
 wire _0073_;
 wire _0074_;
 wire _0075_;
 wire _0076_;
 wire _0077_;
 wire _0078_;
 wire _0079_;
 wire _0080_;
 wire _0081_;
 wire _0082_;
 wire _0083_;
 wire _0084_;
 wire _0085_;
 wire _0086_;
 wire _0087_;
 wire _0088_;
 wire _0089_;
 wire _0090_;
 wire _0091_;
 wire _0092_;
 wire _0093_;
 wire _0094_;
 wire _0095_;
 wire _0096_;
 wire _0097_;
 wire _0098_;
 wire _0099_;
 wire _0100_;
 wire _0101_;
 wire _0102_;
 wire _0103_;
 wire _0104_;
 wire _0105_;
 wire _0106_;
 wire _0107_;
 wire _0108_;
 wire _0109_;
 wire _0110_;
 wire _0111_;
 wire _0112_;
 wire _0113_;
 wire _0114_;
 wire _0115_;
 wire _0116_;
 wire _0117_;
 wire _0118_;
 wire _0119_;
 wire _0120_;
 wire _0121_;
 wire _0122_;
 wire _0123_;
 wire _0124_;
 wire _0125_;
 wire _0126_;
 wire _0127_;
 wire _0128_;
 wire _0129_;
 wire _0130_;
 wire _0131_;
 wire _0132_;
 wire _0133_;
 wire _0134_;
 wire _0135_;
 wire _0136_;
 wire _0137_;
 wire _0138_;
 wire _0139_;
 wire _0140_;
 wire _0141_;
 wire _0142_;
 wire _0143_;
 wire _0144_;
 wire _0145_;
 wire _0146_;
 wire _0147_;
 wire _0148_;
 wire _0149_;
 wire _0150_;
 wire _0151_;
 wire _0152_;
 wire _0153_;
 wire _0154_;
 wire _0155_;
 wire _0156_;
 wire _0157_;
 wire _0158_;
 wire _0159_;
 wire _0160_;
 wire _0161_;
 wire _0162_;
 wire _0163_;
 wire _0164_;
 wire _0165_;
 wire _0166_;
 wire _0167_;
 wire _0168_;
 wire _0169_;
 wire _0170_;
 wire _0171_;
 wire _0172_;
 wire _0173_;
 wire _0174_;
 wire _0175_;
 wire _0176_;
 wire _0177_;
 wire _0178_;
 wire _0179_;
 wire _0180_;
 wire _0181_;
 wire _0182_;
 wire _0183_;
 wire _0184_;
 wire _0185_;
 wire net349;
 wire net297;
 wire net348;
 wire net280;
 wire net281;
 wire net279;
 wire net278;
 wire net326;
 wire net312;
 wire net313;
 wire net311;
 wire net286;
 wire net273;
 wire net272;
 wire _0200_;
 wire net299;
 wire net315;
 wire net304;
 wire net306;
 wire net317;
 wire net303;
 wire net305;
 wire net302;
 wire net307;
 wire net308;
 wire net309;
 wire net316;
 wire net310;
 wire net314;
 wire net347;
 wire net266;
 wire net294;
 wire net346;
 wire _0219_;
 wire _0220_;
 wire net290;
 wire net292;
 wire net269;
 wire net291;
 wire _0225_;
 wire net268;
 wire net265;
 wire net267;
 wire net293;
 wire net351;
 wire _0231_;
 wire _0232_;
 wire net341;
 wire net301;
 wire REF_regs;
 wire net345;
 wire net298;
 wire net296;
 wire net318;
 wire net320;
 wire net322;
 wire net324;
 wire net288;
 wire net287;
 wire net285;
 wire net284;
 wire net334;
 wire net338;
 wire _0249_;
 wire net344;
 wire net343;
 wire net282;
 wire net276;
 wire net283;
 wire net274;
 wire net270;
 wire net271;
 wire net289;
 wire net342;
 wire _0260_;
 wire net340;
 wire _0262_;
 wire net331;
 wire net328;
 wire _0265_;
 wire net327;
 wire net277;
 wire net275;
 wire net295;
 wire net300;
 wire net350;
 wire net319;
 wire net321;
 wire net323;
 wire net325;
 wire net329;
 wire net333;
 wire net337;
 wire net335;
 wire net332;
 wire net339;
 wire net336;
 wire net330;
 wire _0284_;
 wire _0285_;
 wire _0286_;
 wire _0287_;
 wire _0288_;
 wire _0289_;
 wire _0290_;
 wire _0291_;
 wire _0292_;
 wire _0293_;
 wire _0294_;
 wire _0295_;
 wire _0296_;
 wire _0297_;
 wire _0298_;
 wire net352;
 wire _0300_;
 wire _0301_;
 wire _0302_;
 wire _0303_;
 wire _0304_;
 wire _0305_;
 wire _0306_;
 wire _0307_;
 wire _0308_;
 wire _0309_;
 wire _0310_;
 wire _0311_;
 wire _0312_;
 wire _0313_;
 wire _0314_;
 wire _0315_;
 wire _0316_;
 wire _0317_;
 wire _0318_;
 wire _0319_;
 wire _0320_;
 wire _0321_;
 wire _0322_;
 wire _0323_;
 wire _0324_;
 wire _0325_;
 wire _0326_;
 wire _0327_;
 wire _0328_;
 wire _0329_;
 wire _0330_;
 wire _0331_;
 wire _0332_;
 wire _0333_;
 wire _0334_;
 wire _0335_;
 wire _0336_;
 wire _0337_;
 wire _0338_;
 wire _0339_;
 wire _0340_;
 wire _0341_;
 wire _0342_;
 wire _0343_;
 wire _0344_;
 wire _0345_;
 wire _0346_;
 wire _0347_;
 wire _0348_;
 wire _0349_;
 wire _0350_;
 wire _0351_;
 wire _0352_;
 wire _0353_;
 wire _0354_;
 wire _0355_;
 wire _0356_;
 wire _0357_;
 wire _0358_;
 wire _0359_;
 wire _0360_;
 wire _0361_;
 wire _0362_;
 wire _0363_;
 wire _0364_;
 wire _0365_;
 wire _0366_;
 wire _0367_;
 wire _0368_;
 wire _0369_;
 wire _0370_;
 wire _0371_;
 wire _0372_;
 wire _0373_;
 wire _0374_;
 wire _0375_;
 wire _0376_;
 wire _0377_;
 wire _0378_;
 wire _0379_;
 wire _0380_;
 wire _0381_;
 wire _0382_;
 wire _0383_;
 wire _0384_;
 wire _0385_;
 wire _0386_;
 wire _0387_;
 wire _0388_;
 wire _0389_;
 wire _0390_;
 wire _0391_;
 wire _0392_;
 wire _0393_;
 wire _0394_;
 wire _0395_;
 wire _0396_;
 wire _0397_;
 wire _0398_;
 wire _0399_;
 wire _0400_;
 wire _0401_;
 wire _0402_;
 wire _0403_;
 wire _0404_;
 wire _0405_;
 wire _0406_;
 wire _0407_;
 wire _0408_;
 wire _0409_;
 wire _0410_;
 wire _0411_;
 wire _0412_;
 wire _0413_;
 wire _0414_;
 wire _0415_;
 wire _0416_;
 wire _0417_;
 wire _0418_;
 wire _0419_;
 wire _0420_;
 wire _0421_;
 wire _0422_;
 wire _0423_;
 wire _0424_;
 wire _0425_;
 wire _0426_;
 wire _0427_;
 wire _0428_;
 wire _0429_;
 wire _0430_;
 wire _0431_;
 wire _0432_;
 wire _0433_;
 wire _0434_;
 wire _0435_;
 wire _0436_;
 wire _0437_;
 wire _0438_;
 wire _0439_;
 wire _0440_;
 wire _0441_;
 wire _0442_;
 wire _0443_;
 wire _0444_;
 wire _0445_;
 wire _0446_;
 wire _0447_;
 wire _0448_;
 wire _0449_;
 wire _0450_;
 wire _0451_;
 wire _0452_;
 wire _0453_;
 wire _0454_;
 wire _0455_;
 wire _0456_;
 wire _0457_;
 wire _0458_;
 wire _0459_;
 wire _0460_;
 wire _0461_;
 wire _0462_;
 wire _0463_;
 wire _0464_;
 wire _0465_;
 wire _0466_;
 wire _0467_;
 wire _0468_;
 wire _0469_;
 wire _0470_;
 wire _0471_;
 wire _0472_;
 wire _0473_;
 wire _0474_;
 wire _0475_;
 wire _0476_;
 wire _0477_;
 wire _0478_;
 wire _0479_;
 wire _0480_;
 wire _0481_;
 wire _0482_;
 wire _0483_;
 wire _0484_;
 wire _0485_;
 wire _0486_;
 wire _0487_;
 wire _0488_;
 wire _0489_;
 wire _0490_;
 wire _0491_;
 wire _0492_;
 wire _0493_;
 wire _0494_;
 wire _0495_;
 wire _0496_;
 wire _0497_;
 wire _0498_;
 wire _0499_;
 wire _0500_;
 wire _0501_;
 wire _0502_;
 wire _0503_;
 wire _0504_;
 wire _0505_;
 wire _0506_;
 wire _0507_;
 wire _0508_;
 wire _0509_;
 wire _0510_;
 wire _0511_;
 wire _0512_;
 wire _0513_;
 wire _0514_;
 wire _0515_;
 wire _0516_;
 wire _0517_;
 wire _0518_;
 wire _0519_;
 wire _0520_;
 wire _0521_;
 wire _0522_;
 wire _0523_;
 wire _0524_;
 wire _0525_;
 wire _0526_;
 wire _0527_;
 wire _0528_;
 wire _0529_;
 wire _0530_;
 wire _0531_;
 wire _0532_;
 wire _0533_;
 wire _0534_;
 wire _0535_;
 wire _0536_;
 wire _0537_;
 wire _0538_;
 wire _0539_;
 wire _0540_;
 wire _0541_;
 wire _0542_;
 wire _0543_;
 wire _0544_;
 wire _0545_;
 wire _0546_;
 wire _0547_;
 wire _0548_;
 wire _0549_;
 wire _0550_;
 wire _0551_;
 wire _0552_;
 wire _0553_;
 wire _0554_;
 wire _0555_;
 wire _0556_;
 wire _0557_;
 wire _0558_;
 wire _0559_;
 wire _0560_;
 wire _0561_;
 wire _0562_;
 wire _0563_;
 wire _0564_;
 wire _0565_;
 wire _0566_;
 wire _0567_;
 wire _0568_;
 wire _0569_;
 wire _0570_;
 wire _0571_;
 wire _0572_;
 wire _0573_;
 wire _0574_;
 wire _0575_;
 wire _0576_;
 wire _0577_;
 wire _0578_;
 wire _0579_;
 wire _0580_;
 wire _0581_;
 wire _0582_;
 wire _0583_;
 wire _0584_;
 wire _0585_;
 wire _0586_;
 wire _0587_;
 wire _0588_;
 wire _0589_;
 wire _0590_;
 wire _0591_;
 wire _0592_;
 wire _0593_;
 wire _0594_;
 wire _0595_;
 wire _0596_;
 wire _0597_;
 wire _0598_;
 wire _0599_;
 wire _0600_;
 wire _0601_;
 wire _0602_;
 wire _0603_;
 wire _0604_;
 wire _0605_;
 wire _0606_;
 wire _0607_;
 wire _0608_;
 wire _0609_;
 wire _0610_;
 wire _0611_;
 wire _0612_;
 wire _0613_;
 wire _0614_;
 wire _0615_;
 wire _0616_;
 wire _0617_;
 wire _0618_;
 wire _0619_;
 wire _0620_;
 wire _0621_;
 wire _0622_;
 wire _0623_;
 wire _0624_;
 wire _0625_;
 wire _0626_;
 wire _0627_;
 wire _0628_;
 wire _0629_;
 wire _0630_;
 wire _0631_;
 wire _0632_;
 wire _0633_;
 wire _0634_;
 wire _0635_;
 wire _0636_;
 wire _0637_;
 wire _0638_;
 wire _0639_;
 wire _0640_;
 wire _0641_;
 wire _0642_;
 wire _0643_;
 wire _0644_;
 wire _0645_;
 wire _0646_;
 wire _0647_;
 wire _0648_;
 wire _0649_;
 wire _0650_;
 wire _0651_;
 wire _0652_;
 wire _0653_;
 wire _0654_;
 wire _0655_;
 wire _0656_;
 wire _0657_;
 wire _0658_;
 wire _0659_;
 wire _0660_;
 wire _0661_;
 wire _0662_;
 wire _0663_;
 wire _0664_;
 wire _0665_;
 wire _0666_;
 wire _0667_;
 wire _0668_;
 wire _0669_;
 wire _0670_;
 wire _0671_;
 wire _0672_;
 wire _0673_;
 wire _0674_;
 wire _0675_;
 wire _0676_;
 wire _0677_;
 wire _0678_;
 wire _0679_;
 wire _0680_;
 wire _0681_;
 wire _0682_;
 wire _0683_;
 wire _0684_;
 wire _0685_;
 wire _0686_;
 wire _0687_;
 wire _0688_;
 wire _0689_;
 wire _0690_;
 wire _0691_;
 wire _0692_;
 wire _0693_;
 wire _0694_;
 wire _0695_;
 wire _0696_;
 wire _0697_;
 wire _0698_;
 wire _0699_;
 wire _0700_;
 wire _0701_;
 wire _0702_;
 wire _0703_;
 wire _0704_;
 wire _0705_;
 wire _0706_;
 wire _0707_;
 wire _0708_;
 wire _0709_;
 wire _0710_;
 wire _0711_;
 wire _0712_;
 wire _0713_;
 wire _0714_;
 wire _0715_;
 wire _0716_;
 wire _0717_;
 wire _0718_;
 wire _0719_;
 wire _0720_;
 wire _0721_;
 wire _0722_;
 wire _0723_;
 wire _0724_;
 wire _0725_;
 wire _0726_;
 wire _0727_;
 wire _0728_;
 wire _0729_;
 wire _0730_;
 wire _0731_;
 wire _0732_;
 wire _0733_;
 wire _0734_;
 wire _0735_;
 wire _0736_;
 wire _0737_;
 wire _0738_;
 wire _0739_;
 wire _0740_;
 wire _0741_;
 wire _0742_;
 wire _0743_;
 wire _0744_;
 wire _0745_;
 wire _0746_;
 wire _0747_;
 wire _0748_;
 wire _0749_;
 wire _0750_;
 wire _0751_;
 wire _0752_;
 wire _0753_;
 wire _0754_;
 wire _0755_;
 wire _0756_;
 wire _0757_;
 wire _0758_;
 wire _0759_;
 wire _0760_;
 wire _0761_;
 wire _0762_;
 wire _0763_;
 wire _0764_;
 wire _0765_;
 wire _0766_;
 wire _0767_;
 wire _0768_;
 wire _0769_;
 wire _0770_;
 wire _0771_;
 wire _0772_;
 wire _0773_;
 wire _0774_;
 wire _0775_;
 wire _0776_;
 wire _0777_;
 wire _0778_;
 wire _0779_;
 wire _0780_;
 wire _0781_;
 wire _0782_;
 wire _0783_;
 wire _0784_;
 wire _0785_;
 wire _0786_;
 wire _0787_;
 wire _0788_;
 wire _0789_;
 wire _0790_;
 wire _0791_;
 wire _0792_;
 wire _0793_;
 wire _0794_;
 wire _0795_;
 wire _0796_;
 wire _0797_;
 wire _0798_;
 wire _0799_;
 wire _0800_;
 wire _0801_;
 wire _0802_;
 wire _0803_;
 wire _0804_;
 wire _0805_;
 wire _0806_;
 wire _0807_;
 wire _0808_;
 wire _0809_;
 wire _0810_;
 wire _0811_;
 wire _0812_;
 wire _0813_;
 wire _0814_;
 wire _0815_;
 wire _0816_;
 wire _0817_;
 wire _0818_;
 wire _0819_;
 wire _0820_;
 wire _0821_;
 wire _0822_;
 wire _0823_;
 wire _0824_;
 wire _0825_;
 wire _0826_;
 wire _0827_;
 wire _0828_;
 wire _0829_;
 wire _0830_;
 wire _0831_;
 wire _0832_;
 wire _0833_;
 wire _0834_;
 wire _0835_;
 wire _0836_;
 wire _0837_;
 wire _0838_;
 wire _0839_;
 wire _0840_;
 wire _0841_;
 wire _0842_;
 wire _0843_;
 wire _0844_;
 wire _0845_;
 wire _0846_;
 wire _0847_;
 wire _0848_;
 wire _0849_;
 wire _0850_;
 wire _0851_;
 wire _0852_;
 wire _0853_;
 wire _0854_;
 wire _0855_;
 wire _0856_;
 wire _0857_;
 wire _0858_;
 wire _0859_;
 wire _0860_;
 wire _0861_;
 wire _0862_;
 wire _0863_;
 wire _0864_;
 wire _0865_;
 wire _0866_;
 wire _0867_;
 wire _0868_;
 wire _0869_;
 wire _0870_;
 wire _0871_;
 wire _0872_;
 wire _0873_;
 wire _0874_;
 wire _0875_;
 wire _0876_;
 wire _0877_;
 wire _0878_;
 wire _0879_;
 wire _0880_;
 wire _0881_;
 wire _0882_;
 wire _0883_;
 wire _0884_;
 wire _0885_;
 wire _0886_;
 wire _0887_;
 wire _0888_;
 wire _0889_;
 wire _0890_;
 wire _0891_;
 wire _0892_;
 wire _0893_;
 wire _0894_;
 wire _0895_;
 wire _0896_;
 wire _0897_;
 wire _0898_;
 wire _0899_;
 wire _0900_;
 wire _0901_;
 wire _0902_;
 wire _0903_;
 wire _0904_;
 wire _0905_;
 wire _0906_;
 wire _0907_;
 wire _0908_;
 wire _0909_;
 wire _0910_;
 wire _0911_;
 wire _0912_;
 wire _0913_;
 wire _0914_;
 wire _0915_;
 wire _0916_;
 wire _0917_;
 wire _0918_;
 wire _0919_;
 wire _0920_;
 wire _0921_;
 wire _0922_;
 wire _0923_;
 wire _0924_;
 wire _0925_;
 wire _0926_;
 wire _0927_;
 wire _0928_;
 wire _0929_;
 wire _0930_;
 wire _0931_;
 wire _0932_;
 wire _0933_;
 wire _0934_;
 wire _0935_;
 wire _0936_;
 wire _0937_;
 wire _0938_;
 wire _0939_;
 wire _0940_;
 wire _0941_;
 wire _0942_;
 wire _0943_;
 wire _0944_;
 wire _0945_;
 wire _0946_;
 wire _0947_;
 wire _0948_;
 wire _0949_;
 wire _0950_;
 wire _0951_;
 wire _0952_;
 wire _0953_;
 wire _0954_;
 wire _0955_;
 wire _0956_;
 wire _0957_;
 wire _0958_;
 wire _0959_;
 wire _0960_;
 wire _0961_;
 wire _0962_;
 wire _0963_;
 wire _0964_;
 wire _0965_;
 wire _0966_;
 wire _0967_;
 wire _0968_;
 wire _0969_;
 wire _0970_;
 wire _0971_;
 wire _0972_;
 wire _0973_;
 wire _0974_;
 wire _0975_;
 wire _0976_;
 wire _0977_;
 wire _0978_;
 wire _0979_;
 wire _0980_;
 wire _0981_;
 wire _0982_;
 wire _0983_;
 wire _0984_;
 wire _0985_;
 wire _0986_;
 wire _0987_;
 wire _0988_;
 wire _0989_;
 wire _0990_;
 wire _0991_;
 wire _0992_;
 wire _0993_;
 wire _0994_;
 wire _0995_;
 wire _0996_;
 wire _0997_;
 wire _0998_;
 wire _0999_;
 wire _1000_;
 wire _1001_;
 wire _1002_;
 wire _1003_;
 wire _1004_;
 wire _1005_;
 wire _1006_;
 wire _1007_;
 wire _1008_;
 wire _1009_;
 wire _1010_;
 wire _1011_;
 wire _1012_;
 wire _1013_;
 wire _1014_;
 wire _1015_;
 wire _1016_;
 wire _1017_;
 wire _1018_;
 wire _1019_;
 wire _1020_;
 wire _1021_;
 wire _1022_;
 wire _1023_;
 wire _1024_;
 wire _1025_;
 wire _1026_;
 wire _1027_;
 wire _1028_;
 wire _1029_;
 wire _1030_;
 wire _1031_;
 wire _1032_;
 wire _1033_;
 wire _1034_;
 wire _1035_;
 wire _1036_;
 wire _1037_;
 wire _1038_;
 wire _1039_;
 wire _1040_;
 wire _1041_;
 wire _1042_;
 wire _1043_;
 wire _1044_;
 wire _1045_;
 wire _1046_;
 wire _1047_;
 wire _1048_;
 wire _1049_;
 wire _1050_;
 wire _1051_;
 wire _1052_;
 wire _1053_;
 wire _1054_;
 wire _1055_;
 wire _1056_;
 wire _1057_;
 wire _1058_;
 wire _1059_;
 wire _1060_;
 wire _1061_;
 wire _1062_;
 wire _1063_;
 wire _1064_;
 wire _1065_;
 wire _1066_;
 wire _1067_;
 wire _1068_;
 wire _1069_;
 wire _1070_;
 wire _1071_;
 wire _1072_;
 wire _1073_;
 wire _1074_;
 wire _1075_;
 wire _1076_;
 wire _1077_;
 wire _1078_;
 wire _1079_;
 wire _1080_;
 wire _1081_;
 wire _1082_;
 wire _1083_;
 wire _1084_;
 wire _1085_;
 wire _1086_;
 wire _1087_;
 wire _1088_;
 wire _1089_;
 wire _1090_;
 wire _1091_;
 wire _1092_;
 wire _1093_;
 wire _1094_;
 wire _1095_;
 wire _1096_;
 wire _1097_;
 wire _1098_;
 wire _1099_;
 wire _1100_;
 wire _1101_;
 wire _1102_;
 wire _1103_;
 wire _1104_;
 wire _1105_;
 wire _1106_;
 wire _1107_;
 wire _1108_;
 wire _1109_;
 wire _1110_;
 wire _1111_;
 wire _1112_;
 wire _1113_;
 wire _1114_;
 wire _1115_;
 wire _1116_;
 wire _1117_;
 wire _1118_;
 wire _1119_;
 wire _1120_;
 wire _1121_;
 wire _1122_;
 wire _1123_;
 wire _1124_;
 wire _1125_;
 wire _1126_;
 wire _1127_;
 wire _1128_;
 wire _1129_;
 wire _1130_;
 wire _1131_;
 wire _1132_;
 wire _1133_;
 wire _1134_;
 wire _1135_;
 wire _1136_;
 wire _1137_;
 wire _1138_;
 wire _1139_;
 wire _1140_;
 wire _1141_;
 wire _1142_;
 wire _1143_;
 wire _1144_;
 wire _1145_;
 wire _1146_;
 wire _1147_;
 wire _1148_;
 wire _1149_;
 wire _1150_;
 wire _1151_;
 wire _1152_;
 wire _1153_;
 wire _1154_;
 wire _1155_;
 wire _1156_;
 wire _1157_;
 wire _1158_;
 wire _1159_;
 wire _1160_;
 wire _1161_;
 wire _1162_;
 wire _1163_;
 wire _1164_;
 wire _1165_;
 wire _1166_;
 wire _1167_;
 wire _1168_;
 wire _1169_;
 wire _1170_;
 wire _1171_;
 wire _1172_;
 wire _1173_;
 wire _1174_;
 wire _1175_;
 wire _1176_;
 wire _1177_;
 wire _1178_;
 wire _1179_;
 wire _1180_;
 wire _1181_;
 wire _1182_;
 wire _1183_;
 wire _1184_;
 wire _1185_;
 wire _1186_;
 wire _1187_;
 wire _1188_;
 wire _1189_;
 wire _1190_;
 wire _1191_;
 wire _1192_;
 wire _1193_;
 wire _1194_;
 wire _1195_;
 wire _1196_;
 wire _1197_;
 wire _1198_;
 wire _1199_;
 wire _1200_;
 wire _1201_;
 wire _1202_;
 wire _1203_;
 wire _1204_;
 wire _1205_;
 wire _1206_;
 wire _1207_;
 wire _1208_;
 wire _1209_;
 wire _1210_;
 wire _1211_;
 wire _1212_;
 wire _1213_;
 wire _1214_;
 wire _1215_;
 wire _1216_;
 wire _1217_;
 wire _1218_;
 wire _1219_;
 wire _1220_;
 wire _1221_;
 wire _1222_;
 wire _1223_;
 wire _1224_;
 wire _1225_;
 wire _1226_;
 wire _1227_;
 wire _1228_;
 wire _1229_;
 wire _1230_;
 wire _1231_;
 wire _1232_;
 wire _1233_;
 wire _1234_;
 wire _1235_;
 wire _1236_;
 wire _1237_;
 wire _1238_;
 wire _1239_;
 wire _1240_;
 wire _1241_;
 wire _1242_;
 wire _1243_;
 wire _1244_;
 wire _1245_;
 wire _1246_;
 wire _1247_;
 wire _1248_;
 wire _1249_;
 wire _1250_;
 wire _1251_;
 wire _1252_;
 wire _1253_;
 wire _1254_;
 wire _1255_;
 wire _1256_;
 wire _1257_;
 wire _1258_;
 wire _1259_;
 wire _1260_;
 wire _1261_;
 wire _1262_;
 wire _1263_;
 wire _1264_;
 wire _1265_;
 wire _1266_;
 wire _1267_;
 wire _1268_;
 wire _1269_;
 wire _1270_;
 wire _1271_;
 wire _1272_;
 wire _1273_;
 wire _1274_;
 wire _1275_;
 wire _1276_;
 wire _1277_;
 wire _1278_;
 wire _1279_;
 wire _1280_;
 wire _1281_;
 wire _1282_;
 wire _1283_;
 wire _1284_;
 wire _1285_;
 wire _1286_;
 wire _1287_;
 wire _1288_;
 wire _1289_;
 wire _1290_;
 wire _1291_;
 wire _1292_;
 wire _1293_;
 wire _1294_;
 wire _1295_;
 wire _1296_;
 wire _1297_;
 wire _1298_;
 wire _1299_;
 wire _1300_;
 wire _1301_;
 wire _1302_;
 wire _1303_;
 wire _1304_;
 wire _1305_;
 wire _1306_;
 wire _1307_;
 wire _1308_;
 wire _1309_;
 wire _1310_;
 wire _1311_;
 wire _1312_;
 wire _1313_;
 wire _1314_;
 wire _1315_;
 wire _1316_;
 wire _1317_;
 wire _1318_;
 wire _1319_;
 wire _1320_;
 wire _1321_;
 wire _1322_;
 wire _1323_;
 wire _1324_;
 wire _1325_;
 wire _1326_;
 wire _1327_;
 wire _1328_;
 wire _1329_;
 wire _1330_;
 wire _1331_;
 wire _1332_;
 wire _1333_;
 wire _1334_;
 wire _1335_;
 wire _1336_;
 wire _1337_;
 wire _1338_;
 wire _1339_;
 wire _1340_;
 wire _1341_;
 wire _1342_;
 wire _1343_;
 wire _1344_;
 wire _1345_;
 wire _1346_;
 wire _1347_;
 wire _1348_;
 wire _1349_;
 wire _1350_;
 wire _1351_;
 wire _1352_;
 wire _1353_;
 wire _1354_;
 wire _1355_;
 wire _1356_;
 wire _1357_;
 wire _1358_;
 wire _1359_;
 wire _1360_;
 wire _1361_;
 wire _1362_;
 wire _1363_;
 wire _1364_;
 wire _1365_;
 wire _1366_;
 wire _1367_;
 wire _1368_;
 wire _1369_;
 wire _1370_;
 wire _1371_;
 wire _1372_;
 wire _1373_;
 wire _1374_;
 wire _1375_;
 wire _1376_;
 wire _1377_;
 wire _1378_;
 wire _1379_;
 wire _1380_;
 wire _1381_;
 wire _1382_;
 wire _1383_;
 wire _1384_;
 wire _1385_;
 wire _1386_;
 wire _1387_;
 wire _1388_;
 wire _1389_;
 wire _1390_;
 wire _1391_;
 wire _1392_;
 wire _1393_;
 wire _1394_;
 wire _1395_;
 wire _1396_;
 wire _1397_;
 wire _1398_;
 wire _1399_;
 wire _1400_;
 wire _1401_;
 wire _1402_;
 wire _1403_;
 wire _1404_;
 wire _1405_;
 wire _1406_;
 wire _1407_;
 wire _1408_;
 wire _1409_;
 wire _1410_;
 wire _1411_;
 wire _1412_;
 wire _1413_;
 wire _1414_;
 wire _1415_;
 wire _1416_;
 wire _1417_;
 wire _1418_;
 wire _1419_;
 wire _1420_;
 wire _1421_;
 wire _1422_;
 wire _1423_;
 wire _1424_;
 wire _1425_;
 wire _1426_;
 wire _1427_;
 wire _1428_;
 wire _1429_;
 wire _1430_;
 wire _1431_;
 wire _1432_;
 wire _1433_;
 wire _1434_;
 wire _1435_;
 wire _1436_;
 wire _1437_;
 wire _1438_;
 wire _1439_;
 wire _1440_;
 wire _1441_;
 wire _1442_;
 wire _1443_;
 wire _1444_;
 wire _1445_;
 wire _1446_;
 wire _1447_;
 wire _1448_;
 wire _1449_;
 wire _1450_;
 wire _1451_;
 wire _1452_;
 wire _1453_;
 wire _1454_;
 wire _1455_;
 wire _1456_;
 wire _1457_;
 wire _1458_;
 wire _1459_;
 wire _1460_;
 wire _1461_;
 wire _1462_;
 wire _1463_;
 wire _1464_;
 wire _1465_;
 wire _1466_;
 wire _1467_;
 wire _1468_;
 wire _1469_;
 wire _1470_;
 wire _1471_;
 wire _1472_;
 wire _1473_;
 wire _1474_;
 wire _1475_;
 wire _1476_;
 wire _1477_;
 wire _1478_;
 wire _1479_;
 wire _1480_;
 wire _1481_;
 wire _1482_;
 wire _1483_;
 wire _1484_;
 wire _1485_;
 wire _1486_;
 wire _1487_;
 wire _1488_;
 wire _1489_;
 wire _1490_;
 wire _1491_;
 wire _1492_;
 wire _1493_;
 wire _1494_;
 wire _1495_;
 wire _1496_;
 wire _1497_;
 wire _1498_;
 wire _1499_;
 wire _1500_;
 wire _1501_;
 wire _1502_;
 wire _1503_;
 wire _1504_;
 wire _1505_;
 wire _1506_;
 wire _1507_;
 wire _1508_;
 wire _1509_;
 wire _1510_;
 wire _1511_;
 wire _1512_;
 wire _1513_;
 wire _1514_;
 wire _1515_;
 wire _1516_;
 wire _1517_;
 wire _1518_;
 wire _1519_;
 wire _1520_;
 wire _1521_;
 wire _1522_;
 wire _1523_;
 wire _1524_;
 wire _1525_;
 wire _1526_;
 wire _1527_;
 wire _1528_;
 wire _1529_;
 wire _1530_;
 wire _1531_;
 wire _1532_;
 wire _1533_;
 wire _1534_;
 wire _1535_;
 wire _1536_;
 wire _1537_;
 wire _1538_;
 wire _1539_;
 wire _1540_;
 wire _1541_;
 wire _1542_;
 wire _1543_;
 wire _1544_;
 wire _1545_;
 wire _1546_;
 wire _1547_;
 wire _1548_;
 wire _1549_;
 wire _1550_;
 wire _1551_;
 wire _1552_;
 wire _1553_;
 wire _1554_;
 wire _1555_;
 wire _1556_;
 wire _1557_;
 wire _1558_;
 wire _1559_;
 wire _1560_;
 wire _1561_;
 wire _1562_;
 wire _1563_;
 wire _1564_;
 wire _1565_;
 wire _1566_;
 wire _1567_;
 wire _1568_;
 wire _1569_;
 wire _1570_;
 wire _1571_;
 wire _1572_;
 wire _1573_;
 wire _1574_;
 wire _1575_;
 wire _1576_;
 wire _1577_;
 wire _1578_;
 wire _1579_;
 wire _1580_;
 wire _1581_;
 wire _1582_;
 wire _1583_;
 wire _1584_;
 wire _1585_;
 wire _1586_;
 wire _1587_;
 wire _1588_;
 wire _1589_;
 wire _1590_;
 wire _1591_;
 wire _1592_;
 wire _1593_;
 wire _1594_;
 wire _1595_;
 wire _1596_;
 wire _1597_;
 wire _1598_;
 wire _1599_;
 wire _1600_;
 wire _1601_;
 wire _1602_;
 wire _1603_;
 wire _1604_;
 wire _1605_;
 wire _1606_;
 wire _1607_;
 wire _1608_;
 wire _1609_;
 wire _1610_;
 wire _1611_;
 wire _1612_;
 wire _1613_;
 wire _1614_;
 wire _1615_;
 wire _1616_;
 wire _1617_;
 wire _1618_;
 wire _1619_;
 wire _1620_;
 wire _1621_;
 wire _1622_;
 wire _1623_;
 wire _1624_;
 wire _1625_;
 wire _1626_;
 wire _1627_;
 wire _1628_;
 wire _1629_;
 wire _1630_;
 wire _1631_;
 wire _1632_;
 wire _1633_;
 wire _1634_;
 wire _1635_;
 wire _1636_;
 wire _1637_;
 wire _1638_;
 wire _1639_;
 wire _1640_;
 wire _1641_;
 wire _1642_;
 wire _1643_;
 wire _1644_;
 wire _1645_;
 wire _1646_;
 wire _1647_;
 wire _1648_;
 wire _1649_;
 wire _1650_;
 wire _1651_;
 wire _1652_;
 wire _1653_;
 wire _1654_;
 wire _1655_;
 wire _1656_;
 wire _1657_;
 wire _1658_;
 wire _1659_;
 wire _1660_;
 wire _1661_;
 wire _1662_;
 wire _1663_;
 wire _1664_;
 wire _1665_;
 wire _1666_;
 wire _1667_;
 wire _1668_;
 wire _1669_;
 wire _1670_;
 wire _1671_;
 wire _1672_;
 wire _1673_;
 wire _1674_;
 wire _1675_;
 wire _1676_;
 wire _1677_;
 wire _1678_;
 wire _1679_;
 wire _1680_;
 wire _1681_;
 wire _1682_;
 wire _1683_;
 wire _1684_;
 wire _1685_;
 wire _1686_;
 wire _1687_;
 wire _1688_;
 wire _1689_;
 wire _1690_;
 wire _1691_;
 wire _1692_;
 wire _1693_;
 wire _1694_;
 wire _1695_;
 wire _1696_;
 wire _1697_;
 wire _1698_;
 wire _1699_;
 wire _1700_;
 wire _1701_;
 wire _1702_;
 wire _1703_;
 wire _1704_;
 wire _1705_;
 wire _1706_;
 wire _1707_;
 wire _1708_;
 wire _1709_;
 wire _1710_;
 wire _1711_;
 wire _1712_;
 wire _1713_;
 wire _1714_;
 wire _1715_;
 wire _1716_;
 wire _1717_;
 wire _1718_;
 wire _1719_;
 wire _1720_;
 wire _1721_;
 wire _1722_;
 wire _1723_;
 wire _1724_;
 wire _1725_;
 wire _1726_;
 wire _1727_;
 wire _1728_;
 wire _1729_;
 wire _1730_;
 wire _1731_;
 wire _1732_;
 wire _1733_;
 wire _1734_;
 wire _1735_;
 wire _1736_;
 wire _1737_;
 wire _1738_;
 wire _1739_;
 wire _1740_;
 wire _1741_;
 wire _1742_;
 wire _1743_;
 wire _1744_;
 wire _1745_;
 wire _1746_;
 wire _1747_;
 wire _1748_;
 wire _1749_;
 wire _1750_;
 wire _1751_;
 wire _1752_;
 wire _1753_;
 wire _1754_;
 wire _1755_;
 wire _1756_;
 wire _1757_;
 wire _1758_;
 wire _1759_;
 wire _1760_;
 wire _1761_;
 wire _1762_;
 wire _1763_;
 wire _1764_;
 wire _1765_;
 wire _1766_;
 wire _1767_;
 wire _1768_;
 wire _1769_;
 wire _1770_;
 wire _1771_;
 wire _1772_;
 wire _1773_;
 wire _1774_;
 wire _1775_;
 wire _1776_;
 wire _1777_;
 wire _1778_;
 wire _1779_;
 wire _1780_;
 wire _1781_;
 wire _1782_;
 wire _1783_;
 wire _1784_;
 wire _1785_;
 wire _1786_;
 wire _1787_;
 wire _1788_;
 wire _1789_;
 wire _1790_;
 wire _1791_;
 wire _1792_;
 wire _1793_;
 wire _1794_;
 wire _1795_;
 wire _1796_;
 wire _1797_;
 wire _1798_;
 wire _1799_;
 wire _1800_;
 wire _1801_;
 wire _1802_;
 wire _1803_;
 wire _1804_;
 wire _1805_;
 wire _1806_;
 wire _1807_;
 wire _1808_;
 wire _1809_;
 wire _1810_;
 wire _1811_;
 wire _1812_;
 wire _1813_;
 wire _1814_;
 wire _1815_;
 wire _1816_;
 wire _1817_;
 wire _1818_;
 wire _1819_;
 wire _1820_;
 wire _1821_;
 wire _1822_;
 wire _1823_;
 wire _1824_;
 wire _1825_;
 wire _1826_;
 wire _1827_;
 wire _1828_;
 wire _1829_;
 wire _1830_;
 wire _1831_;
 wire _1832_;
 wire _1833_;
 wire _1834_;
 wire _1835_;
 wire _1836_;
 wire _1837_;
 wire _1838_;
 wire _1839_;
 wire _1840_;
 wire _1841_;
 wire _1842_;
 wire _1843_;
 wire _1844_;
 wire _1845_;
 wire _1846_;
 wire _1847_;
 wire _1848_;
 wire _1849_;
 wire _1850_;
 wire _1851_;
 wire _1852_;
 wire _1853_;
 wire _1854_;
 wire _1855_;
 wire _1856_;
 wire _1857_;
 wire _1858_;
 wire _1859_;
 wire _1860_;
 wire _1861_;
 wire _1862_;
 wire _1863_;
 wire _1864_;
 wire _1865_;
 wire _1866_;
 wire _1867_;
 wire _1868_;
 wire _1869_;
 wire _1870_;
 wire _1871_;
 wire _1872_;
 wire _1873_;
 wire _1874_;
 wire _1875_;
 wire _1876_;
 wire _1877_;
 wire _1878_;
 wire _1879_;
 wire _1880_;
 wire _1881_;
 wire _1882_;
 wire _1883_;
 wire _1884_;
 wire _1885_;
 wire _1886_;
 wire _1887_;
 wire _1888_;
 wire _1889_;
 wire _1890_;
 wire _1891_;
 wire _1892_;
 wire _1893_;
 wire _1894_;
 wire _1895_;
 wire _1896_;
 wire _1897_;
 wire _1898_;
 wire _1899_;
 wire _1900_;
 wire _1901_;
 wire _1902_;
 wire _1903_;
 wire _1904_;
 wire _1905_;
 wire _1906_;
 wire _1907_;
 wire _1908_;
 wire _1909_;
 wire _1910_;
 wire _1911_;
 wire _1912_;
 wire _1913_;
 wire _1914_;
 wire _1915_;
 wire _1916_;
 wire _1917_;
 wire _1918_;
 wire _1919_;
 wire _1920_;
 wire _1921_;
 wire _1922_;
 wire _1923_;
 wire _1924_;
 wire _1925_;
 wire _1926_;
 wire _1927_;
 wire _1928_;
 wire _1929_;
 wire _1930_;
 wire _1931_;
 wire _1932_;
 wire _1933_;
 wire _1934_;
 wire _1935_;
 wire _1936_;
 wire _1937_;
 wire _1938_;
 wire _1939_;
 wire _1940_;
 wire _1941_;
 wire _1942_;
 wire _1943_;
 wire _1944_;
 wire _1945_;
 wire _1946_;
 wire _1947_;
 wire _1948_;
 wire _1949_;
 wire _1950_;
 wire _1951_;
 wire _1952_;
 wire _1953_;
 wire _1954_;
 wire _1955_;
 wire _1956_;
 wire _1957_;
 wire _1958_;
 wire _1959_;
 wire _1960_;
 wire _1961_;
 wire _1962_;
 wire _1963_;
 wire _1964_;
 wire _1965_;
 wire _1966_;
 wire _1967_;
 wire _1968_;
 wire _1969_;
 wire _1970_;
 wire _1971_;
 wire _1972_;
 wire _1973_;
 wire _1974_;
 wire _1975_;
 wire _1976_;
 wire _1977_;
 wire _1978_;
 wire _1979_;
 wire _1980_;
 wire _1981_;
 wire _1982_;
 wire _1983_;
 wire _1984_;
 wire _1985_;
 wire _1986_;
 wire _1987_;
 wire _1988_;
 wire _1989_;
 wire _1990_;
 wire _1991_;
 wire _1992_;
 wire _1993_;
 wire _1994_;
 wire _1995_;
 wire _1996_;
 wire _1997_;
 wire _1998_;
 wire _1999_;
 wire _2000_;
 wire _2001_;
 wire _2002_;
 wire _2003_;
 wire _2004_;
 wire _2005_;
 wire _2006_;
 wire _2007_;
 wire _2008_;
 wire _2009_;
 wire _2010_;
 wire _2011_;
 wire _2012_;
 wire _2013_;
 wire _2014_;
 wire _2015_;
 wire _2016_;
 wire _2017_;
 wire _2018_;
 wire _2019_;
 wire _2020_;
 wire _2021_;
 wire _2022_;
 wire _2023_;
 wire _2024_;
 wire _2025_;
 wire _2026_;
 wire _2027_;
 wire _2028_;
 wire _2029_;
 wire _2030_;
 wire _2031_;
 wire _2032_;
 wire _2033_;
 wire _2034_;
 wire _2035_;
 wire _2036_;
 wire _2037_;
 wire _2038_;
 wire _2039_;
 wire _2040_;
 wire _2041_;
 wire _2042_;
 wire _2043_;
 wire _2044_;
 wire _2045_;
 wire _2046_;
 wire _2047_;
 wire _2048_;
 wire _2049_;
 wire _2050_;
 wire _2051_;
 wire _2052_;
 wire _2053_;
 wire _2054_;
 wire _2055_;
 wire _2056_;
 wire _2057_;
 wire _2058_;
 wire _2059_;
 wire _2060_;
 wire _2061_;
 wire _2062_;
 wire _2063_;
 wire _2064_;
 wire _2065_;
 wire _2066_;
 wire _2067_;
 wire _2068_;
 wire _2069_;
 wire _2070_;
 wire _2071_;
 wire _2072_;
 wire _2073_;
 wire _2074_;
 wire _2075_;
 wire _2076_;
 wire _2077_;
 wire _2078_;
 wire _2079_;
 wire _2080_;
 wire _2081_;
 wire _2082_;
 wire _2083_;
 wire _2084_;
 wire _2085_;
 wire _2086_;
 wire net246;
 wire net247;
 wire net248;
 wire net249;
 wire net250;
 wire net251;
 wire net252;
 wire net253;
 wire net254;
 wire net255;
 wire net256;
 wire net257;
 wire net258;
 wire net259;
 wire net260;
 wire net261;
 wire net262;
 wire net263;
 wire net264;
 wire \pll_dig.CKR ;
 wire \pll_dig.COARSE_MUX_D[0] ;
 wire \pll_dig.COARSE_MUX_D[10] ;
 wire \pll_dig.COARSE_MUX_D[11] ;
 wire \pll_dig.COARSE_MUX_D[12] ;
 wire \pll_dig.COARSE_MUX_D[13] ;
 wire \pll_dig.COARSE_MUX_D[14] ;
 wire \pll_dig.COARSE_MUX_D[1] ;
 wire \pll_dig.COARSE_MUX_D[2] ;
 wire \pll_dig.COARSE_MUX_D[3] ;
 wire \pll_dig.COARSE_MUX_D[4] ;
 wire \pll_dig.COARSE_MUX_D[5] ;
 wire \pll_dig.COARSE_MUX_D[6] ;
 wire \pll_dig.COARSE_MUX_D[7] ;
 wire \pll_dig.COARSE_MUX_D[8] ;
 wire \pll_dig.COARSE_MUX_D[9] ;
 wire \pll_dig.ENABLE ;
 wire \pll_dig.FILTER_DEC[0] ;
 wire \pll_dig.FILTER_DEC[1] ;
 wire \pll_dig.FILTER_DEC[2] ;
 wire \pll_dig.FILTER_DEC[3] ;
 wire \pll_dig.FILTER_DEC[4] ;
 wire \pll_dig.FILTER_DEC_RAW[0] ;
 wire \pll_dig.FILTER_DEC_RAW[1] ;
 wire \pll_dig.FILTER_DEC_RAW[2] ;
 wire \pll_dig.FILTER_DEC_RAW[3] ;
 wire \pll_dig.FILTER_DEC_RAW[4] ;
 wire \pll_dig.FILTER_OUT[0] ;
 wire \pll_dig.FILTER_OUT[10] ;
 wire \pll_dig.FILTER_OUT[11] ;
 wire \pll_dig.FILTER_OUT[12] ;
 wire \pll_dig.FILTER_OUT[13] ;
 wire \pll_dig.FILTER_OUT[14] ;
 wire \pll_dig.FILTER_OUT[15] ;
 wire \pll_dig.FILTER_OUT[1] ;
 wire \pll_dig.FILTER_OUT[2] ;
 wire \pll_dig.FILTER_OUT[3] ;
 wire \pll_dig.FILTER_OUT[4] ;
 wire \pll_dig.FILTER_OUT[5] ;
 wire \pll_dig.FILTER_OUT[6] ;
 wire \pll_dig.FILTER_OUT[7] ;
 wire \pll_dig.FILTER_OUT[8] ;
 wire \pll_dig.FILTER_OUT[9] ;
 wire \pll_dig.FINE_MUX_D[0] ;
 wire \pll_dig.FINE_MUX_D[10] ;
 wire \pll_dig.FINE_MUX_D[11] ;
 wire \pll_dig.FINE_MUX_D[12] ;
 wire \pll_dig.FINE_MUX_D[13] ;
 wire \pll_dig.FINE_MUX_D[14] ;
 wire \pll_dig.FINE_MUX_D[16] ;
 wire \pll_dig.FINE_MUX_D[17] ;
 wire \pll_dig.FINE_MUX_D[18] ;
 wire \pll_dig.FINE_MUX_D[19] ;
 wire \pll_dig.FINE_MUX_D[1] ;
 wire \pll_dig.FINE_MUX_D[20] ;
 wire \pll_dig.FINE_MUX_D[21] ;
 wire \pll_dig.FINE_MUX_D[22] ;
 wire \pll_dig.FINE_MUX_D[23] ;
 wire \pll_dig.FINE_MUX_D[24] ;
 wire \pll_dig.FINE_MUX_D[25] ;
 wire \pll_dig.FINE_MUX_D[26] ;
 wire \pll_dig.FINE_MUX_D[27] ;
 wire \pll_dig.FINE_MUX_D[28] ;
 wire \pll_dig.FINE_MUX_D[29] ;
 wire \pll_dig.FINE_MUX_D[2] ;
 wire \pll_dig.FINE_MUX_D[30] ;
 wire \pll_dig.FINE_MUX_D[3] ;
 wire \pll_dig.FINE_MUX_D[4] ;
 wire \pll_dig.FINE_MUX_D[5] ;
 wire \pll_dig.FINE_MUX_D[6] ;
 wire \pll_dig.FINE_MUX_D[7] ;
 wire \pll_dig.FINE_MUX_D[8] ;
 wire \pll_dig.FINE_MUX_D[9] ;
 wire \pll_dig.FORCE_N ;
 wire \pll_dig.FORCE_P ;
 wire \pll_dig.FREQ_ERR ;
 wire \pll_dig.FREQ_LOCKED ;
 wire \pll_dig.FREQ_OK ;
 wire \pll_dig.ILL_N ;
 wire \pll_dig.ILL_P ;
 wire \pll_dig.LOCK_LOST ;
 wire \pll_dig.MID_MUX_D[0] ;
 wire \pll_dig.MID_MUX_D[10] ;
 wire \pll_dig.MID_MUX_D[11] ;
 wire \pll_dig.MID_MUX_D[12] ;
 wire \pll_dig.MID_MUX_D[13] ;
 wire \pll_dig.MID_MUX_D[14] ;
 wire \pll_dig.MID_MUX_D[1] ;
 wire \pll_dig.MID_MUX_D[2] ;
 wire \pll_dig.MID_MUX_D[3] ;
 wire \pll_dig.MID_MUX_D[4] ;
 wire \pll_dig.MID_MUX_D[5] ;
 wire \pll_dig.MID_MUX_D[6] ;
 wire \pll_dig.MID_MUX_D[7] ;
 wire \pll_dig.MID_MUX_D[8] ;
 wire \pll_dig.MID_MUX_D[9] ;
 wire \pll_dig.PHASE_LOCK ;
 wire \pll_dig.START ;
 wire \pll_dig.clr_r1 ;
 wire \pll_dig.clr_r2 ;
 wire \pll_dig.clr_r3 ;
 wire \pll_dig.clr_toggle ;
 wire \pll_dig.cnt[0] ;
 wire \pll_dig.cnt[1] ;
 wire \pll_dig.cnt[2] ;
 wire \pll_dig.cnt[3] ;
 wire \pll_dig.cnt[4] ;
 wire \pll_dig.cnt[5] ;
 wire \pll_dig.cnt[6] ;
 wire \pll_dig.cnt[7] ;
 wire \pll_dig.cntf[0] ;
 wire \pll_dig.cntf[1] ;
 wire \pll_dig.cntf[2] ;
 wire \pll_dig.cntf[3] ;
 wire \pll_dig.cntf[4] ;
 wire \pll_dig.cntf[5] ;
 wire \pll_dig.cntf[6] ;
 wire \pll_dig.cntf[7] ;
 wire \pll_dig.dco_fail ;
 wire \pll_dig.dco_miss_cnt[0] ;
 wire \pll_dig.dco_miss_cnt[1] ;
 wire \pll_dig.dco_miss_cnt[2] ;
 wire \pll_dig.div.cnt[0] ;
 wire \pll_dig.div.cnt[1] ;
 wire \pll_dig.div.cnt[2] ;
 wire \pll_dig.div.cnt[3] ;
 wire \pll_dig.div.cnt[4] ;
 wire \pll_dig.div.cnt[5] ;
 wire \pll_dig.div.cnt[6] ;
 wire \pll_dig.div.cnt[7] ;
 wire \pll_dig.div.div[0] ;
 wire \pll_dig.div.div[2] ;
 wire \pll_dig.div.div[3] ;
 wire \pll_dig.div.div[4] ;
 wire \pll_dig.div.div[5] ;
 wire \pll_dig.div.div[6] ;
 wire \pll_dig.div.div[7] ;
 wire \pll_dig.div.div_for_counts_is_pend ;
 wire \pll_dig.div.div_pend[0] ;
 wire \pll_dig.div.div_pend[2] ;
 wire \pll_dig.div.div_pend[3] ;
 wire \pll_dig.div.div_pend[4] ;
 wire \pll_dig.div.div_pend[5] ;
 wire \pll_dig.div.div_pend[6] ;
 wire \pll_dig.div.div_pend[7] ;
 wire \pll_dig.div.enter_req ;
 wire \pll_dig.div.hi_cur[1] ;
 wire \pll_dig.div.hi_cur[2] ;
 wire \pll_dig.div.hi_cur[3] ;
 wire \pll_dig.div.hi_cur[4] ;
 wire \pll_dig.div.hi_cur[5] ;
 wire \pll_dig.div.hi_cur[6] ;
 wire \pll_dig.div.hi_cur[7] ;
 wire \pll_dig.div.hi_pend[1] ;
 wire \pll_dig.div.hi_pend[2] ;
 wire \pll_dig.div.hi_pend[3] ;
 wire \pll_dig.div.hi_pend[4] ;
 wire \pll_dig.div.hi_pend[5] ;
 wire \pll_dig.div.hi_pend[6] ;
 wire \pll_dig.div.hi_pend[7] ;
 wire \pll_dig.div.high_count[1] ;
 wire \pll_dig.div.high_count[2] ;
 wire \pll_dig.div.high_count[3] ;
 wire \pll_dig.div.high_count[4] ;
 wire \pll_dig.div.high_count[5] ;
 wire \pll_dig.div.high_count[6] ;
 wire \pll_dig.div.high_count[7] ;
 wire \pll_dig.div.high_count_pend[1] ;
 wire \pll_dig.div.high_count_pend[2] ;
 wire \pll_dig.div.high_count_pend[3] ;
 wire \pll_dig.div.high_count_pend[4] ;
 wire \pll_dig.div.high_count_pend[5] ;
 wire \pll_dig.div.high_count_pend[6] ;
 wire \pll_dig.div.high_count_pend[7] ;
 wire \pll_dig.div.high_phase ;
 wire \pll_dig.div.leave_req ;
 wire \pll_dig.div.lo_cur[1] ;
 wire \pll_dig.div.lo_cur[2] ;
 wire \pll_dig.div.lo_cur[3] ;
 wire \pll_dig.div.lo_cur[4] ;
 wire \pll_dig.div.lo_cur[5] ;
 wire \pll_dig.div.lo_cur[6] ;
 wire \pll_dig.div.lo_pend[1] ;
 wire \pll_dig.div.lo_pend[2] ;
 wire \pll_dig.div.lo_pend[3] ;
 wire \pll_dig.div.lo_pend[4] ;
 wire \pll_dig.div.lo_pend[5] ;
 wire \pll_dig.div.lo_pend[6] ;
 wire \pll_dig.div.low_count[1] ;
 wire \pll_dig.div.low_count[2] ;
 wire \pll_dig.div.low_count[3] ;
 wire \pll_dig.div.low_count[4] ;
 wire \pll_dig.div.low_count[5] ;
 wire \pll_dig.div.low_count[6] ;
 wire \pll_dig.div.low_count_pend[1] ;
 wire \pll_dig.div.low_count_pend[2] ;
 wire \pll_dig.div.low_count_pend[3] ;
 wire \pll_dig.div.low_count_pend[4] ;
 wire \pll_dig.div.low_count_pend[5] ;
 wire \pll_dig.div.low_count_pend[6] ;
 wire \pll_dig.div.n_hi ;
 wire \pll_dig.div.ncnt[0] ;
 wire \pll_dig.div.ncnt[1] ;
 wire \pll_dig.div.ncnt[2] ;
 wire \pll_dig.div.ncnt[3] ;
 wire \pll_dig.div.ncnt[4] ;
 wire \pll_dig.div.ncnt[5] ;
 wire \pll_dig.div.ncnt[6] ;
 wire \pll_dig.div.ncnt[7] ;
 wire \pll_dig.div.out_reg ;
 wire \pll_dig.div.p_hi ;
 wire \pll_dig.div.pcnt[0] ;
 wire \pll_dig.div.pcnt[1] ;
 wire \pll_dig.div.pcnt[2] ;
 wire \pll_dig.div.pcnt[3] ;
 wire \pll_dig.div.pcnt[4] ;
 wire \pll_dig.div.pcnt[5] ;
 wire \pll_dig.div.pcnt[6] ;
 wire \pll_dig.div.pcnt[7] ;
 wire \pll_dig.div.pend ;
 wire \pll_dig.div.rst_n ;
 wire \pll_dig.div.use_clk ;
 wire \pll_dig.div.use_clk_p ;
 wire \pll_dig.div_rst_cnt[0] ;
 wire \pll_dig.div_rst_cnt[1] ;
 wire \pll_dig.div_rst_cnt[2] ;
 wire \pll_dig.div_rst_cnt[3] ;
 wire \pll_dig.dlf.ILL_N_C ;
 wire \pll_dig.dlf.ILL_P_C ;
 wire \pll_dig.dlf.INT[0] ;
 wire \pll_dig.dlf.INT[10] ;
 wire \pll_dig.dlf.INT[11] ;
 wire \pll_dig.dlf.INT[12] ;
 wire \pll_dig.dlf.INT[13] ;
 wire \pll_dig.dlf.INT[14] ;
 wire \pll_dig.dlf.INT[1] ;
 wire \pll_dig.dlf.INT[2] ;
 wire \pll_dig.dlf.INT[3] ;
 wire \pll_dig.dlf.INT[4] ;
 wire \pll_dig.dlf.INT[5] ;
 wire \pll_dig.dlf.INT[6] ;
 wire \pll_dig.dlf.INT[7] ;
 wire \pll_dig.dlf.INT[8] ;
 wire \pll_dig.dlf.INT[9] ;
 wire \pll_dig.dlf.OUT_C[0] ;
 wire \pll_dig.dlf.OUT_C[10] ;
 wire \pll_dig.dlf.OUT_C[11] ;
 wire \pll_dig.dlf.OUT_C[12] ;
 wire \pll_dig.dlf.OUT_C[13] ;
 wire \pll_dig.dlf.OUT_C[14] ;
 wire \pll_dig.dlf.OUT_C[1] ;
 wire \pll_dig.dlf.OUT_C[2] ;
 wire \pll_dig.dlf.OUT_C[3] ;
 wire \pll_dig.dlf.OUT_C[4] ;
 wire \pll_dig.dlf.OUT_C[5] ;
 wire \pll_dig.dlf.OUT_C[6] ;
 wire \pll_dig.dlf.OUT_C[7] ;
 wire \pll_dig.dlf.OUT_C[8] ;
 wire \pll_dig.dlf.OUT_C[9] ;
 wire \pll_dig.dsm_impl.DSM_CK ;
 wire \pll_dig.dsm_impl.DSM_CK_G ;
 wire \pll_dig.dsm_impl.FCWF[0] ;
 wire \pll_dig.dsm_impl.FCWF[10] ;
 wire \pll_dig.dsm_impl.FCWF[11] ;
 wire \pll_dig.dsm_impl.FCWF[1] ;
 wire \pll_dig.dsm_impl.FCWF[2] ;
 wire \pll_dig.dsm_impl.FCWF[3] ;
 wire \pll_dig.dsm_impl.FCWF[4] ;
 wire \pll_dig.dsm_impl.FCWF[5] ;
 wire \pll_dig.dsm_impl.FCWF[6] ;
 wire \pll_dig.dsm_impl.FCWF[7] ;
 wire \pll_dig.dsm_impl.FCWF[8] ;
 wire \pll_dig.dsm_impl.FCWF[9] ;
 wire \pll_dig.dsm_impl.FCWI[1] ;
 wire \pll_dig.dsm_impl.FCWI[2] ;
 wire \pll_dig.dsm_impl.FCWI[3] ;
 wire \pll_dig.dsm_impl.FCWI[4] ;
 wire \pll_dig.dsm_impl.dsm.cin_stg1 ;
 wire \pll_dig.dsm_impl.dsm.cin_stg2 ;
 wire \pll_dig.dsm_impl.dsm.dff_ca2 ;
 wire \pll_dig.dsm_impl.dsm.dff_ca3 ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[0] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[10] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[11] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[1] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[2] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[3] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[4] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[5] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[6] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[7] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[8] ;
 wire \pll_dig.dsm_impl.dsm.dff_err1[9] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[0] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[10] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[11] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[1] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[2] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[3] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[4] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[5] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[6] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[7] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[8] ;
 wire \pll_dig.dsm_impl.dsm.dff_err2[9] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[0] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[10] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[11] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[1] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[2] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[3] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[4] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[5] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[6] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[7] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[8] ;
 wire \pll_dig.dsm_impl.dsm.dff_err3[9] ;
 wire \pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ;
 wire \pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ;
 wire \pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ;
 wire \pll_dig.dsm_impl.locked_dsm_s1 ;
 wire \pll_dig.dsm_impl.locked_dsm_s2 ;
 wire \pll_dig.dsm_impl.u_dsm_icg.EN ;
 wire \pll_dig.fail_q ;
 wire \pll_dig.fail_qq ;
 wire \pll_dig.flock.FCW_NA[0] ;
 wire \pll_dig.flock.FCW_NA[10] ;
 wire \pll_dig.flock.FCW_NA[1] ;
 wire \pll_dig.flock.FCW_NA[2] ;
 wire \pll_dig.flock.FCW_NA[3] ;
 wire \pll_dig.flock.FCW_NA[4] ;
 wire \pll_dig.flock.FCW_NA[5] ;
 wire \pll_dig.flock.FCW_NA[6] ;
 wire \pll_dig.flock.FCW_NA[7] ;
 wire \pll_dig.flock.FCW_PA[1] ;
 wire \pll_dig.flock.FCW_PA[2] ;
 wire \pll_dig.flock.FCW_PA[3] ;
 wire \pll_dig.flock.FCW_PA[4] ;
 wire \pll_dig.flock.FCW_PA[5] ;
 wire \pll_dig.flock.FCW_PA[6] ;
 wire \pll_dig.flock.FCW_PA[7] ;
 wire \pll_dig.flock.FCW_PA[8] ;
 wire \pll_dig.flock.REF_G ;
 wire \pll_dig.flock.cap_valid ;
 wire \pll_dig.flock.cnt[10] ;
 wire \pll_dig.flock.cnt[11] ;
 wire \pll_dig.flock.cnt[12] ;
 wire \pll_dig.flock.cnt[13] ;
 wire \pll_dig.flock.cnt[14] ;
 wire \pll_dig.flock.cnt[15] ;
 wire \pll_dig.flock.cnt[1] ;
 wire \pll_dig.flock.cnt[2] ;
 wire \pll_dig.flock.cnt[3] ;
 wire \pll_dig.flock.cnt[4] ;
 wire \pll_dig.flock.cnt[5] ;
 wire \pll_dig.flock.cnt[6] ;
 wire \pll_dig.flock.cnt[7] ;
 wire \pll_dig.flock.cnt[8] ;
 wire \pll_dig.flock.cnt[9] ;
 wire \pll_dig.flock.cnt_bin[0] ;
 wire \pll_dig.flock.cnt_bin[10] ;
 wire \pll_dig.flock.cnt_bin[11] ;
 wire \pll_dig.flock.cnt_bin[12] ;
 wire \pll_dig.flock.cnt_bin[13] ;
 wire \pll_dig.flock.cnt_bin[14] ;
 wire \pll_dig.flock.cnt_bin[1] ;
 wire \pll_dig.flock.cnt_bin[2] ;
 wire \pll_dig.flock.cnt_bin[3] ;
 wire \pll_dig.flock.cnt_bin[4] ;
 wire \pll_dig.flock.cnt_bin[5] ;
 wire \pll_dig.flock.cnt_bin[6] ;
 wire \pll_dig.flock.cnt_bin[7] ;
 wire \pll_dig.flock.cnt_bin[8] ;
 wire \pll_dig.flock.cnt_bin[9] ;
 wire \pll_dig.flock.cnt_cap[10] ;
 wire \pll_dig.flock.cnt_cap[11] ;
 wire \pll_dig.flock.cnt_cap[12] ;
 wire \pll_dig.flock.cnt_cap[13] ;
 wire \pll_dig.flock.cnt_cap[14] ;
 wire \pll_dig.flock.cnt_cap[15] ;
 wire \pll_dig.flock.cnt_cap[1] ;
 wire \pll_dig.flock.cnt_cap[2] ;
 wire \pll_dig.flock.cnt_cap[3] ;
 wire \pll_dig.flock.cnt_cap[4] ;
 wire \pll_dig.flock.cnt_cap[5] ;
 wire \pll_dig.flock.cnt_cap[6] ;
 wire \pll_dig.flock.cnt_cap[7] ;
 wire \pll_dig.flock.cnt_cap[8] ;
 wire \pll_dig.flock.cnt_cap[9] ;
 wire \pll_dig.flock.cnt_coarse_wait[0] ;
 wire \pll_dig.flock.cnt_coarse_wait[1] ;
 wire \pll_dig.flock.cnt_coarse_wait[2] ;
 wire \pll_dig.flock.cnt_coarse_wait[3] ;
 wire \pll_dig.flock.cnt_coarse_wait[4] ;
 wire \pll_dig.flock.cnt_coarse_wait[5] ;
 wire \pll_dig.flock.cnt_coarse_wait[6] ;
 wire \pll_dig.flock.cnt_coarse_wait[7] ;
 wire \pll_dig.flock.cnt_done[0] ;
 wire \pll_dig.flock.cnt_done[1] ;
 wire \pll_dig.flock.cnt_done[2] ;
 wire \pll_dig.flock.cnt_done[3] ;
 wire \pll_dig.flock.cnt_done[4] ;
 wire \pll_dig.flock.cnt_done[5] ;
 wire \pll_dig.flock.cnt_done[6] ;
 wire \pll_dig.flock.cnt_done[7] ;
 wire \pll_dig.flock.cnt_err[0] ;
 wire \pll_dig.flock.cnt_err[1] ;
 wire \pll_dig.flock.cnt_err[2] ;
 wire \pll_dig.flock.cnt_err[3] ;
 wire \pll_dig.flock.cnt_err[4] ;
 wire \pll_dig.flock.cnt_err[5] ;
 wire \pll_dig.flock.cnt_err[6] ;
 wire \pll_dig.flock.cnt_err[7] ;
 wire \pll_dig.flock.cnt_filt[0] ;
 wire \pll_dig.flock.cnt_filt[10] ;
 wire \pll_dig.flock.cnt_filt[11] ;
 wire \pll_dig.flock.cnt_filt[12] ;
 wire \pll_dig.flock.cnt_filt[13] ;
 wire \pll_dig.flock.cnt_filt[14] ;
 wire \pll_dig.flock.cnt_filt[15] ;
 wire \pll_dig.flock.cnt_filt[1] ;
 wire \pll_dig.flock.cnt_filt[2] ;
 wire \pll_dig.flock.cnt_filt[3] ;
 wire \pll_dig.flock.cnt_filt[4] ;
 wire \pll_dig.flock.cnt_filt[5] ;
 wire \pll_dig.flock.cnt_filt[6] ;
 wire \pll_dig.flock.cnt_filt[7] ;
 wire \pll_dig.flock.cnt_filt[8] ;
 wire \pll_dig.flock.cnt_filt[9] ;
 wire \pll_dig.flock.cnt_gray[0] ;
 wire \pll_dig.flock.cnt_gray[10] ;
 wire \pll_dig.flock.cnt_gray[11] ;
 wire \pll_dig.flock.cnt_gray[12] ;
 wire \pll_dig.flock.cnt_gray[13] ;
 wire \pll_dig.flock.cnt_gray[14] ;
 wire \pll_dig.flock.cnt_gray[15] ;
 wire \pll_dig.flock.cnt_gray[1] ;
 wire \pll_dig.flock.cnt_gray[2] ;
 wire \pll_dig.flock.cnt_gray[3] ;
 wire \pll_dig.flock.cnt_gray[4] ;
 wire \pll_dig.flock.cnt_gray[5] ;
 wire \pll_dig.flock.cnt_gray[6] ;
 wire \pll_dig.flock.cnt_gray[7] ;
 wire \pll_dig.flock.cnt_gray[8] ;
 wire \pll_dig.flock.cnt_gray[9] ;
 wire \pll_dig.flock.cnt_gray_s1[0] ;
 wire \pll_dig.flock.cnt_gray_s1[10] ;
 wire \pll_dig.flock.cnt_gray_s1[11] ;
 wire \pll_dig.flock.cnt_gray_s1[12] ;
 wire \pll_dig.flock.cnt_gray_s1[13] ;
 wire \pll_dig.flock.cnt_gray_s1[14] ;
 wire \pll_dig.flock.cnt_gray_s1[15] ;
 wire \pll_dig.flock.cnt_gray_s1[1] ;
 wire \pll_dig.flock.cnt_gray_s1[2] ;
 wire \pll_dig.flock.cnt_gray_s1[3] ;
 wire \pll_dig.flock.cnt_gray_s1[4] ;
 wire \pll_dig.flock.cnt_gray_s1[5] ;
 wire \pll_dig.flock.cnt_gray_s1[6] ;
 wire \pll_dig.flock.cnt_gray_s1[7] ;
 wire \pll_dig.flock.cnt_gray_s1[8] ;
 wire \pll_dig.flock.cnt_gray_s1[9] ;
 wire \pll_dig.flock.cnt_gray_s2[0] ;
 wire \pll_dig.flock.cnt_gray_s2[10] ;
 wire \pll_dig.flock.cnt_gray_s2[11] ;
 wire \pll_dig.flock.cnt_gray_s2[12] ;
 wire \pll_dig.flock.cnt_gray_s2[13] ;
 wire \pll_dig.flock.cnt_gray_s2[14] ;
 wire \pll_dig.flock.cnt_gray_s2[15] ;
 wire \pll_dig.flock.cnt_gray_s2[1] ;
 wire \pll_dig.flock.cnt_gray_s2[2] ;
 wire \pll_dig.flock.cnt_gray_s2[3] ;
 wire \pll_dig.flock.cnt_gray_s2[4] ;
 wire \pll_dig.flock.cnt_gray_s2[5] ;
 wire \pll_dig.flock.cnt_gray_s2[6] ;
 wire \pll_dig.flock.cnt_gray_s2[7] ;
 wire \pll_dig.flock.cnt_gray_s2[8] ;
 wire \pll_dig.flock.cnt_gray_s2[9] ;
 wire \pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ;
 wire \pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ;
 wire \pll_dig.flock.freq_miss[0] ;
 wire \pll_dig.flock.freq_miss[1] ;
 wire \pll_dig.flock.freq_miss[2] ;
 wire \pll_dig.flock.started ;
 wire \pll_dig.flock.u_fll_icg.EN ;
 wire \pll_dig.lock_detector.bad_cnt[0] ;
 wire \pll_dig.lock_detector.bad_cnt[1] ;
 wire \pll_dig.lock_detector.bad_cnt[2] ;
 wire \pll_dig.lock_detector.seen_n ;
 wire \pll_dig.lock_detector.seen_p ;
 wire \pll_dig.lock_detector.win_cnt[0] ;
 wire \pll_dig.lock_detector.win_cnt[1] ;
 wire \pll_dig.lock_detector.win_cnt[2] ;
 wire \pll_dig.lock_detector.win_cnt[3] ;
 wire \pll_dig.lock_detector.win_cnt[4] ;
 wire \pll_dig.locked_q ;
 wire \pll_dig.out_div2 ;
 wire \pll_dig.out_edges[0] ;
 wire \pll_dig.out_edges[1] ;
 wire \pll_dig.out_edges[2] ;
 wire \pll_dig.out_edges[3] ;
 wire \pll_dig.out_edges[4] ;
 wire \pll_dig.out_edges[5] ;
 wire \pll_dig.out_edges[6] ;
 wire \pll_dig.out_edges[7] ;
 wire \pll_dig.out_edges[8] ;
 wire \pll_dig.out_edges[9] ;
 wire \pll_dig.out_edges_g1[0] ;
 wire \pll_dig.out_edges_g1[1] ;
 wire \pll_dig.out_edges_g1[2] ;
 wire \pll_dig.out_edges_g1[3] ;
 wire \pll_dig.out_edges_g1[4] ;
 wire \pll_dig.out_edges_g1[5] ;
 wire \pll_dig.out_edges_g1[6] ;
 wire \pll_dig.out_edges_g1[7] ;
 wire \pll_dig.out_edges_g1[8] ;
 wire \pll_dig.out_edges_g1[9] ;
 wire \pll_dig.out_edges_g2[0] ;
 wire \pll_dig.out_edges_g2[1] ;
 wire \pll_dig.out_edges_g2[2] ;
 wire \pll_dig.out_edges_g2[3] ;
 wire \pll_dig.out_edges_g2[4] ;
 wire \pll_dig.out_edges_g2[5] ;
 wire \pll_dig.out_edges_g2[6] ;
 wire \pll_dig.out_edges_g2[7] ;
 wire \pll_dig.out_edges_g2[8] ;
 wire \pll_dig.out_edges_g2[9] ;
 wire \pll_dig.out_edges_g2_q[0] ;
 wire \pll_dig.out_edges_g2_q[1] ;
 wire \pll_dig.out_edges_g2_q[2] ;
 wire \pll_dig.out_edges_g2_q[3] ;
 wire \pll_dig.out_edges_g2_q[4] ;
 wire \pll_dig.out_edges_g2_q[5] ;
 wire \pll_dig.out_edges_g2_q[6] ;
 wire \pll_dig.out_edges_g2_q[7] ;
 wire \pll_dig.out_edges_g2_q[8] ;
 wire \pll_dig.out_edges_g2_q[9] ;
 wire \pll_dig.out_edges_gray[0] ;
 wire \pll_dig.out_edges_gray[1] ;
 wire \pll_dig.out_edges_gray[2] ;
 wire \pll_dig.out_edges_gray[3] ;
 wire \pll_dig.out_edges_gray[4] ;
 wire \pll_dig.out_edges_gray[5] ;
 wire \pll_dig.out_edges_gray[6] ;
 wire \pll_dig.out_edges_gray[7] ;
 wire \pll_dig.out_edges_gray[8] ;
 wire \pll_dig.out_edges_next[0] ;
 wire \pll_dig.out_edges_next[1] ;
 wire \pll_dig.out_edges_next[2] ;
 wire \pll_dig.out_edges_next[3] ;
 wire \pll_dig.out_edges_next[4] ;
 wire \pll_dig.out_edges_next[5] ;
 wire \pll_dig.out_edges_next[6] ;
 wire \pll_dig.out_edges_next[7] ;
 wire \pll_dig.out_edges_next[8] ;
 wire \pll_dig.out_edges_next[9] ;
 wire \pll_dig.ref_fail ;
 wire \pll_dig.ref_wd.cnt[0] ;
 wire \pll_dig.ref_wd.cnt[1] ;
 wire \pll_dig.ref_wd.cnt[2] ;
 wire \pll_dig.ref_wd.cnt[3] ;
 wire \pll_dig.ref_wd.cnt[4] ;
 wire \pll_dig.ref_wd.cnt[5] ;
 wire \pll_dig.ref_wd.cnt[6] ;
 wire \pll_dig.ref_wd.cnt[7] ;
 wire \pll_dig.ref_wd.cnt[8] ;
 wire \pll_dig.ref_wd.cnt[9] ;
 wire \pll_dig.ref_wd.watch_s1 ;
 wire \pll_dig.ref_wd.watch_s2 ;
 wire \pll_dig.ref_wd.watch_s3 ;
 wire \pll_dig.state[1] ;
 wire \pll_dig.state[2] ;
 wire \pll_dig.state[3] ;
 wire \pll_dig.state[4] ;
 wire \pll_dig.u_ddr_ck.ck_en ;
 wire net61;
 wire net62;
 wire net63;
 wire net64;
 wire net65;
 wire net66;
 wire net67;
 wire net68;
 wire net69;
 wire net70;
 wire net71;
 wire net72;
 wire net73;
 wire net74;
 wire net75;
 wire net76;
 wire net77;
 wire net78;
 wire net79;
 wire net80;
 wire net81;
 wire net82;
 wire net83;
 wire net84;
 wire net85;
 wire net86;
 wire net87;
 wire net88;
 wire net89;
 wire net90;
 wire net91;
 wire net92;
 wire net93;
 wire net94;
 wire net95;
 wire net96;
 wire net97;
 wire net98;
 wire net99;
 wire net100;
 wire net101;
 wire net102;
 wire net103;
 wire net104;
 wire net105;
 wire net106;
 wire net107;
 wire net108;
 wire net109;
 wire net110;
 wire net111;
 wire net112;
 wire net113;
 wire net114;
 wire net115;
 wire net116;
 wire net117;
 wire net118;
 wire net119;
 wire net120;
 wire net121;
 wire net122;
 wire net123;
 wire net124;
 wire net125;
 wire net126;
 wire net127;
 wire net128;
 wire net129;
 wire net130;
 wire net131;
 wire net132;
 wire net133;
 wire net134;
 wire net135;
 wire net136;
 wire net137;
 wire net138;
 wire net139;
 wire net140;
 wire net141;
 wire net142;
 wire net143;
 wire net144;
 wire net145;
 wire net146;
 wire net147;
 wire net148;
 wire net149;
 wire net484;
 wire net151;
 wire net152;
 wire net153;
 wire net154;
 wire net155;
 wire net156;
 wire net157;
 wire net158;
 wire net159;
 wire net160;
 wire net161;
 wire net162;
 wire net163;
 wire net164;
 wire net165;
 wire net166;
 wire net167;
 wire net168;
 wire net169;
 wire net170;
 wire net171;
 wire net172;
 wire net173;
 wire net174;
 wire net175;
 wire net176;
 wire net177;
 wire net178;
 wire net179;
 wire net180;
 wire net181;
 wire net182;
 wire net183;
 wire net184;
 wire net185;
 wire net186;
 wire net187;
 wire net188;
 wire net189;
 wire net190;
 wire net191;
 wire net192;
 wire net193;
 wire net194;
 wire net195;
 wire net196;
 wire net197;
 wire net198;
 wire net199;
 wire net200;
 wire net201;
 wire net202;
 wire net203;
 wire net204;
 wire net205;
 wire net206;
 wire net207;
 wire net208;
 wire net209;
 wire net210;
 wire net211;
 wire net212;
 wire net213;
 wire net214;
 wire net215;
 wire net216;
 wire net217;
 wire net218;
 wire net219;
 wire net220;
 wire net221;
 wire net222;
 wire net223;
 wire net224;
 wire net225;
 wire net226;
 wire net227;
 wire net228;
 wire net229;
 wire net230;
 wire net231;
 wire net232;
 wire net233;
 wire net234;
 wire net235;
 wire net236;
 wire net237;
 wire net238;
 wire net239;
 wire net240;
 wire net241;
 wire net242;
 wire net243;
 wire net;
 wire net59_regs;
 wire net60_regs;
 wire \pll_dig.dsm_impl.DSM_CK_regs ;
 wire clknet_0_REF;
 wire clknet_1_0__leaf_REF;
 wire clknet_1_1__leaf_REF;
 wire clknet_0_REF_regs;
 wire clknet_4_0_0_REF_regs;
 wire clknet_4_1_0_REF_regs;
 wire clknet_4_2_0_REF_regs;
 wire clknet_4_3_0_REF_regs;
 wire clknet_4_4_0_REF_regs;
 wire clknet_4_5_0_REF_regs;
 wire clknet_4_6_0_REF_regs;
 wire clknet_4_7_0_REF_regs;
 wire clknet_4_8_0_REF_regs;
 wire clknet_4_9_0_REF_regs;
 wire clknet_4_10_0_REF_regs;
 wire clknet_4_11_0_REF_regs;
 wire clknet_4_12_0_REF_regs;
 wire clknet_4_13_0_REF_regs;
 wire clknet_4_14_0_REF_regs;
 wire clknet_4_15_0_REF_regs;
 wire clknet_5_0__leaf_REF_regs;
 wire clknet_5_1__leaf_REF_regs;
 wire clknet_5_2__leaf_REF_regs;
 wire clknet_5_3__leaf_REF_regs;
 wire clknet_5_4__leaf_REF_regs;
 wire clknet_5_5__leaf_REF_regs;
 wire clknet_5_6__leaf_REF_regs;
 wire clknet_5_7__leaf_REF_regs;
 wire clknet_5_8__leaf_REF_regs;
 wire clknet_5_9__leaf_REF_regs;
 wire clknet_5_10__leaf_REF_regs;
 wire clknet_5_11__leaf_REF_regs;
 wire clknet_5_12__leaf_REF_regs;
 wire clknet_5_13__leaf_REF_regs;
 wire clknet_5_14__leaf_REF_regs;
 wire clknet_5_15__leaf_REF_regs;
 wire clknet_5_16__leaf_REF_regs;
 wire clknet_5_17__leaf_REF_regs;
 wire clknet_5_18__leaf_REF_regs;
 wire clknet_5_19__leaf_REF_regs;
 wire clknet_5_20__leaf_REF_regs;
 wire clknet_5_21__leaf_REF_regs;
 wire clknet_5_22__leaf_REF_regs;
 wire clknet_5_23__leaf_REF_regs;
 wire clknet_5_24__leaf_REF_regs;
 wire clknet_5_25__leaf_REF_regs;
 wire clknet_5_26__leaf_REF_regs;
 wire clknet_5_27__leaf_REF_regs;
 wire clknet_5_28__leaf_REF_regs;
 wire clknet_5_29__leaf_REF_regs;
 wire clknet_5_30__leaf_REF_regs;
 wire clknet_5_31__leaf_REF_regs;
 wire clknet_0_net59;
 wire clknet_1_0__leaf_net59;
 wire clknet_1_1__leaf_net59;
 wire clknet_0_net59_regs;
 wire clknet_4_0_0_net59_regs;
 wire clknet_4_1_0_net59_regs;
 wire clknet_4_2_0_net59_regs;
 wire clknet_4_3_0_net59_regs;
 wire clknet_4_4_0_net59_regs;
 wire clknet_4_5_0_net59_regs;
 wire clknet_4_6_0_net59_regs;
 wire clknet_4_7_0_net59_regs;
 wire clknet_4_8_0_net59_regs;
 wire clknet_4_9_0_net59_regs;
 wire clknet_4_10_0_net59_regs;
 wire clknet_4_11_0_net59_regs;
 wire clknet_4_12_0_net59_regs;
 wire clknet_4_13_0_net59_regs;
 wire clknet_4_14_0_net59_regs;
 wire clknet_4_15_0_net59_regs;
 wire clknet_5_0__leaf_net59_regs;
 wire clknet_5_1__leaf_net59_regs;
 wire clknet_5_2__leaf_net59_regs;
 wire clknet_5_3__leaf_net59_regs;
 wire clknet_5_4__leaf_net59_regs;
 wire clknet_5_5__leaf_net59_regs;
 wire clknet_5_6__leaf_net59_regs;
 wire clknet_5_7__leaf_net59_regs;
 wire clknet_5_8__leaf_net59_regs;
 wire clknet_5_9__leaf_net59_regs;
 wire clknet_5_10__leaf_net59_regs;
 wire clknet_5_11__leaf_net59_regs;
 wire clknet_5_12__leaf_net59_regs;
 wire clknet_5_13__leaf_net59_regs;
 wire clknet_5_14__leaf_net59_regs;
 wire clknet_5_15__leaf_net59_regs;
 wire clknet_5_16__leaf_net59_regs;
 wire clknet_5_17__leaf_net59_regs;
 wire clknet_5_18__leaf_net59_regs;
 wire clknet_5_19__leaf_net59_regs;
 wire clknet_5_20__leaf_net59_regs;
 wire clknet_5_21__leaf_net59_regs;
 wire clknet_5_22__leaf_net59_regs;
 wire clknet_5_23__leaf_net59_regs;
 wire clknet_5_24__leaf_net59_regs;
 wire clknet_5_25__leaf_net59_regs;
 wire clknet_5_26__leaf_net59_regs;
 wire clknet_5_27__leaf_net59_regs;
 wire clknet_5_28__leaf_net59_regs;
 wire clknet_5_29__leaf_net59_regs;
 wire clknet_5_30__leaf_net59_regs;
 wire clknet_5_31__leaf_net59_regs;
 wire clknet_0_net60;
 wire clknet_1_0__leaf_net60;
 wire clknet_1_1__leaf_net60;
 wire clknet_0_net60_regs;
 wire clknet_1_0__leaf_net60_regs;
 wire clknet_0_MID_OUT;
 wire clknet_3_0__leaf_MID_OUT;
 wire clknet_3_1__leaf_MID_OUT;
 wire clknet_3_2__leaf_MID_OUT;
 wire clknet_3_3__leaf_MID_OUT;
 wire clknet_3_4__leaf_MID_OUT;
 wire clknet_3_5__leaf_MID_OUT;
 wire clknet_3_6__leaf_MID_OUT;
 wire clknet_3_7__leaf_MID_OUT;
 wire clknet_0_INJ_EDGE;
 wire clknet_4_0_0_INJ_EDGE;
 wire clknet_4_1_0_INJ_EDGE;
 wire clknet_4_2_0_INJ_EDGE;
 wire clknet_4_3_0_INJ_EDGE;
 wire clknet_4_4_0_INJ_EDGE;
 wire clknet_4_5_0_INJ_EDGE;
 wire clknet_4_6_0_INJ_EDGE;
 wire clknet_4_7_0_INJ_EDGE;
 wire clknet_4_8_0_INJ_EDGE;
 wire clknet_4_9_0_INJ_EDGE;
 wire clknet_4_10_0_INJ_EDGE;
 wire clknet_4_11_0_INJ_EDGE;
 wire clknet_4_12_0_INJ_EDGE;
 wire clknet_4_13_0_INJ_EDGE;
 wire clknet_4_14_0_INJ_EDGE;
 wire clknet_4_15_0_INJ_EDGE;
 wire \clknet_0_pll_dig.flock.REF_G ;
 wire \clknet_4_0_0_pll_dig.flock.REF_G ;
 wire \clknet_4_1_0_pll_dig.flock.REF_G ;
 wire \clknet_4_2_0_pll_dig.flock.REF_G ;
 wire \clknet_4_3_0_pll_dig.flock.REF_G ;
 wire \clknet_4_4_0_pll_dig.flock.REF_G ;
 wire \clknet_4_5_0_pll_dig.flock.REF_G ;
 wire \clknet_4_6_0_pll_dig.flock.REF_G ;
 wire \clknet_4_7_0_pll_dig.flock.REF_G ;
 wire \clknet_4_8_0_pll_dig.flock.REF_G ;
 wire \clknet_4_9_0_pll_dig.flock.REF_G ;
 wire \clknet_4_10_0_pll_dig.flock.REF_G ;
 wire \clknet_4_11_0_pll_dig.flock.REF_G ;
 wire \clknet_4_12_0_pll_dig.flock.REF_G ;
 wire \clknet_4_13_0_pll_dig.flock.REF_G ;
 wire \clknet_4_14_0_pll_dig.flock.REF_G ;
 wire \clknet_4_15_0_pll_dig.flock.REF_G ;
 wire \clknet_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ;
 wire \clknet_0_pll_dig.out_div2 ;
 wire \clknet_2_0__leaf_pll_dig.out_div2 ;
 wire \clknet_2_1__leaf_pll_dig.out_div2 ;
 wire \clknet_2_2__leaf_pll_dig.out_div2 ;
 wire \clknet_2_3__leaf_pll_dig.out_div2 ;
 wire \clknet_0_pll_dig.CKR ;
 wire \clknet_3_0__leaf_pll_dig.CKR ;
 wire \clknet_3_1__leaf_pll_dig.CKR ;
 wire \clknet_3_2__leaf_pll_dig.CKR ;
 wire \clknet_3_3__leaf_pll_dig.CKR ;
 wire \clknet_3_4__leaf_pll_dig.CKR ;
 wire \clknet_3_5__leaf_pll_dig.CKR ;
 wire \clknet_3_6__leaf_pll_dig.CKR ;
 wire \clknet_3_7__leaf_pll_dig.CKR ;
 wire \clknet_0_pll_dig.dsm_impl.DSM_CK ;
 wire \clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK ;
 wire \clknet_0_pll_dig.dsm_impl.DSM_CK_regs ;
 wire \clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ;
 wire \clknet_1_1__leaf_pll_dig.dsm_impl.DSM_CK_regs ;
 wire delaynet_0_REF;
 wire delaynet_1_REF;
 wire delaynet_2_REF;
 wire delaynet_3_REF;
 wire delaynet_4_REF;
 wire net354;
 wire net355;
 wire net356;
 wire net357;
 wire net358;
 wire net359;
 wire net360;
 wire net361;
 wire net362;
 wire net363;
 wire net364;
 wire net365;
 wire net366;
 wire net367;
 wire net368;
 wire net369;
 wire net370;
 wire net371;
 wire net372;
 wire net373;
 wire net374;
 wire net375;
 wire net376;
 wire net377;
 wire net378;
 wire net379;
 wire net380;
 wire net381;
 wire net382;
 wire net383;
 wire net384;
 wire net385;
 wire net386;
 wire net387;
 wire net439;
 wire net389;
 wire net390;
 wire net391;
 wire net392;
 wire net393;
 wire net394;
 wire net395;
 wire net396;
 wire net397;
 wire net398;
 wire net399;
 wire net400;
 wire net401;
 wire net402;
 wire net403;
 wire net404;
 wire net405;
 wire net406;
 wire net407;
 wire net408;
 wire net409;
 wire net410;
 wire net411;
 wire net413;
 wire net414;
 wire net415;
 wire net416;
 wire net417;
 wire net418;
 wire net419;
 wire net420;
 wire net421;
 wire net422;
 wire net423;
 wire net424;
 wire net425;
 wire net426;
 wire net427;
 wire net428;
 wire net483;
 wire net434;
 wire net435;
 wire net436;
 wire net437;
 wire net438;
 wire net441;
 wire net469;
 wire net470;
 wire net471;
 wire net472;
 wire net473;
 wire net474;
 wire net475;
 wire net476;
 wire net477;
 wire net478;
 wire net479;
 wire net485;
 wire net486;
 wire net487;
 wire net488;
 wire net489;
 wire net490;
 wire net491;
 wire net492;
 wire net493;
 wire net494;
 wire net495;
 wire net496;
 wire net497;
 wire net498;
 wire net499;
 wire net500;
 wire net501;
 wire net502;
 wire net503;
 wire net504;
 wire net505;
 wire net506;
 wire net507;
 wire net508;
 wire net509;
 wire net510;
 wire net511;
 wire net512;
 wire net513;
 wire net514;
 wire net515;
 wire net516;
 wire net517;
 wire net518;
 wire net519;
 wire net520;
 wire net521;
 wire net522;
 wire net523;
 wire net524;
 wire net525;
 wire net526;
 wire net527;
 wire net528;
 wire net529;
 wire net530;
 wire net531;
 wire net532;
 wire net533;
 wire net534;
 wire net535;
 wire net536;
 wire net537;
 wire net538;
 wire net539;
 wire net540;
 wire net541;
 wire net542;
 wire net543;
 wire net544;
 wire net545;
 wire net546;
 wire net547;
 wire net548;
 wire net549;
 wire net550;
 wire net551;
 wire net552;
 wire net553;
 wire net554;
 wire net555;
 wire net556;
 wire net557;
 wire net558;
 wire net559;
 wire net560;
 wire net561;
 wire net562;
 wire net563;
 wire net564;
 wire net565;
 wire net566;
 wire net567;
 wire net568;
 wire net569;
 wire net570;
 wire net571;
 wire net572;
 wire net573;
 wire net574;
 wire net575;
 wire net576;
 wire net577;
 wire net578;
 wire net579;
 wire net580;
 wire net581;
 wire net582;
 wire net583;
 wire net584;
 wire net585;
 wire net586;
 wire net587;
 wire net588;
 wire net589;
 wire net590;
 wire net591;
 wire net592;
 wire net593;
 wire net594;
 wire net595;
 wire net596;
 wire net597;
 wire net598;
 wire net599;
 wire net600;
 wire net601;
 wire net602;
 wire net603;
 wire net604;
 wire net605;
 wire net606;
 wire net607;
 wire net608;
 wire net609;
 wire net610;
 wire net611;
 wire net612;
 wire net613;
 wire net614;
 wire net615;
 wire net616;
 wire net617;
 wire net618;
 wire net619;
 wire net620;
 wire net621;
 wire net622;
 wire net623;
 wire net624;
 wire net625;
 wire net626;
 wire net627;
 wire net628;
 wire net629;
 wire net630;
 wire net631;
 wire net632;
 wire net633;
 wire net634;
 wire net635;
 wire net636;
 wire net637;
 wire net638;
 wire net639;
 wire net640;
 wire net641;
 wire net642;
 wire net643;
 wire net644;
 wire net645;
 wire net646;
 wire net647;
 wire net648;
 wire net649;
 wire net650;
 wire net651;
 wire net652;
 wire net653;
 wire net654;
 wire net655;
 wire net656;
 wire net657;
 wire net658;
 wire net659;
 wire net660;
 wire net661;
 wire net662;
 wire net663;
 wire net664;
 wire net665;
 wire net666;
 wire net667;
 wire net668;
 wire net669;
 wire net670;
 wire net671;
 wire net672;
 wire net673;
 wire net674;
 wire net675;
 wire net676;
 wire net677;
 wire net678;
 wire net679;
 wire net680;
 wire net681;
 wire net682;
 wire net683;
 wire net684;
 wire net685;
 wire net686;
 wire net687;
 wire net688;
 wire net689;
 wire net690;
 wire net691;
 wire net692;
 wire net693;
 wire net694;
 wire net695;
 wire net696;
 wire net697;
 wire net698;
 wire net699;
 wire net700;
 wire net701;
 wire net702;
 wire net703;
 wire net704;
 wire net705;
 wire net706;
 wire net707;
 wire net708;
 wire net709;
 wire net710;
 wire net711;
 wire net712;
 wire net713;
 wire net714;
 wire net715;
 wire net716;
 wire net717;
 wire net718;
 wire net719;
 wire net720;
 wire net721;
 wire net722;
 wire net723;
 wire net724;
 wire net725;
 wire net726;
 wire net727;
 wire net728;
 wire net729;
 wire net730;
 wire net731;
 wire net732;
 wire net733;
 wire net734;
 wire net735;
 wire net736;
 wire net737;
 wire net738;
 wire net739;
 wire net740;
 wire net741;
 wire net742;
 wire net743;
 wire net744;
 wire net745;
 wire net746;
 wire net747;
 wire net748;
 wire net749;
 wire net750;
 wire net751;
 wire net752;
 wire net753;
 wire net754;
 wire net755;
 wire net756;
 wire net757;
 wire net758;
 wire net759;
 wire net760;
 wire net761;
 wire net762;
 wire net763;
 wire net764;
 wire net765;
 wire net766;
 wire net767;
 wire net768;
 wire net769;
 wire net770;
 wire net771;
 wire net772;
 wire net773;
 wire net774;
 wire net775;
 wire net776;
 wire net777;
 wire net778;
 wire net779;
 wire net780;
 wire net781;
 wire net782;
 wire net783;
 wire net784;
 wire net785;
 wire net786;
 wire net787;
 wire net788;
 wire net789;
 wire net790;
 wire net791;
 wire net792;
 wire net793;
 wire net794;
 wire net795;

 sg13g2_inv_1 _2106_ (.Y(_0479_),
    .A(net402));
 sg13g2_inv_1 _2107_ (.Y(_0480_),
    .A(\pll_dig.div.ncnt[3] ));
 sg13g2_inv_1 _2108_ (.Y(_0489_),
    .A(net7));
 sg13g2_inv_1 _2109_ (.Y(_0574_),
    .A(\pll_dig.dlf.INT[4] ));
 sg13g2_nor2_1 _2110_ (.A(\pll_dig.flock.cnt_gray[10] ),
    .B(net129),
    .Y(_1332_));
 sg13g2_nand2_1 _2111_ (.Y(_1333_),
    .A(_0529_),
    .B(net424));
 sg13g2_xnor2_1 _2112_ (.Y(_1334_),
    .A(\pll_dig.flock.cnt[12] ),
    .B(_1333_));
 sg13g2_a21oi_1 _2113_ (.A1(net128),
    .A2(_1334_),
    .Y(_0431_),
    .B1(_1332_));
 sg13g2_nand2_1 _2114_ (.Y(_1335_),
    .A(\pll_dig.ref_wd.cnt[9] ),
    .B(net123));
 sg13g2_a21oi_1 _2115_ (.A1(_0587_),
    .A2(net123),
    .Y(_1336_),
    .B1(\pll_dig.ref_wd.cnt[0] ));
 sg13g2_a21oi_1 _2116_ (.A1(\pll_dig.ref_wd.cnt[0] ),
    .A2(_1335_),
    .Y(_0430_),
    .B1(_1336_));
 sg13g2_o21ai_1 _2117_ (.B1(net123),
    .Y(_1337_),
    .A1(\pll_dig.ref_wd.cnt[8] ),
    .A2(_0924_));
 sg13g2_nand3_1 _2118_ (.B(\pll_dig.ref_wd.cnt[8] ),
    .C(_0920_),
    .A(\pll_dig.ref_wd.cnt[7] ),
    .Y(_1338_));
 sg13g2_a21oi_1 _2119_ (.A1(\pll_dig.ref_wd.cnt[8] ),
    .A2(_0924_),
    .Y(_0429_),
    .B1(_1337_));
 sg13g2_inv_1 _2120_ (.Y(_0575_),
    .A(net694));
 sg13g2_a21o_1 _2121_ (.A2(net124),
    .A1(net428),
    .B1(_0912_),
    .X(_0428_));
 sg13g2_nor2_2 _2122_ (.A(net414),
    .B(_0529_),
    .Y(_1339_));
 sg13g2_xnor2_1 _2123_ (.Y(_0427_),
    .A(_0529_),
    .B(_1328_));
 sg13g2_nor2_1 _2124_ (.A(\pll_dig.flock.cnt[4] ),
    .B(net420),
    .Y(_1340_));
 sg13g2_nor2_1 _2125_ (.A(\pll_dig.flock.cnt_gray[3] ),
    .B(net126),
    .Y(_1341_));
 sg13g2_xor2_1 _2126_ (.B(_1340_),
    .A(\pll_dig.flock.cnt[5] ),
    .X(_1342_));
 sg13g2_a21oi_1 _2127_ (.A1(net126),
    .A2(_1342_),
    .Y(_0426_),
    .B1(_1341_));
 sg13g2_nor2_1 _2128_ (.A(\pll_dig.flock.cnt_gray[11] ),
    .B(net128),
    .Y(_1343_));
 sg13g2_nor2_2 _2129_ (.A(\pll_dig.flock.cnt[12] ),
    .B(net421),
    .Y(_1344_));
 sg13g2_xnor2_1 _2130_ (.Y(_1345_),
    .A(_1344_),
    .B(_0528_));
 sg13g2_inv_1 _2131_ (.Y(_0576_),
    .A(net676));
 sg13g2_a21oi_1 _2132_ (.A1(net128),
    .A2(_1345_),
    .Y(_0425_),
    .B1(_1343_));
 sg13g2_a21oi_1 _2133_ (.A1(\pll_dig.ref_wd.cnt[0] ),
    .A2(_1335_),
    .Y(_1346_),
    .B1(\pll_dig.ref_wd.cnt[1] ));
 sg13g2_and3_1 _2134_ (.X(_1347_),
    .A(\pll_dig.ref_wd.cnt[1] ),
    .B(_0587_),
    .C(\pll_dig.ref_wd.cnt[0] ));
 sg13g2_nor3_1 _2135_ (.A(_0925_),
    .B(_1346_),
    .C(_1347_),
    .Y(_0424_));
 sg13g2_a21oi_1 _2136_ (.A1(_0587_),
    .A2(_1338_),
    .Y(_0423_),
    .B1(_0925_));
 sg13g2_nor3_1 _2137_ (.A(_0941_),
    .B(_0949_),
    .C(_0950_),
    .Y(_1348_));
 sg13g2_nand2_1 _2138_ (.Y(_1349_),
    .A(net107),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[3] ));
 sg13g2_nand2_1 _2139_ (.Y(_1350_),
    .A(net96),
    .B(_0951_));
 sg13g2_o21ai_1 _2140_ (.B1(_1349_),
    .Y(_0422_),
    .A1(_1348_),
    .A2(_1350_));
 sg13g2_nand2_1 _2141_ (.Y(_1351_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .B(net105));
 sg13g2_inv_1 _2142_ (.Y(_0577_),
    .A(net161));
 sg13g2_a21o_1 _2143_ (.A2(_0967_),
    .A1(_0965_),
    .B1(net106),
    .X(_1352_));
 sg13g2_o21ai_1 _2144_ (.B1(_1351_),
    .Y(_0421_),
    .A1(_0968_),
    .A2(_1352_));
 sg13g2_nand2b_1 _2145_ (.Y(_1353_),
    .B(\pll_dig.COARSE_MUX_D[14] ),
    .A_N(net92));
 sg13g2_nand2_1 _2146_ (.Y(_1354_),
    .A(_1259_),
    .B(_1353_));
 sg13g2_a21oi_1 _2147_ (.A1(_0589_),
    .A2(net92),
    .Y(_1355_),
    .B1(_0506_));
 sg13g2_mux2_1 _2148_ (.A0(_1355_),
    .A1(\pll_dig.COARSE_MUX_D[1] ),
    .S(net74),
    .X(_0420_));
 sg13g2_nor2_1 _2149_ (.A(\pll_dig.COARSE_MUX_D[14] ),
    .B(net92),
    .Y(_1356_));
 sg13g2_a221oi_1 _2150_ (.B2(\pll_dig.COARSE_MUX_D[5] ),
    .C1(net74),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[7] ),
    .Y(_1357_),
    .A2(net84));
 sg13g2_a21oi_1 _2151_ (.A1(_0554_),
    .A2(net74),
    .Y(_0419_),
    .B1(_1357_));
 sg13g2_a221oi_1 _2152_ (.B2(\pll_dig.COARSE_MUX_D[10] ),
    .C1(net72),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[12] ),
    .Y(_1358_),
    .A2(net84));
 sg13g2_inv_1 _2153_ (.Y(_0578_),
    .A(\pll_dig.out_edges_g2_q[9] ));
 sg13g2_a21oi_1 _2154_ (.A1(_0534_),
    .A2(net72),
    .Y(_0418_),
    .B1(_1358_));
 sg13g2_and2_1 _2155_ (.A(_0613_),
    .B(net88),
    .X(_1359_));
 sg13g2_nor2_1 _2156_ (.A(_1247_),
    .B(net86),
    .Y(_1360_));
 sg13g2_a21oi_1 _2157_ (.A1(\pll_dig.MID_MUX_D[0] ),
    .A2(_0530_),
    .Y(_1361_),
    .B1(_1360_));
 sg13g2_nor3_1 _2158_ (.A(net77),
    .B(_1359_),
    .C(_1361_),
    .Y(_1362_));
 sg13g2_a21o_1 _2159_ (.A2(net77),
    .A1(\pll_dig.MID_MUX_D[1] ),
    .B1(_1362_),
    .X(_0417_));
 sg13g2_a221oi_1 _2160_ (.B2(\pll_dig.MID_MUX_D[5] ),
    .C1(net80),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[7] ),
    .Y(_1363_),
    .A2(net88));
 sg13g2_a22oi_1 _2161_ (.Y(_0416_),
    .B1(net69),
    .B2(_1363_),
    .A2(net80),
    .A1(_0531_));
 sg13g2_a221oi_1 _2162_ (.B2(\pll_dig.MID_MUX_D[11] ),
    .C1(net80),
    .B1(net87),
    .A1(\pll_dig.MID_MUX_D[13] ),
    .Y(_1364_),
    .A2(net89));
 sg13g2_a22oi_1 _2163_ (.Y(_0415_),
    .B1(net69),
    .B2(_1364_),
    .A2(net80),
    .A1(_0533_));
 sg13g2_inv_1 _2164_ (.Y(_0579_),
    .A(\pll_dig.flock.cnt_bin[5] ));
 sg13g2_nand3b_1 _2165_ (.B(_0845_),
    .C(\pll_dig.flock.cnt_coarse_wait[7] ),
    .Y(_1365_),
    .A_N(_0836_));
 sg13g2_nand2_1 _2166_ (.Y(_0020_),
    .A(net70),
    .B(_1365_));
 sg13g2_nor2b_1 _2167_ (.A(\pll_dig.flock.cnt_bin[12] ),
    .B_N(_0135_),
    .Y(_1366_));
 sg13g2_nand2_1 _2168_ (.Y(_1367_),
    .A(\pll_dig.flock.cnt_bin[12] ),
    .B(_0135_));
 sg13g2_or2_1 _2169_ (.X(_1368_),
    .B(_0135_),
    .A(\pll_dig.flock.cnt_bin[12] ));
 sg13g2_nand2_1 _2170_ (.Y(_1369_),
    .A(_1367_),
    .B(_1368_));
 sg13g2_or2_1 _2171_ (.X(_1370_),
    .B(_0933_),
    .A(\pll_dig.flock.cnt_bin[11] ));
 sg13g2_and2_1 _2172_ (.A(\pll_dig.flock.cnt_bin[11] ),
    .B(_0933_),
    .X(_1371_));
 sg13g2_xnor2_1 _2173_ (.Y(_1372_),
    .A(\pll_dig.flock.cnt_bin[10] ),
    .B(_0133_));
 sg13g2_or2_1 _2174_ (.X(_1373_),
    .B(_0934_),
    .A(\pll_dig.flock.cnt_bin[9] ));
 sg13g2_inv_1 _2175_ (.Y(_0580_),
    .A(\pll_dig.flock.cnt_filt[7] ));
 sg13g2_nand2_1 _2176_ (.Y(_1374_),
    .A(\pll_dig.flock.cnt_bin[9] ),
    .B(_0934_));
 sg13g2_nand2b_1 _2177_ (.Y(_1375_),
    .B(_0145_),
    .A_N(\pll_dig.flock.cnt_bin[8] ));
 sg13g2_xor2_1 _2178_ (.B(_0145_),
    .A(\pll_dig.flock.cnt_bin[8] ),
    .X(_1376_));
 sg13g2_inv_1 _2179_ (.Y(_1377_),
    .A(_1376_));
 sg13g2_nor2b_1 _2180_ (.A(\pll_dig.flock.cnt_bin[7] ),
    .B_N(_0144_),
    .Y(_1378_));
 sg13g2_nor2b_1 _2181_ (.A(_0144_),
    .B_N(\pll_dig.flock.cnt_bin[7] ),
    .Y(_1379_));
 sg13g2_or2_1 _2182_ (.X(_1380_),
    .B(_1309_),
    .A(\pll_dig.flock.cnt_bin[6] ));
 sg13g2_xnor2_1 _2183_ (.Y(_1381_),
    .A(\pll_dig.flock.cnt_bin[6] ),
    .B(_1309_));
 sg13g2_nand2_1 _2184_ (.Y(_1382_),
    .A(_0579_),
    .B(_0142_));
 sg13g2_or2_1 _2185_ (.X(_1383_),
    .B(_0142_),
    .A(_0579_));
 sg13g2_inv_1 _2186_ (.Y(_0581_),
    .A(net639));
 sg13g2_nand2b_1 _2187_ (.Y(_1384_),
    .B(_0141_),
    .A_N(\pll_dig.flock.cnt_bin[4] ));
 sg13g2_or2_1 _2188_ (.X(_1385_),
    .B(_1310_),
    .A(\pll_dig.flock.cnt_bin[3] ));
 sg13g2_nor2b_1 _2189_ (.A(\pll_dig.flock.cnt_bin[2] ),
    .B_N(_0139_),
    .Y(_1386_));
 sg13g2_inv_1 _2190_ (.Y(_1387_),
    .A(_1386_));
 sg13g2_xor2_1 _2191_ (.B(_0139_),
    .A(\pll_dig.flock.cnt_gray_s2[1] ),
    .X(_0138_));
 sg13g2_nand2b_1 _2192_ (.Y(_1388_),
    .B(_0138_),
    .A_N(\pll_dig.flock.cnt_bin[1] ));
 sg13g2_xnor2_1 _2193_ (.Y(_1389_),
    .A(\pll_dig.flock.cnt_bin[1] ),
    .B(_0138_));
 sg13g2_xor2_1 _2194_ (.B(_0138_),
    .A(\pll_dig.flock.cnt_gray_s2[0] ),
    .X(_0132_));
 sg13g2_or2_1 _2195_ (.X(_1390_),
    .B(_0132_),
    .A(_0607_));
 sg13g2_o21ai_1 _2196_ (.B1(_1389_),
    .Y(_1391_),
    .A1(_0607_),
    .A2(_0132_));
 sg13g2_inv_1 _2197_ (.Y(_0582_),
    .A(net121));
 sg13g2_xor2_1 _2198_ (.B(_0139_),
    .A(\pll_dig.flock.cnt_bin[2] ),
    .X(_1392_));
 sg13g2_a21o_1 _2199_ (.A2(_1391_),
    .A1(_1388_),
    .B1(_1392_),
    .X(_1393_));
 sg13g2_xnor2_1 _2200_ (.Y(_1394_),
    .A(\pll_dig.flock.cnt_bin[3] ),
    .B(_1310_));
 sg13g2_a21o_1 _2201_ (.A2(_1393_),
    .A1(_1387_),
    .B1(_1394_),
    .X(_1395_));
 sg13g2_and2_1 _2202_ (.A(_1385_),
    .B(_1395_),
    .X(_1396_));
 sg13g2_xor2_1 _2203_ (.B(_0141_),
    .A(\pll_dig.flock.cnt_bin[4] ),
    .X(_1397_));
 sg13g2_a21o_1 _2204_ (.A2(_1395_),
    .A1(_1385_),
    .B1(_1397_),
    .X(_1398_));
 sg13g2_nand2_1 _2205_ (.Y(_1399_),
    .A(_1384_),
    .B(_1398_));
 sg13g2_nand3_1 _2206_ (.B(_1384_),
    .C(_1398_),
    .A(_1382_),
    .Y(_1400_));
 sg13g2_nand2_1 _2207_ (.Y(_1401_),
    .A(_1383_),
    .B(_1400_));
 sg13g2_inv_1 _2208_ (.Y(_0583_),
    .A(\pll_dig.COARSE_MUX_D[3] ));
 sg13g2_nand3b_1 _2209_ (.B(_1383_),
    .C(_1400_),
    .Y(_1402_),
    .A_N(_1381_));
 sg13g2_nand2_1 _2210_ (.Y(_1403_),
    .A(_1380_),
    .B(_1402_));
 sg13g2_a21oi_1 _2211_ (.A1(_1380_),
    .A2(_1402_),
    .Y(_1404_),
    .B1(_1379_));
 sg13g2_nor2_1 _2212_ (.A(_1378_),
    .B(_1404_),
    .Y(_1405_));
 sg13g2_o21ai_1 _2213_ (.B1(_1377_),
    .Y(_1406_),
    .A1(_1378_),
    .A2(_1404_));
 sg13g2_and2_1 _2214_ (.A(_1375_),
    .B(_1406_),
    .X(_1407_));
 sg13g2_nand3_1 _2215_ (.B(_1375_),
    .C(_1406_),
    .A(_1373_),
    .Y(_1408_));
 sg13g2_and2_1 _2216_ (.A(_1374_),
    .B(_1408_),
    .X(_1409_));
 sg13g2_and3_1 _2217_ (.X(_1410_),
    .A(_1372_),
    .B(_1374_),
    .C(_1408_));
 sg13g2_a21oi_1 _2218_ (.A1(_0509_),
    .A2(_0133_),
    .Y(_1411_),
    .B1(_1410_));
 sg13g2_inv_1 _2219_ (.Y(_0490_),
    .A(net11));
 sg13g2_inv_1 _2220_ (.Y(_0584_),
    .A(\pll_dig.COARSE_MUX_D[4] ));
 sg13g2_a21oi_1 _2221_ (.A1(_1370_),
    .A2(_1411_),
    .Y(_1412_),
    .B1(_1371_));
 sg13g2_a221oi_1 _2222_ (.B2(_1411_),
    .C1(_1371_),
    .B1(_1370_),
    .A1(_1367_),
    .Y(_1413_),
    .A2(_1368_));
 sg13g2_nor2_1 _2223_ (.A(_1366_),
    .B(_1413_),
    .Y(_1414_));
 sg13g2_or2_1 _2224_ (.X(_1415_),
    .B(_0793_),
    .A(\pll_dig.flock.cnt_bin[13] ));
 sg13g2_nand2_1 _2225_ (.Y(_1416_),
    .A(\pll_dig.flock.cnt_bin[13] ),
    .B(_0793_));
 sg13g2_nand2_1 _2226_ (.Y(_1417_),
    .A(_1415_),
    .B(_1416_));
 sg13g2_o21ai_1 _2227_ (.B1(net161),
    .Y(_1418_),
    .A1(_1414_),
    .A2(_1417_));
 sg13g2_a21oi_1 _2228_ (.A1(_1414_),
    .A2(_1417_),
    .Y(_0073_),
    .B1(_1418_));
 sg13g2_or2_1 _2229_ (.X(_1419_),
    .B(_0137_),
    .A(\pll_dig.flock.cnt_bin[14] ));
 sg13g2_nand2_1 _2230_ (.Y(_1420_),
    .A(\pll_dig.flock.cnt_bin[14] ),
    .B(_0137_));
 sg13g2_inv_1 _2231_ (.Y(_0585_),
    .A(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_o21ai_1 _2232_ (.B1(_1416_),
    .Y(_1421_),
    .A1(_1366_),
    .A2(_1413_));
 sg13g2_a22oi_1 _2233_ (.Y(_1422_),
    .B1(_1421_),
    .B2(_1415_),
    .A2(_1420_),
    .A1(_1419_));
 sg13g2_and4_1 _2234_ (.A(_1415_),
    .B(_1419_),
    .C(_1420_),
    .D(_1421_),
    .X(_1423_));
 sg13g2_nor3_1 _2235_ (.A(_0577_),
    .B(_1422_),
    .C(_1423_),
    .Y(_0074_));
 sg13g2_o21ai_1 _2236_ (.B1(net161),
    .Y(_1424_),
    .A1(_1369_),
    .A2(_1412_));
 sg13g2_nor2_1 _2237_ (.A(_1413_),
    .B(_1424_),
    .Y(_0072_));
 sg13g2_xnor2_1 _2238_ (.Y(_1425_),
    .A(\pll_dig.flock.cnt_bin[11] ),
    .B(_0933_));
 sg13g2_o21ai_1 _2239_ (.B1(net162),
    .Y(_1426_),
    .A1(_1411_),
    .A2(_1425_));
 sg13g2_a21oi_1 _2240_ (.A1(_1411_),
    .A2(_1425_),
    .Y(_0071_),
    .B1(_1426_));
 sg13g2_o21ai_1 _2241_ (.B1(net162),
    .Y(_1427_),
    .A1(_1372_),
    .A2(_1409_));
 sg13g2_inv_1 _2242_ (.Y(_0586_),
    .A(net734));
 sg13g2_nor2_1 _2243_ (.A(_1410_),
    .B(_1427_),
    .Y(_0070_));
 sg13g2_nand2_1 _2244_ (.Y(_1428_),
    .A(_1373_),
    .B(_1374_));
 sg13g2_o21ai_1 _2245_ (.B1(net162),
    .Y(_1429_),
    .A1(_1407_),
    .A2(_1428_));
 sg13g2_a21oi_1 _2246_ (.A1(_1407_),
    .A2(_1428_),
    .Y(_0069_),
    .B1(_1429_));
 sg13g2_o21ai_1 _2247_ (.B1(net161),
    .Y(_1430_),
    .A1(_1389_),
    .A2(_1390_));
 sg13g2_nor2b_1 _2248_ (.A(_1430_),
    .B_N(_1391_),
    .Y(_0076_));
 sg13g2_nand2_1 _2249_ (.Y(_1431_),
    .A(_0607_),
    .B(_0132_));
 sg13g2_a21oi_1 _2250_ (.A1(_1390_),
    .A2(_1431_),
    .Y(_0075_),
    .B1(_0577_));
 sg13g2_o21ai_1 _2251_ (.B1(_1278_),
    .Y(_1432_),
    .A1(\pll_dig.flock.cnt_err[0] ),
    .A2(_0839_));
 sg13g2_nor2b_1 _2252_ (.A(_0830_),
    .B_N(_1432_),
    .Y(_1433_));
 sg13g2_inv_1 _2253_ (.Y(_0587_),
    .A(\pll_dig.ref_wd.cnt[9] ));
 sg13g2_nor2_1 _2254_ (.A(_1280_),
    .B(_1433_),
    .Y(_1434_));
 sg13g2_o21ai_1 _2255_ (.B1(_1434_),
    .Y(_0029_),
    .A1(_1249_),
    .A2(_1277_));
 sg13g2_nand2_1 _2256_ (.Y(_1435_),
    .A(_0846_),
    .B(_1249_));
 sg13g2_nand3_1 _2257_ (.B(net114),
    .C(_1435_),
    .A(\pll_dig.flock.cnt_err[5] ),
    .Y(_1436_));
 sg13g2_and2_1 _2258_ (.A(\pll_dig.flock.cnt_err[1] ),
    .B(\pll_dig.flock.cnt_err[0] ),
    .X(_1437_));
 sg13g2_nand2_1 _2259_ (.Y(_1438_),
    .A(\pll_dig.flock.cnt_err[2] ),
    .B(_1437_));
 sg13g2_nor2_1 _2260_ (.A(_0609_),
    .B(_1438_),
    .Y(_1439_));
 sg13g2_and2_1 _2261_ (.A(\pll_dig.flock.cnt_err[4] ),
    .B(_1439_),
    .X(_1440_));
 sg13g2_xnor2_1 _2262_ (.Y(_1441_),
    .A(\pll_dig.flock.cnt_err[5] ),
    .B(_1440_));
 sg13g2_o21ai_1 _2263_ (.B1(_1436_),
    .Y(_0034_),
    .A1(net70),
    .A2(_1441_));
 sg13g2_inv_1 _2264_ (.Y(_0588_),
    .A(net591));
 sg13g2_nand3_1 _2265_ (.B(net114),
    .C(_1435_),
    .A(\pll_dig.flock.cnt_err[6] ),
    .Y(_1442_));
 sg13g2_nand3_1 _2266_ (.B(\pll_dig.flock.cnt_err[5] ),
    .C(_1440_),
    .A(\pll_dig.flock.cnt_err[6] ),
    .Y(_1443_));
 sg13g2_a21o_1 _2267_ (.A2(_1440_),
    .A1(\pll_dig.flock.cnt_err[5] ),
    .B1(\pll_dig.flock.cnt_err[6] ),
    .X(_1444_));
 sg13g2_nand2_1 _2268_ (.Y(_1445_),
    .A(_1443_),
    .B(_1444_));
 sg13g2_o21ai_1 _2269_ (.B1(_1442_),
    .Y(_0035_),
    .A1(net71),
    .A2(_1445_));
 sg13g2_nand3_1 _2270_ (.B(net114),
    .C(_1435_),
    .A(\pll_dig.flock.cnt_err[4] ),
    .Y(_1446_));
 sg13g2_xnor2_1 _2271_ (.Y(_1447_),
    .A(\pll_dig.flock.cnt_err[4] ),
    .B(_1439_));
 sg13g2_o21ai_1 _2272_ (.B1(_1446_),
    .Y(_0033_),
    .A1(net71),
    .A2(_1447_));
 sg13g2_nand3_1 _2273_ (.B(net114),
    .C(_1435_),
    .A(\pll_dig.flock.cnt_err[3] ),
    .Y(_1448_));
 sg13g2_xnor2_1 _2274_ (.Y(_1449_),
    .A(_0609_),
    .B(_1438_));
 sg13g2_inv_1 _2275_ (.Y(_0589_),
    .A(\pll_dig.COARSE_MUX_D[2] ));
 sg13g2_o21ai_1 _2276_ (.B1(_1448_),
    .Y(_0032_),
    .A1(net71),
    .A2(_1449_));
 sg13g2_nand3_1 _2277_ (.B(net114),
    .C(_1435_),
    .A(\pll_dig.flock.cnt_err[2] ),
    .Y(_1450_));
 sg13g2_xnor2_1 _2278_ (.Y(_1451_),
    .A(\pll_dig.flock.cnt_err[2] ),
    .B(_1437_));
 sg13g2_o21ai_1 _2279_ (.B1(_1450_),
    .Y(_0031_),
    .A1(net71),
    .A2(_1451_));
 sg13g2_nand2_1 _2280_ (.Y(_1452_),
    .A(\pll_dig.flock.cnt_err[1] ),
    .B(net114));
 sg13g2_nor2_1 _2281_ (.A(_0837_),
    .B(_1452_),
    .Y(_1453_));
 sg13g2_nor3_1 _2282_ (.A(net71),
    .B(_1283_),
    .C(_1437_),
    .Y(_1454_));
 sg13g2_o21ai_1 _2283_ (.B1(_0845_),
    .Y(_1455_),
    .A1(_1453_),
    .A2(_1454_));
 sg13g2_o21ai_1 _2284_ (.B1(_1455_),
    .Y(_0030_),
    .A1(_1249_),
    .A2(_1452_));
 sg13g2_nand2_1 _2285_ (.Y(_1456_),
    .A(net161),
    .B(_1398_));
 sg13g2_inv_1 _2286_ (.Y(_0590_),
    .A(\pll_dig.flock.FCW_NA[1] ));
 sg13g2_a21oi_1 _2287_ (.A1(_1396_),
    .A2(_1397_),
    .Y(_0079_),
    .B1(_1456_));
 sg13g2_nand3_1 _2288_ (.B(_1393_),
    .C(_1394_),
    .A(_1387_),
    .Y(_1457_));
 sg13g2_and3_1 _2289_ (.X(_0078_),
    .A(net161),
    .B(_1395_),
    .C(_1457_));
 sg13g2_nand3_1 _2290_ (.B(_1391_),
    .C(_1392_),
    .A(_1388_),
    .Y(_1458_));
 sg13g2_and3_1 _2291_ (.X(_0077_),
    .A(net161),
    .B(_1393_),
    .C(_1458_));
 sg13g2_and3_1 _2292_ (.X(_1459_),
    .A(_1382_),
    .B(_1383_),
    .C(_1399_));
 sg13g2_a21oi_1 _2293_ (.A1(_1382_),
    .A2(_1383_),
    .Y(_1460_),
    .B1(_1399_));
 sg13g2_nor3_1 _2294_ (.A(_0577_),
    .B(_1459_),
    .C(_1460_),
    .Y(_0080_));
 sg13g2_nand2_1 _2295_ (.Y(_1461_),
    .A(net161),
    .B(_1402_));
 sg13g2_a21oi_1 _2296_ (.A1(_1381_),
    .A2(_1401_),
    .Y(_0081_),
    .B1(_1461_));
 sg13g2_inv_1 _2297_ (.Y(_0591_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[3] ));
 sg13g2_xor2_1 _2298_ (.B(_1267_),
    .A(\pll_dig.div_rst_cnt[0] ),
    .X(_0414_));
 sg13g2_xnor2_1 _2299_ (.Y(_0127_),
    .A(net8),
    .B(_0662_));
 sg13g2_nand2_1 _2300_ (.Y(_1462_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .B(net113));
 sg13g2_o21ai_1 _2301_ (.B1(_1462_),
    .Y(_0413_),
    .A1(net113),
    .A2(net360));
 sg13g2_nand3_1 _2302_ (.B(_1034_),
    .C(_1035_),
    .A(_1027_),
    .Y(_1463_));
 sg13g2_a21oi_1 _2303_ (.A1(_1036_),
    .A2(_1463_),
    .Y(_1464_),
    .B1(net108));
 sg13g2_a21oi_1 _2304_ (.A1(_0518_),
    .A2(net108),
    .Y(_0412_),
    .B1(_1464_));
 sg13g2_nand3_1 _2305_ (.B(net368),
    .C(_1045_),
    .A(_1016_),
    .Y(_1465_));
 sg13g2_nand2b_1 _2306_ (.Y(_1466_),
    .B(_1465_),
    .A_N(_1046_));
 sg13g2_nor2_1 _2307_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .B(net97),
    .Y(_1467_));
 sg13g2_inv_1 _2308_ (.Y(_0592_),
    .A(\pll_dig.ref_wd.cnt[4] ));
 sg13g2_a21oi_1 _2309_ (.A1(net97),
    .A2(_1466_),
    .Y(_0411_),
    .B1(_1467_));
 sg13g2_mux2_1 _2310_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[5] ),
    .A1(_1022_),
    .S(net97),
    .X(_0410_));
 sg13g2_xnor2_1 _2311_ (.Y(_0152_),
    .A(_0490_),
    .B(_1306_));
 sg13g2_xnor2_1 _2312_ (.Y(_0149_),
    .A(_0538_),
    .B(_1303_));
 sg13g2_xnor2_1 _2313_ (.Y(_0006_),
    .A(\pll_dig.out_edges[7] ),
    .B(_0791_));
 sg13g2_nor2_1 _2314_ (.A(_0784_),
    .B(_0849_),
    .Y(\pll_dig.out_edges_next[3] ));
 sg13g2_xnor2_1 _2315_ (.Y(_0002_),
    .A(_0521_),
    .B(_1262_));
 sg13g2_xnor2_1 _2316_ (.Y(_0409_),
    .A(\pll_dig.div_rst_cnt[2] ),
    .B(_1285_));
 sg13g2_xor2_1 _2317_ (.B(_0729_),
    .A(_0701_),
    .X(_1468_));
 sg13g2_nand2b_1 _2318_ (.Y(_1469_),
    .B(_0701_),
    .A_N(_0765_));
 sg13g2_inv_1 _2319_ (.Y(_0593_),
    .A(\pll_dig.flock.freq_miss[1] ));
 sg13g2_nand3b_1 _2320_ (.B(net65),
    .C(_1469_),
    .Y(_1470_),
    .A_N(_0766_));
 sg13g2_o21ai_1 _2321_ (.B1(_0752_),
    .Y(_1471_),
    .A1(\SS_BBPD[0] ),
    .A2(net122));
 sg13g2_a22oi_1 _2322_ (.Y(\pll_dig.dlf.OUT_C[8] ),
    .B1(_1470_),
    .B2(_1471_),
    .A2(_1468_),
    .A1(net61));
 sg13g2_xnor2_1 _2323_ (.Y(_1472_),
    .A(_0720_),
    .B(_0761_));
 sg13g2_a22oi_1 _2324_ (.Y(_1473_),
    .B1(net66),
    .B2(_1472_),
    .A2(net670),
    .A1(net133));
 sg13g2_xnor2_1 _2325_ (.Y(_1474_),
    .A(_0717_),
    .B(_0720_));
 sg13g2_a22oi_1 _2326_ (.Y(\pll_dig.dlf.OUT_C[5] ),
    .B1(_1474_),
    .B2(net62),
    .A2(net671),
    .A1(net131));
 sg13g2_mux2_1 _2327_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .A1(net355),
    .S(net98),
    .X(_0406_));
 sg13g2_o21ai_1 _2328_ (.B1(net94),
    .Y(\pll_dig.FINE_MUX_D[17] ),
    .A1(net103),
    .A2(_1268_));
 sg13g2_nand2_1 _2329_ (.Y(_1475_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .B(_1101_));
 sg13g2_inv_1 _2330_ (.Y(_0491_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[1] ));
 sg13g2_inv_1 _2331_ (.Y(_0594_),
    .A(\pll_dig.MID_MUX_D[4] ));
 sg13g2_xor2_1 _2332_ (.B(_1148_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .X(_1476_));
 sg13g2_o21ai_1 _2333_ (.B1(_1475_),
    .Y(_0024_),
    .A1(_1142_),
    .A2(_1476_));
 sg13g2_and3_1 _2334_ (.X(net56),
    .A(\pll_dig.u_ddr_ck.ck_en ),
    .B(clknet_1_1__leaf_net60),
    .C(net58));
 sg13g2_nor2b_1 _2335_ (.A(net131),
    .B_N(_0748_),
    .Y(\pll_dig.dlf.ILL_P_C ));
 sg13g2_xnor2_1 _2336_ (.Y(_1477_),
    .A(_0693_),
    .B(_0745_));
 sg13g2_xnor2_1 _2337_ (.Y(_1478_),
    .A(_0692_),
    .B(_0774_));
 sg13g2_nand2_1 _2338_ (.Y(_1479_),
    .A(net65),
    .B(_1478_));
 sg13g2_a22oi_1 _2339_ (.Y(_1480_),
    .B1(_1479_),
    .B2(net131),
    .A2(_1477_),
    .A1(net61));
 sg13g2_a21o_1 _2340_ (.A2(net658),
    .A1(net133),
    .B1(_1480_),
    .X(\pll_dig.dlf.OUT_C[14] ));
 sg13g2_nand3_1 _2341_ (.B(_0696_),
    .C(_0738_),
    .A(_0695_),
    .Y(_1481_));
 sg13g2_inv_1 _2342_ (.Y(_0595_),
    .A(\pll_dig.COARSE_MUX_D[5] ));
 sg13g2_nand2b_1 _2343_ (.Y(_1482_),
    .B(_1481_),
    .A_N(_0739_));
 sg13g2_nand3_1 _2344_ (.B(_0770_),
    .C(_0771_),
    .A(_0694_),
    .Y(_1483_));
 sg13g2_nand3b_1 _2345_ (.B(net65),
    .C(_1483_),
    .Y(_1484_),
    .A_N(_0772_));
 sg13g2_o21ai_1 _2346_ (.B1(_0752_),
    .Y(_1485_),
    .A1(\SS_BBPD[0] ),
    .A2(net665));
 sg13g2_a22oi_1 _2347_ (.Y(\pll_dig.dlf.OUT_C[12] ),
    .B1(_1484_),
    .B2(_1485_),
    .A2(_1482_),
    .A1(net61));
 sg13g2_nor2_1 _2348_ (.A(\pll_dig.dco_miss_cnt[2] ),
    .B(_0869_),
    .Y(_1486_));
 sg13g2_o21ai_1 _2349_ (.B1(_0870_),
    .Y(_1487_),
    .A1(\pll_dig.dco_miss_cnt[0] ),
    .A2(_1486_));
 sg13g2_inv_1 _2350_ (.Y(_0401_),
    .A(_1487_));
 sg13g2_nor2_1 _2351_ (.A(\pll_dig.dco_miss_cnt[2] ),
    .B(_0871_),
    .Y(_1488_));
 sg13g2_nor2_1 _2352_ (.A(_0869_),
    .B(_1488_),
    .Y(_0400_));
 sg13g2_inv_1 _2353_ (.Y(_0596_),
    .A(net122));
 sg13g2_mux2_1 _2354_ (.A0(net405),
    .A1(\pll_dig.div.div_pend[0] ),
    .S(net82),
    .X(_0399_));
 sg13g2_a21oi_1 _2355_ (.A1(net103),
    .A2(_1287_),
    .Y(\pll_dig.FINE_MUX_D[8] ),
    .B1(net99));
 sg13g2_o21ai_1 _2356_ (.B1(net123),
    .Y(_1489_),
    .A1(\pll_dig.ref_wd.cnt[5] ),
    .A2(_0921_));
 sg13g2_nor2_1 _2357_ (.A(_0922_),
    .B(_1489_),
    .Y(_0398_));
 sg13g2_xnor2_1 _2358_ (.Y(_0397_),
    .A(\pll_dig.flock.cnt[7] ),
    .B(_0908_));
 sg13g2_nor2_1 _2359_ (.A(\pll_dig.flock.cnt_gray[14] ),
    .B(net130),
    .Y(_1490_));
 sg13g2_nand3_1 _2360_ (.B(_1339_),
    .C(\pll_dig.flock.cnt[13] ),
    .A(\pll_dig.flock.cnt[12] ),
    .Y(_1491_));
 sg13g2_inv_2 _2361_ (.Y(_1492_),
    .A(_1491_));
 sg13g2_a21oi_2 _2362_ (.B1(\pll_dig.flock.cnt[15] ),
    .Y(_1493_),
    .A2(_1492_),
    .A1(\pll_dig.flock.cnt[14] ));
 sg13g2_xor2_1 _2363_ (.B(_1493_),
    .A(\pll_dig.flock.cnt_gray[15] ),
    .X(_1494_));
 sg13g2_inv_1 _2364_ (.Y(_0597_),
    .A(net44));
 sg13g2_a21oi_1 _2365_ (.A1(net130),
    .A2(_1494_),
    .Y(_0396_),
    .B1(_1490_));
 sg13g2_a21o_1 _2366_ (.A2(net423),
    .A1(net126),
    .B1(\pll_dig.flock.cnt[6] ),
    .X(_1495_));
 sg13g2_and2_1 _2367_ (.A(_0908_),
    .B(_1495_),
    .X(_0395_));
 sg13g2_nand2_1 _2368_ (.Y(_1496_),
    .A(\pll_dig.flock.cnt_done[0] ),
    .B(_1101_));
 sg13g2_o21ai_1 _2369_ (.B1(_1496_),
    .Y(_0021_),
    .A1(\pll_dig.flock.cnt_done[0] ),
    .A2(_1142_));
 sg13g2_nor2_1 _2370_ (.A(\pll_dig.flock.cnt_gray[8] ),
    .B(net130),
    .Y(_1497_));
 sg13g2_nor2_1 _2371_ (.A(\pll_dig.flock.cnt[9] ),
    .B(net419),
    .Y(_1498_));
 sg13g2_xor2_1 _2372_ (.B(_1498_),
    .A(\pll_dig.flock.cnt[10] ),
    .X(_1499_));
 sg13g2_a21oi_1 _2373_ (.A1(net130),
    .A2(_1499_),
    .Y(_0394_),
    .B1(_1497_));
 sg13g2_nor2_1 _2374_ (.A(\pll_dig.flock.FCW_NA[7] ),
    .B(_0555_),
    .Y(_1500_));
 sg13g2_inv_1 _2375_ (.Y(_0598_),
    .A(net40));
 sg13g2_nand2_1 _2376_ (.Y(_1501_),
    .A(\pll_dig.flock.FCW_NA[0] ),
    .B(\pll_dig.flock.FCW_NA[1] ));
 sg13g2_nor2_1 _2377_ (.A(\pll_dig.flock.FCW_NA[0] ),
    .B(\pll_dig.flock.FCW_NA[1] ),
    .Y(_1502_));
 sg13g2_a221oi_1 _2378_ (.B2(_1501_),
    .C1(_1502_),
    .B1(\pll_dig.flock.cnt_cap[1] ),
    .A1(_0535_),
    .Y(_1503_),
    .A2(\pll_dig.flock.cnt_cap[2] ));
 sg13g2_a221oi_1 _2379_ (.B2(\pll_dig.flock.FCW_NA[2] ),
    .C1(_1503_),
    .B1(_0560_),
    .A1(\pll_dig.flock.FCW_NA[3] ),
    .Y(_1504_),
    .A2(_0556_));
 sg13g2_a221oi_1 _2380_ (.B2(_0547_),
    .C1(_1504_),
    .B1(\pll_dig.flock.cnt_cap[4] ),
    .A1(_0513_),
    .Y(_1505_),
    .A2(\pll_dig.flock.cnt_cap[3] ));
 sg13g2_a221oi_1 _2381_ (.B2(\pll_dig.flock.FCW_NA[5] ),
    .C1(_1505_),
    .B1(_0558_),
    .A1(\pll_dig.flock.FCW_NA[4] ),
    .Y(_1506_),
    .A2(_0557_));
 sg13g2_a221oi_1 _2382_ (.B2(_0512_),
    .C1(_1506_),
    .B1(\pll_dig.flock.cnt_cap[6] ),
    .A1(_0548_),
    .Y(_1507_),
    .A2(\pll_dig.flock.cnt_cap[5] ));
 sg13g2_a221oi_1 _2383_ (.B2(\pll_dig.flock.FCW_NA[6] ),
    .C1(_1507_),
    .B1(_0559_),
    .A1(\pll_dig.flock.FCW_NA[7] ),
    .Y(_1508_),
    .A2(_0555_));
 sg13g2_nor3_1 _2384_ (.A(\pll_dig.flock.cnt_cap[8] ),
    .B(_1500_),
    .C(_1508_),
    .Y(_1509_));
 sg13g2_nand2b_1 _2385_ (.Y(_1510_),
    .B(\pll_dig.flock.FCW_PA[8] ),
    .A_N(\pll_dig.flock.cnt_cap[8] ));
 sg13g2_inv_1 _2386_ (.Y(_0599_),
    .A(net623));
 sg13g2_nor2_1 _2387_ (.A(_0555_),
    .B(\pll_dig.flock.FCW_PA[7] ),
    .Y(_1511_));
 sg13g2_a22oi_1 _2388_ (.Y(_1512_),
    .B1(_0616_),
    .B2(\pll_dig.flock.cnt_cap[2] ),
    .A2(\pll_dig.flock.cnt_cap[1] ),
    .A1(_0514_));
 sg13g2_a221oi_1 _2389_ (.B2(_0560_),
    .C1(_1512_),
    .B1(\pll_dig.flock.FCW_PA[2] ),
    .A1(_0556_),
    .Y(_1513_),
    .A2(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_a221oi_1 _2390_ (.B2(\pll_dig.flock.cnt_cap[3] ),
    .C1(_1513_),
    .B1(_0585_),
    .A1(_0549_),
    .Y(_1514_),
    .A2(\pll_dig.flock.cnt_cap[4] ));
 sg13g2_a221oi_1 _2391_ (.B2(\pll_dig.flock.FCW_PA[5] ),
    .C1(_1514_),
    .B1(_0558_),
    .A1(\pll_dig.flock.FCW_PA[4] ),
    .Y(_1515_),
    .A2(_0557_));
 sg13g2_a221oi_1 _2392_ (.B2(_0617_),
    .C1(_1515_),
    .B1(\pll_dig.flock.cnt_cap[6] ),
    .A1(_0515_),
    .Y(_1516_),
    .A2(\pll_dig.flock.cnt_cap[5] ));
 sg13g2_a221oi_1 _2393_ (.B2(_0559_),
    .C1(_1516_),
    .B1(\pll_dig.flock.FCW_PA[6] ),
    .A1(_0555_),
    .Y(_1517_),
    .A2(\pll_dig.flock.FCW_PA[7] ));
 sg13g2_o21ai_1 _2394_ (.B1(_1510_),
    .Y(_1518_),
    .A1(_1511_),
    .A2(_1517_));
 sg13g2_nor4_1 _2395_ (.A(\pll_dig.flock.cnt_cap[9] ),
    .B(\pll_dig.flock.cnt_cap[10] ),
    .C(\pll_dig.flock.cnt_cap[13] ),
    .D(\pll_dig.flock.cnt_cap[12] ),
    .Y(_1519_));
 sg13g2_nand2b_1 _2396_ (.Y(_1520_),
    .B(\pll_dig.flock.cnt_cap[8] ),
    .A_N(\pll_dig.flock.FCW_PA[8] ));
 sg13g2_inv_1 _2397_ (.Y(_0600_),
    .A(net636));
 sg13g2_nor4_1 _2398_ (.A(\pll_dig.flock.FCW_NA[10] ),
    .B(\pll_dig.flock.cnt_cap[15] ),
    .C(\pll_dig.flock.cnt_cap[14] ),
    .D(\pll_dig.flock.cnt_cap[11] ),
    .Y(_1521_));
 sg13g2_nand4_1 _2399_ (.B(_1519_),
    .C(_1520_),
    .A(_1518_),
    .Y(_1522_),
    .D(_1521_));
 sg13g2_nor2_1 _2400_ (.A(_1509_),
    .B(_1522_),
    .Y(_1523_));
 sg13g2_o21ai_1 _2401_ (.B1(net163),
    .Y(_1524_),
    .A1(_1509_),
    .A2(_1522_));
 sg13g2_nor2_1 _2402_ (.A(_0601_),
    .B(_1524_),
    .Y(_0393_));
 sg13g2_a21oi_1 _2403_ (.A1(\pll_dig.MID_MUX_D[13] ),
    .A2(_1251_),
    .Y(_1525_),
    .B1(\pll_dig.MID_MUX_D[14] ));
 sg13g2_a21oi_1 _2404_ (.A1(_1251_),
    .A2(_1360_),
    .Y(_0392_),
    .B1(_1525_));
 sg13g2_a21oi_1 _2405_ (.A1(\pll_dig.COARSE_MUX_D[13] ),
    .A2(_1259_),
    .Y(_1526_),
    .B1(\pll_dig.COARSE_MUX_D[14] ));
 sg13g2_a21oi_1 _2406_ (.A1(net92),
    .A2(_1259_),
    .Y(_0391_),
    .B1(_1526_));
 sg13g2_nor2_1 _2407_ (.A(\pll_dig.flock.cnt_gray[7] ),
    .B(net126),
    .Y(_1527_));
 sg13g2_inv_1 _2408_ (.Y(_0601_),
    .A(\pll_dig.flock.freq_miss[2] ));
 sg13g2_nand2_1 _2409_ (.Y(_1528_),
    .A(_0508_),
    .B(net416));
 sg13g2_xnor2_1 _2410_ (.Y(_1529_),
    .A(\pll_dig.flock.cnt[9] ),
    .B(_1528_));
 sg13g2_a21oi_1 _2411_ (.A1(net126),
    .A2(_1529_),
    .Y(_0390_),
    .B1(_1527_));
 sg13g2_nand2b_1 _2412_ (.Y(_1530_),
    .B(\pll_dig.flock.freq_miss[2] ),
    .A_N(\pll_dig.flock.freq_miss[0] ));
 sg13g2_nand2_1 _2413_ (.Y(_1531_),
    .A(\pll_dig.flock.freq_miss[0] ),
    .B(_0601_));
 sg13g2_o21ai_1 _2414_ (.B1(_1530_),
    .Y(_1532_),
    .A1(\pll_dig.flock.freq_miss[1] ),
    .A2(_1531_));
 sg13g2_nor2_1 _2415_ (.A(_1524_),
    .B(_1532_),
    .Y(_0389_));
 sg13g2_a21oi_1 _2416_ (.A1(\pll_dig.flock.cnt[6] ),
    .A2(net423),
    .Y(_1533_),
    .B1(\pll_dig.flock.cnt[7] ));
 sg13g2_xnor2_1 _2417_ (.Y(_1534_),
    .A(_0508_),
    .B(_1533_));
 sg13g2_nand2_1 _2418_ (.Y(_1535_),
    .A(\pll_dig.flock.cnt_gray[6] ),
    .B(net124));
 sg13g2_inv_1 _2419_ (.Y(_0602_),
    .A(\pll_dig.flock.cnt_err[7] ));
 sg13g2_o21ai_1 _2420_ (.B1(_1535_),
    .Y(_0388_),
    .A1(net124),
    .A2(_1534_));
 sg13g2_nand2_1 _2421_ (.Y(_1536_),
    .A(\pll_dig.FREQ_OK ),
    .B(_0601_));
 sg13g2_a21oi_1 _2422_ (.A1(\pll_dig.flock.freq_miss[1] ),
    .A2(\pll_dig.flock.freq_miss[0] ),
    .Y(_1537_),
    .B1(_1536_));
 sg13g2_o21ai_1 _2423_ (.B1(net163),
    .Y(_1538_),
    .A1(_1523_),
    .A2(_1537_));
 sg13g2_inv_1 _2424_ (.Y(_0387_),
    .A(_1538_));
 sg13g2_xnor2_1 _2425_ (.Y(_0173_),
    .A(_1234_),
    .B(net541));
 sg13g2_xnor2_1 _2426_ (.Y(_0185_),
    .A(_1225_),
    .B(net529));
 sg13g2_o21ai_1 _2427_ (.B1(net123),
    .Y(_1539_),
    .A1(\pll_dig.ref_wd.cnt[6] ),
    .A2(_0922_));
 sg13g2_nor2_1 _2428_ (.A(_0923_),
    .B(_1539_),
    .Y(_0386_));
 sg13g2_nor2_1 _2429_ (.A(\pll_dig.flock.cnt_gray[0] ),
    .B(net129),
    .Y(_1540_));
 sg13g2_inv_1 _2430_ (.Y(_0603_),
    .A(\pll_dig.div.pend ));
 sg13g2_a21oi_1 _2431_ (.A1(net426),
    .A2(net129),
    .Y(_0385_),
    .B1(_1540_));
 sg13g2_a221oi_1 _2432_ (.B2(\pll_dig.MID_MUX_D[10] ),
    .C1(net79),
    .B1(net87),
    .A1(\pll_dig.MID_MUX_D[12] ),
    .Y(_1541_),
    .A2(net89));
 sg13g2_a22oi_1 _2433_ (.Y(_0384_),
    .B1(net69),
    .B2(_1541_),
    .A2(net79),
    .A1(_0550_));
 sg13g2_a221oi_1 _2434_ (.B2(\pll_dig.COARSE_MUX_D[9] ),
    .C1(net72),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[11] ),
    .Y(_1542_),
    .A2(net84));
 sg13g2_a21oi_1 _2435_ (.A1(_0544_),
    .A2(net72),
    .Y(_0383_),
    .B1(_1542_));
 sg13g2_and2_1 _2436_ (.A(_0962_),
    .B(_0963_),
    .X(_1543_));
 sg13g2_nor3_1 _2437_ (.A(net106),
    .B(_0964_),
    .C(_1543_),
    .Y(_1544_));
 sg13g2_a21o_1 _2438_ (.A2(net105),
    .A1(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .B1(_1544_),
    .X(_0382_));
 sg13g2_nor2_2 _2439_ (.A(_1491_),
    .B(net124),
    .Y(_1545_));
 sg13g2_a21oi_1 _2440_ (.A1(\pll_dig.flock.cnt[14] ),
    .A2(net425),
    .Y(_1546_),
    .B1(\pll_dig.flock.cnt[15] ));
 sg13g2_inv_1 _2441_ (.Y(_0492_),
    .A(\pll_dig.FILTER_DEC[4] ));
 sg13g2_inv_1 _2442_ (.Y(_0604_),
    .A(net428));
 sg13g2_nand3_1 _2443_ (.B(\pll_dig.flock.cnt[14] ),
    .C(\pll_dig.flock.cnt[15] ),
    .A(_1545_),
    .Y(_1547_));
 sg13g2_nor2b_1 _2444_ (.A(_1546_),
    .B_N(_1547_),
    .Y(_0381_));
 sg13g2_a21oi_1 _2445_ (.A1(\pll_dig.ref_wd.cnt[9] ),
    .A2(net123),
    .Y(_1548_),
    .B1(_0918_));
 sg13g2_o21ai_1 _2446_ (.B1(net123),
    .Y(_1549_),
    .A1(\pll_dig.ref_wd.cnt[4] ),
    .A2(_1548_));
 sg13g2_nor2_1 _2447_ (.A(_0921_),
    .B(_1549_),
    .Y(_0380_));
 sg13g2_xor2_1 _2448_ (.B(net418),
    .A(\pll_dig.flock.cnt[14] ),
    .X(_0379_));
 sg13g2_xnor2_1 _2449_ (.Y(_0172_),
    .A(net559),
    .B(net537));
 sg13g2_a21o_1 _2450_ (.A2(net30),
    .A1(\pll_dig.dlf.INT[0] ),
    .B1(_0707_),
    .X(_1550_));
 sg13g2_nand2_1 _2451_ (.Y(_1551_),
    .A(_0708_),
    .B(_1550_));
 sg13g2_nand2_1 _2452_ (.Y(_1552_),
    .A(_0707_),
    .B(_0754_));
 sg13g2_inv_1 _2453_ (.Y(_0605_),
    .A(net42));
 sg13g2_nand3b_1 _2454_ (.B(net65),
    .C(_1552_),
    .Y(_1553_),
    .A_N(_0755_));
 sg13g2_o21ai_1 _2455_ (.B1(_0752_),
    .Y(_1554_),
    .A1(\SS_BBPD[0] ),
    .A2(net684));
 sg13g2_a22oi_1 _2456_ (.Y(\pll_dig.dlf.OUT_C[1] ),
    .B1(_1553_),
    .B2(_1554_),
    .A2(_1551_),
    .A1(net61));
 sg13g2_o21ai_1 _2457_ (.B1(_0508_),
    .Y(_1555_),
    .A1(net124),
    .A2(net416));
 sg13g2_and2_1 _2458_ (.A(_0907_),
    .B(_1555_),
    .X(_0377_));
 sg13g2_a221oi_1 _2459_ (.B2(\pll_dig.MID_MUX_D[4] ),
    .C1(net78),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[6] ),
    .Y(_1556_),
    .A2(net88));
 sg13g2_a22oi_1 _2460_ (.Y(_0376_),
    .B1(net69),
    .B2(_1556_),
    .A2(net78),
    .A1(_0541_));
 sg13g2_a221oi_1 _2461_ (.B2(\pll_dig.COARSE_MUX_D[4] ),
    .C1(net74),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[6] ),
    .Y(_1557_),
    .A2(net85));
 sg13g2_a21oi_1 _2462_ (.A1(_0595_),
    .A2(net74),
    .Y(_0375_),
    .B1(_1557_));
 sg13g2_xnor2_1 _2463_ (.Y(_1558_),
    .A(_0602_),
    .B(_1443_));
 sg13g2_inv_1 _2464_ (.Y(_0606_),
    .A(\pll_dig.flock.cnt_filt[8] ));
 sg13g2_nand3_1 _2465_ (.B(net114),
    .C(_1435_),
    .A(\pll_dig.flock.cnt_err[7] ),
    .Y(_1559_));
 sg13g2_o21ai_1 _2466_ (.B1(_1559_),
    .Y(_0036_),
    .A1(net71),
    .A2(_1558_));
 sg13g2_nor2_1 _2467_ (.A(_0830_),
    .B(_1246_),
    .Y(_1560_));
 sg13g2_nor2_1 _2468_ (.A(_1245_),
    .B(_1560_),
    .Y(_1561_));
 sg13g2_nor2_1 _2469_ (.A(\pll_dig.flock.cnt_coarse_wait[0] ),
    .B(_1561_),
    .Y(_0013_));
 sg13g2_nand2_1 _2470_ (.Y(\pll_dig.FINE_MUX_D[4] ),
    .A(net99),
    .B(_1274_));
 sg13g2_nand2_1 _2471_ (.Y(\pll_dig.FINE_MUX_D[2] ),
    .A(net100),
    .B(_1272_));
 sg13g2_nand2_1 _2472_ (.Y(\pll_dig.FINE_MUX_D[1] ),
    .A(net100),
    .B(_1268_));
 sg13g2_and3_1 _2473_ (.X(_1562_),
    .A(_0942_),
    .B(_0947_),
    .C(_0948_));
 sg13g2_nor3_1 _2474_ (.A(net107),
    .B(_0949_),
    .C(_1562_),
    .Y(_1563_));
 sg13g2_inv_1 _2475_ (.Y(_0607_),
    .A(\pll_dig.flock.cnt_bin[0] ));
 sg13g2_a21o_1 _2476_ (.A2(net108),
    .A1(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B1(_1563_),
    .X(_0373_));
 sg13g2_and3_1 _2477_ (.X(_1564_),
    .A(_0940_),
    .B(_0951_),
    .C(_0952_));
 sg13g2_nor3_1 _2478_ (.A(net107),
    .B(_0953_),
    .C(_1564_),
    .Y(_1565_));
 sg13g2_a21o_1 _2479_ (.A2(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .A1(net109),
    .B1(_1565_),
    .X(_0372_));
 sg13g2_nor3_1 _2480_ (.A(_0939_),
    .B(_0953_),
    .C(_0954_),
    .Y(_1566_));
 sg13g2_nand2_1 _2481_ (.Y(_1567_),
    .A(net111),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[5] ));
 sg13g2_nand2_1 _2482_ (.Y(_1568_),
    .A(net97),
    .B(_0955_));
 sg13g2_o21ai_1 _2483_ (.B1(_1567_),
    .Y(_0371_),
    .A1(_1566_),
    .A2(_1568_));
 sg13g2_xnor2_1 _2484_ (.Y(_0178_),
    .A(net503),
    .B(_1209_));
 sg13g2_xnor2_1 _2485_ (.Y(_0171_),
    .A(net558),
    .B(net533));
 sg13g2_inv_1 _2486_ (.Y(_0608_),
    .A(net33));
 sg13g2_a21oi_1 _2487_ (.A1(net522),
    .A2(_1239_),
    .Y(_1569_),
    .B1(_1238_));
 sg13g2_and2_1 _2488_ (.A(\pll_dig.flock.cnt_filt[14] ),
    .B(\pll_dig.flock.cnt_filt[13] ),
    .X(_1570_));
 sg13g2_xor2_1 _2489_ (.B(\pll_dig.flock.cnt_filt[13] ),
    .A(\pll_dig.flock.cnt_filt[14] ),
    .X(_1571_));
 sg13g2_xnor2_1 _2490_ (.Y(_1572_),
    .A(net544),
    .B(_1571_));
 sg13g2_nor2_1 _2491_ (.A(net523),
    .B(_1572_),
    .Y(_1573_));
 sg13g2_xor2_1 _2492_ (.B(_1572_),
    .A(net523),
    .X(_1574_));
 sg13g2_a21oi_1 _2493_ (.A1(net561),
    .A2(net741),
    .Y(_1575_),
    .B1(_1241_));
 sg13g2_inv_1 _2494_ (.Y(_1576_),
    .A(_1575_));
 sg13g2_a21oi_1 _2495_ (.A1(_1574_),
    .A2(_1576_),
    .Y(_1577_),
    .B1(net524));
 sg13g2_a21oi_1 _2496_ (.A1(net510),
    .A2(_1571_),
    .Y(_1578_),
    .B1(_1570_));
 sg13g2_inv_1 _2497_ (.Y(_0609_),
    .A(\pll_dig.flock.cnt_err[3] ));
 sg13g2_xor2_1 _2498_ (.B(\pll_dig.flock.cnt_filt[15] ),
    .A(\pll_dig.flock.cnt_filt[14] ),
    .X(_1579_));
 sg13g2_xnor2_1 _2499_ (.Y(_1580_),
    .A(net507),
    .B(_1579_));
 sg13g2_xor2_1 _2500_ (.B(_1580_),
    .A(net511),
    .X(_1581_));
 sg13g2_xnor2_1 _2501_ (.Y(_0176_),
    .A(net525),
    .B(_1581_));
 sg13g2_a21oi_1 _2502_ (.A1(\pll_dig.flock.cnt_filt[14] ),
    .A2(net507),
    .Y(_1582_),
    .B1(\pll_dig.flock.cnt_filt[15] ));
 sg13g2_o21ai_1 _2503_ (.B1(\pll_dig.flock.cnt_filt[15] ),
    .Y(_1583_),
    .A1(\pll_dig.flock.cnt_filt[14] ),
    .A2(net507));
 sg13g2_nand2b_1 _2504_ (.Y(_1584_),
    .B(net508),
    .A_N(_1582_));
 sg13g2_a21o_1 _2505_ (.A2(_1580_),
    .A1(net511),
    .B1(_1577_),
    .X(_1585_));
 sg13g2_o21ai_1 _2506_ (.B1(_1585_),
    .Y(_1586_),
    .A1(net511),
    .A2(_1580_));
 sg13g2_inv_1 _2507_ (.Y(_1587_),
    .A(net512));
 sg13g2_inv_1 _2508_ (.Y(_0610_),
    .A(net28));
 sg13g2_xnor2_1 _2509_ (.Y(_0177_),
    .A(_1584_),
    .B(net512));
 sg13g2_xnor2_1 _2510_ (.Y(_0175_),
    .A(net545),
    .B(_1575_));
 sg13g2_nand2_1 _2511_ (.Y(_1588_),
    .A(net110),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[6] ));
 sg13g2_o21ai_1 _2512_ (.B1(_1588_),
    .Y(_0370_),
    .A1(net110),
    .A2(net356));
 sg13g2_nand3_1 _2513_ (.B(_1036_),
    .C(_1037_),
    .A(_1025_),
    .Y(_1589_));
 sg13g2_a21oi_1 _2514_ (.A1(_1038_),
    .A2(_1589_),
    .Y(_1590_),
    .B1(net110));
 sg13g2_a21oi_1 _2515_ (.A1(net110),
    .A2(_0614_),
    .Y(_0369_),
    .B1(_1590_));
 sg13g2_a21o_1 _2516_ (.A2(net6),
    .A1(net5),
    .B1(net7),
    .X(_1591_));
 sg13g2_and2_1 _2517_ (.A(_0662_),
    .B(_1591_),
    .X(_0126_));
 sg13g2_mux2_1 _2518_ (.A0(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .A1(net380),
    .S(net98),
    .X(_0368_));
 sg13g2_inv_1 _2519_ (.Y(_0611_),
    .A(\pll_dig.dco_miss_cnt[2] ));
 sg13g2_nor3_1 _2520_ (.A(_1013_),
    .B(_1046_),
    .C(_1047_),
    .Y(_1592_));
 sg13g2_nand2_1 _2521_ (.Y(_1593_),
    .A(net111),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[10] ));
 sg13g2_nand2_1 _2522_ (.Y(_1594_),
    .A(net98),
    .B(net361));
 sg13g2_o21ai_1 _2523_ (.B1(_1593_),
    .Y(_0367_),
    .A1(_1592_),
    .A2(_1594_));
 sg13g2_nor2_1 _2524_ (.A(_0752_),
    .B(_0778_),
    .Y(\pll_dig.dlf.ILL_N_C ));
 sg13g2_mux2_1 _2525_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .A1(net373),
    .S(net96),
    .X(_0366_));
 sg13g2_nand2_1 _2526_ (.Y(_1595_),
    .A(_0497_),
    .B(\pll_dig.FREQ_LOCKED ));
 sg13g2_nor2_1 _2527_ (.A(net622),
    .B(\pll_dig.flock.u_fll_icg.EN ),
    .Y(_1596_));
 sg13g2_nand2_1 _2528_ (.Y(_1597_),
    .A(\pll_dig.state[3] ),
    .B(_1276_));
 sg13g2_nor2b_1 _2529_ (.A(net587),
    .B_N(net633),
    .Y(_1598_));
 sg13g2_inv_1 _2530_ (.Y(_0612_),
    .A(\pll_dig.MID_MUX_D[3] ));
 sg13g2_nor2_1 _2531_ (.A(net636),
    .B(net630),
    .Y(_1599_));
 sg13g2_or2_1 _2532_ (.X(_1600_),
    .B(net630),
    .A(net636));
 sg13g2_nor2b_1 _2533_ (.A(net589),
    .B_N(\pll_dig.FREQ_OK ),
    .Y(_1601_));
 sg13g2_inv_1 _2534_ (.Y(_1602_),
    .A(_1601_));
 sg13g2_a21oi_1 _2535_ (.A1(_1600_),
    .A2(_1602_),
    .Y(_1603_),
    .B1(_1598_));
 sg13g2_o21ai_1 _2536_ (.B1(net634),
    .Y(_0049_),
    .A1(_1596_),
    .A2(_1597_));
 sg13g2_mux2_1 _2537_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[8] ),
    .A1(net354),
    .S(net97),
    .X(_0365_));
 sg13g2_a21oi_1 _2538_ (.A1(\pll_dig.ref_wd.cnt[2] ),
    .A2(_1347_),
    .Y(_1604_),
    .B1(\pll_dig.ref_wd.cnt[3] ));
 sg13g2_nor3_1 _2539_ (.A(_0925_),
    .B(_1548_),
    .C(_1604_),
    .Y(_0364_));
 sg13g2_nand2_1 _2540_ (.Y(_1605_),
    .A(\SS_BBPD[0] ),
    .B(net623));
 sg13g2_inv_1 _2541_ (.Y(_0613_),
    .A(\pll_dig.MID_MUX_D[2] ));
 sg13g2_nor2_1 _2542_ (.A(net611),
    .B(net614),
    .Y(_1606_));
 sg13g2_and2_1 _2543_ (.A(\SS_BBPD[0] ),
    .B(_1606_),
    .X(_1607_));
 sg13g2_nand3b_1 _2544_ (.B(_1607_),
    .C(\pll_dig.ENABLE ),
    .Y(_1608_),
    .A_N(net606));
 sg13g2_and3_1 _2545_ (.X(_1609_),
    .A(net635),
    .B(net601),
    .C(net596));
 sg13g2_a21o_1 _2546_ (.A2(_1609_),
    .A1(net653),
    .B1(net607),
    .X(_1610_));
 sg13g2_nor2_1 _2547_ (.A(\pll_dig.lock_detector.win_cnt[0] ),
    .B(net607),
    .Y(_0057_));
 sg13g2_xnor2_1 _2548_ (.Y(_1611_),
    .A(net601),
    .B(\pll_dig.lock_detector.win_cnt[1] ));
 sg13g2_nor2_1 _2549_ (.A(_1608_),
    .B(_1611_),
    .Y(_0058_));
 sg13g2_a21oi_1 _2550_ (.A1(_0496_),
    .A2(_1607_),
    .Y(_1612_),
    .B1(\pll_dig.lock_detector.seen_p ));
 sg13g2_nor2_1 _2551_ (.A(_1610_),
    .B(_1612_),
    .Y(_0056_));
 sg13g2_inv_1 _2552__330 (.Y(net329),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _2553__352 (.Y(net351),
    .A(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_nor2_1 _2554_ (.A(\pll_dig.lock_detector.win_cnt[3] ),
    .B(_1609_),
    .Y(_1613_));
 sg13g2_nor2_1 _2555_ (.A(_1610_),
    .B(_1613_),
    .Y(_0060_));
 sg13g2_a21oi_1 _2556_ (.A1(\pll_dig.lock_detector.win_cnt[0] ),
    .A2(net596),
    .Y(_1614_),
    .B1(\pll_dig.lock_detector.win_cnt[2] ));
 sg13g2_nor3_1 _2557_ (.A(_1608_),
    .B(_1609_),
    .C(net597),
    .Y(_0059_));
 sg13g2_mux2_1 _2558_ (.A0(\pll_dig.div.low_count[3] ),
    .A1(\pll_dig.div.high_count[3] ),
    .S(\pll_dig.div.high_phase ),
    .X(_1615_));
 sg13g2_nand2_1 _2559_ (.Y(_1616_),
    .A(net390),
    .B(_1615_));
 sg13g2_nor2_1 _2560_ (.A(\pll_dig.div.high_count[2] ),
    .B(net396),
    .Y(_1617_));
 sg13g2_nor2_1 _2561_ (.A(net400),
    .B(\pll_dig.div.high_count[1] ),
    .Y(_1618_));
 sg13g2_nor3_1 _2562_ (.A(_0479_),
    .B(_0165_),
    .C(_1618_),
    .Y(_1619_));
 sg13g2_a21oi_1 _2563_ (.A1(\pll_dig.div.high_count[1] ),
    .A2(net435),
    .Y(_1620_),
    .B1(_1619_));
 sg13g2_inv_1 _2564_ (.Y(\pll_dig.dsm_impl.u_dsm_icg.EN ),
    .A(\pll_dig.dsm_impl.locked_dsm_s2 ));
 sg13g2_a21oi_1 _2565_ (.A1(\pll_dig.div.high_count[2] ),
    .A2(net396),
    .Y(_1621_),
    .B1(_0494_));
 sg13g2_o21ai_1 _2566_ (.B1(_1621_),
    .Y(_1622_),
    .A1(_1620_),
    .A2(_1617_));
 sg13g2_o21ai_1 _2567_ (.B1(_1622_),
    .Y(_1623_),
    .A1(\pll_dig.div.high_phase ),
    .A2(_0882_));
 sg13g2_mux2_1 _2568_ (.A0(\pll_dig.div.low_count[4] ),
    .A1(\pll_dig.div.high_count[4] ),
    .S(\pll_dig.div.high_phase ),
    .X(_1624_));
 sg13g2_nor2_1 _2569_ (.A(net393),
    .B(_1624_),
    .Y(_1625_));
 sg13g2_a21oi_2 _2570_ (.B1(_1625_),
    .Y(_1626_),
    .A2(_1616_),
    .A1(_1623_));
 sg13g2_o21ai_1 _2571_ (.B1(_1626_),
    .Y(_1627_),
    .A1(net391),
    .A2(_1615_));
 sg13g2_mux2_1 _2572_ (.A0(\pll_dig.div.low_count[5] ),
    .A1(\pll_dig.div.high_count[5] ),
    .S(\pll_dig.div.high_phase ),
    .X(_1628_));
 sg13g2_a22oi_1 _2573_ (.Y(_1629_),
    .B1(_1628_),
    .B2(net398),
    .A2(_1624_),
    .A1(net392));
 sg13g2_or2_1 _2574_ (.X(_1630_),
    .B(_1628_),
    .A(net434));
 sg13g2_inv_1 _2575__351 (.Y(net350),
    .A(clknet_3_4__leaf_MID_OUT));
 sg13g2_mux2_1 _2576_ (.A0(\pll_dig.div.low_count[6] ),
    .A1(\pll_dig.div.high_count[6] ),
    .S(\pll_dig.div.high_phase ),
    .X(_1631_));
 sg13g2_o21ai_1 _2577_ (.B1(_1630_),
    .Y(_1632_),
    .A1(_0893_),
    .A2(_1631_));
 sg13g2_a21oi_2 _2578_ (.B1(_1632_),
    .Y(_1633_),
    .A2(_1629_),
    .A1(_1627_));
 sg13g2_and2_1 _2579_ (.A(\pll_dig.div.high_phase ),
    .B(\pll_dig.div.high_count[7] ),
    .X(_1634_));
 sg13g2_a221oi_1 _2580_ (.B2(net389),
    .C1(_1633_),
    .B1(_1634_),
    .A1(net387),
    .Y(_1635_),
    .A2(_1631_));
 sg13g2_nor3_2 _2581_ (.A(\pll_dig.div.leave_req ),
    .B(\pll_dig.div.use_clk_p ),
    .C(_1635_),
    .Y(_1636_));
 sg13g2_o21ai_1 _2582_ (.B1(_1636_),
    .Y(_1637_),
    .A1(net389),
    .A2(_1634_));
 sg13g2_nand2_1 _2583_ (.Y(_1638_),
    .A(\pll_dig.div.out_reg ),
    .B(net395));
 sg13g2_nor2_1 _2584_ (.A(\pll_dig.div.div_pend[2] ),
    .B(\pll_dig.div.div_pend[3] ),
    .Y(_1639_));
 sg13g2_nor4_1 _2585_ (.A(\pll_dig.div.div_pend[6] ),
    .B(\pll_dig.div.div_pend[7] ),
    .C(\pll_dig.div.div_pend[5] ),
    .D(\pll_dig.div.div_pend[4] ),
    .Y(_1640_));
 sg13g2_inv_1 _2586_ (.Y(_0614_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[5] ));
 sg13g2_nand3_1 _2587_ (.B(_1639_),
    .C(_1640_),
    .A(_0157_),
    .Y(_1641_));
 sg13g2_inv_1 _2588_ (.Y(_1642_),
    .A(_1641_));
 sg13g2_nand2_1 _2589_ (.Y(_1643_),
    .A(\pll_dig.div.div_pend[0] ),
    .B(_1642_));
 sg13g2_nor2_2 _2590_ (.A(_1643_),
    .B(net399),
    .Y(_1644_));
 sg13g2_nor2_2 _2591_ (.A(\pll_dig.div.use_clk_p ),
    .B(_1644_),
    .Y(_1645_));
 sg13g2_nand2_1 _2592_ (.Y(_1646_),
    .A(_1638_),
    .B(_1645_));
 sg13g2_xor2_1 _2593_ (.B(_1646_),
    .A(net83),
    .X(_0362_));
 sg13g2_mux2_1 _2594_ (.A0(\pll_dig.div.div_pend[2] ),
    .A1(net50),
    .S(net243),
    .X(_0361_));
 sg13g2_nor2_1 _2595_ (.A(\pll_dig.div.enter_req ),
    .B(_1644_),
    .Y(_1647_));
 sg13g2_nor2_1 _2596_ (.A(\pll_dig.div.use_clk_p ),
    .B(_1647_),
    .Y(_0356_));
 sg13g2_inv_1 _2597__353 (.Y(net352),
    .A(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_nor2_1 _2598_ (.A(net243),
    .B(_0157_),
    .Y(_1648_));
 sg13g2_a21oi_1 _2599_ (.A1(net243),
    .A2(net49),
    .Y(_0350_),
    .B1(_1648_));
 sg13g2_nand2_1 _2600_ (.Y(_1649_),
    .A(net46),
    .B(net55));
 sg13g2_o21ai_1 _2601_ (.B1(_1649_),
    .Y(_0348_),
    .A1(_0501_),
    .A2(net243));
 sg13g2_mux2_1 _2602_ (.A0(\pll_dig.div.div_pend[6] ),
    .A1(net54),
    .S(net243),
    .X(_0346_));
 sg13g2_mux2_1 _2603_ (.A0(\pll_dig.div.div_pend[5] ),
    .A1(net53),
    .S(net243),
    .X(_0345_));
 sg13g2_mux2_1 _2604_ (.A0(\pll_dig.div.use_clk_p ),
    .A1(\pll_dig.div.use_clk ),
    .S(net136),
    .X(_0344_));
 sg13g2_mux2_1 _2605_ (.A0(\pll_dig.div.div_pend[3] ),
    .A1(net51),
    .S(net46),
    .X(_0343_));
 sg13g2_o21ai_1 _2606_ (.B1(_0511_),
    .Y(_0342_),
    .A1(_0603_),
    .A2(net82));
 sg13g2_nor4_1 _2607_ (.A(net55),
    .B(net54),
    .C(net51),
    .D(net50),
    .Y(_1650_));
 sg13g2_inv_1 _2608_ (.Y(_0615_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[6] ));
 sg13g2_nor4_1 _2609_ (.A(_0511_),
    .B(net53),
    .C(net52),
    .D(net49),
    .Y(_1651_));
 sg13g2_mux2_1 _2610_ (.A0(\pll_dig.div.div_pend[0] ),
    .A1(net48),
    .S(net46),
    .X(_1652_));
 sg13g2_a21o_1 _2611_ (.A2(_1651_),
    .A1(_1650_),
    .B1(_1652_),
    .X(_0340_));
 sg13g2_mux2_1 _2612_ (.A0(\pll_dig.div.div_pend[4] ),
    .A1(net52),
    .S(net243),
    .X(_0339_));
 sg13g2_a21oi_1 _2613_ (.A1(\pll_dig.div.pend ),
    .A2(_1643_),
    .Y(_1653_),
    .B1(\pll_dig.div.leave_req ));
 sg13g2_nor2b_1 _2614_ (.A(_1653_),
    .B_N(\pll_dig.div.use_clk_p ),
    .Y(_0338_));
 sg13g2_nand4_1 _2615_ (.B(\pll_dig.FREQ_ERR ),
    .C(net594),
    .A(_0497_),
    .Y(_1654_),
    .D(\pll_dig.flock.u_fll_icg.EN ));
 sg13g2_nand2b_1 _2616_ (.Y(_0047_),
    .B(_1654_),
    .A_N(\pll_dig.state[1] ));
 sg13g2_and2_1 _2617_ (.A(\pll_dig.lock_detector.bad_cnt[1] ),
    .B(net599),
    .X(_1655_));
 sg13g2_nor4_1 _2618_ (.A(_0599_),
    .B(net617),
    .C(_1607_),
    .D(_1655_),
    .Y(_1656_));
 sg13g2_inv_1 _2619_ (.Y(_0616_),
    .A(\pll_dig.flock.FCW_PA[2] ));
 sg13g2_nor2b_1 _2620_ (.A(\pll_dig.lock_detector.bad_cnt[0] ),
    .B_N(net618),
    .Y(_0052_));
 sg13g2_nor2_1 _2621_ (.A(net664),
    .B(_1602_),
    .Y(_1657_));
 sg13g2_nand2b_1 _2622_ (.Y(_1658_),
    .B(_1601_),
    .A_N(net664));
 sg13g2_nand2_1 _2623_ (.Y(_1659_),
    .A(net630),
    .B(_1657_));
 sg13g2_or4_1 _2624_ (.A(\pll_dig.cnt[3] ),
    .B(\pll_dig.cnt[2] ),
    .C(\pll_dig.cnt[0] ),
    .D(net603),
    .X(_1660_));
 sg13g2_nor3_1 _2625_ (.A(\pll_dig.cnt[7] ),
    .B(\pll_dig.cnt[4] ),
    .C(_1660_),
    .Y(_1661_));
 sg13g2_nand4_1 _2626_ (.B(net608),
    .C(net625),
    .A(_0581_),
    .Y(_1662_),
    .D(_1661_));
 sg13g2_nand3_1 _2627_ (.B(_1657_),
    .C(_1662_),
    .A(net630),
    .Y(_1663_));
 sg13g2_nand2_1 _2628_ (.Y(_1664_),
    .A(net594),
    .B(_1596_));
 sg13g2_nand2b_1 _2629_ (.Y(_1665_),
    .B(net625),
    .A_N(net664));
 sg13g2_inv_1 _2630_ (.Y(_0617_),
    .A(\pll_dig.flock.FCW_PA[6] ));
 sg13g2_nand3_1 _2631_ (.B(_1601_),
    .C(_1665_),
    .A(net636),
    .Y(_1666_));
 sg13g2_nand3_1 _2632_ (.B(\pll_dig.LOCK_LOST ),
    .C(_1601_),
    .A(\pll_dig.state[2] ),
    .Y(_1667_));
 sg13g2_nand4_1 _2633_ (.B(_1664_),
    .C(net637),
    .A(_1663_),
    .Y(_0048_),
    .D(_1667_));
 sg13g2_o21ai_1 _2634_ (.B1(_1656_),
    .Y(_1668_),
    .A1(\pll_dig.lock_detector.bad_cnt[1] ),
    .A2(net599));
 sg13g2_inv_1 _2635_ (.Y(_0053_),
    .A(net600));
 sg13g2_xnor2_1 _2636_ (.Y(_1669_),
    .A(_0727_),
    .B(_0764_));
 sg13g2_a22oi_1 _2637_ (.Y(_1670_),
    .B1(net66),
    .B2(_1669_),
    .A2(net678),
    .A1(net133));
 sg13g2_xnor2_1 _2638_ (.Y(_1671_),
    .A(_0724_),
    .B(_0727_));
 sg13g2_a22oi_1 _2639_ (.Y(\pll_dig.dlf.OUT_C[7] ),
    .B1(_1671_),
    .B2(net62),
    .A2(_1670_),
    .A1(net131));
 sg13g2_xor2_1 _2640_ (.B(_0722_),
    .A(_0702_),
    .X(_1672_));
 sg13g2_inv_1 _2641_ (.Y(_0618_),
    .A(_0155_));
 sg13g2_xnor2_1 _2642_ (.Y(_1673_),
    .A(_0702_),
    .B(_0762_));
 sg13g2_a22oi_1 _2643_ (.Y(_1674_),
    .B1(net66),
    .B2(_1673_),
    .A2(net667),
    .A1(net133));
 sg13g2_a22oi_1 _2644_ (.Y(\pll_dig.dlf.OUT_C[6] ),
    .B1(net668),
    .B2(net132),
    .A2(_1672_),
    .A1(net62));
 sg13g2_xor2_1 _2645_ (.B(_0715_),
    .A(_0703_),
    .X(_1675_));
 sg13g2_xnor2_1 _2646_ (.Y(_1676_),
    .A(_0703_),
    .B(_0759_));
 sg13g2_a22oi_1 _2647_ (.Y(_1677_),
    .B1(net66),
    .B2(_1676_),
    .A2(net673),
    .A1(net133));
 sg13g2_a22oi_1 _2648_ (.Y(\pll_dig.dlf.OUT_C[4] ),
    .B1(net674),
    .B2(net132),
    .A2(_1675_),
    .A1(net62));
 sg13g2_nand2_1 _2649_ (.Y(_1678_),
    .A(net107),
    .B(net381));
 sg13g2_xnor2_1 _2650_ (.Y(_1679_),
    .A(\pll_dig.dsm_impl.dsm.cin_stg1 ),
    .B(_0944_));
 sg13g2_o21ai_1 _2651_ (.B1(_1678_),
    .Y(_0337_),
    .A1(net107),
    .A2(_1679_));
 sg13g2_inv_1 _2652_ (.Y(_0619_),
    .A(\pll_dig.div.cnt[3] ));
 sg13g2_mux2_1 _2653_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[7] ),
    .A1(net358),
    .S(net97),
    .X(_0336_));
 sg13g2_and3_1 _2654_ (.X(_1680_),
    .A(_1010_),
    .B(net361),
    .C(net370));
 sg13g2_nor3_1 _2655_ (.A(net105),
    .B(net372),
    .C(_1680_),
    .Y(_1681_));
 sg13g2_a21o_1 _2656_ (.A2(net105),
    .A1(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .B1(_1681_),
    .X(_0335_));
 sg13g2_nand3_1 _2657_ (.B(_1038_),
    .C(_1039_),
    .A(_1023_),
    .Y(_1682_));
 sg13g2_a21oi_1 _2658_ (.A1(_1040_),
    .A2(_1682_),
    .Y(_1683_),
    .B1(net110));
 sg13g2_a21oi_1 _2659_ (.A1(net110),
    .A2(_0615_),
    .Y(_0334_),
    .B1(_1683_));
 sg13g2_nand4_1 _2660_ (.B(net98),
    .C(_1003_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .Y(_1684_),
    .D(_1051_));
 sg13g2_o21ai_1 _2661_ (.B1(_1684_),
    .Y(_0333_),
    .A1(_0517_),
    .A2(net98));
 sg13g2_nor2_1 _2662_ (.A(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .B(net98),
    .Y(_1685_));
 sg13g2_inv_1 _2663_ (.Y(_0493_),
    .A(\pll_dig.out_edges[7] ));
 sg13g2_inv_1 _2664_ (.Y(_0620_),
    .A(\pll_dig.div.pcnt[3] ));
 sg13g2_a21oi_1 _2665_ (.A1(net98),
    .A2(_1003_),
    .Y(_0332_),
    .B1(_1685_));
 sg13g2_a21o_1 _2666_ (.A2(net382),
    .A1(net108),
    .B1(_1292_),
    .X(_0331_));
 sg13g2_o21ai_1 _2667_ (.B1(net94),
    .Y(\pll_dig.FINE_MUX_D[18] ),
    .A1(net103),
    .A2(_1272_));
 sg13g2_a21oi_1 _2668_ (.A1(\SS_BBPD[1] ),
    .A2(_1607_),
    .Y(_1686_),
    .B1(\pll_dig.lock_detector.seen_n ));
 sg13g2_nor2_1 _2669_ (.A(_1610_),
    .B(_1686_),
    .Y(_0055_));
 sg13g2_nor3_1 _2670_ (.A(_0600_),
    .B(_1602_),
    .C(_1665_),
    .Y(_1687_));
 sg13g2_inv_1 _2671_ (.Y(_1688_),
    .A(_1687_));
 sg13g2_o21ai_1 _2672_ (.B1(_1688_),
    .Y(_0050_),
    .A1(net631),
    .A2(_1662_));
 sg13g2_nand2_1 _2673_ (.Y(_1689_),
    .A(net553),
    .B(_1204_));
 sg13g2_xnor2_1 _2674_ (.Y(_0179_),
    .A(_1211_),
    .B(net554));
 sg13g2_inv_1 _2675_ (.Y(\pll_dig.FILTER_OUT[15] ),
    .A(net727));
 sg13g2_xnor2_1 _2676_ (.Y(_0184_),
    .A(net739),
    .B(net516));
 sg13g2_o21ai_1 _2677_ (.B1(net508),
    .Y(_0170_),
    .A1(_1584_),
    .A2(_1587_));
 sg13g2_mux2_1 _2678_ (.A0(net159),
    .A1(\pll_dig.div.div_pend[2] ),
    .S(net82),
    .X(_0330_));
 sg13g2_mux2_1 _2679_ (.A0(net156),
    .A1(\pll_dig.div.div_pend[4] ),
    .S(net82),
    .X(_0326_));
 sg13g2_o21ai_1 _2680_ (.B1(_1645_),
    .Y(_1690_),
    .A1(_0494_),
    .A2(\pll_dig.div.leave_req ));
 sg13g2_xor2_1 _2681_ (.B(_1690_),
    .A(net83),
    .X(_0325_));
 sg13g2_mux2_1 _2682_ (.A0(net153),
    .A1(\pll_dig.div.div_pend[6] ),
    .S(net82),
    .X(_0323_));
 sg13g2_nor2_2 _2683_ (.A(\pll_dig.div.div[7] ),
    .B(net82),
    .Y(_1691_));
 sg13g2_a21oi_2 _2684_ (.B1(_1691_),
    .Y(_0322_),
    .A2(net82),
    .A1(_0501_));
 sg13g2_mux2_1 _2685_ (.A0(net158),
    .A1(\pll_dig.div.div_pend[3] ),
    .S(net82),
    .X(_0321_));
 sg13g2_inv_1 _2686_ (.Y(_0262_),
    .A(net731));
 sg13g2_mux2_1 _2687_ (.A0(net154),
    .A1(\pll_dig.div.div_pend[5] ),
    .S(net384),
    .X(_0320_));
 sg13g2_xnor2_1 _2688_ (.Y(_1692_),
    .A(_0740_),
    .B(_0743_));
 sg13g2_xnor2_1 _2689_ (.Y(_1693_),
    .A(_0743_),
    .B(_0773_));
 sg13g2_nand2_1 _2690_ (.Y(_1694_),
    .A(net65),
    .B(_1693_));
 sg13g2_a22oi_1 _2691_ (.Y(_1695_),
    .B1(_1694_),
    .B2(net131),
    .A2(_1692_),
    .A1(net61));
 sg13g2_a21o_1 _2692_ (.A2(net120),
    .A1(net133),
    .B1(_1695_),
    .X(\pll_dig.dlf.OUT_C[13] ));
 sg13g2_xnor2_1 _2693_ (.Y(_1696_),
    .A(_0734_),
    .B(_0767_));
 sg13g2_a22oi_1 _2694_ (.Y(_1697_),
    .B1(net66),
    .B2(_1696_),
    .A2(net121),
    .A1(net133));
 sg13g2_xnor2_1 _2695_ (.Y(_1698_),
    .A(_0731_),
    .B(_0734_));
 sg13g2_a22oi_1 _2696_ (.Y(\pll_dig.dlf.OUT_C[9] ),
    .B1(_1698_),
    .B2(net62),
    .A2(net689),
    .A1(net132));
 sg13g2_nor2b_1 _2697_ (.A(_0157_),
    .B_N(\pll_dig.div.div_pend[0] ),
    .Y(_0621_));
 sg13g2_xor2_1 _2698_ (.B(_0736_),
    .A(_0700_),
    .X(_1699_));
 sg13g2_xnor2_1 _2699_ (.Y(_1700_),
    .A(_0700_),
    .B(_0768_));
 sg13g2_a22oi_1 _2700_ (.Y(_1701_),
    .B1(net65),
    .B2(_1700_),
    .A2(net661),
    .A1(net133));
 sg13g2_a22oi_1 _2701_ (.Y(\pll_dig.dlf.OUT_C[10] ),
    .B1(net662),
    .B2(net132),
    .A2(_1699_),
    .A1(net61));
 sg13g2_a21oi_1 _2702_ (.A1(_0492_),
    .A2(_1274_),
    .Y(\pll_dig.FINE_MUX_D[12] ),
    .B1(net99));
 sg13g2_nor2_1 _2703_ (.A(\pll_dig.flock.cnt[6] ),
    .B(net423),
    .Y(_1702_));
 sg13g2_nor2_1 _2704_ (.A(\pll_dig.flock.cnt_gray[5] ),
    .B(net126),
    .Y(_1703_));
 sg13g2_xor2_1 _2705_ (.B(_1702_),
    .A(\pll_dig.flock.cnt[7] ),
    .X(_1704_));
 sg13g2_a21oi_1 _2706_ (.A1(net126),
    .A2(_1704_),
    .Y(_0319_),
    .B1(_1703_));
 sg13g2_and3_1 _2707_ (.X(_1705_),
    .A(\pll_dig.flock.cnt[4] ),
    .B(net127),
    .C(net420));
 sg13g2_and3_1 _2708_ (.X(_0622_),
    .A(\pll_dig.div.div_pend[2] ),
    .B(\pll_dig.div.div_pend[3] ),
    .C(_0621_));
 sg13g2_xor2_1 _2709_ (.B(_1705_),
    .A(\pll_dig.flock.cnt[5] ),
    .X(_0318_));
 sg13g2_a221oi_1 _2710_ (.B2(\pll_dig.COARSE_MUX_D[2] ),
    .C1(net75),
    .B1(net91),
    .A1(\pll_dig.COARSE_MUX_D[4] ),
    .Y(_1706_),
    .A2(net85));
 sg13g2_a21oi_1 _2711_ (.A1(_0583_),
    .A2(net75),
    .Y(_0317_),
    .B1(_1706_));
 sg13g2_a221oi_1 _2712_ (.B2(\pll_dig.COARSE_MUX_D[11] ),
    .C1(net72),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[13] ),
    .Y(_1707_),
    .A2(net84));
 sg13g2_a21oi_1 _2713_ (.A1(_0527_),
    .A2(net72),
    .Y(_0316_),
    .B1(_1707_));
 sg13g2_nand2_1 _2714_ (.Y(_1708_),
    .A(net30),
    .B(\SS_BBPD[0] ));
 sg13g2_xnor2_1 _2715_ (.Y(_1709_),
    .A(net686),
    .B(_1708_));
 sg13g2_nor2_1 _2716_ (.A(\pll_dig.dlf.ILL_P_C ),
    .B(_1709_),
    .Y(_1710_));
 sg13g2_nor2_1 _2717_ (.A(\pll_dig.dlf.ILL_N_C ),
    .B(_1710_),
    .Y(\pll_dig.dlf.OUT_C[0] ));
 sg13g2_a21oi_1 _2718_ (.A1(\pll_dig.flock.cnt[4] ),
    .A2(net420),
    .Y(_1711_),
    .B1(\pll_dig.flock.cnt[5] ));
 sg13g2_and2_1 _2719_ (.A(\pll_dig.div.div_pend[4] ),
    .B(_0622_),
    .X(_0623_));
 sg13g2_xor2_1 _2720_ (.B(_1711_),
    .A(\pll_dig.flock.cnt[6] ),
    .X(_1712_));
 sg13g2_nand2_1 _2721_ (.Y(_1713_),
    .A(\pll_dig.flock.cnt_gray[4] ),
    .B(net124));
 sg13g2_o21ai_1 _2722_ (.B1(_1713_),
    .Y(_0315_),
    .A1(net124),
    .A2(_1712_));
 sg13g2_xor2_1 _2723_ (.B(\pll_dig.dsm_impl.FCWF[11] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .X(_1714_));
 sg13g2_xnor2_1 _2724_ (.Y(_1715_),
    .A(_0969_),
    .B(_1714_));
 sg13g2_mux2_1 _2725_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .A1(_1715_),
    .S(net98),
    .X(_0314_));
 sg13g2_a221oi_1 _2726_ (.B2(\pll_dig.MID_MUX_D[2] ),
    .C1(net77),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[4] ),
    .Y(_1716_),
    .A2(net88));
 sg13g2_a22oi_1 _2727_ (.Y(_0313_),
    .B1(net69),
    .B2(_1716_),
    .A2(net77),
    .A1(_0612_));
 sg13g2_a21oi_1 _2728_ (.A1(_0587_),
    .A2(_0618_),
    .Y(_0312_),
    .B1(_0925_));
 sg13g2_a221oi_1 _2729_ (.B2(\pll_dig.MID_MUX_D[12] ),
    .C1(net78),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[14] ),
    .Y(_1717_),
    .A2(net88));
 sg13g2_nand3_1 _2730_ (.B(\pll_dig.div.div_pend[5] ),
    .C(_0623_),
    .A(\pll_dig.div.div_pend[6] ),
    .Y(_0624_));
 sg13g2_a21oi_1 _2731_ (.A1(_0540_),
    .A2(net78),
    .Y(_0311_),
    .B1(_1717_));
 sg13g2_nor2_1 _2732_ (.A(\pll_dig.flock.cnt_gray[13] ),
    .B(net128),
    .Y(_1718_));
 sg13g2_nand2b_1 _2733_ (.Y(_1719_),
    .B(net415),
    .A_N(\pll_dig.flock.cnt[14] ));
 sg13g2_xnor2_1 _2734_ (.Y(_1720_),
    .A(\pll_dig.flock.cnt[15] ),
    .B(_1719_));
 sg13g2_a21oi_1 _2735_ (.A1(net128),
    .A2(_1720_),
    .Y(_0310_),
    .B1(_1718_));
 sg13g2_nand3_1 _2736_ (.B(net128),
    .C(net421),
    .A(\pll_dig.flock.cnt[12] ),
    .Y(_1721_));
 sg13g2_a21oi_1 _2737_ (.A1(_0528_),
    .A2(_1721_),
    .Y(_0309_),
    .B1(net417));
 sg13g2_and4_1 _2738_ (.A(\pll_dig.flock.cnt_done[2] ),
    .B(\pll_dig.flock.cnt_done[3] ),
    .C(\pll_dig.flock.cnt_done[4] ),
    .D(_1145_),
    .X(_1722_));
 sg13g2_nand2_1 _2739_ (.Y(_1723_),
    .A(\pll_dig.flock.cnt_done[5] ),
    .B(_1722_));
 sg13g2_nand4_1 _2740_ (.B(\pll_dig.flock.cnt_done[6] ),
    .C(net81),
    .A(\pll_dig.flock.cnt_done[5] ),
    .Y(_1724_),
    .D(_1722_));
 sg13g2_nor2_1 _2741_ (.A(_0501_),
    .B(_0624_),
    .Y(_0111_));
 sg13g2_xnor2_1 _2742_ (.Y(_1725_),
    .A(\pll_dig.flock.cnt_done[7] ),
    .B(_1724_));
 sg13g2_a22oi_1 _2743_ (.Y(_1726_),
    .B1(_1141_),
    .B2(_1725_),
    .A2(_1101_),
    .A1(\pll_dig.flock.cnt_done[7] ));
 sg13g2_inv_1 _2744_ (.Y(_0028_),
    .A(_1726_));
 sg13g2_xnor2_1 _2745_ (.Y(_0181_),
    .A(net570),
    .B(net737));
 sg13g2_xor2_1 _2746_ (.B(_1212_),
    .A(net565),
    .X(_0180_));
 sg13g2_a221oi_1 _2747_ (.B2(\pll_dig.COARSE_MUX_D[7] ),
    .C1(net73),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[9] ),
    .Y(_1727_),
    .A2(net84));
 sg13g2_a21oi_1 _2748_ (.A1(_0552_),
    .A2(net73),
    .Y(_0308_),
    .B1(_1727_));
 sg13g2_xnor2_1 _2749_ (.Y(_1728_),
    .A(_0713_),
    .B(_0758_));
 sg13g2_a22oi_1 _2750_ (.Y(_1729_),
    .B1(net66),
    .B2(_1728_),
    .A2(net676),
    .A1(_0495_));
 sg13g2_xnor2_1 _2751_ (.Y(_1730_),
    .A(_0710_),
    .B(_0713_));
 sg13g2_xor2_1 _2752_ (.B(_0623_),
    .A(\pll_dig.div.div_pend[5] ),
    .X(_0108_));
 sg13g2_a22oi_1 _2753_ (.Y(\pll_dig.dlf.OUT_C[3] ),
    .B1(_1730_),
    .B2(net62),
    .A2(_1729_),
    .A1(net132));
 sg13g2_xnor2_1 _2754_ (.Y(_0182_),
    .A(_1216_),
    .B(net549));
 sg13g2_a221oi_1 _2755_ (.B2(\pll_dig.MID_MUX_D[1] ),
    .C1(net77),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[3] ),
    .Y(_1731_),
    .A2(net88));
 sg13g2_a22oi_1 _2756_ (.Y(_0307_),
    .B1(net69),
    .B2(_1731_),
    .A2(net77),
    .A1(_0613_));
 sg13g2_xnor2_1 _2757_ (.Y(_0306_),
    .A(_1547_),
    .B(\pll_dig.flock.cnt_gray[15] ));
 sg13g2_a21oi_2 _2758_ (.B1(\pll_dig.flock.cnt[13] ),
    .Y(_1732_),
    .A2(net421),
    .A1(\pll_dig.flock.cnt[12] ));
 sg13g2_nor2_1 _2759_ (.A(\pll_dig.flock.cnt_gray[12] ),
    .B(net128),
    .Y(_1733_));
 sg13g2_xor2_1 _2760_ (.B(_1732_),
    .A(\pll_dig.flock.cnt[14] ),
    .X(_1734_));
 sg13g2_a21oi_1 _2761_ (.A1(net128),
    .A2(_1734_),
    .Y(_0305_),
    .B1(_1733_));
 sg13g2_a221oi_1 _2762_ (.B2(\pll_dig.COARSE_MUX_D[1] ),
    .C1(net75),
    .B1(net91),
    .A1(\pll_dig.COARSE_MUX_D[3] ),
    .Y(_1735_),
    .A2(net85));
 sg13g2_mux2_1 _2763_ (.A0(\pll_dig.div.hi_cur[5] ),
    .A1(\pll_dig.div.hi_pend[5] ),
    .S(net151),
    .X(\pll_dig.div.high_count_pend[5] ));
 sg13g2_a21oi_1 _2764_ (.A1(_0589_),
    .A2(net75),
    .Y(_0304_),
    .B1(_1735_));
 sg13g2_a221oi_1 _2765_ (.B2(\pll_dig.MID_MUX_D[7] ),
    .C1(net79),
    .B1(net87),
    .A1(\pll_dig.MID_MUX_D[9] ),
    .Y(_1736_),
    .A2(net89));
 sg13g2_a22oi_1 _2766_ (.Y(_0303_),
    .B1(net69),
    .B2(_1736_),
    .A2(net79),
    .A1(_0543_));
 sg13g2_nor3_1 _2767_ (.A(_0937_),
    .B(_0957_),
    .C(_0958_),
    .Y(_1737_));
 sg13g2_nand2_1 _2768_ (.Y(_1738_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(net111));
 sg13g2_nand2_1 _2769_ (.Y(_1739_),
    .A(_0520_),
    .B(_0959_));
 sg13g2_o21ai_1 _2770_ (.B1(_1738_),
    .Y(_0302_),
    .A1(_1737_),
    .A2(_1739_));
 sg13g2_a21oi_1 _2771_ (.A1(net127),
    .A2(net420),
    .Y(_1740_),
    .B1(\pll_dig.flock.cnt[4] ));
 sg13g2_nor2_1 _2772_ (.A(_1705_),
    .B(_1740_),
    .Y(_0301_));
 sg13g2_or2_1 _2773_ (.X(_0300_),
    .B(\pll_dig.flock.started ),
    .A(\pll_dig.START ));
 sg13g2_inv_1 _2774_ (.Y(_0494_),
    .A(\pll_dig.div.high_phase ));
 sg13g2_a21o_1 _2775_ (.A2(_0623_),
    .A1(\pll_dig.div.div_pend[5] ),
    .B1(\pll_dig.div.div_pend[6] ),
    .X(_0625_));
 sg13g2_a221oi_1 _2776_ (.B2(\pll_dig.COARSE_MUX_D[6] ),
    .C1(net73),
    .B1(net91),
    .A1(\pll_dig.COARSE_MUX_D[8] ),
    .Y(_1741_),
    .A2(net84));
 sg13g2_a21oi_1 _2777_ (.A1(_0553_),
    .A2(net74),
    .Y(_0298_),
    .B1(_1741_));
 sg13g2_a21o_1 _2778_ (.A2(net421),
    .A1(net129),
    .B1(\pll_dig.flock.cnt[12] ),
    .X(_1742_));
 sg13g2_and2_1 _2779_ (.A(_1721_),
    .B(_1742_),
    .X(_0297_));
 sg13g2_nand2_1 _2780_ (.Y(_1743_),
    .A(\pll_dig.flock.cnt_done[6] ),
    .B(_1101_));
 sg13g2_xor2_1 _2781_ (.B(_1723_),
    .A(\pll_dig.flock.cnt_done[6] ),
    .X(_1744_));
 sg13g2_nor2b_1 _2782_ (.A(_1139_),
    .B_N(\pll_dig.flock.cnt_done[6] ),
    .Y(_1745_));
 sg13g2_a21oi_1 _2783_ (.A1(\pll_dig.flock.cnt_done[7] ),
    .A2(_1140_),
    .Y(_1746_),
    .B1(_1745_));
 sg13g2_mux2_1 _2784_ (.A0(_1746_),
    .A1(_1744_),
    .S(net81),
    .X(_1747_));
 sg13g2_o21ai_1 _2785_ (.B1(_1743_),
    .Y(_0027_),
    .A1(_1099_),
    .A2(_1747_));
 sg13g2_and2_1 _2786_ (.A(_0624_),
    .B(_0625_),
    .X(_0109_));
 sg13g2_and3_1 _2787_ (.X(_1748_),
    .A(_0938_),
    .B(_0955_),
    .C(_0956_));
 sg13g2_nor3_1 _2788_ (.A(net111),
    .B(_0957_),
    .C(_1748_),
    .Y(_1749_));
 sg13g2_a21o_1 _2789_ (.A2(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .A1(net111),
    .B1(_1749_),
    .X(_0296_));
 sg13g2_a221oi_1 _2790_ (.B2(\pll_dig.COARSE_MUX_D[12] ),
    .C1(net72),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[14] ),
    .Y(_1750_),
    .A2(net84));
 sg13g2_a21oi_1 _2791_ (.A1(_0532_),
    .A2(net72),
    .Y(_0295_),
    .B1(_1750_));
 sg13g2_o21ai_1 _2792_ (.B1(_0926_),
    .Y(_1751_),
    .A1(\pll_dig.ref_wd.cnt[2] ),
    .A2(_1347_));
 sg13g2_a21oi_1 _2793_ (.A1(\pll_dig.ref_wd.cnt[2] ),
    .A2(_1347_),
    .Y(_0294_),
    .B1(_1751_));
 sg13g2_a221oi_1 _2794_ (.B2(\pll_dig.MID_MUX_D[6] ),
    .C1(net80),
    .B1(net87),
    .A1(\pll_dig.MID_MUX_D[8] ),
    .Y(_1752_),
    .A2(net89));
 sg13g2_a22oi_1 _2795_ (.Y(_0293_),
    .B1(_1260_),
    .B2(_1752_),
    .A2(net79),
    .A1(_0542_));
 sg13g2_a221oi_1 _2796_ (.B2(\pll_dig.MID_MUX_D[3] ),
    .C1(net77),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[5] ),
    .Y(_1753_),
    .A2(net88));
 sg13g2_mux2_1 _2797_ (.A0(\pll_dig.div.hi_cur[6] ),
    .A1(\pll_dig.div.hi_pend[6] ),
    .S(net151),
    .X(\pll_dig.div.high_count_pend[6] ));
 sg13g2_a22oi_1 _2798_ (.Y(_0292_),
    .B1(net69),
    .B2(_1753_),
    .A2(net77),
    .A1(_0594_));
 sg13g2_a221oi_1 _2799_ (.B2(\pll_dig.MID_MUX_D[9] ),
    .C1(net79),
    .B1(net87),
    .A1(\pll_dig.MID_MUX_D[11] ),
    .Y(_1754_),
    .A2(net89));
 sg13g2_a22oi_1 _2800_ (.Y(_0291_),
    .B1(_1260_),
    .B2(_1754_),
    .A2(net80),
    .A1(_0551_));
 sg13g2_nor2_1 _2801_ (.A(_1378_),
    .B(_1379_),
    .Y(_1755_));
 sg13g2_o21ai_1 _2802_ (.B1(net162),
    .Y(_1756_),
    .A1(_1403_),
    .A2(_1755_));
 sg13g2_a21oi_1 _2803_ (.A1(_1403_),
    .A2(_1755_),
    .Y(_0082_),
    .B1(_1756_));
 sg13g2_a221oi_1 _2804_ (.B2(\pll_dig.COARSE_MUX_D[8] ),
    .C1(net73),
    .B1(net90),
    .A1(\pll_dig.COARSE_MUX_D[10] ),
    .Y(_1757_),
    .A2(net84));
 sg13g2_a21oi_1 _2805_ (.A1(_0545_),
    .A2(net73),
    .Y(_0290_),
    .B1(_1757_));
 sg13g2_nand2_1 _2806_ (.Y(_1758_),
    .A(\pll_dig.flock.cnt_done[5] ),
    .B(_1101_));
 sg13g2_o21ai_1 _2807_ (.B1(\pll_dig.flock.cnt_done[5] ),
    .Y(_1759_),
    .A1(_1136_),
    .A2(_1138_));
 sg13g2_xnor2_1 _2808_ (.Y(_0110_),
    .A(\pll_dig.div.div_pend[7] ),
    .B(_0624_));
 sg13g2_nor2_1 _2809_ (.A(\pll_dig.flock.cnt_done[7] ),
    .B(\pll_dig.flock.cnt_done[6] ),
    .Y(_1760_));
 sg13g2_nand2b_1 _2810_ (.Y(_1761_),
    .B(_1139_),
    .A_N(_1760_));
 sg13g2_nand2_1 _2811_ (.Y(_1762_),
    .A(_1759_),
    .B(_1761_));
 sg13g2_xnor2_1 _2812_ (.Y(_1763_),
    .A(\pll_dig.flock.cnt_done[5] ),
    .B(_1722_));
 sg13g2_a21oi_1 _2813_ (.A1(net81),
    .A2(_1763_),
    .Y(_1764_),
    .B1(_1099_));
 sg13g2_o21ai_1 _2814_ (.B1(_1764_),
    .Y(_1765_),
    .A1(net81),
    .A2(_1762_));
 sg13g2_nand2_1 _2815_ (.Y(_0026_),
    .A(_1758_),
    .B(_1765_));
 sg13g2_nand2_1 _2816_ (.Y(_1766_),
    .A(net162),
    .B(_1406_));
 sg13g2_a21oi_1 _2817_ (.A1(_1376_),
    .A2(_1405_),
    .Y(_0083_),
    .B1(_1766_));
 sg13g2_o21ai_1 _2818_ (.B1(_1595_),
    .Y(_0012_),
    .A1(_1099_),
    .A2(_1760_));
 sg13g2_xor2_1 _2819_ (.B(_0622_),
    .A(\pll_dig.div.div_pend[4] ),
    .X(_0107_));
 sg13g2_nand3_1 _2820_ (.B(_1255_),
    .C(_1353_),
    .A(_1249_),
    .Y(_1767_));
 sg13g2_a21oi_1 _2821_ (.A1(\pll_dig.COARSE_MUX_D[0] ),
    .A2(\pll_dig.COARSE_MUX_D[1] ),
    .Y(_1768_),
    .B1(_1256_));
 sg13g2_a22oi_1 _2822_ (.Y(_0289_),
    .B1(_1768_),
    .B2(net92),
    .A2(_1767_),
    .A1(_0506_));
 sg13g2_o21ai_1 _2823_ (.B1(net93),
    .Y(_1769_),
    .A1(\pll_dig.MID_MUX_D[0] ),
    .A2(_1244_));
 sg13g2_inv_1 _2824_ (.Y(_1770_),
    .A(_1769_));
 sg13g2_o21ai_1 _2825_ (.B1(\pll_dig.MID_MUX_D[0] ),
    .Y(_1771_),
    .A1(\pll_dig.MID_MUX_D[1] ),
    .A2(_1250_));
 sg13g2_o21ai_1 _2826_ (.B1(_1771_),
    .Y(_0288_),
    .A1(_1250_),
    .A2(_1770_));
 sg13g2_a21oi_1 _2827_ (.A1(_0593_),
    .A2(_1531_),
    .Y(_0287_),
    .B1(_1524_));
 sg13g2_and3_1 _2828_ (.X(_1772_),
    .A(_0936_),
    .B(_0959_),
    .C(_0960_));
 sg13g2_nor3_1 _2829_ (.A(net111),
    .B(_0961_),
    .C(_1772_),
    .Y(_1773_));
 sg13g2_mux2_1 _2830_ (.A0(\pll_dig.div.hi_cur[7] ),
    .A1(\pll_dig.div.hi_pend[7] ),
    .S(net151),
    .X(\pll_dig.div.high_count_pend[7] ));
 sg13g2_a21o_1 _2831_ (.A2(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .A1(net111),
    .B1(_1773_),
    .X(_0286_));
 sg13g2_a221oi_1 _2832_ (.B2(\pll_dig.COARSE_MUX_D[3] ),
    .C1(net74),
    .B1(net91),
    .A1(\pll_dig.COARSE_MUX_D[5] ),
    .Y(_1774_),
    .A2(net85));
 sg13g2_a21oi_1 _2833_ (.A1(_0584_),
    .A2(net74),
    .Y(_0285_),
    .B1(_1774_));
 sg13g2_nor2b_2 _2834_ (.A(net159),
    .B_N(net410),
    .Y(_1775_));
 sg13g2_nand2b_2 _2835_ (.Y(_1776_),
    .B(_1775_),
    .A_N(net158));
 sg13g2_nor3_2 _2836_ (.A(net154),
    .B(net156),
    .C(_1776_),
    .Y(_1777_));
 sg13g2_nor2b_2 _2837_ (.A(net153),
    .B_N(_1777_),
    .Y(_1778_));
 sg13g2_xnor2_1 _2838_ (.Y(_1779_),
    .A(\pll_dig.div.div[7] ),
    .B(_1778_));
 sg13g2_nor2_1 _2839_ (.A(\pll_dig.div.ncnt[6] ),
    .B(_1779_),
    .Y(_1780_));
 sg13g2_xnor2_1 _2840_ (.Y(_1781_),
    .A(net153),
    .B(_1777_));
 sg13g2_mux2_1 _2841_ (.A0(\pll_dig.div.hi_cur[4] ),
    .A1(\pll_dig.div.hi_pend[4] ),
    .S(net151),
    .X(\pll_dig.div.high_count_pend[4] ));
 sg13g2_nand2_1 _2842_ (.Y(_1782_),
    .A(\pll_dig.div.ncnt[5] ),
    .B(_1781_));
 sg13g2_xnor2_1 _2843_ (.Y(_1783_),
    .A(net158),
    .B(_1775_));
 sg13g2_xnor2_1 _2844_ (.Y(_1784_),
    .A(net159),
    .B(net410));
 sg13g2_nor2b_2 _2845_ (.A(net406),
    .B_N(net405),
    .Y(_1785_));
 sg13g2_or2_1 _2846_ (.X(_1786_),
    .B(_1785_),
    .A(net410));
 sg13g2_nand2b_1 _2847_ (.Y(_1787_),
    .B(_1786_),
    .A_N(\pll_dig.div.ncnt[0] ));
 sg13g2_o21ai_1 _2848_ (.B1(_1787_),
    .Y(_1788_),
    .A1(_1784_),
    .A2(\pll_dig.div.ncnt[1] ));
 sg13g2_a22oi_1 _2849_ (.Y(_1789_),
    .B1(_1784_),
    .B2(\pll_dig.div.ncnt[1] ),
    .A2(_1783_),
    .A1(\pll_dig.div.ncnt[2] ));
 sg13g2_xor2_1 _2850_ (.B(_1776_),
    .A(net156),
    .X(_1790_));
 sg13g2_nor2_1 _2851_ (.A(\pll_dig.div.ncnt[3] ),
    .B(_1790_),
    .Y(_1791_));
 sg13g2_and2_1 _2852_ (.A(\pll_dig.div.ncnt[1] ),
    .B(net437),
    .X(_0626_));
 sg13g2_a21oi_2 _2853_ (.B1(_1791_),
    .Y(_1792_),
    .A2(_1789_),
    .A1(_1788_));
 sg13g2_o21ai_1 _2854_ (.B1(_1792_),
    .Y(_1793_),
    .A1(\pll_dig.div.ncnt[2] ),
    .A2(_1783_));
 sg13g2_o21ai_1 _2855_ (.B1(net154),
    .Y(_1794_),
    .A1(net156),
    .A2(_1776_));
 sg13g2_nor2b_1 _2856_ (.A(_1777_),
    .B_N(_1794_),
    .Y(_1795_));
 sg13g2_a22oi_1 _2857_ (.Y(_1796_),
    .B1(_1795_),
    .B2(\pll_dig.div.ncnt[4] ),
    .A2(_1790_),
    .A1(\pll_dig.div.ncnt[3] ));
 sg13g2_nor2_1 _2858_ (.A(\pll_dig.div.ncnt[5] ),
    .B(_1781_),
    .Y(_1797_));
 sg13g2_a21oi_2 _2859_ (.B1(_1797_),
    .Y(_1798_),
    .A2(_1793_),
    .A1(_1796_));
 sg13g2_o21ai_1 _2860_ (.B1(_1798_),
    .Y(_1799_),
    .A1(\pll_dig.div.ncnt[4] ),
    .A2(_1795_));
 sg13g2_a21oi_2 _2861_ (.B1(_1780_),
    .Y(_1800_),
    .A2(_1782_),
    .A1(_1799_));
 sg13g2_and2_1 _2862_ (.A(\pll_dig.div.ncnt[6] ),
    .B(_1779_),
    .X(_1801_));
 sg13g2_nand2_1 _2863_ (.Y(_0627_),
    .A(\pll_dig.div.ncnt[2] ),
    .B(_0626_));
 sg13g2_nor4_2 _2864_ (.A(\pll_dig.div.ncnt[7] ),
    .B(net409),
    .C(_1801_),
    .Y(_0112_),
    .D(_1800_));
 sg13g2_nor2_2 _2865_ (.A(net401),
    .B(net441),
    .Y(_0090_));
 sg13g2_nor2_2 _2866_ (.A(net435),
    .B(net441),
    .Y(_0091_));
 sg13g2_nor2_2 _2867_ (.A(net436),
    .B(net441),
    .Y(_0092_));
 sg13g2_nor2_2 _2868_ (.A(net390),
    .B(net441),
    .Y(_0093_));
 sg13g2_nor2_2 _2869_ (.A(net392),
    .B(net83),
    .Y(_0094_));
 sg13g2_nor2_2 _2870_ (.A(net397),
    .B(net441),
    .Y(_0095_));
 sg13g2_nor2_1 _2871_ (.A(net387),
    .B(net439),
    .Y(_0096_));
 sg13g2_nor2_1 _2872_ (.A(net389),
    .B(net439),
    .Y(_0097_));
 sg13g2_or2_1 _2873_ (.X(_1802_),
    .B(_1795_),
    .A(\pll_dig.div.pcnt[4] ));
 sg13g2_nor2_1 _2874_ (.A(_0480_),
    .B(_0627_),
    .Y(_0628_));
 sg13g2_nor2_1 _2875_ (.A(net474),
    .B(_1784_),
    .Y(_1803_));
 sg13g2_a21oi_1 _2876_ (.A1(_0526_),
    .A2(_1786_),
    .Y(_1804_),
    .B1(_1803_));
 sg13g2_a221oi_1 _2877_ (.B2(net474),
    .C1(_1804_),
    .B1(_1784_),
    .A1(net476),
    .Y(_1805_),
    .A2(_1783_));
 sg13g2_or2_1 _2878_ (.X(_1806_),
    .B(_1783_),
    .A(net476));
 sg13g2_o21ai_1 _2879_ (.B1(_1806_),
    .Y(_1807_),
    .A1(\pll_dig.div.pcnt[3] ),
    .A2(_1790_));
 sg13g2_a22oi_1 _2880_ (.Y(_1808_),
    .B1(_1795_),
    .B2(\pll_dig.div.pcnt[4] ),
    .A2(_1790_),
    .A1(\pll_dig.div.pcnt[3] ));
 sg13g2_o21ai_1 _2881_ (.B1(_1808_),
    .Y(_1809_),
    .A1(_1805_),
    .A2(_1807_));
 sg13g2_a22oi_1 _2882_ (.Y(_1810_),
    .B1(_1802_),
    .B2(_1809_),
    .A2(_1781_),
    .A1(\pll_dig.div.pcnt[5] ));
 sg13g2_or2_1 _2883_ (.X(_1811_),
    .B(_1781_),
    .A(\pll_dig.div.pcnt[5] ));
 sg13g2_o21ai_1 _2884_ (.B1(_1811_),
    .Y(_1812_),
    .A1(\pll_dig.div.pcnt[6] ),
    .A2(_1779_));
 sg13g2_inv_1 _2885_ (.Y(_0495_),
    .A(\SS_BBPD[0] ));
 sg13g2_nand3_1 _2886_ (.B(\pll_dig.div.ncnt[4] ),
    .C(_0628_),
    .A(\pll_dig.div.ncnt[5] ),
    .Y(_0629_));
 sg13g2_nand2_1 _2887_ (.Y(_1813_),
    .A(\pll_dig.div.pcnt[6] ),
    .B(_1779_));
 sg13g2_o21ai_1 _2888_ (.B1(_1813_),
    .Y(_1814_),
    .A1(_1810_),
    .A2(_1812_));
 sg13g2_nor3_1 _2889_ (.A(\pll_dig.div.pcnt[7] ),
    .B(net409),
    .C(_1814_),
    .Y(_0113_));
 sg13g2_nor3_1 _2890_ (.A(_0169_),
    .B(_0586_),
    .C(_0051_),
    .Y(_0122_));
 sg13g2_xor2_1 _2891_ (.B(_1785_),
    .A(net159),
    .X(_0098_));
 sg13g2_and3_1 _2892_ (.X(_1815_),
    .A(net160),
    .B(net158),
    .C(_1785_));
 sg13g2_a21oi_1 _2893_ (.A1(net160),
    .A2(_1785_),
    .Y(_1816_),
    .B1(net413));
 sg13g2_nor2_1 _2894_ (.A(_1815_),
    .B(_1816_),
    .Y(_0099_));
 sg13g2_xor2_1 _2895_ (.B(_1815_),
    .A(net157),
    .X(_0100_));
 sg13g2_nand3_1 _2896_ (.B(net157),
    .C(_1815_),
    .A(net154),
    .Y(_1817_));
 sg13g2_nand4_1 _2897_ (.B(\pll_dig.div.ncnt[5] ),
    .C(\pll_dig.div.ncnt[4] ),
    .A(\pll_dig.div.ncnt[6] ),
    .Y(_0630_),
    .D(_0628_));
 sg13g2_a21o_1 _2898_ (.A2(_1815_),
    .A1(net157),
    .B1(net155),
    .X(_1818_));
 sg13g2_and2_1 _2899_ (.A(_1817_),
    .B(_1818_),
    .X(_0101_));
 sg13g2_nand4_1 _2900_ (.B(net157),
    .C(net153),
    .A(net155),
    .Y(_1819_),
    .D(_1815_));
 sg13g2_xnor2_1 _2901_ (.Y(_0102_),
    .A(net153),
    .B(_1817_));
 sg13g2_nor2_1 _2902_ (.A(_0502_),
    .B(_1819_),
    .Y(_0104_));
 sg13g2_xnor2_1 _2903_ (.Y(_0103_),
    .A(\pll_dig.div.div[7] ),
    .B(_1819_));
 sg13g2_mux2_1 _2904_ (.A0(\pll_dig.div.lo_cur[1] ),
    .A1(\pll_dig.div.lo_pend[1] ),
    .S(net152),
    .X(\pll_dig.div.low_count_pend[1] ));
 sg13g2_mux2_1 _2905_ (.A0(\pll_dig.div.lo_cur[2] ),
    .A1(\pll_dig.div.lo_pend[2] ),
    .S(net152),
    .X(\pll_dig.div.low_count_pend[2] ));
 sg13g2_mux2_1 _2906_ (.A0(\pll_dig.div.lo_cur[3] ),
    .A1(\pll_dig.div.lo_pend[3] ),
    .S(net151),
    .X(\pll_dig.div.low_count_pend[3] ));
 sg13g2_mux2_1 _2907_ (.A0(\pll_dig.div.lo_cur[4] ),
    .A1(\pll_dig.div.lo_pend[4] ),
    .S(net151),
    .X(\pll_dig.div.low_count_pend[4] ));
 sg13g2_xor2_1 _2908_ (.B(_0630_),
    .A(\pll_dig.div.ncnt[7] ),
    .X(_0631_));
 sg13g2_mux2_1 _2909_ (.A0(\pll_dig.div.lo_cur[5] ),
    .A1(\pll_dig.div.lo_pend[5] ),
    .S(net151),
    .X(\pll_dig.div.low_count_pend[5] ));
 sg13g2_mux2_1 _2910_ (.A0(\pll_dig.div.lo_cur[6] ),
    .A1(\pll_dig.div.lo_pend[6] ),
    .S(net151),
    .X(\pll_dig.div.low_count_pend[6] ));
 sg13g2_nand2_2 _2911_ (.Y(_1820_),
    .A(net478),
    .B(net479));
 sg13g2_nand3_1 _2912_ (.B(\pll_dig.div.pcnt[2] ),
    .C(\pll_dig.div.pcnt[0] ),
    .A(\pll_dig.div.pcnt[1] ),
    .Y(_1821_));
 sg13g2_nor2_2 _2913_ (.A(_1821_),
    .B(_0620_),
    .Y(_1822_));
 sg13g2_xnor2_1 _2914_ (.Y(_1823_),
    .A(_1822_),
    .B(\pll_dig.div.pcnt[4] ));
 sg13g2_nand2_1 _2915_ (.Y(_1824_),
    .A(net156),
    .B(net470));
 sg13g2_xor2_1 _2916_ (.B(_1820_),
    .A(net476),
    .X(_1825_));
 sg13g2_nor2_1 _2917_ (.A(net407),
    .B(net474),
    .Y(_1826_));
 sg13g2_o21ai_1 _2918_ (.B1(_1826_),
    .Y(_1827_),
    .A1(net404),
    .A2(_0526_));
 sg13g2_xnor2_1 _2919_ (.Y(_0632_),
    .A(\pll_dig.div.ncnt[4] ),
    .B(_0628_));
 sg13g2_a21oi_1 _2920_ (.A1(_1820_),
    .A2(_1827_),
    .Y(_1828_),
    .B1(net410));
 sg13g2_o21ai_1 _2921_ (.B1(_1828_),
    .Y(_1829_),
    .A1(net159),
    .A2(_1825_));
 sg13g2_xnor2_1 _2922_ (.Y(_1830_),
    .A(_0620_),
    .B(net469));
 sg13g2_a22oi_1 _2923_ (.Y(_1831_),
    .B1(net158),
    .B2(_1830_),
    .A2(_1825_),
    .A1(net159));
 sg13g2_nor2_2 _2924_ (.A(_1823_),
    .B(net156),
    .Y(_1832_));
 sg13g2_a21oi_2 _2925_ (.B1(_1832_),
    .Y(_1833_),
    .A2(_1829_),
    .A1(_1831_));
 sg13g2_o21ai_1 _2926_ (.B1(_1833_),
    .Y(_1834_),
    .A1(net158),
    .A2(net471));
 sg13g2_nand3_1 _2927_ (.B(\pll_dig.div.pcnt[4] ),
    .C(_1822_),
    .A(\pll_dig.div.pcnt[5] ),
    .Y(_1835_));
 sg13g2_a21o_1 _2928_ (.A2(_1822_),
    .A1(\pll_dig.div.pcnt[4] ),
    .B1(\pll_dig.div.pcnt[5] ),
    .X(_1836_));
 sg13g2_nand2_1 _2929_ (.Y(_1837_),
    .A(_1835_),
    .B(_1836_));
 sg13g2_xnor2_1 _2930_ (.Y(_0633_),
    .A(\pll_dig.div.ncnt[2] ),
    .B(_0626_));
 sg13g2_nor2_1 _2931_ (.A(net154),
    .B(_1837_),
    .Y(_1838_));
 sg13g2_a21oi_2 _2932_ (.B1(_1838_),
    .Y(_1839_),
    .A2(_1824_),
    .A1(_1834_));
 sg13g2_nand4_1 _2933_ (.B(\pll_dig.div.pcnt[5] ),
    .C(\pll_dig.div.pcnt[4] ),
    .A(\pll_dig.div.pcnt[6] ),
    .Y(_1840_),
    .D(_1822_));
 sg13g2_xor2_1 _2934_ (.B(_1835_),
    .A(\pll_dig.div.pcnt[6] ),
    .X(_1841_));
 sg13g2_a221oi_1 _2935_ (.B2(net153),
    .C1(_1839_),
    .B1(_1841_),
    .A1(net154),
    .Y(_1842_),
    .A2(_1837_));
 sg13g2_nor2_1 _2936_ (.A(net153),
    .B(_1841_),
    .Y(_1843_));
 sg13g2_xor2_1 _2937_ (.B(_1840_),
    .A(\pll_dig.div.pcnt[7] ),
    .X(_1844_));
 sg13g2_nor2_1 _2938_ (.A(\pll_dig.div.div[7] ),
    .B(_1844_),
    .Y(_1845_));
 sg13g2_nor4_2 _2939_ (.A(net409),
    .B(_1845_),
    .C(_1843_),
    .Y(_1846_),
    .D(_1842_));
 sg13g2_a21oi_2 _2940_ (.B1(_1846_),
    .Y(_1847_),
    .A2(_1844_),
    .A1(_0659_));
 sg13g2_nor2b_2 _2941_ (.A(net411),
    .B_N(_0168_),
    .Y(_0634_));
 sg13g2_nor2_2 _2942_ (.A(net472),
    .B(net477),
    .Y(_0114_));
 sg13g2_xnor2_1 _2943_ (.Y(_1848_),
    .A(net472),
    .B(net475));
 sg13g2_nor2_2 _2944_ (.A(_1848_),
    .B(net477),
    .Y(_0115_));
 sg13g2_nor2_2 _2945_ (.A(_1825_),
    .B(net477),
    .Y(_0116_));
 sg13g2_nor2_2 _2946_ (.A(net477),
    .B(net471),
    .Y(_0117_));
 sg13g2_nor2_2 _2947_ (.A(net470),
    .B(net477),
    .Y(_0118_));
 sg13g2_nor2_2 _2948_ (.A(_1837_),
    .B(net477),
    .Y(_0119_));
 sg13g2_nor2_2 _2949_ (.A(_1841_),
    .B(net477),
    .Y(_0120_));
 sg13g2_nor2b_1 _2950_ (.A(_1844_),
    .B_N(_1846_),
    .Y(_0121_));
 sg13g2_mux2_1 _2951_ (.A0(\pll_dig.div.hi_cur[1] ),
    .A1(\pll_dig.div.hi_pend[1] ),
    .S(net152),
    .X(\pll_dig.div.high_count_pend[1] ));
 sg13g2_nand2b_1 _2952_ (.Y(_0635_),
    .B(net437),
    .A_N(\pll_dig.div.div[0] ));
 sg13g2_xor2_1 _2953_ (.B(_0621_),
    .A(\pll_dig.div.div_pend[2] ),
    .X(_0105_));
 sg13g2_mux2_1 _2954_ (.A0(\pll_dig.div.hi_cur[2] ),
    .A1(\pll_dig.div.hi_pend[2] ),
    .S(net152),
    .X(\pll_dig.div.high_count_pend[2] ));
 sg13g2_a21oi_1 _2955_ (.A1(\pll_dig.div.div_pend[2] ),
    .A2(_0621_),
    .Y(_1849_),
    .B1(\pll_dig.div.div_pend[3] ));
 sg13g2_nor2_1 _2956_ (.A(_0622_),
    .B(_1849_),
    .Y(_0106_));
 sg13g2_mux2_1 _2957_ (.A0(\pll_dig.div.hi_cur[3] ),
    .A1(\pll_dig.div.hi_pend[3] ),
    .S(net152),
    .X(\pll_dig.div.high_count_pend[3] ));
 sg13g2_a21oi_1 _2958_ (.A1(net587),
    .A2(_1599_),
    .Y(_1850_),
    .B1(_1687_));
 sg13g2_and2_1 _2959_ (.A(net660),
    .B(_1850_),
    .X(_1851_));
 sg13g2_and3_1 _2960_ (.X(_1852_),
    .A(net654),
    .B(net603),
    .C(_1851_));
 sg13g2_nand4_1 _2961_ (.B(net654),
    .C(net660),
    .A(net633),
    .Y(_1853_),
    .D(net603));
 sg13g2_nand3_1 _2962_ (.B(net633),
    .C(_1852_),
    .A(net648),
    .Y(_1854_));
 sg13g2_nor2_2 _2963_ (.A(net438),
    .B(_0168_),
    .Y(_0636_));
 sg13g2_nor2_1 _2964_ (.A(_0581_),
    .B(_1854_),
    .Y(_1855_));
 sg13g2_nand2_1 _2965_ (.Y(_1856_),
    .A(net608),
    .B(_1855_));
 sg13g2_nor3_1 _2966_ (.A(net611),
    .B(net614),
    .C(_1663_),
    .Y(_1857_));
 sg13g2_nor2_1 _2967_ (.A(net633),
    .B(_1600_),
    .Y(_1858_));
 sg13g2_nand2b_1 _2968_ (.Y(_1859_),
    .B(_1850_),
    .A_N(_1858_));
 sg13g2_nor2_1 _2969_ (.A(_1857_),
    .B(_1859_),
    .Y(_1860_));
 sg13g2_o21ai_1 _2970_ (.B1(net609),
    .Y(_1861_),
    .A1(_1857_),
    .A2(_1859_));
 sg13g2_o21ai_1 _2971_ (.B1(_0507_),
    .Y(_1862_),
    .A1(_1857_),
    .A2(_1858_));
 sg13g2_a22oi_1 _2972_ (.Y(_0324_),
    .B1(_1861_),
    .B2(_1862_),
    .A2(net609),
    .A1(_0507_));
 sg13g2_nor2_1 _2973_ (.A(\SS_BBPD[1] ),
    .B(net115),
    .Y(_1863_));
 sg13g2_a21oi_2 _2974_ (.B1(_0626_),
    .Y(_0637_),
    .A2(_0636_),
    .A1(_0635_));
 sg13g2_nor2_1 _2975_ (.A(net20),
    .B(net119),
    .Y(_1864_));
 sg13g2_nand2b_1 _2976_ (.Y(_1865_),
    .B(net658),
    .A_N(net19));
 sg13g2_xnor2_1 _2977_ (.Y(_1866_),
    .A(net691),
    .B(net19));
 sg13g2_inv_1 _2978_ (.Y(_1867_),
    .A(_1866_));
 sg13g2_nand2_1 _2979_ (.Y(_1868_),
    .A(_0568_),
    .B(net18));
 sg13g2_nor2_1 _2980_ (.A(_0568_),
    .B(net18),
    .Y(_1869_));
 sg13g2_xnor2_1 _2981_ (.Y(_1870_),
    .A(\pll_dig.dlf.INT[12] ),
    .B(net17));
 sg13g2_nor2b_1 _2982_ (.A(\pll_dig.dlf.INT[11] ),
    .B_N(net16),
    .Y(_1871_));
 sg13g2_nand2b_1 _2983_ (.Y(_1872_),
    .B(net693),
    .A_N(net16));
 sg13g2_nor2_1 _2984_ (.A(_0573_),
    .B(net15),
    .Y(_1873_));
 sg13g2_nor2_2 _2985_ (.A(_0634_),
    .B(_0637_),
    .Y(_0638_));
 sg13g2_xnor2_1 _2986_ (.Y(_1874_),
    .A(\pll_dig.dlf.INT[10] ),
    .B(net15));
 sg13g2_nand2b_1 _2987_ (.Y(_1875_),
    .B(net121),
    .A_N(net29));
 sg13g2_nor2b_1 _2988_ (.A(net121),
    .B_N(net29),
    .Y(_1876_));
 sg13g2_xor2_1 _2989_ (.B(net28),
    .A(net122),
    .X(_1877_));
 sg13g2_xnor2_1 _2990_ (.Y(_1878_),
    .A(net122),
    .B(net28));
 sg13g2_nand2_1 _2991_ (.Y(_1879_),
    .A(_0571_),
    .B(net27));
 sg13g2_nor2_1 _2992_ (.A(_0571_),
    .B(net27),
    .Y(_1880_));
 sg13g2_xnor2_1 _2993_ (.Y(_1881_),
    .A(\pll_dig.dlf.INT[6] ),
    .B(net26));
 sg13g2_nand2_1 _2994_ (.Y(_1882_),
    .A(net670),
    .B(net25));
 sg13g2_xnor2_1 _2995_ (.Y(_1883_),
    .A(\pll_dig.dlf.INT[5] ),
    .B(net25));
 sg13g2_inv_1 _2996_ (.Y(_0496_),
    .A(\SS_BBPD[1] ));
 sg13g2_o21ai_1 _2997_ (.B1(_0638_),
    .Y(_0639_),
    .A1(net159),
    .A2(_0633_));
 sg13g2_nand2b_1 _2998_ (.Y(_1884_),
    .B(\pll_dig.dlf.INT[4] ),
    .A_N(net24));
 sg13g2_nand2_1 _2999_ (.Y(_1885_),
    .A(net673),
    .B(net24));
 sg13g2_xor2_1 _3000_ (.B(net24),
    .A(\pll_dig.dlf.INT[4] ),
    .X(_1886_));
 sg13g2_nor2_1 _3001_ (.A(_0576_),
    .B(net23),
    .Y(_1887_));
 sg13g2_and2_1 _3002_ (.A(net676),
    .B(net23),
    .X(_1888_));
 sg13g2_xnor2_1 _3003_ (.Y(_1889_),
    .A(\pll_dig.dlf.INT[3] ),
    .B(net23));
 sg13g2_nor2_1 _3004_ (.A(_0524_),
    .B(net22),
    .Y(_1890_));
 sg13g2_nand2_1 _3005_ (.Y(_1891_),
    .A(net682),
    .B(net22));
 sg13g2_xor2_1 _3006_ (.B(net22),
    .A(net687),
    .X(_1892_));
 sg13g2_nand2b_1 _3007_ (.Y(_1893_),
    .B(net684),
    .A_N(net21));
 sg13g2_xnor2_1 _3008_ (.Y(_0640_),
    .A(_0480_),
    .B(_0627_));
 sg13g2_xnor2_1 _3009_ (.Y(_1894_),
    .A(\pll_dig.dlf.INT[1] ),
    .B(net21));
 sg13g2_nand2b_1 _3010_ (.Y(_1895_),
    .B(net14),
    .A_N(net686));
 sg13g2_nand2_1 _3011_ (.Y(_1896_),
    .A(_1894_),
    .B(_1895_));
 sg13g2_a21oi_1 _3012_ (.A1(_1893_),
    .A2(_1896_),
    .Y(_1897_),
    .B1(_1892_));
 sg13g2_or2_1 _3013_ (.X(_1898_),
    .B(_1897_),
    .A(_1890_));
 sg13g2_a21oi_1 _3014_ (.A1(_1889_),
    .A2(_1898_),
    .Y(_1899_),
    .B1(_1887_));
 sg13g2_o21ai_1 _3015_ (.B1(_1884_),
    .Y(_1900_),
    .A1(_1886_),
    .A2(_1899_));
 sg13g2_and2_1 _3016_ (.A(_1883_),
    .B(_1900_),
    .X(_1901_));
 sg13g2_nor2_1 _3017_ (.A(_0500_),
    .B(net25),
    .Y(_1902_));
 sg13g2_o21ai_1 _3018_ (.B1(_1881_),
    .Y(_1903_),
    .A1(_1901_),
    .A2(_1902_));
 sg13g2_a22oi_1 _3019_ (.Y(_0641_),
    .B1(_0640_),
    .B2(net158),
    .A2(_0633_),
    .A1(net159));
 sg13g2_o21ai_1 _3020_ (.B1(_1903_),
    .Y(_1904_),
    .A1(_0575_),
    .A2(net26));
 sg13g2_a21oi_1 _3021_ (.A1(_1879_),
    .A2(_1904_),
    .Y(_1905_),
    .B1(_1880_));
 sg13g2_nor2_1 _3022_ (.A(_1877_),
    .B(_1905_),
    .Y(_1906_));
 sg13g2_a21oi_1 _3023_ (.A1(net122),
    .A2(_0610_),
    .Y(_1907_),
    .B1(_1906_));
 sg13g2_a21oi_1 _3024_ (.A1(_1875_),
    .A2(_1907_),
    .Y(_1908_),
    .B1(_1876_));
 sg13g2_a21oi_1 _3025_ (.A1(_1874_),
    .A2(_1908_),
    .Y(_1909_),
    .B1(_1873_));
 sg13g2_o21ai_1 _3026_ (.B1(_1872_),
    .Y(_1910_),
    .A1(_1871_),
    .A2(_1909_));
 sg13g2_nand2_1 _3027_ (.Y(_1911_),
    .A(_1870_),
    .B(_1910_));
 sg13g2_o21ai_1 _3028_ (.B1(_1911_),
    .Y(_1912_),
    .A1(_0569_),
    .A2(net17));
 sg13g2_a21oi_1 _3029_ (.A1(_1868_),
    .A2(_1912_),
    .Y(_1913_),
    .B1(_1869_));
 sg13g2_or2_1 _3030_ (.X(_0642_),
    .B(_0640_),
    .A(net158));
 sg13g2_o21ai_1 _3031_ (.B1(_1865_),
    .Y(_1914_),
    .A1(_1867_),
    .A2(_1913_));
 sg13g2_nor2_1 _3032_ (.A(_1864_),
    .B(_1914_),
    .Y(_1915_));
 sg13g2_a21oi_1 _3033_ (.A1(net20),
    .A2(net119),
    .Y(_1916_),
    .B1(_1915_));
 sg13g2_nand2_1 _3034_ (.Y(_1917_),
    .A(net101),
    .B(_1916_));
 sg13g2_nor2_1 _3035_ (.A(_1883_),
    .B(_1900_),
    .Y(_1918_));
 sg13g2_nor3_1 _3036_ (.A(_1901_),
    .B(net67),
    .C(_1918_),
    .Y(_1919_));
 sg13g2_nand2b_1 _3037_ (.Y(_1920_),
    .B(net20),
    .A_N(net119));
 sg13g2_nand2_1 _3038_ (.Y(_1921_),
    .A(net120),
    .B(net18));
 sg13g2_nand2b_1 _3039_ (.Y(_1922_),
    .B(_1872_),
    .A_N(_1871_));
 sg13g2_inv_1 _3040_ (.Y(_1923_),
    .A(_1922_));
 sg13g2_o21ai_1 _3041_ (.B1(_0642_),
    .Y(_0643_),
    .A1(net156),
    .A2(_0632_));
 sg13g2_xor2_1 _3042_ (.B(net29),
    .A(net121),
    .X(_1924_));
 sg13g2_inv_1 _3043_ (.Y(_1925_),
    .A(_1924_));
 sg13g2_xnor2_1 _3044_ (.Y(_1926_),
    .A(\pll_dig.dlf.INT[7] ),
    .B(net27));
 sg13g2_and2_1 _3045_ (.A(net684),
    .B(net21),
    .X(_1927_));
 sg13g2_nand2_1 _3046_ (.Y(_1928_),
    .A(net686),
    .B(net14));
 sg13g2_nor2_1 _3047_ (.A(_1894_),
    .B(_1928_),
    .Y(_1929_));
 sg13g2_o21ai_1 _3048_ (.B1(_1892_),
    .Y(_1930_),
    .A1(_1927_),
    .A2(_1929_));
 sg13g2_a21oi_1 _3049_ (.A1(_1891_),
    .A2(_1930_),
    .Y(_1931_),
    .B1(_1889_));
 sg13g2_o21ai_1 _3050_ (.B1(_1886_),
    .Y(_1932_),
    .A1(_1888_),
    .A2(_1931_));
 sg13g2_a21o_1 _3051_ (.A2(_1932_),
    .A1(_1885_),
    .B1(_1883_),
    .X(_1933_));
 sg13g2_a21oi_2 _3052_ (.B1(_0643_),
    .Y(_0644_),
    .A2(_0641_),
    .A1(_0639_));
 sg13g2_a21oi_1 _3053_ (.A1(_1882_),
    .A2(_1933_),
    .Y(_1934_),
    .B1(_1881_));
 sg13g2_a21oi_1 _3054_ (.A1(net667),
    .A2(net26),
    .Y(_1935_),
    .B1(_1934_));
 sg13g2_nor2_1 _3055_ (.A(_1926_),
    .B(_1935_),
    .Y(_1936_));
 sg13g2_a21oi_1 _3056_ (.A1(net678),
    .A2(net27),
    .Y(_1937_),
    .B1(_1936_));
 sg13g2_nor2_1 _3057_ (.A(_1878_),
    .B(_1937_),
    .Y(_1938_));
 sg13g2_a21oi_1 _3058_ (.A1(net122),
    .A2(net28),
    .Y(_1939_),
    .B1(_1938_));
 sg13g2_nor2_1 _3059_ (.A(_1925_),
    .B(_1939_),
    .Y(_1940_));
 sg13g2_a21oi_1 _3060_ (.A1(net121),
    .A2(net29),
    .Y(_1941_),
    .B1(_1940_));
 sg13g2_nor2_1 _3061_ (.A(_1874_),
    .B(_1941_),
    .Y(_1942_));
 sg13g2_a21oi_1 _3062_ (.A1(net661),
    .A2(net15),
    .Y(_1943_),
    .B1(_1942_));
 sg13g2_a21oi_2 _3063_ (.B1(_0644_),
    .Y(_0645_),
    .A2(_0632_),
    .A1(net156));
 sg13g2_nor2_1 _3064_ (.A(_1923_),
    .B(_1943_),
    .Y(_1944_));
 sg13g2_a21oi_1 _3065_ (.A1(net680),
    .A2(net16),
    .Y(_1945_),
    .B1(_1944_));
 sg13g2_or2_1 _3066_ (.X(_1946_),
    .B(_1945_),
    .A(_1870_));
 sg13g2_o21ai_1 _3067_ (.B1(_1946_),
    .Y(_1947_),
    .A1(_0569_),
    .A2(_0570_));
 sg13g2_o21ai_1 _3068_ (.B1(_1947_),
    .Y(_1948_),
    .A1(net120),
    .A2(net18));
 sg13g2_a21oi_1 _3069_ (.A1(_1921_),
    .A2(_1948_),
    .Y(_1949_),
    .B1(_1866_));
 sg13g2_a21oi_1 _3070_ (.A1(net658),
    .A2(net19),
    .Y(_1950_),
    .B1(_1949_));
 sg13g2_nor2b_1 _3071_ (.A(net20),
    .B_N(net119),
    .Y(_1951_));
 sg13g2_or2_1 _3072_ (.X(_1952_),
    .B(_1951_),
    .A(net101));
 sg13g2_a21oi_1 _3073_ (.A1(_1920_),
    .A2(_1950_),
    .Y(_1953_),
    .B1(_1952_));
 sg13g2_a21o_1 _3074_ (.A2(_0628_),
    .A1(\pll_dig.div.ncnt[4] ),
    .B1(\pll_dig.div.ncnt[5] ),
    .X(_0646_));
 sg13g2_nor2_1 _3075_ (.A(net115),
    .B(_1953_),
    .Y(_1954_));
 sg13g2_nand3_1 _3076_ (.B(_1885_),
    .C(_1932_),
    .A(_1883_),
    .Y(_1955_));
 sg13g2_nand3_1 _3077_ (.B(_1933_),
    .C(_1955_),
    .A(\SS_BBPD[1] ),
    .Y(_1956_));
 sg13g2_nor3_1 _3078_ (.A(net117),
    .B(_1919_),
    .C(_1953_),
    .Y(_1957_));
 sg13g2_a22oi_1 _3079_ (.Y(_0327_),
    .B1(_1956_),
    .B2(_1957_),
    .A2(net117),
    .A1(_0500_));
 sg13g2_xnor2_1 _3080_ (.Y(_1958_),
    .A(_1886_),
    .B(_1899_));
 sg13g2_nor2_1 _3081_ (.A(net67),
    .B(_1958_),
    .Y(_1959_));
 sg13g2_or3_1 _3082_ (.A(_1886_),
    .B(_1888_),
    .C(_1931_),
    .X(_1960_));
 sg13g2_nor2b_1 _3083_ (.A(net101),
    .B_N(_1932_),
    .Y(_1961_));
 sg13g2_a21oi_1 _3084_ (.A1(_1960_),
    .A2(_1961_),
    .Y(_1962_),
    .B1(_1959_));
 sg13g2_nand2_1 _3085_ (.Y(_0647_),
    .A(_0629_),
    .B(_0646_));
 sg13g2_a22oi_1 _3086_ (.Y(_0328_),
    .B1(net63),
    .B2(_1962_),
    .A2(net117),
    .A1(_0574_));
 sg13g2_or3_1 _3087_ (.A(_1881_),
    .B(_1901_),
    .C(_1902_),
    .X(_1963_));
 sg13g2_nor2b_1 _3088_ (.A(net68),
    .B_N(_1903_),
    .Y(_1964_));
 sg13g2_nand3_1 _3089_ (.B(_1882_),
    .C(_1933_),
    .A(_1881_),
    .Y(_1965_));
 sg13g2_nor2_1 _3090_ (.A(net102),
    .B(_1934_),
    .Y(_1966_));
 sg13g2_a22oi_1 _3091_ (.Y(_1967_),
    .B1(_1965_),
    .B2(_1966_),
    .A2(_1964_),
    .A1(_1963_));
 sg13g2_a22oi_1 _3092_ (.Y(_0329_),
    .B1(net63),
    .B2(_1967_),
    .A2(net117),
    .A1(_0575_));
 sg13g2_or2_1 _3093_ (.X(_0200_),
    .B(net587),
    .A(net633));
 sg13g2_nand3_1 _3094_ (.B(_1893_),
    .C(_1896_),
    .A(_1892_),
    .Y(_1968_));
 sg13g2_nor2_1 _3095_ (.A(_1897_),
    .B(net67),
    .Y(_1969_));
 sg13g2_nor2_1 _3096_ (.A(net154),
    .B(_0647_),
    .Y(_0648_));
 sg13g2_or3_1 _3097_ (.A(_1892_),
    .B(_1927_),
    .C(_1929_),
    .X(_1970_));
 sg13g2_nor2b_1 _3098_ (.A(net101),
    .B_N(_1930_),
    .Y(_1971_));
 sg13g2_a22oi_1 _3099_ (.Y(_1972_),
    .B1(_1970_),
    .B2(_1971_),
    .A2(_1969_),
    .A1(_1968_));
 sg13g2_a22oi_1 _3100_ (.Y(_0341_),
    .B1(net63),
    .B2(_1972_),
    .A2(net117),
    .A1(_0524_));
 sg13g2_xor2_1 _3101_ (.B(net18),
    .A(net120),
    .X(_1973_));
 sg13g2_xnor2_1 _3102_ (.Y(_1974_),
    .A(_1912_),
    .B(_1973_));
 sg13g2_nand3_1 _3103_ (.B(_1916_),
    .C(_1974_),
    .A(net101),
    .Y(_1975_));
 sg13g2_o21ai_1 _3104_ (.B1(\SS_BBPD[1] ),
    .Y(_1976_),
    .A1(_1947_),
    .A2(_1973_));
 sg13g2_a21oi_1 _3105_ (.A1(_1947_),
    .A2(_1973_),
    .Y(_1977_),
    .B1(_1976_));
 sg13g2_nor3_1 _3106_ (.A(net115),
    .B(_1953_),
    .C(_1977_),
    .Y(_1978_));
 sg13g2_inv_1 _3107_ (.Y(_0497_),
    .A(net622));
 sg13g2_xor2_1 _3108_ (.B(_0629_),
    .A(\pll_dig.div.ncnt[6] ),
    .X(_0649_));
 sg13g2_a22oi_1 _3109_ (.Y(_0347_),
    .B1(_1975_),
    .B2(_1978_),
    .A2(net115),
    .A1(_0568_));
 sg13g2_xnor2_1 _3110_ (.Y(_1979_),
    .A(_1909_),
    .B(_1922_));
 sg13g2_nor2_1 _3111_ (.A(net67),
    .B(_1979_),
    .Y(_1980_));
 sg13g2_and2_1 _3112_ (.A(_1923_),
    .B(_1943_),
    .X(_1981_));
 sg13g2_nor3_1 _3113_ (.A(net101),
    .B(_1944_),
    .C(_1981_),
    .Y(_1982_));
 sg13g2_nor2_1 _3114_ (.A(_1980_),
    .B(_1982_),
    .Y(_1983_));
 sg13g2_a22oi_1 _3115_ (.Y(_0349_),
    .B1(net63),
    .B2(_1983_),
    .A2(net115),
    .A1(_0572_));
 sg13g2_or2_1 _3116_ (.X(_1984_),
    .B(net14),
    .A(\pll_dig.dlf.INT[0] ));
 sg13g2_a21oi_1 _3117_ (.A1(_1928_),
    .A2(_1984_),
    .Y(_1985_),
    .B1(_1953_));
 sg13g2_nor2_1 _3118_ (.A(\SS_BBPD[1] ),
    .B(_1916_),
    .Y(_1986_));
 sg13g2_a22oi_1 _3119_ (.Y(_0650_),
    .B1(_0649_),
    .B2(\pll_dig.div.div[6] ),
    .A2(_0647_),
    .A1(net154));
 sg13g2_nor3_1 _3120_ (.A(net116),
    .B(_1985_),
    .C(_1986_),
    .Y(_1987_));
 sg13g2_a21o_1 _3121_ (.A2(net116),
    .A1(\pll_dig.dlf.INT[0] ),
    .B1(_1987_),
    .X(_0351_));
 sg13g2_xnor2_1 _3122_ (.Y(_1988_),
    .A(_1867_),
    .B(_1913_));
 sg13g2_nor2_1 _3123_ (.A(net67),
    .B(_1988_),
    .Y(_1989_));
 sg13g2_nand3_1 _3124_ (.B(_1921_),
    .C(_1948_),
    .A(_1866_),
    .Y(_1990_));
 sg13g2_nor2_1 _3125_ (.A(net101),
    .B(_1949_),
    .Y(_1991_));
 sg13g2_a21oi_1 _3126_ (.A1(_1990_),
    .A2(_1991_),
    .Y(_1992_),
    .B1(_1989_));
 sg13g2_a22oi_1 _3127_ (.Y(_0352_),
    .B1(net63),
    .B2(_1992_),
    .A2(net115),
    .A1(_0567_));
 sg13g2_xnor2_1 _3128_ (.Y(_1993_),
    .A(_1870_),
    .B(_1910_));
 sg13g2_nand2_1 _3129_ (.Y(_1994_),
    .A(_1870_),
    .B(_1945_));
 sg13g2_o21ai_1 _3130_ (.B1(_0650_),
    .Y(_0651_),
    .A1(_0648_),
    .A2(_0645_));
 sg13g2_nand3_1 _3131_ (.B(_1946_),
    .C(_1994_),
    .A(\SS_BBPD[1] ),
    .Y(_1995_));
 sg13g2_o21ai_1 _3132_ (.B1(net63),
    .Y(_1996_),
    .A1(net67),
    .A2(_1993_));
 sg13g2_inv_1 _3133_ (.Y(_1997_),
    .A(_1996_));
 sg13g2_a22oi_1 _3134_ (.Y(_0353_),
    .B1(_1995_),
    .B2(_1997_),
    .A2(net116),
    .A1(_0569_));
 sg13g2_nand2_1 _3135_ (.Y(_1998_),
    .A(net119),
    .B(net115));
 sg13g2_a21oi_1 _3136_ (.A1(_1950_),
    .A2(_1951_),
    .Y(_1999_),
    .B1(_0496_));
 sg13g2_nand3_1 _3137_ (.B(_1864_),
    .C(_1914_),
    .A(net101),
    .Y(_2000_));
 sg13g2_nand2b_1 _3138_ (.Y(_2001_),
    .B(_2000_),
    .A_N(net115));
 sg13g2_o21ai_1 _3139_ (.B1(_1998_),
    .Y(_0354_),
    .A1(_1999_),
    .A2(_2001_));
 sg13g2_or2_1 _3140_ (.X(_2002_),
    .B(_1908_),
    .A(_1874_));
 sg13g2_nor2_1 _3141_ (.A(\pll_dig.div.div[6] ),
    .B(\pll_dig.div.div[7] ),
    .Y(_0652_));
 sg13g2_a21oi_1 _3142_ (.A1(_1874_),
    .A2(_1908_),
    .Y(_2003_),
    .B1(net67));
 sg13g2_nand2_1 _3143_ (.Y(_2004_),
    .A(_1874_),
    .B(_1941_));
 sg13g2_nor2_1 _3144_ (.A(net102),
    .B(_1942_),
    .Y(_2005_));
 sg13g2_a22oi_1 _3145_ (.Y(_2006_),
    .B1(_2004_),
    .B2(_2005_),
    .A2(_2003_),
    .A1(_2002_));
 sg13g2_a22oi_1 _3146_ (.Y(_0355_),
    .B1(net63),
    .B2(_2006_),
    .A2(net117),
    .A1(_0573_));
 sg13g2_xnor2_1 _3147_ (.Y(_2007_),
    .A(_1907_),
    .B(_1924_));
 sg13g2_nor2_1 _3148_ (.A(net68),
    .B(_2007_),
    .Y(_2008_));
 sg13g2_nand2_1 _3149_ (.Y(_2009_),
    .A(_1925_),
    .B(_1939_));
 sg13g2_nor2_1 _3150_ (.A(net102),
    .B(_1940_),
    .Y(_2010_));
 sg13g2_a21oi_1 _3151_ (.A1(_2009_),
    .A2(_2010_),
    .Y(_2011_),
    .B1(_2008_));
 sg13g2_nor4_2 _3152_ (.A(net155),
    .B(net157),
    .C(net160),
    .Y(_0653_),
    .D(net413));
 sg13g2_a22oi_1 _3153_ (.Y(_0357_),
    .B1(net64),
    .B2(_2011_),
    .A2(net117),
    .A1(_0582_));
 sg13g2_nand2_1 _3154_ (.Y(_2012_),
    .A(_1877_),
    .B(_1905_));
 sg13g2_nor2_1 _3155_ (.A(_1906_),
    .B(net68),
    .Y(_2013_));
 sg13g2_nand2_1 _3156_ (.Y(_2014_),
    .A(_1878_),
    .B(_1937_));
 sg13g2_nor2_1 _3157_ (.A(net102),
    .B(_1938_),
    .Y(_2015_));
 sg13g2_a22oi_1 _3158_ (.Y(_2016_),
    .B1(_2014_),
    .B2(_2015_),
    .A2(_2013_),
    .A1(_2012_));
 sg13g2_a22oi_1 _3159_ (.Y(_0358_),
    .B1(net64),
    .B2(_2016_),
    .A2(net118),
    .A1(_0596_));
 sg13g2_xnor2_1 _3160_ (.Y(_2017_),
    .A(_1894_),
    .B(_1895_));
 sg13g2_xor2_1 _3161_ (.B(_1928_),
    .A(_1894_),
    .X(_2018_));
 sg13g2_o21ai_1 _3162_ (.B1(net63),
    .Y(_2019_),
    .A1(net67),
    .A2(_2017_));
 sg13g2_nand3_1 _3163_ (.B(_0653_),
    .C(_0652_),
    .A(net406),
    .Y(_0654_));
 sg13g2_a21oi_1 _3164_ (.A1(\SS_BBPD[1] ),
    .A2(_2018_),
    .Y(_2020_),
    .B1(_2019_));
 sg13g2_a21oi_1 _3165_ (.A1(_0525_),
    .A2(net116),
    .Y(_0359_),
    .B1(_2020_));
 sg13g2_xnor2_1 _3166_ (.Y(_2021_),
    .A(_1904_),
    .B(_1926_));
 sg13g2_nor2_1 _3167_ (.A(net68),
    .B(_2021_),
    .Y(_2022_));
 sg13g2_nand2_1 _3168_ (.Y(_2023_),
    .A(_1926_),
    .B(_1935_));
 sg13g2_nor2_1 _3169_ (.A(net102),
    .B(_1936_),
    .Y(_2024_));
 sg13g2_a21oi_1 _3170_ (.A1(_2023_),
    .A2(_2024_),
    .Y(_2025_),
    .B1(_2022_));
 sg13g2_a22oi_1 _3171_ (.Y(_0360_),
    .B1(net64),
    .B2(_2025_),
    .A2(net118),
    .A1(_0571_));
 sg13g2_xnor2_1 _3172_ (.Y(_2026_),
    .A(_1889_),
    .B(_1898_));
 sg13g2_nand3_1 _3173_ (.B(_1891_),
    .C(_1930_),
    .A(_1889_),
    .Y(_2027_));
 sg13g2_nand2_2 _3174_ (.Y(_0655_),
    .A(net405),
    .B(_0654_));
 sg13g2_nor2_1 _3175_ (.A(_0496_),
    .B(_1931_),
    .Y(_2028_));
 sg13g2_o21ai_1 _3176_ (.B1(net64),
    .Y(_2029_),
    .A1(net68),
    .A2(_2026_));
 sg13g2_a21oi_1 _3177_ (.A1(_2027_),
    .A2(_2028_),
    .Y(_2030_),
    .B1(_2029_));
 sg13g2_a21oi_1 _3178_ (.A1(_0576_),
    .A2(net117),
    .Y(_0363_),
    .B1(_2030_));
 sg13g2_and2_1 _3179_ (.A(net403),
    .B(_1786_),
    .X(_0219_));
 sg13g2_xnor2_1 _3180_ (.Y(_2031_),
    .A(\pll_dig.div.div_pend[0] ),
    .B(_0157_));
 sg13g2_nor2_1 _3181_ (.A(_1642_),
    .B(_2031_),
    .Y(_0220_));
 sg13g2_a21oi_1 _3182_ (.A1(_0690_),
    .A2(_0747_),
    .Y(_2032_),
    .B1(net131));
 sg13g2_nand2b_1 _3183_ (.Y(_2033_),
    .B(net131),
    .A_N(net119));
 sg13g2_a21oi_1 _3184_ (.A1(\SS_BBPD[0] ),
    .A2(_0777_),
    .Y(_2034_),
    .B1(_2033_));
 sg13g2_nor2_1 _3185_ (.A(net153),
    .B(_0649_),
    .Y(_0656_));
 sg13g2_nor2_1 _3186_ (.A(_2032_),
    .B(_2034_),
    .Y(_0225_));
 sg13g2_and2_1 _3187_ (.A(net406),
    .B(net403),
    .X(_0231_));
 sg13g2_mux2_1 _3188_ (.A0(_0162_),
    .A1(_0164_),
    .S(net152),
    .X(_0232_));
 sg13g2_nand2_1 _3189_ (.Y(_2035_),
    .A(net589),
    .B(_1600_));
 sg13g2_xnor2_1 _3190_ (.Y(_0374_),
    .A(\pll_dig.clr_toggle ),
    .B(net590));
 sg13g2_nor2b_1 _3191_ (.A(net618),
    .B_N(_1610_),
    .Y(_2036_));
 sg13g2_nand2b_1 _3192_ (.Y(_2037_),
    .B(_1610_),
    .A_N(net618));
 sg13g2_nand2_1 _3193_ (.Y(_2038_),
    .A(_1607_),
    .B(_1610_));
 sg13g2_nor3_1 _3194_ (.A(_1612_),
    .B(_1686_),
    .C(_2038_),
    .Y(_2039_));
 sg13g2_a21oi_1 _3195_ (.A1(\pll_dig.PHASE_LOCK ),
    .A2(_2037_),
    .Y(_2040_),
    .B1(_2039_));
 sg13g2_o21ai_1 _3196_ (.B1(_0651_),
    .Y(_0657_),
    .A1(\pll_dig.div.div[7] ),
    .A2(_0631_));
 sg13g2_nor2_1 _3197_ (.A(_0599_),
    .B(_2040_),
    .Y(_0378_));
 sg13g2_nor2_1 _3198_ (.A(_1599_),
    .B(_0050_),
    .Y(_2041_));
 sg13g2_nand2b_1 _3199_ (.Y(_2042_),
    .B(_1600_),
    .A_N(_0050_));
 sg13g2_nand3_1 _3200_ (.B(net619),
    .C(net646),
    .A(net628),
    .Y(_2043_));
 sg13g2_nor2_1 _3201_ (.A(_0499_),
    .B(_2043_),
    .Y(_2044_));
 sg13g2_and2_1 _3202_ (.A(net650),
    .B(net644),
    .X(_2045_));
 sg13g2_nand3_1 _3203_ (.B(net591),
    .C(_2045_),
    .A(net641),
    .Y(_2046_));
 sg13g2_nor2_1 _3204_ (.A(\pll_dig.cntf[2] ),
    .B(\pll_dig.cntf[3] ),
    .Y(_2047_));
 sg13g2_nor4_1 _3205_ (.A(\pll_dig.cntf[6] ),
    .B(\pll_dig.cntf[7] ),
    .C(\pll_dig.cntf[0] ),
    .D(\pll_dig.cntf[1] ),
    .Y(_2048_));
 sg13g2_and4_1 _3206_ (.A(net650),
    .B(_0588_),
    .C(_2047_),
    .D(_2048_),
    .X(_2049_));
 sg13g2_nor3_2 _3207_ (.A(_0655_),
    .B(_0657_),
    .C(_0656_),
    .Y(_0658_));
 sg13g2_nor4_1 _3208_ (.A(net636),
    .B(_1606_),
    .C(_1658_),
    .D(_2049_),
    .Y(_2050_));
 sg13g2_a21oi_1 _3209_ (.A1(net642),
    .A2(_2050_),
    .Y(_2051_),
    .B1(_2042_));
 sg13g2_nor2b_1 _3210_ (.A(_2051_),
    .B_N(\pll_dig.cntf[7] ),
    .Y(_2052_));
 sg13g2_nand2_1 _3211_ (.Y(_2053_),
    .A(_2041_),
    .B(_2050_));
 sg13g2_nor3_1 _3212_ (.A(\pll_dig.cntf[7] ),
    .B(net642),
    .C(_2053_),
    .Y(_2054_));
 sg13g2_or2_1 _3213_ (.X(_0402_),
    .B(_2054_),
    .A(_2052_));
 sg13g2_nand2b_1 _3214_ (.Y(_2055_),
    .B(_2050_),
    .A_N(_2045_));
 sg13g2_a21oi_1 _3215_ (.A1(_2041_),
    .A2(_2055_),
    .Y(_2056_),
    .B1(_0588_));
 sg13g2_nand4_1 _3216_ (.B(_2041_),
    .C(_2045_),
    .A(_0588_),
    .Y(_2057_),
    .D(_2050_));
 sg13g2_nand2b_1 _3217_ (.Y(_0403_),
    .B(net651),
    .A_N(_2056_));
 sg13g2_inv_1 _3218_ (.Y(_0481_),
    .A(\pll_dig.flock.cnt_filt[6] ));
 sg13g2_inv_1 _3219_ (.Y(_0498_),
    .A(\pll_dig.cntf[2] ));
 sg13g2_nor2b_1 _3220_ (.A(_0631_),
    .B_N(_0658_),
    .Y(_0044_));
 sg13g2_a21oi_1 _3221_ (.A1(_2043_),
    .A2(_2050_),
    .Y(_2058_),
    .B1(_2042_));
 sg13g2_or3_1 _3222_ (.A(\pll_dig.cntf[3] ),
    .B(_2043_),
    .C(_2053_),
    .X(_2059_));
 sg13g2_o21ai_1 _3223_ (.B1(_2059_),
    .Y(_0404_),
    .A1(_0499_),
    .A2(_2058_));
 sg13g2_nand2_1 _3224_ (.Y(_2060_),
    .A(\pll_dig.cntf[1] ),
    .B(_2042_));
 sg13g2_xnor2_1 _3225_ (.Y(_2061_),
    .A(net628),
    .B(\pll_dig.cntf[1] ));
 sg13g2_o21ai_1 _3226_ (.B1(_2060_),
    .Y(_0405_),
    .A1(_2053_),
    .A2(_2061_));
 sg13g2_nand2b_1 _3227_ (.Y(_2062_),
    .B(\pll_dig.FORCE_N ),
    .A_N(\pll_dig.state[2] ));
 sg13g2_nand3b_1 _3228_ (.B(net614),
    .C(_2049_),
    .Y(_2063_),
    .A_N(net611));
 sg13g2_o21ai_1 _3229_ (.B1(_2062_),
    .Y(_0407_),
    .A1(_1663_),
    .A2(net615));
 sg13g2_or2_1 _3230_ (.X(_0408_),
    .B(_1598_),
    .A(\pll_dig.ENABLE ));
 sg13g2_nor2_1 _3231_ (.A(_0502_),
    .B(_0655_),
    .Y(_0659_));
 sg13g2_and2_1 _3232_ (.A(_0157_),
    .B(_1641_),
    .X(_0249_));
 sg13g2_mux2_1 _3233_ (.A0(_0159_),
    .A1(_0160_),
    .S(net152),
    .X(_0260_));
 sg13g2_nand2_1 _3234_ (.Y(_0449_),
    .A(net587),
    .B(_0262_));
 sg13g2_a21oi_1 _3235_ (.A1(net603),
    .A2(_1851_),
    .Y(_2064_),
    .B1(\pll_dig.cnt[2] ));
 sg13g2_nor3_1 _3236_ (.A(_1852_),
    .B(_1860_),
    .C(net604),
    .Y(_0450_));
 sg13g2_a21oi_1 _3237_ (.A1(_0581_),
    .A2(net649),
    .Y(_2065_),
    .B1(_1860_));
 sg13g2_nor2b_1 _3238_ (.A(net640),
    .B_N(_2065_),
    .Y(_0451_));
 sg13g2_nor2_1 _3239_ (.A(\pll_dig.cnt[6] ),
    .B(net640),
    .Y(_2066_));
 sg13g2_nor2_1 _3240_ (.A(_1861_),
    .B(_2066_),
    .Y(_0452_));
 sg13g2_a21oi_1 _3241_ (.A1(net625),
    .A2(_2036_),
    .Y(_2067_),
    .B1(\pll_dig.LOCK_LOST ));
 sg13g2_a21oi_2 _3242_ (.B1(_0658_),
    .Y(_0660_),
    .A2(_0631_),
    .A1(_0659_));
 sg13g2_nor3_1 _3243_ (.A(_0599_),
    .B(_2039_),
    .C(net626),
    .Y(_0455_));
 sg13g2_a21o_1 _3244_ (.A2(\pll_dig.div.use_clk ),
    .A1(_0510_),
    .B1(\pll_dig.div.enter_req ),
    .X(_0461_));
 sg13g2_nand3_1 _3245_ (.B(_2041_),
    .C(_2045_),
    .A(net591),
    .Y(_2068_));
 sg13g2_a21oi_1 _3246_ (.A1(_0488_),
    .A2(net592),
    .Y(_0464_),
    .B1(_2051_));
 sg13g2_a21oi_1 _3247_ (.A1(_2041_),
    .A2(net644),
    .Y(_2069_),
    .B1(\pll_dig.cntf[4] ));
 sg13g2_a21oi_1 _3248_ (.A1(_2041_),
    .A2(_2055_),
    .Y(_0465_),
    .B1(_2069_));
 sg13g2_nand3_1 _3249_ (.B(net619),
    .C(_2041_),
    .A(\pll_dig.cntf[0] ),
    .Y(_2070_));
 sg13g2_a21oi_1 _3250_ (.A1(_0498_),
    .A2(net620),
    .Y(_0466_),
    .B1(_2058_));
 sg13g2_nand2_1 _3251_ (.Y(_2071_),
    .A(\pll_dig.cntf[0] ),
    .B(_2042_));
 sg13g2_o21ai_1 _3252_ (.B1(_2071_),
    .Y(_0467_),
    .A1(\pll_dig.cntf[0] ),
    .A2(_2053_));
 sg13g2_nor2_2 _3253_ (.A(_0649_),
    .B(_0660_),
    .Y(_0043_));
 sg13g2_nand3_1 _3254_ (.B(_1852_),
    .C(_1857_),
    .A(net633),
    .Y(_2072_));
 sg13g2_nor2b_1 _3255_ (.A(\pll_dig.cnt[4] ),
    .B_N(_2072_),
    .Y(_2073_));
 sg13g2_a21oi_1 _3256_ (.A1(_1853_),
    .A2(_1857_),
    .Y(_2074_),
    .B1(_1859_));
 sg13g2_a21oi_1 _3257_ (.A1(\pll_dig.cnt[4] ),
    .A2(_2074_),
    .Y(_0468_),
    .B1(_2073_));
 sg13g2_nor2_1 _3258_ (.A(\pll_dig.cnt[0] ),
    .B(_1850_),
    .Y(_2075_));
 sg13g2_nor3_1 _3259_ (.A(_1851_),
    .B(_1860_),
    .C(_2075_),
    .Y(_0469_));
 sg13g2_or3_1 _3260_ (.A(\pll_dig.FREQ_ERR ),
    .B(\pll_dig.FREQ_OK ),
    .C(_1595_),
    .X(_2076_));
 sg13g2_and2_1 _3261_ (.A(_0200_),
    .B(_2076_),
    .X(_2077_));
 sg13g2_a21oi_1 _3262_ (.A1(net594),
    .A2(net587),
    .Y(_2078_),
    .B1(_1598_));
 sg13g2_a22oi_1 _3263_ (.Y(_0470_),
    .B1(_2078_),
    .B2(_0497_),
    .A2(_2077_),
    .A1(net594));
 sg13g2_nor2_2 _3264_ (.A(_0647_),
    .B(_0660_),
    .Y(_0042_));
 sg13g2_nand2b_1 _3265_ (.Y(_2079_),
    .B(\pll_dig.FORCE_P ),
    .A_N(\pll_dig.state[2] ));
 sg13g2_nand2_1 _3266_ (.Y(_2080_),
    .A(net611),
    .B(_2049_));
 sg13g2_o21ai_1 _3267_ (.B1(_2079_),
    .Y(_0472_),
    .A1(_1663_),
    .A2(net612));
 sg13g2_xnor2_1 _3268_ (.Y(_2081_),
    .A(\pll_dig.cnt[1] ),
    .B(_1851_));
 sg13g2_nor2_1 _3269_ (.A(_1860_),
    .B(_2081_),
    .Y(_0473_));
 sg13g2_or2_1 _3270_ (.X(_0474_),
    .B(net57),
    .A(net588));
 sg13g2_nand2_1 _3271_ (.Y(_2082_),
    .A(_1600_),
    .B(_1663_));
 sg13g2_nor2_1 _3272_ (.A(_1687_),
    .B(_2082_),
    .Y(_2083_));
 sg13g2_a21oi_1 _3273_ (.A1(_0586_),
    .A2(_2082_),
    .Y(_0475_),
    .B1(_2083_));
 sg13g2_nor2_1 _3274_ (.A(\pll_dig.cnt[3] ),
    .B(net655),
    .Y(_2084_));
 sg13g2_nor2_2 _3275_ (.A(_0632_),
    .B(_0660_),
    .Y(_0041_));
 sg13g2_nor2_1 _3276_ (.A(_2074_),
    .B(_2084_),
    .Y(_0476_));
 sg13g2_nor3_2 _3277_ (.A(\pll_dig.div.div_pend[0] ),
    .B(_1642_),
    .C(net395),
    .Y(_2085_));
 sg13g2_nor2b_1 _3278_ (.A(net405),
    .B_N(net403),
    .Y(_2086_));
 sg13g2_a21oi_2 _3279_ (.B1(_2085_),
    .Y(_0284_),
    .A2(_2086_),
    .A1(net395));
 sg13g2_inv_1 _3280__336 (.Y(net335),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3281__339 (.Y(net338),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_nor2_2 _3282_ (.A(_0660_),
    .B(_0640_),
    .Y(_0040_));
 sg13g2_inv_1 _3283__332 (.Y(net331),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3284__335 (.Y(net334),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_buf_1 _3285_ (.A(\pll_dig.div.div_pend[6] ),
    .X(_0067_));
 sg13g2_inv_1 _3286__337 (.Y(net336),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3287__333 (.Y(net332),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3288__329 (.Y(net328),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3289__325 (.Y(net324),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3290__323 (.Y(net322),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3291__321 (.Y(net320),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3292__319 (.Y(net318),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_nor2_2 _3293_ (.A(_0633_),
    .B(_0660_),
    .Y(_0039_));
 sg13g2_inv_1 _3294__300 (.Y(net299),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3295__295 (.Y(net294),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3296__275 (.Y(net274),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3297__277 (.Y(net276),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3298__327 (.Y(net326),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3299__328 (.Y(net327),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3300__331 (.Y(net330),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3301__340 (.Y(net339),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3302__342 (.Y(net341),
    .A(clknet_5_2__leaf_net59_regs));
 sg13g2_inv_1 _3303__289 (.Y(net288),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_nor2_1 _3304_ (.A(net438),
    .B(net437),
    .Y(_0661_));
 sg13g2_inv_1 _3305__271 (.Y(net270),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3306__270 (.Y(net269),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3307__274 (.Y(net273),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3308__283 (.Y(net282),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3309__276 (.Y(net275),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3310__282 (.Y(net281),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3311__343 (.Y(net342),
    .A(clknet_5_15__leaf_net59_regs));
 sg13g2_inv_1 _3312__344 (.Y(net343),
    .A(clknet_5_26__leaf_net59_regs));
 sg13g2_buf_1 _3313_ (.A(\pll_dig.div.div_pend[7] ),
    .X(_0068_));
 sg13g2_buf_1 _3314_ (.A(\pll_dig.div.div_pend[5] ),
    .X(_0066_));
 sg13g2_nor3_2 _3315_ (.A(_0626_),
    .B(_0661_),
    .C(_0660_),
    .Y(_0038_));
 sg13g2_buf_1 _3316_ (.A(\pll_dig.div.div_pend[4] ),
    .X(_0065_));
 sg13g2_buf_1 _3317_ (.A(\pll_dig.div.div_pend[3] ),
    .X(_0064_));
 sg13g2_buf_1 _3318_ (.A(\pll_dig.div.div_pend[2] ),
    .X(_0063_));
 sg13g2_inv_1 _3319__338 (.Y(net337),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3320__334 (.Y(net333),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3321__284 (.Y(net283),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3322__285 (.Y(net284),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3323__287 (.Y(net286),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3324__288 (.Y(net287),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3325__324 (.Y(net323),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3326_ (.Y(_0499_),
    .A(net643));
 sg13g2_nor2_2 _3327_ (.A(net437),
    .B(_0660_),
    .Y(_0037_));
 sg13g2_inv_1 _3328__322 (.Y(net321),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3329__320 (.Y(net319),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3330__318 (.Y(net317),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3331__296 (.Y(net295),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3332__298 (.Y(net297),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3333__345 (.Y(net344),
    .A(clknet_5_12__leaf_net59_regs));
 sg13g2_inv_1 _3334__301 (.Y(net300),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3335__341 (.Y(net340),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3336__293 (.Y(net292),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3337__267 (.Y(net266),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_nand3_1 _3338_ (.B(net5),
    .C(net6),
    .A(net7),
    .Y(_0662_));
 sg13g2_inv_1 _3339__265 (.Y(net264),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3340__268 (.Y(net267),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3341__291 (.Y(net290),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3342__269 (.Y(net268),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3343__292 (.Y(net291),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3344__290 (.Y(net289),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3345__346 (.Y(net345),
    .A(clknet_5_15__leaf_net59_regs));
 sg13g2_inv_1 _3346__294 (.Y(net293),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3347__266 (.Y(net265),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3348__347 (.Y(net346),
    .A(clknet_5_14__leaf_net59_regs));
 sg13g2_nor2_1 _3349_ (.A(_0538_),
    .B(_0662_),
    .Y(_0663_));
 sg13g2_inv_1 _3350__314 (.Y(net313),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3351__310 (.Y(net309),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3352__316 (.Y(net315),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3353__309 (.Y(net308),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3354__308 (.Y(net307),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3355__307 (.Y(net306),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3356__302 (.Y(net301),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3357__305 (.Y(net304),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3358__303 (.Y(net302),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3359__317 (.Y(net316),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_nand3_1 _3360_ (.B(net10),
    .C(_0663_),
    .A(net9),
    .Y(_0664_));
 sg13g2_inv_1 _3361__306 (.Y(net305),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3362__304 (.Y(net303),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3363__315 (.Y(net314),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3364__299 (.Y(net298),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3365__272 (.Y(net271),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3366__273 (.Y(net272),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3367__286 (.Y(net285),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3368__311 (.Y(net310),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3369__313 (.Y(net312),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3370__312 (.Y(net311),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_or2_1 _3371_ (.X(_0665_),
    .B(_0664_),
    .A(_0490_));
 sg13g2_inv_1 _3372__326 (.Y(net325),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3373__278 (.Y(net277),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3374__279 (.Y(net278),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3375__281 (.Y(net280),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3376__280 (.Y(net279),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3377__348 (.Y(net347),
    .A(clknet_5_12__leaf_net59_regs));
 sg13g2_inv_1 _3378__297 (.Y(net296),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3379__349 (.Y(net348),
    .A(clknet_5_2__leaf_net59_regs));
 sg13g2_buf_1 _3380_ (.A(net160),
    .X(_0084_));
 sg13g2_buf_1 _3381_ (.A(net413),
    .X(_0085_));
 sg13g2_xnor2_1 _3382_ (.Y(_0130_),
    .A(net11),
    .B(_0664_));
 sg13g2_buf_1 _3383_ (.A(net157),
    .X(_0086_));
 sg13g2_buf_1 _3384_ (.A(net155),
    .X(_0087_));
 sg13g2_buf_1 _3385_ (.A(\pll_dig.div.div[6] ),
    .X(_0088_));
 sg13g2_buf_1 _3386_ (.A(\pll_dig.div.div[7] ),
    .X(_0089_));
 sg13g2_buf_1 _3387_ (.A(_0166_),
    .X(_0265_));
 sg13g2_nand2_1 _3388_ (.Y(_0666_),
    .A(\pll_dig.dsm_impl.dsm.cin_stg2 ),
    .B(net107));
 sg13g2_nor2b_1 _3389_ (.A(net4),
    .B_N(net3),
    .Y(_0667_));
 sg13g2_nor2b_1 _3390_ (.A(net3),
    .B_N(net4),
    .Y(_0668_));
 sg13g2_or2_1 _3391_ (.X(_0669_),
    .B(_0668_),
    .A(_0667_));
 sg13g2_inv_1 _3392_ (.Y(_0500_),
    .A(net670));
 sg13g2_and2_1 _3393_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .B(net1),
    .X(_0670_));
 sg13g2_nand2_1 _3394_ (.Y(_0671_),
    .A(net96),
    .B(net2));
 sg13g2_a21oi_1 _3395_ (.A1(_0669_),
    .A2(_0670_),
    .Y(_0672_),
    .B1(net106));
 sg13g2_a21oi_1 _3396_ (.A1(_0666_),
    .A2(_0671_),
    .Y(_0478_),
    .B1(_0672_));
 sg13g2_and2_1 _3397_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[0] ),
    .X(_0673_));
 sg13g2_or2_1 _3398_ (.X(_0674_),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[0] ));
 sg13g2_nand2b_1 _3399_ (.Y(_0675_),
    .B(net377),
    .A_N(_0673_));
 sg13g2_xnor2_1 _3400_ (.Y(_0676_),
    .A(\pll_dig.dsm_impl.dsm.cin_stg2 ),
    .B(_0675_));
 sg13g2_nand2_1 _3401_ (.Y(_0677_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .B(_0676_));
 sg13g2_a21oi_2 _3402_ (.B1(_0673_),
    .Y(_0678_),
    .A2(\pll_dig.dsm_impl.dsm.cin_stg2 ),
    .A1(_0674_));
 sg13g2_inv_1 _3403_ (.Y(_0501_),
    .A(\pll_dig.div.div_pend[7] ));
 sg13g2_nand2_1 _3404_ (.Y(_0679_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[1] ));
 sg13g2_nor2_1 _3405_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .Y(_0680_));
 sg13g2_xor2_1 _3406_ (.B(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .X(_0681_));
 sg13g2_xnor2_1 _3407_ (.Y(_0682_),
    .A(_0681_),
    .B(_0678_));
 sg13g2_nand2_1 _3408_ (.Y(_0683_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .B(net373));
 sg13g2_xnor2_1 _3409_ (.Y(_0684_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .B(_0682_));
 sg13g2_a21oi_1 _3410_ (.A1(_0677_),
    .A2(_0684_),
    .Y(_0685_),
    .B1(net108));
 sg13g2_o21ai_1 _3411_ (.B1(_0685_),
    .Y(_0686_),
    .A1(_0677_),
    .A2(_0684_));
 sg13g2_o21ai_1 _3412_ (.B1(_0686_),
    .Y(_0477_),
    .A1(_0491_),
    .A2(net96));
 sg13g2_nor2_1 _3413_ (.A(\pll_dig.FILTER_DEC[4] ),
    .B(\pll_dig.FILTER_DEC[3] ),
    .Y(_0687_));
 sg13g2_inv_1 _3414_ (.Y(_0502_),
    .A(\pll_dig.div.div[7] ));
 sg13g2_inv_1 _3415_ (.Y(\pll_dig.FINE_MUX_D[7] ),
    .A(net99));
 sg13g2_a21o_1 _3416_ (.A2(\pll_dig.FILTER_DEC[3] ),
    .A1(net104),
    .B1(\pll_dig.FILTER_DEC[4] ),
    .X(\pll_dig.FINE_MUX_D[11] ));
 sg13g2_nand2_1 _3417_ (.Y(_0688_),
    .A(\SS_BBPD[0] ),
    .B(\SS_BBPD[1] ));
 sg13g2_nand2b_1 _3418_ (.Y(_0689_),
    .B(net36),
    .A_N(net119));
 sg13g2_nor2b_1 _3419_ (.A(net36),
    .B_N(net119),
    .Y(_0690_));
 sg13g2_nor2_1 _3420_ (.A(_0567_),
    .B(net35),
    .Y(_0691_));
 sg13g2_xor2_1 _3421_ (.B(net35),
    .A(\pll_dig.dlf.INT[14] ),
    .X(_0692_));
 sg13g2_inv_1 _3422_ (.Y(_0693_),
    .A(_0692_));
 sg13g2_xor2_1 _3423_ (.B(net33),
    .A(net665),
    .X(_0694_));
 sg13g2_inv_1 _3424_ (.Y(_0695_),
    .A(_0694_));
 sg13g2_inv_1 _3425_ (.Y(_0000_),
    .A(\pll_dig.out_edges[1] ));
 sg13g2_nand2_1 _3426_ (.Y(_0696_),
    .A(\pll_dig.dlf.INT[11] ),
    .B(net32));
 sg13g2_xnor2_1 _3427_ (.Y(_0697_),
    .A(net680),
    .B(net32));
 sg13g2_inv_1 _3428_ (.Y(_0698_),
    .A(_0697_));
 sg13g2_and2_1 _3429_ (.A(net661),
    .B(net31),
    .X(_0699_));
 sg13g2_xor2_1 _3430_ (.B(net31),
    .A(net661),
    .X(_0700_));
 sg13g2_xor2_1 _3431_ (.B(net44),
    .A(net122),
    .X(_0701_));
 sg13g2_xor2_1 _3432_ (.B(net42),
    .A(net667),
    .X(_0702_));
 sg13g2_xor2_1 _3433_ (.B(net40),
    .A(net673),
    .X(_0703_));
 sg13g2_nand2b_1 _3434_ (.Y(_0704_),
    .B(\pll_dig.dlf.INT[2] ),
    .A_N(net38));
 sg13g2_xnor2_1 _3435_ (.Y(_0705_),
    .A(net682),
    .B(net38));
 sg13g2_inv_1 _3436_ (.Y(\pll_dig.out_edges_next[0] ),
    .A(\pll_dig.out_edges[0] ));
 sg13g2_nand2_1 _3437_ (.Y(_0706_),
    .A(net37),
    .B(\pll_dig.dlf.INT[1] ));
 sg13g2_xor2_1 _3438_ (.B(net684),
    .A(net37),
    .X(_0707_));
 sg13g2_nand3_1 _3439_ (.B(net30),
    .C(_0707_),
    .A(\pll_dig.dlf.INT[0] ),
    .Y(_0708_));
 sg13g2_a21oi_1 _3440_ (.A1(_0706_),
    .A2(_0708_),
    .Y(_0709_),
    .B1(_0705_));
 sg13g2_a21oi_1 _3441_ (.A1(\pll_dig.dlf.INT[2] ),
    .A2(net38),
    .Y(_0710_),
    .B1(_0709_));
 sg13g2_nor2b_1 _3442_ (.A(net676),
    .B_N(net39),
    .Y(_0711_));
 sg13g2_nand2b_1 _3443_ (.Y(_0712_),
    .B(net676),
    .A_N(net39));
 sg13g2_nor2b_1 _3444_ (.A(_0711_),
    .B_N(_0712_),
    .Y(_0713_));
 sg13g2_nor2_1 _3445_ (.A(_0710_),
    .B(_0713_),
    .Y(_0714_));
 sg13g2_a21oi_1 _3446_ (.A1(\pll_dig.dlf.INT[3] ),
    .A2(net39),
    .Y(_0715_),
    .B1(_0714_));
 sg13g2_inv_1 _3447_ (.Y(_0503_),
    .A(\pll_dig.div_rst_cnt[3] ));
 sg13g2_nor2b_1 _3448_ (.A(_0715_),
    .B_N(_0703_),
    .Y(_0716_));
 sg13g2_a21oi_1 _3449_ (.A1(\pll_dig.dlf.INT[4] ),
    .A2(net40),
    .Y(_0717_),
    .B1(_0716_));
 sg13g2_nor2b_1 _3450_ (.A(net670),
    .B_N(net41),
    .Y(_0718_));
 sg13g2_nand2b_1 _3451_ (.Y(_0719_),
    .B(net670),
    .A_N(net41));
 sg13g2_nor2b_1 _3452_ (.A(_0718_),
    .B_N(_0719_),
    .Y(_0720_));
 sg13g2_nor2_1 _3453_ (.A(_0717_),
    .B(_0720_),
    .Y(_0721_));
 sg13g2_a21oi_1 _3454_ (.A1(net41),
    .A2(\pll_dig.dlf.INT[5] ),
    .Y(_0722_),
    .B1(_0721_));
 sg13g2_nor2b_1 _3455_ (.A(_0722_),
    .B_N(_0702_),
    .Y(_0723_));
 sg13g2_a21oi_1 _3456_ (.A1(net667),
    .A2(net42),
    .Y(_0724_),
    .B1(_0723_));
 sg13g2_nor2b_1 _3457_ (.A(net678),
    .B_N(net43),
    .Y(_0725_));
 sg13g2_inv_1 _3458_ (.Y(_0504_),
    .A(\pll_dig.dco_miss_cnt[1] ));
 sg13g2_nand2b_1 _3459_ (.Y(_0726_),
    .B(net678),
    .A_N(net43));
 sg13g2_nor2b_1 _3460_ (.A(_0725_),
    .B_N(_0726_),
    .Y(_0727_));
 sg13g2_nor2_1 _3461_ (.A(_0724_),
    .B(_0727_),
    .Y(_0728_));
 sg13g2_a21oi_1 _3462_ (.A1(net678),
    .A2(net43),
    .Y(_0729_),
    .B1(_0728_));
 sg13g2_nor2b_1 _3463_ (.A(_0729_),
    .B_N(_0701_),
    .Y(_0730_));
 sg13g2_a21oi_1 _3464_ (.A1(net122),
    .A2(net44),
    .Y(_0731_),
    .B1(_0730_));
 sg13g2_nor2b_1 _3465_ (.A(net121),
    .B_N(net45),
    .Y(_0732_));
 sg13g2_nand2b_1 _3466_ (.Y(_0733_),
    .B(net121),
    .A_N(net45));
 sg13g2_nor2b_1 _3467_ (.A(_0732_),
    .B_N(_0733_),
    .Y(_0734_));
 sg13g2_nor2_1 _3468_ (.A(_0731_),
    .B(_0734_),
    .Y(_0735_));
 sg13g2_inv_1 _3469__350 (.Y(net349),
    .A(clknet_5_4__leaf_net59_regs));
 sg13g2_a21oi_1 _3470_ (.A1(\pll_dig.dlf.INT[9] ),
    .A2(net45),
    .Y(_0736_),
    .B1(_0735_));
 sg13g2_nor2b_1 _3471_ (.A(_0736_),
    .B_N(_0700_),
    .Y(_0737_));
 sg13g2_o21ai_1 _3472_ (.B1(_0698_),
    .Y(_0738_),
    .A1(_0699_),
    .A2(_0737_));
 sg13g2_a21oi_1 _3473_ (.A1(_0696_),
    .A2(_0738_),
    .Y(_0739_),
    .B1(_0695_));
 sg13g2_a21oi_1 _3474_ (.A1(net665),
    .A2(net33),
    .Y(_0740_),
    .B1(_0739_));
 sg13g2_nand2b_1 _3475_ (.Y(_0741_),
    .B(net120),
    .A_N(net34));
 sg13g2_nor2b_1 _3476_ (.A(net120),
    .B_N(net34),
    .Y(_0742_));
 sg13g2_xnor2_1 _3477_ (.Y(_0743_),
    .A(net120),
    .B(net34));
 sg13g2_nor2_1 _3478_ (.A(_0740_),
    .B(_0743_),
    .Y(_0744_));
 sg13g2_a21oi_1 _3479_ (.A1(net690),
    .A2(net34),
    .Y(_0745_),
    .B1(_0744_));
 sg13g2_inv_1 _3480_ (.Y(_0482_),
    .A(\pll_dig.flock.cnt_filt[4] ));
 sg13g2_inv_1 _3481_ (.Y(_0505_),
    .A(\pll_dig.flock.cnt_gray[1] ));
 sg13g2_nor2_1 _3482_ (.A(_0693_),
    .B(_0745_),
    .Y(_0746_));
 sg13g2_a21oi_1 _3483_ (.A1(net658),
    .A2(net35),
    .Y(_0747_),
    .B1(_0746_));
 sg13g2_a21oi_1 _3484_ (.A1(_0689_),
    .A2(_0747_),
    .Y(_0748_),
    .B1(_0690_));
 sg13g2_nor2_1 _3485_ (.A(net131),
    .B(_0748_),
    .Y(_0749_));
 sg13g2_or3_1 _3486_ (.A(_0698_),
    .B(_0699_),
    .C(_0737_),
    .X(_0750_));
 sg13g2_nand2_1 _3487_ (.Y(_0751_),
    .A(_0738_),
    .B(_0750_));
 sg13g2_nand2_1 _3488_ (.Y(_0752_),
    .A(\SS_BBPD[0] ),
    .B(_0496_));
 sg13g2_nor2_1 _3489_ (.A(_0573_),
    .B(net31),
    .Y(_0753_));
 sg13g2_nor2b_1 _3490_ (.A(\pll_dig.dlf.INT[0] ),
    .B_N(net30),
    .Y(_0754_));
 sg13g2_nor2_1 _3491_ (.A(_0707_),
    .B(_0754_),
    .Y(_0755_));
 sg13g2_inv_1 _3492_ (.Y(_0506_),
    .A(\pll_dig.COARSE_MUX_D[0] ));
 sg13g2_nor2_1 _3493_ (.A(net37),
    .B(_0525_),
    .Y(_0756_));
 sg13g2_o21ai_1 _3494_ (.B1(_0705_),
    .Y(_0757_),
    .A1(_0755_),
    .A2(_0756_));
 sg13g2_and2_1 _3495_ (.A(_0704_),
    .B(_0757_),
    .X(_0758_));
 sg13g2_o21ai_1 _3496_ (.B1(_0712_),
    .Y(_0759_),
    .A1(_0711_),
    .A2(_0758_));
 sg13g2_nor2b_1 _3497_ (.A(_0703_),
    .B_N(_0759_),
    .Y(_0760_));
 sg13g2_a21oi_1 _3498_ (.A1(\pll_dig.dlf.INT[4] ),
    .A2(_0598_),
    .Y(_0761_),
    .B1(_0760_));
 sg13g2_o21ai_1 _3499_ (.B1(_0719_),
    .Y(_0762_),
    .A1(_0718_),
    .A2(_0761_));
 sg13g2_nor2b_1 _3500_ (.A(_0702_),
    .B_N(_0762_),
    .Y(_0763_));
 sg13g2_a21oi_1 _3501_ (.A1(net667),
    .A2(_0605_),
    .Y(_0764_),
    .B1(_0763_));
 sg13g2_o21ai_1 _3502_ (.B1(_0726_),
    .Y(_0765_),
    .A1(_0725_),
    .A2(_0764_));
 sg13g2_inv_1 _3503_ (.Y(_0507_),
    .A(\pll_dig.cnt[7] ));
 sg13g2_nor2b_1 _3504_ (.A(_0701_),
    .B_N(_0765_),
    .Y(_0766_));
 sg13g2_a21oi_1 _3505_ (.A1(net688),
    .A2(_0597_),
    .Y(_0767_),
    .B1(_0766_));
 sg13g2_o21ai_1 _3506_ (.B1(_0733_),
    .Y(_0768_),
    .A1(_0732_),
    .A2(_0767_));
 sg13g2_nor2b_1 _3507_ (.A(_0700_),
    .B_N(_0768_),
    .Y(_0769_));
 sg13g2_o21ai_1 _3508_ (.B1(_0697_),
    .Y(_0770_),
    .A1(_0753_),
    .A2(_0769_));
 sg13g2_nand2b_1 _3509_ (.Y(_0771_),
    .B(\pll_dig.dlf.INT[11] ),
    .A_N(net32));
 sg13g2_a21oi_1 _3510_ (.A1(_0770_),
    .A2(_0771_),
    .Y(_0772_),
    .B1(_0694_));
 sg13g2_a21oi_1 _3511_ (.A1(net692),
    .A2(_0608_),
    .Y(_0773_),
    .B1(_0772_));
 sg13g2_a21oi_1 _3512_ (.A1(_0741_),
    .A2(_0773_),
    .Y(_0774_),
    .B1(_0742_));
 sg13g2_a21oi_1 _3513_ (.A1(_0693_),
    .A2(_0774_),
    .Y(_0775_),
    .B1(_0691_));
 sg13g2_inv_1 _3514_ (.Y(_0508_),
    .A(\pll_dig.flock.cnt[8] ));
 sg13g2_and2_1 _3515_ (.A(net36),
    .B(_0775_),
    .X(_0776_));
 sg13g2_or2_1 _3516_ (.X(_0777_),
    .B(_0775_),
    .A(net36));
 sg13g2_o21ai_1 _3517_ (.B1(_0777_),
    .Y(_0778_),
    .A1(net657),
    .A2(_0776_));
 sg13g2_nor2b_1 _3518_ (.A(_0752_),
    .B_N(_0778_),
    .Y(_0779_));
 sg13g2_or3_1 _3519_ (.A(_0697_),
    .B(_0753_),
    .C(_0769_),
    .X(_0780_));
 sg13g2_nand3_1 _3520_ (.B(net65),
    .C(_0780_),
    .A(_0770_),
    .Y(_0781_));
 sg13g2_o21ai_1 _3521_ (.B1(_0752_),
    .Y(_0782_),
    .A1(\SS_BBPD[0] ),
    .A2(net680));
 sg13g2_a22oi_1 _3522_ (.Y(\pll_dig.dlf.OUT_C[11] ),
    .B1(_0781_),
    .B2(_0782_),
    .A2(_0751_),
    .A1(net61));
 sg13g2_nand3_1 _3523_ (.B(\pll_dig.out_edges[0] ),
    .C(\pll_dig.out_edges[2] ),
    .A(\pll_dig.out_edges[1] ),
    .Y(_0783_));
 sg13g2_nor2_1 _3524_ (.A(_0521_),
    .B(_0783_),
    .Y(_0784_));
 sg13g2_inv_1 _3525_ (.Y(_0509_),
    .A(\pll_dig.flock.cnt_bin[10] ));
 sg13g2_and3_1 _3526_ (.X(_0785_),
    .A(\pll_dig.out_edges[5] ),
    .B(\pll_dig.out_edges[4] ),
    .C(_0784_));
 sg13g2_nand3_1 _3527_ (.B(\pll_dig.out_edges[4] ),
    .C(_0784_),
    .A(\pll_dig.out_edges[5] ),
    .Y(_0786_));
 sg13g2_a21oi_1 _3528_ (.A1(\pll_dig.out_edges[4] ),
    .A2(_0784_),
    .Y(_0787_),
    .B1(\pll_dig.out_edges[5] ));
 sg13g2_nor2_1 _3529_ (.A(_0785_),
    .B(_0787_),
    .Y(\pll_dig.out_edges_next[5] ));
 sg13g2_nand2_1 _3530_ (.Y(_0788_),
    .A(\pll_dig.out_edges[6] ),
    .B(_0785_));
 sg13g2_nor2_1 _3531_ (.A(_0493_),
    .B(_0788_),
    .Y(_0789_));
 sg13g2_nor2_1 _3532_ (.A(\pll_dig.out_edges[8] ),
    .B(_0789_),
    .Y(_0790_));
 sg13g2_xnor2_1 _3533_ (.Y(_0008_),
    .A(\pll_dig.out_edges[9] ),
    .B(_0790_));
 sg13g2_nor2_1 _3534_ (.A(\pll_dig.out_edges[6] ),
    .B(_0785_),
    .Y(_0791_));
 sg13g2_xnor2_1 _3535_ (.Y(\pll_dig.out_edges_next[6] ),
    .A(\pll_dig.out_edges[6] ),
    .B(_0786_));
 sg13g2_inv_1 _3536_ (.Y(_0510_),
    .A(\pll_dig.div.leave_req ));
 sg13g2_nor2_1 _3537_ (.A(\pll_dig.out_edges[4] ),
    .B(_0784_),
    .Y(_0792_));
 sg13g2_xnor2_1 _3538_ (.Y(_0004_),
    .A(\pll_dig.out_edges[5] ),
    .B(_0792_));
 sg13g2_xnor2_1 _3539_ (.Y(_0005_),
    .A(\pll_dig.out_edges[6] ),
    .B(_0787_));
 sg13g2_xor2_1 _3540_ (.B(\pll_dig.flock.cnt_gray_s2[14] ),
    .A(\pll_dig.flock.cnt_gray_s2[15] ),
    .X(_0137_));
 sg13g2_xnor2_1 _3541_ (.Y(_0793_),
    .A(\pll_dig.flock.cnt_gray_s2[13] ),
    .B(_0137_));
 sg13g2_inv_1 _3542_ (.Y(_0136_),
    .A(_0793_));
 sg13g2_a22oi_1 _3543_ (.Y(_0794_),
    .B1(_0536_),
    .B2(\pll_dig.flock.cnt_filt[7] ),
    .A2(_0490_),
    .A1(\pll_dig.flock.cnt_filt[6] ));
 sg13g2_nand2_1 _3544_ (.Y(_0795_),
    .A(_0481_),
    .B(net11));
 sg13g2_nand2_1 _3545_ (.Y(_0796_),
    .A(net12),
    .B(_0580_));
 sg13g2_nand3_1 _3546_ (.B(_0795_),
    .C(_0796_),
    .A(_0794_),
    .Y(_0797_));
 sg13g2_inv_1 _3547_ (.Y(_0511_),
    .A(net243));
 sg13g2_nand2b_1 _3548_ (.Y(_0798_),
    .B(\pll_dig.flock.cnt_filt[5] ),
    .A_N(net10));
 sg13g2_nor2b_1 _3549_ (.A(\pll_dig.flock.cnt_filt[4] ),
    .B_N(net9),
    .Y(_0799_));
 sg13g2_nor2b_1 _3550_ (.A(\pll_dig.flock.cnt_filt[5] ),
    .B_N(net10),
    .Y(_0800_));
 sg13g2_nor2_1 _3551_ (.A(_0799_),
    .B(_0800_),
    .Y(_0801_));
 sg13g2_a22oi_1 _3552_ (.Y(_0802_),
    .B1(_0538_),
    .B2(\pll_dig.flock.cnt_filt[3] ),
    .A2(_0489_),
    .A1(\pll_dig.flock.cnt_filt[2] ));
 sg13g2_nor2_1 _3553_ (.A(\pll_dig.flock.cnt_filt[3] ),
    .B(_0538_),
    .Y(_0803_));
 sg13g2_a21oi_1 _3554_ (.A1(_0485_),
    .A2(net7),
    .Y(_0804_),
    .B1(_0803_));
 sg13g2_nand2_1 _3555_ (.Y(_0805_),
    .A(_0802_),
    .B(_0804_));
 sg13g2_nand2_1 _3556_ (.Y(_0806_),
    .A(_0487_),
    .B(net6));
 sg13g2_o21ai_1 _3557_ (.B1(_0806_),
    .Y(_0807_),
    .A1(\pll_dig.flock.cnt_filt[0] ),
    .A2(_0123_));
 sg13g2_inv_1 _3558_ (.Y(_0512_),
    .A(\pll_dig.flock.FCW_NA[6] ));
 sg13g2_nand2b_1 _3559_ (.Y(_0808_),
    .B(\pll_dig.flock.cnt_filt[1] ),
    .A_N(net6));
 sg13g2_a21oi_1 _3560_ (.A1(_0807_),
    .A2(_0808_),
    .Y(_0809_),
    .B1(_0805_));
 sg13g2_nand2b_1 _3561_ (.Y(_0810_),
    .B(\pll_dig.flock.cnt_filt[4] ),
    .A_N(net9));
 sg13g2_o21ai_1 _3562_ (.B1(_0810_),
    .Y(_0811_),
    .A1(_0802_),
    .A2(_0803_));
 sg13g2_o21ai_1 _3563_ (.B1(_0801_),
    .Y(_0812_),
    .A1(_0809_),
    .A2(_0811_));
 sg13g2_a21oi_1 _3564_ (.A1(_0798_),
    .A2(_0812_),
    .Y(_0813_),
    .B1(_0797_));
 sg13g2_nor4_1 _3565_ (.A(\pll_dig.flock.cnt_filt[14] ),
    .B(\pll_dig.flock.cnt_filt[15] ),
    .C(\pll_dig.flock.cnt_filt[13] ),
    .D(\pll_dig.flock.cnt_filt[12] ),
    .Y(_0814_));
 sg13g2_or2_1 _3566_ (.X(_0815_),
    .B(\pll_dig.flock.cnt_filt[11] ),
    .A(\pll_dig.flock.cnt_filt[10] ));
 sg13g2_nor3_1 _3567_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .C(_0815_),
    .Y(_0816_));
 sg13g2_nand2_1 _3568_ (.Y(_0817_),
    .A(_0814_),
    .B(_0816_));
 sg13g2_inv_1 _3569_ (.Y(_0513_),
    .A(\pll_dig.flock.FCW_NA[3] ));
 sg13g2_nor2b_1 _3570_ (.A(_0794_),
    .B_N(_0796_),
    .Y(_0818_));
 sg13g2_nor3_1 _3571_ (.A(_0813_),
    .B(_0817_),
    .C(_0818_),
    .Y(_0819_));
 sg13g2_nand2_1 _3572_ (.Y(_0820_),
    .A(net581),
    .B(\pll_dig.PHASE_LOCK ));
 sg13g2_a21oi_1 _3573_ (.A1(_0819_),
    .A2(net582),
    .Y(_0821_),
    .B1(\pll_dig.FORCE_N ));
 sg13g2_nand2_1 _3574_ (.Y(_0822_),
    .A(\pll_dig.flock.cnt_filt[0] ),
    .B(_0123_));
 sg13g2_nand4_1 _3575_ (.B(_0808_),
    .C(_0810_),
    .A(_0798_),
    .Y(_0823_),
    .D(_0822_));
 sg13g2_nor4_1 _3576_ (.A(_0799_),
    .B(_0800_),
    .C(_0807_),
    .D(_0823_),
    .Y(_0824_));
 sg13g2_nor3_1 _3577_ (.A(_0797_),
    .B(_0805_),
    .C(_0817_),
    .Y(_0825_));
 sg13g2_a221oi_1 _3578_ (.B2(_0825_),
    .C1(_0819_),
    .B1(_0824_),
    .A1(net581),
    .Y(_0826_),
    .A2(\pll_dig.PHASE_LOCK ));
 sg13g2_nor2_1 _3579_ (.A(\pll_dig.FORCE_P ),
    .B(_0826_),
    .Y(_0827_));
 sg13g2_inv_1 _3580_ (.Y(_0514_),
    .A(\pll_dig.flock.FCW_PA[1] ));
 sg13g2_nor2b_1 _3581_ (.A(_0827_),
    .B_N(\pll_dig.flock.started ),
    .Y(_0828_));
 sg13g2_and2_1 _3582_ (.A(_0821_),
    .B(_0828_),
    .X(_0829_));
 sg13g2_nand2_1 _3583_ (.Y(_0830_),
    .A(\pll_dig.MID_MUX_D[14] ),
    .B(net583));
 sg13g2_nor2_1 _3584_ (.A(\pll_dig.flock.cnt_coarse_wait[0] ),
    .B(\pll_dig.flock.cnt_coarse_wait[1] ),
    .Y(_0831_));
 sg13g2_nand2b_1 _3585_ (.Y(_0832_),
    .B(_0831_),
    .A_N(\pll_dig.flock.cnt_coarse_wait[2] ));
 sg13g2_nor2_1 _3586_ (.A(\pll_dig.flock.cnt_coarse_wait[3] ),
    .B(_0832_),
    .Y(_0833_));
 sg13g2_nor3_1 _3587_ (.A(\pll_dig.flock.cnt_coarse_wait[3] ),
    .B(\pll_dig.flock.cnt_coarse_wait[4] ),
    .C(_0832_),
    .Y(_0834_));
 sg13g2_nor2b_1 _3588_ (.A(\pll_dig.flock.cnt_coarse_wait[5] ),
    .B_N(_0834_),
    .Y(_0835_));
 sg13g2_nor2b_1 _3589_ (.A(\pll_dig.flock.cnt_coarse_wait[6] ),
    .B_N(_0835_),
    .Y(_0836_));
 sg13g2_nor2b_1 _3590_ (.A(\pll_dig.flock.cnt_coarse_wait[7] ),
    .B_N(_0836_),
    .Y(_0837_));
 sg13g2_inv_1 _3591_ (.Y(_0483_),
    .A(\pll_dig.flock.cnt_filt[5] ));
 sg13g2_inv_1 _3592_ (.Y(_0515_),
    .A(\pll_dig.flock.FCW_PA[5] ));
 sg13g2_nand2b_1 _3593_ (.Y(_0838_),
    .B(_0836_),
    .A_N(\pll_dig.flock.cnt_coarse_wait[7] ));
 sg13g2_nand2_1 _3594_ (.Y(_0839_),
    .A(\pll_dig.COARSE_MUX_D[14] ),
    .B(_0837_));
 sg13g2_nor2_1 _3595_ (.A(_0830_),
    .B(_0839_),
    .Y(_0840_));
 sg13g2_nor2b_1 _3596_ (.A(_0821_),
    .B_N(\pll_dig.flock.started ),
    .Y(_0841_));
 sg13g2_nand2b_1 _3597_ (.Y(_0842_),
    .B(net92),
    .A_N(\pll_dig.MID_MUX_D[0] ));
 sg13g2_nor3_1 _3598_ (.A(\pll_dig.COARSE_MUX_D[0] ),
    .B(_0838_),
    .C(_0842_),
    .Y(_0843_));
 sg13g2_nor2_1 _3599_ (.A(_0840_),
    .B(_0843_),
    .Y(_0844_));
 sg13g2_nand2_1 _3600_ (.Y(_0845_),
    .A(_0830_),
    .B(_0842_));
 sg13g2_nand2_1 _3601_ (.Y(_0846_),
    .A(_0838_),
    .B(_0845_));
 sg13g2_xnor2_1 _3602_ (.Y(_0847_),
    .A(\pll_dig.flock.cnt_coarse_wait[6] ),
    .B(_0835_));
 sg13g2_inv_1 _3603_ (.Y(_0516_),
    .A(\pll_dig.dsm_impl.FCWI[2] ));
 sg13g2_o21ai_1 _3604_ (.B1(net70),
    .Y(_0019_),
    .A1(_0846_),
    .A2(_0847_));
 sg13g2_xnor2_1 _3605_ (.Y(_0848_),
    .A(\pll_dig.flock.cnt_coarse_wait[4] ),
    .B(_0833_));
 sg13g2_o21ai_1 _3606_ (.B1(net70),
    .Y(_0017_),
    .A1(_0846_),
    .A2(_0848_));
 sg13g2_xor2_1 _3607_ (.B(_0784_),
    .A(\pll_dig.out_edges[4] ),
    .X(\pll_dig.out_edges_next[4] ));
 sg13g2_and2_1 _3608_ (.A(_0521_),
    .B(_0783_),
    .X(_0849_));
 sg13g2_xnor2_1 _3609_ (.Y(_0003_),
    .A(\pll_dig.out_edges[4] ),
    .B(_0849_));
 sg13g2_xor2_1 _3610_ (.B(\pll_dig.out_edges[0] ),
    .A(\pll_dig.out_edges[1] ),
    .X(\pll_dig.out_edges_next[1] ));
 sg13g2_nand3_1 _3611_ (.B(\pll_dig.div_rst_cnt[1] ),
    .C(\pll_dig.div_rst_cnt[2] ),
    .A(\pll_dig.div_rst_cnt[0] ),
    .Y(_0850_));
 sg13g2_o21ai_1 _3612_ (.B1(_0503_),
    .Y(_0471_),
    .A1(net134),
    .A2(_0850_));
 sg13g2_nor2b_1 _3613_ (.A(\pll_dig.clr_r2 ),
    .B_N(\pll_dig.clr_r3 ),
    .Y(_0851_));
 sg13g2_inv_1 _3614_ (.Y(_0517_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ));
 sg13g2_o21ai_1 _3615_ (.B1(\pll_dig.ref_fail ),
    .Y(_0852_),
    .A1(_0561_),
    .A2(\pll_dig.clr_r3 ));
 sg13g2_o21ai_1 _3616_ (.B1(_0618_),
    .Y(_0463_),
    .A1(_0851_),
    .A2(_0852_));
 sg13g2_nand2b_1 _3617_ (.Y(_0853_),
    .B(\pll_dig.out_edges_g2[8] ),
    .A_N(\pll_dig.out_edges_g2_q[8] ));
 sg13g2_nand2b_1 _3618_ (.Y(_0854_),
    .B(\pll_dig.out_edges_g2_q[8] ),
    .A_N(\pll_dig.out_edges_g2[8] ));
 sg13g2_a22oi_1 _3619_ (.Y(_0855_),
    .B1(\pll_dig.out_edges_g2[9] ),
    .B2(_0578_),
    .A2(\pll_dig.out_edges_g2_q[2] ),
    .A1(_0564_));
 sg13g2_nand2b_1 _3620_ (.Y(_0856_),
    .B(\pll_dig.out_edges_g2_q[9] ),
    .A_N(\pll_dig.out_edges_g2[9] ));
 sg13g2_a22oi_1 _3621_ (.Y(_0857_),
    .B1(\pll_dig.out_edges_g2[2] ),
    .B2(_0565_),
    .A2(_0563_),
    .A1(\pll_dig.out_edges_g2[4] ));
 sg13g2_xor2_1 _3622_ (.B(\pll_dig.out_edges_g2_q[7] ),
    .A(\pll_dig.out_edges_g2[7] ),
    .X(_0858_));
 sg13g2_o21ai_1 _3623_ (.B1(_0856_),
    .Y(_0859_),
    .A1(_0566_),
    .A2(\pll_dig.out_edges_g2_q[0] ));
 sg13g2_xnor2_1 _3624_ (.Y(_0860_),
    .A(\pll_dig.out_edges_g2[5] ),
    .B(\pll_dig.out_edges_g2_q[5] ));
 sg13g2_inv_1 _3625_ (.Y(_0518_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[4] ));
 sg13g2_xor2_1 _3626_ (.B(\pll_dig.out_edges_g2_q[3] ),
    .A(\pll_dig.out_edges_g2[3] ),
    .X(_0861_));
 sg13g2_nand2b_1 _3627_ (.Y(_0862_),
    .B(\pll_dig.out_edges_g2_q[6] ),
    .A_N(\pll_dig.out_edges_g2[6] ));
 sg13g2_xnor2_1 _3628_ (.Y(_0863_),
    .A(\pll_dig.out_edges_g2[1] ),
    .B(\pll_dig.out_edges_g2_q[1] ));
 sg13g2_nand4_1 _3629_ (.B(_0853_),
    .C(_0860_),
    .A(\pll_dig.locked_q ),
    .Y(_0864_),
    .D(_0863_));
 sg13g2_o21ai_1 _3630_ (.B1(_0854_),
    .Y(_0865_),
    .A1(\pll_dig.out_edges_g2[4] ),
    .A2(_0563_));
 sg13g2_or4_1 _3631_ (.A(_0858_),
    .B(_0859_),
    .C(_0861_),
    .D(_0865_),
    .X(_0866_));
 sg13g2_a22oi_1 _3632_ (.Y(_0867_),
    .B1(_0566_),
    .B2(\pll_dig.out_edges_g2_q[0] ),
    .A2(_0562_),
    .A1(\pll_dig.out_edges_g2[6] ));
 sg13g2_nand4_1 _3633_ (.B(_0857_),
    .C(_0862_),
    .A(_0855_),
    .Y(_0868_),
    .D(_0867_));
 sg13g2_or3_1 _3634_ (.A(_0864_),
    .B(_0866_),
    .C(_0868_),
    .X(_0869_));
 sg13g2_o21ai_1 _3635_ (.B1(\pll_dig.dco_miss_cnt[0] ),
    .Y(_0870_),
    .A1(_0611_),
    .A2(_0869_));
 sg13g2_inv_1 _3636_ (.Y(_0519_),
    .A(\pll_dig.MID_MUX_D[9] ));
 sg13g2_and2_1 _3637_ (.A(\pll_dig.dco_miss_cnt[1] ),
    .B(\pll_dig.dco_miss_cnt[0] ),
    .X(_0871_));
 sg13g2_a221oi_1 _3638_ (.B2(_0611_),
    .C1(_0869_),
    .B1(_0871_),
    .A1(_0504_),
    .Y(_0462_),
    .A2(_0870_));
 sg13g2_nand3_1 _3639_ (.B(\pll_dig.div.cnt[2] ),
    .C(\pll_dig.div.cnt[1] ),
    .A(\pll_dig.div.cnt[0] ),
    .Y(_0872_));
 sg13g2_nor2_2 _3640_ (.A(_0872_),
    .B(_0619_),
    .Y(_0873_));
 sg13g2_xnor2_1 _3641_ (.Y(_0874_),
    .A(net383),
    .B(_0619_));
 sg13g2_a21o_1 _3642_ (.A2(\pll_dig.div.cnt[1] ),
    .A1(\pll_dig.div.cnt[0] ),
    .B1(\pll_dig.div.cnt[2] ),
    .X(_0875_));
 sg13g2_nand2_2 _3643_ (.Y(_0876_),
    .A(net385),
    .B(_0875_));
 sg13g2_nor2_1 _3644_ (.A(\pll_dig.div.low_count[2] ),
    .B(net436),
    .Y(_0877_));
 sg13g2_xnor2_1 _3645_ (.Y(_0878_),
    .A(net400),
    .B(net402));
 sg13g2_nor2_1 _3646_ (.A(\pll_dig.div.low_count[1] ),
    .B(net400),
    .Y(_0879_));
 sg13g2_inv_1 _3647_ (.Y(_0520_),
    .A(net105));
 sg13g2_nor3_1 _3648_ (.A(_0479_),
    .B(_0163_),
    .C(_0879_),
    .Y(_0880_));
 sg13g2_a221oi_1 _3649_ (.B2(\pll_dig.div.low_count[1] ),
    .C1(_0880_),
    .B1(_0878_),
    .A1(_0876_),
    .Y(_0881_),
    .A2(\pll_dig.div.low_count[2] ));
 sg13g2_nor2_2 _3650_ (.A(_0881_),
    .B(_0877_),
    .Y(_0882_));
 sg13g2_o21ai_1 _3651_ (.B1(_0882_),
    .Y(_0883_),
    .A1(\pll_dig.div.low_count[3] ),
    .A2(_0874_));
 sg13g2_xnor2_1 _3652_ (.Y(_0884_),
    .A(_0873_),
    .B(\pll_dig.div.cnt[4] ));
 sg13g2_a22oi_1 _3653_ (.Y(_0885_),
    .B1(\pll_dig.div.low_count[4] ),
    .B2(_0884_),
    .A2(_0874_),
    .A1(\pll_dig.div.low_count[3] ));
 sg13g2_nand3_1 _3654_ (.B(\pll_dig.div.cnt[5] ),
    .C(\pll_dig.div.cnt[4] ),
    .A(_0873_),
    .Y(_0886_));
 sg13g2_a21o_1 _3655_ (.A2(net386),
    .A1(\pll_dig.div.cnt[4] ),
    .B1(\pll_dig.div.cnt[5] ),
    .X(_0887_));
 sg13g2_nand2_2 _3656_ (.Y(_0888_),
    .A(_0887_),
    .B(net394));
 sg13g2_nor2_1 _3657_ (.A(\pll_dig.div.low_count[4] ),
    .B(_0884_),
    .Y(_0889_));
 sg13g2_inv_1 _3658_ (.Y(_0521_),
    .A(\pll_dig.out_edges[3] ));
 sg13g2_a21oi_2 _3659_ (.B1(_0889_),
    .Y(_0890_),
    .A2(_0885_),
    .A1(_0883_));
 sg13g2_o21ai_1 _3660_ (.B1(_0890_),
    .Y(_0891_),
    .A1(_0888_),
    .A2(\pll_dig.div.low_count[5] ));
 sg13g2_nand4_1 _3661_ (.B(\pll_dig.div.cnt[5] ),
    .C(\pll_dig.div.cnt[6] ),
    .A(net386),
    .Y(_0892_),
    .D(\pll_dig.div.cnt[4] ));
 sg13g2_xor2_1 _3662_ (.B(\pll_dig.div.cnt[6] ),
    .A(_0886_),
    .X(_0893_));
 sg13g2_a22oi_1 _3663_ (.Y(_0894_),
    .B1(\pll_dig.div.low_count[6] ),
    .B2(_0893_),
    .A2(_0888_),
    .A1(\pll_dig.div.low_count[5] ));
 sg13g2_xor2_1 _3664_ (.B(\pll_dig.div.cnt[7] ),
    .A(_0892_),
    .X(_0895_));
 sg13g2_o21ai_1 _3665_ (.B1(_0895_),
    .Y(_0896_),
    .A1(\pll_dig.div.low_count[6] ),
    .A2(_0893_));
 sg13g2_a21oi_2 _3666_ (.B1(_0896_),
    .Y(_0897_),
    .A2(_0891_),
    .A1(_0894_));
 sg13g2_nand3_1 _3667_ (.B(_0511_),
    .C(\pll_dig.div.pend ),
    .A(_0494_),
    .Y(_0898_));
 sg13g2_or4_1 _3668_ (.A(\pll_dig.div.leave_req ),
    .B(\pll_dig.div.use_clk_p ),
    .C(_0898_),
    .D(_0897_),
    .X(_0899_));
 sg13g2_inv_1 _3669_ (.Y(_0522_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ));
 sg13g2_and2_2 _3670_ (.A(_0899_),
    .B(_0510_),
    .X(_0900_));
 sg13g2_nor2_2 _3671_ (.A(_0900_),
    .B(\pll_dig.div.use_clk_p ),
    .Y(_0062_));
 sg13g2_mux2_1 _3672_ (.A0(net406),
    .A1(_0157_),
    .S(net384),
    .X(_0460_));
 sg13g2_nor2_1 _3673_ (.A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .Y(_0901_));
 sg13g2_or2_1 _3674_ (.X(_0902_),
    .B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ));
 sg13g2_xnor2_1 _3675_ (.Y(_0459_),
    .A(net427),
    .B(net124));
 sg13g2_and3_2 _3676_ (.X(_0903_),
    .A(\pll_dig.flock.cnt[1] ),
    .B(\pll_dig.flock.cnt[3] ),
    .C(\pll_dig.flock.cnt[2] ));
 sg13g2_and3_2 _3677_ (.X(_0904_),
    .A(\pll_dig.flock.cnt[5] ),
    .B(\pll_dig.flock.cnt[4] ),
    .C(_0903_));
 sg13g2_nand3_1 _3678_ (.B(\pll_dig.flock.cnt[6] ),
    .C(\pll_dig.flock.cnt[7] ),
    .A(_0904_),
    .Y(_0905_));
 sg13g2_nor2_2 _3679_ (.A(_0905_),
    .B(_0508_),
    .Y(_0906_));
 sg13g2_inv_1 _3680_ (.Y(_0523_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[8] ));
 sg13g2_nand2_1 _3681_ (.Y(_0907_),
    .A(net127),
    .B(net419));
 sg13g2_nand3_1 _3682_ (.B(net126),
    .C(net423),
    .A(\pll_dig.flock.cnt[6] ),
    .Y(_0908_));
 sg13g2_xnor2_1 _3683_ (.Y(_0458_),
    .A(\pll_dig.flock.cnt[9] ),
    .B(_0907_));
 sg13g2_xnor2_1 _3684_ (.Y(_0909_),
    .A(net427),
    .B(net426));
 sg13g2_a21oi_1 _3685_ (.A1(net427),
    .A2(net426),
    .Y(_0910_),
    .B1(net428));
 sg13g2_nor2_1 _3686_ (.A(net125),
    .B(_0910_),
    .Y(_0911_));
 sg13g2_nor3_1 _3687_ (.A(net125),
    .B(net420),
    .C(_0910_),
    .Y(_0912_));
 sg13g2_nor2_1 _3688_ (.A(net125),
    .B(_0909_),
    .Y(_0913_));
 sg13g2_a22oi_1 _3689_ (.Y(_0914_),
    .B1(_0913_),
    .B2(_0604_),
    .A2(_0912_),
    .A1(_0909_));
 sg13g2_o21ai_1 _3690_ (.B1(_0914_),
    .Y(_0457_),
    .A1(_0505_),
    .A2(net129));
 sg13g2_inv_1 _3691_ (.Y(_0524_),
    .A(\pll_dig.dlf.INT[2] ));
 sg13g2_nor2_1 _3692_ (.A(\pll_dig.flock.cnt_gray[9] ),
    .B(net130),
    .Y(_0915_));
 sg13g2_a21oi_1 _3693_ (.A1(\pll_dig.flock.cnt[9] ),
    .A2(net419),
    .Y(_0916_),
    .B1(\pll_dig.flock.cnt[10] ));
 sg13g2_xnor2_1 _3694_ (.Y(_0917_),
    .A(_0529_),
    .B(_0916_));
 sg13g2_a21oi_1 _3695_ (.A1(net130),
    .A2(_0917_),
    .Y(_0456_),
    .B1(_0915_));
 sg13g2_nand4_1 _3696_ (.B(\pll_dig.ref_wd.cnt[1] ),
    .C(\pll_dig.ref_wd.cnt[3] ),
    .A(\pll_dig.ref_wd.cnt[2] ),
    .Y(_0918_),
    .D(\pll_dig.ref_wd.cnt[0] ));
 sg13g2_nand2_1 _3697_ (.Y(_0919_),
    .A(\pll_dig.ref_wd.cnt[6] ),
    .B(\pll_dig.ref_wd.cnt[5] ));
 sg13g2_nor3_1 _3698_ (.A(_0592_),
    .B(_0918_),
    .C(_0919_),
    .Y(_0920_));
 sg13g2_nor3_1 _3699_ (.A(\pll_dig.ref_wd.cnt[9] ),
    .B(_0592_),
    .C(_0918_),
    .Y(_0921_));
 sg13g2_and2_1 _3700_ (.A(\pll_dig.ref_wd.cnt[5] ),
    .B(_0921_),
    .X(_0922_));
 sg13g2_and2_1 _3701_ (.A(_0587_),
    .B(_0920_),
    .X(_0923_));
 sg13g2_inv_1 _3702_ (.Y(_0484_),
    .A(\pll_dig.flock.cnt_filt[3] ));
 sg13g2_inv_1 _3703_ (.Y(_0525_),
    .A(\pll_dig.dlf.INT[1] ));
 sg13g2_and2_1 _3704_ (.A(\pll_dig.ref_wd.cnt[7] ),
    .B(_0923_),
    .X(_0924_));
 sg13g2_xor2_1 _3705_ (.B(\pll_dig.ref_wd.watch_s3 ),
    .A(\pll_dig.ref_wd.watch_s2 ),
    .X(_0925_));
 sg13g2_xnor2_1 _3706_ (.Y(_0926_),
    .A(\pll_dig.ref_wd.watch_s2 ),
    .B(\pll_dig.ref_wd.watch_s3 ));
 sg13g2_o21ai_1 _3707_ (.B1(net123),
    .Y(_0927_),
    .A1(\pll_dig.ref_wd.cnt[7] ),
    .A2(_0923_));
 sg13g2_nor2_1 _3708_ (.A(_0924_),
    .B(_0927_),
    .Y(_0454_));
 sg13g2_nand3_1 _3709_ (.B(_0706_),
    .C(_0708_),
    .A(_0705_),
    .Y(_0928_));
 sg13g2_nand2b_1 _3710_ (.Y(_0929_),
    .B(_0928_),
    .A_N(_0709_));
 sg13g2_or3_1 _3711_ (.A(_0705_),
    .B(_0755_),
    .C(_0756_),
    .X(_0930_));
 sg13g2_nand3_1 _3712_ (.B(net65),
    .C(_0930_),
    .A(_0757_),
    .Y(_0931_));
 sg13g2_o21ai_1 _3713_ (.B1(_0752_),
    .Y(_0932_),
    .A1(\SS_BBPD[0] ),
    .A2(net682));
 sg13g2_inv_1 _3714_ (.Y(_0526_),
    .A(net473));
 sg13g2_a22oi_1 _3715_ (.Y(\pll_dig.dlf.OUT_C[2] ),
    .B1(_0931_),
    .B2(_0932_),
    .A2(_0929_),
    .A1(net61));
 sg13g2_or2_1 _3716_ (.X(_0051_),
    .B(\pll_dig.dco_fail ),
    .A(\pll_dig.ref_fail ));
 sg13g2_xnor2_1 _3717_ (.Y(_0135_),
    .A(\pll_dig.flock.cnt_gray_s2[12] ),
    .B(_0793_));
 sg13g2_xnor2_1 _3718_ (.Y(_0933_),
    .A(\pll_dig.flock.cnt_gray_s2[11] ),
    .B(_0135_));
 sg13g2_inv_1 _3719_ (.Y(_0134_),
    .A(_0933_));
 sg13g2_xnor2_1 _3720_ (.Y(_0133_),
    .A(\pll_dig.flock.cnt_gray_s2[10] ),
    .B(_0933_));
 sg13g2_xnor2_1 _3721_ (.Y(_0934_),
    .A(\pll_dig.flock.cnt_gray_s2[9] ),
    .B(_0133_));
 sg13g2_inv_1 _3722_ (.Y(_0146_),
    .A(_0934_));
 sg13g2_nand2_1 _3723_ (.Y(_0935_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .B(\pll_dig.dsm_impl.FCWF[11] ));
 sg13g2_nand2_1 _3724_ (.Y(_0936_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(\pll_dig.dsm_impl.FCWF[7] ));
 sg13g2_inv_1 _3725_ (.Y(_0527_),
    .A(\pll_dig.COARSE_MUX_D[12] ));
 sg13g2_and2_1 _3726_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .B(\pll_dig.dsm_impl.FCWF[6] ),
    .X(_0937_));
 sg13g2_nand2_1 _3727_ (.Y(_0938_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .B(\pll_dig.dsm_impl.FCWF[5] ));
 sg13g2_and2_1 _3728_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .B(\pll_dig.dsm_impl.FCWF[4] ),
    .X(_0939_));
 sg13g2_nand2_1 _3729_ (.Y(_0940_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .B(\pll_dig.dsm_impl.FCWF[3] ));
 sg13g2_and2_1 _3730_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B(\pll_dig.dsm_impl.FCWF[2] ),
    .X(_0941_));
 sg13g2_nand2_1 _3731_ (.Y(_0942_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .B(\pll_dig.dsm_impl.FCWF[1] ));
 sg13g2_nand2_1 _3732_ (.Y(_0943_),
    .A(net381),
    .B(\pll_dig.dsm_impl.FCWF[0] ));
 sg13g2_xor2_1 _3733_ (.B(\pll_dig.dsm_impl.FCWF[0] ),
    .A(net381),
    .X(_0944_));
 sg13g2_nand2_1 _3734_ (.Y(_0945_),
    .A(\pll_dig.dsm_impl.dsm.cin_stg1 ),
    .B(_0944_));
 sg13g2_xnor2_1 _3735_ (.Y(_0946_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .B(\pll_dig.dsm_impl.FCWF[1] ));
 sg13g2_inv_1 _3736_ (.Y(_0528_),
    .A(\pll_dig.flock.cnt[13] ));
 sg13g2_a21o_1 _3737_ (.A2(_0945_),
    .A1(_0943_),
    .B1(_0946_),
    .X(_0947_));
 sg13g2_xnor2_1 _3738_ (.Y(_0948_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B(\pll_dig.dsm_impl.FCWF[2] ));
 sg13g2_a21oi_1 _3739_ (.A1(_0942_),
    .A2(_0947_),
    .Y(_0949_),
    .B1(_0948_));
 sg13g2_xor2_1 _3740_ (.B(\pll_dig.dsm_impl.FCWF[3] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .X(_0950_));
 sg13g2_o21ai_1 _3741_ (.B1(_0950_),
    .Y(_0951_),
    .A1(_0941_),
    .A2(_0949_));
 sg13g2_xnor2_1 _3742_ (.Y(_0952_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .B(\pll_dig.dsm_impl.FCWF[4] ));
 sg13g2_a21oi_1 _3743_ (.A1(_0940_),
    .A2(_0951_),
    .Y(_0953_),
    .B1(_0952_));
 sg13g2_xor2_1 _3744_ (.B(\pll_dig.dsm_impl.FCWF[5] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .X(_0954_));
 sg13g2_o21ai_1 _3745_ (.B1(_0954_),
    .Y(_0955_),
    .A1(_0939_),
    .A2(_0953_));
 sg13g2_xnor2_1 _3746_ (.Y(_0956_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .B(\pll_dig.dsm_impl.FCWF[6] ));
 sg13g2_inv_1 _3747_ (.Y(_0529_),
    .A(\pll_dig.flock.cnt[11] ));
 sg13g2_a21oi_1 _3748_ (.A1(_0938_),
    .A2(_0955_),
    .Y(_0957_),
    .B1(_0956_));
 sg13g2_xor2_1 _3749_ (.B(\pll_dig.dsm_impl.FCWF[7] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .X(_0958_));
 sg13g2_o21ai_1 _3750_ (.B1(_0958_),
    .Y(_0959_),
    .A1(_0937_),
    .A2(_0957_));
 sg13g2_xnor2_1 _3751_ (.Y(_0960_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .B(\pll_dig.dsm_impl.FCWF[8] ));
 sg13g2_a21oi_1 _3752_ (.A1(_0936_),
    .A2(_0959_),
    .Y(_0961_),
    .B1(_0960_));
 sg13g2_a21oi_1 _3753_ (.A1(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .A2(\pll_dig.dsm_impl.FCWF[8] ),
    .Y(_0962_),
    .B1(_0961_));
 sg13g2_xnor2_1 _3754_ (.Y(_0963_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .B(\pll_dig.dsm_impl.FCWF[9] ));
 sg13g2_nor2_1 _3755_ (.A(_0962_),
    .B(_0963_),
    .Y(_0964_));
 sg13g2_a21oi_1 _3756_ (.A1(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .A2(\pll_dig.dsm_impl.FCWF[9] ),
    .Y(_0965_),
    .B1(_0964_));
 sg13g2_nor2_1 _3757_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .B(\pll_dig.dsm_impl.FCWF[11] ),
    .Y(_0966_));
 sg13g2_inv_1 _3758_ (.Y(_0530_),
    .A(\pll_dig.MID_MUX_D[14] ));
 sg13g2_xnor2_1 _3759_ (.Y(_0967_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .B(\pll_dig.dsm_impl.FCWF[10] ));
 sg13g2_nor2_1 _3760_ (.A(_0965_),
    .B(_0967_),
    .Y(_0968_));
 sg13g2_a21oi_1 _3761_ (.A1(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .A2(\pll_dig.dsm_impl.FCWF[10] ),
    .Y(_0969_),
    .B1(_0968_));
 sg13g2_o21ai_1 _3762_ (.B1(_0935_),
    .Y(_0970_),
    .A1(_0966_),
    .A2(_0969_));
 sg13g2_and2_1 _3763_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .X(_0971_));
 sg13g2_xor2_1 _3764_ (.B(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .X(_0972_));
 sg13g2_nor2_1 _3765_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[9] ),
    .Y(_0973_));
 sg13g2_nand2_1 _3766_ (.Y(_0974_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[9] ));
 sg13g2_and2_1 _3767_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[8] ),
    .X(_0975_));
 sg13g2_or2_1 _3768_ (.X(_0976_),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[8] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[8] ));
 sg13g2_inv_1 _3769_ (.Y(_0531_),
    .A(\pll_dig.MID_MUX_D[6] ));
 sg13g2_nand2b_1 _3770_ (.Y(_0977_),
    .B(_0976_),
    .A_N(_0975_));
 sg13g2_nor2_1 _3771_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[7] ),
    .Y(_0978_));
 sg13g2_nand2_1 _3772_ (.Y(_0979_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[7] ));
 sg13g2_and2_1 _3773_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[6] ),
    .X(_0980_));
 sg13g2_nand2_1 _3774_ (.Y(_0981_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[5] ));
 sg13g2_and2_1 _3775_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[4] ),
    .X(_0982_));
 sg13g2_nand2_1 _3776_ (.Y(_0983_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[3] ));
 sg13g2_and2_1 _3777_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[2] ),
    .X(_0984_));
 sg13g2_o21ai_1 _3778_ (.B1(_0679_),
    .Y(_0985_),
    .A1(_0680_),
    .A2(_0678_));
 sg13g2_xor2_1 _3779_ (.B(\pll_dig.dsm_impl.dsm.dff_err2[2] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .X(_0986_));
 sg13g2_inv_1 _3780_ (.Y(_0532_),
    .A(\pll_dig.COARSE_MUX_D[13] ));
 sg13g2_a21oi_2 _3781_ (.B1(_0984_),
    .Y(_0987_),
    .A2(_0985_),
    .A1(_0986_));
 sg13g2_nor2_1 _3782_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .Y(_0988_));
 sg13g2_xor2_1 _3783_ (.B(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .X(_0989_));
 sg13g2_o21ai_1 _3784_ (.B1(_0983_),
    .Y(_0990_),
    .A1(_0988_),
    .A2(_0987_));
 sg13g2_xor2_1 _3785_ (.B(\pll_dig.dsm_impl.dsm.dff_err2[4] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .X(_0991_));
 sg13g2_a21oi_2 _3786_ (.B1(_0982_),
    .Y(_0992_),
    .A2(_0990_),
    .A1(_0991_));
 sg13g2_nor2_1 _3787_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[5] ),
    .Y(_0993_));
 sg13g2_xor2_1 _3788_ (.B(\pll_dig.dsm_impl.dsm.dff_err2[5] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .X(_0994_));
 sg13g2_o21ai_1 _3789_ (.B1(_0981_),
    .Y(_0995_),
    .A1(_0993_),
    .A2(_0992_));
 sg13g2_xor2_1 _3790_ (.B(\pll_dig.dsm_impl.dsm.dff_err2[6] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .X(_0996_));
 sg13g2_inv_1 _3791_ (.Y(_0533_),
    .A(\pll_dig.MID_MUX_D[12] ));
 sg13g2_a21oi_2 _3792_ (.B1(_0980_),
    .Y(_0997_),
    .A2(_0995_),
    .A1(_0996_));
 sg13g2_o21ai_1 _3793_ (.B1(_0979_),
    .Y(_0998_),
    .A1(_0997_),
    .A2(_0978_));
 sg13g2_a21oi_2 _3794_ (.B1(_0975_),
    .Y(_0999_),
    .A2(_0976_),
    .A1(_0998_));
 sg13g2_o21ai_1 _3795_ (.B1(_0974_),
    .Y(_1000_),
    .A1(_0999_),
    .A2(_0973_));
 sg13g2_a21o_1 _3796_ (.A2(_0972_),
    .A1(_1000_),
    .B1(_0971_),
    .X(_1001_));
 sg13g2_a21o_1 _3797_ (.A2(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .A1(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .B1(net371),
    .X(_1002_));
 sg13g2_o21ai_1 _3798_ (.B1(_1002_),
    .Y(_1003_),
    .A1(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .A2(\pll_dig.dsm_impl.dsm.dff_err2[11] ));
 sg13g2_nand3_1 _3799_ (.B(_0667_),
    .C(_1003_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .Y(_1004_));
 sg13g2_nor2_1 _3800_ (.A(_0970_),
    .B(_1004_),
    .Y(_1005_));
 sg13g2_xnor2_1 _3801_ (.Y(_1006_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[11] ));
 sg13g2_inv_1 _3802_ (.Y(_0534_),
    .A(\pll_dig.COARSE_MUX_D[11] ));
 sg13g2_xnor2_1 _3803_ (.Y(_1007_),
    .A(_1006_),
    .B(_1001_));
 sg13g2_xnor2_1 _3804_ (.Y(_1008_),
    .A(_1000_),
    .B(_0972_));
 sg13g2_inv_1 _3805_ (.Y(_1009_),
    .A(net357));
 sg13g2_nand2_1 _3806_ (.Y(_1010_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .B(_1009_));
 sg13g2_nor2b_1 _3807_ (.A(_0973_),
    .B_N(_0974_),
    .Y(_1011_));
 sg13g2_xnor2_1 _3808_ (.Y(_1012_),
    .A(_1011_),
    .B(_0999_));
 sg13g2_and2_1 _3809_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .B(_1012_),
    .X(_1013_));
 sg13g2_xnor2_1 _3810_ (.Y(_1014_),
    .A(_0998_),
    .B(_0977_));
 sg13g2_and2_1 _3811_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .B(net354),
    .X(_1015_));
 sg13g2_inv_1 _3812_ (.Y(_1016_),
    .A(_1015_));
 sg13g2_inv_1 _3813_ (.Y(_0485_),
    .A(\pll_dig.flock.cnt_filt[2] ));
 sg13g2_inv_1 _3814_ (.Y(_0535_),
    .A(\pll_dig.flock.FCW_NA[2] ));
 sg13g2_nor2b_1 _3815_ (.A(_0978_),
    .B_N(_0979_),
    .Y(_1017_));
 sg13g2_xnor2_1 _3816_ (.Y(_1018_),
    .A(_1017_),
    .B(_0997_));
 sg13g2_nand2_1 _3817_ (.Y(_1019_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[7] ),
    .B(net358));
 sg13g2_xnor2_1 _3818_ (.Y(_1020_),
    .A(_0996_),
    .B(_0995_));
 sg13g2_or2_1 _3819_ (.X(_1021_),
    .B(net356),
    .A(_0615_));
 sg13g2_xnor2_1 _3820_ (.Y(_1022_),
    .A(_0992_),
    .B(_0994_));
 sg13g2_nand2_1 _3821_ (.Y(_1023_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .B(_1022_));
 sg13g2_xnor2_1 _3822_ (.Y(_1024_),
    .A(_0991_),
    .B(_0990_));
 sg13g2_or2_1 _3823_ (.X(_1025_),
    .B(net363),
    .A(_0518_));
 sg13g2_xnor2_1 _3824_ (.Y(_1026_),
    .A(_0987_),
    .B(_0989_));
 sg13g2_inv_1 _3825_ (.Y(_0123_),
    .A(net5));
 sg13g2_nand2_1 _3826_ (.Y(_1027_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .B(_1026_));
 sg13g2_xnor2_1 _3827_ (.Y(_1028_),
    .A(_0986_),
    .B(_0985_));
 sg13g2_or2_1 _3828_ (.X(_1029_),
    .B(net362),
    .A(_0539_));
 sg13g2_o21ai_1 _3829_ (.B1(_0683_),
    .Y(_1030_),
    .A1(_0677_),
    .A2(_0684_));
 sg13g2_xnor2_1 _3830_ (.Y(_1031_),
    .A(_0539_),
    .B(_1028_));
 sg13g2_nand2b_1 _3831_ (.Y(_1032_),
    .B(_1030_),
    .A_N(_1031_));
 sg13g2_xnor2_1 _3832_ (.Y(_1033_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .B(_1026_));
 sg13g2_a21o_1 _3833_ (.A2(_1032_),
    .A1(_1029_),
    .B1(_1033_),
    .X(_1034_));
 sg13g2_xnor2_1 _3834_ (.Y(_1035_),
    .A(_0518_),
    .B(_1024_));
 sg13g2_a21o_1 _3835_ (.A2(_1034_),
    .A1(_1027_),
    .B1(_1035_),
    .X(_1036_));
 sg13g2_inv_1 _3836_ (.Y(_0536_),
    .A(net12));
 sg13g2_xnor2_1 _3837_ (.Y(_1037_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .B(_1022_));
 sg13g2_a21o_1 _3838_ (.A2(_1036_),
    .A1(_1025_),
    .B1(_1037_),
    .X(_1038_));
 sg13g2_xnor2_1 _3839_ (.Y(_1039_),
    .A(_0615_),
    .B(_1020_));
 sg13g2_a21o_1 _3840_ (.A2(_1038_),
    .A1(_1023_),
    .B1(_1039_),
    .X(_1040_));
 sg13g2_xnor2_1 _3841_ (.Y(_1041_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[7] ),
    .B(_1018_));
 sg13g2_a21o_1 _3842_ (.A2(_1040_),
    .A1(_1021_),
    .B1(_1041_),
    .X(_1042_));
 sg13g2_xnor2_1 _3843_ (.Y(_1043_),
    .A(_1014_),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[8] ));
 sg13g2_a21o_1 _3844_ (.A2(_1042_),
    .A1(_1019_),
    .B1(_1043_),
    .X(_1044_));
 sg13g2_xnor2_1 _3845_ (.Y(_1045_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .B(_1012_));
 sg13g2_a21oi_2 _3846_ (.B1(_1045_),
    .Y(_1046_),
    .A2(_1016_),
    .A1(_1044_));
 sg13g2_inv_1 _3847_ (.Y(_0537_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[7] ));
 sg13g2_xnor2_1 _3848_ (.Y(_1047_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .B(_1008_));
 sg13g2_o21ai_1 _3849_ (.B1(_1047_),
    .Y(_1048_),
    .A1(_1046_),
    .A2(_1013_));
 sg13g2_xnor2_1 _3850_ (.Y(_1049_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .B(_1007_));
 sg13g2_a21oi_2 _3851_ (.B1(_1049_),
    .Y(_1050_),
    .A2(_1010_),
    .A1(_1048_));
 sg13g2_a21oi_2 _3852_ (.B1(_1050_),
    .Y(_1051_),
    .A2(net355),
    .A1(\pll_dig.dsm_impl.dsm.dff_err3[11] ));
 sg13g2_xor2_1 _3853_ (.B(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .A(_1051_),
    .X(_1052_));
 sg13g2_xnor2_1 _3854_ (.Y(_1053_),
    .A(_1003_),
    .B(_1052_));
 sg13g2_nand2_1 _3855_ (.Y(_1054_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .B(_1053_));
 sg13g2_and3_1 _3856_ (.X(_1055_),
    .A(_1051_),
    .B(_1003_),
    .C(\pll_dig.dsm_impl.dsm.dff_ca3 ));
 sg13g2_nor3_1 _3857_ (.A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .B(_1003_),
    .C(net367),
    .Y(_1056_));
 sg13g2_inv_1 _3858_ (.Y(_0538_),
    .A(net8));
 sg13g2_or2_1 _3859_ (.X(_1057_),
    .B(_1055_),
    .A(_1056_));
 sg13g2_nor2b_1 _3860_ (.A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .B_N(net380),
    .Y(_1058_));
 sg13g2_xor2_1 _3861_ (.B(_1057_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .X(_1059_));
 sg13g2_nor2b_1 _3862_ (.A(net364),
    .B_N(_1054_),
    .Y(_1060_));
 sg13g2_xnor2_1 _3863_ (.Y(_1061_),
    .A(_1053_),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ));
 sg13g2_nand2_2 _3864_ (.Y(_1062_),
    .A(_0970_),
    .B(_1061_));
 sg13g2_xor2_1 _3865_ (.B(_1054_),
    .A(_1059_),
    .X(_1063_));
 sg13g2_nor2_2 _3866_ (.A(_1063_),
    .B(_1062_),
    .Y(_1064_));
 sg13g2_nor2_1 _3867_ (.A(_0517_),
    .B(net369),
    .Y(_1065_));
 sg13g2_xnor2_1 _3868_ (.Y(_1066_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .B(net369));
 sg13g2_inv_1 _3869_ (.Y(_0539_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[2] ));
 sg13g2_xnor2_1 _3870_ (.Y(_1067_),
    .A(_1058_),
    .B(_1066_));
 sg13g2_inv_1 _3871_ (.Y(_1068_),
    .A(_1067_));
 sg13g2_o21ai_1 _3872_ (.B1(_1068_),
    .Y(_1069_),
    .A1(_1060_),
    .A2(_1064_));
 sg13g2_and2_1 _3873_ (.A(_0668_),
    .B(_1069_),
    .X(_1070_));
 sg13g2_a21oi_1 _3874_ (.A1(_1058_),
    .A2(_1066_),
    .Y(_1071_),
    .B1(_1065_));
 sg13g2_a21oi_1 _3875_ (.A1(net379),
    .A2(_1071_),
    .Y(_1072_),
    .B1(_1005_));
 sg13g2_nand2_1 _3876_ (.Y(_1073_),
    .A(\pll_dig.dsm_impl.FCWI[4] ),
    .B(_1072_));
 sg13g2_or3_1 _3877_ (.A(_1060_),
    .B(_1064_),
    .C(_1068_),
    .X(_1074_));
 sg13g2_a21oi_2 _3878_ (.B1(_1005_),
    .Y(_1075_),
    .A2(_1070_),
    .A1(_1074_));
 sg13g2_and2_1 _3879_ (.A(net374),
    .B(net359),
    .X(_1076_));
 sg13g2_inv_1 _3880_ (.Y(_0540_),
    .A(\pll_dig.MID_MUX_D[13] ));
 sg13g2_o21ai_1 _3881_ (.B1(_0668_),
    .Y(_1077_),
    .A1(net375),
    .A2(net359));
 sg13g2_nand2b_1 _3882_ (.Y(_1078_),
    .B(_0667_),
    .A_N(\pll_dig.dsm_impl.dsm.dff_ca2 ));
 sg13g2_nor2_1 _3883_ (.A(_1003_),
    .B(_1078_),
    .Y(_1079_));
 sg13g2_a21oi_1 _3884_ (.A1(_0970_),
    .A2(_1079_),
    .Y(_1080_),
    .B1(_1005_));
 sg13g2_o21ai_1 _3885_ (.B1(_1080_),
    .Y(_1081_),
    .A1(_1076_),
    .A2(_1077_));
 sg13g2_nand2_2 _3886_ (.Y(_1082_),
    .A(\pll_dig.dsm_impl.FCWI[1] ),
    .B(_1081_));
 sg13g2_xnor2_1 _3887_ (.Y(_1083_),
    .A(_1075_),
    .B(\pll_dig.dsm_impl.FCWI[2] ));
 sg13g2_nand2b_1 _3888_ (.Y(_1084_),
    .B(_1083_),
    .A_N(_1082_));
 sg13g2_o21ai_1 _3889_ (.B1(_1084_),
    .Y(_1085_),
    .A1(_0516_),
    .A2(_1075_));
 sg13g2_nor2b_1 _3890_ (.A(_1072_),
    .B_N(\pll_dig.dsm_impl.FCWI[3] ),
    .Y(_1086_));
 sg13g2_inv_1 _3891_ (.Y(_0541_),
    .A(\pll_dig.MID_MUX_D[5] ));
 sg13g2_nand2b_1 _3892_ (.Y(_1087_),
    .B(_1072_),
    .A_N(\pll_dig.dsm_impl.FCWI[3] ));
 sg13g2_nand2b_1 _3893_ (.Y(_1088_),
    .B(_1087_),
    .A_N(_1086_));
 sg13g2_a21oi_2 _3894_ (.B1(_1086_),
    .Y(_1089_),
    .A2(_1085_),
    .A1(_1087_));
 sg13g2_nor2_2 _3895_ (.A(_1089_),
    .B(_1073_),
    .Y(_1090_));
 sg13g2_nor2_1 _3896_ (.A(\pll_dig.dsm_impl.FCWI[4] ),
    .B(_1072_),
    .Y(_1091_));
 sg13g2_nand2_2 _3897_ (.Y(_1092_),
    .A(_1089_),
    .B(_1091_));
 sg13g2_nand2_1 _3898_ (.Y(_1093_),
    .A(_0668_),
    .B(_1061_));
 sg13g2_nand2_1 _3899_ (.Y(_1094_),
    .A(_1004_),
    .B(_1093_));
 sg13g2_nor2_1 _3900_ (.A(_1079_),
    .B(_1094_),
    .Y(_1095_));
 sg13g2_xnor2_1 _3901_ (.Y(_1096_),
    .A(_0970_),
    .B(_1095_));
 sg13g2_inv_1 _3902_ (.Y(_0542_),
    .A(\pll_dig.MID_MUX_D[7] ));
 sg13g2_a21o_1 _3903_ (.A2(_1096_),
    .A1(_1092_),
    .B1(_1090_),
    .X(\pll_dig.FILTER_DEC_RAW[0] ));
 sg13g2_nor2_1 _3904_ (.A(\pll_dig.FREQ_LOCKED ),
    .B(\pll_dig.FREQ_ERR ),
    .Y(_1097_));
 sg13g2_o21ai_1 _3905_ (.B1(\pll_dig.START ),
    .Y(_1098_),
    .A1(\pll_dig.FREQ_LOCKED ),
    .A2(\pll_dig.FREQ_ERR ));
 sg13g2_nand2_1 _3906_ (.Y(_1099_),
    .A(\pll_dig.flock.started ),
    .B(_1097_));
 sg13g2_inv_1 _3907_ (.Y(_1100_),
    .A(_1099_));
 sg13g2_and2_1 _3908_ (.A(_1098_),
    .B(_1099_),
    .X(_1101_));
 sg13g2_nand2_1 _3909_ (.Y(_1102_),
    .A(\pll_dig.flock.cnt_done[4] ),
    .B(_1101_));
 sg13g2_a22oi_1 _3910_ (.Y(_1103_),
    .B1(\pll_dig.flock.FCW_NA[1] ),
    .B2(_0487_),
    .A2(\pll_dig.flock.FCW_NA[0] ),
    .A1(_0486_));
 sg13g2_a221oi_1 _3911_ (.B2(\pll_dig.flock.cnt_filt[1] ),
    .C1(_1103_),
    .B1(_0590_),
    .A1(\pll_dig.flock.cnt_filt[2] ),
    .Y(_1104_),
    .A2(_0535_));
 sg13g2_a221oi_1 _3912_ (.B2(_0485_),
    .C1(_1104_),
    .B1(\pll_dig.flock.FCW_NA[2] ),
    .A1(_0484_),
    .Y(_1105_),
    .A2(\pll_dig.flock.FCW_NA[3] ));
 sg13g2_inv_1 _3913_ (.Y(_0543_),
    .A(\pll_dig.MID_MUX_D[8] ));
 sg13g2_a221oi_1 _3914_ (.B2(\pll_dig.flock.cnt_filt[4] ),
    .C1(_1105_),
    .B1(_0547_),
    .A1(\pll_dig.flock.cnt_filt[3] ),
    .Y(_1106_),
    .A2(_0513_));
 sg13g2_a221oi_1 _3915_ (.B2(_0483_),
    .C1(_1106_),
    .B1(\pll_dig.flock.FCW_NA[5] ),
    .A1(_0482_),
    .Y(_1107_),
    .A2(\pll_dig.flock.FCW_NA[4] ));
 sg13g2_a21oi_1 _3916_ (.A1(\pll_dig.flock.cnt_filt[5] ),
    .A2(_0548_),
    .Y(_1108_),
    .B1(_1107_));
 sg13g2_a21o_1 _3917_ (.A2(\pll_dig.flock.FCW_NA[6] ),
    .A1(_0481_),
    .B1(_1108_),
    .X(_1109_));
 sg13g2_a22oi_1 _3918_ (.Y(_1110_),
    .B1(_0546_),
    .B2(\pll_dig.flock.cnt_filt[7] ),
    .A2(_0512_),
    .A1(\pll_dig.flock.cnt_filt[6] ));
 sg13g2_a22oi_1 _3919_ (.Y(_1111_),
    .B1(_1109_),
    .B2(_1110_),
    .A2(_0580_),
    .A1(\pll_dig.flock.FCW_NA[7] ));
 sg13g2_nor2_1 _3920_ (.A(net572),
    .B(_0815_),
    .Y(_1112_));
 sg13g2_and2_1 _3921_ (.A(\pll_dig.flock.cnt_filt[10] ),
    .B(\pll_dig.flock.cnt_filt[11] ),
    .X(_1113_));
 sg13g2_a21oi_1 _3922_ (.A1(net572),
    .A2(_1113_),
    .Y(_1114_),
    .B1(net573));
 sg13g2_and2_1 _3923_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[10] ),
    .X(_1115_));
 sg13g2_inv_1 _3924_ (.Y(_0486_),
    .A(\pll_dig.flock.cnt_filt[0] ));
 sg13g2_inv_1 _3925_ (.Y(_0544_),
    .A(\pll_dig.COARSE_MUX_D[10] ));
 sg13g2_xor2_1 _3926_ (.B(\pll_dig.flock.cnt_filt[10] ),
    .A(\pll_dig.flock.cnt_filt[9] ),
    .X(_1116_));
 sg13g2_and2_1 _3927_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .X(_1117_));
 sg13g2_xor2_1 _3928_ (.B(\pll_dig.flock.cnt_filt[8] ),
    .A(\pll_dig.flock.cnt_filt[9] ),
    .X(_1118_));
 sg13g2_nor4_1 _3929_ (.A(_1111_),
    .B(_1114_),
    .C(_1116_),
    .D(_1118_),
    .Y(_1119_));
 sg13g2_nor2_1 _3930_ (.A(\pll_dig.flock.cnt_filt[1] ),
    .B(_0514_),
    .Y(_1120_));
 sg13g2_nor3_1 _3931_ (.A(_0486_),
    .B(\pll_dig.flock.FCW_NA[0] ),
    .C(_1120_),
    .Y(_1121_));
 sg13g2_a221oi_1 _3932_ (.B2(\pll_dig.flock.cnt_filt[2] ),
    .C1(_1121_),
    .B1(_0616_),
    .A1(\pll_dig.flock.cnt_filt[1] ),
    .Y(_1122_),
    .A2(_0514_));
 sg13g2_a221oi_1 _3933_ (.B2(_0485_),
    .C1(_1122_),
    .B1(\pll_dig.flock.FCW_PA[2] ),
    .A1(_0484_),
    .Y(_1123_),
    .A2(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_a21oi_1 _3934_ (.A1(\pll_dig.flock.cnt_filt[3] ),
    .A2(_0585_),
    .Y(_1124_),
    .B1(_1123_));
 sg13g2_a21oi_1 _3935_ (.A1(_0482_),
    .A2(\pll_dig.flock.FCW_PA[4] ),
    .Y(_1125_),
    .B1(_1124_));
 sg13g2_inv_1 _3936_ (.Y(_0545_),
    .A(\pll_dig.COARSE_MUX_D[9] ));
 sg13g2_a221oi_1 _3937_ (.B2(\pll_dig.flock.cnt_filt[4] ),
    .C1(_1125_),
    .B1(_0549_),
    .A1(\pll_dig.flock.cnt_filt[5] ),
    .Y(_1126_),
    .A2(_0515_));
 sg13g2_a22oi_1 _3938_ (.Y(_1127_),
    .B1(\pll_dig.flock.FCW_PA[6] ),
    .B2(_0481_),
    .A2(\pll_dig.flock.FCW_PA[5] ),
    .A1(_0483_));
 sg13g2_nand2b_1 _3939_ (.Y(_1128_),
    .B(_1127_),
    .A_N(_1126_));
 sg13g2_o21ai_1 _3940_ (.B1(_1128_),
    .Y(_1129_),
    .A1(_0580_),
    .A2(net578));
 sg13g2_a21oi_1 _3941_ (.A1(\pll_dig.flock.cnt_filt[6] ),
    .A2(_0617_),
    .Y(_1130_),
    .B1(_1129_));
 sg13g2_a221oi_1 _3942_ (.B2(_0580_),
    .C1(_1130_),
    .B1(net578),
    .A1(\pll_dig.flock.FCW_PA[8] ),
    .Y(_1131_),
    .A2(_0606_));
 sg13g2_nand2b_1 _3943_ (.Y(_1132_),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .A_N(\pll_dig.flock.FCW_PA[8] ));
 sg13g2_nand3_1 _3944_ (.B(net573),
    .C(_1132_),
    .A(_0814_),
    .Y(_1133_));
 sg13g2_nor4_1 _3945_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(_1119_),
    .C(net579),
    .D(net574),
    .Y(_1134_));
 sg13g2_inv_1 _3946_ (.Y(_1135_),
    .A(net81));
 sg13g2_inv_1 _3947_ (.Y(_0546_),
    .A(\pll_dig.flock.FCW_NA[7] ));
 sg13g2_or2_1 _3948_ (.X(_1136_),
    .B(\pll_dig.flock.cnt_done[0] ),
    .A(\pll_dig.flock.cnt_done[1] ));
 sg13g2_or2_1 _3949_ (.X(_1137_),
    .B(\pll_dig.flock.cnt_done[3] ),
    .A(\pll_dig.flock.cnt_done[2] ));
 sg13g2_or2_1 _3950_ (.X(_1138_),
    .B(_1137_),
    .A(\pll_dig.flock.cnt_done[4] ));
 sg13g2_nor3_1 _3951_ (.A(\pll_dig.flock.cnt_done[5] ),
    .B(_1136_),
    .C(_1138_),
    .Y(_1139_));
 sg13g2_nor2b_1 _3952_ (.A(\pll_dig.flock.cnt_done[6] ),
    .B_N(_1139_),
    .Y(_1140_));
 sg13g2_a21oi_1 _3953_ (.A1(_1135_),
    .A2(_1140_),
    .Y(_1141_),
    .B1(_1099_));
 sg13g2_a21oi_1 _3954_ (.A1(\pll_dig.flock.cnt_done[7] ),
    .A2(_1100_),
    .Y(_1142_),
    .B1(_1141_));
 sg13g2_nand2_1 _3955_ (.Y(_1143_),
    .A(\pll_dig.flock.cnt_done[2] ),
    .B(\pll_dig.flock.cnt_done[3] ));
 sg13g2_nor2_1 _3956_ (.A(net81),
    .B(_1136_),
    .Y(_1144_));
 sg13g2_and2_1 _3957_ (.A(\pll_dig.flock.cnt_done[1] ),
    .B(\pll_dig.flock.cnt_done[0] ),
    .X(_1145_));
 sg13g2_inv_1 _3958_ (.Y(_0547_),
    .A(\pll_dig.flock.FCW_NA[4] ));
 sg13g2_and2_1 _3959_ (.A(net81),
    .B(_1145_),
    .X(_1146_));
 sg13g2_nor3_1 _3960_ (.A(\pll_dig.flock.cnt_done[2] ),
    .B(net81),
    .C(_1136_),
    .Y(_1147_));
 sg13g2_a21oi_1 _3961_ (.A1(\pll_dig.flock.cnt_done[2] ),
    .A2(_1146_),
    .Y(_1148_),
    .B1(_1147_));
 sg13g2_a21oi_1 _3962_ (.A1(_1137_),
    .A2(_1143_),
    .Y(_1149_),
    .B1(_1148_));
 sg13g2_xnor2_1 _3963_ (.Y(_1150_),
    .A(\pll_dig.flock.cnt_done[4] ),
    .B(_1149_));
 sg13g2_o21ai_1 _3964_ (.B1(_1102_),
    .Y(_0025_),
    .A1(_1142_),
    .A2(_1150_));
 sg13g2_nand2_1 _3965_ (.Y(_1151_),
    .A(net104),
    .B(\pll_dig.FILTER_DEC[1] ));
 sg13g2_nand2_1 _3966_ (.Y(\pll_dig.FINE_MUX_D[5] ),
    .A(net100),
    .B(_1151_));
 sg13g2_xor2_1 _3967_ (.B(_1081_),
    .A(\pll_dig.dsm_impl.FCWI[1] ),
    .X(_1152_));
 sg13g2_a21o_1 _3968_ (.A2(_1152_),
    .A1(_1092_),
    .B1(_1090_),
    .X(\pll_dig.FILTER_DEC_RAW[1] ));
 sg13g2_inv_1 _3969_ (.Y(_0548_),
    .A(\pll_dig.flock.FCW_NA[5] ));
 sg13g2_xnor2_1 _3970_ (.Y(_1153_),
    .A(_1082_),
    .B(net365));
 sg13g2_a21o_1 _3971_ (.A2(_1153_),
    .A1(_1092_),
    .B1(_1090_),
    .X(\pll_dig.FILTER_DEC_RAW[2] ));
 sg13g2_xnor2_1 _3972_ (.Y(_1154_),
    .A(_1085_),
    .B(_1088_));
 sg13g2_a21o_1 _3973_ (.A2(_1154_),
    .A1(_1092_),
    .B1(_1090_),
    .X(\pll_dig.FILTER_DEC_RAW[3] ));
 sg13g2_xor2_1 _3974_ (.B(\pll_dig.flock.cnt_filt[11] ),
    .A(\pll_dig.flock.cnt_filt[10] ),
    .X(_1155_));
 sg13g2_a21oi_1 _3975_ (.A1(net535),
    .A2(_0815_),
    .Y(_1156_),
    .B1(_1113_));
 sg13g2_nand2_1 _3976_ (.Y(_1157_),
    .A(\pll_dig.flock.cnt_filt[12] ),
    .B(\pll_dig.flock.cnt_filt[11] ));
 sg13g2_xor2_1 _3977_ (.B(\pll_dig.flock.cnt_filt[11] ),
    .A(\pll_dig.flock.cnt_filt[12] ),
    .X(_1158_));
 sg13g2_nand2_1 _3978_ (.Y(_1159_),
    .A(net539),
    .B(_1158_));
 sg13g2_xnor2_1 _3979_ (.Y(_1160_),
    .A(net539),
    .B(_1158_));
 sg13g2_inv_1 _3980_ (.Y(_0549_),
    .A(\pll_dig.flock.FCW_PA[4] ));
 sg13g2_a21oi_1 _3981_ (.A1(net531),
    .A2(_1116_),
    .Y(_1161_),
    .B1(_1115_));
 sg13g2_xnor2_1 _3982_ (.Y(_1162_),
    .A(net535),
    .B(_1155_));
 sg13g2_nor2_1 _3983_ (.A(_1161_),
    .B(net536),
    .Y(_1163_));
 sg13g2_a21oi_1 _3984_ (.A1(net527),
    .A2(_1118_),
    .Y(_1164_),
    .B1(_1117_));
 sg13g2_xnor2_1 _3985_ (.Y(_1165_),
    .A(net531),
    .B(_1116_));
 sg13g2_nor2_1 _3986_ (.A(_1164_),
    .B(net532),
    .Y(_1166_));
 sg13g2_nor2_1 _3987_ (.A(_0580_),
    .B(_0606_),
    .Y(_1167_));
 sg13g2_xor2_1 _3988_ (.B(\pll_dig.flock.cnt_filt[8] ),
    .A(\pll_dig.flock.cnt_filt[7] ),
    .X(_1168_));
 sg13g2_a21oi_1 _3989_ (.A1(net556),
    .A2(_1168_),
    .Y(_1169_),
    .B1(_1167_));
 sg13g2_xnor2_1 _3990_ (.Y(_1170_),
    .A(net527),
    .B(_1118_));
 sg13g2_inv_1 _3991_ (.Y(_0550_),
    .A(\pll_dig.MID_MUX_D[11] ));
 sg13g2_nor2_1 _3992_ (.A(net557),
    .B(net528),
    .Y(_1171_));
 sg13g2_nor2_1 _3993_ (.A(_0481_),
    .B(_0580_),
    .Y(_1172_));
 sg13g2_xor2_1 _3994_ (.B(\pll_dig.flock.cnt_filt[7] ),
    .A(\pll_dig.flock.cnt_filt[6] ),
    .X(_1173_));
 sg13g2_a21oi_1 _3995_ (.A1(net514),
    .A2(_1173_),
    .Y(_1174_),
    .B1(_1172_));
 sg13g2_xnor2_1 _3996_ (.Y(_1175_),
    .A(net556),
    .B(_1168_));
 sg13g2_nor2_1 _3997_ (.A(net515),
    .B(_1175_),
    .Y(_1176_));
 sg13g2_nor2_1 _3998_ (.A(_0481_),
    .B(_0483_),
    .Y(_1177_));
 sg13g2_xor2_1 _3999_ (.B(\pll_dig.flock.cnt_filt[5] ),
    .A(\pll_dig.flock.cnt_filt[6] ),
    .X(_1178_));
 sg13g2_a21oi_1 _4000_ (.A1(net518),
    .A2(_1178_),
    .Y(_1179_),
    .B1(_1177_));
 sg13g2_xnor2_1 _4001_ (.Y(_1180_),
    .A(net514),
    .B(_1173_));
 sg13g2_inv_1 _4002_ (.Y(_0551_),
    .A(\pll_dig.MID_MUX_D[10] ));
 sg13g2_nor2_1 _4003_ (.A(net519),
    .B(_1180_),
    .Y(_1181_));
 sg13g2_nor2_1 _4004_ (.A(_0482_),
    .B(_0483_),
    .Y(_1182_));
 sg13g2_xor2_1 _4005_ (.B(\pll_dig.flock.cnt_filt[5] ),
    .A(\pll_dig.flock.cnt_filt[4] ),
    .X(_1183_));
 sg13g2_a21oi_1 _4006_ (.A1(net547),
    .A2(_1183_),
    .Y(_1184_),
    .B1(_1182_));
 sg13g2_xnor2_1 _4007_ (.Y(_1185_),
    .A(net518),
    .B(_1178_));
 sg13g2_nor2_1 _4008_ (.A(net548),
    .B(_1185_),
    .Y(_1186_));
 sg13g2_nor2_1 _4009_ (.A(_0482_),
    .B(_0484_),
    .Y(_1187_));
 sg13g2_xor2_1 _4010_ (.B(\pll_dig.flock.cnt_filt[3] ),
    .A(\pll_dig.flock.cnt_filt[4] ),
    .X(_1188_));
 sg13g2_a21oi_1 _4011_ (.A1(net563),
    .A2(_1188_),
    .Y(_1189_),
    .B1(_1187_));
 sg13g2_xnor2_1 _4012_ (.Y(_1190_),
    .A(net547),
    .B(_1183_));
 sg13g2_inv_1 _4013_ (.Y(_0552_),
    .A(\pll_dig.COARSE_MUX_D[8] ));
 sg13g2_nor2_1 _4014_ (.A(_1189_),
    .B(_1190_),
    .Y(_1191_));
 sg13g2_nor2_1 _4015_ (.A(_0484_),
    .B(_0485_),
    .Y(_1192_));
 sg13g2_xor2_1 _4016_ (.B(\pll_dig.flock.cnt_filt[2] ),
    .A(\pll_dig.flock.cnt_filt[3] ),
    .X(_1193_));
 sg13g2_a21oi_1 _4017_ (.A1(net567),
    .A2(_1193_),
    .Y(_1194_),
    .B1(_1192_));
 sg13g2_xnor2_1 _4018_ (.Y(_1195_),
    .A(net563),
    .B(_1188_));
 sg13g2_nor2_1 _4019_ (.A(net568),
    .B(net564),
    .Y(_1196_));
 sg13g2_xor2_1 _4020_ (.B(net564),
    .A(net568),
    .X(_1197_));
 sg13g2_nand2_1 _4021_ (.Y(_1198_),
    .A(\pll_dig.flock.cnt_filt[2] ),
    .B(\pll_dig.flock.cnt_filt[1] ));
 sg13g2_xor2_1 _4022_ (.B(\pll_dig.flock.cnt_filt[1] ),
    .A(\pll_dig.flock.cnt_filt[2] ),
    .X(_1199_));
 sg13g2_nand2_1 _4023_ (.Y(_1200_),
    .A(net551),
    .B(_1199_));
 sg13g2_inv_1 _4024_ (.Y(_0553_),
    .A(\pll_dig.COARSE_MUX_D[7] ));
 sg13g2_xnor2_1 _4025_ (.Y(_1201_),
    .A(net567),
    .B(_1193_));
 sg13g2_nand3_1 _4026_ (.B(net552),
    .C(_1201_),
    .A(_1198_),
    .Y(_1202_));
 sg13g2_a21oi_1 _4027_ (.A1(_1198_),
    .A2(net552),
    .Y(_1203_),
    .B1(_1201_));
 sg13g2_inv_1 _4028_ (.Y(_1204_),
    .A(_1203_));
 sg13g2_nor2_1 _4029_ (.A(\pll_dig.flock.cnt_filt[0] ),
    .B(\pll_dig.flock.cnt_filt[1] ),
    .Y(_1205_));
 sg13g2_xnor2_1 _4030_ (.Y(_1206_),
    .A(net551),
    .B(_1199_));
 sg13g2_nor2_1 _4031_ (.A(_0486_),
    .B(_0487_),
    .Y(_1207_));
 sg13g2_o21ai_1 _4032_ (.B1(net502),
    .Y(_1208_),
    .A1(_1205_),
    .A2(_1207_));
 sg13g2_xor2_1 _4033_ (.B(_1206_),
    .A(_1205_),
    .X(_1209_));
 sg13g2_nand2b_1 _4034_ (.Y(_1210_),
    .B(_1209_),
    .A_N(net503));
 sg13g2_inv_1 _4035_ (.Y(_0487_),
    .A(\pll_dig.flock.cnt_filt[1] ));
 sg13g2_inv_1 _4036_ (.Y(_0554_),
    .A(\pll_dig.COARSE_MUX_D[6] ));
 sg13g2_o21ai_1 _4037_ (.B1(_1210_),
    .Y(_1211_),
    .A1(_1205_),
    .A2(_1206_));
 sg13g2_a21o_1 _4038_ (.A2(_1211_),
    .A1(net553),
    .B1(_1203_),
    .X(_1212_));
 sg13g2_a21oi_1 _4039_ (.A1(net565),
    .A2(_1212_),
    .Y(_1213_),
    .B1(net569));
 sg13g2_inv_1 _4040_ (.Y(_1214_),
    .A(_1213_));
 sg13g2_xor2_1 _4041_ (.B(_1190_),
    .A(_1189_),
    .X(_1215_));
 sg13g2_a21oi_1 _4042_ (.A1(_1214_),
    .A2(net737),
    .Y(_1216_),
    .B1(_1191_));
 sg13g2_xor2_1 _4043_ (.B(_1185_),
    .A(net548),
    .X(_1217_));
 sg13g2_nor2b_1 _4044_ (.A(_1216_),
    .B_N(net549),
    .Y(_1218_));
 sg13g2_nor2_1 _4045_ (.A(_1186_),
    .B(_1218_),
    .Y(_1219_));
 sg13g2_xor2_1 _4046_ (.B(_1180_),
    .A(net519),
    .X(_1220_));
 sg13g2_inv_1 _4047_ (.Y(_0555_),
    .A(\pll_dig.flock.cnt_cap[7] ));
 sg13g2_nor2b_1 _4048_ (.A(_1219_),
    .B_N(net520),
    .Y(_1221_));
 sg13g2_nor2_1 _4049_ (.A(_1181_),
    .B(_1221_),
    .Y(_1222_));
 sg13g2_xor2_1 _4050_ (.B(_1175_),
    .A(net515),
    .X(_1223_));
 sg13g2_nor2b_1 _4051_ (.A(_1222_),
    .B_N(net516),
    .Y(_1224_));
 sg13g2_nor2_1 _4052_ (.A(_1176_),
    .B(_1224_),
    .Y(_1225_));
 sg13g2_xor2_1 _4053_ (.B(net528),
    .A(_1169_),
    .X(_1226_));
 sg13g2_nor2b_1 _4054_ (.A(_1225_),
    .B_N(net529),
    .Y(_1227_));
 sg13g2_nor2_1 _4055_ (.A(_1171_),
    .B(_1227_),
    .Y(_1228_));
 sg13g2_xor2_1 _4056_ (.B(net532),
    .A(_1164_),
    .X(_1229_));
 sg13g2_nor2b_1 _4057_ (.A(net558),
    .B_N(net533),
    .Y(_1230_));
 sg13g2_inv_1 _4058_ (.Y(_0556_),
    .A(\pll_dig.flock.cnt_cap[3] ));
 sg13g2_nor2_1 _4059_ (.A(_1166_),
    .B(_1230_),
    .Y(_1231_));
 sg13g2_xor2_1 _4060_ (.B(net536),
    .A(_1161_),
    .X(_1232_));
 sg13g2_nor2b_1 _4061_ (.A(net559),
    .B_N(net537),
    .Y(_1233_));
 sg13g2_nor2_1 _4062_ (.A(_1163_),
    .B(_1233_),
    .Y(_1234_));
 sg13g2_xor2_1 _4063_ (.B(net540),
    .A(_1156_),
    .X(_1235_));
 sg13g2_o21ai_1 _4064_ (.B1(net541),
    .Y(_1236_),
    .A1(_1163_),
    .A2(_1233_));
 sg13g2_o21ai_1 _4065_ (.B1(net560),
    .Y(_1237_),
    .A1(_1156_),
    .A2(net540));
 sg13g2_and2_1 _4066_ (.A(\pll_dig.flock.cnt_filt[13] ),
    .B(\pll_dig.flock.cnt_filt[12] ),
    .X(_1238_));
 sg13g2_xor2_1 _4067_ (.B(\pll_dig.flock.cnt_filt[12] ),
    .A(\pll_dig.flock.cnt_filt[13] ),
    .X(_1239_));
 sg13g2_xnor2_1 _4068_ (.Y(_1240_),
    .A(net522),
    .B(_1239_));
 sg13g2_inv_1 _4069_ (.Y(_0557_),
    .A(\pll_dig.flock.cnt_cap[4] ));
 sg13g2_a21oi_1 _4070_ (.A1(_1157_),
    .A2(_1159_),
    .Y(_1241_),
    .B1(_1240_));
 sg13g2_nand3_1 _4071_ (.B(_1159_),
    .C(_1240_),
    .A(_1157_),
    .Y(_1242_));
 sg13g2_nand2b_1 _4072_ (.Y(_1243_),
    .B(net741),
    .A_N(_1241_));
 sg13g2_xnor2_1 _4073_ (.Y(_0174_),
    .A(net561),
    .B(net742));
 sg13g2_nand2_1 _4074_ (.Y(_1244_),
    .A(\pll_dig.COARSE_MUX_D[0] ),
    .B(_0837_));
 sg13g2_nor2b_1 _4075_ (.A(_0842_),
    .B_N(_1244_),
    .Y(_1245_));
 sg13g2_nor2_1 _4076_ (.A(\pll_dig.COARSE_MUX_D[14] ),
    .B(_0838_),
    .Y(_1246_));
 sg13g2_nor2_1 _4077_ (.A(net93),
    .B(_1246_),
    .Y(_1247_));
 sg13g2_nand2_1 _4078_ (.Y(_1248_),
    .A(\pll_dig.MID_MUX_D[14] ),
    .B(_1247_));
 sg13g2_or2_1 _4079_ (.X(_1249_),
    .B(net93),
    .A(_0828_));
 sg13g2_inv_1 _4080_ (.Y(_0558_),
    .A(\pll_dig.flock.cnt_cap[5] ));
 sg13g2_nand2_1 _4081_ (.Y(_1250_),
    .A(_1248_),
    .B(_1249_));
 sg13g2_nor2b_1 _4082_ (.A(_1245_),
    .B_N(_1249_),
    .Y(_1251_));
 sg13g2_nand2_1 _4083_ (.Y(_1252_),
    .A(_1248_),
    .B(_1251_));
 sg13g2_and2_1 _4084_ (.A(\pll_dig.MID_MUX_D[0] ),
    .B(net93),
    .X(_1253_));
 sg13g2_nor2_1 _4085_ (.A(\pll_dig.MID_MUX_D[14] ),
    .B(net93),
    .Y(_1254_));
 sg13g2_nor3_1 _4086_ (.A(_0838_),
    .B(net88),
    .C(net86),
    .Y(_1255_));
 sg13g2_inv_1 _4087_ (.Y(_1256_),
    .A(_1255_));
 sg13g2_and2_1 _4088_ (.A(\pll_dig.COARSE_MUX_D[0] ),
    .B(net92),
    .X(_1257_));
 sg13g2_o21ai_1 _4089_ (.B1(_1255_),
    .Y(_1258_),
    .A1(net583),
    .A2(net85));
 sg13g2_inv_1 _4090_ (.Y(_1259_),
    .A(_1258_));
 sg13g2_inv_1 _4091_ (.Y(_0559_),
    .A(\pll_dig.flock.cnt_cap[6] ));
 sg13g2_nand2_1 _4092_ (.Y(_1260_),
    .A(net92),
    .B(_1259_));
 sg13g2_a221oi_1 _4093_ (.B2(\pll_dig.MID_MUX_D[8] ),
    .C1(net79),
    .B1(net87),
    .A1(\pll_dig.MID_MUX_D[10] ),
    .Y(_1261_),
    .A2(net89));
 sg13g2_a22oi_1 _4094_ (.Y(_0453_),
    .B1(_1260_),
    .B2(_1261_),
    .A2(net79),
    .A1(_0519_));
 sg13g2_a21o_1 _4095_ (.A2(\pll_dig.out_edges[0] ),
    .A1(\pll_dig.out_edges[1] ),
    .B1(\pll_dig.out_edges[2] ),
    .X(_1262_));
 sg13g2_and2_1 _4096_ (.A(_0783_),
    .B(_1262_),
    .X(\pll_dig.out_edges_next[2] ));
 sg13g2_nor2_1 _4097_ (.A(\pll_dig.out_edges_next[1] ),
    .B(\pll_dig.out_edges_next[2] ),
    .Y(_1263_));
 sg13g2_a21oi_1 _4098_ (.A1(\pll_dig.out_edges[2] ),
    .A2(\pll_dig.out_edges_next[1] ),
    .Y(_0001_),
    .B1(_1263_));
 sg13g2_nand2_1 _4099_ (.Y(_1264_),
    .A(\pll_dig.out_edges[8] ),
    .B(_0789_));
 sg13g2_nor2b_1 _4100_ (.A(_0790_),
    .B_N(_1264_),
    .Y(\pll_dig.out_edges_next[8] ));
 sg13g2_and2_1 _4101_ (.A(_0493_),
    .B(_0788_),
    .X(_1265_));
 sg13g2_inv_1 _4102_ (.Y(_0560_),
    .A(\pll_dig.flock.cnt_cap[2] ));
 sg13g2_xnor2_1 _4103_ (.Y(_0007_),
    .A(\pll_dig.out_edges[8] ),
    .B(_1265_));
 sg13g2_or2_1 _4104_ (.X(_1266_),
    .B(_0850_),
    .A(_0503_));
 sg13g2_nor2b_1 _4105_ (.A(net134),
    .B_N(_1266_),
    .Y(_1267_));
 sg13g2_inv_1 _4106_ (.Y(_0009_),
    .A(_1267_));
 sg13g2_nor2_1 _4107_ (.A(_0789_),
    .B(_1265_),
    .Y(\pll_dig.out_edges_next[7] ));
 sg13g2_nor2_1 _4108_ (.A(net104),
    .B(\pll_dig.FILTER_DEC[1] ),
    .Y(_1268_));
 sg13g2_nand2_1 _4109_ (.Y(_1269_),
    .A(\pll_dig.FILTER_DEC[4] ),
    .B(\pll_dig.FILTER_DEC[3] ));
 sg13g2_inv_1 _4110_ (.Y(\pll_dig.FINE_MUX_D[23] ),
    .A(net94));
 sg13g2_nor2_1 _4111_ (.A(_1268_),
    .B(net94),
    .Y(\pll_dig.FINE_MUX_D[25] ));
 sg13g2_nand2_1 _4112_ (.Y(_1270_),
    .A(\pll_dig.FILTER_DEC[4] ),
    .B(net104));
 sg13g2_inv_1 _4113_ (.Y(_0561_),
    .A(\pll_dig.clr_r2 ));
 sg13g2_nand2_1 _4114_ (.Y(_1271_),
    .A(\pll_dig.FILTER_DEC[0] ),
    .B(\pll_dig.FILTER_DEC[1] ));
 sg13g2_a21oi_1 _4115_ (.A1(\pll_dig.FILTER_DEC[0] ),
    .A2(\pll_dig.FILTER_DEC[1] ),
    .Y(_1272_),
    .B1(net104));
 sg13g2_nor2_1 _4116_ (.A(net94),
    .B(_1272_),
    .Y(\pll_dig.FINE_MUX_D[26] ));
 sg13g2_and2_1 _4117_ (.A(net104),
    .B(\pll_dig.FINE_MUX_D[23] ),
    .X(\pll_dig.FINE_MUX_D[27] ));
 sg13g2_nor2_1 _4118_ (.A(\pll_dig.FILTER_DEC[0] ),
    .B(\pll_dig.FILTER_DEC[1] ),
    .Y(_1273_));
 sg13g2_o21ai_1 _4119_ (.B1(net104),
    .Y(_1274_),
    .A1(\pll_dig.FILTER_DEC[0] ),
    .A2(\pll_dig.FILTER_DEC[1] ));
 sg13g2_nor2_1 _4120_ (.A(net95),
    .B(_1274_),
    .Y(\pll_dig.FINE_MUX_D[28] ));
 sg13g2_nor2_1 _4121_ (.A(_1151_),
    .B(net95),
    .Y(\pll_dig.FINE_MUX_D[29] ));
 sg13g2_nand3_1 _4122_ (.B(\pll_dig.FILTER_DEC[0] ),
    .C(\pll_dig.FILTER_DEC[1] ),
    .A(\pll_dig.FILTER_DEC[2] ),
    .Y(_1275_));
 sg13g2_nor2_1 _4123_ (.A(net95),
    .B(_1275_),
    .Y(\pll_dig.FINE_MUX_D[30] ));
 sg13g2_inv_1 _4124_ (.Y(_0562_),
    .A(\pll_dig.out_edges_g2_q[6] ));
 sg13g2_nand2_1 _4125_ (.Y(\pll_dig.FINE_MUX_D[19] ),
    .A(net95),
    .B(_1270_));
 sg13g2_o21ai_1 _4126_ (.B1(net95),
    .Y(\pll_dig.FINE_MUX_D[20] ),
    .A1(_1270_),
    .A2(_1273_));
 sg13g2_nand2_1 _4127_ (.Y(_1276_),
    .A(_0497_),
    .B(\pll_dig.FREQ_ERR ));
 sg13g2_nand2_1 _4128_ (.Y(_1277_),
    .A(\pll_dig.flock.cnt_err[0] ),
    .B(net114));
 sg13g2_nand2b_1 _4129_ (.Y(_1278_),
    .B(_0838_),
    .A_N(_1277_));
 sg13g2_or3_1 _4130_ (.A(\pll_dig.COARSE_MUX_D[0] ),
    .B(\pll_dig.flock.cnt_err[0] ),
    .C(_0838_),
    .X(_1279_));
 sg13g2_a21oi_1 _4131_ (.A1(_1278_),
    .A2(_1279_),
    .Y(_1280_),
    .B1(_0842_));
 sg13g2_nor2_1 _4132_ (.A(_0840_),
    .B(_1280_),
    .Y(_1281_));
 sg13g2_nor4_1 _4133_ (.A(\pll_dig.flock.cnt_err[4] ),
    .B(\pll_dig.flock.cnt_err[5] ),
    .C(\pll_dig.flock.cnt_err[3] ),
    .D(\pll_dig.flock.cnt_err[2] ),
    .Y(_1282_));
 sg13g2_nor2_1 _4134_ (.A(\pll_dig.flock.cnt_err[1] ),
    .B(\pll_dig.flock.cnt_err[0] ),
    .Y(_1283_));
 sg13g2_inv_1 _4135_ (.Y(_0563_),
    .A(\pll_dig.out_edges_g2_q[4] ));
 sg13g2_nand4_1 _4136_ (.B(\pll_dig.flock.cnt_err[6] ),
    .C(_1282_),
    .A(_0602_),
    .Y(_1284_),
    .D(_1283_));
 sg13g2_o21ai_1 _4137_ (.B1(_1276_),
    .Y(_0011_),
    .A1(_1281_),
    .A2(_1284_));
 sg13g2_xnor2_1 _4138_ (.Y(\pll_dig.out_edges_next[9] ),
    .A(\pll_dig.out_edges[9] ),
    .B(_1264_));
 sg13g2_nand3_1 _4139_ (.B(\pll_dig.div_rst_cnt[1] ),
    .C(_1267_),
    .A(\pll_dig.div_rst_cnt[0] ),
    .Y(_1285_));
 sg13g2_a21o_1 _4140_ (.A2(_1267_),
    .A1(\pll_dig.div_rst_cnt[0] ),
    .B1(\pll_dig.div_rst_cnt[1] ),
    .X(_1286_));
 sg13g2_and2_1 _4141_ (.A(_1285_),
    .B(_1286_),
    .X(_0448_));
 sg13g2_nor2b_1 _4142_ (.A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .B_N(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .Y(_0045_));
 sg13g2_xor2_1 _4143_ (.B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .X(_0046_));
 sg13g2_a21oi_1 _4144_ (.A1(net103),
    .A2(_1275_),
    .Y(\pll_dig.FINE_MUX_D[14] ),
    .B1(net99));
 sg13g2_a21oi_1 _4145_ (.A1(net103),
    .A2(_1151_),
    .Y(\pll_dig.FINE_MUX_D[13] ),
    .B1(net99));
 sg13g2_inv_1 _4146_ (.Y(_0488_),
    .A(\pll_dig.cntf[6] ));
 sg13g2_inv_1 _4147_ (.Y(_0564_),
    .A(\pll_dig.out_edges_g2[2] ));
 sg13g2_a21oi_1 _4148_ (.A1(net103),
    .A2(_1268_),
    .Y(\pll_dig.FINE_MUX_D[9] ),
    .B1(net99));
 sg13g2_a21oi_1 _4149_ (.A1(net103),
    .A2(_1272_),
    .Y(\pll_dig.FINE_MUX_D[10] ),
    .B1(net99));
 sg13g2_nor3_1 _4150_ (.A(\pll_dig.FILTER_DEC[2] ),
    .B(\pll_dig.FILTER_DEC[0] ),
    .C(\pll_dig.FILTER_DEC[1] ),
    .Y(_1287_));
 sg13g2_o21ai_1 _4151_ (.B1(net94),
    .Y(\pll_dig.FINE_MUX_D[16] ),
    .A1(_0492_),
    .A2(_1287_));
 sg13g2_nor3_1 _4152_ (.A(\pll_dig.div.p_hi ),
    .B(\pll_dig.div.n_hi ),
    .C(net408),
    .Y(_1288_));
 sg13g2_a21oi_1 _4153_ (.A1(net405),
    .A2(net403),
    .Y(_1289_),
    .B1(\pll_dig.div.out_reg ));
 sg13g2_nor3_1 _4154_ (.A(\pll_dig.div.use_clk ),
    .B(_1288_),
    .C(_1289_),
    .Y(_1290_));
 sg13g2_a21o_1 _4155_ (.A2(\pll_dig.div.use_clk ),
    .A1(clknet_1_1__leaf_net59),
    .B1(_1290_),
    .X(net60));
 sg13g2_inv_1 _4156__354 (.Y(net353),
    .A(clknet_1_0__leaf_net60_regs));
 sg13g2_nor2_1 _4157_ (.A(_0536_),
    .B(_0665_),
    .Y(_0124_));
 sg13g2_inv_1 _4158_ (.Y(_0565_),
    .A(\pll_dig.out_edges_g2_q[2] ));
 sg13g2_xnor2_1 _4159_ (.Y(_0131_),
    .A(net12),
    .B(_0665_));
 sg13g2_o21ai_1 _4160_ (.B1(_0671_),
    .Y(_1291_),
    .A1(net96),
    .A2(\pll_dig.dsm_impl.dsm.cin_stg1 ));
 sg13g2_nor2_1 _4161_ (.A(_0672_),
    .B(_1291_),
    .Y(_0447_));
 sg13g2_and2_1 _4162_ (.A(net96),
    .B(_0676_),
    .X(_1292_));
 sg13g2_xor2_1 _4163_ (.B(_1292_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .X(_0446_));
 sg13g2_nand3_1 _4164_ (.B(_1040_),
    .C(_1041_),
    .A(_1021_),
    .Y(_1293_));
 sg13g2_a21oi_1 _4165_ (.A1(_1042_),
    .A2(_1293_),
    .Y(_1294_),
    .B1(net110));
 sg13g2_a21oi_1 _4166_ (.A1(net110),
    .A2(_0537_),
    .Y(_0445_),
    .B1(_1294_));
 sg13g2_nand2_1 _4167_ (.Y(_1295_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[2] ),
    .B(net108));
 sg13g2_o21ai_1 _4168_ (.B1(_1295_),
    .Y(_0444_),
    .A1(net108),
    .A2(net362));
 sg13g2_inv_1 _4169_ (.Y(_0566_),
    .A(\pll_dig.out_edges_g2[0] ));
 sg13g2_mux2_1 _4170_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[9] ),
    .A1(_1012_),
    .S(_0520_),
    .X(_0443_));
 sg13g2_xor2_1 _4171_ (.B(net6),
    .A(net5),
    .X(_0125_));
 sg13g2_inv_1 _4172_ (.Y(_0147_),
    .A(_0125_));
 sg13g2_a21o_1 _4173_ (.A2(_0663_),
    .A1(net9),
    .B1(net10),
    .X(_1296_));
 sg13g2_and2_1 _4174_ (.A(_0664_),
    .B(_1296_),
    .X(_0129_));
 sg13g2_nand2_1 _4175_ (.Y(_1297_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .B(net105));
 sg13g2_o21ai_1 _4176_ (.B1(_1297_),
    .Y(_0442_),
    .A1(net105),
    .A2(_1051_));
 sg13g2_nand2b_1 _4177_ (.Y(_1298_),
    .B(_1031_),
    .A_N(_1030_));
 sg13g2_nand3_1 _4178_ (.B(_1032_),
    .C(_1298_),
    .A(net96),
    .Y(_1299_));
 sg13g2_o21ai_1 _4179_ (.B1(_1299_),
    .Y(_0441_),
    .A1(net96),
    .A2(_0539_));
 sg13g2_inv_1 _4180_ (.Y(_0567_),
    .A(\pll_dig.dlf.INT[14] ));
 sg13g2_nand3_1 _4181_ (.B(_1042_),
    .C(net376),
    .A(_1019_),
    .Y(_1300_));
 sg13g2_a21oi_1 _4182_ (.A1(net368),
    .A2(_1300_),
    .Y(_1301_),
    .B1(net112));
 sg13g2_a21oi_1 _4183_ (.A1(net112),
    .A2(_0523_),
    .Y(_0440_),
    .B1(_1301_));
 sg13g2_mux2_1 _4184_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .A1(_1026_),
    .S(net97),
    .X(_0439_));
 sg13g2_nand2_1 _4185_ (.Y(_1302_),
    .A(net105),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[10] ));
 sg13g2_o21ai_1 _4186_ (.B1(_1302_),
    .Y(_0438_),
    .A1(net106),
    .A2(net357));
 sg13g2_nor3_1 _4187_ (.A(net7),
    .B(net5),
    .C(net6),
    .Y(_1303_));
 sg13g2_and2_1 _4188_ (.A(_0538_),
    .B(_1303_),
    .X(_1304_));
 sg13g2_nor2b_1 _4189_ (.A(net9),
    .B_N(_1304_),
    .Y(_1305_));
 sg13g2_nor2b_1 _4190_ (.A(net10),
    .B_N(_1305_),
    .Y(_1306_));
 sg13g2_inv_1 _4191_ (.Y(_0568_),
    .A(net120));
 sg13g2_and2_1 _4192_ (.A(_0490_),
    .B(_1306_),
    .X(_1307_));
 sg13g2_and2_1 _4193_ (.A(_0536_),
    .B(_1307_),
    .X(_0154_));
 sg13g2_xnor2_1 _4194_ (.Y(_0153_),
    .A(_0536_),
    .B(_1307_));
 sg13g2_xor2_1 _4195_ (.B(_1304_),
    .A(net9),
    .X(_0150_));
 sg13g2_xor2_1 _4196_ (.B(_1305_),
    .A(net10),
    .X(_0151_));
 sg13g2_o21ai_1 _4197_ (.B1(net7),
    .Y(_1308_),
    .A1(net5),
    .A2(net6));
 sg13g2_nand2b_1 _4198_ (.Y(_0148_),
    .B(_1308_),
    .A_N(_1303_));
 sg13g2_xnor2_1 _4199_ (.Y(_0145_),
    .A(\pll_dig.flock.cnt_gray_s2[8] ),
    .B(_0934_));
 sg13g2_xor2_1 _4200_ (.B(_0145_),
    .A(\pll_dig.flock.cnt_gray_s2[7] ),
    .X(_0144_));
 sg13g2_xnor2_1 _4201_ (.Y(_1309_),
    .A(\pll_dig.flock.cnt_gray_s2[6] ),
    .B(_0144_));
 sg13g2_inv_1 _4202_ (.Y(_0569_),
    .A(net692));
 sg13g2_inv_1 _4203_ (.Y(_0143_),
    .A(_1309_));
 sg13g2_xnor2_1 _4204_ (.Y(_0142_),
    .A(\pll_dig.flock.cnt_gray_s2[5] ),
    .B(_1309_));
 sg13g2_xor2_1 _4205_ (.B(_0142_),
    .A(\pll_dig.flock.cnt_gray_s2[4] ),
    .X(_0141_));
 sg13g2_xnor2_1 _4206_ (.Y(_1310_),
    .A(\pll_dig.flock.cnt_gray_s2[3] ),
    .B(_0141_));
 sg13g2_inv_1 _4207_ (.Y(_0140_),
    .A(_1310_));
 sg13g2_xnor2_1 _4208_ (.Y(_0139_),
    .A(\pll_dig.flock.cnt_gray_s2[2] ),
    .B(_1310_));
 sg13g2_xor2_1 _4209_ (.B(_0832_),
    .A(\pll_dig.flock.cnt_coarse_wait[3] ),
    .X(_1311_));
 sg13g2_o21ai_1 _4210_ (.B1(net70),
    .Y(_0016_),
    .A1(_0846_),
    .A2(_1311_));
 sg13g2_xnor2_1 _4211_ (.Y(_1312_),
    .A(\pll_dig.flock.cnt_coarse_wait[2] ),
    .B(_0831_));
 sg13g2_o21ai_1 _4212_ (.B1(net70),
    .Y(_0015_),
    .A1(_0846_),
    .A2(_1312_));
 sg13g2_inv_1 _4213_ (.Y(_0570_),
    .A(net17));
 sg13g2_xor2_1 _4214_ (.B(\pll_dig.flock.cnt_coarse_wait[1] ),
    .A(\pll_dig.flock.cnt_coarse_wait[0] ),
    .X(_1313_));
 sg13g2_o21ai_1 _4215_ (.B1(net70),
    .Y(_0014_),
    .A1(_0846_),
    .A2(_1313_));
 sg13g2_nand2_1 _4216_ (.Y(_1314_),
    .A(\pll_dig.flock.cnt_done[2] ),
    .B(_1101_));
 sg13g2_nor3_1 _4217_ (.A(\pll_dig.flock.cnt_done[2] ),
    .B(_1144_),
    .C(_1146_),
    .Y(_1315_));
 sg13g2_o21ai_1 _4218_ (.B1(\pll_dig.flock.cnt_done[2] ),
    .Y(_1316_),
    .A1(_1144_),
    .A2(_1146_));
 sg13g2_nand2b_1 _4219_ (.Y(_1317_),
    .B(_1316_),
    .A_N(_1142_));
 sg13g2_o21ai_1 _4220_ (.B1(_1314_),
    .Y(_0023_),
    .A1(_1315_),
    .A2(_1317_));
 sg13g2_nor2_1 _4221_ (.A(net94),
    .B(_1287_),
    .Y(\pll_dig.FINE_MUX_D[24] ));
 sg13g2_nand2_1 _4222_ (.Y(\pll_dig.flock.u_fll_icg.EN ),
    .A(\pll_dig.FREQ_LOCKED ),
    .B(net585));
 sg13g2_o21ai_1 _4223_ (.B1(net94),
    .Y(\pll_dig.FINE_MUX_D[21] ),
    .A1(net103),
    .A2(_1151_));
 sg13g2_inv_1 _4224_ (.Y(_0571_),
    .A(net695));
 sg13g2_nor2_1 _4225_ (.A(net505),
    .B(_0051_),
    .Y(net58));
 sg13g2_xor2_1 _4226_ (.B(_0663_),
    .A(net9),
    .X(_0128_));
 sg13g2_nand3_1 _4227_ (.B(_1032_),
    .C(_1033_),
    .A(_1029_),
    .Y(_1318_));
 sg13g2_a21oi_1 _4228_ (.A1(_1034_),
    .A2(_1318_),
    .Y(_1319_),
    .B1(net108));
 sg13g2_a21oi_1 _4229_ (.A1(net109),
    .A2(_0591_),
    .Y(_0437_),
    .B1(_1319_));
 sg13g2_nand2_1 _4230_ (.Y(_1320_),
    .A(net109),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[4] ));
 sg13g2_o21ai_1 _4231_ (.B1(_1320_),
    .Y(_0436_),
    .A1(net109),
    .A2(net363));
 sg13g2_nand2_1 _4232_ (.Y(_1321_),
    .A(\pll_dig.flock.cnt_done[1] ),
    .B(_1101_));
 sg13g2_xnor2_1 _4233_ (.Y(_1322_),
    .A(\pll_dig.flock.cnt_done[1] ),
    .B(\pll_dig.flock.cnt_done[0] ));
 sg13g2_xnor2_1 _4234_ (.Y(_1323_),
    .A(net575),
    .B(_1322_));
 sg13g2_inv_1 _4235_ (.Y(_0572_),
    .A(\pll_dig.dlf.INT[11] ));
 sg13g2_o21ai_1 _4236_ (.B1(_1321_),
    .Y(_0022_),
    .A1(_1142_),
    .A2(net576));
 sg13g2_o21ai_1 _4237_ (.B1(net95),
    .Y(\pll_dig.FINE_MUX_D[22] ),
    .A1(_1270_),
    .A2(_1271_));
 sg13g2_nand3_1 _4238_ (.B(_0945_),
    .C(_0946_),
    .A(_0943_),
    .Y(_1324_));
 sg13g2_a21oi_1 _4239_ (.A1(_0947_),
    .A2(_1324_),
    .Y(_1325_),
    .B1(net107));
 sg13g2_a21oi_1 _4240_ (.A1(net107),
    .A2(_0522_),
    .Y(_0435_),
    .B1(_1325_));
 sg13g2_a21oi_1 _4241_ (.A1(_1073_),
    .A2(net366),
    .Y(\pll_dig.FILTER_DEC_RAW[4] ),
    .B1(_1091_));
 sg13g2_nand2b_1 _4242_ (.Y(\pll_dig.FINE_MUX_D[3] ),
    .B(net100),
    .A_N(net104));
 sg13g2_nand2_1 _4243_ (.Y(\pll_dig.FINE_MUX_D[0] ),
    .A(net100),
    .B(_1287_));
 sg13g2_nand2_1 _4244_ (.Y(\pll_dig.FINE_MUX_D[6] ),
    .A(net100),
    .B(_1275_));
 sg13g2_xnor2_1 _4245_ (.Y(_0183_),
    .A(_1219_),
    .B(net520));
 sg13g2_inv_1 _4246_ (.Y(_0573_),
    .A(\pll_dig.dlf.INT[10] ));
 sg13g2_xnor2_1 _4247_ (.Y(_1326_),
    .A(\pll_dig.flock.cnt_coarse_wait[5] ),
    .B(_0834_));
 sg13g2_o21ai_1 _4248_ (.B1(net70),
    .Y(_0018_),
    .A1(_0846_),
    .A2(_1326_));
 sg13g2_a21o_1 _4249_ (.A2(net125),
    .A1(net426),
    .B1(_0913_),
    .X(_0434_));
 sg13g2_nand3_1 _4250_ (.B(_0906_),
    .C(\pll_dig.flock.cnt[10] ),
    .A(\pll_dig.flock.cnt[9] ),
    .Y(_1327_));
 sg13g2_nor2_1 _4251_ (.A(net125),
    .B(net424),
    .Y(_1328_));
 sg13g2_nor2_1 _4252_ (.A(\pll_dig.flock.cnt[10] ),
    .B(net130),
    .Y(_1329_));
 sg13g2_nor3_1 _4253_ (.A(_0916_),
    .B(_1328_),
    .C(_1329_),
    .Y(_0433_));
 sg13g2_mux2_1 _4254_ (.A0(\pll_dig.flock.cnt_gray[2] ),
    .A1(\pll_dig.flock.cnt[4] ),
    .S(_0901_),
    .X(_1330_));
 sg13g2_nor2_1 _4255_ (.A(_0911_),
    .B(_1330_),
    .Y(_1331_));
 sg13g2_a21oi_1 _4256_ (.A1(\pll_dig.flock.cnt[4] ),
    .A2(_0911_),
    .Y(_0432_),
    .B1(_1331_));
 sg13g2_dfrbpq_1 _4257_ (.RESET_B(net147),
    .D(_0232_),
    .Q(_0163_),
    .CLK(clknet_5_28__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4258_ (.RESET_B(net147),
    .D(\pll_dig.div.low_count_pend[1] ),
    .Q(\pll_dig.div.low_count[1] ),
    .CLK(clknet_5_30__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4259_ (.RESET_B(net148),
    .D(\pll_dig.div.low_count_pend[2] ),
    .Q(\pll_dig.div.low_count[2] ),
    .CLK(clknet_5_30__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4260_ (.RESET_B(net142),
    .D(\pll_dig.div.low_count_pend[3] ),
    .Q(\pll_dig.div.low_count[3] ),
    .CLK(clknet_5_17__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4261_ (.RESET_B(net142),
    .D(\pll_dig.div.low_count_pend[4] ),
    .Q(\pll_dig.div.low_count[4] ),
    .CLK(clknet_5_22__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4262_ (.RESET_B(net142),
    .D(\pll_dig.div.low_count_pend[5] ),
    .Q(\pll_dig.div.low_count[5] ),
    .CLK(clknet_5_21__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4263_ (.RESET_B(net142),
    .D(\pll_dig.div.low_count_pend[6] ),
    .Q(\pll_dig.div.low_count[6] ),
    .CLK(clknet_5_5__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4264_ (.RESET_B(net189),
    .D(_0075_),
    .Q(\pll_dig.flock.cnt_cap[1] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4265_ (.RESET_B(net189),
    .D(_0076_),
    .Q(\pll_dig.flock.cnt_cap[2] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4266_ (.RESET_B(net189),
    .D(_0077_),
    .Q(\pll_dig.flock.cnt_cap[3] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4267_ (.RESET_B(net189),
    .D(_0078_),
    .Q(\pll_dig.flock.cnt_cap[4] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4268_ (.RESET_B(net190),
    .D(_0079_),
    .Q(\pll_dig.flock.cnt_cap[5] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4269_ (.RESET_B(net190),
    .D(_0080_),
    .Q(\pll_dig.flock.cnt_cap[6] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4270_ (.RESET_B(net190),
    .D(_0081_),
    .Q(\pll_dig.flock.cnt_cap[7] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4271_ (.RESET_B(net197),
    .D(_0082_),
    .Q(\pll_dig.flock.cnt_cap[8] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4272_ (.RESET_B(net197),
    .D(_0083_),
    .Q(\pll_dig.flock.cnt_cap[9] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4273_ (.RESET_B(net197),
    .D(_0069_),
    .Q(\pll_dig.flock.cnt_cap[10] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4274_ (.RESET_B(net204),
    .D(_0070_),
    .Q(\pll_dig.flock.cnt_cap[11] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4275_ (.RESET_B(net204),
    .D(_0071_),
    .Q(\pll_dig.flock.cnt_cap[12] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4276_ (.RESET_B(net204),
    .D(_0072_),
    .Q(\pll_dig.flock.cnt_cap[13] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4277_ (.RESET_B(net204),
    .D(_0073_),
    .Q(\pll_dig.flock.cnt_cap[14] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4278_ (.RESET_B(net204),
    .D(_0074_),
    .Q(\pll_dig.flock.cnt_cap[15] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4279_ (.RESET_B(net184),
    .D(_0374_),
    .Q(\pll_dig.clr_toggle ),
    .CLK(net340));
 sg13g2_dfrbpq_1 _4280_ (.RESET_B(net139),
    .D(_0249_),
    .Q(_0164_),
    .CLK(clknet_5_25__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4281_ (.RESET_B(net145),
    .D(_0063_),
    .Q(\pll_dig.div.lo_pend[1] ),
    .CLK(clknet_5_27__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4282_ (.RESET_B(net145),
    .D(_0064_),
    .Q(\pll_dig.div.lo_pend[2] ),
    .CLK(clknet_5_30__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4283_ (.RESET_B(net146),
    .D(_0065_),
    .Q(\pll_dig.div.lo_pend[3] ),
    .CLK(clknet_5_16__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4284_ (.RESET_B(net142),
    .D(_0066_),
    .Q(\pll_dig.div.lo_pend[4] ),
    .CLK(clknet_5_21__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4285_ (.RESET_B(net136),
    .D(_0067_),
    .Q(\pll_dig.div.lo_pend[5] ),
    .CLK(clknet_5_13__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4286_ (.RESET_B(net136),
    .D(_0068_),
    .Q(\pll_dig.div.lo_pend[6] ),
    .CLK(clknet_5_7__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4287_ (.RESET_B(net236),
    .D(_0414_),
    .Q(\pll_dig.div_rst_cnt[0] ),
    .CLK(clknet_5_9__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4288_ (.RESET_B(net225),
    .D(_0448_),
    .Q(\pll_dig.div_rst_cnt[1] ),
    .CLK(clknet_5_9__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4289_ (.RESET_B(net225),
    .D(_0409_),
    .Q(\pll_dig.div_rst_cnt[2] ),
    .CLK(clknet_5_1__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4290_ (.RESET_B(net236),
    .D(_0471_),
    .Q(\pll_dig.div_rst_cnt[3] ),
    .CLK(clknet_5_1__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4291_ (.RESET_B(net179),
    .D(_0449_),
    .Q(DCO_EN),
    .CLK(net339));
 sg13g2_dfrbpq_1 _4292_ (.RESET_B(net181),
    .D(_0474_),
    .Q(net57),
    .CLK(net338));
 sg13g2_dfrbpq_1 _4293_ (.RESET_B(net180),
    .D(_0408_),
    .Q(\pll_dig.ENABLE ),
    .CLK(net337));
 sg13g2_dfrbpq_1 _4294_ (.RESET_B(net179),
    .D(net595),
    .Q(\pll_dig.START ),
    .CLK(net336));
 sg13g2_dfrbpq_1 _4295_ (.RESET_B(net221),
    .D(_0475_),
    .Q(\pll_dig.locked_q ),
    .CLK(net335));
 sg13g2_dfrbpq_1 _4296_ (.RESET_B(net184),
    .D(net613),
    .Q(\pll_dig.FORCE_P ),
    .CLK(net334));
 sg13g2_dfrbpq_1 _4297_ (.RESET_B(net180),
    .D(net616),
    .Q(\pll_dig.FORCE_N ),
    .CLK(net333));
 sg13g2_dfrbpq_1 _4298_ (.RESET_B(net195),
    .D(_0469_),
    .Q(\pll_dig.cnt[0] ),
    .CLK(net332));
 sg13g2_dfrbpq_1 _4299_ (.RESET_B(net195),
    .D(_0473_),
    .Q(\pll_dig.cnt[1] ),
    .CLK(net331));
 sg13g2_dfrbpq_1 _4300_ (.RESET_B(net179),
    .D(net605),
    .Q(\pll_dig.cnt[2] ),
    .CLK(net330));
 sg13g2_dfrbpq_1 _4301_ (.RESET_B(net179),
    .D(net656),
    .Q(\pll_dig.cnt[3] ),
    .CLK(net329));
 sg13g2_dfrbpq_1 _4302_ (.RESET_B(net180),
    .D(_0468_),
    .Q(\pll_dig.cnt[4] ),
    .CLK(net328));
 sg13g2_dfrbpq_1 _4303_ (.RESET_B(net195),
    .D(_0451_),
    .Q(\pll_dig.cnt[5] ),
    .CLK(net327));
 sg13g2_dfrbpq_1 _4304_ (.RESET_B(net200),
    .D(_0452_),
    .Q(\pll_dig.cnt[6] ),
    .CLK(net326));
 sg13g2_dfrbpq_1 _4305_ (.RESET_B(net184),
    .D(net610),
    .Q(\pll_dig.cnt[7] ),
    .CLK(net325));
 sg13g2_dfrbpq_1 _4306_ (.RESET_B(net198),
    .D(_0467_),
    .Q(\pll_dig.cntf[0] ),
    .CLK(net324));
 sg13g2_dfrbpq_1 _4307_ (.RESET_B(net221),
    .D(net629),
    .Q(\pll_dig.cntf[1] ),
    .CLK(net323));
 sg13g2_dfrbpq_1 _4308_ (.RESET_B(net221),
    .D(net621),
    .Q(\pll_dig.cntf[2] ),
    .CLK(net322));
 sg13g2_dfrbpq_1 _4309_ (.RESET_B(net222),
    .D(net647),
    .Q(\pll_dig.cntf[3] ),
    .CLK(net321));
 sg13g2_dfrbpq_1 _4310_ (.RESET_B(net184),
    .D(net645),
    .Q(\pll_dig.cntf[4] ),
    .CLK(net320));
 sg13g2_dfrbpq_1 _4311_ (.RESET_B(net184),
    .D(net652),
    .Q(\pll_dig.cntf[5] ),
    .CLK(net319));
 sg13g2_dfrbpq_1 _4312_ (.RESET_B(net184),
    .D(net593),
    .Q(\pll_dig.cntf[6] ),
    .CLK(net318));
 sg13g2_dfrbpq_1 _4313_ (.RESET_B(net198),
    .D(_0402_),
    .Q(\pll_dig.cntf[7] ),
    .CLK(net317));
 sg13g2_dfrbpq_1 _4314_ (.RESET_B(net222),
    .D(_0463_),
    .Q(\pll_dig.ref_fail ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4315_ (.RESET_B(net239),
    .D(_0401_),
    .Q(\pll_dig.dco_miss_cnt[0] ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4316_ (.RESET_B(net240),
    .D(_0462_),
    .Q(\pll_dig.dco_miss_cnt[1] ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4317_ (.RESET_B(net222),
    .D(_0400_),
    .Q(\pll_dig.dco_miss_cnt[2] ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4318_ (.RESET_B(net138),
    .D(_0461_),
    .Q(\pll_dig.div.use_clk ),
    .CLK(net349));
 sg13g2_dfrbpq_2 _4319_ (.RESET_B(net140),
    .D(_0399_),
    .Q(\pll_dig.div.div[0] ),
    .CLK(clknet_5_24__leaf_net59_regs));
 sg13g2_dfrbpq_2 _4320_ (.RESET_B(net139),
    .D(_0460_),
    .Q(_0168_),
    .CLK(clknet_5_24__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4321_ (.RESET_B(net141),
    .D(_0330_),
    .Q(\pll_dig.div.div[2] ),
    .CLK(clknet_5_26__leaf_net59_regs));
 sg13g2_dfrbpq_2 _4322_ (.RESET_B(net141),
    .D(_0321_),
    .Q(\pll_dig.div.div[3] ),
    .CLK(clknet_5_26__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4323_ (.RESET_B(net139),
    .D(_0326_),
    .Q(\pll_dig.div.div[4] ),
    .CLK(clknet_5_18__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4324_ (.RESET_B(net139),
    .D(_0320_),
    .Q(\pll_dig.div.div[5] ),
    .CLK(clknet_5_18__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4325_ (.RESET_B(net139),
    .D(_0323_),
    .Q(\pll_dig.div.div[6] ),
    .CLK(clknet_5_12__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4326_ (.RESET_B(net136),
    .D(_0322_),
    .Q(\pll_dig.div.div[7] ),
    .CLK(clknet_5_12__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4327_ (.RESET_B(net142),
    .D(_0325_),
    .Q(\pll_dig.div.high_phase ),
    .CLK(clknet_5_21__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4328_ (.RESET_B(net138),
    .D(_0362_),
    .Q(\pll_dig.div.out_reg ),
    .CLK(clknet_5_4__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4329_ (.RESET_B(net148),
    .D(_0340_),
    .Q(\pll_dig.div.div_pend[0] ),
    .CLK(clknet_5_31__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4330_ (.RESET_B(net148),
    .D(_0350_),
    .Q(_0157_),
    .CLK(clknet_5_31__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4331_ (.RESET_B(net148),
    .D(_0361_),
    .Q(\pll_dig.div.div_pend[2] ),
    .CLK(clknet_5_30__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4332_ (.RESET_B(net148),
    .D(_0343_),
    .Q(\pll_dig.div.div_pend[3] ),
    .CLK(clknet_5_31__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4333_ (.RESET_B(net147),
    .D(_0339_),
    .Q(\pll_dig.div.div_pend[4] ),
    .CLK(clknet_5_29__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4334_ (.RESET_B(net147),
    .D(_0345_),
    .Q(\pll_dig.div.div_pend[5] ),
    .CLK(clknet_5_29__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4335_ (.RESET_B(net147),
    .D(_0346_),
    .Q(\pll_dig.div.div_pend[6] ),
    .CLK(clknet_5_17__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4336_ (.RESET_B(net147),
    .D(_0348_),
    .Q(\pll_dig.div.div_pend[7] ),
    .CLK(clknet_5_29__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4337_ (.RESET_B(net136),
    .D(_0342_),
    .Q(\pll_dig.div.pend ),
    .CLK(clknet_5_5__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4338_ (.RESET_B(net258),
    .D(_0344_),
    .Q(\pll_dig.div.use_clk_p ),
    .CLK(clknet_5_4__leaf_net59_regs));
 sg13g2_tiehi _4338__259 (.L_HI(net258));
 sg13g2_dfrbpq_1 _4339_ (.RESET_B(net136),
    .D(_0356_),
    .Q(\pll_dig.div.enter_req ),
    .CLK(clknet_5_4__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4340_ (.RESET_B(net136),
    .D(_0338_),
    .Q(\pll_dig.div.leave_req ),
    .CLK(clknet_5_20__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4341_ (.RESET_B(net216),
    .D(_0351_),
    .Q(\pll_dig.dlf.INT[0] ),
    .CLK(net316));
 sg13g2_dfrbpq_1 _4342_ (.RESET_B(net216),
    .D(_0359_),
    .Q(\pll_dig.dlf.INT[1] ),
    .CLK(net315));
 sg13g2_dfrbpq_1 _4343_ (.RESET_B(net217),
    .D(_0341_),
    .Q(\pll_dig.dlf.INT[2] ),
    .CLK(net314));
 sg13g2_dfrbpq_1 _4344_ (.RESET_B(net217),
    .D(_0363_),
    .Q(\pll_dig.dlf.INT[3] ),
    .CLK(net313));
 sg13g2_dfrbpq_1 _4345_ (.RESET_B(net217),
    .D(_0328_),
    .Q(\pll_dig.dlf.INT[4] ),
    .CLK(net312));
 sg13g2_dfrbpq_1 _4346_ (.RESET_B(net229),
    .D(_0327_),
    .Q(\pll_dig.dlf.INT[5] ),
    .CLK(net311));
 sg13g2_dfrbpq_1 _4347_ (.RESET_B(net229),
    .D(_0329_),
    .Q(\pll_dig.dlf.INT[6] ),
    .CLK(net310));
 sg13g2_dfrbpq_1 _4348_ (.RESET_B(net229),
    .D(_0360_),
    .Q(\pll_dig.dlf.INT[7] ),
    .CLK(net309));
 sg13g2_dfrbpq_1 _4349_ (.RESET_B(net217),
    .D(_0358_),
    .Q(\pll_dig.dlf.INT[8] ),
    .CLK(net308));
 sg13g2_dfrbpq_1 _4350_ (.RESET_B(net218),
    .D(_0357_),
    .Q(\pll_dig.dlf.INT[9] ),
    .CLK(net307));
 sg13g2_dfrbpq_1 _4351_ (.RESET_B(net218),
    .D(_0355_),
    .Q(\pll_dig.dlf.INT[10] ),
    .CLK(net306));
 sg13g2_dfrbpq_1 _4352_ (.RESET_B(net218),
    .D(_0349_),
    .Q(\pll_dig.dlf.INT[11] ),
    .CLK(net305));
 sg13g2_dfrbpq_1 _4353_ (.RESET_B(net216),
    .D(_0353_),
    .Q(\pll_dig.dlf.INT[12] ),
    .CLK(net304));
 sg13g2_dfrbpq_1 _4354_ (.RESET_B(net176),
    .D(_0347_),
    .Q(\pll_dig.dlf.INT[13] ),
    .CLK(net303));
 sg13g2_dfrbpq_1 _4355_ (.RESET_B(net216),
    .D(_0352_),
    .Q(\pll_dig.dlf.INT[14] ),
    .CLK(net302));
 sg13g2_dfrbpq_1 _4356_ (.RESET_B(net176),
    .D(_0354_),
    .Q(_0158_),
    .CLK(net301));
 sg13g2_dfrbpq_1 _4357_ (.RESET_B(net229),
    .D(_0447_),
    .Q(\pll_dig.dsm_impl.dsm.cin_stg1 ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4358_ (.RESET_B(net229),
    .D(_0478_),
    .Q(\pll_dig.dsm_impl.dsm.cin_stg2 ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4359_ (.RESET_B(net224),
    .D(_0442_),
    .Q(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4360_ (.RESET_B(net220),
    .D(_0413_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4361_ (.RESET_B(net225),
    .D(_0368_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4362_ (.RESET_B(net226),
    .D(_0333_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4363_ (.RESET_B(net224),
    .D(_0332_),
    .Q(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4364_ (.RESET_B(net233),
    .D(_0446_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4365_ (.RESET_B(net233),
    .D(_0477_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4366_ (.RESET_B(net232),
    .D(_0441_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[2] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4367_ (.RESET_B(net232),
    .D(_0437_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4368_ (.RESET_B(net232),
    .D(_0412_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4369_ (.RESET_B(net232),
    .D(_0369_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4370_ (.RESET_B(net237),
    .D(_0334_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4371_ (.RESET_B(net237),
    .D(_0445_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[7] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4372_ (.RESET_B(net237),
    .D(_0440_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4373_ (.RESET_B(net236),
    .D(_0411_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4374_ (.RESET_B(net236),
    .D(_0367_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4375_ (.RESET_B(net235),
    .D(_0335_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4376_ (.RESET_B(net233),
    .D(_0331_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[0] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4377_ (.RESET_B(net233),
    .D(_0366_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4378_ (.RESET_B(net232),
    .D(_0444_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[2] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4379_ (.RESET_B(net234),
    .D(_0439_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4380_ (.RESET_B(net234),
    .D(_0436_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4381_ (.RESET_B(net234),
    .D(_0410_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[5] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4382_ (.RESET_B(net237),
    .D(_0370_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[6] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4383_ (.RESET_B(net237),
    .D(_0336_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[7] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4384_ (.RESET_B(net237),
    .D(_0365_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[8] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4385_ (.RESET_B(net235),
    .D(_0443_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[9] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4386_ (.RESET_B(net235),
    .D(_0438_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4387_ (.RESET_B(net224),
    .D(_0406_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_2 _4388_ (.RESET_B(net233),
    .D(_0337_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4389_ (.RESET_B(net233),
    .D(_0435_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4390_ (.RESET_B(net233),
    .D(_0373_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4391_ (.RESET_B(net232),
    .D(_0422_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4392_ (.RESET_B(net232),
    .D(_0372_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4393_ (.RESET_B(net232),
    .D(_0371_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4394_ (.RESET_B(net237),
    .D(_0296_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4395_ (.RESET_B(net238),
    .D(_0302_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4396_ (.RESET_B(net236),
    .D(_0286_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4397_ (.RESET_B(net235),
    .D(_0382_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4398_ (.RESET_B(net235),
    .D(_0421_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4399_ (.RESET_B(net224),
    .D(_0314_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4400_ (.RESET_B(net182),
    .D(net351),
    .Q(\pll_dig.dsm_impl.DSM_CK ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4401_ (.RESET_B(net169),
    .D(_0289_),
    .Q(\pll_dig.COARSE_MUX_D[0] ),
    .CLK(\clknet_4_2_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4402_ (.RESET_B(net169),
    .D(_0391_),
    .Q(\pll_dig.COARSE_MUX_D[14] ),
    .CLK(\clknet_4_3_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4403_ (.RESET_B(net169),
    .D(_0420_),
    .Q(\pll_dig.COARSE_MUX_D[1] ),
    .CLK(\clknet_4_3_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4404_ (.RESET_B(net169),
    .D(_0304_),
    .Q(\pll_dig.COARSE_MUX_D[2] ),
    .CLK(\clknet_4_2_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4405_ (.RESET_B(net167),
    .D(_0317_),
    .Q(\pll_dig.COARSE_MUX_D[3] ),
    .CLK(\clknet_4_2_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4406_ (.RESET_B(net167),
    .D(_0285_),
    .Q(\pll_dig.COARSE_MUX_D[4] ),
    .CLK(\clknet_4_0_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4407_ (.RESET_B(net167),
    .D(_0375_),
    .Q(\pll_dig.COARSE_MUX_D[5] ),
    .CLK(\clknet_4_0_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4408_ (.RESET_B(net167),
    .D(_0419_),
    .Q(\pll_dig.COARSE_MUX_D[6] ),
    .CLK(\clknet_4_0_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4409_ (.RESET_B(net166),
    .D(_0298_),
    .Q(\pll_dig.COARSE_MUX_D[7] ),
    .CLK(\clknet_4_0_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4410_ (.RESET_B(net166),
    .D(_0308_),
    .Q(\pll_dig.COARSE_MUX_D[8] ),
    .CLK(\clknet_4_0_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4411_ (.RESET_B(net164),
    .D(_0290_),
    .Q(\pll_dig.COARSE_MUX_D[9] ),
    .CLK(\clknet_4_1_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4412_ (.RESET_B(net164),
    .D(_0383_),
    .Q(\pll_dig.COARSE_MUX_D[10] ),
    .CLK(\clknet_4_1_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4413_ (.RESET_B(net164),
    .D(_0418_),
    .Q(\pll_dig.COARSE_MUX_D[11] ),
    .CLK(\clknet_4_1_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4414_ (.RESET_B(net164),
    .D(_0316_),
    .Q(\pll_dig.COARSE_MUX_D[12] ),
    .CLK(\clknet_4_1_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4415_ (.RESET_B(net165),
    .D(_0295_),
    .Q(\pll_dig.COARSE_MUX_D[13] ),
    .CLK(\clknet_4_1_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4416_ (.RESET_B(net169),
    .D(_0288_),
    .Q(\pll_dig.MID_MUX_D[0] ),
    .CLK(\clknet_4_6_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4417_ (.RESET_B(net170),
    .D(_0392_),
    .Q(\pll_dig.MID_MUX_D[14] ),
    .CLK(\clknet_4_7_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4418_ (.RESET_B(net170),
    .D(_0417_),
    .Q(\pll_dig.MID_MUX_D[1] ),
    .CLK(\clknet_4_6_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4419_ (.RESET_B(net170),
    .D(_0307_),
    .Q(\pll_dig.MID_MUX_D[2] ),
    .CLK(\clknet_4_6_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4420_ (.RESET_B(net168),
    .D(_0313_),
    .Q(\pll_dig.MID_MUX_D[3] ),
    .CLK(\clknet_4_3_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4421_ (.RESET_B(net168),
    .D(_0292_),
    .Q(\pll_dig.MID_MUX_D[4] ),
    .CLK(\clknet_4_4_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4422_ (.RESET_B(net172),
    .D(_0376_),
    .Q(\pll_dig.MID_MUX_D[5] ),
    .CLK(\clknet_4_4_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4423_ (.RESET_B(net172),
    .D(_0416_),
    .Q(\pll_dig.MID_MUX_D[6] ),
    .CLK(\clknet_4_4_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4424_ (.RESET_B(net171),
    .D(_0293_),
    .Q(\pll_dig.MID_MUX_D[7] ),
    .CLK(\clknet_4_4_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4425_ (.RESET_B(net171),
    .D(_0303_),
    .Q(\pll_dig.MID_MUX_D[8] ),
    .CLK(\clknet_4_5_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4426_ (.RESET_B(net173),
    .D(_0453_),
    .Q(\pll_dig.MID_MUX_D[9] ),
    .CLK(\clknet_4_5_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4427_ (.RESET_B(net173),
    .D(_0291_),
    .Q(\pll_dig.MID_MUX_D[10] ),
    .CLK(\clknet_4_5_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4428_ (.RESET_B(net173),
    .D(_0384_),
    .Q(\pll_dig.MID_MUX_D[11] ),
    .CLK(\clknet_4_5_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4429_ (.RESET_B(net172),
    .D(_0415_),
    .Q(\pll_dig.MID_MUX_D[12] ),
    .CLK(\clknet_4_4_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4430_ (.RESET_B(net172),
    .D(_0311_),
    .Q(\pll_dig.MID_MUX_D[13] ),
    .CLK(\clknet_4_7_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4431_ (.RESET_B(net173),
    .D(_0300_),
    .Q(\pll_dig.flock.started ),
    .CLK(\clknet_4_12_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4432_ (.RESET_B(net196),
    .D(_0387_),
    .Q(\pll_dig.FREQ_OK ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4433_ (.RESET_B(net196),
    .D(_0389_),
    .Q(\pll_dig.flock.freq_miss[0] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4434_ (.RESET_B(net195),
    .D(_0287_),
    .Q(\pll_dig.flock.freq_miss[1] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4435_ (.RESET_B(net196),
    .D(_0393_),
    .Q(\pll_dig.flock.freq_miss[2] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4436_ (.RESET_B(net211),
    .D(_0459_),
    .Q(\pll_dig.flock.cnt[1] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_2 _4437_ (.RESET_B(net206),
    .D(_0434_),
    .Q(\pll_dig.flock.cnt[2] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_2 _4438_ (.RESET_B(net211),
    .D(_0428_),
    .Q(\pll_dig.flock.cnt[3] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4439_ (.RESET_B(net211),
    .D(_0301_),
    .Q(\pll_dig.flock.cnt[4] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4440_ (.RESET_B(net209),
    .D(_0318_),
    .Q(\pll_dig.flock.cnt[5] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4441_ (.RESET_B(net209),
    .D(_0395_),
    .Q(\pll_dig.flock.cnt[6] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4442_ (.RESET_B(net209),
    .D(_0397_),
    .Q(\pll_dig.flock.cnt[7] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4443_ (.RESET_B(net209),
    .D(_0377_),
    .Q(\pll_dig.flock.cnt[8] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4444_ (.RESET_B(net212),
    .D(_0458_),
    .Q(\pll_dig.flock.cnt[9] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4445_ (.RESET_B(net212),
    .D(_0433_),
    .Q(\pll_dig.flock.cnt[10] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4446_ (.RESET_B(net212),
    .D(_0427_),
    .Q(\pll_dig.flock.cnt[11] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4447_ (.RESET_B(net206),
    .D(_0297_),
    .Q(\pll_dig.flock.cnt[12] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4448_ (.RESET_B(net208),
    .D(_0309_),
    .Q(\pll_dig.flock.cnt[13] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4449_ (.RESET_B(net208),
    .D(_0379_),
    .Q(\pll_dig.flock.cnt[14] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4450_ (.RESET_B(net211),
    .D(_0381_),
    .Q(\pll_dig.flock.cnt[15] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4451_ (.RESET_B(net206),
    .D(_0385_),
    .Q(\pll_dig.flock.cnt_gray[0] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4452_ (.RESET_B(net206),
    .D(_0457_),
    .Q(\pll_dig.flock.cnt_gray[1] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4453_ (.RESET_B(net211),
    .D(_0432_),
    .Q(\pll_dig.flock.cnt_gray[2] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4454_ (.RESET_B(net210),
    .D(_0426_),
    .Q(\pll_dig.flock.cnt_gray[3] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4455_ (.RESET_B(net210),
    .D(_0315_),
    .Q(\pll_dig.flock.cnt_gray[4] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4456_ (.RESET_B(net210),
    .D(_0319_),
    .Q(\pll_dig.flock.cnt_gray[5] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4457_ (.RESET_B(net209),
    .D(_0388_),
    .Q(\pll_dig.flock.cnt_gray[6] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4458_ (.RESET_B(net210),
    .D(_0390_),
    .Q(\pll_dig.flock.cnt_gray[7] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4459_ (.RESET_B(net242),
    .D(_0394_),
    .Q(\pll_dig.flock.cnt_gray[8] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4460_ (.RESET_B(net212),
    .D(_0456_),
    .Q(\pll_dig.flock.cnt_gray[9] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4461_ (.RESET_B(net207),
    .D(_0431_),
    .Q(\pll_dig.flock.cnt_gray[10] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4462_ (.RESET_B(net207),
    .D(_0425_),
    .Q(\pll_dig.flock.cnt_gray[11] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4463_ (.RESET_B(net207),
    .D(_0305_),
    .Q(\pll_dig.flock.cnt_gray[12] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4464_ (.RESET_B(net207),
    .D(_0310_),
    .Q(\pll_dig.flock.cnt_gray[13] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4465_ (.RESET_B(net211),
    .D(_0396_),
    .Q(\pll_dig.flock.cnt_gray[14] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4466_ (.RESET_B(net211),
    .D(_0306_),
    .Q(\pll_dig.flock.cnt_gray[15] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4467_ (.RESET_B(net181),
    .D(net624),
    .Q(\pll_dig.PHASE_LOCK ),
    .CLK(net300));
 sg13g2_dfrbpq_1 _4468_ (.RESET_B(net181),
    .D(net627),
    .Q(\pll_dig.LOCK_LOST ),
    .CLK(net299));
 sg13g2_dfrbpq_1 _4469_ (.RESET_B(net225),
    .D(_0430_),
    .Q(\pll_dig.ref_wd.cnt[0] ),
    .CLK(clknet_5_8__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4470_ (.RESET_B(net225),
    .D(_0424_),
    .Q(\pll_dig.ref_wd.cnt[1] ),
    .CLK(clknet_5_0__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4471_ (.RESET_B(net226),
    .D(_0294_),
    .Q(\pll_dig.ref_wd.cnt[2] ),
    .CLK(clknet_5_1__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4472_ (.RESET_B(net226),
    .D(_0364_),
    .Q(\pll_dig.ref_wd.cnt[3] ),
    .CLK(clknet_5_9__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4473_ (.RESET_B(net226),
    .D(_0380_),
    .Q(\pll_dig.ref_wd.cnt[4] ),
    .CLK(clknet_5_9__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4474_ (.RESET_B(net225),
    .D(_0398_),
    .Q(\pll_dig.ref_wd.cnt[5] ),
    .CLK(clknet_5_10__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4475_ (.RESET_B(net225),
    .D(_0386_),
    .Q(\pll_dig.ref_wd.cnt[6] ),
    .CLK(clknet_5_10__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4476_ (.RESET_B(net222),
    .D(_0454_),
    .Q(\pll_dig.ref_wd.cnt[7] ),
    .CLK(clknet_5_10__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4477_ (.RESET_B(net222),
    .D(_0429_),
    .Q(\pll_dig.ref_wd.cnt[8] ),
    .CLK(clknet_5_8__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4478_ (.RESET_B(net225),
    .D(_0423_),
    .Q(\pll_dig.ref_wd.cnt[9] ),
    .CLK(clknet_5_8__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4479_ (.RESET_B(net222),
    .D(_0312_),
    .Q(_0155_),
    .CLK(clknet_5_8__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4480_ (.RESET_B(net179),
    .D(_0200_),
    .Q(_0156_),
    .CLK(net298));
 sg13g2_dfrbpq_1 _4481_ (.RESET_B(net179),
    .D(_0047_),
    .Q(\pll_dig.state[1] ),
    .CLK(net297));
 sg13g2_dfrbpq_1 _4482_ (.RESET_B(net180),
    .D(net638),
    .Q(\pll_dig.state[2] ),
    .CLK(net296));
 sg13g2_dfrbpq_1 _4483_ (.RESET_B(net179),
    .D(_0049_),
    .Q(\pll_dig.state[3] ),
    .CLK(net295));
 sg13g2_dfrbpq_1 _4484_ (.RESET_B(net184),
    .D(net632),
    .Q(\pll_dig.state[4] ),
    .CLK(net294));
 sg13g2_dfrbpq_1 _4485_ (.RESET_B(net224),
    .D(net697),
    .Q(\pll_dig.dsm_impl.FCWI[1] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4486_ (.RESET_B(net220),
    .D(net701),
    .Q(\pll_dig.dsm_impl.FCWI[2] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4487_ (.RESET_B(net220),
    .D(net699),
    .Q(\pll_dig.dsm_impl.FCWI[3] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4488_ (.RESET_B(net219),
    .D(net729),
    .Q(\pll_dig.dsm_impl.FCWI[4] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4489_ (.RESET_B(\pll_dig.div.rst_n ),
    .D(_0122_),
    .Q(\pll_dig.u_ddr_ck.ck_en ),
    .CLK(net353));
 sg13g2_dfrbpq_2 _4490_ (.RESET_B(net140),
    .D(_0037_),
    .Q(\pll_dig.div.ncnt[0] ),
    .CLK(net342));
 sg13g2_dfrbpq_2 _4491_ (.RESET_B(net140),
    .D(_0038_),
    .Q(\pll_dig.div.ncnt[1] ),
    .CLK(net343));
 sg13g2_dfrbpq_2 _4492_ (.RESET_B(net140),
    .D(_0039_),
    .Q(\pll_dig.div.ncnt[2] ),
    .CLK(net345));
 sg13g2_dfrbpq_1 _4493_ (.RESET_B(net135),
    .D(_0040_),
    .Q(\pll_dig.div.ncnt[3] ),
    .CLK(net346));
 sg13g2_dfrbpq_1 _4494_ (.RESET_B(net140),
    .D(_0041_),
    .Q(\pll_dig.div.ncnt[4] ),
    .CLK(net347));
 sg13g2_dfrbpq_1 _4495_ (.RESET_B(net138),
    .D(_0042_),
    .Q(\pll_dig.div.ncnt[5] ),
    .CLK(net344));
 sg13g2_dfrbpq_1 _4496_ (.RESET_B(net138),
    .D(_0043_),
    .Q(\pll_dig.div.ncnt[6] ),
    .CLK(net348));
 sg13g2_dfrbpq_1 _4497_ (.RESET_B(net134),
    .D(_0044_),
    .Q(\pll_dig.div.ncnt[7] ),
    .CLK(net341));
 sg13g2_dfrbpq_1 _4498_ (.RESET_B(net138),
    .D(_0112_),
    .Q(\pll_dig.div.n_hi ),
    .CLK(clknet_5_3__leaf_net59_regs));
 sg13g2_dfrbpq_2 _4499_ (.RESET_B(net144),
    .D(_0090_),
    .Q(\pll_dig.div.cnt[0] ),
    .CLK(clknet_5_23__leaf_net59_regs));
 sg13g2_dfrbpq_2 _4500_ (.RESET_B(net147),
    .D(_0091_),
    .Q(\pll_dig.div.cnt[1] ),
    .CLK(clknet_5_17__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4501_ (.RESET_B(net144),
    .D(_0092_),
    .Q(\pll_dig.div.cnt[2] ),
    .CLK(clknet_5_17__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4502_ (.RESET_B(net144),
    .D(_0093_),
    .Q(\pll_dig.div.cnt[3] ),
    .CLK(clknet_5_23__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4503_ (.RESET_B(net144),
    .D(_0094_),
    .Q(\pll_dig.div.cnt[4] ),
    .CLK(clknet_5_22__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4504_ (.RESET_B(net144),
    .D(_0095_),
    .Q(\pll_dig.div.cnt[5] ),
    .CLK(clknet_5_22__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4505_ (.RESET_B(net144),
    .D(_0096_),
    .Q(\pll_dig.div.cnt[6] ),
    .CLK(clknet_5_23__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4506_ (.RESET_B(net149),
    .D(_0097_),
    .Q(\pll_dig.div.cnt[7] ),
    .CLK(clknet_5_22__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4507_ (.RESET_B(net147),
    .D(_0260_),
    .Q(_0165_),
    .CLK(clknet_5_16__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4508_ (.RESET_B(net148),
    .D(\pll_dig.div.high_count_pend[1] ),
    .Q(\pll_dig.div.high_count[1] ),
    .CLK(clknet_5_28__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4509_ (.RESET_B(net145),
    .D(\pll_dig.div.high_count_pend[2] ),
    .Q(\pll_dig.div.high_count[2] ),
    .CLK(clknet_5_28__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4510_ (.RESET_B(net146),
    .D(\pll_dig.div.high_count_pend[3] ),
    .Q(\pll_dig.div.high_count[3] ),
    .CLK(clknet_5_28__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4511_ (.RESET_B(net143),
    .D(\pll_dig.div.high_count_pend[4] ),
    .Q(\pll_dig.div.high_count[4] ),
    .CLK(clknet_5_16__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4512_ (.RESET_B(net143),
    .D(\pll_dig.div.high_count_pend[5] ),
    .Q(\pll_dig.div.high_count[5] ),
    .CLK(clknet_5_7__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4513_ (.RESET_B(net142),
    .D(\pll_dig.div.high_count_pend[6] ),
    .Q(\pll_dig.div.high_count[6] ),
    .CLK(clknet_5_20__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4514_ (.RESET_B(net142),
    .D(\pll_dig.div.high_count_pend[7] ),
    .Q(\pll_dig.div.high_count[7] ),
    .CLK(clknet_5_20__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4515_ (.RESET_B(net134),
    .D(_0113_),
    .Q(\pll_dig.div.p_hi ),
    .CLK(clknet_5_3__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4516_ (.RESET_B(net134),
    .D(_0284_),
    .Q(_0169_),
    .CLK(clknet_5_3__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4517_ (.RESET_B(net140),
    .D(net384),
    .Q(\pll_dig.div.div_for_counts_is_pend ),
    .CLK(clknet_5_26__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4518_ (.RESET_B(net140),
    .D(_0219_),
    .Q(_0159_),
    .CLK(clknet_5_15__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4519_ (.RESET_B(net145),
    .D(_0098_),
    .Q(\pll_dig.div.hi_cur[1] ),
    .CLK(clknet_5_25__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4520_ (.RESET_B(net145),
    .D(_0099_),
    .Q(\pll_dig.div.hi_cur[2] ),
    .CLK(clknet_5_19__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4521_ (.RESET_B(net146),
    .D(_0100_),
    .Q(\pll_dig.div.hi_cur[3] ),
    .CLK(clknet_5_19__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4522_ (.RESET_B(net139),
    .D(_0101_),
    .Q(\pll_dig.div.hi_cur[4] ),
    .CLK(clknet_5_18__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4523_ (.RESET_B(net137),
    .D(_0102_),
    .Q(\pll_dig.div.hi_cur[5] ),
    .CLK(clknet_5_13__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4524_ (.RESET_B(net137),
    .D(_0103_),
    .Q(\pll_dig.div.hi_cur[6] ),
    .CLK(clknet_5_6__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4525_ (.RESET_B(net138),
    .D(_0104_),
    .Q(\pll_dig.div.hi_cur[7] ),
    .CLK(clknet_5_5__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4526_ (.RESET_B(net139),
    .D(_0231_),
    .Q(_0162_),
    .CLK(clknet_5_24__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4527_ (.RESET_B(net145),
    .D(_0084_),
    .Q(\pll_dig.div.lo_cur[1] ),
    .CLK(clknet_5_27__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4528_ (.RESET_B(net145),
    .D(_0085_),
    .Q(\pll_dig.div.lo_cur[2] ),
    .CLK(clknet_5_27__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4529_ (.RESET_B(net146),
    .D(_0086_),
    .Q(\pll_dig.div.lo_cur[3] ),
    .CLK(clknet_5_16__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4530_ (.RESET_B(net143),
    .D(_0087_),
    .Q(\pll_dig.div.lo_cur[4] ),
    .CLK(clknet_5_20__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4531_ (.RESET_B(net137),
    .D(_0088_),
    .Q(\pll_dig.div.lo_cur[5] ),
    .CLK(clknet_5_6__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4532_ (.RESET_B(net136),
    .D(_0089_),
    .Q(\pll_dig.div.lo_cur[6] ),
    .CLK(clknet_5_6__leaf_net59_regs));
 sg13g2_dfrbpq_2 _4533_ (.RESET_B(net135),
    .D(_0114_),
    .Q(\pll_dig.div.pcnt[0] ),
    .CLK(clknet_5_14__leaf_net59_regs));
 sg13g2_dfrbpq_2 _4534_ (.RESET_B(net135),
    .D(_0115_),
    .Q(\pll_dig.div.pcnt[1] ),
    .CLK(clknet_5_14__leaf_net59_regs));
 sg13g2_dfrbpq_2 _4535_ (.RESET_B(net135),
    .D(_0116_),
    .Q(\pll_dig.div.pcnt[2] ),
    .CLK(clknet_5_14__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4536_ (.RESET_B(net135),
    .D(_0117_),
    .Q(\pll_dig.div.pcnt[3] ),
    .CLK(clknet_5_11__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4537_ (.RESET_B(net135),
    .D(_0118_),
    .Q(\pll_dig.div.pcnt[4] ),
    .CLK(clknet_5_11__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4538_ (.RESET_B(net134),
    .D(_0119_),
    .Q(\pll_dig.div.pcnt[5] ),
    .CLK(clknet_5_11__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4539_ (.RESET_B(net134),
    .D(_0120_),
    .Q(\pll_dig.div.pcnt[6] ),
    .CLK(clknet_5_2__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4540_ (.RESET_B(net134),
    .D(_0121_),
    .Q(\pll_dig.div.pcnt[7] ),
    .CLK(clknet_5_2__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4541_ (.RESET_B(net139),
    .D(_0220_),
    .Q(_0160_),
    .CLK(clknet_5_24__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4542_ (.RESET_B(net146),
    .D(_0105_),
    .Q(\pll_dig.div.hi_pend[1] ),
    .CLK(clknet_5_25__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4543_ (.RESET_B(net145),
    .D(_0106_),
    .Q(\pll_dig.div.hi_pend[2] ),
    .CLK(clknet_5_25__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4544_ (.RESET_B(net146),
    .D(_0107_),
    .Q(\pll_dig.div.hi_pend[3] ),
    .CLK(clknet_5_19__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4545_ (.RESET_B(net146),
    .D(_0108_),
    .Q(\pll_dig.div.hi_pend[4] ),
    .CLK(clknet_5_18__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4546_ (.RESET_B(net137),
    .D(_0109_),
    .Q(\pll_dig.div.hi_pend[5] ),
    .CLK(clknet_5_13__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4547_ (.RESET_B(net143),
    .D(_0110_),
    .Q(\pll_dig.div.hi_pend[6] ),
    .CLK(clknet_5_7__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4548_ (.RESET_B(net137),
    .D(_0111_),
    .Q(\pll_dig.div.hi_pend[7] ),
    .CLK(clknet_5_6__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4549_ (.RESET_B(net194),
    .D(_0132_),
    .Q(\pll_dig.flock.cnt_bin[0] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4550_ (.RESET_B(net191),
    .D(_0138_),
    .Q(\pll_dig.flock.cnt_bin[1] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4551_ (.RESET_B(net191),
    .D(_0139_),
    .Q(\pll_dig.flock.cnt_bin[2] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4552_ (.RESET_B(net190),
    .D(_0140_),
    .Q(\pll_dig.flock.cnt_bin[3] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4553_ (.RESET_B(net190),
    .D(_0141_),
    .Q(\pll_dig.flock.cnt_bin[4] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4554_ (.RESET_B(net193),
    .D(_0142_),
    .Q(\pll_dig.flock.cnt_bin[5] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4555_ (.RESET_B(net193),
    .D(_0143_),
    .Q(\pll_dig.flock.cnt_bin[6] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4556_ (.RESET_B(net204),
    .D(_0144_),
    .Q(\pll_dig.flock.cnt_bin[7] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4557_ (.RESET_B(net204),
    .D(_0145_),
    .Q(\pll_dig.flock.cnt_bin[8] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4558_ (.RESET_B(net205),
    .D(_0146_),
    .Q(\pll_dig.flock.cnt_bin[9] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4559_ (.RESET_B(net204),
    .D(_0133_),
    .Q(\pll_dig.flock.cnt_bin[10] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4560_ (.RESET_B(net193),
    .D(_0134_),
    .Q(\pll_dig.flock.cnt_bin[11] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4561_ (.RESET_B(net192),
    .D(_0135_),
    .Q(\pll_dig.flock.cnt_bin[12] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4562_ (.RESET_B(net192),
    .D(_0136_),
    .Q(\pll_dig.flock.cnt_bin[13] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4563_ (.RESET_B(net192),
    .D(_0137_),
    .Q(\pll_dig.flock.cnt_bin[14] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4564_ (.RESET_B(net173),
    .D(_0012_),
    .Q(\pll_dig.FREQ_LOCKED ),
    .CLK(\clknet_4_12_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4565_ (.RESET_B(net172),
    .D(_0011_),
    .Q(\pll_dig.FREQ_ERR ),
    .CLK(\clknet_4_7_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4566_ (.RESET_B(net189),
    .D(net504),
    .Q(\pll_dig.flock.cnt_filt[0] ),
    .CLK(\clknet_4_10_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4567_ (.RESET_B(net189),
    .D(net555),
    .Q(\pll_dig.flock.cnt_filt[1] ),
    .CLK(\clknet_4_10_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4568_ (.RESET_B(net189),
    .D(net566),
    .Q(\pll_dig.flock.cnt_filt[2] ),
    .CLK(\clknet_4_10_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4569_ (.RESET_B(net190),
    .D(net571),
    .Q(\pll_dig.flock.cnt_filt[3] ),
    .CLK(\clknet_4_11_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4570_ (.RESET_B(net190),
    .D(net550),
    .Q(\pll_dig.flock.cnt_filt[4] ),
    .CLK(\clknet_4_11_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4571_ (.RESET_B(net190),
    .D(net521),
    .Q(\pll_dig.flock.cnt_filt[5] ),
    .CLK(\clknet_4_11_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4572_ (.RESET_B(net188),
    .D(net517),
    .Q(\pll_dig.flock.cnt_filt[6] ),
    .CLK(\clknet_4_14_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4573_ (.RESET_B(net197),
    .D(net530),
    .Q(\pll_dig.flock.cnt_filt[7] ),
    .CLK(\clknet_4_14_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4574_ (.RESET_B(net195),
    .D(net534),
    .Q(\pll_dig.flock.cnt_filt[8] ),
    .CLK(\clknet_4_13_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4575_ (.RESET_B(net197),
    .D(net538),
    .Q(\pll_dig.flock.cnt_filt[9] ),
    .CLK(\clknet_4_15_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4576_ (.RESET_B(net197),
    .D(net542),
    .Q(\pll_dig.flock.cnt_filt[10] ),
    .CLK(\clknet_4_15_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4577_ (.RESET_B(net201),
    .D(net562),
    .Q(\pll_dig.flock.cnt_filt[11] ),
    .CLK(\clknet_4_15_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4578_ (.RESET_B(net201),
    .D(net546),
    .Q(\pll_dig.flock.cnt_filt[12] ),
    .CLK(\clknet_4_15_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4579_ (.RESET_B(net205),
    .D(net526),
    .Q(\pll_dig.flock.cnt_filt[13] ),
    .CLK(\clknet_4_14_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4580_ (.RESET_B(net210),
    .D(net513),
    .Q(\pll_dig.flock.cnt_filt[14] ),
    .CLK(\clknet_4_14_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4581_ (.RESET_B(net201),
    .D(net509),
    .Q(\pll_dig.flock.cnt_filt[15] ),
    .CLK(\clknet_4_14_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4582_ (.RESET_B(net188),
    .D(_0021_),
    .Q(\pll_dig.flock.cnt_done[0] ),
    .CLK(\clknet_4_12_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4583_ (.RESET_B(net188),
    .D(net577),
    .Q(\pll_dig.flock.cnt_done[1] ),
    .CLK(\clknet_4_12_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4584_ (.RESET_B(net195),
    .D(_0023_),
    .Q(\pll_dig.flock.cnt_done[2] ),
    .CLK(\clknet_4_13_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4585_ (.RESET_B(net195),
    .D(_0024_),
    .Q(\pll_dig.flock.cnt_done[3] ),
    .CLK(\clknet_4_13_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4586_ (.RESET_B(net195),
    .D(_0025_),
    .Q(\pll_dig.flock.cnt_done[4] ),
    .CLK(\clknet_4_13_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4587_ (.RESET_B(net179),
    .D(_0026_),
    .Q(\pll_dig.flock.cnt_done[5] ),
    .CLK(\clknet_4_12_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4588_ (.RESET_B(net172),
    .D(_0027_),
    .Q(\pll_dig.flock.cnt_done[6] ),
    .CLK(\clknet_4_9_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4589_ (.RESET_B(net188),
    .D(_0028_),
    .Q(\pll_dig.flock.cnt_done[7] ),
    .CLK(\clknet_4_9_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4590_ (.RESET_B(net170),
    .D(net584),
    .Q(\pll_dig.flock.cnt_err[0] ),
    .CLK(\clknet_4_6_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4591_ (.RESET_B(net187),
    .D(_0030_),
    .Q(\pll_dig.flock.cnt_err[1] ),
    .CLK(\clknet_4_6_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4592_ (.RESET_B(net187),
    .D(_0031_),
    .Q(\pll_dig.flock.cnt_err[2] ),
    .CLK(\clknet_4_10_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4593_ (.RESET_B(net188),
    .D(_0032_),
    .Q(\pll_dig.flock.cnt_err[3] ),
    .CLK(\clknet_4_11_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4594_ (.RESET_B(net188),
    .D(_0033_),
    .Q(\pll_dig.flock.cnt_err[4] ),
    .CLK(\clknet_4_8_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4595_ (.RESET_B(net194),
    .D(_0034_),
    .Q(\pll_dig.flock.cnt_err[5] ),
    .CLK(\clknet_4_9_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4596_ (.RESET_B(net172),
    .D(_0035_),
    .Q(\pll_dig.flock.cnt_err[6] ),
    .CLK(\clknet_4_9_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4597_ (.RESET_B(net172),
    .D(_0036_),
    .Q(\pll_dig.flock.cnt_err[7] ),
    .CLK(\clknet_4_7_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4598_ (.RESET_B(net169),
    .D(_0013_),
    .Q(\pll_dig.flock.cnt_coarse_wait[0] ),
    .CLK(\clknet_4_2_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4599_ (.RESET_B(net187),
    .D(_0014_),
    .Q(\pll_dig.flock.cnt_coarse_wait[1] ),
    .CLK(\clknet_4_2_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4600_ (.RESET_B(net187),
    .D(_0015_),
    .Q(\pll_dig.flock.cnt_coarse_wait[2] ),
    .CLK(\clknet_4_8_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4601_ (.RESET_B(net187),
    .D(_0016_),
    .Q(\pll_dig.flock.cnt_coarse_wait[3] ),
    .CLK(\clknet_4_8_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4602_ (.RESET_B(net187),
    .D(_0017_),
    .Q(\pll_dig.flock.cnt_coarse_wait[4] ),
    .CLK(\clknet_4_8_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4603_ (.RESET_B(net187),
    .D(_0018_),
    .Q(\pll_dig.flock.cnt_coarse_wait[5] ),
    .CLK(\clknet_4_8_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4604_ (.RESET_B(net188),
    .D(_0019_),
    .Q(\pll_dig.flock.cnt_coarse_wait[6] ),
    .CLK(\clknet_4_10_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4605_ (.RESET_B(net187),
    .D(_0020_),
    .Q(\pll_dig.flock.cnt_coarse_wait[7] ),
    .CLK(\clknet_4_3_0_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4606_ (.RESET_B(net262),
    .D(_0125_),
    .Q(\pll_dig.flock.FCW_PA[1] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4606__263 (.L_HI(net262));
 sg13g2_dfrbpq_1 _4607_ (.RESET_B(net261),
    .D(_0126_),
    .Q(\pll_dig.flock.FCW_PA[2] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4607__262 (.L_HI(net261));
 sg13g2_dfrbpq_1 _4608_ (.RESET_B(net254),
    .D(_0127_),
    .Q(\pll_dig.flock.FCW_PA[3] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4608__255 (.L_HI(net254));
 sg13g2_dfrbpq_1 _4609_ (.RESET_B(net249),
    .D(_0128_),
    .Q(\pll_dig.flock.FCW_PA[4] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4609__250 (.L_HI(net249));
 sg13g2_dfrbpq_1 _4610_ (.RESET_B(net247),
    .D(_0129_),
    .Q(\pll_dig.flock.FCW_PA[5] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4610__248 (.L_HI(net247));
 sg13g2_dfrbpq_1 _4611_ (.RESET_B(net257),
    .D(_0130_),
    .Q(\pll_dig.flock.FCW_PA[6] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_tiehi _4611__258 (.L_HI(net257));
 sg13g2_dfrbpq_1 _4612_ (.RESET_B(net248),
    .D(_0131_),
    .Q(\pll_dig.flock.FCW_PA[7] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_tiehi _4612__249 (.L_HI(net248));
 sg13g2_dfrbpq_1 _4613_ (.RESET_B(net260),
    .D(_0124_),
    .Q(\pll_dig.flock.FCW_PA[8] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_tiehi _4613__261 (.L_HI(net260));
 sg13g2_dfrbpq_1 _4614_ (.RESET_B(net256),
    .D(_0123_),
    .Q(\pll_dig.flock.FCW_NA[0] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4614__257 (.L_HI(net256));
 sg13g2_dfrbpq_1 _4615_ (.RESET_B(net250),
    .D(_0147_),
    .Q(\pll_dig.flock.FCW_NA[1] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4615__251 (.L_HI(net250));
 sg13g2_dfrbpq_1 _4616_ (.RESET_B(net245),
    .D(_0148_),
    .Q(\pll_dig.flock.FCW_NA[2] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4616__246 (.L_HI(net245));
 sg13g2_dfrbpq_1 _4617_ (.RESET_B(net253),
    .D(_0149_),
    .Q(\pll_dig.flock.FCW_NA[3] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4617__254 (.L_HI(net253));
 sg13g2_dfrbpq_1 _4618_ (.RESET_B(net251),
    .D(_0150_),
    .Q(\pll_dig.flock.FCW_NA[4] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4618__252 (.L_HI(net251));
 sg13g2_dfrbpq_1 _4619_ (.RESET_B(net259),
    .D(_0151_),
    .Q(\pll_dig.flock.FCW_NA[5] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4619__260 (.L_HI(net259));
 sg13g2_dfrbpq_1 _4620_ (.RESET_B(net252),
    .D(_0152_),
    .Q(\pll_dig.flock.FCW_NA[6] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_tiehi _4620__253 (.L_HI(net252));
 sg13g2_dfrbpq_1 _4621_ (.RESET_B(net263),
    .D(_0153_),
    .Q(\pll_dig.flock.FCW_NA[7] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_tiehi _4621__264 (.L_HI(net263));
 sg13g2_dfrbpq_1 _4622_ (.RESET_B(net246),
    .D(_0154_),
    .Q(\pll_dig.flock.FCW_NA[10] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_tiehi _4622__247 (.L_HI(net246));
 sg13g2_dfrbpq_1 _4623_ (.RESET_B(net189),
    .D(net255),
    .Q(\pll_dig.flock.cap_valid ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_tiehi _4623__256 (.L_HI(net255));
 sg13g2_dfrbpq_1 _4624_ (.RESET_B(net191),
    .D(\pll_dig.flock.cnt_gray[0] ),
    .Q(\pll_dig.flock.cnt_gray_s1[0] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4625_ (.RESET_B(net191),
    .D(\pll_dig.flock.cnt_gray[1] ),
    .Q(\pll_dig.flock.cnt_gray_s1[1] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4626_ (.RESET_B(net206),
    .D(\pll_dig.flock.cnt_gray[2] ),
    .Q(\pll_dig.flock.cnt_gray_s1[2] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4627_ (.RESET_B(net205),
    .D(\pll_dig.flock.cnt_gray[3] ),
    .Q(\pll_dig.flock.cnt_gray_s1[3] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4628_ (.RESET_B(net205),
    .D(\pll_dig.flock.cnt_gray[4] ),
    .Q(\pll_dig.flock.cnt_gray_s1[4] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4629_ (.RESET_B(net210),
    .D(\pll_dig.flock.cnt_gray[5] ),
    .Q(\pll_dig.flock.cnt_gray_s1[5] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4630_ (.RESET_B(net209),
    .D(\pll_dig.flock.cnt_gray[6] ),
    .Q(\pll_dig.flock.cnt_gray_s1[6] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4631_ (.RESET_B(net242),
    .D(\pll_dig.flock.cnt_gray[7] ),
    .Q(\pll_dig.flock.cnt_gray_s1[7] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4632_ (.RESET_B(net242),
    .D(\pll_dig.flock.cnt_gray[8] ),
    .Q(\pll_dig.flock.cnt_gray_s1[8] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4633_ (.RESET_B(net207),
    .D(\pll_dig.flock.cnt_gray[9] ),
    .Q(\pll_dig.flock.cnt_gray_s1[9] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4634_ (.RESET_B(net207),
    .D(\pll_dig.flock.cnt_gray[10] ),
    .Q(\pll_dig.flock.cnt_gray_s1[10] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4635_ (.RESET_B(net191),
    .D(\pll_dig.flock.cnt_gray[11] ),
    .Q(\pll_dig.flock.cnt_gray_s1[11] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4636_ (.RESET_B(net191),
    .D(\pll_dig.flock.cnt_gray[12] ),
    .Q(\pll_dig.flock.cnt_gray_s1[12] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4637_ (.RESET_B(net192),
    .D(\pll_dig.flock.cnt_gray[13] ),
    .Q(\pll_dig.flock.cnt_gray_s1[13] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4638_ (.RESET_B(net212),
    .D(\pll_dig.flock.cnt_gray[14] ),
    .Q(\pll_dig.flock.cnt_gray_s1[14] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4639_ (.RESET_B(net211),
    .D(\pll_dig.flock.cnt_gray[15] ),
    .Q(\pll_dig.flock.cnt_gray_s1[15] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4640_ (.RESET_B(net191),
    .D(\pll_dig.flock.cnt_gray_s1[0] ),
    .Q(\pll_dig.flock.cnt_gray_s2[0] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4641_ (.RESET_B(net191),
    .D(\pll_dig.flock.cnt_gray_s1[1] ),
    .Q(\pll_dig.flock.cnt_gray_s2[1] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4642_ (.RESET_B(net206),
    .D(\pll_dig.flock.cnt_gray_s1[2] ),
    .Q(\pll_dig.flock.cnt_gray_s2[2] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4643_ (.RESET_B(net205),
    .D(\pll_dig.flock.cnt_gray_s1[3] ),
    .Q(\pll_dig.flock.cnt_gray_s2[3] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4644_ (.RESET_B(net205),
    .D(\pll_dig.flock.cnt_gray_s1[4] ),
    .Q(\pll_dig.flock.cnt_gray_s2[4] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4645_ (.RESET_B(net209),
    .D(\pll_dig.flock.cnt_gray_s1[5] ),
    .Q(\pll_dig.flock.cnt_gray_s2[5] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4646_ (.RESET_B(net210),
    .D(\pll_dig.flock.cnt_gray_s1[6] ),
    .Q(\pll_dig.flock.cnt_gray_s2[6] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4647_ (.RESET_B(net205),
    .D(\pll_dig.flock.cnt_gray_s1[7] ),
    .Q(\pll_dig.flock.cnt_gray_s2[7] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4648_ (.RESET_B(net206),
    .D(\pll_dig.flock.cnt_gray_s1[8] ),
    .Q(\pll_dig.flock.cnt_gray_s2[8] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4649_ (.RESET_B(net206),
    .D(\pll_dig.flock.cnt_gray_s1[9] ),
    .Q(\pll_dig.flock.cnt_gray_s2[9] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4650_ (.RESET_B(net207),
    .D(\pll_dig.flock.cnt_gray_s1[10] ),
    .Q(\pll_dig.flock.cnt_gray_s2[10] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4651_ (.RESET_B(net192),
    .D(\pll_dig.flock.cnt_gray_s1[11] ),
    .Q(\pll_dig.flock.cnt_gray_s2[11] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4652_ (.RESET_B(net192),
    .D(\pll_dig.flock.cnt_gray_s1[12] ),
    .Q(\pll_dig.flock.cnt_gray_s2[12] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4653_ (.RESET_B(net192),
    .D(\pll_dig.flock.cnt_gray_s1[13] ),
    .Q(\pll_dig.flock.cnt_gray_s2[13] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4654_ (.RESET_B(net212),
    .D(\pll_dig.flock.cnt_gray_s1[14] ),
    .Q(\pll_dig.flock.cnt_gray_s2[14] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4655_ (.RESET_B(net212),
    .D(\pll_dig.flock.cnt_gray_s1[15] ),
    .Q(\pll_dig.flock.cnt_gray_s2[15] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4656_ (.RESET_B(net202),
    .D(_0045_),
    .Q(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4657_ (.RESET_B(net209),
    .D(_0046_),
    .Q(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4658_ (.RESET_B(net181),
    .D(_0055_),
    .Q(\pll_dig.lock_detector.seen_n ),
    .CLK(net293));
 sg13g2_dfrbpq_1 _4659_ (.RESET_B(net183),
    .D(_0056_),
    .Q(\pll_dig.lock_detector.seen_p ),
    .CLK(net292));
 sg13g2_dfrbpq_1 _4660_ (.RESET_B(net183),
    .D(_0057_),
    .Q(\pll_dig.lock_detector.win_cnt[0] ),
    .CLK(net291));
 sg13g2_dfrbpq_1 _4661_ (.RESET_B(net183),
    .D(net602),
    .Q(\pll_dig.lock_detector.win_cnt[1] ),
    .CLK(net290));
 sg13g2_dfrbpq_1 _4662_ (.RESET_B(net183),
    .D(net598),
    .Q(\pll_dig.lock_detector.win_cnt[2] ),
    .CLK(net289));
 sg13g2_dfrbpq_1 _4663_ (.RESET_B(net183),
    .D(_0060_),
    .Q(\pll_dig.lock_detector.win_cnt[3] ),
    .CLK(net288));
 sg13g2_dfrbpq_1 _4664_ (.RESET_B(net183),
    .D(net244),
    .Q(\pll_dig.lock_detector.win_cnt[4] ),
    .CLK(net287));
 sg13g2_tielo _4664__245 (.L_LO(net244));
 sg13g2_dfrbpq_1 _4665_ (.RESET_B(net181),
    .D(_0052_),
    .Q(\pll_dig.lock_detector.bad_cnt[0] ),
    .CLK(net286));
 sg13g2_dfrbpq_1 _4666_ (.RESET_B(net181),
    .D(_0053_),
    .Q(\pll_dig.lock_detector.bad_cnt[1] ),
    .CLK(net285));
 sg13g2_dfrbpq_1 _4667_ (.RESET_B(net181),
    .D(net),
    .Q(\pll_dig.lock_detector.bad_cnt[2] ),
    .CLK(net284));
 sg13g2_tielo _4667__244 (.L_LO(net));
 sg13g2_dfrbpq_1 _4668_ (.RESET_B(net223),
    .D(\pll_dig.ref_wd.watch_s2 ),
    .Q(\pll_dig.ref_wd.watch_s3 ),
    .CLK(clknet_5_0__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4669_ (.RESET_B(net223),
    .D(\pll_dig.ref_wd.watch_s1 ),
    .Q(\pll_dig.ref_wd.watch_s2 ),
    .CLK(clknet_5_0__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4670_ (.RESET_B(net221),
    .D(clknet_1_1__leaf_REF),
    .Q(\pll_dig.ref_wd.watch_s1 ),
    .CLK(clknet_5_0__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4671_ (.RESET_B(net223),
    .D(\pll_dig.dlf.ILL_N_C ),
    .Q(\pll_dig.ILL_N ),
    .CLK(net283));
 sg13g2_dfrbpq_1 _4672_ (.RESET_B(net229),
    .D(\pll_dig.dlf.OUT_C[0] ),
    .Q(\pll_dig.FILTER_OUT[0] ),
    .CLK(net282));
 sg13g2_dfrbpq_1 _4673_ (.RESET_B(net229),
    .D(net685),
    .Q(\pll_dig.FILTER_OUT[1] ),
    .CLK(net281));
 sg13g2_dfrbpq_1 _4674_ (.RESET_B(net230),
    .D(net683),
    .Q(\pll_dig.FILTER_OUT[2] ),
    .CLK(net280));
 sg13g2_dfrbpq_1 _4675_ (.RESET_B(net230),
    .D(net677),
    .Q(\pll_dig.FILTER_OUT[3] ),
    .CLK(net279));
 sg13g2_dfrbpq_1 _4676_ (.RESET_B(net230),
    .D(net675),
    .Q(\pll_dig.FILTER_OUT[4] ),
    .CLK(net278));
 sg13g2_dfrbpq_1 _4677_ (.RESET_B(net230),
    .D(net672),
    .Q(\pll_dig.FILTER_OUT[5] ),
    .CLK(net277));
 sg13g2_dfrbpq_1 _4678_ (.RESET_B(net230),
    .D(net669),
    .Q(\pll_dig.FILTER_OUT[6] ),
    .CLK(net276));
 sg13g2_dfrbpq_1 _4679_ (.RESET_B(net231),
    .D(net679),
    .Q(\pll_dig.FILTER_OUT[7] ),
    .CLK(net275));
 sg13g2_dfrbpq_1 _4680_ (.RESET_B(net235),
    .D(\pll_dig.dlf.OUT_C[8] ),
    .Q(\pll_dig.FILTER_OUT[8] ),
    .CLK(net274));
 sg13g2_dfrbpq_1 _4681_ (.RESET_B(net218),
    .D(\pll_dig.dlf.OUT_C[9] ),
    .Q(\pll_dig.FILTER_OUT[9] ),
    .CLK(net273));
 sg13g2_dfrbpq_1 _4682_ (.RESET_B(net224),
    .D(net663),
    .Q(\pll_dig.FILTER_OUT[10] ),
    .CLK(net272));
 sg13g2_dfrbpq_1 _4683_ (.RESET_B(net224),
    .D(net681),
    .Q(\pll_dig.FILTER_OUT[11] ),
    .CLK(net271));
 sg13g2_dfrbpq_1 _4684_ (.RESET_B(net220),
    .D(net666),
    .Q(\pll_dig.FILTER_OUT[12] ),
    .CLK(net270));
 sg13g2_dfrbpq_1 _4685_ (.RESET_B(net220),
    .D(\pll_dig.dlf.OUT_C[13] ),
    .Q(\pll_dig.FILTER_OUT[13] ),
    .CLK(net269));
 sg13g2_dfrbpq_1 _4686_ (.RESET_B(net220),
    .D(net659),
    .Q(\pll_dig.FILTER_OUT[14] ),
    .CLK(net268));
 sg13g2_dfrbpq_1 _4687_ (.RESET_B(net219),
    .D(_0225_),
    .Q(_0161_),
    .CLK(net267));
 sg13g2_dfrbpq_1 _4688_ (.RESET_B(net220),
    .D(\pll_dig.dlf.ILL_P_C ),
    .Q(\pll_dig.ILL_P ),
    .CLK(net266));
 sg13g2_dfrbpq_1 _4689_ (.RESET_B(net181),
    .D(clknet_1_0__leaf_REF),
    .Q(\pll_dig.CKR ),
    .CLK(net350));
 sg13g2_dfrbpq_1 _4690_ (.RESET_B(net222),
    .D(\pll_dig.dco_miss_cnt[2] ),
    .Q(\pll_dig.dco_fail ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4691_ (.RESET_B(net221),
    .D(net586),
    .Q(\pll_dig.fail_qq ),
    .CLK(net265));
 sg13g2_dfrbpq_1 _4692_ (.RESET_B(net201),
    .D(\pll_dig.out_edges_next[0] ),
    .Q(\pll_dig.out_edges[0] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4693_ (.RESET_B(net202),
    .D(\pll_dig.out_edges_next[1] ),
    .Q(\pll_dig.out_edges[1] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4694_ (.RESET_B(net203),
    .D(\pll_dig.out_edges_next[2] ),
    .Q(\pll_dig.out_edges[2] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4695_ (.RESET_B(net201),
    .D(\pll_dig.out_edges_next[3] ),
    .Q(\pll_dig.out_edges[3] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4696_ (.RESET_B(net201),
    .D(\pll_dig.out_edges_next[4] ),
    .Q(\pll_dig.out_edges[4] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4697_ (.RESET_B(net196),
    .D(\pll_dig.out_edges_next[5] ),
    .Q(\pll_dig.out_edges[5] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4698_ (.RESET_B(net196),
    .D(\pll_dig.out_edges_next[6] ),
    .Q(\pll_dig.out_edges[6] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4699_ (.RESET_B(net200),
    .D(\pll_dig.out_edges_next[7] ),
    .Q(\pll_dig.out_edges[7] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4700_ (.RESET_B(net200),
    .D(\pll_dig.out_edges_next[8] ),
    .Q(\pll_dig.out_edges[8] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4701_ (.RESET_B(net198),
    .D(\pll_dig.out_edges_next[9] ),
    .Q(\pll_dig.out_edges[9] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4702_ (.RESET_B(net221),
    .D(_0051_),
    .Q(\pll_dig.fail_q ),
    .CLK(net264));
 sg13g2_dfrbpq_1 _4703_ (.RESET_B(net169),
    .D(\pll_dig.COARSE_MUX_D[0] ),
    .Q(\COARSE_MUX[0] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4704_ (.RESET_B(net167),
    .D(\pll_dig.COARSE_MUX_D[1] ),
    .Q(\COARSE_MUX[1] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4705_ (.RESET_B(net167),
    .D(\pll_dig.COARSE_MUX_D[2] ),
    .Q(\COARSE_MUX[2] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4706_ (.RESET_B(net167),
    .D(\pll_dig.COARSE_MUX_D[3] ),
    .Q(\COARSE_MUX[3] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4707_ (.RESET_B(net167),
    .D(\pll_dig.COARSE_MUX_D[4] ),
    .Q(\COARSE_MUX[4] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4708_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[5] ),
    .Q(\COARSE_MUX[5] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4709_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[6] ),
    .Q(\COARSE_MUX[6] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4710_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[7] ),
    .Q(\COARSE_MUX[7] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4711_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[8] ),
    .Q(\COARSE_MUX[8] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4712_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[9] ),
    .Q(\COARSE_MUX[9] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4713_ (.RESET_B(net164),
    .D(\pll_dig.COARSE_MUX_D[10] ),
    .Q(\COARSE_MUX[10] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4714_ (.RESET_B(net164),
    .D(\pll_dig.COARSE_MUX_D[11] ),
    .Q(\COARSE_MUX[11] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4715_ (.RESET_B(net164),
    .D(\pll_dig.COARSE_MUX_D[12] ),
    .Q(\COARSE_MUX[12] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4716_ (.RESET_B(net164),
    .D(\pll_dig.COARSE_MUX_D[13] ),
    .Q(\COARSE_MUX[13] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4717_ (.RESET_B(net165),
    .D(\pll_dig.COARSE_MUX_D[14] ),
    .Q(\COARSE_MUX[14] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4718_ (.RESET_B(net241),
    .D(\pll_dig.out_edges_g2[0] ),
    .Q(\pll_dig.out_edges_g2_q[0] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4719_ (.RESET_B(net239),
    .D(\pll_dig.out_edges_g2[1] ),
    .Q(\pll_dig.out_edges_g2_q[1] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4720_ (.RESET_B(net241),
    .D(\pll_dig.out_edges_g2[2] ),
    .Q(\pll_dig.out_edges_g2_q[2] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4721_ (.RESET_B(net239),
    .D(\pll_dig.out_edges_g2[3] ),
    .Q(\pll_dig.out_edges_g2_q[3] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4722_ (.RESET_B(net240),
    .D(\pll_dig.out_edges_g2[4] ),
    .Q(\pll_dig.out_edges_g2_q[4] ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4723_ (.RESET_B(net239),
    .D(\pll_dig.out_edges_g2[5] ),
    .Q(\pll_dig.out_edges_g2_q[5] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4724_ (.RESET_B(net241),
    .D(\pll_dig.out_edges_g2[6] ),
    .Q(\pll_dig.out_edges_g2_q[6] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4725_ (.RESET_B(net240),
    .D(\pll_dig.out_edges_g2[7] ),
    .Q(\pll_dig.out_edges_g2_q[7] ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4726_ (.RESET_B(net240),
    .D(\pll_dig.out_edges_g2[8] ),
    .Q(\pll_dig.out_edges_g2_q[8] ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4727_ (.RESET_B(net241),
    .D(\pll_dig.out_edges_g2[9] ),
    .Q(\pll_dig.out_edges_g2_q[9] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4728_ (.RESET_B(net241),
    .D(\pll_dig.out_edges_g1[0] ),
    .Q(\pll_dig.out_edges_g2[0] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4729_ (.RESET_B(net239),
    .D(\pll_dig.out_edges_g1[1] ),
    .Q(\pll_dig.out_edges_g2[1] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4730_ (.RESET_B(net241),
    .D(\pll_dig.out_edges_g1[2] ),
    .Q(\pll_dig.out_edges_g2[2] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4731_ (.RESET_B(net202),
    .D(\pll_dig.out_edges_g1[3] ),
    .Q(\pll_dig.out_edges_g2[3] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4732_ (.RESET_B(net198),
    .D(\pll_dig.out_edges_g1[4] ),
    .Q(\pll_dig.out_edges_g2[4] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4733_ (.RESET_B(net198),
    .D(\pll_dig.out_edges_g1[5] ),
    .Q(\pll_dig.out_edges_g2[5] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4734_ (.RESET_B(net242),
    .D(\pll_dig.out_edges_g1[6] ),
    .Q(\pll_dig.out_edges_g2[6] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4735_ (.RESET_B(net239),
    .D(\pll_dig.out_edges_g1[7] ),
    .Q(\pll_dig.out_edges_g2[7] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4736_ (.RESET_B(net239),
    .D(\pll_dig.out_edges_g1[8] ),
    .Q(\pll_dig.out_edges_g2[8] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4737_ (.RESET_B(net239),
    .D(\pll_dig.out_edges_g1[9] ),
    .Q(\pll_dig.out_edges_g2[9] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4738_ (.RESET_B(net203),
    .D(\pll_dig.out_edges_gray[0] ),
    .Q(\pll_dig.out_edges_g1[0] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4739_ (.RESET_B(net202),
    .D(\pll_dig.out_edges_gray[1] ),
    .Q(\pll_dig.out_edges_g1[1] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4740_ (.RESET_B(net202),
    .D(\pll_dig.out_edges_gray[2] ),
    .Q(\pll_dig.out_edges_g1[2] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4741_ (.RESET_B(net202),
    .D(\pll_dig.out_edges_gray[3] ),
    .Q(\pll_dig.out_edges_g1[3] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4742_ (.RESET_B(net198),
    .D(\pll_dig.out_edges_gray[4] ),
    .Q(\pll_dig.out_edges_g1[4] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4743_ (.RESET_B(net200),
    .D(\pll_dig.out_edges_gray[5] ),
    .Q(\pll_dig.out_edges_g1[5] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4744_ (.RESET_B(net202),
    .D(\pll_dig.out_edges_gray[6] ),
    .Q(\pll_dig.out_edges_g1[6] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4745_ (.RESET_B(net199),
    .D(\pll_dig.out_edges_gray[7] ),
    .Q(\pll_dig.out_edges_g1[7] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4746_ (.RESET_B(net198),
    .D(\pll_dig.out_edges_gray[8] ),
    .Q(\pll_dig.out_edges_g1[8] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4747_ (.RESET_B(net199),
    .D(\pll_dig.out_edges[9] ),
    .Q(\pll_dig.out_edges_g1[9] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4748_ (.RESET_B(net236),
    .D(_0009_),
    .Q(\pll_dig.div.rst_n ),
    .CLK(clknet_5_1__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4749_ (.RESET_B(net201),
    .D(net352),
    .Q(\pll_dig.out_div2 ),
    .CLK(clknet_5_10__leaf_net59_regs));
 sg13g2_dfrbpq_1 _4750_ (.RESET_B(net219),
    .D(\pll_dig.dsm_impl.locked_dsm_s1 ),
    .Q(\pll_dig.dsm_impl.locked_dsm_s2 ),
    .CLK(\clknet_1_1__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_dfrbpq_1 _4751_ (.RESET_B(net221),
    .D(\pll_dig.clr_r2 ),
    .Q(\pll_dig.clr_r3 ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4752_ (.RESET_B(net219),
    .D(net506),
    .Q(\pll_dig.dsm_impl.locked_dsm_s1 ),
    .CLK(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_dfrbpq_1 _4753_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[0] ),
    .Q(\MID_MUX[0] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4754_ (.RESET_B(net165),
    .D(\pll_dig.MID_MUX_D[1] ),
    .Q(\MID_MUX[1] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4755_ (.RESET_B(net165),
    .D(\pll_dig.MID_MUX_D[2] ),
    .Q(\MID_MUX[2] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4756_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[3] ),
    .Q(\MID_MUX[3] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4757_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[4] ),
    .Q(\MID_MUX[4] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4758_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[5] ),
    .Q(\MID_MUX[5] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4759_ (.RESET_B(net171),
    .D(\pll_dig.MID_MUX_D[6] ),
    .Q(\MID_MUX[6] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4760_ (.RESET_B(net171),
    .D(\pll_dig.MID_MUX_D[7] ),
    .Q(\MID_MUX[7] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4761_ (.RESET_B(net171),
    .D(\pll_dig.MID_MUX_D[8] ),
    .Q(\MID_MUX[8] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4762_ (.RESET_B(net171),
    .D(\pll_dig.MID_MUX_D[9] ),
    .Q(\MID_MUX[9] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4763_ (.RESET_B(net174),
    .D(\pll_dig.MID_MUX_D[10] ),
    .Q(\MID_MUX[10] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4764_ (.RESET_B(net171),
    .D(\pll_dig.MID_MUX_D[11] ),
    .Q(\MID_MUX[11] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4765_ (.RESET_B(net171),
    .D(\pll_dig.MID_MUX_D[12] ),
    .Q(\MID_MUX[12] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4766_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[13] ),
    .Q(\MID_MUX[13] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4767_ (.RESET_B(net169),
    .D(\pll_dig.MID_MUX_D[14] ),
    .Q(\MID_MUX[14] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4768_ (.RESET_B(net220),
    .D(_0265_),
    .Q(_0167_),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4769_ (.RESET_B(net184),
    .D(net733),
    .Q(_0166_),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4770_ (.RESET_B(net221),
    .D(\pll_dig.clr_r1 ),
    .Q(\pll_dig.clr_r2 ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4771_ (.RESET_B(net229),
    .D(net709),
    .Q(\pll_dig.dsm_impl.FCWF[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4772_ (.RESET_B(net234),
    .D(net705),
    .Q(\pll_dig.dsm_impl.FCWF[1] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4773_ (.RESET_B(net230),
    .D(net717),
    .Q(\pll_dig.dsm_impl.FCWF[2] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4774_ (.RESET_B(net230),
    .D(net719),
    .Q(\pll_dig.dsm_impl.FCWF[3] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4775_ (.RESET_B(net230),
    .D(net713),
    .Q(\pll_dig.dsm_impl.FCWF[4] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4776_ (.RESET_B(net231),
    .D(net715),
    .Q(\pll_dig.dsm_impl.FCWF[5] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4777_ (.RESET_B(net231),
    .D(net721),
    .Q(\pll_dig.dsm_impl.FCWF[6] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4778_ (.RESET_B(net231),
    .D(net711),
    .Q(\pll_dig.dsm_impl.FCWF[7] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4779_ (.RESET_B(net235),
    .D(net725),
    .Q(\pll_dig.dsm_impl.FCWF[8] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4780_ (.RESET_B(net235),
    .D(net723),
    .Q(\pll_dig.dsm_impl.FCWF[9] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4781_ (.RESET_B(net227),
    .D(net707),
    .Q(\pll_dig.dsm_impl.FCWF[10] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4782_ (.RESET_B(net224),
    .D(net703),
    .Q(\pll_dig.dsm_impl.FCWF[11] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4783_ (.RESET_B(net182),
    .D(\pll_dig.FILTER_DEC_RAW[0] ),
    .Q(\pll_dig.FILTER_DEC[0] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4784_ (.RESET_B(net182),
    .D(\pll_dig.FILTER_DEC_RAW[1] ),
    .Q(\pll_dig.FILTER_DEC[1] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4785_ (.RESET_B(net219),
    .D(\pll_dig.FILTER_DEC_RAW[2] ),
    .Q(\pll_dig.FILTER_DEC[2] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4786_ (.RESET_B(net219),
    .D(\pll_dig.FILTER_DEC_RAW[3] ),
    .Q(\pll_dig.FILTER_DEC[3] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4787_ (.RESET_B(net219),
    .D(\pll_dig.FILTER_DEC_RAW[4] ),
    .Q(\pll_dig.FILTER_DEC[4] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4788_ (.RESET_B(net185),
    .D(\pll_dig.clr_toggle ),
    .Q(\pll_dig.clr_r1 ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4789_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[0] ),
    .Q(\FINE_MUX[0] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4790_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[1] ),
    .Q(\FINE_MUX[1] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4791_ (.RESET_B(net178),
    .D(\pll_dig.FINE_MUX_D[2] ),
    .Q(\FINE_MUX[2] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4792_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[3] ),
    .Q(\FINE_MUX[3] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4793_ (.RESET_B(net216),
    .D(\pll_dig.FINE_MUX_D[4] ),
    .Q(\FINE_MUX[4] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4794_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[5] ),
    .Q(\FINE_MUX[5] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4795_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[6] ),
    .Q(\FINE_MUX[6] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4796_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[7] ),
    .Q(\FINE_MUX[7] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4797_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[8] ),
    .Q(\FINE_MUX[8] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4798_ (.RESET_B(net176),
    .D(\pll_dig.FINE_MUX_D[9] ),
    .Q(\FINE_MUX[9] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4799_ (.RESET_B(net176),
    .D(\pll_dig.FINE_MUX_D[10] ),
    .Q(\FINE_MUX[10] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4800_ (.RESET_B(net216),
    .D(\pll_dig.FINE_MUX_D[11] ),
    .Q(\FINE_MUX[11] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4801_ (.RESET_B(net216),
    .D(\pll_dig.FINE_MUX_D[12] ),
    .Q(\FINE_MUX[12] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4802_ (.RESET_B(net176),
    .D(\pll_dig.FINE_MUX_D[13] ),
    .Q(\FINE_MUX[13] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4803_ (.RESET_B(net176),
    .D(\pll_dig.FINE_MUX_D[14] ),
    .Q(\FINE_MUX[14] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4804_ (.RESET_B(net216),
    .D(\pll_dig.FILTER_DEC[4] ),
    .Q(\FINE_MUX[15] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4805_ (.RESET_B(net176),
    .D(\pll_dig.FINE_MUX_D[16] ),
    .Q(\FINE_MUX[16] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4806_ (.RESET_B(net176),
    .D(\pll_dig.FINE_MUX_D[17] ),
    .Q(\FINE_MUX[17] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4807_ (.RESET_B(net186),
    .D(\pll_dig.FINE_MUX_D[18] ),
    .Q(\FINE_MUX[18] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4808_ (.RESET_B(net217),
    .D(\pll_dig.FINE_MUX_D[19] ),
    .Q(\FINE_MUX[19] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4809_ (.RESET_B(net217),
    .D(\pll_dig.FINE_MUX_D[20] ),
    .Q(\FINE_MUX[20] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4810_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[21] ),
    .Q(\FINE_MUX[21] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4811_ (.RESET_B(net217),
    .D(\pll_dig.FINE_MUX_D[22] ),
    .Q(\FINE_MUX[22] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4812_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[23] ),
    .Q(\FINE_MUX[23] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4813_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[24] ),
    .Q(\FINE_MUX[24] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4814_ (.RESET_B(net177),
    .D(\pll_dig.FINE_MUX_D[25] ),
    .Q(\FINE_MUX[25] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4815_ (.RESET_B(net178),
    .D(\pll_dig.FINE_MUX_D[26] ),
    .Q(\FINE_MUX[26] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4816_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[27] ),
    .Q(\FINE_MUX[27] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4817_ (.RESET_B(net219),
    .D(\pll_dig.FINE_MUX_D[28] ),
    .Q(\FINE_MUX[28] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4818_ (.RESET_B(net178),
    .D(\pll_dig.FINE_MUX_D[29] ),
    .Q(\FINE_MUX[29] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4819_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[30] ),
    .Q(\FINE_MUX[30] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4820_ (.RESET_B(net203),
    .D(_0000_),
    .Q(\pll_dig.out_edges_gray[0] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4821_ (.RESET_B(net203),
    .D(_0001_),
    .Q(\pll_dig.out_edges_gray[1] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4822_ (.RESET_B(net202),
    .D(_0002_),
    .Q(\pll_dig.out_edges_gray[2] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4823_ (.RESET_B(net201),
    .D(_0003_),
    .Q(\pll_dig.out_edges_gray[3] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4824_ (.RESET_B(net200),
    .D(_0004_),
    .Q(\pll_dig.out_edges_gray[4] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4825_ (.RESET_B(net200),
    .D(_0005_),
    .Q(\pll_dig.out_edges_gray[5] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4826_ (.RESET_B(net199),
    .D(_0006_),
    .Q(\pll_dig.out_edges_gray[6] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4827_ (.RESET_B(net199),
    .D(_0007_),
    .Q(\pll_dig.out_edges_gray[7] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4828_ (.RESET_B(net198),
    .D(_0008_),
    .Q(\pll_dig.out_edges_gray[8] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_buf_16 clkbuf_0_INJ_EDGE (.X(clknet_0_INJ_EDGE),
    .A(INJ_EDGE));
 sg13g2_buf_16 clkbuf_0_MID_OUT (.X(clknet_0_MID_OUT),
    .A(MID_OUT));
 sg13g2_buf_16 clkbuf_0_REF (.X(clknet_0_REF),
    .A(delaynet_4_REF));
 sg13g2_buf_16 clkbuf_0_REF_regs (.X(clknet_0_REF_regs),
    .A(REF_regs));
 sg13g2_buf_16 clkbuf_0_net59 (.X(clknet_0_net59),
    .A(net59));
 sg13g2_buf_16 clkbuf_0_net59_regs (.X(clknet_0_net59_regs),
    .A(net59_regs));
 sg13g2_buf_16 clkbuf_0_net60 (.X(clknet_0_net60),
    .A(net60));
 sg13g2_buf_16 clkbuf_0_net60_regs (.X(clknet_0_net60_regs),
    .A(net60_regs));
 sg13g2_buf_16 \clkbuf_0_pll_dig.CKR  (.X(\clknet_0_pll_dig.CKR ),
    .A(\pll_dig.CKR ));
 sg13g2_buf_16 \clkbuf_0_pll_dig.dsm_impl.DSM_CK  (.X(\clknet_0_pll_dig.dsm_impl.DSM_CK ),
    .A(\pll_dig.dsm_impl.DSM_CK ));
 sg13g2_buf_16 \clkbuf_0_pll_dig.dsm_impl.DSM_CK_G  (.X(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .A(\pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_0_pll_dig.dsm_impl.DSM_CK_regs  (.X(\clknet_0_pll_dig.dsm_impl.DSM_CK_regs ),
    .A(\pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_buf_16 \clkbuf_0_pll_dig.flock.REF_G  (.X(\clknet_0_pll_dig.flock.REF_G ),
    .A(\pll_dig.flock.REF_G ));
 sg13g2_buf_16 \clkbuf_0_pll_dig.out_div2  (.X(\clknet_0_pll_dig.out_div2 ),
    .A(\pll_dig.out_div2 ));
 sg13g2_buf_16 clkbuf_1_0__f_REF (.X(clknet_1_0__leaf_REF),
    .A(clknet_0_REF));
 sg13g2_buf_16 clkbuf_1_0__f_net59 (.X(clknet_1_0__leaf_net59),
    .A(clknet_0_net59));
 sg13g2_buf_16 clkbuf_1_0__f_net60 (.X(clknet_1_0__leaf_net60),
    .A(clknet_0_net60));
 sg13g2_buf_16 clkbuf_1_0__f_net60_regs (.X(clknet_1_0__leaf_net60_regs),
    .A(clknet_0_net60_regs));
 sg13g2_buf_16 \clkbuf_1_0__f_pll_dig.dsm_impl.DSM_CK  (.X(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK ),
    .A(\clknet_0_pll_dig.dsm_impl.DSM_CK ));
 sg13g2_buf_16 \clkbuf_1_0__f_pll_dig.dsm_impl.DSM_CK_regs  (.X(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ),
    .A(\clknet_0_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_buf_16 clkbuf_1_1__f_REF (.X(clknet_1_1__leaf_REF),
    .A(clknet_0_REF));
 sg13g2_buf_16 clkbuf_1_1__f_net59 (.X(clknet_1_1__leaf_net59),
    .A(clknet_0_net59));
 sg13g2_buf_16 clkbuf_1_1__f_net60 (.X(clknet_1_1__leaf_net60),
    .A(clknet_0_net60));
 sg13g2_buf_16 \clkbuf_1_1__f_pll_dig.dsm_impl.DSM_CK_regs  (.X(\clknet_1_1__leaf_pll_dig.dsm_impl.DSM_CK_regs ),
    .A(\clknet_0_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_buf_16 \clkbuf_2_0__f_pll_dig.out_div2  (.X(\clknet_2_0__leaf_pll_dig.out_div2 ),
    .A(\clknet_0_pll_dig.out_div2 ));
 sg13g2_buf_16 \clkbuf_2_1__f_pll_dig.out_div2  (.X(\clknet_2_1__leaf_pll_dig.out_div2 ),
    .A(\clknet_0_pll_dig.out_div2 ));
 sg13g2_buf_16 \clkbuf_2_2__f_pll_dig.out_div2  (.X(\clknet_2_2__leaf_pll_dig.out_div2 ),
    .A(\clknet_0_pll_dig.out_div2 ));
 sg13g2_buf_16 \clkbuf_2_3__f_pll_dig.out_div2  (.X(\clknet_2_3__leaf_pll_dig.out_div2 ),
    .A(\clknet_0_pll_dig.out_div2 ));
 sg13g2_buf_16 clkbuf_3_0__f_MID_OUT (.X(clknet_3_0__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_0__f_pll_dig.CKR  (.X(\clknet_3_0__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_16 clkbuf_3_1__f_MID_OUT (.X(clknet_3_1__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_1__f_pll_dig.CKR  (.X(\clknet_3_1__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_16 clkbuf_3_2__f_MID_OUT (.X(clknet_3_2__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_2__f_pll_dig.CKR  (.X(\clknet_3_2__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_16 clkbuf_3_3__f_MID_OUT (.X(clknet_3_3__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_3__f_pll_dig.CKR  (.X(\clknet_3_3__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_16 clkbuf_3_4__f_MID_OUT (.X(clknet_3_4__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_4__f_pll_dig.CKR  (.X(\clknet_3_4__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_16 clkbuf_3_5__f_MID_OUT (.X(clknet_3_5__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_5__f_pll_dig.CKR  (.X(\clknet_3_5__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_16 clkbuf_3_6__f_MID_OUT (.X(clknet_3_6__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_6__f_pll_dig.CKR  (.X(\clknet_3_6__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_16 clkbuf_3_7__f_MID_OUT (.X(clknet_3_7__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_7__f_pll_dig.CKR  (.X(\clknet_3_7__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 clkbuf_4_0_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_0_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_0_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_0_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_0_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_0_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_0_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_0_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_0_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_10_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_10_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_10_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_10_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_10_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_10_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_10_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_10_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_10_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_11_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_11_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_11_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_11_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_11_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_11_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_11_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_11_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_11_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_12_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_12_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_12_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_12_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_12_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_12_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_12_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_12_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_12_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_13_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_13_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_13_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_13_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_13_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_13_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_13_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_13_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_13_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_14_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_14_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_14_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_14_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_14_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_14_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_14_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_14_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_14_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_15_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_15_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_15_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_15_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_15_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_15_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_15_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_15_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_15_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_1_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_1_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_1_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_1_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_1_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_1_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_1_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_1_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_1_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_2_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_2_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_2_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_2_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_2_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_2_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_2_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_2_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_2_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_3_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_3_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_3_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_3_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_3_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_3_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_3_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_3_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_3_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_4_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_4_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_4_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_4_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_4_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_4_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_4_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_4_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_4_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_5_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_5_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_5_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_5_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_5_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_5_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_5_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_5_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_5_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_6_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_6_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_6_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_6_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_6_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_6_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_6_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_6_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_6_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_7_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_7_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_7_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_7_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_7_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_7_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_7_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_7_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_7_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_8_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_8_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_8_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_8_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_8_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_8_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_8_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_8_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_8_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_9_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_9_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_9_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_9_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_9_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_9_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_9_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_8 \clkbuf_4_9_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_4_9_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_5_0__f_REF_regs (.X(clknet_5_0__leaf_REF_regs),
    .A(clknet_4_0_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_0__f_net59_regs (.X(clknet_5_0__leaf_net59_regs),
    .A(clknet_4_0_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_10__f_REF_regs (.X(clknet_5_10__leaf_REF_regs),
    .A(clknet_4_5_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_10__f_net59_regs (.X(clknet_5_10__leaf_net59_regs),
    .A(clknet_4_5_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_11__f_REF_regs (.X(clknet_5_11__leaf_REF_regs),
    .A(clknet_4_5_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_11__f_net59_regs (.X(clknet_5_11__leaf_net59_regs),
    .A(clknet_4_5_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_12__f_REF_regs (.X(clknet_5_12__leaf_REF_regs),
    .A(clknet_4_6_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_12__f_net59_regs (.X(clknet_5_12__leaf_net59_regs),
    .A(clknet_4_6_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_13__f_REF_regs (.X(clknet_5_13__leaf_REF_regs),
    .A(clknet_4_6_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_13__f_net59_regs (.X(clknet_5_13__leaf_net59_regs),
    .A(clknet_4_6_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_14__f_REF_regs (.X(clknet_5_14__leaf_REF_regs),
    .A(clknet_4_7_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_14__f_net59_regs (.X(clknet_5_14__leaf_net59_regs),
    .A(clknet_4_7_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_15__f_REF_regs (.X(clknet_5_15__leaf_REF_regs),
    .A(clknet_4_7_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_15__f_net59_regs (.X(clknet_5_15__leaf_net59_regs),
    .A(clknet_4_7_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_16__f_REF_regs (.X(clknet_5_16__leaf_REF_regs),
    .A(clknet_4_8_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_16__f_net59_regs (.X(clknet_5_16__leaf_net59_regs),
    .A(clknet_4_8_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_17__f_REF_regs (.X(clknet_5_17__leaf_REF_regs),
    .A(clknet_4_8_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_17__f_net59_regs (.X(clknet_5_17__leaf_net59_regs),
    .A(clknet_4_8_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_18__f_REF_regs (.X(clknet_5_18__leaf_REF_regs),
    .A(clknet_4_9_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_18__f_net59_regs (.X(clknet_5_18__leaf_net59_regs),
    .A(clknet_4_9_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_19__f_REF_regs (.X(clknet_5_19__leaf_REF_regs),
    .A(clknet_4_9_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_19__f_net59_regs (.X(clknet_5_19__leaf_net59_regs),
    .A(clknet_4_9_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_1__f_REF_regs (.X(clknet_5_1__leaf_REF_regs),
    .A(clknet_4_0_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_1__f_net59_regs (.X(clknet_5_1__leaf_net59_regs),
    .A(clknet_4_0_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_20__f_REF_regs (.X(clknet_5_20__leaf_REF_regs),
    .A(clknet_4_10_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_20__f_net59_regs (.X(clknet_5_20__leaf_net59_regs),
    .A(clknet_4_10_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_21__f_REF_regs (.X(clknet_5_21__leaf_REF_regs),
    .A(clknet_4_10_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_21__f_net59_regs (.X(clknet_5_21__leaf_net59_regs),
    .A(clknet_4_10_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_22__f_REF_regs (.X(clknet_5_22__leaf_REF_regs),
    .A(clknet_4_11_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_22__f_net59_regs (.X(clknet_5_22__leaf_net59_regs),
    .A(clknet_4_11_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_23__f_REF_regs (.X(clknet_5_23__leaf_REF_regs),
    .A(clknet_4_11_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_23__f_net59_regs (.X(clknet_5_23__leaf_net59_regs),
    .A(clknet_4_11_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_24__f_REF_regs (.X(clknet_5_24__leaf_REF_regs),
    .A(clknet_4_12_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_24__f_net59_regs (.X(clknet_5_24__leaf_net59_regs),
    .A(clknet_4_12_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_25__f_REF_regs (.X(clknet_5_25__leaf_REF_regs),
    .A(clknet_4_12_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_25__f_net59_regs (.X(clknet_5_25__leaf_net59_regs),
    .A(clknet_4_12_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_26__f_REF_regs (.X(clknet_5_26__leaf_REF_regs),
    .A(clknet_4_13_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_26__f_net59_regs (.X(clknet_5_26__leaf_net59_regs),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_27__f_REF_regs (.X(clknet_5_27__leaf_REF_regs),
    .A(clknet_4_13_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_27__f_net59_regs (.X(clknet_5_27__leaf_net59_regs),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_28__f_REF_regs (.X(clknet_5_28__leaf_REF_regs),
    .A(clknet_4_14_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_28__f_net59_regs (.X(clknet_5_28__leaf_net59_regs),
    .A(clknet_4_14_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_29__f_REF_regs (.X(clknet_5_29__leaf_REF_regs),
    .A(clknet_4_14_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_29__f_net59_regs (.X(clknet_5_29__leaf_net59_regs),
    .A(clknet_4_14_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_2__f_REF_regs (.X(clknet_5_2__leaf_REF_regs),
    .A(clknet_4_1_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_2__f_net59_regs (.X(clknet_5_2__leaf_net59_regs),
    .A(clknet_4_1_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_30__f_REF_regs (.X(clknet_5_30__leaf_REF_regs),
    .A(clknet_4_15_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_30__f_net59_regs (.X(clknet_5_30__leaf_net59_regs),
    .A(clknet_4_15_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_31__f_REF_regs (.X(clknet_5_31__leaf_REF_regs),
    .A(clknet_4_15_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_31__f_net59_regs (.X(clknet_5_31__leaf_net59_regs),
    .A(clknet_4_15_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_3__f_REF_regs (.X(clknet_5_3__leaf_REF_regs),
    .A(clknet_4_1_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_3__f_net59_regs (.X(clknet_5_3__leaf_net59_regs),
    .A(clknet_4_1_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_4__f_REF_regs (.X(clknet_5_4__leaf_REF_regs),
    .A(clknet_4_2_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_4__f_net59_regs (.X(clknet_5_4__leaf_net59_regs),
    .A(clknet_4_2_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_5__f_REF_regs (.X(clknet_5_5__leaf_REF_regs),
    .A(clknet_4_2_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_5__f_net59_regs (.X(clknet_5_5__leaf_net59_regs),
    .A(clknet_4_2_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_6__f_REF_regs (.X(clknet_5_6__leaf_REF_regs),
    .A(clknet_4_3_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_6__f_net59_regs (.X(clknet_5_6__leaf_net59_regs),
    .A(clknet_4_3_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_7__f_REF_regs (.X(clknet_5_7__leaf_REF_regs),
    .A(clknet_4_3_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_7__f_net59_regs (.X(clknet_5_7__leaf_net59_regs),
    .A(clknet_4_3_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_8__f_REF_regs (.X(clknet_5_8__leaf_REF_regs),
    .A(clknet_4_4_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_8__f_net59_regs (.X(clknet_5_8__leaf_net59_regs),
    .A(clknet_4_4_0_net59_regs));
 sg13g2_buf_16 clkbuf_5_9__f_REF_regs (.X(clknet_5_9__leaf_REF_regs),
    .A(clknet_4_4_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_9__f_net59_regs (.X(clknet_5_9__leaf_net59_regs),
    .A(clknet_4_4_0_net59_regs));
 sg13g2_buf_16 clkbuf_regs_0_REF (.X(REF_regs),
    .A(REF));
 sg13g2_buf_16 clkbuf_regs_1_OUT (.X(net59_regs),
    .A(net59));
 sg13g2_buf_16 clkbuf_regs_2_OUT (.X(net60_regs),
    .A(net60));
 sg13g2_buf_16 clkbuf_regs_3_DSM_CK_CLK (.X(\pll_dig.dsm_impl.DSM_CK_regs ),
    .A(\pll_dig.dsm_impl.DSM_CK ));
 sg13g2_buf_16 delaybuf_0_REF (.X(delaynet_0_REF),
    .A(REF));
 sg13g2_buf_16 delaybuf_1_REF (.X(delaynet_1_REF),
    .A(delaynet_0_REF));
 sg13g2_buf_16 delaybuf_2_REF (.X(delaynet_2_REF),
    .A(delaynet_1_REF));
 sg13g2_buf_16 delaybuf_3_REF (.X(delaynet_3_REF),
    .A(delaynet_2_REF));
 sg13g2_buf_16 delaybuf_4_REF (.X(delaynet_4_REF),
    .A(delaynet_3_REF));
 sg13g2_buf_1 fanout100 (.A(_0687_),
    .X(net100));
 sg13g2_buf_1 fanout101 (.A(_1863_),
    .X(net101));
 sg13g2_buf_1 fanout102 (.A(_1863_),
    .X(net102));
 sg13g2_buf_1 fanout103 (.A(_0492_),
    .X(net103));
 sg13g2_buf_1 fanout104 (.A(\pll_dig.FILTER_DEC[2] ),
    .X(net104));
 sg13g2_buf_1 fanout105 (.A(net106),
    .X(net105));
 sg13g2_buf_1 fanout106 (.A(net113),
    .X(net106));
 sg13g2_buf_1 fanout107 (.A(net109),
    .X(net107));
 sg13g2_buf_1 fanout108 (.A(net109),
    .X(net108));
 sg13g2_buf_1 fanout109 (.A(net112),
    .X(net109));
 sg13g2_buf_1 fanout110 (.A(net111),
    .X(net110));
 sg13g2_buf_1 fanout111 (.A(net112),
    .X(net111));
 sg13g2_buf_1 fanout112 (.A(net113),
    .X(net112));
 sg13g2_buf_1 fanout113 (.A(_0167_),
    .X(net113));
 sg13g2_buf_1 fanout114 (.A(_1098_),
    .X(net114));
 sg13g2_buf_1 fanout115 (.A(net118),
    .X(net115));
 sg13g2_buf_1 fanout116 (.A(net118),
    .X(net116));
 sg13g2_buf_1 fanout117 (.A(net118),
    .X(net117));
 sg13g2_buf_1 fanout118 (.A(_1605_),
    .X(net118));
 sg13g2_buf_1 fanout119 (.A(net657),
    .X(net119));
 sg13g2_buf_1 fanout120 (.A(net690),
    .X(net120));
 sg13g2_buf_1 fanout121 (.A(\pll_dig.dlf.INT[9] ),
    .X(net121));
 sg13g2_buf_1 fanout122 (.A(net688),
    .X(net122));
 sg13g2_buf_1 fanout123 (.A(_0926_),
    .X(net123));
 sg13g2_buf_1 fanout124 (.A(_0902_),
    .X(net124));
 sg13g2_buf_1 fanout125 (.A(_0902_),
    .X(net125));
 sg13g2_buf_1 fanout126 (.A(net127),
    .X(net126));
 sg13g2_buf_1 fanout127 (.A(_0901_),
    .X(net127));
 sg13g2_buf_1 fanout128 (.A(net129),
    .X(net128));
 sg13g2_buf_1 fanout129 (.A(net130),
    .X(net129));
 sg13g2_buf_1 fanout130 (.A(_0901_),
    .X(net130));
 sg13g2_buf_1 fanout131 (.A(_0688_),
    .X(net131));
 sg13g2_buf_1 fanout132 (.A(_0688_),
    .X(net132));
 sg13g2_buf_1 fanout133 (.A(_0495_),
    .X(net133));
 sg13g2_buf_2 fanout134 (.A(\pll_dig.div.rst_n ),
    .X(net134));
 sg13g2_buf_1 fanout135 (.A(\pll_dig.div.rst_n ),
    .X(net135));
 sg13g2_buf_1 fanout136 (.A(net138),
    .X(net136));
 sg13g2_buf_1 fanout137 (.A(net138),
    .X(net137));
 sg13g2_buf_4 fanout138 (.X(net138),
    .A(net141));
 sg13g2_buf_1 fanout139 (.A(net140),
    .X(net139));
 sg13g2_buf_4 fanout140 (.X(net140),
    .A(net141));
 sg13g2_buf_4 fanout141 (.X(net141),
    .A(\pll_dig.div.rst_n ));
 sg13g2_buf_1 fanout142 (.A(net144),
    .X(net142));
 sg13g2_buf_1 fanout143 (.A(net144),
    .X(net143));
 sg13g2_buf_1 fanout144 (.A(net149),
    .X(net144));
 sg13g2_buf_1 fanout145 (.A(net146),
    .X(net145));
 sg13g2_buf_1 fanout146 (.A(net149),
    .X(net146));
 sg13g2_buf_1 fanout147 (.A(net149),
    .X(net147));
 sg13g2_buf_1 fanout148 (.A(net149),
    .X(net148));
 sg13g2_buf_1 fanout149 (.A(\pll_dig.div.rst_n ),
    .X(net149));
 sg13g2_buf_1 fanout151 (.A(\pll_dig.div.div_for_counts_is_pend ),
    .X(net151));
 sg13g2_buf_1 fanout152 (.A(\pll_dig.div.div_for_counts_is_pend ),
    .X(net152));
 sg13g2_buf_1 fanout153 (.A(\pll_dig.div.div[6] ),
    .X(net153));
 sg13g2_buf_1 fanout154 (.A(\pll_dig.div.div[5] ),
    .X(net154));
 sg13g2_buf_2 fanout155 (.A(\pll_dig.div.div[5] ),
    .X(net155));
 sg13g2_buf_2 fanout156 (.A(\pll_dig.div.div[4] ),
    .X(net156));
 sg13g2_buf_2 fanout157 (.A(\pll_dig.div.div[4] ),
    .X(net157));
 sg13g2_buf_8 fanout158 (.A(\pll_dig.div.div[3] ),
    .X(net158));
 sg13g2_buf_2 fanout159 (.A(\pll_dig.div.div[2] ),
    .X(net159));
 sg13g2_buf_1 fanout160 (.A(\pll_dig.div.div[2] ),
    .X(net160));
 sg13g2_buf_1 fanout161 (.A(net163),
    .X(net161));
 sg13g2_buf_1 fanout162 (.A(net163),
    .X(net162));
 sg13g2_buf_1 fanout163 (.A(\pll_dig.flock.cap_valid ),
    .X(net163));
 sg13g2_buf_1 fanout164 (.A(net165),
    .X(net164));
 sg13g2_buf_1 fanout165 (.A(net166),
    .X(net165));
 sg13g2_buf_1 fanout166 (.A(net215),
    .X(net166));
 sg13g2_buf_1 fanout167 (.A(net168),
    .X(net167));
 sg13g2_buf_1 fanout168 (.A(net175),
    .X(net168));
 sg13g2_buf_1 fanout169 (.A(net175),
    .X(net169));
 sg13g2_buf_1 fanout170 (.A(net175),
    .X(net170));
 sg13g2_buf_1 fanout171 (.A(net174),
    .X(net171));
 sg13g2_buf_1 fanout172 (.A(net174),
    .X(net172));
 sg13g2_buf_1 fanout173 (.A(net174),
    .X(net173));
 sg13g2_buf_1 fanout174 (.A(net175),
    .X(net174));
 sg13g2_buf_1 fanout175 (.A(net215),
    .X(net175));
 sg13g2_buf_1 fanout176 (.A(net186),
    .X(net176));
 sg13g2_buf_1 fanout177 (.A(net178),
    .X(net177));
 sg13g2_buf_1 fanout178 (.A(net186),
    .X(net178));
 sg13g2_buf_1 fanout179 (.A(net185),
    .X(net179));
 sg13g2_buf_1 fanout180 (.A(net185),
    .X(net180));
 sg13g2_buf_1 fanout181 (.A(net185),
    .X(net181));
 sg13g2_buf_1 fanout182 (.A(net183),
    .X(net182));
 sg13g2_buf_1 fanout183 (.A(net185),
    .X(net183));
 sg13g2_buf_1 fanout184 (.A(net185),
    .X(net184));
 sg13g2_buf_1 fanout185 (.A(net186),
    .X(net185));
 sg13g2_buf_1 fanout186 (.A(net215),
    .X(net186));
 sg13g2_buf_1 fanout187 (.A(net188),
    .X(net187));
 sg13g2_buf_1 fanout188 (.A(net194),
    .X(net188));
 sg13g2_buf_1 fanout189 (.A(net194),
    .X(net189));
 sg13g2_buf_1 fanout190 (.A(net193),
    .X(net190));
 sg13g2_buf_1 fanout191 (.A(net193),
    .X(net191));
 sg13g2_buf_1 fanout192 (.A(net193),
    .X(net192));
 sg13g2_buf_1 fanout193 (.A(net194),
    .X(net193));
 sg13g2_buf_1 fanout194 (.A(net215),
    .X(net194));
 sg13g2_buf_1 fanout195 (.A(net197),
    .X(net195));
 sg13g2_buf_1 fanout196 (.A(net197),
    .X(net196));
 sg13g2_buf_1 fanout197 (.A(net214),
    .X(net197));
 sg13g2_buf_1 fanout198 (.A(net200),
    .X(net198));
 sg13g2_buf_1 fanout199 (.A(net200),
    .X(net199));
 sg13g2_buf_1 fanout200 (.A(net214),
    .X(net200));
 sg13g2_buf_1 fanout201 (.A(net203),
    .X(net201));
 sg13g2_buf_1 fanout202 (.A(net203),
    .X(net202));
 sg13g2_buf_1 fanout203 (.A(net214),
    .X(net203));
 sg13g2_buf_1 fanout204 (.A(net208),
    .X(net204));
 sg13g2_buf_1 fanout205 (.A(net208),
    .X(net205));
 sg13g2_buf_1 fanout206 (.A(net207),
    .X(net206));
 sg13g2_buf_1 fanout207 (.A(net208),
    .X(net207));
 sg13g2_buf_1 fanout208 (.A(net213),
    .X(net208));
 sg13g2_buf_1 fanout209 (.A(net210),
    .X(net209));
 sg13g2_buf_1 fanout210 (.A(net213),
    .X(net210));
 sg13g2_buf_1 fanout211 (.A(net213),
    .X(net211));
 sg13g2_buf_1 fanout212 (.A(net213),
    .X(net212));
 sg13g2_buf_1 fanout213 (.A(net214),
    .X(net213));
 sg13g2_buf_1 fanout214 (.A(net215),
    .X(net214));
 sg13g2_buf_1 fanout215 (.A(net47),
    .X(net215));
 sg13g2_buf_1 fanout216 (.A(net217),
    .X(net216));
 sg13g2_buf_1 fanout217 (.A(net228),
    .X(net217));
 sg13g2_buf_1 fanout218 (.A(net228),
    .X(net218));
 sg13g2_buf_1 fanout219 (.A(net223),
    .X(net219));
 sg13g2_buf_1 fanout220 (.A(net223),
    .X(net220));
 sg13g2_buf_1 fanout221 (.A(net222),
    .X(net221));
 sg13g2_buf_1 fanout222 (.A(net223),
    .X(net222));
 sg13g2_buf_1 fanout223 (.A(net228),
    .X(net223));
 sg13g2_buf_1 fanout224 (.A(net227),
    .X(net224));
 sg13g2_buf_1 fanout225 (.A(net227),
    .X(net225));
 sg13g2_buf_1 fanout226 (.A(net227),
    .X(net226));
 sg13g2_buf_1 fanout227 (.A(net228),
    .X(net227));
 sg13g2_buf_1 fanout228 (.A(net238),
    .X(net228));
 sg13g2_buf_1 fanout229 (.A(net234),
    .X(net229));
 sg13g2_buf_1 fanout230 (.A(net231),
    .X(net230));
 sg13g2_buf_1 fanout231 (.A(net234),
    .X(net231));
 sg13g2_buf_1 fanout232 (.A(net233),
    .X(net232));
 sg13g2_buf_1 fanout233 (.A(net234),
    .X(net233));
 sg13g2_buf_1 fanout234 (.A(net238),
    .X(net234));
 sg13g2_buf_1 fanout235 (.A(net236),
    .X(net235));
 sg13g2_buf_1 fanout236 (.A(net237),
    .X(net236));
 sg13g2_buf_1 fanout237 (.A(net238),
    .X(net237));
 sg13g2_buf_1 fanout238 (.A(net47),
    .X(net238));
 sg13g2_buf_1 fanout239 (.A(net241),
    .X(net239));
 sg13g2_buf_1 fanout240 (.A(net241),
    .X(net240));
 sg13g2_buf_1 fanout241 (.A(net242),
    .X(net241));
 sg13g2_buf_1 fanout242 (.A(net47),
    .X(net242));
 sg13g2_buf_1 fanout243 (.A(net46),
    .X(net243));
 sg13g2_buf_1 fanout61 (.A(_0749_),
    .X(net61));
 sg13g2_buf_1 fanout62 (.A(_0749_),
    .X(net62));
 sg13g2_buf_1 fanout63 (.A(_1954_),
    .X(net63));
 sg13g2_buf_1 fanout64 (.A(_1954_),
    .X(net64));
 sg13g2_buf_1 fanout65 (.A(_0779_),
    .X(net65));
 sg13g2_buf_1 fanout66 (.A(_0779_),
    .X(net66));
 sg13g2_buf_1 fanout67 (.A(_1917_),
    .X(net67));
 sg13g2_buf_1 fanout68 (.A(_1917_),
    .X(net68));
 sg13g2_buf_1 fanout69 (.A(_1260_),
    .X(net69));
 sg13g2_buf_1 fanout70 (.A(_0844_),
    .X(net70));
 sg13g2_buf_1 fanout71 (.A(_0844_),
    .X(net71));
 sg13g2_buf_1 fanout72 (.A(net76),
    .X(net72));
 sg13g2_buf_1 fanout73 (.A(net76),
    .X(net73));
 sg13g2_buf_1 fanout74 (.A(net76),
    .X(net74));
 sg13g2_buf_1 fanout75 (.A(net76),
    .X(net75));
 sg13g2_buf_1 fanout76 (.A(_1354_),
    .X(net76));
 sg13g2_buf_1 fanout77 (.A(_1252_),
    .X(net77));
 sg13g2_buf_1 fanout78 (.A(_1252_),
    .X(net78));
 sg13g2_buf_1 fanout79 (.A(net80),
    .X(net79));
 sg13g2_buf_1 fanout80 (.A(_1252_),
    .X(net80));
 sg13g2_buf_1 fanout81 (.A(net575),
    .X(net81));
 sg13g2_buf_8 fanout82 (.A(_0062_),
    .X(net82));
 sg13g2_buf_8 fanout83 (.A(_1637_),
    .X(net83));
 sg13g2_buf_1 fanout84 (.A(_1257_),
    .X(net84));
 sg13g2_buf_1 fanout85 (.A(_1257_),
    .X(net85));
 sg13g2_buf_1 fanout86 (.A(_1254_),
    .X(net86));
 sg13g2_buf_1 fanout87 (.A(_1254_),
    .X(net87));
 sg13g2_buf_1 fanout88 (.A(_1253_),
    .X(net88));
 sg13g2_buf_1 fanout89 (.A(_1253_),
    .X(net89));
 sg13g2_buf_1 fanout90 (.A(_1356_),
    .X(net90));
 sg13g2_buf_1 fanout91 (.A(_1356_),
    .X(net91));
 sg13g2_buf_1 fanout92 (.A(net93),
    .X(net92));
 sg13g2_buf_1 fanout93 (.A(_0841_),
    .X(net93));
 sg13g2_buf_1 fanout94 (.A(_1269_),
    .X(net94));
 sg13g2_buf_1 fanout95 (.A(_1269_),
    .X(net95));
 sg13g2_buf_1 fanout96 (.A(net97),
    .X(net96));
 sg13g2_buf_1 fanout97 (.A(_0520_),
    .X(net97));
 sg13g2_buf_1 fanout98 (.A(_0520_),
    .X(net98));
 sg13g2_buf_1 fanout99 (.A(net100),
    .X(net99));
 sg13g2_dlygate4sd3_1 hold484 (.A(net761),
    .X(net483));
 sg13g2_dlygate4sd3_1 hold485 (.A(net758),
    .X(net484));
 sg13g2_dlygate4sd3_1 hold486 (.A(net767),
    .X(net485));
 sg13g2_dlygate4sd3_1 hold487 (.A(net755),
    .X(net486));
 sg13g2_dlygate4sd3_1 hold488 (.A(net773),
    .X(net487));
 sg13g2_dlygate4sd3_1 hold489 (.A(net752),
    .X(net488));
 sg13g2_dlygate4sd3_1 hold490 (.A(net779),
    .X(net489));
 sg13g2_dlygate4sd3_1 hold491 (.A(net770),
    .X(net490));
 sg13g2_dlygate4sd3_1 hold492 (.A(net785),
    .X(net491));
 sg13g2_dlygate4sd3_1 hold493 (.A(net764),
    .X(net492));
 sg13g2_dlygate4sd3_1 hold494 (.A(net782),
    .X(net493));
 sg13g2_dlygate4sd3_1 hold495 (.A(net788),
    .X(net494));
 sg13g2_dlygate4sd3_1 hold496 (.A(net791),
    .X(net495));
 sg13g2_dlygate4sd3_1 hold497 (.A(net776),
    .X(net496));
 sg13g2_dlygate4sd3_1 hold498 (.A(net794),
    .X(net497));
 sg13g2_dlygate4sd3_1 hold499 (.A(net726),
    .X(net498));
 sg13g2_dlygate4sd3_1 hold500 (.A(net728),
    .X(net499));
 sg13g2_dlygate4sd3_1 hold501 (.A(net730),
    .X(net500));
 sg13g2_dlygate4sd3_1 hold502 (.A(net732),
    .X(net501));
 sg13g2_dlygate4sd3_1 hold503 (.A(\pll_dig.flock.cnt_cap[1] ),
    .X(net502));
 sg13g2_dlygate4sd3_1 hold504 (.A(_1208_),
    .X(net503));
 sg13g2_dlygate4sd3_1 hold505 (.A(_0178_),
    .X(net504));
 sg13g2_dlygate4sd3_1 hold506 (.A(_0586_),
    .X(net505));
 sg13g2_dlygate4sd3_1 hold507 (.A(net58),
    .X(net506));
 sg13g2_dlygate4sd3_1 hold508 (.A(net735),
    .X(net507));
 sg13g2_dlygate4sd3_1 hold509 (.A(_1583_),
    .X(net508));
 sg13g2_dlygate4sd3_1 hold510 (.A(_0170_),
    .X(net509));
 sg13g2_dlygate4sd3_1 hold511 (.A(net543),
    .X(net510));
 sg13g2_dlygate4sd3_1 hold512 (.A(_1578_),
    .X(net511));
 sg13g2_dlygate4sd3_1 hold513 (.A(_1586_),
    .X(net512));
 sg13g2_dlygate4sd3_1 hold514 (.A(_0177_),
    .X(net513));
 sg13g2_dlygate4sd3_1 hold515 (.A(net738),
    .X(net514));
 sg13g2_dlygate4sd3_1 hold516 (.A(_1174_),
    .X(net515));
 sg13g2_dlygate4sd3_1 hold517 (.A(_1223_),
    .X(net516));
 sg13g2_dlygate4sd3_1 hold518 (.A(_0184_),
    .X(net517));
 sg13g2_dlygate4sd3_1 hold519 (.A(net748),
    .X(net518));
 sg13g2_dlygate4sd3_1 hold520 (.A(_1179_),
    .X(net519));
 sg13g2_dlygate4sd3_1 hold521 (.A(_1220_),
    .X(net520));
 sg13g2_dlygate4sd3_1 hold522 (.A(_0183_),
    .X(net521));
 sg13g2_dlygate4sd3_1 hold523 (.A(net745),
    .X(net522));
 sg13g2_dlygate4sd3_1 hold524 (.A(_1569_),
    .X(net523));
 sg13g2_dlygate4sd3_1 hold525 (.A(_1573_),
    .X(net524));
 sg13g2_dlygate4sd3_1 hold526 (.A(_1577_),
    .X(net525));
 sg13g2_dlygate4sd3_1 hold527 (.A(_0176_),
    .X(net526));
 sg13g2_dlygate4sd3_1 hold528 (.A(\pll_dig.flock.cnt_cap[9] ),
    .X(net527));
 sg13g2_dlygate4sd3_1 hold529 (.A(_1170_),
    .X(net528));
 sg13g2_dlygate4sd3_1 hold530 (.A(_1226_),
    .X(net529));
 sg13g2_dlygate4sd3_1 hold531 (.A(_0185_),
    .X(net530));
 sg13g2_dlygate4sd3_1 hold532 (.A(net744),
    .X(net531));
 sg13g2_dlygate4sd3_1 hold533 (.A(_1165_),
    .X(net532));
 sg13g2_dlygate4sd3_1 hold534 (.A(_1229_),
    .X(net533));
 sg13g2_dlygate4sd3_1 hold535 (.A(_0171_),
    .X(net534));
 sg13g2_dlygate4sd3_1 hold536 (.A(\pll_dig.flock.cnt_cap[11] ),
    .X(net535));
 sg13g2_dlygate4sd3_1 hold537 (.A(_1162_),
    .X(net536));
 sg13g2_dlygate4sd3_1 hold538 (.A(_1232_),
    .X(net537));
 sg13g2_dlygate4sd3_1 hold539 (.A(_0172_),
    .X(net538));
 sg13g2_dlygate4sd3_1 hold540 (.A(net740),
    .X(net539));
 sg13g2_dlygate4sd3_1 hold541 (.A(_1160_),
    .X(net540));
 sg13g2_dlygate4sd3_1 hold542 (.A(_1235_),
    .X(net541));
 sg13g2_dlygate4sd3_1 hold543 (.A(_0173_),
    .X(net542));
 sg13g2_dlygate4sd3_1 hold544 (.A(\pll_dig.flock.cnt_cap[14] ),
    .X(net543));
 sg13g2_dlygate4sd3_1 hold545 (.A(net510),
    .X(net544));
 sg13g2_dlygate4sd3_1 hold546 (.A(_1574_),
    .X(net545));
 sg13g2_dlygate4sd3_1 hold547 (.A(_0175_),
    .X(net546));
 sg13g2_dlygate4sd3_1 hold548 (.A(net746),
    .X(net547));
 sg13g2_dlygate4sd3_1 hold549 (.A(_1184_),
    .X(net548));
 sg13g2_dlygate4sd3_1 hold550 (.A(_1217_),
    .X(net549));
 sg13g2_dlygate4sd3_1 hold551 (.A(_0182_),
    .X(net550));
 sg13g2_dlygate4sd3_1 hold552 (.A(net743),
    .X(net551));
 sg13g2_dlygate4sd3_1 hold553 (.A(_1200_),
    .X(net552));
 sg13g2_dlygate4sd3_1 hold554 (.A(_1202_),
    .X(net553));
 sg13g2_dlygate4sd3_1 hold555 (.A(_1689_),
    .X(net554));
 sg13g2_dlygate4sd3_1 hold556 (.A(_0179_),
    .X(net555));
 sg13g2_dlygate4sd3_1 hold557 (.A(net747),
    .X(net556));
 sg13g2_dlygate4sd3_1 hold558 (.A(_1169_),
    .X(net557));
 sg13g2_dlygate4sd3_1 hold559 (.A(_1228_),
    .X(net558));
 sg13g2_dlygate4sd3_1 hold560 (.A(_1231_),
    .X(net559));
 sg13g2_dlygate4sd3_1 hold561 (.A(_1236_),
    .X(net560));
 sg13g2_dlygate4sd3_1 hold562 (.A(_1237_),
    .X(net561));
 sg13g2_dlygate4sd3_1 hold563 (.A(_0174_),
    .X(net562));
 sg13g2_dlygate4sd3_1 hold564 (.A(net736),
    .X(net563));
 sg13g2_dlygate4sd3_1 hold565 (.A(_1195_),
    .X(net564));
 sg13g2_dlygate4sd3_1 hold566 (.A(_1197_),
    .X(net565));
 sg13g2_dlygate4sd3_1 hold567 (.A(_0180_),
    .X(net566));
 sg13g2_dlygate4sd3_1 hold568 (.A(net749),
    .X(net567));
 sg13g2_dlygate4sd3_1 hold569 (.A(_1194_),
    .X(net568));
 sg13g2_dlygate4sd3_1 hold570 (.A(_1196_),
    .X(net569));
 sg13g2_dlygate4sd3_1 hold571 (.A(_1213_),
    .X(net570));
 sg13g2_dlygate4sd3_1 hold572 (.A(_0181_),
    .X(net571));
 sg13g2_dlygate4sd3_1 hold573 (.A(\pll_dig.flock.FCW_NA[10] ),
    .X(net572));
 sg13g2_dlygate4sd3_1 hold574 (.A(_1112_),
    .X(net573));
 sg13g2_dlygate4sd3_1 hold575 (.A(_1133_),
    .X(net574));
 sg13g2_dlygate4sd3_1 hold576 (.A(net580),
    .X(net575));
 sg13g2_dlygate4sd3_1 hold577 (.A(_1323_),
    .X(net576));
 sg13g2_dlygate4sd3_1 hold578 (.A(_0022_),
    .X(net577));
 sg13g2_dlygate4sd3_1 hold579 (.A(\pll_dig.flock.FCW_PA[7] ),
    .X(net578));
 sg13g2_dlygate4sd3_1 hold580 (.A(_1131_),
    .X(net579));
 sg13g2_dlygate4sd3_1 hold581 (.A(_1134_),
    .X(net580));
 sg13g2_dlygate4sd3_1 hold582 (.A(net585),
    .X(net581));
 sg13g2_dlygate4sd3_1 hold583 (.A(_0820_),
    .X(net582));
 sg13g2_dlygate4sd3_1 hold584 (.A(_0829_),
    .X(net583));
 sg13g2_dlygate4sd3_1 hold585 (.A(_0029_),
    .X(net584));
 sg13g2_dlygate4sd3_1 hold586 (.A(\pll_dig.FREQ_OK ),
    .X(net585));
 sg13g2_dlygate4sd3_1 hold587 (.A(net750),
    .X(net586));
 sg13g2_dlygate4sd3_1 hold588 (.A(_0156_),
    .X(net587));
 sg13g2_dlygate4sd3_1 hold589 (.A(\pll_dig.state[1] ),
    .X(net588));
 sg13g2_dlygate4sd3_1 hold590 (.A(\pll_dig.fail_qq ),
    .X(net589));
 sg13g2_dlygate4sd3_1 hold591 (.A(_2035_),
    .X(net590));
 sg13g2_dlygate4sd3_1 hold592 (.A(\pll_dig.cntf[5] ),
    .X(net591));
 sg13g2_dlygate4sd3_1 hold593 (.A(_2068_),
    .X(net592));
 sg13g2_dlygate4sd3_1 hold594 (.A(_0464_),
    .X(net593));
 sg13g2_dlygate4sd3_1 hold595 (.A(\pll_dig.state[3] ),
    .X(net594));
 sg13g2_dlygate4sd3_1 hold596 (.A(_0470_),
    .X(net595));
 sg13g2_dlygate4sd3_1 hold597 (.A(\pll_dig.lock_detector.win_cnt[1] ),
    .X(net596));
 sg13g2_dlygate4sd3_1 hold598 (.A(_1614_),
    .X(net597));
 sg13g2_dlygate4sd3_1 hold599 (.A(_0059_),
    .X(net598));
 sg13g2_dlygate4sd3_1 hold600 (.A(\pll_dig.lock_detector.bad_cnt[0] ),
    .X(net599));
 sg13g2_dlygate4sd3_1 hold601 (.A(_1668_),
    .X(net600));
 sg13g2_dlygate4sd3_1 hold602 (.A(\pll_dig.lock_detector.win_cnt[0] ),
    .X(net601));
 sg13g2_dlygate4sd3_1 hold603 (.A(_0058_),
    .X(net602));
 sg13g2_dlygate4sd3_1 hold604 (.A(\pll_dig.cnt[1] ),
    .X(net603));
 sg13g2_dlygate4sd3_1 hold605 (.A(_2064_),
    .X(net604));
 sg13g2_dlygate4sd3_1 hold606 (.A(_0450_),
    .X(net605));
 sg13g2_dlygate4sd3_1 hold607 (.A(\pll_dig.lock_detector.win_cnt[4] ),
    .X(net606));
 sg13g2_dlygate4sd3_1 hold608 (.A(_1608_),
    .X(net607));
 sg13g2_dlygate4sd3_1 hold609 (.A(\pll_dig.cnt[6] ),
    .X(net608));
 sg13g2_dlygate4sd3_1 hold610 (.A(_1856_),
    .X(net609));
 sg13g2_dlygate4sd3_1 hold611 (.A(_0324_),
    .X(net610));
 sg13g2_dlygate4sd3_1 hold612 (.A(\pll_dig.ILL_P ),
    .X(net611));
 sg13g2_dlygate4sd3_1 hold613 (.A(_2080_),
    .X(net612));
 sg13g2_dlygate4sd3_1 hold614 (.A(_0472_),
    .X(net613));
 sg13g2_dlygate4sd3_1 hold615 (.A(\pll_dig.ILL_N ),
    .X(net614));
 sg13g2_dlygate4sd3_1 hold616 (.A(_2063_),
    .X(net615));
 sg13g2_dlygate4sd3_1 hold617 (.A(_0407_),
    .X(net616));
 sg13g2_dlygate4sd3_1 hold618 (.A(\pll_dig.lock_detector.bad_cnt[2] ),
    .X(net617));
 sg13g2_dlygate4sd3_1 hold619 (.A(_1656_),
    .X(net618));
 sg13g2_dlygate4sd3_1 hold620 (.A(\pll_dig.cntf[1] ),
    .X(net619));
 sg13g2_dlygate4sd3_1 hold621 (.A(_2070_),
    .X(net620));
 sg13g2_dlygate4sd3_1 hold622 (.A(_0466_),
    .X(net621));
 sg13g2_dlygate4sd3_1 hold623 (.A(\pll_dig.START ),
    .X(net622));
 sg13g2_dlygate4sd3_1 hold624 (.A(\pll_dig.ENABLE ),
    .X(net623));
 sg13g2_dlygate4sd3_1 hold625 (.A(_0378_),
    .X(net624));
 sg13g2_dlygate4sd3_1 hold626 (.A(\pll_dig.PHASE_LOCK ),
    .X(net625));
 sg13g2_dlygate4sd3_1 hold627 (.A(_2067_),
    .X(net626));
 sg13g2_dlygate4sd3_1 hold628 (.A(_0455_),
    .X(net627));
 sg13g2_dlygate4sd3_1 hold629 (.A(\pll_dig.cntf[0] ),
    .X(net628));
 sg13g2_dlygate4sd3_1 hold630 (.A(_0405_),
    .X(net629));
 sg13g2_dlygate4sd3_1 hold631 (.A(\pll_dig.state[2] ),
    .X(net630));
 sg13g2_dlygate4sd3_1 hold632 (.A(_1659_),
    .X(net631));
 sg13g2_dlygate4sd3_1 hold633 (.A(_0050_),
    .X(net632));
 sg13g2_dlygate4sd3_1 hold634 (.A(\pll_dig.cnt[3] ),
    .X(net633));
 sg13g2_dlygate4sd3_1 hold635 (.A(_1603_),
    .X(net634));
 sg13g2_dlygate4sd3_1 hold636 (.A(\pll_dig.lock_detector.win_cnt[2] ),
    .X(net635));
 sg13g2_dlygate4sd3_1 hold637 (.A(\pll_dig.state[4] ),
    .X(net636));
 sg13g2_dlygate4sd3_1 hold638 (.A(_1666_),
    .X(net637));
 sg13g2_dlygate4sd3_1 hold639 (.A(_0048_),
    .X(net638));
 sg13g2_dlygate4sd3_1 hold640 (.A(\pll_dig.cnt[5] ),
    .X(net639));
 sg13g2_dlygate4sd3_1 hold641 (.A(_1855_),
    .X(net640));
 sg13g2_dlygate4sd3_1 hold642 (.A(\pll_dig.cntf[6] ),
    .X(net641));
 sg13g2_dlygate4sd3_1 hold643 (.A(_2046_),
    .X(net642));
 sg13g2_dlygate4sd3_1 hold644 (.A(\pll_dig.cntf[3] ),
    .X(net643));
 sg13g2_dlygate4sd3_1 hold645 (.A(_2044_),
    .X(net644));
 sg13g2_dlygate4sd3_1 hold646 (.A(_0465_),
    .X(net645));
 sg13g2_dlygate4sd3_1 hold647 (.A(\pll_dig.cntf[2] ),
    .X(net646));
 sg13g2_dlygate4sd3_1 hold648 (.A(_0404_),
    .X(net647));
 sg13g2_dlygate4sd3_1 hold649 (.A(\pll_dig.cnt[4] ),
    .X(net648));
 sg13g2_dlygate4sd3_1 hold650 (.A(_1854_),
    .X(net649));
 sg13g2_dlygate4sd3_1 hold651 (.A(\pll_dig.cntf[4] ),
    .X(net650));
 sg13g2_dlygate4sd3_1 hold652 (.A(_2057_),
    .X(net651));
 sg13g2_dlygate4sd3_1 hold653 (.A(_0403_),
    .X(net652));
 sg13g2_dlygate4sd3_1 hold654 (.A(\pll_dig.lock_detector.win_cnt[3] ),
    .X(net653));
 sg13g2_dlygate4sd3_1 hold655 (.A(\pll_dig.cnt[2] ),
    .X(net654));
 sg13g2_dlygate4sd3_1 hold656 (.A(_1852_),
    .X(net655));
 sg13g2_dlygate4sd3_1 hold657 (.A(_0476_),
    .X(net656));
 sg13g2_dlygate4sd3_1 hold658 (.A(_0158_),
    .X(net657));
 sg13g2_dlygate4sd3_1 hold659 (.A(\pll_dig.dlf.INT[14] ),
    .X(net658));
 sg13g2_dlygate4sd3_1 hold660 (.A(\pll_dig.dlf.OUT_C[14] ),
    .X(net659));
 sg13g2_dlygate4sd3_1 hold661 (.A(\pll_dig.cnt[0] ),
    .X(net660));
 sg13g2_dlygate4sd3_1 hold662 (.A(\pll_dig.dlf.INT[10] ),
    .X(net661));
 sg13g2_dlygate4sd3_1 hold663 (.A(_1701_),
    .X(net662));
 sg13g2_dlygate4sd3_1 hold664 (.A(\pll_dig.dlf.OUT_C[10] ),
    .X(net663));
 sg13g2_dlygate4sd3_1 hold665 (.A(\pll_dig.LOCK_LOST ),
    .X(net664));
 sg13g2_dlygate4sd3_1 hold666 (.A(\pll_dig.dlf.INT[12] ),
    .X(net665));
 sg13g2_dlygate4sd3_1 hold667 (.A(\pll_dig.dlf.OUT_C[12] ),
    .X(net666));
 sg13g2_dlygate4sd3_1 hold668 (.A(\pll_dig.dlf.INT[6] ),
    .X(net667));
 sg13g2_dlygate4sd3_1 hold669 (.A(_1674_),
    .X(net668));
 sg13g2_dlygate4sd3_1 hold670 (.A(\pll_dig.dlf.OUT_C[6] ),
    .X(net669));
 sg13g2_dlygate4sd3_1 hold671 (.A(\pll_dig.dlf.INT[5] ),
    .X(net670));
 sg13g2_dlygate4sd3_1 hold672 (.A(_1473_),
    .X(net671));
 sg13g2_dlygate4sd3_1 hold673 (.A(\pll_dig.dlf.OUT_C[5] ),
    .X(net672));
 sg13g2_dlygate4sd3_1 hold674 (.A(\pll_dig.dlf.INT[4] ),
    .X(net673));
 sg13g2_dlygate4sd3_1 hold675 (.A(_1677_),
    .X(net674));
 sg13g2_dlygate4sd3_1 hold676 (.A(\pll_dig.dlf.OUT_C[4] ),
    .X(net675));
 sg13g2_dlygate4sd3_1 hold677 (.A(\pll_dig.dlf.INT[3] ),
    .X(net676));
 sg13g2_dlygate4sd3_1 hold678 (.A(\pll_dig.dlf.OUT_C[3] ),
    .X(net677));
 sg13g2_dlygate4sd3_1 hold679 (.A(\pll_dig.dlf.INT[7] ),
    .X(net678));
 sg13g2_dlygate4sd3_1 hold680 (.A(\pll_dig.dlf.OUT_C[7] ),
    .X(net679));
 sg13g2_dlygate4sd3_1 hold681 (.A(\pll_dig.dlf.INT[11] ),
    .X(net680));
 sg13g2_dlygate4sd3_1 hold682 (.A(\pll_dig.dlf.OUT_C[11] ),
    .X(net681));
 sg13g2_dlygate4sd3_1 hold683 (.A(\pll_dig.dlf.INT[2] ),
    .X(net682));
 sg13g2_dlygate4sd3_1 hold684 (.A(\pll_dig.dlf.OUT_C[2] ),
    .X(net683));
 sg13g2_dlygate4sd3_1 hold685 (.A(\pll_dig.dlf.INT[1] ),
    .X(net684));
 sg13g2_dlygate4sd3_1 hold686 (.A(\pll_dig.dlf.OUT_C[1] ),
    .X(net685));
 sg13g2_dlygate4sd3_1 hold687 (.A(\pll_dig.dlf.INT[0] ),
    .X(net686));
 sg13g2_dlygate4sd3_1 hold688 (.A(\pll_dig.dlf.INT[2] ),
    .X(net687));
 sg13g2_dlygate4sd3_1 hold689 (.A(\pll_dig.dlf.INT[8] ),
    .X(net688));
 sg13g2_dlygate4sd3_1 hold690 (.A(_1697_),
    .X(net689));
 sg13g2_dlygate4sd3_1 hold691 (.A(\pll_dig.dlf.INT[13] ),
    .X(net690));
 sg13g2_dlygate4sd3_1 hold692 (.A(\pll_dig.dlf.INT[14] ),
    .X(net691));
 sg13g2_dlygate4sd3_1 hold693 (.A(\pll_dig.dlf.INT[12] ),
    .X(net692));
 sg13g2_dlygate4sd3_1 hold694 (.A(\pll_dig.dlf.INT[11] ),
    .X(net693));
 sg13g2_dlygate4sd3_1 hold695 (.A(\pll_dig.dlf.INT[6] ),
    .X(net694));
 sg13g2_dlygate4sd3_1 hold696 (.A(\pll_dig.dlf.INT[7] ),
    .X(net695));
 sg13g2_dlygate4sd3_1 hold697 (.A(net751),
    .X(net696));
 sg13g2_dlygate4sd3_1 hold698 (.A(net753),
    .X(net697));
 sg13g2_dlygate4sd3_1 hold699 (.A(net754),
    .X(net698));
 sg13g2_dlygate4sd3_1 hold700 (.A(net756),
    .X(net699));
 sg13g2_dlygate4sd3_1 hold701 (.A(net757),
    .X(net700));
 sg13g2_dlygate4sd3_1 hold702 (.A(net759),
    .X(net701));
 sg13g2_dlygate4sd3_1 hold703 (.A(net760),
    .X(net702));
 sg13g2_dlygate4sd3_1 hold704 (.A(net762),
    .X(net703));
 sg13g2_dlygate4sd3_1 hold705 (.A(net766),
    .X(net704));
 sg13g2_dlygate4sd3_1 hold706 (.A(net768),
    .X(net705));
 sg13g2_dlygate4sd3_1 hold707 (.A(net763),
    .X(net706));
 sg13g2_dlygate4sd3_1 hold708 (.A(net765),
    .X(net707));
 sg13g2_dlygate4sd3_1 hold709 (.A(net769),
    .X(net708));
 sg13g2_dlygate4sd3_1 hold710 (.A(net771),
    .X(net709));
 sg13g2_dlygate4sd3_1 hold711 (.A(net772),
    .X(net710));
 sg13g2_dlygate4sd3_1 hold712 (.A(net774),
    .X(net711));
 sg13g2_dlygate4sd3_1 hold713 (.A(net781),
    .X(net712));
 sg13g2_dlygate4sd3_1 hold714 (.A(net783),
    .X(net713));
 sg13g2_dlygate4sd3_1 hold715 (.A(net787),
    .X(net714));
 sg13g2_dlygate4sd3_1 hold716 (.A(net789),
    .X(net715));
 sg13g2_dlygate4sd3_1 hold717 (.A(net778),
    .X(net716));
 sg13g2_dlygate4sd3_1 hold718 (.A(net780),
    .X(net717));
 sg13g2_dlygate4sd3_1 hold719 (.A(net784),
    .X(net718));
 sg13g2_dlygate4sd3_1 hold720 (.A(net786),
    .X(net719));
 sg13g2_dlygate4sd3_1 hold721 (.A(net790),
    .X(net720));
 sg13g2_dlygate4sd3_1 hold722 (.A(net792),
    .X(net721));
 sg13g2_dlygate4sd3_1 hold723 (.A(net775),
    .X(net722));
 sg13g2_dlygate4sd3_1 hold724 (.A(net777),
    .X(net723));
 sg13g2_dlygate4sd3_1 hold725 (.A(net793),
    .X(net724));
 sg13g2_dlygate4sd3_1 hold726 (.A(net795),
    .X(net725));
 sg13g2_dlygate4sd3_1 hold727 (.A(_0161_),
    .X(net726));
 sg13g2_dlygate4sd3_1 hold728 (.A(net498),
    .X(net727));
 sg13g2_dlygate4sd3_1 hold729 (.A(\pll_dig.FILTER_OUT[15] ),
    .X(net728));
 sg13g2_dlygate4sd3_1 hold730 (.A(net499),
    .X(net729));
 sg13g2_dlygate4sd3_1 hold731 (.A(DCO_EN),
    .X(net730));
 sg13g2_dlygate4sd3_1 hold732 (.A(net500),
    .X(net731));
 sg13g2_dlygate4sd3_1 hold733 (.A(_0262_),
    .X(net732));
 sg13g2_dlygate4sd3_1 hold734 (.A(net501),
    .X(net733));
 sg13g2_dlygate4sd3_1 hold735 (.A(\pll_dig.locked_q ),
    .X(net734));
 sg13g2_dlygate4sd3_1 hold736 (.A(\pll_dig.flock.cnt_cap[15] ),
    .X(net735));
 sg13g2_dlygate4sd3_1 hold737 (.A(\pll_dig.flock.cnt_cap[4] ),
    .X(net736));
 sg13g2_dlygate4sd3_1 hold738 (.A(_1215_),
    .X(net737));
 sg13g2_dlygate4sd3_1 hold739 (.A(\pll_dig.flock.cnt_cap[7] ),
    .X(net738));
 sg13g2_dlygate4sd3_1 hold740 (.A(_1222_),
    .X(net739));
 sg13g2_dlygate4sd3_1 hold741 (.A(\pll_dig.flock.cnt_cap[12] ),
    .X(net740));
 sg13g2_dlygate4sd3_1 hold742 (.A(_1242_),
    .X(net741));
 sg13g2_dlygate4sd3_1 hold743 (.A(_1243_),
    .X(net742));
 sg13g2_dlygate4sd3_1 hold744 (.A(\pll_dig.flock.cnt_cap[2] ),
    .X(net743));
 sg13g2_dlygate4sd3_1 hold745 (.A(\pll_dig.flock.cnt_cap[10] ),
    .X(net744));
 sg13g2_dlygate4sd3_1 hold746 (.A(\pll_dig.flock.cnt_cap[13] ),
    .X(net745));
 sg13g2_dlygate4sd3_1 hold747 (.A(\pll_dig.flock.cnt_cap[5] ),
    .X(net746));
 sg13g2_dlygate4sd3_1 hold748 (.A(\pll_dig.flock.cnt_cap[8] ),
    .X(net747));
 sg13g2_dlygate4sd3_1 hold749 (.A(\pll_dig.flock.cnt_cap[6] ),
    .X(net748));
 sg13g2_dlygate4sd3_1 hold750 (.A(\pll_dig.flock.cnt_cap[3] ),
    .X(net749));
 sg13g2_dlygate4sd3_1 hold751 (.A(\pll_dig.fail_q ),
    .X(net750));
 sg13g2_dlygate4sd3_1 hold752 (.A(\pll_dig.FILTER_OUT[12] ),
    .X(net751));
 sg13g2_dlygate4sd3_1 hold753 (.A(net696),
    .X(net752));
 sg13g2_dlygate4sd3_1 hold754 (.A(net488),
    .X(net753));
 sg13g2_dlygate4sd3_1 hold755 (.A(\pll_dig.FILTER_OUT[14] ),
    .X(net754));
 sg13g2_dlygate4sd3_1 hold756 (.A(net698),
    .X(net755));
 sg13g2_dlygate4sd3_1 hold757 (.A(net486),
    .X(net756));
 sg13g2_dlygate4sd3_1 hold758 (.A(\pll_dig.FILTER_OUT[13] ),
    .X(net757));
 sg13g2_dlygate4sd3_1 hold759 (.A(net700),
    .X(net758));
 sg13g2_dlygate4sd3_1 hold760 (.A(net484),
    .X(net759));
 sg13g2_dlygate4sd3_1 hold761 (.A(\pll_dig.FILTER_OUT[11] ),
    .X(net760));
 sg13g2_dlygate4sd3_1 hold762 (.A(net702),
    .X(net761));
 sg13g2_dlygate4sd3_1 hold763 (.A(net483),
    .X(net762));
 sg13g2_dlygate4sd3_1 hold764 (.A(\pll_dig.FILTER_OUT[10] ),
    .X(net763));
 sg13g2_dlygate4sd3_1 hold765 (.A(net706),
    .X(net764));
 sg13g2_dlygate4sd3_1 hold766 (.A(net492),
    .X(net765));
 sg13g2_dlygate4sd3_1 hold767 (.A(\pll_dig.FILTER_OUT[1] ),
    .X(net766));
 sg13g2_dlygate4sd3_1 hold768 (.A(net704),
    .X(net767));
 sg13g2_dlygate4sd3_1 hold769 (.A(net485),
    .X(net768));
 sg13g2_dlygate4sd3_1 hold770 (.A(\pll_dig.FILTER_OUT[0] ),
    .X(net769));
 sg13g2_dlygate4sd3_1 hold771 (.A(net708),
    .X(net770));
 sg13g2_dlygate4sd3_1 hold772 (.A(net490),
    .X(net771));
 sg13g2_dlygate4sd3_1 hold773 (.A(\pll_dig.FILTER_OUT[7] ),
    .X(net772));
 sg13g2_dlygate4sd3_1 hold774 (.A(net710),
    .X(net773));
 sg13g2_dlygate4sd3_1 hold775 (.A(net487),
    .X(net774));
 sg13g2_dlygate4sd3_1 hold776 (.A(\pll_dig.FILTER_OUT[9] ),
    .X(net775));
 sg13g2_dlygate4sd3_1 hold777 (.A(net722),
    .X(net776));
 sg13g2_dlygate4sd3_1 hold778 (.A(net496),
    .X(net777));
 sg13g2_dlygate4sd3_1 hold779 (.A(\pll_dig.FILTER_OUT[2] ),
    .X(net778));
 sg13g2_dlygate4sd3_1 hold780 (.A(net716),
    .X(net779));
 sg13g2_dlygate4sd3_1 hold781 (.A(net489),
    .X(net780));
 sg13g2_dlygate4sd3_1 hold782 (.A(\pll_dig.FILTER_OUT[4] ),
    .X(net781));
 sg13g2_dlygate4sd3_1 hold783 (.A(net712),
    .X(net782));
 sg13g2_dlygate4sd3_1 hold784 (.A(net493),
    .X(net783));
 sg13g2_dlygate4sd3_1 hold785 (.A(\pll_dig.FILTER_OUT[3] ),
    .X(net784));
 sg13g2_dlygate4sd3_1 hold786 (.A(net718),
    .X(net785));
 sg13g2_dlygate4sd3_1 hold787 (.A(net491),
    .X(net786));
 sg13g2_dlygate4sd3_1 hold788 (.A(\pll_dig.FILTER_OUT[5] ),
    .X(net787));
 sg13g2_dlygate4sd3_1 hold789 (.A(net714),
    .X(net788));
 sg13g2_dlygate4sd3_1 hold790 (.A(net494),
    .X(net789));
 sg13g2_dlygate4sd3_1 hold791 (.A(\pll_dig.FILTER_OUT[6] ),
    .X(net790));
 sg13g2_dlygate4sd3_1 hold792 (.A(net720),
    .X(net791));
 sg13g2_dlygate4sd3_1 hold793 (.A(net495),
    .X(net792));
 sg13g2_dlygate4sd3_1 hold794 (.A(\pll_dig.FILTER_OUT[8] ),
    .X(net793));
 sg13g2_dlygate4sd3_1 hold795 (.A(net724),
    .X(net794));
 sg13g2_dlygate4sd3_1 hold796 (.A(net497),
    .X(net795));
 sg13g2_buf_1 input1 (.A(DSM_EN_DT),
    .X(net1));
 sg13g2_buf_1 input10 (.A(FCW[5]),
    .X(net10));
 sg13g2_buf_1 input11 (.A(FCW[6]),
    .X(net11));
 sg13g2_buf_1 input12 (.A(FCW[7]),
    .X(net12));
 sg13g2_buf_1 input13 (.A(INJ_EN),
    .X(net13));
 sg13g2_buf_1 input14 (.A(KI[0]),
    .X(net14));
 sg13g2_buf_1 input15 (.A(KI[10]),
    .X(net15));
 sg13g2_buf_1 input16 (.A(KI[11]),
    .X(net16));
 sg13g2_buf_1 input17 (.A(KI[12]),
    .X(net17));
 sg13g2_buf_1 input18 (.A(KI[13]),
    .X(net18));
 sg13g2_buf_1 input19 (.A(KI[14]),
    .X(net19));
 sg13g2_buf_1 input2 (.A(DSM_EN_SHDT),
    .X(net2));
 sg13g2_buf_1 input20 (.A(KI[15]),
    .X(net20));
 sg13g2_buf_1 input21 (.A(KI[1]),
    .X(net21));
 sg13g2_buf_1 input22 (.A(KI[2]),
    .X(net22));
 sg13g2_buf_1 input23 (.A(KI[3]),
    .X(net23));
 sg13g2_buf_1 input24 (.A(KI[4]),
    .X(net24));
 sg13g2_buf_1 input25 (.A(KI[5]),
    .X(net25));
 sg13g2_buf_1 input26 (.A(KI[6]),
    .X(net26));
 sg13g2_buf_1 input27 (.A(KI[7]),
    .X(net27));
 sg13g2_buf_1 input28 (.A(KI[8]),
    .X(net28));
 sg13g2_buf_1 input29 (.A(KI[9]),
    .X(net29));
 sg13g2_buf_1 input3 (.A(DSM_ORDER[0]),
    .X(net3));
 sg13g2_buf_1 input30 (.A(KP[0]),
    .X(net30));
 sg13g2_buf_1 input31 (.A(KP[10]),
    .X(net31));
 sg13g2_buf_1 input32 (.A(KP[11]),
    .X(net32));
 sg13g2_buf_1 input33 (.A(KP[12]),
    .X(net33));
 sg13g2_buf_1 input34 (.A(KP[13]),
    .X(net34));
 sg13g2_buf_1 input35 (.A(KP[14]),
    .X(net35));
 sg13g2_buf_1 input36 (.A(KP[15]),
    .X(net36));
 sg13g2_buf_1 input37 (.A(KP[1]),
    .X(net37));
 sg13g2_buf_1 input38 (.A(KP[2]),
    .X(net38));
 sg13g2_buf_1 input39 (.A(KP[3]),
    .X(net39));
 sg13g2_buf_1 input4 (.A(DSM_ORDER[1]),
    .X(net4));
 sg13g2_buf_1 input40 (.A(KP[4]),
    .X(net40));
 sg13g2_buf_1 input41 (.A(KP[5]),
    .X(net41));
 sg13g2_buf_1 input42 (.A(KP[6]),
    .X(net42));
 sg13g2_buf_1 input43 (.A(KP[7]),
    .X(net43));
 sg13g2_buf_1 input44 (.A(KP[8]),
    .X(net44));
 sg13g2_buf_1 input45 (.A(KP[9]),
    .X(net45));
 sg13g2_buf_1 input46 (.A(LOAD_DIV),
    .X(net46));
 sg13g2_buf_1 input47 (.A(RST_N),
    .X(net47));
 sg13g2_buf_1 input48 (.A(SET_DIV[0]),
    .X(net48));
 sg13g2_buf_1 input49 (.A(SET_DIV[1]),
    .X(net49));
 sg13g2_buf_1 input5 (.A(FCW[0]),
    .X(net5));
 sg13g2_buf_1 input50 (.A(SET_DIV[2]),
    .X(net50));
 sg13g2_buf_1 input51 (.A(SET_DIV[3]),
    .X(net51));
 sg13g2_buf_1 input52 (.A(SET_DIV[4]),
    .X(net52));
 sg13g2_buf_1 input53 (.A(SET_DIV[5]),
    .X(net53));
 sg13g2_buf_1 input54 (.A(SET_DIV[6]),
    .X(net54));
 sg13g2_buf_1 input55 (.A(SET_DIV[7]),
    .X(net55));
 sg13g2_buf_1 input6 (.A(FCW[1]),
    .X(net6));
 sg13g2_buf_1 input7 (.A(FCW[2]),
    .X(net7));
 sg13g2_buf_1 input8 (.A(FCW[3]),
    .X(net8));
 sg13g2_buf_1 input9 (.A(FCW[4]),
    .X(net9));
 sg13g2_buf_1 output56 (.A(net56),
    .X(CK));
 sg13g2_buf_1 output57 (.A(net57),
    .X(ERR));
 sg13g2_buf_1 output58 (.A(net58),
    .X(LOCKED));
 sg13g2_buf_1 output59 (.A(clknet_1_0__leaf_net59),
    .X(OUT));
 sg13g2_buf_1 output60 (.A(clknet_1_0__leaf_net60),
    .X(OUT_DIV));
 PLL_ANALOG_MACRO pll_ana (.DCO_EN(DCO_EN),
    .INJ_EDGE(INJ_EDGE),
    .INJ_EN(net13),
    .MID_OUT(MID_OUT),
    .OUT(net59),
    .REF(clknet_1_0__leaf_REF),
    .COARSE_MUX({\COARSE_MUX[14] ,
    \COARSE_MUX[13] ,
    \COARSE_MUX[12] ,
    \COARSE_MUX[11] ,
    \COARSE_MUX[10] ,
    \COARSE_MUX[9] ,
    \COARSE_MUX[8] ,
    \COARSE_MUX[7] ,
    \COARSE_MUX[6] ,
    \COARSE_MUX[5] ,
    \COARSE_MUX[4] ,
    \COARSE_MUX[3] ,
    \COARSE_MUX[2] ,
    \COARSE_MUX[1] ,
    \COARSE_MUX[0] }),
    .FINE_MUX({\FINE_MUX[30] ,
    \FINE_MUX[29] ,
    \FINE_MUX[28] ,
    \FINE_MUX[27] ,
    \FINE_MUX[26] ,
    \FINE_MUX[25] ,
    \FINE_MUX[24] ,
    \FINE_MUX[23] ,
    \FINE_MUX[22] ,
    \FINE_MUX[21] ,
    \FINE_MUX[20] ,
    \FINE_MUX[19] ,
    \FINE_MUX[18] ,
    \FINE_MUX[17] ,
    \FINE_MUX[16] ,
    \FINE_MUX[15] ,
    \FINE_MUX[14] ,
    \FINE_MUX[13] ,
    \FINE_MUX[12] ,
    \FINE_MUX[11] ,
    \FINE_MUX[10] ,
    \FINE_MUX[9] ,
    \FINE_MUX[8] ,
    \FINE_MUX[7] ,
    \FINE_MUX[6] ,
    \FINE_MUX[5] ,
    \FINE_MUX[4] ,
    \FINE_MUX[3] ,
    \FINE_MUX[2] ,
    \FINE_MUX[1] ,
    \FINE_MUX[0] }),
    .MID_MUX({\MID_MUX[14] ,
    \MID_MUX[13] ,
    \MID_MUX[12] ,
    \MID_MUX[11] ,
    \MID_MUX[10] ,
    \MID_MUX[9] ,
    \MID_MUX[8] ,
    \MID_MUX[7] ,
    \MID_MUX[6] ,
    \MID_MUX[5] ,
    \MID_MUX[4] ,
    \MID_MUX[3] ,
    \MID_MUX[2] ,
    \MID_MUX[1] ,
    \MID_MUX[0] }),
    .SS_BBPD({\SS_BBPD[1] ,
    \SS_BBPD[0] }));
 sg13g2_lgcp_1 \pll_dig.dsm_impl.u_dsm_icg.u_icg  (.GATE(\pll_dig.dsm_impl.u_dsm_icg.EN ),
    .CLK(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK ),
    .GCLK(\pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_lgcp_1 \pll_dig.flock.u_fll_icg.u_icg  (.GATE(\pll_dig.flock.u_fll_icg.EN ),
    .CLK(clknet_1_1__leaf_REF),
    .GCLK(\pll_dig.flock.REF_G ));
 sg13g2_buf_1 rebuffer355 (.A(_1014_),
    .X(net354));
 sg13g2_buf_1 rebuffer356 (.A(_1007_),
    .X(net355));
 sg13g2_buf_1 rebuffer357 (.A(_1020_),
    .X(net356));
 sg13g2_buf_1 rebuffer358 (.A(_1008_),
    .X(net357));
 sg13g2_buf_1 rebuffer359 (.A(_1018_),
    .X(net358));
 sg13g2_buf_1 rebuffer360 (.A(_1063_),
    .X(net359));
 sg13g2_buf_1 rebuffer361 (.A(_1053_),
    .X(net360));
 sg13g2_buf_1 rebuffer362 (.A(_1048_),
    .X(net361));
 sg13g2_buf_1 rebuffer363 (.A(_1028_),
    .X(net362));
 sg13g2_buf_1 rebuffer364 (.A(_1024_),
    .X(net363));
 sg13g2_buf_1 rebuffer365 (.A(_1059_),
    .X(net364));
 sg13g2_buf_1 rebuffer366 (.A(net378),
    .X(net365));
 sg13g2_buf_1 rebuffer367 (.A(_1089_),
    .X(net366));
 sg13g2_buf_1 rebuffer368 (.A(_1051_),
    .X(net367));
 sg13g2_buf_1 rebuffer369 (.A(_1044_),
    .X(net368));
 sg13g2_buf_1 rebuffer370 (.A(_1055_),
    .X(net369));
 sg13g2_buf_1 rebuffer371 (.A(_1049_),
    .X(net370));
 sg13g2_buf_1 rebuffer372 (.A(_1001_),
    .X(net371));
 sg13g2_buf_1 rebuffer373 (.A(_1050_),
    .X(net372));
 sg13g2_buf_1 rebuffer374 (.A(_0682_),
    .X(net373));
 sg13g2_buf_1 rebuffer375 (.A(_1062_),
    .X(net374));
 sg13g2_buf_1 rebuffer376 (.A(_1062_),
    .X(net375));
 sg13g2_buf_1 rebuffer377 (.A(_1043_),
    .X(net376));
 sg13g2_buf_1 rebuffer378 (.A(_0674_),
    .X(net377));
 sg13g2_buf_1 rebuffer379 (.A(_1083_),
    .X(net378));
 sg13g2_buf_1 rebuffer380 (.A(_1070_),
    .X(net379));
 sg13g2_buf_1 rebuffer381 (.A(_1057_),
    .X(net380));
 sg13g2_buf_1 rebuffer382 (.A(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .X(net381));
 sg13g2_buf_1 rebuffer383 (.A(\pll_dig.dsm_impl.dsm.dff_err2[0] ),
    .X(net382));
 sg13g2_buf_1 rebuffer384 (.A(_0872_),
    .X(net383));
 sg13g2_buf_8 rebuffer385 (.A(_0062_),
    .X(net384));
 sg13g2_buf_1 rebuffer386 (.A(_0872_),
    .X(net385));
 sg13g2_buf_1 rebuffer387 (.A(_0873_),
    .X(net386));
 sg13g2_buf_1 rebuffer388 (.A(_0893_),
    .X(net387));
 sg13g2_buf_1 rebuffer390 (.A(_0895_),
    .X(net389));
 sg13g2_buf_1 rebuffer391 (.A(_0874_),
    .X(net390));
 sg13g2_buf_1 rebuffer392 (.A(_0874_),
    .X(net391));
 sg13g2_buf_1 rebuffer393 (.A(_0884_),
    .X(net392));
 sg13g2_buf_1 rebuffer394 (.A(_0884_),
    .X(net393));
 sg13g2_buf_1 rebuffer395 (.A(_0886_),
    .X(net394));
 sg13g2_buf_8 rebuffer396 (.A(_0900_),
    .X(net395));
 sg13g2_buf_1 rebuffer397 (.A(net436),
    .X(net396));
 sg13g2_buf_1 rebuffer398 (.A(net434),
    .X(net397));
 sg13g2_buf_1 rebuffer399 (.A(net434),
    .X(net398));
 sg13g2_buf_1 rebuffer400 (.A(_0899_),
    .X(net399));
 sg13g2_buf_1 rebuffer401 (.A(\pll_dig.div.cnt[1] ),
    .X(net400));
 sg13g2_buf_1 rebuffer402 (.A(\pll_dig.div.cnt[0] ),
    .X(net401));
 sg13g2_buf_1 rebuffer403 (.A(\pll_dig.div.cnt[0] ),
    .X(net402));
 sg13g2_buf_1 rebuffer404 (.A(_0654_),
    .X(net403));
 sg13g2_buf_1 rebuffer405 (.A(\pll_dig.div.div[0] ),
    .X(net404));
 sg13g2_buf_1 rebuffer406 (.A(net411),
    .X(net405));
 sg13g2_buf_1 rebuffer407 (.A(_0168_),
    .X(net406));
 sg13g2_buf_1 rebuffer408 (.A(_0168_),
    .X(net407));
 sg13g2_buf_1 rebuffer409 (.A(_0655_),
    .X(net408));
 sg13g2_buf_1 rebuffer410 (.A(_0655_),
    .X(net409));
 sg13g2_buf_8 rebuffer411 (.A(_0634_),
    .X(net410));
 sg13g2_buf_2 rebuffer412 (.A(\pll_dig.div.div[0] ),
    .X(net411));
 sg13g2_buf_1 rebuffer414 (.A(\pll_dig.div.div[3] ),
    .X(net413));
 sg13g2_buf_2 rebuffer415 (.A(_1327_),
    .X(net414));
 sg13g2_buf_1 rebuffer416 (.A(_1491_),
    .X(net415));
 sg13g2_buf_1 rebuffer417 (.A(_0905_),
    .X(net416));
 sg13g2_buf_1 rebuffer418 (.A(_1545_),
    .X(net417));
 sg13g2_buf_1 rebuffer419 (.A(_1545_),
    .X(net418));
 sg13g2_buf_1 rebuffer420 (.A(net422),
    .X(net419));
 sg13g2_buf_1 rebuffer421 (.A(_0903_),
    .X(net420));
 sg13g2_buf_8 rebuffer422 (.A(_1339_),
    .X(net421));
 sg13g2_buf_1 rebuffer423 (.A(_0906_),
    .X(net422));
 sg13g2_buf_1 rebuffer424 (.A(_0904_),
    .X(net423));
 sg13g2_buf_1 rebuffer425 (.A(net414),
    .X(net424));
 sg13g2_buf_1 rebuffer426 (.A(_1545_),
    .X(net425));
 sg13g2_buf_1 rebuffer427 (.A(\pll_dig.flock.cnt[2] ),
    .X(net426));
 sg13g2_buf_1 rebuffer428 (.A(\pll_dig.flock.cnt[1] ),
    .X(net427));
 sg13g2_buf_1 rebuffer429 (.A(\pll_dig.flock.cnt[3] ),
    .X(net428));
 sg13g2_buf_8 rebuffer435 (.A(_0888_),
    .X(net434));
 sg13g2_buf_1 rebuffer436 (.A(_0878_),
    .X(net435));
 sg13g2_buf_2 rebuffer437 (.A(_0876_),
    .X(net436));
 sg13g2_buf_2 rebuffer438 (.A(\pll_dig.div.ncnt[0] ),
    .X(net437));
 sg13g2_buf_1 rebuffer439 (.A(\pll_dig.div.ncnt[1] ),
    .X(net438));
 sg13g2_buf_1 rebuffer440 (.A(_1637_),
    .X(net439));
 sg13g2_buf_16 rebuffer442 (.X(net441),
    .A(net83));
 sg13g2_buf_1 rebuffer470 (.A(_1821_),
    .X(net469));
 sg13g2_buf_2 rebuffer471 (.A(_1823_),
    .X(net470));
 sg13g2_buf_1 rebuffer472 (.A(_1830_),
    .X(net471));
 sg13g2_buf_1 rebuffer473 (.A(net478),
    .X(net472));
 sg13g2_buf_1 rebuffer474 (.A(net478),
    .X(net473));
 sg13g2_buf_1 rebuffer475 (.A(\pll_dig.div.pcnt[1] ),
    .X(net474));
 sg13g2_buf_1 rebuffer476 (.A(net479),
    .X(net475));
 sg13g2_buf_1 rebuffer477 (.A(\pll_dig.div.pcnt[2] ),
    .X(net476));
 sg13g2_buf_8 rebuffer478 (.A(_1847_),
    .X(net477));
 sg13g2_buf_1 rebuffer479 (.A(\pll_dig.div.pcnt[0] ),
    .X(net478));
 sg13g2_buf_1 rebuffer480 (.A(\pll_dig.div.pcnt[1] ),
    .X(net479));
endmodule
