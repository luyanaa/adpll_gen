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
