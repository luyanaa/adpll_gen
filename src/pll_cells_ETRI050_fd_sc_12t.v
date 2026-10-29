// PLL_CELL_* -> ETRI050_fd_sc_12t mapping.
// ETRI050 has no nand2b/nor2b cells; those are built from NAND2/NOR2 + INV.
`default_nettype none

module PLL_CELL_INVX1(input I, output ZN);
  (* keep *) (* dont_touch = "true" *) INVX1 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX2(input I, output ZN);
  (* keep *) (* dont_touch = "true" *) INVX2 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX5(input I, output ZN);
  (* keep *) (* dont_touch = "true" *) INVX4 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_INVX9(input I, output ZN);
  (* keep *) (* dont_touch = "true" *) INVX8 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_CLKINVX1(input I, output ZN);
  (* keep *) (* dont_touch = "true" *) INVX1 impl(.A(I), .Y(ZN));
endmodule
module PLL_CELL_BUFFX0(input I, output Z);
  (* keep *) (* dont_touch = "true" *) BUFX2 impl(.A(I), .Y(Z));
endmodule
module PLL_CELL_NAND2X1(input A0, A1, output ZN);
  (* keep *) (* dont_touch = "true" *) NAND2X1 impl(.A(A0), .B(A1), .Y(ZN));
endmodule
module PLL_CELL_NAND2BX1(input A0, B0, output ZN);
  wire A0_B;
  (* keep *) (* dont_touch = "true" *) INVX1 inv_a(.A(A0), .Y(A0_B));
  (* keep *) (* dont_touch = "true" *) NAND2X1 impl(.A(A0_B), .B(B0), .Y(ZN));
endmodule
module PLL_CELL_NOR2X1(input A0, A1, output ZN);
  (* keep *) (* dont_touch = "true" *) NOR2X1 impl(.A(A0), .B(A1), .Y(ZN));
endmodule
module PLL_CELL_NOR2BX1(input A0, B0, output ZN);
  wire A0_B;
  (* keep *) (* dont_touch = "true" *) INVX1 inv_a(.A(A0), .Y(A0_B));
  (* keep *) (* dont_touch = "true" *) NOR2X1 impl(.A(A0_B), .B(B0), .Y(ZN));
endmodule
module PLL_CELL_NAND3X1(input A0, A1, A2, output ZN);
  (* keep *) (* dont_touch = "true" *) NAND3X1 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule
module PLL_CELL_NAND3X8(input A0, A1, A2, output ZN);
  (* keep *) (* dont_touch = "true" *) NAND3X1 impl(.A(A0), .B(A1), .C(A2), .Y(ZN));
endmodule
module PLL_CELL_AND2X1(input A0, A1, output Z);
  (* keep *) (* dont_touch = "true" *) AND2X1 impl(.A(A0), .B(A1), .Y(Z));
endmodule
module PLL_CELL_DFFNQX1(input D, CKN, output Q);
  (* keep *) (* dont_touch = "true" *) DFFNEGX1 impl(.D(D), .CLK(CKN), .Q(Q));
endmodule
module PLL_CELL_DFFQX1(input D, CK, output Q);
  (* keep *) (* dont_touch = "true" *) DFFPOSX1 impl(.D(D), .CLK(CK), .Q(Q));
endmodule
`default_nettype wire
