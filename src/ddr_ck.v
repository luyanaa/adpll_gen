// DDR CK gate.
//
// The PLL loop clock (OUT) and the raw divider keep running so the
// lock detector can finish.  The pad clock CK stays low until all of:
//   * LOCKED is 1 (and returns low if lock is lost)
//   * the integer divisor is even and at least 2
//
// An even divisor makes the divider's high and low phases the same
// number of DCO cycles, so tCH == tCL in cycle counts (50%).  Odd
// divisors are outside the DDR tCH/tCL window used here (0.45-0.55)
// for the small ratios that reach 100 MHz, so CK stays quiet.
//
// ck_en is sampled on the divided clock's falling edge, so a normal
// ratio change or disable lets the high pulse already open finish with its
// old width.  The next period starts with the new ratio: if the new divisor
// is odd, its first high is emitted at the odd width and ck_en drops at
// that falling edge, so no second odd pulse starts.  That single
// transition pulse is a shutdown artifact, not a steady-state DDR tCH/tCL
// pulse.
//
// CK is also combinationally AND-gated by locked.  That is fail-closed,
// not glitchless shutdown: if LOCKED falls while CK is high, CK goes low
// at once and that last high phase is shorter than tCH.  The gate is what
// stops the pad when the DCO sticks high and the divided falling edge
// that would clear ck_en never arrives, so it must not wait for a low
// window.  A DDR timing claim therefore covers normal operation and the
// steady state after a ratio change only; after a lock fault, or on the
// single odd-ratio transition pulse, the last high is reported as
// truncated or off-duty, not as a compliant tCH/tCL clock.
module ddr_ck_gate #(parameter integer W = 8) (
    input  wire             clk_div,
    input  wire             locked,
    input  wire             rst_n,
    input  wire [W-1:0]     div,
    // Pre-registered "even and >= 2" qualification from pll_mod_divider.
    // Computed in the OUT domain; this block only samples the one bit on the
    // divided clock's falling edge.  Recomputing the 8-bit compare here put
    // it on the negedge capture path, where only half an OUT period is
    // available (ics55 SS -0.456 ns).
    input  wire             div_even,
    output wire             ck
);
    reg ck_en;

    always @(negedge clk_div or negedge rst_n) begin
        if (!rst_n)
            ck_en <= 1'b0;
        else
            ck_en <= (locked === 1'b1) && div_even;
    end

    assign ck = ck_en & locked & clk_div;
endmodule
