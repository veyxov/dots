#!/usr/bin/env bash
set -euo pipefail

export HOMEBREW_NO_ENV_HINTS=1

# ask for password once, up front; keep sudo alive so cask installers
# that need it later don't stall the unattended run
sudo -v
( while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null & )

brew update
brew upgrade --greedy --force
brew cleanup -s
brew autoremove
nvim --headless -c 'lua vim.pack.update(nil, {force=true})' -c 'q'
