// A synthesizable configurable divider.
//
// LOAD_DIV is captured immediately and applied only at the end of the
// output period already in progress (the end of its low phase).  The open
// high phase and the open low phase therefore keep the old width, and the
// new ratio starts at its high phase with the phase counter at zero.  A
// load that arrives on the boundary edge itself waits for the next period:
// div_pend is read from the value it already holds.
//
// /1 is a bypass.  The bypass is armed at that same period boundary while
// the counted output is low, and it is dropped on the following falling
// edge of clk, where clk and the counted output are both low.  That avoids
// splicing clk onto a half-finished pulse.
module pll_mod_divider #(
    parameter W = 8,
    // Power-on divisor.  Runtime SET_DIV/LOAD_DIV may still override it, but
    // the generator binds a deterministic out_div here instead of relying on
    // the divider's old hard-coded /2 reset value.
    parameter integer DIV_INIT = 2
)(
    input  wire             clk,
    input  wire             rst_n,     // active low reset
    input  wire [W-1:0]     set_div,   // new division value (>=1)
    input  wire             load_div,  // pulse to latch set_div (synchronous)
    output wire             out,       // divided clock output (/1 bypass)
    output wire [W-1:0]     div_q,     // active divisor (for the DDR CK gate)
    // Registered "divisor is usable for the DDR pad clock" qualification:
    // even and >= 2.  It is computed in this (OUT) clock domain so the
    // ddr_ck_gate negedge capture sees one stable bit instead of an 8-bit
    // compare.  That compare was the last SS setup violator (-0.456 ns at
    // 1.08 V/125 C) because the negedge flop only has half an OUT period.
    output wire             div_even
);
    localparam integer DIV0 = (DIV_INIT < 1) ? 1 : DIV_INIT;
    localparam integer DIV0_HIGH = (DIV0 <= 1) ? 1 :
        (DIV0 % 2 ? (DIV0 / 2) + 1 : (DIV0 / 2));
    localparam integer DIV0_LOW = (DIV0 <= 1) ? 1 : (DIV0 / 2);

    reg [W-1:0] div;
    reg [W-1:0] cnt;
    reg [W-1:0] high_count, low_count;
    reg         high_phase; // 1 => currently producing the high phase
    reg         out_reg;
    reg [W-1:0] div_pend;
    reg         pend;
    reg         use_clk = (DIV0 == 1);  // /1 bypass; out follows clk
    // Initialised as well as reset: use_clk is reset on the FALLING edge, so
    // a reset released in the high phase would leave use_clk_p sampling X.
    reg         use_clk_p;  // use_clk re-timed into the posedge domain
    reg         even_q;     // registered div>=2 && !div[0]
    reg         enter_req;  // arm the bypass on the next falling clk
    reg         leave_req;  // drop the bypass on the next falling clk

    // Odd divisors take the 50%-duty path; even divisors and the /1 bypass
    // keep the existing behaviour.
    assign out = use_clk ? clk : (odd_div ? odd_out : out_reg);
    assign div_q = div;
    assign div_even = even_q;

    // ------------------------------------------------------------------
    // Odd divisors need 50% duty to feed a DLL.
    //
    // With the posedge-only counter an odd divisor cannot be 50%: div=3 is
    // 2:1 (66.7%), div=5 3:2 (60%), div=15 8:7 (53.3%).  A DLL fed from that
    // reference sees unequal phase steps and has no legal code over one
    // period.
    //
    // Kept deliberately OUTSIDE the main FSM: an earlier version gated the
    // existing posedge path on `odd_div` and broke the even-divisor load
    // (the FSM never applied `div_pend`, so div stayed at DIV_INIT).  This
    // block only reads `div` and drives `out` when div is odd.
    //
    // Standard construction: two counters, one per clk edge, each producing
    // a k=(div-1)/2 wide pulse; OR the two.  The negedge copy is half a cycle
    // later, so high time is k+0.5 out of div -> exactly 50%.
    // ------------------------------------------------------------------
    wire         odd_div = div[0] && (div > 1);
    wire [W-1:0] odd_k   = (div == 1) ? 'd0 : ((div - 1'b1) >> 1);

    reg [W-1:0] pcnt, ncnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)      pcnt <= 'd0;
        else if (odd_div) pcnt <= (pcnt + 1'b1 >= div) ? 'd0 : pcnt + 1'b1;
        else             pcnt <= 'd0;
    end
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)      ncnt <= 'd0;
        else if (odd_div) ncnt <= (ncnt + 1'b1 >= div) ? 'd0 : ncnt + 1'b1;
        else             ncnt <= 'd0;
    end

    // Pulse high while the counter is below the half width.  Registered on the
    // opposite edge so the OR has no glitch.
    reg p_hi, n_hi;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) p_hi <= 1'b0; else p_hi <= odd_div && (pcnt < odd_k);
    always @(posedge clk or negedge rst_n)
        if (!rst_n) n_hi <= 1'b0; else n_hi <= odd_div && (ncnt < odd_k);

    wire odd_out = odd_div && (p_hi | n_hi);

    wire [W-1:0] limit = high_phase ? high_count : low_count;
    // End of the low phase: the output period in progress is complete.
    wire cycle_end = !use_clk_p && !leave_req && !high_phase &&
                     (cnt + 1'b1 >= low_count);
    wire apply_pend = pend && cycle_end && !load_div;
    // div_for_counts must not depend on use_clk.  use_clk is a falling-edge
    // flop (the /1 bypass select), so any term that consults it turns the
    // width pre-decode into a half-OUT-period path; that was the last ics55
    // SS setup violator (-0.641 ns at 1.08 V/125 C).  The `!use_clk` qualifier
    // is redundant: while use_clk is high the posedge block only clears the
    // counter and never reads high_count/low_count, and when the bypass is
    // dropped leave_req is still set, so the div_pend selection is unchanged.
    wire [W-1:0] div_for_counts = (leave_req || apply_pend) ? div_pend : div;

    // Pre-decode both candidate divisors concurrently, then pick one.  The
    // candidates are the running `div` and the pending `div_pend`; both are
    // registered and stable well before the select resolves.
    function [W-1:0] half_hi;
        input [W-1:0] d;
        begin
            if (d <= 1)          half_hi = {{(W-1){1'b0}}, 1'b1};
            else if (d[0])       half_hi = (d >> 1) + 1'b1;
            else                 half_hi = d >> 1;
        end
    endfunction
    function [W-1:0] half_lo;
        input [W-1:0] d;
        begin
            if (d <= 1)          half_lo = {{(W-1){1'b0}}, 1'b1};
            else                 half_lo = d >> 1;
        end
    endfunction
    wire [W-1:0] hi_cur = half_hi(div);
    wire [W-1:0] lo_cur = half_lo(div);
    wire [W-1:0] hi_pend = half_hi(div_pend);
    wire [W-1:0] lo_pend = half_lo(div_pend);
    // The select is combinational from two falling-edge/derived flops
    // (use_clk_p, leave_req) plus apply_pend, and it fans out into two 12-bit
    // muxes whose inputs are barrel shifters (half_hi/half_lo).  That whole
    // cone sat on high_count's D input: 36 of the 53 SS OUT violators start at
    // div.cnt[1] and end at div.high_count[*].
    //
    // Both mux inputs (div, div_pend) are registered and stable well before the
    // select resolves -- the comment above the functions says so -- so the
    // select itself can be registered.  Costs one OUT cycle of latency on a
    // ratio *change*, which only happens on SET_DIV commits.
    reg div_for_counts_is_pend_q;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) div_for_counts_is_pend_q <= 1'b0;
        else        div_for_counts_is_pend_q <= (!use_clk_p && leave_req) || apply_pend;
    end
    wire [W-1:0] high_count_pend = div_for_counts_is_pend_q ? hi_pend : hi_cur;
    wire [W-1:0] low_count_pend  = div_for_counts_is_pend_q ? lo_pend : lo_cur;
    wire div_for_counts_is_pend = div_for_counts_is_pend_q;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div        <= DIV0[W-1:0];
            even_q     <= (DIV0 >= 2) && !DIV0[0];
            cnt        <= 'd0;
            out_reg    <= 1'b0;
            high_phase <= 1'b0;
            high_count <= DIV0_HIGH[W-1:0];
            low_count  <= DIV0_LOW[W-1:0];
            div_pend   <= DIV0[W-1:0];
            pend       <= 1'b0;
            enter_req  <= 1'b0;
            leave_req  <= 1'b0;
        end else begin
            // Re-time the bypass select into this (posedge) domain.  use_clk
            // itself is a falling-edge flop, so reading it here created a
            // half-OUT-period reg->reg path (ics55 SS -0.558 ns).  The
            // re-timed copy is equivalent for the control decisions below:
            // while use_clk is high the output is driven by clk through the
            // mux, so out_reg/cnt are not observable for that one cycle.
            use_clk_p <= use_clk;

            // Zero is rejected as /1.  A load on the cycle-end edge stays
            // pending; apply_pend ignores load_div so this edge still
            // finishes the old period.
            // The DDR qualification follows the divisor actually in force,
            // so a ratio change updates it one OUT edge after `div`.
            even_q <= (div_for_counts >= 2) && !div_for_counts[0];

            if (load_div) begin
                div_pend <= (set_div < 1) ? 1 : set_div;
                pend <= 1'b1;
            end else if (apply_pend || (!use_clk_p && leave_req)) begin
                pend <= 1'b0;
            end

            // Register the two candidate high/low widths and select with a
            // single mux.  The direct form put the whole
            // div -> half-compare -> shift -> increment chain in the same
            // cycle, and div_for_counts depends on use_clk (a falling-edge
            // flop with only half an OUT period).  That path was the SS
            // post-route setup violator (-0.784 ns at 1.08 V/125 C).
            high_count <= high_count_pend;
            low_count  <= low_count_pend;

            if (use_clk_p) begin
                // Bypass.  Hold the counter low so leaving it starts a low
                // phase.  use_clk itself falls in the negedge block.
                cnt <= 'd0;
                out_reg <= 1'b0;
                high_phase <= 1'b0;
                if (enter_req)
                    enter_req <= 1'b0;
                if (pend && (div_pend != 1))
                    leave_req <= 1'b1;
            end else if (leave_req) begin
                // use_clk fell on the previous negedge, while clk was low.
                // That falling edge is the end of the /1 low half.  Start
                // the new ratio's high phase now instead of inserting
                // another low phase.
                div <= div_pend;
                leave_req <= 1'b0;
                // The high phase starts on this edge.  It must last the
                // new ratio's full high width, so the counter starts at
                // zero: pre-loading one less than the high width makes the
                // next edge satisfy cnt+1 >= limit and emits a one-cycle
                // high.
                cnt <= 'd0;
                out_reg <= 1'b1;
                high_phase <= 1'b1;
            end else if (apply_pend && (div_pend == 1)) begin
                div <= 1;
                cnt <= 'd0;
                out_reg <= 1'b0;
                high_phase <= 1'b0;
                enter_req <= 1'b1;
            end else if (apply_pend) begin
                // The low phase that just finished keeps its old width.
                // Start the new ratio on its high phase; restarting another
                // low phase would stretch the low pulse.
                div <= div_pend;
                cnt <= 'd0;
                out_reg <= 1'b1;
                high_phase <= 1'b1;
            end else if (cnt + 1'b1 >= limit) begin
                cnt <= 'd0;
                out_reg <= ~out_reg;
                high_phase <= ~high_phase;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    // Bypass select changes only while clk is low.  Entering there keeps
    // out low until the next rising clk.  Leaving there hands the output
    // back to out_reg, which the posedge block holds low.
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            use_clk <= (DIV0 == 1);
        else if (enter_req)
            use_clk <= 1'b1;
        else if (leave_req)
            use_clk <= 1'b0;
    end
endmodule
