#pragma once

#include QMK_KEYBOARD_H

void toggle_lg(void);
bool process_record_features(uint16_t keycode, keyrecord_t *record);
bool process_s_mous(keyrecord_t *record);
void matrix_scan_s_mous(void);
bool remember_last_key_features(uint16_t keycode);
