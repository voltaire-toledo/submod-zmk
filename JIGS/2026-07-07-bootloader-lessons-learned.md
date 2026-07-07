# Keychron B1 Pro Hardware Lessons Learned

## Lesson 1: The Undocumented Reset Button
Despite having ultra-slim scissor switches, the B1 Pro has a hidden physical reset hole on the bottom case (requiring a paperclip/SIM ejector tool). 
**To trigger a true factory hardware reset:**
1. Set physical switch to **Win**.
2. Set source switch to **Cable**.
3. Press and hold the button through the hole.
4. Plug in the USB-C cable.
5. The power light will flash erratically for 3-5 seconds, indicating the reset is complete.

## Lesson 2: The VIA Bootloader Mapping
The documentation states that holding `fn` + `-` while plugging in the USB-C cable enters the bootloader. However, this actually relies on VIA's specific software configuration. In the factory firmware, the `-` key on the FN layer is mapped to `CUSTOM(3):Bootloader` (which appears as a "Boot" key in the VIA interface). 

Because we hardcoded our own `.keymap` and bypassed VIA, we inadvertently wiped that `CUSTOM(3)` mapping. This is why the `fn` + `-` shortcut stopped working on our custom firmware, forcing us to discover the undocumented reset hole from Lesson 1!
