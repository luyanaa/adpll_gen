// Clock-alive watchdog.
//
// Counts edges of clk_count.  clk_watch must toggle at least once every
// TIMEOUT of those edges.  The lock FSM and the phase detector are clocked
// by INJ_EDGE, which is derived from REF, so a stopped REF cannot clear
// LOCKED by itself.  This counter runs on the free-running DCO and watches
// REF.
//
// enable holds the watchdog healthy while it is disarmed.  TIMEOUT is in
// DCO cycles and must sit above the legal FCW: one REF edge is expected
// every FCW DCO cycles while the loop is in range.
`timescale 1fs/1fs

module pll_ref_watchdog #(
    parameter integer TIMEOUT = 512
) (
    input  wire clk_count,
    input  wire clk_watch,
    input  wire enable,
    input  wire rst_n,
    output reg  alive
);
    localparam integer W = (TIMEOUT < 2) ? 1 : $clog2(TIMEOUT + 1);
    reg [W-1:0] cnt;
    reg watch_q;
    wire watched_edge = clk_watch ^ watch_q;

    always @(posedge clk_count or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 'd0;
            watch_q <= 1'b0;
            // Disarmed at reset.  A 0 here would stick in the lock sticky
            // before enable is allowed to rise.
            alive <= 1'b1;
        end else begin
            watch_q <= clk_watch;
            if (!enable) begin
                cnt <= 'd0;
                alive <= 1'b1;
            end else if (watched_edge) begin
                cnt <= 'd0;
                alive <= 1'b1;
            end else if (cnt >= TIMEOUT) begin
                alive <= 1'b0;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end
endmodule
