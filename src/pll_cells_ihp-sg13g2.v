// Microdefinition of the cells
// Map the technology standard cells here
// Mapped using the IHP cells for sg13g2

//`define YOSYS
//`define WITH_POWER
//`define WITH_BODY

module PLL_CELL_INVX1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output ZN
);
  // INVX1 -> sg13g2_inv_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_inv_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(I), .Y(ZN)
  );
endmodule

module PLL_CELL_INVX2(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output ZN
);
  // INVX2 -> sg13g2_inv_2
  (* keep *) (* dont_touch = "true" *)
  sg13g2_inv_2 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(I), .Y(ZN)
  );
endmodule

module PLL_CELL_INVX5(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output ZN
);
  // INVX5 -> sg13g2_inv_4
  (* keep *) (* dont_touch = "true" *)
  sg13g2_inv_4 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(I), .Y(ZN)
  );
endmodule

module PLL_CELL_INVX9(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output ZN
);
  // INVX9 -> sg13g2_inv_8
  (* keep *) (* dont_touch = "true" *)
  sg13g2_inv_8 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(I), .Y(ZN)
  );
endmodule

module PLL_CELL_NAND3X8(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, A1, A2, // NOTE: A1 should be ALWAYS the middle one. Check it on the spice.
  output ZN
);
  // NAND3X8 -> sg13g2_nand3_1 x8
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_0(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    // A0 Should be to the gate that goes to GND
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_1(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_2(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_3(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_4(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_5(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_6(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl_7(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );

endmodule

module PLL_CELL_NAND3X1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, A1, A2,
  output ZN
);
  // NAND3X1 -> sg13g2_nand3_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand3_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A2), .B(A1), .C(A0), .Y(ZN)
  );

endmodule

module PLL_CELL_NAND2X1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, A1,
  output ZN
);
  // NAND2X1 -> sg13g2_nand2_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand2_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A0), .B(A1), .Y(ZN)
  );

endmodule

module PLL_CELL_NOR2X1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, A1,
  output ZN
);
  // NOR2X1 -> sg13g2_nor2_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nor2_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A0), .B(A1), .Y(ZN)
  );

endmodule

module PLL_CELL_NAND2BX1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, B0, // A0 is the negated one
  output ZN
);
  // NAND2BX1 -> sg13g2_nand2b_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nand2b_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A_N(A0), .B(B0), .Y(ZN)
  );

endmodule

module PLL_CELL_NOR2BX1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, B0, // A0 is the negated one
  output ZN
);
  // NOR2BX1 -> sg13g2_nor2b_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_nor2b_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .B_N(A0), .A(B0), .Y(ZN)
  );

endmodule

module PLL_CELL_BUFFX0(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output Z
);
  // BUFFX0 -> sg13g2_buf_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_buf_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(I), .X(Z)
  );

endmodule

module PLL_CELL_AND2X1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, A1,
  output Z
);
  // AND2X1 -> sg13g2_and2_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_and2_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(A0), .B(A1), .X(Z)
  );

endmodule

module PLL_CELL_OR2X1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, A1,
  output Z
);
  // OR2X1 -> sg13g2_or2_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_or2_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS),
`endif
    .A(A0), .B(A1), .X(Z)
  );

endmodule

module PLL_CELL_INVX4(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output ZN
);
  // INVX4 -> sg13g2_inv_4 -- the tuned ring's stage drive (sizing approved
  // 2026-11-25): inv_1 + the tuning banks' fixed 5.7 fF caps the SS fast
  // end at 185 MHz; inv_4 restores ~310 MHz pre-layout / ~267 routed.
  (* keep *) (* dont_touch = "true" *)
  sg13g2_inv_4 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS),
`endif
    .A(I), .Y(ZN)
  );
endmodule

module PLL_CELL_CLKINVX1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output ZN
);
  // CLKINVX1 -> sg13g2_inv_1
  (* keep *) (* dont_touch = "true" *)
  sg13g2_inv_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(I), .Y(ZN)
  );
endmodule

module PLL_CELL_DFFNQX1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input D, CKN,
  output Q
);
  // DFFNQX1 -> sg13g2_dfrbp_1 + sg13g2_inv_1 + sg13g2_tiehi
  wire CLK;
  wire RESET_B;
  (* keep *) (* dont_touch = "true" *)
  sg13g2_inv_1 impl_inv(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .A(CKN), .Y(CLK)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_tiehi impl_tiehi(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .L_HI(RESET_B)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_dfrbp_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .RESET_B(RESET_B), .D(D), .CLK(CLK), .Q(Q), .Q_N()
  );
endmodule

module PLL_CELL_DFFQX1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input D, CK,
  output Q
);
  // DFFQX1 -> sg13g2_dfrbp_1 + sg13g2_tiehi
  wire RESET_B;
  (* keep *) (* dont_touch = "true" *)
  sg13g2_tiehi impl_tiehi(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .L_HI(RESET_B)
  );
  (* keep *) (* dont_touch = "true" *)
  sg13g2_dfrbp_1 impl(
`ifdef WITH_POWER
    .VDD(VDD), .VSS(VSS), 
`endif
    .RESET_B(RESET_B), .D(D), .CLK(CK), .Q(Q), .Q_N()
  );
endmodule

