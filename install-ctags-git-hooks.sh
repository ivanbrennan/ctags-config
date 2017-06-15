#!/usr/bin/env bash

set -eu

TEMP_DIR=$1

col_red="\x1b[31;01m"
col_reset="\x1b[39;49;00m"
red_x="${col_red}⨉${col_reset}"

main() {
  echo 'Writing ctags generation script...'

  source_dir=$TEMP_DIR/ctags-config/templates

  envvar_template_dir=${GIT_TEMPLATE_DIR-}
  config_template_dir=$(git config --global --get --path init.templateDir || :)
  template_dir=${envvar_template_dir:-${config_template_dir}}

  if [ -z "$template_dir" ]; then
    echo -e "$red_x No git template directory configured."
    echo '  Run `bash configure-git-template-directory.sh`'
    exit 1
  fi

  target_dir=$template_dir/hooks
  mkdir -p "$target_dir"

  if [ -e "$target_dir/ctags" ]; then
    backup_file="$target_dir/ctags.backup.$(date +%s)"
    echo "· Backing up $target_dir/ctags"
    (set -x; mv "$target_dir/ctags" "$backup_file")
  fi

  echo "· Creating $target_dir/ctags"
  cp "$source_dir/ctags" "$target_dir/ctags"
  chmod +x "$target_dir/ctags"

  echo 'Writing hooks...'
  for file in post-checkout post-commit post-merge; do
    add_or_create_hook "$source_dir/async-ctags-command" \
                       "$target_dir/$file"
  done

  add_or_create_hook "$source_dir/rebase-command" \
                     "$target_dir/post-rewrite"
}

add_or_create_hook() {
  local src=$1
  local dest=$2
  local name=$(basename "$dest")

  if [ -e "$dest" ]; then
    if ! contains_match "$src" "$dest"; then
      echo       >> "$dest"
      cat "$src" >> "$dest"
    fi
  else
    touch "$dest"
    chmod +x "$dest"
    echo '#!/bin/sh' >> "$dest"
    echo             >> "$dest"
    cat "$src"       >> "$dest"
  fi
  echo "· $name ✓"
}

contains_match() {
  local subfile=$1
  local superfile=$2

  [[ $(<$superfile) = *$(<$subfile)* ]]
}

main
