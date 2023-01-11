if status is-interactive
    fish_vi_key_bindings
end

function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold red
      echo 'N'
    case insert
      set_color --bold green
      echo ''
    case replace_one
      set_color --bold green
      echo 'R'
    case visual
      set_color --bold brmagenta
      echo 'V'
    case '*'
      set_color --bold red
      echo '?'
  end
  set_color normal
end

function kfg
    lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME
end

function kfgg
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME
end

# Faster input
xset r rate 300 50

bind -M insert \cn 'nvim .'
bind -M insert \ce 'cd ~/Projects && cd $(sudo fd --max-depth 4 --type d | fzf)'

# pnpm
set -gx PNPM_HOME "/home/iz/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

alias ns='ls'
alias ls='exa -F --icons --color=automatic'
alias la='ls -a'
alias tree='exa -T'
alias st="cd"
alias arst="clear"
alias oien="exit"
alias arstoien="lazygit"
alias n="nvim"
