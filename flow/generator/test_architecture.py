from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))

from architecture import select


def main():
    # ETRI: low frequency, area sensitive -> Core C, not Core A.
    r = select("ETRI050_fd_sc_12t", 5, area="high")
    assert r["status"] == "PASS_ARCH_SELECTED_EXPERIMENTAL", r["status"]
    assert r["selected"]["id"] == "core_c_counter", r["selected"]
    assert r["library"]["library"] == "ETRI050_fd_sc_12t", r["library"]
    assert r["production_eligible"] is False

    # The ETRI ceiling is 5 MHz, not the 90 MHz pre-layout number.
    r = select("etri050", 20)
    assert r["status"] == "FAIL_SYSTEM_FMAX", r

    # GF180 AS: mid frequency -> ring; area-tight low frequency -> counter.
    r = select("gf180mcu_as_sc_mcu7t3v3", 100, area="medium", ref_mhz=50)
    assert r["selected"]["id"] == "core_b_ring_dco", r["selected"]
    r = select("gf180mcu_as_sc_mcu7t3v3", 100, area="high", ref_mhz=50)
    assert r["selected"]["id"] == "core_c_counter", r["selected"]
    r = select("gf180mcu_as_sc_mcu7t3v3", 200, ref_mhz=50)
    assert r["status"] == "FAIL_SYSTEM_FMAX", r

    # ics55 high target: segmented IL-DCO is preferred.  The conservative
    # digital signoff ceiling is only 479 MHz, so this is experimental.
    r = select("ics55", 800, area="medium", ref_mhz=100)
    assert r["selected"]["id"] in ("segmented_il_dco", "core_a_il_dco"), r["selected"]
    assert any("signoff ceiling" in w for w in r["warnings"]), r["warnings"]
    assert r["production_eligible"] is False
    r = select("ics55", 800, area="medium", ref_mhz=100, require_signoff=True)
    assert r["status"] == "FAIL_SIGNOFF_FMAX", r

    # IHP mid/high target is a valid architecture candidate.
    r = select("ihp-sg13g2", 300, area="medium", ref_mhz=100)
    assert r["status"].startswith("PASS_"), r
    assert r["selected"]["core"] in ("core_a_il_dco", "core_b_ring_dco"), r["selected"]

    # Fractional request must select a fractional-capable architecture.
    r = select("ics55", 600, area="medium", ref_mhz=100, fractional=True)
    assert "fractional_n" in r["selected"]["features"], r["selected"]

    print("test_architecture: PASS")


if __name__ == "__main__":
    main()
