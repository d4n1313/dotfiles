#!/usr/bin/env bash
set -Eeuo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
have fzf && { info "fzf present"; exit 0; }
sudo apt update -qq && sudo apt install -y fzf
