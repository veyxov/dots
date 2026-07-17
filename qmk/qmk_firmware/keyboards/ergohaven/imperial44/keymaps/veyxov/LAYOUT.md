# veyxov keymap — Imperial44 (Hands Down Gold–derived)

Ergohaven Imperial44: split, 3x6 per hand + 4 thumb keys per hand (44 keys total), RP2040.
Base alpha layout is [Hands Down Gold](https://sites.google.com/alanreiser.com/handsdown/home) ("Neu", T-on-thumb variant), with a handful of positions swapped and home-row mods replaced by thumb-cluster mods. Reference implementation used for comparison: [neonfuzz/HandsDown](https://github.com/neonfuzz/HandsDown), `layouts/community/hands_down_gold/hdgold.c` + `keyboards/ergodox_ez/keymaps/hands_down_gold/keymap.c`.

## BASE layer

```
┌─────┬─────┬─────┬─────┬─────┐         ┌─────┬─────┬─────┬─────┬─────┐
│OSL/N│  J  │  F  │  M  │  P  │  V        X    │  .  │  /  │  ?  │  '  │  _  │
├─────┼─────┼─────┼─────┼─────┤         ├─────┼─────┼─────┼─────┼─────┤
│ DEL │  R  │  S  │  N  │  D  │  W        ,    │  A  │  E  │  I  │  H  │  :  │
├─────┼─────┼─────┼─────┼─────┤         ├─────┼─────┼─────┼─────┼─────┤
│GUI/F│  X  │  G  │  L  │  C  │  B        -    │  U  │  O  │  Y  │  K  │CRYL │
└─────┴─────┴─────┼─────┼─────┼─────┐ ┌─────┼─────┼─────┴─────┴─────┴─────┘
                   │ REP │ T/N │ Sh/M│ TAB │ │⌘Lock│←/Ct │SPC/S│→/Alt│
                   └─────┴─────┴─────┘ └─────┴─────┴─────┴─────┘
```
- Shifted punctuation: `.`→`~`, `/`→`&`, `?`→`!`, `,`→`|`, `_`→`` ` ``, `-`→`+`, `:`↔`;` (custom shift keys, `keymap.c`).
- `OSL/N` = one-shot layer → NUM. `GUI/F` = tap GUI, hold → FN layer. `Sh/M` = S_MOUS (tap one-shot shift, hold → MOUSE layer, see below). `T/N` = LTNAV (tap T, hold → NAV). `←/Ct`, `→/Alt` = mod-tap arrows. `SPC/S` = tap space, hold → SYM. `⌘Lock` = `OS_LOCK` (macOS lock screen, `Cmd+Ctrl+Q`).

### Differences from stock Hands Down Gold

Stock Hands Down Gold (Neu) base layer, for comparison:
```
left:  J G M P V  /  R S N D B  /  X F L C W
right: : . / ' ?  /  , A E I H  /  _ U O Y K
```
This keymap:
```
left:  J F M P V  /  R S N D W  /  X G L C B
right: . / ? ' _  /  , A E I H  /  - U O Y K
```

- **F ↔ G swapped** between top row and bottom row (stock top has G, bottom has F; here it's the reverse).
- **B ↔ W swapped** between home row and bottom row (stock home has B, bottom has W; here it's the reverse).
- Right-hand top row drops the leading `:` and shifts everything one slot left (`. / ? ' _` instead of `: . / ' ?`); `:` moved to the home-row pinky slot (shift-`;`), and `_` gained a slot on top row. Bottom-row `_` became `-` (shifted to `+`).
- Right hand `, A E I H` (home row) is unchanged from stock.
- **Home-row mods removed.** Stock Hands Down Gold puts Ctrl/Gui/Alt/Shift on `R S N D` (left) and `A E I H` (right, mirrored) as mod-taps. This keymap keeps those eight keys as plain letters and moves all modifiers to the thumb cluster instead: `S_MOUS` (shift), `LTNAV` (nav), mod-tap arrows (`Ctrl`, `Alt`), and `GUI/FN` on the pinky-adjacent key. Trade-off: fewer simultaneous chorded mods, but no risk of a home-row letter misfiring as a modifier on a fast roll.
- T-on-thumb (the "Neu" variant) is preserved (`LTNAV = LT(_NAV, KC_T)`).
- Thumb cluster is 4+4 here vs. Ergodox's 6+6 — Emoji/Intl-layer/Fkeys thumb keys from stock don't exist; FN is reached via `GUI/FN` mod-tap instead of a dedicated thumb key.

## Other layers

**NAV** (hold `T`) — arrow cluster (`Home ← ↓ ↑ → End`) on the right home row, one-hand mods on the left home row, window/monitor management, undo/redo, app switching (`⌥1..4`).

```
left:  ·    ·   ⌥F   ·   ⌥P  ⌥V    |  right:  ·   ⌥1  ⌥2  ⌥3  ⌥4   ·
       ·  ⌘⇧S Alt  Sft  Ctl  Gui   |         Home  ←   ↓   ↑   →  End
       ·    ·  ⌘⇧G  ⌥N  Undo Redo  |          ·   ⌥C ⌘Spc  ⌥K  Mon WinMon
thumbs:  ·    ·    ·    ·          |   ·  ⌘⇧S  ⌘⇧Spc  ⌘⇧C
```

**MOUSE** (hold `Sh/M` past tapping term) — cursor on right hand (`← ↓ ↑ →` + wheel on the surrounding keys), buttons on right thumbs (left/middle/right click).

**NUM** (one-shot from `OSL/N`) — numpad-style digits on left hand (`6 4 0 2` / `8` and `3 1 5 7` / `9`), `+` and `BTN1/BTN2` (mouse buttons) plus `SPC`/`BSPC` on thumbs.

**CRYL** (Cyrillic, toggled by `CRYLTG`) — remaps alpha keys to Cyrillic (қ ф м п в / я р с н д ш / х г л ч б on the left; ы / а е и ҳ з / у о й к on the right), keeps punctuation layer mostly transparent. See "Language toggle" below.

**FN** (hold `GUI/FN`) — dynamic macro record/stop/play, media transport, volume, `QK_BOOT` (bootloader) top-right.

**SYM** (hold `SPC/S`) — full symbol layer: brackets, quotes, math operators, `!@#$%^&*()`, backtick/tilde, with `BSPC`/`SPC`/`ENT` on thumbs.

## Behaviors (`features.c`, `adaptive.h`)

- **`S_MOUS`** — tap: one-shot Shift. Hold past `TAPPING_TERM` (200ms): momentary MOUSE layer. Releasing while mouse-active turns MOUSE off. Tracks interruption so a key pressed mid-hold doesn't leak an extra one-shot shift afterward.
- **`REP`** — repeat key. Plain: repeats last key (`repeat_key_invoke`). With Ctrl held: alt-repeat (`alt_repeat_key_invoke`), Ctrl stripped and reapplied around the call. Rationale for no dedicated `//`/`??` keys — just repeat.
- **`LTNAV`** — tap `T`, hold → NAV layer. If a repeat sequence is active (`get_repeat_key_count() > 0`), a tap always sends `T` instead of participating in hold-detection, so `T` after `REP` doesn't misfire as nav.
- **Language toggle (`CRYLTG` / `SN_ESC_CRYL` / `toggle_lg`)** — `CRYLTG` (top-right BASE key) enables Russian: fires the OS input-source-switch shortcut, turns CRYL layer on. Only fires if CRYL isn't already active (so a stray repeat can't desync firmware from OS). `SN_ESC_CRYL` (combo: `S`+`N`) is Esc normally, but disables Russian (fires the OS shortcut again + `layer_off`) when CRYL is active. OS-aware: both-Shift tap on Windows/Linux (`grp:shifts_toggle`), `Ctrl+Space` on macOS.
- **Adaptive substitutions (`adaptive.h`, `ADAPTIVE_TERM` 200ms)** — two keys typed in quick succession on BASE produce a third key instead, active only on the BASE layer and not when any Ctrl/Alt/Gui mod is held:
  - `F`+`M`→`L`, `F`+`P`→`{`, `V`+`M`→`L`, `M`+`V`→`B`, `P`+`V`→`LV`, `P`+`M`→`PL`, `L`+`C`→`P`, `L`+`L`→`M`, `G`+`X`→`S`, `G`+`G`→`F`, `U`+`H`→`A`, `A`+`H`→`U`, `O`+`H`→`E`, `D`+`D`→`C`, `E`+`H`→`O`.
  - `P` alone is buffered (gobbled) until `ADAPTIVE_TERM` elapses or a matching second key arrives, then emitted plain if nothing matched.
