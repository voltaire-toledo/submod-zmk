# Firmware Build Changelog

This log records only firmware UF2 files that were copied to a physical test
unit. A successful build alone does not create an entry.

## Entry format

```markdown
## <revision> — YYYY-MM-DD

- **UF2:** `<relative path>`
- **SHA-256:** `<hash>`
- **Source commit:** `<commit or unavailable>`
- **Test unit:** `<device identifier or description>`
- **Reason:** `<what this build was intended to verify>`
- **Result:** `<observed hardware result>`
```

## v0.8_HRM — 2026-07-16

- **UF2:** `build-hrm/zephyr/zmk.uf2`
- **SHA-256:** `4fce1323da5502539f690e705c6b55f1a21ca4de9220028f9ef8544a14439b0c`
- **Source commit:** `d6966635` (historical annotated tag `v1.0_HRM`;
  release numbering corrected to `v0.8_HRM`)
- **Test unit:** Keychron B1 Pro test unit.
- **Reason:** Verify the bilateral home-row-modifier fix.
- **Result:** Flashed successfully and recorded as the hardware-tested HRM
  baseline.

## Factory-2024-07-22 — 2026-07-19

- **UF2:** `JIGS/zmk_b1pro_us_v1.0.3_2407221034_e013003c-271c-4949-b9a2-e58582ca12e3.uf2`
- **SHA-256:** `7907dfdc6439f75f91492188797b73542bd9c9bfa44fe6ff56639de35d6f037f`
- **Source commit:** Unavailable; vendor factory image.
- **Test unit:** Available Keychron B1 Pro test unit.
- **Reason:** Restore the Keychron factory firmware baseline.
- **Result:** Copied to the `NRF52BOOT` UF2 volume; the bootloader unmounted.
  Normal keyboard startup and behavior were not recorded in this deployment.

## v1.1_Layers0-3 — 2026-07-19

- **UF2:** `build-spec-layers-0-3/zephyr/zmk.uf2`
- **SHA-256:** `9a7efd0de6c86e7a0cdb1a0a1d29e67611cdde0a0c5ddeee5905661b67d87a55`
- **Source commit:** `d6966635` plus uncommitted Layer 0–3 keymap and
  validator changes.
- **Test unit:** Keychron B1 Pro test unit.
- **Reason:** Deploy the specified Base, Fn-NUM, Symbols, and Navigation
  layers for hardware acceptance testing.
- **Result:** Copied to verified `E:` / `NRF52BOOT`; the volume unmounted
  afterward. Hardware acceptance failed: the physical Mac/Win-switch matrix
  position was incorrectly bound to `LAYER_FN_NUM`, leaving the keyboard in
  the Fn layer whenever that switch position was active. Unit requires
  hardware-bootloader recovery before further firmware changes.

## v1.1_Layers0-3-Recovery — 2026-07-19

- **UF2:** `JIGS/zmk_b1pro_us_v1.0.3_2407221034_e013003c-271c-4949-b9a2-e58582ca12e3.uf2`
- **SHA-256:** `7907dfdc6439f75f91492188797b73542bd9c9bfa44fe6ff56639de35d6f037f`
- **Source commit:** Unavailable; vendor factory image.
- **Test unit:** Keychron B1 Pro test unit.
- **Reason:** Recover from the failed `v1.1_Layers0-3` custom-firmware
  deployment before evaluating a corrected build.
- **Result:** Copied to verified `E:` / `NRF52BOOT`; the volume unmounted
  afterward. Normal factory-keyboard behavior remains to be confirmed.

## v1.3_MacWin-Preservation_R1 â€” 2026-07-20

- **UF2:** `JIGS/QC-IN_PROGRESS/v1.3-mac-win.uf2`
- **SHA-256:** `3f96b329bf3a2922e5e60a5ead038a5d8533b6e7c1c943b8fcc7376d363821b7`
- **Source commit:** `d6966635aae8e3f731e69d9437549281880c1480`, with the
  reviewed R1 candidate copied to the isolated build input and hash-proven.
- **Test unit:** Keychron B1 Pro test unit on verified `E:` / `NRF52BOOT`.
- **Reason:** Verify that the repaired KEY-00 Mac/Win direct control preserves
  momentary `&mo 2` access without disrupting Base-layer typing.
- **Result:** Copied to verified `E:` / `NRF52BOOT`; the bootloader volume
  unmounted afterward. This proves host-side transfer only; Mac/Win typing and
  direct-control hardware QC remain pending.

## v0.9_EscCaps — 2026-07-20

- **UF2:** `JIGS/QC-PASS/v0.9-Esc-Hold-to-Toggle-CapsLock/v0.9-esc-caps.uf2`
- **SHA-256:** `aa32efdee2712ac08044b7fbd5356a60e44101b89022d67cd3c5a6416241350a`
- **Source commit:** `d6966635aae8e3f731e69d9437549281880c1480`, with the
  reviewed R2 candidate copied to the isolated build input and hash-proven.
- **Test unit:** Keychron B1 Pro test unit on verified `E:` / `NRF52BOOT`.
- **Reason:** Verify that the physical Esc key taps Escape and, after a
  600 ms hold, toggles Caps Lock.
- **Result:** QC PASS. The physical Esc key performed its specified tap and
  hold behavior, including Caps Lock toggle after a 600 ms hold. The critical
  Fn+`-` behavior also remained correct.

## v0.19-ten-key-foundation — 2026-07-20

- **UF2:** `JIGS/QC-IN_PROGRESS/v0.19-ten-key-foundation.uf2`
- **SHA-256:** `8c35e645e3e1dd4bc67ae17688613132979d6fc3c0461f20deb20996fda55845`
- **Source commit:** `da7247c5b1268d769ba1a4135c4c09ea101e4652`, with the
  reviewed v0.19 candidate copied to the isolated build input and hash-proven
  as `9fa0ef021e9992a97042949c0ec7fcc0cbdbe6fceb86424a36c6a623df8a7e92`.
- **Test unit:** Keychron B1 Pro test unit; authorized `E:` / `NRF52BOOT`
  bootloader volume.
- **Reason:** Hardware acceptance of the v0.10--v0.19 ten-key foundation,
  including retained direct controls and recovery paths.
- **Result:** Copied to verified `E:` / `NRF52BOOT` as `zmk.uf2`; the volume
  unmounted afterward. Hardware acceptance failed: the Caps-held Layer 1 test
  exposed the candidate's mismatch with the specified Layer 0/Layer 1
  function rows, and the Fn-selector procedure lacked a concrete test case.
  The image is not a QC-passed release and must not be reused.
