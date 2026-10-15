# QMK Documentation and Linux Chezmoi Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make QMK authoritative in keyboard documentation and add a reversible Linux chezmoi home source tree.

**Architecture:** Keep independent `mac/home` and `linux/home` chezmoi source trees. QMK remains the keyboard authority; Kanata remains a documented laptop compatibility port. Copy Linux home configuration into chezmoi naming without removing the existing stow-era sources.

**Tech Stack:** chezmoi, QMK/keymap-drawer YAML, Bash, Fish, Hyprland.

**Spec:** `docs/superpowers/specs/2026-08-30-qmk-docs-linux-chezmoi-design.md`

## Global Constraints

- Preserve QMK keyboard behavior and do not flash firmware.
- Preserve all existing Linux stow-era source files.
- Manage only home-relative Linux paths in `linux/home`; leave the `/etc` Pacman hook outside chezmoi.
- Preserve executable source names for Linux `~/.local/bin` scripts.

---

### Task 1: Synchronize QMK documentation and visualization

**Files:**
- Modify: `qmk/qmk_firmware/keyboards/ergohaven/imperial44/AGENTS.md`
- Modify: `qmk/qmk_firmware/keyboards/ergohaven/imperial44/keymaps/veyxov/LAYOUT.md`
- Modify: `qmk/qmk_firmware/keyboards/ergohaven/imperial44/keymaps/veyxov/keymap.yaml`

**Interfaces:**
- Consumes: `keymap.c`, `layers.h`, `features.c`, `combos.def`, and `config.h`.
- Produces: agent and keymap-drawer references matching active firmware.

- [ ] Record the active four-layer enum and absence of an active boot key.
- [ ] Remove CRYL/FN/boot claims and stale Hyprland references; identify QMK as canonical and Kanata as an intentionally divergent compatibility port.
- [ ] Rewrite the YAML to represent only BASE/NAV/NUM/SYM from `keymap.c`, retaining active combo scopes.
- [ ] Run `rg` over the three documents to prove obsolete layer and boot claims are absent.

### Task 2: Add a Linux chezmoi source tree

**Files:**
- Create: `linux/home/dot_config/` equivalents for Electron, Fish, Hyprland, Kitty, Mako, MPV, Wget, wl-kbptr, and keyboard.
- Create: `linux/home/dot_local/bin/executable_{bri_ctl,instl,net_name,select_proj,setwall,vol_ctl}`.
- Create: `linux/home/dot_xkb/symbols/rus` and `linux/home/dot_packages`.

**Interfaces:**
- Consumes: home-scoped payloads beneath `linux/`.
- Produces: a complete chezmoi Linux source mapping to the same home targets.

- [ ] Map every `linux/` file to its destination, excluding `linux/pacman/etc/pacman.d/hooks/precommit.hook` because it targets `/etc`.
- [ ] Add destination-equivalent files using chezmoi naming, retaining originals as the rollback source.
- [ ] Verify every local-bin script uses `executable_` and that old source files remain.

### Task 3: Make bootstrap platform-aware

**Files:**
- Modify: `install.sh`
- Modify: `README.md`
- Modify: `mac/macos/defaults.sh`

**Interfaces:**
- Consumes: `uname`, chezmoi `sourceDir`, `mac/home`, and `linux/home`.
- Produces: explicit Darwin/Linux initialization and apply paths.

- [ ] Add a `case "$(uname -s)"` selector for `mac/home` and `linux/home`; fail clearly for unsupported systems and preserve existing chezmoi configuration.
- [ ] Document source roots, dry-run/apply commands, the compatibility window, and the manual Pacman-hook exception.
- [ ] Derive the repository root from `defaults.sh` rather than hardcoding `$HOME/dots`; correct its usage comment.
- [ ] Run shell syntax checks and `chezmoi -S "$PWD/{mac,linux}/home" source-path` without applying configurations.

### Task 4: Verify additive migration

**Files:**
- Verify: all Task 1-3 outputs.

- [ ] Run shell syntax checks, Python bytecode compilation, plist lint, and `git diff --check`.
- [ ] Verify old Linux Fish, Hyprland, and Pacman hook files still exist.
- [ ] Inspect `git status --short` and distinguish pre-existing user changes from migration output.
