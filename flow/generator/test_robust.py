from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent))
from robust import Point, check_target, feasible_runs


def pts(vals, c=0, m=0):
    return [Point(c, m, i, f) for i, f in enumerate(vals)]


def main():
    corners = {
        "tt": pts([900, 800, 700, 600, 500]),
        "ss": pts([850, 750, 680, 580, 480]),
        "ff": pts([950, 850, 720, 620, 520]),
    }
    r = check_target(corners, 680, margin_mhz=20)
    assert r["status"] == "PVT_FREQUENCY_SCREEN", r
    assert r["production_eligible"] is False

    corners["ss"] = pts([400, 350, 300, 250, 200])
    r = check_target(corners, 680, margin_mhz=20)
    assert r["status"] == "FAIL_DISJOINT", r

    corners["tt"] = pts([900, 800, 700, 600, 500])
    corners["ss"] = pts([850, 750, 680, 580, 480])
    r = check_target(corners, 680, margin_mhz=20,
                     jitter_verified=True, drc_lvs_verified=True)
    assert r["status"] == "PVT_FREQUENCY_SCREEN", r
    assert r["production_eligible"] is False

    r = check_target(corners, 680, margin_mhz=20,
                     jitter_verified=True, drc_lvs_verified=True,
                     pex_verified=True, pvt_verified=True,
                     lock_verified=True, sta_verified=True,
                     injection_verified=True, evidence_key="core_a/hash")
    assert r["status"] == "PVT_FREQUENCY_SCREEN", r
    assert r["production_eligible"] is False
    assert r["evidence_complete"] is True

    # An invalid code breaks the run; do not connect code 1 directly to code 3.
    gap = [Point(0, 0, 0, 400.0), Point(0, 0, 1, 300.0),
           Point(0, 0, 2, 200.0, False), Point(0, 0, 3, 100.0)]
    assert feasible_runs(gap, 10.0) == [(310.0, 390.0)], feasible_runs(gap, 10.0)

    # A missing required corner cannot pass by simply having three datasets.
    r = check_target({"TT": pts([900, 800, 700, 600, 500]),
                       "SS": pts([850, 750, 680, 580, 480]),
                       "FF": pts([950, 850, 720, 620, 520])},
                     680, margin_mhz=20)
    assert r["status"] == "PVT_FREQUENCY_SCREEN", r
    print("test_robust: PASS")


if __name__ == "__main__":
    main()
