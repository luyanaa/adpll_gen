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
    input  wire             rst_n,     // active low reset (posedge-domain flops)
    // Second reset port, an identical copy of rst_n produced by a separate
    // register in pll_logic.  The odd-path staging registers
    // (hi/lo_pend_q, div_pend_*_q, div_m1_pend_q, div_m1, odd_*_q) sit on it
    // so each reset net feeds roughly half the async-clear fanout -- a
    // single net left the deassert past the recovery window (-0.29 ns SS).
    input  wire             rst_n2,
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
    // Phase widths are stored as LAST indices (width-1), not widths.  The
    // reload compare then reads `cnt == high_last`, an equality tree, instead
    // of `cnt + 1 >= limit` -- the subtract-and-compare was the deep cone
    // behind every cnt[0] -> div/out_reg SS violator.  The decrement is paid
    // once per ratio change, inside half_hi/half_lo, on a full-period path.
    reg [W-1:0] high_last, low_last;  // on rst_n2
    // Zero flags for high_last/low_last so phase_last_q's boundary arm reads
    // a flop instead of an 8-input NOR tree behind the high_phase mux.
    reg         hi_last_z, lo_last_z;   // on rst_n2
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
    // out selects the registered odd flag, not the live `odd_div` decode.
    // odd_div = div[0] && (div>1) put an 8-input equality in front of this
    // mux; out feeds the DSM ICG enable, where the path is a half-OUT-period
    // clock-gating check (div[3] -> u_dsm_icg E was -0.26 ns SS).  odd_div_q
    // is loaded at the same commit edge div changes, so it is valid exactly
    // when p_hi/n_hi start producing the new ratio's pulse -- one OUT edge
    // after the commit, which is also when this mux first needs it.
    assign out = use_clk ? clk : (odd_div_q ? odd_out : out_reg);
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

    wire [W-1:0] pcnt_inc = pcnt + 1'b1;
    always @(posedge clk or negedge rst_n2) begin
        if (!rst_n2)     pcnt <= 'd0;
        else if (odd_div_q) pcnt <= (pcnt == div_m1) ? 'd0 : pcnt_inc;
        else             pcnt <= 'd0;
    end
    // The posedge copies below exist for the negedge half of the odd path.
    // Feeding `div` straight into the negedge logic put an 8-bit compare, an
    // 8-bit increment and the `odd_div` decode inside half an OUT period
    // (-0.66 ns SS on ncnt[0] -> n_hi, plus div[4]/div[5] -> ncnt and the two
    // gated-clock endpoints).  Stage the div-derived terms once on posedge --
    // same edge and same div sample as div_m1, so the three describe one
    // divisor -- and re-time them into the negedge domain.  A posedge flop ->
    // negedge flop hop is still half a period, but with nothing between the
    // pins it is trivial.
    // The div-derived terms decode from hi_pend_q/lo_pend_q at the commit
    // edge, not from div every cycle: div only moves when a ratio commits,
    // and re-decoding (div-1), (div>1), (div-1)>>1 against the live div left
    // an 8-bit borrow chain on the posedge path (div[5] -> odd_k_q/div_m1
    // was -0.68/-0.64 ns SS).  On the commit edge div_pend is the new div
    // and hi/lo_pend_q already hold its half-decodes:
    //   odd_k  = (div-1)>>1 = half_hi(div)      for odd div
    //   div_m1 = div-1      = hi_pend + lo_pend + 1
    // so the commit edge loads them out of registers, one adder for div_m1.
    // The write enable for the div-derived registers is a registered copy of
    // the commit edge, one OUT edge late.  phase_last drives every commit mux
    // already (div, high_last/low_last, pend, cnt, out_reg, high_phase);
    // adding the odd-path registers to that fanout left phase_last -> div_m1
    // at -0.12 ns SS.  Loading one edge later is safe: pcnt/ncnt begin the
    // new ratio the edge after the commit, which is when these registers
    // turn over, and the duty bench measures the settled waveform.
    reg         commit_edge_q;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) commit_edge_q <= 1'b0;
        else        commit_edge_q <= apply_pend || (leave_req && !use_clk_p);
    end
    reg [W-1:0] div_m1;
    reg         odd_div_q;
    reg [W-1:0] odd_k_q;
    always @(posedge clk or negedge rst_n2) begin
        if (!rst_n2) begin
            div_m1    <= (DIV0 > 0) ? DIV0 - 1 : 0;
            odd_div_q <= (DIV0 > 1) && (DIV0 % 2 != 0);
            odd_k_q   <= (DIV0 <= 1) ? 'd0 : ((DIV0 - 1) >> 1);
        end else if (commit_edge_q) begin
            div_m1    <= div_m1_pend_q;
            odd_div_q <= div_pend[0] && div_pend_gt1_q;
            odd_k_q   <= hi_pend_q;
        end
    end
    // The negedge domain releases reset on its own edge.  rst_n is produced
    // by a posedge register (pll_logic.div_rst_n), so the raw input reaches
    // the negedge flops half an OUT cycle after the posedge release --
    // asynchronous to this domain and an 8-line recovery violation at
    // -0.02 ns.  rst_n_n re-times the deassert onto negedge; the assert is
    // still asynchronous because rst_n_n itself is reset by rst_n.
    reg rst_n_n;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) rst_n_n <= 1'b0;
        else        rst_n_n <= 1'b1;
    end
    reg         odd_div_n;
    reg [W-1:0] div_m1_n;
    reg [W-1:0] odd_k_n;
    always @(negedge clk or negedge rst_n_n) begin
        if (!rst_n_n) begin
            odd_div_n <= (DIV0 > 1) && (DIV0 % 2 != 0);
            div_m1_n  <= (DIV0 > 0) ? DIV0 - 1 : 0;
            odd_k_n   <= (DIV0 <= 1) ? 'd0 : ((DIV0 - 1) >> 1);
        end else begin
            odd_div_n <= odd_div_q;
            div_m1_n  <= div_m1;
            odd_k_n   <= odd_k_q;
        end
    end

    // ncnt must stay on the negative edge -- it is half of what makes an odd
    // divisor 50 % -- so its next-state cone only has half an OUT period.
    // ncnt_lt_k registers "the ncnt value in force on the next rising edge is
    // below the pulse width" on the falling edge itself, where it has a full
    // period.  n_hi then reads a registered bit in its half cycle instead of
    // the `ncnt < odd_k` magnitude compare.  After a wrap the next ncnt is 0,
    // which is below odd_k for every odd divisor (div >= 3 -> odd_k >= 1), so
    // the wrap arm is a constant 1.
    wire         ncnt_wrap = (ncnt == div_m1_n);
    wire [W-1:0] ncnt_inc  = ncnt + 1'b1;
    reg          ncnt_lt_k;
    always @(negedge clk or negedge rst_n_n) begin
        if (!rst_n_n) begin
            ncnt      <= 'd0;
            ncnt_lt_k <= 1'b0;
        end else if (odd_div_n) begin
            ncnt      <= ncnt_wrap ? 'd0 : ncnt_inc;
            ncnt_lt_k <= ncnt_wrap | (ncnt_inc < odd_k_n);
        end else begin
            ncnt      <= 'd0;
            ncnt_lt_k <= 1'b0;
        end
    end

    // Pulse high while the counter is below the half width.  Registered on the
    // opposite edge so the OR has no glitch.  p_hi reads the registered
    // odd_div_q/odd_k_q copies: live `odd_div`/`odd_k` put the (div>1) and
    // (div-1)>>1 decode on this D input -- div[0] -> p_hi was the worst
    // remaining SS OUT path (-0.172 ns).  The copies lag div by one edge,
    // which is fine: they are consumed exactly the same number of edges after
    // div as pcnt itself is.
    reg p_hi, n_hi;
    always @(posedge clk or negedge rst_n2)
        if (!rst_n2) p_hi <= 1'b0; else p_hi <= odd_div_q && (pcnt < odd_k_q);
    always @(posedge clk or negedge rst_n)
        if (!rst_n) n_hi <= 1'b0; else n_hi <= odd_div_n && ncnt_lt_k;

    wire odd_out = odd_div_q && (p_hi | n_hi);

    // cnt is a DOWN counter: each phase loads it with that phase's
    // last-index (width-1) and the phase ends when it reaches zero.  The
    // boundary test `~|cnt` is a single reduction tree and does not consult
    // high_last/low_last at all -- the previous `cnt == limit_last` equality
    // carried an 8-bit XOR tree plus the high/low select mux through every
    // consumer of cycle_end/apply_pend, which is what put the
    // cnt[0] -> low_last/high_last/div[*] cluster at -0.10 ns SS.  The
    // registers are now only read to reload cnt at the boundary.
    //
    // The decrement keeps the nibble split: cnt[3:0] free-runs and the high
    // part borrows only when the low nibble is zero, so the borrow chain is
    // 4 bits, not W.
    wire        cnt_nib_borrow = ~|cnt[3:0];
    wire [W-1:0] cnt_dec = {cnt[W-1:4] - {{(W-5){1'b0}}, cnt_nib_borrow},
                             cnt[3:0] - 4'b0001};
    // phase_last must reach apply_pend's NAND4 with nothing between the flop
    // and the gate.  Combinational ~|cnt -- even hand-balanced -- keeps being
    // re-serialised by techmap into a chain whose head bit pays six NOR
    // stages (-0.60/-0.58 ns SS on cnt[0] -> low_last/div).  Register the
    // boundary one count early instead: phase_last_q is set the edge BEFORE
    // cnt reaches zero, i.e. when the decrement result is the terminal
    // count.  On the commit edges below cnt reloads to a last-index, which
    // is nonzero for every divisor >= 1, so the register clears itself.
    reg          phase_last_q;
    wire         phase_last    = phase_last_q;
    // Terminal when cnt is already zero (reset start, a zero last-index
    // load) OR when the decrement in flight is the one that reaches zero.
    // Without the cnt==0 half, a phase whose last-index is 0 would reload
    // cnt to 0, drop the flag, and let cnt wrap through 255 before the
    // boundary is seen again.
    wire         dec_is_last = ~|cnt | (~(|cnt_dec[W-1:4]) & ~(|cnt_dec[3:0]));
    // End of the low phase with a new ratio waiting.  !use_clk_p is left
    // out: use_clk_p only distinguishes the first edge after the bypass
    // select drops, and on that edge leave_req is still set -- the
    // !leave_req term already covers it.  Every remaining term is a register
    // output, written as one expression so the mapper builds a single
    // NOR/NAND tree for the qualifier instead of cascading a cycle_end AND
    // and a pend AND back to back.
    wire apply_pend = phase_last && !high_phase && !leave_req &&
                      pend && !load_div;


    // div_pend is latched at load_div and stays until the ratio commits, so
    // its half-decode can run a full period early.  Commit edges then read
    // the registered values instead of the (d>>1)-1 chain.  These only move
    // when div_pend does, once per SET_DIV.
    reg [W-1:0] hi_pend_q, lo_pend_q;
    // The /1 commit arm reads `div_pend == 1` inside apply_pend's cone: an
    // 8-input equality in series with the five-term commit AND, which left
    // div_pend[7] -> high_phase/out_reg at -0.08 ns SS.  div_pend only moves
    // on load_div, so the test is registered at load time instead.
    reg         div_pend_is1_q;
    reg         div_pend_gt1_q;
    // Zero flags for the half-decode last-indices, registered alongside them
    // so phase_last_q's reload arm reads a flop instead of an 8-input NOR in
    // series with high_phase's mux (phase_last -> phase_last was -0.14 SS).
    reg         hi_pend_z, lo_pend_z;
    // div_m1 = hi_pend + lo_pend + 1.  Computing it on the commit_edge_q
    // enable left an 8-bit carry in front of a reg->reg window
    // (hi_pend_q[2] -> div_m1 was -0.18 ns SS).  The operands are settled
    // from load_div on, so the sum is registered at load time alongside the
    // half decodes and commit_edge_q only has to select it.
    reg [W-1:0] div_m1_pend_q;
    always @(posedge clk or negedge rst_n2) begin
        if (!rst_n2) begin
            hi_pend_q <= (DIV0_HIGH - 1);
            lo_pend_q <= (DIV0_LOW - 1);
            div_pend <= DIV0[W-1:0];
            div_pend_is1_q <= (DIV0 == 1);
            div_pend_gt1_q <= (DIV0 > 1);
            div_m1_pend_q <= (DIV0 > 0) ? DIV0 - 1 : 0;
            hi_pend_z <= ~|(DIV0_HIGH - 1);
            lo_pend_z <= ~|(DIV0_LOW - 1);
        end else if (load_div) begin
            hi_pend_q <= half_hi((set_div < 1) ? 1 : set_div);
            lo_pend_q <= half_lo((set_div < 1) ? 1 : set_div);
            div_pend <= (set_div < 1) ? 1 : set_div;
            div_pend_is1_q <= ((set_div < 1) ? 1 : set_div) == 1;
            div_pend_gt1_q <= ((set_div < 1) ? 1 : set_div) > 1;
            div_m1_pend_q <= half_hi((set_div < 1) ? 1 : set_div) +
                             half_lo((set_div < 1) ? 1 : set_div) + 1'b1;
            hi_pend_z <= ~|half_hi((set_div < 1) ? 1 : set_div);
            lo_pend_z <= ~|half_lo((set_div < 1) ? 1 : set_div);
        end
    end

    // high_last/low_last are the running phase boundaries.  They must turn
    // over on the commit edge itself -- a last-index of 0 means the edge
    // right after the commit is already a phase boundary, so a one-edge-late
    // load leaves that boundary reading the stale index (divider_tb FATAL
    // when tried on commit_edge_q).  They sit on rst_n2 with the other
    // staging registers so the primary rst_n net's async-clear fanout stays
    // low enough for the recovery check (rst_n -> hi/lo_last was -0.04 SS).
    always @(posedge clk or negedge rst_n2) begin
        if (!rst_n2) begin
            // Down-count reload values are last-indices; cnt itself resets
            // to 0, which starts a fresh low phase of DIV0_LOW clocks once
            // the reset phase_last edge flips it high.
            high_last <= (DIV0_HIGH - 1);
            low_last  <= (DIV0_LOW - 1);
            hi_last_z <= ~|(DIV0_HIGH - 1);
            lo_last_z <= ~|(DIV0_LOW - 1);
        end else if (leave_req && !use_clk_p) begin
            high_last <= hi_pend_q;
            low_last  <= lo_pend_q;
            hi_last_z <= hi_pend_z;
            lo_last_z <= lo_pend_z;
        end else if (apply_pend) begin
            high_last <= hi_pend_q;
            low_last  <= lo_pend_q;
            hi_last_z <= hi_pend_z;
            lo_last_z <= lo_pend_z;
        end
    end

    // Pre-decode both candidate divisors concurrently, then pick one.  The
    // candidates are the running `div` and the pending `div_pend`; both are
    // registered and stable well before the select resolves.  The functions
    // return the LAST phase index (width-1): phase_last compares with
    // equality, so the only adder is this one decrement, evaluated once per
    // div/div_pend change on a full-period path.
    function [W-1:0] half_hi;
        input [W-1:0] d;
        begin
            if (d <= 1)          half_hi = 'd0;
            else if (d[0])       half_hi = d >> 1;
            else                 half_hi = (d >> 1) - 1'b1;
        end
    endfunction
    function [W-1:0] half_lo;
        input [W-1:0] d;
        begin
            if (d <= 1)          half_lo = 'd0;
            else                 half_lo = (d >> 1) - 1'b1;
        end
    endfunction
    // The only edges that need new phase widths are the ones that commit a
    // new ratio (leave_req / apply_pend).  On those edges the committed
    // divisor is always div_pend, whose half-decode is registered once here
    // at load time.  Committing then selects between two registered values --
    // hi_pend_q/lo_pend_q versus the running high_last/low_last -- so the
    // `(d >> 1) - 1` borrow chain never lands inside the commit edge, and
    // between commits both registers simply hold.  An earlier version decoded
    // half_*(div_pend) directly at the commit edge; the borrow chain plus the
    // use_clk_p commit qualifier made use_clk_p -> high_last/low_last the
    // densest SS cluster (-0.43 to -0.36).

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div        <= DIV0[W-1:0];
            even_q     <= (DIV0 >= 2) && !DIV0[0];
            cnt        <= 'd0;
            out_reg    <= 1'b0;
            high_phase <= 1'b0;
            pend       <= 1'b0;
            enter_req  <= 1'b0;
            leave_req  <= 1'b0;
            phase_last_q <= 1'b0;
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
            // The DDR qualification is committed with the ratio: at the
            // commit edge div_pend is the new divisor and div_pend_gt1_q
            // already holds its >1 test, so even_q needs no live decode.
            // Between commits div is static and even_q holds.
            if (commit_edge_q)
                even_q <= div_pend_gt1_q && !div_pend[0];

            // One-count-early terminal flag.  dec_is_last is true on the
            // edge before a free-running cnt reaches zero.  Reload edges
            // (phase boundary, ratio commit) cannot rely on that -- a phase
            // whose last-index is 0 (e.g. div=2) loads cnt straight to the
            // terminal count and never passes through 1 -- so each reload
            // arm sets the flag from the loaded value instead.  During
            // bypass the flag is held low; the commit arms qualify their own
            // conditions and never consult it.
            // phase_last is the high-fanout term; it sits at the SECOND
            // priority here (was fifth, behind use_clk_p/leave_req/two
            // apply_pend arms, which put a 4-deep priority mux on the
            // phase_last -> phase_last_q self-loop at -0.078 ns SS).  The
            // commit arms still precede it because a commit edge is itself
            // a phase_last edge whose loaded value must win.  use_clk_p can
            // drop to the bottom: while bypass is active cnt is held at its
            // terminal count, so phase_last is 0 and the dec_is_last arm can
            // never fire a real boundary -- the use_clk_p arm only has to
            // beat dec_is_last, not the reload.
            if (leave_req || apply_pend)
                phase_last_q <= (apply_pend && div_pend_is1_q) ? 1'b0
                                                             : hi_pend_z;
            else if (phase_last)
                phase_last_q <= high_phase ? lo_last_z : hi_last_z;
            else if (use_clk_p)
                phase_last_q <= 1'b0;
            else
                phase_last_q <= dec_is_last;

            if (load_div)
                pend <= 1'b1;
            else if (apply_pend || (!use_clk_p && leave_req))
                pend <= 1'b0;

            // Commit edges take the ratio's pre-decoded last-indices; every
            // other edge leaves the registers at the running divisor's
            // values.  The decode lives one edge ahead in hi_pend_q/lo_pend_q
            // (below), so the commit mux is one gate deep.  These must load
            // on the commit edge itself -- a last-index of 0 makes the edge
            // right after the commit already a phase boundary, and a
            // one-edge-late load (commit_edge_q, tried and reverted) leaves
            // the boundary reading the stale index (divider_tb FATAL).


            if (leave_req && !use_clk_p && !use_clk) begin
                // use_clk fell on the previous negedge, while clk was low.
                // That falling edge is the end of the /1 low half.  out_reg
                // only commits on this edge, so the first high of the new
                // ratio starts on the NEXT posedge -- which is the down
                // count's first tick.  cnt loads the new ratio's high
                // last-index from the same pre-decoded pair that high_last
                // commits on this edge (hi_pend_q, read before the
                // nonblocking update above lands).  This arm must precede
                // use_clk_p because use_clk_p still reads the just-dropped 1
                // on this edge.
                div <= div_pend;
                leave_req <= 1'b0;
                cnt <= hi_pend_q;
                out_reg <= 1'b1;
                high_phase <= 1'b1;
            end else if (use_clk_p) begin
                // Bypass.  Hold the counter at its terminal count so leaving
                // bypass cannot borrow a stale phase.
                cnt <= 'd0;
                out_reg <= 1'b0;
                high_phase <= 1'b0;
                if (enter_req)
                    enter_req <= 1'b0;
                if (pend && (div_pend != 1))
                    leave_req <= 1'b1;
            end else if (leave_req) begin
                // use_clk fell on the previous negedge and use_clk_p has
                // already copied the 0.  Only reachable if leave_req was set
                // for a cycle while use_clk_p was still low.
                div <= div_pend;
                leave_req <= 1'b0;
                cnt <= hi_pend_q;
                out_reg <= 1'b1;
                high_phase <= 1'b1;
            end else if (apply_pend && div_pend_is1_q) begin
                div <= 1;
                cnt <= 'd0;
                out_reg <= 1'b0;
                high_phase <= 1'b0;
                enter_req <= 1'b1;
            end else if (apply_pend) begin
                // The low phase that just finished keeps its old width.
                // Start the new ratio on its high phase, counted down from
                // the pending last-index (committed to high_last this same
                // edge); restarting another low phase would stretch the low
                // pulse.
                div <= div_pend;
                cnt <= hi_pend_q;
                out_reg <= 1'b1;
                high_phase <= 1'b1;
            end else if (phase_last) begin
                // Down counter hit zero: toggle and reload the OTHER phase's
                // last-index.  high_phase still holds the phase that just
                // ended, so the reload pick is inverted.
                cnt <= high_phase ? low_last : high_last;
                out_reg <= ~out_reg;
                high_phase <= ~high_phase;
            end else begin
                cnt <= cnt_dec;
            end
        end
    end

    // high_phase shares the big block's priority chain.  It was split out
    // once to shallow its D, but the independent mux stopped the placer
    // co-locating it with the cnt/hi/lo_last muxes it drives and its clk2q
    // landed high_phase -> high_last at -0.15 ns SS -- worse than the
    // -0.044 self-loop it was meant to fix.  Reverted.


    // Bypass select changes only while clk is low.  Entering there keeps
    // out low until the next rising clk.  Leaving there hands the output
    // back to out_reg, which the posedge block holds low.
    always @(negedge clk or negedge rst_n_n) begin
        if (!rst_n_n)
            use_clk <= (DIV0 == 1);
        else if (enter_req)
            use_clk <= 1'b1;
        else if (leave_req)
            use_clk <= 1'b0;
    end
endmodule