// We also define the used cells as blackboxes for yosys synthesis
`ifdef YOSYS
// PDK primitive: MOS capacitor (gate = G, second plate = SUB).
(* blackbox *)
module sg13_moscap_n (G, SUB);
  // Both terminals carry the cap current; neither drives.
  inout G;   // gate on the tuned node
  inout SUB; // bottom plate -> series switch
endmodule
// PDK primitive: LV NMOS (the switched-cap series switch).
(* blackbox *)
module sg13_lv_nmos (D, G, S, B);
  inout D;
  input  G, S, B;
endmodule
(* blackbox *)
module sg13g2_inv_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A;
endmodule
(* blackbox *)
module sg13g2_inv_2 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A;
endmodule
(* blackbox *)
module sg13g2_inv_4 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A;
endmodule
(* blackbox *)
module sg13g2_inv_8 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A;
endmodule
(* blackbox *)
module sg13g2_dfrbp_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Q, Q_N, D, RESET_B, CLK);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Q, Q_N;
	input D, RESET_B, CLK;
endmodule
(* blackbox *)
module sg13g2_nand3_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A, B, C);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A, B, C;
endmodule
(* blackbox *)
module sg13g2_nand2_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A, B);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A, B;
endmodule
(* blackbox *)
module sg13g2_nor2_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A, B);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A, B;
endmodule
(* blackbox *)
module sg13g2_nand2b_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A_N, B);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A_N, B;
endmodule
(* blackbox *)
module sg13g2_nor2b_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  Y, A, B_N);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output Y;
	input A, B_N;
endmodule
(* blackbox *)
module sg13g2_buf_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  X, A);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output X;
	input A;
endmodule
(* blackbox *)
module sg13g2_and2_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  X, A, B);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output X;
	input A, B;
endmodule
(* blackbox *)
module sg13g2_tiehi (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  L_HI);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output L_HI;
endmodule
(* blackbox *)
module sg13g2_decap_4 (
`ifdef WITH_POWER
  VDD, VSS
`endif
);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
endmodule
(* blackbox *)
module sg13g2_or2_1 (
`ifdef WITH_POWER
  VDD, VSS,
`endif
  X, A, B);
`ifdef WITH_POWER
  inout VDD, VSS;
`endif
	output X;
	input A, B;
endmodule
`endif

// ============================================================================
// dco_stage support cells (dco_tuning_design.md).  These are the only new
// PLL_CELL_* wrappers; every other PDK's pll_cells_*.v carries a functional
// no-op stub so the DCO elaborates everywhere, and only ihp-sg13g2 maps them
// to real devices (sg13_moscap_n has no equivalent elsewhere).
// ============================================================================

// One coarse bit: NFINGERS parallel sg13_moscap_n unit fingers (gate on a
// switched plate node, bottom plate hard to VSS) behind ONE sg13_lv_nmos
// switch on the GATE side (SW_M width multiplier, 4 for the 16-finger bit).
//
// Gate-side switching (measured 2026-11-25): with the switch on the plate
// side an OFF finger still couples its 9.2 fF gate to the ring node through
// the floating plate (~1.3 fF/finger, x31 = dead fixed load that measured
// ~4x period on the 25-stage ring).  With the switch on the gate side an
// OFF finger's gate floats and presents only the switch junction residual
// (~0.2 fF/finger); ON fingers see the full cap through R_on (transparent:
// 147 fF behind a 4x switch is tau ~ 0.4 ns << T/2).
module PLL_CELL_COARSE_BIT #(
    parameter integer NFINGERS = 1,
    parameter integer SW_M     = 1
) (
`ifdef WITH_POWER
    inout  wire VDD, VSS,
`endif
    inout  wire NODE,   // the tuned stage output
    input  wire EN      // buffered COARSE bit (switch gate)
);
    wire gn;
    genvar f;
    generate
        for (f = 0; f < NFINGERS; f = f + 1) begin : finger
            (* keep *) (* dont_touch = "true" *)
            sg13_moscap_n cap (
                // Unit finger ~9.2 fF (w=0.72u x l=1.0u plate at the
                // measured 12.7 fF/um^2 density).
                .G(gn), .SUB(VSS)
            );
        end
    endgenerate
    (* keep *) (* dont_touch = "true" *)
    sg13_lv_nmos sw (
        .D(gn), .G(EN), .S(NODE), .B(VSS)
    );
endmodule

// Per-stage supply decoupling.
module PLL_CELL_DECAP4 (
`ifdef WITH_POWER
    inout wire VDD, VSS
`endif
);
    (* keep *) (* dont_touch = "true" *)
    sg13g2_decap_4 impl(
`ifdef WITH_POWER
        .VDD(VDD), .VSS(VSS)
`endif
    );
endmodule

// One fine bit group: NFINGERS small sg13_moscap_n unit fingers (0.15u x
// 0.5u, ~0.7 fF) behind ONE sg13_lv_nmos gate-side switch -- the fine twin
// of PLL_CELL_COARSE_BIT.
module PLL_CELL_FINE_UNIT #(
    parameter integer NFINGERS = 1,
    parameter integer SW_M     = 1
) (
`ifdef WITH_POWER
    inout  wire VDD, VSS,
`endif
    inout  wire NODE,   // the tuned stage output
    input  wire EN      // buffered fine bit (switch gate)
);
    wire gn;
    genvar f;
    generate
        for (f = 0; f < NFINGERS; f = f + 1) begin : finger
            (* keep *) (* dont_touch = "true" *)
            sg13_moscap_n cap (
                .G(gn), .SUB(VSS)
            );
        end
    endgenerate
    (* keep *) (* dont_touch = "true" *)
    sg13_lv_nmos sw (
        .D(gn), .G(EN), .S(NODE), .B(VSS)
    );
endmodule

