# Keymap Specification — Dual-Role and Bluetooth Clarifications

## User decisions recorded

### Layer 0: `[CAPS]`

- Tap: `Esc`.
- Hold: temporarily activate `LAYER_FN-NUM`; releasing it returns to
  `LAYER_BASE`.
- VIA interpretation: `LT(1, KC_ESC)`.

### Layer 0: `[Esc]`

- Tap: `Esc`.
- Hold for more than 600 ms: toggle `Caps Lock`.
- This needs a custom ZMK hold-tap behavior; it is not represented by the VIA
  `LT` shorthand.

### `LAYER_FN-NUM` selection and Bluetooth controls

- `[1]`, `[2]`, and `[3]` select layers with `TO(1)`, `TO(2)`, and `TO(3)`.
- `[Q]`, `[W]`, and `[E]` select Bluetooth profiles 1, 2, and 3 on tap.
- Double-tapping each of those keys starts discovery/pairing for the matching
  profile. This is a desired tap-dance behavior and still needs a ZMK
  implementation and timing validation.

## Documentation update

`JIGS/B1Pro-ZMK-KEYMAP.md` now records the decisions in its Layer 0 and
`LAYER_FN-NUM` sections and labels them as desired behavior requiring firmware
work, rather than claiming the active keymap already provides them.

## Verification

`scripts/validate-keymap.ps1` passed after the documentation-only changes.
