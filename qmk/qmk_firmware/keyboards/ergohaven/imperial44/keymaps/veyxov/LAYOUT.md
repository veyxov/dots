# veyxov keymap — Imperial44 (Hands Down Gold–derived)

Ergohaven Imperial44: split, 3x6 per hand + 4 thumb keys per hand (44 keys total), RP2040.
Base alpha layout is [Hands Down Gold](https://sites.google.com/alanreiser.com/handsdown/home) ("Neu", T-on-thumb variant), with a handful of positions swapped and home-row mods replaced by thumb-cluster mods. Reference implementation used for comparison: [neonfuzz/HandsDown](https://github.com/neonfuzz/HandsDown), `layouts/community/hands_down_gold/hdgold.c` + `keyboards/ergodox_ez/keymaps/hands_down_gold/keymap.c`.

## BASE layer

```
┌─────┬─────┬─────┬─────┬─────┐         ┌─────┬─────┬─────┬─────┬─────┐
│OSL/N│  J  │  F  │  M  │  P  │  V       Scrn   │  .  │  /  │  ?  │  '  │  _  │
├─────┼─────┼─────┼─────┼─────┤         ├─────┼─────┼─────┼─────┼─────┤
│ DEL │  R  │  S  │  N  │  D  │  W        ,    │  A  │  E  │  I  │  H  │  :  │
├─────┼─────┼─────┼─────┼─────┤         ├─────┼─────┼─────┼─────┼─────┤
│ GUI │  X  │  G  │  L  │  C  │  B        -    │  U  │  O  │  Y  │  K  │  ·  │
└─────┴─────┴─────┼─────┼─────┼─────┐ ┌─────┼─────┼─────┴─────┴─────┴─────┘
                   │ REP │ T/N │  Sh │ TAB │ │⌘Lock│←/Ct │SPC/S│→/Alt│
                   └─────┴─────┴─────┘ └─────┴─────┴─────┴─────┘
```
- Shifted punctuation: `.`→`~`, `/`→`&`, `?`→`!`, `,`→`|`, `_`→`` ` ``, `-`→`+`, `:`↔`;` (custom shift keys, `keymap.c`).
- `OSL/N` = one-shot layer → NUM. `GUI` = plain Cmd (held modifier). `Sh` = `OSM(MOD_LSFT)` (tap one-shot shift, hold for normal held shift). `T/N` = LTNAV (tap T, hold → NAV). `←/Ct`, `→/Alt` = mod-tap arrows. `SPC/S` = tap space, hold → SYM. `⌘Lock` = `OS_LOCK` (macOS lock screen, `Cmd+Ctrl+Q`). `Scrn` = `Cmd+Shift+Ctrl+4` (macOS region screenshot to clipboard).

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
- **Home-row mods removed.** Stock Hands Down Gold puts Ctrl/Gui/Alt/Shift on `R S N D` (left) and `A E I H` (right, mirrored) as mod-taps. This keymap keeps those eight keys as plain letters and moves all modifiers to the thumb cluster instead: `OSM(MOD_LSFT)` (shift), `LTNAV` (nav), mod-tap arrows (`Ctrl`, `Alt`), and plain `GUI` on the pinky-adjacent key. Trade-off: fewer simultaneous chorded mods, but no risk of a home-row letter misfiring as a modifier on a fast roll.
- T-on-thumb (the "Neu" variant) is preserved (`LTNAV = LT(_NAV, KC_T)`).
- Thumb cluster is 4+4 here vs. Ergodox's 6+6 — Emoji/Intl-layer/Fkeys thumb keys from stock don't exist; media/system keys live on the NUM layer.

## Other layers

**NAV** (hold `T`) — arrow cluster (`Home ← ↓ ↑ → End`) on the right home row, one-hand mods on the left home row, window/monitor management, undo/redo, app switching (`⌥1..4`).

```
left:  ·    ·   ⌥F   ·   ⌥P  ⌥V    |  right:  ·   ⌥1  ⌥2  ⌥3  ⌥4   ·
       ·  ⌘⇧S Alt  Sft  Ctl  Gui   |         Home  ←   ↓   ↑   →  End
       ·    ·  ⌘⇧G  ⌥N  Undo Redo  |          ·   ⌥C ⌘Spc  ⌥K  Mon WinMon
thumbs:  ·    ·    ·    ·          |   ·  ⌘⇧S  ⌘⇧Spc  ⌘⇧C
```

**NUM** (one-shot from `OSL/N`, or NUMWORD combo) — numpad-style digits (`6 4 0 2` / `8` and `3 1 5 7` / `9`), `+` on right home pinky, `.`/`SPC`/`BSPC`/`-` on thumbs. Also hosts the former FN keys: volume/brightness/mute on right top row, media transport on right bottom row. `QK_BOOT` deliberately left off — `reflash.sh` enters bootloader over raw HID (falling back to the physical board button), so a keymap bootloader key was only accidental-trigger risk.

**SYM** (hold `SPC/S`) — full symbol layer: brackets, quotes, math operators, `!@#$%^&*()`, backtick/tilde, with `BSPC`/`SPC`/`ENT` on thumbs.

## Behaviors (`features.c`, `adaptive.h`)

- **`REP`** — repeat key. Plain: repeats last key (`repeat_key_invoke`). With Ctrl held: alt-repeat (`alt_repeat_key_invoke`), Ctrl stripped and reapplied around the call. Rationale for no dedicated `//`/`??` keys — just repeat.
- **`LTNAV`** — tap `T`, hold → NAV layer. If a repeat sequence is active (`get_repeat_key_count() > 0`), a tap always sends `T` instead of participating in hold-detection, so `T` after `REP` doesn't misfire as nav.
- **`LANG_SW`** — combo `S`+`D`, plain OS input-source switch (`Ctrl+Space`). No layer/state logic. Bottom-right corner key is unused (`KC_NO`).
- **`NUMWORD`** — combo `SPC/S`+`Sh` (mirror thumbs), smart NUM layer: stays active over `0-9 . - + BSPC REP`, self-deactivates on any other key (T-34 style). `OSL/N` still works for one-shot/held access.
- **Adaptive substitutions (`adaptive.h`, `ADAPTIVE_TERM` 200ms)** — two keys typed in quick succession on BASE produce a third key instead, active only on the BASE layer and not when any Ctrl/Alt/Gui mod is held:
  - `F`+`M`→`L`, `F`+`P`→`{`, `V`+`M`→`L`, `M`+`V`→`B`, `P`+`V`→`LV`, `P`+`M`→`PL`, `L`+`C`→`P`, `L`+`L`→`M`, `G`+`X`→`S`, `G`+`G`→`F`, `U`+`H`→`A`, `A`+`H`→`U`, `O`+`H`→`E`, `D`+`D`→`C`, `E`+`H`→`O`.
  - `P` alone is buffered (gobbled) until `ADAPTIVE_TERM` elapses or a matching second key arrives, then emitted plain if nothing matched.
- **macOS taps (`features.c`)** — word-backspace is `Alt+Bspc`; copy/paste/select-all use `Cmd`.
- **Raw HID bootloader (`raw_hid_receive`)** — listens for `"BOOTLDR1"` magic string, replies `"BOOTING"`, calls `reset_keyboard()`. Used by `reflash.sh` to enter the bootloader without a physical key combo.

## Combos (`combos.def`)

| Keys | Result | Layer |
|---|---|---|
| `M`+`P` | `Z` | BASE |
| `J`+`F` | `Q` | BASE |
| `F`+`M` | `qu` (string) | BASE |
| `E`+`I` | Enter | BASE |
| `S`+`N` | Esc | BASE |
| `N`+`D` | Tab | BASE |
| `A`+`E` | word-backspace | BASE |
| `S`+`D` | `LANG_SW` (OS input-source switch) | BASE |
| `G`+`L` | copy | BASE |
| `L`+`C` | paste | BASE |
| `G`+`L`+`C` | select-all | BASE |
| `A`+`E`+`I` | `;` | BASE |
| `SPC/S`+`T/N` | Caps-word toggle | BASE |
| `SPC/S`+`Sh` | NUMWORD toggle | BASE |
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
