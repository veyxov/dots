# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prevent ^S and ^Q doing XON/XOFF (mostly for Vim)
if [[ -t 0 && $- = *i* ]]
then
    stty -ixon
fi 

# Vim mode
set -o vi
#use extra globing features. See man bash, search extglob.
shopt -s extglob
#include .files when globbing.
shopt -s dotglob
#When a glob expands to nothing, make it an empty string instead of the literal characters.
shopt -s nullglob
# fix spelling errors for cd, only in interactive shell
shopt -s cdspell

# Aliases
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Eye candy
alias grep='grep --color=auto'
alias tmux='TERM=xterm-256color tmux -2'
alias ls='exa -F --icons --color=automatic'
alias la='ls -a'
alias tree='exa -T'

# More verbose output for risky commands
alias mkdir='mkdir -v'
alias cp='cp -vi'
alias mv='mv -v'
alias rm='rm -v'

# Git aliases
alias gs='git status -s'
alias gc='git commit'
alias gp='git push'
alias gP='git pull'

# Dotfiles managment
alias config='/usr/bin/git --git-dir=/home/iz/.dots/ --work-tree=/home/iz'

# Zsh-like completion
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups

# append history entries..
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Bash options
shopt -s autocd # Go to typed directory
shopt -s cdspell # Correct minor mistakes

# Binds
bind -x '"\C-l": clear; ls'

# FZF
source "/usr/share/fzf/key-bindings.bash"
source "/usr/share/fzf/completion.bash"

# Make extracting archives easier
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

# ZOXIDE
# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
__zoxide_oldpwd="$(__zoxide_pwd)"

function __zoxide_hook() {
    \builtin local -r retval="$?"
    \builtin local pwd_tmp
    pwd_tmp="$(__zoxide_pwd)"
    if [[ ${__zoxide_oldpwd} != "${pwd_tmp}" ]]; then
        __zoxide_oldpwd="${pwd_tmp}"
        \command zoxide add -- "${__zoxide_oldpwd}"
    fi
    return "${retval}"
}

# Initialize hook.
if [[ ${PROMPT_COMMAND:=} != *'__zoxide_hook'* ]]; then
    PROMPT_COMMAND="__zoxide_hook;${PROMPT_COMMAND#;}"
fi

# =============================================================================
#
# When using zoxide with --no-aliases, alias these internal functions as
# desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ $# -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ $# -eq 1 && $1 == '-' ]]; then
        __zoxide_cd "${OLDPWD}"
    elif [[ $# -eq 1 && -d $1 ]]; then
        __zoxide_cd "$1"
    elif [[ ${@: -1} == "${__zoxide_z_prefix}"* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@: -1}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query -i -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Convenient aliases for zoxide. Disable these using --no-aliases.
#

# Remove definitions.
function __zoxide_unset() {
    \builtin unset -f "$@" &>/dev/null
    \builtin unset -v "$@" &>/dev/null
    \builtin unalias "$@" &>/dev/null || \builtin :
}

__zoxide_unset j
function j() {
    __zoxide_z "$@"
}

__zoxide_unset ji
function ji() {
    __zoxide_zi "$@"
}

# Load completions.
# - Bash 4.0+ is needed to use `mapfile`.
# - Completions require line editing. Since Bash supports only two modes of
#   line editing (`vim` and `emacs`), we check if either them is enabled.
# - Completions don't work on `dumb` terminals.
if [[ ${BASH_VERSINFO:-0} -ge 4 && :"${SHELLOPTS}": =~ :(vi|emacs): && ${TERM} != 'dumb' ]]; then
    # Use `printf '\e[5n'` to redraw line after fzf closes.
    \builtin bind '"\e[0n": redraw-current-line' &>/dev/null

    function _j() {
        # Only show completions when the cursor is at the end of the line.
        [[ ${#COMP_WORDS[@]} -eq $((COMP_CWORD + 1)) ]] || return

        # If there is only one argument, use `cd` completions.
        if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
            \builtin mapfile -t COMPREPLY < \
                <(\builtin compgen -A directory -S / -- "${COMP_WORDS[-1]}" || \builtin true)
        # If there is a space after the last word, use interactive selection.
        elif [[ -z ${COMP_WORDS[-1]} ]]; then
            \builtin local result
            result="$(\command zoxide query -i -- "${COMP_WORDS[@]:1:${#COMP_WORDS[@]}-2}")" &&
                COMPREPLY=("${__zoxide_z_prefix}${result@Q}")
            \builtin printf '\e[5n'
        fi
    }

    \builtin complete -F _j -o nospace -- j
fi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.bashrc):
#
eval "$(zoxide init bash)"

# Starship
eval "$(starship init bash)"
