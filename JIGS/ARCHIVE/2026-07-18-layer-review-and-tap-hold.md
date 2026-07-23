# B1 Pro layer review and tap-hold capability

## User request

Review `JIGS/B1Pro-ZMK-KEYMAP.md`, confirm whether its first four layer
definitions are understandable, and determine whether ZMK can distinguish
Tap, Tap+Hold, and Hold for one key.

## Findings

- The document communicates the intended conceptual sequence: Base, Numpad,
  Symbols, and Navigation. It does not assign those sections explicit numeric
  layer IDs, so describing them as layers 0--3 is ambiguous.
- The active firmware uses `0 = Base`, `1 = Fn`, `2 = Num`, `3 = Sym`, and
  reserves `4 = Nav`. Therefore the document's conceptual order must not be
  treated as the current firmware numbering.
- ZMK's ordinary hold-tap behavior (`&lt` and `&mt`) has exactly two outcomes:
  Tap or Hold. The `T+H:R_CTRL` labels in the diagram need a definition; they
  cannot be a third independent outcome of a stock hold-tap binding.
- If `T+H` means “hold one layer key, then tap this key,” ZMK supports it via
  normal layered key resolution. If it means a third gesture on the *same*
  key, it requires a custom behavior (or a redesigned gesture), not `&lt`/
  `&mt` alone.

## Tap dance follow-up

- This ZMK fork supports `zmk,behavior-tap-dance` for actions selected by the
  number of taps within a tapping term.
- The active keymap already declares `td0` (`TAPD_LAYER`) with a 350 ms term
  and five configured outcomes. It is distinct from hold-tap: tap dance is
  appropriate for one/two/three-tap gestures, not for adding a third
  tap-versus-hold outcome to a normal `&lt` or `&mt` binding.

## Community-pattern research follow-up

- Public ZMK keymaps use tap dance for single/double layer actions, Bluetooth
  profile select versus pairing/discovery, paired punctuation, Caps Word,
  navigation history, zoom, and grouped copy/paste shortcuts.
- The B1 Pro's key directly left of the arrow cluster is presently `&mo
  LAYER_FN`. Do not move its factory Fn role into tap dance without a hardware
  test: its hold path must continue to support the bootloader and reset chords.
- Safer early candidates are a non-critical punctuation key or an existing
  output/profile key. Keep one action per tap count and avoid assigning a
  destructive action (bootloader/reset) to a multi-tap gesture.

## Evidence checked

- `JIGS/B1Pro-ZMK-KEYMAP.md`
- `app/boards/shields/keychron/b1/us/keychron_b1_us.keymap`
- `app/dts/bindings/behaviors/zmk,behavior-hold-tap.yaml`
- `app/src/behaviors/behavior_hold_tap.c`

## Tooling verification

- Compound Engineering and its `ce-ideate` skill are installed as a
  profile-level Codex plugin and are available in this repository.
- This checkout has no local Compound Engineering configuration. No local copy
  was installed because duplicating the profile-managed plugin would drift from
  its maintained version.
