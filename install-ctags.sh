#!/usr/bin/env bash

# Multiple implementations of ctags exist:
# · macOS ships with an old BSD implementation in /usr/bin/ctags (1993?)
# · Exuberant Ctags expanded language support, but development ceased in 2009
# · Universal Ctags forked off Exuberant Ctags and is actively developed

set -eu
set -o pipefail

main() {
  printf 'Checking ctags executable...\n'

  if universal_ctags_installed; then
    printf '· Your ctags is already up-to-date (https://ctags.io)\n'
  elif exuberant_ctags_installed; then
    maybe_switch_to_universal_ctags
  else
    install_universal_ctags
  fi
}

universal_ctags_installed() {
  brew list universal-ctags > /dev/null 2>&1
}

exuberant_ctags_installed() {
  brew list ctags > /dev/null 2>&1
}

maybe_switch_to_universal_ctags() {
  if verify_switch; then
    switch_to_universal_ctags
  else
    printf '· Using Exuberant Ctags\n'
  fi
}

verify_switch() {
  cat <<EOF

  You currently have Exuberant Ctags (http://ctags.sourceforge.net) installed.
  This works fine, but is no longer actively-maintained.
  Universal Ctags (https://ctags.io) is recommended.

EOF
  verify '  Do you want to replace Exuberant Ctags with Universal Ctags?'
}

verify() {
  (
    printf '%s\n' "$1"
    read -r ans
    if [ "$ans" = 'no' ]; then
      exit 1
    elif [ "$ans" != 'yes' ]; then
      printf '⨉ Invalid response...\n'
      verify "$1"
    fi
  )
}

switch_to_universal_ctags() {
  uninstall_exuberant_ctags
  install_universal_ctags
}

uninstall_exuberant_ctags() {
  printf '· Uninstalling Exuberant Ctags\n'
  brew uninstall ctags
}

install_universal_ctags() {
  printf '· Installing Universal Ctags (https://ctags.io)\n'
  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags
}

main
