`timescale 1ns/1ps
// TDC_TOP — SAR time-to-digital converter (functional model).
//
// Measures the delay of SIG relative to REF by pushing REF through the
// shared DCDL and binary-searching the tap count until the delayed REF
// edge coincides with the SIG edge.  The converged code * LSB is the
// time difference.  This is the cheap SAR/TDC variant — one delay line
// and a linear search engine, versus a full flash TDC's per-tap
// arbiter chain (the expensive option in the research table).
//
// The comparison uses the same bang-bang PD as the DLL: whether the
// delayed REF edge leads or lags the SIG edge is a 1-bit result, which
// is all a SAR step needs.
module TDC_TOP #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS    = 15,
    parameter integer FINE_NDELS   = 31,
    parameter integer MID_W = 4,
    parameter integer COARSE_W = 8,
    parameter integer CODE_BITS = 8,
    parameter integer SETTLE = 4
) (
    input  REF,                      // reference edge
    input  SIG,                      // edge whose delay vs REF is measured
    input  RST_N,
    input  TICK,
    input  START,                    // begin a conversion
    output reg [CODE_BITS-1:0] TDC_CODE,
    output reg TDC_HALF,                 // sub-LSB interpolation bit
    output reg DONE,
    output reg BUSY
);
    localparam integer TOTAL_STEPS =
        FINE_NDELS + MID_W*MID_NDELS + COARSE_W*COARSE_NDELS;

    // ---- SAR state machine: binary-search the code 0..TOTAL_STEPS ----
    reg [CODE_BITS-1:0] lo, hi, mid;
    reg [3:0] settle;
    wire pd_late;                    // delayed REF edge is later than SIG

    localparam [CODE_BITS-1:0] STEPS_C = TOTAL_STEPS;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) begin
            lo<=0; hi<=STEPS_C; mid<=0; settle<=0;
            TDC_CODE<=0; TDC_HALF<=0; DONE<=0; BUSY<=0;
        end else if (START && !BUSY && !DONE) begin
            lo<=0; hi<=STEPS_C;
            mid<=STEPS_C >> 1;
            settle<=0; BUSY<=1; DONE<=0;
        end else if (BUSY) begin
            if (settle < SETTLE[3:0]) begin
                settle <= settle + 1;
            end else begin
                if (pd_late) hi <= mid - 1; else lo <= mid + 1;
                if (lo >= hi - 1 || mid == 0) begin
                    TDC_CODE <= mid;
                    // sub-LSB: edge inside the multi-threshold window
                    // (early sampler saw it, late one didn't) -> +1/2 LSB
                    TDC_HALF <= half_bit;
                    BUSY <= 0; DONE <= 1;
                end else begin
                    mid <= (lo + hi) >> 1;
                    settle <= 0;
                end
            end
        end else if (!START) begin
            DONE <= 0;
        end
    end

    // ---- decode mid -> thermometer taps (shift/saturate, same as DLL) --
    wire [7:0] code = mid;
    wire [7:0] fine_w   = (code > FINE_NDELS) ? FINE_NDELS : code;
    wire [7:0] rem1     = code - fine_w;
    wire [7:0] mid_w    = (rem1[7:2] > MID_NDELS) ? MID_NDELS : rem1[7:2];
    wire [7:0] rem2     = rem1 - (mid_w << 2);
    wire [7:0] coarse_w = (rem2[7:3] > COARSE_NDELS) ? COARSE_NDELS : rem2[7:3];

    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0]    MID_MUX;
    wire [FINE_NDELS-1:0]   FINE_MUX;
    pll_term_decoder_with_zero #(.NDELS(COARSE_NDELS)) dec_c (
        .IN(coarse_w[$clog2(COARSE_NDELS+1)-1:0]), .OUT(COARSE_MUX));
    pll_term_decoder_with_zero #(.NDELS(MID_NDELS)) dec_m (
        .IN(mid_w[$clog2(MID_NDELS+1)-1:0]), .OUT(MID_MUX));
    pll_term_decoder_with_zero #(.NDELS(FINE_NDELS)) dec_f (
        .IN(fine_w[$clog2(FINE_NDELS+1)-1:0]), .OUT(FINE_MUX));

    // ---- delayed REF through the DCDL ----
    wire ref_d;
`ifdef SIMULATION
    PLL_COUNTER_DCDL #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS), .T0_PS(0)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(REF), .CLK_OUT(ref_d)
    );
`else
    PLL_COUNTER_DCDL_PHYS #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS), .FINE_NDELS(FINE_NDELS)
    ) dcdl (
        .COARSE_MUX(COARSE_MUX), .MID_MUX(MID_MUX), .FINE_MUX(FINE_MUX),
        .CLK_IN(REF), .CLK_OUT(ref_d)
    );
`endif

    // ---- edge comparison: multi-threshold sampling -------------------
    // The main arbiter is the custom ARB_CELL (a transparent-latch
    // resolver + decision FF), not a bare DFF — better MTBF and a
    // narrower indeterminate band.  The half-LSB interpolation still
    // uses a second sampler on a deliberately offset ref_d stub.
    // Single arbiter DFF -> a 1-bit late/early verdict with no sub-LSB
    // information: the metastability window is a single razor edge.
    //
    // INSTEAD, *manufacture* the uncertainty:  fan ref_d out through two
    // deliberately UNEQUAL clock stubs so the two samplers see the same
    // REF edge at different effective times (offset delta = one delay
    // stage).  This is an intentional, *designed* setup/hold violation
    // window: SIG edges that land between the two sampling instants make
    // the two samplers DISAGREE, which interpolates the edge position to
    // ~1/2 LSB.  All standard cells: 2 DFFs + a fixed `inv_4` clock stub
    // on the late tap.  (Versus a true arbiter, which needs a custom
    // metastability-resolution cell; versus a 2-FF TICK re-sync, which
    // adds latency that makes the SAR read a stale sample.)
    //
    //   ref_d_early --+--> [DFF early] q_e      q_e=1 & q_l=0 : edge is
    //   ref_d ----[inv_4]--> [DFF late] q_l      inside the window -> 1/2
    wire ref_d_late;
`ifdef SIMULATION
    // behavioural delay stub standing in for the matched inv_4 clock
    // buffer (the physical macro uses a real clocked buffer stage)
    assign #(15) ref_d_late = ref_d;
`else
    // a matched clock-buffer stub = one delay stage on the late sampler
    // clock pin; sky130 clock buffer cell, no logic.
    sky130_fd_sc_hd__clkbuf_4 u_interp_delay (.A(ref_d), .X(ref_d_late));
`endif
    wire sig_e;   // main arbiter verdict (custom ARB_CELL)
    reg  sig_l;   // offset sampler for the half-LSB interpolation
    ARB_CELL u_arb (.D(SIG), .CK(ref_d), .RST_B(RST_N), .Q(sig_e)
        `ifdef WITH_POWER , .VPWR(VPWR), .VGND(VGND)`endif);
    always @(posedge ref_d_late or negedge RST_N) begin
        if (!RST_N) sig_l <= 1'b0;
        else        sig_l <= SIG;
    end
    // The SAR verdict keeps using the MAIN sampler (sig_e on ref_d); the
    // delayed sampler only supplies the half-LSB refinement.  sig_e=1
    // while sig_l=0 means the SIG edge fell between the two sampling
    // instants -> it is inside the interpolation window -> +1/2 LSB.
    assign pd_late  = sig_e;              // coarse late/early verdict
    wire   half_bit = sig_e & ~sig_l;     // inside the window -> +1/2 LSB
endmodule
