// PLL_CELL_* -> gf180mcu_as_sc_mcu7t3v3 mapping.
// Logic-only wrappers; the std-cell VPW/VNW/VDD/VSS pins are connected by the
// P&R global-connection rules (SCL_POWER_PINS / SCL_GROUND_PINS).
`default_nettype none

module PLL_CELL_INVX1(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__inv_2 impl(.A(I), .Y(ZN));
endmodule

module PLL_CELL_INVX2(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__inv_4 impl(.A(I), .Y(ZN));
endmodule

module PLL_CELL_INVX5(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__inv_6 impl(.A(I), .Y(ZN));
endmodule

module PLL_CELL_INVX9(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__inv_8 impl(.A(I), .Y(ZN));
endmodule

module PLL_CELL_CLKINVX1(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__inv_2 impl(.A(I), .Y(ZN));
endmodule

module PLL_CELL_BUFFX0(input I, output Z);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__buff_2 impl(.A(I), .Y(Z));
endmodule

module PLL_CELL_NAND2X1(input A0, A1, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__nand2_2 impl(.A(A0), .B(A1), .Y(ZN));
endmodule

module PLL_CELL_NAND2BX1(input A0, B0, output ZN);
  // NAND2BX1 = !(!A0 & B0) = A0 | !B0
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__nand2b_2 impl(.A(A0), .B(B0), .Y(ZN));
endmodule

module PLL_CELL_NOR2X1(input A0, A1, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__nor2_2 impl(.A(A0), .B(A1), .Y(ZN));
endmodule

module PLL_CELL_NOR2BX1(input A0, B0, output ZN);
  // NOR2BX1 = !(!A0 | B0) = A0 & !B0
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__nor2b_2 impl(.A(A0), .B(B0), .Y(ZN));
endmodule

module PLL_CELL_NAND3X1(input A0, A1, A2, output ZN);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__nand3_2 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule

module PLL_CELL_NAND3X8(input A0, A1, A2, output ZN);
  // Functional mapping only: one nand3_2 instead of a drive-8 cell.
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__nand3_2 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule

module PLL_CELL_AND2X1(input A0, A1, output Z);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__and2_2 impl(.A(A0), .B(A1), .Y(Z));
endmodule

module PLL_CELL_DFFNQX1(input D, CKN, output Q);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__dfxtn_2 impl(.D(D), .CLK(CKN), .Q(Q));
endmodule

module PLL_CELL_DFFQX1(input D, CK, output Q);
  (* keep *) (* dont_touch = "true" *)
  gf180mcu_as_sc_mcu7t3v3__dfxtp_2 impl(.D(D), .CLK(CK), .Q(Q));
endmodule

`default_nettype wire
