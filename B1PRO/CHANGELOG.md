# Keymap Version Changelog

This file records the obtainable B1 Pro keymap sequence and the material
changes between revisions. Failed candidate files may be deleted after their
identity and useful findings are captured here and in `B1PRO/LEARNINGS.md`.
Firmware deployment evidence remains authoritative in the root
`CHANGELOG.md`.

## Available release sequence

| Revision | Keymap SHA-256 observed before cleanup | QC result |
| --- | --- | --- |
| v0.8 HRM | `faa1612fc82c6c23bfa43e1f1551a576a6a3feeaee2bbb0af9d9c3cd219d056d` | PASS |
| v0.9 Esc/Caps | `abbbf227ae1ffcb1d164775673fd1bfe2338b07c6b7ebf01e1f686838091a187` | PASS |
| v0.19 ten-key foundation | `bb63f9822d740426b8b2b242b727f13c476014431935f93398e845886c3e8a7e` | FAIL |
| v0.20 layer completion | `a6a74fa7711c5f7db29f63e0a274e216c7ed535676af55c0d76b6c653e90f34e` | FAIL / rejected before hardware completion |
| v0.21 symbol tap dances | `ac7a52882772a5b1b0f1acc1f4bb3d41a04212f9302e59e0f15a333260710428` | FAIL / rejected before hardware completion |
| v0.22 V2 Mac layers | `0e37d4eacf247d4bbcdad71a94fc4ea87c2f842105cd89de53cda7f8482cf3d7` | FAIL / superseded before hardware completion |
| v0.23 full Mac + Windows layers | `984d7250d8eb08977c4a6de168b69c25edd48376c70d6056b59f936697da7813` | PASS |

The surviving v0.23 archive is
`B1PRO/QC-PASS/0.23-All_MacOS_Layers_defined/`. Intermediate v0.10--v0.18
changes existed only as the cumulative v0.19 candidate; no separate keymap
files for those revisions were available.

## v0.8 HRM

- Established the eight-key bilateral home-row-modifier map.
- Replaced timing-only generic mod-taps with left/right hold-taps filtered by
  opposite-hand positions.
- Preserved the factory layer structure and direct controls.

## v0.9 Esc/Caps

Compared with v0.8:

- Added the 600 ms Escape/Caps dual-role behavior at Base position 0.
- Short press sends Escape; one continuous hold sends a normal Caps Lock
  press/release.
- Retained the bilateral HRMs and protected Fn+minus bootloader behavior.

## v0.19 ten-key foundation

Compared with v0.9:

- Added Caps tap/Function hold, Fn hold/one-shot access, persistent layer
  selection, Bluetooth select/pair tap dances, G/H Symbols holds, and
  Backslash Navigation hold.
- Added inert compatibility and selector layers.
- Hardware QC failed because the Layer 0/1 function rows did not match the
  authoritative diagrams and the Fn-selector checklist lacked a concrete
  transparent-key assertion.
- The release record approved hash
  `9fa0ef021e9992a97042949c0ec7fcc0cbdbe6fceb86424a36c6a623df8a7e92`
  no longer matched the observed worktree file above, so that file was not a
  trustworthy reviewed artifact at cleanup.

## v0.20 layer completion

Compared with v0.19:

- Completed most Function/Numpad, Symbols, and Navigation layer bindings,
  including keypad numbers/operators, punctuation, mouse actions, navigation,
  shortcuts, modifiers, and F13--F24.
- Added launcher mouse constants and the Right Shift/emoji hold-tap.
- Started from a user-edited, failed v0.19 derivative instead of the locked
  v0.9 baseline.
- Never cleared its required validator update, two reviews, build, deployment,
  or hardware gates.

## v0.21 symbol tap dances

Compared with v0.20:

- Restored Base Delete, repaired an omitted Layer-1 binding, and changed Fn
  access behavior.
- Added single/double/triple tap dances for parentheses, braces, and brackets
  at Symbols positions 49--51.
- Compilation exposed malformed tap-dance binding cells. The repair changed
  the candidate identity after its pre-build review; no post-fix independent
  review or completed hardware QC followed.
- The release-record build-input hash
  `4b279b96cfce91cb9f7de62d774dbad113f64de1b3e7b4070fbc658b7efa8f05`
  did not match the observed worktree keymap hash above.

## v0.22 V2 Mac layers

Compared with v0.21:

- Reworked the keymap around named V2 Mac layers and added a Windows Base
  layer selected by protected physical position 77.
- Added Base Hyper Tab, Navigation holds on Backslash/Space, corrected Mac
  modifier order, explicit inert UAT and selector layers, V2 Symbols and
  Navigation maps, and an 82-position Layer 5.
- Earlier identities contained a Symbols Caps illustration/code mismatch and
  only 80 Layer-5 bindings. The repaired candidate built, but Layers 7--11
  remained undefined and hardware QC never completed.
- The release-record approved hash
  `ade84319260769d765c0fa84192d7c54cdceadb110d1fe6a603759ecb3d5249f`
  did not match the observed worktree keymap hash above.

## v0.23 full Mac + Windows layers

Compared with v0.22:

- Expanded the keymap to twelve complete 82-position layers: Mac 0--5 and
  Windows 6--11.
- Added full Windows Function, Symbols, Navigation, UAT, and selector maps.
- Corrected F6 to Ctrl+Alt+M, Windows Navigation Ctrl+V, and Navigation
  position 22 Space on both operating-system families.
- Added named `-/_` and `=/+` tap dances and removed remaining placeholders.
- Corrected Escape/Caps to ordinary `&kp` press/release bindings so one hold
  completes each Caps Lock toggle.
- Added fixed-keymap integration that retains required Keychron vendor support
  while disabling Launcher USB and dynamic-map initialization.
- QC PASS reported 2026-07-30 for the exact keymap above and UF2 SHA-256
  `b77bd6be9ffc28f1383c962a79fec0150970538e6e0fad5bcaa519db85b80444`.
