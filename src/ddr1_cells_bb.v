// SPDX-License-Identifier: Apache-2.0
// Yosys-only blackbox declarations for sg13g2 standard cells that the DDR1
// structural path instantiates but that are NOT declared in the shared
// src/pll_cells_ihp-sg13g2.v blackbox section (that file is shared with the
// SerDes workstream; DDR1 adds its own declarations here instead of editing
// it).
//
// Pin order mirrors the PDK SPICE subckts exactly:
//   sg13g2_buf_4 (X A VDD VSS)
//
// Not used in simulation: src/ddr1_phys_elab_stub.v provides the sim models,
// and the PDK sg13g2_stdcell.spice provides the SPICE devices.
`ifdef YOSYS
(* blackbox *)
module sg13g2_buf_4 (X, A);
    output X;
    input  A;
endmodule
`endif
