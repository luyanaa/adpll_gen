// Functional (behavioural) model of the counter-style digitally-controlled
// delay line (DCDL).  This is the DLL analogue of PLL_COUNTER_DCO: instead of
// a closed ring that free-runs at a digitally-set period, the input clock is
// pushed through a tapped inverter/NAND chain and the MUX selects the tap,
// so the module is a pure transport delay t = T0 + N*tau.  It does not
// generate a frequency.
//
// Mirrors PLL_COUNTER_DCO's modelling style: a fixed TICK_PS grid and a
// delay computed from the thermometer control words.  Use it for RTL smoke
// and closed-loop DLL tests; the physical view is pll_counter_dcdl_phys.v.
module PLL_COUNTER_DCDL #(
    parameter integer COARSE_NDELS = 15,
    parameter integer MID_NDELS = 15,
    parameter integer FINE_NDELS = 31,
    parameter integer TICK_PS = 1000,       // simulation time grid, 1 ps unit
    // nominal per-stage delays in TICK_PS units (model only)
    parameter integer T0_PS = 4000,         // fixed insertion delay
    parameter integer COARSE_STEP_PS = 120,
    parameter integer MID_STEP_PS = 60,
    parameter integer FINE_STEP_PS = 15
) (
    input [COARSE_NDELS-1:0] COARSE_MUX,
    input [MID_NDELS-1:0]    MID_MUX,
    input [FINE_NDELS-1:0]   FINE_MUX,
    input CLK_IN,
    output reg CLK_OUT
);

    // Transport delay in TICK_PS.  Unlike the DCO (which mapped the words to a
    // period), each enabled tap adds a fixed per-stage delay to the input.
    integer delay_ps, i, cc, mc, fc;
    always @(*) begin
        cc = 0; mc = 0; fc = 0;
        for (i = 0; i < COARSE_NDELS; i = i + 1) cc = cc + COARSE_MUX[i];
        for (i = 0; i < MID_NDELS;    i = i + 1) mc = mc + MID_MUX[i];
        for (i = 0; i < FINE_NDELS;   i = i + 1) fc = fc + FINE_MUX[i];
        delay_ps = T0_PS
                 + COARSE_STEP_PS * cc
                 + MID_STEP_PS    * mc
                 + FINE_STEP_PS   * fc;
    end

    // Simple inertial transport: re-time the input by the programmed delay.
    // A change in the control word re-arms the output timing; during lock the
    // loop freezes MUX updates so this never glitches mid-cycle.
    always @(CLK_IN or delay_ps) begin
        CLK_OUT <= #(delay_ps/1000.0) CLK_IN;
    end

endmodule
