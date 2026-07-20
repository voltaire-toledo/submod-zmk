# Keychron B1 Pro Conservative Firmware Backlog

## Purpose and current state

This backlog replaces broad keymap rewrites with small, reviewable firmware
revisions. The starting point for every future custom revision is the
hardware-passed HRM baseline:

- Git tag: v1.0_HRM / commit d6966635.
- Immutable copy: JIGS/v1.0-HRM-QC_PASSED.keymap.
- Current test unit: restored to the verified factory firmware after the
  failed v1.1_Layers0-3 deployment.

The factory-to-HRM delta is narrow: it adds the bilateral HRM definitions and
rebinds the intended home-row modifier keys. By contrast, the failed
HRM-to-v1.1 delta changed 110 lines and removed 210 lines. It also reassigned
the B1 Pro's hidden physical Mac/Win-switch matrix position to Layer 1. That
is the regression this process is designed to prevent.

## Non-negotiable workflow

1. The active source keymap must never be the starting point for a new
   revision. Copy the exact HRM QC-passed baseline to JIGS/QC-IN_PROGRESS/ and
   work from that versioned copy.
2. A revision may change **at most four named physical-key bindings**. A
   supporting behavior definition is allowed only when it is used exclusively
   by the named keys in that revision.
3. Every changed binding and every supporting non-binding change must have one
   task below. An unlisted change is out of scope and must not be changed.
4. Two independent senior Keychron/ZMK reviewers must both issue PASS against
   the exact same candidate-keymap SHA-256. Any source edit invalidates both
   reviews. A BLOCK, unresolved finding, or disagreement prohibits compile.
5. Before a UF2 is built, review the diff against the prior QC-passed keymap
   by physical key and confirm the complete 20-binding direct-control map
   remains intentional.
6. Build exactly one pristine UF2 for that revision, run the focused
   validator, and record its SHA-256. Do not begin the next revision until the
   current revision has passed the written hardware QC checklist.
7. Copy a UF2 to a test unit only after explicit user authorization and only
   after confirming the mounted drive label is NRF52BOOT.
8. Record every deployed UF2 in CHANGELOG.md. A failed hardware check is a
   failed revision, not a baseline.
9. After QC passes, preserve the exact keymap, UF2 hash, build command, and
   test result in JIGS/QC-PASS/. Do not overwrite an existing QC-passed
   artifact.

## Required artifact layout

Each revision must create these files before any hardware flash:

~~~text
JIGS/QC-IN_PROGRESS/
  v<major>.<minor>-<two-word-task>.keymap
  v<major>.<minor>-<two-word-task>.manifest.md
  v<major>.<minor>-<two-word-task>.review-a.md
  v<major>.<minor>-<two-word-task>.review-b.md
  v<major>.<minor>-<two-word-task>.QC.md
  v<major>.<minor>-<two-word-task>.uf2
  v<major>.<minor>-<two-word-task>.uf2.sha256
~~~

The shared artifact stem must match the pattern
v<major>.<minor>-<two-word-task>, such as v1.2-esc-caps. The candidate
keymap, manifest, both reviews, QC record, UF2, and UF2 hash must use that
identical stem and stay in this directory together.

The QC document must state the source baseline blob ID, candidate keymap
SHA-256, every changed physical key, every supporting non-binding change, the
expected result, validator result, pristine-build result, UF2 hash, and the
hardware test result. A build is not QC-passed until the hardware results are
recorded.

## Mandatory two-engineer adversarial review

Before compilation, create the two review records defined in
JIGS/QC-IN_PROGRESS/REVIEW-PROTOCOL.md. Each independent reviewer must presume
the candidate is broken and inspect:

- the exact diff against the prior QC-passed baseline;
- the candidate SHA-256 and baseline blob ID;
- the manifest's one-to-four approved physical-key IDs;
- all behavior definitions, combos, includes, and preprocessor constants;
- the layer count and binding count for every layer;
- all 20 direct-control bindings at physical positions 77 through 81 across
  the four layers; and
- the proposed build-input provenance.

Compilation is permitted only when both records say PASS for the same candidate
SHA-256 and contain no unresolved finding. The active shield keymap copied into
the build input must then hash identically to the reviewed candidate immediately
before configuration. Any unrelated source modification in the build workspace
is an automatic BLOCK.

## Global safety tasks

- [x] **SAFE-00 — Freeze the source baseline.** Verify the working copy equals
  JIGS/v1.0-HRM-QC_PASSED.keymap before starting a revision. Record the
  expected blob ID e88289af51f7d2ec79af4c3fd864e4c434a8037f.
- [x] **SAFE-01 — Preserve the 20-cell direct-control map.** Review the final
  five bindings in each 82-binding layer. The immutable HRM baseline map is:
  Layer 0 = &mo 2, &out OUT_BLE, &out OUT_24G, &out OUT_CHG, &out OUT_CHGD;
  Layers 1, 2, and 3 = five &none bindings each.
- [x] **SAFE-02 — Replace end-state regex validation.** Build a
  baseline-aware validator that passes the immutable HRM baseline, rejects the
  known-bad v1.1 keymap because its position-77 Mac/Win binding changed from
  &mo 2 to &mo LAYER_FN_NUM, verifies ordered binding counts, and accepts
  revision-specific assertions for only the one-to-four approved keys.
- [x] **SAFE-03 — Capture a pre-flash rollback artifact.** Record the factory
  UF2 path and SHA-256 in the revision QC document before any custom flash.

## Key-change ledger

Only the tasks below are authorized implementation targets. Each ID represents
one physical key or direct control. A task remains blocked until its target
behavior and test are written in the revision QC document.

