# Keychron B1 Pro Execution Backlog

## Role

This file records accepted work that surfaced outside the keymap specification
during execution. It is not a task manifest or a session history. Live status
belongs in `B1PRO/HANDOFF.md`; verified firmware history belongs in
`CHANGELOG.md` and the applicable `B1PRO/QC-PASS/` release record.

## Locked baseline

- Latest hardware-passed release: `v0.23-mac-win-full-layers`.
- Archive:
  `B1PRO/QC-PASS/0.23-All_MacOS_Layers_defined/`.
- Archived keymap SHA-256:
  `984d7250d8eb08977c4a6de168b69c25edd48376c70d6056b59f936697da7813`.
- Archived UF2 SHA-256:
  `b77bd6be9ffc28f1383c962a79fec0150970538e6e0fad5bcaa519db85b80444`.
- Source identity: working-tree candidate based on
  `8f1c2329928f1d63ae091af98d1a8807159cee70`; no exact candidate commit is
  claimed.
- The abandoned `v1.3-mac-win` revision is not a baseline and must not be
  resumed. Any future direct-control work receives a new revision.

## Accepted key changes

None. The completed v0.10--v0.23 progression is recorded in
`B1PRO/CHANGELOG.md`; v0.23 is the locked hardware-passed baseline.

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
