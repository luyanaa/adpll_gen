// PDK-independent cell stubs for structural elaboration/synthesis checks.
//
// These are NOT PDK cells, timing models or signoff views.  They exist only so
// the non-SIMULATION tap-bus path can be elaborated without a PDK install.
// A real check must substitute the selected library's PLL_CELL_* wrappers and
// standard-cell models.
module PLL_CELL_INVX1(input I, output ZN);
    assign ZN = ~I;
endmodule

module PLL_CELL_INVX5(input I, output ZN);
    assign ZN = ~I;
endmodule

module PLL_CELL_NAND3X1(input A0, A1, A2, output ZN);
    assign ZN = ~(A0 & A1 & A2);
endmodule

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

module PLL_CELL_KICK_PU (
`ifdef WITH_POWER
    inout  wire VDD, VSS,
`endif
    inout  wire NODE,
    input  wire KICKB
);
    // Inert in digital simulation.
    wire sink;
    assign sink = 1'bz;
endmodule
