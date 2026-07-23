# Keychron B1 Pro (ANSI) ZMK Keymap Specification

This document defines the Keychron B1 Pro's intended ZMK keymap. The active
firmware source is `app/boards/shields/keychron/b1/us/keychron_b1_us.keymap`.
The diagrams are a specification: a binding is only implemented once it also
exists in that keymap and passes the focused validator.

## Canonical ZMK layer convention

ZMK addresses a layer by its **zero-based numeric index**. In a keymap,
`&mo`, `&lt`, and `&to` receive that index (or a C preprocessor constant that
expands to it). The devicetree node label, such as `layer_num`, is a
project-defined identifier, not a separate ZMK layer number.

Use these names and indices everywhere in this project:

| Index | Canonical constant | ZMK node        | Status                                         |
| ----: | ------------------ | --------------- | ---------------------------------------------- |
|     0 | `LAYER_BASE`       | `layer_base` | Implemented default layer                      |
|     1 | `LAYER_FN-NUM`     | `layer_fn-num`  | Implemented factory Function layer & numpad    |
|     2 | `LAYER_SYM`        | `layer_sym`     | Implemented combined Symbols layer             |
|     3 | `LAYER_NAV`        | `layer_nav`               | Reserved for Navigation; no node/bindings yet  |

Indices 5 and above are unassigned. Do not introduce a Muggle, Bypass, or
System layer number until its keymap node, activation path, and acceptance
test have been agreed.

---

## Temporary Layer Access: User Workflow
This workflow enables the user to access the various layers while holding down a designated LAYER_ACTIVATION_KEY assigned to each layer. When the user releases the key, the keyboard will switch back to LAYER_BASE. The LAYER_ACTIVATION_KEYS are:

| LAYER Access | Temp Activation Keys |
|-------------:|:---------------------|
**LAYER_FN-NUM** |  **[CAPS]** OR **[Fn]**
**LAYER_SYM** | **[G]** OR **[H]**
**LAYER_NAV** | **[SPACE]** or **[\\]**

```mermaid
flowchart LR
classDef base fill:#e2e8f0,stroke:#475569,stroke-width:2px,color:#0f172a;
classDef fnnum fill:#dbeafe,stroke:#2563eb,stroke-width:2px,color:#1e3a8a;
classDef sym fill:#f3e8ff,stroke:#7e22ce,stroke-width:2px,color:#581c87;
classDef nav fill:#dcfce7,stroke:#16a34a,stroke-width:2px,color:#14532d;

Base["LAYER_BASE"]
FnNum["LAYER_FN-NUM"]
Sym["LAYER_SYM"]
Nav["LAYER_NAV"]
Return["Return to LAYER_BASE"]

Base .->|HOLD #91;Caps#93; or #91;Fn#93;| FnNum
Base .->|HOLD #91;G#93; or #91;H#93;| Sym
Base .->|HOLD #91;SPACE#93; or #91;\#93;| Nav

FnNum -->|Release| Return
Sym -->|Release| Return
Nav -->|Release| Return

class Base,Return base
class FnNum fnnum
class Sym sym
class Nav nav
```

### Persistent Layer Access: User Workflow
1. The user will TAP the [Fn] key for One-Shot Access to Layer 1 (LAYER_FN-NUM)
2. User taps the Number Row [1], [2], or [3]:
    a. [1] will switch to the LAYER_FN-NUM.
    b. [2] will switch to the LAYER_SYM.
    c. [3] will switch to the LAYER_NAV.
3. From within the 3 layers (LAYER_FN-NUM, LAYER_SYM, LAYER_NAV), the [Esc] is configured to switch the kayboard back to LAYER_BASE.
  
