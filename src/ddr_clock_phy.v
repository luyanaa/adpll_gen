// DDR clock PHY path — fixed-configuration first version.
//
//   CK_IN (ADPLL CK / divider output)
//     -> ADCC_TOP   duty-cycle corrector
//     -> ADDLL_TOP  full-period delay / deskew
//     -> PHASE_SELECTOR_TOP  static phase tap
//     -> CK_PHY / CK_PHY_N
//
// This is the PHY-side clock path after the ADPLL, not a second PLL.  The
// ADPLL supplies the raw divider output (not the LOCKED-gated CK, so DCC and
// DLL can run during acquisition) and PLL_LOCKED for the final gate.  TICK is
// the loop update clock; SAMP must be incommensurate with CK_IN so the DCC
// averaging detector sweeps the whole waveform.  DCC and DLL are enabled
// together; the phase tap is selected before the output is released, so the
// first version does not exercise a live phase change.
//
// The output is fail-closed: if PLL_LOCKED, DCC_LOCKED, DLL_LOCKED or the
// selector BUSY flag goes bad, both CK_PHY and CK_PHY_N go low at once.
// That can truncate the last high pulse.  It is a safe-shutdown contract,
// not a glitchless DFS switch.
//
// The DCC_ERR/DLL_ERR flags in the two blocks are sticky lock-loss
// diagnostics.  The gate uses the lock deassertion, not ERR, because a
// transient excursion during acquisition can leave ERR set while the loop
// has re-locked.
// USE_DLL=0 is the selector-only bring-up path.  USE_DLL=1 inserts the Route B
// full-period DLL: a 4-segment bypass + 56-tap DCDL, a startup absolute-range
// detector that measures the actual REF period, an edge-time phase detector,
// and LOCKED = RANGE_OK & PHASE_OK & !CODE_RAILED & ALIVE.  The DLL TDC needs
// a fast clock (DLL_TICK), separate from the 1 GHz loop update clock.  The
// DLL is enabled only after PLL_LOCKED so its period measurement is taken on
// the final ADPLL frequency.
module DDR_CLOCK_PHY #(
    parameter integer DCC_COARSE_NDELS = 15,
    parameter integer DCC_MID_NDELS = 15,
    parameter integer DCC_FINE_NDELS = 31,
    parameter integer DLL_COARSE_NDELS = 15,
    parameter integer DLL_MID_NDELS = 15,
    parameter integer DLL_FINE_NDELS = 31,
    parameter integer DLL_T0_PS = 2930,
    parameter integer DLL_STEP_PS = 35,
    parameter integer DLL_CODE_MIN = 20,
    parameter integer DLL_CODE_MAX = 170,
    parameter integer DLL_CODE_INIT = 55,
    parameter integer DLL_PERIOD_TICKS = 50,
    parameter integer FILTER_BITS = 16,
    parameter integer DCC_LOCK_COUNT = 16,
    parameter integer DLL_LOCK_COUNT = 16,
    parameter integer MID_W = 4,
    parameter integer COARSE_W = 8,
    parameter integer NTAPS = 16,
    parameter integer SEL_BITS = 4,
    parameter integer DEAD_TICKS = 2,
    parameter integer USE_DLL = 0
) (
    input  wire                    CK_IN,
    input  wire                    PLL_LOCKED,
    input  wire                    RST_N,
    input  wire                    TICK,
    input  wire                    DLL_TICK,
    input  wire                    SAMP,
    input  wire                    DCC_EN,
    input  wire                    DLL_EN,
    input  wire [FILTER_BITS-1:0]  DCC_KI,
    input  wire [FILTER_BITS-1:0]  DLL_KI,
    input  wire [7:0]              DUTY_OFFS,
    input  wire [7:0]              DUTY_INIT,
    input  wire [7:0]              DLL_PHASE_OFFS,
    input  wire [7:0]              DLY_INIT,
    input  wire [SEL_BITS-1:0]     SEL_REQ,
    input  wire                    SEL_UPD,
    output wire                    CK_DCC,
    output wire                    CK_DLL,
    output wire                    CK_PATH,
    output wire                    CK_SEL,
    output wire                    CK_PHY,
    output wire                    CK_PHY_N,
    output wire                    DCC_LOCKED,
    output wire                    DLL_LOCKED,
    output wire                    PHY_LOCKED,
    output wire                    DCC_ERR,
    output wire                    DLL_ERR,
    output wire                    ERR,
    output wire [7:0]              DUTY_CODE,
    output wire [8:0]              DLY_CODE,
    output wire [SEL_BITS-1:0]     SEL_CUR,
    output wire                    BUSY
);
    ADCC_TOP #(
        .COARSE_NDELS(DCC_COARSE_NDELS),
        .MID_NDELS(DCC_MID_NDELS),
        .FINE_NDELS(DCC_FINE_NDELS),
        .FILTER_BITS(FILTER_BITS),
        .LOCK_COUNT(DCC_LOCK_COUNT),
        .MID_W(MID_W),
        .COARSE_W(COARSE_W)
    ) u_dcc (
        .CLK_IN(CK_IN), .RST_N(RST_N), .TICK(TICK), .SAMP(SAMP),
        .EN(DCC_EN), .KI(DCC_KI),
        .DUTY_OFFS(DUTY_OFFS), .DUTY_INIT(DUTY_INIT),
        .CLK_OUT(CK_DCC), .LOCKED(DCC_LOCKED), .ERR(DCC_ERR),
        .DUTY_CODE(DUTY_CODE)
    );

    // The DLL only runs on a locked ADPLL frequency; otherwise its one-time
    // period measurement would capture an acquisition-time frequency.
    wire dll_en = DLL_EN & PLL_LOCKED;
    localparam [8:0] DLL_CODE_START = DLL_CODE_INIT;

    DLL_FULL_PERIOD_TOP #(
        .TAPS(280), .T0_PS(DLL_T0_PS), .STEP_PS(DLL_STEP_PS),
        .CODE_MIN(DLL_CODE_MIN), .CODE_MAX(DLL_CODE_MAX),
        .PERIOD_TICKS(DLL_PERIOD_TICKS),
        .ACQ_EPS(4), .PHASE_EPS(1), .LOCK_COUNT(DLL_LOCK_COUNT)
    ) u_dll (
        .REF(CK_DCC), .RST_N(RST_N), .EN(dll_en), .TICK(DLL_TICK),
        .CODE_START(DLL_CODE_START),
        .OUT(CK_DLL), .LOCKED(DLL_LOCKED), .PHASE_OK(), .RANGE_OK(),
        .CODE_RAILED(), .ALIVE(), .CODE(DLY_CODE),
        .PFD_UP(), .PFD_DN(),
        .ACQ_BUSY(), .ACQ_OK(), .ACQ_FAIL(DLL_ERR)
    );

    PHASE_SELECTOR_TOP #(
        .NTAPS(NTAPS), .SEL_BITS(SEL_BITS), .DEAD_TICKS(DEAD_TICKS)
    ) u_sel (
        .CLK_IN(CK_PATH), .RST_N(RST_N), .TICK(TICK),
        .SEL_REQ(SEL_REQ), .SEL_UPD(SEL_UPD),
        .CLK_OUT(CK_SEL), .SEL_CUR(SEL_CUR), .BUSY(BUSY)
    );

    assign CK_PATH = USE_DLL ? CK_DLL : CK_DCC;
    assign ERR = DCC_ERR | DLL_ERR;
    assign PHY_LOCKED = PLL_LOCKED & DCC_LOCKED &
                        (USE_DLL ? DLL_LOCKED : 1'b1) & ~BUSY;

    // Fail-closed differential pair.  Both sides are low when the path is
    // not locked; CK_PHY_N is the functional complement, not a modeled
    // DDR IO driver.
    assign CK_PHY   = PHY_LOCKED &  CK_SEL;
    assign CK_PHY_N = PHY_LOCKED & ~CK_SEL;
endmodule
