// Physical Core C counter DCO / NCO.
//
// This is a synthesizable phase accumulator, not a behavioral delay model.
// The DCO needs an externally supplied high-speed TICK.  There is no fixed
// 1 GHz assumption: the generator must bind tick_frequency_mhz.  The output
// clock toggles once per accumulator carry, so one output period is two
// carries and f_OUT = f_TICK * increment / 2^(ACC_BITS+1).  The control codes
// are unary thermometer codes from pll_logic.
`timescale 1ns/1ps

// 8-bit ripple-carry slice used by the carry-select phase accumulator below.
// The module is intentionally not marked keep_hierarchy: LibreLane's
// `prep -flatten` inlines it, so the three slices are ordinary gates after
// synthesis and do not look like unresolved macros to CTS/PDN.
module PLL_ADD8 (
    input  [7:0] A,
    input  [7:0] B,
    input        CI,
    output [7:0] S,
    output       CO
);
    assign {CO, S} = A + B + CI;
endmodule

module PLL_COUNTER_DCO_PHYS #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer ACC_BITS = 16,
    parameter integer BASE_INC = 3493,
    parameter integer COARSE_STEP = 120,
    parameter integer MID_STEP = 60,
    parameter integer FINE_STEP = 15
) (
    input [COARSE_NDELS-1:0] COARSE_MUX,
    input [MID_NDELS-1:0] MID_MUX,
    input [FINE_NDELS-1:0] FINE_MUX,
    input TICK,
    input DCO_EN, REF, INJ_EN,
    output [1:0] SS_BBPD,
    output reg OUT,
    output MID_OUT,
    output INJ_EDGE
);
    reg [ACC_BITS-1:0] phase;
    reg [ACC_BITS:0] increment;
    integer i;
    integer coarse_count, mid_count, fine_count, increment_calc;

    // Event semantics: one accumulator carry is one output toggle, not one
    // output period.  phase_overflow and output_edge are the same event here;
    // two carries are required for a complete OUT period.
    wire phase_overflow;
    wire [ACC_BITS-1:0] phase_next;
    wire output_edge = phase_overflow;

    assign MID_OUT = OUT;
    assign INJ_EDGE = REF;

    always @* begin
        // More unary delay bits means more delay and therefore a lower
        // output frequency, matching pll_logic's coarse/mid tuning direction.
        // Count each unary bank and do one arithmetic update instead of the
        // previous serial chain of 61 conditional subtracts.  The counts are
        // static configuration inputs, so this is a decode path, not the
        // TICK-clocked accumulator loop.
        coarse_count = 0;
        for (i = 0; i < COARSE_NDELS; i = i + 1)
            coarse_count = coarse_count + COARSE_MUX[i];
        mid_count = 0;
        for (i = 0; i < MID_NDELS; i = i + 1)
            mid_count = mid_count + MID_MUX[i];
        fine_count = 0;
        for (i = 0; i < FINE_NDELS; i = i + 1)
            fine_count = fine_count + FINE_MUX[i];
        increment_calc = BASE_INC
                         - coarse_count * COARSE_STEP
                         - mid_count * MID_STEP
                         - fine_count * FINE_STEP;
        if (increment_calc < 1)
            increment_calc = 1;
        if (increment_calc > (1 << ACC_BITS) / 2)
            increment_calc = (1 << ACC_BITS) / 2;
        increment = increment_calc;
    end

`ifdef SIMULATION
    // The combinational increment block is not guaranteed to execute at time
    // zero in event-driven simulators because all unary code inputs start at
    // zero.  Seed a legal code-0 increment so the first measurement does not
    // wait forever on an X phase accumulator.
    initial begin
        coarse_count = 0;
        mid_count = 0;
        fine_count = 0;
        increment_calc = BASE_INC;
        increment = BASE_INC;
    end
`endif

    // 16-bit carry-select phase accumulator.  The low byte propagates its
    // carry directly; the high byte is computed twice (carry-in 0/1) and the
    // correct result is selected.  The carry-select structure halves the
    // critical TICK path versus a single 16-bit ripple chain while keeping
    // the exact phase_sum / overflow semantics.
    wire [7:0] lo_sum;
    wire       lo_carry;
    wire [7:0] hi_sum0, hi_sum1;
    wire       hi_carry0, hi_carry1;
    wire [7:0] hi_sum;

    PLL_ADD8 add_lo (
        .A(phase[7:0]), .B(increment[7:0]), .CI(1'b0),
        .S(lo_sum), .CO(lo_carry)
    );
    PLL_ADD8 add_hi0 (
        .A(phase[ACC_BITS-1:8]), .B(increment[ACC_BITS-1:8]), .CI(1'b0),
        .S(hi_sum0), .CO(hi_carry0)
    );
    PLL_ADD8 add_hi1 (
        .A(phase[ACC_BITS-1:8]), .B(increment[ACC_BITS-1:8]), .CI(1'b1),
        .S(hi_sum1), .CO(hi_carry1)
    );

    assign hi_sum = lo_carry ? hi_sum1 : hi_sum0;
    assign phase_overflow = lo_carry ? hi_carry1 : hi_carry0;
    assign phase_next = {hi_sum, lo_sum};

    always @(posedge TICK or negedge DCO_EN) begin
        if (!DCO_EN) begin
            phase <= 'd0;
            OUT <= 1'b0;
        end else begin
            phase <= phase_next;
            if (output_edge)
                OUT <= ~OUT;
        end
    end

`ifdef SIMULATION
    sim_SSBBPD bbpd(.CLK_VCO(OUT), .CLK_REF(REF), .SS_BBPD(SS_BBPD));
`else
    PLL_SSBBPD bbpd(
        .INJ_EDGE_BALANCED(REF), .OSC_BALANCED(OUT), .SS_BBPD(SS_BBPD));
`endif
endmodule
