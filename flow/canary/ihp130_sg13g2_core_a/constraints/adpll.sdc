# adpll.sdc -- practical canary constraints for ihp130 (SG13G2, 1.2 V) + Core A
#
# Scope
# -----
# This one file is used by BOTH canary configs:
#   config.digital.yaml : top = pll_logic; REF/OUT/MID_OUT/INJ_EDGE are ports
#   config.macro.yaml   : top = pll; OUT/MID_OUT/INJ_EDGE come from the
#                         PLL_ANALOG instance `pll_ana`
#
# It is a canary, not signoff.  In particular:
#   - PLL_ANALOG has no Liberty model yet, so macro->digital paths (SS_BBPD)
#     are not constrained at all.
#   - CKR (a flop retiming REF into the MID_OUT domain) and DSM_CK (MID_OUT
#     divided by DSM_DIV) are internally generated clocks in pll_logic.  They
#     are NOT declared here because their post-synthesis hierarchical names are
#     not stable.  CTS/STA must add create_generated_clock for them before any
#     timing claim.
#   - The numbers below are planning assumptions (50 MHz REF, FCW=8 nominal
#     OUT), not measured DCO behavior.
#
# Do not copy this file into a signoff run.  The ckdur `src/pll.sdc.tcl` is
# also not signoff-grade (it creates 1 ns clocks on analog internal pins and
# says nothing about INJ_EDGE or the generated digital clocks).

# ---------------------------------------------------------------------------
# Clocks
# ---------------------------------------------------------------------------
# REF is normally created by LibreLane from CLOCK_PORT/CLOCK_PERIOD.  Create
# it only if the flow has not already done so (keeps this file usable
# standalone and avoids a duplicate definition).
if {[llength [get_clocks -quiet REF]] == 0} {
    create_clock -name REF -period 20.000 [get_ports REF]
}

# OUT / MID_OUT / INJ_EDGE: ports in the digital-only top, macro pins in the
# full top.  Nominal periods are STA assumptions:
#   OUT/MID_OUT : measured per corner (see MID_OUT below); real period is set
#                 by the DCO, not by the FCW
#   INJ_EDGE    : 20 ns, a delayed copy of REF
# Prefer the macro pin in the full top: OUT/MID_OUT/INJ_EDGE are top-level
# *outputs* there, and a clock defined on an output port would not propagate
# back into the design.  In the digital-only top the pins do not exist and the
# ports are inputs, so the fallback is correct.
if {[llength [get_clocks -quiet OUT]] == 0} {
    set out_src [get_pins -quiet pll_ana/OUT]
    if {[llength $out_src] == 0} {
        set out_src [get_ports -quiet OUT]
    }
    if {[llength $out_src] > 0} {
        create_clock -name OUT -period 2.500 $out_src
    } else {
        puts "WARNING: adpll.sdc: OUT not found as pll_ana/OUT or a port"
    }
}

if {[llength [get_clocks -quiet MID_OUT]] == 0} {
    set mid_src [get_pins -quiet pll_ana/MID_OUT]
    if {[llength $mid_src] == 0} {
        set mid_src [get_ports -quiet MID_OUT]
    }
    # Real per-corner minimum MID_OUT period, measured on the *corrected*
    # macro netlist (mid LOAD 120/120) with the open-loop gate sweep in
    # sim/outputs/ihp-sg13g2/gate:
    #   nom_tt_025C_1v20 : 1.900 ns (526.3 MHz)
    #   nom_ff_n40C_1v32 : 1.310 ns (763.4 MHz, the fastest)
    #   nom_ss_125C_1v08 : 2.940 ns (340.1 MHz)
    # The old 2.500 ns (400 MHz) both over-clocked the FLL counter and was
    # wrong for every corner.  LibreLane exposes the active corner through
    # ::env(_CURRENT_CORNER_NAME); guard it so a standalone OpenSTA run still
    # gets the worst (fastest) measured period, 1.310 ns.
    set mid_period 1.310
    if {[info exists ::env(_CURRENT_CORNER_NAME)]} {
        set _corner $::env(_CURRENT_CORNER_NAME)
        if {[string match *nom_tt_025C_1v20* $_corner]} {
            set mid_period 1.900
        } elseif {[string match *nom_ff_n40C_1v32* $_corner]} {
            set mid_period 1.310
        } elseif {[string match *nom_ss_125C_1v08* $_corner]} {
            set mid_period 2.940
        }
        puts "adpll.sdc: MID_OUT period $mid_period ns for corner $_corner"
    }
    if {[llength $mid_src] > 0} {
        create_clock -name MID_OUT -period $mid_period $mid_src
    } else {
        puts "WARNING: adpll.sdc: MID_OUT not found as pll_ana/MID_OUT or a port"
    }
}

