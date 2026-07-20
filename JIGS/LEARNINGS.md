# Project Learnings

This document summarizes ZMK-related issues found and how they were resolved.

## Entries

### 2. Isolated Toolchain Environment
*   **Problem:** Installing `west` globally can pollute the system Python environment and cause dependency conflicts with other projects.
*   **Fix:** Use a localized Python virtual environment (`python -m venv .venv`) inside the workspace to sandbox the ZMK build tools.


### 1. Homerow Modifiers (HRMs) Phantom Triggers
*   **Problem:** Accidental modifier holds (phantom modifiers) on stock keymaps occur during fast typing because ZMK uses `hold-preferred` behavior for mod-taps by default.
*   **Fix:** Modify global `MOD_TAP` behavior to use `tap-preferred` flavor with `quick-tap-ms = <200>`.
*   **File Modified:** [mod_tap.dtsi](file:///C:/Users/Jigs/CODE/VT-ZMK-B1-Pro/app/dts/behaviors/mod_tap.dtsi)

### 3. Keychron's ZMK Fork Limitations (Dead Keys)
*   **Problem:** Injecting advanced ZMK behaviors (like `require-prior-idle-ms` from `urob`'s timerless HRM approach) into Keychron's older ZMK fork caused the entire behavior block to be rejected by the devicetree compiler. This resulted in the keys mapped to the custom behavior becoming completely dead (unbound).
*   **Correction:** This conclusion was disproven by the `v1.0_HRM` build. The fork accepts `require-prior-idle-ms`, `hold-trigger-key-positions`, and `hold-trigger-on-release` when they are defined in valid custom hold-tap behaviors.
*   **Verified Fix:** Use separate left/right positional hold-tap behaviors so same-hand rolls force taps and only opposite-hand keys can authorize modifier holds. The configuration was built, flashed, and hardware-tested successfully.
