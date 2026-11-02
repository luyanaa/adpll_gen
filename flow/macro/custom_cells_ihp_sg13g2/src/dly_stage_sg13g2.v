// DLY_STAGE — one matched tap of a custom delay line, sg13g2_stdcell.
//
// Two deliberately UNEQUAL but symmetrically-laid-out paths from IN:
//   fast leg : a single sg13g2_buf_1              (~short insertion)
//   slow leg : a sg13g2_dlygate4sd3 delay element (~one LSB longer)
// mux2_1 selects between the chain input (B_IN) and the slow leg on
// SEL; a final matched buf_1 equalises output load.  The fast leg is
// padded, not bare, so only the designed LSB step differs between taps.
//
// Replaces "delay cell flattens to whatever the synthesiser picks":
// the tap step is a designed offset between two matched stdcell paths.
module DLY_STAGE (
    input  IN,        // signal to delay
    input  B_IN,      // chain input (previous stage output)
    input  SEL,       // 0 = pass B_IN through fast leg, 1 = slow leg
    output X          // delayed signal to next stage / line output
);
    wire fast, slow, sel_path;
    // fast leg: minimum buffer (the LSB reference)
    sg13g2_buf_1 u_fast (.A(IN), .X(fast));
    // slow leg: matched delay element (one designed LSB longer)
    sg13g2_dlygate4sd3_1 u_slow (.A(IN), .X(slow));
    // tap select: continue the chain (B_IN) or take the slow leg
    sg13g2_mux2_1 u_sel (.A0(B_IN), .A1(slow), .S(SEL), .X(sel_path));
    // matched output buffer (equalises load on both legs)
    sg13g2_buf_1 u_out (.A(sel_path), .X(X));
endmodule
