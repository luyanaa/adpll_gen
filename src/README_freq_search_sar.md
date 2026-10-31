# SAR / binary-search frequency acquisition

`freq_search_sar.v` is an optional, standalone search controller.  It is not
wired into `freq_lock.v` by default.  Linear acquisition remains the default
until a measured tuning map proves that coarse and mid code order is monotonic
over the full operating range.

For a 16 x 16 map, a two-stage binary search takes about
`ceil(log2(16)) + ceil(log2(16)) = 8` comparison decisions.  That is **not** a
lock in 8 REF cycles: each comparison needs a settled DCO code, a frequency
observation window, and a valid observation; retries, timeout and final phase
acquisition are additional.

The controller requires `MONOTONIC_MAP_VALID`.  When it is low, the controller
asserts `FALLBACK` and does not take ownership of the DCO codes.  The
`src/dco_tuning_map.schema.json` file defines the evidence that must be
provided before setting that input high.  No production map is shipped here.

The timeout path asserts `ERR`; it is a search failure, not a DCO lock.
