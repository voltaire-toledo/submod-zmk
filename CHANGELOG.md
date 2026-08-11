# Firmware Build Changelog

## v0.25-candidate (candidate — unapproved) - 2026-08-11

**Baseline:** `v0.24-sync-layers`  
**Baseline keymap:** `B1PRO/releases/v0.24/v0.24-sync-layers.keymap`  
**Baseline SHA-256:** `c94b0555cd77d61e9fc96bef28b73367ed491a5db3c2788f720825dfea73c30c`  
**Candidate keymap:** `B1PRO/QC-IN_PROGRESS/v0.25-candidate.keymap`  
**Candidate keymap SHA-256:** TBD  
**Candidate UF2:** Pending compilation  

- **Status:** Scaffolding complete; unapproved candidate awaiting binding definition and build.

---

## v0.24-sync-layers (released) - 2026-08-11

**Baseline:** `v0.23-mac-win-full-layers`  
**Archived keymap:** `B1PRO/releases/v0.24/v0.24-sync-layers.keymap`  
**Archived keymap SHA-256:** `c94b0555cd77d61e9fc96bef28b73367ed491a5db3c2788f720825dfea73c30c`  
**Archived UF2:** `B1PRO/releases/v0.24/v0.24-sync-layers.uf2`  
**Archived UF2 SHA-256:** `9641b7660f258ac49cd420ffa64490ee35462bad0406427dbde42b2baefe476a`

- **Status:** Hardware QC PASSED on 2026-08-11. Promoted and archived into `B1PRO/releases/v0.24/`.
- **Scope:** Retains twelve 82-position layers. Fifty-seven bindings changed
  across eight layers. Direct controls (positions 77–81), physical OS-switch
  behavior, and the Function-layer bootloader binding are unchanged.

### Mac Function-row swap

Mac-labelled functions move from `LYR_M_FUNC` (Layer 1) to `LYR_M_BASE`
(Layer 0); F1–F12 move to the Fn layer.

| Position | v0.23 Layer 0 | v0.24 Layer 0 | v0.23 Layer 1 | v0.24 Layer 1 |
| --- | --- | --- | --- | --- |
| 1 | F1 | Brightness down | Brightness down | F1 |
| 2 | F2 | Brightness up | Brightness up | F2 |
| 3 | F3 | Mission Control / show all windows | Mission Control / show all windows | F3 |
| 4 | F4 | Mac launch | Mac launch | F4 |
| 5 | F5 | Search | Search | F5 |
| 6 | F6 | `C_AL_LOCK` | Ctrl+Alt+M | F6 |
| 7 | F7 | Previous track | Previous track | F7 |
| 8 | F8 | Play/Pause | Play/Pause | F8 |
| 9 | F9 | Next track | Next track | F9 |
| 10 | F10 | Mute | Mute | F10 |
| 11 | F11 | Volume down | Volume down | F11 |
| 12 | F12 | Volume up | Volume up | F12 |

### Mac shortcut and symbol corrections

- `LYR_M_NAV1` position 30: `&uc LC(W)` → `&uc LG(W)` (Ctrl+W → Cmd+W).
- `LYR_M_NAV1` position 58: `&uc LG(C)` → `&td_nav_c_mac 0`:
  single Cmd+C, double Cmd+Shift+C, triple Ctrl+Shift+C.
- `LYR_M_NAV1` position 59: `&uc LG(V)` → `&td_nav_v_mac 0`:
  single Cmd+V, double Ctrl+V, triple Ctrl+Shift+V.
- `LYR_M_SYM1` position 66: `&kp RSHFT` → `&uc LC(LG(SPACE))`
  (Ctrl+Cmd+Space emoji picker).

### Windows base modifier corrections

- `LYR_W_BASE` position 68: `&uc LALT` → `&uc LCMD`.
- `LYR_W_BASE` position 69: `&uc LCMD` → `&uc LALT`.
- `LYR_W_BASE` position 71: `&uc RCMD` → `&uc RALT`.

