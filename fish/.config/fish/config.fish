if status is-interactive
    set -g fish_greeting

    zoxide init fish | source

    fzf_configure_bindings --directory=\ce

    alias d="z"
    alias n="nvim"

    alias nd="zi"
    alias fl="cd ~/dots && lazygit"

    alias g="lazygit"
    alias s="eza --icons"

    abbr gc "git checkout"
    abbr gl git commit -m 
end
set -x PATH $PATH $HOME/.dotnet/tools
set -x DOTNET_ROOT $HOME/.dotnet
set -x PATH $PATH $DOTNET_ROOT
export DOTNET_ROOT=$(dirname $(readlink $(command -v dotnet)))