| ID | Physical key/control | Baseline binding | Approved target | Dependency | Required hardware evidence |
| --- | --- | --- | --- | --- | --- |
| KEY-00 | **Mac/Win direct control** | &mo 2 | **Decision required.** No target is assumed. Its behavior must be explicitly selected before an edit is reviewed. | User decision; SAFE-01 | Both switch positions, normal Base typing, and all direct controls must pass. |
| KEY-01 | **Esc** (top-left) | &kp ESC | Tap Esc; hold longer than 600 ms toggles Caps Lock. | New dedicated hold-tap behavior | Tap, 600+ ms hold, and rapid repeat must work. |
| KEY-02 | **Caps** | &kp CLCK | Tap Esc; hold temporarily accesses Function/Numpad. | Function/Numpad content must be safe to expose | Tap must not latch a layer; hold/release must return to Base. |
| KEY-03 | **Fn** (bottom-row physical Fn) | &mo 1 | Hold temporarily accesses Function/Numpad; tap arms the one-shot selector. | KEY-04 through KEY-06 must be ready before one-shot selection is enabled | Hold/release, one-shot timeout, and cancellation must be tested. |
| KEY-04 | **Number-row 1** on Function/Numpad | Factory Bluetooth-profile action | Select persistent Function/Numpad layer. | KEY-03 and Function/Numpad QC | Tap after one-shot Fn must select Layer 1 only. |
| KEY-05 | **Number-row 2** on Function/Numpad | Factory Bluetooth-profile action | Select persistent Symbols layer. | Symbols layer must have a separately approved key ledger | Tap after one-shot Fn must select Layer 2 only. |
| KEY-06 | **Number-row 3** on Function/Numpad | Factory Bluetooth-profile action | Select persistent Navigation layer. | Navigation layer must have a separately approved key ledger | Tap after one-shot Fn must select Layer 3 only. |
| KEY-07 | **Q** on Function/Numpad | Factory profile behavior | Tap selects Bluetooth profile 1; double-tap starts pairing profile 1. | Dedicated tap-dance definition | Verify select, pairing, and no unintended pairing on normal typing. |
| KEY-08 | **W** on Function/Numpad | Factory profile behavior | Tap selects Bluetooth profile 2; double-tap starts pairing profile 2. | Dedicated tap-dance definition | Verify select, pairing, and no unintended pairing on normal typing. |
| KEY-09 | **E** on Function/Numpad | Factory profile behavior | Tap selects Bluetooth profile 3; double-tap starts pairing profile 3. | Dedicated tap-dance definition | Verify select, pairing, and no unintended pairing on normal typing. |
| KEY-10 | **G** | &lt 3 G | Tap G; hold temporarily accesses the shared Symbols layer. | Symbols layer key ledger and QC | Tap must remain G; hold/release must not latch. |
| KEY-11 | **H** | &lt 2 H | Tap H; hold temporarily accesses the same Symbols layer as G. | Symbols layer key ledger and QC | Tap must remain H; both holds must reach the same layer. |
| KEY-12 | **Backslash** | &kp BSLH | Tap backslash; hold temporarily accesses Navigation. | Navigation layer key ledger and QC | Tap must remain backslash; hold/release must not latch. |
| KEY-13 | **Space** | &kp SPACE | Tap space; hold temporarily accesses Navigation. | Navigation layer key ledger and QC | Tap must remain space; hold/release must not latch. |
| KEY-14 | **Tab** | &kp TAB | Tap Tab; hold Hyper. | Dedicated hold-tap definition | Test Tab tap and all four Hyper modifiers. |
| KEY-15 | **Minus** on Function/Numpad | Factory three-second Boot hold-tap | **No binding change authorized.** Preserve it and add a regression test only. | SAFE-02 | Normal Base minus must type minus; Function/Numpad minus must enter bootloader only after its full hold time. |
| KEY-16 | **Backslash** on Function/Numpad | Factory screenshot action | Print Screen shortcut specified by the keymap spec. | Exact host chord review | Confirm the intended operating-system screenshot result. |
| KEY-17 | **Right Shift** on Function/Numpad | Factory emoji shortcut | Tap emoji shortcut; hold Right Shift. | Dedicated hold-tap definition | Test both paths independently and verify no stuck Shift. |

## Explicitly unscheduled keys

The Symbols and Navigation layer **content bindings** are not yet scheduled
because the prior failed release created them as a broad row-by-row rewrite.
Before any one of those bindings is modified, append a new KEY-xx entry to
this ledger containing:

- one physical key;
- its baseline binding;
- one exact target binding;
- its layer-activation dependency;
- a hardware assertion; and
- a revision assignment with no more than four changed physical keys.

No full-row copy, layer rename, global reformat, or unrelated cleanup is
permitted while implementing this backlog.

## Revision gates

| Gate | Permitted work | Stop condition |
| --- | --- | --- |
| R0 — validation hardening | SAFE-00 through SAFE-03 only; no key binding edits and no custom UF2 | Both reviewers PASS the baseline-aware validator design; it passes the HRM baseline and rejects known-bad v1.1. |
| R1 — direct-control safety | KEY-00 only, after the user decides its intended Mac/Win behavior | Both reviewers PASS the exact candidate hash; build one UF2; both switch positions pass Base-layer typing QC. |
| R2 onward | At most four ledger keys in dependency-safe order | Both reviews PASS, pristine build, validator, build-input hash proof, diff review, and all hardware assertions pass before the next revision. |

## Current stop condition

**R1 physical QC remains pending. R2 KEY-01 is QC-passed and archived at
`JIGS/QC-PASS/v1.4-Esc-Hold-to-Toggle-CapsLock/`.** Hardware confirmed the
Esc tap / 600 ms Caps Lock hold behavior and preserved the critical Fn+`-`
behavior. Do not define a further candidate until its keymap and companion
delivery report are ready for review.
