#pragma once

#include QMK_KEYBOARD_H

bool process_record_features(uint16_t keycode, keyrecord_t *record);
bool remember_last_key_features(uint16_t keycode);
