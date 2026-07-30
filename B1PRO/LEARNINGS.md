# Verified Project Learnings

## Troubleshooting notes

### Bilateral home-row modifiers

- Generic `&mt` with timing changes alone did not prevent same-hand roll
  misfires.
- Separate `lhm` and `rhm` hold-taps with opposite-hand trigger positions,
  `hold-trigger-on-release`, and prior-idle filtering passed hardware testing.
- This Keychron fork accepts `require-prior-idle-ms`,
  `hold-trigger-key-positions`, and `hold-trigger-on-release` when declared in
  valid custom hold-tap nodes.

### Hidden matrix direct controls

- The B1 Pro has five non-typing matrix positions, 77 through 81, in each
  82-binding layer.
- Rebinding Base position 77 caused the failed v1.1 layer trap. Every candidate
  must compare all 20 direct-control cells against its QA-passed baseline.
- User-confirmed hardware mapping: Layer 0's final-row `&mo <layer>` binding
  is selected by the physical Win switch. Future candidates must use
  `&mo LYR_W_BASE`, and therefore define at least `LYR_W_BASE` at layer index
  6 before changing that binding.

### Bootloader recovery

- Fn+minus depends on the Function-layer Boot binding and can be lost during a
  broad keymap rewrite.
- Hardware recovery is available through the recessed reset control with the
  keyboard in Win/Cable mode. A UF2 transfer is valid only after the mounted
  volume label is confirmed as `NRF52BOOT`.

### Esc hold-to-Caps Lock

- `&kt CLCK` is a key-state toggle, not a normal press/release. In a hold-tap
  it can leave Caps Lock asserted after the physical Esc release, so a second
  hold is needed to complete the next toggle.
- The verified single-hold form keeps the 600 ms `tap-preferred` policy and
  uses `bindings = <&kp>, <&kp>;`: the hold sends a normal Caps Lock press and
  release once, while a short press still sends Esc.

### Windows build environment

- Build from the physical `D:\CODE` path; the `C:\Users\Jigs\CODE` junction
  can produce conflicting absolute paths in CMake.
- Zephyr SDK 0.15.2 is the validated toolchain for this fork.
- On this Windows host, serialized Ninja completed builds that failed during
  the parallel static-library phase. WSL remains the preferred clean build
  environment.

### Release evidence

- A successful build or bootloader unmount proves neither firmware behavior
  nor QC acceptance.
- The exact candidate hash must follow the keymap through review, isolated
  build input, UF2 creation, deployment, and archive promotion.
- The baseline-aware validator is the fast regression gate for layer shape,
  approved physical positions, definition drift, and protected direct
  controls.

### Rejected v0.19--v0.22 candidate sequence

- v0.19 reached hardware testing and failed. Its Layer 0/Layer 1 function rows
  did not match the authoritative diagrams, and its Fn-selector checklist did
  not define a concrete transparent-key action and expected result.
- v0.20 was based on a user-edited derivative of failed v0.19 rather than the
  locked v0.9 baseline. Its broader position set was not covered by the pinned
  validator, two required reviews were pending, and it never reached a
  trustworthy build or hardware result.
- v0.21 compiled only after repairing malformed tap-dance binding cells. That
  repair changed the keymap identity after the pre-build review, so a new
  independent review was required and hardware QC never completed.
- v0.22 initially disagreed with its illustration at Symbols Caps and defined
  only 80 bindings on Layer 5. The repaired seven-layer image built, but it
  still omitted Windows Layers 7--11 and never completed hardware QC.
- At cleanup, the observed v0.19, v0.21, and v0.22 worktree keymap hashes did
  not match the reviewed or build-input identities in their release records.
  A candidate identity mismatch is itself a stop condition: never infer that
  an edited worktree copy is the reviewed firmware source.
- v0.23 resolved the cumulative specification, layer-shape, Windows-map,
  placeholder, Escape/Caps, and fixed-keymap integration gaps and is the first
  revision after v0.9 reported as a complete hardware QC pass.

## Justified automation candidate

A repository-local release-QC utility would be worthwhile after another full
revision proves the workflow. It should validate the candidate, compare the
direct-control map, hash-prove isolated build input, force serial Ninja on this
Windows host, hash the UF2, verify `NRF52BOOT`, and update the single release
record without creating duplicate status documents.
