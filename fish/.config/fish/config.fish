if status is-interactive
    set -g fish_greeting

    zoxide init fish | source

    fzf_configure_bindings --directory=\ce

    alias d="z"
    alias n="nvim"

    alias nd="zi"
    alias fl="cd ~/dots && lazygit"

    alias g="lazygit"
    alias s="lsd --ignore-config --human-readable --extensionsort --long --blocks size,date,name --date relative"
end
set -x PATH $PATH $HOME/.dotnet/tools
set -x DOTNET_ROOT $HOME/.dotnet
set -x PATH $PATH $DOTNET_ROOT
export DOTNET_ROOT=$(dirname $(readlink $(command -v dotnet)))

# vi based cursor style
set -gx fish_vi_force_cursor 1
set -gx fish_cursor_default block
set -gx fish_cursor_insert line blink
set -gx fish_cursor_visual block
set -gx fish_cursor_replace_one underscore
