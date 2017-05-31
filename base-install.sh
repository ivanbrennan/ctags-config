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
      echo "Usage: $0 [-g|--github-host HOST]"
      exit 1
      ;;
  esac
  shift
done

GITHUB_HOST=${ARG_GITHUB_HOST:-github.com}
TEMP_DIR="$(mktemp -d -t ctags-temp.XXXXXXXXXX)"

trap 'rm -rf "$TEMP_DIR"' EXIT

echo '### Cloning installation scripts'
(
  set -x
  git clone \
      "git@${GITHUB_HOST}:ivanbrennan/configure-ctags.git" \
      "${TEMP_DIR}/configure-ctags"
)

bash ${TEMP_DIR}/configure-ctags/install.sh ${TEMP_DIR}

}
