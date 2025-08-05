$env.config.show_banner = false
$env.config.buffer_editor = "nvim"

$env.config.history = {
  max_size: 0
  sync_on_enter: false
  isolation: false
}

$env.DOTNET_ROOT = '~/.dotnet'
$env.PATH ++= [
    ~/.dotnet/tools
    $env.DOTNET_ROOT
]
