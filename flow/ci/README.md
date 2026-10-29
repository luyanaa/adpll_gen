# CI canaries

Canaries are **flow smoke tests**, not product defaults.

- One combination per PDK, chosen for simplicity and coverage of the PDK's
  basic flow.
- Run on every change to `flow/`, the LibreLane config generator, the cell
  mapping, or the hard-macro interface.
- A canary pass means the flow still runs and produces the expected artifacts;
  it does not mean the library is the best choice.
- A canary failure blocks merging until the flow is fixed or the canary is
  intentionally updated with a reason.
- When a new PDK or library family is added, add one canary for it; do not add
  every library as a canary.

`canary.json` is the source of truth. The entries are deliberately not the
same as `selection.example.json`.
