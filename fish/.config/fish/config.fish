if status is-interactive
    set -g fish_greeting

    zoxide init fish | source

    fzf_configure_bindings --directory=\ce

    alias fl="cd ~/dots && lazygit"
    alias d="z"
    alias nd="zi"
    alias n="nvim"
end
