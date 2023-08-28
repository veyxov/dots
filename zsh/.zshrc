# Bootstrap zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Edit buffer in vim mode
export VISUAL=nvim
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Aliases
alias ea="clear;exa --long --octal-permissions --no-permissions  --no-user --icons --sort time --reverse"
alias nd="z"
alias n="nvim"
alias ei="lazygit"

# "Hands down" did this to me :)
alias nvil="nvim"

# file-system manipulation
alias rm="rm -rfv"
alias mv="mv -v"
alias cp="cp -v"
# yadm
function kfg() {
    cd ~/dots
    ei
}

# Exports
path+=('/home/iz/.cargo/bin')
export KEYTIMEOUT=1 # Kill the lag between switching to VIM mode
export DISABLE_MAGIC_FUNCTIONS=true     # make pasting into terminal faster

zstyle ':completion:*' completer _extensions _complete _approximate
zinit  for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

export ZSH_AUTOSUGGEST_USE_ASYNC=1
zinit light zsh-users/zsh-autosuggestions

NUM=$((RANDOM%255))
PROMPT="%B%F{240}%(5~|%-1~/…/%3~|%4~)%b%F{$NUM}❯ %f"
# RPROMPT='%*' right prompt

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

bindkey -v # Vim mode

cmd_to_clip () {
    echo $BUFFER | tr -d '\n' | wl-copy
}
zle -N cmd_to_clip
bindkey '^Y' cmd_to_clip

export GPG_TTY=$(tty)
#pkill -9 gpg-agent &
gpg-connect-agent updatestartuptty /bye >/dev/null
# Zoxide
eval "$(zoxide init zsh)"

# New session
bindkey -s '^p' '^uselect_proj^M'
bindkey -s '^e' 'cd ./$(fd -t d -d 7 | fzf)^M'


__fzfcmd() {
  [ -n "${TMUX_PANE-}" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "${FZF_TMUX_OPTS-}" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget

source /home/iz/.config/broot/launcher/bash/br
