// DDR clock PHY path smoke test.
//
// Fixed 200 MHz clock, 30% input duty, no live phase switching:
//   * DCC converges to a 50% duty
//   * DLL locks to a full-period delay
//   * phase selector tap 4 adds ~240 ps (4 x 60 ps)
//   * CK_PHY / CK_PHY_N carry the corrected, selected clock
//   * dropping PLL_LOCKED mid-high fail-closes both outputs
//
// This uses the behavioral DCDL/SS-BBPD models.  It is not a pad, PVT or
// jitter signoff.
`timescale 1ns/1ps

module ddr_clock_phy_tb;
    localparam real TCLK = 5.0;       // 200 MHz
    localparam real DUTY_IN = 0.30;   // 30% high
    localparam integer SEL_TAP = 4;
    localparam real TAP_PS = 60.0;    // PHASE_SELECTOR_TOP SIMULATION step
    localparam integer USE_DLL = 0;   // first version uses DCC -> selector

    reg CK_IN = 1'b1;
    // 30%-duty source.  Start high so the first edge is a falling edge.
    initial begin
        forever begin
            #(TCLK * DUTY_IN)    CK_IN = 1'b0;
            #(TCLK * (1.0 - DUTY_IN)) CK_IN = 1'b1;
        end
    end

    reg TICK = 1'b0;
    reg SAMP = 1'b0;
    always #0.5 TICK = ~TICK;          // 1 GHz loop clock
    always #0.555 SAMP = ~SAMP;        // incommensurate duty sampler

    reg RST_N = 1'b0;
    reg PLL_LOCKED = 1'b0;
    reg DCC_EN = 1'b0, DLL_EN = 1'b0;
    reg [15:0] DCC_KI = 16'd1, DLL_KI = 16'd1;
    reg [7:0] DUTY_OFFS = 8'd0, DUTY_INIT = 8'd0;
    reg [7:0] DLL_PHASE_OFFS = 8'd0, DLY_INIT = 8'd0;
    reg [3:0] SEL_REQ = SEL_TAP;
    reg SEL_UPD = 1'b0;

    wire CK_DCC, CK_DLL, CK_PATH, CK_SEL, CK_PHY, CK_PHY_N;
    wire PAD_CK_T, PAD_CK_C;
    wire DCC_LOCKED, DLL_LOCKED, PHY_LOCKED;
    wire DCC_ERR, DLL_ERR, ERR;
    wire [7:0] DUTY_CODE, DLY_CODE;
    wire [3:0] SEL_CUR;
    wire BUSY;

    DDR_CLOCK_PHY #(
        .DCC_COARSE_NDELS(15), .DCC_MID_NDELS(15), .DCC_FINE_NDELS(31),
        .DLL_COARSE_NDELS(15), .DLL_MID_NDELS(15), .DLL_FINE_NDELS(31),
        .FILTER_BITS(16),
        .DCC_LOCK_COUNT(16), .DLL_LOCK_COUNT(16),
        .NTAPS(16), .SEL_BITS(4), .DEAD_TICKS(2),
        .USE_DLL(USE_DLL)
    ) dut (
        .CK_IN(CK_IN), .PLL_LOCKED(PLL_LOCKED), .RST_N(RST_N),
        .TICK(TICK), .SAMP(SAMP),
        .DCC_EN(DCC_EN), .DLL_EN(DLL_EN),
        .DCC_KI(DCC_KI), .DLL_KI(DLL_KI),
        .DUTY_OFFS(DUTY_OFFS), .DUTY_INIT(DUTY_INIT),
        .DLL_PHASE_OFFS(DLL_PHASE_OFFS), .DLY_INIT(DLY_INIT),
        .SEL_REQ(SEL_REQ), .SEL_UPD(SEL_UPD),
        .CK_DCC(CK_DCC), .CK_DLL(CK_DLL), .CK_PATH(CK_PATH),
        .CK_SEL(CK_SEL), .CK_PHY(CK_PHY), .CK_PHY_N(CK_PHY_N),
        .DCC_LOCKED(DCC_LOCKED), .DLL_LOCKED(DLL_LOCKED),
        .PHY_LOCKED(PHY_LOCKED),
        .DCC_ERR(DCC_ERR), .DLL_ERR(DLL_ERR), .ERR(ERR),
        .DUTY_CODE(DUTY_CODE), .DLY_CODE(DLY_CODE),
        .SEL_CUR(SEL_CUR), .BUSY(BUSY)
    );

    // Matched functional pad/load: 80 ps driver + 50 ohm * 0.5 pF + edge = 135 ps.
    DDR_CK_PAD_MODEL #(
        .TPAD_PS(80), .LOAD_PF(0.5), .ROUT_OHM(50),
        .TRISE_PS(30), .TFALL_PS(30)
    ) u_pad (
        .CK_PHY(CK_PHY), .CK_PHY_N(CK_PHY_N),
        .PAD_CK_T(PAD_CK_T), .PAD_CK_C(PAD_CK_C)
    );

`ifdef ICS55_IO
    wire VDD, VDDIO, VSS, VSSIO;
    assign VDD = 1'b1;
    assign VDDIO = 1'b1;
    assign VSS = 1'b0;
    assign VSSIO = 1'b0;
    wire IO_CK_T, IO_CK_C;
    integer io_edges = 0;
    always @(posedge IO_CK_T) io_edges = io_edges + 1;
    ICS55_DDR_CK_PAD u_io (
        .CK_PHY(CK_PHY), .CK_PHY_N(CK_PHY_N),
        .VDD(VDD), .VDDIO(VDDIO), .VSS(VSS), .VSSIO(VSSIO),
        .CK_T(IO_CK_T), .CK_C(IO_CK_C)
    );
