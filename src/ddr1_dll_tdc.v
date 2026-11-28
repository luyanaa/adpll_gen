`timescale 1ns/1ps
// SPDX-License-Identifier: Apache-2.0
// DDR1_DLL_TDC — signed flash time-to-digital converter for the DDR1 CK90
// ratio DLL phase detector (TDC_IMPL=1 structural path).
// Architecture: docs/DDR1_TDC_DESIGN.md (option (d) + capture dynamics).
//
// STRUCTURE (single chain + delayed-master offset, single clock domain):
//
//   CKIN ──► measurement chain (NTAP cells, tap vector)
//                │ capture clock
//   MASTER ──► offset chain (NTAP/2 identical cells) ──► master_d
//
//   The capture of the tap vector is clocked by master_d = MASTER + D0,
//   D0 = (NTAP/2)·tau.  A capture at the master edge therefore happens D0
//   AFTER the wavefront entry even when the master edge COINCIDES with
//   CKIN, so the zero residual reads the CENTER tap:
//
//       position(na) ~ (e + D0)/tau     e = (na - NTAP/2) · tau
//
//   valid signed range: ±(NTAP/2)·tau (±1.6/1.04/0.72 ns at SS/TT/FF with
//   NTAP=32 — far outside the ±640 ps loss band everywhere).
//
// WHY THIS STRUCTURE (vs. a two-chain start/stop swap):
//   * every capture for in-range residuals happens between wavefront entry
//     and +(NTAP)·tau < T/2, i.e. BEFORE the falling wavefront of the 50%
//     duty CKIN can enter the chain — no falling-edge garbage in range;
//   * deep late masters saturate all-ones (correct sign); deep early
//     masters capture before entry / after passage, all-zero (correct
//     sign) — no modulo aliasing, STRICTLY better than the behavioral
//     fold emulation (which stays as the pessimistic verification model);
//   * everything is one quasi-static domain: capture at master_d =
//     t_m + D0, consumption in the DLL loop at the NEXT master edge
//     t_m + T — a gap of T - D0 ~ 8.7 ns » metastability resolution, so
//     no synchronizers and NO extra measurement latency in the loop
//     (a two-chain CDC structure would have cost 2 periods of loop
//     latency and retuned lock dynamics).
//
// IMPL split (same pattern as the DQS line):
//   IMPL=0: behavioral transport-delay cells — full end-to-end exercise of
//           the capture/decode logic with realistic timing in RTL sim.
//   IMPL=1: structural FINE_DELAY_CELLs for synthesis/STA.  Decode logic
//           is IDENTICAL RTL in both.
//
// Interface (consumed by DDR1_CK90_DLL): E_MEAS is the signed residual in
// ps (integer, tap-quantized), stable well before each MASTER rising edge
// once running; MEAS_VLD raises after the first captured measurement.
//
// Metastability: capture flops near the wavefront transition can go
// metastable; worst case one tap reads wrong for one measurement.  The
// ones-count decode tolerates a single bubble; the DLL's LOCK_N=8 /
// LOSS_N=3 counters debounce single bad samples.  MTBF analysis is a
// pass-2 signoff item.

module DDR1_DLL_TDC_CELL_BEH #(
    parameter integer DLY_PS = 65
) (
    input  wire I,
    output wire O
);
    // behavioral transport delay — same role as DDR1_DQS_DELAY_CELL_BEH.
    // NOTE the timescale of this file is 1ns/1ps: DLY_PS is picoseconds,
    // so the delay must be scaled to nanoseconds.
    reg d = 1'b0;
    always @(I) d <= #(DLY_PS/1000.0) I;
    assign O = d;
endmodule

module DDR1_DLL_TDC #(
    parameter integer NTAP        = 32,  // measurement chain cells
    parameter integer TDC_STEP_PS = 65,  // behavioral tap step (TT cell)
    parameter integer IMPL        = 0,   // 0 = behavioral cells, 1 = structural
    parameter integer E_BITS      = 16
) (
`ifdef WITH_POWER
    inout  wire VDD, VSS,
