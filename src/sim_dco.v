// A digital VCO useful for digital simulations
`timescale 1fs/1fs

// Umbrella define for the closed-loop smoke regression.  SIMULATION_FAST_DCO
// is kept as the finer-grained name; SIMULATION_FAST turns it on.
`ifdef SIMULATION_FAST
    `ifndef SIMULATION_FAST_DCO
        `define SIMULATION_FAST_DCO
    `endif
`endif

module sim_delay_fine #(
    parameter integer NDELS = 31
) (
    input [NDELS-1:0] MUX,
    input IN,
    output reg OUT
);
    initial OUT = 1'b0;
    // Fine-bank delay table, code = countones(MUX) (thermometer, first 0 bit
    // selects).  IMPORTANT: this is a load-trim bank in RTL (fine_delay.v:
    // switched NAND3 loads on a shared LOAD node), NOT an in-path delay.  The
    // old table spanned only 2.24 ps (23.77->26.01 ps), which is ~10x too
    // small: the converged-timestep SPICE characterization measures the real
    // fine authority as ~0.8 ps/code, ~25 ps full span
    // (flow/characterization/ihp_l3_dense/README.md, RESOLVED 2026-11-23,
    // tstep 0.02: f16->f31 = 12.4 ps => ~0.78 ps/code).  An under-ranged
    // model made the closed-loop phase loop rail at FINE=31 for a model
    // reason, not a real one.  This table is monotone, 0.8 ps/code, code 0
    // unchanged (23.77 ps) so the code-0 operating point is preserved.
    always @(IN) begin
        if(MUX[0] == 1'b0) #(23770); // delay = 23.770 ps (code 0)
        else if(MUX[1] == 1'b0) #(24570);
        else if(MUX[2] == 1'b0) #(25370);
        else if(MUX[3] == 1'b0) #(26170);
        else if(MUX[4] == 1'b0) #(26970);
        else if(MUX[5] == 1'b0) #(27770);
        else if(MUX[6] == 1'b0) #(28570);
        else if(MUX[7] == 1'b0) #(29370);
        else if(MUX[8] == 1'b0) #(30170);
        else if(MUX[9] == 1'b0) #(30970);
        else if(MUX[10] == 1'b0) #(31770);
        else if(MUX[11] == 1'b0) #(32570);
        else if(MUX[12] == 1'b0) #(33370);
        else if(MUX[13] == 1'b0) #(34170);
        else if(MUX[14] == 1'b0) #(34970);
        else if(MUX[15] == 1'b0) #(35770);
        else if(MUX[16] == 1'b0) #(36570);
        else if(MUX[17] == 1'b0) #(37370);
        else if(MUX[18] == 1'b0) #(38170);
        else if(MUX[19] == 1'b0) #(38970);
        else if(MUX[20] == 1'b0) #(39770);
        else if(MUX[21] == 1'b0) #(40570);
        else if(MUX[22] == 1'b0) #(41370);
        else if(MUX[23] == 1'b0) #(42170);
        else if(MUX[24] == 1'b0) #(42970);
        else if(MUX[25] == 1'b0) #(43770);
        else if(MUX[26] == 1'b0) #(44570);
        else if(MUX[27] == 1'b0) #(45370);
        else if(MUX[28] == 1'b0) #(46170);
        else if(MUX[29] == 1'b0) #(46970);
        else if(MUX[30] == 1'b0) #(47770);
        else #(48570); // delay = 48.57 ps (code 31), span 24.8 ps
        OUT = IN;
    end
endmodule

module sim_delay_mid #(
    parameter integer NDELS = 15
) (
    input [NDELS-1:0] MUX,
    input IN,
    output reg OUT
);
    initial OUT = 1'b0;
    always @(IN) begin
        if(MUX[0] == 1'b0) #(52460); // delay = 5.246e-11
        else if(MUX[1] == 1'b0) #(53250); // delay = 5.325e-11
        else if(MUX[2] == 1'b0) #(54060); // delay = 5.406e-11
        else if(MUX[3] == 1'b0) #(54890); // delay = 5.489e-11
        else if(MUX[4] == 1'b0) #(55780); // delay = 5.578e-11
        else if(MUX[5] == 1'b0) #(56740); // delay = 5.674e-11
        else if(MUX[6] == 1'b0) #(57720); // delay = 5.772e-11
        else if(MUX[7] == 1'b0) #(58700); // delay = 5.87e-11
        else if(MUX[8] == 1'b0) #(59700); // delay = 5.97e-11
        else if(MUX[9] == 1'b0) #(60710); // delay = 6.071e-11
        else if(MUX[10] == 1'b0) #(61790); // delay = 6.179e-11
        else if(MUX[11] == 1'b0) #(62950); // delay = 6.295e-11
        else if(MUX[12] == 1'b0) #(64190); // delay = 6.419e-11
        else if(MUX[13] == 1'b0) #(65520); // delay = 6.552e-11
        else if(MUX[14] == 1'b0) #(66750); // delay = 6.675e-11
        else #(67930); // delay = 6.793e-11
        OUT = IN;
    end
endmodule

module sim_delay_coarse #(
    parameter integer NDELS = 15
) (
    input [NDELS-1:0] MUX,
    input IN,
    output reg OUT
);
    initial OUT = 1'b0;
    always @(IN) begin
        if(MUX[0] == 1'b0) #(31320); // delay = 3.132e-11
        else if(MUX[1] == 1'b0) #(65810); // delay = 6.581e-11
        else if(MUX[2] == 1'b0) #(99300); // delay = 9.93e-11
        else if(MUX[3] == 1'b0) #(133300); // delay = 1.333e-10
        else if(MUX[4] == 1'b0) #(170000); // delay = 1.7e-10
        else if(MUX[5] == 1'b0) #(205200); // delay = 2.052e-10
        else if(MUX[6] == 1'b0) #(235899); // delay = 2.359e-10
        else if(MUX[7] == 1'b0) #(273000); // delay = 2.73e-10
        else if(MUX[8] == 1'b0) #(307300); // delay = 3.073e-10
        else if(MUX[9] == 1'b0) #(341800); // delay = 3.418e-10
        else if(MUX[10] == 1'b0) #(373000); // delay = 3.73e-10
        else if(MUX[11] == 1'b0) #(399400); // delay = 3.994e-10
        else if(MUX[12] == 1'b0) #(431300); // delay = 4.313e-10
        else if(MUX[13] == 1'b0) #(465100); // delay = 4.651e-10
        else if(MUX[14] == 1'b0) #(511400); // delay = 5.114e-10
        else #(535700); // delay = 5.357e-10
        OUT = IN;
    end
endmodule

module sim_dco #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31
) (
    input [COARSE_NDELS-1:0] COARSE_MUX,
    input [MID_NDELS-1:0] MID_MUX,
    input [FINE_NDELS-1:0] FINE_MUX,
    output reg CLK_VCO
);
`ifdef SIMULATION_FAST_DCO
    // Behavioural fast path for the closed-loop smoke TB.  Here the
    // half-period is computed directly from the mux codes (identical
    // constants to the tables), so the loop sees the same K_DCO with O(1)
    // events per cycle.
    //
    // NOTE (2026-11-24): this module is NOT instantiated by pll_macro_top_tb
    // (its ring is built from sim_delay_* in il_dco.v).  Icarus nevertheless
    // elaborated the unused module as an extra root, so this always block
    // free-ran and its real-valued delay was scheduled in *time units* (1 fs),
    // not ps: `#(period_fs/2000.0)` became ~60 fs, i.e. one event every 60 fs
    // and ~10^9 events over a 20 us window -- the 9 GB OOM.  Keep the delay
    // an integer in fs, and make the TB select an explicit top (-s) so unused
    // modules are pruned.
    //
    // period_fs = BIAS + FINE[code] + MID[code] + COARSE[code]
    // (FINE/MID tables are per-tap values; the coarse table is non-linear
    // so it is kept as a case.  BIAS = 23770/2, the inverter offset below.)
    // matching code-0 of each table.  Only the code-to-delay mapping is
    // modelled; the analog delay-chain shape (non-uniform taps, glitches)
    // is not -- that is what the full tables below are for.
    function integer fine_fs(input integer c);
        case (c)
            0:  fine_fs = 23770;  1:  fine_fs = 23830;  2:  fine_fs = 23880;
            3:  fine_fs = 23940;  4:  fine_fs = 23990;  5:  fine_fs = 24050;
            6:  fine_fs = 24110;  7:  fine_fs = 24170;  8:  fine_fs = 24230;
            9:  fine_fs = 24290;  10: fine_fs = 24360;  11: fine_fs = 24420;
            12: fine_fs = 24490;  13: fine_fs = 24550;  14: fine_fs = 24620;
            15: fine_fs = 24690;  16: fine_fs = 24760;  17: fine_fs = 24830;
            18: fine_fs = 24910;  19: fine_fs = 24980;  20: fine_fs = 25060;
            21: fine_fs = 25140;  22: fine_fs = 25220;  23: fine_fs = 25300;
            24: fine_fs = 25380;  25: fine_fs = 25470;  26: fine_fs = 25550;
            27: fine_fs = 25640;  28: fine_fs = 25730;  29: fine_fs = 25830;
            30: fine_fs = 25920;  default: fine_fs = 26010;
        endcase
    endfunction
    function integer mid_fs(input integer c);
        case (c)
            0:  mid_fs = 52460;  1:  mid_fs = 53250;  2:  mid_fs = 54060;
            3:  mid_fs = 54890;  4:  mid_fs = 55780;  5:  mid_fs = 56740;
            6:  mid_fs = 57720;  7:  mid_fs = 58700;  8:  mid_fs = 59700;
            9:  mid_fs = 60710;  10: mid_fs = 61790;  11: mid_fs = 62950;
            12: mid_fs = 64190;  13: mid_fs = 65520;  14: mid_fs = 66750;
            default: mid_fs = 67930;
        endcase
    endfunction
    // coarse table is not linear (load steps); keep code 0 only, the FLL
    // parks coarse at 0 in every lock the smoke test reaches.
    function integer coarse_fs(input integer c);
        case (c)
            0:  coarse_fs = 31320;  1:  coarse_fs = 65810;
            2:  coarse_fs = 99300;  3:  coarse_fs = 133300;
            4:  coarse_fs = 170000; 5:  coarse_fs = 205200;
            6:  coarse_fs = 235899; 7:  coarse_fs = 273000;
            8:  coarse_fs = 307300; 9:  coarse_fs = 341800;
            10: coarse_fs = 373000; 11: coarse_fs = 399400;
            12: coarse_fs = 431300; 13: coarse_fs = 465100;
            14: coarse_fs = 511400; default: coarse_fs = 535700;
        endcase
    endfunction
    integer fc, mc, cc, period_fs_v;
    initial CLK_VCO = 1'b0;
    always begin
        fc = $countones(FINE_MUX);
        mc = $countones(MID_MUX);
        cc = $countones(COARSE_MUX);
        period_fs_v = 11885 + fine_fs(fc) + mid_fs(mc) + coarse_fs(cc);
        // Integer fs, so the delay is not silently scaled by the timescale
        // unit (a real #59.7 would mean 59.7 fs, not 59.7 ps).
        #(period_fs_v/2) CLK_VCO = ~CLK_VCO;
    end
`else
    // Simulation of the delay-based VCO
    // see parse_delays.py for getting those values
    initial CLK_VCO = 1'b0;
    always begin
        #(23770/2); // This is a bias delay caused by a single inverter

        if(FINE_MUX[0] == 1'b0) #(23770); // delay = 2.377e-11
        else if(FINE_MUX[1] == 1'b0) #(23830); // delay = 2.383e-11
        else if(FINE_MUX[2] == 1'b0) #(23880); // delay = 2.388e-11
        else if(FINE_MUX[3] == 1'b0) #(23940); // delay = 2.394e-11
        else if(FINE_MUX[4] == 1'b0) #(23990); // delay = 2.399e-11
        else if(FINE_MUX[5] == 1'b0) #(24050); // delay = 2.405e-11
        else if(FINE_MUX[6] == 1'b0) #(24110); // delay = 2.411e-11
        else if(FINE_MUX[7] == 1'b0) #(24170); // delay = 2.417e-11
        else if(FINE_MUX[8] == 1'b0) #(24230); // delay = 2.423e-11
        else if(FINE_MUX[9] == 1'b0) #(24290); // delay = 2.429e-11
        else if(FINE_MUX[10] == 1'b0) #(24360); // delay = 2.436e-11
        else if(FINE_MUX[11] == 1'b0) #(24420); // delay = 2.442e-11
        else if(FINE_MUX[12] == 1'b0) #(24490); // delay = 2.449e-11
        else if(FINE_MUX[13] == 1'b0) #(24550); // delay = 2.455e-11
        else if(FINE_MUX[14] == 1'b0) #(24620); // delay = 2.462e-11
        else if(FINE_MUX[15] == 1'b0) #(24690); // delay = 2.469e-11
        else if(FINE_MUX[16] == 1'b0) #(24760); // delay = 2.476e-11
        else if(FINE_MUX[17] == 1'b0) #(24830); // delay = 2.483e-11
        else if(FINE_MUX[18] == 1'b0) #(24910); // delay = 2.491e-11
        else if(FINE_MUX[19] == 1'b0) #(24980); // delay = 2.498e-11
        else if(FINE_MUX[20] == 1'b0) #(25060); // delay = 2.506e-11
        else if(FINE_MUX[21] == 1'b0) #(25140); // delay = 2.514e-11
        else if(FINE_MUX[22] == 1'b0) #(25220); // delay = 2.522e-11
        else if(FINE_MUX[23] == 1'b0) #(25300); // delay = 2.53e-11
        else if(FINE_MUX[24] == 1'b0) #(25380); // delay = 2.538e-11
        else if(FINE_MUX[25] == 1'b0) #(25470); // delay = 2.547e-11
        else if(FINE_MUX[26] == 1'b0) #(25550); // delay = 2.555e-11
        else if(FINE_MUX[27] == 1'b0) #(25640); // delay = 2.564e-11
        else if(FINE_MUX[28] == 1'b0) #(25730); // delay = 2.573e-11
        else if(FINE_MUX[29] == 1'b0) #(25830); // delay = 2.583e-11
        else if(FINE_MUX[30] == 1'b0) #(25920); // delay = 2.592e-11
        else #(26010); // delay = 2.601e-11
        
        if(MID_MUX[0] == 1'b0) #(52460); // delay = 5.246e-11
        else if(MID_MUX[1] == 1'b0) #(53250); // delay = 5.325e-11
        else if(MID_MUX[2] == 1'b0) #(54060); // delay = 5.406e-11
        else if(MID_MUX[3] == 1'b0) #(54890); // delay = 5.489e-11
        else if(MID_MUX[4] == 1'b0) #(55780); // delay = 5.578e-11
        else if(MID_MUX[5] == 1'b0) #(56740); // delay = 5.674e-11
        else if(MID_MUX[6] == 1'b0) #(57720); // delay = 5.772e-11
        else if(MID_MUX[7] == 1'b0) #(58700); // delay = 5.87e-11
        else if(MID_MUX[8] == 1'b0) #(59700); // delay = 5.97e-11
        else if(MID_MUX[9] == 1'b0) #(60710); // delay = 6.071e-11
        else if(MID_MUX[10] == 1'b0) #(61790); // delay = 6.179e-11
        else if(MID_MUX[11] == 1'b0) #(62950); // delay = 6.295e-11
        else if(MID_MUX[12] == 1'b0) #(64190); // delay = 6.419e-11
        else if(MID_MUX[13] == 1'b0) #(65520); // delay = 6.552e-11
        else if(MID_MUX[14] == 1'b0) #(66750); // delay = 6.675e-11
        else #(67930); // delay = 6.793e-11

        if(COARSE_MUX[0] == 1'b0) #(31320); // delay = 3.132e-11
        else if(COARSE_MUX[1] == 1'b0) #(65810); // delay = 6.581e-11
        else if(COARSE_MUX[2] == 1'b0) #(99300); // delay = 9.93e-11
        else if(COARSE_MUX[3] == 1'b0) #(133300); // delay = 1.333e-10
        else if(COARSE_MUX[4] == 1'b0) #(170000); // delay = 1.7e-10
        else if(COARSE_MUX[5] == 1'b0) #(205200); // delay = 2.052e-10
        else if(COARSE_MUX[6] == 1'b0) #(235899); // delay = 2.359e-10
        else if(COARSE_MUX[7] == 1'b0) #(273000); // delay = 2.73e-10
        else if(COARSE_MUX[8] == 1'b0) #(307300); // delay = 3.073e-10
        else if(COARSE_MUX[9] == 1'b0) #(341800); // delay = 3.418e-10
        else if(COARSE_MUX[10] == 1'b0) #(373000); // delay = 3.73e-10
        else if(COARSE_MUX[11] == 1'b0) #(399400); // delay = 3.994e-10
        else if(COARSE_MUX[12] == 1'b0) #(431300); // delay = 4.313e-10
        else if(COARSE_MUX[13] == 1'b0) #(465100); // delay = 4.651e-10
        else if(COARSE_MUX[14] == 1'b0) #(511400); // delay = 5.114e-10
        else #(535700); // delay = 5.357e-10
        CLK_VCO <= !CLK_VCO;
    end
`endif
endmodule