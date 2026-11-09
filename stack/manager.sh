#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_common.sh
. "$DIR/_common.sh"
export PATH="$HOME/.local/bin:$HOME/.local/share/intelli-shell/bin:$PATH"

# ---- manifest: order matters (gh before arsenal, intelli-shell last) ----
declare -a MANIFEST=(
  gh
  fzf
  pet
  nb
  arsenal
  intelli-shell
)

declare -A INSTALLER=(
  [gh]=install_gh.sh
  [fzf]=install_fzf.sh
  [pet]=install_pet.sh
  [nb]=install_nb.sh
  [arsenal]=install_arsenal.sh
  [intelli-shell]=install_intelli_shell.sh
)

usage() {
  cat <<EOF
Usage: $0 <module> [<module>...]
       $0 all
       $0 list

Modules (run in this order for 'all'):
$(printf '  %-15s %s\n' "${MANIFEST[@]}" "" | sed 's/  $//')
EOF
}

run_module() {
  local mod="$1"
  local script="${INSTALLER[$mod]:-}"
  [[ -z "$script" ]] && { err "unknown module: $mod"; return 1; }
  [[ -f "$DIR/$script" ]] || { err "missing installer: $script"; return 1; }
  info "→ $mod"
  bash "$DIR/$script"
}

[[ $# -eq 0 ]] && { usage; exit 1; }

modules=()
for arg in "$@"; do
  case "$arg" in
    -h|--help|list) usage; exit 0 ;;
    all)            modules+=("${MANIFEST[@]}") ;;
    *)              modules+=("$arg") ;;
  esac
done

failed=()
for mod in "${modules[@]}"; do
  run_module "$mod" || failed+=("$mod")
done

if (( ${#failed[@]} )); then
  err "failed: ${failed[*]}"
  exit 1
fi
info "done. run: source ~/.bashrc"
