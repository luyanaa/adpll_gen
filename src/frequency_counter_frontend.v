// Replaceable DCO frequency-counter frontend.
//
// This block deliberately keeps the counter topology separate from the
// acquisition FSM.  The default is a synchronous binary counter clocked by the
// DCO output.  The alternate modes are explicit experiments, not claims that
// an asynchronous counter is unconditionally safe.
`default_nettype none
`timescale 1ns/1ps

module frequency_counter_frontend #(
    parameter integer CNT_W = 16,
    // 0 = synchronous binary, 1 = asynchronous ripple, 2 = Johnson prescaler
    parameter integer MODE = 0,
    parameter integer PRESCALE = 1,
    parameter integer JOHNSON_STAGES = 4
) (
    input CLK,
    input RST_N,
    output [CNT_W-1:0] COUNT,
    output [CNT_W-1:0] GRAY_COUNT,
    output CDC_SAFE
);
    localparam integer MODE_SYNC = 0;
    localparam integer MODE_RIPPLE = 1;
    localparam integer MODE_JOHNSON = 2;
    localparam integer MODE_STATIC = 3;
    genvar i;

    generate
        if (MODE == MODE_SYNC) begin : sync_frontend
            localparam integer PS = (PRESCALE < 1) ? 1 : PRESCALE;
            reg [CNT_W-1:0] cnt;
            reg [CNT_W-1:0] ps;
            reg [CNT_W-1:0] count_q;
            reg [CNT_W-1:0] gray_q;
            // COUNT is the actual input-edge count, not the prescaled count.
            // This keeps the FCW comparison in freq_lock independent of P.
            wire [CNT_W-1:0] cnt_inc = cnt + 1'b1;
            wire [CNT_W-1:0] ps_inc = ps + 1'b1;
            wire [CNT_W-1:0] count_next = (ps == PS - 1)
                ? cnt_inc * PS
                : cnt * PS + ps_inc;
            always @(posedge CLK or negedge RST_N) begin
                if (!RST_N) begin
                    cnt <= 'd0;
                    ps <= 'd0;
                    count_q <= 'd0;
                    gray_q <= 'd0;
                end else begin
                    if (ps == PS - 1) begin
                        ps <= 'd0;
                        cnt <= cnt_inc;
                    end else begin
                        ps <= ps_inc;
                    end
                    // Register the Gray word in the source clock domain; the
                    // binary-to-Gray XOR must not be left combinational.
                    count_q <= count_next;
                    gray_q <= (count_next >> 1) ^ count_next;
                end
            end
            assign COUNT = count_q;
            assign GRAY_COUNT = gray_q;
            assign CDC_SAFE = 1'b1;
        end else if (MODE == MODE_RIPPLE) begin : ripple_frontend
            // Asynchronous toggle chain.  The multi-bit COUNT/GRAY outputs are
            // not safe to sample directly across a clock domain; CDC_SAFE is
            // deliberately low so the caller must use a Gray/synchronizer or
            // a stable capture window.
            reg [CNT_W-1:0] cnt;
            integer i;
            always @(posedge CLK or negedge RST_N) begin
                if (!RST_N) cnt[0] <= 1'b0;
                else cnt[0] <= ~cnt[0];
            end
            for (i = 1; i < CNT_W; i = i + 1) begin : stages
                always @(posedge cnt[i-1] or negedge RST_N) begin
                    if (!RST_N) cnt[i] <= 1'b0;
                    else cnt[i] <= ~cnt[i];
                end
            end
            assign COUNT = cnt;
            assign GRAY_COUNT = (cnt >> 1) ^ cnt;
            assign CDC_SAFE = 1'b0;
        end else if (MODE == MODE_STATIC) begin : static_frontend
            // True static prescaler: the counter flops are clocked by the
            // divided clock, not by CLK.  GRAY_COUNT is the divided count
            // (one bit per divided edge), so the REF domain must multiply the
            // delta by PRESCALE; COUNT is normalized for debug.
            localparam integer PS = (PRESCALE < 2) ? 2 :
                (PRESCALE > 4) ? 4 : PRESCALE;
            localparam integer PS_SHIFT = (PS == 2) ? 1 : 2;
            localparam integer HALF = PS / 2;
            reg [1:0] div_cnt;
            reg clk_div;
            // cnt is split at the byte boundary: the low byte free-runs on the
            // divided-enable edge and the high byte only increments when the
            // low byte is all ones.  A flat CNT_W-bit increment put the whole
            // ripple in the self-loop and in the Gray chain (SS -0.29 ns on
            // cnt[3] -> cnt_gray[15]).  With PRESCALE 2 or 4 the divided count
            // toggles cnt[0] every enable, so bit 3 is the busiest bit the
            // ripple has to climb out of.
            reg [CNT_W-1:0] cnt;
            reg [CNT_W-1:0] gray_q;
            // Split the carry at the nibble boundary inside the low byte, not
            // only at the byte boundary.  &cnt[7:0] is an 8-input AND tree
            // ahead of the upper-byte increment; cnt[3] -> cnt[15] through it
            // still measured -0.109 ns SS.  A 4-input AND plus one carry-in is
            // the shallowest increment this counter can offer.
            wire        cnt_ln_wrap = &cnt[3:0];
            wire        cnt_hn_wrap = &cnt[11:8];
            // Every nibble pre-decodes its own +1 with at most a 4-bit carry.
            // Writing the whole vector as cascaded adds keeps a serial carry
            // alive inside the byte adders (cnt[1] -> cnt[15] was -0.29 SS);
            // per-nibble sums selected by the lower wrap flags cap the cone.
            wire [3:0]  n0_inc = cnt[3:0]   + 4'b0001;
            wire [3:0]  n1_inc = cnt[7:4]   + 4'b0001;
            wire [3:0]  n2_inc = cnt[11:8]  + 4'b0001;
            wire [3:0]  n3_inc = cnt[15:12] + 4'b0001;
            if (PS == 2) begin : div2
                // div_cnt is always 0 at HALF=1; toggling clk_div on every
                // input edge is the whole prescaler.  Keeping div_cnt in the
                // netlist only added a dead 2-bit compare in front of cnt_en.
                always @(posedge CLK or negedge RST_N) begin
                    if (!RST_N) clk_div <= 1'b0;
                    else        clk_div <= ~clk_div;
                end
            end else begin : div4
                // PS == 4 (clamped): one clk_div toggle per two input edges.
                always @(posedge CLK or negedge RST_N) begin
                    if (!RST_N) begin
                        div_cnt <= 2'd0;
                        clk_div <= 1'b0;
                    end else if (div_cnt == HALF - 1) begin
                        div_cnt <= 2'd0;
                        clk_div <= ~clk_div;
                    end else begin
                        div_cnt <= div_cnt + 1'b1;
                    end
                end
            end
            // 计数寄存器的时钟统一用 CLK，改由使能脉冲控制递增。
            // 原写法 `always @(posedge clk_div)` 把寄存器输出当时钟，CTS 会为
            // 负载侧再造一棵树并把根留成悬空网（实测 ..._clk_div_regs 全
            // netlist 无驱动源），导致这 33 个寄存器在签核时根本没有被计时。
            //
            // 2026-11-24 (MID_OUT domain fix): restore the divided clock.
            // The enable-based structure above was a workaround for CTS not
            // recognising clk_div; it left cnt/gray_q clocked by the raw
            // 0.34-0.76 GHz MID_OUT ring, whose real period (1.31 ns FF,
            // 2.94 ns SS from the corrected gate sweep) is what the MID_OUT
            // constraint must use.  The counter increments once per two
            // MID_OUT edges, so clocking the flops from clk_div gives them a
            // full /2 period instead of a single ring period.  The clk_div
            // register is now declared as the FE_CLK_DIV generated clock in
            // constraints/adpll.sdc, which is what keeps CTS from leaving its
            // root undriven (the failure that motivated the enable workaround).
            //
            // Keep the B12 nibble pre-decode/carry split: it caps the
            // counter's own carry cone and is independent of the clocking.
            // The former cnt_en_q/cnt_hi_en_q registers are no longer needed
            // because there is no full-rate enable mux to drive; the -0.59 ns
            // clk_div -> enable cone they fixed does not exist on this
            // structure.  Do not reintroduce a full-rate CLK here.
            wire       cnt_lo_wrap = &cnt[7:0];
            always @(posedge clk_div or negedge RST_N) begin
                if (!RST_N) begin
                    cnt    <= 'd0;
                    gray_q <= 'd0;
                end else begin
                    gray_q <= cnt ^ (cnt >> 1);
                    cnt[7:0] <= {cnt_ln_wrap ? n1_inc : cnt[7:4],
                                 n0_inc};
                    cnt[CNT_W-1:8] <= cnt_lo_wrap ?
                        {cnt_hn_wrap ? n3_inc : cnt[15:12],
                         n2_inc}
                                      : cnt[CNT_W-1:8];
                end
            end
            assign COUNT = cnt << PS_SHIFT;
            assign GRAY_COUNT = gray_q;
            assign CDC_SAFE = 1'b1;
        end else if (MODE == MODE_JOHNSON) begin : johnson_frontend
            // 4-stage Johnson prescaler (divide by 8) plus a synchronous
            // extension counter.  The phase decode is intentionally explicit:
            // do not assume the Johnson state is a binary code.
            localparam integer DIV = 2 * JOHNSON_STAGES;
            reg [JOHNSON_STAGES-1:0] john;
            reg [CNT_W-1:0] ext;
            reg [2:0] phase;
            // Johnson state 000...0 is the wrap/terminal state.  The old
            // terminal used the MSB, which is high for half of the state
            // sequence and therefore incremented ext by JOHNSON_STAGES/2 per
            // Johnson cycle instead of once.
            wire terminal = (john == {JOHNSON_STAGES{1'b0}});
            always @(posedge CLK or negedge RST_N) begin
                if (!RST_N) begin
                    john <= {{(JOHNSON_STAGES-1){1'b0}}, 1'b1};
                    ext <= 'd0;
                end else begin
                    john <= {john[JOHNSON_STAGES-2:0], ~john[JOHNSON_STAGES-1]};
                    if (terminal) ext <= ext + 1'b1;
                end
            end
            always @* begin
                case (john)
                    4'b0001: phase = 3'd0;
                    4'b0011: phase = 3'd1;
                    4'b0111: phase = 3'd2;
                    4'b1111: phase = 3'd3;
                    4'b1110: phase = 3'd4;
                    4'b1100: phase = 3'd5;
                    4'b1000: phase = 3'd6;
                    4'b0000: phase = 3'd7;
                    default: phase = 3'd0;
                endcase
            end
            assign COUNT = ext * DIV + phase;
            assign GRAY_COUNT = (COUNT >> 1) ^ COUNT;
            // The Johnson decode is a multi-bit synchronous state, but the
            // extension counter and phase are sampled in the DCO domain.  It is
            // not a CDC-safe replacement without a stable capture protocol.
            assign CDC_SAFE = 1'b0;
        end else begin : unsupported_frontend
            assign COUNT = 'd0;
            assign GRAY_COUNT = 'd0;
            assign CDC_SAFE = 1'b0;
        end
    endgenerate
endmodule
`default_nettype wire
