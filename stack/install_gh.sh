#!/usr/bin/env bash
set -Eeuo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

have gh || { info "installing gh"; sudo apt update -qq && sudo apt install -y gh; }

if [[ -n "${GIST_TOKEN:-}" ]]; then
  info "authenticating gh"
  printf '%s\n' "$GIST_TOKEN" | gh auth login --with-token
  gh auth setup-git
elif gh auth status >/dev/null 2>&1; then
  info "gh already authenticated"
else
  warn "gh not authenticated; export GIST_TOKEN and re-run, or run 'gh auth login'"
fi