`endif
    input  wire CKIN,
    input  wire MASTER,
    input  wire RST,                       // async, clears output regs only
    output reg  signed [E_BITS-1:0] E_MEAS,
    output reg                        MEAS_VLD
);
    localparam integer NOFF = NTAP/2;    // offset chain length

    // ------------------------------------------------------------------
    // measurement chain: tap[0] is the input node, tap[NTAP] the far end.
    // Non-inverting cells: the rising wavefront propagates as 0->1.
    // ------------------------------------------------------------------
    wire [NTAP:0] cha;
    wire [NOFF:0] off;
    assign cha[0] = CKIN;
    assign off[0] = MASTER;

    genvar gi;
    generate
        for (gi = 0; gi < NTAP; gi = gi + 1) begin : mcell
            if (IMPL == 0) begin : beh
                DDR1_DLL_TDC_CELL_BEH #(.DLY_PS(TDC_STEP_PS)) c0 (
                    .I(cha[gi]), .O(cha[gi+1]));
            end else begin : phys
                FINE_DELAY_CELL c0 (
`ifdef WITH_POWER
                    .VDD(VDD), .VSS(VSS),
`endif
                    .MUX(1'b1), .IN(cha[gi]), .OUT(cha[gi+1]));
            end
        end
        for (gi = 0; gi < NOFF; gi = gi + 1) begin : ocell
            if (IMPL == 0) begin : beh
                DDR1_DLL_TDC_CELL_BEH #(.DLY_PS(TDC_STEP_PS)) c0 (
                    .I(off[gi]), .O(off[gi+1]));
            end else begin : phys
                FINE_DELAY_CELL c0 (
`ifdef WITH_POWER
                    .VDD(VDD), .VSS(VSS),
`endif
                    .MUX(1'b1), .IN(off[gi]), .OUT(off[gi+1]));
            end
        end
    endgenerate

    wire master_d = off[NOFF];

    // ------------------------------------------------------------------
    // capture in the master_d domain.  taps 1..NTAP (tap[0] is the raw
    // input, excluded).  cap[0] = tap 1 (nearest the input).
    // ------------------------------------------------------------------
    reg [NTAP-1:0] cap;
    always @(posedge master_d) begin
        cap <= cha[NTAP:1];
    end

    // ------------------------------------------------------------------
    // decode: leading-ones count with one-bubble tolerance, scanning from
    // the input side (cap[0]) toward the far end.
    // ------------------------------------------------------------------
    function integer ones_count(input [NTAP-1:0] v);
        integer k;
        integer zeros_seen;
        integer stop;
        begin
            ones_count = 0;
            zeros_seen = 0;
            stop = 0;
            for (k = 0; k < NTAP; k = k + 1) begin
                if (!stop) begin
                    if (v[k] === 1'b1) begin
                        ones_count = ones_count + 1;
                    end else begin
                        zeros_seen = zeros_seen + 1;
                        if (zeros_seen > 1) stop = 1;
                    end
                end
            end
        end
    endfunction

    integer na;
    reg signed [E_BITS-1:0] e_next;

    // position -> signed residual: center tap = zero.
    // saturation reads clamp at the ends (correct sign for deep offsets).
    always @(*) begin
        na = ones_count(cap);
        e_next = (na - NOFF) * TDC_STEP_PS;
    end

    // consumption domain: MASTER.  The capture happened at master_d =
    // t_m + D0; this register samples it at the NEXT master edge
    // (t_m + T), i.e. T - D0 ~ 8.7 ns after the capture — fully stable,
    // no synchronizer required.
    always @(posedge MASTER or posedge RST) begin
        if (RST) begin
            E_MEAS   <= {E_BITS{1'b0}};
            MEAS_VLD <= 1'b0;
        end else begin
            E_MEAS   <= e_next;
            MEAS_VLD <= 1'b1;
        end
    end
endmodule
