# Keychron B1 Pro Execution Backlog

## Role

This file records accepted work that surfaced outside the keymap specification
during execution. It is not a task manifest or a session history. Live status
belongs in `JIGS/HANDOFF.md`; verified firmware history belongs in
`CHANGELOG.md` and the applicable `JIGS/QC-PASS/` release record.

## Locked baseline

- Latest hardware-passed release: `v0.9_EscCaps`.
- Archive:
  `JIGS/QC-PASS/v0.9-Esc-Hold-to-Toggle-CapsLock/`.
- Archived keymap SHA-256:
  `abbbf227ae1ffcb1d164775673fd1bfe2338b07c6b7ebf01e1f686838091a187`.
- Archived UF2 SHA-256:
  `aa32efdee2712ac08044b7fbd5356a60e44101b89022d67cd3c5a6416241350a`.
- Locking commit: `da7247c5b1268d769ba1a4135c4c09ea101e4652`.
- The abandoned `v1.3-mac-win` revision is not a baseline and must not be
  resumed. Any future direct-control work receives a new revision.

## Accepted key changes

Each accepted item covers one physical key unless stated otherwise. Version
numbers count enabled keys cumulatively: the eight-key HRM baseline is v0.8,
Escape is v0.9, and each subsequent enabled key increments the numeric suffix
by one. Thus v0.11 is two revisions after v0.9.

| Version | ID | Physical key/layer | Locked-baseline binding | Accepted target | Dependency and required evidence |
| --- | --- | --- | --- | --- | --- |
| v0.10 | KEY-02 | Caps, Base position 42 | `&kp CLCK` | Tap Escape; hold momentarily accesses Function/Numpad | Function layer remains unchanged; tap must not latch; hold/release must return to Base. |
| v0.11 | KEY-03 | Physical Fn, Base position 72 | `&mo 1` | Hold Function/Numpad; tap arms one-shot selector | Test hold/release, one-shot timeout, cancellation, and KEY-04 through KEY-06 selection. |
| v0.12 | KEY-04 | Number-row 1 on Function/Numpad, position 15 | Factory Bluetooth action | Select persistent Function/Numpad | Depends on KEY-03; Esc remains the exit path. |
| v0.13 | KEY-05 | Number-row 2 on Function/Numpad, position 16 | Factory Bluetooth action | Select persistent Symbols | Depends on KEY-03; Esc remains the exit path. |
| v0.14 | KEY-06 | Number-row 3 on Function/Numpad, position 17 | Factory Bluetooth action | Select persistent Navigation | Depends on KEY-03; Esc remains the exit path. |
| v0.15 | KEY-07 | Q on Function/Numpad, position 29 | Transparent | Tap selects Bluetooth profile 1; double-tap pairs profile 1 | Requires a dedicated tap-dance and profile-selection/pairing tests. |
| v0.16 | KEY-08 | W on Function/Numpad, position 30 | Transparent | Tap selects Bluetooth profile 2; double-tap pairs profile 2 | Requires a dedicated tap-dance and profile-selection/pairing tests. |
| v0.17 | KEY-09 | E on Function/Numpad, position 31 | Transparent | Tap selects Bluetooth profile 3; double-tap pairs profile 3 | Requires a dedicated tap-dance and profile-selection/pairing tests. |
| v0.18 | KEY-10 | G, Base position 47 | `&lt 3 G` | Tap G; hold the shared Symbols layer | H already holds the same Symbols layer; test tap and momentary release. |
| — | KEY-11 | H, Base | `&lt 2 H` | Already taps H and holds Symbols Layer 2 | No binding change required; retain as a v0.19 regression assertion. |
| v0.19 | KEY-12 | Backslash, Base position 41 | `&kp BSLH` | Tap backslash; hold Navigation | Test tap and momentary release; Navigation content remains unchanged. |
| — | KEY-13 | Space, Base | `&kp SPACE` | Tap Space; hold Navigation | Navigation content must be separately approved; test tap and momentary release. |
| — | KEY-14 | Tab, Base | `&kp TAB` | Tap Tab; hold Hyper | Requires a dedicated hold-tap; test Tab and all four modifiers. |
| — | KEY-15 | Minus on Function/Numpad | Factory three-second Boot hold-tap | Preserve binding; regression test only | Verify Base minus and delayed Fn+minus bootloader entry. |
| — | KEY-16 | Backslash on Function/Numpad | Factory screenshot action | Use the specified host screenshot chord | Confirm the intended operating-system screenshot result. |
| — | KEY-17 | Right Shift on Function/Numpad | Factory emoji shortcut | Tap Emoji; hold Right Shift | Requires a dedicated hold-tap; verify both paths and no stuck Shift. |

## Unscheduled work

- **Low priority — soft connectivity selection:** expose soft controls for
  2.4G, BT1, BT2, and BT3. Requires a profile-aware BLE transport switch that
  persists the requested BT profile across the BLE reboot; retain the physical
  switch as recovery fallback until all four paths hardware-pass.
- Direct-control work corresponding to the abandoned v1.3 experiment must be
  assigned a new ID/revision before implementation.
- Symbols and Navigation content bindings require one ledger row per physical
  position before modification. Broad row rewrites remain prohibited.
- No full-layer rename, global reformat, or unrelated cleanup is authorized by
  this backlog.

## Candidate workflow

1. Start from the latest archived QA-passed keymap, never the active shield
   keymap or an abandoned candidate.
2. Create one companion delivery record containing the complete candidate
   identity, side-by-side baseline comparison, all changed zero-based physical
   positions, behavior changes, full direct-control result, and every related
   code-file update outside the keymap.
3. Run deterministic validation, then one senior review by default. Add a
   second independent review for protected direct controls, Fn/boot/reset,
   layer structure, combos, shared/runtime behavior, or three or more changed
   physical positions. The ten-position v0.19 candidate requires two reviews.
4. Request user approval of the exact reviewed candidate hash before build.
5. After approval, prove the isolated build input matches the reviewed hash,
   build one pristine UF2, record its hash, and obtain explicit authorization
   before copying it to a verified `NRF52BOOT` volume.
6. Promote only after every required hardware assertion is explicitly passed.
