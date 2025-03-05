static uint8_t  prior_saved_mods = 0;
static uint16_t prior_keycode    = KC_NO;
static uint32_t prior_keydown    = 0;

bool process_adaptive_user(uint16_t keycode, const keyrecord_t *record) {
    bool return_state = true;

    if (record->event.pressed) {
        uint8_t saved_mods = get_mods();
        if (saved_mods & MOD_MASK_CAG) {
            // Don't do anything if mods are present.
            return true;
        }
        if (timer_elapsed32(prior_keydown) < ADAPTIVE_TERM) {
            return_state    = true;
            uint16_t first  = KC_NO;
            uint16_t second = KC_NO;
            clear_mods();

            switch (prior_keycode) {
                case KC_V: // VM -> VL
                    switch (keycode) {
                        case KC_M:
                            return_state = false;
                            second       = KC_L;
                            break;
                    }
                    break;
                case KC_M: // MV -> MB
                    switch (keycode) {
                        case KC_V:
                            return_state = false;
                            second       = KC_B;
                            break;
                    }
                    break;
                case KC_P:
                    switch (keycode) {
                        case KC_V: // PV -> LV
                            return_state = false;
                            first        = KC_L;
                            second       = KC_V;
                            break;
                        case KC_M: // PM -> PL
                            return_state = false;
                            first        = KC_P;
                            second       = KC_L;
                            break;
                        default:
                            tap_code(prior_keycode);
                    }
                    break;
                case KC_L: // LC -> LP
                    switch (keycode) {
                        case KC_C:
                            return_state = false;
                            second       = KC_P;
                            break;
                    }
                    break;
                case KC_G: // GX -> GS
                    switch (keycode) {
                        case KC_X:
                            return_state = false;
                            second       = KC_S;
                            break;
                    }
                    break;
                case KC_U: // UH -> UA
                    switch (keycode) {
                        case KC_H:
                            return_state = false;
                            second       = KC_A;
                            break;
                    }
                    break;
                case KC_A:
                    switch (keycode) {
                        case KC_H: // AH -> AU
                            return_state = false;
                            second = KC_U;
                            break;
                    }
                    break;

                case KC_E:
                    switch (keycode) {
                        case KC_H: // EH -> EO
                            return_state = false;
                            second = KC_O;
                            break;
                    }
                    break;
            }

            if (return_state) {
                set_mods(saved_mods);
            } else {
                set_mods(prior_saved_mods);
                tap_code(first);
                clear_mods();
                tap_code(second);
            }
        }
        switch (keycode) {
            // If pressed, gobble these keys until
            // `ADAPTIVE_TERM` (handled in `matrix_adaptive_user`)
            // or another keypress (handled in `case`s above)
            case KC_P:
                return_state = false;
                break;
        }
        prior_saved_mods = saved_mods;
        prior_keycode    = keycode;
        prior_keydown    = timer_read32();
    }
    return return_state;
}
void matrix_adaptive_user(void) {
    if (timer_elapsed32(prior_keydown) >= ADAPTIVE_TERM) {
        switch (prior_keycode) {
            // If `ADAPTIVE_TERM` has elapsed,
            // with no other key presses
            case KC_P:
                set_mods(prior_saved_mods);
                tap_code(prior_keycode);
                clear_mods();
                break;
        }
        prior_keydown = timer_read32();
        prior_keycode = KC_NO;
    }
}