if {[llength [get_clocks -quiet INJ_EDGE]] == 0} {
    set inj_src [get_pins -quiet pll_ana/INJ_EDGE]
    if {[llength $inj_src] == 0} {
        set inj_src [get_ports -quiet INJ_EDGE]
    }
    if {[llength $inj_src] > 0} {
        create_clock -name INJ_EDGE -period 20.000 $inj_src
    } else {
        puts "WARNING: adpll.sdc: INJ_EDGE not found as pll_ana/INJ_EDGE or a port"
    }
}

# REF and INJ_EDGE are physically related (INJ_EDGE is a delayed REF), but
# the insertion delay is unknown until the macro is characterized.  Treat all
# four as asynchronous for the canary.  Replace the REF/INJ_EDGE split with a
# create_generated_clock + -edge_shift once the macro Liberty provides the
# injection delay.
# ---------------------------------------------------------------------------
# Gated clocks produced by PLL_CLKGATE
# ---------------------------------------------------------------------------
# When PLL_USE_ICS55_ICG is defined, flock.REF_G and dsm_impl.DSM_CK_G are
# driven by real ICGNX1H7R cells and CTS builds them as separate clock nets.
# Without a generated-clock declaration STA treats those nets as ordinary
# data: every REF -> REF_G transfer becomes a synchronous path and repair
# fills it with delay cells (measured: DLY4X2H7R 15 -> 201, hold -0.1161).
#
# The gates are transparent while enabled, so both clocks are the same
# frequency as their source with a small insertion delay.
# create_generated_clock wants a pin/port, not a net: resolve the driver of
# each gated-clock net first.  The driver is either the ICG's ECK pin
# (PLL_USE_ICS55_ICG) or the fallback AND gate's Y pin.
proc _drv_pin {net} {
    set drv [get_pins -quiet -of_objects $net -filter "direction==output"]
    if {[llength $drv] > 0} { return [lindex $drv 0] }
    return ""
}

if {[llength [get_clocks -quiet REF_G_CLK]] == 0} {
    # Anchor on the ICG's GCLK output, not on a net wildcard: the wildcard also
    # matches the CTS-inserted clknet_* nets, and lindex 0 then picks a tree
    # buffer instead of the clock root.  That made the clock `Virtual: yes` with
    # a mid-tree source, so its phase was referred to the wrong node (the DSM
    # clock derived the same way produced a data required time of -8.4187 ns,
    # i.e. a capture edge before the launch edge).
    set refg_pin [get_pins -quiet *u_fll_icg*/GCLK]
    if {[llength $refg_pin] > 0} {
        create_generated_clock -name REF_G_CLK -source [get_ports REF] \
            -divide_by 1 [lindex $refg_pin 0]
    } else {
        puts "WARNING: adpll.sdc: REF_G_CLK not created (icg pin not found)"
    }
}

# DSM_CK is MID_OUT divided by DSM_DIV (a pll_fix_divider instance; DSM_DIV
# is 4 in pll_macro_top).  DSM_CK_G is the same clock through the ICG, so no
# further division.  /2 (5 ns) left the DSM adder at -1.51 ns; /4 is 10 ns.
#
# The previous version derived DSM_CK_G_CLK with -divide_by 1 from the *divider
# register's Q pin*, which made STA report a 2.500 ns period -- the same as
# MID_OUT.  That is half the real period, and it is what turned the DSM adder
# into a 49-stage path against a 2.5 ns budget at all three corners.  The
# divider register is real (_4277_ in the routed netlist: D from the counter
# logic, CLK = clknet_1_0__leaf_MID_OUT, Q = pll_dig.dsm_impl.DSM_CK), so the
# divided clock is genuinely MID_OUT/DSM_DIV.
#
# Anchor must be MID_OUT itself, not the divider's Q: -source takes a clock
# source pin, and the Q pin of a flop is data, not a clock root.
set dsm_div 4
if {[llength [get_clocks -quiet DSM_CK_G_CLK]] == 0} {
    # Anchor on the ICG's GCLK output, NOT on a net wildcard.  The wildcard
    # *dsm_impl.DSM_CK_G* also matches the CTS-inserted nets
    # (clknet_0_pll_dig.dsm_impl.DSM_CK_G, clknet_4_*...), and taking lindex 0
    # picked whichever came first -- after CTS that is a clock-tree buffer's
    # output, not the clock root.  The clock then came out
    # `Virtual: yes` with `Sources: clkbuf_0_....DSM_CK_G/X`, and its phase was
    # referred to a mid-tree node: STA reported data required time
    # -8.4187 ns on the DSM path, i.e. the capture edge was placed before the
    # launch edge.  That single defect accounted for the residual SS/TT setup
    # violation after the /2 fix.
    set dsmg_pin [get_pins -quiet *u_dsm_icg*/GCLK]
    set mid_src [get_ports -quiet MID_OUT]
    if {[llength $mid_src] == 0} {
        set mid_src [get_pins -quiet *pll_ana/MID_OUT]
    }
    if {[llength $dsmg_pin] > 0 && [llength $mid_src] > 0} {
        create_generated_clock -name DSM_CK_G_CLK \
            -source [lindex $mid_src 0] -divide_by $dsm_div [lindex $dsmg_pin 0]
    } else {
        puts "WARNING: adpll.sdc: DSM_CK_G_CLK not created (icg pin [llength $dsmg_pin], mid src [llength $mid_src])"
    }
}

