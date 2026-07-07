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
