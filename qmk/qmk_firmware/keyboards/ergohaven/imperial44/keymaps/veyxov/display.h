#pragma once

#include QMK_KEYBOARD_H

void display_init(void);
void display_layer_state_set(layer_state_t state);
void display_sync(void);

#ifdef OLED_ENABLE
oled_rotation_t display_oled_init(oled_rotation_t rotation);
bool display_oled_task(void);
#endif
