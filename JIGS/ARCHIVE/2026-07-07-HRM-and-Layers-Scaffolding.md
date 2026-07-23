# Session Summary: 2026-07-07

**Topic:** Homerow Modifiers Validation & Layer Architecture Scaffolding

## What was Accomplished
1. **Homerow Modifiers Validated:**
   - The user tested the flashed firmware and confirmed that the HRMs (mapped via standard `&mt`) function flawlessly on the B1 Pro hardware.
   - The global ZMK hack (`app/dts/behaviors/mod_tap.dtsi` -> `flavor = "tap-preferred"`) was verified as the correct fix for preventing phantom holds during fast typing.
2. **Keyboard Matrix Discovery (Ghosting):**
   - The user discovered that the B1 Pro matrix exhibits severe masking/ghosting when multiple keys in a square are pressed (e.g., holding `ASDF` blocks `G` and `H`).
   - We determined this is a hardware limitation due to the lack of diodes in the cheap scissor-switch membrane.
   - **Conclusion:** We cannot use `urob`-style simultaneous key combos for symbols. We must rely on `&lt` (Layer-Taps), which limit simultaneous presses to 2 keys.
3. **Layer Architecture Scaffolding:**
   - Restored Layer 2 to factory defaults.
   - Since the physical switch is left on "Mac", Layers 2 and 3 were completely wiped of Windows factory defaults to serve as blank canvases.
   - Converted `G` and `H` on Layer 0 to `&lt 3 G` and `&lt 2 H`.
   - Placed a global `&to 0` escape hatch on the `ESC` key for the new layers to prevent layer-traps.
   - Loaded Layers 2 and 3 with transparent `&trans` placeholders.
4. **ZMK Framework Education:**
   - Explained how ZMK `&mt` functions are inherited via `#include <behaviors.dtsi>` rather than manually written in the keymap.
   - Explained why the ZMK repository is 7.2GB (it contains the entire Zephyr RTOS, Bluetooth stacks, and HALs).
   - Clarified that `west update` stores these massive dependencies in nested repositories that are `.gitignore`d from the main project.

## Agent Recommendations
*   **Skill Export:** The custom PowerShell script used to build the firmware and wait in an infinite loop for the bootloader drive to mount (`wait_and_flash.ps1`) is highly robust. **Recommendation:** Export this script into an Antigravity Skill so future agents can seamlessly build and flash ZMK keyboards on Windows without needing to rewrite the loop logic.

## Next Steps
- Implement the "Programmer's Baseline" symbol map into the Layer 2 and 3 placeholders.
- Tackle the remaining backlog items (Numpad, Nav layers, Hardware controls).
