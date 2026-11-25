// ADPLL -> divider -> DDR clock PHY path integration smoke.
//
// The macro's FREQ_LOCKED is a frequency-acquisition flag, not full LOCKED
// (the behavioral SS-BBPD/fine loop still saturates).  This test therefore
// proves connectivity and a running 200 MHz-class PHY clock, not phase
// lock, pad duty or PVT.  The raw OUT_DIV is used because CK is gated by the
// full LOCKED flag.
`timescale 1ns/1ps

module ddr_clock_phy_integration_tb;
    localparam integer FILTER_BITS = 16;
    localparam integer FCW_BITS = 8;
    localparam integer DIV_BITS = 8;
    localparam integer SEL_TAP = 4;
    localparam real TAP_PS = 60.0;
    // The raw OUT_DIV is a fractional-divider clock: its edge spacing is not
    // uniform, so a one-period DLL has no valid code and correctly refuses to
    // lock.  This test therefore checks the selector path.  The DLL PHY path
    // is verified in ddr_clock_phy_dll_tb with a uniform 200 MHz reference.
    localparam integer USE_DLL = 0;

    reg REF = 1'b0;
    always #5 REF = ~REF;            // 100 MHz
    reg RST_N = 1'b1;
    reg INJ_EN = 1'b0;
    reg [FILTER_BITS-1:0] KP = 16'd3967;
    reg [FILTER_BITS-1:0] KI = 16'd257;
    reg [FCW_BITS-1:0] FCW = 8'd16;
    reg DSM_EN_DT = 1'b0, DSM_EN_SHDT = 1'b1;
    reg [1:0] DSM_ORDER = 2'b00;
    reg [DIV_BITS-1:0] SET_DIV = 8'd8;
    reg LOAD_DIV = 1'b0;

    wire OUT, OUT_DIV, LOCKED, ERR;
    pll_macro_top #(
        .COARSE_NDELS(15), .MID_NDELS(15), .FINE_NDELS(31),
        .FILTER_BITS(FILTER_BITS),
        .IS_DSM(1), .DSM_DIV(2),
        .LOCKED_WAIT(64), .FILTER_ILL(16), .LOCK_WINDOW(1),
        .DIV_BITS(DIV_BITS), .DIV_INIT(8),
        .FCW_BITS(FCW_BITS)
    ) u_pll (
        .REF(REF), .RST_N(RST_N), .INJ_EN(INJ_EN),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT),
        .DSM_ORDER(DSM_ORDER),
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV),
        .OUT_DIV(OUT_DIV), .CK(),
        .LOCKED(LOCKED), .ERR(ERR), .OUT(OUT)
    );

    reg TICK = 1'b0;
    reg DLL_TICK = 1'b0;
    reg SAMP = 1'b0;
    always #0.5 TICK = ~TICK;
    always #0.05 DLL_TICK = ~DLL_TICK;   // 10 GHz DLL TDC
    always #0.850 SAMP = ~SAMP;

    reg [3:0] SEL_REQ = SEL_TAP;
    reg SEL_UPD = 1'b0;
    reg DCC_EN = 1'b0;

    wire CK_DCC, CK_DLL, CK_PATH, CK_SEL, CK_PHY, CK_PHY_N;
    wire DCC_LOCKED, DLL_LOCKED, PHY_LOCKED;
    wire DCC_ERR, DLL_ERR, PHY_ERR;
    wire [7:0] DUTY_CODE;
    wire [8:0] DLY_CODE;
    wire [3:0] SEL_CUR;
    wire BUSY;

    DDR_CLOCK_PHY #(
        .DCC_COARSE_NDELS(15), .DCC_MID_NDELS(15), .DCC_FINE_NDELS(31),
        .DLL_COARSE_NDELS(15), .DLL_MID_NDELS(15), .DLL_FINE_NDELS(31),
        .FILTER_BITS(FILTER_BITS),
        .NTAPS(16), .SEL_BITS(4), .DEAD_TICKS(2),
        .USE_DLL(USE_DLL)
    ) u_phy (
        .CK_IN(OUT_DIV),
        .PLL_LOCKED(u_pll.LOCKED),
        .RST_N(RST_N), .TICK(TICK), .DLL_TICK(DLL_TICK), .SAMP(SAMP),
        .DCC_EN(DCC_EN), .DLL_EN(USE_DLL != 0),
        .DCC_KI(16'd1), .DLL_KI(16'd1),
        .DUTY_OFFS(8'd0), .DUTY_INIT(8'd0),
        .DLL_PHASE_OFFS(8'd0), .DLY_INIT(8'd0),
        .SEL_REQ(SEL_REQ), .SEL_UPD(SEL_UPD),
        .CK_DCC(CK_DCC), .CK_DLL(CK_DLL), .CK_PATH(CK_PATH),
        .CK_SEL(CK_SEL), .CK_PHY(CK_PHY), .CK_PHY_N(CK_PHY_N),
        .DCC_LOCKED(DCC_LOCKED), .DLL_LOCKED(DLL_LOCKED),
        .PHY_LOCKED(PHY_LOCKED),
        .DCC_ERR(DCC_ERR), .DLL_ERR(DLL_ERR), .ERR(PHY_ERR),
        .DUTY_CODE(DUTY_CODE), .DLY_CODE(DLY_CODE),
        .SEL_CUR(SEL_CUR), .BUSY(BUSY)
    );

    integer errors = 0;
    integer k;
    integer ref_edges = 0, div_edges = 0;
    always @(posedge REF) ref_edges = ref_edges + 1;
    always @(posedge OUT_DIV) div_edges = div_edges + 1;

    initial begin
        #1 RST_N = 1'b0;
        repeat (8) @(posedge REF);
        RST_N = 1'b1;
        repeat (4) @(posedge TICK);
        SEL_UPD = 1'b1;
        @(posedge TICK);
        SEL_UPD = 1'b0;
        repeat (6) @(posedge TICK);
        if (BUSY || SEL_CUR != SEL_TAP) begin
            $display("FAIL: selector did not settle, BUSY=%b SEL_CUR=%0d", BUSY, SEL_CUR);
            errors = errors + 1;
        end

        #20 INJ_EN = 1'b1;
        k = 0;
        while (u_pll.LOCKED !== 1'b1 && k < 4000) begin
            @(posedge REF);
            k = k + 1;
        end
        $display("ddr_clock_phy_integration: LOCKED=%b after %0d REF, FREQ_LOCKED=%b ERR=%b",
                 u_pll.LOCKED, k, u_pll.pll_dig.FREQ_LOCKED, ERR);
        if (u_pll.LOCKED !== 1'b1) begin
            $display("FAIL: ADPLL full LOCKED did not rise");
            errors = errors + 1;
        end

        // OUT_DIV is the raw divider output; measure its average rate over
        // 100 REF periods before enabling the PHY loop.
        begin : div_rate
            integer d0, d1;
            d0 = div_edges;
            repeat (100) @(posedge REF);
            d1 = div_edges;
            $display("ddr_clock_phy_integration: OUT_DIV %0d edges / 100 REF = %0d.%02d per REF",
                     d1 - d0, (d1 - d0) / 100, (d1 - d0) % 100);
        end

        DCC_EN = 1'b1;
        k = 0;
        while (DCC_LOCKED !== 1'b1 && k < 200000) begin
            @(posedge TICK);
            k = k + 1;
        end
        $display("ddr_clock_phy_integration: DCC_LOCKED=%b after %0d TICK, DUTY_CODE=%0d",
                 DCC_LOCKED, k, DUTY_CODE);
        if (DCC_LOCKED !== 1'b1) begin
            $display("FAIL: DCC did not lock on OUT_DIV");
            errors = errors + 1;
        end

        if (USE_DLL != 0) begin
            k = 0;
            while (DLL_LOCKED !== 1'b1 && k < 100000) begin
                @(posedge TICK);
                k = k + 1;
            end
            $display("ddr_clock_phy_integration: DLL_LOCKED=%b after %0d TICK, DLY_CODE=%0d",
                     DLL_LOCKED, k, DLY_CODE);
            if (DLL_LOCKED !== 1'b1) begin
                $display("FAIL: DLL did not lock on the DCC output");
                errors = errors + 1;
            end
        end

        repeat (2000) @(posedge TICK);
        if (PHY_LOCKED !== 1'b1) begin
            $display("FAIL: PHY_LOCKED low, LOCKED=%b DCC_LOCKED=%b DLL_LOCKED=%b BUSY=%b",
                     u_pll.LOCKED, DCC_LOCKED, DLL_LOCKED, BUSY);
            errors = errors + 1;
        end

        // A DLL_LOCKED flag is only useful if the delayed edge is actually
        // at a full-period phase.  Check the CK_DLL edge relative to CK_DCC.
        if (USE_DLL != 0) begin : dll_phase
            real t0, t1, period, delay, modp;
            @(posedge CK_DCC); t0 = $realtime;
            @(posedge CK_DCC); t1 = $realtime; period = t1 - t0;
            @(posedge CK_DCC); t0 = $realtime;
            @(posedge CK_DLL); t1 = $realtime; delay = t1 - t0;
            modp = delay;
            while (modp >= period) modp = modp - period;
            $display("ddr_clock_phy_integration: DLL delay=%0.3f ns period=%0.3f ns mod=%0.3f ns",
                     delay, period, modp);
            if (modp > 0.25 && modp < period - 0.25) begin
                $display("FAIL: DLL_LOCKED but CK_DLL is not at a full-period phase");
                errors = errors + 1;
            end
        end

        // Measure CK_PHY period and duty.
        begin : phy_measure
            real t0, th, tl;
            @(posedge CK_PHY); t0 = $realtime;
            @(negedge CK_PHY); th = $realtime - t0;
            @(posedge CK_PHY); tl = $realtime - (t0 + th);
            $display("ddr_clock_phy_integration: CK_PHY high=%0.3f low=%0.3f period=%0.3f duty=%0.1f%%",
                     th, tl, th + tl, 100.0 * th / (th + tl));
            if (th + tl < 4.0 || th + tl > 5.6) begin
                $display("FAIL: CK_PHY period outside 200 MHz class");
                errors = errors + 1;
            end
            if (100.0 * th / (th + tl) < 45.0 || 100.0 * th / (th + tl) > 55.0) begin
                $display("FAIL: CK_PHY duty outside 45-55%%");
                errors = errors + 1;
            end
        end

        // Static tap phase relative to the selected path input.  Measure the
        // minimum over several edges so a momentary lock deassertion cannot
        // turn a missed edge into a full-period result.
        begin : phy_phase
            real t_ref, t_phy, phase_ps, min_ps;
            integer n;
            min_ps = 1.0e9;
            while (PHY_LOCKED !== 1'b1) @(posedge CK_PATH);
            for (n = 0; n < 8; n = n + 1) begin
                @(posedge CK_PATH); t_ref = $realtime;
                @(posedge CK_PHY); t_phy = $realtime;
                phase_ps = (t_phy - t_ref) * 1000.0;
                if (PHY_LOCKED === 1'b1 && phase_ps < min_ps)
                    min_ps = phase_ps;
            end
            $display("ddr_clock_phy_integration: tap %0d phase=%0.1f ps (expected %0.1f ps)",
                     SEL_TAP, min_ps, SEL_TAP * TAP_PS);
            if (min_ps < SEL_TAP * TAP_PS - 100.0 ||
                min_ps > SEL_TAP * TAP_PS + 100.0) begin
                $display("FAIL: selected phase outside tolerance");
                errors = errors + 1;
            end
        end

        if (errors != 0) $fatal(1, "ddr_clock_phy_integration_tb failed");
        $display("ddr_clock_phy_integration_tb: PASS");
        $finish;
    end
endmodule
