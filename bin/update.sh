#!/usr/bin/env bash
set -euo pipefail

export HOMEBREW_NO_ENV_HINTS=1

case "${1:-}" in
  '') mode=update ;;
  --check) mode=check ;;
  -h|--help)
    echo "Usage: $0 [--check]"
    echo "--check refreshes Homebrew metadata and previews updates without installing."
    exit 0 ;;
  *) echo "Unknown option: $1" >&2; exit 2 ;;
esac
if (( $# > 1 )); then echo 'Too many arguments' >&2; exit 2; fi

command -v brew >/dev/null
command -v python3 >/dev/null
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
work_dir=$(mktemp -d)
sudo_pid=
report_ready=false
stage='refreshing Homebrew'

finish() {
  status=$?
  trap - EXIT
  if [[ -n "$sudo_pid" ]]; then kill "$sudo_pid" 2>/dev/null || true; fi
  if [[ "$report_ready" == true ]]; then
    printf '\n==> Installed version summary\n'
    if brew info --json=v2 --installed > "$work_dir/after.json"; then
      python3 "$script_dir/update-report.py" summary "$work_dir/before.json" "$work_dir/after.json" || true
    else
      echo 'Could not read installed versions; no reliable summary available.' >&2
    fi
  fi
  rm -rf -- "$work_dir"
  if (( status != 0 )); then
    printf '\nUpdate stopped while %s (exit %s).\n' "$stage" "$status" >&2
  fi
  exit "$status"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

printf '\n==> Refreshing Homebrew metadata and formula news\n'
brew update
export HOMEBREW_NO_AUTO_UPDATE=1
brew info --json=v2 --installed > "$work_dir/before.json"
brew outdated --greedy --json=v2 > "$work_dir/outdated.json"
printf '\n==> Available updates (pinned packages are skipped by Homebrew)\n'
python3 "$script_dir/update-report.py" preview "$work_dir/before.json" "$work_dir/outdated.json"
if [[ "$mode" == check ]]; then
  printf '\nPreview only; no packages or Neovim plugins were updated.\n'
  exit 0
fi

stage='requesting sudo credentials'
sudo -v
# Keep credentials alive for cask installers; EXIT always stops this process.
while sleep 60; do sudo -n true || break; done 2>/dev/null &
sudo_pid=$!
report_ready=true

stage='upgrading Homebrew packages'
printf '\n==> Upgrading Homebrew packages\n'
brew upgrade --greedy --force
stage='cleaning Homebrew caches and unused dependencies'
printf '\n==> Cleaning Homebrew\n'
brew cleanup -s
brew autoremove
stage='updating Neovim plugins'
printf '\n==> Updating Neovim plugins (changes are listed below)\n'
nvim --headless -c 'lua vim.pack.update(nil, {force=true})' -c 'q'
stage='upgrading uv tools'
printf '\n==> Upgrading uv tools\n'
uv tool upgrade --all
stage='updating zsh plugins'
printf '\n==> Updating zsh plugins\n'
antidote_zsh="$(brew --prefix antidote)/share/antidote/antidote.zsh"
zsh -c 'source "$1" && antidote update --bundles' zsh "$antidote_zsh"
printf '\nAll update steps completed.\n'