`endif

    integer errors = 0;
    integer k;
    integer phy_edges = 0;
    integer pad_edges = 0;
    always @(posedge CK_PHY) phy_edges = phy_edges + 1;
    always @(posedge PAD_CK_T) pad_edges = pad_edges + 1;

    task measure_duty;
        input [8*12-1:0] name;
        real t0, th, tl;
        begin
            @(posedge CK_PHY); t0 = $realtime;
            @(negedge CK_PHY); th = $realtime - t0;
            @(posedge CK_PHY); tl = $realtime - (t0 + th);
            $display("ddr_clock_phy: %0s high=%0.3f ns low=%0.3f ns period=%0.3f ns duty=%0.1f%%",
                     name, th, tl, th + tl, 100.0 * th / (th + tl));
            if (th + tl < TCLK - 0.1 || th + tl > TCLK + 0.1) begin
                $display("FAIL: %0s period=%0.3f, expected %0.3f", name, th + tl, TCLK);
                errors = errors + 1;
            end
            if (100.0 * th / (th + tl) < 45.0 || 100.0 * th / (th + tl) > 55.0) begin
                $display("FAIL: %0s duty outside 45-55%%", name);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        // Hold reset, request the tap while the output is still gated.
        repeat (8) @(posedge CK_IN);
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

        DCC_EN = 1'b1;
        DLL_EN = (USE_DLL != 0);
        for (k = 0; k < 200000 && !(DCC_LOCKED && (USE_DLL ? DLL_LOCKED : 1'b1)); k = k + 1)
            @(posedge TICK);
        $display("ddr_clock_phy: after %0d ticks DCC_LOCKED=%b DLL_LOCKED=%b USE_DLL=%0d DUTY_CODE=%0d DLY_CODE=%0d",
                 k, DCC_LOCKED, DLL_LOCKED, USE_DLL, DUTY_CODE, DLY_CODE);
        if (!(DCC_LOCKED && (USE_DLL ? DLL_LOCKED : 1'b1))) begin
            $display("FAIL: DCC/DLL did not lock");
            errors = errors + 1;
        end

        // Let both loops settle past the early dither-window lock flag.
        repeat (2000) @(posedge TICK);

        if (PHY_LOCKED !== 1'b0) begin
            $display("FAIL: PHY_LOCKED high before PLL_LOCKED");
            errors = errors + 1;
        end
        PLL_LOCKED = 1'b1;
        #1;
        if (PHY_LOCKED !== 1'b1) begin
            $display("FAIL: PHY_LOCKED low after all locks");
            errors = errors + 1;
        end

        measure_duty("CK_DCC");
        measure_duty("CK_PHY");

        // Pad/load duty and period.  The matched 135 ps driver does not
        // change the duty, but it is measured at the pad output.
        begin : pad_measure
            real t0, th, tl;
            @(posedge PAD_CK_T); t0 = $realtime;
            @(negedge PAD_CK_T); th = $realtime - t0;
            @(posedge PAD_CK_T); tl = $realtime - (t0 + th);
            $display("ddr_clock_phy: PAD_CK_T high=%0.3f low=%0.3f period=%0.3f duty=%0.1f%%",
                     th, tl, th + tl, 100.0 * th / (th + tl));
            if (th + tl < TCLK - 0.1 || th + tl > TCLK + 0.1) begin
                $display("FAIL: PAD_CK_T period=%0.3f", th + tl);
                errors = errors + 1;
            end
            if (100.0 * th / (th + tl) < 45.0 || 100.0 * th / (th + tl) > 55.0) begin
                $display("FAIL: PAD_CK_T duty outside 45-55%%");
                errors = errors + 1;
            end
        end

        // Static tap phase: CK_PHY is CK_PATH delayed by SEL_TAP tap steps.
        begin : phase_check
            real t_ref, t_phy, phase_ps;
            @(posedge CK_PATH); t_ref = $realtime;
            @(posedge CK_PHY); t_phy = $realtime;
            phase_ps = (t_phy - t_ref) * 1000.0;
            $display("ddr_clock_phy: tap %0d phase=%0.1f ps (expected %0.1f ps)",
                     SEL_TAP, phase_ps, SEL_TAP * TAP_PS);
            if (phase_ps < SEL_TAP * TAP_PS - 60.0 ||
                phase_ps > SEL_TAP * TAP_PS + 60.0) begin
                $display("FAIL: selected phase outside tolerance");
                errors = errors + 1;
            end
        end

        // Pad phase: selector tap plus the matched 135 ps pad/load driver.
        begin : pad_phase
            real t_ref, t_pad, phase_ps;
            @(posedge CK_PATH); t_ref = $realtime;
            @(posedge PAD_CK_T); t_pad = $realtime;
            phase_ps = (t_pad - t_ref) * 1000.0;
            $display("ddr_clock_phy: PAD_CK_T phase=%0.1f ps (expected %0.1f ps)",
                     phase_ps, SEL_TAP * TAP_PS + 135.0);
            if (phase_ps < SEL_TAP * TAP_PS + 135.0 - 80.0 ||
                phase_ps > SEL_TAP * TAP_PS + 135.0 + 80.0) begin
                $display("FAIL: pad phase outside tolerance");
                errors = errors + 1;
            end
        end

        // Differential pair: sample at stable levels, not while both
        // continuous assignments are in the same delta.
        @(posedge CK_PHY); #0.1;
        if (CK_PHY !== 1'b1 || CK_PHY_N !== 1'b0) begin
            $display("FAIL: CK_PHY/CK_PHY_N not complementary at high, %b/%b",
                     CK_PHY, CK_PHY_N);
            errors = errors + 1;
        end
        @(negedge CK_PHY); #0.1;
        if (CK_PHY !== 1'b0 || CK_PHY_N !== 1'b1) begin
            $display("FAIL: CK_PHY/CK_PHY_N not complementary at low, %b/%b",
                     CK_PHY, CK_PHY_N);
            errors = errors + 1;
        end else begin
            $display("PASS: CK_PHY/CK_PHY_N are complementary");
        end

`ifdef ICS55_IO
        // Real ics55 IO model: the Verilog cell has zero specify delay, so
        // this checks connectivity/duty/phase; the IO Liberty timing is
        // measured separately in flow/sta.
        begin : io_measure
            real t0, th, tl, t_ref, t_io, phase_ps;
            @(posedge IO_CK_T); t0 = $realtime;
            @(negedge IO_CK_T); th = $realtime - t0;
            @(posedge IO_CK_T); tl = $realtime - (t0 + th);
            $display("ddr_clock_phy: IO_CK_T high=%0.3f low=%0.3f period=%0.3f duty=%0.1f%%",
                     th, tl, th + tl, 100.0 * th / (th + tl));
            if (th + tl < TCLK - 0.1 || th + tl > TCLK + 0.1) begin
                $display("FAIL: IO_CK_T period=%0.3f", th + tl);
                errors = errors + 1;
            end
            if (100.0 * th / (th + tl) < 45.0 || 100.0 * th / (th + tl) > 55.0) begin
                $display("FAIL: IO_CK_T duty outside 45-55%%");
                errors = errors + 1;
            end
            @(posedge CK_PATH); t_ref = $realtime;
            @(posedge IO_CK_T); t_io = $realtime;
            phase_ps = (t_io - t_ref) * 1000.0;
            $display("ddr_clock_phy: IO_CK_T phase=%0.1f ps (expected %0.1f ps)",
                     phase_ps, SEL_TAP * TAP_PS);
            if (phase_ps < SEL_TAP * TAP_PS - 60.0 ||
                phase_ps > SEL_TAP * TAP_PS + 60.0) begin
                $display("FAIL: IO pad phase outside tolerance");
                errors = errors + 1;
            end
        end
