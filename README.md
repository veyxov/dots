# dots

macOS dotfiles, managed with [chezmoi](https://chezmoi.io).

## Layout

- `home/` — chezmoi source state (`.chezmoiroot` points here). Targets `~`:
  `dot_config/` → `~/.config/`, plus `dot_zshenv`, `Library/`, etc.
- `Brewfile` — Homebrew packages and casks (`brew bundle`).
- `install.sh` — bootstrap: clone the repo, point chezmoi at it, `chezmoi apply`.
- `macos/launchdaemons/` — LaunchDaemon plists for kanata and the
  Karabiner VirtualHIDDevice daemon (install instructions in each plist).
- `macos/defaults.sh` — Finder/Dock/trackpad/keyboard/screenshot defaults,
  not applied automatically; run manually with `./macos/defaults.sh`.
- `qmk/` — QMK keyboard firmware/layout.
- `bin/`, `sony/` — personal utility scripts.
- `archive/` — old Arch Linux (stow-era) configs, kept for reference; not applied.

## Usage

```sh
./install.sh          # first-time bootstrap
brew bundle           # install packages
chezmoi apply         # re-apply after edits
chezmoi diff          # preview changes
```

Edit files in `home/` directly (the repo is the chezmoi source dir), then
`chezmoi apply`.
