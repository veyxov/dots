# ------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/.cargo/bin" $path)

# ------------------------------------------------------------------
# Core options
# ------------------------------------------------------------------
export VISUAL=nvim
export EDITOR=nvim
export KEYTIMEOUT=1                    # kill the lag switching in/out of vi mode
export DISABLE_MAGIC_FUNCTIONS=true    # make pasting into terminal faster
export ZSH_AUTOSUGGEST_USE_ASYNC=1

bindkey -v                             # vi mode
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# ------------------------------------------------------------------
# History
# ------------------------------------------------------------------
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# ------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------
autoload -Uz compinit
setopt extendedglob # needed for the (#q...) glob qualifier below to actually evaluate
# compaudit (compinit's insecure-directory scan) is the slow part of every
# startup; only pay for it once a day, load from cache the rest of the time.
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'

# ------------------------------------------------------------------
# Antidote (plugin manager)
# ------------------------------------------------------------------
ANTIDOTE_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
if [[ ! -d $ANTIDOTE_HOME ]]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_HOME"
fi
source "$ANTIDOTE_HOME/antidote.zsh"

zsh_plugins="${ZDOTDIR:-$HOME}/.zsh_plugins"
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle <"${zsh_plugins}.txt" >"${zsh_plugins}.zsh"
fi
source "${zsh_plugins}.zsh"

# ------------------------------------------------------------------
# Prompt / navigation / history
# ------------------------------------------------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

# ------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------
alias ea="clear; lsd --long --octal-permissions --no-permissions --no-user --icons --sort time --reverse"
alias nd="z"
alias n="nvim"
alias ei="lazygit"
alias nvil="nvim" # "Hands down" did this to me :)

# file-system manipulation
alias rm="rm -rfv"
alias mv="mv -v"
alias cp="cp -v"

kfg() {
    cd ~/dots || return
    ei
}

# ------------------------------------------------------------------
# Custom widgets
# ------------------------------------------------------------------
cmd_to_clip() {
    echo $BUFFER | tr -d '\n' | wl-copy
}
zle -N cmd_to_clip
bindkey '^Y' cmd_to_clip

bindkey -s '^p' '^uselect_proj^M'
bindkey -s '^e' 'cd ./$(fd -t d -d 7 | fzf)^M'
