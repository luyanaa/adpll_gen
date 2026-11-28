`timescale 1ns/1ps
// SPDX-License-Identifier: Apache-2.0
// DDR1 DLL physical (pass-2) building blocks:
//
//   DDR1_DLL_THERM_STRAP — 7-bit loop code -> 127-bit finger strap bus with
//                          the dll8_line4 polarity contract folded in
//                          (strap[j] = th[j] XOR (j odd): N fingers ON high,
//                          P fingers ON low).  One instance per DLL, broadcast
//                          to all ten strips (4 master segments x2 + 1 slave
//                          segment x2).  Control is quasi-static DC: the loop
//                          moves +-1 LSB per 10 ns measurement, so strap
//                          timing is irrelevant; there is no glitch-sensitive
//                          element because a finger is a cap on a DC switch.
//
//   DDR1_DLL_SEG_PHYS    — one quarter-replica segment = TWO dll8_line4
//                          hard-macro strips in series (8 elements, the N=8
//                          pick of docs/DDR1_DLL_ELEMENT_SIZING.md).  The
//                          strips are blackboxes (LEF/GDS collateral in
//                          flow/macro/dll8_line4_macro/); there is no
//                          behavioral model — RTL simulation of the loop
//                          uses DDR1_DLL_SEG (behavioral) and the structural
//                          path is elaboration/synthesis/SPICE evidence.
//
//   DDR1_CLK_REGEN       — SR phase regeneration (the sizing doc's "matched
//                          SR regeneration" decision).  Q rises at SET_IN's
//                          rising edge and falls at RESET_IN's rising edge.
//                          Both inputs are chain taps carrying the SAME input
//                          waveform, so the tpHL/tpLH chain asymmetry is
//                          common-mode and the output duty is set by the TAP
//                          SPACING (T/2 at lock), not by the input duty.
//                          Each structural instance ends in a matched
//                          sg13g2_buf_4 output stage.  Why: the two latch
//                          outputs drive DIFFERENT loads in the integrated
//                          top (master -> the TDC offset chain; CK90 -> the
//                          EN gate + pad), and that load difference lands
//                          directly on CK90 (it is not divided by 4).  The
//                          buffer makes the latch's own output load
//                          identical on both sides; the residual is the
//                          buffer's load sensitivity, one stage removed and
//                          absorbed by TRIM_MASTER_PS.
//
//                          Structural: sg13g2_dfrbp_1 D=1 clocked by SET_IN,
//                          async-reset by an active-low pulse from RESET_IN
//                          built as rn = ~(RESET_IN & ~RESET_IN_d) with
//                          RESET_IN_d = 12 inverter stages (~330 ps TT).
//                          PULSE WIDTH IS A HARD CONSTRAINT, measured in
//                          SPICE on the real dfrbp model (2026-11-28,
//                          /tmp/opencode/dfr probe decks): a 100 ps
//                          active-low pulse does NOT reset the flop, 150 ps
//                          does, and the 8-stage chain gave only 219 ps
//                          (1.5x) -- 12 stages gives ~330 ps, >=2x margin,
//                          and tracks the flop's own corner scaling since
//                          both are the same cell family.  A 2-stage (47 ps)
//                          pulse was the first cut and silently left Q
//                          stuck high: always characterize async controls
//                          against the min-pulse-width spec.
//                          Behavioral model for RTL sim: edge-sensitive SR
//                          semantics (pulse width irrelevant there).
//
// Timing note (docs/DDR1_DLL_ELEMENT_SIZING.md): the latch adds a constant
// set-path delay D_set to every regenerated edge.  Because the TDC measures
// the REGENERATED master, the loop servos most of it out: the residual
// systematic CK90 offset is (3/4)*D_set at every corner, characterized by
// SPICE.  This is the price of duty independence; the raw alternative
// violates nothing in the spec but leaves the transmit eye asymmetric.
`default_nettype none

// ---------------------------------------------------------------------------
// thermometer strap decoder (shared, broadcast)
// ---------------------------------------------------------------------------
module DDR1_DLL_THERM_STRAP (
    input  wire [6:0]    CODE,
    output wire [126:0]  STRAP
);
    genvar j;
    generate
        for (j = 0; j < 127; j = j + 1) begin : bitg
            // th[j] = (CODE > j); polarity: even (N) fingers ON when strap
            // HIGH, odd (P) fingers ON when strap LOW.
            if ((j % 2) == 0) begin : n_fing
                assign STRAP[j] = (CODE > j);
            end else begin : p_fing
                assign STRAP[j] = !(CODE > j);
            end
        end
    endgenerate
