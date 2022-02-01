# Add my bin's to PATH
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$HOME/.local/src/dwmblocks/src"

# XDG
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# Move to XDG complaiant folders
export HISTFILE="$HOME"/.cache/history
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# Graphics driver
export LIBVA_DRIVER_NAME=iris

# ignore case, long prompt, exit if it fits on one screen, allow colors for ls and grep colors
export LESS="-iMFXR"

# Programs
export EDITOR="nvim"
# Fzf defaults
export FZF_DEFAULT_OPTS='--no-height --no-reverse --select-1 --exit-0'

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto start X
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    # Startx quietly
    exec startx "$XDG_CONFIG_HOME/X11/xinitrc" -- vt1 &> /dev/null
fi
