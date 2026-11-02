// DLY_STAGE — one matched tap of a custom delay line, or1_fd_sc (OpenRule1um).
//
// or1_fd_sc is a minimal SCL: no dedicated delay cell, no mux2, no latch.
// The tap is built from matched INVX1 legs and a three-NAND 2:1 select:
//
//   fast leg : INVX1 x2   (~short — sets the reference insertion)
//   slow leg : INVX1 x4   (+ one matched inverter pair = the designed LSB)
//   select   : (SEL ? slow : B_IN) via three NAND2X1
//
//   mux = NAND( ~(SEL&slow), ~(~SEL&B_IN) )  =  (SEL&slow) | (~SEL&B_IN)
//
// Both legs keep the same polarity and equal drive, so the only delay
// that differs is the designed LSB step.  or1_fd_sc has a single drive
// strength per gate — matching comes from identical cell+fanout, not
// from a delay-tuned cell like sky130's clkdlybuf.
module DLY_STAGE (
`ifdef WITH_POWER
    inout VDD, VSS,
`endif
    input  IN,        // signal to delay
    input  B_IN,      // chain input (previous stage output)
    input  SEL,       // 0 = pass B_IN (fast), 1 = slow leg
    output X          // delayed signal to next stage
);
    wire f0, fast, s0, slow;
    wire selb, nsel, nbsel;
    // fast leg: matched minimum path (2 inversions, non-inverting)
    INVX1 u_f0 (.A(IN),  .Y(f0)   `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    INVX1 u_f1 (.A(f0),  .Y(fast) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    // slow leg: fast leg + one extra matched inverter pair = the LSB
    INVX1 u_s0 (.A(fast), .Y(s0)   `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    INVX1 u_s1 (.A(s0),   .Y(slow) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    // select: (SEL ? slow : B_IN) — three-NAND 2:1 mux
    INVX1   u_sb (.A(SEL),   .Y(selb)  `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    NAND2X1 u_ns (.A(SEL),   .B(slow), .Y(nsel)  `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    NAND2X1 u_nb (.A(selb),  .B(B_IN), .Y(nbsel) `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
    NAND2X1 u_mx (.A(nsel),  .B(nbsel),.Y(X)     `ifdef WITH_POWER ,.VDD(VDD),.VSS(VSS)`endif);
endmodule
