# Agent Directives

These directives guide AI agents (including Antigravity) throughout this repository's lifecycle.

## Communication

- Keep responses for this project compact and concise. Grammar may be
  sacrificed when doing so improves brevity without losing essential meaning.

## Required Workflows

1. **Initial Session Setup:**
   - Search the environment for ZMK-related skills or plugins and install/reference them in this repo.
2. **Session Start Checklist:**
   - At the beginning of *every* session, always read the [JIGS/](file:///C:/Users/Jigs/CODE/VT-ZMK-B1-Pro/JIGS) markdown documents (`PLAN.md`, `HANDOFF.md`, etc.) to align on goals, objectives, and current status.
3. **Session End Checklist:**
   - Do not create transcripts, narrative recaps, or documentation solely to
     record a session.
   - Persist only durable, approved records: decisions in the authoritative
     specification or backlog; completed actions in the relevant QC or release
     artifact; and approved firmware evidence in `QC-PASS` and `CHANGELOG.md`.
   - Review recent work for a reusable script, utility, or workflow only when
     it supports an approved recurring action; present that recommendation to
     the user rather than creating speculative documentation.
4. **Firmware Build Revision Log:**
   - Maintain the root [CHANGELOG.md](CHANGELOG.md) alongside the project's
     Markdown documentation.
   - Before copying a project or factory UF2 to a physical test unit, assign a
     revision identifier and append an entry to `CHANGELOG.md`.
   - Each entry must record the revision identifier, date, UF2 path and
     SHA-256, source commit (when available), target test unit, and the
     observed test result. Do not log a build merely because it compiled.
5. **Keymap Candidate Delivery:**
   - Before requesting user approval for any newly defined `.keymap` candidate,
     provide one companion release record.
   - The release record must compare the candidate side by side with the most recent
     QA-passed release, identifying that baseline by path, revision, and hash.
   - It must enumerate every changed binding by zero-based physical position,
     every added, removed, or changed keymap behavior, and the complete
     direct-control result.
   - It must separately explain every candidate-related code-file update
     outside the candidate keymap, including its purpose and safety impact;
     explicitly state when no firmware source or DTS code changed.
   - Add the reviewer verdict, build-input proof, UF2 hash, and observed
     hardware result to that same record as the work advances. Do not create
     separate manifest, review-summary, or QC-status documents that duplicate
     it.
   - Use one senior review by default after deterministic validation. Require a
     second independent review only for protected direct controls, physical
     Fn/boot/reset behavior, layer structure, combos, shared behavior or
     runtime code, or changes to three or more physical positions.
   - Do not burden the release record with unrelated documentation changes or
     pre-existing user worktree changes.
6. **QC-PASS Promotion and Archive:**
   - Promote a candidate only after the tester explicitly reports that every
     required hardware assertion passed. A successful build or UF2 transfer is
     not a QC pass.
   - Move (do not copy) the exact approved keymap, UF2, UF2 SHA-256 sidecar,
     and complete release record into a unique
     `JIGS/QC-PASS/<revision-and-description>/` directory.
   - Verify the archived UF2 hash against its SHA-256 sidecar and update the
     existing `CHANGELOG.md` revision entry to use the archived UF2 path and
     record the observed passing hardware results, including required retained
     behavior.
   - Update the backlog or handoff stop condition to identify the archived
     QC-passed release and the next permitted gate. Never promote untested or
     transfer-only candidates; leave their artifacts outside `QC-PASS`.
7. **JIGS Document Cadence:**
   - `JIGS/HANDOFF.md` is the live task manifest only: `Done`, `In progress`,
     and `Remaining`. Replace stale status rather than appending history.
   - `JIGS/BACKLOG.md` contains only work that surfaces outside the PRD during
     execution. Promote an accepted item to an approved candidate or remove it
     when resolved; do not use it as a session log.
   - `JIGS/LEARNINGS.md` contains only verified troubleshooting notes, dead
     ends, and justified skill or automation candidates. Do not add narrative
     recaps or speculative lessons.
8. **Required Next-Run Completion:**
   - Before beginning any new firmware work, complete the following unfinished
     document-role updates and report their completion to the user:
     - `JIGS/HANDOFF.md`: create or replace it as the live task manifest with
       only `Done`, `In progress`, and `Remaining` sections.
     - `JIGS/BACKLOG.md`: make it the register for work that surfaces outside
       the PRD during execution, not a task manifest or session history.
     - `JIGS/LEARNINGS.md`: limit it to verified troubleshooting notes, dead
       ends, and justified skill or automation candidates.

9. **B1 Pro Build Environment:**
   - Never use Docker or pull a Docker image for a B1 Pro firmware build,
     including as a fallback.
   - Use the native WSL build guide when available. When WSL is inaccessible,
     use the validated Windows fallback: the repository `.venv` tools with
     Zephyr SDK 0.15.2 and serialized Ninja.
   - Do not change a Docker image pin to work around an unavailable toolchain.
