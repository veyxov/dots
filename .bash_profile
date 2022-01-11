# Add my bin's to PATH
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$HOME/.local/src/dwmblocks/src"

# Programs
export EDITOR="nvim"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto start X
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    # Startx quietly
    exec startx -- vt1 &> /dev/null
fi
