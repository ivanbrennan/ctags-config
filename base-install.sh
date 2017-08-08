#!/usr/bin/env bash

set -eu

{ # Prevent execution if this script was only partially downloaded

while [[ $# -gt 0 ]]; do
  case $1 in
    -g|--github-host)
      ARG_GITHUB_HOST=$2
      shift
      ;;
    *)
      printf 'Usage: bash %s [-g|--github-host HOST]\n' "$0"
      exit 1
      ;;
  esac
  shift
done

GITHUB_HOST=${ARG_GITHUB_HOST:-github.com}
TEMP_DIR="$(mktemp -d -t ctags-temp.XXXXXXXXXX)"

trap 'rm -rf "$TEMP_DIR"' EXIT

git clone \
    "git@${GITHUB_HOST}:ivanbrennan/ctags-config.git" \
    "${TEMP_DIR}/ctags-config"

bash "${TEMP_DIR}/ctags-config/install.sh" "${TEMP_DIR}"

} # End of wrapping
