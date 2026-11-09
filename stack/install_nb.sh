#!/usr/bin/env bash
set -Eeuo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

if ! have nb; then
  info "installing nb"
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://raw.githubusercontent.com/xwmx/nb/master/nb -o "$HOME/.local/bin/nb"
  chmod +x "$HOME/.local/bin/nb"
fi

if [[ ! -d "$HOME/.nb/home/.git" ]]; then
  info "cloning notes repo"
  mkdir -p "$HOME/.nb"
  git clone "$NOTES_REPO" "$HOME/.nb/home"
fi

ensure_bashrc_block
