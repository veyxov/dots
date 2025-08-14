$env.config.show_banner = false
$env.config.buffer_editor = "nvim"

$env.DOTNET_ROOT = '~/.dotnet'
$env.PATH ++= [
    ~/.dotnet/tools
    $env.DOTNET_ROOT
]