# ---------------------------------------------------------------------------
# FLL front-end divided clock
# ---------------------------------------------------------------------------
# frequency_counter_frontend toggles `clk_div` on MID_OUT and clocks the whole
# counter (cnt, gray_q) from 'always @(posedge clk_div)'.  That makes clk_div a
# real clock domain inside pll_dig.flock.
#
# B12 moved the counter to CLK + a registered enable to avoid CTS leaving a
# generated-clock root undriven, but that left the counter flops timed against
# the full-rate MID_OUT period.  The 2026-11-24 fix restores posedge clk_div
# (the counter increments once per two MID_OUT edges) and the FE_CLK_DIV
# declaration below is what makes CTS treat the clk_div register as a clock
# root instead of an ordinary net.  The B12 nibble pre-decode is still in the
# RTL; only the enable muxes were removed with the divided clock.
#
# PRESCALE is 2 in the signoff build (pll_logic instantiates
# .PRESCALE(2)), and div_cnt runs off MID_OUT, so clk_div is MID_OUT/2.
set frontend_prescale 2

# ---------------------------------------------------------------------------
# Derived clocks that were also never declared
# ---------------------------------------------------------------------------
# Both of these are register outputs used as clocks in pll_logic, and both were
# part of the same "unclocked register/latch pins" report:
#
#   out_div2 : toggles on OUT, then clocks out_edges_gray
#              (always @(posedge out_div2)).  It is OUT/2, i.e. MID_OUT.
#   CKR      : REF sampled on the falling edge of MID_OUT, then clocks the
#              COARSE_MUX / MID_MUX / FINE_MUX write registers.  Those are the
#              DCO control words, so leaving them unchecked is worse than a
#              bookkeeping gap -- the capture of the control word was invisible.
#
# CKR's period is MID_OUT's (it is a register in that domain, launched by
# MID_OUT and capturing REF), so declaring it relative to MID_OUT is right.

proc _genclk_on_net {name net_pat src_list div} {
    if {[llength [get_clocks -quiet $name]] > 0} { return 1 }
    set net [lindex [get_nets -quiet $net_pat] 0]
    if {$net eq ""} {
        puts "WARNING: adpll.sdc: $name skipped (net $net_pat not found)"
        return 0
    }
    set pin [get_pins -quiet -of_objects $net -filter "direction==output"]
    if {[llength $pin] == 0 || [llength $src_list] == 0} {
        puts "WARNING: adpll.sdc: $name skipped (pin [llength $pin], src [llength $src_list])"
        return 0
    }
    create_generated_clock -name $name -source [lindex $src_list 0] \
        -divide_by $div [lindex $pin 0]
    puts "adpll.sdc: $name created (divide_by $div) at [lindex $pin 0]"
    return 1
}

set mid_src_d [get_ports -quiet MID_OUT]
if {[llength $mid_src_d] == 0} {
    set mid_src_d [get_pins -quiet *pll_ana/MID_OUT]
}

