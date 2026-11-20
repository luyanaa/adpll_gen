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
    DSM_ORDER,
    FCW,
    KI,
    KP,
    SET_DIV);
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
 input [7:0] FCW;
 input [15:0] KI;
 input [15:0] KP;
 input [7:0] SET_DIV;

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
 wire net344;
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
 wire net235;
 wire _0055_;
 wire _0056_;
 wire _0057_;
 wire _0058_;
 wire _0059_;
 wire _0060_;
 wire net236;
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
 wire net280;
 wire net283;
 wire net277;
 wire net310;
 wire net296;
 wire net297;
 wire net295;
 wire net302;
 wire net299;
 wire net305;
 wire net304;
 wire net308;
 wire net307;
 wire net306;
 wire net301;
 wire net303;
 wire net293;
 wire net300;
 wire net294;
 wire net298;
 wire net272;
 wire net281;
 wire net269;
 wire net263;
 wire net342;
 wire net341;
 wire net340;
 wire net282;
 wire net339;
 wire net276;
 wire net285;
 wire net257;
 wire _0187_;
 wire net259;
 wire net261;
 wire net265;
 wire net267;
 wire net279;
 wire net258;
 wire net260;
 wire net262;
 wire net264;
 wire net266;
 wire net268;
 wire net284;
 wire net270;
 wire net271;
 wire net278;
 wire net273;
 wire net338;
 wire net337;
 wire _0206_;
 wire net332;
 wire net336;
 wire net256;
 wire net318;
 wire net322;
 wire net326;
 wire net331;
 wire net328;
 wire net329;
 wire net330;
 wire _0217_;
 wire net286;
 wire net291;
 wire _0220_;
 wire _0221_;
 wire net311;
 wire net315;
 wire net319;
 wire net323;
 wire net327;
 wire net312;
 wire net316;
 wire net320;
 wire net324;
 wire net275;
 wire net314;
 wire _0233_;
 wire net335;
 wire net289;
 wire net288;
 wire net334;
 wire net274;
 wire REF_regs;
 wire net287;
 wire net292;
 wire net309;
 wire net313;
 wire net317;
 wire net321;
 wire net325;
 wire _0247_;
 wire net290;
 wire net333;
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
 wire net343;
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
 wire net237;
 wire net238;
 wire net239;
 wire net240;
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
 wire net461;
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
 wire net432;
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
 wire delaynet_4_REF;
 wire net345;
 wire net346;
 wire net347;
 wire net348;
 wire net349;
 wire net350;
 wire net351;
 wire net352;
 wire net353;
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
 wire net388;
 wire net794;
 wire net390;
 wire net391;
 wire net392;
 wire net393;
 wire net394;
 wire net395;
 wire net396;
 wire net397;
 wire net398;
 wire net793;
 wire net400;
 wire net734;
 wire net735;
 wire net736;
 wire net737;
 wire net738;
 wire net739;
 wire net766;
 wire net408;
 wire net409;
 wire net410;
 wire net411;
 wire net412;
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
 wire net431;
 wire net437;
 wire net459;
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
 wire net553;
 wire net554;
 wire net700;
 wire net701;
 wire net705;
 wire net706;
 wire net707;
 wire net708;
 wire net709;
 wire net710;
 wire net722;
 wire net726;
 wire net727;
 wire net728;
 wire net729;
 wire net730;
 wire net731;
 wire net795;
 wire net796;
 wire net797;
 wire net800;
 wire net801;
 wire net802;
 wire net803;
 wire net804;
 wire net805;
 wire net806;
 wire net807;
 wire net808;
 wire net809;
 wire net810;
 wire net811;
 wire net812;
 wire net813;
 wire net814;
 wire net815;
 wire net816;
 wire net817;
 wire net818;
 wire net819;
 wire net820;
 wire net821;
 wire net822;
 wire net823;
 wire net824;
 wire net825;
 wire net826;
 wire net827;
 wire net828;
 wire net829;
 wire net830;
 wire net831;
 wire net832;
 wire net833;
 wire net834;
 wire net835;
 wire net836;
 wire net837;
 wire net838;
 wire net839;
 wire net840;
 wire net841;
 wire net842;
 wire net843;
 wire net844;
 wire net845;
 wire net846;
 wire net847;
 wire net848;
 wire net849;
 wire net850;
 wire net851;
 wire net852;
 wire net853;
 wire net854;
 wire net855;
 wire net856;
 wire net857;
 wire net858;
 wire net859;
 wire net860;
 wire net861;
 wire net862;
 wire net863;
 wire net864;
 wire net865;
 wire net866;
 wire net867;
 wire net868;
 wire net869;
 wire net870;
 wire net871;
 wire net872;
 wire net873;
 wire net874;
 wire net875;
 wire net876;
 wire net877;
 wire net878;
 wire net879;
 wire net880;
 wire net881;
 wire net882;
 wire net883;
 wire net884;
 wire net885;
 wire net886;
 wire net887;
 wire net888;
 wire net889;
 wire net890;
 wire net891;
 wire net892;
 wire net893;
 wire net894;
 wire net895;
 wire net896;
 wire net897;
 wire net898;
 wire net899;
 wire net900;
 wire net901;
 wire net902;
 wire net903;
 wire net904;
 wire net905;
 wire net906;
 wire net907;
 wire net908;
 wire net909;
 wire net910;
 wire net911;
 wire net912;
 wire net913;
 wire net914;
 wire net915;
 wire net916;
 wire net917;
 wire net918;
 wire net919;
 wire net920;
 wire net921;
 wire net922;
 wire net923;
 wire net924;
 wire net925;
 wire net926;
 wire net927;
 wire net928;
 wire net929;
 wire net930;
 wire net931;
 wire net932;
 wire net933;
 wire net934;
 wire net935;
 wire net936;
 wire net937;
 wire net938;
 wire net939;
 wire net940;
 wire net941;
 wire net942;
 wire net943;
 wire net944;
 wire net945;
 wire net946;
 wire net947;
 wire net948;
 wire net949;
 wire net950;
 wire net951;
 wire net952;
 wire net953;
 wire net954;
 wire net955;
 wire net956;
 wire net957;
 wire net958;
 wire net959;
 wire net960;
 wire net961;
 wire net962;
 wire net963;
 wire net964;
 wire net965;
 wire net966;
 wire net967;
 wire net968;
 wire net969;
 wire net970;
 wire net971;
 wire net972;
 wire net973;
 wire net974;
 wire net975;
 wire net976;
 wire net977;
 wire net978;
 wire net979;
 wire net980;
 wire net981;
 wire net982;
 wire net983;
 wire net984;
 wire net985;
 wire net986;
 wire net987;
 wire net988;
 wire net989;
 wire net990;
 wire net991;
 wire net992;
 wire net993;
 wire net994;
 wire net995;
 wire net996;
 wire net997;
 wire net998;
 wire net999;
 wire net1000;
 wire net1001;
 wire net1002;
 wire net1003;
 wire net1004;
 wire net1005;
 wire net1006;
 wire net1007;
 wire net1008;
 wire net1009;
 wire net1010;
 wire net1011;
 wire net1012;
 wire net1013;
 wire net1014;
 wire net1015;
 wire net1016;
 wire net1017;
 wire net1018;
 wire net1019;
 wire net1020;
 wire net1021;
 wire net1022;
 wire net1023;
 wire net1024;
 wire net1025;
 wire net1026;
 wire net1027;
 wire net1028;
 wire net1029;
 wire net1030;
 wire net1031;
 wire net1032;
 wire net1033;
 wire net1034;
 wire net1035;
 wire net1036;
 wire net1037;
 wire net1038;
 wire net1039;
 wire net1040;
 wire net1041;
 wire net1042;
 wire net1043;
 wire net1044;
 wire net1045;
 wire net1046;
 wire net1047;
 wire net1048;
 wire net1049;
 wire net1050;
 wire net1051;
 wire net1052;
 wire net1053;
 wire net1054;
 wire net1055;
 wire net1056;
 wire net1057;
 wire net1058;
 wire net1059;
 wire net1060;
 wire net1061;
 wire net1062;
 wire net1063;
 wire net1064;
 wire net1065;
 wire net1066;
 wire net1067;
 wire net1068;
 wire net1069;
 wire net1070;
 wire net1071;
 wire net1072;
 wire net1073;
 wire net1074;
 wire net1075;
 wire net1076;
 wire net1077;
 wire net1078;
 wire net1079;
 wire net1080;
 wire net1081;
 wire net1082;
 wire net1083;
 wire net1084;
 wire net1085;
 wire net1086;
 wire net1087;
 wire net1088;
 wire net1089;
 wire net1090;
 wire net1091;
 wire net1092;
 wire net1093;
 wire net1094;
 wire net1095;
 wire net1096;
 wire net1097;
 wire net1098;
 wire net1099;
 wire net1100;
 wire net1101;
 wire net1102;
 wire net1103;
 wire net1104;
 wire net1105;
 wire net1106;
 wire net1107;
 wire net1108;
 wire net1109;
 wire net1110;
 wire net1111;
 wire net1112;
 wire net1113;
 wire net1114;
 wire net1115;
 wire net1116;
 wire net1117;
 wire net1118;
 wire net1119;

 sg13g2_inv_1 _2086_ (.Y(_0444_),
    .A(net422));
 sg13g2_inv_1 _2087_ (.Y(_0445_),
    .A(\pll_dig.div.ncnt[3] ));
 sg13g2_inv_1 _2088_ (.Y(_0454_),
    .A(\pll_dig.FILTER_DEC[4] ));
 sg13g2_inv_1 _2089_ (.Y(_0539_),
    .A(\pll_dig.flock.cnt_cap[7] ));
 sg13g2_a21oi_1 _2090_ (.A1(_1348_),
    .A2(_1356_),
    .Y(_1357_),
    .B1(_1313_));
 sg13g2_a21oi_1 _2091_ (.A1(\pll_dig.flock.cnt_done[7] ),
    .A2(_1314_),
    .Y(_1358_),
    .B1(_1357_));
 sg13g2_nand2_1 _2092_ (.Y(_1359_),
    .A(\pll_dig.flock.cnt_done[2] ),
    .B(_1353_));
 sg13g2_nor2_1 _2093_ (.A(_1350_),
    .B(_1353_),
    .Y(_1360_));
 sg13g2_xnor2_1 _2094_ (.Y(_1361_),
    .A(_0457_),
    .B(_1360_));
 sg13g2_o21ai_1 _2095_ (.B1(_1316_),
    .Y(_0023_),
    .A1(_1358_),
    .A2(_1361_));
 sg13g2_nor2_1 _2096_ (.A(\pll_dig.flock.cnt_gray[5] ),
    .B(net122),
    .Y(_1362_));
 sg13g2_nor2_1 _2097_ (.A(\pll_dig.flock.cnt[6] ),
    .B(net495),
    .Y(_1363_));
 sg13g2_xor2_1 _2098_ (.B(_1363_),
    .A(\pll_dig.flock.cnt[7] ),
    .X(_1364_));
 sg13g2_a21oi_1 _2099_ (.A1(net122),
    .A2(_1364_),
    .Y(_0404_),
    .B1(_1362_));
 sg13g2_inv_1 _2100_ (.Y(_0540_),
    .A(\pll_dig.clr_r2 ));
 sg13g2_nor2_1 _2101_ (.A(\pll_dig.flock.cnt_gray[14] ),
    .B(net123),
    .Y(_1365_));
 sg13g2_a21oi_2 _2102_ (.B1(\pll_dig.flock.cnt[15] ),
    .Y(_1366_),
    .A2(_0861_),
    .A1(\pll_dig.flock.cnt[14] ));
 sg13g2_xor2_1 _2103_ (.B(_1366_),
    .A(\pll_dig.flock.cnt_gray[15] ),
    .X(_1367_));
 sg13g2_a21oi_1 _2104_ (.A1(net123),
    .A2(_1367_),
    .Y(_0403_),
    .B1(_1365_));
 sg13g2_nor2_1 _2105_ (.A(net103),
    .B(\pll_dig.FILTER_DEC[1] ),
    .Y(_1368_));
 sg13g2_nand2_1 _2106_ (.Y(_1369_),
    .A(\pll_dig.FILTER_DEC[4] ),
    .B(\pll_dig.FILTER_DEC[3] ));
 sg13g2_inv_1 _2107_ (.Y(\pll_dig.FINE_MUX_D[23] ),
    .A(net102));
 sg13g2_nor2_1 _2108_ (.A(_1368_),
    .B(net102),
    .Y(\pll_dig.FINE_MUX_D[25] ));
 sg13g2_nand2_1 _2109_ (.Y(_1370_),
    .A(\pll_dig.FILTER_DEC[0] ),
    .B(\pll_dig.FILTER_DEC[1] ));
 sg13g2_nand2_1 _2110_ (.Y(_1371_),
    .A(net103),
    .B(\pll_dig.FINE_MUX_D[23] ));
 sg13g2_inv_1 _2111_ (.Y(_0541_),
    .A(\pll_dig.out_edges_g2[8] ));
 sg13g2_inv_1 _2112_ (.Y(\pll_dig.FINE_MUX_D[27] ),
    .A(_1371_));
 sg13g2_a21oi_1 _2113_ (.A1(_0482_),
    .A2(_1370_),
    .Y(\pll_dig.FINE_MUX_D[26] ),
    .B1(net102));
 sg13g2_nor2_1 _2114_ (.A(\pll_dig.FILTER_DEC[0] ),
    .B(\pll_dig.FILTER_DEC[1] ),
    .Y(_1372_));
 sg13g2_nand2_1 _2115_ (.Y(_1373_),
    .A(\pll_dig.FILTER_DEC[4] ),
    .B(net103));
 sg13g2_nor2_1 _2116_ (.A(_1371_),
    .B(_1372_),
    .Y(\pll_dig.FINE_MUX_D[28] ));
 sg13g2_nand2_1 _2117_ (.Y(_1374_),
    .A(net103),
    .B(\pll_dig.FILTER_DEC[1] ));
 sg13g2_nor2_1 _2118_ (.A(_1369_),
    .B(_1374_),
    .Y(\pll_dig.FINE_MUX_D[29] ));
 sg13g2_nand3_1 _2119_ (.B(\pll_dig.FILTER_DEC[0] ),
    .C(\pll_dig.FILTER_DEC[1] ),
    .A(net103),
    .Y(_1375_));
 sg13g2_nor2_1 _2120_ (.A(_1369_),
    .B(_1375_),
    .Y(\pll_dig.FINE_MUX_D[30] ));
 sg13g2_nor2_1 _2121_ (.A(net103),
    .B(\pll_dig.FILTER_DEC[3] ),
    .Y(_1376_));
 sg13g2_inv_1 _2122_ (.Y(_0542_),
    .A(\pll_dig.out_edges_g2[6] ));
 sg13g2_nand2_1 _2123_ (.Y(\pll_dig.FINE_MUX_D[19] ),
    .A(net102),
    .B(_1373_));
 sg13g2_o21ai_1 _2124_ (.B1(net102),
    .Y(\pll_dig.FINE_MUX_D[20] ),
    .A1(_1372_),
    .A2(_1373_));
 sg13g2_nand2_1 _2125_ (.Y(_1377_),
    .A(net879),
    .B(_0974_));
 sg13g2_xnor2_1 _2126_ (.Y(_0148_),
    .A(_0981_),
    .B(net880));
 sg13g2_a221oi_1 _2127_ (.B2(\pll_dig.MID_MUX_D[8] ),
    .C1(net71),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[6] ),
    .Y(_1378_),
    .A2(net87));
 sg13g2_a22oi_1 _2128_ (.Y(_0402_),
    .B1(net68),
    .B2(_1378_),
    .A2(net71),
    .A1(_0489_));
 sg13g2_nand2_1 _2129_ (.Y(_1379_),
    .A(_0468_),
    .B(net492));
 sg13g2_xnor2_1 _2130_ (.Y(_1380_),
    .A(\pll_dig.flock.cnt[9] ),
    .B(_1379_));
 sg13g2_nor2_1 _2131_ (.A(\pll_dig.flock.cnt_gray[7] ),
    .B(net125),
    .Y(_1381_));
 sg13g2_a21oi_1 _2132_ (.A1(net125),
    .A2(_1380_),
    .Y(_0401_),
    .B1(_1381_));
 sg13g2_inv_1 _2133_ (.Y(_0543_),
    .A(\pll_dig.out_edges_g2_q[6] ));
 sg13g2_a21oi_1 _2134_ (.A1(_0894_),
    .A2(_1298_),
    .Y(_1382_),
    .B1(\pll_dig.ref_wd.cnt[3] ));
 sg13g2_nor3_1 _2135_ (.A(_0898_),
    .B(_1304_),
    .C(_1382_),
    .Y(_0400_));
 sg13g2_xor2_1 _2136_ (.B(_0864_),
    .A(\pll_dig.flock.cnt[5] ),
    .X(_0399_));
 sg13g2_nor2b_1 _2137_ (.A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .B_N(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .Y(_0045_));
 sg13g2_xor2_1 _2138_ (.B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .X(_0046_));
 sg13g2_a21oi_1 _2139_ (.A1(_0454_),
    .A2(_1375_),
    .Y(\pll_dig.FINE_MUX_D[14] ),
    .B1(net95));
 sg13g2_a21oi_1 _2140_ (.A1(_0454_),
    .A2(_1374_),
    .Y(\pll_dig.FINE_MUX_D[13] ),
    .B1(net95));
 sg13g2_a21oi_1 _2141_ (.A1(_0454_),
    .A2(_1368_),
    .Y(\pll_dig.FINE_MUX_D[9] ),
    .B1(net95));
 sg13g2_o21ai_1 _2142_ (.B1(_0833_),
    .Y(\pll_dig.FINE_MUX_D[10] ),
    .A1(net95),
    .A2(_1370_));
 sg13g2_o21ai_1 _2143_ (.B1(net102),
    .Y(\pll_dig.FINE_MUX_D[17] ),
    .A1(_0454_),
    .A2(_1368_));
 sg13g2_inv_1 _2144_ (.Y(_0544_),
    .A(\pll_dig.out_edges_g2[4] ));
 sg13g2_a21o_1 _2145_ (.A2(\pll_dig.FILTER_DEC[0] ),
    .A1(\pll_dig.FILTER_DEC[4] ),
    .B1(\pll_dig.FINE_MUX_D[17] ),
    .X(\pll_dig.FINE_MUX_D[16] ));
 sg13g2_nand2_1 _2146_ (.Y(_1383_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .B(net108));
 sg13g2_o21ai_1 _2147_ (.B1(_1383_),
    .Y(_0398_),
    .A1(net108),
    .A2(net362));
 sg13g2_xnor2_1 _2148_ (.Y(_0104_),
    .A(net12),
    .B(_0702_));
 sg13g2_and2_1 _2149_ (.A(net98),
    .B(_0720_),
    .X(_1384_));
 sg13g2_xor2_1 _2150_ (.B(_1384_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .X(_0397_));
 sg13g2_nand2_1 _2151_ (.Y(_1385_),
    .A(_0809_),
    .B(net377));
 sg13g2_a21oi_1 _2152_ (.A1(_0811_),
    .A2(_1385_),
    .Y(_1386_),
    .B1(net107));
 sg13g2_a21oi_1 _2153_ (.A1(_0488_),
    .A2(net107),
    .Y(_0396_),
    .B1(_1386_));
 sg13g2_nor2_1 _2154_ (.A(net104),
    .B(_0793_),
    .Y(_1387_));
 sg13g2_inv_1 _2155_ (.Y(_0545_),
    .A(\pll_dig.out_edges_g2[2] ));
 sg13g2_a21oi_1 _2156_ (.A1(_0498_),
    .A2(net105),
    .Y(_0395_),
    .B1(_1387_));
 sg13g2_nor2_1 _2157_ (.A(net108),
    .B(net348),
    .Y(_1388_));
 sg13g2_a21oi_1 _2158_ (.A1(_0499_),
    .A2(net108),
    .Y(_0394_),
    .B1(_1388_));
 sg13g2_nand2_1 _2159_ (.Y(_1389_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .B(net105));
 sg13g2_o21ai_1 _2160_ (.B1(_1389_),
    .Y(_0393_),
    .A1(net105),
    .A2(net357));
 sg13g2_xor2_1 _2161_ (.B(net6),
    .A(net5),
    .X(_0098_));
 sg13g2_inv_1 _2162_ (.Y(_0120_),
    .A(_0098_));
 sg13g2_a21o_1 _2163_ (.A2(_0700_),
    .A1(net9),
    .B1(net10),
    .X(_1390_));
 sg13g2_and2_1 _2164_ (.A(_0701_),
    .B(_1390_),
    .X(_0102_));
 sg13g2_xor2_1 _2165_ (.B(_0797_),
    .A(_0795_),
    .X(_1391_));
 sg13g2_inv_1 _2166_ (.Y(_0546_),
    .A(\pll_dig.out_edges_g2_q[2] ));
 sg13g2_nor2_1 _2167_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[2] ),
    .B(net98),
    .Y(_1392_));
 sg13g2_a21oi_1 _2168_ (.A1(net98),
    .A2(_1391_),
    .Y(_0392_),
    .B1(_1392_));
 sg13g2_nand2_1 _2169_ (.Y(_1393_),
    .A(_1237_),
    .B(net372));
 sg13g2_a21oi_1 _2170_ (.A1(_1239_),
    .A2(_1393_),
    .Y(_1394_),
    .B1(net108));
 sg13g2_a21oi_1 _2171_ (.A1(_0501_),
    .A2(net108),
    .Y(_0391_),
    .B1(_1394_));
 sg13g2_mux2_1 _2172_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .A1(net373),
    .S(net98),
    .X(_0390_));
 sg13g2_mux2_1 _2173_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .A1(net360),
    .S(net100),
    .X(_0389_));
 sg13g2_nand2_1 _2174_ (.Y(_1395_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .B(net106));
 sg13g2_o21ai_1 _2175_ (.B1(_1395_),
    .Y(_0388_),
    .A1(net106),
    .A2(_0746_));
 sg13g2_and2_1 _2176_ (.A(_0556_),
    .B(_0697_),
    .X(_1396_));
 sg13g2_inv_1 _2177_ (.Y(_0547_),
    .A(\pll_dig.out_edges_g2[0] ));
 sg13g2_and2_1 _2178_ (.A(_0519_),
    .B(_1396_),
    .X(_1397_));
 sg13g2_and2_1 _2179_ (.A(_0500_),
    .B(_1397_),
    .X(_1398_));
 sg13g2_and2_1 _2180_ (.A(_0453_),
    .B(_1398_),
    .X(_1399_));
 sg13g2_and2_1 _2181_ (.A(_0476_),
    .B(_1399_),
    .X(_0127_));
 sg13g2_xnor2_1 _2182_ (.Y(_0126_),
    .A(_0476_),
    .B(_1399_));
 sg13g2_xnor2_1 _2183_ (.Y(_0123_),
    .A(_0519_),
    .B(_1396_));
 sg13g2_xnor2_1 _2184_ (.Y(_0124_),
    .A(_0500_),
    .B(_1397_));
 sg13g2_xnor2_1 _2185_ (.Y(_0111_),
    .A(\pll_dig.flock.cnt_gray_s2[1] ),
    .B(_1213_));
 sg13g2_xnor2_1 _2186_ (.Y(_1400_),
    .A(\pll_dig.flock.cnt_coarse_wait[6] ),
    .B(_0665_));
 sg13g2_o21ai_1 _2187_ (.B1(net79),
    .Y(_0019_),
    .A1(_0673_),
    .A2(_1400_));
 sg13g2_inv_1 _2188_ (.Y(_0548_),
    .A(\pll_dig.out_edges_g2_q[7] ));
 sg13g2_nand3_1 _2189_ (.B(_0674_),
    .C(net111),
    .A(\pll_dig.flock.cnt_err[1] ),
    .Y(_1401_));
 sg13g2_xnor2_1 _2190_ (.Y(_1402_),
    .A(\pll_dig.flock.cnt_err[1] ),
    .B(\pll_dig.flock.cnt_err[0] ));
 sg13g2_o21ai_1 _2191_ (.B1(_1401_),
    .Y(_0030_),
    .A1(net80),
    .A2(_1402_));
 sg13g2_a21oi_1 _2192_ (.A1(_0482_),
    .A2(_1372_),
    .Y(\pll_dig.FINE_MUX_D[24] ),
    .B1(_1369_));
 sg13g2_nand2_1 _2193_ (.Y(\pll_dig.flock.u_fll_icg.EN ),
    .A(net901),
    .B(\pll_dig.FREQ_LOCKED ));
 sg13g2_nand2_1 _2194_ (.Y(_1403_),
    .A(\pll_dig.flock.cnt_done[5] ),
    .B(_1315_));
 sg13g2_nor2_1 _2195_ (.A(_0474_),
    .B(_1354_),
    .Y(_1404_));
 sg13g2_or2_1 _2196_ (.X(_1405_),
    .B(\pll_dig.flock.cnt_done[6] ),
    .A(\pll_dig.flock.cnt_done[7] ));
 sg13g2_a21oi_1 _2197_ (.A1(_1355_),
    .A2(_1405_),
    .Y(_1406_),
    .B1(_1404_));
 sg13g2_nand4_1 _2198_ (.B(\pll_dig.flock.cnt_done[3] ),
    .C(\pll_dig.flock.cnt_done[4] ),
    .A(\pll_dig.flock.cnt_done[2] ),
    .Y(_1407_),
    .D(_1352_));
 sg13g2_inv_1 _2199__333 (.Y(net332),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_inv_1 _2200_ (.Y(_0549_),
    .A(net150));
 sg13g2_or2_1 _2201_ (.X(_1408_),
    .B(_1407_),
    .A(_0474_));
 sg13g2_xnor2_1 _2202_ (.Y(_1409_),
    .A(_0474_),
    .B(_1407_));
 sg13g2_mux2_1 _2203_ (.A0(_1406_),
    .A1(_1409_),
    .S(net900),
    .X(_1410_));
 sg13g2_o21ai_1 _2204_ (.B1(_1403_),
    .Y(_0026_),
    .A1(_1313_),
    .A2(_1410_));
 sg13g2_o21ai_1 _2205_ (.B1(net102),
    .Y(\pll_dig.FINE_MUX_D[21] ),
    .A1(_0454_),
    .A2(_1374_));
 sg13g2_or2_1 _2206_ (.X(_1411_),
    .B(\pll_dig.div.ncnt[0] ),
    .A(net554));
 sg13g2_and3_1 _2207_ (.X(_0038_),
    .A(_0591_),
    .B(_0627_),
    .C(_1411_));
 sg13g2_nor2_1 _2208_ (.A(net854),
    .B(_0051_),
    .Y(net58));
 sg13g2_nand2_1 _2209_ (.Y(_1412_),
    .A(_0464_),
    .B(\pll_dig.FREQ_ERR ));
 sg13g2_nor2_1 _2210_ (.A(_0678_),
    .B(_0695_),
    .Y(_1413_));
 sg13g2_inv_1 _2211_ (.Y(_0550_),
    .A(\pll_dig.flock.cnt_filt[0] ));
 sg13g2_nor2_1 _2212_ (.A(\pll_dig.flock.cnt_err[2] ),
    .B(\pll_dig.flock.cnt_err[5] ),
    .Y(_1414_));
 sg13g2_nor4_1 _2213_ (.A(\pll_dig.flock.cnt_err[4] ),
    .B(\pll_dig.flock.cnt_err[3] ),
    .C(\pll_dig.flock.cnt_err[1] ),
    .D(\pll_dig.flock.cnt_err[0] ),
    .Y(_1415_));
 sg13g2_nand4_1 _2214_ (.B(_0574_),
    .C(_1414_),
    .A(\pll_dig.flock.cnt_err[6] ),
    .Y(_1416_),
    .D(_1415_));
 sg13g2_o21ai_1 _2215_ (.B1(_1412_),
    .Y(_0011_),
    .A1(_1413_),
    .A2(_1416_));
 sg13g2_nand2_1 _2216_ (.Y(_1417_),
    .A(\pll_dig.flock.cnt_done[4] ),
    .B(_1315_));
 sg13g2_a21oi_1 _2217_ (.A1(_0457_),
    .A2(_1350_),
    .Y(_1418_),
    .B1(\pll_dig.flock.cnt_done[3] ));
 sg13g2_a21oi_1 _2218_ (.A1(\pll_dig.flock.cnt_done[3] ),
    .A2(_1359_),
    .Y(_1419_),
    .B1(_1418_));
 sg13g2_xnor2_1 _2219_ (.Y(_1420_),
    .A(\pll_dig.flock.cnt_done[4] ),
    .B(_1419_));
 sg13g2_o21ai_1 _2220_ (.B1(_1417_),
    .Y(_0025_),
    .A1(_1358_),
    .A2(_1420_));
 sg13g2_xnor2_1 _2221_ (.Y(_0101_),
    .A(_0519_),
    .B(_0700_));
 sg13g2_inv_1 _2222_ (.Y(_0551_),
    .A(\pll_dig.out_edges[3] ));
 sg13g2_xor2_1 _2223_ (.B(_1242_),
    .A(net358),
    .X(_1421_));
 sg13g2_nor2_1 _2224_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .B(net100),
    .Y(_1422_));
 sg13g2_a21oi_1 _2225_ (.A1(net100),
    .A2(_1421_),
    .Y(_0386_),
    .B1(_1422_));
 sg13g2_nand2_1 _2226_ (.Y(_1423_),
    .A(net384),
    .B(net104));
 sg13g2_o21ai_1 _2227_ (.B1(_1423_),
    .Y(_0385_),
    .A1(net104),
    .A2(net371));
 sg13g2_o21ai_1 _2228_ (.B1(net102),
    .Y(\pll_dig.FINE_MUX_D[22] ),
    .A1(_1370_),
    .A2(_1373_));
 sg13g2_a21oi_2 _2229_ (.B1(_1283_),
    .Y(\pll_dig.FILTER_DEC_RAW[4] ),
    .A2(net385),
    .A1(_1268_));
 sg13g2_nand2_1 _2230_ (.Y(\pll_dig.FINE_MUX_D[5] ),
    .A(net95),
    .B(_1374_));
 sg13g2_nor2_1 _2231_ (.A(net103),
    .B(\pll_dig.FINE_MUX_D[7] ),
    .Y(_1424_));
 sg13g2_inv_1 _2232_ (.Y(\pll_dig.FINE_MUX_D[3] ),
    .A(_1424_));
 sg13g2_inv_1 _2233_ (.Y(_0552_),
    .A(\pll_dig.flock.cnt_filt[5] ));
 sg13g2_nand2_1 _2234_ (.Y(\pll_dig.FINE_MUX_D[0] ),
    .A(_1372_),
    .B(_1424_));
 sg13g2_nand2_1 _2235_ (.Y(\pll_dig.FINE_MUX_D[6] ),
    .A(net95),
    .B(_1375_));
 sg13g2_xor2_1 _2236_ (.B(_0111_),
    .A(\pll_dig.flock.cnt_gray_s2[0] ),
    .X(_0105_));
 sg13g2_nor2b_1 _2237_ (.A(\pll_dig.flock.cnt_bin[12] ),
    .B_N(_0108_),
    .Y(_1425_));
 sg13g2_nand2_1 _2238_ (.Y(_1426_),
    .A(\pll_dig.flock.cnt_bin[12] ),
    .B(_0108_));
 sg13g2_or2_1 _2239_ (.X(_1427_),
    .B(_0108_),
    .A(\pll_dig.flock.cnt_bin[12] ));
 sg13g2_nand2_1 _2240_ (.Y(_1428_),
    .A(_1426_),
    .B(_1427_));
 sg13g2_or2_1 _2241_ (.X(_1429_),
    .B(_1210_),
    .A(\pll_dig.flock.cnt_bin[11] ));
 sg13g2_and2_1 _2242_ (.A(\pll_dig.flock.cnt_bin[11] ),
    .B(_1210_),
    .X(_1430_));
 sg13g2_xnor2_1 _2243_ (.Y(_1431_),
    .A(_0537_),
    .B(_0106_));
 sg13g2_inv_1 _2244_ (.Y(_0553_),
    .A(\pll_dig.COARSE_MUX_D[3] ));
 sg13g2_nor2b_1 _2245_ (.A(\pll_dig.flock.cnt_bin[9] ),
    .B_N(_0119_),
    .Y(_1432_));
 sg13g2_nor2b_1 _2246_ (.A(_0119_),
    .B_N(\pll_dig.flock.cnt_bin[9] ),
    .Y(_1433_));
 sg13g2_nor2_1 _2247_ (.A(\pll_dig.flock.cnt_bin[8] ),
    .B(_1211_),
    .Y(_1434_));
 sg13g2_xnor2_1 _2248_ (.Y(_1435_),
    .A(\pll_dig.flock.cnt_bin[8] ),
    .B(_1211_));
 sg13g2_nor2b_1 _2249_ (.A(\pll_dig.flock.cnt_bin[7] ),
    .B_N(_0117_),
    .Y(_1436_));
 sg13g2_nor2b_1 _2250_ (.A(_0117_),
    .B_N(\pll_dig.flock.cnt_bin[7] ),
    .Y(_1437_));
 sg13g2_nor2_1 _2251_ (.A(\pll_dig.flock.cnt_bin[6] ),
    .B(_1212_),
    .Y(_1438_));
 sg13g2_xnor2_1 _2252_ (.Y(_1439_),
    .A(\pll_dig.flock.cnt_bin[6] ),
    .B(_1212_));
 sg13g2_and2_1 _2253_ (.A(_0536_),
    .B(_0115_),
    .X(_1440_));
 sg13g2_or2_1 _2254_ (.X(_1441_),
    .B(_0115_),
    .A(_0536_));
 sg13g2_inv_1 _2255_ (.Y(_0554_),
    .A(\pll_dig.COARSE_MUX_D[4] ));
 sg13g2_inv_1 _2256_ (.Y(_1442_),
    .A(_1441_));
 sg13g2_nor2b_1 _2257_ (.A(\pll_dig.flock.cnt_bin[4] ),
    .B_N(_0114_),
    .Y(_1443_));
 sg13g2_nand2b_1 _2258_ (.Y(_1444_),
    .B(_0113_),
    .A_N(\pll_dig.flock.cnt_bin[3] ));
 sg13g2_nor2_1 _2259_ (.A(\pll_dig.flock.cnt_bin[2] ),
    .B(_1213_),
    .Y(_1445_));
 sg13g2_nand2b_1 _2260_ (.Y(_1446_),
    .B(_0111_),
    .A_N(\pll_dig.flock.cnt_bin[1] ));
 sg13g2_xnor2_1 _2261_ (.Y(_1447_),
    .A(\pll_dig.flock.cnt_bin[1] ),
    .B(_0111_));
 sg13g2_or2_1 _2262_ (.X(_1448_),
    .B(_0105_),
    .A(_0564_));
 sg13g2_o21ai_1 _2263_ (.B1(_1447_),
    .Y(_1449_),
    .A1(_0564_),
    .A2(_0105_));
 sg13g2_xnor2_1 _2264_ (.Y(_1450_),
    .A(\pll_dig.flock.cnt_bin[2] ),
    .B(_1213_));
 sg13g2_a21oi_1 _2265_ (.A1(_1446_),
    .A2(_1449_),
    .Y(_1451_),
    .B1(_1450_));
 sg13g2_inv_1 _2266_ (.Y(_0555_),
    .A(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_xnor2_1 _2267_ (.Y(_1452_),
    .A(\pll_dig.flock.cnt_bin[3] ),
    .B(_0113_));
 sg13g2_o21ai_1 _2268_ (.B1(_1452_),
    .Y(_1453_),
    .A1(_1445_),
    .A2(_1451_));
 sg13g2_xor2_1 _2269_ (.B(_0114_),
    .A(\pll_dig.flock.cnt_bin[4] ),
    .X(_1454_));
 sg13g2_a21oi_1 _2270_ (.A1(_1444_),
    .A2(_1453_),
    .Y(_1455_),
    .B1(_1454_));
 sg13g2_nor2_1 _2271_ (.A(_1443_),
    .B(_1455_),
    .Y(_1456_));
 sg13g2_nor3_1 _2272_ (.A(_1440_),
    .B(_1443_),
    .C(_1455_),
    .Y(_1457_));
 sg13g2_nor3_1 _2273_ (.A(_1439_),
    .B(_1442_),
    .C(_1457_),
    .Y(_1458_));
 sg13g2_or2_1 _2274_ (.X(_1459_),
    .B(_1458_),
    .A(_1438_));
 sg13g2_nor3_1 _2275_ (.A(_1436_),
    .B(_1438_),
    .C(_1458_),
    .Y(_1460_));
 sg13g2_nor3_1 _2276_ (.A(_1435_),
    .B(_1437_),
    .C(_1460_),
    .Y(_1461_));
 sg13g2_inv_1 _2277_ (.Y(_0556_),
    .A(net8));
 sg13g2_or2_1 _2278_ (.X(_1462_),
    .B(_1461_),
    .A(_1434_));
 sg13g2_nor3_1 _2279_ (.A(_1432_),
    .B(_1434_),
    .C(_1461_),
    .Y(_1463_));
 sg13g2_nor3_1 _2280_ (.A(_1431_),
    .B(_1433_),
    .C(_1463_),
    .Y(_1464_));
 sg13g2_a21oi_1 _2281_ (.A1(_0537_),
    .A2(_0106_),
    .Y(_1465_),
    .B1(_1464_));
 sg13g2_a21oi_1 _2282_ (.A1(_1429_),
    .A2(_1465_),
    .Y(_1466_),
    .B1(_1430_));
 sg13g2_a221oi_1 _2283_ (.B2(_1465_),
    .C1(_1430_),
    .B1(_1429_),
    .A1(_1426_),
    .Y(_1467_),
    .A2(_1427_));
 sg13g2_o21ai_1 _2284_ (.B1(net150),
    .Y(_1468_),
    .A1(_1428_),
    .A2(_1466_));
 sg13g2_nor2_1 _2285_ (.A(_1467_),
    .B(_1468_),
    .Y(_0065_));
 sg13g2_nor2_1 _2286_ (.A(_1425_),
    .B(_1467_),
    .Y(_1469_));
 sg13g2_or2_1 _2287_ (.X(_1470_),
    .B(_1019_),
    .A(\pll_dig.flock.cnt_bin[13] ));
 sg13g2_inv_1 _2288_ (.Y(_0557_),
    .A(net853));
 sg13g2_nand2_1 _2289_ (.Y(_1471_),
    .A(\pll_dig.flock.cnt_bin[13] ),
    .B(_1019_));
 sg13g2_nand2_1 _2290_ (.Y(_1472_),
    .A(_1470_),
    .B(_1471_));
 sg13g2_o21ai_1 _2291_ (.B1(net150),
    .Y(_1473_),
    .A1(_1469_),
    .A2(_1472_));
 sg13g2_a21oi_1 _2292_ (.A1(_1469_),
    .A2(_1472_),
    .Y(_0066_),
    .B1(_1473_));
 sg13g2_xnor2_1 _2293_ (.Y(_0147_),
    .A(net821),
    .B(_0979_));
 sg13g2_nand3_1 _2294_ (.B(\pll_dig.div_rst_cnt[2] ),
    .C(\pll_dig.div_rst_cnt[1] ),
    .A(\pll_dig.div_rst_cnt[0] ),
    .Y(_1474_));
 sg13g2_or2_1 _2295_ (.X(_1475_),
    .B(_1474_),
    .A(_0572_));
 sg13g2_nor2b_1 _2296_ (.A(net137),
    .B_N(_1475_),
    .Y(_1476_));
 sg13g2_inv_1 _2297_ (.Y(_0009_),
    .A(_1476_));
 sg13g2_and3_1 _2298_ (.X(_1477_),
    .A(\pll_dig.out_edges[5] ),
    .B(\pll_dig.out_edges[4] ),
    .C(_1021_));
 sg13g2_inv_1 _2299_ (.Y(_0558_),
    .A(\pll_dig.ref_wd.cnt[9] ));
 sg13g2_nand3_1 _2300_ (.B(\pll_dig.out_edges[4] ),
    .C(_1021_),
    .A(\pll_dig.out_edges[5] ),
    .Y(_1478_));
 sg13g2_a21oi_1 _2301_ (.A1(\pll_dig.out_edges[4] ),
    .A2(_1021_),
    .Y(_1479_),
    .B1(\pll_dig.out_edges[5] ));
 sg13g2_nor2_1 _2302_ (.A(_1477_),
    .B(_1479_),
    .Y(\pll_dig.out_edges_next[5] ));
 sg13g2_xnor2_1 _2303_ (.Y(_0004_),
    .A(\pll_dig.out_edges[5] ),
    .B(_1022_));
 sg13g2_a21o_1 _2304_ (.A2(\pll_dig.out_edges[0] ),
    .A1(\pll_dig.out_edges[1] ),
    .B1(\pll_dig.out_edges[2] ),
    .X(_1480_));
 sg13g2_and2_1 _2305_ (.A(_1020_),
    .B(_1480_),
    .X(\pll_dig.out_edges_next[2] ));
 sg13g2_nor2_1 _2306_ (.A(\pll_dig.out_edges_next[1] ),
    .B(\pll_dig.out_edges_next[2] ),
    .Y(_1481_));
 sg13g2_a21oi_1 _2307_ (.A1(\pll_dig.out_edges[2] ),
    .A2(\pll_dig.out_edges_next[1] ),
    .Y(_0001_),
    .B1(_1481_));
 sg13g2_nand2_1 _2308_ (.Y(_1482_),
    .A(\pll_dig.out_edges[6] ),
    .B(_1477_));
 sg13g2_nor2_1 _2309_ (.A(_0566_),
    .B(_1482_),
    .Y(_1483_));
 sg13g2_inv_1 _2310_ (.Y(_0455_),
    .A(\pll_dig.COARSE_MUX_D[2] ));
 sg13g2_inv_1 _2311_ (.Y(_0559_),
    .A(net907));
 sg13g2_nand2_1 _2312_ (.Y(_1484_),
    .A(\pll_dig.out_edges[8] ),
    .B(_1483_));
 sg13g2_nor2_1 _2313_ (.A(\pll_dig.out_edges[8] ),
    .B(_1483_),
    .Y(_1485_));
 sg13g2_xor2_1 _2314_ (.B(_1483_),
    .A(\pll_dig.out_edges[8] ),
    .X(\pll_dig.out_edges_next[8] ));
 sg13g2_xnor2_1 _2315_ (.Y(\pll_dig.out_edges_next[9] ),
    .A(\pll_dig.out_edges[9] ),
    .B(_1484_));
 sg13g2_xnor2_1 _2316_ (.Y(_0008_),
    .A(\pll_dig.out_edges[9] ),
    .B(_1485_));
 sg13g2_nand2_1 _2317_ (.Y(_1486_),
    .A(_0566_),
    .B(_1482_));
 sg13g2_nor2b_1 _2318_ (.A(_1483_),
    .B_N(_1486_),
    .Y(\pll_dig.out_edges_next[7] ));
 sg13g2_xor2_1 _2319_ (.B(_1486_),
    .A(\pll_dig.out_edges[8] ),
    .X(_0007_));
 sg13g2_nor2_1 _2320_ (.A(\pll_dig.out_edges[6] ),
    .B(_1477_),
    .Y(_1487_));
 sg13g2_xnor2_1 _2321_ (.Y(\pll_dig.out_edges_next[6] ),
    .A(\pll_dig.out_edges[6] ),
    .B(_1478_));
 sg13g2_inv_1 _2322_ (.Y(_0560_),
    .A(\pll_dig.dco_miss_cnt[1] ));
 sg13g2_xnor2_1 _2323_ (.Y(_0005_),
    .A(\pll_dig.out_edges[6] ),
    .B(_1479_));
 sg13g2_o21ai_1 _2324_ (.B1(_1431_),
    .Y(_1488_),
    .A1(_1433_),
    .A2(_1463_));
 sg13g2_nand2_1 _2325_ (.Y(_1489_),
    .A(net151),
    .B(_1488_));
 sg13g2_nor2_1 _2326_ (.A(_1464_),
    .B(_1489_),
    .Y(_0063_));
 sg13g2_a221oi_1 _2327_ (.B2(\pll_dig.MID_MUX_D[7] ),
    .C1(net71),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[5] ),
    .Y(_1490_),
    .A2(net87));
 sg13g2_a22oi_1 _2328_ (.Y(_0375_),
    .B1(net68),
    .B2(_1490_),
    .A2(net71),
    .A1(_0494_));
 sg13g2_xnor2_1 _2329_ (.Y(_0374_),
    .A(\pll_dig.flock.cnt[9] ),
    .B(_1104_));
 sg13g2_o21ai_1 _2330_ (.B1(net121),
    .Y(_1491_),
    .A1(net500),
    .A2(net499));
 sg13g2_a21oi_1 _2331_ (.A1(net500),
    .A2(net499),
    .Y(_1492_),
    .B1(_1491_));
 sg13g2_a21oi_1 _2332_ (.A1(net500),
    .A2(net499),
    .Y(_1493_),
    .B1(net501));
 sg13g2_inv_1 _2333_ (.Y(_0561_),
    .A(\pll_dig.flock.freq_miss[1] ));
 sg13g2_nor3_1 _2334_ (.A(net119),
    .B(net494),
    .C(_1493_),
    .Y(_1494_));
 sg13g2_a21oi_1 _2335_ (.A1(\pll_dig.flock.cnt_gray[1] ),
    .A2(net119),
    .Y(_1495_),
    .B1(_1494_));
 sg13g2_nand2b_1 _2336_ (.Y(_1496_),
    .B(_1493_),
    .A_N(_1491_));
 sg13g2_o21ai_1 _2337_ (.B1(_1496_),
    .Y(_0373_),
    .A1(_1492_),
    .A2(_1495_));
 sg13g2_a21oi_1 _2338_ (.A1(\pll_dig.flock.cnt[9] ),
    .A2(net491),
    .Y(_1497_),
    .B1(\pll_dig.flock.cnt[10] ));
 sg13g2_nand2_1 _2339_ (.Y(_1498_),
    .A(\pll_dig.flock.cnt_gray[9] ),
    .B(net119));
 sg13g2_xnor2_1 _2340_ (.Y(_1499_),
    .A(_0493_),
    .B(_1497_));
 sg13g2_o21ai_1 _2341_ (.B1(_1498_),
    .Y(_0372_),
    .A1(net120),
    .A2(_1499_));
 sg13g2_a21oi_1 _2342_ (.A1(_0896_),
    .A2(_1110_),
    .Y(_1500_),
    .B1(\pll_dig.ref_wd.cnt[7] ));
 sg13g2_and4_1 _2343_ (.A(\pll_dig.ref_wd.cnt[7] ),
    .B(_0895_),
    .C(_1110_),
    .D(_1298_),
    .X(_1501_));
 sg13g2_inv_1 _2344_ (.Y(_0562_),
    .A(\pll_dig.MID_MUX_D[4] ));
 sg13g2_nor3_1 _2345_ (.A(_0898_),
    .B(_1500_),
    .C(_1501_),
    .Y(_0370_));
 sg13g2_nand3_1 _2346_ (.B(net125),
    .C(net491),
    .A(\pll_dig.flock.cnt[9] ),
    .Y(_1502_));
 sg13g2_nor2_1 _2347_ (.A(net120),
    .B(net493),
    .Y(_1503_));
 sg13g2_xnor2_1 _2348_ (.Y(_0369_),
    .A(\pll_dig.flock.cnt[10] ),
    .B(_1502_));
 sg13g2_nor2_1 _2349_ (.A(\pll_dig.flock.cnt_gray[2] ),
    .B(net121),
    .Y(_1504_));
 sg13g2_xor2_1 _2350_ (.B(_1493_),
    .A(\pll_dig.flock.cnt[4] ),
    .X(_1505_));
 sg13g2_a21oi_1 _2351_ (.A1(net121),
    .A2(_1505_),
    .Y(_0368_),
    .B1(_1504_));
 sg13g2_nor2_1 _2352_ (.A(\pll_dig.flock.cnt_gray[10] ),
    .B(net123),
    .Y(_1506_));
 sg13g2_nand2_1 _2353_ (.Y(_1507_),
    .A(_0493_),
    .B(net493));
 sg13g2_xnor2_1 _2354_ (.Y(_1508_),
    .A(\pll_dig.flock.cnt[12] ),
    .B(_1507_));
 sg13g2_inv_1 _2355_ (.Y(_0563_),
    .A(\pll_dig.COARSE_MUX_D[5] ));
 sg13g2_a21oi_1 _2356_ (.A1(net123),
    .A2(_1508_),
    .Y(_0367_),
    .B1(_1506_));
 sg13g2_a21oi_1 _2357_ (.A1(_0558_),
    .A2(_0899_),
    .Y(_1509_),
    .B1(\pll_dig.ref_wd.cnt[0] ));
 sg13g2_a21oi_1 _2358_ (.A1(\pll_dig.ref_wd.cnt[0] ),
    .A2(_1298_),
    .Y(_0366_),
    .B1(_1509_));
 sg13g2_nand4_1 _2359_ (.B(\pll_dig.ref_wd.cnt[8] ),
    .C(_0895_),
    .A(\pll_dig.ref_wd.cnt[7] ),
    .Y(_1510_),
    .D(_1110_));
 sg13g2_nor2_1 _2360_ (.A(\pll_dig.ref_wd.cnt[9] ),
    .B(_1510_),
    .Y(_1511_));
 sg13g2_o21ai_1 _2361_ (.B1(_0899_),
    .Y(_1512_),
    .A1(\pll_dig.ref_wd.cnt[8] ),
    .A2(_1501_));
 sg13g2_nor2_1 _2362_ (.A(_1511_),
    .B(_1512_),
    .Y(_0365_));
 sg13g2_mux2_1 _2363_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .A1(net374),
    .S(net100),
    .X(_0364_));
 sg13g2_a221oi_1 _2364_ (.B2(\pll_dig.COARSE_MUX_D[2] ),
    .C1(net76),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[4] ),
    .Y(_1513_),
    .A2(net83));
 sg13g2_a21oi_1 _2365_ (.A1(_0553_),
    .A2(net76),
    .Y(_0363_),
    .B1(_1513_));
 sg13g2_inv_1 _2366_ (.Y(_0564_),
    .A(\pll_dig.flock.cnt_bin[0] ));
 sg13g2_a221oi_1 _2367_ (.B2(\pll_dig.COARSE_MUX_D[7] ),
    .C1(net74),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[9] ),
    .Y(_1514_),
    .A2(net83));
 sg13g2_a21oi_1 _2368_ (.A1(_0515_),
    .A2(net75),
    .Y(_0362_),
    .B1(_1514_));
 sg13g2_a221oi_1 _2369_ (.B2(\pll_dig.COARSE_MUX_D[12] ),
    .C1(net74),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[14] ),
    .Y(_1515_),
    .A2(net83));
 sg13g2_a21oi_1 _2370_ (.A1(_0495_),
    .A2(net74),
    .Y(_0361_),
    .B1(_1515_));
 sg13g2_a221oi_1 _2371_ (.B2(\pll_dig.MID_MUX_D[4] ),
    .C1(net70),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[2] ),
    .Y(_1516_),
    .A2(net88));
 sg13g2_a22oi_1 _2372_ (.Y(_0360_),
    .B1(net69),
    .B2(_1516_),
    .A2(net70),
    .A1(_0571_));
 sg13g2_a221oi_1 _2373_ (.B2(\pll_dig.MID_MUX_D[9] ),
    .C1(net71),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[7] ),
    .Y(_1517_),
    .A2(net87));
 sg13g2_a22oi_1 _2374_ (.Y(_0359_),
    .B1(net68),
    .B2(_1517_),
    .A2(net71),
    .A1(_0504_));
 sg13g2_a221oi_1 _2375_ (.B2(\pll_dig.MID_MUX_D[14] ),
    .C1(net70),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[12] ),
    .Y(_1518_),
    .A2(net87));
 sg13g2_a21oi_1 _2376_ (.A1(_0502_),
    .A2(net72),
    .Y(_0358_),
    .B1(_1518_));
 sg13g2_inv_1 _2377_ (.Y(_0565_),
    .A(net40));
 sg13g2_xnor2_1 _2378_ (.Y(_0357_),
    .A(net500),
    .B(net119));
 sg13g2_o21ai_1 _2379_ (.B1(_0572_),
    .Y(_0356_),
    .A1(net137),
    .A2(_1474_));
 sg13g2_a221oi_1 _2380_ (.B2(\pll_dig.MID_MUX_D[12] ),
    .C1(net72),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[10] ),
    .Y(_1519_),
    .A2(net87));
 sg13g2_a22oi_1 _2381_ (.Y(_0355_),
    .B1(net68),
    .B2(_1519_),
    .A2(net72),
    .A1(_0512_));
 sg13g2_a221oi_1 _2382_ (.B2(\pll_dig.COARSE_MUX_D[5] ),
    .C1(net76),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[7] ),
    .Y(_1520_),
    .A2(net84));
 sg13g2_a21oi_1 _2383_ (.A1(_0516_),
    .A2(net76),
    .Y(_0354_),
    .B1(_1520_));
 sg13g2_nand2_1 _2384_ (.Y(_1521_),
    .A(_0460_),
    .B(\pll_dig.flock.freq_miss[0] ));
 sg13g2_a21oi_1 _2385_ (.A1(_0561_),
    .A2(_1521_),
    .Y(_0353_),
    .B1(_0893_));
 sg13g2_o21ai_1 _2386_ (.B1(\pll_dig.COARSE_MUX_D[0] ),
    .Y(_1522_),
    .A1(\pll_dig.COARSE_MUX_D[2] ),
    .A2(_0659_));
 sg13g2_nand2_1 _2387_ (.Y(_1523_),
    .A(\pll_dig.COARSE_MUX_D[1] ),
    .B(net77));
 sg13g2_inv_1 _2388_ (.Y(_0566_),
    .A(\pll_dig.out_edges[7] ));
 sg13g2_o21ai_1 _2389_ (.B1(_1523_),
    .Y(_0352_),
    .A1(net77),
    .A2(_1522_));
 sg13g2_a21o_1 _2390_ (.A2(_0864_),
    .A1(\pll_dig.flock.cnt[5] ),
    .B1(\pll_dig.flock.cnt[6] ),
    .X(_1524_));
 sg13g2_and2_1 _2391_ (.A(_1015_),
    .B(_1524_),
    .X(_0351_));
 sg13g2_a221oi_1 _2392_ (.B2(\pll_dig.COARSE_MUX_D[10] ),
    .C1(net74),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[12] ),
    .Y(_1525_),
    .A2(net83));
 sg13g2_a21oi_1 _2393_ (.A1(_0496_),
    .A2(net74),
    .Y(_0350_),
    .B1(_1525_));
 sg13g2_nand3b_1 _2394_ (.B(_0672_),
    .C(\pll_dig.flock.cnt_coarse_wait[7] ),
    .Y(_1526_),
    .A_N(_0666_));
 sg13g2_nand2_1 _2395_ (.Y(_0020_),
    .A(net79),
    .B(_1526_));
 sg13g2_nand2b_1 _2396_ (.Y(_1527_),
    .B(_1441_),
    .A_N(_1440_));
 sg13g2_o21ai_1 _2397_ (.B1(net150),
    .Y(_1528_),
    .A1(_1456_),
    .A2(_1527_));
 sg13g2_a21oi_1 _2398_ (.A1(_1456_),
    .A2(_1527_),
    .Y(_0073_),
    .B1(_1528_));
 sg13g2_inv_1 _2399_ (.Y(_0567_),
    .A(net107));
 sg13g2_and3_1 _2400_ (.X(_1529_),
    .A(_1444_),
    .B(_1453_),
    .C(_1454_));
 sg13g2_nor3_1 _2401_ (.A(_0549_),
    .B(_1455_),
    .C(_1529_),
    .Y(_0072_));
 sg13g2_nor3_1 _2402_ (.A(_1445_),
    .B(_1451_),
    .C(_1452_),
    .Y(_1530_));
 sg13g2_nand2_1 _2403_ (.Y(_1531_),
    .A(net150),
    .B(_1453_));
 sg13g2_nor2_1 _2404_ (.A(_1530_),
    .B(_1531_),
    .Y(_0071_));
 sg13g2_xor2_1 _2405_ (.B(_0110_),
    .A(\pll_dig.flock.cnt_bin[14] ),
    .X(_1532_));
 sg13g2_o21ai_1 _2406_ (.B1(_1471_),
    .Y(_1533_),
    .A1(_1425_),
    .A2(_1467_));
 sg13g2_nand3_1 _2407_ (.B(_1532_),
    .C(_1533_),
    .A(_1470_),
    .Y(_1534_));
 sg13g2_a21o_1 _2408_ (.A2(_1533_),
    .A1(_1470_),
    .B1(_1532_),
    .X(_1535_));
 sg13g2_and3_1 _2409_ (.X(_0067_),
    .A(net151),
    .B(_1534_),
    .C(_1535_));
 sg13g2_inv_1 _2410_ (.Y(_0568_),
    .A(\pll_dig.dlf.INT[8] ));
 sg13g2_nor2_1 _2411_ (.A(_1432_),
    .B(_1433_),
    .Y(_1536_));
 sg13g2_o21ai_1 _2412_ (.B1(net151),
    .Y(_1537_),
    .A1(_1462_),
    .A2(_1536_));
 sg13g2_a21oi_1 _2413_ (.A1(_1462_),
    .A2(_1536_),
    .Y(_0062_),
    .B1(_1537_));
 sg13g2_o21ai_1 _2414_ (.B1(_1435_),
    .Y(_1538_),
    .A1(_1437_),
    .A2(_1460_));
 sg13g2_nand2_1 _2415_ (.Y(_1539_),
    .A(net151),
    .B(_1538_));
 sg13g2_nor2_1 _2416_ (.A(_1461_),
    .B(_1539_),
    .Y(_0076_));
 sg13g2_nand3_1 _2417_ (.B(_0674_),
    .C(net111),
    .A(\pll_dig.flock.cnt_err[5] ),
    .Y(_1540_));
 sg13g2_xnor2_1 _2418_ (.Y(_1541_),
    .A(\pll_dig.flock.cnt_err[5] ),
    .B(_0683_));
 sg13g2_o21ai_1 _2419_ (.B1(_1540_),
    .Y(_0034_),
    .A1(net80),
    .A2(_1541_));
 sg13g2_xnor2_1 _2420_ (.Y(_1542_),
    .A(\pll_dig.flock.cnt_coarse_wait[2] ),
    .B(_0661_));
 sg13g2_inv_1 _2421_ (.Y(_0456_),
    .A(\pll_dig.MID_MUX_D[12] ));
 sg13g2_inv_1 _2422_ (.Y(_0569_),
    .A(net44));
 sg13g2_o21ai_1 _2423_ (.B1(net79),
    .Y(_0015_),
    .A1(_0673_),
    .A2(_1542_));
 sg13g2_xor2_1 _2424_ (.B(\pll_dig.flock.cnt_coarse_wait[1] ),
    .A(\pll_dig.flock.cnt_coarse_wait[0] ),
    .X(_1543_));
 sg13g2_o21ai_1 _2425_ (.B1(net79),
    .Y(_0014_),
    .A1(_0673_),
    .A2(_1543_));
 sg13g2_o21ai_1 _2426_ (.B1(net79),
    .Y(_0013_),
    .A1(\pll_dig.flock.cnt_coarse_wait[0] ),
    .A2(_0673_));
 sg13g2_nand3_1 _2427_ (.B(\pll_dig.flock.cnt_err[6] ),
    .C(_0683_),
    .A(\pll_dig.flock.cnt_err[5] ),
    .Y(_1544_));
 sg13g2_xnor2_1 _2428_ (.Y(_1545_),
    .A(_0574_),
    .B(_1544_));
 sg13g2_nand3_1 _2429_ (.B(_0674_),
    .C(net111),
    .A(\pll_dig.flock.cnt_err[7] ),
    .Y(_1546_));
 sg13g2_o21ai_1 _2430_ (.B1(_1546_),
    .Y(_0036_),
    .A1(net80),
    .A2(_1545_));
 sg13g2_xor2_1 _2431_ (.B(_0662_),
    .A(\pll_dig.flock.cnt_coarse_wait[3] ),
    .X(_1547_));
 sg13g2_o21ai_1 _2432_ (.B1(net79),
    .Y(_0016_),
    .A1(_0673_),
    .A2(_1547_));
 sg13g2_inv_1 _2433_ (.Y(_0570_),
    .A(net33));
 sg13g2_xnor2_1 _2434_ (.Y(_1548_),
    .A(\pll_dig.flock.cnt_coarse_wait[4] ),
    .B(_0663_));
 sg13g2_o21ai_1 _2435_ (.B1(net79),
    .Y(_0017_),
    .A1(_0673_),
    .A2(_1548_));
 sg13g2_nand3_1 _2436_ (.B(_0674_),
    .C(net111),
    .A(\pll_dig.flock.cnt_err[6] ),
    .Y(_1549_));
 sg13g2_a21o_1 _2437_ (.A2(_0683_),
    .A1(\pll_dig.flock.cnt_err[5] ),
    .B1(\pll_dig.flock.cnt_err[6] ),
    .X(_1550_));
 sg13g2_nand2_1 _2438_ (.Y(_1551_),
    .A(_1544_),
    .B(_1550_));
 sg13g2_o21ai_1 _2439_ (.B1(_1549_),
    .Y(_0035_),
    .A1(net80),
    .A2(_1551_));
 sg13g2_o21ai_1 _2440_ (.B1(net150),
    .Y(_1552_),
    .A1(_1447_),
    .A2(_1448_));
 sg13g2_nor2b_1 _2441_ (.A(_1552_),
    .B_N(_1449_),
    .Y(_0069_));
 sg13g2_nand2_1 _2442_ (.Y(_1553_),
    .A(_0564_),
    .B(_0105_));
 sg13g2_a21oi_1 _2443_ (.A1(_1448_),
    .A2(_1553_),
    .Y(_0068_),
    .B1(_0549_));
 sg13g2_inv_1 _2444_ (.Y(_0571_),
    .A(\pll_dig.MID_MUX_D[3] ));
 sg13g2_and3_1 _2445_ (.X(_1554_),
    .A(_1446_),
    .B(_1449_),
    .C(_1450_));
 sg13g2_nor3_1 _2446_ (.A(_0549_),
    .B(_1451_),
    .C(_1554_),
    .Y(_0070_));
 sg13g2_o21ai_1 _2447_ (.B1(_1439_),
    .Y(_1555_),
    .A1(_1442_),
    .A2(_1457_));
 sg13g2_and2_1 _2448_ (.A(net150),
    .B(_1555_),
    .X(_1556_));
 sg13g2_nor2b_1 _2449_ (.A(_1458_),
    .B_N(_1556_),
    .Y(_0074_));
 sg13g2_nor2_1 _2450_ (.A(_1436_),
    .B(_1437_),
    .Y(_1557_));
 sg13g2_o21ai_1 _2451_ (.B1(net151),
    .Y(_1558_),
    .A1(_1459_),
    .A2(_1557_));
 sg13g2_a21oi_1 _2452_ (.A1(_1459_),
    .A2(_1557_),
    .Y(_0075_),
    .B1(_1558_));
 sg13g2_xor2_1 _2453_ (.B(_1476_),
    .A(\pll_dig.div_rst_cnt[0] ),
    .X(_0349_));
 sg13g2_nand3_1 _2454_ (.B(\pll_dig.div_rst_cnt[1] ),
    .C(_1476_),
    .A(\pll_dig.div_rst_cnt[0] ),
    .Y(_1559_));
 sg13g2_inv_1 _2455_ (.Y(_0572_),
    .A(\pll_dig.div_rst_cnt[3] ));
 sg13g2_xnor2_1 _2456_ (.Y(_0344_),
    .A(\pll_dig.div_rst_cnt[2] ),
    .B(_1559_));
 sg13g2_xnor2_1 _2457_ (.Y(_0125_),
    .A(_0453_),
    .B(_1398_));
 sg13g2_xnor2_1 _2458_ (.Y(_0122_),
    .A(_0556_),
    .B(_0697_));
 sg13g2_xnor2_1 _2459_ (.Y(_0100_),
    .A(net8),
    .B(_0699_));
 sg13g2_xnor2_1 _2460_ (.Y(_1560_),
    .A(_0798_),
    .B(net370));
 sg13g2_nor2_1 _2461_ (.A(net98),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .Y(_1561_));
 sg13g2_a21oi_1 _2462_ (.A1(net99),
    .A2(_1560_),
    .Y(_0343_),
    .B1(_1561_));
 sg13g2_and2_1 _2463_ (.A(net381),
    .B(net722),
    .X(_1562_));
 sg13g2_nor3_1 _2464_ (.A(net110),
    .B(_1245_),
    .C(_1562_),
    .Y(_1563_));
 sg13g2_a21o_1 _2465_ (.A2(net110),
    .A1(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .B1(_1563_),
    .X(_0342_));
 sg13g2_inv_1 _2466_ (.Y(_0573_),
    .A(\pll_dig.flock.cnt_filt[8] ));
 sg13g2_nor2_1 _2467_ (.A(net105),
    .B(_0789_),
    .Y(_1564_));
 sg13g2_a21oi_1 _2468_ (.A1(net105),
    .A2(_0576_),
    .Y(_0341_),
    .B1(_1564_));
 sg13g2_mux2_1 _2469_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .A1(net346),
    .S(net98),
    .X(_0340_));
 sg13g2_xnor2_1 _2470_ (.Y(_0006_),
    .A(\pll_dig.out_edges[7] ),
    .B(_1487_));
 sg13g2_nor2_1 _2471_ (.A(_1021_),
    .B(_1023_),
    .Y(\pll_dig.out_edges_next[3] ));
 sg13g2_xnor2_1 _2472_ (.Y(_0002_),
    .A(_0551_),
    .B(_1480_));
 sg13g2_nand2_1 _2473_ (.Y(_1565_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .B(net106));
 sg13g2_o21ai_1 _2474_ (.B1(_1565_),
    .Y(_0336_),
    .A1(net106),
    .A2(net351));
 sg13g2_xor2_1 _2475_ (.B(_1154_),
    .A(_1125_),
    .X(_1566_));
 sg13g2_nand2b_1 _2476_ (.Y(_1567_),
    .B(_1125_),
    .A_N(_1193_));
 sg13g2_inv_1 _2477_ (.Y(_0574_),
    .A(\pll_dig.flock.cnt_err[7] ));
 sg13g2_nand3b_1 _2478_ (.B(net64),
    .C(_1567_),
    .Y(_1568_),
    .A_N(_1194_));
 sg13g2_a21oi_1 _2479_ (.A1(net126),
    .A2(net996),
    .Y(_1569_),
    .B1(net116));
 sg13g2_a22oi_1 _2480_ (.Y(\pll_dig.dlf.OUT_C[8] ),
    .B1(_1568_),
    .B2(_1569_),
    .A2(_1566_),
    .A1(net61));
 sg13g2_xnor2_1 _2481_ (.Y(_1570_),
    .A(_1142_),
    .B(_1145_));
 sg13g2_xnor2_1 _2482_ (.Y(_1571_),
    .A(_1145_),
    .B(_1189_));
 sg13g2_nand2_1 _2483_ (.Y(_1572_),
    .A(net64),
    .B(_1571_));
 sg13g2_o21ai_1 _2484_ (.B1(_1179_),
    .Y(_1573_),
    .A1(\SS_BBPD[0] ),
    .A2(net978));
 sg13g2_a22oi_1 _2485_ (.Y(\pll_dig.dlf.OUT_C[5] ),
    .B1(_1572_),
    .B2(_1573_),
    .A2(_1570_),
    .A1(net61));
 sg13g2_and3_1 _2486_ (.X(net56),
    .A(\pll_dig.u_ddr_ck.ck_en ),
    .B(clknet_1_1__leaf_net60),
    .C(net58));
 sg13g2_nor2b_1 _2487_ (.A(\pll_dig.clr_r2 ),
    .B_N(\pll_dig.clr_r3 ),
    .Y(_1574_));
 sg13g2_inv_1 _2488_ (.Y(_0575_),
    .A(net28));
 sg13g2_o21ai_1 _2489_ (.B1(\pll_dig.ref_fail ),
    .Y(_1575_),
    .A1(_0540_),
    .A2(\pll_dig.clr_r3 ));
 sg13g2_o21ai_1 _2490_ (.B1(_0483_),
    .Y(_0335_),
    .A1(_1574_),
    .A2(_1575_));
 sg13g2_a221oi_1 _2491_ (.B2(_0467_),
    .C1(_1037_),
    .B1(_1041_),
    .A1(_0560_),
    .Y(_0334_),
    .A2(_1038_));
 sg13g2_mux2_1 _2492_ (.A0(_0128_),
    .A1(_0132_),
    .S(net420),
    .X(_0332_));
 sg13g2_mux2_1 _2493_ (.A0(\pll_dig.div.div_pend[3] ),
    .A1(net145),
    .S(net420),
    .X(_0331_));
 sg13g2_mux2_1 _2494_ (.A0(\pll_dig.div.div_pend[5] ),
    .A1(net142),
    .S(net425),
    .X(_0330_));
 sg13g2_mux2_1 _2495_ (.A0(\pll_dig.div.div_pend[7] ),
    .A1(\pll_dig.div.div[7] ),
    .S(net90),
    .X(_0329_));
 sg13g2_and2_1 _2496_ (.A(net115),
    .B(_1175_),
    .X(\pll_dig.dlf.ILL_P_C ));
 sg13g2_xnor2_1 _2497_ (.Y(_1576_),
    .A(_1119_),
    .B(_1172_));
 sg13g2_xnor2_1 _2498_ (.Y(_1577_),
    .A(_1118_),
    .B(_1201_));
 sg13g2_inv_1 _2499_ (.Y(_0576_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[4] ));
 sg13g2_a21oi_1 _2500_ (.A1(net64),
    .A2(_1577_),
    .Y(_1578_),
    .B1(net115));
 sg13g2_a21o_1 _2501_ (.A2(_1576_),
    .A1(net61),
    .B1(_1578_),
    .X(_1579_));
 sg13g2_o21ai_1 _2502_ (.B1(_1579_),
    .Y(\pll_dig.dlf.OUT_C[14] ),
    .A1(\SS_BBPD[0] ),
    .A2(_0520_));
 sg13g2_nand3_1 _2503_ (.B(_1122_),
    .C(_1165_),
    .A(_1121_),
    .Y(_1580_));
 sg13g2_nand2b_1 _2504_ (.Y(_1581_),
    .B(_1580_),
    .A_N(_1166_));
 sg13g2_nand3_1 _2505_ (.B(_1180_),
    .C(_1198_),
    .A(_1120_),
    .Y(_1582_));
 sg13g2_nand3b_1 _2506_ (.B(net64),
    .C(_1582_),
    .Y(_1583_),
    .A_N(_1199_));
 sg13g2_a21oi_1 _2507_ (.A1(net126),
    .A2(net998),
    .Y(_1584_),
    .B1(net115));
 sg13g2_a22oi_1 _2508_ (.Y(\pll_dig.dlf.OUT_C[12] ),
    .B1(_1583_),
    .B2(_1584_),
    .A2(_1581_),
    .A1(net61));
 sg13g2_o21ai_1 _2509_ (.B1(_0833_),
    .Y(\pll_dig.FINE_MUX_D[8] ),
    .A1(net95),
    .A2(_1372_));
 sg13g2_inv_1 _2510__343 (.Y(net342),
    .A(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_a21o_1 _2511_ (.A2(net119),
    .A1(net501),
    .B1(_1494_),
    .X(_0328_));
 sg13g2_a21oi_1 _2512_ (.A1(\pll_dig.MID_MUX_D[13] ),
    .A2(_0847_),
    .Y(_1585_),
    .B1(\pll_dig.MID_MUX_D[14] ));
 sg13g2_nor2_1 _2513_ (.A(net88),
    .B(_0844_),
    .Y(_1586_));
 sg13g2_a21oi_1 _2514_ (.A1(_0847_),
    .A2(_1586_),
    .Y(_0327_),
    .B1(_1585_));
 sg13g2_o21ai_1 _2515_ (.B1(_0491_),
    .Y(_1587_),
    .A1(_0495_),
    .A2(_0838_));
 sg13g2_and2_1 _2516_ (.A(net69),
    .B(_1587_),
    .X(_0326_));
 sg13g2_a21oi_1 _2517_ (.A1(\pll_dig.ref_wd.cnt[0] ),
    .A2(_1298_),
    .Y(_1588_),
    .B1(\pll_dig.ref_wd.cnt[1] ));
 sg13g2_nor3_1 _2518_ (.A(_0898_),
    .B(_1306_),
    .C(_1588_),
    .Y(_0325_));
 sg13g2_xnor2_1 _2519_ (.Y(_0324_),
    .A(_0493_),
    .B(_1503_));
 sg13g2_a221oi_1 _2520_ (.B2(\pll_dig.MID_MUX_D[10] ),
    .C1(net72),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[8] ),
    .Y(_1589_),
    .A2(net87));
 sg13g2_inv_1 _2521_ (.Y(_0577_),
    .A(\pll_dig.PHASE_LOCK ));
 sg13g2_a22oi_1 _2522_ (.Y(_0323_),
    .B1(net69),
    .B2(_1589_),
    .A2(net72),
    .A1(_0514_));
 sg13g2_a221oi_1 _2523_ (.B2(\pll_dig.COARSE_MUX_D[8] ),
    .C1(net75),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[10] ),
    .Y(_1590_),
    .A2(net83));
 sg13g2_a21oi_1 _2524_ (.A1(_0506_),
    .A2(net75),
    .Y(_0322_),
    .B1(_1590_));
 sg13g2_a221oi_1 _2525_ (.B2(\pll_dig.MID_MUX_D[11] ),
    .C1(net72),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[9] ),
    .Y(_1591_),
    .A2(net87));
 sg13g2_a22oi_1 _2526_ (.Y(_0321_),
    .B1(net69),
    .B2(_1591_),
    .A2(net72),
    .A1(_0513_));
 sg13g2_a221oi_1 _2527_ (.B2(\pll_dig.COARSE_MUX_D[9] ),
    .C1(net74),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[11] ),
    .Y(_1592_),
    .A2(net83));
 sg13g2_a21oi_1 _2528_ (.A1(_0505_),
    .A2(net75),
    .Y(_0320_),
    .B1(_1592_));
 sg13g2_nor2_1 _2529_ (.A(\pll_dig.flock.cnt_gray[11] ),
    .B(net123),
    .Y(_1593_));
 sg13g2_nor2_1 _2530_ (.A(\pll_dig.flock.cnt[12] ),
    .B(net496),
    .Y(_1594_));
 sg13g2_xor2_1 _2531_ (.B(_1594_),
    .A(\pll_dig.flock.cnt[13] ),
    .X(_1595_));
 sg13g2_inv_1 _2532_ (.Y(_0457_),
    .A(\pll_dig.flock.cnt_done[2] ));
 sg13g2_inv_1 _2533_ (.Y(\pll_dig.dsm_impl.u_dsm_icg.EN ),
    .A(\pll_dig.dsm_impl.locked_dsm_s2 ));
 sg13g2_a21oi_1 _2534_ (.A1(net123),
    .A2(_1595_),
    .Y(_0319_),
    .B1(_1593_));
 sg13g2_a21o_1 _2535_ (.A2(net119),
    .A1(net499),
    .B1(_1492_),
    .X(_0318_));
 sg13g2_a221oi_1 _2536_ (.B2(\pll_dig.MID_MUX_D[5] ),
    .C1(net70),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[3] ),
    .Y(_1596_),
    .A2(net88));
 sg13g2_a22oi_1 _2537_ (.Y(_0317_),
    .B1(net68),
    .B2(_1596_),
    .A2(net70),
    .A1(_0562_));
 sg13g2_a221oi_1 _2538_ (.B2(\pll_dig.COARSE_MUX_D[3] ),
    .C1(net77),
    .B1(net82),
    .A1(\pll_dig.COARSE_MUX_D[5] ),
    .Y(_1597_),
    .A2(net84));
 sg13g2_a21oi_1 _2539_ (.A1(_0554_),
    .A2(net77),
    .Y(_0316_),
    .B1(_1597_));
 sg13g2_a21oi_1 _2540_ (.A1(\pll_dig.flock.cnt[4] ),
    .A2(net494),
    .Y(_1598_),
    .B1(\pll_dig.flock.cnt[5] ));
 sg13g2_nand2_1 _2541_ (.Y(_1599_),
    .A(\pll_dig.flock.cnt_gray[4] ),
    .B(net119));
 sg13g2_xor2_1 _2542_ (.B(_1598_),
    .A(\pll_dig.flock.cnt[6] ),
    .X(_1600_));
 sg13g2_o21ai_1 _2543_ (.B1(_1599_),
    .Y(_0315_),
    .A1(net119),
    .A2(_1600_));
 sg13g2_inv_1 _2544__342 (.Y(net341),
    .A(clknet_3_0__leaf_MID_OUT));
 sg13g2_a221oi_1 _2545_ (.B2(\pll_dig.MID_MUX_D[6] ),
    .C1(net71),
    .B1(net85),
    .A1(\pll_dig.MID_MUX_D[4] ),
    .Y(_1601_),
    .A2(net87));
 sg13g2_a22oi_1 _2546_ (.Y(_0314_),
    .B1(net68),
    .B2(_1601_),
    .A2(net71),
    .A1(_0503_));
 sg13g2_a221oi_1 _2547_ (.B2(\pll_dig.COARSE_MUX_D[4] ),
    .C1(net76),
    .B1(net82),
    .A1(\pll_dig.COARSE_MUX_D[6] ),
    .Y(_1602_),
    .A2(net84));
 sg13g2_a21oi_1 _2548_ (.A1(_0563_),
    .A2(net76),
    .Y(_0313_),
    .B1(_1602_));
 sg13g2_a21oi_1 _2549_ (.A1(_0558_),
    .A2(_1510_),
    .Y(_0312_),
    .B1(_0898_));
 sg13g2_nor2_1 _2550_ (.A(\pll_dig.flock.cnt_gray[3] ),
    .B(net121),
    .Y(_1603_));
 sg13g2_xor2_1 _2551_ (.B(_0865_),
    .A(\pll_dig.flock.cnt[5] ),
    .X(_1604_));
 sg13g2_a21oi_1 _2552_ (.A1(net121),
    .A2(_1604_),
    .Y(_0311_),
    .B1(_1603_));
 sg13g2_or2_1 _2553_ (.X(_0310_),
    .B(\pll_dig.flock.started ),
    .A(\pll_dig.START ));
 sg13g2_a21oi_1 _2554_ (.A1(_0660_),
    .A2(_0845_),
    .Y(_1605_),
    .B1(_0492_));
 sg13g2_inv_1 _2555_ (.Y(_0578_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[5] ));
 sg13g2_a221oi_1 _2556_ (.B2(\pll_dig.MID_MUX_D[14] ),
    .C1(net70),
    .B1(_0840_),
    .A1(_0579_),
    .Y(_1606_),
    .A2(net86));
 sg13g2_or2_1 _2557_ (.X(_0309_),
    .B(_1606_),
    .A(_1605_));
 sg13g2_nand3_1 _2558_ (.B(_0836_),
    .C(_0839_),
    .A(_0660_),
    .Y(_1607_));
 sg13g2_a21oi_1 _2559_ (.A1(\pll_dig.COARSE_MUX_D[0] ),
    .A2(\pll_dig.COARSE_MUX_D[1] ),
    .Y(_1608_),
    .B1(_0659_));
 sg13g2_a22oi_1 _2560_ (.Y(_0308_),
    .B1(_1608_),
    .B2(_0836_),
    .A2(_1607_),
    .A1(_0469_));
 sg13g2_nor2b_1 _2561_ (.A(net997),
    .B_N(\pll_dig.FREQ_LOCKED ),
    .Y(_1609_));
 sg13g2_a21o_1 _2562_ (.A2(_1405_),
    .A1(_1314_),
    .B1(_1609_),
    .X(_0012_));
 sg13g2_a21o_1 _2563_ (.A2(_1476_),
    .A1(\pll_dig.div_rst_cnt[0] ),
    .B1(\pll_dig.div_rst_cnt[1] ),
    .X(_1610_));
 sg13g2_and2_1 _2564_ (.A(_1559_),
    .B(_1610_),
    .X(_0306_));
 sg13g2_o21ai_1 _2565_ (.B1(net95),
    .Y(\pll_dig.FINE_MUX_D[4] ),
    .A1(_0482_),
    .A2(_1372_));
 sg13g2_inv_1 _2566__344 (.Y(net343),
    .A(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_nand2_1 _2567_ (.Y(\pll_dig.FINE_MUX_D[2] ),
    .A(_1370_),
    .B(_1424_));
 sg13g2_nand2_1 _2568_ (.Y(\pll_dig.FINE_MUX_D[1] ),
    .A(_0832_),
    .B(_1368_));
 sg13g2_xnor2_1 _2569_ (.Y(_1611_),
    .A(\pll_dig.flock.cnt_coarse_wait[5] ),
    .B(_0664_));
 sg13g2_o21ai_1 _2570_ (.B1(net79),
    .Y(_0018_),
    .A1(_0673_),
    .A2(_1611_));
 sg13g2_nand2_1 _2571_ (.Y(_1612_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .B(_1315_));
 sg13g2_o21ai_1 _2572_ (.B1(_1359_),
    .Y(_1613_),
    .A1(net893),
    .A2(_1351_));
 sg13g2_xnor2_1 _2573_ (.Y(_1614_),
    .A(\pll_dig.flock.cnt_done[3] ),
    .B(_1613_));
 sg13g2_o21ai_1 _2574_ (.B1(_1612_),
    .Y(_0024_),
    .A1(_1358_),
    .A2(_1614_));
 sg13g2_nand2_1 _2575_ (.Y(_1615_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .B(net108));
 sg13g2_o21ai_1 _2576_ (.B1(_1615_),
    .Y(_0305_),
    .A1(net108),
    .A2(_0818_));
 sg13g2_inv_1 _2577_ (.Y(_0579_),
    .A(\pll_dig.MID_MUX_D[1] ));
 sg13g2_mux2_1 _2578_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .A1(_1221_),
    .S(net100),
    .X(_0304_));
 sg13g2_nor2_1 _2579_ (.A(net849),
    .B(_0910_),
    .Y(_1616_));
 sg13g2_xnor2_1 _2580_ (.Y(_0145_),
    .A(net867),
    .B(_1616_));
 sg13g2_xor2_1 _2581_ (.B(_0982_),
    .A(net888),
    .X(_0149_));
 sg13g2_nor2_1 _2582_ (.A(_0921_),
    .B(net840),
    .Y(_1617_));
 sg13g2_xor2_1 _2583_ (.B(net841),
    .A(net1052),
    .X(_0143_));
 sg13g2_xnor2_1 _2584_ (.Y(_0144_),
    .A(net862),
    .B(_1009_));
 sg13g2_o21ai_1 _2585_ (.B1(net824),
    .Y(_0139_),
    .A1(_0904_),
    .A2(_1014_));
 sg13g2_nand2_1 _2586_ (.Y(_1618_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B(net104));
 sg13g2_o21ai_1 _2587_ (.B1(_1618_),
    .Y(_0302_),
    .A1(net104),
    .A2(net352));
 sg13g2_inv_1 _2588_ (.Y(_0580_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[6] ));
 sg13g2_a21o_1 _2589_ (.A2(net105),
    .A1(\pll_dig.dsm_impl.dsm.dff_err2[0] ),
    .B1(_1384_),
    .X(_0301_));
 sg13g2_a21o_1 _2590_ (.A2(net6),
    .A1(net5),
    .B1(net7),
    .X(_1619_));
 sg13g2_and2_1 _2591_ (.A(_0699_),
    .B(_1619_),
    .X(_0099_));
 sg13g2_xnor2_1 _2592_ (.Y(_1620_),
    .A(_0800_),
    .B(_0802_));
 sg13g2_mux2_1 _2593_ (.A0(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .A1(_1620_),
    .S(net99),
    .X(_0300_));
 sg13g2_nor2_1 _2594_ (.A(net106),
    .B(net347),
    .Y(_1621_));
 sg13g2_a21oi_1 _2595_ (.A1(net106),
    .A2(_0578_),
    .Y(_0299_),
    .B1(_1621_));
 sg13g2_nor2_1 _2596_ (.A(net917),
    .B(net929),
    .Y(_1622_));
 sg13g2_and2_1 _2597_ (.A(\SS_BBPD[0] ),
    .B(_1622_),
    .X(_1623_));
 sg13g2_a21oi_1 _2598_ (.A1(\SS_BBPD[1] ),
    .A2(_1623_),
    .Y(_1624_),
    .B1(\pll_dig.lock_detector.seen_n ));
 sg13g2_inv_1 _2599_ (.Y(_0581_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[5] ));
 sg13g2_nand2_1 _2600_ (.Y(_1625_),
    .A(\SS_BBPD[0] ),
    .B(net940));
 sg13g2_nand3b_1 _2601_ (.B(_1623_),
    .C(\pll_dig.ENABLE ),
    .Y(_1626_),
    .A_N(net924));
 sg13g2_and3_1 _2602_ (.X(_1627_),
    .A(net943),
    .B(net922),
    .C(net914));
 sg13g2_a21o_1 _2603_ (.A2(_1627_),
    .A1(net949),
    .B1(net925),
    .X(_1628_));
 sg13g2_nor2_1 _2604_ (.A(_1624_),
    .B(_1628_),
    .Y(_0055_));
 sg13g2_xnor2_1 _2605_ (.Y(_0150_),
    .A(net1069),
    .B(net884));
 sg13g2_nand2b_1 _2606_ (.Y(_1629_),
    .B(net934),
    .A_N(net963));
 sg13g2_nor2b_1 _2607_ (.A(net912),
    .B_N(\pll_dig.FREQ_OK ),
    .Y(_1630_));
 sg13g2_nand2_1 _2608_ (.Y(_1631_),
    .A(net992),
    .B(_1630_));
 sg13g2_nor2_1 _2609_ (.A(_1629_),
    .B(_1631_),
    .Y(_1632_));
 sg13g2_inv_1 _2610_ (.Y(_0582_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[7] ));
 sg13g2_inv_1 _2611_ (.Y(_1633_),
    .A(_1632_));
 sg13g2_nor2b_1 _2612_ (.A(net963),
    .B_N(_1630_),
    .Y(_1634_));
 sg13g2_nand2b_1 _2613_ (.Y(_1635_),
    .B(_1630_),
    .A_N(net963));
 sg13g2_nand2_1 _2614_ (.Y(_1636_),
    .A(\pll_dig.state[2] ),
    .B(_1634_));
 sg13g2_nor2b_1 _2615_ (.A(net955),
    .B_N(net926),
    .Y(_1637_));
 sg13g2_nor2_1 _2616_ (.A(net975),
    .B(\pll_dig.cnt[4] ),
    .Y(_1638_));
 sg13g2_nor4_1 _2617_ (.A(net944),
    .B(net950),
    .C(net953),
    .D(net958),
    .Y(_1639_));
 sg13g2_nand4_1 _2618_ (.B(_1637_),
    .C(net976),
    .A(net934),
    .Y(_1640_),
    .D(_1639_));
 sg13g2_o21ai_1 _2619_ (.B1(_1633_),
    .Y(_0050_),
    .A1(_1636_),
    .A2(_1640_));
 sg13g2_xnor2_1 _2620_ (.Y(_0141_),
    .A(net1055),
    .B(net828));
 sg13g2_inv_1 _2621_ (.Y(_0583_),
    .A(net42));
 sg13g2_mux2_1 _2622_ (.A0(\pll_dig.div.div_pend[6] ),
    .A1(net54),
    .S(net234),
    .X(_0297_));
 sg13g2_mux2_1 _2623_ (.A0(\pll_dig.div.use_clk_p ),
    .A1(\pll_dig.div.use_clk ),
    .S(net128),
    .X(_0296_));
 sg13g2_nand2_1 _2624_ (.Y(_1641_),
    .A(_1227_),
    .B(_1231_));
 sg13g2_nand4_1 _2625_ (.B(net99),
    .C(net1),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .Y(_1642_),
    .D(_1641_));
 sg13g2_nor3_1 _2626_ (.A(net104),
    .B(net2),
    .C(_1642_),
    .Y(_1643_));
 sg13g2_a21o_1 _2627_ (.A2(\pll_dig.dsm_impl.dsm.cin_stg1 ),
    .A1(net104),
    .B1(_1643_),
    .X(_0292_));
 sg13g2_nand2_1 _2628_ (.Y(_1644_),
    .A(net99),
    .B(net2));
 sg13g2_nand2_1 _2629_ (.Y(_1645_),
    .A(net104),
    .B(\pll_dig.dsm_impl.dsm.cin_stg2 ));
 sg13g2_o21ai_1 _2630_ (.B1(_1645_),
    .Y(_0290_),
    .A1(_1642_),
    .A2(_1644_));
 sg13g2_nand2_1 _2631_ (.Y(_1646_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .B(net110));
 sg13g2_inv_1 _2632_ (.Y(_0584_),
    .A(\pll_dig.flock.FCW_PA[2] ));
 sg13g2_o21ai_1 _2633_ (.B1(_1646_),
    .Y(_0289_),
    .A1(net110),
    .A2(_1225_));
 sg13g2_mux2_1 _2634_ (.A0(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .A1(net553),
    .S(net100),
    .X(_0288_));
 sg13g2_nor2_1 _2635_ (.A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .B(net100),
    .Y(_1647_));
 sg13g2_a21oi_1 _2636_ (.A1(net100),
    .A2(net356),
    .Y(_0287_),
    .B1(_1647_));
 sg13g2_a21o_1 _2637_ (.A2(net424),
    .A1(\pll_dig.div.pend ),
    .B1(net234),
    .X(_0285_));
 sg13g2_nor2_1 _2638_ (.A(net110),
    .B(net345),
    .Y(_1648_));
 sg13g2_a21oi_1 _2639_ (.A1(_0458_),
    .A2(net110),
    .Y(_0284_),
    .B1(_1648_));
 sg13g2_nand2_1 _2640_ (.Y(_1649_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .B(net110));
 sg13g2_o21ai_1 _2641_ (.B1(_1649_),
    .Y(_0282_),
    .A1(net110),
    .A2(net383));
 sg13g2_nor2_1 _2642_ (.A(\pll_dig.div.enter_req ),
    .B(_1100_),
    .Y(_1650_));
 sg13g2_inv_1 _2643__290 (.Y(net289),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _2644_ (.Y(_0585_),
    .A(\pll_dig.flock.FCW_PA[7] ));
 sg13g2_nor2_1 _2645_ (.A(\pll_dig.div.use_clk_p ),
    .B(_1650_),
    .Y(_0278_));
 sg13g2_mux2_1 _2646_ (.A0(\pll_dig.div.div_pend[7] ),
    .A1(net55),
    .S(net234),
    .X(_0275_));
 sg13g2_a21oi_1 _2647_ (.A1(\pll_dig.div.pend ),
    .A2(_1099_),
    .Y(_1651_),
    .B1(\pll_dig.div.leave_req ));
 sg13g2_nor2b_1 _2648_ (.A(_1651_),
    .B_N(\pll_dig.div.use_clk_p ),
    .Y(_0274_));
 sg13g2_nor2_1 _2649_ (.A(_1179_),
    .B(_1205_),
    .Y(\pll_dig.dlf.ILL_N_C ));
 sg13g2_nand2_1 _2650_ (.Y(_1652_),
    .A(\pll_dig.state[3] ),
    .B(_1412_));
 sg13g2_a21oi_1 _2651_ (.A1(\pll_dig.FREQ_OK ),
    .A2(_1609_),
    .Y(_1653_),
    .B1(_1652_));
 sg13g2_nor2b_1 _2652_ (.A(net911),
    .B_N(net944),
    .Y(_1654_));
 sg13g2_nor2_1 _2653_ (.A(net992),
    .B(net983),
    .Y(_1655_));
 sg13g2_nor2_1 _2654_ (.A(_1630_),
    .B(_1655_),
    .Y(_1656_));
 sg13g2_inv_1 _2655_ (.Y(_0586_),
    .A(\pll_dig.flock.FCW_PA[6] ));
 sg13g2_or3_1 _2656_ (.A(_1653_),
    .B(_1654_),
    .C(_1656_),
    .X(_0049_));
 sg13g2_nor2_1 _2657_ (.A(\pll_dig.lock_detector.win_cnt[0] ),
    .B(net925),
    .Y(_0057_));
 sg13g2_xnor2_1 _2658_ (.Y(_1657_),
    .A(net922),
    .B(\pll_dig.lock_detector.win_cnt[1] ));
 sg13g2_nor2_1 _2659_ (.A(_1626_),
    .B(_1657_),
    .Y(_0058_));
 sg13g2_a21oi_1 _2660_ (.A1(_0463_),
    .A2(_1623_),
    .Y(_1658_),
    .B1(\pll_dig.lock_detector.seen_p ));
 sg13g2_nor2_1 _2661_ (.A(_1628_),
    .B(_1658_),
    .Y(_0056_));
 sg13g2_nor2_1 _2662_ (.A(\pll_dig.lock_detector.win_cnt[3] ),
    .B(_1627_),
    .Y(_1659_));
 sg13g2_nor2_1 _2663_ (.A(_1628_),
    .B(_1659_),
    .Y(_0060_));
 sg13g2_a21oi_1 _2664_ (.A1(\pll_dig.lock_detector.win_cnt[0] ),
    .A2(net914),
    .Y(_1660_),
    .B1(\pll_dig.lock_detector.win_cnt[2] ));
 sg13g2_nor3_1 _2665_ (.A(_1626_),
    .B(_1627_),
    .C(net915),
    .Y(_0059_));
 sg13g2_inv_1 _2666_ (.Y(_0587_),
    .A(\pll_dig.div.pcnt[6] ));
 sg13g2_nand2_1 _2667_ (.Y(_1661_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(net107));
 sg13g2_o21ai_1 _2668_ (.B1(_1661_),
    .Y(_0272_),
    .A1(net107),
    .A2(_0742_));
 sg13g2_mux2_1 _2669_ (.A0(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .A1(net353),
    .S(net99),
    .X(_0271_));
 sg13g2_nor2_1 _2670_ (.A(net106),
    .B(_0785_),
    .Y(_1662_));
 sg13g2_a21oi_1 _2671_ (.A1(net106),
    .A2(_0580_),
    .Y(_0270_),
    .B1(_1662_));
 sg13g2_mux2_1 _2672_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .A1(net350),
    .S(net98),
    .X(_0269_));
 sg13g2_nand2_1 _2673_ (.Y(_1663_),
    .A(net369),
    .B(net376));
 sg13g2_a21oi_1 _2674_ (.A1(_0805_),
    .A2(_1663_),
    .Y(_1664_),
    .B1(net109));
 sg13g2_a21oi_1 _2675_ (.A1(net109),
    .A2(_0581_),
    .Y(_0268_),
    .B1(_1664_));
 sg13g2_xor2_1 _2676_ (.B(_0808_),
    .A(_0806_),
    .X(_1665_));
 sg13g2_inv_1 _2677_ (.Y(_0588_),
    .A(\pll_dig.div.pcnt[5] ));
 sg13g2_nor2_1 _2678_ (.A(net101),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .Y(_1666_));
 sg13g2_a21oi_1 _2679_ (.A1(net101),
    .A2(_1665_),
    .Y(_0267_),
    .B1(_1666_));
 sg13g2_nor2_1 _2680_ (.A(net107),
    .B(net349),
    .Y(_1667_));
 sg13g2_a21oi_1 _2681_ (.A1(net107),
    .A2(_0582_),
    .Y(_0266_),
    .B1(_1667_));
 sg13g2_nand2b_1 _2682_ (.Y(_1668_),
    .B(\pll_dig.flock.freq_miss[2] ),
    .A_N(\pll_dig.flock.freq_miss[0] ));
 sg13g2_o21ai_1 _2683_ (.B1(_1668_),
    .Y(_1669_),
    .A1(\pll_dig.flock.freq_miss[1] ),
    .A2(_1521_));
 sg13g2_nor2_1 _2684_ (.A(_0893_),
    .B(_1669_),
    .Y(_0265_));
 sg13g2_nor2b_1 _2685_ (.A(_1412_),
    .B_N(\pll_dig.flock.u_fll_icg.EN ),
    .Y(_1670_));
 sg13g2_a21o_1 _2686_ (.A2(_1670_),
    .A1(net932),
    .B1(\pll_dig.state[1] ),
    .X(_0047_));
 sg13g2_nand2b_1 _2687_ (.Y(_1671_),
    .B(net940),
    .A_N(net947));
 sg13g2_inv_1 _2688_ (.Y(_0589_),
    .A(net797));
 sg13g2_a221oi_1 _2689_ (.B2(\SS_BBPD[0] ),
    .C1(_1671_),
    .B1(_1622_),
    .A1(\pll_dig.lock_detector.bad_cnt[1] ),
    .Y(_1672_),
    .A2(net920));
 sg13g2_nor2b_1 _2690_ (.A(\pll_dig.lock_detector.bad_cnt[0] ),
    .B_N(net948),
    .Y(_0052_));
 sg13g2_nand3_1 _2691_ (.B(_1634_),
    .C(_1640_),
    .A(net983),
    .Y(_1673_));
 sg13g2_nand3_1 _2692_ (.B(net932),
    .C(_1609_),
    .A(\pll_dig.FREQ_OK ),
    .Y(_1674_));
 sg13g2_nand3_1 _2693_ (.B(net963),
    .C(_1630_),
    .A(\pll_dig.state[2] ),
    .Y(_1675_));
 sg13g2_nand3_1 _2694_ (.B(_1629_),
    .C(_1630_),
    .A(\pll_dig.state[4] ),
    .Y(_1676_));
 sg13g2_nand4_1 _2695_ (.B(_1674_),
    .C(_1675_),
    .A(_1673_),
    .Y(_0048_),
    .D(_1676_));
 sg13g2_o21ai_1 _2696_ (.B1(_1672_),
    .Y(_1677_),
    .A1(\pll_dig.lock_detector.bad_cnt[1] ),
    .A2(net920));
 sg13g2_inv_1 _2697_ (.Y(_0053_),
    .A(net921));
 sg13g2_xnor2_1 _2698_ (.Y(_1678_),
    .A(_1152_),
    .B(_1192_));
 sg13g2_inv_1 _2699_ (.Y(_0590_),
    .A(\pll_dig.div.cnt[3] ));
 sg13g2_nand2_1 _2700_ (.Y(_1679_),
    .A(net65),
    .B(_1678_));
 sg13g2_o21ai_1 _2701_ (.B1(_1179_),
    .Y(_1680_),
    .A1(\SS_BBPD[0] ),
    .A2(net993));
 sg13g2_xnor2_1 _2702_ (.Y(_1681_),
    .A(_1149_),
    .B(_1152_));
 sg13g2_a22oi_1 _2703_ (.Y(\pll_dig.dlf.OUT_C[7] ),
    .B1(_1681_),
    .B2(net62),
    .A2(_1680_),
    .A1(_1679_));
 sg13g2_xor2_1 _2704_ (.B(_1147_),
    .A(_1126_),
    .X(_1682_));
 sg13g2_nand2b_1 _2705_ (.Y(_1683_),
    .B(_1126_),
    .A_N(_1190_));
 sg13g2_nand3b_1 _2706_ (.B(net65),
    .C(_1683_),
    .Y(_1684_),
    .A_N(_1191_));
 sg13g2_a21oi_1 _2707_ (.A1(net126),
    .A2(net982),
    .Y(_1685_),
    .B1(net116));
 sg13g2_a22oi_1 _2708_ (.Y(\pll_dig.dlf.OUT_C[6] ),
    .B1(_1684_),
    .B2(_1685_),
    .A2(_1682_),
    .A1(net62));
 sg13g2_xor2_1 _2709_ (.B(_1140_),
    .A(_1127_),
    .X(_1686_));
 sg13g2_inv_1 _2710_ (.Y(\pll_dig.FILTER_OUT[15] ),
    .A(net1044));
 sg13g2_nand2b_1 _2711_ (.Y(_1687_),
    .B(_1127_),
    .A_N(_1187_));
 sg13g2_nand3b_1 _2712_ (.B(net65),
    .C(_1687_),
    .Y(_1688_),
    .A_N(_1188_));
 sg13g2_a21oi_1 _2713_ (.A1(net127),
    .A2(net973),
    .Y(_1689_),
    .B1(net116));
 sg13g2_a22oi_1 _2714_ (.Y(\pll_dig.dlf.OUT_C[4] ),
    .B1(_1688_),
    .B2(_1689_),
    .A2(_1686_),
    .A1(net62));
 sg13g2_a21oi_1 _2715_ (.A1(_1370_),
    .A2(_1376_),
    .Y(\pll_dig.FINE_MUX_D[18] ),
    .B1(_0454_));
 sg13g2_nand2_1 _2716_ (.Y(_1690_),
    .A(\pll_dig.flock.cnt_done[1] ),
    .B(_1315_));
 sg13g2_nor2_1 _2717_ (.A(_1349_),
    .B(_1352_),
    .Y(_1691_));
 sg13g2_xor2_1 _2718_ (.B(_1691_),
    .A(net893),
    .X(_1692_));
 sg13g2_o21ai_1 _2719_ (.B1(_1690_),
    .Y(_0022_),
    .A1(_1358_),
    .A2(net894));
 sg13g2_xnor2_1 _2720_ (.Y(_0142_),
    .A(_1004_),
    .B(net832));
 sg13g2_inv_1 _2721_ (.Y(_0220_),
    .A(net1048));
 sg13g2_nand2_1 _2722_ (.Y(_1693_),
    .A(\pll_dig.flock.cnt_done[0] ),
    .B(_1315_));
 sg13g2_o21ai_1 _2723_ (.B1(_1693_),
    .Y(_0021_),
    .A1(\pll_dig.flock.cnt_done[0] ),
    .A2(_1358_));
 sg13g2_xnor2_1 _2724_ (.Y(_1694_),
    .A(_1167_),
    .B(_1170_));
 sg13g2_xnor2_1 _2725_ (.Y(_1695_),
    .A(_1170_),
    .B(_1200_));
 sg13g2_a21oi_1 _2726_ (.A1(net64),
    .A2(_1695_),
    .Y(_1696_),
    .B1(net115));
 sg13g2_a21o_1 _2727_ (.A2(_1694_),
    .A1(net61),
    .B1(_1696_),
    .X(_1697_));
 sg13g2_o21ai_1 _2728_ (.B1(_1697_),
    .Y(\pll_dig.dlf.OUT_C[13] ),
    .A1(\SS_BBPD[0] ),
    .A2(_0521_));
 sg13g2_xnor2_1 _2729_ (.Y(_1698_),
    .A(_1156_),
    .B(_1159_));
 sg13g2_xnor2_1 _2730_ (.Y(_1699_),
    .A(_1159_),
    .B(_1195_));
 sg13g2_a221oi_1 _2731_ (.B2(_1699_),
    .C1(net116),
    .B1(net65),
    .A1(net127),
    .Y(_1700_),
    .A2(net118));
 sg13g2_nand2_1 _2732_ (.Y(_0591_),
    .A(net554),
    .B(\pll_dig.div.ncnt[0] ));
 sg13g2_a21oi_1 _2733_ (.A1(net62),
    .A2(_1698_),
    .Y(\pll_dig.dlf.OUT_C[9] ),
    .B1(_1700_));
 sg13g2_xor2_1 _2734_ (.B(_1161_),
    .A(_1124_),
    .X(_1701_));
 sg13g2_nand2b_1 _2735_ (.Y(_1702_),
    .B(_1124_),
    .A_N(_1196_));
 sg13g2_nand3b_1 _2736_ (.B(net65),
    .C(_1702_),
    .Y(_1703_),
    .A_N(_1197_));
 sg13g2_a21oi_1 _2737_ (.A1(net127),
    .A2(net986),
    .Y(_1704_),
    .B1(net116));
 sg13g2_a22oi_1 _2738_ (.Y(\pll_dig.dlf.OUT_C[10] ),
    .B1(_1703_),
    .B2(_1704_),
    .A2(_1701_),
    .A1(net62));
 sg13g2_a21oi_1 _2739_ (.A1(\pll_dig.div.out_reg ),
    .A2(net398),
    .Y(_1705_),
    .B1(_1101_));
 sg13g2_xnor2_1 _2740_ (.Y(_0264_),
    .A(net89),
    .B(_1705_));
 sg13g2_nor2_1 _2741_ (.A(net234),
    .B(_0128_),
    .Y(_1706_));
 sg13g2_a21oi_1 _2742_ (.A1(net234),
    .A2(net49),
    .Y(_0260_),
    .B1(_1706_));
 sg13g2_nand3_1 _2743_ (.B(net554),
    .C(\pll_dig.div.ncnt[0] ),
    .A(\pll_dig.div.ncnt[2] ),
    .Y(_0592_));
 sg13g2_mux2_1 _2744_ (.A0(\pll_dig.div.div_pend[5] ),
    .A1(net53),
    .S(net234),
    .X(_0259_));
 sg13g2_mux2_1 _2745_ (.A0(\pll_dig.div.div_pend[3] ),
    .A1(net51),
    .S(net46),
    .X(_0257_));
 sg13g2_mux2_1 _2746_ (.A0(\pll_dig.div.div_pend[4] ),
    .A1(net52),
    .S(net46),
    .X(_0256_));
 sg13g2_nor4_1 _2747_ (.A(net52),
    .B(net51),
    .C(net50),
    .D(net54),
    .Y(_1707_));
 sg13g2_nor4_1 _2748_ (.A(_0473_),
    .B(net49),
    .C(net53),
    .D(net55),
    .Y(_1708_));
 sg13g2_mux2_1 _2749_ (.A0(\pll_dig.div.div_pend[0] ),
    .A1(net48),
    .S(net234),
    .X(_1709_));
 sg13g2_a21o_1 _2750_ (.A2(_1708_),
    .A1(_1707_),
    .B1(_1709_),
    .X(_0255_));
 sg13g2_mux2_1 _2751_ (.A0(\pll_dig.div.div_pend[2] ),
    .A1(net50),
    .S(net46),
    .X(_0254_));
 sg13g2_a21oi_1 _2752_ (.A1(_0454_),
    .A2(_1372_),
    .Y(\pll_dig.FINE_MUX_D[12] ),
    .B1(_0833_));
 sg13g2_xnor2_1 _2753_ (.Y(_0152_),
    .A(net1062),
    .B(net858));
 sg13g2_inv_1 _2754_ (.Y(_0458_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca3 ));
 sg13g2_nor2_1 _2755_ (.A(_0445_),
    .B(_0592_),
    .Y(_0593_));
 sg13g2_xnor2_1 _2756_ (.Y(_0153_),
    .A(net1060),
    .B(net871));
 sg13g2_xnor2_1 _2757_ (.Y(_0140_),
    .A(net1057),
    .B(net836));
 sg13g2_xnor2_1 _2758_ (.Y(_0154_),
    .A(_0995_),
    .B(net845));
 sg13g2_o21ai_1 _2759_ (.B1(_0867_),
    .Y(_1710_),
    .A1(\pll_dig.flock.cnt[12] ),
    .A2(net123));
 sg13g2_nor2_1 _2760_ (.A(_1594_),
    .B(_1710_),
    .Y(_0253_));
 sg13g2_or3_1 _2761_ (.A(_0477_),
    .B(_1348_),
    .C(_1408_),
    .X(_1711_));
 sg13g2_xnor2_1 _2762_ (.Y(_1712_),
    .A(\pll_dig.flock.cnt_done[7] ),
    .B(_1711_));
 sg13g2_a22oi_1 _2763_ (.Y(_1713_),
    .B1(_1357_),
    .B2(_1712_),
    .A2(_1315_),
    .A1(\pll_dig.flock.cnt_done[7] ));
 sg13g2_inv_1 _2764_ (.Y(_0028_),
    .A(_1713_));
 sg13g2_nand2_1 _2765_ (.Y(_1714_),
    .A(\pll_dig.flock.freq_miss[1] ),
    .B(\pll_dig.flock.freq_miss[0] ));
 sg13g2_nand3_1 _2766_ (.B(\pll_dig.div.ncnt[4] ),
    .C(_0593_),
    .A(\pll_dig.div.ncnt[5] ),
    .Y(_0594_));
 sg13g2_nand3_1 _2767_ (.B(\pll_dig.FREQ_OK ),
    .C(_1714_),
    .A(_0460_),
    .Y(_1715_));
 sg13g2_a21oi_1 _2768_ (.A1(_0892_),
    .A2(_1715_),
    .Y(_0252_),
    .B1(_0549_));
 sg13g2_xnor2_1 _2769_ (.Y(_0151_),
    .A(net1067),
    .B(net875));
 sg13g2_a21oi_1 _2770_ (.A1(\SS_BBPD[0] ),
    .A2(net30),
    .Y(_1716_),
    .B1(_0525_));
 sg13g2_nor2_1 _2771_ (.A(\SS_BBPD[0] ),
    .B(net979),
    .Y(_1717_));
 sg13g2_nor3_1 _2772_ (.A(_1183_),
    .B(\pll_dig.dlf.ILL_P_C ),
    .C(_1716_),
    .Y(_1718_));
 sg13g2_nor3_1 _2773_ (.A(\pll_dig.dlf.ILL_N_C ),
    .B(_1717_),
    .C(_1718_),
    .Y(\pll_dig.dlf.OUT_C[0] ));
 sg13g2_nor2_2 _2774_ (.A(\pll_dig.flock.cnt[13] ),
    .B(net498),
    .Y(_1719_));
 sg13g2_xor2_1 _2775_ (.B(_1719_),
    .A(\pll_dig.flock.cnt[14] ),
    .X(_1720_));
 sg13g2_nor2_1 _2776_ (.A(\pll_dig.flock.cnt_gray[12] ),
    .B(net124),
    .Y(_1721_));
 sg13g2_nand4_1 _2777_ (.B(\pll_dig.div.ncnt[5] ),
    .C(\pll_dig.div.ncnt[4] ),
    .A(\pll_dig.div.ncnt[6] ),
    .Y(_0595_),
    .D(_0593_));
 sg13g2_a21oi_1 _2778_ (.A1(_1720_),
    .A2(net124),
    .Y(_0251_),
    .B1(_1721_));
 sg13g2_xnor2_1 _2779_ (.Y(_1722_),
    .A(_1138_),
    .B(_1186_));
 sg13g2_a221oi_1 _2780_ (.B2(_1722_),
    .C1(net116),
    .B1(net65),
    .A1(net127),
    .Y(_1723_),
    .A2(net984));
 sg13g2_xnor2_1 _2781_ (.Y(_1724_),
    .A(_1135_),
    .B(_1138_));
 sg13g2_a21oi_1 _2782_ (.A1(net62),
    .A2(_1724_),
    .Y(\pll_dig.dlf.OUT_C[3] ),
    .B1(_1723_));
 sg13g2_nand2_1 _2783_ (.Y(_1725_),
    .A(\pll_dig.flock.cnt_done[6] ),
    .B(_1315_));
 sg13g2_xnor2_1 _2784_ (.Y(_1726_),
    .A(_0477_),
    .B(_1408_));
 sg13g2_nand2_1 _2785_ (.Y(_1727_),
    .A(net900),
    .B(_1726_));
 sg13g2_nand2_1 _2786_ (.Y(_1728_),
    .A(\pll_dig.flock.cnt_done[7] ),
    .B(_1356_));
 sg13g2_o21ai_1 _2787_ (.B1(_1728_),
    .Y(_1729_),
    .A1(_0477_),
    .A2(_1355_));
 sg13g2_xor2_1 _2788_ (.B(_0595_),
    .A(\pll_dig.div.ncnt[7] ),
    .X(_0596_));
 sg13g2_o21ai_1 _2789_ (.B1(_1727_),
    .Y(_1730_),
    .A1(net900),
    .A2(_1729_));
 sg13g2_o21ai_1 _2790_ (.B1(_1725_),
    .Y(_0027_),
    .A1(_1313_),
    .A2(_1730_));
 sg13g2_a221oi_1 _2791_ (.B2(_0484_),
    .C1(net73),
    .B1(net86),
    .A1(_0492_),
    .Y(_1731_),
    .A2(net88));
 sg13g2_a21o_1 _2792_ (.A2(net73),
    .A1(\pll_dig.MID_MUX_D[1] ),
    .B1(_1731_),
    .X(_0250_));
 sg13g2_xnor2_1 _2793_ (.Y(_1732_),
    .A(\pll_dig.flock.cnt_bin[11] ),
    .B(_1210_));
 sg13g2_o21ai_1 _2794_ (.B1(net151),
    .Y(_1733_),
    .A1(_1465_),
    .A2(_1732_));
 sg13g2_a21oi_1 _2795_ (.A1(_1465_),
    .A2(_1732_),
    .Y(_0064_),
    .B1(_1733_));
 sg13g2_nor3_1 _2796_ (.A(_0557_),
    .B(_0133_),
    .C(_0051_),
    .Y(_0095_));
 sg13g2_nor3_2 _2797_ (.A(net146),
    .B(_0600_),
    .C(\pll_dig.div.div[2] ),
    .Y(_1734_));
 sg13g2_nor2b_2 _2798_ (.A(net144),
    .B_N(_1734_),
    .Y(_1735_));
 sg13g2_xnor2_1 _2799_ (.Y(_0597_),
    .A(\pll_dig.div.ncnt[4] ),
    .B(_0593_));
 sg13g2_nand2b_1 _2800_ (.Y(_1736_),
    .B(_1735_),
    .A_N(net142));
 sg13g2_nor2_2 _2801_ (.A(net141),
    .B(_1736_),
    .Y(_1737_));
 sg13g2_xnor2_1 _2802_ (.Y(_1738_),
    .A(\pll_dig.div.div[7] ),
    .B(_1737_));
 sg13g2_xnor2_1 _2803_ (.Y(_1739_),
    .A(net144),
    .B(_1734_));
 sg13g2_nor2_1 _2804_ (.A(\pll_dig.div.pcnt[3] ),
    .B(_1739_),
    .Y(_1740_));
 sg13g2_o21ai_1 _2805_ (.B1(net146),
    .Y(_1741_),
    .A1(\pll_dig.div.div[2] ),
    .A2(_0600_));
 sg13g2_nor2b_1 _2806_ (.A(net708),
    .B_N(_1741_),
    .Y(_1742_));
 sg13g2_and2_2 _2807_ (.A(\pll_dig.div.pcnt[1] ),
    .B(\pll_dig.div.pcnt[0] ),
    .X(_1743_));
 sg13g2_nor2b_1 _2808_ (.A(_0132_),
    .B_N(net149),
    .Y(_1744_));
 sg13g2_or2_1 _2809_ (.X(_1745_),
    .B(_1744_),
    .A(_0599_));
 sg13g2_xnor2_1 _2810_ (.Y(_0598_),
    .A(_0445_),
    .B(_0592_));
 sg13g2_a21oi_1 _2811_ (.A1(\pll_dig.div.div[2] ),
    .A2(_0589_),
    .Y(_1746_),
    .B1(_1745_));
 sg13g2_nor2_1 _2812_ (.A(net727),
    .B(_1746_),
    .Y(_1747_));
 sg13g2_xnor2_1 _2813_ (.Y(_1748_),
    .A(\pll_dig.div.div[2] ),
    .B(net710));
 sg13g2_nor2_1 _2814_ (.A(net796),
    .B(net797),
    .Y(_1749_));
 sg13g2_o21ai_1 _2815_ (.B1(_1747_),
    .Y(_1750_),
    .A1(_1748_),
    .A2(_1749_));
 sg13g2_a21oi_1 _2816_ (.A1(\pll_dig.div.pcnt[2] ),
    .A2(_1742_),
    .Y(_1751_),
    .B1(_1750_));
 sg13g2_nor2_1 _2817_ (.A(\pll_dig.div.pcnt[2] ),
    .B(_1742_),
    .Y(_1752_));
 sg13g2_nor3_1 _2818_ (.A(_1740_),
    .B(_1751_),
    .C(_1752_),
    .Y(_1753_));
 sg13g2_xnor2_1 _2819_ (.Y(_1754_),
    .A(net142),
    .B(net709));
 sg13g2_a221oi_1 _2820_ (.B2(_1754_),
    .C1(_1753_),
    .B1(\pll_dig.div.pcnt[4] ),
    .A1(\pll_dig.div.pcnt[3] ),
    .Y(_1755_),
    .A2(_1739_));
 sg13g2_nor2b_1 _2821_ (.A(net149),
    .B_N(_0132_),
    .Y(_0599_));
 sg13g2_xor2_1 _2822_ (.B(_1736_),
    .A(net141),
    .X(_1756_));
 sg13g2_or2_1 _2823_ (.X(_1757_),
    .B(_1754_),
    .A(\pll_dig.div.pcnt[4] ));
 sg13g2_o21ai_1 _2824_ (.B1(_1757_),
    .Y(_1758_),
    .A1(\pll_dig.div.pcnt[5] ),
    .A2(_1756_));
 sg13g2_a22oi_1 _2825_ (.Y(_1759_),
    .B1(_1756_),
    .B2(\pll_dig.div.pcnt[5] ),
    .A2(_1738_),
    .A1(\pll_dig.div.pcnt[6] ));
 sg13g2_o21ai_1 _2826_ (.B1(_1759_),
    .Y(_1760_),
    .A1(_1758_),
    .A2(_1755_));
 sg13g2_o21ai_1 _2827_ (.B1(_1760_),
    .Y(_1761_),
    .A1(\pll_dig.div.pcnt[6] ),
    .A2(net705));
 sg13g2_inv_1 _2828_ (.Y(_1762_),
    .A(_1761_));
 sg13g2_nor3_1 _2829_ (.A(\pll_dig.div.pcnt[7] ),
    .B(_0622_),
    .C(_1762_),
    .Y(_0086_));
 sg13g2_nor2_1 _2830_ (.A(net422),
    .B(net89),
    .Y(_0077_));
 sg13g2_nor2_1 _2831_ (.A(_1050_),
    .B(net89),
    .Y(_0078_));
 sg13g2_nand2b_2 _2832_ (.Y(_0600_),
    .B(_0132_),
    .A_N(net149));
 sg13g2_nor2_1 _2833_ (.A(_1048_),
    .B(net503),
    .Y(_0079_));
 sg13g2_nor2_2 _2834_ (.A(net503),
    .B(net408),
    .Y(_0080_));
 sg13g2_nor2_1 _2835_ (.A(net395),
    .B(net89),
    .Y(_0081_));
 sg13g2_nor2_1 _2836_ (.A(_1060_),
    .B(net89),
    .Y(_0082_));
 sg13g2_nor2_1 _2837_ (.A(net392),
    .B(net89),
    .Y(_0083_));
 sg13g2_nor2_1 _2838_ (.A(net394),
    .B(net89),
    .Y(_0084_));
 sg13g2_nand3_1 _2839_ (.B(\pll_dig.div.pcnt[2] ),
    .C(\pll_dig.div.pcnt[3] ),
    .A(_1743_),
    .Y(_1763_));
 sg13g2_nand4_1 _2840_ (.B(\pll_dig.div.pcnt[4] ),
    .C(\pll_dig.div.pcnt[2] ),
    .A(_1743_),
    .Y(_1764_),
    .D(\pll_dig.div.pcnt[3] ));
 sg13g2_xor2_1 _2841_ (.B(_1763_),
    .A(\pll_dig.div.pcnt[4] ),
    .X(_1765_));
 sg13g2_xnor2_1 _2842_ (.Y(_1766_),
    .A(\pll_dig.div.pcnt[2] ),
    .B(_1743_));
 sg13g2_nand2b_1 _2843_ (.Y(_0601_),
    .B(\pll_dig.div.ncnt[0] ),
    .A_N(net149));
 sg13g2_nor2_1 _2844_ (.A(\pll_dig.div.div[2] ),
    .B(_1766_),
    .Y(_1767_));
 sg13g2_nor2b_1 _2845_ (.A(net149),
    .B_N(net796),
    .Y(_1768_));
 sg13g2_nor3_1 _2846_ (.A(_0132_),
    .B(net797),
    .C(_1768_),
    .Y(_1769_));
 sg13g2_o21ai_1 _2847_ (.B1(net710),
    .Y(_1770_),
    .A1(net727),
    .A2(_1769_));
 sg13g2_a21o_1 _2848_ (.A2(net731),
    .A1(\pll_dig.div.pcnt[2] ),
    .B1(\pll_dig.div.pcnt[3] ),
    .X(_1771_));
 sg13g2_nand2_2 _2849_ (.Y(_1772_),
    .A(_1771_),
    .B(net795));
 sg13g2_a22oi_1 _2850_ (.Y(_1773_),
    .B1(_1772_),
    .B2(net146),
    .A2(_1766_),
    .A1(\pll_dig.div.div[2] ));
 sg13g2_o21ai_1 _2851_ (.B1(_1773_),
    .Y(_1774_),
    .A1(_1767_),
    .A2(_1770_));
 sg13g2_nor2_1 _2852_ (.A(net146),
    .B(_1772_),
    .Y(_1775_));
 sg13g2_nor2_2 _2853_ (.A(_1765_),
    .B(net144),
    .Y(_1776_));
 sg13g2_nor2_1 _2854_ (.A(net554),
    .B(_0132_),
    .Y(_0602_));
 sg13g2_nor2_2 _2855_ (.A(_1775_),
    .B(_1776_),
    .Y(_1777_));
 sg13g2_a22oi_1 _2856_ (.Y(_1778_),
    .B1(_1777_),
    .B2(_1774_),
    .A2(net794),
    .A1(\pll_dig.div.div[4] ));
 sg13g2_xnor2_1 _2857_ (.Y(_1779_),
    .A(_0588_),
    .B(net726));
 sg13g2_nor2_1 _2858_ (.A(net142),
    .B(_1779_),
    .Y(_1780_));
 sg13g2_nor3_2 _2859_ (.A(_0587_),
    .B(_0588_),
    .C(net729),
    .Y(_1781_));
 sg13g2_o21ai_1 _2860_ (.B1(_0587_),
    .Y(_1782_),
    .A1(_0588_),
    .A2(net726));
 sg13g2_nand2b_1 _2861_ (.Y(_1783_),
    .B(_1782_),
    .A_N(_1781_));
 sg13g2_a22oi_1 _2862_ (.Y(_1784_),
    .B1(_1783_),
    .B2(net141),
    .A2(_1779_),
    .A1(net143));
 sg13g2_o21ai_1 _2863_ (.B1(_1784_),
    .Y(_1785_),
    .A1(_1780_),
    .A2(_1778_));
 sg13g2_nor2_1 _2864_ (.A(net141),
    .B(net728),
    .Y(_1786_));
 sg13g2_inv_1 _2865_ (.Y(_0459_),
    .A(\pll_dig.COARSE_MUX_D[7] ));
 sg13g2_a22oi_1 _2866_ (.Y(_0603_),
    .B1(_0601_),
    .B2(_0602_),
    .A2(\pll_dig.div.ncnt[0] ),
    .A1(net554));
 sg13g2_xnor2_1 _2867_ (.Y(_1787_),
    .A(\pll_dig.div.pcnt[7] ),
    .B(_1781_));
 sg13g2_o21ai_1 _2868_ (.B1(_1785_),
    .Y(_1788_),
    .A1(\pll_dig.div.div[7] ),
    .A2(_1787_));
 sg13g2_nor3_2 _2869_ (.A(_0622_),
    .B(_1788_),
    .C(_1786_),
    .Y(_1789_));
 sg13g2_a21oi_2 _2870_ (.B1(_1789_),
    .Y(_1790_),
    .A2(_1787_),
    .A1(_0626_));
 sg13g2_nor2_2 _2871_ (.A(net796),
    .B(_1790_),
    .Y(_0087_));
 sg13g2_nor3_2 _2872_ (.A(net727),
    .B(_1749_),
    .C(_1790_),
    .Y(_0088_));
 sg13g2_nor2_2 _2873_ (.A(_1766_),
    .B(_1790_),
    .Y(_0089_));
 sg13g2_nor2_2 _2874_ (.A(net800),
    .B(_1790_),
    .Y(_0090_));
 sg13g2_nor2_2 _2875_ (.A(net730),
    .B(_1790_),
    .Y(_0091_));
 sg13g2_nor2_2 _2876_ (.A(_1779_),
    .B(_1790_),
    .Y(_0092_));
 sg13g2_xor2_1 _2877_ (.B(_0591_),
    .A(\pll_dig.div.ncnt[2] ),
    .X(_0604_));
 sg13g2_nor2_2 _2878_ (.A(_1790_),
    .B(net728),
    .Y(_0093_));
 sg13g2_nor2b_1 _2879_ (.A(_1787_),
    .B_N(_1789_),
    .Y(_0094_));
 sg13g2_nor2b_1 _2880_ (.A(_0128_),
    .B_N(\pll_dig.div.div_pend[0] ),
    .Y(_1791_));
 sg13g2_a21oi_2 _2881_ (.B1(net92),
    .Y(_1792_),
    .A2(_1791_),
    .A1(\pll_dig.div.div_pend[2] ));
 sg13g2_o21ai_1 _2882_ (.B1(_1792_),
    .Y(_1793_),
    .A1(\pll_dig.div.div_pend[2] ),
    .A2(_1791_));
 sg13g2_and2_1 _2883_ (.A(net147),
    .B(_1744_),
    .X(_1794_));
 sg13g2_o21ai_1 _2884_ (.B1(net92),
    .Y(_1795_),
    .A1(net147),
    .A2(_1744_));
 sg13g2_o21ai_1 _2885_ (.B1(_1793_),
    .Y(\pll_dig.div.high_count_pend[1] ),
    .A1(_1794_),
    .A2(_1795_));
 sg13g2_a21oi_1 _2886_ (.A1(\pll_dig.div.div_pend[2] ),
    .A2(_1791_),
    .Y(_1796_),
    .B1(\pll_dig.div.div_pend[3] ));
 sg13g2_and3_1 _2887_ (.X(_1797_),
    .A(\pll_dig.div.div_pend[2] ),
    .B(\pll_dig.div.div_pend[3] ),
    .C(_1791_));
 sg13g2_a22oi_1 _2888_ (.Y(_0605_),
    .B1(_0604_),
    .B2(net147),
    .A2(_0598_),
    .A1(net145));
 sg13g2_nor3_2 _2889_ (.A(net92),
    .B(_1796_),
    .C(_1797_),
    .Y(_1798_));
 sg13g2_and3_1 _2890_ (.X(_1799_),
    .A(net145),
    .B(net147),
    .C(_1744_));
 sg13g2_a21oi_1 _2891_ (.A1(net147),
    .A2(_1744_),
    .Y(_1800_),
    .B1(net145));
 sg13g2_nor2_1 _2892_ (.A(_1799_),
    .B(_1800_),
    .Y(_1801_));
 sg13g2_a21o_1 _2893_ (.A2(_1801_),
    .A1(net92),
    .B1(_1798_),
    .X(\pll_dig.div.high_count_pend[2] ));
 sg13g2_xnor2_1 _2894_ (.Y(_1802_),
    .A(\pll_dig.div.div_pend[4] ),
    .B(_1797_));
 sg13g2_and2_1 _2895_ (.A(net144),
    .B(_1799_),
    .X(_1803_));
 sg13g2_xor2_1 _2896_ (.B(_1799_),
    .A(net144),
    .X(_1804_));
 sg13g2_nand2_1 _2897_ (.Y(_1805_),
    .A(net92),
    .B(_1804_));
 sg13g2_o21ai_1 _2898_ (.B1(_1805_),
    .Y(\pll_dig.div.high_count_pend[3] ),
    .A1(_1802_),
    .A2(net92));
 sg13g2_o21ai_1 _2899_ (.B1(_0605_),
    .Y(_0606_),
    .A1(_0603_),
    .A2(_0599_));
 sg13g2_and3_1 _2900_ (.X(_1806_),
    .A(\pll_dig.div.div_pend[5] ),
    .B(\pll_dig.div.div_pend[4] ),
    .C(_1797_));
 sg13g2_a21oi_1 _2901_ (.A1(\pll_dig.div.div_pend[4] ),
    .A2(_1797_),
    .Y(_1807_),
    .B1(\pll_dig.div.div_pend[5] ));
 sg13g2_nor3_2 _2902_ (.A(net92),
    .B(_1806_),
    .C(_1807_),
    .Y(_1808_));
 sg13g2_xor2_1 _2903_ (.B(_1803_),
    .A(net142),
    .X(_1809_));
 sg13g2_a21o_1 _2904_ (.A2(_1809_),
    .A1(net425),
    .B1(_1808_),
    .X(\pll_dig.div.high_count_pend[4] ));
 sg13g2_a21oi_1 _2905_ (.A1(net142),
    .A2(_1803_),
    .Y(_1810_),
    .B1(net141));
 sg13g2_nand3_1 _2906_ (.B(net142),
    .C(_1803_),
    .A(net141),
    .Y(_1811_));
 sg13g2_nand2_1 _2907_ (.Y(_1812_),
    .A(net90),
    .B(_1811_));
 sg13g2_or2_1 _2908_ (.X(_1813_),
    .B(_1812_),
    .A(_1810_));
 sg13g2_nor2_1 _2909_ (.A(\pll_dig.div.div_pend[6] ),
    .B(_1806_),
    .Y(_1814_));
 sg13g2_nor2_1 _2910_ (.A(net145),
    .B(_0598_),
    .Y(_0607_));
 sg13g2_nand2_1 _2911_ (.Y(_1815_),
    .A(\pll_dig.div.div_pend[6] ),
    .B(_1806_));
 sg13g2_nand2b_1 _2912_ (.Y(_1816_),
    .B(_1815_),
    .A_N(net90));
 sg13g2_o21ai_1 _2913_ (.B1(_1813_),
    .Y(\pll_dig.div.high_count_pend[5] ),
    .A1(_1814_),
    .A2(_1816_));
 sg13g2_xor2_1 _2914_ (.B(_1815_),
    .A(\pll_dig.div.div_pend[7] ),
    .X(_1817_));
 sg13g2_xnor2_1 _2915_ (.Y(_1818_),
    .A(\pll_dig.div.div[7] ),
    .B(_1811_));
 sg13g2_nand2_1 _2916_ (.Y(_1819_),
    .A(net426),
    .B(_1818_));
 sg13g2_o21ai_1 _2917_ (.B1(_1819_),
    .Y(\pll_dig.div.high_count_pend[6] ),
    .A1(_1817_),
    .A2(net426));
 sg13g2_and3_1 _2918_ (.X(\pll_dig.div.high_count_pend[7] ),
    .A(_0329_),
    .B(_1812_),
    .C(_1816_));
 sg13g2_o21ai_1 _2919_ (.B1(_1745_),
    .Y(_1820_),
    .A1(_0446_),
    .A2(_1748_));
 sg13g2_nor2_1 _2920_ (.A(\pll_dig.div.ncnt[0] ),
    .B(_1820_),
    .Y(_1821_));
 sg13g2_a21oi_1 _2921_ (.A1(_0445_),
    .A2(net145),
    .Y(_0608_),
    .B1(\pll_dig.div.div[2] ));
 sg13g2_nand2_1 _2922_ (.Y(_1822_),
    .A(_0446_),
    .B(_1748_));
 sg13g2_o21ai_1 _2923_ (.B1(_1822_),
    .Y(_1823_),
    .A1(\pll_dig.div.ncnt[2] ),
    .A2(_1742_));
 sg13g2_a22oi_1 _2924_ (.Y(_1824_),
    .B1(_1742_),
    .B2(\pll_dig.div.ncnt[2] ),
    .A2(_1739_),
    .A1(\pll_dig.div.ncnt[3] ));
 sg13g2_o21ai_1 _2925_ (.B1(_1824_),
    .Y(_1825_),
    .A1(_1823_),
    .A2(_1821_));
 sg13g2_nor2_1 _2926_ (.A(\pll_dig.div.ncnt[4] ),
    .B(_1754_),
    .Y(_1826_));
 sg13g2_o21ai_1 _2927_ (.B1(_1825_),
    .Y(_1827_),
    .A1(\pll_dig.div.ncnt[3] ),
    .A2(_1739_));
 sg13g2_a22oi_1 _2928_ (.Y(_1828_),
    .B1(_1756_),
    .B2(\pll_dig.div.ncnt[5] ),
    .A2(_1754_),
    .A1(\pll_dig.div.ncnt[4] ));
 sg13g2_o21ai_1 _2929_ (.B1(_1828_),
    .Y(_1829_),
    .A1(_1827_),
    .A2(_1826_));
 sg13g2_nor2_1 _2930_ (.A(\pll_dig.div.ncnt[5] ),
    .B(_1756_),
    .Y(_1830_));
 sg13g2_o21ai_1 _2931_ (.B1(_1829_),
    .Y(_1831_),
    .A1(\pll_dig.div.ncnt[6] ),
    .A2(net707));
 sg13g2_nor2b_1 _2932_ (.A(_0604_),
    .B_N(_0608_),
    .Y(_0609_));
 sg13g2_nand2_1 _2933_ (.Y(_1832_),
    .A(\pll_dig.div.ncnt[6] ),
    .B(net706));
 sg13g2_o21ai_1 _2934_ (.B1(_1832_),
    .Y(_1833_),
    .A1(_1831_),
    .A2(_1830_));
 sg13g2_nor3_1 _2935_ (.A(\pll_dig.div.ncnt[7] ),
    .B(_0622_),
    .C(_1833_),
    .Y(_0085_));
 sg13g2_nor2_1 _2936_ (.A(_0050_),
    .B(_1655_),
    .Y(_1834_));
 sg13g2_or2_1 _2937_ (.X(_1835_),
    .B(_1655_),
    .A(_0050_));
 sg13g2_nand3_1 _2938_ (.B(net937),
    .C(net965),
    .A(net945),
    .Y(_1836_));
 sg13g2_nor2_1 _2939_ (.A(_0466_),
    .B(_1836_),
    .Y(_1837_));
 sg13g2_and2_1 _2940_ (.A(net970),
    .B(_1837_),
    .X(_1838_));
 sg13g2_nand3_1 _2941_ (.B(net907),
    .C(_1838_),
    .A(net960),
    .Y(_1839_));
 sg13g2_nor2_1 _2942_ (.A(\pll_dig.cntf[2] ),
    .B(\pll_dig.cntf[3] ),
    .Y(_1840_));
 sg13g2_nor2_1 _2943_ (.A(_0607_),
    .B(_0609_),
    .Y(_0610_));
 sg13g2_nor4_1 _2944_ (.A(\pll_dig.cntf[6] ),
    .B(\pll_dig.cntf[7] ),
    .C(\pll_dig.cntf[0] ),
    .D(\pll_dig.cntf[1] ),
    .Y(_1841_));
 sg13g2_and4_1 _2945_ (.A(net970),
    .B(_0559_),
    .C(_1840_),
    .D(_1841_),
    .X(_1842_));
 sg13g2_nor4_1 _2946_ (.A(net992),
    .B(_1622_),
    .C(_1635_),
    .D(_1842_),
    .Y(_1843_));
 sg13g2_a21oi_1 _2947_ (.A1(net961),
    .A2(_1843_),
    .Y(_1844_),
    .B1(_1835_));
 sg13g2_nand3_1 _2948_ (.B(_1834_),
    .C(_1838_),
    .A(net907),
    .Y(_1845_));
 sg13g2_a21oi_1 _2949_ (.A1(_0452_),
    .A2(net908),
    .Y(_0258_),
    .B1(_1844_));
 sg13g2_nand2b_1 _2950_ (.Y(_1846_),
    .B(_0463_),
    .A_N(net112));
 sg13g2_nand2_1 _2951_ (.Y(_1847_),
    .A(net20),
    .B(net117));
 sg13g2_nor2_1 _2952_ (.A(net20),
    .B(net117),
    .Y(_1848_));
 sg13g2_xnor2_1 _2953_ (.Y(_1849_),
    .A(\pll_dig.dlf.INT[14] ),
    .B(net19));
 sg13g2_a22oi_1 _2954_ (.Y(_0611_),
    .B1(_0610_),
    .B2(_0606_),
    .A2(_0597_),
    .A1(\pll_dig.div.div[4] ));
 sg13g2_nor2b_1 _2955_ (.A(net1001),
    .B_N(net18),
    .Y(_1850_));
 sg13g2_nor2_1 _2956_ (.A(_0521_),
    .B(net18),
    .Y(_1851_));
 sg13g2_nand2_1 _2957_ (.Y(_1852_),
    .A(net998),
    .B(net17));
 sg13g2_xnor2_1 _2958_ (.Y(_1853_),
    .A(\pll_dig.dlf.INT[12] ),
    .B(net17));
 sg13g2_nor2b_1 _2959_ (.A(net1006),
    .B_N(net16),
    .Y(_1854_));
 sg13g2_nor2_1 _2960_ (.A(_0529_),
    .B(net16),
    .Y(_1855_));
 sg13g2_nor2_1 _2961_ (.A(_0530_),
    .B(net15),
    .Y(_1856_));
 sg13g2_xnor2_1 _2962_ (.Y(_1857_),
    .A(\pll_dig.dlf.INT[10] ),
    .B(net15));
 sg13g2_nand2b_1 _2963_ (.Y(_1858_),
    .B(net118),
    .A_N(net29));
 sg13g2_nor2b_1 _2964_ (.A(net118),
    .B_N(net29),
    .Y(_1859_));
 sg13g2_a21o_1 _2965_ (.A2(_0593_),
    .A1(\pll_dig.div.ncnt[4] ),
    .B1(\pll_dig.div.ncnt[5] ),
    .X(_0612_));
 sg13g2_nand2_1 _2966_ (.Y(_1860_),
    .A(net996),
    .B(net28));
 sg13g2_xnor2_1 _2967_ (.Y(_1861_),
    .A(\pll_dig.dlf.INT[8] ),
    .B(net28));
 sg13g2_nand2_1 _2968_ (.Y(_1862_),
    .A(_0526_),
    .B(net27));
 sg13g2_nor2_1 _2969_ (.A(_0526_),
    .B(net27),
    .Y(_1863_));
 sg13g2_nand2_1 _2970_ (.Y(_1864_),
    .A(net982),
    .B(net26));
 sg13g2_xnor2_1 _2971_ (.Y(_1865_),
    .A(\pll_dig.dlf.INT[6] ),
    .B(net26));
 sg13g2_nor2_1 _2972_ (.A(_0532_),
    .B(net25),
    .Y(_1866_));
 sg13g2_nand2_1 _2973_ (.Y(_1867_),
    .A(net978),
    .B(net25));
 sg13g2_xnor2_1 _2974_ (.Y(_1868_),
    .A(\pll_dig.dlf.INT[5] ),
    .B(net25));
 sg13g2_nand2_1 _2975_ (.Y(_1869_),
    .A(net973),
    .B(net24));
 sg13g2_inv_1 _2976_ (.Y(_0460_),
    .A(\pll_dig.flock.freq_miss[2] ));
 sg13g2_nand2_1 _2977_ (.Y(_0613_),
    .A(_0594_),
    .B(_0612_));
 sg13g2_xnor2_1 _2978_ (.Y(_1870_),
    .A(\pll_dig.dlf.INT[4] ),
    .B(net24));
 sg13g2_nor2_1 _2979_ (.A(_0534_),
    .B(net23),
    .Y(_1871_));
 sg13g2_nand2_1 _2980_ (.Y(_1872_),
    .A(net984),
    .B(net23));
 sg13g2_xnor2_1 _2981_ (.Y(_1873_),
    .A(\pll_dig.dlf.INT[3] ),
    .B(net23));
 sg13g2_inv_1 _2982_ (.Y(_1874_),
    .A(_1873_));
 sg13g2_nand2b_1 _2983_ (.Y(_1875_),
    .B(\pll_dig.dlf.INT[2] ),
    .A_N(net22));
 sg13g2_nand2_1 _2984_ (.Y(_1876_),
    .A(net994),
    .B(net22));
 sg13g2_xnor2_1 _2985_ (.Y(_1877_),
    .A(\pll_dig.dlf.INT[2] ),
    .B(net22));
 sg13g2_nor2_1 _2986_ (.A(_0471_),
    .B(net21),
    .Y(_1878_));
 sg13g2_xor2_1 _2987_ (.B(net21),
    .A(\pll_dig.dlf.INT[1] ),
    .X(_1879_));
 sg13g2_or2_1 _2988_ (.X(_0614_),
    .B(_0597_),
    .A(\pll_dig.div.div[4] ));
 sg13g2_a21oi_1 _2989_ (.A1(_0525_),
    .A2(net14),
    .Y(_1880_),
    .B1(_1879_));
 sg13g2_o21ai_1 _2990_ (.B1(_1877_),
    .Y(_1881_),
    .A1(_1878_),
    .A2(_1880_));
 sg13g2_a21oi_1 _2991_ (.A1(_1875_),
    .A2(_1881_),
    .Y(_1882_),
    .B1(_1874_));
 sg13g2_or2_1 _2992_ (.X(_1883_),
    .B(_1882_),
    .A(_1871_));
 sg13g2_nand2_1 _2993_ (.Y(_1884_),
    .A(_1870_),
    .B(_1883_));
 sg13g2_o21ai_1 _2994_ (.B1(_1884_),
    .Y(_1885_),
    .A1(_0531_),
    .A2(net24));
 sg13g2_and2_1 _2995_ (.A(_1868_),
    .B(_1885_),
    .X(_1886_));
 sg13g2_o21ai_1 _2996_ (.B1(_1865_),
    .Y(_1887_),
    .A1(_1866_),
    .A2(_1886_));
 sg13g2_o21ai_1 _2997_ (.B1(_1887_),
    .Y(_1888_),
    .A1(_0533_),
    .A2(net26));
 sg13g2_a21oi_1 _2998_ (.A1(_1862_),
    .A2(_1888_),
    .Y(_1889_),
    .B1(_1863_));
 sg13g2_o21ai_1 _2999_ (.B1(_0614_),
    .Y(_0615_),
    .A1(net143),
    .A2(_0613_));
 sg13g2_nor2b_1 _3000_ (.A(_1889_),
    .B_N(_1861_),
    .Y(_1890_));
 sg13g2_a21oi_1 _3001_ (.A1(net1010),
    .A2(_0575_),
    .Y(_1891_),
    .B1(_1890_));
 sg13g2_a21oi_1 _3002_ (.A1(_1858_),
    .A2(_1891_),
    .Y(_1892_),
    .B1(_1859_));
 sg13g2_a21oi_1 _3003_ (.A1(_1857_),
    .A2(_1892_),
    .Y(_1893_),
    .B1(_1856_));
 sg13g2_nor2_1 _3004_ (.A(_1854_),
    .B(_1893_),
    .Y(_1894_));
 sg13g2_nor2_1 _3005_ (.A(_1855_),
    .B(_1894_),
    .Y(_1895_));
 sg13g2_nor2b_1 _3006_ (.A(_1895_),
    .B_N(_1853_),
    .Y(_1896_));
 sg13g2_a21oi_1 _3007_ (.A1(net1008),
    .A2(_0523_),
    .Y(_1897_),
    .B1(_1896_));
 sg13g2_nor2_1 _3008_ (.A(_1850_),
    .B(_1897_),
    .Y(_1898_));
 sg13g2_o21ai_1 _3009_ (.B1(_1849_),
    .Y(_1899_),
    .A1(_1851_),
    .A2(_1898_));
 sg13g2_xor2_1 _3010_ (.B(_0594_),
    .A(\pll_dig.div.ncnt[6] ),
    .X(_0616_));
 sg13g2_o21ai_1 _3011_ (.B1(_1899_),
    .Y(_1900_),
    .A1(_0520_),
    .A2(net19));
 sg13g2_a21oi_1 _3012_ (.A1(_1847_),
    .A2(_1900_),
    .Y(_1901_),
    .B1(_1848_));
 sg13g2_or2_1 _3013_ (.X(_1902_),
    .B(_1901_),
    .A(net97));
 sg13g2_inv_1 _3014_ (.Y(_1903_),
    .A(_1902_));
 sg13g2_xnor2_1 _3015_ (.Y(_1904_),
    .A(_1853_),
    .B(_1895_));
 sg13g2_nand2_1 _3016_ (.Y(_1905_),
    .A(net1001),
    .B(net18));
 sg13g2_nor2_1 _3017_ (.A(_1854_),
    .B(_1855_),
    .Y(_1906_));
 sg13g2_xnor2_1 _3018_ (.Y(_1907_),
    .A(net118),
    .B(net29));
 sg13g2_xnor2_1 _3019_ (.Y(_1908_),
    .A(\pll_dig.dlf.INT[7] ),
    .B(net27));
 sg13g2_nand2_1 _3020_ (.Y(_1909_),
    .A(net991),
    .B(net21));
 sg13g2_a22oi_1 _3021_ (.Y(_0617_),
    .B1(_0616_),
    .B2(\pll_dig.div.div[6] ),
    .A2(_0613_),
    .A1(net143));
 sg13g2_nand3_1 _3022_ (.B(net14),
    .C(_1879_),
    .A(net979),
    .Y(_1910_));
 sg13g2_a21o_1 _3023_ (.A2(_1910_),
    .A1(_1909_),
    .B1(_1877_),
    .X(_1911_));
 sg13g2_a21o_1 _3024_ (.A2(_1911_),
    .A1(_1876_),
    .B1(_1873_),
    .X(_1912_));
 sg13g2_a21o_1 _3025_ (.A2(_1912_),
    .A1(_1872_),
    .B1(_1870_),
    .X(_1913_));
 sg13g2_a21o_1 _3026_ (.A2(_1913_),
    .A1(_1869_),
    .B1(_1868_),
    .X(_1914_));
 sg13g2_a21o_1 _3027_ (.A2(_1914_),
    .A1(_1867_),
    .B1(_1865_),
    .X(_1915_));
 sg13g2_a21o_1 _3028_ (.A2(_1915_),
    .A1(_1864_),
    .B1(_1908_),
    .X(_1916_));
 sg13g2_nand2_1 _3029_ (.Y(_1917_),
    .A(net1072),
    .B(net27));
 sg13g2_a21o_1 _3030_ (.A2(_1917_),
    .A1(_1916_),
    .B1(_1861_),
    .X(_1918_));
 sg13g2_a21o_1 _3031_ (.A2(_1918_),
    .A1(_1860_),
    .B1(_1907_),
    .X(_1919_));
 sg13g2_o21ai_1 _3032_ (.B1(_0617_),
    .Y(_0618_),
    .A1(_0615_),
    .A2(_0611_));
 sg13g2_nand2_1 _3033_ (.Y(_1920_),
    .A(net118),
    .B(net29));
 sg13g2_a21o_1 _3034_ (.A2(_1920_),
    .A1(_1919_),
    .B1(_1857_),
    .X(_1921_));
 sg13g2_nand2_1 _3035_ (.Y(_1922_),
    .A(net986),
    .B(net15));
 sg13g2_a21o_1 _3036_ (.A2(_1922_),
    .A1(_1921_),
    .B1(_1906_),
    .X(_1923_));
 sg13g2_nand2_1 _3037_ (.Y(_1924_),
    .A(net988),
    .B(net16));
 sg13g2_a21o_1 _3038_ (.A2(_1924_),
    .A1(_1923_),
    .B1(_1853_),
    .X(_1925_));
 sg13g2_nand2_1 _3039_ (.Y(_1926_),
    .A(_1852_),
    .B(_1925_));
 sg13g2_o21ai_1 _3040_ (.B1(_1926_),
    .Y(_1927_),
    .A1(net1003),
    .A2(net18));
 sg13g2_a21oi_1 _3041_ (.A1(_1905_),
    .A2(_1927_),
    .Y(_1928_),
    .B1(_1849_));
 sg13g2_a21oi_1 _3042_ (.A1(net990),
    .A2(net19),
    .Y(_1929_),
    .B1(_1928_));
 sg13g2_nor2_1 _3043_ (.A(net147),
    .B(net143),
    .Y(_0619_));
 sg13g2_o21ai_1 _3044_ (.B1(_1929_),
    .Y(_1930_),
    .A1(_0524_),
    .A2(net117));
 sg13g2_nand2_1 _3045_ (.Y(_1931_),
    .A(_0524_),
    .B(net117));
 sg13g2_nand3_1 _3046_ (.B(_1930_),
    .C(_1931_),
    .A(net97),
    .Y(_1932_));
 sg13g2_nand2b_1 _3047_ (.Y(_1933_),
    .B(_1932_),
    .A_N(net112));
 sg13g2_inv_1 _3048_ (.Y(_1934_),
    .A(net66));
 sg13g2_nand3_1 _3049_ (.B(_1923_),
    .C(_1924_),
    .A(_1853_),
    .Y(_1935_));
 sg13g2_and2_1 _3050_ (.A(_1925_),
    .B(_1935_),
    .X(_1936_));
 sg13g2_a221oi_1 _3051_ (.B2(net96),
    .C1(net66),
    .B1(_1936_),
    .A1(net63),
    .Y(_1937_),
    .A2(_1904_));
 sg13g2_a21oi_1 _3052_ (.A1(_0522_),
    .A2(net114),
    .Y(_0261_),
    .B1(_1937_));
 sg13g2_xnor2_1 _3053_ (.Y(_1938_),
    .A(_1893_),
    .B(_1906_));
 sg13g2_nor4_1 _3054_ (.A(net144),
    .B(net145),
    .C(\pll_dig.div.div[6] ),
    .D(\pll_dig.div.div[7] ),
    .Y(_0620_));
 sg13g2_nand3_1 _3055_ (.B(_1921_),
    .C(_1922_),
    .A(_1906_),
    .Y(_1939_));
 sg13g2_and2_1 _3056_ (.A(_1923_),
    .B(_1939_),
    .X(_1940_));
 sg13g2_a221oi_1 _3057_ (.B2(net96),
    .C1(net66),
    .B1(_1940_),
    .A1(net63),
    .Y(_1941_),
    .A2(_1938_));
 sg13g2_a21oi_1 _3058_ (.A1(_0529_),
    .A2(net114),
    .Y(_0262_),
    .B1(_1941_));
 sg13g2_nor2_1 _3059_ (.A(_1850_),
    .B(_1851_),
    .Y(_1942_));
 sg13g2_nand3_1 _3060_ (.B(_1852_),
    .C(_1925_),
    .A(net96),
    .Y(_1943_));
 sg13g2_o21ai_1 _3061_ (.B1(_1943_),
    .Y(_1944_),
    .A1(_1897_),
    .A2(_1902_));
 sg13g2_nand2_1 _3062_ (.Y(_1945_),
    .A(net96),
    .B(_1926_));
 sg13g2_nand2_1 _3063_ (.Y(_1946_),
    .A(_1897_),
    .B(net63));
 sg13g2_nand3_1 _3064_ (.B(_1945_),
    .C(_1946_),
    .A(_1942_),
    .Y(_1947_));
 sg13g2_nand3_1 _3065_ (.B(_0620_),
    .C(_0619_),
    .A(_0132_),
    .Y(_0621_));
 sg13g2_o21ai_1 _3066_ (.B1(_1947_),
    .Y(_1948_),
    .A1(_1942_),
    .A2(_1944_));
 sg13g2_a22oi_1 _3067_ (.Y(_0263_),
    .B1(_1934_),
    .B2(_1948_),
    .A2(net114),
    .A1(_0521_));
 sg13g2_nor3_1 _3068_ (.A(_1865_),
    .B(_1866_),
    .C(_1886_),
    .Y(_1949_));
 sg13g2_nor2_1 _3069_ (.A(_1902_),
    .B(_1949_),
    .Y(_1950_));
 sg13g2_nand3_1 _3070_ (.B(_1867_),
    .C(_1914_),
    .A(_1865_),
    .Y(_1951_));
 sg13g2_nand3_1 _3071_ (.B(_1915_),
    .C(_1951_),
    .A(\SS_BBPD[1] ),
    .Y(_1952_));
 sg13g2_nand2_1 _3072_ (.Y(_1953_),
    .A(_1934_),
    .B(_1952_));
 sg13g2_a21oi_1 _3073_ (.A1(_1887_),
    .A2(_1950_),
    .Y(_1954_),
    .B1(_1953_));
 sg13g2_a21oi_1 _3074_ (.A1(_0533_),
    .A2(net113),
    .Y(_0273_),
    .B1(_1954_));
 sg13g2_xnor2_1 _3075_ (.Y(_1955_),
    .A(_1891_),
    .B(_1907_));
 sg13g2_nand2_2 _3076_ (.Y(_0622_),
    .A(net432),
    .B(_0621_));
 sg13g2_nand3_1 _3077_ (.B(_1907_),
    .C(_1918_),
    .A(_1860_),
    .Y(_1956_));
 sg13g2_and2_1 _3078_ (.A(_1919_),
    .B(_1956_),
    .X(_1957_));
 sg13g2_a221oi_1 _3079_ (.B2(net96),
    .C1(net66),
    .B1(_1957_),
    .A1(net63),
    .Y(_1958_),
    .A2(_1955_));
 sg13g2_a21oi_1 _3080_ (.A1(_0538_),
    .A2(net114),
    .Y(_0276_),
    .B1(_1958_));
 sg13g2_nand3_1 _3081_ (.B(_1875_),
    .C(_1881_),
    .A(_1874_),
    .Y(_1959_));
 sg13g2_nor2b_1 _3082_ (.A(_1882_),
    .B_N(_1959_),
    .Y(_1960_));
 sg13g2_nand3_1 _3083_ (.B(_1876_),
    .C(_1911_),
    .A(_1873_),
    .Y(_1961_));
 sg13g2_nand3_1 _3084_ (.B(_1912_),
    .C(_1961_),
    .A(net97),
    .Y(_1962_));
 sg13g2_a21oi_1 _3085_ (.A1(net63),
    .A2(_1960_),
    .Y(_1963_),
    .B1(net67));
 sg13g2_a22oi_1 _3086_ (.Y(_0277_),
    .B1(_1962_),
    .B2(_1963_),
    .A2(net113),
    .A1(_0534_));
 sg13g2_inv_1 _3087_ (.Y(_0461_),
    .A(\pll_dig.flock.cnt_cap[6] ));
 sg13g2_nor2_1 _3088_ (.A(\pll_dig.div.div[6] ),
    .B(_0616_),
    .Y(_0623_));
 sg13g2_nor2_1 _3089_ (.A(_1870_),
    .B(_1883_),
    .Y(_1964_));
 sg13g2_nor2_1 _3090_ (.A(_1902_),
    .B(_1964_),
    .Y(_1965_));
 sg13g2_nand3_1 _3091_ (.B(_1872_),
    .C(_1912_),
    .A(_1870_),
    .Y(_1966_));
 sg13g2_and2_1 _3092_ (.A(_1913_),
    .B(_1966_),
    .X(_1967_));
 sg13g2_a221oi_1 _3093_ (.B2(net97),
    .C1(net67),
    .B1(_1967_),
    .A1(_1884_),
    .Y(_1968_),
    .A2(_1965_));
 sg13g2_a21oi_1 _3094_ (.A1(_0531_),
    .A2(net113),
    .Y(_0279_),
    .B1(_1968_));
 sg13g2_xnor2_1 _3095_ (.Y(_1969_),
    .A(\pll_dig.dlf.INT[0] ),
    .B(net14));
 sg13g2_a221oi_1 _3096_ (.B2(_1969_),
    .C1(net112),
    .B1(_1932_),
    .A1(_0463_),
    .Y(_1970_),
    .A2(_1901_));
 sg13g2_a21o_1 _3097_ (.A2(net112),
    .A1(\pll_dig.dlf.INT[0] ),
    .B1(_1970_),
    .X(_0280_));
 sg13g2_nand3_1 _3098_ (.B(net14),
    .C(_1879_),
    .A(_0525_),
    .Y(_1971_));
 sg13g2_o21ai_1 _3099_ (.B1(_0618_),
    .Y(_0624_),
    .A1(\pll_dig.div.div[7] ),
    .A2(_0596_));
 sg13g2_nand3b_1 _3100_ (.B(_1903_),
    .C(_1971_),
    .Y(_1972_),
    .A_N(_1880_));
 sg13g2_a21o_1 _3101_ (.A2(net14),
    .A1(net979),
    .B1(_1879_),
    .X(_1973_));
 sg13g2_nand3_1 _3102_ (.B(_1910_),
    .C(_1973_),
    .A(net97),
    .Y(_1974_));
 sg13g2_and2_1 _3103_ (.A(_1934_),
    .B(_1972_),
    .X(_1975_));
 sg13g2_a22oi_1 _3104_ (.Y(_0281_),
    .B1(_1974_),
    .B2(_1975_),
    .A2(net112),
    .A1(_0471_));
 sg13g2_or3_1 _3105_ (.A(_1877_),
    .B(_1878_),
    .C(_1880_),
    .X(_1976_));
 sg13g2_nor2b_1 _3106_ (.A(_1902_),
    .B_N(_1881_),
    .Y(_1977_));
 sg13g2_nand3_1 _3107_ (.B(_1909_),
    .C(_1910_),
    .A(_1877_),
    .Y(_1978_));
 sg13g2_and2_1 _3108_ (.A(_1911_),
    .B(_1978_),
    .X(_1979_));
 sg13g2_a221oi_1 _3109_ (.B2(net97),
    .C1(net67),
    .B1(_1979_),
    .A1(_1976_),
    .Y(_1980_),
    .A2(_1977_));
 sg13g2_nor3_2 _3110_ (.A(_0622_),
    .B(_0623_),
    .C(_0624_),
    .Y(_0625_));
 sg13g2_a21oi_1 _3111_ (.A1(_0535_),
    .A2(net112),
    .Y(_0283_),
    .B1(_1980_));
 sg13g2_xor2_1 _3112_ (.B(_1908_),
    .A(_1888_),
    .X(_1981_));
 sg13g2_nand3_1 _3113_ (.B(_1908_),
    .C(_1915_),
    .A(_1864_),
    .Y(_1982_));
 sg13g2_and2_1 _3114_ (.A(_1916_),
    .B(_1982_),
    .X(_1983_));
 sg13g2_a221oi_1 _3115_ (.B2(net96),
    .C1(net66),
    .B1(_1983_),
    .A1(_1903_),
    .Y(_1984_),
    .A2(_1981_));
 sg13g2_a21oi_1 _3116_ (.A1(_0526_),
    .A2(net114),
    .Y(_0286_),
    .B1(_1984_));
 sg13g2_xor2_1 _3117_ (.B(_1885_),
    .A(_1868_),
    .X(_1985_));
 sg13g2_nand3_1 _3118_ (.B(_1869_),
    .C(_1913_),
    .A(_1868_),
    .Y(_1986_));
 sg13g2_and2_1 _3119_ (.A(_1914_),
    .B(_1986_),
    .X(_1987_));
 sg13g2_a221oi_1 _3120_ (.B2(_1846_),
    .C1(net67),
    .B1(_1987_),
    .A1(_1903_),
    .Y(_1988_),
    .A2(_1985_));
 sg13g2_nor2b_1 _3121_ (.A(_0596_),
    .B_N(net437),
    .Y(_0044_));
 sg13g2_a21oi_1 _3122_ (.A1(_0532_),
    .A2(net113),
    .Y(_0291_),
    .B1(_1988_));
 sg13g2_nand3_1 _3123_ (.B(_0129_),
    .C(_1929_),
    .A(_0524_),
    .Y(_1989_));
 sg13g2_nor2b_1 _3124_ (.A(_1846_),
    .B_N(_1848_),
    .Y(_1990_));
 sg13g2_a221oi_1 _3125_ (.B2(_1900_),
    .C1(net112),
    .B1(_1990_),
    .A1(\SS_BBPD[1] ),
    .Y(_1991_),
    .A2(_1989_));
 sg13g2_a21o_1 _3126_ (.A2(net112),
    .A1(_0129_),
    .B1(_1991_),
    .X(_0293_));
 sg13g2_xnor2_1 _3127_ (.Y(_1992_),
    .A(_1861_),
    .B(_1889_));
 sg13g2_nand3_1 _3128_ (.B(_1916_),
    .C(_1917_),
    .A(_1861_),
    .Y(_1993_));
 sg13g2_and2_1 _3129_ (.A(_1918_),
    .B(_1993_),
    .X(_1994_));
 sg13g2_a221oi_1 _3130_ (.B2(net96),
    .C1(net66),
    .B1(_1994_),
    .A1(net63),
    .Y(_1995_),
    .A2(_1992_));
 sg13g2_a21oi_1 _3131_ (.A1(_0568_),
    .A2(net114),
    .Y(_0294_),
    .B1(net1073));
 sg13g2_and2_1 _3132_ (.A(\pll_dig.div.div[7] ),
    .B(net432),
    .X(_0626_));
 sg13g2_or3_1 _3133_ (.A(_1849_),
    .B(_1851_),
    .C(_1898_),
    .X(_1996_));
 sg13g2_nand3_1 _3134_ (.B(net63),
    .C(_1996_),
    .A(_1899_),
    .Y(_1997_));
 sg13g2_nand3_1 _3135_ (.B(_1905_),
    .C(_1927_),
    .A(_1849_),
    .Y(_1998_));
 sg13g2_nor2b_1 _3136_ (.A(_1928_),
    .B_N(_1998_),
    .Y(_1999_));
 sg13g2_a21oi_1 _3137_ (.A1(net96),
    .A2(_1999_),
    .Y(_2000_),
    .B1(net66));
 sg13g2_a22oi_1 _3138_ (.Y(_0295_),
    .B1(_1997_),
    .B2(_2000_),
    .A2(net114),
    .A1(_0520_));
 sg13g2_xor2_1 _3139_ (.B(_1892_),
    .A(_1857_),
    .X(_2001_));
 sg13g2_nand3_1 _3140_ (.B(_1919_),
    .C(_1920_),
    .A(_1857_),
    .Y(_2002_));
 sg13g2_and2_1 _3141_ (.A(_1921_),
    .B(_2002_),
    .X(_2003_));
 sg13g2_a221oi_1 _3142_ (.B2(net97),
    .C1(net66),
    .B1(_2003_),
    .A1(net63),
    .Y(_2004_),
    .A2(_2001_));
 sg13g2_a21o_2 _3143_ (.A2(_0626_),
    .A1(_0596_),
    .B1(_0625_),
    .X(_0627_));
 sg13g2_a21oi_1 _3144_ (.A1(_0530_),
    .A2(net114),
    .Y(_0298_),
    .B1(_2004_));
 sg13g2_nand2_1 _3145_ (.Y(_2005_),
    .A(_1116_),
    .B(_1174_));
 sg13g2_nand2_1 _3146_ (.Y(_2006_),
    .A(\SS_BBPD[0] ),
    .B(_1204_));
 sg13g2_nor2_1 _3147_ (.A(net117),
    .B(net115),
    .Y(_2007_));
 sg13g2_a22oi_1 _3148_ (.Y(_0187_),
    .B1(_2006_),
    .B2(_2007_),
    .A2(_2005_),
    .A1(net115));
 sg13g2_nand2_1 _3149_ (.Y(_2008_),
    .A(net431),
    .B(net420));
 sg13g2_o21ai_1 _3150_ (.B1(_2008_),
    .Y(_2009_),
    .A1(net420),
    .A2(_1097_));
 sg13g2_and2_1 _3151_ (.A(_0332_),
    .B(_2009_),
    .X(_0206_));
 sg13g2_o21ai_1 _3152_ (.B1(net912),
    .Y(_2010_),
    .A1(\pll_dig.state[4] ),
    .A2(\pll_dig.state[2] ));
 sg13g2_xnor2_1 _3153_ (.Y(_0307_),
    .A(\pll_dig.clr_toggle ),
    .B(net913));
 sg13g2_nor2b_1 _3154_ (.A(_0616_),
    .B_N(_0627_),
    .Y(_0043_));
 sg13g2_a21o_1 _3155_ (.A2(\pll_dig.div.use_clk ),
    .A1(_0472_),
    .B1(\pll_dig.div.enter_req ),
    .X(_0333_));
 sg13g2_a21oi_1 _3156_ (.A1(net911),
    .A2(_1655_),
    .Y(_2011_),
    .B1(_1632_));
 sg13g2_and2_1 _3157_ (.A(net953),
    .B(_2011_),
    .X(_2012_));
 sg13g2_and2_1 _3158_ (.A(net958),
    .B(_2012_),
    .X(_2013_));
 sg13g2_and2_1 _3159_ (.A(net950),
    .B(_2013_),
    .X(_2014_));
 sg13g2_and2_1 _3160_ (.A(net944),
    .B(net951),
    .X(_2015_));
 sg13g2_and2_1 _3161_ (.A(net980),
    .B(_2015_),
    .X(_2016_));
 sg13g2_and2_1 _3162_ (.A(net955),
    .B(_2016_),
    .X(_2017_));
 sg13g2_nor2_1 _3163_ (.A(\pll_dig.cnt[6] ),
    .B(net956),
    .Y(_2018_));
 sg13g2_nor2_1 _3164_ (.A(\pll_dig.ILL_P ),
    .B(_1673_),
    .Y(_2019_));
 sg13g2_nor2b_1 _3165_ (.A(_0613_),
    .B_N(_0627_),
    .Y(_0042_));
 sg13g2_nor3_1 _3166_ (.A(net917),
    .B(net929),
    .C(_1673_),
    .Y(_2020_));
 sg13g2_nor3_1 _3167_ (.A(net944),
    .B(net992),
    .C(net983),
    .Y(_2021_));
 sg13g2_nor2_1 _3168_ (.A(_2020_),
    .B(_2021_),
    .Y(_2022_));
 sg13g2_and2_1 _3169_ (.A(_2011_),
    .B(_2022_),
    .X(_2023_));
 sg13g2_nand2_1 _3170_ (.Y(_2024_),
    .A(_2011_),
    .B(_2022_));
 sg13g2_nand2_1 _3171_ (.Y(_2025_),
    .A(net926),
    .B(_2017_));
 sg13g2_nand2_1 _3172_ (.Y(_2026_),
    .A(_2024_),
    .B(net927));
 sg13g2_nor2_1 _3173_ (.A(_2018_),
    .B(_2026_),
    .Y(_0337_));
 sg13g2_nor2_1 _3174_ (.A(\pll_dig.cnt[2] ),
    .B(_2013_),
    .Y(_2027_));
 sg13g2_nor3_1 _3175_ (.A(net951),
    .B(_2023_),
    .C(_2027_),
    .Y(_0338_));
 sg13g2_nor2b_1 _3176_ (.A(_0597_),
    .B_N(_0627_),
    .Y(_0041_));
 sg13g2_nand2b_1 _3177_ (.Y(_2028_),
    .B(\pll_dig.FORCE_P ),
    .A_N(\pll_dig.state[2] ));
 sg13g2_nand2_1 _3178_ (.Y(_2029_),
    .A(net929),
    .B(_1842_));
 sg13g2_o21ai_1 _3179_ (.B1(_2028_),
    .Y(_0339_),
    .A1(_1673_),
    .A2(net930));
 sg13g2_nand2_1 _3180_ (.Y(_0345_),
    .A(_0220_),
    .B(net911));
 sg13g2_nor2_1 _3181_ (.A(\pll_dig.FREQ_OK ),
    .B(\pll_dig.FREQ_ERR ),
    .Y(_2030_));
 sg13g2_or2_1 _3182_ (.X(_0247_),
    .B(net911),
    .A(net944));
 sg13g2_nand2_1 _3183_ (.Y(_2031_),
    .A(net932),
    .B(_0247_));
 sg13g2_a21oi_1 _3184_ (.A1(_1609_),
    .A2(_2030_),
    .Y(_2032_),
    .B1(_2031_));
 sg13g2_a21oi_1 _3185_ (.A1(net932),
    .A2(net911),
    .Y(_2033_),
    .B1(_1654_));
 sg13g2_a21oi_1 _3186_ (.A1(_0464_),
    .A2(_2033_),
    .Y(_0346_),
    .B1(_2032_));
 sg13g2_nor2b_1 _3187_ (.A(_0598_),
    .B_N(_0627_),
    .Y(_0040_));
 sg13g2_or2_1 _3188_ (.X(_0347_),
    .B(_1654_),
    .A(\pll_dig.ENABLE ));
 sg13g2_or2_1 _3189_ (.X(_0348_),
    .B(net57),
    .A(net910));
 sg13g2_nor3_2 _3190_ (.A(\pll_dig.div.div_pend[0] ),
    .B(net398),
    .C(_1097_),
    .Y(_2034_));
 sg13g2_nor2b_1 _3191_ (.A(net149),
    .B_N(net431),
    .Y(_2035_));
 sg13g2_a21oi_1 _3192_ (.A1(net398),
    .A2(_2035_),
    .Y(_0217_),
    .B1(_2034_));
 sg13g2_nor2b_1 _3193_ (.A(_1672_),
    .B_N(_1628_),
    .Y(_2036_));
 sg13g2_a21oi_1 _3194_ (.A1(net934),
    .A2(_2036_),
    .Y(_2037_),
    .B1(\pll_dig.LOCK_LOST ));
 sg13g2_o21ai_1 _3195_ (.B1(_1623_),
    .Y(_2038_),
    .A1(\SS_BBPD[1] ),
    .A2(\pll_dig.lock_detector.seen_n ));
 sg13g2_nor2_1 _3196_ (.A(_1658_),
    .B(_2038_),
    .Y(_2039_));
 sg13g2_o21ai_1 _3197_ (.B1(\pll_dig.ENABLE ),
    .Y(_2040_),
    .A1(_1658_),
    .A2(_2038_));
 sg13g2_inv_1 _3198_ (.Y(_0446_),
    .A(\pll_dig.div.ncnt[1] ));
 sg13g2_inv_1 _3199_ (.Y(_0462_),
    .A(\SS_BBPD[0] ));
 sg13g2_nor2b_1 _3200_ (.A(_0604_),
    .B_N(_0627_),
    .Y(_0039_));
 sg13g2_a21oi_1 _3201_ (.A1(_2036_),
    .A2(_2040_),
    .Y(_0371_),
    .B1(net935));
 sg13g2_nand2b_1 _3202_ (.Y(_2041_),
    .B(_1843_),
    .A_N(_1838_));
 sg13g2_a21oi_1 _3203_ (.A1(_1834_),
    .A2(_2041_),
    .Y(_2042_),
    .B1(_0559_));
 sg13g2_nand2_1 _3204_ (.Y(_2043_),
    .A(_1834_),
    .B(_1843_));
 sg13g2_nand4_1 _3205_ (.B(_1834_),
    .C(_1838_),
    .A(_0559_),
    .Y(_2044_),
    .D(_1843_));
 sg13g2_nand2b_1 _3206_ (.Y(_0376_),
    .B(net971),
    .A_N(_2042_));
 sg13g2_nand2_1 _3207_ (.Y(_2045_),
    .A(\pll_dig.cntf[1] ),
    .B(_1835_));
 sg13g2_xnor2_1 _3208_ (.Y(_2046_),
    .A(net945),
    .B(\pll_dig.cntf[1] ));
 sg13g2_o21ai_1 _3209_ (.B1(_2045_),
    .Y(_0377_),
    .A1(_2043_),
    .A2(_2046_));
 sg13g2_o21ai_1 _3210_ (.B1(_2024_),
    .Y(_2047_),
    .A1(\pll_dig.cnt[5] ),
    .A2(_2016_));
 sg13g2_nor2b_1 _3211_ (.A(\pll_dig.div.ncnt[0] ),
    .B_N(_0627_),
    .Y(_0037_));
 sg13g2_nor2_1 _3212_ (.A(net956),
    .B(net981),
    .Y(_0378_));
 sg13g2_nor2_1 _3213_ (.A(\pll_dig.cnt[1] ),
    .B(_2012_),
    .Y(_2048_));
 sg13g2_nor3_1 _3214_ (.A(_2013_),
    .B(_2023_),
    .C(_2048_),
    .Y(_0379_));
 sg13g2_nand2b_1 _3215_ (.Y(_2049_),
    .B(_1673_),
    .A_N(_1655_));
 sg13g2_nor2_1 _3216_ (.A(_1632_),
    .B(_2049_),
    .Y(_2050_));
 sg13g2_a21oi_1 _3217_ (.A1(_0557_),
    .A2(_2049_),
    .Y(_0380_),
    .B1(_2050_));
 sg13g2_a21oi_1 _3218_ (.A1(_1834_),
    .A2(_1837_),
    .Y(_2051_),
    .B1(\pll_dig.cntf[4] ));
 sg13g2_a21oi_1 _3219_ (.A1(_1834_),
    .A2(_2041_),
    .Y(_0381_),
    .B1(_2051_));
 sg13g2_nand2_1 _3220_ (.Y(_2052_),
    .A(\pll_dig.cntf[0] ),
    .B(_1835_));
 sg13g2_o21ai_1 _3221_ (.B1(_2052_),
    .Y(_0382_),
    .A1(\pll_dig.cntf[0] ),
    .A2(_2043_));
 sg13g2_nor4_1 _3222_ (.A(\pll_dig.flock.cnt_filt[13] ),
    .B(\pll_dig.flock.cnt_filt[12] ),
    .C(\pll_dig.flock.cnt_filt[15] ),
    .D(\pll_dig.flock.cnt_filt[14] ),
    .Y(_0628_));
 sg13g2_a22oi_1 _3223_ (.Y(_2053_),
    .B1(_2024_),
    .B2(\pll_dig.cnt[4] ),
    .A2(_2020_),
    .A1(_2015_));
 sg13g2_nor2_1 _3224_ (.A(_2016_),
    .B(_2053_),
    .Y(_0383_));
 sg13g2_nor2_1 _3225_ (.A(\pll_dig.cnt[0] ),
    .B(_2011_),
    .Y(_2054_));
 sg13g2_nor3_1 _3226_ (.A(_2012_),
    .B(_2023_),
    .C(_2054_),
    .Y(_0384_));
 sg13g2_a21oi_1 _3227_ (.A1(_1836_),
    .A2(_1843_),
    .Y(_2055_),
    .B1(_1835_));
 sg13g2_nand3_1 _3228_ (.B(net937),
    .C(_1834_),
    .A(\pll_dig.cntf[0] ),
    .Y(_2056_));
 sg13g2_a21oi_1 _3229_ (.A1(_0465_),
    .A2(net938),
    .Y(_0387_),
    .B1(_2055_));
 sg13g2_xor2_1 _3230_ (.B(_0128_),
    .A(\pll_dig.div.div_pend[0] ),
    .X(_2057_));
 sg13g2_nand2_1 _3231_ (.Y(_2058_),
    .A(net431),
    .B(_1745_));
 sg13g2_a21oi_1 _3232_ (.A1(_1098_),
    .A2(_2057_),
    .Y(_2059_),
    .B1(net420));
 sg13g2_or2_1 _3233_ (.X(_0629_),
    .B(\pll_dig.flock.cnt_filt[10] ),
    .A(\pll_dig.flock.cnt_filt[11] ));
 sg13g2_a21oi_1 _3234_ (.A1(net420),
    .A2(_2058_),
    .Y(_0233_),
    .B1(_2059_));
 sg13g2_nand3_1 _3235_ (.B(_2036_),
    .C(_2039_),
    .A(net940),
    .Y(_2060_));
 sg13g2_o21ai_1 _3236_ (.B1(net941),
    .Y(_0415_),
    .A1(_0577_),
    .A2(_2036_));
 sg13g2_nor2b_1 _3237_ (.A(_1844_),
    .B_N(\pll_dig.cntf[7] ),
    .Y(_2061_));
 sg13g2_nor3_1 _3238_ (.A(\pll_dig.cntf[7] ),
    .B(net961),
    .C(_2043_),
    .Y(_2062_));
 sg13g2_or2_1 _3239_ (.X(_0426_),
    .B(net962),
    .A(_2061_));
 sg13g2_or3_1 _3240_ (.A(\pll_dig.cntf[3] ),
    .B(_1836_),
    .C(_2043_),
    .X(_2063_));
 sg13g2_o21ai_1 _3241_ (.B1(net966),
    .Y(_0427_),
    .A1(_0466_),
    .A2(_2055_));
 sg13g2_o21ai_1 _3242_ (.B1(_0470_),
    .Y(_2064_),
    .A1(_2020_),
    .A2(_2021_));
 sg13g2_a22oi_1 _3243_ (.Y(_0428_),
    .B1(_2026_),
    .B2(_2064_),
    .A2(net927),
    .A1(_0470_));
 sg13g2_nor3_1 _3244_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .C(_0629_),
    .Y(_0630_));
 sg13g2_nor2_1 _3245_ (.A(\pll_dig.cnt[3] ),
    .B(net951),
    .Y(_2065_));
 sg13g2_nor3_1 _3246_ (.A(_2015_),
    .B(_2023_),
    .C(_2065_),
    .Y(_0429_));
 sg13g2_nand3_1 _3247_ (.B(_1842_),
    .C(_2019_),
    .A(net917),
    .Y(_2066_));
 sg13g2_o21ai_1 _3248_ (.B1(net918),
    .Y(_0430_),
    .A1(_0490_),
    .A2(\pll_dig.state[2] ));
 sg13g2_inv_1 _3249__325 (.Y(net324),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3250__321 (.Y(net320),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_nand2_1 _3251_ (.Y(_0631_),
    .A(_0628_),
    .B(_0630_));
 sg13g2_inv_1 _3252__317 (.Y(net316),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3253__313 (.Y(net312),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3254__309 (.Y(net308),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3255__292 (.Y(net291),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3256__287 (.Y(net286),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3257__274 (.Y(net273),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3258__334 (.Y(net333),
    .A(clknet_4_15_0_net59_regs));
 sg13g2_inv_1 _3259__288 (.Y(net287),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3260__289 (.Y(net288),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3261__335 (.Y(net334),
    .A(clknet_4_7_0_net59_regs));
 sg13g2_a22oi_1 _3262_ (.Y(_0632_),
    .B1(_0476_),
    .B2(net139),
    .A2(_0453_),
    .A1(\pll_dig.flock.cnt_filt[6] ));
 sg13g2_inv_1 _3263__314 (.Y(net313),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3264__275 (.Y(net274),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3265__324 (.Y(net323),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3266__320 (.Y(net319),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3267__316 (.Y(net315),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3268__312 (.Y(net311),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3269__327 (.Y(net326),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3270__323 (.Y(net322),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3271__319 (.Y(net318),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3272__315 (.Y(net314),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_a22oi_1 _3273_ (.Y(_0633_),
    .B1(net10),
    .B2(_0552_),
    .A2(net11),
    .A1(_0449_));
 sg13g2_inv_1 _3274__311 (.Y(net310),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3275__291 (.Y(net290),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3276__286 (.Y(net285),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3277__330 (.Y(net329),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3278__329 (.Y(net328),
    .A(clknet_4_3_0_INJ_EDGE));
 sg13g2_inv_1 _3279__328 (.Y(net327),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_inv_1 _3280__331 (.Y(net330),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3281__326 (.Y(net325),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3282__322 (.Y(net321),
    .A(clknet_4_0_0_INJ_EDGE));
 sg13g2_inv_1 _3283__318 (.Y(net317),
    .A(clknet_4_1_0_INJ_EDGE));
 sg13g2_nor2_1 _3284_ (.A(_0450_),
    .B(net9),
    .Y(_0634_));
 sg13g2_inv_1 _3285__256 (.Y(net255),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3286__336 (.Y(net335),
    .A(clknet_4_8_0_net59_regs));
 sg13g2_inv_1 _3287__332 (.Y(net331),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3288__337 (.Y(net336),
    .A(clknet_4_6_0_net59_regs));
 sg13g2_inv_1 _3289__338 (.Y(net337),
    .A(clknet_4_7_0_net59_regs));
 sg13g2_inv_1 _3290__273 (.Y(net272),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3291__278 (.Y(net277),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3292__271 (.Y(net270),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3293__270 (.Y(net269),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3294__284 (.Y(net283),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_a21oi_1 _3295_ (.A1(_0500_),
    .A2(\pll_dig.flock.cnt_filt[5] ),
    .Y(_0635_),
    .B1(_0634_));
 sg13g2_inv_1 _3296__268 (.Y(net267),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3297__266 (.Y(net265),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3298__264 (.Y(net263),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3299__262 (.Y(net261),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3300__260 (.Y(net259),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3301__258 (.Y(net257),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3302__279 (.Y(net278),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_inv_1 _3303__267 (.Y(net266),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3304__265 (.Y(net264),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3305__261 (.Y(net260),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3306_ (.Y(_0463_),
    .A(\SS_BBPD[1] ));
 sg13g2_a22oi_1 _3307_ (.Y(_0636_),
    .B1(net8),
    .B2(_0451_),
    .A2(net9),
    .A1(_0450_));
 sg13g2_inv_1 _3308__259 (.Y(net258),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3309__257 (.Y(net256),
    .A(clknet_4_5_0_INJ_EDGE));
 sg13g2_inv_1 _3310__285 (.Y(net284),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3311__276 (.Y(net275),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_inv_1 _3312__339 (.Y(net338),
    .A(clknet_4_14_0_net59_regs));
 sg13g2_inv_1 _3313__282 (.Y(net281),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3314__340 (.Y(net339),
    .A(clknet_4_15_0_net59_regs));
 sg13g2_inv_1 _3315__341 (.Y(net340),
    .A(clknet_4_13_0_net59_regs));
 sg13g2_inv_1 _3316__263 (.Y(net262),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3317__269 (.Y(net268),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_nor2_1 _3318_ (.A(_0486_),
    .B(net6),
    .Y(_0637_));
 sg13g2_inv_1 _3319__281 (.Y(net280),
    .A(clknet_4_13_0_INJ_EDGE));
 sg13g2_inv_1 _3320__272 (.Y(net271),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3321__298 (.Y(net297),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3322__294 (.Y(net293),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3323__300 (.Y(net299),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3324__293 (.Y(net292),
    .A(clknet_4_12_0_INJ_EDGE));
 sg13g2_inv_1 _3325__303 (.Y(net302),
    .A(clknet_4_11_0_INJ_EDGE));
 sg13g2_inv_1 _3326__301 (.Y(net300),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3327__306 (.Y(net305),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3328__307 (.Y(net306),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_a22oi_1 _3329_ (.Y(_0638_),
    .B1(_0550_),
    .B2(net5),
    .A2(net6),
    .A1(_0486_));
 sg13g2_inv_1 _3330__308 (.Y(net307),
    .A(clknet_4_15_0_INJ_EDGE));
 sg13g2_inv_1 _3331__304 (.Y(net303),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3332__305 (.Y(net304),
    .A(clknet_4_14_0_INJ_EDGE));
 sg13g2_inv_1 _3333__299 (.Y(net298),
    .A(clknet_4_10_0_INJ_EDGE));
 sg13g2_inv_1 _3334__302 (.Y(net301),
    .A(clknet_4_9_0_INJ_EDGE));
 sg13g2_inv_1 _3335__295 (.Y(net294),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3336__297 (.Y(net296),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3337__296 (.Y(net295),
    .A(clknet_4_8_0_INJ_EDGE));
 sg13g2_inv_1 _3338__310 (.Y(net309),
    .A(clknet_4_7_0_INJ_EDGE));
 sg13g2_inv_1 _3339__277 (.Y(net276),
    .A(clknet_4_2_0_INJ_EDGE));
 sg13g2_nor2_1 _3340_ (.A(_0637_),
    .B(_0638_),
    .Y(_0639_));
 sg13g2_inv_1 _3341__283 (.Y(net282),
    .A(clknet_4_6_0_INJ_EDGE));
 sg13g2_inv_1 _3342__280 (.Y(net279),
    .A(clknet_4_4_0_INJ_EDGE));
 sg13g2_mux2_1 _3343_ (.A0(\pll_dig.div.div_pend[2] ),
    .A1(net147),
    .S(net428),
    .X(\pll_dig.div.low_count_pend[1] ));
 sg13g2_mux2_1 _3344_ (.A0(\pll_dig.div.div_pend[3] ),
    .A1(net145),
    .S(net428),
    .X(\pll_dig.div.low_count_pend[2] ));
 sg13g2_mux2_1 _3345_ (.A0(\pll_dig.div.div_pend[4] ),
    .A1(net144),
    .S(net92),
    .X(\pll_dig.div.low_count_pend[3] ));
 sg13g2_mux2_1 _3346_ (.A0(\pll_dig.div.div_pend[5] ),
    .A1(net142),
    .S(net424),
    .X(\pll_dig.div.low_count_pend[4] ));
 sg13g2_mux2_1 _3347_ (.A0(\pll_dig.div.div_pend[6] ),
    .A1(net141),
    .S(net424),
    .X(\pll_dig.div.low_count_pend[5] ));
 sg13g2_mux2_1 _3348_ (.A0(\pll_dig.div.div_pend[7] ),
    .A1(\pll_dig.div.div[7] ),
    .S(net426),
    .X(\pll_dig.div.low_count_pend[6] ));
 sg13g2_buf_1 _3349_ (.A(_0134_),
    .X(_0221_));
 sg13g2_nor2_1 _3350_ (.A(_0480_),
    .B(net140),
    .Y(_0640_));
 sg13g2_a22oi_1 _3351_ (.Y(_0641_),
    .B1(_0556_),
    .B2(\pll_dig.flock.cnt_filt[3] ),
    .A2(net140),
    .A1(_0480_));
 sg13g2_o21ai_1 _3352_ (.B1(_0641_),
    .Y(_0642_),
    .A1(_0639_),
    .A2(_0640_));
 sg13g2_a221oi_1 _3353_ (.B2(_0642_),
    .C1(_0634_),
    .B1(_0636_),
    .A1(_0500_),
    .Y(_0643_),
    .A2(\pll_dig.flock.cnt_filt[5] ));
 sg13g2_nand2b_1 _3354_ (.Y(_0644_),
    .B(_0633_),
    .A_N(_0643_));
 sg13g2_a22oi_1 _3355_ (.Y(_0645_),
    .B1(_0632_),
    .B2(_0644_),
    .A2(net12),
    .A1(_0448_));
 sg13g2_inv_1 _3356_ (.Y(_0464_),
    .A(net997));
 sg13g2_nor2_1 _3357_ (.A(_0631_),
    .B(_0645_),
    .Y(_0646_));
 sg13g2_nand2_1 _3358_ (.Y(_0647_),
    .A(net901),
    .B(\pll_dig.PHASE_LOCK ));
 sg13g2_nand4_1 _3359_ (.B(_0636_),
    .C(_0638_),
    .A(_0635_),
    .Y(_0648_),
    .D(_0641_));
 sg13g2_a21oi_1 _3360_ (.A1(_0096_),
    .A2(\pll_dig.flock.cnt_filt[0] ),
    .Y(_0649_),
    .B1(_0637_));
 sg13g2_a21oi_1 _3361_ (.A1(_0448_),
    .A2(net12),
    .Y(_0650_),
    .B1(_0640_));
 sg13g2_nand4_1 _3362_ (.B(_0633_),
    .C(_0649_),
    .A(_0632_),
    .Y(_0651_),
    .D(_0650_));
 sg13g2_nor3_1 _3363_ (.A(_0631_),
    .B(_0648_),
    .C(_0651_),
    .Y(_0652_));
 sg13g2_nor2_1 _3364_ (.A(_0646_),
    .B(_0652_),
    .Y(_0653_));
 sg13g2_a21oi_1 _3365_ (.A1(net902),
    .A2(_0653_),
    .Y(_0654_),
    .B1(\pll_dig.FORCE_P ));
 sg13g2_nor2b_1 _3366_ (.A(net903),
    .B_N(\pll_dig.flock.started ),
    .Y(_0655_));
 sg13g2_inv_1 _3367_ (.Y(_0465_),
    .A(\pll_dig.cntf[2] ));
 sg13g2_nand2_1 _3368_ (.Y(_0656_),
    .A(_0646_),
    .B(net902));
 sg13g2_nand2_1 _3369_ (.Y(_0657_),
    .A(_0490_),
    .B(_0656_));
 sg13g2_and2_1 _3370_ (.A(\pll_dig.flock.started ),
    .B(_0657_),
    .X(_0658_));
 sg13g2_nand2_1 _3371_ (.Y(_0659_),
    .A(\pll_dig.flock.started ),
    .B(_0657_));
 sg13g2_nand2b_1 _3372_ (.Y(_0660_),
    .B(_0659_),
    .A_N(_0655_));
 sg13g2_nor2_1 _3373_ (.A(\pll_dig.flock.cnt_coarse_wait[0] ),
    .B(\pll_dig.flock.cnt_coarse_wait[1] ),
    .Y(_0661_));
 sg13g2_nand2b_1 _3374_ (.Y(_0662_),
    .B(_0661_),
    .A_N(\pll_dig.flock.cnt_coarse_wait[2] ));
 sg13g2_nor2_1 _3375_ (.A(\pll_dig.flock.cnt_coarse_wait[3] ),
    .B(_0662_),
    .Y(_0663_));
 sg13g2_nor3_1 _3376_ (.A(\pll_dig.flock.cnt_coarse_wait[4] ),
    .B(\pll_dig.flock.cnt_coarse_wait[3] ),
    .C(_0662_),
    .Y(_0664_));
 sg13g2_nor2b_1 _3377_ (.A(\pll_dig.flock.cnt_coarse_wait[5] ),
    .B_N(_0664_),
    .Y(_0665_));
 sg13g2_inv_1 _3378_ (.Y(_0466_),
    .A(net968));
 sg13g2_nor2b_1 _3379_ (.A(\pll_dig.flock.cnt_coarse_wait[6] ),
    .B_N(_0665_),
    .Y(_0666_));
 sg13g2_nor2b_1 _3380_ (.A(\pll_dig.flock.cnt_coarse_wait[7] ),
    .B_N(_0666_),
    .Y(_0667_));
 sg13g2_nand2b_1 _3381_ (.Y(_0668_),
    .B(_0666_),
    .A_N(\pll_dig.flock.cnt_coarse_wait[7] ));
 sg13g2_and3_1 _3382_ (.X(_0669_),
    .A(_0490_),
    .B(_0655_),
    .C(_0656_));
 sg13g2_nand2_1 _3383_ (.Y(_0670_),
    .A(\pll_dig.MID_MUX_D[14] ),
    .B(_0669_));
 sg13g2_nand2_1 _3384_ (.Y(_0671_),
    .A(_0492_),
    .B(_0658_));
 sg13g2_nand2_1 _3385_ (.Y(_0672_),
    .A(_0670_),
    .B(_0671_));
 sg13g2_nand2_1 _3386_ (.Y(_0673_),
    .A(_0668_),
    .B(_0672_));
 sg13g2_nand2_1 _3387_ (.Y(_0674_),
    .A(_0660_),
    .B(_0673_));
 sg13g2_nor2_1 _3388_ (.A(\pll_dig.FREQ_ERR ),
    .B(\pll_dig.FREQ_LOCKED ),
    .Y(_0675_));
 sg13g2_inv_1 _3389_ (.Y(_0000_),
    .A(\pll_dig.out_edges[1] ));
 sg13g2_o21ai_1 _3390_ (.B1(\pll_dig.START ),
    .Y(_0676_),
    .A1(\pll_dig.FREQ_ERR ),
    .A2(\pll_dig.FREQ_LOCKED ));
 sg13g2_nand3_1 _3391_ (.B(_0674_),
    .C(net111),
    .A(\pll_dig.flock.cnt_err[4] ),
    .Y(_0677_));
 sg13g2_nor3_1 _3392_ (.A(_0491_),
    .B(_0668_),
    .C(_0670_),
    .Y(_0678_));
 sg13g2_nor3_1 _3393_ (.A(\pll_dig.COARSE_MUX_D[0] ),
    .B(_0668_),
    .C(_0671_),
    .Y(_0679_));
 sg13g2_nor2_1 _3394_ (.A(_0678_),
    .B(_0679_),
    .Y(_0680_));
 sg13g2_nand3_1 _3395_ (.B(\pll_dig.flock.cnt_err[1] ),
    .C(\pll_dig.flock.cnt_err[0] ),
    .A(\pll_dig.flock.cnt_err[2] ),
    .Y(_0681_));
 sg13g2_nor2_1 _3396_ (.A(_0447_),
    .B(_0681_),
    .Y(_0682_));
 sg13g2_and2_1 _3397_ (.A(\pll_dig.flock.cnt_err[4] ),
    .B(_0682_),
    .X(_0683_));
 sg13g2_xnor2_1 _3398_ (.Y(_0684_),
    .A(\pll_dig.flock.cnt_err[4] ),
    .B(_0682_));
 sg13g2_o21ai_1 _3399_ (.B1(_0677_),
    .Y(_0033_),
    .A1(net80),
    .A2(_0684_));
 sg13g2_inv_1 _3400_ (.Y(\pll_dig.out_edges_next[0] ),
    .A(\pll_dig.out_edges[0] ));
 sg13g2_nand3_1 _3401_ (.B(_0674_),
    .C(net111),
    .A(\pll_dig.flock.cnt_err[3] ),
    .Y(_0685_));
 sg13g2_xnor2_1 _3402_ (.Y(_0686_),
    .A(_0447_),
    .B(_0681_));
 sg13g2_o21ai_1 _3403_ (.B1(_0685_),
    .Y(_0032_),
    .A1(net80),
    .A2(_0686_));
 sg13g2_nand3_1 _3404_ (.B(_0674_),
    .C(net111),
    .A(\pll_dig.flock.cnt_err[2] ),
    .Y(_0687_));
 sg13g2_a21o_1 _3405_ (.A2(\pll_dig.flock.cnt_err[0] ),
    .A1(\pll_dig.flock.cnt_err[1] ),
    .B1(\pll_dig.flock.cnt_err[2] ),
    .X(_0688_));
 sg13g2_nand2_1 _3406_ (.Y(_0689_),
    .A(_0681_),
    .B(_0688_));
 sg13g2_o21ai_1 _3407_ (.B1(_0687_),
    .Y(_0031_),
    .A1(net80),
    .A2(_0689_));
 sg13g2_nand2_1 _3408_ (.Y(_0690_),
    .A(\pll_dig.flock.cnt_err[0] ),
    .B(net111));
 sg13g2_nand2b_1 _3409_ (.Y(_0691_),
    .B(_0668_),
    .A_N(_0690_));
 sg13g2_nand3b_1 _3410_ (.B(\pll_dig.COARSE_MUX_D[14] ),
    .C(_0667_),
    .Y(_0692_),
    .A_N(\pll_dig.flock.cnt_err[0] ));
 sg13g2_inv_1 _3411_ (.Y(_0467_),
    .A(\pll_dig.dco_miss_cnt[2] ));
 sg13g2_a21oi_1 _3412_ (.A1(_0691_),
    .A2(_0692_),
    .Y(_0693_),
    .B1(_0670_));
 sg13g2_nand3b_1 _3413_ (.B(_0469_),
    .C(_0667_),
    .Y(_0694_),
    .A_N(\pll_dig.flock.cnt_err[0] ));
 sg13g2_a21oi_1 _3414_ (.A1(_0691_),
    .A2(_0694_),
    .Y(_0695_),
    .B1(_0671_));
 sg13g2_nor2_1 _3415_ (.A(_0693_),
    .B(_0695_),
    .Y(_0696_));
 sg13g2_o21ai_1 _3416_ (.B1(_0696_),
    .Y(_0029_),
    .A1(_0660_),
    .A2(_0690_));
 sg13g2_nor3_1 _3417_ (.A(net7),
    .B(net5),
    .C(net6),
    .Y(_0697_));
 sg13g2_o21ai_1 _3418_ (.B1(net7),
    .Y(_0698_),
    .A1(net5),
    .A2(net6));
 sg13g2_nand2b_1 _3419_ (.Y(_0121_),
    .B(_0698_),
    .A_N(_0697_));
 sg13g2_nand3_1 _3420_ (.B(net5),
    .C(net6),
    .A(net7),
    .Y(_0699_));
 sg13g2_nor2_1 _3421_ (.A(_0556_),
    .B(_0699_),
    .Y(_0700_));
 sg13g2_inv_1 _3422_ (.Y(_0468_),
    .A(\pll_dig.flock.cnt[8] ));
 sg13g2_nand3_1 _3423_ (.B(net9),
    .C(_0700_),
    .A(net10),
    .Y(_0701_));
 sg13g2_or2_1 _3424_ (.X(_0702_),
    .B(_0701_),
    .A(_0453_));
 sg13g2_xnor2_1 _3425_ (.Y(_0103_),
    .A(net11),
    .B(_0701_));
 sg13g2_and2_1 _3426_ (.A(net384),
    .B(\pll_dig.dsm_impl.FCWF[0] ),
    .X(_0703_));
 sg13g2_xor2_1 _3427_ (.B(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .A(\pll_dig.dsm_impl.FCWF[0] ),
    .X(_0704_));
 sg13g2_xnor2_1 _3428_ (.Y(_0705_),
    .A(_0704_),
    .B(\pll_dig.dsm_impl.dsm.cin_stg1 ));
 sg13g2_nor2_1 _3429_ (.A(_0487_),
    .B(_0705_),
    .Y(_0706_));
 sg13g2_nand2_1 _3430_ (.Y(_0707_),
    .A(_0487_),
    .B(_0705_));
 sg13g2_nand2b_1 _3431_ (.Y(_0708_),
    .B(_0707_),
    .A_N(_0706_));
 sg13g2_a21oi_1 _3432_ (.A1(\pll_dig.dsm_impl.dsm.cin_stg2 ),
    .A2(_0707_),
    .Y(_0709_),
    .B1(_0706_));
 sg13g2_inv_1 _3433_ (.Y(_0469_),
    .A(\pll_dig.COARSE_MUX_D[0] ));
 sg13g2_a21oi_2 _3434_ (.B1(_0703_),
    .Y(_0710_),
    .A2(\pll_dig.dsm_impl.dsm.cin_stg1 ),
    .A1(_0704_));
 sg13g2_nand2_1 _3435_ (.Y(_0711_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .B(\pll_dig.dsm_impl.FCWF[1] ));
 sg13g2_nor2_1 _3436_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .B(\pll_dig.dsm_impl.FCWF[1] ),
    .Y(_0712_));
 sg13g2_xor2_1 _3437_ (.B(\pll_dig.dsm_impl.FCWF[1] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .X(_0713_));
 sg13g2_xnor2_1 _3438_ (.Y(_0714_),
    .A(_0713_),
    .B(_0710_));
 sg13g2_nand2_1 _3439_ (.Y(_0715_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .B(net346));
 sg13g2_xnor2_1 _3440_ (.Y(_0716_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .B(_0714_));
 sg13g2_xor2_1 _3441_ (.B(_0709_),
    .A(_0716_),
    .X(_0717_));
 sg13g2_nand2_1 _3442_ (.Y(_0718_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .B(net350));
 sg13g2_xnor2_1 _3443_ (.Y(_0719_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .B(_0717_));
 sg13g2_inv_1 _3444_ (.Y(_0447_),
    .A(\pll_dig.flock.cnt_err[3] ));
 sg13g2_inv_1 _3445_ (.Y(_0470_),
    .A(\pll_dig.cnt[7] ));
 sg13g2_xnor2_1 _3446_ (.Y(_0720_),
    .A(\pll_dig.dsm_impl.dsm.cin_stg2 ),
    .B(_0708_));
 sg13g2_nand2_1 _3447_ (.Y(_0721_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .B(_0720_));
 sg13g2_xor2_1 _3448_ (.B(_0721_),
    .A(_0719_),
    .X(_0722_));
 sg13g2_mux2_1 _3449_ (.A0(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .A1(_0722_),
    .S(net98),
    .X(_0443_));
 sg13g2_and2_1 _3450_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .B(\pll_dig.dsm_impl.FCWF[6] ),
    .X(_0723_));
 sg13g2_nand2_1 _3451_ (.Y(_0724_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .B(\pll_dig.dsm_impl.FCWF[5] ));
 sg13g2_and2_1 _3452_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .B(\pll_dig.dsm_impl.FCWF[4] ),
    .X(_0725_));
 sg13g2_nand2_1 _3453_ (.Y(_0726_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .B(\pll_dig.dsm_impl.FCWF[3] ));
 sg13g2_and2_1 _3454_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .B(\pll_dig.dsm_impl.FCWF[2] ),
    .X(_0727_));
 sg13g2_o21ai_1 _3455_ (.B1(_0711_),
    .Y(_0728_),
    .A1(_0712_),
    .A2(_0710_));
 sg13g2_inv_1 _3456_ (.Y(_0471_),
    .A(net1002));
 sg13g2_xor2_1 _3457_ (.B(\pll_dig.dsm_impl.FCWF[2] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .X(_0729_));
 sg13g2_a21oi_2 _3458_ (.B1(_0727_),
    .Y(_0730_),
    .A2(_0728_),
    .A1(_0729_));
 sg13g2_nor2_1 _3459_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .B(\pll_dig.dsm_impl.FCWF[3] ),
    .Y(_0731_));
 sg13g2_xor2_1 _3460_ (.B(\pll_dig.dsm_impl.FCWF[3] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .X(_0732_));
 sg13g2_o21ai_1 _3461_ (.B1(_0726_),
    .Y(_0733_),
    .A1(_0731_),
    .A2(_0730_));
 sg13g2_xor2_1 _3462_ (.B(\pll_dig.dsm_impl.FCWF[4] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .X(_0734_));
 sg13g2_a21oi_2 _3463_ (.B1(_0725_),
    .Y(_0735_),
    .A2(_0733_),
    .A1(_0734_));
 sg13g2_xnor2_1 _3464_ (.Y(_0736_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .B(\pll_dig.dsm_impl.FCWF[5] ));
 sg13g2_o21ai_1 _3465_ (.B1(_0724_),
    .Y(_0737_),
    .A1(_0736_),
    .A2(_0735_));
 sg13g2_xor2_1 _3466_ (.B(\pll_dig.dsm_impl.FCWF[6] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .X(_0738_));
 sg13g2_inv_1 _3467_ (.Y(_0472_),
    .A(\pll_dig.div.leave_req ));
 sg13g2_a21oi_2 _3468_ (.B1(_0723_),
    .Y(_0739_),
    .A2(_0738_),
    .A1(_0737_));
 sg13g2_nand2_1 _3469_ (.Y(_0740_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(\pll_dig.dsm_impl.FCWF[7] ));
 sg13g2_xnor2_1 _3470_ (.Y(_0741_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .B(\pll_dig.dsm_impl.FCWF[7] ));
 sg13g2_xnor2_1 _3471_ (.Y(_0742_),
    .A(_0739_),
    .B(_0741_));
 sg13g2_nor2_1 _3472_ (.A(_0582_),
    .B(_0742_),
    .Y(_0743_));
 sg13g2_xnor2_1 _3473_ (.Y(_0744_),
    .A(_0738_),
    .B(_0737_));
 sg13g2_or2_1 _3474_ (.X(_0745_),
    .B(net351),
    .A(_0580_));
 sg13g2_xnor2_1 _3475_ (.Y(_0746_),
    .A(_0736_),
    .B(_0735_));
 sg13g2_nor2_1 _3476_ (.A(_0578_),
    .B(_0746_),
    .Y(_0747_));
 sg13g2_xnor2_1 _3477_ (.Y(_0748_),
    .A(_0734_),
    .B(_0733_));
 sg13g2_inv_1 _3478_ (.Y(_0473_),
    .A(net234));
 sg13g2_or2_1 _3479_ (.X(_0749_),
    .B(net361),
    .A(_0576_));
 sg13g2_xnor2_1 _3480_ (.Y(_0750_),
    .A(_0732_),
    .B(_0730_));
 sg13g2_and2_1 _3481_ (.A(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .B(net353),
    .X(_0751_));
 sg13g2_xnor2_1 _3482_ (.Y(_0752_),
    .A(_0729_),
    .B(_0728_));
 sg13g2_nor2_1 _3483_ (.A(_0498_),
    .B(net352),
    .Y(_0753_));
 sg13g2_o21ai_1 _3484_ (.B1(_0715_),
    .Y(_0754_),
    .A1(_0716_),
    .A2(_0709_));
 sg13g2_nand2_1 _3485_ (.Y(_0755_),
    .A(_0498_),
    .B(net352));
 sg13g2_xnor2_1 _3486_ (.Y(_0756_),
    .A(_0498_),
    .B(net352));
 sg13g2_a21o_1 _3487_ (.A2(_0755_),
    .A1(_0754_),
    .B1(_0753_),
    .X(_0757_));
 sg13g2_or2_1 _3488_ (.X(_0758_),
    .B(net354),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[3] ));
 sg13g2_inv_1 _3489_ (.Y(_0474_),
    .A(\pll_dig.flock.cnt_done[5] ));
 sg13g2_xnor2_1 _3490_ (.Y(_0759_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .B(_0750_));
 sg13g2_a21oi_1 _3491_ (.A1(_0757_),
    .A2(_0758_),
    .Y(_0760_),
    .B1(_0751_));
 sg13g2_a21o_1 _3492_ (.A2(_0758_),
    .A1(_0757_),
    .B1(_0751_),
    .X(_0761_));
 sg13g2_xnor2_1 _3493_ (.Y(_0762_),
    .A(_0748_),
    .B(_0576_));
 sg13g2_o21ai_1 _3494_ (.B1(_0749_),
    .Y(_0763_),
    .A1(_0762_),
    .A2(_0760_));
 sg13g2_nand2_1 _3495_ (.Y(_0764_),
    .A(_0578_),
    .B(_0746_));
 sg13g2_xnor2_1 _3496_ (.Y(_0765_),
    .A(_0578_),
    .B(_0746_));
 sg13g2_a21oi_2 _3497_ (.B1(_0747_),
    .Y(_0766_),
    .A2(_0764_),
    .A1(net379));
 sg13g2_a21o_1 _3498_ (.A2(_0764_),
    .A1(net359),
    .B1(_0747_),
    .X(_0767_));
 sg13g2_xnor2_1 _3499_ (.Y(_0768_),
    .A(_0744_),
    .B(_0580_));
 sg13g2_inv_1 _3500_ (.Y(_0475_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[8] ));
 sg13g2_o21ai_1 _3501_ (.B1(_0745_),
    .Y(_0769_),
    .A1(_0768_),
    .A2(_0766_));
 sg13g2_nand2_1 _3502_ (.Y(_0770_),
    .A(_0582_),
    .B(_0742_));
 sg13g2_xnor2_1 _3503_ (.Y(_0771_),
    .A(_0582_),
    .B(_0742_));
 sg13g2_a21oi_2 _3504_ (.B1(_0743_),
    .Y(_0772_),
    .A2(_0769_),
    .A1(_0770_));
 sg13g2_o21ai_1 _3505_ (.B1(_0740_),
    .Y(_0773_),
    .A1(_0739_),
    .A2(_0741_));
 sg13g2_and2_1 _3506_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .B(\pll_dig.dsm_impl.FCWF[8] ),
    .X(_0774_));
 sg13g2_xor2_1 _3507_ (.B(\pll_dig.dsm_impl.FCWF[8] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .X(_0775_));
 sg13g2_xnor2_1 _3508_ (.Y(_0776_),
    .A(_0775_),
    .B(_0773_));
 sg13g2_or2_1 _3509_ (.X(_0777_),
    .B(net362),
    .A(_0475_));
 sg13g2_xnor2_1 _3510_ (.Y(_0778_),
    .A(_0475_),
    .B(_0776_));
 sg13g2_inv_1 _3511_ (.Y(_0476_),
    .A(net12));
 sg13g2_xor2_1 _3512_ (.B(_0778_),
    .A(net375),
    .X(_0779_));
 sg13g2_and2_1 _3513_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .B(_0779_),
    .X(_0780_));
 sg13g2_or2_1 _3514_ (.X(_0781_),
    .B(_0779_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[8] ));
 sg13g2_nand2b_1 _3515_ (.Y(_0782_),
    .B(_0781_),
    .A_N(_0780_));
 sg13g2_xnor2_1 _3516_ (.Y(_0783_),
    .A(_0771_),
    .B(_0769_));
 sg13g2_nand2_1 _3517_ (.Y(_0784_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[7] ),
    .B(net349));
 sg13g2_xnor2_1 _3518_ (.Y(_0785_),
    .A(_0767_),
    .B(net380));
 sg13g2_and2_1 _3519_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .B(_0785_),
    .X(_0786_));
 sg13g2_xnor2_1 _3520_ (.Y(_0787_),
    .A(_0765_),
    .B(net379));
 sg13g2_nand2_1 _3521_ (.Y(_0788_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .B(net347));
 sg13g2_inv_1 _3522_ (.Y(_0477_),
    .A(\pll_dig.flock.cnt_done[6] ));
 sg13g2_xnor2_1 _3523_ (.Y(_0789_),
    .A(_0761_),
    .B(net378));
 sg13g2_and2_1 _3524_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .B(_0789_),
    .X(_0790_));
 sg13g2_xnor2_1 _3525_ (.Y(_0791_),
    .A(_0759_),
    .B(_0757_));
 sg13g2_nand2_1 _3526_ (.Y(_0792_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .B(net373));
 sg13g2_xnor2_1 _3527_ (.Y(_0793_),
    .A(net363),
    .B(_0756_));
 sg13g2_and2_1 _3528_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[2] ),
    .B(_0793_),
    .X(_0794_));
 sg13g2_o21ai_1 _3529_ (.B1(_0718_),
    .Y(_0795_),
    .A1(_0719_),
    .A2(_0721_));
 sg13g2_or2_1 _3530_ (.X(_0796_),
    .B(_0793_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[2] ));
 sg13g2_nand2b_1 _3531_ (.Y(_0797_),
    .B(_0796_),
    .A_N(_0794_));
 sg13g2_a21oi_2 _3532_ (.B1(_0794_),
    .Y(_0798_),
    .A2(_0796_),
    .A1(_0795_));
 sg13g2_inv_1 _3533_ (.Y(_0478_),
    .A(\pll_dig.flock.FCW_PA[5] ));
 sg13g2_xnor2_1 _3534_ (.Y(_0799_),
    .A(_0791_),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[3] ));
 sg13g2_o21ai_1 _3535_ (.B1(_0792_),
    .Y(_0800_),
    .A1(_0799_),
    .A2(_0798_));
 sg13g2_or2_1 _3536_ (.X(_0801_),
    .B(_0789_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[4] ));
 sg13g2_nand2b_1 _3537_ (.Y(_0802_),
    .B(_0801_),
    .A_N(_0790_));
 sg13g2_a21oi_2 _3538_ (.B1(_0790_),
    .Y(_0803_),
    .A2(_0800_),
    .A1(_0801_));
 sg13g2_xnor2_1 _3539_ (.Y(_0804_),
    .A(_0787_),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[5] ));
 sg13g2_or2_1 _3540_ (.X(_0805_),
    .B(net376),
    .A(net369));
 sg13g2_o21ai_1 _3541_ (.B1(_0788_),
    .Y(_0806_),
    .A1(_0804_),
    .A2(_0803_));
 sg13g2_or2_1 _3542_ (.X(_0807_),
    .B(_0785_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[6] ));
 sg13g2_nand2b_1 _3543_ (.Y(_0808_),
    .B(_0807_),
    .A_N(_0786_));
 sg13g2_inv_1 _3544_ (.Y(_0479_),
    .A(\pll_dig.flock.FCW_PA[1] ));
 sg13g2_a21oi_2 _3545_ (.B1(_0786_),
    .Y(_0809_),
    .A2(_0806_),
    .A1(_0807_));
 sg13g2_xnor2_1 _3546_ (.Y(_0810_),
    .A(_0783_),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[7] ));
 sg13g2_or2_1 _3547_ (.X(_0811_),
    .B(net377),
    .A(_0809_));
 sg13g2_o21ai_1 _3548_ (.B1(_0784_),
    .Y(_0812_),
    .A1(_0810_),
    .A2(_0809_));
 sg13g2_xnor2_1 _3549_ (.Y(_0813_),
    .A(_0782_),
    .B(net364));
 sg13g2_mux2_1 _3550_ (.A0(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .A1(_0813_),
    .S(net101),
    .X(_0442_));
 sg13g2_a21o_1 _3551_ (.A2(_0775_),
    .A1(_0773_),
    .B1(_0774_),
    .X(_0814_));
 sg13g2_or2_1 _3552_ (.X(_0815_),
    .B(\pll_dig.dsm_impl.FCWF[9] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[9] ));
 sg13g2_and2_1 _3553_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .B(\pll_dig.dsm_impl.FCWF[9] ),
    .X(_0816_));
 sg13g2_xor2_1 _3554_ (.B(\pll_dig.dsm_impl.FCWF[9] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .X(_0817_));
 sg13g2_inv_1 _3555_ (.Y(_0448_),
    .A(net139));
 sg13g2_inv_1 _3556_ (.Y(_0480_),
    .A(net7));
 sg13g2_xnor2_1 _3557_ (.Y(_0818_),
    .A(_0817_),
    .B(_0814_));
 sg13g2_nor2_1 _3558_ (.A(_0499_),
    .B(_0818_),
    .Y(_0819_));
 sg13g2_o21ai_1 _3559_ (.B1(_0777_),
    .Y(_0820_),
    .A1(_0778_),
    .A2(_0772_));
 sg13g2_nand2_1 _3560_ (.Y(_0821_),
    .A(_0499_),
    .B(_0818_));
 sg13g2_xnor2_1 _3561_ (.Y(_0822_),
    .A(_0499_),
    .B(_0818_));
 sg13g2_a21oi_2 _3562_ (.B1(_0819_),
    .Y(_0823_),
    .A2(_0821_),
    .A1(_0820_));
 sg13g2_and2_1 _3563_ (.A(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .B(\pll_dig.dsm_impl.FCWF[10] ),
    .X(_0824_));
 sg13g2_or2_1 _3564_ (.X(_0825_),
    .B(\pll_dig.dsm_impl.FCWF[10] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[10] ));
 sg13g2_nand2b_1 _3565_ (.Y(_0826_),
    .B(_0825_),
    .A_N(_0824_));
 sg13g2_a21o_1 _3566_ (.A2(_0815_),
    .A1(_0814_),
    .B1(_0816_),
    .X(_0827_));
 sg13g2_inv_1 _3567_ (.Y(_0481_),
    .A(\pll_dig.flock.FCW_NA[3] ));
 sg13g2_xnor2_1 _3568_ (.Y(_0828_),
    .A(_0827_),
    .B(_0826_));
 sg13g2_nand2_1 _3569_ (.Y(_0829_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .B(net374));
 sg13g2_xnor2_1 _3570_ (.Y(_0830_),
    .A(_0828_),
    .B(\pll_dig.dsm_impl.dsm.dff_err2[10] ));
 sg13g2_xor2_1 _3571_ (.B(_0830_),
    .A(_0823_),
    .X(_0831_));
 sg13g2_mux2_1 _3572_ (.A0(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .A1(_0831_),
    .S(net101),
    .X(_0441_));
 sg13g2_nor2_1 _3573_ (.A(\pll_dig.FILTER_DEC[4] ),
    .B(\pll_dig.FILTER_DEC[3] ),
    .Y(_0832_));
 sg13g2_inv_1 _3574_ (.Y(\pll_dig.FINE_MUX_D[7] ),
    .A(_0832_));
 sg13g2_a21oi_1 _3575_ (.A1(net103),
    .A2(\pll_dig.FILTER_DEC[3] ),
    .Y(_0833_),
    .B1(\pll_dig.FILTER_DEC[4] ));
 sg13g2_inv_1 _3576_ (.Y(\pll_dig.FINE_MUX_D[11] ),
    .A(_0833_));
 sg13g2_nor2_1 _3577_ (.A(\pll_dig.MID_MUX_D[14] ),
    .B(_0658_),
    .Y(_0834_));
 sg13g2_inv_1 _3578_ (.Y(_0482_),
    .A(\pll_dig.FILTER_DEC[2] ));
 sg13g2_nor2_1 _3579_ (.A(_0492_),
    .B(_0659_),
    .Y(_0835_));
 sg13g2_nor3_1 _3580_ (.A(_0668_),
    .B(net88),
    .C(net86),
    .Y(_0836_));
 sg13g2_nor2_1 _3581_ (.A(_0469_),
    .B(_0659_),
    .Y(_0837_));
 sg13g2_o21ai_1 _3582_ (.B1(_0836_),
    .Y(_0838_),
    .A1(_0669_),
    .A2(net84));
 sg13g2_nand2_1 _3583_ (.Y(_0839_),
    .A(\pll_dig.COARSE_MUX_D[14] ),
    .B(_0659_));
 sg13g2_inv_1 _3584_ (.Y(_0840_),
    .A(_0839_));
 sg13g2_nand2b_1 _3585_ (.Y(_0841_),
    .B(_0839_),
    .A_N(_0838_));
 sg13g2_nor2_1 _3586_ (.A(\pll_dig.COARSE_MUX_D[14] ),
    .B(_0658_),
    .Y(_0842_));
 sg13g2_a221oi_1 _3587_ (.B2(\pll_dig.COARSE_MUX_D[1] ),
    .C1(net77),
    .B1(net82),
    .A1(\pll_dig.COARSE_MUX_D[3] ),
    .Y(_0843_),
    .A2(net84));
 sg13g2_a21oi_1 _3588_ (.A1(_0455_),
    .A2(net77),
    .Y(_0440_),
    .B1(_0843_));
 sg13g2_inv_1 _3589_ (.Y(_0483_),
    .A(_0137_));
 sg13g2_a21oi_1 _3590_ (.A1(_0491_),
    .A2(_0667_),
    .Y(_0844_),
    .B1(_0658_));
 sg13g2_nand2_1 _3591_ (.Y(_0845_),
    .A(\pll_dig.MID_MUX_D[14] ),
    .B(_0844_));
 sg13g2_a21o_1 _3592_ (.A2(_0667_),
    .A1(\pll_dig.COARSE_MUX_D[0] ),
    .B1(_0671_),
    .X(_0846_));
 sg13g2_and2_1 _3593_ (.A(_0660_),
    .B(_0846_),
    .X(_0847_));
 sg13g2_nand2_1 _3594_ (.Y(_0848_),
    .A(_0845_),
    .B(_0847_));
 sg13g2_or2_1 _3595_ (.X(_0849_),
    .B(_0838_),
    .A(_0659_));
 sg13g2_a221oi_1 _3596_ (.B2(\pll_dig.MID_MUX_D[13] ),
    .C1(net73),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[11] ),
    .Y(_0850_),
    .A2(net88));
 sg13g2_a22oi_1 _3597_ (.Y(_0439_),
    .B1(net68),
    .B2(_0850_),
    .A2(net73),
    .A1(_0456_));
 sg13g2_nor2_1 _3598_ (.A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .Y(_0851_));
 sg13g2_or2_1 _3599_ (.X(_0852_),
    .B(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .A(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ));
 sg13g2_inv_1 _3600_ (.Y(_0484_),
    .A(\pll_dig.MID_MUX_D[2] ));
 sg13g2_and3_2 _3601_ (.X(_0853_),
    .A(\pll_dig.flock.cnt[1] ),
    .B(\pll_dig.flock.cnt[3] ),
    .C(\pll_dig.flock.cnt[2] ));
 sg13g2_and3_1 _3602_ (.X(_0854_),
    .A(\pll_dig.flock.cnt[4] ),
    .B(\pll_dig.flock.cnt[5] ),
    .C(_0853_));
 sg13g2_nand3_1 _3603_ (.B(\pll_dig.flock.cnt[6] ),
    .C(\pll_dig.flock.cnt[7] ),
    .A(_0854_),
    .Y(_0855_));
 sg13g2_nor2_2 _3604_ (.A(_0855_),
    .B(_0468_),
    .Y(_0856_));
 sg13g2_nand3_1 _3605_ (.B(\pll_dig.flock.cnt[9] ),
    .C(\pll_dig.flock.cnt[10] ),
    .A(_0856_),
    .Y(_0857_));
 sg13g2_nor2_2 _3606_ (.A(_0857_),
    .B(_0493_),
    .Y(_0858_));
 sg13g2_and2_2 _3607_ (.A(\pll_dig.flock.cnt[12] ),
    .B(_0858_),
    .X(_0859_));
 sg13g2_nand2_2 _3608_ (.Y(_0860_),
    .A(\pll_dig.flock.cnt[13] ),
    .B(_0859_));
 sg13g2_inv_2 _3609_ (.Y(_0861_),
    .A(_0860_));
 sg13g2_nor2_2 _3610_ (.A(net120),
    .B(_0860_),
    .Y(_0862_));
 sg13g2_inv_1 _3611_ (.Y(_0485_),
    .A(\pll_dig.COARSE_MUX_D[12] ));
 sg13g2_nand3_1 _3612_ (.B(_0862_),
    .C(\pll_dig.flock.cnt[15] ),
    .A(\pll_dig.flock.cnt[14] ),
    .Y(_0863_));
 sg13g2_xnor2_1 _3613_ (.Y(_0438_),
    .A(_0863_),
    .B(\pll_dig.flock.cnt_gray[15] ));
 sg13g2_and3_1 _3614_ (.X(_0864_),
    .A(\pll_dig.flock.cnt[4] ),
    .B(net121),
    .C(net494));
 sg13g2_nor2_1 _3615_ (.A(\pll_dig.flock.cnt[4] ),
    .B(net494),
    .Y(_0865_));
 sg13g2_a21oi_1 _3616_ (.A1(net122),
    .A2(net494),
    .Y(_0866_),
    .B1(\pll_dig.flock.cnt[4] ));
 sg13g2_nor2_1 _3617_ (.A(_0864_),
    .B(_0866_),
    .Y(_0437_));
 sg13g2_nand2_2 _3618_ (.Y(_0867_),
    .A(net123),
    .B(net498));
 sg13g2_xor2_1 _3619_ (.B(_0862_),
    .A(\pll_dig.flock.cnt[14] ),
    .X(_0436_));
 sg13g2_a221oi_1 _3620_ (.B2(\pll_dig.COARSE_MUX_D[6] ),
    .C1(net76),
    .B1(net82),
    .A1(\pll_dig.COARSE_MUX_D[8] ),
    .Y(_0868_),
    .A2(net83));
 sg13g2_a21oi_1 _3621_ (.A1(_0459_),
    .A2(net76),
    .Y(_0435_),
    .B1(_0868_));
 sg13g2_inv_1 _3622_ (.Y(_0486_),
    .A(\pll_dig.flock.cnt_filt[1] ));
 sg13g2_nor2_1 _3623_ (.A(_0510_),
    .B(\pll_dig.flock.cnt_cap[8] ),
    .Y(_0869_));
 sg13g2_a22oi_1 _3624_ (.Y(_0870_),
    .B1(_0584_),
    .B2(\pll_dig.flock.cnt_cap[2] ),
    .A2(\pll_dig.flock.cnt_cap[1] ),
    .A1(_0479_));
 sg13g2_a221oi_1 _3625_ (.B2(_0518_),
    .C1(_0870_),
    .B1(\pll_dig.flock.FCW_PA[2] ),
    .A1(_0527_),
    .Y(_0871_),
    .A2(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_a221oi_1 _3626_ (.B2(\pll_dig.flock.cnt_cap[3] ),
    .C1(_0871_),
    .B1(_0555_),
    .A1(_0511_),
    .Y(_0872_),
    .A2(\pll_dig.flock.cnt_cap[4] ));
 sg13g2_a221oi_1 _3627_ (.B2(\pll_dig.flock.FCW_PA[4] ),
    .C1(_0872_),
    .B1(_0528_),
    .A1(\pll_dig.flock.FCW_PA[5] ),
    .Y(_0873_),
    .A2(_0517_));
 sg13g2_a221oi_1 _3628_ (.B2(\pll_dig.flock.cnt_cap[6] ),
    .C1(_0873_),
    .B1(_0586_),
    .A1(_0478_),
    .Y(_0874_),
    .A2(\pll_dig.flock.cnt_cap[5] ));
 sg13g2_a221oi_1 _3629_ (.B2(_0461_),
    .C1(_0874_),
    .B1(\pll_dig.flock.FCW_PA[6] ),
    .A1(_0539_),
    .Y(_0875_),
    .A2(\pll_dig.flock.FCW_PA[7] ));
 sg13g2_a21oi_1 _3630_ (.A1(\pll_dig.flock.cnt_cap[7] ),
    .A2(_0585_),
    .Y(_0876_),
    .B1(_0875_));
 sg13g2_nand2_1 _3631_ (.Y(_0877_),
    .A(\pll_dig.flock.FCW_NA[0] ),
    .B(\pll_dig.flock.FCW_NA[1] ));
 sg13g2_nor2_1 _3632_ (.A(\pll_dig.flock.FCW_NA[0] ),
    .B(\pll_dig.flock.FCW_NA[1] ),
    .Y(_0878_));
 sg13g2_inv_1 _3633_ (.Y(_0487_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[0] ));
 sg13g2_a221oi_1 _3634_ (.B2(_0877_),
    .C1(_0878_),
    .B1(\pll_dig.flock.cnt_cap[1] ),
    .A1(_0497_),
    .Y(_0879_),
    .A2(\pll_dig.flock.cnt_cap[2] ));
 sg13g2_a221oi_1 _3635_ (.B2(\pll_dig.flock.FCW_NA[3] ),
    .C1(_0879_),
    .B1(_0527_),
    .A1(\pll_dig.flock.FCW_NA[2] ),
    .Y(_0880_),
    .A2(_0518_));
 sg13g2_a221oi_1 _3636_ (.B2(_0508_),
    .C1(_0880_),
    .B1(\pll_dig.flock.cnt_cap[4] ),
    .A1(_0481_),
    .Y(_0881_),
    .A2(\pll_dig.flock.cnt_cap[3] ));
 sg13g2_a221oi_1 _3637_ (.B2(\pll_dig.flock.FCW_NA[4] ),
    .C1(_0881_),
    .B1(_0528_),
    .A1(\pll_dig.flock.FCW_NA[5] ),
    .Y(_0882_),
    .A2(_0517_));
 sg13g2_a21oi_1 _3638_ (.A1(_0509_),
    .A2(\pll_dig.flock.cnt_cap[5] ),
    .Y(_0883_),
    .B1(_0882_));
 sg13g2_o21ai_1 _3639_ (.B1(_0883_),
    .Y(_0884_),
    .A1(_0461_),
    .A2(\pll_dig.flock.FCW_NA[6] ));
 sg13g2_a22oi_1 _3640_ (.Y(_0885_),
    .B1(\pll_dig.flock.FCW_NA[7] ),
    .B2(_0539_),
    .A2(\pll_dig.flock.FCW_NA[6] ),
    .A1(_0461_));
 sg13g2_a221oi_1 _3641_ (.B2(_0885_),
    .C1(\pll_dig.flock.cnt_cap[8] ),
    .B1(_0884_),
    .A1(_0507_),
    .Y(_0886_),
    .A2(\pll_dig.flock.cnt_cap[7] ));
 sg13g2_nor4_1 _3642_ (.A(\pll_dig.flock.cnt_cap[15] ),
    .B(\pll_dig.flock.cnt_cap[14] ),
    .C(\pll_dig.flock.cnt_cap[11] ),
    .D(\pll_dig.flock.cnt_cap[9] ),
    .Y(_0887_));
 sg13g2_nand2_1 _3643_ (.Y(_0888_),
    .A(_0510_),
    .B(\pll_dig.flock.cnt_cap[8] ));
 sg13g2_inv_1 _3644_ (.Y(_0488_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[7] ));
 sg13g2_nor4_1 _3645_ (.A(\pll_dig.flock.FCW_NA[10] ),
    .B(\pll_dig.flock.cnt_cap[10] ),
    .C(\pll_dig.flock.cnt_cap[13] ),
    .D(\pll_dig.flock.cnt_cap[12] ),
    .Y(_0889_));
 sg13g2_nand3_1 _3646_ (.B(_0888_),
    .C(_0889_),
    .A(_0887_),
    .Y(_0890_));
 sg13g2_nor2_1 _3647_ (.A(_0886_),
    .B(_0890_),
    .Y(_0891_));
 sg13g2_o21ai_1 _3648_ (.B1(_0891_),
    .Y(_0892_),
    .A1(_0869_),
    .A2(_0876_));
 sg13g2_nand2_1 _3649_ (.Y(_0893_),
    .A(net150),
    .B(_0892_));
 sg13g2_nor2_1 _3650_ (.A(_0460_),
    .B(_0893_),
    .Y(_0434_));
 sg13g2_and3_1 _3651_ (.X(_0894_),
    .A(\pll_dig.ref_wd.cnt[2] ),
    .B(\pll_dig.ref_wd.cnt[1] ),
    .C(\pll_dig.ref_wd.cnt[0] ));
 sg13g2_and3_1 _3652_ (.X(_0895_),
    .A(\pll_dig.ref_wd.cnt[4] ),
    .B(\pll_dig.ref_wd.cnt[3] ),
    .C(_0894_));
 sg13g2_and2_1 _3653_ (.A(_0558_),
    .B(_0895_),
    .X(_0896_));
 sg13g2_and2_1 _3654_ (.A(\pll_dig.ref_wd.cnt[5] ),
    .B(_0896_),
    .X(_0897_));
 sg13g2_inv_1 _3655_ (.Y(_0489_),
    .A(\pll_dig.MID_MUX_D[7] ));
 sg13g2_xor2_1 _3656_ (.B(\pll_dig.ref_wd.watch_s3 ),
    .A(\pll_dig.ref_wd.watch_s2 ),
    .X(_0898_));
 sg13g2_inv_1 _3657_ (.Y(_0899_),
    .A(_0898_));
 sg13g2_o21ai_1 _3658_ (.B1(_0899_),
    .Y(_0900_),
    .A1(\pll_dig.ref_wd.cnt[5] ),
    .A2(_0896_));
 sg13g2_nor2_1 _3659_ (.A(_0897_),
    .B(_0900_),
    .Y(_0433_));
 sg13g2_xor2_1 _3660_ (.B(\pll_dig.flock.cnt_filt[14] ),
    .A(\pll_dig.flock.cnt_filt[15] ),
    .X(_0901_));
 sg13g2_a21oi_1 _3661_ (.A1(\pll_dig.flock.cnt_filt[14] ),
    .A2(net823),
    .Y(_0902_),
    .B1(\pll_dig.flock.cnt_filt[15] ));
 sg13g2_o21ai_1 _3662_ (.B1(\pll_dig.flock.cnt_filt[15] ),
    .Y(_0903_),
    .A1(\pll_dig.flock.cnt_filt[14] ),
    .A2(net823));
 sg13g2_nand2b_1 _3663_ (.Y(_0904_),
    .B(net824),
    .A_N(_0902_));
 sg13g2_nand2_1 _3664_ (.Y(_0905_),
    .A(\pll_dig.flock.cnt_filt[13] ),
    .B(\pll_dig.flock.cnt_filt[14] ));
 sg13g2_xor2_1 _3665_ (.B(\pll_dig.flock.cnt_filt[14] ),
    .A(\pll_dig.flock.cnt_filt[13] ),
    .X(_0906_));
 sg13g2_inv_1 _3666_ (.Y(_0449_),
    .A(\pll_dig.flock.cnt_filt[6] ));
 sg13g2_inv_1 _3667_ (.Y(_0490_),
    .A(\pll_dig.FORCE_N ));
 sg13g2_nand2_1 _3668_ (.Y(_0907_),
    .A(net847),
    .B(_0906_));
 sg13g2_xnor2_1 _3669_ (.Y(_0908_),
    .A(net823),
    .B(_0901_));
 sg13g2_a21oi_1 _3670_ (.A1(_0905_),
    .A2(net848),
    .Y(_0909_),
    .B1(_0908_));
 sg13g2_and3_1 _3671_ (.X(_0910_),
    .A(_0905_),
    .B(net848),
    .C(_0908_));
 sg13g2_and2_1 _3672_ (.A(\pll_dig.flock.cnt_filt[13] ),
    .B(\pll_dig.flock.cnt_filt[12] ),
    .X(_0911_));
 sg13g2_xor2_1 _3673_ (.B(\pll_dig.flock.cnt_filt[12] ),
    .A(\pll_dig.flock.cnt_filt[13] ),
    .X(_0912_));
 sg13g2_a21oi_1 _3674_ (.A1(net860),
    .A2(_0912_),
    .Y(_0913_),
    .B1(_0911_));
 sg13g2_xnor2_1 _3675_ (.Y(_0914_),
    .A(net865),
    .B(_0906_));
 sg13g2_nor2_1 _3676_ (.A(net861),
    .B(_0914_),
    .Y(_0915_));
 sg13g2_xor2_1 _3677_ (.B(_0914_),
    .A(net861),
    .X(_0916_));
 sg13g2_inv_1 _3678_ (.Y(_0491_),
    .A(\pll_dig.COARSE_MUX_D[14] ));
 sg13g2_nand2_1 _3679_ (.Y(_0917_),
    .A(\pll_dig.flock.cnt_filt[12] ),
    .B(\pll_dig.flock.cnt_filt[11] ));
 sg13g2_xor2_1 _3680_ (.B(\pll_dig.flock.cnt_filt[11] ),
    .A(\pll_dig.flock.cnt_filt[12] ),
    .X(_0918_));
 sg13g2_nand2_1 _3681_ (.Y(_0919_),
    .A(net838),
    .B(_0918_));
 sg13g2_xnor2_1 _3682_ (.Y(_0920_),
    .A(net860),
    .B(_0912_));
 sg13g2_and3_1 _3683_ (.X(_0921_),
    .A(_0917_),
    .B(net839),
    .C(_0920_));
 sg13g2_a21oi_1 _3684_ (.A1(_0917_),
    .A2(net839),
    .Y(_0922_),
    .B1(_0920_));
 sg13g2_and2_1 _3685_ (.A(\pll_dig.flock.cnt_filt[11] ),
    .B(\pll_dig.flock.cnt_filt[10] ),
    .X(_0923_));
 sg13g2_xor2_1 _3686_ (.B(\pll_dig.flock.cnt_filt[10] ),
    .A(\pll_dig.flock.cnt_filt[11] ),
    .X(_0924_));
 sg13g2_a21oi_1 _3687_ (.A1(net830),
    .A2(_0629_),
    .Y(_0925_),
    .B1(_0923_));
 sg13g2_xnor2_1 _3688_ (.Y(_0926_),
    .A(net838),
    .B(_0918_));
 sg13g2_inv_1 _3689_ (.Y(_0492_),
    .A(\pll_dig.MID_MUX_D[0] ));
 sg13g2_and2_1 _3690_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[10] ),
    .X(_0927_));
 sg13g2_xor2_1 _3691_ (.B(\pll_dig.flock.cnt_filt[10] ),
    .A(\pll_dig.flock.cnt_filt[9] ),
    .X(_0928_));
 sg13g2_a21oi_1 _3692_ (.A1(net826),
    .A2(_0928_),
    .Y(_0929_),
    .B1(_0927_));
 sg13g2_xnor2_1 _3693_ (.Y(_0930_),
    .A(net830),
    .B(_0924_));
 sg13g2_nor2_1 _3694_ (.A(net827),
    .B(_0930_),
    .Y(_0931_));
 sg13g2_and2_1 _3695_ (.A(\pll_dig.flock.cnt_filt[9] ),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .X(_0932_));
 sg13g2_xor2_1 _3696_ (.B(\pll_dig.flock.cnt_filt[8] ),
    .A(\pll_dig.flock.cnt_filt[9] ),
    .X(_0933_));
 sg13g2_a21oi_1 _3697_ (.A1(net834),
    .A2(_0933_),
    .Y(_0934_),
    .B1(_0932_));
 sg13g2_xnor2_1 _3698_ (.Y(_0935_),
    .A(net826),
    .B(_0928_));
 sg13g2_nor2_1 _3699_ (.A(net835),
    .B(_0935_),
    .Y(_0936_));
 sg13g2_inv_1 _3700_ (.Y(_0493_),
    .A(\pll_dig.flock.cnt[11] ));
 sg13g2_and2_1 _3701_ (.A(net139),
    .B(\pll_dig.flock.cnt_filt[8] ),
    .X(_0937_));
 sg13g2_xor2_1 _3702_ (.B(\pll_dig.flock.cnt_filt[8] ),
    .A(net139),
    .X(_0938_));
 sg13g2_a21oi_1 _3703_ (.A1(net843),
    .A2(_0938_),
    .Y(_0939_),
    .B1(_0937_));
 sg13g2_xnor2_1 _3704_ (.Y(_0940_),
    .A(net834),
    .B(_0933_));
 sg13g2_nor2_1 _3705_ (.A(net844),
    .B(_0940_),
    .Y(_0941_));
 sg13g2_and2_1 _3706_ (.A(net139),
    .B(\pll_dig.flock.cnt_filt[6] ),
    .X(_0942_));
 sg13g2_xor2_1 _3707_ (.B(\pll_dig.flock.cnt_filt[6] ),
    .A(net139),
    .X(_0943_));
 sg13g2_a21oi_1 _3708_ (.A1(net869),
    .A2(_0943_),
    .Y(_0944_),
    .B1(_0942_));
 sg13g2_xnor2_1 _3709_ (.Y(_0945_),
    .A(net843),
    .B(_0938_));
 sg13g2_nor2_1 _3710_ (.A(net870),
    .B(_0945_),
    .Y(_0946_));
 sg13g2_inv_1 _3711_ (.Y(_0494_),
    .A(\pll_dig.MID_MUX_D[6] ));
 sg13g2_nor2_1 _3712_ (.A(_0449_),
    .B(_0552_),
    .Y(_0947_));
 sg13g2_xor2_1 _3713_ (.B(\pll_dig.flock.cnt_filt[5] ),
    .A(\pll_dig.flock.cnt_filt[6] ),
    .X(_0948_));
 sg13g2_a21oi_1 _3714_ (.A1(net856),
    .A2(_0948_),
    .Y(_0949_),
    .B1(_0947_));
 sg13g2_xnor2_1 _3715_ (.Y(_0950_),
    .A(net869),
    .B(_0943_));
 sg13g2_nor2_1 _3716_ (.A(net857),
    .B(_0950_),
    .Y(_0951_));
 sg13g2_nor2_1 _3717_ (.A(_0450_),
    .B(_0552_),
    .Y(_0952_));
 sg13g2_xor2_1 _3718_ (.B(\pll_dig.flock.cnt_filt[5] ),
    .A(\pll_dig.flock.cnt_filt[4] ),
    .X(_0953_));
 sg13g2_a21oi_1 _3719_ (.A1(net873),
    .A2(_0953_),
    .Y(_0954_),
    .B1(_0952_));
 sg13g2_xnor2_1 _3720_ (.Y(_0955_),
    .A(net856),
    .B(_0948_));
 sg13g2_nor2_1 _3721_ (.A(net874),
    .B(_0955_),
    .Y(_0956_));
 sg13g2_inv_1 _3722_ (.Y(_0495_),
    .A(\pll_dig.COARSE_MUX_D[13] ));
 sg13g2_nor2_1 _3723_ (.A(_0450_),
    .B(_0451_),
    .Y(_0957_));
 sg13g2_xor2_1 _3724_ (.B(\pll_dig.flock.cnt_filt[3] ),
    .A(\pll_dig.flock.cnt_filt[4] ),
    .X(_0958_));
 sg13g2_a21oi_1 _3725_ (.A1(net882),
    .A2(_0958_),
    .Y(_0959_),
    .B1(_0957_));
 sg13g2_xnor2_1 _3726_ (.Y(_0960_),
    .A(net873),
    .B(_0953_));
 sg13g2_nor2_1 _3727_ (.A(net883),
    .B(_0960_),
    .Y(_0961_));
 sg13g2_and2_1 _3728_ (.A(\pll_dig.flock.cnt_filt[3] ),
    .B(net140),
    .X(_0962_));
 sg13g2_xor2_1 _3729_ (.B(net140),
    .A(\pll_dig.flock.cnt_filt[3] ),
    .X(_0963_));
 sg13g2_a21oi_1 _3730_ (.A1(net886),
    .A2(_0963_),
    .Y(_0964_),
    .B1(_0962_));
 sg13g2_xnor2_1 _3731_ (.Y(_0965_),
    .A(net882),
    .B(_0958_));
 sg13g2_nor2_1 _3732_ (.A(net887),
    .B(_0965_),
    .Y(_0966_));
 sg13g2_inv_1 _3733_ (.Y(_0496_),
    .A(\pll_dig.COARSE_MUX_D[11] ));
 sg13g2_xor2_1 _3734_ (.B(_0965_),
    .A(net887),
    .X(_0967_));
 sg13g2_nand2_1 _3735_ (.Y(_0968_),
    .A(net140),
    .B(\pll_dig.flock.cnt_filt[1] ));
 sg13g2_xor2_1 _3736_ (.B(\pll_dig.flock.cnt_filt[1] ),
    .A(net140),
    .X(_0969_));
 sg13g2_nand2_1 _3737_ (.Y(_0970_),
    .A(net877),
    .B(_0969_));
 sg13g2_xnor2_1 _3738_ (.Y(_0971_),
    .A(net886),
    .B(_0963_));
 sg13g2_nand3_1 _3739_ (.B(net878),
    .C(_0971_),
    .A(_0968_),
    .Y(_0972_));
 sg13g2_a21oi_1 _3740_ (.A1(_0968_),
    .A2(net878),
    .Y(_0973_),
    .B1(_0971_));
 sg13g2_inv_1 _3741_ (.Y(_0974_),
    .A(_0973_));
 sg13g2_nor2_1 _3742_ (.A(\pll_dig.flock.cnt_filt[1] ),
    .B(\pll_dig.flock.cnt_filt[0] ),
    .Y(_0975_));
 sg13g2_xnor2_1 _3743_ (.Y(_0976_),
    .A(net877),
    .B(_0969_));
 sg13g2_inv_1 _3744_ (.Y(_0497_),
    .A(\pll_dig.flock.FCW_NA[2] ));
 sg13g2_nor2_1 _3745_ (.A(_0486_),
    .B(_0550_),
    .Y(_0977_));
 sg13g2_o21ai_1 _3746_ (.B1(net820),
    .Y(_0978_),
    .A1(_0975_),
    .A2(_0977_));
 sg13g2_xor2_1 _3747_ (.B(_0976_),
    .A(_0975_),
    .X(_0979_));
 sg13g2_nand2b_1 _3748_ (.Y(_0980_),
    .B(_0979_),
    .A_N(net821));
 sg13g2_o21ai_1 _3749_ (.B1(_0980_),
    .Y(_0981_),
    .A1(_0975_),
    .A2(_0976_));
 sg13g2_a21o_1 _3750_ (.A2(_0981_),
    .A1(net879),
    .B1(_0973_),
    .X(_0982_));
 sg13g2_a21oi_1 _3751_ (.A1(net888),
    .A2(_0982_),
    .Y(_0983_),
    .B1(_0966_));
 sg13g2_inv_1 _3752_ (.Y(_0984_),
    .A(_0983_));
 sg13g2_xor2_1 _3753_ (.B(_0960_),
    .A(net883),
    .X(_0985_));
 sg13g2_a21oi_1 _3754_ (.A1(_0984_),
    .A2(net884),
    .Y(_0986_),
    .B1(_0961_));
 sg13g2_inv_1 _3755_ (.Y(_0096_),
    .A(net5));
 sg13g2_xor2_1 _3756_ (.B(_0955_),
    .A(net874),
    .X(_0987_));
 sg13g2_nor2b_1 _3757_ (.A(_0986_),
    .B_N(net875),
    .Y(_0988_));
 sg13g2_nor2_1 _3758_ (.A(_0956_),
    .B(_0988_),
    .Y(_0989_));
 sg13g2_xor2_1 _3759_ (.B(_0950_),
    .A(net857),
    .X(_0990_));
 sg13g2_nor2b_1 _3760_ (.A(_0989_),
    .B_N(net858),
    .Y(_0991_));
 sg13g2_nor2_1 _3761_ (.A(_0951_),
    .B(_0991_),
    .Y(_0992_));
 sg13g2_xor2_1 _3762_ (.B(_0945_),
    .A(net870),
    .X(_0993_));
 sg13g2_nor2b_1 _3763_ (.A(net1060),
    .B_N(net871),
    .Y(_0994_));
 sg13g2_nor2_1 _3764_ (.A(_0946_),
    .B(_0994_),
    .Y(_0995_));
 sg13g2_xor2_1 _3765_ (.B(_0940_),
    .A(net844),
    .X(_0996_));
 sg13g2_inv_1 _3766_ (.Y(_0498_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[2] ));
 sg13g2_nor2b_1 _3767_ (.A(_0995_),
    .B_N(net845),
    .Y(_0997_));
 sg13g2_nor2_1 _3768_ (.A(_0941_),
    .B(_0997_),
    .Y(_0998_));
 sg13g2_xor2_1 _3769_ (.B(_0935_),
    .A(net835),
    .X(_0999_));
 sg13g2_nor2b_1 _3770_ (.A(_0998_),
    .B_N(net836),
    .Y(_1000_));
 sg13g2_nor2_1 _3771_ (.A(_0936_),
    .B(_1000_),
    .Y(_1001_));
 sg13g2_xor2_1 _3772_ (.B(_0930_),
    .A(net827),
    .X(_1002_));
 sg13g2_nor2b_1 _3773_ (.A(net1055),
    .B_N(net828),
    .Y(_1003_));
 sg13g2_nor2_1 _3774_ (.A(_0931_),
    .B(_1003_),
    .Y(_1004_));
 sg13g2_xor2_1 _3775_ (.B(_0926_),
    .A(net831),
    .X(_1005_));
 sg13g2_o21ai_1 _3776_ (.B1(net832),
    .Y(_1006_),
    .A1(_0931_),
    .A2(_1003_));
 sg13g2_inv_1 _3777_ (.Y(_0450_),
    .A(\pll_dig.flock.cnt_filt[4] ));
 sg13g2_inv_1 _3778_ (.Y(_0499_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[9] ));
 sg13g2_o21ai_1 _3779_ (.B1(_1006_),
    .Y(_1007_),
    .A1(net831),
    .A2(_0926_));
 sg13g2_nor2_1 _3780_ (.A(net840),
    .B(net1052),
    .Y(_1008_));
 sg13g2_or2_1 _3781_ (.X(_1009_),
    .B(_1008_),
    .A(_0921_));
 sg13g2_inv_1 _3782_ (.Y(_1010_),
    .A(_1009_));
 sg13g2_a21oi_1 _3783_ (.A1(net862),
    .A2(_1010_),
    .Y(_1011_),
    .B1(net866));
 sg13g2_nor2b_1 _3784_ (.A(net849),
    .B_N(_1011_),
    .Y(_1012_));
 sg13g2_nor2_1 _3785_ (.A(_0910_),
    .B(net850),
    .Y(_1013_));
 sg13g2_inv_1 _3786_ (.Y(_1014_),
    .A(net851));
 sg13g2_xnor2_1 _3787_ (.Y(_0146_),
    .A(_0904_),
    .B(net851));
 sg13g2_nand3_1 _3788_ (.B(\pll_dig.flock.cnt[6] ),
    .C(_0864_),
    .A(\pll_dig.flock.cnt[5] ),
    .Y(_1015_));
 sg13g2_inv_1 _3789_ (.Y(_0500_),
    .A(net10));
 sg13g2_xnor2_1 _3790_ (.Y(_0432_),
    .A(\pll_dig.flock.cnt[13] ),
    .B(_0867_));
 sg13g2_a21oi_1 _3791_ (.A1(\pll_dig.flock.cnt[6] ),
    .A2(net495),
    .Y(_1016_),
    .B1(\pll_dig.flock.cnt[7] ));
 sg13g2_nand2_1 _3792_ (.Y(_1017_),
    .A(\pll_dig.flock.cnt_gray[6] ),
    .B(net120));
 sg13g2_xnor2_1 _3793_ (.Y(_1018_),
    .A(_0468_),
    .B(_1016_));
 sg13g2_o21ai_1 _3794_ (.B1(_1017_),
    .Y(_0431_),
    .A1(net120),
    .A2(_1018_));
 sg13g2_xor2_1 _3795_ (.B(\pll_dig.flock.cnt_gray_s2[14] ),
    .A(\pll_dig.flock.cnt_gray_s2[15] ),
    .X(_0110_));
 sg13g2_xnor2_1 _3796_ (.Y(_1019_),
    .A(\pll_dig.flock.cnt_gray_s2[13] ),
    .B(_0110_));
 sg13g2_inv_1 _3797_ (.Y(_0109_),
    .A(_1019_));
 sg13g2_nand3_1 _3798_ (.B(\pll_dig.out_edges[0] ),
    .C(\pll_dig.out_edges[2] ),
    .A(\pll_dig.out_edges[1] ),
    .Y(_1020_));
 sg13g2_nor2_1 _3799_ (.A(_0551_),
    .B(_1020_),
    .Y(_1021_));
 sg13g2_inv_1 _3800_ (.Y(_0501_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[9] ));
 sg13g2_nor2_1 _3801_ (.A(\pll_dig.out_edges[4] ),
    .B(_1021_),
    .Y(_1022_));
 sg13g2_xor2_1 _3802_ (.B(_1021_),
    .A(\pll_dig.out_edges[4] ),
    .X(\pll_dig.out_edges_next[4] ));
 sg13g2_and2_1 _3803_ (.A(_0551_),
    .B(_1020_),
    .X(_1023_));
 sg13g2_xnor2_1 _3804_ (.Y(_0003_),
    .A(\pll_dig.out_edges[4] ),
    .B(_1023_));
 sg13g2_xor2_1 _3805_ (.B(\pll_dig.out_edges[0] ),
    .A(\pll_dig.out_edges[1] ),
    .X(\pll_dig.out_edges_next[1] ));
 sg13g2_xnor2_1 _3806_ (.Y(_1024_),
    .A(\pll_dig.out_edges_g2[1] ),
    .B(\pll_dig.out_edges_g2_q[1] ));
 sg13g2_xnor2_1 _3807_ (.Y(_1025_),
    .A(\pll_dig.out_edges_g2[5] ),
    .B(\pll_dig.out_edges_g2_q[5] ));
 sg13g2_xnor2_1 _3808_ (.Y(_1026_),
    .A(\pll_dig.out_edges_g2[9] ),
    .B(\pll_dig.out_edges_g2_q[9] ));
 sg13g2_xor2_1 _3809_ (.B(\pll_dig.out_edges_g2_q[3] ),
    .A(\pll_dig.out_edges_g2[3] ),
    .X(_1027_));
 sg13g2_a221oi_1 _3810_ (.B2(\pll_dig.out_edges_g2_q[0] ),
    .C1(_1027_),
    .B1(_0547_),
    .A1(\pll_dig.out_edges_g2[6] ),
    .Y(_1028_),
    .A2(_0543_));
 sg13g2_inv_1 _3811_ (.Y(_0502_),
    .A(\pll_dig.MID_MUX_D[13] ));
 sg13g2_o21ai_1 _3812_ (.B1(\pll_dig.locked_q ),
    .Y(_1029_),
    .A1(_0544_),
    .A2(\pll_dig.out_edges_g2_q[4] ));
 sg13g2_a221oi_1 _3813_ (.B2(_0546_),
    .C1(_1029_),
    .B1(\pll_dig.out_edges_g2[2] ),
    .A1(_0541_),
    .Y(_1030_),
    .A2(\pll_dig.out_edges_g2_q[8] ));
 sg13g2_nor2_1 _3814_ (.A(_0541_),
    .B(\pll_dig.out_edges_g2_q[8] ),
    .Y(_1031_));
 sg13g2_a221oi_1 _3815_ (.B2(_0548_),
    .C1(_1031_),
    .B1(\pll_dig.out_edges_g2[7] ),
    .A1(_0545_),
    .Y(_1032_),
    .A2(\pll_dig.out_edges_g2_q[2] ));
 sg13g2_nand2b_1 _3816_ (.Y(_1033_),
    .B(\pll_dig.out_edges_g2[0] ),
    .A_N(\pll_dig.out_edges_g2_q[0] ));
 sg13g2_o21ai_1 _3817_ (.B1(_1033_),
    .Y(_1034_),
    .A1(\pll_dig.out_edges_g2[7] ),
    .A2(_0548_));
 sg13g2_a221oi_1 _3818_ (.B2(\pll_dig.out_edges_g2_q[4] ),
    .C1(_1034_),
    .B1(_0544_),
    .A1(_0542_),
    .Y(_1035_),
    .A2(\pll_dig.out_edges_g2_q[6] ));
 sg13g2_and4_1 _3819_ (.A(_1028_),
    .B(_1030_),
    .C(_1032_),
    .D(_1035_),
    .X(_1036_));
 sg13g2_nand4_1 _3820_ (.B(_1025_),
    .C(_1026_),
    .A(_1024_),
    .Y(_1037_),
    .D(_1036_));
 sg13g2_o21ai_1 _3821_ (.B1(\pll_dig.dco_miss_cnt[0] ),
    .Y(_1038_),
    .A1(_0467_),
    .A2(_1037_));
 sg13g2_inv_1 _3822_ (.Y(_0503_),
    .A(\pll_dig.MID_MUX_D[5] ));
 sg13g2_nor2_1 _3823_ (.A(\pll_dig.dco_miss_cnt[2] ),
    .B(_1037_),
    .Y(_1039_));
 sg13g2_o21ai_1 _3824_ (.B1(_1038_),
    .Y(_1040_),
    .A1(\pll_dig.dco_miss_cnt[0] ),
    .A2(_1039_));
 sg13g2_inv_1 _3825_ (.Y(_0425_),
    .A(_1040_));
 sg13g2_and2_1 _3826_ (.A(\pll_dig.dco_miss_cnt[0] ),
    .B(\pll_dig.dco_miss_cnt[1] ),
    .X(_1041_));
 sg13g2_nor2_1 _3827_ (.A(\pll_dig.dco_miss_cnt[2] ),
    .B(_1041_),
    .Y(_1042_));
 sg13g2_nor2_1 _3828_ (.A(_1037_),
    .B(_1042_),
    .Y(_0424_));
 sg13g2_nand3_1 _3829_ (.B(\pll_dig.div.cnt[2] ),
    .C(\pll_dig.div.cnt[1] ),
    .A(\pll_dig.div.cnt[0] ),
    .Y(_1043_));
 sg13g2_nor2_2 _3830_ (.A(_1043_),
    .B(_0590_),
    .Y(_1044_));
 sg13g2_xnor2_1 _3831_ (.Y(_1045_),
    .A(_1044_),
    .B(\pll_dig.div.cnt[4] ));
 sg13g2_xnor2_1 _3832_ (.Y(_1046_),
    .A(net387),
    .B(_0590_));
 sg13g2_inv_1 _3833_ (.Y(_0504_),
    .A(\pll_dig.MID_MUX_D[8] ));
 sg13g2_a21o_1 _3834_ (.A2(\pll_dig.div.cnt[1] ),
    .A1(\pll_dig.div.cnt[0] ),
    .B1(\pll_dig.div.cnt[2] ),
    .X(_1047_));
 sg13g2_nand2_2 _3835_ (.Y(_1048_),
    .A(net386),
    .B(_1047_));
 sg13g2_nor2_1 _3836_ (.A(\pll_dig.div.low_count[2] ),
    .B(_1048_),
    .Y(_1049_));
 sg13g2_xnor2_1 _3837_ (.Y(_1050_),
    .A(net422),
    .B(net421));
 sg13g2_nor2_1 _3838_ (.A(\pll_dig.div.low_count[1] ),
    .B(net421),
    .Y(_1051_));
 sg13g2_nor3_1 _3839_ (.A(_0444_),
    .B(_0131_),
    .C(_1051_),
    .Y(_1052_));
 sg13g2_a221oi_1 _3840_ (.B2(\pll_dig.div.low_count[1] ),
    .C1(_1052_),
    .B1(_1050_),
    .A1(_1048_),
    .Y(_1053_),
    .A2(\pll_dig.div.low_count[2] ));
 sg13g2_nor2_2 _3841_ (.A(_1049_),
    .B(_1053_),
    .Y(_1054_));
 sg13g2_o21ai_1 _3842_ (.B1(_1054_),
    .Y(_1055_),
    .A1(_1046_),
    .A2(\pll_dig.div.low_count[3] ));
 sg13g2_nand2_1 _3843_ (.Y(_1056_),
    .A(\pll_dig.div.low_count[3] ),
    .B(net388));
 sg13g2_inv_1 _3844_ (.Y(_0505_),
    .A(\pll_dig.COARSE_MUX_D[10] ));
 sg13g2_a22oi_1 _3845_ (.Y(_1057_),
    .B1(_1046_),
    .B2(\pll_dig.div.low_count[3] ),
    .A2(_1045_),
    .A1(\pll_dig.div.low_count[4] ));
 sg13g2_nand3_1 _3846_ (.B(_1044_),
    .C(\pll_dig.div.cnt[5] ),
    .A(\pll_dig.div.cnt[4] ),
    .Y(_1058_));
 sg13g2_a21o_1 _3847_ (.A2(\pll_dig.div.cnt[4] ),
    .A1(_1044_),
    .B1(\pll_dig.div.cnt[5] ),
    .X(_1059_));
 sg13g2_nand2_2 _3848_ (.Y(_1060_),
    .A(_1059_),
    .B(net390));
 sg13g2_nor2_1 _3849_ (.A(\pll_dig.div.low_count[5] ),
    .B(_1060_),
    .Y(_1061_));
 sg13g2_a21oi_2 _3850_ (.B1(_1061_),
    .Y(_1062_),
    .A2(_1055_),
    .A1(_1057_));
 sg13g2_o21ai_1 _3851_ (.B1(_1062_),
    .Y(_1063_),
    .A1(\pll_dig.div.low_count[4] ),
    .A2(net396));
 sg13g2_nand4_1 _3852_ (.B(\pll_dig.div.cnt[5] ),
    .C(\pll_dig.div.cnt[6] ),
    .A(net391),
    .Y(_1064_),
    .D(\pll_dig.div.cnt[4] ));
 sg13g2_xor2_1 _3853_ (.B(\pll_dig.div.cnt[6] ),
    .A(_1058_),
    .X(_1065_));
 sg13g2_a22oi_1 _3854_ (.Y(_1066_),
    .B1(\pll_dig.div.low_count[6] ),
    .B2(_1065_),
    .A2(_1060_),
    .A1(\pll_dig.div.low_count[5] ));
 sg13g2_inv_1 _3855_ (.Y(_0506_),
    .A(\pll_dig.COARSE_MUX_D[9] ));
 sg13g2_xor2_1 _3856_ (.B(\pll_dig.div.cnt[7] ),
    .A(_1064_),
    .X(_1067_));
 sg13g2_o21ai_1 _3857_ (.B1(_1067_),
    .Y(_1068_),
    .A1(\pll_dig.div.low_count[6] ),
    .A2(_1065_));
 sg13g2_a21oi_2 _3858_ (.B1(_1068_),
    .Y(_1069_),
    .A2(_1063_),
    .A1(_1066_));
 sg13g2_nand3b_1 _3859_ (.B(_0473_),
    .C(\pll_dig.div.pend ),
    .Y(_1070_),
    .A_N(\pll_dig.div.high_phase ));
 sg13g2_nor4_2 _3860_ (.A(\pll_dig.div.leave_req ),
    .B(\pll_dig.div.use_clk_p ),
    .C(_1070_),
    .Y(_1071_),
    .D(_1069_));
 sg13g2_nor2_2 _3861_ (.A(_1071_),
    .B(\pll_dig.div.leave_req ),
    .Y(_1072_));
 sg13g2_or2_2 _3862_ (.X(_1073_),
    .B(_1072_),
    .A(\pll_dig.div.use_clk_p ));
 sg13g2_mux2_1 _3863_ (.A0(\pll_dig.div.div_pend[0] ),
    .A1(net149),
    .S(net424),
    .X(_0423_));
 sg13g2_mux2_1 _3864_ (.A0(\pll_dig.div.div_pend[2] ),
    .A1(net147),
    .S(net420),
    .X(_0422_));
 sg13g2_mux2_1 _3865_ (.A0(\pll_dig.div.div_pend[4] ),
    .A1(net144),
    .S(net420),
    .X(_0421_));
 sg13g2_inv_1 _3866_ (.Y(_0507_),
    .A(\pll_dig.flock.FCW_NA[7] ));
 sg13g2_mux2_1 _3867_ (.A0(\pll_dig.div.div_pend[6] ),
    .A1(net141),
    .S(net428),
    .X(_0420_));
 sg13g2_mux2_1 _3868_ (.A0(\pll_dig.div.low_count[4] ),
    .A1(\pll_dig.div.high_count[4] ),
    .S(\pll_dig.div.high_phase ),
    .X(_1074_));
 sg13g2_or2_1 _3869_ (.X(_1075_),
    .B(_1074_),
    .A(net395));
 sg13g2_a21oi_2 _3870_ (.B1(\pll_dig.div.high_phase ),
    .Y(_1076_),
    .A2(_1056_),
    .A1(net400));
 sg13g2_nor2_1 _3871_ (.A(net421),
    .B(\pll_dig.div.high_count[1] ),
    .Y(_1077_));
 sg13g2_nor3_1 _3872_ (.A(_0444_),
    .B(_0136_),
    .C(_1077_),
    .Y(_1078_));
 sg13g2_a21o_1 _3873_ (.A2(_1050_),
    .A1(\pll_dig.div.high_count[1] ),
    .B1(_1078_),
    .X(_1079_));
 sg13g2_o21ai_1 _3874_ (.B1(_1079_),
    .Y(_1080_),
    .A1(\pll_dig.div.high_count[2] ),
    .A2(_1048_));
 sg13g2_a22oi_1 _3875_ (.Y(_1081_),
    .B1(_1048_),
    .B2(\pll_dig.div.high_count[2] ),
    .A2(net388),
    .A1(\pll_dig.div.high_count[3] ));
 sg13g2_o21ai_1 _3876_ (.B1(\pll_dig.div.high_phase ),
    .Y(_1082_),
    .A1(\pll_dig.div.high_count[3] ),
    .A2(net388));
 sg13g2_inv_1 _3877_ (.Y(_0508_),
    .A(\pll_dig.flock.FCW_NA[4] ));
 sg13g2_a21oi_1 _3878_ (.A1(_1080_),
    .A2(_1081_),
    .Y(_1083_),
    .B1(_1082_));
 sg13g2_o21ai_1 _3879_ (.B1(_1075_),
    .Y(_1084_),
    .A1(_1076_),
    .A2(_1083_));
 sg13g2_mux2_1 _3880_ (.A0(\pll_dig.div.low_count[5] ),
    .A1(\pll_dig.div.high_count[5] ),
    .S(\pll_dig.div.high_phase ),
    .X(_1085_));
 sg13g2_a22oi_1 _3881_ (.Y(_1086_),
    .B1(_1085_),
    .B2(_1060_),
    .A2(_1074_),
    .A1(net395));
 sg13g2_mux2_1 _3882_ (.A0(\pll_dig.div.low_count[6] ),
    .A1(\pll_dig.div.high_count[6] ),
    .S(\pll_dig.div.high_phase ),
    .X(_1087_));
 sg13g2_or2_1 _3883_ (.X(_1088_),
    .B(_1085_),
    .A(_1060_));
 sg13g2_o21ai_1 _3884_ (.B1(_1088_),
    .Y(_1089_),
    .A1(net392),
    .A2(_1087_));
 sg13g2_a21oi_2 _3885_ (.B1(_1089_),
    .Y(_1090_),
    .A2(_1086_),
    .A1(_1084_));
 sg13g2_and2_1 _3886_ (.A(\pll_dig.div.high_phase ),
    .B(\pll_dig.div.high_count[7] ),
    .X(_1091_));
 sg13g2_a221oi_1 _3887_ (.B2(net394),
    .C1(_1090_),
    .B1(_1091_),
    .A1(net393),
    .Y(_1092_),
    .A2(_1087_));
 sg13g2_inv_1 _3888_ (.Y(_0451_),
    .A(\pll_dig.flock.cnt_filt[3] ));
 sg13g2_inv_1 _3889_ (.Y(_0509_),
    .A(\pll_dig.flock.FCW_NA[5] ));
 sg13g2_nor3_2 _3890_ (.A(\pll_dig.div.leave_req ),
    .B(\pll_dig.div.use_clk_p ),
    .C(_1092_),
    .Y(_1093_));
 sg13g2_o21ai_1 _3891_ (.B1(_1093_),
    .Y(_1094_),
    .A1(net394),
    .A2(_1091_));
 sg13g2_nor2_1 _3892_ (.A(\pll_dig.div.div_pend[3] ),
    .B(\pll_dig.div.div_pend[4] ),
    .Y(_1095_));
 sg13g2_nor4_1 _3893_ (.A(\pll_dig.div.div_pend[6] ),
    .B(\pll_dig.div.div_pend[7] ),
    .C(\pll_dig.div.div_pend[5] ),
    .D(\pll_dig.div.div_pend[2] ),
    .Y(_1096_));
 sg13g2_and3_1 _3894_ (.X(_1097_),
    .A(_0128_),
    .B(_1095_),
    .C(_1096_));
 sg13g2_nand3_1 _3895_ (.B(_1095_),
    .C(_1096_),
    .A(_0128_),
    .Y(_1098_));
 sg13g2_nand2_1 _3896_ (.Y(_1099_),
    .A(\pll_dig.div.div_pend[0] ),
    .B(_1097_));
 sg13g2_and3_1 _3897_ (.X(_1100_),
    .A(\pll_dig.div.div_pend[0] ),
    .B(_1071_),
    .C(_1097_));
 sg13g2_or2_1 _3898_ (.X(_1101_),
    .B(_1100_),
    .A(\pll_dig.div.use_clk_p ));
 sg13g2_a21oi_1 _3899_ (.A1(\pll_dig.div.high_phase ),
    .A2(_0472_),
    .Y(_1102_),
    .B1(_1101_));
 sg13g2_inv_1 _3900_ (.Y(_0510_),
    .A(\pll_dig.flock.FCW_PA[8] ));
 sg13g2_xnor2_1 _3901_ (.Y(_0419_),
    .A(net89),
    .B(_1102_));
 sg13g2_or2_1 _3902_ (.X(_1103_),
    .B(net492),
    .A(net120));
 sg13g2_nand2_1 _3903_ (.Y(_1104_),
    .A(net125),
    .B(net491));
 sg13g2_a22oi_1 _3904_ (.Y(_0418_),
    .B1(_1103_),
    .B2(_0468_),
    .A2(net491),
    .A1(net122));
 sg13g2_nor2_1 _3905_ (.A(\pll_dig.flock.cnt_gray[0] ),
    .B(net121),
    .Y(_1105_));
 sg13g2_a21oi_1 _3906_ (.A1(net499),
    .A2(net121),
    .Y(_0417_),
    .B1(_1105_));
 sg13g2_nor2_1 _3907_ (.A(\pll_dig.flock.cnt_gray[8] ),
    .B(net125),
    .Y(_1106_));
 sg13g2_nor2_1 _3908_ (.A(\pll_dig.flock.cnt[9] ),
    .B(net491),
    .Y(_1107_));
 sg13g2_xor2_1 _3909_ (.B(_1107_),
    .A(\pll_dig.flock.cnt[10] ),
    .X(_1108_));
 sg13g2_a21oi_1 _3910_ (.A1(net125),
    .A2(_1108_),
    .Y(_0416_),
    .B1(_1106_));
 sg13g2_inv_1 _3911_ (.Y(_0511_),
    .A(\pll_dig.flock.FCW_PA[4] ));
 sg13g2_o21ai_1 _3912_ (.B1(_0899_),
    .Y(_1109_),
    .A1(\pll_dig.ref_wd.cnt[6] ),
    .A2(_0897_));
 sg13g2_and2_1 _3913_ (.A(\pll_dig.ref_wd.cnt[5] ),
    .B(\pll_dig.ref_wd.cnt[6] ),
    .X(_1110_));
 sg13g2_a21oi_1 _3914_ (.A1(\pll_dig.ref_wd.cnt[6] ),
    .A2(_0897_),
    .Y(_0414_),
    .B1(_1109_));
 sg13g2_nor3_1 _3915_ (.A(\pll_dig.div.p_hi ),
    .B(\pll_dig.div.n_hi ),
    .C(_0622_),
    .Y(_1111_));
 sg13g2_a21oi_1 _3916_ (.A1(net149),
    .A2(net431),
    .Y(_1112_),
    .B1(\pll_dig.div.out_reg ));
 sg13g2_nor3_1 _3917_ (.A(\pll_dig.div.use_clk ),
    .B(_1111_),
    .C(_1112_),
    .Y(_1113_));
 sg13g2_a21o_1 _3918_ (.A2(\pll_dig.div.use_clk ),
    .A1(clknet_1_1__leaf_net59),
    .B1(_1113_),
    .X(net60));
 sg13g2_inv_1 _3919__345 (.Y(net344),
    .A(clknet_1_0__leaf_net60_regs));
 sg13g2_nor2_1 _3920_ (.A(net126),
    .B(_0463_),
    .Y(_1114_));
 sg13g2_nand2b_1 _3921_ (.Y(_1115_),
    .B(net36),
    .A_N(net117));
 sg13g2_inv_1 _3922_ (.Y(_0512_),
    .A(\pll_dig.MID_MUX_D[11] ));
 sg13g2_nor2b_1 _3923_ (.A(net36),
    .B_N(net117),
    .Y(_1116_));
 sg13g2_nor2_1 _3924_ (.A(_0520_),
    .B(net35),
    .Y(_1117_));
 sg13g2_xor2_1 _3925_ (.B(net35),
    .A(\pll_dig.dlf.INT[14] ),
    .X(_1118_));
 sg13g2_inv_1 _3926_ (.Y(_1119_),
    .A(_1118_));
 sg13g2_xor2_1 _3927_ (.B(net33),
    .A(\pll_dig.dlf.INT[12] ),
    .X(_1120_));
 sg13g2_inv_1 _3928_ (.Y(_1121_),
    .A(_1120_));
 sg13g2_nand2_1 _3929_ (.Y(_1122_),
    .A(net988),
    .B(net32));
 sg13g2_and2_1 _3930_ (.A(\pll_dig.dlf.INT[10] ),
    .B(net31),
    .X(_1123_));
 sg13g2_xor2_1 _3931_ (.B(net31),
    .A(net986),
    .X(_1124_));
 sg13g2_xor2_1 _3932_ (.B(net44),
    .A(net996),
    .X(_1125_));
 sg13g2_inv_1 _3933_ (.Y(_0513_),
    .A(\pll_dig.MID_MUX_D[10] ));
 sg13g2_xor2_1 _3934_ (.B(net42),
    .A(net982),
    .X(_1126_));
 sg13g2_xor2_1 _3935_ (.B(net40),
    .A(net973),
    .X(_1127_));
 sg13g2_nand2b_1 _3936_ (.Y(_1128_),
    .B(\pll_dig.dlf.INT[2] ),
    .A_N(net38));
 sg13g2_xnor2_1 _3937_ (.Y(_1129_),
    .A(\pll_dig.dlf.INT[2] ),
    .B(net38));
 sg13g2_nand2_1 _3938_ (.Y(_1130_),
    .A(net37),
    .B(net991));
 sg13g2_nand2_1 _3939_ (.Y(_1131_),
    .A(net979),
    .B(net30));
 sg13g2_xor2_1 _3940_ (.B(net991),
    .A(net37),
    .X(_1132_));
 sg13g2_nand2b_1 _3941_ (.Y(_1133_),
    .B(_1132_),
    .A_N(_1131_));
 sg13g2_a21oi_1 _3942_ (.A1(_1130_),
    .A2(_1133_),
    .Y(_1134_),
    .B1(_1129_));
 sg13g2_a21oi_1 _3943_ (.A1(\pll_dig.dlf.INT[2] ),
    .A2(net38),
    .Y(_1135_),
    .B1(_1134_));
 sg13g2_inv_1 _3944_ (.Y(_0514_),
    .A(\pll_dig.MID_MUX_D[9] ));
 sg13g2_nor2b_1 _3945_ (.A(net984),
    .B_N(net39),
    .Y(_1136_));
 sg13g2_nand2b_1 _3946_ (.Y(_1137_),
    .B(net984),
    .A_N(net39));
 sg13g2_nor2b_1 _3947_ (.A(_1136_),
    .B_N(_1137_),
    .Y(_1138_));
 sg13g2_nor2_1 _3948_ (.A(_1135_),
    .B(_1138_),
    .Y(_1139_));
 sg13g2_a21oi_1 _3949_ (.A1(net1009),
    .A2(net39),
    .Y(_1140_),
    .B1(_1139_));
 sg13g2_nor2b_1 _3950_ (.A(_1140_),
    .B_N(_1127_),
    .Y(_1141_));
 sg13g2_a21oi_1 _3951_ (.A1(net973),
    .A2(net40),
    .Y(_1142_),
    .B1(_1141_));
 sg13g2_nor2b_1 _3952_ (.A(net978),
    .B_N(net41),
    .Y(_1143_));
 sg13g2_nand2b_1 _3953_ (.Y(_1144_),
    .B(net978),
    .A_N(net41));
 sg13g2_nor2b_1 _3954_ (.A(_1143_),
    .B_N(_1144_),
    .Y(_1145_));
 sg13g2_inv_1 _3955_ (.Y(_0515_),
    .A(\pll_dig.COARSE_MUX_D[8] ));
 sg13g2_nor2_1 _3956_ (.A(_1142_),
    .B(_1145_),
    .Y(_1146_));
 sg13g2_a21oi_1 _3957_ (.A1(net978),
    .A2(net41),
    .Y(_1147_),
    .B1(_1146_));
 sg13g2_nor2b_1 _3958_ (.A(_1147_),
    .B_N(_1126_),
    .Y(_1148_));
 sg13g2_a21oi_1 _3959_ (.A1(net982),
    .A2(net42),
    .Y(_1149_),
    .B1(_1148_));
 sg13g2_nor2b_1 _3960_ (.A(net993),
    .B_N(net43),
    .Y(_1150_));
 sg13g2_nand2b_1 _3961_ (.Y(_1151_),
    .B(net993),
    .A_N(net43));
 sg13g2_nor2b_1 _3962_ (.A(_1150_),
    .B_N(_1151_),
    .Y(_1152_));
 sg13g2_nor2_1 _3963_ (.A(_1149_),
    .B(_1152_),
    .Y(_1153_));
 sg13g2_a21oi_1 _3964_ (.A1(net993),
    .A2(net43),
    .Y(_1154_),
    .B1(_1153_));
 sg13g2_nor2b_1 _3965_ (.A(_1154_),
    .B_N(_1125_),
    .Y(_1155_));
 sg13g2_inv_1 _3966_ (.Y(_0516_),
    .A(\pll_dig.COARSE_MUX_D[6] ));
 sg13g2_a21oi_1 _3967_ (.A1(net996),
    .A2(net44),
    .Y(_1156_),
    .B1(_1155_));
 sg13g2_nor2b_1 _3968_ (.A(net118),
    .B_N(net45),
    .Y(_1157_));
 sg13g2_nand2b_1 _3969_ (.Y(_1158_),
    .B(net118),
    .A_N(net45));
 sg13g2_nor2b_1 _3970_ (.A(_1157_),
    .B_N(_1158_),
    .Y(_1159_));
 sg13g2_nor2_1 _3971_ (.A(_1156_),
    .B(_1159_),
    .Y(_1160_));
 sg13g2_a21oi_1 _3972_ (.A1(net45),
    .A2(\pll_dig.dlf.INT[9] ),
    .Y(_1161_),
    .B1(_1160_));
 sg13g2_nor2b_1 _3973_ (.A(_1161_),
    .B_N(_1124_),
    .Y(_1162_));
 sg13g2_xnor2_1 _3974_ (.Y(_1163_),
    .A(\pll_dig.dlf.INT[11] ),
    .B(net32));
 sg13g2_inv_1 _3975_ (.Y(_1164_),
    .A(_1163_));
 sg13g2_o21ai_1 _3976_ (.B1(_1164_),
    .Y(_1165_),
    .A1(_1123_),
    .A2(_1162_));
 sg13g2_inv_1 _3977_ (.Y(_0517_),
    .A(\pll_dig.flock.cnt_cap[5] ));
 sg13g2_a21oi_1 _3978_ (.A1(_1122_),
    .A2(_1165_),
    .Y(_1166_),
    .B1(_1121_));
 sg13g2_a21oi_1 _3979_ (.A1(\pll_dig.dlf.INT[12] ),
    .A2(net33),
    .Y(_1167_),
    .B1(_1166_));
 sg13g2_nand2b_1 _3980_ (.Y(_1168_),
    .B(\pll_dig.dlf.INT[13] ),
    .A_N(net34));
 sg13g2_nor2b_1 _3981_ (.A(\pll_dig.dlf.INT[13] ),
    .B_N(net34),
    .Y(_1169_));
 sg13g2_xnor2_1 _3982_ (.Y(_1170_),
    .A(\pll_dig.dlf.INT[13] ),
    .B(net34));
 sg13g2_nor2_1 _3983_ (.A(_1167_),
    .B(_1170_),
    .Y(_1171_));
 sg13g2_a21oi_1 _3984_ (.A1(net1003),
    .A2(net34),
    .Y(_1172_),
    .B1(_1171_));
 sg13g2_nor2_1 _3985_ (.A(_1119_),
    .B(_1172_),
    .Y(_1173_));
 sg13g2_a21oi_1 _3986_ (.A1(net990),
    .A2(net35),
    .Y(_1174_),
    .B1(_1173_));
 sg13g2_a21oi_1 _3987_ (.A1(_1115_),
    .A2(_1174_),
    .Y(_1175_),
    .B1(_1116_));
 sg13g2_inv_1 _3988_ (.Y(_0518_),
    .A(\pll_dig.flock.cnt_cap[2] ));
 sg13g2_nor3_1 _3989_ (.A(net126),
    .B(_0463_),
    .C(_1175_),
    .Y(_1176_));
 sg13g2_nand3_1 _3990_ (.B(_1130_),
    .C(_1133_),
    .A(_1129_),
    .Y(_1177_));
 sg13g2_nand2b_1 _3991_ (.Y(_1178_),
    .B(_1177_),
    .A_N(_1134_));
 sg13g2_nand2_1 _3992_ (.Y(_1179_),
    .A(\SS_BBPD[0] ),
    .B(_0463_));
 sg13g2_nand2b_1 _3993_ (.Y(_1180_),
    .B(net988),
    .A_N(net32));
 sg13g2_nor2_1 _3994_ (.A(_0530_),
    .B(net31),
    .Y(_1181_));
 sg13g2_nor2_1 _3995_ (.A(net37),
    .B(_0471_),
    .Y(_1182_));
 sg13g2_nor2b_1 _3996_ (.A(net979),
    .B_N(net30),
    .Y(_1183_));
 sg13g2_nor2_1 _3997_ (.A(_1132_),
    .B(_1183_),
    .Y(_1184_));
 sg13g2_o21ai_1 _3998_ (.B1(_1129_),
    .Y(_1185_),
    .A1(_1182_),
    .A2(_1184_));
 sg13g2_inv_1 _3999_ (.Y(_0452_),
    .A(\pll_dig.cntf[6] ));
 sg13g2_inv_1 _4000_ (.Y(_0519_),
    .A(net9));
 sg13g2_and2_1 _4001_ (.A(_1128_),
    .B(_1185_),
    .X(_1186_));
 sg13g2_o21ai_1 _4002_ (.B1(_1137_),
    .Y(_1187_),
    .A1(_1136_),
    .A2(_1186_));
 sg13g2_nor2b_1 _4003_ (.A(_1127_),
    .B_N(_1187_),
    .Y(_1188_));
 sg13g2_a21oi_1 _4004_ (.A1(net973),
    .A2(_0565_),
    .Y(_1189_),
    .B1(_1188_));
 sg13g2_o21ai_1 _4005_ (.B1(_1144_),
    .Y(_1190_),
    .A1(_1143_),
    .A2(_1189_));
 sg13g2_nor2b_1 _4006_ (.A(_1126_),
    .B_N(_1190_),
    .Y(_1191_));
 sg13g2_a21oi_1 _4007_ (.A1(net982),
    .A2(_0583_),
    .Y(_1192_),
    .B1(_1191_));
 sg13g2_o21ai_1 _4008_ (.B1(_1151_),
    .Y(_1193_),
    .A1(_1150_),
    .A2(_1192_));
 sg13g2_nor2b_1 _4009_ (.A(_1125_),
    .B_N(_1193_),
    .Y(_1194_));
 sg13g2_a21oi_1 _4010_ (.A1(net996),
    .A2(_0569_),
    .Y(_1195_),
    .B1(_1194_));
 sg13g2_inv_1 _4011_ (.Y(_0520_),
    .A(net990));
 sg13g2_o21ai_1 _4012_ (.B1(_1158_),
    .Y(_1196_),
    .A1(_1157_),
    .A2(_1195_));
 sg13g2_nor2b_1 _4013_ (.A(_1124_),
    .B_N(_1196_),
    .Y(_1197_));
 sg13g2_o21ai_1 _4014_ (.B1(_1163_),
    .Y(_1198_),
    .A1(_1181_),
    .A2(_1197_));
 sg13g2_a21oi_1 _4015_ (.A1(_1180_),
    .A2(_1198_),
    .Y(_1199_),
    .B1(_1120_));
 sg13g2_a21oi_1 _4016_ (.A1(\pll_dig.dlf.INT[12] ),
    .A2(_0570_),
    .Y(_1200_),
    .B1(_1199_));
 sg13g2_a21oi_1 _4017_ (.A1(_1168_),
    .A2(_1200_),
    .Y(_1201_),
    .B1(_1169_));
 sg13g2_a21oi_1 _4018_ (.A1(_1119_),
    .A2(_1201_),
    .Y(_1202_),
    .B1(_1117_));
 sg13g2_and2_1 _4019_ (.A(net36),
    .B(_1202_),
    .X(_1203_));
 sg13g2_or2_1 _4020_ (.X(_1204_),
    .B(_1202_),
    .A(net36));
 sg13g2_o21ai_1 _4021_ (.B1(_1204_),
    .Y(_1205_),
    .A1(net117),
    .A2(_1203_));
 sg13g2_inv_1 _4022_ (.Y(_0521_),
    .A(net1001));
 sg13g2_nor2b_1 _4023_ (.A(_1179_),
    .B_N(_1205_),
    .Y(_1206_));
 sg13g2_or3_1 _4024_ (.A(_1129_),
    .B(_1182_),
    .C(_1184_),
    .X(_1207_));
 sg13g2_nand3_1 _4025_ (.B(net64),
    .C(_1207_),
    .A(_1185_),
    .Y(_1208_));
 sg13g2_a21oi_1 _4026_ (.A1(net126),
    .A2(net994),
    .Y(_1209_),
    .B1(net115));
 sg13g2_a22oi_1 _4027_ (.Y(\pll_dig.dlf.OUT_C[2] ),
    .B1(_1208_),
    .B2(_1209_),
    .A2(_1178_),
    .A1(net61));
 sg13g2_or2_1 _4028_ (.X(_0051_),
    .B(\pll_dig.dco_fail ),
    .A(\pll_dig.ref_fail ));
 sg13g2_xnor2_1 _4029_ (.Y(_0108_),
    .A(\pll_dig.flock.cnt_gray_s2[12] ),
    .B(_1019_));
 sg13g2_xnor2_1 _4030_ (.Y(_1210_),
    .A(\pll_dig.flock.cnt_gray_s2[11] ),
    .B(_0108_));
 sg13g2_inv_1 _4031_ (.Y(_0107_),
    .A(_1210_));
 sg13g2_xnor2_1 _4032_ (.Y(_0106_),
    .A(\pll_dig.flock.cnt_gray_s2[10] ),
    .B(_1210_));
 sg13g2_inv_1 _4033_ (.Y(_0522_),
    .A(\pll_dig.dlf.INT[12] ));
 sg13g2_xor2_1 _4034_ (.B(_0106_),
    .A(\pll_dig.flock.cnt_gray_s2[9] ),
    .X(_0119_));
 sg13g2_xnor2_1 _4035_ (.Y(_1211_),
    .A(\pll_dig.flock.cnt_gray_s2[8] ),
    .B(_0119_));
 sg13g2_inv_1 _4036_ (.Y(_0118_),
    .A(_1211_));
 sg13g2_xnor2_1 _4037_ (.Y(_0117_),
    .A(\pll_dig.flock.cnt_gray_s2[7] ),
    .B(_1211_));
 sg13g2_xnor2_1 _4038_ (.Y(_1212_),
    .A(\pll_dig.flock.cnt_gray_s2[6] ),
    .B(_0117_));
 sg13g2_inv_1 _4039_ (.Y(_0116_),
    .A(_1212_));
 sg13g2_xnor2_1 _4040_ (.Y(_0115_),
    .A(\pll_dig.flock.cnt_gray_s2[5] ),
    .B(_1212_));
 sg13g2_xor2_1 _4041_ (.B(_0115_),
    .A(\pll_dig.flock.cnt_gray_s2[4] ),
    .X(_0114_));
 sg13g2_xor2_1 _4042_ (.B(_0114_),
    .A(\pll_dig.flock.cnt_gray_s2[3] ),
    .X(_0113_));
 sg13g2_xnor2_1 _4043_ (.Y(_1213_),
    .A(\pll_dig.flock.cnt_gray_s2[2] ),
    .B(_0113_));
 sg13g2_inv_1 _4044_ (.Y(_0523_),
    .A(net17));
 sg13g2_inv_1 _4045_ (.Y(_0112_),
    .A(_1213_));
 sg13g2_nand2_1 _4046_ (.Y(_1214_),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .B(\pll_dig.dsm_impl.FCWF[11] ));
 sg13g2_a221oi_1 _4047_ (.B2(_0815_),
    .C1(_0827_),
    .B1(_0774_),
    .A1(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .Y(_1215_),
    .A2(\pll_dig.dsm_impl.FCWF[10] ));
 sg13g2_o21ai_1 _4048_ (.B1(_0825_),
    .Y(_1216_),
    .A1(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .A2(\pll_dig.dsm_impl.FCWF[11] ));
 sg13g2_o21ai_1 _4049_ (.B1(_1214_),
    .Y(_1217_),
    .A1(_1215_),
    .A2(_1216_));
 sg13g2_inv_1 _4050_ (.Y(_1218_),
    .A(_1217_));
 sg13g2_xor2_1 _4051_ (.B(\pll_dig.dsm_impl.FCWF[11] ),
    .A(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .X(_1219_));
 sg13g2_a21oi_1 _4052_ (.A1(_0825_),
    .A2(_0827_),
    .Y(_1220_),
    .B1(_0824_));
 sg13g2_xnor2_1 _4053_ (.Y(_1221_),
    .A(_1219_),
    .B(_1220_));
 sg13g2_o21ai_1 _4054_ (.B1(_0829_),
    .Y(_1222_),
    .A1(_0830_),
    .A2(_0823_));
 sg13g2_inv_1 _4055_ (.Y(_0524_),
    .A(net20));
 sg13g2_xnor2_1 _4056_ (.Y(_1223_),
    .A(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .B(_1221_));
 sg13g2_nor2b_1 _4057_ (.A(_1223_),
    .B_N(_1222_),
    .Y(_1224_));
 sg13g2_a21oi_1 _4058_ (.A1(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .A2(_1221_),
    .Y(_1225_),
    .B1(_1224_));
 sg13g2_inv_1 _4059_ (.Y(_1226_),
    .A(_1225_));
 sg13g2_nand2b_1 _4060_ (.Y(_1227_),
    .B(net3),
    .A_N(net4));
 sg13g2_nand2_1 _4061_ (.Y(_1228_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .B(_1225_));
 sg13g2_nor2_1 _4062_ (.A(_1227_),
    .B(_1228_),
    .Y(_1229_));
 sg13g2_nor3_1 _4063_ (.A(_1217_),
    .B(_1227_),
    .C(_1228_),
    .Y(_1230_));
 sg13g2_nand2b_1 _4064_ (.Y(_1231_),
    .B(net4),
    .A_N(net3));
 sg13g2_xnor2_1 _4065_ (.Y(_1232_),
    .A(_1223_),
    .B(_1222_));
 sg13g2_inv_1 _4066_ (.Y(_0525_),
    .A(net979));
 sg13g2_nand2_1 _4067_ (.Y(_1233_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .B(net360));
 sg13g2_and2_1 _4068_ (.A(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .B(_0831_),
    .X(_1234_));
 sg13g2_xnor2_1 _4069_ (.Y(_1235_),
    .A(_0822_),
    .B(_0820_));
 sg13g2_nand2_1 _4070_ (.Y(_1236_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .B(net348));
 sg13g2_a21oi_2 _4071_ (.B1(_0780_),
    .Y(_1237_),
    .A2(_0781_),
    .A1(_0812_));
 sg13g2_xnor2_1 _4072_ (.Y(_1238_),
    .A(_1235_),
    .B(\pll_dig.dsm_impl.dsm.dff_err3[9] ));
 sg13g2_or2_1 _4073_ (.X(_1239_),
    .B(net372),
    .A(_1237_));
 sg13g2_o21ai_1 _4074_ (.B1(_1236_),
    .Y(_1240_),
    .A1(_1238_),
    .A2(_1237_));
 sg13g2_or2_1 _4075_ (.X(_1241_),
    .B(_0831_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[10] ));
 sg13g2_nand2b_1 _4076_ (.Y(_1242_),
    .B(_1241_),
    .A_N(_1234_));
 sg13g2_inv_1 _4077_ (.Y(_0526_),
    .A(\pll_dig.dlf.INT[7] ));
 sg13g2_a21oi_2 _4078_ (.B1(_1234_),
    .Y(_1243_),
    .A2(_1240_),
    .A1(_1241_));
 sg13g2_xnor2_1 _4079_ (.Y(_1244_),
    .A(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .B(_1232_));
 sg13g2_nor2_1 _4080_ (.A(net381),
    .B(net722),
    .Y(_1245_));
 sg13g2_o21ai_1 _4081_ (.B1(_1233_),
    .Y(_1246_),
    .A1(_1244_),
    .A2(_1243_));
 sg13g2_xnor2_1 _4082_ (.Y(_1247_),
    .A(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .B(_1246_));
 sg13g2_xnor2_1 _4083_ (.Y(_1248_),
    .A(_1247_),
    .B(_1226_));
 sg13g2_nand2b_1 _4084_ (.Y(_1249_),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .A_N(_1248_));
 sg13g2_or3_1 _4085_ (.A(_1246_),
    .B(_1226_),
    .C(_0458_),
    .X(_1250_));
 sg13g2_nand3_1 _4086_ (.B(_1226_),
    .C(_0458_),
    .A(net355),
    .Y(_1251_));
 sg13g2_and2_2 _4087_ (.A(_1251_),
    .B(_1250_),
    .X(_1252_));
 sg13g2_inv_1 _4088_ (.Y(_0527_),
    .A(\pll_dig.flock.cnt_cap[3] ));
 sg13g2_nor2_1 _4089_ (.A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .B(net383),
    .Y(_1253_));
 sg13g2_xnor2_1 _4090_ (.Y(_1254_),
    .A(_1252_),
    .B(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ));
 sg13g2_nand2b_1 _4091_ (.Y(_1255_),
    .B(_1249_),
    .A_N(_1254_));
 sg13g2_xnor2_1 _4092_ (.Y(_1256_),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .B(_1248_));
 sg13g2_or2_1 _4093_ (.X(_1257_),
    .B(_1256_),
    .A(_1218_));
 sg13g2_xor2_1 _4094_ (.B(_1249_),
    .A(_1254_),
    .X(_1258_));
 sg13g2_nor2_1 _4095_ (.A(_1257_),
    .B(net368),
    .Y(_1259_));
 sg13g2_o21ai_1 _4096_ (.B1(_1255_),
    .Y(_1260_),
    .A1(_1258_),
    .A2(_1257_));
 sg13g2_and2_1 _4097_ (.A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .B(net356),
    .X(_1261_));
 sg13g2_xor2_1 _4098_ (.B(net356),
    .A(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .X(_1262_));
 sg13g2_inv_1 _4099_ (.Y(_0528_),
    .A(\pll_dig.flock.cnt_cap[4] ));
 sg13g2_xor2_1 _4100_ (.B(_1262_),
    .A(_1253_),
    .X(_1263_));
 sg13g2_a21oi_2 _4101_ (.B1(_1231_),
    .Y(_1264_),
    .A2(_1263_),
    .A1(_1260_));
 sg13g2_a21oi_1 _4102_ (.A1(_1253_),
    .A2(_1262_),
    .Y(_1265_),
    .B1(_1261_));
 sg13g2_a21oi_2 _4103_ (.B1(_1230_),
    .Y(_1266_),
    .A2(_1265_),
    .A1(_1264_));
 sg13g2_inv_1 _4104_ (.Y(_1267_),
    .A(_1266_));
 sg13g2_nand2_1 _4105_ (.Y(_1268_),
    .A(\pll_dig.dsm_impl.FCWI[4] ),
    .B(_1266_));
 sg13g2_or2_1 _4106_ (.X(_1269_),
    .B(_1260_),
    .A(_1263_));
 sg13g2_a21oi_2 _4107_ (.B1(_1230_),
    .Y(_1270_),
    .A2(_1269_),
    .A1(_1264_));
 sg13g2_nand2b_1 _4108_ (.Y(_1271_),
    .B(\pll_dig.dsm_impl.FCWI[2] ),
    .A_N(_1270_));
 sg13g2_nand2_1 _4109_ (.Y(_1272_),
    .A(_1257_),
    .B(net365));
 sg13g2_inv_1 _4110_ (.Y(_0453_),
    .A(net11));
 sg13g2_inv_1 _4111_ (.Y(_0529_),
    .A(\pll_dig.dlf.INT[11] ));
 sg13g2_nor2_1 _4112_ (.A(_1231_),
    .B(_1259_),
    .Y(_1273_));
 sg13g2_nor3_1 _4113_ (.A(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .B(_1225_),
    .C(_1227_),
    .Y(_1274_));
 sg13g2_a221oi_1 _4114_ (.B2(_1217_),
    .C1(_1230_),
    .B1(_1274_),
    .A1(_1273_),
    .Y(_1275_),
    .A2(_1272_));
 sg13g2_nor2b_1 _4115_ (.A(_1275_),
    .B_N(\pll_dig.dsm_impl.FCWI[1] ),
    .Y(_1276_));
 sg13g2_xnor2_1 _4116_ (.Y(_1277_),
    .A(_1270_),
    .B(\pll_dig.dsm_impl.FCWI[2] ));
 sg13g2_nand2_2 _4117_ (.Y(_1278_),
    .A(_1277_),
    .B(_1276_));
 sg13g2_xor2_1 _4118_ (.B(_1266_),
    .A(\pll_dig.dsm_impl.FCWI[3] ),
    .X(_1279_));
 sg13g2_a21oi_2 _4119_ (.B1(_1279_),
    .Y(_1280_),
    .A2(_1271_),
    .A1(_1278_));
 sg13g2_a21oi_2 _4120_ (.B1(_1280_),
    .Y(_1281_),
    .A2(_1267_),
    .A1(\pll_dig.dsm_impl.FCWI[3] ));
 sg13g2_nor2_2 _4121_ (.A(_1281_),
    .B(_1268_),
    .Y(_1282_));
 sg13g2_inv_1 _4122_ (.Y(_0530_),
    .A(\pll_dig.dlf.INT[10] ));
 sg13g2_nor2_1 _4123_ (.A(\pll_dig.dsm_impl.FCWI[4] ),
    .B(_1266_),
    .Y(_1283_));
 sg13g2_nand2_2 _4124_ (.Y(_1284_),
    .A(_1281_),
    .B(_1283_));
 sg13g2_nor2_1 _4125_ (.A(_1231_),
    .B(_1256_),
    .Y(_1285_));
 sg13g2_nor3_1 _4126_ (.A(_1229_),
    .B(_1274_),
    .C(_1285_),
    .Y(_1286_));
 sg13g2_xnor2_1 _4127_ (.Y(_1287_),
    .A(_1217_),
    .B(_1286_));
 sg13g2_a21o_1 _4128_ (.A2(_1287_),
    .A1(_1284_),
    .B1(_1282_),
    .X(\pll_dig.FILTER_DEC_RAW[0] ));
 sg13g2_nor2_1 _4129_ (.A(net109),
    .B(_0779_),
    .Y(_1288_));
 sg13g2_a21oi_1 _4130_ (.A1(_0475_),
    .A2(net107),
    .Y(_0413_),
    .B1(_1288_));
 sg13g2_nor2_1 _4131_ (.A(_0476_),
    .B(_0702_),
    .Y(_0097_));
 sg13g2_or3_1 _4132_ (.A(_1123_),
    .B(_1162_),
    .C(_1164_),
    .X(_1289_));
 sg13g2_inv_1 _4133_ (.Y(_0531_),
    .A(net1011));
 sg13g2_nand2_1 _4134_ (.Y(_1290_),
    .A(_1165_),
    .B(_1289_));
 sg13g2_or3_1 _4135_ (.A(_1163_),
    .B(_1181_),
    .C(_1197_),
    .X(_1291_));
 sg13g2_nand3_1 _4136_ (.B(net64),
    .C(_1291_),
    .A(_1198_),
    .Y(_1292_));
 sg13g2_a21oi_1 _4137_ (.A1(net126),
    .A2(net988),
    .Y(_1293_),
    .B1(net115));
 sg13g2_a22oi_1 _4138_ (.Y(\pll_dig.dlf.OUT_C[11] ),
    .B1(_1292_),
    .B2(_1293_),
    .A2(_1290_),
    .A1(net61));
 sg13g2_xnor2_1 _4139_ (.Y(_1294_),
    .A(\pll_dig.dsm_impl.FCWI[1] ),
    .B(net367));
 sg13g2_a21o_1 _4140_ (.A2(_1294_),
    .A1(_1284_),
    .B1(_1282_),
    .X(\pll_dig.FILTER_DEC_RAW[1] ));
 sg13g2_xor2_1 _4141_ (.B(net366),
    .A(_1276_),
    .X(_1295_));
 sg13g2_a21o_1 _4142_ (.A2(_1295_),
    .A1(_1284_),
    .B1(_1282_),
    .X(\pll_dig.FILTER_DEC_RAW[2] ));
 sg13g2_nand3_1 _4143_ (.B(_1278_),
    .C(_1279_),
    .A(_1271_),
    .Y(_1296_));
 sg13g2_inv_1 _4144_ (.Y(_0532_),
    .A(net1005));
 sg13g2_nor2b_1 _4145_ (.A(net382),
    .B_N(_1296_),
    .Y(_1297_));
 sg13g2_a21o_1 _4146_ (.A2(_1297_),
    .A1(_1284_),
    .B1(_1282_),
    .X(\pll_dig.FILTER_DEC_RAW[3] ));
 sg13g2_nand2_1 _4147_ (.Y(_1298_),
    .A(\pll_dig.ref_wd.cnt[9] ),
    .B(_0899_));
 sg13g2_a21oi_1 _4148_ (.A1(_0483_),
    .A2(_0558_),
    .Y(_0412_),
    .B1(_0898_));
 sg13g2_a221oi_1 _4149_ (.B2(\pll_dig.MID_MUX_D[3] ),
    .C1(net70),
    .B1(net86),
    .A1(\pll_dig.MID_MUX_D[1] ),
    .Y(_1299_),
    .A2(net88));
 sg13g2_a22oi_1 _4150_ (.Y(_0411_),
    .B1(net68),
    .B2(_1299_),
    .A2(net70),
    .A1(_0484_));
 sg13g2_a21o_1 _4151_ (.A2(_0862_),
    .A1(\pll_dig.flock.cnt[14] ),
    .B1(\pll_dig.flock.cnt[15] ),
    .X(_1300_));
 sg13g2_and2_1 _4152_ (.A(_0863_),
    .B(_1300_),
    .X(_0410_));
 sg13g2_nand2b_1 _4153_ (.Y(_1301_),
    .B(net497),
    .A_N(\pll_dig.flock.cnt[14] ));
 sg13g2_xnor2_1 _4154_ (.Y(_1302_),
    .A(\pll_dig.flock.cnt[15] ),
    .B(_1301_));
 sg13g2_inv_1 _4155_ (.Y(_0533_),
    .A(net1007));
 sg13g2_nor2_1 _4156_ (.A(\pll_dig.flock.cnt_gray[13] ),
    .B(net124),
    .Y(_1303_));
 sg13g2_a21oi_1 _4157_ (.A1(_1302_),
    .A2(net124),
    .Y(_0409_),
    .B1(_1303_));
 sg13g2_and3_1 _4158_ (.X(_1304_),
    .A(\pll_dig.ref_wd.cnt[3] ),
    .B(_0894_),
    .C(_1298_));
 sg13g2_o21ai_1 _4159_ (.B1(_0899_),
    .Y(_1305_),
    .A1(\pll_dig.ref_wd.cnt[4] ),
    .A2(_1304_));
 sg13g2_nor2_1 _4160_ (.A(_0896_),
    .B(_1305_),
    .Y(_0408_));
 sg13g2_and3_1 _4161_ (.X(_1306_),
    .A(\pll_dig.ref_wd.cnt[1] ),
    .B(_0558_),
    .C(\pll_dig.ref_wd.cnt[0] ));
 sg13g2_o21ai_1 _4162_ (.B1(_0899_),
    .Y(_1307_),
    .A1(\pll_dig.ref_wd.cnt[2] ),
    .A2(_1306_));
 sg13g2_a21oi_1 _4163_ (.A1(_0558_),
    .A2(_0894_),
    .Y(_0407_),
    .B1(_1307_));
 sg13g2_a221oi_1 _4164_ (.B2(\pll_dig.COARSE_MUX_D[11] ),
    .C1(net74),
    .B1(net81),
    .A1(\pll_dig.COARSE_MUX_D[13] ),
    .Y(_1308_),
    .A2(net83));
 sg13g2_a21oi_1 _4165_ (.A1(_0485_),
    .A2(net74),
    .Y(_0406_),
    .B1(_1308_));
 sg13g2_inv_1 _4166_ (.Y(_0534_),
    .A(\pll_dig.dlf.INT[3] ));
 sg13g2_xnor2_1 _4167_ (.Y(_0405_),
    .A(\pll_dig.flock.cnt[7] ),
    .B(_1015_));
 sg13g2_xor2_1 _4168_ (.B(_1132_),
    .A(_1131_),
    .X(_1309_));
 sg13g2_nand2_1 _4169_ (.Y(_1310_),
    .A(_1132_),
    .B(_1183_));
 sg13g2_nand3b_1 _4170_ (.B(net64),
    .C(_1310_),
    .Y(_1311_),
    .A_N(_1184_));
 sg13g2_a21oi_1 _4171_ (.A1(net126),
    .A2(net991),
    .Y(_1312_),
    .B1(net116));
 sg13g2_a22oi_1 _4172_ (.Y(\pll_dig.dlf.OUT_C[1] ),
    .B1(_1311_),
    .B2(_1312_),
    .A2(_1309_),
    .A1(net61));
 sg13g2_nand2_1 _4173_ (.Y(_1313_),
    .A(\pll_dig.flock.started ),
    .B(_0675_));
 sg13g2_inv_1 _4174_ (.Y(_1314_),
    .A(_1313_));
 sg13g2_and2_1 _4175_ (.A(_0676_),
    .B(_1313_),
    .X(_1315_));
 sg13g2_nand2_1 _4176_ (.Y(_1316_),
    .A(\pll_dig.flock.cnt_done[2] ),
    .B(_1315_));
 sg13g2_inv_1 _4177_ (.Y(_0535_),
    .A(\pll_dig.dlf.INT[2] ));
 sg13g2_nor2_1 _4178_ (.A(_0449_),
    .B(net905),
    .Y(_1317_));
 sg13g2_nand2b_1 _4179_ (.Y(_1318_),
    .B(\pll_dig.flock.FCW_NA[2] ),
    .A_N(net140));
 sg13g2_a22oi_1 _4180_ (.Y(_1319_),
    .B1(\pll_dig.flock.FCW_NA[1] ),
    .B2(_0486_),
    .A2(_0550_),
    .A1(\pll_dig.flock.FCW_NA[0] ));
 sg13g2_nor2_1 _4181_ (.A(_0486_),
    .B(\pll_dig.flock.FCW_NA[1] ),
    .Y(_1320_));
 sg13g2_o21ai_1 _4182_ (.B1(_1318_),
    .Y(_1321_),
    .A1(_1319_),
    .A2(_1320_));
 sg13g2_a22oi_1 _4183_ (.Y(_1322_),
    .B1(net140),
    .B2(_0497_),
    .A2(_0481_),
    .A1(\pll_dig.flock.cnt_filt[3] ));
 sg13g2_nor2_1 _4184_ (.A(\pll_dig.flock.cnt_filt[3] ),
    .B(_0481_),
    .Y(_1323_));
 sg13g2_a221oi_1 _4185_ (.B2(_1322_),
    .C1(_1323_),
    .B1(_1321_),
    .A1(_0450_),
    .Y(_1324_),
    .A2(\pll_dig.flock.FCW_NA[4] ));
 sg13g2_a221oi_1 _4186_ (.B2(\pll_dig.flock.cnt_filt[5] ),
    .C1(_1324_),
    .B1(_0509_),
    .A1(\pll_dig.flock.cnt_filt[4] ),
    .Y(_1325_),
    .A2(_0508_));
 sg13g2_a221oi_1 _4187_ (.B2(_0552_),
    .C1(_1325_),
    .B1(\pll_dig.flock.FCW_NA[5] ),
    .A1(_0449_),
    .Y(_1326_),
    .A2(\pll_dig.flock.FCW_NA[6] ));
 sg13g2_inv_1 _4188_ (.Y(_0536_),
    .A(\pll_dig.flock.cnt_bin[5] ));
 sg13g2_nand2b_1 _4189_ (.Y(_1327_),
    .B(net896),
    .A_N(net139));
 sg13g2_o21ai_1 _4190_ (.B1(_1327_),
    .Y(_1328_),
    .A1(_1317_),
    .A2(_1326_));
 sg13g2_nor2_1 _4191_ (.A(net890),
    .B(_0629_),
    .Y(_1329_));
 sg13g2_a21oi_1 _4192_ (.A1(net890),
    .A2(_0923_),
    .Y(_1330_),
    .B1(net891));
 sg13g2_nor2b_1 _4193_ (.A(net896),
    .B_N(\pll_dig.flock.cnt_filt[7] ),
    .Y(_1331_));
 sg13g2_nor4_1 _4194_ (.A(_0928_),
    .B(_0933_),
    .C(_1330_),
    .D(net897),
    .Y(_1332_));
 sg13g2_nor2_1 _4195_ (.A(\pll_dig.flock.FCW_NA[0] ),
    .B(_0550_),
    .Y(_1333_));
 sg13g2_o21ai_1 _4196_ (.B1(_1333_),
    .Y(_1334_),
    .A1(_0479_),
    .A2(\pll_dig.flock.cnt_filt[1] ));
 sg13g2_a22oi_1 _4197_ (.Y(_1335_),
    .B1(_0584_),
    .B2(\pll_dig.flock.cnt_filt[2] ),
    .A2(\pll_dig.flock.cnt_filt[1] ),
    .A1(_0479_));
 sg13g2_nor2_1 _4198_ (.A(\pll_dig.flock.cnt_filt[2] ),
    .B(_0584_),
    .Y(_1336_));
 sg13g2_inv_1 _4199_ (.Y(_0537_),
    .A(\pll_dig.flock.cnt_bin[10] ));
 sg13g2_a221oi_1 _4200_ (.B2(_1335_),
    .C1(_1336_),
    .B1(_1334_),
    .A1(_0451_),
    .Y(_1337_),
    .A2(\pll_dig.flock.FCW_PA[3] ));
 sg13g2_a21oi_1 _4201_ (.A1(\pll_dig.flock.cnt_filt[3] ),
    .A2(_0555_),
    .Y(_1338_),
    .B1(_1337_));
 sg13g2_a21oi_1 _4202_ (.A1(_0450_),
    .A2(\pll_dig.flock.FCW_PA[4] ),
    .Y(_1339_),
    .B1(_1338_));
 sg13g2_a221oi_1 _4203_ (.B2(_0478_),
    .C1(_1339_),
    .B1(\pll_dig.flock.cnt_filt[5] ),
    .A1(\pll_dig.flock.cnt_filt[4] ),
    .Y(_1340_),
    .A2(_0511_));
 sg13g2_a221oi_1 _4204_ (.B2(_0449_),
    .C1(_1340_),
    .B1(\pll_dig.flock.FCW_PA[6] ),
    .A1(\pll_dig.flock.FCW_PA[5] ),
    .Y(_1341_),
    .A2(_0552_));
 sg13g2_a221oi_1 _4205_ (.B2(\pll_dig.flock.cnt_filt[6] ),
    .C1(_1341_),
    .B1(_0586_),
    .A1(net139),
    .Y(_1342_),
    .A2(_0585_));
 sg13g2_a21oi_1 _4206_ (.A1(\pll_dig.flock.FCW_PA[8] ),
    .A2(_0573_),
    .Y(_1343_),
    .B1(_1342_));
 sg13g2_o21ai_1 _4207_ (.B1(_1343_),
    .Y(_1344_),
    .A1(\pll_dig.flock.cnt_filt[7] ),
    .A2(_0585_));
 sg13g2_a21oi_1 _4208_ (.A1(_0510_),
    .A2(\pll_dig.flock.cnt_filt[8] ),
    .Y(_1345_),
    .B1(\pll_dig.flock.cnt_filt[9] ));
 sg13g2_nand4_1 _4209_ (.B(net891),
    .C(_1344_),
    .A(_0628_),
    .Y(_1346_),
    .D(_1345_));
 sg13g2_inv_1 _4210_ (.Y(_0538_),
    .A(net118));
 sg13g2_a21oi_1 _4211_ (.A1(_1328_),
    .A2(net898),
    .Y(_1347_),
    .B1(net892));
 sg13g2_inv_1 _4212_ (.Y(_1348_),
    .A(net893));
 sg13g2_nor2_1 _4213_ (.A(\pll_dig.flock.cnt_done[1] ),
    .B(\pll_dig.flock.cnt_done[0] ),
    .Y(_1349_));
 sg13g2_nor2b_1 _4214_ (.A(net893),
    .B_N(_1349_),
    .Y(_1350_));
 sg13g2_nand2_1 _4215_ (.Y(_1351_),
    .A(_0457_),
    .B(_1349_));
 sg13g2_and2_1 _4216_ (.A(\pll_dig.flock.cnt_done[1] ),
    .B(\pll_dig.flock.cnt_done[0] ),
    .X(_1352_));
 sg13g2_and2_1 _4217_ (.A(net893),
    .B(_1352_),
    .X(_1353_));
 sg13g2_nor3_1 _4218_ (.A(\pll_dig.flock.cnt_done[3] ),
    .B(\pll_dig.flock.cnt_done[4] ),
    .C(_1351_),
    .Y(_1354_));
 sg13g2_and2_1 _4219_ (.A(_0474_),
    .B(_1354_),
    .X(_1355_));
 sg13g2_and2_1 _4220_ (.A(_0477_),
    .B(_1355_),
    .X(_1356_));
 sg13g2_dfrbpq_1 _4221_ (.RESET_B(net133),
    .D(_0206_),
    .Q(_0131_),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4222_ (.RESET_B(net136),
    .D(\pll_dig.div.low_count_pend[1] ),
    .Q(\pll_dig.div.low_count[1] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_1 _4223_ (.RESET_B(net133),
    .D(\pll_dig.div.low_count_pend[2] ),
    .Q(\pll_dig.div.low_count[2] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4224_ (.RESET_B(net133),
    .D(\pll_dig.div.low_count_pend[3] ),
    .Q(\pll_dig.div.low_count[3] ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4225_ (.RESET_B(net133),
    .D(\pll_dig.div.low_count_pend[4] ),
    .Q(\pll_dig.div.low_count[4] ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4226_ (.RESET_B(net132),
    .D(\pll_dig.div.low_count_pend[5] ),
    .Q(\pll_dig.div.low_count[5] ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4227_ (.RESET_B(net132),
    .D(\pll_dig.div.low_count_pend[6] ),
    .Q(\pll_dig.div.low_count[6] ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4228_ (.RESET_B(net194),
    .D(_0068_),
    .Q(\pll_dig.flock.cnt_cap[1] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4229_ (.RESET_B(net197),
    .D(_0069_),
    .Q(\pll_dig.flock.cnt_cap[2] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4230_ (.RESET_B(net202),
    .D(_0070_),
    .Q(\pll_dig.flock.cnt_cap[3] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4231_ (.RESET_B(net197),
    .D(_0071_),
    .Q(\pll_dig.flock.cnt_cap[4] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4232_ (.RESET_B(net202),
    .D(_0072_),
    .Q(\pll_dig.flock.cnt_cap[5] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4233_ (.RESET_B(net203),
    .D(_0073_),
    .Q(\pll_dig.flock.cnt_cap[6] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4234_ (.RESET_B(net212),
    .D(_0074_),
    .Q(\pll_dig.flock.cnt_cap[7] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4235_ (.RESET_B(net208),
    .D(_0075_),
    .Q(\pll_dig.flock.cnt_cap[8] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4236_ (.RESET_B(net211),
    .D(_0076_),
    .Q(\pll_dig.flock.cnt_cap[9] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4237_ (.RESET_B(net211),
    .D(_0062_),
    .Q(\pll_dig.flock.cnt_cap[10] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4238_ (.RESET_B(net211),
    .D(_0063_),
    .Q(\pll_dig.flock.cnt_cap[11] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4239_ (.RESET_B(net216),
    .D(_0064_),
    .Q(\pll_dig.flock.cnt_cap[12] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4240_ (.RESET_B(net217),
    .D(_0065_),
    .Q(\pll_dig.flock.cnt_cap[13] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4241_ (.RESET_B(net209),
    .D(_0066_),
    .Q(\pll_dig.flock.cnt_cap[14] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4242_ (.RESET_B(net209),
    .D(_0067_),
    .Q(\pll_dig.flock.cnt_cap[15] ),
    .CLK(clknet_5_14__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4243_ (.RESET_B(net200),
    .D(_0307_),
    .Q(\pll_dig.clr_toggle ),
    .CLK(net331));
 sg13g2_dfrbpq_1 _4244_ (.RESET_B(net231),
    .D(_0349_),
    .Q(\pll_dig.div_rst_cnt[0] ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4245_ (.RESET_B(net231),
    .D(_0306_),
    .Q(\pll_dig.div_rst_cnt[1] ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4246_ (.RESET_B(net231),
    .D(_0344_),
    .Q(\pll_dig.div_rst_cnt[2] ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4247_ (.RESET_B(net231),
    .D(_0356_),
    .Q(\pll_dig.div_rst_cnt[3] ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4248_ (.RESET_B(net167),
    .D(_0345_),
    .Q(DCO_EN),
    .CLK(net330));
 sg13g2_dfrbpq_1 _4249_ (.RESET_B(net168),
    .D(_0348_),
    .Q(net57),
    .CLK(net329));
 sg13g2_dfrbpq_1 _4250_ (.RESET_B(net168),
    .D(_0347_),
    .Q(\pll_dig.ENABLE ),
    .CLK(net328));
 sg13g2_dfrbpq_1 _4251_ (.RESET_B(net168),
    .D(_0346_),
    .Q(\pll_dig.START ),
    .CLK(net327));
 sg13g2_dfrbpq_1 _4252_ (.RESET_B(net186),
    .D(_0380_),
    .Q(\pll_dig.locked_q ),
    .CLK(net326));
 sg13g2_dfrbpq_1 _4253_ (.RESET_B(net200),
    .D(net931),
    .Q(\pll_dig.FORCE_P ),
    .CLK(net325));
 sg13g2_dfrbpq_1 _4254_ (.RESET_B(net170),
    .D(net919),
    .Q(\pll_dig.FORCE_N ),
    .CLK(net324));
 sg13g2_dfrbpq_1 _4255_ (.RESET_B(net167),
    .D(_0384_),
    .Q(\pll_dig.cnt[0] ),
    .CLK(net323));
 sg13g2_dfrbpq_1 _4256_ (.RESET_B(net167),
    .D(net954),
    .Q(\pll_dig.cnt[1] ),
    .CLK(net322));
 sg13g2_dfrbpq_1 _4257_ (.RESET_B(net167),
    .D(net959),
    .Q(\pll_dig.cnt[2] ),
    .CLK(net321));
 sg13g2_dfrbpq_1 _4258_ (.RESET_B(net168),
    .D(net952),
    .Q(\pll_dig.cnt[3] ),
    .CLK(net320));
 sg13g2_dfrbpq_1 _4259_ (.RESET_B(net168),
    .D(_0383_),
    .Q(\pll_dig.cnt[4] ),
    .CLK(net319));
 sg13g2_dfrbpq_1 _4260_ (.RESET_B(net170),
    .D(_0378_),
    .Q(\pll_dig.cnt[5] ),
    .CLK(net318));
 sg13g2_dfrbpq_1 _4261_ (.RESET_B(net170),
    .D(net957),
    .Q(\pll_dig.cnt[6] ),
    .CLK(net317));
 sg13g2_dfrbpq_1 _4262_ (.RESET_B(net168),
    .D(net928),
    .Q(\pll_dig.cnt[7] ),
    .CLK(net316));
 sg13g2_dfrbpq_1 _4263_ (.RESET_B(net187),
    .D(_0382_),
    .Q(\pll_dig.cntf[0] ),
    .CLK(net315));
 sg13g2_dfrbpq_1 _4264_ (.RESET_B(net187),
    .D(net946),
    .Q(\pll_dig.cntf[1] ),
    .CLK(net314));
 sg13g2_dfrbpq_1 _4265_ (.RESET_B(net187),
    .D(net939),
    .Q(\pll_dig.cntf[2] ),
    .CLK(net313));
 sg13g2_dfrbpq_1 _4266_ (.RESET_B(net186),
    .D(net967),
    .Q(\pll_dig.cntf[3] ),
    .CLK(net312));
 sg13g2_dfrbpq_1 _4267_ (.RESET_B(net169),
    .D(net969),
    .Q(\pll_dig.cntf[4] ),
    .CLK(net311));
 sg13g2_dfrbpq_1 _4268_ (.RESET_B(net169),
    .D(net972),
    .Q(\pll_dig.cntf[5] ),
    .CLK(net310));
 sg13g2_dfrbpq_1 _4269_ (.RESET_B(net200),
    .D(net909),
    .Q(\pll_dig.cntf[6] ),
    .CLK(net309));
 sg13g2_dfrbpq_1 _4270_ (.RESET_B(net222),
    .D(_0426_),
    .Q(\pll_dig.cntf[7] ),
    .CLK(net308));
 sg13g2_dfrbpq_1 _4271_ (.RESET_B(net222),
    .D(_0335_),
    .Q(\pll_dig.ref_fail ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4272_ (.RESET_B(net224),
    .D(_0425_),
    .Q(\pll_dig.dco_miss_cnt[0] ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4273_ (.RESET_B(net224),
    .D(_0334_),
    .Q(\pll_dig.dco_miss_cnt[1] ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4274_ (.RESET_B(net223),
    .D(_0424_),
    .Q(\pll_dig.dco_miss_cnt[2] ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4275_ (.RESET_B(net129),
    .D(_0333_),
    .Q(\pll_dig.div.use_clk ),
    .CLK(net335));
 sg13g2_dfrbpq_2 _4276_ (.RESET_B(net130),
    .D(_0423_),
    .Q(\pll_dig.div.div[0] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4277_ (.RESET_B(net130),
    .D(_0332_),
    .Q(_0132_),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_2 _4278_ (.RESET_B(net135),
    .D(_0422_),
    .Q(\pll_dig.div.div[2] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4279_ (.RESET_B(net130),
    .D(_0331_),
    .Q(\pll_dig.div.div[3] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4280_ (.RESET_B(net130),
    .D(_0421_),
    .Q(\pll_dig.div.div[4] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4281_ (.RESET_B(net131),
    .D(_0330_),
    .Q(\pll_dig.div.div[5] ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4282_ (.RESET_B(net133),
    .D(_0420_),
    .Q(\pll_dig.div.div[6] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4283_ (.RESET_B(net132),
    .D(_0329_),
    .Q(\pll_dig.div.div[7] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4284_ (.RESET_B(net129),
    .D(_0419_),
    .Q(\pll_dig.div.high_phase ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4285_ (.RESET_B(net129),
    .D(_0264_),
    .Q(\pll_dig.div.out_reg ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4286_ (.RESET_B(net128),
    .D(_0255_),
    .Q(\pll_dig.div.div_pend[0] ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4287_ (.RESET_B(net130),
    .D(_0260_),
    .Q(_0128_),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4288_ (.RESET_B(net135),
    .D(_0254_),
    .Q(\pll_dig.div.div_pend[2] ),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4289_ (.RESET_B(net130),
    .D(_0257_),
    .Q(\pll_dig.div.div_pend[3] ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4290_ (.RESET_B(net130),
    .D(_0256_),
    .Q(\pll_dig.div.div_pend[4] ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4291_ (.RESET_B(net128),
    .D(_0259_),
    .Q(\pll_dig.div.div_pend[5] ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4292_ (.RESET_B(net130),
    .D(_0297_),
    .Q(\pll_dig.div.div_pend[6] ),
    .CLK(clknet_4_3_0_net59_regs));
 sg13g2_dfrbpq_1 _4293_ (.RESET_B(net128),
    .D(_0275_),
    .Q(\pll_dig.div.div_pend[7] ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4294_ (.RESET_B(net128),
    .D(_0285_),
    .Q(\pll_dig.div.pend ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4295_ (.RESET_B(net250),
    .D(_0296_),
    .Q(\pll_dig.div.use_clk_p ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_tiehi _4295__251 (.L_HI(net250));
 sg13g2_dfrbpq_1 _4296_ (.RESET_B(net129),
    .D(_0278_),
    .Q(\pll_dig.div.enter_req ),
    .CLK(clknet_4_2_0_net59_regs));
 sg13g2_dfrbpq_1 _4297_ (.RESET_B(net128),
    .D(_0274_),
    .Q(\pll_dig.div.leave_req ),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4298_ (.RESET_B(net182),
    .D(_0280_),
    .Q(\pll_dig.dlf.INT[0] ),
    .CLK(net307));
 sg13g2_dfrbpq_1 _4299_ (.RESET_B(net174),
    .D(_0281_),
    .Q(\pll_dig.dlf.INT[1] ),
    .CLK(net306));
 sg13g2_dfrbpq_1 _4300_ (.RESET_B(net184),
    .D(_0283_),
    .Q(\pll_dig.dlf.INT[2] ),
    .CLK(net305));
 sg13g2_dfrbpq_1 _4301_ (.RESET_B(net184),
    .D(_0277_),
    .Q(\pll_dig.dlf.INT[3] ),
    .CLK(net304));
 sg13g2_dfrbpq_1 _4302_ (.RESET_B(net178),
    .D(_0279_),
    .Q(\pll_dig.dlf.INT[4] ),
    .CLK(net303));
 sg13g2_dfrbpq_1 _4303_ (.RESET_B(net178),
    .D(_0291_),
    .Q(\pll_dig.dlf.INT[5] ),
    .CLK(net302));
 sg13g2_dfrbpq_1 _4304_ (.RESET_B(net178),
    .D(_0273_),
    .Q(\pll_dig.dlf.INT[6] ),
    .CLK(net301));
 sg13g2_dfrbpq_1 _4305_ (.RESET_B(net178),
    .D(_0286_),
    .Q(\pll_dig.dlf.INT[7] ),
    .CLK(net300));
 sg13g2_dfrbpq_1 _4306_ (.RESET_B(net175),
    .D(_0294_),
    .Q(\pll_dig.dlf.INT[8] ),
    .CLK(net299));
 sg13g2_dfrbpq_1 _4307_ (.RESET_B(net175),
    .D(_0276_),
    .Q(\pll_dig.dlf.INT[9] ),
    .CLK(net298));
 sg13g2_dfrbpq_1 _4308_ (.RESET_B(net173),
    .D(_0298_),
    .Q(\pll_dig.dlf.INT[10] ),
    .CLK(net297));
 sg13g2_dfrbpq_1 _4309_ (.RESET_B(net174),
    .D(_0262_),
    .Q(\pll_dig.dlf.INT[11] ),
    .CLK(net296));
 sg13g2_dfrbpq_1 _4310_ (.RESET_B(net173),
    .D(_0261_),
    .Q(\pll_dig.dlf.INT[12] ),
    .CLK(net295));
 sg13g2_dfrbpq_1 _4311_ (.RESET_B(net173),
    .D(_0263_),
    .Q(\pll_dig.dlf.INT[13] ),
    .CLK(net294));
 sg13g2_dfrbpq_1 _4312_ (.RESET_B(net173),
    .D(_0295_),
    .Q(\pll_dig.dlf.INT[14] ),
    .CLK(net293));
 sg13g2_dfrbpq_1 _4313_ (.RESET_B(net182),
    .D(_0293_),
    .Q(_0129_),
    .CLK(net292));
 sg13g2_dfrbpq_1 _4314_ (.RESET_B(net175),
    .D(_0292_),
    .Q(\pll_dig.dsm_impl.dsm.cin_stg1 ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4315_ (.RESET_B(net175),
    .D(_0290_),
    .Q(\pll_dig.dsm_impl.dsm.cin_stg2 ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4316_ (.RESET_B(net187),
    .D(_0284_),
    .Q(\pll_dig.dsm_impl.dsm.dff_ca3 ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4317_ (.RESET_B(net184),
    .D(_0288_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[0] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4318_ (.RESET_B(net187),
    .D(_0282_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[1] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4319_ (.RESET_B(net187),
    .D(_0287_),
    .Q(\pll_dig.dsm_impl.dsm.dff_sum_sd23[2] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4320_ (.RESET_B(net184),
    .D(_0289_),
    .Q(\pll_dig.dsm_impl.dsm.dff_ca2 ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4321_ (.RESET_B(net176),
    .D(_0397_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[0] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4322_ (.RESET_B(net176),
    .D(_0443_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[1] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4323_ (.RESET_B(net176),
    .D(_0392_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[2] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4324_ (.RESET_B(net176),
    .D(_0343_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[3] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4325_ (.RESET_B(net179),
    .D(_0300_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4326_ (.RESET_B(net190),
    .D(_0268_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[5] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4327_ (.RESET_B(net190),
    .D(_0267_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[6] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4328_ (.RESET_B(net190),
    .D(_0396_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[7] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4329_ (.RESET_B(net192),
    .D(_0442_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[8] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4330_ (.RESET_B(net192),
    .D(_0391_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[9] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4331_ (.RESET_B(net192),
    .D(_0386_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[10] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4332_ (.RESET_B(net192),
    .D(_0342_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err3[11] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4333_ (.RESET_B(net176),
    .D(_0301_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4334_ (.RESET_B(net176),
    .D(_0269_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[1] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4335_ (.RESET_B(net177),
    .D(_0395_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[2] ),
    .CLK(\clknet_4_10_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4336_ (.RESET_B(net179),
    .D(_0390_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[3] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4337_ (.RESET_B(net179),
    .D(_0341_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4338_ (.RESET_B(net179),
    .D(_0299_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[5] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4339_ (.RESET_B(net190),
    .D(_0270_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[6] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4340_ (.RESET_B(net190),
    .D(_0266_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[7] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4341_ (.RESET_B(net190),
    .D(_0413_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[8] ),
    .CLK(\clknet_4_15_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4342_ (.RESET_B(net189),
    .D(_0394_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[9] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4343_ (.RESET_B(net189),
    .D(_0441_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[10] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4344_ (.RESET_B(net185),
    .D(_0389_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err2[11] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_2 _4345_ (.RESET_B(net176),
    .D(_0385_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4346_ (.RESET_B(net176),
    .D(_0340_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[1] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4347_ (.RESET_B(net177),
    .D(_0302_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[2] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4348_ (.RESET_B(net179),
    .D(_0271_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[3] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4349_ (.RESET_B(net179),
    .D(_0393_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[4] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4350_ (.RESET_B(net179),
    .D(_0388_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[5] ),
    .CLK(\clknet_4_11_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4351_ (.RESET_B(net190),
    .D(_0336_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[6] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4352_ (.RESET_B(net190),
    .D(_0272_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[7] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4353_ (.RESET_B(net191),
    .D(_0398_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[8] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4354_ (.RESET_B(net189),
    .D(_0305_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[9] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4355_ (.RESET_B(net189),
    .D(_0364_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[10] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4356_ (.RESET_B(net189),
    .D(_0304_),
    .Q(\pll_dig.dsm_impl.dsm.dff_err1[11] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4357_ (.RESET_B(net183),
    .D(net342),
    .Q(\pll_dig.dsm_impl.DSM_CK ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4358_ (.RESET_B(net160),
    .D(_0308_),
    .Q(\pll_dig.COARSE_MUX_D[0] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4359_ (.RESET_B(net161),
    .D(_0326_),
    .Q(\pll_dig.COARSE_MUX_D[14] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4360_ (.RESET_B(net160),
    .D(_0352_),
    .Q(\pll_dig.COARSE_MUX_D[1] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4361_ (.RESET_B(net160),
    .D(_0440_),
    .Q(\pll_dig.COARSE_MUX_D[2] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4362_ (.RESET_B(net160),
    .D(_0363_),
    .Q(\pll_dig.COARSE_MUX_D[3] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4363_ (.RESET_B(net157),
    .D(_0316_),
    .Q(\pll_dig.COARSE_MUX_D[4] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4364_ (.RESET_B(net157),
    .D(_0313_),
    .Q(\pll_dig.COARSE_MUX_D[5] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4365_ (.RESET_B(net158),
    .D(_0354_),
    .Q(\pll_dig.COARSE_MUX_D[6] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4366_ (.RESET_B(net158),
    .D(_0435_),
    .Q(\pll_dig.COARSE_MUX_D[7] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4367_ (.RESET_B(net154),
    .D(_0362_),
    .Q(\pll_dig.COARSE_MUX_D[8] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4368_ (.RESET_B(net154),
    .D(_0322_),
    .Q(\pll_dig.COARSE_MUX_D[9] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4369_ (.RESET_B(net154),
    .D(_0320_),
    .Q(\pll_dig.COARSE_MUX_D[10] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4370_ (.RESET_B(net152),
    .D(_0350_),
    .Q(\pll_dig.COARSE_MUX_D[11] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4371_ (.RESET_B(net152),
    .D(_0406_),
    .Q(\pll_dig.COARSE_MUX_D[12] ),
    .CLK(\clknet_4_0__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4372_ (.RESET_B(net152),
    .D(_0361_),
    .Q(\pll_dig.COARSE_MUX_D[13] ),
    .CLK(\clknet_4_1__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4373_ (.RESET_B(net160),
    .D(_0309_),
    .Q(\pll_dig.MID_MUX_D[0] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4374_ (.RESET_B(net161),
    .D(_0327_),
    .Q(\pll_dig.MID_MUX_D[14] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4375_ (.RESET_B(net162),
    .D(_0250_),
    .Q(\pll_dig.MID_MUX_D[1] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4376_ (.RESET_B(net162),
    .D(_0411_),
    .Q(\pll_dig.MID_MUX_D[2] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4377_ (.RESET_B(net157),
    .D(_0360_),
    .Q(\pll_dig.MID_MUX_D[3] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4378_ (.RESET_B(net159),
    .D(_0317_),
    .Q(\pll_dig.MID_MUX_D[4] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4379_ (.RESET_B(net159),
    .D(_0314_),
    .Q(\pll_dig.MID_MUX_D[5] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4380_ (.RESET_B(net159),
    .D(_0375_),
    .Q(\pll_dig.MID_MUX_D[6] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4381_ (.RESET_B(net159),
    .D(_0402_),
    .Q(\pll_dig.MID_MUX_D[7] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4382_ (.RESET_B(net162),
    .D(_0359_),
    .Q(\pll_dig.MID_MUX_D[8] ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4383_ (.RESET_B(net162),
    .D(_0323_),
    .Q(\pll_dig.MID_MUX_D[9] ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4384_ (.RESET_B(net162),
    .D(_0321_),
    .Q(\pll_dig.MID_MUX_D[10] ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4385_ (.RESET_B(net163),
    .D(_0355_),
    .Q(\pll_dig.MID_MUX_D[11] ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4386_ (.RESET_B(net162),
    .D(_0439_),
    .Q(\pll_dig.MID_MUX_D[12] ),
    .CLK(\clknet_4_4__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4387_ (.RESET_B(net162),
    .D(_0358_),
    .Q(\pll_dig.MID_MUX_D[13] ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4388_ (.RESET_B(net163),
    .D(_0310_),
    .Q(\pll_dig.flock.started ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4389_ (.RESET_B(net198),
    .D(_0252_),
    .Q(\pll_dig.FREQ_OK ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4390_ (.RESET_B(net198),
    .D(_0265_),
    .Q(\pll_dig.flock.freq_miss[0] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4391_ (.RESET_B(net198),
    .D(_0353_),
    .Q(\pll_dig.flock.freq_miss[1] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4392_ (.RESET_B(net198),
    .D(_0434_),
    .Q(\pll_dig.flock.freq_miss[2] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4393_ (.RESET_B(net200),
    .D(_0357_),
    .Q(\pll_dig.flock.cnt[1] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_2 _4394_ (.RESET_B(net200),
    .D(_0318_),
    .Q(\pll_dig.flock.cnt[2] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_2 _4395_ (.RESET_B(net201),
    .D(_0328_),
    .Q(\pll_dig.flock.cnt[3] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4396_ (.RESET_B(net201),
    .D(_0437_),
    .Q(\pll_dig.flock.cnt[4] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4397_ (.RESET_B(net204),
    .D(_0399_),
    .Q(\pll_dig.flock.cnt[5] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4398_ (.RESET_B(net204),
    .D(_0351_),
    .Q(\pll_dig.flock.cnt[6] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4399_ (.RESET_B(net205),
    .D(_0405_),
    .Q(\pll_dig.flock.cnt[7] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4400_ (.RESET_B(net213),
    .D(_0418_),
    .Q(\pll_dig.flock.cnt[8] ),
    .CLK(clknet_3_3__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4401_ (.RESET_B(net213),
    .D(_0374_),
    .Q(\pll_dig.flock.cnt[9] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4402_ (.RESET_B(net214),
    .D(_0369_),
    .Q(\pll_dig.flock.cnt[10] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4403_ (.RESET_B(net214),
    .D(_0324_),
    .Q(\pll_dig.flock.cnt[11] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4404_ (.RESET_B(net219),
    .D(_0253_),
    .Q(\pll_dig.flock.cnt[12] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4405_ (.RESET_B(net218),
    .D(_0432_),
    .Q(\pll_dig.flock.cnt[13] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4406_ (.RESET_B(net219),
    .D(_0436_),
    .Q(\pll_dig.flock.cnt[14] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4407_ (.RESET_B(net219),
    .D(_0410_),
    .Q(\pll_dig.flock.cnt[15] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4408_ (.RESET_B(net198),
    .D(_0417_),
    .Q(\pll_dig.flock.cnt_gray[0] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4409_ (.RESET_B(net199),
    .D(_0373_),
    .Q(\pll_dig.flock.cnt_gray[1] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4410_ (.RESET_B(net201),
    .D(_0368_),
    .Q(\pll_dig.flock.cnt_gray[2] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4411_ (.RESET_B(net204),
    .D(_0311_),
    .Q(\pll_dig.flock.cnt_gray[3] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4412_ (.RESET_B(net205),
    .D(_0315_),
    .Q(\pll_dig.flock.cnt_gray[4] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4413_ (.RESET_B(net205),
    .D(_0404_),
    .Q(\pll_dig.flock.cnt_gray[5] ),
    .CLK(clknet_3_1__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4414_ (.RESET_B(net212),
    .D(_0431_),
    .Q(\pll_dig.flock.cnt_gray[6] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4415_ (.RESET_B(net213),
    .D(_0401_),
    .Q(\pll_dig.flock.cnt_gray[7] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4416_ (.RESET_B(net214),
    .D(_0416_),
    .Q(\pll_dig.flock.cnt_gray[8] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4417_ (.RESET_B(net214),
    .D(_0372_),
    .Q(\pll_dig.flock.cnt_gray[9] ),
    .CLK(clknet_3_4__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4418_ (.RESET_B(net216),
    .D(_0367_),
    .Q(\pll_dig.flock.cnt_gray[10] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4419_ (.RESET_B(net216),
    .D(_0319_),
    .Q(\pll_dig.flock.cnt_gray[11] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4420_ (.RESET_B(net218),
    .D(_0251_),
    .Q(\pll_dig.flock.cnt_gray[12] ),
    .CLK(clknet_3_5__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4421_ (.RESET_B(net218),
    .D(_0409_),
    .Q(\pll_dig.flock.cnt_gray[13] ),
    .CLK(clknet_3_6__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4422_ (.RESET_B(net218),
    .D(_0403_),
    .Q(\pll_dig.flock.cnt_gray[14] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4423_ (.RESET_B(net218),
    .D(_0438_),
    .Q(\pll_dig.flock.cnt_gray[15] ),
    .CLK(clknet_3_7__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4424_ (.RESET_B(net169),
    .D(net942),
    .Q(\pll_dig.PHASE_LOCK ),
    .CLK(net291));
 sg13g2_dfrbpq_1 _4425_ (.RESET_B(net169),
    .D(net936),
    .Q(\pll_dig.LOCK_LOST ),
    .CLK(net290));
 sg13g2_dfrbpq_1 _4426_ (.RESET_B(net223),
    .D(_0366_),
    .Q(\pll_dig.ref_wd.cnt[0] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4427_ (.RESET_B(net223),
    .D(_0325_),
    .Q(\pll_dig.ref_wd.cnt[1] ),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4428_ (.RESET_B(net222),
    .D(_0407_),
    .Q(\pll_dig.ref_wd.cnt[2] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4429_ (.RESET_B(net222),
    .D(_0400_),
    .Q(\pll_dig.ref_wd.cnt[3] ),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4430_ (.RESET_B(net200),
    .D(_0408_),
    .Q(\pll_dig.ref_wd.cnt[4] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4431_ (.RESET_B(net224),
    .D(_0433_),
    .Q(\pll_dig.ref_wd.cnt[5] ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4432_ (.RESET_B(net224),
    .D(_0414_),
    .Q(\pll_dig.ref_wd.cnt[6] ),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4433_ (.RESET_B(net201),
    .D(_0370_),
    .Q(\pll_dig.ref_wd.cnt[7] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4434_ (.RESET_B(net201),
    .D(_0365_),
    .Q(\pll_dig.ref_wd.cnt[8] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4435_ (.RESET_B(net207),
    .D(_0312_),
    .Q(\pll_dig.ref_wd.cnt[9] ),
    .CLK(clknet_4_4_0_net59_regs));
 sg13g2_dfrbpq_1 _4436_ (.RESET_B(net222),
    .D(_0412_),
    .Q(_0137_),
    .CLK(clknet_4_1_0_net59_regs));
 sg13g2_dfrbpq_1 _4437_ (.RESET_B(net168),
    .D(_0247_),
    .Q(_0138_),
    .CLK(net289));
 sg13g2_dfrbpq_1 _4438_ (.RESET_B(net162),
    .D(net933),
    .Q(\pll_dig.state[1] ),
    .CLK(net288));
 sg13g2_dfrbpq_1 _4439_ (.RESET_B(net169),
    .D(net964),
    .Q(\pll_dig.state[2] ),
    .CLK(net287));
 sg13g2_dfrbpq_1 _4440_ (.RESET_B(net168),
    .D(_0049_),
    .Q(\pll_dig.state[3] ),
    .CLK(net286));
 sg13g2_dfrbpq_1 _4441_ (.RESET_B(net170),
    .D(net977),
    .Q(\pll_dig.state[4] ),
    .CLK(net285));
 sg13g2_dfrbpq_1 _4442_ (.RESET_B(net184),
    .D(net1018),
    .Q(\pll_dig.dsm_impl.FCWI[1] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4443_ (.RESET_B(net183),
    .D(net1020),
    .Q(\pll_dig.dsm_impl.FCWI[2] ),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4444_ (.RESET_B(net182),
    .D(net1022),
    .Q(\pll_dig.dsm_impl.FCWI[3] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4445_ (.RESET_B(net182),
    .D(net1046),
    .Q(\pll_dig.dsm_impl.FCWI[4] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4446_ (.RESET_B(net128),
    .D(_0095_),
    .Q(\pll_dig.u_ddr_ck.ck_en ),
    .CLK(net344));
 sg13g2_dfrbpq_1 _4447_ (.RESET_B(net128),
    .D(_0217_),
    .Q(_0133_),
    .CLK(clknet_4_0_0_net59_regs));
 sg13g2_dfrbpq_1 _4448_ (.RESET_B(net137),
    .D(_0086_),
    .Q(\pll_dig.div.p_hi ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_2 _4449_ (.RESET_B(net136),
    .D(_0077_),
    .Q(\pll_dig.div.cnt[0] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_2 _4450_ (.RESET_B(net136),
    .D(_0078_),
    .Q(\pll_dig.div.cnt[1] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_1 _4451_ (.RESET_B(net133),
    .D(_0079_),
    .Q(\pll_dig.div.cnt[2] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4452_ (.RESET_B(net134),
    .D(_0080_),
    .Q(\pll_dig.div.cnt[3] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4453_ (.RESET_B(net134),
    .D(_0081_),
    .Q(\pll_dig.div.cnt[4] ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4454_ (.RESET_B(net132),
    .D(_0082_),
    .Q(\pll_dig.div.cnt[5] ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4455_ (.RESET_B(net132),
    .D(_0083_),
    .Q(\pll_dig.div.cnt[6] ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_1 _4456_ (.RESET_B(net134),
    .D(_0084_),
    .Q(\pll_dig.div.cnt[7] ),
    .CLK(clknet_4_10_0_net59_regs));
 sg13g2_dfrbpq_2 _4457_ (.RESET_B(net135),
    .D(_0087_),
    .Q(\pll_dig.div.pcnt[0] ),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_2 _4458_ (.RESET_B(net135),
    .D(_0088_),
    .Q(\pll_dig.div.pcnt[1] ),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_1 _4459_ (.RESET_B(net138),
    .D(_0089_),
    .Q(\pll_dig.div.pcnt[2] ),
    .CLK(clknet_4_7_0_net59_regs));
 sg13g2_dfrbpq_1 _4460_ (.RESET_B(net138),
    .D(_0090_),
    .Q(\pll_dig.div.pcnt[3] ),
    .CLK(clknet_4_13_0_net59_regs));
 sg13g2_dfrbpq_1 _4461_ (.RESET_B(net137),
    .D(_0091_),
    .Q(\pll_dig.div.pcnt[4] ),
    .CLK(clknet_4_13_0_net59_regs));
 sg13g2_dfrbpq_1 _4462_ (.RESET_B(net137),
    .D(_0092_),
    .Q(\pll_dig.div.pcnt[5] ),
    .CLK(clknet_4_13_0_net59_regs));
 sg13g2_dfrbpq_1 _4463_ (.RESET_B(net138),
    .D(_0093_),
    .Q(\pll_dig.div.pcnt[6] ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4464_ (.RESET_B(net138),
    .D(_0094_),
    .Q(\pll_dig.div.pcnt[7] ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4465_ (.RESET_B(net136),
    .D(_0233_),
    .Q(_0136_),
    .CLK(clknet_4_6_0_net59_regs));
 sg13g2_dfrbpq_1 _4466_ (.RESET_B(net136),
    .D(\pll_dig.div.high_count_pend[1] ),
    .Q(\pll_dig.div.high_count[1] ),
    .CLK(clknet_4_14_0_net59_regs));
 sg13g2_dfrbpq_1 _4467_ (.RESET_B(net134),
    .D(\pll_dig.div.high_count_pend[2] ),
    .Q(\pll_dig.div.high_count[2] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4468_ (.RESET_B(net133),
    .D(\pll_dig.div.high_count_pend[3] ),
    .Q(\pll_dig.div.high_count[3] ),
    .CLK(clknet_4_11_0_net59_regs));
 sg13g2_dfrbpq_1 _4469_ (.RESET_B(net133),
    .D(\pll_dig.div.high_count_pend[4] ),
    .Q(\pll_dig.div.high_count[4] ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4470_ (.RESET_B(net132),
    .D(\pll_dig.div.high_count_pend[5] ),
    .Q(\pll_dig.div.high_count[5] ),
    .CLK(clknet_4_9_0_net59_regs));
 sg13g2_dfrbpq_1 _4471_ (.RESET_B(net132),
    .D(\pll_dig.div.high_count_pend[6] ),
    .Q(\pll_dig.div.high_count[6] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4472_ (.RESET_B(net132),
    .D(\pll_dig.div.high_count_pend[7] ),
    .Q(\pll_dig.div.high_count[7] ),
    .CLK(clknet_4_8_0_net59_regs));
 sg13g2_dfrbpq_1 _4473_ (.RESET_B(net135),
    .D(_0037_),
    .Q(\pll_dig.div.ncnt[0] ),
    .CLK(net336));
 sg13g2_dfrbpq_2 _4474_ (.RESET_B(net135),
    .D(_0038_),
    .Q(\pll_dig.div.ncnt[1] ),
    .CLK(net334));
 sg13g2_dfrbpq_1 _4475_ (.RESET_B(net135),
    .D(_0039_),
    .Q(\pll_dig.div.ncnt[2] ),
    .CLK(net337));
 sg13g2_dfrbpq_1 _4476_ (.RESET_B(net135),
    .D(_0040_),
    .Q(\pll_dig.div.ncnt[3] ),
    .CLK(net340));
 sg13g2_dfrbpq_1 _4477_ (.RESET_B(net136),
    .D(_0041_),
    .Q(\pll_dig.div.ncnt[4] ),
    .CLK(net332));
 sg13g2_dfrbpq_1 _4478_ (.RESET_B(net136),
    .D(_0042_),
    .Q(\pll_dig.div.ncnt[5] ),
    .CLK(net338));
 sg13g2_dfrbpq_1 _4479_ (.RESET_B(net136),
    .D(_0043_),
    .Q(\pll_dig.div.ncnt[6] ),
    .CLK(net339));
 sg13g2_dfrbpq_1 _4480_ (.RESET_B(net137),
    .D(_0044_),
    .Q(\pll_dig.div.ncnt[7] ),
    .CLK(net333));
 sg13g2_dfrbpq_1 _4481_ (.RESET_B(net137),
    .D(_0085_),
    .Q(\pll_dig.div.n_hi ),
    .CLK(clknet_4_15_0_net59_regs));
 sg13g2_dfrbpq_1 _4482_ (.RESET_B(net199),
    .D(_0105_),
    .Q(\pll_dig.flock.cnt_bin[0] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4483_ (.RESET_B(net199),
    .D(_0111_),
    .Q(\pll_dig.flock.cnt_bin[1] ),
    .CLK(clknet_5_4__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4484_ (.RESET_B(net199),
    .D(_0112_),
    .Q(\pll_dig.flock.cnt_bin[2] ),
    .CLK(clknet_5_3__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4485_ (.RESET_B(net202),
    .D(_0113_),
    .Q(\pll_dig.flock.cnt_bin[3] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4486_ (.RESET_B(net202),
    .D(_0114_),
    .Q(\pll_dig.flock.cnt_bin[4] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4487_ (.RESET_B(net203),
    .D(_0115_),
    .Q(\pll_dig.flock.cnt_bin[5] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4488_ (.RESET_B(net212),
    .D(_0116_),
    .Q(\pll_dig.flock.cnt_bin[6] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4489_ (.RESET_B(net212),
    .D(_0117_),
    .Q(\pll_dig.flock.cnt_bin[7] ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4490_ (.RESET_B(net211),
    .D(_0118_),
    .Q(\pll_dig.flock.cnt_bin[8] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4491_ (.RESET_B(net211),
    .D(_0119_),
    .Q(\pll_dig.flock.cnt_bin[9] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4492_ (.RESET_B(net216),
    .D(_0106_),
    .Q(\pll_dig.flock.cnt_bin[10] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4493_ (.RESET_B(net216),
    .D(_0107_),
    .Q(\pll_dig.flock.cnt_bin[11] ),
    .CLK(clknet_5_15__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4494_ (.RESET_B(net217),
    .D(_0108_),
    .Q(\pll_dig.flock.cnt_bin[12] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4495_ (.RESET_B(net217),
    .D(_0109_),
    .Q(\pll_dig.flock.cnt_bin[13] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4496_ (.RESET_B(net217),
    .D(_0110_),
    .Q(\pll_dig.flock.cnt_bin[14] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4497_ (.RESET_B(net163),
    .D(_0012_),
    .Q(\pll_dig.FREQ_LOCKED ),
    .CLK(\clknet_4_5__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4498_ (.RESET_B(net163),
    .D(_0011_),
    .Q(\pll_dig.FREQ_ERR ),
    .CLK(\clknet_4_7__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4499_ (.RESET_B(net208),
    .D(net822),
    .Q(\pll_dig.flock.cnt_filt[0] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4500_ (.RESET_B(net208),
    .D(net881),
    .Q(\pll_dig.flock.cnt_filt[1] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4501_ (.RESET_B(net208),
    .D(net889),
    .Q(\pll_dig.flock.cnt_filt[2] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4502_ (.RESET_B(net208),
    .D(net885),
    .Q(\pll_dig.flock.cnt_filt[3] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4503_ (.RESET_B(net208),
    .D(net876),
    .Q(\pll_dig.flock.cnt_filt[4] ),
    .CLK(\clknet_4_10__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4504_ (.RESET_B(net208),
    .D(net859),
    .Q(\pll_dig.flock.cnt_filt[5] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4505_ (.RESET_B(net208),
    .D(net872),
    .Q(\pll_dig.flock.cnt_filt[6] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4506_ (.RESET_B(net210),
    .D(net846),
    .Q(\pll_dig.flock.cnt_filt[7] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4507_ (.RESET_B(net210),
    .D(net837),
    .Q(\pll_dig.flock.cnt_filt[8] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4508_ (.RESET_B(net209),
    .D(net829),
    .Q(\pll_dig.flock.cnt_filt[9] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4509_ (.RESET_B(net209),
    .D(net833),
    .Q(\pll_dig.flock.cnt_filt[10] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4510_ (.RESET_B(net209),
    .D(net842),
    .Q(\pll_dig.flock.cnt_filt[11] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4511_ (.RESET_B(net209),
    .D(net863),
    .Q(\pll_dig.flock.cnt_filt[12] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4512_ (.RESET_B(net210),
    .D(net868),
    .Q(\pll_dig.flock.cnt_filt[13] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4513_ (.RESET_B(net209),
    .D(net852),
    .Q(\pll_dig.flock.cnt_filt[14] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4514_ (.RESET_B(net209),
    .D(net825),
    .Q(\pll_dig.flock.cnt_filt[15] ),
    .CLK(\clknet_4_14__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4515_ (.RESET_B(net197),
    .D(_0021_),
    .Q(\pll_dig.flock.cnt_done[0] ),
    .CLK(\clknet_4_15__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4516_ (.RESET_B(net195),
    .D(net895),
    .Q(\pll_dig.flock.cnt_done[1] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4517_ (.RESET_B(net198),
    .D(_0023_),
    .Q(\pll_dig.flock.cnt_done[2] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4518_ (.RESET_B(net195),
    .D(_0024_),
    .Q(\pll_dig.flock.cnt_done[3] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4519_ (.RESET_B(net195),
    .D(_0025_),
    .Q(\pll_dig.flock.cnt_done[4] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4520_ (.RESET_B(net198),
    .D(_0026_),
    .Q(\pll_dig.flock.cnt_done[5] ),
    .CLK(\clknet_4_13__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4521_ (.RESET_B(net163),
    .D(_0027_),
    .Q(\pll_dig.flock.cnt_done[6] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4522_ (.RESET_B(net195),
    .D(_0028_),
    .Q(\pll_dig.flock.cnt_done[7] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4523_ (.RESET_B(net161),
    .D(net904),
    .Q(\pll_dig.flock.cnt_err[0] ),
    .CLK(\clknet_4_6__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4524_ (.RESET_B(net194),
    .D(_0030_),
    .Q(\pll_dig.flock.cnt_err[1] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4525_ (.RESET_B(net196),
    .D(_0031_),
    .Q(\pll_dig.flock.cnt_err[2] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4526_ (.RESET_B(net194),
    .D(_0032_),
    .Q(\pll_dig.flock.cnt_err[3] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4527_ (.RESET_B(net194),
    .D(_0033_),
    .Q(\pll_dig.flock.cnt_err[4] ),
    .CLK(\clknet_4_11__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4528_ (.RESET_B(net196),
    .D(_0034_),
    .Q(\pll_dig.flock.cnt_err[5] ),
    .CLK(\clknet_4_9__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4529_ (.RESET_B(net196),
    .D(_0035_),
    .Q(\pll_dig.flock.cnt_err[6] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4530_ (.RESET_B(net196),
    .D(_0036_),
    .Q(\pll_dig.flock.cnt_err[7] ),
    .CLK(\clknet_4_12__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4531_ (.RESET_B(net195),
    .D(_0013_),
    .Q(\pll_dig.flock.cnt_coarse_wait[0] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4532_ (.RESET_B(net195),
    .D(_0014_),
    .Q(\pll_dig.flock.cnt_coarse_wait[1] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4533_ (.RESET_B(net195),
    .D(_0015_),
    .Q(\pll_dig.flock.cnt_coarse_wait[2] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4534_ (.RESET_B(net194),
    .D(_0016_),
    .Q(\pll_dig.flock.cnt_coarse_wait[3] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4535_ (.RESET_B(net194),
    .D(_0017_),
    .Q(\pll_dig.flock.cnt_coarse_wait[4] ),
    .CLK(\clknet_4_8__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4536_ (.RESET_B(net194),
    .D(_0018_),
    .Q(\pll_dig.flock.cnt_coarse_wait[5] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4537_ (.RESET_B(net161),
    .D(_0019_),
    .Q(\pll_dig.flock.cnt_coarse_wait[6] ),
    .CLK(\clknet_4_2__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4538_ (.RESET_B(net194),
    .D(_0020_),
    .Q(\pll_dig.flock.cnt_coarse_wait[7] ),
    .CLK(\clknet_4_3__leaf_pll_dig.flock.REF_G ));
 sg13g2_dfrbpq_1 _4539_ (.RESET_B(net248),
    .D(_0098_),
    .Q(\pll_dig.flock.FCW_PA[1] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_tiehi _4539__249 (.L_HI(net248));
 sg13g2_dfrbpq_1 _4540_ (.RESET_B(net251),
    .D(_0099_),
    .Q(\pll_dig.flock.FCW_PA[2] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4540__252 (.L_HI(net251));
 sg13g2_dfrbpq_1 _4541_ (.RESET_B(net252),
    .D(_0100_),
    .Q(\pll_dig.flock.FCW_PA[3] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4541__253 (.L_HI(net252));
 sg13g2_dfrbpq_1 _4542_ (.RESET_B(net246),
    .D(_0101_),
    .Q(\pll_dig.flock.FCW_PA[4] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4542__247 (.L_HI(net246));
 sg13g2_dfrbpq_1 _4543_ (.RESET_B(net253),
    .D(_0102_),
    .Q(\pll_dig.flock.FCW_PA[5] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4543__254 (.L_HI(net253));
 sg13g2_dfrbpq_1 _4544_ (.RESET_B(net254),
    .D(_0103_),
    .Q(\pll_dig.flock.FCW_PA[6] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4544__255 (.L_HI(net254));
 sg13g2_dfrbpq_1 _4545_ (.RESET_B(net249),
    .D(_0104_),
    .Q(\pll_dig.flock.FCW_PA[7] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_tiehi _4545__250 (.L_HI(net249));
 sg13g2_dfrbpq_1 _4546_ (.RESET_B(net236),
    .D(_0097_),
    .Q(\pll_dig.flock.FCW_PA[8] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4546__237 (.L_HI(net236));
 sg13g2_dfrbpq_1 _4547_ (.RESET_B(net237),
    .D(_0096_),
    .Q(\pll_dig.flock.FCW_NA[0] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_tiehi _4547__238 (.L_HI(net237));
 sg13g2_dfrbpq_1 _4548_ (.RESET_B(net247),
    .D(_0120_),
    .Q(\pll_dig.flock.FCW_NA[1] ),
    .CLK(clknet_5_8__leaf_REF_regs));
 sg13g2_tiehi _4548__248 (.L_HI(net247));
 sg13g2_dfrbpq_1 _4549_ (.RESET_B(net245),
    .D(_0121_),
    .Q(\pll_dig.flock.FCW_NA[2] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4549__246 (.L_HI(net245));
 sg13g2_dfrbpq_1 _4550_ (.RESET_B(net244),
    .D(_0122_),
    .Q(\pll_dig.flock.FCW_NA[3] ),
    .CLK(clknet_5_1__leaf_REF_regs));
 sg13g2_tiehi _4550__245 (.L_HI(net244));
 sg13g2_dfrbpq_1 _4551_ (.RESET_B(net241),
    .D(_0123_),
    .Q(\pll_dig.flock.FCW_NA[4] ),
    .CLK(clknet_5_0__leaf_REF_regs));
 sg13g2_tiehi _4551__242 (.L_HI(net241));
 sg13g2_dfrbpq_1 _4552_ (.RESET_B(net240),
    .D(_0124_),
    .Q(\pll_dig.flock.FCW_NA[5] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4552__241 (.L_HI(net240));
 sg13g2_dfrbpq_1 _4553_ (.RESET_B(net243),
    .D(_0125_),
    .Q(\pll_dig.flock.FCW_NA[6] ),
    .CLK(clknet_5_2__leaf_REF_regs));
 sg13g2_tiehi _4553__244 (.L_HI(net243));
 sg13g2_dfrbpq_1 _4554_ (.RESET_B(net239),
    .D(_0126_),
    .Q(\pll_dig.flock.FCW_NA[7] ),
    .CLK(clknet_5_9__leaf_REF_regs));
 sg13g2_tiehi _4554__240 (.L_HI(net239));
 sg13g2_dfrbpq_1 _4555_ (.RESET_B(net238),
    .D(_0127_),
    .Q(\pll_dig.flock.FCW_NA[10] ),
    .CLK(clknet_5_11__leaf_REF_regs));
 sg13g2_tiehi _4555__239 (.L_HI(net238));
 sg13g2_dfrbpq_1 _4556_ (.RESET_B(net212),
    .D(net242),
    .Q(\pll_dig.flock.cap_valid ),
    .CLK(clknet_5_10__leaf_REF_regs));
 sg13g2_tiehi _4556__243 (.L_HI(net242));
 sg13g2_dfrbpq_1 _4557_ (.RESET_B(net198),
    .D(\pll_dig.flock.cnt_gray[0] ),
    .Q(\pll_dig.flock.cnt_gray_s1[0] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4558_ (.RESET_B(net199),
    .D(\pll_dig.flock.cnt_gray[1] ),
    .Q(\pll_dig.flock.cnt_gray_s1[1] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4559_ (.RESET_B(net202),
    .D(\pll_dig.flock.cnt_gray[2] ),
    .Q(\pll_dig.flock.cnt_gray_s1[2] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4560_ (.RESET_B(net202),
    .D(\pll_dig.flock.cnt_gray[3] ),
    .Q(\pll_dig.flock.cnt_gray_s1[3] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4561_ (.RESET_B(net203),
    .D(\pll_dig.flock.cnt_gray[4] ),
    .Q(\pll_dig.flock.cnt_gray_s1[4] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4562_ (.RESET_B(net203),
    .D(\pll_dig.flock.cnt_gray[5] ),
    .Q(\pll_dig.flock.cnt_gray_s1[5] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4563_ (.RESET_B(net213),
    .D(\pll_dig.flock.cnt_gray[6] ),
    .Q(\pll_dig.flock.cnt_gray_s1[6] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4564_ (.RESET_B(net212),
    .D(\pll_dig.flock.cnt_gray[7] ),
    .Q(\pll_dig.flock.cnt_gray_s1[7] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4565_ (.RESET_B(net211),
    .D(\pll_dig.flock.cnt_gray[8] ),
    .Q(\pll_dig.flock.cnt_gray_s1[8] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4566_ (.RESET_B(net211),
    .D(\pll_dig.flock.cnt_gray[9] ),
    .Q(\pll_dig.flock.cnt_gray_s1[9] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4567_ (.RESET_B(net216),
    .D(\pll_dig.flock.cnt_gray[10] ),
    .Q(\pll_dig.flock.cnt_gray_s1[10] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4568_ (.RESET_B(net216),
    .D(\pll_dig.flock.cnt_gray[11] ),
    .Q(\pll_dig.flock.cnt_gray_s1[11] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4569_ (.RESET_B(net217),
    .D(\pll_dig.flock.cnt_gray[12] ),
    .Q(\pll_dig.flock.cnt_gray_s1[12] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4570_ (.RESET_B(net218),
    .D(\pll_dig.flock.cnt_gray[13] ),
    .Q(\pll_dig.flock.cnt_gray_s1[13] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4571_ (.RESET_B(net218),
    .D(\pll_dig.flock.cnt_gray[14] ),
    .Q(\pll_dig.flock.cnt_gray_s1[14] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4572_ (.RESET_B(net218),
    .D(\pll_dig.flock.cnt_gray[15] ),
    .Q(\pll_dig.flock.cnt_gray_s1[15] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4573_ (.RESET_B(net199),
    .D(\pll_dig.flock.cnt_gray_s1[0] ),
    .Q(\pll_dig.flock.cnt_gray_s2[0] ),
    .CLK(clknet_5_5__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4574_ (.RESET_B(net199),
    .D(\pll_dig.flock.cnt_gray_s1[1] ),
    .Q(\pll_dig.flock.cnt_gray_s2[1] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4575_ (.RESET_B(net202),
    .D(\pll_dig.flock.cnt_gray_s1[2] ),
    .Q(\pll_dig.flock.cnt_gray_s2[2] ),
    .CLK(clknet_5_6__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4576_ (.RESET_B(net202),
    .D(\pll_dig.flock.cnt_gray_s1[3] ),
    .Q(\pll_dig.flock.cnt_gray_s2[3] ),
    .CLK(clknet_5_7__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4577_ (.RESET_B(net203),
    .D(\pll_dig.flock.cnt_gray_s1[4] ),
    .Q(\pll_dig.flock.cnt_gray_s2[4] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4578_ (.RESET_B(net203),
    .D(\pll_dig.flock.cnt_gray_s1[5] ),
    .Q(\pll_dig.flock.cnt_gray_s2[5] ),
    .CLK(clknet_5_13__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4579_ (.RESET_B(net213),
    .D(\pll_dig.flock.cnt_gray_s1[6] ),
    .Q(\pll_dig.flock.cnt_gray_s2[6] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4580_ (.RESET_B(net212),
    .D(\pll_dig.flock.cnt_gray_s1[7] ),
    .Q(\pll_dig.flock.cnt_gray_s2[7] ),
    .CLK(clknet_5_12__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4581_ (.RESET_B(net211),
    .D(\pll_dig.flock.cnt_gray_s1[8] ),
    .Q(\pll_dig.flock.cnt_gray_s2[8] ),
    .CLK(clknet_5_25__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4582_ (.RESET_B(net215),
    .D(\pll_dig.flock.cnt_gray_s1[9] ),
    .Q(\pll_dig.flock.cnt_gray_s2[9] ),
    .CLK(clknet_5_24__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4583_ (.RESET_B(net216),
    .D(\pll_dig.flock.cnt_gray_s1[10] ),
    .Q(\pll_dig.flock.cnt_gray_s2[10] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4584_ (.RESET_B(net217),
    .D(\pll_dig.flock.cnt_gray_s1[11] ),
    .Q(\pll_dig.flock.cnt_gray_s2[11] ),
    .CLK(clknet_5_27__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4585_ (.RESET_B(net217),
    .D(\pll_dig.flock.cnt_gray_s1[12] ),
    .Q(\pll_dig.flock.cnt_gray_s2[12] ),
    .CLK(clknet_5_26__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4586_ (.RESET_B(net219),
    .D(\pll_dig.flock.cnt_gray_s1[13] ),
    .Q(\pll_dig.flock.cnt_gray_s2[13] ),
    .CLK(clknet_5_30__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4587_ (.RESET_B(net230),
    .D(\pll_dig.flock.cnt_gray_s1[14] ),
    .Q(\pll_dig.flock.cnt_gray_s2[14] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4588_ (.RESET_B(net230),
    .D(\pll_dig.flock.cnt_gray_s1[15] ),
    .Q(\pll_dig.flock.cnt_gray_s2[15] ),
    .CLK(clknet_5_31__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4589_ (.RESET_B(net200),
    .D(_0045_),
    .Q(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[0] ),
    .CLK(clknet_3_0__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4590_ (.RESET_B(net201),
    .D(_0046_),
    .Q(\pll_dig.flock.counter_frontend.genblk1.genblk1.static_frontend.div_cnt[1] ),
    .CLK(clknet_3_2__leaf_MID_OUT));
 sg13g2_dfrbpq_1 _4591_ (.RESET_B(net166),
    .D(_0055_),
    .Q(\pll_dig.lock_detector.seen_n ),
    .CLK(net284));
 sg13g2_dfrbpq_1 _4592_ (.RESET_B(net166),
    .D(_0056_),
    .Q(\pll_dig.lock_detector.seen_p ),
    .CLK(net283));
 sg13g2_dfrbpq_1 _4593_ (.RESET_B(net186),
    .D(_0057_),
    .Q(\pll_dig.lock_detector.win_cnt[0] ),
    .CLK(net282));
 sg13g2_dfrbpq_1 _4594_ (.RESET_B(net186),
    .D(net923),
    .Q(\pll_dig.lock_detector.win_cnt[1] ),
    .CLK(net281));
 sg13g2_dfrbpq_1 _4595_ (.RESET_B(net186),
    .D(net916),
    .Q(\pll_dig.lock_detector.win_cnt[2] ),
    .CLK(net280));
 sg13g2_dfrbpq_1 _4596_ (.RESET_B(net169),
    .D(_0060_),
    .Q(\pll_dig.lock_detector.win_cnt[3] ),
    .CLK(net279));
 sg13g2_dfrbpq_1 _4597_ (.RESET_B(net169),
    .D(net235),
    .Q(\pll_dig.lock_detector.win_cnt[4] ),
    .CLK(net278));
 sg13g2_tielo _4597__236 (.L_LO(net235));
 sg13g2_dfrbpq_1 _4598_ (.RESET_B(net166),
    .D(_0052_),
    .Q(\pll_dig.lock_detector.bad_cnt[0] ),
    .CLK(net277));
 sg13g2_dfrbpq_1 _4599_ (.RESET_B(net166),
    .D(_0053_),
    .Q(\pll_dig.lock_detector.bad_cnt[1] ),
    .CLK(net276));
 sg13g2_dfrbpq_1 _4600_ (.RESET_B(net167),
    .D(net),
    .Q(\pll_dig.lock_detector.bad_cnt[2] ),
    .CLK(net275));
 sg13g2_tielo _4600__235 (.L_LO(net));
 sg13g2_dfrbpq_1 _4601_ (.RESET_B(net204),
    .D(\pll_dig.ref_wd.watch_s2 ),
    .Q(\pll_dig.ref_wd.watch_s3 ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4602_ (.RESET_B(net204),
    .D(\pll_dig.ref_wd.watch_s1 ),
    .Q(\pll_dig.ref_wd.watch_s2 ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4603_ (.RESET_B(net204),
    .D(clknet_1_1__leaf_REF),
    .Q(\pll_dig.ref_wd.watch_s1 ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4604_ (.RESET_B(net186),
    .D(\pll_dig.dlf.ILL_N_C ),
    .Q(\pll_dig.ILL_N ),
    .CLK(net274));
 sg13g2_dfrbpq_1 _4605_ (.RESET_B(net175),
    .D(\pll_dig.dlf.OUT_C[0] ),
    .Q(\pll_dig.FILTER_OUT[0] ),
    .CLK(net273));
 sg13g2_dfrbpq_1 _4606_ (.RESET_B(net175),
    .D(\pll_dig.dlf.OUT_C[1] ),
    .Q(\pll_dig.FILTER_OUT[1] ),
    .CLK(net272));
 sg13g2_dfrbpq_1 _4607_ (.RESET_B(net175),
    .D(net995),
    .Q(\pll_dig.FILTER_OUT[2] ),
    .CLK(net271));
 sg13g2_dfrbpq_1 _4608_ (.RESET_B(net178),
    .D(net985),
    .Q(\pll_dig.FILTER_OUT[3] ),
    .CLK(net270));
 sg13g2_dfrbpq_1 _4609_ (.RESET_B(net178),
    .D(net974),
    .Q(\pll_dig.FILTER_OUT[4] ),
    .CLK(net269));
 sg13g2_dfrbpq_1 _4610_ (.RESET_B(net180),
    .D(\pll_dig.dlf.OUT_C[5] ),
    .Q(\pll_dig.FILTER_OUT[5] ),
    .CLK(net268));
 sg13g2_dfrbpq_1 _4611_ (.RESET_B(net180),
    .D(\pll_dig.dlf.OUT_C[6] ),
    .Q(\pll_dig.FILTER_OUT[6] ),
    .CLK(net267));
 sg13g2_dfrbpq_1 _4612_ (.RESET_B(net188),
    .D(\pll_dig.dlf.OUT_C[7] ),
    .Q(\pll_dig.FILTER_OUT[7] ),
    .CLK(net266));
 sg13g2_dfrbpq_1 _4613_ (.RESET_B(net188),
    .D(\pll_dig.dlf.OUT_C[8] ),
    .Q(\pll_dig.FILTER_OUT[8] ),
    .CLK(net265));
 sg13g2_dfrbpq_1 _4614_ (.RESET_B(net188),
    .D(\pll_dig.dlf.OUT_C[9] ),
    .Q(\pll_dig.FILTER_OUT[9] ),
    .CLK(net264));
 sg13g2_dfrbpq_1 _4615_ (.RESET_B(net188),
    .D(net987),
    .Q(\pll_dig.FILTER_OUT[10] ),
    .CLK(net263));
 sg13g2_dfrbpq_1 _4616_ (.RESET_B(net184),
    .D(net989),
    .Q(\pll_dig.FILTER_OUT[11] ),
    .CLK(net262));
 sg13g2_dfrbpq_1 _4617_ (.RESET_B(net184),
    .D(net999),
    .Q(\pll_dig.FILTER_OUT[12] ),
    .CLK(net261));
 sg13g2_dfrbpq_1 _4618_ (.RESET_B(net183),
    .D(\pll_dig.dlf.OUT_C[13] ),
    .Q(\pll_dig.FILTER_OUT[13] ),
    .CLK(net260));
 sg13g2_dfrbpq_1 _4619_ (.RESET_B(net182),
    .D(\pll_dig.dlf.OUT_C[14] ),
    .Q(\pll_dig.FILTER_OUT[14] ),
    .CLK(net259));
 sg13g2_dfrbpq_1 _4620_ (.RESET_B(net183),
    .D(_0187_),
    .Q(_0130_),
    .CLK(net258));
 sg13g2_dfrbpq_1 _4621_ (.RESET_B(net186),
    .D(\pll_dig.dlf.ILL_P_C ),
    .Q(\pll_dig.ILL_P ),
    .CLK(net257));
 sg13g2_dfrbpq_1 _4622_ (.RESET_B(net167),
    .D(clknet_1_0__leaf_REF),
    .Q(\pll_dig.CKR ),
    .CLK(net341));
 sg13g2_dfrbpq_1 _4623_ (.RESET_B(net222),
    .D(net1012),
    .Q(\pll_dig.dco_fail ),
    .CLK(clknet_5_23__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4624_ (.RESET_B(net200),
    .D(net906),
    .Q(\pll_dig.fail_qq ),
    .CLK(net256));
 sg13g2_dfrbpq_1 _4625_ (.RESET_B(net214),
    .D(\pll_dig.out_edges_next[0] ),
    .Q(\pll_dig.out_edges[0] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4626_ (.RESET_B(net228),
    .D(\pll_dig.out_edges_next[1] ),
    .Q(\pll_dig.out_edges[1] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4627_ (.RESET_B(net214),
    .D(\pll_dig.out_edges_next[2] ),
    .Q(\pll_dig.out_edges[2] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4628_ (.RESET_B(net214),
    .D(\pll_dig.out_edges_next[3] ),
    .Q(\pll_dig.out_edges[3] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4629_ (.RESET_B(net213),
    .D(\pll_dig.out_edges_next[4] ),
    .Q(\pll_dig.out_edges[4] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4630_ (.RESET_B(net213),
    .D(\pll_dig.out_edges_next[5] ),
    .Q(\pll_dig.out_edges[5] ),
    .CLK(\clknet_2_2__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4631_ (.RESET_B(net213),
    .D(\pll_dig.out_edges_next[6] ),
    .Q(\pll_dig.out_edges[6] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4632_ (.RESET_B(net205),
    .D(\pll_dig.out_edges_next[7] ),
    .Q(\pll_dig.out_edges[7] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4633_ (.RESET_B(net205),
    .D(\pll_dig.out_edges_next[8] ),
    .Q(\pll_dig.out_edges[8] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4634_ (.RESET_B(net224),
    .D(\pll_dig.out_edges_next[9] ),
    .Q(\pll_dig.out_edges[9] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4635_ (.RESET_B(net223),
    .D(_0051_),
    .Q(\pll_dig.fail_q ),
    .CLK(net255));
 sg13g2_dfrbpq_1 _4636_ (.RESET_B(net160),
    .D(\pll_dig.COARSE_MUX_D[0] ),
    .Q(\COARSE_MUX[0] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4637_ (.RESET_B(net160),
    .D(\pll_dig.COARSE_MUX_D[1] ),
    .Q(\COARSE_MUX[1] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4638_ (.RESET_B(net157),
    .D(\pll_dig.COARSE_MUX_D[2] ),
    .Q(\COARSE_MUX[2] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4639_ (.RESET_B(net157),
    .D(\pll_dig.COARSE_MUX_D[3] ),
    .Q(\COARSE_MUX[3] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4640_ (.RESET_B(net157),
    .D(\pll_dig.COARSE_MUX_D[4] ),
    .Q(\COARSE_MUX[4] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4641_ (.RESET_B(net158),
    .D(\pll_dig.COARSE_MUX_D[5] ),
    .Q(\COARSE_MUX[5] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4642_ (.RESET_B(net154),
    .D(\pll_dig.COARSE_MUX_D[6] ),
    .Q(\COARSE_MUX[6] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4643_ (.RESET_B(net154),
    .D(\pll_dig.COARSE_MUX_D[7] ),
    .Q(\COARSE_MUX[7] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4644_ (.RESET_B(net154),
    .D(\pll_dig.COARSE_MUX_D[8] ),
    .Q(\COARSE_MUX[8] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4645_ (.RESET_B(net154),
    .D(\pll_dig.COARSE_MUX_D[9] ),
    .Q(\COARSE_MUX[9] ),
    .CLK(\clknet_3_2__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4646_ (.RESET_B(net152),
    .D(\pll_dig.COARSE_MUX_D[10] ),
    .Q(\COARSE_MUX[10] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4647_ (.RESET_B(net152),
    .D(\pll_dig.COARSE_MUX_D[11] ),
    .Q(\COARSE_MUX[11] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4648_ (.RESET_B(net152),
    .D(\pll_dig.COARSE_MUX_D[12] ),
    .Q(\COARSE_MUX[12] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4649_ (.RESET_B(net153),
    .D(\pll_dig.COARSE_MUX_D[13] ),
    .Q(\COARSE_MUX[13] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4650_ (.RESET_B(net152),
    .D(\pll_dig.COARSE_MUX_D[14] ),
    .Q(\COARSE_MUX[14] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4651_ (.RESET_B(net230),
    .D(\pll_dig.out_edges_g2[0] ),
    .Q(\pll_dig.out_edges_g2_q[0] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4652_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_g2[1] ),
    .Q(\pll_dig.out_edges_g2_q[1] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4653_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_g2[2] ),
    .Q(\pll_dig.out_edges_g2_q[2] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4654_ (.RESET_B(net228),
    .D(\pll_dig.out_edges_g2[3] ),
    .Q(\pll_dig.out_edges_g2_q[3] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4655_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_g2[4] ),
    .Q(\pll_dig.out_edges_g2_q[4] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4656_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g2[5] ),
    .Q(\pll_dig.out_edges_g2_q[5] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4657_ (.RESET_B(net229),
    .D(\pll_dig.out_edges_g2[6] ),
    .Q(\pll_dig.out_edges_g2_q[6] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4658_ (.RESET_B(net230),
    .D(\pll_dig.out_edges_g2[7] ),
    .Q(\pll_dig.out_edges_g2_q[7] ),
    .CLK(clknet_5_19__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4659_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_g2[8] ),
    .Q(\pll_dig.out_edges_g2_q[8] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4660_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g2[9] ),
    .Q(\pll_dig.out_edges_g2_q[9] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4661_ (.RESET_B(net228),
    .D(\pll_dig.out_edges_g1[0] ),
    .Q(\pll_dig.out_edges_g2[0] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4662_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g1[1] ),
    .Q(\pll_dig.out_edges_g2[1] ),
    .CLK(clknet_5_17__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4663_ (.RESET_B(net229),
    .D(\pll_dig.out_edges_g1[2] ),
    .Q(\pll_dig.out_edges_g2[2] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4664_ (.RESET_B(net229),
    .D(\pll_dig.out_edges_g1[3] ),
    .Q(\pll_dig.out_edges_g2[3] ),
    .CLK(clknet_5_28__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4665_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_g1[4] ),
    .Q(\pll_dig.out_edges_g2[4] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4666_ (.RESET_B(net224),
    .D(\pll_dig.out_edges_g1[5] ),
    .Q(\pll_dig.out_edges_g2[5] ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4667_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_g1[6] ),
    .Q(\pll_dig.out_edges_g2[6] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4668_ (.RESET_B(net229),
    .D(\pll_dig.out_edges_g1[7] ),
    .Q(\pll_dig.out_edges_g2[7] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4669_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g1[8] ),
    .Q(\pll_dig.out_edges_g2[8] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4670_ (.RESET_B(net226),
    .D(\pll_dig.out_edges_g1[9] ),
    .Q(\pll_dig.out_edges_g2[9] ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4671_ (.RESET_B(net229),
    .D(\pll_dig.out_edges_gray[0] ),
    .Q(\pll_dig.out_edges_g1[0] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4672_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_gray[1] ),
    .Q(\pll_dig.out_edges_g1[1] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4673_ (.RESET_B(net228),
    .D(\pll_dig.out_edges_gray[2] ),
    .Q(\pll_dig.out_edges_g1[2] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4674_ (.RESET_B(net228),
    .D(\pll_dig.out_edges_gray[3] ),
    .Q(\pll_dig.out_edges_g1[3] ),
    .CLK(clknet_5_29__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4675_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_gray[4] ),
    .Q(\pll_dig.out_edges_g1[4] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4676_ (.RESET_B(net224),
    .D(\pll_dig.out_edges_gray[5] ),
    .Q(\pll_dig.out_edges_g1[5] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4677_ (.RESET_B(net227),
    .D(\pll_dig.out_edges_gray[6] ),
    .Q(\pll_dig.out_edges_g1[6] ),
    .CLK(clknet_5_18__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4678_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_gray[7] ),
    .Q(\pll_dig.out_edges_g1[7] ),
    .CLK(clknet_5_16__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4679_ (.RESET_B(net225),
    .D(\pll_dig.out_edges_gray[8] ),
    .Q(\pll_dig.out_edges_g1[8] ),
    .CLK(clknet_5_22__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4680_ (.RESET_B(net224),
    .D(\pll_dig.out_edges[9] ),
    .Q(\pll_dig.out_edges_g1[9] ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4681_ (.RESET_B(net232),
    .D(_0009_),
    .Q(\pll_dig.div.rst_n ),
    .CLK(clknet_4_12_0_net59_regs));
 sg13g2_dfrbpq_1 _4682_ (.RESET_B(net204),
    .D(net343),
    .Q(\pll_dig.out_div2 ),
    .CLK(clknet_4_5_0_net59_regs));
 sg13g2_dfrbpq_1 _4683_ (.RESET_B(net183),
    .D(\pll_dig.dsm_impl.locked_dsm_s1 ),
    .Q(\pll_dig.dsm_impl.locked_dsm_s2 ),
    .CLK(\clknet_1_1__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_dfrbpq_1 _4684_ (.RESET_B(net222),
    .D(\pll_dig.clr_r2 ),
    .Q(\pll_dig.clr_r3 ),
    .CLK(clknet_5_21__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4685_ (.RESET_B(net183),
    .D(net855),
    .Q(\pll_dig.dsm_impl.locked_dsm_s1 ),
    .CLK(\clknet_1_0__leaf_pll_dig.dsm_impl.DSM_CK_regs ));
 sg13g2_dfrbpq_1 _4686_ (.RESET_B(net152),
    .D(\pll_dig.MID_MUX_D[0] ),
    .Q(\MID_MUX[0] ),
    .CLK(\clknet_3_0__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4687_ (.RESET_B(net153),
    .D(\pll_dig.MID_MUX_D[1] ),
    .Q(\MID_MUX[1] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4688_ (.RESET_B(net153),
    .D(\pll_dig.MID_MUX_D[2] ),
    .Q(\MID_MUX[2] ),
    .CLK(\clknet_3_1__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4689_ (.RESET_B(net157),
    .D(\pll_dig.MID_MUX_D[3] ),
    .Q(\MID_MUX[3] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4690_ (.RESET_B(net158),
    .D(\pll_dig.MID_MUX_D[4] ),
    .Q(\MID_MUX[4] ),
    .CLK(\clknet_3_3__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4691_ (.RESET_B(net158),
    .D(\pll_dig.MID_MUX_D[5] ),
    .Q(\MID_MUX[5] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4692_ (.RESET_B(net159),
    .D(\pll_dig.MID_MUX_D[6] ),
    .Q(\MID_MUX[6] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4693_ (.RESET_B(net167),
    .D(\pll_dig.MID_MUX_D[7] ),
    .Q(\MID_MUX[7] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4694_ (.RESET_B(net167),
    .D(\pll_dig.MID_MUX_D[8] ),
    .Q(\MID_MUX[8] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4695_ (.RESET_B(net159),
    .D(\pll_dig.MID_MUX_D[9] ),
    .Q(\MID_MUX[9] ),
    .CLK(\clknet_3_7__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4696_ (.RESET_B(net165),
    .D(\pll_dig.MID_MUX_D[10] ),
    .Q(\MID_MUX[10] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4697_ (.RESET_B(net159),
    .D(\pll_dig.MID_MUX_D[11] ),
    .Q(\MID_MUX[11] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4698_ (.RESET_B(net159),
    .D(\pll_dig.MID_MUX_D[12] ),
    .Q(\MID_MUX[12] ),
    .CLK(\clknet_3_6__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4699_ (.RESET_B(net160),
    .D(\pll_dig.MID_MUX_D[13] ),
    .Q(\MID_MUX[13] ),
    .CLK(\clknet_3_4__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4700_ (.RESET_B(net157),
    .D(\pll_dig.MID_MUX_D[14] ),
    .Q(\MID_MUX[14] ),
    .CLK(\clknet_3_5__leaf_pll_dig.CKR ));
 sg13g2_dfrbpq_1 _4701_ (.RESET_B(net186),
    .D(_0221_),
    .Q(_0135_),
    .CLK(\clknet_4_7_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4702_ (.RESET_B(net169),
    .D(net1050),
    .Q(_0134_),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4703_ (.RESET_B(net222),
    .D(\pll_dig.clr_r1 ),
    .Q(\pll_dig.clr_r2 ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_2 _4704_ (.RESET_B(net175),
    .D(net1030),
    .Q(\pll_dig.dsm_impl.FCWF[0] ),
    .CLK(\clknet_4_8_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4705_ (.RESET_B(net177),
    .D(net1028),
    .Q(\pll_dig.dsm_impl.FCWF[1] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4706_ (.RESET_B(net177),
    .D(net1036),
    .Q(\pll_dig.dsm_impl.FCWF[2] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4707_ (.RESET_B(net178),
    .D(net1042),
    .Q(\pll_dig.dsm_impl.FCWF[3] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4708_ (.RESET_B(net178),
    .D(net1040),
    .Q(\pll_dig.dsm_impl.FCWF[4] ),
    .CLK(\clknet_4_9_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4709_ (.RESET_B(net179),
    .D(net1034),
    .Q(\pll_dig.dsm_impl.FCWF[5] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4710_ (.RESET_B(net180),
    .D(net1026),
    .Q(\pll_dig.dsm_impl.FCWF[6] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4711_ (.RESET_B(net188),
    .D(net1038),
    .Q(\pll_dig.dsm_impl.FCWF[7] ),
    .CLK(\clknet_4_14_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4712_ (.RESET_B(net188),
    .D(net1024),
    .Q(\pll_dig.dsm_impl.FCWF[8] ),
    .CLK(\clknet_4_13_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4713_ (.RESET_B(net188),
    .D(net1032),
    .Q(\pll_dig.dsm_impl.FCWF[9] ),
    .CLK(\clknet_4_12_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4714_ (.RESET_B(net188),
    .D(net1016),
    .Q(\pll_dig.dsm_impl.FCWF[10] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4715_ (.RESET_B(net184),
    .D(net1014),
    .Q(\pll_dig.dsm_impl.FCWF[11] ),
    .CLK(\clknet_4_6_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4716_ (.RESET_B(net182),
    .D(\pll_dig.FILTER_DEC_RAW[0] ),
    .Q(\pll_dig.FILTER_DEC[0] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4717_ (.RESET_B(net182),
    .D(\pll_dig.FILTER_DEC_RAW[1] ),
    .Q(\pll_dig.FILTER_DEC[1] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4718_ (.RESET_B(net183),
    .D(\pll_dig.FILTER_DEC_RAW[2] ),
    .Q(\pll_dig.FILTER_DEC[2] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4719_ (.RESET_B(net185),
    .D(\pll_dig.FILTER_DEC_RAW[3] ),
    .Q(\pll_dig.FILTER_DEC[3] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4720_ (.RESET_B(net185),
    .D(\pll_dig.FILTER_DEC_RAW[4] ),
    .Q(\pll_dig.FILTER_DEC[4] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4721_ (.RESET_B(net201),
    .D(\pll_dig.clr_toggle ),
    .Q(\pll_dig.clr_r1 ),
    .CLK(clknet_5_20__leaf_REF_regs));
 sg13g2_dfrbpq_1 _4722_ (.RESET_B(net155),
    .D(\pll_dig.FINE_MUX_D[0] ),
    .Q(\FINE_MUX[0] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4723_ (.RESET_B(net174),
    .D(\pll_dig.FINE_MUX_D[1] ),
    .Q(\FINE_MUX[1] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4724_ (.RESET_B(net156),
    .D(\pll_dig.FINE_MUX_D[2] ),
    .Q(\FINE_MUX[2] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4725_ (.RESET_B(net156),
    .D(\pll_dig.FINE_MUX_D[3] ),
    .Q(\FINE_MUX[3] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4726_ (.RESET_B(net166),
    .D(\pll_dig.FINE_MUX_D[4] ),
    .Q(\FINE_MUX[4] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4727_ (.RESET_B(net174),
    .D(\pll_dig.FINE_MUX_D[5] ),
    .Q(\FINE_MUX[5] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4728_ (.RESET_B(net156),
    .D(\pll_dig.FINE_MUX_D[6] ),
    .Q(\FINE_MUX[6] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4729_ (.RESET_B(net156),
    .D(\pll_dig.FINE_MUX_D[7] ),
    .Q(\FINE_MUX[7] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4730_ (.RESET_B(net174),
    .D(\pll_dig.FINE_MUX_D[8] ),
    .Q(\FINE_MUX[8] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4731_ (.RESET_B(net174),
    .D(\pll_dig.FINE_MUX_D[9] ),
    .Q(\FINE_MUX[9] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4732_ (.RESET_B(net155),
    .D(\pll_dig.FINE_MUX_D[10] ),
    .Q(\FINE_MUX[10] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4733_ (.RESET_B(net155),
    .D(\pll_dig.FINE_MUX_D[11] ),
    .Q(\FINE_MUX[11] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4734_ (.RESET_B(net155),
    .D(\pll_dig.FINE_MUX_D[12] ),
    .Q(\FINE_MUX[12] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4735_ (.RESET_B(net173),
    .D(\pll_dig.FINE_MUX_D[13] ),
    .Q(\FINE_MUX[13] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4736_ (.RESET_B(net155),
    .D(\pll_dig.FINE_MUX_D[14] ),
    .Q(\FINE_MUX[14] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4737_ (.RESET_B(net155),
    .D(\pll_dig.FILTER_DEC[4] ),
    .Q(\FINE_MUX[15] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4738_ (.RESET_B(net173),
    .D(\pll_dig.FINE_MUX_D[16] ),
    .Q(\FINE_MUX[16] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4739_ (.RESET_B(net173),
    .D(\pll_dig.FINE_MUX_D[17] ),
    .Q(\FINE_MUX[17] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4740_ (.RESET_B(net173),
    .D(\pll_dig.FINE_MUX_D[18] ),
    .Q(\FINE_MUX[18] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4741_ (.RESET_B(net155),
    .D(\pll_dig.FINE_MUX_D[19] ),
    .Q(\FINE_MUX[19] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4742_ (.RESET_B(net155),
    .D(\pll_dig.FINE_MUX_D[20] ),
    .Q(\FINE_MUX[20] ),
    .CLK(\clknet_4_2_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4743_ (.RESET_B(net174),
    .D(\pll_dig.FINE_MUX_D[21] ),
    .Q(\FINE_MUX[21] ),
    .CLK(\clknet_4_3_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4744_ (.RESET_B(net156),
    .D(\pll_dig.FINE_MUX_D[22] ),
    .Q(\FINE_MUX[22] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4745_ (.RESET_B(net166),
    .D(\pll_dig.FINE_MUX_D[23] ),
    .Q(\FINE_MUX[23] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4746_ (.RESET_B(net166),
    .D(\pll_dig.FINE_MUX_D[24] ),
    .Q(\FINE_MUX[24] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4747_ (.RESET_B(net181),
    .D(\pll_dig.FINE_MUX_D[25] ),
    .Q(\FINE_MUX[25] ),
    .CLK(\clknet_4_0_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4748_ (.RESET_B(net166),
    .D(\pll_dig.FINE_MUX_D[26] ),
    .Q(\FINE_MUX[26] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4749_ (.RESET_B(net171),
    .D(\pll_dig.FINE_MUX_D[27] ),
    .Q(\FINE_MUX[27] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4750_ (.RESET_B(net171),
    .D(\pll_dig.FINE_MUX_D[28] ),
    .Q(\FINE_MUX[28] ),
    .CLK(\clknet_4_5_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4751_ (.RESET_B(net181),
    .D(\pll_dig.FINE_MUX_D[29] ),
    .Q(\FINE_MUX[29] ),
    .CLK(\clknet_4_1_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4752_ (.RESET_B(net182),
    .D(\pll_dig.FINE_MUX_D[30] ),
    .Q(\FINE_MUX[30] ),
    .CLK(\clknet_4_4_0_pll_dig.dsm_impl.DSM_CK_G ));
 sg13g2_dfrbpq_1 _4753_ (.RESET_B(net228),
    .D(_0000_),
    .Q(\pll_dig.out_edges_gray[0] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4754_ (.RESET_B(net225),
    .D(_0001_),
    .Q(\pll_dig.out_edges_gray[1] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4755_ (.RESET_B(net228),
    .D(_0002_),
    .Q(\pll_dig.out_edges_gray[2] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4756_ (.RESET_B(net228),
    .D(_0003_),
    .Q(\pll_dig.out_edges_gray[3] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4757_ (.RESET_B(net227),
    .D(_0004_),
    .Q(\pll_dig.out_edges_gray[4] ),
    .CLK(\clknet_2_3__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4758_ (.RESET_B(net204),
    .D(_0005_),
    .Q(\pll_dig.out_edges_gray[5] ),
    .CLK(\clknet_2_0__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4759_ (.RESET_B(net227),
    .D(_0006_),
    .Q(\pll_dig.out_edges_gray[6] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4760_ (.RESET_B(net225),
    .D(_0007_),
    .Q(\pll_dig.out_edges_gray[7] ),
    .CLK(\clknet_2_1__leaf_pll_dig.out_div2 ));
 sg13g2_dfrbpq_1 _4761_ (.RESET_B(net225),
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
 sg13g2_buf_16 delaybuf_4_REF (.X(delaynet_4_REF),
    .A(delaynet_3_REF));
 sg13g2_buf_1 fanout100 (.A(net101),
    .X(net100));
 sg13g2_buf_1 fanout101 (.A(_0567_),
    .X(net101));
 sg13g2_buf_1 fanout102 (.A(_1369_),
    .X(net102));
 sg13g2_buf_1 fanout103 (.A(\pll_dig.FILTER_DEC[2] ),
    .X(net103));
 sg13g2_buf_1 fanout104 (.A(net105),
    .X(net104));
 sg13g2_buf_1 fanout105 (.A(_0135_),
    .X(net105));
 sg13g2_buf_1 fanout106 (.A(net109),
    .X(net106));
 sg13g2_buf_1 fanout107 (.A(net109),
    .X(net107));
 sg13g2_buf_1 fanout108 (.A(net109),
    .X(net108));
 sg13g2_buf_1 fanout109 (.A(_0135_),
    .X(net109));
 sg13g2_buf_1 fanout110 (.A(_0135_),
    .X(net110));
 sg13g2_buf_1 fanout111 (.A(_0676_),
    .X(net111));
 sg13g2_buf_1 fanout112 (.A(_1625_),
    .X(net112));
 sg13g2_buf_1 fanout113 (.A(_1625_),
    .X(net113));
 sg13g2_buf_1 fanout114 (.A(_1625_),
    .X(net114));
 sg13g2_buf_1 fanout115 (.A(net116),
    .X(net115));
 sg13g2_buf_1 fanout116 (.A(_1114_),
    .X(net116));
 sg13g2_buf_1 fanout117 (.A(net1000),
    .X(net117));
 sg13g2_buf_1 fanout118 (.A(net1004),
    .X(net118));
 sg13g2_buf_1 fanout119 (.A(_0852_),
    .X(net119));
 sg13g2_buf_1 fanout120 (.A(_0852_),
    .X(net120));
 sg13g2_buf_1 fanout121 (.A(net122),
    .X(net121));
 sg13g2_buf_1 fanout122 (.A(_0851_),
    .X(net122));
 sg13g2_buf_1 fanout123 (.A(net125),
    .X(net123));
 sg13g2_buf_1 fanout124 (.A(net125),
    .X(net124));
 sg13g2_buf_1 fanout125 (.A(_0851_),
    .X(net125));
 sg13g2_buf_1 fanout126 (.A(_0462_),
    .X(net126));
 sg13g2_buf_1 fanout127 (.A(_0462_),
    .X(net127));
 sg13g2_buf_1 fanout128 (.A(net131),
    .X(net128));
 sg13g2_buf_2 fanout129 (.A(net131),
    .X(net129));
 sg13g2_buf_1 fanout130 (.A(net131),
    .X(net130));
 sg13g2_buf_1 fanout131 (.A(\pll_dig.div.rst_n ),
    .X(net131));
 sg13g2_buf_1 fanout132 (.A(net134),
    .X(net132));
 sg13g2_buf_1 fanout133 (.A(net134),
    .X(net133));
 sg13g2_buf_1 fanout134 (.A(\pll_dig.div.rst_n ),
    .X(net134));
 sg13g2_buf_2 fanout135 (.A(net138),
    .X(net135));
 sg13g2_buf_8 fanout136 (.A(net137),
    .X(net136));
 sg13g2_buf_8 fanout137 (.A(net138),
    .X(net137));
 sg13g2_buf_8 fanout138 (.A(\pll_dig.div.rst_n ),
    .X(net138));
 sg13g2_buf_1 fanout139 (.A(\pll_dig.flock.cnt_filt[7] ),
    .X(net139));
 sg13g2_buf_1 fanout140 (.A(\pll_dig.flock.cnt_filt[2] ),
    .X(net140));
 sg13g2_buf_1 fanout141 (.A(\pll_dig.div.div[6] ),
    .X(net141));
 sg13g2_buf_1 fanout142 (.A(\pll_dig.div.div[5] ),
    .X(net142));
 sg13g2_buf_1 fanout143 (.A(\pll_dig.div.div[5] ),
    .X(net143));
 sg13g2_buf_4 fanout144 (.X(net144),
    .A(\pll_dig.div.div[4] ));
 sg13g2_buf_8 fanout145 (.A(\pll_dig.div.div[3] ),
    .X(net145));
 sg13g2_buf_1 fanout146 (.A(\pll_dig.div.div[3] ),
    .X(net146));
 sg13g2_buf_2 fanout147 (.A(\pll_dig.div.div[2] ),
    .X(net147));
 sg13g2_buf_8 fanout149 (.A(\pll_dig.div.div[0] ),
    .X(net149));
 sg13g2_buf_1 fanout150 (.A(\pll_dig.flock.cap_valid ),
    .X(net150));
 sg13g2_buf_1 fanout151 (.A(\pll_dig.flock.cap_valid ),
    .X(net151));
 sg13g2_buf_1 fanout152 (.A(net153),
    .X(net152));
 sg13g2_buf_1 fanout153 (.A(net154),
    .X(net153));
 sg13g2_buf_1 fanout154 (.A(net172),
    .X(net154));
 sg13g2_buf_1 fanout155 (.A(net172),
    .X(net155));
 sg13g2_buf_1 fanout156 (.A(net172),
    .X(net156));
 sg13g2_buf_1 fanout157 (.A(net158),
    .X(net157));
 sg13g2_buf_1 fanout158 (.A(net165),
    .X(net158));
 sg13g2_buf_1 fanout159 (.A(net165),
    .X(net159));
 sg13g2_buf_1 fanout160 (.A(net164),
    .X(net160));
 sg13g2_buf_1 fanout161 (.A(net164),
    .X(net161));
 sg13g2_buf_1 fanout162 (.A(net164),
    .X(net162));
 sg13g2_buf_1 fanout163 (.A(net164),
    .X(net163));
 sg13g2_buf_1 fanout164 (.A(net165),
    .X(net164));
 sg13g2_buf_1 fanout165 (.A(net172),
    .X(net165));
 sg13g2_buf_1 fanout166 (.A(net171),
    .X(net166));
 sg13g2_buf_1 fanout167 (.A(net171),
    .X(net167));
 sg13g2_buf_1 fanout168 (.A(net170),
    .X(net168));
 sg13g2_buf_1 fanout169 (.A(net170),
    .X(net169));
 sg13g2_buf_1 fanout170 (.A(net171),
    .X(net170));
 sg13g2_buf_1 fanout171 (.A(net172),
    .X(net171));
 sg13g2_buf_1 fanout172 (.A(net233),
    .X(net172));
 sg13g2_buf_1 fanout173 (.A(net174),
    .X(net173));
 sg13g2_buf_1 fanout174 (.A(net181),
    .X(net174));
 sg13g2_buf_1 fanout175 (.A(net177),
    .X(net175));
 sg13g2_buf_1 fanout176 (.A(net177),
    .X(net176));
 sg13g2_buf_1 fanout177 (.A(net181),
    .X(net177));
 sg13g2_buf_1 fanout178 (.A(net180),
    .X(net178));
 sg13g2_buf_1 fanout179 (.A(net180),
    .X(net179));
 sg13g2_buf_1 fanout180 (.A(net181),
    .X(net180));
 sg13g2_buf_1 fanout181 (.A(net193),
    .X(net181));
 sg13g2_buf_1 fanout182 (.A(net183),
    .X(net182));
 sg13g2_buf_1 fanout183 (.A(net185),
    .X(net183));
 sg13g2_buf_1 fanout184 (.A(net185),
    .X(net184));
 sg13g2_buf_1 fanout185 (.A(net193),
    .X(net185));
 sg13g2_buf_1 fanout186 (.A(net187),
    .X(net186));
 sg13g2_buf_1 fanout187 (.A(net193),
    .X(net187));
 sg13g2_buf_1 fanout188 (.A(net191),
    .X(net188));
 sg13g2_buf_1 fanout189 (.A(net191),
    .X(net189));
 sg13g2_buf_1 fanout190 (.A(net191),
    .X(net190));
 sg13g2_buf_1 fanout191 (.A(net192),
    .X(net191));
 sg13g2_buf_1 fanout192 (.A(net193),
    .X(net192));
 sg13g2_buf_1 fanout193 (.A(net233),
    .X(net193));
 sg13g2_buf_1 fanout194 (.A(net195),
    .X(net194));
 sg13g2_buf_1 fanout195 (.A(net197),
    .X(net195));
 sg13g2_buf_1 fanout196 (.A(net197),
    .X(net196));
 sg13g2_buf_1 fanout197 (.A(net221),
    .X(net197));
 sg13g2_buf_1 fanout198 (.A(net199),
    .X(net198));
 sg13g2_buf_1 fanout199 (.A(net207),
    .X(net199));
 sg13g2_buf_1 fanout200 (.A(net201),
    .X(net200));
 sg13g2_buf_1 fanout201 (.A(net207),
    .X(net201));
 sg13g2_buf_1 fanout202 (.A(net206),
    .X(net202));
 sg13g2_buf_1 fanout203 (.A(net206),
    .X(net203));
 sg13g2_buf_1 fanout204 (.A(net206),
    .X(net204));
 sg13g2_buf_1 fanout205 (.A(net206),
    .X(net205));
 sg13g2_buf_1 fanout206 (.A(net207),
    .X(net206));
 sg13g2_buf_1 fanout207 (.A(net221),
    .X(net207));
 sg13g2_buf_1 fanout208 (.A(net210),
    .X(net208));
 sg13g2_buf_1 fanout209 (.A(net210),
    .X(net209));
 sg13g2_buf_1 fanout210 (.A(net221),
    .X(net210));
 sg13g2_buf_1 fanout211 (.A(net212),
    .X(net211));
 sg13g2_buf_1 fanout212 (.A(net215),
    .X(net212));
 sg13g2_buf_1 fanout213 (.A(net215),
    .X(net213));
 sg13g2_buf_1 fanout214 (.A(net215),
    .X(net214));
 sg13g2_buf_1 fanout215 (.A(net220),
    .X(net215));
 sg13g2_buf_1 fanout216 (.A(net220),
    .X(net216));
 sg13g2_buf_1 fanout217 (.A(net220),
    .X(net217));
 sg13g2_buf_1 fanout218 (.A(net219),
    .X(net218));
 sg13g2_buf_1 fanout219 (.A(net220),
    .X(net219));
 sg13g2_buf_1 fanout220 (.A(net221),
    .X(net220));
 sg13g2_buf_1 fanout221 (.A(net233),
    .X(net221));
 sg13g2_buf_1 fanout222 (.A(net223),
    .X(net222));
 sg13g2_buf_1 fanout223 (.A(net232),
    .X(net223));
 sg13g2_buf_1 fanout224 (.A(net226),
    .X(net224));
 sg13g2_buf_1 fanout225 (.A(net226),
    .X(net225));
 sg13g2_buf_1 fanout226 (.A(net232),
    .X(net226));
 sg13g2_buf_1 fanout227 (.A(net229),
    .X(net227));
 sg13g2_buf_1 fanout228 (.A(net229),
    .X(net228));
 sg13g2_buf_1 fanout229 (.A(net230),
    .X(net229));
 sg13g2_buf_1 fanout230 (.A(net231),
    .X(net230));
 sg13g2_buf_1 fanout231 (.A(net232),
    .X(net231));
 sg13g2_buf_1 fanout232 (.A(net233),
    .X(net232));
 sg13g2_buf_1 fanout233 (.A(net47),
    .X(net233));
 sg13g2_buf_1 fanout234 (.A(net46),
    .X(net234));
 sg13g2_buf_1 fanout61 (.A(_1176_),
    .X(net61));
 sg13g2_buf_1 fanout62 (.A(_1176_),
    .X(net62));
 sg13g2_buf_1 fanout63 (.A(_1903_),
    .X(net63));
 sg13g2_buf_1 fanout64 (.A(_1206_),
    .X(net64));
 sg13g2_buf_1 fanout65 (.A(_1206_),
    .X(net65));
 sg13g2_buf_1 fanout66 (.A(_1933_),
    .X(net66));
 sg13g2_buf_1 fanout67 (.A(_1933_),
    .X(net67));
 sg13g2_buf_1 fanout68 (.A(net69),
    .X(net68));
 sg13g2_buf_1 fanout69 (.A(_0849_),
    .X(net69));
 sg13g2_buf_1 fanout70 (.A(net73),
    .X(net70));
 sg13g2_buf_1 fanout71 (.A(net72),
    .X(net71));
 sg13g2_buf_1 fanout72 (.A(net73),
    .X(net72));
 sg13g2_buf_1 fanout73 (.A(_0848_),
    .X(net73));
 sg13g2_buf_1 fanout74 (.A(net78),
    .X(net74));
 sg13g2_buf_1 fanout75 (.A(net78),
    .X(net75));
 sg13g2_buf_1 fanout76 (.A(net78),
    .X(net76));
 sg13g2_buf_1 fanout77 (.A(net78),
    .X(net77));
 sg13g2_buf_1 fanout78 (.A(_0841_),
    .X(net78));
 sg13g2_buf_1 fanout79 (.A(net80),
    .X(net79));
 sg13g2_buf_1 fanout80 (.A(_0680_),
    .X(net80));
 sg13g2_buf_1 fanout81 (.A(_0842_),
    .X(net81));
 sg13g2_buf_1 fanout82 (.A(_0842_),
    .X(net82));
 sg13g2_buf_1 fanout83 (.A(_0837_),
    .X(net83));
 sg13g2_buf_1 fanout84 (.A(_0837_),
    .X(net84));
 sg13g2_buf_1 fanout85 (.A(net86),
    .X(net85));
 sg13g2_buf_1 fanout86 (.A(_0835_),
    .X(net86));
 sg13g2_buf_1 fanout87 (.A(net88),
    .X(net87));
 sg13g2_buf_1 fanout88 (.A(_0834_),
    .X(net88));
 sg13g2_buf_8 fanout89 (.A(_1094_),
    .X(net89));
 sg13g2_buf_16 fanout90 (.X(net90),
    .A(net91));
 sg13g2_buf_16 fanout91 (.X(net91),
    .A(net397));
 sg13g2_buf_16 fanout92 (.X(net92),
    .A(net94));
 sg13g2_buf_16 fanout94 (.X(net94),
    .A(net427));
 sg13g2_buf_1 fanout95 (.A(_0832_),
    .X(net95));
 sg13g2_buf_1 fanout96 (.A(net97),
    .X(net96));
 sg13g2_buf_1 fanout97 (.A(_1846_),
    .X(net97));
 sg13g2_buf_1 fanout98 (.A(net99),
    .X(net98));
 sg13g2_buf_1 fanout99 (.A(_0567_),
    .X(net99));
 sg13g2_dlygate4sd3_1 hold1000 (.A(\pll_dig.dlf.OUT_C[12] ),
    .X(net999));
 sg13g2_dlygate4sd3_1 hold1001 (.A(_0129_),
    .X(net1000));
 sg13g2_dlygate4sd3_1 hold1002 (.A(\pll_dig.dlf.INT[13] ),
    .X(net1001));
 sg13g2_dlygate4sd3_1 hold1003 (.A(\pll_dig.dlf.INT[1] ),
    .X(net1002));
 sg13g2_dlygate4sd3_1 hold1004 (.A(\pll_dig.dlf.INT[13] ),
    .X(net1003));
 sg13g2_dlygate4sd3_1 hold1005 (.A(\pll_dig.dlf.INT[9] ),
    .X(net1004));
 sg13g2_dlygate4sd3_1 hold1006 (.A(\pll_dig.dlf.INT[5] ),
    .X(net1005));
 sg13g2_dlygate4sd3_1 hold1007 (.A(\pll_dig.dlf.INT[11] ),
    .X(net1006));
 sg13g2_dlygate4sd3_1 hold1008 (.A(\pll_dig.dlf.INT[6] ),
    .X(net1007));
 sg13g2_dlygate4sd3_1 hold1009 (.A(\pll_dig.dlf.INT[12] ),
    .X(net1008));
 sg13g2_dlygate4sd3_1 hold1010 (.A(\pll_dig.dlf.INT[3] ),
    .X(net1009));
 sg13g2_dlygate4sd3_1 hold1011 (.A(\pll_dig.dlf.INT[8] ),
    .X(net1010));
 sg13g2_dlygate4sd3_1 hold1012 (.A(\pll_dig.dlf.INT[4] ),
    .X(net1011));
 sg13g2_dlygate4sd3_1 hold1013 (.A(\pll_dig.dco_miss_cnt[2] ),
    .X(net1012));
 sg13g2_dlygate4sd3_1 hold1014 (.A(net1081),
    .X(net1013));
 sg13g2_dlygate4sd3_1 hold1015 (.A(net1083),
    .X(net1014));
 sg13g2_dlygate4sd3_1 hold1016 (.A(net1078),
    .X(net1015));
 sg13g2_dlygate4sd3_1 hold1017 (.A(net1080),
    .X(net1016));
 sg13g2_dlygate4sd3_1 hold1018 (.A(net1075),
    .X(net1017));
 sg13g2_dlygate4sd3_1 hold1019 (.A(net1077),
    .X(net1018));
 sg13g2_dlygate4sd3_1 hold1020 (.A(net1087),
    .X(net1019));
 sg13g2_dlygate4sd3_1 hold1021 (.A(net1089),
    .X(net1020));
 sg13g2_dlygate4sd3_1 hold1022 (.A(net1084),
    .X(net1021));
 sg13g2_dlygate4sd3_1 hold1023 (.A(net1086),
    .X(net1022));
 sg13g2_dlygate4sd3_1 hold1024 (.A(net1090),
    .X(net1023));
 sg13g2_dlygate4sd3_1 hold1025 (.A(net1092),
    .X(net1024));
 sg13g2_dlygate4sd3_1 hold1026 (.A(net1093),
    .X(net1025));
 sg13g2_dlygate4sd3_1 hold1027 (.A(net1095),
    .X(net1026));
 sg13g2_dlygate4sd3_1 hold1028 (.A(net1096),
    .X(net1027));
 sg13g2_dlygate4sd3_1 hold1029 (.A(net1098),
    .X(net1028));
 sg13g2_dlygate4sd3_1 hold1030 (.A(net1105),
    .X(net1029));
 sg13g2_dlygate4sd3_1 hold1031 (.A(net1107),
    .X(net1030));
 sg13g2_dlygate4sd3_1 hold1032 (.A(net1102),
    .X(net1031));
 sg13g2_dlygate4sd3_1 hold1033 (.A(net1104),
    .X(net1032));
 sg13g2_dlygate4sd3_1 hold1034 (.A(net1108),
    .X(net1033));
 sg13g2_dlygate4sd3_1 hold1035 (.A(net1110),
    .X(net1034));
 sg13g2_dlygate4sd3_1 hold1036 (.A(net1111),
    .X(net1035));
 sg13g2_dlygate4sd3_1 hold1037 (.A(net1113),
    .X(net1036));
 sg13g2_dlygate4sd3_1 hold1038 (.A(net1099),
    .X(net1037));
 sg13g2_dlygate4sd3_1 hold1039 (.A(net1101),
    .X(net1038));
 sg13g2_dlygate4sd3_1 hold1040 (.A(net1114),
    .X(net1039));
 sg13g2_dlygate4sd3_1 hold1041 (.A(net1116),
    .X(net1040));
 sg13g2_dlygate4sd3_1 hold1042 (.A(net1117),
    .X(net1041));
 sg13g2_dlygate4sd3_1 hold1043 (.A(net1119),
    .X(net1042));
 sg13g2_dlygate4sd3_1 hold1044 (.A(_0130_),
    .X(net1043));
 sg13g2_dlygate4sd3_1 hold1045 (.A(net816),
    .X(net1044));
 sg13g2_dlygate4sd3_1 hold1046 (.A(\pll_dig.FILTER_OUT[15] ),
    .X(net1045));
 sg13g2_dlygate4sd3_1 hold1047 (.A(net817),
    .X(net1046));
 sg13g2_dlygate4sd3_1 hold1048 (.A(DCO_EN),
    .X(net1047));
 sg13g2_dlygate4sd3_1 hold1049 (.A(net818),
    .X(net1048));
 sg13g2_dlygate4sd3_1 hold1050 (.A(_0220_),
    .X(net1049));
 sg13g2_dlygate4sd3_1 hold1051 (.A(net819),
    .X(net1050));
 sg13g2_dlygate4sd3_1 hold1052 (.A(\pll_dig.flock.cnt_cap[12] ),
    .X(net1051));
 sg13g2_dlygate4sd3_1 hold1053 (.A(_1007_),
    .X(net1052));
 sg13g2_dlygate4sd3_1 hold1054 (.A(\pll_dig.flock.cnt_cap[15] ),
    .X(net1053));
 sg13g2_dlygate4sd3_1 hold1055 (.A(\pll_dig.flock.cnt_cap[10] ),
    .X(net1054));
 sg13g2_dlygate4sd3_1 hold1056 (.A(_1001_),
    .X(net1055));
 sg13g2_dlygate4sd3_1 hold1057 (.A(\pll_dig.flock.cnt_cap[9] ),
    .X(net1056));
 sg13g2_dlygate4sd3_1 hold1058 (.A(_0998_),
    .X(net1057));
 sg13g2_dlygate4sd3_1 hold1059 (.A(\pll_dig.flock.cnt_cap[11] ),
    .X(net1058));
 sg13g2_dlygate4sd3_1 hold1060 (.A(\pll_dig.flock.cnt_cap[7] ),
    .X(net1059));
 sg13g2_dlygate4sd3_1 hold1061 (.A(_0992_),
    .X(net1060));
 sg13g2_dlygate4sd3_1 hold1062 (.A(\pll_dig.flock.cnt_cap[6] ),
    .X(net1061));
 sg13g2_dlygate4sd3_1 hold1063 (.A(_0989_),
    .X(net1062));
 sg13g2_dlygate4sd3_1 hold1064 (.A(\pll_dig.flock.cnt_cap[8] ),
    .X(net1063));
 sg13g2_dlygate4sd3_1 hold1065 (.A(\pll_dig.flock.cnt_cap[2] ),
    .X(net1064));
 sg13g2_dlygate4sd3_1 hold1066 (.A(_0147_),
    .X(net1065));
 sg13g2_dlygate4sd3_1 hold1067 (.A(\pll_dig.flock.cnt_cap[5] ),
    .X(net1066));
 sg13g2_dlygate4sd3_1 hold1068 (.A(_0986_),
    .X(net1067));
 sg13g2_dlygate4sd3_1 hold1069 (.A(\pll_dig.flock.cnt_cap[4] ),
    .X(net1068));
 sg13g2_dlygate4sd3_1 hold1070 (.A(_0983_),
    .X(net1069));
 sg13g2_dlygate4sd3_1 hold1071 (.A(\pll_dig.flock.cnt_cap[13] ),
    .X(net1070));
 sg13g2_dlygate4sd3_1 hold1072 (.A(\pll_dig.flock.cnt_cap[3] ),
    .X(net1071));
 sg13g2_dlygate4sd3_1 hold1073 (.A(\pll_dig.dlf.INT[7] ),
    .X(net1072));
 sg13g2_dlygate4sd3_1 hold1074 (.A(_1995_),
    .X(net1073));
 sg13g2_dlygate4sd3_1 hold1075 (.A(\pll_dig.fail_q ),
    .X(net1074));
 sg13g2_dlygate4sd3_1 hold1076 (.A(\pll_dig.FILTER_OUT[12] ),
    .X(net1075));
 sg13g2_dlygate4sd3_1 hold1077 (.A(net1017),
    .X(net1076));
 sg13g2_dlygate4sd3_1 hold1078 (.A(net810),
    .X(net1077));
 sg13g2_dlygate4sd3_1 hold1079 (.A(\pll_dig.FILTER_OUT[10] ),
    .X(net1078));
 sg13g2_dlygate4sd3_1 hold1080 (.A(net1015),
    .X(net1079));
 sg13g2_dlygate4sd3_1 hold1081 (.A(net803),
    .X(net1080));
 sg13g2_dlygate4sd3_1 hold1082 (.A(\pll_dig.FILTER_OUT[11] ),
    .X(net1081));
 sg13g2_dlygate4sd3_1 hold1083 (.A(net1013),
    .X(net1082));
 sg13g2_dlygate4sd3_1 hold1084 (.A(net801),
    .X(net1083));
 sg13g2_dlygate4sd3_1 hold1085 (.A(\pll_dig.FILTER_OUT[14] ),
    .X(net1084));
 sg13g2_dlygate4sd3_1 hold1086 (.A(net1021),
    .X(net1085));
 sg13g2_dlygate4sd3_1 hold1087 (.A(net807),
    .X(net1086));
 sg13g2_dlygate4sd3_1 hold1088 (.A(\pll_dig.FILTER_OUT[13] ),
    .X(net1087));
 sg13g2_dlygate4sd3_1 hold1089 (.A(net1019),
    .X(net1088));
 sg13g2_dlygate4sd3_1 hold1090 (.A(net802),
    .X(net1089));
 sg13g2_dlygate4sd3_1 hold1091 (.A(\pll_dig.FILTER_OUT[8] ),
    .X(net1090));
 sg13g2_dlygate4sd3_1 hold1092 (.A(net1023),
    .X(net1091));
 sg13g2_dlygate4sd3_1 hold1093 (.A(net805),
    .X(net1092));
 sg13g2_dlygate4sd3_1 hold1094 (.A(\pll_dig.FILTER_OUT[6] ),
    .X(net1093));
 sg13g2_dlygate4sd3_1 hold1095 (.A(net1025),
    .X(net1094));
 sg13g2_dlygate4sd3_1 hold1096 (.A(net809),
    .X(net1095));
 sg13g2_dlygate4sd3_1 hold1097 (.A(\pll_dig.FILTER_OUT[1] ),
    .X(net1096));
 sg13g2_dlygate4sd3_1 hold1098 (.A(net1027),
    .X(net1097));
 sg13g2_dlygate4sd3_1 hold1099 (.A(net806),
    .X(net1098));
 sg13g2_dlygate4sd3_1 hold1100 (.A(\pll_dig.FILTER_OUT[7] ),
    .X(net1099));
 sg13g2_dlygate4sd3_1 hold1101 (.A(net1037),
    .X(net1100));
 sg13g2_dlygate4sd3_1 hold1102 (.A(net815),
    .X(net1101));
 sg13g2_dlygate4sd3_1 hold1103 (.A(\pll_dig.FILTER_OUT[9] ),
    .X(net1102));
 sg13g2_dlygate4sd3_1 hold1104 (.A(net1031),
    .X(net1103));
 sg13g2_dlygate4sd3_1 hold1105 (.A(net811),
    .X(net1104));
 sg13g2_dlygate4sd3_1 hold1106 (.A(\pll_dig.FILTER_OUT[0] ),
    .X(net1105));
 sg13g2_dlygate4sd3_1 hold1107 (.A(net1029),
    .X(net1106));
 sg13g2_dlygate4sd3_1 hold1108 (.A(net804),
    .X(net1107));
 sg13g2_dlygate4sd3_1 hold1109 (.A(\pll_dig.FILTER_OUT[5] ),
    .X(net1108));
 sg13g2_dlygate4sd3_1 hold1110 (.A(net1033),
    .X(net1109));
 sg13g2_dlygate4sd3_1 hold1111 (.A(net808),
    .X(net1110));
 sg13g2_dlygate4sd3_1 hold1112 (.A(\pll_dig.FILTER_OUT[2] ),
    .X(net1111));
 sg13g2_dlygate4sd3_1 hold1113 (.A(net1035),
    .X(net1112));
 sg13g2_dlygate4sd3_1 hold1114 (.A(net812),
    .X(net1113));
 sg13g2_dlygate4sd3_1 hold1115 (.A(\pll_dig.FILTER_OUT[4] ),
    .X(net1114));
 sg13g2_dlygate4sd3_1 hold1116 (.A(net1039),
    .X(net1115));
 sg13g2_dlygate4sd3_1 hold1117 (.A(net813),
    .X(net1116));
 sg13g2_dlygate4sd3_1 hold1118 (.A(\pll_dig.FILTER_OUT[3] ),
    .X(net1117));
 sg13g2_dlygate4sd3_1 hold1119 (.A(net1041),
    .X(net1118));
 sg13g2_dlygate4sd3_1 hold1120 (.A(net814),
    .X(net1119));
 sg13g2_dlygate4sd3_1 hold802 (.A(net1082),
    .X(net801));
 sg13g2_dlygate4sd3_1 hold803 (.A(net1088),
    .X(net802));
 sg13g2_dlygate4sd3_1 hold804 (.A(net1079),
    .X(net803));
 sg13g2_dlygate4sd3_1 hold805 (.A(net1106),
    .X(net804));
 sg13g2_dlygate4sd3_1 hold806 (.A(net1091),
    .X(net805));
 sg13g2_dlygate4sd3_1 hold807 (.A(net1097),
    .X(net806));
 sg13g2_dlygate4sd3_1 hold808 (.A(net1085),
    .X(net807));
 sg13g2_dlygate4sd3_1 hold809 (.A(net1109),
    .X(net808));
 sg13g2_dlygate4sd3_1 hold810 (.A(net1094),
    .X(net809));
 sg13g2_dlygate4sd3_1 hold811 (.A(net1076),
    .X(net810));
 sg13g2_dlygate4sd3_1 hold812 (.A(net1103),
    .X(net811));
 sg13g2_dlygate4sd3_1 hold813 (.A(net1112),
    .X(net812));
 sg13g2_dlygate4sd3_1 hold814 (.A(net1115),
    .X(net813));
 sg13g2_dlygate4sd3_1 hold815 (.A(net1118),
    .X(net814));
 sg13g2_dlygate4sd3_1 hold816 (.A(net1100),
    .X(net815));
 sg13g2_dlygate4sd3_1 hold817 (.A(net1043),
    .X(net816));
 sg13g2_dlygate4sd3_1 hold818 (.A(net1045),
    .X(net817));
 sg13g2_dlygate4sd3_1 hold819 (.A(net1047),
    .X(net818));
 sg13g2_dlygate4sd3_1 hold820 (.A(net1049),
    .X(net819));
 sg13g2_dlygate4sd3_1 hold821 (.A(\pll_dig.flock.cnt_cap[1] ),
    .X(net820));
 sg13g2_dlygate4sd3_1 hold822 (.A(_0978_),
    .X(net821));
 sg13g2_dlygate4sd3_1 hold823 (.A(net1065),
    .X(net822));
 sg13g2_dlygate4sd3_1 hold824 (.A(net1053),
    .X(net823));
 sg13g2_dlygate4sd3_1 hold825 (.A(_0903_),
    .X(net824));
 sg13g2_dlygate4sd3_1 hold826 (.A(_0139_),
    .X(net825));
 sg13g2_dlygate4sd3_1 hold827 (.A(net1054),
    .X(net826));
 sg13g2_dlygate4sd3_1 hold828 (.A(_0929_),
    .X(net827));
 sg13g2_dlygate4sd3_1 hold829 (.A(_1002_),
    .X(net828));
 sg13g2_dlygate4sd3_1 hold830 (.A(_0141_),
    .X(net829));
 sg13g2_dlygate4sd3_1 hold831 (.A(net1058),
    .X(net830));
 sg13g2_dlygate4sd3_1 hold832 (.A(_0925_),
    .X(net831));
 sg13g2_dlygate4sd3_1 hold833 (.A(_1005_),
    .X(net832));
 sg13g2_dlygate4sd3_1 hold834 (.A(_0142_),
    .X(net833));
 sg13g2_dlygate4sd3_1 hold835 (.A(net1056),
    .X(net834));
 sg13g2_dlygate4sd3_1 hold836 (.A(_0934_),
    .X(net835));
 sg13g2_dlygate4sd3_1 hold837 (.A(_0999_),
    .X(net836));
 sg13g2_dlygate4sd3_1 hold838 (.A(_0140_),
    .X(net837));
 sg13g2_dlygate4sd3_1 hold839 (.A(net1051),
    .X(net838));
 sg13g2_dlygate4sd3_1 hold840 (.A(_0919_),
    .X(net839));
 sg13g2_dlygate4sd3_1 hold841 (.A(_0922_),
    .X(net840));
 sg13g2_dlygate4sd3_1 hold842 (.A(_1617_),
    .X(net841));
 sg13g2_dlygate4sd3_1 hold843 (.A(_0143_),
    .X(net842));
 sg13g2_dlygate4sd3_1 hold844 (.A(net1063),
    .X(net843));
 sg13g2_dlygate4sd3_1 hold845 (.A(_0939_),
    .X(net844));
 sg13g2_dlygate4sd3_1 hold846 (.A(_0996_),
    .X(net845));
 sg13g2_dlygate4sd3_1 hold847 (.A(_0154_),
    .X(net846));
 sg13g2_dlygate4sd3_1 hold848 (.A(net864),
    .X(net847));
 sg13g2_dlygate4sd3_1 hold849 (.A(_0907_),
    .X(net848));
 sg13g2_dlygate4sd3_1 hold850 (.A(_0909_),
    .X(net849));
 sg13g2_dlygate4sd3_1 hold851 (.A(_1012_),
    .X(net850));
 sg13g2_dlygate4sd3_1 hold852 (.A(_1013_),
    .X(net851));
 sg13g2_dlygate4sd3_1 hold853 (.A(_0146_),
    .X(net852));
 sg13g2_dlygate4sd3_1 hold854 (.A(\pll_dig.locked_q ),
    .X(net853));
 sg13g2_dlygate4sd3_1 hold855 (.A(_0557_),
    .X(net854));
 sg13g2_dlygate4sd3_1 hold856 (.A(net58),
    .X(net855));
 sg13g2_dlygate4sd3_1 hold857 (.A(net1061),
    .X(net856));
 sg13g2_dlygate4sd3_1 hold858 (.A(_0949_),
    .X(net857));
 sg13g2_dlygate4sd3_1 hold859 (.A(_0990_),
    .X(net858));
 sg13g2_dlygate4sd3_1 hold860 (.A(_0152_),
    .X(net859));
 sg13g2_dlygate4sd3_1 hold861 (.A(net1070),
    .X(net860));
 sg13g2_dlygate4sd3_1 hold862 (.A(_0913_),
    .X(net861));
 sg13g2_dlygate4sd3_1 hold863 (.A(_0916_),
    .X(net862));
 sg13g2_dlygate4sd3_1 hold864 (.A(_0144_),
    .X(net863));
 sg13g2_dlygate4sd3_1 hold865 (.A(\pll_dig.flock.cnt_cap[14] ),
    .X(net864));
 sg13g2_dlygate4sd3_1 hold866 (.A(net847),
    .X(net865));
 sg13g2_dlygate4sd3_1 hold867 (.A(_0915_),
    .X(net866));
 sg13g2_dlygate4sd3_1 hold868 (.A(_1011_),
    .X(net867));
 sg13g2_dlygate4sd3_1 hold869 (.A(_0145_),
    .X(net868));
 sg13g2_dlygate4sd3_1 hold870 (.A(net1059),
    .X(net869));
 sg13g2_dlygate4sd3_1 hold871 (.A(_0944_),
    .X(net870));
 sg13g2_dlygate4sd3_1 hold872 (.A(_0993_),
    .X(net871));
 sg13g2_dlygate4sd3_1 hold873 (.A(_0153_),
    .X(net872));
 sg13g2_dlygate4sd3_1 hold874 (.A(net1066),
    .X(net873));
 sg13g2_dlygate4sd3_1 hold875 (.A(_0954_),
    .X(net874));
 sg13g2_dlygate4sd3_1 hold876 (.A(_0987_),
    .X(net875));
 sg13g2_dlygate4sd3_1 hold877 (.A(_0151_),
    .X(net876));
 sg13g2_dlygate4sd3_1 hold878 (.A(net1064),
    .X(net877));
 sg13g2_dlygate4sd3_1 hold879 (.A(_0970_),
    .X(net878));
 sg13g2_dlygate4sd3_1 hold880 (.A(_0972_),
    .X(net879));
 sg13g2_dlygate4sd3_1 hold881 (.A(_1377_),
    .X(net880));
 sg13g2_dlygate4sd3_1 hold882 (.A(_0148_),
    .X(net881));
 sg13g2_dlygate4sd3_1 hold883 (.A(net1068),
    .X(net882));
 sg13g2_dlygate4sd3_1 hold884 (.A(_0959_),
    .X(net883));
 sg13g2_dlygate4sd3_1 hold885 (.A(_0985_),
    .X(net884));
 sg13g2_dlygate4sd3_1 hold886 (.A(_0150_),
    .X(net885));
 sg13g2_dlygate4sd3_1 hold887 (.A(net1071),
    .X(net886));
 sg13g2_dlygate4sd3_1 hold888 (.A(_0964_),
    .X(net887));
 sg13g2_dlygate4sd3_1 hold889 (.A(_0967_),
    .X(net888));
 sg13g2_dlygate4sd3_1 hold890 (.A(_0149_),
    .X(net889));
 sg13g2_dlygate4sd3_1 hold891 (.A(\pll_dig.flock.FCW_NA[10] ),
    .X(net890));
 sg13g2_dlygate4sd3_1 hold892 (.A(_1329_),
    .X(net891));
 sg13g2_dlygate4sd3_1 hold893 (.A(_1346_),
    .X(net892));
 sg13g2_dlygate4sd3_1 hold894 (.A(net899),
    .X(net893));
 sg13g2_dlygate4sd3_1 hold895 (.A(_1692_),
    .X(net894));
 sg13g2_dlygate4sd3_1 hold896 (.A(_0022_),
    .X(net895));
 sg13g2_dlygate4sd3_1 hold897 (.A(\pll_dig.flock.FCW_NA[7] ),
    .X(net896));
 sg13g2_dlygate4sd3_1 hold898 (.A(_1331_),
    .X(net897));
 sg13g2_dlygate4sd3_1 hold899 (.A(_1332_),
    .X(net898));
 sg13g2_dlygate4sd3_1 hold900 (.A(_1347_),
    .X(net899));
 sg13g2_dlygate4sd3_1 hold901 (.A(net893),
    .X(net900));
 sg13g2_dlygate4sd3_1 hold902 (.A(\pll_dig.FREQ_OK ),
    .X(net901));
 sg13g2_dlygate4sd3_1 hold903 (.A(_0647_),
    .X(net902));
 sg13g2_dlygate4sd3_1 hold904 (.A(_0654_),
    .X(net903));
 sg13g2_dlygate4sd3_1 hold905 (.A(_0029_),
    .X(net904));
 sg13g2_dlygate4sd3_1 hold906 (.A(\pll_dig.flock.FCW_NA[6] ),
    .X(net905));
 sg13g2_dlygate4sd3_1 hold907 (.A(net1074),
    .X(net906));
 sg13g2_dlygate4sd3_1 hold908 (.A(\pll_dig.cntf[5] ),
    .X(net907));
 sg13g2_dlygate4sd3_1 hold909 (.A(_1845_),
    .X(net908));
 sg13g2_dlygate4sd3_1 hold910 (.A(_0258_),
    .X(net909));
 sg13g2_dlygate4sd3_1 hold911 (.A(\pll_dig.state[1] ),
    .X(net910));
 sg13g2_dlygate4sd3_1 hold912 (.A(_0138_),
    .X(net911));
 sg13g2_dlygate4sd3_1 hold913 (.A(\pll_dig.fail_qq ),
    .X(net912));
 sg13g2_dlygate4sd3_1 hold914 (.A(_2010_),
    .X(net913));
 sg13g2_dlygate4sd3_1 hold915 (.A(\pll_dig.lock_detector.win_cnt[1] ),
    .X(net914));
 sg13g2_dlygate4sd3_1 hold916 (.A(_1660_),
    .X(net915));
 sg13g2_dlygate4sd3_1 hold917 (.A(_0059_),
    .X(net916));
 sg13g2_dlygate4sd3_1 hold918 (.A(\pll_dig.ILL_N ),
    .X(net917));
 sg13g2_dlygate4sd3_1 hold919 (.A(_2066_),
    .X(net918));
 sg13g2_dlygate4sd3_1 hold920 (.A(_0430_),
    .X(net919));
 sg13g2_dlygate4sd3_1 hold921 (.A(\pll_dig.lock_detector.bad_cnt[0] ),
    .X(net920));
 sg13g2_dlygate4sd3_1 hold922 (.A(_1677_),
    .X(net921));
 sg13g2_dlygate4sd3_1 hold923 (.A(\pll_dig.lock_detector.win_cnt[0] ),
    .X(net922));
 sg13g2_dlygate4sd3_1 hold924 (.A(_0058_),
    .X(net923));
 sg13g2_dlygate4sd3_1 hold925 (.A(\pll_dig.lock_detector.win_cnt[4] ),
    .X(net924));
 sg13g2_dlygate4sd3_1 hold926 (.A(_1626_),
    .X(net925));
 sg13g2_dlygate4sd3_1 hold927 (.A(\pll_dig.cnt[6] ),
    .X(net926));
 sg13g2_dlygate4sd3_1 hold928 (.A(_2025_),
    .X(net927));
 sg13g2_dlygate4sd3_1 hold929 (.A(_0428_),
    .X(net928));
 sg13g2_dlygate4sd3_1 hold930 (.A(\pll_dig.ILL_P ),
    .X(net929));
 sg13g2_dlygate4sd3_1 hold931 (.A(_2029_),
    .X(net930));
 sg13g2_dlygate4sd3_1 hold932 (.A(_0339_),
    .X(net931));
 sg13g2_dlygate4sd3_1 hold933 (.A(\pll_dig.state[3] ),
    .X(net932));
 sg13g2_dlygate4sd3_1 hold934 (.A(_0047_),
    .X(net933));
 sg13g2_dlygate4sd3_1 hold935 (.A(\pll_dig.PHASE_LOCK ),
    .X(net934));
 sg13g2_dlygate4sd3_1 hold936 (.A(_2037_),
    .X(net935));
 sg13g2_dlygate4sd3_1 hold937 (.A(_0371_),
    .X(net936));
 sg13g2_dlygate4sd3_1 hold938 (.A(\pll_dig.cntf[1] ),
    .X(net937));
 sg13g2_dlygate4sd3_1 hold939 (.A(_2056_),
    .X(net938));
 sg13g2_dlygate4sd3_1 hold940 (.A(_0387_),
    .X(net939));
 sg13g2_dlygate4sd3_1 hold941 (.A(\pll_dig.ENABLE ),
    .X(net940));
 sg13g2_dlygate4sd3_1 hold942 (.A(_2060_),
    .X(net941));
 sg13g2_dlygate4sd3_1 hold943 (.A(_0415_),
    .X(net942));
 sg13g2_dlygate4sd3_1 hold944 (.A(\pll_dig.lock_detector.win_cnt[2] ),
    .X(net943));
 sg13g2_dlygate4sd3_1 hold945 (.A(\pll_dig.cnt[3] ),
    .X(net944));
 sg13g2_dlygate4sd3_1 hold946 (.A(\pll_dig.cntf[0] ),
    .X(net945));
 sg13g2_dlygate4sd3_1 hold947 (.A(_0377_),
    .X(net946));
 sg13g2_dlygate4sd3_1 hold948 (.A(\pll_dig.lock_detector.bad_cnt[2] ),
    .X(net947));
 sg13g2_dlygate4sd3_1 hold949 (.A(_1672_),
    .X(net948));
 sg13g2_dlygate4sd3_1 hold950 (.A(\pll_dig.lock_detector.win_cnt[3] ),
    .X(net949));
 sg13g2_dlygate4sd3_1 hold951 (.A(\pll_dig.cnt[2] ),
    .X(net950));
 sg13g2_dlygate4sd3_1 hold952 (.A(_2014_),
    .X(net951));
 sg13g2_dlygate4sd3_1 hold953 (.A(_0429_),
    .X(net952));
 sg13g2_dlygate4sd3_1 hold954 (.A(\pll_dig.cnt[0] ),
    .X(net953));
 sg13g2_dlygate4sd3_1 hold955 (.A(_0379_),
    .X(net954));
 sg13g2_dlygate4sd3_1 hold956 (.A(\pll_dig.cnt[5] ),
    .X(net955));
 sg13g2_dlygate4sd3_1 hold957 (.A(_2017_),
    .X(net956));
 sg13g2_dlygate4sd3_1 hold958 (.A(_0337_),
    .X(net957));
 sg13g2_dlygate4sd3_1 hold959 (.A(\pll_dig.cnt[1] ),
    .X(net958));
 sg13g2_dlygate4sd3_1 hold960 (.A(_0338_),
    .X(net959));
 sg13g2_dlygate4sd3_1 hold961 (.A(\pll_dig.cntf[6] ),
    .X(net960));
 sg13g2_dlygate4sd3_1 hold962 (.A(_1839_),
    .X(net961));
 sg13g2_dlygate4sd3_1 hold963 (.A(_2062_),
    .X(net962));
 sg13g2_dlygate4sd3_1 hold964 (.A(\pll_dig.LOCK_LOST ),
    .X(net963));
 sg13g2_dlygate4sd3_1 hold965 (.A(_0048_),
    .X(net964));
 sg13g2_dlygate4sd3_1 hold966 (.A(\pll_dig.cntf[2] ),
    .X(net965));
 sg13g2_dlygate4sd3_1 hold967 (.A(_2063_),
    .X(net966));
 sg13g2_dlygate4sd3_1 hold968 (.A(_0427_),
    .X(net967));
 sg13g2_dlygate4sd3_1 hold969 (.A(\pll_dig.cntf[3] ),
    .X(net968));
 sg13g2_dlygate4sd3_1 hold970 (.A(_0381_),
    .X(net969));
 sg13g2_dlygate4sd3_1 hold971 (.A(\pll_dig.cntf[4] ),
    .X(net970));
 sg13g2_dlygate4sd3_1 hold972 (.A(_2044_),
    .X(net971));
 sg13g2_dlygate4sd3_1 hold973 (.A(_0376_),
    .X(net972));
 sg13g2_dlygate4sd3_1 hold974 (.A(\pll_dig.dlf.INT[4] ),
    .X(net973));
 sg13g2_dlygate4sd3_1 hold975 (.A(\pll_dig.dlf.OUT_C[4] ),
    .X(net974));
 sg13g2_dlygate4sd3_1 hold976 (.A(\pll_dig.cnt[7] ),
    .X(net975));
 sg13g2_dlygate4sd3_1 hold977 (.A(_1638_),
    .X(net976));
 sg13g2_dlygate4sd3_1 hold978 (.A(_0050_),
    .X(net977));
 sg13g2_dlygate4sd3_1 hold979 (.A(\pll_dig.dlf.INT[5] ),
    .X(net978));
 sg13g2_dlygate4sd3_1 hold980 (.A(\pll_dig.dlf.INT[0] ),
    .X(net979));
 sg13g2_dlygate4sd3_1 hold981 (.A(\pll_dig.cnt[4] ),
    .X(net980));
 sg13g2_dlygate4sd3_1 hold982 (.A(_2047_),
    .X(net981));
 sg13g2_dlygate4sd3_1 hold983 (.A(\pll_dig.dlf.INT[6] ),
    .X(net982));
 sg13g2_dlygate4sd3_1 hold984 (.A(\pll_dig.state[2] ),
    .X(net983));
 sg13g2_dlygate4sd3_1 hold985 (.A(\pll_dig.dlf.INT[3] ),
    .X(net984));
 sg13g2_dlygate4sd3_1 hold986 (.A(\pll_dig.dlf.OUT_C[3] ),
    .X(net985));
 sg13g2_dlygate4sd3_1 hold987 (.A(\pll_dig.dlf.INT[10] ),
    .X(net986));
 sg13g2_dlygate4sd3_1 hold988 (.A(\pll_dig.dlf.OUT_C[10] ),
    .X(net987));
 sg13g2_dlygate4sd3_1 hold989 (.A(\pll_dig.dlf.INT[11] ),
    .X(net988));
 sg13g2_dlygate4sd3_1 hold990 (.A(\pll_dig.dlf.OUT_C[11] ),
    .X(net989));
 sg13g2_dlygate4sd3_1 hold991 (.A(\pll_dig.dlf.INT[14] ),
    .X(net990));
 sg13g2_dlygate4sd3_1 hold992 (.A(\pll_dig.dlf.INT[1] ),
    .X(net991));
 sg13g2_dlygate4sd3_1 hold993 (.A(\pll_dig.state[4] ),
    .X(net992));
 sg13g2_dlygate4sd3_1 hold994 (.A(\pll_dig.dlf.INT[7] ),
    .X(net993));
 sg13g2_dlygate4sd3_1 hold995 (.A(\pll_dig.dlf.INT[2] ),
    .X(net994));
 sg13g2_dlygate4sd3_1 hold996 (.A(\pll_dig.dlf.OUT_C[2] ),
    .X(net995));
 sg13g2_dlygate4sd3_1 hold997 (.A(\pll_dig.dlf.INT[8] ),
    .X(net996));
 sg13g2_dlygate4sd3_1 hold998 (.A(\pll_dig.START ),
    .X(net997));
 sg13g2_dlygate4sd3_1 hold999 (.A(\pll_dig.dlf.INT[12] ),
    .X(net998));
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
 sg13g2_buf_1 rebuffer346 (.A(_1246_),
    .X(net345));
 sg13g2_buf_1 rebuffer347 (.A(_0714_),
    .X(net346));
 sg13g2_buf_1 rebuffer348 (.A(_0787_),
    .X(net347));
 sg13g2_buf_1 rebuffer349 (.A(_1235_),
    .X(net348));
 sg13g2_buf_1 rebuffer350 (.A(_0783_),
    .X(net349));
 sg13g2_buf_1 rebuffer351 (.A(_0717_),
    .X(net350));
 sg13g2_buf_1 rebuffer352 (.A(_0744_),
    .X(net351));
 sg13g2_buf_2 rebuffer353 (.A(_0752_),
    .X(net352));
 sg13g2_buf_1 rebuffer354 (.A(_0750_),
    .X(net353));
 sg13g2_buf_1 rebuffer355 (.A(_0750_),
    .X(net354));
 sg13g2_buf_1 rebuffer356 (.A(_1246_),
    .X(net355));
 sg13g2_buf_2 rebuffer357 (.A(_1250_),
    .X(net356));
 sg13g2_buf_1 rebuffer358 (.A(net361),
    .X(net357));
 sg13g2_buf_1 rebuffer359 (.A(_1240_),
    .X(net358));
 sg13g2_buf_1 rebuffer360 (.A(net379),
    .X(net359));
 sg13g2_buf_1 rebuffer361 (.A(_1232_),
    .X(net360));
 sg13g2_buf_1 rebuffer362 (.A(_0748_),
    .X(net361));
 sg13g2_buf_1 rebuffer363 (.A(_0776_),
    .X(net362));
 sg13g2_buf_1 rebuffer364 (.A(_0754_),
    .X(net363));
 sg13g2_buf_1 rebuffer365 (.A(_0812_),
    .X(net364));
 sg13g2_buf_1 rebuffer366 (.A(_1258_),
    .X(net365));
 sg13g2_buf_1 rebuffer367 (.A(_1277_),
    .X(net366));
 sg13g2_buf_1 rebuffer368 (.A(_1275_),
    .X(net367));
 sg13g2_buf_1 rebuffer369 (.A(_1258_),
    .X(net368));
 sg13g2_buf_1 rebuffer370 (.A(_0803_),
    .X(net369));
 sg13g2_buf_1 rebuffer371 (.A(_0799_),
    .X(net370));
 sg13g2_buf_1 rebuffer372 (.A(_0705_),
    .X(net371));
 sg13g2_buf_1 rebuffer373 (.A(_1238_),
    .X(net372));
 sg13g2_buf_1 rebuffer374 (.A(_0791_),
    .X(net373));
 sg13g2_buf_1 rebuffer375 (.A(_0828_),
    .X(net374));
 sg13g2_buf_1 rebuffer376 (.A(_0772_),
    .X(net375));
 sg13g2_buf_1 rebuffer377 (.A(_0804_),
    .X(net376));
 sg13g2_buf_1 rebuffer378 (.A(_0810_),
    .X(net377));
 sg13g2_buf_1 rebuffer379 (.A(_0762_),
    .X(net378));
 sg13g2_buf_2 rebuffer380 (.A(_0763_),
    .X(net379));
 sg13g2_buf_1 rebuffer381 (.A(_0768_),
    .X(net380));
 sg13g2_buf_1 rebuffer382 (.A(_1243_),
    .X(net381));
 sg13g2_buf_1 rebuffer383 (.A(_1280_),
    .X(net382));
 sg13g2_buf_1 rebuffer384 (.A(_1252_),
    .X(net383));
 sg13g2_buf_1 rebuffer385 (.A(\pll_dig.dsm_impl.dsm.dff_err1[0] ),
    .X(net384));
 sg13g2_buf_1 rebuffer386 (.A(_1281_),
    .X(net385));
 sg13g2_buf_1 rebuffer387 (.A(_1043_),
    .X(net386));
 sg13g2_buf_1 rebuffer388 (.A(_1043_),
    .X(net387));
 sg13g2_buf_1 rebuffer389 (.A(net461),
    .X(net388));
 sg13g2_buf_1 rebuffer391 (.A(_1058_),
    .X(net390));
 sg13g2_buf_1 rebuffer392 (.A(_1044_),
    .X(net391));
 sg13g2_buf_1 rebuffer393 (.A(_1065_),
    .X(net392));
 sg13g2_buf_1 rebuffer394 (.A(_1065_),
    .X(net393));
 sg13g2_buf_1 rebuffer395 (.A(_1067_),
    .X(net394));
 sg13g2_buf_1 rebuffer396 (.A(net396),
    .X(net395));
 sg13g2_buf_1 rebuffer397 (.A(_1045_),
    .X(net396));
 sg13g2_buf_8 rebuffer398 (.A(_1073_),
    .X(net397));
 sg13g2_buf_2 rebuffer399 (.A(_1072_),
    .X(net398));
 sg13g2_buf_1 rebuffer401 (.A(net502),
    .X(net400));
 sg13g2_buf_1 rebuffer409 (.A(net409),
    .X(net408));
 sg13g2_buf_1 rebuffer410 (.A(net410),
    .X(net409));
 sg13g2_buf_1 rebuffer411 (.A(net411),
    .X(net410));
 sg13g2_buf_1 rebuffer412 (.A(net412),
    .X(net411));
 sg13g2_buf_1 rebuffer413 (.A(net413),
    .X(net412));
 sg13g2_buf_1 rebuffer414 (.A(net414),
    .X(net413));
 sg13g2_buf_1 rebuffer415 (.A(net415),
    .X(net414));
 sg13g2_buf_1 rebuffer416 (.A(net416),
    .X(net415));
 sg13g2_buf_1 rebuffer417 (.A(net417),
    .X(net416));
 sg13g2_buf_1 rebuffer418 (.A(net418),
    .X(net417));
 sg13g2_buf_1 rebuffer419 (.A(net419),
    .X(net418));
 sg13g2_buf_1 rebuffer420 (.A(net423),
    .X(net419));
 sg13g2_buf_8 rebuffer421 (.A(_1073_),
    .X(net420));
 sg13g2_buf_1 rebuffer422 (.A(\pll_dig.div.cnt[1] ),
    .X(net421));
 sg13g2_buf_1 rebuffer423 (.A(\pll_dig.div.cnt[0] ),
    .X(net422));
 sg13g2_buf_1 rebuffer424 (.A(net734),
    .X(net423));
 sg13g2_buf_16 rebuffer425 (.X(net424),
    .A(net91));
 sg13g2_buf_16 rebuffer426 (.X(net425),
    .A(net90));
 sg13g2_buf_16 rebuffer427 (.X(net426),
    .A(net90));
 sg13g2_buf_16 rebuffer428 (.X(net427),
    .A(net459));
 sg13g2_buf_16 rebuffer429 (.X(net428),
    .A(net94));
 sg13g2_buf_1 rebuffer432 (.A(_0621_),
    .X(net431));
 sg13g2_buf_1 rebuffer433 (.A(\pll_dig.div.div[0] ),
    .X(net432));
 sg13g2_buf_1 rebuffer438 (.A(_0625_),
    .X(net437));
 sg13g2_buf_8 rebuffer460 (.A(_1073_),
    .X(net459));
 sg13g2_buf_1 rebuffer462 (.A(_1046_),
    .X(net461));
 sg13g2_buf_1 rebuffer492 (.A(_0856_),
    .X(net491));
 sg13g2_buf_1 rebuffer493 (.A(_0855_),
    .X(net492));
 sg13g2_buf_1 rebuffer494 (.A(_0857_),
    .X(net493));
 sg13g2_buf_1 rebuffer495 (.A(_0853_),
    .X(net494));
 sg13g2_buf_1 rebuffer496 (.A(_0854_),
    .X(net495));
 sg13g2_buf_1 rebuffer497 (.A(_0858_),
    .X(net496));
 sg13g2_buf_1 rebuffer498 (.A(_0860_),
    .X(net497));
 sg13g2_buf_8 rebuffer499 (.A(_0859_),
    .X(net498));
 sg13g2_buf_1 rebuffer500 (.A(\pll_dig.flock.cnt[2] ),
    .X(net499));
 sg13g2_buf_1 rebuffer501 (.A(\pll_dig.flock.cnt[1] ),
    .X(net500));
 sg13g2_buf_1 rebuffer502 (.A(\pll_dig.flock.cnt[3] ),
    .X(net501));
 sg13g2_buf_1 rebuffer503 (.A(net700),
    .X(net502));
 sg13g2_buf_2 rebuffer504 (.A(_1094_),
    .X(net503));
 sg13g2_buf_1 rebuffer554 (.A(_1248_),
    .X(net553));
 sg13g2_buf_1 rebuffer555 (.A(\pll_dig.div.ncnt[1] ),
    .X(net554));
 sg13g2_buf_1 rebuffer701 (.A(net701),
    .X(net700));
 sg13g2_buf_1 rebuffer702 (.A(_1055_),
    .X(net701));
 sg13g2_buf_1 rebuffer706 (.A(_1738_),
    .X(net705));
 sg13g2_buf_1 rebuffer707 (.A(net707),
    .X(net706));
 sg13g2_buf_1 rebuffer708 (.A(_1738_),
    .X(net707));
 sg13g2_buf_1 rebuffer709 (.A(_1734_),
    .X(net708));
 sg13g2_buf_1 rebuffer710 (.A(_1735_),
    .X(net709));
 sg13g2_buf_1 rebuffer711 (.A(_0600_),
    .X(net710));
 sg13g2_buf_1 rebuffer723 (.A(_1244_),
    .X(net722));
 sg13g2_buf_2 rebuffer727 (.A(_1764_),
    .X(net726));
 sg13g2_buf_1 rebuffer728 (.A(_1743_),
    .X(net727));
 sg13g2_buf_1 rebuffer729 (.A(_1783_),
    .X(net728));
 sg13g2_buf_1 rebuffer730 (.A(_1764_),
    .X(net729));
 sg13g2_buf_1 rebuffer731 (.A(net793),
    .X(net730));
 sg13g2_buf_1 rebuffer732 (.A(_1743_),
    .X(net731));
 sg13g2_buf_1 rebuffer735 (.A(net735),
    .X(net734));
 sg13g2_buf_1 rebuffer736 (.A(net736),
    .X(net735));
 sg13g2_buf_1 rebuffer737 (.A(net737),
    .X(net736));
 sg13g2_buf_1 rebuffer738 (.A(net738),
    .X(net737));
 sg13g2_buf_1 rebuffer739 (.A(net739),
    .X(net738));
 sg13g2_buf_1 rebuffer740 (.A(net766),
    .X(net739));
 sg13g2_buf_1 rebuffer767 (.A(_1046_),
    .X(net766));
 sg13g2_buf_1 rebuffer794 (.A(_1765_),
    .X(net793));
 sg13g2_buf_1 rebuffer795 (.A(_1765_),
    .X(net794));
 sg13g2_buf_1 rebuffer796 (.A(_1763_),
    .X(net795));
 sg13g2_buf_1 rebuffer797 (.A(\pll_dig.div.pcnt[0] ),
    .X(net796));
 sg13g2_buf_1 rebuffer798 (.A(\pll_dig.div.pcnt[1] ),
    .X(net797));
 sg13g2_buf_1 rebuffer801 (.A(_1772_),
    .X(net800));
endmodule