endmodule

// ---------------------------------------------------------------------------
// structural quarter-replica segment: 2 x dll8_line4 (8 elements)
// ---------------------------------------------------------------------------
module DDR1_DLL_SEG_PHYS (
    input  wire          IN,
    input  wire [126:0]  STRAP,
    output wire          OUT
);
    wire mid;
    (* keep *) (* dont_touch = "true" *)
    dll8_line4 u_lo (
        .IN(IN),   .OUT(mid),
        .TAP0(), .TAP1(), .TAP2(), .TAP3(),
        .EN0(STRAP), .EN1(STRAP), .EN2(STRAP), .EN3(STRAP));
    (* keep *) (* dont_touch = "true" *)
    dll8_line4 u_hi (
        .IN(mid),  .OUT(OUT),
        .TAP0(), .TAP1(), .TAP2(), .TAP3(),
        .EN0(STRAP), .EN1(STRAP), .EN2(STRAP), .EN3(STRAP));
endmodule

// ---------------------------------------------------------------------------
// SR phase regeneration.
//   STRUCT: dfrbp(CLK=SET_IN, D=1) + async-reset pulse from RESET_IN rise.
//   BEH   : edge-sensitive SR semantics (zero added delay at the set edge —
//           the constant D_set is a silicon systematic, documented; the RTL
//           sim cares about logic, not the offset).
// ---------------------------------------------------------------------------
module DDR1_CLK_REGEN #(
    parameter integer IMPL = 0   // 0 = behavioral sim model, 1 = structural
) (
    input  wire SET_IN,    // rising edge: output rises (THE phase edge)
    input  wire RESET_IN,  // rising edge: output falls
    output wire Q
);
    generate
        if (IMPL == 0) begin : beh
            // single process, edge-discriminated: SET priority on a
            // (never-occurring) exact collision.
            reg q = 1'b0;
            reg ps = 1'b0, pr = 1'b0;
            always @(SET_IN or RESET_IN) begin
                if (SET_IN === 1'b1 && ps !== 1'b1) q = 1'b1;
                else if (RESET_IN === 1'b1 && pr !== 1'b1) q = 1'b0;
                ps = SET_IN;
                pr = RESET_IN;
            end
            assign Q = q;
        end else begin : cells
            // reset pulse: rn = ~(RESET_IN & ~RESET_IN_d) with an 8-stage
            // delay (~400 ps measured; 2 stages = 47 ps was BELOW the flop's
            // minimum async-reset width and did not reset it at all).
            wire [12:0] rdl;
            assign rdl[0] = RESET_IN;
            genvar ri;
            for (ri = 0; ri < 12; ri = ri + 1) begin : rdel
                (* keep *) (* dont_touch = "true" *)
                sg13g2_inv_1 u_i (.A(rdl[ri]), .Y(rdl[ri+1]));
            end
            wire rdb = rdl[12];
            wire rn;
            // nand2b: Y = ~(~A_N & B) (A_N is the internally-inverted pin).
            // With A_N = rdb (= RESET_IN delayed) and B = RESET_IN:
            // Y = ~(~RESET_IN_d & RESET_IN) = the narrow active-low pulse
            // starting at the RESET_IN rising edge.
            (* keep *) (* dont_touch = "true" *)
            sg13g2_nand2b_1 u_rp (.A_N(rdb), .B(RESET_IN), .Y(rn));
            wire tied_hi, q_raw;
            (* keep *) (* dont_touch = "true" *)
            sg13g2_tiehi u_tie (.L_HI(tied_hi));
            (* keep *) (* dont_touch = "true" *)
            sg13g2_dfrbp_1 u_sr (
                .CLK(SET_IN), .D(tied_hi), .RESET_B(rn), .Q(q_raw), .Q_N());
            // matched output stage (identical cell in every instance)
            (* keep *) (* dont_touch = "true" *)
            sg13g2_buf_4 u_obuf (.A(q_raw), .X(Q));
        end
    endgenerate
endmodule
`default_nettype wire
