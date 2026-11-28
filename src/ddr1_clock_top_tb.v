// ddr1_clock_top_tb — self-checking integration testbench for
// DDR1_CLOCK_TOP (DDR1 100 MHz Phase B clock generation, pass 1).
//
// Three DUT instances are exercised:
//   uA: USE_DLL90=0, USE_DCC=0 (candidate A, dual-edge divide-by-2)
//   uB: USE_DLL90=1, USE_DCC=0 (candidate B, ratio DLL -- the Phase-B
//       default architecture)
//   uC: USE_DLL90=0, USE_DCC=1 (candidate-A + DCC experiment; exercises
//       the DCC-loss fail-closed path)
// fed with the same 200 MHz MCK, PLL_LOCKED, RST, bypass pins, TICK/SAMP.
//
// The A/B duty-injection matrix is run by ddr1_ck90_compare_tb.v.
//
// Checks (each prints PASS/FAIL; exit nonzero on any failure):
//   1  reset behavior: outputs low before lock; 4 reset reruns give the
//      same first-CK-edge phase (no 180-degree ambiguity) and CK90 lag
//   1c BLOCKER 4: DLL is held in reset/disabled until PLL_LOCKED (code
//      stays at CODE_INIT), and re-acquires after a PLL-lock return
//   2  frequency: CK 100 MHz +/-1%, SYS_CLK 50 MHz
//   3  duty: CK high in 45-55% (zero injected error)
//   4  SYS_CLK rise aligned with CK rise
//   5  CK90 phase: A and B both 2.5 ns lag
//   5b BLOCKER 1: candidate B DLL code still dithers post-lock (no freeze)
//   6  BLOCKER 7: lock-release at BOTH ck_a parities -> no runt; first CK
//      and CK90 pulses are full width and CK leads CK90
//   7  fail-closed: PLL_LOCKED drop -> outputs low within one CK cycle,
//      ERR sticky, outputs stay low until RST
//   8  bypass: reset-only switching, outputs gated by the bypass lock,
//      PLL-independent lock, Bypass changes outside reset ignored
//   9  lock timing from reset release (must be << 100 us)
//  11  BLOCKER 2: DLL acquisition timeout reports DLL_ERR
//  12  BLOCKER 6: CK90 phase monitor violation sets ERR and drops lock
//  13  BLOCKER 5: DCC-lock loss drops PHY_LOCKED (fail-closed) and DCC_ERR
//      arms sticky ERR
//  14  droop survival: 8-LSB (512 ps master) step keeps lock, no ERR,
//      loop slews back (in-spec correctable step must NOT false-trip)
//  15  code-window elimination: slow drift below old CODE_LOCK_MIN keeps lock
//  16  real loss: beyond-correction-range offset sets ERR, clears lock
//  17  BLOCKER 3: beyond-spec but correctable step (1024 ps master /
//      256 ps CK90) fails CLOSED within LOSS_N=3 (old 800/24 rode it out)
//  18  BLOCKER 2 (attempt 3): 180-deg inverse CK90 (= ~CK, passes the
//      old two-sample monitor) is rejected by the third sample
//      (CK-rise+2.8 ns) -> ERR sets, lock drops
//
// Compile/run (from the repo root):
//   mkdir -p sim/outputs/ddr1
//   iverilog -g2012 -DSIMULATION -o /tmp/opencode/ddr1_clock_top.vvp \
//     src/ddr1_clock_top_tb.v src/ddr1_clock_top.v src/ddr1_ck90_de2.v \
//     src/ddr1_ck90_dll.v src/adcc_top.v src/digital_loop_filter.v \
//     src/term_decoder.v src/pll_counter_dcdl.v src/sim_mux.v
//   vvp /tmp/opencode/ddr1_clock_top.vvp
//
// Output: sim/outputs/ddr1/ddr1_clock_top_tb.log
`timescale 1ns/1ps

module ddr1_clock_top_tb;
    integer fd, errors, checks;
    reg mck = 1'b0;
    reg pll_locked = 1'b0;
    reg rst = 1'b0;   // starts low; sequence asserts a real 0->1 edge
    reg bypass = 1'b0;
    reg ext_ck = 1'b0;
    reg ext_ck90_r = 1'b0;
    reg ext_sys = 1'b0;
    reg tick_r = 1'b0;
    reg samp_r = 1'b0;

    always #2.5 mck = ~mck;                 // 200 MHz, 50% duty
    always #5.0 ext_ck = ~ext_ck;           // 100 MHz external (bypass)
    always @(ext_ck) ext_ck90_r <= #2.5 ext_ck;   // external CK90
    wire ext_ck90 = ext_ck90_r;
    always @(posedge ext_ck) ext_sys = ~ext_sys;  // 50 MHz aligned
    always #0.5   tick_r = ~tick_r;         // DCC loop clock (1 ns)
    always #0.555 samp_r = ~samp_r;         // DCC incommensurate sampler

    wire ckA, ckAn, ck90A, sysA, lockA, errA;
    wire [15:0] dbgA;
    wire ckB, ckBn, ck90B, sysB, lockB, errB;
    wire [15:0] dbgB;
    wire ckC, ckCn, ck90C, sysC, lockC, errC;
    wire [15:0] dbgC;

    DDR1_CLOCK_TOP #(.USE_DLL90(0), .USE_DCC(0)) uA (
        .MCK_IN(mck), .PLL_LOCKED(pll_locked), .RST(rst),
        .TICK(tick_r), .SAMP(samp_r),
        .EXT_CK(ext_ck), .EXT_CK90(ext_ck90_r), .EXT_SYS_CLK(ext_sys),
        .BYPASS(bypass),
        .CK_PHY(ckA), .CK_PHY_N(ckAn), .CK90_PHY(ck90A), .SYS_CLK(sysA),
        .PHY_LOCKED(lockA), .ERR(errA), .DBG(dbgA));

    DDR1_CLOCK_TOP #(.USE_DLL90(1), .USE_DCC(0)) uB (
        .MCK_IN(mck), .PLL_LOCKED(pll_locked), .RST(rst),
        .TICK(tick_r), .SAMP(samp_r),
        .EXT_CK(ext_ck), .EXT_CK90(ext_ck90_r), .EXT_SYS_CLK(ext_sys),
        .BYPASS(bypass),
        .CK_PHY(ckB), .CK_PHY_N(ckBn), .CK90_PHY(ck90B), .SYS_CLK(sysB),
        .PHY_LOCKED(lockB), .ERR(errB), .DBG(dbgB));

    DDR1_CLOCK_TOP #(.USE_DLL90(0), .USE_DCC(1)) uC (
        .MCK_IN(mck), .PLL_LOCKED(pll_locked), .RST(rst),
        .TICK(tick_r), .SAMP(samp_r),
        .EXT_CK(ext_ck), .EXT_CK90(ext_ck90_r), .EXT_SYS_CLK(ext_sys),
        .BYPASS(bypass),
        .CK_PHY(ckC), .CK_PHY_N(ckCn), .CK90_PHY(ck90C), .SYS_CLK(sysC),
        .PHY_LOCKED(lockC), .ERR(errC), .DBG(dbgC));

    // --- BLOCKER 2: standalone DLL whose target is unreachable (the cell
    // law is too fast: master delay ~256 ps against a 10 ns period), so it
    // can never lock -> the acquisition watchdog must set DLL_ERR.  The
    // rail aid is pushed out of the way (200) so this proves the timeout
    // fires independently of the rail state.
    reg  dllt_rst = 1'b1;
    wire dllt_ck90, dllt_locked, dllt_err;
    wire [8:0] dllt_code;
    DDR1_CK90_DLL #(
        .NQ_SEG(64), .CODE_BITS(9),
        .CELL_X4_MIN(4), .CELL_X4_STEP(0),
        .RAIL_CONSEC(200), .ACQ_TIMEOUT_CY(64)
    ) uDLLT (
        .CKIN(ext_ck), .RST(dllt_rst), .EN(1'b1),
        .CK90(dllt_ck90), .DLL_LOCKED(dllt_locked), .DLL_ERR(dllt_err),
        .DBG_CODE(dllt_code));

    // --- BLOCKERS 1/2: phase-measurement DLL tests (loss, droop survival,
    // slow drift out of the old code window, beyond-range loss).  The
    // internal test scaffolding reg dly_off_x4 is forced by the TB.
    reg  dllv_rst = 1'b1;
    wire dllv_ck90, dllv_locked, dllv_err;
    wire [8:0] dllv_code;
    DDR1_CK90_DLL uDLLV (
        .CKIN(ext_ck), .RST(dllv_rst), .EN(1'b1),
        .CK90(dllv_ck90), .DLL_LOCKED(dllv_locked), .DLL_ERR(dllv_err),
        .DBG_CODE(dllv_code));

    // last MCK rise time (for reset-determinism measurements)
    real t_mck_r;
    always @(posedge mck) t_mck_r <= #0.001 $realtime;

    task chk(input cond, input [8*56-1:0] name);
        begin
            checks = checks + 1;
            if (cond) begin
                $display("PASS: %0s", name);
                $fdisplay(fd, "PASS: %0s", name);
            end else begin
                errors = errors + 1;
                $display("FAIL: %0s", name);
                $fdisplay(fd, "FAIL: %0s", name);
            end
        end
    endtask

    real t_rel, t_lock, lag, t1, t2, acc, per, dutyc, algn;
    real first_ck_off [0:3];
    real first_ck90_off [0:3];
    integer i, k, ok, tmo_cnt;
    integer dstep, code_before, code_after;
    real t_sysr;

    // BLOCKER 7 support: which ck_a parity the latch released on
    reg latch_phase [0:1];

    // No-runt lock-release check.  `flip` shifts the PLL_LOCKED assertion
    // by one MCK cycle so the debounced latch releases on the opposite
    // ck_a parity.  The first CK and CK90 pulses must be full width and
    // CK must lead CK90 (a latch release inside a CK90 high pulse would
    // make CK90 lead / runt).
    task no_runt_release(input integer flip, input integer idx);
        real t0, tw, t90, wck, w90, d90;
        begin
            @(posedge mck);
            rst = 1'b1; pll_locked = 1'b0; #30;
            @(posedge mck); #1; rst = 1'b0;
            repeat (20) @(posedge mck);
            repeat (flip) @(posedge mck);
            pll_locked = 1'b1;
            @(posedge uA.latch_q);
            latch_phase[idx] = uA.ck_a;
            @(posedge lockA);
            t0 = $realtime;
            @(posedge ck90A); t90 = $realtime; d90 = t90 - t0;
            @(negedge ckA);   wck = $realtime - t0;
            @(negedge ck90A); w90 = $realtime - t90;
            chk((wck > 4.5) && (wck < 5.5),
                "check6: first CK pulse full width (no runt)");
            chk((d90 > 2.3) && (d90 < 2.7),
                "check6: CK90 rises ~2.5 ns after first CK");
            chk((w90 > 4.5) && (w90 < 5.5),
                "check6: first CK90 pulse full width (no runt)");
            $display("check6: release flip=%0d latch_ck_a=%b wck=%0.2f d90=%0.2f w90=%0.2f",
                     flip, latch_phase[idx], wck, d90, w90);
            $fdisplay(fd, "check6: release flip=%0d latch_ck_a=%b wck=%0.2f d90=%0.2f w90=%0.2f",
                      flip, latch_phase[idx], wck, d90, w90);
        end
    endtask

    initial begin
        errors = 0; checks = 0;
        fd = $fopen("sim/outputs/ddr1/ddr1_clock_top_tb.log", "w");
        $display("ddr1_clock_top_tb: DDR1 100 MHz clock generation, pass 1");
        $fdisplay(fd, "ddr1_clock_top_tb: DDR1 100 MHz clock generation, pass 1");

        // ---- check 1a: everything low during reset ----
        rst = 1'b1;   // real 0->1 edge so the async resets fire
        #60;
        chk((ckA === 1'b0) && (ckAn === 1'b0) && (ck90A === 1'b0) && (sysA === 1'b0),
            "check1: uA outputs low during reset");
        chk((lockA === 1'b0) && (errA === 1'b0),
            "check1: uA PHY_LOCKED/ERR low during reset");
        chk((ckB === 1'b0) && (ck90B === 1'b0) && (sysB === 1'b0) && (lockB === 1'b0),
            "check1: uB outputs low during reset");
        chk((ckC === 1'b0) && (lockC === 1'b0),
            "check1: uC outputs low during reset");

        // ---- release reset with PLL still unlocked ----
        @(posedge mck); #1;
        rst = 1'b0; t_rel = $realtime;
        #200;
        // BLOCKER 4: DLL must be parked in reset until PLL_LOCKED.  If it
        // ran, it would lock on the acquisition-time frequency.
        chk((dbgB[11] === 1'b0) && (uB.g_dll.u_dll.code_q === 9'd40),
            "check1c: DLL held in reset until PLL_LOCKED (code=init)");
        #50;
        pll_locked = 1'b1;

        // wait for uA PHY_LOCKED (check 9 timing)
        tmo_cnt = 0;
        while (!lockA && tmo_cnt < 5000) begin #10; tmo_cnt = tmo_cnt + 10; end
        t_lock = $realtime - t_rel;
        chk(lockA, "check9: uA PHY_LOCKED asserts");
        $display("check9: uA lock time from reset release = %0.1f ns (must be << 100000 ns)", t_lock);
        $fdisplay(fd, "check9: uA lock time from reset release = %0.1f ns", t_lock);
        chk(t_lock < 100000.0, "check9: lock time < 100 us");

        tmo_cnt = 0;
        while (!lockB && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(lockB, "check9: uB PHY_LOCKED asserts (DLL locked)");

        #200; // settle

        // ---- check 2: frequency ----
        acc = 0.0;
        @(posedge ckA); t1 = $realtime;
        for (k = 0; k < 10; k = k + 1) begin
            @(posedge ckA); t2 = $realtime; acc = acc + (t2 - t1); t1 = t2;
        end
        per = acc/10.0;
        $display("check2: uA CK period avg = %0.3f ns over 10 cycles", per);
        $fdisplay(fd, "check2: uA CK period avg = %0.3f ns", per);
        chk((per > 9.9) && (per < 10.1), "check2: CK = 100 MHz +/-1%");
        acc = 0.0;
        @(posedge sysA); t1 = $realtime;
        for (k = 0; k < 10; k = k + 1) begin
            @(posedge sysA); t2 = $realtime; acc = acc + (t2 - t1); t1 = t2;
        end
        per = acc/10.0;
        $display("check2: uA SYS_CLK period avg = %0.3f ns over 10 cycles", per);
        $fdisplay(fd, "check2: uA SYS_CLK period avg = %0.3f ns", per);
        chk((per > 19.8) && (per < 20.2), "check2: SYS_CLK = 50 MHz +/-1%");

        // ---- check 3: duty ----
        acc = 0.0;
        for (k = 0; k < 10; k = k + 1) begin
            @(posedge ckA); t1 = $realtime;
            @(negedge ckA); acc = acc + ($realtime - t1);
        end
        dutyc = acc/10.0;
        $display("check3: uA CK high time avg = %0.3f ns (duty %0.1f%%)", dutyc, dutyc*10.0);
        $fdisplay(fd, "check3: uA CK high time avg = %0.3f ns", dutyc);
        chk((dutyc > 4.5) && (dutyc < 5.5), "check3: CK duty 45-55%");

        // ---- check 4: SYS alignment ----
        ok = 1;
        for (k = 0; k < 5; k = k + 1) begin
            @(posedge sysA); t_sysr = $realtime;
            #0.01;
            algn = t_sysr - t_mck_r;
            if (!(algn < 0.02)) ok = 0;
        end
        chk(ok == 1, "check4: SYS_CLK rise aligned with CK rise");

        // ---- check 5: CK90 phase ----
        acc = 0.0;
        for (k = 0; k < 10; k = k + 1) begin
            @(posedge ckA);   t1 = $realtime;
            @(posedge ck90A); acc = acc + ($realtime - t1);
        end
        lag = acc/10.0*1000.0;
        $display("check5: uA CK90 lag avg = %0.1f ps (target 2500 +/- 200)", lag);
        $fdisplay(fd, "check5: uA CK90 lag avg = %0.1f ps", lag);
        chk((lag > 2300.0) && (lag < 2700.0), "check5: candidate A CK90 = 2.5 ns +/- 200 ps");

        acc = 0.0;
        for (k = 0; k < 10; k = k + 1) begin
            @(posedge ckB);   t1 = $realtime;
            @(posedge ck90B); acc = acc + ($realtime - t1);
        end
        lag = acc/10.0*1000.0;
        $display("check5: uB CK90 lag avg = %0.1f ps (target 2500 +/- 100)", lag);
        $fdisplay(fd, "check5: uB CK90 lag avg = %0.1f ps", lag);
        chk((lag > 2400.0) && (lag < 2600.0), "check5: candidate B CK90 = 2.5 ns +/- 100 ps");
        chk(errA === 1'b0, "check5: uA ERR still clear");
        chk(errB === 1'b0, "check5: uB ERR still clear");

        // ---- check 5b: BLOCKER 1 continuous tracking (dither post-lock) ----
        begin : dither_chk
            integer changes;
            reg [8:0] prev;
            changes = 0;
            prev = uB.g_dll.u_dll.code_q;
            for (k = 0; k < 40; k = k + 1) begin
                @(posedge mck);
                if (uB.g_dll.u_dll.code_q !== prev) changes = changes + 1;
                prev = uB.g_dll.u_dll.code_q;
            end
            $display("check5b: uB DLL code changed %0d times in 40 MCK cycles (dither)", changes);
            $fdisplay(fd, "check5b: uB DLL code changed %0d times in 40 MCK cycles", changes);
            chk(changes >= 2, "check5b: DLL keeps dithering after lock (not frozen)");
            chk((lockB === 1'b1) && (errB === 1'b0),
                "check5b: DLL stays locked/error-free while tracking");
        end

        // ---- check 6: lock release at BOTH ck_a parities (no runt) ----
        no_runt_release(0, 0);
        no_runt_release(1, 1);
        chk(latch_phase[0] !== latch_phase[1],
            "check6: exercised both ck_a release parities");
        chk((lockA === 1'b1) && (errA === 1'b0),
            "check6: uA locked/clear after parity release tests");

        // ---- check 1b: 4 reset reruns, no 180-degree ambiguity ----
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge mck); #1;
            rst = 1'b1;
            #30;
            @(posedge mck); #1;
            rst = 1'b0; t_rel = $realtime;
            tmo_cnt = 0;
            while (!lockA && tmo_cnt < 5000) begin #10; tmo_cnt = tmo_cnt + 10; end
            chk(lockA, "check1: rerun relocks");
            @(posedge ckA);
            #0.01;
            first_ck_off[i] = $realtime - t_mck_r;
            @(posedge ck90A);
            #0.01;
            first_ck90_off[i] = $realtime - t_mck_r;
            chk(first_ck_off[i] < 0.05,
                "check1: first CK rise at an MCK rising edge (not 180-deg)");
            chk((first_ck90_off[i] > 2.3) && (first_ck90_off[i] < 2.65),
                "check1: first CK90 rise at MCK rise + ~2.5 ns");
            $display("check1: rerun %0d: ck_off=%0.3f ns ck90_off=%0.3f ns",
                     i, first_ck_off[i], first_ck90_off[i]);
            $fdisplay(fd, "check1: rerun %0d: ck_off=%0.3f ns ck90_off=%0.3f ns",
                      i, first_ck_off[i], first_ck90_off[i]);
        end
        chk((first_ck_off[0]  < first_ck_off[1]+0.15) && (first_ck_off[0]  > first_ck_off[1]-0.15) &&
            (first_ck90_off[0] < first_ck90_off[1]+0.15) && (first_ck90_off[0] > first_ck90_off[1]-0.15) &&
            (first_ck90_off[2] < first_ck90_off[3]+0.15) && (first_ck90_off[2] > first_ck90_off[3]-0.15),
            "check1: first-edge times deterministic across reruns");
        tmo_cnt = 0;
        while (!(lockB === 1'b1) && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(lockB === 1'b1, "check1: uB relocked after reruns");
        #50;

        // ---- check 7: fail-closed ----
        pll_locked = 1'b0;
        #10;   // well within one CK cycle (10 ns)
        chk((ckA === 1'b0) && (ck90A === 1'b0) && (sysA === 1'b0),
            "check7: uA outputs low within one CK cycle of unlock");
        chk((ckB === 1'b0) && (ck90B === 1'b0) && (sysB === 1'b0),
            "check7: uB outputs low within one CK cycle of unlock");
        chk((lockA === 1'b0) && (lockB === 1'b0),
            "check7: PHY_LOCKED low same cycle");
        chk((errA === 1'b1) && (errB === 1'b1),
            "check7: ERR sticky set");
        $display("check7 debug: errA=%b errB=%b dbgA=%b dbgB=%b", errA, errB, dbgA, dbgB);
        $fdisplay(fd, "check7 debug: errA=%b errB=%b dbgA=%b dbgB=%b", errA, errB, dbgA, dbgB);
        // outputs stay low even if PLL_LOCKED returns (documented: until RST)
        pll_locked = 1'b1;
        #300;
        chk((ckA === 1'b0) && (ck90A === 1'b0) && (lockA === 1'b0),
            "check7: outputs stay low after PLL_LOCKED returns (until RST)");
        // BLOCKER 4: the DLL itself must re-acquire once PLL_LOCKED returns.
        tmo_cnt = 0;
        while (!(dbgB[11] === 1'b1) && tmo_cnt < 100000) begin #100; tmo_cnt = tmo_cnt + 100; end
        chk(dbgB[11] === 1'b1, "check7: B DLL re-acquires after PLL returns");
        // RST clears ERR and allows relock
        @(posedge mck); #1;
        rst = 1'b1; #30; @(posedge mck); #1; rst = 1'b0;
        tmo_cnt = 0;
        while (!lockA && tmo_cnt < 5000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(lockA && (errA === 1'b0), "check7: relock after RST, ERR cleared");
        tmo_cnt = 0;
        while (!lockB && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(lockB && (errB === 1'b0), "check7: uB relock after RST");
        #200;

        // ---- check 11: DLL acquisition timeout (BLOCKER 2) ----
        dllt_rst = 1'b1; #50; dllt_rst = 1'b0;
        #3000;
        chk(dllt_err === 1'b1, "check11: DLL acquisition timeout sets DLL_ERR");
        chk(dllt_locked === 1'b0, "check11: DLL not locked on timeout");
        $display("check11: timeout instance code=%0d err=%b locked=%b",
                 dllt_code, dllt_err, dllt_locked);
        $fdisplay(fd, "check11: timeout instance code=%0d err=%b locked=%b",
                  dllt_code, dllt_err, dllt_locked);

        // ---- check 10: phase-measurement loss (large permanent offset) ----
        dllv_rst = 1'b1; #50; dllv_rst = 1'b0;
        tmo_cnt = 0;
        while (!(dllv_locked === 1'b1) && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(dllv_locked === 1'b1, "check10: loss-test DLL acquires at 10 ns");
        $display("check10: locked code=%0d", dllv_code);
        $fdisplay(fd, "check10: locked code=%0d", dllv_code);
        // code 45 -> master delay 9024 ps -> -976 ps master (-244 ps CK90),
        // beyond LOSS_TOL=640 ps.  Forced permanently, so the measured phase
        // sustains the violation and loss must fire from the TDC, not from
        // a direction-run heuristic.
        force uDLLV.code_q = 9'd45;
        #1500;
        chk((uDLLV.phase_ps > 800) || (uDLLV.phase_ps < -800),
            "check10: measured phase beyond LOSS_TOL");
        chk(dllv_err === 1'b1, "check10: sustained phase error sets DLL_ERR");
        chk(dllv_locked === 1'b0, "check10: loss-of-lock clears DLL_LOCKED");
        $display("check10: phase_ps=%0d code=%0d err=%b locked=%b",
                 uDLLV.phase_ps, dllv_code, dllv_err, dllv_locked);
        $fdisplay(fd, "check10: phase_ps=%0d code=%0d err=%b locked=%b",
                  uDLLV.phase_ps, dllv_code, dllv_err, dllv_locked);
        release uDLLV.code_q;
        #200;

        // ---- check 14: droop survival (legitimate 8-LSB step) ----------
        // +8 CODE-LSB equivalent cell-delay shift = +512 ps master
        // (+128 ps CK90).  The loop needs ~8 one-LSB corrections.  This is
        // the exact scenario the old run-length rule false-tripped on.
        dllv_rst = 1'b1; #50; dllv_rst = 1'b0;
        tmo_cnt = 0;
        while (!(dllv_locked === 1'b1) && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(dllv_locked === 1'b1, "check14: DLL relocks before droop");
        code_before = dllv_code;
        force uDLLV.dly_off_x4 = 32'd8;
        #3000;
        code_after = dllv_code;
        chk(dllv_locked === 1'b1, "check14: 8-LSB droop keeps lock (no false loss)");
        chk(dllv_err === 1'b0, "check14: 8-LSB droop does NOT set ERR");
        chk((uDLLV.phase_ps < 300) && (uDLLV.phase_ps > -300),
            "check14: loop slewed phase back into tolerance");
        chk(code_after <= code_before-4, "check14: loop compensated the droop");
        $display("check14: code %0d -> %0d, phase_ps=%0d, lock=%b err=%b",
                 code_before, code_after, uDLLV.phase_ps, dllv_locked, dllv_err);
        $fdisplay(fd, "check14: code %0d -> %0d, phase_ps=%0d, lock=%b err=%b",
                  code_before, code_after, uDLLV.phase_ps, dllv_locked, dllv_err);
        release uDLLV.dly_off_x4;
        uDLLV.dly_off_x4 = 32'd0;  // release on a REG keeps the forced value
                                    // (no RTL driver to restore it); re-zero
        #1000;

        // ---- check 15: slow drift walking code outside old [40,80] ------
        // Ramp the cell-law offset so the loop must move the code below the
        // deleted CODE_LOCK_MIN=40.  Phase stays in tolerance each step, so
        // lock must NOT clear (the old window would have false-lost).
        dllv_rst = 1'b1; #50; dllv_rst = 1'b0;
        tmo_cnt = 0;
        while (!(dllv_locked === 1'b1) && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(dllv_locked === 1'b1, "check15: DLL relocks before drift");
        code_before = dllv_code;
        for (dstep = 1; dstep <= 48; dstep = dstep + 1) begin
            force uDLLV.dly_off_x4 = dstep;
            #200;
        end
        code_after = dllv_code;
        chk(dllv_locked === 1'b1, "check15: drift outside old code window keeps lock");
        chk(dllv_err === 1'b0, "check15: drift outside old window does NOT set ERR");
        chk(code_after < 40, "check15: code walked below old CODE_LOCK_MIN=40");
        $display("check15: code %0d -> %0d, phase_ps=%0d, lock=%b err=%b",
                 code_before, code_after, uDLLV.phase_ps, dllv_locked, dllv_err);
        $fdisplay(fd, "check15: code %0d -> %0d, phase_ps=%0d, lock=%b err=%b",
                  code_before, code_after, uDLLV.phase_ps, dllv_locked, dllv_err);
        release uDLLV.dly_off_x4;
        uDLLV.dly_off_x4 = 32'd0;  // release on a REG keeps the forced value
                                    // (no RTL driver to restore it); re-zero
        #500;

        // ---- check 16: real loss beyond correction range -----------------
        dllv_rst = 1'b1; #50; dllv_rst = 1'b0;
        tmo_cnt = 0;
        while (!(dllv_locked === 1'b1) && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(dllv_locked === 1'b1, "check16: DLL relocks before real-loss test");
        force uDLLV.dly_off_x4 = 32'd200;   // +12800 ps master, unreachable
        #3000;
        chk(dllv_err === 1'b1, "check16: beyond-range offset sets DLL_ERR");
        chk(dllv_locked === 1'b0, "check16: beyond-range offset clears lock");
        $display("check16: phase_ps=%0d code=%0d err=%b locked=%b",
                 uDLLV.phase_ps, dllv_code, dllv_err, dllv_locked);
        $fdisplay(fd, "check16: phase_ps=%0d code=%0d err=%b locked=%b",
                  uDLLV.phase_ps, dllv_code, dllv_err, dllv_locked);
        release uDLLV.dly_off_x4;
        uDLLV.dly_off_x4 = 32'd0;  // release on a REG keeps the forced value
                                    // (no RTL driver to restore it); re-zero
        #200;

        // ---- check 17: BLOCKER 3 boundary — beyond-spec but CORRECTABLE
        // step must still fail closed.  dly_off_x4=16 -> +1024 ps master
        // (+256 ps CK90): past LOSS_TOL=640 and past the 200 ps hard spec,
        // yet recoverable in 16 one-LSB corrections.  The old 800/24 pair
        // would have ridden it out with PHY_LOCKED high for ~240 ns; with
        // LOSS_TOL=640/LOSS_N=3 the loop can move at most 3*64=192 ps in
        // the trip window, so it cannot pull the phase back into band
        // first -> ERR must assert and lock must drop fast.
        dllv_rst = 1'b1; #50; dllv_rst = 1'b0;
        tmo_cnt = 0;
        while (!(dllv_locked === 1'b1) && tmo_cnt < 20000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(dllv_locked === 1'b1, "check17: DLL relocks before boundary test");
        force uDLLV.dly_off_x4 = 32'd16;   // +1024 ps master (+256 ps CK90)
        #400;                              // 40 CK cycles >> LOSS_N=3 (~30 ns)
        chk(dllv_err === 1'b1,
            "check17: beyond-spec step sets DLL_ERR (fail-closed)");
        chk(dllv_locked === 1'b0,
            "check17: lock drops within LOSS_N (not ridden out)");
        $display("check17: phase_ps=%0d code=%0d err=%b locked=%b",
                 uDLLV.phase_ps, dllv_code, dllv_err, dllv_locked);
        $fdisplay(fd, "check17: phase_ps=%0d code=%0d err=%b locked=%b",
                  uDLLV.phase_ps, dllv_code, dllv_err, dllv_locked);
        release uDLLV.dly_off_x4;
        uDLLV.dly_off_x4 = 32'd0;  // release on a REG keeps the forced value
                                    // (no RTL driver to restore it); re-zero
        #200;

        // ---- check 12: CK90 phase monitor (BLOCKER 6) ----
        // Force CK90 high at CK rise for several CK cycles.  The monitor must
        // flag it (N consecutive failures), set ERR and drop the lock.
        force uA.ck90_sel = 1'b1;
        repeat (12) @(posedge mck);
        release uA.ck90_sel;
        #20;
        chk((errA === 1'b1) && (lockA === 1'b0),
            "check12: CK90 phase monitor sets ERR and drops lock");
        $display("check12: after force errA=%b lockA=%b mon_err=%b",
                 errA, lockA, uA.ck90_mon_err);
        $fdisplay(fd, "check12: after force errA=%b lockA=%b mon_err=%b",
                  errA, lockA, uA.ck90_mon_err);
        // RST clears it again
        @(posedge mck); #1; rst = 1'b1; #30;
        @(posedge mck); #1; rst = 1'b0;
        tmo_cnt = 0;
        while (!lockA && tmo_cnt < 5000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(lockA && (errA === 1'b0), "check12: RST clears monitor ERR, relocks");

        // ---- check 18: BLOCKER 2 — 180-degree inverse must be rejected ----
        // The old two-sample monitor (low at CK rise, high at CK fall) is
        // satisfied by BOTH the correct 90-degree lag and the forbidden
        // 180-degree inverse, so an inverted CK90 passed silently.  Inject
        // ck90_sel = ~ck_a through the ck90_inv_tb scaffolding (a literal
        // `force ck90_sel = ~ck_a` is unusable: iverilog evaluates a force
        // RHS once).  Samples 1+2 still pass; only the third sample
        // (CK-rise + 2.8 ns, where a real 90-degree CK90 reads HIGH and
        // the inverse reads LOW) fails -> ERR must set and lock must drop.
        uA.ck90_inv_tb = 1'b1;
        repeat (12) @(posedge mck);
        #20;
        chk((errA === 1'b1) && (lockA === 1'b0),
            "check18: 180-deg inverse CK90 sets ERR and drops lock");
        chk(uA.ck90_mon_err === 1'b1,
            "check18: caught by the monitor (third-sample reject)");
        $display("check18: after 180-deg inject errA=%b lockA=%b mon_err=%b",
                 errA, lockA, uA.ck90_mon_err);
        $fdisplay(fd, "check18: after 180-deg inject errA=%b lockA=%b mon_err=%b",
                  errA, lockA, uA.ck90_mon_err);
        uA.ck90_inv_tb = 1'b0;
        // RST clears the sticky ERR and the path relocks clean.
        @(posedge mck); #1; rst = 1'b1; #30;
        @(posedge mck); #1; rst = 1'b0;
        tmo_cnt = 0;
        while (!lockA && tmo_cnt < 5000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(lockA && (errA === 1'b0),
            "check18: RST clears 180-deg ERR, relocks clean");

        // ---- check 13: DCC-lock loss fail-closed (BLOCKER 5) ----
        tmo_cnt = 0;
        while (!(lockC === 1'b1) && tmo_cnt < 200000) begin #100; tmo_cnt = tmo_cnt + 100; end
        chk(lockC === 1'b1, "check13: uC DCC path locks");
        #200;
        force uC.g_dcc.u_dcc.locked_r = 1'b0;
        #200;   // > DCC_LOSS_DBC_CY MCK cycles
        chk((lockC === 1'b0) && (ckC === 1'b0),
            "check13: DCC-lock loss drops PHY_LOCKED (fail-closed)");
        release uC.g_dcc.u_dcc.locked_r;
        #100;
        force uC.g_dcc.u_dcc.lost_r = 1'b1;
        #100;
        release uC.g_dcc.u_dcc.lost_r;
        #50;
        chk(errC === 1'b1, "check13: DCC_ERR arms sticky ERR");
        $display("check13: after loss lockC=%b errC=%b dcc_locked=%b dcc_err=%b",
                 lockC, errC, dbgC[9], dbgC[8]);
        $fdisplay(fd, "check13: after loss lockC=%b errC=%b dcc_locked=%b dcc_err=%b",
                  lockC, errC, dbgC[9], dbgC[8]);

        // ---- check 8: bypass ----
        // (c) BYPASS must change during reset; commit it there.
        @(posedge mck); rst = 1'b1; bypass = 1'b1; pll_locked = 1'b0; #200;
        @(posedge mck); #1; rst = 1'b0;
        #50;
        // (a) outputs gated low until the bypass-lock latch arms
        chk((ckA === 1'b0) && (ckAn === 1'b0) && (lockA === 1'b0),
            "check8: bypass outputs gated low before bypass lock");
        #300;  // bypass debounce (8 EXT_SYS_CLK cycles) + bgo release
        chk(lockA === 1'b1, "check8: bypass PHY_LOCKED high (PLL-independent)");
        chk((ckA === ext_ck) && (ckAn === ~ext_ck) &&
            (ck90A === ext_ck90_r) && (sysA === ext_sys),
            "check8: uA outputs follow EXT pins (gated)");
        chk((ckB === ext_ck) && (ck90B === ext_ck90_r) && (sysB === ext_sys),
            "check8: uB outputs follow EXT pins (gated)");
        // with bypass on, drop the PLL: ERR must NOT be armed
        pll_locked = 1'b0;
        #100;
        chk((errA === 1'b0) && (lockA === 1'b1) && (ckA === ext_ck),
            "check8: bypass keeps clocks/lock with PLL down, ERR not armed");
        // (c) BYPASS change outside reset is ignored
        bypass = 1'b0;
        #300;
        chk((ckA === ext_ck) && (lockA === 1'b1),
            "check8: BYPASS change outside reset ignored");
        // leave bypass properly: change BYPASS during reset
        @(posedge mck); rst = 1'b1; bypass = 1'b0; pll_locked = 1'b1; #200;
        @(posedge mck); #1; rst = 1'b0;
        tmo_cnt = 0;
        while (!lockA && tmo_cnt < 5000) begin #10; tmo_cnt = tmo_cnt + 10; end
        chk(lockA, "check8: on-chip path relocks after bypass reset");
        // (d) first SYS_CLK pulse after relock is a full CK-aligned pulse
        // (SYS is 50 MHz / 50% duty: one CK period high per 2 CK periods)
        @(posedge sysA); t1 = $realtime;
        @(negedge sysA); t2 = $realtime;
        chk((t2 - t1 > 9.5) && (t2 - t1 < 10.5),
            "check8: first SYS_CLK pulse after relock is full width");
        $display("check8: first post-bypass SYS pulse width = %0.2f ns", t2 - t1);
        $fdisplay(fd, "check8: first post-bypass SYS pulse width = %0.2f ns", t2 - t1);

        $display("SUMMARY: %0d checks, %0d errors", checks, errors);
        $fdisplay(fd, "SUMMARY: %0d checks, %0d errors", checks, errors);
        $fflush(fd);
        $fclose(fd);
        if (errors != 0) begin
            $display("RESULT: FAIL");
            $fatal(1, "ddr1_clock_top_tb FAILED");
        end else begin
            $display("RESULT: PASS");
            $finish;
        end
    end
endmodule
