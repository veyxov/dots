#pragma once

#include "layers.h"

enum custom_keycodes {
    S_MOUS = SAFE_RANGE,
    NUMWORD,
    CRYLTG,
    REP,
    SN_ESC_CRYL,
};

#define LTNAV LT(_NAV, KC_T)
#define SYM_SPC LT(_SYM, KC_SPC)
#define MON_TOG G(C(KC_RGHT))
#define MON_MOV G(C(S(KC_RGHT)))
