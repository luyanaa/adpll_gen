#!/usr/bin/env python3
"""CDC contract and starter constraints for the Gray frequency counter.

This is a design-review artifact, not a claim that a placed design meets the
skew.  It gives the delivery generator a concrete constraint file and a
machine-readable checklist for the synchronizer/bus.
"""
from __future__ import annotations

from typing import Any


def cdc_contract(cnt_bits: int = 8,
                 extra_bits: int = 8,
                 meas_periods: int = 1) -> dict[str, Any]:
    return {
        "schema_version": 1,
        "counter_width": cnt_bits + extra_bits,
        "source_clock": "MID_OUT",
        "destination_clock": "REF",
        "bus": "cnt_gray",
        "source_encoding": "Gray",
        "synchronizer_stages": 2,
        "synchronizer_attribute": "ASYNC_REG",
        "measurement_periods": meas_periods,
        "max_skew_ns": 0.5,
        "requirements": [
            "all Gray bits launch from one MID_OUT register bank",
            "no combinational logic on the Gray bus before the 2FF sampler",
            "synchronizer registers placed together in the REF domain",
            "reset assertion asynchronous, deassertion synchronized per domain",
            "counter width covers max DCO/REF ratio for the acquisition range",
            "run CDC/clock-domain checks and review timing exceptions",
            "do not add a broad false_path that masks the Gray max-delay check",
        ],
        "status": "TEMPLATE_ONLY_NOT_SIGNOFF",
    }


def sdc_text(dco_period_ns: float,
             ref_period_ns: float,
             cnt_bits: int = 8,
             extra_bits: int = 8,
             meas_periods: int = 1) -> str:
    """Return starter CDC constraints.

    ``dco_period_ns`` is the actual raw DCO period.  ``ref_period_ns`` is the
    REF period.  The previous generator passed REF for both, which made the
    source clock appear ten times slower than the DCO in the 100/1000 MHz
    example.  MID_OUT is internal and is therefore constrained with
    ``get_pins``; using ``get_ports MID_OUT`` would silently create nothing.
    """
    width = cnt_bits + extra_bits
    return f"""# Generated Gray-bus CDC starter constraints.
# Review hierarchy names after synthesis; these globs are intentionally
# conservative and do not grant CDC or timing signoff.
# Gray width: {width} bits; measurement window: {meas_periods} REF period(s).
# DCO period: {dco_period_ns:.6f} ns; REF period: {ref_period_ns:.6f} ns.

# Apply adpll.sdc first.  These guards only create the clocks when this CDC
# fragment is used standalone, so loading both files does not redefine clocks.
if {{[llength [get_clocks -quiet REF]] == 0}} {{
  create_clock -name REF -period {ref_period_ns:.6f} [get_ports REF]
}}
# MID_OUT is an internal clock in u_pll, not a top-level port.  Its period must
# be the actual DCO period, not the REF period.
if {{[llength [get_clocks -quiet MID_OUT]] == 0}} {{
  create_clock -name MID_OUT -period {dco_period_ns:.6f} \
    [get_pins -hierarchical *u_pll*MID_OUT]
}}

# Source-side Gray register bank (frontend gray_q) and the first destination
# flop.  Keep all bits in one bank and do not insert logic between source and
# synchronizer.  These globs are deliberately matched to the RTL names and
# must be re-checked after synthesis; an empty get_pins is a defect.
set_max_skew 0.500 -from [get_pins -hier *counter_frontend*gray_q*] \
  -to [get_pins -hier *cnt_gray_s1*]
set_max_delay -datapath_only 0.500 \
  -from [get_pins -hier *counter_frontend*gray_q*] \
  -to [get_pins -hier *cnt_gray_s1*]

# The Gray value is a data word, not an edge event.  Do not use it as a
# single-bit synchronizer; the REF domain subtracts consecutive words.
# Deliberately no broad set_false_path here: it would override the max-delay
# constraint above in STA.  The clock relationship is declared in the top SDC.
"""