- **OS-aware taps (`features.c`)** — best-effort `detected_host_os()`, falls back to macOS behavior when unsure (primary machine): word-backspace is `Alt+Bspc` on macOS / `Ctrl+Bspc` on Win/Linux; copy/paste/select-all use `Cmd` on macOS / `Ctrl` on Win/Linux.
- **Raw HID bootloader (`raw_hid_receive`)** — listens for `"BOOTLDR1"` magic string, replies `"BOOTING"`, calls `reset_keyboard()`. Used by `reflash.sh` to enter the bootloader without a physical key combo.

## Combos (`combos.def`)

| Keys | Result | Layer |
|---|---|---|
| `M`+`P` | `Z` | BASE |
| `J`+`F` | `Q` | BASE |
| `F`+`M` | `qu` (string) | BASE |
| `E`+`I` | Enter | BASE |
| `S`+`N` | `SN_ESC_CRYL` (Esc / disable Cyrillic) | BASE |
| `N`+`D` | Tab | BASE |
| `A`+`E` | word-backspace | BASE |
| `G`+`L` | copy | BASE |
| `L`+`C` | paste | BASE |
| `G`+`L`+`C` | select-all | BASE |
| `A`+`E`+`I` | `;` | BASE |
| `SPC/S`+`T/N` | Caps-word toggle | BASE |
| `/`+`?` | Page Up | BASE |
| `?`+`'` | Page Down | BASE |
| `/`+`E` | `=>` (string) | BASE |
| `)`+`(` (shifted 0/9) | Enter | SYM |

`COMBO_TERM` 20ms, variable-length combos enabled.

## Timing

| Constant | Value |
|---|---|
| `TAPPING_TERM` | 200ms |
| `COMBO_TERM` | 20ms |
| `ADAPTIVE_TERM` | 200ms |
| `QUICK_TAP_TERM` | 0 (disabled — `REP` covers repeats) |

## File map

See `AGENTS.md` in this keyboard's root for the full file map, build/flash workflow (`reflash.sh`), and Neovim/Hyprland cross-references. This file (`LAYOUT.md`) is the layout reference; `keymap.yaml` is the machine-readable source for the [keymap-drawer](https://keymap-drawer.streamlit.app) visualization.
