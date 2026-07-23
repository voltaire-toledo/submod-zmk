# Session Transcript: R1 Direct-Control Safety (2026-07-20)

## Scope and decision

- Proceeded through R1 after the user approved work through R2 and directed
  that future approval is required only after a new keymap is defined.
- Recorded KEY-00 as a preservation decision: the Mac/Win direct control at
  physical position 77 remains `&mo 2`; no new binding was introduced.

## Candidate and reviews

- Candidate: `JIGS/QC-IN_PROGRESS/v1.3-mac-win.keymap`.
- Candidate and immutable HRM baseline are byte-identical; both SHA-256:
  `faa1612fc82c6c23bfa43e1f1551a576a6a3feeaee2bbb0af9d9c3cd219d056d`.
- Reviewer A and independently assigned Reviewer B both recorded PASS.
- The baseline-aware validator passed four 82-binding layers and all 20 direct
  controls.

## Pristine build and deployment

- Built from an isolated local clone at source commit
  `d6966635aae8e3f731e69d9437549281880c1480` after copying and hash-proving
  the candidate at the active build-input path.
- The local Zephyr SDK 0.15.2 archive supplied the nRF toolchain. The Windows
  host required a serialized Ninja run after its parallel static-library phase
  failed; the final generated UF2 is valid.
- Preserved artifact: `JIGS/QC-IN_PROGRESS/v1.3-mac-win.uf2` (435,712 bytes),
  SHA-256 `3f96b329bf3a2922e5e60a5ead038a5d8533b6e7c1c943b8fcc7376d363821b7`.
- Verified `E:` label `NRF52BOOT`, recorded the revision in `CHANGELOG.md`,
  copied the UF2 as `E:\zmk.uf2`, and observed the bootloader volume unmount.

## Current gate

Host-side transfer is complete. R1 remains blocked pending physical evidence:

1. Normal Base typing and KEY-00 hold/release in both Mac/Win switch positions.
2. Direct controls 78--81: BLE, 2.4 GHz, charge, and charge-disabled.

Do not define or build R2 until those assertions are recorded as passed.

## Workflow recommendation

The isolated candidate clone, candidate-to-build-input hash proof, UF2 hashing,
`NRF52BOOT` label verification, and changelog sequence should become a small
repository-local ZMK release-QC skill or script. It should also force serial
Ninja on this Windows host and preserve WSL as the preferred production build
environment.
