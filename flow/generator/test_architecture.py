from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))

from architecture import select, selection_template


def main():
    # Core C RTL exists, but ETRI has no core-specific physical macro entry.
    r = select("ETRI050_fd_sc_12t", 5, area="high", mode="explore")
    assert r["status"] == "PASS_ARCH_SELECTED_EXPERIMENTAL", r["status"]
    assert r["selected"]["id"] == "core_c_counter", r["selected"]
    assert r["selected"]["implementation_state"] == "RTL_SYNTHESIZABLE", r["selected"]
    assert r["dco_capability"]["status"] == "NEEDS_DCO_CHARACTERIZATION", r
    assert r["selected"]["physical_buildable"] is False

    r = select("ETRI050_fd_sc_12t", 5, area="high")
    assert r["status"] == "FAIL_NO_ARCHITECTURE", r

    # The ETRI ceiling is 5 MHz, not the 90 MHz pre-layout number.
    r = select("etri050", 20, mode="explore")
    assert r["status"] == "FAIL_SYSTEM_FMAX", r

    # gf180mcu now has core-specific physical ring/counter macros.
    r = select("gf180mcu_as_sc_mcu7t3v3", 100, area="medium",
               ref_mhz=50, mode="buildable")
    assert r["status"] == "PASS_ARCH_SELECTED_PHYSICAL", r
    assert r["selected"]["id"] == "core_b_ring_dco", r["selected"]
    assert r["selected"]["implementation_state"] == "PHYSICAL_IMPLEMENTABLE", r
    assert r["dco_capability"]["status"] == "NEEDS_DCO_CHARACTERIZATION", r
    r = select("gf180mcu_as_sc_mcu7t3v3", 25, area="high",
               ref_mhz=25, fcw=1, mode="buildable")
    assert r["status"] == "PASS_ARCH_SELECTED_PHYSICAL", r
    assert r["selected"]["id"] == "core_c_counter", r["selected"]
    assert r["selected"]["physical_buildable"] is True
    r = select("gf180mcu_as_sc_mcu7t3v3", 200, ref_mhz=50, mode="explore")
    assert r["status"] == "FAIL_SYSTEM_FMAX", r

    # ics55 Core B/C have core-specific physical macro entries and are
    # buildable physical candidates; DCO evidence remains a separate gate.
    r = select("ics55", 100, area="medium", ref_mhz=10, fcw=10)
    assert r["status"] == "PASS_ARCH_SELECTED_PHYSICAL", r
    assert r["selected"]["id"] == "core_b_ring_dco", r["selected"]
    assert r["selected"]["implementation_state"] == "PHYSICAL_IMPLEMENTABLE", r
    assert r["selected"]["physical_buildable"] is True
    assert r["dco_capability"]["status"] == "NEEDS_DCO_CHARACTERIZATION"
    r = select("ics55", 20, area="high", ref_mhz=10, fcw=2)
    assert r["status"] == "PASS_ARCH_SELECTED_PHYSICAL", r
    assert r["selected"]["id"] == "core_c_counter", r["selected"]
    assert r["selected"]["physical_buildable"] is True
    tpl = selection_template(r)
    assert tpl["blocks"]["dco"]["kind"] == "hard_macro", tpl

    # Core A has a bound L1 manifest and its own physical macro.
    r = select("ics55", 800, area="medium", ref_mhz=100, fcw=8)
    assert r["status"] == "PASS_ARCH_SELECTED_WITH_DCO", r
    assert r["selected"]["id"] == "core_a_il_dco", r["selected"]
    assert r["selected"]["physical_buildable"] is True
    assert r["library"]["library"] == "ics55_LLSC_H7CR", r["library"]
    assert r["production_eligible"] is False
    r = select("ics55", 800, area="medium", ref_mhz=100, fcw=8,
               require_signoff=True)
    assert r["status"] == "FAIL_SIGNOFF_FMAX", r

    r = select("ics55", 800, area="medium", ref_mhz=100, fcw=8,
               allow_unimplemented=True, mode="explore")
    assert r["selected"]["implementation"] == "missing", r["selected"]

    # IHP has a physical Core A path but the target must still match its
    # architecture band; 300 MHz is a valid physical candidate.
    r = select("ihp-sg13g2", 300, area="medium", ref_mhz=100, fcw=3)
    assert r["status"].startswith("PASS_"), r
    assert r["selected"]["core"] == "core_a_il_dco", r["selected"]

    # DSM is not a fractional feedback implementation.
    r = select("ics55", 600, area="medium", ref_mhz=100, fcw=6,
               fractional=True, mode="explore")
    assert r["status"] == "FAIL_NO_ARCHITECTURE", r
    r = select("ics55", 600, area="medium", ref_mhz=100, fcw=6,
               fractional=True, mode="explore", allow_unimplemented=True)
    assert r["selected"]["id"] == "fractional_n_feedback", r["selected"]
    assert r["selected"]["implementation_class"] == "FRACTIONAL_N_FEEDBACK"

    # A fractional/DSM candidate is not a physical hard-macro template even
    # when it carries partial RTL.
    r = select("ics55", 600, area="medium", ref_mhz=100, fcw=6,
               fractional=True, mode="explore", allow_unimplemented=True)
    tpl = selection_template(r)
    assert tpl["blocks"]["dco"]["kind"] == "soft", tpl

    # A planning call can require the exact limit identity; a PDK name alone
    # is not allowed to borrow another view/flow result.
    r = select("gf180mcu_as_sc_mcu7t3v3", 100, ref_mhz=50, fcw=2,
               require_identity=True)
    assert r["status"] == "FAIL_EVIDENCE_IDENTITY", r
    identity = {
        "process_id": "gf180mcu",
        "standard_cell_library": "gf180mcu_as_sc_mcu7t3v3",
        "technology_view": "3.3V",
        "physical_flow": "librelane",
        "timing_corner": "SS",
    }
    r = select("gf180mcu_as_sc_mcu7t3v3", 100, ref_mhz=50, fcw=2,
               evidence_identity=identity, require_identity=True)
    assert r["status"] != "FAIL_EVIDENCE_IDENTITY", r

    # Frequency planning is checked before architecture selection.
    r = select("gf180mcu_as_sc_mcu7t3v3", 100, ref_mhz=50, fcw=8,
               mode="explore")
    assert r["status"] == "FAIL_FREQUENCY_PLAN", r

    print("test_architecture: PASS")


if __name__ == "__main__":
    main()
