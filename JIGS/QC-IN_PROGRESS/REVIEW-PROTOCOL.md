# Two-Engineer Keymap Review Protocol

## Purpose

Every B1 Pro keymap revision is presumed broken until two independent senior
Keychron/ZMK reviewers both approve the exact same candidate keymap.

## Candidate identity

The candidate path must be:

    JIGS/QC-IN_PROGRESS/v<major>.<minor>-<two-word-task>.keymap

The candidate SHA-256 is the review identity. A reviewer may approve only one
specific hash. Editing the candidate after either review invalidates both
reviews and starts the review cycle again.

## Reviewer A and Reviewer B records

Create these records beside the candidate:

    v<major>.<minor>-<two-word-task>.review-a.md
    v<major>.<minor>-<two-word-task>.review-b.md

Each record must contain all of the following:

1. Reviewer identity: Senior Keychron/ZMK Engineer A or B.
2. Candidate path and SHA-256.
3. Prior QC-passed baseline path and Git blob ID.
4. Approved physical-key IDs, limited to one through four.
5. Every supporting non-binding change, with its exclusive references.
6. Diff findings for bindings, behaviors, combos, includes, defines, and
   formatting-only changes.
7. Layer count and ordered binding count per layer.
8. The full 20-cell direct-control map, positions 77 through 81 across all
   four layers.
9. Build-input provenance check: how the reviewed candidate will be copied to
   the shield build-input path and hash-verified immediately before build.
10. A final verdict of PASS or BLOCK, followed by unresolved findings.

## Consensus rule

Compile is permitted only when:

- both records state PASS;
- both records name the identical candidate SHA-256;
- both records approve the same allowed change set;
- no unresolved finding remains; and
- the active shield build-input keymap hashes identically to the reviewed
  candidate immediately before the pristine configure/build.

Any disagreement, missing record, changed hash, unsupported file change, or
BLOCK verdict stops the revision. Do not compile a UF2.

## Required adversarial checks

Reviewers must specifically try to prove each candidate unsafe by checking:

- unapproved matrix bindings or row-wide changes;
- altered direct controls, including the Mac/Win state in both positions;
- removed factory recovery, output, bootloader, or combo behavior;
- unexpected behavior timing or shared behavior side effects;
- layer-number, layer-count, or binding-count drift;
- active build-input mismatch;
- incorrect rollback UF2 path or recovery procedure; and
- missing test coverage for tap, hold, release, repeat, interruption, normal
  Base typing, Bluetooth/2.4G controls, Fn-plus-minus Boot, and physical
  bootloader recovery.
