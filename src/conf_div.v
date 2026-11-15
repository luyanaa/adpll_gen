// A synthesizable configurable divider.
//
// LOAD_DIV is captured immediately and applied only at the end of the
// output period already in progress (the end of its low phase).  The open
// high phase and the open low phase therefore keep the old width, and the
// new ratio starts from a low phase.  A load that arrives on the boundary
// edge itself waits for the next period: div_pend is read from the value
// it already holds.
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
    output wire [W-1:0]     div_q      // active divisor (for the DDR CK gate)
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
    reg         use_clk;    // /1 bypass; out follows clk
    reg         enter_req;  // arm the bypass on the next falling clk
    reg         leave_req;  // drop the bypass on the next falling clk

    assign out = use_clk ? clk : out_reg;
    assign div_q = div;

    wire [W-1:0] limit = high_phase ? high_count : low_count;
    // End of the low phase: the output period in progress is complete.
    wire cycle_end = !use_clk && !leave_req && !high_phase &&
                     (cnt + 1'b1 >= low_count);
    wire apply_pend = pend && cycle_end && !load_div;
    wire [W-1:0] div_for_counts = (!use_clk && leave_req) ? div_pend :
                                  apply_pend ? div_pend : div;
    // Width of the high phase that starts on this edge.  The registered
    // high_count still describes the previous ratio.
    wire [W-1:0] fresh_high = (div_for_counts <= 1) ? 1 :
        div_for_counts[0] ? ((div_for_counts >> 1) + 1'b1) : (div_for_counts >> 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div        <= DIV0[W-1:0];
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
            // Zero is rejected as /1.  A load on the cycle-end edge stays
            // pending; apply_pend ignores load_div so this edge still
            // finishes the old period.
            if (load_div) begin
                div_pend <= (set_div < 1) ? 1 : set_div;
                pend <= 1'b1;
            end else if (apply_pend || (!use_clk && leave_req)) begin
                pend <= 1'b0;
            end

            if (div_for_counts <= 1) begin
                high_count <= 1;
                low_count  <= 1;
            end else if (div_for_counts[0]) begin
                high_count <= (div_for_counts >> 1) + 1'b1;
                low_count  <= div_for_counts >> 1;
            end else begin
                high_count <= div_for_counts >> 1;
                low_count  <= div_for_counts >> 1;
            end

            if (use_clk) begin
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
                cnt <= fresh_high - 1'b1;
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
                cnt <= fresh_high - 1'b1;
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
