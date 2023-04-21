### Added by Zinit's installer
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
eval "$(zoxide init zsh)"

setopt inc_append_history
# xset r rate 250 150
alias ns="clear;exa --long --octal-permissions --no-permissions  --no-user --icons --sort time --reverse"
alias st="z"
alias n="nvim ."

alias arst="clear"
alias oien="exit"
alias oine="exit"
alias oa="lazygit"

alias kfg="lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# file-system manipulation
alias rm="rm -rfv"
alias mv="mv -v"
alias cp="cp -v"

alias man='tldr'
colorscript random

path+=('/home/iz/.cargo/bin')

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

export KEYTIMEOUT=1 # Kill the lag between switching to VIM mode

bindkey -v

source "$HOME/.config/zsh/0zinit"
source "$HOME/.config/zsh/plugins"
source "$HOME/.config/zsh/alias"
source "$HOME/.config/zsh/9other"
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':completion:*:*:*:default' menu yes select search # What is this ?

zinit light Aloxaf/fzf-tab # Todo: find out how to enable this on cd-tab

# Better vim mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
# as of v4.0 use ZSH/zpty module to async retrieve
export ZSH_AUTOSUGGEST_USE_ASYNC=1
# Removed forward-char
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zinit light zsh-users/zsh-autosuggestions
bindkey "\e\[Z" autosuggest-accept

zinit ice lucid wait"1"
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
