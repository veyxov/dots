# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Eye candy
alias grep='grep --color=auto'
alias tmux='TERM=xterm-256color tmux -2'
alias ls='exa -F --icons --color=automatic'
alias la='ls -a'

# More verbose output for risky commands
alias mkdir='mkdir -v'
alias cp='cp -vi'
alias mv='mv -v'
alias rm='rm -v'

# Dotfiles managment
alias config='/usr/bin/git --git-dir=/home/iz/.dots/ --work-tree=/home/iz'

# Zsh-like completion
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Bash options
shopt -s autocd # Go to typed directory
shopt -s cdspell # Correct minor mistakes
