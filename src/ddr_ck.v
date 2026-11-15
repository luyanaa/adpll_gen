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
// ck_en is sampled on the divided clock's falling edge, so the pad
// clock starts and stops on a full low phase instead of a runt pulse.
module ddr_ck_gate #(parameter integer W = 8) (
    input  wire             clk_div,
    input  wire             locked,
    input  wire             rst_n,
    input  wire [W-1:0]     div,
    output wire             ck
);
    // Even and >= 2: high_count == low_count in pll_mod_divider.
    wire even_ok = (div >= 2) && !div[0];
    reg ck_en;

    always @(negedge clk_div or negedge rst_n) begin
        if (!rst_n)
            ck_en <= 1'b0;
        else
            ck_en <= (locked === 1'b1) && even_ok;
    end

    assign ck = ck_en & clk_div;
endmodule
