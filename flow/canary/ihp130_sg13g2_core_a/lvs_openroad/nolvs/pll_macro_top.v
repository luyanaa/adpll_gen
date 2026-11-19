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
 wire net272;
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
 wire _0054_;
 wire net239;
 wire _0056_;
 wire _0057_;
 wire _0058_;
 wire _0059_;
 wire _0060_;
 wire _0061_;
 wire net240;
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
 wire net269;
 wire _0179_;
 wire net268;
 wire _0181_;
 wire _0182_;
 wire _0183_;
 wire _0184_;
 wire _0185_;
 wire _0186_;
 wire _0187_;
 wire _0188_;
 wire _0189_;
 wire _0190_;
 wire _0191_;
 wire _0192_;
 wire _0193_;
 wire _0194_;
 wire _0195_;
 wire _0196_;
 wire net267;
 wire _0198_;
 wire _0199_;
 wire net266;
 wire _0201_;
 wire net265;
 wire net260;
 wire _0204_;
 wire _0205_;
 wire _0206_;
 wire _0207_;
 wire _0208_;
 wire _0209_;
 wire _0210_;
 wire _0211_;
 wire _0212_;
 wire _0213_;
 wire _0214_;
 wire _0215_;
 wire _0216_;
 wire _0217_;
 wire _0218_;
 wire _0219_;
 wire _0220_;
 wire _0221_;
 wire _0222_;
 wire _0223_;
 wire _0224_;
 wire _0225_;
 wire net264;
 wire net263;
 wire net262;
 wire REF_regs;
 wire _0230_;
 wire _0231_;
 wire _0232_;
 wire _0233_;
 wire _0234_;
 wire _0235_;
 wire _0236_;
 wire _0237_;
 wire net261;
 wire _0239_;
 wire _0240_;
 wire _0241_;
 wire _0242_;
 wire _0243_;
 wire _0244_;
 wire _0245_;
 wire net270;
 wire _0247_;
 wire _0248_;
 wire _0249_;
 wire _0250_;
 wire _0251_;
 wire _0252_;
 wire _0253_;
 wire _0254_;
 wire _0255_;
 wire _0256_;
 wire _0257_;
 wire _0258_;
 wire _0259_;
 wire _0260_;
 wire _0261_;
 wire _0262_;
 wire _0263_;
 wire _0264_;
 wire _0265_;
 wire _0266_;
 wire _0267_;
 wire _0268_;
 wire _0269_;
 wire _0270_;
 wire _0271_;
 wire _0272_;
 wire _0273_;
 wire _0274_;
 wire _0275_;
 wire _0276_;
 wire _0277_;
 wire _0278_;
 wire _0279_;
 wire _0280_;
 wire _0281_;
 wire _0282_;
 wire _0283_;
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
 wire _0299_;
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
 wire net271;
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
 wire net241;
 wire net242;
 wire net243;
 wire net244;
 wire net245;
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
 wire \pll_dig.div.div_pend[0] ;
 wire \pll_dig.div.div_pend[2] ;
 wire \pll_dig.div.div_pend[3] ;
 wire \pll_dig.div.div_pend[4] ;
 wire \pll_dig.div.div_pend[5] ;
 wire \pll_dig.div.div_pend[6] ;
 wire \pll_dig.div.div_pend[7] ;
 wire \pll_dig.div.enter_req ;
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
 wire net429;
 wire net146;
 wire net147;
 wire net148;
 wire net149;
 wire net150;
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
 wire \clknet_3_0_0_pll_dig.flock.REF_G ;
 wire \clknet_3_1_0_pll_dig.flock.REF_G ;
 wire \clknet_3_2_0_pll_dig.flock.REF_G ;
 wire \clknet_3_3_0_pll_dig.flock.REF_G ;
 wire \clknet_3_4_0_pll_dig.flock.REF_G ;
 wire \clknet_3_5_0_pll_dig.flock.REF_G ;
 wire \clknet_3_6_0_pll_dig.flock.REF_G ;
 wire \clknet_3_7_0_pll_dig.flock.REF_G ;
 wire \clknet_4_0__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_1__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_2__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_3__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_4__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_5__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_6__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_7__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_8__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_9__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_10__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_11__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_12__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_13__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_14__leaf_pll_dig.flock.REF_G ;
 wire \clknet_4_15__leaf_pll_dig.flock.REF_G ;
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
 wire net273;
 wire net274;
 wire net275;
 wire net276;
 wire net277;
 wire net278;
 wire net279;
 wire net280;
 wire net281;
 wire net282;
 wire net283;
 wire net284;
 wire net285;
 wire net286;
 wire net287;
 wire net288;
 wire net289;
 wire net290;
 wire net291;
 wire net292;
 wire net293;
 wire net294;
 wire net295;
 wire net296;
 wire net297;
 wire net298;
 wire net299;
 wire net300;
 wire net301;
 wire net302;
 wire net303;
 wire net304;
 wire net305;
 wire net306;
 wire net307;
 wire net308;
 wire net309;
 wire net310;
 wire net311;
 wire net312;
 wire net313;
 wire net314;
 wire net315;
 wire net316;
 wire net317;
 wire net318;
 wire net319;
 wire net320;
 wire net321;
 wire net322;
 wire net323;
 wire net324;
 wire net325;
 wire net326;
 wire net327;
 wire net328;
 wire net329;
 wire net330;
 wire net331;
 wire net332;
 wire net333;
 wire net334;
 wire net335;
 wire net336;
 wire net337;
 wire net338;
 wire net339;
 wire net340;
 wire net341;
 wire net342;
 wire net343;
 wire net344;
 wire net350;
 wire net351;
 wire net352;
 wire net353;
 wire net356;
 wire net357;
 wire net358;
 wire net359;
 wire net361;
 wire net362;
 wire net369;
 wire net371;
 wire net379;
 wire net458;
 wire net459;
 wire net460;
 wire net461;
 wire net384;
 wire net385;
 wire net386;
 wire net387;
 wire net388;
 wire net389;
 wire net390;
 wire net395;
 wire net404;
 wire net405;
 wire net406;
 wire net411;
 wire net412;
 wire net413;
 wire net414;
 wire net415;
 wire net416;
 wire net417;
 wire net418;
 wire net430;
 wire net431;
 wire net432;
 wire net433;
 wire net434;
 wire net450;
 wire net462;
 wire net463;
 wire net464;
 wire net465;
 wire net466;
 wire net467;
 wire net468;
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
 wire net480;
 wire net481;
 wire net482;
 wire net483;
 wire net484;
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

 sg13g2_inv_1 _2081_ (.Y(_2058_),
    .A(net352));
 sg13g2_inv_1 _2082_ (.Y(_2059_),
    .A(\pll_dig.div.ncnt[3] ));
 sg13g2_inv_1 _2083_ (.Y(_0443_),
    .A(\pll_dig.dlf.INT[0] ));
 sg13g2_inv_1 _2084_ (.Y(_0529_),
    .A(\pll_dig.dlf.INT[8] ));
 sg13g2_nor2_2 _2085_ (.A(net411),
    .B(_0583_),
    .Y(_0037_));
 sg13g2_nand2_1 _2086_ (.Y(_1303_),
    .A(\pll_dig.flock.cnt_done[4] ),
    .B(_1081_));
 sg13g2_nand2_1 _2087_ (.Y(_1304_),
    .A(net95),
    .B(_1110_));
 sg13g2_nand3_1 _2088_ (.B(net95),
    .C(_1110_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .Y(_1305_));
 sg13g2_nor2b_1 _2089_ (.A(net95),
    .B_N(_1114_),
    .Y(_1306_));
 sg13g2_or2_1 _2090_ (.X(_1307_),
    .B(_1115_),
    .A(net529));
 sg13g2_o21ai_1 _2091_ (.B1(_1305_),
    .Y(_1308_),
    .A1(\pll_dig.flock.cnt_done[3] ),
    .A2(_1307_));
 sg13g2_a21o_1 _2092_ (.A2(_1188_),
    .A1(_0460_),
    .B1(_1079_),
    .X(_1309_));
 sg13g2_xnor2_1 _2093_ (.Y(_1310_),
    .A(\pll_dig.flock.cnt_done[4] ),
    .B(_1308_));
 sg13g2_o21ai_1 _2094_ (.B1(_1303_),
    .Y(_0025_),
    .A1(_1309_),
    .A2(_1310_));
 sg13g2_inv_1 _2095_ (.Y(_0530_),
    .A(net146));
 sg13g2_nand2_1 _2096_ (.Y(_1311_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .B(_1081_));
 sg13g2_nand2_1 _2097_ (.Y(_1312_),
    .A(_1304_),
    .B(_1307_));
 sg13g2_xnor2_1 _2098_ (.Y(_1313_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .B(_1312_));
 sg13g2_o21ai_1 _2099_ (.B1(_1311_),
    .Y(_0024_),
    .A1(_1309_),
    .A2(_1313_));
 sg13g2_nand2_1 _2100_ (.Y(_1314_),
    .A(\pll_dig.flock.cnt_done[1] ),
    .B(_1081_));
 sg13g2_nor2_1 _2101_ (.A(_1109_),
    .B(_1114_),
    .Y(_1315_));
 sg13g2_xor2_1 _2102_ (.B(_1315_),
    .A(net529),
    .X(_1316_));
 sg13g2_o21ai_1 _2103_ (.B1(_1314_),
    .Y(_0022_),
    .A1(_1309_),
    .A2(net530));
 sg13g2_nor2_1 _2104_ (.A(net96),
    .B(_1271_),
    .Y(\pll_dig.FINE_MUX_D[24] ));
 sg13g2_nand2_1 _2105_ (.Y(\pll_dig.flock.u_fll_icg.EN ),
    .A(\pll_dig.FREQ_OK ),
    .B(\pll_dig.FREQ_LOCKED ));
 sg13g2_inv_1 _2106_ (.Y(_0531_),
    .A(\pll_dig.flock.cnt_err[3] ));
 sg13g2_or3_1 _2107_ (.A(_0991_),
    .B(_1029_),
    .C(_1031_),
    .X(_1317_));
 sg13g2_nand2_1 _2108_ (.Y(_1318_),
    .A(_1032_),
    .B(_1317_));
 sg13g2_or3_1 _2109_ (.A(_1030_),
    .B(_1048_),
    .C(_1064_),
    .X(_1319_));
 sg13g2_nand3_1 _2110_ (.B(net64),
    .C(_1319_),
    .A(_1065_),
    .Y(_1320_));
 sg13g2_a21oi_1 _2111_ (.A1(\pll_dig.dlf.INT[11] ),
    .A2(net132),
    .Y(_1321_),
    .B1(net109));
 sg13g2_a22oi_1 _2112_ (.Y(\pll_dig.dlf.OUT_C[11] ),
    .B1(_1320_),
    .B2(_1321_),
    .A2(_1318_),
    .A1(net61));
 sg13g2_nor2_1 _2113_ (.A(\pll_dig.COARSE_MUX_D[8] ),
    .B(net72),
    .Y(_1322_));
 sg13g2_a22oi_1 _2114_ (.Y(_1323_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[7] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[9] ));
 sg13g2_a21oi_1 _2115_ (.A1(net72),
    .A2(_1323_),
    .Y(_0378_),
    .B1(_1322_));
 sg13g2_o21ai_1 _2116_ (.B1(net96),
    .Y(\pll_dig.FINE_MUX_D[21] ),
    .A1(net98),
    .A2(_1077_));
 sg13g2_inv_1 _2117_ (.Y(_0532_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[5] ));
 sg13g2_nor2_1 _2118_ (.A(\pll_dig.COARSE_MUX_D[3] ),
    .B(net73),
    .Y(_1324_));
 sg13g2_a22oi_1 _2119_ (.Y(_1325_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[2] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[4] ));
 sg13g2_a21oi_1 _2120_ (.A1(net73),
    .A2(_1325_),
    .Y(_0377_),
    .B1(_1324_));
 sg13g2_nor2_1 _2121_ (.A(_0520_),
    .B(_0052_),
    .Y(net58));
 sg13g2_xnor2_1 _2122_ (.Y(_0101_),
    .A(_0462_),
    .B(_0613_));
 sg13g2_nand2_1 _2123_ (.Y(_1326_),
    .A(net112),
    .B(_0662_));
 sg13g2_o21ai_1 _2124_ (.B1(_1326_),
    .Y(_0376_),
    .A1(net112),
    .A2(_0524_));
 sg13g2_nor2_1 _2125_ (.A(net113),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .Y(_1327_));
 sg13g2_a21oi_1 _2126_ (.A1(net113),
    .A2(_0631_),
    .Y(_0375_),
    .B1(_1327_));
 sg13g2_o21ai_1 _2127_ (.B1(net96),
    .Y(\pll_dig.FINE_MUX_D[22] ),
    .A1(_1235_),
    .A2(_1236_));
 sg13g2_inv_1 _2128_ (.Y(_0533_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[7] ));
 sg13g2_a21oi_2 _2129_ (.B1(_1180_),
    .Y(\pll_dig.FILTER_DEC_RAW[4] ),
    .A2(_1164_),
    .A1(_1178_));
 sg13g2_nand2b_1 _2130_ (.Y(\pll_dig.FINE_MUX_D[3] ),
    .B(net100),
    .A_N(net103));
 sg13g2_nand2_1 _2131_ (.Y(\pll_dig.FINE_MUX_D[0] ),
    .A(net100),
    .B(_1271_));
 sg13g2_nand2_1 _2132_ (.Y(\pll_dig.FINE_MUX_D[6] ),
    .A(net99),
    .B(_1240_));
 sg13g2_a221oi_1 _2133_ (.B2(\pll_dig.MID_MUX_D[2] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[4] ),
    .Y(_1328_),
    .A2(net92));
 sg13g2_nand2_1 _2134_ (.Y(_1329_),
    .A(\pll_dig.MID_MUX_D[3] ),
    .B(net78));
 sg13g2_o21ai_1 _2135_ (.B1(_1329_),
    .Y(_0374_),
    .A1(net78),
    .A2(_1328_));
 sg13g2_xnor2_1 _2136_ (.Y(_1330_),
    .A(\pll_dig.flock.cnt_coarse_wait[4] ),
    .B(_0801_));
 sg13g2_o21ai_1 _2137_ (.B1(net68),
    .Y(_0017_),
    .A1(_1301_),
    .A2(_1330_));
 sg13g2_nand3_1 _2138_ (.B(\pll_dig.flock.cnt_err[1] ),
    .C(\pll_dig.flock.cnt_err[0] ),
    .A(\pll_dig.flock.cnt_err[2] ),
    .Y(_1331_));
 sg13g2_inv_1 _2139__260 (.Y(net259),
    .A(clknet_3_0__leaf_MID_OUT));
 sg13g2_nor2_1 _2140_ (.A(_0531_),
    .B(_1331_),
    .Y(_1332_));
 sg13g2_and2_1 _2141_ (.A(\pll_dig.flock.cnt_err[4] ),
    .B(_1332_),
    .X(_1333_));
 sg13g2_nand3_1 _2142_ (.B(\pll_dig.flock.cnt_err[6] ),
    .C(_1333_),
    .A(\pll_dig.flock.cnt_err[5] ),
    .Y(_1334_));
 sg13g2_xor2_1 _2143_ (.B(_1334_),
    .A(\pll_dig.flock.cnt_err[7] ),
    .X(_1335_));
 sg13g2_nand2_1 _2144_ (.Y(_1336_),
    .A(_0819_),
    .B(_1301_));
 sg13g2_nand3_1 _2145_ (.B(net104),
    .C(_1336_),
    .A(\pll_dig.flock.cnt_err[7] ),
    .Y(_1337_));
 sg13g2_o21ai_1 _2146_ (.B1(_1337_),
    .Y(_0036_),
    .A1(net69),
    .A2(_1335_));
 sg13g2_nor3_1 _2147_ (.A(net125),
    .B(net389),
    .C(_0965_),
    .Y(_1338_));
 sg13g2_a21o_1 _2148_ (.A2(net125),
    .A1(net418),
    .B1(_1338_),
    .X(_0373_));
 sg13g2_o21ai_1 _2149_ (.B1(_0483_),
    .Y(_1339_),
    .A1(net126),
    .A2(net415));
 sg13g2_inv_1 _2150_ (.Y(_0534_),
    .A(\pll_dig.flock.FCW_PA[6] ));
 sg13g2_nor2b_1 _2151_ (.A(net395),
    .B_N(_1339_),
    .Y(_0372_));
 sg13g2_nor2_1 _2152_ (.A(\pll_dig.flock.cnt_gray[3] ),
    .B(net127),
    .Y(_1340_));
 sg13g2_nor2_1 _2153_ (.A(\pll_dig.flock.cnt[4] ),
    .B(net389),
    .Y(_1341_));
 sg13g2_xor2_1 _2154_ (.B(_1341_),
    .A(\pll_dig.flock.cnt[5] ),
    .X(_1342_));
 sg13g2_a21oi_1 _2155_ (.A1(net127),
    .A2(_1342_),
    .Y(_0371_),
    .B1(_1340_));
 sg13g2_nor2_1 _2156_ (.A(\pll_dig.flock.cnt[12] ),
    .B(net390),
    .Y(_1343_));
 sg13g2_xor2_1 _2157_ (.B(_1343_),
    .A(\pll_dig.flock.cnt[13] ),
    .X(_1344_));
 sg13g2_nor2_1 _2158_ (.A(\pll_dig.flock.cnt_gray[11] ),
    .B(net128),
    .Y(_1345_));
 sg13g2_a21oi_1 _2159_ (.A1(net128),
    .A2(_1344_),
    .Y(_0370_),
    .B1(_1345_));
 sg13g2_a21oi_1 _2160_ (.A1(\pll_dig.ref_wd.cnt[0] ),
    .A2(_0974_),
    .Y(_1346_),
    .B1(\pll_dig.ref_wd.cnt[1] ));
 sg13g2_inv_1 _2161_ (.Y(_0535_),
    .A(\pll_dig.flock.FCW_PA[2] ));
 sg13g2_and2_1 _2162_ (.A(_0521_),
    .B(_0977_),
    .X(_1347_));
 sg13g2_nor3_1 _2163_ (.A(_0972_),
    .B(_1346_),
    .C(_1347_),
    .Y(_0369_));
 sg13g2_o21ai_1 _2164_ (.B1(_0974_),
    .Y(_0368_),
    .A1(_0976_),
    .A2(_0979_));
 sg13g2_a21oi_1 _2165_ (.A1(net127),
    .A2(net389),
    .Y(_1348_),
    .B1(\pll_dig.flock.cnt[4] ));
 sg13g2_nor2_1 _2166_ (.A(_1260_),
    .B(_1348_),
    .Y(_0367_));
 sg13g2_xor2_1 _2167_ (.B(net395),
    .A(\pll_dig.flock.cnt[12] ),
    .X(_0366_));
 sg13g2_a21oi_1 _2168_ (.A1(\pll_dig.flock.cnt[4] ),
    .A2(net389),
    .Y(_1349_),
    .B1(\pll_dig.flock.cnt[5] ));
 sg13g2_nand2_1 _2169_ (.Y(_1350_),
    .A(\pll_dig.flock.cnt_gray[4] ),
    .B(net125));
 sg13g2_xor2_1 _2170_ (.B(_1349_),
    .A(\pll_dig.flock.cnt[6] ),
    .X(_1351_));
 sg13g2_o21ai_1 _2171_ (.B1(_1350_),
    .Y(_0365_),
    .A1(net125),
    .A2(_1351_));
 sg13g2_inv_1 _2172_ (.Y(_0536_),
    .A(net44));
 sg13g2_a21oi_2 _2173_ (.B1(\pll_dig.flock.cnt[13] ),
    .Y(_1352_),
    .A2(net390),
    .A1(\pll_dig.flock.cnt[12] ));
 sg13g2_nor2_1 _2174_ (.A(\pll_dig.flock.cnt_gray[12] ),
    .B(net128),
    .Y(_1353_));
 sg13g2_xor2_1 _2175_ (.B(_1352_),
    .A(\pll_dig.flock.cnt[14] ),
    .X(_1354_));
 sg13g2_a21oi_1 _2176_ (.A1(net128),
    .A2(_1354_),
    .Y(_0364_),
    .B1(_1353_));
 sg13g2_o21ai_1 _2177_ (.B1(_0973_),
    .Y(_1355_),
    .A1(\pll_dig.ref_wd.cnt[2] ),
    .A2(_1347_));
 sg13g2_a21oi_1 _2178_ (.A1(\pll_dig.ref_wd.cnt[2] ),
    .A2(_1347_),
    .Y(_0363_),
    .B1(_1355_));
 sg13g2_a21oi_1 _2179_ (.A1(_0521_),
    .A2(_0527_),
    .Y(_0362_),
    .B1(_0972_));
 sg13g2_nand2_1 _2180_ (.Y(_1356_),
    .A(\pll_dig.flock.freq_miss[1] ),
    .B(\pll_dig.flock.freq_miss[0] ));
 sg13g2_nand3_1 _2181_ (.B(\pll_dig.FREQ_OK ),
    .C(_1356_),
    .A(_0468_),
    .Y(_1357_));
 sg13g2_a21oi_1 _2182_ (.A1(_1215_),
    .A2(_1357_),
    .Y(_0361_),
    .B1(_0512_));
 sg13g2_inv_1 _2183_ (.Y(_0537_),
    .A(\pll_dig.flock.cnt_filt[5] ));
 sg13g2_nand3_1 _2184_ (.B(\pll_dig.div_rst_cnt[1] ),
    .C(\pll_dig.div_rst_cnt[2] ),
    .A(\pll_dig.div_rst_cnt[0] ),
    .Y(_1358_));
 sg13g2_or2_1 _2185_ (.X(_1359_),
    .B(_1358_),
    .A(_0538_));
 sg13g2_nor2b_1 _2186_ (.A(net144),
    .B_N(_1359_),
    .Y(_1360_));
 sg13g2_inv_1 _2187_ (.Y(_0009_),
    .A(_1360_));
 sg13g2_nand2_1 _2188_ (.Y(_1361_),
    .A(\pll_dig.out_edges[6] ),
    .B(_0873_));
 sg13g2_nor2_1 _2189_ (.A(_0448_),
    .B(_1361_),
    .Y(_1362_));
 sg13g2_nand2_1 _2190_ (.Y(_1363_),
    .A(\pll_dig.out_edges[8] ),
    .B(_1362_));
 sg13g2_xnor2_1 _2191_ (.Y(\pll_dig.out_edges_next[9] ),
    .A(\pll_dig.out_edges[9] ),
    .B(_1363_));
 sg13g2_xor2_1 _2192_ (.B(\pll_dig.out_edges[0] ),
    .A(\pll_dig.out_edges[1] ),
    .X(\pll_dig.out_edges_next[1] ));
 sg13g2_a21oi_1 _2193_ (.A1(\pll_dig.out_edges[4] ),
    .A2(_0870_),
    .Y(_1364_),
    .B1(\pll_dig.out_edges[5] ));
 sg13g2_inv_1 _2194_ (.Y(_0444_),
    .A(\pll_dig.START ));
 sg13g2_inv_1 _2195_ (.Y(\pll_dig.dsm_impl.u_dsm_icg.EN ),
    .A(\pll_dig.dsm_impl.locked_dsm_s2 ));
 sg13g2_xnor2_1 _2196_ (.Y(_0005_),
    .A(\pll_dig.out_edges[6] ),
    .B(_1364_));
 sg13g2_xor2_1 _2197_ (.B(\pll_dig.out_edges_next[1] ),
    .A(\pll_dig.out_edges_next[2] ),
    .X(_0001_));
 sg13g2_nor2_1 _2198_ (.A(\pll_dig.out_edges[8] ),
    .B(_1362_),
    .Y(_1365_));
 sg13g2_xor2_1 _2199_ (.B(_1362_),
    .A(\pll_dig.out_edges[8] ),
    .X(\pll_dig.out_edges_next[8] ));
 sg13g2_nand2_1 _2200_ (.Y(_1366_),
    .A(_0448_),
    .B(_1361_));
 sg13g2_nor2b_1 _2201_ (.A(_1362_),
    .B_N(_1366_),
    .Y(\pll_dig.out_edges_next[7] ));
 sg13g2_nor2b_1 _2202_ (.A(_0874_),
    .B_N(_1361_),
    .Y(\pll_dig.out_edges_next[6] ));
 sg13g2_nor2_1 _2203_ (.A(_0873_),
    .B(_1364_),
    .Y(\pll_dig.out_edges_next[5] ));
 sg13g2_and2_1 _2204_ (.A(_0449_),
    .B(_0869_),
    .X(_1367_));
 sg13g2_nor2_1 _2205_ (.A(_0870_),
    .B(_1367_),
    .Y(\pll_dig.out_edges_next[3] ));
 sg13g2_inv_1 _2206_ (.Y(_0538_),
    .A(\pll_dig.div_rst_cnt[3] ));
 sg13g2_xnor2_1 _2207_ (.Y(_0008_),
    .A(\pll_dig.out_edges[9] ),
    .B(_1365_));
 sg13g2_xnor2_1 _2208_ (.Y(_0004_),
    .A(\pll_dig.out_edges[5] ),
    .B(_0871_));
 sg13g2_xnor2_1 _2209_ (.Y(_1368_),
    .A(\pll_dig.flock.cnt_bin[14] ),
    .B(_0110_));
 sg13g2_nor2_1 _2210_ (.A(\pll_dig.flock.cnt_bin[13] ),
    .B(_0868_),
    .Y(_1369_));
 sg13g2_nand2_1 _2211_ (.Y(_1370_),
    .A(\pll_dig.flock.cnt_bin[13] ),
    .B(_0868_));
 sg13g2_nor2b_1 _2212_ (.A(\pll_dig.flock.cnt_bin[12] ),
    .B_N(_0108_),
    .Y(_1371_));
 sg13g2_nand2_1 _2213_ (.Y(_1372_),
    .A(\pll_dig.flock.cnt_bin[12] ),
    .B(_0108_));
 sg13g2_or2_1 _2214_ (.X(_1373_),
    .B(_0108_),
    .A(\pll_dig.flock.cnt_bin[12] ));
 sg13g2_nand2_1 _2215_ (.Y(_1374_),
    .A(_1372_),
    .B(_1373_));
 sg13g2_or2_1 _2216_ (.X(_1375_),
    .B(_1291_),
    .A(\pll_dig.flock.cnt_bin[11] ));
 sg13g2_inv_1 _2217_ (.Y(_0539_),
    .A(\pll_dig.PHASE_LOCK ));
 sg13g2_and2_1 _2218_ (.A(\pll_dig.flock.cnt_bin[11] ),
    .B(_1291_),
    .X(_1376_));
 sg13g2_xnor2_1 _2219_ (.Y(_1377_),
    .A(_0508_),
    .B(_0106_));
 sg13g2_nor2b_1 _2220_ (.A(\pll_dig.flock.cnt_bin[9] ),
    .B_N(_0119_),
    .Y(_1378_));
 sg13g2_nor2b_1 _2221_ (.A(_0119_),
    .B_N(\pll_dig.flock.cnt_bin[9] ),
    .Y(_1379_));
 sg13g2_nor2_1 _2222_ (.A(\pll_dig.flock.cnt_bin[8] ),
    .B(_1292_),
    .Y(_1380_));
 sg13g2_xnor2_1 _2223_ (.Y(_1381_),
    .A(\pll_dig.flock.cnt_bin[8] ),
    .B(_1292_));
 sg13g2_nor2b_1 _2224_ (.A(\pll_dig.flock.cnt_bin[7] ),
    .B_N(_0117_),
    .Y(_1382_));
 sg13g2_nor2b_1 _2225_ (.A(_0117_),
    .B_N(\pll_dig.flock.cnt_bin[7] ),
    .Y(_1383_));
 sg13g2_nor2_1 _2226_ (.A(\pll_dig.flock.cnt_bin[6] ),
    .B(_1293_),
    .Y(_1384_));
 sg13g2_xnor2_1 _2227_ (.Y(_1385_),
    .A(\pll_dig.flock.cnt_bin[6] ),
    .B(_1293_));
 sg13g2_inv_1 _2228_ (.Y(_0540_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[2] ));
 sg13g2_and2_1 _2229_ (.A(_0507_),
    .B(_0115_),
    .X(_1386_));
 sg13g2_or2_1 _2230_ (.X(_1387_),
    .B(_0115_),
    .A(_0507_));
 sg13g2_inv_1 _2231_ (.Y(_1388_),
    .A(_1387_));
 sg13g2_nor2b_1 _2232_ (.A(\pll_dig.flock.cnt_bin[4] ),
    .B_N(_0114_),
    .Y(_1389_));
 sg13g2_nand2b_1 _2233_ (.Y(_1390_),
    .B(_0113_),
    .A_N(\pll_dig.flock.cnt_bin[3] ));
 sg13g2_nor2_1 _2234_ (.A(\pll_dig.flock.cnt_bin[2] ),
    .B(_1294_),
    .Y(_1391_));
 sg13g2_nand2b_1 _2235_ (.Y(_1392_),
    .B(_0111_),
    .A_N(\pll_dig.flock.cnt_bin[1] ));
 sg13g2_xnor2_1 _2236_ (.Y(_1393_),
    .A(\pll_dig.flock.cnt_bin[1] ),
    .B(_0111_));
 sg13g2_or2_1 _2237_ (.X(_1394_),
    .B(_0105_),
    .A(_0513_));
 sg13g2_o21ai_1 _2238_ (.B1(_1393_),
    .Y(_1395_),
    .A1(_0513_),
    .A2(_0105_));
 sg13g2_inv_1 _2239_ (.Y(_0541_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[8] ));
 sg13g2_xnor2_1 _2240_ (.Y(_1396_),
    .A(\pll_dig.flock.cnt_bin[2] ),
    .B(_1294_));
 sg13g2_a21oi_1 _2241_ (.A1(_1392_),
    .A2(_1395_),
    .Y(_1397_),
    .B1(_1396_));
 sg13g2_xnor2_1 _2242_ (.Y(_1398_),
    .A(\pll_dig.flock.cnt_bin[3] ),
    .B(_0113_));
 sg13g2_o21ai_1 _2243_ (.B1(_1398_),
    .Y(_1399_),
    .A1(_1391_),
    .A2(_1397_));
 sg13g2_xor2_1 _2244_ (.B(_0114_),
    .A(\pll_dig.flock.cnt_bin[4] ),
    .X(_1400_));
 sg13g2_a21oi_1 _2245_ (.A1(_1390_),
    .A2(_1399_),
    .Y(_1401_),
    .B1(_1400_));
 sg13g2_nor2_1 _2246_ (.A(_1389_),
    .B(_1401_),
    .Y(_1402_));
 sg13g2_nor3_1 _2247_ (.A(_1386_),
    .B(_1389_),
    .C(_1401_),
    .Y(_1403_));
 sg13g2_nor3_1 _2248_ (.A(_1385_),
    .B(_1388_),
    .C(_1403_),
    .Y(_1404_));
 sg13g2_or2_1 _2249_ (.X(_1405_),
    .B(_1404_),
    .A(_1384_));
 sg13g2_inv_1 _2250_ (.Y(_0542_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[1] ));
 sg13g2_nor3_1 _2251_ (.A(_1382_),
    .B(_1384_),
    .C(_1404_),
    .Y(_1406_));
 sg13g2_nor3_1 _2252_ (.A(_1381_),
    .B(_1383_),
    .C(_1406_),
    .Y(_1407_));
 sg13g2_or2_1 _2253_ (.X(_1408_),
    .B(_1407_),
    .A(_1380_));
 sg13g2_nor3_1 _2254_ (.A(_1378_),
    .B(_1380_),
    .C(_1407_),
    .Y(_1409_));
 sg13g2_or2_1 _2255_ (.X(_1410_),
    .B(_1409_),
    .A(_1379_));
 sg13g2_nor3_1 _2256_ (.A(_1377_),
    .B(_1379_),
    .C(_1409_),
    .Y(_1411_));
 sg13g2_a21oi_1 _2257_ (.A1(_0508_),
    .A2(_0106_),
    .Y(_1412_),
    .B1(_1411_));
 sg13g2_a21oi_1 _2258_ (.A1(_1375_),
    .A2(_1412_),
    .Y(_1413_),
    .B1(_1376_));
 sg13g2_a221oi_1 _2259_ (.B2(_1412_),
    .C1(_1376_),
    .B1(_1375_),
    .A1(_1372_),
    .Y(_1414_),
    .A2(_1373_));
 sg13g2_nor2_1 _2260_ (.A(_1371_),
    .B(_1414_),
    .Y(_1415_));
 sg13g2_inv_1 _2261__272 (.Y(net271),
    .A(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_or3_1 _2262_ (.A(_1369_),
    .B(_1371_),
    .C(_1414_),
    .X(_1416_));
 sg13g2_nand3_1 _2263_ (.B(_1370_),
    .C(_1416_),
    .A(_1368_),
    .Y(_1417_));
 sg13g2_a21o_1 _2264_ (.A2(_1416_),
    .A1(_1370_),
    .B1(_1368_),
    .X(_1418_));
 sg13g2_and3_1 _2265_ (.X(_0068_),
    .A(net158),
    .B(_1417_),
    .C(_1418_));
 sg13g2_a221oi_1 _2266_ (.B2(\pll_dig.MID_MUX_D[7] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[9] ),
    .Y(_1419_),
    .A2(net92));
 sg13g2_nand2_1 _2267_ (.Y(_1420_),
    .A(\pll_dig.MID_MUX_D[8] ),
    .B(net77));
 sg13g2_o21ai_1 _2268_ (.B1(_1420_),
    .Y(_0351_),
    .A1(net77),
    .A2(_1419_));
 sg13g2_xnor2_1 _2269_ (.Y(_0350_),
    .A(_0453_),
    .B(_0962_));
 sg13g2_nand2b_1 _2270_ (.Y(_1421_),
    .B(_1370_),
    .A_N(_1369_));
 sg13g2_o21ai_1 _2271_ (.B1(net158),
    .Y(_1422_),
    .A1(_1415_),
    .A2(_1421_));
 sg13g2_inv_1 _2272_ (.Y(_0543_),
    .A(net42));
 sg13g2_a21oi_1 _2273_ (.A1(_1415_),
    .A2(_1421_),
    .Y(_0067_),
    .B1(_1422_));
 sg13g2_nor2_1 _2274_ (.A(net121),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .Y(_1423_));
 sg13g2_a21oi_1 _2275_ (.A1(net121),
    .A2(_0757_),
    .Y(_0349_),
    .B1(_1423_));
 sg13g2_nand2_1 _2276_ (.Y(_1424_),
    .A(_0444_),
    .B(\pll_dig.FREQ_ERR ));
 sg13g2_nand2_1 _2277_ (.Y(_1425_),
    .A(\pll_dig.flock.cnt_err[0] ),
    .B(net104));
 sg13g2_nand2b_1 _2278_ (.Y(_1426_),
    .B(_0806_),
    .A_N(_1425_));
 sg13g2_or3_1 _2279_ (.A(\pll_dig.COARSE_MUX_D[0] ),
    .B(\pll_dig.flock.cnt_err[0] ),
    .C(_0806_),
    .X(_1427_));
 sg13g2_a21oi_1 _2280_ (.A1(_1426_),
    .A2(_1427_),
    .Y(_1428_),
    .B1(_0798_));
 sg13g2_nor2_1 _2281_ (.A(_1298_),
    .B(_1428_),
    .Y(_1429_));
 sg13g2_nor2_1 _2282_ (.A(\pll_dig.flock.cnt_err[5] ),
    .B(\pll_dig.flock.cnt_err[4] ),
    .Y(_1430_));
 sg13g2_inv_1 _2283_ (.Y(_0544_),
    .A(net38));
 sg13g2_nor4_1 _2284_ (.A(\pll_dig.flock.cnt_err[2] ),
    .B(\pll_dig.flock.cnt_err[7] ),
    .C(\pll_dig.flock.cnt_err[1] ),
    .D(\pll_dig.flock.cnt_err[0] ),
    .Y(_1431_));
 sg13g2_nand4_1 _2285_ (.B(_0531_),
    .C(_1430_),
    .A(\pll_dig.flock.cnt_err[6] ),
    .Y(_1432_),
    .D(_1431_));
 sg13g2_o21ai_1 _2286_ (.B1(_1424_),
    .Y(_0011_),
    .A1(_1429_),
    .A2(_1432_));
 sg13g2_xnor2_1 _2287_ (.Y(_0145_),
    .A(net459),
    .B(_1248_));
 sg13g2_nor2_1 _2288_ (.A(\pll_dig.COARSE_MUX_D[13] ),
    .B(net71),
    .Y(_1433_));
 sg13g2_a22oi_1 _2289_ (.Y(_1434_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[12] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[14] ));
 sg13g2_a21oi_1 _2290_ (.A1(net71),
    .A2(_1434_),
    .Y(_0348_),
    .B1(_1433_));
 sg13g2_a21oi_1 _2291_ (.A1(\pll_dig.flock.cnt[12] ),
    .A2(net395),
    .Y(_1435_),
    .B1(\pll_dig.flock.cnt[13] ));
 sg13g2_a21oi_1 _2292_ (.A1(net128),
    .A2(net387),
    .Y(_0347_),
    .B1(_1435_));
 sg13g2_nor2_1 _2293_ (.A(\pll_dig.flock.cnt[6] ),
    .B(net388),
    .Y(_1436_));
 sg13g2_inv_1 _2294_ (.Y(_0545_),
    .A(net37));
 sg13g2_xor2_1 _2295_ (.B(_1436_),
    .A(\pll_dig.flock.cnt[7] ),
    .X(_1437_));
 sg13g2_nand2_1 _2296_ (.Y(_1438_),
    .A(\pll_dig.flock.cnt_gray[5] ),
    .B(net126));
 sg13g2_o21ai_1 _2297_ (.B1(_1438_),
    .Y(_0346_),
    .A1(net126),
    .A2(_1437_));
 sg13g2_nor2_1 _2298_ (.A(\pll_dig.flock.cnt_gray[13] ),
    .B(net128),
    .Y(_1439_));
 sg13g2_nor2_2 _2299_ (.A(\pll_dig.flock.cnt[14] ),
    .B(_0837_),
    .Y(_1440_));
 sg13g2_xor2_1 _2300_ (.B(_1440_),
    .A(\pll_dig.flock.cnt[15] ),
    .X(_1441_));
 sg13g2_a21oi_1 _2301_ (.A1(_1441_),
    .A2(net129),
    .Y(_0345_),
    .B1(_1439_));
 sg13g2_and4_1 _2302_ (.A(\pll_dig.ref_wd.cnt[2] ),
    .B(\pll_dig.ref_wd.cnt[3] ),
    .C(_0974_),
    .D(_0977_),
    .X(_1442_));
 sg13g2_a21oi_1 _2303_ (.A1(\pll_dig.ref_wd.cnt[2] ),
    .A2(_1347_),
    .Y(_1443_),
    .B1(\pll_dig.ref_wd.cnt[3] ));
 sg13g2_nor3_1 _2304_ (.A(_0972_),
    .B(_1442_),
    .C(_1443_),
    .Y(_0344_));
 sg13g2_inv_1 _2305_ (.Y(_0445_),
    .A(\pll_dig.cntf[2] ));
 sg13g2_inv_1 _2306_ (.Y(_0546_),
    .A(net2));
 sg13g2_a21o_1 _2307_ (.A2(_0837_),
    .A1(net129),
    .B1(\pll_dig.flock.cnt[14] ),
    .X(_1444_));
 sg13g2_and2_1 _2308_ (.A(_0839_),
    .B(_1444_),
    .X(_0343_));
 sg13g2_a21oi_1 _2309_ (.A1(\pll_dig.flock.cnt[6] ),
    .A2(net388),
    .Y(_1445_),
    .B1(\pll_dig.flock.cnt[7] ));
 sg13g2_nor2_1 _2310_ (.A(\pll_dig.flock.cnt_gray[6] ),
    .B(net131),
    .Y(_1446_));
 sg13g2_xnor2_1 _2311_ (.Y(_1447_),
    .A(_0453_),
    .B(_1445_));
 sg13g2_a21oi_1 _2312_ (.A1(net131),
    .A2(_1447_),
    .Y(_0342_),
    .B1(_1446_));
 sg13g2_nor2_1 _2313_ (.A(\pll_dig.flock.cnt_gray[14] ),
    .B(net129),
    .Y(_1448_));
 sg13g2_a21oi_2 _2314_ (.B1(\pll_dig.flock.cnt[15] ),
    .Y(_1449_),
    .A2(_0837_),
    .A1(\pll_dig.flock.cnt[14] ));
 sg13g2_xor2_1 _2315_ (.B(_1449_),
    .A(\pll_dig.flock.cnt_gray[15] ),
    .X(_1450_));
 sg13g2_a21oi_1 _2316_ (.A1(net129),
    .A2(_1450_),
    .Y(_0341_),
    .B1(_1448_));
 sg13g2_inv_1 _2317_ (.Y(_0547_),
    .A(\pll_dig.div.cnt[3] ));
 sg13g2_o21ai_1 _2318_ (.B1(_0973_),
    .Y(_1451_),
    .A1(\pll_dig.ref_wd.cnt[4] ),
    .A2(_1442_));
 sg13g2_nor2_1 _2319_ (.A(_1218_),
    .B(_1451_),
    .Y(_0340_));
 sg13g2_nor2_1 _2320_ (.A(\pll_dig.COARSE_MUX_D[5] ),
    .B(net73),
    .Y(_1452_));
 sg13g2_a22oi_1 _2321_ (.Y(_1453_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[4] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[6] ));
 sg13g2_a21oi_1 _2322_ (.A1(net73),
    .A2(_1453_),
    .Y(_0338_),
    .B1(_1452_));
 sg13g2_nor2_1 _2323_ (.A(\pll_dig.COARSE_MUX_D[10] ),
    .B(net71),
    .Y(_1454_));
 sg13g2_a22oi_1 _2324_ (.Y(_1455_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[9] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[11] ));
 sg13g2_a21oi_1 _2325_ (.A1(net71),
    .A2(_1455_),
    .Y(_0337_),
    .B1(_1454_));
 sg13g2_a21oi_1 _2326_ (.A1(\pll_dig.MID_MUX_D[13] ),
    .A2(net91),
    .Y(_1456_),
    .B1(net76));
 sg13g2_a21oi_1 _2327_ (.A1(_0809_),
    .A2(_0819_),
    .Y(_1457_),
    .B1(\pll_dig.MID_MUX_D[14] ));
 sg13g2_inv_1 _2328_ (.Y(_0548_),
    .A(\pll_dig.div.pcnt[3] ));
 sg13g2_nor2_1 _2329_ (.A(_1456_),
    .B(_1457_),
    .Y(_0336_));
 sg13g2_a221oi_1 _2330_ (.B2(\pll_dig.MID_MUX_D[4] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[6] ),
    .Y(_1458_),
    .A2(net92));
 sg13g2_nand2_1 _2331_ (.Y(_1459_),
    .A(\pll_dig.MID_MUX_D[5] ),
    .B(net78));
 sg13g2_o21ai_1 _2332_ (.B1(_1459_),
    .Y(_0335_),
    .A1(net78),
    .A2(_1458_));
 sg13g2_a221oi_1 _2333_ (.B2(\pll_dig.MID_MUX_D[9] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[11] ),
    .Y(_1460_),
    .A2(net92));
 sg13g2_nand2_1 _2334_ (.Y(_1461_),
    .A(\pll_dig.MID_MUX_D[10] ),
    .B(net77));
 sg13g2_o21ai_1 _2335_ (.B1(_1461_),
    .Y(_0334_),
    .A1(net77),
    .A2(_1460_));
 sg13g2_nand2b_1 _2336_ (.Y(_1462_),
    .B(\pll_dig.flock.freq_miss[2] ),
    .A_N(\pll_dig.flock.freq_miss[0] ));
 sg13g2_o21ai_1 _2337_ (.B1(_1462_),
    .Y(_1463_),
    .A1(\pll_dig.flock.freq_miss[1] ),
    .A2(_1217_));
 sg13g2_nor2_1 _2338_ (.A(_1216_),
    .B(_1463_),
    .Y(_0333_));
 sg13g2_inv_1 _2339_ (.Y(\pll_dig.FILTER_OUT[15] ),
    .A(_0131_));
 sg13g2_xor2_1 _2340_ (.B(_1260_),
    .A(\pll_dig.flock.cnt[5] ),
    .X(_0332_));
 sg13g2_a221oi_1 _2341_ (.B2(\pll_dig.MID_MUX_D[12] ),
    .C1(net76),
    .B1(net91),
    .A1(\pll_dig.MID_MUX_D[14] ),
    .Y(_1464_),
    .A2(net93));
 sg13g2_a21oi_1 _2342_ (.A1(_0488_),
    .A2(net76),
    .Y(_0331_),
    .B1(_1464_));
 sg13g2_xnor2_1 _2343_ (.Y(_0330_),
    .A(net416),
    .B(net125));
 sg13g2_nand3b_1 _2344_ (.B(_1300_),
    .C(\pll_dig.flock.cnt_coarse_wait[7] ),
    .Y(_1465_),
    .A_N(_0804_));
 sg13g2_nand2_1 _2345_ (.Y(_0020_),
    .A(net68),
    .B(_1465_));
 sg13g2_a21oi_1 _2346_ (.A1(_1377_),
    .A2(_1410_),
    .Y(_1466_),
    .B1(_0512_));
 sg13g2_nor2b_1 _2347_ (.A(_1411_),
    .B_N(_1466_),
    .Y(_0064_));
 sg13g2_nor2_1 _2348_ (.A(_1378_),
    .B(_1379_),
    .Y(_1467_));
 sg13g2_o21ai_1 _2349_ (.B1(net158),
    .Y(_1468_),
    .A1(_1408_),
    .A2(_1467_));
 sg13g2_and2_1 _2350_ (.A(net414),
    .B(\pll_dig.div.ncnt[0] ),
    .X(_0549_));
 sg13g2_a21oi_1 _2351_ (.A1(_1408_),
    .A2(_1467_),
    .Y(_0063_),
    .B1(_1468_));
 sg13g2_o21ai_1 _2352_ (.B1(_1381_),
    .Y(_1469_),
    .A1(_1383_),
    .A2(_1406_));
 sg13g2_nand2_1 _2353_ (.Y(_1470_),
    .A(net159),
    .B(_1469_));
 sg13g2_nor2_1 _2354_ (.A(_1407_),
    .B(_1470_),
    .Y(_0077_));
 sg13g2_xnor2_1 _2355_ (.Y(_1471_),
    .A(\pll_dig.flock.cnt_coarse_wait[5] ),
    .B(_0802_));
 sg13g2_o21ai_1 _2356_ (.B1(net68),
    .Y(_0018_),
    .A1(_1301_),
    .A2(_1471_));
 sg13g2_xnor2_1 _2357_ (.Y(_1472_),
    .A(\pll_dig.flock.cnt_coarse_wait[2] ),
    .B(_0799_));
 sg13g2_o21ai_1 _2358_ (.B1(net68),
    .Y(_0015_),
    .A1(_1301_),
    .A2(_1472_));
 sg13g2_xor2_1 _2359_ (.B(\pll_dig.flock.cnt_coarse_wait[1] ),
    .A(\pll_dig.flock.cnt_coarse_wait[0] ),
    .X(_1473_));
 sg13g2_o21ai_1 _2360_ (.B1(net68),
    .Y(_0014_),
    .A1(_1301_),
    .A2(_1473_));
 sg13g2_nand2_1 _2361_ (.Y(_0550_),
    .A(\pll_dig.div.ncnt[2] ),
    .B(_0549_));
 sg13g2_o21ai_1 _2362_ (.B1(_1296_),
    .Y(_1474_),
    .A1(\pll_dig.COARSE_MUX_D[14] ),
    .A2(_0806_));
 sg13g2_a21oi_1 _2363_ (.A1(_0809_),
    .A2(_1474_),
    .Y(_0013_),
    .B1(\pll_dig.flock.cnt_coarse_wait[0] ));
 sg13g2_nand3_1 _2364_ (.B(net104),
    .C(_1336_),
    .A(\pll_dig.flock.cnt_err[5] ),
    .Y(_1475_));
 sg13g2_xnor2_1 _2365_ (.Y(_1476_),
    .A(\pll_dig.flock.cnt_err[5] ),
    .B(_1333_));
 sg13g2_o21ai_1 _2366_ (.B1(_1475_),
    .Y(_0034_),
    .A1(net69),
    .A2(_1476_));
 sg13g2_o21ai_1 _2367_ (.B1(_1426_),
    .Y(_1477_),
    .A1(\pll_dig.flock.cnt_err[0] ),
    .A2(_1297_));
 sg13g2_a21oi_1 _2368_ (.A1(_1296_),
    .A2(_1477_),
    .Y(_1478_),
    .B1(_1428_));
 sg13g2_o21ai_1 _2369_ (.B1(_1478_),
    .Y(_0029_),
    .A1(_0819_),
    .A2(_1425_));
 sg13g2_nand3_1 _2370_ (.B(net104),
    .C(_1336_),
    .A(\pll_dig.flock.cnt_err[1] ),
    .Y(_1479_));
 sg13g2_xnor2_1 _2371_ (.Y(_1480_),
    .A(\pll_dig.flock.cnt_err[1] ),
    .B(\pll_dig.flock.cnt_err[0] ));
 sg13g2_nor2_1 _2372_ (.A(_2059_),
    .B(_0550_),
    .Y(_0551_));
 sg13g2_o21ai_1 _2373_ (.B1(_1479_),
    .Y(_0030_),
    .A1(net68),
    .A2(_1480_));
 sg13g2_nand3_1 _2374_ (.B(net104),
    .C(_1336_),
    .A(\pll_dig.flock.cnt_err[6] ),
    .Y(_1481_));
 sg13g2_a21o_1 _2375_ (.A2(_1333_),
    .A1(\pll_dig.flock.cnt_err[5] ),
    .B1(\pll_dig.flock.cnt_err[6] ),
    .X(_1482_));
 sg13g2_nand2_1 _2376_ (.Y(_1483_),
    .A(_1334_),
    .B(_1482_));
 sg13g2_o21ai_1 _2377_ (.B1(_1481_),
    .Y(_0035_),
    .A1(net69),
    .A2(_1483_));
 sg13g2_xor2_1 _2378_ (.B(_0800_),
    .A(\pll_dig.flock.cnt_coarse_wait[3] ),
    .X(_1484_));
 sg13g2_o21ai_1 _2379_ (.B1(net68),
    .Y(_0016_),
    .A1(_1301_),
    .A2(_1484_));
 sg13g2_nand3_1 _2380_ (.B(net104),
    .C(_1336_),
    .A(\pll_dig.flock.cnt_err[4] ),
    .Y(_1485_));
 sg13g2_xnor2_1 _2381_ (.Y(_1486_),
    .A(\pll_dig.flock.cnt_err[4] ),
    .B(_1332_));
 sg13g2_o21ai_1 _2382_ (.B1(_1485_),
    .Y(_0033_),
    .A1(net69),
    .A2(_1486_));
 sg13g2_nand3_1 _2383_ (.B(\pll_dig.div.ncnt[4] ),
    .C(_0551_),
    .A(\pll_dig.div.ncnt[5] ),
    .Y(_0552_));
 sg13g2_nand3_1 _2384_ (.B(net104),
    .C(_1336_),
    .A(\pll_dig.flock.cnt_err[3] ),
    .Y(_1487_));
 sg13g2_xnor2_1 _2385_ (.Y(_1488_),
    .A(_0531_),
    .B(_1331_));
 sg13g2_o21ai_1 _2386_ (.B1(_1487_),
    .Y(_0032_),
    .A1(net69),
    .A2(_1488_));
 sg13g2_nand3_1 _2387_ (.B(net104),
    .C(_1336_),
    .A(\pll_dig.flock.cnt_err[2] ),
    .Y(_1489_));
 sg13g2_a21o_1 _2388_ (.A2(\pll_dig.flock.cnt_err[0] ),
    .A1(\pll_dig.flock.cnt_err[1] ),
    .B1(\pll_dig.flock.cnt_err[2] ),
    .X(_1490_));
 sg13g2_nand2_1 _2389_ (.Y(_1491_),
    .A(_1331_),
    .B(_1490_));
 sg13g2_o21ai_1 _2390_ (.B1(_1489_),
    .Y(_0031_),
    .A1(net69),
    .A2(_1491_));
 sg13g2_o21ai_1 _2391_ (.B1(_1385_),
    .Y(_1492_),
    .A1(_1388_),
    .A2(_1403_));
 sg13g2_and2_1 _2392_ (.A(net158),
    .B(_1492_),
    .X(_1493_));
 sg13g2_nor2b_1 _2393_ (.A(_1404_),
    .B_N(_1493_),
    .Y(_0075_));
 sg13g2_nand4_1 _2394_ (.B(\pll_dig.div.ncnt[5] ),
    .C(\pll_dig.div.ncnt[4] ),
    .A(\pll_dig.div.ncnt[6] ),
    .Y(_0553_),
    .D(_0551_));
 sg13g2_nand2b_1 _2395_ (.Y(_1494_),
    .B(_1387_),
    .A_N(_1386_));
 sg13g2_o21ai_1 _2396_ (.B1(net158),
    .Y(_1495_),
    .A1(_1402_),
    .A2(_1494_));
 sg13g2_a21oi_1 _2397_ (.A1(_1402_),
    .A2(_1494_),
    .Y(_0074_),
    .B1(_1495_));
 sg13g2_nor2_1 _2398_ (.A(_1382_),
    .B(_1383_),
    .Y(_1496_));
 sg13g2_o21ai_1 _2399_ (.B1(net159),
    .Y(_1497_),
    .A1(_1405_),
    .A2(_1496_));
 sg13g2_a21oi_1 _2400_ (.A1(_1405_),
    .A2(_1496_),
    .Y(_0076_),
    .B1(_1497_));
 sg13g2_nor3_1 _2401_ (.A(_1391_),
    .B(_1397_),
    .C(_1398_),
    .Y(_1498_));
 sg13g2_nand2_1 _2402_ (.Y(_1499_),
    .A(net158),
    .B(_1399_));
 sg13g2_nor2_1 _2403_ (.A(_1498_),
    .B(_1499_),
    .Y(_0072_));
 sg13g2_and3_1 _2404_ (.X(_1500_),
    .A(_1392_),
    .B(_1395_),
    .C(_1396_));
 sg13g2_xor2_1 _2405_ (.B(_0553_),
    .A(\pll_dig.div.ncnt[7] ),
    .X(_0554_));
 sg13g2_nor3_1 _2406_ (.A(_0512_),
    .B(_1397_),
    .C(_1500_),
    .Y(_0071_));
 sg13g2_xnor2_1 _2407_ (.Y(_1501_),
    .A(\pll_dig.flock.cnt_bin[11] ),
    .B(_1291_));
 sg13g2_o21ai_1 _2408_ (.B1(net159),
    .Y(_1502_),
    .A1(_1412_),
    .A2(_1501_));
 sg13g2_a21oi_1 _2409_ (.A1(_1412_),
    .A2(_1501_),
    .Y(_0065_),
    .B1(_1502_));
 sg13g2_o21ai_1 _2410_ (.B1(net159),
    .Y(_1503_),
    .A1(_1374_),
    .A2(_1413_));
 sg13g2_nor2_1 _2411_ (.A(_1414_),
    .B(_1503_),
    .Y(_0066_));
 sg13g2_and3_1 _2412_ (.X(_1504_),
    .A(_1390_),
    .B(_1399_),
    .C(_1400_));
 sg13g2_nor3_1 _2413_ (.A(_0512_),
    .B(_1401_),
    .C(_1504_),
    .Y(_0073_));
 sg13g2_o21ai_1 _2414_ (.B1(net158),
    .Y(_1505_),
    .A1(_1393_),
    .A2(_1394_));
 sg13g2_nor2b_1 _2415_ (.A(_1505_),
    .B_N(_1395_),
    .Y(_0070_));
 sg13g2_inv_1 _2416_ (.Y(_0446_),
    .A(\pll_dig.cntf[3] ));
 sg13g2_xnor2_1 _2417_ (.Y(_0555_),
    .A(\pll_dig.div.ncnt[4] ),
    .B(_0551_));
 sg13g2_nand2_1 _2418_ (.Y(_1506_),
    .A(_0513_),
    .B(_0105_));
 sg13g2_a21oi_1 _2419_ (.A1(_1394_),
    .A2(_1506_),
    .Y(_0069_),
    .B1(_0512_));
 sg13g2_xor2_1 _2420_ (.B(_1288_),
    .A(net11),
    .X(_0125_));
 sg13g2_xnor2_1 _2421_ (.Y(_0122_),
    .A(_0485_),
    .B(_1285_));
 sg13g2_xnor2_1 _2422_ (.Y(_0100_),
    .A(net8),
    .B(_0612_));
 sg13g2_nand2b_1 _2423_ (.Y(_1507_),
    .B(_0737_),
    .A_N(net293));
 sg13g2_nand3_1 _2424_ (.B(_0738_),
    .C(_1507_),
    .A(net114),
    .Y(_1508_));
 sg13g2_o21ai_1 _2425_ (.B1(_1508_),
    .Y(_0325_),
    .A1(net116),
    .A2(_0532_));
 sg13g2_nor2_1 _2426_ (.A(net112),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .Y(_1509_));
 sg13g2_a21oi_1 _2427_ (.A1(net112),
    .A2(_0658_),
    .Y(_0324_),
    .B1(_1509_));
 sg13g2_xnor2_1 _2428_ (.Y(_0556_),
    .A(\pll_dig.div.ncnt[2] ),
    .B(_0549_));
 sg13g2_nand2_1 _2429_ (.Y(_1510_),
    .A(net119),
    .B(_0725_));
 sg13g2_o21ai_1 _2430_ (.B1(_1510_),
    .Y(_0323_),
    .A1(net119),
    .A2(_0533_));
 sg13g2_mux2_1 _2431_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .A1(_0649_),
    .S(net115),
    .X(_0322_));
 sg13g2_xor2_1 _2432_ (.B(_1366_),
    .A(\pll_dig.out_edges[8] ),
    .X(_0007_));
 sg13g2_xnor2_1 _2433_ (.Y(_0003_),
    .A(\pll_dig.out_edges[4] ),
    .B(_1367_));
 sg13g2_xor2_1 _2434_ (.B(_1021_),
    .A(_0993_),
    .X(_1511_));
 sg13g2_nand2b_1 _2435_ (.Y(_1512_),
    .B(_0993_),
    .A_N(_1060_));
 sg13g2_nand3b_1 _2436_ (.B(net65),
    .C(_1512_),
    .Y(_1513_),
    .A_N(_1061_));
 sg13g2_a21oi_1 _2437_ (.A1(net132),
    .A2(\pll_dig.dlf.INT[8] ),
    .Y(_1514_),
    .B1(net109));
 sg13g2_a22oi_1 _2438_ (.Y(\pll_dig.dlf.OUT_C[8] ),
    .B1(_1513_),
    .B2(_1514_),
    .A2(_1511_),
    .A1(net62));
 sg13g2_nor2_1 _2439_ (.A(net155),
    .B(_0556_),
    .Y(_0557_));
 sg13g2_xnor2_1 _2440_ (.Y(_1515_),
    .A(_1012_),
    .B(_1056_));
 sg13g2_a221oi_1 _2441_ (.B2(_1515_),
    .C1(net109),
    .B1(net64),
    .A1(\pll_dig.dlf.INT[5] ),
    .Y(_1516_),
    .A2(net132));
 sg13g2_xnor2_1 _2442_ (.Y(_1517_),
    .A(_1009_),
    .B(_1012_));
 sg13g2_a21oi_1 _2443_ (.A1(net61),
    .A2(_1517_),
    .Y(\pll_dig.dlf.OUT_C[5] ),
    .B1(_1516_));
 sg13g2_o21ai_1 _2444_ (.B1(net96),
    .Y(\pll_dig.FINE_MUX_D[17] ),
    .A1(net98),
    .A2(_1233_));
 sg13g2_nor2_1 _2445_ (.A(net120),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .Y(_1518_));
 sg13g2_a21oi_1 _2446_ (.A1(net119),
    .A2(_0685_),
    .Y(_0318_),
    .B1(_1518_));
 sg13g2_and3_1 _2447_ (.X(net56),
    .A(\pll_dig.u_ddr_ck.ck_en ),
    .B(clknet_1_1__leaf_net60),
    .C(net58));
 sg13g2_and2_1 _2448_ (.A(net108),
    .B(_1042_),
    .X(\pll_dig.dlf.ILL_P_C ));
 sg13g2_xnor2_1 _2449_ (.Y(_1519_),
    .A(_0987_),
    .B(_1039_));
 sg13g2_nand2b_2 _2450_ (.Y(_0558_),
    .B(_0133_),
    .A_N(net157));
 sg13g2_xnor2_1 _2451_ (.Y(_1520_),
    .A(_0986_),
    .B(_1068_));
 sg13g2_a21oi_1 _2452_ (.A1(net65),
    .A2(_1520_),
    .Y(_1521_),
    .B1(net108));
 sg13g2_a21o_1 _2453_ (.A2(_1519_),
    .A1(net62),
    .B1(_1521_),
    .X(_1522_));
 sg13g2_o21ai_1 _2454_ (.B1(_1522_),
    .Y(\pll_dig.dlf.OUT_C[14] ),
    .A1(_0496_),
    .A2(\SS_BBPD[0] ));
 sg13g2_nand3_1 _2455_ (.B(_0990_),
    .C(_1032_),
    .A(_0989_),
    .Y(_1523_));
 sg13g2_nand2b_1 _2456_ (.Y(_1524_),
    .B(_1523_),
    .A_N(_1033_));
 sg13g2_nand3_1 _2457_ (.B(_1047_),
    .C(_1065_),
    .A(_0988_),
    .Y(_1525_));
 sg13g2_nand3b_1 _2458_ (.B(net65),
    .C(_1525_),
    .Y(_1526_),
    .A_N(_1066_));
 sg13g2_a21oi_1 _2459_ (.A1(\pll_dig.dlf.INT[12] ),
    .A2(net133),
    .Y(_1527_),
    .B1(net108));
 sg13g2_a22oi_1 _2460_ (.Y(\pll_dig.dlf.OUT_C[12] ),
    .B1(_1526_),
    .B2(_1527_),
    .A2(_1524_),
    .A1(net62));
 sg13g2_nor2b_1 _2461_ (.A(net157),
    .B_N(\pll_dig.div.ncnt[0] ),
    .Y(_0559_));
 sg13g2_nor2b_1 _2462_ (.A(\pll_dig.clr_r2 ),
    .B_N(\pll_dig.clr_r3 ),
    .Y(_1528_));
 sg13g2_o21ai_1 _2463_ (.B1(\pll_dig.ref_fail ),
    .Y(_1529_),
    .A1(_0509_),
    .A2(\pll_dig.clr_r3 ));
 sg13g2_o21ai_1 _2464_ (.B1(_0527_),
    .Y(_0317_),
    .A1(_1528_),
    .A2(_1529_));
 sg13g2_a221oi_1 _2465_ (.B2(_0450_),
    .C1(_0895_),
    .B1(_0899_),
    .A1(_0523_),
    .Y(_0316_),
    .A2(_0896_));
 sg13g2_mux2_1 _2466_ (.A0(_0133_),
    .A1(_0128_),
    .S(net84),
    .X(_0314_));
 sg13g2_mux2_1 _2467_ (.A0(net154),
    .A1(\pll_dig.div.div_pend[3] ),
    .S(net350),
    .X(_0313_));
 sg13g2_mux2_1 _2468_ (.A0(net151),
    .A1(\pll_dig.div.div_pend[5] ),
    .S(net357),
    .X(_0312_));
 sg13g2_mux2_1 _2469_ (.A0(net149),
    .A1(\pll_dig.div.div_pend[7] ),
    .S(net357),
    .X(_0311_));
 sg13g2_a21oi_1 _2470_ (.A1(net98),
    .A2(_1271_),
    .Y(\pll_dig.FINE_MUX_D[8] ),
    .B1(net99));
 sg13g2_a21oi_1 _2471_ (.A1(\SS_BBPD[0] ),
    .A2(net30),
    .Y(_1530_),
    .B1(_0443_));
 sg13g2_nor3_1 _2472_ (.A(net413),
    .B(_0133_),
    .C(_0559_),
    .Y(_0560_));
 sg13g2_nor3_1 _2473_ (.A(_1049_),
    .B(\pll_dig.dlf.ILL_P_C ),
    .C(_1530_),
    .Y(_1531_));
 sg13g2_nor2_1 _2474_ (.A(_1046_),
    .B(_1072_),
    .Y(\pll_dig.dlf.ILL_N_C ));
 sg13g2_nor2_1 _2475_ (.A(\pll_dig.dlf.INT[0] ),
    .B(\SS_BBPD[0] ),
    .Y(_1532_));
 sg13g2_nor3_1 _2476_ (.A(_1531_),
    .B(\pll_dig.dlf.ILL_N_C ),
    .C(_1532_),
    .Y(\pll_dig.dlf.OUT_C[0] ));
 sg13g2_xnor2_1 _2477_ (.Y(_1533_),
    .A(_1005_),
    .B(_1053_));
 sg13g2_nand2_1 _2478_ (.Y(_1534_),
    .A(net64),
    .B(_1533_));
 sg13g2_o21ai_1 _2479_ (.B1(_1046_),
    .Y(_1535_),
    .A1(\pll_dig.dlf.INT[3] ),
    .A2(\SS_BBPD[0] ));
 sg13g2_xnor2_1 _2480_ (.Y(_1536_),
    .A(_1002_),
    .B(_1005_));
 sg13g2_a22oi_1 _2481_ (.Y(\pll_dig.dlf.OUT_C[3] ),
    .B1(_1536_),
    .B2(net61),
    .A2(_1535_),
    .A1(_1534_));
 sg13g2_nor2_1 _2482_ (.A(\pll_dig.flock.cnt_done[7] ),
    .B(\pll_dig.flock.cnt_done[6] ),
    .Y(_1537_));
 sg13g2_o21ai_1 _2483_ (.B1(net319),
    .Y(_0561_),
    .A1(_0549_),
    .A2(_0560_));
 sg13g2_nand2_1 _2484_ (.Y(_1538_),
    .A(_0444_),
    .B(\pll_dig.FREQ_LOCKED ));
 sg13g2_o21ai_1 _2485_ (.B1(_1538_),
    .Y(_0012_),
    .A1(_1079_),
    .A2(_1537_));
 sg13g2_nand2_1 _2486_ (.Y(\pll_dig.FINE_MUX_D[4] ),
    .A(net100),
    .B(_1239_));
 sg13g2_nand2_1 _2487_ (.Y(\pll_dig.FINE_MUX_D[2] ),
    .A(net100),
    .B(_1237_));
 sg13g2_nand2_1 _2488_ (.Y(\pll_dig.FINE_MUX_D[1] ),
    .A(net100),
    .B(_1233_));
 sg13g2_xor2_1 _2489_ (.B(_1360_),
    .A(\pll_dig.div_rst_cnt[0] ),
    .X(_0309_));
 sg13g2_nand3_1 _2490_ (.B(\pll_dig.div_rst_cnt[1] ),
    .C(_1360_),
    .A(\pll_dig.div_rst_cnt[0] ),
    .Y(_1539_));
 sg13g2_a21o_1 _2491_ (.A2(_1360_),
    .A1(\pll_dig.div_rst_cnt[0] ),
    .B1(\pll_dig.div_rst_cnt[1] ),
    .X(_1540_));
 sg13g2_and2_1 _2492_ (.A(_1539_),
    .B(_1540_),
    .X(_0308_));
 sg13g2_xnor2_1 _2493_ (.Y(_0307_),
    .A(\pll_dig.div_rst_cnt[2] ),
    .B(_1539_));
 sg13g2_xnor2_1 _2494_ (.Y(_0562_),
    .A(_2059_),
    .B(_0550_));
 sg13g2_o21ai_1 _2495_ (.B1(_0538_),
    .Y(_0306_),
    .A1(net144),
    .A2(_1358_));
 sg13g2_nand2_1 _2496_ (.Y(_1541_),
    .A(\pll_dig.flock.cnt_done[0] ),
    .B(_1081_));
 sg13g2_o21ai_1 _2497_ (.B1(_1541_),
    .Y(_0021_),
    .A1(\pll_dig.flock.cnt_done[0] ),
    .A2(_1309_));
 sg13g2_mux2_1 _2498_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .A1(_1126_),
    .S(net117),
    .X(_0305_));
 sg13g2_a21oi_1 _2499_ (.A1(_0819_),
    .A2(_0851_),
    .Y(_1542_),
    .B1(\pll_dig.COARSE_MUX_D[0] ));
 sg13g2_nand2_1 _2500_ (.Y(_1543_),
    .A(\pll_dig.COARSE_MUX_D[0] ),
    .B(\pll_dig.COARSE_MUX_D[1] ));
 sg13g2_a21oi_1 _2501_ (.A1(_0827_),
    .A2(_1543_),
    .Y(_0304_),
    .B1(_1542_));
 sg13g2_nand3_1 _2502_ (.B(_0848_),
    .C(_0850_),
    .A(\pll_dig.COARSE_MUX_D[13] ),
    .Y(_1544_));
 sg13g2_a21oi_1 _2503_ (.A1(_0482_),
    .A2(_1544_),
    .Y(_0303_),
    .B1(net81));
 sg13g2_and2_1 _2504_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[10] ),
    .X(_1545_));
 sg13g2_a22oi_1 _2505_ (.Y(_0563_),
    .B1(_0562_),
    .B2(net154),
    .A2(_0556_),
    .A1(net155));
 sg13g2_xor2_1 _2506_ (.B(\pll_dig.flock.cnt_filt[10] ),
    .A(\pll_dig.flock.cnt_filt[9] ),
    .X(_1546_));
 sg13g2_a21oi_1 _2507_ (.A1(net464),
    .A2(_1546_),
    .Y(_1547_),
    .B1(_1545_));
 sg13g2_and2_1 _2508_ (.A(\pll_dig.flock.cnt_filt[11] ),
    .B(\pll_dig.flock.cnt_filt[10] ),
    .X(_1548_));
 sg13g2_xor2_1 _2509_ (.B(\pll_dig.flock.cnt_filt[10] ),
    .A(\pll_dig.flock.cnt_filt[11] ),
    .X(_1549_));
 sg13g2_xnor2_1 _2510_ (.Y(_1550_),
    .A(net485),
    .B(_1549_));
 sg13g2_nor2_1 _2511_ (.A(net465),
    .B(_1550_),
    .Y(_1551_));
 sg13g2_and2_1 _2512_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .X(_1552_));
 sg13g2_nor2_1 _2513_ (.A(_0791_),
    .B(_1552_),
    .Y(_1553_));
 sg13g2_a21oi_1 _2514_ (.A1(net472),
    .A2(_1553_),
    .Y(_1554_),
    .B1(_1552_));
 sg13g2_xnor2_1 _2515_ (.Y(_1555_),
    .A(net464),
    .B(_1546_));
 sg13g2_o21ai_1 _2516_ (.B1(_0563_),
    .Y(_0564_),
    .A1(_0561_),
    .A2(_0557_));
 sg13g2_nor2_1 _2517_ (.A(net473),
    .B(_1555_),
    .Y(_1556_));
 sg13g2_nor2_1 _2518_ (.A(_0514_),
    .B(_0515_),
    .Y(_1557_));
 sg13g2_nor2_1 _2519_ (.A(_1104_),
    .B(_1557_),
    .Y(_1558_));
 sg13g2_a21oi_1 _2520_ (.A1(net476),
    .A2(_1558_),
    .Y(_1559_),
    .B1(_1557_));
 sg13g2_xnor2_1 _2521_ (.Y(_1560_),
    .A(net472),
    .B(_1553_));
 sg13g2_nor2_1 _2522_ (.A(net477),
    .B(_1560_),
    .Y(_1561_));
 sg13g2_nor2_1 _2523_ (.A(_0514_),
    .B(_0518_),
    .Y(_1562_));
 sg13g2_xor2_1 _2524_ (.B(\pll_dig.flock.cnt_filt[6] ),
    .A(\pll_dig.flock.cnt_filt[7] ),
    .X(_1563_));
 sg13g2_a21oi_1 _2525_ (.A1(net468),
    .A2(_1563_),
    .Y(_1564_),
    .B1(_1562_));
 sg13g2_xnor2_1 _2526_ (.Y(_1565_),
    .A(net476),
    .B(_1558_));
 sg13g2_inv_1 _2527_ (.Y(_0447_),
    .A(\pll_dig.flock.cnt_cap[7] ));
 sg13g2_nor2_1 _2528_ (.A(net154),
    .B(_0562_),
    .Y(_0565_));
 sg13g2_nor2_1 _2529_ (.A(net469),
    .B(_1565_),
    .Y(_1566_));
 sg13g2_nor2_1 _2530_ (.A(_0518_),
    .B(_0537_),
    .Y(_1567_));
 sg13g2_xor2_1 _2531_ (.B(\pll_dig.flock.cnt_filt[5] ),
    .A(\pll_dig.flock.cnt_filt[6] ),
    .X(_1568_));
 sg13g2_a21oi_1 _2532_ (.A1(net495),
    .A2(_1568_),
    .Y(_1569_),
    .B1(_1567_));
 sg13g2_xnor2_1 _2533_ (.Y(_1570_),
    .A(net468),
    .B(_1563_));
 sg13g2_nor2_1 _2534_ (.A(_0495_),
    .B(_0537_),
    .Y(_1571_));
 sg13g2_xor2_1 _2535_ (.B(\pll_dig.flock.cnt_filt[5] ),
    .A(\pll_dig.flock.cnt_filt[4] ),
    .X(_1572_));
 sg13g2_a21oi_1 _2536_ (.A1(net522),
    .A2(_1572_),
    .Y(_1573_),
    .B1(_1571_));
 sg13g2_xnor2_1 _2537_ (.Y(_1574_),
    .A(net495),
    .B(_1568_));
 sg13g2_nor2_1 _2538_ (.A(net523),
    .B(_1574_),
    .Y(_1575_));
 sg13g2_nor2_1 _2539_ (.A(net152),
    .B(_0555_),
    .Y(_0566_));
 sg13g2_xor2_1 _2540_ (.B(_1574_),
    .A(net523),
    .X(_1576_));
 sg13g2_nand2_1 _2541_ (.Y(_1577_),
    .A(\pll_dig.flock.cnt_filt[4] ),
    .B(net146));
 sg13g2_xor2_1 _2542_ (.B(net146),
    .A(\pll_dig.flock.cnt_filt[4] ),
    .X(_1578_));
 sg13g2_nand2_1 _2543_ (.Y(_1579_),
    .A(net517),
    .B(_1578_));
 sg13g2_xnor2_1 _2544_ (.Y(_1580_),
    .A(net522),
    .B(_1572_));
 sg13g2_nand3_1 _2545_ (.B(net518),
    .C(_1580_),
    .A(_1577_),
    .Y(_1581_));
 sg13g2_a21o_1 _2546_ (.A2(net518),
    .A1(_1577_),
    .B1(_1580_),
    .X(_1582_));
 sg13g2_xnor2_1 _2547_ (.Y(_1583_),
    .A(net517),
    .B(_1578_));
 sg13g2_a21oi_1 _2548_ (.A1(_1251_),
    .A2(_1253_),
    .Y(_1584_),
    .B1(_1583_));
 sg13g2_nand3_1 _2549_ (.B(_1253_),
    .C(_1583_),
    .A(_1251_),
    .Y(_1585_));
 sg13g2_nor2_1 _2550_ (.A(_0565_),
    .B(_0566_),
    .Y(_0567_));
 sg13g2_nor2b_1 _2551_ (.A(_1584_),
    .B_N(net553),
    .Y(_1586_));
 sg13g2_inv_1 _2552_ (.Y(_1587_),
    .A(_1586_));
 sg13g2_a21oi_1 _2553_ (.A1(_1250_),
    .A2(_1256_),
    .Y(_1588_),
    .B1(net510));
 sg13g2_nor2_1 _2554_ (.A(_1587_),
    .B(net511),
    .Y(_1589_));
 sg13g2_nor2_1 _2555_ (.A(_1584_),
    .B(_1589_),
    .Y(_1590_));
 sg13g2_o21ai_1 _2556_ (.B1(net519),
    .Y(_1591_),
    .A1(_1584_),
    .A2(_1589_));
 sg13g2_nand2_1 _2557_ (.Y(_1592_),
    .A(_1582_),
    .B(_1591_));
 sg13g2_a21oi_1 _2558_ (.A1(net524),
    .A2(_1592_),
    .Y(_1593_),
    .B1(_1575_));
 sg13g2_xor2_1 _2559_ (.B(_1570_),
    .A(net496),
    .X(_1594_));
 sg13g2_nand2b_1 _2560_ (.Y(_1595_),
    .B(net497),
    .A_N(_1593_));
 sg13g2_a22oi_1 _2561_ (.Y(_0568_),
    .B1(_0567_),
    .B2(_0564_),
    .A2(_0555_),
    .A1(net152));
 sg13g2_o21ai_1 _2562_ (.B1(_1595_),
    .Y(_1596_),
    .A1(net496),
    .A2(_1570_));
 sg13g2_xor2_1 _2563_ (.B(_1565_),
    .A(net469),
    .X(_1597_));
 sg13g2_a21oi_1 _2564_ (.A1(_1596_),
    .A2(net470),
    .Y(_1598_),
    .B1(_1566_));
 sg13g2_inv_1 _2565_ (.Y(_1599_),
    .A(_1598_));
 sg13g2_xor2_1 _2566_ (.B(_1560_),
    .A(net477),
    .X(_1600_));
 sg13g2_a21oi_1 _2567_ (.A1(_1599_),
    .A2(net478),
    .Y(_1601_),
    .B1(_1561_));
 sg13g2_inv_1 _2568_ (.Y(_1602_),
    .A(_1601_));
 sg13g2_xor2_1 _2569_ (.B(_1555_),
    .A(net473),
    .X(_1603_));
 sg13g2_a21oi_1 _2570_ (.A1(_1602_),
    .A2(net474),
    .Y(_1604_),
    .B1(_1556_));
 sg13g2_inv_1 _2571_ (.Y(_1605_),
    .A(_1604_));
 sg13g2_a21o_1 _2572_ (.A2(_0551_),
    .A1(\pll_dig.div.ncnt[4] ),
    .B1(\pll_dig.div.ncnt[5] ),
    .X(_0569_));
 sg13g2_xor2_1 _2573_ (.B(_1550_),
    .A(net465),
    .X(_1606_));
 sg13g2_a21oi_1 _2574_ (.A1(_1605_),
    .A2(net466),
    .Y(_1607_),
    .B1(_1551_));
 sg13g2_a21oi_1 _2575_ (.A1(net485),
    .A2(_0787_),
    .Y(_1608_),
    .B1(_1548_));
 sg13g2_nand2_1 _2576_ (.Y(_1609_),
    .A(\pll_dig.flock.cnt_filt[12] ),
    .B(\pll_dig.flock.cnt_filt[11] ));
 sg13g2_xor2_1 _2577_ (.B(\pll_dig.flock.cnt_filt[11] ),
    .A(\pll_dig.flock.cnt_filt[12] ),
    .X(_1610_));
 sg13g2_nand2_1 _2578_ (.Y(_1611_),
    .A(net480),
    .B(_1610_));
 sg13g2_xnor2_1 _2579_ (.Y(_1612_),
    .A(net480),
    .B(_1610_));
 sg13g2_xor2_1 _2580_ (.B(_1612_),
    .A(net486),
    .X(_1613_));
 sg13g2_nand2b_1 _2581_ (.Y(_1614_),
    .B(net487),
    .A_N(_1607_));
 sg13g2_xnor2_1 _2582_ (.Y(_0140_),
    .A(net543),
    .B(net487));
 sg13g2_nand2_1 _2583_ (.Y(_0570_),
    .A(_0552_),
    .B(_0569_));
 sg13g2_xnor2_1 _2584_ (.Y(_0147_),
    .A(net554),
    .B(net511));
 sg13g2_o21ai_1 _2585_ (.B1(\pll_dig.flock.cnt_filt[15] ),
    .Y(_1615_),
    .A1(net461),
    .A2(\pll_dig.flock.cnt_filt[14] ));
 sg13g2_xor2_1 _2586_ (.B(\pll_dig.flock.cnt_filt[15] ),
    .A(\pll_dig.flock.cnt_filt[14] ),
    .X(_1616_));
 sg13g2_and2_1 _2587_ (.A(net461),
    .B(_1616_),
    .X(_1617_));
 sg13g2_o21ai_1 _2588_ (.B1(net462),
    .Y(_1618_),
    .A1(\pll_dig.flock.cnt_filt[15] ),
    .A2(_1617_));
 sg13g2_nand2_1 _2589_ (.Y(_1619_),
    .A(\pll_dig.flock.cnt_filt[14] ),
    .B(\pll_dig.flock.cnt_filt[13] ));
 sg13g2_xor2_1 _2590_ (.B(\pll_dig.flock.cnt_filt[13] ),
    .A(\pll_dig.flock.cnt_filt[14] ),
    .X(_1620_));
 sg13g2_nand2_1 _2591_ (.Y(_1621_),
    .A(net489),
    .B(_1620_));
 sg13g2_xnor2_1 _2592_ (.Y(_1622_),
    .A(net461),
    .B(_1616_));
 sg13g2_a21oi_1 _2593_ (.A1(_1619_),
    .A2(net490),
    .Y(_1623_),
    .B1(_1622_));
 sg13g2_nor2_1 _2594_ (.A(net151),
    .B(_0570_),
    .Y(_0571_));
 sg13g2_and3_1 _2595_ (.X(_1624_),
    .A(_1619_),
    .B(net490),
    .C(_1622_));
 sg13g2_and2_1 _2596_ (.A(\pll_dig.flock.cnt_filt[13] ),
    .B(\pll_dig.flock.cnt_filt[12] ),
    .X(_1625_));
 sg13g2_xor2_1 _2597_ (.B(\pll_dig.flock.cnt_filt[12] ),
    .A(\pll_dig.flock.cnt_filt[13] ),
    .X(_1626_));
 sg13g2_a21oi_1 _2598_ (.A1(net499),
    .A2(_0788_),
    .Y(_1627_),
    .B1(_1625_));
 sg13g2_xnor2_1 _2599_ (.Y(_1628_),
    .A(net504),
    .B(_1620_));
 sg13g2_nor2_1 _2600_ (.A(net500),
    .B(_1628_),
    .Y(_1629_));
 sg13g2_xor2_1 _2601_ (.B(_1628_),
    .A(net500),
    .X(_1630_));
 sg13g2_xnor2_1 _2602_ (.Y(_1631_),
    .A(net499),
    .B(_1626_));
 sg13g2_and3_1 _2603_ (.X(_1632_),
    .A(_1609_),
    .B(net481),
    .C(_1631_));
 sg13g2_a21oi_1 _2604_ (.A1(_1609_),
    .A2(net481),
    .Y(_1633_),
    .B1(_1631_));
 sg13g2_xor2_1 _2605_ (.B(_0552_),
    .A(\pll_dig.div.ncnt[6] ),
    .X(_0572_));
 sg13g2_o21ai_1 _2606_ (.B1(_1614_),
    .Y(_1634_),
    .A1(net486),
    .A2(_1612_));
 sg13g2_nor2_1 _2607_ (.A(net482),
    .B(_1634_),
    .Y(_1635_));
 sg13g2_or2_1 _2608_ (.X(_1636_),
    .B(_1635_),
    .A(_1632_));
 sg13g2_inv_1 _2609_ (.Y(_1637_),
    .A(_1636_));
 sg13g2_a21oi_1 _2610_ (.A1(net501),
    .A2(_1637_),
    .Y(_1638_),
    .B1(net505));
 sg13g2_nor2b_1 _2611_ (.A(net491),
    .B_N(_1638_),
    .Y(_1639_));
 sg13g2_nor2_1 _2612_ (.A(_1624_),
    .B(net492),
    .Y(_1640_));
 sg13g2_inv_1 _2613_ (.Y(_1641_),
    .A(net493));
 sg13g2_o21ai_1 _2614_ (.B1(net462),
    .Y(_0137_),
    .A1(_1618_),
    .A2(_1641_));
 sg13g2_xnor2_1 _2615_ (.Y(_0142_),
    .A(net501),
    .B(_1636_));
 sg13g2_a22oi_1 _2616_ (.Y(_0573_),
    .B1(_0572_),
    .B2(net150),
    .A2(_0570_),
    .A1(net151));
 sg13g2_nor2_1 _2617_ (.A(net115),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .Y(_1642_));
 sg13g2_a21oi_1 _2618_ (.A1(net115),
    .A2(_0697_),
    .Y(_0302_),
    .B1(_1642_));
 sg13g2_nor2_1 _2619_ (.A(net112),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[2] ),
    .Y(_1643_));
 sg13g2_a21oi_1 _2620_ (.A1(net112),
    .A2(_0656_),
    .Y(_0301_),
    .B1(_1643_));
 sg13g2_a21o_1 _2621_ (.A2(net5),
    .A1(net6),
    .B1(net7),
    .X(_1644_));
 sg13g2_and2_1 _2622_ (.A(_0612_),
    .B(_1644_),
    .X(_0099_));
 sg13g2_xnor2_1 _2623_ (.Y(_1645_),
    .A(net317),
    .B(_0740_));
 sg13g2_nor2_1 _2624_ (.A(net119),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .Y(_1646_));
 sg13g2_a21oi_1 _2625_ (.A1(net119),
    .A2(_1645_),
    .Y(_0300_),
    .B1(_1646_));
 sg13g2_nand2_1 _2626_ (.Y(_1647_),
    .A(net122),
    .B(net288));
 sg13g2_o21ai_1 _2627_ (.B1(_0573_),
    .Y(_0574_),
    .A1(_0571_),
    .A2(_0568_));
 sg13g2_o21ai_1 _2628_ (.B1(_1647_),
    .Y(_0299_),
    .A1(net122),
    .A2(_0541_));
 sg13g2_nor2_1 _2629_ (.A(\pll_dig.ILL_N ),
    .B(\pll_dig.ILL_P ),
    .Y(_1648_));
 sg13g2_nand2_1 _2630_ (.Y(_1649_),
    .A(\SS_BBPD[0] ),
    .B(_1648_));
 sg13g2_nor2_1 _2631_ (.A(\SS_BBPD[1] ),
    .B(_1649_),
    .Y(_1650_));
 sg13g2_nor2_1 _2632_ (.A(\pll_dig.lock_detector.seen_p ),
    .B(_1650_),
    .Y(_1651_));
 sg13g2_nand2_1 _2633_ (.Y(_1652_),
    .A(\pll_dig.ENABLE ),
    .B(\SS_BBPD[0] ));
 sg13g2_or4_1 _2634_ (.A(\pll_dig.ILL_N ),
    .B(\pll_dig.ILL_P ),
    .C(\pll_dig.lock_detector.win_cnt[4] ),
    .D(net107),
    .X(_1653_));
 sg13g2_and3_1 _2635_ (.X(_1654_),
    .A(\pll_dig.lock_detector.win_cnt[1] ),
    .B(\pll_dig.lock_detector.win_cnt[0] ),
    .C(\pll_dig.lock_detector.win_cnt[2] ));
 sg13g2_a21o_1 _2636_ (.A2(_1654_),
    .A1(\pll_dig.lock_detector.win_cnt[3] ),
    .B1(_1653_),
    .X(_1655_));
 sg13g2_nor2_1 _2637_ (.A(_1651_),
    .B(_1655_),
    .Y(_0057_));
 sg13g2_inv_1 _2638_ (.Y(_0448_),
    .A(\pll_dig.out_edges[7] ));
 sg13g2_nor2_1 _2639_ (.A(net152),
    .B(net154),
    .Y(_0575_));
 sg13g2_nor2_1 _2640_ (.A(_1632_),
    .B(net482),
    .Y(_1656_));
 sg13g2_xor2_1 _2641_ (.B(net483),
    .A(_1634_),
    .X(_0141_));
 sg13g2_a21o_1 _2642_ (.A2(net30),
    .A1(\pll_dig.dlf.INT[0] ),
    .B1(_0999_),
    .X(_1657_));
 sg13g2_nand2_1 _2643_ (.Y(_1658_),
    .A(_1000_),
    .B(_1657_));
 sg13g2_nand2_1 _2644_ (.Y(_1659_),
    .A(_0999_),
    .B(_1049_));
 sg13g2_nand3b_1 _2645_ (.B(net64),
    .C(_1659_),
    .Y(_1660_),
    .A_N(_1050_));
 sg13g2_a21oi_1 _2646_ (.A1(\pll_dig.dlf.INT[1] ),
    .A2(net132),
    .Y(_1661_),
    .B1(net108));
 sg13g2_a22oi_1 _2647_ (.Y(\pll_dig.dlf.OUT_C[1] ),
    .B1(_1660_),
    .B2(_1661_),
    .A2(_1658_),
    .A1(net61));
 sg13g2_xnor2_1 _2648_ (.Y(_0144_),
    .A(_1618_),
    .B(net493));
 sg13g2_o21ai_1 _2649_ (.B1(net127),
    .Y(_1662_),
    .A1(net417),
    .A2(net416));
 sg13g2_nor4_1 _2650_ (.A(net150),
    .B(net149),
    .C(net155),
    .D(net151),
    .Y(_0576_));
 sg13g2_a21oi_1 _2651_ (.A1(net417),
    .A2(net416),
    .Y(_1663_),
    .B1(_1662_));
 sg13g2_a21oi_1 _2652_ (.A1(\pll_dig.flock.cnt_gray[1] ),
    .A2(net125),
    .Y(_1664_),
    .B1(_1338_));
 sg13g2_nand2b_1 _2653_ (.Y(_1665_),
    .B(_0965_),
    .A_N(_1662_));
 sg13g2_o21ai_1 _2654_ (.B1(_1665_),
    .Y(_0298_),
    .A1(_1663_),
    .A2(_1664_));
 sg13g2_xnor2_1 _2655_ (.Y(_1666_),
    .A(_0483_),
    .B(_0964_));
 sg13g2_nor2_1 _2656_ (.A(\pll_dig.flock.cnt_gray[9] ),
    .B(net130),
    .Y(_1667_));
 sg13g2_a21oi_1 _2657_ (.A1(net130),
    .A2(_1666_),
    .Y(_0297_),
    .B1(_1667_));
 sg13g2_nor2_1 _2658_ (.A(\pll_dig.ref_wd.cnt[7] ),
    .B(_1232_),
    .Y(_1668_));
 sg13g2_nor3_1 _2659_ (.A(_0972_),
    .B(_0980_),
    .C(_1668_),
    .Y(_0296_));
 sg13g2_nand2_1 _2660_ (.Y(_1669_),
    .A(net519),
    .B(_1582_));
 sg13g2_nand3_1 _2661_ (.B(_0576_),
    .C(_0575_),
    .A(_0133_),
    .Y(_0577_));
 sg13g2_xor2_1 _2662_ (.B(net520),
    .A(_1590_),
    .X(_0148_));
 sg13g2_nand2b_1 _2663_ (.Y(_1670_),
    .B(\pll_dig.PHASE_LOCK ),
    .A_N(\pll_dig.LOCK_LOST ));
 sg13g2_nor2b_1 _2664_ (.A(\pll_dig.fail_qq ),
    .B_N(\pll_dig.FREQ_OK ),
    .Y(_1671_));
 sg13g2_nand2_1 _2665_ (.Y(_1672_),
    .A(\pll_dig.state[4] ),
    .B(_1671_));
 sg13g2_nor2_1 _2666_ (.A(_1670_),
    .B(_1672_),
    .Y(_1673_));
 sg13g2_inv_1 _2667_ (.Y(_1674_),
    .A(_1673_));
 sg13g2_nand2b_1 _2668_ (.Y(_1675_),
    .B(_1671_),
    .A_N(\pll_dig.LOCK_LOST ));
 sg13g2_nand3b_1 _2669_ (.B(_1671_),
    .C(\pll_dig.state[2] ),
    .Y(_1676_),
    .A_N(\pll_dig.LOCK_LOST ));
 sg13g2_nor2b_1 _2670_ (.A(\pll_dig.cnt[5] ),
    .B_N(\pll_dig.cnt[6] ),
    .Y(_1677_));
 sg13g2_nor2_1 _2671_ (.A(\pll_dig.cnt[7] ),
    .B(\pll_dig.cnt[4] ),
    .Y(_1678_));
 sg13g2_nand2_1 _2672_ (.Y(_0578_),
    .A(net327),
    .B(_0577_));
 sg13g2_nor4_1 _2673_ (.A(\pll_dig.cnt[3] ),
    .B(\pll_dig.cnt[2] ),
    .C(\pll_dig.cnt[0] ),
    .D(\pll_dig.cnt[1] ),
    .Y(_1679_));
 sg13g2_nand4_1 _2674_ (.B(_1677_),
    .C(_1678_),
    .A(\pll_dig.PHASE_LOCK ),
    .Y(_1680_),
    .D(_1679_));
 sg13g2_o21ai_1 _2675_ (.B1(_1674_),
    .Y(_0051_),
    .A1(_1676_),
    .A2(_1680_));
 sg13g2_nand3_1 _2676_ (.B(\SS_BBPD[0] ),
    .C(_1648_),
    .A(\SS_BBPD[1] ),
    .Y(_1681_));
 sg13g2_nor2b_1 _2677_ (.A(\pll_dig.lock_detector.seen_n ),
    .B_N(_1681_),
    .Y(_1682_));
 sg13g2_nor2_1 _2678_ (.A(_1655_),
    .B(_1682_),
    .Y(_0056_));
 sg13g2_mux2_1 _2679_ (.A0(\pll_dig.div.div_pend[6] ),
    .A1(net54),
    .S(net237),
    .X(_0293_));
 sg13g2_mux2_1 _2680_ (.A0(\pll_dig.div.use_clk_p ),
    .A1(\pll_dig.div.use_clk ),
    .S(net134),
    .X(_0292_));
 sg13g2_nor2_1 _2681_ (.A(net117),
    .B(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .Y(_1683_));
 sg13g2_a21oi_1 _2682_ (.A1(net117),
    .A2(net406),
    .Y(_0288_),
    .B1(_1683_));
 sg13g2_nor2_1 _2683_ (.A(net150),
    .B(_0572_),
    .Y(_0579_));
 sg13g2_mux2_1 _2684_ (.A0(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .A1(net300),
    .S(net117),
    .X(_0286_));
 sg13g2_o21ai_1 _2685_ (.B1(net112),
    .Y(_1684_),
    .A1(_0661_),
    .A2(_0663_));
 sg13g2_a21o_1 _2686_ (.A2(_0663_),
    .A1(_0661_),
    .B1(_1684_),
    .X(_1685_));
 sg13g2_o21ai_1 _2687_ (.B1(_1685_),
    .Y(_0285_),
    .A1(net112),
    .A2(_0542_));
 sg13g2_nand2b_1 _2688_ (.Y(_1686_),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .A_N(net117));
 sg13g2_nand2_1 _2689_ (.Y(_1687_),
    .A(net117),
    .B(_1130_));
 sg13g2_o21ai_1 _2690_ (.B1(_1686_),
    .Y(_0284_),
    .A1(_1143_),
    .A2(_1687_));
 sg13g2_xnor2_1 _2691_ (.Y(_0283_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .B(_1326_));
 sg13g2_a21o_1 _2692_ (.A2(_0931_),
    .A1(\pll_dig.div.pend ),
    .B1(net237),
    .X(_0281_));
 sg13g2_nor2_1 _2693_ (.A(net118),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .Y(_1688_));
 sg13g2_o21ai_1 _2694_ (.B1(_0574_),
    .Y(_0580_),
    .A1(net149),
    .A2(_0554_));
 sg13g2_a21oi_2 _2695_ (.B1(_1688_),
    .Y(_0280_),
    .A2(net299),
    .A1(net118));
 sg13g2_nor2_1 _2696_ (.A(net117),
    .B(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .Y(_1689_));
 sg13g2_a21oi_1 _2697_ (.A1(net117),
    .A2(_1130_),
    .Y(_0278_),
    .B1(_1689_));
 sg13g2_nor2_2 _2698_ (.A(\pll_dig.div.enter_req ),
    .B(_0959_),
    .Y(_1690_));
 sg13g2_nor2_1 _2699_ (.A(\pll_dig.div.use_clk_p ),
    .B(_1690_),
    .Y(_0274_));
 sg13g2_mux2_1 _2700_ (.A0(\pll_dig.div.div_pend[7] ),
    .A1(net55),
    .S(net237),
    .X(_0271_));
 sg13g2_a21oi_1 _2701_ (.A1(\pll_dig.div.pend ),
    .A2(_0958_),
    .Y(_1691_),
    .B1(\pll_dig.div.leave_req ));
 sg13g2_nor2b_1 _2702_ (.A(_1691_),
    .B_N(\pll_dig.div.use_clk_p ),
    .Y(_0270_));
 sg13g2_a21oi_1 _2703_ (.A1(net529),
    .A2(_1109_),
    .Y(_1692_),
    .B1(\pll_dig.flock.cnt_done[2] ));
 sg13g2_o21ai_1 _2704_ (.B1(_1307_),
    .Y(_1693_),
    .A1(_1306_),
    .A2(_1692_));
 sg13g2_nor3_2 _2705_ (.A(_0578_),
    .B(_0580_),
    .C(_0579_),
    .Y(_0581_));
 sg13g2_nor2b_1 _2706_ (.A(_1309_),
    .B_N(_1304_),
    .Y(_1694_));
 sg13g2_a22oi_1 _2707_ (.Y(_1695_),
    .B1(_1693_),
    .B2(_1694_),
    .A2(_1081_),
    .A1(\pll_dig.flock.cnt_done[2] ));
 sg13g2_inv_1 _2708_ (.Y(_0023_),
    .A(_1695_));
 sg13g2_a21o_1 _2709_ (.A2(net125),
    .A1(net417),
    .B1(_1663_),
    .X(_0268_));
 sg13g2_a21o_1 _2710_ (.A2(_0962_),
    .A1(\pll_dig.flock.cnt[8] ),
    .B1(\pll_dig.flock.cnt[9] ),
    .X(_1696_));
 sg13g2_and2_1 _2711_ (.A(_0963_),
    .B(_1696_),
    .X(_0267_));
 sg13g2_nor2_1 _2712_ (.A(net491),
    .B(_1624_),
    .Y(_1697_));
 sg13g2_xnor2_1 _2713_ (.Y(_0143_),
    .A(net506),
    .B(_1697_));
 sg13g2_a21oi_1 _2714_ (.A1(\pll_dig.lock_detector.win_cnt[1] ),
    .A2(\pll_dig.lock_detector.win_cnt[0] ),
    .Y(_1698_),
    .B1(\pll_dig.lock_detector.win_cnt[2] ));
 sg13g2_nor3_1 _2715_ (.A(_1653_),
    .B(_1654_),
    .C(_1698_),
    .Y(_0060_));
 sg13g2_nor2b_1 _2716_ (.A(_0554_),
    .B_N(net362),
    .Y(_0044_));
 sg13g2_nor2_1 _2717_ (.A(\pll_dig.lock_detector.win_cnt[0] ),
    .B(_1653_),
    .Y(_0058_));
 sg13g2_nor2_1 _2718_ (.A(\pll_dig.START ),
    .B(\pll_dig.flock.u_fll_icg.EN ),
    .Y(_1699_));
 sg13g2_nand3b_1 _2719_ (.B(\pll_dig.state[3] ),
    .C(_1424_),
    .Y(_1700_),
    .A_N(_1699_));
 sg13g2_nor2b_1 _2720_ (.A(_0134_),
    .B_N(\pll_dig.cnt[3] ),
    .Y(_1701_));
 sg13g2_inv_1 _2721_ (.Y(_1702_),
    .A(_1701_));
 sg13g2_nor2_1 _2722_ (.A(\pll_dig.state[4] ),
    .B(\pll_dig.state[2] ),
    .Y(_1703_));
 sg13g2_o21ai_1 _2723_ (.B1(_1702_),
    .Y(_1704_),
    .A1(_1671_),
    .A2(_1703_));
 sg13g2_nand2b_1 _2724_ (.Y(_0050_),
    .B(_1700_),
    .A_N(_1704_));
 sg13g2_nor2_1 _2725_ (.A(\pll_dig.lock_detector.win_cnt[3] ),
    .B(_1654_),
    .Y(_1705_));
 sg13g2_nor2_1 _2726_ (.A(_1655_),
    .B(_1705_),
    .Y(_0061_));
 sg13g2_and2_1 _2727_ (.A(net149),
    .B(net327),
    .X(_0582_));
 sg13g2_xnor2_1 _2728_ (.Y(_1706_),
    .A(\pll_dig.lock_detector.win_cnt[1] ),
    .B(\pll_dig.lock_detector.win_cnt[0] ));
 sg13g2_nor2_1 _2729_ (.A(_1655_),
    .B(_1706_),
    .Y(_0059_));
 sg13g2_a221oi_1 _2730_ (.B2(\pll_dig.MID_MUX_D[8] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[10] ),
    .Y(_1707_),
    .A2(net92));
 sg13g2_nand2_1 _2731_ (.Y(_1708_),
    .A(\pll_dig.MID_MUX_D[9] ),
    .B(net77));
 sg13g2_o21ai_1 _2732_ (.B1(_1708_),
    .Y(_0266_),
    .A1(net77),
    .A2(_1707_));
 sg13g2_or2_1 _2733_ (.X(_0265_),
    .B(\pll_dig.flock.started ),
    .A(\pll_dig.START ));
 sg13g2_nor2b_1 _2734_ (.A(_1424_),
    .B_N(\pll_dig.flock.u_fll_icg.EN ),
    .Y(_1709_));
 sg13g2_a21o_1 _2735_ (.A2(_1709_),
    .A1(\pll_dig.state[3] ),
    .B1(\pll_dig.state[1] ),
    .X(_0048_));
 sg13g2_nand2b_1 _2736_ (.Y(_1710_),
    .B(\pll_dig.ENABLE ),
    .A_N(\pll_dig.lock_detector.bad_cnt[2] ));
 sg13g2_a221oi_1 _2737_ (.B2(\SS_BBPD[0] ),
    .C1(_1710_),
    .B1(_1648_),
    .A1(\pll_dig.lock_detector.bad_cnt[1] ),
    .Y(_1711_),
    .A2(\pll_dig.lock_detector.bad_cnt[0] ));
 sg13g2_a21oi_2 _2738_ (.B1(_0581_),
    .Y(_0583_),
    .A2(_0582_),
    .A1(_0554_));
 sg13g2_nor2b_1 _2739_ (.A(\pll_dig.lock_detector.bad_cnt[0] ),
    .B_N(_1711_),
    .Y(_0053_));
 sg13g2_o21ai_1 _2740_ (.B1(_1711_),
    .Y(_1712_),
    .A1(\pll_dig.lock_detector.bad_cnt[1] ),
    .A2(\pll_dig.lock_detector.bad_cnt[0] ));
 sg13g2_inv_1 _2741_ (.Y(_0054_),
    .A(_1712_));
 sg13g2_nor2b_1 _2742_ (.A(_1676_),
    .B_N(_1680_),
    .Y(_1713_));
 sg13g2_nand3_1 _2743_ (.B(_1670_),
    .C(_1671_),
    .A(\pll_dig.state[4] ),
    .Y(_1714_));
 sg13g2_and2_1 _2744_ (.A(\pll_dig.LOCK_LOST ),
    .B(_1671_),
    .X(_1715_));
 sg13g2_a22oi_1 _2745_ (.Y(_1716_),
    .B1(_1715_),
    .B2(\pll_dig.state[2] ),
    .A2(_1699_),
    .A1(\pll_dig.state[3] ));
 sg13g2_nand3b_1 _2746_ (.B(_1714_),
    .C(_1716_),
    .Y(_0049_),
    .A_N(_1713_));
 sg13g2_xnor2_1 _2747_ (.Y(_1717_),
    .A(_1019_),
    .B(_1059_));
 sg13g2_nand2_1 _2748_ (.Y(_1718_),
    .A(net64),
    .B(_1717_));
 sg13g2_inv_1 _2749_ (.Y(_0449_),
    .A(\pll_dig.out_edges[3] ));
 sg13g2_nor2_2 _2750_ (.A(_0583_),
    .B(_0572_),
    .Y(_0043_));
 sg13g2_o21ai_1 _2751_ (.B1(_1046_),
    .Y(_1719_),
    .A1(\pll_dig.dlf.INT[7] ),
    .A2(\SS_BBPD[0] ));
 sg13g2_xnor2_1 _2752_ (.Y(_1720_),
    .A(_1016_),
    .B(_1019_));
 sg13g2_a22oi_1 _2753_ (.Y(\pll_dig.dlf.OUT_C[7] ),
    .B1(_1720_),
    .B2(net61),
    .A2(_1719_),
    .A1(_1718_));
 sg13g2_xor2_1 _2754_ (.B(_1014_),
    .A(_0994_),
    .X(_1721_));
 sg13g2_nand2b_1 _2755_ (.Y(_1722_),
    .B(_0994_),
    .A_N(_1057_));
 sg13g2_nand3b_1 _2756_ (.B(net64),
    .C(_1722_),
    .Y(_1723_),
    .A_N(_1058_));
 sg13g2_a21oi_1 _2757_ (.A1(\pll_dig.dlf.INT[6] ),
    .A2(net132),
    .Y(_1724_),
    .B1(net109));
 sg13g2_a22oi_1 _2758_ (.Y(\pll_dig.dlf.OUT_C[6] ),
    .B1(_1723_),
    .B2(_1724_),
    .A2(_1721_),
    .A1(net61));
 sg13g2_xor2_1 _2759_ (.B(_1007_),
    .A(_0995_),
    .X(_1725_));
 sg13g2_nand2b_1 _2760_ (.Y(_1726_),
    .B(_0995_),
    .A_N(_1054_));
 sg13g2_nor2_2 _2761_ (.A(_0570_),
    .B(_0583_),
    .Y(_0042_));
 sg13g2_nand3b_1 _2762_ (.B(net64),
    .C(_1726_),
    .Y(_1727_),
    .A_N(_1055_));
 sg13g2_a21oi_1 _2763_ (.A1(\pll_dig.dlf.INT[4] ),
    .A2(net132),
    .Y(_1728_),
    .B1(net109));
 sg13g2_a22oi_1 _2764_ (.Y(\pll_dig.dlf.OUT_C[4] ),
    .B1(_1727_),
    .B2(_1728_),
    .A2(_1725_),
    .A1(net61));
 sg13g2_o21ai_1 _2765_ (.B1(net96),
    .Y(\pll_dig.FINE_MUX_D[18] ),
    .A1(net98),
    .A2(_1237_));
 sg13g2_nor2_1 _2766_ (.A(net121),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .Y(_1729_));
 sg13g2_a21oi_1 _2767_ (.A1(net121),
    .A2(_0718_),
    .Y(_0264_),
    .B1(_1729_));
 sg13g2_nor2_1 _2768_ (.A(net115),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .Y(_1730_));
 sg13g2_a21oi_1 _2769_ (.A1(net115),
    .A2(_0694_),
    .Y(_0263_),
    .B1(_1730_));
 sg13g2_nand2_1 _2770_ (.Y(_1731_),
    .A(net121),
    .B(_0721_));
 sg13g2_o21ai_1 _2771_ (.B1(_1731_),
    .Y(_0262_),
    .A1(net121),
    .A2(_0473_));
 sg13g2_nor2_2 _2772_ (.A(_0555_),
    .B(_0583_),
    .Y(_0041_));
 sg13g2_mux2_1 _2773_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .A1(_0652_),
    .S(net114),
    .X(_0261_));
 sg13g2_nand2b_1 _2774_ (.Y(_1732_),
    .B(_0743_),
    .A_N(net277));
 sg13g2_nand3_1 _2775_ (.B(_0744_),
    .C(_1732_),
    .A(net119),
    .Y(_1733_));
 sg13g2_o21ai_1 _2776_ (.B1(_1733_),
    .Y(_0260_),
    .A1(net120),
    .A2(_0476_));
 sg13g2_xnor2_1 _2777_ (.Y(_1734_),
    .A(_0745_),
    .B(_0746_));
 sg13g2_nor2_1 _2778_ (.A(net122),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .Y(_1735_));
 sg13g2_a21oi_1 _2779_ (.A1(net122),
    .A2(_1734_),
    .Y(_0259_),
    .B1(_1735_));
 sg13g2_mux2_1 _2780_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .A1(net278),
    .S(net121),
    .X(_0258_));
 sg13g2_xnor2_1 _2781_ (.Y(_0139_),
    .A(net547),
    .B(net466));
 sg13g2_xnor2_1 _2782_ (.Y(_1736_),
    .A(_1034_),
    .B(_1037_));
 sg13g2_nor2_2 _2783_ (.A(_0562_),
    .B(_0583_),
    .Y(_0040_));
 sg13g2_xnor2_1 _2784_ (.Y(_1737_),
    .A(_1037_),
    .B(_1067_));
 sg13g2_a21oi_1 _2785_ (.A1(net65),
    .A2(_1737_),
    .Y(_1738_),
    .B1(net108));
 sg13g2_a21o_1 _2786_ (.A2(_1736_),
    .A1(net62),
    .B1(_1738_),
    .X(_1739_));
 sg13g2_o21ai_1 _2787_ (.B1(_1739_),
    .Y(\pll_dig.dlf.OUT_C[13] ),
    .A1(_0465_),
    .A2(\SS_BBPD[0] ));
 sg13g2_xnor2_1 _2788_ (.Y(_1740_),
    .A(_1023_),
    .B(_1026_));
 sg13g2_xnor2_1 _2789_ (.Y(_1741_),
    .A(_1026_),
    .B(_1062_));
 sg13g2_a221oi_1 _2790_ (.B2(_1741_),
    .C1(net109),
    .B1(net65),
    .A1(net111),
    .Y(_1742_),
    .A2(net133));
 sg13g2_a21oi_1 _2791_ (.A1(net62),
    .A2(_1740_),
    .Y(\pll_dig.dlf.OUT_C[9] ),
    .B1(_1742_));
 sg13g2_xor2_1 _2792_ (.B(_1028_),
    .A(_0992_),
    .X(_1743_));
 sg13g2_nand2b_1 _2793_ (.Y(_1744_),
    .B(_0992_),
    .A_N(_1063_));
 sg13g2_nor2_2 _2794_ (.A(_0556_),
    .B(_0583_),
    .Y(_0039_));
 sg13g2_nand3b_1 _2795_ (.B(net65),
    .C(_1744_),
    .Y(_1745_),
    .A_N(_1064_));
 sg13g2_a21oi_1 _2796_ (.A1(\pll_dig.dlf.INT[10] ),
    .A2(net133),
    .Y(_1746_),
    .B1(net109));
 sg13g2_a22oi_1 _2797_ (.Y(\pll_dig.dlf.OUT_C[10] ),
    .B1(_1745_),
    .B2(_1746_),
    .A2(_1743_),
    .A1(net62));
 sg13g2_a21oi_1 _2798_ (.A1(\pll_dig.div.out_reg ),
    .A2(net337),
    .Y(_1747_),
    .B1(_0960_));
 sg13g2_xnor2_1 _2799_ (.Y(_0257_),
    .A(net70),
    .B(_1747_));
 sg13g2_nor2_1 _2800_ (.A(net237),
    .B(_0128_),
    .Y(_1748_));
 sg13g2_a21oi_1 _2801_ (.A1(net237),
    .A2(net49),
    .Y(_0253_),
    .B1(_1748_));
 sg13g2_mux2_1 _2802_ (.A0(\pll_dig.div.div_pend[5] ),
    .A1(net53),
    .S(net237),
    .X(_0252_));
 sg13g2_mux2_1 _2803_ (.A0(\pll_dig.div.div_pend[3] ),
    .A1(net51),
    .S(net238),
    .X(_0250_));
 sg13g2_mux2_1 _2804_ (.A0(\pll_dig.div.div_pend[4] ),
    .A1(net52),
    .S(net237),
    .X(_0249_));
 sg13g2_nor2_1 _2805_ (.A(net412),
    .B(net411),
    .Y(_0584_));
 sg13g2_nor3_1 _2806_ (.A(net55),
    .B(net53),
    .C(net52),
    .Y(_1749_));
 sg13g2_nor4_1 _2807_ (.A(net51),
    .B(net50),
    .C(net49),
    .D(net54),
    .Y(_1750_));
 sg13g2_nand2b_1 _2808_ (.Y(_1751_),
    .B(net238),
    .A_N(net48));
 sg13g2_a21oi_1 _2809_ (.A1(_1749_),
    .A2(_1750_),
    .Y(_1752_),
    .B1(_1751_));
 sg13g2_nor2_1 _2810_ (.A(\pll_dig.div.div_pend[0] ),
    .B(net238),
    .Y(_1753_));
 sg13g2_nor2_1 _2811_ (.A(_1752_),
    .B(_1753_),
    .Y(_0248_));
 sg13g2_mux2_1 _2812_ (.A0(\pll_dig.div.div_pend[2] ),
    .A1(net50),
    .S(net238),
    .X(_0247_));
 sg13g2_a21oi_1 _2813_ (.A1(net98),
    .A2(_1239_),
    .Y(\pll_dig.FINE_MUX_D[12] ),
    .B1(net99));
 sg13g2_xnor2_1 _2814_ (.Y(_0138_),
    .A(_1601_),
    .B(net474));
 sg13g2_nand2_1 _2815_ (.Y(_1754_),
    .A(\pll_dig.flock.cnt_done[5] ),
    .B(_1081_));
 sg13g2_nor3_2 _2816_ (.A(_0549_),
    .B(_0584_),
    .C(_0583_),
    .Y(_0038_));
 sg13g2_and2_1 _2817_ (.A(_0461_),
    .B(_1111_),
    .X(_1755_));
 sg13g2_o21ai_1 _2818_ (.B1(net95),
    .Y(_1756_),
    .A1(_1112_),
    .A2(_1755_));
 sg13g2_o21ai_1 _2819_ (.B1(\pll_dig.flock.cnt_done[5] ),
    .Y(_1757_),
    .A1(_1115_),
    .A2(_1116_));
 sg13g2_nand2b_1 _2820_ (.Y(_1758_),
    .B(_1117_),
    .A_N(_1537_));
 sg13g2_nand2_1 _2821_ (.Y(_1759_),
    .A(_1757_),
    .B(_1758_));
 sg13g2_o21ai_1 _2822_ (.B1(_1756_),
    .Y(_1760_),
    .A1(net95),
    .A2(_1759_));
 sg13g2_o21ai_1 _2823_ (.B1(_1754_),
    .Y(_0026_),
    .A1(_1079_),
    .A2(_1760_));
 sg13g2_xor2_1 _2824_ (.B(_1592_),
    .A(net524),
    .X(_0149_));
 sg13g2_xor2_1 _2825_ (.B(net470),
    .A(_1596_),
    .X(_0151_));
 sg13g2_xnor2_1 _2826_ (.Y(_0150_),
    .A(_1593_),
    .B(net497));
 sg13g2_nor3_2 _2827_ (.A(_0558_),
    .B(net154),
    .C(net156),
    .Y(_0585_));
 sg13g2_xnor2_1 _2828_ (.Y(_0152_),
    .A(_1598_),
    .B(net478));
 sg13g2_nor3_1 _2829_ (.A(_0520_),
    .B(_0130_),
    .C(_0052_),
    .Y(_0095_));
 sg13g2_nor2_1 _2830_ (.A(net352),
    .B(net70),
    .Y(_0078_));
 sg13g2_nor2_1 _2831_ (.A(_0911_),
    .B(net70),
    .Y(_0079_));
 sg13g2_nor2_1 _2832_ (.A(net342),
    .B(net371),
    .Y(_0080_));
 sg13g2_nor2_1 _2833_ (.A(net341),
    .B(net371),
    .Y(_0081_));
 sg13g2_nor2_1 _2834_ (.A(net333),
    .B(net70),
    .Y(_0082_));
 sg13g2_nor2_1 _2835_ (.A(net339),
    .B(net70),
    .Y(_0083_));
 sg13g2_nor2_1 _2836_ (.A(net332),
    .B(net70),
    .Y(_0084_));
 sg13g2_nor2_1 _2837_ (.A(net344),
    .B(net70),
    .Y(_0085_));
 sg13g2_nor2b_2 _2838_ (.A(net153),
    .B_N(_0585_),
    .Y(_0586_));
 sg13g2_nand2_1 _2839_ (.Y(_1761_),
    .A(\pll_dig.div.pcnt[0] ),
    .B(\pll_dig.div.pcnt[1] ));
 sg13g2_nand3_1 _2840_ (.B(\pll_dig.div.pcnt[0] ),
    .C(\pll_dig.div.pcnt[2] ),
    .A(\pll_dig.div.pcnt[1] ),
    .Y(_1762_));
 sg13g2_xor2_1 _2841_ (.B(_1761_),
    .A(\pll_dig.div.pcnt[2] ),
    .X(_1763_));
 sg13g2_nor2b_1 _2842_ (.A(net328),
    .B_N(\pll_dig.div.pcnt[0] ),
    .Y(_1764_));
 sg13g2_or2_1 _2843_ (.X(_1765_),
    .B(\pll_dig.div.pcnt[1] ),
    .A(_0133_));
 sg13g2_o21ai_1 _2844_ (.B1(_1761_),
    .Y(_1766_),
    .A1(_1764_),
    .A2(_1765_));
 sg13g2_a22oi_1 _2845_ (.Y(_1767_),
    .B1(_1766_),
    .B2(net320),
    .A2(_1763_),
    .A1(net156));
 sg13g2_nor2_2 _2846_ (.A(_1762_),
    .B(_0548_),
    .Y(_1768_));
 sg13g2_xnor2_1 _2847_ (.Y(_1769_),
    .A(_0548_),
    .B(net429));
 sg13g2_nor2_1 _2848_ (.A(\pll_dig.div.div[3] ),
    .B(_1769_),
    .Y(_1770_));
 sg13g2_xnor2_1 _2849_ (.Y(_0587_),
    .A(net153),
    .B(net322));
 sg13g2_nor2_1 _2850_ (.A(_1767_),
    .B(_1770_),
    .Y(_1771_));
 sg13g2_o21ai_1 _2851_ (.B1(_1771_),
    .Y(_1772_),
    .A1(net156),
    .A2(_1763_));
 sg13g2_xnor2_1 _2852_ (.Y(_1773_),
    .A(\pll_dig.div.pcnt[4] ),
    .B(_1768_));
 sg13g2_a22oi_1 _2853_ (.Y(_1774_),
    .B1(_1773_),
    .B2(net153),
    .A2(_1769_),
    .A1(\pll_dig.div.div[3] ));
 sg13g2_nand3_1 _2854_ (.B(_1768_),
    .C(\pll_dig.div.pcnt[5] ),
    .A(\pll_dig.div.pcnt[4] ),
    .Y(_1775_));
 sg13g2_a21o_1 _2855_ (.A2(net432),
    .A1(\pll_dig.div.pcnt[4] ),
    .B1(\pll_dig.div.pcnt[5] ),
    .X(_1776_));
 sg13g2_nand2_2 _2856_ (.Y(_1777_),
    .A(_1775_),
    .B(_1776_));
 sg13g2_or2_1 _2857_ (.X(_1778_),
    .B(_1773_),
    .A(net153));
 sg13g2_o21ai_1 _2858_ (.B1(_1778_),
    .Y(_1779_),
    .A1(net151),
    .A2(_1777_));
 sg13g2_a21oi_1 _2859_ (.A1(_1772_),
    .A2(_1774_),
    .Y(_1780_),
    .B1(_1779_));
 sg13g2_inv_1 _2860_ (.Y(_0450_),
    .A(\pll_dig.dco_miss_cnt[2] ));
 sg13g2_nand2_1 _2861_ (.Y(_0588_),
    .A(\pll_dig.div.pcnt[3] ),
    .B(net325));
 sg13g2_nand4_1 _2862_ (.B(\pll_dig.div.pcnt[5] ),
    .C(\pll_dig.div.pcnt[6] ),
    .A(\pll_dig.div.pcnt[4] ),
    .Y(_1781_),
    .D(net430));
 sg13g2_xor2_1 _2863_ (.B(\pll_dig.div.pcnt[6] ),
    .A(_1775_),
    .X(_1782_));
 sg13g2_a221oi_1 _2864_ (.B2(net150),
    .C1(_1780_),
    .B1(_1782_),
    .A1(\pll_dig.div.div[5] ),
    .Y(_1783_),
    .A2(_1777_));
 sg13g2_xor2_1 _2865_ (.B(_1781_),
    .A(\pll_dig.div.pcnt[7] ),
    .X(_1784_));
 sg13g2_nor2_1 _2866_ (.A(net149),
    .B(_1784_),
    .Y(_1785_));
 sg13g2_nor2_1 _2867_ (.A(\pll_dig.div.div[6] ),
    .B(net431),
    .Y(_1786_));
 sg13g2_nor4_2 _2868_ (.A(_0578_),
    .B(_1786_),
    .C(_1785_),
    .Y(_1787_),
    .D(_1783_));
 sg13g2_a21o_2 _2869_ (.A2(_1784_),
    .A1(_0582_),
    .B1(_1787_),
    .X(_1788_));
 sg13g2_nor2b_1 _2870_ (.A(\pll_dig.div.pcnt[0] ),
    .B_N(_1788_),
    .Y(_0087_));
 sg13g2_or2_1 _2871_ (.X(_1789_),
    .B(\pll_dig.div.pcnt[1] ),
    .A(\pll_dig.div.pcnt[0] ));
 sg13g2_o21ai_1 _2872_ (.B1(\pll_dig.div.div[3] ),
    .Y(_0589_),
    .A1(net156),
    .A2(net320));
 sg13g2_and3_1 _2873_ (.X(_0088_),
    .A(_1761_),
    .B(_1788_),
    .C(_1789_));
 sg13g2_nor2b_1 _2874_ (.A(_1763_),
    .B_N(_1788_),
    .Y(_0089_));
 sg13g2_nor2b_1 _2875_ (.A(_1769_),
    .B_N(_1788_),
    .Y(_0090_));
 sg13g2_nor2b_1 _2876_ (.A(_1773_),
    .B_N(_1788_),
    .Y(_0091_));
 sg13g2_nor2b_1 _2877_ (.A(net450),
    .B_N(_1788_),
    .Y(_0092_));
 sg13g2_nor2b_1 _2878_ (.A(net433),
    .B_N(_1788_),
    .Y(_0093_));
 sg13g2_nor2b_1 _2879_ (.A(_1784_),
    .B_N(net434),
    .Y(_0094_));
 sg13g2_nor2b_1 _2880_ (.A(_0128_),
    .B_N(\pll_dig.div.div_pend[0] ),
    .Y(_1790_));
 sg13g2_o21ai_1 _2881_ (.B1(net84),
    .Y(_1791_),
    .A1(\pll_dig.div.div_pend[2] ),
    .A2(_1790_));
 sg13g2_a21oi_1 _2882_ (.A1(\pll_dig.div.div_pend[2] ),
    .A2(_1790_),
    .Y(_1792_),
    .B1(_1791_));
 sg13g2_nor2b_1 _2883_ (.A(net322),
    .B_N(_0589_),
    .Y(_0590_));
 sg13g2_xor2_1 _2884_ (.B(_0593_),
    .A(net155),
    .X(_1793_));
 sg13g2_a21o_1 _2885_ (.A2(_1793_),
    .A1(net358),
    .B1(_1792_),
    .X(\pll_dig.div.high_count_pend[1] ));
 sg13g2_and3_1 _2886_ (.X(_1794_),
    .A(\pll_dig.div.div_pend[2] ),
    .B(\pll_dig.div.div_pend[3] ),
    .C(_1790_));
 sg13g2_a21oi_1 _2887_ (.A1(\pll_dig.div.div_pend[2] ),
    .A2(_1790_),
    .Y(_1795_),
    .B1(\pll_dig.div.div_pend[3] ));
 sg13g2_nor2_1 _2888_ (.A(_1794_),
    .B(_1795_),
    .Y(_1796_));
 sg13g2_and3_1 _2889_ (.X(_1797_),
    .A(net155),
    .B(net154),
    .C(_0593_));
 sg13g2_a21oi_1 _2890_ (.A1(net155),
    .A2(_0593_),
    .Y(_1798_),
    .B1(net154));
 sg13g2_nor3_2 _2891_ (.A(_1798_),
    .B(_1797_),
    .C(net84),
    .Y(_1799_));
 sg13g2_a21o_1 _2892_ (.A2(_1796_),
    .A1(net84),
    .B1(_1799_),
    .X(\pll_dig.div.high_count_pend[2] ));
 sg13g2_o21ai_1 _2893_ (.B1(net84),
    .Y(_1800_),
    .A1(\pll_dig.div.div_pend[4] ),
    .A2(_1794_));
 sg13g2_xor2_1 _2894_ (.B(net319),
    .A(net156),
    .X(_0591_));
 sg13g2_a21oi_1 _2895_ (.A1(\pll_dig.div.div_pend[4] ),
    .A2(_1794_),
    .Y(_1801_),
    .B1(_1800_));
 sg13g2_xor2_1 _2896_ (.B(_1797_),
    .A(net152),
    .X(_1802_));
 sg13g2_a21o_1 _2897_ (.A2(_1802_),
    .A1(_0931_),
    .B1(_1801_),
    .X(\pll_dig.div.high_count_pend[3] ));
 sg13g2_and3_1 _2898_ (.X(_1803_),
    .A(\pll_dig.div.div_pend[5] ),
    .B(\pll_dig.div.div_pend[4] ),
    .C(_1794_));
 sg13g2_a21oi_1 _2899_ (.A1(\pll_dig.div.div_pend[4] ),
    .A2(_1794_),
    .Y(_1804_),
    .B1(\pll_dig.div.div_pend[5] ));
 sg13g2_nor2_1 _2900_ (.A(_1803_),
    .B(_1804_),
    .Y(_1805_));
 sg13g2_and3_1 _2901_ (.X(_1806_),
    .A(net152),
    .B(net151),
    .C(_1797_));
 sg13g2_a21oi_1 _2902_ (.A1(net152),
    .A2(_1797_),
    .Y(_1807_),
    .B1(net151));
 sg13g2_nor3_2 _2903_ (.A(_1807_),
    .B(_1806_),
    .C(net82),
    .Y(_1808_));
 sg13g2_a21o_1 _2904_ (.A2(_1805_),
    .A1(net82),
    .B1(_1808_),
    .X(\pll_dig.div.high_count_pend[4] ));
 sg13g2_nor2_1 _2905_ (.A(\pll_dig.div.pcnt[1] ),
    .B(_0591_),
    .Y(_0592_));
 sg13g2_and2_1 _2906_ (.A(\pll_dig.div.div_pend[6] ),
    .B(_1803_),
    .X(_1809_));
 sg13g2_xnor2_1 _2907_ (.Y(_1810_),
    .A(\pll_dig.div.div_pend[6] ),
    .B(_1803_));
 sg13g2_and2_1 _2908_ (.A(net150),
    .B(_1806_),
    .X(_1811_));
 sg13g2_nor2_2 _2909_ (.A(_1811_),
    .B(net82),
    .Y(_1812_));
 sg13g2_o21ai_1 _2910_ (.B1(_1812_),
    .Y(_1813_),
    .A1(net150),
    .A2(_1806_));
 sg13g2_o21ai_1 _2911_ (.B1(_1813_),
    .Y(\pll_dig.div.high_count_pend[5] ),
    .A1(net359),
    .A2(_1810_));
 sg13g2_a21oi_2 _2912_ (.B1(_0931_),
    .Y(_1814_),
    .A2(_1809_),
    .A1(\pll_dig.div.div_pend[7] ));
 sg13g2_o21ai_1 _2913_ (.B1(_1814_),
    .Y(_1815_),
    .A1(\pll_dig.div.div_pend[7] ),
    .A2(_1809_));
 sg13g2_a21oi_2 _2914_ (.B1(net356),
    .Y(_1816_),
    .A2(_1811_),
    .A1(net149));
 sg13g2_xnor2_1 _2915_ (.Y(_1817_),
    .A(net149),
    .B(_1811_));
 sg13g2_nor2b_1 _2916_ (.A(_0133_),
    .B_N(net326),
    .Y(_0593_));
 sg13g2_o21ai_1 _2917_ (.B1(_1815_),
    .Y(\pll_dig.div.high_count_pend[6] ),
    .A1(net356),
    .A2(_1817_));
 sg13g2_nor2_2 _2918_ (.A(_1816_),
    .B(_1814_),
    .Y(\pll_dig.div.high_count_pend[7] ));
 sg13g2_nand2_1 _2919_ (.Y(_1818_),
    .A(\pll_dig.div.ncnt[3] ),
    .B(net325));
 sg13g2_nor2_2 _2920_ (.A(\pll_dig.div.ncnt[1] ),
    .B(_0591_),
    .Y(_1819_));
 sg13g2_nor2_2 _2921_ (.A(\pll_dig.div.ncnt[0] ),
    .B(_0594_),
    .Y(_1820_));
 sg13g2_nor2_1 _2922_ (.A(_1819_),
    .B(_1820_),
    .Y(_1821_));
 sg13g2_a221oi_1 _2923_ (.B2(\pll_dig.div.ncnt[1] ),
    .C1(_1821_),
    .B1(_0591_),
    .A1(\pll_dig.div.ncnt[2] ),
    .Y(_1822_),
    .A2(_0590_));
 sg13g2_or2_1 _2924_ (.X(_1823_),
    .B(net325),
    .A(\pll_dig.div.ncnt[3] ));
 sg13g2_o21ai_1 _2925_ (.B1(_1823_),
    .Y(_1824_),
    .A1(\pll_dig.div.ncnt[2] ),
    .A2(_0590_));
 sg13g2_o21ai_1 _2926_ (.B1(_1818_),
    .Y(_1825_),
    .A1(_1824_),
    .A2(_1822_));
 sg13g2_xnor2_1 _2927_ (.Y(_0594_),
    .A(net326),
    .B(_0133_));
 sg13g2_o21ai_1 _2928_ (.B1(_1825_),
    .Y(_1826_),
    .A1(\pll_dig.div.ncnt[4] ),
    .A2(_0599_));
 sg13g2_a22oi_1 _2929_ (.Y(_1827_),
    .B1(_0605_),
    .B2(\pll_dig.div.ncnt[5] ),
    .A2(_0599_),
    .A1(\pll_dig.div.ncnt[4] ));
 sg13g2_or2_1 _2930_ (.X(_1828_),
    .B(_0605_),
    .A(\pll_dig.div.ncnt[5] ));
 sg13g2_o21ai_1 _2931_ (.B1(_1828_),
    .Y(_1829_),
    .A1(\pll_dig.div.ncnt[6] ),
    .A2(net323));
 sg13g2_a21oi_2 _2932_ (.B1(_1829_),
    .Y(_1830_),
    .A2(_1827_),
    .A1(_1826_));
 sg13g2_and2_1 _2933_ (.A(\pll_dig.div.ncnt[6] ),
    .B(net323),
    .X(_1831_));
 sg13g2_nor4_2 _2934_ (.A(\pll_dig.div.ncnt[7] ),
    .B(_0578_),
    .C(_1831_),
    .Y(_0086_),
    .D(_1830_));
 sg13g2_nor2_1 _2935_ (.A(_0051_),
    .B(_1703_),
    .Y(_1832_));
 sg13g2_or2_1 _2936_ (.X(_1833_),
    .B(_1703_),
    .A(_0051_));
 sg13g2_nand3_1 _2937_ (.B(\pll_dig.cntf[1] ),
    .C(\pll_dig.cntf[2] ),
    .A(\pll_dig.cntf[0] ),
    .Y(_1834_));
 sg13g2_nor2_1 _2938_ (.A(\pll_dig.div.pcnt[0] ),
    .B(_0594_),
    .Y(_0595_));
 sg13g2_nor2_1 _2939_ (.A(_0446_),
    .B(_1834_),
    .Y(_1835_));
 sg13g2_and2_1 _2940_ (.A(\pll_dig.cntf[4] ),
    .B(_1835_),
    .X(_1836_));
 sg13g2_nand3_1 _2941_ (.B(\pll_dig.cntf[5] ),
    .C(_1836_),
    .A(\pll_dig.cntf[6] ),
    .Y(_1837_));
 sg13g2_nor2_1 _2942_ (.A(\pll_dig.cntf[2] ),
    .B(\pll_dig.cntf[3] ),
    .Y(_1838_));
 sg13g2_nor4_1 _2943_ (.A(\pll_dig.cntf[6] ),
    .B(\pll_dig.cntf[7] ),
    .C(\pll_dig.cntf[0] ),
    .D(\pll_dig.cntf[1] ),
    .Y(_1839_));
 sg13g2_and4_1 _2944_ (.A(\pll_dig.cntf[4] ),
    .B(_0522_),
    .C(_1838_),
    .D(_1839_),
    .X(_1840_));
 sg13g2_nor4_1 _2945_ (.A(\pll_dig.state[4] ),
    .B(_1648_),
    .C(_1675_),
    .D(_1840_),
    .Y(_1841_));
 sg13g2_a21oi_1 _2946_ (.A1(_1837_),
    .A2(_1841_),
    .Y(_1842_),
    .B1(_1833_));
 sg13g2_nand3_1 _2947_ (.B(_1832_),
    .C(_1836_),
    .A(\pll_dig.cntf[5] ),
    .Y(_1843_));
 sg13g2_a21oi_1 _2948_ (.A1(_2060_),
    .A2(_1843_),
    .Y(_0251_),
    .B1(_1842_));
 sg13g2_nor2_1 _2949_ (.A(_0592_),
    .B(_0595_),
    .Y(_0596_));
 sg13g2_nor2_1 _2950_ (.A(\SS_BBPD[1] ),
    .B(net106),
    .Y(_1844_));
 sg13g2_nand2b_1 _2951_ (.Y(_1845_),
    .B(_0516_),
    .A_N(net107));
 sg13g2_nor2_1 _2952_ (.A(net20),
    .B(net110),
    .Y(_1846_));
 sg13g2_nor2_1 _2953_ (.A(_0496_),
    .B(net19),
    .Y(_1847_));
 sg13g2_xnor2_1 _2954_ (.Y(_1848_),
    .A(\pll_dig.dlf.INT[14] ),
    .B(net19));
 sg13g2_nor2b_1 _2955_ (.A(\pll_dig.dlf.INT[13] ),
    .B_N(net18),
    .Y(_1849_));
 sg13g2_nor2_1 _2956_ (.A(_0465_),
    .B(net18),
    .Y(_1850_));
 sg13g2_xnor2_1 _2957_ (.Y(_1851_),
    .A(\pll_dig.dlf.INT[12] ),
    .B(net17));
 sg13g2_nor2b_1 _2958_ (.A(\pll_dig.dlf.INT[11] ),
    .B_N(net16),
    .Y(_1852_));
 sg13g2_nor2_1 _2959_ (.A(_0502_),
    .B(net16),
    .Y(_1853_));
 sg13g2_a221oi_1 _2960_ (.B2(\pll_dig.div.pcnt[1] ),
    .C1(_0596_),
    .B1(_0591_),
    .A1(_0590_),
    .Y(_0597_),
    .A2(\pll_dig.div.pcnt[2] ));
 sg13g2_nor2_1 _2961_ (.A(_0466_),
    .B(net15),
    .Y(_1854_));
 sg13g2_xnor2_1 _2962_ (.Y(_1855_),
    .A(\pll_dig.dlf.INT[10] ),
    .B(net15));
 sg13g2_nand2b_1 _2963_ (.Y(_1856_),
    .B(net111),
    .A_N(net29));
 sg13g2_nor2b_1 _2964_ (.A(net111),
    .B_N(net29),
    .Y(_1857_));
 sg13g2_nand2_1 _2965_ (.Y(_1858_),
    .A(\pll_dig.dlf.INT[8] ),
    .B(net28));
 sg13g2_xnor2_1 _2966_ (.Y(_1859_),
    .A(\pll_dig.dlf.INT[8] ),
    .B(net28));
 sg13g2_nor2b_1 _2967_ (.A(\pll_dig.dlf.INT[7] ),
    .B_N(net27),
    .Y(_1860_));
 sg13g2_nand2b_1 _2968_ (.Y(_1861_),
    .B(\pll_dig.dlf.INT[7] ),
    .A_N(net27));
 sg13g2_nand2_1 _2969_ (.Y(_1862_),
    .A(\pll_dig.dlf.INT[6] ),
    .B(net26));
 sg13g2_xnor2_1 _2970_ (.Y(_1863_),
    .A(\pll_dig.dlf.INT[6] ),
    .B(net26));
 sg13g2_inv_1 _2971_ (.Y(_0000_),
    .A(\pll_dig.out_edges[1] ));
 sg13g2_nor2b_2 _2972_ (.A(\pll_dig.div.div[5] ),
    .B_N(_0586_),
    .Y(_0598_));
 sg13g2_nor2_1 _2973_ (.A(_0504_),
    .B(net25),
    .Y(_1864_));
 sg13g2_nand2_1 _2974_ (.Y(_1865_),
    .A(\pll_dig.dlf.INT[5] ),
    .B(net25));
 sg13g2_xnor2_1 _2975_ (.Y(_1866_),
    .A(\pll_dig.dlf.INT[5] ),
    .B(net25));
 sg13g2_nand2_1 _2976_ (.Y(_1867_),
    .A(\pll_dig.dlf.INT[4] ),
    .B(net24));
 sg13g2_xnor2_1 _2977_ (.Y(_1868_),
    .A(\pll_dig.dlf.INT[4] ),
    .B(net24));
 sg13g2_nand2_1 _2978_ (.Y(_1869_),
    .A(\pll_dig.dlf.INT[3] ),
    .B(net23));
 sg13g2_xnor2_1 _2979_ (.Y(_1870_),
    .A(\pll_dig.dlf.INT[3] ),
    .B(net23));
 sg13g2_nand2_1 _2980_ (.Y(_1871_),
    .A(\pll_dig.dlf.INT[2] ),
    .B(net22));
 sg13g2_xnor2_1 _2981_ (.Y(_1872_),
    .A(\pll_dig.dlf.INT[2] ),
    .B(net22));
 sg13g2_nor2_1 _2982_ (.A(_0506_),
    .B(net21),
    .Y(_1873_));
 sg13g2_xnor2_1 _2983_ (.Y(_0599_),
    .A(\pll_dig.div.div[5] ),
    .B(net321));
 sg13g2_xor2_1 _2984_ (.B(net21),
    .A(\pll_dig.dlf.INT[1] ),
    .X(_1874_));
 sg13g2_a21oi_1 _2985_ (.A1(_0443_),
    .A2(net14),
    .Y(_1875_),
    .B1(_1874_));
 sg13g2_or2_1 _2986_ (.X(_1876_),
    .B(_1875_),
    .A(_1873_));
 sg13g2_nand2_1 _2987_ (.Y(_1877_),
    .A(_1872_),
    .B(_1876_));
 sg13g2_o21ai_1 _2988_ (.B1(_1877_),
    .Y(_1878_),
    .A1(_0505_),
    .A2(net22));
 sg13g2_nand2_1 _2989_ (.Y(_1879_),
    .A(_1870_),
    .B(_1878_));
 sg13g2_o21ai_1 _2990_ (.B1(_1879_),
    .Y(_1880_),
    .A1(_0452_),
    .A2(net23));
 sg13g2_and2_1 _2991_ (.A(_1868_),
    .B(_1880_),
    .X(_1881_));
 sg13g2_nand2_1 _2992_ (.Y(_1882_),
    .A(_1868_),
    .B(_1880_));
 sg13g2_o21ai_1 _2993_ (.B1(_1882_),
    .Y(_1883_),
    .A1(_0503_),
    .A2(net24));
 sg13g2_or2_1 _2994_ (.X(_0600_),
    .B(_0587_),
    .A(\pll_dig.div.pcnt[3] ));
 sg13g2_and2_1 _2995_ (.A(_1866_),
    .B(_1883_),
    .X(_1884_));
 sg13g2_o21ai_1 _2996_ (.B1(_1863_),
    .Y(_1885_),
    .A1(_1864_),
    .A2(_1884_));
 sg13g2_nand2b_1 _2997_ (.Y(_1886_),
    .B(\pll_dig.dlf.INT[6] ),
    .A_N(net26));
 sg13g2_and2_1 _2998_ (.A(_1885_),
    .B(_1886_),
    .X(_1887_));
 sg13g2_o21ai_1 _2999_ (.B1(_1861_),
    .Y(_1888_),
    .A1(_1860_),
    .A2(_1887_));
 sg13g2_nor2_1 _3000_ (.A(_0529_),
    .B(net28),
    .Y(_1889_));
 sg13g2_a21oi_1 _3001_ (.A1(_1859_),
    .A2(_1888_),
    .Y(_1890_),
    .B1(_1889_));
 sg13g2_a21oi_1 _3002_ (.A1(_1856_),
    .A2(_1890_),
    .Y(_1891_),
    .B1(_1857_));
 sg13g2_a21oi_1 _3003_ (.A1(_1855_),
    .A2(_1891_),
    .Y(_1892_),
    .B1(_1854_));
 sg13g2_nor2_1 _3004_ (.A(_1852_),
    .B(_1892_),
    .Y(_1893_));
 sg13g2_o21ai_1 _3005_ (.B1(_0600_),
    .Y(_0601_),
    .A1(\pll_dig.div.pcnt[2] ),
    .A2(_0590_));
 sg13g2_nor2_1 _3006_ (.A(_1853_),
    .B(_1893_),
    .Y(_1894_));
 sg13g2_nor2b_1 _3007_ (.A(_1894_),
    .B_N(_1851_),
    .Y(_1895_));
 sg13g2_a21oi_1 _3008_ (.A1(\pll_dig.dlf.INT[12] ),
    .A2(_0498_),
    .Y(_1896_),
    .B1(_1895_));
 sg13g2_nor2b_1 _3009_ (.A(_1850_),
    .B_N(_1896_),
    .Y(_1897_));
 sg13g2_nor2_1 _3010_ (.A(_1849_),
    .B(_1897_),
    .Y(_1898_));
 sg13g2_and2_1 _3011_ (.A(_1848_),
    .B(_1898_),
    .X(_1899_));
 sg13g2_nor2_1 _3012_ (.A(_1847_),
    .B(_1899_),
    .Y(_1900_));
 sg13g2_nor3_1 _3013_ (.A(_1846_),
    .B(_1847_),
    .C(_1899_),
    .Y(_1901_));
 sg13g2_a21o_1 _3014_ (.A2(net110),
    .A1(net20),
    .B1(_1901_),
    .X(_1902_));
 sg13g2_nor2_1 _3015_ (.A(net101),
    .B(_1902_),
    .Y(_1903_));
 sg13g2_o21ai_1 _3016_ (.B1(_0588_),
    .Y(_0602_),
    .A1(_0597_),
    .A2(_0601_));
 sg13g2_or2_1 _3017_ (.X(_1904_),
    .B(_1902_),
    .A(net101));
 sg13g2_xnor2_1 _3018_ (.Y(_1905_),
    .A(_1851_),
    .B(_1894_));
 sg13g2_nand2b_1 _3019_ (.Y(_1906_),
    .B(net20),
    .A_N(net110));
 sg13g2_nand2_1 _3020_ (.Y(_1907_),
    .A(\pll_dig.dlf.INT[13] ),
    .B(net18));
 sg13g2_nand2_1 _3021_ (.Y(_1908_),
    .A(\pll_dig.dlf.INT[11] ),
    .B(net16));
 sg13g2_nor2_1 _3022_ (.A(_1852_),
    .B(_1853_),
    .Y(_1909_));
 sg13g2_nand2_1 _3023_ (.Y(_1910_),
    .A(\pll_dig.dlf.INT[10] ),
    .B(net15));
 sg13g2_nand2_1 _3024_ (.Y(_1911_),
    .A(net111),
    .B(net29));
 sg13g2_xnor2_1 _3025_ (.Y(_1912_),
    .A(net111),
    .B(net29));
 sg13g2_nor2b_1 _3026_ (.A(_1860_),
    .B_N(_1861_),
    .Y(_1913_));
 sg13g2_o21ai_1 _3027_ (.B1(_0602_),
    .Y(_0603_),
    .A1(\pll_dig.div.pcnt[4] ),
    .A2(_0599_));
 sg13g2_nand2_1 _3028_ (.Y(_1914_),
    .A(\pll_dig.dlf.INT[1] ),
    .B(net21));
 sg13g2_nand2_1 _3029_ (.Y(_1915_),
    .A(\pll_dig.dlf.INT[0] ),
    .B(net14));
 sg13g2_nand2b_1 _3030_ (.Y(_1916_),
    .B(_1874_),
    .A_N(_1915_));
 sg13g2_a21o_1 _3031_ (.A2(_1916_),
    .A1(_1914_),
    .B1(_1872_),
    .X(_1917_));
 sg13g2_a21o_1 _3032_ (.A2(_1917_),
    .A1(_1871_),
    .B1(_1870_),
    .X(_1918_));
 sg13g2_a21o_1 _3033_ (.A2(_1918_),
    .A1(_1869_),
    .B1(_1868_),
    .X(_1919_));
 sg13g2_a21o_1 _3034_ (.A2(_1919_),
    .A1(_1867_),
    .B1(_1866_),
    .X(_1920_));
 sg13g2_a21o_1 _3035_ (.A2(_1920_),
    .A1(_1865_),
    .B1(_1863_),
    .X(_1921_));
 sg13g2_a21o_1 _3036_ (.A2(_1921_),
    .A1(_1862_),
    .B1(_1913_),
    .X(_1922_));
 sg13g2_nand2_1 _3037_ (.Y(_1923_),
    .A(\pll_dig.dlf.INT[7] ),
    .B(net27));
 sg13g2_nand2b_1 _3038_ (.Y(_0604_),
    .B(_0598_),
    .A_N(\pll_dig.div.div[6] ));
 sg13g2_a21o_1 _3039_ (.A2(_1923_),
    .A1(_1922_),
    .B1(_1859_),
    .X(_1924_));
 sg13g2_a21o_1 _3040_ (.A2(_1924_),
    .A1(_1858_),
    .B1(_1912_),
    .X(_1925_));
 sg13g2_a21o_1 _3041_ (.A2(_1925_),
    .A1(_1911_),
    .B1(_1855_),
    .X(_1926_));
 sg13g2_a21o_1 _3042_ (.A2(_1926_),
    .A1(_1910_),
    .B1(_1909_),
    .X(_1927_));
 sg13g2_a21o_1 _3043_ (.A2(_1927_),
    .A1(_1908_),
    .B1(_1851_),
    .X(_1928_));
 sg13g2_inv_1 _3044_ (.Y(_1929_),
    .A(_1928_));
 sg13g2_a21oi_1 _3045_ (.A1(\pll_dig.dlf.INT[12] ),
    .A2(net17),
    .Y(_1930_),
    .B1(_1929_));
 sg13g2_inv_1 _3046_ (.Y(_1931_),
    .A(_1930_));
 sg13g2_o21ai_1 _3047_ (.B1(_1931_),
    .Y(_1932_),
    .A1(\pll_dig.dlf.INT[13] ),
    .A2(net18));
 sg13g2_a21oi_1 _3048_ (.A1(_1907_),
    .A2(_1932_),
    .Y(_1933_),
    .B1(_1848_));
 sg13g2_xnor2_1 _3049_ (.Y(_0605_),
    .A(\pll_dig.div.div[6] ),
    .B(_0598_));
 sg13g2_a21oi_1 _3050_ (.A1(\pll_dig.dlf.INT[14] ),
    .A2(net19),
    .Y(_1934_),
    .B1(_1933_));
 sg13g2_nor2b_1 _3051_ (.A(net20),
    .B_N(net110),
    .Y(_1935_));
 sg13g2_a21oi_1 _3052_ (.A1(_1906_),
    .A2(_1934_),
    .Y(_1936_),
    .B1(_1935_));
 sg13g2_a21o_1 _3053_ (.A2(_1936_),
    .A1(\SS_BBPD[1] ),
    .B1(net105),
    .X(_1937_));
 sg13g2_nand3_1 _3054_ (.B(_1908_),
    .C(_1927_),
    .A(_1851_),
    .Y(_1938_));
 sg13g2_nand3_1 _3055_ (.B(_1928_),
    .C(_1938_),
    .A(net102),
    .Y(_1939_));
 sg13g2_a21oi_1 _3056_ (.A1(net63),
    .A2(_1905_),
    .Y(_1940_),
    .B1(net66));
 sg13g2_a22oi_1 _3057_ (.Y(_0254_),
    .B1(_1939_),
    .B2(_1940_),
    .A2(net107),
    .A1(_0497_));
 sg13g2_xnor2_1 _3058_ (.Y(_1941_),
    .A(_1892_),
    .B(_1909_));
 sg13g2_nand3_1 _3059_ (.B(_1910_),
    .C(_1926_),
    .A(_1909_),
    .Y(_1942_));
 sg13g2_a22oi_1 _3060_ (.Y(_0606_),
    .B1(_0605_),
    .B2(\pll_dig.div.pcnt[5] ),
    .A2(_0599_),
    .A1(\pll_dig.div.pcnt[4] ));
 sg13g2_nand3_1 _3061_ (.B(_1927_),
    .C(_1942_),
    .A(net102),
    .Y(_1943_));
 sg13g2_a21oi_1 _3062_ (.A1(net63),
    .A2(_1941_),
    .Y(_1944_),
    .B1(net67));
 sg13g2_a22oi_1 _3063_ (.Y(_0255_),
    .B1(_1943_),
    .B2(_1944_),
    .A2(net107),
    .A1(_0502_));
 sg13g2_a22oi_1 _3064_ (.Y(_1945_),
    .B1(_1931_),
    .B2(net102),
    .A2(net63),
    .A1(_1896_));
 sg13g2_nor3_1 _3065_ (.A(_1849_),
    .B(_1850_),
    .C(_1945_),
    .Y(_1946_));
 sg13g2_nand2_1 _3066_ (.Y(_1947_),
    .A(net102),
    .B(_1930_));
 sg13g2_o21ai_1 _3067_ (.B1(_1947_),
    .Y(_1948_),
    .A1(_1896_),
    .A2(_1904_));
 sg13g2_o21ai_1 _3068_ (.B1(_1948_),
    .Y(_1949_),
    .A1(_1849_),
    .A2(_1850_));
 sg13g2_nor2_1 _3069_ (.A(net67),
    .B(_1946_),
    .Y(_1950_));
 sg13g2_a22oi_1 _3070_ (.Y(_0256_),
    .B1(_1949_),
    .B2(_1950_),
    .A2(net105),
    .A1(_0465_));
 sg13g2_xor2_1 _3071_ (.B(_0604_),
    .A(\pll_dig.div.div[7] ),
    .X(_0607_));
 sg13g2_or3_1 _3072_ (.A(_1863_),
    .B(_1864_),
    .C(_1884_),
    .X(_1951_));
 sg13g2_and2_1 _3073_ (.A(_1885_),
    .B(_1951_),
    .X(_1952_));
 sg13g2_nand3_1 _3074_ (.B(_1865_),
    .C(_1920_),
    .A(_1863_),
    .Y(_1953_));
 sg13g2_nand3_1 _3075_ (.B(_1921_),
    .C(_1953_),
    .A(net101),
    .Y(_1954_));
 sg13g2_a21oi_1 _3076_ (.A1(net63),
    .A2(_1952_),
    .Y(_1955_),
    .B1(net66));
 sg13g2_a22oi_1 _3077_ (.Y(_0269_),
    .B1(_1954_),
    .B2(_1955_),
    .A2(net105),
    .A1(_0480_));
 sg13g2_xnor2_1 _3078_ (.Y(_1956_),
    .A(_1890_),
    .B(_1912_));
 sg13g2_nand3_1 _3079_ (.B(_1912_),
    .C(_1924_),
    .A(_1858_),
    .Y(_1957_));
 sg13g2_nand3_1 _3080_ (.B(_1925_),
    .C(_1957_),
    .A(net102),
    .Y(_1958_));
 sg13g2_a21oi_1 _3081_ (.A1(net63),
    .A2(_1956_),
    .Y(_1959_),
    .B1(net67));
 sg13g2_inv_1 _3082_ (.Y(_0451_),
    .A(\pll_dig.COARSE_MUX_D[0] ));
 sg13g2_or2_1 _3083_ (.X(_0608_),
    .B(_0605_),
    .A(\pll_dig.div.pcnt[5] ));
 sg13g2_a22oi_1 _3084_ (.Y(_0272_),
    .B1(_1958_),
    .B2(_1959_),
    .A2(net105),
    .A1(_0478_));
 sg13g2_xor2_1 _3085_ (.B(_1878_),
    .A(_1870_),
    .X(_1960_));
 sg13g2_nand3_1 _3086_ (.B(_1871_),
    .C(_1917_),
    .A(_1870_),
    .Y(_1961_));
 sg13g2_nand3_1 _3087_ (.B(_1918_),
    .C(_1961_),
    .A(net101),
    .Y(_1962_));
 sg13g2_a21oi_1 _3088_ (.A1(net63),
    .A2(_1960_),
    .Y(_1963_),
    .B1(net66));
 sg13g2_a22oi_1 _3089_ (.Y(_0273_),
    .B1(_1962_),
    .B2(_1963_),
    .A2(net105),
    .A1(_0452_));
 sg13g2_nor2_1 _3090_ (.A(_1868_),
    .B(_1880_),
    .Y(_1964_));
 sg13g2_nor3_1 _3091_ (.A(_1881_),
    .B(_1904_),
    .C(_1964_),
    .Y(_1965_));
 sg13g2_nand3_1 _3092_ (.B(_1869_),
    .C(_1918_),
    .A(_1868_),
    .Y(_1966_));
 sg13g2_nand3_1 _3093_ (.B(_1919_),
    .C(_1966_),
    .A(net101),
    .Y(_1967_));
 sg13g2_o21ai_1 _3094_ (.B1(_0608_),
    .Y(_0609_),
    .A1(_0607_),
    .A2(\pll_dig.div.pcnt[6] ));
 sg13g2_nor2_1 _3095_ (.A(net66),
    .B(_1965_),
    .Y(_1968_));
 sg13g2_a22oi_1 _3096_ (.Y(_0275_),
    .B1(_1967_),
    .B2(_1968_),
    .A2(net105),
    .A1(_0503_));
 sg13g2_or2_1 _3097_ (.X(_1969_),
    .B(net14),
    .A(\pll_dig.dlf.INT[0] ));
 sg13g2_a21oi_1 _3098_ (.A1(_1915_),
    .A2(_1969_),
    .Y(_1970_),
    .B1(net66));
 sg13g2_a221oi_1 _3099_ (.B2(_1902_),
    .C1(_1970_),
    .B1(_1844_),
    .A1(_0443_),
    .Y(_0276_),
    .A2(net106));
 sg13g2_nand3_1 _3100_ (.B(net14),
    .C(_1874_),
    .A(_0443_),
    .Y(_1971_));
 sg13g2_nor2_1 _3101_ (.A(_1875_),
    .B(_1904_),
    .Y(_1972_));
 sg13g2_xnor2_1 _3102_ (.Y(_1973_),
    .A(_1874_),
    .B(_1915_));
 sg13g2_a221oi_1 _3103_ (.B2(net101),
    .C1(net66),
    .B1(_1973_),
    .A1(_1971_),
    .Y(_1974_),
    .A2(_1972_));
 sg13g2_a21oi_1 _3104_ (.A1(_0506_),
    .A2(net106),
    .Y(_0277_),
    .B1(_1974_));
 sg13g2_a21oi_2 _3105_ (.B1(_0609_),
    .Y(_0610_),
    .A2(_0606_),
    .A1(_0603_));
 sg13g2_xor2_1 _3106_ (.B(_1876_),
    .A(_1872_),
    .X(_1975_));
 sg13g2_nand3_1 _3107_ (.B(_1914_),
    .C(_1916_),
    .A(_1872_),
    .Y(_1976_));
 sg13g2_nand3_1 _3108_ (.B(_1917_),
    .C(_1976_),
    .A(net101),
    .Y(_1977_));
 sg13g2_a21oi_1 _3109_ (.A1(net63),
    .A2(_1975_),
    .Y(_1978_),
    .B1(net66));
 sg13g2_a22oi_1 _3110_ (.Y(_0279_),
    .B1(_1977_),
    .B2(_1978_),
    .A2(net106),
    .A1(_0505_));
 sg13g2_xnor2_1 _3111_ (.Y(_1979_),
    .A(_1887_),
    .B(_1913_));
 sg13g2_nand3_1 _3112_ (.B(_1913_),
    .C(_1921_),
    .A(_1862_),
    .Y(_1980_));
 sg13g2_nand3_1 _3113_ (.B(_1922_),
    .C(_1980_),
    .A(net102),
    .Y(_1981_));
 sg13g2_a21oi_1 _3114_ (.A1(net63),
    .A2(_1979_),
    .Y(_1982_),
    .B1(net67));
 sg13g2_a22oi_1 _3115_ (.Y(_0282_),
    .B1(_1981_),
    .B2(_1982_),
    .A2(net105),
    .A1(_0499_));
 sg13g2_and2_1 _3116_ (.A(\pll_dig.div.pcnt[6] ),
    .B(net324),
    .X(_0611_));
 sg13g2_nor2_1 _3117_ (.A(_1866_),
    .B(_1883_),
    .Y(_1983_));
 sg13g2_nor3_1 _3118_ (.A(_1884_),
    .B(_1904_),
    .C(_1983_),
    .Y(_1984_));
 sg13g2_nand3_1 _3119_ (.B(_1867_),
    .C(_1919_),
    .A(_1866_),
    .Y(_1985_));
 sg13g2_nand3_1 _3120_ (.B(_1920_),
    .C(_1985_),
    .A(net102),
    .Y(_1986_));
 sg13g2_nor2_1 _3121_ (.A(net66),
    .B(_1984_),
    .Y(_1987_));
 sg13g2_a22oi_1 _3122_ (.Y(_0287_),
    .B1(_1986_),
    .B2(_1987_),
    .A2(net105),
    .A1(_0504_));
 sg13g2_a21oi_1 _3123_ (.A1(_1934_),
    .A2(_1935_),
    .Y(_1988_),
    .B1(_0516_));
 sg13g2_nor4_1 _3124_ (.A(net20),
    .B(net110),
    .C(net101),
    .D(_1900_),
    .Y(_1989_));
 sg13g2_nor2_1 _3125_ (.A(_1988_),
    .B(_1989_),
    .Y(_1990_));
 sg13g2_mux2_1 _3126_ (.A0(_1990_),
    .A1(net110),
    .S(net106),
    .X(_0289_));
 sg13g2_nor4_2 _3127_ (.A(\pll_dig.div.pcnt[7] ),
    .B(_0578_),
    .C(_0611_),
    .Y(_0045_),
    .D(_0610_));
 sg13g2_xor2_1 _3128_ (.B(_1888_),
    .A(_1859_),
    .X(_1991_));
 sg13g2_nand3_1 _3129_ (.B(_1922_),
    .C(_1923_),
    .A(_1859_),
    .Y(_1992_));
 sg13g2_nand3_1 _3130_ (.B(_1924_),
    .C(_1992_),
    .A(_1845_),
    .Y(_1993_));
 sg13g2_a21oi_1 _3131_ (.A1(_1903_),
    .A2(_1991_),
    .Y(_1994_),
    .B1(net67));
 sg13g2_a22oi_1 _3132_ (.Y(_0290_),
    .B1(_1993_),
    .B2(_1994_),
    .A2(net106),
    .A1(_0529_));
 sg13g2_nor2_1 _3133_ (.A(_1848_),
    .B(_1898_),
    .Y(_1995_));
 sg13g2_nor3_1 _3134_ (.A(_1899_),
    .B(_1904_),
    .C(_1995_),
    .Y(_1996_));
 sg13g2_nand3_1 _3135_ (.B(_1907_),
    .C(_1932_),
    .A(_1848_),
    .Y(_1997_));
 sg13g2_nor2_1 _3136_ (.A(_1844_),
    .B(_1933_),
    .Y(_1998_));
 sg13g2_nand2_1 _3137_ (.Y(_1999_),
    .A(_1997_),
    .B(_1998_));
 sg13g2_nand3_1 _3138_ (.B(net6),
    .C(net5),
    .A(net7),
    .Y(_0612_));
 sg13g2_nor2_1 _3139_ (.A(net67),
    .B(_1996_),
    .Y(_2000_));
 sg13g2_a22oi_1 _3140_ (.Y(_0291_),
    .B1(_1999_),
    .B2(_2000_),
    .A2(net106),
    .A1(_0496_));
 sg13g2_xor2_1 _3141_ (.B(_1891_),
    .A(_1855_),
    .X(_2001_));
 sg13g2_nand3_1 _3142_ (.B(_1911_),
    .C(_1925_),
    .A(_1855_),
    .Y(_2002_));
 sg13g2_nand3_1 _3143_ (.B(_1926_),
    .C(_2002_),
    .A(_1845_),
    .Y(_2003_));
 sg13g2_a21oi_1 _3144_ (.A1(_1903_),
    .A2(_2001_),
    .Y(_2004_),
    .B1(net67));
 sg13g2_a22oi_1 _3145_ (.Y(_0294_),
    .B1(_2003_),
    .B2(_2004_),
    .A2(net107),
    .A1(_0466_));
 sg13g2_nor2b_1 _3146_ (.A(_1711_),
    .B_N(_1655_),
    .Y(_2005_));
 sg13g2_a21oi_1 _3147_ (.A1(\pll_dig.PHASE_LOCK ),
    .A2(_2005_),
    .Y(_2006_),
    .B1(\pll_dig.LOCK_LOST ));
 sg13g2_nor3_1 _3148_ (.A(_1649_),
    .B(_1651_),
    .C(_1682_),
    .Y(_2007_));
 sg13g2_nor2_1 _3149_ (.A(_0485_),
    .B(_0612_),
    .Y(_0613_));
 sg13g2_nand2b_1 _3150_ (.Y(_2008_),
    .B(\pll_dig.ENABLE ),
    .A_N(_2007_));
 sg13g2_a21oi_1 _3151_ (.A1(_2005_),
    .A2(_2008_),
    .Y(_0295_),
    .B1(_2006_));
 sg13g2_nand2b_1 _3152_ (.Y(_2009_),
    .B(_0957_),
    .A_N(\pll_dig.div.div_pend[0] ));
 sg13g2_nand2b_1 _3153_ (.Y(_2010_),
    .B(net361),
    .A_N(net327));
 sg13g2_mux2_1 _3154_ (.A0(_2009_),
    .A1(_2010_),
    .S(net337),
    .X(_0172_));
 sg13g2_nand2_1 _3155_ (.Y(_2011_),
    .A(_0984_),
    .B(_1041_));
 sg13g2_nand2_1 _3156_ (.Y(_2012_),
    .A(\SS_BBPD[0] ),
    .B(_1071_));
 sg13g2_nor2_1 _3157_ (.A(net110),
    .B(net108),
    .Y(_2013_));
 sg13g2_a22oi_1 _3158_ (.Y(_0182_),
    .B1(_2012_),
    .B2(_2013_),
    .A2(_2011_),
    .A1(net108));
 sg13g2_o21ai_1 _3159_ (.B1(\pll_dig.fail_qq ),
    .Y(_2014_),
    .A1(\pll_dig.state[4] ),
    .A2(\pll_dig.state[2] ));
 sg13g2_nand3_1 _3160_ (.B(net10),
    .C(_0613_),
    .A(net9),
    .Y(_0614_));
 sg13g2_xnor2_1 _3161_ (.Y(_0310_),
    .A(\pll_dig.clr_toggle ),
    .B(_2014_));
 sg13g2_mux2_1 _3162_ (.A0(net361),
    .A1(_0957_),
    .S(net84),
    .X(_2015_));
 sg13g2_and2_1 _3163_ (.A(_2015_),
    .B(_0314_),
    .X(_0201_));
 sg13g2_a21o_1 _3164_ (.A2(\pll_dig.div.use_clk ),
    .A1(_0454_),
    .B1(\pll_dig.div.enter_req ),
    .X(_0315_));
 sg13g2_a21oi_1 _3165_ (.A1(_0134_),
    .A2(_1703_),
    .Y(_2016_),
    .B1(_1673_));
 sg13g2_and2_1 _3166_ (.A(\pll_dig.cnt[0] ),
    .B(_2016_),
    .X(_2017_));
 sg13g2_and2_1 _3167_ (.A(\pll_dig.cnt[1] ),
    .B(_2017_),
    .X(_2018_));
 sg13g2_and2_1 _3168_ (.A(\pll_dig.cnt[2] ),
    .B(_2018_),
    .X(_2019_));
 sg13g2_and2_1 _3169_ (.A(\pll_dig.cnt[3] ),
    .B(_2019_),
    .X(_2020_));
 sg13g2_and3_1 _3170_ (.X(_2021_),
    .A(\pll_dig.cnt[4] ),
    .B(\pll_dig.cnt[5] ),
    .C(_2020_));
 sg13g2_nand4_1 _3171_ (.B(net9),
    .C(net10),
    .A(net11),
    .Y(_0615_),
    .D(_0613_));
 sg13g2_a221oi_1 _3172_ (.B2(_1648_),
    .C1(_1673_),
    .B1(_1713_),
    .A1(_1702_),
    .Y(_2022_),
    .A2(_1703_));
 sg13g2_nand2_1 _3173_ (.Y(_2023_),
    .A(\pll_dig.cnt[6] ),
    .B(_2021_));
 sg13g2_xnor2_1 _3174_ (.Y(_2024_),
    .A(\pll_dig.cnt[6] ),
    .B(_2021_));
 sg13g2_nor2_1 _3175_ (.A(_2022_),
    .B(_2024_),
    .Y(_0319_));
 sg13g2_nor2_1 _3176_ (.A(\pll_dig.cnt[2] ),
    .B(_2018_),
    .Y(_2025_));
 sg13g2_nor3_1 _3177_ (.A(_2019_),
    .B(_2022_),
    .C(_2025_),
    .Y(_0320_));
 sg13g2_nand3_1 _3178_ (.B(_1713_),
    .C(_1840_),
    .A(\pll_dig.ILL_P ),
    .Y(_2026_));
 sg13g2_o21ai_1 _3179_ (.B1(_2026_),
    .Y(_0321_),
    .A1(_0481_),
    .A2(\pll_dig.state[2] ));
 sg13g2_nand2b_1 _3180_ (.Y(_0326_),
    .B(_0134_),
    .A_N(net124));
 sg13g2_nor3_1 _3181_ (.A(\pll_dig.FREQ_OK ),
    .B(\pll_dig.FREQ_ERR ),
    .C(_1538_),
    .Y(_2027_));
 sg13g2_xnor2_1 _3182_ (.Y(_0103_),
    .A(net11),
    .B(_0614_));
 sg13g2_or2_1 _3183_ (.X(_0213_),
    .B(_0134_),
    .A(\pll_dig.cnt[3] ));
 sg13g2_nand2_1 _3184_ (.Y(_2028_),
    .A(\pll_dig.state[3] ),
    .B(_0213_));
 sg13g2_nor2_1 _3185_ (.A(_2027_),
    .B(_2028_),
    .Y(_2029_));
 sg13g2_a21oi_1 _3186_ (.A1(\pll_dig.state[3] ),
    .A2(_0134_),
    .Y(_2030_),
    .B1(_1701_));
 sg13g2_a21oi_1 _3187_ (.A1(_0444_),
    .A2(_2030_),
    .Y(_0327_),
    .B1(_2029_));
 sg13g2_or2_1 _3188_ (.X(_0328_),
    .B(_1701_),
    .A(\pll_dig.ENABLE ));
 sg13g2_or2_1 _3189_ (.X(_0329_),
    .B(net57),
    .A(\pll_dig.state[1] ));
 sg13g2_nand2b_1 _3190_ (.Y(_2031_),
    .B(_1841_),
    .A_N(_1836_));
 sg13g2_a21oi_1 _3191_ (.A1(_1832_),
    .A2(_2031_),
    .Y(_2032_),
    .B1(_0522_));
 sg13g2_nand2_1 _3192_ (.Y(_2033_),
    .A(_1832_),
    .B(_1841_));
 sg13g2_inv_1 _3193_ (.Y(_2060_),
    .A(\pll_dig.cntf[6] ));
 sg13g2_inv_1 _3194_ (.Y(\pll_dig.out_edges_next[0] ),
    .A(\pll_dig.out_edges[0] ));
 sg13g2_nand2_1 _3195_ (.Y(_0616_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .B(\pll_dig.dsm_impl.FCWF[1] ));
 sg13g2_nand4_1 _3196_ (.B(_1832_),
    .C(_1836_),
    .A(_0522_),
    .Y(_2034_),
    .D(_1841_));
 sg13g2_nand2b_1 _3197_ (.Y(_0352_),
    .B(_2034_),
    .A_N(_2032_));
 sg13g2_nand2_1 _3198_ (.Y(_2035_),
    .A(\pll_dig.cntf[1] ),
    .B(_1833_));
 sg13g2_xnor2_1 _3199_ (.Y(_2036_),
    .A(\pll_dig.cntf[0] ),
    .B(\pll_dig.cntf[1] ));
 sg13g2_o21ai_1 _3200_ (.B1(_2035_),
    .Y(_0353_),
    .A1(_2033_),
    .A2(_2036_));
 sg13g2_a21oi_1 _3201_ (.A1(\pll_dig.cnt[4] ),
    .A2(_2020_),
    .Y(_2037_),
    .B1(\pll_dig.cnt[5] ));
 sg13g2_nor3_1 _3202_ (.A(_2021_),
    .B(_2022_),
    .C(_2037_),
    .Y(_0354_));
 sg13g2_nor2_1 _3203_ (.A(\pll_dig.cnt[1] ),
    .B(_2017_),
    .Y(_2038_));
 sg13g2_nor3_1 _3204_ (.A(_2018_),
    .B(_2022_),
    .C(_2038_),
    .Y(_0355_));
 sg13g2_nor2_1 _3205_ (.A(_1703_),
    .B(_1713_),
    .Y(_2039_));
 sg13g2_and2_1 _3206_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .B(\pll_dig.dsm_impl.FCWF[0] ),
    .X(_0617_));
 sg13g2_nand2_1 _3207_ (.Y(_2040_),
    .A(_1673_),
    .B(_2039_));
 sg13g2_o21ai_1 _3208_ (.B1(_2040_),
    .Y(_0356_),
    .A1(_0520_),
    .A2(_2039_));
 sg13g2_a21oi_1 _3209_ (.A1(_1832_),
    .A2(_1835_),
    .Y(_2041_),
    .B1(\pll_dig.cntf[4] ));
 sg13g2_a21oi_1 _3210_ (.A1(_1832_),
    .A2(_2031_),
    .Y(_0357_),
    .B1(_2041_));
 sg13g2_nand2_1 _3211_ (.Y(_2042_),
    .A(\pll_dig.cntf[0] ),
    .B(_1833_));
 sg13g2_o21ai_1 _3212_ (.B1(_2042_),
    .Y(_0358_),
    .A1(\pll_dig.cntf[0] ),
    .A2(_2033_));
 sg13g2_a21oi_1 _3213_ (.A1(\pll_dig.cnt[4] ),
    .A2(_2020_),
    .Y(_2043_),
    .B1(_2022_));
 sg13g2_o21ai_1 _3214_ (.B1(_2043_),
    .Y(_2044_),
    .A1(\pll_dig.cnt[4] ),
    .A2(_2020_));
 sg13g2_inv_1 _3215_ (.Y(_0359_),
    .A(_2044_));
 sg13g2_nor2_1 _3216_ (.A(\pll_dig.cnt[0] ),
    .B(_2016_),
    .Y(_2045_));
 sg13g2_nor2b_1 _3217_ (.A(net4),
    .B_N(net3),
    .Y(_0618_));
 sg13g2_nor3_1 _3218_ (.A(_2017_),
    .B(_2022_),
    .C(_2045_),
    .Y(_0360_));
 sg13g2_xnor2_1 _3219_ (.Y(_2046_),
    .A(\pll_dig.div.div_pend[0] ),
    .B(_0128_));
 sg13g2_mux2_1 _3220_ (.A0(_0594_),
    .A1(_2046_),
    .S(net84),
    .X(_2047_));
 sg13g2_nor2b_1 _3221_ (.A(_2047_),
    .B_N(_2015_),
    .Y(_0235_));
 sg13g2_nor2b_1 _3222_ (.A(_1842_),
    .B_N(\pll_dig.cntf[7] ),
    .Y(_2048_));
 sg13g2_nor3_1 _3223_ (.A(\pll_dig.cntf[7] ),
    .B(_1837_),
    .C(_2033_),
    .Y(_2049_));
 sg13g2_or2_1 _3224_ (.X(_0418_),
    .B(_2049_),
    .A(_2048_));
 sg13g2_a21oi_1 _3225_ (.A1(_1834_),
    .A2(_1841_),
    .Y(_2050_),
    .B1(_1833_));
 sg13g2_or3_1 _3226_ (.A(\pll_dig.cntf[3] ),
    .B(_1834_),
    .C(_2033_),
    .X(_2051_));
 sg13g2_o21ai_1 _3227_ (.B1(_2051_),
    .Y(_0419_),
    .A1(_0446_),
    .A2(_2050_));
 sg13g2_nand2b_1 _3228_ (.Y(_0619_),
    .B(net4),
    .A_N(net3));
 sg13g2_xor2_1 _3229_ (.B(_2023_),
    .A(\pll_dig.cnt[7] ),
    .X(_2052_));
 sg13g2_nor2_1 _3230_ (.A(_2022_),
    .B(_2052_),
    .Y(_0420_));
 sg13g2_nor2_1 _3231_ (.A(\pll_dig.cnt[3] ),
    .B(_2019_),
    .Y(_2053_));
 sg13g2_nor3_1 _3232_ (.A(_2020_),
    .B(_2022_),
    .C(_2053_),
    .Y(_0421_));
 sg13g2_nand2b_1 _3233_ (.Y(_2054_),
    .B(\pll_dig.FORCE_N ),
    .A_N(\pll_dig.state[2] ));
 sg13g2_nand3_1 _3234_ (.B(_1713_),
    .C(_1840_),
    .A(\pll_dig.ILL_N ),
    .Y(_2055_));
 sg13g2_o21ai_1 _3235_ (.B1(_2054_),
    .Y(_0422_),
    .A1(\pll_dig.ILL_P ),
    .A2(_2055_));
 sg13g2_nand3_1 _3236_ (.B(_2005_),
    .C(_2007_),
    .A(\pll_dig.ENABLE ),
    .Y(_2056_));
 sg13g2_o21ai_1 _3237_ (.B1(_2056_),
    .Y(_0424_),
    .A1(_0539_),
    .A2(_2005_));
 sg13g2_nand3_1 _3238_ (.B(\pll_dig.cntf[1] ),
    .C(_1832_),
    .A(\pll_dig.cntf[0] ),
    .Y(_2057_));
 sg13g2_xnor2_1 _3239_ (.Y(_0620_),
    .A(net3),
    .B(net4));
 sg13g2_a21oi_1 _3240_ (.A1(_0445_),
    .A2(_2057_),
    .Y(_0434_),
    .B1(_2050_));
 sg13g2_inv_1 _3241_ (.Y(_0244_),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3242_ (.Y(_0243_),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3243_ (.Y(_0242_),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3244_ (.Y(_0241_),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3245_ (.Y(_0240_),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_nand3_1 _3246_ (.B(net1),
    .C(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .A(net113),
    .Y(_0621_));
 sg13g2_inv_1 _3247_ (.Y(_0239_),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3248__261 (.Y(net260),
    .A(clknet_4_9_0_net59_regs));
 sg13g2_inv_1 _3249_ (.Y(_0237_),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3250_ (.Y(_0236_),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3251_ (.Y(_0234_),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3252_ (.Y(_0233_),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3253_ (.Y(_0232_),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3254_ (.Y(_0231_),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3255_ (.Y(_0230_),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3256__262 (.Y(net261),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_nor3_2 _3257_ (.A(net2),
    .B(_0620_),
    .C(net309),
    .Y(_0622_));
 sg13g2_inv_1 _3258__263 (.Y(net262),
    .A(clknet_4_14_0_net59_regs));
 sg13g2_inv_1 _3259__264 (.Y(net263),
    .A(clknet_4_12_0_net59_regs));
 sg13g2_inv_1 _3260_ (.Y(_0225_),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3261_ (.Y(_0224_),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3262_ (.Y(_0223_),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3263_ (.Y(_0222_),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3264_ (.Y(_0221_),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3265_ (.Y(_0220_),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3266_ (.Y(_0219_),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3267_ (.Y(_0218_),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_xnor2_1 _3268_ (.Y(_0623_),
    .A(\pll_dig.dsm_impl.FCWF[0] ),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[0] ));
 sg13g2_inv_1 _3269_ (.Y(_0217_),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3270_ (.Y(_0216_),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3271_ (.Y(_0215_),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3272_ (.Y(_0214_),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3273_ (.Y(_0212_),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3274_ (.Y(_0211_),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3275_ (.Y(_0210_),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3276_ (.Y(_0209_),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3277_ (.Y(_0208_),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3278_ (.Y(_0207_),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_nor4_2 _3279_ (.A(_0621_),
    .B(_0620_),
    .C(net2),
    .Y(_0624_),
    .D(_0623_));
 sg13g2_inv_1 _3280_ (.Y(_0206_),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3281_ (.Y(_0205_),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3282_ (.Y(_0204_),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3283__265 (.Y(net264),
    .A(clknet_4_0_0_net59_regs));
 sg13g2_inv_1 _3284__266 (.Y(net265),
    .A(clknet_4_12_0_net59_regs));
 sg13g2_inv_1 _3285_ (.Y(_0199_),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3286_ (.Y(_0198_),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3287__267 (.Y(net266),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_inv_1 _3288_ (.Y(_0196_),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3289_ (.Y(_0195_),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_xor2_1 _3290_ (.B(\pll_dig.dsm_impl.FCWF[1] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .X(_0625_));
 sg13g2_inv_1 _3291_ (.Y(_0194_),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3292_ (.Y(_0193_),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3293_ (.Y(_0192_),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3294_ (.Y(_0191_),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3295_ (.Y(_0190_),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3296_ (.Y(_0189_),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3297_ (.Y(_0188_),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3298_ (.Y(_0187_),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3299_ (.Y(_0186_),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3300_ (.Y(_0185_),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3301_ (.Y(_0452_),
    .A(\pll_dig.dlf.INT[3] ));
 sg13g2_o21ai_1 _3302_ (.B1(_0625_),
    .Y(_0626_),
    .A1(_0624_),
    .A2(_0617_));
 sg13g2_inv_1 _3303_ (.Y(_0184_),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3304_ (.Y(_0183_),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3305_ (.Y(_0181_),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3306__268 (.Y(net267),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_inv_1 _3307_ (.Y(_0179_),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3308__269 (.Y(net268),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_inv_1 _3309_ (.Y(_0177_),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3310_ (.Y(_0176_),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3311_ (.Y(_0175_),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3312_ (.Y(_0174_),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_and2_1 _3313_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B(\pll_dig.dsm_impl.FCWF[2] ),
    .X(_0627_));
 sg13g2_inv_1 _3314_ (.Y(_0173_),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3315_ (.Y(_0171_),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3316_ (.Y(_0170_),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3317_ (.Y(_0169_),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3318_ (.Y(_0168_),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3319_ (.Y(_0167_),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3320_ (.Y(_0166_),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3321_ (.Y(_0165_),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3322_ (.Y(_0164_),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3323_ (.Y(_0163_),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_xnor2_1 _3324_ (.Y(_0628_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B(\pll_dig.dsm_impl.FCWF[2] ));
 sg13g2_inv_1 _3325_ (.Y(_0162_),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3326_ (.Y(_0161_),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3327_ (.Y(_0160_),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3328_ (.Y(_0159_),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3329_ (.Y(_0158_),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3330_ (.Y(_0157_),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3331_ (.Y(_0156_),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3332_ (.Y(_0155_),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3333_ (.Y(_0154_),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3334_ (.Y(_0153_),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_a21oi_2 _3335_ (.B1(_0628_),
    .Y(_0629_),
    .A2(_0616_),
    .A1(_0626_));
 sg13g2_mux2_1 _3336_ (.A0(net155),
    .A1(\pll_dig.div.div_pend[2] ),
    .S(net350),
    .X(\pll_dig.div.low_count_pend[1] ));
 sg13g2_mux2_1 _3337_ (.A0(net154),
    .A1(\pll_dig.div.div_pend[3] ),
    .S(net350),
    .X(\pll_dig.div.low_count_pend[2] ));
 sg13g2_mux2_1 _3338_ (.A0(net152),
    .A1(\pll_dig.div.div_pend[4] ),
    .S(net353),
    .X(\pll_dig.div.low_count_pend[3] ));
 sg13g2_mux2_1 _3339_ (.A0(net151),
    .A1(\pll_dig.div.div_pend[5] ),
    .S(net82),
    .X(\pll_dig.div.low_count_pend[4] ));
 sg13g2_mux2_1 _3340_ (.A0(net150),
    .A1(\pll_dig.div.div_pend[6] ),
    .S(net357),
    .X(\pll_dig.div.low_count_pend[5] ));
 sg13g2_mux2_1 _3341_ (.A0(net149),
    .A1(\pll_dig.div.div_pend[7] ),
    .S(net82),
    .X(\pll_dig.div.low_count_pend[6] ));
 sg13g2_nand3_1 _3342_ (.B(net296),
    .C(_0628_),
    .A(_0616_),
    .Y(_0630_));
 sg13g2_nand2b_2 _3343_ (.Y(_0631_),
    .B(_0630_),
    .A_N(_0629_));
 sg13g2_nor2_1 _3344_ (.A(_0540_),
    .B(_0631_),
    .Y(_0632_));
 sg13g2_or3_1 _3345_ (.A(_0617_),
    .B(_0624_),
    .C(_0625_),
    .X(_0633_));
 sg13g2_and2_2 _3346_ (.A(_0633_),
    .B(_0626_),
    .X(_0634_));
 sg13g2_and2_1 _3347_ (.A(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .B(net298),
    .X(_0635_));
 sg13g2_inv_1 _3348_ (.Y(_0453_),
    .A(\pll_dig.flock.cnt[8] ));
 sg13g2_xor2_1 _3349_ (.B(_0622_),
    .A(net314),
    .X(_0636_));
 sg13g2_nor2_1 _3350_ (.A(_0524_),
    .B(net275),
    .Y(_0637_));
 sg13g2_xnor2_1 _3351_ (.Y(_0638_),
    .A(_0636_),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[0] ));
 sg13g2_nor3_1 _3352_ (.A(_0546_),
    .B(_0620_),
    .C(net276),
    .Y(_0639_));
 sg13g2_a21o_1 _3353_ (.A2(_0639_),
    .A1(_0638_),
    .B1(_0637_),
    .X(_0640_));
 sg13g2_xor2_1 _3354_ (.B(_0634_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .X(_0641_));
 sg13g2_a21o_1 _3355_ (.A2(_0640_),
    .A1(_0641_),
    .B1(_0635_),
    .X(_0642_));
 sg13g2_xnor2_1 _3356_ (.Y(_0643_),
    .A(_0631_),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[2] ));
 sg13g2_a21oi_2 _3357_ (.B1(_0632_),
    .Y(_0644_),
    .A2(_0642_),
    .A1(_0643_));
 sg13g2_nand2_1 _3358_ (.Y(_0645_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .B(\pll_dig.dsm_impl.FCWF[3] ));
 sg13g2_inv_1 _3359_ (.Y(_0454_),
    .A(\pll_dig.div.leave_req ));
 sg13g2_xor2_1 _3360_ (.B(\pll_dig.dsm_impl.FCWF[3] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .X(_0646_));
 sg13g2_o21ai_1 _3361_ (.B1(_0646_),
    .Y(_0647_),
    .A1(_0629_),
    .A2(_0627_));
 sg13g2_or3_1 _3362_ (.A(_0627_),
    .B(_0629_),
    .C(_0646_),
    .X(_0648_));
 sg13g2_and2_2 _3363_ (.A(_0647_),
    .B(_0648_),
    .X(_0649_));
 sg13g2_nand2_1 _3364_ (.Y(_0650_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .B(_0649_));
 sg13g2_xnor2_1 _3365_ (.Y(_0651_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .B(_0649_));
 sg13g2_xor2_1 _3366_ (.B(_0651_),
    .A(_0644_),
    .X(_0652_));
 sg13g2_and2_1 _3367_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .B(_0652_),
    .X(_0653_));
 sg13g2_or2_1 _3368_ (.X(_0654_),
    .B(_0652_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[3] ));
 sg13g2_nor2b_1 _3369_ (.A(_0653_),
    .B_N(_0654_),
    .Y(_0655_));
 sg13g2_inv_1 _3370_ (.Y(_0455_),
    .A(\pll_dig.flock.FCW_NA[6] ));
 sg13g2_xnor2_1 _3371_ (.Y(_0656_),
    .A(_0642_),
    .B(_0643_));
 sg13g2_or2_1 _3372_ (.X(_0657_),
    .B(_0656_),
    .A(_0475_));
 sg13g2_xnor2_1 _3373_ (.Y(_0658_),
    .A(net310),
    .B(net305));
 sg13g2_nor2_1 _3374_ (.A(_0542_),
    .B(_0658_),
    .Y(_0659_));
 sg13g2_nand2_1 _3375_ (.Y(_0660_),
    .A(_0542_),
    .B(_0658_));
 sg13g2_nand2b_1 _3376_ (.Y(_0661_),
    .B(_0660_),
    .A_N(_0659_));
 sg13g2_xor2_1 _3377_ (.B(_0639_),
    .A(net307),
    .X(_0662_));
 sg13g2_nand2_1 _3378_ (.Y(_0663_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .B(_0662_));
 sg13g2_inv_1 _3379_ (.Y(_0664_),
    .A(_0663_));
 sg13g2_a21oi_1 _3380_ (.A1(_0660_),
    .A2(_0664_),
    .Y(_0665_),
    .B1(_0659_));
 sg13g2_inv_1 _3381_ (.Y(_0456_),
    .A(\pll_dig.flock.FCW_NA[3] ));
 sg13g2_xnor2_1 _3382_ (.Y(_0666_),
    .A(_0475_),
    .B(_0656_));
 sg13g2_o21ai_1 _3383_ (.B1(_0657_),
    .Y(_0667_),
    .A1(_0666_),
    .A2(_0665_));
 sg13g2_o21ai_1 _3384_ (.B1(net114),
    .Y(_0668_),
    .A1(_0655_),
    .A2(net283));
 sg13g2_a21o_1 _3385_ (.A2(net283),
    .A1(_0655_),
    .B1(_0668_),
    .X(_0669_));
 sg13g2_o21ai_1 _3386_ (.B1(_0669_),
    .Y(_0438_),
    .A1(_2061_),
    .A2(net114));
 sg13g2_nand2_1 _3387_ (.Y(_0670_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(\pll_dig.dsm_impl.FCWF[7] ));
 sg13g2_and2_1 _3388_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .B(\pll_dig.dsm_impl.FCWF[6] ),
    .X(_0671_));
 sg13g2_nand2_1 _3389_ (.Y(_0672_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .B(\pll_dig.dsm_impl.FCWF[5] ));
 sg13g2_and2_1 _3390_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .B(\pll_dig.dsm_impl.FCWF[4] ),
    .X(_0673_));
 sg13g2_xnor2_1 _3391_ (.Y(_0674_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .B(\pll_dig.dsm_impl.FCWF[4] ));
 sg13g2_inv_1 _3392_ (.Y(_0457_),
    .A(\pll_dig.flock.FCW_PA[1] ));
 sg13g2_a21oi_2 _3393_ (.B1(_0674_),
    .Y(_0675_),
    .A2(_0647_),
    .A1(_0645_));
 sg13g2_xor2_1 _3394_ (.B(\pll_dig.dsm_impl.FCWF[5] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .X(_0676_));
 sg13g2_o21ai_1 _3395_ (.B1(_0676_),
    .Y(_0677_),
    .A1(_0675_),
    .A2(_0673_));
 sg13g2_xnor2_1 _3396_ (.Y(_0678_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .B(\pll_dig.dsm_impl.FCWF[6] ));
 sg13g2_a21oi_2 _3397_ (.B1(_0678_),
    .Y(_0679_),
    .A2(_0672_),
    .A1(_0677_));
 sg13g2_xor2_1 _3398_ (.B(\pll_dig.dsm_impl.FCWF[7] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .X(_0680_));
 sg13g2_o21ai_1 _3399_ (.B1(_0680_),
    .Y(_0681_),
    .A1(_0679_),
    .A2(_0671_));
 sg13g2_xnor2_1 _3400_ (.Y(_0682_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .B(\pll_dig.dsm_impl.FCWF[8] ));
 sg13g2_a21oi_2 _3401_ (.B1(_0682_),
    .Y(_0683_),
    .A2(net369),
    .A1(_0670_));
 sg13g2_nand3_1 _3402_ (.B(net290),
    .C(_0682_),
    .A(_0670_),
    .Y(_0684_));
 sg13g2_inv_1 _3403_ (.Y(_0458_),
    .A(\pll_dig.flock.FCW_NA[0] ));
 sg13g2_nand2b_1 _3404_ (.Y(_0685_),
    .B(_0684_),
    .A_N(_0683_));
 sg13g2_nor2_1 _3405_ (.A(_0541_),
    .B(_0685_),
    .Y(_0686_));
 sg13g2_or3_1 _3406_ (.A(_0671_),
    .B(_0679_),
    .C(_0680_),
    .X(_0687_));
 sg13g2_nand2_2 _3407_ (.Y(_0688_),
    .A(net369),
    .B(_0687_));
 sg13g2_nand3_1 _3408_ (.B(net291),
    .C(_0687_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[7] ),
    .Y(_0689_));
 sg13g2_nand3_1 _3409_ (.B(net286),
    .C(_0678_),
    .A(_0672_),
    .Y(_0690_));
 sg13g2_nand2b_1 _3410_ (.Y(_0691_),
    .B(_0690_),
    .A_N(_0679_));
 sg13g2_nor2_1 _3411_ (.A(_0487_),
    .B(_0691_),
    .Y(_0692_));
 sg13g2_or3_1 _3412_ (.A(_0673_),
    .B(_0675_),
    .C(_0676_),
    .X(_0693_));
 sg13g2_nand2_1 _3413_ (.Y(_0694_),
    .A(_0677_),
    .B(_0693_));
 sg13g2_inv_1 _3414_ (.Y(_0459_),
    .A(\pll_dig.flock.FCW_PA[5] ));
 sg13g2_nand3_1 _3415_ (.B(net285),
    .C(_0693_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[5] ),
    .Y(_0695_));
 sg13g2_nand3_1 _3416_ (.B(net306),
    .C(_0674_),
    .A(_0645_),
    .Y(_0696_));
 sg13g2_nand2b_2 _3417_ (.Y(_0697_),
    .B(_0696_),
    .A_N(_0675_));
 sg13g2_nor2_1 _3418_ (.A(_0463_),
    .B(_0697_),
    .Y(_0698_));
 sg13g2_o21ai_1 _3419_ (.B1(_0650_),
    .Y(_0699_),
    .A1(_0651_),
    .A2(_0644_));
 sg13g2_nand2_1 _3420_ (.Y(_0700_),
    .A(_0463_),
    .B(_0697_));
 sg13g2_xnor2_1 _3421_ (.Y(_0701_),
    .A(_0463_),
    .B(_0697_));
 sg13g2_a21oi_1 _3422_ (.A1(_0699_),
    .A2(_0700_),
    .Y(_0702_),
    .B1(_0698_));
 sg13g2_a21o_1 _3423_ (.A2(_0700_),
    .A1(net279),
    .B1(_0698_),
    .X(_0703_));
 sg13g2_xnor2_1 _3424_ (.Y(_0704_),
    .A(_0439_),
    .B(_0694_));
 sg13g2_inv_1 _3425_ (.Y(_0460_),
    .A(\pll_dig.flock.cnt_done[7] ));
 sg13g2_o21ai_1 _3426_ (.B1(_0695_),
    .Y(_0705_),
    .A1(_0704_),
    .A2(_0702_));
 sg13g2_nand2_1 _3427_ (.Y(_0706_),
    .A(_0487_),
    .B(_0691_));
 sg13g2_xnor2_1 _3428_ (.Y(_0707_),
    .A(_0487_),
    .B(_0691_));
 sg13g2_a21oi_2 _3429_ (.B1(_0692_),
    .Y(_0708_),
    .A2(_0706_),
    .A1(net405));
 sg13g2_a21o_1 _3430_ (.A2(_0706_),
    .A1(net405),
    .B1(_0692_),
    .X(_0709_));
 sg13g2_xnor2_1 _3431_ (.Y(_0710_),
    .A(_0533_),
    .B(_0688_));
 sg13g2_o21ai_1 _3432_ (.B1(_0689_),
    .Y(_0711_),
    .A1(_0710_),
    .A2(_0708_));
 sg13g2_nand2_1 _3433_ (.Y(_0712_),
    .A(_0541_),
    .B(_0685_));
 sg13g2_xnor2_1 _3434_ (.Y(_0713_),
    .A(_0541_),
    .B(_0685_));
 sg13g2_a21oi_2 _3435_ (.B1(_0686_),
    .Y(_0714_),
    .A2(_0711_),
    .A1(_0712_));
 sg13g2_inv_1 _3436_ (.Y(_2061_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[3] ));
 sg13g2_inv_1 _3437_ (.Y(_0461_),
    .A(\pll_dig.flock.cnt_done[5] ));
 sg13g2_a21o_1 _3438_ (.A2(\pll_dig.dsm_impl.FCWF[8] ),
    .A1(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .B1(_0683_),
    .X(_0715_));
 sg13g2_and2_1 _3439_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .B(\pll_dig.dsm_impl.FCWF[9] ),
    .X(_0716_));
 sg13g2_xor2_1 _3440_ (.B(\pll_dig.dsm_impl.FCWF[9] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .X(_0717_));
 sg13g2_xnor2_1 _3441_ (.Y(_0718_),
    .A(_0717_),
    .B(_0715_));
 sg13g2_or2_1 _3442_ (.X(_0719_),
    .B(_0718_),
    .A(_0473_));
 sg13g2_xnor2_1 _3443_ (.Y(_0720_),
    .A(_0473_),
    .B(_0718_));
 sg13g2_xor2_1 _3444_ (.B(_0720_),
    .A(net404),
    .X(_0721_));
 sg13g2_and2_1 _3445_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .B(_0721_),
    .X(_0722_));
 sg13g2_xnor2_1 _3446_ (.Y(_0723_),
    .A(_0713_),
    .B(_0711_));
 sg13g2_nand2_1 _3447_ (.Y(_0724_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .B(net288));
 sg13g2_inv_1 _3448_ (.Y(_0462_),
    .A(net9));
 sg13g2_xnor2_1 _3449_ (.Y(_0725_),
    .A(_0709_),
    .B(_0710_));
 sg13g2_and2_1 _3450_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[7] ),
    .B(_0725_),
    .X(_0726_));
 sg13g2_xnor2_1 _3451_ (.Y(_0727_),
    .A(_0707_),
    .B(net405));
 sg13g2_nand2_1 _3452_ (.Y(_0728_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .B(net274));
 sg13g2_xnor2_1 _3453_ (.Y(_0729_),
    .A(_0703_),
    .B(_0704_));
 sg13g2_and2_1 _3454_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .B(_0729_),
    .X(_0730_));
 sg13g2_xnor2_1 _3455_ (.Y(_0731_),
    .A(_0701_),
    .B(net281));
 sg13g2_nand2_1 _3456_ (.Y(_0732_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .B(net273));
 sg13g2_a21oi_1 _3457_ (.A1(_0654_),
    .A2(_0667_),
    .Y(_0733_),
    .B1(_0653_));
 sg13g2_xnor2_1 _3458_ (.Y(_0734_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .B(_0731_));
 sg13g2_inv_1 _3459_ (.Y(_0463_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[4] ));
 sg13g2_o21ai_1 _3460_ (.B1(_0732_),
    .Y(_0735_),
    .A1(_0734_),
    .A2(_0733_));
 sg13g2_or2_1 _3461_ (.X(_0736_),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .A(_0729_));
 sg13g2_nand2b_1 _3462_ (.Y(_0737_),
    .B(net297),
    .A_N(_0730_));
 sg13g2_nand2b_1 _3463_ (.Y(_0738_),
    .B(net293),
    .A_N(_0737_));
 sg13g2_a21oi_2 _3464_ (.B1(_0730_),
    .Y(_0739_),
    .A2(_0736_),
    .A1(_0735_));
 sg13g2_xnor2_1 _3465_ (.Y(_0740_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .B(_0727_));
 sg13g2_o21ai_1 _3466_ (.B1(_0728_),
    .Y(_0741_),
    .A1(_0740_),
    .A2(_0739_));
 sg13g2_or2_1 _3467_ (.X(_0742_),
    .B(_0725_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[7] ));
 sg13g2_nand2b_1 _3468_ (.Y(_0743_),
    .B(_0742_),
    .A_N(_0726_));
 sg13g2_nand2b_1 _3469_ (.Y(_0744_),
    .B(net277),
    .A_N(_0743_));
 sg13g2_inv_1 _3470_ (.Y(_0464_),
    .A(\pll_dig.flock.freq_miss[1] ));
 sg13g2_a21oi_2 _3471_ (.B1(_0726_),
    .Y(_0745_),
    .A2(_0741_),
    .A1(_0742_));
 sg13g2_xnor2_1 _3472_ (.Y(_0746_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .B(_0723_));
 sg13g2_o21ai_1 _3473_ (.B1(_0724_),
    .Y(_0747_),
    .A1(_0746_),
    .A2(_0745_));
 sg13g2_or2_1 _3474_ (.X(_0748_),
    .B(_0721_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[9] ));
 sg13g2_nand2b_1 _3475_ (.Y(_0749_),
    .B(_0748_),
    .A_N(_0722_));
 sg13g2_nand2b_1 _3476_ (.Y(_0750_),
    .B(net280),
    .A_N(_0749_));
 sg13g2_a21oi_2 _3477_ (.B1(_0722_),
    .Y(_0751_),
    .A2(_0747_),
    .A1(_0748_));
 sg13g2_o21ai_1 _3478_ (.B1(_0719_),
    .Y(_0752_),
    .A1(_0720_),
    .A2(_0714_));
 sg13g2_a21o_1 _3479_ (.A2(_0717_),
    .A1(_0715_),
    .B1(_0716_),
    .X(_0753_));
 sg13g2_or2_1 _3480_ (.X(_0754_),
    .B(\pll_dig.dsm_impl.FCWF[10] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[10] ));
 sg13g2_inv_1 _3481_ (.Y(_0465_),
    .A(\pll_dig.dlf.INT[13] ));
 sg13g2_and2_1 _3482_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .B(\pll_dig.dsm_impl.FCWF[10] ),
    .X(_0755_));
 sg13g2_xor2_1 _3483_ (.B(\pll_dig.dsm_impl.FCWF[10] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .X(_0756_));
 sg13g2_xnor2_1 _3484_ (.Y(_0757_),
    .A(_0753_),
    .B(_0756_));
 sg13g2_nor2b_1 _3485_ (.A(_0757_),
    .B_N(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .Y(_0758_));
 sg13g2_xnor2_1 _3486_ (.Y(_0759_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .B(_0757_));
 sg13g2_xor2_1 _3487_ (.B(_0752_),
    .A(_0759_),
    .X(_0760_));
 sg13g2_nand2_1 _3488_ (.Y(_0761_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .B(net278));
 sg13g2_xnor2_1 _3489_ (.Y(_0762_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .B(_0760_));
 sg13g2_xnor2_1 _3490_ (.Y(_0763_),
    .A(net295),
    .B(_0762_));
 sg13g2_nor2_1 _3491_ (.A(net121),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .Y(_0764_));
 sg13g2_inv_1 _3492_ (.Y(_0466_),
    .A(\pll_dig.dlf.INT[10] ));
 sg13g2_a21oi_1 _3493_ (.A1(net122),
    .A2(_0763_),
    .Y(_0437_),
    .B1(_0764_));
 sg13g2_nand2_1 _3494_ (.Y(_0765_),
    .A(net115),
    .B(_0729_));
 sg13g2_o21ai_1 _3495_ (.B1(_0765_),
    .Y(_0436_),
    .A1(net115),
    .A2(_0439_));
 sg13g2_nor2_1 _3496_ (.A(net113),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .Y(_0766_));
 sg13g2_a21oi_1 _3497_ (.A1(net113),
    .A2(net275),
    .Y(_0435_),
    .B1(_0766_));
 sg13g2_nor2_1 _3498_ (.A(\pll_dig.FILTER_DEC[4] ),
    .B(\pll_dig.FILTER_DEC[3] ),
    .Y(_0767_));
 sg13g2_inv_1 _3499_ (.Y(\pll_dig.FINE_MUX_D[7] ),
    .A(net99));
 sg13g2_a21o_1 _3500_ (.A2(\pll_dig.FILTER_DEC[3] ),
    .A1(net103),
    .B1(\pll_dig.FILTER_DEC[4] ),
    .X(\pll_dig.FINE_MUX_D[11] ));
 sg13g2_nand2_1 _3501_ (.Y(_0768_),
    .A(net12),
    .B(_0514_));
 sg13g2_nand2b_1 _3502_ (.Y(_0769_),
    .B(\pll_dig.flock.cnt_filt[6] ),
    .A_N(net11));
 sg13g2_inv_1 _3503_ (.Y(_0467_),
    .A(\pll_dig.COARSE_MUX_D[1] ));
 sg13g2_a22oi_1 _3504_ (.Y(_0770_),
    .B1(_0537_),
    .B2(net10),
    .A2(_0518_),
    .A1(net11));
 sg13g2_nand3_1 _3505_ (.B(_0769_),
    .C(_0770_),
    .A(_0768_),
    .Y(_0771_));
 sg13g2_a22oi_1 _3506_ (.Y(_0772_),
    .B1(\pll_dig.flock.cnt_filt[5] ),
    .B2(_0486_),
    .A2(\pll_dig.flock.cnt_filt[4] ),
    .A1(_0462_));
 sg13g2_nand2_1 _3507_ (.Y(_0773_),
    .A(net9),
    .B(_0495_));
 sg13g2_nand2b_1 _3508_ (.Y(_0774_),
    .B(\pll_dig.flock.cnt_filt[2] ),
    .A_N(net7));
 sg13g2_nor2_1 _3509_ (.A(_0485_),
    .B(net146),
    .Y(_0775_));
 sg13g2_a21oi_1 _3510_ (.A1(net7),
    .A2(_0472_),
    .Y(_0776_),
    .B1(_0775_));
 sg13g2_nand2_1 _3511_ (.Y(_0777_),
    .A(_0774_),
    .B(_0776_));
 sg13g2_nand2b_1 _3512_ (.Y(_0778_),
    .B(net5),
    .A_N(\pll_dig.flock.cnt_filt[0] ));
 sg13g2_o21ai_1 _3513_ (.B1(_0778_),
    .Y(_0779_),
    .A1(net147),
    .A2(_0471_));
 sg13g2_inv_1 _3514_ (.Y(_0468_),
    .A(\pll_dig.flock.freq_miss[2] ));
 sg13g2_nand2_1 _3515_ (.Y(_0780_),
    .A(net147),
    .B(_0471_));
 sg13g2_a21oi_1 _3516_ (.A1(_0779_),
    .A2(_0780_),
    .Y(_0781_),
    .B1(_0777_));
 sg13g2_nand2_1 _3517_ (.Y(_0782_),
    .A(_0485_),
    .B(net146));
 sg13g2_o21ai_1 _3518_ (.B1(_0782_),
    .Y(_0783_),
    .A1(_0774_),
    .A2(_0775_));
 sg13g2_o21ai_1 _3519_ (.B1(_0773_),
    .Y(_0784_),
    .A1(_0781_),
    .A2(_0783_));
 sg13g2_a21oi_1 _3520_ (.A1(_0772_),
    .A2(_0784_),
    .Y(_0785_),
    .B1(_0771_));
 sg13g2_nand3b_1 _3521_ (.B(\pll_dig.flock.cnt_filt[6] ),
    .C(_0768_),
    .Y(_0786_),
    .A_N(net11));
 sg13g2_or2_1 _3522_ (.X(_0787_),
    .B(\pll_dig.flock.cnt_filt[10] ),
    .A(\pll_dig.flock.cnt_filt[11] ));
 sg13g2_or2_1 _3523_ (.X(_0788_),
    .B(\pll_dig.flock.cnt_filt[12] ),
    .A(\pll_dig.flock.cnt_filt[13] ));
 sg13g2_nor4_1 _3524_ (.A(\pll_dig.flock.cnt_filt[14] ),
    .B(\pll_dig.flock.cnt_filt[15] ),
    .C(_0787_),
    .D(_0788_),
    .Y(_0789_));
 sg13g2_inv_1 _3525_ (.Y(_0469_),
    .A(\pll_dig.MID_MUX_D[0] ));
 sg13g2_nand2_1 _3526_ (.Y(_0790_),
    .A(_0484_),
    .B(\pll_dig.flock.cnt_filt[7] ));
 sg13g2_nor2_1 _3527_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .Y(_0791_));
 sg13g2_nand2_1 _3528_ (.Y(_0792_),
    .A(_0786_),
    .B(_0790_));
 sg13g2_nand2_1 _3529_ (.Y(_0793_),
    .A(_0789_),
    .B(_0791_));
 sg13g2_nor3_1 _3530_ (.A(_0785_),
    .B(_0792_),
    .C(_0793_),
    .Y(_0794_));
 sg13g2_nand2_1 _3531_ (.Y(_0795_),
    .A(net535),
    .B(\pll_dig.PHASE_LOCK ));
 sg13g2_a21oi_1 _3532_ (.A1(_0794_),
    .A2(net536),
    .Y(_0796_),
    .B1(\pll_dig.FORCE_N ));
 sg13g2_nor2b_1 _3533_ (.A(_0796_),
    .B_N(\pll_dig.flock.started ),
    .Y(_0797_));
 sg13g2_nand2_1 _3534_ (.Y(_0798_),
    .A(_0469_),
    .B(net94));
 sg13g2_nor2_1 _3535_ (.A(\pll_dig.flock.cnt_coarse_wait[0] ),
    .B(\pll_dig.flock.cnt_coarse_wait[1] ),
    .Y(_0799_));
 sg13g2_inv_1 _3536_ (.Y(_0470_),
    .A(net147));
 sg13g2_nand2b_1 _3537_ (.Y(_0800_),
    .B(_0799_),
    .A_N(\pll_dig.flock.cnt_coarse_wait[2] ));
 sg13g2_nor2_1 _3538_ (.A(\pll_dig.flock.cnt_coarse_wait[3] ),
    .B(_0800_),
    .Y(_0801_));
 sg13g2_nor3_1 _3539_ (.A(\pll_dig.flock.cnt_coarse_wait[4] ),
    .B(\pll_dig.flock.cnt_coarse_wait[3] ),
    .C(_0800_),
    .Y(_0802_));
 sg13g2_nor2b_1 _3540_ (.A(\pll_dig.flock.cnt_coarse_wait[5] ),
    .B_N(_0802_),
    .Y(_0803_));
 sg13g2_nor2b_1 _3541_ (.A(\pll_dig.flock.cnt_coarse_wait[6] ),
    .B_N(_0803_),
    .Y(_0804_));
 sg13g2_nor2b_1 _3542_ (.A(\pll_dig.flock.cnt_coarse_wait[7] ),
    .B_N(_0804_),
    .Y(_0805_));
 sg13g2_nand2b_1 _3543_ (.Y(_0806_),
    .B(_0804_),
    .A_N(\pll_dig.flock.cnt_coarse_wait[7] ));
 sg13g2_nand2_1 _3544_ (.Y(_0807_),
    .A(\pll_dig.COARSE_MUX_D[0] ),
    .B(_0805_));
 sg13g2_nor2b_1 _3545_ (.A(_0798_),
    .B_N(_0807_),
    .Y(_0808_));
 sg13g2_nand3_1 _3546_ (.B(net94),
    .C(_0807_),
    .A(_0469_),
    .Y(_0809_));
 sg13g2_inv_1 _3547_ (.Y(_0439_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[5] ));
 sg13g2_inv_1 _3548_ (.Y(_0471_),
    .A(net6));
 sg13g2_nand2_1 _3549_ (.Y(_0810_),
    .A(\pll_dig.flock.cnt_filt[0] ),
    .B(_0096_));
 sg13g2_nand3_1 _3550_ (.B(_0782_),
    .C(_0810_),
    .A(_0780_),
    .Y(_0811_));
 sg13g2_nand3_1 _3551_ (.B(_0773_),
    .C(_0790_),
    .A(_0772_),
    .Y(_0812_));
 sg13g2_nor3_1 _3552_ (.A(_0771_),
    .B(_0777_),
    .C(_0811_),
    .Y(_0813_));
 sg13g2_nor3_1 _3553_ (.A(_0779_),
    .B(_0793_),
    .C(_0812_),
    .Y(_0814_));
 sg13g2_a221oi_1 _3554_ (.B2(_0814_),
    .C1(_0794_),
    .B1(_0813_),
    .A1(net535),
    .Y(_0815_),
    .A2(\pll_dig.PHASE_LOCK ));
 sg13g2_nor2_1 _3555_ (.A(\pll_dig.FORCE_P ),
    .B(_0815_),
    .Y(_0816_));
 sg13g2_nor2b_1 _3556_ (.A(_0816_),
    .B_N(\pll_dig.flock.started ),
    .Y(_0817_));
 sg13g2_o21ai_1 _3557_ (.B1(\pll_dig.MID_MUX_D[14] ),
    .Y(_0818_),
    .A1(\pll_dig.COARSE_MUX_D[14] ),
    .A2(_0806_));
 sg13g2_or2_1 _3558_ (.X(_0819_),
    .B(_0817_),
    .A(net94));
 sg13g2_inv_1 _3559_ (.Y(_0472_),
    .A(\pll_dig.flock.cnt_filt[2] ));
 sg13g2_a21oi_1 _3560_ (.A1(_0817_),
    .A2(_0818_),
    .Y(_0820_),
    .B1(net94));
 sg13g2_or2_1 _3561_ (.X(_0821_),
    .B(_0820_),
    .A(_0808_));
 sg13g2_and2_1 _3562_ (.A(\pll_dig.MID_MUX_D[0] ),
    .B(_0797_),
    .X(_0822_));
 sg13g2_and2_1 _3563_ (.A(\pll_dig.MID_MUX_D[2] ),
    .B(net93),
    .X(_0823_));
 sg13g2_o21ai_1 _3564_ (.B1(_0818_),
    .Y(_0824_),
    .A1(\pll_dig.MID_MUX_D[0] ),
    .A2(\pll_dig.MID_MUX_D[14] ));
 sg13g2_nor2_1 _3565_ (.A(_0797_),
    .B(_0824_),
    .Y(_0825_));
 sg13g2_nor2_1 _3566_ (.A(_0798_),
    .B(_0807_),
    .Y(_0826_));
 sg13g2_nor2_1 _3567_ (.A(_0798_),
    .B(_0806_),
    .Y(_0827_));
 sg13g2_nor4_1 _3568_ (.A(net76),
    .B(_0823_),
    .C(_0825_),
    .D(net81),
    .Y(_0828_));
 sg13g2_a21oi_1 _3569_ (.A1(_0441_),
    .A2(net79),
    .Y(_0433_),
    .B1(_0828_));
 sg13g2_inv_1 _3570_ (.Y(_0473_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[9] ));
 sg13g2_nor2_1 _3571_ (.A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .Y(_0829_));
 sg13g2_or2_1 _3572_ (.X(_0830_),
    .B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ));
 sg13g2_and3_2 _3573_ (.X(_0831_),
    .A(\pll_dig.flock.cnt[2] ),
    .B(\pll_dig.flock.cnt[3] ),
    .C(\pll_dig.flock.cnt[1] ));
 sg13g2_and3_1 _3574_ (.X(_0832_),
    .A(_0831_),
    .B(\pll_dig.flock.cnt[4] ),
    .C(\pll_dig.flock.cnt[5] ));
 sg13g2_nand3_1 _3575_ (.B(\pll_dig.flock.cnt[6] ),
    .C(\pll_dig.flock.cnt[7] ),
    .A(_0832_),
    .Y(_0833_));
 sg13g2_nor2_2 _3576_ (.A(_0833_),
    .B(_0453_),
    .Y(_0834_));
 sg13g2_nand3_1 _3577_ (.B(\pll_dig.flock.cnt[9] ),
    .C(\pll_dig.flock.cnt[10] ),
    .A(_0834_),
    .Y(_0835_));
 sg13g2_nor2_2 _3578_ (.A(_0483_),
    .B(net385),
    .Y(_0836_));
 sg13g2_and3_2 _3579_ (.X(_0837_),
    .A(\pll_dig.flock.cnt[12] ),
    .B(_0836_),
    .C(\pll_dig.flock.cnt[13] ));
 sg13g2_nor3_2 _3580_ (.A(net415),
    .B(net126),
    .C(_0483_),
    .Y(_0838_));
 sg13g2_inv_1 _3581_ (.Y(_0474_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[9] ));
 sg13g2_nand4_1 _3582_ (.B(\pll_dig.flock.cnt[13] ),
    .C(\pll_dig.flock.cnt[14] ),
    .A(_0838_),
    .Y(_0839_),
    .D(\pll_dig.flock.cnt[12] ));
 sg13g2_nand4_1 _3583_ (.B(\pll_dig.flock.cnt[14] ),
    .C(net129),
    .A(_0837_),
    .Y(_0840_),
    .D(\pll_dig.flock.cnt[15] ));
 sg13g2_xnor2_1 _3584_ (.Y(_0432_),
    .A(\pll_dig.flock.cnt[15] ),
    .B(_0839_));
 sg13g2_nor2_1 _3585_ (.A(\pll_dig.MID_MUX_D[14] ),
    .B(_0797_),
    .Y(_0841_));
 sg13g2_a221oi_1 _3586_ (.B2(\pll_dig.MID_MUX_D[6] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[8] ),
    .Y(_0842_),
    .A2(net92));
 sg13g2_nand2_1 _3587_ (.Y(_0843_),
    .A(\pll_dig.MID_MUX_D[7] ),
    .B(net77));
 sg13g2_o21ai_1 _3588_ (.B1(_0843_),
    .Y(_0431_),
    .A1(net77),
    .A2(_0842_));
 sg13g2_nor2_1 _3589_ (.A(\pll_dig.flock.cnt[9] ),
    .B(net386),
    .Y(_0844_));
 sg13g2_xor2_1 _3590_ (.B(_0844_),
    .A(\pll_dig.flock.cnt[10] ),
    .X(_0845_));
 sg13g2_nand2_1 _3591_ (.Y(_0846_),
    .A(\pll_dig.flock.cnt_gray[8] ),
    .B(net126));
 sg13g2_inv_1 _3592_ (.Y(_0475_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[2] ));
 sg13g2_o21ai_1 _3593_ (.B1(_0846_),
    .Y(_0430_),
    .A1(net126),
    .A2(_0845_));
 sg13g2_and2_1 _3594_ (.A(\pll_dig.COARSE_MUX_D[0] ),
    .B(net94),
    .X(_0847_));
 sg13g2_a21o_1 _3595_ (.A2(_0817_),
    .A1(_0796_),
    .B1(net89),
    .X(_0848_));
 sg13g2_nor2_1 _3596_ (.A(_0482_),
    .B(net94),
    .Y(_0849_));
 sg13g2_nor3_1 _3597_ (.A(_0806_),
    .B(net93),
    .C(net91),
    .Y(_0850_));
 sg13g2_nor2b_1 _3598_ (.A(_0849_),
    .B_N(_0850_),
    .Y(_0851_));
 sg13g2_nor4_1 _3599_ (.A(_0806_),
    .B(net93),
    .C(net91),
    .D(_0849_),
    .Y(_0852_));
 sg13g2_and2_1 _3600_ (.A(_0848_),
    .B(_0852_),
    .X(_0853_));
 sg13g2_nor2_1 _3601_ (.A(\pll_dig.COARSE_MUX_D[4] ),
    .B(net74),
    .Y(_0854_));
 sg13g2_nor2_1 _3602_ (.A(\pll_dig.COARSE_MUX_D[14] ),
    .B(net94),
    .Y(_0855_));
 sg13g2_inv_1 _3603_ (.Y(_0476_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[7] ));
 sg13g2_a22oi_1 _3604_ (.Y(_0856_),
    .B1(net87),
    .B2(\pll_dig.COARSE_MUX_D[3] ),
    .A2(net89),
    .A1(\pll_dig.COARSE_MUX_D[5] ));
 sg13g2_a21oi_1 _3605_ (.A1(net74),
    .A2(_0856_),
    .Y(_0429_),
    .B1(_0854_));
 sg13g2_a221oi_1 _3606_ (.B2(\pll_dig.MID_MUX_D[5] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[7] ),
    .Y(_0857_),
    .A2(net92));
 sg13g2_nand2_1 _3607_ (.Y(_0858_),
    .A(\pll_dig.MID_MUX_D[6] ),
    .B(net78));
 sg13g2_o21ai_1 _3608_ (.B1(_0858_),
    .Y(_0428_),
    .A1(net78),
    .A2(_0857_));
 sg13g2_nand2_1 _3609_ (.Y(_0859_),
    .A(_0453_),
    .B(_0833_));
 sg13g2_xnor2_1 _3610_ (.Y(_0860_),
    .A(\pll_dig.flock.cnt[9] ),
    .B(_0859_));
 sg13g2_nor2_1 _3611_ (.A(\pll_dig.flock.cnt_gray[7] ),
    .B(net130),
    .Y(_0861_));
 sg13g2_a21oi_1 _3612_ (.A1(net130),
    .A2(_0860_),
    .Y(_0427_),
    .B1(_0861_));
 sg13g2_nor2_1 _3613_ (.A(\pll_dig.COARSE_MUX_D[2] ),
    .B(net74),
    .Y(_0862_));
 sg13g2_inv_1 _3614_ (.Y(_0477_),
    .A(net315));
 sg13g2_a22oi_1 _3615_ (.Y(_0863_),
    .B1(net87),
    .B2(\pll_dig.COARSE_MUX_D[1] ),
    .A2(net89),
    .A1(\pll_dig.COARSE_MUX_D[3] ));
 sg13g2_a21oi_1 _3616_ (.A1(net74),
    .A2(_0863_),
    .Y(_0426_),
    .B1(_0862_));
 sg13g2_a221oi_1 _3617_ (.B2(\pll_dig.MID_MUX_D[11] ),
    .C1(net81),
    .B1(net91),
    .A1(\pll_dig.MID_MUX_D[13] ),
    .Y(_0864_),
    .A2(net93));
 sg13g2_nand2_1 _3618_ (.Y(_0865_),
    .A(\pll_dig.MID_MUX_D[12] ),
    .B(net76));
 sg13g2_o21ai_1 _3619_ (.B1(_0865_),
    .Y(_0425_),
    .A1(net76),
    .A2(_0864_));
 sg13g2_nor2_1 _3620_ (.A(\pll_dig.COARSE_MUX_D[9] ),
    .B(net72),
    .Y(_0866_));
 sg13g2_a22oi_1 _3621_ (.Y(_0867_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[8] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[10] ));
 sg13g2_a21oi_1 _3622_ (.A1(net72),
    .A2(_0867_),
    .Y(_0423_),
    .B1(_0866_));
 sg13g2_xor2_1 _3623_ (.B(\pll_dig.flock.cnt_gray_s2[14] ),
    .A(\pll_dig.flock.cnt_gray_s2[15] ),
    .X(_0110_));
 sg13g2_xnor2_1 _3624_ (.Y(_0868_),
    .A(\pll_dig.flock.cnt_gray_s2[13] ),
    .B(_0110_));
 sg13g2_inv_1 _3625_ (.Y(_0478_),
    .A(net111));
 sg13g2_inv_1 _3626_ (.Y(_0109_),
    .A(_0868_));
 sg13g2_nand3_1 _3627_ (.B(\pll_dig.out_edges[0] ),
    .C(\pll_dig.out_edges[2] ),
    .A(\pll_dig.out_edges[1] ),
    .Y(_0869_));
 sg13g2_nor2_1 _3628_ (.A(_0449_),
    .B(_0869_),
    .Y(_0870_));
 sg13g2_nor2_1 _3629_ (.A(\pll_dig.out_edges[4] ),
    .B(_0870_),
    .Y(_0871_));
 sg13g2_xor2_1 _3630_ (.B(_0870_),
    .A(\pll_dig.out_edges[4] ),
    .X(\pll_dig.out_edges_next[4] ));
 sg13g2_a21o_1 _3631_ (.A2(\pll_dig.out_edges[0] ),
    .A1(\pll_dig.out_edges[1] ),
    .B1(\pll_dig.out_edges[2] ),
    .X(_0872_));
 sg13g2_and2_1 _3632_ (.A(_0869_),
    .B(_0872_),
    .X(\pll_dig.out_edges_next[2] ));
 sg13g2_and3_1 _3633_ (.X(_0873_),
    .A(\pll_dig.out_edges[4] ),
    .B(\pll_dig.out_edges[5] ),
    .C(_0870_));
 sg13g2_nor2_1 _3634_ (.A(\pll_dig.out_edges[6] ),
    .B(_0873_),
    .Y(_0874_));
 sg13g2_xnor2_1 _3635_ (.Y(_0006_),
    .A(\pll_dig.out_edges[7] ),
    .B(_0874_));
 sg13g2_inv_1 _3636_ (.Y(_0479_),
    .A(\pll_dig.flock.FCW_NA[2] ));
 sg13g2_xnor2_1 _3637_ (.Y(_0002_),
    .A(_0449_),
    .B(_0872_));
 sg13g2_xor2_1 _3638_ (.B(\pll_dig.out_edges_g2_q[1] ),
    .A(\pll_dig.out_edges_g2[1] ),
    .X(_0875_));
 sg13g2_xor2_1 _3639_ (.B(\pll_dig.out_edges_g2_q[8] ),
    .A(\pll_dig.out_edges_g2[8] ),
    .X(_0876_));
 sg13g2_nor2b_1 _3640_ (.A(\pll_dig.out_edges_g2_q[5] ),
    .B_N(\pll_dig.out_edges_g2[5] ),
    .Y(_0877_));
 sg13g2_nor4_1 _3641_ (.A(_0520_),
    .B(_0875_),
    .C(_0876_),
    .D(_0877_),
    .Y(_0878_));
 sg13g2_xor2_1 _3642_ (.B(\pll_dig.out_edges_g2_q[2] ),
    .A(\pll_dig.out_edges_g2[2] ),
    .X(_0879_));
 sg13g2_a221oi_1 _3643_ (.B2(_0511_),
    .C1(_0879_),
    .B1(\pll_dig.out_edges_g2[3] ),
    .A1(\pll_dig.out_edges_g2[9] ),
    .Y(_0880_),
    .A2(_0510_));
 sg13g2_nor2b_1 _3644_ (.A(\pll_dig.out_edges_g2[5] ),
    .B_N(\pll_dig.out_edges_g2_q[5] ),
    .Y(_0881_));
 sg13g2_nor2b_1 _3645_ (.A(\pll_dig.out_edges_g2_q[0] ),
    .B_N(\pll_dig.out_edges_g2[0] ),
    .Y(_0882_));
 sg13g2_nor2b_1 _3646_ (.A(\pll_dig.out_edges_g2_q[4] ),
    .B_N(\pll_dig.out_edges_g2[4] ),
    .Y(_0883_));
 sg13g2_inv_1 _3647_ (.Y(_0480_),
    .A(\pll_dig.dlf.INT[6] ));
 sg13g2_nor2b_1 _3648_ (.A(\pll_dig.out_edges_g2[7] ),
    .B_N(\pll_dig.out_edges_g2_q[7] ),
    .Y(_0884_));
 sg13g2_nor4_1 _3649_ (.A(_0881_),
    .B(_0882_),
    .C(_0883_),
    .D(_0884_),
    .Y(_0885_));
 sg13g2_nor2b_1 _3650_ (.A(\pll_dig.out_edges_g2[6] ),
    .B_N(\pll_dig.out_edges_g2_q[6] ),
    .Y(_0886_));
 sg13g2_nor2_1 _3651_ (.A(\pll_dig.out_edges_g2[3] ),
    .B(_0511_),
    .Y(_0887_));
 sg13g2_nor2b_1 _3652_ (.A(\pll_dig.out_edges_g2_q[6] ),
    .B_N(\pll_dig.out_edges_g2[6] ),
    .Y(_0888_));
 sg13g2_nand2b_1 _3653_ (.Y(_0889_),
    .B(\pll_dig.out_edges_g2_q[9] ),
    .A_N(\pll_dig.out_edges_g2[9] ));
 sg13g2_nand2b_1 _3654_ (.Y(_0890_),
    .B(\pll_dig.out_edges_g2[7] ),
    .A_N(\pll_dig.out_edges_g2_q[7] ));
 sg13g2_nand2b_1 _3655_ (.Y(_0891_),
    .B(\pll_dig.out_edges_g2_q[4] ),
    .A_N(\pll_dig.out_edges_g2[4] ));
 sg13g2_nand2b_1 _3656_ (.Y(_0892_),
    .B(\pll_dig.out_edges_g2_q[0] ),
    .A_N(\pll_dig.out_edges_g2[0] ));
 sg13g2_nand4_1 _3657_ (.B(_0890_),
    .C(_0891_),
    .A(_0889_),
    .Y(_0893_),
    .D(_0892_));
 sg13g2_inv_1 _3658_ (.Y(_0440_),
    .A(\pll_dig.FILTER_DEC[4] ));
 sg13g2_inv_1 _3659_ (.Y(_0481_),
    .A(\pll_dig.FORCE_P ));
 sg13g2_nor4_1 _3660_ (.A(_0886_),
    .B(_0887_),
    .C(_0888_),
    .D(_0893_),
    .Y(_0894_));
 sg13g2_nand4_1 _3661_ (.B(_0880_),
    .C(_0885_),
    .A(_0878_),
    .Y(_0895_),
    .D(_0894_));
 sg13g2_o21ai_1 _3662_ (.B1(\pll_dig.dco_miss_cnt[0] ),
    .Y(_0896_),
    .A1(_0450_),
    .A2(_0895_));
 sg13g2_nor2_1 _3663_ (.A(\pll_dig.dco_miss_cnt[2] ),
    .B(_0895_),
    .Y(_0897_));
 sg13g2_o21ai_1 _3664_ (.B1(_0896_),
    .Y(_0898_),
    .A1(\pll_dig.dco_miss_cnt[0] ),
    .A2(_0897_));
 sg13g2_inv_1 _3665_ (.Y(_0417_),
    .A(_0898_));
 sg13g2_and2_1 _3666_ (.A(\pll_dig.dco_miss_cnt[0] ),
    .B(\pll_dig.dco_miss_cnt[1] ),
    .X(_0899_));
 sg13g2_nor2_1 _3667_ (.A(\pll_dig.dco_miss_cnt[2] ),
    .B(_0899_),
    .Y(_0900_));
 sg13g2_nor2_1 _3668_ (.A(_0895_),
    .B(_0900_),
    .Y(_0416_));
 sg13g2_nand3_1 _3669_ (.B(\pll_dig.div.cnt[2] ),
    .C(\pll_dig.div.cnt[1] ),
    .A(\pll_dig.div.cnt[0] ),
    .Y(_0901_));
 sg13g2_inv_1 _3670_ (.Y(_0482_),
    .A(\pll_dig.COARSE_MUX_D[14] ));
 sg13g2_nor2_2 _3671_ (.A(_0901_),
    .B(_0547_),
    .Y(_0902_));
 sg13g2_nand3_1 _3672_ (.B(_0902_),
    .C(\pll_dig.div.cnt[5] ),
    .A(\pll_dig.div.cnt[4] ),
    .Y(_0903_));
 sg13g2_nand4_1 _3673_ (.B(\pll_dig.div.cnt[5] ),
    .C(\pll_dig.div.cnt[6] ),
    .A(\pll_dig.div.cnt[4] ),
    .Y(_0904_),
    .D(net330));
 sg13g2_xor2_1 _3674_ (.B(\pll_dig.div.cnt[6] ),
    .A(_0903_),
    .X(_0905_));
 sg13g2_a21o_1 _3675_ (.A2(\pll_dig.div.cnt[4] ),
    .A1(_0902_),
    .B1(\pll_dig.div.cnt[5] ),
    .X(_0906_));
 sg13g2_nand2_2 _3676_ (.Y(_0907_),
    .A(_0906_),
    .B(net331));
 sg13g2_a21o_1 _3677_ (.A2(\pll_dig.div.cnt[1] ),
    .A1(\pll_dig.div.cnt[0] ),
    .B1(\pll_dig.div.cnt[2] ),
    .X(_0908_));
 sg13g2_nand2_2 _3678_ (.Y(_0909_),
    .A(net329),
    .B(_0908_));
 sg13g2_nor2_1 _3679_ (.A(\pll_dig.div.low_count[2] ),
    .B(net343),
    .Y(_0910_));
 sg13g2_xnor2_1 _3680_ (.Y(_0911_),
    .A(net352),
    .B(net351));
 sg13g2_inv_1 _3681_ (.Y(_0483_),
    .A(\pll_dig.flock.cnt[11] ));
 sg13g2_nor2_1 _3682_ (.A(\pll_dig.div.low_count[1] ),
    .B(net351),
    .Y(_0912_));
 sg13g2_nor3_1 _3683_ (.A(_2058_),
    .B(_0132_),
    .C(_0912_),
    .Y(_0913_));
 sg13g2_a221oi_1 _3684_ (.B2(\pll_dig.div.low_count[1] ),
    .C1(_0913_),
    .B1(_0911_),
    .A1(_0909_),
    .Y(_0914_),
    .A2(\pll_dig.div.low_count[2] ));
 sg13g2_nor2_2 _3685_ (.A(_0910_),
    .B(_0914_),
    .Y(_0915_));
 sg13g2_xnor2_1 _3686_ (.Y(_0916_),
    .A(net329),
    .B(_0547_));
 sg13g2_xnor2_1 _3687_ (.Y(_0917_),
    .A(_0902_),
    .B(\pll_dig.div.cnt[4] ));
 sg13g2_or2_1 _3688_ (.X(_0918_),
    .B(_0917_),
    .A(\pll_dig.div.low_count[4] ));
 sg13g2_o21ai_1 _3689_ (.B1(_0915_),
    .Y(_0919_),
    .A1(\pll_dig.div.low_count[3] ),
    .A2(_0916_));
 sg13g2_a22oi_1 _3690_ (.Y(_0920_),
    .B1(_0917_),
    .B2(\pll_dig.div.low_count[4] ),
    .A2(_0916_),
    .A1(\pll_dig.div.low_count[3] ));
 sg13g2_o21ai_1 _3691_ (.B1(_0918_),
    .Y(_0921_),
    .A1(\pll_dig.div.low_count[5] ),
    .A2(_0907_));
 sg13g2_inv_1 _3692_ (.Y(_0096_),
    .A(net5));
 sg13g2_a21oi_2 _3693_ (.B1(_0921_),
    .Y(_0922_),
    .A2(_0920_),
    .A1(_0919_));
 sg13g2_a221oi_1 _3694_ (.B2(\pll_dig.div.low_count[5] ),
    .C1(_0922_),
    .B1(net340),
    .A1(_0905_),
    .Y(_0923_),
    .A2(\pll_dig.div.low_count[6] ));
 sg13g2_xor2_1 _3695_ (.B(\pll_dig.div.cnt[7] ),
    .A(_0904_),
    .X(_0924_));
 sg13g2_o21ai_1 _3696_ (.B1(_0924_),
    .Y(_0925_),
    .A1(\pll_dig.div.low_count[6] ),
    .A2(net338));
 sg13g2_nand2b_1 _3697_ (.Y(_0926_),
    .B(\pll_dig.div.pend ),
    .A_N(net237));
 sg13g2_nor4_1 _3698_ (.A(net148),
    .B(\pll_dig.div.leave_req ),
    .C(\pll_dig.div.use_clk_p ),
    .D(_0926_),
    .Y(_0927_));
 sg13g2_o21ai_1 _3699_ (.B1(_0927_),
    .Y(_0928_),
    .A1(_0925_),
    .A2(_0923_));
 sg13g2_and2_2 _3700_ (.A(_0928_),
    .B(_0454_),
    .X(_0929_));
 sg13g2_nor2_2 _3701_ (.A(\pll_dig.div.use_clk_p ),
    .B(_0929_),
    .Y(_0930_));
 sg13g2_inv_16 _3702_ (.A(net82),
    .Y(_0931_));
 sg13g2_inv_1 _3703_ (.Y(_0484_),
    .A(net12));
 sg13g2_mux2_1 _3704_ (.A0(net327),
    .A1(\pll_dig.div.div_pend[0] ),
    .S(net350),
    .X(_0415_));
 sg13g2_mux2_1 _3705_ (.A0(net155),
    .A1(\pll_dig.div.div_pend[2] ),
    .S(net350),
    .X(_0414_));
 sg13g2_mux2_1 _3706_ (.A0(net152),
    .A1(\pll_dig.div.div_pend[4] ),
    .S(net350),
    .X(_0413_));
 sg13g2_mux2_1 _3707_ (.A0(net150),
    .A1(\pll_dig.div.div_pend[6] ),
    .S(net357),
    .X(_0412_));
 sg13g2_mux2_1 _3708_ (.A0(\pll_dig.div.low_count[3] ),
    .A1(\pll_dig.div.high_count[3] ),
    .S(net148),
    .X(_0932_));
 sg13g2_or2_1 _3709_ (.X(_0933_),
    .B(_0915_),
    .A(net148));
 sg13g2_nor2_1 _3710_ (.A(net351),
    .B(\pll_dig.div.high_count[1] ),
    .Y(_0934_));
 sg13g2_nor3_1 _3711_ (.A(_2058_),
    .B(_0136_),
    .C(_0934_),
    .Y(_0935_));
 sg13g2_a21o_1 _3712_ (.A2(_0911_),
    .A1(\pll_dig.div.high_count[1] ),
    .B1(_0935_),
    .X(_0936_));
 sg13g2_o21ai_1 _3713_ (.B1(_0936_),
    .Y(_0937_),
    .A1(\pll_dig.div.high_count[2] ),
    .A2(net342));
 sg13g2_inv_1 _3714_ (.Y(_0485_),
    .A(net8));
 sg13g2_nand2_1 _3715_ (.Y(_0938_),
    .A(\pll_dig.div.high_count[2] ),
    .B(net342));
 sg13g2_nand3_1 _3716_ (.B(_0938_),
    .C(_0937_),
    .A(net148),
    .Y(_0939_));
 sg13g2_a22oi_1 _3717_ (.Y(_0940_),
    .B1(_0939_),
    .B2(_0933_),
    .A2(_0932_),
    .A1(net341));
 sg13g2_mux2_1 _3718_ (.A0(\pll_dig.div.low_count[4] ),
    .A1(\pll_dig.div.high_count[4] ),
    .S(\pll_dig.div.high_phase ),
    .X(_0941_));
 sg13g2_nor2_1 _3719_ (.A(net334),
    .B(_0941_),
    .Y(_0942_));
 sg13g2_nor2_1 _3720_ (.A(net341),
    .B(_0932_),
    .Y(_0943_));
 sg13g2_nor3_2 _3721_ (.A(_0943_),
    .B(_0942_),
    .C(_0940_),
    .Y(_0944_));
 sg13g2_mux2_1 _3722_ (.A0(\pll_dig.div.low_count[5] ),
    .A1(\pll_dig.div.high_count[5] ),
    .S(net148),
    .X(_0945_));
 sg13g2_a221oi_1 _3723_ (.B2(_0945_),
    .C1(_0944_),
    .B1(net339),
    .A1(net333),
    .Y(_0946_),
    .A2(_0941_));
 sg13g2_nor2_1 _3724_ (.A(net339),
    .B(_0945_),
    .Y(_0947_));
 sg13g2_inv_1 _3725_ (.Y(_0486_),
    .A(net10));
 sg13g2_mux2_1 _3726_ (.A0(\pll_dig.div.low_count[6] ),
    .A1(\pll_dig.div.high_count[6] ),
    .S(net148),
    .X(_0948_));
 sg13g2_nor2_1 _3727_ (.A(_0905_),
    .B(_0948_),
    .Y(_0949_));
 sg13g2_nor3_2 _3728_ (.A(_0949_),
    .B(_0947_),
    .C(_0946_),
    .Y(_0950_));
 sg13g2_and2_1 _3729_ (.A(net148),
    .B(\pll_dig.div.high_count[7] ),
    .X(_0951_));
 sg13g2_a221oi_1 _3730_ (.B2(net344),
    .C1(_0950_),
    .B1(_0951_),
    .A1(net332),
    .Y(_0952_),
    .A2(_0948_));
 sg13g2_nor3_2 _3731_ (.A(\pll_dig.div.leave_req ),
    .B(\pll_dig.div.use_clk_p ),
    .C(_0952_),
    .Y(_0953_));
 sg13g2_o21ai_1 _3732_ (.B1(_0953_),
    .Y(_0954_),
    .A1(net344),
    .A2(_0951_));
 sg13g2_nor2_1 _3733_ (.A(\pll_dig.div.div_pend[3] ),
    .B(\pll_dig.div.div_pend[4] ),
    .Y(_0955_));
 sg13g2_nor4_1 _3734_ (.A(\pll_dig.div.div_pend[6] ),
    .B(\pll_dig.div.div_pend[7] ),
    .C(\pll_dig.div.div_pend[5] ),
    .D(\pll_dig.div.div_pend[2] ),
    .Y(_0956_));
 sg13g2_nand3_1 _3735_ (.B(_0955_),
    .C(_0956_),
    .A(_0128_),
    .Y(_0957_));
 sg13g2_inv_1 _3736_ (.Y(_0487_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[6] ));
 sg13g2_nand4_1 _3737_ (.B(_0128_),
    .C(_0955_),
    .A(\pll_dig.div.div_pend[0] ),
    .Y(_0958_),
    .D(_0956_));
 sg13g2_nor2_2 _3738_ (.A(_0958_),
    .B(net335),
    .Y(_0959_));
 sg13g2_or2_1 _3739_ (.X(_0960_),
    .B(_0959_),
    .A(\pll_dig.div.use_clk_p ));
 sg13g2_a21oi_1 _3740_ (.A1(net148),
    .A2(_0454_),
    .Y(_0961_),
    .B1(_0960_));
 sg13g2_xnor2_1 _3741_ (.Y(_0411_),
    .A(net70),
    .B(_0961_));
 sg13g2_nor2_1 _3742_ (.A(net126),
    .B(_0833_),
    .Y(_0962_));
 sg13g2_nand3_1 _3743_ (.B(\pll_dig.flock.cnt[9] ),
    .C(_0962_),
    .A(\pll_dig.flock.cnt[8] ),
    .Y(_0963_));
 sg13g2_a21oi_1 _3744_ (.A1(\pll_dig.flock.cnt[9] ),
    .A2(net386),
    .Y(_0964_),
    .B1(\pll_dig.flock.cnt[10] ));
 sg13g2_xnor2_1 _3745_ (.Y(_0410_),
    .A(\pll_dig.flock.cnt[10] ),
    .B(_0963_));
 sg13g2_a21oi_1 _3746_ (.A1(net417),
    .A2(net416),
    .Y(_0965_),
    .B1(net418));
 sg13g2_inv_1 _3747_ (.Y(_0488_),
    .A(\pll_dig.MID_MUX_D[13] ));
 sg13g2_nor2_1 _3748_ (.A(net125),
    .B(_0965_),
    .Y(_0966_));
 sg13g2_mux2_1 _3749_ (.A0(\pll_dig.flock.cnt_gray[2] ),
    .A1(\pll_dig.flock.cnt[4] ),
    .S(net127),
    .X(_0967_));
 sg13g2_nor2_1 _3750_ (.A(_0966_),
    .B(_0967_),
    .Y(_0968_));
 sg13g2_a21oi_1 _3751_ (.A1(\pll_dig.flock.cnt[4] ),
    .A2(_0966_),
    .Y(_0409_),
    .B1(_0968_));
 sg13g2_nand2_2 _3752_ (.Y(_0969_),
    .A(_0483_),
    .B(net379));
 sg13g2_xnor2_1 _3753_ (.Y(_0970_),
    .A(\pll_dig.flock.cnt[12] ),
    .B(_0969_));
 sg13g2_nor2_1 _3754_ (.A(\pll_dig.flock.cnt_gray[10] ),
    .B(net128),
    .Y(_0971_));
 sg13g2_a21oi_1 _3755_ (.A1(net128),
    .A2(_0970_),
    .Y(_0408_),
    .B1(_0971_));
 sg13g2_xor2_1 _3756_ (.B(\pll_dig.ref_wd.watch_s3 ),
    .A(\pll_dig.ref_wd.watch_s2 ),
    .X(_0972_));
 sg13g2_xnor2_1 _3757_ (.Y(_0973_),
    .A(\pll_dig.ref_wd.watch_s2 ),
    .B(\pll_dig.ref_wd.watch_s3 ));
 sg13g2_inv_1 _3758_ (.Y(_0489_),
    .A(\pll_dig.flock.FCW_NA[4] ));
 sg13g2_nand2_1 _3759_ (.Y(_0974_),
    .A(\pll_dig.ref_wd.cnt[9] ),
    .B(_0973_));
 sg13g2_a21oi_1 _3760_ (.A1(_0521_),
    .A2(_0973_),
    .Y(_0975_),
    .B1(\pll_dig.ref_wd.cnt[0] ));
 sg13g2_a21oi_1 _3761_ (.A1(\pll_dig.ref_wd.cnt[0] ),
    .A2(_0974_),
    .Y(_0407_),
    .B1(_0975_));
 sg13g2_nand2_1 _3762_ (.Y(_0976_),
    .A(\pll_dig.ref_wd.cnt[8] ),
    .B(_0973_));
 sg13g2_and2_1 _3763_ (.A(\pll_dig.ref_wd.cnt[0] ),
    .B(\pll_dig.ref_wd.cnt[1] ),
    .X(_0977_));
 sg13g2_and4_1 _3764_ (.A(\pll_dig.ref_wd.cnt[2] ),
    .B(\pll_dig.ref_wd.cnt[3] ),
    .C(\pll_dig.ref_wd.cnt[4] ),
    .D(_0977_),
    .X(_0978_));
 sg13g2_nand4_1 _3765_ (.B(\pll_dig.ref_wd.cnt[6] ),
    .C(\pll_dig.ref_wd.cnt[7] ),
    .A(\pll_dig.ref_wd.cnt[5] ),
    .Y(_0979_),
    .D(_0978_));
 sg13g2_nor2_1 _3766_ (.A(\pll_dig.ref_wd.cnt[9] ),
    .B(_0979_),
    .Y(_0980_));
 sg13g2_or4_1 _3767_ (.A(\pll_dig.ref_wd.cnt[8] ),
    .B(\pll_dig.ref_wd.cnt[9] ),
    .C(_0972_),
    .D(_0979_),
    .X(_0981_));
 sg13g2_o21ai_1 _3768_ (.B1(_0981_),
    .Y(_0406_),
    .A1(_0976_),
    .A2(_0980_));
 sg13g2_inv_1 _3769__270 (.Y(net269),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_inv_1 _3770_ (.Y(_0490_),
    .A(\pll_dig.flock.FCW_NA[5] ));
 sg13g2_nor2_1 _3771_ (.A(_0516_),
    .B(net132),
    .Y(_0982_));
 sg13g2_nand2b_1 _3772_ (.Y(_0983_),
    .B(net36),
    .A_N(net110));
 sg13g2_nor2b_1 _3773_ (.A(net36),
    .B_N(_0129_),
    .Y(_0984_));
 sg13g2_nor2_1 _3774_ (.A(_0496_),
    .B(net35),
    .Y(_0985_));
 sg13g2_xor2_1 _3775_ (.B(net35),
    .A(\pll_dig.dlf.INT[14] ),
    .X(_0986_));
 sg13g2_inv_1 _3776_ (.Y(_0987_),
    .A(_0986_));
 sg13g2_xor2_1 _3777_ (.B(net33),
    .A(\pll_dig.dlf.INT[12] ),
    .X(_0988_));
 sg13g2_inv_1 _3778_ (.Y(_0989_),
    .A(_0988_));
 sg13g2_nand2_1 _3779_ (.Y(_0990_),
    .A(\pll_dig.dlf.INT[11] ),
    .B(net32));
 sg13g2_and2_1 _3780_ (.A(\pll_dig.dlf.INT[10] ),
    .B(net31),
    .X(_0991_));
 sg13g2_inv_1 _3781_ (.Y(_0491_),
    .A(\pll_dig.flock.FCW_PA[8] ));
 sg13g2_xor2_1 _3782_ (.B(net31),
    .A(\pll_dig.dlf.INT[10] ),
    .X(_0992_));
 sg13g2_xor2_1 _3783_ (.B(net44),
    .A(\pll_dig.dlf.INT[8] ),
    .X(_0993_));
 sg13g2_xor2_1 _3784_ (.B(net42),
    .A(\pll_dig.dlf.INT[6] ),
    .X(_0994_));
 sg13g2_xor2_1 _3785_ (.B(net40),
    .A(\pll_dig.dlf.INT[4] ),
    .X(_0995_));
 sg13g2_xnor2_1 _3786_ (.Y(_0996_),
    .A(\pll_dig.dlf.INT[2] ),
    .B(net38));
 sg13g2_xor2_1 _3787_ (.B(net38),
    .A(\pll_dig.dlf.INT[2] ),
    .X(_0997_));
 sg13g2_nand2_1 _3788_ (.Y(_0998_),
    .A(\pll_dig.dlf.INT[1] ),
    .B(net37));
 sg13g2_xor2_1 _3789_ (.B(net37),
    .A(\pll_dig.dlf.INT[1] ),
    .X(_0999_));
 sg13g2_nand3_1 _3790_ (.B(net30),
    .C(_0999_),
    .A(\pll_dig.dlf.INT[0] ),
    .Y(_1000_));
 sg13g2_a21oi_1 _3791_ (.A1(_0998_),
    .A2(_1000_),
    .Y(_1001_),
    .B1(_0996_));
 sg13g2_inv_1 _3792_ (.Y(_0492_),
    .A(\pll_dig.flock.FCW_PA[4] ));
 sg13g2_a21oi_1 _3793_ (.A1(\pll_dig.dlf.INT[2] ),
    .A2(net38),
    .Y(_1002_),
    .B1(_1001_));
 sg13g2_nor2b_1 _3794_ (.A(\pll_dig.dlf.INT[3] ),
    .B_N(net39),
    .Y(_1003_));
 sg13g2_nand2b_1 _3795_ (.Y(_1004_),
    .B(\pll_dig.dlf.INT[3] ),
    .A_N(net39));
 sg13g2_nor2b_1 _3796_ (.A(_1003_),
    .B_N(_1004_),
    .Y(_1005_));
 sg13g2_nor2_1 _3797_ (.A(_1002_),
    .B(_1005_),
    .Y(_1006_));
 sg13g2_a21oi_1 _3798_ (.A1(\pll_dig.dlf.INT[3] ),
    .A2(net39),
    .Y(_1007_),
    .B1(_1006_));
 sg13g2_nor2b_1 _3799_ (.A(_1007_),
    .B_N(_0995_),
    .Y(_1008_));
 sg13g2_a21oi_1 _3800_ (.A1(\pll_dig.dlf.INT[4] ),
    .A2(net40),
    .Y(_1009_),
    .B1(_1008_));
 sg13g2_nor2b_1 _3801_ (.A(\pll_dig.dlf.INT[5] ),
    .B_N(net41),
    .Y(_1010_));
 sg13g2_nand2b_1 _3802_ (.Y(_1011_),
    .B(\pll_dig.dlf.INT[5] ),
    .A_N(net41));
 sg13g2_inv_1 _3803_ (.Y(_0493_),
    .A(\pll_dig.flock.cnt_cap[5] ));
 sg13g2_nor2b_1 _3804_ (.A(_1010_),
    .B_N(_1011_),
    .Y(_1012_));
 sg13g2_nor2_1 _3805_ (.A(_1009_),
    .B(_1012_),
    .Y(_1013_));
 sg13g2_a21oi_1 _3806_ (.A1(\pll_dig.dlf.INT[5] ),
    .A2(net41),
    .Y(_1014_),
    .B1(_1013_));
 sg13g2_nor2b_1 _3807_ (.A(_1014_),
    .B_N(_0994_),
    .Y(_1015_));
 sg13g2_a21oi_1 _3808_ (.A1(\pll_dig.dlf.INT[6] ),
    .A2(net42),
    .Y(_1016_),
    .B1(_1015_));
 sg13g2_nor2b_1 _3809_ (.A(\pll_dig.dlf.INT[7] ),
    .B_N(net43),
    .Y(_1017_));
 sg13g2_nand2b_1 _3810_ (.Y(_1018_),
    .B(\pll_dig.dlf.INT[7] ),
    .A_N(net43));
 sg13g2_nor2b_1 _3811_ (.A(_1017_),
    .B_N(_1018_),
    .Y(_1019_));
 sg13g2_nor2_1 _3812_ (.A(_1016_),
    .B(_1019_),
    .Y(_1020_));
 sg13g2_a21oi_1 _3813_ (.A1(\pll_dig.dlf.INT[7] ),
    .A2(net43),
    .Y(_1021_),
    .B1(_1020_));
 sg13g2_inv_1 _3814_ (.Y(_0494_),
    .A(\pll_dig.flock.cnt_cap[2] ));
 sg13g2_nor2b_1 _3815_ (.A(_1021_),
    .B_N(_0993_),
    .Y(_1022_));
 sg13g2_a21oi_1 _3816_ (.A1(\pll_dig.dlf.INT[8] ),
    .A2(net44),
    .Y(_1023_),
    .B1(_1022_));
 sg13g2_nor2b_1 _3817_ (.A(net111),
    .B_N(net45),
    .Y(_1024_));
 sg13g2_nand2b_1 _3818_ (.Y(_1025_),
    .B(net111),
    .A_N(net45));
 sg13g2_nor2b_1 _3819_ (.A(_1024_),
    .B_N(_1025_),
    .Y(_1026_));
 sg13g2_nor2_1 _3820_ (.A(_1023_),
    .B(_1026_),
    .Y(_1027_));
 sg13g2_a21oi_1 _3821_ (.A1(\pll_dig.dlf.INT[9] ),
    .A2(net45),
    .Y(_1028_),
    .B1(_1027_));
 sg13g2_nor2b_1 _3822_ (.A(_1028_),
    .B_N(_0992_),
    .Y(_1029_));
 sg13g2_xnor2_1 _3823_ (.Y(_1030_),
    .A(\pll_dig.dlf.INT[11] ),
    .B(net32));
 sg13g2_inv_1 _3824_ (.Y(_1031_),
    .A(_1030_));
 sg13g2_inv_1 _3825_ (.Y(_0495_),
    .A(\pll_dig.flock.cnt_filt[4] ));
 sg13g2_o21ai_1 _3826_ (.B1(_1031_),
    .Y(_1032_),
    .A1(_0991_),
    .A2(_1029_));
 sg13g2_a21oi_1 _3827_ (.A1(_0990_),
    .A2(_1032_),
    .Y(_1033_),
    .B1(_0989_));
 sg13g2_a21oi_1 _3828_ (.A1(\pll_dig.dlf.INT[12] ),
    .A2(net33),
    .Y(_1034_),
    .B1(_1033_));
 sg13g2_nand2b_1 _3829_ (.Y(_1035_),
    .B(\pll_dig.dlf.INT[13] ),
    .A_N(net34));
 sg13g2_nor2b_1 _3830_ (.A(\pll_dig.dlf.INT[13] ),
    .B_N(net34),
    .Y(_1036_));
 sg13g2_xnor2_1 _3831_ (.Y(_1037_),
    .A(\pll_dig.dlf.INT[13] ),
    .B(net34));
 sg13g2_nor2_1 _3832_ (.A(_1034_),
    .B(_1037_),
    .Y(_1038_));
 sg13g2_a21oi_1 _3833_ (.A1(\pll_dig.dlf.INT[13] ),
    .A2(net34),
    .Y(_1039_),
    .B1(_1038_));
 sg13g2_nor2_1 _3834_ (.A(_0987_),
    .B(_1039_),
    .Y(_1040_));
 sg13g2_a21oi_1 _3835_ (.A1(\pll_dig.dlf.INT[14] ),
    .A2(net35),
    .Y(_1041_),
    .B1(_1040_));
 sg13g2_inv_1 _3836_ (.Y(_0496_),
    .A(\pll_dig.dlf.INT[14] ));
 sg13g2_a21oi_1 _3837_ (.A1(_0983_),
    .A2(_1041_),
    .Y(_1042_),
    .B1(_0984_));
 sg13g2_nor3_1 _3838_ (.A(_0516_),
    .B(net133),
    .C(_1042_),
    .Y(_1043_));
 sg13g2_nand3_1 _3839_ (.B(_0998_),
    .C(_1000_),
    .A(_0996_),
    .Y(_1044_));
 sg13g2_nand2b_1 _3840_ (.Y(_1045_),
    .B(_1044_),
    .A_N(_1001_));
 sg13g2_nand2_1 _3841_ (.Y(_1046_),
    .A(_0516_),
    .B(\SS_BBPD[0] ));
 sg13g2_nand2b_1 _3842_ (.Y(_1047_),
    .B(\pll_dig.dlf.INT[11] ),
    .A_N(net32));
 sg13g2_nor2_1 _3843_ (.A(_0466_),
    .B(net31),
    .Y(_1048_));
 sg13g2_nor2b_1 _3844_ (.A(\pll_dig.dlf.INT[0] ),
    .B_N(net30),
    .Y(_1049_));
 sg13g2_nor2_1 _3845_ (.A(_0999_),
    .B(_1049_),
    .Y(_1050_));
 sg13g2_a21oi_1 _3846_ (.A1(\pll_dig.dlf.INT[1] ),
    .A2(_0545_),
    .Y(_1051_),
    .B1(_1050_));
 sg13g2_inv_1 _3847_ (.Y(_0497_),
    .A(\pll_dig.dlf.INT[12] ));
 sg13g2_nor2_1 _3848_ (.A(_0997_),
    .B(_1051_),
    .Y(_1052_));
 sg13g2_a21oi_1 _3849_ (.A1(\pll_dig.dlf.INT[2] ),
    .A2(_0544_),
    .Y(_1053_),
    .B1(_1052_));
 sg13g2_o21ai_1 _3850_ (.B1(_1004_),
    .Y(_1054_),
    .A1(_1003_),
    .A2(_1053_));
 sg13g2_nor2b_1 _3851_ (.A(_0995_),
    .B_N(_1054_),
    .Y(_1055_));
 sg13g2_a21oi_1 _3852_ (.A1(\pll_dig.dlf.INT[4] ),
    .A2(_0526_),
    .Y(_1056_),
    .B1(_1055_));
 sg13g2_o21ai_1 _3853_ (.B1(_1011_),
    .Y(_1057_),
    .A1(_1010_),
    .A2(_1056_));
 sg13g2_nor2b_1 _3854_ (.A(_0994_),
    .B_N(_1057_),
    .Y(_1058_));
 sg13g2_a21oi_1 _3855_ (.A1(\pll_dig.dlf.INT[6] ),
    .A2(_0543_),
    .Y(_1059_),
    .B1(_1058_));
 sg13g2_o21ai_1 _3856_ (.B1(_1018_),
    .Y(_1060_),
    .A1(_1017_),
    .A2(_1059_));
 sg13g2_nor2b_1 _3857_ (.A(_0993_),
    .B_N(_1060_),
    .Y(_1061_));
 sg13g2_inv_1 _3858_ (.Y(_0498_),
    .A(net17));
 sg13g2_a21oi_1 _3859_ (.A1(\pll_dig.dlf.INT[8] ),
    .A2(_0536_),
    .Y(_1062_),
    .B1(_1061_));
 sg13g2_o21ai_1 _3860_ (.B1(_1025_),
    .Y(_1063_),
    .A1(_1024_),
    .A2(_1062_));
 sg13g2_nor2b_1 _3861_ (.A(_0992_),
    .B_N(_1063_),
    .Y(_1064_));
 sg13g2_o21ai_1 _3862_ (.B1(_1030_),
    .Y(_1065_),
    .A1(_1048_),
    .A2(_1064_));
 sg13g2_a21oi_1 _3863_ (.A1(_1047_),
    .A2(_1065_),
    .Y(_1066_),
    .B1(_0988_));
 sg13g2_a21oi_1 _3864_ (.A1(\pll_dig.dlf.INT[12] ),
    .A2(_0528_),
    .Y(_1067_),
    .B1(_1066_));
 sg13g2_a21oi_1 _3865_ (.A1(_1035_),
    .A2(_1067_),
    .Y(_1068_),
    .B1(_1036_));
 sg13g2_a21oi_1 _3866_ (.A1(_0987_),
    .A2(_1068_),
    .Y(_1069_),
    .B1(_0985_));
 sg13g2_and2_1 _3867_ (.A(net36),
    .B(_1069_),
    .X(_1070_));
 sg13g2_or2_1 _3868_ (.X(_1071_),
    .B(_1069_),
    .A(net36));
 sg13g2_inv_1 _3869_ (.Y(_0499_),
    .A(\pll_dig.dlf.INT[7] ));
 sg13g2_o21ai_1 _3870_ (.B1(_1071_),
    .Y(_1072_),
    .A1(_0129_),
    .A2(_1070_));
 sg13g2_nor2b_1 _3871_ (.A(_1046_),
    .B_N(_1072_),
    .Y(_1073_));
 sg13g2_nand2_1 _3872_ (.Y(_1074_),
    .A(_0997_),
    .B(_1051_));
 sg13g2_nand3b_1 _3873_ (.B(net64),
    .C(_1074_),
    .Y(_1075_),
    .A_N(_1052_));
 sg13g2_a21oi_1 _3874_ (.A1(\pll_dig.dlf.INT[2] ),
    .A2(net132),
    .Y(_1076_),
    .B1(net108));
 sg13g2_a22oi_1 _3875_ (.Y(\pll_dig.dlf.OUT_C[2] ),
    .B1(_1075_),
    .B2(_1076_),
    .A2(_1045_),
    .A1(net61));
 sg13g2_or2_1 _3876_ (.X(_0052_),
    .B(\pll_dig.dco_fail ),
    .A(\pll_dig.ref_fail ));
 sg13g2_nand2_1 _3877_ (.Y(_1077_),
    .A(net103),
    .B(\pll_dig.FILTER_DEC[1] ));
 sg13g2_nand2_1 _3878_ (.Y(\pll_dig.FINE_MUX_D[5] ),
    .A(net100),
    .B(_1077_));
 sg13g2_nor2_1 _3879_ (.A(\pll_dig.FREQ_ERR ),
    .B(\pll_dig.FREQ_LOCKED ),
    .Y(_1078_));
 sg13g2_inv_1 _3880_ (.Y(_0245_),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3881_ (.Y(_0500_),
    .A(\pll_dig.flock.cnt_cap[3] ));
 sg13g2_nand2_1 _3882_ (.Y(_1079_),
    .A(\pll_dig.flock.started ),
    .B(_1078_));
 sg13g2_o21ai_1 _3883_ (.B1(\pll_dig.START ),
    .Y(_1080_),
    .A1(\pll_dig.FREQ_ERR ),
    .A2(\pll_dig.FREQ_LOCKED ));
 sg13g2_and2_1 _3884_ (.A(_1079_),
    .B(_1080_),
    .X(_1081_));
 sg13g2_nand2_1 _3885_ (.Y(_1082_),
    .A(\pll_dig.flock.cnt_done[6] ),
    .B(_1081_));
 sg13g2_a22oi_1 _3886_ (.Y(_1083_),
    .B1(net147),
    .B2(_0457_),
    .A2(\pll_dig.flock.cnt_filt[0] ),
    .A1(_0458_));
 sg13g2_a221oi_1 _3887_ (.B2(\pll_dig.flock.FCW_PA[2] ),
    .C1(_1083_),
    .B1(_0472_),
    .A1(\pll_dig.flock.FCW_PA[1] ),
    .Y(_1084_),
    .A2(_0470_));
 sg13g2_a221oi_1 _3888_ (.B2(\pll_dig.flock.cnt_filt[2] ),
    .C1(_1084_),
    .B1(_0535_),
    .A1(_0519_),
    .Y(_1085_),
    .A2(net146));
 sg13g2_a221oi_1 _3889_ (.B2(_0530_),
    .C1(_1085_),
    .B1(\pll_dig.flock.FCW_PA[3] ),
    .A1(\pll_dig.flock.FCW_PA[4] ),
    .Y(_1086_),
    .A2(_0495_));
 sg13g2_a22oi_1 _3890_ (.Y(_1087_),
    .B1(\pll_dig.flock.cnt_filt[5] ),
    .B2(_0459_),
    .A2(\pll_dig.flock.cnt_filt[4] ),
    .A1(_0492_));
 sg13g2_nand2b_1 _3891_ (.Y(_1088_),
    .B(_1087_),
    .A_N(_1086_));
 sg13g2_inv_1 _3892_ (.Y(_0501_),
    .A(\pll_dig.flock.cnt_cap[4] ));
 sg13g2_a22oi_1 _3893_ (.Y(_1089_),
    .B1(_0537_),
    .B2(\pll_dig.flock.FCW_PA[5] ),
    .A2(\pll_dig.flock.FCW_PA[6] ),
    .A1(_0518_));
 sg13g2_nor2_1 _3894_ (.A(_0514_),
    .B(net532),
    .Y(_1090_));
 sg13g2_a221oi_1 _3895_ (.B2(_1089_),
    .C1(_1090_),
    .B1(_1088_),
    .A1(\pll_dig.flock.cnt_filt[6] ),
    .Y(_1091_),
    .A2(_0534_));
 sg13g2_a221oi_1 _3896_ (.B2(_0514_),
    .C1(_1091_),
    .B1(net532),
    .A1(\pll_dig.flock.FCW_PA[8] ),
    .Y(_1092_),
    .A2(_0515_));
 sg13g2_nand2b_1 _3897_ (.Y(_1093_),
    .B(net147),
    .A_N(\pll_dig.flock.FCW_NA[1] ));
 sg13g2_nor2b_1 _3898_ (.A(\pll_dig.flock.cnt_filt[0] ),
    .B_N(\pll_dig.flock.FCW_NA[0] ),
    .Y(_1094_));
 sg13g2_nor2b_1 _3899_ (.A(net147),
    .B_N(\pll_dig.flock.FCW_NA[1] ),
    .Y(_1095_));
 sg13g2_a221oi_1 _3900_ (.B2(_1094_),
    .C1(_1095_),
    .B1(_1093_),
    .A1(_0472_),
    .Y(_1096_),
    .A2(\pll_dig.flock.FCW_NA[2] ));
 sg13g2_a221oi_1 _3901_ (.B2(_0456_),
    .C1(_1096_),
    .B1(net146),
    .A1(\pll_dig.flock.cnt_filt[2] ),
    .Y(_1097_),
    .A2(_0479_));
 sg13g2_a221oi_1 _3902_ (.B2(\pll_dig.flock.FCW_NA[3] ),
    .C1(_1097_),
    .B1(_0530_),
    .A1(\pll_dig.flock.FCW_NA[4] ),
    .Y(_1098_),
    .A2(_0495_));
 sg13g2_inv_1 _3903_ (.Y(_0502_),
    .A(\pll_dig.dlf.INT[11] ));
 sg13g2_a221oi_1 _3904_ (.B2(_0490_),
    .C1(_1098_),
    .B1(\pll_dig.flock.cnt_filt[5] ),
    .A1(_0489_),
    .Y(_1099_),
    .A2(\pll_dig.flock.cnt_filt[4] ));
 sg13g2_a221oi_1 _3905_ (.B2(\pll_dig.flock.FCW_NA[5] ),
    .C1(_1099_),
    .B1(_0537_),
    .A1(\pll_dig.flock.FCW_NA[6] ),
    .Y(_1100_),
    .A2(_0518_));
 sg13g2_nor2_1 _3906_ (.A(\pll_dig.flock.FCW_NA[6] ),
    .B(_0518_),
    .Y(_1101_));
 sg13g2_nor2_1 _3907_ (.A(\pll_dig.flock.FCW_NA[7] ),
    .B(_0514_),
    .Y(_1102_));
 sg13g2_nor4_1 _3908_ (.A(\pll_dig.flock.cnt_filt[8] ),
    .B(_1100_),
    .C(_1101_),
    .D(_1102_),
    .Y(_1103_));
 sg13g2_nor2_1 _3909_ (.A(\pll_dig.flock.cnt_filt[7] ),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .Y(_1104_));
 sg13g2_nor2_1 _3910_ (.A(net526),
    .B(\pll_dig.flock.cnt_filt[9] ),
    .Y(_1105_));
 sg13g2_a22oi_1 _3911_ (.Y(_1106_),
    .B1(_1104_),
    .B2(\pll_dig.flock.FCW_NA[7] ),
    .A2(\pll_dig.flock.cnt_filt[8] ),
    .A1(_0491_));
 sg13g2_nand3_1 _3912_ (.B(net527),
    .C(_1106_),
    .A(_0789_),
    .Y(_1107_));
 sg13g2_nor3_1 _3913_ (.A(net533),
    .B(_1103_),
    .C(net528),
    .Y(_1108_));
 sg13g2_inv_1 _3914_ (.Y(_0503_),
    .A(\pll_dig.dlf.INT[4] ));
 sg13g2_and2_1 _3915_ (.A(\pll_dig.flock.cnt_done[1] ),
    .B(\pll_dig.flock.cnt_done[0] ),
    .X(_1109_));
 sg13g2_and2_1 _3916_ (.A(\pll_dig.flock.cnt_done[2] ),
    .B(_1109_),
    .X(_1110_));
 sg13g2_nand3_1 _3917_ (.B(\pll_dig.flock.cnt_done[4] ),
    .C(_1110_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .Y(_1111_));
 sg13g2_nor2_1 _3918_ (.A(_0461_),
    .B(_1111_),
    .Y(_1112_));
 sg13g2_xnor2_1 _3919_ (.Y(_1113_),
    .A(\pll_dig.flock.cnt_done[6] ),
    .B(_1112_));
 sg13g2_nor2_1 _3920_ (.A(\pll_dig.flock.cnt_done[1] ),
    .B(\pll_dig.flock.cnt_done[0] ),
    .Y(_1114_));
 sg13g2_nand2b_1 _3921_ (.Y(_1115_),
    .B(_1114_),
    .A_N(\pll_dig.flock.cnt_done[2] ));
 sg13g2_or2_1 _3922_ (.X(_1116_),
    .B(\pll_dig.flock.cnt_done[4] ),
    .A(\pll_dig.flock.cnt_done[3] ));
 sg13g2_nor3_1 _3923_ (.A(\pll_dig.flock.cnt_done[5] ),
    .B(_1115_),
    .C(_1116_),
    .Y(_1117_));
 sg13g2_nor2b_1 _3924_ (.A(_1117_),
    .B_N(\pll_dig.flock.cnt_done[6] ),
    .Y(_1118_));
 sg13g2_inv_1 _3925_ (.Y(_0504_),
    .A(\pll_dig.dlf.INT[5] ));
 sg13g2_nor2b_1 _3926_ (.A(\pll_dig.flock.cnt_done[6] ),
    .B_N(_1117_),
    .Y(_1119_));
 sg13g2_a21oi_1 _3927_ (.A1(\pll_dig.flock.cnt_done[7] ),
    .A2(_1119_),
    .Y(_1120_),
    .B1(_1118_));
 sg13g2_mux2_1 _3928_ (.A0(_1120_),
    .A1(_1113_),
    .S(net95),
    .X(_1121_));
 sg13g2_o21ai_1 _3929_ (.B1(_1082_),
    .Y(_0027_),
    .A1(_1079_),
    .A2(_1121_));
 sg13g2_nand2_1 _3930_ (.Y(_1122_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .B(\pll_dig.dsm_impl.FCWF[11] ));
 sg13g2_nor2_1 _3931_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .B(\pll_dig.dsm_impl.FCWF[11] ),
    .Y(_1123_));
 sg13g2_xor2_1 _3932_ (.B(\pll_dig.dsm_impl.FCWF[11] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .X(_1124_));
 sg13g2_o21ai_1 _3933_ (.B1(_0754_),
    .Y(_1125_),
    .A1(_0753_),
    .A2(_0755_));
 sg13g2_xnor2_1 _3934_ (.Y(_1126_),
    .A(_1124_),
    .B(_1125_));
 sg13g2_a21oi_1 _3935_ (.A1(net287),
    .A2(_0759_),
    .Y(_1127_),
    .B1(_0758_));
 sg13g2_inv_1 _3936_ (.Y(_0505_),
    .A(\pll_dig.dlf.INT[2] ));
 sg13g2_xnor2_1 _3937_ (.Y(_1128_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .B(_1126_));
 sg13g2_nor2_1 _3938_ (.A(_1127_),
    .B(_1128_),
    .Y(_1129_));
 sg13g2_a21oi_1 _3939_ (.A1(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .A2(_1126_),
    .Y(_1130_),
    .B1(_1129_));
 sg13g2_inv_1 _3940_ (.Y(_1131_),
    .A(_1130_));
 sg13g2_nor2_1 _3941_ (.A(_0525_),
    .B(_1131_),
    .Y(_1132_));
 sg13g2_nand2_1 _3942_ (.Y(_1133_),
    .A(_0618_),
    .B(_1132_));
 sg13g2_o21ai_1 _3943_ (.B1(_1122_),
    .Y(_1134_),
    .A1(_1123_),
    .A2(_1125_));
 sg13g2_nor2_1 _3944_ (.A(_1133_),
    .B(_1134_),
    .Y(_1135_));
 sg13g2_xor2_1 _3945_ (.B(_1128_),
    .A(_1127_),
    .X(_1136_));
 sg13g2_and2_1 _3946_ (.A(net315),
    .B(_1136_),
    .X(_1137_));
 sg13g2_inv_1 _3947_ (.Y(_0506_),
    .A(\pll_dig.dlf.INT[1] ));
 sg13g2_o21ai_1 _3948_ (.B1(_0761_),
    .Y(_1138_),
    .A1(_0762_),
    .A2(_0751_));
 sg13g2_or2_1 _3949_ (.X(_1139_),
    .B(_1136_),
    .A(net315));
 sg13g2_nand2b_1 _3950_ (.Y(_1140_),
    .B(_1139_),
    .A_N(_1137_));
 sg13g2_nand2b_1 _3951_ (.Y(_1141_),
    .B(_1138_),
    .A_N(_1140_));
 sg13g2_a21oi_2 _3952_ (.B1(_1137_),
    .Y(_1142_),
    .A2(_1138_),
    .A1(_1139_));
 sg13g2_nand2_2 _3953_ (.Y(_1143_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .B(net406));
 sg13g2_xor2_1 _3954_ (.B(_1142_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .X(_1144_));
 sg13g2_xnor2_1 _3955_ (.Y(_1145_),
    .A(_1144_),
    .B(_1131_));
 sg13g2_nand2b_1 _3956_ (.Y(_1146_),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .A_N(_1145_));
 sg13g2_and3_1 _3957_ (.X(_1147_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .B(_1130_),
    .C(_1142_));
 sg13g2_inv_1 _3958_ (.Y(_0507_),
    .A(\pll_dig.flock.cnt_bin[5] ));
 sg13g2_nor3_2 _3959_ (.A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .B(_1130_),
    .C(net284),
    .Y(_1148_));
 sg13g2_nor2_2 _3960_ (.A(_1148_),
    .B(_1147_),
    .Y(_1149_));
 sg13g2_nor2_1 _3961_ (.A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .B(net299),
    .Y(_1150_));
 sg13g2_xnor2_1 _3962_ (.Y(_1151_),
    .A(_1149_),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ));
 sg13g2_nand2b_1 _3963_ (.Y(_1152_),
    .B(net308),
    .A_N(_1151_));
 sg13g2_xnor2_1 _3964_ (.Y(_1153_),
    .A(_1145_),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ));
 sg13g2_nand2b_1 _3965_ (.Y(_1154_),
    .B(_1134_),
    .A_N(_1153_));
 sg13g2_xor2_1 _3966_ (.B(_1146_),
    .A(_1151_),
    .X(_1155_));
 sg13g2_nor2_1 _3967_ (.A(_1154_),
    .B(net282),
    .Y(_1156_));
 sg13g2_o21ai_1 _3968_ (.B1(_1152_),
    .Y(_1157_),
    .A1(_1155_),
    .A2(_1154_));
 sg13g2_inv_1 _3969_ (.Y(_0508_),
    .A(\pll_dig.flock.cnt_bin[10] ));
 sg13g2_nor2b_1 _3970_ (.A(_1147_),
    .B_N(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .Y(_1158_));
 sg13g2_xnor2_1 _3971_ (.Y(_1159_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .B(_1147_));
 sg13g2_xor2_1 _3972_ (.B(_1159_),
    .A(_1150_),
    .X(_1160_));
 sg13g2_a21oi_2 _3973_ (.B1(_0619_),
    .Y(_1161_),
    .A2(_1160_),
    .A1(_1157_));
 sg13g2_a21oi_1 _3974_ (.A1(_1150_),
    .A2(_1159_),
    .Y(_1162_),
    .B1(_1158_));
 sg13g2_a21oi_2 _3975_ (.B1(_1135_),
    .Y(_1163_),
    .A2(_1161_),
    .A1(_1162_));
 sg13g2_nand2_1 _3976_ (.Y(_1164_),
    .A(\pll_dig.dsm_impl.FCWI[4] ),
    .B(net294));
 sg13g2_or2_1 _3977_ (.X(_1165_),
    .B(_1157_),
    .A(_1160_));
 sg13g2_a21oi_2 _3978_ (.B1(_1135_),
    .Y(_1166_),
    .A2(_1161_),
    .A1(_1165_));
 sg13g2_nand2b_1 _3979_ (.Y(_1167_),
    .B(\pll_dig.dsm_impl.FCWI[2] ),
    .A_N(_1166_));
 sg13g2_inv_1 _3980_ (.Y(_0509_),
    .A(\pll_dig.clr_r2 ));
 sg13g2_nand2_1 _3981_ (.Y(_1168_),
    .A(net301),
    .B(net282));
 sg13g2_nor2_1 _3982_ (.A(_0619_),
    .B(_1156_),
    .Y(_1169_));
 sg13g2_and3_1 _3983_ (.X(_1170_),
    .A(_0525_),
    .B(_0618_),
    .C(_1131_));
 sg13g2_a221oi_1 _3984_ (.B2(_1134_),
    .C1(_1135_),
    .B1(_1170_),
    .A1(_1169_),
    .Y(_1171_),
    .A2(_1168_));
 sg13g2_nor2b_2 _3985_ (.A(_1171_),
    .B_N(\pll_dig.dsm_impl.FCWI[1] ),
    .Y(_1172_));
 sg13g2_xnor2_1 _3986_ (.Y(_1173_),
    .A(_1166_),
    .B(\pll_dig.dsm_impl.FCWI[2] ));
 sg13g2_nand2_2 _3987_ (.Y(_1174_),
    .A(_1173_),
    .B(_1172_));
 sg13g2_nor2b_1 _3988_ (.A(net294),
    .B_N(\pll_dig.dsm_impl.FCWI[3] ),
    .Y(_1175_));
 sg13g2_xor2_1 _3989_ (.B(_1163_),
    .A(\pll_dig.dsm_impl.FCWI[3] ),
    .X(_1176_));
 sg13g2_a21oi_2 _3990_ (.B1(_1176_),
    .Y(_1177_),
    .A2(_1167_),
    .A1(_1174_));
 sg13g2_inv_1 _3991_ (.Y(_0441_),
    .A(\pll_dig.MID_MUX_D[1] ));
 sg13g2_inv_1 _3992_ (.Y(_0510_),
    .A(\pll_dig.out_edges_g2_q[9] ));
 sg13g2_nor2_1 _3993_ (.A(_1175_),
    .B(net316),
    .Y(_1178_));
 sg13g2_nand2b_1 _3994_ (.Y(_1179_),
    .B(_1177_),
    .A_N(_1164_));
 sg13g2_nor2_1 _3995_ (.A(\pll_dig.dsm_impl.FCWI[4] ),
    .B(net294),
    .Y(_1180_));
 sg13g2_nor4_2 _3996_ (.A(\pll_dig.dsm_impl.FCWI[3] ),
    .B(_1177_),
    .C(net294),
    .Y(_1181_),
    .D(\pll_dig.dsm_impl.FCWI[4] ));
 sg13g2_xor2_1 _3997_ (.B(net289),
    .A(\pll_dig.dsm_impl.FCWI[1] ),
    .X(_1182_));
 sg13g2_o21ai_1 _3998_ (.B1(_1179_),
    .Y(\pll_dig.FILTER_DEC_RAW[1] ),
    .A1(_1182_),
    .A2(_1181_));
 sg13g2_xnor2_1 _3999_ (.Y(_1183_),
    .A(net304),
    .B(net303));
 sg13g2_o21ai_1 _4000_ (.B1(_1179_),
    .Y(\pll_dig.FILTER_DEC_RAW[2] ),
    .A1(_1183_),
    .A2(_1181_));
 sg13g2_nand3_1 _4001_ (.B(net318),
    .C(_1176_),
    .A(_1167_),
    .Y(_1184_));
 sg13g2_nand2b_1 _4002_ (.Y(_1185_),
    .B(_1184_),
    .A_N(_1177_));
 sg13g2_inv_1 _4003_ (.Y(_0511_),
    .A(\pll_dig.out_edges_g2_q[3] ));
 sg13g2_o21ai_1 _4004_ (.B1(_1179_),
    .Y(\pll_dig.FILTER_DEC_RAW[3] ),
    .A1(_1185_),
    .A2(_1181_));
 sg13g2_nand3_1 _4005_ (.B(net95),
    .C(_1112_),
    .A(\pll_dig.flock.cnt_done[6] ),
    .Y(_1186_));
 sg13g2_xnor2_1 _4006_ (.Y(_1187_),
    .A(_0460_),
    .B(_1186_));
 sg13g2_nor2b_1 _4007_ (.A(net95),
    .B_N(_1119_),
    .Y(_1188_));
 sg13g2_nor3_1 _4008_ (.A(_1079_),
    .B(_1187_),
    .C(_1188_),
    .Y(_1189_));
 sg13g2_a21o_1 _4009_ (.A2(_1081_),
    .A1(\pll_dig.flock.cnt_done[7] ),
    .B1(_1189_),
    .X(_0028_));
 sg13g2_nor2_1 _4010_ (.A(\pll_dig.COARSE_MUX_D[6] ),
    .B(net73),
    .Y(_1190_));
 sg13g2_a22oi_1 _4011_ (.Y(_1191_),
    .B1(net87),
    .B2(\pll_dig.COARSE_MUX_D[5] ),
    .A2(net89),
    .A1(\pll_dig.COARSE_MUX_D[7] ));
 sg13g2_a21oi_1 _4012_ (.A1(net73),
    .A2(_1191_),
    .Y(_0405_),
    .B1(_1190_));
 sg13g2_nand2b_1 _4013_ (.Y(_1192_),
    .B(\pll_dig.flock.FCW_PA[8] ),
    .A_N(\pll_dig.flock.cnt_cap[8] ));
 sg13g2_inv_1 _4014_ (.Y(_0512_),
    .A(net159));
 sg13g2_nor2_1 _4015_ (.A(_0447_),
    .B(\pll_dig.flock.FCW_PA[7] ),
    .Y(_1193_));
 sg13g2_a22oi_1 _4016_ (.Y(_1194_),
    .B1(_0535_),
    .B2(\pll_dig.flock.cnt_cap[2] ),
    .A2(\pll_dig.flock.cnt_cap[1] ),
    .A1(_0457_));
 sg13g2_a221oi_1 _4017_ (.B2(_0494_),
    .C1(_1194_),
    .B1(\pll_dig.flock.FCW_PA[2] ),
    .A1(_0500_),
    .Y(_1195_),
    .A2(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_a221oi_1 _4018_ (.B2(\pll_dig.flock.cnt_cap[3] ),
    .C1(_1195_),
    .B1(_0519_),
    .A1(_0492_),
    .Y(_1196_),
    .A2(\pll_dig.flock.cnt_cap[4] ));
 sg13g2_a221oi_1 _4019_ (.B2(\pll_dig.flock.FCW_PA[4] ),
    .C1(_1196_),
    .B1(_0501_),
    .A1(\pll_dig.flock.FCW_PA[5] ),
    .Y(_1197_),
    .A2(_0493_));
 sg13g2_a221oi_1 _4020_ (.B2(\pll_dig.flock.cnt_cap[6] ),
    .C1(_1197_),
    .B1(_0534_),
    .A1(_0459_),
    .Y(_1198_),
    .A2(\pll_dig.flock.cnt_cap[5] ));
 sg13g2_a221oi_1 _4021_ (.B2(_0447_),
    .C1(_1198_),
    .B1(\pll_dig.flock.FCW_PA[7] ),
    .A1(_0442_),
    .Y(_1199_),
    .A2(\pll_dig.flock.FCW_PA[6] ));
 sg13g2_o21ai_1 _4022_ (.B1(_1192_),
    .Y(_1200_),
    .A1(_1193_),
    .A2(_1199_));
 sg13g2_nand2_1 _4023_ (.Y(_1201_),
    .A(\pll_dig.flock.FCW_NA[0] ),
    .B(\pll_dig.flock.FCW_NA[1] ));
 sg13g2_nor2_1 _4024_ (.A(\pll_dig.flock.FCW_NA[0] ),
    .B(\pll_dig.flock.FCW_NA[1] ),
    .Y(_1202_));
 sg13g2_inv_1 _4025_ (.Y(_0513_),
    .A(\pll_dig.flock.cnt_bin[0] ));
 sg13g2_a221oi_1 _4026_ (.B2(_1201_),
    .C1(_1202_),
    .B1(\pll_dig.flock.cnt_cap[1] ),
    .A1(_0479_),
    .Y(_1203_),
    .A2(\pll_dig.flock.cnt_cap[2] ));
 sg13g2_a221oi_1 _4027_ (.B2(\pll_dig.flock.FCW_NA[3] ),
    .C1(_1203_),
    .B1(_0500_),
    .A1(\pll_dig.flock.FCW_NA[2] ),
    .Y(_1204_),
    .A2(_0494_));
 sg13g2_a221oi_1 _4028_ (.B2(_0489_),
    .C1(_1204_),
    .B1(\pll_dig.flock.cnt_cap[4] ),
    .A1(_0456_),
    .Y(_1205_),
    .A2(\pll_dig.flock.cnt_cap[3] ));
 sg13g2_a221oi_1 _4029_ (.B2(\pll_dig.flock.FCW_NA[4] ),
    .C1(_1205_),
    .B1(_0501_),
    .A1(\pll_dig.flock.FCW_NA[5] ),
    .Y(_1206_),
    .A2(_0493_));
 sg13g2_a221oi_1 _4030_ (.B2(\pll_dig.flock.cnt_cap[5] ),
    .C1(_1206_),
    .B1(_0490_),
    .A1(\pll_dig.flock.cnt_cap[6] ),
    .Y(_1207_),
    .A2(_0455_));
 sg13g2_nor2_1 _4031_ (.A(_0447_),
    .B(\pll_dig.flock.FCW_NA[7] ),
    .Y(_1208_));
 sg13g2_a221oi_1 _4032_ (.B2(_0447_),
    .C1(_1207_),
    .B1(\pll_dig.flock.FCW_NA[7] ),
    .A1(_0442_),
    .Y(_1209_),
    .A2(\pll_dig.flock.FCW_NA[6] ));
 sg13g2_nor3_1 _4033_ (.A(\pll_dig.flock.cnt_cap[8] ),
    .B(_1208_),
    .C(_1209_),
    .Y(_1210_));
 sg13g2_nor4_1 _4034_ (.A(\pll_dig.flock.FCW_NA[10] ),
    .B(\pll_dig.flock.cnt_cap[10] ),
    .C(\pll_dig.flock.cnt_cap[13] ),
    .D(\pll_dig.flock.cnt_cap[12] ),
    .Y(_1211_));
 sg13g2_nand2_1 _4035_ (.Y(_1212_),
    .A(\pll_dig.flock.cnt_cap[8] ),
    .B(_0491_));
 sg13g2_inv_1 _4036_ (.Y(_0514_),
    .A(\pll_dig.flock.cnt_filt[7] ));
 sg13g2_nor4_1 _4037_ (.A(\pll_dig.flock.cnt_cap[11] ),
    .B(\pll_dig.flock.cnt_cap[9] ),
    .C(\pll_dig.flock.cnt_cap[15] ),
    .D(\pll_dig.flock.cnt_cap[14] ),
    .Y(_1213_));
 sg13g2_nand4_1 _4038_ (.B(_1211_),
    .C(_1212_),
    .A(_1200_),
    .Y(_1214_),
    .D(_1213_));
 sg13g2_or2_1 _4039_ (.X(_1215_),
    .B(_1214_),
    .A(_1210_));
 sg13g2_nand2_1 _4040_ (.Y(_1216_),
    .A(net158),
    .B(_1215_));
 sg13g2_nand2_1 _4041_ (.Y(_1217_),
    .A(_0468_),
    .B(\pll_dig.flock.freq_miss[0] ));
 sg13g2_a21oi_1 _4042_ (.A1(_0464_),
    .A2(_1217_),
    .Y(_0404_),
    .B1(_1216_));
 sg13g2_and2_1 _4043_ (.A(_0521_),
    .B(_0978_),
    .X(_1218_));
 sg13g2_o21ai_1 _4044_ (.B1(_0973_),
    .Y(_1219_),
    .A1(\pll_dig.ref_wd.cnt[5] ),
    .A2(_1218_));
 sg13g2_a21oi_1 _4045_ (.A1(\pll_dig.ref_wd.cnt[5] ),
    .A2(_1218_),
    .Y(_0403_),
    .B1(_1219_));
 sg13g2_nor2_1 _4046_ (.A(\pll_dig.COARSE_MUX_D[12] ),
    .B(net71),
    .Y(_1220_));
 sg13g2_inv_1 _4047_ (.Y(_0515_),
    .A(\pll_dig.flock.cnt_filt[8] ));
 sg13g2_a22oi_1 _4048_ (.Y(_1221_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[11] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[13] ));
 sg13g2_a21oi_1 _4049_ (.A1(net71),
    .A2(_1221_),
    .Y(_0402_),
    .B1(_1220_));
 sg13g2_nand3_1 _4050_ (.B(net131),
    .C(net388),
    .A(\pll_dig.flock.cnt[6] ),
    .Y(_1222_));
 sg13g2_xnor2_1 _4051_ (.Y(_0401_),
    .A(\pll_dig.flock.cnt[7] ),
    .B(_1222_));
 sg13g2_a221oi_1 _4052_ (.B2(\pll_dig.MID_MUX_D[3] ),
    .C1(net81),
    .B1(net91),
    .A1(\pll_dig.MID_MUX_D[5] ),
    .Y(_1223_),
    .A2(_0822_));
 sg13g2_nand2_1 _4053_ (.Y(_1224_),
    .A(\pll_dig.MID_MUX_D[4] ),
    .B(net78));
 sg13g2_o21ai_1 _4054_ (.B1(_1224_),
    .Y(_0400_),
    .A1(net79),
    .A2(_1223_));
 sg13g2_nand2b_1 _4055_ (.Y(_1225_),
    .B(net94),
    .A_N(\pll_dig.COARSE_MUX_D[2] ));
 sg13g2_nand3_1 _4056_ (.B(net74),
    .C(_1225_),
    .A(\pll_dig.COARSE_MUX_D[0] ),
    .Y(_1226_));
 sg13g2_o21ai_1 _4057_ (.B1(_1226_),
    .Y(_0399_),
    .A1(_0467_),
    .A2(net74));
 sg13g2_inv_1 _4058_ (.Y(_0516_),
    .A(\SS_BBPD[1] ));
 sg13g2_a221oi_1 _4059_ (.B2(\pll_dig.MID_MUX_D[10] ),
    .C1(net81),
    .B1(net91),
    .A1(\pll_dig.MID_MUX_D[12] ),
    .Y(_1227_),
    .A2(net93));
 sg13g2_nand2_1 _4060_ (.Y(_1228_),
    .A(\pll_dig.MID_MUX_D[11] ),
    .B(net76));
 sg13g2_o21ai_1 _4061_ (.B1(_1228_),
    .Y(_0398_),
    .A1(net76),
    .A2(_1227_));
 sg13g2_xnor2_1 _4062_ (.Y(_0397_),
    .A(\pll_dig.flock.cnt_gray[15] ),
    .B(_0840_));
 sg13g2_nor2_1 _4063_ (.A(\pll_dig.COARSE_MUX_D[7] ),
    .B(net73),
    .Y(_1229_));
 sg13g2_a22oi_1 _4064_ (.Y(_1230_),
    .B1(net87),
    .B2(\pll_dig.COARSE_MUX_D[6] ),
    .A2(net89),
    .A1(\pll_dig.COARSE_MUX_D[8] ));
 sg13g2_a21oi_1 _4065_ (.A1(net73),
    .A2(_1230_),
    .Y(_0396_),
    .B1(_1229_));
 sg13g2_nor2_1 _4066_ (.A(_0468_),
    .B(_1216_),
    .Y(_0395_));
 sg13g2_a21oi_1 _4067_ (.A1(\pll_dig.ref_wd.cnt[5] ),
    .A2(_1218_),
    .Y(_1231_),
    .B1(\pll_dig.ref_wd.cnt[6] ));
 sg13g2_and4_1 _4068_ (.A(\pll_dig.ref_wd.cnt[5] ),
    .B(\pll_dig.ref_wd.cnt[6] ),
    .C(_0974_),
    .D(_0978_),
    .X(_1232_));
 sg13g2_inv_1 _4069_ (.Y(_0517_),
    .A(\SS_BBPD[0] ));
 sg13g2_nor3_1 _4070_ (.A(_0972_),
    .B(_1231_),
    .C(_1232_),
    .Y(_0394_));
 sg13g2_a221oi_1 _4071_ (.B2(_0441_),
    .C1(_0808_),
    .B1(net93),
    .A1(_0469_),
    .Y(_0393_),
    .A2(_0820_));
 sg13g2_nor2_1 _4072_ (.A(net103),
    .B(\pll_dig.FILTER_DEC[1] ),
    .Y(_1233_));
 sg13g2_nand2_1 _4073_ (.Y(_1234_),
    .A(\pll_dig.FILTER_DEC[4] ),
    .B(\pll_dig.FILTER_DEC[3] ));
 sg13g2_inv_1 _4074_ (.Y(\pll_dig.FINE_MUX_D[23] ),
    .A(net97));
 sg13g2_nor2_1 _4075_ (.A(_1233_),
    .B(net96),
    .Y(\pll_dig.FINE_MUX_D[25] ));
 sg13g2_nand2_1 _4076_ (.Y(_1235_),
    .A(\pll_dig.FILTER_DEC[4] ),
    .B(net103));
 sg13g2_nand2_1 _4077_ (.Y(_1236_),
    .A(\pll_dig.FILTER_DEC[0] ),
    .B(\pll_dig.FILTER_DEC[1] ));
 sg13g2_a21oi_1 _4078_ (.A1(\pll_dig.FILTER_DEC[0] ),
    .A2(\pll_dig.FILTER_DEC[1] ),
    .Y(_1237_),
    .B1(net103));
 sg13g2_nor2_1 _4079_ (.A(net96),
    .B(_1237_),
    .Y(\pll_dig.FINE_MUX_D[26] ));
 sg13g2_inv_1 _4080_ (.Y(_0518_),
    .A(\pll_dig.flock.cnt_filt[6] ));
 sg13g2_and2_1 _4081_ (.A(net103),
    .B(\pll_dig.FINE_MUX_D[23] ),
    .X(\pll_dig.FINE_MUX_D[27] ));
 sg13g2_nor2_1 _4082_ (.A(\pll_dig.FILTER_DEC[0] ),
    .B(\pll_dig.FILTER_DEC[1] ),
    .Y(_1238_));
 sg13g2_o21ai_1 _4083_ (.B1(net103),
    .Y(_1239_),
    .A1(\pll_dig.FILTER_DEC[0] ),
    .A2(\pll_dig.FILTER_DEC[1] ));
 sg13g2_nor2_1 _4084_ (.A(net97),
    .B(_1239_),
    .Y(\pll_dig.FINE_MUX_D[28] ));
 sg13g2_nor2_1 _4085_ (.A(_1077_),
    .B(net97),
    .Y(\pll_dig.FINE_MUX_D[29] ));
 sg13g2_nand3_1 _4086_ (.B(\pll_dig.FILTER_DEC[0] ),
    .C(\pll_dig.FILTER_DEC[1] ),
    .A(\pll_dig.FILTER_DEC[2] ),
    .Y(_1240_));
 sg13g2_nor2_1 _4087_ (.A(net97),
    .B(_1240_),
    .Y(\pll_dig.FINE_MUX_D[30] ));
 sg13g2_nand2_1 _4088_ (.Y(\pll_dig.FINE_MUX_D[19] ),
    .A(net97),
    .B(_1235_));
 sg13g2_o21ai_1 _4089_ (.B1(net97),
    .Y(\pll_dig.FINE_MUX_D[20] ),
    .A1(_1235_),
    .A2(_1238_));
 sg13g2_nor2_1 _4090_ (.A(\pll_dig.flock.cnt_filt[0] ),
    .B(net147),
    .Y(_1241_));
 sg13g2_inv_1 _4091_ (.Y(_0519_),
    .A(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_nand2_1 _4092_ (.Y(_1242_),
    .A(net147),
    .B(\pll_dig.flock.cnt_filt[2] ));
 sg13g2_xor2_1 _4093_ (.B(\pll_dig.flock.cnt_filt[2] ),
    .A(\pll_dig.flock.cnt_filt[1] ),
    .X(_1243_));
 sg13g2_nand2_1 _4094_ (.Y(_1244_),
    .A(net508),
    .B(_1243_));
 sg13g2_xnor2_1 _4095_ (.Y(_1245_),
    .A(net508),
    .B(_1243_));
 sg13g2_and2_1 _4096_ (.A(\pll_dig.flock.cnt_filt[0] ),
    .B(\pll_dig.flock.cnt_filt[1] ),
    .X(_1246_));
 sg13g2_o21ai_1 _4097_ (.B1(net458),
    .Y(_1247_),
    .A1(_1241_),
    .A2(_1246_));
 sg13g2_xor2_1 _4098_ (.B(_1245_),
    .A(_1241_),
    .X(_1248_));
 sg13g2_nand2b_1 _4099_ (.Y(_1249_),
    .B(_1248_),
    .A_N(net459));
 sg13g2_o21ai_1 _4100_ (.B1(_1249_),
    .Y(_1250_),
    .A1(_1241_),
    .A2(_1245_));
 sg13g2_nand2_1 _4101_ (.Y(_1251_),
    .A(\pll_dig.flock.cnt_filt[2] ),
    .B(net146));
 sg13g2_inv_1 _4102_ (.Y(_0442_),
    .A(\pll_dig.flock.cnt_cap[6] ));
 sg13g2_inv_1 _4103_ (.Y(_0520_),
    .A(\pll_dig.locked_q ));
 sg13g2_xor2_1 _4104_ (.B(\pll_dig.flock.cnt_filt[3] ),
    .A(\pll_dig.flock.cnt_filt[2] ),
    .X(_1252_));
 sg13g2_nand2_1 _4105_ (.Y(_1253_),
    .A(net513),
    .B(_1252_));
 sg13g2_xnor2_1 _4106_ (.Y(_1254_),
    .A(net513),
    .B(_1252_));
 sg13g2_a21oi_1 _4107_ (.A1(_1242_),
    .A2(net509),
    .Y(_1255_),
    .B1(net514));
 sg13g2_nand3_1 _4108_ (.B(net509),
    .C(net514),
    .A(_1242_),
    .Y(_1256_));
 sg13g2_nand2b_1 _4109_ (.Y(_1257_),
    .B(net515),
    .A_N(net510));
 sg13g2_xnor2_1 _4110_ (.Y(_0146_),
    .A(_1250_),
    .B(_1257_));
 sg13g2_nor2_1 _4111_ (.A(\pll_dig.COARSE_MUX_D[11] ),
    .B(net71),
    .Y(_1258_));
 sg13g2_a22oi_1 _4112_ (.Y(_1259_),
    .B1(net86),
    .B2(\pll_dig.COARSE_MUX_D[10] ),
    .A2(net88),
    .A1(\pll_dig.COARSE_MUX_D[12] ));
 sg13g2_a21oi_1 _4113_ (.A1(net71),
    .A2(_1259_),
    .Y(_0392_),
    .B1(_1258_));
 sg13g2_inv_1 _4114_ (.Y(_0521_),
    .A(\pll_dig.ref_wd.cnt[9] ));
 sg13g2_and3_1 _4115_ (.X(_1260_),
    .A(\pll_dig.flock.cnt[4] ),
    .B(net127),
    .C(net389));
 sg13g2_nand2_1 _4116_ (.Y(_1261_),
    .A(\pll_dig.flock.cnt[5] ),
    .B(_1260_));
 sg13g2_xnor2_1 _4117_ (.Y(_0391_),
    .A(\pll_dig.flock.cnt[6] ),
    .B(_1261_));
 sg13g2_a221oi_1 _4118_ (.B2(\pll_dig.MID_MUX_D[1] ),
    .C1(net80),
    .B1(net90),
    .A1(\pll_dig.MID_MUX_D[3] ),
    .Y(_1262_),
    .A2(net92));
 sg13g2_nand2_1 _4119_ (.Y(_1263_),
    .A(\pll_dig.MID_MUX_D[2] ),
    .B(net79));
 sg13g2_o21ai_1 _4120_ (.B1(_1263_),
    .Y(_0390_),
    .A1(net79),
    .A2(_1262_));
 sg13g2_nor2_1 _4121_ (.A(\pll_dig.flock.cnt_gray[0] ),
    .B(net127),
    .Y(_1264_));
 sg13g2_a21oi_1 _4122_ (.A1(net417),
    .A2(net127),
    .Y(_0389_),
    .B1(_1264_));
 sg13g2_nor3_1 _4123_ (.A(\pll_dig.div.p_hi ),
    .B(\pll_dig.div.n_hi ),
    .C(_0578_),
    .Y(_1265_));
 sg13g2_a21oi_1 _4124_ (.A1(net327),
    .A2(net361),
    .Y(_1266_),
    .B1(\pll_dig.div.out_reg ));
 sg13g2_inv_1 _4125_ (.Y(_0522_),
    .A(\pll_dig.cntf[5] ));
 sg13g2_nor3_1 _4126_ (.A(\pll_dig.div.use_clk ),
    .B(_1265_),
    .C(_1266_),
    .Y(_1267_));
 sg13g2_a21o_1 _4127_ (.A2(\pll_dig.div.use_clk ),
    .A1(clknet_1_1__leaf_net59),
    .B1(_1267_),
    .X(net60));
 sg13g2_inv_1 _4128__273 (.Y(net272),
    .A(clknet_1_0__leaf_net60_regs));
 sg13g2_nor2b_1 _4129_ (.A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .B_N(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .Y(_0046_));
 sg13g2_xor2_1 _4130_ (.B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .X(_0047_));
 sg13g2_a21oi_1 _4131_ (.A1(net98),
    .A2(_1240_),
    .Y(\pll_dig.FINE_MUX_D[14] ),
    .B1(net99));
 sg13g2_a21oi_1 _4132_ (.A1(net98),
    .A2(_1077_),
    .Y(\pll_dig.FINE_MUX_D[13] ),
    .B1(net99));
 sg13g2_a21oi_1 _4133_ (.A1(net98),
    .A2(_1233_),
    .Y(\pll_dig.FINE_MUX_D[9] ),
    .B1(net99));
 sg13g2_a21oi_1 _4134_ (.A1(_0440_),
    .A2(_1237_),
    .Y(\pll_dig.FINE_MUX_D[10] ),
    .B1(net99));
 sg13g2_a21oi_1 _4135_ (.A1(_0618_),
    .A2(_1132_),
    .Y(_1268_),
    .B1(_1170_));
 sg13g2_inv_1 _4136_ (.Y(_0523_),
    .A(\pll_dig.dco_miss_cnt[1] ));
 sg13g2_o21ai_1 _4137_ (.B1(_1268_),
    .Y(_1269_),
    .A1(_0619_),
    .A2(net302));
 sg13g2_xnor2_1 _4138_ (.Y(_1270_),
    .A(_1134_),
    .B(_1269_));
 sg13g2_o21ai_1 _4139_ (.B1(_1179_),
    .Y(\pll_dig.FILTER_DEC_RAW[0] ),
    .A1(_1270_),
    .A2(_1181_));
 sg13g2_nor3_1 _4140_ (.A(\pll_dig.FILTER_DEC[2] ),
    .B(\pll_dig.FILTER_DEC[0] ),
    .C(\pll_dig.FILTER_DEC[1] ),
    .Y(_1271_));
 sg13g2_o21ai_1 _4141_ (.B1(net96),
    .Y(\pll_dig.FINE_MUX_D[16] ),
    .A1(_0440_),
    .A2(_1271_));
 sg13g2_nor2_1 _4142_ (.A(_0484_),
    .B(_0615_),
    .Y(_0097_));
 sg13g2_xnor2_1 _4143_ (.Y(_0104_),
    .A(net12),
    .B(_0615_));
 sg13g2_nor2_1 _4144_ (.A(net116),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[2] ),
    .Y(_1272_));
 sg13g2_xnor2_1 _4145_ (.Y(_1273_),
    .A(_0665_),
    .B(_0666_));
 sg13g2_a21oi_1 _4146_ (.A1(net113),
    .A2(_1273_),
    .Y(_0388_),
    .B1(_1272_));
 sg13g2_inv_1 _4147_ (.Y(_0524_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[0] ));
 sg13g2_nand2b_1 _4148_ (.Y(_1274_),
    .B(_0749_),
    .A_N(net280));
 sg13g2_nand3_1 _4149_ (.B(_0750_),
    .C(_1274_),
    .A(net123),
    .Y(_1275_));
 sg13g2_o21ai_1 _4150_ (.B1(_1275_),
    .Y(_0387_),
    .A1(net123),
    .A2(_0474_));
 sg13g2_nand2_1 _4151_ (.Y(_1276_),
    .A(net114),
    .B(net273));
 sg13g2_o21ai_1 _4152_ (.B1(_1276_),
    .Y(_0386_),
    .A1(net114),
    .A2(_0463_));
 sg13g2_mux2_1 _4153_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .A1(_1136_),
    .S(net118),
    .X(_0385_));
 sg13g2_nor2_1 _4154_ (.A(net120),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .Y(_1277_));
 sg13g2_a21oi_1 _4155_ (.A1(net120),
    .A2(_0691_),
    .Y(_0384_),
    .B1(_1277_));
 sg13g2_xor2_1 _4156_ (.B(net5),
    .A(net6),
    .X(_0098_));
 sg13g2_inv_1 _4157_ (.Y(_0120_),
    .A(_0098_));
 sg13g2_inv_1 _4158_ (.Y(_0525_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca2 ));
 sg13g2_a21o_1 _4159_ (.A2(_0613_),
    .A1(net9),
    .B1(net10),
    .X(_1278_));
 sg13g2_and2_1 _4160_ (.A(_0614_),
    .B(_1278_),
    .X(_0102_));
 sg13g2_xnor2_1 _4161_ (.Y(_1279_),
    .A(_0733_),
    .B(_0734_));
 sg13g2_nor2_1 _4162_ (.A(net114),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .Y(_1280_));
 sg13g2_a21oi_1 _4163_ (.A1(net114),
    .A2(_1279_),
    .Y(_0383_),
    .B1(_1280_));
 sg13g2_nand2b_1 _4164_ (.Y(_1281_),
    .B(_1140_),
    .A_N(_1138_));
 sg13g2_nand3_1 _4165_ (.B(_1141_),
    .C(_1281_),
    .A(net122),
    .Y(_1282_));
 sg13g2_o21ai_1 _4166_ (.B1(_1282_),
    .Y(_0382_),
    .A1(net122),
    .A2(_0477_));
 sg13g2_nand2_1 _4167_ (.Y(_1283_),
    .A(net119),
    .B(net274));
 sg13g2_o21ai_1 _4168_ (.B1(_1283_),
    .Y(_0381_),
    .A1(net119),
    .A2(_0487_));
 sg13g2_inv_1 _4169_ (.Y(_0526_),
    .A(net40));
 sg13g2_mux2_1 _4170_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .A1(net298),
    .S(net113),
    .X(_0380_));
 sg13g2_nor2_1 _4171_ (.A(net120),
    .B(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .Y(_1284_));
 sg13g2_a21oi_1 _4172_ (.A1(net120),
    .A2(_0688_),
    .Y(_0379_),
    .B1(_1284_));
 sg13g2_nor3_1 _4173_ (.A(net7),
    .B(net6),
    .C(net5),
    .Y(_1285_));
 sg13g2_and2_1 _4174_ (.A(_0485_),
    .B(_1285_),
    .X(_1286_));
 sg13g2_and2_1 _4175_ (.A(_0462_),
    .B(_1286_),
    .X(_1287_));
 sg13g2_and2_1 _4176_ (.A(_0486_),
    .B(_1287_),
    .X(_1288_));
 sg13g2_nor2b_1 _4177_ (.A(net11),
    .B_N(_1288_),
    .Y(_1289_));
 sg13g2_and2_1 _4178_ (.A(_0484_),
    .B(_1289_),
    .X(_0127_));
 sg13g2_xnor2_1 _4179_ (.Y(_0126_),
    .A(_0484_),
    .B(_1289_));
 sg13g2_inv_1 _4180_ (.Y(_0527_),
    .A(_0135_));
 sg13g2_xnor2_1 _4181_ (.Y(_0123_),
    .A(_0462_),
    .B(_1286_));
 sg13g2_xnor2_1 _4182_ (.Y(_0124_),
    .A(_0486_),
    .B(_1287_));
 sg13g2_o21ai_1 _4183_ (.B1(net7),
    .Y(_1290_),
    .A1(net6),
    .A2(net5));
 sg13g2_nand2b_1 _4184_ (.Y(_0121_),
    .B(_1290_),
    .A_N(_1285_));
 sg13g2_xnor2_1 _4185_ (.Y(_0108_),
    .A(\pll_dig.flock.cnt_gray_s2[12] ),
    .B(_0868_));
 sg13g2_xnor2_1 _4186_ (.Y(_1291_),
    .A(\pll_dig.flock.cnt_gray_s2[11] ),
    .B(_0108_));
 sg13g2_inv_1 _4187_ (.Y(_0107_),
    .A(_1291_));
 sg13g2_xnor2_1 _4188_ (.Y(_0106_),
    .A(\pll_dig.flock.cnt_gray_s2[10] ),
    .B(_1291_));
 sg13g2_xor2_1 _4189_ (.B(_0106_),
    .A(\pll_dig.flock.cnt_gray_s2[9] ),
    .X(_0119_));
 sg13g2_xnor2_1 _4190_ (.Y(_1292_),
    .A(\pll_dig.flock.cnt_gray_s2[8] ),
    .B(_0119_));
 sg13g2_inv_1 _4191_ (.Y(_0528_),
    .A(net33));
 sg13g2_inv_1 _4192_ (.Y(_0118_),
    .A(_1292_));
 sg13g2_xnor2_1 _4193_ (.Y(_0117_),
    .A(\pll_dig.flock.cnt_gray_s2[7] ),
    .B(_1292_));
 sg13g2_xnor2_1 _4194_ (.Y(_1293_),
    .A(\pll_dig.flock.cnt_gray_s2[6] ),
    .B(_0117_));
 sg13g2_inv_1 _4195_ (.Y(_0116_),
    .A(_1293_));
 sg13g2_xnor2_1 _4196_ (.Y(_0115_),
    .A(\pll_dig.flock.cnt_gray_s2[5] ),
    .B(_1293_));
 sg13g2_xor2_1 _4197_ (.B(_0115_),
    .A(\pll_dig.flock.cnt_gray_s2[4] ),
    .X(_0114_));
 sg13g2_xor2_1 _4198_ (.B(_0114_),
    .A(\pll_dig.flock.cnt_gray_s2[3] ),
    .X(_0113_));
 sg13g2_xnor2_1 _4199_ (.Y(_1294_),
    .A(\pll_dig.flock.cnt_gray_s2[2] ),
    .B(_0113_));
 sg13g2_inv_1 _4200_ (.Y(_0112_),
    .A(_1294_));
 sg13g2_xnor2_1 _4201_ (.Y(_0111_),
    .A(\pll_dig.flock.cnt_gray_s2[1] ),
    .B(_1294_));
 sg13g2_inv_1 _4202__271 (.Y(net270),
    .A(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_nand3_1 _4203_ (.B(_0796_),
    .C(_0817_),
    .A(\pll_dig.MID_MUX_D[14] ),
    .Y(_1295_));
 sg13g2_inv_1 _4204_ (.Y(_1296_),
    .A(net537));
 sg13g2_nand2_1 _4205_ (.Y(_1297_),
    .A(\pll_dig.COARSE_MUX_D[14] ),
    .B(_0805_));
 sg13g2_nor2_1 _4206_ (.A(net537),
    .B(_1297_),
    .Y(_1298_));
 sg13g2_a21oi_1 _4207_ (.A1(_0451_),
    .A2(_0827_),
    .Y(_1299_),
    .B1(_1298_));
 sg13g2_nand2_1 _4208_ (.Y(_1300_),
    .A(_0798_),
    .B(net537));
 sg13g2_nand2_1 _4209_ (.Y(_1301_),
    .A(_0806_),
    .B(_1300_));
 sg13g2_xnor2_1 _4210_ (.Y(_1302_),
    .A(\pll_dig.flock.cnt_coarse_wait[6] ),
    .B(_0803_));
 sg13g2_o21ai_1 _4211_ (.B1(net68),
    .Y(_0019_),
    .A1(_1301_),
    .A2(_1302_));
 sg13g2_xor2_1 _4212_ (.B(_0111_),
    .A(\pll_dig.flock.cnt_gray_s2[0] ),
    .X(_0105_));
 sg13g2_dfrbpq_1 _4213_ (.RESET_B(net143),
    .D(_0201_),
    .Q(_0132_),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4214_ (.RESET_B(net143),
    .D(\pll_dig.div.low_count_pend[1] ),
    .Q(\pll_dig.div.low_count[1] ),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4215_ (.RESET_B(net143),
    .D(\pll_dig.div.low_count_pend[2] ),
    .Q(\pll_dig.div.low_count[2] ),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4216_ (.RESET_B(net139),
    .D(\pll_dig.div.low_count_pend[3] ),
    .Q(\pll_dig.div.low_count[3] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4217_ (.RESET_B(net139),
    .D(\pll_dig.div.low_count_pend[4] ),
    .Q(\pll_dig.div.low_count[4] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4218_ (.RESET_B(net138),
    .D(\pll_dig.div.low_count_pend[5] ),
    .Q(\pll_dig.div.low_count[5] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4219_ (.RESET_B(net138),
    .D(\pll_dig.div.low_count_pend[6] ),
    .Q(\pll_dig.div.low_count[6] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4220_ (.RESET_B(net201),
    .D(_0069_),
    .Q(\pll_dig.flock.cnt_cap[1] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4221_ (.RESET_B(net201),
    .D(_0070_),
    .Q(\pll_dig.flock.cnt_cap[2] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4222_ (.RESET_B(net204),
    .D(_0071_),
    .Q(\pll_dig.flock.cnt_cap[3] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4223_ (.RESET_B(net204),
    .D(_0072_),
    .Q(\pll_dig.flock.cnt_cap[4] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4224_ (.RESET_B(net204),
    .D(_0073_),
    .Q(\pll_dig.flock.cnt_cap[5] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4225_ (.RESET_B(net204),
    .D(_0074_),
    .Q(\pll_dig.flock.cnt_cap[6] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4226_ (.RESET_B(net216),
    .D(_0075_),
    .Q(\pll_dig.flock.cnt_cap[7] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4227_ (.RESET_B(net216),
    .D(_0076_),
    .Q(\pll_dig.flock.cnt_cap[8] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4228_ (.RESET_B(net216),
    .D(_0077_),
    .Q(\pll_dig.flock.cnt_cap[9] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4229_ (.RESET_B(net216),
    .D(_0063_),
    .Q(\pll_dig.flock.cnt_cap[10] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4230_ (.RESET_B(net219),
    .D(_0064_),
    .Q(\pll_dig.flock.cnt_cap[11] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4231_ (.RESET_B(net222),
    .D(_0065_),
    .Q(\pll_dig.flock.cnt_cap[12] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4232_ (.RESET_B(net222),
    .D(_0066_),
    .Q(\pll_dig.flock.cnt_cap[13] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4233_ (.RESET_B(net220),
    .D(_0067_),
    .Q(\pll_dig.flock.cnt_cap[14] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4234_ (.RESET_B(net222),
    .D(_0068_),
    .Q(\pll_dig.flock.cnt_cap[15] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4235_ (.RESET_B(net207),
    .D(_0310_),
    .Q(\pll_dig.clr_toggle ),
    .CLK(_0199_));
 sg13g2_dfrbpq_1 _4236_ (.RESET_B(net235),
    .D(_0309_),
    .Q(\pll_dig.div_rst_cnt[0] ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4237_ (.RESET_B(net235),
    .D(_0308_),
    .Q(\pll_dig.div_rst_cnt[1] ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4238_ (.RESET_B(net235),
    .D(_0307_),
    .Q(\pll_dig.div_rst_cnt[2] ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4239_ (.RESET_B(net235),
    .D(_0306_),
    .Q(\pll_dig.div_rst_cnt[3] ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4240_ (.RESET_B(net172),
    .D(_0326_),
    .Q(DCO_EN),
    .CLK(_0208_));
 sg13g2_dfrbpq_1 _4241_ (.RESET_B(net176),
    .D(_0329_),
    .Q(net57),
    .CLK(_0211_));
 sg13g2_dfrbpq_1 _4242_ (.RESET_B(net172),
    .D(_0328_),
    .Q(\pll_dig.ENABLE ),
    .CLK(_0210_));
 sg13g2_dfrbpq_1 _4243_ (.RESET_B(net176),
    .D(_0327_),
    .Q(\pll_dig.START ),
    .CLK(_0209_));
 sg13g2_dfrbpq_1 _4244_ (.RESET_B(net177),
    .D(_0356_),
    .Q(\pll_dig.locked_q ),
    .CLK(_0219_));
 sg13g2_dfrbpq_1 _4245_ (.RESET_B(net177),
    .D(_0321_),
    .Q(\pll_dig.FORCE_P ),
    .CLK(_0207_));
 sg13g2_dfrbpq_1 _4246_ (.RESET_B(net177),
    .D(_0422_),
    .Q(\pll_dig.FORCE_N ),
    .CLK(_0243_));
 sg13g2_dfrbpq_1 _4247_ (.RESET_B(net178),
    .D(_0360_),
    .Q(\pll_dig.cnt[0] ),
    .CLK(_0223_));
 sg13g2_dfrbpq_1 _4248_ (.RESET_B(net177),
    .D(_0355_),
    .Q(\pll_dig.cnt[1] ),
    .CLK(_0218_));
 sg13g2_dfrbpq_1 _4249_ (.RESET_B(net206),
    .D(_0320_),
    .Q(\pll_dig.cnt[2] ),
    .CLK(_0206_));
 sg13g2_dfrbpq_1 _4250_ (.RESET_B(net206),
    .D(_0421_),
    .Q(\pll_dig.cnt[3] ),
    .CLK(_0242_));
 sg13g2_dfrbpq_1 _4251_ (.RESET_B(net205),
    .D(_0359_),
    .Q(\pll_dig.cnt[4] ),
    .CLK(_0222_));
 sg13g2_dfrbpq_1 _4252_ (.RESET_B(net205),
    .D(_0354_),
    .Q(\pll_dig.cnt[5] ),
    .CLK(_0217_));
 sg13g2_dfrbpq_1 _4253_ (.RESET_B(net208),
    .D(_0319_),
    .Q(\pll_dig.cnt[6] ),
    .CLK(_0205_));
 sg13g2_dfrbpq_1 _4254_ (.RESET_B(net208),
    .D(_0420_),
    .Q(\pll_dig.cnt[7] ),
    .CLK(_0241_));
 sg13g2_dfrbpq_1 _4255_ (.RESET_B(net208),
    .D(_0358_),
    .Q(\pll_dig.cntf[0] ),
    .CLK(_0221_));
 sg13g2_dfrbpq_1 _4256_ (.RESET_B(net236),
    .D(_0353_),
    .Q(\pll_dig.cntf[1] ),
    .CLK(_0216_));
 sg13g2_dfrbpq_1 _4257_ (.RESET_B(net236),
    .D(_0434_),
    .Q(\pll_dig.cntf[2] ),
    .CLK(_0245_));
 sg13g2_dfrbpq_1 _4258_ (.RESET_B(net196),
    .D(_0419_),
    .Q(\pll_dig.cntf[3] ),
    .CLK(_0240_));
 sg13g2_dfrbpq_1 _4259_ (.RESET_B(net177),
    .D(_0357_),
    .Q(\pll_dig.cntf[4] ),
    .CLK(_0220_));
 sg13g2_dfrbpq_1 _4260_ (.RESET_B(net178),
    .D(_0352_),
    .Q(\pll_dig.cntf[5] ),
    .CLK(_0215_));
 sg13g2_dfrbpq_1 _4261_ (.RESET_B(net208),
    .D(_0251_),
    .Q(\pll_dig.cntf[6] ),
    .CLK(_0153_));
 sg13g2_dfrbpq_1 _4262_ (.RESET_B(net208),
    .D(_0418_),
    .Q(\pll_dig.cntf[7] ),
    .CLK(_0239_));
 sg13g2_dfrbpq_1 _4263_ (.RESET_B(net236),
    .D(_0317_),
    .Q(\pll_dig.ref_fail ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4264_ (.RESET_B(net207),
    .D(_0417_),
    .Q(\pll_dig.dco_miss_cnt[0] ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4265_ (.RESET_B(net207),
    .D(_0316_),
    .Q(\pll_dig.dco_miss_cnt[1] ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4266_ (.RESET_B(net207),
    .D(_0416_),
    .Q(\pll_dig.dco_miss_cnt[2] ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4267_ (.RESET_B(net134),
    .D(_0315_),
    .Q(\pll_dig.div.use_clk ),
    .CLK(net264));
 sg13g2_dfrbpq_2 _4268_ (.RESET_B(net136),
    .D(_0415_),
    .Q(\pll_dig.div.div[0] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4269_ (.RESET_B(net141),
    .D(_0314_),
    .Q(_0133_),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4270_ (.RESET_B(net141),
    .D(_0414_),
    .Q(\pll_dig.div.div[2] ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4271_ (.RESET_B(net141),
    .D(_0313_),
    .Q(\pll_dig.div.div[3] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4272_ (.RESET_B(net136),
    .D(_0413_),
    .Q(\pll_dig.div.div[4] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4273_ (.RESET_B(net136),
    .D(_0312_),
    .Q(\pll_dig.div.div[5] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4274_ (.RESET_B(net134),
    .D(_0412_),
    .Q(\pll_dig.div.div[6] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4275_ (.RESET_B(net134),
    .D(_0311_),
    .Q(\pll_dig.div.div[7] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4276_ (.RESET_B(net134),
    .D(_0411_),
    .Q(\pll_dig.div.high_phase ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4277_ (.RESET_B(net135),
    .D(_0257_),
    .Q(\pll_dig.div.out_reg ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4278_ (.RESET_B(net136),
    .D(_0248_),
    .Q(\pll_dig.div.div_pend[0] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4279_ (.RESET_B(net136),
    .D(_0253_),
    .Q(_0128_),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4280_ (.RESET_B(net136),
    .D(_0247_),
    .Q(\pll_dig.div.div_pend[2] ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4281_ (.RESET_B(net136),
    .D(_0250_),
    .Q(\pll_dig.div.div_pend[3] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4282_ (.RESET_B(net136),
    .D(_0249_),
    .Q(\pll_dig.div.div_pend[4] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4283_ (.RESET_B(net135),
    .D(_0252_),
    .Q(\pll_dig.div.div_pend[5] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4284_ (.RESET_B(net137),
    .D(_0293_),
    .Q(\pll_dig.div.div_pend[6] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4285_ (.RESET_B(net134),
    .D(_0271_),
    .Q(\pll_dig.div.div_pend[7] ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4286_ (.RESET_B(net138),
    .D(_0281_),
    .Q(\pll_dig.div.pend ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4287_ (.RESET_B(net258),
    .D(_0292_),
    .Q(\pll_dig.div.use_clk_p ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_tiehi _4287__259 (.L_HI(net258));
 sg13g2_dfrbpq_1 _4288_ (.RESET_B(net135),
    .D(_0274_),
    .Q(\pll_dig.div.enter_req ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4289_ (.RESET_B(net135),
    .D(_0270_),
    .Q(\pll_dig.div.leave_req ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4290_ (.RESET_B(net181),
    .D(_0276_),
    .Q(\pll_dig.dlf.INT[0] ),
    .CLK(_0161_));
 sg13g2_dfrbpq_1 _4291_ (.RESET_B(net164),
    .D(_0277_),
    .Q(\pll_dig.dlf.INT[1] ),
    .CLK(_0162_));
 sg13g2_dfrbpq_1 _4292_ (.RESET_B(net181),
    .D(_0279_),
    .Q(\pll_dig.dlf.INT[2] ),
    .CLK(_0163_));
 sg13g2_dfrbpq_1 _4293_ (.RESET_B(net181),
    .D(_0273_),
    .Q(\pll_dig.dlf.INT[3] ),
    .CLK(_0159_));
 sg13g2_dfrbpq_1 _4294_ (.RESET_B(net181),
    .D(_0275_),
    .Q(\pll_dig.dlf.INT[4] ),
    .CLK(_0160_));
 sg13g2_dfrbpq_1 _4295_ (.RESET_B(net185),
    .D(_0287_),
    .Q(\pll_dig.dlf.INT[5] ),
    .CLK(_0165_));
 sg13g2_dfrbpq_1 _4296_ (.RESET_B(net184),
    .D(_0269_),
    .Q(\pll_dig.dlf.INT[6] ),
    .CLK(_0157_));
 sg13g2_dfrbpq_1 _4297_ (.RESET_B(net184),
    .D(_0282_),
    .Q(\pll_dig.dlf.INT[7] ),
    .CLK(_0164_));
 sg13g2_dfrbpq_1 _4298_ (.RESET_B(net183),
    .D(_0290_),
    .Q(\pll_dig.dlf.INT[8] ),
    .CLK(_0167_));
 sg13g2_dfrbpq_1 _4299_ (.RESET_B(net183),
    .D(_0272_),
    .Q(\pll_dig.dlf.INT[9] ),
    .CLK(_0158_));
 sg13g2_dfrbpq_1 _4300_ (.RESET_B(net183),
    .D(_0294_),
    .Q(\pll_dig.dlf.INT[10] ),
    .CLK(_0169_));
 sg13g2_dfrbpq_1 _4301_ (.RESET_B(net183),
    .D(_0255_),
    .Q(\pll_dig.dlf.INT[11] ),
    .CLK(_0155_));
 sg13g2_dfrbpq_1 _4302_ (.RESET_B(net183),
    .D(_0254_),
    .Q(\pll_dig.dlf.INT[12] ),
    .CLK(_0154_));
 sg13g2_dfrbpq_1 _4303_ (.RESET_B(net182),
    .D(_0256_),
    .Q(\pll_dig.dlf.INT[13] ),
    .CLK(_0156_));
 sg13g2_dfrbpq_1 _4304_ (.RESET_B(net182),
    .D(_0291_),
    .Q(\pll_dig.dlf.INT[14] ),
    .CLK(_0168_));
 sg13g2_dfrbpq_1 _4305_ (.RESET_B(net184),
    .D(_0289_),
    .Q(_0129_),
    .CLK(_0166_));
 sg13g2_dfrbpq_1 _4306_ (.RESET_B(net197),
    .D(_0288_),
    .Q(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4307_ (.RESET_B(net195),
    .D(_0286_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4308_ (.RESET_B(net195),
    .D(_0280_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4309_ (.RESET_B(net195),
    .D(_0284_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4310_ (.RESET_B(net195),
    .D(_0278_),
    .Q(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4311_ (.RESET_B(net187),
    .D(_0283_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4312_ (.RESET_B(net187),
    .D(_0285_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4313_ (.RESET_B(net187),
    .D(_0388_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[2] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4314_ (.RESET_B(net187),
    .D(_0438_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4315_ (.RESET_B(net191),
    .D(_0383_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4316_ (.RESET_B(net191),
    .D(_0325_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4317_ (.RESET_B(net191),
    .D(_0300_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4318_ (.RESET_B(net198),
    .D(_0260_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[7] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4319_ (.RESET_B(net198),
    .D(_0259_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4320_ (.RESET_B(net198),
    .D(_0387_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4321_ (.RESET_B(net198),
    .D(_0437_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_2 _4322_ (.RESET_B(net199),
    .D(_0382_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4323_ (.RESET_B(net187),
    .D(_0376_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4324_ (.RESET_B(net187),
    .D(_0324_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4325_ (.RESET_B(net187),
    .D(_0301_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[2] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4326_ (.RESET_B(net188),
    .D(_0261_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4327_ (.RESET_B(net191),
    .D(_0386_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4328_ (.RESET_B(net191),
    .D(_0436_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[5] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4329_ (.RESET_B(net191),
    .D(_0381_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[6] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4330_ (.RESET_B(net192),
    .D(_0323_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[7] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4331_ (.RESET_B(net198),
    .D(_0299_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[8] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4332_ (.RESET_B(net199),
    .D(_0262_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[9] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4333_ (.RESET_B(net198),
    .D(_0258_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4334_ (.RESET_B(net198),
    .D(_0385_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4335_ (.RESET_B(net185),
    .D(_0435_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4336_ (.RESET_B(net187),
    .D(_0380_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4337_ (.RESET_B(net188),
    .D(_0375_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4338_ (.RESET_B(net188),
    .D(_0322_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4339_ (.RESET_B(net185),
    .D(_0302_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4340_ (.RESET_B(net189),
    .D(_0263_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4341_ (.RESET_B(net189),
    .D(_0384_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4342_ (.RESET_B(net189),
    .D(_0379_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4343_ (.RESET_B(net199),
    .D(_0318_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4344_ (.RESET_B(net197),
    .D(_0264_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4345_ (.RESET_B(net197),
    .D(_0349_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4346_ (.RESET_B(net197),
    .D(_0305_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4347_ (.RESET_B(net174),
    .D(net270),
    .Q(\pll_dig.dsm_impl.DSM_CK ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4348_ (.RESET_B(net169),
    .D(_0304_),
    .Q(\pll_dig.COARSE_MUX_D[0] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4349_ (.RESET_B(net169),
    .D(_0303_),
    .Q(\pll_dig.COARSE_MUX_D[14] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4350_ (.RESET_B(net169),
    .D(_0399_),
    .Q(\pll_dig.COARSE_MUX_D[1] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4351_ (.RESET_B(net166),
    .D(_0426_),
    .Q(\pll_dig.COARSE_MUX_D[2] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4352_ (.RESET_B(net166),
    .D(_0377_),
    .Q(\pll_dig.COARSE_MUX_D[3] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4353_ (.RESET_B(net165),
    .D(_0429_),
    .Q(\pll_dig.COARSE_MUX_D[4] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4354_ (.RESET_B(net165),
    .D(_0338_),
    .Q(\pll_dig.COARSE_MUX_D[5] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4355_ (.RESET_B(net165),
    .D(_0405_),
    .Q(\pll_dig.COARSE_MUX_D[6] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4356_ (.RESET_B(net162),
    .D(_0396_),
    .Q(\pll_dig.COARSE_MUX_D[7] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4357_ (.RESET_B(net162),
    .D(_0378_),
    .Q(\pll_dig.COARSE_MUX_D[8] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4358_ (.RESET_B(net162),
    .D(_0423_),
    .Q(\pll_dig.COARSE_MUX_D[9] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4359_ (.RESET_B(net160),
    .D(_0337_),
    .Q(\pll_dig.COARSE_MUX_D[10] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4360_ (.RESET_B(net160),
    .D(_0392_),
    .Q(\pll_dig.COARSE_MUX_D[11] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4361_ (.RESET_B(net160),
    .D(_0402_),
    .Q(\pll_dig.COARSE_MUX_D[12] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4362_ (.RESET_B(net160),
    .D(_0348_),
    .Q(\pll_dig.COARSE_MUX_D[13] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4363_ (.RESET_B(net169),
    .D(_0393_),
    .Q(\pll_dig.MID_MUX_D[0] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4364_ (.RESET_B(net169),
    .D(_0336_),
    .Q(\pll_dig.MID_MUX_D[14] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4365_ (.RESET_B(net170),
    .D(_0433_),
    .Q(\pll_dig.MID_MUX_D[1] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4366_ (.RESET_B(net170),
    .D(_0390_),
    .Q(\pll_dig.MID_MUX_D[2] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4367_ (.RESET_B(net170),
    .D(_0374_),
    .Q(\pll_dig.MID_MUX_D[3] ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4368_ (.RESET_B(net170),
    .D(_0400_),
    .Q(\pll_dig.MID_MUX_D[4] ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4369_ (.RESET_B(net176),
    .D(_0335_),
    .Q(\pll_dig.MID_MUX_D[5] ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4370_ (.RESET_B(net172),
    .D(_0428_),
    .Q(\pll_dig.MID_MUX_D[6] ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4371_ (.RESET_B(net172),
    .D(_0431_),
    .Q(\pll_dig.MID_MUX_D[7] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4372_ (.RESET_B(net167),
    .D(_0351_),
    .Q(\pll_dig.MID_MUX_D[8] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4373_ (.RESET_B(net167),
    .D(_0266_),
    .Q(\pll_dig.MID_MUX_D[9] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4374_ (.RESET_B(net167),
    .D(_0334_),
    .Q(\pll_dig.MID_MUX_D[10] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4375_ (.RESET_B(net167),
    .D(_0398_),
    .Q(\pll_dig.MID_MUX_D[11] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4376_ (.RESET_B(net167),
    .D(_0425_),
    .Q(\pll_dig.MID_MUX_D[12] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4377_ (.RESET_B(net166),
    .D(_0331_),
    .Q(\pll_dig.MID_MUX_D[13] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4378_ (.RESET_B(net170),
    .D(_0265_),
    .Q(\pll_dig.flock.started ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4379_ (.RESET_B(net202),
    .D(_0361_),
    .Q(\pll_dig.FREQ_OK ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4380_ (.RESET_B(net201),
    .D(_0333_),
    .Q(\pll_dig.flock.freq_miss[0] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4381_ (.RESET_B(net203),
    .D(_0404_),
    .Q(\pll_dig.flock.freq_miss[1] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4382_ (.RESET_B(net201),
    .D(_0395_),
    .Q(\pll_dig.flock.freq_miss[2] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4383_ (.RESET_B(net207),
    .D(_0330_),
    .Q(\pll_dig.flock.cnt[1] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_2 _4384_ (.RESET_B(net205),
    .D(_0268_),
    .Q(\pll_dig.flock.cnt[2] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4385_ (.RESET_B(net211),
    .D(_0373_),
    .Q(\pll_dig.flock.cnt[3] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4386_ (.RESET_B(net209),
    .D(_0367_),
    .Q(\pll_dig.flock.cnt[4] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4387_ (.RESET_B(net210),
    .D(_0332_),
    .Q(\pll_dig.flock.cnt[5] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4388_ (.RESET_B(net223),
    .D(_0391_),
    .Q(\pll_dig.flock.cnt[6] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4389_ (.RESET_B(net223),
    .D(_0401_),
    .Q(\pll_dig.flock.cnt[7] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4390_ (.RESET_B(net224),
    .D(_0350_),
    .Q(\pll_dig.flock.cnt[8] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4391_ (.RESET_B(net224),
    .D(_0267_),
    .Q(\pll_dig.flock.cnt[9] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4392_ (.RESET_B(net224),
    .D(_0410_),
    .Q(\pll_dig.flock.cnt[10] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4393_ (.RESET_B(net229),
    .D(_0372_),
    .Q(\pll_dig.flock.cnt[11] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4394_ (.RESET_B(net229),
    .D(_0366_),
    .Q(\pll_dig.flock.cnt[12] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4395_ (.RESET_B(net228),
    .D(_0347_),
    .Q(\pll_dig.flock.cnt[13] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4396_ (.RESET_B(net228),
    .D(_0343_),
    .Q(\pll_dig.flock.cnt[14] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4397_ (.RESET_B(net228),
    .D(_0432_),
    .Q(\pll_dig.flock.cnt[15] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4398_ (.RESET_B(net205),
    .D(_0389_),
    .Q(\pll_dig.flock.cnt_gray[0] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4399_ (.RESET_B(net205),
    .D(_0298_),
    .Q(\pll_dig.flock.cnt_gray[1] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4400_ (.RESET_B(net210),
    .D(_0409_),
    .Q(\pll_dig.flock.cnt_gray[2] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4401_ (.RESET_B(net209),
    .D(_0371_),
    .Q(\pll_dig.flock.cnt_gray[3] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4402_ (.RESET_B(net209),
    .D(_0365_),
    .Q(\pll_dig.flock.cnt_gray[4] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4403_ (.RESET_B(net223),
    .D(_0346_),
    .Q(\pll_dig.flock.cnt_gray[5] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4404_ (.RESET_B(net223),
    .D(_0342_),
    .Q(\pll_dig.flock.cnt_gray[6] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4405_ (.RESET_B(net224),
    .D(_0427_),
    .Q(\pll_dig.flock.cnt_gray[7] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4406_ (.RESET_B(net224),
    .D(_0430_),
    .Q(\pll_dig.flock.cnt_gray[8] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4407_ (.RESET_B(net229),
    .D(_0297_),
    .Q(\pll_dig.flock.cnt_gray[9] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4408_ (.RESET_B(net229),
    .D(_0408_),
    .Q(\pll_dig.flock.cnt_gray[10] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4409_ (.RESET_B(net229),
    .D(_0370_),
    .Q(\pll_dig.flock.cnt_gray[11] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4410_ (.RESET_B(net228),
    .D(_0364_),
    .Q(\pll_dig.flock.cnt_gray[12] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4411_ (.RESET_B(net228),
    .D(_0345_),
    .Q(\pll_dig.flock.cnt_gray[13] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4412_ (.RESET_B(net228),
    .D(_0341_),
    .Q(\pll_dig.flock.cnt_gray[14] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4413_ (.RESET_B(net228),
    .D(_0397_),
    .Q(\pll_dig.flock.cnt_gray[15] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4414_ (.RESET_B(net176),
    .D(_0424_),
    .Q(\pll_dig.PHASE_LOCK ),
    .CLK(_0244_));
 sg13g2_dfrbpq_1 _4415_ (.RESET_B(net174),
    .D(_0295_),
    .Q(\pll_dig.LOCK_LOST ),
    .CLK(_0171_));
 sg13g2_dfrbpq_1 _4416_ (.RESET_B(net233),
    .D(_0407_),
    .Q(\pll_dig.ref_wd.cnt[0] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4417_ (.RESET_B(net233),
    .D(_0369_),
    .Q(\pll_dig.ref_wd.cnt[1] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4418_ (.RESET_B(net233),
    .D(_0363_),
    .Q(\pll_dig.ref_wd.cnt[2] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4419_ (.RESET_B(net233),
    .D(_0344_),
    .Q(\pll_dig.ref_wd.cnt[3] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4420_ (.RESET_B(net234),
    .D(_0340_),
    .Q(\pll_dig.ref_wd.cnt[4] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_1 _4421_ (.RESET_B(net235),
    .D(_0403_),
    .Q(\pll_dig.ref_wd.cnt[5] ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4422_ (.RESET_B(net235),
    .D(_0394_),
    .Q(\pll_dig.ref_wd.cnt[6] ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4423_ (.RESET_B(net236),
    .D(_0296_),
    .Q(\pll_dig.ref_wd.cnt[7] ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4424_ (.RESET_B(net236),
    .D(_0406_),
    .Q(\pll_dig.ref_wd.cnt[8] ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4425_ (.RESET_B(net233),
    .D(_0368_),
    .Q(\pll_dig.ref_wd.cnt[9] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_1 _4426_ (.RESET_B(net233),
    .D(_0362_),
    .Q(_0135_),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4427_ (.RESET_B(net176),
    .D(_0213_),
    .Q(_0134_),
    .CLK(_0214_));
 sg13g2_dfrbpq_1 _4428_ (.RESET_B(net176),
    .D(_0048_),
    .Q(\pll_dig.state[1] ),
    .CLK(_0212_));
 sg13g2_dfrbpq_1 _4429_ (.RESET_B(net177),
    .D(_0049_),
    .Q(\pll_dig.state[2] ),
    .CLK(_0230_));
 sg13g2_dfrbpq_1 _4430_ (.RESET_B(net176),
    .D(_0050_),
    .Q(\pll_dig.state[3] ),
    .CLK(_0233_));
 sg13g2_dfrbpq_1 _4431_ (.RESET_B(net178),
    .D(_0051_),
    .Q(\pll_dig.state[4] ),
    .CLK(_0170_));
 sg13g2_dfrbpq_1 _4432_ (.RESET_B(net195),
    .D(\pll_dig.FILTER_OUT[12] ),
    .Q(\pll_dig.dsm_impl.FCWI[1] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4433_ (.RESET_B(net195),
    .D(\pll_dig.FILTER_OUT[13] ),
    .Q(\pll_dig.dsm_impl.FCWI[2] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4434_ (.RESET_B(net193),
    .D(\pll_dig.FILTER_OUT[14] ),
    .Q(\pll_dig.dsm_impl.FCWI[3] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4435_ (.RESET_B(net193),
    .D(\pll_dig.FILTER_OUT[15] ),
    .Q(\pll_dig.dsm_impl.FCWI[4] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4436_ (.RESET_B(net134),
    .D(_0095_),
    .Q(\pll_dig.u_ddr_ck.ck_en ),
    .CLK(net272));
 sg13g2_dfrbpq_1 _4437_ (.RESET_B(net134),
    .D(_0172_),
    .Q(_0130_),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4438_ (.RESET_B(net141),
    .D(_0045_),
    .Q(\pll_dig.div.p_hi ),
    .CLK(net260));
 sg13g2_dfrbpq_2 _4439_ (.RESET_B(net143),
    .D(_0078_),
    .Q(\pll_dig.div.cnt[0] ),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_2 _4440_ (.RESET_B(net143),
    .D(_0079_),
    .Q(\pll_dig.div.cnt[1] ),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_1 _4441_ (.RESET_B(net139),
    .D(_0080_),
    .Q(\pll_dig.div.cnt[2] ),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_1 _4442_ (.RESET_B(net139),
    .D(_0081_),
    .Q(\pll_dig.div.cnt[3] ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4443_ (.RESET_B(net139),
    .D(_0082_),
    .Q(\pll_dig.div.cnt[4] ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4444_ (.RESET_B(net138),
    .D(_0083_),
    .Q(\pll_dig.div.cnt[5] ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4445_ (.RESET_B(net138),
    .D(_0084_),
    .Q(\pll_dig.div.cnt[6] ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4446_ (.RESET_B(net140),
    .D(_0085_),
    .Q(\pll_dig.div.cnt[7] ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_2 _4447_ (.RESET_B(net142),
    .D(_0087_),
    .Q(\pll_dig.div.pcnt[0] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_2 _4448_ (.RESET_B(net142),
    .D(_0088_),
    .Q(\pll_dig.div.pcnt[1] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_2 _4449_ (.RESET_B(net142),
    .D(_0089_),
    .Q(\pll_dig.div.pcnt[2] ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4450_ (.RESET_B(net142),
    .D(_0090_),
    .Q(\pll_dig.div.pcnt[3] ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4451_ (.RESET_B(net142),
    .D(_0091_),
    .Q(\pll_dig.div.pcnt[4] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4452_ (.RESET_B(net141),
    .D(_0092_),
    .Q(\pll_dig.div.pcnt[5] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4453_ (.RESET_B(net141),
    .D(_0093_),
    .Q(\pll_dig.div.pcnt[6] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4454_ (.RESET_B(net141),
    .D(_0094_),
    .Q(\pll_dig.div.pcnt[7] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4455_ (.RESET_B(net143),
    .D(_0235_),
    .Q(_0136_),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_1 _4456_ (.RESET_B(net140),
    .D(\pll_dig.div.high_count_pend[1] ),
    .Q(\pll_dig.div.high_count[1] ),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_1 _4457_ (.RESET_B(net139),
    .D(\pll_dig.div.high_count_pend[2] ),
    .Q(\pll_dig.div.high_count[2] ),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4458_ (.RESET_B(net139),
    .D(\pll_dig.div.high_count_pend[3] ),
    .Q(\pll_dig.div.high_count[3] ),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4459_ (.RESET_B(net139),
    .D(\pll_dig.div.high_count_pend[4] ),
    .Q(\pll_dig.div.high_count[4] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4460_ (.RESET_B(net138),
    .D(\pll_dig.div.high_count_pend[5] ),
    .Q(\pll_dig.div.high_count[5] ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4461_ (.RESET_B(net138),
    .D(\pll_dig.div.high_count_pend[6] ),
    .Q(\pll_dig.div.high_count[6] ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4462_ (.RESET_B(net138),
    .D(\pll_dig.div.high_count_pend[7] ),
    .Q(\pll_dig.div.high_count[7] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_2 _4463_ (.RESET_B(net142),
    .D(_0037_),
    .Q(\pll_dig.div.ncnt[0] ),
    .CLK(net262));
 sg13g2_dfrbpq_2 _4464_ (.RESET_B(net144),
    .D(_0038_),
    .Q(\pll_dig.div.ncnt[1] ),
    .CLK(net263));
 sg13g2_dfrbpq_1 _4465_ (.RESET_B(net144),
    .D(_0039_),
    .Q(\pll_dig.div.ncnt[2] ),
    .CLK(net265));
 sg13g2_dfrbpq_1 _4466_ (.RESET_B(net144),
    .D(_0040_),
    .Q(\pll_dig.div.ncnt[3] ),
    .CLK(net261));
 sg13g2_dfrbpq_1 _4467_ (.RESET_B(net144),
    .D(_0041_),
    .Q(\pll_dig.div.ncnt[4] ),
    .CLK(net266));
 sg13g2_dfrbpq_1 _4468_ (.RESET_B(net143),
    .D(_0042_),
    .Q(\pll_dig.div.ncnt[5] ),
    .CLK(net268));
 sg13g2_dfrbpq_1 _4469_ (.RESET_B(net144),
    .D(_0043_),
    .Q(\pll_dig.div.ncnt[6] ),
    .CLK(net269));
 sg13g2_dfrbpq_1 _4470_ (.RESET_B(net143),
    .D(_0044_),
    .Q(\pll_dig.div.ncnt[7] ),
    .CLK(net267));
 sg13g2_dfrbpq_1 _4471_ (.RESET_B(net141),
    .D(_0086_),
    .Q(\pll_dig.div.n_hi ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4472_ (.RESET_B(net202),
    .D(_0105_),
    .Q(\pll_dig.flock.cnt_bin[0] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4473_ (.RESET_B(net205),
    .D(_0111_),
    .Q(\pll_dig.flock.cnt_bin[1] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4474_ (.RESET_B(net210),
    .D(_0112_),
    .Q(\pll_dig.flock.cnt_bin[2] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4475_ (.RESET_B(net210),
    .D(_0113_),
    .Q(\pll_dig.flock.cnt_bin[3] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4476_ (.RESET_B(net204),
    .D(_0114_),
    .Q(\pll_dig.flock.cnt_bin[4] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4477_ (.RESET_B(net209),
    .D(_0115_),
    .Q(\pll_dig.flock.cnt_bin[5] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4478_ (.RESET_B(net216),
    .D(_0116_),
    .Q(\pll_dig.flock.cnt_bin[6] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4479_ (.RESET_B(net216),
    .D(_0117_),
    .Q(\pll_dig.flock.cnt_bin[7] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4480_ (.RESET_B(net217),
    .D(_0118_),
    .Q(\pll_dig.flock.cnt_bin[8] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4481_ (.RESET_B(net217),
    .D(_0119_),
    .Q(\pll_dig.flock.cnt_bin[9] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4482_ (.RESET_B(net219),
    .D(_0106_),
    .Q(\pll_dig.flock.cnt_bin[10] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4483_ (.RESET_B(net219),
    .D(_0107_),
    .Q(\pll_dig.flock.cnt_bin[11] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4484_ (.RESET_B(net220),
    .D(_0108_),
    .Q(\pll_dig.flock.cnt_bin[12] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4485_ (.RESET_B(net220),
    .D(_0109_),
    .Q(\pll_dig.flock.cnt_bin[13] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4486_ (.RESET_B(net220),
    .D(_0110_),
    .Q(\pll_dig.flock.cnt_bin[14] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4487_ (.RESET_B(net176),
    .D(_0012_),
    .Q(\pll_dig.FREQ_LOCKED ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4488_ (.RESET_B(net170),
    .D(_0011_),
    .Q(\pll_dig.FREQ_ERR ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4489_ (.RESET_B(net202),
    .D(net460),
    .Q(\pll_dig.flock.cnt_filt[0] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4490_ (.RESET_B(net202),
    .D(net516),
    .Q(\pll_dig.flock.cnt_filt[1] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4491_ (.RESET_B(net204),
    .D(net512),
    .Q(\pll_dig.flock.cnt_filt[2] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4492_ (.RESET_B(net204),
    .D(net521),
    .Q(\pll_dig.flock.cnt_filt[3] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4493_ (.RESET_B(net204),
    .D(net525),
    .Q(\pll_dig.flock.cnt_filt[4] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4494_ (.RESET_B(net215),
    .D(net498),
    .Q(\pll_dig.flock.cnt_filt[5] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4495_ (.RESET_B(net216),
    .D(net471),
    .Q(\pll_dig.flock.cnt_filt[6] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4496_ (.RESET_B(net216),
    .D(net479),
    .Q(\pll_dig.flock.cnt_filt[7] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4497_ (.RESET_B(net217),
    .D(net475),
    .Q(\pll_dig.flock.cnt_filt[8] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4498_ (.RESET_B(net218),
    .D(net467),
    .Q(\pll_dig.flock.cnt_filt[9] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4499_ (.RESET_B(net218),
    .D(net488),
    .Q(\pll_dig.flock.cnt_filt[10] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4500_ (.RESET_B(net218),
    .D(net484),
    .Q(\pll_dig.flock.cnt_filt[11] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4501_ (.RESET_B(net222),
    .D(net502),
    .Q(\pll_dig.flock.cnt_filt[12] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4502_ (.RESET_B(net222),
    .D(net507),
    .Q(\pll_dig.flock.cnt_filt[13] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4503_ (.RESET_B(net222),
    .D(net494),
    .Q(\pll_dig.flock.cnt_filt[14] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4504_ (.RESET_B(net222),
    .D(net463),
    .Q(\pll_dig.flock.cnt_filt[15] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4505_ (.RESET_B(net201),
    .D(_0021_),
    .Q(\pll_dig.flock.cnt_done[0] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4506_ (.RESET_B(net201),
    .D(net531),
    .Q(\pll_dig.flock.cnt_done[1] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4507_ (.RESET_B(net202),
    .D(_0023_),
    .Q(\pll_dig.flock.cnt_done[2] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4508_ (.RESET_B(net205),
    .D(_0024_),
    .Q(\pll_dig.flock.cnt_done[3] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4509_ (.RESET_B(net206),
    .D(_0025_),
    .Q(\pll_dig.flock.cnt_done[4] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4510_ (.RESET_B(net206),
    .D(_0026_),
    .Q(\pll_dig.flock.cnt_done[5] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4511_ (.RESET_B(net178),
    .D(_0027_),
    .Q(\pll_dig.flock.cnt_done[6] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4512_ (.RESET_B(net171),
    .D(_0028_),
    .Q(\pll_dig.flock.cnt_done[7] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4513_ (.RESET_B(net169),
    .D(_0029_),
    .Q(\pll_dig.flock.cnt_err[0] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4514_ (.RESET_B(net169),
    .D(_0030_),
    .Q(\pll_dig.flock.cnt_err[1] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4515_ (.RESET_B(net171),
    .D(_0031_),
    .Q(\pll_dig.flock.cnt_err[2] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4516_ (.RESET_B(net170),
    .D(_0032_),
    .Q(\pll_dig.flock.cnt_err[3] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4517_ (.RESET_B(net170),
    .D(_0033_),
    .Q(\pll_dig.flock.cnt_err[4] ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4518_ (.RESET_B(net171),
    .D(_0034_),
    .Q(\pll_dig.flock.cnt_err[5] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4519_ (.RESET_B(net201),
    .D(_0035_),
    .Q(\pll_dig.flock.cnt_err[6] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4520_ (.RESET_B(net201),
    .D(_0036_),
    .Q(\pll_dig.flock.cnt_err[7] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4521_ (.RESET_B(net169),
    .D(_0013_),
    .Q(\pll_dig.flock.cnt_coarse_wait[0] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4522_ (.RESET_B(net171),
    .D(_0014_),
    .Q(\pll_dig.flock.cnt_coarse_wait[1] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4523_ (.RESET_B(net203),
    .D(_0015_),
    .Q(\pll_dig.flock.cnt_coarse_wait[2] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4524_ (.RESET_B(net203),
    .D(_0016_),
    .Q(\pll_dig.flock.cnt_coarse_wait[3] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4525_ (.RESET_B(net203),
    .D(_0017_),
    .Q(\pll_dig.flock.cnt_coarse_wait[4] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4526_ (.RESET_B(net203),
    .D(_0018_),
    .Q(\pll_dig.flock.cnt_coarse_wait[5] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4527_ (.RESET_B(net203),
    .D(_0019_),
    .Q(\pll_dig.flock.cnt_coarse_wait[6] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4528_ (.RESET_B(net171),
    .D(_0020_),
    .Q(\pll_dig.flock.cnt_coarse_wait[7] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4529_ (.RESET_B(net240),
    .D(_0098_),
    .Q(\pll_dig.flock.FCW_PA[1] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4529__241 (.L_HI(net240));
 sg13g2_dfrbpq_1 _4530_ (.RESET_B(net241),
    .D(_0099_),
    .Q(\pll_dig.flock.FCW_PA[2] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4530__242 (.L_HI(net241));
 sg13g2_dfrbpq_1 _4531_ (.RESET_B(net247),
    .D(_0100_),
    .Q(\pll_dig.flock.FCW_PA[3] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4531__248 (.L_HI(net247));
 sg13g2_dfrbpq_1 _4532_ (.RESET_B(net242),
    .D(_0101_),
    .Q(\pll_dig.flock.FCW_PA[4] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_tiehi _4532__243 (.L_HI(net242));
 sg13g2_dfrbpq_1 _4533_ (.RESET_B(net243),
    .D(_0102_),
    .Q(\pll_dig.flock.FCW_PA[5] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4533__244 (.L_HI(net243));
 sg13g2_dfrbpq_1 _4534_ (.RESET_B(net252),
    .D(_0103_),
    .Q(\pll_dig.flock.FCW_PA[6] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4534__253 (.L_HI(net252));
 sg13g2_dfrbpq_1 _4535_ (.RESET_B(net244),
    .D(_0104_),
    .Q(\pll_dig.flock.FCW_PA[7] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_tiehi _4535__245 (.L_HI(net244));
 sg13g2_dfrbpq_1 _4536_ (.RESET_B(net245),
    .D(_0097_),
    .Q(\pll_dig.flock.FCW_PA[8] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_tiehi _4536__246 (.L_HI(net245));
 sg13g2_dfrbpq_1 _4537_ (.RESET_B(net253),
    .D(_0096_),
    .Q(\pll_dig.flock.FCW_NA[0] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4537__254 (.L_HI(net253));
 sg13g2_dfrbpq_1 _4538_ (.RESET_B(net248),
    .D(_0120_),
    .Q(\pll_dig.flock.FCW_NA[1] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4538__249 (.L_HI(net248));
 sg13g2_dfrbpq_1 _4539_ (.RESET_B(net249),
    .D(_0121_),
    .Q(\pll_dig.flock.FCW_NA[2] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4539__250 (.L_HI(net249));
 sg13g2_dfrbpq_1 _4540_ (.RESET_B(net251),
    .D(_0122_),
    .Q(\pll_dig.flock.FCW_NA[3] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4540__252 (.L_HI(net251));
 sg13g2_dfrbpq_1 _4541_ (.RESET_B(net250),
    .D(_0123_),
    .Q(\pll_dig.flock.FCW_NA[4] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_tiehi _4541__251 (.L_HI(net250));
 sg13g2_dfrbpq_1 _4542_ (.RESET_B(net246),
    .D(_0124_),
    .Q(\pll_dig.flock.FCW_NA[5] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_tiehi _4542__247 (.L_HI(net246));
 sg13g2_dfrbpq_1 _4543_ (.RESET_B(net256),
    .D(_0125_),
    .Q(\pll_dig.flock.FCW_NA[6] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4543__257 (.L_HI(net256));
 sg13g2_dfrbpq_1 _4544_ (.RESET_B(net255),
    .D(_0126_),
    .Q(\pll_dig.flock.FCW_NA[7] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_tiehi _4544__256 (.L_HI(net255));
 sg13g2_dfrbpq_1 _4545_ (.RESET_B(net257),
    .D(_0127_),
    .Q(\pll_dig.flock.FCW_NA[10] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_tiehi _4545__258 (.L_HI(net257));
 sg13g2_dfrbpq_1 _4546_ (.RESET_B(net220),
    .D(net254),
    .Q(\pll_dig.flock.cap_valid ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_tiehi _4546__255 (.L_HI(net254));
 sg13g2_dfrbpq_1 _4547_ (.RESET_B(net205),
    .D(\pll_dig.flock.cnt_gray[0] ),
    .Q(\pll_dig.flock.cnt_gray_s1[0] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4548_ (.RESET_B(net207),
    .D(\pll_dig.flock.cnt_gray[1] ),
    .Q(\pll_dig.flock.cnt_gray_s1[1] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4549_ (.RESET_B(net210),
    .D(\pll_dig.flock.cnt_gray[2] ),
    .Q(\pll_dig.flock.cnt_gray_s1[2] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4550_ (.RESET_B(net209),
    .D(\pll_dig.flock.cnt_gray[3] ),
    .Q(\pll_dig.flock.cnt_gray_s1[3] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4551_ (.RESET_B(net209),
    .D(\pll_dig.flock.cnt_gray[4] ),
    .Q(\pll_dig.flock.cnt_gray_s1[4] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4552_ (.RESET_B(net223),
    .D(\pll_dig.flock.cnt_gray[5] ),
    .Q(\pll_dig.flock.cnt_gray_s1[5] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4553_ (.RESET_B(net223),
    .D(\pll_dig.flock.cnt_gray[6] ),
    .Q(\pll_dig.flock.cnt_gray_s1[6] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4554_ (.RESET_B(net224),
    .D(\pll_dig.flock.cnt_gray[7] ),
    .Q(\pll_dig.flock.cnt_gray_s1[7] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4555_ (.RESET_B(net217),
    .D(\pll_dig.flock.cnt_gray[8] ),
    .Q(\pll_dig.flock.cnt_gray_s1[8] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4556_ (.RESET_B(net219),
    .D(\pll_dig.flock.cnt_gray[9] ),
    .Q(\pll_dig.flock.cnt_gray_s1[9] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4557_ (.RESET_B(net219),
    .D(\pll_dig.flock.cnt_gray[10] ),
    .Q(\pll_dig.flock.cnt_gray_s1[10] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4558_ (.RESET_B(net219),
    .D(\pll_dig.flock.cnt_gray[11] ),
    .Q(\pll_dig.flock.cnt_gray_s1[11] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4559_ (.RESET_B(net220),
    .D(\pll_dig.flock.cnt_gray[12] ),
    .Q(\pll_dig.flock.cnt_gray_s1[12] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4560_ (.RESET_B(net220),
    .D(\pll_dig.flock.cnt_gray[13] ),
    .Q(\pll_dig.flock.cnt_gray_s1[13] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4561_ (.RESET_B(net228),
    .D(\pll_dig.flock.cnt_gray[14] ),
    .Q(\pll_dig.flock.cnt_gray_s1[14] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4562_ (.RESET_B(net229),
    .D(\pll_dig.flock.cnt_gray[15] ),
    .Q(\pll_dig.flock.cnt_gray_s1[15] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4563_ (.RESET_B(net206),
    .D(\pll_dig.flock.cnt_gray_s1[0] ),
    .Q(\pll_dig.flock.cnt_gray_s2[0] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4564_ (.RESET_B(net207),
    .D(\pll_dig.flock.cnt_gray_s1[1] ),
    .Q(\pll_dig.flock.cnt_gray_s2[1] ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4565_ (.RESET_B(net210),
    .D(\pll_dig.flock.cnt_gray_s1[2] ),
    .Q(\pll_dig.flock.cnt_gray_s2[2] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4566_ (.RESET_B(net209),
    .D(\pll_dig.flock.cnt_gray_s1[3] ),
    .Q(\pll_dig.flock.cnt_gray_s2[3] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4567_ (.RESET_B(net209),
    .D(\pll_dig.flock.cnt_gray_s1[4] ),
    .Q(\pll_dig.flock.cnt_gray_s2[4] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4568_ (.RESET_B(net223),
    .D(\pll_dig.flock.cnt_gray_s1[5] ),
    .Q(\pll_dig.flock.cnt_gray_s2[5] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4569_ (.RESET_B(net223),
    .D(\pll_dig.flock.cnt_gray_s1[6] ),
    .Q(\pll_dig.flock.cnt_gray_s2[6] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4570_ (.RESET_B(net217),
    .D(\pll_dig.flock.cnt_gray_s1[7] ),
    .Q(\pll_dig.flock.cnt_gray_s2[7] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4571_ (.RESET_B(net224),
    .D(\pll_dig.flock.cnt_gray_s1[8] ),
    .Q(\pll_dig.flock.cnt_gray_s2[8] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4572_ (.RESET_B(net219),
    .D(\pll_dig.flock.cnt_gray_s1[9] ),
    .Q(\pll_dig.flock.cnt_gray_s2[9] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4573_ (.RESET_B(net219),
    .D(\pll_dig.flock.cnt_gray_s1[10] ),
    .Q(\pll_dig.flock.cnt_gray_s2[10] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4574_ (.RESET_B(net221),
    .D(\pll_dig.flock.cnt_gray_s1[11] ),
    .Q(\pll_dig.flock.cnt_gray_s2[11] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4575_ (.RESET_B(net220),
    .D(\pll_dig.flock.cnt_gray_s1[12] ),
    .Q(\pll_dig.flock.cnt_gray_s2[12] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4576_ (.RESET_B(net221),
    .D(\pll_dig.flock.cnt_gray_s1[13] ),
    .Q(\pll_dig.flock.cnt_gray_s2[13] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4577_ (.RESET_B(net230),
    .D(\pll_dig.flock.cnt_gray_s1[14] ),
    .Q(\pll_dig.flock.cnt_gray_s2[14] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4578_ (.RESET_B(net230),
    .D(\pll_dig.flock.cnt_gray_s1[15] ),
    .Q(\pll_dig.flock.cnt_gray_s2[15] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4579_ (.RESET_B(net229),
    .D(_0046_),
    .Q(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4580_ (.RESET_B(net230),
    .D(_0047_),
    .Q(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4581_ (.RESET_B(net175),
    .D(_0056_),
    .Q(\pll_dig.lock_detector.seen_n ),
    .CLK(_0176_));
 sg13g2_dfrbpq_1 _4582_ (.RESET_B(net173),
    .D(_0057_),
    .Q(\pll_dig.lock_detector.seen_p ),
    .CLK(_0232_));
 sg13g2_dfrbpq_1 _4583_ (.RESET_B(net174),
    .D(_0058_),
    .Q(\pll_dig.lock_detector.win_cnt[0] ),
    .CLK(_0181_));
 sg13g2_dfrbpq_1 _4584_ (.RESET_B(net177),
    .D(_0059_),
    .Q(\pll_dig.lock_detector.win_cnt[1] ),
    .CLK(_0192_));
 sg13g2_dfrbpq_1 _4585_ (.RESET_B(net177),
    .D(_0060_),
    .Q(\pll_dig.lock_detector.win_cnt[2] ),
    .CLK(_0234_));
 sg13g2_dfrbpq_1 _4586_ (.RESET_B(net174),
    .D(_0061_),
    .Q(\pll_dig.lock_detector.win_cnt[3] ),
    .CLK(_0179_));
 sg13g2_dfrbpq_1 _4587_ (.RESET_B(net174),
    .D(net239),
    .Q(\pll_dig.lock_detector.win_cnt[4] ),
    .CLK(_0174_));
 sg13g2_tielo _4587__240 (.L_LO(net239));
 sg13g2_dfrbpq_1 _4588_ (.RESET_B(net172),
    .D(_0053_),
    .Q(\pll_dig.lock_detector.bad_cnt[0] ),
    .CLK(_0231_));
 sg13g2_dfrbpq_1 _4589_ (.RESET_B(net172),
    .D(_0054_),
    .Q(\pll_dig.lock_detector.bad_cnt[1] ),
    .CLK(_0186_));
 sg13g2_dfrbpq_1 _4590_ (.RESET_B(net173),
    .D(net),
    .Q(\pll_dig.lock_detector.bad_cnt[2] ),
    .CLK(_0195_));
 sg13g2_dfrbpq_1 _4591_ (.RESET_B(net234),
    .D(\pll_dig.ref_wd.watch_s2 ),
    .Q(\pll_dig.ref_wd.watch_s3 ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4592_ (.RESET_B(net234),
    .D(\pll_dig.ref_wd.watch_s1 ),
    .Q(\pll_dig.ref_wd.watch_s2 ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4593_ (.RESET_B(net234),
    .D(clknet_1_1__leaf_REF),
    .Q(\pll_dig.ref_wd.watch_s1 ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4594_ (.RESET_B(net194),
    .D(\pll_dig.dlf.ILL_N_C ),
    .Q(\pll_dig.ILL_N ),
    .CLK(_0198_));
 sg13g2_dfrbpq_1 _4595_ (.RESET_B(net185),
    .D(\pll_dig.dlf.OUT_C[0] ),
    .Q(\pll_dig.FILTER_OUT[0] ),
    .CLK(_0224_));
 sg13g2_dfrbpq_1 _4596_ (.RESET_B(net185),
    .D(\pll_dig.dlf.OUT_C[1] ),
    .Q(\pll_dig.FILTER_OUT[1] ),
    .CLK(_0225_));
 sg13g2_dfrbpq_1 _4597_ (.RESET_B(net185),
    .D(\pll_dig.dlf.OUT_C[2] ),
    .Q(\pll_dig.FILTER_OUT[2] ),
    .CLK(_0236_));
 sg13g2_dfrbpq_1 _4598_ (.RESET_B(net186),
    .D(\pll_dig.dlf.OUT_C[3] ),
    .Q(\pll_dig.FILTER_OUT[3] ),
    .CLK(_0196_));
 sg13g2_dfrbpq_1 _4599_ (.RESET_B(net186),
    .D(\pll_dig.dlf.OUT_C[4] ),
    .Q(\pll_dig.FILTER_OUT[4] ),
    .CLK(_0173_));
 sg13g2_dfrbpq_1 _4600_ (.RESET_B(net189),
    .D(\pll_dig.dlf.OUT_C[5] ),
    .Q(\pll_dig.FILTER_OUT[5] ),
    .CLK(_0194_));
 sg13g2_dfrbpq_1 _4601_ (.RESET_B(net189),
    .D(\pll_dig.dlf.OUT_C[6] ),
    .Q(\pll_dig.FILTER_OUT[6] ),
    .CLK(_0193_));
 sg13g2_dfrbpq_1 _4602_ (.RESET_B(net189),
    .D(\pll_dig.dlf.OUT_C[7] ),
    .Q(\pll_dig.FILTER_OUT[7] ),
    .CLK(_0175_));
 sg13g2_dfrbpq_1 _4603_ (.RESET_B(net190),
    .D(\pll_dig.dlf.OUT_C[8] ),
    .Q(\pll_dig.FILTER_OUT[8] ),
    .CLK(_0191_));
 sg13g2_dfrbpq_1 _4604_ (.RESET_B(net190),
    .D(\pll_dig.dlf.OUT_C[9] ),
    .Q(\pll_dig.FILTER_OUT[9] ),
    .CLK(_0185_));
 sg13g2_dfrbpq_1 _4605_ (.RESET_B(net197),
    .D(\pll_dig.dlf.OUT_C[10] ),
    .Q(\pll_dig.FILTER_OUT[10] ),
    .CLK(_0190_));
 sg13g2_dfrbpq_1 _4606_ (.RESET_B(net196),
    .D(\pll_dig.dlf.OUT_C[11] ),
    .Q(\pll_dig.FILTER_OUT[11] ),
    .CLK(_0184_));
 sg13g2_dfrbpq_1 _4607_ (.RESET_B(net196),
    .D(\pll_dig.dlf.OUT_C[12] ),
    .Q(\pll_dig.FILTER_OUT[12] ),
    .CLK(_0189_));
 sg13g2_dfrbpq_1 _4608_ (.RESET_B(net193),
    .D(\pll_dig.dlf.OUT_C[13] ),
    .Q(\pll_dig.FILTER_OUT[13] ),
    .CLK(_0177_));
 sg13g2_dfrbpq_1 _4609_ (.RESET_B(net193),
    .D(\pll_dig.dlf.OUT_C[14] ),
    .Q(\pll_dig.FILTER_OUT[14] ),
    .CLK(_0188_));
 sg13g2_dfrbpq_1 _4610_ (.RESET_B(net193),
    .D(_0182_),
    .Q(_0131_),
    .CLK(_0183_));
 sg13g2_dfrbpq_1 _4611_ (.RESET_B(net194),
    .D(\pll_dig.dlf.ILL_P_C ),
    .Q(\pll_dig.ILL_P ),
    .CLK(_0187_));
 sg13g2_dfrbpq_1 _4612_ (.RESET_B(net226),
    .D(_0000_),
    .Q(\pll_dig.out_edges_gray[0] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4613_ (.RESET_B(net226),
    .D(_0001_),
    .Q(\pll_dig.out_edges_gray[1] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4614_ (.RESET_B(net230),
    .D(_0002_),
    .Q(\pll_dig.out_edges_gray[2] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4615_ (.RESET_B(net225),
    .D(_0003_),
    .Q(\pll_dig.out_edges_gray[3] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4616_ (.RESET_B(net225),
    .D(_0004_),
    .Q(\pll_dig.out_edges_gray[4] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4617_ (.RESET_B(net225),
    .D(_0005_),
    .Q(\pll_dig.out_edges_gray[5] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4618_ (.RESET_B(net212),
    .D(_0006_),
    .Q(\pll_dig.out_edges_gray[6] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4619_ (.RESET_B(net212),
    .D(_0007_),
    .Q(\pll_dig.out_edges_gray[7] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4620_ (.RESET_B(net211),
    .D(_0008_),
    .Q(\pll_dig.out_edges_gray[8] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4621_ (.RESET_B(net173),
    .D(clknet_1_0__leaf_REF),
    .Q(\pll_dig.CKR ),
    .CLK(net259));
 sg13g2_dfrbpq_1 _4622_ (.RESET_B(net207),
    .D(net540),
    .Q(\pll_dig.dco_fail ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4623_ (.RESET_B(net196),
    .D(net539),
    .Q(\pll_dig.fail_qq ),
    .CLK(_0204_));
 sg13g2_dfrbpq_1 _4624_ (.RESET_B(net230),
    .D(\pll_dig.out_edges_next[0] ),
    .Q(\pll_dig.out_edges[0] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4625_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_next[1] ),
    .Q(\pll_dig.out_edges[1] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4626_ (.RESET_B(net224),
    .D(\pll_dig.out_edges_next[2] ),
    .Q(\pll_dig.out_edges[2] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4627_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_next[3] ),
    .Q(\pll_dig.out_edges[3] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4628_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_next[4] ),
    .Q(\pll_dig.out_edges[4] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4629_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_next[5] ),
    .Q(\pll_dig.out_edges[5] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4630_ (.RESET_B(net212),
    .D(\pll_dig.out_edges_next[6] ),
    .Q(\pll_dig.out_edges[6] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4631_ (.RESET_B(net212),
    .D(\pll_dig.out_edges_next[7] ),
    .Q(\pll_dig.out_edges[7] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4632_ (.RESET_B(net211),
    .D(\pll_dig.out_edges_next[8] ),
    .Q(\pll_dig.out_edges[8] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4633_ (.RESET_B(net211),
    .D(\pll_dig.out_edges_next[9] ),
    .Q(\pll_dig.out_edges[9] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4634_ (.RESET_B(net178),
    .D(_0052_),
    .Q(\pll_dig.fail_q ),
    .CLK(_0237_));
 sg13g2_dfrbpq_1 _4635_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[0] ),
    .Q(\COARSE_MUX[0] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4636_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[1] ),
    .Q(\COARSE_MUX[1] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4637_ (.RESET_B(net166),
    .D(\pll_dig.COARSE_MUX_D[2] ),
    .Q(\COARSE_MUX[2] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4638_ (.RESET_B(net165),
    .D(\pll_dig.COARSE_MUX_D[3] ),
    .Q(\COARSE_MUX[3] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4639_ (.RESET_B(net165),
    .D(\pll_dig.COARSE_MUX_D[4] ),
    .Q(\COARSE_MUX[4] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4640_ (.RESET_B(net162),
    .D(\pll_dig.COARSE_MUX_D[5] ),
    .Q(\COARSE_MUX[5] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4641_ (.RESET_B(net162),
    .D(\pll_dig.COARSE_MUX_D[6] ),
    .Q(\COARSE_MUX[6] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4642_ (.RESET_B(net162),
    .D(\pll_dig.COARSE_MUX_D[7] ),
    .Q(\COARSE_MUX[7] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4643_ (.RESET_B(net180),
    .D(\pll_dig.COARSE_MUX_D[8] ),
    .Q(\COARSE_MUX[8] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4644_ (.RESET_B(net160),
    .D(\pll_dig.COARSE_MUX_D[9] ),
    .Q(\COARSE_MUX[9] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4645_ (.RESET_B(net160),
    .D(\pll_dig.COARSE_MUX_D[10] ),
    .Q(\COARSE_MUX[10] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4646_ (.RESET_B(net161),
    .D(\pll_dig.COARSE_MUX_D[11] ),
    .Q(\COARSE_MUX[11] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4647_ (.RESET_B(net160),
    .D(\pll_dig.COARSE_MUX_D[12] ),
    .Q(\COARSE_MUX[12] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4648_ (.RESET_B(net161),
    .D(\pll_dig.COARSE_MUX_D[13] ),
    .Q(\COARSE_MUX[13] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4649_ (.RESET_B(net160),
    .D(\pll_dig.COARSE_MUX_D[14] ),
    .Q(\COARSE_MUX[14] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4650_ (.RESET_B(net234),
    .D(\pll_dig.out_edges_g2[0] ),
    .Q(\pll_dig.out_edges_g2_q[0] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4651_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g2[1] ),
    .Q(\pll_dig.out_edges_g2_q[1] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4652_ (.RESET_B(net230),
    .D(\pll_dig.out_edges_g2[2] ),
    .Q(\pll_dig.out_edges_g2_q[2] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4653_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_g2[3] ),
    .Q(\pll_dig.out_edges_g2_q[3] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4654_ (.RESET_B(net233),
    .D(\pll_dig.out_edges_g2[4] ),
    .Q(\pll_dig.out_edges_g2_q[4] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4655_ (.RESET_B(net212),
    .D(\pll_dig.out_edges_g2[5] ),
    .Q(\pll_dig.out_edges_g2_q[5] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4656_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_g2[6] ),
    .Q(\pll_dig.out_edges_g2_q[6] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4657_ (.RESET_B(net236),
    .D(\pll_dig.out_edges_g2[7] ),
    .Q(\pll_dig.out_edges_g2_q[7] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4658_ (.RESET_B(net211),
    .D(\pll_dig.out_edges_g2[8] ),
    .Q(\pll_dig.out_edges_g2_q[8] ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4659_ (.RESET_B(net233),
    .D(\pll_dig.out_edges_g2[9] ),
    .Q(\pll_dig.out_edges_g2_q[9] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4660_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g1[0] ),
    .Q(\pll_dig.out_edges_g2[0] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4661_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g1[1] ),
    .Q(\pll_dig.out_edges_g2[1] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4662_ (.RESET_B(net230),
    .D(\pll_dig.out_edges_g1[2] ),
    .Q(\pll_dig.out_edges_g2[2] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4663_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_g1[3] ),
    .Q(\pll_dig.out_edges_g2[3] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4664_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_g1[4] ),
    .Q(\pll_dig.out_edges_g2[4] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4665_ (.RESET_B(net212),
    .D(\pll_dig.out_edges_g1[5] ),
    .Q(\pll_dig.out_edges_g2[5] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4666_ (.RESET_B(net212),
    .D(\pll_dig.out_edges_g1[6] ),
    .Q(\pll_dig.out_edges_g2[6] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4667_ (.RESET_B(net213),
    .D(\pll_dig.out_edges_g1[7] ),
    .Q(\pll_dig.out_edges_g2[7] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4668_ (.RESET_B(net211),
    .D(\pll_dig.out_edges_g1[8] ),
    .Q(\pll_dig.out_edges_g2[8] ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4669_ (.RESET_B(net211),
    .D(\pll_dig.out_edges_g1[9] ),
    .Q(\pll_dig.out_edges_g2[9] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4670_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_gray[0] ),
    .Q(\pll_dig.out_edges_g1[0] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4671_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_gray[1] ),
    .Q(\pll_dig.out_edges_g1[1] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4672_ (.RESET_B(net231),
    .D(\pll_dig.out_edges_gray[2] ),
    .Q(\pll_dig.out_edges_g1[2] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4673_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_gray[3] ),
    .Q(\pll_dig.out_edges_g1[3] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4674_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_gray[4] ),
    .Q(\pll_dig.out_edges_g1[4] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4675_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_gray[5] ),
    .Q(\pll_dig.out_edges_g1[5] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4676_ (.RESET_B(net212),
    .D(\pll_dig.out_edges_gray[6] ),
    .Q(\pll_dig.out_edges_g1[6] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4677_ (.RESET_B(net213),
    .D(\pll_dig.out_edges_gray[7] ),
    .Q(\pll_dig.out_edges_g1[7] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4678_ (.RESET_B(net213),
    .D(\pll_dig.out_edges_gray[8] ),
    .Q(\pll_dig.out_edges_g1[8] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4679_ (.RESET_B(net213),
    .D(\pll_dig.out_edges[9] ),
    .Q(\pll_dig.out_edges_g1[9] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4680_ (.RESET_B(net236),
    .D(_0009_),
    .Q(\pll_dig.div.rst_n ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4681_ (.RESET_B(net211),
    .D(net271),
    .Q(\pll_dig.out_div2 ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4682_ (.RESET_B(net194),
    .D(\pll_dig.dsm_impl.locked_dsm_s1 ),
    .Q(\pll_dig.dsm_impl.locked_dsm_s2 ),
    .CLK(\clknet_1_1__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_dfrbpq_1 _4683_ (.RESET_B(net214),
    .D(\pll_dig.clr_r2 ),
    .Q(\pll_dig.clr_r3 ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4684_ (.RESET_B(net194),
    .D(net58),
    .Q(\pll_dig.dsm_impl.locked_dsm_s1 ),
    .CLK(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_dfrbpq_1 _4685_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[0] ),
    .Q(\MID_MUX[0] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4686_ (.RESET_B(net161),
    .D(\pll_dig.MID_MUX_D[1] ),
    .Q(\MID_MUX[1] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4687_ (.RESET_B(net161),
    .D(\pll_dig.MID_MUX_D[2] ),
    .Q(\MID_MUX[2] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4688_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[3] ),
    .Q(\MID_MUX[3] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4689_ (.RESET_B(net168),
    .D(\pll_dig.MID_MUX_D[4] ),
    .Q(\MID_MUX[4] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4690_ (.RESET_B(net173),
    .D(\pll_dig.MID_MUX_D[5] ),
    .Q(\MID_MUX[5] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4691_ (.RESET_B(net172),
    .D(\pll_dig.MID_MUX_D[6] ),
    .Q(\MID_MUX[6] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4692_ (.RESET_B(net172),
    .D(\pll_dig.MID_MUX_D[7] ),
    .Q(\MID_MUX[7] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4693_ (.RESET_B(net167),
    .D(\pll_dig.MID_MUX_D[8] ),
    .Q(\MID_MUX[8] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4694_ (.RESET_B(net167),
    .D(\pll_dig.MID_MUX_D[9] ),
    .Q(\MID_MUX[9] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4695_ (.RESET_B(net167),
    .D(\pll_dig.MID_MUX_D[10] ),
    .Q(\MID_MUX[10] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4696_ (.RESET_B(net165),
    .D(\pll_dig.MID_MUX_D[11] ),
    .Q(\MID_MUX[11] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4697_ (.RESET_B(net165),
    .D(\pll_dig.MID_MUX_D[12] ),
    .Q(\MID_MUX[12] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4698_ (.RESET_B(net165),
    .D(\pll_dig.MID_MUX_D[13] ),
    .Q(\MID_MUX[13] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4699_ (.RESET_B(net166),
    .D(\pll_dig.MID_MUX_D[14] ),
    .Q(\MID_MUX[14] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4700_ (.RESET_B(net185),
    .D(\pll_dig.FILTER_OUT[0] ),
    .Q(\pll_dig.dsm_impl.FCWF[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4701_ (.RESET_B(net185),
    .D(\pll_dig.FILTER_OUT[1] ),
    .Q(\pll_dig.dsm_impl.FCWF[1] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4702_ (.RESET_B(net186),
    .D(\pll_dig.FILTER_OUT[2] ),
    .Q(\pll_dig.dsm_impl.FCWF[2] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4703_ (.RESET_B(net186),
    .D(\pll_dig.FILTER_OUT[3] ),
    .Q(\pll_dig.dsm_impl.FCWF[3] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4704_ (.RESET_B(net186),
    .D(\pll_dig.FILTER_OUT[4] ),
    .Q(\pll_dig.dsm_impl.FCWF[4] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4705_ (.RESET_B(net189),
    .D(\pll_dig.FILTER_OUT[5] ),
    .Q(\pll_dig.dsm_impl.FCWF[5] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4706_ (.RESET_B(net189),
    .D(\pll_dig.FILTER_OUT[6] ),
    .Q(\pll_dig.dsm_impl.FCWF[6] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4707_ (.RESET_B(net190),
    .D(\pll_dig.FILTER_OUT[7] ),
    .Q(\pll_dig.dsm_impl.FCWF[7] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4708_ (.RESET_B(net190),
    .D(\pll_dig.FILTER_OUT[8] ),
    .Q(\pll_dig.dsm_impl.FCWF[8] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4709_ (.RESET_B(net197),
    .D(\pll_dig.FILTER_OUT[9] ),
    .Q(\pll_dig.dsm_impl.FCWF[9] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4710_ (.RESET_B(net197),
    .D(\pll_dig.FILTER_OUT[10] ),
    .Q(\pll_dig.dsm_impl.FCWF[10] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4711_ (.RESET_B(net197),
    .D(\pll_dig.FILTER_OUT[11] ),
    .Q(\pll_dig.dsm_impl.FCWF[11] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4712_ (.RESET_B(net208),
    .D(\pll_dig.clr_r1 ),
    .Q(\pll_dig.clr_r2 ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4713_ (.RESET_B(net193),
    .D(\pll_dig.FILTER_DEC_RAW[0] ),
    .Q(\pll_dig.FILTER_DEC[0] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4714_ (.RESET_B(net193),
    .D(\pll_dig.FILTER_DEC_RAW[1] ),
    .Q(\pll_dig.FILTER_DEC[1] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4715_ (.RESET_B(net194),
    .D(\pll_dig.FILTER_DEC_RAW[2] ),
    .Q(\pll_dig.FILTER_DEC[2] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4716_ (.RESET_B(net174),
    .D(\pll_dig.FILTER_DEC_RAW[3] ),
    .Q(\pll_dig.FILTER_DEC[3] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4717_ (.RESET_B(net175),
    .D(\pll_dig.FILTER_DEC_RAW[4] ),
    .Q(\pll_dig.FILTER_DEC[4] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4718_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[0] ),
    .Q(\FINE_MUX[0] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4719_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[1] ),
    .Q(\FINE_MUX[1] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4720_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[2] ),
    .Q(\FINE_MUX[2] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4721_ (.RESET_B(net175),
    .D(\pll_dig.FINE_MUX_D[3] ),
    .Q(\FINE_MUX[3] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4722_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[4] ),
    .Q(\FINE_MUX[4] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4723_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[5] ),
    .Q(\FINE_MUX[5] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4724_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[6] ),
    .Q(\FINE_MUX[6] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4725_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[7] ),
    .Q(\FINE_MUX[7] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4726_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[8] ),
    .Q(\FINE_MUX[8] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4727_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[9] ),
    .Q(\FINE_MUX[9] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4728_ (.RESET_B(net181),
    .D(\pll_dig.FINE_MUX_D[10] ),
    .Q(\FINE_MUX[10] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4729_ (.RESET_B(net175),
    .D(\pll_dig.FINE_MUX_D[11] ),
    .Q(\FINE_MUX[11] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4730_ (.RESET_B(net181),
    .D(\pll_dig.FINE_MUX_D[12] ),
    .Q(\FINE_MUX[12] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4731_ (.RESET_B(net164),
    .D(\pll_dig.FINE_MUX_D[13] ),
    .Q(\FINE_MUX[13] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4732_ (.RESET_B(net164),
    .D(\pll_dig.FINE_MUX_D[14] ),
    .Q(\FINE_MUX[14] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4733_ (.RESET_B(net164),
    .D(\pll_dig.FILTER_DEC[4] ),
    .Q(\FINE_MUX[15] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4734_ (.RESET_B(net181),
    .D(\pll_dig.FINE_MUX_D[16] ),
    .Q(\FINE_MUX[16] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4735_ (.RESET_B(net164),
    .D(\pll_dig.FINE_MUX_D[17] ),
    .Q(\FINE_MUX[17] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4736_ (.RESET_B(net181),
    .D(\pll_dig.FINE_MUX_D[18] ),
    .Q(\FINE_MUX[18] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4737_ (.RESET_B(net175),
    .D(\pll_dig.FINE_MUX_D[19] ),
    .Q(\FINE_MUX[19] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4738_ (.RESET_B(net175),
    .D(\pll_dig.FINE_MUX_D[20] ),
    .Q(\FINE_MUX[20] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4739_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[21] ),
    .Q(\FINE_MUX[21] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4740_ (.RESET_B(net175),
    .D(\pll_dig.FINE_MUX_D[22] ),
    .Q(\FINE_MUX[22] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4741_ (.RESET_B(net174),
    .D(\pll_dig.FINE_MUX_D[23] ),
    .Q(\FINE_MUX[23] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4742_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[24] ),
    .Q(\FINE_MUX[24] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4743_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[25] ),
    .Q(\FINE_MUX[25] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4744_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[26] ),
    .Q(\FINE_MUX[26] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4745_ (.RESET_B(net174),
    .D(\pll_dig.FINE_MUX_D[27] ),
    .Q(\FINE_MUX[27] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4746_ (.RESET_B(net193),
    .D(\pll_dig.FINE_MUX_D[28] ),
    .Q(\FINE_MUX[28] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4747_ (.RESET_B(net163),
    .D(\pll_dig.FINE_MUX_D[29] ),
    .Q(\FINE_MUX[29] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4748_ (.RESET_B(net164),
    .D(\pll_dig.FINE_MUX_D[30] ),
    .Q(\FINE_MUX[30] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4749_ (.RESET_B(net208),
    .D(\pll_dig.clr_toggle ),
    .Q(\pll_dig.clr_r1 ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_buf_16 clkbuf_0_INJ_EDGE (.X(clknet_0_INJ_EDGE),
    .A(INJ_EDGE));
 sg13g2_buf_16 clkbuf_0_MID_OUT (.X(clknet_0_MID_OUT),
    .A(MID_OUT));
 sg13g2_buf_16 clkbuf_0_REF (.X(clknet_0_REF),
    .A(delaynet_3_REF));
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
 sg13g2_buf_8 \clkbuf_3_0_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_0_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_3_0__f_MID_OUT (.X(clknet_3_0__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_0__f_pll_dig.CKR  (.X(\clknet_3_0__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 \clkbuf_3_1_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_1_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_3_1__f_MID_OUT (.X(clknet_3_1__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_1__f_pll_dig.CKR  (.X(\clknet_3_1__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 \clkbuf_3_2_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_2_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_3_2__f_MID_OUT (.X(clknet_3_2__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_2__f_pll_dig.CKR  (.X(\clknet_3_2__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 \clkbuf_3_3_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_3_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_3_3__f_MID_OUT (.X(clknet_3_3__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_3__f_pll_dig.CKR  (.X(\clknet_3_3__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 \clkbuf_3_4_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_4_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_3_4__f_MID_OUT (.X(clknet_3_4__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_4__f_pll_dig.CKR  (.X(\clknet_3_4__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 \clkbuf_3_5_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_5_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_3_5__f_MID_OUT (.X(clknet_3_5__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_5__f_pll_dig.CKR  (.X(\clknet_3_5__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 \clkbuf_3_6_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_6_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_3_6__f_MID_OUT (.X(clknet_3_6__leaf_MID_OUT),
    .A(clknet_0_MID_OUT));
 sg13g2_buf_16 \clkbuf_3_6__f_pll_dig.CKR  (.X(\clknet_3_6__leaf_pll_dig.CKR ),
    .A(\clknet_0_pll_dig.CKR ));
 sg13g2_buf_8 \clkbuf_3_7_0_pll_dig.flock.REF_G  (.A(\clknet_0_pll_dig.flock.REF_G ),
    .X(\clknet_3_7_0_pll_dig.flock.REF_G ));
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
 sg13g2_buf_16 \clkbuf_4_0__f_pll_dig.flock.REF_G  (.X(\clknet_4_0__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_0_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_10_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_10_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_10_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_10_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_10_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_10_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_10_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_10__f_pll_dig.flock.REF_G  (.X(\clknet_4_10__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_5_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_11_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_11_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_11_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_11_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_11_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_11_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_11_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_11__f_pll_dig.flock.REF_G  (.X(\clknet_4_11__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_5_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_12_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_12_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_12_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_12_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_12_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_12_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_12_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_12__f_pll_dig.flock.REF_G  (.X(\clknet_4_12__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_6_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_13_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_13_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_13_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_13_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_13_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_13_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_13_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_13__f_pll_dig.flock.REF_G  (.X(\clknet_4_13__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_6_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_14_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_14_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_14_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_14_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_14_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_14_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_14_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_14__f_pll_dig.flock.REF_G  (.X(\clknet_4_14__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_7_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_15_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_15_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_15_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_15_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_15_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_15_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_15_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_15__f_pll_dig.flock.REF_G  (.X(\clknet_4_15__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_7_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_1_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_1_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_1_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_1_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_1_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_1_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_1_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_1__f_pll_dig.flock.REF_G  (.X(\clknet_4_1__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_0_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_2_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_2_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_2_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_2_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_2_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_2_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_2_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_2__f_pll_dig.flock.REF_G  (.X(\clknet_4_2__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_1_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_3_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_3_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_3_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_3_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_3_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_3_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_3_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_3__f_pll_dig.flock.REF_G  (.X(\clknet_4_3__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_1_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_4_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_4_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_4_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_4_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_4_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_4_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_4_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_4__f_pll_dig.flock.REF_G  (.X(\clknet_4_4__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_2_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_5_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_5_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_5_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_5_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_5_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_5_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_5_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_5__f_pll_dig.flock.REF_G  (.X(\clknet_4_5__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_2_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_6_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_6_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_6_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_6_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_6_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_6_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_6_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_6__f_pll_dig.flock.REF_G  (.X(\clknet_4_6__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_3_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_7_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_7_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_7_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_7_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_7_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_7_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_7_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_7__f_pll_dig.flock.REF_G  (.X(\clknet_4_7__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_3_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_8_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_8_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_8_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_8_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_8_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_8_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_8_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_8__f_pll_dig.flock.REF_G  (.X(\clknet_4_8__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_4_0_pll_dig.flock.REF_G ));
 sg13g2_buf_8 clkbuf_4_9_0_INJ_EDGE (.A(clknet_0_INJ_EDGE),
    .X(clknet_4_9_0_INJ_EDGE));
 sg13g2_buf_8 clkbuf_4_9_0_REF_regs (.A(clknet_0_REF_regs),
    .X(clknet_4_9_0_REF_regs));
 sg13g2_buf_8 clkbuf_4_9_0_net59_regs (.A(clknet_0_net59_regs),
    .X(clknet_4_9_0_net59_regs));
 sg13g2_buf_8 \clkbuf_4_9_0_pll_dig.dsm_impl.DSM_CK_G  (.A(\clknet_0_pll_dig.dsm_impl.DSM_CK_G ),
    .X(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_buf_16 \clkbuf_4_9__f_pll_dig.flock.REF_G  (.X(\clknet_4_9__leaf_pll_dig.flock.REF_G ),
    .A(\clknet_3_4_0_pll_dig.flock.REF_G ));
 sg13g2_buf_16 clkbuf_5_0__f_REF_regs (.X(clknet_5_0__leaf_REF_regs),
    .A(clknet_4_0_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_10__f_REF_regs (.X(clknet_5_10__leaf_REF_regs),
    .A(clknet_4_5_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_11__f_REF_regs (.X(clknet_5_11__leaf_REF_regs),
    .A(clknet_4_5_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_12__f_REF_regs (.X(clknet_5_12__leaf_REF_regs),
    .A(clknet_4_6_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_13__f_REF_regs (.X(clknet_5_13__leaf_REF_regs),
    .A(clknet_4_6_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_14__f_REF_regs (.X(clknet_5_14__leaf_REF_regs),
    .A(clknet_4_7_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_15__f_REF_regs (.X(clknet_5_15__leaf_REF_regs),
    .A(clknet_4_7_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_16__f_REF_regs (.X(clknet_5_16__leaf_REF_regs),
    .A(clknet_4_8_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_17__f_REF_regs (.X(clknet_5_17__leaf_REF_regs),
    .A(clknet_4_8_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_18__f_REF_regs (.X(clknet_5_18__leaf_REF_regs),
    .A(clknet_4_9_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_19__f_REF_regs (.X(clknet_5_19__leaf_REF_regs),
    .A(clknet_4_9_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_1__f_REF_regs (.X(clknet_5_1__leaf_REF_regs),
    .A(clknet_4_0_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_20__f_REF_regs (.X(clknet_5_20__leaf_REF_regs),
    .A(clknet_4_10_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_21__f_REF_regs (.X(clknet_5_21__leaf_REF_regs),
    .A(clknet_4_10_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_22__f_REF_regs (.X(clknet_5_22__leaf_REF_regs),
    .A(clknet_4_11_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_23__f_REF_regs (.X(clknet_5_23__leaf_REF_regs),
    .A(clknet_4_11_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_24__f_REF_regs (.X(clknet_5_24__leaf_REF_regs),
    .A(clknet_4_12_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_25__f_REF_regs (.X(clknet_5_25__leaf_REF_regs),
    .A(clknet_4_12_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_26__f_REF_regs (.X(clknet_5_26__leaf_REF_regs),
    .A(clknet_4_13_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_27__f_REF_regs (.X(clknet_5_27__leaf_REF_regs),
    .A(clknet_4_13_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_28__f_REF_regs (.X(clknet_5_28__leaf_REF_regs),
    .A(clknet_4_14_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_29__f_REF_regs (.X(clknet_5_29__leaf_REF_regs),
    .A(clknet_4_14_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_2__f_REF_regs (.X(clknet_5_2__leaf_REF_regs),
    .A(clknet_4_1_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_30__f_REF_regs (.X(clknet_5_30__leaf_REF_regs),
    .A(clknet_4_15_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_31__f_REF_regs (.X(clknet_5_31__leaf_REF_regs),
    .A(clknet_4_15_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_3__f_REF_regs (.X(clknet_5_3__leaf_REF_regs),
    .A(clknet_4_1_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_4__f_REF_regs (.X(clknet_5_4__leaf_REF_regs),
    .A(clknet_4_2_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_5__f_REF_regs (.X(clknet_5_5__leaf_REF_regs),
    .A(clknet_4_2_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_6__f_REF_regs (.X(clknet_5_6__leaf_REF_regs),
    .A(clknet_4_3_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_7__f_REF_regs (.X(clknet_5_7__leaf_REF_regs),
    .A(clknet_4_3_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_8__f_REF_regs (.X(clknet_5_8__leaf_REF_regs),
    .A(clknet_4_4_0_REF_regs));
 sg13g2_buf_16 clkbuf_5_9__f_REF_regs (.X(clknet_5_9__leaf_REF_regs),
    .A(clknet_4_4_0_REF_regs));
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
 sg13g2_buf_1 fanout100 (.A(_0767_),
    .X(net100));
 sg13g2_buf_1 fanout101 (.A(net102),
    .X(net101));
 sg13g2_buf_1 fanout102 (.A(_1845_),
    .X(net102));
 sg13g2_buf_1 fanout103 (.A(\pll_dig.FILTER_DEC[2] ),
    .X(net103));
 sg13g2_buf_1 fanout104 (.A(_1080_),
    .X(net104));
 sg13g2_buf_1 fanout105 (.A(net106),
    .X(net105));
 sg13g2_buf_1 fanout106 (.A(net107),
    .X(net106));
 sg13g2_buf_1 fanout107 (.A(_1652_),
    .X(net107));
 sg13g2_buf_1 fanout108 (.A(_0982_),
    .X(net108));
 sg13g2_buf_1 fanout109 (.A(_0982_),
    .X(net109));
 sg13g2_buf_1 fanout110 (.A(_0129_),
    .X(net110));
 sg13g2_buf_1 fanout111 (.A(\pll_dig.dlf.INT[9] ),
    .X(net111));
 sg13g2_buf_1 fanout112 (.A(net113),
    .X(net112));
 sg13g2_buf_1 fanout113 (.A(net116),
    .X(net113));
 sg13g2_buf_1 fanout114 (.A(net115),
    .X(net114));
 sg13g2_buf_1 fanout115 (.A(net116),
    .X(net115));
 sg13g2_buf_1 fanout116 (.A(net124),
    .X(net116));
 sg13g2_buf_1 fanout117 (.A(net118),
    .X(net117));
 sg13g2_buf_1 fanout118 (.A(net124),
    .X(net118));
 sg13g2_buf_1 fanout119 (.A(net120),
    .X(net119));
 sg13g2_buf_1 fanout120 (.A(net123),
    .X(net120));
 sg13g2_buf_1 fanout121 (.A(net122),
    .X(net121));
 sg13g2_buf_1 fanout122 (.A(net123),
    .X(net122));
 sg13g2_buf_1 fanout123 (.A(net124),
    .X(net123));
 sg13g2_buf_1 fanout124 (.A(DCO_EN),
    .X(net124));
 sg13g2_buf_1 fanout125 (.A(_0830_),
    .X(net125));
 sg13g2_buf_1 fanout126 (.A(_0830_),
    .X(net126));
 sg13g2_buf_1 fanout127 (.A(net131),
    .X(net127));
 sg13g2_buf_1 fanout128 (.A(net130),
    .X(net128));
 sg13g2_buf_1 fanout129 (.A(net130),
    .X(net129));
 sg13g2_buf_1 fanout130 (.A(net131),
    .X(net130));
 sg13g2_buf_1 fanout131 (.A(_0829_),
    .X(net131));
 sg13g2_buf_1 fanout132 (.A(_0517_),
    .X(net132));
 sg13g2_buf_1 fanout133 (.A(_0517_),
    .X(net133));
 sg13g2_buf_4 fanout134 (.X(net134),
    .A(net137));
 sg13g2_buf_1 fanout135 (.A(net137),
    .X(net135));
 sg13g2_buf_1 fanout136 (.A(net137),
    .X(net136));
 sg13g2_buf_2 fanout137 (.A(\pll_dig.div.rst_n ),
    .X(net137));
 sg13g2_buf_1 fanout138 (.A(net140),
    .X(net138));
 sg13g2_buf_1 fanout139 (.A(net140),
    .X(net139));
 sg13g2_buf_1 fanout140 (.A(\pll_dig.div.rst_n ),
    .X(net140));
 sg13g2_buf_2 fanout141 (.A(\pll_dig.div.rst_n ),
    .X(net141));
 sg13g2_buf_1 fanout142 (.A(\pll_dig.div.rst_n ),
    .X(net142));
 sg13g2_buf_4 fanout143 (.X(net143),
    .A(net144));
 sg13g2_buf_8 fanout144 (.A(\pll_dig.div.rst_n ),
    .X(net144));
 sg13g2_buf_1 fanout146 (.A(\pll_dig.flock.cnt_filt[3] ),
    .X(net146));
 sg13g2_buf_1 fanout147 (.A(\pll_dig.flock.cnt_filt[1] ),
    .X(net147));
 sg13g2_buf_1 fanout148 (.A(\pll_dig.div.high_phase ),
    .X(net148));
 sg13g2_buf_2 fanout149 (.A(\pll_dig.div.div[7] ),
    .X(net149));
 sg13g2_buf_2 fanout150 (.A(\pll_dig.div.div[6] ),
    .X(net150));
 sg13g2_buf_1 fanout151 (.A(\pll_dig.div.div[5] ),
    .X(net151));
 sg13g2_buf_1 fanout152 (.A(\pll_dig.div.div[4] ),
    .X(net152));
 sg13g2_buf_1 fanout153 (.A(\pll_dig.div.div[4] ),
    .X(net153));
 sg13g2_buf_2 fanout154 (.A(\pll_dig.div.div[3] ),
    .X(net154));
 sg13g2_buf_1 fanout155 (.A(\pll_dig.div.div[2] ),
    .X(net155));
 sg13g2_buf_1 fanout156 (.A(\pll_dig.div.div[2] ),
    .X(net156));
 sg13g2_buf_16 fanout157 (.X(net157),
    .A(\pll_dig.div.div[0] ));
 sg13g2_buf_1 fanout158 (.A(\pll_dig.flock.cap_valid ),
    .X(net158));
 sg13g2_buf_1 fanout159 (.A(\pll_dig.flock.cap_valid ),
    .X(net159));
 sg13g2_buf_1 fanout160 (.A(net162),
    .X(net160));
 sg13g2_buf_1 fanout161 (.A(net162),
    .X(net161));
 sg13g2_buf_1 fanout162 (.A(net180),
    .X(net162));
 sg13g2_buf_1 fanout163 (.A(net164),
    .X(net163));
 sg13g2_buf_1 fanout164 (.A(net180),
    .X(net164));
 sg13g2_buf_1 fanout165 (.A(net168),
    .X(net165));
 sg13g2_buf_1 fanout166 (.A(net168),
    .X(net166));
 sg13g2_buf_1 fanout167 (.A(net168),
    .X(net167));
 sg13g2_buf_1 fanout168 (.A(net180),
    .X(net168));
 sg13g2_buf_1 fanout169 (.A(net171),
    .X(net169));
 sg13g2_buf_1 fanout170 (.A(net171),
    .X(net170));
 sg13g2_buf_1 fanout171 (.A(net180),
    .X(net171));
 sg13g2_buf_1 fanout172 (.A(net179),
    .X(net172));
 sg13g2_buf_1 fanout173 (.A(net179),
    .X(net173));
 sg13g2_buf_1 fanout174 (.A(net175),
    .X(net174));
 sg13g2_buf_1 fanout175 (.A(net179),
    .X(net175));
 sg13g2_buf_1 fanout176 (.A(net178),
    .X(net176));
 sg13g2_buf_1 fanout177 (.A(net178),
    .X(net177));
 sg13g2_buf_1 fanout178 (.A(net179),
    .X(net178));
 sg13g2_buf_1 fanout179 (.A(net180),
    .X(net179));
 sg13g2_buf_1 fanout180 (.A(net200),
    .X(net180));
 sg13g2_buf_1 fanout181 (.A(net184),
    .X(net181));
 sg13g2_buf_1 fanout182 (.A(net184),
    .X(net182));
 sg13g2_buf_1 fanout183 (.A(net184),
    .X(net183));
 sg13g2_buf_1 fanout184 (.A(net192),
    .X(net184));
 sg13g2_buf_1 fanout185 (.A(net188),
    .X(net185));
 sg13g2_buf_1 fanout186 (.A(net188),
    .X(net186));
 sg13g2_buf_1 fanout187 (.A(net188),
    .X(net187));
 sg13g2_buf_1 fanout188 (.A(net192),
    .X(net188));
 sg13g2_buf_1 fanout189 (.A(net191),
    .X(net189));
 sg13g2_buf_1 fanout190 (.A(net191),
    .X(net190));
 sg13g2_buf_1 fanout191 (.A(net192),
    .X(net191));
 sg13g2_buf_1 fanout192 (.A(net200),
    .X(net192));
 sg13g2_buf_1 fanout193 (.A(net195),
    .X(net193));
 sg13g2_buf_1 fanout194 (.A(net195),
    .X(net194));
 sg13g2_buf_1 fanout195 (.A(net196),
    .X(net195));
 sg13g2_buf_1 fanout196 (.A(net200),
    .X(net196));
 sg13g2_buf_1 fanout197 (.A(net198),
    .X(net197));
 sg13g2_buf_1 fanout198 (.A(net199),
    .X(net198));
 sg13g2_buf_1 fanout199 (.A(net200),
    .X(net199));
 sg13g2_buf_1 fanout200 (.A(net47),
    .X(net200));
 sg13g2_buf_1 fanout201 (.A(net203),
    .X(net201));
 sg13g2_buf_1 fanout202 (.A(net203),
    .X(net202));
 sg13g2_buf_1 fanout203 (.A(net215),
    .X(net203));
 sg13g2_buf_1 fanout204 (.A(net215),
    .X(net204));
 sg13g2_buf_1 fanout205 (.A(net206),
    .X(net205));
 sg13g2_buf_1 fanout206 (.A(net214),
    .X(net206));
 sg13g2_buf_1 fanout207 (.A(net208),
    .X(net207));
 sg13g2_buf_1 fanout208 (.A(net214),
    .X(net208));
 sg13g2_buf_1 fanout209 (.A(net210),
    .X(net209));
 sg13g2_buf_1 fanout210 (.A(net214),
    .X(net210));
 sg13g2_buf_1 fanout211 (.A(net213),
    .X(net211));
 sg13g2_buf_1 fanout212 (.A(net213),
    .X(net212));
 sg13g2_buf_1 fanout213 (.A(net214),
    .X(net213));
 sg13g2_buf_1 fanout214 (.A(net215),
    .X(net214));
 sg13g2_buf_1 fanout215 (.A(net232),
    .X(net215));
 sg13g2_buf_1 fanout216 (.A(net218),
    .X(net216));
 sg13g2_buf_1 fanout217 (.A(net218),
    .X(net217));
 sg13g2_buf_1 fanout218 (.A(net232),
    .X(net218));
 sg13g2_buf_1 fanout219 (.A(net221),
    .X(net219));
 sg13g2_buf_1 fanout220 (.A(net221),
    .X(net220));
 sg13g2_buf_1 fanout221 (.A(net222),
    .X(net221));
 sg13g2_buf_1 fanout222 (.A(net232),
    .X(net222));
 sg13g2_buf_1 fanout223 (.A(net231),
    .X(net223));
 sg13g2_buf_1 fanout224 (.A(net231),
    .X(net224));
 sg13g2_buf_1 fanout225 (.A(net227),
    .X(net225));
 sg13g2_buf_1 fanout226 (.A(net227),
    .X(net226));
 sg13g2_buf_1 fanout227 (.A(net231),
    .X(net227));
 sg13g2_buf_1 fanout228 (.A(net229),
    .X(net228));
 sg13g2_buf_1 fanout229 (.A(net230),
    .X(net229));
 sg13g2_buf_1 fanout230 (.A(net231),
    .X(net230));
 sg13g2_buf_1 fanout231 (.A(net232),
    .X(net231));
 sg13g2_buf_1 fanout232 (.A(net47),
    .X(net232));
 sg13g2_buf_1 fanout233 (.A(net235),
    .X(net233));
 sg13g2_buf_1 fanout234 (.A(net235),
    .X(net234));
 sg13g2_buf_1 fanout235 (.A(net236),
    .X(net235));
 sg13g2_buf_1 fanout236 (.A(net47),
    .X(net236));
 sg13g2_buf_1 fanout237 (.A(net46),
    .X(net237));
 sg13g2_buf_1 fanout238 (.A(net46),
    .X(net238));
 sg13g2_buf_1 fanout61 (.A(_1043_),
    .X(net61));
 sg13g2_buf_1 fanout62 (.A(_1043_),
    .X(net62));
 sg13g2_buf_1 fanout63 (.A(_1903_),
    .X(net63));
 sg13g2_buf_1 fanout64 (.A(_1073_),
    .X(net64));
 sg13g2_buf_1 fanout65 (.A(_1073_),
    .X(net65));
 sg13g2_buf_1 fanout66 (.A(_1937_),
    .X(net66));
 sg13g2_buf_1 fanout67 (.A(_1937_),
    .X(net67));
 sg13g2_buf_1 fanout68 (.A(_1299_),
    .X(net68));
 sg13g2_buf_1 fanout69 (.A(_1299_),
    .X(net69));
 sg13g2_buf_8 fanout70 (.A(_0954_),
    .X(net70));
 sg13g2_buf_1 fanout71 (.A(net75),
    .X(net71));
 sg13g2_buf_1 fanout72 (.A(net75),
    .X(net72));
 sg13g2_buf_1 fanout73 (.A(net75),
    .X(net73));
 sg13g2_buf_1 fanout74 (.A(net75),
    .X(net74));
 sg13g2_buf_1 fanout75 (.A(_0853_),
    .X(net75));
 sg13g2_buf_1 fanout76 (.A(net79),
    .X(net76));
 sg13g2_buf_1 fanout77 (.A(net78),
    .X(net77));
 sg13g2_buf_1 fanout78 (.A(net79),
    .X(net78));
 sg13g2_buf_1 fanout79 (.A(_0821_),
    .X(net79));
 sg13g2_buf_1 fanout80 (.A(net81),
    .X(net80));
 sg13g2_buf_1 fanout81 (.A(_0826_),
    .X(net81));
 sg13g2_buf_16 fanout82 (.X(net82),
    .A(net83));
 sg13g2_buf_16 fanout83 (.X(net83),
    .A(net336));
 sg13g2_buf_16 fanout84 (.X(net84),
    .A(net85));
 sg13g2_buf_8 fanout85 (.A(_0930_),
    .X(net85));
 sg13g2_buf_1 fanout86 (.A(_0855_),
    .X(net86));
 sg13g2_buf_1 fanout87 (.A(_0855_),
    .X(net87));
 sg13g2_buf_1 fanout88 (.A(_0847_),
    .X(net88));
 sg13g2_buf_1 fanout89 (.A(_0847_),
    .X(net89));
 sg13g2_buf_1 fanout90 (.A(net91),
    .X(net90));
 sg13g2_buf_1 fanout91 (.A(_0841_),
    .X(net91));
 sg13g2_buf_1 fanout92 (.A(net93),
    .X(net92));
 sg13g2_buf_1 fanout93 (.A(_0822_),
    .X(net93));
 sg13g2_buf_1 fanout94 (.A(_0797_),
    .X(net94));
 sg13g2_buf_1 fanout95 (.A(net529),
    .X(net95));
 sg13g2_buf_1 fanout96 (.A(_1234_),
    .X(net96));
 sg13g2_buf_1 fanout97 (.A(_1234_),
    .X(net97));
 sg13g2_buf_1 fanout98 (.A(_0440_),
    .X(net98));
 sg13g2_buf_1 fanout99 (.A(net100),
    .X(net99));
 sg13g2_dlygate4sd3_1 hold459 (.A(\pll_dig.flock.cnt_cap[1] ),
    .X(net458));
 sg13g2_dlygate4sd3_1 hold460 (.A(_1247_),
    .X(net459));
 sg13g2_dlygate4sd3_1 hold461 (.A(_0145_),
    .X(net460));
 sg13g2_dlygate4sd3_1 hold462 (.A(net545),
    .X(net461));
 sg13g2_dlygate4sd3_1 hold463 (.A(_1615_),
    .X(net462));
 sg13g2_dlygate4sd3_1 hold464 (.A(_0137_),
    .X(net463));
 sg13g2_dlygate4sd3_1 hold465 (.A(net546),
    .X(net464));
 sg13g2_dlygate4sd3_1 hold466 (.A(_1547_),
    .X(net465));
 sg13g2_dlygate4sd3_1 hold467 (.A(_1606_),
    .X(net466));
 sg13g2_dlygate4sd3_1 hold468 (.A(_0139_),
    .X(net467));
 sg13g2_dlygate4sd3_1 hold469 (.A(net544),
    .X(net468));
 sg13g2_dlygate4sd3_1 hold470 (.A(_1564_),
    .X(net469));
 sg13g2_dlygate4sd3_1 hold471 (.A(_1597_),
    .X(net470));
 sg13g2_dlygate4sd3_1 hold472 (.A(_0151_),
    .X(net471));
 sg13g2_dlygate4sd3_1 hold473 (.A(net549),
    .X(net472));
 sg13g2_dlygate4sd3_1 hold474 (.A(_1554_),
    .X(net473));
 sg13g2_dlygate4sd3_1 hold475 (.A(_1603_),
    .X(net474));
 sg13g2_dlygate4sd3_1 hold476 (.A(_0138_),
    .X(net475));
 sg13g2_dlygate4sd3_1 hold477 (.A(net551),
    .X(net476));
 sg13g2_dlygate4sd3_1 hold478 (.A(_1559_),
    .X(net477));
 sg13g2_dlygate4sd3_1 hold479 (.A(_1600_),
    .X(net478));
 sg13g2_dlygate4sd3_1 hold480 (.A(_0152_),
    .X(net479));
 sg13g2_dlygate4sd3_1 hold481 (.A(net541),
    .X(net480));
 sg13g2_dlygate4sd3_1 hold482 (.A(_1611_),
    .X(net481));
 sg13g2_dlygate4sd3_1 hold483 (.A(_1633_),
    .X(net482));
 sg13g2_dlygate4sd3_1 hold484 (.A(_1656_),
    .X(net483));
 sg13g2_dlygate4sd3_1 hold485 (.A(_0141_),
    .X(net484));
 sg13g2_dlygate4sd3_1 hold486 (.A(net542),
    .X(net485));
 sg13g2_dlygate4sd3_1 hold487 (.A(_1608_),
    .X(net486));
 sg13g2_dlygate4sd3_1 hold488 (.A(_1613_),
    .X(net487));
 sg13g2_dlygate4sd3_1 hold489 (.A(_0140_),
    .X(net488));
 sg13g2_dlygate4sd3_1 hold490 (.A(net503),
    .X(net489));
 sg13g2_dlygate4sd3_1 hold491 (.A(_1621_),
    .X(net490));
 sg13g2_dlygate4sd3_1 hold492 (.A(_1623_),
    .X(net491));
 sg13g2_dlygate4sd3_1 hold493 (.A(_1639_),
    .X(net492));
 sg13g2_dlygate4sd3_1 hold494 (.A(_1640_),
    .X(net493));
 sg13g2_dlygate4sd3_1 hold495 (.A(_0144_),
    .X(net494));
 sg13g2_dlygate4sd3_1 hold496 (.A(net550),
    .X(net495));
 sg13g2_dlygate4sd3_1 hold497 (.A(_1569_),
    .X(net496));
 sg13g2_dlygate4sd3_1 hold498 (.A(_1594_),
    .X(net497));
 sg13g2_dlygate4sd3_1 hold499 (.A(_0150_),
    .X(net498));
 sg13g2_dlygate4sd3_1 hold500 (.A(net557),
    .X(net499));
 sg13g2_dlygate4sd3_1 hold501 (.A(_1627_),
    .X(net500));
 sg13g2_dlygate4sd3_1 hold502 (.A(_1630_),
    .X(net501));
 sg13g2_dlygate4sd3_1 hold503 (.A(_0142_),
    .X(net502));
 sg13g2_dlygate4sd3_1 hold504 (.A(\pll_dig.flock.cnt_cap[14] ),
    .X(net503));
 sg13g2_dlygate4sd3_1 hold505 (.A(net489),
    .X(net504));
 sg13g2_dlygate4sd3_1 hold506 (.A(_1629_),
    .X(net505));
 sg13g2_dlygate4sd3_1 hold507 (.A(_1638_),
    .X(net506));
 sg13g2_dlygate4sd3_1 hold508 (.A(_0143_),
    .X(net507));
 sg13g2_dlygate4sd3_1 hold509 (.A(net548),
    .X(net508));
 sg13g2_dlygate4sd3_1 hold510 (.A(_1244_),
    .X(net509));
 sg13g2_dlygate4sd3_1 hold511 (.A(_1255_),
    .X(net510));
 sg13g2_dlygate4sd3_1 hold512 (.A(_1588_),
    .X(net511));
 sg13g2_dlygate4sd3_1 hold513 (.A(_0147_),
    .X(net512));
 sg13g2_dlygate4sd3_1 hold514 (.A(net552),
    .X(net513));
 sg13g2_dlygate4sd3_1 hold515 (.A(_1254_),
    .X(net514));
 sg13g2_dlygate4sd3_1 hold516 (.A(_1256_),
    .X(net515));
 sg13g2_dlygate4sd3_1 hold517 (.A(_0146_),
    .X(net516));
 sg13g2_dlygate4sd3_1 hold518 (.A(net555),
    .X(net517));
 sg13g2_dlygate4sd3_1 hold519 (.A(_1579_),
    .X(net518));
 sg13g2_dlygate4sd3_1 hold520 (.A(_1581_),
    .X(net519));
 sg13g2_dlygate4sd3_1 hold521 (.A(_1669_),
    .X(net520));
 sg13g2_dlygate4sd3_1 hold522 (.A(_0148_),
    .X(net521));
 sg13g2_dlygate4sd3_1 hold523 (.A(net556),
    .X(net522));
 sg13g2_dlygate4sd3_1 hold524 (.A(_1573_),
    .X(net523));
 sg13g2_dlygate4sd3_1 hold525 (.A(_1576_),
    .X(net524));
 sg13g2_dlygate4sd3_1 hold526 (.A(_0149_),
    .X(net525));
 sg13g2_dlygate4sd3_1 hold527 (.A(\pll_dig.flock.FCW_NA[10] ),
    .X(net526));
 sg13g2_dlygate4sd3_1 hold528 (.A(_1105_),
    .X(net527));
 sg13g2_dlygate4sd3_1 hold529 (.A(_1107_),
    .X(net528));
 sg13g2_dlygate4sd3_1 hold530 (.A(net534),
    .X(net529));
 sg13g2_dlygate4sd3_1 hold531 (.A(_1316_),
    .X(net530));
 sg13g2_dlygate4sd3_1 hold532 (.A(_0022_),
    .X(net531));
 sg13g2_dlygate4sd3_1 hold533 (.A(\pll_dig.flock.FCW_PA[7] ),
    .X(net532));
 sg13g2_dlygate4sd3_1 hold534 (.A(_1092_),
    .X(net533));
 sg13g2_dlygate4sd3_1 hold535 (.A(_1108_),
    .X(net534));
 sg13g2_dlygate4sd3_1 hold536 (.A(net538),
    .X(net535));
 sg13g2_dlygate4sd3_1 hold537 (.A(_0795_),
    .X(net536));
 sg13g2_dlygate4sd3_1 hold538 (.A(_1295_),
    .X(net537));
 sg13g2_dlygate4sd3_1 hold539 (.A(\pll_dig.FREQ_OK ),
    .X(net538));
 sg13g2_dlygate4sd3_1 hold540 (.A(\pll_dig.fail_q ),
    .X(net539));
 sg13g2_dlygate4sd3_1 hold541 (.A(\pll_dig.dco_miss_cnt[2] ),
    .X(net540));
 sg13g2_dlygate4sd3_1 hold542 (.A(\pll_dig.flock.cnt_cap[12] ),
    .X(net541));
 sg13g2_dlygate4sd3_1 hold543 (.A(\pll_dig.flock.cnt_cap[11] ),
    .X(net542));
 sg13g2_dlygate4sd3_1 hold544 (.A(_1607_),
    .X(net543));
 sg13g2_dlygate4sd3_1 hold545 (.A(\pll_dig.flock.cnt_cap[7] ),
    .X(net544));
 sg13g2_dlygate4sd3_1 hold546 (.A(\pll_dig.flock.cnt_cap[15] ),
    .X(net545));
 sg13g2_dlygate4sd3_1 hold547 (.A(\pll_dig.flock.cnt_cap[10] ),
    .X(net546));
 sg13g2_dlygate4sd3_1 hold548 (.A(_1604_),
    .X(net547));
 sg13g2_dlygate4sd3_1 hold549 (.A(\pll_dig.flock.cnt_cap[2] ),
    .X(net548));
 sg13g2_dlygate4sd3_1 hold550 (.A(\pll_dig.flock.cnt_cap[9] ),
    .X(net549));
 sg13g2_dlygate4sd3_1 hold551 (.A(\pll_dig.flock.cnt_cap[6] ),
    .X(net550));
 sg13g2_dlygate4sd3_1 hold552 (.A(\pll_dig.flock.cnt_cap[8] ),
    .X(net551));
 sg13g2_dlygate4sd3_1 hold553 (.A(\pll_dig.flock.cnt_cap[3] ),
    .X(net552));
 sg13g2_dlygate4sd3_1 hold554 (.A(_1585_),
    .X(net553));
 sg13g2_dlygate4sd3_1 hold555 (.A(_1586_),
    .X(net554));
 sg13g2_dlygate4sd3_1 hold556 (.A(\pll_dig.flock.cnt_cap[4] ),
    .X(net555));
 sg13g2_dlygate4sd3_1 hold557 (.A(\pll_dig.flock.cnt_cap[5] ),
    .X(net556));
 sg13g2_dlygate4sd3_1 hold558 (.A(\pll_dig.flock.cnt_cap[13] ),
    .X(net557));
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
 PLL_ANALOG_MACRO pll_ana (.DCO_EN(net124),
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
 sg13g2_buf_1 rebuffer274 (.A(_0731_),
    .X(net273));
 sg13g2_buf_1 rebuffer275 (.A(_0727_),
    .X(net274));
 sg13g2_buf_1 rebuffer276 (.A(_0636_),
    .X(net275));
 sg13g2_buf_1 rebuffer277 (.A(net309),
    .X(net276));
 sg13g2_buf_1 rebuffer278 (.A(_0741_),
    .X(net277));
 sg13g2_buf_1 rebuffer279 (.A(_0760_),
    .X(net278));
 sg13g2_buf_1 rebuffer280 (.A(net281),
    .X(net279));
 sg13g2_buf_1 rebuffer281 (.A(_0747_),
    .X(net280));
 sg13g2_buf_2 rebuffer282 (.A(_0699_),
    .X(net281));
 sg13g2_buf_1 rebuffer283 (.A(_1155_),
    .X(net282));
 sg13g2_buf_1 rebuffer284 (.A(_0667_),
    .X(net283));
 sg13g2_buf_1 rebuffer285 (.A(_1142_),
    .X(net284));
 sg13g2_buf_1 rebuffer286 (.A(net292),
    .X(net285));
 sg13g2_buf_1 rebuffer287 (.A(net292),
    .X(net286));
 sg13g2_buf_1 rebuffer288 (.A(_0752_),
    .X(net287));
 sg13g2_buf_1 rebuffer289 (.A(_0723_),
    .X(net288));
 sg13g2_buf_1 rebuffer290 (.A(_1171_),
    .X(net289));
 sg13g2_buf_1 rebuffer291 (.A(net311),
    .X(net290));
 sg13g2_buf_1 rebuffer292 (.A(net369),
    .X(net291));
 sg13g2_buf_1 rebuffer293 (.A(_0677_),
    .X(net292));
 sg13g2_buf_1 rebuffer294 (.A(_0735_),
    .X(net293));
 sg13g2_buf_1 rebuffer295 (.A(_1163_),
    .X(net294));
 sg13g2_buf_1 rebuffer296 (.A(_0751_),
    .X(net295));
 sg13g2_buf_1 rebuffer297 (.A(_0626_),
    .X(net296));
 sg13g2_buf_1 rebuffer298 (.A(_0736_),
    .X(net297));
 sg13g2_buf_1 rebuffer299 (.A(_0634_),
    .X(net298));
 sg13g2_buf_2 rebuffer300 (.A(_1149_),
    .X(net299));
 sg13g2_buf_1 rebuffer301 (.A(_1145_),
    .X(net300));
 sg13g2_buf_1 rebuffer302 (.A(_1154_),
    .X(net301));
 sg13g2_buf_1 rebuffer303 (.A(_1153_),
    .X(net302));
 sg13g2_buf_1 rebuffer304 (.A(_1173_),
    .X(net303));
 sg13g2_buf_1 rebuffer305 (.A(_1172_),
    .X(net304));
 sg13g2_buf_1 rebuffer306 (.A(_0641_),
    .X(net305));
 sg13g2_buf_1 rebuffer307 (.A(net312),
    .X(net306));
 sg13g2_buf_1 rebuffer308 (.A(_0638_),
    .X(net307));
 sg13g2_buf_1 rebuffer309 (.A(_1146_),
    .X(net308));
 sg13g2_buf_2 rebuffer310 (.A(_0621_),
    .X(net309));
 sg13g2_buf_1 rebuffer311 (.A(_0640_),
    .X(net310));
 sg13g2_buf_1 rebuffer312 (.A(net369),
    .X(net311));
 sg13g2_buf_1 rebuffer313 (.A(net313),
    .X(net312));
 sg13g2_buf_1 rebuffer314 (.A(_0647_),
    .X(net313));
 sg13g2_buf_1 rebuffer315 (.A(_0623_),
    .X(net314));
 sg13g2_buf_1 rebuffer316 (.A(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .X(net315));
 sg13g2_buf_1 rebuffer317 (.A(_1177_),
    .X(net316));
 sg13g2_buf_1 rebuffer318 (.A(_0739_),
    .X(net317));
 sg13g2_buf_1 rebuffer319 (.A(_1174_),
    .X(net318));
 sg13g2_buf_8 rebuffer320 (.A(_0558_),
    .X(net319));
 sg13g2_buf_1 rebuffer321 (.A(_0558_),
    .X(net320));
 sg13g2_buf_1 rebuffer322 (.A(_0586_),
    .X(net321));
 sg13g2_buf_1 rebuffer323 (.A(_0585_),
    .X(net322));
 sg13g2_buf_1 rebuffer324 (.A(net324),
    .X(net323));
 sg13g2_buf_1 rebuffer325 (.A(_0607_),
    .X(net324));
 sg13g2_buf_1 rebuffer326 (.A(_0587_),
    .X(net325));
 sg13g2_buf_1 rebuffer327 (.A(\pll_dig.div.div[0] ),
    .X(net326));
 sg13g2_buf_1 rebuffer328 (.A(net328),
    .X(net327));
 sg13g2_buf_1 rebuffer329 (.A(net157),
    .X(net328));
 sg13g2_buf_2 rebuffer330 (.A(_0901_),
    .X(net329));
 sg13g2_buf_1 rebuffer331 (.A(_0902_),
    .X(net330));
 sg13g2_buf_1 rebuffer332 (.A(_0903_),
    .X(net331));
 sg13g2_buf_1 rebuffer333 (.A(net338),
    .X(net332));
 sg13g2_buf_1 rebuffer334 (.A(_0917_),
    .X(net333));
 sg13g2_buf_1 rebuffer335 (.A(_0917_),
    .X(net334));
 sg13g2_buf_1 rebuffer336 (.A(_0928_),
    .X(net335));
 sg13g2_buf_8 rebuffer337 (.A(_0930_),
    .X(net336));
 sg13g2_buf_8 rebuffer338 (.A(_0929_),
    .X(net337));
 sg13g2_buf_2 rebuffer339 (.A(_0905_),
    .X(net338));
 sg13g2_buf_1 rebuffer340 (.A(net340),
    .X(net339));
 sg13g2_buf_1 rebuffer341 (.A(_0907_),
    .X(net340));
 sg13g2_buf_1 rebuffer342 (.A(_0916_),
    .X(net341));
 sg13g2_buf_2 rebuffer343 (.A(net343),
    .X(net342));
 sg13g2_buf_2 rebuffer344 (.A(_0909_),
    .X(net343));
 sg13g2_buf_1 rebuffer345 (.A(_0924_),
    .X(net344));
 sg13g2_buf_16 rebuffer351 (.X(net350),
    .A(net85));
 sg13g2_buf_1 rebuffer352 (.A(\pll_dig.div.cnt[1] ),
    .X(net351));
 sg13g2_buf_1 rebuffer353 (.A(\pll_dig.div.cnt[0] ),
    .X(net352));
 sg13g2_buf_1 rebuffer354 (.A(net84),
    .X(net353));
 sg13g2_buf_2 rebuffer357 (.A(net82),
    .X(net356));
 sg13g2_buf_16 rebuffer358 (.X(net357),
    .A(net83));
 sg13g2_buf_1 rebuffer359 (.A(_0931_),
    .X(net358));
 sg13g2_buf_1 rebuffer360 (.A(_0931_),
    .X(net359));
 sg13g2_buf_1 rebuffer362 (.A(_0577_),
    .X(net361));
 sg13g2_buf_1 rebuffer363 (.A(_0581_),
    .X(net362));
 sg13g2_buf_2 rebuffer370 (.A(_0681_),
    .X(net369));
 sg13g2_buf_2 rebuffer372 (.A(_0954_),
    .X(net371));
 sg13g2_buf_1 rebuffer380 (.A(net384),
    .X(net379));
 sg13g2_buf_1 rebuffer385 (.A(net385),
    .X(net384));
 sg13g2_buf_8 rebuffer386 (.A(_0835_),
    .X(net385));
 sg13g2_buf_1 rebuffer387 (.A(_0834_),
    .X(net386));
 sg13g2_buf_1 rebuffer388 (.A(_0837_),
    .X(net387));
 sg13g2_buf_1 rebuffer389 (.A(_0832_),
    .X(net388));
 sg13g2_buf_1 rebuffer390 (.A(_0831_),
    .X(net389));
 sg13g2_buf_2 rebuffer391 (.A(_0836_),
    .X(net390));
 sg13g2_buf_2 rebuffer396 (.A(_0838_),
    .X(net395));
 sg13g2_buf_1 rebuffer405 (.A(_0714_),
    .X(net404));
 sg13g2_buf_2 rebuffer406 (.A(_0705_),
    .X(net405));
 sg13g2_buf_1 rebuffer407 (.A(_1142_),
    .X(net406));
 sg13g2_buf_1 rebuffer412 (.A(\pll_dig.div.ncnt[0] ),
    .X(net411));
 sg13g2_buf_1 rebuffer413 (.A(\pll_dig.div.ncnt[1] ),
    .X(net412));
 sg13g2_buf_1 rebuffer414 (.A(net414),
    .X(net413));
 sg13g2_buf_1 rebuffer415 (.A(\pll_dig.div.ncnt[1] ),
    .X(net414));
 sg13g2_buf_8 rebuffer416 (.A(net385),
    .X(net415));
 sg13g2_buf_1 rebuffer417 (.A(\pll_dig.flock.cnt[1] ),
    .X(net416));
 sg13g2_buf_1 rebuffer418 (.A(\pll_dig.flock.cnt[2] ),
    .X(net417));
 sg13g2_buf_1 rebuffer419 (.A(\pll_dig.flock.cnt[3] ),
    .X(net418));
 sg13g2_buf_1 rebuffer430 (.A(_1762_),
    .X(net429));
 sg13g2_buf_1 rebuffer431 (.A(_1768_),
    .X(net430));
 sg13g2_buf_2 rebuffer432 (.A(_1782_),
    .X(net431));
 sg13g2_buf_1 rebuffer433 (.A(_1768_),
    .X(net432));
 sg13g2_buf_1 rebuffer434 (.A(net431),
    .X(net433));
 sg13g2_buf_1 rebuffer435 (.A(_1787_),
    .X(net434));
 sg13g2_buf_1 rebuffer451 (.A(_1777_),
    .X(net450));
endmodule
