// PLL_CELL_* -> sky130_fd_sc_hd mapping.
// Logic-only wrappers; the std-cell VPWR/VGND/VPB/VNB pins are connected by
// the P&R global-connection rules.
`default_nettype none

module PLL_CELL_INVX1(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__inv_2 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX2(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__inv_4 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX5(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__inv_6 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX9(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__inv_6 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_CLKINVX1(input I, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__inv_2 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_BUFFX0(input I, output Z);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__buf_2 impl(.A(I), .X(Z));
endmodule
module PLL_CELL_NAND2X1(input A0, A1, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__nand2_2 impl(.A(A0), .B(A1), .Y(ZN));
endmodule
module PLL_CELL_NAND2BX1(input A0, B0, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__nand2b_2 impl(.A_N(A0), .B(B0), .Y(ZN));
endmodule
module PLL_CELL_NOR2X1(input A0, A1, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__nor2_2 impl(.A(A0), .B(A1), .Y(ZN));
endmodule
module PLL_CELL_NOR2BX1(input A0, B0, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__nor2b_2 impl(.A(A0), .B_N(B0), .Y(ZN));
endmodule
module PLL_CELL_NAND3X1(input A0, A1, A2, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__nand3_2 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule
module PLL_CELL_NAND3X8(input A0, A1, A2, output ZN);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__nand3_2 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule
module PLL_CELL_AND2X1(input A0, A1, output Z);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__and2_2 impl(.A(A0), .B(A1), .X(Z));
endmodule
module PLL_CELL_DFFNQX1(input D, CKN, output Q);
  wire CKN_B;
  (* keep *) (* dont_touch = "true" *)
  PLL_CELL_INVX1 inv_ck(.I(CKN), .ZN(CKN_B));
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__dfxtp_2 impl(.D(D), .CLK(CKN_B), .Q(Q));
endmodule
module PLL_CELL_DFFQX1(input D, CK, output Q);
  (* keep *) (* dont_touch = "true" *)
  sky130_fd_sc_hd__dfxtp_2 impl(.D(D), .CLK(CK), .Q(Q));
endmodule
`default_nettype wire
