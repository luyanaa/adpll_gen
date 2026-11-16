`timescale 1ps/1ps
// Route B: full-period DLL with a startup absolute-range detector, an
// edge-time phase detector and a valid-edge phase window.
//
// Delay line: 4-segment bypass + 56 fine taps (the ics55 STA structure):
//   delay(code) = T0 + code * STEP,  code = coarse*56 + fine, 0..279
// Each tap is a transport-delayed copy of the line input; changing CODE
// selects a tap and does not re-time an already scheduled event.  The code is
// only committed in the low phase of the measurement clock (safe window).
//
// Startup range detector: the line is driven by REF/16 (80 ns) so one edge is
// in flight at a time and the absolute delay can be measured with a
// free-running TICK counter.  A binary search over the code finds the tap
// whose measured delay is ~1 REF period.  0T/0.5T/2T have absolute delays of
// ~0/~T/2, so they cannot pass the check even though their phase modulo T is
// the same as 1T.
//
// Tracking: REF-to-OUT delay in TICK counts modulo one period; > half period
// is early, < half period is late.  PHASE_OK counts consecutive REF windows
// with a valid OUT edge and |delay - period| within PHASE_EPS.
//
// LOCKED = RANGE_OK & PHASE_OK & !CODE_RAILED & ALIVE.
module DLL_FULL_PERIOD_TOP #(
    parameter integer TAPS = 280,
    parameter integer CODE_BITS = 9,
    parameter integer T0_PS = 2930,
    parameter integer STEP_PS = 35,
    parameter integer CODE_MIN = 45,
    parameter integer CODE_MAX = 116,
    parameter integer PERIOD_TICKS = 50,  // fallback; measured at startup
    parameter integer ACQ_EPS = 4,
    parameter integer PHASE_EPS = 1,
    parameter integer LOCK_COUNT = 16
) (
    input  wire                  REF,
    input  wire                  RST_N,
    input  wire                  EN,
    input  wire                  TICK,
    input  wire [CODE_BITS-1:0]  CODE_START,
    output wire                  OUT,
    output wire                  LOCKED,
    output wire                  PHASE_OK,
    output wire                  RANGE_OK,
    output wire                  CODE_RAILED,
    output wire                  ALIVE,
    output wire [CODE_BITS-1:0]  CODE,
    output wire                  PFD_UP,
    output wire                  PFD_DN,
    output wire                  ACQ_BUSY,
    output wire                  ACQ_OK,
    output wire                  ACQ_FAIL
);
    // ---------------------------------------------------------------- line
    // ACQ: line driven by REF/16, with an unarmed flush window.
    // CODE is committed at div==4, after the previous delayed falling edge
    // and before the next rising edge, so the mux never re-times an edge.
    reg        acq_mode;
    reg        acq_armed;
    reg  [3:0] div;
    wire       acq_clk = div[3];
    wire       line_in = acq_mode ? (acq_armed ? acq_clk : 1'b0) : REF;

    reg [TAPS-1:0] tap_r;
    genvar g;
    generate
        for (g = 0; g < TAPS; g = g + 1) begin : taps
            always @(line_in) tap_r[g] <= #(T0_PS + g * STEP_PS) line_in;
        end
    endgenerate

    reg [CODE_BITS-1:0] code;
    assign CODE = code;
    wire [CODE_BITS-1:0] sel = (code >= TAPS) ? (TAPS - 1) : code;
    assign OUT = tap_r[sel];

    // ------------------------------------------------- absolute time base
    reg [15:0] tcnt;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) tcnt <= 16'd0;
        else        tcnt <= tcnt + 1'b1;
    end

    reg [15:0] t_ref, t_out;
    reg        acq_seen;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) begin
            t_out    <= 16'd0;
            acq_seen <= 1'b0;
        end else if (acq_mode && acq_armed && !acq_seen) begin
            t_out    <= tcnt;
            acq_seen <= 1'b1;
        end
    end
    wire [15:0] acq_delay = t_out - t_ref;

    // ------------------------------------------------- tracking phase TDC
    reg [7:0] cnt;
    reg [7:0] delay_ticks;
    reg       out_seen;
    always @(posedge TICK or negedge RST_N) begin
        if (!RST_N) cnt <= 8'd0;
        else        cnt <= cnt + 1'b1;
    end
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) begin
            delay_ticks <= 8'd0;
            out_seen    <= 1'b0;
        end else if (!acq_mode) begin
            delay_ticks <= cnt;
            out_seen    <= 1'b1;
        end
    end

    // ---------------------------------------------------------- liveness
    reg [7:0] out_edges, out_edges_q;
    reg [2:0] alive_miss;
    always @(posedge OUT or negedge RST_N) begin
        if (!RST_N) out_edges <= 8'd0;
        else        out_edges <= out_edges + 1'b1;
    end
    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            out_edges_q <= 8'd0;
            alive_miss  <= 3'd0;
        end else begin
            out_edges_q <= out_edges;
            if (out_edges == out_edges_q) begin
                if (alive_miss < 3'd4) alive_miss <= alive_miss + 1'b1;
            end else begin
                alive_miss <= 3'd0;
            end
        end
    end
    assign ALIVE = (alive_miss < 3'd4);

    // ------------------------------------------------------ lock terms
    reg        acq_ok, acq_fail, acq_busy;
    reg  [3:0] flush;
    reg [CODE_BITS-1:0] lo, hi;
    reg  [7:0] phase_good;
    reg        phase_ok_r;
    // Measured REF period in TICK counts.  The acquisition target is one
    // period of the actual input, not a hardcoded 5 ns.
    reg [15:0] t_p0, period_ticks;
    reg [1:0]  per_state;
    wire [7:0] per8 = period_ticks[7:0];

    assign ACQ_BUSY  = acq_busy;
    assign ACQ_OK    = acq_ok;
    assign ACQ_FAIL  = acq_fail;
    assign RANGE_OK  = acq_ok && (code >= CODE_MIN) && (code <= CODE_MAX);
    assign CODE_RAILED = (code == 0) || (code == TAPS - 1);

    always @(posedge REF or negedge RST_N) begin
        if (!RST_N) begin
            div <= 4'd0; acq_mode <= 1'b0; acq_armed <= 1'b0; flush <= 4'd0;
            acq_ok <= 1'b0; acq_fail <= 1'b0; acq_busy <= 1'b0;
            acq_seen <= 1'b0; code <= CODE_START; lo <= CODE_MIN; hi <= CODE_MAX;
            t_ref <= 16'd0; cnt <= 8'd0; out_seen <= 1'b0;
            phase_good <= 8'd0; phase_ok_r <= 1'b0;
            period_ticks <= PERIOD_TICKS; t_p0 <= 16'd0; per_state <= 2'd0;
        end else if (!EN) begin
            div <= 4'd0; acq_mode <= 1'b0; acq_armed <= 1'b0; flush <= 4'd0;
            acq_ok <= 1'b0; acq_fail <= 1'b0; acq_busy <= 1'b0;
            acq_seen <= 1'b0; code <= CODE_START; lo <= CODE_MIN; hi <= CODE_MAX;
            t_ref <= 16'd0; cnt <= 8'd0; out_seen <= 1'b0;
            phase_good <= 8'd0; phase_ok_r <= 1'b0;
            period_ticks <= PERIOD_TICKS; t_p0 <= 16'd0; per_state <= 2'd0;
        end else begin
            div <= div + 1'b1;

            if (!acq_mode) begin
                if (acq_ok) begin
                    // ------------------------------------- tracking
                    if (out_seen) begin
                        if ((delay_ticks <= per8) &&
                            (delay_ticks > PHASE_EPS) &&
                            (delay_ticks < per8 / 2) &&
                            (code > CODE_MIN))
                            code <= code - 1'b1;          // output late
                        else if ((delay_ticks <= per8) &&
                                 (delay_ticks >= per8 / 2) &&
                                 (delay_ticks < per8 - PHASE_EPS) &&
                                 (code < CODE_MAX))
                            code <= code + 1'b1;          // output early

                        if (RANGE_OK && !CODE_RAILED &&
                            (delay_ticks <= per8) &&
                            ((delay_ticks <= PHASE_EPS) ||
                             (delay_ticks >= per8 - PHASE_EPS))) begin
                            if (phase_good < LOCK_COUNT[7:0])
                                phase_good <= phase_good + 1'b1;
                            if (phase_good + 1 >= LOCK_COUNT[7:0])
                                phase_ok_r <= 1'b1;
                        end else begin
                            phase_good <= 8'd0;
                            phase_ok_r <= 1'b0;
                        end
                    end else begin
                        // no valid OUT edge in this REF window
                        phase_good <= 8'd0;
                        phase_ok_r <= 1'b0;
                    end
                    cnt <= 8'd0;
                    out_seen <= 1'b0;
                end else if (!acq_fail) begin
                    // start acquisition; flush the line for 8 REF cycles
                    acq_mode  <= 1'b1;
                    acq_armed <= 1'b0;
                    flush     <= 4'd0;
                    acq_busy  <= 1'b1;
                    lo        <= CODE_MIN;
                    hi        <= CODE_MAX;
                    code      <= (CODE_MIN + CODE_MAX) >> 1;
                    t_p0      <= tcnt;
                    per_state <= 2'd1;
                end
            end else if (!acq_armed) begin
                // Measure the actual REF period once, in TICK counts.
                if (per_state == 2'd1) begin
                    period_ticks <= tcnt - t_p0;
                    per_state    <= 2'd2;
                end
                if (flush < 4'd8) flush <= flush + 1'b1;
                else if (!acq_clk) acq_armed <= 1'b1;
            end else begin
                // ----------------------------- absolute range acquisition
                // Process at div==4: the previous delayed falling edge has
                // passed, the line is low, and the next rising edge is 20 ns
                // away.  Commit the new code here (safe mux window).
                if (div == 4'd4 && acq_seen) begin
                    acq_seen <= 1'b0;
                    if (acq_delay < period_ticks) begin
                        if (code >= hi) begin
                            if (acq_delay + ACQ_EPS >= period_ticks)
                                acq_ok <= 1'b1;
                            else
                                acq_fail <= 1'b1;
                            acq_busy <= 1'b0;
                        end else begin
                            lo   <= code + 1'b1;
                            // keep the midpoint arithmetic inside CODE_BITS:
                            // (code + hi + 1) can overflow 9 bits at 280+279
                            code <= code + ((hi - code + 1'b1) >> 1);
                        end
                    end else begin
                        if (code <= lo) begin
                            if (acq_delay <= period_ticks + ACQ_EPS)
                                acq_ok <= 1'b1;
                            else
                                acq_fail <= 1'b1;
                            acq_busy <= 1'b0;
                        end else begin
                            hi   <= code - 1'b1;
                            code <= lo + ((code - lo) >> 1);
                        end
                    end
                end
                // Start one measurement per REF/16 period.
                if (div == 4'd7) begin
                    t_ref    <= tcnt;
                    acq_seen <= 1'b0;
                end
                // Leave acquisition at the falling edge of the measurement
                // clock, while both acq_clk and REF are high (no runt).
                if ((acq_ok || acq_fail) && div == 4'd15)
                    acq_mode <= 1'b0;
            end
        end
    end

    assign PHASE_OK = phase_ok_r;
    assign LOCKED   = PHASE_OK && RANGE_OK && !CODE_RAILED && ALIVE;

    assign PFD_UP = !acq_mode && out_seen && (delay_ticks > PHASE_EPS) &&
                    (delay_ticks < per8 / 2);
    assign PFD_DN = !acq_mode && out_seen && (delay_ticks >= per8 / 2) &&
                    (delay_ticks < per8 - PHASE_EPS);
endmodule
