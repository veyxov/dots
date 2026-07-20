#pragma once

// combos
#define COMBO_TERM 20
#define COMBO_VARIABLE_LEN

#define ADAPTIVE_TERM 200

// disable "quick tap", no need to repeat when we have a "repeat key"
#define QUICK_TAP_TERM 0

// resolve mod-tap as hold immediately on next keypress, but only for specific
// keys (see get_hold_on_other_key_press in keymap.c) — global HOLD_ON_OTHER_KEY_PRESS
// also hit LTNAV (T is a layer-tap), so typing "t" fast followed by any
// letter resolved as a NAV-hold instead of the letter T.
#define HOLD_ON_OTHER_KEY_PRESS_PER_KEY
