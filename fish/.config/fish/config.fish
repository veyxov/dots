if status is-interactive
    set -g fish_greeting

    zoxide init fish | source

    fzf_configure_bindings --directory=\ce

    alias d="z"
    alias n="nvim"

    alias nd="zi"
    alias fl="cd ~/dots && lazygit"

    alias g="lazygit"

    abbr gc "git checkout"
    abbr go git commit -m 
end
