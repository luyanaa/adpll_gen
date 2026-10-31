// RTL equivalence check for the sky130 counter accumulator optimization.
//
// Compares PLL_COUNTER_DCO_PHYS (carry-select phase accumulator plus
// popcount MUX decode) against the original serial-subtract / ripple-adder
// model over several COARSE/MID/FINE codes.
//
// Reproduce from the repository root:
//   iverilog -g2012 -DSIMULATION \
//     -o /tmp/tb_counter.vvp \
//     flow/macro/counter_dco_sky130/tb_accumulator_equivalence.v \
//     flow/macro/counter_dco_sky130/src/pll_counter_dco_phys.v
//   vvp /tmp/tb_counter.vvp
`timescale 1ns/1ps

module sim_SSBBPD(input CLK_VCO, CLK_REF, output [1:0] SS_BBPD);
    assign SS_BBPD = {CLK_VCO, CLK_REF};
endmodule

module ref_counter #(
    parameter integer ACC_BITS = 16,
    parameter integer BASE_INC = 3493,
    parameter integer COARSE_STEP = 120,
    parameter integer MID_STEP = 60,
    parameter integer FINE_STEP = 15
) (
    input [14:0] COARSE_MUX,
    input [14:0] MID_MUX,
    input [30:0] FINE_MUX,
    input TICK, DCO_EN,
    output reg OUT
);
    reg [ACC_BITS-1:0] phase;
    reg [ACC_BITS:0] phase_sum;
    reg [ACC_BITS:0] increment;
    integer i;

    always @* begin
        increment = BASE_INC;
        for (i = 0; i < 15; i = i + 1)
            if (COARSE_MUX[i]) increment = increment - COARSE_STEP;
        for (i = 0; i < 15; i = i + 1)
            if (MID_MUX[i]) increment = increment - MID_STEP;
        for (i = 0; i < 31; i = i + 1)
            if (FINE_MUX[i]) increment = increment - FINE_STEP;
        if (increment < 1) increment = 1;
        if (increment > (1 << ACC_BITS) / 2)
            increment = (1 << ACC_BITS) / 2;
        phase_sum = phase + increment;
    end

    always @(posedge TICK or negedge DCO_EN) begin
        if (!DCO_EN) begin
            phase <= 'd0;
            OUT <= 1'b0;
        end else begin
            phase <= phase_sum[ACC_BITS-1:0];
            if (phase_sum[ACC_BITS]) OUT <= ~OUT;
        end
    end
endmodule

module tb;
    reg [14:0] COARSE_MUX;
    reg [14:0] MID_MUX;
    reg [30:0] FINE_MUX;
    reg TICK, DCO_EN;
    wire OUT_DUT, OUT_REF;
    wire [1:0] SS_BBPD;
    reg prev_out;
    integer n, errors, toggles, code;

    PLL_COUNTER_DCO_PHYS dut (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .TICK(TICK), .DCO_EN(DCO_EN), .REF(1'b0), .INJ_EN(1'b0),
        .SS_BBPD(SS_BBPD), .OUT(OUT_DUT), .MID_OUT(), .INJ_EDGE()
    );
    ref_counter ref_inst (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .TICK(TICK), .DCO_EN(DCO_EN), .OUT(OUT_REF)
    );

    task run_code(input [14:0] c, input [14:0] m, input [30:0] f);
        begin
            COARSE_MUX = c;
            MID_MUX = m;
            FINE_MUX = f;
            DCO_EN = 0;
            TICK = 0;
            #5 DCO_EN = 1;
            #5;
            toggles = 0;
            prev_out = 0;
            for (n = 0; n < 20000; n = n + 1) begin
                TICK = 0;
                #5 TICK = 1;
                #5;
                if (OUT_DUT !== OUT_REF) begin
                    errors = errors + 1;
                    if (errors < 10)
                        $display("MISMATCH code=%0d cyc=%0d dut=%b ref=%b",
                                 code, n, OUT_DUT, OUT_REF);
                end
                if (n > 0 && OUT_DUT !== prev_out) toggles = toggles + 1;
                prev_out = OUT_DUT;
            end
            $display("code %0d: errors=%0d toggles=%0d", code, errors, toggles);
        end
    endtask

    initial begin
        errors = 0;
        code = 0; run_code(0, 0, 0);
        code = 1; run_code(15'h0001, 0, 0);
        code = 2; run_code(15'h7fff, 0, 0);
        code = 3; run_code(0, 15'h7fff, 0);
        code = 4; run_code(0, 0, 31'h7fffffff);
        code = 5; run_code(15'h00ff, 15'h00ff, 31'h00ff00ff);
        if (errors != 0) $fatal(1, "counter equivalence failed: %0d errors", errors);
        $display("COUNTER EQUIVALENCE PASS");
        $finish;
    end
endmodule
