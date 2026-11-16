#!/usr/bin/env python3
"""CDC contracts and starter constraints for the digital lock path.

This is a design-review artifact, not a claim that a placed design meets the
skew.  Every channel carries its own definition, constraint, verification and
waiver so a new synchronizer cannot silently inherit the frequency-counter
template.

Channels:
  freq_count    MID_OUT -> REF, Gray count bus, 2FF
  dco_activity  OUT -> REF, Gray edge counter, 2FF
  ref_level     REF -> OUT, single-bit level, 2FF (sampled-liveness)
"""
from __future__ import annotations

from typing import Any


def cdc_channels(cnt_bits: int = 8,
                 extra_bits: int = 8,
                 meas_periods: int = 1,
                 dco_act_bits: int = 10) -> list[dict[str, Any]]:
    """Return one contract per CDC channel in the lock path."""
    return [
        {
            "name": "freq_count",
            "kind": "gray_bus",
            "source_clock": "MID_OUT",
            "destination_clock": "REF",
            "bus": "cnt_gray",
            "width": cnt_bits + extra_bits,
            "encoding": "Gray",
            "synchronizer_stages": 2,
            "source_glob": "*counter_frontend*gray_q*",
            "destination_glob": "*cnt_gray_s1*",
            "max_skew_ns": 0.5,
            "constraints": ["set_max_skew", "set_max_delay -datapath_only"],
            "verification": "freq_lock_cdc_tb: independent MID_OUT edge count "
                            "against the captured delta",
            "waiver": "",
            "measurement_periods": meas_periods,
            "status": "TEMPLATE_ONLY_NOT_SIGNOFF",
        },
        {
            "name": "dco_activity",
            "kind": "gray_bus",
            "source_clock": "OUT",
            "destination_clock": "REF",
            "bus": "out_edges_gray",
            "width": dco_act_bits,
            "encoding": "Gray",
            "synchronizer_stages": 2,
            "source_glob": "*out_edges_gray*",
            "destination_glob": "*out_edges_g1*",
            "max_skew_ns": 0.5,
            "constraints": ["set_max_skew", "set_max_delay -datapath_only"],
            "verification": "lock_fsm_tb: DCO stuck-high/stuck-low/stopped "
                            "drop LOCKED; Gray changes one bit per OUT edge",
            "waiver": "",
            "status": "TEMPLATE_ONLY_NOT_SIGNOFF",
        },
        {
            "name": "ref_level",
            "kind": "level",
            "source_clock": "REF",
            "destination_clock": "OUT",
            "bus": "watch_s1",
            "width": 1,
            "encoding": "level",
            "synchronizer_stages": 2,
            "source_glob": "port:REF",
            "destination_glob": "*watch_s1*",
            "max_skew_ns": None,
            "constraints": [],
            "verification": "ref_watchdog_tb: normal ratio, REF stop, and "
                            "the 1:1 alias case",
            "waiver": "sampled liveness aliases at integer DCO/REF ratios, "
                      "including FCW=1.  A hard clock-fault contract needs an "
                      "independent always-on monitor or analog clock detector.",
            "status": "REVIEW_ONLY",
        },
    ]


def cdc_contract(cnt_bits: int = 8,
                 extra_bits: int = 8,
                 meas_periods: int = 1,
                 dco_act_bits: int = 10) -> dict[str, Any]:
    return {
        "schema_version": 2,
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
            "all Gray bits launch from one source-domain register bank",
            "no combinational logic on a Gray bus before the 2FF sampler",
            "synchronizer registers placed together in the destination domain",
            "reset assertion asynchronous, deassertion synchronized per domain",
            "counter width covers max DCO/REF ratio for the acquisition range",
            "run CDC/clock-domain checks and review timing exceptions",
            "do not add a broad false_path that masks a Gray max-delay check",
            "every channel has an explicit verification and waiver entry",
        ],
        "channels": cdc_channels(cnt_bits, extra_bits, meas_periods,
                                 dco_act_bits),
        "status": "TEMPLATE_ONLY_NOT_SIGNOFF",
    }


def sdc_text(dco_period_ns: float,
             ref_period_ns: float,
             cnt_bits: int = 8,
             extra_bits: int = 8,
             meas_periods: int = 1,
             dco_act_bits: int = 10) -> str:
    """Return starter CDC constraints for every channel.

    ``dco_period_ns`` is the actual raw DCO period.  ``ref_period_ns`` is the
    REF period.  MID_OUT is internal and is therefore constrained with
    ``get_pins``; using ``get_ports MID_OUT`` would silently create nothing.
    """
    width = cnt_bits + extra_bits
    channels = cdc_channels(cnt_bits, extra_bits, meas_periods, dco_act_bits)
    freq = channels[0]
    act = channels[1]
    level = channels[2]
    return f"""# Generated CDC starter constraints for {len(channels)} channels.
# Review hierarchy names after synthesis; these globs are intentionally
# conservative and do not grant CDC or timing signoff.
# freq_count: {width} bits, {meas_periods} REF period(s), Gray, 2FF.
# dco_activity: {dco_act_bits} bits, Gray, 2FF.
# ref_level: 1 bit, level, 2FF; waiver: {level['waiver']}
# DCO period: {dco_period_ns:.6f} ns; REF period: {ref_period_ns:.6f} ns.

# Apply adpll.sdc first.  These guards only create the clocks when this CDC
# fragment is used standalone, so loading both files does not redefine clocks.
if {{[llength [get_clocks -quiet REF]] == 0}} {{
  create_clock -name REF -period {ref_period_ns:.6f} [get_ports REF]
}}
if {{[llength [get_clocks -quiet DCO_OUT]] == 0}} {{
  create_clock -name DCO_OUT -period {dco_period_ns:.6f} [get_ports OUT]
}}
# MID_OUT is an internal clock in u_pll, not a top-level port.
if {{[llength [get_clocks -quiet MID_OUT]] == 0}} {{
  create_clock -name MID_OUT -period {dco_period_ns:.6f} \
    [get_pins -hierarchical *u_pll*MID_OUT]
}}

# freq_count: {freq['source_clock']} -> {freq['destination_clock']}, Gray.
set_max_skew 0.500 -from [get_pins -hier {freq['source_glob']}] \
  -to [get_pins -hier {freq['destination_glob']}]
set_max_delay -datapath_only 0.500 \
  -from [get_pins -hier {freq['source_glob']}] \
  -to [get_pins -hier {freq['destination_glob']}]

# dco_activity: {act['source_clock']} -> {act['destination_clock']}, Gray.
set_max_skew 0.500 -from [get_pins -hier {act['source_glob']}] \
  -to [get_pins -hier {act['destination_glob']}]
set_max_delay -datapath_only 0.500 \
  -from [get_pins -hier {act['source_glob']}] \
  -to [get_pins -hier {act['destination_glob']}]

# ref_level: REF -> OUT, 2FF level synchronizer at *watch_s1*.  No max-delay
# is imposed on a single-bit level path; the contract is the synchronizer and
# its waiver.
# Do not add a broad set_false_path here: it would also mask the Gray
# max-delay constraints above.
"""


if __name__ == "__main__":
    import json
    print(json.dumps(cdc_contract(), indent=2, sort_keys=True))
