#!python
"""Bang-bang ADPLL loop-filter sizing.

Replaces the old script, which analyzed the DLF as a standalone digital
filter and therefore could not produce a loop bandwidth.  This script
models the *closed* loop and prints the linearized crossover frequency
and phase margin for a given (KP, KI), then sizes KP/KI for a target
bandwidth.

Loop chain (src/pll_logic.v, src/digital_loop_filter.v):

    BBPD decision e[k] in {+1,-1}
      -> DLF        OUT = INT +/- KP,  INT[k] = INT[k-1] +/- KI
                    H_dlf(z) = KP + KI*z^-1/(1 - z^-1)
      -> REG_OUT    one filter-clock (REF-rate) delay
      -> FCWI/FCWF registers + DSM + FILTER_DEC_Q + decoder + FINE_MUX
                    ~3 DSM_CK cycles  (~1-2 REF cycles)
      -> fine code  code_avg = FILTER_OUT/1024  (see below)
      -> DCO        df = K_DCO_FINE * code        [Hz]
      -> phase      dphi = 2*pi*df*T_REF per REF cycle (integrator)
      -> BBPD       K_pd = sqrt(2/pi)/sigma_phi   [decision/rad]

Code mapping: FCWI = {FILTER_OUT[15:11],1'b0}, FCWF = FILTER_OUT[10:0],
so code_avg = 2*FILT[15:11] + FILT[10:0]/2048 ~= FILT/1024 within half a
code.  One fine code = 1024 FILTER_OUT LSBs.

K_pd caveat: the bang-bang gain is 1/sigma_phi, i.e. the linearized fc
scales as 1/sigma_t.  sigma_t is supplied as a parameter (default = the
4.0 ps estimated-signoff number).  When the linearized fc comes out near
or above F_REF/10 the BBPD is operating saturated and the real loop is in
a bounded limit cycle, not on the linear model -- the script flags this.
"""

import numpy as np

# ---------------------------------------------------------------------------
# Measured / design constants (edit when new characterization lands)
# ---------------------------------------------------------------------------
F_REF        = 100e6          # REF / DLF update rate [Hz]
FCW          = 16             # lock ratio: f_vco = FCW * F_REF
K_DCO_FINE   = 55e3           # Hz per fine code at the lock point
                            # (ihp_l3_dense: ~150 ppm/LSB at ~370 MHz; keep
                            # the lock-point number, NOT the -0.177 MHz/code
                            # median which includes the coarse end)
LSB_PER_CODE = 1024.0         # FILTER_OUT LSBs per fine code (see header)
SIGMA_T      = 4.0e-12        # locked phase-error rms at the PD [s]
                            # 4.0 ps = estimated-signoff jitter floor
LATENCY_REF  = 3.0            # total loop latency in REF cycles:
                            #   1 (REG_OUT) + ~2 (DSM pipeline+decode+mux)

T_REF  = 1.0 / F_REF
F_VCO  = FCW * F_REF

# BBPD linearized gain [decisions per radian]
SIGMA_PHI = 2.0 * np.pi * SIGMA_T * F_VCO      # rad rms at PD input
K_PD      = np.sqrt(2.0 / np.pi) / SIGMA_PHI

# DCO gain per FILTER_OUT LSB, referred to phase per REF sample
K_F_LSB   = K_DCO_FINE / LSB_PER_CODE          # Hz per FILTER LSB
G_VCO     = 2.0 * np.pi * K_F_LSB * T_REF      # rad per REF per LSB


def open_loop(w, kp, ki, latency=LATENCY_REF):
    """L(e^jw) with w = normalized frequency (rad/sample, 0..pi)."""
    z = np.exp(1j * w)
    h_dlf = kp + ki * z**-1 / (1.0 - z**-1)
    vco   = G_VCO * z**-1 / (1.0 - z**-1)      # f -> phase accumulator
    return K_PD * h_dlf * z**-latency * vco


def measure(kp, ki, latency=LATENCY_REF, n=20000):
    """Return (fc_hz, pm_deg) from the linearized model."""
    w = np.logspace(-6, np.log10(np.pi), n)
    L = open_loop(w, kp, ki, latency)
    mag = np.abs(L)
    idx = np.searchsorted(-mag, -1.0)          # first |L| <= 1 descending
    if idx == 0 or idx >= n:
        return None, None
    # log-log interpolate the crossover
    w0, w1 = w[idx - 1], w[idx]
    m0, m1 = np.log10(mag[idx - 1]), np.log10(mag[idx])
    wc = 10 ** (np.log10(w0) + (0 - m0) * np.log10(w1 / w0) / (m1 - m0))
    phase = np.degrees(np.angle(open_loop(wc, kp, ki, latency)))
    pm = 180.0 + phase
    return wc * F_REF / (2.0 * np.pi), pm


