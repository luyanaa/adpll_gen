// Elaboration-only stubs for the sg13g2 standard cells instantiated by
// DDR1_CLK_REGEN (structural) — same role as pll_cells_elab_stub.v: NOT
// timing models, NOT signoff views.  They let iverilog elaborate the
// SEG_IMPL=1 / REGEN_IMPL=1 structural configuration; synthesis uses the
// real blackboxes in pll_cells_ihp-sg13g2.v (guarded by `ifdef YOSYS`)
// and the sg13g2 liberty for mapping.  Do not compile this file together
// with pll_cells_ihp-sg13g2.v when YOSYS is defined.
module sg13g2_inv_1(input A, output Y);
    assign Y = ~A;
endmodule

module sg13g2_nand2b_1(input A_N, input B, output Y);
    assign Y = ~(~A_N & B);
endmodule

module sg13g2_tiehi(output L_HI);
    assign L_HI = 1'b1;
endmodule

module sg13g2_dfrbp_1(input D, input RESET_B, input CLK, output Q, output Q_N);
    reg q = 1'b0;
    always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B) q <= 1'b0;
        else          q <= D;
    end
    assign Q   = q;
    assign Q_N = ~q;
endmodule
