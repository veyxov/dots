# Add my bin's to PATH
export PATH="$PATH:$HOME/.local/bin/"

export WALLPAPERS_LOCATION="$HOME/.local/walls/*"

# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export SQLITE_HISTORY="$XDG_CACHE_HOME"/sqlite_history

# Move to XDG complaiant folders
export HISTFILE="$HOME"/.cache/history
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages

# Graphics driver
export LIBVA_DRIVER_NAME=iris

# ignore case, long prompt, exit if it fits on one screen, allow colors for ls and grep colors
export LESS="-iMFXR"

# Programs
export EDITOR="nvim"
# Open man pages in neovim
export MANPAGER='nvim +Man!'

export MOZ_ENABLE_WAYLAND=1

# Fzf defaults
export FZF_DEFAULT_OPTS='--no-height --no-reverse --select-1 --exit-0'

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto start wayland
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    # dwl -s ~/start.sh
    river -log-level warning
fi
