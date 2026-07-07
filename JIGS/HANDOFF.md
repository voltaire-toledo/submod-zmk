# Homerow Modifiers Scaffolding Tasks (HANDOFF)

This document tracks all tasks necessary to achieve our goal, including statuses and remaining items.

## Current State of the Repository
- **Branch:** `feat/homerow-mods-b1-pro`
- **Working Tree:** Clean. [PLAN.md](file:///C:/Users/Jigs/CODE/VT-ZMK-B1-Pro/JIGS/PLAN.md) created.
- **DTS File Located:** [mod_tap.dtsi](file:///C:/Users/Jigs/CODE/VT-ZMK-B1-Pro/app/dts/behaviors/mod_tap.dtsi) verified.

## Task Roadmap

| ID | Task | Status | Notes |
|---|---|---|---|
| T01 | Propose high-level numbered plan | **Done** | Approved by user. |
| T02 | Create branch `feat/homerow-mods-b1-pro` | **Done** | Checked out and active. |
| T03 | Create `JIGS/` directory with md logs | **Done** | PLAN, HANDOFF, BACKLOG, LEARNINGS created. |
| T04 | Create `AGENTS.md` starter | **Done** | Created with session directives. |
| T05 | Search for ZMK-related skills | **Done** | Checked VT-SKILLS-Library and catalog.json; none found. |
| T06 | Sync Documentation | **Done** | Updated PLAN.md and HANDOFF.md with HRMs strategy. |
| T07 | Fix Behavior Engine (`mod_tap.dtsi`) | **Done** | Set `tap-preferred` and `quick-tap-ms`. |
| T08 | Implement HRMs in Keymap | **Done** | Updated `keychron_b1_us.keymap` layers. |
| T09 | Set up west workspace and patch | **Done** | `west init`, `west update`, applied patch in `.venv`. |
| T10 | Build and verify firmware | **Pending** | Run Zephyr build command. |

## Remaining Tasks
- Complete creation of remaining JIGS directory logs (`BACKLOG.md`, `LEARNINGS.md`).
- Create root-level [AGENTS.md](file:///C:/Users/Jigs/CODE/VT-ZMK-B1-Pro/AGENTS.md).
- Search and integrate any matching ZMK skills.
- Perform the code change in [mod_tap.dtsi](file:///C:/Users/Jigs/CODE/VT-ZMK-B1-Pro/app/dts/behaviors/mod_tap.dtsi).
- Set up west build environment and run compile command.
