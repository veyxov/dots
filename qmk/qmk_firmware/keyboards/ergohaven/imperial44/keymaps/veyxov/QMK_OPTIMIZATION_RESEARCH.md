# QMK optimization research

Research date: 2026-09-26. Sources are the official QMK documentation and source. The local QMK checkout used to verify implementation details is `a738fad372c1e72e10c47f560c8d167d233416ad` (2026-07-11).

## Recommended actions

### 1. Keep the current one-shot NUM design

The current combination is the native QMK mechanism for the requested interaction:

- `OSL(_NUM)` activates NUM for one key.
- `ONESHOT_TAP_TOGGLE 2` makes a double tap lock the one-shot layer.
- `QUICK_TAP_TERM_PER_KEY` plus a nonzero return for `OSL(_NUM)` is necessary because `QUICK_TAP_TERM 0` otherwise prevents tapping-toggle detection.

QMK documents that `ONESHOT_TAP_TOGGLE` applies to both one-shot modifiers and layers, and that Quick Tap affects One Shot Tap Toggle. The current `get_quick_tap_term()` implementation preserves disabled quick tap for other dual-role keys while enabling it only for NUM and one-shot Shift. This is already the smallest stock-QMK solution for the current UX.

Sources: [One Shot Keys](https://github.com/qmk/qmk_firmware/blob/master/docs/one_shot_keys.md), [Quick Tap Term](https://github.com/qmk/qmk_firmware/blob/master/docs/tap_hold.md#quick-tap-term), [one-shot implementation](https://github.com/qmk/qmk_firmware/blob/master/quantum/action.c).

### 2. Keep the explicit NUM Escape combo and avoid a broad reference layer

`COMBO_REF_LAYER(_NUM, _BASE)` makes combo detection on NUM read keycodes from BASE. On this layout, that turns the physical media positions back into `/`, `?`, and `'` for combo processing, which can delay or consume the consumer controls. The explicit NUM chord `KC_4 + KC_0 -> KC_ESC` preserves the physical S+N Escape gesture without remapping every NUM key through BASE.

QMK defines a combo reference layer as the layer from which combo keycodes are looked up. It is useful when whole layouts should share positional combos; it is too broad when a utility layer intentionally replaces those positions. If future layers reuse the same keycodes and cause accidental combos, use `combo_should_trigger()` to gate only the affected combo rather than remapping the entire layer.

Sources: [Combo reference layers](https://github.com/qmk/qmk_firmware/blob/master/docs/features/combo.md#layer-independent-combos), [combo trigger hook](https://github.com/qmk/qmk_firmware/blob/master/docs/features/combo.md#generic-hook-to-disallow-a-combo-activation).

### 3. Keep the consumer media keycodes

`KC_MUTE`, `KC_VOLD`, `KC_VOLU`, `KC_BRID`, and `KC_BRIU` are QMK consumer keycodes and are explicitly listed as supported on macOS. `EXTRAKEY_ENABLE = yes` is required for QMK to emit the system and consumer HID reports and is already enabled.

Keep `KC_BRID`/`KC_BRIU`. The older `KC_BRMD`/`KC_BRMU` names are aliases for the basic keyboard usages Scroll Lock and Pause. QMK labels those aliases as macOS brightness controls, but the dedicated consumer usages are clearer and portable, and they are the controls confirmed working here.

Sources: [QMK keycodes and OS support](https://github.com/qmk/qmk_firmware/blob/master/docs/keycodes.md), [keycode aliases in source](https://github.com/qmk/qmk_firmware/blob/master/quantum/keycodes.h), [Extra Keys requirement](https://github.com/qmk/qmk_firmware/blob/master/docs/faq_misc.md#media-keys-arent-working).

### 4. Replace four custom combo wrappers with native modified results

This is the clearest safe code reduction. QMK combos accept 16-bit modified keycodes directly; the official example uses `C(KC_Z)`. Therefore these combo results can be direct:

```c
COMB(ae_bsp, A(KC_BSPC), KC_A, KC_E)
COMB(gl_cpy, G(KC_C), KC_G, KC_L)
COMB(lc_pst, G(KC_V), KC_L, KC_C)
COMB(glc_all, G(KC_A), KC_G, KC_L, KC_C)
```

After that change, remove `CG_WBSPC`, `CG_COPY`, `CG_PASTE`, and `CG_SELALL` from `enum custom_keycodes`, and remove `tap_macros[]` plus its loop from `features.c`. This replaces custom event interception with QMK’s normal combo press/release handling and removes code and state without changing the shortcuts.

Source: [QMK combo dictionary example](https://github.com/qmk/qmk_firmware/blob/master/docs/features/combo.md#dictionary-management).

### 5. Keep custom NUMWORD behavior

The `NUMWORD` behavior is a persistent NUM layer with an allowlist that remains active for numeric entry and exits on unrelated keys. Native Layer Lock can lock `OSL`, `LT`, `MO`, `TT`, or `LM` layers, but it does not provide an allowlist that automatically exits after a nonnumeric key. Replacing NUMWORD with Layer Lock would change behavior or retain custom filtering while adding another feature.

Native Layer Lock is useful if the desired UX changes to “hold/tap a layer key, then press a separate lock key.” It requires `LAYER_LOCK_ENABLE = yes` and `QK_LLCK`. It is not a simpler replacement for the current single-tap/double-tap NUM key.

Source: [Layer Lock](https://github.com/qmk/qmk_firmware/blob/master/docs/features/layer_lock.md).

### 6. Preserve both operations when Escape cancels locked OSL

The current Escape path calls both `reset_oneshot_layer()` and `layer_off(_NUM)`. Keep both. In current QMK source, `reset_oneshot_layer()` clears one-shot bookkeeping and invokes the callback, but does not turn the layer off. `layer_off()` performs the separate layer-state change. Removing either call can leave stale state or leave NUM active.

Source: [`reset_oneshot_layer()` implementation](https://github.com/qmk/qmk_firmware/blob/master/quantum/action_util.c), [OSL toggle implementation](https://github.com/qmk/qmk_firmware/blob/master/quantum/action.c).

### 7. Flash both halves after behavior changes

The Imperial44 has a controller in each half and can use either connected side as the primary side. Both halves should carry the same firmware after keymap or split-protocol changes. The board already enables `SPLIT_LAYER_STATE_ENABLE`, so active layers are synchronized for the secondary OLED; `SPLIT_MODS_ENABLE` is also enabled when OLED support is built. `SPLIT_TRANSPORT_MIRROR` is unnecessary because no secondary-side feature needs a mirrored matrix.

QMK explicitly requires both sides to be flashed for split configuration and synchronized RGB layer changes. Keeping both halves on the same firmware also avoids protocol/version mismatch when the USB side changes.

Sources: [Split Keyboard](https://github.com/qmk/qmk_firmware/blob/master/docs/features/split_keyboard.md), [RGB Lighting Layers](https://github.com/qmk/qmk_firmware/blob/master/docs/features/rgblight.md#defining-lighting-layers).

## Low-priority cleanup

- When touching the dual-role normalization in `process_record_user()`, prefer `QK_MOD_TAP_GET_TAP_KEYCODE()` and `QK_LAYER_TAP_GET_TAP_KEYCODE()` over `keycode &= QK_BASIC_MAX`. The current mask works for basic tap keycodes, but the named accessors make the encoding assumption explicit.
- Do not enable `LAYER_LOCK_ENABLE`, `COMBO_SHOULD_TRIGGER`, or additional split synchronization flags without a concrete behavior that needs them. Each adds firmware code or split traffic, while the current configuration already handles the confirmed use cases.

## Priority order

1. Convert the four shortcut combos to native modified results and remove their wrappers.
2. Leave the proven NUM one-shot, media, Escape, and split synchronization behavior intact.
3. Apply the named tap-keycode accessors only as a readability cleanup during related work.
