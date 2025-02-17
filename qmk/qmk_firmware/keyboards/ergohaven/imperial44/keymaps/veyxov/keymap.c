#include QMK_KEYBOARD_H
#ifdef CONSOLE_ENABLE
#include "print.h"
#endif


#define _BASE 0
#define _NAV 1
#define _MOUSE 2

#define LTNAV LT(_NAV, KC_T)

enum custom_keycodes {
    S_MOUS = SAFE_RANGE,
};


bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    static bool shift_triggered = false;
    static uint16_t shift_timer = 0;

    #ifdef CONSOLE_ENABLE
        const bool is_combo = record->event.type == COMBO_EVENT;
        uprintf("0x%04X,%u,%u,%u,%b,0x%02X,0x%02X,%u\n",
             keycode,
             is_combo ? 254 : record->event.key.row,
             is_combo ? 254 : record->event.key.col,
             get_highest_layer(layer_state),
             record->event.pressed,
             get_mods(),
             get_oneshot_mods(),
             record->tap.count
             );
    #endif

    switch (keycode) {
        case S_MOUS:
            if (record->event.pressed) {
                shift_timer = timer_read();
                register_code(KC_LSFT);
                shift_triggered = true;
            } else {
                if (shift_triggered && (timer_elapsed(shift_timer) < TAPPING_TERM)) {
                    // If released quickly, trigger one-shot shift
                    unregister_code(KC_LSFT);
                    set_oneshot_mods(MOD_LSFT);
                } else {
                    // If it was held, disable the mouse layer
                    unregister_code(KC_LSFT);
                    layer_off(_MOUSE);
                }
                shift_triggered = false;
            }
            return false;
    }

    // Add this outside the switch statement
    if (shift_triggered && timer_elapsed(shift_timer) > TAPPING_TERM) {
        unregister_code(KC_LSFT);  // Unregister shift before enabling mouse layer
        layer_on(_MOUSE);
        shift_triggered = false;
    }

    return true;
}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        KC_Q,  KC_J,   KC_F,   KC_M,   KC_P,   KC_V,                          XXXXXXX,KC_DOT, KC_SLASH, S(KC_SLSH),  KC_QUOT,   S(KC_MINS),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       KC_LALT,  KC_R,   KC_S,   KC_N,   KC_D,   KC_W,                       KC_COMM,   KC_A,   KC_E,   KC_I,   KC_H , QK_REP,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX, KC_X,   KC_G,   KC_L,   KC_C,   KC_B,                       KC_MINS,   KC_U,   KC_O,  KC_Y,  KC_K, KC_RSFT,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                S_MOUS, LTNAV, XXXXXXX, QK_BOOTLOADER,    XXXXXXX, QK_REP, KC_SPC,   XXXXXXX
    ),
    [_NAV] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,LGUI(KC_1),LGUI(KC_2),LGUI(KC_3),LGUI(KC_4), XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX,XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,KC_LEFT,KC_DOWN,KC_UP,  KC_RGHT, XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                XXXXXXX,XXXXXXX,XXXXXXX, XXXXXXX,         XXXXXXX,XXXXXXX,XXXXXXX,XXXXXXX
    ),
    [_MOUSE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        MS_ACL0, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,XXXXXXX,MS_WHLD,MS_WHLU,XXXXXXX, XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_ACL1,XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 MS_WHLL,MS_LEFT,MS_DOWN,MS_UP,  MS_RGHT, MS_WHLR,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_ACL2, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                XXXXXXX,XXXXXXX,XXXXXXX, XXXXXXX,         XXXXXXX,MS_BTN2,MS_BTN1,XXXXXXX
    ),
};


const uint16_t PROGMEM z[] = {KC_U, KC_Y, COMBO_END};
const uint16_t PROGMEM qu[] = {KC_F, KC_M, COMBO_END};

const uint16_t PROGMEM ei_enter[] = {KC_E, KC_I, COMBO_END};
const uint16_t PROGMEM sn_esc[] = {KC_S, KC_N, COMBO_END};
const uint16_t PROGMEM nd_tab[] = {KC_N, KC_D, COMBO_END};
const uint16_t PROGMEM ae_bsp[] = {KC_A, KC_E, COMBO_END};

const uint16_t PROGMEM gl_cpy[] = {KC_G, KC_L, COMBO_END};
const uint16_t PROGMEM lc_pst[] = {KC_L, KC_C, COMBO_END};
const uint16_t PROGMEM glc_all[] = {KC_G, KC_L, KC_C, COMBO_END};

const uint16_t PROGMEM aei_scol[] = {KC_A, KC_E, KC_I, COMBO_END};
const uint16_t PROGMEM ai_col[] = {KC_A, KC_I, COMBO_END};
const uint16_t PROGMEM sd_qt[] = {KC_S, KC_D, COMBO_END};

