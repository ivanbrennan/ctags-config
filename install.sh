#!/usr/bin/env bash

set -eu

TEMP_DIR=$1

col_green="\x1b[32;01m"
col_reset="\x1b[39;49;00m"
green_check="${col_green}✓${col_reset}"

bash ${TEMP_DIR}/ctags-config/install-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-git-template-directory.sh
bash ${TEMP_DIR}/ctags-config/install-ctags-git-hooks.sh ${TEMP_DIR}

echo -e "Finished successfully $green_check"
