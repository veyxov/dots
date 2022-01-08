# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
