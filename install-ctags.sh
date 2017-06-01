#!/usr/bin/env bash

# Multiple implementations of ctags exist:
# · macOS ships with an old BSD implementation in /usr/bin/ctags (1993?)
# · Exuberant Ctags expanded language support, but development ceased in 2009
# · Universal Ctags forked off Exuberant Ctags and is actively developed

set -eu
set -o pipefail

main() {
  echo 'Checking ctags executable...'

  if universal_ctags_installed; then
    echo '· Your ctags is already up-to-date (https://ctags.io)'
  elif exuberant_ctags_installed; then
    verify_upgrade
  else
    echo '· Installing ctags...'
    install_universal_ctags
    echo '· Installed successfully (https://ctags.io)'
  fi
}

universal_ctags_installed() {
  brew list universal-ctags > /dev/null 2>&1
}

exuberant_ctags_installed() {
  brew list ctags > /dev/null 2>&1
}

verify_upgrade() {
  cat <<EOF

  You currently have Exuberant Ctags (http://ctags.sourceforge.net) installed.
  This works fine, but is no longer actively-maintained.
  Universal Ctags (https://ctags.io) is recommended.

EOF
  if verify '* Do you want to replace Exuberant Ctags with Universal Ctags?'; then
    echo '· Uninstalling Exuberant Ctags...'
    uninstall_exuberant_ctags
    echo '· Installing Universal Ctags'
    install_universal_ctags
    echo '· Installed successfully (https://ctags.io)'
  else
    echo '· Using Exuberant Ctags'
  fi
}

verify() {
  (
    echo "$1"
    read ans
    if [ "$ans" = 'no' ]; then
      exit 1
    elif [ "$ans" != 'yes' ]; then
      echo '⨉ Invalid response...'
      verify "$1"
    fi
  )
}

uninstall_exuberant_ctags() {
  brew uninstall ctags
}

install_universal_ctags() {
  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags
}

main