### Windows Function-layer corrections

- Position 3: `&kp C_AC_DESKTOP_SHOW_ALL_WINDOWS` → `&uc LG(TAB)`.
- Position 4: `&kp C_AC_MAC_LAUNCH` → `&uc LG(E)`.
- Position 6: `&uc LC(LA(M))` → `&uc LG(L)`.
- Position 15: `&to LYR_W_FUNC` → `&td_bt_0 0`.
- Position 16: `&to LYR_W_SYM1` → `&td_bt_1 0`.
- Position 17: `&to LYR_W_NAV1` → `&td_bt_2 0`.
- Position 18: `&to LYR_W_UAT` → `&out OUT_24G`.
- Position 19: `&to LYR_W_MCRO` → `&trans`.
- Positions 29–32: `&td_bt_0 0`, `&td_bt_1 0`, `&td_bt_2 0`, and
  `&out OUT_24G` → `&trans`; BT/2.4G selection is therefore relocated to
  positions 15–18.
- Position 41: `&uc LG(LS(N4))` → `&uc LG(LS(S))`
  (macOS screenshot shortcut → Win+Shift+S).
- Position 66: `&uc LC(LG(SPACE))` → `&uc LG(DOT)`
  (macOS emoji picker → Win+Period).
- Position 71: `&kp RCTRL` → `&trans`.

### Windows Navigation and Symbols corrections

- `LYR_W_NAV1` position 34: `&uc LG(Y)` → `&uc LC(Y)` (Win+Y → Ctrl+Y).
- `LYR_W_SYM1` position 42: `&none` → `&kp TILDE`.
- `LYR_W_SYM1` position 62: `&none` → `&td_sym_angle_brackets 0`:
  single `<`, double `>`, triple `<>`.
- `LYR_W_SYM1` positions 63–65: `&kp LT`, `&kp GT`, `&kp QMARK` → `&trans`.
- `LYR_W_SYM1` position 66: `&kp RSHFT` → `&uc LG(DOT)`.
- `LYR_W_SYM1` positions 73–76: `&kp LEFT`, `&kp UP`, `&kp DOWN`,
  `&kp RIGHT` → `&trans`.

### Behavior definitions and tooling

- Added `sym_angle_brackets`, `td_sym_angle_brackets`, `td_nav_c_mac`, and
  `td_nav_v_mac` behavior definitions.
- Updated keymap diagrams/comments to match the changed Mac Function-row and
  Windows shortcuts.
- Added version-neutral `scripts/lint-keymap.ps1`; retired the
  v0.23-specific validator. No ZMK firmware source or DTS code changed.

##### Required before release promotion

- Complete the single v0.24 release record, two independent reviews, and
  hardware QC. Do not treat this build or its UF2 hash as a hardware PASS.


## v0.23-mac-win-full-layers - 2026-07-30

**UF2**: `v0.23-mac-win-full-layers.uf2`
**Keymap**: `v0.23-mac-win-full-layers.uf2`
- Full OS Layer Separation: Expanded the keymap from a basic factory setup to twelve complete 82-key layers (Mac layers 0–5, Windows layers 6–11) to perfectly match both operating systems.
- Physical OS Switch: Bound physical key position 77 to toggle between the Mac and Windows base layers.
- **LAYER 1/7**: Built out a full numpad under the right hand, added Bluetooth select/pair 
  tap-dances, and mapped F13-F24 and screen capture shortcuts.
- **LAYER 2/8**: Mapped out an extensive custom symbols layer. Added single, double, and triple tap-dances for parentheses (), braces {}, and brackets [], as well as smart tap-dances for -/_ and =/+.
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
> * This will easy enough to recover from - there's a pinhold reset button under the keyboard near the physical switches. Press that for a few seconds while plugging in the USB cable. This will restore things back to a working state. 
> * However, to use the Keychron Launcher, download the Factory firmware and install it before doing so.


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