```mermaid
flowchart LR
classDef base fill:#e2e8f0,stroke:#475569,stroke-width:2px,color:#0f172a;
classDef fnnum fill:#dbeafe,stroke:#2563eb,stroke-width:2px,color:#1e3a8a;
classDef sym fill:#f3e8ff,stroke:#7e22ce,stroke-width:2px,color:#581c87;
classDef nav fill:#dcfce7,stroke:#16a34a,stroke-width:2px,color:#14532d;

Base["LAYER_BASE"]
Armed(["One-shot layer armed"])
FnNum["LAYER_FN-NUM"]
Sym["LAYER_SYM"]
Nav["LAYER_NAV"]
Return["Return to LAYER_BASE"]

Base .->|"TAP #91;Fn#93;"| Armed
Armed -->|"TAP #91;1#93;"| FnNum
Armed -->|"TAP #91;2#93;"| Sym
Armed -->|"TAP #91;3#93;"| Nav

FnNum -->|"TAP #91;Esc#93;"| Return
Sym -->|"TAP #91;Esc#93;"| Return
Nav -->|"TAP #91;Esc#93;"| Return

class Base,Return base
class Armed,FnNum fnnum
class Sym sym
class Nav nav
```

## Layer Index 0: `LAYER_BASE` / `default_layer`

- **How Activated:** Default active layer.
- **Desired explicit dual-role definitions:**

  | Physical key | Tap action | Hold action | VIA interpretation | Specification status |
  | --- | --- | --- | --- | --- |
  | **[CAPS]** | `Esc` | Temporarily activate `LAYER_FN-NUM`; releasing the key returns to `LAYER_BASE`. | `LT(1, KC_ESC)` | Desired; firmware change required. |
  | **[Esc]** | `Esc` | After more than 600 ms, toggle `Caps Lock`. | No direct VIA `LT` equivalent; requires a ZMK custom hold-tap behavior. | Desired; firmware change required. |

- **Special Dual-Role Keys:**
  - **Tab:** Taps as `Tab`, holds as **Hyper** (`Cmd + Alt + Ctrl + Shift`).
  - **Caps Lock:** Taps as `Escape`, holds **Layer 1 — Function and Numpad** (`LAYER_FN-NUM`) only while held, then returns to `LAYER_BASE` on release.
  - **Escape:** Taps as `Escape`; a hold longer than 600 ms toggles `Caps Lock`.
  - **Spacebar:** Currently sends `Space`; hold **Layer 4 — Navigation** (`LAYER_NAV`) is planned, not implemented.
  - **G** and **H:** Each taps as its letter and holds the shared **Layer 3 — Symbols** (`LAYER_SYM`).
  - **Z:** Currently sends plain `z`; it is not an Fn layer-tap.
  - **Physical Fn key:** Holds **Layer 1 — Function** (`LAYER_FN`).
  - **Home Row Modifiers:** Taps as character, holds as modifier on opposite-hand presses:
    - `A`/`S`/`D`/`F` $\rightarrow$ `Ctrl`/`Cmd`/`Alt`/`Shift`
    - `J`/`K`/`L`/`;` $\rightarrow$ `Shift`/`Alt`/`Cmd`/`Ctrl`

