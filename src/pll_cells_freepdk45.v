// PLL_CELL_* -> FreePDK45 OSU standard-cell wrappers.
// Planning/simulation only: the predictive PDK has no GDS standard-cell views
// or DRC/LVS path in this repository.
`default_nettype none

module PLL_CELL_INVX1(input I, output ZN);
  (* keep *) INVX1 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX2(input I, output ZN);
  (* keep *) INVX2 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX5(input I, output ZN);
  (* keep *) INVX4 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX9(input I, output ZN);
  (* keep *) INVX8 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_CLKINVX1(input I, output ZN);
  (* keep *) INVX1 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_BUFFX0(input I, output Z);
  (* keep *) BUFX2 impl(.A(I), .Y(Z));
endmodule
module PLL_CELL_NAND2X1(input A0, A1, output ZN);
  (* keep *) NAND2X1 impl(.A(A0), .B(A1), .Y(ZN));
endmodule
module PLL_CELL_NOR2X1(input A0, A1, output ZN);
  (* keep *) NOR2X1 impl(.A(A0), .B(A1), .Y(ZN));
endmodule
module PLL_CELL_NAND3X1(input A0, A1, A2, output ZN);
  (* keep *) NAND3X1 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule
module PLL_CELL_NAND3X8(input A0, A1, A2, output ZN);
  // Functional planning mapping; not a drive-strength equivalent.
  (* keep *) NAND3X1 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule
module PLL_CELL_NAND2BX1(input A0, B0, output ZN);
  wire A0N;
  (* keep *) INVX1 inv(.A(A0), .Y(A0N));
  (* keep *) NAND2X1 n(.A(A0N), .B(B0), .Y(ZN));
endmodule
module PLL_CELL_NOR2BX1(input A0, B0, output ZN);
  wire A0N;
  (* keep *) INVX1 inv(.A(A0), .Y(A0N));
  (* keep *) NOR2X1 n(.A(A0N), .B(B0), .Y(ZN));
endmodule
module PLL_CELL_AND2X1(input A0, A1, output Z);
  (* keep *) AND2X1 impl(.A(A0), .B(A1), .Y(Z));
endmodule
module PLL_CELL_DFFNQX1(input D, CLK, output Q);
  (* keep *) DFFNEGX1 impl(.D(D), .CLK(CLK), .Q(Q));
endmodule
module PLL_CELL_DFFQX1(input D, CLK, output Q);
  (* keep *) DFFPOSX1 impl(.D(D), .CLK(CLK), .Q(Q));
endmodule

`default_nettype wire

// ---------------------------------------------------------------------------
// dco_stage support stubs (dco_tuning_design.md).  No-op on this PDK: the
// tuned multiphase DCO is an ihp-sg13g2 macro; these keep the module
// elaborating everywhere.  A real build on another PDK needs its own
// switched-cap implementation here.
// ---------------------------------------------------------------------------
module PLL_CELL_COARSE_BIT #(
    parameter integer NFINGERS = 1,
    parameter integer SW_M     = 1
) (
`ifdef WITH_POWER
    inout  wire VDD, VSS,
`endif
    inout  wire NODE,
    input  wire EN
);
    wire [NFINGERS-1:0] bot;
    // Inert in digital simulation: the cap bank draws no logic events.
    assign bot = {NFINGERS{1'bz}};
endmodule

module PLL_CELL_DECAP4 (
`ifdef WITH_POWER
    inout wire VDD, VSS
`endif
);
    // No-op.
endmodule
// One fine bit group: NFINGERS small sg13_moscap_n unit fingers behind one
// switch (the fine twin of PLL_CELL_COARSE_BIT).  No-op on this PDK.
module PLL_CELL_FINE_UNIT #(
    parameter integer NFINGERS = 1,
    parameter integer SW_M     = 1
) (
`ifdef WITH_POWER
    inout  wire VDD, VSS,
`endif
    inout  wire NODE,
    input  wire EN
);
    wire [NFINGERS-1:0] sink;
    assign sink = {NFINGERS{1'bz}};
endmodule

module PLL_CELL_OR2X1(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input A0, A1,
  output Z
);
    wire [1:0] sink;
    assign sink = 2'b00;
endmodule

module PLL_CELL_INVX4(
`ifdef WITH_POWER
  VDD, VSS,
`endif
  input I,
  output ZN
);
    // Digital stand-in: same polarity/timing class as the real INVX4.
    wire a;
    PLL_CELL_INVX1 u(.I(I), .ZN(ZN));
endmodule