# out_div2: OUT/2 (a register clocked by OUT), so derive it from the OUT
# clock with -divide_by 2.  The old declaration used MID_OUT as the source and
# -divide_by 1, which silently modelled it as the MID_OUT rate instead.
set out_src_d [get_ports -quiet OUT]
if {[llength $out_src_d] == 0} {
    set out_src_d [get_pins -quiet *pll_ana/OUT]
}
_genclk_on_net OUT_DIV2_CLK *pll_dig.out_div2* $out_src_d 2
# FE_CLK_DIV: the FLL counter clock, MID_OUT/2.  See the front-end note above;
# declared here (before set_clock_groups) so it lands in the MID_OUT group.
_genclk_on_net FE_CLK_DIV *clk_div* $mid_src_d 2
# CKR: a MID_OUT-domain register capturing REF; keep the MID_OUT period.
_genclk_on_net CKR_CLK *pll_dig.CKR $mid_src_d 1
# DSM_CK (ungated): the 2FF synchroniser that carries LOCKED into the DSM
# domain is clocked by dsm_impl.DSM_CK directly, while the loop itself runs on
# DSM_CK_G_CLK (the ICG output).  Without a clock on DSM_CK those two flops
# (_4615_/_4613_, locked_dsm_s1/s2) were the last entries in the unclocked
# report, so the LOCKED hand-off into the DSM was never timed.  Same rate as
# DSM_CK_G_CLK: MID_OUT/DSM_DIV.
# EXPERIMENT: DSM_CK_CLK removed.  DSM_CK is only the ICG input plus the LOCKED
# 2FF tree, and both clocks are in the same asynchronous group, so the separate
# clock object existed only to make CTS build a second tree -- which is then
# cascaded with the DSM_CK_G tree (B20/B23: 1.99 ns of a 5 ns period).
#_genclk_on_net DSM_CK_CLK *pll_dig.dsm_impl.DSM_CK $mid_src_d $dsm_div

# REF_G is REF gated by the FLL ICG: same frequency, small insertion delay.
# It stays in the REF group so REF -> REF_G transfers are analysed (the ICG
# setup requirement is real), while the CDC synchronizers inside both domains
# are exempted separately below.  The asynchronous group declaration itself is
# made once, after every generated clock exists (see the end of this file).

# ---------------------------------------------------------------------------
# CDC synchronizers: exempt the first stage from hold repair
# ---------------------------------------------------------------------------
# The RTL marks every 2FF synchronizer first stage (* ASYNC_REG = "TRUE" *),
# and set_clock_groups below declares the four clocks asynchronous.  OpenROAD's
# repair_design still inserts hold buffers on them: 42 of the 55 DLY4X2H7R
# cells in run RUN_2026-11-18_11-55-44 sit on cnt_gray_s1/s2,
# out_edges_g1/g2, watch_s1/s2 and clr_r1/r2.  That is 7.6% of the die in
# timing_repair cells, and it is also what breaks functional gate-level
# simulation of the P&R netlist: a delay inserted into a 2FF shifts the loop
# timing against the behavioural DCO.
#
# A metastable first stage cannot be fixed by added delay -- the requirement is
# MTBF, not hold.
#
# Mechanism: hierarchical pin names are gone after synthesis, but the *net*
# names survive (the netlist keeps flock.cnt_gray_s1[12] etc.).  Resolve each
# synchronizer net to its sink pins and exempt those.  set_max_delay is not
# used: OpenSTA rejects -datapath_only on this netlist (STA-0563), and the
# hold exemption alone is what removes the delay cells.
#
# Verified with OpenROAD on RUN_2026-11-18_11-55-44: 93 sink pins resolved,
# set_false_path -hold accepted for all of them.
proc cdc_exempt_hold {patterns} {
    set total 0
    foreach pat $patterns {
        set nets [get_nets -quiet $pat]
        set sinks {}
        foreach n $nets {
            set sinks [concat $sinks \
                [get_pins -quiet -of_objects $n -filter "direction==input"]]
        }
        if {[llength $sinks] > 0} {
            set_false_path -hold -to $sinks
            set total [expr {$total + [llength $sinks]}]
        }
    }
    if {$total > 0} {
        puts "adpll.sdc: CDC hold exemption applied to $total sink pins"
    }
}

cdc_exempt_hold {
    *cnt_gray_s1*  *cnt_gray_s2*
    *out_edges_g1* *out_edges_g2*
    *watch_s1*     *watch_s2*
    *clr_r1*       *clr_r2*
    *ref_ok_s1*    *ref_ok_s2*
    *locked_dsm_s1* *locked_dsm_s2*
}