`endif

        // Fault shutdown mid-high: both sides must go low immediately and
        // stay low while PLL_LOCKED is low.
        @(posedge CK_PHY);
        #1.0;
        PLL_LOCKED = 1'b0;
        #0.1;
        if (CK_PHY !== 1'b0 || CK_PHY_N !== 1'b0) begin
            $display("FAIL: output did not fail closed, CK_PHY=%b CK_PHY_N=%b",
                     CK_PHY, CK_PHY_N);
            errors = errors + 1;
        end else begin
            $display("PASS: CK_PHY and CK_PHY_N fail closed mid-high");
        end
        // The pad model adds 135 ps; after that both pad sides must be low.
        #0.2;
        if (PAD_CK_T !== 1'b0 || PAD_CK_C !== 1'b0) begin
            $display("FAIL: pad did not fail closed, PAD_CK_T=%b PAD_CK_C=%b",
                     PAD_CK_T, PAD_CK_C);
            errors = errors + 1;
        end else begin
            $display("PASS: PAD_CK_T and PAD_CK_C fail closed");
        end
        phy_edges = 0;
        pad_edges = 0;
        #20;
        if (phy_edges != 0 || pad_edges != 0) begin
            $display("FAIL: edges while unlocked, phy=%0d pad=%0d", phy_edges, pad_edges);
            errors = errors + 1;
        end else begin
            $display("PASS: no CK_PHY or PAD_CK_T edges while unlocked");
        end

        PLL_LOCKED = 1'b1;
        #20;
        if (PHY_LOCKED !== 1'b1 || phy_edges == 0 || pad_edges == 0) begin
            $display("FAIL: output did not resume after relock, phy=%0d pad=%0d",
                     phy_edges, pad_edges);
            errors = errors + 1;
        end else begin
            $display("PASS: output resumed after relock, phy=%0d pad=%0d edges",
                     phy_edges, pad_edges);
        end

        if (errors != 0) $fatal(1, "ddr_clock_phy_tb failed");
        $display("ddr_clock_phy_tb: PASS");
        $finish;
    end
endmodule
