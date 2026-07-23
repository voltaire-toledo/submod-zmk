# Session Transcript: Keychron Screenshot Bindings

## Question

Identify the code behind Keychron Launcher's `PrtSc-m` and `PrtSc-w` actions
assigned to the physical backslash key on the B1 Pro factory layers.

## Finding

The factory keymap uses ordinary composite keypresses through the `&uc`
(`user_custom`) behavior, which is declared as `zmk,behavior-key-press`.

| Launcher label | Factory layer (zero-based) | Factory binding | OS shortcut |
| --- | ---: | --- | --- |
| `PrtSc-m` | 1, Mac Function | `&uc LG(LS(N4))` | Command + Shift + 4 |
| `PrtSc-w` | 3, Windows Function | `&uc LG(LS(S))` | Windows + Shift + S |

Keychron's launcher mapping code recognizes those exact composite keycodes and
converts them to/from `UC_PRNS_MAC` and `UC_PRNS_WIN` for display in the UI.
They are not separate runtime screenshot behaviors.

## Evidence

- `app/boards/shields/keychron/b1/us/keychron_b1_us_factory.keymap`
- `app/src/launcher/launcher.h`
- `app/src/launcher/map_keycode.c`

## Workflow recommendation

No reusable skill or script is warranted for this one-off source lookup.
