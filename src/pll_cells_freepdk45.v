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