```text
  ┏━━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━┓
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┃TAP: ESC   ┃   F1    ┃   F2    ┃   F3    ┃   F4    ┃   F5    ┃   F6    ┃    F7   ┃    F8   ┃    F9   ┃   F10   ┃   F11   ┃   F12   ┃  DEL   ┃
  ┃HOLD: CAPS ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┣━━━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━━━━┫
  ┃   ~   ┃    !    ┃    @    ┃    #    ┃    $    ┃    %    ┃    ^    ┃    *    ┃    -    ┃    (    ┃    )    ┃    _    ┃    +    ┃            ┃
  ┃   `   ┃    1    ┃    2    ┃    3    ┃    4    ┃    5    ┃    6    ┃    7    ┃    8    ┃    9    ┃    0    ┃    -    ┃    =    ┃    BKSP    ┃
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┣━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━━━━┫
  ┃TAP: TAB  ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃    {    ┃    }    ┃    |    ┃
  ┃HOLD: HYPR┃    Q    ┃    W    ┃    E    ┃    R    ┃    T    ┃    Y    ┃    U    ┃    I    ┃    O    ┃    P    ┃    [    ┃    ]    ┃    \    ┃
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┣━━━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻━━━━━━━━━┫
  ┃TAP=ESC    ┃ TAP=A   ┃ TAP=S   ┃ TAP=D   ┃ TAP=F   ┃ TAP=G   ┃ TAP=H   ┃ TAP=J   ┃ TAP=K   ┃ TAP=L   ┃ TAP=;/: ┃    "    ┃                  ┃
  ┃HOLD:MO(1) ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃ HLD=    ┃    '    ┃      RETURN      ┃
  ┃           ┃  L_CTRL ┃  L_GUI  ┃  L_ALT  ┃ L_SHIFT ┃   MO(2) ┃   MO(2) ┃ R_SHIFT ┃  R_ALT  ┃  R_GUI  ┃  R_CTRL ┃         ┃                  ┃
  ┣━━━━━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━━━━━━━━━━━━━━━━━┫
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃    <    ┃    >    ┃    ?    ┃                         ┃
  ┃   L_SHIFT    ┃    Z    ┃    X    ┃    C    ┃    V    ┃    B    ┃   N     ┃    M    ┃    ,    ┃    .    ┃    /    ┃        R_SHIFT          ┃
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┣━━━━━━━━━━━┳━━┻━━━━━━━┳━┻━━━━━━━━━╋━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━╋━━━━━━━━━┻━━━━┳━━━━┻━━━━━┳━┳━┻━━━━━━┳━━━━━━━━━┳━━━━━━━━┫
  ┃           ┃          ┃           ┃                                                 ┃              ┃TAP:OSL(1)┃ ┃        ┃    ↑    ┃        ┃
  ┃  L_CTRL   ┃  L_ALT   ┃   L_CMD   ┃               * LT MAC_LNAV SPACE *             ┃    R_CMD     ┃HOLD:MO(1)┃ ┃    ←   ┣━━━━━━━━━┫   →    ┃
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃    ↓    ┃        ┃
  ┗━━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┻━━━━━━━━━━┛ ┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━┛

