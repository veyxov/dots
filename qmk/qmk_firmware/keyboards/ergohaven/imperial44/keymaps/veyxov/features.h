#pragma once

#include QMK_KEYBOARD_H

void toggle_lg(void);
void enable_num_word(void);
bool process_record_num_word(uint16_t keycode, const keyrecord_t *record);
bool process_record_features(uint16_t keycode, keyrecord_t *record);
bool process_s_mous(keyrecord_t *record);
void matrix_scan_s_mous(void);
void leader_end_features(void);
bool remember_last_key_features(uint16_t keycode);