# ---------------------------------------------------------------------------
# Negedge clocks: `always @(negedge clk)` lands behind an inverter
# ---------------------------------------------------------------------------
# Synthesis implements a negedge register as INV(clk) -> flop CLK, so the flop
# is not on the clock net and STA cannot attach it to any clock group.  In the
# netlist 89 flops are like this, one per inverter, and they are where a large
# part of the remaining setup violations live (path group OUT alone held 53 of
# 73 at SS).
#
# Declared structurally rather than by net name, because the names differ by
# stage: pre-CTS the flop clock is the inverter output `_0202_`, after CTS it is
# `net264`.  A net-name list therefore matched nothing at STAPrePNR (measured:
# "NE_CLK declared on 0 net").  Instead, walk the flops and take every one
# whose CLK pin is driven by an inverter output, then anchor the generated
# clock on that inverter output with -source set to the clock feeding the
# inverter.
#
# OpenSTA's -source does NOT place a generated clock into its master's clock
# group: a clock that appears in no set_clock_groups group is related to every
# other clock and is timed synchronously.  Each generated NE clock must
# therefore be named explicitly in the set_clock_groups call (done after all
# clocks are created, below), together with its master.  Leaving them out
# would split each domain into many synchronous domains (the failure mode
# recorded in B12, which produced thirteen groups for one clock).
proc _declare_negedge_clocks {} {
    set made 0
    set seen {}
    set _diag_flops 0
    set _diag_clkpin 0
    set _diag_drv 0
    set _diag_inv 0
    set _diag_src 0
    foreach flop [get_cells -quiet -hierarchical *] {
        set rt [get_property $flop ref_name]
        if {![string match *dfrbp* $rt] && ![string match *dl* $rt]} { continue }
        set clkpins [get_pins -quiet -of_objects $flop -filter "name==CLK"]
        if {[llength $clkpins] == 0} { continue }
        incr _diag_clkpin
        set clkpin [lindex $clkpins 0]
        set drv [get_pins -quiet -of_objects [get_nets -quiet -of_objects $clkpin] \
                     -filter "direction==output"]
        if {[llength $drv] == 0} { continue }
        incr _diag_drv
        set drvcell [get_cells -quiet -of_objects $drv]
        set drvtype [get_property $drvcell ref_name]
        if {![string match *inv* $drvtype]} { continue }
        incr _diag_inv
        set outpin [lindex $drv 0]
        if {[lsearch -exact $seen $outpin] >= 0} { continue }
        lappend seen $outpin
        # Master clock.  The inverter's input net is named after the clock it
        # carries -- measured on the routed netlist: INJ_EDGE (77 of the 89),
        # OUT (10), plus a handful of stray non-clock nets.  Match that name
        # against the clock list and take the clock's own source pin.
        #
        # (Walking one pin upstream instead landed on another inverter's Y,
        # e.g. Sources: _3285_/Y, which is not a clock and put each of the 89
        # into its own group.)
        set inpin [get_pins -quiet -of_objects $drvcell -filter "direction==input"]
        if {[llength $inpin] == 0} { continue }
        set innet [lindex [get_nets -quiet -of_objects [lindex $inpin 0]] 0]
        if {$innet eq ""} { continue }
        set innetname [get_property $innet name]
        regsub {^\\} $innetname {} innetname
        set master ""
        # longest name first so a substring never matches a shorter clock
        set _ne_clks {}
        foreach clk [all_clocks] { lappend _ne_clks [list [string length [get_property $clk name]] $clk] }
        foreach _pair [lsort -integer -decreasing -index 0 $_ne_clks] {
            set clk [lindex $_pair 1]
            set clkname [get_property $clk name]
            # Post-CTS the inverter input is a CTS leaf of the clock, e.g.
            # clknet_4_13_0_INJ_EDGE, so an exact match finds nothing
            # (measured post-PnR: inv=89 but src=0, and the clocks silently
            # did not exist).  Match the clock name anywhere in the net name,
            # longest name first so REF does not shadow REF_G_CLK.
            if {[string first $clkname $innetname] >= 0} {
                set master [get_property $clk sources]
                break
            }
        }
        if {$master eq ""} { continue }
        incr _diag_src
        set srcpin [list $master]
        set cname NE_CLK_$made
        if {[catch {
            # -invert alone is rejected (Error 388: missing -multiply_by,
            # -divide_by, -combinational or -edges); a waveform argument is
            # mandatory.  -divide_by 1 with -invert is exactly "same frequency,
            # opposite phase", which is what negedge registers want.
            create_generated_clock -name $cname -source [lindex $srcpin 0] \
                -divide_by 1 -invert $outpin
        } e]} {
            puts "WARNING: adpll.sdc: $cname failed: $e"
            continue
        }
        incr made
        # Remember which master clock this NE clock belongs to so the
        # set_clock_groups call after all clocks exist can place it in the
        # master's group explicitly (-source does not do that for us).
        if {![info exists ::NE_CLK_GROUPS]} { set ::NE_CLK_GROUPS [dict create] }
        dict lappend ::NE_CLK_GROUPS $clkname $cname
    }
    puts "adpll.sdc: NE_CLK diag clkpin=$_diag_clkpin drv=$_diag_drv inv=$_diag_inv src=$_diag_src made=$made"
    puts "adpll.sdc: NE_CLK declared on $made inverter clock(s)"
    return $made
}

