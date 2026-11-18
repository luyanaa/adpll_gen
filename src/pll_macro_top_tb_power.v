// VCD dump for the ICG power comparison.
//
// Runs the same stimulus as pll_macro_top_tb but dumps a window before lock
// and a window after lock into two separate files, so OpenROAD's read_vcd can
// report the DSM/FLL clock-gating saving directly.
//
// Usage (gate level, ics55 cells, post-route pll_logic netlist):
//   iverilog -g2012 -gspecify -D SIMULATION=1 -D POSTSYN=1 \
//       src/pll_macro_top_tb_power.v src/pll_macro_top.v \
//       <PR_NETLIST> src/ref_watchdog.v src/ddr_ck.v src/lock_detector.v \
//       src/digital_loop_filter.v src/term_decoder.v src/freq_lock.v \
//       src/delta_sigma.v src/fix_div.v src/conf_div.v \
//       src/frequency_counter_frontend.v src/pll_analog.v src/il_dco.v \
//       src/sim_dco.v src/sim_injection.v src/sim_sym.v src/sim_SSBBPD.v \
//       <ics55 cells>.v
`timescale 1ns/1ps

module pll_macro_top_tb;
    localparam integer FILTER_BITS = 16;
    localparam integer FCW_BITS = 8;
    localparam integer COARSE_NDELS = 15;
    localparam integer MID_NDELS = 15;
    localparam integer FINE_NDELS = 31;
    localparam integer DIV_BITS = 8;
    localparam integer DSM_DIV = 2;
    localparam integer LOCKED_WAIT = 64;
    localparam integer FILTER_ILL = 16;
    localparam integer LOCK_TOL = 1;
    localparam integer LOCK_COUNT = 16;
    localparam integer LOSS_COUNT = 4;
    localparam integer MEAS_PERIODS = 1;

    reg REF = 1'b0;
    reg RST_N;
    reg INJ_EN = 1'b0;
    reg [FILTER_BITS-1:0] KP = 16'd3967;
    reg [FILTER_BITS-1:0] KI = 16'd257;
    reg [FCW_BITS-1:0] FCW = 8'd16;
    reg DSM_EN_DT = 1'b0;
    reg DSM_EN_SHDT = 1'b1;
    reg [1:0] DSM_ORDER = 2'b00;
    reg [DIV_BITS-1:0] SET_DIV = 8'd2;
    reg LOAD_DIV = 1'b0;

    wire LOCKED, ERR, OUT, OUT_DIV;
    wire CK;
    wire [COARSE_NDELS-1:0] COARSE_MUX;
    wire [MID_NDELS-1:0] MID_MUX;
    wire [FINE_NDELS-1:0] FINE_MUX;

    always #5 REF = ~REF; // 100 MHz

    pll_macro_top #(
        .COARSE_NDELS(COARSE_NDELS), .MID_NDELS(MID_NDELS),
        .FINE_NDELS(FINE_NDELS), .FILTER_BITS(FILTER_BITS),
        .IS_DSM(1), .DSM_DIV(DSM_DIV), .LOCKED_WAIT(LOCKED_WAIT),
        .FILTER_ILL(FILTER_ILL), .LOCK_TOL(LOCK_TOL),
        .LOCK_COUNT(LOCK_COUNT), .LOSS_COUNT(LOSS_COUNT),
        .MEAS_PERIODS(MEAS_PERIODS), .DIV_BITS(DIV_BITS),
        .FCW_BITS(FCW_BITS)
    ) dut (
        .REF(REF), .RST_N(RST_N), .INJ_EN(INJ_EN),
        .KP(KP), .KI(KI), .FCW(FCW),
        .DSM_EN_DT(DSM_EN_DT), .DSM_EN_SHDT(DSM_EN_SHDT),
        .DSM_ORDER(DSM_ORDER),
        .SET_DIV(SET_DIV), .LOAD_DIV(LOAD_DIV), .OUT_DIV(OUT_DIV), .CK(CK),
        .LOCKED(LOCKED), .ERR(ERR), .OUT(OUT)
    );

    integer t_lock;

    initial begin
        // One continuous VCD.  Icarus does not reliably reopen a second
        // $dumpfile after $dumpoff, so both windows go into one file and the
        // analysis splits it by the times printed below.
        $dumpfile("power_windows.vcd");
        $dumpvars(0, pll_macro_top_tb);

        #1 RST_N = 1'b0;
        #20 RST_N = 1'b1;
        #200 INJ_EN = 1'b1;

        // ---- window A: still acquiring, DSM + FLL both running ----
        repeat (150) @(posedge REF);
        $display("POWER_TB window_start %0d acquiring LOCKED=%b FREQ_OK=%b",
                 $time, LOCKED, dut.pll_dig.FREQ_OK);
        repeat (200) @(posedge REF);
        $display("POWER_TB window_end %0d acquiring", $time);

        // ---- wait for the loops to settle ----
        wait (dut.pll_dig.FREQ_LOCKED === 1'b1);
        repeat (600) @(posedge REF);
        t_lock = $time;

        // ---- window B: locked, dsm_gate closed and fll_standby set ----
        $display("POWER_TB window_start %0d locked LOCKED=%b FREQ_OK=%b",
                 $time, LOCKED, dut.pll_dig.FREQ_OK);
        repeat (200) @(posedge REF);
        $display("POWER_TB window_end %0d locked LOCKED=%b",
                 $time, LOCKED);

        $finish;
    end
endmodule
