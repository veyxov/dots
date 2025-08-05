source ~/.config/nushell/zoxide.nu

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.local/share/atuin/init.nu

alias n = nvim
alias s = ls
alias g = lazygit
