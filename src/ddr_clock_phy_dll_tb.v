// Route B PHY-level DLL test: uniform 200 MHz input -> DCC -> full-period DLL
// -> selector -> CK_PHY.
//
// Unlike ddr_clock_phy_integration_tb (raw fractional-divider OUT_DIV, whose
// edge spacing is not uniform), this test uses the PHY's contract input: a
// uniform clock.  It checks that the DLL LOCKED flag corresponds to a real
// one-period phase and that the fail-closed output gate still works.
//
// Behavioral DCDL/pad models only; not PVT, PEX or jitter signoff.
`timescale 1ns/1ps

module ddr_clock_phy_dll_tb;
    localparam real TCLK = 5.0;       // 200 MHz
    localparam real DUTY_IN = 0.30;
    localparam integer SEL_TAP = 0;

    reg CK_IN = 1'b1;
    initial begin
        forever begin
            #(TCLK * DUTY_IN)          CK_IN = 1'b0;
            #(TCLK * (1.0 - DUTY_IN))  CK_IN = 1'b1;
        end
    end

    reg TICK = 1'b0;
    reg DLL_TICK = 1'b0;
    reg SAMP = 1'b0;
    always #0.5   TICK = ~TICK;       // 1 GHz loop clock
    always #0.05  DLL_TICK = ~DLL_TICK; // 10 GHz DLL TDC
    always #0.555 SAMP = ~SAMP;

    reg RST_N = 1'b0;
    reg PLL_LOCKED = 1'b0;
    reg DCC_EN = 1'b0, DLL_EN = 1'b0;
    reg [15:0] DCC_KI = 16'd1;
    reg [7:0] DUTY_OFFS = 8'd0, DUTY_INIT = 8'd0;
    reg [3:0] SEL_REQ = SEL_TAP;
    reg SEL_UPD = 1'b0;

    wire CK_DCC, CK_DLL, CK_PATH, CK_SEL, CK_PHY, CK_PHY_N;
    wire DCC_LOCKED, DLL_LOCKED, PHY_LOCKED;
    wire DCC_ERR, DLL_ERR, ERR;
    wire [7:0] DUTY_CODE;
    wire [8:0] DLY_CODE;
    wire [3:0] SEL_CUR;
    wire BUSY;

    DDR_CLOCK_PHY #(
        .DCC_COARSE_NDELS(15), .DCC_MID_NDELS(15), .DCC_FINE_NDELS(31),
        .FILTER_BITS(16),
        .DCC_LOCK_COUNT(16), .DLL_LOCK_COUNT(16),
        .DLL_T0_PS(2930), .DLL_STEP_PS(35),
        .DLL_CODE_MIN(20), .DLL_CODE_MAX(170), .DLL_CODE_INIT(55),
        .NTAPS(16), .SEL_BITS(4), .DEAD_TICKS(2),
        .USE_DLL(1)
    ) dut (
        .CK_IN(CK_IN), .PLL_LOCKED(PLL_LOCKED), .RST_N(RST_N),
        .TICK(TICK), .DLL_TICK(DLL_TICK), .SAMP(SAMP),
        .DCC_EN(DCC_EN), .DLL_EN(DLL_EN),
        .DCC_KI(DCC_KI), .DLL_KI(16'd1),
        .DUTY_OFFS(DUTY_OFFS), .DUTY_INIT(DUTY_INIT),
        .DLL_PHASE_OFFS(8'd0), .DLY_INIT(8'd0),
        .SEL_REQ(SEL_REQ), .SEL_UPD(SEL_UPD),
        .CK_DCC(CK_DCC), .CK_DLL(CK_DLL), .CK_PATH(CK_PATH),
        .CK_SEL(CK_SEL), .CK_PHY(CK_PHY), .CK_PHY_N(CK_PHY_N),
        .DCC_LOCKED(DCC_LOCKED), .DLL_LOCKED(DLL_LOCKED),
        .PHY_LOCKED(PHY_LOCKED),
        .DCC_ERR(DCC_ERR), .DLL_ERR(DLL_ERR), .ERR(ERR),
        .DUTY_CODE(DUTY_CODE), .DLY_CODE(DLY_CODE),
        .SEL_CUR(SEL_CUR), .BUSY(BUSY)
    );

    integer errors = 0;
    integer k;

    initial begin
        repeat (8) @(posedge CK_IN);
        RST_N = 1'b1;
        // The PHY gates the DLL with PLL_LOCKED so the period measurement is
        // taken on the final frequency.
        PLL_LOCKED = 1'b1;
        repeat (4) @(posedge TICK);
        SEL_UPD = 1'b1;
        @(posedge TICK);
        SEL_UPD = 1'b0;
        repeat (6) @(posedge TICK);
        if (BUSY || SEL_CUR != SEL_TAP) begin
            $display("FAIL: selector did not settle, BUSY=%b SEL_CUR=%0d",
                     BUSY, SEL_CUR);
            errors = errors + 1;
        end

        DCC_EN = 1'b1;
        DLL_EN = 1'b1;
        k = 0;
        while (!(DCC_LOCKED && DLL_LOCKED) && k < 200000) begin
            @(posedge TICK);
            k = k + 1;
        end
        $display("ddr_clock_phy_dll: after %0d TICK DCC_LOCKED=%b DLL_LOCKED=%b DLY_CODE=%0d DCC_ERR=%b DLL_ERR=%b",
                 k, DCC_LOCKED, DLL_LOCKED, DLY_CODE, DCC_ERR, DLL_ERR);

        repeat (2000) @(posedge TICK);

        if (DLL_LOCKED !== 1'b1) begin
            $display("FAIL: full-period DLL did not lock on the uniform 200 MHz input");
            errors = errors + 1;
        end
        if (PHY_LOCKED !== 1'b1) begin
            $display("FAIL: PHY_LOCKED low, DCC=%b DLL=%b BUSY=%b",
                     DCC_LOCKED, DLL_LOCKED, BUSY);
            errors = errors + 1;
        end

        // The lock flag must correspond to a real one-period phase.
        begin : dll_phase
            real t0, t1, period, delay, modp;
            @(posedge CK_DCC); t0 = $realtime;
            @(posedge CK_DCC); t1 = $realtime; period = t1 - t0;
            @(posedge CK_DCC); t0 = $realtime;
            @(posedge CK_DLL); t1 = $realtime; delay = t1 - t0;
            modp = delay;
            while (modp >= period) modp = modp - period;
            $display("ddr_clock_phy_dll: DLL delay=%0.3f ns period=%0.3f ns mod=%0.3f ns code=%0d",
                     delay, period, modp, DLY_CODE);
            if (modp > 0.25 && modp < period - 0.25) begin
                $display("FAIL: DLL_LOCKED but CK_DLL is not at a full-period phase");
                errors = errors + 1;
            end
        end

        begin : duty
            real t0, th, tl;
            @(posedge CK_PHY); t0 = $realtime;
            @(negedge CK_PHY); th = $realtime - t0;
            @(posedge CK_PHY); tl = $realtime - (t0 + th);
            $display("ddr_clock_phy_dll: CK_PHY high=%0.3f low=%0.3f period=%0.3f duty=%0.1f%%",
                     th, tl, th + tl, 100.0 * th / (th + tl));
            if (th + tl < TCLK - 0.1 || th + tl > TCLK + 0.1) begin
                $display("FAIL: CK_PHY period outside the input period");
                errors = errors + 1;
            end
            if (100.0 * th / (th + tl) < 45.0 ||
                100.0 * th / (th + tl) > 55.0) begin
                $display("FAIL: CK_PHY duty outside 45-55%%");
                errors = errors + 1;
            end
        end

        // Fail-closed contract.
        PLL_LOCKED = 1'b0;
        #0.1;
        if (CK_PHY !== 1'b0 || CK_PHY_N !== 1'b0) begin
            $display("FAIL: CK_PHY/CK_PHY_N did not fail closed, %b/%b",
                     CK_PHY, CK_PHY_N);
            errors = errors + 1;
        end
        repeat (4) @(posedge CK_IN);
        if (CK_PHY !== 1'b0) begin
            $display("FAIL: CK_PHY not held low while PLL unlocks");
            errors = errors + 1;
        end

        if (errors != 0) $fatal(1, "ddr_clock_phy_dll_tb failed");
        $display("ddr_clock_phy_dll_tb: PASS");
        $finish;
    end
endmodule