# ---------------------------------------------------------------------------
# Clock quality

# after all master clocks exist.
# Opt-in: declaring the 89 negedge clocks is correct and is what makes them
# visible to STA, but doing so reveals a real cross-domain hold path
# (NE_CLK_1 -> DSM_CK_G_CLK, -0.4039) that needs a CDC decision.  Until that is
# settled, keep the default signoff numbers on the configuration that has been
# verified end-to-end and let the mode be selected explicitly.
# ---------------------------------------------------------------------------
# DCO_EN is a quasi-static enable, not data
# ---------------------------------------------------------------------------
# delta_sigma uses EN_DSM (driven by DCO_EN) only as a clock enable -- six
# register groups do `else if (EN_DSM) dff_* <= ...`, it never enters an adder
# or comparator.  Once the 89 negedge flops are declared this becomes a timed
# cross-domain path:
#   NE_CLK_1 (INJ_EDGE 20 ns) -> DSM_CK_G flop, hold -0.4039
# A synchronous enable has no hold relationship to satisfy, so exempt the
# enable's driver.  Anchored on the net name (DCO_EN survives CTS) rather than
# on an instance, because the driver pin is anonymous post-CTS.
# Default-on.  The 89 negedge flops (B14) are now timed, and the DCO_EN
# crossing that doing so exposed is closed in RTL by a 2FF synchroniser before
# delta_sigma's EN_DSM (pll_logic.v), not by an SDC exemption -- six exemption
# variants were tried and none moved the -0.4039.  Set
# ADPLL_DECLARE_NEGEDGE_CLOCKS=0 to fall back to the 11-clock view.
if {![info exists ::env(ADPLL_DECLARE_NEGEDGE_CLOCKS)] || $::env(ADPLL_DECLARE_NEGEDGE_CLOCKS)} {
    _declare_negedge_clocks
} else {
    puts "adpll.sdc: negedge clock declaration off (ADPLL_DECLARE_NEGEDGE_CLOCKS=1 to enable)"
}

# ---------------------------------------------------------------------------
# The ORFS ihp-sg13g2 platform does not publish these limits.  The setup
# uncertainty used to be the generic 0.250 ns placeholder, which is 13-19 % of
# the real MID_OUT period and dominated the budget.  Replace it with 0.050 ns
# (50 ps) for these domains.  Basis: the ISF/phase-noise work measures the
# free-running DCO residual jitter at <~1 ps and the tracked CDR jitter is
# bandwidth-limited (sim/outputs/ihp-sg13g2/lock/ISF_LOCK_NOTES.md §6), so
# 50 ps is still a conservative multi-cycle corner/jitter allowance, not a
# fully characterized period-jitter budget.
set_clock_uncertainty -setup 0.050 [all_clocks]
set_clock_uncertainty -hold  0.050 [all_clocks]
# set_max_transition 0.15 [current_design]

# ---------------------------------------------------------------------------
# Inputs
# ---------------------------------------------------------------------------
# REF-sampled configuration.  KP/KI/FCW are quasi-static during lock; DSM_* are
# mode straps.  They are timed as if driven by a REF-domain register.
#
# KP/KI are the loop-filter coefficients and they are consumed by
# pll_digital_loop_filter, whose clock is `.CLK(!INJ_EDGE)` -- i.e. they are
# sampled in the INJ_EDGE domain, on the inverted edge.  Constraining them
# against REF produced 14 hold violators once the negedge clocks were declared
# (KI[1]/KP[1] -> dlf.INT[*] / FILTER_OUT[*], -0.007 .. -0.153), which are
# cross-domain input paths rather than data flow: a coefficient does not change
# while the loop is locked.
#
# Declare them where they are actually sampled and exempt the crossing.  FCW
# stays on REF because it *is* re-read each REF cycle by the frequency counter.
set_input_delay -max 5.000 -clock REF [get_ports {FCW[*]}]
set_input_delay -min 1.000 -clock REF [get_ports {FCW[*]}]
set_input_delay -max 5.000 -clock INJ_EDGE [get_ports {KP[*] KI[*]}]
set_input_delay -min 1.000 -clock INJ_EDGE [get_ports {KP[*] KI[*]}]
set_false_path -from [get_ports {KP[*] KI[*]}]
set_input_delay -max 5.000 -clock REF [get_ports {DSM_EN_DT DSM_EN_SHDT DSM_ORDER[*]}]
set_input_delay -min 1.000 -clock REF [get_ports {DSM_EN_DT DSM_EN_SHDT DSM_ORDER[*]}]

