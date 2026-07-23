# 2026-07-20 R0 validation hardening

## User authorization

The user approved R0 validation hardening only: no key-binding edits, build,
UF2, flash, or hardware work.

## Work completed

- Replaced `scripts/validate-keymap.ps1` with a baseline-aware validator.
- Added the v1.2 manifest and QC record under `JIGS/QC-IN_PROGRESS/`.
- Refreshed Reviewer A's record for the exact staged candidate SHA-256.
- Corrected the backlog's direct-control map to match the immutable HRM
  baseline: Layer 0 has the Mac/Win and output controls; Layers 1 through 3
  end in five `&none` bindings each.

## Validation evidence

- Immutable HRM baseline: passed.
- `v1.2-validator-hardening.keymap`: passed.
- Active known-bad v1.1 map: rejected for changed definitions, layer names,
  position-77 Mac/Win binding, 73 unapproved positions, and the four-key cap.
- Temporary one-binding test: passed only when its zero-based position 0 was
  explicitly approved.
- Candidate-to-baseline byte diff: empty.
- No project PowerShell lint or automated test runner was configured for this
  script; focused execution tests and a manual simplify/quality pass were run.

## Status

Reviewer A PASSes the exact candidate
`faa1612fc82c6c23bfa43e1f1551a576a6a3feeaee2bbb0af9d9c3cd219d056d`.
R0 remains incomplete until an independent Reviewer B PASSes that same hash.
No build or hardware action is authorized.

## Workflow recommendation

After Reviewer B validates the process, consider exporting the candidate,
manifest, direct-control-map, and baseline-aware-validator sequence as a
reusable B1 Pro QC skill. It is not mature enough to package yet.