def size_kp_ki(fc_target, pm_target=60.0, fz_ratio=4.0, latency=LATENCY_REF):
    """Find (KP, KI) for a target crossover.

    KP sets the proportional step (and thus fc).  The DLF zero
    f_z ~= F_REF*KI/(2*pi*KP) is placed fc/fz_ratio below fc so the
    integrator adds phase lead without eating the margin.  Iterated twice
    because the zero slightly lifts the true crossover.
    """
    # First guess: at fc the loop is P-dominated, |L| ~ K_PD*KP*G_VCO/wc
    wc = 2.0 * np.pi * fc_target / F_REF
    kp = wc / (K_PD * G_VCO)                    # neglect KI at wc
    ki = kp * 2.0 * np.pi * (fc_target / fz_ratio) / F_REF
    for _ in range(3):
        # rescale KP so the measured crossover lands on target
        fc_m, _ = measure(kp, ki, latency)
        if fc_m is None:
            break
        kp = kp * fc_target / fc_m
        ki = kp * 2.0 * np.pi * (fc_target / fz_ratio) / F_REF
    return kp, ki


def step_summary(kp, ki):
    df_p = kp * K_F_LSB      # Hz correction per bang-bang decision (P)
    df_i = ki * K_F_LSB      # Hz per decision through the integrator
    c_p  = kp / LSB_PER_CODE # fine codes per decision (P)
    return df_p, df_i, c_p


if __name__ == "__main__":
    print(f"model: f_ref={F_REF/1e6:.0f} MHz  f_vco={F_VCO/1e9:.2f} GHz  "
          f"K_DCO_fine={K_DCO_FINE/1e3:.1f} kHz/code  "
          f"K_pd={K_PD:.2f}/rad (sigma_t={SIGMA_T*1e12:.1f} ps)")
    print(f"loop latency = {LATENCY_REF:.0f} REF cycles "
          f"(phase loss = 360*D*fc/f_ref)")

    # --- current testbench values ---
    for name, kp, ki in [("TB (pll_macro_top_tb)", 3967, 257)]:
        fc, pm = measure(kp, ki)
        df_p, df_i, c_p = step_summary(kp, ki)
        print(f"\n{name}: KP={kp} KI={ki}")
        if fc is None:
            print("  linearized |L| never crosses 0 dB -- saturated regime")
        else:
            flag = "  *** fc > f_ref/10: saturated, limit-cycle regime ***" \
                   if fc > F_REF / 10 else ""
            print(f"  linearized fc = {fc/1e6:.2f} MHz  PM = {pm:.0f} deg{flag}")
        print(f"  P step = {c_p:.2f} codes ({df_p/1e3:.0f} kHz)/decision, "
              f"I step = {df_i/1e3:.1f} kHz/decision")

    # --- gear table ---
    print("\nsuggested gears (linearized; fc scales as 1/sigma_t):")
    for name, fc_t in [("acquisition", F_REF / 20),
                       ("tracking",    F_REF / 80)]:
        kp, ki = size_kp_ki(fc_t)
        fc, pm = measure(kp, ki)
        df_p, df_i, c_p = step_summary(kp, ki)
        print(f"  {name:11s} fc*={fc_t/1e6:.2f} MHz -> KP={kp:8.1f} "
              f"KI={ki:7.1f}   fc={fc/1e6:.2f} MHz PM={pm:.0f} deg "
              f"P={c_p:.2f} codes/step")
        print(f"             raw LSB: KP={round(kp)} KI={round(ki)}")

    print("\nlatency budget: fc <= f_ref/30 keeps latency loss < 36 deg "
          "at D=3")

    # --- raising F_REF -----------------------------------------------------
    # fc scales ~linearly with F_REF (both the loop update rate and the
    # latency limit).  200 MHz REF doubles the tracking-bandwidth ceiling
    # to ~2.5 MHz at the same PM, and the digital paths trivially close at
    # 10 ns.  Two constraints gate it:
    #   * INJ_WIN is a fixed analog delay, so the injection window does not
    #     shrink; only the SS_BBPD decision slack halves (5 -> 2.5 ns).
    #   * f_vco = FCW * F_REF, so 200 MHz REF needs FCW <= ~1-2 to keep the
    #     ring inside its PEX reach (<= ~230 MHz baud/2).  For a SerDes
    #     sample clock that caps baud at ~230 Mb/s, REF already has to sit
    #     near f_vco, so a 200 MHz reference only helps acquisition speed,
    #     not tracking bandwidth at the lock point.
    print("\nREF 100->200 MHz: digital + injection side feasible; fc ceiling")
    print("  doubles.  Only worthwhile with a low FCW lock point -- it buys")
    print("  acquisition speed, not in-lock tracking bandwidth for SerDes.")
