#pragma once

#include "layers.h"

enum custom_keycodes {
    LANG_SW = SAFE_RANGE,
    NUMWORD,
    REP,
};

#define LTNAV LT(_NAV, KC_T)
#define SYM_SPC LT(_SYM, KC_SPC)
#define OS_SFT OSM(MOD_LSFT)
#define CTL_LFT MT(MOD_LCTL, KC_LEFT)
#define ALT_RGT MT(MOD_LALT, KC_RGHT)
#define HYPR_HD HYPR_T(KC_NO) // hold-only Hyper
#define SCRNSHT G(S(C(KC_4)))  // region screenshot to clipboard
#define MON_TOG G(C(KC_RGHT))
#define MON_MOV G(C(S(KC_RGHT)))
#define OS_LOCK G(C(KC_Q)) // macOS Lock Screen
