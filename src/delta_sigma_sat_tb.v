// Focused saturation test for delta_sigma.
// The bug was {(BITS_INT-1){1'b1}}, which gives 5'b01111 for BITS_INT=5.
`timescale 1ns/1ps

module delta_sigma_sat_tb;
    localparam integer BITS_INT = 5;
    localparam integer BITS_DSM = 11;

    reg CK = 1'b0;
    reg RST = 1'b0;
    reg EN_DSM = 1'b1;
    reg EN_DSM_DT = 1'b0;
    reg EN_DSM_SHDT = 1'b1;
    reg [1:0] DSM_ORDER = 2'b01;
    reg [BITS_INT-1:0] FCWI = 0;
    reg [BITS_DSM-1:0] FCWF = 0;
    wire [BITS_INT-1:0] DSM_OUT;

    delta_sigma #(
        .BITS_INT(BITS_INT),
        .BITS_DSM(BITS_DSM)
    ) dut (
        .CK(CK), .RST(RST),
        .EN_DSM(EN_DSM), .EN_DSM_DT(EN_DSM_DT), .EN_DSM_SHDT(EN_DSM_SHDT),
        .DSM_ORDER(DSM_ORDER), .FCWI(FCWI), .FCWF(FCWF),
        .DSM_OUT(DSM_OUT)
    );

    integer errors = 0;

    initial begin
        // Force the two saturation branches directly.  This is a unit test of
        // the output width, independent of the MASH sequence.
        force dut.DSM_CAP_P = 1'b1;
        force dut.DSM_CAP_N = 1'b0;
        #1;
        if (DSM_OUT !== {BITS_INT{1'b1}}) begin
            $display("FAIL: positive saturation DSM_OUT=%b expected=%b",
                     DSM_OUT, {BITS_INT{1'b1}});
            errors = errors + 1;
        end else begin
            $display("PASS: positive saturation DSM_OUT=%0d", DSM_OUT);
        end

        force dut.DSM_CAP_P = 1'b0;
        force dut.DSM_CAP_N = 1'b1;
        #1;
        if (DSM_OUT !== {BITS_INT{1'b0}}) begin
            $display("FAIL: negative saturation DSM_OUT=%b expected=%b",
                     DSM_OUT, {BITS_INT{1'b0}});
            errors = errors + 1;
        end else begin
            $display("PASS: negative saturation DSM_OUT=%0d", DSM_OUT);
        end

        release dut.DSM_CAP_P;
        release dut.DSM_CAP_N;
        if (errors != 0) $fatal(1, "delta_sigma saturation test failed");
        $display("delta_sigma_sat_tb: PASS");
        $finish;
    end
endmodule
