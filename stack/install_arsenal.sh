#!/usr/bin/env bash
set -Eeuo pipefail
. "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
have arsenal-ng && { info "arsenal-ng present"; exit 0; }
sudo apt update -qq && sudo apt install -y arsenal-ng
