`timescale 1ps/1ps
// -----------------------------------------------------------------------------
// dll8_tile_tb -- closed-loop verification of the PRODUCTION tile control
// plane (bang-bang PD loop with sub-LSB quantization dead zone, REF-domain
// acquisition, SPICE-structure SR regeneration) with the behavioral line
// stand-in carrying SPICE-locked element timing.
//
// Measurement methodology is IDENTICAL to the verified behavioral campaign
// (src/dll8_tb.v): edge-sequenced coherent capture -- after a REF rising
// edge, wait for TAP0..TAP7 rising edges in order, so all measurements are
// within one REF period and free of cross-cycle associativity artifacts.
// The |phase_k - k*T/8| error metric is relative to the REF-launched
// absolute grid, so it INCLUDES the lock-point offset -- the stricter,
// application-relevant reading.
//
// Checks per (corner, rail):
//   1. LOCKED asserts within the simulation budget.
//   2. worst |phase_k - k*T/8| <= 30 ps.
//   3. tap7-REF mod T inside +-T/16 of 0 (no 7d/9d false lock).
//   4. duty of every regenerated PHASE in 45..55 % (regeneration contract;
//      the raw taps are 58-61 %, hence regeneration exists).
//   5. PHASE outputs stay flat-zero before LOCKED.
//
// Corner timing follows the SPICE-measured element table:
//   corner 0: SS 1.08V/125C @250 MHz (T=4000): BASE=148 STEP=5.0
//   corner 1: FF 1.32V/-40C @500 MHz (T=2000): BASE= 59 STEP=3.5
//   corner 2: SS stress    @500 MHz (T=2000): BASE= 89 STEP=4.0  (marginal-ok)
// -----------------------------------------------------------------------------
`timescale 1ps/1ps
`default_nettype none

module dll8_tile_tb;
    parameter integer CORNER    = 0;
    parameter integer RAIL      = 0;   // start code 0 or 127
    parameter real    T_PS      = (CORNER == 0) ? 4000.0 : 2000.0;
    // Measured element code->delay curve: cubic fit to the SPICE sweep
    // (flow/characterization/dll8_pex2/stock_elem.json), delay =
    // BASE + STEP*code + A2*code^2 + A3*code^3.  The coefficients are the
    // FIT's, not the old linear BASE/STEP with a correction on top.
    //   SS: a0 146.62, a1 1.9756, a2 -0.029813, a3  0.000360
    //   FF: a0  64.71, a1 -1.24461, a2 0.040914, a3 -0.000050
    parameter real    BASE_PS   = (CORNER == 0) ? 146.62 :
                                  (CORNER == 1) ?  64.71 : 146.62;
    parameter real    STEP_PS   = (CORNER == 0) ? 1.9756 :
                                  (CORNER == 1) ? -1.24461 : 1.9756;
    parameter real    A2_PS     = (CORNER == 0) ? -0.029813 :
                                  (CORNER == 1) ?  0.040914 : -0.029813;
    parameter real    A3_PS     = (CORNER == 0) ?  0.000360 :
                                  (CORNER == 1) ? -0.000050 :  0.000360;
    // DFF detector: data-lead offset and clock-path buffer (SPICE measured /
    // liberty buf_4)
    parameter real    PD_OFF_PS = (CORNER == 0) ? 122.0 :
                                  (CORNER == 1) ?  61.0 : 122.0;
    parameter real    PD_CLK_PS = (CORNER == 0) ? 108.0 :
                                  (CORNER == 1) ?  51.0 : 108.0;

    reg REF, RST_N, EN;
    wire [7:0]  PHASE;
    wire        LOCKED, ACQ_DONE;
    wire [6:0]  LOOP_CODE;
    wire [10:0] LOOP_S;
    wire [3:0]  MEAS_COUNTS;

    dll8_tile #(
        .BASE_PS(BASE_PS), .STEP_PS(STEP_PS),
        .A2_PS(A2_PS), .A3_PS(A3_PS),
        .PD_OFF_PS(PD_OFF_PS), .PD_CLK_PS(PD_CLK_PS)
    ) dut (
        .REF(REF), .RST_N(RST_N), .EN(EN),
        .KI(16'd1), .CODE_INIT(RAIL == 0 ? 7'd0 : 7'd127), .HOLD(1'b0),
        .PHASE(PHASE), .LOCKED(LOCKED), .LOOP_CODE(LOOP_CODE),
        .LOOP_S(LOOP_S), .ACQ_DONE(ACQ_DONE), .MEAS_COUNTS(MEAS_COUNTS)
    );

    wire [7:0] tap = dut.tap;

    initial REF = 0;
    always #(T_PS/2.0) REF = ~REF;

    integer errors;
    reg     phase_early;

    // regenerated outputs must be flat while the loop is not locked
    always @(PHASE) if (!LOCKED && PHASE != 8'd0) phase_early = 1'b1;

    // ------------------------------------------------- coherent measurement
    real t_ref;
    real d_elem [0:7];
    task automatic measure_taps;
        integer t;
        begin
            @(posedge REF); t_ref = $realtime;
            for (t = 0; t < 8; t = t + 1) begin
                @(posedge tap[t]); d_elem[t] = $realtime - t_ref;
            end
        end
    endtask

    task automatic check_phases;
        integer t;
        real target_d, resid, worst_c, err7;
        begin
            measure_taps;
            target_d = T_PS / 8.0;
            worst_c = 0.0;
            for (t = 0; t < 8; t = t + 1) begin
                resid = d_elem[t] - (t + 1) * target_d;
                if ((resid < 0 ? -resid : resid) > worst_c)
                    worst_c = (resid < 0 ? -resid : resid);
                $display("   tap%0d = %0.1f ps  k*T/8 err=%+0.1f ps",
                         t, d_elem[t], resid);
            end
            err7 = d_elem[7] - 8.0 * target_d;
            $display("   worst |phase_k-k*T/8| = %0.1f ps (budget 30)%s",
                     worst_c, (worst_c <= 30.0) ? "  PASS" : "  FAIL");
            if (worst_c > 30.0) errors = errors + 1;
            $display("   -> E (tap7 lock-point error) = %+0.1f ps", err7);
            if ((err7 < 0 ? -err7 : err7) > T_PS/16.0) begin
                $display("   FALSE-LOCK / lock-point failure (budget T/16)");
                errors = errors + 1;
            end
        end
    endtask

    task automatic check_duty;
        real t0, t1, t2, duty;
        integer t;
        begin
            for (t = 0; t < 8; t = t + 1) begin
                @(posedge PHASE[t]); t0 = $realtime;
                @(negedge PHASE[t]); t1 = $realtime;
                @(posedge PHASE[t]); t2 = $realtime;
                duty = 100.0 * (t1 - t0) / (t2 - t0);
                if (duty <= 45.0 || duty >= 55.0) begin
                    $display("   duty PHASE%0d = %0.1f %% FAIL", t, duty);
                    errors = errors + 1;
                end else
                    $display("   duty PHASE%0d = %0.1f %% PASS", t, duty);
            end
        end
    endtask

    // Regenerated-phase spacing: the PHASE[k] rising edges are what the TX/RX
    // actually use.  A common set-path delay cancels; only the k-to-k spread
    // enters |phase_k - k*T/8|.
    task automatic check_regen_spacing;
        real r0, rk, worst;
        integer k;
        begin
            @(posedge REF);
            worst = 0.0; r0 = 0.0;
            for (k = 0; k < 8; k = k + 1) begin
                @(posedge PHASE[k]);
                if (k == 0) r0 = $realtime;
                else begin
                    rk = ($realtime - r0) - k*T_PS/8.0;
                    while (rk >  T_PS/2.0) rk = rk - T_PS;
                    while (rk < -T_PS/2.0) rk = rk + T_PS;
                    if (rk < 0) rk = -rk;
                    if (rk > worst) worst = rk;
                end
            end
            $display("   regenerated spacing worst = %0.1f ps (budget 30)  %s",
                     worst, (worst <= 30.0) ? "PASS" : "FAIL");
            if (worst > 30.0) errors = errors + 1;
        end
    endtask

    // ---------------------------------------------------------------- run
    integer n;
    initial begin
        errors = 0; phase_early = 1'b0;
        RST_N = 1'b0; EN = 1'b0;
        repeat (8) @(posedge REF);
        RST_N = 1'b1;
        repeat (4) @(posedge REF);
        EN = 1'b1;
        // lock wait: acquisition worst case ~127 steps x 4 REF at boosted KI
        // plus settling; generous cap, poll per REF cycle.
        for (n = 0; n < 20000 && !LOCKED; n = n + 1) @(posedge REF);
        $display("corner %0d rail %0d: T=%0.0f BASE=%0.1f LSB=%0.2f",
                 CORNER, RAIL, T_PS, BASE_PS, STEP_PS);
        $display("   lock: LOCKED=%0b after %0d REF cycles, code=%0d S=%0d meas=%0d acq_done=%0b",
                 LOCKED, n, LOOP_CODE, LOOP_S, MEAS_COUNTS, ACQ_DONE);
        if (!LOCKED) begin
            errors = errors + 1;
            $display("dll8_tile_tb: FAIL (no lock)");
            $finish;
        end
        // let the regen pipeline flush a few cycles after lock
        repeat (10) @(posedge REF);
        check_phases;
        check_duty;
        check_regen_spacing;
        if (phase_early) begin
            $display("   PHASE active before LOCKED: FAIL");
            errors = errors + 1;
        end
        if (errors == 0) $display("dll8_tile_tb: PASS");
        else             $display("dll8_tile_tb: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
`default_nettype wire
