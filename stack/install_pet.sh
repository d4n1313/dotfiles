#!/usr/bin/env bash
set -Eeuo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

if ! have pet; then
  info "installing pet"
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  url=$(curl -fsSL https://api.github.com/repos/knqyf263/pet/releases/latest \
        | grep -o 'https://[^"]*linux_amd64.tar.gz' | head -1)
  [[ -n "$url" ]] || { err "pet release URL not found"; exit 1; }
  curl -fsSL "$url" | tar -xz -C "$tmp"
  sudo install -m 755 "$tmp/pet" /usr/local/bin/pet
fi

fetch_config "$DOTFILES_RAW/pet.toml" "$HOME/.config/pet/config.toml"
ensure_bashrc_block
