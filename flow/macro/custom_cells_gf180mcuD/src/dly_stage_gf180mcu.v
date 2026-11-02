// DLY_STAGE — one matched tap of a custom delay line,
// gf180mcu_fd_sc_mcu9t5v0 (gf180mcuD only).
//
// Two deliberately UNEQUAL but symmetrically-laid-out paths from IN:
//   fast leg : a single clkbuf_1           (~short insertion)
//   slow leg : a dlya_4 matched delay      (~one LSB longer)
// mux2_1 selects between the chain input (B_IN) and the slow leg on
// SEL; a final matched buf_1 equalises output load.  The fast leg is
// padded, not bare, so only the designed LSB step differs between taps.
//
// Replaces "delay cell flattens to whatever the synthesiser picks":
// the tap step is a designed offset between two matched stdcell paths.
module DLY_STAGE (
`ifdef WITH_POWER
    inout VDD, VSS, VPW, VNW,
`endif
    input  IN,        // signal to delay
    input  B_IN,      // chain input (previous stage output)
    input  SEL,       // 0 = pass B_IN through fast leg, 1 = slow leg
    output X          // delayed signal to next stage / line output
);
    wire fast, slow, sel_path;
    gf180mcu_fd_sc_mcu9t5v0__buf_1  u_fast (.I(IN), .Z(fast)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
    gf180mcu_fd_sc_mcu9t5v0__dlya_4 u_slow (.I(IN), .Z(slow)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
    gf180mcu_fd_sc_mcu9t5v0__mux2_1 u_sel (.I0(B_IN), .I1(slow), .S(SEL), .Z(sel_path)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
    gf180mcu_fd_sc_mcu9t5v0__buf_1  u_out  (.I(sel_path), .Z(X)
        `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS),.VPW(VPW),.VNW(VNW)`endif);
endmodule
