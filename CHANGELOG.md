# Firmware Build Changelog

## v0.23-mac-win-full-layers - 2026-07-30

**UF2**: `v0.23-mac-win-full-layers.uf2`
**Keymap**: `v0.23-mac-win-full-layers.uf2`

- Full OS Layer Separation: Expanded the keymap from a basic factory setup to twelve complete 82-key layers (Mac layers 0–5, Windows layers 6–11) to perfectly match both operating systems.
- Physical OS Switch: Bound physical key position 77 to toggle between the Mac and Windows base layers.
- **LAYER 1/7**: Built out a full numpad under the right hand, added Bluetooth select/pair
  tap-dances, and mapped F13-F24 and screen capture shortcuts.
- **LAYER 2/8**: Mapped out an extensive custom symbols layer. Added single, double, and triple tap-dances for parentheses (), braces {}, and brackets [], as well as smart tap-dances for -/\_ and =/+.
- **LAYER 3/9**: Mapped mouse movement, clicks, and scroll wheel actions alongside heavy window management shortcuts and dedicated arrow navigation.
- **Feat**: Added a Hyper Tab (Ctrl+Shift+Cmd+Alt) mod-tap.
- **Feat**: Added Navigation layer holds to both Space and Backslash.
- **Feat**: Added Symbols layer holds to G and H.
- **Feat**: Added a Right Shift / Emoji hold-tap.
- **Fix**:
  - Escape/Caps dual-role binding was requiring a dual-hold sequence to toggle Caps Lock.
  - Fixed F6 to correctly map to Ctrl+Alt+M.
  - Fixed Windows Ctrl+V on the Navigation layer.
  - Restored standard Space behavior on position 22 of the Navigation layers.

##### Unresolved:

- **TL;DR version**: Once installed, connecting to https://launcher.keychron.com for VIA configuration will "break" the configuration.

> [!NOTE]
>
> - This will easy enough to recover from - there's a pinhold reset button under the keyboard near the physical switches. Press that for a few seconds while plugging in the USB cable. This will restore things back to a working state.
> - However, to use the Keychron Launcher, download the Factory firmware and install it before doing so.

---

## v0.9 (2026-07-20)

##### Broke lots. Fixed lots. Lessons Learned.

**UF2:** `v0.9-esc-caps.uf2`
**Keymap**: `v0.9.esc-caps.keymap`

- Layer 0: Verify the bilateral home-row-modifier fix.
- Layer 0: Physical Esc key taps Escape and, after a 600 ms hold, toggles Caps Lock.
- Layer 1: ten-key numpad foundation, including retained direct controls and recovery paths.

---

## Factory-2024-07-22 (From Keychron Directly)

##### Factory Image and Keymap

**UF2:** `zmk_b1pro_us_v1.0.3_2407221034_e013003c-271c-4949-b9a2-e58582ca12e3.uf2`
**Keymap**: `DO-NOT-MODIFY_keychron_b1_us_factory.keymap`

- **Status:** Unavailable; vendor factory image.

---

## Entry format

Newest versions up top

```markdown
## <revision> (YYYY-MM-DD)

##### Title

- **UF2:** `file.uf2`
- \*Keymap:\*\* `file.keymap`
- [ **Feature** | **Layer x:** | **Fix** | **Unresolved** ]
```