const uint16_t PROGMEM sqo[] = {LTNAV, KC_S, COMBO_END};
const uint16_t PROGMEM sqc[] = {LTNAV, KC_N, COMBO_END};
const uint16_t PROGMEM a[] = {LTNAV, KC_M, COMBO_END};
const uint16_t PROGMEM b[] = {LTNAV, KC_F, COMBO_END};
const uint16_t PROGMEM c[] = {LTNAV, KC_G, COMBO_END};
const uint16_t PROGMEM d[] = {LTNAV, KC_L, COMBO_END};
const uint16_t PROGMEM e[] = {LTNAV, KC_D, COMBO_END};
const uint16_t PROGMEM f[] = {LTNAV, KC_W, COMBO_END};
const uint16_t PROGMEM g[] = {LTNAV, KC_R, COMBO_END};
const uint16_t PROGMEM h[] = {LTNAV, KC_C, COMBO_END};
const uint16_t PROGMEM j[] = {LTNAV, KC_P, COMBO_END};
const uint16_t PROGMEM k[] = {LTNAV, KC_E, COMBO_END};
const uint16_t PROGMEM l[] = {LTNAV, KC_I, COMBO_END};
const uint16_t PROGMEM m[] = {LTNAV, KC_A, COMBO_END};
const uint16_t PROGMEM n[] = {LTNAV, KC_H, COMBO_END};
const uint16_t PROGMEM o[] = {LTNAV, KC_U, COMBO_END};
const uint16_t PROGMEM p[] = {LTNAV, KC_J, COMBO_END};

const uint16_t PROGMEM q[] = {KC_SPC, KC_A, COMBO_END};
const uint16_t PROGMEM r[] = {KC_SPC, KC_E, COMBO_END};
const uint16_t PROGMEM s[] = {KC_SPC, KC_I, COMBO_END};
const uint16_t PROGMEM t[] = {KC_SPC, KC_H, COMBO_END};
const uint16_t PROGMEM u[] = {KC_SPC, KC_COMM, COMBO_END};
const uint16_t PROGMEM v[] = {KC_SPC, KC_DOT, COMBO_END};
const uint16_t PROGMEM w[] = {KC_SPC, KC_SLSH, COMBO_END};
const uint16_t PROGMEM x[] = {KC_SPC, S(KC_SLSH), COMBO_END};
const uint16_t PROGMEM y[] = {KC_SPC, KC_QUOT, COMBO_END};
const uint16_t PROGMEM zz[] = {KC_SPC, KC_H, COMBO_END};

const uint16_t PROGMEM brah1[] = {KC_SPC, KC_N, COMBO_END};
const uint16_t PROGMEM brah2[] = {KC_SPC, KC_D, COMBO_END};
const uint16_t PROGMEM brah3[] = {KC_SPC, KC_S, COMBO_END};
const uint16_t PROGMEM brah4[] = {KC_SPC, KC_R, COMBO_END};
const uint16_t PROGMEM brah5[] = {KC_SPC, KC_C, COMBO_END};

combo_t key_combos[] = {
    COMBO(z, KC_Z),
    COMBO(qu, KC_Q),
    COMBO(ei_enter, KC_ENT),
    COMBO(sn_esc, KC_ESC),
    COMBO(nd_tab, KC_TAB),
    COMBO(ae_bsp, KC_BSPC),
    COMBO(gl_cpy, C(KC_C)),
    COMBO(lc_pst, C(KC_V)),
    COMBO(glc_all, C(KC_A)),
    COMBO(aei_scol, KC_SCLN),
    COMBO(ai_col, S(KC_SCLN)),
    COMBO(sd_qt, S(KC_QUOT)),

    COMBO(sqo, S(KC_LBRC)),
    COMBO(sqc, S(KC_RBRC)),
    COMBO(a, S(KC_8)),
    COMBO(b, S(KC_EQL)),
    COMBO(c, S(KC_COMM)),
    COMBO(d, S(KC_DOT)),
    COMBO(e, S(KC_MINS)),
    COMBO(f, KC_BSLS),
    COMBO(g, S(KC_BSLS)),
    COMBO(h, S(KC_5)),
    COMBO(j, S(KC_1)),
    COMBO(k, KC_1),
    COMBO(l, KC_5),
    COMBO(m, KC_3),
    COMBO(n, KC_7),
    COMBO(o, KC_9),
    COMBO(p, S(KC_GRV)),

    COMBO(q, S(KC_SLSH)),
    COMBO(r, KC_LBRC),
    COMBO(s, KC_RBRC),
    COMBO(t, S(KC_MINS)),
    COMBO(u, KC_GRV),
    COMBO(v, S(KC_3)),
    COMBO(w, S(KC_2)),
    COMBO(x, S(KC_6)),
    COMBO(y, KC_GRV),
    COMBO(zz, KC_GRV),

    COMBO(brah1, KC_0),
    COMBO(brah2, KC_2),
    COMBO(brah3, KC_4),
    COMBO(brah4, KC_6),
    COMBO(brah5, KC_8),
};

const key_override_t delete_key_override = ko_make_basic(MOD_MASK_SHIFT, KC_BSPC, KC_DEL);

// This globally defines all key overrides to be used
const key_override_t *key_overrides[] = {
	&delete_key_override
};
