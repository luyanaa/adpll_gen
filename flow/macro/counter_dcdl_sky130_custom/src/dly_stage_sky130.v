// DLY_STAGE — one matched tap of a custom delay line, sky130_fd_sc_hd.
//
// Two deliberately UNEQUAL but SYMMETRICALLY-LAID-OUT paths from IN:
//   fast leg : a single clkbuf_1              (~short insertion)
//   slow leg : a clkdlybuf4s50 matched stage  (~one LSB longer)
// mux2_1 selects between them on SEL; a final matched clkinv_1 restores
// polarity and equalises the output load on both legs.  Because both
// legs go through the SAME number of matching stages (the fast leg is
// padded, not left bare), the only delay that differs is the intentional
// LSB step — process/voltage/temperature skews track across the line.
//
// This replaces the "delay cell flattens to whatever the synthesiser
// picks" position: here the tap step is a *designed* offset between two
// matched stdcell paths, not a synthesised accident.
`ifdef WITH_POWER
`define P .VPWR(VPWR), .VGND(VGND), .VPB(VPWR), .VNB(VGND),
`else
`define P
`endif
module DLY_STAGE (
`ifdef WITH_POWER
    inout VPWR, VGND,
`endif
    input  IN,        // signal to delay
    input  B_IN,      // chain input (previous stage output)
    input  SEL,       // 0 = pass B_IN through fast leg, 1 = slow leg
    output X          // delayed signal to next stage / line output
);
    wire fast, slow, sel_path;
    // fast leg: minimum buffer (the LSB reference)
    sky130_fd_sc_hd__clkbuf_1 u_fast (.A(IN), .X(fast) `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
    // slow leg: matched delay element (one designed LSB longer)
    sky130_fd_sc_hd__clkdlybuf4s50_1 u_slow (.A(IN), .X(slow) `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
    // tap select: continue the chain (B_IN) or take the slow leg
    sky130_fd_sc_hd__mux2_1 u_sel (.A0(B_IN), .A1(slow), .S(SEL), .X(sel_path) `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
    // matched output inverter (equalises load on both legs, restores phase)
    sky130_fd_sc_hd__clkinv_1 u_out (.A(sel_path), .Y(X) `ifdef WITH_POWER ,.VPWR(VPWR),.VGND(VGND),.VPB(VPWR),.VNB(VGND)`endif);
endmodule
