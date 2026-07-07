# Homerow Modifiers Plan for Keychron B1 Pro

## Objective
Enable responsive homerow modifiers (HRMs) on the Keychron B1 Pro keyboard by fixing the core mod-tap behavior and mapping the HRMs directly in the ZMK keymap, bypassing VIA UI limitations.

## Problem Description
1. **The Engine Problem:** The stock Keychron ZMK firmware uses `hold-preferred` behavior for mod-tap (`mt`) keycodes, which produces phantom modifiers during fast typing.
2. **The Assignment Problem:** The Keychron Launcher (VIA) lacks a UI to easily assign `MT` (mod-tap) keys to the home row.

## Resolution
1. **Fix Behavior Engine (`mod_tap.dtsi`):**
   Modify ZMK's core `MOD_TAP` behavior to use `tap-preferred` and add `quick-tap-ms = <200>;` to eliminate phantom modifiers.
2. **Implement HRMs in Keymap (`keychron_b1_us.keymap`):**
   Directly edit the ZMK keymap source to apply HRMs to the Mac and Windows layers (e.g., changing `A` to `&mt LCTRL A`).
3. **Workspace & Toolchain Setup:**
   Initialize the `west` workspace, run `west update`, and apply Keychron's required Zephyr patch.
4. **Firmware Build:**
   Compile the custom firmware using `west build`.
