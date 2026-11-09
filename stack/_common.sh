#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
. "$SCRIPT_DIR/config.sh"

info()  { printf '\033[1;32m[+]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
err()   { printf '\033[1;31m[-]\033[0m %s\n' "$*" >&2; }
have()  { command -v "$1" >/dev/null 2>&1; }

on_err() {
  local code=$?
  err "failed at line $1 (exit $code): $2"
  exit "$code"
}
trap 'on_err "$LINENO" "$BASH_COMMAND"' ERR

fetch_config() {
  local url="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  curl -fsSL --retry 2 --connect-timeout 10 "$url" -o "$dest"
  info "config → $dest"
}

ensure_bashrc_block() {
  local marker="# >>> pentest-stack >>>"
  grep -qF "$marker" "$HOME/.bashrc" 2>/dev/null && return 0
  cat >> "$HOME/.bashrc" <<'EOF'

# >>> pentest-stack >>>
export PATH="$HOME/.local/bin:$HOME/.local/share/intelli-shell/bin:$PATH"
command -v intelli-shell >/dev/null && eval "$(intelli-shell init bash)"
# <<< pentest-stack <<<
EOF
  info "shell block → ~/.bashrc"
}
