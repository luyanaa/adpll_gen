from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))

from capability import check_target
from system_limits import check_system, limits


def main():
    # Measured GF180 AS 3.3 V: OUT 196.37 MHz SS, REF/INJ <= 163.53/96.70 MHz.
    assert limits("gf180mcu_as_sc_mcu7t3v3")["max_out_mhz"] == 150.0
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 200)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 150, ref_mhz=80)
    assert r is None, r
    r = check_system("gf180mcu_as_sc_mcu7t3v3", 150, ref_mhz=100)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r

    # ETRI is not allowed to inherit the 90 MHz pre-layout number as a
    # signoff ceiling: the routed canary does not close timing.
    r = check_system("ETRI050_fd_sc_12t", 20)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r
    r = check_system("etri050", 5, ref_mhz=5, fcw=4)
    assert r is None, r
    r = check_system("etri050", 6, ref_mhz=5)
    assert r and r["status"] == "FAIL_SYSTEM_FMAX", r

    # A target under the system ceiling still cannot pass without a DCO table.
    r = check_target("gf180mcu_as_sc_mcu7t3v3", 100, ref_mhz=50)
    assert r["status"] == "FAIL_UNCHARACTERIZED", r
    r = check_target("etri050", 5, ref_mhz=5)
    assert r["status"] == "FAIL_UNCHARACTERIZED", r

    print("test_system_limits: PASS")


if __name__ == "__main__":
    main()
