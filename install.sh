#!/bin/sh
# Bootstrap: clone this repo (if not already) and let chezmoi deploy it.
set -e

DOTS_DIR="${HOME}/dots"

if [ ! -d "$DOTS_DIR" ]; then
  git clone git@github.com:veyxov/dots.git "$DOTS_DIR"
fi

# don't clobber an existing config (it may hold [data] etc.)
if [ ! -f "${HOME}/.config/chezmoi/chezmoi.toml" ]; then
  mkdir -p "${HOME}/.config/chezmoi"
  cat > "${HOME}/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "${DOTS_DIR}"
EOF
fi

chezmoi apply