# Divider ratio interface: quasi-static straps, not OUT-synchronous data.
set_false_path -from [get_ports {SET_DIV[*] LOAD_DIV}]
set_input_delay -max 5.000 -clock REF [get_ports {SET_DIV[*] LOAD_DIV}]
set_input_delay -min 1.000 -clock REF [get_ports {SET_DIV[*] LOAD_DIV}]

# Async reset and static enables are not data paths.
set_false_path -from [get_ports RST_N]
if {[llength [get_ports -quiet INJ_EN]] > 0} {
    set_false_path -from [get_ports INJ_EN]
}
# div_rst_n (pll_logic) is produced on posedge OUT; the divider's negedge
# domain re-times the deassert through div.rst_n_n, a constant-1 synchronizer
# flop.  Recovery of rst_n against rst_n_n only decides which negedge lifts
# the replica; a missed edge holds the negedge domain in reset one extra
# half cycle, harmless, so the check is disabled rather than timed.
set rst_n_n_regs [get_cells -quiet -hierarchical *rst_n_n*]
if {[llength $rst_n_n_regs] > 0} {
    set_false_path -to [get_pins -of_objects $rst_n_n_regs]
}
# div_rst_n/div_rst_n_b (pll_logic) are two identical posedge-OUT registers
# each feeding half the divider's async-clear pins.  Splitting the reset
# fanout was what brought the rst_n recovery residual inside the window --
# set_false_path/set_disable_timing do not cover a recovery check, so the
# fix lives in the RTL, not here.  rst_n_n (above) still re-times the
# release for the negedge domain.

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------
# LOCKED/ERR are launched on negedge INJ_EDGE (20 ns domain).
set_output_delay -max 5.000 -clock INJ_EDGE [get_ports {LOCKED ERR}]
set_output_delay -min 0.000 -clock INJ_EDGE [get_ports {LOCKED ERR}]
# OUT_DIV is the divider's *clock* output, not a data output.  The last
# stage is a clock mux: `use_clk` is a falling-edge flop (the /1 bypass
# select), and the mux output is the divided clock that feeds ddr_ck_gate.
# Constraining it with set_output_delay made STA treat a half-period clock-mux
# path as a data path and reported it as the SS/TT/FF setup violator
# (~-0.99 ns SS).  Declare it as a generated clock instead; the mux select is
# already guaranteed to move only while clk is low (see conf_div.v).
# The nominal waveform uses DIV_INIT=2 (the divider's power-on ratio); the
# runtime SET_DIV value changes the real period, which a static SDC cannot
# express.  That is acceptable for a canary because the divider's own
# reg->reg timing (the use_clk -> high_count path) is checked separately in
# the OUT group.
if {[llength [get_clocks -quiet OUT_DIV_CLK]] == 0} {
    # -source wants the *clock source*, and in the full top OUT is a macro pin,
    # not a port: [get_ports OUT] does not resolve there.  Passing an
    # unresolved source makes OpenSTA invent a second clock object whose name
    # is the master's plus a prime (OUT'), which then captures flops that the
    # real OUT group should own -- measured as `Endpoint: _4338_ (flip-flop
    # clocked by OUT')` on the worst TT path, i.e. those paths silently left
    # the OUT group.  Use the existing OUT clock's source instead.
    set out_src2 [get_ports -quiet OUT]
    if {[llength $out_src2] == 0} {
        set out_src2 [get_pins -quiet *pll_ana/OUT]
    }
    set out_div_pin [get_ports -quiet OUT_DIV]
    if {[llength $out_div_pin] == 0} {
        set out_div_pin [get_pins -quiet *OUT_DIV* -filter "direction==output"]
    }
    if {[llength $out_src2] > 0 && [llength $out_div_pin] > 0} {
        create_generated_clock -name OUT_DIV_CLK \
            -source [lindex $out_src2 0] -divide_by 2 [lindex $out_div_pin 0]
    } else {
        puts "WARNING: adpll.sdc: OUT_DIV_CLK not created (src [llength $out_src2], pin [llength $out_div_pin])"
    }
}
# CK (the DDR pad clock) is the same divided clock, gated by LOCKED.
if {[llength [get_clocks -quiet CK_CLK]] == 0} {
    set out_src3 [get_ports -quiet OUT]
    if {[llength $out_src3] == 0} {
        set out_src3 [get_pins -quiet *pll_ana/OUT]
    }
    set ck_pin [get_ports -quiet CK]
    if {[llength $ck_pin] == 0} {
        set ck_pin [get_pins -quiet *CK -filter "direction==output"]
    }
    if {[llength $out_src3] > 0 && [llength $ck_pin] > 0} {
        create_generated_clock -name CK_CLK \
            -source [lindex $out_src3 0] -divide_by 2 [lindex $ck_pin 0]
    } else {
        puts "WARNING: adpll.sdc: CK_CLK not created (src [llength $out_src3], pin [llength $ck_pin])"
    }
}


