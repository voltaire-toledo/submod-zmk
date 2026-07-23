# Session Handoff: Bilateral Homerow Modifiers

## Reported behavior

Fast same-hand rolls such as `a-t`, `s-t`, `s-e`, `a-r`, and `a-x` produced unintended modifier shortcuts, especially from the `A` and `S` homerow mod-taps.

## Root cause

The earlier custom `&hrm` behavior had been removed by commit `b4c7d9ad` and the active keymap used the generic global `&mt` behavior. The global behavior was tap-preferred but had no bilateral positional filtering, so a homerow key held through the tapping term could become a modifier regardless of which hand pressed the next key.

## Changes prepared

- Added `&lhm` and `&rhm` custom hold-tap behaviors.
- Restricted each behavior's hold triggers to the opposite-hand key positions.
- Enabled `hold-trigger-on-release`.
- Retained the 200 ms tapping term, 175 ms quick-tap window, and 150 ms prior-idle window.
- Rebound the eight homerow modifiers to the appropriate bilateral behavior.
- Changed the Layer 0 left bottom-row modifier order to Ctrl, GUI/Windows, Alt/Option.
- Added `scripts/validate-keymap.ps1` for focused configuration checks.

## Verification

- The focused validator failed before implementation because bilateral behaviors were absent.
- The validator passes after implementation.
- A pristine build completed successfully in `build-hrm/`.
- Firmware: `build-hrm/zephyr/zmk.uf2` (435,712 bytes).
- Firmware was flashed successfully through the verified UF2 bootloader volume.
- Hardware testing confirmed the bilateral HRM behavior and Layer 0 modifier order work as expected.

## Hardware checks required

- Same-hand rolls `at`, `st`, `se`, `ar`, and `ax` must emit letters without modifiers.
- Mirrored right-hand rolls should also emit letters without modifiers.
- Left HRMs must still produce modifiers when chorded with right-hand keys.
- Right HRMs must still produce modifiers when chorded with left-hand keys.
- Layer 0 bottom-left modifiers must report Ctrl, GUI/Windows, Alt/Option in that order.

## Skill recommendation

Package the repeatable Windows environment setup, physical-path handling, pristine build, validation, and flashing workflow as a `zmk-local-builder` skill.
