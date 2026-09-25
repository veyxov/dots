#pragma once

#define COMBO_TERM 20
#define COMBO_VARIABLE_LEN

// Keep custom Shift behavior on both base layers and their utility layers.
#define CUSTOM_SHIFT_KEYS_LAYER_MASK 0x1F

#define ADAPTIVE_TERM 200

#define QUICK_TAP_TERM 0 // REP covers repeats, no need for quick-tap

// per-key so LTNAV (T) isn't swept up — see get_hold_on_other_key_press in features.c
#define HOLD_ON_OTHER_KEY_PRESS_PER_KEY
