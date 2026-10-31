from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))

from capability import check_target
from system_limits import check_system, limits


def main():
    # Measured GF180 AS 3.3 V: OUT 196.37 MHz SS, REF <= 163.53 MHz.
    assert limits("gf180mcu_as_sc_mcu7t3v3")["max_out_mhz"] == 150.0
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 200)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 150, ref_mhz=80)
    assert r is None, r
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 150, ref_mhz=100)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r

    # Frequency plan: target=100, REF=50, FCW=8 is inconsistent (N=2).
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 100, ref_mhz=50, fcw=8)
    assert r and r["status"] == "FAIL_FREQUENCY_PLAN", r
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 100, ref_mhz=50, fcw=2)
    assert r is None, r

    # A PDK name is not an evidence identity.  The same library under another
    # view/flow must not silently reuse the 150 MHz result.
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 100,
                     require_identity=True)
    assert r and r["status"] == "FAIL_EVIDENCE_IDENTITY", r
    identity = {
        "process_id": "gf180mcu",
        "standard_cell_library": "gf180mcu_as_sc_mcu7t3v3",
        "technology_view": "3.3V",
        "physical_flow": "librelane",
        "timing_corner": "SS",
    }
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 100, identity=identity)
    assert r is None, r
    bad = dict(identity, technology_view="5V")
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 100, identity=bad)
    assert r and r["status"] == "FAIL_EVIDENCE_IDENTITY", r

    # ETRI is not allowed to inherit the 90 MHz pre-layout number.
    r = check_system("ETRI050_fd_sc_12t", 20)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r
    r = check_system("etri050", 5, ref_mhz=5, fcw=1)
    assert r is None, r
    r = check_system("etri050", 6, ref_mhz=5, fcw=1)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r

    # A target under the system ceiling still cannot pass without a DCO table.
    r = check_target("gf180mcu_as_sc_mcu7t3v3", 100, ref_mhz=50, fcw=2)
    assert r["status"] == "FAIL_UNCHARACTERIZED", r
    r = check_target("etri050", 5, ref_mhz=5, fcw=1)
    assert r["status"] == "FAIL_UNCHARACTERIZED", r
    r = check_target("ics55", 800, ref_mhz=100, fcw=8,
                     architecture_id="core_b_ring_dco",
                     implementation_id="simulation")
    assert r["status"] == "NEEDS_DCO_CHARACTERIZATION", r
    r = check_target("ics55", 800, ref_mhz=100, fcw=8,
                     architecture_id="core_a_il_dco",
                     implementation_id="simulation")
    assert r["status"] == "NEEDS_DCO_CHARACTERIZATION", r

    print("test_system_limits: PASS")


if __name__ == "__main__":
    main()
