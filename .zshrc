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


# Aliases
alias ea="clear;exa --long --octal-permissions --no-permissions  --no-user --icons --sort time --reverse"
alias nd="z"
alias n="nvim"
alias rsnd="clear"
alias hiea="exit"
alias ei="lazygit"
alias kfg="lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME"
# file-system manipulation
alias rm="rm -rfv"
alias mv="mv -v"
alias cp="cp -v"

# Exports
path+=('/home/iz/.cargo/bin')
export KEYTIMEOUT=1 # Kill the lag between switching to VIM mode
export DISABLE_MAGIC_FUNCTIONS=true     # make pasting into terminal faster

# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _expand _complete _approximate
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':completion:*:*:*:default' menu yes select search # What is this ?

zinit light Aloxaf/fzf-tab


export ZSH_AUTOSUGGEST_USE_ASYNC=1

zinit light zsh-users/zsh-autosuggestions
bindkey "\e\[Z" autosuggest-accept

NUM=$((RANDOM%255))
PROMPT="%B%F{240}%~%b%F{$NUM}❯ %f"
RPROMPT='%*'

# Correction
setopt CORRECT


# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# Better vim mode
bindkey -v # Vim mode

zinit wait"1" lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

cmd_to_clip () {
    echo $BUFFER | tr -d '\n' | xclip -sel clip
}
zle -N cmd_to_clip
bindkey '^Y' cmd_to_clip

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export GPG_TTY=$(tty)
#pkill -9 gpg-agent &
gpg-connect-agent updatestartuptty /bye >/dev/null
# Zoxide
eval "$(zoxide init zsh)"
