# QC In Progress

This directory contains only versioned, not-yet-QC-passed B1 Pro keymaps and
their matching QC records. Do not overwrite or delete an artifact after a UF2
has been built from it.

Start every revision by copying the exact v1.0_HRM QC-passed baseline and
following JIGS/BACKLOG.md. A revision is limited to four named physical key
changes and must remain here until its hardware QC result is recorded.

Before any compile, two independent senior Keychron/ZMK reviewers must both
PASS the same candidate-keymap SHA-256. Read REVIEW-PROTOCOL.md and preserve
the candidate keymap, manifest, both reviews, QC record, UF2, and UF2 hash
under one shared versioned stem.
