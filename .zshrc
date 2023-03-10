# Load seperated config files
for conf in "$HOME/.config/zsh/"*; do
  source "${conf}"
done
unset conf
