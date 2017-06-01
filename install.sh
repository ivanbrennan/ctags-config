#!/usr/bin/env bash

set -eu

TEMP_DIR=$1

bash ${TEMP_DIR}/ctags-config/install-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-git-template-directory.sh
bash ${TEMP_DIR}/ctags-config/install-ctags-git-hooks.sh ${TEMP_DIR}

col_green="\x1b[32;01m"
col_reset="\x1b[39;49;00m"
echo -e "Finished successfully ${col_green}✓${col_reset}"
