# QMK Documentation and Linux Chezmoi Migration Design

## Goal

Make QMK the documented source of truth for the Imperial44 keyboard and add a
reversible Linux chezmoi source tree alongside the existing macOS source tree.

## Scope

- Synchronize the QMK agent guide, layout reference, and keymap-drawer YAML
  with the active four-layer firmware: `BASE`, `NAV`, `NUM`, and `SYM`.
- State that `mac/home/dot_config/kanata/kanata.kbd` is a laptop compatibility
  port whose intentional deviations are documented in that file.
- Convert the existing `linux/` stow-era payload into `linux/home/`, a chezmoi
  source directory using chezmoi filename conventions.
- Make `install.sh` select `mac/home` on Darwin and `linux/home` on Linux.
- Document platform-specific bootstrap and direct apply commands in the README.

## Non-goals

- Change QMK keyboard behavior, combos, adaptive rules, or layer timings.
- Make Kanata feature-identical to QMK.
- Merge macOS and Linux into one templated source tree.
- Delete the old Linux tree during this migration.

## Target layout

```
mac/home/                 # existing macOS chezmoi source, unchanged
linux/home/               # Linux chezmoi source, migrated from linux/*
linux/archive/            # optional later destination for retired stow layout
```

`linux/home/` receives the same destination-oriented structure used by
`mac/home/`: `dot_config/` for `~/.config`, `dot_local/` for `~/.local`, and
literal home-relative files such as `dot_xkb/` for `~/.xkb`. Source files that
must remain executable retain chezmoi's `executable_` prefix.

## Migration and rollback

1. Copy each Linux configuration into `linux/home/` without deleting its
   current stow-era source.
2. Validate the target paths with `chezmoi apply --dry-run --source
   linux/home` (or the equivalent `-S` flag) on Linux.
3. Once applied and manually checked on Linux, retain the original `linux/*`
   sources as a compatibility window; do not delete or archive them in this
   change.
4. If the Linux source tree is unsuitable, set chezmoi's `sourceDir` back to
   the previous location or stop using the new `linux/home` tree. No managed
   source file is destroyed by this migration.

## Bootstrap behavior

`install.sh` determines the operating system with `uname`. It uses `mac/home`
for `Darwin` and `linux/home` for `Linux`; other systems fail with a clear
message. It continues to preserve an existing chezmoi config rather than
overwriting user data. The README documents `chezmoi -S <source> apply` for
explicit, repeatable application.

## Verification

- Compare the QMK layer enum and keymap definitions against the two docs and
  visualization; the removed CRYL/FN layers and boot-key claims must disappear.
- Verify the migrated Linux source tree has one expected target for every
  existing Linux stow payload and that executable scripts retain executable
  source names.
- Run shell syntax checks, Python compilation, plist validation, `git diff
  --check`, and available chezmoi dry-run/validation commands. Do not flash
  firmware or apply user configuration during verification.
