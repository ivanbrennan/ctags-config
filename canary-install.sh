#!/usr/bin/env bash

set -eu

TEMP_DIR=$1

echo "bash ${TEMP_DIR}/ctags-config/install-ctags.sh"
echo "bash ${TEMP_DIR}/ctags-config/configure-ctags.sh"
echo "bash ${TEMP_DIR}/ctags-config/configure-git-template-directory.sh"
echo "bash ${TEMP_DIR}/ctags-config/install-ctags-git-hooks.sh ${TEMP_DIR}"
bash ${TEMP_DIR}/ctags-config/canary-proof.sh ${TEMP_DIR}
