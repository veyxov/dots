#pragma once

// mouse
#define MOUSEKEY_DELAY       0
#define MOUSEKEY_INTERVAL    16
#define MOUSEKEY_WHEEL_DELAY 0
#define MOUSEKEY_MAX_SPEED   6
#define MOUSEKEY_TIME_TO_MAX 64

// combos
#define COMBO_TERM 20
#define COMBO_VARIABLE_LEN

#define ADAPTIVE_TERM 200

// disable "quick tap", no need to repeat when we have a "repeat key"
#define QUICK_TAP_TERM 0

// resolve mod-tap as hold immediately on next keypress (fast alt/ctrl rolls
// like Alt+M were resolving as tap+letter since release came before TAPPING_TERM)
#define HOLD_ON_OTHER_KEY_PRESS
