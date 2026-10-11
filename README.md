# dots

Dotfiles for macOS and Linux, managed with [chezmoi](https://chezmoi.io).

## Layout

- `mac/` — macOS setup:
  - `home/` — macOS chezmoi source state. Targets `~`:
    `dot_config/` → `~/.config/`, plus `dot_zshenv`, `Library/`, etc.
  - `Brewfile` — Homebrew packages and casks (`brew bundle`).
  - `macos/launchdaemons/` — LaunchDaemon plists for kanata and the
    Karabiner VirtualHIDDevice daemon.
  - `macos/install-kanata.sh` — installs the pinned DriverKit driver (6.2.0,
    what kanata 1.12 needs) and bootstraps both daemons; run manually.
  - `macos/defaults.sh` — Finder/Dock/trackpad/keyboard/screenshot defaults,
    not applied automatically; run manually with `./mac/macos/defaults.sh`.
- `linux/` — Arch Linux setup:
  - `home/` — Linux chezmoi source state.
  - `pacman/etc/pacman.d/hooks/precommit.hook` is system-level and remains a
    manual install; chezmoi manages only home-relative Linux files.
- `install.sh` — bootstrap: clone the repo, choose the OS-specific chezmoi
  source state, then run `chezmoi apply`.
- `qmk/` — QMK keyboard firmware/layout.
- `bin/`, `sony/` — personal utility scripts.

## Usage

```sh
./install.sh                         # first-time bootstrap on macOS or Linux
brew bundle --file mac/Brewfile       # macOS packages
ya pkg install                        # yazi plugins and flavors from package.toml

# Explicit source roots; use the one for the current operating system.
chezmoi -S "$HOME/dots/mac/home" diff
chezmoi -S "$HOME/dots/mac/home" apply
chezmoi -S "$HOME/dots/linux/home" diff
chezmoi -S "$HOME/dots/linux/home" apply
```

Edit the source tree for the target OS, then use the matching explicit
`chezmoi -S ... apply` command.
