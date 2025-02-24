// --------------------------------------------------------
// Globally store information about the previous key press.
// --------------------------------------------------------
static uint8_t  prior_saved_mods = 0;
static uint16_t prior_keycode    = KC_NO;
static uint32_t prior_keydown    = 0;

// ---------------------
// On key press/release:
// ---------------------
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
                case KC_A: // A, -> AU
                    switch (keycode) {
                        case KC_COMM:
                            return_state = false;
                            second       = KC_U;
                            // Because "," is a gobbled letter,
                            // switch the keycode to be U.
                            // Otherwise, "A," will produce "AU,".
                            keycode = KC_U;
                            break;
                    }
                    break;
                case KC_B: // BD -> BL
                    switch (keycode) {
                        case KC_D:
                            return_state = false;
                            second       = KC_L;
                            // Because D is a gobbled letter,
                            // switch the keycode to be L.
                            // Otherwise, BD will produce BLD.
                            keycode = KC_L;
                            break;
                    }
                    break;
                case KC_C: // CW -> CD
                    switch (keycode) {
                        case KC_L:
                            // Forces "CL" to be "Cl" even though
                            // it isn't technically adaptive.
                            return_state = false;
                            second       = KC_L;
                            break;
                        case KC_W:
                            return_state = false;
                            second       = KC_D;
                            break;
                    }
                    break;
                case KC_D: // DB -> LB
                    switch (keycode) {
                        case KC_B:
                            return_state = false;
                            first        = KC_L;
                            second       = KC_B;
                            break;
                        default:
                            tap_code(prior_keycode);
                    }
                    break;
                case KC_F: // FX -> FR
                    switch (keycode) {
                        case KC_X:
                            return_state = false;
                            second       = KC_R;
                            break;
                    }
                    break;
                case KC_G: // GM -> GL
                case KC_V: // VM -> VL
                    switch (keycode) {
                        case KC_M:
                            return_state = false;
                            second       = KC_L;
                            break;
                    }
                    break;
                case KC_L: // LF -> LS
                    switch (keycode) {
                        case KC_F:
                            return_state = false;
                            second       = KC_S;
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
                case KC_W: // WC -> WR
                    switch (keycode) {
                        case KC_C:
                            return_state = false;
                            second       = KC_R;
                            break;
                    }
                    break;
                case KC_COMM: // ,A -> UA
                    switch (keycode) {
                        case KC_A:
                            return_state = false;
                            first        = KC_U;
                            second       = KC_A;
                            break;
                        default:
                            // Manually handle KC_COMM -> KC_PIPE.
                            if (prior_saved_mods & MOD_MASK_SHIFT) {
                                tap_code16(KC_PIPE);
                            } else {
                                tap_code(prior_keycode);
                            }
                    }
                    break;
                case KC_DOT: // .: -> .com
                    switch (keycode) {
                        case KC_COLN:
                            send_string("com");
                            return false;
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
            case KC_D:
            case KC_P:
            case KC_COMM:
                return_state = false;
                break;
        }
        prior_saved_mods = saved_mods;
        prior_keycode    = keycode;
        prior_keydown    = timer_read32();
    }
    return return_state;
}

// ---------------------------------
// Every time the matrix is scanned:
// ---------------------------------
void matrix_adaptive_user(void) {
    if (timer_elapsed32(prior_keydown) >= ADAPTIVE_TERM) {
        switch (prior_keycode) {
            // If `ADAPTIVE_TERM` has elapsed,
            // with no other key presses,
            // send our leading key.
            case KC_D:
            case KC_P:
                set_mods(prior_saved_mods);
                tap_code(prior_keycode);
                clear_mods();
                break;
            case KC_COMM:
                // Manually handle KC_COMM -> KC_PIPE.
                if (prior_saved_mods & MOD_MASK_SHIFT) {
                    tap_code16(KC_PIPE);
                } else {
                    set_mods(prior_saved_mods);
                    tap_code(KC_COMM);
                }
                break;
        }
        prior_keydown = timer_read32();
        prior_keycode = KC_NO;
    }
}
