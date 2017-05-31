#!/usr/bin/env bash

set -eu

TEMP_DIR=$1

bash ${TEMP_DIR}/ctags-config/install-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-ctags.sh
bash ${TEMP_DIR}/ctags-config/configure-git-template-directory.sh
bash ${TEMP_DIR}/ctags-config/install-ctags-git-hooks.sh ${TEMP_DIR}
