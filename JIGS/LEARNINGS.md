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

### Bootloader recovery

- Fn+minus depends on the Function-layer Boot binding and can be lost during a
  broad keymap rewrite.
- Hardware recovery is available through the recessed reset control with the
  keyboard in Win/Cable mode. A UF2 transfer is valid only after the mounted
  volume label is confirmed as `NRF52BOOT`.

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

## Justified automation candidate

A repository-local release-QC utility would be worthwhile after another full
revision proves the workflow. It should validate the candidate, compare the
direct-control map, hash-prove isolated build input, force serial Ninja on this
Windows host, hash the UF2, verify `NRF52BOOT`, and update the single release
record without creating duplicate status documents.
