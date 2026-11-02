# PHASE_SELECTOR_TOP — glitch-managed phase selector spec

## Concept

Select one of `NTAPS` equally-spaced clock phases.  The phases are the
taps of the shared DCDL cascade (COARSE→MID→FINE); the selector is a
MUX over the tap-out bus.  Used standalone it is a clock rotator; in a
CDR/DLL it is the element that maps a phase code onto a clock edge.

The only non-trivial part is **glitchless switching**: moving the
select while an edge is inside the line produces a runt pulse.  This
block does the standard two-phase handoff — park the output low for
`DEAD_TICKS`, then reconnect the new tap — so the MUX never switches
under a live edge.

## Ports

| Port | Dir | Description |
|---|---|---|
| `CLK_IN` | in | Source clock driving the tap line. |
| `RST_N`,`TICK` | in | Reset / control clock for the handoff FSM. |
| `SEL_REQ` | in | Requested tap index (`SEL_BITS` wide). |
| `SEL_UPD` | in | Strobe: begin the handoff to `SEL_REQ`. |
| `CLK_OUT` | out | Selected phase (parked low while `BUSY`). |
| `SEL_CUR` | out | Tap the FSM has committed to. |
| `BUSY` | out | Handoff in progress — output is parked. |

## Behaviour

1. `SEL_UPD && SEL_REQ != sel_act` → `switching`, `SEL_CUR<=SEL_REQ`,
   output parked low, `dead = DEAD_TICKS`.
2. `dead` counts down on TICK; at 0 → `sel_act <= SEL_CUR`,
   `switching`/`BUSY` clear, output reconnects to `tap[sel_act]`.
3. Minimum switching latency = `DEAD_TICKS + 1` TICKs; the output is
   guaranteed low throughout (no runt edges).

## Status / open items

- Functional model verified (`phase_selector_tb`): `SEL_CUR` walks to
  the requested tap, handoff completes, narrowest output pulse is a
  clean half-cycle (~500 ps at a 1 ns source) — **no runt pulses**.
- **SIMULATION taps** are behavioural `#g*STEP` delayed copies of
  `CLK_IN`; the silicon view expects a real DCDL tap-out bus on `tap`
  (left as a port-level hook `wire [NTAPS-1:0] tap` under `ifndef`).
- **Open**: a real rotator interleaves a thermometer/grey decode so
  adjacent taps differ by one switching element (fewer runt-risk
  nets); the current binary `tap[sel_act]` MUX is the simplest form
  and may need a one-hot decode + per-tap gate for the physical cell.
- Dead time is in TICKs, not a timed quiet window — for a source whose
  period is >> the tap span the park is safely longer than any edge
  transit; document the assumption when instantiated.
