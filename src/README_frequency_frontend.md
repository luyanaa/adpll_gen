# Frequency-counter frontend

`frequency_counter_frontend.v` isolates the DCO-domain counter from the
acquisition FSM.  It is selectable, not hardcoded to a ripple prescaler.

| `MODE` | Structure | CDC status |
|---|---|---|
| 0 | synchronous binary counter (default) | synchronously generated; can be Gray-sampled by the REF domain |
| 1 | asynchronous ripple counter | **not** CDC-safe for multi-bit capture; needs a stable capture or per-bit synchronization |
| 2 | 4-stage Johnson prescaler + synchronous extension/decode | experimental; extra state/decode; not automatically CDC-safe |

`COUNT`/`GRAY_COUNT` are DCO-domain outputs.  `CDC_SAFE` is a structural hint,
not a proof: the REF-domain sampler in `freq_lock.v` still needs the Gray
handshake, skew analysis and reset sequencing.  Ripple and Johnson modes must
not be selected merely because they reduce high-frequency logic; they trade
that for asynchronous state, glitches and metastability.

The existing linear acquisition uses `FRONTEND_MODE=0` by default.  Any change
to mode 1/2 requires simulation with realistic skew and a CDC review before it
can be considered for a build.
