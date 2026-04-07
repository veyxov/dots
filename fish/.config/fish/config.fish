if status is-interactive
    set -g fish_greeting

    zoxide init fish | source

    fzf_configure_bindings --directory=\ce

    alias d="z"
    alias n="nvim"

    alias nd="zi"
    alias fl="cd ~/dots && lazygit"

    alias g="lazygit"
    alias s="ls"
end

set -x DOTNET_ROOT /usr/share/dotnet
set -x PATH $PATH:$DOTNET_ROOT:$HOME/.dotnet/tools
set -x PATH $PATH:$HOME/.local/roslyn/lib/net10.0/
set -x PATH $PATH:$HOME/.local/roslyn/content/LanguageServer/linux-x64/

# vi based cursor style
set -gx fish_vi_force_cursor 1
set -gx fish_cursor_default block
set -gx fish_cursor_insert line blink
set -gx fish_cursor_visual block
set -gx fish_cursor_replace_one underscore

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