### NEW LAYER 0: LAYER_MAC_BASE
default_layer {
bindings = <
//ESC            	  //f1            //f2          //f3          //f4          //f5        //f6      //f7            //f8          //f9                  //f10             //f11       //f12       //DEL                                              
&esc_caps CLCK ESC  &kp F1          &kp F2        &kp F3        &kp F4        &kp F5      &kp F6    &kp F7          &kp F8        &kp F9                &kp F10           &kp F11     &kp F12     &kp DEL
&kp GRAVE   		    &kp N1          &kp N2        &kp N3        &kp N4        &kp N5      &kp N6    &kp N7          &kp N8        &kp N9                &kp N0            &kp MINUS   &kp EQUAL   &kp BSPC 
&kp TAB     		    &kp Q           &kp W         &kp E         &kp R         &kp T       &kp Y     &kp U           &kp I         &kp O                 &kp P             &kp LBKT    &kp RBKT    &lt 3 BSLH
&lt 1 ESC   		    &lhm LCTRL A    &lhm LGUI S   &lhm LALT D   &lhm LSHFT F  &lt 2 G     &lt 2 H   &rhm RSHFT J    &rhm RALT K   &rhm RGUI L           &rhm RCTRL SEMI   &kp SQT                 &kp RET 
&kp LSHFT   		    &kp Z           &kp X         &kp C         &kp V         &kp B       &kp N     &kp M           &kp COMMA     &kp DOT               &kp FSLH                                  &kp RSHFT
&kp LCTRL           &uc LALT        &uc LCMD                                  &lt MAC_NAV SPACE                     &uc RCMD      &fn_layer_access 1 1  &kp LEFT          &kp UP      &kp DOWN    &kp RIGHT
// RESERVED. DO NOT MODIFY
&mo 2       		&out OUT_BLE    &out OUT_24G   &out OUT_CHG   &out OUT_CHGD 

### NEW LAYER 1: MAC_FUNCTION_NUMPAD
//ESC       //f1                    //f2                    //f3                                //f4                    //f5                //f6            //f7            //f8               //f9         //f10       //f11                       //f12               //DEL                                              
&to 0       &kp C_BRIGHTNESS_DEC    &kp C_BRIGHTNESS_INC    &kp C_AC_DESKTOP_SHOW_ALL_WINDOWS   &kp  C_AC_MAC_LAUNCH    &kp C_AC_SEARCH     &kp C_AL_LOCK   &kp C_PREVIOUS  &kp C_PLAY_PAUSE   &kp C_NEXT   &kp C_MUTE  &kp C_VOLUME_DOWN           &kp C_VOLUME_UP     &kp DEL
&trans      &to 1                   &to 2                   &to 3                               &trans                  &trans              &kp KP_DIVIDE   &kp KP_MULTIPLY &kp KP_MINUS       &kp KP_PLUS  &trans      &long_press_bootloader 0 0  &trans              &trans
&trans      &td_bt_0 0              &td_bt_1 0              &td_bt_2 0                          &out OUT_24G            &kp DEL             &kp KP_N7       &kp KP_N8       &kp KP_N9          &kp BSPC     &trans      &trans                      &trans              &uc LG(LS(N4))
&trans      &kp LCTRL               &kp LGUI                &kp LALT                            &kp LSHFT               &trans              &kp TAB         &kp KP_N4       &kp KP_N5          &kp KP_N6    &kp RET     &trans                      &trans
&trans      &trans                  &trans                  &trans                              &trans                  &trans              &kp COMMA       &kp KP_N1       &kp KP_N2          &kp KP_N3    &kp KP_DOT                              &rshift_emoji RSHFT LC(LG(SPACE))
&kp LCTRL   &uc LCMD                &uc LALT                &kp KP_N0                                                   &uc RCMD            &trans          &kp HOME        &kp PG_UP          &kp PG_DN    &kp END
// RESERVED. DO NOT MODIFY
&none       &none                   &none                   &none                               &none

### DEFAULT LAYER 1: MAC_FUNCTION
layer_one  {
bindings = < 
&kp ESC     &kp C_BRIGHTNESS_DEC    &kp C_BRIGHTNESS_INC    &kp C_AC_DESKTOP_SHOW_ALL_WINDOWS   &kp  C_AC_MAC_LAUNCH    &kp C_AC_SEARCH     &kp C_AL_LOCK   &kp C_PREVIOUS  &kp C_PLAY_PAUSE    &kp C_NEXT  &kp C_MUTE  &kp C_VOLUME_DOWN   &kp C_VOLUME_UP     &kp DEL  
&trans      &bt_pair_0 0 0          &bt_pair_1 0 0          &bt_pair_2 0 0                      &bt_pair_3 0 0          &trans              &trans          &trans          &trans              &trans      &trans      &trans              &kp C_AC_SEARCH     &trans      
&trans      &trans                  &trans                  &trans                              &trans                  &trans              &trans          &trans          &kp INS             &trans      &trans      &trans              &trans              &uc LG(LS(N4))
&trans      &trans                  &trans                  &trans                              &trans                  &trans              &trans          &trans          &trans              &trans      &trans      &trans                      &trans                  
&trans      &trans                  &trans                  &trans                              &trans                  &trans              &trans          &trans          &trans              &trans      &trans                                  &uc LC(LG(SPACE))
&trans      &trans                  &trans                         &trans                                                                                                   &kp RCTRL           &trans        &kp HOME   &kp PG_UP   &kp PG_DN    &kp END  








//win
layer_two {
bindings = <
&kp ESC 	&kp F1 	               &kp F2 	                &kp F3 	                            &kp F4 	                &kp F5 	            &kp F6 	        &kp F7 	        &kp F8 	            &kp F9 	     &kp F10 	&kp F11 	         &kp F12 	         &kp DEL     
&kp GRAVE	&kp N1 	               &kp N2 	                &kp N3 	                            &kp N4 	                &kp N5 	            &kp N6 	        &kp N7 	        &kp N8 	            &kp N9 	     &kp N0     &kp MINUS 	         &kp EQUAL 	         &kp BSPC
&kp TAB 	&kp Q 	               &kp W                    &kp E 	                            &kp R 	                &kp T               &kp Y 	        &kp U 	        &kp I 	            &kp O 	     &kp P 		&kp LBKT 	         &kp RBKT 	         &kp BSLH 	 	
&kp CLCK 	&kp A 	               &kp S 	                &kp D 	                            &kp F 	                &kp G 	            &kp H 	        &kp J 	        &kp K 	            &kp L 	     &kp SEMI 	&kp SQT                      &kp RET
&kp LSHFT   &kp Z 	               &kp X 	                &kp C 	                            &kp V 	                &kp B 	            &kp N 	        &kp M 	        &kp COMMA           &kp DOT      &kp FSLH                                &kp RSHFT				
&kp LCTRL 	&kp LGUI               &kp LALT                      &kp SPACE              		                                                                            &kp RALT 	        &mo 3 		  &kp LEFT 	 &kp UP      &kp DOWN 	&kp RIGHT 	
//
&none       &out OUT_BLE           &out OUT_24G             &out OUT_CHG                        &out OUT_CHGD 
>;
};
//win
layer_three {
bindings = < 
//f1                    //f2                    //f3                                //f4                        //f5            //f6              //f7            //f8              //f9        //f10           //f11                         //f12                     
&trans  &kp C_BRIGHTNESS_DEC    &kp C_BRIGHTNESS_INC        &uc LG(TAB)                         &uc LG(E)               &kp C_AC_SEARCH     &uc LG(L)       &kp C_PREVIOUS  &kp C_PLAY_PAUSE    &kp C_NEXT  &kp C_MUTE  &kp C_VOLUME_DOWN           &kp C_VOLUME_UP      &trans   
&trans  &bt_pair_0 0 0          &bt_pair_1 0 0              &bt_pair_2 0 0                      &bt_pair_3 0 0          &trans              &trans          &trans          &trans              &trans      &trans      &trans                      &kp C_AL_CALC        &trans          
&trans  &trans                  &trans                      &trans                              &trans                  &trans              &trans          &trans          &kp INS             &trans      &trans      &trans                      &trans               &uc LG(LS(S))      
&trans  &trans                  &trans                      &trans                              &trans                  &trans              &trans          &trans          &trans              &trans      &trans      &trans                              &trans  
&trans  &trans                  &trans                      &trans                              &trans                  &trans              &trans          &trans          &trans              &trans      &trans                                          &uc LG(DOT) 
&trans  &trans                  &trans                           &trans                                                                                                     &kp RCTRL           &trans      &kp HOME    &kp PG_UP    &kp PG_DN   &kp END    
//
&none   &none                   &none                       &none                               &none
>;
};




};
```
---

## Layer Index 1: Functions and Numpad (`LAYER_FN-NUM`, `layer_fn-num`)

- **How Activated:** Hold **Caps Lock** (taps as `Esc`).
- **Description:** Turns the top alpha row into a horizontal number line (`1` to `9`) and standard mathematical operators, with navigation and control keys on the right hand. Left hand home row contains Callum-style one-shot modifiers.
- **Persistent layer selection:** The number-row **[1]**, **[2]**, and **[3]** keys use `TO(1)`, `TO(2)`, and `TO(3)` respectively to select `LAYER_FN-NUM`, `LAYER_SYM`, or `LAYER_NAV`.
- **Bluetooth profile controls — desired behavior:**

  | Key | Tap | Double-tap |
  | --- | --- | --- |
  | **[Q]** | Select Bluetooth profile 1. | Start discovery/pairing for Bluetooth profile 1. |
  | **[W]** | Select Bluetooth profile 2. | Start discovery/pairing for Bluetooth profile 2. |
  | **[E]** | Select Bluetooth profile 3. | Start discovery/pairing for Bluetooth profile 3. |

  The double-tap pairing actions are a desired tap-dance behavior and require
  implementation and timing validation in the ZMK keymap.

```text
  ┏━━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━┓
  ┃           ┃         ┃         ┃ MISSION ┃         ┃         ┃         ┃  SCREEN ┃ PLAY/   ┃  TOGGLE ┃         ┃         ┃         ┃        ┃
  ┃   TO(0)   ┃ Bright+ ┃ Bright- ┃ CONTORL ┃  FINDER ┃ ALT+SPC ┃ ACTIVTY ┃   SHOT  ┃  PAUSE  ┃   MIC   ┃   MUTE  ┃   Vol-  ┃  Vol+   ┃   DEL  ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┣━━━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━━━━┫
  ┃       ┃         ┃         ┃         ┃  2.4G   ┃         ┃ NUMPAD  ┃ NUMPAD  ┃ NUMPAD  ┃ NUMPAD  ┃         ┃         ┃         ┃            ┃
  ┃    ▼  ┃  TO(1)  ┃  TO(2)  ┃  TO(3)  ┃  PAIR   ┃    ▼    ┃    ÷    ┃    ×    ┃    −    ┃    +    ┃     ▼   ┃   Boot  ┃    ▼    ┃     ▼      ┃
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┣━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━━━━┫
  ┃          ┃         ┃         ┃         ┃         ┃         ┃ NUMPAD  ┃ NUMPAD  ┃ NUMPAD  ┃         ┃         ┃         ┃         ┃         ┃
  ┃     ▼    ┃TAP:BT1  ┃TAP:BT2  ┃TAP:BT3  ┃    ▼    ┃ DELETE  ┃    7    ┃    8    ┃    9    ┃BACKSPACE┃     ▼   ┃     ▼   ┃    ▼    ┃   Prt   ┃
  ┃          ┃DBL:PAIR1┃DBL:PAIR2┃DBL:PAIR3┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃  Scrn   ┃
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┣━━━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻━━━━━━━━━┫
  ┃  LAYER    ┃         ┃         ┃         ┃         ┃         ┃ NUMPAD  ┃ NUMPAD  ┃ NUMPAD  ┃ NUMPAD  ┃         ┃         ┃                  ┃
  ┃  ACTIVATE ┃  L_CTRL ┃  L_GUI  ┃  L_ALT  ┃ L_SHIFT ┃     ▼   ┃   TAB   ┃    4    ┃    5    ┃    6    ┃  ENTER  ┃     ▼   ┃         ▼        ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                  ┃
  ┣━━━━━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━━━━━━━━━━━━━━━━━┫
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃ NUMPAD  ┃ NUMPAD  ┃ NUMPAD  ┃ NUMPAD  ┃      TAP: Emoji-m       ┃
  ┃        ▼     ┃     ▼   ┃     ▼   ┃     ▼   ┃    ▼    ┃    ▼    ┃    ,    ┃    1    ┃    2    ┃    3    ┃    .    ┃     HOLD: R_SHIFT       ┃
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┣━━━━━━━━━━━┳━━┻━━━━━━━┳━┻━━━━━━━━━╋━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━╋━━━━━━━━━┻━━━━┳━━━━┻━━━━━┳━┳━┻━━━━━━┳━━━━━━━━━┳━━━━━━━━┫
  ┃           ┃          ┃           ┃                     NUMPAD                      ┃              ┃          ┃ ┃        ┃  PgUp   ┃        ┃
  ┃  L_CTRL   ┃  L_GUI   ┃   L_ALT   ┃                        0                        ┃    R_ALT     ┃     ▼    ┃ ┃  Home  ┣━━━━━━━━━┫   End  ┃
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃  PgDn   ┃        ┃
  ┗━━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┻━━━━━━━━━━┛ ┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━┛

```\

---

## Layer Index 2: Symbols (`LAYER_SYM`, `layer_sym`)
- **How Activated:** Hold **`H`** (tapped as `h`), or Hold **`G`** (tapped as `g`).
- **Description:** Accesses easy-access symbols layer. Note that the

```text
  ┏━━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━┓
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┃   TO(0)   ┃    _    ┃    _    ┃    _    ┃    _    ┃    _    ┃    _    ┃    _    ┃    _    ┃    _    ┃    _    ┃  CTRL+- ┃  CTRL+= ┃ CTRL+0 ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┣━━━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━━━━┫
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┃   _   ┃    _    ┃    _    ┃    -    ┃    -    ┃    _    ┃    _    ┃    _    ┃    _    ┃    _    ┃    -    ┃    -    ┃    -    ┃     _      ┃
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┣━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━━━━┫
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┃     `    ┃    !    ┃    @    ┃    #    ┃    $    ┃    %    ┃    ^    ┃    &    ┃    *    ┃    -    ┃    _    ┃    +    ┃    }    ┃    |    ┃
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┣━━━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻━━━━━━━━━┫
  ┃           ┃         ┃         ┃         ┃         ┃    *    ┃   *     ┃ 1TAP: ( ┃ 1TAP: { ┃ 1TAP: [ ┃         ┃         ┃                  ┃
  ┃     ~     ┃   CTRl  ┃    GUI  ┃   Alt   ┃  Shift  ┃  SYMBOL ┃ SYMBOL  ┃ 2TAP: ) ┃ 2TAP: } ┃ 2TAP: ] ┃    :    ┃    "    ┃        =         ┃
  ┃           ┃         ┃         ┃         ┃         ┃    *    ┃   *     ┃ 3TAP: ()┃ 3TAP: {}┃ 3TAP: []┃         ┃         ┃                  ┃
  ┣━━━━━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━━━━━━━━━━━━━━━━━┫
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┃   L_SHIFT    ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃    <    ┃    >    ┃    ?    ┃         R_SHIFT         ┃
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┣━━━━━━━━━━━┳━━┻━━━━━━━┳━┻━━━━━━━━━╋━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━╋━━━━━━━━━┻━━━━┳━━━━┻━━━━━┳━┳━┻━━━━━━┳━━━━━━━━━┳━━━━━━━━┫
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃    ↑    ┃        ┃
  ┃  L_CTRL   ┃  L_GUI   ┃   L_ALT   ┃                      SPACE                      ┃    R_ALT     ┃  R_CTRL  ┃ ┃    ←   ┣━━━━━━━━━┫   →    ┃
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃    ↓    ┃        ┃
  ┗━━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┻━━━━━━━━━━┛ ┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━┛
```

---

## Layer Index 3: Navigation (`LAYER_NAV`, reserved)

> **Specification status:** This layer is not implemented in the active
> keymap. The diagram below is a proposed target layout, not a description of
> current firmware behavior.

- **Desired activation:** Hold **Spacebar** (tapped as `Space`).
- **Target description:** Re-map the right hand to navigation keys (Arrows,
  Home, End, Page Up, Page Down) and the left hand to standard modifiers so
  text can be navigated and selected without leaving the home row.

```text
  ┏━━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━┓
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┃   TO(0)   ┃   F13   ┃   F14   ┃   F15   ┃   F16   ┃   F17   ┃   F18   ┃   F19   ┃   F20   ┃   F21   ┃   F22   ┃   F23   ┃   F24   ┃        ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┣━━━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━━━━┫
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┃       ┃         ┃         ┃    #    ┃   MW ↓  ┃         ┃         ┃         ┃         ┃         ┃  MBtn1  ┃ Mouse ↑ ┃  MBtn2  ┃            ┃
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┣━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━━━━┫
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃****
  ┃          ┃ Alt+F4  ┃ CTRL+W  ┃  MW ←   ┃  MW ↑   ┃  MW →   ┃ CTRL+Y  ┃   Dele  ┃    ↑    ┃  Bksp   ┃ Mouse ← ┃ Mouse ↓ ┃ Mouse → ┃         ┃
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┣━━━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻━━━━━━━━━┫
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                  ┃
  ┃           ┃   CTRl  ┃    GUI  ┃   Alt   ┃  Shift  ┃         ┃   Home  ┃    ←    ┃    ↓    ┃    →    ┃   End   ┃         ┃                  ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                  ┃
  ┣━━━━━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━━━━━━━━━━━━━━━━━┫
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┃              ┃         ┃ CTRL+X  ┃ CTRL+C  ┃ CTRL+V  ┃ CTRL+B  ┃  PgUp   ┃  PgDn   ┃         ┃         ┃         ┃                         ┃
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┣━━━━━━━━━━━┳━━┻━━━━━━━┳━┻━━━━━━━━━╋━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━╋━━━━━━━━━┻━━━━┳━━━━┻━━━━━┳━┳━┻━━━━━━┳━━━━━━━━━┳━━━━━━━━┫
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃         ┃        ┃
  ┃   MSPD1   ┃   MSPD2  ┃   MSPD3   ┃                   [Activator]                   ┃              ┃          ┃ ┃        ┣━━━━━━━━━┫        ┃
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃         ┃        ┃
  ┗━━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┻━━━━━━━━━━┛ ┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━┛
```
---

## Layer X  — TBD (`LAYER_FN`, `layer_fn`)

- **How Activated:** Hold **`fn`** (physical bottom-left corner key).
- **Description:** Restores standard `F1`–`F12` row outputs and preserves the
  existing factory controls, including bootloader access. It does not activate
  a Bypass layer.

```text
  ┏━━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━┓
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┣━━━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━━━━┫
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃   BOOT  ┃         ┃            ┃
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┣━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━━━━┫
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃ BYPASS  ┃
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┣━━━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻━━━━━━━━━┫
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                  ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                  ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                  ┃
  ┣━━━━━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━━━━━━━━━━━━━━━━━┫
  ┃              ┃    *    ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┃              ┃ACTIVATOR┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┃              ┃    *    ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┣━━━━━━━━━━━┳━━┻━━━━━━━┳━┻━━━━━━━━━╋━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━╋━━━━━━━━━┻━━━━┳━━━━┻━━━━━┳━┳━┻━━━━━━┳━━━━━━━━━┳━━━━━━━━┫
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃         ┃        ┃
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┣━━━━━━━━━┫        ┃
  ┃           ┃          ┃           ┃                                                 ┃              ┃          ┃ ┃        ┃         ┃        ┃
  ┗━━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┻━━━━━━━━━━┛ ┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━┛

```

---

## Deferred — Passthrough / Bypass layer

> **Not assigned or implemented.** This legacy Kanata concept has no ZMK node,
> index, or activation binding in the active B1 Pro keymap. It is deliberately
> outside the current specification.

- **Historical target only:** The legacy diagram below is retained for design
  reference. It must not be read as a current key binding or as an assigned
  ZMK layer.

```text
  ┏━━━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━┓
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┃    Esc    ┃   F1    ┃   F2    ┃   F3    ┃   F4    ┃   F5    ┃   F6    ┃    F7   ┃    F8   ┃    F9   ┃   F10   ┃   F11   ┃   F12   ┃  DEL   ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃        ┃
  ┣━━━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━┳━━━┻━━━━━━━━┫
  ┃   ~   ┃    !    ┃    @    ┃    #    ┃    $    ┃    %    ┃    ^    ┃    *    ┃    -    ┃    (    ┃    )    ┃    _    ┃    +    ┃            ┃
  ┃   `   ┃    1    ┃    2    ┃    3    ┃    4    ┃    5    ┃    6    ┃    7    ┃    8    ┃    9    ┃    0    ┃    -    ┃    =    ┃    BKSP    ┃
  ┃       ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃            ┃
  ┣━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━━━━┫
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃    {    ┃    }    ┃    |    ┃
  ┃   TAB    ┃    Q    ┃    W    ┃    E    ┃    R    ┃    T    ┃    Y    ┃    U    ┃    I    ┃    O    ┃    P    ┃    [    ┃    ]    ┃    \    ┃
  ┃          ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃
  ┣━━━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻┳━━━━━━━━┻━━━━━━━━━┫
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃    :    ┃    "    ┃                  ┃
  ┃   CAPS    ┃     A   ┃     S   ┃     D   ┃    F    ┃    G    ┃    H    ┃    J    ┃    K    ┃    L    ┃    ;    ┃    '    ┃      RETURN      ┃
  ┃           ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                  ┃
  ┣━━━━━━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━┳━━━━━━┻━━━━━━━━━━━━━━━━━━┫
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃    <    ┃    >    ┃    ?    ┃                         ┃
  ┃   L_SHIFT    ┃    Z    ┃    X    ┃    C    ┃    V    ┃    B    ┃   N     ┃    M    ┃    ,    ┃    .    ┃    /    ┃        R_SHIFT          ┃
  ┃              ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃         ┃                         ┃
  ┣━━━━━━━━━━━┳━━┻━━━━━━━┳━┻━━━━━━━━━╋━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━╋━━━━━━━━━┻━━━━┳━━━━┻━━━━━┳━┳━┻━━━━━━┳━━━━━━━━━┳━━━━━━━━┫
  ┃           ┃          ┃           ┃                                                 ┃              ┃TAP: TO(0)┃ ┃        ┃    ↑    ┃        ┃
  ┃  L_CTRL   ┃  L_GUI   ┃   L_ALT   ┃                      SPACE                      ┃    R_ALT     ┃HOLD:MO(1)┃ ┃    ←   ┣━━━━━━━━━┫   →    ┃
  ┃           ┃          ┃           ┃                                                 ┃              ┃T+H:R_CTRL┃ ┃        ┃    ↓    ┃        ┃
  ┗━━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┻━━━━━━━━━━┛ ┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━┛
```
