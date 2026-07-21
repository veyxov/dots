#pragma once

#include "layers.h"

enum custom_keycodes {
    LANG_SW = SAFE_RANGE,
    NUMWORD,
    REP,
    CG_WBSPC,
    CG_COPY,
    CG_PASTE,
    CG_SELALL,
};

#define LTNAV LT(_NAV, KC_T)
#define SYM_SPC LT(_SYM, KC_SPC)
#define MON_TOG G(C(KC_RGHT))
#define MON_MOV G(C(S(KC_RGHT)))
#define OS_LOCK G(C(KC_Q)) // macOS native Lock Screen (was LGUI(KC_L), clashed w/ browser addr bar)
