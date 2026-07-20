# 2026-07-20 R0 review consensus

## Result

Both independent R0 reviewers PASSed the exact candidate:

- Candidate: `JIGS/QC-IN_PROGRESS/v1.2-validator-hardening.keymap`
- SHA-256: `faa1612fc82c6c23bfa43e1f1551a576a6a3feeaee2bbb0af9d9c3cd219d056d`
- Reviewer A: `v1.2-validator-hardening.review-a.md`
- Reviewer B: `v1.2-validator-hardening.review-b.md`

## Verified controls

- Candidate is byte-identical to the immutable HRM baseline.
- The baseline and candidate pass the baseline-aware validator.
- The known-bad v1.1 active map is rejected, including the position-77
  Mac/Win-switch regression.
- Four layers contain 82 ordered bindings each, and all 20 protected
  direct-control bindings match the immutable baseline.
- The factory rollback UF2 path and SHA-256 are recorded in the R0 QC record.

## Scope boundary

R0 authorizes no build, UF2, flash, or hardware test. The next gate is R1 and
requires the user's explicit KEY-00 decision for the Mac/Win direct control.
