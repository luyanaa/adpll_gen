`timescale 1ns/1ps
// Self-checking focused testbench for the TDC-honest phase measurement in
// DDR1_CK90_DLL (2026-11-28 rewrite: modulo-T folding + tap quantization).
//
// Three parallel instances, identical except TDC_STEP_PS in {45, 65, 100}
// — the measured sg13g2 FINE_DELAY_CELL tap delays at FF/TT/SS
// (flow/sta/run_ddr1_dqs_corners.sh) — so every check is a corner
// quantization sweep.
//
// Checks:
//   1. acquisition: all instances lock within 5 us, no ERR
//   2. quantization: locked phase_ps is always a whole number of taps
//   3. post-lock dither: code keeps moving (bang-bang alive)
//   4. +512 ps master step (x4 = 8): no false loss trip at ANY corner
//      quantization (worst case: SS 100 ps taps fold the 640 ps loss band
//      down to 600 ps — 512 must still fit), code decreases (correct sign)
//   5. release of the step: code increases back (opposite sign correct)
//   6. +1024 ps master step (x4 = 16): DLL_ERR trips within ~5
//      measurements at all quantizations (fail-closed, sticky)
//   7. modulo aliasing: after reset/re-acquire, force +6016 ps master
//      (x4 = 94) — the residual folds to -3984 ps, so phase_ps must read
//      NEGATIVE (alias demonstrated) and the wrong-way walk must still be
//      caught fail-closed: DLL_ERR trips.
//
// Run:
//   iverilog -g2012 -DSIMULATION -o /tmp/opencode/ddr1_dll_tdc.vvp \
//     src/ddr1_ck90_dll_tdc_tb.v src/ddr1_ck90_dll.v
//   vvp /tmp/opencode/ddr1_dll_tdc.vvp   (exit nonzero on any failure)

module ddr1_ck90_dll_tdc_tb;
    localparam integer TCK_NS = 10;   // 100 MHz CKIN

    reg ckin = 1'b0;
    reg rst  = 1'b1;
    always #(TCK_NS/2.0) ckin = ~ckin;

    integer errors = 0;
    integer checks = 0;
    integer fd;

    wire ck90_45,  locked_45,  err_45;
    wire ck90_65,  locked_65,  err_65;
    wire ck90_100, locked_100, err_100;
    wire [8:0] code_45, code_65, code_100;

    DDR1_CK90_DLL #(.TDC_STEP_PS(45)) u45 (
        .CKIN(ckin), .RST(rst), .EN(1'b1),
        .CK90(ck90_45), .DLL_LOCKED(locked_45), .DLL_ERR(err_45),
        .DBG_CODE(code_45));
    DDR1_CK90_DLL #(.TDC_STEP_PS(65)) u65 (
        .CKIN(ckin), .RST(rst), .EN(1'b1),
        .CK90(ck90_65), .DLL_LOCKED(locked_65), .DLL_ERR(err_65),
        .DBG_CODE(code_65));
    DDR1_CK90_DLL #(.TDC_STEP_PS(100)) u100 (
        .CKIN(ckin), .RST(rst), .EN(1'b1),
        .CK90(ck90_100), .DLL_LOCKED(locked_100), .DLL_ERR(err_100),
        .DBG_CODE(code_100));

    task chk(input cond, input [8*72-1:0] name);
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

    integer tmo;
    integer c0_45, c0_65, c0_100;
    integer ph45, ph65, ph100;
    integer ch45, ch65, ch100;
    integer k;
    integer nchange45, nchange65, nchange100;
    reg [8:0] prev45, prev65, prev100;

    // count code changes over a window
    task count_dither(input integer ncyc, output integer n45, output integer n65, output integer n100);
        integer j;
        begin
            n45 = 0; n65 = 0; n100 = 0;
            prev45 = code_45; prev65 = code_65; prev100 = code_100;
            for (j = 0; j < ncyc; j = j + 1) begin
                @(posedge ckin); #0.001;
                if (code_45  !== prev45)  begin n45  = n45  + 1; prev45  = code_45;  end
                if (code_65  !== prev65)  begin n65  = n65  + 1; prev65  = code_65;  end
                if (code_100 !== prev100) begin n100 = n100 + 1; prev100 = code_100; end
            end
        end
    endtask

    initial begin
        fd = $fopen("sim/outputs/ddr1/ddr1_ck90_dll_tdc_tb.log", "w");
        $display("=== DDR1_CK90_DLL TDC TB start ===");

        // ---------------- acquisition ----------------
        rst = 1'b1;
        #(3*TCK_NS);
        rst = 1'b0;
        tmo = 0;
        while (!(locked_45 && locked_65 && locked_100) && tmo < 5000) begin
            #10; tmo = tmo + 10;
        end
        chk(locked_45 && locked_65 && locked_100,
            "check1: all corners (45/65/100ps taps) lock within 5 us");
        chk(!err_45 && !err_65 && !err_100,
            "check1b: no ERR during acquisition");
        $display("check1: lock time ~%0d ns", tmo);

        #(20*TCK_NS);

        // ---------------- quantization correctness ----------------
        ph45  = u45.phase_ps;  ph65  = u65.phase_ps;  ph100 = u100.phase_ps;
        chk((ph45  % 45  == 0) || (-ph45  % 45  == 0),
            "check2a: FF-tap instance phase is tap-quantized");
        chk((ph65  % 65  == 0) || (-ph65  % 65  == 0),
            "check2b: TT-tap instance phase is tap-quantized");
        chk((ph100 % 100 == 0) || (-ph100 % 100 == 0),
            "check2c: SS-tap instance phase is tap-quantized");
        $display("check2: phases %0d/%0d/%0d ps", ph45, ph65, ph100);

        // ---------------- post-lock dither ----------------
        count_dither(40, nchange45, nchange65, nchange100);
        chk(nchange45 >= 2 && nchange65 >= 2 && nchange100 >= 2,
            "check3: post-lock bang-bang dither alive at all corners");

        // ---------------- +512 ps master step: no false trip, correct sign
        c0_45 = code_45; c0_65 = code_65; c0_100 = code_100;
        force u45.dly_off_x4  = 32'd8;
        force u65.dly_off_x4  = 32'd8;
        force u100.dly_off_x4 = 32'd8;
        #(1500);
        chk(!err_45 && !err_65 && !err_100,
            "check4a: +512ps master step causes NO false loss trip (all taps)");
        chk(locked_45 && locked_65 && locked_100,
            "check4b: lock retained through +512ps step (all taps)");
        chk(code_45 < c0_45 && code_65 < c0_65 && code_100 < c0_100,
            "check4c: code DECREASES for positive (late) phase — sign correct");
        $display("check4: code %0d->%0d / %0d->%0d / %0d->%0d",
                 c0_45, code_45, c0_65, code_65, c0_100, code_100);

        // ---------------- release: opposite sign ----------------
        release u45.dly_off_x4;  u45.dly_off_x4  = 32'd0;
        release u65.dly_off_x4;  u65.dly_off_x4  = 32'd0;
        release u100.dly_off_x4; u100.dly_off_x4 = 32'd0;
        #(1500);
        chk(code_45 > c0_45 - 9'd12 && code_65 > c0_65 - 9'd12 && code_100 > c0_100 - 9'd12,
            "check5: after release code increases back toward pre-step value");
        chk(!err_45 && !err_65 && !err_100,
            "check5b: still no ERR after full droop/recovery cycle");

        // ---------------- +1024 ps master step: fail-closed trip ----------------
        force u45.dly_off_x4  = 32'd16;
        force u65.dly_off_x4  = 32'd16;
        force u100.dly_off_x4 = 32'd16;
        #(500);
        chk(err_45 && err_65 && err_100,
            "check6: +1024ps master step trips DLL_ERR at all quantizations");
        chk(!locked_45 && !locked_65 && !locked_100,
            "check6b: DLL_LOCKED drops with the loss trip");
        release u45.dly_off_x4;  u45.dly_off_x4  = 32'd0;
        release u65.dly_off_x4;  u65.dly_off_x4  = 32'd0;
        release u100.dly_off_x4; u100.dly_off_x4 = 32'd0;
        #(100);
        chk(err_45 && err_65 && err_100,
            "check6c: ERR is sticky after the step is removed");

        // ---------------- modulo aliasing demonstration ----------------
        // reset and re-acquire
        rst = 1'b1; #(3*TCK_NS);
        rst = 1'b0;
        tmo = 0;
        while (!(locked_45 && locked_65 && locked_100) && tmo < 5000) begin
            #10; tmo = tmo + 10;
        end
        chk(locked_45 && locked_65 && locked_100 && !err_45,
            "check7a: re-acquisition after reset, ERR cleared");
        // force +6016 ps master: folds to -3984 -> aliased negative sign
        force u45.dly_off_x4  = 32'd94;
        force u65.dly_off_x4  = 32'd94;
        force u100.dly_off_x4 = 32'd94;
        #(150);
        ph45 = u45.phase_ps; ph65 = u65.phase_ps; ph100 = u100.phase_ps;
        chk(ph45 < -2500 && ph65 < -2500 && ph100 < -2500,
            "check7b: +6016ps master aliases to a LARGE NEGATIVE measured phase (modulo-T)");
        $display("check7: aliased phases %0d/%0d/%0d ps (raw +6016 folds to -3984)",
                 ph45, ph65, ph100);
        #(500);
        chk(err_45 && err_65 && err_100,
            "check7c: aliased wrong-way walk is still caught fail-closed (DLL_ERR)");

        $fdisplay(fd, "SUMMARY: %0d checks, %0d errors", checks, errors);
        $display("=== TB done, %0d checks, errors=%0d ===", checks, errors);
        $fclose(fd);
        if (errors != 0) $fatal(1, "ddr1_ck90_dll_tdc_tb FAILED");
        $finish;
    end

    initial begin
        #(200_000);
        $display("FAIL: global timeout");
        $fatal(1, "watchdog");
    end
endmodule
