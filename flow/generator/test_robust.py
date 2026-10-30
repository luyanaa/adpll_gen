from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))
from robust import Point, check_target

def pts(vals, c=0, m=0):
    return [Point(c, m, i, f) for i, f in enumerate(vals)]

def main():
    # Three corners, overlapping 500..700 MHz, local tuning margin 20 MHz.
    corners = {
        "tt": pts([900, 800, 700, 600, 500]),
        "ss": pts([850, 750, 680, 580, 480]),
        "ff": pts([950, 850, 720, 620, 520]),
    }
    r = check_target(corners, 680, margin_mhz=20)
    assert r["status"] == "PASS_L3_ROBUST_EXPERIMENTAL", r
    # A disjoint corner must fail rather than fall back to a nearest code.
    corners["ss"] = pts([400, 350, 300, 250, 200])
    r = check_target(corners, 680, margin_mhz=20)
    assert r["status"] == "FAIL_DISJOINT", r
    # No explicit signoff flags -> never production.
    corners["tt"] = pts([900, 800, 700, 600, 500])
    corners["ss"] = pts([850, 750, 680, 580, 480])
    r = check_target(corners, 680, margin_mhz=20,
                     jitter_verified=True, drc_lvs_verified=False)
    assert r["production_eligible"] is False
    print("test_robust: PASS")

if __name__ == "__main__":
    main()