# ---------------------------------------------------------------------------
# Asynchronous clock groups (single declaration, after ALL clocks exist)
# ---------------------------------------------------------------------------
# Every generated clock must be listed: OpenSTA's create_generated_clock
# -source does not add it to the master's clock group, and a clock in no group
# is related to every other clock and timed synchronously.  The 78 NE_CLK_*
# negedge clocks (recorded in ::NE_CLK_GROUPS by _declare_negedge_clocks) are
# therefore appended to their master's group here.  Placing a clock in its
# master's group only removes cross-group checks; same-group negedge<->master
# (the CKR launch) and negedge<->negedge (INJ_EDGE) checks stay timed.
set _grp_REF     {REF REF_G_CLK}
set _grp_OUT     {OUT OUT_DIV_CLK CK_CLK}
set _grp_MID_OUT {MID_OUT DSM_CK_G_CLK FE_CLK_DIV OUT_DIV2_CLK CKR_CLK}
set _grp_INJ     {INJ_EDGE}
if {[info exists ::NE_CLK_GROUPS]} {
    dict for {_m _c} $::NE_CLK_GROUPS {
        switch -- $_m {
            REF - REF_G_CLK            { set _grp_REF     [concat $_grp_REF     $_c] }
            OUT - OUT_DIV_CLK - CK_CLK { set _grp_OUT     [concat $_grp_OUT     $_c] }
            INJ_EDGE                   { set _grp_INJ     [concat $_grp_INJ     $_c] }
            default                    { set _grp_MID_OUT [concat $_grp_MID_OUT $_c] }
        }
    }
}
puts "adpll.sdc: groups REF=[llength $_grp_REF] OUT=[llength $_grp_OUT] MID_OUT=[llength $_grp_MID_OUT] INJ_EDGE=[llength $_grp_INJ]"
set_clock_groups -asynchronous \
    -group $_grp_REF -group $_grp_OUT -group $_grp_MID_OUT -group $_grp_INJ


# DCO control buses only exist as ports in the digital-only top.  In the full
# top they are internal nets feeding pll_ana and must be constrained by the
# macro Liberty instead (not by an output delay).  They are quasi-static:
# COARSE/MID change at most once per REF cycle, FINE once per DSM cycle.
if {[llength [get_ports -quiet {COARSE_MUX[*]}]] > 0} {
    set_output_delay -max 0.500 -clock MID_OUT [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*]}]
    set_output_delay -min 0.000 -clock MID_OUT [get_ports {COARSE_MUX[*] MID_MUX[*] FINE_MUX[*]}]
    set_output_delay -max 2.000 -clock INJ_EDGE [get_ports DCO_EN]
    set_output_delay -min 0.000 -clock INJ_EDGE [get_ports DCO_EN]
}

# Load used by ckdur is 0.22 pF for every output.  That is too pessimistic and
# too uniform for a canary: use a small default and replace it with the actual
# macro input caps from PLL_ANALOG.lib when the macro exists.
set_load 0.050 [all_outputs]

# ---------------------------------------------------------------------------
# Explicitly NOT constrained (open items)
# ---------------------------------------------------------------------------
# - SS_BBPD -> loop filter: no macro Liberty yet.  When it exists, this must be
#   a real setup/hold check against negedge INJ_EDGE, not a false path.
# - CKR and DSM_CK: internally generated clocks; add create_generated_clock
#   after synthesis/CTS names are stable.
# - COARSE_MUX/MID_MUX/FINE_MUX in the full top: constrain at the macro pins
#   from PLL_ANALOG.lib (input caps + setup/hold), not as top-level outputs.
# - VDDO/IO 3.3 V domain: not present.  This canary uses only the 1.2 V core
#   library; the 3.3 V sg13g2_stdcell_hv library is intentionally not mixed in.
