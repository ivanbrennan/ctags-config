#!/usr/bin/env bash

set -eu

TEMP_DIR=$1

bash ${TEMP_DIR}/ctags-config/install-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-git-template-directory.sh
bash ${TEMP_DIR}/ctags-config/install-ctags-git-hooks.sh ${TEMP_DIR}

col_green="\033[32;01m"
col_reset="\033[39;49;00m"
printf 'Done %b✓%b\n' "$col_green" "$col_reset"
